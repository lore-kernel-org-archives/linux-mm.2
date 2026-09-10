Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C67B3C88E4A
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63A2D6B00B7; Thu, 10 Sep 2026 19:55:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CAE36B00B8; Thu, 10 Sep 2026 19:55:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48B1B6B00B9; Thu, 10 Sep 2026 19:55:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0456D6B00B8
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69F7180486
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:44 +0000 (UTC)
X-FDA: 85199512608.12.79E86B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 58CFB100003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dz8xeGUU;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084542;
	b=nZYD4tYWYKQpE5X9rFksUjVjtP6v5oAVIBhx4TvOFevx5+02xtSOb7LPkyBb0JW1no/EER
	Rk8Y1m3NGQBujV/DISDNy0uY3b3zTXFSNp23f8BYKh4/x8vTIkNhq149GEFDuJuL+5tLlK
	Cp8T3N1GD3hy9JMD55BPqBlFOqIp++0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dz8xeGUU;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084542;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PWJ5FSRLjny06RS6Fx9x+po1zYJjRQo9aRBCes9sLGA=;
	b=o0iX9ZhciinaPDYKCXF+Km+p0I4wMhJxzWTb02ULsG2+tH1OsaOCN2VuQCSFfM8x8eeOqB
	o7Czvu+YXpeGE8GqeZbqBm9ARGH8was3p4CbvNWw+80qZuB+YWfkLJIzJWw9LV8TumTwUh
	ibosdFGvVFq5hZvUjddsqHyvF3ee8Rs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E0A5944847;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A90A7C2BCFF;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084537;
	bh=KUBsQTo36fuCt/jGb5YG5pvEmZ+aAEdCICVP7x2jb88=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Dz8xeGUUqGNBhY3oHE1gu01VZTYjbgaFPYUwUGgAXxt60RgHFHFHUkVNStZ6RlpBb
	 cJvQ/PNXWjUJcC3O9W8U3xqzuDm6vLOlAU6fdJZva1XEvxF1+4oxgeVHHbZCXY006S
	 5Sz9FHfU/c2RJDtmUga3gYM09afJqxKq2RsgdVAf+z8sNcQUJdJK4ms9/VnnpMZzjA
	 QdgvLWcSzmRRmPxEEat/qOEWCWOCN4y/VC2kXDP/O+AxGYEOFVWpKAYHm6YrLuZSd2
	 0UpZqeX7Nxi5ckkZmnO/gHbk3A/NaB0w/zrNNd+ZzTrEHE1mLp57/QfQOo1JaQVlRj
	 TKIp97xBZqA9g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90D32C88E49;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:37 -0700
Subject: [PATCH v13 11/44] KVM: guest_memfd: Invalidate both SHARED and
 PRIVATE mappings for in-place conversions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-11-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
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
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Fuad Tabba <fuad.tabba@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=3361;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=8XBuEaMzd5Pgtxpe1iKALrGHa+WpduQOVXw3IpwatY8=;
 b=JspU4B/21XYMJZpKuh4/ln46bY/BV6ixGGYrYBAkqCIgIRllZOaF54ndFKGa/TG+hWLxs6bsc
 nqmxWYHdQDGBt5NwNUjFGfg/7vNQGSadqGuHNKUSlbQjDwYg0/OTKpJ
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 58CFB100003
X-Stat-Signature: y6xpwxkdaciwobr39abyqoxytjmr7k3n
X-HE-Tag: 1789084542-433834
X-HE-Meta: U2FsdGVkX19cnX/HqatV+Ll2cK8jdW9tZ/Dxv53vtfrGunUVuU/3HvGE5JE1UdFZ+uaCIAL63jLStfKkXfRrxUEsV3UJKzhKCu3pmwJr/FsC4wgeN49bF+BvoNUvMqNVv1UR7X9anNyOtFk0W69Kc1fgkdYD8c89O9kVv4Dy+d2ywmEt2UfuS6wQcdh0GzntbTJEDdPGvfKJp1jS8jhAUFv7PmUtegq1W86qUGRkE54gzR6E4HGkewKRxoJYYHcO+/wRiphzpwXOq+LaTecIF7QLY2kct7x7TiyTE55yPuEEI0XYeg+gisC0y03REyIHlMl9jXVRdf3jwd84c+VOZqwRyONT3rz0cyzt0V+55Q4S3YPCnTuzbygViZJf+xM8YqzAzlzjUoqH6+McBLoO0O6LpUg9b8YwhgQRs6sRmbVOSns//JXEWsC4nrBe/mCt+PbPv5gimuAN53bX9jHLLUjrVCyTmoqbfba5ftbmTCz52Xpm4clrS+5viRyAlT4JoH7d5qn97IzeSxYAg6gNDMT4ZZGk96/ghGB2124IO76uoiRvcx/tfkcVkgeZHPyh29tdF7R5HA6wu/oXPbl+KPQnstSXxygyKWOKMo0nq23L07GMUaMGRduqM1rwXl4qE4RC1XrbpBbrSl9h48KyZHEdWFw9mSVyf/6v0iZes1tEsTh+4ypt2bSlhZBbDPrerxB/c78haVZXA76Y5jsGPsnfbIa5ZLS/uzJt4v9vE3KL0NjqRizFIxTgNbUKfKRH6052AbmDzwwB+NbSX9GMTx8266rN0mCyXd5a0q8cgZTIUR7fEqg8PPlu3YEJkAysN3eKW9X+iL37z4LQMIukAopLzTil+Q6Z8hwE98XiKi3EuRR1AD0HaCVKSl1VO0pLjpWs5HiA2Gd+0SVX3EvAtvasUMTt7irFk3e5DNOoQdRZG0iFv66XtNxsLRwB0KKHGr9y+6ivxVANFS9QJw7
 icSMZFvr
 5XAjR9DDx4igc57VbHvh0gKwpcHUbxADE1L99zccgJXNDe4D2TNW1Ms1fIbWMSyJm4wyEbyYa/8DmOSgwHQB3KA9kNWXZL4hbuzGM/N8i2Jhl7qquw3MKmgZnlWOQ8dBWSy9GoKaZJdp4mBc14aC+4zYj60vHuVuVc3IhDoojX4iPRws6NsGQm1DQW/92grBxNzfs0v4wnxPEQX/GnUxLcmEk28NntkBH2qT0Qo6MwHtTq++wuszrshBacShojDDzoKRsIux58DDOQfmExlcSkn4Coqq+qkT9M9I6EJSdcVRwi1FPyTFl2ZQAaXtUk2tb3agc4ASlEzJbSuTze0zcDzFmHH4Ye+mGUOxv9fqiN3hC1AO62bUj0Ks+S3qaxYGrZTQCc0qcXplONXH3KP/86z8WAwbJzpbgIsSijs/CB0SN0wsMg9pqKTgVdKsziN5nyX23SPsM0+GDYEdU0XRszxLcGjjEms+KJw3k3kNf6KJrZugvHqFvMRR2Cc7mJVkIioaD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

When removing one or more folios from a guest_memfd instance, invalidate
both SHARED and PRIVATE mappings if in-place conversion is enabled, because
stating the obvious, KVM needs to ensure that all mappings to the folio(s)
are dropped.

Opportunistically rename the helper to capture that it returns a filter for
all gfns in anticipation of zapping only the previous mapping types on
conversion.  I.e. when doing in-place conversion to PRIVATE, only SHARED
mappings need to be zapped (ignoring that KVM would ideally not invalidate
ranges whose attributes aren't changing in the first place).

Note, precisely zapping only the possible mapping types when in-place
conversion is disabled is important for functional correctness, not just
for performance.  Specifically, if KVM zaps both when SHARED vs. PRIVATE is
tracked per-VM, then a PUNCH_HOLE operation on a PRIVATE guest_memfd will
incorrectly zap SHARED mappings that have nothing to do with that gmem
instance (because they're mapped via a VMA, not a gmem fd).

The incorrect over-zapping of SHARED memory that doesn't belong to the gmem
fd requesting the zapping will be resolved in a later patch, where, if
in-place conversion is enabled, KVM will use both shared and private memory
from the guest_memfd. If both shared and private memory are from the
guest_memfd, invalidation will only zap memory belonging to the given gmem
instance.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 virt/kvm/guest_memfd.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index cd966eef45b69..0afe1468d2d9d 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -139,8 +139,11 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	return folio;
 }
 
-static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
+static enum kvm_gfn_range_filter kvm_gmem_get_all_gfns_filter(struct inode *inode)
 {
+	if (gmem_in_place_conversion)
+		return KVM_FILTER_SHARED | KVM_FILTER_PRIVATE;
+
 	if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
 		return KVM_FILTER_SHARED;
 
@@ -191,11 +194,9 @@ static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
 static void kvm_gmem_invalidate_start(struct inode *inode, pgoff_t start,
 				      pgoff_t end)
 {
-	enum kvm_gfn_range_filter attr_filter;
+	enum kvm_gfn_range_filter attr_filter = kvm_gmem_get_all_gfns_filter(inode);
 	struct gmem_file *f;
 
-	attr_filter = kvm_gmem_get_invalidate_filter(inode);
-
 	kvm_gmem_for_each_file(f, inode)
 		__kvm_gmem_invalidate_start(f, start, end, attr_filter);
 }
@@ -347,7 +348,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
 	__kvm_gmem_invalidate_start(f, 0, -1ul,
-				    kvm_gmem_get_invalidate_filter(inode));
+				    kvm_gmem_get_all_gfns_filter(inode));
 	__kvm_gmem_invalidate_end(f, 0, -1ul);
 
 	list_del(&f->entry);

-- 
2.55.0.1007.g17ff1f9808-goog



