Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BE59CF8864
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 14:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E58836B0023; Thu, 20 Nov 2025 09:52:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E30446B002A; Thu, 20 Nov 2025 09:52:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D45C86B0089; Thu, 20 Nov 2025 09:52:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C39F96B0023
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:52:50 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 81E351A0197
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:52:50 +0000 (UTC)
X-FDA: 84131277300.20.7FA4F8A
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6502A2000A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:52:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=WynErOhF;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of axboe@kernel.dk designates 209.85.166.179 as permitted sender) smtp.mailfrom=axboe@kernel.dk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763650368; a=rsa-sha256;
	cv=none;
	b=R1qPfLg63S/P6IrvGW2cEnkOEAB0VHuzf+yMinBnXgIkGVWCLmBSni9r9oJjjyBu9Mdznz
	suFGelK7rCNaoazHQLVHKtsDYupUdbRoP33fvSbmu++66B6NBxmkulSMG2zqlPjNYCUtfM
	354xgyjTtFzFPYOgqDaQlcrIq+BjnT8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=WynErOhF;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of axboe@kernel.dk designates 209.85.166.179 as permitted sender) smtp.mailfrom=axboe@kernel.dk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763650368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mIp1emodWmrQX+c6TjoXmEBGWcecINECr9nK+dGHBUw=;
	b=bTiqvBz94bWA75y9OXSKMs1T5UXrFF5wU3CQaQ11rglSl8/L9e4Zhg6WobrO+2zyo3oZsE
	E7NZOCWsjaOFqXgOXKAr0KlPSrdmJJL5C8hXV4S3S/vZSMU/WTZ15/ZhnrjkZyroySjj05
	0FkIbGFm36cdafHTeg34ahGNzNTqzFY=
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-43476cba770so4317485ab.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 06:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1763650367; x=1764255167; darn=kvack.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mIp1emodWmrQX+c6TjoXmEBGWcecINECr9nK+dGHBUw=;
        b=WynErOhFnadvEz8NB1l34y9qM8ebu7/WfUjao67Xzm6PxO75MmZuIFPPH/0L80iFXH
         rpfn72x9zkfwWV1rr5JjCqo/1k//hN/cvFU1MmMMTe6BzHZtY6NPF8Q6VBfAPpBP3o0c
         BjJIYjVr1KmeqzCIv7FRDAhjegIGRwNMQJJ6B9EUUVp5KvrdavvH3bhdfdU2ZvLimecR
         pnccN0vIUEvXQsqo95p+68M7sL5uio95lDMnCFP58c7kX62cE8azi/XBhC5rD9IXMOkU
         QfyHYYGmpI96hDKwLlH2CxCekvvNcoHgD/LfFoy75OW0hdbXCwvIW5PM3cIYlesh/9IV
         744w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763650367; x=1764255167;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mIp1emodWmrQX+c6TjoXmEBGWcecINECr9nK+dGHBUw=;
        b=D95lksLCjfZ3Eyj9Uk+7KZaAQCfrT3oHalxZNaoIZ3y7li4O4BjJjSt92L46Lr+mYD
         oRwSqfAPikL99P3DLRVeg7zp4afMEVaV1HgRxqQckULT1ejZkhhSVpwhA9aqE3ztD2MA
         b/xSIz9SMAQPjyaMOtAgaijnbOtb0TIiNvbmHzXcMVIr+rJOsNXKoakEwHLkTII+LKDi
         kM14btdWMA+RhqZvAdpj/xf+05LzPc7/1kHHHgpXSXxAQdPG7mdJCEasUH8sFejVBEFR
         CuGP7bN+Zh467pwaHRFzisACcKb8O/YVlnPSx7RbPjnN4OjKZIEVirCR9tt6y6OjpiIU
         6SDQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9VdAAz6+Ufm1FLhyRxnhRFfktws22g6BDoHWi8bIxqoIypJaX7K+PiXMVQGpniLvrT1lEIwAtCg==@kvack.org
X-Gm-Message-State: AOJu0Yw59GWcinAxm8dnyw5szlObcaWc7wO4y8GSHj7F66GgGisC2zgy
	6Ar07Ig/fpm521uJKpOAR+xedDXzl7JEJvnmXq3dpyMhe5DsnIolFWdQkxTyS7HrRmM=
X-Gm-Gg: ASbGncuA7/kXOPGxH0ArmTxaDSBOjbZKpQbhdXLaisAwB4wdY9ab6/Dx5XFgWqsoGRF
	6aW/BJGQjDEg5eAOvOV7BfdCiNU+Opi5kzIjnMFsBHgoyqZCP5kEXCldsrGVJ1Cib/Hrx0B81xd
	y7FR7b/spMe5kaKdq8wRSFLERAE84blEE/zo9R34Avq6mF9zhRgkyTrtYvznppJKd6pDltFQnuj
	tkvd7HXSKWCodUxM6bMmkVUD4Dk5T9ZFKR8gAmKLB6AteYYs4MFT4TO42vUj4ELYfbwzIQob0un
	lG3beAh0XwqTvC09YGaGftDJnSnLyo9Z1BOqImhp+7zq/PZ6S8qs4x4M3b69Fz1FVUpaUCOPBgD
	geNyov82kUAUQGsrvraMhXtzw07tjO4/zIqqWJch1mwxHYSizPgxSEbVQOK6cCUl54NFL8d0Fuo
	CLQQ==
X-Google-Smtp-Source: AGHT+IEmRlVKCe07qbgo1t2w3uFpBKsqx62crTftDC+8sZ0oUBIrcGL53VTRakva//fmnWvcfQrQww==
X-Received: by 2002:a05:6e02:1c01:b0:433:1d5a:5157 with SMTP id e9e14a558f8ab-435aa88e822mr21434775ab.6.1763650367018;
        Thu, 20 Nov 2025 06:52:47 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b954b207d7sm1008611173.33.2025.11.20.06.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 06:52:46 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-kernel@vger.kernel.org, david.laight.linux@gmail.com
Cc: Alan Stern <stern@rowland.harvard.edu>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Alexei Starovoitov <ast@kernel.org>, Andi Shyti <andi.shyti@kernel.org>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Lunn <andrew@lunn.ch>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andrii Nakryiko <andrii@kernel.org>, 
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>, 
 Christian Brauner <brauner@kernel.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Christoph Hellwig <hch@lst.de>, Daniel Borkmann <daniel@iogearbox.net>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, David Ahern <dsahern@kernel.org>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 "David S. Miller" <davem@davemloft.net>, Dennis Zhou <dennis@kernel.org>, 
 Eric Dumazet <edumazet@google.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@redhat.com>, 
 Jakub Kicinski <kuba@kernel.org>, Jakub Sitnicki <jakub@cloudflare.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Jarkko Sakkinen <jarkko@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
 Jiri Slaby <jirislaby@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 John Allen <john.allen@amd.com>, 
 Jonathan Cameron <jonathan.cameron@huawei.com>, 
 Juergen Gross <jgross@suse.com>, Kees Cook <kees@kernel.org>, 
 KP Singh <kpsingh@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Mika Westerberg <westeri@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Miklos Szeredi <miklos@szeredi.hu>, Namhyung Kim <namhyung@kernel.org>, 
 Neal Cardwell <ncardwell@google.com>, nic_swsd@realtek.com, 
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
 Olivia Mackall <olivia@selenic.com>, Paolo Abeni <pabeni@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Peter Huewe <peterhuewe@gmx.de>, 
 Peter Zijlstra <peterz@infradead.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Srinivas Kandagatla <srini@kernel.org>, 
 Stefano Stabellini <sstabellini@kernel.org>, 
 Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>, 
 Theodore Ts'o <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>, 
 Tom Lendacky <thomas.lendacky@amd.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, x86@kernel.org, 
 Yury Norov <yury.norov@gmail.com>, amd-gfx@lists.freedesktop.org, 
 bpf@vger.kernel.org, cgroups@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, io-uring@vger.kernel.org, 
 kvm@vger.kernel.org, linux-acpi@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-cxl@vger.kernel.org, linux-efi@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-mm@kvack.org, 
 linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-serial@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-usb@vger.kernel.org, mptcp@lists.linux.dev, netdev@vger.kernel.org, 
 usb-storage@lists.one-eyed-alien.net, David Hildenbrand <david@kernel.org>
In-Reply-To: <20251119224140.8616-1-david.laight.linux@gmail.com>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
Subject: Re: (subset) [PATCH 00/44] Change a lot of min_t() that might mask
 high bits
Message-Id: <176365036384.566630.2992984118137417732.b4-ty@kernel.dk>
Date: Thu, 20 Nov 2025 07:52:43 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6502A2000A
X-Stat-Signature: m3bwyoguchpbdwp1xwr3fexkfn5e899p
X-HE-Tag: 1763650368-508981
X-HE-Meta: U2FsdGVkX1/H8VoVCJgGPyZv0ViOrR8xYwOEbux777G/8VPthXNdeMRmdyEIpteO8sIIYZm+A1+0SJBLW3vtbvMWcpKP1LF7VdH4CRE79TZIqoMW+A44V3ankTXHVLGyClHzE+f1iewhwcoR+tyE5rGPp8y8kXOyTrSYmywFJmJVsXhncrhQvJ5XDJEjy7BmxX2FonjBiUl66omorYHWYqhEIlDY3rCw0cYSVgm14Dy3xuOaNAABFEmgZ70FCLNGsXAn/qhrDMSS/LQkEzDdwHwfjNS03wmw/14a9oysST21EgHqe3rcWt8nNq2iliR5lVlq1ZYB0W187xwQHNES+CMhLOc32kh/RDRtEptU/eLb04dV/fWjNOQF0c4cD7X84qbLsTfDvrj4prexV9hOXZy/XqRj0SV+oEAIwlT1gLbuAEgDZKxKwJQBntT4n0px6Cr8uc4+6zK9xH0nLm2vWMGO2A6EH56mfSGhzJ2nQLTTc5HsYL1Dj4LpBOqQuwzVwgLuJLl2ElmxlkWesrf+nrwQGZdrNKiMKHLXu+S83b7lk2nODniQstVoirzx1y8QTrq9UyyuS7ZrsQVwDkqyLJOF4MR0Jc8aEykbCesTSU6CIY7R0vW3FylfFT4Y6Lmh0/y0ja6YaulPBgtphVl1bfPLLTNsO6UgULJ3buHMYziIcb3UPKDjoPtEomgAgU4DQiwa634cpQplvnwo3TAsBkjnpt2toR4VbZCG98qRCKEepm0LjmV5+SUaCaO9KmJHacqYLdeAMjDreaUaZkHx0h7nNTSQcb6cGhj/PZE6GfblYdAF8BxVBQh4VI2EGT8gl88y6gk4cWA+byWDqw0h+UO6S9nlvYVqbXhgfvts5Jw4OXF9Rk403Od+F9sas+D80v4KIfOdhD+TuLDTmZHPhhK9XWHWi8BjmAsWT8UnJOalyRpJuPmA5Ed87r8zNYPgBVECiLTBSG19HAAMiwu
 7Araqj25
 pjgWXPqiRYyIDY3qCQn4pewC+3jKkR9ypbHJdHw8eFfjJ5qpT8/Z8YMJeGowzg4iL5yDdOxXl069FybD5KDHszGjjSRxaon8vx+XhUGhc/kbWiVTA8ztAFuHdJU4VLon7G0Ozzz5OHQkCMeygbfHpsCYfRXQflWjvRpTEB+/7j+0zsz7ex8q03FxHL02qLZM+OT0+Asik0yuSt03nDpvYCj4bsSPoJkP5TBoT1AfC0gpBemT6vwJYUnxZHkytiYgJ437r+t1dNiX57DtA7KqkTtVwz/OpYRFcKcfQv6XgzxSkpQRt4LbewGb/3sTjvgNLtSTaO5h3Vg+VdyMYlz/Y0KuuymSof6aX9+B8p9w1oHLQ1VmTFa4kS2sln6jB+K3uRvLldhrPKqy+SliLjp+RS8zV1U4K/Yx92KBuGj3LgDQpc0WYc8efoCobgh7B2Xf3SuzWZ1CN6I1zughrD89/KeyUyyt4Wb0uIY9QzSkBTdusUvfjy8gYym44e6AOdq/5gyofM1eHUMOqKE1cdKTAp1urudJtmMfRmBj0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, 19 Nov 2025 22:40:56 +0000, david.laight.linux@gmail.com wrote:
> It in not uncommon for code to use min_t(uint, a, b) when one of a or b
> is 64bit and can have a value that is larger than 2^32;
> This is particularly prevelant with:
> 	uint_var = min_t(uint, uint_var, uint64_expression);
> 
> Casts to u8 and u16 are very likely to discard significant bits.
> 
> [...]

Applied, thanks!

[12/44] block: use min() instead of min_t()
        commit: 9420e720ad192c53c8d2803c5a2313b2d586adbd

Best regards,
-- 
Jens Axboe




