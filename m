Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E044CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 13:08:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B72C58E0046; Mon, 13 Oct 2025 09:08:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4A4F8E000F; Mon, 13 Oct 2025 09:08:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12F38E0046; Mon, 13 Oct 2025 09:08:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8CE168E000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:08:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3FF3A13AF98
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:08:07 +0000 (UTC)
X-FDA: 83993119014.23.FEF57E1
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id 589C1A000A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:08:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZSD1zBrt;
	spf=pass (imf15.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760360885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ezMBebfglcjXR4WCpqnRZyhjdDDfwSug2JivoEcwJSY=;
	b=MIeLUvu9/Tmh7U6LHk5JBU+4b1lz6F1ApnqkyF0be0nkoeNFpHszQR4/hdWvUt5UImKaII
	rPPlyWorrtjzeA8OeW5Tov6h2CqhlgnS4kF5Yma0w3fUIfbZWiiAAjYWmqSRHZvJvuem4e
	80sd7ek/9lWE/9BLpVs/esiMZ7uS7zw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZSD1zBrt;
	spf=pass (imf15.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760360885; a=rsa-sha256;
	cv=none;
	b=msRrc6DjMPLaDM6ZzLsf8B8CFooyca4wmvsP+eSFT4DCHrfSPLaAjnzx/XXdmlHnjiKtqx
	pIDK/T2xnhSgyZOaQ/rZUE2lX95oyENBXQuiY8FeHwEaGAryE14xeI2swDsE+k7cH9vZNQ
	5tHIQaKHciEH3L9cmLAOL7rMW1Kqu+0=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-78f15d5846dso68603686d6.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 06:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760360884; x=1760965684; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ezMBebfglcjXR4WCpqnRZyhjdDDfwSug2JivoEcwJSY=;
        b=ZSD1zBrtvhDl7lTffmvsqo6kR36XYrOS9AsmoQbDF/HhqFkWPETikx4Ovomx5WuZoy
         52loM7XMCyzuRcs0MnmFjxZ+41e+IRnwke3dzaczQfrL2Vn/8RGyUYWoVOmgRVY7kH9D
         NdOxw1C7Hf58BjJmFi72QzW3o4f+ZTrOP2pZl0aMiqDuG9m9M9CqKjQrjEza+lP5SFud
         hJnf6VUE/HXM5hxXj0ubKRE3FQfVtPV18S2S+JB8WY/vWqL3ldYSHJD5UvWnt3fqlMYC
         I5HwEPpeIHnNhzMIViqGbQUMs76kEAU/ztoju+8UTwVQuhypgT1WCiSsttxwtCk7wziJ
         tikA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760360884; x=1760965684;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ezMBebfglcjXR4WCpqnRZyhjdDDfwSug2JivoEcwJSY=;
        b=hVqNbG3efgChcgzH1ehoZbvOIeI6raJdBf/7cvwnlZDVxoCBTl1WW5SrO46S7sZRg3
         bzuoQzAWPZIC81yQdudnXwk+nbkUde+MIB537adjRiiE4bjSNXtN8Okr7QUSIXcyfvHV
         BY9hLXM0KbzGH44ypSo24Y9UlfJNGll8NsE0knKIkBTkYCYF+MTE0CwYgTqnOOXkAdkr
         l+/us+V9i7nsL5hLCHxOLfKEnfJ9NFnU/TW5fpyR/BgPitvKaJ4tDFD0o7D1MedLKTYD
         3DoEIReZHsZ3La7QrwcR/hQDjmi/zQNZyp5bnvtFAOx7TbjoaKiGd8ZmXQF0gy9GJcnu
         Sx1g==
X-Forwarded-Encrypted: i=1; AJvYcCUvcPAznR0TU/QI56yV7pXu9A1KPvBKuyLmOvlW/JDLQTqGle2gk9vDrTwp79G7Q3a+TPJKXhzA+Q==@kvack.org
X-Gm-Message-State: AOJu0YwTo98rToWT7K1y6Njvp53QufsI8+T4lHlPJbfEBAvJ6YjhRWCS
	GcBZfCPxXa98+SXIfOcKEaz10XxpfAji/CkD1uy8GdylCa6mfUW4t2Bz7PO4DOG+9UXEwdXswL5
	cSDujHH1T3ea2VRZG9F3nnaSoIczA07s=
X-Gm-Gg: ASbGncvw3NYlZ9xV5a9d+wFRbdJR3hwHdp7Ogi8gokLjMaakyCQPfvoWEnwPMqlbu6G
	tJLe17H6ArWXAIyDTQ+n50VhyjQx2Bq6Xv1pRyStcn0hxfeCarb8fcRvsuGje2dbKA+xKznibzj
	KMU7iJfyo2sDkTaBn/+FPIC7Ac/KILptv+Fh+/0dakfG+RE6luReqnk5UNADAYdRjkAbil1iwzk
	+l+i5JFr3qe6NJU4kTaR52vzLfsKQJQuduFoA==
X-Google-Smtp-Source: AGHT+IGm0oKxFc4T/QZjCy+NGutfmN3uHvswZSHDi9nqJU7JDX84TgvXkCDG/QBma6yTwwDWrVtFnLsmlV0W2zzJh/o=
X-Received: by 2002:a05:6214:f08:b0:7a9:3d3b:fe95 with SMTP id
 6a1803df08f44-87b2101d562mr345171496d6.19.1760360884347; Mon, 13 Oct 2025
 06:08:04 -0700 (PDT)
MIME-Version: 1.0
References: <20250930055826.9810-1-laoar.shao@gmail.com> <20250930055826.9810-4-laoar.shao@gmail.com>
 <CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com>
 <27e002e3-b39f-40f9-b095-52da0fbd0fc7@redhat.com> <CALOAHbBFNNXHdzp1zNuD530r9ZjpQF__wGWyAdR7oDLvemYSMw@mail.gmail.com>
 <7723a2c7-3750-44f7-9eb5-4ef64b64fbb8@redhat.com> <CALOAHbD_tRSyx1LXKfFrUriH6BcRS6Hw9N1=KddCJpgXH8vZug@mail.gmail.com>
 <96AE1C18-3833-4EB8-9145-202517331DF5@nvidia.com> <f743cfcd-2467-42c5-9a3c-3dceb6ff7aa8@redhat.com>
 <CALOAHbAY9sjG-M=nwWRdbp3_m2cx_YJCb7DToaXn-kHNV+A5Zg@mail.gmail.com>
 <129379f6-18c7-4d10-8241-8c6c5596d6d5@redhat.com> <CALOAHbD8ko104PEFHPYjvnhKL50XTtpbHL_ehTLCCwSX0HG3-A@mail.gmail.com>
 <3577f7fd-429a-49c5-973b-38174a67be15@redhat.com> <CALOAHbAeS2HzQN96UZNOCuME098=GvXBUh1P4UwUJr0U-bB5EQ@mail.gmail.com>
 <7176597b-006f-40ad-9421-860d80d7e696@redhat.com>
In-Reply-To: <7176597b-006f-40ad-9421-860d80d7e696@redhat.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Mon, 13 Oct 2025 21:07:27 +0800
X-Gm-Features: AS18NWCBr7_RxNHr1I-K75akWBIPcxKG4UcwhU5giQn6IEnh0jqmkdU7wZH1l1w
Message-ID: <CALOAHbDqP3fH2_4r+5_9D46qrFiaRYHYGzW7M-fwwt4_qW9Npw@mail.gmail.com>
Subject: Re: [PATCH v9 mm-new 03/11] mm: thp: add support for BPF based THP
 order selection
To: David Hildenbrand <david@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	Alexei Starovoitov <alexei.starovoitov@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, baolin.wang@linux.alibaba.com, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
	David Rientjes <rientjes@google.com>, Jonathan Corbet <corbet@lwn.net>, 21cnbao@gmail.com, 
	Shakeel Butt <shakeel.butt@linux.dev>, lance.yang@linux.dev, 
	Randy Dunlap <rdunlap@infradead.org>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zxxxh1s8ywt3rxrniwes4jhxeiy9iwgn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 589C1A000A
X-HE-Tag: 1760360885-398939
X-HE-Meta: U2FsdGVkX18KTSIxZTlkPN2StEO+KuGDCmOXjLc1JyMiFyiDU2aaxZjKBkCodq1acKsYbsySPkGu3P/eqKQbG8AEl8mgpOgoU1gIqWk1xoi7Mv91YnCZT8lKVvxRcttkTtZaL147z+SdaqOoyZnIgQTV+Z/6bNIai7OtwKv6Y3UfkA5SOu2OFXUE58L6WHNsBuZfq9kGwctdtsCksTbCbpod3Kc+94ALeW5Gn7kI0solwYKB5VRylIT3KhR8RRE1h12SqJFHweHVAByxa0VGj8hT5Q6deVH8ZlpKbe323z4olevQkhuYKQN3PgTydRYbRcSeXhpG6XC8wvmcD1iLdljokvghEee8pdlzMSjx/+qL9AUa2jSbYuXqL/5G138Ggk73loMsUKIbq4qrT/zUTWXRL9ioYAioc519fhteaBGmCjmj1WAI1leWFUYkNE3Z0tGDhSbcNGVnrv2h1xsBwbEkDytlgWf8hAyKG/YnEzELmmjvzE9ADXIlYnz9mID9BCB5FdKPTnr0Qqd4E72KGO3m2fg5sXqR/b1SkOGviltm+0tDPNhhw7Q+mw/cE3jIpG7GS74Rp1jpCQHroh/bndFQG8GIj0v/CjS2+HRphYyWpyqMycsMQS915Uwg8q/VzNZRV/hCBJR3RbcW+gAUhQiJl79/W4rr1/rxgwb1AEFFfL2uONFGVfFlyATO1+hW62hT87oUg1iZa0mF8WgJZSR4NI2a97I80SoDmk1U5BqJuHo0Kocu3loVCWsk8kKr5O4O19Yl339ftk+H3rGMKMsYlWmFVQhBxukqasPGD4GYOb0bjaqptW/WzHX4/2S7BCmafIQFquY+6VwSfsNwjPx/F/HeLmNRRaoLOPcqzIyyrgQR3lTvFhvDRe9ewOj9o7xY0yLF9UU24orbNTsfnorPJNie6zrZ4M9ajdhKdUotX0oZVAkAl8vKmmw7nkl+PcrnYCzMbKvppj08MRc
 pEW2J99s
 BAZvgBzIpXei1PcCHetpVXGM/5wL74CX429aXpnYqkZjKsBIWFsQvWiPetvWCq09efMB43Te9p+iI6YrTXFhl8vxG1scrEMWPPBHnP9NV2E58Xr9JPLclpXEKGwtGFAuhk9zRZl+N3w0h7Mm0g+nPEjkZQ3izHdVwLjRBQoHf950TvnoacW9WV05yAs6v0v3RTiXzobdtmAhjdF6TmbQTah5NOetiBoznxuL7bQioQo0P9kLf/Goolt2Vx6e+Xr6VGHwIxCpfZSAw8glJPp3MQn8gNW488vscW42RPeV9CKUIyD3NMQCtzbz84onMxHZGmfCoqin4r22Ch4OQbAkBnMpjOgRZaD9a1DkaxhSbbuXT3XmNtl4SQYS7/fg7eCAUo4Qiy5mvPDLL+DrVJiS/JkqMddvCfSdnziGj/4m5DvnZkV/nWzkDhVeekfPs6wgfyyi1a1OKVzCi8E6KzEQqVMX/hIsQVJjoJFzO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 8:42=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> >> I came to the same conclusion. At least it's a valid start.
> >>
> >> Maybe we would later want a global fallback BPF-THP prog if none was
> >> enabled for a specific MM.
> >
> > good idea. We can fallback to the global model when attaching pid 1.
> >
> >>
> >> But I would expect to start with a per MM way of doing it, it gives yo=
u
> >> way more flexibility in the long run.
> >
> > THP, such as shmem and file-backed THP, are shareable across multiple
> > processes and cgroups. If we allow different BPF-THP policies to be
> > applied to these shared resources, it could lead to policy
> > inconsistencies.
>
> Sure, but nothing new about that (e.g., VM_HUGEPAGE, VM_NOHUGEPAGE,
> PR_GET_THP_DISABLE).
>
> I'd expect that we focus on anon THP as the first step either way.
>
> Skimming over this series, anon memory seems to be the main focus.

Right, currently it is focusing on anon memory. In the next step it
will be extended to file-backed THP.

>
> > This would ultimately recreate a long-standing issue
> > in memcg, which still lacks a robust solution for this problem [0].
> >
> > This suggests that applying SCOPED policies to SHAREABLE memory may be
> > fundamentally flawed ;-)
>
> Yeah, shared memory is usually more tricky: see mempolicy handling for
> shmem. There, the policy is much rather glued to a file than to a process=
.

For shared THP we are planning to apply the THP policy based on vma->vm_fil=
e.

Consequently, the existing BPF-THP policies, which are scoped to a
process or cgroup, are incompatible with shared THP. This raises the
question of how to effectively scope policies for shared memory. While
one option is to key the policy to the file structure, this may not be
ideal as it could lead to considerable implementation and maintenance
challenges...

--=20
Regards
Yafang

