Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B968D41C1A
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 10:26:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 682EA6B0005; Thu, 11 Dec 2025 05:26:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 659A26B0007; Thu, 11 Dec 2025 05:26:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56F056B0008; Thu, 11 Dec 2025 05:26:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 486B46B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 05:26:17 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BFF3D16083F
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:26:16 +0000 (UTC)
X-FDA: 84206810352.01.4CBCEEA
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6F6E640008
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:26:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=thingy.jp header.s=google header.b=mi8c7GWM;
	spf=pass (imf11.hostedemail.com: domain of daniel@0x0f.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765448775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zFsNVH+hcnTF+WLyrqw+6YJkD+G+rP7K/L7LQLfciMw=;
	b=gUjg/ut6Nx4vmyFMZvOoT2/AnRx2moyKwGoLq4FqZYNrfgXiPAkmLO6cUB8u2Y0Xj5f/LV
	VVQp76CBxiK7c2CUNRwCFTUTYth2VE3a9tbIpa04DhQCRZ02WewojYd+xAn1ZwUbFR88qQ
	gSm2jD/qYqqbN2pRyX8/B1nN8IFFgGo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765448775; a=rsa-sha256;
	cv=none;
	b=pKzRdaSRMTx7UGANdz476c/562XZg6msgyiSz1AvmASt9dzVQqqKqCHUkNiTTYjdk9Jm3e
	nvHoH/krDrA84sFnXe6XNn3vkKpo3E0OeNvOY6EMT6NrElC+lwS8ChwdF25S74D+7Whki/
	U5B/rf32OnIgCV7+9d2RRkJyQ8mlgmc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=thingy.jp header.s=google header.b=mi8c7GWM;
	spf=pass (imf11.hostedemail.com: domain of daniel@0x0f.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-29d7b019e0eso10903435ad.2
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 02:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thingy.jp; s=google; t=1765448773; x=1766053573; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zFsNVH+hcnTF+WLyrqw+6YJkD+G+rP7K/L7LQLfciMw=;
        b=mi8c7GWM3vShOvL7c0Lal3+IILTJ603l5uYG/DbzuJJEQ42k8kiPzCz8MeOLvEHROb
         rZRlUIOBTcWNbhgifptZT0lCvPcd7LDmoAgerC9ucBQ3+iTF9rXLSKkZT0XyCJs+898c
         2GU0mgKZUL3fOB6+T2R93XxP6FKZRoy5jtgDw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765448773; x=1766053573;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zFsNVH+hcnTF+WLyrqw+6YJkD+G+rP7K/L7LQLfciMw=;
        b=G8HLQDRFnYsnLycMvRaaulGkH+XvAkpMCgy1jR1p7LfwZ8r/z1qaKyNiCU4AxIddPo
         vTvLiNDgk7oHtlWypVvwFufu/9BFJrexGgfBgHV+y34PrN9vCSpSCSzlFRoJdLEmZW38
         CT+NQ5pTtBVsYW8/T2dm2KAUrGUPh+cX9gbvE1y0AcpIN7CPxywVq6kghw/u5QjNqsUr
         1ZzE/mQvvnBZb+p9BLaxa8oM4DSbnPDl31A6dWRytQp1oBLnNg0AnkXmuKL48U8sjRBS
         kf9ZEDiYxKRXNSZUPkep+udc2vk+8OFiccdS7Ck+SU0F8PS8cz567dhFGmfaNPlBvWao
         evhA==
X-Gm-Message-State: AOJu0Yw00PMMv7o9kJnBzGaELSX9JKTChQQhg+tBnbhp3roczACyB01J
	9dS1rZ8LQGMXMkGIKmgWssTlKgfNd5YdK83vde5OkMieOzpI8jVSfAcimn9PIuUPYfamQ4ro17q
	S4TIk04g=
X-Gm-Gg: AY/fxX6QX7BFo8n4ldHTF0F/VzN1YY/sZtqNZpJ+qPJRCBg0aBXgNoWPX9rwGsRbWOu
	8Zq6v5vu+wdWJKDNd2QFdaG77gCXyeIOBNoH/uayyGDrw/OzYwCJ8SYKlydvzNEoi0xjLjB3W05
	KJlAiVxBOiiZ5FEzgqgIn0MxeJL87n/U2N9j47oUTmXk/wt9V6zYXEYsmXXSGHBcsrQJ3FJUCCk
	FN3o994w55nfPPm3lkM/oa0IzQDtFlkG2o30D8iEI1Cwah3/SS5QqComiWR625+w9B8uknWyxiq
	pSwi2rTC2nHYM+6DkFMoGnOhRuNNpn59zRnXiz0NS1JadIdysTKAMjRuyy2OWC7h1YLZMelKPTp
	brFp6B3oH2ZGBynQBuGStESp1VM+ga5sHfi8yuGGIBzlffZYm4VRZva058oBESxcWPNUyMWssgy
	ZTub7kyR+nPoaiCxWgTMhGRgWT1sNjh1bNqvI4D/jcrI8Wmv599hu27w8u1KG/R7OsB0Btb5I/r
	6s=
X-Google-Smtp-Source: AGHT+IHtxJuTKPpxeSlCS0VeV+tpw+BbRU6MxR2kKYmrWqgxv0hJ/sCDXnxbVaXlm/7z15urdp+U6g==
X-Received: by 2002:a17:903:2983:b0:295:8662:6a4e with SMTP id d9443c01a7336-29ec27c15e3mr62125785ad.47.1765448772723;
        Thu, 11 Dec 2025 02:26:12 -0800 (PST)
Received: from kinako.work.home.arpa (p1344243-ipxg00a01sizuokaden.shizuoka.ocn.ne.jp. [114.145.20.243])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29ee9d38adcsm20759115ad.30.2025.12.11.02.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 02:26:12 -0800 (PST)
From: Daniel Palmer <daniel@thingy.jp>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Daniel Palmer <daniel@thingy.jp>
Subject: [RFC PATCH] mm/page_alloc: ?nommu? Deadlock in drain_pages_zone()?
Date: Thu, 11 Dec 2025 19:26:07 +0900
Message-ID: <20251211102607.2538595-1-daniel@thingy.jp>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6F6E640008
X-Stat-Signature: tzpri8otowdrkcdd86ata9hugiiozh1z
X-Rspam-User: 
X-HE-Tag: 1765448774-221357
X-HE-Meta: U2FsdGVkX1/jG7/xvkNyRQzYicpZGJ8NXV84YgSteE4AItPz6GEwbxxce171ol82xQN9XNuc4MKqsqsfEe6gqc+afw8Y43uW1HRucGV5SPk+1Q5I7I4ROc/XdtxTNX7PRAxczDtDX9ZJbKMwVhbjGuvcMrYZxx2PU2UV1SVzfwfziYKVTAOyPjBlpg6uyOQLO7C1BX6LLiyj4wqbPy73MDZLJ+sz3EznmIgpc1tA3Np9AnPQioG47jd1qZiQLxB/w8NCxNsOSQDRE0gOIgJnIifseuSFl3pnkmRlNv4tvxcGM/eMp0LPzxcyq5rWKCFc9vfk1eCFg3npPMLtVHCvRVm8prw5MKyZMB0u7ULW9ttGUu36KNX1Z1secvIST0I3+5wR+9s5Vd2xlSPbGAbKXB0BjqYUcyrUvx//7RREEM98hOSTUuRADCa371qXHs0aTGacR9TOq3TLkcGDuPULIwunnA+TYpQjyEFliSpZfRQ6Q9BFSifsYD8Zb0xsiPYrurzHKaovg1jZezGB+KenT90oCo3fhKUC8xYDuJ4c+DWGN60DRV+zC7t81vMRc6lRbgloGo1xKDRhcWPBPPJDAEX7ZviMj+sM5/UkhPhQMMYAbZlxdlDm2Zq4/j8pbv7EGd1584vPdZeLk8ElHCM6GMEk1LyCmrKpR8jiiMQCBWppk929RFGFJr7RBUq4WMDvNCWVPTiiX7g9ScZa3oqPyW80RaX02b4dsZBT9a47kCFTprRAd3pzP7dBLeTvTeqzGSaFmoXWGLKrBgcyHGFtNBseuikiEEnCGc6fUqNo6vB5Ra2134DkFLHePw5RS3k4KjrXhTiqFFyPgQkPIlD4XchWpb4u/e1nbprZTSV811/Xa49z2GfXCcjy6MjiZFx01duJXKg1gYg9j4NsqtBlKGKpRSZcRWUfMhRSQcgmn3WDLfjiSeG0MtVZlKTgIYR3CXbaw6ZMWunue+MRfMd
 dArCaA23
 hSnd3jkvIPM8nZFkGS7G1GducWtC6yyvsW8wBYI1zMmZCtTflDLBFlOGHNdeH+ufK5DDMUpwqZAO2idaZGQUc5/9r5ZZTayzbIjVSS4B7TXZmQxsbWc6QGzhSQZYWkhRvsm/LafwhF/IMSMkuCRu7LriE7o/doQxAG+T+8MrXaOcqf/pg1QtmnYgnJo0NGVq7xTJJ651SkfOOlqjcUtJtRZnXQJXbVHo6o8CrgOCAMwfz1TxN0LoRPfcQBg7DMVjRB8CuLnSb87uwk0qebvW/RUrLmw9PPHHiCyBiGe95Sp1yIsAAop6Rwe4o9azwImDz0YkmgN1GApC4hixL7OKSf2KCzqzd/C2gvIw2+J7pAt4Xd4dHRxWF0MEucSLlAex8HLUmTNCdeid+1oMsGWs+8fql4f4yPlSnVzIpewnHlvOFNx5tezGUFejyKTSlj1eMlkeS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

per_cpu_pages_init() sets pcp->batch to 1 (BOOT_PAGESET_BATCH) at boot,
then later it is set to 0 (from zone_batchsize()) via the following path:

init_per_zone_wmark_min()
 ->setup_per_zone_wmarks()
   ->zone_pcp_update()
     ->zone_set_pageset_high_and_batch()

Once this happens if an OOM happens drain_pages_zone() will never return
because count never gets to zero.

Signed-off-by: Daniel Palmer <daniel@thingy.jp>
---

Background: I am running a nommu kernel on 68000 with 8MB of RAM,
I messed up my userland config and the resulting binaries became
too big to fit in to the free blocks of memory, OOM should have
happened and I should have seen the kernel trying to free memory
but instead it dead locked. Since this is nommu I thought maybe
I am corrupting memory but I checked with gdb and it doesn't seem
like it. I have some local patches to make this weird setup work
too but I don't think its anything to do with that either.

This change stops the dead lock and I see OOM messages instead as
expected. I have no idea if it is correct. Patch is simply to show
what I am seeing.

 mm/page_alloc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 822e05f1a964..83c9ce6f93ad 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2618,8 +2618,11 @@ static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 		spin_lock(&pcp->lock);
 		count = pcp->count;
 		if (count) {
-			int to_drain = min(count,
-				pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX);
+			int to_drain = count;
+
+			/* if pcp->batch is zero this loop will never exit, on nommu pcp->batch is always 0 */
+			if (likely(pcp->batch))
+				to_drain = min(count, pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX);
 
 			free_pcppages_bulk(zone, to_drain, pcp, 0);
 			count -= to_drain;
-- 
2.51.0


