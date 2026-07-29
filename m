Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7010C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 594CB6B00A1; Tue, 28 Jul 2026 20:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 450B06B00A2; Tue, 28 Jul 2026 20:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25B256B00A5; Tue, 28 Jul 2026 20:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7C306B00A2
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 618721C0E0C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:14 +0000 (UTC)
X-FDA: 85039944948.28.86265E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 65436160007
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kJ6/hRyK";
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285312;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wDeB6HHcZ0pmY1ywfgit3bRClBfkk9OPF95Ni5Imsaw=;
	b=yTyQIwI83kTTO410f3W2hHSVTEFzB2A45NnOdtA1UtBVvG+ob8JkV0WE3dBXvAVEBbGi6r
	LjtkYCwAX+AU1khk0Fc6Q7QiWicv2ctvuLXl5zDNKaOXUDQG6kpHh++xRvXYygF4xv6g3z
	2ZGG3nZgXWRAsjBuC/j+EvQ5p+bKlSk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285312;
	b=wxqg5NFvYKox77qSs9MdYYEy9Qz1zfvOj40el4IlDCnpaN5ot1k+r/9K/sTzIRhgruHw1r
	j3kDKlQsPs7Vz5QZVixSdLzBWCoHiykPNN2HaiD0CJ77LpP6edBebAFcZGLTZD7jDmR7dA
	12tUIke/KNlOR0V5I6f4xHHMHaTwbbs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kJ6/hRyK";
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D145045177;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3C386C2BCF6;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285308;
	bh=pkebOZkkp1inMkmJU+fGxppndabOnRmuc89kDI/A+gI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=kJ6/hRyKnzAkhN3sMmX5f2bCtSUZ6UJ0FvKno3mN8/qh2zkxpLxOkBI3L1bjTBiGv
	 W7vOaxR6O59H8FoQPzY4MoJxnT09Z3wfrAwA+CG6s97D5H1fd9KAPtgwyMLTz5kNH4
	 V8cUj0hLaqZ6BkIeO0mJOxac6jfwsX23bTXpDZdeeHQFl46WcmOPvStI1ejqbkEQAw
	 W76yc8Nla3BydbiUuH6DVysnTdMYIbkfFT5XtneUjgk8HZZmV0fySvl81ljcEO96rO
	 JZI/X0O7NR7xCLoBASlwPdJR90IMn1n4kE+Wbd9Hhq4KCnf3k5/LWERuVg8XTqETja
	 CHl7tq+BRXvZw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B6DC54F5B;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:05 -0700
Subject: [PATCH v9 06/41] KVM: guest_memfd: Introduce function to check GFN
 private/shared status
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-6-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=2538;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=w5N/wcndekVM21bdtflL2Uv+KRH9Rza4/KimR3U9GW0=;
 b=KRpu5g7Egc77bQKPLGdQFySei03zL9Q3JY6eo7VhPE2IQyX3JurNC2rrtDIMxdeh55W725a3e
 cW4tdT5vGfXBgOCkgfDHrXvTqdGTgalhlYinHAo18pVON39h1xNEFP2
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 65436160007
X-Stat-Signature: p8d6uckxdinki7pyj1oy7pqz3x48bqow
X-Rspam-User: 
X-HE-Tag: 1785285312-55766
X-HE-Meta: U2FsdGVkX19yvfVGxqhEAJlaT3WurVA8Pe917yFmOZIQjr1jicqUS96sfzEfIkS519rVk2a0K0/AoLZKuTscueBquxPz0uKYGEP6OuJWJhOewlkd/LFF6uLNNI4kom2Rhhp9a5lLKPyxRJNHTgqwz0/1taNdrncOuZbxPwITuWQpbh8Njv4rG3b+I5r09bKZj03dwcAB8UWBLa1WJXkb8+XpAfaNNDEsgWiP0a5Gih8RiBx4DSJBwy4wv7Fl5eSk2H8EmS8ApnrFyHPAmV+U17wX3tmlFCPDHSmLYOt+wabaYAnDrHT5kNEE0wU4sZtGFRmYa8xGXudLLYr+msRFQ1WTpt5z5vCTNAofaqYf6Fi7UeSF9QtJfiWugqh+aiRmycFyk0g7wNNewJVnm709I99VV2A6xQNk/bF5yy1TJgOe+Jnf0lHDJ0zDmctZLskM7hduPlL7rKU7THKf2USUlMZ/4/XL4qCncf3bxSt2ZX1X/yxOoWIfNG8+ail0fAX+Eb1GDGK712tMoOWGDzqSBGgO/PZYtbHfVngPrKm9ADXHxbCH8b83Au541XS1z0DxpyHSLIEKhz7BPK5A3S3wizHgsVICuHK+p7PpVROtRf9pKwnLdS8Q6IeZgwuFOe9FNvDx0JL2KAmYYlDYcopVn7R6oaDgTX9IG+pWsFu4l50md2ONGD5xA32SAxbBxe0IQl2xcLcBZPz0ecG07bWFzf+sZ65+6O+eA6TYs0im7umkyHRKNhxVCTGWN+G+H2s22hxG+n0z27MEWuLVl8TWiEMMHluzlWm504F6ySU45zSSkru5fsIyAjbJo8hkmPHnQe2B+uILSJMFD0HO2N5aParjMesEKcoTnrrFmvOgafnOROsijyrRhPDwiu8Ua7Q7LV0+aQgwboSRt2QX6BZGR1IjMKYqdVE/1O0JaUD83vZOi8IpCJTg0bmhWiCQFVhoQHcXd0X5ocpTts9/th9
 VSzqolz7
 vY9rp4gIBL6BTnMV0CHXetG3iHx7Xb3UCA9z04Z3PgAGlMWAONG/OHUpv+qVA5NjDysRoZVxg/t+JY26Xm40JDdRV14KquoVOf8+AMCiF3LAg1u7Arpcdj9cANWsR2PK7fYgypuRg41aHtXZRzBqkjRo+hTj/NVMGbHzQk5nkkSl1vNunHRwoXB93VBKY6valNUjqJF2TsxxAT8WEbAa895Sxvc9dnPJmpbh1+5xL1bz+lxVPfzF/ciLcxZ0ck2SEs7HxWpEwe8b0UPHjCGtlhCaaBlrxFF02/QakvwsVG/BlkdEk4zeGRbisn2pxQoU3HGPPt8yr3wr3mpIY0RXgX5SeIXlo+vOWw/X4W+kcEk0TM2hZl6512jLwUA0FNb/ozsiV2Y95dwAh/LamK76cYN7niqGe639PbDDxx7D4EQKlTf3vMiMydi7c/6o2+0+fTFcWfqawP64bPt9TEANMdukEU34ksXoJ71iOmvGxTqbvI1gaod6l5dKaRM0PQz61f2qy2KxyYCx4rgTxRljWPYIhxSI0exf9wUdJnQftPO/dqBb74HzoMylmXzSv+6FOFO0ptsBSXdFoESw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Introduce a function for KVM to check the private/shared status of guest
memory at a given GFN.

This will be used in a later patch.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/guest_memfd.c   | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 438567e3fa6a1..73f564b87a324 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2594,6 +2594,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #endif /* kvm_arch_has_private_mem */
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
+bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn);
+
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
 		     int *max_order);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 8c7709a352cc7..33c9830190e2e 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -474,6 +474,38 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn)
+{
+	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
+	struct inode *inode;
+
+	/*
+	 * guest_memfd is the only provider of private memory and
+	 * guest_memfd must be used with a memslot, hence if there's
+	 * no associated memslot, there's no chance of this gfn being
+	 * private.
+	 */
+	if (!slot)
+		return 0;
+
+	CLASS(gmem_get_file, file)(slot);
+	if (!file)
+		return 0;
+
+	inode = file_inode(file);
+
+	/*
+	 * Rely on the maple tree's internal RCU lock to ensure a
+	 * stable result. This result can become stale as soon as the
+	 * lock is dropped, so the caller _must_ still protect
+	 * consumption of private vs. shared by checking
+	 * mmu_invalidate_retry_gfn() under mmu_lock to serialize
+	 * against ongoing attribute updates.
+	 */
+	return kvm_gmem_is_private_mem(inode, kvm_gmem_get_index(slot, gfn));
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_is_private);
+
 static struct file_operations kvm_gmem_fops = {
 	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,

-- 
2.55.0.508.g3f0d502094-goog



