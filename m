Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93E98CD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:32:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C23A96B00AC; Thu, 18 Jun 2026 20:31:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF9CE6B00AD; Thu, 18 Jun 2026 20:31:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FF0D6B00AE; Thu, 18 Jun 2026 20:31:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 540436B00AA
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 88D9A1402D8
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:56 +0000 (UTC)
X-FDA: 84894784632.12.4492E8B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 88409140004
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qowp0iEB;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829114;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OTVd91ecZWWtA/RNipIiayKK1fsaOIlyDJx7z/F0j5A=;
	b=J7j8y9WpzQGIv1TEcOTHA28gPm2Cz/kdkDG5Ncl4yhVcV06TuvtBOwnkSQXzE/RDL5WvMw
	qp09RLaicFlHsQ2FLQleYRX0OQ5+VVFRKdSo++I0lGasuAA3/Hoi0d7ywMEP1wPDcsZ87c
	drMAb0vjyseQ5A/C/2s1y/BbxeSrG/s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829114;
	b=gjEHtvJC17Npf1+k4KjNNbXANRYoI+dB5yYtFaAkiEzwSeraubzgkuQdnQ03WD+x3m3bAZ
	ZPIrvJ1HxAulvkbU+JM0Vqav498pCgj78/XA7Lz1GUumHcmdNc68rZSPzXG4V2YWTW1knY
	rMaDQGFueAil0p/1s33lBAqRZSETg6M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qowp0iEB;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 73B8F4468A;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23E70C2BCFB;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829108;
	bh=EoGYSuCoSjGpdWmEhpLLk1Atpm/fDiS350q2C1aR+IY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Qowp0iEBsQtvtPoIV/xqmwGnms1M0zWgjxe7RH4s0pTlzwKkCqEHyLqWyS3eRQ7JD
	 m+Av7ydkK7BGXnjCxzPZNtlpy8RG0zddCXbmZJDslDPDFumyfVU0SPDYK3VEudL3nI
	 6bKrJnFAzCZWMyIAyCZSlqd5swg4iAg7D9onJXldl9LWZga4KATsOCtU1FsU3WiAhv
	 TgEMSjgr5M/5pMBJvWD/mIkQQn8g4/H3R3lGPaDnkQI6/hP+EBi3+FKr+x/v3UNWSu
	 V5az3SM7OjJDyyl9WjsXGD3espHBPSYcrvHB4I5l7zCO2Lp9QEwouwicSGhmerhd8R
	 X5ArvEkpIJ6Gw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1911BCDB461;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:31:52 -0700
Subject: [PATCH v8 15/46] KVM: guest_memfd: Call arch invalidate hooks on
 conversion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-15-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=2768;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=E0npEy6B1rbQQ4tFaJTBsuBD+qzlEIeINKdXRgy0S54=;
 b=8FxZDoe7Vx/8EB7MoL7nMRqVXQZWT4PVJS7nEbmyHF20sL4YMgZoBkDxeN/BlJRpM2huh9oKR
 50v8fs38ztoAcPA7hx9HxbXWF/KgYJi6oT2NZf30ZeCl1HNXByz/yA4
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 88409140004
X-Stat-Signature: 9xjs6fmm1db5yqjpp57cxpcrt5dt747b
X-HE-Tag: 1781829114-298996
X-HE-Meta: U2FsdGVkX1+4Bo93qczSYbVx5jGw3PpXyj0iozYy14r6foyR3wLdlPfB+E+wqjwRfRrg2dFh0uQJq7EMvsgiIYb/MYtVbgS0G2JnnIdAzx+CtQyXUNBN0VfG0zk8QzG9lqHx/HU9Rnc9eRpv3OVOmgmtG2fjpgn3EGNQN9zSisq1PMPOWKCllJ7Vk8z2g5FD7YyTHn4C1IbSagX2ExwV1PU5I0U71u2T2Volq7Oi8F44ANjdG0EVSZo4BKZp4z11Vek9z1R7m2xaG8AorwhNjjTretlf28OWNq5Ck6juqWXJcz5b9skDKG8dEn6feXHBo53FwzEipNSUu+hZEnd29fyTLTeLrVVsxotFDNvVTueuiL81Cr/cZD4vVcnkml3cQucIElCehMAJWE9c+ROMXs9WQ2VElz7DwTYjdwGqFNhLvVkqamRQjrC8OSn9uCl+ijFXiCBbEN5lAneMaqwn6RSAt8k/OgUKoSus2hUjXrSTVrlIdMKrwGuhk3hkDTPvZ5DbAMKUqdyRnzgLDkpIsJkvEF4cUG5InCAdb0On2b82RYUpjkeEi361SUD+/Vy+E11NdFcShfa4hC9z0lD14cdCyZIL+8zDzHxKWmVKurHcF8rW9z+1l2AWeUvahY/Ywm42QGwq+OEZLviFijST/68Q+rxsvR/4yxfsIOkHHu/JF7E4puywrlxSXMXmCkGD75JS8+EeU/61b3tifom2WJBjMmsI9/rsp1EWP9zVerJvlqQMZBwcWmsywfPD8PufAzgZRhZA15mMol80q+SqZuY8udZF8KF/hbOIyy0QJ+AzevuhdMvPi04vHmuHdxFvdgtl7wwalPzdJ3iaBD/FHCHXGpFfUfJXSJm22AzAZPJAGtkB9rdOmVstOgiJnPD75JPkSOppCHKx7VfkU828YKZP6OWy+ifCXy/rqECjyD/PHlRS0OhhpYKEW5wpUyw2OT/cyU0u8lRU3dkW1zC
 7gwPq6tt
 4iinIa0aPCzGs9WzDFB+/iRswM5ZFFY2jg5K+PS3Rg6o5ODNg1+ns58iwIEmMvE07meL82L038s/bXSauGdmM97Y7p0j5GWtc+35DrDpU/UoOnyIP7afmugLhLvW0ThBdxaKOHsIp3U/oRz3H7VYF35GtjIfzy5uM1SXipnbAS9zCAgV0X9cOUlJwXm+MaeeDBPiZ2mkAB2tckfduS1VJvVFHoUG/nXvUVDbvnPFM3Fv3n74eHUJoLoIGYOdB1QhjEeZIDO+xZXbvCf2+eM7q8vd8Xogb6rSFkCyW2qC67xHvM+6Sv8qvLklJ1il4yZKdQXFgJx+ff/doCM/Yhm9hCvJQU5yDPNy/lp1p+EC1RBoUHM4qjaIApglHvSVq9KBQf3Q6tcoy4VIUpWsPt25le29jgRD4Mp/u/h7i10ej9De9iYBzwW/CVnSwyneuQyL4IY/e+UST5r9JPkqiFaG3T5B9lQrVXR9ZsdHENcsdfyfjSuNyfKJCdoT7pwt0/qF6eRN+edDHdC5zDkya34BLYtcqlgDNy0Nthbe9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When memory in guest_memfd is converted from private to shared, the
platform-specific state associated with the guest-private pages must be
invalidated or cleaned up.

Iterate over the folios in the affected range and call the
kvm_arch_gmem_invalidate() hook for each PFN range. This allows
architectures to perform necessary teardown, such as updating hardware
metadata or encryption states, before the pages are transitioned to the
shared state.

Invoke this helper after indicating to KVM's mmu code that an invalidation
is in progress to stop in-flight page faults from succeeding.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 433f79047b9d1..3c94442bc8131 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -607,6 +607,42 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
 	return safe;
 }
 
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
+static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
+{
+	struct folio_batch fbatch;
+	pgoff_t next = start;
+	int i;
+
+	folio_batch_init(&fbatch);
+	while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
+		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
+			struct folio *folio = fbatch.folios[i];
+			pgoff_t start_index, end_index;
+			kvm_pfn_t start_pfn, end_pfn;
+
+			start_index = max(start, folio->index);
+			end_index = min(end, folio_next_index(folio));
+			/*
+			 * end_index is either in folio or points to
+			 * the first page of the next folio. Hence,
+			 * all pages in range [start_index, end_index)
+			 * are contiguous.
+			 */
+			start_pfn = folio_file_pfn(folio, start_index);
+			end_pfn = start_pfn + end_index - start_index;
+
+			kvm_arch_gmem_invalidate(start_pfn, end_pfn);
+		}
+
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+}
+#else
+static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end) {}
+#endif
+
 static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 				     size_t nr_pages, uint64_t attrs,
 				     pgoff_t *err_index)
@@ -647,7 +683,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	 */
 
 	kvm_gmem_invalidate_start(inode, start, end);
+
+	if (!to_private)
+		kvm_gmem_invalidate(inode, start, end);
+
 	mas_store_prealloc(&mas, xa_mk_value(attrs));
+
 	kvm_gmem_invalidate_end(inode, start, end);
 out:
 	filemap_invalidate_unlock(mapping);

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog



