Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37EF460885C9
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sr/HKeXx
Received: by kanga.kvack.org (Postfix)
	id 00CCE6B05CA; Fri,  6 Nov 2026 19:37:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2C706B05CD; Fri,  6 Nov 2026 19:37:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E14136B05CC; Fri,  6 Nov 2026 19:37:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B333B6B05C9
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:09 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42BB2C013C
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:09 +0000 (UTC)
X-FDA: 85406458578.13.54F90A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3337320003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Sr/HKeXx";
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011827;
	b=st6FyVcIgtgtzoF7+dKlTu3sCDFcjVZQnQ6+Ft0+hgE8VdiD1S9r+cfECeyl/0JYfNM1du
	qqnObr6NzZDuwbT2Ari8GCOgkdjErB+uHPX5xsuyYIOGJCcYPAT5eveM64KY0Ugfo5wW3S
	s6Y1ztbCh+PM19UO6AHpx1cp7+6/fl8=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Sr/HKeXx";
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011827;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GG/vi0gJ8pTHrLZGRuIsOdTtI6tx4Aak0QyiCSlFpoE=;
	b=f8E6tKWkGZ6LMqylwdIjUgaBtc8YAf3bsFdH8s8skKwiPjaEDsqZY0Gv+PapBbtM1geHH5
	MoCs+QD+PUUsF7HMAfAnOZDlm3E82A+Wf0BHNZTwHewaTD5O+2o6fb9dj91JfC1Bmf3Gfh
	Nws7uMY6dBONV9klP3DsGqe3mi6Cfo0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 835D34017F;
	Sat,  7 Nov 2026 00:37:06 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011826;
	b=Df8QglB/TUk3FzbaeAHZ2/I3OMtv1blVusJAlbAckTpCX2lavBb40FPr++NG01Y/VK4c
	 PzdeP9oAjbZXtmEPq4a+cd8akZjzOC13W9OOgUwgmA4nDBLygw89BOjRIulTb+EVbdbaS
	 8XoBHJ10msffbOqf/jmt1q+br7/xC6d41uIxZwFp2y7XSJG2L/Epe4pZxA2tt4Gyp9RdE
	 r3YKF3Ed7/uEh7+AM48eQLsUXMcWkjVYaT3NdwwpgTQJ7Q21l+CBQsgqE0z6JHkf3y7SV
	 QyhrnAyyvvyO7j+XDplj33PJ7GSQK1jzYAuxqhvAJObTdhRN4BxQkiCpyl1Bs9irWmA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011826;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=GG/vi0gJ8pTHrLZGRuIsOdTtI6tx4Aak0QyiCSlFpoE=;
	b=VWetsHcOd/gg92AKF6N1EC88C7mRo2Ch/3xKXO6sXEr6bcfx7j99SCM24n1M1WtjELNh
	 9dX7IOVA+Ag0Zh7OaEpctGkTIIKHxC9SXw5qKkVwKDxlqNMurAvQQttxnLk/BcnTB6JYf
	 D7SPLSJj8TmF6lvVnVotlrGrDmfBM+hiDMqRuSi5kFWzt+X0l4jHgH1MJ00PW015JgOr6
	 Zsh13n0O8BmO3EasjQRctr9P/w863FgKgBBIjlbclIWnYaN82juqxgZ1Ytrm6IXp9I00o
	 7DTZvOWSAUoNRfWueTatKMwob+bZWS200psCJq8sk4iNjTtc7NGHC3k7na95LJmwzbw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B17901F00932;
	Sat,  7 Nov 2026 00:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011826;
	bh=GG/vi0gJ8pTHrLZGRuIsOdTtI6tx4Aak0QyiCSlFpoE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Sr/HKeXxICARumR9MJeBd8kXcXqe1+kN1thUC5m4BaxGMm0Xj5iyCC4DNA7xwy45M
	 v5MxgZSorel1UCzAu/bJ65nDOKsIhuX7sDDG6ijaAb+ra3bEJjdYJEbFREMs5mV0w9
	 lpaoV69K4KTSznNMl/cuvDkYwCueV3W0yp1nH8vZ4fgAizfJ/ay790XBLc9L4lJCpK
	 qAxd7J6W36bEqJGB5Dw0C+t6yxAof98d5RVrpqlWo6cGKjo5LaF+1iaqlOS1C5kxmi
	 v7YhnropXNOmISXkSlDcwsSeZVOl+BJj6FRTAkUFHsSl9siCaB0ztlkwRFtaQm0+F6
	 AyOV93HWEryIg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 467C64799A;
	Sat,  7 Nov 2026 00:36:55 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:08 -0800
Subject: [PATCH RFC v3 34/88] KVM: guest_memfd: Support converting to
 shared in PFN mode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-34-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=5043;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Iv1zxYO7fP3JXSyVWe6MUD/FvJRtFUd+FcQgJ86kKzs=;
 b=t9r2seWbuOAXmUmfzxNh546Jm5ih8d+H+/MViGmGMCCMkk14rA7b1r8r4bFuLkICvw9lrZNT9
 aVvzkME4C1NDEPrlUHY28C3SvXO2C/Assv0iGM+b0fiXHh5FEAyWZKf
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: syy3cmmurjyzs8orgsxoiiqo4nwxdtn1
X-Rspamd-Queue-Id: 3337320003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011827-776494
X-HE-Meta: U2FsdGVkX18nDV+BVuImP0erMlyvwSrU0fce9pj29NaDo3AUvvSnzykN00a0/FL+cIwtHfzDioULbI+IVccIj/gKgdRnd8XPJoyJlsdei6p57Go1XgS0NzjBeo+ryfQG1egR/Mlo/fAocjWzN5HrZp8bw8COZp9QDCaKJgmUH5SDeRguAkYFNPiElZwhDqH/vcMA1abVG3F015NoWc+g+wBIwb3OConrts5bh0K8R6dBaSoL8DR1psxM327512M64nnIlIcAk9NRlnbQjHylDjIP+djfxurq8jsurBDgOzgLbonaDo8aZyuRRjZI9kMmO3rKnijuF/hgP6jet8GpX53YSbI6D/2yC8bk2T+sF7hnUgGecbp3EbYnMsBi/llaVK7w0SP5n7ScyaSWWGMzoGSPnEXqxEx7NqVhzgA6n/CbrDQ+g1K2ns56KE9Ng0PePbRsUs2laetT0aB3SOQAcsR9SUyJDawcTFvcwnwIhSbnnJn2iV7MlZBUq57bvK36OJngBwIBCOapt7IM1Ke8qsEJSVkaC3EyM3i0ESRa1wGNLnWzbBXXMnjB6znJ0BuqnixMqha8fQf6PXREwP5U59QLTvQJ0xMTMuFK2dNNXgQ/z7Bki+7cXjqdfAobCf0to4pATFHeLlEw0k7MvzxGnc0U1K5Tq2sVaMsK7B+dLiAxZ0zJa6HqZavk+qV/kAoW4uv/dQ+wO45OCb/ToCyBlLjD7sHJcAg4/fDR7vIfZ13rd53KEBZ/MqeaKr3CJmXaYTyDRFp6LmKASt4kZ/hcOCslZoUjpomN5SNyyfTYsCF91uTeiEOqdyX62PEnsMoLbnNgk6TjmV5mPP809xp5pZF1/esH6ad/FQnSEI6CzU04EIez9KJkoyeaCcEnwV22iApMztXKv0c3EJQ9mrTXIrKTKNsovAxG7asX1F84vFbVIIY8iVErnUEh4vBsdQS1yoGpEnO/UpNyEsFiZYj
 CxrekRaV
 f8IvUCL1IZtov+hm+Zqu3SoAqt9by0sV1zWOBQCZMNK/v4nrScW1e0uER4p8Wc+p2WVY/RiC4G+25GsWEctE3WhuxcQ9J5mLgHeTjvvG2KBSw/hJ/+GO25DtkJI9WoPsaegAz48RlN35Q/Dm3ZmFHbtI9aBu3FVmQkHt9kL/8nlYf+s4wTJI9XrrYIZzfVMQROVEhgu/OMP6kKqzqQNGZ//x6wxsVgUU7BzgH0z9RMCj1q/h+civSprutlTrphhSIs0Zkj4V8UYIre+PUYopOUgwmHn4/R4/iD6Jv2DIUbpyH3OPOF8ME66ok8JEzBn9n/BZN1wtd83+9r7olBJV5JiUMXdrjq+QQpmfBPmqIE//8kAbhSvr9/j+AJgcgwDIAHrTkOvhqNhzK5yoSZ8E8ejPU3qAUdhv2znvyXi/jhOtUwm9pHu3S3u7el/fwGxs0yyQMq/wg7dpBLoeZOvQnwCiyeENr5CAmSqhOGnWF3tP0CXqN39ov/xmoAkMIdphrATu8tmMP3nuRsFJNr09xF+P/YDQubpc7c5cAmzItXh69X4HFiCdFEdks921iDvkAGibPuymKghJE08MfM4WhV11hijkDIg3lMUmqSU9mJCPWkEU=
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
 include/linux/guest_memfd.h | 19 +++++++++++++++++-
 virt/kvm/guest_memfd.c      | 47 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 9fdc0bd1a7190..e965aeca061a6 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -28,7 +28,22 @@ struct mempolicy;
  *           @pfn with uniform @pfn_attrs in @max_order. Once @get_pfn succeeds,
  *           the provider must keep the @index-to-@pfn mapping and @pfn_attrs
  *           constant, and the memory accessible, until guest_memfd stops using
- *           this page. Returns a negative error code on failure.
+ *           this page. Returns a negative error code on failure. The provider
+ *           must define @lookup_pfn_range when @get_pfn is defined.
+ * @lookup_pfn_range: Look up the PFN for a given index. This only checks for
+ *                    the existence of backing pages and should not allocate
+ *                    memory. Returns 0 on success with the physical frame
+ *                    number in @pfn and the number of physically contiguous
+ *                    pages in @nr_pages (@nr_pages need not be reduced for
+ *                    pages with different PFN attributes). Once
+ *                    @lookup_pfn_range succeeds, the provider must keep the
+ *                    existence of the pages and the @index-to-@pfn mapping
+ *                    constant until guest_memfd stops using the range. If
+ *                    backing memory is not available at @index, return -ENOENT
+ *                    with @nr_pages set to the number of consecutive indices
+ *                    starting from @index that have no entry. Return a negative
+ *                    error code on other failure. The provider must define
+ *                    @get_pfn when @lookup_pfn_range is defined.
  *
  * Used by filesystems and device drivers that provide memory for guest_memfd.
  */
@@ -40,6 +55,8 @@ struct guest_memfd_provider_operations {
 	void (*invalidate_folio)(void *provider, struct folio *folio);
 	int (*get_pfn)(void *provider, pgoff_t index, unsigned long *pfn,
 		       int *max_order, u64 *pfn_attrs);
+	int (*lookup_pfn_range)(void *provider, pgoff_t index,
+				unsigned long *pfn, size_t *nr_pages);
 };
 
 #endif /* _LINUX_GUEST_MEMFD_H */
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index ceef61cb63a0d..0e392b8735259 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -149,6 +149,27 @@ static int gmem_provider_get_pfn(struct gmem_inode *gi, pgoff_t index,
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
+	if (!r || r == -ENOENT) {
+		if (WARN_ON_ONCE(!*nr_pages))
+			return -EINVAL;
+	}
+	if (r)
+		return r;
+
+	*pfn = raw_pfn;
+	return 0;
+}
+#endif
+
 static void gmem_provider_invalidate_folio(struct gmem_inode *gi,
 					   struct folio *folio)
 {
@@ -830,10 +851,36 @@ static bool kvm_gmem_has_outstanding_references(struct inode *inode,
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
+			int r;
+
+			r = gmem_provider_lookup_pfn_range(gi, index, &pfn, &nr_pages);
+			if (!r || r == -ENOENT) {
+				step = min_t(size_t, nr_pages, end - index);
+				if (!r)
+					kvm_arch_gmem_make_shared(pfn, step);
+			} else {
+				WARN_ONCE(1, "unexpected lookup_pfn_range error %d at index 0x%lx\n",
+					  r, index);
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
2.56.0.455.g6c5a503b38-goog



