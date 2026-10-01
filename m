Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C445CA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 15:25:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12DCD6B008A; Thu,  1 Oct 2026 11:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DE436B0093; Thu,  1 Oct 2026 11:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0F9B6B0095; Thu,  1 Oct 2026 11:25:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8E976B008A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:25:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 64AB3A6DEE
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:25:33 +0000 (UTC)
X-FDA: 85274431746.06.E6ECE2D
Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id 91143140010
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:25:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LKvzgNHI;
	spf=pass (imf26.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790868331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ow6P9ENaq/P6weMozIYjsY54hMuiHWrHxdkamgEMjQ=;
	b=BRGnwe+ic/7aubaLUmLH/3WegBaqphV9MCDLkzNIloIlTBAd0FL3VU/ZBYt/El+j5kGXRl
	S7L6iRlfkIJui8o3pLTXPzkMEkndsS8Y/5UOnhWB+HKg0TpbXHniVCbwDC0k1u0RqQHBqy
	JkgoOC8rtJA5/KYZDKj+Y1qeXDA2zUY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790868331;
	b=sBDQDarKj97HJ4AY5mwEjy9SiWdWzZGES7FXhSTo+jXVoPbWUfxDVLdyWzOaybc5crsc1x
	bvT4z+RLK+dB94wamgyQ2snfXrGHIwWL67ZT3zfxmsRX5vH8Wa+Xlpr/zjy2ObZlYuE8ct
	j2O0zIx9Luhu8N05jfjKwc1sKd8llgs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LKvzgNHI;
	spf=pass (imf26.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-8631d0023daso3341195b3a.2
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 08:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790868330; x=1791473130; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8ow6P9ENaq/P6weMozIYjsY54hMuiHWrHxdkamgEMjQ=;
        b=LKvzgNHI4fCdcMlXZ7hFmoVKa729IB7PfNmiWDxeN+Ii8CSUkMxnPQSaxptEXa76W1
         8ME6fWnFRtPCSKcbH17wOBCJ12nalb7HOhNwsk9axI/zrciFaqB4u1csIrQOJ7YuUiEf
         ha6cPKohQ9ODiRYLBU+T0mLNUd2xm9rkV19xuEya0R/QUSTq0Ko9AaF+asrkUyO7cT30
         J7fq3w3REqztXI+BQg+izeR4w4W/mOnGjxIKCDlph7SUf6PErDhSAoAh4HvSVlHAutlQ
         WB8pHldQNgf2037SuzD6JNA8uf31RzmQAo7dEH/2OI0Fij2rcAsiQX66L56EAuc1rXf7
         8Uew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790868330; x=1791473130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8ow6P9ENaq/P6weMozIYjsY54hMuiHWrHxdkamgEMjQ=;
        b=QgJfeHPfwBmt3DOWi0AA0JTsTm3cHs0F1Da9Bkxdx75hDkDvxjgaPUCbI8UqFjJBzs
         wHcQe4VBDP8l3sWOt+UemHCm3R+GhuOQ3652KOp3vGq/e+SjXaDNoAKNC84h+YX8OYLv
         53oRZpTUxpPg5nJ11drPLMUrUk0GLRZpoOAXgevslI/C8apYxKgIKLzKnXAL+8AVNE0f
         KLUsMLIlRc+8Wg51IzHYQSd4HG5lp1r8vu2i8ujxiEk/NC3t3nv2bgebCaEJgR1fOkrI
         g/WKHAqtFdB3vZGM0s2mMd2xXySSZGLGwsOZhAoF9y4ffY2+ur+vxkm46nhc4CHSSMkP
         MxIA==
X-Forwarded-Encrypted: i=1; AKwUvByQczf1OAnARsYQZqBOZoF/T2Zz/FbP3BYqlGca0GOtilbs3ChYumIDQQ405hTkhTxV2qviSuj8jQ==@kvack.org
X-Gm-Message-State: AFuF++nLy/0jc1yMVOsGCv34kOeQz+RwnrTX1qGQo57HpmCfSemhc+C7
	rFEySNFHZ2SpDJ6Z8OuWdYxo9XLaqSVYNVorZRwAzQP/+8ZeVaAUghZl
X-Gm-Gg: AYBFou1B/AgCdX+zoFA8/5xJzxJ/ZatY5cOQps4n+HpfmDuuJeSuLswhPM5fsrvDDuM
	ZHC8IWjx/6Y/Sq+NAuqg/3cX9TqnC18/+4eduwuMKnYVcMtbYBdSittuNFfToYH+bXYomf8vapW
	3i8Kdt94X+gyPsJ5UGBaK3l8drtTmaLhxNkMcUmWHGbUdi+vAeKUjOA6z/kd5TXh3S9zcOVO5qn
	f4dy4iLr8st7M8DP5jlVPH3v/Zr3nSIjKnhIK8nsJo1JNpxpaJGPTY+CbsWGmIqEy9oyWXqEbBQ
	ekfRYptdME0bthD28gSXvCXlaxtHVSskdvj35SeGScpW1eN/WAIqv9wR0la28Y3x05XLmzeDdp2
	I98oiHIXXhiHZJ6UDICUf1mtjI9nWvLvYUZR2uO493sQbQxnrPsdiCfhDP4j1UJQCQlE5r1FegW
	gWBBuS/cliBCz4Rfcy4k6L6WgTCMAa/MyQ2Z3PfOhPHSgSUt1RuVRYUItCKwaZfHPea9JUT0GyG
	+b1XZvxlvNt
X-Received: by 2002:a05:6a00:21cb:b0:886:458a:42e9 with SMTP id d2e1a72fcca58-8874c9d1ce6mr4160705b3a.49.1790868328827;
        Thu, 01 Oct 2026 08:25:28 -0700 (PDT)
Received: from thangnn-ASUS.. ([2a09:bac5:d457:2e1e::498:2b])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88815996973sm1320468b3a.6.2026.10.01.08.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 08:25:28 -0700 (PDT)
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	peterx@redhat.com,
	dave.hansen@linux.intel.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com
Subject: [PATCH] mm: don't ioremap COWed anon pages in generic_access_phys()
Date: Thu,  1 Oct 2026 22:25:24 +0700
Message-ID: <20261001152524.171115-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <699ae98c.050a0220.340abe.0d31.GAE@google.com>
References: <699ae98c.050a0220.340abe.0d31.GAE@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 91143140010
X-Stat-Signature: dsaycsgu81pzhedjymxaor1r7akbesbk
X-HE-Tag: 1790868331-112404
X-HE-Meta: U2FsdGVkX18M13ffnUtbg6Cv7T8TZYeamNVyhOK4/ZF7e1heAdLRj1CpmebxPVi/MS2H2goL7f2TGdnB/uXBgJjZNsJIy5RUBA5euPSDt1huu2yxfjYETBdFkKGXZZvTcx1Tm+gZzCN4zQIMJ26lrttJW/fb9l6OTV2fc5x0f7dRTje8fAGTSpFni3ZwJ60RNROkKraBtT/YgnkJYph3ftsy9rwcJo7kOOXGbLrgrae1CXPHC1U3YwRVckkrnRMYLV4bnaPI+iwWWhTG5VQRHQIzJhRP1iTuBrKBBwJ5q/31RG01B69qhkEZgALdWlvuKWzTUr9vdh0Y0Qkzk6yptsjo0UmCXZubglsVwwcdorSF3MTFvwSXuNfpe6l+DOXaXzn4LUjVdQ05rM7r9ZMhWrmOpBv3edBJvSgBoW2DFEYug7x74pejy7bM46CsFrMDOwlJgt7QuiBdo+VVd7vkHgmhVMVb2CF8qWv6/BgUK7csMdI3wdkbvDUiuFwTheRMxSx/ueqnIZ+bPTppi3AOjXfxHHEQ4NAeffJK1hzVr2kM7AKZhd6hBM9rEQ4ak5yq/6wWL2EKfNlK4BX7cyRy6Aw+0+BZi/uPuLfz7G0oASi6gBIiBwv2gUt32/4l982bWbTvAd/K9PBm9RzyU3SMt7kZKD182Jmy80hbLXTItVDAPyZWkwRLp3COU0Z3lOai/pujX2lQGFPqFuUHpCkfwEyd/ndlhcYLrXzh9xzlNVyOyIEuu+4F7V+10J/vXethTzCNh3zi0DaU47hn9JzXy25OXhX+45utmXEbwmHYufMCU1S/80dZINmPSV91us/19P0165t6/cxA0xTXVJE6pvKgrAnyqn3+FAHxuAGfgORuqMiKqdBr5v7tYdQ3GcQiwNiVWlG7GVOoSIWgYAQRFeZr9hwtvRfEqs4cNiuClZTPPPxZvD2NR9U3iAYWmtQ7V+aSqyNIPow4EWEY7sb
 SH3nS57R
 RuCyVXpkOrjVsttQ0d79lvOnFQ3CtwNemtn+1tfP2LwFh6S4i4z2f4lxJ2WcWMYHqHfRp0oNt95fBpk3RU5PNGzUiEtmmVQ5XFzg8/lXSaSPeT3icAFlEEAdG2zky16ASfdil6neUMwm78bfPiOyHWxVcodQ16SlM7woGKd3AiwvzbPoRif+xxbXWyAD+SvD4YOdqcmzkzDmePiPVhYmYpvcVbv1iszUUlpH4BM4BiNp7lBEC1+90O0bovr8yCoN3lYBXrHFS8LwOxURhalOjmzDuZZP0SekAoHwoOnzEiDeNpE6Pi+vLcJWjMNi/e69b5BweTkSKkzyTScvNRlmNfVZRutGIEohEJ7HsN2GAzzcqiv7xxshf3kfB3tviDtJJjgaqjTjGfx9uzumt2yhmddY+luEjRenGyFm4RtrZPWM80RlrFti4CJZJBpS1hHVnPY1lrZ5a6+n4z55zr5xhdsQM0F169471VGNqMKfsT/2RuCOE9/QChxtUC8PjKbxxu3NovIbtxzN8SzN7V+y6mn5JW3ktzpyNDWMY20aVQMrM0YpdB5ToVJSkcLut2yfE8WmsC3WsENNGHo2HqsdrMwR6QZJw5KNzYrHBn6xjTJV/a3PJAlvtfuGo5sLvSwrW5JkJYzs9wWZYLD8nAkjiVNTrxsQ1yBqyzZ8eNLk850+GSFEg4pONpoAdhYI4y2s9uakLLFv4ffr+08G4zYawhQdbAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A MAP_PRIVATE mapping of iomem (e.g. a PCI sysfs resourceN file) is a
COW pfnmap: a write fault replaces the pfn with an anonymous page, which
remap_pfn_range() allows by keeping vm_pgoff equal to the base pfn.

generic_access_phys() does not tell those COWed pages apart from the
original pfns and ioremaps whatever the PTE points to. Reading such an
address via /proc/pid/mem or ptrace then ioremaps RAM:

  ioremap on RAM at 0x0000000045623000 - 0x0000000045623fff
  WARNING: arch/x86/mm/ioremap.c:216 at __ioremap_caller.isra.0+0x4c2/0x5f0
  Call Trace:
   generic_access_phys+0x130/0x4d0 mm/memory.c:7178
   kernfs_vma_access+0x1ce/0x280 fs/kernfs/file.c:437
   __access_remote_vm+0x58f/0x890 mm/memory.c:7256
   mem_rw+0x2a1/0x670 fs/proc/base.c:912

Reject COWed pages using the same linearity rule vm_normal_page() uses.
All generic_access_phys() users set up the mapping with a full-vma
(io_)remap_pfn_range(), so the rule holds for them. The access already
fails on x86 and arm64, whose ioremap refuses RAM; elsewhere it no longer
reads the anon page through a device-memory alias.

Fixes: 28b2ee20c7cb ("access_process_vm device memory infrastructure")
Reported-by: syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=49b1021becba70c1f3f6
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
---
This answers Dave's question on the syzbot thread of how a PCI BAR can
point at RAM: it doesn't. The repro mmap()s resource1 MAP_PRIVATE with
PROT_WRITE at address 0, then (via syz_ublk_add_dev() with NULL args)
writes to address 0. That write COWs the BAR page into an anonymous
page, and the later /proc/self/mem read hands its pfn to ioremap.

Forbidding MAP_PRIVATE on BARs would not cover /dev/mem, uio, cdx or
dfl-afu, which share this ->access hook, and private pfnmap COW is
deliberately supported (see get_remap_pgoff()).

Tested in QEMU (q35, virtio-net at 00:03.0) with a small program that
maps resource1 shared and private, COWs the private page and reads both
via pread(/proc/self/mem):

                  before              after
  shared          4, 0xfee01000       4, 0xfee01000
  private         4, 0xfee01000       4, 0xfee01000
  private-cowed   -1 EIO + WARN       -1 EIO, no WARN

(pread() sees EIO either way; internally generic_access_phys() went from
ioremap WARN + -ENOMEM to -EINVAL.)

plus 4 x 500 parallel runs on the patched kernel, no warnings.

Note: the syzbot report also groups an unrelated signature under the
same title (pcibios_device_add() -> memremap() of setup_data on PCI
rescan); this patch does not address that one.

 mm/memory.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 8b0c2c735d3d..8551b144028d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7141,6 +7141,14 @@ void follow_pfnmap_end(struct follow_pfnmap_args *args)
 EXPORT_SYMBOL_GPL(follow_pfnmap_end);
 
 #ifdef CONFIG_HAVE_IOREMAP_PROT
+/* A write fault on a private pfnmap replaces the pfn with an anon page. */
+static bool pfnmap_pfn_is_cowed(struct vm_area_struct *vma, unsigned long addr,
+				unsigned long pfn)
+{
+	return (vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma) &&
+	       pfn != linear_page_index(vma, addr);
+}
+
 /**
  * generic_access_phys - generic implementation for iomem mmap access
  * @vma: the vma to access
@@ -7175,6 +7183,9 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	if ((write & FOLL_WRITE) && !writable)
 		return -EINVAL;
 
+	if (pfnmap_pfn_is_cowed(vma, addr, phys_addr >> PAGE_SHIFT))
+		return -EINVAL;
+
 	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
 	if (!maddr)
 		return -ENOMEM;
-- 
2.43.0


