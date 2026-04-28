Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65503FF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:29:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDF286B00D1; Tue, 28 Apr 2026 19:29:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB7076B00D3; Tue, 28 Apr 2026 19:29:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA55C6B00D4; Tue, 28 Apr 2026 19:29:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA1926B00D1
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:29:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C162A04DB
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:28 +0000 (UTC)
X-FDA: 84709548336.12.4BCD315
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3B1FD40018
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F89sJtWJ;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418726;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KoRAHe5io9uRXYhzkfulmrbrejbchwCmIoUEBlHjc+4=;
	b=kSPlSoRYpkGH6/hM4JFVgSSxPtJatbLBFDuHDwwkSjo3ywQ6AiLHai4PZLiZYWVmT3f/eC
	a3FqJ1XGS9NhuNu6Vj8NS0bmh1uW949h2lZTywin/S+t+SHdJ8L9EqSSQ861Kdcm9VEQ46
	qyVuPIDuYRB/4mUb/sv9DEGMXaN2kmM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F89sJtWJ;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418726; a=rsa-sha256;
	cv=none;
	b=ny2YOHnDOjZBKpOQnS40EQsnHgh1k3UOvxSd4yDCnYzNn7nrnjFiJDGDscMw2LK8cTxaBo
	bnCpaYHNlMZC7Uew/2SfW3KgfUoep3L+lSgMEAEpptvyKsYqccLfNtGiSVztolpxkcVtBm
	oDyWeuzTSRQK9aoUkMSe4jHH+dqA+6M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B39ED449C6;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 79384C2BD04;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418718;
	bh=a2aEfJ6m0j8ZM/bqFoAVOYelACqW9/aXk15li5HxPEQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=F89sJtWJeVjLD9ZPKyzElsVWRALpeCoSfBqOf7qa/fY6Ukl2W+mrJJCaDStQkYgh6
	 SkhG1T1FEd6yY+Hmc/WCEiY6jsFtNMCFtnzP7VNsqYb8iKOtNKZ8X9LTRLgCnvt7Cq
	 Tq7eE6+aAV7EkIVvZcn7BZyGLRZZ7qR0cgaMjxmQEZb07qvr1ftXqb12qrjgPplQn3
	 0dJj4PU0ToiR4Y797W2dY9yA5jiJhsDmN//UBFTvX0ypD0Aw/R3nxrUUIwalQmgF39
	 Al/U0yOHF3qrjA1zyDpn4SeCG+KsycPrQBsHMfZmS6HQKvYyMbzo3Jlq/zdbh3D8zy
	 0p3lIHeoCeZRg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 667CDFF887B;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:11 -0700
Subject: [PATCH RFC v5 16/53] KVM: guest_memfd: Use actual size for
 invalidation in kvm_gmem_release()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-16-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=1535;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=8s9srRWtz7f/qUsN6cgFXL8UzY6gobQjxcKA3FAKF1g=;
 b=nLJzPo61vJJymn23yVtDUejpJ5Rclc0DHXvhXZeTco5UgcVOiVM2sLw/Sj9DreTWilBHd6/8Z
 E8OVvmbj6tdC7PZj5nGP+GWZKGH+JQXBiitkgPeHEIBwyAL9CCzFqF9
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: wm3pmqtg4dmrqaqas7hqu9oaw7wktcmp
X-Rspamd-Queue-Id: 3B1FD40018
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777418726-70845
X-HE-Meta: U2FsdGVkX1/2Nt60dzcX2aUubUhfI4TPp9XPGytD/ECS1BEmuRGfk+2r2IxZT7APmXJk8BhaFgEStabpceKTJMtK4mXZjG9IcnC6UAkMlSWKJhcJCG8u9sNiPgc0GsG5XY2Ukdt4HDEceKC98wzMdra2b8SEqTjtXxg4AiIdlWTLnuK4Mq+kIPYXhX64uHC6n/mhszXx6br6UyP5nsFwPcCCuAJsQt9B5RogyXcBqnLf90rWmz0PREKo3kjcqzU3Le9P0aUF+wbwf0YUPQB+l5hGsPYRyI2ZvcnXIjv3HJKxEi0n3+/QAlUI5IDxjtcKFXLoyLf0GPzRsPEM/vzwjGBiBncGzpw6TDgadHK7rFZgDAxvqcmQILtcbVF3hcaPuMViReSLgr8da9W5Dqq6URhFI5j62d8IfjhJ5DnIR42UggHdys1wOavTSJ3FVz6P4V7obznygcaD9SQEOKAUYQyZtH+8BvXPp5GSw46Qs3uwQBNAn2vRdoyiiJdpG/a12Z4Fw67Oakiab5SyPaYDLVw9QscslUGlYHQlt8ZqzCzZvuOHZzDBfzgfWDkNJEqCFJtvLAHW6KbyxpEVZle0rypU9KsNCxkEYbwOssA3Nu6U7DdPlCUbmhvXK44y/j2zVK/iZWBz0yCHHMtp3W0qYvg7ZvnURwCjviFIq0ygQ06zwfitfghkMdUoHd6OGe0it/zEvEcDXtQnGNwuzb2sS9Swi0Er8zc0bhfvval2aob+8Gn86Aid23gH1Lk6FbdSywDhQE+WUUlEhA8qhvsXLsvzgsXp1nFzyvINowVOAxV7XtKn6DebcE3xebLciT0xj/BTKYrjrKn6l7ladmdducENEEgEhRPBT6ZaWXEYtGvwXv4X70LwMs6Id2O2QupiTtERO0nfpK6XwmbmA3lzXgh5f7Fo0HwjinqT07TcgPuwo2/nFb/Jt2lSfL+v9FWUGnelyHnkXD10rDZwDK8
 WIplJRuO
 sVwMKZg5keLgIqNIrRTDghAMZPN1n7pfem27azqovBLtMyt3U8Wj7dW12orcYYeWALv3/Z+QQ9sIgVn4bmmYy43JxsUso+hsQyC7v5svpQu8grn6KGDOPhH+rRalbFPcy22iOmWX+jUhuKbG/DEifFEg5R+JQTAmJuY4RturPntTlVHynpdLAaxJ73RAYmQV5SLO1tSHNyZlh/OesuS6v+psXDO0m2No7f2K33adg5PgjH4yCjGbBZU3WB+lnlmjTvwHwRzqS/0NWBrJAQmQjUxTNGKu3Dxx1DAYVi2/Qeo4jgIgXi+9x0QTelU9UjPeaWbMxrZqEKzMZjIAbpAA8pgn//BzN0jET/RZmaTirmADCAEu0lrPTxnQQjUbLMoZ08WnccTRUgVEDsppwoV426tzZPdY36h6zSVGSiGWXO/3kKXm/WNLTau9J/BYWntQZ7nsRLb0fPz2ZYP5PtyPW+Ud+qA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

__kvm_gmem_invalidate_begin() and __kvm_gmem_invalidate_end() actually do
not specially handle -1ul. -1ul is used as a huge number, which legal
indices do not exceed, and hence the invalidation works as expected.

Since a later patch is going to make use of the exact range, calculate the
size of the guest_memfd inode and use it as the end range for invalidating
SPTEs.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 18dec87dd4baa..a8a5e37c982a4 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -376,6 +376,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	struct kvm_memory_slot *slot;
 	struct kvm *kvm = f->kvm;
 	unsigned long index;
+	pgoff_t end;
 
 	/*
 	 * Prevent concurrent attempts to *unbind* a memslot.  This is the last
@@ -402,9 +403,10 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * Zap all SPTEs pointed at by this file.  Do not free the backing
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
-	__kvm_gmem_invalidate_begin(f, 0, -1ul,
+	end = i_size_read(inode) >> PAGE_SHIFT;
+	__kvm_gmem_invalidate_begin(f, 0, end,
 				    kvm_gmem_get_invalidate_filter(inode));
-	__kvm_gmem_invalidate_end(f, 0, -1ul);
+	__kvm_gmem_invalidate_end(f, 0, end);
 
 	list_del(&f->entry);
 

-- 
2.54.0.545.g6539524ca2-goog



