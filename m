Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFD71C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 07:18:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B76E6B00AB; Tue,  7 Jul 2026 03:18:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98ECD6B00AC; Tue,  7 Jul 2026 03:18:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A50F6B00AE; Tue,  7 Jul 2026 03:18:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 643C76B00AB
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:18:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F15621C7EB8
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:18:29 +0000 (UTC)
X-FDA: 84961127538.13.640E89A
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 164A8140007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:18:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FNbBWTj9;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783408708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YsSJgGmwj8owXsbgpIZXs0JPGhRVFwHddqbby3E9Cmk=;
	b=P1Boo50wM993B7/zqbLp1+5eyyXOAqH2H572jO6B5ePObkS1RtDd18e7oLjPYl5Ztcj2dg
	l22LGvOkypjIDHg7/yOrvVXykOJ3IaqhBS44t1L7X2C4OCtJLUFVg7CG5ThByTZt2QQPtC
	G3AOJ8RYFwlheXBoZy7cBCRG1PjVPG4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FNbBWTj9;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783408708;
	b=oVqykIS9ZFS64Mp33snKLqQeJXwXDUIeB8DvsWVWQx+Mfz9VcOYH5i+ABh+oYSQk5Aador
	5xhTf0XFAjQPXTQMp38OnYPtvcHdPMumOrRWWJu/0AXEmTOUnmZ21+5pn8Gpj+FMI+N7Bz
	Q9w37ylMzwGrwSssi/NU+khrJuk+eb0=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-847917c3678so211513b3a.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 00:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1783408707; x=1784013507; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YsSJgGmwj8owXsbgpIZXs0JPGhRVFwHddqbby3E9Cmk=;
        b=FNbBWTj9r7P3HjPsTMghXE5lngOxvuLCS0AhHGqUgUc6/tqOJL9K/HV24/o36BFFOE
         JBQujXlDL2sq6PZLvGuTmfiHW9MGzsv2NG42nxJsp4K6k0ZkMDPDHejclsx32lm8FRWN
         2MqnnklqTcPvEzMGquAz0eQyqC9fiEjsmqSQ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783408707; x=1784013507;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YsSJgGmwj8owXsbgpIZXs0JPGhRVFwHddqbby3E9Cmk=;
        b=jvk8WVU5ybTiSfqqJk2Liw4PyHvoBl0NcHLz4jWp3Ke1TdVsF6RxR49kPng4ypd58W
         p66vZSB3aH6TTJHhvix0Uy+m+kbd+iQgMD2ni1GXC6DDcikPuYtRCrxSaajAAzQtLu9z
         oCyhrZCjSao9E1is/zDi3VTbA7F7HPQd9pBeTKiHJsdviNt3y2Nb1K5v0eZv1/L1Be7F
         ko8RtJvS9vEoGlyviWr2oALaPOQ/2Toz751w2yHnya/XD+q9+0FWtyUWWoFGghqnBO2E
         vpBspdjBYh+LMfYCCONs0LN4zLSHygoWB5ZxzipkY/NVRaAq5HtY6S40TMJf6EzmJQpj
         CL5A==
X-Forwarded-Encrypted: i=1; AHgh+RqDdCEQ3MnAIE7Xi98qrD48YNwNXJGTFCgccob+WUjrPjiXuipr/hEqCRVRx5/B4h94HyqZcLSwEw==@kvack.org
X-Gm-Message-State: AOJu0YwnadcxiBubC0KerCuG27RtlhM1OXJfk7dEKOKIqRksXW9bjefc
	091i0YTRdOvOspwiekmZdHASWRMHeAY6KvdauKGovXUZbbLTNztUFox+VebDU7NRVA==
X-Gm-Gg: AfdE7cnbsZfd6J1V5DgINu7UN1rja8vVvs+ubrcx1sfXNjuwqZOTOnR9960xRPb9l3L
	zpGmjz56sCr8EMneBCpFOgP/cSJ7rB42o4wMbxUhhvWTDWPkbsEyPBEVOkAbDLIWafK9iAyEPka
	TFNNTTRYgpIFojhJGFcjc+YjzyV3I3XAI2VQaawsz5hcPmr6h+ktEo0V6pQnyxhxRtk9OxWO0ru
	VVr2pye1uTe7yE42ROZ/IblEeO5Vk6m6NjT2syiy6sTQjzRMIMx5h9fWB4KV14UCF2NmMGmHh1h
	9HKdJxd6JvKOIwlv4iRdSd5kAaaEOXXPbkxco5vbcbP8Rr5hKECVllCnvQdr230mahJT3kb0tj6
	fkh3c/pcBWdJ0rV0THykQkvnCzKRvdgTFrtbSzPClWjiPlGk5Dy4c3HjrUFheepQsB2m+QjZa4x
	aXxPTsvRACTKFqGhFZlG8CWf4FJX+ov6fzJDIcDGl//I1Po8RhJh/h
X-Received: by 2002:a05:6a00:808a:b0:847:8d0e:5d83 with SMTP id d2e1a72fcca58-8482f522f6amr1655067b3a.26.1783408706956;
        Tue, 07 Jul 2026 00:18:26 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:d4f4:6328:49c0:b912])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6dbdc8dsm4897307b3a.55.2026.07.07.00.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 00:18:26 -0700 (PDT)
Date: Tue, 7 Jul 2026 16:18:23 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Nhat Pham <nphamcs@gmail.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Barry Song <baohua@kernel.org>, 
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: Re: [PATCH v6 0/4] mm/zsmalloc: reduce lock contention in zs_free()
Message-ID: <akynv_js-5G88rGd@google.com>
References: <20260626015003.2965881-1-haowenchao22@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626015003.2965881-1-haowenchao22@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 164A8140007
X-Stat-Signature: xhz7z66rqebs8sc4g1n6onkmhspsewr4
X-HE-Tag: 1783408707-217590
X-HE-Meta: U2FsdGVkX18rDl9P7tNQa+6lVlctdzSUiezP0xHhal7tj8JwcdS73ZQ6L+sLn8QTDrWKPdeX/x5FsML/wrfYeeFy5romwtioB98xsahTiEQKr4eBeO2p8+mGnQeuLdZoMMoZfuCngEtudbTv+Hp+2po3yLrmAWtbNfohHiCqPnrmDK2pC/EcSZ1Jya746uowYtnaGSPxZ+4gyVy7SDOfSFWqmZ3A4Cbwkd/0VVEWERrgbQSgmpj/mWrO0S9wRDlxf1xYyOxJYBY+GfsEfvUB17Co/0iGwo0aJFNMjfFNyFor5yK+xZgWeJMHwOysz0HqEinjcVD6Sf3NxzT/MGKkpoBxDdAhsZXU0VruSSdBLsB1Sl3a/9+F6nJxYpycQD/3ikNd4YmtsSk5kgaIfOLIZDThIccGTzIHTLb4kDgKHeUS2fT4R8PUNk1/HJaFxuqR7enyMJmhYN7qMn48utM1AQUkqsPU2jpZ4lyIv7nVP9B2OQgyDuaxwRVHw1R83/1uegYIuzCxLSHF4T0TOLnLFxUyKxzmBrBTV/8W2OctcFMYMkR1SaDcN7zoISDceQdIL6pTVcPbiC8/PWTnFoCLNhaKQxc8s4oXW9Ct8fmWWvpsETKMhJX+n3E8KEz4n6OGF2YDA6J99SW/M8FMQFFJN3UaaPl629eeWttL/cUd6XBP7/BDDiSoD/pDh5352y/Z5e/oUJP0t5Rl/R6PgKrqxpl/sxLEObU3RZ0ziUBdq3I1YEPxkSC0BnrQFp2FIjrXuoLA6VhX+9wSEPIX3MYDS5sDu8cwLYm47u+Af6CgdDU/zOEhNkkhSJJu2j3EoZEWUjm7eUtfg4+2Ne6pfJ3YW9ITmiOS1PxoOVmhF5hZliWnhztLkmCKh07HPDnb7+2kezAg5QBouroPCo+bmFP6e7xDThkreDirBffzdZfFnSnA6CMC+ln7AP+ynArw4AP5SDu6sQn0Eav75vzpymw
 hmf6csNz
 c00C/o6tESj7yp4Q5IF3/KRNpYW8IlxFa0PLB3Nf2G3pS4cuRYjmofS9ZLTyMv5Ixb1eLC68C1PaeYLlMrCyI6j0enyDQOM3uosjpNWZpWp3qv9vp3Q0oUj88eAzzpC3TZ5J5WvKtQAkcdgELl/sTHkmYh5jdgzXweIAtm0zlIIvLPyL0suXIBLTjgxscfAqv5eXjVQaRJ/Qo6KR4TJuEdFPmAVyHYoEVfu9y7GMu0S9SDR/hm2W9YpqprBzbkemPIYdgvlIaWRGCj4P3lyvkfN2gUzHItemSJAY4DfWegV0BGTlzcU8CXA0Ks9nxqaI5K/EiqGhCEZNtdXjjt6n+foBVkF445DXTodwGcM2gXlL+LLMyBO9jjeNn86XrPbEfWMhTWhMP2rmpolVeRFkZuiJxMHZ/RRIwQaZWXHQEC6GDL0LOGeFItnbwm608841gnbEEsf7R1/LSEcwJMvazYr5uyW1Lth9oul8t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/06/26 09:49), Wenchao Hao wrote:
[..]
> Changes since v5:
> - 2/4: rename obj_handle_class_lock() to obj_class_get_and_lock().
> - Pick up Reviewed-by from Barry Song on 2/4, 3/4, 4/4.
> 
> Changes since v4:
> - 1/4: rename macros to make their intent clearer, following the
>   kernel's *_BITS convention (Nhat Pham, Barry Song).
> - 3/4: drop the unused pool argument from __free_zspage_lockless().
> 
> Changes since v3:
> - 1/4: gate ZS_OBJ_CLASS_BITS on a new spare-bit check so unsuitable
>   configs (e.g. UML, no sparsemem) fall back to plain obj layout
>   instead of breaking the build.  (sashiko AI review)
> - 2/4: annotate handle_to_obj()/record_obj() with READ_ONCE/WRITE_ONCE
>   to silence KCSAN; sync the #if predicate with patch 1.  (sashiko AI review)
> - 4/4: clarify when async_free_zspage() runs; pick up Reviewed-by.  (Nhat Pham)
> - Drop Reviewed-by from Nhat Pham on 1/4 and 2/4: substantial logic
>   changes since v3, please re-review.
> 
> Changes since v2:
> - 3/4: drop likely() hint and tidy up else-branch braces, per review
>   nits from Nhat Pham and Joshua Hahn.
> - 4/4 (new): document free_zspage helper variants in a single comment
>   block, per Nhat Pham.
> - Pick up Reviewed-by tags from Nhat Pham (1/4, 2/4, 3/4) and
>   Joshua Hahn (3/4).
> - Fix patch 1/4 and 2/4 From: to match Signed-off-by, per Barry Song.
> 
> Changes since v1:
> - Rename obj-encoding macros for clarity.
> - Make 32-bit / 64-bit handling transparent at call sites
>   (no #ifdef in callers).
> - Extract a helper to keep zs_free() unified.
> 
> Wenchao Hao (3):
>   mm/zsmalloc: encode class index in obj value for lockless class lookup
>   mm/zsmalloc: drop pool->lock from zs_free on 64-bit systems
>   mm/zsmalloc: document free_zspage helper variants
> 
> Xueyuan Chen (1):
>   mm/zsmalloc: drop class lock before freeing zspage

Folks, really sorry for not being around and not being helpful,
I'm catching up on emails and will look at this in the coming days.
Many, many thanks to everyone who worked on it, reviewed it,
contributed to this work in one way or another.  Thank you!

