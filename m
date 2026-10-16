Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 749C9CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 08:19:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FD4B6B0088; Fri, 16 Oct 2026 04:19:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38DD56B008A; Fri, 16 Oct 2026 04:19:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24ED56B008C; Fri, 16 Oct 2026 04:19:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAB1C6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:19:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3BE6C14024D
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:19:23 +0000 (UTC)
X-FDA: 85327789806.27.B41BF3B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 964E1140009
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:19:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ev09OFLL;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792138761;
	b=TsOW6JwP4lnTzSWCfgQUmZMRaU+kYEz0Rt0TZArBvcDB5dCc+2NzER55Sf0xO3nw5qVfWg
	pOb03tPowWUyggQ3l1uapRa04Dy9GvLZMfHfkPqniPaT6rBIJhjZqixtMxOF7CyALCWykZ
	PAB+3EFd+4ACzTI9x+Wnw3q6AWwFhfc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ev09OFLL;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792138761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JN5TVC//3O1ip10wW+8mi89WV09HEjoNN46Wit82ehw=;
	b=xxkjFryQ914iEhvYvz6KQ/C4K9eouewm1npzJNb83N0NmYG4D3mWFfyQAChcqxpSIA7jkA
	5JRog51O4vz+hBcMFyt7AguX+kdqEnJkmb2VF/O4Ge3eiqu/cRr1BpvNyddrGOBLktjy8x
	L8ewjFG3+guVfvnc2vW8vba11i+ikXI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 63CC960018;
	Fri, 16 Oct 2026 08:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB111F000C4;
	Fri, 16 Oct 2026 08:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792138760;
	bh=JN5TVC//3O1ip10wW+8mi89WV09HEjoNN46Wit82ehw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ev09OFLLtBq9nlj0KDPf9/IRstqtsFz6Ma9lLNEXCK2KFDc8mIwCsD6RkeuW1o9Pn
	 L1tsgKuXM3Vc4nO+qGqC/yRqr/LgVTCxJ8JTrRCv80wO74W4u0WZCzTFCeNH/KCsuz
	 Ej+tFS73V67Vigzz5INsrTgs/0GbW9IJRGhER7LjpjNaTh2qF/RErjWDwFIj3wZDMC
	 4600l59QruiRbPJR1xEsyvCpDEgAM7wwLwfQe4XQB0nBqP0WDW7iIQLn9+kLdCx3NC
	 DLUbbWC4bn4uBpjd8S1NyvsLr695f0/LN/geC7Ni3tVb2iTM2ZoRUzHk8W4YChP+e+
	 7cDw+MENd6qTw==
Date: Fri, 16 Oct 2026 09:19:13 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Daehyeon Ko <4ncienth@gmail.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/vma: avoid spurious write locks when mm->mm_lock_seq
 overflows
Message-ID: <atHa3-KlMPg6oy8v@gremlin>
References: <20261015-fix-vma-lock-overflow-v1-1-01beb245d9da@kernel.org>
 <f5548d05-5aec-42d0-b9d9-c14fb575dec9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5548d05-5aec-42d0-b9d9-c14fb575dec9@gmail.com>
X-Stat-Signature: ggay7ktkstepfuuzf9kmqaiddrsyc4rg
X-Rspamd-Queue-Id: 964E1140009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792138761-756673
X-HE-Meta: U2FsdGVkX1+CPMcf53zchTdG3IoNHqbnpZjMtOVZfb3WbwdUaoAW37PsvR+MqRamb2ZvgHBVsUabAXl0COIFxftU9S8FjIBqRY993uPz/tWzuc9L1yMlSrnZizyjQznUas4zZ8csCYoO13BZE3bstMFYMevCf2hvoRXqU/sPBDy5tDcond3WYlC6nkn60IulZ5ytq/fwTk7g5xxi/F463dn2hQAMuuoWB7xRTiXsHGLU7s/N04WyzIyjN58D4kUB+KYvQQ0wLly3p4v4TIynYaoV6Rb7FOZATw223muV2M6vPom1vVEzCCoOysU+29yFCK86j5ml2C/eHWQIneTUPSa675q1R3VhRe62OlMQJRwBTgzj3gkEf5EmM34NMKEM1YNHGZ6OU5hZ/pdKVPfU4hNKlxVaUpUE6pICg73lWdCQfpSO5TSIIPFuM3iMJCnEx7rQeG64tiK2ZHhO462f6RwEuEh1as7fLmni/Vz9iyBjCM5mJbK1bhoV0sFrvc/AFhcc4uMmctHl+Rb95tld4OWyqhX2RQ79X1lfMTI554RGVogCQlTKnigtTdDq00Mr1c0mxeSzKx6c835LKV5VgCWdbEF0jp4J/eTZevdTahrtrKcI4PTUzozDoLRPrsWBfQGhisgLb79mIOl+RLauaeaG8fAae0Q3wP6SK1Up9vLDjPc7fcu3MFyoFGAdF1vxjilnlCdKfzd73hAkECkp/9Nrg0hVczAgqHh8kAQRFpLdLW8kCCNBDmDHoxTAq4qT5TR11IXbbzkC1L7iVBNpeZSSoh2+27Kd82c1b6B/Jcz4jOy4iQkSCx12TPSD5ZBfSHLNJHetRhVhwvmBhyzhkGYo/Wys/32011T/Fks3xKACCxVLSBGrAG4ttCEGVh+aZ+jXZ5WQnBA0tHw1YloiDo/o+VGhnE+WQxl0BghFf4jAwPo/hGtx7TrD69VshxaSsp+iJ2VdhrdaHQ4f3Or
 OUTpw6n2
 mpkIC8fOP5os513cMbtvJrHjArhJOzoOAIQrd+prNK+A5sRVzur8SeCwAX/I3JMIJhguJ7BA9dPsL45OKN/fgFiAzTkB7+MPEE6WLF1F6pY5briMXnFCl7XxlOVVd7xvg+FNXwJvb2EMTDXjyul1N3AsFVgdfzl7eepmPkc2C3LEW5NJpsr6fmDg0Uclm4ky63zVvschTKGZszZsW+4j5LxKdiSB5CE5mwkNKDEkE1yAtYL/Cycq/1NHT63y/Y8TSfCLsArfcb7WrwYXz0/eEGUJHLxoF4YLfXw1TG2LJCZwQeILtYdMHqWSEMXdTCwR/OaP9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It seems likely that you're using AI to generate these review points. Please do
say if you're doing that, thanks.

Normally that'd be totally unwelcome, but both Sashiko + local AI missed these,
and I have made mistakes here I need to fix, so this is actually useful...

On Fri, Oct 16, 2026 at 09:41:28AM +0200, Jose A. Perez de Azpillaga wrote:
> On 10/15/26 10:31 PM, Lorenzo Stoakes (ARM) wrote:
> [snip]
>
> > The reset, performed in reset_vma_seqcounts(), only needs to WRITE_ONCE()
> > the value. The stores follow the smp_wmb() in do_raw_write_seqcount_end(),
> > so a reader observing a reset value also observes the VMA modifications
> > made under the write lock.
>
> the writer side looks fine, but what orders it on the reader side?
> raw_read_seqcount() is just an smp_load_acquire() since d0dd066a0fa2,
> not the smp_rmb() the comment mentions, so the earlier
> READ_ONCE(vma->vm_lock_seq) isn't ordered against the later vma reads.
> couldn't a reader on arm64 see the reset 0 with the old odd
> mm_lock_seq, pass the parity check and read stale vma fields? would
> smp_load_acquire(&vma->vm_lock_seq) be enough?

Yup that's a mistake, will fix on respin.

>
> [snip]
>
> > Cc: stable@vger.kernel.org
>
> the parity check relies on e5e7fb278e59. before that, mm_lock_seq only
> increments on unlock, so locked values can be odd or even. should this
> be limited to 6.14+, with a note that older trees need a different fix?
> a straight backport of the odd check would ignore write locks taken on
> even cycles.

I have a plan for older kernels (just make the value 64 bit...)

>
> [snip]
>
> > +	/*
> > +	 * The VMA seqcount is always odd if locked. An even value can only be
> > +	 * the zero stored by reset_vma_seqcounts(), never a write lock.
> > +	 */
>
> vma_lock_init() now stores 0 too, so this isn't quite true, is it?

Yes it is true, because as the commit message and I think even comments say, the
VMA is not visible when detached, but it is visible when attached, at which
point a write lock will have been acquired by definition, hence non-zero.

I guess I could add a point about attached here.

>
> [snip]
>
> > -static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
> > -						    struct vm_area_struct *vma)
> > +static struct vm_area_struct *vma_start_read(struct mm_struct *mm,
> > +					     struct vm_area_struct *vma)
>
> is dropping the inline intended?

Yes. inline in C files is useless.

>
> [snip]
>
> > +EXPORT_SYMBOL(reset_vma_seqcounts);
>
> since it has to be exported for the inline mmap_write_unlock(), would a
> __ prefix make sense, so nobody calls it outside vma_end_write_all()?

Yup, that's fair, will update.

>
> I tested it on x86 in qemu with KASAN, lockdep and DEBUG_VM on top of
> mm-unstable and saw no issues, but I'm hesitant about the points above.
> happy to give a Tested-by on the next version :)

Thanks!

--
Cheers, Lorenzo

