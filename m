Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEBF1FB44C6
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 08:07:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D67C56B0005; Fri, 24 Apr 2026 04:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D18356B008A; Fri, 24 Apr 2026 04:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2EB66B008C; Fri, 24 Apr 2026 04:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B3BAF6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:07:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 503F61B89C5
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:07:08 +0000 (UTC)
X-FDA: 84692718936.30.23BCF58
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9A38040003
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:07:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WjdZJosY;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777018026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/9G9C3Y1kSQB1x7QQwmzArbfUKe1doiLcocwmb7Q9eY=;
	b=fUznimi9js86zPGdPgiR3JjyGD9pOXeNayy5dr9VtQIIazoBKxkjJwq+QNBx7wUcSCNORI
	i2VdZ6ptC+jUNNd8WxFX1DdiU4Wnmn2M19fJNfZz/hrD5hjkjJ2D5wEmPwoy3+ngG0BcTk
	pqv3w6E6xseslQByWdOU99A4DdHn7WA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777018026; a=rsa-sha256;
	cv=none;
	b=lNk+ePozM0EpgBkTcs7NfU9lE8yCxj4h5TCrtZSC+NbMi4+hGw5eiCQi4bZXgV6IO65dgg
	mbEKfobAA6zHCY7iRNHSFs02N1XVKNHosbsXb3oahB9BpdCmhB4q5UKYP74/1ybr9Zk24B
	a6zxemqy3tX5SZZVlYHh7dY3+B5gKV0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WjdZJosY;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B717360121;
	Fri, 24 Apr 2026 08:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043B9C19425;
	Fri, 24 Apr 2026 08:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777018025;
	bh=mgXIcmsoqBer2oHeUb6xzs1iGKlYykLpK7va+ag9fUk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WjdZJosYQP0LXGEL4Y4EtKi+FATgeWiyx/BmfphphG1sQLSeslI2JTO9EzDSCLJrQ
	 24z1je2g6yUxaVi7CJKgIRbbCvtq9KCsXRjlHudcJcwvjWInpYQL30tSj0IOPa7Xym
	 QrlDZDtpEgndu1xFLnKDSOfIYw0IyPVhvYVtWrbAcyr226i5Zj0LaHph9bj/hQbAgp
	 IO3U9NuVhRYzwvf9Wt1vKUT2VTdD0SWb9YLMnQX+h2VYSv3vmqhaAVzDccKPRfQS4m
	 b+cehSmT7ALE+fgwYFbIfooP5zp6fNTX9wTfQealIJ7IQgb4w2D1rEEj+BvfopqGrz
	 z/H23jYBldARg==
Message-ID: <9b993dc6-f8a3-4f39-b9e3-3b1da29c8343@kernel.org>
Date: Fri, 24 Apr 2026 10:07:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory: update stale locking comments for fault
 handlers
To: Aditya Sharma <adi.sharma@zohomail.in>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org
References: <20260423165609.251787-1-adi.sharma@zohomail.in>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260423165609.251787-1-adi.sharma@zohomail.in>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9A38040003
X-Rspamd-Server: rspam07
X-Stat-Signature: rnw7ethskdpu16pro48o74hf7oooheq4
X-Rspam-User: 
X-HE-Tag: 1777018026-822713
X-HE-Meta: U2FsdGVkX1+wb8vK9hhCInSzdXT09hXp2acWJslFmn7ttstX0eXftmPuEQx0SKrQ8KJdZ9zriVBZGScmhptqMXMLlUlDCunmYcqGG5Iqqny4B+dGA31l6OMDaHTdI7IG/rsE1yCvrab+0vpqBMGvabNAMthncBSnbbwPTMaJjz439xA0fTOIDbw+6OPLgTKaQ5yrt1NLvmoOWLlIu80xIAS6AHzQAp4Dvbj3kBp9owMA8FgtdwulqRPJ9iIfrwfqqVwRX6d6BU1N+7+sl9ifnD7qabgr5FVH9liXHqyqLY7qWAxyBNVtIN7+trYUsrwQp5WQYDvDekIjq0R+1EqBcQi319At3YU1rdHFtdH2kQs71t1qLugYsfWf309jrhNuJv3XaKT2IVPvjEfy/5zDbP/asjR4ohML1++PyFLBczDpk3Y7FLQ/mfAz2byAs5CFc7fYKJyxrfUhcDKhLrY/a4Eg5I9ZvPt1nxHGJ5WT0rb2FmqQNC9F4tw0GSV/wROEOp60Ww00+PmYocDVPBzmGrjMgNthD/fjb00zzeXN0McaW60XwrCJA+ROSpVGHbyasxKiSdQ08WtxnAsKxVcXp8hgnDTsGwt3cCtXTBETn/K4dh2AisuLw+u8T7xcf0pEERLFxplqfQv/tPAyMHvGEMJ5plq7K+bMujIVvup4aG9ttvqWvo/HkKqn6I046m4f7UqUjNHyi6uvQoLcLkTYCeNwGFXTtMhqeYd7nAzAxa2L0nCXck2C4oflnccruu2YBfRDW62fFy1a6bMBKeTGXsKX8zgJb0rjbzU21++9nFsUlXg9yXiSSerhG8HTUUJuCY4Yz/9QhNWAcoFtEWAp0LAlemqf+m9x5rfTitEnf5ojbk+NNhZDC00/xmviFzXPzTT0cEdvytp8GN+pRFYdd6v1KJDCjicZ0i6Y4neXuitJwV+x+b4WDiN4uQGHxRRAn5XDv5nb8U3qY17xm21
 Jw9J0jRB
 x3a0dujbH86QpOLSwy+7V3T/h2jsu2H8YK4DznTQStkmltp6/XZ5y0NRWS/BBVizWsTG+qekaKvsNz+GfmjQrxl8eS40aMjCqE03e2ueDIGze+yqKEE0caU3cIcS9AFurIQF6WTivDnNVQvAqq82eUO78atSunuMxTkJoU9i126pDLn8DubYkkDGDhfwUBVcL8u2Y2f3SfmaEjknH2qkdihUcLnT7j9avfb9/Qy/CO87NtSFl8y7e6yVQg/oj0FiKdIMP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 18:56, Aditya Sharma wrote:
> Update the comments for wp_page_copy(), do_wp_page(), do_swap_page(),
> do_anonymous_page(), __do_fault(), do_fault(), handle_pte_fault(),
> __handle_mm_fault(), and handle_mm_fault() to concisely clarify that
> they can be entered holding either the mmap_lock or the VMA lock,
> and that the lock may be released upon returning VM_FAULT_RETRY.
> 
> Additionally, make the following corrections:
> - In do_anonymous_page(), correct the outdated claim that the function
>   is entered with the PTE "mapped but not yet locked". Since
>   handle_pte_fault() unmaps the empty PTE before routing to
>   do_pte_missing(), the comment now correctly states it is entered
>   with the PTE unmapped and unlocked.
> - In __do_fault(), update the stale reference from __lock_page_retry()
>   to __folio_lock_or_retry().
> 
> Signed-off-by: Aditya Sharma <adi.sharma@zohomail.in>
> ---

Some more nits below:

> - * We enter with non-exclusive mmap_lock (to exclude vma changes,
> - * but allow concurrent faults), with pte both mapped and locked.
> - * We return with mmap_lock still held, but pte unmapped and unlocked.
> + * We enter with either the VMA lock or the mmap_lock held (see
> + * FAULT_FLAG_VMA_LOCK) and pte both mapped and locked. We return with
> + * the same lock still held, but pte unmapped and unlocked.
>   */
>  static vm_fault_t do_wp_page(struct vm_fault *vmf)
>  	__releases(vmf->ptl)
> @@ -4696,11 +4696,11 @@ static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
>  }
>  
>  /*
> - * We enter with non-exclusive mmap_lock (to exclude vma changes,
> - * but allow concurrent faults), and pte mapped but not yet locked.
> + * We enter with either the VMA lock or the mmap_lock held (see
> + * FAULT_FLAG_VMA_LOCK), and pte mapped but not yet locked.
>   * We return with pte unmapped and unlocked.
>   *
> - * We return with the mmap_lock locked or unlocked in the same cases
> + * We return with the lock locked or unlocked in the same cases
>   * as does filemap_fault().

Maybe phrase the second part similar to the other statements further below:

"When returning, the lock may have been released in the same cases as done by
filemap_fault()".

>   */
>  vm_fault_t do_swap_page(struct vm_fault *vmf)
> @@ -5210,9 +5210,10 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
>  }
>  
>  /*
> - * We enter with non-exclusive mmap_lock (to exclude vma changes,
> - * but allow concurrent faults), and pte mapped but not yet locked.
> - * We return with mmap_lock still held, but pte unmapped and unlocked.
> + * We enter with either the VMA lock or the mmap_lock held (see
> + * FAULT_FLAG_VMA_LOCK), and pte unmapped and unlocked.
> + * We return with the lock still held, but pte unmapped and unlocked.
> + * If VM_FAULT_RETRY is returned, the lock may have been released.
>   */
>  static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>  {
> @@ -5330,9 +5331,10 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>  }
>  
>  /*
> - * The mmap_lock must have been held on entry, and may have been
> - * released depending on flags and vma->vm_ops->fault() return value.
> - * See filemap_fault() and __lock_page_retry().
> + * Either the VMA lock or the mmap_lock must have been held on entry,

Do we want to also add a "see .." here?

> + * and may have been released depending on flags and vma->vm_ops->fault()
> + * return value.
> + * See filemap_fault() and __folio_lock_or_retry().
>   */
>  static vm_fault_t __do_fault(struct vm_fault *vmf)
>  {
> @@ -5893,11 +5895,11 @@ static vm_fault_t do_shared_fault(struct vm_fault *vmf)
>  }

[...]

In general LGTM!

-- 
Cheers,

David

