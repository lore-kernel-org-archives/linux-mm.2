Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81774C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0A046B009D; Tue, 28 Jul 2026 20:35:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADF716B009F; Tue, 28 Jul 2026 20:35:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A7516B009E; Tue, 28 Jul 2026 20:35:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 655176B00A0
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D9E45403E7
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:12 +0000 (UTC)
X-FDA: 85039944864.12.1DB23D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0917440012
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cn9xtmoa;
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285311;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1b0KUbyq8T4gUFVXhYD/Fnm+PcWTOxp8aSxICDhKTCY=;
	b=Cg6tTGh0aZxvqnCGQHYA9E0b4ti9L2aG59ANq5MYMZa8Y+FuPxQU3FuAkJkzvdFjmqlBzN
	mzuXUeVblsXURsp5t4quW90UMIKCGrxaB9g9qvoR2nNy+a0grLo834nKop8/jwCCrfBb89
	WkDS71JfktSq7JTlqIDocb3BcdpPtsg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285311;
	b=twQ5jHDSSoX1QjZ94hld2sYgdL02qEJmFVuAxJUtP7aKK2bbSqpHvywofkfd5PczFVOT6C
	EYdqM8I1zK1dg/GlqhLQsizVEYOfg5fO+0cSfbBmDvBFzyZSL92+RfdMMvuxr0rOa3nSL2
	IItSyC71tg6CuEY3Scd1bpwlIgbc8Yw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cn9xtmoa;
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A707E60DC5;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 250AAC4AF11;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285309;
	bh=tLm2sExVUSHllXBvt40VdvuFXPpT1kf/TFtQbm5kn1s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Cn9xtmoaz38gK0Gsv/+vV+vvKnmTsjzhJDGYsIOaYyMPziTPwFq9DCQECJlnHSqXr
	 MrZaXhSRW1FygiRxlCsszE9BkV64yTuHjy1B1JOsAT4RV90pC7LZrwNTPhVqc75BZT
	 5TIHW0J0wuLxxlkElMxAkjipqxM+KMB8PH8E0Rl6Ss0PTQJz8ov+eJFCCVCuNB2vJG
	 7zSRQB+VfvY1baAXOhdY095ScrQsi0t9/vndtqs0wBoRGvWwZYuz8CDShc3FSch4rp
	 YniiSjv0nnO9COWGAgELOZGBmBnut9VxzOlEgbQc3mqASdvZxlXXSCIepm0sG/wW6S
	 GTFU8KKS4w3Pg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0805AC54F57;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:15 -0700
Subject: [PATCH v9 16/41] KVM: guest_memfd: Zero page while getting pfn
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-16-35f9aec2aed2@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=2515;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=DnfgdOILwJaXU85D1SeMtvWbci6InAPagvN5EQKjyoc=;
 b=5QNKwwgi+Uzc6y0HVwMEajeW/iXXi/Id2T0nEnh8Gqp8MociKfCV8TPimFMrQ037jMYqJdw0f
 5CAGysKM1R5Bqf0l51NuoBE9tO2EEQ5+z2zgB4+bfVerbepvHMNlpEE
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0917440012
X-Stat-Signature: fi9eqaygs559tce6ydxa9gpxjigd81hz
X-Rspam-User: 
X-HE-Tag: 1785285310-544480
X-HE-Meta: U2FsdGVkX18QWOAf55pm0OhXfEK6MTeu5z4LLRyRLM3mM7Tvc3geimO3WolX36PZXFZFSZwC9NLSdywQD+QfxP79DZ6cSsU7EhmsTeqGdbzsxNrjCLfMgXF4D3vCmEuplNsO4xm/Xj8E6/zC8ydi0Kgx9gAcx6S57GRY0pJwtuEXIjYUs6gElolKIqYGPpU/l+wVCq71+tlP3rBnbV7kTCX/JltPnZreiwxINJ5NLTCZ2B37lFTz4QIxTmXhB2oPeXZBcZh3pgIsiY15C2qzNNB27iYC5ayTHK39i9UzyVFbSUr/Y0xHoHIQwIkmFTAY9UR0cMfYrM54Kbg8DFpZ70dcLJ9w9hDpDOqDrIoA/Zxpq4hzFOiY5b09ydHbRjlWzMAlx0fpxYDDanwfFHBFw/ArFuz5eEM5b4LTryqN3ddA6TBcBqHJoCFxrma62VuOvHDOTdziW9K8ayVhK6U235zl09DyJxhf8uQLO3s5DyYLnwb4KVTtFGity4VALumwRtSKqSBgz1JW3EWYdwxxY04MCFq1kkUn0zDYu0OH6Ha+NuIZBwNnZrnsJYJcGZWddl5I7xVDei5fpwBvwg2VVTl3EAKptTRphdAOLuLElKoQKJfJlnkLdDSNTRlaWLVnfxGyCA6dYNvOVzPUOW4vWwcSmomkXpaxLhDaCMZDWaB1ha5n5um01TnWDIjlhvLlS3RpgrfpAb/AWj489SlXaHddKBb6sYKE2xu6NJ49GZYt+Kx4eWKyXgQi6ueG+winIjTNC1O5pwd5OEUnfkdbt6CB3xhvHn6xp6sKKOvgz9DjtL/wH3kvHG4CIiAkbCgwW0sDjsi9u0jgyjldD/awT7r0ZlNQl265wKmmtFovvUbqGM48pL2gYuaBjo2pi2JN3l9wcwmsoKSPa/S+ARRxQ78ZUW6ghuAzQytO9MsNrONGTZuou1ZMWlPiyz1AXlNibqcl0LyrDEj663hN0+f
 NEP8pvvZ
 u+EZ4HJ4n5/IlBjZDl1PBqONfeC22wFl80Rywggq1M/SAPfvwHF6IJO77uR43zV9hBBQSvEc1gcP/43cUC4X3pU/2zEj4CUIHp3HUQ09puaf99VjWocV71kBnprFuRyFNHQrMRby5/89B+d5lfgtfwcTkQpUGD/+BjRlJfTlVEmIu8xOVABPYw3UhvwMhwakN7X5aups6MvOnbgZCRX0ns/lz4LPjnUfBTDcyldZ5PhUDbsyfjruDNO+YiG5WBTpbduBTOvQfYraK9ufQHaKUmL8rf1pNrDy1bUK7Lh1TU+YjJbt/JBgv6E3MUr3mBCJhuX+O+e2iLR8juBYzHme9EW8hA15OsGybl1sOB1WK/CUqyzPaJg1quBYp16CZhY2VBSN1pbel5BMgfhO49xL8skUBX/k5SBip7wye4KN6xU/b4dEGG1xCmP/vWDFNVI0+1iqLuSBMIQ8FayHaxx7cWYZTGsA3D7iDao2d8u3+jeynf9/c2xUuI7OBIk6z/379gDJA6DLiby2kq4UcvxHFrDnKwOZ6Q6kKq8964/MfduwDFXr7mnMSfQzfsw==
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
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 505bb6747620b..ea2752989f8bd 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1078,6 +1078,11 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
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
@@ -1107,11 +1112,6 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
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
@@ -1171,8 +1171,6 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 	}
 
 	ret = post_populate(kvm, gfn, pfn, src_page, opaque);
-	if (!ret)
-		folio_mark_uptodate(folio);
 
 out_put_folio:
 	folio_put(folio);

-- 
2.55.0.508.g3f0d502094-goog



