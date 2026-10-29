Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDE85606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 12:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DY4TNd5n
Received: by kanga.kvack.org (Postfix)
	id 22F086B05B1; Thu, 29 Oct 2026 08:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B8AA6B05B2; Thu, 29 Oct 2026 08:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 081736B05B8; Thu, 29 Oct 2026 08:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD3BA6B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:23:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D87C14030B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:23:03 +0000 (UTC)
X-FDA: 85375578246.16.3D394DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id BA8F7A0003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:23:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DY4TNd5n;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793276581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r6E1IEixHTh8cJ3/xRiHjP84PzUjYGfrYzQ71GFVa4U=;
	b=oX7wABapEcOLo+jGZXpnXAJBmr2h8jYOeSY0Qe420rHsXwN/cjTrmT7lBQdW5xxhwLiVdE
	l80ESgmF/HK78Du3b3KqE5nVMPtGoOW6wnmxVd+qyyyEYB9ztow+8dM1xSWBk2zyYiHAZm
	HPCDcsJqgeU8QvKSRYE0OL4UL3wLXEc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DY4TNd5n;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793276581;
	b=R08veo0L3nV0nzPUek7CD1OQt3GY/zjrlw02SdtRT9TsD5kET9xwE7iV5tRkiw/aqNUDWq
	UBHi1aQrNVLtLX1QlUMUnXzSrHzAQ8dHw15tJcI7MamFEsBg7xNl6/ub/fIvpBdQHCjTaE
	NX8peX13fujZikdUNEt4l/f6BelMg2M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 475C6601FA;
	Thu, 29 Oct 2026 12:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4251F01825;
	Thu, 29 Oct 2026 12:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793276581;
	bh=r6E1IEixHTh8cJ3/xRiHjP84PzUjYGfrYzQ71GFVa4U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DY4TNd5naEMsmhz2lvr3AUxVCOaYTfN4Gh5huITORmh05nN3YGxczRJbuCgLdFe+J
	 v7OZntuOdNvhFvnbYgF2YThtGw9fVrr9/9cL0vchoH46OXubztM3mtbD/Uo272P3lj
	 i6u9BcZ1EVKqwtsEWWG0OfQTHx4vPmadUmRIH3vEsCSc2y6NQsCyf3iNJyL34tBuIV
	 tdO9bh3Sb6dKTez4oQaZPhwLKSVgv1PXv8DbihTyGae+HrBtyCAemi38u1jMlgFSJ2
	 8USRGvYOnpsYW8Q6vkYcY0phhNtH4B2af+3Xiyq1K6mZEvlG7nTzlR6an8TQiaUWZR
	 rHL8n/kJ/a/Fw==
Date: Thu, 29 Oct 2026 14:22:54 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Ivy Lopez <skunkolee@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, fvdl@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/cma: fix range selection in
 cma_declare_contiguous_multi()
Message-ID: <auM6nqlB9FusAr4B@kernel.org>
References: <cover.1792032699.git.skunkolee@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1792032699.git.skunkolee@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BA8F7A0003
X-Stat-Signature: ptu4h9gbqdnsfgwwf5h4yayojyxn8w8b
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793276581-862376
X-HE-Meta: U2FsdGVkX1+lhTBuLWyDB0mFXTUgaAMu7ET6eCdoXNaT/wM/cAzc3dybt8ddrzYS8iNr0ZUsXLmcA0Lzklk+OewjtSnTGexBpVKIw/9R1C5G28HfkystkY6Hs9jvJcSSfeQ6ttsWWN8FMbSFEhneoUcOlC3muG8NMJVSKCJ+XKFumdCNYoeJ3Egw/ydvvrRDOigsks9wpijTIalcc/+gFE0zLeEV6JqwVrz0KAZ7S1ZBCxnjN620Gi3vfj7IAgLJaaG3lOpXm1MdKhEusk0wb00q46FJ0z9BxSy3wbWewtO+dQGzUK3bHLuyhtsV+XDLvjt7I4OjsFQpHYuVaw7wvMj0hB3d4V9HU7E/QS72Dd9PT8y4DSWwJNzWHMhOn/SkzdnGhjIZZ0kEVk9En0snzmrDDQ4JJ8+R5JXhVeYKA3r4XRlDaMEdqX44ntN5wy+1F4+xdKlz5+H8OprVQCMZp45Jr+iKvLyDvAjyBYDnjKLVJYkGi1wvke/zAW+8x9g/hwMOapWY2MaPPCfL+NeeelpyUPb2Ip6DAxb9Lsq7kSunH/uJr9kJUI0Ch9DEPs+SxlzOJVwF8faCbICZhjlic0uW4VKVhspFjQUJsDCMvH2+fM+dIYS0Bh0OroM3fujl7gwN5BcD1qGsxefnuQnnGj3nnTQfFDmsZPSXHknDjIe6YAxVyd8jZIbSSgxUlfblAS/qbuuojTUJjTN6QyXGA5IhsMwbvTZJBUXWlNa+mit44lXPIa1U2WmSZblJEcJv5vCUv0xIXnY2cwhXx4NXmNiNe2zMKm9NSbR6XGy56CSR6Ero8PX9Kz/evy/k9ocPm3Ih5xVBqpRRpsUS07ndIH0d1KXWt7kICAtDGVOrKuMg3eIolranszGN0desS7cQCdFlp/pjEAIehD5+Vm5++445pYt12Z4nyB3Ih05yXUd1gY9fwQGlDyOBralwlQNPTBVbprtLUC/wZHIPMYA
 8EOq8+jc
 k047kJkuvEhgIZFDfqc90yXfh7Pn993sdcJrpABl9Bt4jktvzAkK05IVqSx7x5ad8L379+xiJ9AfMYIJKpRfQvre61WfkRv+/1WSnHn6zY0HjvmvC3UY2MFZRCeL0f724MLR9Mboq6atiZnqaHKLWeiJJM4zXV/Eub/W3mASugRFZZX2RCR01A+LDmrZ2sKoENO8FgGLl46u4lGPJ+uinEj3LCGKUF77bbrhICiRBne07AeNOCpvjBJ7Nj5uMj6SnnCkRUJIh0mt2jBm3kF3d7Z8Kc2vumyvXJv6zGM1DDV3NctWzV3wIVRwGTULtV+pWAh1BlO0GbLtGxL3+egNBYHKbfzqaLP8bG+Ma
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 14, 2026 at 08:53:39PM -0600, Ivy Lopez wrote:
> These two patches fix two independent bugs in the multi-range selection
> of cma_declare_contiguous_multi(), found by code inspection with the
> help of an LLM (both patches carry Assisted-by: LLM).

cma_declare_contiguous_multi() seems broken in many ways.
I'm working on a patch to rewrite it.
 
> Patch 1 fixes list_insert_sorted(), which does not actually sort: it
> stops at the wrong entry and, when no entry matches, inserts before the
> last entry instead of appending. The caller assumes the list tail is the
> smallest recorded range and that the list is walked largest first.
> 
> Patch 2 fixes sizesum counting the size of ranges that were skipped
> because the list was full, so the sizesum < total_size check can pass
> when the recorded ranges cannot cover the request, and the function
> returns 0 having reserved less than asked for.
> 
> Each patch fixes a distinct failure and neither depends on the other.
> No kernel-level reproducer was produced and nothing was tested beyond
> compiling; the examples in the commit messages come from a userspace
> copy of the helper and the selection loop, written from the source.
> 
> Changes in v2:
> - resend as a series with a cover letter, as requested by Lorenzo
> - commit messages now state how the bugs were found and that they were
>   not tested on hardware or in a booted kernel
> - add Assisted-by: LLM
> - patch 1: correct the sentence about the first inserted range staying
>   at the tail (only until it is evicted)
> - rebased on the current akpm/mm-new
> - no code changes
> 
> v1: https://lore.kernel.org/all/20261011003059.169430-1-skunkolee@gmail.com/
> 
> Ivy Lopez (2):
>   mm/cma: fix list_insert_sorted() ordering
>   mm/cma: do not count skipped ranges in cma_declare_contiguous_multi()
> 
>  mm/cma.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> -- 
> 2.56.0
> 
> 

-- 
Sincerely yours,
Mike.

