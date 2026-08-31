Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65C7CC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:26:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD9726B00A4; Sun, 30 Aug 2026 20:25:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAE8C6B00A6; Sun, 30 Aug 2026 20:25:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADCB26B00A9; Sun, 30 Aug 2026 20:25:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C5B26B00A4
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F2D07A03B1
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:27 +0000 (UTC)
X-FDA: 85159670694.14.1948AA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 06B38100007
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rzXfk74h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135926;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hWbM3xs7Q9+b50wFqCnuVYCBjembtEcY1ugAt6eoCYA=;
	b=RjarWZ23OX3qUlcOi4k1+A/ic5w2z1F3i9HVL7SPjQwyAxYLET4RyM85nnAZFnwYQz9BLS
	n5Sg7BTpSSAd5VsA9lyRCtqfu0OR5ZmUHb9XLu7CgRPSDjq74PSv1EnK8Lku3qRMqtRRYe
	mKTxMD6rFNRMgJ8BnmQbGiql6L8I9eA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rzXfk74h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135926;
	b=vidiixukWCi+xLZAPsMlRZQmpMbpeIQAqAszHfzq16En6Nt9/AuxuU5mnteXpkdwaz7jcz
	2q1+iz+R+oVm9lacPdh02uy9uPzRPNkfHOKeNEQa7A9PIFF4HBbsTXSyxJwe5u9bjrnF+8
	tlxt1OeIDyrN0EqSjPH9j/hZzYG4vtY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 159D6447DA;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CBC2FC4AF64;
	Mon, 31 Aug 2026 00:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135920;
	bh=t9tIswHrdBmjog6KcGGiBEsXA8vzkM0vs3f9V0PMZDU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rzXfk74h/pMzdnZsp4qXd6RyV3Ok9XPvsQNi+4W/B+AzBGmJtInrcphLpd0g6YAq1
	 MefK2bo29SJYK0m/EdU2jnXDHtRQY0Ct6+sX/J5PDKkwKdlvGS8nwJ/XvMumBDz2yY
	 s8iH50Ut/GyIFv5JGSwQLs1rgIZ2pLnqs0gosHqJvBHeQYihecsV7NFcueJOPL3DSW
	 kvf0idjMt0kQUH30LHmpSj+zS/nMBs0xdTH+wMceqrmkEtC1e9qfp0PjHTpvoNFY1a
	 47vkJyTerD7QFCKS8eugNyamlzaiLAAld+Uy3su6+mnt79hnQxf5dFRRYlioNdxLdS
	 vH9mUl3WD2emA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2300C61DFD;
	Mon, 31 Aug 2026 00:25:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:14 -0700
Subject: [PATCH v12 13/45] KVM: guest_memfd: Pass mapping type filter to
 invalidation helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-13-85e5fd25252a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135915; l=2917;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ypeEDM+LfsQQ4QqwIgwW5NhyTvWeVmGP7oL9zB4ZTHc=;
 b=FpekWujCWkPT25P5EpG9jIkKIThptLZ8wxNDFM01ojRBI8RRpi94Rq41rKW7yMDZbiVZ8ew8A
 Bs4OUofPBSIBJTIvzAUjXDQsWuwD3ci2CM2wz2z6f5zwaW/gTMuvvM+
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: oqrkwcwucezqxxkrzexfyfwse19fguso
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 06B38100007
X-Rspam-User: 
X-HE-Tag: 1788135925-485912
X-HE-Meta: U2FsdGVkX1/KmdjO+++49RYPkxe47FnMNY7spcTIRtr+IhoIEN70zxOkhPocCxOHtC8JhBuP0CSS3lrXQqUiY5uuby8HkuI9/iXG7KBoNlUHc2d6y6S/SQXk2QSQRn0PrwlAqJ9UxjchuKWuqCPdrp2vXCRtaHjev1fvRyEAOx0R95F5aXFdLpur5stGHiF3UzVqpzzXAsB8bl8y4RF7UpTqUqpSG/Uvi6lK7WiAhrVA4b9hBImm6d++33klDxkEpWmc3BDRjcMI7g3fbcAAitoSDttlIb3I1wQgUQtxc/kQxX10Fw5N74weO43IuoFZc8E5jSMUPQo20H6siRs0NhAnZlLsMLPNV98kBhzsFRZewdHHmkwzjFqWkVKz9AAzfBhmKJHOC1FEW3B8L8SgcrfnU8eL4Pt2Wo8TuePruz7uu5zV0XzcMJJOJdWnQdzvrvA4GK3YcM5KovhbGEj+ZXVZ8u2ulUp1u5wxGyRrYstv9ea7e8jKvYcAukVuqX3dlnX1H5f7ZjUi+h9+/WaX+k4MqxUvyCm6arv09JOuJZ2x5BaTq+eF3s4GOsRJlGaJXb8lLjVwNPpe4jAzNlkA07z9uu78FuTyYjycGz+zQ0sj3sfAOnJhZITFpC/vkSjrEPL9LJehVgns0fQ/qZ5R3j2ovASt8bZ0Qj3W6GdYzUPvUDa9o5++jcbLIwylv42HgLccZfegOX81Ii0i4fg9kK9maJ51jNpYpcRQgWxbknLwGROjsLcDX6/PO/P26jx4K7VqSh9eubC61PB+uFbMx/H72ezvinmQ3p425uJ2lsT5AgY+Lehvh5F1ccCH3PyZsOoPK49gwDxlwUFoQmqHNSMOO73OC23cLZTPcwlzulZWkaAnFdSSSeENg3kh6sFmwMtokhcZwa8uKgNIRFvSTXdBEPz5yit+sxYa0hOCTwbQyvycCQOYxRCFnfZ4W07Um6WGXc7Ak5RewLMQxhW
 jZMKk5Dv
 pDZWfuJkOB6wcnAHbj4K3yhTtlIhmNDpuMiHqNUAH2rptXL3eAJvjtbh4tjQa8n/Fomo6MvNO6b89544+AIyQpfxSzKnKa7pAZzcr9M2II0vbthAQEWXdrMw228IcRupuApn3egyhlsJW55bjNtb0LRozObMwYLQS0DMofBoQD184VJqkUPgCO4Ep0AlGQEDMfcuPfvVsLvaDMw6EEWM6Y2xp/joAoVMWdkUJ6Gvbpmj0S4GsOmBvX25aLseln/XFkqBRwu5+2gjhgs2kLBwOT7dnk96lxFFnoZHB0FHNLxb7M9GZy4waO20eaORRWfIFbPZ/OmHspAFYEIbTw8FhBmRdUaqroVZxHaGTKy2zupgwiQ9RsMn4D90USk94xRBM8/UPUra+7/WURc8nfhHhXtCvkC8eDJfla28HKkJo+qgBrKPvoi2XkxYB7R3WQGb3rmwEr4LJ/54Op8V8QtzniUDdLBQpYj6B6YH8Fn6T0l3RMrj8jW/R+7ZCPaGSbi9dzhjhSrl21FGyB82/mipoH5rbw17uC8POtV54wVDeO+olNv0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Accept the mapping type filter as a parameter in the invalidation start
helper instead of querying it internally. This allows callers to specify
which mappings (shared, private, or both) should be invalidated.

In the next patch, the conversion process will use this new parameter to
invalidate mappings only when they're different from the target state of
the conversion, i.e. invalidate only shared mappings on a shared to private
conversion and not both.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index e41802944756b..e19de803149c2 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -192,13 +192,13 @@ static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
 }
 
 static void kvm_gmem_invalidate_start(struct inode *inode, pgoff_t start,
-				      pgoff_t end)
+				      pgoff_t end,
+				      enum kvm_gfn_range_filter filter)
 {
-	enum kvm_gfn_range_filter attr_filter = kvm_gmem_get_all_gfns_filter(inode);
 	struct gmem_file *f;
 
 	kvm_gmem_for_each_file(f, inode)
-		__kvm_gmem_invalidate_start(f, start, end, attr_filter);
+		__kvm_gmem_invalidate_start(f, start, end, filter);
 }
 
 static void __kvm_gmem_invalidate_end(struct gmem_file *f, pgoff_t start,
@@ -224,6 +224,7 @@ static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
 
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
+	enum kvm_gfn_range_filter filter = kvm_gmem_get_all_gfns_filter(inode);
 	pgoff_t start = offset >> PAGE_SHIFT;
 	pgoff_t end = (offset + len) >> PAGE_SHIFT;
 
@@ -233,7 +234,7 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	 */
 	filemap_invalidate_lock(inode->i_mapping);
 
-	kvm_gmem_invalidate_start(inode, start, end);
+	kvm_gmem_invalidate_start(inode, start, end, filter);
 
 	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
 
@@ -522,6 +523,8 @@ static int kvm_gmem_migrate_folio(struct address_space *mapping,
 
 static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *folio)
 {
+	struct inode *inode = mapping->host;
+	enum kvm_gfn_range_filter filter;
 	pgoff_t start, end;
 
 	filemap_invalidate_lock_shared(mapping);
@@ -529,7 +532,8 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
 	start = folio->index;
 	end = start + folio_nr_pages(folio);
 
-	kvm_gmem_invalidate_start(mapping->host, start, end);
+	filter = kvm_gmem_get_all_gfns_filter(inode);
+	kvm_gmem_invalidate_start(inode, start, end, filter);
 
 	/*
 	 * Do not truncate the range, what action is taken in response to the

-- 
2.55.0.897.gb25b4bd76c-goog



