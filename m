Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6329C606C091
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LkQd7EDx
Received: by kanga.kvack.org (Postfix)
	id 150706B0A3B; Thu, 22 Oct 2026 19:28:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12AEA6B0A3C; Thu, 22 Oct 2026 19:28:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6EF26B0A3E; Thu, 22 Oct 2026 19:28:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9EAFD6B0A3B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2568E1A0352
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:10 +0000 (UTC)
X-FDA: 85351852740.02.FE3FC56
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 132A080003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LkQd7EDx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf02.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711688;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CIdRhsv1mGre3cDRXUtNlPmF51qRPEAIHo2IbSyjS0U=;
	b=EvMNyPJ73e61EwuJjw0AikyzHH/vWjfDYmlxJHSKEMsVJCDHPsiwn50OXTiAHhMFWlASNK
	C/rcmlk9YrkqmeA6ePT4F8GGinuu1Kiu9UWH3HLXedlATw9DnSC4ZpNaMNLQeKSsXN8eMz
	jJPG6k8LfGL2ALwZV7w1cYs/QTfy31Y=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LkQd7EDx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf02.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711688;
	b=02icbdkbotyW13DRYXvt3zga8K/3TQog8NLm75EE2BKWlzIv/P/8UPU+nfjq2Y3zNdkQgX
	FvKjehF+n+ruuJizcryvFgAtP+fGF6PzGwRTxtyPyFIuqLc2NPkwtoUb2LyTMliu7kz8X0
	4xY1SOvXB9Xzs8luWY68K4Ya5OhVANQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1AFB6447B7;
	Thu, 22 Oct 2026 23:28:07 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711687;
	b=C0duIKqV3/K3WLAXwuGM45mQKTAufTYKsbBxoC4g7POx2CG+33uC7CF1Jp6CLzKmNbbZ
	 z8kZaznSbGxYziir81LbGkHWjtrixlvQKODh5KWmhDY9RjyL5sX0Y9whFyrW2h5ESzuHU
	 8Q5CPJ+uAVBRWh28KaT3zvwNH9YyOyRtqi8FyCwfeez/eeEuA7nJKhTBb4ZkhmHWbPkvj
	 y6ACzKxeFGlie6SlaMruqtpYP0yVZfTMjVf+HoK81jzRgTAi0YZsXfT7QbAiModfZSDvt
	 DcMwp4drK4A4NSKuBj+1D0TAxqL3WQAfDfmj+GQSLkz3D74tcd4yV6wg3Ifp5Ra2boQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711687;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=CIdRhsv1mGre3cDRXUtNlPmF51qRPEAIHo2IbSyjS0U=;
	b=kpfk1N43bxD8H4Z4WqEfhMzytoTHLRtlNYReoSD0oK58zO+VXnmsTc6xKvd2ohPgVLPq
	 R2TIYOmu6i3cqyUtKSstKS9uM+7HnX23n0pjzNjo1u5yqS0QnCxQw34XBMl9UbKtZBmn9
	 LcMH5XAqRFjvYW+MGvBUDF8i1FpZ98gIhPo0ENt9mm+od3FswXMTlom2mtaW5jSUotr5y
	 tZGlASoCZhKgGG0I/aO6lWRaUzFZ4FtHkieC8xmKTR1YhS0iVOvMkhZvfwgPmwoLzuxIV
	 c/PTQb+uXGmhpqJBwfP7YLFT9PX3x0oh3o1nUhrAevX0i0dkx28V8GpNbYGRHjiQy2g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 0FEFE1F011AC;
	Thu, 22 Oct 2026 23:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711687;
	bh=CIdRhsv1mGre3cDRXUtNlPmF51qRPEAIHo2IbSyjS0U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=LkQd7EDxpmKjp3oh5L7rFChFo+A41y98n0mIOBWOsUTmNwd7HBLyQ55vUGigaVXaW
	 7vF5Nl6WDIhFgaly7dhOCIXpU0gNEikiQOiyWgSBBXuSSZbFGER4YlXEb8v/foM4kd
	 4bAAnHIvjYeGf5O+XUAqqCUPW62MA6HMoUu+nYZQG9XtseybAmxJbFtaCdZgRfm1U6
	 fsvm3/yKtOvG7uwKAO0iSJ5ov0vO2mHYahg7vZtcShqaOUSjLNDt3UzJDuP+dhqndp
	 pMrlD3tugqIh+iItIJr3BnU0C9oO2dxjXifPQYCqp59BZY+K+WfE9L8oCVY0hPqw86
	 iA7/+5jGFsr8Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 767A9420A8;
	Thu, 22 Oct 2026 23:27:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:27:57 -0700
Subject: [PATCH RFC v2 25/50] samples/kvm: Remove MMAP_CAPABLE flag from
 sample provider
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-25-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
In-Reply-To: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
To: Alex Williamson <alex@shazbot.org>, Alexander Graf <graf@amazon.de>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Alexey Kardashevskiy <aik@amd.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Ashish Kalra <ashish.kalra@amd.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Baolu Lu <baolu.lu@linux.intel.com>, Bill Wendling <morbo@google.com>, 
 Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
 Christian Brauner <brauner@kernel.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Connor Williamson <connordw@amazon.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, David Hildenbrand <david@kernel.org>, 
 David Rientjes <rientjes@google.com>, David Woodhouse <dwmw2@infradead.org>, 
 Erdem Aktas <erdemaktas@google.com>, Frank van der Linden <fvdl@google.com>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, Fred Griffoul <griffoul@gmail.com>, 
 Gregory Price <gourry@gourry.net>, "H. Peter Anvin" <hpa@zytor.com>, 
 Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, 
 James Houghton <jthoughton@google.com>, Jan Kara <jack@suse.cz>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Jianxiong Gao <jxgao@google.com>, 
 Joerg Roedel <joro@8bytes.org>, Joey Gouly <joey.gouly@arm.com>, 
 John Starks <John.Starks@microsoft.com>, Jonathan Corbet <corbet@lwn.net>, 
 Justin Stitt <justinstitt@google.com>, Kevin Tian <kevin.tian@intel.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Michael Roth <michael.roth@amd.com>, Mike Rapoport <rppt@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Nicolin Chen <nicolinc@nvidia.com>, Oliver Upton <oupton@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Pratyush Yadav <pratyush@kernel.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Robin Murphy <robin.murphy@arm.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
 Steffen Eiden <seiden@linux.ibm.com>, Steven Price <steven.price@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Tom Lendacky <thomas.lendacky@amd.com>, Tycho Andersen <tycho@kernel.org>, 
 Vishal Annapurve <vannapurve@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, x86@kernel.org, 
 Shuah Khan <skhan@linuxfoundation.org>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=5272;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=NyLuSglYrgseNgo22Leven/EVJ6xVizHVjRReJCGP3c=;
 b=oOyJLSyR86edjat5g+/tkS/BgrVfnXSZMxDSUij8i8EsT8NCw5Hlv/4VKfZZ36+fvuL82lKzW
 YHjlPObEObuCk6Lf69FV0eMFWTxmVS2+taE4yXO2/NipSMiv4SSI0tI
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 132A080003
X-Stat-Signature: xi6j7gydhiep9zp73w917ia5xd8aazar
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792711687-44099
X-HE-Meta: U2FsdGVkX196gCpPu1srF+bA5mRtOXRzmUvTHIJOTFcc0RwXcX4s5CwwqDEfig0GscCWLlHVIl+I7kRAbULVfMbH8Tw180RNhUAkRyyPi9FiooN4691liVOntzCB4egfhFYPbGp+FsWNy6bYCH1HG5RfYXqpZRURRZetsasxWit+Uv8NyzPlH/Z/OsC/x0UTg4aiJbh3UTwkQH6eaF2gvX7Jh5vkDimPRryMDH+PRaElPXTZUhFQQPlKG7W4jAyEAHLGzajimI6VjpM/RjszY82Po+zYHB2uCc6UuCksJHb4f5zVCC4B5wlBrN7pq0duX63Hte+hP2R5+x+W16MCQKRcYs8+V2rsuJOBCvdGE7k8NIVpEx0NstGk2kol/51VilR/a4A7YwSavvO9zvlnOmnaK+49y7HGex7BCMX/QT3GIwIpzP6QuJ4vGeMNRZq5y14S+euf2ZLIqiWRTCPoL8kfq/O9316KikrMMywQM5U2YSqoHli2iL3zx/ckzq5aibg9Mj6wP0jqSvl41plc8baXTt/se1O+X5O6GHXbheOgrSesc1VksNlM3Bx/IL4uxXBuzQq8hAvpDarNCxR+sfspVl9X/YZqBn8T6ifPbJj6Aj6+7j3cIBqCbj0dglWJvbuA+3YcugNp66DfGBR/sf1B4cRZexakTelE0Gtws4gUrVRNHAkbrxGKGNLiI4BxO27S4nmEcYIPhcuAgdxXENNzNxxP9wKusizWgN4Z7ZP/NKFqdVA2tLtq5RjniFp9ssgIvQZUY1MYxU9CHbSLcqFGrirqXyVjmnnn+L6gpsPOFge14n6fOaa/LyOziMwa+4jH8L3sQilNFWm1Nath2jrnadl5H687tbXQ63ED63bflJwakkUrr0uqFexG4DHA3mCXF49mWogeUDvtw2A0Wmjoyza5UJC9QfH1PfOyZQVTLXYpgOOLy9qDPPetTIwCJeRMnPEOe6cIOrKv/Ng
 xJlN4a1G
 sEbzBu+Bog/GiKTz+fYqTPzOPYv4YZAS+0yIr9e7f6B3r5CGSvqtFfgGh7RUEptYGFFgzaYd2IYe8qhma2aFdxVirOlRDf/3T7FzTXt6PUfBsvzHTZ4jFv7R1oLT+Q44JVR9NaYj2zrQo5wwPVt5qmowAL+/KYux62xSr63wQgV64mzj4w8YeZv2O5VtG7XkV25jXcchlyCLFnL9jVcQ8rq3J2ke923OCHFU4AM9Iy38fqDQ2Byxk9Bs6+pfxdCRp5WdUjrrwb28WoRQd1mS+LGXXla0lJLLZ/8cIR9FG3CPQFkaY9Sln3aVi+abn7Gu80xNgfsJK5J50T/e/fCRYzkj4c0XKlmfBN+7IVW/GI55csg5CKf6sCX5uRC2U3FiEcz+5nshAh1hlm7x13eM9C/74IRnZPHwNPNs01+LoFAIaA0yqqPLrBMKI3IjUzgxBvLhdSedLdDgeTJwMyuMPjc6qU6OnC1oRJkN3H/dqyHvRcSKjvjNS7emAUh1a83UAndmLewRVK92sy5pcRLLWv3tP/BdUzcRDy7HlfRuK9trDRGPozeBzNMfzaFrr8ImZmcBq1fk0cc/AXgGZbEJtue7sBE4En8tV8H26
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Remove the MMAP_CAPABLE flag and associated write-back PAT mapping logic
from the sample memory provider.

This is removed to focus on the core concept of providing memory.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 samples/kvm/mem_provider_sample.c | 66 +--------------------------------------
 samples/kvm/mem_provider_sample.h |  6 +---
 2 files changed, 2 insertions(+), 70 deletions(-)

diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider_sample.c
index abb8e35cd5357..f7ecb2ea1d75d 100644
--- a/samples/kvm/mem_provider_sample.c
+++ b/samples/kvm/mem_provider_sample.c
@@ -61,8 +61,6 @@ struct mps_info {
 	unsigned long base_pfn;
 	unsigned long npages;
 	struct page *cma_pages;		/* from alloc_contig_pages(), or NULL */
-	bool mmap_capable;
-	bool fixed_wb;			/* holds a ref on the fixed-region WB alias */
 
 	unsigned long *absent;		/* taken away by CTL_SET_PRESENT */
 
@@ -86,48 +84,8 @@ static struct mps_root {
 	struct page *cma_pages;
 	unsigned long *allocated;	/* pages allocated to a child */
 	struct list_head children;
-	/* Files over the fixed region that may be mapped into userspace. */
-	unsigned int fixed_wb_users;
 } mps_root;
 
-/*
- * A write-back mapping of the addr=/len= region, held while any file over it
- * may be mapped into userspace (counted by mps_root.fixed_wb_users).  Without
- * it, PAT makes the range uncached on x86, and the VMM's mapping would be
- * uncached while the guest's is write-back.  PAT may still give a weaker type
- * if the MTRRs do not mark the range write-back.
- */
-static void *mps_fixed_wb;
-
-/* A file over the fixed region whose pages the host may map. */
-static bool mps_over_fixed_mappable(struct mps_info *info)
-{
-	return addr && len && !info->cma_pages && info->mmap_capable;
-}
-
-/*
- * Hold a write-back mapping of the fixed region while any file over it may be
- * mapped into userspace.  Called under mps_root.lock.
- */
-static int mps_fixed_wb_get(void)
-{
-	if (mps_root.fixed_wb_users == 0) {
-		mps_fixed_wb = memremap(addr, len, MEMREMAP_WB);
-		if (!mps_fixed_wb)
-			return -ENOMEM;
-	}
-	mps_root.fixed_wb_users++;
-	return 0;
-}
-
-static void mps_fixed_wb_put(void)
-{
-	if (--mps_root.fixed_wb_users == 0) {
-		memunmap(mps_fixed_wb);
-		mps_fixed_wb = NULL;
-	}
-}
-
 /* Does @info have page @index now?  Called with or without info->lock. */
 static bool mps_page_present(struct mps_info *info, unsigned long index)
 {
@@ -192,9 +150,6 @@ static int mps_mp_get_page(struct mem_provider_file *mpf, pgoff_t index,
 	}
 
 	*pfn = info->base_pfn + index;
-	/* The creator of the file decides whether the host may map it. */
-	if (!info->mmap_capable)
-		*attrs |= MEM_PROVIDER_ATTR_NO_USER_MAP;
 	return 0;
 }
 
@@ -281,13 +236,6 @@ static int mps_file_release(struct inode *inode, struct file *file)
 		bitmap_clear(mps_root.allocated, info->root_index, info->npages);
 		mutex_unlock(&mps_root.lock);
 	}
-	if (addr && len && !info->cma_pages) {
-		mutex_lock(&mps_root.lock);
-		if (info->fixed_wb)
-			mps_fixed_wb_put();
-		mutex_unlock(&mps_root.lock);
-	}
-
 	if (info->cma_pages)
 		free_contig_range(info->base_pfn, info->npages);
 	bitmap_free(info->absent);
@@ -325,7 +273,6 @@ static int mps_new_file(unsigned long base_pfn, unsigned long npages,
 	mem_provider_file_init(&info->mpf);
 	info->base_pfn = base_pfn;
 	info->npages = npages;
-	info->mmap_capable = flags & MPS_FLAG_MMAP_CAPABLE;
 	info->absent = bitmap_zalloc(npages, GFP_KERNEL);
 	if (!info->absent) {
 		ret = -ENOMEM;
@@ -449,7 +396,7 @@ static long mps_ctl_new_child(void __user *uarg)
 
 	if (copy_from_user(&nc, uarg, sizeof(nc)))
 		return -EFAULT;
-	if ((nc.flags & ~MPS_FLAG_MMAP_CAPABLE) || nc.pad)
+	if (nc.flags || nc.pad)
 		return -EINVAL;
 
 	mutex_lock(&mps_root.lock);
@@ -471,15 +418,6 @@ static long mps_ctl_new_child(void __user *uarg)
 		ret = fd;
 		goto out_unlock;
 	}
-	if (mps_over_fixed_mappable(info)) {
-		if (mps_fixed_wb_get()) {
-			put_unused_fd(fd);
-			fput(file);
-			ret = -ENOMEM;
-			goto out_unlock;
-		}
-		info->fixed_wb = true;
-	}
 
 	bitmap_set(mps_root.allocated, first, last - first);
 	info->is_child = true;
@@ -571,8 +509,6 @@ static void __exit mps_exit(void)
 {
 	misc_deregister(&mps_dev);
 	mps_root_teardown();
-	if (mps_fixed_wb)
-		memunmap(mps_fixed_wb);
 }
 module_exit(mps_exit);
 
diff --git a/samples/kvm/mem_provider_sample.h b/samples/kvm/mem_provider_sample.h
index 3b0928b6478ca..51eaf39acbad1 100644
--- a/samples/kvm/mem_provider_sample.h
+++ b/samples/kvm/mem_provider_sample.h
@@ -14,10 +14,6 @@
  * the ioctls below make.
  */
 
-/* Flags for struct mps_new_child */
-/* The host may map the pages; otherwise they are NO_USER_MAP */
-#define MPS_FLAG_MMAP_CAPABLE	(1u << 0)
-
 #define MPS_IOCTL_BASE		'P'
 
 /*
@@ -36,7 +32,7 @@
  * root into a new child fd. Returns the child fd.
  */
 struct mps_new_child {
-	__u32 flags;	/* MPS_FLAG_* */
+	__u32 flags;	/* Reserved, must be 0 */
 	__u32 pad;
 	__u64 offset;	/* bytes into the root, page aligned */
 	__u64 len;	/* bytes, page aligned */

-- 
2.56.0.257.gf7497c7d27-goog



