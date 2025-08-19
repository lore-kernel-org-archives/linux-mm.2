Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD650CA0EE4
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 02:41:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A5F46B00E6; Mon, 18 Aug 2025 22:41:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27DD46B00E7; Mon, 18 Aug 2025 22:41:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16CCD6B00E9; Mon, 18 Aug 2025 22:41:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02E1D6B00E6
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 22:41:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 87F3D1DB47D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:41:56 +0000 (UTC)
X-FDA: 83791957032.17.F4B0E37
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id D7BDF140003
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:41:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RsB6ezK5;
	spf=pass (imf09.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755571314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=onFaYc8Oi6sRPr9JC4nOACA346CgKiRanyJ+ix+sgzw=;
	b=uniQJuqoZV/RfsPhiYHGTr2YOk0umjW0Us+B9Z4FtMemOenxeG6rsHdCvduj7FSUGMkCqH
	695p9GHoIFYsObXvDJBgp3GLv3xk6VZ5Tqp4SNJ7wZQX5wh/uYpvSxTa0cYx4Gt+Aei622
	ueIzvdCviqGz9iiQecA4i2PVlIzc1fw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RsB6ezK5;
	spf=pass (imf09.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755571314; a=rsa-sha256;
	cv=none;
	b=Oaa6t8Bvl5v7EuoKHlBgAasvu/xAfViZi7/blsASgBJUSwxkkZLvlrCuvaa14+IPWyj3mp
	nP/ETrjFVan/mpji23XSKaoxYwQsjsJY54EGCewS1ACjRnIM0m+r2iIXGKJKsxoyqv5QXQ
	GxjlMW+f1GmDJ+zbYCeIw22jxAY5zI4=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-70a88de7d4fso38087936d6.0
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 19:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755571314; x=1756176114; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=onFaYc8Oi6sRPr9JC4nOACA346CgKiRanyJ+ix+sgzw=;
        b=RsB6ezK5nemYLtXX9zCCofv7b3hJVj0eLzZH2JxClLM30dEVkgVlX/0VR58JS2S4Ro
         FE3BGqgGbP296Kof24cLxRc0xfTlylvCHjzg43wfvPHgnwfBfgo8ZMtF9bfgeuM+l6cQ
         VRmx/qBUW1HYlvE82g7ck4vlhTz1d70Z7u8I2fwuDrlos3auCA4qPMpX77/vkPRJSG92
         QEotzONs8FeP/GgrYsKeIWALzpmft0/0iso7jGLVFvfayKLajsihDW3bOZwMKHPxpLCq
         wt6gsNT75fIskOxc5m5Kfv5/DZUfd6P/qnImv9/cHVQdUzQWsLAU3+Yw1nY/lc2FNHIK
         zAtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755571314; x=1756176114;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=onFaYc8Oi6sRPr9JC4nOACA346CgKiRanyJ+ix+sgzw=;
        b=AqzDkqNRi6ib2fVkvheqsXGWXnhL9tPaKP/h755UGhNT3r8W2z3WNUfXm6soQ3k+/a
         pDcuIAH/RjidHyNrIvJk410sgnCW0Xdj4uxoWjzs7eF+S9jT/r6A0nKsIMep6h7nmpQF
         KBWNJ44N2dlbeI3WG2aI7lOY7yjwbkepTc6JYFDePz1/uCuqdMZhkjS7nJANNSRFwfha
         5K5MI2ATRmb7GRiNP9RjvGHHDAp8uraIaeAj0iOsUt3UkuzvYWRnGFk2XzmmIiNZQNiK
         NmvtqWr+RtNwZ87kcQx6VhRgTBZdhhYH5TvVtvQbOSZbOFGH1F3+FaUXd9UXxnYd/LIu
         h3IQ==
X-Forwarded-Encrypted: i=1; AJvYcCVT++yhE+hwFZQHxdO2NRzfpwBPBpvSKn9ELLA9N79KVmtWS7uSkuAler/wjMQ6zt5ZVK0TOqaVKg==@kvack.org
X-Gm-Message-State: AOJu0YzpprK4mZJG5GZf8ql/ZC0QgiPY6jUhHDeTFAkR1wGnAKPeupuE
	HevKf5U1VPCvtthI+JkW6HM1Jl7KaamQXVTFOl1kUR8FWvAoISA/3CpKYWVNLQiREX+kflCMLhr
	wKayMgQfiMWkZKiqAvHtqilcA9dakkJk=
X-Gm-Gg: ASbGncvGEznGTbfbEL5QzGFUngq4RKzKCHVwQXCbEWJRnD2mp+cA3QpM4J6/Qy4D5mG
	YlASgDEY7E2pKz/NnNMPnz0MGUEpl5NQkJhMlmIPN+BK/eLGgPnG+dq4ntA1rEV0z6E2s25OY/c
	sMh5inT5i5rmLWiIGNq6pWiLSH40+TiYw/hRudm7cigo281WIIAHEgQBFE5jvAr7e1Werd/Zaf0
	/ue4GCgux+2LV95ujAjRuOwFz3EVw==
X-Google-Smtp-Source: AGHT+IG2MXlbLljqpPYVKfINgcapRgtWELmnw39RaPgPOUN9RmrIkyy05SHyRlG7ZN69YOO4d+fangxxrTuPcoI+Z3I=
X-Received: by 2002:a05:6214:1c8c:b0:709:76b4:5934 with SMTP id
 6a1803df08f44-70c35d3b94dmr11874506d6.53.1755571313802; Mon, 18 Aug 2025
 19:41:53 -0700 (PDT)
MIME-Version: 1.0
References: <20250818055510.968-1-laoar.shao@gmail.com> <36c97fc6-eaa9-44dd-a52f-0b6bf5a001d9@gmail.com>
In-Reply-To: <36c97fc6-eaa9-44dd-a52f-0b6bf5a001d9@gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 19 Aug 2025 10:41:16 +0800
X-Gm-Features: Ac12FXyJHg8YZsqiYvuaFXELA4COS9RCAKmGCWSNlwvRg3bmiOgm4T6wEBjyqco
Message-ID: <CALOAHbAQ=51mfszBN+Bvb9z+ZDyTBuCW_s0EKi+5rDghFvRZzg@mail.gmail.com>
Subject: Re: [RFC PATCH v5 mm-new 0/5] mm, bpf: BPF based THP order selection
To: Usama Arif <usamaarif642@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, bpf@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D7BDF140003
X-Stat-Signature: zaegt9bq4fnhssc7rbb1a96tim33nubb
X-Rspam-User: 
X-HE-Tag: 1755571314-512848
X-HE-Meta: U2FsdGVkX19XxvGNLGXZZ1UF6uXLG1taZrvKmWUd14mWSQXKSFxWCEwrNKqkUVJELC2DKJ90WL2vD1lNR5YE4XrQl1TFHgY+nxkJrKhF0bQTlEkC3myLRiNUbB0w36wIsUdZ35Be426iUQ3pr9hhAUQeoqaUTAdmSygsyUsFePXL2BPbLIsEU1ImZT8u4EYDImRwJTcN04G78j98XxC3YzxeSjPQqHEBBGCOURN4OufK8c0xszj13+aWwJP6+yzkgnr8XZzIBnmuMIcpbq+L86XHhBcrnm6cdHvDRSebJUZ6DP8L/+876CXODRRipxvzN5PIz0Y29Q+CgxhqpAEm+3C6Ki8zvFH2E+JKFXE3+Qt7NAz36FQSlDQ1Y4FnVwwD1/Y7T5BiVUwVGo6K9QzkORb7+Am0cLNHXpnH8z6GlWXDRNDyOaWOqlPHMJwP80Vv/rojGSIITEsDpClmsFo9R6nJ6nTuemkRrQtHa+lnBHmj2NL+0/Y0Wj5Pi+tUJl+LUfx3TrDTv6nKkAcvOypmGeAy0Jpi2IDBkEr9nZ7M8XjciW03hK1bQm78bo6wmupM4lbO2mL37hFEn58iHL8EztyRH1/PDntoH8VCeHiWHTrA1p5zx9gFaHDF1k7xbGsYw3OcXCPTsSX26LcFz8B3/5fdgnWzYTmiOljeU7X79t6fWsjUaSFij1x9VjaSa4WW0LJ22I+oj5nfgs6Hf7dTp0mRmQ5IKiRIs25kAhhuIGE5hFyu5A/aHC1ihUa4nI2aZyfCj5/2IIem5uvFufIEUsi1RSTXYoSk+fdo1ZFPqRIZyIyuMCkQI9X4yT+Uy0KLRXLA773e3MEySqZ2g0drZw+SC/fskVSgIu/CFGWhCWlLtcpktDwNzdu0f40zsoSHh8irDPcH1uC+SOKzyRh6xG1c1r0aIIJr2L+zvoBxr78GMyOyJRTMgsBBz2kmJ1xw77LYmFVQmTqTnQlf+RG
 fDqN+HDO
 eUzDym+4HDJOpB2xHcJm2rAoOKRZe4KXMRmEbWGTkym9nBFY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 10:35=E2=80=AFPM Usama Arif <usamaarif642@gmail.com=
> wrote:
>
>
>
> On 18/08/2025 06:55, Yafang Shao wrote:
> > Background
> > ----------
> >
> > Our production servers consistently configure THP to "never" due to
> > historical incidents caused by its behavior. Key issues include:
> > - Increased Memory Consumption
> >   THP significantly raises overall memory usage, reducing available mem=
ory
> >   for workloads.
> >
> > - Latency Spikes
> >   Random latency spikes occur due to frequent memory compaction trigger=
ed
> >   by THP.
> >
> > - Lack of Fine-Grained Control
> >   THP tuning is globally configured, making it unsuitable for container=
ized
> >   environments. When multiple workloads share a host, enabling THP with=
out
> >   per-workload control leads to unpredictable behavior.
> >
> > Due to these issues, administrators avoid switching to madvise or alway=
s
> > modes=E2=80=94unless per-workload THP control is implemented.
> >
> > To address this, we propose BPF-based THP policy for flexible adjustmen=
t.
> > Additionally, as David mentioned [0], this mechanism can also serve as =
a
> > policy prototyping tool (test policies via BPF before upstreaming them)=
.
>
> Hi Yafang,
>
> A few points:
>
> The link [0] is mentioned a couple of times in the coverletter, but it do=
esnt seem
> to be anywhere in the coverletter.

Oops, my bad.

>
> I am probably missing something over here, but the current version won't =
accomplish
> the usecase you have described at the start of the coverletter and are ai=
ming for, right?
> i.e. THP global policy "never", but get hugepages on an madvise or always=
 basis.

In "never" mode, THP allocation is entirely disabled (except via
MADV_COLLAPSE). However, we can achieve the same behavior=E2=80=94and
more=E2=80=94using a BPF program, even in "madvise" or "always" mode. Inste=
ad
of introducing a new THP mode, we dynamically enforce policy via BPF.

Deployment Steps in our production servers:

1. Initial Setup:
- Set THP mode to "never" (disabling THP by default).
- Attach the BPF program and pin the BPF maps and links.
- Pinning ensures persistence (like a kernel module), preventing
disruption under system pressure.
- A THP whitelist map tracks allowed cgroups (initially empty =E2=86=92 no =
THP
allocations).

2. Enable THP Control:
- Switch THP mode to "always" or "madvise" (BPF now governs actual allocati=
ons).

3. Dynamic Management:
- To permit THP for a cgroup, add its ID to the whitelist map.
- To revoke permission, remove the cgroup ID from the map.
- The BPF program can be updated live (policy adjustments require no
task interruption).

> I think there was a new THP mode introduced in some earlier revision wher=
e you can switch to it
> from "never" and then you can use bpf programs with it, but its not in th=
is revision?
> It might be useful to add your specific usecase as a selftest.
>
> Do we have some numbers on what the overhead of calling the bpf program i=
s in the
> pagefault path as its a critical path?

In our current implementation, THP allocation occurs during the page
fault path. As such, I have not yet evaluated performance for this
specific case.
The overhead is expected to be workload-dependent, primarily influenced by:
- Memory availability: The presence (or absence) of higher-order free pages
- System pressure: Contention for memory compaction, NUMA balancing,
or direct reclaim

>
> I remember there was a discussion on this in the earlier revisions, and I=
 have mentioned this in patch 1
> as well, but I think making this feature experimental with warnings might=
 not be a great idea.

The experimental status of this feature was requested by David and
Lorenzo, who likely have specific technical considerations behind this
requirement.

> It could lead to 2 paths:
> - people don't deploy this in their fleet because its marked as experimen=
tal and they dont want
> their machines to break once they upgrade the kernel and this is changed.=
 We will have a difficult
> time improving upon this as this is just going to be used for prototyping=
 and won't be driven by
> production data.
> - people are careless and deploy it in on their production machines, and =
you get reports that this
> has broken after kernel upgrades (despite being marked as experimental :)=
).
> This is just my opinion (which can be wrong :)), but I think we should tr=
y and have this merged
> as a stable interface that won't change. There might be bugs reported dow=
n the line, but I am hoping
> we can get the interface of get_suggested_order right in the first implem=
entation that gets merged?

We may eventually remove the experimental status or deprecate this
feature entirely, depending on its adoption. However, the first
critical step is to make it available for broader usage and
evaluation.

--=20
Regards
Yafang

