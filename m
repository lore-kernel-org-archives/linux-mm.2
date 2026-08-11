Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5CD7C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D2726B009B; Tue, 11 Aug 2026 11:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 883316B009D; Tue, 11 Aug 2026 11:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74A966B009E; Tue, 11 Aug 2026 11:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39FBA6B009B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:19:48 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A94534048A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:19:47 +0000 (UTC)
X-FDA: 85089348414.05.6C53D02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id DE149C000C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:19:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VkxC/iQ8";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786461585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N3sGQ6wm+Gzp0+w751keBcCQghKUsRRShVvsLPMj604=;
	b=7oo4YwzswhvWsTRyXApYGsbkb2RFlUg6dxCJT70VIYmiFsoB/T6gtQh8gL+HLyR9kxfdNx
	WwQIxutas0We1vT2PFRax81I4wYFYfbTZiEy7ZmUYhVwhvDK6X7yV8irptP1ldWfuT0VIx
	EyECCd+fqb9jj68hohsnDW6bQ9/moIU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786461585;
	b=oLBa+OiuKAC+PxvRYKy19BThIR8Utxeytz5DVpXC0mw7O5HgM+PghLr3wahJ5GQ+DU1qfc
	qjkQ7++CZaBVjwCV2HQHHEc9KqTkpBw2aI5e2kqzJ6elCJrhs0FXBQXBmrcPIu8HLhotwR
	LzYG3p0lpoprlzN6z1jUxQNRHadwYgc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VkxC/iQ8";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FC93600C8;
	Tue, 11 Aug 2026 15:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE01F1F000E9;
	Tue, 11 Aug 2026 15:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786461585;
	bh=N3sGQ6wm+Gzp0+w751keBcCQghKUsRRShVvsLPMj604=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VkxC/iQ8k0nyQb/L5x3wdHKisvzuGV2yY8sotHC8igD1DcT6WEz5renkViAmXn2Xg
	 +/QKmxippHxBntGL0+j3FJQQVgkLl1hSx67XjpldKHIm7Av9W5YU3dvj6VREG0uIzz
	 V+GQM15vcEmSoTq79U1vbmVOHw7sZdxNG7JbW0cOEJSZEw9HbVvom6cvwmNM1u7/xd
	 esc3I3q4Z4JE0Ew0HGmGG3QKv7T+tzftD8p4rQTu3QsV2jIcJ7l6eaJZEA3QM8z50N
	 RI2xMB5NNiHQe5MRnMTI8N0x9ji0IUk/M2nSvNcfMSoHWEcZb7qi02/+W6pBWhwRd+
	 BYHnqqOLGgg3w==
Message-ID: <57248ac2-2d5e-4995-9ecd-b71b233fe5d4@kernel.org>
Date: Tue, 11 Aug 2026 17:19:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: khugepaged: don't pass swap entry value to
 trace_mm_khugepaged_scan_file()
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 zokeefe@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Vernon Yang <yanglincheng@kylinos.cn>, stable@vger.kernel.org
References: <20260811133655.267739-1-vernon2gm@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260811133655.267739-1-vernon2gm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DE149C000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: th3m4tbmer1z184ihoqkqg5c3gz7c9zp
X-HE-Tag: 1786461585-749217
X-HE-Meta: U2FsdGVkX19Qt/vFUkEx/4KjO51y72AJlkkyq2uKguYwWHrR/kCRgpeGawcZ48NjO4NUbTzsUEjeGHZBpmD4XfPuGFskcJIAhi96IyeA3e9iIVsaDHgk7mi5ADUK7MMmRrVefq3/3f68l0w9kUapzywCQ6oVpaIWOjvU9h5HOdNYtMCo0xJ/IAVRUSzM1rU5eNREFZ/GeMC3/iAdKW//jL6M4siUdBrHFCnAtmJZVc2Bl5UYqFb+6pZ1HmqzSmOuXz8qHcXE8pg4x9z8LfyQ5mTB3xgfCbO3IxKdGtliBRNuAgwP/uGxslBd4ywuY8TGmyOveHm7OZSFTIcwUUtmG2YX7J1XXjx1ILp63h7eUcopcS9J4lLO7QEjcWfGMiNJxLfaIjM7mxAKx+2rxScO5dcbNFnw6Q9Oi427DytgoMghmYIGbGDUPuX1kqs6xnFNEB+F+myqztKkTxcHzLB31sKDFya13+9aEi5TWwVICM72y0FaQ9Oq2LBGWmYaHWhrENp1vulXTtH7wWy+LxI7lzPhbHX9v99gLthIrp5UbqWRrEVchPuWSW0uOwpydH6byhvS/AfeeNshXE/r8toEFMmb8Fwez0/jZfhNrC4c1tAIDQtAoA2GOqdBQGT6PbYLV4Ukl/Hcc5e6Tj6hK3q5B3i916bbWmUxSUn2BwCwObj72HELCMmx0sTl3TJo8eKgaYk2hfNs+J5FS64B7QTfadMvMTAqV1vFTO/SawWjEkndSKPkMi4gljqIoEvG0Pol4F9S3YwZPClEK2aqBHU5AdSUqP1GH6ryRa2IzCDnbEhhJNPrBIYzUG/2yWhJTyAYy3XaigdmwWk90MSTzZx2h7cDViOP7L+xyY52jGUbeE4k2ObJIhx4fCH2AAk8mtkS0O/LtLpBTqefqsBXo3AI8uBOy+IL90gu7GP/NQ7ZGnWU9HRsemzrabm5tcOoIgd3uTt4nJfN7IfipCUabos
 SCRL6i98
 S4Oe2sbckffWRy+GFmdEcEHlHKlJhEQzLzAHMshydzz3xxH4Iip9ji/EJzSrhRE7LXe8qMyb2MHGb93a1/fmA81utCMrOge0wnM+2lLWBFvZjP3LDXNCbg3h/STO+M3+WMAS5x4Q2HrWf13mKPIB4CxtWjVG2sEDxBgftJd35dCBUBvVoeQehwJUAxJ9FcG4lCXLWHUUhpYAg359OsRU0nolflX5Zfshqdm4Mj68sNyWRIlUvWuv8MnNEDWJQI6CZcBmCC1PNEPQUkS+1yzyMrTsFS6fcGEYXbtUpapmObRuYrqQWV7kbMq5rFJipyWDwrlwKOin9wHc3ioM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 15:36, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
> 
> When the swap entries found exceed max_ptes_swap, the loop is left via
> break with folio still holding the xarray value that encodes the swap
> entry, not valid folio pointer.
> 
> That value is passed to trace_mm_khugepaged_scan_file(), which feeds it
> to folio_pfn(). On FLATMEM and SPARSEMEM_VMEMMAP, the page_to_pfn() is
> plain pointer arithmetic, so the trace event merely prints bogus
> scan_pfn. On classic SPARSEMEM, the page_to_pfn() reads page->flags,
> dereferencing the tiny encoded integer and oopsing khugepaged whenever
> the trace event is enabled.
> 
> So set folio to NULL before breaking out, the tracepoint maps NULL to
> scan_pfn of -1, just like exhausted scan naturally.
> 
> Fixes: d41fd2016ed0 ("mm/khugepaged: add tracepoint to hpage_collapse_scan_file()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>  mm/khugepaged.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 617bca76db49..bc0d04c9162d 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2696,6 +2696,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>  		if (xa_is_value(folio)) {
>  			swap += 1 << xas_get_order(&xas);
>  			if (swap > max_ptes_swap) {
> +				folio = NULL;
>  				result = SCAN_EXCEED_SWAP_PTE;
>  				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
>  				break;

Yes, we'll do a folio_pfn(), and used to do a page_to_pfn().

Using the folio after dropping the reference is rather nasty.

Instead of passing the folio, should we just pass the pfn directly?

-- 
Cheers,

David

