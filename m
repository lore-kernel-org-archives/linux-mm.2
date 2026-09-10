Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1174EC88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:55:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B8E76B00AE; Thu, 10 Sep 2026 19:55:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 249236B00B4; Thu, 10 Sep 2026 19:55:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEB9A6B00AE; Thu, 10 Sep 2026 19:55:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B5736B00AF
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70AA5A065E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
X-FDA: 85199512440.07.C3695E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 86CDDA0002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=po3OU40F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=po3OU40F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084538;
	b=tUv8Of1YZU3rKsUqeOYNkg4o4EbUH1kSUyZ2GLdNxABUsKgCEGczFtrupsOr4N6OpELXQL
	sCVsLsMz/+TwGBl+3AXT3PdBzieJRSl4ekD8QD9PgxE4OmHR5MkE3rJrvJZ/me3tX837F8
	QFUOwZOEyGlO+h2bkzU6bl32bFJC//E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084538;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n70yln4f5InBTXI9UMd5dZOZU0wSvafV5m9vTWe4i0Y=;
	b=CaMAhjQNe/k7fhK8u0tnbmeSZixq34qn2+8HlprrvUx82XITRWbR0nAB8EEd91T7feMrNU
	opzz8E5Losw425Nuh3LNKDTbtyEDDBM5gK0j0OCIfS4RGPHMDal9If71Bv1k9cI8t0iGDt
	axXdtSnBL0TqayDHZ2osxOPrGBSDCgA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E5276025F;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 06FE0C4AF0B;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084537;
	bh=5QkLS2pKN+HDoOrAvlZqoVwn+Add7OgMCe7B4hBuSEY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=po3OU40F1w0xSTYvLwDkvjnQmiqyQMk+IwdJjOo+BmrSZTggMbidUbz5DiBkSjx//
	 5Td9ZQuPBpmzwZ5d9Ympy7XMQXv4dN1TfTr42dqN3pYFonXw0GcTrGshgyGfJKOgIc
	 GAcfq6mA4KpmrltNc/VukXiQh5NkVKihbYRyt2yaLeVawnX8sbS2sdtM2PAULFj+Yg
	 wOzuJ8VpzTHGiU7A2lqmkkqIsCB4lAOIWpU96hyS/ax4033GK9gEXpKBfzop7eO5O3
	 SUG5SVMlUdoMqEmY346yYs6QLoFjlqEoywmRsh6Mp0oq9sJZsXWeUFOgP947o7Mp5g
	 ZYhaC4UixFXxA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9D7AC88E41;
	Thu, 10 Sep 2026 23:55:36 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:31 -0700
Subject: [PATCH v13 05/44] KVM: Enumerate support for PRIVATE memory iff
 kvm_arch_has_private_mem is defined
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-5-dd6fbf94f4e1@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=2389;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=O70DRBCqJPo7OxNTezSDtm49FHHo7FriipOE2XExhRo=;
 b=b1A3ybajair4KCcbVnsjZV+Wg0ASVjE11fejtHIZcieujKw+KbrLgJNSjTgqT8+tVicrZhtEK
 rQo+tRTUvBJAzczj0tfYrGuONxc6tzSlyEvBNpYdVJdjHRdp4FVQL5g
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 86CDDA0002
X-Stat-Signature: on3bb515eh9oeuggeyazp3j11ubu33ws
X-Rspamd-Server: rspam01
X-HE-Tag: 1789084538-455402
X-HE-Meta: U2FsdGVkX18KLnWmwmxa+818xe+kNeSS6/8HY/U+HbpFYIHW/21gY00CfkWeCe/zQ+hL2x6VoE/05LuJyhtS/YoZYFCxCekZpZgZVzLBEWtQ1rmv0NDQiBQU1Q6tCSzsP7SLVeiD/ZZpTGjPWmMFJEmHkokgpqYQAlSa6t7kf8DndLzUmpLQuuplxM3zNq8+ONWS71c1Bb57IelSbyKoNt3ywu8U30vFpQnszoIahVmA1pd1r1J5oEYG9epzypjKcRv/tSyNEnTTKXxzNpE1mDxc7Bw3IqVVGQNSaYFpftSWxo56h5ZhiqoDSyHA7jqLKOtmMaBI2onbV3b2C336B/ClqS4ulsYdoHXd2mG3+DdVuET/jzPt6CwjndPa5ITddmD5YqC+oAvIsNCV9jMQi7YHfL/rbJG0wFbgHVNdo1WgmL908XT68GShDqTxe8WSWsFrBqFBSWCptyaSbwxJCYs+WKAC+3KkH51DpYo+/V6Hl5OOahkNJ+jvUi8EIbNKJu15X6hYgiLjRDS5JRvXJCXtq3+vJgdOzahryhs/zeQ6b6LAPMy00sFArhGYFkSRk5EKMcm9+6PARopqt+1GEW47QJkif8GyPdWVxHbi/A+mUOH2TEzO0FF42Mi1FEGsbeAdbfJq+EFBi1XHD1tS5maCAbgkwjcb1qU5DVx9vEcdMP/oWGfrO7b5ctbcqP6utXUs/ws3ydMEjy0TkW/yVNPxBoMj468ck95+MFirjh52zeDf/jo/LXWZRvdGCTJgGO7JwQqoHauZvUMwsoO6fX/bVzFwfhYBfARr5slrOfocRqRqh8l1KGJJ57460LqdudWXQga81xbIyB3qzNZcD/78QAdjJ0exd7ztubIlTILeKy96AKh8kGJDX7LN00UNCESUfe4iDNwhkAznxqiZkNme42E+iz5rQp1vIuft65DraGhYAbAOaskg0wuhdIsHCKPLiRKLZALEd6rPHtC
 X0bqguIP
 R47YMwhWwEc4vedW9LCDzisM2xbmt0rXWE63sN9EE7ytCK0q5WYqkRCGCMbGvPlTZ4FHhcxIrBzFcAjj2WtEh0veUNuIKwKJZ26cbYvZ2ATADQVneSMUCqTLe9rC2StKqkwYEDMaMu7HUl0LDTYJ16cyZFwqs4ZJrjCKOMxx9evAcjUo6TglKZiNTeHJTo6GBevS4YJzd5rGb2fNMKzR07y/d9/mdOblrD++nky6YShu/IDdVDqxwSOFwEUVmEpzgGEKZllPQ8TF4dXmegSSU8s7Z8Wa9VdF/zQGPn5Ns2r76igZCjlxlWL3mzmQtNk88DZwMb7MctJJqf86pYLv178Ho1NyJEaMa/7Ww0507BPxUTnvQvYaeAcgTW+Nx4xqDeR8w3/zepBAAggjXT8si2ggsn/7uMX/xGf1i3aWyX5DJT8HASTSZ3ev1APGmVpteadqn9FHwERrdU1BiE5vw9OIwQyGSfRbx7J1RlCwt16ducWNjbNe2Nqitpf1CWahaBmBQg2q9/wP025XyPCNfx8ZEhtOgOwyPRv+p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE based
on kvm_arch_has_private_mem being #defined in anticipation of tracking
PRIVATE vs. SHARED state per-guest_memfd, not per-VM (to allow in-place
conversion).

guest_memfd support for memory attributes is expected to be unconditional
to avoid yet more macros (all architectures that support guest_memfd are
expected to use per-gmem attributes at some point), at which point
enumerating support KVM_MEMORY_ATTRIBUTE_PRIVATE based solely on memory
attributes being supported by KVM at-large would result in a system-scope
check (NULL @kvm) over-reporting support on arm64.

Give architectures full control over overriding the default definition of
kvm_arch_has_private_mem() by removing the coupling with
CONFIG_KVM_VM_MEMORY_ATTRIBUTES.

In a later patch, kvm_arch_has_private_mem() will be defined based on
whether architectural features are compiled in, and made orthogonal to
CONFIG_KVM_VM_MEMORY_ATTRIBUTES.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index cffa16647f2ab..b45fb80b0aca0 100644
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
index 7d5325e3cb44b..050757544a1cb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2422,8 +2422,10 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
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
2.55.0.1007.g17ff1f9808-goog



