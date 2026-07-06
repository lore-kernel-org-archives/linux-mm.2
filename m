Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18C27C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A37326B00DA; Mon,  6 Jul 2026 10:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A107E6B00D5; Mon,  6 Jul 2026 10:06:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D7E96B00DA; Mon,  6 Jul 2026 10:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 543586B00D5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:06:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CECDA1A0351
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:43 +0000 (UTC)
X-FDA: 84958527486.01.7C9EBC4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3AFF3140005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ekfWfAui;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783346802;
	b=Sp7MAPwly8Kcf7UJWSbQG91OMi4gja3k33psoXAW4oHtsA4elSm4nRvxoIxjKe0epb+dH1
	Q/QZij1PganVy6/lpLJe49GmlQGW+slS1bOHmQ1W4Q74O3qWladrbY6f0N6lFvx9eAYB6w
	qkZDyzs97q7WFnhbTKgRzzN5NW5ugPw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ekfWfAui;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783346802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LS4CO1+OYp8+pSPAS3NbVTVyYCl94ZecPiNEYxC3hmA=;
	b=tj0zmji+tpj4GRJr2ta4AK9fU+e6zt7ym+eIqMl45x9CNBsk0GcLug9HLeVGr2B6xrnx0R
	gqOJcuksSEYU72xGPSF8aDn9gVDWIMcHg9MTU0NEe/tZjuB8G6Wyl4tV9KuPWd/FriTd52
	QxnYJGX36eL2orV7USmeZeno9ZP0B3g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3479943B46;
	Mon,  6 Jul 2026 14:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83FB1F00AC4;
	Mon,  6 Jul 2026 14:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783346801;
	bh=LS4CO1+OYp8+pSPAS3NbVTVyYCl94ZecPiNEYxC3hmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ekfWfAuitYuwonapsS/11mTl8oLxfiZ2cBK1kLPuSJpYed67fF5WpGEiA8qCLTeHV
	 pw2EgFq2BiN8RqJZ/pLrwxVU78kOUO7OR8JKvNbquHZwx5yosKyYIOHWFX31OuRytp
	 uLDPB5rGRFTp3vjUT3soJOBDfvJbcUgwbb/Qq7sOl9dZ1hRau47Y1PdPdPEKnhJ0VK
	 Spja7poO/Y/hm7JfDLQjzy5U582amuse6yO39Ujs0n1aMst3gKbmUp4B4kaWMccWNZ
	 PeDR1rK/7cDV7X51YD+Tu7sFYtHD9UDvFiqO5yoIHlbt5VBqSFTqVthvnno33EV/qK
	 76ODUHFS42ZbA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 08/11] samples/damon/mtier: stop all contexts with single damon_stop() call
Date: Mon,  6 Jul 2026 07:06:23 -0700
Message-ID: <20260706140628.87414-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706140628.87414-1-sj@kernel.org>
References: <20260706140628.87414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3AFF3140005
X-Stat-Signature: rq5f4ezz73oi3zhmegxjpxr9dbcxjjwj
X-HE-Tag: 1783346802-159274
X-HE-Meta: U2FsdGVkX1+lIqBxDFERJpt3rt9PVvdsRADlnnBsUq7e2RuA8grI/0fxQGPSGpxFpiVyVCIbrnOO1MslhJ+QtCIY3aA8VDtl3VN6Qw9u0HvR1uHmo+lC9qagiZvTQrptbF345dmJ2UDLNaT6F8c4ipAvh0husbwd57tjihbCYADbM0AZdHIISem8pzy8nXATOMbruQljsdjGUvT3Xk+B3I7JF99KIkGWOlGxG8PW2zEqBXFFqPcmucSRLvIyqkR5ZtMHcOTlj9P/CJKv1QfRIo1ZeTpa80iE3rUcaVJAhgAMEb51vguRW0qgIcv4U5AxNAW3+Y912zDNGkxs1ae+F0s/CEUNevy45onSeloMtzUiLNUJsyi3urDEFZDB2Gcp1xsiPkH/Ml0KP8ITm2DqyKgysfgdnVHxXHoU9ISdIWZCft5BJFRIvv5jNgafCebejyDzyM/qTGfKHDez1WIw9GfDHWPQ2H1C1fLIbpqLBAVGevkgj4SawxLNwzwuIWDNjr7smCmg19BJBGrlqqdHvt68YzkjvPBl+fHLrRGdVzymWT3p2nbifJ6unWRKg+bOPvTWw/htWwv3EOAXrwMSt/Eegbtxen3iWzHcY/TOJscNOlbKp2moKVH81tBrEmkS+AHfVtoTFINs/+x30GZAbbwvSmgvNrouVy4JKp+x974i0UTo2qpCXzMdxWtsKASt6vly5AlNxa6AFX+8lYrYvlXOEclu+8ZOL9gWK5PyBLvScWhJgLGS+iry11gfBpD2OS225ONIHkl909bsUu4iy+huAGRlB9PYdIvHRU7RixRaGC42mbwnKQGV99Ud1dGO25of2YNLW5XdF6sviA5bA1e6rAjR5p3S8rXp6KK/edJcK+NpyKBLcljZLNVsQIYfQm6oG0FZIohC6BLKwgkljzLts3ZU/HFafR50bHEVshj+A1UajLEo37wkDlgQrg16OlzWpKzTNRkmd9qNyC+
 9kKIpspo
 ttJ4r49OyrsLKgmYnVgamydBpAjmRjMVFf2hvoxSGLn+UCNkikzhSbbKCiF2DnqiKEP+BsgtkBfV0InEJtY+xjcMvjkIITqS6GOUrE586yW/taxs76IWPNYzSJhPLoPkQaXXlC7vqIidK5JOoxl1vQlLv/pzREMgTcoOcC7Mexj+dtJa1RgunmEeC/EEA3yXnU3xT90jwssAnZUZsOhoxGp73fCBgPHgbGVkAcrYOVoa2Eg7N6z5oTUgMHM9Op3FkdfRSP6F+THiBNKMTMGli/+ScJ1mRHG/wlXPW/lyYzt56nmg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_stop() was theoretically able to return failure while keeping the
second context for mtier running.  mtier stops its contexts one by one
with two damon_stop() call for the reason.  damon_stop() is refactored
to always successfully stop all requested DAMON contexts.  The two calls
are unnecessary.  Use only single damon_stop() call for all contexts.

Signed-off-by: SJ Park <sj@kernel.org>
---
 samples/damon/mtier.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index 90881e8bd441f..ac9c24b92ead8 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -200,8 +200,7 @@ static int damon_sample_mtier_start(void)
 
 static void damon_sample_mtier_stop(void)
 {
-	damon_stop(ctxs, 1);
-	damon_stop(&ctxs[1], 1);
+	damon_stop(ctxs, 2);
 	damon_destroy_ctx(ctxs[0]);
 	damon_destroy_ctx(ctxs[1]);
 }
-- 
2.47.3

