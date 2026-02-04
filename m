Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C313E9D401
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 15:24:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7383B6B0088; Wed,  4 Feb 2026 10:24:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E2B16B009F; Wed,  4 Feb 2026 10:24:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E5866B00A3; Wed,  4 Feb 2026 10:24:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4CABF6B0088
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 10:24:16 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E8CE91C043
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 15:24:15 +0000 (UTC)
X-FDA: 84407145270.02.CFC53B7
Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com [209.85.218.67])
	by imf18.hostedemail.com (Postfix) with ESMTP id D00991C000C
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 15:24:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=delta-utec-com.20230601.gappssmtp.com header.s=20230601 header.b=ePXXiEna
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770218654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HOCklTVJSoz/0GlLyW4AmbDRNJcWn4GEKUozxS6wdv0=;
	b=tELZWZOlzk7AVeuPq/gpPovY/wxuKNqGEDqe+waXn9CnBCiGosRLo5ziZsW473+1pKK09z
	A9Gvg7mlbSesvGymOTgRflLtM/lO0eoqQTSe6nTJLxLoTwVXXn3bQgEXnS2dRnjpAF7+b6
	hrSqkgg5ss6LgGo45myByQ4IXQhIrJw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770218654; a=rsa-sha256;
	cv=none;
	b=PGFU0VKwzJ9fHm80lHXJ+2zK/vQIqhw6t/sq+szjmv6JxVDpjEzCVgRtcAQPHD9gRUk9kK
	RDmk4AAoyhqD6VYeNuzjXbfjIBut4scskK2iaV5a1m2Ze4cHoV21euPSJpanacS5CnchYb
	Loo5pgLsXvpq2oXCETm/W0LWZ5X+vEc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=delta-utec-com.20230601.gappssmtp.com header.s=20230601 header.b=ePXXiEna;
	spf=none (imf18.hostedemail.com: domain of boudewijn@delta-utec.com has no SPF policy when checking 209.85.218.67) smtp.mailfrom=boudewijn@delta-utec.com;
	dmarc=none
Received: by mail-ej1-f67.google.com with SMTP id a640c23a62f3a-b884d5c787bso1214881166b.0
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 07:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=delta-utec-com.20230601.gappssmtp.com; s=20230601; t=1770218652; x=1770823452; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HOCklTVJSoz/0GlLyW4AmbDRNJcWn4GEKUozxS6wdv0=;
        b=ePXXiEnakfaZDsLtlYVqVELOVpHFbOYu/tOUCSpEYuosTgXGjRniYyOAjuoKykRFxR
         nsXTbDg6VCBO14ZekUT+YgBDPJP2pMMjzGuWM/Ix/sQkHNBF3q4EJpHMmtPBGciXMgOI
         G7jtfQY0KQ13h6Tf8Qejdw8kFRw9liY9//3JeaN2txvRqJrnsudmNu9iAhQwrR9HNGhW
         K7l2SrcJZSdQZ7Wf4BFWNRKOLK6ppbAyiHnPwRNZmwii1K5Q1P6CtL70G6C/nYp5tvG2
         OX7r/DFpRGGMTNCrP/sXYoLYX9aJt2Daqxf7V7W8eC0qIT7Wq19c0eV8JkNa99O5IyF/
         yh4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770218652; x=1770823452;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HOCklTVJSoz/0GlLyW4AmbDRNJcWn4GEKUozxS6wdv0=;
        b=OARRGTPiBWx2zCrIX+kDrYBSxssVqqoTTEcTxKm/oRuzD911kcI2sqc4KZQIogQb9T
         7+xXysS89TbH4bt9AkUJdsdMWuENmJUkU63XwRoO31+8xlrV1EnR4Nw9Yw9ljCx0QtVj
         xcKA+NCqAEoLLGDrZA2Ls2Y96HchAR8nlyRP985J1B2fSwzWWRxts7abK/N33Hri3tnd
         8cVZx4yCYKs2kSMBJzQIXFAvqDfopo3SXx8jVi/Hm7FYNqGdoGDDREe01xF8N7muovcz
         HPrggYA9f/WrYbPLDCNJWDdWEdKAibr0Pp/LXBrKUyznAgL6nm7koOCtlHDzZ9hfbUzp
         7FJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKWacjcUWMgqHfVR7+ScOHO7KDzmf7VfFyBqY0von6QIan5O95JYeeKs0UC56lGynbtXAogcQtFA==@kvack.org
X-Gm-Message-State: AOJu0Yz7qlbFCjEiw3ITHFB7HWG5lvGCnLy09JnJfaEcplvc3JyeeHFn
	XB77xSjB29VbKDU9p/pMBGNZvE//9u6O0BScn6u8fsds1Hp6lIYyXFOtncuo5hJWyg==
X-Gm-Gg: AZuq6aLxNtLAy3/SdMy6sbDm040RSmu+x4H77GaXK1YpMsSrxACg63AqsZwrM9rgWng
	XMivrz0aaioU4cNsbF+pQYx7h1OBZ92FXc+xHOqoIeTbicyLclkcaYoQb4NZmRl7CQaXm0Ea93/
	AegAyBPMjE48mj7DLIyBL2+qlNC4SpTCPqSDKyb5STBMj5ed0jOnZVEtG/DiLrUbzqT8oGGfdHl
	LbNFXIJ0UDS4CSSRn3PopMke03N3kAY7ZY//5tihezBHv31uMSd5OgqvnbNk+jWfvaPqRVMcdLB
	CVtFr1SpYswahkH5/6b7hTehoKfL51MTYoHlFdWL+H5UDNkNICefj7OJHD6cAhz03kRXJeD8ZlZ
	EO02oDZ5Esk6Ekdy6flWeylymHnEF9WDvr2HwqioevrhdCiMHp8A9jheq07fnelxwZkmK2V0wj1
	a9jgK0aTjW1UHdxDceryjjHORuWzFJYcL/twMH187uN0Ob9tRUARqHIYQKlIkjoKSLl/3piT4E1
	M/zX+ZA2OQX8c9c+8Pq+ViNDnDY6F23CgpE/CwuqbXIJ4qyRg==
X-Received: by 2002:a17:907:746:b0:b8e:4470:6caf with SMTP id a640c23a62f3a-b8e9f0d470dmr235513166b.22.1770218652002;
        Wed, 04 Feb 2026 07:24:12 -0800 (PST)
Received: from bou-desktop.arnhem.chello.nl (2001-1c00-3406-8400-85ea-1e81-1e0a-8a4d.cable.dynamic.v6.ziggo.nl. [2001:1c00:3406:8400:85ea:1e81:1e0a:8a4d])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8ea0044a09sm130627866b.56.2026.02.04.07.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 07:24:11 -0800 (PST)
From: Boudewijn van der Heide <boudewijn@delta-utec.com>
To: jiaqiyan@google.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	boudewijn@delta-utec.com,
	david@redhat.com,
	duenwen@google.com,
	hannes@cmpxchg.org,
	harry.yoo@oracle.com,
	jackmanb@google.com,
	jane.chu@oracle.com,
	jthoughton@google.com,
	linmiaohe@huawei.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	nao.horiguchi@gmail.com,
	osalvador@suse.de,
	rientjes@google.com,
	rppt@kernel.org,
	surenb@google.com,
	tony.luck@intel.com,
	vbabka@suse.cz,
	wangkefeng.wang@huawei.com,
	william.roche@oracle.com,
	willy@infradead.org,
	ziy@nvidia.com
Subject: Re: [PATCH v4 0/3] Only free healthy pages in high-order has_hwpoisoned folio
Date: Wed,  4 Feb 2026 16:23:52 +0100
Message-ID: <20260204152352.55606-1-boudewijn@delta-utec.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202194125.2191216-1-jiaqiyan@google.com>
References: <20260202194125.2191216-1-jiaqiyan@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D00991C000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 7dc643u6871dcjahz59jwqxx8zfyg7ok
X-HE-Tag: 1770218653-517422
X-HE-Meta: U2FsdGVkX1+MJUKR7vIsGaw7up+9QvIcniwILMRGqfJQGT2gTQUvCvOqxXus6VUTlGR5kfAO0R4Gbs7JZ0ZqisFDYjRewRN4NJpu5v6/zXjC4xrssFS3nYi0g/wxQ0IkdV267nSN+m7m8qeUpVGWFf6OPMW2McssYL+M5FieNmACC3ozlAEIeM2svSztjwT45qEK93k4Pq1UjhJA3eHcdLMFCshufMgWhNX4koBW5jAIpm+TVTGRlbzrlWlOqmwlaRDVBOu+xtQvrVDQXxlGyXF4XNKadui4bHoAWy4KB7guVnCjrelpxdm5XEjmYwMNqVXTEhNcVbdG45BBN2bsgt61QCEE/QxL6EN2Wt7VGnMkdmLWT/Xi4wzbolDOpU4ZKBpJzeh8hb0ywpxW54erFM3BP+c/OHLAfmAi0zstv7TIiPYr470FbaZ6I43V8DgjN8T9AmJ9yA2kMlzO3AdUqNgB6eWxfQiSQMwz/NZhM+Ut+48/crLEf9Noi64YSb2AiRJnL2tQaJLQmNtfK72JiGdBuFt7BfGFifw/rE86bQ537IYO5d3IR9jLHjSmpUwYq8nIvTQp9rk1IaluYFgEEaytT2+n0eGtjKQIotZ4YanOpIQ1W2pvLrcPcc9X+exc9Z+4m8qU4/rCrAenJyeZqixk2xO0BEPnPxooewnuPBiAq0AUbXzmxCVU9xzrIviVLXQxfeSkJv6n7QRm9SQPJfHuqpE2BfKS1ffSrwo0+hV68POL5EFXuZx3cxAMoUSdV1tnPYbZ0Fog9m3Q1m27GKVFGdPY9ZvHXL6767MRs6xkTMtWOuh4p27J2aCuDTtf6PJssvPpoBP/lwAN8MTa5jgyI+R3Dve8JUbXyXvQOSGThJ/m89LBNSbaG4C5vLsglYm1+TZDeNp0GeqqxLKM5LQhEd6XRl2j1ONyEZFPXA0EPjZT6DNZiuK2KYMW9tkLxekq76NSf35UO6xQs0x
 OHa4wg55
 p/KcMLY4/lyA3AYaid5rHbhJrUr/E8n9eVsg+xyM8cxKFITKeXcz2vM2OtcQxsVzRsIjhpvZmL4hWzabwz8sXd2a8Mo1fXLUBv9FvvS5sAkfgfZPU6jLTe7bbhHmb/UTa2ZZzC3v6y+81uKjWodvj8PdHJmMApneEX3H+wCfWuR7rNAmKAZi9I/wvEglFr9DVO9QWubdW5CeeVKceC9+jG2PIXB5DFv0ZA9uCzaBqLgsp/bD7jaOw32MW/VzBRFL/bKsqa/7MCriuydgBPeeVsXS/jPrORzJlD+cszRwFSxTgwBP9F8Qq+u3NGbus9OQ4Fz8eg5rBA3RTGyQPEIkTi4N612VbSPZhkHrzHjZjE3e3C5PDiF05sam1BdVrK5i7NmiZlJC4gXPTW4xTFtjrv3JFL6qtLY3AlookvYIVxfPnQspsI7/7fT6UpDFYudV1WLq3TvsmFDFH5KHCa95wlIO7X+rTY1ijGewAczfmQF086cOik2BlXgdQgNp8n1GplY9O61CpLvwPy2bx7Ai7ZfBFqCnc8ekv6cTfwuQYeMIsEgGJ5a2g8gg1DEaQCO64vPVkF3qQnjbNeGAM0FOeUi/0gZBmD39NSH9JyVJHA6HIihhn48AuTAhNMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jiaqi,
Thanks for including the THP scenario.

> Another similar situation is when a transparent huge page (THP)
> is handled by MFR but splitting failed. Such THP will eventually
> be released to buddy allocator when owning userspace processes
> are gone, but with certain subpages having HWPoison [9].

I think for failed-split THP, we need to do the following to support them:

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index cf0d526e6d41..3f727038f400 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2479,6 +2479,7 @@ int memory_failure(unsigned long pfn, int flags)
 		if (err || new_order) {
 			/* get folio again in case the original one is split */
 			folio = page_folio(p);
+			folio_set_has_hwpoisoned(folio);
 			res = -EHWPOISON;
 			kill_procs_now(p, pfn, flags, folio);
 			put_page(p);

We set the PG_has_hwpoison flag here again, 
because when the split partially succeeds (new_order > 0),
page_folio(p) returns a new smaller-order folio that doesn't have the flag set. 
Without this, when the THP is eventually freed, 
free_pages_prepare() won't see the flag 
and HWPoison subpages could enter the buddy allocator. 

This aligns with what Miaohe mentioned in the earlier discussion [1]:

<quote Miaohe>

IMHO, it's enough to handle poisoned sub-pages when in-use or split-failed THP
eventually be released to the buddy.

</quote Miaohe>

Would you prefer to add this to your series,
or should I send a separate follow-up patch?

[1] https://lore.kernel.org/linux-mm/20260113205441.506897-1-boudewijn@delta-utec.com/

Kind regards,
Boudewijn

