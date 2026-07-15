Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77AB0C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 15:58:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 782036B008C; Wed, 15 Jul 2026 11:58:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 759396B0095; Wed, 15 Jul 2026 11:58:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66E936B009B; Wed, 15 Jul 2026 11:58:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 336986B008C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:58:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B898EA0201
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:58:10 +0000 (UTC)
X-FDA: 84991467540.23.2C25659
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id DBAE840005
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:58:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Zr2pQ+jQ;
	spf=pass (imf12.hostedemail.com: domain of linjh22s@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=linjh22s@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784131088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5jqq9tpaX/pC62ALfZOmXiDQ0y4ecS0xGD3vn+9oows=;
	b=b9PGSRCNRT4/d5xiaMmM+bqxdBDFNZ16NSB8PkUpFwPeYTNvwBVag8WNzuWr9do/x4dVPt
	bx/qMKmVzlq0ZEWnxn/Dqqao7B1ydrPy/tDw3XHaSs0Z8df0EwaFBmTsSDO1yblIo8l0mJ
	P6+ORLiWvmwCwkTyF0WHHhpYUMxhtfE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Zr2pQ+jQ;
	spf=pass (imf12.hostedemail.com: domain of linjh22s@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=linjh22s@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784131088;
	b=AEtufHFUnNk+6YEuFCqD68Tgd9V90UXU1k3yuAuo8cRwfVjQLC1nQKlTCsX/VB1K4Beg8k
	J2nB2D63cmDS4stQ1X5yfcxhNqVeuggsYPVoRfk8migT+4rYHbYsFq/BfuovfmhTuoyKyP
	OpEN8oFxuzKOIoqgZ9K99716Qtimsms=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cedda2ce6fso23900255ad.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 08:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784131087; x=1784735887; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:references:cc:to
         :subject:from:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5jqq9tpaX/pC62ALfZOmXiDQ0y4ecS0xGD3vn+9oows=;
        b=Zr2pQ+jQ439OjlVH5A0w+hzBGSNlf4x8h/lVHCqn2220RhytgzhWFmHuXXNuFwf0HB
         YP57M82oi2u34G8uYvP76IZh6IjBPwnLNrZX6JY9aBSPpelipnbK/oWOz6zCuIDXH2Xa
         OJ1jB2Nk1Z6qioQCFNARDdEpT4EhV1FFEwKIMHUv5qSmBHHcVf5zT/3Xgh/WjjHXsnV4
         Uq+fxRxCgGGPL5zcDPuDuwQfIxwFt3JyLxSXP0Df8k4Qh/CE1fzTsyPLHUNCLW/VlIem
         XgV0datXpjYu28m3aE2Z/9u/28hBcQ/sReLKyjYqUQ7DmX/ZNitFxADrRVEOrL08/SdD
         TFNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784131087; x=1784735887;
        h=content-transfer-encoding:content-type:in-reply-to:references:cc:to
         :subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5jqq9tpaX/pC62ALfZOmXiDQ0y4ecS0xGD3vn+9oows=;
        b=ZqJ6ULvGTXn/eFY7NxL0DTkTe5eskoYQVBGWlvs9wTf78hgiTvGsotEZtW1J0qGf0h
         ZiCFaCk/DpkCcoTph2Bd46eS1iqLRF8ZzEDWj0tcjJtyu1HigYJ2Jlsnook/hHbo1l17
         98Kt4GwDZGZA7XmNypY3bEGY9eIcqFk4/mlWJAtWJ13QyjMqDqo4og/22lQ5CORXDXdv
         NbtaaUPufSVAL44H92+DMvSDR9Hy5NRyqi/oR9tmT05L5xQ0Fjl3oKIV5Y4+Ip15QCRQ
         xOffLE3EhiTNN0Z5c9fJorlSGAmjQjJauN+xMFg6hPcIwPVPtMTzwp37cVfD54DCBhCp
         3jew==
X-Forwarded-Encrypted: i=1; AHgh+RoN5qRWNdwe7LnALbzLp7xVltsa+lDZxO1umVCnzNwTNADDINRTeswAN3Eaw8kCdxm4Zwwjb9V98w==@kvack.org
X-Gm-Message-State: AOJu0Yzo/kJLqVaBuB9Hn3p20QZz4awkLAeS+UpyjoqKu9EiXwSGrc/V
	6N5YIwn3TA2MUWy/VmwwVxPd1lU/cDCtzphSF/cKwQz5c7Q8skF3p5/C
X-Gm-Gg: AfdE7clyCxIdOGE5meklXpE3Ukp1ISPHp6H15onGxdim36jq9Fedw1+CvL+HxNcLg2p
	zlfXFx/HmFbFOD7obvt5MLmDhkfLNeKWh7Mt/Dkkr4rrVM8C/qwk+D7rXqkN2HklIU1DyR9tSfr
	5Xv7KnT0shArkyUsl/FwJZCBVDJfyiObsIKnFgUdkuJ3VONh1FIFJK0lJ/YLo5zkIRneYcWEupL
	07FVuIOfCREQjYFbFsMWMBFBvAGFiD8qrxlV7E8s+u182YO/iDArsIxcHn0AW55HpzNg8dxgQzV
	LUZDsZveFegFurN6L4wORQiA9qag6KyDW0wRUTUJH0LbSMEAe1uyjuPxVvo/nJDJmAQ0TdMAbWh
	P2RdNkOQ7UjpCQOv2DN78NH3SbZq6BlhMVv4lmbL6KC7vPWScM5Ny+teg2v+7HSRHQxBKZA5OIp
	H2RCetT1d+Zif/JPIDjJy8cVw=
X-Received: by 2002:a17:903:38c4:b0:2c9:97a7:71b1 with SMTP id d9443c01a7336-2cef14bcb92mr73814315ad.44.1784131087288;
        Wed, 15 Jul 2026 08:58:07 -0700 (PDT)
Received: from [127.0.0.1] ([178.208.188.113])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf100e3920sm5130685ad.5.2026.07.15.08.58.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2026 08:58:06 -0700 (PDT)
Message-ID: <77d6da3d-10af-49a1-a356-72aa8b462e85@gmail.com>
Date: Wed, 15 Jul 2026 23:57:58 +0800
MIME-Version: 1.0
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
From: Jihan LIN <linjh22s@gmail.com>
Subject: Re: [PATCH RFC 09/13] mm/swap: add priority queue for swap device
 allocation
To: kasong@tencent.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Kemeng Shi <shikemeng@huaweicloud.com>
References: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
 <20260714-swap-pcp-priq-v1-9-de9b164ed419@tencent.com>
In-Reply-To: <20260714-swap-pcp-priq-v1-9-de9b164ed419@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DBAE840005
X-Stat-Signature: 9p9e57uw63a4eua7h7o8zpnjbek1pt5a
X-HE-Tag: 1784131088-960761
X-HE-Meta: U2FsdGVkX18SePww1WuPGVngsjiykvhhNPaShFUxds043p17dVgF1kzYnnCYwPCNHRI5nO/mxtZcnvwC02Jxxl8IC2oBtjIRQPmiI224JNlchipZuLTr2B371igpYmb6KVDqFGSoLIrby7EI1eshd/sJUDe5EbyKcdSiYJx8g7uAGxpqAssGihdCKjs3vNWE2kXUin/hMCmOUlp3TFHI2pUJfcHwFZM6MLX1eH0oD9FWj0J+MKbNxNc6RGA5pHN76dD3EWO/Dm6fHIxwJKlRERkF9dK/3c30H+W0e6zahI3Uf/5w3abWG6mP0Ih8ZoBrvUJa2iM+/ZpDU/t+DYkXKeGQh5EatWV1fEbtIegNImOCfsojF5SIm8L+s3VEgp6O7Zup0tkq7zTNuMRjpt2xruApDcfxaew3KQJcs68wLnaxwq7j5qbMRwvs796tHy7rzwsnjEA2dZJsnzDOkGazFekfWotcEK1OfisusV1ThMfc56PfUjSSQTsJuQBEQFcklgnmZ8E2BHChlBiRhgQCF7xT94XO8qCO1ehlq5AJrwF0IEyEtG3qtj7BVerJmhc1w74xXMpSY3HTT2JY+qVceOrcKCP2gWw26rOJTZ1kO8Di7qUMjAH0ivmEV4UH9EZj55L4wMjoc1tahavbrQ7toUQ9mnO0iXp5nS9j4+lQdKH0qYDQfEbGjD0nuJvBUEJSkb0NRgWHgD49LXICv7HkrN3ebop7V8H9j+MuEAp6AUr8DIPfaLkErCfKnVlzNoXTQ2ReIHl9pc48/pIXxVLRAY3IVYeR0hUKm+30pJQJn26Y7vA2Xq2sXnKLCa+j/shgwbPcxW6qbztkmG0gcz5N5wDRKRVBUSOjkkrFIvS3urqZcD22scqzbaWovRKc3QGQpThb9LqaNg6XuhTFb2V1TxCPrgtV0nGuwCihlgvzVHfHtkAmIGrnliqRVRJl+XhDIgKehFL0LFawnnv52N9
 BGi3b8QU
 ZjUnLKWZgwWGG8xTHjsJF1+2fL3dFpISzDMDOMWWhOtzNAWLH84HuDk2h3YwvdqmZ3GE49ePlwW7H5gyesYSsO1hYYsTInOMVLIkUrkWXpdfrZBjpBAEht3pK3VLvDOVGjK7VwAdmqLOpLsliHyX7tnGpzlL/ZGL5NpFxOMsXG0/HWqWSMFPNVTmaRz8ghmDc+/rzLFf3pH5vH7mGSF57QBitWOTjVVCzNYVxaysmtahnfqpVGCtgCeKTCRAxUGEDmJtbNDQpPo+l+mi8h8juV4wFBIMtV7OpB4+9x6oig5p3CiUpjOCPaSiliGNhFiDFL06lDu0c7frmI+lC34e9ZDmSwtQzDLLW4fgFDeFn8BTFB+b1BkXuUYsQae/FKzGTBQhB/y/fjqZMi5oTcNdwpNWU26Q1Dv7IlclCDj5ON9kkEIsrTm9T4KbiuZh91Zebywa++OT2WFUOqULoJtuJO//DV8Z6fu83+cfEuB5dPDdcWew=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

Thanks for this series! I noticed a few issues in this patch:

[...]

>+static void swap_queue_install_readers(struct swap_queue_reader __percpu *readers)
>+{
>+	int ring_idx, cpu;
>+	struct swap_prio_ring *ring;
>+
>+	free_percpu(swap_queue_readers);
>+	swap_queue_readers = readers;
>+	if (!readers)
>+		return;
>+
>+	/* Distribute each CPU's swap IO fairly across devices. */
>+	for_each_possible_cpu(cpu) {
>+		local_lock_init(&per_cpu_ptr(readers, cpu)->lock);
>+
>+		for (ring_idx = 0; ring_idx < swap_queue_len; ring_idx++) {
>+			ring = swap_queue[ring_idx];
>+			per_cpu_ptr(readers, cpu)->ri[ring_idx].offset =
>+				    cpu % ring->size;
>+		}
>+	}
>+}
>+static struct swap_info_struct *swap_queue_get_device(long nr_alloc, int nr_iter)
>+{
>+	bool rotate = false;
>+	struct swap_info_struct *si;
>+	struct swap_ring_iterator *ri;
>+	struct swap_prio_ring *ring;
>+	unsigned int queue_idx;
>+
>+	if (!swap_queue_len)
>+		return ERR_PTR(-ENOENT);
>+
>+	queue_idx = 0;
>+	while (nr_iter >= swap_queue[queue_idx]->size) {
>+		nr_iter -= swap_queue[queue_idx]->size;
>+		if (++queue_idx >= swap_queue_len)
>+			return ERR_PTR(-ENOENT);
>+	}
>+
>+	ring = swap_queue[queue_idx];
>+	local_lock(&swap_queue_readers->lock);
>+	ri = this_cpu_ptr(&swap_queue_readers->ri[queue_idx]);
>+	/* Rotate while iterating the ring, just not on the first try */
>+	if (nr_iter)
>+		rotate = true;
>+	else if (ri->rr_counter < nr_alloc)
>+		rotate = true;
>+	else if (ri->offset >= ring->size)
>+		rotate = true;
>+	if (rotate) {
>+		ri->offset++;
>+		ri->offset %= ring->size;
>+		ri->rr_counter = SWAP_ROUND_ROBIN_QUOTA;
>+	}
>+	ri->rr_counter -= nr_alloc;

ri->rr_counter is left at 0 so the first allocation on each CPU hits
ri->rr_counter < nr_alloc and rotates, shifting offset away from
intended cpu % ring->size start. Initializing rr_counter to
SWAP_ROUND_ROBIN_QUOTA would avoid this, or is this initial rotation
perhaps intentional?

[...]

> @@ -1245,12 +1580,12 @@ static void add_to_avail_list(struct swap_info_struct *si)
> 	unsigned long pages;
> 
> 	spin_lock(&swap_avail_lock);
>+	spin_lock(&swap_queue_update_lock);
> 
> 	/*
>-	 * Add the device to the avail list if SWP_WRITEOK is set and
>-	 * SWAP_USAGE_OFFLIST_BIT is still set. Swapoff clears
>-	 * SWP_WRITEOK first, so the device won't be re-added after
>-	 * swapoff starts unless swap_device_enable resurrects it.
>+	 * Mark the device as avail if SWP_WRITEOK is set. Swapoff clears
>+	 * SWP_WRITEOK first, so check that first so the device won't be
>+	 * re-added after swapoff started.
> 	 */
> 	if (!(si->flags & SWP_WRITEOK))
> 		goto skip;
>@@ -1261,9 +1596,10 @@ static void add_to_avail_list(struct swap_info_struct *si)
> 	val = atomic_long_fetch_and_relaxed(~SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
> 
> 	/*
>-	 * When device is full and device is on the plist, only one updater will
>-	 * see (inuse_pages == si->pages) and will call del_from_avail_list. If
>-	 * that updater happen to be here, just skip adding.
>+	 * When device is full and marked as available, one reader will see
>+	 * (inuse_pages == si->pages) and should mark it as unavailable and
>+	 * set SWAP_USAGE_OFFLIST_BIT. If that updater happens to be here, just
>+	 * skip the rest.
> 	 */
> 	pages = si->pages;
> 	if (val == pages) {
>@@ -1273,10 +1609,10 @@ static void add_to_avail_list(struct swap_info_struct *si)
> 			goto skip;
> 	}
> 
>+	swap_queue_unmask(si);
> 	plist_add(&si->avail_list, &swap_avail_head);
>-
> skip:
>-	spin_unlock(&swap_avail_lock);
>+	spin_unlock(&swap_queue_update_lock);
> }
swap_avail_lock is acquired but never released when add_to_avail_list()
returns.

[...]

>@@ -3700,6 +4035,12 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>
> 	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
> 	percpu_ref_resurrect(&si->users);
>+	percpu_down_write(&swapon_rwsem);
>+	error = swap_queue_add(si);
>+	percpu_up_write(&swapon_rwsem);
>+	if (error)
>+		goto free_swap_zswap;
>+
>	swap_device_enable(si);
The swapfile is inserted into the ring unmasked before SWP_WRITEOK was set in
swap_device_enable(). Allocators can pick it and get -EBUSY from
get_swap_device_info(). How about adding masked and then letting
swap_device_enable() unmask the new swapfile?

---
Thanks!
Jihan LIN

