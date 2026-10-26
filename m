Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7856D60A2614
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 16:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=iEFBSj+M
Received: by kanga.kvack.org (Postfix)
	id 95C8E6B05B1; Mon, 26 Oct 2026 12:01:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 933746B05B4; Mon, 26 Oct 2026 12:01:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 822B76B05B7; Mon, 26 Oct 2026 12:01:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A9006B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:01:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AC1F51A0593
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:01:30 +0000 (UTC)
X-FDA: 85365242340.04.343B177
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id 68075A0020
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:01:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iEFBSj+M;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793030488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lbo8/RDQClorc6ph+pAnOkCeZrLNCxChHhQRvs8O+J4=;
	b=DxjYu2LE2lczG/e+SUiSdv/vw445BZ6451IRe1l167uUF1dedGPNnUXhtUr2pTpmxCcHOw
	wKasNg2Nl24EER0a8RRnZN77sAWoAjp5Xdw89LLobRBqwNd+QW8uPpII1D0fCsGQJK0NLz
	mgdV+4RqCpLvQf7ckjlyDuHnuEFYWMg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793030488;
	b=2+LBKKC3azLLZWsOmPk2EfMv/aXKeKoSTkPyj/CcmH5D64pfQrPxj8YIG9gfjlv+psdxtC
	WQ1ryXA8l0h+3f9MuQi22FDigXVfiRAD/WgVkb7VkIaR/O9nsg6UP+KSJSajUCT60wof9A
	+IkN27VTI8NTK9zHMvqutr2nOGej5lw=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iEFBSj+M;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48e47347279so1139774f8f.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:01:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793030487; cv=none;
        d=google.com; s=arc-20260327;
        b=NMcWYq93qz6hIZMN6QmYthZL1HzgQq48t/wBMuOk18Gte8hov0Ns2G6cMHzZKS8BSL
         JJZYbggpSJmeJbp60EJFKIQXdXujpMn/367/2OeIbT6my3T22mv9V2HnZsKQzUi21vtW
         Glq1yvrcWi9t6U3FwrtvMcFxRb0OxEDOBkp2mV74+du+7SSvcOp2yjTCbWvqpnhQdkb7
         DNss7velpvc56VYhhmVEicCJWXXOeX7EbMWoyvd1TaXLxaxyxwpvWOEWPMzy37lLV0wc
         7uigQ7gMfFa7XRd7oA51VG+eMxkZ8d9yZqVlsEml80k+t1WWpW4OeZ0kKvLxc8CrXIW5
         yUuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Lbo8/RDQClorc6ph+pAnOkCeZrLNCxChHhQRvs8O+J4=;
        fh=qKy8yOHp3f8vGohPqY9gw9GLr2nORV0rEJPQoa67kPE=;
        b=Vyx/p2TWuElqThGE9MLUv+nCu/42vpV7gW1csE5dgBSP7ZMpxis7T6DaamSK7r2/Qq
         kob9qC0xDiB9zyxOSGsUeDk9KXC/B5z3Amc26ckG26JGh+Cnp5lSeEi3GM7UZGl8XTC7
         5E7cGzC8mWZhn7yRB7Sakscp4hR0bGZ6x1Zt+ZGF4xath0TZUqNDlUZQHffrHiHbcbbU
         QGzajpxYGfQLoeKIMCTIfzv0XTdLIAXublsrjDJgSE1OkWZ1N3o0rCpsGxW+c3w49EmI
         FqTA3ZF2u9T9fuQVWtVuVxvkBQWhs+4W3pb9PEpI5oNZO/TifsEHlipNJHp+pyXWSWcV
         L12A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793030487; x=1793635287; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Lbo8/RDQClorc6ph+pAnOkCeZrLNCxChHhQRvs8O+J4=;
        b=iEFBSj+ME0lxS46LnN10b2uCGBV27n3py6IeiK2VVPEeuXu98xbvFKF9Ry9QmzNO8P
         HCAK6NauLd4MwLLf9HcWEavYE3Bz9/ZBpO2H3N1gj4fyjuimjsQdC/EOIyq7W08M0XUv
         wCpBV4Ij9OpzEOrehGyJv8D01TVde9X/Cz8FPYD/QUjnMy6JgAMzpzSN5MKkFAV0tWKw
         MLlrjAvSThkug75SOCCV+jw0AS6VFKaFlzWMyOFI2FRPaz9BAML31JcD47KdgP0JCdE0
         gGmrg3E5vL7Ce+HXSxV+uvMw07J8lGI1XqOtKlPRWCqsymiavFYPSiwO+DahzgberSAd
         FEOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793030487; x=1793635287;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lbo8/RDQClorc6ph+pAnOkCeZrLNCxChHhQRvs8O+J4=;
        b=HHLEW1/UPpHUCvc5gERSi8jpAFWS6OB6V64YyeTguDWp08koQXTSv7xxjLSR5oEg3G
         ALwLfZkQkPKa7qpNcuJlZW5SXXC7/rBowg978SYY4Ex4Mo4KtZqizpnyoQrJg61rQAma
         6BBFFgaVpCaDtujtqTWM7LtrcPJcVPGMSA5im/9Qp7m/6LMfzyRiI6iaeyQxbm8gJU3a
         hdzo0Rm1hM9hCA/TP09x+LoSSvXTex/P+HjF7QtkB1WLBrfG8XMI2wTYqKS4GFH5m+2r
         ZsclC0DSbjZNBkV+GEc8SIAXrdZn6yJ92FuQ/tXd4bWm0HwgD1bUkYmtghKzWtoxS9Zb
         l7TQ==
X-Forwarded-Encrypted: i=1; AKwUvBw97P+RArr7ii0oMz9xTLqyj4jN7BkszMch+pkNTfOOb7RtlAVZcPMhfVDexX1JX4uSFktEkhu6tg==@kvack.org
X-Gm-Message-State: AFq9FYI0I8Wz4TF+QzNgfWidWA/SpRcGO97HjQh1iV7itRR829Vs59b7
	grkODtFUu0XhmpcO30OpKe4XQsaAdPBVW5Q3JYEJ1CNFdwfGfA3Ace71KsBd+1EWEjVTV8G3Vh/
	GXps+IE/uYejK41QmBFcCKY7p2o7D4PU=
X-Gm-Gg: AYBFou0Uqq9O+3JQiOczmadxyIgUWVlKuBEED1yIyVI3ZsG2LrcGgm7Yt0MzkdJIPvV
	X/aT4D1GJlb+wCXL1k5X3qAWhlL1wqz3wVEvqnJeI88LTaD5Ls8eMHm+OaKfrj+kG0UTgfg0y6R
	CMLGMpRWPHTDSnVkg/soeG10cEPPjTaP6ushK9iZQNMCsrQMHvyfIstvz/c6amoN0ve6sw7BJuU
	GMvPZFus1jGK9YhwWeRMRV4+6OADTfQVTfqZl5YxHLj3Z3x860IjqVXE7tRHi/o2vC9TJuyETNR
	pHuePkkj4GZYw6EAbCHFDIKuNDxEjzSH0BhYZcpHb4mCQv/3Ul+cDhmWM2RgwCudOsBSNb80PiW
	zIbxiChEDLuDz7t2dxb3za5ej5nNoTBHFqId5OHrcKjHV9FGO9P+FJ7nl1cfAIhIylRUqOgfDb/
	vNrVqJWLt6yOUBw0DmRD9MsIhBpNvSc9681u/HSOCaQpj37FY0ah5n
X-Received: by 2002:a05:6000:2489:b0:48e:25e1:5eb8 with SMTP id
 ffacd0b85a97d-48e3eb2cea4mr13577585f8f.3.1793030486487; Mon, 26 Oct 2026
 09:01:26 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org> <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
 <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
 <c6e62e80befa886fccd36d34a39cf56ea5b9c9c2.camel@surriel.com>
 <CAMgjq7CN7qTes+OXvCfsgPOnbtyY7YPytTEP3zZJTBxrGZ5JnA@mail.gmail.com>
 <12081d266e4846f23faacfc65c7be7da4ed013a9.camel@surriel.com> <CAMgjq7Cjt==BxXPNw5HjiA0hjxhfzWn=9gDQ+2x-rdrEQBWTeg@mail.gmail.com>
In-Reply-To: <CAMgjq7Cjt==BxXPNw5HjiA0hjxhfzWn=9gDQ+2x-rdrEQBWTeg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 26 Oct 2026 09:01:14 -0700
X-Gm-Features: AclHuK_CEYsPKY6hq0opM-Cj8xQh0uLfbNs1stTtcOkUahfkClQYL2L3gwCISqY
Message-ID: <CAKEwX=P_3W+MAFe80MZ5FT0mytv-UDzfmbyBiNsYR5XjC5emSQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Kairui Song <ryncsn@gmail.com>
Cc: Rik van Riel <riel@surriel.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 68075A0020
X-Stat-Signature: xywe8rr1nfmpfsrnpnjbm5h5bk5w6akg
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793030488-303845
X-HE-Meta: U2FsdGVkX1/7duzvhhdCtLw4kj4wj+mqXdWtXgklG4jldjGfGE/WyuRoS59x2VQEj0W1UIWJ+zqQnljeW89ZG7L28xkYB86szcrhZhSwL1oF7QGDH/296i6X0O/Nv1fqClt8aod2pMcXee4snTOLRdZP2YREdT2a+udUtNj8g80mF660epp7TlUlgv80B7mPb1fTNyawsIeua2Ov7vYJ3DMs+tvXkOC8jmyb62ZHJ5/G6VS01CxkJMUqL68zByzZsE5ZkNMRtyzG5z1C9TeoyjpJHQ6RXBZ4zRvfNP43GkxeQDCTzGLPELwmzqaqyJRe6+90izdiCerbbNEdChKxeNwePAei7s7bs4UDUJ+axxkX2M/ZFDXhlgKEDylemr37Zs0MIDfBAbNuKz8bozcctA9zwms7nxRJ7ef/YrEsFhvEWwhlyXdTb4BitnMLn5ttP6zJNHnGCqaeJe9/LuRMjypWkZ5utfkb8MMwmJbBKkQuZ7NaF74PUHcfAtNacq2ZCzam2HymTZUuQJpEBZICnCC7SPFsxVAmNrvPfkylM61bLsuN5D8EZc96D3agbqhOdbkL2CfjTgx9yJJUlNkA4T/yXDV9Q9pxLWPqzKbFdCpRX0AMsdoiYz660C35ubSv7g/4yXVl3DqWBGV7egZ7RkMTIZZqEaXkKaosWAKif16JSuvpVIufvIjnpS757qR+3BW5PcXIso3IYSRwE3NeQDQMPhik49vUwI68QJPDsiWtjgQse0SO+CqvJrH9pF6eC/YhOCPyUXCVXFbL+4cp5LOL6KTzow8K7LUZhOyclHneMkXGPCRBmWIQ7rzOE4G12znacD9j0HOKlhuvNnesCztZHxfF/EHOkJ8s2/ftAL6+1N9XEeNYuKgtyyfFXgGHUaPBfEaBDVKmRF7tpdGlt+mis4gb8IsiTpnwoj1EYptGqagn2LvlzPp004C7SiDQZtY63WPwFeYnv+DMWCL
 0H6O8Ubj
 LNOiZxO/Jftnd/HdodkmNpXsWSUg8H2RAwKt2zkG9emrh9uiv7ARD6LQiZQWt8Bnh3/3SEPRBiPTs/+dOTHa8spoeqN9BN+fcwkbwPCMP2nf+qSKcIJM2SOP/NM7jbasYdluiqUzHP06YopjwunyVofCIoAwwQbyUC+4u4qjYCneXPQ5ovgTI81SHNdc/uv/lW9xB+/kZhxKY80LNHthUM6HS5/srAUeJciwcW/QPfJO2DUJKc5hddQZvks2UGrKENHz6TEIpvFOjGNM4qsbB+fpxrqpzO5rVR87PtHyM/eXbN8bG7TOjyqHXfV/fatZxV2V1PumU6FSmZMHiQNyQT2WmBt8iv8SIJSQ+3DriXZtaq8ub1i2yT7KMEGFoPaIMUpaoyznzPWuDO8N2WNpn2I7hTTHRl+0HK0D5EpbYqoMU2c2nIJgcWD5xAKLNrVB2bqt4aIohv5Pod/uLwYKKy9m7xVzzyNcw1F7dcIBBKsTpqycN+UiRLslOR3hRAgRivkpkPW3UAcZgYQipyekGbh5pi3t32tErB0kXhxANp0olssdUx6suqrxwIciNdEWwuRmQffdP13e/TP6g/CwzoZVh4o5rrMbb3dnChcj1xLlPJuu3OSCbaS54aQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 24, 2026 at 9:22=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> Rik van Riel <riel@surriel.com> =E4=BA=8E 2026=E5=B9=B410=E6=9C=8825=E6=
=97=A5=E5=91=A8=E6=97=A5 02:16=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Sat, 2026-10-24 at 23:50 +0800, Kairui Song wrote:
> > > On Sat, Oct 24, 2026 at 4:03=E2=80=AFAM Rik van Riel <riel@surriel.co=
m>
> > > wrote:
> > > >
> > > > On Fri, 2026-10-23 at 10:24 -0700, Nhat Pham wrote:
> > > > >
> > > > > * Swapoff: this was brought up as a request, but we ran out of
> > > > > time
> > > > > before we could discuss the motivations and use cases behind
> > > > > them.
> > > > > Folks interested, could you explain as a follow-up?
> > > >
> > > > This is one that I really don't understand.
> > > >
> > > > In my mind, we have vswap sitting as kind
> > > > of a swap VFS between the rest of the system
> > > > and the swap devices:
> > > >
> > > > +-------+     +------------+
> > > > > vswap |-----| swap cache |
> > > > +---+---+     +------------+
> > > >     |
> > > >     +----------+-----------+
> > > >     |          |           |
> > > > +---+---+  +---+---+   +---+---+
> > > > > swap  |  | zswap |   | zram  |
> > > > > file  |  |       |   |       |
> > > > +-------+  +-------+   +-------+
> > > >
> > > > When a page is unmapped from userspace by the
> > > > reclaim code, it goes into the swap cache.
> > > >
> > > > The vswap layer then decides where to store it
> > > > at eviction time. This is configurable by userspace.
> > > >
> > > > If the zswap pool is shrunk, the vswap layer knows
> > > > where to put the data next. There is no need to
> > > > change page table entries to indicate that the
> > > > data was moved from zswap to a swap file.
> > > >
> > > > If we decide to disable one of the backing swap
> > > > devices, the vswap layer can just move the data
> > > > into the swap cache, and the page reclaim code
> > > > can evict it into a different backing store, if
> > > > needed.
> > >
> > > And in this case we want to disable vswap itself.
> >
> > OK, so you are looking for a way to totally depopulate
> > the swap cache, in addition to swap files, zswap, etc?
> >
> > I think we can accomplish that by simply keeping the
> > current swapoff code around, which scans through the
> > virtual memory of all processes and brings the memory
> > out of swap.
>
> Yeah, that's the right starting point. The scan itself can also be
> optimized to be cheaper or better later on, but that's orthogonal.
>
> > > I also hope there is a way to release swap metadata completely too.
> > > e.g. for fs, you at least have umount, and can rmmod the fs itself
> > > afterwards. We also have many ways to bypass the page cache. In cases
> > > where a virtual layer is just a burden, we want raw physical swap,
> > > and
> > > the ability to swap off that too.
> >
> > The VM cannot operate without the swap cache, though.
> >
> > That is very much built into core parts of the VM.
>
> I never meant to strip swap cache out of VM... The opposite, actually
> :), most of my work over the last couple of years has been about
> removing the paths that bypass the swap cache (e.g. the
> SWP_SYNCHRONOUS_IO fast path), to get a simpler model and better
> performance.
>
> What I'd like is for swapoff of the last swap device to return the
> system to its pre-swapon state: no leftover swap metadata, no leftover
> per-slot or per-cgroup data or statistic, and ideally no residual cost
> in the fast paths (e.g. minor fault).

So basically remapping? I don't think that's terribly hard to do. I
mean the swapoff code is still there, so it's just the question of
exposing an off knob, basically?

But wouldn't MADV_WILLNEED be the better tool here? Or is it not reliable?

>
> > However, having swapoff remove all data from the swap
> > cache, after mapping the memory back into userspace
> > page tables, seems like it would be fairly easy to do.
> >
> > Does that meet the needs of your use case?
>
> Right, it's nothing hard, as long as we don't add mandatory new
> layers. For very high bandwidth swap devices, a mandatory indirection
> layer is pure overhead. I posted a per-CPU queue based allocator for
> that case (https://lore.kernel.org/linux-mm/20260829-swap-pcp-priq-v2-res=
end-0-68d3d925578c@gmail.com/).

I skipped non-zswap cgroups for now, so there is no overhead :)

We can revisit this once a new feature is implemented (and we can
figure out what interface is best for this, or can the kernel figure
this out on its own).

