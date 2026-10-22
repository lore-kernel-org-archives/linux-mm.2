Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CE35606A327
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZQSKULeX
Received: by kanga.kvack.org (Postfix)
	id 918586B0A26; Thu, 22 Oct 2026 19:27:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EEAA6B0A27; Thu, 22 Oct 2026 19:27:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DE536B0A28; Thu, 22 Oct 2026 19:27:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CCAF6B0A26
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:27:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E6746160351
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:27:52 +0000 (UTC)
X-FDA: 85351851984.17.E6D6973
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id C0DE91A0007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:27:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZQSKULeX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf19.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711670;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c/PcMTlVSiDoElKibJKXS/wLSV8AGDaIx0CeSsAhKHo=;
	b=fOuPUUezJM3GyDzHN0m3BnJmlQIlmfPXFvbmkTbc4Ye93eRNxNsmvGSKcjrPKCovriMYcL
	QPpVcQGkcmsjivdc6XBWN8q0Fwrihgdb6nrpLOQo+c+itnxOA3qCBAl785pB8iiFVkzmaV
	Xsc8/lZcIYWUrbqsPSisIXuu90TKb0Q=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZQSKULeX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf19.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711670;
	b=obHfU9V1Kyt3Lg8kOpS3H27dY1L4zduwuy6RnpKoF5gIRg19397yfTQAFimBMrXJ6Kpeu1
	F3JuDQKT/MRel4EDAyLFOQrZ0gXmyGVls/o2F4Zn/3Xr9UuyAFLVQop09xsA2YnUELzrLV
	FxT3oaEoh6fGX4d8U6Lf0+F14OjBeMU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 984F4400B7;
	Thu, 22 Oct 2026 23:27:49 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711669;
	b=OdDnDGzY56DvWwp1T7EniCdmw5xdvE7vJTuSKosrNSp/5AWscd91/7h+sEnwRSj+xTG2
	 a7bCfY4/zjzPnz9SKB9rnpjBDbqAXEf2bj3FeoEC5jj78POiBHpkDTOhVSE2c/5bx1Ou+
	 FvOWuCZ0Pp1ONg0cKVLOQeZ1ZYfdolPZyfWxzFMFOIMkhkFfbW7EHbOTtgMdOtLbWgpBV
	 FEOSSzdVs7TV9vq5uPmMts48HdWOkzMQayTzgwrofTGWrf3Sc8wqumAsStnszzZm2cnLX
	 Uze+yd72D/Cdeyjuj8p1HAjttumFPyB1mmqRAs193fEp2/JG2GWYJ83WzfJHlljjtAQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711669;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=c/PcMTlVSiDoElKibJKXS/wLSV8AGDaIx0CeSsAhKHo=;
	b=vazLOo4FNvuZeDEN3cla2JHMcyVdZ6JD+Y+Tin39CdAOvsOqAP/LEkYyWBdJDw26TIOL
	 hHDWaTWuRrfEwy3ZXnrLa1wWmDXT4WiSQp8+9kxVw0sxvyNFNrAaqk6+3Q6ocNpfm3gBI
	 yh3Cc3APB7WZTsbFKN/XmiGlwWfK5IFFfp0+EpWAGmUVWKJaP34riVASSgZyoE88UJKfB
	 kp6/8iEM5J0rXOP723hFqFIKJrmOBQSxI9GviW5uoego432m7wKnwN/GEwsFe+jeykCZu
	 29n0m2cDQa0PWZkct19DZ1vazhOD6TmnKxW067AckI4BOesP55OsFtPUc9s7HoSUNjw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D8D641F031E1;
	Thu, 22 Oct 2026 23:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711669;
	bh=c/PcMTlVSiDoElKibJKXS/wLSV8AGDaIx0CeSsAhKHo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ZQSKULeXnXScbq7el8zdVZpkJ4TsdFH28e0FrTRaOeA5cfWnmSS3QuwU98oDrZxKr
	 FnwxemLVFmqsHggH/zit2cS6iMXxsfeqoX/IUltqaTbPtCWiJKJdbalR93Iu2ps2pv
	 +mrBKDVyE85rlBQhbKd+zp/dzKzlQzjYF7V6DfOEsy4sKR6KCCSpiFOKZi89PTcE2r
	 UpW2/p8pFA5DUxGHo7LO7KWvX24MGBFsESXz7ah8CYy/Y23M0lI5gEPUN+KZu4whjb
	 rNupZnuwugqT1wkU5rYDz773icp7ZX7J6SAzxvxD4h2a4yadhHBEu2B7I4Jau4Q96N
	 edrYiTZY1O0tQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 41C5041FDA;
	Thu, 22 Oct 2026 23:27:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:27:33 -0700
Subject: [PATCH RFC v2 01/50] KVM: guest_memfd: Split folio allocation and
 insertion in kvm_gmem_get_folio
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-1-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711664; l=2189;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=GfiMpI8weIzEfe3dYmoSriDA9qkD3c7kHqz6/C+y+ss=;
 b=hnkT7p+18c3Sr3N7f/u3g+FKFjdGy3FOvIKfYK/1YmHBg8FczOXDkZtiTAqtDKGFzJtjTl5qg
 X9gbb0h7mF2AhytYyzNbn1jwp69oDXywATpu4DdnG1D0luF/0cv4Pae
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C0DE91A0007
X-Stat-Signature: 9pb9djpd3b56sz6ng3zc71fb3oiuomns
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792711670-785915
X-HE-Meta: U2FsdGVkX197NBaaOmPfYvVsBWiT6KLPJXoWdbc36kiUmVTM/nQSzFAIn91OdSDLT8xkFnkbYDbms7xkYTwG7x4ZTeApoEh8UNEXXwu8KsCR7aBSqrPZeRc13TGgscxmWp7B1FTjBi0Gl1u5glbQnZjSqTp1X3AtvX2CFOgP7gK41YRb5DzAY5i2gVKkUaeinYzYoMd2AR4ULPI8CJ9/ark11dohT5d73Q0bj7nZfKi+grTK8LAGdHfjNt7aZcUKjAn/aLkJyrTJaV4Z2HJOfLhBRNProxksaOJDww29KxhRjq80p+WcqZ/OX9FesuWcPWOQUeh7+jsSUs/g1EiSuj5da5Qa4OQFVwONG8ikzCs9LmF6SGZZKZUz11oQPPJyoTQAOBJ+QK9uSYnUEo0U+63H0kMXqnwW/MNgj4LWJJ4zVGnRtx9sIAGgF5B19lMEaSwMVz79dfMsYx9rkdJpdYtZOk3uKKYpBQ+i7vZ47UeVGGzqS9BIUb2Pq/uaimzq/TmF6V6V+t9UQfVZWYvcYHkJe6tMXyEMEXUSjopQMkGPwnMRsfujSWVv2+7QU7fccjE3vPYOo0zyMqxUvJAFOqhHGbgO12iFvJWCMjlQOAiIMEKckC0NL0IXmBzUrW5dIMWtL18keij0TNY6gvkDVYhlIx+Hol1ob1K6ayZ7h8TaxphSUfUI4N21nysWIkMdmVZrTzEAJrt4OcwP/nxm0vIAsyqOm2SHRq+AOK0g/2miV/bKyimpX/wZNJjpNixCkZxSE6mv8V7SM+Req5YWIvd0R2TO6TQqYq2K8my+JnMlqPiAgzNb6w0nm8CnJP924TNbT1DGxfiaCsO6rJ0mIZgI/thD1QgqxZhPi1ChFPPn5Be8XQPchY8IoQ7EdkrwzV3JODth8MOGDxBT49KaXqaEihskMg6H+yT4Xh45gfXy9BZ5BoLPV1TW5edbkUDA4QmxovjvQariBlP2jdF
 c1rKBPjZ
 2b7sG78MtIP68Ina1ymMD0jizj6UXw5DQFSqRroxvJTtZWkvmhjHOWx2cSY1BJHgyqN1smNFaqOX6MSKnu1K7cRzgFYNr7pbwzfdGh7my+FWGYQRm9VWsU0VQ/fyeZFL0TSrc/HYViwfS/wB6tx9znJaTrooHxloYjihSkX0HgbqvViL54wh/dmaXMM+5ZdgYqv+vn5KVrym64ARTIoK2Lc9xxA4iUkS9eMJPMabrQZ4lYD+zGn2sRzl3PkhZIwVmLh5ftKTSAAZ4tdNYJVTq7YMeGrJwUlXaIQHD37mE9egCGqW0aibsHzbt+4I7HmA4n56NG63WfrNsiM+J+wksQD1TGTzZMMJssoPiXKPTH6nlObwIVDT28RH4Qw2ddBzG/Ri1mqLG4H6BpvGP9QhMNhVPwN54fxjecw5w3PZ9T31gWByx91xmkfGgaIfOsFEBUzP5Rckf9iNAy1k17/hCdFcHE6OKTYHT860AMPKeMitoulyzw/haP5x9p/OVDvdGGKdNzlTEWPYPGGROGpPKq2t/0dEs0/werBIUE40hhc/enx3sKOoTW2FU9ecodZXrGgkJyTA583z5WQt2i7At/YBk99/d1usBcS1n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Separate __filemap_get_folio_mpol() call in kvm_gmem_get_folio() into two
distinct steps:

1. Allocating a folio via filemap_alloc_folio() with the NUMA policy.
2. Inserting the allocated folio into the inode filemap.

Handle -EEXIST from filemap_add_folio() by retrying filemap_lock_folio()
safely to manage concurrent insertions.

Decouple folio allocation from filemap insertion to prepare for supporting
other memory providers.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 93f3d29d5751a..f865fa0e46840 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -131,7 +131,9 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	/* TODO: Support huge pages. */
 	struct mempolicy *policy;
 	struct folio *folio;
+	int r;
 
+retry:
 	/*
 	 * Fast-path: See if folio is already present in mapping to avoid
 	 * policy_lookup.
@@ -141,10 +143,19 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 		return folio;
 
 	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
-	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
-					 FGP_LOCK | FGP_CREAT,
-					 mapping_gfp_mask(inode->i_mapping), policy);
+	folio = filemap_alloc_folio(mapping_gfp_mask(inode->i_mapping), 0,
+				    policy);
 	mpol_cond_put(policy);
+	if (!folio)
+		return ERR_PTR(-ENOMEM);
+
+	r = filemap_add_folio(inode->i_mapping, folio, index, GFP_KERNEL);
+	if (r) {
+		folio_put(folio);
+		if (r == -EEXIST)
+			goto retry;
+		return ERR_PTR(r);
+	}
 
 	/*
 	 * External interfaces like kvm_gmem_get_pfn() support dealing
@@ -153,7 +164,7 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	 * to be updated for anything otherwise (e.g. page-clearing
 	 * operations).
 	 */
-	WARN_ON_ONCE(!IS_ERR(folio) && folio_order(folio));
+	WARN_ON_ONCE(folio_order(folio));
 
 	return folio;
 }

-- 
2.56.0.257.gf7497c7d27-goog



