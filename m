Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDCC0C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0B5A6B0095; Tue, 28 Jul 2026 20:35:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCDB36B009B; Tue, 28 Jul 2026 20:35:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1BE46B0095; Tue, 28 Jul 2026 20:35:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 707716B0093
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0ABC6A0558
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:12 +0000 (UTC)
X-FDA: 85039944864.01.1A32C84
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 23C69180009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GTWEhim2;
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285310;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DleNQfEB9cqX6wOcQVaZdgMjDWx2pn8iUAOJiWxtwCg=;
	b=GbySV4QlLg9QnEO3EUzj47RBNSHldBzZIxlKKUnhaTK6Sxs27ytrcb8iMgQFcCNdXLm2+H
	BonOwhdkvtw4mhVXYhCQcW4Ipj5il/CsTDeqPTxFdNr0VXKJbx/G53cjWeN+b4EztSa7Fn
	htW1M7oWTVKq/wI9a4rxbOb3NdQ5iL4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285310;
	b=tY9WOMJGw+tBgrhQ92jqf/j19vK4JyJf+DoQS2GuEu9zmxOvJJydF2hc2xoKQ4trOAUlw/
	aaaHARYLt8qss4mcZh3U/xtJiofcbmjojIpz+TlBk8CIE7OsLIIQjf1oYCzdK0Oh2EPp2V
	vFUrrBNzxKU17+/iXSoodwQmKmW0fy8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GTWEhim2;
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 42D2160A77;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6B35EC2BCFD;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285308;
	bh=oOvptBP1kHuIEZOwJBI+f8SsY42H4/nb1CUiPBPjfiM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=GTWEhim2ZPUMZKOpcfWm9nPkvIj9Apkbsfi5ujBvtSuKw4qvn25/tCQAI1zo2xPwp
	 Zjpng9fpKCpKaSF8G+8Tz4robVaW/u4UlKg5kT5jjE25GArarjDY/Iebs1Okr09XCJ
	 sKrsi8mlBP34uI5vv/SfVVgdshO8e6C38nCo9whcPT2Q+wN7kd1aRYGe1Se8kFVP4B
	 n7nKvs3QNIwsp4lL7OyYDP66kABVcZTHw2nnd6hfTLOMfSnKkGNzOR0t0tWc2OElhB
	 yawttVCnrPE6iszy7KpBIkmmfX2nT8kG1N4j4V/6VEHVQ8WJD6hIK/v2F9L2+bR5e1
	 4bKk/EdzumJkQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F99C54F57;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:08 -0700
Subject: [PATCH v9 09/41] KVM: guest_memfd: Filter both shared and private
 when invalidating
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-9-35f9aec2aed2@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=3366;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=hy3oHJbAlbd3BdtMu+ggtDgSC1hRpPwyOUDnMsmWhI8=;
 b=Q82EILOc2arJsnsAnSRPJO4h9y0lQ3EWf5Tl/BVR0nqhL6mlGH1/9/teLCdyyjNvKJz3STyPt
 rYqq89TUKPiBG9HLvTikFCdG/QvETOQkHS54Y1ScTEE4wjSJIkc2QoT
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: 23C69180009
X-Stat-Signature: kj7i8rh7efu1xyewywfqm5zgbaqcy75g
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785285310-312493
X-HE-Meta: U2FsdGVkX1/5J4GAwzvqQKr1EK8FcfE//l7c0BL3s0BrsozeAgmKoejsBtq1mPJl1NpnDu9t4Mg+AyRixGd8TuW48/d1hCyV3Lh9dXw+aKxiU9NM5ynJpWBE2WcCQ986ztr2ZJmK4rG3DM80iYw0/Q5TbmvQd9ahwI46J0RngJYXd+svOmJLZ4VycJnhE19BfyI5ij7KeQyjicVr8zsy863wrAPXtdb7ObUYQ9bUqdfunOdKaTmyLLACr1fMItm5n2XtecK/x/n+K5MjJ0NgFJIl22CFFg8L3ui2rnxZH+0yxdRR4iLiY7P/AlIxkZ1KRPtghHqTcNXsVDRAxPyDI6oxqe1gLSDjjdgDt2iXbxGstHeypJpw9o5mXNQXoTmzxbD9ihXYC/IkEVpKw5lAEN0e+Yw9EMhuUTtdJDlUyPWMYLjlM7cSMbDbRs1MuYilhAAnuoF4R/wnfIhKVERWY0a5mnALX22ohjmME7zJ6PSjTKzLriUwjRnn/AvESipQtGBJfq8rPH0xLfyDsex+LvcduMn3y9OKyC6wFyteAEZ63rIhHVw2kfYhS9kbpimlB854AvRs6DP1yeFsIul4X0vuSMneqTvENpvkN4KjNSnPOPNZXBmZo8YMSpq2u0z4JhFVjoJ29Bm+NsNoHOFdM5TquWDrazhuAW7XxX0pndIuFARPG6l+IH+bVKZnYxTQJWfx1rwrvNvPkWxfaCYRXLpDBYq9h4lnjEV1d7mgGscfo1IcvZn6lfROBVsgTuFtshCmtDp4n78nGH9sT8cN9EgHZVIhRlCY5Vjrm7cuHo33XDDUDjiuLbyPpPfNzBlEiOGBBIvag6EQ+d+xYpBMw/oshE42IPwB2tIPoF5GqVhLTrXwI7/nThBGQ1YY9cqPkfsvV/q6sAkuKv7h08gbSLD7JjnmL6+3XgATnTRyt2NxpgjAR+JcR1DMGYD1ROfhcYev4gbFF7FV5+yKvrA
 DN7pweEN
 8ICdMZ+dIIgKUATdn0jmyeL3/jkPC5cwRJv/4cwD5OGVquGUPZOpMDqjN3h95+CqsIqjhRZCA0y4QM/l+YlZhjYx4M3vh+OpkCmuEerkiOLPQGkoRApckzCkMENW+r3KhMFMesn7L0tI+YASkkCE2NHYl7XutynjP2MV4ca83pRDykNCAC19D1i+lWAci6MMJo0AXySgcadd5orU6ZoQqj9gMU/8VFa8bWSAEStiD567vp4MrZb+7wFrWtE2BDTIZ2xAFdxH/ET85g4h5fAb1pW9coXHu6QWlc8+FHLaHmBkFac7idKCcVRHQdxhTNzmuLwnJkXIAPEZn/YGssj897RMoOzWsZkA3bWSW3i7M80t1+7y5sKsfvLpT84CJqKSK2cQiMAmbsODMasJ6xOiOv8Ws9WIyFbBnSdynDxCCDcO1X1nY7RfpVqFfI8kSGxxQE65CxHCCJIvC3AYYmSEIiVETFSrPthNVpg7E5uGTClwAzq3z4sOLWwREXalxMro1dvnhgNxIsQPEtZ2JFaLAy+SV/tOpOkUOwqmK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Before conversion, a guest_memfd could be either all shared, or all
private, configured at creation time using the INIT_SHARED flag. Hence,
when zapping pages from stage 2 page tables, guest_memfd can filter which
to zap based on the initial shared/private state.

With conversion, guest_memfd tracks shared/private state on a per-page
level, so a range can contain both private and shared pages. Zap both
private and shared pages for simplicity.

An alternative would be to iterate guest_memfd attributes and only zap both
if shared and private pages exist within the range. Setting both the shared
and private filters lets the zapping logic do that iteration instead.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 89cf922232920..6cbd96e2a99d3 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -135,14 +135,6 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	return folio;
 }
 
-static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
-{
-	if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
-		return KVM_FILTER_SHARED;
-
-	return KVM_FILTER_PRIVATE;
-}
-
 static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
 					pgoff_t end,
 					enum kvm_gfn_range_filter attr_filter)
@@ -185,15 +177,13 @@ static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
 }
 
 static void kvm_gmem_invalidate_start(struct inode *inode, pgoff_t start,
-				      pgoff_t end)
+				      pgoff_t end,
+				      enum kvm_gfn_range_filter filter)
 {
-	enum kvm_gfn_range_filter attr_filter;
 	struct gmem_file *f;
 
-	attr_filter = kvm_gmem_get_invalidate_filter(inode);
-
 	kvm_gmem_for_each_file(f, inode)
-		__kvm_gmem_invalidate_start(f, start, end, attr_filter);
+		__kvm_gmem_invalidate_start(f, start, end, filter);
 }
 
 static void __kvm_gmem_invalidate_end(struct gmem_file *f, pgoff_t start,
@@ -228,7 +218,8 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	 */
 	filemap_invalidate_lock(inode->i_mapping);
 
-	kvm_gmem_invalidate_start(inode, start, end);
+	kvm_gmem_invalidate_start(inode, start, end,
+				  KVM_FILTER_SHARED | KVM_FILTER_PRIVATE);
 
 	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
 
@@ -343,7 +334,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
 	__kvm_gmem_invalidate_start(f, 0, -1ul,
-				    kvm_gmem_get_invalidate_filter(inode));
+				    KVM_FILTER_SHARED | KVM_FILTER_PRIVATE);
 	__kvm_gmem_invalidate_end(f, 0, -1ul);
 
 	list_del(&f->entry);
@@ -530,7 +521,8 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
 	start = folio->index;
 	end = start + folio_nr_pages(folio);
 
-	kvm_gmem_invalidate_start(mapping->host, start, end);
+	kvm_gmem_invalidate_start(mapping->host, start, end,
+				  KVM_FILTER_SHARED | KVM_FILTER_PRIVATE);
 
 	/*
 	 * Do not truncate the range, what action is taken in response to the

-- 
2.55.0.508.g3f0d502094-goog



