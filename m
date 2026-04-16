Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D3F4F43841
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 07:41:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89EEE6B008A; Thu, 16 Apr 2026 03:41:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84FB76B008C; Thu, 16 Apr 2026 03:41:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765C96B0092; Thu, 16 Apr 2026 03:41:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 642576B008A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:41:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D916C8C301
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:41:29 +0000 (UTC)
X-FDA: 84663623898.30.9237A7F
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0603A140002
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:41:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=jDMKaTFY;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.43 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776325288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MaYOU7eGew8S40dm8UCkeWyZ2/sdhMJxx0U3+qUHRQ4=;
	b=LO15T7u2DQUdOPWGqhIGEWKwze55L8GFhOBc5+2cFZKZUoE4V0jdUS5seeubTBkL1SCFVd
	n5RdNwb/Y/rCEpxOYwckPspXyuUagHbPlDupXxvIMteL2VLToItlc6a3Yffc86MCTi0MPM
	lZ/vaJiUdp54xJAmhA8O0Wnrd9EH6WI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776325288; a=rsa-sha256;
	cv=none;
	b=acQrjM6T3jLMUMQqctm8Ee7WoBz32HvhN/07z+3m8kZfUrY0+S5PCebpTYSi8QmdLzjhgo
	M6LJB0wk7D/2IcY+Y2ik0oWX5qfTfXbWRd+ca6LptNQRIanwXWyVmedvS12e+hu5Loq3Ue
	ul8klSWPvaHU85eHmOG98rWjl88MJ5g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=jDMKaTFY;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.43 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-35e563b0ee7so163670a91.1
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 00:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1776325287; x=1776930087; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MaYOU7eGew8S40dm8UCkeWyZ2/sdhMJxx0U3+qUHRQ4=;
        b=jDMKaTFYgU/6KPH1IXOPiTg+FS4I1YB1X4kh7z4Dl/cwhfC7zdMC/Chu4f5FvZH7is
         CRv39lAEw7bnOlE74Ns3Z3EVLYaK4ILpQqtX/TBOU8j+YTaXbDpAKpBG3MF4rnD4ox2F
         c/HhuI4TGHpNL5qdJqwV7gRsqqyI83MYqhrtU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776325287; x=1776930087;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MaYOU7eGew8S40dm8UCkeWyZ2/sdhMJxx0U3+qUHRQ4=;
        b=cvqR1d+JXxQgKcIvwj6WUynXf0hrygcBIKyNcBFDF3dCyibdLUaUSNuDTHAgtFPm7S
         B2rKrpZdXCdmi/Moesgz+8zHgss183EB6vUAOnQSUqlFktitDtgvLX9uul/ksDwJTuQC
         WEDH5e5+cTkjyM7j4aGCyblIPjsC+m/+DwP24ITEQchpRJBpR0Tn2EQEDL21u9yuLyhs
         Zs89NH9T0Lj22gFrNreTXpFITP/N7gnsaQkPia2xmQYGUWfCoY+L85q3UgTqomAlXvG8
         w9M/o0VoB8i7UMOZIXohm3NUl6SfsYkmmM4CYfVRFJLJ/vT2J9c27LeavWRbQQRGMDKx
         rHXw==
X-Forwarded-Encrypted: i=1; AFNElJ8iiS97fcyqDkIwJFXJGPeCm/n5sbscx9OxeP5XROrqwEw8DjOY9nxI3wxOefU1Z7BQaszOoDecmA==@kvack.org
X-Gm-Message-State: AOJu0Yxre33e4J07mjGS9zzPthl0czUsoS3rzVGy/hucfD2zy5umaPbi
	CzHOitE9BaQ2pyMSb5rEsoL9xhgtbaBGKBUeas2HTOUPSIuEJGxOebPdTSrLPT3hGg==
X-Gm-Gg: AeBDiev3F2sQ3iCd6vr/Q4eTJIzXWlEOjIBMA4WBGc37sB9TDSVmjiykySwkGSpYcZI
	Dz8wWNIDrBdog6rkqdTm2Z8KH1riCR9jz6+ssSVOHgAL+xozEUgGZamb3DCx9uv95jDinQ2a9o1
	7xhWsupKigsuxNWAdtUEZz0DpwRKUeJIzskHq2Z9UWwGdAfrHs8xCK4eyoC0JhrXzrFA3qTCAzt
	zQOM1yRysdiVZmSjPb2U6FS7JizbABEfmoEH1hmWepI0KVDN8V7jzehGUsG5lGiRMRUva68h041
	mgF5wnoUuK/oTZQVHv40L1EvjocbQwhoBG8uWDwaHkL2M9uWFBMnj6PJUNyhm9U58swmmngs/pn
	uq6vicvdulANZKfGVNIwJZ+EyCl4T/UeDEHumMQaZBR2D5ENT+i7cg/e+PIJ3ZIZqJCMTUCvGWv
	ObEUj92EopENdvwm9lBx7hpvhDWELCID9oZVptAN7UQt9Na8oCCjZPy9O7lD+HCxYB0emdJejvl
	w==
X-Received: by 2002:a17:90b:1e01:b0:35d:a31e:6b04 with SMTP id 98e67ed59e1d1-3612f26db5fmr2823276a91.3.1776325286746;
        Thu, 16 Apr 2026 00:41:26 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:63b6:f9e5:485d:ef04])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36132cfc6cdsm1654717a91.13.2026.04.16.00.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 00:41:26 -0700 (PDT)
Date: Thu, 16 Apr 2026 16:41:22 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: ryncsn@gmail.com, baohua@kernel.org, minchan@kernel.org, 
	senozhatsky@chromium.org, akpm@linux-foundation.org, linux-mm@kvack.org, axboe@kernel.dk, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kasong@tencent.com, 
	chrisl@kernel.org, justinjiang@vivo.com, liulei.rjpt@vivo.com
Subject: Re: [RFC PATCH] zram: support asynchronous GC for lazy slot freeing
Message-ID: <aeCRnAhfg3fNi6Ey@google.com>
References: <adt3Q_SRToF6fb3W@KASONG-MC4>
 <20260414054930.225853-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414054930.225853-1-xueyuan.chen21@gmail.com>
X-Rspamd-Queue-Id: 0603A140002
X-Rspamd-Server: rspam07
X-Stat-Signature: 5wfhdyxt68nccwu5fm1whdqkosrg36b7
X-Rspam-User: 
X-HE-Tag: 1776325287-751251
X-HE-Meta: U2FsdGVkX18DwqiyCnzP2xNk23NJswEnRPAb/9iP0WFYHAJ+RGdsM9YmZ2vBLxhXFbQYH208rhdZbkkUwh1EZS7QmlxglPMaM2TBB1kZm9PYDQniCoGPwAZG7YSrOquvPMi2yMIhs1n2IsFbWhgP7gzbZTuhZgccpB90ngr246TNui0B6GOLnC4r1pzLqIPCo9ojfJ6jObLC1+93Z/gEbGut/AjY9i4JsEKKDTocCzE7yn6w3w/WdA5PnqGave9CcDiWhfKI3T/hv+BTt9psXFSqJI+4pmF5VHh/GzoQwyUpZxL3x1nIXar6PGBUzuYRglkz54DPy4ySR3MjwfP1cMfOfiUi3ShVhh3VBn2aUBoyyk6uLFEr7chqfE8qbvNhhapRzYOZKZQKoeanmgDNLS+QK591UAVVW2kOKDnJZ6flW1Of2x6jbzKCO3r4R5gCAHuhOREL7nLNFtDq0+jqudOPtFhiOfPb3JTFqJxWFt0ZdzZ1yoTzoBO8daaPDa+UComrMpTxeOuyt8z3rrWKInJ9JgfugQf/zlUNjxun9DCMlaCZgGyL1WHFKJvBzt/VShZOiWdhDv36OfTIR1yb/KPJnNr8AO5MVJF/X63v+jBrokrSwzL8fWHH5bzi0uU4tfxLJhlgWuOKftw+d055e3I2sKbPS47lEcVnG86HSyfW9qBdb9sgzaiBc/D5oETxj5sTFqE1wqxaZnTLoug7tzeKWefrFttXkS39mYF4C2oYZfkA7eg/tWnPi/RrjFWrMJdNuEfhCxJYAAQQzjF9MtZ3MzahASvR96XhgxCZFEJMTYRcaEIgWnTBLDqrLONUH4y+Pqz0ZUj8hbVxS2hyNSlGNxTWnu1o+K/Lb3x+0XeAgOhmuJleXWJUIWMECRuCOuRt1CnM4daJuBszuEHYz87ELKOLnsHNHVmi+HJH2RX1UsctUNKeadC6D670VX1YyFrjcGYr8530R9ZG3Bm
 TN3fj9sN
 bgdI68kBQSWGDHEBE84hvjiN8g2wB3OYaandQSYOmOOK9mAJDhgDUKZ4ffSNhe0lrStlKeSAvxLFG98LyV9U/NJ2IcKrdxN1xSQq1SjOrgrgMUCK/MoCzjOzhGrpgGu6h2hjiVOeTdwHl1zY8dqG96UmSH1LcBZkjWKqmuetMvIz78z4RcxRk95hcrXdFcEIL8ZBWzAA9421VuafJz5He6Y2NinmH/HLC+bjHz/V1oGAW9vVR5ug750kLZXixOfI/KcUhq7uNHP9L9f0XkYGtmuiM8F8f1iyslX5P2egxe6NzDwaJTHUo0VYigfQiCjiyxaVnn7+E35oxdc4LlSmbcwvTDPnEU9tp1dE8QW6CdFzRJg447iHTGQiYRNyc0wpjuzXLZuJyJKxUvTLWW64IUq3bU3ozBdcjK8o923jJNw3jawCKyZw82Msitg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/04/14 13:49), Xueyuan Chen wrote:
> On Sun, Apr 12, 2026 at 07:48:48PM +0800, Kairui Song wrote:
> [...]
> >What is making this slot_free so costly? zs_free?
> 
> Yes, I've captured some perf data on RK3588 cpu2: 
> 
>   -    3.79%     0.42%  zram  [zram]  [k] slot_free
>      - 89.04% slot_free
>         - 65.40% zs_free
>            + 77.29% free_zspage
>            + 21.75% kmem_cache_free
>              0.68% __kern_my_cpu_offset
>         + 13.19% _raw_spin_unlock
>         + 4.86% _raw_read_unlock
>           4.75% obj_free
>         + 4.72% _raw_read_lock
>           3.64% fix_fullness_group
>         + 2.02% _raw_spin_lock
>         + 1.31% kmem_cache_free
> 
> It's clear that zs_free is the primary hotspot, accounting for ~65.40%
> of the total slot_free cycles. Beyond that, have some read and spin lock
> in slot_free.

Just a random thought, if zs_free() is costly then it likely also affects
zswap, which makes me wonder if doing something on the zsmalloc side is a
"batter" way forward.

