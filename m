Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 629D8E88D6E
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 01:44:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAC766B0005; Fri,  3 Apr 2026 21:44:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C84386B008A; Fri,  3 Apr 2026 21:44:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC1D06B008C; Fri,  3 Apr 2026 21:44:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ACB796B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 21:44:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 601DE1A05E8
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 01:44:00 +0000 (UTC)
X-FDA: 84619177440.06.751C3A4
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id A583E20003
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 01:43:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kdqWqxJi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775267038; a=rsa-sha256;
	cv=none;
	b=1YAUxKdf6uLFae++vDzv5NX2vxUJO+r7uSoX4+bmeElyKxyuGS/FZ+ytomxVtU/xfB8LqQ
	v8b42kNH710e3V3oPcAS8yToviaInvW6TlPTg5qt7Z8tcZpGqr9hCRh9tBxp8HO3qHllep
	kydXpLi5T+9xGqEdkY+jXDaeSL0+mb0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kdqWqxJi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775267038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=mSmUlQx+7wcM8hvk6KgWAN6mYWx05Ua8pH5lZ6mYZjw=;
	b=XxLc/m07UtUGaSfPT2Mlf5zs8H0OsFUD8d5zFCRce6wqpOLnVznShcoQFL+vTQZjzT7YJp
	VuzU2XjKghHoATUHmIgFFuzdGFui+xIhnNaqqOPZpexEmo+sFL9+/4XunL/u8SE2enJsG7
	W64HbAeHpO9vPiiyCaYG4ZNBbHOwcOs=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ad9f316d68so9807135ad.2
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 18:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775267037; x=1775871837; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mSmUlQx+7wcM8hvk6KgWAN6mYWx05Ua8pH5lZ6mYZjw=;
        b=kdqWqxJiR6nKGY46Dk6oUYQYcmqIFM1M3axUdoed1FGxzCwKxadOIUh/Qn1mB0ZXYK
         YHpnJ4LcG/OVYmKf19otACd2cp33/qybF4Amokct0el8+pUQefTCKi72ogZLkSSOQ7JP
         I4zpS0oKbvyvygxG3vgC54kFACzVPVjt2gNujvCaHkb3SAbIzggGhNdp6rOVKNmDX9/C
         FzVN2X6nhe6YFi55MuOT0QhcY75dn7R/efay8oJ0IR5FZf8IBArYGYk1ddAijGs1aCYt
         In/wfGfIfeh7Ov6hAM2rdqCswIMiMFexpHRaGifql020dx8d7Tox14Fsi0p7KuSHqpAT
         2ZLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775267037; x=1775871837;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mSmUlQx+7wcM8hvk6KgWAN6mYWx05Ua8pH5lZ6mYZjw=;
        b=YXpPRW0689CtJTohaPYt2/2AOxr4d1Na2Af7F0lxE/+2FQGVKrB8eV4IBSWXJi3uj0
         PTViOv3S62BjvpHluUyCVEzuZtSQN1Q8ogB7oVD4t/eLh4FjhV3eBMoHQn2hEC8XSa95
         SnDYZaary3DlDdHtY4vU2nUu21LR37MP9hHz5mo2hMXgVKTawlqaSerJE+invVMMghst
         82xCmBhks+XAUNJYtuIl7gaW1ZVyoR6vu+aWA6FjjJEwkXXZ4Pi4jM+UoDOXi8THWdDK
         tkMCin5m1wZ3+M129qP0L2nHoKwRbIRgyheDF9fwX1CA/iOWhPyeoqDy4m13+Dn6k2tb
         gHnA==
X-Forwarded-Encrypted: i=1; AJvYcCWUAU5f+KK1bbpVfl6suXZFWIApujZrvKfALlDHKBpGUbfwrCb8Lep48B4AS5ToIQYrofrV7AznfA==@kvack.org
X-Gm-Message-State: AOJu0YxD7Y6eP8zFFg0NPfn2s0BuRBwsTPzHRnftMLRgOFkLSYRgLud5
	5QBnHPmNYsyN/L8ARCMReUjFMlnG2O3vapRIu408NWVbscW9xzKRbCWKTYSmiBR6
X-Gm-Gg: AeBDievBg7a/orpIBc2waa8zrK/oFtHlDDXuCMDCkmO+DaboFASqFhDKWdGR99jTWNQ
	fKI5r9SKVHW1YwILUBsCpLR0pyFwymRY4GqQxJ9rPHnwzwOd46fXvQ9RNLuKeoUsz3WYMe2kkjH
	8Jw+QFfuu/2LrlbC3ZW5wBp8zAUPmUknGOHgMX9XyI9wblodeuqO5u2GZQs/KdpDbiCvnsjPAvd
	JQY3WJcXfDoadmI5WqczXyIxLzAyeY8bOCN+ZtRvKHFa+qNt0lFSYgnTtQQPxu8XtfTVLQJjMi0
	DDjbZbYbIiiv+62XdXBpW18tbKqZDGUOhyQmlav7fQKYnAWzhCwZXhzx4QgAtygcUYE1r7i6ddk
	sM7ed6buVc/GQb61X/xS1FXAgC49/7mTj8U5i8bAo6SIiQ0RBwmyKLgKOhCoQQcagfod2IoSIlL
	AwHVIklk7GA4bHKHF7UqyMHeWdoKtbc0SR
X-Received: by 2002:a17:903:1ae3:b0:2b0:afad:7aad with SMTP id d9443c01a7336-2b2818016c3mr52841215ad.45.1775267036795;
        Fri, 03 Apr 2026 18:43:56 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2749cbca2sm65157255ad.73.2026.04.03.18.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 18:43:56 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Salvatore Dipietro <dipiets@amazon.it>, linux-kernel@vger.kernel.org
Cc: dipiets@amazon.it, alisaidi@amazon.com, blakgeof@amazon.com, abuehaze@amazon.de, dipietro.salvatore@gmail.com, willy@infradead.org, stable@vger.kernel.org, Christian Brauner <brauner@kernel.org>, "Darrick J.
 Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order allocation
In-Reply-To: <20260403193535.9970-2-dipiets@amazon.it>
Date: Sat, 04 Apr 2026 06:43:06 +0530
Message-ID: <bjfzmst9.ritesh.list@gmail.com>
References: <20260403193535.9970-1-dipiets@amazon.it> <20260403193535.9970-2-dipiets@amazon.it>
X-Rspamd-Queue-Id: A583E20003
X-Stat-Signature: 78gtxfxj7sfaicfc6aonfu5hrsjngq8z
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775267038-493701
X-HE-Meta: U2FsdGVkX18U+tT8SYwZZIEwofumadVeUkLcfvRFHV4omxkaehmnsrD/RzoLdvc+5/8PJn++STFHGBBBMFj+18bX7jGEQATZyn4bi/QatsZtwVDvM9beJa7vE5GNwBIZHnmpl1u6wzpWGKaPCXqhw89+odxPa6M6NB+zNcLUFZFU8EhhjfkFpzcpH6jYfgpT3QSRCZ9vzCGaAR/Ta6iekPXSCaeyq5+T5oM631Mv4xw4Ba+WUKOGXlBv+mDpm9k3R4voSGgziEDXe9zw6KTRY/MbeD70MbMJrN4wFbTSFOWD/BKOf7Dz7+0EthQFZwJODcqYkmx+X73e6OzNyzHf26y1mppoFbuMY0hsUzVhZEA1Fc5OyoogkRCKbAzvZDhrc7n5k3ZDSg9nZiYeI04DdPpF2OshwvkQWftKHmekEMIKqBB3z6aEdFUUw1TjpgkFyEGD5inLWfmjh2qirS5quB6L5n30IgVUY9BcHQL+1grl0dNLr/EBX+4e3aYbud50LOBjKxJuO55aTQFl9R1LpzJ8p2TFwvtpG8hd1DAk2LwYgUQd0pXr3dPi7NsnJjUWHG81JS2CmmsBeaj+nQGtCs5b+f5jjbkQPhCcowtGYGjT09MXvYDgtXDMNP4+571FBs3XCl2/CSN9dWjsLO9nWr/7AkMAn91ywODFGM9/lqb5qkwOxH+m3l6sxxigLhjLDVvVETKcl5bZska2d8lL6XDEbIbCUR8MKdzNR4OAiknD1gLUBEgmqeMQwFTTL7OPHD4c4JBhrKYFO6vQVSqclfSYiDfzD17g0v8xPUo525nki7OPRC/ZIePu4kp9EzcYXs7HZb8DFsqCKB6Uepj9d2m4Xyzx38LNMPnBsRwxAZ7omCn7AAa+4gtVa/sqE0XXOcomG6i2ltRxVA+MiYx/41fgwTCmvnyj7PsLtI6fUa9czR2hCiOFOzEEit96DxPMC33wmwCrWpUGsi0ryPf
 GVMrXlys
 aXLyBSsS9KL5YsraHlYRGFc5lLj+DnM57GCXGNdO2jm6eEW6MXcFYZnrgJ0MKTJkMDZCx/dvZGMwLnIFfUpq/S1HWwbtw/oGSyn/yrT9O4oaqafnFmRX9lkI3OaYabmFdva3o4XYl9gbYCtxIb2WK6Dcrcv/4KHSACprpyPQ4V1pwhN46v+X6WMCBImDSONsI30s0NvMUK+9kheOUMR2GOzi6nIcwfg3xDxVD6WcXAyzKK6OL58Ib04pGZHmKHEsVBTLJtDbl86DCbMcQGG2wlIVuq+pSaBkoAyqT7ePeQVJH8bgthN9KlCVAtvAXJag2xJv/R5BW0/fRHzQu0zek/nSIcT1ACHkkY/uQbptwVtJYrJPRWM/W42nO3hv4A6hsbIGTQfDo9IR3VJGMCGJP8w0ht7nbb5C9o8f5eeTfwZepHEhUhBDdz32sWfQibTpMcf5MFd+TVKnjjfoErvv9ksMKLJnyFgSu0cGYQjfUUpePL38=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Let's cc: linux-mm too.

Salvatore Dipietro <dipiets@amazon.it> writes:

> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> introduced high-order folio allocations in the buffered write
> path. When memory is fragmented, each failed allocation triggers

Isn't it the right thing to do i.e. run compaction, when memory is
fragmented? 

> compaction and drain_all_pages() via __alloc_pages_slowpath(),
> causing a 0.75x throughput drop on pgbench (simple-update) with 
> 1024 clients on a 96-vCPU arm64 system.
>

I think removing the __GFP_DIRECT_RECLAIM flag unconditionally at the
caller may cause -ENOMEM. Note that it is the __filemap_get_folio()
which retries with smaller order allocations, so instead of changing the
callers, shouldn't this be fixed in __filemap_get_folio() instead?

Maybe in there too, we should keep the reclaim flag (if passed by
caller) at least for <= PAGE_ALLOC_COSTLY_ORDER + 1

Thoughts?

-ritesh

