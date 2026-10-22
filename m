Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57BB9606A33A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FAypvebQ
Received: by kanga.kvack.org (Postfix)
	id C03F46B0A46; Thu, 22 Oct 2026 19:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAE7D6B0A49; Thu, 22 Oct 2026 19:28:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A76A36B0A48; Thu, 22 Oct 2026 19:28:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 718DB6B0A46
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F28C514031C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:20 +0000 (UTC)
X-FDA: 85351853160.25.7F04BD6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id CEDEFA0002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FAypvebQ;
	spf=pass (imf15.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711698;
	b=jVBxjkMZ6TesLfSilhmx6WUasedSduFTcm79tdAM0DNfm0RI7TezP3eqjsj95AqIUZcoBB
	MI0OWAslPdqJt2LaI1ANxMDo8cPzBEwUHP7Xt8G4tul33UMDoWVpkA1MNhEv1RQwScnb2m
	MQuSejT3BUFeCOoJN0eMzp8bFZN+P88=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FAypvebQ;
	spf=pass (imf15.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711698;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xJxi51KvFSw85wiowaP7Oh1KZBZ2sB2L+Gq110fvDA0=;
	b=ekqLxb9zZeIrR9IrLq76cXBxayK5jPSrXghviUZAFRG6jlVKnK+vMsTU6paxaB3eCy1M4c
	0TQ7sgSa0L5/CtbtgzapUlFZBz+MCzsgZzawOmuWS39mjCNY6hWvNUnRll6RsGMK9DJnlQ
	XD4+iPKJd85ciPUZ+SinFiEqg9Xtogs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6658E447D4;
	Thu, 22 Oct 2026 23:28:15 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711695;
	b=NpDhvQ3iyH+QoymN1cgVInzGwxs/Jru8N9kbLBApxNvau+N3AS7Z/q5gdTFQ1yl1jwVO
	 KEOmhRfRpTtwf6tckj7KzZG7TGyjwmPpPZtK/Zo6/7zczN4klPIi4XRdyWPNeVTpKCfdh
	 NFusMKguiNASPSWPZwUR/g6V9EVPPuQG8RY0ZZxP7bK1oaifjMjhFQJoLwJso+JTGcTbY
	 b46kIhL9JVr4uuUz/Gx1deu0GiyFofzz7RmIiQNytN+hFEaSo+HMhbjUBbrvZaApaxW7b
	 jY8hT3lO0QYd47fP8StnzLGo+wuSTk/8whQgyKtW0/cnIuvGUjn4fJzcHSouo0KFTiA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711695;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=xJxi51KvFSw85wiowaP7Oh1KZBZ2sB2L+Gq110fvDA0=;
	b=bzo3Xv2hjVDIhWIcPNi6Ua0mZpO8VA9ljLJAguM+xeCfxXvfZvx5Ql3OQbVM2LE5bdpq
	 Vl033Jd6rMwdNWXaREB+WHZRVmsFUqDP3FInguuaGe8z+y+OAAROpBncZ8gHq/qwFxx/g
	 Cclz0JoRV8wFfAN6A89AunALME49/lhLhqQmsoSxz6+GDWiyfbijxhfMwllcptg6BuGtk
	 gGHoNtsmKBZ1dFzaW0hrA2RHrEKB/7+c01gfa8AZeeFm9I5e/UHlRNHiNYt3cM0eUuHD3
	 UXbjYVK1sTk/2+9cJfFVHq+BqjFIIBhs7vREyXAREUlqtdYQDNSBOrKDR/OJeAu+hrw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 40E571F01182;
	Thu, 22 Oct 2026 23:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711695;
	bh=xJxi51KvFSw85wiowaP7Oh1KZBZ2sB2L+Gq110fvDA0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=FAypvebQhCZTBMuGdAAcWqAYDCx9tbA/snpNYMxIxy2bG+8uPon0kal+9riF8sL3k
	 fD5V5Sy9+kLZDEItV/6lz+eJRbHzPuhciG7DALECOZL/yIJEJXZVtmkk2gsczDC917
	 zrMa37l/Mr0H7xGV+afz7wccIlmkyaAt2qztSpybLprQpao1/LW+uvWMW6PXxXQWhb
	 RXGn+jqwKb0H8hNlS34+SntHWAh3RZxaS7q7bhMtUAlxflU6jAFYoG6bP9slTfP+Q7
	 wvTMdgEs0JAWt5KcBh6OT5ydjxcryuPmKGMyO0xamdBZJdXUbz6J3kcTKmrIJt4iaL
	 aNO1jOatAh1Hw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id EF12E420D0;
	Thu, 22 Oct 2026 23:27:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:28:07 -0700
Subject: [PATCH RFC v2 35/50] KVM: guest_memfd: Support converting to
 shared in PFN mode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-35-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=4337;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=nqK2K7e8/sm8lvlYRKeUesCLydYLdAKdkCQGMtClssA=;
 b=zX6s8nCT6x5QOcSpXO5MotcgtO11g3eAyDXuzCIhKrw8cmV8an+rPQOPFg87LCvcpTGUcMH/K
 jqsV5JPgLfSB/OGtlDhqPXJY+g8HYUjvR/qmxQ78/TGKUiEA4+66z1S
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CEDEFA0002
X-Stat-Signature: kpryf9uxx9fj8ztbkpbnfb61qskf6iot
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792711698-292333
X-HE-Meta: U2FsdGVkX1+ZuZeye47OeJsECA1DGTYvJhY0vMXfYryEfIw+W0jry9IfC8EYi9lQzxhFw6UuvvIrWg6Z3h6WIN6tnCY2ERarw9CgwCpxA2ZvsQjBsnwzf6re6r357BlawlyYq1SrPwTdePD+ntZx0oi4wkg1tYa9Mkfx79bwBZgWIdIq1wY5Mzyn/LndoFJ9eJs3ADt2W35NKaLUr6wIv3PAFVrwTd4B66SGmpupHiWsYhNBknkdYDaOLbQYqiBNU/kZzFrK84yUbE6oXFofuRp1UZT6qxjCGA7dXQ/Mq34jkwR18QTUVfeHO16PAS3FnyuHyG4mu8UNDNqmA5f4z7Q5Eem9yDHp52YSo2H2WkFOscqheQpXe78SNbTLHwxDCqJc60fExzdaCFIsjoBdcPKSNGN51eCoiyuiMRhTCgDj5BvsCXeWK02p00Rcz743Qwi77awMVE+Rgjup6uslWFW2Q0zZLN6E0Y5K9rlkrT7plSIvM4v4PrDdiXiOdp+Vnifm78eD+tFZZc34WaYJGG8M/6VgcvyaKCTfY8vgVmFB3z80DXMTrJXjGkojQ/GAB1fI3b0nwq05h6vGJBHzvCFXerZ4bso4uMUeHMaa59zjmI2XtjEvxE3I4E/FdG3/IPjHlPU7bAz/d0n04r+DQDJ1dzufdQ01JWc+Qf1L344J1J7dmTK6gGBf6q1bcT8lVm1Wjej+T8UqikseKJlaz6fSq/fCrny/QX6vif3ncVMhXIQo4Md2KRE95ItbmGEuYuMVLFQy1iRzugLwOVHCRKJdIGhiki8PBPvkcPSUOvr3Ayeo/ALG1XgaAIxwn8tgV+tRyB4ag7svh+EwKG7kzmHqDDQNGI8QCkolxO0mSJ4L5dNprI538by1a924FkTMqDrjmO3+yYRqPBvQX+sbxyJbfasR2ecYkAHehR0PapOP5GGD2mY4UQDZWuwySXQgJ3xqaJ/Cu+otGTq1A1i
 viCw4oan
 7cx36IIMQ+UlbaUpty5DJ2gVlGhgV5xjz/Ky5PiPkKWOlOrRZjXm6wdeKPgdxSJs7Jqe0qzLrHLiNQgMPyNwXZp5fIN7Pf+iWlNt8ze1o8Frzh1lQ9O1uLPxSVrj9wC+LS3A84+LCpmmU1MfxBjZzLCcBZF45EoOOnnkpV8o1jEPHxqD3IQ+hBtPmJAPYGh/Sq3+OYLoDHhXGiuDWuHBqup2XJTMMYmNxjxozCy8+Ur/xRJvLsX2TSimi/QFnpe6KJkSI2GPiaEJg54Gf3lFZ6C2cKREhmDwRL6Df5rUVbwFXaflGmDDvojnGP239fpdYAB+ZhfK5JupKyo+1rDagw+KesfgncaWCqIGj9tg2mxcG03LARJF9Wg7qiXYtU/VAJwk/BF2gP4ZoJ3BocdRK6xUFYdHz8h3orNlHZsoR5KqVBUnhYJ+LOmhKWNkkwngOzvAavM3vVnLxuVHtG7tn4LoKrHDmmTP4gjoUM/FS/sLCF3Ss9Vpqkmz7W6/5JSS/ffLsaQcRkn9P/JuB8ryL862Ps6lCcygBMi5VoyYN+PFKI3P2c6KkCKFHEWUSxy9UXQRE0+YW4DuW/RVCNygSA2rtFzjsyTsOVfSocZX7ti7EEvk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

When converting memory attributes to shared, guest_memfd iterates
through folios in the page cache to notify architecture code.

In PFN mode, memory is not backed by page cache folios. To notify
architecture code without unintentionally triggering memory allocation
in dynamic providers for unpopulated ranges, introduce the
lookup_pfn_range provider operation. It returns the PFN and number of
pages of contiguous backing memory, or -ENOENT if not allocated.

Add support for PFN mode when converting to shared by querying
lookup_pfn_range and converting contiguous chunks.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/guest_memfd.h | 13 ++++++++++++-
 virt/kvm/guest_memfd.c      | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 10c48f41a6d7e..2f1c679dd154c 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -23,7 +23,16 @@ struct mempolicy;
  *           zeroing if necessary. On success, return 0 with the physical frame
  *           number in @pfn and, if @max_order is non-NULL, the maximum page
  *           order of contiguous backing memory containing @pfn. Returns a
- *           negative error code on failure.
+ *           negative error code on failure. The provider must define
+ *           @lookup_pfn_range when @get_pfn is defined.
+ * @lookup_pfn_range: Look up the PFN for a given index. Returns 0 on success
+ *                    with the physical frame number in @pfn and the number of
+ *                    contiguous pages the mapping is valid for in @nr_pages.
+ *                    The provider does not need to ensure that backing memory
+ *                    is present. If backing memory is not available, return
+ *                    -ENOENT. Return a negative error code on other failure.
+ *                    The provider must define @get_pfn when @lookup_pfn_range
+ *                    is defined.
  *
  * Used by filesystems and device drivers that provide memory for guest_memfd.
  */
@@ -35,6 +44,8 @@ struct guest_memfd_provider_operations {
 	void (*invalidate_folio)(void *provider, struct folio *folio);
 	int (*get_pfn)(void *provider, pgoff_t index, unsigned long *pfn,
 		       int *max_order);
+	int (*lookup_pfn_range)(void *provider, pgoff_t index,
+				unsigned long *pfn, size_t *nr_pages);
 };
 
 #endif /* _LINUX_GUEST_MEMFD_H */
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index daf4541c3dec6..734107dad63ee 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -143,6 +143,27 @@ static int gmem_provider_get_pfn(struct gmem_inode *gi, pgoff_t index,
 	return 0;
 }
 
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
+static int gmem_provider_lookup_pfn_range(struct gmem_inode *gi, pgoff_t index,
+					  kvm_pfn_t *pfn, size_t *nr_pages)
+{
+	unsigned long raw_pfn;
+	int r;
+
+	r = gi->provider_ops->lookup_pfn_range(gi->provider, index, &raw_pfn,
+					       nr_pages);
+	if (r)
+		return r;
+
+	/* *nr_pages must be > 0 if there is no error. */
+	if (WARN_ON_ONCE(!*nr_pages))
+		return -EINVAL;
+
+	*pfn = raw_pfn;
+	return 0;
+}
+#endif
+
 static void gmem_provider_invalidate_folio(struct gmem_inode *gi,
 					   struct folio *folio)
 {
@@ -783,10 +804,30 @@ static bool kvm_gmem_has_outstanding_references(struct inode *inode,
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
 static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end)
 {
+	struct gmem_inode *gi = GMEM_I(inode);
 	struct folio_batch fbatch;
 	pgoff_t next = start;
 	int i;
 
+	if (kvm_gmem_is_pfn_mode(gi)) {
+		pgoff_t index;
+
+		for (index = start; index < end; ) {
+			size_t step = 1;
+			size_t nr_pages;
+			kvm_pfn_t pfn;
+
+			if (!gmem_provider_lookup_pfn_range(gi, index, &pfn, &nr_pages)) {
+				step = min_t(size_t, nr_pages, end - index);
+				kvm_arch_gmem_make_shared(pfn, step);
+			}
+
+			index += step;
+			cond_resched();
+		}
+		return;
+	}
+
 	folio_batch_init(&fbatch);
 	while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
 		for (i = 0; i < folio_batch_count(&fbatch); ++i) {

-- 
2.56.0.257.gf7497c7d27-goog



