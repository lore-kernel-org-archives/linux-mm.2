Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7E2CD46C10
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 22:41:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C78B6B0005; Wed, 28 Jan 2026 17:41:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59FE16B0089; Wed, 28 Jan 2026 17:41:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CC136B008C; Wed, 28 Jan 2026 17:41:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2E1026B0089
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 17:41:08 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7469BB698
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 22:41:07 +0000 (UTC)
X-FDA: 84382844574.13.1D1E9D0
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id E607C140009
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 22:41:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mFST8c23;
	spf=pass (imf26.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769640066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T7a9RbCOrROWoP016V3+zUrjci7rmnK6fuyJb7ZGpEk=;
	b=7osfqkexI6RdbCercqwydN0UPCkl9dD9ZqpPE1+/hgqdZr4pSKkg2GAN5E4CbN6juBzKUJ
	n+tDroChkt4j18gz4PMEh3r0umRsYWq9icukrIsQ736Z9nyp6/2N1APNk0yRu0xxb3uZdo
	aIxb04gj6oYxY8QEGUHGkPK/zo+jYsw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mFST8c23;
	spf=pass (imf26.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769640066; a=rsa-sha256;
	cv=none;
	b=aUpk6Hd86qRXxWzWIFYHM1oitZWPGFoaL58srhvM2BzS6P49/gQVO7uK+DX01titfGUmKW
	DscZy+EPqKIneyn7+8pLWCArlGulWtmlc/rVEChQicXPrhHZnx10o2DtXedAJVp1eud7LM
	uAUklINhkTSRMsj7O/pS/JKU8SciziM=
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2b71557299dso454457eec.1
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769640065; x=1770244865; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T7a9RbCOrROWoP016V3+zUrjci7rmnK6fuyJb7ZGpEk=;
        b=mFST8c23ymaSm0y1tzTscalDB4kQgmoRUO+6bIsq0N7bPtlO/gYM5L7EohLxsPGOoA
         ONGdsAnB9KvbRMS7bRYjo8oRHv3QZAGc2HJbuzO2ihByGL5299TU2AzzwlgP34C60gwr
         Qf9KVu0XFRmvXdGzju/QRVVAMkKTP8Qyrc0zUyZzrzc+Tk9TwHtT4j2/sIK+s2wrfL5D
         TppjXQcqWNJIWYid7FOKlBaakJ0lrgajLm3uM4YafKY1ZPwIvWH04eP3DKkxD2R/GiCU
         MkXZOJn5ATd6Z4gXSFKc9nFxmCs5BQUtMQ09sk1ZLd0mvObZeBt9/eZHLAHV5tQ2WaiX
         EdfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769640065; x=1770244865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T7a9RbCOrROWoP016V3+zUrjci7rmnK6fuyJb7ZGpEk=;
        b=bW+gO+ND/AeerPkN0ANGonCoDfTjEDABbJ5WLU60NzSLmllJRPb9OvIE5/KsZUkU8X
         tUVzpyEFN2BXRKDtvml2yPOrymK12TbysHUPs9eF2YMxAVIdPG8R2ybYxXmjd3ai/pmw
         H3pxFkL/soWfdB1EkBsj4zBJyxM3WMKPMYAP7BPsdE8cR9sZTXu43DBpFc4gkeOQc1pO
         LtJXgkSVOsydfDceb7vsFHi5p0IEklsjN9AkEFxj07oDIzoxpW2T49G4F/N/M0NTZ9F/
         djTgHIlNsGIiv1sIoq8UDTAu9+NV6srhjlZ9oKUd7ahXsOSCg7eP6cG2jMeWB2eS9OYa
         TQ+g==
X-Forwarded-Encrypted: i=1; AJvYcCUNOFT566AFxOYCKc18EEg+20oepuMAAj4Hce6dB1WZAwvQ6SULmVmz1A20FWw6bSysUQcjxYO8mQ==@kvack.org
X-Gm-Message-State: AOJu0YwfKxYTsk/Ip3Dyxe1xXqLeCmc0jDIZXdltVwXFKTRfuXL/UI3h
	2RP+n8hOsFQv0nAS83UGwGkhwtDJxdNDfZ4zyg8+FBC52GTRGWA4KZ7I
X-Gm-Gg: AZuq6aI0XQQXNck6W/FH0F+X47On0ceCCo51YRwkYIasdYxd4idNS798bD296R3fLwN
	auKU7cJI2s+JwiwG6wybY4gxQOMD05s2gI2zJQ/CM/20uB2yC9htRbVS6Mi567yy0CMfv7FFU8m
	RPWUdMlkQtK5R/tyxTL3jIptASDgtfzgbieE8qY11PHMbjBc/1ldA839Tb4xK467Tlxfzm1FLEl
	P7jt4rKJPMjFN7Abb70hQr900HaUUnZkYsZX+f/R33rCfJXibhHomU03KJDuQWczkpJho0h9EF2
	JzMEK/FLUvFx2+Fv+MGTWyGIEEeEq+AkrNl14TV3uvyDSPB/nsErKLsXO0FaRObTA8OBLAXl7iK
	hWJOtGeBA+5AmeP3XJZ5BcXcPV0vU1c7mJYrX4CwMa9814DeyR+g0XKFTE0y+tdNFYjXbzzsUaS
	vNurn9idTnoHIqLh/x5pw4nKA01bQMnfKWx0JXE2qYjLE=
X-Received: by 2002:a05:693c:2c97:b0:2b7:2908:5aa8 with SMTP id 5a478bee46e88-2b78d90fea5mr3323304eec.10.1769640064697;
        Wed, 28 Jan 2026 14:41:04 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-2b7a1abe57csm5439115eec.22.2026.01.28.14.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 14:41:02 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v2 1/3] x86/mm/pat: Convert pte code to use ptdescs
Date: Wed, 28 Jan 2026 14:40:47 -0800
Message-ID: <20260128224049.385013-2-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128224049.385013-1-vishal.moola@gmail.com>
References: <20260128224049.385013-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E607C140009
X-Stat-Signature: r69gc85tunp37wjyq73zi3gzefb98ohs
X-Rspam-User: 
X-HE-Tag: 1769640065-876271
X-HE-Meta: U2FsdGVkX19mG77qXjxO6MapELi17nP/jB7rNsGBx+aj12ZDEIq3tx9gGVsM6TgZ22ynIAygTZ9gmreGrGubmp+HrUoIZ+Akw56FKaiqC1JmUT1y0q4hQr8B65VfRitqDjpgSXikT2NkNEbxZsY4iB9w4nc0UD06795reIhUKyfcs3gcbwSxJBcO96HNhBScMiyQBFBCg/HDPmkf7hC29TdxWwtCBFstFOwzOfJFRF8eufPA44RZa+gyXTmKNlZEpt7RbE5fOEIIDqraYDfjwP2VU3y6BkP3qAfNuCnLLYg38BQaoDlJj/e3D1oBhT64fths+4s7i47hg719b5Id734lMeojKZiBQNunBjvMItKeyKtCvN/IHlVWbGOAyfWk8UD2Etjpd8w4bmOfs4XlCDf2cUY+FaYkuaWZPpwg6+XH47In1AcLHnnVe1m0frCv7FNVvaf1sni0gL79ew9Nzf8WjEzJxzHc5FECQ31969uxNE5FydEsrebOG1n2D/jUBVj03FbL1TFW1DEB0ue1e9xvzoQGGovyUv0u8Kn2+I54BQ4e+UsrhYZIdWdW1tC/wWcB5eP/7RCy+wtwhCud6KSt6K6CdwBg02n3m4Mwnp05Q38D2OXvVXzkfqvNwZpPfI7cVEbdS88cjhsXRKlZ7lZQSfnKxy0YG7F5hB2F+ui9ijKsk4J3QLvaypC9xaULAuBh4WBO4EoMeVuW1ubKg7M8cwDGjp58ODt7vbmLICjSVdQdG88sjNx8XNsYEu6hYuTzalhoIm9knIJkP09CtQmGDnJ4I/5gEcrPC+JYLysiFMNFpheX5XIDrirV0/fy34+OIDFvT2z7AE9GEEOQZ5pqO8wy2pRdrResdi9E4kMJiG+au8vWseZl4I1HNEpwlTJ2nR6V+LUjTQlOloXN6t+S/7Wyc2cK2q7Uhodp194GE2w8Z6ZdMrP4uzO6p4Dxny9xHzMrGLbvP+fBjt9
 tgowtvEx
 +XnbPy7YigpxIZVnnqtBu0r7WlzmycO/M3QtV/1aHknbRdspk5rLqOousjDlyOuZdlhO5drvbhBlMsA+CVCrLOVpyxnxG3dTC6aJxR0vJLieIjtj/PCjQSrWqDi+8XOi1V6H0efV4kl/R5uwDPoL4kmwfO2HkXgJzmbn3iVg3QsKPi1rV8IRz/+DV2dIrNvqTjDq4tM8Rai8oy+YX81GBJBoKXYdjj2iBZSjtnmUVmH2E2JBom4mtlS/aFR9KoUeGF3vWYjGxCnyxuje0lCtAGCZq7b9ctu0jvJI7g77BFbyzuxfAiiHHSEIVBSCqFMA+Hu6lb2a1gXn2C1yj0kKubD6ks7cvO8PaothO5E0NNCLxSCwSbNe4t5MQr1BMdbgRtpPGh4OoNWY8jYwuHQ1HkTExI9rbsYgxYBIER30wms/yoZoVOgos39+nmHWLxJvea6jVqTCORlNAMcDNhHuENwkprjqwDjovoTOkA3G9jch2yOvBTJAlL+kMUA47FAjk7BHq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to separately allocate ptdescs from pages, we need all allocation
and free sites to use the appropriate functions. Convert these pte
allocation/free sites to use ptdescs.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/x86/mm/pat/set_memory.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 6c6eb486f7a6..2dcb565d8f9b 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1408,7 +1408,7 @@ static bool try_to_free_pte_page(pte_t *pte)
 		if (!pte_none(pte[i]))
 			return false;
 
-	free_page((unsigned long)pte);
+	pagetable_free(virt_to_ptdesc((void *)pte));
 	return true;
 }
 
@@ -1537,9 +1537,10 @@ static void unmap_pud_range(p4d_t *p4d, unsigned long start, unsigned long end)
 	 */
 }
 
-static int alloc_pte_page(pmd_t *pmd)
+static int alloc_pte_ptdesc(pmd_t *pmd)
 {
-	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
+	pte_t *pte = (pte_t *) ptdesc_address(
+			pagetable_alloc(GFP_KERNEL | __GFP_ZERO, 0));
 	if (!pte)
 		return -1;
 
@@ -1600,7 +1601,7 @@ static long populate_pmd(struct cpa_data *cpa,
 		 */
 		pmd = pmd_offset(pud, start);
 		if (pmd_none(*pmd))
-			if (alloc_pte_page(pmd))
+			if (alloc_pte_ptdesc(pmd))
 				return -1;
 
 		populate_pte(cpa, start, pre_end, cur_pages, pmd, pgprot);
@@ -1641,7 +1642,7 @@ static long populate_pmd(struct cpa_data *cpa,
 	if (start < end) {
 		pmd = pmd_offset(pud, start);
 		if (pmd_none(*pmd))
-			if (alloc_pte_page(pmd))
+			if (alloc_pte_ptdesc(pmd))
 				return -1;
 
 		populate_pte(cpa, start, end, num_pages - cur_pages,
-- 
2.52.0


