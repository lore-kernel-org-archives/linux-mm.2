Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42F94EF586B
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 06:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 950A66B0088; Sun, 15 Feb 2026 01:47:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FE626B008C; Sun, 15 Feb 2026 01:47:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82B1A6B0092; Sun, 15 Feb 2026 01:47:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7263E6B0088
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 01:47:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 212B713BF47
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 06:47:31 +0000 (UTC)
X-FDA: 84445759902.08.6109761
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8EC9FC0002
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 06:47:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pd5ZgntW;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771138049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2l7h6AZgsCQNAFoeKxysvqrlTHtQeTpw/FXQJGzkYTE=;
	b=bdxfhxPKBfhIkKBgm1Ex3A2IB6dBlTspJY0tjMaWZGZigzHnj8zP+o81N8s4Vo3ByO9S06
	0e0+JeYur79jXAsIrlMMXbUCS9rh3eies5azHp5ko3hNzZHVr+XZfdrwCHSRYNXiuIuszO
	Oe6NPP7tSMqgYBr0D2qYUl3XhHqhwwo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pd5ZgntW;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771138049; a=rsa-sha256;
	cv=none;
	b=4g/lDdHyXjms3cviIbfIvsm3O+oA0YZb6d+gb/lS5IEqPZRz5Ak4MeXjRbUQipqwbKDKic
	brn4JTLkv4y2Sf5ed2lq5C4r6fYLgVF7Z2bPAJpOsZdP/k5bRgpeQJfkdEKopuilDJpyGr
	iRBpkXoWz2UvFOXf8+nD/UE4aa1LKCY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DB86D6001D;
	Sun, 15 Feb 2026 06:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93C7C4CEF7;
	Sun, 15 Feb 2026 06:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771138048;
	bh=Li2C5wEg3QVoAnSKgUm9f8v7M+2VmXqH7O8tRmrVvtw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pd5ZgntW4T22oD9B6EVv91jD12lpMZXLWz+cL8hG1AwF19lPGgfkoXUoXbhlDIU27
	 tAPOQpRHxN715E4CEr8c9gxYCJJ7FkcPZtB5byjVGSvmnBoO2hLDU97+48+eXWr/UF
	 bdZ9KeBJxHaZ1GaOyMjUiM/qoOCuyu6cGjNdr+pvajgoJhIrXQknnRbsxpP+RAmvXi
	 9ewgdGFvs/CKyDlHXHAWVR83pRwObf3SwpvOU8074MeIWxyKdC+OdvsXMDe6zEV+O8
	 /0Xa+/cYWEsn8ihgTIVOR6/3RAMWVkEcUAqgbUhi6rpEym0K5O+vXmYu9EFOAWoOE/
	 piw17Eq1Vwg7Q==
Date: Sun, 15 Feb 2026 08:47:21 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Marco Elver <elver@google.com>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com
Subject: Re: [PATCH] kho: validate order in deserialize_bitmap()
Message-ID: <aZFr-TvaWn-KbA1u@kernel.org>
References: <20260214010013.3027519-1-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260214010013.3027519-1-elver@google.com>
X-Stat-Signature: 6m7ji887mgkxphqnfhamj67fn8ug157d
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8EC9FC0002
X-HE-Tag: 1771138049-508271
X-HE-Meta: U2FsdGVkX19rwBes1GKz1Ah08BlvFzMCy1VY2g+xphOpeTNCCuiDnMjrKZEMKx/U1P8JGJuBd+qozU00ux/XO32agcrAknzFkTxPFkhKVen3ZlqmPBPKP0ABrPZd10PwpRa/Bcr7po/0LU8GlH2lxdiwRhtWRkONOZBFUt7KfrtFyUivwgVOUf6W1Z6uIfvEo+pkvr1Fo5qVjqjdYJUJe3K7gb3g302pz9nh2bvPHCNt5sUT0f/iAhW8cGiVEIoi5CMx500TmqWpt1HxG8+DHtJ3f47G4vvhj1wlDjhb665PTQQFnkvloj/7Oa9X4vOi+5jWY5HbssrVGS59Bg9bQvZoch/Xvi0oLEZ8/vOSDPwH8b1wUXTvkaKx+gwihhPYseZfrorDeT/Rlboxz/U3V1O6MiNEHwGGC36+CzZz7fWHXo3gjie2zqY+/z9aWMK6fUXnXVKzT+RIifTEC6QsDDm9pwM4Qzymwdu6O9ecObwKkUeNU2KZAwC6D59rtiB/aYAedhL83h3H9z7/ZjU6GxJUNkhe6U19wp/4p2m4Myh6dEZueu0SnIC1+CT8hqI6ywTjxlzeX5YqEae4Bbj4KTm40FjeQAk6hfmTUG4GnQDEB26g9YVVYyj8x5gqDlJ0FJTrE9rxNwc73NNjsg1Q/dP+hQjYBx+nl4LgCtnV/sV+EegSuqTeZZKLa4DzNBhTw/OVUM4d0I/0POM3JBce034FZMhBCoc2C45TRPVV08Pmd1gDPOLSUSKM2mAIao3OXWGSS8jJgiPB3Gxd37k4+HkqNPrCRee/fAMqx2TKEcPmR3Tv0o1SCnpxhe0r4a7Cam5qKK5PAeLs7F3NO0gGXEkWkgOjBaSzE1/FcQ7C6BjKz6O/r7eNQ4UsbPw/7ImJQIT0uh/+DrdMj5t9w15SNDTjoW8E0G8+sklbxPLywZF70l03HjuWpNUVOt24WECLvhj2dod8SoztCGdHOZ5
 hkhV3F+A
 1n8R3wnNEDQCoe76S5QXTzOr///j+FJhHYNT1jGLn8gr0XiSfctvPT7uwcOs+V7kdQ6WzFdsqJGeK1aakNdXLOjPhUrRXdCR2iWq99Nw4IejvlgHsbd9tEg+l9iXzH9pRn9pkZ5aP8BqKJJJg0O408NQRa3UJvSVJtFks27Jm32gjYA3hBYc0vWDhqISCgOoNCHUm+WtE5BJDOCc1yxPzSOzcLynrujx9QY/xeYEmTRl9EinQqPPikJoJA/ZFPctVklGUUDP+LervEJhOOnncEbLr/q+VpkBNhG7i2z4IKWZSVAVdoyCZvSQ69cY9r4gOb9Ms
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Marco,

On Sat, Feb 14, 2026 at 01:57:51AM +0100, Marco Elver wrote:
> The function deserialize_bitmap() calculates the reservation size using:
> 
>     int sz = 1 << (order + PAGE_SHIFT);
> 
> If a corrupted KHO image provides an order >= 20 (on systems with 4KB
> pages), the shift amount becomes >= 32, which overflows the 32-bit
> integer. This results in a zero-size memory reservation.
> 
> Furthermore, the physical address calculation:
> 
>     phys_addr_t phys = elm->phys_start + (bit << (order + PAGE_SHIFT));
> 
> can also overflow and wrap around if the order is large. This allows a
> corrupt KHO image to cause out-of-bounds updates to page->private of
> arbitrary physical pages during early boot.
> 
> Fix this by adding a bounds check for the order field.
> 
> Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
> Signed-off-by: Marco Elver <elver@google.com>
> ---
>  kernel/liveupdate/kexec_handover.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index b851b09a8e99..ec353e4b68a6 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -463,6 +463,11 @@ static void __init deserialize_bitmap(unsigned int order,
>  	struct kho_mem_phys_bits *bitmap = KHOSER_LOAD_PTR(elm->bitmap);
>  	unsigned long bit;
>  
> +	if (order > MAX_PAGE_ORDER) {

Preserved order can be larger than MAX_PAGE_ORDER. 
Let's make 'sz' unsigned long and add checks that calculations won't
overflow.

> +		pr_warn("invalid order %u for preserved bitmap\n", order);
> +		return;
> +	}
> +
>  	for_each_set_bit(bit, bitmap->preserve, PRESERVE_BITS) {
>  		int sz = 1 << (order + PAGE_SHIFT);
>  		phys_addr_t phys =
> -- 
> 2.53.0.335.g19a08e0c02-goog

-- 
Sincerely yours,
Mike.

