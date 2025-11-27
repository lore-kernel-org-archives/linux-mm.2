Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 287BBD116F3
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 09:24:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 745176B0022; Thu, 27 Nov 2025 04:24:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71CA56B0026; Thu, 27 Nov 2025 04:24:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 638A26B0022; Thu, 27 Nov 2025 04:24:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F98D6B0022
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 04:24:19 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 072F31409B6
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:24:19 +0000 (UTC)
X-FDA: 84155851038.10.3BA6781
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7F714180007
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:24:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=F6UJRyhv;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of jan.sokolowski@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=jan.sokolowski@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764235457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avkSYFBTGKWcb8DXG+GznKaLVN75gMih9B0p/IsxWh4=;
	b=K6G+hoI46/whuG6b49VO1c3Lo8BYSeaB/TP93zMIDTmJQ+Dhmg43eSx1DpYzcPOCRZHb2U
	LaZ54TFbjl/sH2taxI1tmLajgFCGJH1PeSvLnaEvmBPrXnQFlvhYv/DPs5yqdaV52V3Qsy
	TEftn6LLAfTwczE9wC9RNHzDV8T2b6k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=F6UJRyhv;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of jan.sokolowski@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=jan.sokolowski@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764235457; a=rsa-sha256;
	cv=none;
	b=nsXANjMeAglWLAJxLewa+N7tprlU8Jmc6ORdQKdMuMxW0peVP+fDlG4qjo9g0UeG202zx9
	b6nKR2KnIX7Tti4tHjL/qsDiVAuNWGU84yyS6a1CU8W7EicipoAOlNDj3QTz1LCwUfda8F
	I45zIERptH9b6a4k0GT2v9ZyiE5msUk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764235457; x=1795771457;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XlyfUYuWkICDUfkFcCQCj16yl/DMg/jjxI+jKDmBYg0=;
  b=F6UJRyhvb/cjbA80+cXJUlAYw+SiDRjbwPlSKk2gb1fJVj+mXt8hPPO3
   iWxO3suUo+6JmK9BifbGdzVoRyONbIFfBzf7Zmty7XL3GUoCfcazqcHID
   DNWbnuMZV3Y5kO6X3mbUrjyXcsd6Fz93UL2aC3sFt36VTAJ6DqVDrzKKY
   zqBaH2fLWwbcNgn5wAHx3t/Luuotzdw/Xnsz4R8c1ApuydIoCYck1Tvao
   /WfIMv9LOw0igHCOlPqqVi1avvurtzLASile8O9g+oiaUjJKMEaxek1lS
   jC0v38H8bNLIDafukIR0+ac4xa+ntBfZoz8BjmHH/vJvb+q3pP+lh/IsO
   Q==;
X-CSE-ConnectionGUID: rOslrHIyRjaQia2e77pbkQ==
X-CSE-MsgGUID: pGMC00LQTfWB1HAfqV2ozg==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="66226346"
X-IronPort-AV: E=Sophos;i="6.20,230,1758610800"; 
   d="scan'208";a="66226346"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2025 01:24:16 -0800
X-CSE-ConnectionGUID: DlvEOMD2R++DjwHq95mBvQ==
X-CSE-MsgGUID: jGxafr28T76J8iM+e4YXaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,230,1758610800"; 
   d="scan'208";a="223888066"
Received: from jsokolow-alderlakeclientplatform.igk.intel.com ([172.28.176.71])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2025 01:24:14 -0800
From: Jan Sokolowski <jan.sokolowski@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Sokolowski <jan.sokolowski@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/1] idr: do not create idr if new id would be outside given range
Date: Thu, 27 Nov 2025 10:27:32 +0100
Message-ID: <20251127092732.684959-2-jan.sokolowski@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251127092732.684959-1-jan.sokolowski@intel.com>
References: <20251127092732.684959-1-jan.sokolowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F714180007
X-Rspamd-Server: rspam11
X-Stat-Signature: 4jt8mz7x6gr6ak458ba573uapw93sfzy
X-HE-Tag: 1764235456-56368
X-HE-Meta: U2FsdGVkX18MzNGTQWTjOyHO+0DqdGqhe1+qBHyMgJRZ8+j4HhNeO1PmT14CUsl6zKLJO1A8WJN1ZYDMuF2RmU+p++o7RbMGh5EJg4A3Xh6ncMcCOyTCYNPD5qNZSrVxmMk5AQkLlpoQnN5yEMxv37UsoYOjlY59IZHTnOodhKEuNPNBZwjwPO7cwQc5aR1P3ioouwGL9UgS6GlBT40mvNgWRuGZWxR/6cH3NKoCSLFa+b3Z7AQn0ClaikeBbZ7kdSsQ18QRpEdHg4blMPm6YH2zKpeQtjBClEW6enbHk8I0qi7zaLmodzkvnrOPUq8BxJ6hayagZmDjZc137OOoTYBMLBrWoKEB/OxLbVmUT1Lml6ngvFKyvIzmqP1EKn3LEo5U+qF1ReajVlve7tVvEiyZTxFAVnVOdRU/co0tBLycR88WC78iiuqWembJ7M87JPdKQB0dY2XXHvvuUkCutbonjcNV4s5FgztY6IpdePw8q0zXOqEn1oYOKFhSbONY6ylH4RJIfqCx+h4FAWN9Z/e6DKrjJGCjyFkIHY4vMjdREv8LFTOcfQDX6rpfWJIvOGjeAJeoo0I57BCKjiiDt9nlIlL4cAT570BqHzbz7pCVtnmoA+VG3f1p7jBfWVR7yNmE6LyEPw+7vUv5VoXJddLQWwgTeejHst8Txfnjm2SIwsiYmNneD33QSWtNCgNIcwsEsdDzAKpOJK1+zG2ON+fUkOVTCBqLk8kWeqHYuBbp5vMCWfykDoDeognJqLiqxy9y3XVw93NOw6Bsp7vjC3jqLtAQKfcsfhN3GRMlwalQauY7uGfkT0ypp0EtlS3ijgRGHMwLVUYWJGqsUBrwMZSY0GpUsizVoXf6SF3rnLtev6utTv8OK0kPrBSrzK5Emdb8nQwnHJLUvpRQ60Tm6NrvimHYnwEYR8n39C/GwsctorSaRkSnwdrnDU16gVTF8ISq4pKrapFSC4eJMoD
 sUJu50Ct
 EVSPCK/fd/qdAZWMfkd2vq5zmZWglaDl98smPls6UQi5+9PbtfcX/sKGVMuqd/DnCdbMIUr37FlEns/Suy/jH+0jZEVBZ12L679+HpGf+kdW22uLyrR58Q0sJws56VOhqFJLQwxU6W/77cAsJzcdTRYk5DZ6bkqiDCxicYTL3Q8qZOvn7rZ1FANWy1ez9Q00/uyTL0B2KlKixQSjFgAmK+GVuyRzWLzDwJePOYwTRCWs2k9OTPgOUlTyK5HbQauT62vQVmtC5mgGY1Tj8a7OULpgjk9rvNeHZDKQ4go4rVHHUyYBNSENgPQIWVz6ceMNxFQUxtpULFfxNp4cyPeCpWRYkn3QajnNBt0E8YbuPAfUMSUr2meE1MKjCoy1SjLcLUfLQHGN2EFQkSx5JP4QsaX7NCm8Y/VpxoQ7zpFoi9+kFqY2eFallSSc1TQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A scenario was found where trying to add id in range 0,1
would return an id of 2, which is outside the range and thus
now what the user would expect.

Return -EINVAL if new id would fall outside the range.

Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 lib/idr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/lib/idr.c b/lib/idr.c
index e2adc457abb4..8c786e50f2da 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -74,6 +74,7 @@ EXPORT_SYMBOL_GPL(idr_alloc_u32);
  * exclude simultaneous writers.
  *
  * Return: The newly allocated ID, -ENOMEM if memory allocation failed,
+ * -EINVAL is start value is less than 0 or if new id would be in wrong range,
  * or -ENOSPC if no free IDs could be found.
  */
 int idr_alloc(struct idr *idr, void *ptr, int start, int end, gfp_t gfp)
@@ -88,6 +89,11 @@ int idr_alloc(struct idr *idr, void *ptr, int start, int end, gfp_t gfp)
 	if (ret)
 		return ret;
 
+	if (WARN_ON_ONCE(id < start || (id >= end && end != 0))) {
+		idr_remove(idr, id);
+		return -EINVAL;
+	}
+
 	return id;
 }
 EXPORT_SYMBOL_GPL(idr_alloc);
@@ -112,6 +118,7 @@ EXPORT_SYMBOL_GPL(idr_alloc);
  * exclude simultaneous writers.
  *
  * Return: The newly allocated ID, -ENOMEM if memory allocation failed,
+ * -EINVAL if new id would be in wrong range,
  * or -ENOSPC if no free IDs could be found.
  */
 int idr_alloc_cyclic(struct idr *idr, void *ptr, int start, int end, gfp_t gfp)
@@ -130,6 +137,11 @@ int idr_alloc_cyclic(struct idr *idr, void *ptr, int start, int end, gfp_t gfp)
 	if (err)
 		return err;
 
+	if (WARN_ON_ONCE(id < start || (id >= end && end != 0))) {
+		idr_remove(idr, id);
+		return -EINVAL;
+	}
+
 	idr->idr_next = id + 1;
 	return id;
 }
-- 
2.43.0


