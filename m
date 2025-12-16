Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1035D5C0C0
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 02:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0D6D6B0005; Mon, 15 Dec 2025 21:23:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBB826B0089; Mon, 15 Dec 2025 21:23:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C90596B008A; Mon, 15 Dec 2025 21:23:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B59436B0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:23:13 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 69D861603EB
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:23:13 +0000 (UTC)
X-FDA: 84223737066.05.A579F64
Received: from mail-ot1-f65.google.com (mail-ot1-f65.google.com [209.85.210.65])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3A88D1C000E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:23:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=cbX6fwgB;
	spf=pass (imf21.hostedemail.com: domain of axboe@kernel.dk designates 209.85.210.65 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765851791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=97NP7q40hxg4C4aKfTESLyYY7arcjR+J9fUfN3qZbks=;
	b=is96sfFGvPvUujn4o95dEQgx6pUIlSi3SNLedVVF3Tk0pHD0w8ICbIYl+UGtyHqDg/1ZUf
	U69YnbBr57X56xBCTQVIbXfUaYQz+BKxNPXZX59CvP33Hku4+NY3DgvxBgWWAxAjQlS7pw
	KPYY7gX/VnJsad4XUAIErfpSvbHkhew=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765851791; a=rsa-sha256;
	cv=none;
	b=PItFoyBBIB+h/GCak04zOTO6gqMS72TDDuin9HJi7IbqjkIJ6lmWi+f407gEbBf5Nek9Ru
	YVLBC2G8ZzvM3wOa00DLqphusJ0aMhztdFpsUwU91wYQCztPg8dB6q36TO8+392m1LxA4N
	yfQ1XwT7grnLEdK0WLWda/nkgg63ft4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=cbX6fwgB;
	spf=pass (imf21.hostedemail.com: domain of axboe@kernel.dk designates 209.85.210.65 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
Received: by mail-ot1-f65.google.com with SMTP id 46e09a7af769-7c75178c05fso1544373a34.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 18:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765851790; x=1766456590; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=97NP7q40hxg4C4aKfTESLyYY7arcjR+J9fUfN3qZbks=;
        b=cbX6fwgBzfrDWmK7C0dcvqYM7o8J89hs2D5VDS2q7TluQ7RXonb3uRRrDKgYf4xVRO
         2GgtnBRjA6XQ3FgDRdBqcyMHe0SQgYvIwxmcnAIShY5eed+9KCMZhJ2Lss5DA1SeA0u4
         98pVVv9agcbl07npmbU8lAveSlERy2wPw1vmcTNe0lbaLo2+FhhRLfW9a72P5K8H3Ju0
         JoWlr0qBwSj11uF1SY+UHL7ky/HAex0aB2htcikOPB+9SltJSbs4LWMaWOozmh4zfPEP
         TFSA6dY9yTiMMFwzFeqvPkg4TDwTTghLX2igv39FFuTqxj+7/fOrb/kxBSUZUfamsN+i
         tcJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765851790; x=1766456590;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=97NP7q40hxg4C4aKfTESLyYY7arcjR+J9fUfN3qZbks=;
        b=u5X9M9vxXir+5bfPJapNuXXZ3JMRL5EO/LBEfwgRSlBIIuUuJiZAkTgKdhX7pzM2gV
         lJZfK+8qxrvNSJv6wYYsOzAQqkKuQ12sV+ZWLNQPWr5qg8kvTZkWYHFmvcktNdGbj8/n
         pXo7AEFZLZbKt1ShdV0luv8eEkuG03koogH5vfaqp3JQZZQjFGPp4pTSPPCG7Li9TvTg
         IpXAEn3RMgfru65J6bsUcs6cOUxm3d9g897rS0MHmbMStvtUoatQW7ppYjiuybDDRcyj
         fnkf5IKlYgdH019aDqVEUhFwi6wtLljKHGLuCNiClWzfMObXEEvj+CBRcLwkdhDhPc41
         cmQw==
X-Forwarded-Encrypted: i=1; AJvYcCVnwgnTqHQLVX40KRpqE1yQbG3IStM4frB8fRltrq9c+IYR6UHZ3cILrZ35xAi2YGZkJMwZggH3Qw==@kvack.org
X-Gm-Message-State: AOJu0YwrLX9FfguDPdOv0anKtaguFWFKfG3pIWTsXtY+OaiV4ISul64A
	z+1wR9y/7egGsHESrMUzR0Q3fhDl0sZuXIXFFtsPel9YMwJglMBM+PuTiBQiPHOqS4E=
X-Gm-Gg: AY/fxX7rsG76h21nk7ElEToY6eD17zVlnnyNHDkW/aRf+eTY0MXDEQG8qvZAWGc3Exh
	RTJ4qkEdePGe3E5pDobuZQQd2tfUDkLRi20zPRCf/cIVasDt/2crjanmsQbZmlZ6JY1WqFwhuVz
	ZQJ6vxjBAmcdX4HZnBlNWLkH7uJXR0WJzhha8KBUvF+8cNnEwCEcAz5V+TCaM9G6rJud2Gjx+mc
	u5+GiO7ahfTUGYZiWNRRZdQ+LuPxATghzR82ozxt6cIn2X3V1cw9+mGFvP0qv/7PWV7L1+SRS2X
	HUU/kG98pIGykkqFKpOGZU9acLpjvaPafBdajripZCSP/OIeL+2wZ9K7AILeJvoxSOcV3vECqrX
	D1tsKvkHTiDdgqvcWx9fCu6xVLVtGwi+ISO67MXh/8As8jcdZFQ2ny5HDkU8fzcz0AOlQtEmtoD
	2RxtKJTHu8
X-Google-Smtp-Source: AGHT+IGw49EXJuZm3frjyR11xkPH+vdqLYoeS1FUPQDYXLmra5UiAdf2Xx2U8pJgwATRG6fINRGdEA==
X-Received: by 2002:a05:6830:4990:b0:7c6:d001:afb2 with SMTP id 46e09a7af769-7cae8398d7emr6145680a34.35.1765851789989;
        Mon, 15 Dec 2025 18:23:09 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cadb1ff4desm11006188a34.7.2025.12.15.18.23.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Dec 2025 18:23:09 -0800 (PST)
Message-ID: <09d2d256-2eba-41ea-a397-dca4df5d5a2a@kernel.dk>
Date: Mon, 15 Dec 2025 19:23:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: retiring laptop_mode? was Re: [PATCH] mm: vmscan: always allow
 writeback during memcg reclaim
To: Johannes Weiner <hannes@cmpxchg.org>,
 Christoph Hellwig <hch@infradead.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
References: <20251213083639.364539-1-kartikey406@gmail.com>
 <20251215041200.GB905277@cmpxchg.org> <aT-xv1BNYabnZB_n@infradead.org>
 <20251215200838.GC905277@cmpxchg.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251215200838.GC905277@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bcq73ctzxyxjgxhfg783m5fex76erprf
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3A88D1C000E
X-Rspam-User: 
X-HE-Tag: 1765851791-510213
X-HE-Meta: U2FsdGVkX1/P9pmMqkFjs/bbn8dU4V0gia7Fh2oS2++tnAJHUZCRM24M92df2+pZYJM7X6syc3pVs1PKu20JC5U/PMTNxmdMTlCgiXH8n33ul7PZ1sVK3akm5OyjhszEwBdFFIPMqi9rdSBd2//F/VdV0/3JXdLqNzddMOkNLX26PJfd2qFD70dkyFVK8Ut3ZClwPAk1nNa6GbpA2kMBG6LZcVP4KoHa1mN+ZT/3KBSzqiv73UgnWTsx6EQ0fXY0Aom02QgW/0mSNmSt8QU5/pZWNJy+sTYYZfhRD0ii3kV80f0a+9jkktURkfMRHfgL7Z159rRXcr68U5YB1bVYJbddjO/e1ZwIpVsghAGEn5hDWca8aH5VOj/694ldoCnscRgfIVl+L/oJErJiEGs78/eMFpMmYbJkd4ZUYyGnDpQPryCXOIMfkJXpPW9L0mFshEnW0asngJyWXIHzAGRoTSRx+pQvG4fAgFI9Hu2CHQQO38m28qvrdD9G9MNCd1MVI6a7VtQWPRtDHPEBT5Kf7bOS2X6i038RBqvoCwHBjYyEhJSd1PDtIi1ZQOensTftQJ52w3dywBDVa/LLPoYG+nJoR1nygn9luPnRERuR+Rt7whtzFkGZUB0wNMaUtgBXTjFvqTanq+QkSfWpFUMCQLRleIZtNNnYZcedtcxyk+TyuH4by32/w/6APKTmbKriDByWQM+cSZ/p5YJfWm4hxlSUp6XtvII7FljZDaSloGDAGGx5HpymCp/ZrqsGz3hrx84ZiYl0qOI7ElRckLRXdXJYDDsAViUyNgaEdk4CUILanKfprIlcOLB+nsIvCHDed5QFdDifIprTI8AhWfhYMGkJKz+1rNXlYkH+VbLEw7FGI2HGX8wcIhKadegdhlgyJ05QSpa9brTvm2oIHfasqqrQXdGCLIxyYIz8bD6iEDSDfALHDGOgbnZ6DPWiag8fl/+fdD1gikGkRsNotc9
 Y3Bpb16/
 lt07E+3v0NFcr5ppSyyfR+pBj5jU+meSXTwNOU5UjUtwYAz5cn4hEog2zTqB+1jMKPEEFXhqi4uh3NKfkHOmecCpksMSfoXR94oeq+AMasR13QL7YdjtyXcYmx0pxmvc6B68HCqzW2T3o7QE2iqKluSqGANMF53bAnc3DLRaptv/0issWP9HwhoY/QMFQeOQ2p8TpsYeL2ojzLTqXAUx/cqqc/fL4KTWjwCruuR9D8Ctr1ma9osNY8oqlYGD1SeCE8BBYRLEkHWtynQGtYH5TKWoL1vP2OHI7Q9blCPTZMcmq2msbx/rtGgWvNw9pEyU8GsTmZPIjNpAYoz0nDbtoO3E/CVPUcYsUfrEN7dZUmZK7JphGbF6oeX/PmYES2lF+tatPoQFzXdbQY5WMf2YmsJFX6sRqa4nr+qmQooPuSn1P54F7lchBwqV28d50cJ14jbHLiCq/ft5+yf/W5Xa93wlrZFEOvYp97GmwUwfOrkJnzzgZ9FpncqGATR9SwTmsKuNirNEmYTLfAKoePLeQJlMavOwgfbApGQPTdGvBX/IyAP82Fg6Jg9JTG4YdNClT2f1EvrXL8uqoTBmdXCDStJuTKe2Ve1uwGj/SMmal0dr2dQeaNwr0PUiIMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/15/25 1:08 PM, Johannes Weiner wrote:
> On Sun, Dec 14, 2025 at 10:59:11PM -0800, Christoph Hellwig wrote:
>> On Sun, Dec 14, 2025 at 11:12:00PM -0500, Johannes Weiner wrote:
>>> That reasoning doesn't make sense to me. Reclaim is always in response
>>> to an allocation need. The laptop_mode idea applies to cgroup reclaim
>>> as much as any other reclaim.
>>>
>>> Now obviously all of this is pretty dated. Reclaim doesn't do
>>> filesystem writes anymore, and I'm not sure there are a whole lot of
>>> laptops with rotational drives left, either. Also I doubt anybody is
>>> still using zone_reclaim_mode (which is where the may_unmap is from).
>>
>> Yeah.  I wonder if we should retire laptop_mode.  It was a cute hack
>> back then, but it has it's ugly fingers in way to many places and
>> should be mostly obsolete by how writeback works these days.
> 
> Yes, that makes sense to me. How about the below?
> 
> It doesn't actually get rid of the reclaim toggles - I added comments
> for the other usecases. But it's a nice diffstat nonetheless.
> 
> Debated whether to add some sort of deprecation sysctl handler, but at
> least systemd-sysctl just prints a warning and still applies other
> settings from the same config file.
> 
> ---
> 
> From 868f67e9d0d4465a6c22d8a147084944e7569c8d Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Mon, 15 Dec 2025 12:57:53 -0500
> Subject: [PATCH] mm/block/fs: remove laptop_mode
> 
> Laptop mode was introduced to save battery, by delaying and
> consolidating writes and maximize the time rotating hard drives
> wouldn't have to spin. Needless to say, this is a scenario of the
> (in)glorious past.
> 
> The footprint of the feature is small, but nevertheless it's a
> complicating factor in mm, block, filesystems. Developers don't think
> about it, and the decision-making in reclaim looks dubious. It likely
> hasn't been tested in years while the surrounding code has evolved.

From a quick glance, looks good to me:

Acked-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe


