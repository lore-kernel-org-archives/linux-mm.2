Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99A39606A337
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CxW1qBJm
Received: by kanga.kvack.org (Postfix)
	id 87CE06B0305; Thu, 22 Oct 2026 19:28:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769F86B02FE; Thu, 22 Oct 2026 19:28:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56D6D6B02FC; Thu, 22 Oct 2026 19:28:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D4EA6B02FB
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8CD10A7745
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:25 +0000 (UTC)
X-FDA: 85351853370.23.580DB61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6CC2940003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CxW1qBJm;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711703;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BnvA+UDDZWLhpw1u4Fz/4lUP+B1wGtSpXKc4lElgTtw=;
	b=vk7bl1axhg6VmqkrOKj1qzjbxZ8kWO8T7C1Tv/Y+dW9K9JPIEEWsjzJtbij6vLdX0QeZxq
	EQDOXtt2QoG3ZB0YINOyjuffD1mw8HiFAiHhXBNgyoKM594iaqZysgDZsbeO/WkyOxf0oW
	vDCxGIEakobPomvoBMGaf9vhPZiKDKQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711703;
	b=xWDb//Pt+TO7XdohwVQnGmaeghQSWk5O+2S740aXZdq/37gCr0j8/QoMpzjEclFQN5O+Fd
	OBNXN4W2vxING95VYs5E6CVEiyZeSnP5QvviASOwdVb6/7wlP32chSXrQ1WggvhDQO2dcQ
	fvmoiTJxi4D44fedxfSUVB0rSzSMBAU=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CxW1qBJm;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 190D644866;
	Thu, 22 Oct 2026 23:28:18 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711698;
	b=H6FxxrbusmM27n6kYWckX2pZEB3pi8jueYTvNH7gGGCGtoIcJWZDL30l9TMDqaEiJ5No
	 RS2rj8Htj2PwwSGoRIRabOClVHT1mMc1q7SDsILsHOWY0IWTJ4DB4szl90Dy6o5yxWNFT
	 pPJ3tnS22mAxIcZUxjPHHUe/rpebfpIlDV3EYT7C7kmks9Qx8mjYwOosVFypHbUpk1rCi
	 jLcMjEEo2dYPziTgAyo+ppyjkd7R1O+CXE0vOxoyyWIo74/r6zARdnu129oNFuFMENLqd
	 1V4x6yzRYOZq1Wr2OEA0RPF49wu0GfpR7X/QR3SfQPKaTGSjiZwIh+BPRrwjA30eGDg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711698;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=BnvA+UDDZWLhpw1u4Fz/4lUP+B1wGtSpXKc4lElgTtw=;
	b=nDjO2nob+oKXMHmx9N2wGePBDx95MyXKqDTzcwYEraEJrRaoGIT4SM9N0DNUa9S7URRS
	 LwuXE5zs4YdwP/o1Oipcn+Z1bxFfepUrsEomjuXkV0CP1tUgQkONMEdxkKihBods1itbF
	 MfwwvxtCVJMz519d2p+Dj12FjGtQ8vvuc4y7zpDUtMMMGQqWXll3XXdM1JEQc8PRs44mj
	 FfsooZ4bZLztFG0eq76xONaE17R12RsRAiOtvRb/hInW8BzYfoUDMKAkm5fo734o3bXqB
	 8TLWH1P2sTyGB9mMtxY6DPaUdGdwFlHtClXu5MesQxd0JYvTQxPYV1uYefNZs2pgCKw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5AB3A1F011B8;
	Thu, 22 Oct 2026 23:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711697;
	bh=BnvA+UDDZWLhpw1u4Fz/4lUP+B1wGtSpXKc4lElgTtw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=CxW1qBJm+Du/Pj1yZWWZ+guYUADxFUzGsLqbCkLspsvbKmBjtR58ecQYq++K6J6gK
	 JuyEbpobw9/EqwyGgrIRPpoG2OeJIbrjy9EgKUtXxDdjV8vlr7d3zl02uGCLssLw03
	 VzO0BS/AoPA+RB8fDnmf/w0Tx0mGRWqh//2rsmOVhIp4HzAplJfBd5r3x/a4m482xV
	 /4lXOACrGgWzgKkLY3MaALj/NQbp6aQVgfOri28zxaW4ntIlUwPqTBP/kGMEvlkVox
	 /+vZLwTJ3qcZv8jrvJq645/qTXTYwYkF+Gz7TxE4aIxTk3tiqix+YAT1BG9tmazSjb
	 2SkvIAIqgO0yw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1E697420DC;
	Thu, 22 Oct 2026 23:27:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:28:10 -0700
Subject: [PATCH RFC v2 38/50] KVM: guest_memfd: Support reclaim during hole
 punch in PFN mode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-38-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=2795;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Amg9h7PFK16CNLlu8wPc8g3msTSzfsY9jcWdvuN1E3s=;
 b=juwFRws8T0z3x8gJBTIgAzHVW9gxXr/0rumZeyTIjNlEMf+me1eQ7r0gWp5QZxgPTATu/OJdn
 y897sKLaSagDVXPEqUTUL67SrR2vlPH17j+23zbPqaOnlyFKKID2cBN
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6CC2940003
X-Stat-Signature: fyaznmq9qsnmp7c8pt51jqbb8tzfyx4f
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792711703-486892
X-HE-Meta: U2FsdGVkX1/32F9qnY2XMPny52ou703BY4nUQyhxl3jwG4IRL3VbqDNy1JsINOWRrAHn5RdMWWQp7Tal6/yJ+w5q1jwGD041npHu0zgHs1gC/nMqndAqOVsY0aXJkQelEzFBvndIDKI+BNXmcQVmI4SlP/TUlrWoPfE98Y/uoNgRRZfrRKYOTgmmgt8CWrBEDnIlTndPiA0mLbIsJQ1WyRv/PzUSEiNwMBZ5GSoqiPa0aaOAjm3ToC/vJXqF/wjwd0Lzg99nbOCVvt90wQLB6tXrl5UDLTbRAqKRnV0gKAO7Kzy2JkvquQjwl3d82A9rl8eBimaWVFUjVrVfwGQ1oglhkXipdEg3L2Lg8KXQA2vAUOHEvoq3YOxrdrC8NpF9C7+5k+ZM2fu8rkUpkmg17ZKt8tcgGmKWP4sbkgQChAi7xeMRk+uvrK+TVHowMFjbKgABGjRg5ghOQAGe8grwddeb9w4OFysUc0eI1JixcjFsdSz0ZJHedpNIQzQd1uALRM0cGXFw0/2FMdQzFmGlxiR0NV/FbydlNr1nI58QIboTrs1bKjjdW2U+GFuggLpvBaFeDirMIrm/vQNay/z+LcOOFR6Yrjl9ZqJSVlT1CKkX7vy0SF38MH7juizS4dpU+QPo4vy0BHdwmMKaMlbI4zaRmGe7bIPFb0nAsYzoyirskPKxkrEqCwJshCHKpoQlCjGTSeFSejKjUaJIAR6y3IfWdOAtAmhtYeoFCDhLsDBmrDSQqFyFaOEsV07xKnPdS+ebsbPccZuFtxZ+2jh9lc1K+RxXCS2IyA+CQomFi8vibsL0X7lQa7rW0H1vt2iMblPQOlpHNGAF2PToYRhKuHBZKLut/y3wle7LZLRK4xOS7JapV+3z4Rnpu69BkCh8eKWSHD7fCHf77BF1MafOCbdaQWbyyN0sGaA2StOdleJbMSlnsoQiG1X6FT2iIlrq4odDM9T7SKNbBosElqV
 tS+54452
 KoNGk30rJdroOIk4Nh5rzpBnVdf4apmZafqMx/MjoTeQa2EoaYlNOHPbJj8XKFlOu3wTgh6glBxIbf4aYF578ZJ2uF2Dcxd/qhaAJYwsR1uSGgxx+k/JlBsryEHxw9eiSLpbvrzzIHLlE5HCxz+5tX91R0PTl06EpqbQlpZFgDw7vRoUvSVpcwUaQ0YMqMwaVUjDun7QIqExrcrdgsZdp6bbNnwKXgy/8SuhHQUmUNj2V3qu2rsa7BqIFYOxWF5SAGPUCQ4MRlliZRI422puy2WZvpNrlmgmeg+aFCdrAHMM4l+FD5XVXxHG3x3TTdVvVODPk7mPojomM/NRFk8REKgXy9M2tlU57JSYSJKLayD7gmfmsu+EZZB+75Pt/iMB1KXKTcqdiqBP5R00flL7ZPvwOpBg5EjDrPIH68f0X7In5Yf/LHmsCsKaINH/RuM6LOpAJjHKetgxaHVvzyBQwaBb4Yb5envrlhc259O9QahP3vd70HHej7O305j2wwsKvKxgN83XM1PE7GAvZB3BJD5q+gd6vS8r0qhpWSt/xFld4CjzmhDHbf/6Qd8DjMa5u9mS6IvjxLOzyRMhY0EBtZV6gbQpaCrt0w5WhHWU6oEIHbzg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

In PFN mode, guest_memfd does not allocate or insert folios into the page
cache (inode->i_mapping). Calling truncate_inode_pages_range() is therefore
unnecessary.

Instead, call unmap_mapping_range() when in PFN mode to unmap any host
userspace PTEs over the punched range, while retaining
kvm_gmem_invalidate_start() and kvm_gmem_invalidate_end() to zap stage-2
KVM SPTEs.

Reclaim any confidential architecture state (e.g. SEV-SNP RMP) on provider
PFNs across the punched range via kvm_gmem_pfn_reclaim(), querying
.lookup_pfn_range() to skip unallocated holes without allocating memory.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 206b90646c743..0819c3653e88a 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -143,7 +143,7 @@ static int gmem_provider_get_pfn(struct gmem_inode *gi, pgoff_t index,
 	return 0;
 }
 
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
+#if defined(CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT) || defined(CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM)
 static int gmem_provider_lookup_pfn_range(struct gmem_inode *gi, pgoff_t index,
 					  kvm_pfn_t *pfn, size_t *nr_pages)
 {
@@ -379,6 +379,29 @@ static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
 		__kvm_gmem_invalidate_end(f, start, end);
 }
 
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
+static void kvm_gmem_pfn_reclaim(struct gmem_inode *gi, pgoff_t start, pgoff_t end)
+{
+	pgoff_t index;
+
+	for (index = start; index < end; ) {
+		size_t step = 1;
+		size_t nr_pages;
+		kvm_pfn_t pfn;
+
+		if (!gmem_provider_lookup_pfn_range(gi, index, &pfn, &nr_pages)) {
+			step = min_t(size_t, nr_pages, end - index);
+			kvm_arch_gmem_reclaim(pfn, step);
+		}
+
+		index += step;
+		cond_resched();
+	}
+}
+#else
+static void kvm_gmem_pfn_reclaim(struct gmem_inode *gi, pgoff_t start, pgoff_t end) {}
+#endif
+
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
 	enum kvm_gfn_range_filter filter = kvm_gmem_get_all_gfns_filter(inode);
@@ -400,7 +423,12 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 
 	kvm_gmem_invalidate_start(inode, start, end, filter);
 
-	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
+	if (kvm_gmem_is_pfn_mode(GMEM_I(inode))) {
+		unmap_mapping_range(inode->i_mapping, offset, len, 0);
+		kvm_gmem_pfn_reclaim(GMEM_I(inode), start, end);
+	} else {
+		truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
+	}
 
 	kvm_gmem_invalidate_end(inode, start, end);
 

-- 
2.56.0.257.gf7497c7d27-goog



