Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B14A9C98311
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 10:09:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7C026B008A; Thu, 24 Sep 2026 06:09:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C53706B00AE; Thu, 24 Sep 2026 06:09:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B42C16B00AF; Thu, 24 Sep 2026 06:09:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 905EB6B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:09:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1CAED1402EB
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:09:32 +0000 (UTC)
X-FDA: 85248233784.01.8EB4F38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7BFCD1C000B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:09:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dnSLogll;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790244570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T/L8GH36WphB4FWEap/OQWo2XNq0RD33mRMiQ8zqE3c=;
	b=BICF3AYl1QhPWP1A0jgntSfOf7M3VQ8Gh13myqEimy3EilQdrIw9PXnWGS1C3t4A3ve9bi
	Z0LW8OotHOr0BtUcGhv0rkgUFI46slxMlCoakilapfO2VObN2XstzVKOX8Fhpavw1qCbtW
	TaXo5h4G/apQsirgXoP37z4bp8CV9aA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dnSLogll;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790244570;
	b=1//CvwjYGPC4GTOqAc/9HWedbirEy3bdtRJgWqtjClCTJmzW/n8f39fVWHmswtumWAesfR
	ZoYfeCafDL/QwmtQ6ppyHPiiW137jZbowg5s6U1/fwGZ5kMPwRRmuy6tx2yOA+uUMa0stQ
	5V4A4g8Xn20pOtG1MLwb+S13dbEuJK0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A1F2C43D1F;
	Thu, 24 Sep 2026 10:09:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507301F000FF;
	Thu, 24 Sep 2026 10:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790244569;
	bh=T/L8GH36WphB4FWEap/OQWo2XNq0RD33mRMiQ8zqE3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dnSLogllfOwGPjiiYgYeYNLUbV922KBGPQBr1iWfsc0tB53dUpUKxf7Bdtcpcr3bI
	 N/yMdNt2Ov0UkVr3MhgwO2+hKGw0VJvasN8PtaGsg7DTl5Ql1ufzTr95NdJDCRfBOD
	 wRMGS47TdnCWOSqXI+wAq/TqxOS5zw8/ZLyamBfgIKhWLJU98AI0JXzOWvht07ccMo
	 2JB/877rqVQmvUlpiMOQYNo009UWntXGbqTXDczrJzMPMIo32vZaRkqz6B5foRNisc
	 tn0L4hnJrri/j4++dOckyGH9o5Ual1j5zyEjqvpx9L8hqj3USKaRp7UJIrXQt3YkOi
	 q/ADwv496KpUg==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v8 13/14] mm: Assert CoCo shared allocations may sleep
Date: Thu, 24 Sep 2026 15:35:28 +0530
Message-ID: <20260924100529.1398790-14-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
References: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pmosu3wk1m5o86d4gk76gjxo5ka81ho9
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7BFCD1C000B
X-HE-Tag: 1790244570-212630
X-HE-Meta: U2FsdGVkX18QtRGf89lmJDwTKHn/WVmVFo2mk90fBsj7l1Imr8zvHMQIuom6yqXaRACm5sodDgwTxsaCMnv88AN+BPaHIPQaoVbTfg+7IjJ/n+yuhYtMB9CeomQzsMXhzLPcHpE0opKcpejVY4ope9+5jadE2Jf2QVBCIDZulIl0vsGq3RhyFNLWH0EOvE11Ibihbmgeo60vhGGUA44eM+39oVheSNsxvKXgHI6RsGp57LO48QBq7Sl5XixGQzJZC48awhxA5TTSQZ7qHGSWxY6TGxUgoMDWAEr2+oUqxpBM/fhhN74XA1GzY9kRNspZ37crUagrZ+54B02VC/YVQQlmwvjwFx+Go3poLfoV29J++O+F4znV9BrDmTOybk5i810vlt0fvgEI8C6nSg1iZQ1SEDTY4ItPArFxcgdwGtzrSA2+K5dJFuj1DrjdsimFMxY3z5ZrMbOVNgJdnIatXj4ZTvmIoWTfnEavcY9tesRNcZ20K6UG4QlRe7QetyhjLiyG1ywLeNe09DfAsERMUuOjMV5KMbw+VBY2UkucdRZxw3cH6zW2Gi2jsg6jCyKlAMuvtRjrKtouFF9C8eEzXrMOp/qgnXn5c2NJK5d/YbZpqV4Xi4gYu8coBR3xenibhjK+au7XXHDSzVgVn/yxjyrFzDKQj2cS+1HtxXz07veDlhmZHM0h54vHHcpF/UPAwh5IkonLqNu05+aCUKwhW7F2OlMOYstDAzLyD8+CvMJrzDLGw2wOWyUAekPnqUv2uYsCLzE1YhRrjzIpHg3XZfMAZMSuSZt8Oa3SxG9E5xedIyafPLftE9XAProajF4XaKgj45+ZyxM1jdbyQ2RNeraNw81Fbp/8MFWt7xNg1Ss4dI2ViBj9wuO7vkY/Oyh5q/yqopifKUkJybvEguoR9dI5siGl5GcQ7JAbFXyRKLAJi4sibB51RWEl/+EupKOtDOwLTGNjETCR4hlcShj
 TgOO4epB
 INoq/qHpwCi7XLU83getQuR5SUZIL77UiCgwAY8oWLiFckGrT83CBg+XNbMGtPYm6qa/SWLekk06w99Ehasu1r5ShKVRgKK7GYiqApZnlir6vdyMEulG83kp4ywePIMZgfrESn0g4sF6xDaBowz+uZGC2+hXgH5dHp96tFHdrt/ahlDh5EORPZ22ogLQmHq8etU1dDotg5S7u5M51MMAmVbmc8Sr19aFskBTGTAS/+URQVVhsI2cFSTxTOCuqa6DNMr3gwW2Og7BadN1iVqQ0aVAFtn7nENV1vYZRq7OHYI71Ic0vDZ9X6Kkk1ywnPyKcx8Rs2CksYqdlZncLBdidjov0/itHkiWV8QstY5rUZYz9NQOxLtZhuknbdshDtmXtgBKPRgHX59jf7rk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On platforms with memory encryption, alloc_cc_shared_pages_node()
transitions the allocated memory to the shared state.
set_memory_decrypted() may sleep, so the transition must run from a
sleepable context.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 mm/cc_shared.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/cc_shared.c b/mm/cc_shared.c
index 9eb79832a702..6f68a3f44ef8 100644
--- a/mm/cc_shared.c
+++ b/mm/cc_shared.c
@@ -8,6 +8,7 @@
 #include <linux/errno.h>
 #include <linux/export.h>
 #include <linux/gfp.h>
+#include <linux/kernel.h>
 #include <linux/log2.h>
 #include <linux/mm.h>
 #include <linux/mem_encrypt.h>
@@ -106,6 +107,8 @@ static int __alloc_cc_shared_pages_node(int nid, gfp_t gfp,
 	unsigned int order;
 	int ret;
 
+	might_sleep();
+
 	ret = cc_shared_calc_layout(requested, &layout);
 	if (ret)
 		return ret;
-- 
2.43.0


