Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F36C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 17:47:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09ED26B00C8; Thu,  7 Aug 2025 13:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04F2A6B00C9; Thu,  7 Aug 2025 13:47:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E805C6B00CA; Thu,  7 Aug 2025 13:47:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D67B16B00C8
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:47:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93113B96BD
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:47:19 +0000 (UTC)
X-FDA: 83750692998.19.4107DDB
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id 953A81A0005
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:47:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="CXh91A/0";
	spf=pass (imf19.hostedemail.com: domain of jannh@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754588837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hDJdMpTFc0KMKXcRTALWA1S9ovbUgwwdEZq6bXr34JU=;
	b=IS20SMdV9DC9z9nhuF0xO3KlJi2bRwZK1UpGeH6b8pCrZUwu7bPOlRx2VKjD74NsVPtz3p
	X4mDv4DlCHru7l6FzzyTx9E34oSxJ5EnaRyXDBokm+yDOqWLj3pNmLAzOmDgeppP4TgNeI
	TCIq+swaX9mQw4QCXYMcbP8J6bLN2yM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="CXh91A/0";
	spf=pass (imf19.hostedemail.com: domain of jannh@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754588837; a=rsa-sha256;
	cv=none;
	b=iGlPrE8VXrQGSpsZ4AT0w7W/fwP0Hk1ONT+SBy7YbAe5EdnApuYdfVw4XsMWWfcHIVuFWg
	PC3m4gEztTKeVlNYhn+pTPhpieIBU8V8hs16wUsaZlYDQNajyNkpnVKeuvzXoAtHE0upVX
	mRpTXL8ljQ/bpee0UGR6K46g5iEywl0=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6154c7b3ee7so1302a12.0
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 10:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754588836; x=1755193636; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hDJdMpTFc0KMKXcRTALWA1S9ovbUgwwdEZq6bXr34JU=;
        b=CXh91A/0zK2t1h4reClu9BP92/cLuBUYeftcqccZ1FvtX080Ga70UJkRgrQWF+Tl31
         RjS/kvYQ3CMD23O6BplWF96PFaBhn8n+ea197bLvtbkWx9KYjXbFXVMpRgwyTqF+svkX
         oyWAfXxbmNxSUcHu+VqHL7/TkmxqVpXxYHMfs8JD5XW70Jo7rg4D4VEN2ZM5w4qPLm9o
         Pv6h+vQ89MQSRBny3y85Pk68ZxtiFBmASOir1S7togMqWBp594lbh88cxHk20ViI5fzX
         OPxCL4dXhmXM2NwQPlnIZtwddT8UAc6ru1NNslgDIhC5CE1dKHk2Q8MBxLuB4JONI9tB
         eXaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754588836; x=1755193636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hDJdMpTFc0KMKXcRTALWA1S9ovbUgwwdEZq6bXr34JU=;
        b=VmoO9ofIQ/c4tWg38GEHwFlmbaxXQV0zCRMuAvKrgNXKSLbAdxTt4qQVfDbv/GzEvN
         iRRUCh/VZqoQwpBhNPnWYOfX8AALYVS1Uv4hyn8xIsZAh70D9ohTrtQPZNiaK1LsQadU
         UX7QwZlKJGOfNjzfW0YxZ+3cOwPTORhik1JZfwnHB3D7pClTs6uQeA1rSbwQJ6zvX6jQ
         fDsm1ZWDFjEHJP55xj8MFWu9BOsdpccx8bDRR0Bod73cWxIuGJicLI4ET5owuR6IBFjH
         7bgZ5LrNLBzUYdVYt+humOdGTsj2xA5qUqXIgkJyY5lnyYXS0CbL5HwdebZ+9xDNs3rP
         Y+NQ==
X-Forwarded-Encrypted: i=1; AJvYcCW65dIXT5JF4pgMzbGwLnasg/NamEGhh/NZRWCgM19pMpboO3b7PE/35jB2y60C5S6+76RzL3pAqA==@kvack.org
X-Gm-Message-State: AOJu0YwX4MP9EMpoVZlY03sVEGfdDN7tCfixkGTzBF4nCGxA7UJTR7Wm
	J32veEGAxwVt6ugjT0+o+fVITkMgY/0Ej8lLEnhu8wwmBoxMuhDwXj/PSi/5D9Lu15u9yRljGZT
	uLz14eoWVSj1hOLksJrGY6dF665OycKwtBQ/B0omL
X-Gm-Gg: ASbGncuPW0TQ7T+Kh45g1eTLa0jW2o8SZcBsdTPrWayxgT/A3zrFY/4YJrNz2tQvLnJ
	KXod33meQEejBzHSMcl78x1lvnkQW0NbzQvksUaWoIOdrnl4MzD6Q7VuQvQ0xidUZScN/OGXqWx
	lUOZrHn7qFrqbUiH6HU5TWTcVsjWM/h3552M/wt9+1463fA51+S6FolOPzv3x8/2n8mvQpfAjpa
	42GAlxMzmAB/4KKWGmHnZ/oXfyb/aNUXnY=
X-Google-Smtp-Source: AGHT+IFVAwixRVEdAdG9acHP30gULaJwSYNDDdAwpFBfQR2iG91VTEgNHzYlsENI7tXxpeqYxK8IG0xUMq0IsdLdjZM=
X-Received: by 2002:a05:6402:292f:b0:615:63af:84c7 with SMTP id
 4fb4d7f45d1cf-617e0c2fea6mr1229a12.0.1754588835703; Thu, 07 Aug 2025 10:47:15
 -0700 (PDT)
MIME-Version: 1.0
References: <202508071609.4e743d7c-lkp@intel.com> <9e3a59b2-11c0-43ca-aff3-414091f04aa4@lucifer.local>
 <CAG48ez3=8f3eShjAe9hrvivP+Dvyisw=X_Tr_phc-OX_4MzeDw@mail.gmail.com> <be074809-e1fd-43a2-9396-8f7264532c4d@lucifer.local>
In-Reply-To: <be074809-e1fd-43a2-9396-8f7264532c4d@lucifer.local>
From: Jann Horn <jannh@google.com>
Date: Thu, 7 Aug 2025 19:46:39 +0200
X-Gm-Features: Ac12FXz0pqhZ5ZXNMYXrgkg69OVAPBJ7j_8d24_PRsIXf3jxPz6zdWEIncqLCrg
Message-ID: <CAG48ez3=kLL4wBxAVSa2Ugrws+-RFQMdNY9jx5FAdbhpNt8fGg@mail.gmail.com>
Subject: Re: [linus:master] [mm] f822a9a81a: stress-ng.bigheap.realloc_calls_per_sec
 37.3% regression
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: kernel test robot <oliver.sang@intel.com>, Dev Jain <dev.jain@arm.com>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Bang Li <libang.li@antgroup.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	bibo mao <maobibo@loongson.cn>, David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, 
	Ingo Molnar <mingo@kernel.org>, Lance Yang <ioworker0@gmail.com>, 
	Liam Howlett <liam.howlett@oracle.com>, Matthew Wilcox <willy@infradead.org>, 
	Peter Xu <peterx@redhat.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Yang Shi <yang@os.amperecomputing.com>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: d3tnt3rx3dwob9x8nog3n54oxg5a5jx4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 953A81A0005
X-Rspam-User: 
X-HE-Tag: 1754588837-527572
X-HE-Meta: U2FsdGVkX1+ne6m6Uy2zhQk52BE0euGgJbJOM3vjIR8gjmdWAKQS6eXVKv+uxl7WvuFriGjJw2utLPxnjEYROIODlZRtq194owmweUt4NmERxW+49hskU0l5DM/+tu0BeJMgz2W4fvYMWbmhaeKoUDkBeFI83+oo14d9O9LHB8tpNB5HubxfPXStVRTVN1Dy1hbB7xKJGkxPFYEwPyhCwvrvfhwjuxYQP2ZVtUlvTJsYG/izJpdkyV7E2KMGAhNc+TW1n5UFf0CYP7qCkq+FPO12seY+xk0qC2uz9ynpEwEOXBuK/hQB52zz7bEJiPVFYeAjZ+zbQEFzJ1FgAAZHsnGUtD26no0w/w4FV5/30gSXh3TdvDWHhoWxO0m6v7Fkf0HDMv4v/BpeJrqtr3BIVXPO+IQrwbsReoCGdsMsch4yBQjZ6Tdoe2xmWN4AJV+VpAgc5WbE9SVJNkkanp0PVhf42naPFFQKW6Evh4GgriqWVujL3GAI1K1zkP1Gi7K/6zE7dZnX76IMsuARBSFruhhV6P2zVQ2rNtRQ1w5wInktZYUTipNb5JIYRPv8f9fhE8FYV4C7YjFxbYtrR9qstTapddldNkgAb5FEW4ogOzl6wWCIfV7J3tKQXvEJuAQL+0Xkx6DWkyZbT8Py9KXjTsaBvPPRDFQVV1Fw0y9oGcftIa4h4XWSzi2zzhQbde/1HrsqwsWarf0NO5DSZJKHo7qU2t/Rinbne1i2Bc6Pd8OqaRBx0lbkUisErg+eIyZsWgZsGlnYvrLQB/xQtjZWpFf5+WgMvDWhjEqT7ucJBKNZ8e3kmdsDC4nsQxQ71iuKPrMciOsL/LqyZ5NgEH+wRTgSM2kJ4fHaGZ8mnwgldb6kMxOGLDD4QgyXw+nrqImBhG2BvJM2VlCSPDAx5K0FmU9Xwzbt4ONSyEX9AFYA8l+8Qu7691X+L/5dal/S0b4MSI7W3GK9ccSNkVpL5Ux
 YrF7aevx
 mZMjJTHlEXiq6PFY6eA6S9n+yWep/tXr2Ky/C2HM9Of1V0vSXQbaVMon/OLSOErCYc7fZXa3BLs9MYzoGxWFpRkjrXy8isUFMe/hRqjEKHRuMFTpv1Xyh8/UmC8vb9GFgl+Jn14YET7QRs30UoQCYS3oP7cwvNTkaLtsDFPjqSvp4uvCn2qYCnH/Mb/J9IoLccQjddoiwoUxgexxT1Wvp0CyvW977fG2uuR6UKET7epbh/x+LHV3VHHGI/245KGATyq17oMEUVR2ccabv2nJrdTJ2WPJYWOSJbpu2ZNIAg/TiMDrp4pal7nxU3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 7, 2025 at 7:41=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> On Thu, Aug 07, 2025 at 07:37:38PM +0200, Jann Horn wrote:
> > On Thu, Aug 7, 2025 at 10:28=E2=80=AFAM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > > On Thu, Aug 07, 2025 at 04:17:09PM +0800, kernel test robot wrote:
> > > > 94dab12d86cf77ff f822a9a81a31311d67f260aea96
> > > > ---------------- ---------------------------
> > > >          %stddev     %change         %stddev
> > > >              \          |                \
> > > >      13777 =C4=85 37%     +45.0%      19979 =C4=85 27%  numa-vmstat=
.node1.nr_slab_reclaimable
> > > >     367205            +2.3%     375703        vmstat.system.in
> > > >      55106 =C4=85 37%     +45.1%      79971 =C4=85 27%  numa-meminf=
o.node1.KReclaimable
> > > >      55106 =C4=85 37%     +45.1%      79971 =C4=85 27%  numa-meminf=
o.node1.SReclaimable
> > > >     559381           -37.3%     350757        stress-ng.bigheap.rea=
lloc_calls_per_sec
> > > >      11468            +1.2%      11603        stress-ng.time.system=
_time
> > > >     296.25            +4.5%     309.70        stress-ng.time.user_t=
ime
> > > >       0.81 =C4=85187%    -100.0%       0.00        perf-sched.sch_d=
elay.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > > >       9.36 =C4=85165%    -100.0%       0.00        perf-sched.sch_d=
elay.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > > >       0.81 =C4=85187%    -100.0%       0.00        perf-sched.wait_=
time.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > > >       9.36 =C4=85165%    -100.0%       0.00        perf-sched.wait_=
time.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > > >       5.50 =C4=85 17%    +390.9%      27.00 =C4=85 56%  perf-c2c.DR=
AM.local
> > > >     388.50 =C4=85 10%    +114.7%     834.17 =C4=85 33%  perf-c2c.DR=
AM.remote
> > > >       1214 =C4=85 13%    +107.3%       2517 =C4=85 31%  perf-c2c.HI=
TM.local
> > > >     135.00 =C4=85 19%    +130.9%     311.67 =C4=85 32%  perf-c2c.HI=
TM.remote
> > > >       1349 =C4=85 13%    +109.6%       2829 =C4=85 31%  perf-c2c.HI=
TM.total
> > >
> > > Yeah this also looks pretty consistent too...
> >
> > FWIW, HITM hat different meanings depending on exactly which
> > microarchitecture that test happened on; the message says it is from
> > Sapphire Rapids, which is a successor of Ice Lake, so HITM is less
> > meaningful than if it came from a pre-IceLake system (see
> > https://lore.kernel.org/all/CAG48ez3RmV6SsVw9oyTXxQXHp3rqtKDk2qwJWo9TGv=
XCq7Xr-w@mail.gmail.com/).
> >
> > To me those numbers mainly look like you're accessing a lot more
> > cache-cold data. (On pre-IceLake they would indicate cacheline
> > bouncing, but I guess here they probably don't.) And that makes sense,
> > since before the patch, this path was just moving PTEs around without
> > looking at the associated pages/folios; basically more or less like a
> > memcpy() on x86-64. But after the patch, for every 8 bytes that you
> > copy, you have to load a cacheline from the vmemmap to get the page.
>
> Yup this is representative of what my investigation is showing.
>
> I've narrowed it down but want to wait to report until I'm sure...
>
> But yeah we're doing a _lot_ more work.
>
> I'm leaning towards disabling except for arm64 atm tbh, seems mremap is
> especially sensitive to this (I found issues with this with my abortive m=
remap
> anon merging stuff too, but really expected it there...)

Another approach would be to always read and write PTEs in
contpte-sized chunks here, without caring whether they're actually
contiguous or whatever, or something along those lines.

