Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60BA7F44875
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 09:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A0836B0089; Sat, 11 Apr 2026 05:09:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 851ED6B008A; Sat, 11 Apr 2026 05:09:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73FA86B0092; Sat, 11 Apr 2026 05:09:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60DF36B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 05:09:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F2C9513BA99
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 09:09:20 +0000 (UTC)
X-FDA: 84645701280.03.C4411C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0433B16000A
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 09:09:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cIj2fH6u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775898559; a=rsa-sha256;
	cv=none;
	b=qhA54m/3ntxX+KruQSNtsSVERQ66KRhbbJpe0V7wu4DQJCV3hSdNrlGcjKf1YAYpM+fEAR
	02VZwZGarW9xh8d5WdWvY+pFQuhRI+FKXOiHiBCiZ1vL5fL7XJxmv30Y+6Uoc7M9VbCh9s
	UZ7GzAQVPFS8TNravDow2lzLWYkxw7A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cIj2fH6u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775898559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=38fDXR1oNt3l2YQzzSSIli1F+Ol/jQv7O0Hh3iV4qjk=;
	b=QHson39OOQQQQIu31XHWi2HXnxrbudD4MT/F0Bn5MNRlkrDCE68NQP/HWzQ7xuUFCjzoiz
	P661yikyhHM3ZoV6dWm3hb8b8JtxHCxY6fEF6PIb4ue2TBisI3XweqZBmPGQUSfQAB0Mnx
	iW4AI/v+Nw/2iOYa+ZP9LbpdSw3sh2w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 10A4644564
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 09:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0EC9C4AF0B
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 09:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775898555;
	bh=38fDXR1oNt3l2YQzzSSIli1F+Ol/jQv7O0Hh3iV4qjk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=cIj2fH6usct+ny1cojV7tTi1nY1U1sj2g2rCE6UCpR+woD/sN4TH7peu2GZIvgm8Z
	 2V2ByYjtS3frpjKjVtLqHzhYoN9wHLXZpRgpsruSwR8Vj4K8miS2luu4y7hcYTkbn4
	 PL/Cn2/IWkut8lAYWUmVSMt9Loc003+L02cUSZ/UdsZP5fSQinYVGtaLosh4dgQlG+
	 IPr8znVpf/37P6XwyviZnILxT4eGIvYImXRWJgyZaLZKRp0x+foAE5KOnYAnKPHTk4
	 9/LwTIJqtUHHgO9zz/dZIADjF9ljjAN2WvzaN0hirEbMIpWgcDRXg6Lh2Ci2GSU2Wz
	 aq2gCaIaX3Rjg==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8d67a483d3eso300187985a.1
        for <linux-mm@kvack.org>; Sat, 11 Apr 2026 02:09:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX2WvEEqYShcWNm4vCLoVoolLDuiJv804PULuv4Xi3V1n8o295jVrMMz+qkgHmMwTCbQYKjI775fw==@kvack.org
X-Gm-Message-State: AOJu0YxlnC+1+REt9uc7cO/kL/QvOW7vW3x/pooRjwsC/iUFyP3RWODL
	bZ0p71I0S7fqkQQzZl+7E7KVsJpd+h1hkytkgxlOaStDHFz+7XiIXKsPgMbsBVGnnwfaxYUlut9
	oC5aIRJ4CpT+yqVVafF/D8CBcwSimLQ8=
X-Received: by 2002:a05:620a:19a7:b0:8cd:92c5:b3e7 with SMTP id
 af79cd13be357-8ddcd8f4124mr835409485a.18.1775898555055; Sat, 11 Apr 2026
 02:09:15 -0700 (PDT)
MIME-Version: 1.0
References: <a3474fcf-9f20-47ee-9d15-233e5c7e3f83@oracle.com>
 <k2ldf7rk6mogzhoe3r7a2hpcc62x2uqqpnwk3czbet4shpirs5@sqfzsqpdc3fk>
 <639f20f3-9e65-4117-af9b-e37af0829847@kernel.org> <CAGsJ_4ztHnGYycwRgh3FaA7gsehJUWG5YY5nMURRBS6BBdqQ3w@mail.gmail.com>
 <peuzimkftq4t7kzyfyykwd2juka7z7h6mxsj7itt2fw6nehnvk@pfhser63fpgx>
In-Reply-To: <peuzimkftq4t7kzyfyykwd2juka7z7h6mxsj7itt2fw6nehnvk@pfhser63fpgx>
From: Barry Song <baohua@kernel.org>
Date: Sat, 11 Apr 2026 17:09:02 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xuGJTiy-aYNuvEVGYdJTQL6-ct_qvZmSXZGdneSfpkWw@mail.gmail.com>
X-Gm-Features: AQROBzB8SdrSWQffgHZdRNJ55q0wqYuqvdMaJBwD3T75zXscPlXDb2-wHbYYyuM
Message-ID: <CAGsJ_4xuGJTiy-aYNuvEVGYdJTQL6-ct_qvZmSXZGdneSfpkWw@mail.gmail.com>
Subject: Re: [RFC] mm: stress-ng --mremap triggers severe lruvec lock
 contention in populate/unmap paths
To: Pedro Falcato <pfalcato@suse.de>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Joseph Salisbury <joseph.salisbury@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, ljs@kernel.org, linux-mm@kvack.org, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0433B16000A
X-Stat-Signature: ifk6wyjfxjs3fq64enukhgag4iz853o1
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775898558-265231
X-HE-Meta: U2FsdGVkX19cfSoplJCkcshY6M/O4Lr6a25SJ9X1jsxssZ7cZ707EtRG9egypsz+A18BfGyHtMCmZ340hOY+bGZCVLjlt9zGB2GzPNTSFqGOScwVFhtnNWgb2t5QNyFrbju2eWK9gQMGBigvSh1nXuKyly4tsMycbN+0hUfK4g88dhs/TsGnN5LPMrrlfRkOUe0IOwiwQq3DHxb0ShalgdERV0Pw3QRIy6XI+Xpd6lviHG6fHRnznHCLV15EXu1aHXrw9qyF1EgyR8jIsHwGXa/cnV14OKhij1GQ9EJANYqM2yilu6JUzW3TqZAOVsP5qfLEHGLK8XjpKh6QAFkJnf023b2Hu9vSwrXoWzVpcK8bo07/XR4cv6OFXidYV5NEXu13rEHEW5rE0GcKK8Q+mhcAgXlZr1XK6lvWVWOkU21mCdo8dMX0N96sbIeZFQSVNfuZnZiWVowmYNik3VVz7kIDNn0NyIzDSIQ5CpEo7yNpX7FMMFnKDlhLFiac109DP4V/BQvI7A+B/q3znRiEleaK6AXqdPSTy83r7VFPm1KTEo1qmo6ViPd0wwMrXob9VU34MYVPlJiqBcN34yo4R/a/nYwI4of63CIj4x23ECUAH2We0CnLaQ6Cb3okpao4MjD3jfQoIo1pjfTckGTdrhV/jyz0zQKWLdTak0nzwumqN5Q2WyF/b49hduX8Kv2UInPqnokTdwEd5Up1iwSWMwHyTraHPUfFrrZUXgRGLQPa2PBpuI+lOzP63HePahzxwdeiYgzASvaRByBlJSLnwDKLliVSH4p5XrgjMEDhkn7KGdMNHLj/OuH+irqY8l+DdqMK/fCV5/jmWVbts9KsTYwmRN8GNAgvI2jEcJ3EvlnzSDTb2vk7X1rkIYwUIfdUAT+Tb3r8/3ZQf+SKU3Q6PANYHMEOCu3KnIG2XUoFDrQbU+eVMDzORZYLL27hL05P5ISRLV5goSjT+lE4jQU
 FltM5YtM
 nAtb5adTpuqQE3j4kwJDLiPDi6VqW8pE/1FtFoWTPqOkkbk/AUf2LAZtcGKv8vXVl98FQEiWvX8uGeqVkJ4/tflHRIydRjs9OZD/HyIbzhKyXKlrE3ULzxbBB94EMNlBPRYjiMQ8kiohD/mt5GxeEvlu74NDYp/nWWdsNtMAoNBxR0aODRHv5HeI5xAl8ledV3JY52fAfZpsTsMwauExhg/nNeh0fotbtH6GnTTsbuTLCe8RMbi9JNWDnXhdoncQwR0+JXOkj46144ZhsML6DnklvUT+aLG5Lds8KAAeffQ2Ikv4Us7ZSfrdbaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 6:30=E2=80=AFPM Pedro Falcato <pfalcato@suse.de> wr=
ote:
>
> On Fri, Apr 10, 2026 at 05:59:58AM +0800, Barry Song wrote:
> > On Wed, Apr 8, 2026 at 4:09=E2=80=AFPM David Hildenbrand (Arm) <david@k=
ernel.org> wrote:
> > >
> > > >>
> > > >> It was also found that adding '--mremap-numa' changes the behavior
> > > >> substantially:
> > > >
> > > > "assign memory mapped pages to randomly selected NUMA nodes. This i=
s
> > > > disabled for systems that do not support NUMA."
> > > >
> > > > so this is just sharding your lock contention across your NUMA node=
s (you
> > > > have an lruvec per node).
> > > >
> > > >>
> > > >> stress-ng --mremap 8192 --mremap-bytes 4K --timeout 30 --mremap-nu=
ma
> > > >> --metrics-brief
> > > >>
> > > >> mremap 2570798 29.39 8.06 106.23 87466.50 22494.74
> > > >>
> > > >> So it's possible that either actual swapping, or the mbind(...,
> > > >> MPOL_MF_MOVE) path used by '--mremap-numa', removes most of the ex=
cessive
> > > >> system time.
> > > >>
> > > >> Does this look like a known MM scalability issue around short-live=
d
> > > >> MAP_POPULATE / munmap churn?
> > > >
> > > > Yes. Is this an actual issue on some workload?
> > >
> > > Same thought, it's unclear to me why we should care here. In particul=
ar,
> > > when talking about excessive use of zero-filled pages.
> >
> > About 2=E2=80=933 years ago, I had the impression that we might need
> > separate LRU locks for file and anon. This could reduce
> > contention in real-world scenarios, especially when memcg is
> > not enabled, but I never built a prototype for it.
>
> Honestly, I don't think this would work. You will still contend hard.
> Having a lock for file and a lock for anon just makes two very large
> locks, instead of one gigalarge lock.

This is true, but I feel this might be the low-hanging fruit that should
at least be able to halve the contention, since the implementation would
be small.

>
> I think the real solution is either sharding lruvecs harder[1], percpu-ca=
ching
> super-harder, or fully reworking reclaim such that we don't need to maint=
ain
> such a global list.
>
> Alas, maybe we'll get there one day :)
>
> For MADV_POPULATE there might be a straightforward solution, though. Usin=
g
> something akin to blk_plug, maintain a per-cpu (or per-task?) list of pag=
es
> that need to be queued. reclaim would drain these lists if needed, or the
> task doing MADV_POPULATE drains them at the end. It should drastically
> reduce lruvec lock traffic (though yes, possibly just another bandaid).

For MADV_POPULATE, I guess your idea can work. But I assume
MADV_POPULATE is not that widely used?

>
> I say "For MADV_POPULATE" simply because I suspect this idea might not be
> useful or effective for regular page faulting.
>
> [1] say, maintain a superpageblock concept that is a lot larger than a pa=
geblock
> (1GB could work? though maybe too small for large machines) and maintain =
LRU
> ordering between those pages. though later approximating LRU order betwee=
n
> the superpageblocks is tricky.

We already have this concept in MGLRU, where each zone has its own
LRU lists (but all zones still share the same LRU lock).

With superpageblock, I feel the difficulty is how to balance between
different superpageblocks, and how to compare the aging of folios
across them.

Thanks
Barry

