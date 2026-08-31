Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E423CC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAE2C6B00AC; Sun, 30 Aug 2026 20:25:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E878C6B00AE; Sun, 30 Aug 2026 20:25:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4E296B00AF; Sun, 30 Aug 2026 20:25:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B49946B00AC
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3CC25A3EF3
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:32 +0000 (UTC)
X-FDA: 85159670904.22.D88CDDF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2B75F14000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="R6Zn/gCf";
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135930;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N1rFBdCQi78j/PfJ5MitjXoVYYk1apqe/NwWWyVAfXE=;
	b=k1bLO9u4lL66PME80vx2NBnG7+iPWFf0djW+sH99uKj6cwlL3m2eb3KnVKSH/fDNPHO0RL
	5WAYytVFIRTvoQkHlqFagn9cjcXcugacZ7OPzuiqDESgPQtS4WeK274KvS2y+kIIgsY+75
	msnpVC7LtH+a/rKAcm08ZVXprhuCEdk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135930;
	b=bey0iAO5HX92rNDijtepUITqZj7L57HbO+Ls3EYL1W8Ss1NARsHkJxSo6c+ZMtWCn0dTcn
	mVKBgb2psamJCJeaNhScAm3Zs1TMOhjf8X9hHbUU53UNKfAZiMM6Bqb7UOfRLL7vdlGHSi
	tqkUIUvbDKT+v9OtI991TiZp0vV2C44=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="R6Zn/gCf";
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AF86F43F3D;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84F24C2BCF5;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135921;
	bh=EXsOSFV1vU8DO2BOHPz/Ce8cakRIbhdqPxZFrapJwFs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=R6Zn/gCf/axP6nr1BaengQ/HEwKUXk8Cq6jD0GwrDYmNy59fv6L18Ccf+xAvZbxd2
	 z53c5te2jZ88oxW7EYusMTkvM4Oz1lkt2N7Qt7QJE5VeQ3jwISbpaw/SD1jKsEsKrs
	 EzgOlbKj0EQyJ+RU1TnYadGVrY/x+BwRtx6UMqTrCLLHi4EZpFyWj1afFRSWXu++M5
	 mtx4k8LGgMkC0M7p42WjHBkRnXIoVwLnLq/fVDRNOeR6KcRRQK7WrU4NGHNr1s/DUS
	 ppr27tO+OozYMgdK6vqEcA3D+Vv/3EKbE6DSdwSAEI8DTa6dXZWMZKCDP5dd7qCCEk
	 uo2qvO66eQIow==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CF2AC61DFF;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:20 -0700
Subject: [PATCH v12 19/45] KVM: guest_memfd: Zero page while getting pfn
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-19-85e5fd25252a@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135915; l=3028;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=cUGg+sf4DufBRW7+H+nQruNnSYvplZ5+HPGnat0Z7N0=;
 b=iaUEix/boqWHf265FiFwo3RPtQTjSrXq4zSJrf1krBwQQG7RpimowPl9GrMH5wwiWvEnLTWM6
 eoZpOCymVXPCpSEDnOsDrQzfSoTA27VtGyKj0i0A3pUg0T40KvmIX/V
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: epzjmkxxhgku9fkmzs394b8wjusqzry8
X-Rspamd-Queue-Id: 2B75F14000A
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788135930-465688
X-HE-Meta: U2FsdGVkX18m2FFl2sT7l4DrZvo0xu74f+BuYgGtl7RvzQ+vvlc3kj/QmWZ3LT3IxJj16Kc04UijIQUTZfqzgr02KqDQ1X9XZ5Xw9PGcfUcJGz8e3k7wubN1R6F7A25GGPUi7xgCQ6W3wiwGFAA6UHrGmj17zlYqcklvvdZj1ZM28DttpMLf0GB/97xiqPnbSGEWEGgNbiG97tKym5xNN7XXqARse0sNnNlPklqhpqqjjthu2RDIB2JvW8rmEAt2y3odmLykxMDkrgL4gqC6+aWdH+MbLoj8cTpd43qy3QBY4vZi5GsA5Yn8zlznHPi6VFrPVqld3mRd8x4HZZk8TcMpml4QOlx1cuFlVhhJdHgFcnby3eldQarlplf7XP/IhWeVwj980uNpQrsNT2m60vtvI0CGjKXVrdZPfE8RCyorE4f+Citc5ywMT5RB1g7fq6NhaE5WxA5cJHpyXdxJzIF84zQTieyRnVqFT/q0QX1lQZElkZOTm9r81n53EWktRZWjMZ/krQrr4ob4UBjIxTSxme3PJwnkkL6OIRplCiOhzag0ZIn1fgxa4AlaYQ10KEwqqmhW0gqsYqfWlgzmYjdNc9kattZMb9fKMO535VMOyaDeGQUXWpsPX5LGf5gzw9ziKUR7HSryTRbMZkVXDZTEr7B7ES17Ee0QKjOWlLN0tMuaVmU0b0ktn9oHr4jib0SK6JuRWJvM9iNi/eSt+Yy7ruYEi4rhGvRH/fgYVQoksWKja1Xwq1wOCMKzujSylOJItvHHH21YbPDfkVVn1k5P6cKFX7u/omuFjkTZA1CNKrW+wKT/Bq0Noonf/V8ZKYJBaP5vEhu4WzMhY94jfl98n+HkGoMF419zTInhnTmX2HwxshAjkqyh0avAJH5PXa7kdkVEeyCBIKlI/+QLodlcMoRefasRk+WomEH2wOzIQ4LJmKEL3VkHvfyOxOxjfTyLMtGu/Lw1zMDnL3s
 s82CPKI5
 asrn99+vv7afWcYtrqyfWKVH6ZfoBLBFFLdLUPxC/WMHN/9VMzWjQVNNnVsyVO+A/8ErHjmM8wwCOe4FFRfXlj3eJ4QX/O+NS/AEZ3pzv1cPLttMzeMMtrZS/6AdYTyrW1uTUZOiOY/u+8IvSazkxp7t3yFjuUfRE/9ch6yhn5OsybMPmLJ+Wtnm3QxbDlMC5Sx4sAQGRlZuHPxqTCrUQy1wKsJL6yYPklzaWWHNw+oF7Cvc1jZtVMcoasgg9PVcFAJOsC9QomhE/7qfT5lMCZkGcU/AA9bqgvYiQKaG06UUSS/L3ljx0nLmhNnOPmL+qzqpveRYjDeHQSGImdoStaAb5mHyuC7LCsJD3S2lSsT3w/+6+mMroYdGz528hnUiAKqGR4zuI8CE2fyEnydcS7KQGGp6OXkyhADIe57s5en2k3cY7y7kkk2BQd1oTlxD8B2Qii1wSC6swDuP/jVwexFNnrAoSoMzXosMsWcD7G2FHhyGBhfUyTZqQOfPrh5x3e3DkjSjWDyiIp0AgV1N9SKMqyeD6ausJkB6Dn/N5F7k0VJM=
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

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 1fe935aaef36f..5db578fdce6af 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1105,6 +1105,11 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
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
@@ -1133,11 +1138,6 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
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
@@ -1179,8 +1179,6 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 	}
 
 	ret = post_populate(kvm, gfn, pfn, src_page, opaque);
-	if (!ret)
-		folio_mark_uptodate(folio);
 
 out_put_folio:
 	folio_put(folio);

-- 
2.55.0.897.gb25b4bd76c-goog



