Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB7C1CFC29E
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 18:55:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C05A6B0011; Fri, 21 Nov 2025 13:55:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AF1E6B0027; Fri, 21 Nov 2025 13:55:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24EFD6B0012; Fri, 21 Nov 2025 13:55:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 119B86B0008
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:55:45 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DD8B5130380
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:55:44 +0000 (UTC)
X-FDA: 84135518208.24.50D9D3F
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4C8A640012
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:55:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=N0xVb90S;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763751343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zLEh+v4goIHofpOxJTSOvne0xnDbCpiZkI74Ux8pr/s=;
	b=xvdfGahi6M/MmqhsVg82mmiZdiEIqjo2pYcpHX0JCSAnQVCT99G1VPJV1fH1F3qasQDX7l
	5m6SXMOGm497VbvCzgbi+EvAMWvR9VU82GjVLnfHRxBCS/zA0R9mPBj1yQ/pl2biOnZIs0
	4yJ8d+p3aiQO64+E17r4wtAVBzzHBYI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=N0xVb90S;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763751343; a=rsa-sha256;
	cv=none;
	b=dUtZJHUKYYPrRJ9lyt6cvhBsYJsF5LentsxRxMv/VY9vU3J0hPwUY9yFF0gbHlDPaeOLCh
	cHSXdH1erNxSrQhCaL29wDcbmc5sP2CjIRH46V/X6epWXp6WRZ7Hgyu4UJGdJNWzQ3yApU
	c791tdKdZwA+qXslrPCvsDAW1FAQ9Rw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zLEh+v4goIHofpOxJTSOvne0xnDbCpiZkI74Ux8pr/s=; b=N0xVb90SQDRvyVlM14+IH8E9tu
	rx9eVc+ScW921gqJ9dMnmurdZsW09ksnJb4S0c0zQGeUCV+T96XA9U1V7EX4nSlLEWs6k01PPdLui
	9NRDp8yu1/eS5g2Z3wf17OUbwMCvSF4JePhIGL/eV1cO3WysK2xsGCZmW56E2zTjTOq5CUoR+sQv+
	tmISLBQQZ4PPSWzLVCwdlIYjGU0CvS/543klKnDAwdydsBt3QtLCxPnuewFd+TWTJU78fLQ1pzlay
	pjAqlL4udIHeAx2do/XIj+CTx6LMWVWMvp2lozHyVoEjppiQ/ktuRcMx2FCKj6fmGlD9waMW+fapY
	PHkHY2ow==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vMWI9-000000003i4-1Kky;
	Fri, 21 Nov 2025 13:55:34 -0500
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	x86@kernel.org,
	dave.hansen@linux.intel.com,
	peterz@infradead.org,
	kernel-team@meta.com,
	bp@alien8.de,
	Rik van Riel <riel@fb.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC v5 2/8] x86/mm: enable BROADCAST_TLB_FLUSH on Intel, too
Date: Fri, 21 Nov 2025 13:54:23 -0500
Message-ID: <20251121185530.21876-3-riel@surriel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251121185530.21876-1-riel@surriel.com>
References: <20251121185530.21876-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4C8A640012
X-Stat-Signature: 4jh3fuzutgtt58w3o679kybhm8bhm4t6
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763751343-825118
X-HE-Meta: U2FsdGVkX18ALcCpB4quDTdNngsT2MreMkdEPWX2wXAsl9NtkEUBf4rK75IASk2rRQTSpbCzuH68fdWMLv0sm9dCUuqKrlcmIi32cCol5qvAwb6J3La5lQ7qebHddwR4w9QlFb1muNIIa3eqZax6i7eK+LsuTvLBApLsvOHAaAqFkkAaQYg5Zeo+Od7j8TIgOF7A64CKDpVILZHgDqHR9osrVI7J2yuDYyAf0GmdBtLCYhajLySLDPt63LpOmL5V0oSpF4tPyDoXmFUVmsqHS7Fo5M8GuXnRQRj+mOpW7QZxMuOt1oJQSkyZeSiwUx6yGv0VxnZaV9OteVqd6i1FpqLSYZzUP4ue1DpsWzWf7qwUxqYNwmisEq7knwJyoyAnlhrFhUcn38wGDAZ1G2g5UygA+nGiRPIGCrDn1E2HYryVmb436KgG3MmVKekzpsQEw64g+NZitCXfRar7fv4iiaOd/hGqeSEuCITSBNKuPiA1e2F0jH1ifKYKmeYy27skToH2p+zRVoUGCbRdf+NuIumZJtlD9NqLvlhZ0pGhAHGqmQEC9NxMesH0f2MjqpVVVl/rOo5k97Nn2q2UF6Eb9QbA0iAIlsNN2v52OYiing7HvbBrswWsCuq6dF73qvQeqD1TigdZ0jB8isZTnFbmgou6IGuvvUcPzljoIGxOv3M5dnPrD32AvBvK3W79002v2WVMf5MynKk2HTDXlhYYZ+0c8EhgitX92ugrXzB+8IVt6WFUkDVRjbJM095kyO9PBjNsmNhC69ZUpg/2u7uiT+c04Xr2Oo5uffM//b139jdwMdiXh0yfifMH6WNSD+gOF6r4gEgGzwCvPW55g8PwJhEz0It7Z2REcSCOAXoY0VUKfK7KLYAcGwCZt2HM4e7zmt4bwddrLWwa1ZasL2bkHSoBsZlA5f7LKEvyGRXI180VCrxflCMExpWyiG5Hy2KQJT0pX/Gc6uxf+RiQWEV
 iMUpg0WP
 g7nEhje7DRQjGPSx+s6ZW2xc+wvdcVMu+31A9ipYswWT+09+JPMsuCHw2H549o79WsI8JzxOrxxTQgfqlROV0lmXYhVlo3aN9DYWvieWJR1x4TG5IGLhsEyJ6gzFOQ/WAZMfp3mSmuB0gwzb/mDMoGU7ck1xZzrO7YzqqrLaEtnepJwNU+lwobAfyTJ0aN2A7F9pxYt03cfkKjarPTP15Mivv/cWAdVI1k0G8h5dmOJnhH4U5rs9Az9WmKDIkWWRGOb2hbjYLyzCDCq5uvb2TbOwoQzuOgLowpYWxWIOrTLRFUvWOYqz/AVnuMCGP9BA24yZ/j6cj8aVgqz2ZGaBL9iYLqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@fb.com>

Much of the code for Intel RAR and AMD INVLPGB is shared.

Place both under the same config option.

Signed-off-by: Rik van Riel <riel@surriel.com>
---
 arch/x86/Kconfig.cpu | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index f928cf6e3252..ab763f69f54d 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -360,7 +360,7 @@ menuconfig PROCESSOR_SELECT
 
 config BROADCAST_TLB_FLUSH
 	def_bool y
-	depends on CPU_SUP_AMD && 64BIT
+	depends on (CPU_SUP_AMD || CPU_SUP_INTEL) && 64BIT && SMP
 
 config CPU_SUP_INTEL
 	default y
-- 
2.51.1


