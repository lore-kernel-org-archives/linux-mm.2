Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 470F2C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 12:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63EEA6B00D5; Mon, 21 Sep 2026 08:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EFF86B00D9; Mon, 21 Sep 2026 08:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 506CD6B00DB; Mon, 21 Sep 2026 08:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 273086B00D5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:04:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC347160174
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:04:18 +0000 (UTC)
X-FDA: 85237636596.27.761E86D
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0DD404000E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:04:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jypbwlat;
	spf=pass (imf27.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789992257;
	b=BkJbi8EhfKoz7SlVtgotkXobEkzqfbf50gSHmadaLEZ3CLMwsWdfFC1aq6D3exTiI8tNAP
	Fagn/qZxXYEUCc1BjDtWLwgw4+ayWpIk9sQ4+X6wicjjJQ0mVGRFMkEKrA+W6lTD1yZ1Vd
	t1tiIJ9qyWfcx4lnwl3MG2gWk+mK4NA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jypbwlat;
	spf=pass (imf27.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789992257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BJyN6hZEtJ7I+g39wMWDf70pybar89NGAUqAa4CiJnQ=;
	b=QeMZY/n96g1UnHu7aNsqWppTJOD1y6VU+ZoNFWW1dWn4kFpmxWvsvtvwqmqeVYhevY4reY
	Nzb3sI4zeTl0MpGudyKWOpqNxGvpkeEdaHLLSbXJSWEPW8/yY/7lURrGHzZisz2nwVM4aG
	wmxss99v9ePHG+6I3s+fF5owszo8OW0=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49ccead2aecso13713655e9.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789992255; x=1790597055; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BJyN6hZEtJ7I+g39wMWDf70pybar89NGAUqAa4CiJnQ=;
        b=jypbwlat1tuK+UISWUkuUr1z9wGkwtveC4zkVWkF4pIzGuoNeyxsgUR8YE/B8NpiUt
         lbqpWYIKpykl6oyyftHx0MKvXs6cciG0SJ23jhZkIBCbmUbhar3Oq7v47tEXkmHVPpwb
         2iU82/zLikXOauMEB3sm0cnNVpVri0XNJBlFBwrmw1WlJRuDCAwacjjvxzz8mFaejZaS
         ZcQL1Gu5w/WC2bpCsg5bsGp3zzQQDepeBQZMOf2X5T2Eh7XxPmfHpjWIczzl21xD5Yo7
         ZK5ajdCzW7uyIP2AfcvIti0+tAxHdvAy525+K36tLiiDu4TF3qkdh3h2QPYoZynbAZGi
         PM2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789992255; x=1790597055;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BJyN6hZEtJ7I+g39wMWDf70pybar89NGAUqAa4CiJnQ=;
        b=h30RF0iPPavXskgbp+NiRXD9tNNAYiYuzMGD8CGFuN5Nm5X3kbAA8jjm8hDvA3L/Li
         rnNl3M6WOkMHjJFxJV2GSDsJNwGcRsPnVpVB+wTG2l74ZJlafXxse//1NhpgfGhvtpTN
         PjKez/5TqSvaGjxaoFFl+Dx1JyPARk6pCBsnCSp2Ph4So6/s9N5bTodwyZsdDdCgR+To
         cMVQ0djiqpMh4vQdj3894DDpqE9PLO1R2bGzHm6kQbzGfXTUKx4H/7LyE3jNheM0jggw
         7KL4U4I+3zj6uVhfyMUTAX31EwCAMKLbFx13tE4Jzk2/b2NR5j77nFICdsQU5bJgg32U
         LUuw==
X-Forwarded-Encrypted: i=1; AKwUvByxCEqYNRQx4sZoaCxm4+kh5KaYRFQyav5DYbF8VZgy0QrrvZ5UiBNsDUd2QXN16FnVlyhbYjNdHQ==@kvack.org
X-Gm-Message-State: AFuF++kwPSBS8eIto/WDh0FFqg6PSESYCG7a4HLQXvQzp2w8mfwYl87B
	bfPNpdK657CKejpeCpwJkU5ajr+OfpchyPgqobfZKeJIJuMnx/tc0Xf+
X-Gm-Gg: AYBFou1YgvimfNTEqxlPkC0AjWxQ8Uq426OAMfslJcIL1yBMBSzt01lAfEX1soWrKJo
	HAB4AlbJFrxTZlk6ZCJAxInpNuQgRnM8Ce7/XbFvHi76uqLE1nntXcHul9HbMgOehDSynA1n3nL
	AFq7Crvh4b6rl4cI9eFs8ZLddg2ouNgMUY9wEvm/V11yKXOszWq01VHbdMp3typnY2C4BKwEJeM
	5A9lx6ns95NifnPlo2V/zkzGHnskhkCluRYdFzSux4aMIISGHgwKrMSDS+cQYgpM0LMMOyc5P9w
	nU4NvFVmzZL6xiU09ptzyNDai2aNI/eItiTbuL4c2SiLr6CFis/MgmW4yPZ4SEecCCibgj0UT9b
	eR9Pl3swIG97GF50rg0uDnTusrAaMJUtF7i1EGp2VOqno2YuJvehiSn0Fukk9sFGe4GLENUaE4W
	A+vSQrtSK4t83RX3NeodxVA3fGw+2+PA3kRI0Ka3O2m5rW2Bi16jhiWabyUaeGFsm1zw3YlyS+J
	K3f/vXXEZ7l2Roc1DQgA76Kw3z+Av1wxb3vkhHlbUvWoVQbwtD459Ogc+VdJSP/2A==
X-Received: by 2002:a05:600c:3584:b0:49d:286:83d5 with SMTP id 5b1f17b1804b1-49fc5722755mr188101715e9.13.1789992255201;
        Mon, 21 Sep 2026 05:04:15 -0700 (PDT)
Received: from C422HJQPQG-Fractile.local ([130.43.154.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-487244229e0sm21110408f8f.4.2026.09.21.05.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 05:04:14 -0700 (PDT)
Date: Mon, 21 Sep 2026 13:04:12 +0100
From: "Vishal Moola (Fractile)" <vishal.moola@gmail.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, willy@infradead.org, david@kernel.org,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	muchun.song@linux.dev, riel@surriel.com, shakeel.butt@linux.dev,
	kernel-team@meta.com
Subject: Re: [PATCH] mm: filemap: move lruvec accounting outside the xarray
 lock
Message-ID: <arEdPO5O-kz9nzX4@C422HJQPQG-Fractile.local>
References: <20260916125122.2696271-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916125122.2696271-1-usama.arif@linux.dev>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0DD404000E
X-Rspam-User: 
X-Stat-Signature: mmg9bjfiuyp1dfc1u7enijzj8e5rzahg
X-HE-Tag: 1789992256-651601
X-HE-Meta: U2FsdGVkX19+fk+cJRW48rh9FSNuU69GdYOd1GXmMU1scfGMM4HTRmUMO4PbHexx+urs094DYrHY2nQ7p9YxqKzu8fmVAqlxml1ZgBe9K3b1gblaTPbgELOLAQsigeYyUNiawJJjbXk6xuSCy+6t7BMR/HTIdVob+8zN8I09IQRTcTd74n2ftbOkVZduEn7qTGvH2eF7pGQfEorut18cYcRCO92Sq8pwEUKK8L/aqjnR0IBHrCe+uvc5H+GQUC4yCQfpbE8ubPM2GPetSlvUBsBF1PwHky0qFJaTo8kdeEJxOCvjnfXq3612IK8NozfpOyrG46srJrRG9fIQ5J7g3mEKP5HPI9FdAHWoBeIrH56qHzPqu/y2wedhilksVV9DBSKDk+/AZO+7zu1QPWakdFZVQLGqzzdlCLub7/OHI/laFId9kf3Jbm2onkM5pnTNW/Gv5gtV+NPHaiAIt2f1F5PuYVfsOgHfcleGiczPZeL3XfWoDTu/edEnpoiVK8PGQkkI0Ef2i/Jy7k34jYNvFfTNCYzrot0Q5ETyYgcKIK4Z9LaVVNump/aOXL+3Imy3QdSnPdwaOTPX+W9cZbKgemDuweeNJF7GWS3g8TqgHQjLGW7MAFlVrid8LyBOTOp0GF6s/wtrR8ZDcDB9Q7WRYIehULdcINUV/ALEzfW9PNDfbPSHKweghO+j9IbGYvtkagaVb7unlM3g63EE+LcI3kmt4L6QZp5re32l6go8Zcr8ZCWXfs7P4P5k/rj/MBN6ifFt2FKnRa9h0z08qh6M2EkrsVhxyz1lT0m2UPFdlL7tVLn1sTDPt4he80IHWzR1gZ7kxphq0V2nzD2ySoWndd4nX2W4Bqqrjim2qoq3rJ2bZbK7hHdQp05OLmuUCYmcEXHlsl36HIBVSfd0dZz6Cqpw4iEJ+LHnvuAd4ZMHVzPnOpVPvfnKEAOexilIEGNsfm8M6eDTvKAcOD8Zleq
 oqnmJnIU
 0VKoOXIpttmJIFtt7WBvlSDN3ozd4lO5VR65wScoqy72kGf2mF7saew4fmjQRjeRgzOh1DUQHUA5/BoxskNSAgNv87sDD4Ymh42HIGjURmTRFWh7mrD/65VmY8h6aGApJRjttRIZ/R13Gtb5OvKmsI4T8WYpIIrXpApbj9bQ8mEGVjFYserTE1YDJeCliy/tCBYRhW5+IeyOA4m26uWenYJI9sVe2jC8M4eQlfhymgaJk+DJ6SjxLgJdM8n0jDLnwiS4H4lTIe07IbRDv6AZJaC2yxmCmHuaTS05QayFjhxCwQwOc0ogt0fHTRaPlAb5GhFO9ctmMYS/iTv5PoV/u986x1kH5iWAQ/fQAvsdI1So2CtWsbBGpDI3Y0Q97XG+ajjavMDJwzYyGVZslEllYPCs+V/wtAihGqhhphdEd/5NuFjWspNI8e9vQkTwz4Nfe9MaQf0XX3S+NxNafBaKazYgByQRf2NwKJIR1fJSCY8pX+pPG+RYojMKG2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 05:51:22AM -0700, Usama Arif wrote:
> __filemap_add_folio() inserts a folio and updates mapping->nrpages
> while holding mapping->i_pages.xa_lock with interrupts disabled. The
> XArray insertion and nrpages update require the lock, but the lruvec
> statistic updates do not. With CONFIG_MEMCG, those calls also update
> per-CPU memcg and lruvec counters and notify cgroup rstat, extending the
> critical section.
> 
> Move the lruvec accounting after a successful XArray insertion and
> after xas_unlock_irq(). The page-cache references pin the folio, while
> the folio lock keeps folio->mapping stable and prevents removal until
> accounting is complete. This moves one lruvec update for ordinary folios
> and a second for PMD-mappable folios out of the serialized section.
> 
> In a 30-second system-wide perf lock contention -ab capture on a
> production host, the hottest caller-stack record attributed to
> __filemap_add_folio() had 20,867 contentions and 557.930 ms total wait.
> That was 14% of the 3.998 seconds of aggregate lock wait in the
> capture. Moving lruvec accuting outside of critical section should
> help optimize it.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>

