Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C84D310AB82C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8471C6B0098; Thu, 26 Mar 2026 18:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D0F56B0099; Thu, 26 Mar 2026 18:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64B386B009B; Thu, 26 Mar 2026 18:24:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7686B0098
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:24:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16CCCBCDED
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:42 +0000 (UTC)
X-FDA: 84589644804.27.3435477
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 41164A0008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=I5P9ZoYL;
	spf=pass (imf25.hostedemail.com: domain of 3JrLFaQsKCPUXZhboibvqkddlldib.Zljifkru-jjhsXZh.lod@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3JrLFaQsKCPUXZhboibvqkddlldib.Zljifkru-jjhsXZh.lod@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tsJB8DUiPUozVAwHEUqka6GAzAJgxzJ+NiuNM0UTPFA=;
	b=pdNzjHqv1gzLVRZAj7WDxmBclXlxCUJzt2yqwpmTtUuodiJVrLeaOA8CU0/9x6BNFxCFHi
	MQFreJmIkbR/swbMqUOgiJXnNxC0Kpug9yP6FHWNvFV90VUSdpALJBgiUNEcu+6iWggRUP
	vSjLOdUZnz7IzYthStaVMX3w46Diqgg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=I5P9ZoYL;
	spf=pass (imf25.hostedemail.com: domain of 3JrLFaQsKCPUXZhboibvqkddlldib.Zljifkru-jjhsXZh.lod@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3JrLFaQsKCPUXZhboibvqkddlldib.Zljifkru-jjhsXZh.lod@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563880; a=rsa-sha256;
	cv=none;
	b=QdsiE8IUHt/dW1d5D15PegMCUbfk6t+cw/kePK8unUBvpRZ1JJ6Jz5hR5DgbGZzxmtrxlJ
	3U5w9UO2J4BF46hhOHvDEz66d5+cuZibdE23IerXNtNrczx3RBoqQJupPC96tcRG43kxR1
	NR3Sgq48xuER/+qIJBLUGml01Kn4uSc=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35c10c2d890so2142100a91.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563879; x=1775168679; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tsJB8DUiPUozVAwHEUqka6GAzAJgxzJ+NiuNM0UTPFA=;
        b=I5P9ZoYLg0WXKWm5tyWPYre1WZeHAqus1pjuP+Xl2JTX0xaEU7gzT9lIcmvIIyN7Kq
         XyUrzsYdNA3eEZWf6kImZ75pJp7JuL5qJeD3iI34fTyD74MESaULmKPqZHz2dAC9hiVW
         Dk21KyQ0u+GepL+EOsjAlE9MerOHLKvaz53YxvQxD0fOCEwxSChkX4U1OOw5QLCOpZjV
         7X1oBjOa/bR3G1gxWVOc3CsbUsyLfM4Psq5mZcMREHtWe8JZ4hDVlLxpSWbCzQjK7jG+
         3Seyd3kzScd/V8mTvx4LqhLj/kzeKZ9ZEV6PHRsRAo3lPSXAdhbbRZkLrJJXDb51QOhl
         QIQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563879; x=1775168679;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tsJB8DUiPUozVAwHEUqka6GAzAJgxzJ+NiuNM0UTPFA=;
        b=otMYda3ssG1kn2V+sDP2fyuGiUZXV7Q8c3vvmOC7WDQitZZxSGEGX6RdYr0yBe1KmP
         cmkmRNT2BVu+OqTXbh7srQ87MpMy5AIEYV57Vsu0OChZJvA69c6FCm2FCFIVSEus8r+p
         dDS/ggwC9ZD83QGX5HmjWZaKZGFG3NVQqVWSyQM+Vh/ffmQ9Tx2ftUfwztVDMMagwD+J
         FSV16wOBXoagfvGB73MGtbR0sXU1OSkkLGvWOtldkBYNL2quRnKhBrjauFdOzGDrF11j
         LCwvjN0TOvf3DZPt0gj4uWh4A/b583J1lt1oUk3WRd8s4mdR4yAnt/LpjI6kE6TOO+zQ
         XKOA==
X-Forwarded-Encrypted: i=1; AJvYcCUplkUABjHCGIszscJEu7//GvbxybqkaIcUD3/9Qn5OroR6p8+cOV/hoSUHptBSDxpiUFPeyptekQ==@kvack.org
X-Gm-Message-State: AOJu0YyQT5rb7e8vsDXQjzeqbAvFJsSs3fgmU9JdLnqHCUuhXsj6aaP7
	w3ij8XCsTSToqZUNSm2BLcl0QJ8wzZ1gVjAp8DXlR7c8yCOGAdK0gaQTbVYW+H4FuefGS07+qxS
	o0Wq3K6I9dDaOn3XRRI44uDmn6g==
X-Received: from pjtf15.prod.google.com ([2002:a17:90a:c28f:b0:359:8bb2:c98d])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3e81:b0:35b:a8cf:7969 with SMTP id 98e67ed59e1d1-35c30000104mr272692a91.11.1774563878752;
 Thu, 26 Mar 2026 15:24:38 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:16 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=2199;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Bkrh8dbtdInO5wZHJbP237TumUuE8eZL80zRafq4z5c=; b=r+Ksvf5Tzi9wrZK3RvQc1ByJZ1ZJxVo8VxXv/mzOeG32ukrA+EzJbetR3GTGB2X4avA5pYEIw
 2Sc+4DsfnYHB5FEh+yTsFYKnnRlz4kYJ7QAOuJpchSQEInd/x8o+zGI
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-7-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 07/44] KVM: guest_memfd: Only prepare folios for
 private pages
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 41164A0008
X-Stat-Signature: kej9h8radpba7788ncfoyq3kquu7ers8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774563880-336086
X-HE-Meta: U2FsdGVkX181ChkHy72YQAlrqiaXGda77AFz3rq9oC6D3avvleZNqNb5uCMd0ywROmSJjqBN347fiowUbBWc6mWZUzL2jJoJOC3Dgeu6ca3rtdcU9dNd2zsXg1XnFu1Lin/+3OSMEGwvS5IeJ2Z42zCQhfpR2TDCTgFVsh/8m9PFYXUyI9bSW9YgAw3wVLYJRwVkZTmLuqqKGJHzdMnh5uK6qfiFRi0Qxgtjm4n6CyLKlhF01oqKuVIxZVRbTuJNH3EE88LJO/5KBm5VAt931eExrGT9Qb+qMdiEOrYbsJjTziyi3pJC/OZyo5jwHS+yQEma6ICGSt1vpZ289n3wVqUk+z5u6RQMe6MEoEuTN9CyY6P2TnPEc0dn0TkHSyWzYplg+WiU9KBuKU6TEON7zf5JfYYSl70GX98qs7RbQioaJkKQDVQ9ubT2KpVqAM3i51TRUCe4nAu8yX7sQ3U4ItNXaUHhVVcqL0HIeOqXgJuqzcJnFxlqemOAWQUFVOQODPyGpqyLhUWeiiJ4dxhyjIpijt/4+Alu2kKQW+Yq6KrVwBo8TUt5S9lYInFI165NO4NCNE5rINxaJbBpLzlASOxwErf7aDaH8ncUBMVO2LCLsFLYXMw2Q032BGtj/g7jMiFz1aipNNqX5a5E3JyCSZG80dqXmJ8t9bLWr75LPSQQCfqBTnOvVy/2aCGyx+tOOzxtLE38Km0YbmXkt0HHWGSiu0OnSa19u1gPWUyntg84glQQtkg4UHDz5ZgdYl9ofl+Hx3pKBi8KINTAQ5l8sXTfOAsojfjULdfiAdldLqhd1vjihIypuqGTIENdGuEl+yNITrs5t1aMN0EH0OI+C4osoQxZs8nJ0Y8Hs4RdDGi9yWYridRX6Ks05vGKfuaq8R3QxtFSjtXUr4D0iY/pRLtIzWWN5uMSaNI9OD2oquKdFqhbvSXGXxTeK7jTvhHtmthKktlnIm6zvgHbMq2
 pGNdkFcS
 333cS1JZZgo1hjEeRo1QjEU8FwGOeaaNHwYZU0SxTG4H2RWfTrUhzKMSubpTWmXt5dPsg8J36Nra12j220L7JivVAflYoP2l+jci8Dh28Ul2Ql2QGAEO7IGIN9cWTl1ZsJ1kG5U8ubtfxp6tIMqw7wm4XYXXuxR5RWNe/0mdt53UzHCh/wyAoJ8fnr37wDQgVYDN0Fb9s2njQxkyoT54MHuDgL/OQGmiyTM3lRHpItruunT/7x1fCvEbLcqP5rLySmC0R/vKJ3c9+CTezS75/DVqP+w5C/kI45XQd5zOPJtcSVviQIlWxuctVroe45dLaRyfbioZJvuVkwAPg6paXAOt3aJ+55RzWlDtIu3EOPdFX92NFx0BhqQAgr1ih2a5iNblM5b4a4fExkKYVxelLHF3S2RqpMObMIyFMUXbhkGsMMaci5l74c4pF0igcEzWKoGRZ0qs0AQJmyOH3P5gCWip9RbWfNz9HvrbrewMSdTweFf4GHe8WNclTeiYxg0uk9KyVKJe/UNmRqSG8jlRz8+iWQ+Z94KQMXvyIyBdWG14nwzn9MjxT02kzdZx+p1wNNL6Td91TQgQYETwUmrkQ0bQ11qlveypUtCPuh3cK+0Zo0fu1uteRWpt79uk3i3rl8IlgQmeOWQBiKLdRUscwUXyM0SppXvCXc/cY7jgURayAhp4ETh/LLMAVSbDSyrK4elwCx2XUtAxZBU/bO16m1is9xQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All-shared guest_memfd used to be only supported for non-CoCo VMs where
preparation doesn't apply. INIT_SHARED is about to be supported for
non-CoCo VMs in a later patch in this series.

In addition, KVM_SET_MEMORY_ATTRIBUTES2 is about to be supported in
guest_memfd in a later patch in this series.

This means that the kvm fault handler may now call kvm_gmem_get_pfn() on a
shared folio for a CoCo VM where preparation applies.

Add a check to make sure that preparation is only performed for private
folios.

Preparation will be undone on freeing (see kvm_gmem_free_folio()) and on
conversion to shared.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b6ffa8734175d..d414ebfcb4c19 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -900,6 +900,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     int *max_order)
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
+	struct inode *inode;
 	struct folio *folio;
 	int r = 0;
 
@@ -907,7 +908,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (!file)
 		return -EFAULT;
 
-	filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
+	inode = file_inode(file);
+	filemap_invalidate_lock_shared(inode->i_mapping);
 
 	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
 	if (IS_ERR(folio)) {
@@ -920,7 +922,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		folio_mark_uptodate(folio);
 	}
 
-	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
+	if (kvm_gmem_is_private_mem(inode, index))
+		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
 
 	folio_unlock(folio);
 
@@ -930,7 +933,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		folio_put(folio);
 
 out:
-	filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
+	filemap_invalidate_unlock_shared(inode->i_mapping);
 	return r;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);

-- 
2.53.0.1018.g2bb0e51243-goog


