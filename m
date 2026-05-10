Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27D80CD37B9
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 13:56:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 888176B009B; Sun, 10 May 2026 09:56:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 838C46B009D; Sun, 10 May 2026 09:56:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727B16B009E; Sun, 10 May 2026 09:56:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 595D56B009B
	for <linux-mm@kvack.org>; Sun, 10 May 2026 09:56:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 21E43160313
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:56:18 +0000 (UTC)
X-FDA: 84751659636.18.D51CB12
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 866C2100003
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:56:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qTx6zCQ5;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778421376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iDocV7B92GL7ACETudM1jL9mwFqvJ3AGxeoTsfzD7MU=;
	b=4L1eRubQzIYzsuxkUaKizL6zuRTT3yt3LB8SQhdXex42mzOr43rZm/LcicwYVHwjlHVQi8
	x/T6zg4jurPVmdpxzyfU+EZncb4N0tBT89aLog7IYpvZ9jnrmGLrFNWww/4sexPr8WElJH
	kPbVo77kSfh1YL2dvGd3SANKpI4XuW4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qTx6zCQ5;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778421376; a=rsa-sha256;
	cv=none;
	b=wvKmNtfFVBBKms169LQB/JocP4mnw2IMrI9tz4m5k1GhrPqmg1r3F30vu2xtbNoMt6/cYC
	vH5PB6KPry4guzrSVO5W0GBQRlesAxargPKiIQVD3U+C7Yem77MR1qYUosXUnqR/Vw12Gl
	vJLeZgnzBvzVP1VPIPalAhrTh91FFis=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 110F260142;
	Sun, 10 May 2026 13:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712DAC2BCC9;
	Sun, 10 May 2026 13:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778421375;
	bh=IdEPlXw4dkMVbwrrWqpYiCW1jHNUxW961O1EvYNalsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qTx6zCQ5dh4qEwZhqFS99kQ5etYMSIjj7tuTxSW9d8G0j3zKW3JMWXRROevWzF2+o
	 WVEzflU7g2gZvElHmKuzMOT1DuJUWKMpAGPLOYagNzJf5+bM3r1BYbns7L08gj4z3m
	 zbzuff/MucIrEeU2n0sqfJfsTPivTlYUOHxedwJRwUKXn8YLH/7gLLN/F8Vg3YSGBX
	 9iVA1KwQhEtECeQVIjj3uzhSAOtpgEBmOENTVcEuiUGSXe/L55ozKCofEEfZgG4IOk
	 wqJVrRPOmoITukBYPBVQhgz/jaKAye+sx1R/wL8qHMQ2cSeQRfa2XQfRxv6p6zFhSA
	 bmRFv31RUcjIA==
From: Mike Rapoport <rppt@kernel.org>
To: linux-sh@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Mike Rapoport <rppt@kernel.org>,
	Rich Felker <dalias@libc.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 08/10] sh: init: remove call the memblock_set_node()
Date: Sun, 10 May 2026 16:55:44 +0300
Message-ID: <20260510135546.13554-9-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260510135546.13554-1-rppt@kernel.org>
References: <20260510135546.13554-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 866C2100003
X-Rspam-User: 
X-Stat-Signature: 5imzxkofemp18hp31d5nokappsrx1sdo
X-HE-Tag: 1778421376-737593
X-HE-Meta: U2FsdGVkX1+0/PLpsStaWteRI1n7kBFBPFIcs7I+80WkQtSHa8XutsF1agiujXz4QlXQiHi6Q4jN/kaVDeAnEkEdXXoNcxX9Rvdhu2m3QMd/AxA/NdrgKNezOFDEuF6jBOePBlBG8JlmP1EfqKEKeGDAkJBZ32TCwQEPENCx8dv1CGMuhqyWLP6IPZeCJTA5S4BhvHpY9/++jDxZGYlw7zUVYexlgwGuDpnknrF91+7dp2bwo/VJsnvgPGbguqpltNmAydppipB3FoqxIeVSJRhp72H1O8z48sdjJDpCTolHsNFY4hKjc1w0Ri9lmCrFURCl4Z+wYmIjJcozyNRUb53FX2hSkVfLuzGSxn77jJQqDCHHe8VUm2qFMduyciLzzX7h8n6wC/jT0j/zYcQFiTXMnLN7FeeheED9F51h9+Cx8UXhTrr/mS8KWajgU5ieTLfkj+eHClhWF2tagwfQoE5vKemWPSX5p+OZUTwNpQCcJBRcKZN/mG2xMkER+nuhQT19AUfj1s4gEoAjbBB736EvlKwZumfCDw4bOAW7IYx6cJXgpVA22qpkaaKvEHVTqAdy2c9LlN+M93poPOJemlMoy+TobCdlVU/ttxPUnRz9yaiwEfCeVd75oqt7eSxY4eGolumkt2+Z9JI5vJs7nGRrenvUHlrtcf29YYWRYPrV4wfGHnOqPkEB7RaISHB2s+bO8NF2tVtbwoppAnxSQ9ZirTNe/vVh6eB76amWSSCAL1kMZqK3z83xbfM/82n4hgBBn7uMRDVnw9gYCa2qbpgWjdncqllzeV93ETppB98iii90fHdo/LwfyixvHVy94MPKIsKD6t9Co+iTbhzy1occnad6TLi4Nwc6eKBpmwAtUvqb+nLxE/5nrMk8IY5V2pWeGXRe0kH0wPkK6e7pxQaOELkH2Mevev5tiOffX1d6NZJPRzjeEyTpwA4tdkrTROObjkNkoRCh3UiPpuY
 x1sncmnn
 XPJ6UlBOhmh3WymGOQxMWT04k1INqqJHglfXvZ18v4u0eEXrzSiU6LDrZvpFD8lLuVm6JGPAZoGIfKPPHG5Zds725RTdhe2BkdTA1e8hm2xcddnAd0PfiPD4Vyov/IBX75CWKB9FolSjt0iB6zJo1fJheQr+TY10TK2khHa6iqLwmmN3p6n6GsWfk8ctSWd4dGbulZX9Cxmoo3pvIep3kg+4PMPEEvaFCZJuBJhtZi2gPgjdq/hM20UoY4sjjHrcw+lHYxvv6LDh/yQWoiep5gD2VyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Without CONFIG_NUMA, the call to memblock_set_node() is not needed.

Remove it.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/sh/kernel/setup.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/sh/kernel/setup.c b/arch/sh/kernel/setup.c
index 2f2764061003..43d0f7b62b03 100644
--- a/arch/sh/kernel/setup.c
+++ b/arch/sh/kernel/setup.c
@@ -228,9 +228,6 @@ void __init __add_active_range(unsigned int nid, unsigned long start_pfn,
 	 */
 	pmb_bolt_mapping((unsigned long)__va(start), start, end - start,
 			 PAGE_KERNEL);
-
-	memblock_set_node(PFN_PHYS(start_pfn), PFN_PHYS(end_pfn - start_pfn),
-			  &memblock.memory, nid);
 }
 
 void __init __weak plat_early_device_setup(void)
-- 
2.53.0


