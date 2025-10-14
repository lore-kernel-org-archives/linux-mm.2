Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF78BCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED8998E000D; Tue, 14 Oct 2025 09:07:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E87D38E0112; Tue, 14 Oct 2025 09:07:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D76D38E000D; Tue, 14 Oct 2025 09:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A90A78E0112
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:07:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7C74411B098
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:07:52 +0000 (UTC)
X-FDA: 83996747184.13.93B24FB
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	by imf21.hostedemail.com (Postfix) with ESMTP id 099601C000F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:07:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=XYZmbZu+;
	spf=pass (imf21.hostedemail.com: domain of axboe@kernel.dk designates 209.85.166.52 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760447270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KtUOBA02vnRbubidZ3Mq6jULmhFQWs/Je7/vpnoal3k=;
	b=iWIrro+EGHfc2XQrjmQvU34CjzQQ9ixlJNANm5S6nsb3veqdle+jswcgMTDAv7yd9YpDgj
	e9XXLEkULGOdhPXAUlSPc9x1RpXPEcjnwUaAIoEs1Pbh8dsqjFeL6b+7f85KQXHf4weFtn
	JzfKV5HYuQWWLhkzzS0xxieUfZdYBjc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=XYZmbZu+;
	spf=pass (imf21.hostedemail.com: domain of axboe@kernel.dk designates 209.85.166.52 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760447270; a=rsa-sha256;
	cv=none;
	b=jWwbxqFsuHwJsDUlKxnHi6C2irL5sE64+veyCBjCyOzGCyThobrnU5rI85DlzUtS2hh1X/
	3WPonVl/GO0Ur4FW/HWFvDSA96G1cjcXEl+3yfDKuevw6U3++wOTllSrs1v/ysKxDML8C5
	+F4aF2dybro3aU1qlMiDlUW6KplpGj0=
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-938de0df471so491161239f.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760447269; x=1761052069; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KtUOBA02vnRbubidZ3Mq6jULmhFQWs/Je7/vpnoal3k=;
        b=XYZmbZu+tm4WqlDJefwxgWCUgfpKYXU5td/StS0ulT4anTX+WcN/avYb44/iXlz2rw
         eX5c6S4evSqQvCXKFtWGtOQje668LErxDNZzwSzcc7uOG9UUd8QD/uOdxicvDouUOTww
         wZF926gMKnVKktK78+g2gvwqm/rO7PSMYND4XgFTMO1Pwjln2tQkjVqmjiK58emzk8fQ
         Gx/EQjCo+NRdCAJydPfHZtAcFjxaoU7+rO5JKBiaRbpvKV7UIS7tB4LHWhdm85vW3jhs
         61odPGAXguzWQllfXvfkykF+7LXsqVw2hiQ0spuytAyb7o6McpPhZNO9Do6PJrfl1tTG
         yN3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760447269; x=1761052069;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KtUOBA02vnRbubidZ3Mq6jULmhFQWs/Je7/vpnoal3k=;
        b=JbCvRqD7M0N7AxZc70m7hmVjOQtw6Fv548pHSvKFgYr8ikAPEv8M/Vd3G9DQM8QKOC
         UNj4A1syRHMRCS7bcVqAqbdVqTo+e6odiSmqiege0c6jy72XywUzdswyMaGhjYO4IySP
         Un03eh6xYXVZdZQ5tvRP+y+9SeRioqytk1g854F+DPF9bn3YkczuoCfYipgMjaoU+InY
         Hz40M50u93RXTggzgf4rWmOpKw4Ada9cIWA39Dy5ewjhbNUzACdRBlmqoLHKmKRqW0du
         37LJIUinNgzPy9lerW1QFcIjeVBrCstmokIpe3R14qy97AbIpb1vVsDl7JbsjLwicRE0
         01XQ==
X-Gm-Message-State: AOJu0YxiuqN4uKypAx1eGqcjGI0wYcLEKO8jF4YL5adUMDb3ANvGbm2Z
	qaY8CdNVVOjHNkdgjxZGHb46gcXNK+D+GYGqf2embRLol/TOefyvvJRCgsPvWYPv+J4=
X-Gm-Gg: ASbGncs2XDcVHLIRNbBWGB9NJfeTazMI3IjCTfY2Sn8c4J/7o/ngr9/q+S3l/xknoeh
	dzpF7ECOf8o+6dV/t7AlGV1P+4B7QZUkZuAM9rOXtpzecp8HSWlKr2m1I60mIsQXjQclIDnzoe2
	kM5sYsO3UGNuD4RWouj2+N+Hnxk9ManhMQ6AgCqnmEndaIo26GLe3cfHIkG1Dtf3osenMljlVTj
	tou0kJQbFM8O54L3cBio2I/eb9TCN++J4BqPxRDhmm1x48BgW00x2avml2PDW3KP7VWUens2gVV
	1ZjoG41WqUa0+uRy8NYll8TrxFqwvkavSCnjSXCbe/XwOSXEUWtDW+Vgo5u9ljgH9QEEhS0ZxL0
	UQPNaoRhRxhfK886VBbbNh9RDwMNeNcyoAngdwgw=
X-Google-Smtp-Source: AGHT+IGh+/cXW5eXefvfc/8019u8t+Wip4UewYdAOiTu7XDHpy98OIT7QQFCjFM4MijZt4pR5t5BaA==
X-Received: by 2002:a05:6e02:1562:b0:42e:2c30:285d with SMTP id e9e14a558f8ab-430a43ca194mr21969905ab.6.1760447264888;
        Tue, 14 Oct 2025 06:07:44 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-58f6cd58e48sm4796689173.17.2025.10.14.06.07.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 06:07:44 -0700 (PDT)
Message-ID: <c775db95-ccff-46e8-9e3c-5cd784618f04@kernel.dk>
Date: Tue, 14 Oct 2025 07:07:43 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Remove the BOUNCE config option
To: Huacai Chen <chenhuacai@loongson.cn>, Huacai Chen
 <chenhuacai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>,
 Hannes Reinecke <hare@suse.de>, John Garry <john.g.garry@oracle.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-kernel@vger.kernel.org
References: <20251013095620.1111061-1-chenhuacai@loongson.cn>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251013095620.1111061-1-chenhuacai@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 099601C000F
X-Stat-Signature: u7ug9imq7dxdy11ni49ca9whf351ynmr
X-Rspam-User: 
X-HE-Tag: 1760447269-544945
X-HE-Meta: U2FsdGVkX1+P92kAdKkHD2fVrx0yh4Q5XwqK+yJ3VbC0cRMDvXZ0r5dcKM+3VtuXokeSVCQoN9t5za7h3t6RA+UmTssmBGWKG7hdcz/sHebCL0VmbbYaeHoG50vQmTSs2bBWJQeASvlLYG7Rv6NHEUCWvXYqdWfw667aneTZRqLOCMQDUwmAKNcw4/eHByHCJGkbukpoZHpMM5UeVFdNCPKG2aBOSGape1geyy6Sx3zH+pC80VTTjUENCY96Zl8Wtyrr0CpkLmPEEuvYePMS+Qdu9NhF6HBZWTWAgLcmkaoEZpFIIjgwz0HOXC9VhPaiamIXmmXtiRooWT93ehnIIxZ90w0Qzl1DN24R/8NTVmkOZEM3rapIv8zU0AgblXDpGdohw2yh6yV3KYaYO0ZRUe5MA90XImHS8+YtluBLk0buKadQ9SXv+O21bis/IT7MP4684LFq4945OrwnV2Y4dfoxV+wCKGF/UGxlVUtYk57FDavdQHolnwgwuRwH0Q3gi4SpTV8TAOv1dCn71zysQllg41AESEzkxLvuu8g+agji3902MOt+kxrFvZ8iuf7kMOQLNNBa83BLumnQYdiMkqyWCyDX2DBv8mGI03+ptTHLsgX9JFQ21XMUbsWQp39OPeoYFEt6QMNisNEptHJhFTBOseQsZrO/CQDxC2gAjC9taQ/E2kgd2urpi14gA8JTWeZA+PLSzCTcHzGAwWDYpAtmkACWgB+MvL3nepWDO0Z/zgO7AIVaOKugBD7D/f9wntvXMzhMrCR7p7CgL1CJaNI5KRja4/V9cVknKbmvgsCEWnL9idJBN8S7BJHYBqfe+taGSzcGxIc26OxUPetbRM1sWFTB/m8AjNY/XwxHh0TKODAXpDdzuQQqIr2nBjeGuXdIEvQ3WsTwbVaynkeOb23X45Kdo7GleVj7vDZJp5/Ca5tsI08z45RReOMHV4CvQ8di8tGjhHjsgCf72pr
 FhFb2DoO
 4dt9LrYoYmtn/1xXKawqJ+uGQmpXTrpnA/l7SUXJRXM+cesvE/iRf+elKu5jmz1mHRfp88pk6gqt0/RgGAGFALRszkullEyew3r7HvU078ecxJmGpq8dt2f0f0X8lYa0MQV5XRcsyp2Q93FgAQbck8hDrDfBnwTZT+aMiXmQoBI4JFRaAP+5x5g9N+S0xRZ3c6Fx4OJoyln5JvuvPm5JS/CkkNGK7dqAek7VZAJsBnSsOpwKKRVgXkOBo6L0WGEIyWz8BBrqGEaW+ni5SPM3Ar/HQp1gy3mPHpP+GMoxL6woC7fKAAkQxabe4nlm62r8QVxAvgVQMa/3+YYUZLg0ytzTHWniMUE/6gI33CZRqCzQgu+kBjhDhZ9MdYJPNY4wDstA1FLDC2IqE9Q47ZORLMV1H/VvGMBLs5I3PxKULDp2DH9I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/25 3:56 AM, Huacai Chen wrote:
> Commit eeadd68e2a5f6bfe0bf10 ("block: remove bounce buffering support")
> remove block/bounce.c but left the BOUNCE config option. Now this option
> has no users, so remove it.

Acked-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe


