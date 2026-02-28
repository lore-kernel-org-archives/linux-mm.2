Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56F001048924
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 00:06:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96CD26B0095; Fri, 27 Feb 2026 19:06:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91ABA6B0096; Fri, 27 Feb 2026 19:06:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FC276B0098; Fri, 27 Feb 2026 19:06:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 699766B0095
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:06:43 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0346D8C6E0
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 00:06:42 +0000 (UTC)
X-FDA: 84491924286.19.4DBC0EB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id B5CB81C0009
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 00:06:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="hPSyK6/5";
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772237200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZgQjMLyBsefVKSZLFOZenbLdjl9yvSc36kLvDM5ApCs=;
	b=RP3DoAdoJ5K9TqKrrjysxYCb8kgyO7K7OYPbxmGKpcwgpk06/v9JQIQ8fUtP3olFZZnOtK
	XIJxtkFNCCSyzIl7eK6bCJ7RjbrBjX8GdbnB5hxRcKkHZpPTBTkb4Ufq/sGjIWTJHatjvY
	BwNkQ4nbXXj4qjBwKM7A0EDNfMyaoEg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772237200; a=rsa-sha256;
	cv=none;
	b=JsFt09xG6VU2bpeQLWSHXaeE1r1Zbix/spb2qJQL3CF3e3U6cPfdFHNfDxEuWUJqod4tDX
	0WVy0+ritc/HP+yia0IysKvvxkuf2pIC+mUrTxlfz6tqVpbtvqd7PUq05kK/s0F0YOeL3u
	ciAU+6ywfHlCkC0s3RBXLKAoBwvW50E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="hPSyK6/5";
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772237200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZgQjMLyBsefVKSZLFOZenbLdjl9yvSc36kLvDM5ApCs=;
	b=hPSyK6/5DXbgLsVoX9ZM8ERQnrvcfthB+eyKV+5vl1J0TteT9OhMsLLAgoGRVs0t0rOZ5k
	Xz9d1OsGiF9O2Yw6Ucx6A+kQifYBnysjS0jw5/MKV5NTCqoWwQJ3MEVFwI6WgdXZmKIm7G
	rhFZm5Kaes8Ry4P1z/OO4/EZ8eoAuho=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-I6eGqY0CPfqu5KqBDExjXA-1; Fri, 27 Feb 2026 19:06:38 -0500
X-MC-Unique: I6eGqY0CPfqu5KqBDExjXA-1
X-Mimecast-MFC-AGG-ID: I6eGqY0CPfqu5KqBDExjXA_1772237198
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-64ca6895833so4036415d50.2
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:06:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772237198; x=1772841998;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZgQjMLyBsefVKSZLFOZenbLdjl9yvSc36kLvDM5ApCs=;
        b=uYVn9YMoxZ3TuymcjtTnJlp9B2nmJR+5+xXE59VHgsu/pZaW5CPqMwoMWs1ubX9WEB
         +/w+4Lxh/Nm6YG6eE2Ou5IQin49kfCMvYhx/DbhxudP/5+gurFmc3C6EYMG52rA4+LTn
         qGottrJAsAugEpqSA/Ml/iV/3phv+ctAYCABcnIaEgc3nAzuOSl15jKAVersdCoyHudx
         Wb+TTu6tUL16uypXYAV+30ULFQapbu5yEaE9+9N6EQwWg41JoJ5VAQ4OG7AYipQIFmGe
         IMc+cNhAb2ucQN255StSaSXYkTxnGuS6Uklc7p2u+NeZDtiphffes7auNJIC3OWwbpK9
         ar7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVQNEGqcLvJ0S50yGIgBgw+YmX2qCaJcVHVT4rmvEoyYyScuPl1TwFQlX4B4R+IUksxaVIVNN20uw==@kvack.org
X-Gm-Message-State: AOJu0Yxr6ZZo7cyVPztjnsyqCDHuUpx9okATz8nKb8+akQ/BL77V3dsc
	BK8N4UPNchjb2HP6HKGU70BOMgslBJR+8w9vaOi8yI7VksE8a8rG7IiUfEUMedcQqhqmIRJlyAq
	eJUmxPC/1XjfqJ5A1hc5axRoZI0uikZGgAogoGnkNCZq6FBrn8HbdThmAWSzs/391zU/fzNvhgo
	DDDdKPLTTzRu261ceyGQBfnUVAS+I=
X-Gm-Gg: ATEYQzwmgws1PqeTAcJ1HpBVreXVfNSxIbRGg2kPYQSQM7Ejm0pno7WuytBzwuYrEt8
	yZJB0BYsGgQWntQ7T+goJTKQmA5qqHTTdq5vO0XEvG7pxFw8CqPtBpuyVAgKS8ZisLa+DhEsIae
	z2RkZW5/2IFhnR+i7rnGphBnDeqSv+xP5veaZqr1sRrCd18p49JhoN3H1Cp5UBc1jN+I3AP/Oag
	1+J
X-Received: by 2002:a05:690e:edb:b0:64c:9a08:9948 with SMTP id 956f58d0204a3-64cc2302f31mr3708802d50.76.1772237198208;
        Fri, 27 Feb 2026 16:06:38 -0800 (PST)
X-Received: by 2002:a05:690e:edb:b0:64c:9a08:9948 with SMTP id
 956f58d0204a3-64cc2302f31mr3708764d50.76.1772237197814; Fri, 27 Feb 2026
 16:06:37 -0800 (PST)
MIME-Version: 1.0
References: <20260226113233.3987674-1-usama.arif@linux.dev>
 <CAA1CXcAYt3OfW_uBTYZgr-dBhg99x=5pUs5uvqtpg+PNJ1KxGQ@mail.gmail.com> <1d3a4e8e-9ea0-42e7-b8e7-d92fb27f80f4@linux.dev>
In-Reply-To: <1d3a4e8e-9ea0-42e7-b8e7-d92fb27f80f4@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Fri, 27 Feb 2026 17:06:12 -0700
X-Gm-Features: AaiRm50atKm0LplrPamqC93Qv4KgvjRMNXj12GuBsNodzUDc90TXdhaD9w6BIXM
Message-ID: <CAA1CXcCygvA9uUJjB-+2J00srnHbiNGwbvcbqpRer8Vy8QBxWg@mail.gmail.com>
Subject: Re: [RFC v2 00/21] mm: thp: lazy PTE page table allocation at PMD split
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, lorenzo.stoakes@oracle.com, 
	willy@infradead.org, linux-mm@kvack.org, fvdl@google.com, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, 
	dev.jain@arm.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, maddy@linux.ibm.com, 
	mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, hca@linux.ibm.com, 
	gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com, 
	svens@linux.ibm.com, linux-s390@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZZH0ugdAk1pYhmpNuxVlccVOIC8FD6QyIGQmFyT6cFw_1772237198
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: sqtdgy9n51kx3ehddy43wh1mdzg7y5ho
X-Rspam-User: 
X-Rspamd-Queue-Id: B5CB81C0009
X-Rspamd-Server: rspam12
X-HE-Tag: 1772237200-13893
X-HE-Meta: U2FsdGVkX1+dA9itcTZrYR/s/mnu65ABgkN/TLKDMvTGdtfGUeZI3jIa9qOgSA8G9LwX6B7miBevPPdflKmPTDZyH99KAGS9uDSRgz3Lyk1tsXkYpSHgyJWLx7RdQWLwOLeb1OtUtWLjiaTT+Aob6H99WwY2V1KV2oIHiflair7DYio61WQhGNWFOTdlEEsAsjY1Q1ZGgwvLQ5LFqWyG4ejyht7yOWG6F0ZH45ei0sPQ+4zwql++tB+X1fWdkxMraifBJgLPh4GGDJxFCQdSPVghpxdQxya4BKS8vo+Orl/NDRmcKdSmfAghclV1LQEfQ6w2dZfkkjrU0VRaWVqrF9FZdw3+IDUx8xykkJEGdIihnJgxtTwknmDLqoOfZQnXL2zj9YL4Nx1Yyymc7ykLmtLYHzcnzU8ZQsCYwjVdIKPa0Ko/wrfTzHxZ4Z5tZ1VjOOp/wAdQzf/xwJB5PV4TUCZGXolHMDiKHQqS7AQhdJn8zz8ZGFdrJUhvPIZq4Brk2jiJCUVRAxTDGozWqvsYskm+FdsNUIs3kU1KEOvRp5VuecZiu9JAPwmchG1MJzojc2nYrB+MdeChiBfSghs2q/YEbngROR4DK0i/3xYke8UDVhIWudfNZW12BtxMgHceAS7PFLrlrIjKtwHcqEpm9kBnfo32aNYBOyYZB0pVVyrHhjXAZ2AerFrSGjFfI5wqikIjboevQrMp5FrTu5RvQXU5/iQWEU/B4PzMF3JOZz5jyt/mCLSDx6a1WcRQ1S1IdhGhTx/kuoXC8eMKGcfZWCai5vVG9HdeX3wXMdytxA3Rl8H3YkhzuUSzAszztGrwpcFknbsk2/m3SKCln3gQY5vzGUfxqeVEkjl8O94JW2MO5IUpUtKJ6CFLny47005Moms67x8RcDpowuS6IHgbEQVh72oMNJqoKO5DnY0rdk0bUVosJYdqhU1xouesR0Idta/Ltezsl8zInwfDka7
 98hwdctg
 318g5cFPDd1kjJxeeTlOgLkMYNcDu+US+vED7OmBFUUc/WxyHhPrq6zMXuYGQJP/0uZS8RIsus7xgtE6sYKxTQNU3Ygk+/cJg5+8G3XdbyZkZXE/9gCibcud1Ffo+QEEld3BeNle8DEghrVHkp45jOZMMtozj9tUUC5Yg6W4TyPEFR4Y57vTtarIEa7D9riG1BTiZ5gtW6Zmog+qs5CNNVU5IWGXu2ziRkcrj3tUkEqeKjtxlE2guGGMH96nijw2bPmrA0yaExfoZpZPtsNkbNQ0MD8cWZd9rrl8F267Yg0G/vyE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 4:14=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
>
>
> On 26/02/2026 21:01, Nico Pache wrote:
> > On Thu, Feb 26, 2026 at 4:33=E2=80=AFAM Usama Arif <usama.arif@linux.de=
v> wrote:
> >>
> >> When the kernel creates a PMD-level THP mapping for anonymous pages, i=
t
> >> pre-allocates a PTE page table via pgtable_trans_huge_deposit(). This
> >> page table sits unused in a deposit list for the lifetime of the THP
> >> mapping, only to be withdrawn when the PMD is split or zapped. Every
> >> anonymous THP therefore wastes 4KB of memory unconditionally. On large
> >> servers where hundreds of gigabytes of memory are mapped as THPs, this
> >> adds up: roughly 200MB wasted per 100GB of THP memory. This memory
> >> could otherwise satisfy other allocations, including the very PTE page
> >> table allocations needed when splits eventually occur.
> >>
> >> This series removes the pre-deposit and allocates the PTE page table
> >> lazily =E2=80=94 only when a PMD split actually happens. Since a large=
 number
> >> of THPs are never split (they are zapped wholesale when processes exit=
 or
> >> munmap the full range), the allocation is avoided entirely in the comm=
on
> >> case.
> >>
> >> The pre-deposit pattern exists because split_huge_pmd was designed as =
an
> >> operation that must never fail: if the kernel decides to split, it nee=
ds
> >> a PTE page table, so one is deposited in advance. But "must never fail=
"
> >> is an unnecessarily strong requirement. A PMD split is typically trigg=
ered
> >> by a partial operation on a sub-PMD range =E2=80=94 partial munmap, pa=
rtial
> >> mprotect, partial mremap and so on.
> >> Most of these operations already have well-defined error handling for
> >> allocation failures (e.g., -ENOMEM, VM_FAULT_OOM). Allowing split to
> >> fail and propagating the error through these existing paths is the nat=
ural
> >> thing to do. Furthermore, split failing requires an order-0 allocation=
 for
> >> a page table to fail, which is extremely unlikely.
> >>
> >> Designing functions like split_huge_pmd as operations that cannot fail
> >> has a subtle but real cost to code quality. It forces a pre-allocation
> >> pattern - every THP creation path must deposit a page table, and every
> >> split or zap path must withdraw one, creating a hidden coupling betwee=
n
> >> widely separated code paths.
> >>
> >> This also serves as a code cleanup. On every architecture except power=
pc
> >> with hash MMU, the deposit/withdraw machinery becomes dead code. The
> >> series removes the generic implementations in pgtable-generic.c and th=
e
> >> s390/sparc overrides, replacing them with no-op stubs guarded by
> >> arch_needs_pgtable_deposit(), which evaluates to false at compile time
> >> on all non-powerpc architectures.
> >
> > Hi Usama,
> >
> > Thanks for tackling this, it seems like an interesting problem. Im
> > trying to get more into reviewing, so bare with me I may have some
> > stupid comments or questions. Where I can really help out is with
> > testing. I will build this for all RH-supported architectures and run
> > some automated test suites and performance metrics. I'll report back
> > if I spot anything.
> >
> > Cheers!
> > -- Nico
> >
>
> Thanks for the build and looking into reviewing this. All comments
> and questions are welcome! I had only tested on x86, and I had a look
> at the link you shared so its great to know that powerPC and s390 are fin=
e.

Good news: as you noted all the builds succeeded, and the sanity tests
dont show any signs of an immediate issue across the architectures.
I'll proceed to debug kernels, and then performance testing. I will
try to start reviewing the actual code changes in depth next week :)

Cheers,
-- Nico

>


