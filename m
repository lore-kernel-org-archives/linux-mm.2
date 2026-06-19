Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E450CD98FA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98A526B00AD; Thu, 18 Jun 2026 20:31:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961E86B00AE; Thu, 18 Jun 2026 20:31:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A236B00AF; Thu, 18 Jun 2026 20:31:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC876B00AD
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AA8221C4821
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:57 +0000 (UTC)
X-FDA: 84894784674.21.9B0C435
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C2F3BC0002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MD0ThQfg;
	spf=pass (imf22.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829115;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OQCKvL+Oz1OzMty4A51XfkPyu+rpclH0/Lm0NgL8cHM=;
	b=kpbEkN44StF6CnWEj3yNYQGizSbc1ka7mL/+22CJqW9iHEVB5QOzMVtGM4W3VYr5k3ybhR
	fIhrXo7x3PgERfzt4fgX7X0kWDLjxIeckBSIryhSZ34nht6XjAmmwAk5bawE7NwZ2a3Arb
	Uj5LpviBg/EaHDlubLFVg7ag0XMlX7Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MD0ThQfg;
	spf=pass (imf22.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829115;
	b=P+MCR7CoPmxzXr2IaHmwI4OhKzv2spvHIkOjdJN6AzoZsR8vWlVWM9XarXt8mJagjZtBFA
	TkshcrsybQVld+smZLo4h6PGkjY01gTMUB3I5wR2a3MkUKOMTMjDHun5z3JDmNItI+GoNT
	6m2T8t+QQFSW9RpmJ497X1qpt7F8LEs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D97A446D3;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E64E2C2BCC7;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829109;
	bh=Ub91o5JGUysbqH+c6DC6cQ/gv+FgRBBDSaawbsYxfI4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=MD0ThQfgCXMocoQ0NfK6SXumq73HZGT0IEDWQC2AhUVd4Bm6+fuz+WjeDsxGzgyBo
	 iv2AzBzLFNkivlBrfi3diZiLrWo+8KGdDK9JhGXSpIQfkbI6OCUtgcClRk4q5FLaeL
	 E69ywDcJjQZlEf2OTAMKpwHoaCgUyb/FytRmrNLaQvMiSBu2Hf1aMU1Wi4T2It9tgP
	 pDnl9aciCk1aLo+B/TXDjFsojKR6ILLNva6zlJRG7uVWlMiV8CCkeZybqFh6pLuZrI
	 FijHtRP+CmZhTtiBUTIsaVHduUgE044clR5pl8yALJqqEKFq48BPW5+/33Em3BsFFR
	 rhN00hxik/fRQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8195CDB461;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:31:58 -0700
Subject: [PATCH v8 21/46] KVM: guest_memfd: Zero page while getting pfn
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-21-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=1991;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=RJyzbxXf667S2so5DDvNBxGMe2tadiiUFOb3n2zIf6s=;
 b=VphIUj4gXv8nnyXvQcJzxM4YxIKGwcCP+UP/454op+orRTjcT6LPKud8fILbuVA+Yyg3ClDxP
 AF8+SzvWFqNBdZYhak6zSoIs6SNfg1Wcn4652084e0mielkprSJrrEw
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C2F3BC0002
X-Rspam-User: 
X-Stat-Signature: 6sk9tump46ius7r37g117y8mpmbnf9wm
X-HE-Tag: 1781829115-696715
X-HE-Meta: U2FsdGVkX1+40LVO+02xqlJjumd6uQjvojdMRJ9LSvOcuYabt3gZ/AEb8+GByg4sjt2Sq4zDojDJU0T4LKdKSPA5urcht6aKnbhseBmH2XhBZOpLi3SvowwM9ktiwyDeY5iziL1Yjh+mw5/svw/m8VqXGjOxC5qKWfBBduzjtgkiqmVQkTAUOJeVz7BMRRgjHXO/nQ56lYvh2NuejV0069bPfGYFNxxGK7Tjx8Ct7j7KZPOH5A5Hpmc3g+LwRdeOpWiDIESU3S5fgcQOr4t7DzjuRVNC7FoyQY/yApcB9p079UXlc3owFsdweS2gzfoP/Rm6lDS1nuvWPquc33SGlpWHvWo+hF5pVrGzwy3VIsEapgje1OIvMzPXTTBfcuzc9sgK7kKHs1XQcSu6WcuWBA8FFoBNkCTnjDLSxgwllek917HWyJ/iIwNqjYE7CtydSvFIKbiPt/La4owimYym9qJdBWSAe34XYgmIH9J4tCTPuPge5kxe9/IqgyrQpfZGg+2UIGtXnZGFL+DKS9j+VBcjLBdd2xNs2yfy9xxqU3DFwZJPFNtSQk5s9QGonEZHF5oxBOzDbR9pSHijYYzS3dvNjTo/u/Crgf2/eflFe4+5Rhj7rVs1HO8Q297aX43QaohmfQzlwh09NGNNMHz87bPYJX3RWuXnLdUqXrG+maATYK1UgCcBH7Uq8v3fKBBdOoPvrOtcoI3f3FwE4MomiE5RHDGnsLkwFySKg9FuB3KxhhHOksUq/jDMsMgmKMuzqqbNdDCKq45gL4FHGeqYwFcxDJVPq+vzZEZBiQ7cO36SslhEAtoqoZi/B7raNQvTAILwP1Atahzy1ij/gcTtvUnKrq7480qmFLGR5s2xg7huqdGfp6A9iJ0bxSIr7qASY2GL6wutIZ1L7IpBcIxovTVKHMMW/HLt1TG0jNTXRQxfp2rMyrkjuidV/3k4Hlea8iwnSUfQM37t3cmDtJp
 BCnfiAH1
 BgFHsLC9bgAkYXIM9U82Oh+4/zc14rW4R5cBUXQAuP0gFcKIyNok4c2N8obKawe7qBKQCUcL5Kzr2jQz45l2JtvXV8tt8Xyr+v4FC6bFkXwu4vHoUUhmgWcjnr6yMJ2KJJqn+38U4/qKhoCA1TDXqJGaKqGhVLX1jQ6VvyytG2QttgLasyPka5V/f0D2L/ntERc7HBJsuVJqlxW8e7ZtFlRb1qKcmpWKknPvBSkzrScGElhG/qXuZC2hH397NTAsLpVo51C7Q2fUSq50YKWf0TruMI89T95y5TaeVv6IBN/kNtzJq6jigYSMKZrIUvylg+HqWqEMF8EDEl5W+I6i4kTHxonVMb7PvlpFAIutV+qaQo04cRYmC/Ri+LsUDyV986T05gHmBrulGTaeq+DQIL7UDJHTrg28MeSGZtOBlKMydPSDOBecxs0iZOsKynpGS23RbBB1LSYaxpDdZDPBKwPNclypkF9cgJz0SQnTPgOSECTWAEna8i1LefA==
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

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 90bc1a26512b6..86c9f5b0863cb 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1137,6 +1137,11 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
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
@@ -1166,11 +1171,6 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		goto out;
 	}
 
-	if (!folio_test_uptodate(folio)) {
-		clear_highpage(folio_page(folio, 0));
-		folio_mark_uptodate(folio);
-	}
-
 	if (kvm_gmem_is_private_mem(inode, index))
 		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
 

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog



