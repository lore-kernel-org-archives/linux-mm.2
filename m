Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF4A9FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:34:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3230D6B0102; Tue, 28 Apr 2026 19:34:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D36D6B0104; Tue, 28 Apr 2026 19:34:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C25E6B0105; Tue, 28 Apr 2026 19:34:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0736A6B0102
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:34:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7FC8C1C0D02
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:23 +0000 (UTC)
X-FDA: 84709548126.03.DD83A0C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7537440012
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ledDx784;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418721;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cDcFxivID5ZUBVaetx68PlRl5pbKEdWkF6ZL88m7244=;
	b=ag5H8wXasrXguggGNXBbxeK+Uc6tghS98skdONLo6GmbYg/v/HwSOFMWLJGd3W2oDLw0Il
	36VPjtur+q2G5pQrWv6iCjW2eHXaRnT91zEZoHvm6HQgymf4yiVTMUhGHHES1guFCfOfdT
	zlx99fV1czc4oF0lDxt+45dnwdKBEzI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ledDx784;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418721; a=rsa-sha256;
	cv=none;
	b=iA5gh2HfB8KPW0A4Y+9R5lknriK05iBl8KaSNGQk7MrG03T8hZv1Fd9qgqQ8Vchkj/Lt55
	pGQgvAYyOt1+Sdwa4bOC4TXcWZFo26Zu487KPKTm7hOIWBwhJW03OIjCpsF1NF8DsGLqi5
	7lCZLunQG+1iBvAU+MQt+fvac+36Wvs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E8AE9445B9;
	Tue, 28 Apr 2026 23:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84BDDC4AF50;
	Tue, 28 Apr 2026 23:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418717;
	bh=ufUN0hAdqDtY1fVXkXrEJTm6DllO/3WjmsGXjjz/Fsk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ledDx784b8qj08pPKN3Kl6FI2Sdyt4JemNMlTSKtuzLqO47dNyLqsTcblx/XVuKwc
	 1WKjXaJu/tAJW9e+afVzp1a+bVAYPUvBaRRTjlgxKqKXogUkCWQ3+E2srtmngLp0DA
	 dfKl2d32HCrDEwEanpFaMfGs8IfTwewU/aZ29PZTKOyDchMiOvYu8YkKF0L7xfBLgN
	 9DGZ6nMBf3T64sxXUcuQEOUefIljK25w/NpR6OQZvCXAbbBUhds2LCuMVEnIEjkgQ8
	 ytJx9BVq04BPVWN2oOMv5NKsxxBz1zKGBSfg+iBkC0ucHCcsev7FFdshWCQv2l633Z
	 CUUOJAHOvPqUA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A23FF8877;
	Tue, 28 Apr 2026 23:25:17 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:01 -0700
Subject: [PATCH RFC v5 06/53] KVM: x86/mmu: Bug the VM if gmem attributes
 are queried to determine max mapping level
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-6-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=1802;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=mE1k3tJABrFyLvPsAUThPSR13SSUuI4MykLoB5ZQsPI=;
 b=CMxTYYNPO2Cg0DwwVYx4rM0CeYzUOqMMYtEiADkSrj386FCCj4wMlpDsBDm5m+GMCeMOCbzOi
 lMB9ng0Vh81CYdMxjc8AIWrpzjoE01tqhLnJELjyZNXaKHIOyygmT3c
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: tx5kbjxqk6gwuuaumb7raqm3z6t6jpkb
X-Rspamd-Queue-Id: 7537440012
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777418721-98309
X-HE-Meta: U2FsdGVkX19jLzH7O/Va4xXIuwl8Sxkm34xsF/8E0eyrri8Qej2ZDPP3KOgyiR2Q4ButBH9dU+y6wYv+9sWxIpALHK0qcJLafazb+CJ8qzaIECUYUzgv/+LqzKZyM44TpTl6b+nhB/jVIBH7RkVDjIBorPQKTAHPTPLsKINUYHI/M4q/AYDfsW25VEKr9R+gza8qtzDj44F0Fo63L8Vgsf+Nvchyl8UKva8Qv/+yQM2fWYKVA6z9u9WrZpe7Kw0/CtmFYaHovWL09TN4gGD25n6evMGso0O52d/EvLd3iQYIPmZoy4ZbWa/bYZ4DZkaGwOoT9e9OkVlicQEVMiMJXwDINJK1lcG0K6jaYl7il+C2i+4sHvi26xsXprgKjrH+QnCrAJ+GhUM77A1Bs9nW1NZucpKUtzrAkFimi9FjeRQU1dESInD7FTkRN3/w1GPKhSWAfCVJ+AgKN6XX5AtFjgZnc22QutIRa2rGAvUacOIt18U7Qbzq9fYdllNXe/0ojnXBTsDMHE1X3Z9sNHfzSIxuil6Ph0jUlrsIXaB+DLYQTddFbXEgMihoJ/z9UEI+HEmWJ9ttRYGnkm489GE4OHwjI3vxYuAFAMJf1uFGXY2EwjOxp0QbOR2CW9U+x75R+sA/BfTl2J10kSOUsNjzys+hpd6gJpvQBQ8Nm5xIr+2v1LEueqeajD7d6FSVQ8nQHLSGzAcJCj4wn75vtQ8VeU0DH6nNiyBB+M5KLfz9oxQ8bOb+sbPCrkw1Isb53bMjHh0gvaQgmMpa1CLwxQewygUnY4Cmq7EE/NmuxoM3xUMO43VX2K3xHiErsP/5VJk6p7KLZvRoEdgkwCZcBOB1gwbJuRqwhai0aAREYiJdKoORwrb/oK+6fC63GUWOgS8B7/9JzKaUzEtGWRym4cphU0MdEhWQ3SLn1sCP5SydIfLZIXWEzzhulefZyGn86eO/tzEMliXZAGgZgLFhLfP
 hcL90Qv3
 nEAa9QEtDJfUEdFJMOBqdpvLnGkQqquG/CdnbjzDfN692E5/ofPXQPGVE4lz6oOXKRzAUF9CVjv3+KAxQYF5wsZ5TZHXlbuKhbnWEtaFfEosm/Z4xQunnIl0iaKnfO68wOl9JFBc4fFvjtMleLqhsqhh3h9rklM/W62ZwIwdjBCnxRr/ytXMXqazVvJWQHEglPM0UQ0fJTlvQgCuQ8IWY5CYZR7E+3SQGu4caUFXui9Icesmm+jyeI8J4uceGSQF0eNtN0U+CIOnkNHuT0O5ELVK1jQxsw8TtPpcDz0XqEGAkopUG4A0P0w28Y3bSXCGpnIPMgzuooNAUU8mx5sDCFs+05mRr4zyT2a7VpPJI5YN02HnER57K7nkNtcna5/cYmMFDa7XAdVX4VqgeOnZxKRPMJUt4HLAFFXBe
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
index 8276d7ca02036..2cc848bddf190 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3364,6 +3364,15 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
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
2.54.0.545.g6539524ca2-goog



