Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72F92C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:03:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80CE76B00C3; Mon, 21 Sep 2026 09:03:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E5316B00C7; Mon, 21 Sep 2026 09:03:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7212D6B00C9; Mon, 21 Sep 2026 09:03:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C1846B00C3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:03:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8924AC0163
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:03:41 +0000 (UTC)
X-FDA: 85237786242.03.7C9490B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id C2B2140008
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:03:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Y9x5z2N9;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789995819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uZr0pvoIprX1hi176kzQ99GPmdm50LvdPWiam950w1U=;
	b=FmV7YDtcwzAFr8s+GEWakUxXoBkemTiY+D5Y1vrni+ucbOdLfgHW1+iUfuBgVG1PzllOEI
	2wSHZu9cMzWpz6tyCMAERd99bXWdoZ7lTdyDau//wsg00NmIseau3rOkiFNW853JdBaRPb
	LolQEYT1CZ04CpeHQ8K2aH1KGciTZlI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789995819;
	b=HRaY2tn3BIEsn4C9zadm+gcgQ35m0RBZif5k4DwVyrzfdGHBdg+mMHJ/81/k47muTNMifp
	0kGXOmzRQmlCP+8JOoJ+0oRSh+yyiJnXIgWbcIyP/zsIwwfj6BAvCUlUiOpKc1ARsl6/Uc
	EFTUCg4kdkoGEXdCmC4YLk7Ii0e8LMI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Y9x5z2N9;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4571C19F0;
	Mon, 21 Sep 2026 06:03:35 -0700 (PDT)
Received: from [10.57.6.224] (unknown [10.57.6.224])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 11EAF3F86F;
	Mon, 21 Sep 2026 06:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789995818; bh=OoPqL9ehIIvD/OJY5G8d5/03edwIvHcNFvhV8sTgPSk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Y9x5z2N9wxF1WJc9DrkVDbq6LZtMWGUJDqscc1hkUG8aFM75LsyBMucrsg5EiOBdx
	 z/KSv4t2K5w/2K/s6vlsXf3XnlX276qju0hZG4HW9aOmWjiILwbXEnleijlMRvTfc/
	 6aooxHtsj5Y6TP7O2n7n5OE1KlPrfuIzbkwiW3Ms=
Message-ID: <433d32a4-f59a-4d6c-915d-2c1b4c22b840@arm.com>
Date: Mon, 21 Sep 2026 15:03:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] docs/mm: describe set_memory() and set_direct_map()
 APIs
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>
Cc: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Randy Dunlap <rdunlap@infradead.org>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260919-set-memory-docs-v2-1-a2a4b3657690@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260919-set-memory-docs-v2-1-a2a4b3657690@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C2B2140008
X-Stat-Signature: mactjrewz1c4psgfjws9t8moij4bbg3j
X-HE-Tag: 1789995819-904007
X-HE-Meta: U2FsdGVkX19Md7rT0BeurY7P+KTtUQo7QfQ8KfrSWF7D6+pPdJYB6EgW7nRPCPI+9wOmrKLjiQRBYzTuLXan+q6jt3h+bNHsFQ4DBih7gCdo6QI0OrtUNOlNAsFnzN3retvK8hncCUO7S6sSLLubW5OchNW9ixW03FS7U4MaAnO0DF3dnb5Fp8w3LvIyq3/d6n31dt1UWUL5UMpRfS8UsKifsXnbHEnM9P16EwNgiK5GoqNyrZDPaEeYwdwdFJArHWeR2KXJMSbsdtBm+zsUn37A4lgU8c5sUY5DArWp63yyywyk5EHLNJyJEadT+vtXbjMnNhbDePUo+imFb3O0pHKvpjZsQXTuBtaBeUm3ftbgHhdj/afKixIKMlBcPKdVhoYH8BHx/agOdnrQzAkQ1R9zJ/ZV7jy4/vIiPBkyTDyCoK+cJ/8EsHedPN6+X/xUdAoCUgfbswihxGyMr0B8ftgUC9MgjlxGhSxQeMW9ecOiFZfzCVuzgLgREY47ZQ+cKXT226iBIlPPaT3GsWfkTwZmJO+LDCqn+YzU0O9fVMHeo6ol419KWRMZk5vPwKnv6vGoUFJwuIVcCbEffWpMyWZ78G7tr+Qe2anwU28QeJ3Ec2UKY2D3+GLt/gg9GIxhiZ9Q+L1OSjcDy+M7ZuKI55ZZ/Hv/BaRkASct+FitzXujU7BLmy+T3B6W6dO6zi48QkGf6Nha3X6FPb6fHSDoFFt3rxdSkHDYjSYUsugCWXz+pZO/mBeKvwARmsN3VnkIm0emZxR/EbwUpfOLFMEap9My56OT6ea1g4tugnadq7/H5ytAorNhayqNvVw6guEfcHUiqtR7RbPpayqrebZHd+cck0DRnylrFarC8/hyzzZwrxC9tSBpsB2ev3+4e0S2UiOcbqZfgtZoYM7LAZbsHp4x67Trpv9p7yGHAyrTasxEZhj1w3e0Jsy1EE3AIERtY57ken4WqHQOGo8xMK/
 dVwQrXTk
 udWLAps8j78CXRTtV7Bo9LSWE3cV5pUceP+isJ6oTF2H4DOesIUpBF1lLG+soWC2zmG/Fv44T6kXpiEI0JsxukMI5qMlj4bmAWRxOfS9Mo5QRLv+XTxm5yzBMM8n2IJM8Y0xstQg+9tAmvoy1ckq28iO4LxcTUO4y16J/7vqwJuQf81qqZoo0jWDw/j2iMK1+pa4AA9aAIT432RZQrzWrtEUlahnhm0MSHw+2EbxbMaLp2PSsMX1+bhaxSICpcmgpl8cTBC6DFV3uRPuSC4KVGeWfC4xXDDw1DuEWs5BpOqBuUaE8PPSOJVYy5O7wScWuFi6AEvyegXMzqyBF4zTD7oEmYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/09/2026 12:43, Mike Rapoport (Microsoft) wrote:
> [...]
>
> +Modifying the kernel page tables
> +================================
> +
> +Except for the vmalloc area, the kernel page tables are mostly static. Still,
> +there are cases when the permissions of existing kernel mappings have to be
> +updated, for instance when a module is loaded and its text becomes read-only
> +and executable, or when a page is temporarily removed from the direct map to
> +reduce its exposure.
> +
> +There are two families of functions for this, both declared in
> +`include/linux/set_memory.h`:
> +
> +* `set_memory_*()` change permissions of an arbitrary kernel mapping. They
> +  take a kernel virtual address and the number of pages.
> +
> +* `set_direct_map_*()` change permissions of the direct mapping of the page
> +  frame represented by a `struct page`. They take a `struct page` pointer and

The new phrasing is a mouthful but at least should be accurate :) It
should probably say "range of page frames" or something like that though.

Looks good otherwise!

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

