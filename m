Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00F4AC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97E4A6B00AF; Sun, 30 Aug 2026 20:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 955846B00B0; Sun, 30 Aug 2026 20:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86B996B00B1; Sun, 30 Aug 2026 20:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F6D26B00AF
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE9C01C1DC2
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:33 +0000 (UTC)
X-FDA: 85159670946.15.DEE5BC7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id C4E5AA000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ALKGmRAL;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135931;
	b=obJDhVIGETEzwYP5s08vV6FFNyV6rQvbSrjiXhXlsLq1rkLjC0PI7+P+uqXhY7HiWjESvH
	lqXxX4m5wh+8r1uxhAQiCfXI6nngcT0rutjsavrK2g0nQQiEpooZPWkEJGCBWMjLnGm6aV
	/M/NyhkHjx7JVeu+ifMPEFWXcbaLxWU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135931;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oUFw9zhWu5bJ2ElZ+wz/g2lEXVPCq0uiy8ZATnf4PhQ=;
	b=tJzXVtIgXfCYhGmQi71I3S7QnG9SRmJ80zvnlqQSIWex+PJze+frkkBu/aMx8crnTn1ewu
	RabHGNmcnmN9GxexQGCGf8qj3mim0embcE5ayKHNla3TUPxhVklCpj8jgsAMRSqp3IzjJu
	/r/ZUxjAttvj47DDZDXwV35mGkEfS5E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ALKGmRAL;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 04E964487D;
	Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CFA22C2BCF5;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135921;
	bh=NxJXoL+hsz4bVjsKWlEJSpWxkSslYL/LfQ9olC8zRh8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ALKGmRAL+Na46FxAZrk8zkS3oFn3FIKadNwnytZlryYVryhIdPqtHjGK2JrqnucJj
	 zggqoWSjCFmxU/BX8cHOYaRbUI3TYrWvKUKzZFYUkAkDdezTGp9Rx7UNBQsEAOEuLq
	 pmTPmMbPNPt0Y0SN2r7VqlcpOU0dnG2kg9eTaL/qjKXbbzIT27U7YyF5ht/+JlEA/D
	 BuGctEQ7WZ5GPmMkSDKEjSTPSoNQJOvB+fxVbeynXshf4OtjMsJoi+15iUhEBklvfG
	 0x+3bUgIHvP/ptLb7zg8de5dCmpfmPJkYPhnGCdeHkMKIxlb7xPLvco+Fj98wYapyx
	 jJtT7RIsI7OXQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7A27C61DE4;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:23 -0700
Subject: [PATCH v12 22/45] KVM: Move KVM_VM_MEMORY_ATTRIBUTES config
 definition to x86
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-22-85e5fd25252a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135915; l=2002;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=LaDn2CsI38OBZyS6stNAkFJkoZdaUfE8YC0Rnt/13Oo=;
 b=5ojShQdxW/ITFZ0NQyVogZ4ru4lAf3wNfSGMZhvme6tF3hgOkZs2drAVgwLc05VWwGcoPekF7
 TjjTBYl+XCtCB93l/Nax9ptE7IrsyxW78rE0iJUz2HiE05VWEHJBTfT
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C4E5AA000A
X-Stat-Signature: z6sk58556weq896f78p1m451s4oy5m74
X-HE-Tag: 1788135931-508234
X-HE-Meta: U2FsdGVkX19Ej7ftOuwS58czMlgJe19F/2YQZj2u1dRxhCaAPUHf9RdqfJHrdg4vboR+H67DKqLRXOlyPNXHU13KMC53cNQBzvw75wntgrhfx5TvTghHYFiaaCOh0/EFBDc9flxFfP7EfvXS96tftmYy2IUgDCdoxVVkYn8ITTHCstQlm3mt0VIX4S6ckm+SDOiQfkT+9by0SSeKJIbDtktdSynaLmgpGeFdUz74Lz97u7+K/mqsfKYEkrAFbUzlA0tbndvaVECJ3yhlamuA3BwowL17obWbRVcJMjsVTepv8zjIecy4l0YgZ7Ml0PU9wUksKZDLKR3rQ0URn3BxaJsdRJQNmA3ZYgNWM/gfRjSF3hAVKHQgKmRBCoDLY+sYuNiQx0q9cotaxFng7R1mgg/YULdul7/ZrxPvA4ZwuNAP4iuDFlxRbJeaL1KW1C6WuN2ieBncEOBbsG3i+54hcxMtqMl+Topd8kfIMDFTmrJPiBBFS+zfqUeWjA7DwdNbsnaDuBYH1tzFj54PdGxbQ1c5kBjPtpnvgOc3NUj4G2hW+jfXTQl/f+dakf8Rk1kUMkUVfYt1nz1HqGTJQ5g+E1m3p7ZyHz4dsxnrVojuDwlIV9QSjVhcRCx1RnD6VBTlbHZtLBCehA/sWDxffsQQ9hGZge59b/lj3nqxCir9DVGf++uqkJAQvy4cW+tU/ZsGaiKF2m7JS92W0dccPqcbKi/yOYz73+PuGVAUojDX+qebDJCwmwOHylBVhGxRzpVvba9ZArPYj253Pkd995KHFQn6RHWBCQS1/51WHvDzy2x7v9y9LN9kMB75FWjWXyfATcz/6HPE+IYNHUnMIUhw+jMlKg/3TmYmwwisqIM3vRnpAnjSBZoEPOvSaQ+3uhQ/3sJFU9p/SkwCy5/pORA9n8n2UE7ziHX9EipjIO7u5t+geEN+8Df0D56ah6ENpzNJBGhCC6fy0ZkaAJqqQXR
 bGO4TGiJ
 wBlk9nEm+PyG9TLpm/HRNAlpbTWZGORZOvZJH5C5sra3wwEQhJ7dQ+I1egb3lx8NRjzTH2SDZlgRvNRApnsy3FMlelUSbj6o1N5R6IJaC+N38pAtQzuaEzMg5wt9wsWv+xOUpCl+clzezhjEUWIZahgBkArJ9cOJx5R6/D575wtj+thQMHUeIoksChdXo9o09Oa/vYn8/Rm4DMbIgygRIu0qz1pUyTT5Axs+rnV9nJZH/mvGD/fH90xoyUrv44PXmO6aEALS1Cur4YT+SQ39GhOnz3OQDlOFyMYfLInEg5g0DPoJQy6D/YuEh2AfqBDt78Ly3M4mE6+lH/xtxsdxIItlcGRQjoAWsnsZJck11wU6rDzHYdHImXb+T2BHV6VP73NIzUB53auTTBgf2yt4Yt8TSjI3JaoWoOXcwF1F+y0XTdKnXtzK5YrjTtwFXXra3vRlrGpurGaoh5hqN2sCKc4d+Wmf0txpR/Zzuy/mW19Hs4nSA6Lc73uik2StbAwNJAVHq8OzWcP4xZBztUzFBJz6Urp3AEjxQ91Dz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Bury KVM_VM_MEMORY_ATTRIBUTES in x86 to discourage other architectures
from adding support for per-VM memory attributes, because tracking private
vs. shared memory on a per-VM basis is now deprecated in favor of tracking
on a per-guest_memfd basis, and while RWX memory attributes are on the
horizon, they too are expected to be x86-only.

This will also allow modifying KVM_VM_MEMORY_ATTRIBUTES to be
user-selectable (in x86) without creating weirdness in KVM's Kconfigs.
Now that guest_memfd supports in-place conversions, it's entirely possible
to run x86 CoCo VMs without support for KVM_VM_MEMORY_ATTRIBUTES.

Leave the code itself in common KVM so that it's trivial to undo this
change if new per-VM attributes do come along.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/Kconfig | 3 +++
 virt/kvm/Kconfig     | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 2f8e1b5a8a72c..abb108886733a 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -80,6 +80,9 @@ config KVM_WERROR
 
 	  If in doubt, say "N".
 
+config KVM_VM_MEMORY_ATTRIBUTES
+	bool
+
 config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index df575449d97b5..a0678ef8ee3f5 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -100,9 +100,6 @@ config KVM_ELIDE_TLB_FLUSH_IF_YOUNG
 config KVM_MMU_LOCKLESS_AGING
        bool
 
-config KVM_VM_MEMORY_ATTRIBUTES
-       bool
-
 config KVM_GUEST_MEMFD
        select XARRAY_MULTI
        bool

-- 
2.55.0.897.gb25b4bd76c-goog



