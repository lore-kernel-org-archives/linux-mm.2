Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F89FCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 13:07:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F95C6B0005; Wed, 20 May 2026 09:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3842D6B008A; Wed, 20 May 2026 09:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24BBD6B008C; Wed, 20 May 2026 09:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1033B6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:07:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A2998C167E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:07:07 +0000 (UTC)
X-FDA: 84787823694.04.311FBA4
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id 59AC140016
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:07:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rk1LzxBt;
	spf=pass (imf04.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779282425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5gunmBLjCjS6Gti7CYJba8OZxUFE4BT2dND5fh8wPSA=;
	b=LP7FYYOVTFTYlcBJfiBT+nc6COmdMMkwbGfa4SypucetP0jFbkTKXkEoR96LzogFrke2DW
	UinLZG8mxX/8uA1XTQvzh6I19jWHcZ2Jr9cvr4cRqR5z5+1XTj7nfHCHRMyzKGLFH/9NQt
	2I8Uu0yzKGgxGX0DMjxp5RingecdbFk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rk1LzxBt;
	spf=pass (imf04.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779282425; a=rsa-sha256;
	cv=none;
	b=H77hZw1D1wGmOvlcDXKUAuaOKCw2nFZQT5bJOtitRIx24YKHlMD+NjT6Ng7FlRAjZnWPgm
	SU8P82ENAoXV1arB0bVFk2hemCcphyTDuf9ZhdeLYB4fWvNiCHJhogf4ZbKCFzYdt3N342
	K3Z9eyNWJkhQCEiyLSRfQej08+eOP+s=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4585a116a4aso4021698f8f.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 06:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779282419; x=1779887219; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5gunmBLjCjS6Gti7CYJba8OZxUFE4BT2dND5fh8wPSA=;
        b=rk1LzxBt+5UR3OTtQG1UCvp3GYicBJ26UV7ZHzUcvOynHeP8lgHW3vIA4xgeH2S2qL
         ZOfgT+BJdj2cOov1Ci9fViQokulH0OmP5rnlIx7luU2H0PwGHx4pyqJZNfqBUXjMNFuk
         XwG2RVZbvU//m515FeXratEaVNlBMkiJwSTTvUZfcsrepa/1dQsJm1+0cRsA507pWEJO
         ooAdfffprc/0UdeCge0dchxkD3vaUMXxdNVuJ1RotbEfGHs8Cu/ZiT0KkjMkoVPmX0tG
         9yHoH1hEkf8MLA1G8/mucrEidMlSGfERKUtAmWxoAGhhYcpCy0gZt2IaM6aqPnS5gu1m
         Gd2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779282419; x=1779887219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5gunmBLjCjS6Gti7CYJba8OZxUFE4BT2dND5fh8wPSA=;
        b=isa2l8m6gxPHVGIwhda5R3mXgub3Ys29sw6Z5mNWhYKRuGSxYief1/wJddeLt/q//g
         c8X5pv2WGda0ZKFL+FN8yDGxxGGkR/TbW5OzWX4QJpsZlbGFrzWOy1hgE7MFWk1ViifB
         92grzB3k1YsqIWPfWaz6rSnq2Ztn/lXpwVxCEohF56kJmNEtGYZqSw/NxBjmjnmCkemR
         C+FOjIuH4yieOwReImp41iEsCwtdbRlP9tDzgtmoPBpWBsV+RwybP/Ql9i96SmP0mpJS
         qdpoT66GMyS4t6kl3bCFRoxaGltY2ovXsaWcfTG4BbiMjxAcoUrXVg4jrooLqOSBRZAq
         9gDg==
X-Forwarded-Encrypted: i=1; AFNElJ+KjKNb+9H0W+t8zIu6EuSOBSPBMvzCmWTniOzR2eqii9uSTFzHQCcI4iwI0IGFW7ZJ7lBSPu4x0g==@kvack.org
X-Gm-Message-State: AOJu0YxQORdRgEijHaST+32YUtywVtS826sQeKWyUYqzpZGLrzWpot7i
	AlJ0Z7l/odayqgc3lcTuWTCW/j/YuQWVwXzpuA6ho/dA9B/TxiRhwymO
X-Gm-Gg: Acq92OHL3jq3INgERhqE2KrPmpeLZrZSGc1OYwBn51XA4e1DNwl2sdm1c+5VbPUVa3h
	V4cTv2W6XLGdkDrY+ozKapE+KSX/kmegW0gJae8180yN/dYOBqrHVLKjyhLlXhorhT0QFjpn0vN
	0zSbCFerpkPXbaPk0k4//0cnQOVp0eGxK0G3quxgYXef2We/L2SdqajqMfix5wzuULA5/rzstPn
	rvfJPNejdvec+HNTW5qVqe10ahxIGnjwi6/MI7VxbqusfZtWpWk2+AN4a2M0Gi7J9V0l+KRErRY
	M1gx2MsYYzlFMEB3RzDkSTyYKTSWVir/9rVdAZB1i2K4rwoVcFbRt61+itlts9SkJyJUodbK03t
	rjWL27mSAGc9DT91B4gXGD5+v3PRHE2iq6bqGW7eFGoI42g6qtq8muFWIfznR2LYyhq+zdXet53
	SXBYxXhHzmkOyBMRk8wEDbNxXDZ0ypGkpcckbWlcofZmdFCFbQDRkFRJJlku1/PahRqqileS0r9
	lo=
X-Received: by 2002:a05:6000:2207:b0:45e:73eb:2a75 with SMTP id ffacd0b85a97d-45e73eb2ab3mr27313880f8f.16.1779282418850;
        Wed, 20 May 2026 06:06:58 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9e768bcesm56306140f8f.4.2026.05.20.06.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 06:06:58 -0700 (PDT)
Date: Wed, 20 May 2026 14:06:57 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, Li Nan
 <linan122@huawei.com>, Xiao Ni <xiao@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-raid@vger.kernel.org
Subject: Re: [PATCH 2/2] lib/raid6: use kmalloc() in raid6_select_algo()
Message-ID: <20260520140657.2b5b5f3b@pumpkin>
In-Reply-To: <20260520-lib-v1-2-cb3045bef2d8@kernel.org>
References: <20260520-lib-v1-0-cb3045bef2d8@kernel.org>
	<20260520-lib-v1-2-cb3045bef2d8@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7su196oubyqt9dms1yd3wuwmjn4wokuo
X-Rspamd-Queue-Id: 59AC140016
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779282425-933436
X-HE-Meta: U2FsdGVkX1/nybVC0ezux8uulTr2lX4+p5J7ZrHlKE1Rdv/v0UVPTXao+TG+VEDYcyLjVEEaR4mjU8FIJK5Hxo1oqcbNspUxK/k+MkfwKSksEwHHsPzxmEXI6Nq8BeVy8dePBflgjiNrEUdm3/Cyj1IZYihkVLvFA4HNNd7KfinX0ffvR6MAoQvGFbHyzDOMZIg6CCPwVrKY5l5fd5a5QTzaO71KCJfq1q+LkZcYPYlRKtCAvwzGmNUdZvS+pGK1JnetIIdGPrz5zGpzuUazVyafia/bFkTUkJMzxX2mmaTolEH4VTvsKn9cMNEil4HDQqW5UUiE7XybyYnCMiFYNgbjbw4tXRyGgIOCMCtRk6UznFoFrn/zrNsyoveijXZAgJUH7o38aYY+KBmYHQjZq8vIJ2Tj/K+0ZH53qQTTafb8T3HuUvbol/UkbinfQOjCW6CrI7/RnIPCLoxKTZNMXUw5bxhcPEUZYje7rIK4obPA2vikFrTf+Ovvu8jy4uS8Y8kgjn4pcxkffzgkfU3kfBBoiVuQikDxxrGFkI0Hogg1B5ugn6M2l2iFLTj9uf/UgUrUNgpwGlgjwOXd8gCX68hZ1n+njjK7a/0KKJ9BziQHW3J1C2Eti01B0X7V95IGrse24EQ1wk8w4VbCocgX6X9qTuDYb6vIn15YAgH4LSep7zIUAExn3Gv/MCTeYHh2072Qs6fnv2Rlq8shvctJZglGODYb1daA3Vw37k46DsQIxhI4Im6v3QwbavRTb2Ov7Z8CS+QSJf4ZYNeSCC+q8yl7oZORpnSRSad0AsppNf1is4io/upJA5hPcSTWwKAgQJS7IV0BB84wDWLYlIvSIxqJtqjIL15KYBxIV6gVyv3LWub89YSNGauVSTTRLHLkp9xy1gZ/cgrrvPDkQgaAXdsJIy6dqVlhSKBUQDS8Pn8d4qcn3F2CKt+2MZfxDDTZni9Khrr6QagE0Qy3PoE
 DQDWLuhf
 1opXGhLZ0T/7V5JdzlfUiSvvZydJL35bx/hXm1NkGPm09rPE5TUBXb8CXE1NfXrlAecF+Jasq6G/h17nja7b9H4GBiNpUSsXOjvYzjbKVPt+F67vavw6RuvOHmnyUWv7yaOJfMuxlfb+ncnNHb9RR7viZW40v582mtfZ8DdoBhboY2QQPW1cHAHBcX/oSv5epgEK2zw9ML0vE3EbtytI7ql39YkLgSx3Q29V0ODqQxFgtZW6LmIu0O57HwprWetA94phDSMEEs3NFge26Xx6PcoGDq8yswUm2W0DMzDSW7ctkuj3Ajhlnoi4rKjKjBsOIReam5AtfeTwc/deZCPkxR+qD2u9Sh+7yXp4QTwjBhSgHCZnT4x2Apm6TzOB3wj7ylLRNWnn5/ABGGlXmRnmvLmlHZN2Tw7DFvdH4bLQdDIyMFC0u6+UBMxINWUvTsGakhQIsp5moBMmFQ4B9WeU4dsdzFrcwcGv9m7u6E46bgjeCnj6B4KFPqU3LMLHpennpg4EIGedeNHaadZM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 11:17:52 +0300
"Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:

> raid6_select_algo() allocates an order 3 (8 pages) buffer that is used
> as a scratch area for selection of the best algorithm.

Should this code really be using a 4k buffer rather than a PAGE_SIZE one?

-- David

> 
> For such large allocations kmalloc() would fall back to alloc_pages() but
> still kmalloc() is a better API as it does not require unnecessary
> castings and may provide more debugging possibilities.
> 
> Replace __get_free_pages() call with kmalloc().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  lib/raid6/algos.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> index 799e0e5eac26..89e627c62e30 100644
> --- a/lib/raid6/algos.c
> +++ b/lib/raid6/algos.c
> @@ -12,6 +12,7 @@
>   */
>  
>  #include <linux/raid/pq.h>
> +#include <linux/slab.h>
>  #ifndef __KERNEL__
>  #include <sys/mman.h>
>  #include <stdio.h>
> @@ -129,7 +130,6 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
>  #endif
>  
>  #define RAID6_TEST_DISKS	8
> -#define RAID6_TEST_DISKS_ORDER	3
>  
>  static inline const struct raid6_recov_calls *raid6_choose_recov(void)
>  {
> @@ -250,7 +250,7 @@ int __init raid6_select_algo(void)
>  	int i, cycle;
>  
>  	/* prepare the buffer and fill it circularly with gfmul table */
> -	disk_ptr = (char *)__get_free_pages(GFP_KERNEL, RAID6_TEST_DISKS_ORDER);
> +	disk_ptr = kmalloc(PAGE_SIZE * RAID6_TEST_DISKS, GFP_KERNEL);
>  	if (!disk_ptr) {
>  		pr_err("raid6: Yikes!  No memory available.\n");
>  		return -ENOMEM;
> @@ -275,7 +275,7 @@ int __init raid6_select_algo(void)
>  	/* select raid recover functions */
>  	rec_best = raid6_choose_recov();
>  
> -	free_pages((unsigned long)disk_ptr, RAID6_TEST_DISKS_ORDER);
> +	kfree(disk_ptr);
>  
>  	return gen_best && rec_best ? 0 : -EINVAL;
>  }
> 


