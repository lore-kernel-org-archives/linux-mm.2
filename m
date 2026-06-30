Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88AD5C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:03:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5409C6B00B8; Tue, 30 Jun 2026 12:03:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C9D26B00B9; Tue, 30 Jun 2026 12:03:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 392B96B00BA; Tue, 30 Jun 2026 12:03:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 08BD76B00B8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:03:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 88B651A056D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:03:54 +0000 (UTC)
X-FDA: 84937049988.25.B4F9873
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6B8EB1C000D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:03:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=KWO3EDai;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu;
	spf=pass (imf21.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.222.180 as permitted sender) smtp.mailfrom=stern@g.harvard.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782835432;
	b=Npob8o55eiWYiasZKD8bWFr+W7Qm8ve86a/SsbPRchgprYuEMrBkk1+HqsLaSjiKTZxJcz
	evr5DIay05z8+i0hXhMJmMwsDICBAzYsz6mAnMHib+cJbAewTKdt2VMpO+db1FHpSzbVen
	8PEQyI7VnkbT8EfUmSZEz9RLA6+eMB4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782835432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7epFnLjvPec3b1jHkzlheknH4OwwUcUE0lsvvL6dYlY=;
	b=YDRohSj1s0Sfz+OaT6YaeM2BAnl6wDYw3vIiQTwa/9uJI5D0EXlo0NjMQb6j+KzUxYzZIj
	tSTtl94MCYYJA0F/CGLZ1sLXYd5tgzmUvMTivh74XADd3v3XT2nKSZlCcQhi8a+jJWuCz/
	6K7u/QAV2L4EFgiqXeHpWyEAfw3dCxk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=KWO3EDai;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu;
	spf=pass (imf21.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.222.180 as permitted sender) smtp.mailfrom=stern@g.harvard.edu
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92e6a434cabso51898285a.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1782835431; x=1783440231; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7epFnLjvPec3b1jHkzlheknH4OwwUcUE0lsvvL6dYlY=;
        b=KWO3EDaiOjJQEYkY2Z6/CffTP15QMfF4MEgtp6u6Hm6B6s+b+WDV/8eHGJXpLSAP4D
         pXknoEx1R1nfxDEP59HgNAX0IUbCkjWGICtzWMqCJdDmxVADLZtBcDS26GUWqrebmtKv
         JTlFiFK8FTvlktAlv/lmvVsUHxaWik+fIZrm4YCAEmwsQiaMKddKlLJpE40C/cZcvOy3
         gSzMUii0rXwccA7dhyICw/hHNNoBjFmFMjBLbZ8ExvU2zVrzaNp21rYi8DncO2wugMoT
         IrUwCTOc5UhhT/JrsvuYdGo+MCqpVY3/Dp6eZs5il6A3qKq9HQ8o+5ofciDcW4w03stM
         N66Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782835431; x=1783440231;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7epFnLjvPec3b1jHkzlheknH4OwwUcUE0lsvvL6dYlY=;
        b=gyh2qcmB+j3k7VpRtXh0uOjzCf5K1wmLZ9wTyL3/CU4Ggf48PXA4IquDFsFgsspFeY
         ZUsyzkX6EzwkbI1AU/p0JHGx5gDoCMGEqfkXaWvsMtdL7ifmS6eJuX/6IoEumNDQP9I1
         PXsj+z1gZpvm2KWIpj/qbq+T0jtuKcUWJqpilevd5glZ76FYQZo/jiWB7gwDn+gzLPbU
         J2ATEWemFyRSckg2Ck7+Gk91yhIvuViGLhK9OzQL/K5SGVtrk9WnILyeKPsmW6NxX+wE
         W6mGk5PMBKf/oCuxhcqCOKYrjyO1ZabvjMneNu/PRerI8VBHEu2qgJ3/wbniEel1gGUt
         sX9A==
X-Forwarded-Encrypted: i=1; AFNElJ/FMu7ZCpsK9ZsaGz5GEYjjb3dLu0pWLBYGdYNHCLPZ9s54g04S3S/23slMvXf0Knat8lZrHIQ63w==@kvack.org
X-Gm-Message-State: AOJu0Yx1QT5Y/oeZEACaBLoJyVnHGouXsqV5md8ZWXsSNCD/jLKnaRbl
	Kh+mMuIVRZCMgDCRmhVIQHTfZMHPmL5zTr0gOu2dk+i4+WWQrQPiliSiEsHHF2IzJA==
X-Gm-Gg: AfdE7ckcPFLBV1s2m1IDwedXVhroUJH/JJkt1xWS7klWwuuoL9MHCLbVjx+6i2lWss0
	cy+xwv2sPssEEEv9CLHvejxrWGe5CumXNJ3BFZIYntxyiw9wYaXvjZLOE5l6LQm2SdFVr+G3CNm
	h84Q72bxAvzkYjiyN1i1xpVt/TdrKsKTxVpXh7jaCugqL+GRRqzcYdY8rW+f/KgRO+881Fdrmd9
	XHGTP6cnD1F3xJH7cr0SMPr4sfJ7Lv2aHNE3cEhEkC64ttyGws02hg+a4Xs+OFwADnSGcmvRMBQ
	JrhN+2JNCIJ+Z8taKtQzBZ9i67l8PXXJqmyBglaiFse4tTjTgFwcve3QUxK/er5fxRvPTYyhW1r
	gGs74ZTfqTjlkCoYz6sGcfPbXuMAjrQA9C3eqCuQsfQ5iJ1d5YxOpnTLo9kjrW6vk+k0CwNAkJs
	7bQuYwyRb+GWVZo2OuSSw21f/X
X-Received: by 2002:a05:620a:c55:b0:92d:6961:9519 with SMTP id af79cd13be357-92e6249fe27mr694745885a.8.1782835431154;
        Tue, 30 Jun 2026 09:03:51 -0700 (PDT)
Received: from rowland.harvard.edu ([2601:19b:d01:d210::883a])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e622e87a7sm281331385a.28.2026.06.30.09.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 09:03:50 -0700 (PDT)
Date: Tue, 30 Jun 2026 12:03:48 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mike Rapoport <rpppt@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/2] usb: core: devices: use kmalloc() to allocate dump
 buffer
Message-ID: <fb38dac8-7832-49df-a4d7-5488f210f83d@rowland.harvard.edu>
References: <20260630-b4-usb-v1-0-8d547235c374@kernel.org>
 <20260630-b4-usb-v1-2-8d547235c374@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630-b4-usb-v1-2-8d547235c374@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6B8EB1C000D
X-Stat-Signature: obekfps5zxit4mz1p63r4xyfpmej8i9m
X-HE-Tag: 1782835432-508255
X-HE-Meta: U2FsdGVkX18ZiUjYCRvKc82t9ZMSOcwjDSTSac+syE/BDQLXq80A39o5x3SjzQ9p90wlfxQSpHsXJx7oqtP1h1Wt5UcJlQndi6OdUSqMpVDavflz8Jys0WGP7OBEEzxVsHSmsRMeICyfUgVYZh/+lwbE/b+WWJT193V6TRQ/ioAjkqrvJ0jkJxbk+hrrk2QcxvYgcFq9MeBiPtfsljnTlq57ge0sxtG7NfvgI8feHyGo9t1NOP+hjHARkhK0gVAec2RPFy9Rvxp0J5GkUXP1ccBUnoCvVmnTGi5P1mbClKsazeGu5Mr5emrEt7MQf+dRspbL4FFS3zCZmlVwtrfMXyu7aInWmOk88+NkXc1gE9g3hw1nMk/PDtItySEW2pYbIxz1L21bvMzsn1MVWajoGxor1Z7jfRdHaCGbbB7hLUBfPvibwPOCnr7JrErYcbwWsyxDJYz7PxYiCMs0s3RzZnT6BmkNhgCJKJVWDrvum+ETVzatW7qbjSQIbQil4lCGmDMWhA5trRYvj2DIn2NxEb0f4JTnQYDW/DXmFejoS/I+5nntjHxz27ynAePOG9CYj+z/4lRuLp9Wym8WRn7mRAb5ZCkh1Vf8RWKqnqx32ZIGH6HGs1fFs6yGSUJPCNpUtDWDA8sAs8Rk7XFT/5+s49BUDQxeTWZvtuvzCKrgo0/Q+9s2L/zw1qBb4+Ysi3Bo2qrcUHp8ZJ4ZyQ3APU7Ndq61jIgH0gxLtzx4IcRXDK8c+QWqPvJ6l4mGv7MTW5JD6ZkbQ+Y6PhvKhVcWZSBA+tqt1YPqr2R/Pnw9M1eOslGHpddo58pHuhWYLZeFoA0mQisbkoS2yZw5tmh1PoHHBkCYzKRo+Qd2PxMvqQz32+8Ua0UVs/FAZbOYE5O0PaE5nIIs4Jh2L2NNYigxhazUiz909XkGM+s0uAk57C+MonHtDljaFuA0Ydl1BeTQP0tFpYFAzJBczOCLN3FfkHn
 Rz0+ptAu
 j7O+kfNxymY3GUsV1Wl8lMFZz1n+7g7y4Kth/pI4k8Cp39x/fVi1XhWVt8tY88le1WN8h5p9m6cacPhuiqn0FM0/hjqAJJSMxB3NuIqoAYAIhMos4V8bzU8Ic1NFi4TWx0VNFcecriZltQz/86K81P4aRoxmBH+ySvxxW0oW2UANOaSSh36MdlPrshFvTh9Iw90RQ0Juf5VrkAIu0Be9idvA3UdOyKlSu627Og9JfgHfZEaS0neTLQF5wRFs5aItvkQa1PbbkeDl6wHnQZYmIIBXsnLrxo8ksKID0n+LB4trTlmSP9EYMD2OmA6X2mq4n9IhIjKqK0unq3GL198oIVWm9hrJJ0cBvdDBqvqFlwvVK6HR0GtXRid3V2EKjusVUBEYTGdNxNS0x7UNlFjDU/h1X0ahRbIXb6iE7aHMIRP4LJMYOHms7LCROfjE6QuwepsU2WukTF/rxDDPu1xslGrB7H9iH5xoH1N3XRm9Pmdbgb09oesXuxCwMckPaFPU+6U5NuOYrYOt3leH5qCuAx0hH0czs8Swq8eWnNpn4hcQnaAIeAeRg14PVbgt+/YfxCzVK4DU2aJMkQOXkNalMOGS/aQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 01:27:09PM +0300, Mike Rapoport (Microsoft) wrote:
> usb_device_dump() allocates a buffer for formatting
> /proc/bus/usb/devices output text.

You mean /sys/kernel/debug/usb/devices.  There is no /proc/bus/usb/ 
directory.

Aside from that mistake:

Reviewed-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

> 
> This buffer can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.
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
> Replace use of __get_free_pages() with kmalloc() and free_pages() with
> kfree().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  drivers/usb/core/devices.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/core/devices.c b/drivers/usb/core/devices.c
> index a247da73f34d..6f0354aba38b 100644
> --- a/drivers/usb/core/devices.c
> +++ b/drivers/usb/core/devices.c
> @@ -37,6 +37,7 @@
>   */
>  
>  #include <linux/fs.h>
> +#include <linux/slab.h>
>  #include <linux/mm.h>
>  #include <linux/gfp.h>
>  #include <linux/usb.h>
> @@ -408,7 +409,7 @@ static ssize_t usb_device_dump(char __user **buffer, size_t *nbytes,
>  		return 0;
>  	/* allocate 2^1 pages = 8K (on i386);
>  	 * should be more than enough for one device */
> -	pages_start = (char *)__get_free_pages(GFP_NOIO, 1);
> +	pages_start = kmalloc(PAGE_SIZE << 1, GFP_NOIO);
>  	if (!pages_start)
>  		return -ENOMEM;
>  
> @@ -479,7 +480,7 @@ static ssize_t usb_device_dump(char __user **buffer, size_t *nbytes,
>  		if (length > *nbytes)
>  			length = *nbytes;
>  		if (copy_to_user(*buffer, pages_start + *skip_bytes, length)) {
> -			free_pages((unsigned long)pages_start, 1);
> +			kfree(pages_start);
>  			return -EFAULT;
>  		}
>  		*nbytes -= length;
> @@ -490,7 +491,7 @@ static ssize_t usb_device_dump(char __user **buffer, size_t *nbytes,
>  	} else
>  		*skip_bytes -= length;
>  
> -	free_pages((unsigned long)pages_start, 1);
> +	kfree(pages_start);
>  
>  	/* Now look at all of this device's children. */
>  	usb_hub_for_each_child(usbdev, chix, childdev) {
> 
> -- 
> 2.53.0
> 

