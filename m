Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEE06606BFC8
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PcdzordF
Received: by kanga.kvack.org (Postfix)
	id 9AA7B6B05DB; Fri,  6 Nov 2026 19:37:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95AA86B05D4; Fri,  6 Nov 2026 19:37:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70F346B05DB; Fri,  6 Nov 2026 19:37:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4663E6B05D4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:13 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E20A7A7BC8
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:12 +0000 (UTC)
X-FDA: 85406458704.02.C29E47B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id BF05020003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PcdzordF;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011830;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XnHUrxh1SR1r8PJyXaJlDOb3GL3FiynLANr7SpLGnpw=;
	b=gzWIME9O983XKGKF1bgm958Za/uDCTF3mso2SWLg/GhZk/Okbcq/TrnaMgfTtCYYKNv5iT
	K0gIdB5cYHMh/I5PIATOSbgrUKkG0a9ziFuCaXmEm9o/atqIIgze0zAjTLHOqSg2qBZHqB
	gyB2B0pYkn1/P5Fm43vS6E1jfq8Jnvw=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PcdzordF;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011831;
	b=T8Bra14426iOqlx4nXS2I5SLisAMECRsxw4dS0/u+iVa0LSBKK+7pQjMUCAaQaY5Pki6EP
	hOrHdt5rA/dorQENeIFKSzyHeCgyc4tS1memAC6JcIt3AUYXdNO8rs5xBD+sa7QItKR6YF
	nU7KmJNE3gisjnCI/41pBDzaB1eOx9w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 89EF741A41;
	Sat,  7 Nov 2026 00:37:10 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011830;
	b=RQlRhEi2ur5W94Dy/+OM0XOA8ujFcnIKwAEeQp5ksQJTjumBxAg1INIQdwyjX2XC2S/6
	 F84GxY/2rTeP3OSRJOFY8vARcOOe9u8BQ972DIOMj8myn9LCdCA+Yw//2FscphGkMryXX
	 JHR4KNp+qsSMwQwr1fsTO7iBmVaMIEL4a9MdnPYpnEyJTdz7PyttyujjwHKMnyhDKcXjA
	 7cRvFj2Z+UMV5JZ7UcOAt6vGRZbo5LScJqhJJ4bnqBDpeslXlpl26hMpdWtCETqWYekSA
	 IsDcPkwusxIad1wjh2TWZ+Utidae4kDnd4E1BEXC/tY1FtlvuoblYKoEK2JVZUmpcoQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011830;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=XnHUrxh1SR1r8PJyXaJlDOb3GL3FiynLANr7SpLGnpw=;
	b=aREpAKWjquP7TlxYZ5zV9JZhtXvPXJKrlbzRG7hQ77JuWL6LXU6n9YhDXdzSRkowrtkV
	 udhfgsHkmY8JlLnpdFK13IB4PXlNH5cx/d8NBsf8mVbMzZXSkyCzqStf7ffaej6GzI/J8
	 kmYrg0UCYOakx4sRQiNKmAK4UimXctPpo8RwlFtVpnfJ8oRA6LOgSLQ6LkSBPnQT4nec5
	 06eK02XlX4SurbTvcmnV3Y8wBYjPXkVKEpeun+1ElVuiVRzdYjR/bpfJDN1KiV2nuTwf7
	 L93uI74kfUyE5HwbN6Syb95VAIIIc1cz2nGu045EISMM1nn46ES0rH+87/ECyXe4pBQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 0FFCD1F00A0E;
	Sat,  7 Nov 2026 00:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011830;
	bh=XnHUrxh1SR1r8PJyXaJlDOb3GL3FiynLANr7SpLGnpw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=PcdzordFOmF6/ZXlfFJZVEzZZCZWKG5+Gr4hxUcbtY53hfK2dWNlKLNlAH7KxYI8l
	 F9muZfoMitC9c/4EUz9EpJQRTkVIq9qigpugZrjIfAQSSwEzawkub5jBmqqKRtkgVE
	 Dyi+tdvbQ7CNxsRTR/LzWPhxLx+iT2ncph8/RO3EmpGc/q9RBlDrLLAfXJiNwsyoTK
	 7oNpsGmYNM+x8hlZLEzMSyT7Bjgjxd17LdD6l4NhMCZ5hOkb/T0hPRg2Fxa2yZY4jm
	 c+76tDuOrerhsaJ1aQvXqWvxi4lFKK4RQSj6ulzOEWNjdW6sOyh3jrac7/+6CmAz7h
	 wdas3pb0lyjDQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id CB360479B8;
	Sat,  7 Nov 2026 00:36:55 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:16 -0800
Subject: [PATCH RFC v3 42/88] KVM: guest_memfd: Export kvm_gmem_revoke for
 provider-driven revocation
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-42-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=9183;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=KGi0b4edDBIuTocBQekssX77k5i2otDcPksXtOPmhvI=;
 b=Te9++pLFJFnW4N3FxCx+9OU7l2p3qOhL8KAm2XxPNG+NWA488ixSARUq8p61w3XvYZUqQL9Hq
 +22sSMjPqkqCYF7whbd+ceNyTK0LG1TKeJMLvwoXrP5278iHSI2dzwu
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bw45rrbe6jcybfgyyjabzej756j6kc3d
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: BF05020003
X-HE-Tag: 1794011830-578422
X-HE-Meta: U2FsdGVkX19v5P72Hmq+TAaqueX3GU3aQg94YI+lSYBXO8XLPmh5uFpw1sIhD0L5oqgsFEaVtdHKcRShB9eCP0BX7ag7yRnUoZOQXjNp6M3RHZEu/dSiLaFnwfimpMalho6bCD/daOYem4rjMv1nsKIjOZ51GOWsbZSrHW8ksv4x0g+nNWhISeb1tAABAOBJufmUPF/NMUgLQyx5Hudias6V1nnz3k1g40C68Qt2vpO5gSCqONPiSe7pZK4VYNoQdnzlyierlYIByVkquAOl63Gyj0youQr4ufCYFfom+964uKcgy7iznroLVZe5NEd07FhXHDvK/bbOcOStDAiFR5Q3hFirZ/mMArRrUMMvDAUpyGPmhc86bLDEyXczZxNSt4JOKLXbfybSyJMd12frTRdAoUn64u2EVHdB8ybelBTuu63v0WWPdNhmokpA+GVRAIPpkW/w7X1T4DdGPpDXqIoY+MQbCaOwFOkxlc1R/v8WVKXRmJaZriwSE9EyIbrc/Ebd1coX6TNnQ1ckgNjHQQKw/bubSYDSez8zRxOwgSxhFPjf0oDYxXNNx2vkWNhgnzZfPsKeFQ0J8xs+28rGIZwQsfHSiAHfq4sQq1Zl96fZcqJ/1YwVUwQT6C1jCD9WRANmXUgQM1pL3Jvk9oa9Y4o06l4yKQT4TKChbmoroICJDK4mMCiCfxY1aRq2DP9S4nTUQrvsGwDpKp+3I9n8s/qgW8s9HtbH4bcxHDHDVpYFk3Dxqw0kXThkaDUivIdUy2wvx0uPcT+uZMCMmmpOEeGbYizQsLlqoOu9KtM3ACwsTIjMCChWji9U34DaVKN1XQw5bXi9qJN7KON+bRUnsqLizdc9lprHo6Bkxnnp9vXz+Vr4lvJFDGtRejd0UqPr0l2OV5nUDyHGmJI3CvaAo0s2AHGKBT9Rn3OzxN52UCgeX2PUkxlDfYreEoliPqooakq/qkXBQGxkQAoCw4i
 4hC5wXhj
 feSbBYtRhK7OCB3WzpvMHMceG3doMxoRufuF30m57zM7xCQrJZhF34SzIrwM3Txt060x3+SV2UD2C5W5qakj7MX85qpomEkpWnEV/vAQyejWJsankevJMrXnYQBnQOLbqSkfFAXZDVTXv8p10OD/k3C7LD9cS+tTpcCVirU08HDRPjHnDGXxv77jp4501CtuqJ33MCDZG7lJt4LNsalpO4pJy4x6hYoDIbSheDd774hh36ogQlBSOmCYyN836WhY2jWRCTz/VlyDIir3RbNDTrs2AlMw4Hr95rNsgu/ayraB4QvINb/sz721/hrnljcVSNoqw9Hb5T84hkJjnRsm/a1heyqX08zu3YH+t8qlAtEwRSl2uYXrME1AyemkJ4mVxpY8OtQ3yYHuAMCpaiwqNNR4DJ6PgdEXSX3zxOzbEjuM+j8kzOkB3Bb3BAdcek7aGbFDk+oYDfoVnc1Kjp9qCvWeAZC6MTAakRG0I/rT46H03AodWU67I+qEZ/mr1dm/1+HzVn/gzymc3YHRDPNmHoHElUJ1Mg2j0s5izfGJ3vB5EKX0hTDvXd8iUDI8hDpmpiNlqbxoNYc7P1KmZ9W6tlxQ3kgjn6yVUnqPX6JtvjHEJ7/A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Providers may dynamically revoke physical memory ranges (e.g., dynamic
page removal or device teardown) and need a mechanism to sever guest and
host mappings and reclaim confidential architecture state.

Introduce __kvm_gmem_revoke() to share the core invalidation and
reclamation path between kvm_gmem_punch_hole() and kvm_gmem_revoke().

Introduce boolean to control whether to call .put_pfn_range().
.put_pfn_range() must not be called when revoke is used by a provider,
because the provider already initiated the revocation and calling back into
the provider could lead to self-deadlock or re-entrancy on provider locks.

Export kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_pages,
const unsigned long *pfn) via EXPORT_SYMBOL_GPL. Providers must pass
both start and pfn.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/Makefile       |  3 +-
 include/linux/guest_memfd.h | 31 ++++++++++++++++----
 virt/kvm/guest_memfd.c      | 70 +++++++++++++++++++++++++++++++++++++++------
 3 files changed, 88 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index c6bf463f50327..5fd01bd19d1c4 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -61,7 +61,8 @@ exports_grep_trailer := --include='*.[ch]' -nrw $(srctree)/virt/kvm $(srctree)/a
 				-e kvm_page_track_unregister_notifier \
 				-e kvm_write_track_add_gfn \
 				-e kvm_write_track_remove_gfn \
-				-e kvm_file_to_kvm_fn
+				-e kvm_file_to_kvm_fn \
+				-e kvm_gmem_revoke
 
 # Force grep to emit a goofy group separator that can in turn be replaced with
 # the above newline macro (newlines in Make are a nightmare).  Note, grep only
diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 697f8f8c9b0ae..fb2279a001ebf 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -28,8 +28,13 @@ struct mempolicy;
  *           @pfn with uniform @pfn_attrs in @max_order. Once @get_pfn succeeds,
  *           the provider must keep the @index-to-@pfn mapping and @pfn_attrs
  *           constant, and the memory accessible, until guest_memfd stops using
- *           this page. Returns a negative error code on failure. The provider
- *           must define @lookup_pfn_range when @get_pfn is defined.
+ *           this page. Do not take locks held across kvm_gmem_revoke().
+ *           Returns a negative error code on failure. The provider must define
+ *           @lookup_pfn_range when @get_pfn is defined.
+ * @mmap: Optional callback to set up user mappings. Called when userspace calls
+ *        mmap() on guest_memfd. The provider can customize VMA flags,
+ *        cacheability/protections, or reject the mapping. If not defined,
+ *        guest_memfd falls back to default mapping behavior.
  * @lookup_pfn_range: Look up the PFN for a given index. This only checks for
  *                    the existence of backing pages and should not allocate
  *                    memory. Returns 0 on success with the physical frame
@@ -41,15 +46,18 @@ struct mempolicy;
  *                    constant until guest_memfd stops using the range. If
  *                    backing memory is not available at @index, return -ENOENT
  *                    with @nr_pages set to the number of consecutive indices
- *                    starting from @index that have no entry. Return a negative
- *                    error code on other failure. The provider must define
- *                    @get_pfn when @lookup_pfn_range is defined.
+ *                    starting from @index that have no entry. Do not take locks
+ *                    held across kvm_gmem_revoke(). Return a negative error
+ *                    code on other failure. The provider must define @get_pfn
+ *                    when @lookup_pfn_range is defined.
  * @put_pfn_range: Release a range of PFNs previously obtained for a given
  *                 index. Called with the exclusive filemap invalidate lock held.
  *                 This indicates to the provider that guest_memfd is no longer
  *                 using the memory range. The provider does not need to ensure
  *                 that backing memory is present; if backing memory is not
- *                 available, the provider should skip the unbacked range.
+ *                 available, the provider should skip the unbacked range. Not
+ *                 called on kvm_gmem_revoke(). Do not take locks held across
+ *                 kvm_gmem_revoke().
  *
  * Used by filesystems and device drivers that provide memory for guest_memfd.
  */
@@ -66,4 +74,15 @@ struct guest_memfd_provider_operations {
 	void (*put_pfn_range)(void *provider, pgoff_t index, size_t nr_pages);
 };
 
+#ifdef CONFIG_KVM_GUEST_MEMFD
+int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_pages,
+		    const unsigned long *pfn);
+#else
+static inline int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_pages,
+				  const unsigned long *pfn)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 #endif /* _LINUX_GUEST_MEMFD_H */
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 1b6fc44ba00bb..023bf095340be 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -433,18 +433,25 @@ static void kvm_gmem_pfn_reclaim(struct gmem_inode *gi, pgoff_t start, pgoff_t e
 static void kvm_gmem_pfn_reclaim(struct gmem_inode *gi, pgoff_t start, pgoff_t end) {}
 #endif
 
-static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
+static int __kvm_gmem_revoke(struct inode *inode, pgoff_t start,
+			      size_t nr_pages, const unsigned long *pfn,
+			      bool put_pfn_range)
 {
 	enum kvm_gfn_range_filter filter = kvm_gmem_get_all_gfns_filter(inode);
-	loff_t size = i_size_read(inode);
-	pgoff_t start, end;
+	pgoff_t max_pages = i_size_read(inode) >> PAGE_SHIFT;
+	loff_t offset, len;
+	pgoff_t end;
 
-	if (offset >= size)
+	if (start >= max_pages)
 		return 0;
 
-	len = min(len, size - offset);
-	start = offset >> PAGE_SHIFT;
-	end = (offset + len) >> PAGE_SHIFT;
+	nr_pages = min_t(size_t, nr_pages, max_pages - start);
+	if (!nr_pages)
+		return 0;
+
+	offset = (loff_t)start << PAGE_SHIFT;
+	len = (loff_t)nr_pages << PAGE_SHIFT;
+	end = start + nr_pages;
 
 	/*
 	 * Bindings must be stable across invalidation to ensure the start+end
@@ -456,8 +463,14 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 
 	if (kvm_gmem_is_pfn_mode(GMEM_I(inode))) {
 		unmap_mapping_range(inode->i_mapping, offset, len, 0);
-		kvm_gmem_pfn_reclaim(GMEM_I(inode), start, end);
-		gmem_provider_put_pfn_range(GMEM_I(inode), start, end - start);
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
+		if (pfn)
+			kvm_arch_gmem_reclaim(*pfn, nr_pages);
+		else
+			kvm_gmem_pfn_reclaim(GMEM_I(inode), start, end);
+#endif
+		if (put_pfn_range)
+			gmem_provider_put_pfn_range(GMEM_I(inode), start, nr_pages);
 	} else {
 		truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
 	}
@@ -469,6 +482,45 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	return 0;
 }
 
+static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
+{
+	return __kvm_gmem_revoke(inode, offset >> PAGE_SHIFT, len >> PAGE_SHIFT,
+				 NULL, true);
+}
+
+/**
+ * kvm_gmem_revoke - Revoke and reclaim a range of memory in guest_memfd.
+ * @inode:    The guest_memfd inode.
+ * @start:    Starting page index within the file.
+ * @nr_pages: Number of pages to revoke.
+ * @pfn:      The physical address / frame number being revoked. Directly
+ *            reclaims this physical range without querying the provider's
+ *            .lookup_pfn_range().
+ *
+ * guest_memfd will do everything to make sure the range revoked is no longer in
+ * use across guest and host mappings, as well as reclaim any confidential
+ * architecture state.
+ *
+ * Before calling kvm_gmem_revoke(), the caller must ensure that future
+ * .get_pfn() calls for the revoked range will fail so new mappings cannot be
+ * faulted back in after kvm_gmem_revoke() releases the inode's invalidate_lock.
+ * Must be called before accessing, freeing, resetting, or powering down the
+ * backing resource, and the caller must keep the @start-to-PFN mapping valid
+ * and accessible until kvm_gmem_revoke() returns. .put_pfn_range() will not be
+ * called.
+ *
+ * Acquires @inode->i_mapping->invalidate_lock exclusively; callers must not
+ * hold any lock that is also acquired inside provider callbacks.
+ *
+ * Return: 0 on success, or a negative error code on failure.
+ */
+int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_pages,
+		    const unsigned long *pfn)
+{
+	return __kvm_gmem_revoke(inode, start, nr_pages, pfn, false);
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_revoke);
+
 static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 {
 	struct address_space *mapping = inode->i_mapping;

-- 
2.56.0.455.g6c5a503b38-goog



