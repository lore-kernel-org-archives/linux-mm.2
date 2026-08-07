Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB3DCC5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2016A6B00C9; Fri,  7 Aug 2026 17:52:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D9FC6B00C8; Fri,  7 Aug 2026 17:52:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 052AF6B00CB; Fri,  7 Aug 2026 17:52:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5EF66B00C8
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:52:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A4B6B401B7
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:57 +0000 (UTC)
X-FDA: 85075823994.24.DD87914
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id B9AFC1C0007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L3e89q+G;
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139575;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/4U2H/xOhK+4KAf+C2Ujx1omTtbudAs8zmvsB8IDmcE=;
	b=GUBffPkCG8BkDrSWWNnXhl4RqQbefK+u0/MNpqKINhEFjjfPWnYZ1LLEzRMwumyE0XxRlc
	6QngZnwbnNdU71GC4yhmvWQ0i+Lj6zWVKVOJqvUsJnA/4cxyZMR2dr31zcA5sYzYaX9sA3
	JypHW7AZCeM33u61okgyRp73FvAmPwE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139575;
	b=cwxpqYmfVEO6h7fhRn9ZBuoZcFl4sWCwLgBZt4fcA9oLBW9ydhSiuO9KvQLOvKr0LbUomA
	V2eEAfqGUreV2m7rNGc5fd0bgGTsFl2BHsyiSfZ1FHNzzFxC+f9terNNG/SmjCiOH1dwoK
	nrrYSfu3u4o4SFoMKvnO3MkiS+E5QlM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L3e89q+G;
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BB9C44033;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 430C8C4AF10;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139569;
	bh=vlMdPByiTSwzUUCngQu0R7QT3mZcq70VQdRClRIO7xE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=L3e89q+GDFleJcGjL5VMnUKlaKh0Pmh4Xd8lok7xboM5efF5etd6xaXQElHVXzPIv
	 36lXYFvxbo8VSx+gsfu5OxDzPfdCri1aArnTBAc3S6Ay0JjVFGTIzuyJK0OdTy9TyH
	 HRDbQNW1MJviiGsJzEtN2rMkp0FSZgF1m1FT0OWAqSbwbAjqT9NbxGj1WdXUKxZBfC
	 xkKj4iX74AoNG+cN6ikIMte1YjbHBnK0ieBJJzkmdeAEjG4ljZhuAgNKJgiIJ2sTKJ
	 u8JqZ3ltOOPxvFjaz0A+2Er0vVt4ON34cWeT7G5m77Xn1V8SLYBEzwjlAuYRZ4lma0
	 Z9OTdzE1bocUQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA1EC5ACDC;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:52:55 -0700
Subject: [PATCH v10 16/41] KVM: guest_memfd: Zero page while getting pfn
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-16-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
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
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=2563;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=yJn/ZHgiLozpfiaF3WvTX3dAxLUI4g7cee7UK9m2PVM=;
 b=l30Jr9f3hi6OTXNRNCJUYvIodwuNAe/9sIlpUlyIylb9JLbckvWkQEC0O3MkF9z/Ad2RJAuKg
 fQ+UqUROtkeAcqmpEqLAFhsm4pcVQLQgS28LhNijkgBlq/BTWV7VOub
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B9AFC1C0007
X-Rspam-User: 
X-Stat-Signature: z1ofmwhr4ebpnrhtget9dzu4sf8t8euw
X-HE-Tag: 1786139575-504364
X-HE-Meta: U2FsdGVkX1+w5YTS9XgKyBVLmUw0qoNrij+ajq3gWdOZs92AJiOE1FDzvi9AJLJsHYsaiPS+Pr6A4hA0V2CaQJU3Vk4s+lUvOwcLZ1v8BrIpz12wTjLzg7h9/0MePTGOoyqosaoeNkp2gvR6YM8rlMpAT8wwsJr3H+IDmyTPu35DCocWel35OwUucbKfiNZjJ5orP8MEKIl/o7IKfyuAAOLIObIV+swHPGk2UirVRi1th6fOfc1HUffiOBSbb/ybmU4MbKy61Slznikhkkcisfq0Jy2lnvFClMza4HQgmSSy+QTZtG5EfgUg2LNzrdhQbh5+xxyznZJemqLaQTndxjsRHhjKmPnyDHi6iJl99uip/VFmog8wAJ656zEAgULmGAH2c3e4w8dkQLZeHBFoch7kjVl2UB+/DGnjcclMIhHTEgCXiwz4Oy5kPtHRIRvdHf4QdfAf0pCucSzH35wcg8HNx+SADKd2H0tcCTB1MUdhh4ePaI0RmehV3uLcC7jvVO+lH7iu0U3pF8ITVbAc+KCEcTeRiV5RbVvClhWI0QOo7/DmxyK2nd0dKjB2e1wItLmKkUlSyPNx4lEMaOCuqDWLe4Crn+ebohU5XNKM6lmtqwLFMYbD5k4+dHsM1PTZRRarGpphL9cQiVYT3m/824txvROpV0domigYopTMNYTYgk/bJ/aV03tNVAryZ32/q6JaOiVUnSEL7gne83KsheR0Ay18/xfHfRDA4UdeSf3dUI6SUBGCSUO/Y1kQIbR/zF3jcRSLSeTWvwuo5YGj2Jo2ZiG1tctECSHF4tCunO0k0HgCmJUv2MdJy8WHIfQBir2Jo6hwdjbRxkALC9ATGNYQRVQnk6Hx9RrHg5Xe/HwHsmXdaGC2yrtHgJsNl6+TalIwcGTkfBlUf1aJRF+oL+rYHu7O+PKvywqlq9dIf9dWDRg+USYYi6T/HdEN55ecvH+IzRXyMhaA7/zAaeC
 4nMf2kx6
 nnyidjokzSbpQuzkk0hcOAnapfK6fMFxL0IKWO9/BVOEXPlAzXAzr88uASsTRmtwh/H91lDYnPKn65yPF+ZR0JWjtXSagLxD3opcNbd9NGLD5bFbG6YGvA2KJwp4LzNrOKsOh+iOnSa1u8tzQwzCpLNhHTDrCQbDMB5z6963F/7zAYyDUka+Kdn3nM8uSKRzypioOwuDkUv29iOgCR/33fukkWxmOK+rVwK16Dg34dUCvng8uOJUK0kHGyL5Rwhfy+utNdZmsUVaLpfZWtQCDZ8TQjoOs9GmNMJoXe5AUmMrcPoJrq3sFezrHxsgNgj0IRqxDijTlHll5nwtipYSQnKUmca0Ogi4e18ITYhqKAPD2FqxPOz/7HQVO8k/QvXkZMpAwtFYhR81eooAUT/jesYIRXLcdWNDjGNaTiuOvMNWW0gz9StHRnYDFdrYM6HYDGTWtarfN+vZp/ssqDr8bGpTWMnXN4E+f3iZSIRKYub5H98cBl6jkvo/q8xM7X23avb0Bd6lGiuHz7eqhSCJLOlEQSN4ndZ3OQZV6QsHi0t2xkBySx8RvSQc5xkCiMEvsJdlx3g8LNj49OSZhMr2dI8QRxg==
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

This aligns with the concept of zeroing before first use - the other place
where zeroing happens is in kvm_gmem_fault_user_mapping().

Don't mark the page uptodate again after populating, since the page would
already be marked uptodate before the post_populate() call.

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 030af0855f8b0..41950c8105b5d 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1079,6 +1079,11 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
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
@@ -1108,11 +1113,6 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		goto out;
 	}
 
-	if (!folio_test_uptodate(folio)) {
-		clear_highpage(folio_page(folio, 0));
-		folio_mark_uptodate(folio);
-	}
-
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
 	if (kvm_gmem_is_private_mem(file_inode(file), index))
 		r = kvm_arch_gmem_make_private(kvm, gfn, *pfn,
@@ -1159,8 +1159,6 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 	}
 
 	ret = post_populate(kvm, gfn, pfn, src_page, opaque);
-	if (!ret)
-		folio_mark_uptodate(folio);
 
 out_put_folio:
 	folio_put(folio);

-- 
2.55.0.654.g21b8a5bc05-goog



