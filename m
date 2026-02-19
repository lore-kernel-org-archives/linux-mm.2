Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65C44E9A04D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 02:04:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 766946B008A; Wed, 18 Feb 2026 21:04:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EFFE6B008C; Wed, 18 Feb 2026 21:04:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C8016B0092; Wed, 18 Feb 2026 21:04:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 440586B008A
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 21:04:15 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D02B11B4C51
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:04:14 +0000 (UTC)
X-FDA: 84459561228.07.9E46B2A
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0DB6540006
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:04:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lxbYi5gl;
	spf=pass (imf12.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.161.44 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771466653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nHBv8qiAqn9zn5/9Lglf+QJsgs0ZODCHP/HKhTXpHe4=;
	b=tp7ow7C6S156B4uoSGkdcFU1vL5LXH/Bum8fQwuHLqY//mV0HtbmAkW5bKVj50/JAc3AsT
	FdPQJluBWZbsKHx52lAseWauJ+i4AY3mvrzIY9/OahP/1Jjs28QCY7A2OoIPCJdWk82lFT
	BkoDzFgcD11+wiDiEaE9RX2y1GafU9k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lxbYi5gl;
	spf=pass (imf12.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.161.44 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771466653; a=rsa-sha256;
	cv=none;
	b=cOt++4TI3LMaxQRjbh0wD4wcfysrfiKiLdbtaJKDM/TY7mVjSTwjAfzjSdw4JXXTtl3w9/
	6ZuzeSEh2w53JD2AJsu14CfflDCgiLyOk9IsV4u50v2d6q+v2r82503sbel6XnMLPtRTSC
	mlpxbmONmLHHVHTS9EfHY/T/eljWK6U=
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-662f9aeb765so181253eaf.3
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 18:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771466652; x=1772071452; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nHBv8qiAqn9zn5/9Lglf+QJsgs0ZODCHP/HKhTXpHe4=;
        b=lxbYi5glX9JidFe/sH6I2N4aEG406ldLDxH2Y0C7puH7/aJBi8LwSF0mr2KEBTHpsk
         WkEgtSYiZL+EIqWbkGrfzbz6Cy1DqGAO0vs4ecmFCRygsvS5z0GA52jZXdXqFdjbsFVu
         isE9llXKJ8bo0UMbruJCkfrmX822pjgDwaXxk/iU6uER8FFuU654pnbJ2fZblryADjOu
         AbKbX2Fd5y1ubN7Mn/KozUTad8yf4jJRJDdWJIXGUwKVhsr61GZif9Lt1L4BpcfrIPBZ
         Qy7ucI1rAPCsaiwDkJl4FXQ/n87LQC/n+2Z2Lr+j+pDezKvcGiBEUP1Wt6yPXQFuRzJs
         VaKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771466652; x=1772071452;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nHBv8qiAqn9zn5/9Lglf+QJsgs0ZODCHP/HKhTXpHe4=;
        b=IfmWFMgQdHsbBCjGayCL7kAKMmPwjeDDic7TtVyrINmG2OrgEqhu4s6qg1in+ThO7c
         Rx+2zZEiyUywysH9YMcubpKMRryir2kFdPlcB3gbax3nI7AK57l/Cp1pbMUlqnbTM4Pz
         IljhYQ+xW8iuglQE9npMam20Dqz8QrJGQ4ffaw0K/RXNP+ECpr19WN+Xsx5mNcJQcK3W
         0aiVd0YXG541xenbnkxBEc2Shl7AqtPYRjFpddKame56MooCj/63oUYjtlL8kA5fWsOB
         Shg6paOqwVYxJHRQB3Jhf+kApGcBj+Io/H2tmoMTSRbB0xnCFMRSCSmv287/7D2az0H1
         g0ow==
X-Forwarded-Encrypted: i=1; AJvYcCUqLDq/cOe4VTJtl8iA2x4OSCZBgnVeUnWI6BA7Wxmhp64iatHu9dOHhrgbpHFJxERqWRUeLGkqqw==@kvack.org
X-Gm-Message-State: AOJu0YzFajJos65XpAADoZmbypDZzhJh05ovyTrP7rc/rsdtl/uZZ/08
	yyc4IbHPKJ1pBS2lrx/nPXI+82vt1RtFySGfswqCy+2UtnyfHfjsYjK9
X-Gm-Gg: AZuq6aJsztVdqGzctJRZqg4Et6hpv09LMaMx7l1r3C8BFj5tHH+8yPhFxvs/uJlhma/
	e56R+ZnO6SbuO3ibLLkUfgfsWoJ7eA+JRa5dWY8U6ybk/GSDjBoFB7slRRgSusK4zu5exlXwP3N
	9WvxHUHbg3LrcEVyr4zaLHrG0tYEi/xY1lHP82Pm/scX3il6Bj6u+SbciUq8/XCNdCT0yN0gVwt
	Aif4dccuuraooU2fJWUgxovmq+TGNDrma4NIvu4eDyCNz6HmdFhFW0hEedkPlPk3oGFAtKz+4mF
	ahIj+/VZnXD9kZsXFTAX4ABiSbt16Z/EC9tClxUpXAUdbX3INSBiPGyUe6QvSE51VmToesHuJxq
	Q8lNhQIFYiBbX7lz2qeCY/eHkIqkpdEsM0qZmf2FrNzLU8J5zS4qyUZJaL4UkWv4uOO88JXUnwr
	yKLHWIWp8kJbvPYjn+vkSXdr/9TBKmXB4Jm1gXxP1KJS7d+hgFytcuAAheITTJTkf8kqkubmOmO
	qV3oi+Wckp0ImSHG8bbsruH3X5LHXiBLSyRbH0=
X-Received: by 2002:a05:6820:1c8f:b0:679:5f79:91dd with SMTP id 006d021491bc7-6795f799aefmr7884557eaf.60.1771466652087;
        Wed, 18 Feb 2026 18:04:12 -0800 (PST)
Received: from syn-2603-8080-10f0-ab80-0000-0000-0000-1382.res6.spectrum.com ([2603:8080:10f0:ab80::1382])
        by smtp.googlemail.com with ESMTPSA id 006d021491bc7-676e3b52902sm12187297eaf.11.2026.02.18.18.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 18:04:11 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Dave Hansen" <dave.hansen@linux.intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	akpm@linux-foundation.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v6 2/4] x86/mm/pat: Convert pmd code to use page table apis
Date: Wed, 18 Feb 2026 18:03:52 -0800
Message-ID: <20260219020354.321088-3-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260219020354.321088-1-vishal.moola@gmail.com>
References: <20260219020354.321088-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0DB6540006
X-Stat-Signature: hbf81bbb5oo7gko1n1nwpr3i8z8uggiu
X-HE-Tag: 1771466652-976758
X-HE-Meta: U2FsdGVkX1/llRMNe1VhAd/BG8KukN+SmAjAIrl5ZtQhim+daO6riebIRplY5YehD+8uoiCKxjAR8YQPgtFple0hz0TSfLcoP85SJEbfk/aHU799BoTYsXTI2BPAPUlVmYMICeACZEQCm7mYpijeudQvs0FDEJ0mV2B65DDs+r8rJEcDCVfZCDqnhcyfkOvQp8GqGFFKMnPY3t1GUoMRnacn9zlVXyBYDAsvKGhi7TU71KHgzoYwLRAg81GT5/JevMuNKPTtTb2Y2JwK5d3yH1Muz0L3lNtbsjFCUV92M7efykin8Z/EH7GSbO4LGfD0ncxlRoFz0qTPA5L7IIwDYuS85X6jPR4dxvplHR4gutZEmZ8qugGu1JcuY0G/3QdvXV36tbuZq2AtbWUItKk0bIy8qFERf9QV0zQNHFje4Jx5uuYZxghQ8qpmexMj/9P7FqJbaHPZ4XrnQ+6C5800jGmXm1BniQCxBXA21FGExhbUqWiRm98uSc+rDVyLwUK2z9FhMu2hnlSDL7Ps8dsPGpacywKr+3swXndv9so/Hk8cBDJNqjsAGuJ1qm9YuqdbrAH7I8vMSqX9son6OgPnGkccyB/YQIWQ/WOXE7zYUD7ztsJdxbrNWDhBOd7xeFwLFpvJM8yRdgOly0mrm+I923U8NgxK1GEQTm9t2wSAjnx5NL1kVbMQT8EzLiDRKPC385wU7idKf0pL2dQUqqyvnLaOczN4H/TkyTxuVP9Xv8dTziHKOfn1gdAu/P9EC36zO3wScn5S4FrwDllXTfGhDGIhazc9CS6Ggs5FGQ3x32XhX34ITF6W9XDtjyyDQKZoPjaHW8HWVnVopiTzB46JcesQ2RHhcS4H+8dcKXrENW3shsBKFtkE0ygvc4M6R2azjkTaCel1XJy0bEBI+TySE/tR+6v3Xlv6IADYhhYUYC3rO4/fgnSqrbZbvhx9AUthcdPGm6C1Gt9Luv1PtNu
 Y3jNbMj9
 iqc/nYZ5zj/M1qiTxQfbmXcJi7MRLVUXMAICmGZPbCVMTxrOQkm5r6GhGk1Uhdi0CuKp6unoLHfRBVsqJib86l95xYSx3TjnqK2zRrdWzehOqP48OxhDfpH44MKvC0mXvayxK7iedYFVpDm9YcW+jAlXYPiFrsxjg5WkjolAbiNCq2kmPRKs/6FB6as40UUleWJFW9SzYHood7m1WYrs6xf32BRk1LHtNcXx/aJ5P6DLbD7qotd0cQccL6XuU2ZHY/hhPslszuwNZos3Y6jE4UFPhsqRBOBlL8td1RuP5lIVtLcRNBkumwU2Qnx28lFadH/bExR2ceRmx791b/BZDDCITVv9kery3sDxXxSKYF9hjuo7s3xPNG//dm+wr/kQU7u4a5ZeNw0Dy53nxW64MOwien5hDYzI+p6HXN/+DaEOnISoOkThW68VLdxsSg8oWc0U2KsGue1+5sAr4vuG6PnF5qodxmBLSMrIi0aoDNc1HtX3GS8Yszvt+kQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We need all allocation and free sites to use the ptdesc APIs in order to
allocate them separately from regular pages. Convert the pmd
allocation/free sites to use the generic page table apis, since those
use ptdescs already.

Pass through init_mm since these are kernel page tables, pmd_alloc_one()
needs it to identify kernel page tables. Also, the generic implementation
doesn't use the second argument. Pass it a placeholder so we don't have
to reimplement it or risk breaking other architectures.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/x86/mm/pat/set_memory.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d52010fd3023..655bef618ea0 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1420,7 +1420,7 @@ static bool try_to_free_pmd_page(pmd_t *pmd)
 		if (!pmd_none(pmd[i]))
 			return false;
 
-	free_page((unsigned long)pmd);
+	pmd_free(&init_mm, pmd);
 	return true;
 }
 
@@ -1549,7 +1549,10 @@ static int alloc_pte_page(pmd_t *pmd)
 
 static int alloc_pmd_page(pud_t *pud)
 {
-	pmd_t *pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+	/* The generic implementation of pmd_alloc_one() doesn't use
+	 * the second argument. Pass it 0 as a placeholder.
+	 */
+	pmd_t *pmd = pmd_alloc_one(&init_mm, 0);
 	if (!pmd)
 		return -1;
 
-- 
2.53.0


