Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ACF3608BB11
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hx3uuviZ
Received: by kanga.kvack.org (Postfix)
	id C15C06B05CD; Fri,  6 Nov 2026 19:37:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCA156B05D3; Fri,  6 Nov 2026 19:37:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CE2C6B05CD; Fri,  6 Nov 2026 19:37:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 569DE6B05CE
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:10 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC350120281
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:09 +0000 (UTC)
X-FDA: 85406458578.11.991B158
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id A5529180003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hx3uuviZ;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011827;
	b=RP8KovNxufyWewzNzoqNTSGkyUT5WN40PFT+vVbzNjm0H5zzNecewsaWSfDiBTFjL5JDBo
	R1CZaEdzywUD2iPU8gxfbkqpqGZzbp84gvQThMY8UEcBOnxSkoaTrgsKnQrK2oOPEIKKmp
	u8Nr6majMIMtuqRpqbpHGH8BlWeqywA=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hx3uuviZ;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011827;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JrP6l22VK6AldWxiWhpFsQCv9l0Qgcd3J7DNoznOHbY=;
	b=MBC99BEnPh5h4oLVyNHCiO3j6Wh/iX2EZCFuT8R/1BrCrJrvxBUSclNrT586/hs2Z/HzM0
	FoOIMRzs+wOgxDW6KXPw/2NCl0QMVrwA1npkKkXm0J3ZmCggHIJLQLBiMjmzN7v/LFVqhb
	E1OiLAgdicZYa0y57kqFXDYWExfLHw0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 25F844406A;
	Sat,  7 Nov 2026 00:37:07 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011827;
	b=pIOf56ltUFVp8TKwdob/sf3XUAs+kP859hXEEnm3HATr5salmNva4s9ecN+AG1+/dzuk
	 HZC4TxCLDb52v5REw+84eeocIx38cGUDKC4pqmc3ISrnRqvjZnyyBav5CZwtkToZ8fDnj
	 1Y0xsj17LxTpaaX6JfsibOQ24/GVogkfLRMsqT8jQMiLTonHGrP7BeHGlboqSaqJieyWQ
	 eeyyQXRWb9G+UGKytJFLC5hy8N9L/q0UvKLXsCax9l8c1E3Vge//664xxoH/NZefUQzpI
	 YBpWIqxg/RWOpsspqW+d+X7fmvUEtY4QN0uGHl/dQ1HK9njo7BYRdRKtFEpIqHaw3dg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011827;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=JrP6l22VK6AldWxiWhpFsQCv9l0Qgcd3J7DNoznOHbY=;
	b=bngrH46gRD3bEbiwOoWvBz3tyFeKOKpAVEUR48EtzyF+Fe53B6aqQTf8E1JzVqtF63a0
	 TlgWns/3Gd3zi/uCO+bigQXlWNLpuXxxWJ26p0WVpyJIjK0WHY6ep1qw1y0eANfZybqRk
	 LGB4c0Bn2gDPNohj0VbkAvcTy4ni0X1FUKwDfOkwlIoMbpCqgsYcIM57KhXVtg8p44uTC
	 CWu+Zrb3TkHsxP9WYBO2BvZqOWPrOORsp3mq0IS51Zr9ODPmkIeZGQTtVEAIW0C6EeY3o
	 l2X09eYT7Z5YtsSW6NMRGEUikAh9YjrK5t8OgojaJlBpzgEJj1h6HVE6aGFRXu/Lrvg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 24F781F0092C;
	Sat,  7 Nov 2026 00:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011827;
	bh=JrP6l22VK6AldWxiWhpFsQCv9l0Qgcd3J7DNoznOHbY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=hx3uuviZV9dttW2piCRtuIyn3jTtJRrhwB0hi1IIp6523Hpbpx+Mts8ZNhfp/NJBi
	 so5CvAr0GwA7t1HyRTbMnY1r/NYb/CYGAAFRoxKzC5twOsJTyA8SHQZfuYbGTGp5gI
	 pHCUrWFXj2e8g1CU4SEM2qXrjahR0M4Qw3cu0mbjtV3SZtO4VE5TUUTyiiAxR3QI3+
	 Yd0jAjO6a67U26nYAsT3Yh2KOcTmHizCiW/MG6uZWR/9WpD+f2DQTozQXcwHRQng2d
	 Cb1KdUW4OCMJ5j9OXHozuEXe+gmBQBA+cDtk5yM9Bj4syufJ9BVc1rw1CFNPvmIkV9
	 NA9zuB7OHFxqg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 564534799E;
	Sat,  7 Nov 2026 00:36:55 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:09 -0800
Subject: [PATCH RFC v3 35/88] KVM: guest_memfd: Support preallocating
 memory via fallocate in PFN mode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-35-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=2052;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=y5ji1QZXHiuR/oyFz2HLfJNU3wDMuExGaG2bV2F9jH0=;
 b=DW3LHEMrOWHyFBzYbIPFyKM5f6WF7y8psIUQsI0OqS5DAy7Qg1PqfpHwQmy0Y47gdcmY7E2JQ
 Pg5dgsEC+uVDKCSzf51XtagCoDyPmvKfgnkxrFZ8dF0gqS9b+M/7K6r
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bcjphuzgzkwiubpgb6p6ffb5irc955au
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A5529180003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011827-213231
X-HE-Meta: U2FsdGVkX1+NlI5hHtBs0n0wdQc5jH9q6yM+1kIztoi+VYvi7c0atMkr5kbP7pDBxXG1XuGMp8UTeE/CbLiPxj+MDLFFtRLsKzzwLyoAf9Ob0bbzrv9BunkOwxYLrnqE5M7mb9L4os2D7L5PClcz06Jb6TQnFKwhUYJtoRp/bj+JDiKkyG3tYIx9QzQkZVN2w4Ydj5QAzjoeDEYCFXOyYMDJB0qrR2MxK5WapTHAOFjIcNrpb11Y73JNbb3qiyCcMn8ZAHwcvBxVEfJRrDO2KViO7LKpXKdRA1IX4c/UE9d2biHH0rns6Q6OBNQMgEtjlQsJTiigsvKKesVPuCmI2CgQuZJU4VP5TgMb/IqWgxXfRb4IkcLawUpHAYWOIqiqCR18EGdCV9T2oYVB0D7xQRnIoFsslN+NREkaS1LgB7tYW6fL6VDbr19+8TnDlYcwdrCMlDLYW1GeBW3eWcqjFoYalek2Nf8PeCZeslbNOqRx8plYJBCAgnDLAXfNX6II3iNpqocqMmz916/VUL4u6AUG1VYqP4pvUVOQBPHOwrxQScnsXk2G3Krvi8VSMi5VrPSPBE0BkXuO65ag+Eyd2VYi44qXG3cTWIFacDraRj7ZU/aZdSAU1wBnZQyw1IKUzVXNGrgeXxBWqC8tj1+qisAO+seASWK/ZwBslAPN4Yroninsy9OWY4dScZCEwd8otnuTygs/AsmleSDJcSIHKUrnCKw+IWXa1VexZEEgXFMh4aUzCeXV/jLZoOX90zD6oEEZeSk1BkH/aY8Vwf0eIoNxmjX1hs/4VaUCVtJr0FPLVdudTNFvLyTIS0xmq5ETdz2a0ZzyO3gN6AHsE7RA2N6Fan7gciv3OcAOHWwinC94ijusxilwh9tiR3RDOGmHHGz1J3MjInGq7ayaN/mGiLuCS23yHCeN+xuvV9XQTXYYDSXEElXpeHpSdfDGRKW4C/1rb+gadD4B3oSfdWf
 XQQmCmMs
 BaWRJO7F7TQAjA/jd1ZqpwF3wO8QCmZEeiUFLymU7hqGkoxjPFGoc8Q1uAoJDdLHAhvQVykOruGAjRmi84OZVwBrcoSHrduyYPBkKFVky86IZJyEtCt7JSdQ0XwmLb51QWcEDp3ZM5URVRRP3AEuHnMkAY9VQ/KzDL8RY7mNoq3cE6PLzrjZWpBiANDcgAm3aHsuQTgIrMpL9llP/5v3Ta9txZKcEhKlB9+yUrYai2hL3ZPSKfphxVD3RlgdZUzDVFaaTBOb5met7YU75dIpSPJfudDHfDwpyEL3+Ktq2G5VhWevg17k8r/u6a0LBisbInZwIxN5fYwDMKTHzkH93ikuTZ5dK1cos4CukcVKEHpOMrfl4WXZo84T8F4c0W6OeDV1DXOR2tEvs5DxNw1Oizi6VRno5xGusMsHO9ucD+aRfuqa0qWJKFF8KlnBwPST1yWtFVqTeMIuy3w62SZsGiQ8T60c0CKupfFGd0AMSz71Ro4s9X7tIeahsA1aKgmDurmwdSF4qbcpCkPC2xEeM36n39WtLVf2VVCEu1aDEFti7CLsVo8ebuKb28sYZ3Otmi3CRmPb/Gr5I4junxVsCQZXVNC0cY4ltLVHiqL3lV5sO4zI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

In PFN mode, memory is not backed by page cache folios, so attempting
to allocate folios during fallocate fails.

Support preallocating backing memory in PFN mode by querying the
provider for PFNs across the requested range. Step forward by the
contiguous order reported by the provider so that large contiguous
allocations do not require redundant per-page calls.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 0e392b8735259..c62e15e05a249 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -411,6 +411,7 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 {
 	struct address_space *mapping = inode->i_mapping;
+	struct gmem_inode *gi = GMEM_I(inode);
 	pgoff_t start, index, end;
 	int r;
 
@@ -424,6 +425,30 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 	end = (offset + len) >> PAGE_SHIFT;
 
 	r = 0;
+	if (kvm_gmem_is_pfn_mode(gi)) {
+		for (index = start; index < end; ) {
+			pgoff_t next_boundary;
+			pgoff_t max_nr_pages;
+			int max_order = 0;
+			kvm_pfn_t pfn;
+
+			if (signal_pending(current)) {
+				r = -EINTR;
+				break;
+			}
+
+			r = gmem_provider_get_pfn(gi, index, &pfn, &max_order, NULL);
+			if (r)
+				break;
+
+			max_nr_pages = 1UL << max_order;
+			next_boundary = ALIGN_DOWN(index + max_nr_pages, max_nr_pages);
+			index += min_t(size_t, next_boundary - index, end - index);
+			cond_resched();
+		}
+		goto out_unlock;
+	}
+
 	for (index = start; index < end; ) {
 		struct folio *folio;
 
@@ -450,6 +475,7 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 		cond_resched();
 	}
 
+out_unlock:
 	filemap_invalidate_unlock_shared(mapping);
 
 	return r;

-- 
2.56.0.455.g6c5a503b38-goog



