Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07AF9CA1002
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 05:25:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B64F36B0008; Sat,  6 Sep 2025 01:25:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15916B000C; Sat,  6 Sep 2025 01:25:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A04596B000D; Sat,  6 Sep 2025 01:25:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 910616B0008
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 01:25:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 330D0C02D7
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 05:25:08 +0000 (UTC)
X-FDA: 83857686696.24.F93D3DD
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id 79574140002
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 05:25:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ghnYVbdU;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757136306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZGo+T7amOY1lETbh1kJa9AjOv0PBB9f7/HBJ+WiqwM=;
	b=8jJzRMJIfnnk6r0OSXWSg9tLYccwArbI4MeMkSXy6jBrKva0FUNUdeH+/AFrq/puoqSq58
	1QiFOpJSP2Pw2rJP9jB7OAFZCnA92Vo85Dq1F+qiEfhLqzxwSahbDUUuUkt5byL7SOC46w
	BtySyUz12cYfdN8g0zGHvF1uhRLUkIY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757136306; a=rsa-sha256;
	cv=none;
	b=hzxS44Hzo9C9woIlcdkDJVyEXRp1tF5DEFIGD2O1ICrgRcLtzs74eb38Hdq2spo3frzRa9
	HQqBdRbNnQ7YW6h3A2+sfiqRj53bd2OMqk7WqTjKyXr2yhAYsCVr1bXJFnQsYBB+S04ORb
	r66PtM577Ufd39OUgJgUsXynoTYeFnU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ghnYVbdU;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b4c53892a56so2483319a12.2
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 22:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1757136305; x=1757741105; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZZGo+T7amOY1lETbh1kJa9AjOv0PBB9f7/HBJ+WiqwM=;
        b=ghnYVbdUROJMAFKUdYMNgVQm3bD5ogtd1mSTJRzpWj32eMwFAbe1VHqX+MoU+HpgVW
         dxRx1hD05VWt120RydRfH2uvtr7YMfqOrahiJlQmO1ElPQaU1ro6fXyfAlBVZpsUD3+W
         PoLBYGb66mrxGdbPDGjaoweGRaltGrL3iTkds=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757136305; x=1757741105;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZZGo+T7amOY1lETbh1kJa9AjOv0PBB9f7/HBJ+WiqwM=;
        b=DbdrX1ZiSYqHKywj4TtYWadMkqa9cMFlWua1puBdxm8/kuo/VIJvmuHS0DToZ24PWm
         5f8iFbYAUtMWP+5k8ETQyiTtV3Bs3HytZrT7H2iq/boTOa+9/CouK6BHf9VEBESTM9pd
         haDaz2RM7vuOrrlOKcAOfF1fj4NTEZyJHRbTtYnkBaB25XwWoc8fScsy2xiLGNz6Jqd0
         1JHNiivqLf32FpS/abyVKT1d4Ri8Iu2rc622zctqWwy/4PYtthwm0ld39yHttcIFLADE
         QEn21JWvyr1ETWo59DcXVl6fv2/4d4LKZYiJT9i6ueAIwGWxmjW4GwL/6WOpM/kXmPkz
         QZhw==
X-Forwarded-Encrypted: i=1; AJvYcCU40FutdWe3i0cE2GYmojyXkpgBlNYLQ7gDwYgMzKgLUFI0Xa7/jRghVgra98RZXOWu0vXojcuyQQ==@kvack.org
X-Gm-Message-State: AOJu0Yx8LYEx9yC79u/CVAwBH+R2nfScNi0Yb1ZqiuJsXHZmlGm1hzEb
	8YCgnIG1zzEw+KpAb9GfPKrorv1CD0FDYTtPo+nZxVtgR18xLZKBbJihAVCppUUrpg==
X-Gm-Gg: ASbGnctbtMAoi2BD8yj6d5KWzDngBCJuhLXWU7EWi80MvUIdFAxg/iGQnUOvmlOuHcH
	i17RR/2+cTn+ozvehRVYlVCtosVAlrsoJTJtAzLlCJfyvz4x1KpFSccAI9dzmIfxFpAfuvtGoOC
	9CYGLnaUJN6B/k0nWhdBnyI04L9zGB3ftItQdhJt8D503MS92GjBl7bi9ZnMb2rCe9vEbrYu0h6
	FDWyQXG+JeEvQmiMHUxbw5qJVqrggTV5uNHsV40G3pEuT3MgQl3YcV8OMi0ozJsUAx9DqrYW9Mv
	Hm1sa/br37cG7PyL+n5waInnOmxQl+4UnMCpScclmGF5qD+JRGQQaVQmZCDamRNnih8zibRVcw5
	zqINjc/VZz0vj4FAD5vyodMGEPOLcauOT7ZQ=
X-Google-Smtp-Source: AGHT+IEoDHKsfNZjYJYHiPgDcwHYSGs1lR2jb/L8ZEYHKch3JPG8uNbquge4NeIL4yWvY+k0jKXftA==
X-Received: by 2002:a17:902:da92:b0:24c:cc7c:daa7 with SMTP id d9443c01a7336-251736dedf9mr17725615ad.38.1757136305265;
        Fri, 05 Sep 2025 22:25:05 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:788:b55a:785c:1e68])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24c9e39094dsm82041125ad.84.2025.09.05.22.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 22:25:04 -0700 (PDT)
Date: Sat, 6 Sep 2025 14:25:00 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Vitaly Wool <vitaly.wool@konsulko.se>, 
	Vlastimil Babka <vbabka@suse.cz>, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Hellwig <hch@infradead.org>, Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH 0/3] mm: remove zpool
Message-ID: <dh74mr7bjtpzk7frviv6iqqno2u2b27p7jiagp2dtnsz2wrfhr@wlb5vqg4majs>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250904093325.2768507-1-vitaly.wool@konsulko.se>
 <7b1ca42d-1b89-44f4-bffb-e6b09f86fdc5@suse.cz>
 <1d42c513-cc83-4f08-a10c-cbd6206070f4@konsulko.se>
 <girukcvvzgbtkxt4aftfz3lw3glvf2qsof4mx6wf5perolck5n@vaxlrtaeuzw7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <girukcvvzgbtkxt4aftfz3lw3glvf2qsof4mx6wf5perolck5n@vaxlrtaeuzw7>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 79574140002
X-Stat-Signature: q7w6nnckhou9uyrtf5et8eb5iizm6xhb
X-Rspam-User: 
X-HE-Tag: 1757136306-734807
X-HE-Meta: U2FsdGVkX19L1hmv4bTsjuC1hLeH0bDfLATDmvaPw3duDdGVTixSGKAf18v07I8aMORrah20gRJ0C05eflv7Q2ehMK7zHfdVoct3QqX7r8FdTmXQBu5TUdz21eSqILce/ChxffYxUlNCCm0/37oQZYWv+It3ICuF1ZxSihu8fMh4ZiHHHSf2wtOHwyubMRdX039HMp3CbTOA8k3pVjjWcEHtm5i6ZIEJBElG3l/RGnPwG2lzn1p7z8INDg3W5KUxHXaLiLHXPsaJuxbZPevt22J5YHBtQe8FYXGHjxnaVPZEzfibpoXm5Uaz8BXJXmOIyULvxLoJL2+siPLzIwe7sMQU3RO0sRyYbk7eRdCWTvCGEgxI3fBZ2vZcFbq4ynarEfEoDBTNOJOa9klcRBk4kU3MYnOs813JoYsVAXpxN2Vm/ta1CFUcE/hITMGzLNxGpOGCvR8j38MQopQWOV5Y5RCmuTOdUG1QMpA5jhD8lyPnoN/EBvXQjRxTAeMGJZac3BBQSTZbwtpfI0MuSRI8E7xTm6cTtZldw7v0F7iZPwUZ6SrlVkk088xA3APc3VteMcG9KwexjJo9DgBJ4tKq4XpF9Z85I6NVuAqeO+EEj14rb3J/GqTNtAoDzGTYd3mqKgiMDuE4f2S9ekpOdeMVOImeNelujSORsj8inRhEAAkKrF23u8AKpfM1CyE2Jy2/liwQ43RstDbE4B1QVfrVEUz1/Lisq+Y+kIUjdlGhA0WD+dsUS+4hCxLGfeQMA8NdF7RsZk09TuqEwg9sKGrlTBNzk6RCFzOHLuK/7oWXTkLkOQS3+/eNTmKFCl+OPNr0R9LnqNSoFRGSCiEDp91EYDeFLmx0qUIqutGB8ubDcVZw5FR0g4mrxWnzZ4HKOr5FuTzeEoqIewrBMaAKLaMz8Xlk0kHVp4tks8aqvOPcG3wymI3FXd+FXTXH6+KZfqkPiSUX1qMKK6ciAKLM5KB
 jS0q+4XM
 H7T6JoH0+BGQijYY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/09/05 19:57), Yosry Ahmed wrote:
> I think Android uses zram+zsmalloc with 16K pages. Perhaps Sergey could
> confirm.

I'm not working on android directly,

I can confirm that android uses zram+zsmalloc.  As of 16K pages, there
was a way to toggle 16k pages on android (via system settings), I don't
know if this is the default now.

