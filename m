Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49F77606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cHKJSbPk
Received: by kanga.kvack.org (Postfix)
	id 656856B05C6; Mon, 16 Nov 2026 04:15:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62F1B6B05C7; Mon, 16 Nov 2026 04:15:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 544B16B05C8; Mon, 16 Nov 2026 04:15:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 34EED6B05C6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:15:56 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD5D312057A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:15:55 +0000 (UTC)
X-FDA: 85440425070.17.09D6D1C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3F12340008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:15:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cHKJSbPk;
	spf=pass (imf27.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794820554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vl/C5jn+1tPTrCTsFhPelusdvJCp3xW8fwCUnP8k0/4=;
	b=2uAxyx2OAWA5/kPoM2bAhSCs/rDnXfcsdkblYZcyjF0vbmU8IUUTn36FGmYnUUCpYv1F6o
	hGzIP4HYDErlDvn+QOCIDwJrqA717bY6A5cBG15F8hz/l0eQGK9I/fo5bbXXZGEv5sNbb7
	5EAcTLhNIwvLnOf4CeYUY6deJGxpfRo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794820554;
	b=vuL1X6aWxMjVom2ln2WM3Z6KEU4cKL071Yx/R+HUobsmncuAOENUv7wIBx2KLFNnBWM1g7
	NJ/VXAxguHtEFMJxhDa1O+8Zhb5wkfzQwnqhQSktrcPXpjqx3iwAO1fuc7NikF3/Ro1d9b
	tW7VSO46Acr7GbMOy1rsAC6+vcaVdi8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cHKJSbPk;
	spf=pass (imf27.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BB83D6144F;
	Mon, 16 Nov 2026 09:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C371F000C4;
	Mon, 16 Nov 2026 09:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794820553;
	bh=vl/C5jn+1tPTrCTsFhPelusdvJCp3xW8fwCUnP8k0/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cHKJSbPkOmS/vgJzoXZ32XAOeuVSd+4AR7wQLkrcipLJYDsoZKVmhqWehLYzXMbaw
	 R3B/AWlh1S33BLxY0EBupbn4erb2GjPok1Jk/A55GVWK5wNLgVoyr2G0xYzkPsQqrS
	 gEcKCWeL+Dx8daRQR7LlmEGmvbevX+pW1mWsLtDL+aO8GHfANkZfhz3lX/pcDnwZbc
	 UHkMOWPm7+qImQLYnPoIXD7VjI+BnQheFEUtLhUtYGPZ9yo3CCvw5jJbAJwFim9sxs
	 Sn+0K23n/zloQoNpUknUCmfvqa20zhvkh18bHTM68vSbFX62rWnlkpstGAqA6zLKhe
	 SJxi6oLHRkgQw==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
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
	iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	kvmarm@lists.linux.dev,
	patches@lists.linux.dev
Subject: [PATCH v10 13/13] mm: Assert CoCo shared allocations may sleep
Date: Mon, 16 Nov 2026 14:41:36 +0530
Message-ID: <20261116091137.94252-14-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116091137.94252-1-aneesh.kumar@kernel.org>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3F12340008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3zq4dabjgjjjcxkuw75uyxfm8c7t4mpw
X-Rspam-User: 
X-HE-Tag: 1794820554-895656
X-HE-Meta: U2FsdGVkX19Ar40kJN1BIW2G4jIuRC4NQtl1zfoHAaSNBQrWkPNjdYljCwehz8uKYfvwn7WtiIhUH+ajWskvKKygvoI8FagR7L+0aDZFLQrv5XR0ZI5A5JroADxz3HYureRc7afUjY+i5sNZtA4OPYfhSeKi/mBDl3GTMWlj8h+objhvJypjktvSVPZUtdtVP0G75Yl601HVH4dpTFGnweHc1iewhDnGDAAPeVjsDnDo+WaRHs3fHkJ9vuSHO0zoCTQXvToUMLz2VqKynB6avSofhuy72M5y2l07jRzJH2gfkXjGHEpir9E80NhrumjNFJv9MgyzUwRWH1aBbYZOFF7mowPoK/ZmJDIDTNPdAfKFiUUsI+2VG3jcXry7laga371tq52KUgXJOGSdbjWrYNYJnH38CODrmSttiYMbUXGaYl4+TcwjDxGJKEhPGLFBaDnxeKmKYFgIO6hKBGHbYFEOvsJ/wRVehal1A/JEXOf/JHD417MxfB7c46sq8UiIlqQc191+IXtEdCi7xYo9OyYmjjdGfdxzi7cdMjfoQLhhXkkZceOjao0qbaXlskQGmeMVK7gfnpu2Oq7+FbEBj9k2dxiQeSAHO/sqeGcr249aD1tNa5MIAj9183kEEgi4wmABV5v8/+ff6XAGFQNO3LQpJdQFh0R0eh6CW7x3SuMNFeg8hr+YAcHGzIvt7IG+ENsIYM2pXmplRf6gtYJCixzvd/uBrzW44z1YWkpsxG9vzqr4CieB7OvblaUWeKfZ+Cpo7F0sFMrVy2iGpTw3v3kPTOwubw7LGsnqPz/rUMvvhliooB1eJu/q6siZLcR1DRd4Eo9pid1VJ0ot1+ue+XE161kkRTSBWegLhCBA76svVKnwdgzrk5mjuVMS2Esr+wXZKfVxzrpcQfwJ+82x/Rw79boUiHBvZkcaFWgrMVWKauaEU4cvBd+TMDYiW+lR4pSisObV7SVctws9/kF
 4hnCwi+C
 L5VQUDIIIhMHobsb5IQEXdb3tjswcWj80iCLzU5PAKLLomHA2DjCEthtZgzzUnhTjW7b8wS8BeiHXNJtIpCk2ghuRlHpQSdjzmlPOIl6afdM7l2kVO3KGIlqMsnTKtLHsCG6jZsK32F9uktBGO1e8l0TO4iS4nH5mAlYpGLdZqmVF2IziBn03aKl3cNQ/VFzy0sawSg2yyQY51Z8EeZP4eDzY4+EpPqgNT9NgAFnPnuVBb5/vgmXp881rBrd6COjsFMPotNqNMBWMJ5SyEZJwiucDuyE/EyCMe+ltnV6dNKpkJcaAl/V9LJwc3qIVmT5YBmbz67ZgqQiluwaH4ADGNBAbjJB64kdqz/xZy/ONHMMszs5f00KzYijFqO/4mJ6ImEK1afy6NU8EiCZdIMvSMf9sFMVqLmSrQC+CcMWVDwpmemCbY8vMpN1prQNyTfQxqSfiL9CTUN9V6yX0bNT4PADZSHfUvlpuO3DhPfy562OfDMsWXinbbYmEf0rlELGZWlat
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index c9b4e3dfe06a..b30b8e78da32 100644
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


