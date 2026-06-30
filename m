Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6388AC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F41D26B011D; Tue, 30 Jun 2026 11:57:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F19846B011E; Tue, 30 Jun 2026 11:57:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E57DB6B011F; Tue, 30 Jun 2026 11:57:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A854D6B011D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:57:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0D15D1A041B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:57:00 +0000 (UTC)
X-FDA: 84937032600.03.029ECD4
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2A5CD20006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:56:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=VF3jJPXf;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu;
	spf=pass (imf13.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.222.170 as permitted sender) smtp.mailfrom=stern@g.harvard.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782835018;
	b=j/lDxBJr5NAEPImAmaocQPqtGfQAtHhmCcWnyHV2Y99DiucCEV91NRvoBkr3YXNw9qcB31
	5UNDHeBAYMbFzbCqqTXk8bdGhZUpFq/lBnzzk8z/I+O33gipxnbHLS1JifEji1Udbp1tZL
	KaXuc3Fw/aulzNzFMi459n4wQln+i7w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782835018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ag7vyYZ1qPpEzK4WsJQkIt1kiT2/2vAc0yWyVzCS7E=;
	b=brn02B4bzQwtEmPXXGTAfrsanxW7+V+h3Ngz7Cs3wafSdlx95kfa1hhAfG1Aa7euaqiW7A
	VuH9nO/onv6YrwlYrI1z4cPuvMpMxI1fywn33Gomea1icAJyLKNlhUGTSKmf07EUR9TI8F
	fjqz8wBEPLHZuVfyxZrHI/GRiURUVr0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=VF3jJPXf;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu;
	spf=pass (imf13.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.222.170 as permitted sender) smtp.mailfrom=stern@g.harvard.edu
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e6391b114so106631785a.3
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1782835017; x=1783439817; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5ag7vyYZ1qPpEzK4WsJQkIt1kiT2/2vAc0yWyVzCS7E=;
        b=VF3jJPXfUlPhWnG8pVia4ZNe8UV7oAtlJIGvwMxHmiyrlvsaWTTtKYDk7/EU4GrDt3
         PRLPD8VTRCAKqe1/QcCwuxNNgSd2IQrn9ww4SBub3lklGYCYkXRl3a2VaOIfEwSYwHzb
         osp6/g/KMKKcRepGdsLgkOv0e6fn+lwAtd11ElDcR8OupgBTWul1r+Zbb2lPGZPo7Jk6
         N/4ig/XETdIkDUEZpNL4smKoF/S88uzMLRQgM2YmjZkTWg7xPcGGudEJMFrMZYSt3jdv
         PQ5nkAKGsR+9WvXJ4/p8H0XgJUgC50ZaEfF6psT116AkwkzUyLW91zPzgE5S5hVxnSD9
         xmkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782835017; x=1783439817;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5ag7vyYZ1qPpEzK4WsJQkIt1kiT2/2vAc0yWyVzCS7E=;
        b=YfgEzuaTudcWp+3QxrM9F5k5NRBm4ioJQ6Z0OZVcQJNQuR50wOBHHFkOWnSdkyT+rR
         7AS8KjzGZoIE8WKYiVTVjUI7MGiUtpwDo5Eg4uGwtZgMfTTyYZp96ae77hNOOn7MPOyX
         q+txCPCViYjhCCoO09Rsh9kJwNoEK/uWNpeNnR+uq9rSuq5IlU9q+ixZCsyLir6Jl3PM
         KyRkJI5gNJRXxvu7Oqi8a2kCmnXshiLDbqBBh5J5lyUP6QF0H4c3FFWJEuoQx2cw6I3c
         OHflocquSRXKD1oW9QTnWy3O2uT8Zm1KoB1wOV2Ot5s1yvh9Qh0XMywRRdBu7YqpJtkX
         luBw==
X-Forwarded-Encrypted: i=1; AFNElJ/5HzvlQywtKE9yUYjLyOHpDNFOe/ffxICchgYoEGxybkYNKkwZJuyTQBo+f8AkvnIknx2YCtEe3Q==@kvack.org
X-Gm-Message-State: AOJu0YyD6bcbtBKohzI9/jvOho39LH3fYHsN+bnTfUgMWH9rIg7UuW5i
	YOyo+9oAhZf9TQMJGJ8vOGEZc5C6Bgx0Tr7O3Vhat49IqqPjOkLVSb36M9DsU99anA==
X-Gm-Gg: AfdE7cmdYCcj4B9qucnUvyNsXhLGpzJMShdDLGGvmJDz+l+vhs98zEVXV/9xQjAHIPD
	is8oI97iPHB03N7QQOxeLbi16oba+M0x3TWLBR/9ZXh0gXEC/T15yFp6jStGSv5fJAabD5+QYUu
	xMnVPI7r1vmwXGmSuLLQcFvviQkvknY6Dt4YRUeHxiXtRW7v/p8fqgeVgZjX1bQf/X1/wDNuaen
	1uoDikofLRTOVzFAJ/xysK8GRlJW2Jb7hIZhk6jDkA+iuxEbthom/eD1hZxbxaOH3Df3BCF21OI
	IHi04zJC5LLSKcOxaEMbLD7JK7y9zqMt+UyW24mbRBQ9TOB+xOGodyb3Liq6jMEvQ726w5MI68r
	ArmqvFfo6PxC2fcMa2LwQZeHESRZypwKc9ykBHA38FmkNRCvAm98H4wdDalpzBG5LXRFnf/mpch
	24AmB0u9HitJckWw==
X-Received: by 2002:a05:620a:4546:b0:92d:44b:db99 with SMTP id af79cd13be357-92e624e78d8mr671180985a.20.1782835017027;
        Tue, 30 Jun 2026 08:56:57 -0700 (PDT)
Received: from rowland.harvard.edu ([2601:19b:d01:d210::883a])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e62371ba1sm271366685a.42.2026.06.30.08.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:56:56 -0700 (PDT)
Date: Tue, 30 Jun 2026 11:56:54 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mike Rapoport <rpppt@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] usb: host: ohci-dbg: use kmalloc() for print buffer
Message-ID: <dfff8910-c325-4b48-bb40-eb8852b115c5@rowland.harvard.edu>
References: <20260630-b4-usb-v1-0-8d547235c374@kernel.org>
 <20260630-b4-usb-v1-1-8d547235c374@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630-b4-usb-v1-1-8d547235c374@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2A5CD20006
X-Stat-Signature: s4k6smujcu485uuzorau9r97ih8765no
X-HE-Tag: 1782835017-90808
X-HE-Meta: U2FsdGVkX19eFPFym8tQGj1oaP3wycNwlkhVA7/JKJDkS0/qLNqgTelUyKtMXuMPQlJhxtu8vX/a2Lm9OySfHadv2vGvEjxi1roF4rY6OL0gn4P/M1QSw65li5PeRHCMShzbRAsPWPVysocTkbzi2sp8nuc2Ko5/lx0NZGVXgp2G515VDXMgBJz9L4gWa4OGPLDy8EL1rzHsJn+7ui9NtWHrCd7K9nKqwQNl2eE251Z9fW+wJn1zmwo+xqxJq+0LZfTzJ8PKo9vFT86TGdi/E/vlwp4JdjdFS92dd3+rMa0J1HXGpYlAruH0FjXSvjzruXraCpTxdcentqTjs9qxqdAd3xosnQ8U0b4kc1IPI85fDv9Ef7Lit/gGaAcwWrVdm0xRKcnXx4jpnftrF/k3WmJ7ui0HgEE5AieVu5GqEtCzTqw2IXm3XiSTuerHYGOsru1cyz9emz/CP9Xp1NhciQ+abSfpyG3qjYAOvJxvkFLeu3Jule7wZqqDCvCs9/8pl3HEQ3wPUMQ7pO146PBFAOq07H5cOQlIT9JsoHE4eAFmhs9/XADsNQQQN9AOt8tKMxRtiXp+MGOVXBDMREDcq/lLaYL664lTpOlIZoH2Z7ndrmZr71YhEoIWKHR5+9lDkro7XSXDfntDDJGYGK9puKMMUicJ/7c2QUvOm0iqYkriTjU2fta157Bsb9pGOWGJV7xE654ZAa+O1GokZbX8xUF5N9XWa/K/9vDZcrbPkJe39imd1h7GMFZJziet1caj+ONT3SI8XqL8B7b+kmLnVmiP5xMwIVPEAA3A7GkCsmWl21QIMGH6P/ALsNfldKPaKWT5Bo1xZ2ZWhAAE/0pT+e4RppgWXfkwU+Gt7QYWtS1kkIKwdVbokgvqetC5V2h2Q0bxx4sr9HEQeLXEF4psx9u40bXFzP/S95Rj6rgX0RIeIwbTm5mlt+p7rS1aazoDjoeY7D55ijCpgfgVQAu
 Uwa5q8TU
 /qSB59qqpQh5vg+hMTxuSUxmFUxHD3gjMNTp/m1GuwLSE0MBmOv3YrWBS+B3BbUaOX2g5D59xe8aQ/sdjlLvUGGwpzamDDRADjHgR3a2lw+tsiqfmLpXrsgYYi5nNEzEROUXJxbtsMsysNm4oWGGXGcsqhVt5I/0HZXEsfzBDqhssI9x2mNIDSkWvlymZL8uEKSNVjsU7DC8vQ+DLlDTWTV9SCtQjZCLx5AFWRbwyiMuMHtjKTT0W62HgnnJjI7a72M7z83atpH6tFWajl/nfOSdEoC1F09o83OiGUu+/LzIiD9iBTxUya2MywNzwZlpLr0LvOtfe8BW9SR82C3N4BfUSBaqAqrwGcMnfXwgQ2BiKn/x5rhOfYhR7bofMK7F8kAFWh9Gs8X+MXQwM1L5jzaHPcw/6RaJ1FKrvoI+I01B5lV1UrTaBxozhU8eZX0MFOGIPERIEwz2YTIluLmoENpPHMQOuKaF8Sg3k5EfMvM1Wcqcoxs0aP9hazBWMArUpjRflUonXrarYlPtxWv+SIyVEi0h+eLwc1e0gTxQpin0NK+bHdJr2bBG5fzeAucFaBbkll1AAEAGuAy0Kjgu2S5TdhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 01:27:08PM +0300, Mike Rapoport (Microsoft) wrote:
> ochi-dbg allocates buffers for formatting of various dump outputs.
> 
> These buffers can be allocated with kmalloc() as there's nothing special
> about them to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> Performance difference between kmalloc() and __get_free_pages() is not
> measurable as both allocators take an object/page from a per-CPU list for
> fast path allocations.
> 
> For the slow path the performance is anyway determined by the amount of
> reclaim involved rather than by what allocator is used.
> 
> Replace use of get_zeroed_page() with kzalloc() and free_page() with
> kfree().
> 
> While on it, make kfree() calls unconditional since kfree() can be passed a
> NULL pointer.

That is not a good way of describing the last change.  The 
"kfree(buf->page)" call may indeed pass a NULL pointer, but the fact 
that it doesn't dereference a NULL pointer (i.e., buf) is not obvious.

> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  drivers/usb/host/ohci-dbg.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/usb/host/ohci-dbg.c b/drivers/usb/host/ohci-dbg.c
> index 9e0e06bbc570..0a648a7d9136 100644
> --- a/drivers/usb/host/ohci-dbg.c
> +++ b/drivers/usb/host/ohci-dbg.c
> @@ -1,4 +1,5 @@
>  // SPDX-License-Identifier: GPL-1.0+
> +#include <linux/slab.h>

Thanks to the odd way in which ohci-hcd is built, this line is 
completely unnecessary.  It should not be part of the patch.

Alan Stern

>  /*
>   * OHCI HCD (Host Controller Driver) for USB.
>   *
> @@ -683,7 +684,7 @@ static int fill_buffer(struct debug_buffer *buf)
>  	int ret;
>  
>  	if (!buf->page)
> -		buf->page = (char *)get_zeroed_page(GFP_KERNEL);
> +		buf->page = kzalloc(PAGE_SIZE, GFP_KERNEL);
>  
>  	if (!buf->page) {
>  		ret = -ENOMEM;
> @@ -729,11 +730,8 @@ static int debug_close(struct inode *inode, struct file *file)
>  {
>  	struct debug_buffer *buf = file->private_data;
>  
> -	if (buf) {
> -		if (buf->page)
> -			free_page((unsigned long)buf->page);
> -		kfree(buf);
> -	}
> +	kfree(buf->page);
> +	kfree(buf);
>  
>  	return 0;
>  }
> @@ -782,4 +780,3 @@ static inline void remove_debug_files (struct ohci_hcd *ohci)
>  }
>  
>  /*-------------------------------------------------------------------------*/
> -
> 
> -- 
> 2.53.0
> 

