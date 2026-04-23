Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4658BFC0379
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 15:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE6A86B008C; Thu, 23 Apr 2026 11:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABE366B0092; Thu, 23 Apr 2026 11:56:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D4306B0093; Thu, 23 Apr 2026 11:56:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8E7A46B008C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:56:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D4561202C9
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 15:56:04 +0000 (UTC)
X-FDA: 84690271848.10.BA7BB30
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3F6BE80006
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 15:56:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pEhBq3vd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776959762; a=rsa-sha256;
	cv=none;
	b=MOVvz/CyRhNxJk9R8dWWsb3rVsEEFngbgAUWoinSoO7KSae275NvrXWzVZSvDcdhEC4UMP
	JwYXdv3YkQgafc16hQZwCX5KbAn6rOnWWkZbEUsp6ZgjKkecVxexp5QiiT46AVRDF/Fgv7
	N9nSXwP/JE4kjfoGAtoHHt0LvldogVU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pEhBq3vd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776959762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vr5iVORROWKQui84kSfDk9Ss2fOsqdTFGgFbcuo0tdk=;
	b=m/C1khzUtnIUgbDIiHxrXhuth+lv02ivpd1RFdR9Kz+UCrhBbc/TZjLM3SjNlNPmWecET0
	C2IP09/YoW7bBlKs+nicoXzzTKQ56hkL2IxA+ELt6BfIzky/zBL+LxrvCDzd2mMws8Ojyr
	CQAj2Swd4yqcUiWdmWUyKzlL8KJ3Fqk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E81F43F93;
	Thu, 23 Apr 2026 15:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F236BC2BCAF;
	Thu, 23 Apr 2026 15:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776959761;
	bh=0L5e/EPnegp4JHS0wXmUj5FxsmR4LIX+3gaFnChJO6s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pEhBq3vdwrjld+IR22eeekTh4+a7rsdskikeEVkX/tZ9JK7SIwOSiFuyezbIQGF/G
	 4+It6V9BojzewleJ5ErtRo+QcDhD5h6h6tNoxhbHJcLOQlyGIiv7GM5ade5pHMGVdp
	 zt8SoXvHT3ZjeQYk0TYI2Wg11xUfCw2GGzreWVwMTw1oRzXKKQx/sYTxDPWQDIrf7D
	 q2L92KkHygasjzOvRtHqekUD7PJZnTw7/0HHo9v8nJxU6eZ+B5A/8wQ6aRNpL5J82v
	 BodwqsZT80AwLa79kq5nr9f/boblucydGsIpyUbpvx88yO92wNK3swcNny/QtOX59R
	 a1LvbZZBpupJg==
Message-ID: <a20913f0-476c-4f56-a044-9802bb1c7f1a@kernel.org>
Date: Thu, 23 Apr 2026 17:55:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>
References: <2026042303-vendor-outright-b9d2@gregkh>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2026042303-vendor-outright-b9d2@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Stat-Signature: hn85h89ecxq9dsps3kcigzewdofgky3y
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F6BE80006
X-HE-Tag: 1776959762-932606
X-HE-Meta: U2FsdGVkX19uQsKT4Ph7N5fmWTLtjuieekds9oeeRJtqbBQn2/nVyx0bcMgrDHArplCeS+hlpQa5blyQ0rEC9b8JooZ/KtSGWyQyOIjIQym9a84FxB7ju8Bhn+dus5mnvkzweGv7fAijhsNo4cXPM4qQHZsODkE02Xn2EKk/TYoqUtXTkADjk2zlX97BAU+DlILOUmv/wJ43SKCPSlF4oZdv/F9B8aTxO0ierI2ps6/qGsKNFCSIKdP/5Y+h+bkYKRPxekrCMVsuMYIcnjRlCin0oEGPYlEmwx/597vitWh2CPr715P6LsU9LcqA/SSeH/aNggvFR0FJA3LbWAafPaV/LK6z4ltf4pQ0/5dVIGdDI5H/0qx475RdHIRSRt4gL6OjvyjghlU1WqMVtE0fNhUCrXpCrLkyPPO5Ru2J+DgwE6GFW3J8xL9a2fjYA746dq4fpu/c2ST4bRs5sWL4mIGuV5RdlwQWtyTkYQmYnxEm5taa9y1TUC/vJyzsOInD9YeuTEQFIgXpv4X1xHcRkD7qn+L1NeXI2miq5ezKDVcMw8C94k3qRedHdUb85H/Q6Ao0J0LF1bMyKD6PlMju1iRTD5KWGOaa8CW0eC+aQRY3o7GdyaDLuawZGZH8thtizhadojJQr7BBiVzcsPC3rhcNrz1pZCS+9UFm4D4rO+B9QKdZqR9Opq55h7HipHaKfWOTMzXBCEWC8eUxTIB0Km0a8mc+CHlsbK3RAf4kf854V8RISzT+QK6uzuXL6B3GZDi1TXBYM0usDHZPiyzQOxKahmB13ftS6xH6+2NFGEd+PjNTREddZmb2cDFVOqmu1p/zZRctPOm9FJN3y1QykX21jbwpyABWkHoqqEqyZfPjQDwvJjw/1KqESvkTgaGjBFefWf9xtZDAN9PF8s3TEQQZcE6FA85e1JFvsP06q7hS68ETpVaK7QRrc7Ujlx1LdDOBMVnukQx2RVZgrKj
 gdTKhBaB
 MNKGHxGLM3jG15xYYzUVG4f8k/aNdSme+MtZ+hglcRWytNan83l/glphXubwU35oapntV1UzLJOzCqODVzhU3fKEDNz+0r3k/kTGtNNNzKXYuKaXRA702QW4q0RJ8rSnByv8+CUnL2vD7iU19ZAh2dgBikwZy+crh2tmN9snmVURyT2qzjgV1UlNye1twChqCTvUXi3Y/DpJVUCt7iyQElx3vPlgji9KS+dFllke/TESasV0VJvCy19INoF1borW9P/b3C9k1JwR/YpLA1bZMWquuI6JTRQLsfLz/dfuSXJLK5gSxCKSvhmNBUK1OXa4kwmETMm61fh3+lF7uLbNOP+20EYrK010h65P/6c7N/uSM2hAW9TRKCo9qy5uTCDCXOXWEDZvZpn0E4KW0BSx0b/APX3ewmM1bWJCMEP3yXcvn5UE2BXGRAyc9ScUsHy30QonO/0+fwgmQovRDShk6//R6Dl8siEz8tVaX7n05nN4KU9ss8PFR163Mcyr+4kigE/KWX3wxXCQwiaR/sMfSbQcbLeJUNx8SSWtkSgGN10qCiI4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 16:28, Greg Kroah-Hartman wrote:
> The !CONFIG_MMU implementation of __get_user_pages_locked() takes a bare
> get_page() reference for each page regardless of foll_flags:
> 	if (pages[i])
> 		get_page(pages[i]);
> 
> This is reached from pin_user_pages*() with FOLL_PIN set.
> unpin_user_page() is shared between MMU and NOMMU configurations and
> unconditionally calls gup_put_folio(..., FOLL_PIN), which subtracts
> GUP_PIN_COUNTING_BIAS (1024) from the folio refcount.
> 
> This means that pin adds 1, and then unpin will subtract 1024.
> 
> If a user maps a page (refcount 1), registers it 1023 times as an
> io_uring fixed buffer (1023 pin_user_pages calls -> refcount 1024), then
> unregisters: the first unpin_user_page subtracts 1024, refcount hits 0,
> the page is freed and returned to the buddy allocator.  The remaining
> 1022 unpins write into whatever was reallocated, and the user's VMA
> still maps the freed page (NOMMU has no MMU to invalidate it).
> Reallocating the page for an io_uring pbuf_ring then lets userspace
> corrupt the new owner's data through the stale mapping.
> 
> Use try_grab_folio() which adds GUP_PIN_COUNTING_BIAS for FOLL_PIN and 1
> for FOLL_GET, mirroring the CONFIG_MMU path so pin and unpin are
> symmetric.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Peter Xu <peterx@redhat.com>
> Reported-by: Anthropic
> Assisted-by: gkh_clanker_t1000

Assisted-by: David :(

(no, I'm not a tool! :) )

> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> v2: - drop huge comment
>     - rework error return value based on David's suggestion (heck,
>       pretty much the full patch was written by him now)
>     Link to v1: https://lore.kernel.org/r/2026042334-acutely-unadorned-e05c@gregkh
> 
>  mm/gup.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index ad9ded39609c..2f6f95a167af 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1983,6 +1983,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
>  	struct vm_area_struct *vma;
>  	bool must_unlock = false;
>  	vm_flags_t vm_flags;
> +	int ret, err = -EFAULT;
>  	long i;
>  
>  	if (!nr_pages)
> @@ -2019,8 +2020,14 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
>  
>  		if (pages) {
>  			pages[i] = virt_to_page((void *)start);
> -			if (pages[i])
> -				get_page(pages[i]);
> +			if (!pages[i])
> +				break;

Best to mention that change in the patch description. I really think this is the
right thing to do (returning NULL in the page array is just very dubious).


Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

