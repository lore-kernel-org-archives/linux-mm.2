Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7B9D60709F1
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GTWtyAd4
Received: by kanga.kvack.org (Postfix)
	id C0C3D6B07EE; Tue, 27 Oct 2026 11:47:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6F466B07F0; Tue, 27 Oct 2026 11:47:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A10AE6B07F2; Tue, 27 Oct 2026 11:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F07B6B07EE
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:47:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 83F791A0A0F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:23 +0000 (UTC)
X-FDA: 85368835566.02.C1137E5
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf13.hostedemail.com (Postfix) with ESMTP id B100B2000A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GTWtyAd4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6vMAPCp1wpjFuFIUnktZkIDiiA7zyUFU2h3UC7p8Or8=;
	b=Ctd5/uwZp9d9N3G4Cu6sofWjjOAZ+6XjwnX0WDrZyUvpIX7NDPQm3Yh0z1IUvSxGDdowxt
	BpNxUCbOGVkfiEnAUBSp2hd2ZKwnwxHFNl4oH3fxNN7DThVLG0mSj5JNE5I5ETJv66FpuG
	BmpvQqjVzy4QX2rHb7FLRo6/u8iM/Ec=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GTWtyAd4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116041;
	b=NQgCAGrkUrZ3/1NqZOgwHEDUQWfwsCfYAKz4g3HooDlfAr574Ie/tZFYv1L2Uy+G5m7592
	GQlFscDdXC43NB7fR/f4z4KB2eZ+zWxnz8V9Q3+0L5DOt4Ms9wlRvuqbl9+FoXiZInG+Zj
	2jPWVTG14kRKHE0aOV6vrJQQ+WRsy9o=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48c45111bebso1980105f8f.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793116040; x=1793720840; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6vMAPCp1wpjFuFIUnktZkIDiiA7zyUFU2h3UC7p8Or8=;
        b=GTWtyAd4BitVrC7jZ3uB+hECxBmdgREaz5aIGih4wAuzm6GsIEJ6ltXF5AL9TXTMkQ
         DIrkIylJ7Bukou5gYZZTNIQYZCk+6pPoQBo0qUOVW8rR1tXB7nAp09T1ekawPZhaCsYI
         bhfF51c4B1IkcEO5qADyg6spkfdeg2AKnZAHmeF66Ipj+aq+XwI1O+Oc/YCLgGvM0s8U
         e6f/XC7X5ZrA7Ydj+M1Qs3R1x931mta114dpJoIBY0b8rmOEJBp7kmr6sbatLDD1nJHT
         fTKLkU7GE4pdjg2MlTBcRsFmWpLHLNRf/TfZv16qUJnbIp3WEQ4lnrZ0iCN44npNBoeZ
         mTTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793116040; x=1793720840;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6vMAPCp1wpjFuFIUnktZkIDiiA7zyUFU2h3UC7p8Or8=;
        b=J9LR9cxmO4Lbh/lEVvVV/9oM6PBS5MZlCIGLrOFMAUs8pgvdUzGrgjs4MjYQcOhlrA
         xRxjDtJSmvByKRU0F62vlL7UvDfPhRtivCvv6aY82bXqpvsPxtQpIw3ZmmIoqxq/skFq
         YH33oQck1Pki878lRbZPRwBIz9gScGiB/aHfX0aNkYU5lJdu5U9vUzW/i0lyqqdFUw1I
         ei/JEwx/5xjAVdE+30kH5LUNDRVJBWkh5UDtH4XR/6KJIX1gJOFxyLMeIkWsEobqIlDW
         Yx+AYyYdXZYhZCCBAXwhrtpl5rfDR1zTzESmnxUtD1iRb7zcOID8P8oXtbQDCd+QlAVX
         s2ug==
X-Forwarded-Encrypted: i=1; AKwUvBwYc8rcY68oIL2D6FVpRfxwokfs/F2Z75xcZtCbI7qhN+FmHeEPMNRl6Wd88FL/5c5lTiEgxJgupQ==@kvack.org
X-Gm-Message-State: AFq9FYKAjHwPO27eCDWp+uHApy487TkxR9Vx+dzK0RyyvANRNEEsfkX4
	nHGAHX/aXBYZ47XQrkJvlnlW5s8OScqp5Ef41qNTm4S14ri+CjExvJrX
X-Gm-Gg: AYBFou1GKyH9DEPkvkxMx22so3/l6/nArsIh9lgbTveeUZrrSC40oalYpfrHuCjL6te
	cS7c4PN7YVBKf9wMFqoW1fWiXNbthWxenK1KFMtFHkGaL0QhfmAj1mxh0wWKLE0uqVSPO5heVCI
	YxlizBNn6eefU+GP0oJUkd+XVRmxP9TZffFc/VIznxKxgRb9jHV+5RLuu661TUrDPzmuIr1z1cb
	7F+r+7zdHnCLyM0HAZd+G+UeCVCIJ+R2rhjMlu3yHefFlFmrv0yADt0u8np3jutZ7rVqg94bVFv
	HCheIKtg6kQK18cPFPSJ2yNYQYxRUNMPQJ53qhmcVCFJJqjxh5Dd6M7xXurfHpZ1R3P93u7rldc
	dDCq7/908Hffztfr9uCxYbYhc3vP/gO1WucjFEYcutdBbFlQ7FC3cZIiPDhS2z6PBDC+tc5dNG4
	W2xsszy8lwL7g6DXv8sY1YNugnnFBcpzzFzmzYLJagr3fwxgha+qmal8Ju4sDOJvt+3aidrgo2Q
	uz/2mhhZl9DHodQS9LtwmNhfV464UlOnZktv0KamQKZfwwPmWnW4kfgNYPQFMkxERG0w8FS9Sh6
	al+j35iJYwXIS8nduonqDGC+5hIpdbDyzJzRajJfRMdQ7X0BRR/Yef15hFS11hWTNtZkcjsGxWt
	ewp2siuZ4itziIG/FnoGCb/sHx1/FPk40zpn2fQ==
X-Received: by 2002:a5d:5d0b:0:b0:48d:f39b:83de with SMTP id ffacd0b85a97d-48e3eb46758mr20927440f8f.3.1793116040069;
        Tue, 27 Oct 2026 08:47:20 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb958sm23845574f8f.21.2026.10.27.08.47.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2026 08:47:19 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Ackerley Tng <ackerleytng@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alexander Graf <graf@amazon.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Kardashevskiy <aik@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Bill Wendling <morbo@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Connor Williamson <connordw@amazon.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Erdem Aktas <erdemaktas@google.com>,
	Frank van der Linden <fvdl@google.com>,
	Gregory Price <gourry@gourry.net>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Hugh Dickins <hughd@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	James Houghton <jthoughton@google.com>,
	Jan Kara <jack@suse.cz>,
	Jianxiong Gao <jxgao@google.com>,
	Joerg Roedel <joro@8bytes.org>,
	Joey Gouly <joey.gouly@arm.com>,
	John Starks <John.Starks@microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Justin Stitt <justinstitt@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Michael Roth <michael.roth@amd.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Oliver Upton <oupton@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Tarun Sahu <tarunsahu@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Tycho Andersen <tycho@kernel.org>,
	Vishal Annapurve <vannapurve@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	x86@kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: [RFC PATCH 11/14] KVM: guest_memfd: Add kvm_gmem_restore() for PFN mode providers
Date: Tue, 27 Oct 2026 15:46:46 +0000
Message-ID: <20261027154649.91571-12-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261027154649.91571-1-griffoul@gmail.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B100B2000A
X-Stat-Signature: du1m8qyig53dri7afzhnfcbq1dnb7zcy
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793116041-54618
X-HE-Meta: U2FsdGVkX1/XibV4nLqVRfT6FCdhvUJcCIePXk3AMt+pQjhPxJpVnXt1S54ZiQrmTZSsL9V3WokeiZ2OCFXZOSysOIuQFp0Kc5fINqHlnZwryuq85cpBJ4mdvVKmKFwDbOkMso+FOQuqW75hPixLEAGrrIajexPPe+K1RbsDNHoyB5+tIM40WdmRx4tRQxYaasZW4P8ItPWY0a6aq/TKgasH1gdk2yi1bhLmUIDX55yvRjEDteNpBz97VxdAZZ+lN6HimTHc6X8hZJg7tVrZRXvjj4Uwj8lCWrXLk36pNKfADINOf/yPnYUK894e97vXsvULx88SUxTdR2wZWGet5Gt5uLkbp+lUswGAI3H2u3tzz5U9Q09Rh5tFFAp10OMPVc8v1M1AMkLeszC2BwWQD6adM53Lz59/WxCACw5v5DZkYg+YhRNj4g/cdJBbmeLaiCwXucEM3GLe4zJuKOCizKPS0YIo9w8kVtinUsiUg+V/O6p1dyr//a8jo494nsPxug4BJQm7brY7Fd97txK+sGf7pu2OVHr+bizcS7HWyh0fWkNBX+q/pTZMgjOUeBRYK21LRu5Gvz+jBzZ/jzuUzSxf0gGF2SiwDkAuiqZoKWlj/oFVW9eBFFvZl6bG5XdX6R1JCVyuO+oBBqRZuwtGTQurceHQySL6hlpuF7XZRhHVgcyzcXfTGQYyLa2uanhheo6OnbOPYQDUX26o1v+wr13/8JseLjH3bncR+ndGHrPaTy5f6Rs+1MZ1Z+8+MKkF9aajTVbiBry7pIRgTEDDkSiTgK15JGLd0FqWU6UMCofH8gCPhNQ/tZ/Skv+xiUrRlF6D/cGwQLFQcSV7GQZPE7uNrMIi25Er5O7QvzfnCpbty9Nmqw96VJCc/gF/qEGHzJ7ivpNY/KsMRb5JN4VZruytjOjEg385RbbM174VAXn4KSRghzQLWx/a5RcCdnAa4TkDU4iBg/CGDtQQkx1
 kItCyViW
 2pgyBE0fajNxKczCk3a1FtoKf2qxhU6+JnRD8K80i5YNeV21qFwd2Wd2pb+Uptx7oUURA1QECmdFs71mH2bYMav67N5fMYjxFTRq2Wa7hQy60TbVIVX7ToJD3Z2Mrk8/TgKk1yR5zao4yhmLy86jDrgkpVqbx7DaqhECGvlvC4qS1IBNYeWXCmRqIGTUPqshanybxbwlIyjl2DLcuafpljnuSOLvxmQUrLfXnU/2C1sZ8JhDTlicau1AuVPVHHFw4eTWYZtkFIFWZ14lypT88DXd726nxbW9qufA5OpGVU2sTtzXOgTpSu5RpbRuRyG4o7ZbwGBKR/gaH0ddko82OKkLGQgDW+S6jBmLZ1Wgn5kKxDkur6Z5rQLk2n5o5io0sahuw7GMkpwGgTRCGVB1I1/vCSvd14o6Aha9B7uxvRDsnqRER1ku123JUosWXpFbcjllY4NCESeN4I9GaiAJkjY4LwHjxRvHXwsMrHy5ctN+KeSJjRk/2h1rIQp4uT6rtC0Fm5OzWepAGCHsZLNvmcW8J9vp99pQappB32K1DLgvEZ1k3TwS2Rj049LgQHQ+dMTpAxMwD654bo8z56hj6F8s7QgacxdcMAh95JD2JRpWPScunRWuRlrLd+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Fred Griffoul <fgriffo@amazon.co.uk>

A device cannot fault, so when a PFN mode provider gives frames to pages
that had none, or makes a read-only frame writable, a subsystem that
maps the file must be told. kvm_gmem_revoke() does not fit: it would
zap the guest's and the VMM's mappings and reclaim frames that a guest
may already use.

Add kvm_gmem_restore(), the counterpart to kvm_gmem_revoke() that the
sample provider leaves for users that cannot fault. It only updates the
exports, under the shared invalidate lock.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 arch/x86/kvm/Makefile       |  1 +
 include/linux/guest_memfd.h | 37 ++++++++++++++++++++++---------------
 virt/kvm/guest_memfd.c      | 35 +++++++++++++++++++++++++++++++++--
 3 files changed, 56 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 25fb3d6e2032..3255280884b5 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -63,6 +63,7 @@ exports_grep_trailer := --include='*.[ch]' -nrw $(srctree)/virt/kvm $(srctree)/a
 				-e kvm_write_track_remove_gfn \
 				-e kvm_file_to_kvm_fn \
 				-e kvm_gmem_revoke \
+				-e kvm_gmem_restore \
 				-e kvm_gmem_export
 
 # Force grep to emit a goofy group separator that can in turn be replaced with
diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index f8e89723dd68..45572d929bd7 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -75,12 +75,18 @@ struct guest_memfd_provider_operations {
 #ifdef CONFIG_KVM_GUEST_MEMFD
 int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_pages,
 		    const unsigned long *pfn);
+void kvm_gmem_restore(struct inode *inode, pgoff_t start, size_t nr_pages);
 #else
 static inline int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_pages,
 				  const unsigned long *pfn)
 {
 	return -EOPNOTSUPP;
 }
+
+static inline void kvm_gmem_restore(struct inode *inode, pgoff_t start,
+				    size_t nr_pages)
+{
+}
 #endif
 
 /*
@@ -90,14 +96,15 @@ static inline int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_
  * nor fault them.  It attaches to the file, looks up the frame behind each
  * shared page without taking a reference, and guest_memfd calls its update()
  * whenever what a lookup returns for a range may have changed: conversions,
- * punch holes, memory failure, a provider's kvm_gmem_revoke(), fallocate() and
- * pages getting their first frame.  update() makes the consumer's mappings of
- * the range match what a lookup returns now: a frame, or a hole for a private
- * page or a page without a frame.  It may be called for pages that did not
- * change, and for ranges that do not follow the blocks that lookups report:
- * the consumer may then remap whole blocks, also outside the range, e.g. to
- * merge them into larger mappings.  A consumer that can fault may instead only
- * remove its mappings of the range.
+ * punch holes, memory failure, a provider's kvm_gmem_revoke() or
+ * kvm_gmem_restore(), fallocate() and pages getting their first frame.
+ * update() makes the consumer's mappings of the range match what a lookup
+ * returns now: a frame, or a hole for a private page or a page without a
+ * frame.  It may be called for pages that did not change, and for ranges that
+ * do not follow the blocks that lookups report: the consumer may then remap
+ * whole blocks, also outside the range, e.g. to merge them into larger
+ * mappings.  A consumer that can fault may instead only remove its mappings of
+ * the range.
  *
  * Until update() returns, the frames it replaces stay valid, so a consumer
  * may switch each mapping to its new target in one step; once it returns,
@@ -106,14 +113,14 @@ static inline int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_
  * beforehand.
  *
  * guest_memfd calls update() with its invalidate lock held, exclusive when it
- * takes frames away or pages convert, and shared when pages only gain frames
- * and on memory failure, possibly with a folio of the file locked; so update()
- * may only call kvm_gmem_export_lookup_pfn().  Under the shared lock, updates
- * may run at the same time, also for overlapping ranges.  The consumer holds a
- * lock across a lookup and the mapping it installs, which update() also takes.
- * Lock order:
+ * takes frames or write access away or pages convert, and shared when pages
+ * only gain frames or write access and on memory failure, possibly with a
+ * folio of the file locked; so update() may only call
+ * kvm_gmem_export_lookup_pfn().  Under the shared lock, updates may run at the
+ * same time, also for overlapping ranges.  The consumer holds a lock across a
+ * lookup and the mapping it installs, which update() also takes.  Lock order:
  *
- *   PFN mode provider lock (across kvm_gmem_revoke())
+ *   PFN mode provider lock (across kvm_gmem_revoke() and kvm_gmem_restore())
  *     guest_memfd invalidate lock
  *       consumer lock
  *         provider leaf lock (get_pfn(), lookup_pfn_range())
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 42bb5f263e23..37ff2fae89ae 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -431,8 +431,8 @@ static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
 
 /*
  * What a lookup returns for [start, end) may have changed: exclusive lock when
- * frames were taken away or pages converted, at least shared when pages only
- * gained frames and on memory failure.
+ * frames or write access were taken away or pages converted, at least shared
+ * when pages only gained frames or write access and on memory failure.
  */
 static void kvm_gmem_update_exports(struct inode *inode, pgoff_t start,
 				    pgoff_t end)
@@ -592,6 +592,37 @@ int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_pages,
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_revoke);
 
+/**
+ * kvm_gmem_restore - Tell guest_memfd that memory of a range is now available.
+ * @inode:    The guest_memfd inode.
+ * @start:    Starting page index within the file.
+ * @nr_pages: Number of pages.
+ *
+ * A PFN mode provider calls this when it gives frames to pages that had none,
+ * unless get_pfn() does so for the block it reports, and when it makes a
+ * read-only frame writable.  Nothing is taken away, so the guest and the VMM
+ * need nothing: they fault the pages in, or get write access on their next
+ * write.  The subsystems that map the file cannot, and are told to map the
+ * range again.  A change that takes something away, a frame or write access,
+ * needs kvm_gmem_revoke() instead, which updates them too.  Does nothing past
+ * the end of the file.
+ *
+ * Context: May sleep.  Must not be called with the provider's leaf lock held.
+ */
+void kvm_gmem_restore(struct inode *inode, pgoff_t start, size_t nr_pages)
+{
+	pgoff_t max_pages = i_size_read(inode) >> PAGE_SHIFT;
+
+	if (start >= max_pages)
+		return;
+	nr_pages = min_t(size_t, nr_pages, max_pages - start);
+
+	filemap_invalidate_lock_shared(inode->i_mapping);
+	kvm_gmem_update_exports(inode, start, start + nr_pages);
+	filemap_invalidate_unlock_shared(inode->i_mapping);
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_restore);
+
 /*
  * Zero a folio on its first use.  Lookups find it from then on, with no
  * reference held, so mark it dirty: memory-failure handling drops clean
-- 
2.47.3


