Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 606E1606A31B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 09:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jilo8k6Z
Received: by kanga.kvack.org (Postfix)
	id 5246E6B048F; Wed, 21 Oct 2026 05:42:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D5366B0692; Wed, 21 Oct 2026 05:42:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4076B0693; Wed, 21 Oct 2026 05:42:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DA5A6B048F
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:42:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 741451C3C33
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:42:26 +0000 (UTC)
X-FDA: 85346143092.10.5277397
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 73F2E1A000A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:42:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jilo8k6Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792575744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8G57XmwynB3mR6uqi8qOOjUgqBbEb9SN5unyoR6cdBc=;
	b=uLsjbgvqQ//TkRC5GPJQ38dDkD9EUAnEdQsYTtSih9YJEggY2XDE4kR/sxv3hs6vNwi6q0
	XmTbufYO+oGrTKVvjrOeMKo9/VCmb4V3aPUrIE2xIKq9bg6eaB0jXHgdhixFWj4yWfEz64
	ejKIHBQqUwrwqzabHz/SBJQsN8Lhwck=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jilo8k6Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792575744;
	b=Cef46OYRt2/pbNFCfCPzafrcNBymkMd0by8tjeBapbP+qUrLzZt7pNtFy0ypSGbN9GLdm/
	NoU5yJ4GNDNLamCDpPmrr1dSJTQTSbHd76GsWGVXGkqfTfPPk7xd/4Jm1MfojlBb65UU2Z
	KX/kjj1i4Y+A4wVaL/JfUzRUwDAFYVQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A881844415
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843611F01576
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792575743;
	bh=8G57XmwynB3mR6uqi8qOOjUgqBbEb9SN5unyoR6cdBc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Jilo8k6Z5wiwnrH4plvBWdxS8RtonTg/JgZofxZHOOXxDzU8nFF6LsmfOjOgIikTC
	 ddSVsbXALA+BsGCsSOppLQ1BdnD88owUzKlN5rY/DiDqEDmwS/VDJwB72CUkL/fyMQ
	 PJrxg8ms6x11WCb1ryTiPltSt+QYeAJinNHVpecKVCgqjy0sLMiGx0k83cJp4orDEp
	 hK0DW/3Outxkn2sdWPm1l2a78M+rTs1KFy5r09Ww5R2lbukzefQyRt1v5+2EpLBSWR
	 vBTcsrTQCio72mFDkCi47TM96QapYh9ntgmQ1KL20OFcxyFdJB/xT2e2cNsvt9h+gq
	 vofQPTxDvMP2A==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-93f20b304c0so60390585a.3
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:42:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy2lgNwsMsphoJhh6xx5RjfTszWyLD/pc9AoE5pFoK919CWIKn6Tx4uqjnIWUhWqk3N34TJr6NmqQ==@kvack.org
X-Gm-Message-State: AFq9FYK7yYVgEUzz97ki6ty3W6WJFHNBxCbkoXZUWm/brQ2fesprc03K
	j2QQubKv/4xW95GXUVDJ3p1IJJX3dxIg2l8StL7ffuu4KWyXUrhX7BVwIRX0qXnHM5G5/JgkDY8
	woLCaLITWUxdabkL4La/MmC8SSt3pyxE=
X-Received: by 2002:a05:620a:40c1:b0:93e:6283:eba6 with SMTP id
 af79cd13be357-93f57f1cf03mr308028285a.38.1792575742833; Wed, 21 Oct 2026
 02:42:22 -0700 (PDT)
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
 <CACePvbVbMPZTrD5y=--XgBS+sa4CHb7e4RFTYCbWfzHzVc3vXA@mail.gmail.com>
In-Reply-To: <CACePvbVbMPZTrD5y=--XgBS+sa4CHb7e4RFTYCbWfzHzVc3vXA@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 21 Oct 2026 17:42:11 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w0A_xwGZrhZWqUB1Csj1QsMx3VzjwKuSSrP0ajymCw=A@mail.gmail.com>
X-Gm-Features: AclHuK-Lnt40pgtt6cgtli_2uN4Jy8RyL6YrVOTjl81POv4J0v-Ixt1q8_SZhk8
Message-ID: <CAGsJ_4w0A_xwGZrhZWqUB1Csj1QsMx3VzjwKuSSrP0ajymCw=A@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>, 
	Kairui Song <ryncsn@gmail.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 73F2E1A000A
X-Stat-Signature: mbkuea4q1xne38aeimiwoty5n441qs84
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792575744-303487
X-HE-Meta: U2FsdGVkX1+avINIA36KnBKmAsBP1e5LGozY8M/39SwMYZWtseSTJJU5VfF23yfQhWP2pE0lhU5L5K/rJa0zcXbw72/z+XQqCU+r+m1UMElPk44i//iK4CIvAJbkup3kl8Cdp4yL8AbwAX+8kHjsLStufR1fuHlV/U9aU3ns8Ia9YmFW0NujkVS8GpPvpRrPNqnJDmRxy5I6HcDaQZD6CF0RaiKOP0yfAksNr3KkvYbNrvLAoCJ6cjLk7ReRQkCI/3aXLbRTEZF8y+Gqp+VE0LJJAKZKo3bjWQPX5VlkwY7IDp6dUuHtP1HbflSSGWIsKJakalkXJC3p7hdxWExDewntqvx3VwcLkcp8fhtUdFnnMaApKyqz7yUejCHsvFnEbQe//npiYPgZdRMFZfOrolxo+6USV8iECHdZRmNO08TiIiAOLN1zffxQKx8XMPiXnoixgwQhjfYf18WIiZaCsGzRuT5D999YwVknwSe57QHqz/H+CAyKy0EgS0IPAaJnnXIKw1AyjFVItEzBncpKathC83zp/Grfw3QRw+FPEvKMq05XtODvGxwh8Nc5Mu4u3wy/MIUoY1HPgjweWObfS2kvpcTDDiCYm/E5GjC/bvKrAyIl3CP4x4CuKYY7u7v9bcPPbS7TLZOLlk+iSR2huYsYSG4TJkVd8SFd/bL+nrpmZ6epi0AH+mlje0rF+4FsmEWQCW/2N3IEzUAB0tBxzX9j3fFQ+xheIdQ8ecmiz0TuKHJJzQs0S/656/EjumMk1/AGIPFcyM37HMMmFEG1C6tMpaJoOhke9meXRZQB+TgMZkAO9vXlV0kt/34G3qPtDUtVHSeNoIaDlxk1ME8gzgLSryoqpBypsfvGBod8VkCHEVgdaGGbw/dy3F1xX0BohHT6dn1ML+ttvRODPVby/fJYGqPfrcI2q0+W2mmyjfeU2HVPgEUBFi7O/t26b89D5cOf0p1QJXXNZiXh7rJ
 4Y7vRvOC
 2JKvx2ZvHoH8tb0L2PF7/Nlmz1D+QMd3Tuo5sF8aFeg2yAprLu8u+8avc7+BpcMC2LR2eZZwsvt6oQfL1iJPa2g6wh9ocBhhDl8ZYUgaGqCxQ3eHo9tQAnn6CmAKJ7nE/FXe5wqS4jUUq6tVcXu905vx/Iskf1/bQVbW5e7d7BF2fnih07DzjpP8YkQr7bA+Lx15F3168dANlqstHNejDTPBSIE131HUqdsiHeGQV41AbG4ZAXsGXyCp/Rj1CYZO6uVJYRqH3Fxu8DJnOiIGBCQhPJgY+awpYTyoDTkouzpw7gWH+QJwQ0cTkpyrTZk2z3vHJAh7P/akUVzFxIdOa9N4IPZ8HLh+MEME9EufF4mFQEWEmubYxE6W2pQGUky4DtVFyiRfX2FHxPpWH7bmMH6LJgm3ZQYeyjGV5QdQ48MdB8tvvNxUVefkRkrXJ6SCIkn0t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 3:41=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Mon, Oct 19, 2026 at 5:35=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Mon, Oct 19, 2026 at 5:28=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> > >
> > > On 10/19/26 14:24, Nhat Pham wrote:
> > >
> > > I'm traveling this week, so it's a bit tricky. I cannot make Thursday=
 morning.
> > >
> > > On Thursday I'll be traveling back from Cambridge. But hang on.
> > >
> > > My plan lands on Oct 22, 11:10 PM. I should be home around Friday 1.3=
0am - 2am.
> > >
> > > I could just naturally join that day.
> > >
> > > So one day later would work for me.
> >
> > Would that be too rushed for you? :)
> >
> > For everyone's convenience, this would be the time slot:
> >
> > PDT: Thu Oct 22, 5:00 PM
>
> Works for me :-)
>
> > EDT: Thu Oct 22, 8:00 PM
> > Europe: Fri Oct 23, 2:00 AM
>
> Ouch, David. If you commit to that, I understand it is very
> challenging. Thank you for taking one for the team.
>
> > China: Fri Oct 23, 8:00 AM
>
> Other swap developers: Kairui, Baoquan, YoungJun and Barry, when you
> have time, please comment on whether you can make the meeting as well.
>

I will be glad to join.

Best Regards
Barry

