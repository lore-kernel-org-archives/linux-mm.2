Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94CD7606A329
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 14:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GI1pmYnj
Received: by kanga.kvack.org (Postfix)
	id B22966B05B0; Thu,  5 Nov 2026 09:46:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD3F26B05B1; Thu,  5 Nov 2026 09:46:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E9BC6B05B2; Thu,  5 Nov 2026 09:46:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E4BC6B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:46:40 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 136B280A54
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:46:40 +0000 (UTC)
X-FDA: 85401341760.21.BF71936
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 590A34000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:46:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GI1pmYnj;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793889998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sVQyqzffyPn/JePjwjFuckgqFqjcEu2veYv/4AtLt0w=;
	b=hrLvDq/aanBwsAy2qf75TGWGHnAzrAOjlJ2KPsPexb0iFutZAn1G3fOWbBjaPoUN2zg3Em
	p+qotPacKgwH8ZOUakc0u5Qdn6uvtkazaqF54EJylTVaotupqWooLgqU5e6cErW/Pq0JJ7
	JGxEGYt2/xzdl8G5PFOPcxC4hNowVrI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793889998;
	b=IraCPZtZVO8/Dq1HWWd0tk8GcCBjVDRK7Ik9PlZsIT95CGsxN0fhOsLOvHO2DTG9Q1yDP6
	+gEz+Hsb4q6/lOyZxxiCNogRxrgeVOQC8H50pWriUE53AZG5upNC5elRS2DEh0/UtWFLJS
	nIg46jfvN8/zepetHxyyJco6aLuZseM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GI1pmYnj;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 82A7641845;
	Thu,  5 Nov 2026 14:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD6D1F000C1;
	Thu,  5 Nov 2026 14:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793889997;
	bh=sVQyqzffyPn/JePjwjFuckgqFqjcEu2veYv/4AtLt0w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GI1pmYnjC8MmiJ8PDAJYDITXxyfWY5LRI4X58LyejJtpPRM1uX5REyLF5Cy7PFilB
	 orKyo+jKxW+L9WynsldKR/7T6Uat3azcd9Vhml9CyHQ3tTNaJQsPRwLq2fPHv0FFK6
	 7g5OPBzuOVGHRp19qOM8mlYLTX1R183sV8UrRSaJ/ZhWpdRTt03gjnkfdAvN2QAYS5
	 AscVW6QtIP2I0Ttjb52g5R1J6qnOXZIaeN1WJZ87jv9VRcSllvWkNaNpKaJUgf9x5F
	 k5rgymGZW7IzVPmOIDc86T1FltiDnuQmn1BVVrsJAS4I6ziDWfoVeKrr1D/FuveNbB
	 eybP58MbQstkg==
Date: Thu, 5 Nov 2026 14:46:29 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yonghong Song <yonghong.song@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Song Liu <song@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Ihor Solodrai <ihor.solodrai@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 5/5] mm/khugepaged: drop/reacquire mmap read lock if
 skipped enough VMAs
Message-ID: <auyMmGmrW-6WhF4p@gremlin>
References: <20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org>
 <20261103-khugepaged-latency-fix-v1-5-a07ab16ac860@kernel.org>
 <c05cb7a5-35b7-4364-9b7a-a87e54bf0ecf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c05cb7a5-35b7-4364-9b7a-a87e54bf0ecf@kernel.org>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: d6dsqat9qfdcyked11mwk5j15snnq4as
X-Rspamd-Queue-Id: 590A34000B
X-Rspam-User: 
X-HE-Tag: 1793889998-759366
X-HE-Meta: U2FsdGVkX1+dVcn/5EtZJZlhYK6NaMz2TmrBLJkVKCcDvlKcinRXSBzh3cfF/YJ2jO48dhAd+nBSmHRU8GMeIpl6czL2abMTRzZ74SJ22biIstKjs4P1UkzTnNylfDXv4e8V8dFI4oM3dh1XdmHukjw1PVqLeoBiqAQZ1Pw672JZ/5nEtLz89nAoKLbBTeHa6CdXzB0U5bKY5QSgi14TX3MCKZZjf13TBtToOaybVMt2Qr0LCKyDaKoYeWfAM7Xpd7xbJCSBDimyu0X3iR7z4dT2czb5i9AcqvzBUY+7zJr5CP4hOY5SxIlOU3hHs8xo9uJ2BfESGExA8kJwVizHBXXJLq7xgKfw2gRpbqTY8HH5OvyYsd7fBVUL9Rwb2B4/76G4Qdquvd624i7YMav6Dt/oGfL67ommIbh0W7pEgT1bU+U/FbuMqr5bLwV9VFqWno6YRQ3MwhHXF+FpFd4R9LTbQ1AcGWevfmSv1BPDg1XyZuw649aHrFTzzitkuyAEEc4c8IpysO98HDG17Fn9S6hx6VuotR9x5ogEd7giaGo7cXTegvPEGz/XGujHyAYt2Vl8vhLzp4n1ftDNmiKcGJtegIPmG5eSYCJoGk5snqAdQo4PB5HUypWoyxltg449vE3THLK5s1D/Y4vUGRcN1iHWwxM7XTgVNsIZ9U5ntpBXbN6ixCwio5KPQV3wJG3fwryFbsRUYrS5ir0mTJEspzWc5OLKLWrzRHiMGBMZKbwftI41PsD5DxpUtrm1t1ldTalzFy/8UfvR3z8Z+ePR5ngiB9P3xJXXLVN//yjUS6uqndHNcUrzTqqCCDQqGd2MO9NrKnpbM4L/WdcEs6PsTrYf9Ke6AL1VecsmSmJ5miSDFRCtlBw1NzZGNuBvVsJam2WycbmmAxj8f68NzvHwP2r6lL70eyGnXsmuotNECl9Em5VTW5oq1VUpp3PEJ5VZi/02Bvxy+S+xW3hYW8l
 XziBgBoe
 Mg1KaOlPB4DrUCuS+a2Q1hfhgL4LSJn8MHdHg7ijOUYDc/1e7BZ7oyMw5dlKN8p3/vMXB0LB7n0LmXFPImeUBaNBlJ9YSxjaosJ05swulieKM9N79vgRGL0pWFr20Ro7fvIr43/aVhLTIYJ/SXcB631hNLeBaoQKMvHWjBIQ0dAGjYmhm9/6XeFzoKBnV3Vx0uO1OLZkGpYtnsV62iXdOy5ldcp59J5pSzpq6ZIy/nhjgSdnFq+UrWyII5AAUVRPfDUmS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 11:28:47AM +0100, David Hildenbrand (Arm) wrote:
> On 11/3/26 09:27, Lorenzo Stoakes (ARM) wrote:
> >  mm/khugepaged.c | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 216c4b8d28c4..b9c72ee8b421 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -66,6 +66,12 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
> >
> >  static struct kmem_cache *mm_slot_cache __ro_after_init;
> >
> > +/*
> > + * The number of VMAs with nothing to scan to walk before dropping and
> > + * reacquiring the mmap_lock to relieve lock contention.
> > + */
> > +#define KHUGEPAGED_MAX_SKIP_BATCH 1024
>
> I don't quite enjoy this magic number.

Yeah, it's trying to find the least impactful way of saying 'we spent a lot of
time in this loop' more or less.

It was empirically figured out to be a good choice (and is very conservative,
obviously).

An alternative here would be to literally track how much time has been spent in
the loop and if exceeded drop/reacquire lock? That felt icky though.

Another option could be to check to see if cc->progress is, say, 1/4 of
khugepage_pages_to_scan, and then drop/reacquire them?

Since actual collapse drops the lock + exits the loop anyway that should work
OK.

>
> Besides it saying nothing about "VMAS", so the name it self is pretty unclear.

Ack.

>
> I was wondering whether we can give the "cc->progress += 1" a different weight.
> Skipping VMAs seems to be more expensive than we thought.

That could get tricky, the ineligible VMA rejections are all relatively quick
and in any case we don't even check the budget until we reach an eligible one.

The eligible ones being rejected potentially take longer but it could get
complicated.

>
>
> (Maybe we should also just say "skip after X" VMAs in general, whether we
> skipped them or not?)

Hmm yeah true, you might actually find an eligible VMA (spans a PMD) but then
for one of a bunch of different reasons skip it and only cc->progress++, even
though you maybe spent quite some time doing it.

Could keep it simple, something like:

	#define MAX_VMA_SCAN_BATCH	<whatever :)>

	unsigned long nr_vmas_batch = 0;

	...

	for_each_vma(vmi, vma) {
		unsigned long hstart, hend;

		if (nr_vmas_batch++ >= khugepaged_pages_to_scan / 4) {
			... drop + reacquire lock ...
			nr_vmas_batch = 0;
		}

		...
	}

Maybe? Could also potentially only drop the lock if
mmap_lock_is_contended()?

--
Cheers, Lorenzo

