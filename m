Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD026CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 15:25:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0732E8E0010; Wed,  5 Nov 2025 10:25:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04AEE8E0005; Wed,  5 Nov 2025 10:25:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECB2F8E0010; Wed,  5 Nov 2025 10:25:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA8978E0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:25:24 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 87EB11403B8
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 15:25:24 +0000 (UTC)
X-FDA: 84076927368.02.0E3C575
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id 52E9F1C0016
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 15:25:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=AjR2SHkt;
	spf=pass (imf21.hostedemail.com: domain of axboe@kernel.dk designates 209.85.166.43 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762356322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=487sI5AbJzpMbYjr1CjDcFAjiYiuuI8y81LMpEqcmVA=;
	b=BZDTfPV4EupK4jpu1y/M4ywvD6lIHwiG3H3E86ZtuddWG0fQH+LPbAd5nX3grzvgzakcxr
	620XYDKMHe6XX6vSYEPiHndXOQYSOP97CNRDwt5QejJKJAgz41H5gTzjFdrRCZiqplR81U
	0JDtsL86UQ0DFtULhCF9zIyQ8uqHh3I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762356322; a=rsa-sha256;
	cv=none;
	b=XiOmtGgO93Ga+AWh7A81d8RU4jnnCIUl8dXDY1pwjBwEZe3BAGvezAQok/9lUPmOBoo3Dj
	gyX8IdBzb+dVVxnFTa7CvQSkZdRu5ANswJxezZiDF5MF0F0kNwSwMOpBOXtkjhJ4e0HC0e
	EQdxFdFTNRhNBiIY0quZYGE2PqGQymQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=AjR2SHkt;
	spf=pass (imf21.hostedemail.com: domain of axboe@kernel.dk designates 209.85.166.43 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-9486354dcb2so77044439f.3
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 07:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762356321; x=1762961121; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=487sI5AbJzpMbYjr1CjDcFAjiYiuuI8y81LMpEqcmVA=;
        b=AjR2SHktU88CUZAnRpiVaLFnALb3rIomDJn2rR6gi418JhAZ3UWLFWzV+Pee29sWAW
         MHIrEG9fS+tFXVnSxhCWwHyPF0mEgwCgXSelb6faaEmLOJlS2W+JXoD8jTQ5+PmUKDEL
         RM1Qccfp3GDfdPqvBOQFcw41ASU3OHvtnrylyvGlchFmuW8Ta5OZiPFz8nI/R0jkdL1x
         JWFujEH/fGU9oQxfo3PalVR2OXS9V1c2pEAKxLXTKTbxSLcKp5GhdBfXAY7xVaVim2N4
         b+l9XIfC930HNbgY4SbmKTnvXChTIwjNvSByNn1lctBsIm6Z4pY4XmbhufOQ+Ou/CWf+
         0p/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762356321; x=1762961121;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=487sI5AbJzpMbYjr1CjDcFAjiYiuuI8y81LMpEqcmVA=;
        b=YSxLkMYIvLRMF7D70ri/Ob0igofVaUIFtMJuea2QySwMxslesLFOXsbgEPcu95uQdm
         zWt8mvUk09wosLMItqKIHvxyjJUdI723YK7QYdH4crJSivXMoUs+OowobZdWl0vqJMq3
         yJEOHqWWWPGKmOcQm8ByvU7Zw2J/Irxb6HrNejGNznCELOJ/0DBUGmv2yFP3heMQgbM2
         S3PHypo7/GyUClU9FHAB46ZLCufhahbyDNWPThUWED0cCeJx4aXx9dUWNvfTyMPk+xRK
         py1PKFaOy41PdSVeCabo/8fNcFeBowACAkCWp3AA1Z09vF/vhKCutknELrmN1zQ6hVYv
         hFeQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDLoN5BDdkG+DjCk6HwBAnMTmWSeSB2x1k+VFDhLSnaG22hDt9FRhUgKl9egGWnygkDOZbzQHErw==@kvack.org
X-Gm-Message-State: AOJu0YzaA2izIxE7/ALohjIXja9xh6eatFUjH2PKeFHNbkUY9LdFVgaT
	2LlFXhLmHaeZXj/ZDbMRaIFyVO2hqDoyaDXntebFeCN7mwMUaZ9oCPcm9+fszkRJqgU=
X-Gm-Gg: ASbGnctKilPI5kg0X7hnseVI2HjTyyj8hPkFRtLqaR3WSDeNnYs3xUjIUJTlKRB/y2L
	zcwUnnApUe8N/YuWqwr+W2iYQAOLrNZjarZBFCUhMgWZAPqEYyyI+EGPkxtBQznSBfESaIkiLJE
	AZoElKqSCronH91Hi9OPy/jSCJpO9ylCOdD7IcEI7/hPPtcLpuZ8oMS1SBGxe9uKe4XR/sTc42J
	keBoOebXHmESeba6Eh6gdpxkFmUXTkwvKoT1uqQqIB7y+pRrgUcVJ2QRHm+4874LJJL+uGuxy/B
	pqBkVPwO8AiEra6VOBpjoe23sI5A/Lv97N5UdfNQeS51+QvPuTgeD+OhuNv4m+KWQfzd778bkoe
	6JkjqxwihYS9zje7raYUicJOE78mmtx3O5csez5RIj80/ZY6l8PgwI1nEFE+81Zf5S1sR3YIL
X-Google-Smtp-Source: AGHT+IGc9ECZf5jYK1jLXUdJ3FXQag+q/dzClLumbg8vy2PbyYvXZm9bHKrc58cJrzWZLVcyD9QYcw==
X-Received: by 2002:a05:6e02:174b:b0:42d:8b25:47ed with SMTP id e9e14a558f8ab-433407a705bmr56303455ab.6.1762356320939;
        Wed, 05 Nov 2025 07:25:20 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b72258d620sm2536362173.8.2025.11.05.07.25.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Nov 2025 07:25:20 -0800 (PST)
Message-ID: <83d64478-d53c-441f-b5b4-55b5f1530a03@kernel.dk>
Date: Wed, 5 Nov 2025 08:25:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] zram: Implement multi-page write-back
To: Yuwen Chen <ywen.chen@foxmail.com>
Cc: akpm@linux-foundation.org, bgeffon@google.com, licayy@outlook.com,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, liumartin@google.com, minchan@kernel.org,
 richardycc@google.com, senozhatsky@chromium.org
References: <tencent_85F14CD7BA73843CA32FF7AEB6A21A6EC907@qq.com>
 <tencent_25F89AABFE39535EF957519750D107B7D406@qq.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <tencent_25F89AABFE39535EF957519750D107B7D406@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 52E9F1C0016
X-Stat-Signature: xsrshc4zraerdaeaxicna768wa3fa367
X-Rspam-User: 
X-HE-Tag: 1762356322-112105
X-HE-Meta: U2FsdGVkX1+sEtyr71jQR1tHqrAwKJj/AE14EXe8YG5FG/uZuXejDPRD7h03zwl+Uk1vvEFf0L4FGnIizFCFYyNFZj9L85R+djUIyHV4BPnEzmQRsYfa+3VpP50seTzCuop7Tn9W5N2hSiqVyHVLxKUR7frhpMDfOfAU4h8VuO6bajVQHSKXieUpbROG5pGN8ZSGG1WRWVv7Ne18iGWDqBrHTl0y/I3/IWJdA71LjBId7GcCmpxlKNgl8W9oHqQ++fBOQSnaiSBMsrleH0mGBE4EYo34HcNjW05jvdk0EYlHr2PPgCOt822xyRUWmv2rbaNWVnCQDUVOOjk+6y1pVamNX5HaO5W9oxYkPX+NChqLNxKJRuIqeiQgoAq5qcuCeXNUEhDsR0Z/z9ZCcrlwcCvFH+/ORjxApM3bVV7cFoL+jAkKKlUbsyOj4aV+HnrMSViWWYi1AssqgJJHiLeep4tvnnVGPobeY4onLkux5cQTyhPx5vhJ50EWLsQ6lDy+SHZAXXgHwBTfhoqViu+rie4Z9yvM2MAoQeUlG93Z7OUIuUxR1Xxs8xTfnk5Jxy1b4Ch1deM87QeeJdJC0LTvYRUdBswdTnjzN1mBf0wVykMKEXX+NCH2DbD9F/X6USa2daJsN1m8+UTEXIC1xPKhugd2Gi8L9t58FdmhvCCcHkZBNlbPwr2E4cex6CNTcMjSurfjGqi54Y22sJBnu3/l+XcfTvmrnfZKTf5KOxrzBQl2wsUAB4JEwYW5RoQ5wF9oaKE35DgPMb+zRFMxamC4FwAils4/pOF6RM3QGMUYKmnzJWELeI5afLgyn7Fz3R5+7w1MXQYhQV0ttxcSOFSKGWHaONQCQRGvUBGxrq0xoDvicR4yzaf+DliIS/txonCN0RRvzobA5L1ZsRdRMnK67rEy2avmLZ5zMJTwNPJb3AKqc+EwCYAkdHypCn2Sl9UCkpDv+IV8S00ebINDshE
 wAx3UOD/
 jbl485ds3yVcs85RCroo8vHNlWvMR2Iwy0yd2DEIrPItncwFnaq3OqrbfBn9cSTSZ5BWqTSgjgSqGJioF+2kMoDHPNK/IhnaPmurBE8is6CEc1WrVA+05EvQTic0KRi0mp2v/Fc6jelcrjIL86ZlEXp2v293CGvzjpEr/DMFc1bsQqe+8aDmtkDoiMbsMskE5ZnpTeO3bJOncCURxoFafymIyfwvYom19BNV71dBX+fOw7g/mtxNJ0+4NvnFJRsxYshmlRt/HYDRkwO1mioeRQaB53NZFL7b1xM5Qw4dm8kPMsRUxu7hmTOYXRXAC/ZYuRek+02L1vvDExI2L6tIikBgPNINorGU1aBRPlL/yVJFRDPDuFl1s0NbpI45efVTGlIJ7XCUmvbZ9txNWRJjGr01bDf5GojvaGoJdSHhirdThSrfE8qHmsAWwEz/r9NXlxAoKXHjD917dSCUNQtRSzz5zaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/4/25 11:48 PM, Yuwen Chen wrote:
> For block devices, sequential write performance is significantly
> better than random write. Currently, zram's write-back function
> only supports single-page operations, which fails to leverage
> the sequential write advantage and leads to suboptimal performance.
> This patch implements multi-page batch write-back for zram to
> leverage sequential write performance of block devices.
> After applying this patch, a large number of pages being merged
> into batch write operations can be observed via the following test
> code, which effectively improves write-back performance.
> 
> mount -t debugfs none /sys/kernel/debug/
> echo "block:block_bio_frontmerge" >> /sys/kernel/debug/tracing/set_event
> echo "block:block_bio_backmerge" >> /sys/kernel/debug/tracing/set_event
> cat /sys/kernel/debug/tracing/trace_pipe &
> echo "page_indexes=1-10000" > /sys/block/zram0/writeback
> 
> Signed-off-by: Yuwen Chen <ywen.chen@foxmail.com>
> Reviewed-by: Fengyu Lian <licayy@outlook.com>
> ---
> Changes in v3:
>   - Postpone the page allocation.
> Changes in v2:
>   - Rename some data structures.
>   - Fix an exception caused by accessing a null pointer.

Please either finish the patch before sending it out, or take your
time before posting again. Sending 3 versions in one day will just
make people ignore you.

This commit message is in dire need of some actual performance
results. This is a change for better performance, no? If so, you
should have some clear numbers in there describing where it's
better, and where it's worse (if appropriate).

-- 
Jens Axboe


