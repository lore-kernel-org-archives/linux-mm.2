Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F435606A323
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=odrpe2S8
Received: by kanga.kvack.org (Postfix)
	id 2FDA16B0301; Thu, 22 Oct 2026 19:28:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6266B0309; Thu, 22 Oct 2026 19:28:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C5516B030A; Thu, 22 Oct 2026 19:28:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7DD16B0301
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2FE7C14031C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:28 +0000 (UTC)
X-FDA: 85351853496.15.89269A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1541F40003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=odrpe2S8;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711706;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gtSjIpydTrMblhKZ8GTXpi+Aa3MTEkqowhZwXUPn67s=;
	b=JyGvOqi+A7NKNZ3h3CWJ1TzbuW44LBuv2xZsowlWkbbqvSBwaC/PuPI8hmesFt6Dggfcfw
	aFxb+4wsQ7R+Nt/svRMJxnEHBXeMu/Tfqb1O7CyfCStxT99m5juO+4bgyHiYbh2NkvGkjJ
	vNt0M3nnSJdixT4VssnwgaOXqHKw0Lk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711706;
	b=lfeI3LbFdkxwAI8Hpl1+7kPIZ+e4ekl4xQHYkLEbLNSb+eObfsLzd9Oq+DdJhRdCFR34h+
	baUbq0N/kIGofz35r2ul+ZD4O/cIE71U2OBut74cg4KbMxFp7Ncm/mjlBO5a5iK7gH86YM
	Z5dxIBE+UNMSHz96eYVETvLidrhLDWs=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=odrpe2S8;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C46A24481A;
	Thu, 22 Oct 2026 23:28:19 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711699;
	b=nQDiOpqNw88t42xWjNpgTpZztrx4s0JJ3a/OF/bNv7P9ijmVIAzdeenulKr78RobQg+J
	 V+KnjvYsjKRPEM+E8xAx7i+ne1JMWkH3Sc0O2raWAkMUKdlWUEUv4kh2/WWn0SZQBTedr
	 3pTr3w4p0LPRe53ZRZNFIQu9BX/+NKsyheXQJ7PJEofDWxC12qOquZXNjtwkz4pTOGpR1
	 bf/3ILb2rQ64n6NgMYD2fvH7TSiKIv5qow7H3FgUE1wOYS1Vlgk/CIOAKJb4335HNyClj
	 joMS0yu+DgkpL/nw4nHuNLujZ4vkfE2d3ONj1mqUGCrM6JMUIjFknxm8zqoPC006lCQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711699;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=gtSjIpydTrMblhKZ8GTXpi+Aa3MTEkqowhZwXUPn67s=;
	b=zeB/2QmTmL8UWJZTsehPhkQ/UbbQOXx/57WH42Lfh7nKjWkRElqKrEhyC51cLigEluDL
	 w9IVZ8r/91+M+vuza3KkGKdcQOADA4qwqNAEvNFfAcbLh0NBK0o4g8yQ3qx4whPyVPKkO
	 FpViZRT3XwhWISnJASItgphpWeAWga9z3HCZcDSuJJcA8mYRuwg9MEcPK5XkF/Wfloqh4
	 Ypr8RooMt1GprKXlyHZHwetN7LooJLkZuJyClENtbTMBGikNlEVJOiJ1Pw5EIYHt3DDn9
	 BC3Nzjd3QlsuiH254hpPRDAJgsjNa8DrQk9w94o/NzmEaxVkRbglRDW/UOI38fPC1jQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D1E9E1F01182;
	Thu, 22 Oct 2026 23:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711699;
	bh=gtSjIpydTrMblhKZ8GTXpi+Aa3MTEkqowhZwXUPn67s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=odrpe2S8HqmuCLF0WqmaMKTkp46Q2ZdM/nVioU77RizwgTgopEGnkT1l46eR+a+Ik
	 +7WIPBI2WRf1u3ii9vYRixROC99dzrA+mmmMlvCtCJ85tqM1LVfAD417BeM5GaaDiO
	 zQEPRerjALhlZvEW25ewhRHeEZN7N5MsK8IG8Pt9CZ8KiRkzjBnimOD1FsgdVxjK2H
	 HmIPmA+Kc7lXkEc8ftpFp2VcoR0C6VySwRpN75SAlD7IIBfSp/UCeBqFvNU791DGjO
	 g1PrC5kcyHRsfu8ajMhE8/HqIm8KaF/E9qLJRGK409y6WBrYzQNNumyZgFgWU2+8Xs
	 x5JSRFMvyLFHw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3621E420E4;
	Thu, 22 Oct 2026 23:27:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:28:12 -0700
Subject: [PATCH RFC v2 40/50] KVM: guest_memfd: Support put_pfn_range
 provider op in PFN mode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-40-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=3575;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=fQMRQxusZ1KmD4dPC2As64TjcyJvgKaoXqpKrVt4BKs=;
 b=441+taHyVGg3FOmYBS6hIkVBssZuzaMXxGa8VYy3o42dXNzBFf0zRuCuCp0rd2+Xc7H6tCxAO
 gOn8Ozq7ysEA0qQMA3sh6bogKiwLKMoH6biYx3NGNEr70RBWa44tYBz
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1541F40003
X-Stat-Signature: bpsqsmfodndi5jf85dpbop1pujfkgfxt
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792711705-207031
X-HE-Meta: U2FsdGVkX1+PAvi+Q5weVmPiDHfRsNzbhpim9LQMiqt7cH3MOie9R1TGQZq5amvTqNFz1X92O73pJplE70vhToMzaS48kg8QirxCDCdmLKNimvy0oKVh0PE0Tk2x54YMYIMNFqNZx20wiXpcxg/nV9PyXd5aBg4n0KIFrR7bqVdFWvICzxAeZwfLqc9oT3eWgFleA9SAB6Axzb/6nXY/cM1AZbC82yyXQobG3ubU4Z5lg8qtqxUFmHPFKNl6dBCBg8sQnZQMEmROXBd2jXvuZz30aAxqfNnohK7lcx+0UfF/Ow+pqGYiL3AoT6rYWb6rKxKGraCoSTTjYBgkb7xV7YR2k42Z+2Psg+LHi86AYCQ/6h1nNr13/BqWKDFcZVnMvetO0UWEdDM2MnSMXURfC+FWtEpfv+oU8uaqymatwN3AtT8peZuz2t8Yakq9wcA4PLUBROfLxqBzS4PLaxy9Gz3OIWDw+2IigpZC3nT7cuumxoJMZPwkd7v1E8Eg+bPIfuQ1jRwJXlbdlzRW+ZaOBPGuVX/Ehnd2dLPtaQjk7M0B808vHoc3njDclv5LdpH1ZqLMFogdCudhKB0eYJNFxQ6jx7PyHk8lxGA39iFdbYf897loLXFUSt1+SXm/O3+4sjvWglxzHL+Ra6kTcLktSy6tXeBYEXaySPWtj8VHUakcjTAeHU1Rmlwje8WkqvNLzeWVD+KDYTQf68u+l0UjWTByn7spSvVwGrqJ+s6eiOjro3rokk1KEinuoy/sk2YN/oLj968xwxCEsNgLJtTDDRLBzybwGrjUboQmrGxRVNFdUk5ciU1dZigIQ9znSjWzMECoUK0pNnh1337Lz8sulcZ2BEFXVWi/1e3FzNjLNT95HvpCdbXM59sYxXlyx4/nJxInmnGRa3SD4jpdWcqe6k3NK0zi4oHYlKgfjgK+hXLE0iQVv19wLuktR90tZHpvm68+E7AlFnFzWwxXq61
 5CRlVPgC
 SbbGIQHZWoqV3MpKHRFOxoc419PFiHjGITNSMIJR6KSiZLVsyrexZHxeQXMqqO7Kj/luBdutIKCykXGtXhpNhNEy9aa+lPQGP0+kQcJ0nuULG8p//Ngf8suhzHIrDPbLpvFF1R1GYz4MW4tdq2y/DNQtKc6o+Pzz9/Ov/vTWyi0jZbZJGm9lCk9Iaj1tj5/VYAyP0rt6VahKuTmJC28b7rrQgxMmZugyhk6xIaqZ/g47URbJVVOPTP4squ8CIZWZjADjl7c77UK/2ZSHoywy0UgOXsG1F7ClwG/KewI4MikZYjPftKk18dK6u0TfV7WuE9oiqWJxK8b3uW5vpLUr49NT7VJ+WPh7D7LJMTwxuSJPwysbFo+Z/i5KmS+PS8a6J2AVCU43BKlmnmPX0dBYGbczhStJO6pxn5P0Kf6OH4fqgTY5P+E54zsWrKngQi716dT/i4bRuAnmQ1BxYkpu9RbfFjoiWkCWnMwiry62DoqkIKr8F6V3awDVjrTi4goyJrkwRAdfPFj7rFzGs563QHlIVu93if/jUPoXB44Ygm3PMpFkRQYnadQ/DxIaX8g81EQxi0shiq/IBayQfMJTGt4Vsyx3YwdYZY+Ja
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

When punching holes or destroying guest_memfd files in folio mode,
folios are truncated and freed, allowing the backing filesystem to free
or reset memory.

In PFN mode, memory is not backed by page cache folios. To inform the
provider that a physical range has been released by guest_memfd,
introduce the .put_pfn_range callback to struct
guest_memfd_provider_operations.

Invoke .put_pfn_range() after kvm_gmem_pfn_reclaim() during both hole
punching and inode destruction, passing the file index and page count.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/guest_memfd.h |  5 +++++
 virt/kvm/guest_memfd.c      | 16 ++++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 2f1c679dd154c..3c0cc35f748bc 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -33,6 +33,10 @@ struct mempolicy;
  *                    -ENOENT. Return a negative error code on other failure.
  *                    The provider must define @get_pfn when @lookup_pfn_range
  *                    is defined.
+ * @put_pfn_range: Release a range of PFNs previously obtained for a given
+ *                 index.  The provider does not need to ensure that backing
+ *                 memory is present. If backing memory is not available, the
+ *                 provider should skip the unbacked range.
  *
  * Used by filesystems and device drivers that provide memory for guest_memfd.
  */
@@ -46,6 +50,7 @@ struct guest_memfd_provider_operations {
 		       int *max_order);
 	int (*lookup_pfn_range)(void *provider, pgoff_t index,
 				unsigned long *pfn, size_t *nr_pages);
+	void (*put_pfn_range)(void *provider, pgoff_t index, size_t nr_pages);
 };
 
 #endif /* _LINUX_GUEST_MEMFD_H */
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 88eae9d6d249f..5741ff6ab94c6 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -171,6 +171,13 @@ static void gmem_provider_invalidate_folio(struct gmem_inode *gi,
 		gi->provider_ops->invalidate_folio(gi->provider, folio);
 }
 
+static void gmem_provider_put_pfn_range(struct gmem_inode *gi, pgoff_t index,
+					size_t nr_pages)
+{
+	if (gi->provider_ops && gi->provider_ops->put_pfn_range)
+		gi->provider_ops->put_pfn_range(gi->provider, index, nr_pages);
+}
+
 static void gmem_provider_release(struct gmem_inode *gi)
 {
 	if (gi->provider_ops && gi->provider_ops->release)
@@ -426,6 +433,7 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	if (kvm_gmem_is_pfn_mode(GMEM_I(inode))) {
 		unmap_mapping_range(inode->i_mapping, offset, len, 0);
 		kvm_gmem_pfn_reclaim(GMEM_I(inode), start, end);
+		gmem_provider_put_pfn_range(GMEM_I(inode), start, end - start);
 	} else {
 		truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
 	}
@@ -1647,8 +1655,12 @@ static void kvm_gmem_destroy_inode(struct inode *inode)
 	 * Skip if the provider was not yet set up, as iput() can reach this on
 	 * error paths before provider_ops is initialized.
 	 */
-	if (gi->provider_ops && kvm_gmem_is_pfn_mode(gi))
-		kvm_gmem_pfn_reclaim(gi, 0, i_size_read(inode) >> PAGE_SHIFT);
+	if (gi->provider_ops && kvm_gmem_is_pfn_mode(gi)) {
+		pgoff_t nr_pages = i_size_read(inode) >> PAGE_SHIFT;
+
+		kvm_gmem_pfn_reclaim(gi, 0, nr_pages);
+		gmem_provider_put_pfn_range(gi, 0, nr_pages);
+	}
 
 	gmem_provider_release(gi);
 

-- 
2.56.0.257.gf7497c7d27-goog



