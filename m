Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04462E98DF1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 07:05:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75C786B0093; Mon, 23 Feb 2026 02:05:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C5246B0095; Mon, 23 Feb 2026 02:05:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E8B26B0096; Mon, 23 Feb 2026 02:05:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7DC6B0093
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 02:05:01 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 061C0140827
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:05:01 +0000 (UTC)
X-FDA: 84474834402.15.D041E49
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4AA0EC000E
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:04:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HyK7CYUV;
	spf=pass (imf28.hostedemail.com: domain of 3GfybaQsKCNQ02A4HB4OJD66EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3GfybaQsKCNQ02A4HB4OJD66EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771830299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tZVo84a8gYXfxb6fQudIUthBz+u2OhxnqcpBYF66SVE=;
	b=XVcy10GLqbEDSVjfkvbkz0fPVcapat2bPMTVcUYCCDcMgzUnUSAydVWuYorLlaUsR8GJSB
	1TUv619Ehk1tVR4PcOgLPRhuTZHV/MFS+LhCAHJYgmop2FlvpNG8e2hZC1f/rtLIHIQiSi
	HDZMuplvkmajE7WxrYHqqwQ0/avJfxs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HyK7CYUV;
	spf=pass (imf28.hostedemail.com: domain of 3GfybaQsKCNQ02A4HB4OJD66EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3GfybaQsKCNQ02A4HB4OJD66EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771830299; a=rsa-sha256;
	cv=none;
	b=LkX5Eg9259p/re99pKV2rFHxGt1rnW/mA77aivFyqkAq0Jbw8J9DAAazPhaLW2faDHYB1L
	95S4RfB9QGm5YVkdPCQL9J0GQRvPpwzbg0kyHMrkppXq5+sS/jxi8bwyh1yfgLoLXT/3O+
	MIYIBv3XQOVNjSaasCVPpEGdM4+f5pY=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-8244d786b23so1534189b3a.0
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 23:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771830298; x=1772435098; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tZVo84a8gYXfxb6fQudIUthBz+u2OhxnqcpBYF66SVE=;
        b=HyK7CYUVQO22O4s71h0W2PPPz2qdtiEQfRbpx8oQQQvT9cv46WHuRxKFxtSSq9W0CU
         w3roJGxy1TBxkT+Xmk+dCzM6q+K/WIwSanG53p0geTRWljliTY6zT+j5KraR3Aptu9Cx
         SRDSmHMV3kqo8iImLLc8kwFokddsJhpS4iO35GwiTuZKwjf8ZPFr8WyG0KByKNKnE55f
         nZUksO+WQ3b2hwkPrIh0VWRRx5109sXcl1pweMILMFJcwJyBfSn+rxz8jNFdNdjslC7S
         MUd7uKz/27hehKJZZ5hN0MhZJA7zJgN+vsrABOwMgsUbEehfDCugF2wsXyipY85QHYNL
         qReQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771830298; x=1772435098;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tZVo84a8gYXfxb6fQudIUthBz+u2OhxnqcpBYF66SVE=;
        b=DLYeWx0TpRidbjXJGrMppYx6JDyn9LyseJdYpk+psdtdxhaeEOyz9v3eRtkDPOJ+bE
         IVwgYKK+zLrWIwrb9Vfjy+zojLGqyMZUsuR6b+jOMXvlJSXi/Jg/RiCUipjlGysaSnIg
         njVhh3RBVnvhyhMHyPxTdSCWKjOsxVr1AVDDP+wF8Mu9ewpFAZGqjIBOQ851zlXeWcru
         Y93G+pEMNKsScBKYISNYLamimJVxPkuBzV042pM6sBR+HcCTcpGj4+jmCwrLmsCHjSDt
         fww1DUJSqRXnRlG0F3CglSU7jcVJiMGw6rfQn4tawk42QqgyDMmeT0NelUMc09whCWm4
         /frQ==
X-Gm-Message-State: AOJu0YwC/UnSEehqAP5B6kAICvoUJtebAnZ5u8h37qD/J9k5D3xY3TRb
	D6OcR3Vtwittw3fUm9Az/Zykz1K7eAjOyZ5JffSImT4xloylfoQ/Y3PqjHFGA/sdDmFw4X0MR5P
	38l6bv68XZUPU+vcBFAR0tRwUBDoiJMFAaX2K7Eq7AYawlOLWXRHUXk26owGgVgWYv8C1p2IKBR
	2282oZYdmgnPbgHJOmgL4obZVGZkjCDrEjrCKVfmEL0ChfADtRMwSSWEfl+g==
X-Received: from pfbdf2.prod.google.com ([2002:a05:6a00:4702:b0:824:b56e:1181])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4ac1:b0:823:ad3:4ff4 with SMTP id d2e1a72fcca58-826daa0521bmr4935965b3a.37.1771830297745;
 Sun, 22 Feb 2026 23:04:57 -0800 (PST)
Date: Mon, 23 Feb 2026 07:04:38 +0000
In-Reply-To: <cover.1771826352.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1771826352.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <45a3e4c00f4494c5f91aa1ccd9c400525a55ed45.1771826352.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 05/10] mm: Export unmap_mapping_folio() for KVM
From: Ackerley Tng <ackerleytng@google.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, pbonzini@redhat.com, shuah@kernel.org, 
	ackerleytng@google.com, seanjc@google.com, shivankg@amd.com, 
	rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, michael.roth@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: xoija1tfbwny1nkbqxgdgm95ukm577df
X-Rspam-User: 
X-Rspamd-Queue-Id: 4AA0EC000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1771830299-850907
X-HE-Meta: U2FsdGVkX1/TrIuYwSB8gNh+deQ24EMHYFViuNMTSRdREVl8sIz8vKpUl9+v0K8lj4ZWa6OqlM5Gk3pq074EMXz17LfDXfegbQH0OrxQS0xqlCwkwZirVlSoi05S8gO6u0zHiavMSD1hs5/imXRyAPDcURJELF4cJk2MvV8V8DE7HugEMjublGGCS410Zkd4m//F+cxJesjfZvkK8wXiDnU78zEnRxwc8bVzTYo6jpbEQ5FtrGnyoCnQbwK29NGlbLujx7nKigKNDXnG9+lH9x2W+JbolH+kzNQGlwafopxD5k+maozxacsZNdK0bh4CxPRr9W70GBzVLEGQXABmKlq1Bwd/VRLN7pTSZYyKtb+W7qpHFY90Pz+3GuGjjILO6tjdOvix9pWg0VevVFp1DL6lsJEwguCHJVijuXm5ho3i+Pcxhamy0+FW8kd5e9HIcJy/9dPn4d0jEccYT4nawQGbp7G69soZfHxcBomC5cxlxZfPhcpbhrl2SXynFYX/D66pjD6dgUat+n0WaehMaIGC/8osIajA2SilMuL1Lw3h5QrFv5RmPHtXH8xeoTLoo+7IWxqV2zHgSoUkoQrgGCYo5bd2aRuV+mgTn/WEHTOKi8v91tcOhxGgtnh9C9e6wixlj72nj2fakKuAhcVONBuzKho2rpnCUIKFHD6O88DIpcpNLrOhCmEZkYlhb9sDnnRJv1N5Z4WNdx7Qg6n2OtK5eS6okhA+A4HOwshoXKa92kw9IUIYGTvNDiZH78h8Cm5cm8P6j9vIyg42R5CE1y2atZNYG3uW39cCRs8ty+x6cVg5zHp0w5SmD+YIaLcdbPQp3Kn0y7ElMkZflBGI61jVntxrD3fTBpLlO4RtXR1n8UdBUBazbd77JD9BxCQFw3k0zgFRMjAe+nQtM7BxpodLSgcVevt0sjnH8ug0CMq39aGYtORIBZOb2oLi9eMNAHgfueTco6cXYFTcMlR
 m/QAh7gD
 ynZIC8wr4eWmuJ5KW5hQPYp+89kxp5IjQxVEWVjrC7JoTSDR7Fz2qoQMh82oV81mgFEemDJCpkLTjMnhNkjVuZKtz14VpVZ0uJIB1cw1Pch70eDRFGEt3qZ3L7as4NGmtQWpf3o56jTIDqLs4NL/qxAXY0/bdtzI0F7w3Rakd+zpldBsLsF4vH8zqc9JDi1Iq3mhBPbMcWckl2iCg3ecN02MgswWVOaQYQrsj4PSu3oouTjzJ0ZqBbLY+AbAX5RBJStlTAqkrKFqUfVyX2fzVEyXM+ZHxujE8GZlShlVZSeNabP7dqnGWpe9jfk1j6hLnus91sh2qNZMbUKPVVoMcg3C6l/YRqeEdocAAaN0Hl+qewiqZwea/jqGBcyOQyfPq9iLFznN/6QxInstHeptvEGcCHUXA47/6fkZz+hn/sqaZWNj+mQNRK3N23VZJijjq/o8dBRL//HrvJlifV30e4ZUDs4yVq8WxO48v8Z25GVK/AXCPtvuXmIbCGFKChIItzOTdBuya00DFVwqPIfBH8yilvNC6VZLc4iK7NK0i7an+sj/KyLwzP9M3Wyj/t9Zo/5pzB30NvtcLVtkKkWGCYn79AmmMrgUq/rXK/ZUHj027k8lYsWR6dGxrIKhJbNs3sCI6Gsr8XHKHj2E+xAsTWw4rQi773FNJiais8l5aNS7ihxBl+7KjYujLIPCEIi0Tu01tzJRb8oiN4CkICTqz9/1Y9Xm43d9nyex2Pf9Tg5UfYrakh4vw8WmSQw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

guest_memfd needs a way to unmap a folio from all userspace processes. This
is required as part of a folio's truncation process. The function
unmap_mapping_folio() provides exactly this functionality.

Move its declaration from the internal mm/internal.h to the public
include/linux/mm.h and export the symbol.

unmap_mapping_folio() will be used by guest_memfd in a later patch to
implement a custom truncation function.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/mm.h | 2 ++
 mm/internal.h      | 2 --
 mm/memory.c        | 2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7f04f1eaab15a..97fa861364590 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2690,6 +2690,7 @@ extern vm_fault_t handle_mm_fault(struct vm_area_struct *vma,
 extern int fixup_user_fault(struct mm_struct *mm,
 			    unsigned long address, unsigned int fault_flags,
 			    bool *unlocked);
+void unmap_mapping_folio(struct folio *folio);
 void unmap_mapping_pages(struct address_space *mapping,
 		pgoff_t start, pgoff_t nr, bool even_cows);
 void unmap_mapping_range(struct address_space *mapping,
@@ -2710,6 +2711,7 @@ static inline int fixup_user_fault(struct mm_struct *mm, unsigned long address,
 	BUG();
 	return -EFAULT;
 }
+static inline void unmap_mapping_folio(struct folio *folio) { }
 static inline void unmap_mapping_pages(struct address_space *mapping,
 		pgoff_t start, pgoff_t nr, bool even_cows) { }
 static inline void unmap_mapping_range(struct address_space *mapping,
diff --git a/mm/internal.h b/mm/internal.h
index f35dbcf99a86b..98351be76238b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -953,7 +953,6 @@ static inline bool free_area_empty(struct free_area *area, int migratetype)
 struct anon_vma *folio_anon_vma(const struct folio *folio);
 
 #ifdef CONFIG_MMU
-void unmap_mapping_folio(struct folio *folio);
 extern long populate_vma_page_range(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, int *locked);
 extern long faultin_page_range(struct mm_struct *mm, unsigned long start,
@@ -1131,7 +1130,6 @@ static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
 	return fpin;
 }
 #else /* !CONFIG_MMU */
-static inline void unmap_mapping_folio(struct folio *folio) { }
 static inline void mlock_new_folio(struct folio *folio) { }
 static inline bool need_mlock_drain(int cpu) { return false; }
 static inline void mlock_drain_local(void) { }
diff --git a/mm/memory.c b/mm/memory.c
index da360a6eb8a48..983bb25517cb7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -78,6 +78,7 @@
 #include <linux/sched/sysctl.h>
 #include <linux/pgalloc.h>
 #include <linux/uaccess.h>
+#include <linux/kvm_types.h>
 
 #include <trace/events/kmem.h>
 
@@ -4244,6 +4245,7 @@ void unmap_mapping_folio(struct folio *folio)
 					 last_index, &details);
 	i_mmap_unlock_read(mapping);
 }
+EXPORT_SYMBOL_FOR_KVM(unmap_mapping_folio);
 
 /**
  * unmap_mapping_pages() - Unmap pages from processes.
-- 
2.53.0.345.g96ddfc5eaa-goog


