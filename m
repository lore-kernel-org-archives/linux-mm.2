Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC861FC72AD
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 14:32:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5083B6B00AF; Sun, 22 Mar 2026 10:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DFCB6B00B1; Sun, 22 Mar 2026 10:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F5C26B00B2; Sun, 22 Mar 2026 10:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2BB626B00AF
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 10:32:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B20321B6E95
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 14:32:18 +0000 (UTC)
X-FDA: 84573939156.22.C7623C5
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id BE105100005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 14:32:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K10u3KI6;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774189936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wYytzbtyCa3T3ZEJMPNabj/veqCBuf8R/DhRbokObN4=;
	b=IH00pht6cAt32bDoIDTc7pnP0dNJ5X4sBzViod3FyZXzieM6729kkot8HGxNQunfrs8mto
	UZXxXKW4DqWWMEuKewkZqcSTfc3yeVEDUV7gxiWKkpK7PbMZD4Ba0u80M4QuzXrLT3XIY8
	HEZpV4E3OiHW1GOivo6B5SbW0v7415o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774189936; a=rsa-sha256;
	cv=none;
	b=WrZA3k98TP56ldr+weV5sUrDPKyvwht/fJ5lwvKuaVwrJxrWXPd7ilRcRglkGvnCjHWvHu
	TfIXk/kT6GouIibWW27ZMLE2SSRgdvsELYduoEvCoAKKzfcfr/tCTFHnxM88kfi0n4acE6
	IZD5O93P2zGBdxiryDoXSxusmYYdrSU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K10u3KI6;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5a126c8aab9so2338324e87.0
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 07:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774189935; x=1774794735; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wYytzbtyCa3T3ZEJMPNabj/veqCBuf8R/DhRbokObN4=;
        b=K10u3KI6wL7/EY2Okt+w9QFiBFiGZqHD9/eo9cAKLdlGIOZou65n7GY8eYwbmsm5vB
         kEvUejERZM4tTQjkym1FjriQdS2RyLkeDgtAtJ91D9UZuWngIzlK8kEoGJXlsS9ow8HI
         0ItgH4rJbUGjOwjWAMXgyfeiHA9jIjX5u+mr48uKADjrXIRjXaik9GPxFaGoFXxELidJ
         HGos4fC7bkQoLEFKyIYff6MTWKGTpFI8LBQ7urjkSTOy3Eykro6py2wzJ6g4LZ3EH3nI
         4W8tELHF26QlBm16fS+uj6ilip+WpOpGS14AUtvCtK0lb3oHMb8CxG0vJIuuYVkBwdkK
         +XFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774189935; x=1774794735;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wYytzbtyCa3T3ZEJMPNabj/veqCBuf8R/DhRbokObN4=;
        b=qOY6dqIyrfUb/p0/vW8ITHcr0fMg6qrRc6KwyVUahx/1hSygNmiMbCFblkTRTVZtXW
         Zf5yGSwi2QH7wncx+6BiXtXAjnlS5MrlAW/SS43zhWmdlJouo7imvbMhFKCwFMqaTIpZ
         gGGsP/nF8q2bv0vik4uY9bigwq1+CZbDFGukXEhkXhvaQtuOEYd5F7u8mlZdMZ7aELXw
         MoPXvEoDtSNQA6Opcbvij4GvLtnyyJZRpdI76Q83s8abIIRPv8ImWbwfQYGfbavccO+k
         t4ZLW81Gl7ycPOd7ddxHOPh+3iG/Mu6F/JhO1fEDdAFoOo6uetK1w3KDpjb7MAQCCNne
         HPYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfeyWmBMee11p9HSrHS0Jb5yLWdyMLf8AdNqPrF24lP8fmNksfTK+gp/e6ok1I0psGEnUaZYngOw==@kvack.org
X-Gm-Message-State: AOJu0Yw//ld640iHQJfcqD8ImAlXDjw1cIMVk9GAUQ5UQ3Lv47qkG39F
	pivpbuzLuCllvLDmBzfLWpfHMi2/U5UH/Yg6wTAxJZNepp88bdaajORJ
X-Gm-Gg: ATEYQzwwxRNhG+sAvKMnrio9kDnX3nHHkbYmOv12hzSJJHI+2ztNrfKyNJy+MSzfF9q
	0yFSemZ/CVGpTbxeEwMItRYFNNUOSk0lVXxe/B1k3EhutiznDx5LhnHocIp7PSbgsJC3w2moJWW
	J2wQi4nwEf0rC4osqAY6li8CaC1cCM7Ze5XZXYDUz77i4eOjI13/ZEdmIRtN2MHsfvmQ6dWrCvH
	s8cA+Zyjp5NIFsPpGbs1xM4Pzen+MXd9ucYFKMbjeNTr4EHkMkXy9o+bixKbjZFZeBEBhSXhyFu
	XqrMjsCnzXpvqCVdZs6Ccz9Gbf0JNWHJMjcB3ScuKIei7pICMS1XHtGDCHs1dUk84n2lE52DoY0
	1mjLqo5rCO5aG14yD7icMqKF9XR/FsFA5mAgToDO7JZPuJm22S4ojLBovTMjSp/k=
X-Received: by 2002:a05:6512:1092:b0:5a1:2a64:202a with SMTP id 2adb3069b0e04-5a285afe555mr3096947e87.18.1774189934521;
        Sun, 22 Mar 2026 07:32:14 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38bf9aca58fsm18605251fa.41.2026.03.22.07.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2026 07:32:14 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Sun, 22 Mar 2026 15:32:12 +0100
To: Alice Ryhl <aliceryhl@google.com>
Cc: Shivam Kalra <shivamkalra98@zohomail.in>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v5 0/3] mm/vmalloc: free unused pages on vrealloc() shrink
Message-ID: <ab_9bJJQ_pfHEDvF@pc636>
References: <20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in>
 <03262674-2df0-40d8-b411-4735c6f43770@zohomail.in>
 <ab_lHPFszBj6zM67@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab_lHPFszBj6zM67@google.com>
X-Rspam-User: 
X-Stat-Signature: q6yrkcx9fn5abms4fcn8qn4tare6h7t1
X-Rspamd-Queue-Id: BE105100005
X-Rspamd-Server: rspam03
X-HE-Tag: 1774189936-193169
X-HE-Meta: U2FsdGVkX19CD8xB2PABvRpYt7q9wsvj/6NRHaVQ0i6dw10Z/y+Duz2dnzlgiAvRqElfEb4BRBGpNxmHiqktfD8Yu60x08Ds9361MOgKmFDNZn693tjUE2dmWuresinBisCLUSb+O99Sjrx6H/9sxa4kDzp45W2Lrgq7Gy2Y9tO7tQ8ePWLej61krL3H9V7/72lCC7rAJCSvF2vxx1EqOklBjeulwwd7YtVKAoT2uJ8Y+ETnUifG8J47D3ouqbn00aIb3KWFXP+MtIZuMeHgpd+8WxyU1KVvbBPC1HxQYD6l/FqUqqjN00NF9fExLJhQp181HI6mNATAajt6NM2cy+/BLRqBTmUacdnECXzYVymwSam3hLeG3Yn5okyus9eYpFCDnOJS9NR0b2uTMg1+BOqkbnqvb2QPa0meNX/y4SLc8tr6kuUs9kw+s/WGopU9Aq3ybZyiOklHcAL2njif37B7X1TsZiqsluxaTXOPFh28iUIV1YPjkKcZmtEI/GXVQzx7UBjjM12+UOZNK7I7PnY4vjQ8gxRhd245GtF92x538lJo6NfPKeKHeErBVJoY5FyXctY36Vw8fnJHVbQ4HuXR+19yez6U5b7KcUjn++tp7DsfKcH1l+fK1sSb/01cC3/rFDsRFu049sXZWYfmHqGs/XwdRGPGoCHeoiU0kcIdJ4h1PAofJmmMkYQ4zrHy3BOcSGnbacR/eUDQWriTypTXS/KhRkzcRJVvWeHZzdo0Lq1kyZwEigSUa7ACkgAL1RcPt/bLXv5Z3ALcLEYt7riCuRZFB6roO9fS2QHLVAIf8HpRwYRU//eG6p+SgCScrTm3NsJ1ThXirmFaj+zuhdnJpnONKcPZwrVspU2mcu5/ZaFZktDQGC469UC+Fzfo+P5CPTK+UTCoPwYejLngJXpasyrqShNnzqajozjCxJr0Hss/4ANkOtO9r8ckAlOTooQklok2/93FJFuLhxK
 e7O5uZuF
 nvni2xr098GhJOJWphTkt21nAub9RjwQOVCYrp2Z6Qrm8deokkhaC3vtkJuwGD8A03E2uXigaUUxV4ljuw1FS53EvM1gBcuKRrXiCcQ7AS+FZeTofQALIgYKEgVc41qG8mapmzs2/O3Mi8kTZ19Z7cM+Ez8iECHZZcogVcGHRXpVhKciETLmjAgJ0BdAfKxa50qZbgOVPpBcEjkaL2jAO1TH0V4/AAqrHmpfvVT96NEXvXSI6DPYSGtVA2Mgy+cX4tSBijmZg+1rm1SMuio7vx03rVveLQ2YJudxA+T0TwfY71ktva9B6b46DR3Az8GKb7GJVa/QZFuhGUu5D/IcoNagg3lvgbUeofiYigsCwv8VyWH77JBRF1oX2VESSRC0YRoREfh9cqPIw/9RENsvST2bGcBpBnYxjR3vL+b7tPB16o1Gkx2AmiiaGwIqfHsf4NQKv0UsHSmgObWpfDaMbLCz4M/i/t5O4XyJ7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 22, 2026 at 12:48:28PM +0000, Alice Ryhl wrote:
> On Sat, Mar 21, 2026 at 01:45:35PM +0530, Shivam Kalra wrote:
> > On 17/03/26 13:47, Shivam Kalra via B4 Relay wrote:
> > 3. Fixing a /proc/vmallocinfo race condition
> > `show_numa_info()` iterates over `v->nr_pages`. During a shrink,
> > modifying `nr_pages` and NULL-ing out the page pointers concurrently
> > could cause a reader to dereference a NULL page pointer.
> > Plan: I'll update the reader to use `READ_ONCE(v->nr_pages)`, and have
> > the shrink path do a `WRITE_ONCE(vm->nr_pages, new_nr_pages)` before
> > freeing the pages. This guarantees that concurrent readers either see
> > the old count with valid pages or the new, smaller count.
> 
> This doesn't fix the race. Consider this:
> 
> nr < vm->nr_pages == true
> 		vm->nr_pages = nr
> 		free vm->pages[nr]
> page_to_nid(v->pages[nr]) // UAF
> 
> perhaps changing vm->nr_pages should happen under the vn->busy.lock
> spinlock? show_numa_info() is called under that lock too.
> 
vn->busy.lock protects VA in a busy tree. So if you update the nr_pages
of given VA you should hold the lock of the node VA belongs to.

--
Uladzislau Rezki

