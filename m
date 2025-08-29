Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B5F7CA1000
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 11:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AF046B008C; Fri, 29 Aug 2025 07:53:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95E676B0092; Fri, 29 Aug 2025 07:53:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 874FE6B0093; Fri, 29 Aug 2025 07:53:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BE506B008C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:53:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 198A81DE738
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:53:12 +0000 (UTC)
X-FDA: 83829634224.10.29B5455
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6F47818000A
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:53:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756468390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6OZMW45Iucy1OcDGewpUJO5JowXjpqW4cfbiz+J0UBc=;
	b=4zLERb9Mec+go2gBrn5r6GuNFjZ/AUBoi3VC8uZFXJkwjio3r4X11zNTvvWVDuh/OkSrJQ
	1jhfmkz//oc/KRHk752dy5BXAd0q8ns7HCbtveb9OKCnLmu2aPJ5hgxfnR7ZlDCqZQJUje
	WCPs/4ZS245hQROJAHXEf0ZJ+ugPkoM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756468390; a=rsa-sha256;
	cv=none;
	b=6BGpDguqc2fpcWkL48QEN+rispIWJsRLE/nWcHST5W/huloU1J/v6kuufpRmw91VIDV7XA
	u2JyR/U0uiaWq8+0WkRft0ie/mMH2At2LsV3MUJnHsRaYJnhmlxwKibG24Tt/ouGdllDIS
	+AUKbm+n/COgbErShgUkYUkcHqCmxfo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 071BB19F0;
	Fri, 29 Aug 2025 04:53:01 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 536283F694;
	Fri, 29 Aug 2025 04:53:07 -0700 (PDT)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	scott@os.amperecomputing.com,
	cl@gentwo.org
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v7 2/6] arm64: cpufeature: add AmpereOne to BBML2 allow list
Date: Fri, 29 Aug 2025 12:52:43 +0100
Message-ID: <20250829115250.2395585-3-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250829115250.2395585-1-ryan.roberts@arm.com>
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6F47818000A
X-Stat-Signature: 499o9z6qhotwccie4wkprm9do54tk8o1
X-Rspam-User: 
X-HE-Tag: 1756468390-32260
X-HE-Meta: U2FsdGVkX19j3yDh0rFumsIz35TMovpawKD4D4Vn6NpjszRHEvvMO4++jWSQljQ7ra7oclCB5P1ZbdwRt/k4IWpUrFsV74SOUbP9IjyzplgAmOE1Q1Xpn+p7WFDrta8TpnxKfmTBAspoyujTALy8KgU3PiEcSBspyC2DnUh/i00h/GwoZXEGCpXMYXrAG3Us0yDUE9HRatAULuQjDm5SIAptf2dOaau0CV2Ia40kmMg9U5tMVEKT1ekfzwaEe0xWRWGmk0PcQ4L3SG466WcmQcPcOfaagLecCbl/ejdIWECx9/5+iOmB8MnacvJ+9lgNnrRWfTDrmZMBxhmL7DsUpWAtNPmJ+CsZ6lo+iqYCoXCQVc1z6PIODUucmyhu7Kq1TmEyfpMeufJk7uTI0jRkNz3Dp7hcuZ2tgfKHcBIip5k6dEkNM+XJ5u2f3VIb/DS5FmMo138mY9gcRA9eveGIPBK/hX2LEoRl2+lHcMFMSJbjYGRHhQl4xN6G3NJoq0PV9Fc+MLy6PA+fXHien1X1zNbrV97zPbV0K7JwHZoxDCajZC53hWgSnVUg/RNc2+rNqp9Yu6YZE0OvMFnGFhx83ibW+gSWuJ5O2MtLpiujI8boaZjwL9ddgBMe4EhWGC5YaYv+ZUBAX5XrOAGFF+0xrpZ6GrqXJz91ChV+2bNr8KP/EGp0XGpDleyunonGsaKV9JeBEPgtgId61+ozD5+U4+pj4XXrecihzpWalY5XM0v3W1sGhwF1FCnxTcgBJmlm1gYVGOHbQzfYnep47rHhy9zfpmu5HQ9jx7tEZlyYQmPdofb5JoVbeUceROVVFDf7vyefCooM/M2fhn0HFz9SK3t3a4ThHAKFlGJLqgtODHMOb67JsiKTYb6IyugeGftOHQ0t2VtJfwV2wr4HLLF14pV7NNZief/cwTuFw9JhsGPyWbr85TBmCuiCdEtl2nI8H6ldNlcYgOsOmkC0bbE
 f2gcD+Zo
 XRT4yyt2p2sj2sSkBpBKbJ2VnWZXOj75UMlA4EzfMyZAskmJC8XKb3JqXuE3Dz78m+paO31WRXncM1qMBGcUQjQ2T6CzPFdkzJWSnsgxu+g+EM461xjbehfDKsMGRYUPMBnAXrsxhLFfO4YVJ8alKXW4IZVWEC0Fw4f6Vgmsx2noLMns4Y3oUggy80lq4fMlvSJxMaI8kglCjmIq6lxmFh8h9nfBVrXxu7q8tX5NKJNskwV13SWmlNTz81Mr/FGUKIgDggZ1RFxqVYZ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yang Shi <yang@os.amperecomputing.com>

AmpereOne supports BBML2 without conflict abort, add to the allow list.

Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/kernel/cpufeature.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9ad065f15f1d..b93f4ee57176 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2234,6 +2234,8 @@ static bool has_bbml2_noabort(const struct arm64_cpu_capabilities *caps, int sco
 	static const struct midr_range supports_bbml2_noabort_list[] = {
 		MIDR_REV_RANGE(MIDR_CORTEX_X4, 0, 3, 0xf),
 		MIDR_REV_RANGE(MIDR_NEOVERSE_V3, 0, 2, 0xf),
+		MIDR_ALL_VERSIONS(MIDR_AMPERE1),
+		MIDR_ALL_VERSIONS(MIDR_AMPERE1A),
 		{}
 	};
 
-- 
2.43.0


