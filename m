Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3519EEDEBED
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 19:48:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C47AA6B0095; Tue,  3 Mar 2026 14:48:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF2206B0098; Tue,  3 Mar 2026 14:48:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A75746B0099; Tue,  3 Mar 2026 14:48:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E54D6B0095
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:48:50 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3DD5113A7A9
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:48:50 +0000 (UTC)
X-FDA: 84505789620.18.8A88C9A
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id 65EAB160008
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:48:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ONl4lGDB;
	spf=pass (imf08.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772567328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/QjuD5lsXBFogYM+Oz5d5pzv8eE9aoRfo6lRKwq3BoA=;
	b=Pluu5W//ZcxfAs0sZwIeooIllWrQabLfpCaNF5PsPwE4WlL2hK8Rb0HkLub0QeYaYL9qH5
	aonDrV/EEBcxzJq1YkAUA944BSOj+kXAaM69POgw/1JvBvtFV9FxLk7VOuCFrZEjE8cleP
	XK9NfCbY7HYFWGYMPkIcZ1lU99gxJA4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ONl4lGDB;
	spf=pass (imf08.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772567328; a=rsa-sha256;
	cv=none;
	b=E7FrdBzWkSWJTtI1iiIeh0Mpion3/+NKNTH0qJZlkz6VTjiYMdcVRPVW5abe5Pof4Go6L2
	KPYiYRzG2VuxjRWFVZgx78GWthA2PHPQ66rQv1tcn6/f7mL22/W+Sq+B8xUhtnRKmJLd00
	TsTNdTTIfWzt9RqyawavOIYC7Bu+xaE=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-12713e56abdso3736879c88.1
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 11:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772567327; x=1773172127; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/QjuD5lsXBFogYM+Oz5d5pzv8eE9aoRfo6lRKwq3BoA=;
        b=ONl4lGDBaW0O9iln9SZKKyUB38IDmmOLdNyaJYZAHb7/Fzlbap52YYsAXEPImkp6Lf
         TGNnTMW5qJRgxsy1PReBjEoQ9rLcEjUhUmEMjf+GGNy6q1OL5k226YfA968EukUuQTeN
         lvhF/E7GTLM3ELJmJr4Kh4PrSNbXsJYtuPLqrJY5MZR2iyAyaTu5RK9msETWKAV3CqPt
         xBOy37oK/U/o9QyID7w5xcniRlzb40MUPhYhZYuUux5V3FmSPrao80UiJJUfYDzQ2cHU
         0jwTLtTwMXdTClwEnAID1YLnl7H10UJSzHQuPPHWTeyIzkS5z9tyc2iSUa9u3Vl95YFy
         JRnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772567327; x=1773172127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/QjuD5lsXBFogYM+Oz5d5pzv8eE9aoRfo6lRKwq3BoA=;
        b=KeDj+bvQWQJm9pYx2CcXQGtsoSxdp3ZF8iNVhdrZrWe+5DbfEbpcEOK5cuGCeNzFy6
         NKUC8WUDQU5jDw5UhC+yBgdDKOmv5b4yheW25xzMq6IdKdMXonqbYlMxcniI9wOTE/cz
         iQ03tdtFiJ5WqA46EyEms+mo39UesQm/7BrIo3gY5SW+uMDZN7LC2ZENnBfpcHR7+Yrh
         AJPmbqx/kL/pKYd77kXNMKyK1jJ7kzVg/kcaDCo1zn6C1yHpzO4k/mEsI8psUbiEC2I0
         HKx3TZhlR0Rp2tzaGSs0PVzjNIj1TKCwsLb6JbC17ir3VJCrtLsogLTW2wRh0P/yADip
         oQ2w==
X-Forwarded-Encrypted: i=1; AJvYcCX0ZY0iGwe3Ad0qbPWvHO1KaerZ1R85b8JsfhKKsU3VSwhZE70aFrxUhA7Wjl3WFbWTFd//yPBqwQ==@kvack.org
X-Gm-Message-State: AOJu0YyMKS7AgeEZcr6fjsSOiljCigIM1stIJdwuaFcvHMylwF8EiajC
	+TnQ/SCWwVQvmhIkJvGzK6WcoR20PSH0VCzPPrCxJHKK70gt5uP6zU8o
X-Gm-Gg: ATEYQzxX12PdjrbcELrZ0gzvWsNaejpJkDWxhFD8fIOLEnghFZhyhfSR0olRzlwj6e5
	CIBmnkmLouxGJkmyx46ZWxtUTmz3N9Cod8RLqEaZQvykKa5D3pytilM9pHkx/u4NGofj5Tcu8Ud
	yocNUVTMDIcu7+16PPOj3i969YLdkTbT3zyAhEdtUI5vKjKYa3dKvIo06W+OHVZGoL6m3+reYpW
	ojhfxxFph2jlqSV9DzNRfMNxCva0gMd1U53z1Twq/HO2AgPsnXHY8a178/Zqxs68cNJMB2iD1Z+
	sMezWNs0AeoyPfzFdkBVPbT/n63XNFMM4fZNFKAxb4QuVweLPWsMBpuwbKzSa3tSeXO0XdGei2C
	/GQ4GPw/FGTjmcDWtzyQ1w+C/X4VTqr7wa7TAdcICL0Lfii/zAboKRnlKe4z+0bVlfcutF4sDSc
	RoSV0MabhEHM74XXFSF18BoI42w9TjLbF1qXpuRgmILDrbEgAeDV8ryEEzNkWcHSHaku+Mg2fEA
	XdYJrDlQ/VlT/U=
X-Received: by 2002:a05:7022:6882:b0:122:154:7826 with SMTP id a92af1059eb24-128b0d05121mr1278703c88.3.1772567327147;
        Tue, 03 Mar 2026 11:48:47 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-1279e9950cesm9258748c88.7.2026.03.03.11.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 11:48:46 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	Dave Hansen <dave.hansen@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [RESEND PATCH v7 2/4] x86/mm/pat: Convert pmd code to use page table apis
Date: Tue,  3 Mar 2026 11:48:25 -0800
Message-ID: <20260303194828.1406905-3-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260303194828.1406905-1-vishal.moola@gmail.com>
References: <20260303194828.1406905-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 65EAB160008
X-Stat-Signature: 5ostbedceyabdwbbafqjp3gwqk4u4wxz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772567328-732817
X-HE-Meta: U2FsdGVkX18FcVHZEmTU+H+BgYEWtXRlm6HAvvzgEOdJF1MUsl8OQ2yFNNFHqqjkaCcSrF4+12BnOcgDQL3H4ju4gXYzYdCpRmX2UJq8PQn6jpQFu8l/VudPFDAKoSblB7tF1kMYjlAx2t7v1E7DTXYxH+OPE1rYuVnuIfSavOdo36PVYuQm7GPBHXWtTudIm1+9yp475dGaOsrPwMEMTKMjj5U2WhsuAl4HcZTX9aqjhHG7OvFL5p6l/De8oNwq9Vl98/9IaWaY3U5u2KItd+zAYdO18mdK09Kbcwjauq5ISHCP/prqL+X/0yLn8IQt4X2jXCdeqybszy+3Hc0QLfxlE/XttD5csxGm4lO2G5/A4AWz3/TH7NY8hgzspLqRVFxeunZ5aEdl6ywT+cUAkSVj2QPRb2kkpE9vSnOorRPM52eBGPEC/EYja0QEPoIZd94vfUq/34yLdF2JcolQLgZ1FY+mTp/LMBuigjes8KahnJa1/a53zjCbgPhE+oQlDK2+RMPmfaFcg/6PcbD32gwg0HDLOAc7Tqs2cJ6iwdko+1PWSMot7vd5JE+4Hqe3Am1GSArwVFf6YsqRgdMr5OzQSSPRkYRuIC1aSg+wyDnFajAEWZlCHkyL9qYqfDjz32+VC6e69FhwICS/s2GTQSE9FdYZ3w0nT0/up5k9lYVNDXkQYNAwn9r2gXSfnFaIHJ/DLOQgpm6x3qnmaLvM43XCSQK4zRKCtXLST9IXHtyJEocwhNkyosh/bgSgi3gEZJSxRGaOigo8/AMQ8tHwvcxpsJ5HIoUhP70ORmck0VQz0iBqI4LfAOw/3SXv+aUngiRZoZnxuGjsRxVwiJ2GivymlrmBrImFmQ2pppIRv8muLJHSl4ZBcFkO8Vf7TlLRWsi6xU1R2jNRLWi0Md3GHPbRwhEig7ylZcI6c0y7NAPGdOQCAQWh7R6Ln8s0atk1YL9H8c8zd7EtXEIuRV1
 WImwcPTx
 yrQ0u7smJBq6CNRQJtG3gAzlRwFfP/sBsnFjOOzSXIRlIu+9Q3T8t0K9SImaA7vE417GmEyfH+Oc9jXXafO+v3TsISUqNb2X9WaKQsv0CuxoKUHldbbYogVGVqB3VXTu9BMG3wh6qo9frL3V8qbx/Q23OlQM5EzkFqmFAnKLmqOYDvErNI8rFlsWoUmETImbHBAL4CjLtxpFgaMEP4T0m6LH37ojFcvPQ8WtifSUHr+tI/McYlBQvQ+qtTuVoaGuWd/qhjgVnn9PAMYeVCdgx9h0pB1nl7zzbuggzrz/vIiP/8zny31IDVB9NCVXxkZch5Ji6yK4Vf9sbwzXKyfQE4vqPbd2M82+c1WuokRTPEK2gvMbYOJfZJoCOd5XJhUKRwn+Ab4Tc/nJGACUvmO2yB3UpCLL90+a4nyUGKOkzQahOqX7C25TV63b3rdl0vo0EtPXGQ5R4QzNKGeOIL33CHFCau+1d4Dk87Fbm21ECEq6ONJWC7Tsu/cB1r9altknnmXLUnjgSdJCrYxmoiu9yGd022Z5DM7gQd9al
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the ptdesc APIs for all page table allocation and free sites to allow
their separate allocation from struct page in the future. Convert the PMD
allocation and free sites to use the generic page table APIs, as they
already use ptdescs.

Pass through init_mm since these are kernel page tables, as
pmd_alloc_one() requires it to identify kernel page tables. Because the
generic implementation does not use the second argument, pass a
placeholder to avoid reimplementing it or risking breakage on other
architectures.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index a4b1b329c23d..72a260007996 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1420,7 +1420,7 @@ static bool try_to_free_pmd_page(pmd_t *pmd)
 		if (!pmd_none(pmd[i]))
 			return false;
 
-	free_page((unsigned long)pmd);
+	pmd_free(&init_mm, pmd);
 	return true;
 }
 
@@ -1549,7 +1549,11 @@ static int alloc_pte_page(pmd_t *pmd)
 
 static int alloc_pmd_page(pud_t *pud)
 {
-	pmd_t *pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+	/*
+	 * Pass 0 as a placeholder for the second argument, since the
+	 * generic implementation of pmd_alloc_one() does not use it.
+	 */
+	pmd_t *pmd = pmd_alloc_one(&init_mm, 0);
 	if (!pmd)
 		return -1;
 
-- 
2.53.0


