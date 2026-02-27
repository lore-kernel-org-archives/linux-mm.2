Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2CCBFD530E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 08:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8604D6B008A; Fri, 27 Feb 2026 03:21:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FE7D6B008C; Fri, 27 Feb 2026 03:21:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60FB76B0092; Fri, 27 Feb 2026 03:21:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F76C6B008A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 03:21:53 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E14201C41E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:21:52 +0000 (UTC)
X-FDA: 84489543264.20.4656DB6
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id 172FC160006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:21:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ld9iU7cX;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772180511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kstHbIwiV9VI/ZIuMCRHTYCFnv0sGQ9axw2LL0ura2M=;
	b=mqH9KbEQrUY+yO+8FLwQ/aeHkx1YHyoBXp45Y7yKTOUHvvl5Jcl9gkLHopRs7PZwnueAc4
	3cYvGOWkgPeECjceTBVYNrWk+QGm27GnhXH8l7PVppjL12jkGf3njzWmhm6+EHl7u83mGR
	Phni1SkpB+0kxJbwDGrGN/y3A9a0wKY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ld9iU7cX;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772180511; a=rsa-sha256;
	cv=none;
	b=abI+erKx4s8Npy74hQcN07+RoKe1A94KyhFmC/Oo3eY7WFXP5HAxHF0hQtnUGof/z5JgKt
	BRp8z7v0J00TjWCG0r6x00x5VL8FWfxviYLYMLv+l5zA2nT/efDKycUHVsgplkzYxpMKa4
	wTBrq4pmh9aasJnaiFIl3FBhuZFVv/M=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2aaecf9c325so11619995ad.1
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1772180510; x=1772785310; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kstHbIwiV9VI/ZIuMCRHTYCFnv0sGQ9axw2LL0ura2M=;
        b=ld9iU7cXxOMeIHkeoO0IOyraUEDFTc0VWhpJcfBrY8VxuoxJDs2RY725sfmRS6acL6
         mdTv5tjAW9NVXU41lTta0AVjxH8Ql2RSB7FIsRftii7vVczm2Kzau0FT3iz0Bfc73gBM
         vzlcDg1xu2BfuhGuGlOemDCE5H1Zm6sQte1EM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772180510; x=1772785310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kstHbIwiV9VI/ZIuMCRHTYCFnv0sGQ9axw2LL0ura2M=;
        b=hvysqDNkyfTSQFEgNmqKUZ/EaHF7EyKyI+iz+6e/CubNW7wuh0PDdFB+jhA+nnk/Mr
         lpqQIVh0ESwonsmPKTElAXRhEKf2d9u5SAatS+enKriZbGacc/Oddv68d9FVzthscuC4
         q3FirXJLTIVHv/rM0wFUXBHaSrCYLVipQsmmSe3tdDED5q+PE37OHpAo9nSksXKrczaK
         ASKHSCjjaSKFsFmxHdPAEEeaEacuJERKrzuvsoC/xKYJfxlvyS5SGkeJ2mhAGWCBQnon
         pT66j96R52I1iY9ctgSXJ/BgQkw/Ji8uMOBJGmiLXit18PFKIRrX31/aP4QeGo/9eNjx
         xZ9g==
X-Forwarded-Encrypted: i=1; AJvYcCVI9BoweuCWb6IUjTBrggeVEgyZd37/7dka11potO5UvhCuB7Cdk6AnHALK4qGsOfLBYGsRFkumfg==@kvack.org
X-Gm-Message-State: AOJu0YwbNfscxdWexVsoR7SxDm51ipD9cw+BIlasXu8pe/zThphCM2mv
	SohMo03neMYZ+DeImbYrRLjAcGTbNKxjUkJWbNsRr8EzX7byJ8xfUMTclgB9TRqTrQ==
X-Gm-Gg: ATEYQzwXqYYtqeA+ittzIQGSPJfHqoKvEM2p/XstiaVxrpuVlttzFUQ5+/fYf6enela
	ThUtNtD28mLHe8vOM3BoLfw7BrGSw07lLaDih7nCtrWGRGKMsC/VtZaSAbEOD4ph253yjiJXFnZ
	mFcbd1caVjk2ixgqs4xBBjj5ievQaKS6Lbrw0MCgFJrGCfMaoflYNvSU4kmFm29Z7v4FQ9j/TmT
	AwgAnmZnJZfbFNN6yQdAj3ovHm8oFMOYe4bNrBxAu6TbmnPMr3ynLYxlkwtphJ+XHIp796P6abL
	MvCO4cYzNsNe7lSHj8ObTOCUPpvG7cRXedoGKolMaIARIeZGpthrFfQ69wfv1hFxEfqK2iVPBFg
	tHFrMzoQUx0BpHnrf7x2WKmsy+hprCpTzUbdJWw2GwCuSrZe6yoNCunuwIcVOB5l1bYbSqpN+mf
	UyvafyF4anEjlMjEdGeQ8HVuvK3HWlwvg0q9roIlQtwCWsUDnWUg4gmHh8Mf+SsaI1giFAvb3U3
	sffmZgvwt7iag==
X-Received: by 2002:a17:903:40c9:b0:2aa:d320:e965 with SMTP id d9443c01a7336-2ae2bad7ab0mr20498815ad.21.1772180510059;
        Fri, 27 Feb 2026 00:21:50 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:280f:e47e:6718:7698])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb69fa4fsm48796025ad.45.2026.02.27.00.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 00:21:49 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Brian Geffon <bgeffon@google.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 3/5] zram: recompression priority param should override algo
Date: Fri, 27 Feb 2026 17:21:09 +0900
Message-ID: <831636c74ca6d72317de02d96585cc6833d082e6.1772180459.git.senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <8a5d53d19a8dbd51d7d81d153676895163e0735e.1772180459.git.senozhatsky@chromium.org>
References: <8a5d53d19a8dbd51d7d81d153676895163e0735e.1772180459.git.senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 172FC160006
X-Stat-Signature: 4yh93imfnan3ddyrrqqbaxf1c41p5wsy
X-Rspam-User: 
X-HE-Tag: 1772180510-716323
X-HE-Meta: U2FsdGVkX19gXWAaiS+mmy5CLOSFCvdMNdEunnBMXJgTJVxYYpmJx23zKR0GlUO+jlCLhcOEXAKBoPrVNCQOoev+xnTntOSZA1Ua8QqgrqPxAeL0f2hYpLJIeW8IkRadPfjUxXacYhJ6+yfL9SJ9C1wcyody/yX+agcg+KhYDdYV6IV4oO83juFjoTUxc+iiCjKkVu1dNAHrkiMIFh1Z2PJYaUULCU/ayoIbyHksawYFon1EBz4bKTPemdhzg2MmIyu+i6QSmR407oHRUNRUxrOvXaKugIagEM0cuPR1BQAkPA5q19mmPDr2g/j4vNhcWwFCT5by8it1bjCVq/PjcMMskMYn+98MfmlxJ0wt6PecqXmOn4P2AFB3odaFZSx8CX7nhISR8JKZPeGApgynKC4L1uzumtDdsHUYinDfa7gOmOHQLN7cIugjar9L9zBMCEx86IukNAycd+WiOdxOV1ukeHTeaoVFWsmwz1pcakge6bemrY9nnTOV5QRWc6iVKn8R5klxpMAhgalusBsLDVf9aCpyKjoEvrgs7FHXtxMOlWAz6kLe6PBGFR17ne24Z+qtU5Iy1LG714zo45ftcyauOY8cf72gE4Fv+1U0da/qDUhxhKVjkaSCXmRNU0I85cHuH1ej2qmro2Qs/5kJekdYSSKWn4imxi1p1b4Niu0IFlWgiiqhFmMHWihJicjiGR3vuS7aHtW+1BFjSp9/0oAfvfovCsuS/NgfgoX1Ccw1CrXqSoUQKtGyKRCGJsjtz8B7YpIPUe3eRouCgoGB5Q6RpvNe9mvehgTr37IXsBrPEkxnanp1dIIf69kAoRIlEPzHTqDj3JbKHEvYMq0qU+lb4zSp3Gl7B53ko1wSrWbF42pacnslF7rehK6TmEm+ruyy8KRzl3/wam5r9JZuWQ6bHFmMPExWRj+8Bv2xgCeJf7yO9NLRUehAPBmcZRyqwJZDRXiarlOK3zLVS/X
 Nk7bch76
 nI9dNFqB/lSfMrj2mBV8TAxnUSJIQZ9useLDefRIpEIXG1TJVjbwpk1lPPsdPwFZfHxdJclUS2Bv8fD6Mt97qv6D0Q9kI1J2T47r/Ylo/l1SZNC1t0NgRw1g9y6Q4zEkfXQfNxjIz02np0DRxbjes+3I7+1M5k+bx+oPv6RSRhDqQDoAqIAUhCDvFEY605pI8QflWcfu9M9drvU9+vAX/XnCLkhheI9a9Fdhtjla2496GBGesDOBjs7qT5pAyKAP5yDRC8KHj3q9M/qAOAlNpp20A1PllyKYa9LNde7Mb2/ig+iv8F+aTb2Xl4TEKm5M64YwRSimwvtx/gM0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Recompression algorithm lookup by name is ambiguous and
can lead to unexpected results.  The problem is that
the system can configure the same algorithm but with
different parameters (compression level, C/D-dicts, etc.)
multiple times:

    [zstd clevel=3] [zstd clevel=8 dict=/etc/dict]

making it impossible to distinguish compressors by name.
It is advised to always use "priority".  Additionally,
override "algo" with "priority", when both params are
provided.

Suggested-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 6ca5a76c3865..118b0b277e37 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2594,6 +2594,16 @@ static ssize_t recompress_store(struct device *dev,
 			if (ret)
 				return ret;
 
+			/*
+			 * "priority" overrides "algo".
+			 *
+			 * We can have several algorithms configured with
+			 * different params (compression/acceleration level,
+			 * C/D-dict, etc.) but under the same name.
+			 *
+			 * "algorithm" name lookup is ambiguous.
+			 */
+			algo = NULL;
 			prio_max = min(prio + 1, ZRAM_MAX_COMPS);
 			continue;
 		}
-- 
2.53.0.473.g4a7958ca14-goog


