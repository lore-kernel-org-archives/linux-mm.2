Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81A64606A750
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PgXES6LZ
Received: by kanga.kvack.org (Postfix)
	id 56EC46B0309; Thu, 22 Oct 2026 19:28:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 547736B030A; Thu, 22 Oct 2026 19:28:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 435196B030B; Thu, 22 Oct 2026 19:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D1EE6B0309
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8A7451201B4
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:29 +0000 (UTC)
X-FDA: 85351853538.24.F4886AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6EE321C0003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PgXES6LZ;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711707;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cZCIEmEusCZhQNGcXQBWIL0IR44y3Rh6+lShBdKkxxY=;
	b=kgDFD0a9ZH7w7mvLfilRWPXQP4whQGSfSr6rx2HICDwZO1g1coocv1lpvzA4F8hqIaoOdD
	LucNy63ZQFe2uhGPoEI2CBtxlRG4uPNZPCNPkUZ7fI7XPo8sMpt6+5eh2j1vP7H5dgNq53
	RGBsW2ONZHa7w5iR+zMn/MYwARilqJ0=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PgXES6LZ;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711707;
	b=4/P6RQiq1tBWHmc90uZl9egoRMZ/Bb23k24SW7id/gCtY2379wvOrmDHMkj9f7hf34iBGw
	0yV17je+CgTmdiuz0cLihICTj2Z2ffmM1PBq+VvKe1xp3PqC3jqobCHxR9XHoED27NP0c7
	MBJ322nHdkUFDFGQu/62KxtGTTkiUi4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 394B5447A4;
	Thu, 22 Oct 2026 23:28:20 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711700;
	b=ZC37MtCrJwx4KQeLKdYohwHw5teUWnAGnD5m8xCaY11xTBI6tw7TitiPOxYwWI7G/wL/
	 0fjfj7kaXdU62rfzZ7sYfHFR1aDrY738+EjY3aq8rQpewk8rGnq/Rt5jVL7lS/DQgQ0CJ
	 lI4IQz8gq8IHSCKZsUM01Y03E++8h30bmjnsT0KPw101F1WA07IL8JwDBz/d+qrZHX8Op
	 2MVbkz6TyY91FNe1zmrzRLZD2uGLf8M+TFW0TB8N+Ab6csXSqClmsnWemAU8p2tiyXKW/
	 THOCAlqFKDj2BKLqP8v6yUGtlWTff7mF4sVFyd5m4F5xXAYF0caeo4HzaNzPp/Vlhfg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711700;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=cZCIEmEusCZhQNGcXQBWIL0IR44y3Rh6+lShBdKkxxY=;
	b=t9OKjkBK7vcEEne54bEUz4EVZt4tLhE4hJ+FWocyfUhkSITq1vpSkBHuOUxwL8393zsY
	 MUuw61ViHspHVqbc1fTAmvzCkUbhJU/l/9PIzd5q8yijeQBAFeOoaRXzW7zLeZdPHti4r
	 9D6tNShZ2MPcS8fFyVOSaVb35tGmbremA839GP2K1eXQEsZJH55MzOQyd51dGfnX6AL0q
	 Crn7CdQiJduCMaBOYCBpRV6IBDdUMLapX/arNqE1+9naL5IyJOE2yn4rygdYjR7Pxktbu
	 3F2q1HnRdpQLKVLabOWadYVjOheL9RFVYngoriL74Nuv2811bEz+RtBM7tbUZ/MBnOA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7B3861F031E3;
	Thu, 22 Oct 2026 23:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711700;
	bh=cZCIEmEusCZhQNGcXQBWIL0IR44y3Rh6+lShBdKkxxY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=PgXES6LZGTo7q6QOb8JFE//c/htqsTcN5gB9TQtdhmnVXNNt6BiNK0u88EcyfwfeZ
	 9RoyFjgKs0rzCImqmP65mfPhlTkGbgkErxKzVIMuX6C1SGOjWq2fvrwoun709HhcKE
	 8G2pSOH4c8YYpFw9RHo1oiannBUEIBTVUfaBxoSX+dZcnMXXdPYy/gFm/sX20PgJjb
	 u2cT+eWgYsU0owk47/kGhezyEtzUHJEweT6ibNqUC13FIGHBIz14PDFh+dwEgEy/rF
	 S2ahprKWY/Vz76EPzNUQFOxXUcGKx44d1/IIDE8JLCg9z0AJbnew5ixM9miVYSrak5
	 l+ZnEUBSEnJkw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 5D95A4209F;
	Thu, 22 Oct 2026 23:27:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:27:55 -0700
Subject: [PATCH RFC v2 23/50] samples/kvm: Remove child ownership tracking
 from sample provider
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-23-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=8882;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=qZbL+QJVNKb0L2oUo9qw6ZpUrTdAKrmTQ6W+rRuOJj8=;
 b=buCaGa+KJp6KTNyEF2GukFjSdlkmQeHt2oLjFswkYRiHyeNibxJs4DZOA3x9jFrrpolQ6Nluh
 d8zPN/aL78eCwjLLyw8A8x8It/152jzC1OUxx2LgKbY1qKzFQ3biC8i
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6EE321C0003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: f9sxm76op9aoj7w16e1inhc4npgx1ddx
X-HE-Tag: 1792711707-409936
X-HE-Meta: U2FsdGVkX1+KIlVxMzrPcXmJCv1q2xU+TKCQu1Fs3R5BdYT9t28x386BIkbbMEmOPnZv/KaE/1+89Hh2fF/UazBnXzbnYmJxvQ/8CFe9k7ZkJj63yDcInR5ecw8tBHAsENK/FaR2n8g81/sRr7iD6NJ6gxe/qRvexw14SjWxlX+oDWqPvdZjjSuMgdThsL+MUSWDUKCkrUPqxMO/ZxfXSwRpSbq3V84BB39dVx67vbgUUf1uZ1L8hVanedX4RUjju0+xooX1xSTBcAeNHV9PmnDiPsCAD4VJfORXO2bBMtv4nql13LloGRMedZ6m+LxX4Vofs9xNxZpFZ7UPF8kX42WVeCD2KpjUSeodwwlbn6T1nIRFdhbxCFjzAWpw3saqqRwXWpcPhUlpdA+W+1GFmMgNJWrsWdjEwA7Nrp+yWOpB6JOd962rTFR9YdQlo+cq7UgeK9FRpDpYX+K/OaNdcQifG7K37kj2RHkpKRQOVpnS+d5jajMYcXB8IAQxJNYJMqrqtsQYB1Cy/xFe6YO0yXeo9QhCWuGBjfdxJJxnUxHFw5yXcaytMFtB6VHt3So5nlpaTnYd8QA7mfkeBVhagYBA6HlDO56KIBvBRLg6tDYRNdrbHN6KWAPoVIBrXVVipEpYI2W38c6xMWdAB4HXMKVBbLSEDpaybhlW1HiHWqu9Zd89BkAOD46q3gwHrFY7++enWwi+Y5eb5myMnSTYQE9KyoYseNJKG240scjiZ842xoeo2gjmcyr0Tjx28tgVLQWtG17Hixt/YPct70rI8JbHJPbsNp720A0I9b9Ee9ydsQlmyMcasjUt5AQbu7mUzU5DZ06yD+I5QGpxteU/3tHXjxfQ4i79oUgPsm28Z/RqSRfOjHBTRKy1BANKVMtlzRiO4A1RGFL3GwIe9nf6C2hb0Key42Y5jg0OVxEc4UwPp+45WUPA+9EK0YqYzmPVEcXjpKZ8PBPpbU8x7NV
 z26PBcxh
 LtiQcoLtHfNkz/9tzHd27cROuGRywjpaEM7JeR3rwDDnnmma+SSKKfrmJBOC932xfCKemdYNCICC+l3sJJGG2PBxL2y8Had6Q19weWu8QSR0DRoBnd2yC86cBMRJkOsVr3nuZ6Y58i7OsgBY6kAVJ6Hb+/5nRF6PwxEzZ7CQXO0vBi7YoK3R6/k5Lj1JumEbuBetjITrgXcEzrIajKbi9GlC9RMqYCllLRLEUnf0xc87v7Nlt71Y8KuXNTXmIaDzlKaBKlxsIeW7uOBM0V4/zf0IOv4cYToTojfKLOCULzXheLMGkUBcD3I7yerD0uVz5usw3lKIA7OBseK1PUJlUrD7vzsbUECfcaA7ybp97kr+1afPc25Y775qJAtjZIttGqN3KgNvH0w49j+5AytVkImcFJuduBwdoZSxoZJ9yaKqTJoAQtvZp/aRKBSJADGZ+DJXLuApk9x39+ZSQFgen878cfmjGS3+BuvjH3wMbetIuJ1sr/BJFLwC+RRNEMhlqLtUnqBput1Ci5RgL30n6+YPoHUI1CL7XPuMA+skfHvELHUckFjIwUbtq8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Remove per-child owned bitmaps and overlapping child range tracking from
the sample memory provider.

Each child directly carves out a non-overlapping slice from the root pool
tracking allocated pages in mps_root.allocated.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 samples/kvm/mem_provider_sample.c | 115 +++++---------------------------------
 samples/kvm/mem_provider_sample.h |   1 -
 2 files changed, 15 insertions(+), 101 deletions(-)

diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider_sample.c
index 37538dce40cf8..4e8f306ba1154 100644
--- a/samples/kvm/mem_provider_sample.c
+++ b/samples/kvm/mem_provider_sample.c
@@ -68,11 +68,11 @@ struct mps_info {
 	unsigned long *absent;		/* taken away by CTL_SET_PRESENT */
 
 	/*
-	 * A child of the root: its first page in the root, and the pages it
-	 * has.  NULL @owned for a file made by SETUP, which has all its pages.
+	 * A child of the root: its first page in the root, and whether it
+	 * was carved out from the root (is_child).
 	 */
 	unsigned long root_index;
-	unsigned long *owned;
+	bool is_child;
 	struct list_head root_link;	/* mps_root.children, mps_root.lock */
 };
 
@@ -85,8 +85,7 @@ static struct mps_root {
 	unsigned long base_pfn;
 	unsigned long npages;
 	struct page *cma_pages;
-	unsigned long *owned;		/* pages that a child has */
-	unsigned long *donated;		/* pages kept at the root */
+	unsigned long *allocated;	/* pages allocated to a child */
 	struct list_head children;
 	/*
 	 * The addr=/len= region is used either by one SETUP file or by the
@@ -138,8 +137,6 @@ static void mps_fixed_wb_put(void)
 /* Does @info have page @index now?  Called with or without info->lock. */
 static bool mps_page_present(struct mps_info *info, unsigned long index)
 {
-	if (info->owned && !test_bit(index, info->owned))
-		return false;
 	return !test_bit(index, info->absent);
 }
 
@@ -152,9 +149,6 @@ static unsigned long mps_run(struct mps_info *info, unsigned long index)
 	unsigned long end = info->npages;
 
 	end = min(end, find_next_bit(info->absent, info->npages, index + 1));
-	if (info->owned)
-		end = min(end, find_next_zero_bit(info->owned, info->npages,
-						  index + 1));
 	return end - index;
 }
 
@@ -259,8 +253,6 @@ static long mps_get_stats(struct mps_info *info, void __user *uarg)
 	mutex_lock(&info->lock);
 	st.region_offset = (u64)info->root_index << PAGE_SHIFT;
 	st.region_len = (u64)info->npages << PAGE_SHIFT;
-	st.owned_pages = info->owned ?
-		bitmap_weight(info->owned, info->npages) : info->npages;
 	st.absent_pages = bitmap_weight(info->absent, info->npages);
 	mutex_unlock(&info->lock);
 
@@ -287,19 +279,13 @@ static long mps_file_ioctl(struct file *file, unsigned int cmd,
 static int mps_file_release(struct inode *inode, struct file *file)
 {
 	struct mps_info *info = file->private_data;
-	unsigned long i;
 
-	/*
-	 * A child gives the pages it has back to the root.  Pages it donated
-	 * stay at the root, and pages moved out belong to another child.
-	 */
-	if (info->owned) {
+	/* A child gives the pages it has back to the root. */
+	if (info->is_child) {
 		mutex_lock(&mps_root.lock);
 		list_del(&info->root_link);
-		for_each_set_bit(i, info->owned, info->npages)
-			__clear_bit(info->root_index + i, mps_root.owned);
+		bitmap_clear(mps_root.allocated, info->root_index, info->npages);
 		mutex_unlock(&mps_root.lock);
-		bitmap_free(info->owned);
 	}
 	if (addr && len && !info->cma_pages) {
 		mutex_lock(&mps_root.lock);
@@ -473,13 +459,8 @@ static int mps_root_ensure(u64 size)
 			return -ENOMEM;
 		mps_root.base_pfn = page_to_pfn(pages);
 	}
-	mps_root.owned = bitmap_zalloc(npages, GFP_KERNEL);
-	mps_root.donated = bitmap_zalloc(npages, GFP_KERNEL);
-	if (!mps_root.owned || !mps_root.donated) {
-		bitmap_free(mps_root.owned);
-		bitmap_free(mps_root.donated);
-		mps_root.owned = NULL;
-		mps_root.donated = NULL;
+	mps_root.allocated = bitmap_zalloc(npages, GFP_KERNEL);
+	if (!mps_root.allocated) {
 		if (pages)
 			free_contig_range(page_to_pfn(pages), npages);
 		return -ENOMEM;
@@ -496,8 +477,7 @@ static void mps_root_teardown(void)
 	WARN_ON(!list_empty(&mps_root.children));
 	if (mps_root.cma_pages)
 		free_contig_range(mps_root.base_pfn, mps_root.npages);
-	bitmap_free(mps_root.owned);
-	bitmap_free(mps_root.donated);
+	bitmap_free(mps_root.allocated);
 }
 
 /* A page-aligned byte range of the root as page indices [first, last). */
@@ -521,7 +501,7 @@ static struct file *mps_get_child(int fd, struct mps_info **infop)
 	if (!file)
 		return ERR_PTR(-EBADF);
 	if (file->f_op != &mps_file_fops.fops ||
-	    !((struct mps_info *)file->private_data)->owned) {
+	    !((struct mps_info *)file->private_data)->is_child) {
 		fput(file);
 		return ERR_PTR(-EINVAL);
 	}
@@ -532,9 +512,8 @@ static struct file *mps_get_child(int fd, struct mps_info **infop)
 static long mps_ctl_new_child(void __user *uarg)
 {
 	struct mps_new_child nc;
-	unsigned long first, last, i, grant = 0;
+	unsigned long first, last;
 	struct mps_info *info;
-	unsigned long *owned;
 	struct file *file;
 	int fd, ret;
 
@@ -551,25 +530,14 @@ static long mps_ctl_new_child(void __user *uarg)
 	if (ret)
 		goto out_unlock;
 
-	/* A child that would get no page is likely a mistake. */
-	for (i = first; i < last; i++)
-		if (!test_bit(i, mps_root.owned) &&
-		    !test_bit(i, mps_root.donated))
-			grant++;
-	if (!grant) {
+	if (find_next_bit(mps_root.allocated, last, first) < last) {
 		ret = -EBUSY;
 		goto out_unlock;
 	}
 
-	owned = bitmap_zalloc(last - first, GFP_KERNEL);
-	if (!owned) {
-		ret = -ENOMEM;
-		goto out_unlock;
-	}
 	fd = mps_new_file(mps_root.base_pfn + first, last - first, nc.flags,
 			  &info, &file);
 	if (fd < 0) {
-		bitmap_free(owned);
 		ret = fd;
 		goto out_unlock;
 	}
@@ -577,22 +545,14 @@ static long mps_ctl_new_child(void __user *uarg)
 		if (mps_fixed_wb_get()) {
 			put_unused_fd(fd);
 			fput(file);
-			bitmap_free(owned);
 			ret = -ENOMEM;
 			goto out_unlock;
 		}
 		info->fixed_wb = true;
 	}
 
-	/* No other thread can reach the child until fd_install(). */
-	for (i = first; i < last; i++) {
-		if (test_bit(i, mps_root.owned) ||
-		    test_bit(i, mps_root.donated))
-			continue;
-		__set_bit(i - first, owned);
-		__set_bit(i, mps_root.owned);
-	}
-	info->owned = owned;
+	bitmap_set(mps_root.allocated, first, last - first);
+	info->is_child = true;
 	info->root_index = first;
 	list_add(&info->root_link, &mps_root.children);
 	mutex_unlock(&mps_root.lock);
@@ -604,51 +564,6 @@ static long mps_ctl_new_child(void __user *uarg)
 	return ret;
 }
 
-/* Take [first, last) of the root from @info.  Called under mps_root.lock. */
-static void mps_child_lose(struct mps_info *info, unsigned long first,
-			   unsigned long last)
-{
-	unsigned long s = first - info->root_index;
-	unsigned long e = last - info->root_index;
-
-	mutex_lock(&info->lock);
-	bitmap_clear(info->owned, s, e - s);
-	mps_revoke(info, s, e);
-	mutex_unlock(&info->lock);
-	bitmap_clear(mps_root.owned, first, last - first);
-}
-
-/* Give [first, last) of the root to @info.  Called under mps_root.lock. */
-static void mps_child_gain(struct mps_info *info, unsigned long first,
-			   unsigned long last)
-{
-	unsigned long s = first - info->root_index;
-	unsigned long e = last - info->root_index;
-
-	mutex_lock(&info->lock);
-	bitmap_set(info->owned, s, e - s);
-	mps_revoke(info, s, e);
-	mutex_unlock(&info->lock);
-	bitmap_set(mps_root.owned, first, last - first);
-}
-
-static bool mps_child_covers(struct mps_info *info, unsigned long first,
-			     unsigned long last)
-{
-	return first >= info->root_index &&
-	       last <= info->root_index + info->npages;
-}
-
-static bool mps_child_owns(struct mps_info *info, unsigned long first,
-			   unsigned long last)
-{
-	unsigned long s = first - info->root_index;
-	unsigned long e = last - info->root_index;
-
-	return mps_child_covers(info, first, last) &&
-	       find_next_zero_bit(info->owned, e, s) >= e;
-}
-
 /*
  * CTL_SET_PRESENT changes a child's pages, by the owner on the control device.
  * A VMM that holds the child fd cannot, so it cannot undo them.
diff --git a/samples/kvm/mem_provider_sample.h b/samples/kvm/mem_provider_sample.h
index 5955c1c0fbf80..1afea136328f5 100644
--- a/samples/kvm/mem_provider_sample.h
+++ b/samples/kvm/mem_provider_sample.h
@@ -72,7 +72,6 @@ struct mps_new_child {
 struct mps_stats {
 	__u64 region_offset;	/* the child's range in the root */
 	__u64 region_len;
-	__u64 owned_pages;	/* pages the child has */
 	__u64 absent_pages;	/* pages taken away by CTL_SET_PRESENT */
 };
 

-- 
2.56.0.257.gf7497c7d27-goog



