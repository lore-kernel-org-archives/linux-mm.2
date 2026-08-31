Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D67DC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1AF96B00A5; Sun, 30 Aug 2026 20:25:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F17F6B00A6; Sun, 30 Aug 2026 20:25:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B96D6B00A7; Sun, 30 Aug 2026 20:25:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6D4896B00A5
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DCD791203DD
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:27 +0000 (UTC)
X-FDA: 85159670694.11.556F89A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D92C2A0002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m6tryz0T;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135926;
	b=enYpULaeBUJxgS34Nv16pdrHUPg5JBaK1fcOpy3dZHKkdofbnWOfG2uvX8O4YevfC9TfDG
	nBRwedXZRKnpvoclBKNIIKAVRQYQEdXMF9TXNNUAQDuJOJOWzijnt1eZavAYYCpLH3J28O
	4bQY2dHp4Y4nqwNbRCvM7+WerAIy/4E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135926;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1WSV3a89dyxPmKSVnlSgmxjMaeltjt8BLZBNmDuikto=;
	b=x/K02hJSe6DZVImHy3uzZK5UEgALdnP2402PmDUlvFZGv2K34fcQybL9fbZ6bWVgup9T8a
	Ko0zhZeSC+f3SouNb8iUyA80ixtSnDHwSfHK/tMDNnntj+fUygwtQgM6D/hpM/SWa3Fkrv
	Bi/UI8OU1+2K8l83kWDFDAlGBHWqIPg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m6tryz0T;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 05B1B447CF;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E0CBC2BCFB;
	Mon, 31 Aug 2026 00:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135920;
	bh=ARLoo7ngV37dIqzMdRwEWGmzq2H/OMebqzbn4gJysGk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=m6tryz0TLerL/U8q0Y/S0LHoxleFiVZ6yt/yqDLekeGijGtgzzWHkrSItk/+h2Zsg
	 VJI4TPBgaugYjroTn1o5ZztECLrSmfVKmbRZxvGSiI1hKENdxvhxIOfVjUDRHfHwvr
	 0/pjXsx5R6NYuECIxzcKHDJLD3iOJoDhelEs4z1WpSIOJdIIk+WEEVCWIDEofMpuAs
	 01UbLtikHAjMTfWhhzsNFrKDTFjKUUW0fKlMZz7MlgUumMOfIxirw3D6009dkDvzP3
	 GfrKq+9Y/91Hi/emf68/E7U91KLM9YXT5wL3mbzCYTe5Ivx2RhND5QDWCnZik5Ah0p
	 vmlqUuyJsNlew==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D57C61DE2;
	Mon, 31 Aug 2026 00:25:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:12 -0700
Subject: [PATCH v12 11/45] KVM: guest_memfd: Invalidate both SHARED and
 PRIVATE mappings for in-place conversions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-11-85e5fd25252a@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135915; l=3203;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=wwyziPople+SkEp/ySiFCSViS1Jnz5EzSDFKRRrvWlg=;
 b=Gg+nTA/eIzF8o4MMJR486GmGblCq886rCHl1mERVHrwwsNk5FGOc6c8F+wxYu3GEO7CBc7nRx
 W/TgAQ0rLwkD4vIstAaWR8LvwhpIyQJZK1xXuJYNgzO8xTgVvQ4sNkB
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D92C2A0002
X-Stat-Signature: jtfcfx6jwb1mgp5kw7qtn9rjfppnjb78
X-HE-Tag: 1788135925-305735
X-HE-Meta: U2FsdGVkX1/b100CF/8XlvHom9YpeLu60p+VEhflIY82wyI0OEpZx5fysWnFWzR3W2NQa1x2cA/4ybB8xeCpN2JqxaJnkhxZbcjvgEjWq5Objq5kNZa9YqB2ZFc6fdmpph1HXgxegpbgCqQbZoFM2bbfst0et3AC0+YCo88vCmHp8O0Y/LLVnHPUEQ1I/hZ0zXns9Rq8e2PNsq3aOMU4ihWTlEq5Hn9V7VPQa14nOP3PBGBwN6prxz+MIpbn0OLFSUHoOWMRcv8K5+BX3f8HyB1Pmbi1aIueE5zwzRt5H3vhb7V/cOSmcCS7+x+L+4CR36uga35FMjy7/ejd1pLia7JreRWciuxvzBDnXKrptQelarLRp2de4SMW/L3pz6mgesBgxjCgxks0KqqDCCrIoR1HNugyx+7Ov2kmHZ2epy/9VndGFP48+jlaEPGBQY8gpBz9MDmcPlKSo0Hqu8WoB0Pc4cAalEw8V/Hw5hSGneroL46i2xozHn2iIvEcJ84PKxRMknDf7P3QBM9/jzlIpZg6lBEcxFoZQEiP9gAevxych/LY2PuacFT0N1pu+ZTdGtQbSRiTABxNykHCt69CdWV1pdc8SXTFpi6dr644UOXUkQB7L8I7h8mpkz70rursSsW8It8Sd4E2ePfU96yVIe+UTejZ93i4OQMaszT8ZH7kZmJ5EJ0JZ1CYoamlVgXd/QyCWtx5IAFSaIR+FqzoJYdinHK2IWLA0J07QVRBFZZIvJKJt6tCMuTP0uSz9mgWMIGDG+5fANYSL+a6j+YS1lgfRfV01+9KlB15AahhlQs4iqWeirjQ13QU1mLNFAq6Epeb43Vzbo9emimXDcszSl/qnF81gvNnfsCssTEZ6c57E/j/xk0SYVSakMTIGcHIU5VJqeMVmpRQQPemxT5Ki/78euWTRAElDhYQ0GNSjsBn/aDJsL5D5RU8T0YWg4Nn6MEnUlHH68akLwGv1CT
 x0l31Gt6
 5FBirtGBIpWpI5njhv5a11QQvx1dlFVorC/1u9v98kFnN0K0ozwMn6p+TeNNd8g2M4iTSZMDDtljSjfAFhSLVscWkYE5BTmsisWPRkGCGyGdEmvOMcFCsbxgYVajxkpcP2VDeRB+NEvnsDgzvjFAei8yyMsDfSrJmBSTj9HxGBKDw2MEm2XJOOPT8oj5lzyRueDuVIesm8z+/tFr6WKiKLflMtLvZTyC3ZHR7sSoxqt9duNYhmJenW0SuzbYznm4F/dsX+Ieb88rIMj4W0KEZt7ElgR5lROfhVjnVorMjDaNLINpEct5W4+NzpYyldim4LH3ahwKYaAox1MQlIknjusKOu5Yg1wQkri7DMCYudC8fg6Ini5SAbyCBSr9yVcfxmIppO9d8DjSYqvDQfc9fsT5PgwE+vchChIyLY1JJBmPXsySI6qHtd/K+9nfEOjVy+0x0wSDoV0iuPeu9d1MTop0brTo3yWyelmAtqy8U/JaXBbjsxqYXIcK3ug==
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
2.55.0.897.gb25b4bd76c-goog



