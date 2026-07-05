Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9B6DC43602
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 16:01:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A22856B009E; Sun,  5 Jul 2026 12:01:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D3006B00A9; Sun,  5 Jul 2026 12:01:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E91C6B00AA; Sun,  5 Jul 2026 12:01:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 613396B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 12:01:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C19B31664A9
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:54 +0000 (UTC)
X-FDA: 84955188948.20.A05356B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3372CC0005
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cr5MWrhd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783267313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QDJgGdtoA/IbgG+7ciI0YVsTZBt0XSBAZ9d0cV22mDE=;
	b=eGvI2CNoMsN2jM/w78Tbrqe7SqYd9p53rBQn2lC+sf0wq2FkGsnW0iQw+NKJvlwk7MwRCF
	2f7pQ2zjKK4FmQTeap5u+122g0qaP9G2tWcgXrUX8AbKH0EYCF4v3c0hJ0Fy1+A4XLDb6c
	JrPlNlO5mLSEmYeBrpXmR1y+fm5pFSA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cr5MWrhd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783267313;
	b=hpXvrDPBH8+W9sbhATXvqzIRIwSALlZ8ADuhbH+wLMyRCB2bsaRTN376frPvYdxVXrS6ml
	rHmw/d0pTo9waorZIKyLWlEsWMtluT/G0IB01azzapXMwjBvEOJiPc02ooy6kIUGfieS0f
	95H64q5U4U3th96cZ/n0QF93dYcGm0I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C090961383;
	Sun,  5 Jul 2026 16:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D6C1F00A3D;
	Sun,  5 Jul 2026 16:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783267312;
	bh=QDJgGdtoA/IbgG+7ciI0YVsTZBt0XSBAZ9d0cV22mDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cr5MWrhdnyXSLPE6O3xug2SSK25OdsOyAMPxKtabIf/4+fMq0rM8V2Zh1U6LPbVx3
	 s4SpewekBWzCFfDCmijodtPA/MZ8F3BAIhmho4r4hZ8ISsSUOjbNGTJWjdpZptPiXY
	 ucSgFjMZuxbcvqPo+TjS1l4GvKjoDtult5+6hkjvzqgyjfFxcpJtpr6ZtScjCL+6l6
	 757vNMjtQ961oS39rkE2orxwL2fG5dF2+oLr0M5zosMESXgz0EU4klFB0LenYKrNMU
	 tW5ttm/UWDJly4eQ+MRA/2AOf7Cogc0ooKgmeRbQUu2JIXxHsxl5kxSeOYvPmB0/eL
	 4uougHrZKpelA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 01/11] mm/damon/core: stop ctxs in damon_start() before returning an error
Date: Sun,  5 Jul 2026 09:01:28 -0700
Message-ID: <20260705160142.97308-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705160142.97308-1-sj@kernel.org>
References: <20260705160142.97308-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s7mm367zargd1ex9twkswiuowbaiks7d
X-Rspamd-Queue-Id: 3372CC0005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783267313-175338
X-HE-Meta: U2FsdGVkX1/IG+TkSEsNwMq6H4r9/FgzP6+95w/wHoLgQeu5rs3xJxj+umXX9jzb5x4fawzvC/llONBVbx26sFDrDuTgbDCu5YQuDifpE7UQWJ0MFzXpF9ZNImC0Mk9KPfapVlrQuG7l0Aa3kCNSDQyP/8obZzVyTZp2grJnWtYw/Yz80pRu2Y5gBcV0UM/H8JhEnFdCokGPEv/LsFvEydhA8JDlVqr7W5CuTt7+3MGO77Kww55jX2IGq316RtUFH08F0cjH3f2qAYmsu+k3YmkFPCtBf+cjwCe3THM2geN5gocTUXajxC3bkw/DPpcKq86n4fRnm/2PsDKd9rrpCuUXfgn0es7iQIfNGlcjfXe8pm8YnTXdvWmHEH1Jt8DN21iKkZWQ3jR/kxLsyNyUSy4CFn4K3KBpoXXgq3gqKqKKYMjA+OyP15o+QcRiTwvK5MnjozFvVwpV8m11O+yhW2QQjdfkSYXTZOY6umco4UjOsJJKFXzfBDTuJQ8M3o4c7xj2s0xLKlQYqKDWgscWE0cYriWSX5Ac/Iv7IAcG1YHiUP0T6MthJByLRciG9JzDRlvPVTVyPD6bk5WpL/A9Htu3p8YDGDYlNfQiRwiDYnafpF4aU5lzGO6SEfq3tIOCSD4rFU0yWRbTcGoqFvm3sPCK3ikWJSNt2ZyOTwGIrTOj0wghTkxrJUGMYxazyCXY96Z6ievIcy6oV4UBiDnbWvTWht9mqTCq6FTEos77e9XmZZ7QiSWM1q3BsZrs9JL0EGh+Gndutt1zoW1LVF6aGYpOTZ7otKmaIOeU4e+6aZWddX8pnrmjQ1DMbq+7ZN97e5ZZKogTkLpH/1OAFTYhBVS/wa9lfZpuaOLO4UJENJgmfJ6bJQhrgX6iCdf/vGAqGDB/IoHNWZKV35z10zpYPGd9ZZGMyCV5y46+Bmlu+FUkU6G+RMCkQ9pf9gg6yXiIqc0jcXittlgayM4fV0V
 JFc1YgFX
 I/e2KGs1GX2qY+foMdFzGBPvwOJrxzbxzJCaLSwY2FylMVSEjgBBVg/S4qZWCYJSSnf0Qua0Kda1MzG5ggdLhQM5uuR122U5qgvXLgpQUZmiZAflQTxfIXQ+hh5y/AklTI8R0QhRqQPs0bRW+rIc+c9zFEivsCGHMj2JenDEUsuMydj+6IWBnKsjFBATbYWlR4ersNFcKvqlXiRwofL8sdz5EFFr7Y8gRONCzGU8ZYd18O9zxTzZb126NyItgE5VotfdeC0QgyVnn7mTwsP15NPGd4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When multiple contexts are passed to damon_start(), the function starts
the contexts one by one.  If any of the operations fails, it immediately
returns an error.  Contexts that successfully started before the failure
keep running.  The caller should catch this and stop the contexts.  It
is complicated and easy to make mistakes.  Stop all contexts in
damon_start() under the failures.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3c5a46e1c079a..d89a7f2faf350 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1917,6 +1917,9 @@ int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive)
 		running_exclusive_ctxs = true;
 	mutex_unlock(&damon_lock);
 
+	if (i != nr_ctxs)
+		damon_stop(ctxs, i);
+
 	return err;
 }
 
-- 
2.47.3

