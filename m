Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D40B3CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 07:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A10C6B0088; Fri, 29 May 2026 03:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 451536B008A; Fri, 29 May 2026 03:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 341876B008C; Fri, 29 May 2026 03:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 252126B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:47:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B1370120ECE
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:47:38 +0000 (UTC)
X-FDA: 84819677796.25.6472EF7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id EB5F51C000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:47:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FNzeZCYW;
	spf=pass (imf20.hostedemail.com: domain of jirislaby@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jirislaby@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780040857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XmNFt19sfIlkcuJPBReQqrZSY8aoNNa0IyVf/lXiX2M=;
	b=YBZK+TfScx65odvImHe48TRrvBjAXD5ufTUVFovMjO/zZzFHz5/eGYqRNj/uZCXpBjBf0B
	fQBuT5hiWZkgP0RrgGH8jYF+yer+tmtAuVZ8ejBX3vbZgGdcj+6SADvAxVNLyPR2cMACWc
	4BB4Oi5gsKXdk3ljlu7Pk4qnNI5XGFk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FNzeZCYW;
	spf=pass (imf20.hostedemail.com: domain of jirislaby@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jirislaby@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780040857; a=rsa-sha256;
	cv=none;
	b=SfyfqSHt0U5LMj+RSe5c97tdPFXNuyCIqDvEcMX6DedUFkHc7qYye0Ryn2REKYRLqTBir9
	ubngtaY/d8xmr604lDqvdVPQ/36U1cGlrR4M/bcb78LvbuW4GJkn5f5wYJIk1ujGATk9dU
	l10jbwCQCeWE/qTuFt0Gjcr3Myj2lwM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C03460565;
	Fri, 29 May 2026 07:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA331F00893;
	Fri, 29 May 2026 07:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780040856;
	bh=XmNFt19sfIlkcuJPBReQqrZSY8aoNNa0IyVf/lXiX2M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FNzeZCYWj5hs2WFOzdDJLLUOzi8MJFvLzU1iRNVWJDzVl0O/EdU8glXvjInyW6nDy
	 Y69qBMICwsSNeeauTzfRfCAu4jp+o/aWJ3cvvJZpjgvpGWFkmQsRwGAT1U/Ado64oy
	 fcWhON2gZL6pSv2JVydhNMioPHvIKLKMn7VYLhhW4U5BZ7sI8LFc/XhuFQFMnSAL3H
	 C/SiPJGOmXbm1HfGVaO8XCx91haxLkGUtUrsqdfY0ZE2+B873lrUFzI5o9+lNy4sJ0
	 1Bhl8p82/r/NA/kDpQQKE1bRPkD2c0tOTGLzLd6Xm+HagF8qYRNYgF2KXRbV+1HYE7
	 H8jGiJE/1PvjA==
Message-ID: <18bb4a45-c26b-4a89-b598-a844d3aadafa@kernel.org>
Date: Fri, 29 May 2026 09:47:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] tty: serial: men_z135_uart: replace __get_free_page()
 with kmalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-serial@vger.kernel.org
References: <20260528-b4-tty-v1-0-9da9f7aec5f2@kernel.org>
 <20260528-b4-tty-v1-3-9da9f7aec5f2@kernel.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20260528-b4-tty-v1-3-9da9f7aec5f2@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ogk83wuf9kmn3j3jwpp31o3k9buf3378
X-Rspam-User: 
X-Rspamd-Queue-Id: EB5F51C000A
X-HE-Tag: 1780040856-363316
X-HE-Meta: U2FsdGVkX1+7AihbmykF9pAgRqItUSeJDgnX2Av63+pbQotg7cWrINXv3YLW+77teVBY6oMUzX4aF32Pq3GLpA5lm6Hy8R7DijQQJBCILYUBO9m2F88sdseeGuHXSYs65PomY8Jeuwgkf/kWpex2zkv8sanZGY0UiTtYoj78a+VvOhyxUG8QfqVpSGI36Oq9lq9ZXYHtUy4vlvm1oDxhZU+IhGEYhJT18n8VkDZzTtyugNIAice85Tn/ZI/w67zHhgKP4rgxKlROikgkzNBp8RlXGRzFD43yQ4Kb41H3nx/iAUQan4TKjNNGj+EOk5VXbIMFP9oLYIPRNnbOpH1QPZHq8cfcQOSPXdNYv2XSvmUNQr7K8OM5e5P4xurLaCXqFjxQ8EGA8iVCzUrmQQoQ6+GABxEse6VrD8LtYw9y9+Q1hA8ex7Ash83Wk/tjXqCkN43eMS472edrJE9xfWu7xhP4EpNblmKyjPerXBlNJW6Z3ffwA9dNzLomptKsZaSi52encw7japvrt1SfB1MrfYKqvrD82GD92+uSj8cT+peUh8bGklEA1PpKgwUOqeGueMLLHQIleNxuhn+TE81+dVHRPS9PUJUYSFGWKMl3wakz5Cek9eGEqdYXkk+ovxEm9cY74NFJRAa1F9RdobdYPye24TzAEATcPrU4MubMRh3w+E94C1otWsGpCTN2lxHEeMAG4IB5TsOQLxmwNFcNRWYq0Q9+jDQpiRGG4Iw2mUijqLNizIi9a8IVh9Y2oTsRR9ltWyTh1/AavSalLbTq5Zh4u+p4maFYPWjuvXpdu5AitZ66TImfvRO83YmeZuiDa/bxMYPylJtY/Xwe4jdJfqeyk5J4EqPK+1YvE5cLueICQynizUMDeC+7D5ejlWUFlSqJshqmrcLuQ0wxTlcsAol4abBOtloS8jJQAGBMoQVrNCH3mzJSlLSHOgvzIwwhKMFrzeeEb+LNUV6DZLx
 W+7lAvUP
 BmjmAXmg8QN1JuEJ8fC0H8Yrlc68EqggMTYTOJqVohXo2a/5bVGO1cRShf7RRlVHU9fjkPVngqwvku8uBA+rnI4DPbd6Kf1T43fiyajoCkAfpwDOEhElK2s0+uD2531TUpbSOFJnvS6H8bBXQrGM2OMcaZhhw8/TYlrc/wny7f1zjJN+p/RZCfb57XXJ250rmYYbjG0S5S8FZRloOkivip2BskXV2BvtNik2cdKJwby9dpIPmDTgWLSwBSobvjM0QZuFQJ7ZagHtQlQ28i9j2YRF4Maciq9ihKgD6lH0Tl944Q5xERByglDZvoM7Cr0CxbLrmMP++xC+TnORkaPV486Rp/NYW47V+yFKtjVSsXxCPaK7Ho6SAikEegU3KfSNAPCAHCxyRFP6s3WcNmEQOr9+ZgpklxlfHpngOXYGuar+9a8MzuhOBd1QX85/48nO/gj3OOXjQbth1+X/r+sQNw8KDtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28. 05. 26, 12:24, Mike Rapoport (Microsoft) wrote:
> men_z135_probe() allocates a receive staging buffer filled by the
> CPU via memcpy_fromio() from the device MMIO region.
> 
> This buffer can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> Replace use of __get_free_page() with kmalloc() and free_page() with
> kfree().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   drivers/tty/serial/men_z135_uart.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/tty/serial/men_z135_uart.c b/drivers/tty/serial/men_z135_uart.c
> index 6fad57fee912..9c32b01edc9e 100644
> --- a/drivers/tty/serial/men_z135_uart.c
> +++ b/drivers/tty/serial/men_z135_uart.c
> @@ -17,6 +17,7 @@
>   #include <linux/bitops.h>
>   #include <linux/mcb.h>
>   
> +#include <linux/slab.h>
>   #define MEN_Z135_MAX_PORTS		12

This one is misplaced.

thanks,
-- 
js
suse labs

