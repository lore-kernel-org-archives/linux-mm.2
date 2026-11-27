Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DA3D606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 02:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=maLX34fv
Received: by kanga.kvack.org (Postfix)
	id BF7CA6B05B0; Thu, 26 Nov 2026 21:21:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8F16B05B1; Thu, 26 Nov 2026 21:21:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A743D6B05B2; Thu, 26 Nov 2026 21:21:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 81A246B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:21:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 60469C0178
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:21:25 +0000 (UTC)
X-FDA: 85479297330.25.6228F1B
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id 59C8780008
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:21:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=maLX34fv;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795746083;
	b=dG3yOv2egAGAgH9tHYZkl5GKBiaFXJ9PYWGmNmAxRgffTAAjrQFgTKu89NImqd4J5Yi6gm
	gkxXtLWAo+WBbXmjeMFGoU9TpMv3lKoMWCIGKpaKDDll0Bvz+KWQaHM8x8zDjhIW1ePH6D
	R8oxVO4QAF4+yILqvz0LqPUsrwS9T78=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795746083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q9O/QDigxPlmqtrzg+lI27H9LnqU5X97nUid93qpMQw=;
	b=3wSQbKa2PcOwA7EGs19ZgTga27p1mZ68mDY0Kzf8yM8K2UMeHl8Mvzozz3qkPV8lQYk6Z9
	FMtZusx4Qf8r+JR6fshcsIEdFGPWZ27HF4bOl9zKcWgc2+mVCuVF2PkDjFKIW9ZVPkv7Zs
	bc3mBPSpuiDv9jSYZrFxn2djQMq6rK8=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=maLX34fv;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c4cac7a7d3cso1128095366b.3
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:21:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795746082; cv=none;
        d=google.com; s=arc-20260327;
        b=KS4/OXkwsRcpsRRYYrw24ui20qJ3xULdWCVPRpfCxkdmHjwjj7uHj42IT0aDK3hGpE
         /Ydw0uSnHp5IrHhmewd3tfPfJy58JhbO3JSHJN997vMKodbM3kwfrQXOxT4AApHuIGuX
         UYuyrcu3NiGJjot2DpPwv4n+9LowlrFW5JXHm2KqswEEGF7iRzph+cPktkzKivKg6e9X
         jpihwXaTW9ouK8DW2DcXZ3kuMpL4P40I33G7VdelRRrzVl1mFQ9fYnaUL1Iax+RBcFGA
         Wh6K1k/I7PVSCfi5K2uDr1AJQGDSkENDejojvRlAcBKuUtClWAzXP2HrvG3kwbPVkLlm
         J8ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q9O/QDigxPlmqtrzg+lI27H9LnqU5X97nUid93qpMQw=;
        fh=nBYEKBPnraJVXgQRgqDKPhactnTahqFYfUxr7d2/rcI=;
        b=FeiF/wGK5i1pRlicTTi9j7UyAYavUrqH+IZlAv1Sd8h3VZx/h4z1J3TH0DPjJJjymL
         BlJz5ARZHcjpUUA+P4cJxwhz2u2iNXZUBKCHOh+NXHOvTG+TEW09oTrxssM+NDsHisYT
         qHmysvf/Khaq+aW5h4Og2s0D+g1zIFoMvwKSUU7yHpdjDLAV9OzErBCsgRB79POL4m/H
         4xfYle6LhKrun2hk681aaCf0hUUb6nO7d36MyQNaF5YBN4gFmDTakGBsxWEhWm9K9S6b
         gLSosY25NThVhfQcYVd3D0hWFhocDCGdTfHIgbizMWXwDQaJyt8NjRVsaPybWVSFDYvF
         UlxQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795746082; x=1796350882; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q9O/QDigxPlmqtrzg+lI27H9LnqU5X97nUid93qpMQw=;
        b=maLX34fvMZVPH5SDMoqtPpgxxwZ7j+F0Ojr/Wud31buciuFeG6F+flCYzdfACDmoL0
         xYKj+5Ebo8ObejhpE5J602xo7zmDmuVuSTxfQfsTd+nvghh9oRFm6bJfrCAnbESTHkAE
         kgbNTK0ONpwxA+8Sv+hKQsSgeuykHBqAtcRWCCSYqwz4GnklijnDduuYVWPF4Qv8NVkc
         wUA1ypm7j9C3LQm4+6wjzT6wXXInvF4p2rGOmodfz2MIglRpoOjUWuFBn+lwz6enSjRM
         D4putJC8IJByZvEJxZuIHhhirQrPzOsqZqAVnKib3JzjLCln+kjbJa1ahr+8thtPX2gX
         iGcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795746082; x=1796350882;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q9O/QDigxPlmqtrzg+lI27H9LnqU5X97nUid93qpMQw=;
        b=NMAXAJdZL1CF75ar6a1RNmw6hPwmTUnc2hnEr1b6UnXxRT7w9Qzgoh1Z8Y5AOJ9jWF
         BqGbYjQB7V1KMnwPIm8VckGOvaPK5DMBqBK7iex0bXYnZ0CR6EUIzlRr2r45Upo5tgnU
         7A16rR6paXVYZv8v9Zm4ycjEY58E5scTR3EH0QOrWjaXzIPOIt42yHu3HYxGg+qO4/Yd
         Sui5xYLttCIfsbtIs9XnItLN61ioZER/vvf1DR4svyrckmKh3lcH59uVyaYHqnaBHubA
         t4rFX7pzH6EoLGRTCDma9k10LxPL9I+7vRAW2aCTbswJi0AkhEMC5HxG0uih0Pul2CeE
         pzYA==
X-Forwarded-Encrypted: i=1; AL+hErFah0XYMqUh0NGKf64ZhsJdyiKCoskehTeRx2vQXKrW4IvQWGVQw1W2Yd0KC+8/PQuTVm1+SF/iYA==@kvack.org
X-Gm-Message-State: APuU4Z+Rsw1VqD1TlIWtg5kSbseDtHU3dy3+xrMRZdlEM8eLgy3PZFTQ
	6nB7nbFTUxGdommC6Zg7UetCL+DmwRZ2qvv1WC64H/uxCnyv3NiMNeYFBgWNfOK4Q2RswW7n2cp
	rnwc6KmktHSNs9+sKxpeg1vGXv00VPoU=
X-Gm-Gg: AZFdTZcG9XLJI3e2qGe90ZeptFhExPFVSfIZGh83m0qxJNgV78jdCoOsdTEoZ7zdO2T
	e+1Sl75N+X9fXMU9YhMrS7AYS77131pYeMfggifK3Mi34iuGMR5W7enSO9EBdZ2YY1cF60EAj/S
	jUx74agKUCPVIZCd+lEWyxDtk2PEJKq4OE+bd0IBynC/mWedm2Rb0u5Dj7OosF7TwvyvvwQbXga
	uKxRhEYkkxVbn26nJTr6rU1Wkwv8FEFB9mdGER75FIVWOP4dd9aQ9H+Jn6eo2q6qkawK3lGpESh
	3NrXPreAYnmlJeUeaxpejDwK2VGfIy0TvxgxrjPylWdhN61gTyme+k0+TelctpnHDKeCsS5kbWh
	CJLsY8HpPPkP+IG2VTdN+XxpMOVhFIfCWAcZP6X8sELcR1fO20p/9LXV5/PT/LGtmvNwFE2V1PW
	Ay3qzSwIBXxvPwO4o=
X-Received: by 2002:a17:907:9693:b0:c4c:ddd1:d006 with SMTP id
 a640c23a62f3a-c513ab47f40mr1740039266b.38.1795746081722; Thu, 26 Nov 2026
 18:21:21 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-8-8ffea39934a6@tencent.com> <e85a2666-9722-420b-9a60-9d4251fc3d4c@kernel.org>
 <awa30hwg6x82REoo@KASONG-MC4> <8ec3f3e2-5d3a-4bed-a571-88f7ba473b00@linux.dev>
 <CAMgjq7Ayu9H85wurRAUdmXEPWYi9BdLJW13BhK+LMYoBX_7fuw@mail.gmail.com>
In-Reply-To: <CAMgjq7Ayu9H85wurRAUdmXEPWYi9BdLJW13BhK+LMYoBX_7fuw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 27 Nov 2026 10:20:45 +0800
X-Gm-Features: Aa3M54ocIHnij2wxU5gTqMYt2uMcyjdRvBBfxBalbs5FgV17e07SNTVEtRtEE6E
Message-ID: <CAMgjq7DwCNbke2G25Bxfj3bi5aRp3_qkGeYmCTGVGv+Y5XzKTw@mail.gmail.com>
Subject: Re: [PATCH v6 08/18] mm/mglru: make folio lru referenced times count
 a generic API
To: Ridong Chen <ridong.chen@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Tal Zussman <tz2294@columbia.edu>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 59C8780008
X-Stat-Signature: 1576dnka6szj6i1kdptahcbqkxqo4frm
X-Rspam-User:
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795746083-81894
X-HE-Meta: U2FsdGVkX192+sFUaLn2+b4wp/lUKFXz5wjOvneq7mN8DnIbn1DI88ecxdmCIccssw1FDTPQ8pbcYPqG4N5zHA+gV+4+yLJNLGUojoE1sbuzdroFMWtMdxstcNr25cF1jQ+0U+ctbihHnybULszdiA53ETiM/3t56DJHKebVr0gcQwBduR/peJWIMXnjxrPEyRTGrqPth7uKx047rzoyxF1zl7F++ZI1IT8NeV5tihi+XuKfVKlZynMo2ZsOPdo/1dtj+o9iqqjp7g7kTd0bszMXnl3qd8owvsQ3eSUXvGE6h8rqx36ff4Fr0RLMJIjk/9EBPP0uB62fZS0LHJtAumYEWjj1sgWs4X7hCZ/0spIAr5F8f70fOBuKLPAQt7tK/sdOq9uqYgNJlfwvPK0+RF7XgxRaWMChqHdvUY2/Vjm2QEjgePoaUwjoYGqHvMRFv3xqnh1kn0Wksc5PiDliIzWh8WdZ+D0g2dpilVVPoUFtqXeg3wtCOl86led9Bpg7aM1aBHjqq4X93w/RlABd+j4hXT19hpg0zhsvFAkf7X3VZQHvVDaihL4fHbX0FCQUQ/8atAmcbi0RbvUNOqXmwdEzeeeY3giszqovjy6tqzdG+5YUAg+cCyXMbRZRmv+25q+Wt6JFC9LN6z491LZGbYlQOKWJe1SLNHW8ga0BcmKGmqacmhsKZ77OB8YHKSuEymtDveWUOApe/MivgLB3t2ZKNCwbKvLsVVWPBWkv/nNMKxdCn+alztPcRpD8LWS7ywONrGFdn0aOuNXWXkdFbwvw2lRepwJSb5fJoARHRwojZftvtEI1XoBzrrp0QxTM2Cf+E80MFK7tcJ1GLQdWbxJTzjIEciRLo8WuCa90ADlKDurlKBQYM3NmpZOrC3QMyMmfab+uClLJO9i9hqRa5D9aP6zQtHZ91XLR3D83W/Y7qF/S7TiG9nGpF8/f4Ie0AdDg9IaDGVUoRToxobo
 cjOqru4C
 tI1R2mpXSgl1EssrzNuD8hwnE7ifJHGkMAUDYglxpE8e4s+orvhWhTO/TMVd+/aZ64MBEI5T5+SqBv18jDXkqQD2COBkt8FBrPAf33HZnQyf4BBbN81px6EUIihRtbSnGmgOlDUhTv9KLJX5g8HZqpP1KNWuYITOmFlHaeUkrZk0V46sdS1vaenyGEp5hZqWvNu9SWVVqGNeUiLZFvWrAuMZCBAV4K99mNK3SZDKx+wX9zGQ0OmEukkXYdE9jincgkaYRAz1Qcp1qMnc62gDbyCQP3p6hLesTLtTKE7KsPYY7mIQVUiNC2AnDQuwPWRlU911hMIrwDrFiFjZr03V02ZoN33Xj5b9JaBEQ8mW0tba0C8JRNtR+23RdVxfexfT+wHis2ns1mxRupRkyxl1UzH5Hz+ez+iXbEWnLGEOFrzABGIhNqvVcGOwJdj3HSRZBLnUJdcJvtG2lpMHPlC5Yyq6gww1O8YV2KiIwPDHDsNGcALQTCWSvXek9yJXMUVL3w/ZPi3/ise/wtoniaJAtgU29kRYup3cUyGcn97gfjRpJLXifClpIffMDNgDAovjfaAljUyosov2avSQIFTqVcPwDQPmKf21jp/HzEye7TZVGfJLTLD4Dxq2kijytI0Zqk8LZfHIm7BbnC4/5i6UvVZbfxp3gIssEq63geZ4JKIP5MqykTnaLMACb99hr7pN2hir9THa5NnPb2scpGAdwA5OsdzS8h0GRWV+3xQK0fVl+p6hXkcNOoCm0Ku36FtJZKzOZKWYf5owdvB+TsZw4DctYt3EZFIESafrXU8z7PhfUxiz76ycmULwcYHaOZEDarqyEoie87E0wLZCq8vOSISZTd8Bm7wIu87JMuELAHsPHy3U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 27, 2026 at 10:01=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> On Fri, Nov 27, 2026 at 9:48=E2=80=AFAM Ridong Chen <ridong.chen@linux.de=
v> wrote:
> >
> > On 11/25/2026 8:36 PM, Kairui Song wrote:
> > >> On 11/23/26 19:53, Kairui Song via B4 Relay wrote:
> > >>> From: Kairui Song<kasong@tencent.com>
> > >>>
> > >>> Pure code shuffle, no behavior change.
> > >>>
> > >>> Make the folio LRU refs helpers available regardless of CONFIG_LRU_=
GEN.
> > >>> Without MGLRU the extra bits are never set, so they are inert. Move=
 the
> > >>> lru_gen_* helpers into the CONFIG_LRU_GEN section.  This prepares f=
or
> > >>> unifying the API for checking folio referenced and workingset statu=
s.
> > >>>
> > >>> folio_migrate_lru_refs() now migrates the complete refs count,
> > >>> including PG_workingset (bit 1 of the encoding), bitwise identical =
to
> > >>> the direct copy dropped from folio_migrate_flags().
> > >>>
> > >>> lru_set_refs_flags() skips the nonexistent mask bits when
> > >>> LRU_REFS_WIDTH collapses to 0, preserving the two independent flags=
 for
> > >>> !CONFIG_LRU_GEN builds.
> > >>>
> > >>> Tested-by: Zhao Zhenzhuo<zhaozhengzhuo@uniontech.com>
> > >>> Reviewed-by: Kunwu Chan<kunwu.chan@gmail.com>
> > >>> Tested-by: Andrew Morton<akpm@linux-foundation.org>
> > >>> Signed-off-by: Kairui Song<kasong@tencent.com>
> > >>> ---
> > >>>   include/linux/mm_inline.h | 55 ++++++++++++++++++++++++----------=
-------------
> > >> I'm starting to feel like all of these mglru/reclaim thingies should=
 go into a
> > >> dedicated helper.
> > > Hi David
> > >
> > > I saw your comment on other patches too, about the header mm_inline.h=
,
> > > about ~690 / 860 lines of code in it is for MGLRU / CLRU only. The
> > > rest ~200 are for VMA / TLB / MMU.
> > >
> > >> Can you do that as a prio cleanup in this series, so we don't have t=
o mess with
> > >> mm_inline.h in later patches anymore?
> > > Perhaps we can instead move the non LRU helpers in it?
> > > These helpers:
> > >
> > >    - anon_vma_name_get
> > >    - anon_vma_name_put
> > >    - anon_vma_name_reuse
> > >    - dup_anon_vma_name
> > >    - free_anon_vma_name
> > >    - anon_vma_name_eq
> > >    - pfnmap_track_ctx_release
> > >    - init_tlb_flush_pending
> > >    - inc_tlb_flush_pending
> > >    - dec_tlb_flush_pending
> > >    - mm_tlb_flush_pending
> > >    - mm_tlb_flush_nested
> > >    - copy_pte_marker
> > >    - num_pages_contiguous
> > >
> > > All other helper in mm_inline.h are for LRU. So we rename mm_inline.h
> > > to mm_lru.h?
> >
> > Moving the VMA/TLB helpers out looks good to me as a first step.
> >
> > For the LRU part, there is already mm/vmscan.h, added by "mm/vmscan:
> > move struct scan_control to a dedicated header" in mm-new. Most LRU
> > helpers are only used inside mm/, e.g. lruvec_add_folio(),
> > lruvec_add_folio_tail(), lru_gen_add_folio() and the refs encoding
> > helpers, so they could move there instead of staying in a public
> > header. Barry also suggested moving lruvec_add_folio() and friends
> > to mm/vmscan.h in another thread.
> >
> > A few are used outside mm/ and need to stay public:
> > folio_lru_list() in include/trace/events/pagemap.h, and
> > folio_test_workingset() in fs/btrfs and fs/erofs after patch 16. So
> > maybe keep a small public header for those, and move the rest to
> > mm/vmscan.h, or to a separate mm/mglru.h if it gets too large, as
> > David mentioned.
> >
> > I can help with the mm/vmscan.h part if that works for you.
>
> Good idea! Maybe you can send a series to do that which I'll rebase on
> top of. Feel free to take the first renaming patch too since they
> should all be zero-feature-change :-D
>
> But please help keep some helpers in a public helper so when we are
> able to get rid of folio_*_referenced and folio_*_workingset, there
> wron't be some strange header inclusion issues. FS users quite often
> need to call them, especially the folio refs related ones.
>
> (Considering MGLRU even used to try to completely ignore anon reclaim
> at swappiness 200 about a year ago, maybe that isn't too much of a
> problem, but it's still a problem).

Sorry my mistake, I meant file reclaim, got it wrong in the opposite way :P

