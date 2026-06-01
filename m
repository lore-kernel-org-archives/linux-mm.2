Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50900CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 09:29:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C0066B02F1; Mon,  1 Jun 2026 05:29:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 697436B02F3; Mon,  1 Jun 2026 05:29:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4DE6B02F4; Mon,  1 Jun 2026 05:29:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7966B02F1
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:29:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EDAA18FF2B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:29:54 +0000 (UTC)
X-FDA: 84830821908.20.8251164
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id 082834000C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:29:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VY3EtNd5;
	spf=pass (imf17.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780306193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ETFMAyiIE0AHSaaYgHZJw7aw3AWJKkeGkWZaKEdTd7o=;
	b=O8fWcK5TxY+W+zGhXz5TFLhlxUP6pbRxMEFsSnVtf+jaBaABImqmYFFEOjC4m6AuPnZsOf
	uw/ZKWXaCPgISN976xcOgwT2Bg+X1yVwwmvtmMuXBIbAGVyOJaFiG4w6kzGerZdVDvxDUX
	14ctU+G++MOYmJhIWO1QBrhZQO9CpK8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780306193; a=rsa-sha256;
	cv=none;
	b=hmafJkiT65Z72rivdq9dbrn11R0eZUg0dW0/E3Cda102fKFluyohueCc4yvt3mSeG5lRDc
	oNhQfGDHN2YEBVvqxZYL+M+VcR0jxjOchx7Qktk+9RwMR1JtzBg5ZtGrzYg0jrz9vAnE3f
	pcgH5LWzX/RByw9x0TnFRVeYivjH/e4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VY3EtNd5;
	spf=pass (imf17.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5aa68cd8dd3so998125e87.0
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 02:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780306191; x=1780910991; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ETFMAyiIE0AHSaaYgHZJw7aw3AWJKkeGkWZaKEdTd7o=;
        b=VY3EtNd5bQ5HkhiaFtnvwsaBC2xhSE6SUQrevfdjHvtLcBem/CcxA2+5oglG00cID2
         cNmYeKBA6aYU06I6qk6FO4sPMtTmqBS3dngZSDiyAUdHfIsZ/hjMMyLFK8TydeDIZXi8
         vackj63O0eorle+lhlgX3xoJnw39mqeOqxGcrxkcE24Aw+iQ1Y9Ngkx+A7BFrqCXeKEC
         VpUKdImXqJNlB4Gwxs+fa22BQfqSsKNLyq0ooD0JDeWFFGVtT/oqmEkOvJTtoJATRm7+
         8TiRhXxGoB8PnkSlE48xvZnawcxNY+WwPyzacHDG5jGNVlBiIU52TWwmRcv27Dz+UqAZ
         JbTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780306191; x=1780910991;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ETFMAyiIE0AHSaaYgHZJw7aw3AWJKkeGkWZaKEdTd7o=;
        b=EXnN0z5daTU2MW/EXKyTEq3f7dWhupIyKBHGPTQebSsAwSSPapyh+w1ZJPqBQOftvq
         yd5pI6LzJ7IKaifo+qBeeVKXVVDycn69JfXEuBp5vsgrhe+dTfKjbLWp8XL2XGdlrbCl
         NOzf94nNrSMYH40s4WeY3bRgDyBVAAbvx/dH7Nyhte6HNuJ/OGBbqX61buqq+QxFTxXy
         ZUpos2WxBbZODSqiSyyT/BGb7936SGrQLewgm1nMtRQmHhR6T2DwLX1YAZXC8qhz2pqS
         6I4y+i5vL/iGljva8ePbdNSn6TsAOQvADEXU4apHh101fMgAQT6Pr8DemNg/9ARGCFsn
         jw5A==
X-Forwarded-Encrypted: i=1; AFNElJ9gSd/1YZVjOKJVSQOfDK8cssJn+r5oOaue2IEfwOzhjXxJKKkIJrvBkGdrralzINgTStstrgRZGw==@kvack.org
X-Gm-Message-State: AOJu0YwAam0NdhvRqDmWaJTyqQRRjfFBhEcmZ9bDpKgQ29o/ejnN/Nw4
	X0zJxB0V1VD/zXGm0LOIXDZu6umrb7lrsLleFx5X4bLPdi43kAr4uzpH
X-Gm-Gg: Acq92OEI2dCHo5C0bpTH0hVFGczG0v7NvUFGOQhP9ERFBDGPqOYEuw3YYVEgxGZxCo2
	+6SB0QO32rSlcI1r9yFVBSFG+c73VzYvRkro28/lXVTv8tzLua5Ysb+hVln2zgX7clH/rxJsHRc
	ZqRkwtpdbKLsEdQ6JXeBR7I7x7RXpxtSS44atHAhf+MXRY9WSe1L+rTxCpH2CSeyJMKECvZaKv3
	y782XskpumolNcSl/7znV+J7WTO+5afH9NOGVHY35HLd0k4TW8xnAOHr7p/NqostlVLItgPz84D
	H654sXNEUXXVhJfPbiVYzyKdFtZFkMIFtBTmIE/15NnrZl+aVbImyWbSYy9Iip9abGQ0HvKl1AO
	0j3p/vpJJmYDBRVPD+U7t7Go4GbtIfLvPYcZg9ByS9lNj+a0GhLl2/LqZUD8JJlC2NsOumzPDb7
	WynxH2iwf7LA==
X-Received: by 2002:a05:6512:694:b0:5aa:4ca4:d396 with SMTP id 2adb3069b0e04-5aa607a86cbmr2408627e87.11.1780306190698;
        Mon, 01 Jun 2026 02:29:50 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa5b793b9bsm1976158e87.71.2026.06.01.02.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 02:29:50 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 1 Jun 2026 11:29:48 +0200
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH] vmalloc: Fix NULL pointer dereference in
 is_vm_area_hugepages()
Message-ID: <ah1RDKIJThquEF8a@milan>
References: <20260529014130.671291-1-hui.zhu@linux.dev>
 <cb2b4151-e096-4de5-a064-ee3bfa8cdc2c@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb2b4151-e096-4de5-a064-ee3bfa8cdc2c@arm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 082834000C
X-Stat-Signature: 8r4by4wmispyedqu66yhd7ogpu687ujh
X-Rspamd-Server: rspam06
X-HE-Tag: 1780306192-78737
X-HE-Meta: U2FsdGVkX1/nno35zmSSkkg+MLY2XJFzhGTTQy1bm1ruXefGBl8CE19WVqBBluSyvRrbSHExIYGwXiFWp8VQ2x0AB9LIUI+8Q3tZhOsMtzBIKmLsob9oij5Tuw04Q6nQqbMLxOcyym3VtVF7yK+WY8snscez7e0PRyt0E0n5f4skmxMNrhqhYjjOoUTALUhkiWv92G0HLwOVlkis3ciYcs4zNA+2wkZZT5t8GcbKDjvDTz5OZd/wWjW3lj0NzOZxdGkoI94xzUKUnEm/yMq5oFguLFrtFSswYg4GpViSnUY+y9P2cEgw9act0yShKCjqai0r84WXg4gMN+VyUjcCJ85/Uj4u6qFqt1r1vJFu46TaOos7bTFLX9VJLdQqkVoI9bRUWYKs6R9LvqMSSV3X9QOQBA9t8hn2EEOa+x1/dYkd8E/g0UnSMKR2JuQ7TyOeIfI+cJYN2Vdm3BnsO7luqeAl+fS0/32S0ESExZ1tR1DX2kzK0RKD95DP8t6dobbNfMRPRNRHNdVdoWl0KxgkPAXbBWRkpBNnvaA4GtdQbJ45eMavWWY49R1j4NsrX16Kzk+ttCX3gvTcWo7h0dEYr8AQqSJHjSNwjXv7GQupEbohRA5VTjf/yD9r2G6Y2wUj/n8vsUaeQ8FdNSQb0q2CdbpT8T1jelFwqbHonAnDmB1KfTqGNIruXuDJ6c8aZA53FJbIlWrR4OEVHK0I6eVr4/msGuxEHTcvcKrKQBWrM+FnEBJIuiwAvzT03pnEo18PFWZXm9m4gxZT0/QEE7UyzeHvVK/tuN37/G4VhPpzh1IIpqj5ofroYfmCZ8IOobfI3ZA77aT4qZXl8P2KQN/OPOOUuWG7y1Q/MQxE5h3QV0063fma2RZabocev8wZLh2UKw8BmX1g52sWX1vxAeZidyi5BsanvB+nhHIqKVwUImcLYWUoUwVfb0ViUPhsfbZQWMNctMcrm1JtrQ7t28e
 22aullY3
 y9QLSFr3uHry99BM28Ke03JC6q3yOCP96QECR1i4FWPDKipkHq1Um5jBS2D8gAe7UJ2x/dlB61liHmQ8MY5rpKfjzw0rpY2r6TxXsVkKcmKw/nbFEptu+FFQiMT02qs8xdteR00vDsGk1DfHF4FDzLhwANmbTjX0BJcVClV5eLT1q4xaeieEbMwmxPmrILOjh9c0SlNse9WpTtz+/jRck/UZY0vP6vl0t41tK3wjCQ4mLFlBOArVbEV2bzlD9DtmAiGt3meHHMNYU7RW7V9IiKhVzbeYlw1492FUm8s4GPdlirxicXPGhkgXXTl2lVZtx9QJf77AtDnP1C7UYvzjnKvqAOU3Er6OM3CQPJD4wSBmc1RAgrmazjAKWxZ7/KqzXcqkV7dDGkpoTwveAS27fwYoY2zn81aRqekVFcqN1qNvnBdNY6x9z1YDLqLt55f5lskMW/toB0Eu9oI4BGo2PwKAFo6mJpKflh0fRhKNrgO/JrmPJt0jEwV2RyVNqrxnFCtb9ZnM3mZvKZ8uENq3kZeubTGxG0F65VNowh0NRX96VTSPMGtTobHb+nhTKQguNEOXdc0TWUOEf3fTgLxge8//mXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 10:24:12AM +0530, Dev Jain wrote:
> 
> 
> On 29/05/26 7:11 am, Hui Zhu wrote:
> > From: Hui Zhu <zhuhui@kylinos.cn>
> > 
> > find_vm_area() can return NULL if the given address is not a valid
> > vmalloc area. Check the return value before dereferencing it to avoid
> > a kernel crash.
> > 
> > Fixes: 121e6f3258fe ("mm/vmalloc: hugepage vmalloc mappings")
> > Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> > ---
> 
> I think this makes sense from API PoV.
> 
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> 
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

