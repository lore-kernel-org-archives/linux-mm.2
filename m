Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8636DCD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 07:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0BBE6B0095; Fri, 22 May 2026 03:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBC2F6B0096; Fri, 22 May 2026 03:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAA326B0098; Fri, 22 May 2026 03:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CADE06B0095
	for <linux-mm@kvack.org>; Fri, 22 May 2026 03:50:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66E3EC2F93
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:50:58 +0000 (UTC)
X-FDA: 84794284596.11.A19F7EC
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7C44120009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:50:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kBDsj2Fk;
	spf=pass (imf13.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779436256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kIEb9ggG0eAxPAQdLyg2Vnh861QdBe4aCNdLHS7hOUk=;
	b=PsHenr+nPKE/hHhJF4LaFD3950hrL1AI6p/IZN3cQquWRoKNO/Vo6LBmrWXF8CLlwpIOfC
	amuQ6acIQ4wprrJJ1l5eOIV9ddi23Nlzkvj0Zw87tmMbLM8ORon8X1Ra8XOl90IGoa8wPU
	kLe5LZSovQPqvb5i5T+gQoGQRuYrugU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kBDsj2Fk;
	spf=pass (imf13.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779436256; a=rsa-sha256;
	cv=none;
	b=Y0ydPI2aLLQ8HRmQSbsoJlsNu4UhPVrYiuA0nIV82k8i6rN+2g3SMsNgg02oudGoQ7OZDB
	ADGhVi1jSCqo1S0usRk2yS1IaeWUC01sfErLVln5kWON/hYPZoxF9crze3p5nAmVpmDzZ0
	PsRCeyFOfL+k9PsLETziwFiaduJIXUE=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-44a044cb827so5209086f8f.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 00:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779436255; x=1780041055; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kIEb9ggG0eAxPAQdLyg2Vnh861QdBe4aCNdLHS7hOUk=;
        b=kBDsj2Fket0e3Qkm605Lk8imHYWYFGn0YCDFQpnZ8+PTA6/y4nf0XH7L/JOyYFauXN
         TowziHOJ2/LpQiU7qKLDDopgj9lOCgBOsI+8fEzm9b6mjT2aF4nqN4UEY/KeyzBC67mh
         xOLB5xQuLjhTzYtkJhzDX5VaeiwqMWa7HCI57pBWsNLjQX2KzhwaMelUCj5XtlPClsuZ
         zAbJTREevTpr1wmrUoxzwaJsmtw2Clfi2mNyugBaAv6D14zQOIAHrmiRt8/2eaVhaVAM
         2OXo8UZVhdWzMUNOAIuhyCbdqNLMwB33BMjYiPXPnabV2VafvcOQ4jZB9pVaQ6RRYkNL
         DsoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779436255; x=1780041055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kIEb9ggG0eAxPAQdLyg2Vnh861QdBe4aCNdLHS7hOUk=;
        b=dtFTUsy9dnAeqw9E3b38IXCV4+qbglpOZhTRraCj0gWVVd9uiekgqdJumi+0oG02C6
         sLz8OmVd80/s+Vrt0a64VppNObwEPNq7s7Xp0nDhy89lyKmTqSKsD37TREKhEhHsFqZ3
         UPvp6du44KpSCb8Tizl+a83uFPxEpw8V+YoGRj0rGnEE7bWTboKtp2wNt+i2ZIM2t7dd
         UEoGOIwDTiMu+C+C+84s8l2zbF8y/wR4jUnqePHB08Oc5BFMCBPgDpSBV/zeOSoEwzaP
         LUFgf6Xowr4EWC81xVPKtcfwHmihf7/xnpSQcBx+2zIW4BRqx8nk2N96gQQRggP62ZBD
         Qwnw==
X-Forwarded-Encrypted: i=1; AFNElJ9kUNyEbFf4OOoUPtL2WTr6MgSlVv/e7vlvSD+P+jTPybSQdU3YMBGXML27sgW4KlewfJ9wS1uIww==@kvack.org
X-Gm-Message-State: AOJu0YxbVHrFrmBSNlBQT2vsHkw4MQI5NJqm0M+cIUICTL4VLu09K0u1
	qfY9yc4tuO3JAw1erffuZ9Ki4AgHNKxKD0qm9+pfbRq1I39Y5G0BaSXJ
X-Gm-Gg: Acq92OG4H0dFqTJncYz/Wh8qflTGY62v4k2rTSMXmshjuWpx5oOqRupasG3KjdnGfru
	bkVsAQCm0PMnpxHtkAaQFjLTLhyTMZgVfyJSHcRsW0hafI0bcXl0Lb0iT2INtA6b0TLdh5MOUaz
	4ZjmHf8dnKoeXoM21pWV4uAnGFbNaMANwBjlKwgOEJqxDO2dLK67sDSyiR8vMxH5nIZtIAJnPMe
	BhNFirmbnSF3hLnIH0GUqM+LxNipZX8WCTjmfy8LeMRD2a5BqtnQVxHsPTuwC3MThZQNkhOFser
	UAlLmbS72QepN9UIjemM+yeYOCXt7yHrWWuEMiDgeh4o20xLDcCckLKEkVdkUvheXI+6SlgGlmO
	0ulup4R+PrGOq8uaWI4ziNnD4+unXpK1dmT4fWGnMo0OHSWKN40P7HFaRa1VhFooPrt9TZ06sZk
	3Ap5Wr/a1DW7ITB6n6hquRc0rfl7iR2XUhLX+woMdvRpi9dEMA9GpGGWfowZkF3MDIjtdoqnX4/
	0w=
X-Received: by 2002:a5d:5f54:0:b0:45e:73a5:e1ed with SMTP id ffacd0b85a97d-45eb36adb4dmr3485752f8f.27.1779436254515;
        Fri, 22 May 2026 00:50:54 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d64eb1sm2686180f8f.32.2026.05.22.00.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 00:50:54 -0700 (PDT)
Date: Fri, 22 May 2026 08:50:51 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Qi Zheng
 <qi.zheng@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Harry Yoo <harry@kernel.org>, Meta kernel team
 <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH v2 3/4] memcg: int16_t for cached slab stats
Message-ID: <20260522085051.0b4a3f9c@pumpkin>
In-Reply-To: <20260522011908.1669332-4-shakeel.butt@linux.dev>
References: <20260522011908.1669332-1-shakeel.butt@linux.dev>
	<20260522011908.1669332-4-shakeel.butt@linux.dev>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7C44120009
X-Stat-Signature: f8hra3neg68z3s1u799t9i7z96azt8p9
X-HE-Tag: 1779436256-965424
X-HE-Meta: U2FsdGVkX1/HLT3Snd4D0CEHQpja/l67ZJSgWkDyjxTf44HMhecD7Ln8eoFKzkePcVzTxIOJWgOTjQC0WTx+bXXE3dMHXGM1xuiqDl+VZUrFFE/kpepUfOHU12Juhx57mudhz5TcMGHNLqif7YZ+rY43ETZasZYcqY1jv606LwVJWSJUoikAD6lSX1CcqVWh8sUw1NmGIciKkvlRi5YxJfGL1bLc/Yb5VzyW0CS8dPR/tMRVRhhykNw4OJlWDzMZqzfXrsXikdIb5/V/3DuaZ3l7gUIF5WA4RQgij08Eb21nyYRDnW+zEQfuvTxLu8x3zQ8CkkwIJl6mUbHxwdZi+3TRL/BQ9gzblehwzpMqP+6hP9S0Amyh/jcwSp3MyTqLX90Rk8K2co6XNJiVPXqae3BW/gUBDt3XXP1jCghvmitCYeL+5cJ75RbJfoUPZl+gk8FkE0r/ZYZGcbsCeXPUftAStBu/wEa6C3MJ9EpWjEXNvVJ3EJR9l3b3dK0Bcp0Cu96B6Gfo32YL8/F8tKxzQCM1Fn7PFvh8snGlxBdcstlEdzlzf4CRNgT9I/pkf4ZEBsy0nPOTFvLZ45VrvW7onFnFGsIgj6VRqVJ72iq5nzhCV0PJ+p54xNNn4upAcoOqjsnW9aoJ3sCIVyFse0aweIg+IbbuKr9/vUV+9YEiIiPlLgLNEaaamCGIeo5esm4Hsdoy7SET9dliCNQp2byH1TrpHM17VsA3JNw53biGSoKSII3ht9h55g/pflo5lByni8tZh2paExNRshMaFjvmhMEBGNK/F/PlIigtk20f+j5AJ+NZDVk3IHf9lya6JuOQC2lk95bEelKD8Yrc+PjXXz+JJEKcaMMfrCQc/MPy8dEjdzRTe0Xh6shbIVuelb4fT/XOOEh0TbAJQgxFuFqMPu1H8NVEMgZ9B8tOwpOKSoeLzA/CkoT7Mq2/3eti51zzfSmPEUYGIO998qwp2j4
 NqkkswWY
 WkSaRZbUc8HD7kk0G9oTnfxMmmH0kkopvGCNFZkD4qZWw3ShRClSlzI8wyoQEQETxiF7lD9X3ZIJKj/9hNIYx0Xg/QucyCtqn+uVWc512uQ2CMkHKE/FkY6bute4t9/UU2bNL+aLKMKfyvAZ1j9eKNmnb/7CEWBHwThMGdXCCex42OTv+8BNnoxm1VBJPblZ01PeJM0+sISHA6Tn/83h9P5B5aj3vQUiH2dO0irpwveh6rCvhXrL6CudmO8fiLavLENyHQ7BxoigyCNyW8iG+Ye7o3wqNKVMu7/t1A5yCE9shW9502FhaG72ZaMM0u93lrPB51/5px8PfCt6Sk+UWt6aQpzQaOXstVL/3QwmuCSbVKw2aIKYkW9xo7aYjrrx+x3gnjIOAklIm51tlhJ8qw+zeqcvviP0oLNMsQRJYcEgIIygYn+yhWNmj0hIJ5bRXodxoHeXn7/oKJPtY0IdtCXCbGNgCqrqj3tebPsjZXeUGTTugv9tkoVK07pURSb/CN0E2iORE8ePbwPqWaeE9mMaBNkdpdBGOXK6R6ldZsnAT8wI+Ocgc7heZzaXQHKtPbZuHwefFdbTkQZaACUM9C6EbkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 18:19:07 -0700
Shakeel Butt <shakeel.butt@linux.dev> wrote:

> Currently struct obj_stock_pcp stores cached slab stats in 'int' which
> is 4 bytes per counter on 64-bit machines. Switch them to int16_t to
> shrink the cached metadata.
> 
> The existing PAGE_SIZE flush in __account_obj_stock() bounds *bytes at
> PAGE_SIZE on 4KiB and 16KiB page archs, well within int16_t. On 64KiB
> pages PAGE_SIZE is well above S16_MAX so that flush never fires, and a
> sufficiently long run of accumulations would overflow the cache. Add
> an explicit S16_MAX guard before each add: when the next add would
> push abs(*bytes) past S16_MAX, fold the cached value into @nr and
> flush directly via mod_objcg_mlstate() before the accumulation.
> 
> Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
> Tested-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
> 
> Changes since v2:
> - Collected tags
> 
>  mm/memcontrol.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e4f00a8159d5..78c02451312b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2022,8 +2022,8 @@ struct obj_stock_pcp {
>  	struct obj_cgroup *cached_objcg;
>  	uint16_t nr_bytes;
>  	int16_t node_id;
> -	int nr_slab_reclaimable_b;
> -	int nr_slab_unreclaimable_b;
> +	int16_t nr_slab_reclaimable_b;
> +	int16_t nr_slab_unreclaimable_b;
>  
>  	struct work_struct work;
>  	unsigned long flags;
> @@ -3158,7 +3158,7 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
>  				struct obj_stock_pcp *stock, int nr,
>  				struct pglist_data *pgdat, enum node_stat_item idx)
>  {
> -	int *bytes;
> +	int16_t *bytes;
>  
>  	/*
>  	 * Though at the moment MAX_NUMNODES <= 1024 in all archs but let's make
> @@ -3195,6 +3195,16 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
>  
>  	bytes = (idx == NR_SLAB_RECLAIMABLE_B) ? &stock->nr_slab_reclaimable_b
>  					       : &stock->nr_slab_unreclaimable_b;
> +	/*
> +	 * To avoid overflow or underflow, flush directly if accumulating @nr
> +	 * would push the cached value past S16_MAX.
> +	 */
> +	if (abs(nr + *bytes) > S16_MAX) {
> +		nr += *bytes;
> +		*bytes = 0;
> +		goto direct;
> +	}
> +

I think you should do the add first:
	nr += *bytes;
	if (abs(nr) < S16_MAX && (!*bytes || abs(nr) < PAGE_SIZE)) {
		*bytes = nr;
	} else {
		*bytes = 0;
		mod_objcg_mlstate(objcg, pgdat, idx, nr);
	}

-- David



>  	/*
>  	 * Even for large object >= PAGE_SIZE, the vmstat data will still be
>  	 * cached locally at least once before pushing it out.


