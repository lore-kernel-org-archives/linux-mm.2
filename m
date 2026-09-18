Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7F67C982DC
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 11:58:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D53B56B008A; Fri, 18 Sep 2026 07:58:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D04BD6B008C; Fri, 18 Sep 2026 07:58:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF29C6B0092; Fri, 18 Sep 2026 07:58:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 995A56B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:58:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 30F0280680
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:58:16 +0000 (UTC)
X-FDA: 85226734992.26.E2B6016
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf31.hostedemail.com (Postfix) with ESMTP id 659EE20003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:58:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oTQHI4N4;
	spf=pass (imf31.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789732694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PPJuKezU+0LGqyieR7K4QMTdZgLRjpBWSmFo8vmzfNc=;
	b=d9szNR71wcKBa0yT/SGIO1BHiujZhPx62MCbmAaawHvp5hWe2nmAEn0PQ72uezyUa8JcVF
	t1SURX7QpNLSbiq0S8El/QK4KQxeRE6t8AA7sKkQ63diS/LUsYZsOgFIMgKGTtKjtklDOv
	sNAlfQ6DD3RAI8wsC8/uDmYwtvhjAQs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789732694;
	b=3wFhyVFF307H+tmRcR2nyGnSWnoIjIGCCZdiQYYXxDWGlGFbNvrf+rdjJAas3eLw6fqIOR
	tX1/NQ/oeZ837ZsYIbbk85ta8pGIGfeq4RbjKPYku1/GPeembvo3N2ZCymm3k0B0BACT0Y
	20Y5bO5RmXdhbqYkOGsYMP+ZvQ8f2HQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oTQHI4N4;
	spf=pass (imf31.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843f22dcb8so461733f8f.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789732693; x=1790337493; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PPJuKezU+0LGqyieR7K4QMTdZgLRjpBWSmFo8vmzfNc=;
        b=oTQHI4N4GoTBKBqe6XyZ+YOXrBpJCcESGtoM13GD2EZaOmlqbwpi/jBue/+OSuD4W1
         vPQnXH0qAbKVZR0foT+6ZVmyIXaZKnVcXt5gvKN+UmySRwoFIDmpBNlSyHC4Suu6tmEM
         4ZjuW3Z/TWTDGxuY/TlVgxn1/1H5dn3OZnd7BBomBeqncjOozfqyyh5tiMbvfLtsYBek
         vTrT60C6wwtxMDYg2b1Ll3KEQR7jYOmanTjM1H0UPtfGSskXm8cfc018SEJQz/5Gahwb
         Jyy/kK6wAu7npDr32uMRqK13s/M7qrf+3QZG4UD81eapTlT1fgV2/20fGzVvSrXtCKkp
         a+HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789732693; x=1790337493;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PPJuKezU+0LGqyieR7K4QMTdZgLRjpBWSmFo8vmzfNc=;
        b=kSzBdiAkz17/p3/ouL6zMCtZjhF5WNiMOdnpPV5J7Ccn+GR7TQ8NivHWUmCvpoI4z1
         1IpNG5jmca5e8jjyUf+UlUUz/rF3nFq0aKm8zU/Ih+duW2CwQU0jLs6grO0vgp92syyB
         ru06cEheZHktd47j8IEyZiQHPtgcU3kiZ+d0FX9sARohbp4fv+KfbdO39n6XJtPLN2Bv
         s0V6KMS5SbrKpoBi73udfb5O3XKuuL4lK3+7ToCt6ksLc5L1pjLmPSrM3yShqbhXYOai
         bnit/eNRBLA3MGr+mTjsI4tgIa0SDvjiesV+9p5KQ6SyX+HNo/VUXs2do9d0xbHDnsX2
         Bo/w==
X-Forwarded-Encrypted: i=1; AKwUvBwRTCPGC5Us8TMDf9F6MSCgIqtBcT5FUufWL49SzEQsw0wtB2WT6SvSkEBLN1F2OrguTVXBRYsp4g==@kvack.org
X-Gm-Message-State: AFuF++n6GTFazv53ayFT47G/RdsPcR15CFXeb6Lvma3CwBIbuZ7IYD/y
	uPDuMg0QOPeZ8ShzT/nMCiTYvFvaV6xcJdUQu1qgLI33D7JSQCQZ7Xei
X-Gm-Gg: AYBFou0OY8G2ETUxwWKC6JjO8HlZMUYOOsHS5n4eqnui38WAD7Si1DgWnwXQtlwnY0U
	4ziZ1sc+4wjMspeu6P/fx9kKMWTcsnPDesycaX1gRjyx9EFN/66YSVhHY1D5swVNJ3iLtHZ3GUU
	GR2Pc4B2zPeUvxtATZYVcpGVr87h+o02Ulv8XElqXhO43E2CZVDpyUljqQ/ITiaPP31EfMTlmAR
	GlbmCug4g22QXFPT48V0NBiCoTVrr/oLMgA7lmrFKYN8EqvL+dGWaE0bGEXtnHDV9aqrszh9XLS
	HdCu9qx5dqXXTTJJPlPwdl5V7XJFn7gh0rqkGiABMyaLM3IvsnIPebFxwhP2eg1LG0UYJ8fiqfo
	X4Y6BfcGBJQmwRQvGMXPrwkNuYYEkUGXm2bIgbgbdRoS2vadxZs6gHSNZmzP2QBNbl+r9Tg6L6p
	/LlDboIMiRn9/6EX853T3K5C5ciN0dJlMiVbcNgiYSuXGGLyiFxLoJoPPhP3yWgcY7uPdhhO2Vr
	HxEaj3Gs5ueDHZOU7xLOrySUcdQRZCPilIWR0FLZPlKA9SpCn+CIIMv0kt/ERLpH7ERuVB7
X-Received: by 2002:a05:6000:184a:b0:486:e300:a0c3 with SMTP id ffacd0b85a97d-4871e212306mr3249545f8f.12.1789732692470;
        Fri, 18 Sep 2026 04:58:12 -0700 (PDT)
Received: from localhost (pat-125-254.wlan.net.ed.ac.uk. [192.41.125.254])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-487203f077fsm3145025f8f.26.2026.09.18.04.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 04:58:12 -0700 (PDT)
Date: Fri, 18 Sep 2026 12:58:03 +0100
From: Karim Manaouil <kmanaouil.dev@gmail.com>
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, david@kernel.org,
	surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
	hannes@cmpxchg.org, ziy@nvidia.com, ljs@kernel.org,
	liam@infradead.org, rppt@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, kasong@tencent.com, baohua@kernel.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	zhaonanzhe@xiaomi.com, lipengfei28@xiaomi.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] mm: adjust free_pages to make
 __zone_watermark_ok() mTHP-aware
Message-ID: <20260918115803.55bfl7whbvc5q25u@wrangler>
References: <20260917171642.b4pkhqmvjwnq3vmq@wrangler>
 <20260918024238.31128-1-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918024238.31128-1-zhangbo56@xiaomi.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 659EE20003
X-Stat-Signature: n1nqy36um88eyt5okntndj16echb4rp9
X-Rspam-User: 
X-HE-Tag: 1789732694-18137
X-HE-Meta: U2FsdGVkX1+cs6zaYbPREKZHuxTsRo9wy5Z7cznkItFhma14GuFPQAEpar2GyPb9wiGYBmeI/HSHOlCbnbPf3XYERrgO/uD28Nfb/OMphmvtH5pHZbSVxnj5zrC3+rweryTFbIANZXLLUST8KiDNtB7+mRuLRcP076zAcE8TJVL9Dw+5SFIrFDxqZbB+p9L/0mduRuLsGJa2UdProIpieMovG+XJpyFy5YN2hpByq9gWCeSPqpFDG+9YvhKVndnuv6nvCIupIT5YzdB8U4t48Yjiq+De59omjaNEb1/Vlv4VWAyn5UWnt5+waWNHW8SKfG0yrnYy767itJyu3MsQi0ILXFNyPmU4n8M0hEJXxvYPsU0bPzc3fCyjUsPDFYNUC5VTr+ZJspr7Y3GKPUEAXFQ2fw8bVInf8NDBO9lsy0e0xY79iu8kiniaCQRVryFNdbb5R7k7bvyeufjvyVcABCJgeL6Ge3DNNLiowz6TvPr9+fsh4XvPxPF0INlWPd1DyYL85JQnxP8eGuKQR32OK63jZfrpskkUlS+1vCxfLvO3LbKk1gBSz+6EEGnZZ+Bu4CFahNGedzLy5CFnFnu+nAOeDEnMVe8VQrx7/GTSnNgqt3mJNXmA66+4GbWs9IIkUXgQ/SrFVtogyWjbuTr/wYadSv9cm0XvwLJpBf+RlwBfpZGO13oHvzcURNSVDaWUPBCjHBHH8+X+tJtVacKotqRPsocSbm6bbYdxFsPg8vtq9jAczyEu22PkQoKG5Y29cBJjlleDliqJsxV30gScuvFjfFaXSo+3OutX44jWh+anhlOwaUjfGtM3sitkimKiRNyN0Y59ZEDn0PX8MZwuqlDmb8FfOpRHpp3TOLfuLTFIsivbfriKZn+muK+WMXhHYczEM095t6bpjIHGIY6lsMxp30t41aO9KR5hqLQI/SE6eZ8qVxzViG6riDxeGSGTh9k/5lfs1lfl9wLxYvk
 eTuwSJM/
 tqkaItZtiwZhIAp4CbHGkD/TuzREqh8t3GqQ0RfAP1VNDQaCj5bJLhhOM6oNmBQjvUnL7J0uuS5ehM1+tHwTnUddSPDPUF4Xfskf1jcb/+yuiYYqepgL/LOxE9LRLy8pWsMTjC/o8JpurZWxfeYovEarXgRoCvPYCCdoJYLKE1B0lvweGWI2S/vig8eQSmEOyRgg4TccV3aaRrnyZUpO7yKx7jEnWVEeTGE90tFeI1k3/JRoPmlno/8/xcJzUtfkFmlCSmql2cT6BmWezpppyhggz/ZXP/LQf24CpoC6O4ZslIYWRNyi3jsDva0Rnmb2OzcttOgtNqNqCm9+ibLrPnbPE+nDHQA87vFFsCXoSzJr5eO64ggpOrZ6PJ+yrsOupWZOz1hXzUyXBg4aG2nxgITVjEHUZ00KcVf8LoZQ1kN2DiakVG1cxiV0gGNevvjRuqRE8cqkMgKS+9N8eWxlSsfJpa8lLwxbjP9tL5IArsb1vXlWRv5oSY13+toSMHeqqXPwaS5IxkWNePE6QWAj6zyjxliBSfFzkZd/wMGrsASPGT2o0rDFw/wD2td2E697OzYGwiyQANY/evNrbMy1umxpT/Yf9KZDe+sc+eUamBVl464xA7DMSWx9XavI3+vFCR7e/B7eR/i4F2J58F2nfNawW8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 10:42:38AM +0800, Bo Zhang wrote:
> On Thu, Sep 17, 2026 at 06:16:42PM +0100, Karim Manaouil wrote:
> > > +	if (READ_ONCE(huge_anon_orders_always) && order == compact_hpage_order()) {
> > > +		unsigned long free_pages = 0;
> > > +
> > > +		for (int o = order; o < NR_PAGE_ORDERS; o++)
> > > +			free_pages += zone->free_area[o].nr_free << o;
> >
> > I understand that you don't need a precise value here, but in every
> > instance in the kernel source tree where nr_free is accessed, it's
> > accessed under the zone lock. Do we need to use READ_ONCE()?
> 
> Good point, thanks. The nr_free read here is an intentional lockless
> estimate. I'll annotate it with data_race(), matching how
> fill_contig_page_info() in mm/vmstat.c reads the same
> zone->free_area[].nr_free field without the zone lock:
> 
> 	free_pages += data_race(zone->free_area[o].nr_free) << o;
> 
> data_race() documents the intended racy read and keeps KCSAN quiet.
> Happy to use READ_ONCE() instead if you'd prefer.

Yeah, data_race() is probably a good starting point. Thanks!

> Bo

-- 
~karim

