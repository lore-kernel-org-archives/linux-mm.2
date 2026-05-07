Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B08D0CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF1306B0096; Thu,  7 May 2026 16:22:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC8526B0099; Thu,  7 May 2026 16:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D68316B009B; Thu,  7 May 2026 16:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C7AA66B0096
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:22:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 78E2540612
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:54 +0000 (UTC)
X-FDA: 84741747468.09.23FC037
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 34C9740004
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mesFkbnZ;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185372;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tBp8hApVWo0klMAqE6gAxJzoV6eL+6KiRpk5j0qWK4w=;
	b=WBFvQxXBJPVkmmQKb698KHMHn7GPq5/V17CA0oGcMIO3d/97aaci94qaLwzdrq3zZ9QpEq
	OLO/SIID5JKR2tkJzYlXPFyC84JiBw74olXZ9WqWX0xEtUbE6aSZUkHbDBWh+1vH/3gX7y
	zTvWB30EMgVbB0TRgHNtLotrzGFL8Jw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mesFkbnZ;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185372; a=rsa-sha256;
	cv=none;
	b=P5hiIBc7KfMFMU0PxdWyv9gZtSRVSwEDryIK8vJ3WgcVuBUOCMgoUG/9Ttm+lwWfN9qnUZ
	Ejp3P+CNWqUkMgBPirbj/wdYHLflUJzp9dxaU1D1DAV5HxENQc0wZGVo7oP/20qMgUuo8I
	4YO0iFbsVrZ4Cz6ytS2stqOZb7lHvu8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4655044596;
	Thu,  7 May 2026 20:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1C93DC2BCB2;
	Thu,  7 May 2026 20:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185369;
	bh=3Tv8SP7AnWASbuC11+vKkTBpZCOcHskSD+AA8VifsNE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=mesFkbnZAQuzWOKn0YAKeg+kNk95QR6MHiqkqL2v8xwB01b/5s+iATr00O328L9T5
	 oHiMnQD+gBEKwrrSlnnFsCS/dfCJNRNd3TaPwwXlMZmfK3nc1hEDDw4/47gnpVuaaT
	 RbAetGbtYXfj/gkoC7Sz1wmc2EDFKWD+h6O/EwOlq59rp52/Imn1xsPR5JVPPjA8cl
	 67dZTb+Rv5t6Hc8MeBYDPuCx25IufB1+1oMH29TuP25bejpehzuXgaOfKJerUVOtux
	 uKv3OUo/eoeilV87magdwm1MiJ9cNRtJEmR+4kiJJpwCuKvjyn0tFxf1+3E03CXMGT
	 gYrUy1zKdSjNw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F5F0CD379F;
	Thu,  7 May 2026 20:22:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:25 -0700
Subject: [PATCH v6 06/43] KVM: x86/mmu: Bug the VM if gmem attributes are
 queried to determine max mapping level
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-6-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, liam@infradead.org, 
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=1802;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=zSMKUjOxxa82tr34hHB/lIyi0dgSFlYMksc47el8QGc=;
 b=hJ896vjTW0uUAF9uO3rBIOiH5NHAk0DL09eR9y0euiFWur9ijMeWBDnfJ2NtS5VCQ0U7KoL+q
 r6BoruioCdBDfuBf5VaYFPrfITfiOTnp6SwjOLdc8yMs137ID9Bj4ms
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: 1cdff9ery15hwcqfzs77ma3pfe8f3c1j
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 34C9740004
X-Rspam-User: 
X-HE-Tag: 1778185371-718502
X-HE-Meta: U2FsdGVkX1/OD1sNDAj2idYueOdFF/1X8pr/nHMly8e/gQLwq9fnT4mrrotXPRfFBmmAs/el8MG2jM3FSjeegDj9aWsfLCrt8jJhlUiQ9P7T4y6MeqRQrUxUorbg/tjksfcVa7L4UGC5fJO9NMXFdDsWH0JJ8ox2bIvQbjBkyrM9pR+vvQ98jdp3E3LKEcp8eIYC6t93u0v2XOj8vbY44FMZvyG+D6duIO4xvDg1cMNfkB/AfjzR/H9fc+Ky4e7S44BKMmTwHbnQXzhRDxqweDmStfu680Uu+23KTJnkfyXZxdRgJWZfKp1JO6ZmzXGQwN2jdq27dUrVsWFeLpKh6lo+zCfcE3doyMW0G8CY9X6p/4Nllp9Qgvm1fdTpC7Wfzi1EIMuc1xYfWd6LLfysDOlnnTlU0uDLjbJZEa6BsGvZUnrOQxQ/F+HoEz9OgGyFwdi3yywDaLr5YsHOZ/RfsrUCgV5pirq8unkrj3ewbpg9uaLMmxy0ZsPBK+3Nd8XTBYb+VWTe7tu626YskRjHrDVcmbDCN3BKKA4dH+uNqc+fRV3msVlo+9WVXWOuKthhIJBksaOfjppia1NggG8bIlJIl5sMqIDTI57qwYqCJ1HVIYnclFyJ1DLqIjvYyotgys2tiTzLO6CGmqIsLBSpdReotOhM2BJHbsXvbWddQsTvudKBN0rXNPWP3KFUeCSUHIRpUgvIA0w5p+Ga5IuDLtFaUbhFzEUQDS3NBfAgHhFIHr+ImN+MKqbXWliZHNtON6kjC9ZKrbq5t9wIC+7YUt4encfC9FAPLIHRpDxPIO0uqGG0nZcMAG3uCvaIzTddoC+Te8234Diuq//wAM9BbA0vmgFzxs12iYbkhI/jClF2q2DdT3GzaP+rTdSKmAuu9LUuFq6rgR0EgNZCmWYEgB0wbpeGiz/LLEflq8LuXduVh+m4JUi+rJx+pQPMTQfdpeTg/2AOPzTu0YzxTJq
 a+gg/Qz5
 XwrDWn2G0BhTBg6q68dugTrzlp282K1r4elZc16lxRrQLOpI1yEXJQptajuEXrHhtWS6nq/lcyNelr2HFgPPnd3FF/cg8qPY9eZwP2S267fWV7sSTSSuCN5Z79Ui7PDXSOVHOfYuaXxQxqNl6eZHWdEA1xmHwfgFH1bOlSq/6Ock4PDS0HPoJOcvGF7bR5rMul0XyIoM78pDl18dgmf5OrMNpZ5iFR00O1XLHfVkfrGbPh4UrXLFbecOUHeV94XNM4KstHKAJix0HJeKsIFvKL3+95G/NQ2/aIrLQPoX4L48yuxYUKVJyd4xmTl7t4+yY1BXSpleaew5RpnTnW/fXGqAqQfgt3j9eD0juB7mBwhKpW9XI6t8EOCWK2x6fUKKSXqniCOR2uwvX51lnAd/HjOPTK8UjYdw/3oBW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When the maximum mapping level is queried, KVM's MMU lock is held, and
while the MMU lock is held, guest_memfd cannot take the
filemap_invalidate_lock() to look up the current shared/private state of
the gfn, for these reasons:

+ The MMU lock is a spinlock or rwlock and cannot be held while taking a
  lock that can sleep.
+ In guest_memfd's code paths (such as truncate), the
  filemap_invalidate_lock() is held while taking the MMU lock, and taking
  the locks in reverse order would introduce a AB-BA deadlock.

Currently, the maximum mapping level is only queried from guest_memfd in
the process of recovering huge pages, if dirty logging is disabled on a
memslot. Dirty logging is not currently supported for guest_memfd, and
guest_memfd memslots also cannot be updated.

For now, bug the VM if guest_memfd needs to be queried to determine the
maximum mapping level. This guard can be removed if/when support is added.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a80a876ab4ad6..153bcc5369985 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3357,6 +3357,15 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
 		max_level = fault->max_level;
 		is_private = fault->is_private;
 	} else {
+		/*
+		 * Memory attributes cannot be obtained from guest_memfd while
+		 * the MMU lock is held.
+		 */
+		if (KVM_BUG_ON(static_call_query(__kvm_get_memory_attributes) ==
+			       kvm_gmem_get_memory_attributes, kvm)) {
+			return 0;
+		}
+
 		max_level = PG_LEVEL_NUM;
 		is_private = kvm_mem_is_private(kvm, gfn);
 	}

-- 
2.54.0.563.g4f69b47b94-goog



