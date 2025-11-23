Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52A78CFC53F
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 00:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BD406B00A6; Sat, 22 Nov 2025 19:08:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66E316B00A7; Sat, 22 Nov 2025 19:08:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536286B00AA; Sat, 22 Nov 2025 19:08:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 404DE6B00A6
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 19:08:35 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AF3DA160A4B
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 00:08:34 +0000 (UTC)
X-FDA: 84139935348.28.1D99139
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id C3276140002
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 00:08:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=KzxOAUqI;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763856512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2muAciBOaE/k7xfizoYb3tuAX3qHAGDCvnzhObdNAnA=;
	b=11xyTaCXkmNeIJsMVausDNBIZBw7D0dzu8urS80vjzNTn2rjo/dg9S4OACvzd/QC0XQemx
	9dmabzUjpQbv3iuNekah9C57arf078VI6G/L87fvbHahRU1HxfhaRkwm2W3gi2NvFT11Ik
	7/kk5HpyU5yKV+7q5oMDYiBjNntA6Rs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=KzxOAUqI;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763856512; a=rsa-sha256;
	cv=none;
	b=WbOshatgVWbkxPU+RM4BMWRaZVUUah0zeRGUoqPwr+KugA6UG6iRVfZ6r+QVzr8jjj82aE
	sXdnh0+HUuSPakoRGcztOP2NzoT9NthlXo2vb+RsLBxnfJo4cU76m3o90MG9ehqpioZNhv
	aIViJmmCP1jfCZGtD4F7UaI+7UqFhUQ=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7ba55660769so2747780b3a.1
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 16:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763856511; x=1764461311; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2muAciBOaE/k7xfizoYb3tuAX3qHAGDCvnzhObdNAnA=;
        b=KzxOAUqICGP5D305UFfSvICEMRezA1n/xw9K81qgAOv2W7smJKccR8brd8JfGugBZk
         +3MGOj3p00/LhYKMJN4YAufoc3UbcdkQwd17SZBYlsoczDdAQBAConbFPwCvhdGi0ksP
         TUktSUvfNXN1nnARpJ5JOLIMuDWCpJ8CaBGkk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763856511; x=1764461311;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2muAciBOaE/k7xfizoYb3tuAX3qHAGDCvnzhObdNAnA=;
        b=b07u7Y0eQRr7LC2h0WHKrkO0+nmxyh5MA+Z3gSwbMfpQJ9IBIEKAFV+GiOzlGZlon8
         0b5pV2XWAble8dDkCb3qJw6SZQmpszV7W+AkVx+6HjRAQtaGH36d/9dv/QArVGapYnhQ
         VqimGrA8ScFtzgKIfuAohYXSM7BxYYjyz/mG58yPka8j/1CK9ch2O+9ANDKB8p/kEtfG
         fN8MPXdlhnv4zwk3FhH2NnyvfVhELqynRQL2xNd5RS7h3AzsoKQhE0pLSTFjYbjO4f2y
         muYRL8rWYL9aPgBiIK3Dfdh0chjO2ug/lkzK9RlvBgWh+MwJyEmdLnSzpyqDKEZsDJHP
         Z6pA==
X-Forwarded-Encrypted: i=1; AJvYcCV+5F2W76nh77gnu1ds8yQmA8h6REor4lDXpDMOhZnvvv0jdZ1nEIXEhFanoo+ZcMp4RMS7OFYXmg==@kvack.org
X-Gm-Message-State: AOJu0Yz0WkNLKnvwPs1HIcskTCxIUttvOpqHTUrzDHUkknLgbGQ9qENu
	F0550SH+fuHF0fe4l1MeSYYOjVRQMTmzzMITEQcG0sw3nlHKGD9W93yNEOdoeJhj3Q==
X-Gm-Gg: ASbGnctWAfD3fwCGOFUuUil6FA/NyrN9kmO5MtgfqP8TIK1GOkV5GUkouU4lrAU6M3u
	1Ea/GW8ywo7ivxhoRIfpFh5l1Eudc8gKz5ItGTf71rMVPaN8jikZ9CWx/rNAY44U5+khnJimWed
	JpFj3icdDZmjH0zajmAIM8BAOU2K/E6qTl+sXf0DyoaN55I3FSX0aXbXBbNqhxZDragPvVMk+vj
	bo9kCBShpgZ1cghFsCb5LcW7Dfu1LqoUrRNjFwlGhwVWfnjSRG+tnldKpiHVhSiS6jLeUWCa3FP
	aw0vBHtipcsjiUZ5eozYDHQ45FY+/3g9tp2OWkHoLJdemvZnC9mqwVknE0iXfVhqLfaaEy9y3tV
	6Fv461DboGH0TC6QbfAq0KwGkhyQ1ZwNiBs33f0GlEz0gRY/Dz9Hd/SRPYeQqk/fHZg6PGnXHSA
	TSyRlHHnl5J2Vd2k33KAT1R5Om6HKH/UO95L2vpLeFUUvbUW50yQ==
X-Google-Smtp-Source: AGHT+IGDke1OPproyf8Ea7+53qXNHLy3i8Pk7zk6unoaUI5Yq/mG08AMT5TtfH2aktdVFzwpQF96lg==
X-Received: by 2002:a05:6a00:1ad1:b0:7ac:9d93:3efa with SMTP id d2e1a72fcca58-7c58c2b0f28mr7440867b3a.7.1763856511542;
        Sat, 22 Nov 2025 16:08:31 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:296e:57d:751e:5598])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3ecf7d70asm10039686b3a.13.2025.11.22.16.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 16:08:31 -0800 (PST)
Date: Sun, 23 Nov 2025 09:08:25 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Yuwen Chen <ywen.chen@foxmail.com>, akpm@linux-foundation.org, bgeffon@google.com, 
	licayy@outlook.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, minchan@kernel.org, richardycc@google.com
Subject: Re: [RFC PATCHv5 0/6] zram: introduce writeback bio batching
Message-ID: <nx6o4gwpetxjeyfbu4xyibulvldr3xz6lyfjrar62cidy5gxum@xmx4ojyq3mbf>
References: <ts32xzxrpxmwf3okxo4bu2ynbgnfe6mehf5h6eibp7dp3r6jp7@4f7oz6tzqwxn>
 <tencent_865DD78A73BC3C9CAFCBAEBE222B6EA5F107@qq.com>
 <buckmtxvdfnpgo56owip3fjqbzraws2wvtomzfkywhczckoqlt@fifgyl5fjpbt>
 <8c596737-95c1-4274-9834-1fe06558b431@linux.alibaba.com>
 <kvgy5ms2xlkcjuzuq7xx5lmjwx3frguosve7sqbp6wh3gpih5k@kjuwfbdd2cqz>
 <853796e3-fd44-4fc2-8fd2-5810342a6ebe@linux.alibaba.com>
 <ztqfbzq7fwa5znw5ur45qlbnupgepaptzjaw2izsftbtth6zca@db4ruyaulqab>
 <2c6906d1-132e-401f-830f-ae771fe836c5@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c6906d1-132e-401f-830f-ae771fe836c5@linux.alibaba.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C3276140002
X-Stat-Signature: jxnry3br6egyijz86trnkajz1xktrw3r
X-Rspam-User: 
X-HE-Tag: 1763856512-804410
X-HE-Meta: U2FsdGVkX19hmDSZB2VjJ4cqHcb2YePWa+bVimt4bdxG5rruX91KDfbL8cY3lUSftrOdHNVp1tiTeZMBIwTEsVDvUF20E9Od6YGyOfxQVIxOAt1b8MMwoHmkLzPghO/pP5AOHkSyM5YUrZohTNgO1uwyx4CJH9m0QBVBoYyeGVli5+47e0bjUIz5t+I9NH0vU1StS2M07UAJFb0otD1tyO6NCFxc+xZqQB8ObjD0RrxDhS4FKVyOTPu+XSf0U8uOutiAB/EXU1w4vzYgM2ezSHytFrxiXSpg6CQePrLLQ4ZYh/E0IfJ0RMRoDy3SsUJywdTkXsao2ABSnOvpp9p710uwCt7xMG0j9oHoFoEs7a4+jrvzl8quYuZlO3eZuweml7CtQtub/fC4DVdCxUKLvZ/rR2i0FeMnlYG9mAAMSaYQAkNap2hBzzu8RR6O6jq33OFdcHg4smZ8b9PcBD8iMFK01H7jp4pr8pWPy9p8XYvHHQrQbcbEjd+3zZh0/FkPn/MxLwB/VVIsQ1HjwTtsSG49c9xPXYIOY3ZSdjV3jJYrnMWevayIsjbEI/Ld+2kMdhTHhr/0kliK2rEx+BxqPPtEzlW9/AtxOo4zsDUDkjkw9TSfnGxzkp7+h/veUzlxCcbPV+oPY88X+a54GqSNoTsFaUrhtRuP1T1cn4VGbAYNZayCwJVcGxi2UyPWFHOoDcmdiCr+WDyXKGwRSO5uEhRaAJkp4w8aYKkVW+kqHEpqHGwjLdrFV+I+73RAPXfrp24HU7EkU2X0A7A7lTu6Oh+57jQUPKKdOZ9pBbKxDgevonS556KU9DKmjQ6cZNJLemmIExN3HGN4XG3j9Jf/bx967x4HbK0UIrtGyWXZv1gJu4egVMd/fx1VrMgotkWf8CqyBkH/jWget/RaE4wPMy85tBMQfNI5KlTIfvzArASC6mQKvLDX0sM6pMlh4Hf3Ip9HzPUM2Poc4SlgC2C
 M4ZJci2h
 X3ThOKOV9OhnyRgwfuvopfIn84sdQa8UIG5dmSu1ucVmc2h/06So7WKE3Mozv/jXSM+mMNhE5XUiwcdlhNWPEZjPyAb1ikh5XxyhS4kbevuU4uehltjTKgQ83aqTy27v4KvdGnmsRJqyOY1Gumm3vjox2LRHxJd078IcO05f5THwbDsW0zsrXZoMGQRC7OA7O5WSOYWDSYZ3RvilTJ+fj6Ew29xITxqmrm1TCc9rUDEPzNoKD8pYDwliNA5Wv8BhicddlGX8cn/QI+A/Ol2cnvEb4MlRuH78pJdaD7BDHw1x+Wcl0rR+ptneseDT0cIj2ur09hX3+rKRXLVZtpjOpPtdB3GkJNjSWa+gCNJ23aq0yWXOmXoxtAgai3YDHZzlU5Yomtetd/Zk3jxo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/22 22:09), Gao Xiang wrote:
> > I thought you were talking about the backing device being
> > ext4/btrfs.  Sorry, I don't have enough context/knowledge
> > to understand what you're getting at.  zram has been doing
> > writeback for ages, I really don't know what you mean by
> > "to act like this".
> 
> I mean, if zram is formatted as ext4, and then mount it;
> and then there is a backing file which is also in another
> ext4, you'd need a workqueue to do writeback I/Os (or needs
> a loop device to transit), was that the original question
> raised by Yuwen?

We take pages of data from zram0 and write them straight to
the backing device.  Those writes don't go through vfs/fs so
fs on the backing device will simply be corrupted, as far as
I can tell.  This is not intendant use case for zram writeback.

