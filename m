Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59781FF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:33:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C21966B00F6; Tue, 28 Apr 2026 19:33:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF83C6B00FA; Tue, 28 Apr 2026 19:33:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B35B46B00FB; Tue, 28 Apr 2026 19:33:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A6F836B00F6
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:33:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C621541114
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:28 +0000 (UTC)
X-FDA: 84709548336.11.5453329
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8D895100011
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gt0OTQq2;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418726;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kvdn3cULHTXBoAZ1kudqOqpWjtAxQhRykDivcX0WpQU=;
	b=H2qinBtiq/7mUzbuO6wuLNpvDU+iWlqR0YzM5G5rq3G2OzXbVB8ZXErQX91UrFIEisnlRw
	iRnAHnS+NTf56/9W2WXGC6A6B6PoMPPnxxn/5Q1tCPPk58Opfw4kgYXAwtAJg517geBFln
	aYuXFUt95djdYKLutUsXPxo290pJO9k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gt0OTQq2;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418726; a=rsa-sha256;
	cv=none;
	b=d6uoPByHcXUTXsn11viO46nFwgKXWTb+qdqGUUyAnJMiBvqbHI3gXjFavIJjEBvMRl6E55
	ReIdnIoaUykqQDoPYA0a2iSmSpQBQg0k5wJqQUHa27Axgea2OscymuO81jb5EsiFbmMpdr
	YavUVSOw/L5uvy6MZKXsvwhcLoxWjsU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C2C6D449D9;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87F53C2BCC7;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418718;
	bh=pnzJsSOdQ2ZKpf+yB2E9JY952czQ9HO2EsQs+cwWkSM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=gt0OTQq2PVfMjCGZ7b46e19ZN8f2WG6JX+4v1Itr92agtRpaD7mm1R5ZFRQzW2PDk
	 t1rp6nxNsK99HQE4ZpGq/hJLkM9wyIJNM/+XswEWUi1QJtFmK3HJpHzgX6CvoRTmUh
	 y3FYzIuSaaNxV3eJ8VUebU9Os5b/VEjQUylrVnTzVN2B2MYSXASICyy9dCI1XmT7uk
	 K34dykLI8MXbtMCQY1xFL0R1MGCSfh/jqlpuugyuD1ggWco0PsRBSzO/loYRndaaiS
	 J4gL1H4XUgNSY/DwFwKd0ddegjRgiV9dY/470EaG8mSEI8HJNWnIlEAtwNfsXF0mQD
	 xLXW+8JQhuRRw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D967FF887E;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:12 -0700
Subject: [PATCH RFC v5 17/53] KVM: guest_memfd: Determine invalidation
 filter from memory attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-17-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=3498;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=rTbN5ompOLk/ZM+5Duak/FZnd2bH0M3Khx+/Wu0/ecI=;
 b=jwLlCIM76PVRy74xhSINNK9Fe1Gutkg13fkABnTajm9j32KOHvBXPseR/nyk0iXTwD6iNKArG
 Z7SowX0SxpdBl5ecYYavp5YgGIN4Z8bbR2+vwATRdLwTvw3pj01u7lb
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D895100011
X-Rspamd-Server: rspam06
X-Stat-Signature: rekxu5imaodecybfw13ymmcmej4a6qbc
X-HE-Tag: 1777418726-127159
X-HE-Meta: U2FsdGVkX19yAQhfeKFeu/wZl2zP6N449V1AJs1ypn4gxSQgn6BPfUy34/wJxYnyZiCL4skfAG0K0XOiW3osGJl9iPZvO2p1mZqqGm0cEjvQueDU2mpmOROZPzWh23SYTKBp1ZKMK5LhmJJ+Iz4/QEwDU5kXK5uGa+FdJqDWmtsLIicVmikQzJWDWrTQ0CYoLUxPR+7eSCd665NZpyaSPvVasrRB0R5roZMoaw3rNEnzhICQbqignz5oSRrTBAFmJV1Qr+1cCiqioU1pXo78zG70dm3ijeNZ2NwKH8o9zYhv2+9x7JTr8utdkrXJHMj0k/N9ds2cvLgEUUOhNs3Jfr3BMYhYR0KdAc1xbvdYzmXHfe9lXC/CpQUeiDM7mkXO6L9zkXwfarrgn/wrXdUCfAGqsr0afyHg+i4CGlaukJrh93aosHK72A76J36SpCo+gG4ojAI2gRfe3kPadJ7yLj9sgYQnUKhrOVQ7MufR+9w+kncQAv6ijbxc7OrzMXG1dIVuNrWqERCJzPkfYgqxTmtm4RR8lumC1HildttCDP36PjSw/P+5aWrH986Od5aKfHpR7gRBrUEgOaIHPQMb8eNRjp/pm2RksVr/42dHw2dka27c3T4ABxegJ2CWYgR+1fzOzSrP7vDnhr2YDo0f2IB2rv7lceH2RJuhbON72H9EOLcp7JV6/eaErJMfcVTxJc93Gfn209U93LMazBQQj5s5JfK+6WGRRBbgUXd3wdR+QtqdM6+fHnsaaorQ6bJBXSnpAe7+jQpzulOANHyqgiUHMYt9FJpcDRMTzP7XgBHaeQrw+8ShKz4MiVRmRtT2cFpmt8tdifkm+/KID/02NPp6OJ0exZ9TgGhGJsCNwl4SyNHdpkoNsGuFS/M4UNv7nZ33VwJniWn8JFOWxPmq6PKXm/oB5+zvVgk0xBj8ynN0PfF9A2lUjRnx1Vpb5z2GgBcIMKFbFqVIfvMbu/K
 K7fxmKto
 pqOGXKtQ3TKE+YdYToLB+3OFPh0Ai4u4IEFE47OrODDVFn2A+BjoDwI5ygfzMRRj1Nq9iFD50/DuXP/Hu7ptjKj5/Otp00zCRhycOyVc6tSzKQ4dAyNDDqe0c9oVELfR/kHdYF7p2wZcw9cTMfukwwKb8DPfp6KPvS6nIE6oYIDjs0XwlgNRtEFsQkDdRL/lu6mNs8m/Rl5rnouUAI7C/tVQcQ1RsHi6gkSDttVk5MgmBseBeojY3EQGtrl79g91j3tpXazFN1Lh9bvB/W+WvH1HszynkEgL4j15bpnYB2KOr8V6IInnCoaoAHYLbWMfIEXoOjX0zMvigUM1mhtuzu7X+76qI9rI9E625TAr/l/pFiJBrDP5jFcPg/WY2Vs9Ev/HkORGN9Rch3X7yF6oLOiW7rnM+IWladI5a0gxKcCZRYQ9Y/z22Tbq/hy1Klv1rcHoDd15Gytw6MC4+NMdBHZSF5g==
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
index a8a5e37c982a4..85e8b3a981307 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -199,12 +199,24 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
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
@@ -250,7 +262,7 @@ static void kvm_gmem_invalidate_begin(struct inode *inode, pgoff_t start,
 	enum kvm_gfn_range_filter attr_filter;
 	struct gmem_file *f;
 
-	attr_filter = kvm_gmem_get_invalidate_filter(inode);
+	attr_filter = kvm_gmem_get_invalidate_filter(inode, start, end);
 
 	kvm_gmem_for_each_file(f, inode)
 		__kvm_gmem_invalidate_begin(f, start, end, attr_filter);
@@ -373,6 +385,7 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
 static int kvm_gmem_release(struct inode *inode, struct file *file)
 {
 	struct gmem_file *f = file->private_data;
+	enum kvm_gfn_range_filter filter;
 	struct kvm_memory_slot *slot;
 	struct kvm *kvm = f->kvm;
 	unsigned long index;
@@ -404,8 +417,8 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
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
2.54.0.545.g6539524ca2-goog



