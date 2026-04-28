Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B2F5FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3FFA6B00BC; Tue, 28 Apr 2026 19:29:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E18186B00DB; Tue, 28 Apr 2026 19:29:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D061B6B00DD; Tue, 28 Apr 2026 19:29:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BEA1A6B00BC
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:29:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6853B120B56
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:30 +0000 (UTC)
X-FDA: 84709548420.10.1ACFFF2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3D91C20011
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YXmpiXZL;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418728;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWJyTuMRVnulfLTRNylKoR3xD9GL/Ka8HKFVPDGP8JM=;
	b=gKh1esiC2s8Qy8uYs0KeBjY7YTsZCrMP+v/eEHZgqEZBpEbYzSyryLqftsRkT5NGln/Xf0
	SZRy+iMlxf7jMM8xBSGDrlxDRnKo96cvX2oe+bqXwH0u6rVG4Cbhdh4r2ssW8grVaaY7Vs
	BW3UymTxKVRzPoumcGeEsRH4AyVSJ3Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YXmpiXZL;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418728; a=rsa-sha256;
	cv=none;
	b=pK+cHb4u1Z1lueSUtF7Nbn6UUKb8RLJgpVC3Z7An2a+JWHm/ckkA1Ne54HURzk1Wf3VYt7
	VPcQmvVmw5deIdsaxMEuhvnGKtgR/KA6TGPpHh84inqRoS8uXCc0Aadb9zN3xzhLYbzzeX
	nzm802WJ3V3gRVrt7FNVOutX+sXVEiU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1470F44A0D;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF52DC2BCB7;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418719;
	bh=McDOUCm+isas7jiICyN0E5ubUDEjWu5iEe+R8RHc0CE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=YXmpiXZLWXXFdTN57fmIKCnVspLN0ZD8E1nxFJf7RMGgP8ejDB6T9YzrWSPvUl+La
	 niZ5r28LHje+vjo+sbC5WxKMmYzGgy6wlJnrEOeQ2X/9+9CO9ovDxp+hzWlm3ww5qh
	 jkDAOiuSY7mNcMh+XE02D5bdR3yAtsmL7/KUA+QkWEXFhZjBzdb3mLqs6J+d0Xvzwc
	 gwCgagS+aBw4NQ96FNEa83BPcBtGHUpkeiY13dvaAgypBi9aBRQv2zZhyXBlRXWrM3
	 ULkXOhe6Rk/u26192tjuIposMG467TQ4XS0r9GtXv/ameZszFygIhPqVFZrYM98EB1
	 xppN74Be0NkvA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E1BFF887E;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:16 -0700
Subject: [PATCH RFC v5 21/53] KVM: guest_memfd: Introduce default handlers
 for content modes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-21-d8608ccfca22@google.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=3682;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=bExntzDH4eJvOXiKEEI4Mzgx/0x0zxgpmzImhSYoC1o=;
 b=PNbqwo9hcIQwsAQRGjQHX21H24S4wh3bsXFlO6MkquX+OHrZREiPkkpErhDiU7/NBi84pETDV
 vHMROayf7h/AC/UbqBdSyOejE+v/B0mVu0oQwwqp5Kacfunrp/JDX78
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D91C20011
X-Rspamd-Server: rspam06
X-Stat-Signature: ka8zre98hrgufprmxufhf93cmi7w55hf
X-HE-Tag: 1777418728-814371
X-HE-Meta: U2FsdGVkX18i9dr62Duhl6Km1g328X7BfY6vruLCpeXu/SdQg8pa+LrI9UpHRjFlipqyCzW+NpOd4syzmdrVXjt1vCrp9m28k9CKHD3u42q81KcoJsg9GzNxH/4wT+ZclKrLmqX3EpIH6o5lMpmkOpVX73ehWWnDMHIJjOEiZzwDsK24SDPI9AkA5eARFaVfCbnHxgwOI22X7ppSbwSbSRN9E96Ip2D960iW0Is1WufxzEwzdfFCNMrshcaChgD6eTn+yn4F76gd8E6KdB21l18ZhtxQJy3Fod+GDHvNCjNTmPY/kNlDNALGxvDqjXGNnx5Cg4y0SNkgy/orvFIS0YI9+HVhKAYQjP2fOEa2qfVgA+fqGnr210gPiJ2h6XpNyIy5RlpCInsQt2ce+r933KciudrjpsLx/VfFVFIX+Lt+NFlzfxn68podSoFgqF8cue98VZ4YSEoeGfDliiWlUAi+DQ2lTwLvOAgVLjTOvFBzaxe2hMpjpTLjr6YjARi7H2tDcinMRX8p0GmlikzGxYRORvn8iWvdFFoKZ7IPBretitMlf5wpQJJghAk0PNir6mj/5nkaDk9W/IZ6GdsBRA0mSJh1uEjgWu9AD+aXOMGNrWVv0eIG489c2A2wovMIimXnFZsvcNuoTT5jjYuWPGr4dSnU2/hvCmzGvoYFbCKJYArXOuY9ub4OE8U7XXBtkeYQ6YbnVPvvpzQ2rL+ollg2YKFb3IFDryIZT6Ozy7qM90GJRh+T9r/zsunrafaVhP4WVQHUkSgOz2Hf8a2Qc5JFKX8KassiBzgS0YjaMDuomi6hfbVIlJM8tNjtZ0qoK4Iq8IwAqmBFdao97bv/Nnu7wO9yZPyIt0n8/P5wslUAX22C4Z4PjfpWZnEAp2agghOkC/R3uIxhRcLJCnd3ikhgFUIFgn7J+8LJbvcx1Mh/h08sGWZzqry2klHDUt3RlCAMP3OVVew8EP4vnIh
 R1JtBEOA
 ZFMDK7waH2CUOlum8MUsEsEABb9qdZdfaAFcH3nFbsvKpavWYiMJgDMvn3sOiDOJm8h6+6q/qSYzcRZd7xKhWE0WVEBk7WguUKKvPy2UwshWc5Z+Iu1EtGl9O05TVMyHDCiVWFc3xrZyiO+RAYM9dPdTSy2f+cS6c1D5KXoFB2nszEivCT4x/ABDW/iGV1sjhtO/ICoBdZ8ny+a4sdhHQdeQ3DN9/1yrbeJntzyAvSchnH+B6QMA8qea5VhJl76zZcRdztvaNJmSEMEKI5DZteAPAV77BxtZxsxF619C2wmxxt47uZoKOoU++MODmPH7sCjzycDQZjjMnG7tv82SIFlT05jBeHnEOyAJ5lKGdyPeO86p4TVuEQZS2bCaUjFALvqLx17XPVJhkGqFmn4saz0QO9ZMZM/a3P8Wtdd+V2OiL+iarWuKAbOgIrKrcu8tOgmXUGCiJDRGlv59VZXGXesAAWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Currently, when setting memory attributes, KVM provides no guarantees about
the memory contents.

Introduce default handlers for applying memory content modes, which
different architectures should override.

These handlers will be used later to apply memory content modes during set
memory attributes requests.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h | 12 +++++++++
 virt/kvm/guest_memfd.c   | 66 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f9ea95e33d050..458bad0083c37 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -741,6 +741,18 @@ static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
 
 	return flags;
 }
+
+u64 kvm_arch_gmem_supported_content_modes(struct kvm *kvm, bool to_private);
+int kvm_gmem_apply_content_mode_zero(struct inode *inode, pgoff_t start,
+				     pgoff_t end);
+int kvm_arch_gmem_apply_content_mode_zero(struct kvm *kvm, struct inode *inode,
+					  pgoff_t start, pgoff_t end);
+int kvm_arch_gmem_apply_content_mode_preserve(struct kvm *kvm,
+					      struct inode *inode,
+					      pgoff_t start, pgoff_t end);
+int kvm_arch_gmem_apply_content_mode_unspecified(struct kvm *kvm,
+						 struct inode *inode,
+						 pgoff_t start, pgoff_t end);
 #endif
 
 #ifndef kvm_arch_has_readonly_mem
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 85e8b3a981307..b0e4bb554cdf3 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -693,6 +693,72 @@ static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
 static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end) {}
 #endif
 
+u64 __weak kvm_arch_gmem_supported_content_modes(struct kvm *kvm, bool to_private)
+{
+	/* Architectures must override with supported modes. */
+	return 0;
+}
+
+int kvm_gmem_apply_content_mode_zero(struct inode *inode, pgoff_t start,
+				     pgoff_t end)
+{
+	struct address_space *mapping = inode->i_mapping;
+	struct folio_batch fbatch;
+	int ret = 0;
+	int i;
+
+	folio_batch_init(&fbatch);
+	while (!ret && filemap_get_folios(mapping, &start, end - 1, &fbatch)) {
+		for (i = 0; !ret && i < folio_batch_count(&fbatch); ++i) {
+			struct folio *folio = fbatch.folios[i];
+
+			folio_lock(folio);
+
+			if (folio_test_hwpoison(folio)) {
+				ret = -EHWPOISON;
+			} else {
+				/*
+				 * Hard-coding zeroed range since
+				 * guest_memfd only supports PAGE_SIZE
+				 * folios and start and end have been
+				 * checked to be PAGE_SIZE aligned.
+				 */
+				WARN_ON_ONCE(folio_test_large(folio));
+				folio_zero_segment(folio, 0, PAGE_SIZE);
+			}
+
+			folio_unlock(folio);
+		}
+
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+
+	return ret;
+}
+
+int __weak kvm_arch_gmem_apply_content_mode_unspecified(struct kvm *kvm,
+							struct inode *inode,
+							pgoff_t start,
+							pgoff_t end)
+{
+	return 0;
+}
+
+int __weak kvm_arch_gmem_apply_content_mode_zero(struct kvm *kvm,
+						 struct inode *inode,
+						 pgoff_t start, pgoff_t end)
+{
+	return kvm_gmem_apply_content_mode_zero(inode, start, end);
+}
+
+int __weak kvm_arch_gmem_apply_content_mode_preserve(struct kvm *kvm,
+						     struct inode *inode,
+						     pgoff_t start, pgoff_t end)
+{
+	return -EOPNOTSUPP;
+}
+
 static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 				     size_t nr_pages, uint64_t attrs,
 				     pgoff_t *err_index)

-- 
2.54.0.545.g6539524ca2-goog



