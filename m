Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A200FC98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 13:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B10076B0096; Wed, 23 Sep 2026 09:34:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC19A6B0098; Wed, 23 Sep 2026 09:34:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2276B0099; Wed, 23 Sep 2026 09:34:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6DA466B0096
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:34:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D9966C07B2
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:34:21 +0000 (UTC)
X-FDA: 85245121122.22.189D530
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 107F64000A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:34:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LwVkJj9Z;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790170460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nAi96pIQ95HWh44XRESIidPNe1NFI5clCoocx23jiPE=;
	b=MDcvVpSAIYmR8lUwAhSnjlKqutMIgvktTYOpvG7l8vk89/r9tVp225t+aqlGp1PvoaRX1S
	PTs+Ouz7gVump7Q92oDww/tQNMGsXwYCGYfzf2caJvvuRMIk7NAQVyf3mUPAdu1Mv8DT9D
	h+OgyYcooSyXUF34QRd8jzV+Yxu7f5g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LwVkJj9Z;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790170460;
	b=72r8tOd8C/b9haxmfqI9HhIYYZaC5mBa4tmfz+osQqcaW1vf/LSR5EU0HLZwMHy3TscLPC
	4sSyNH9Gqf/F4Ixko35iFWcZBHZYTBniGYJaeruGBMa33Q0xBjn3lzazXVvte3Of1T6ZsA
	BDE6giN3rp8DSHS95Ck6LlApet1dhN0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 925D7600AA;
	Wed, 23 Sep 2026 13:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1AC1F000FF;
	Wed, 23 Sep 2026 13:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790170459;
	bh=nAi96pIQ95HWh44XRESIidPNe1NFI5clCoocx23jiPE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LwVkJj9ZkDQNHUczf9zcG7g0DgTpgrnyciNJ/Cx7aktOA81IDL4565Pa4ewbNgbnL
	 sOxlBJ0HEeSge6kIxE/QzVDN5gDP0zv/C3w3Zablx/uNLD1Tw42b1DihXctbcdWxvA
	 qEAZu/JL0E0D42ihlsjAJDN7CWFYRBQ5uIcV2gu0bQShATr7as45XPupetHkHlLoAE
	 UaEbw5YtE8p2mo6O0YDwAOTETtZwfbe50Qx4/bcBIf6wGFN2Db7/5+qGLWgFOlj8k/
	 l2XE3/dkDQ9HcGI6hM+MbeGmMg24gbbhpHiS7j91lf3l8I+pmVLM/e+UecWuYd1O/i
	 C07+7kOLqzv6g==
Message-ID: <63f49a8b-cabf-4b93-a7e2-76b62c463a90@kernel.org>
Date: Wed, 23 Sep 2026 15:34:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/12] mm/collapse: declare the collapse interface in
 collapse.h
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20260916093145.4022188-1-kirill@shutemov.name>
 <20260916093145.4022188-12-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260916093145.4022188-12-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 107F64000A
X-Stat-Signature: suikiymt34sp8bme8qryoxf6a1amn8c9
X-HE-Tag: 1790170459-813219
X-HE-Meta: U2FsdGVkX19GoWID2fgYjjH6zzAWgIDsY5f6RR/S7rSnVZyE5O+jadzYT0b4TzzUUSaMqMUyC9QnNRtBejoEX1CijoGmoAgxh9hwv1011+Rkk0vKUF/cOQSnKkCMa6HJ2zjEVlXyLHUX0u3D0oVa20nVfY9hGJ7ni7GUi2CWCKZRID/sEOzZ9RCu47WyyNALemvxF9bkgHdsBuT5P12yKuk2JOWosNvkZwjFvlJrbpiQZQY24yGz6oEgqcBcq/nhKeAuLb0rtafZhdQsRiU5PK5uZclb95tAIrmEEUwSDN6x+d5VVKXoCGuPThml6mW7E5BbAO4XlqMd/TGJQ1jdPMtf0BVedSn9g7EbIKL070BrSFh5JGr64TPY8LM8UdzSVq5mfDOZrGYI2la6u4jKvuUMFUTFsIfP6EOJVlSOCOdU644Z5CQvr52k1L/AldhEpMpInnLOwgICy7BMDoGfEn0RcN0MtxxDklSg6ktkn9UL+WY6/cxQoOEzi10fDschlPYrpUQ6tIlBtl/+9Qm2Dip7AQ0AOPKwsc1QZqXn6fh+x8P3w4h7LeBh/xfKIHQHh4TLrQZEL9gkhXe/g/K9OUXQ4N0WQU3W6mtISsBM6y5886wg60XCx+2lv12XAPde59l18EGcHA9KLagRS7NVRZq2nRty6A37KnZGD7T+fAACdFyWxnX2cTVtjZAe6P5pS4N9H3n5kD2XL/1fxKyUjKkFlpBf47DNyiUvGv7KZwTgE9fNefUDoPVd8SJTxkozu79Yne5aATPDzN+iUoqzFnrDI3XGg3/4tpm6cWSwlPerWZw5z/pbgtT6mifkjMKTOuM5EsI98qchPpU1x3c7vOitBWT4u5gC5rBaUXt2FDiw6Kv/OnceDMG1hub2qewvnYL6mUps9X75yW+LhwRZ1cclVl/vl0xVrGQbOeRlOMqnmB8pdgeex4HnvrWdM/5ioabW6e+94CkoOdXxZ0T
 jOEsKWOw
 mI8LiWIXm+92yGRAbrQ4UmjQdTzByCRTz4TIIvnxCBxyDkIrdS2Gssxn/MwOPU8gdNFNdweI3wEI/yHFv/17qmmIfeauHDb/M6bWPgTWCGEV7yBne10P4sbUYwIRUbN93MgINO5j0IkJNihucS/0rCYNfbKIuYliWsnIqcR2/O8MBQD89yoA6q33FLH7TP+vE/BjJqBaGNnyxq58Y5JWFfkJrC6RcVPG8uO3cLkxLzCWf/uuYMtflut8NXD6wrrS3VKo8NOEuU1UoA5jeKg623eDFJMY7KX8/l85PhH7N+cL178WQD/zHHoyRIfukJPs4My6i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 11:31, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> A collapse takes four calls:
> 
>   - collapse_control_init() - set up the control a caller carries;
>   - collapse_scan_pmd() - scan one PTE table, under mmap_lock;
>   - collapse_run_pmd() - collapse what the scan found, no mmap_lock;

As discussed, having a single collapse_pmd() function might be cleaner if that's
easily possible.

	collapse_pmd()

>   - collapse_control_release() - done with the control.
> 

And as discussed, I hope we can just get rid of a release function that's not
actually supposed to release anything right now (unless I was missing an update
in one of the patches).


> All four are static in khugepaged.c, as are collapse_possible_orders(),
> which says what a VMA allows, and the revalidate a caller needs once a
> collapse has given the mmap_lock up.  No other file can ask for a collapse
> without them.
> 
> Declare them in collapse.h, with a comment stating the order they are
> called in and who holds the lock over each step.  Each function says
> what it needs and what it does where it is defined.
> 
> hugepage_vma_revalidate() becomes collapse_vma_revalidate(): it is part of
> what a collapse offers now, not a helper of the daemon.

Is it just me or is collapse_vma_revalidate() an odd part of this interface?

You'd expect a matching function that performs the initial validation on a given
vma.

Maybe we should have a

	orders = collapse_vma_validate(vma)

that really just wraps collapse_possible_orders(), an expose that instead to the
collapse users?

So they'd use collapse_vma_validate() to then call collapse_vma_revalidate()
after temporarily dropping the mmap lock?


[...]

> -static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
> +enum scan_result collapse_vma_revalidate(struct mm_struct *mm, unsigned long address,
>  		bool expect_anon, struct vm_area_struct **vmap,
>  		struct collapse_control *cc, unsigned int order)
>  {
> @@ -1264,7 +1264,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm,
>  	}
>  
>  	mmap_read_lock(mm);
> -	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
> +	result = collapse_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
>  					 &vma, cc, order);
>  	if (result != SCAN_SUCCEED) {
>  		mmap_read_unlock(mm);
> @@ -1299,7 +1299,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm,
>  	 * mmap_lock.
>  	 */
>  	mmap_write_lock(mm);
> -	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
> +	result = collapse_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
>  					 &vma, cc, order);
>  	if (result != SCAN_SUCCEED)
>  		goto out_up_write;
> @@ -2741,7 +2741,8 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>  	return result;
>  }
>  
> -static void collapse_control_init(struct collapse_control *cc)
> +/* Set up a control before its first scan; cc->policy is the caller's to fill */


Kerneldoc please. Applies to the other ones exposed as part of the same
interface as well.

-- 
Cheers,

David

