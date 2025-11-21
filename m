Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54AAECFA761
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 09:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B08626B0092; Fri, 21 Nov 2025 04:44:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADF9B6B0093; Fri, 21 Nov 2025 04:44:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BCC26B0095; Fri, 21 Nov 2025 04:44:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7819E6B0092
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 04:44:19 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1BB05129BF
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:44:19 +0000 (UTC)
X-FDA: 84134128638.10.A72BB15
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3CF008000D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:44:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q5csaNVw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763718257; a=rsa-sha256;
	cv=none;
	b=Yn/AVJxHKYTTTsmGICgfG97WFLd1KzqOqOaH4qeSQO9DX0IFxcakgaKm/W/Mg7skXf1U5R
	o2I8BEF391WJjds4ocdHQ9mmyNbydQzzUFRuE/z9iHOK7grMrc16t56rNnAKI5ZCMnKWGP
	oyzBStNCO+qgrM9zlEpWUkNsu5M/MTY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q5csaNVw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763718257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ihgP3PHNDO2dE6rTOKUbTvgS7JrxdNHtivdt9vcT2gw=;
	b=VcGrlv7EaknL0hjHsy6qHoOt1AVa6ZsRa6ifMkiVSlLW4ZupL5Q0bBVsF2vk01vAeNTysE
	9MQ9fq7tAnnegRPa0+ENmVJgYagDU10XGsvn9UgzfZn+hOaOpmbYZW6pzSS92FUByJszVF
	l9PL0lhZpnyGg2PjQZPKWJN+zoIcVEQ=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7aa9be9f03aso1537598b3a.2
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 01:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763718256; x=1764323056; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ihgP3PHNDO2dE6rTOKUbTvgS7JrxdNHtivdt9vcT2gw=;
        b=Q5csaNVwQn6lzGToe1scl8WczpnHtZvfjuD+mVsh2TOIHmIcbqWXGp1bkLesDgAiNU
         3dIS29nTTZti3F8pQFksMFYp337e3aesEsZdNhyZVBmgZdhXz3tTtlBZrw/MpR7FRGLX
         5Qhh2Ly+XSfVTStJNKzCD3jted/eIolEe80akxlKRa+z8Q44LJm+xv+OuQMc7gN1yga4
         YqeG9X6svDgCmX373zfTORGtpSc1UgvocHMVXPNMUlcRFJBuz5ow6igOPGshBOpCQTWs
         Wi8T9VWY7ocH2qxU/eyzHTp2/hPNamcMxO38nTNr2nnK0r0OjtHlGrw1JR6Yhr2HNTO+
         JnWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763718256; x=1764323056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ihgP3PHNDO2dE6rTOKUbTvgS7JrxdNHtivdt9vcT2gw=;
        b=LPpb3TVDaa6uIoBIUhdT5OgxCObtRFccAiZdOz+ccgwcTJy58Ui+Rpqnd84UNsgEF2
         6sfxnNUX9ztN0ZqRWCT0XXSNuVgWWuR7b+47VCRi51HuE2Fi6R6y9wcSJk4JQsEQepdd
         IcUzcYZP+33dpXPUYmrVFx2TGdXxdRMpy18QV1NFsqOErORw1ZCOiddqsjG8oY6uj3f9
         STsP/Ce895L3S95bao/BEMAHIHH3wvxYe0DnUu/yWYnTMKF9UUBk84t1AQqoTGn5N5bg
         CI4CvWxfTPtOvyVIl7V8dp6qs3bCubCURJwneTViCBgpfniVFDQnV7ViWpN2JQpB/2cM
         3/KA==
X-Forwarded-Encrypted: i=1; AJvYcCVLsWvC9suTgpZQf3MtAV3UNKw4an/IS/Ed6zj01ACKI7LHCp5WTEDO1HikNG494pWzRm4FUXEh6A==@kvack.org
X-Gm-Message-State: AOJu0YxWXLl+EvA4V15k/qi3MD4gzIfQ0SqZb49ETD++U1s5nJ5AsZkO
	Y5KcqWrUPDlYmzy0HNdCX5ky/kByj0fUmbtKemXTx2E7ovewe9RBYou6
X-Gm-Gg: ASbGncvIhhuaDMZSCTwCcmM+imYuKTmerwT65HSwdHJq7urB1V35dQTcunNm599bhPW
	H9hSPTm08ajkbnlKesRHu6WiJGWFJk8L9b3iwRWij80oLeSKfGROLcWkxSBN2asHQ58ZYynh1kt
	KCr+5uld4pvmGkITertg+MiIYWyp7UH5SBNJ6epT9UUJFe/djPxc4/jgnUy8ETSA/iSa8v8774P
	uj4tQCH9W7PqgdnK4ivEKsz4CWueIwsX7UDk9VZZhAIFdf8O/tBZqUavjvahHV8rifA5S1NA7m3
	KrzM+EwowtCYcZCV//1O9H7BnpXRwWVGlB2/R2BH9fU68yMe3RyEM2eEQblbfH4dcy9iBQCdYss
	k4omCEaaz+31UzxKmRUe64vL/jhA4zYePj6XAJR0Lx5e6OGqd/LoEK2mOSkNTB4wfXpzt0ikRlH
	Zb7pMuwzLyDJb7zFPaC+44sQPxjz5trWO4CQhemt38mrI=
X-Google-Smtp-Source: AGHT+IHtn09p/fUajl3JJ7EDFZVm6tN+LhxuwChjRg+EFm3vaMok3KbuKyaYH45O/+tQEly7J9pPSw==
X-Received: by 2002:a05:7022:ef18:b0:11a:342e:8a98 with SMTP id a92af1059eb24-11c9d5653edmr607339c88.0.1763718255862;
        Fri, 21 Nov 2025 01:44:15 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-11c93db4a23sm22430736c88.2.2025.11.21.01.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 01:44:15 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH v4 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
Date: Fri, 21 Nov 2025 01:44:02 -0800
Message-ID: <20251121094405.40628-2-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251121094405.40628-1-vishal.moola@gmail.com>
References: <20251121094405.40628-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3CF008000D
X-Stat-Signature: 43jqc91mst7wcmbqkmkn95t7iczmpokw
X-HE-Tag: 1763718257-249795
X-HE-Meta: U2FsdGVkX19QbU/DI0xNkh/iDqSiOn8hdzEw9cOQXpPVSX8WFcovfjn1mqsJuWOL1oP2wJmDhXP//3sp0vzbYlnX+PnxEJ8/HWBKpZg6uW5Z5Mdw0JS3Q4jeOhkrIzcLnxjFAQEhYnw9+hLjog42BagT04YjMsThmMmM2h+iBxHfzxqs8uH1RtUIuG5b+7vPUWs2sNN80bBmvnRYrCk37AX/NabttOyHZsouVZnK8P+jVeyOBakbnIMiRRMWDheQ5vjocl5bMunUbafSEv2H+6BOU9GI0WQnwih2KA39uUn4YkgfBEqogEpdHLd7KJ31b2cNngTGQcuUF1N1EFof0TdfnLBTEC8jIQCl7bAqRbIxvzllbgdxE6C5w9iXrg9KAS54FCQDEk9S4758Ay1csP8yoL97Mixzh5KOad+hDMpR3zV2X1U64JNPJqE+sbCt44jscLWtr8DusgH/vnZEzHYcDaeasjO4TKivyXaO950JA2o5snrbWa6c4Jrl+PC2fIeClsJOYMA9a3T+FBoCqrPYhN6s4ELOC56r9tEVDWAVJowk8gWydtM++GI+OfWvknaEZeYKrWsG2xzQv9iEoZfoL/ElxzneG+4m9pqLj40hVIZjof8qPDpjePDu2ckR96t+K/0USVcngpte/uUniKfzq+IyOAScMhAJQ6NN4C93QDSZr5fGoqES2wjXJrBM8QiuBsam7ilMUkowB6JyKgE/eHjpJhv+tjuOHOVsUN1gZsYMoaKiPymNaRWcOK3nich+165eFKr/OgJxDIJrkH3haqgMbQSyZDX7VcuSLNHD5Jfah9IMMXBFs0Jo20yHE7LUtLE6Oy25hWpgEiBfGNK6gME5VH+wmIztEAopMMlcL61MyiscxP5TkNrfJwjPn42mhdYnPPqsaeiqM4p7q/EfzT/q6RFxUceG8J+2oB1p2seHokMXa5PgiTMFLJoMIbY0Tq80MLpSS3kKRKf
 PZHvI6Un
 b4ycUpG1SnK346424kyuy0gD4pcN3fVtkNmkd3Mf+g94jOw3z0M1NhDu9ciLAugjjrHL2pYwxeP0+AISPhGkAdAEdkg0PVQbvYAUcHeAAx7O0XhUhccXnrFkK7yF7K0Mv8zdj0tRkQPC1JA33W6d5rt/nH5Y2JvAD2Mx5/HyNo+B4fzRglrMULP123WmqL5hJ5rKiFMVXivaMGPt6tdRBqi7QcX0VkHUKdmasgC6YsoHnj+wh+DiBk4tOTC3uoIVXItk22AJESnuP4AaAw/rEe4kGqZTAFJphjP/mYh8UD+Ed5vtBvos7J9N671c8SKc87SoLH235LRGNmuyCT204sA31Wr7mG5Rr2cMgdmrDdp0vSkjT7oURVFt+gBCP18xLv4V+SUNnc5l7koax/Z1epaBuKBS5X7m/7kcjMsvekLGccRcsCVhvAcQsA2TaY0tBE9x4xv6RxeiM67e02Ef+FFP32y9Ep9H4iZfX7ci5mu9QdeJ7BuldejBt6mNCtcEyq+0oeVKQ/tzAH8hNf00L6wrjP+k4fTp72tpqxv3lr6YWAANg8DjidEcoav75XtkZyk2cAB0eLuGvVSjdTOKGhD/KRoC5u+gxoxQRkMBwWprlX8Zl4O6FdzSL1sIf/klrJDV0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Vmalloc explicitly supports a list of flags, but we never enforce them.
vmalloc has been trying to handle unsupported flags by clearing and
setting flags wherever necessary. This is messy and makes the code
harder to understand, when we could simply check for a supported input
immediately instead.

Define a helper mask and function telling callers they have passed in
invalid flags, and clear those unsupported vmalloc flags.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Acked-by: SeongJae Park <sj@kernel.org>
---
 mm/vmalloc.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0832f944544c..c97c874b6666 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3911,6 +3911,28 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	return NULL;
 }
 
+/*
+ * See __vmalloc_node_range() for a clear list of supported vmalloc flags.
+ * This gfp lists all flags currently passed through vmalloc. Currently,
+ * __GFP_ZERO is used by BPF and __GFP_NORETRY is used by percpu. Both drm
+ * and BPF also use GFP_USER. Additionally, various users pass
+ * GFP_KERNEL_ACCOUNT. Xfs uses __GFP_NOLOCKDEP.
+ */
+#define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
+				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
+				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
+				GFP_USER | __GFP_NOLOCKDEP)
+
+static gfp_t vmalloc_fix_flags(gfp_t flags)
+{
+	gfp_t invalid_mask = flags & ~GFP_VMALLOC_SUPPORTED;
+
+	flags &= GFP_VMALLOC_SUPPORTED;
+	WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
+		  invalid_mask, &invalid_mask, flags, &flags);
+	return flags;
+}
+
 /**
  * __vmalloc_node_range - allocate virtually contiguous memory
  * @size:		  allocation size
@@ -4092,6 +4114,8 @@ EXPORT_SYMBOL_GPL(__vmalloc_node_noprof);
 
 void *__vmalloc_noprof(unsigned long size, gfp_t gfp_mask)
 {
+	if (unlikely(gfp_mask & ~GFP_VMALLOC_SUPPORTED))
+		gfp_mask = vmalloc_fix_flags(gfp_mask);
 	return __vmalloc_node_noprof(size, 1, gfp_mask, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
@@ -4131,6 +4155,8 @@ EXPORT_SYMBOL(vmalloc_noprof);
  */
 void *vmalloc_huge_node_noprof(unsigned long size, gfp_t gfp_mask, int node)
 {
+	if (unlikely(gfp_mask & ~GFP_VMALLOC_SUPPORTED))
+		gfp_mask = vmalloc_fix_flags(gfp_mask);
 	return __vmalloc_node_range_noprof(size, 1, VMALLOC_START, VMALLOC_END,
 					   gfp_mask, PAGE_KERNEL, VM_ALLOW_HUGE_VMAP,
 					   node, __builtin_return_address(0));
-- 
2.51.1


