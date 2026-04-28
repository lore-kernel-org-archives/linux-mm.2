Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80265FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E66AB6B00D7; Tue, 28 Apr 2026 19:29:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E16426B00D9; Tue, 28 Apr 2026 19:29:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDED36B00DA; Tue, 28 Apr 2026 19:29:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA6FB6B00D7
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:29:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 44AC31C0EE7
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:22 +0000 (UTC)
X-FDA: 84709548084.04.87420B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2B2B51C0009
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TECxRH7d;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418720;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=42VYKq3oU14EpMNn8N7BUEKEh+lvEmuwu7yXFsVAhjA=;
	b=mcObJLPutGpCWBKYAFWFy9wkVGL/I6jB/Q+w3FIStAAMzlJ79qhq20y1quZTt2tSKjJ9mB
	yv8BA8pqwGa/jFOy7WgoTah6mM8LyoJvTaM+3SMQeP80icGSrtwk/OZsXjqfuSpGG9QieH
	ZcU+JiF5cG53kzFLSEVM8kJC216aEjg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418720; a=rsa-sha256;
	cv=none;
	b=7Tc4yJg6EdiFpY+10FbFCw3Pzo9zk5sK6oWlzSCeZiI0R1FeK+qYuxbzzdf2+RRSVsQ+kP
	ZLgM/aL99MCTejJmifkqvzpvRo651EslE36H5C+kBmbSK5YGl5++riROLLfF/Oaf6dIoTR
	Stdk5C0GR+5hD4luby0Y58s2RaMnzps=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TECxRH7d;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B4E2B44488;
	Tue, 28 Apr 2026 23:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48DDAC2BCFD;
	Tue, 28 Apr 2026 23:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418717;
	bh=AaF4HXGpP5WD6rmFOZxYKszkVonAtOtfufgz8/0EJFA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=TECxRH7dkgEkaATJlrzxU+2UYhlBdNl/WGlDIixmHZcnS8qBtEDP6PBsEsTstWAef
	 0mDThIVLhAV5LRd5Qs/zPWXSjzd2Gx4yN9N92LxjrZMVO+rmGR8LHYawy074RML1dI
	 LFxn6Tej0APPQFGIBkAzy9vMIj7gNOAuB6VMjtHpDr41KZlu2s7iI9YNZyaC0lcBiH
	 +rX0bpCw5uGqLqE5S3baeoDoLH9M6HmAAJpduMPK+IE3wGPdW2ut28fG+/hOJ/Kt9r
	 On2BCWmtd4jRB13UFPwUTkBdoB87ePxZUfhltla4Z5eb0yceTzcjwD03qTi4UEvAkF
	 PTO9yweGJ1rrw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 371B8FF8879;
	Tue, 28 Apr 2026 23:25:17 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:24:58 -0700
Subject: [PATCH RFC v5 03/53] KVM: Enumerate support for PRIVATE memory iff
 kvm_arch_has_private_mem is defined
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-3-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=1791;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Wv0T7BRlY/etY57IYCmbdP7OGNUJqEfLohRwRHtaZTY=;
 b=XT8IsQV/NcpbmHXja8QsL7lhxDNOK+DGwKds9n4+pmWqIZ673ExEPONdT11cUL0EYvx+PL3C0
 7Po5/EMzQ5vCB4FICf7wMtQLA6KQ9zUFzGAb+XhGvBwk+v+doKObl2s
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2B2B51C0009
X-Stat-Signature: z3acbsr55p1quyyrp1o3rhmcd1zy7kio
X-Rspam-User: 
X-HE-Tag: 1777418719-364935
X-HE-Meta: U2FsdGVkX1/p53txPFCjUR5MOqG3fQi0B0J09m4mtFE5qIgw5qpAlfehlKehgoNVOrG97ssUFY3Rmqh7+hqSVd7/WJiMMqgYMrzxZ+lhTUoAMIjNoiopr/9NmUffTbzVEVt8wMbPoALbCUMQV23XJrZEKX/GP+R9BACWg91ZWIt7hlbNI8YPS4so9fDnckEZQH/lJtFNZgjJ5+XRBebfZLAYZO7ujrJg60wjQiRkjuGyasLkqZzOaISxz/HZvEyTkAo2ev8yDvJ8A8D9caE+1Ow5s+Zlgb/+yUiUpe6jAr6TG07uCdv6TE9M1q0zG3JTwjojkndNc6dR7L9gZr2oOX7bChyW9yKVXv748Jtoo2XqRjxvsp/he54C1GIBS/fbIb+gwYAgrxBZEJo1YyIw2g//Kdx6wNZMB3KABQz2kBbKMOdn6iM8KVBAk1JTpaLwx9M/lTY/X5tIoAsvjy2I5Tmp2QiQvod/S5uh69EFoqsEFIHiqpuRumcpR6/QZOGa4cmRuLn8Lkp3x3T19yoymSiaF6emAOoDxqJm3L39KMREyemchol0+at64X6QXIyxcolLo4UJDd1B7NsJ0SZnWXXgoz5ZD3qW9jwuWKeqQXkD9kc/TodVKdH7dSaVqWAgZimVO57EQBGaTFl22Wyd9ojFQX3a2RbeXI4gK2eXtFS9OOg+2YP3w/9Ya6dmcKaxyhRtFKGz4DAep8Mc7kOLpOLDCA2QGJq/y4So/NoKID7fWEnWFR+JHa7zvK+iTGI6bdH8emFpRkLPNR1gKWFhTdPAZuAI+4Bh90ROM78wBdza6zt+4MAyE016zOx3FIF+bnL2XBzPAwbJUGLoe012WCKEiSpiIQdTUHn25/DJRsKI3SX2W0dwiCDt/eV8FrG3f2k6WEsfrGLaHshElXxDw0B4mUT5VMdh/JYTIhnd0IvI0Mio87jxJ75XKMBkuXg5K4toqwn/5cKJTFuWZ7T
 ZbtMoQOC
 VcTQkv850Z/KgtvPxOBffb+SkK0wrNyGnQnqC5+LvLKpf6myOXO+A9d0ySBgkPopVh+5xcdEwyS1Cleim64RN6vPr98XfUA9JIe8ggNpdSHdeU65AwASA46yJ0tXYFYm/XvVtl7xq3vW319fxfU3uLSjY4LagfAYeXEo/vZqsuh31xgoVbJSObkyaVEAKOYwM9NE8yJqIRb1KB1tqccbxHabga8UHV3noqqWg4Eql8CQVHrTeHKurGMAYZGaqKmH50hwjuEjniojxm4ARJqHc4hxdKVIVgaIByh2qdGFRbvdWn+SN5pSVT5+DXM7wEZiUHzYAA1NX8kpFw+un2PLVg7ZgUCsJElsFNHFo0yJ62JDqpX6uKw6j0qmw7w0jjrWJtojH19EX6AkNHCPshAxldjBiQKDAb6Wc/8zazzoWG8kiexki6Vl26zHe/LWiRS6G4EvT5/cou5zgsos=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE based
on kvm_arch_has_private_mem being #defined in anticipation of decoupling
kvm_supported_mem_attributes() from CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
guest_memfd support for memory attributes will be unconditional to avoid
yet more macros (all architectures that support guest_memfd are expected to
use per-gmem attributes at some point), at which point enumerating support
KVM_MEMORY_ATTRIBUTE_PRIVATE based solely on memory attributes being
supported _somewhere_ would result in KVM over-reporting support on arm64.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7b9faa3545300..7d079f9701346 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -722,7 +722,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 }
 #endif
 
-#ifndef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+#ifndef kvm_arch_has_private_mem
 static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 {
 	return false;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 306153abbafa5..abb9cfa3eb04d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2421,8 +2421,10 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 {
+#ifdef kvm_arch_has_private_mem
 	if (!kvm || kvm_arch_has_private_mem(kvm))
 		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
+#endif
 
 	return 0;
 }

-- 
2.54.0.545.g6539524ca2-goog



