Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 738DC606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 22:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oIwZ2y8v
Received: by kanga.kvack.org (Postfix)
	id 5E71F6B018A; Tue, 20 Oct 2026 18:40:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 599616B018F; Tue, 20 Oct 2026 18:40:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AD526B0192; Tue, 20 Oct 2026 18:40:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CF3B6B018A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:40:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7CF251603B3
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:40:40 +0000 (UTC)
X-FDA: 85344475440.04.21B9C6F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 932304000A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:40:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oIwZ2y8v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792536038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=84jZLGzTIT4Sj3i9FX7tcYRkNT2fyVWLYZ5z8y+jcQs=;
	b=k3/TLLKLo17iKFlpGOmXZNaCP1X2/uCF98HtBWAvLN2OiAdAvuYqP4kNyaQ5rPSEjjIK5p
	qDAWpt2hLRP8yhlDi2Vrz+STVWrxRz2k7z4zmPLesylDb78/LyKX4Qdh94KsT1wqX0JBI8
	yDdkMNtarVlNpD3pPVkN1N/3bizd2dA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oIwZ2y8v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792536038;
	b=ykUKjf9+nNJRvPkePO57YI9Loa5EFXXlJOX7M/8bs/L9Yxj9dT4yYA8ApUeTHPrNp8jzUz
	mr9Hol8u+neI4cMx36Pjf67EByoqB3JOmgS+qRD7gJDIzbOtUFzOiJkXteIXjxilKwEl0B
	NoALE60m69nlD3O+bmKRyUdsTYgliFs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EA7543F63
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6861F01574
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792536036;
	bh=84jZLGzTIT4Sj3i9FX7tcYRkNT2fyVWLYZ5z8y+jcQs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=oIwZ2y8viELTIUIyDEDuwjC6IZqgsuxpY7seZZTPVzwbr8SnvAbVEO12sYHp9gEdI
	 rFJ7trUK5Cp0XvFJCE2O7xsbULGznKYVwiImeNAog0Y0D0Q6JQXXYS5qLlwvWxK126
	 SOI3D7U0QcIeh2EpI5uyPSD78F+onhIKdNcnMz6KnS27hEDnTJyzGuov779fn69bbc
	 vLDJ8LE7yl7eEMsEm7BAFDCPqOM2npdq77/hvfJF89h7C0ppRqa6unNkx/r1l0NKGR
	 xPrbpSVMbLWgs2JwlcUQwbFW6ZGFGOC3yef4L3vLDVMLDZwBrn06XTSV9Aq3YUboVX
	 TXRgORDAKzE/A==
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-917997ab0d9so1621306d6.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:40:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwSVBzhFoOW+fvLyOsC9+1b7z5hxmOB4vjLUigfkmvJ/JIvpJ4ga9Iin3F09hB+oynrVfGEtT++tw==@kvack.org
X-Gm-Message-State: AFq9FYKXh1g+axNHHb/WJDA0JT7RSzsWZRPR+kEWMWi5aj5E7iptVAhg
	/35hUIISNxrJ+8x7xA6oXFMA+9HjCB+M0ZdLp7tvi8SDlHou+ixIqzGq0yoLPpiTaPZ2jKSeoCK
	X1bXkarzRW1luMO0XxhZWwM7Sb5O1sYQ=
X-Received: by 2002:a05:620a:40c1:b0:93e:6283:eba6 with SMTP id
 af79cd13be357-93f57f1cf03mr122558185a.38.1792536036147; Tue, 20 Oct 2026
 15:40:36 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261019230646.3510790-1-joannelkoong@gmail.com> <20261020153648.52636815691868735e9699be@linux-foundation.org>
In-Reply-To: <20261020153648.52636815691868735e9699be@linux-foundation.org>
From: Barry Song <baohua@kernel.org>
Date: Wed, 21 Oct 2026 06:40:23 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wq8jii0HozMonGej+2O5k90DB4ii07WaBHoOQOKQDokg@mail.gmail.com>
X-Gm-Features: AclHuK8ovGRhlv1AIzUCiEbFfOLm2OwfNkpHY-6qkuv3aKlEYhCczyrQk4_0jvI
Message-ID: <CAGsJ_4wq8jii0HozMonGej+2O5k90DB4ii07WaBHoOQOKQDokg@mail.gmail.com>
Subject: Re: [PATCH v3] mm: unqueue deferred split folios outside the lruvec lock
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 932304000A
X-Stat-Signature: 41pdp9q8gguuqcxw7setw3f68c48wxgj
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792536038-732394
X-HE-Meta: U2FsdGVkX1+x10V0GUNaeUyww1W4zTA6PhvMk3RGHvUDAgFoiPknc1nbtOOytHeiEmhgXTUIyGfDIRWficvZjMkaKvsIGJdLxZCXwwtXzEtWNBrR1qSBwlOILDKEuIGddUbbXHzSsnHJ4Bynt8ooIOSIrpLBGTRN14CxSaMqWeJ4+Idyxe2uQrF8Oy/6TwJyWOCQxRjVac1EbfQizNrbqllZjEiSFIvZLwV8AXEFk71IYe5F8XXydXvbd6Srfdur5WvradI9ECzjlzRs7as/zzdYwgM+uqVdI1rLfYAIp1ZjowKVt4Epc6bHihpZHmxtocKYjB7Ud84rliJhsG3to0/cU5mEUiNG8nOsTglsKx+5skORxpYQIqGGG2kLQi8FPhdXk3hGP1J15QzSMtR8JH1vqYkeLG52jW5il9t4LhOImFpEIXA2cvbLocC3adPAmKjyYagAyWb8z8RJ9tfj51xjQlFgR+wQb/YWHzwx80H3fx4XufrPD0DkfPoqWaFSXMu4sgazakir5mpzRUMvHgMvAx0i1uJMrmH6/qOZT2XVJ8ME/LxF3xOe7+KxYae0p/39hT/CfsujDPExl5JGdMnfvZaa5OlDeCH7MUdwF9MUP2/fBjO9OC84mU1DQjO0mbS90wqsf2OD9CiZsGBzICwDm/XMGY5S2WgFLaPAQjuMjTd+7PRqM8ISGVIYzwPFLzuyXD7aM0720TdAByBVVwutYar7dxHYE/IcTBBb8v26AOKkf+s0y/8Ba1VhfJpowUBlytLUav6W0hftBcEUCgppCDb8zcGGXZZO3wsy2fNwuDJlxsBaT9uz1o8RwU8zVCmF2h7ucpemEUVB5lSPAVfSvD3ZyWijmqptewIaDlhGQzUapzgPMrRc+8lUVlNR8HkeMlkmepHJNOWS6P2ap/MfZzzce9+Y3j0hL2PHH1/IBnGv6CbwIoZZBkQgbJgvZ7dq8A0aRW1qH3yBtRP
 DLsvV45m
 XJ4/P0i+sKkH+EcQmLHs6QqxqR9XfG3u4zFIL2uM5Btk+FqUOqzZmO3hxoxUB50Q7VSzSPQJk54AsKi1lmtGNwsSqDVRAc2cEC5fbfIa+N1mWqs5jvr5k+hl/qstIeIfCrVh/UVWs8OCzkMe2mjmB/kvxquH/VKUC4dypt+bh7SYJNgcYsaEsfGMHM0uv5k7qeC0G8wtBzI4Xwejy6sT+KjUPM7pn8/axx+tLCS27I5562Q2hH1LVSYErLXTCiWbuDL8frEZs6DDWY4MWDNK9hkHs9JUnTkWLstnQrwycNZmSCXs0pyuMeByMsv9wcKWREmc07SUZYGez8+I6pkHHe67dA/WCcsnOPdEIwumFdz1BiKh+Ety6HL2JhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 6:36=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 19 Oct 2026 16:06:46 -0700 Joanne Koong <joannelkoong@gmail.com> =
wrote:
>
> > move_folios_to_lru(), folio_batch_move_lru() and folios_put_refs() call
> > folio_unqueue_deferred_split() on folios where the refcount has dropped
> > to zero. In these paths, folio_unqueue_deferred_split() is called with
> > the lruvec lock often held (move_folios_to_lru() always holds it and
> > folio_batch_move_lru()/folios_put_refs() usually hold it for every foli=
o
> > in the batch except the first). However, it's not needed to hold the
> > lruvec lock.
> >
> > The lruvec lock protects folio->lru and the reclaim LRU lists whereas
> > the deferred split queue lives on folio->_deferred_list in
> > deferred_split_lru. The deferred_split_lru is a list_lru with its own
> > per-memcg per-node lock.
> >
> > There are already other existing callers that call
> > folio_unqueue_deferred_split() without holding the lruvec lock (eg
> > __folio_put(), shrink_folio_list(), __folio_migrate_mapping(), ...).
> >
> > Add folio_batch_unqueue_deferred_split() and use it in
> > move_folios_to_lru(), folio_batch_move_lru(), and folios_put_refs() to
> > unqueue each batch of zero-refcount folios from the deferred split list
> > after the lruvec lock is released and before
> > mem_cgroup_uncharge_folios(). This helps shorten the lruvec lock's
> > critical sections, which run with IRQs disabled and are highly
> > contended.
>
> Thanks.
>
> This is a speedup and not a correctness thing, yes?  Let's make it a
> 7.4-rcX thing, for the 7.5 merge window.
>
> I'll park it in the mm-new branch for now.
>
> If people think the speedup is sufficiently worthwhile then I can add a
> cc:stable to it, if clear justification is included in the changelog.

This isn't even a speedup at the moment, as no users have
adopted it yet.

mTHP folios aren't currently added to the deferred split
queue. Joanne is about to add >=3D2MB mTHP folios to the
deferred split queue again, but even then, contention on
the queue shouldn't be an issue.

It may become a problem someday when we add smaller large
folios, such as 16KB folios, to the deferred split queue.
So this patch is more about future-proofing.

Best Regards
Barry

