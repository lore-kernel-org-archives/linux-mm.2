Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDEC4CD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 168B16B00A8; Thu,  7 May 2026 16:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 022A06B00A4; Thu,  7 May 2026 16:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C56BB6B00A7; Thu,  7 May 2026 16:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A605B6B00A6
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:22:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 67BF2120594
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:59 +0000 (UTC)
X-FDA: 84741747678.11.81B86BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6777A1C000A
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Rb5QTB/8";
	spf=pass (imf20.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185377;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xIxUvM3MXYZoSm5xqQK77rq6dLyb+CmsoWHpUejr8GY=;
	b=w+2aTEo1HaCwektKHlbjtmxd9DCgdbUyJ2GcSdI23L67VjeaJB2CklKgb/5/1DQzYn4uvK
	PmbhFlYmEW1P8dfYlBiMWvhUCJqRoSoWfCPc1NFP/0Qq6eeV76XIKCltT6zPym0c48N9nk
	KzRd0zGrRpqM3uhQqIW8YI72yMDxc50=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Rb5QTB/8";
	spf=pass (imf20.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185377; a=rsa-sha256;
	cv=none;
	b=MCikgwZZ57hXv2nZP0k7RNH+BRtO+kYSdRq0dWqwaPiP74y/Va5Ne5EgO2kVrOl+NsoCBW
	n1LEDcPzxWUndzHPQGLL9yqNu8JksAYpZ/d1zOHGrIk6s/oqDbyCQ8ysLMDDTbiWeKyCHi
	TAZAxJ3cZkav7VJgJAwq6DGP+eAOJ2E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CD8F844771;
	Thu,  7 May 2026 20:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A1212C2BCC9;
	Thu,  7 May 2026 20:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185370;
	bh=ECkc//Rm5aBd8ErFl7GQTiHwXQZQd+G0cJcSZ2SUQ4M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Rb5QTB/8Z4E5BQXSKy5CyYL0tGV2JZkL2sjl0qZ5/OuZCZgFXpAET0+ud+L49uM3Y
	 JxRg/0NV+T9O5XDWkHLudhpzGq20NsRLwne2IInhUrUxWw4QoTlDNFfOPvWCDmn169
	 wux10//mxWKqb5IRC+ufFmbsIs6BlZ2D1HTO3xdbSG8/LbWfohurRw9wxqGVWzlKxK
	 1N/zXGTDJTIZ/uoRAfU59GPERK2p+bvG+twQUPTYEPGukSfVBuS/pnqAEih2hjvIm+
	 o5NRrcHY58wM9xdb4H/52wGYuuPMKZGYHZAjaAD/3HFIkPLcXQmg1U/sD4m4QXckEm
	 sW8HsN6CrzpvA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9266ACD379F;
	Thu,  7 May 2026 20:22:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:36 -0700
Subject: [PATCH v6 17/43] KVM: guest_memfd: Determine invalidation filter
 from memory attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-17-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=3498;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=cb6GU/Czugc5dCGBR8Xkq0dGJY95214cakpcZ5+aX1E=;
 b=BctN5RnJgW2m9CJ/sfOPv5rohicoHUSrVanK/+sqiEOSDoTS1c64rUYu0WQ4DBVrjaEC+5C4P
 hL9SGm1sCo2Bqf5LRAMBA9DXaXIgvAopQd7IkiaewR9TKlld4fV+BDJ
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: oear7rath7tega46qrzpnynmerr9yidc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6777A1C000A
X-Rspam-User: 
X-HE-Tag: 1778185377-760091
X-HE-Meta: U2FsdGVkX1/ZnPHHnBYRQ3fKzx7mdYtEsCr4Pp/eBhcfzDT2MRdHh0B+wweFWoX2lMKp6KFnSq1Jc7jwKu/Q8lGnhfw9hTeTvXODKqlf4zoCOJ3qzG8wjnpckwLWyycmYWtfkGDUqJC/EgoS2OK8hpluBlUVZ+vx94YnmF+1Jup6ULmo7VEfJRRiwiHjGRFpd3V7EMB4Tp/pXe3IhezkJ5oVVHP4MjD92uioAqd+Zz6r3Ly+FRLZufcPqJmy4Cec74SRE9H8FF/yT8vgSdLWANnbFzri6eWj+i+uEIURzO1FqgNWFZunyTmpnL+WQknKYtwdq04w39wBETrHr/rAwA5p9NZFeAhT4zvsE+hi/O2iO53L18AfQiUzFMWAID31UjaFlDgoC7IzRFxo8ngntXQ4L5mYWZ8H8TXRUYokqoabU1HOV6R6TXX71u9VBz2b/e4thohkJEUBK2S/aHIJe+i/I8b4Xdn8r/UNbgBnMOSLzUkx9NH3T5Muh3Kr14GeQ8bn8v9tfAhjBgKj0sjho6mEcJxJK0XyxVQS/M2IzLAl3+VIabtFeuaUVHKUW8J0NypbLegejkG220+N7DI1VxhL5A9g+2X/fW+uT88fCVMvAhRKHdig6hyhh7VDbQ3GGtkrYHraImRd+1hC6TY99Cilg75kV6VYFgzFnepaUCeaWCCvBwC8Q+tAaHNabD5/0GLAfJZ7BC+8JpHUegqhtphycOABoNSRN+mnns5FBoIjj9MkMeXXyB8FV+BM57WXasFC3oWuLsoQGMQOVzwi4tR1BZoofZBubxs2FJJE1DNEPkxzCdJNXL2vEPEtclysunnN9rPRnZyKFbXLWD2GEZpqDL3SxJXwh/nmPDgl/bKPcUCKG5GeoFKZFfd6qvDSDwzHLWHjy64j3h9bWeY5b7Hav/8QjB6+PuypEhNg2nUWUuwy7WedTku8AOTZe9BZO7q4Mcw55qgGxaV0yZM
 3VLaItzn
 BdEtqrXNaoU1mN8oUJWljMc/wij9aXsfHmIizi0arEJwcAF01ZIxBQ+eHInuZL9ITcrGcDLKuCg39jFfBftDvvr7utnYCJ+DA5Yt4yoIlutv4ctvkP43Z8mA2zaqQag25ytOLFqlIbRT2Tdp95KMC5cY1vZCkLsJ7M91hXAI+AcW+1Y/J6e0buAAAHSPPKKrXGTsy4PkqfaASuEtW8DBHKUEMGwC0IAUtcDy8qnkcQ6P/Gb0QZeUuyLHqdnT/sa+bHnrFo0QWp9EfblmJQY1JHJqdkcvVOeEsSlSsOk8TWXwPDcmyPNWSfEGlCpDrFmThlhd6X194/ZpXregFJvc3OXTUk5crytkGqvLYqMLf90oZPB3nYs+qeoc5kaKsNHF/Sc+3c3wc1wmVUI169qXXZ5ahIw7Ee29R22NhF5GclxI4HJ867iaJXQ1Yt4xnwc/u2ujiRhB1q/OWhvKygRjQ33i0mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Before conversion, the range filter doesn't really matter:

+ For non-CoCo VMs that use guest_memfd, they have no mirrored tdp, so
  KVM_DIRECT_ROOTS would have been invalidated anyway.
+ CoCo VMs could not use INIT_SHARED, and there's no conversion support, so
  always using KVM_FILTER_PRIVATE would have worked.

Now with conversion support, update kvm_gmem_get_invalidate_filter to
inspect the memory attributes maple tree for a given range.

Instead of determining the invalidation filter based on static inode
flags, iterate through the attributes maple tree for the specific range
being invalidated. This allows KVM to identify if the range contains
private pages, shared pages, or both, and set the filter bits
accordingly.

Update kvm_gmem_invalidate_begin and kvm_gmem_release to pass the range
parameters to the filter helper to ensure invalidation accurately
targets the memory types present in the affected range.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 9f6eebfb68f6b..c9f155c2dc5c5 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -193,12 +193,24 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	return folio;
 }
 
-static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
+static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(
+		struct inode *inode, pgoff_t start, pgoff_t end)
 {
-	if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
-		return KVM_FILTER_SHARED;
+	struct gmem_inode *gi = GMEM_I(inode);
+	enum kvm_gfn_range_filter filter = 0;
+	void *entry;
+
+	lockdep_assert(mt_lock_is_held(&gi->attributes));
+
+	mt_for_each(&gi->attributes, entry, start, end - 1) {
+		filter |= (xa_to_value(entry) & KVM_MEMORY_ATTRIBUTE_PRIVATE) ?
+			  KVM_FILTER_PRIVATE : KVM_FILTER_SHARED;
+
+		if (filter == (KVM_FILTER_PRIVATE | KVM_FILTER_SHARED))
+			break;
+	}
 
-	return KVM_FILTER_PRIVATE;
+	return filter;
 }
 
 static void __kvm_gmem_invalidate_begin(struct gmem_file *f, pgoff_t start,
@@ -244,7 +256,7 @@ static void kvm_gmem_invalidate_begin(struct inode *inode, pgoff_t start,
 	enum kvm_gfn_range_filter attr_filter;
 	struct gmem_file *f;
 
-	attr_filter = kvm_gmem_get_invalidate_filter(inode);
+	attr_filter = kvm_gmem_get_invalidate_filter(inode, start, end);
 
 	kvm_gmem_for_each_file(f, inode)
 		__kvm_gmem_invalidate_begin(f, start, end, attr_filter);
@@ -367,6 +379,7 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
 static int kvm_gmem_release(struct inode *inode, struct file *file)
 {
 	struct gmem_file *f = file->private_data;
+	enum kvm_gfn_range_filter filter;
 	struct kvm_memory_slot *slot;
 	struct kvm *kvm = f->kvm;
 	unsigned long index;
@@ -398,8 +411,8 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
 	end = i_size_read(inode) >> PAGE_SHIFT;
-	__kvm_gmem_invalidate_begin(f, 0, end,
-				    kvm_gmem_get_invalidate_filter(inode));
+	filter = kvm_gmem_get_invalidate_filter(inode, 0, end);
+	__kvm_gmem_invalidate_begin(f, 0, end, filter);
 	__kvm_gmem_invalidate_end(f, 0, end);
 
 	list_del(&f->entry);

-- 
2.54.0.563.g4f69b47b94-goog



