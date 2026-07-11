Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E441AC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 08:27:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B80066B0092; Sat, 11 Jul 2026 04:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B30556B0093; Sat, 11 Jul 2026 04:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1EBA6B0095; Sat, 11 Jul 2026 04:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C8876B0092
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:27:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 072A81C8F05
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 08:27:48 +0000 (UTC)
X-FDA: 84975817416.24.0E5209E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6D98F120007
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 08:27:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZmJcywno;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783758466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o+9YUEALLTL+0259dlnNxroPvNI9JdmPox5B/61vnaM=;
	b=lPBJcvGw3I8LdIkO6P7mXmypupW7eRyfGSM6W1FNR1nAIDpwoUvhFI8pMLKDoKL33ssqQJ
	XUlzFGpfziGKsgVKYPflbrv3spQf4waupihGlhRAb8eTV4wjpnPhlTZrYrCKXMJuyJh4aL
	inDcvh4BeIywpnvuEDrvvpvfXa6n77Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZmJcywno;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783758466;
	b=4re/NW9hT2FUs58d/xvoJFpbUhlBn+7rD0zDhPvFD1lJrHgBLDZxre1WJCNT5Zp+4ixUUc
	+SCpMQ6PIrueuHtUSnobddG5m2WL8geilMrIFp8oqdqG81U6Wo4edhJxboX7KDnCI/8qwW
	rGzZkYpPwbMId1/OTqrkrqargFnSjgg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 12BBD60051;
	Sat, 11 Jul 2026 08:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AA81F00A3D;
	Sat, 11 Jul 2026 08:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783758465;
	bh=o+9YUEALLTL+0259dlnNxroPvNI9JdmPox5B/61vnaM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZmJcywnoP8pPUDaImC5Qgcr5kg1sl/cTQdYsbPJKkAaHXp6XTAodQLk25zI+RO+E6
	 vlVmvzA8B51o5fWTM6JdeeUL+Xfa/Pzo8JNGor0Rtswishsat7zGPuRwOM8FBSzsiw
	 JlqJRXxL6R/nzkixHrrVUf7/Uzkc2Xjw+6JIp7obqP9nVuhOnjahos/YYoSJc6EgU1
	 k1x1QFlXGk4pOumZZpLv/4Tql4QK4/6sN5TJcXixaLH+zP/PKTf8vKR8bTq2jUU/s9
	 C5y2Xkvg1AQdWKQLXYIFaHwKaPOFVU8foh2ckIST4j6o+HWI2vh5P/wM+2vdKMVsr7
	 ToCVy8ckpgvFQ==
Date: Sat, 11 Jul 2026 09:27:32 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Carlier <devnexen@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, stable@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH] x86/mm/pat: acquire mmap lock on page table free to
 avoid ptdump UAF
Message-ID: <alH8fAnP1JlevCPU@lucifer>
References: <20260710-fix-cpa-ptdump-race-v1-1-d898699a7417@kernel.org>
 <529e37eb-ad4c-4b0f-8ba3-c5608aa7a893@intel.com>
 <alE6fUJZzELlUfxP@lucifer>
 <f2af8fae-62b8-4c5a-8f8d-594b93912dc0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2af8fae-62b8-4c5a-8f8d-594b93912dc0@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6D98F120007
X-Stat-Signature: 3qia35yr8k6yu11pfmiofkfun7moskoi
X-HE-Tag: 1783758466-213676
X-HE-Meta: U2FsdGVkX19hDx8oz5hgWw23FU/DMF9bBkZrNKmOnSvHY0ya9iw7xElCedp6tobVbyEHoGJtdfR6AdXBmifsMEdjVo5GsTy2X4SshkIEgee3fUgFX+pq50w0IOHmQJjkGANkrcVimkUZhcXPGGwrgXhsa0tNLU+FbvXpSSrnH9C3n+5wpcbTSynxtM+ubiihjfGmTsS3XWdEqQauKms7wvJ9l5pDzsWaS9q2MYcbUS8+ynA4+fJlIzE+aXHDPVdeP52F4qniJ2l64CWCwyEQUdFVSFPPUKvPkVwDK8yor3RxqV3BJ81jy4+Kwr6ALtxO0ra1a6R7P7PjOGQF0z7UaVZUx8dZ/8HKbAzbLdvMV+Quy9yFOtVDvKVzurUEy5LiAeMQj0eYOZZtdG7MFca9ERkNDTMriy9Hg7qv4NhXmNXJ9BAgHyKXwbcBhvmfkpR0WV64zSAREX/HjdeaBTFoHqMS8WHNnRzRNsnsoWWb9qyE6Fpk83IrixLxT0jobBvmRJyqIFYOZk0eAmOywpSG2S4C3t6d4xqpWzhdaQI54m+yWs6pXpGosXzG3ragvgROYRb1wBwe3Ky2waH31uJt2II7FZ0ApJGij/OLD9Ozzn8ra+ZKZMd1bDbcGP5XHehh6J1od7VJnW1WZJEC8D8qCr4OyNo52kAjnM2A8a/R+HqTq5PgXGPemBoLsFwjGXgFnp9h6QVekSn13rzfIFWfivYhxCxM0Wms442GTg7r8CFgTsbAZr9ShFnLjPY+a/uLRj4hLz3/bBis7wSaQ7+jULsy3yw+L+aC+zPMNZJUcgqSQY+zuM04DgrFIWhCZ2NLeTWfSQXKggL2oWtgRWXGrYBfs3aShAK0xw/uA0G2eYeQv7Ey3c16T9F1jxoeIxSVofD26hzD1QboqCUW9T+L8xQbDsMKEic7yHdiqAMXPyUAoFqSezI42aq6Ayg85gf8UmPu7P0o4tNXxXnpFLD
 EmXojL6U
 Wnz2V7/vG7az522KNIsi7l5o6SLcsWDH4n8iTGn25QeactA8a7TH2GGTsaystvonh3gsDCQBB7b/LaKkjQYYs9bkptqmARev95uGWf5R6pVqmkcWHhQ4R48sO+FDug1M0FnESO3Ck+XhR5cYCAlsK6unGbrZt4BdOxzgO/0veGzAcQpJuZCBki0yDZzJpAE2HzL4zHPbdMsi9CgBBxvDtSkwrPzvUTFvGAJ283kObTHyTkCWHAOd+tb9OqOCbJXNvpJBL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Brendan for fun's sake ;)

On Fri, Jul 10, 2026 at 12:50:26PM -0700, Dave Hansen wrote:
> On 7/10/26 11:53, Lorenzo Stoakes wrote:
> > On Fri, Jul 10, 2026 at 09:26:48AM -0700, Dave Hansen wrote:
> >> 1. We could just bite the bullet and have separate ptdump files for the
> >>    top and bottom of the address space:
> >> 	current_kernel_top
> >> 	current_kernel_bottom
> >> 	current_user_top
> >> 	current_user_bottom
> >> 	etc..
> >>    Then the lock you take is dictated by the file.
> >
> > I mean that'd break userspace though wouldn't it?
>
> It's debugfs. So, yeah, I can see it breaking things, but it's also way
> less of a concern. Nobody ever complained about the new PTI file getting
> added in there.

I wonder how many people use this :P but I expect some do and would moan about a
_removal_.

I guess we could have a warning if somebody used it.

>
> >> 2. We could always take both init_mm and current->mm locks. That seems
> >>    icky.
> >
> > It's actually the least awful of all of these I think :) and the one I
> > implemented ([0]).
>
> Oh, cool, I missed that. That's a good pairing with this one!

Yeah, sent it separately as they stand separately and this already addresses the
init_mm side of it anyway.

>
> >> 3. We could have ptdump_walk_pgd() take a different lock for each
> >>    'range'. Logically:
> >>
> >> 	if (range->start < PAGE_OFFSET)
> >> 		mmap_write_lock(mm);
> >> 	else
> >> 		mmap_write_lock(&init_mm);
> >
> > I don't love this. It feels a hack for x86 that's put in the wrong place,
> > i.e. core code.
> >
> > And can you can make this assumption for efi_mm for all arches? Could other
> > arches might be weird about this?
>
> Yeah, it's possible they're weird. But I thought the whole idea of
> efi_mm was to reuse the non-kernel part of the address space. So oddly
> enough it kinda makes sense.
>
> But, yeah, I totally get the reluctance to do this.

Yeah it's all a bit sucky this :(

>
> >> I'm kinda leaning toward #3.
> >
> > Another way forwards might be simply have the caller _call
> > ptdump_walk_pgd() twice_ once with the range set to [0, PAGE_OFFSET) passing whatever mm
> > != init_mm, and again for [PAGE_OFFSET, ~0) passing init_mm?
>
> Ahh, yeah, that's a good point. It could be done a layer up too.
>
> > Are there cases where you expect to see a delta in the kernel range in x86
> > for an arbitrary mm?
>
> Are you asking if current->mm->pgd[255->511] is always the same as
> init_mm->pgd[255->511]?

Yes :)

>
> I think so, except for the LDT PGD when PTI is on. That can be different
> between mms, and it's a single pgd_t entry. I think Brendan had some
> grand plans to use this PGD for other things for ASI as well.

Yeah I wondered if PTI or something else funky (Brendan's mermap?) might have
changed this.

But whether that'd actually be accessible from the debugfs "this mm's "?

>
> So, yeah, the upper half of the address space is *normally* identical.
> But PTI plus set_ldt() is abnormal and we have to deal with it. The only
> times that code frees page tables is at exit time and in an error path.
>
> So, how does this interact with mmap_lock? Surely, someone looked at
> this recently because the comment says:
>
>  * Lock order:
>  *      context.ldt_usr_sem
>  *        mmap_lock
>  *          context.lock
>
> and not mmap_sem. But, alas, I don't see any mmap_lock anywhere. Someone
> changed the comment and didn't look at the code.

Was a simple mmap_sem -> mmap_lock change since we renamed the lock right?

>
> Is there some mmap_lock interaction that I'm missing? I don't see it
> _anywhere_ in the ldt code.

Presumably dup_mmap() -> arch_dup_mmap() -> ldt_dup_context()?

But I don't think that interacts with the init_mm nested lock stuff we're
looking at here, as it's not touching init_mm and in any case ptdump is
unconditionally taking the mm's mmap write lock as-is without issue.

Cheers, Lorenzo

