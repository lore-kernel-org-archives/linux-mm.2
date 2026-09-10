Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA3A0C88E4A
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:56:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E05016B00C1; Thu, 10 Sep 2026 19:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB4EB6B00C2; Thu, 10 Sep 2026 19:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBDAA6B00C3; Thu, 10 Sep 2026 19:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 875F16B00C1
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5C130A06E9
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:47 +0000 (UTC)
X-FDA: 85199512734.14.45C23FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4B97C1C0003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="SVnW4/t1";
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084545;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VgyGLBLh+MOLHJBa8MRGivgMNMqzQyiUtHK2p9pdAxg=;
	b=tgHD87CYkcDD+NXX2gTsuOruTGW+nBpCBqITnydFVuDi7rjKjJ2ppIYyNhXqGwF0yJWLqZ
	mNwulRqZ3jF+jpzLZOuLAYIXhObXf85rN6aUpXHlZZ+tKF1rTs0VJwbHSHiHsLmswbCthL
	8JkvQ90STk9BLm+r/RODh2Kn79K6eGY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084545;
	b=BQRkdgnZUHqVckgqbUEw1IC9oBsvoBKIYUclNkAwSe7u+U1Eojg77CGz7JcGy54J+rWssw
	WadFOfOaPRd4sKT9gEJyrFVAE5/DwKEvvg0sZGE8D4i9Gk7M+glbqVgGzAAcl9T2ldSpK7
	y8PIcjCziW1sckNbECPxGCK1deBOQtM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="SVnW4/t1";
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C60D443ADC;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9691EC4AF0E;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084538;
	bh=07bg5wm9NPNH7Z9soHiasshjg1qxD93bsnT0TJcLFMk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=SVnW4/t1M49n0g8qFLprlrsNELL3XQb4W/oGQl8WMA271551pDJF9/OHB9OzH3T1A
	 wHIzzssf7V1ytp/5Jc+J+TN655MQlBTSxqcVyckcLVR1Gm5BhBdbxK6EOcCVWH7li5
	 oqgG4TMMO5QMfMw2Fg3fobfjinZgQhnv8zjKelSZDzuSBFhsPNUOSu6zuX61++eUGc
	 yQzBkOaYpai9r5PUULiG45+uIa4CCQE5OWiY0G27TDcQTYSUW9L9smOjcdhD7U4pU+
	 D55V0xISBLFr54G7DXCACk6jgiDpAQuwyPORJu5sxX8CWZM0lqE8UksM1xGaSjjrln
	 SXyGCyzqzIxmw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E60C88E41;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:44 -0700
Subject: [PATCH v13 18/44] KVM: guest_memfd: Zero page while getting pfn
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-18-dd6fbf94f4e1@google.com>
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
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=3086;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=UTds+uB88Pvv734MhYhg7cYOppWN0b7k4dN51AkvmNs=;
 b=cDtkvlZKqZf70bHLRjVFDSDzjoD3T8abnkfI3UpEMGEsChfY+iEpuyTNsIWJynXQQecW6gr7L
 qnjf/0Jpoo2AAK1FvM7Q2CWmfckf5/qlvGdaoEbZl3dy6+KWRRKsqKA
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: jgi9ofqfukgjprxrxf1gg68ez1gj7z49
X-Rspamd-Queue-Id: 4B97C1C0003
X-HE-Tag: 1789084545-28582
X-HE-Meta: U2FsdGVkX1+hAxfUDPKzKDVzzSpbu2oxIUNLB1zyQqa5YFHL4pAnhCusWYx/fsb0F9JgaCVXictKO5veihD983+z9hO90dqOjTaT0gZpFRh4UZoebHMMErvlSL/L3o5aiia7AO8nC2G4e1IBHqVgVqywnFwZ0imyhFGaxp9cR/FMJOh77vc/DBnYyl03lCqZCtusny0VeYnstm7Hk70+YflDMdfveLBCvHZ+sKq7D7Pu0zR5xBOeQVtuEgdfUnzoFqVdDH4VDXYgLNuZOXn1BzeG9CyKd7HAMDfulh4dXOD2csPmtRdgg4vBob+0OyAi3Pyg+4j68q8M10flfnXJ86kK14oAVhuK1MhlA2SkSWfuZ5ha+ihzUcjC3buVSgg0N0ngx5942k7Q08m81Y0CQrIlSCQyYS1+GK3r/ISJ2SMeKKRwpmcht34cgnQel/SCVuZWEVhhVp0CRk8dTecQRtN9z6fKntgrcuVFbwuIPVpgXVF8Cebc+WO2PBbtLgsxgJ5LiwoUhZoI7bZnzDRYY3N41QQYcZp0m97f5do4Nb2dLHvLBaG46GstzDVmqdN/pjQroiuSKp1Lw8I2t6DzgyVtjQID2tB9VjjeyztWAm29Ki8YbIfZ7uyPtic9EkfTy4vVVIVD08vEAN81HnV4C3Y1ZMZeGvR/Hqs5TrSEXg4zUowOfpqTab4U7kBffls+j9i4UQ1yXdksaWB+qnOcFTFC45hZBHmcHayA2Jewj0YKvOOCk9PQ7PWjb0Gbb7yj3LF+jkNVxMUnoVWq+/K4N49RuGwcbbLsJ0V+s96ORfDFG+ptRmnJgC3StIUkEH1LgP6l4ZFs+oo32w8d4ClVS4/YawPn6dz+QhvZGNSq2punsMnE98e/p/XP2x4cVFfN//Sb4Sohte4zk918P9Sl5i8kNLramHuMXmE3GxJWI6AgOCKkwFJFLcjeOXAmKdnJcmTIEXMustBanbqv8Bd
 ODEwqPMU
 EnJ5bCzh68aNchzgH5VH8q/AqjHhgyNKtSGi6e+37NC9nsCv7v5WVpYS8BtNfTjax7mZdw+/ULG40XAwkvDMfhDC47uQfY5+Lbr0tJygCgr3xr0O7EpdLVYyS9kx3PEpt+ZU/NIFRONYSbKGqR94ic1ozmNv3UsG7gr0RNBTUm4fUlXW1Ujkos+7ctgdYeo/9n6XGWrWovyMKfrh62ccPPokzojaG4IcTkHwGOHmpcqU4fqycAEn1tfXM2J+Yu21S6qWoeN7dPoo6T+tdKv8rRmORi1wZ3ZO4xgFMnK7i0NmRtMPA4w9JtFAFpTGPTP7O9OFPPyb8fzTF3OKlrt71dnd0oD+5h3DZhRkVSA0BXlHyNuvv4cBhQyl4h8kWwPbFMkE2CxtELmoCWWPly+QXNaf71u189eJGrxaMOPp0rFlKAuOFpXUwgVbMzYhsAr5CLPeiuhH49kcZkc5mhrnHy2HRQeJvxMi88OQ7eFYAYDRFZPaPm+HbaRkhqkMH54gXlpLEwa6wd7zjJwi5sgq1ErycSG8is7qkTeKV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Move the folio initialization logic from kvm_gmem_get_pfn() into
__kvm_gmem_get_pfn() to also zero pages if the page is to be used in
kvm_gmem_populate().

With in-place conversion, the existing data in a guest_memfd page can be
populated into guest memory through platform-specific ioctls.

Without first zeroing the page obtained using __kvm_gmem_get_pfn(), it
might contain uninitialized host memory, which would leak to the guest if
the populate completes.

guest_memfd pages are zeroed at most once in the page's entire lifetime
with guest_memfd, and that is tracked using the uptodate flag.

Zeroing the page in __kvm_gmem_get_pfn() is chosen over zeroing in
kvm_gmem_get_folio() since other flows, such as a future write() syscall,
can get a page, write to the page and then set page uptodate without
zeroing.

There may be some performance penalty due to redundant zeroing, but this
would pale in comparison to the cost of actually assigning the page to the
VM.

This aligns with the concept of zeroing before first use - the other place
where zeroing happens is in kvm_gmem_fault_user_mapping().

On populate failure, the page is not re-zeroed, since on SNP, if firmware
rejects a CPUID page, the expected CPUID values provided by firmware are
returned to userspace via page contents. More generally, page contents may
be modified on populate failure.

Don't mark the page uptodate again after populating, since the page would
already be marked uptodate before the post_populate() call.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 virt/kvm/guest_memfd.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index f1c36e99cd3ce..5bbf9a5306c66 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1104,6 +1104,11 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 		return ERR_PTR(-EHWPOISON);
 	}
 
+	if (!folio_test_uptodate(folio)) {
+		clear_highpage(folio_page(folio, 0));
+		folio_mark_uptodate(folio);
+	}
+
 	*pfn = folio_file_pfn(folio, index);
 	if (max_order)
 		*max_order = 0;
@@ -1132,11 +1137,6 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		goto out;
 	}
 
-	if (!folio_test_uptodate(folio)) {
-		clear_highpage(folio_page(folio, 0));
-		folio_mark_uptodate(folio);
-	}
-
 	if (kvm_arch_has_gmem_convert() &&
 	    kvm_gmem_is_private_mem(file_inode(file), index))
 		r = kvm_arch_gmem_make_private(kvm, gfn, *pfn,
@@ -1178,8 +1178,6 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 	}
 
 	ret = post_populate(kvm, gfn, pfn, src_page, opaque);
-	if (!ret)
-		folio_mark_uptodate(folio);
 
 out_put_folio:
 	folio_put(folio);

-- 
2.55.0.1007.g17ff1f9808-goog



