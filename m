Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF93C606B13A
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ltG7i5se
Received: by kanga.kvack.org (Postfix)
	id 1B39B6B05C4; Tue,  3 Nov 2026 05:18:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18AC56B05C5; Tue,  3 Nov 2026 05:18:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A0D76B05C6; Tue,  3 Nov 2026 05:18:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6FAA6B05C4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:18:09 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6B2A51A0380
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:18:09 +0000 (UTC)
X-FDA: 85393407498.07.37BD284
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id A5A55140004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:18:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ltG7i5se;
	spf=pass (imf23.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793701087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H9wZERoTK73TzMKQ9KwUyuGxqQabGqZnw2K4sCikbaQ=;
	b=tKJ9x1Aq8WBCwNvGBCI4FdogewkdN4PNAyvxdInQdR6WiBYHXm5EtNo4Pf0b0YiLLT4tak
	itNniJmTiVUsl+Hx9mvh3RT+Ubxbksa0pkuScoUipJbU1SxbenrOg+3sFX4w/DymAQK9Pi
	xRxtdlpkorAtPge+ls4jrh0KKv0BvE4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793701087;
	b=a4ThH4Fi6Z3fehVJ1Uoaj6NIr5hBrq1xRXVeO5V94ZRe7iNfUQH4LPNWfnvstZPLcYQVYl
	6kcIEpTje2EXggV+AjyPA3rRYVjBPGpZCxMB5FLBE7yWtJY4JXBcWq7gvfj9Vm5F/4bvA/
	Lb5CeWp+PrD+8g70Phc8ilERhk9Gq2w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ltG7i5se;
	spf=pass (imf23.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-35c76e9614aso5491380eec.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 02:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793701086; x=1794305886; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H9wZERoTK73TzMKQ9KwUyuGxqQabGqZnw2K4sCikbaQ=;
        b=ltG7i5sei4s5LX36Rf9kg8STDuWqo31PbkJn5hELPDhmVla+8cxsmD+TD9xISJZC36
         TNvU82Ybs5VW/uoTBJ4Nqh30gW9mtjhqF8+f/fAS2dkBXGvAu7hWsT5PbUaX/jBtkuvv
         6/epKyurmBMlfX58N/Ob707SOGazf5z0pv7VmONdhMsaScvmHjTNPxzlNmyGoSTsgU8r
         n/D0yNqpTvGU0CIwq23DPjBBbtwxZSmZD5kaYu7rWAf9Qd+46g1vwICc7/hM6cSCjVld
         2hItvsnEpyHn6U7yWnX/B/apQGOZJuDgiHn+URdR+Uxq6Qfr8y4WdX4OVYUXhqJeL3Tg
         TGoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793701086; x=1794305886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=H9wZERoTK73TzMKQ9KwUyuGxqQabGqZnw2K4sCikbaQ=;
        b=Jr9yrIghh251og3IsK6MCWLZjiGb8vRf46lv2U03b1efckXDoY7zHUQ31rGnRfrywu
         QhYA3oEcj3b4z2RSq3LPS7v4OiAMj+VPWfMnpiPBLFWRx77g7EBrk9xVCQeD+JboQetB
         BYBQ++OU/04DBgqFxmIunLQsi1014tBIWkhLcEoMmGDA6JvDbVImIFMYayBzLkDpo3ZU
         9rQy8+bpda7HPkWQfdG3uOuHEl6uCRFamFVwZsJ03vH1lzwZW5qIHO9ZTEPrkwsU/BAe
         of8GT0eDfC7XP/ezCMspAsD0dPdVwN4iPA9YfAA/vYbDKOg6CGv1jGX8wtfm40YQYip5
         +V7w==
X-Forwarded-Encrypted: i=1; AKwUvBxQGhoglqL4pfZEu1c/hpPmHlrvBljwE90Dxw/QT7Y2CF6BCtGuBN3+x7jk2v4AcDQVruhiKkuXvA==@kvack.org
X-Gm-Message-State: APuU4Z9ILe6uul18LCASX5M7SladNkChZnZYisuu59dfC9522xp5mVwQ
	9YJV6s7+V1jeBEgEXo+Qf6rE6Jjp+Rc17HK0KBfO7MMbr3DVn1KT5+9w
X-Gm-Gg: AYBFou2iGhNjI0fSHcP7aVKUMnqeHbZ/nOETPCuQ+j33EYh50eUMim3oGTXNcfRBf0m
	KMNB/61bEyJ/WrMMjH4ARnvdVXHA/YjuKORI7IP00Ryy9T7aWgjhKDCjRMyNpSSTJ9O1+KxuNVr
	Z8lO7mgSvoDK41YW10tHB3Xs38iKukTjPP3GhsSAu7wmJxRm/G5a5GaIOfvobI9xNcrWvBE5+BW
	INtQnFw52nCvxNHcLhbAukkSHQj2oc0CIeg+9dljL3IyfAz5dlvZoqLf5xjNxExMsitxAjIj6V6
	ey472R71NLyCRskWLrwMO9uUsossCuOUigeYvg6htxFsihMV5mXt6qvSTQ2bvclz8oVnsvzrJXs
	kIC9KVePuSei8V5UaEkKJjwTy/GHnIv3gPVzfGZzF4OXL+A671Y37vFE8gX2HpUguTMzFSc4jMd
	BLVPFVd4Su8sWuLTIw3K+LDAVgWczAlZuak12ULKRIEHLyaCO5kYsxl6geYURfIflGDD2+Yaapb
	VPYIhGsf8n4DAgQv3rV/JjVASb2VPCSWVQvTrVDiBa6q1I8Fr7rZLcqRjPwrz6ydS67nRlcoAZt
	Bc3h4qPKtgFTrllhDIsRPDHHrW+uQreGgBtnh3E4P/9Q6W/2hsM=
X-Received: by 2002:a05:7300:c019:20b0:36b:f09f:924a with SMTP id 5a478bee46e88-36bf09fa41emr1925693eec.14.1793701086055;
        Tue, 03 Nov 2026 02:18:06 -0800 (PST)
Received: from 027.. ([2409:8a20:4a5:7150:84fc:ce3c:7b09:dbca])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a4291e38fsm53145387eec.15.2026.11.03.02.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 02:18:05 -0800 (PST)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	baohua@kernel.org,
	chleroy@kernel.org,
	david@kernel.org,
	dev.jain@arm.com,
	jiangwen6@xiaomi.com,
	leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v11 08/10] mm/vmalloc: extract vm_shift() to consolidate mapping shift selection
Date: Tue,  3 Nov 2026 18:16:56 +0800
Message-Id: <20261103101658.766905-9-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
References: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: mm6z59zzyrbinw9cnsi3zm8x3ifi81hc
X-Rspamd-Queue-Id: A5A55140004
X-Rspam-User: 
X-HE-Tag: 1793701087-753070
X-HE-Meta: U2FsdGVkX19bqnYSSWrcBBx+muhziLAdWjATwxc89Here6tNZUjfxjYHlRBmCcaw/Omf2lJxYi1M5bw0ZUDH6gJqQlBgmYNm0crLUJeRtFlaes9gPR3w9KSTFb3M8vg66jGp2sv2jbZZB1wm99I7YhoepEe/u4STZVbVyZ6PcuIa5q1IWHIXLNryUiKaH5+p9kx2GBrHS1wI+Kz7Od28tktII2HaCbmwWawf3ve19Ky9NUR5qLw69tMutiBJzO5HbcAy5BSuMOQq3TN+osflY/Ah07Gwo1w/UeCzssHI6Z/QxD5wGXAsfEQfMYID/U9xFvantqzOeUpMYasOpx3gh4sG+dk6EZF6WZu90e0zJd8WsuHiI6yNp+SQFz1AkZIJo4s0JxN59jeJ3O1qf27LPCbrgijv3od20gpLclnSp4oO98elKedS9unloopH5UGllqPOX8iuZ3sToVIrbqPA7pQCyfM2mLV29uQY8GVktZn2r57Hv1ZaFsIRZR82itMwIUToYxXj+TpfkdI3sDuRxi1ueObVBy6wtIBV6xUxjrG1sgIkKCO8cbo2jpWPoOfxqnJz0GIafUh5Utjr2unCHxIQkT5ZBDxNjdd2GxlQ/DuWNdpLqcXZGP1UxI9DGm4+38+tw0ZwB8AF9TqIKYL74hayskQjyiEZ27gmj5l3LtvDXOZz/RIk8njUJ1QPUb/ea8LKVQJ3yf/91lO3KNX8juVhLYzsfnsB69UbxhMzWPhrW2yl36f8Breuy+Djm8BmmhDDfnFpLiykAzWBSnqjC/tf/F8/7OXnZUri76Ic+U/eJyOec4uKhBy0ND0ASnKsqbskLTOkRR+BX8jgWtCbkZ+r9s5/zNpFwsJG5KtZ75u2OQ/k5sp4smSRfwqGR/qIgpvbf0t7p2x3RR98w8GoYEGhgUH/vQPevODGo29rXedceXj+xhQc0ssQ2niGE+oGfUGAhX2UkuhHDNmjhmF
 gusbrOei
 KU0Ut/CBcQ2iAgYQWKHRyPqDL2CASPdVWU6cjE1kyAIVgOX6AvDkKkd/EmiQRXtrLxjSVHGWKYZ6Y9//D6Wz7S3un00i/N+mUaeIrm7lDJTa1BZrWHAU7HRmDcibWJuzOczX9VQxsqwSBDDf/bYg3P0+kTBFwkkC4K9zfjHDEBLP5N8tAh0IdU7/NN3ZutqRNr9iJm7Ag3U5MTbd7ouxbt8lU0pF/TfUs9mndffVBTQ17UstX7c/BE/nJ+z+X6aKAb8Lu3xOCyMJ3yYHNcvdgoaX0x/QUKbNepmeBRbqn6z/CDjWQpcH5EG5E9IQ86aOkDSJSvWMdGmz2xvVu71mfNOHSywq8i3YnNMK5uBhJIT4eCN9YSbLIcTpG7SvOSPkdl3GiR2RmVVuhjDd+ruZpgNAjTCdBI+D0JtInFxAQpFNAW3NdScJbj0frpzV42+HrwQJ3nabjpTsUR+6d5778dA4BijvnV9v/LLjGDsTW38M4Za/nq146nbZMA8GM1kLGhgjl7uPnUEp+oEbGTsdP8uHThFMbxBsyaDkQTWf10IYrQaWfL5Zad59M2iI00xNKGZLTXCFhrVuOy6aaHJsu60Qd0F0m3FvC0uFG8zik2tEZL98t2qZxQVubqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wen Jiang <jiangwen6@xiaomi.com>

Extract the vmalloc mapping shift selection from
__vmalloc_node_range_noprof() into vm_shift(), preparing for reuse by the
vmap batching path.

No functional change.

Suggested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 mm/vmalloc.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 61f2b6fbbcd9..ee2c1ec4ff1f 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3605,6 +3605,14 @@ void vunmap(const void *addr)
 }
 EXPORT_SYMBOL(vunmap);
 
+static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
+{
+	if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
+		return PMD_SHIFT;
+
+	return arch_vmap_pte_supported_shift(size);
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -4124,11 +4132,7 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 		 * supporting them.
 		 */
 
-		if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
-			shift = PMD_SHIFT;
-		else
-			shift = arch_vmap_pte_supported_shift(size);
-
+		shift = vm_shift(prot, size);
 		align = max(original_align, 1UL << shift);
 	}
 
-- 
2.34.1


