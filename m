Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78DE3FF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3F156B00DE; Tue, 28 Apr 2026 19:30:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCA566B00DF; Tue, 28 Apr 2026 19:30:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6BA66B00E0; Tue, 28 Apr 2026 19:30:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7D576B00DE
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:30:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10ABD41300
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:22 +0000 (UTC)
X-FDA: 84709548084.29.73137FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0989A80006
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AV2mfwoP;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418720;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G1Gw0C6/5MGejOqnUIP0w17/L/heHbeSF9+D/4FGviY=;
	b=gQQ/Z+TCc3UUlv9ga3K/6fIHKWcXV0EUGVGq+e5TfTf6LjTn02bmQ9l79eHTbGfhJWI0Hk
	Ya9J11YqcoJjGyFFjE73VgqPg69mGiwWARiixr+aVyb+TYyn2PBge44a/RX4pLvPiGJlFP
	Q+9/YZECNrurFrTiJsBU/uyS4yFlkR4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AV2mfwoP;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418720; a=rsa-sha256;
	cv=none;
	b=DRpmuvT3R1dx/SEzDn9MijS2j7pJlroJUBUUozndiYIJep/K4FM3/A5P6BtvWFb4LsiKEQ
	+xyafika028z39iK3p2rBC/7p9UrvTHKPZaD6n3wmnhsAOgm3aW7aMb/YA8aOJyzVOVZ8a
	qqpamU1FDcyPct1KCkeNDG8dRzl+0us=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E17F26184D;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0D41C2BCC9;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418718;
	bh=aEV4UjQjsWs7N1JMqvCcV481PEAk1tk0BIdV5ZaHEYc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=AV2mfwoPlfsAmvMZOdenWjoLEVnV6nPp8/kveXAHR4yHkjSUc5DKCn2Q8NuaQ0FkH
	 bMIj2MrLgVcmrkIRDdlnR+j5mo/QG0Qv4qGGMClmRmseLCF22QBAFZ2+V4mkppt36e
	 JGfQ62QNBadyRpjO+ekn0LsZdYPNGOwU78o+hS1DowhngG4a80gubQf7F2Nx4yUxNX
	 3i1wuy53lE/BMra2BZnlWZVtROcBDFcyWosnCJcmsMmwCQH5IefXNP6nixWMo1pkxQ
	 XNY1MdQYEeeoMziQoKXkdCdfr5Olm2vgtFuqQ9VxxibYif6/ju2WgWTaTe61eERsTe
	 U4h9NKRlI8Cig==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91AECFF8877;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:13 -0700
Subject: [PATCH RFC v5 18/53] KVM: Move KVM_VM_MEMORY_ATTRIBUTES config
 definition to x86
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-18-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=1805;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=kWyeQB/GQxPIUPFKfrteI7VrZ53oW8LRRzQh+H0D7K8=;
 b=ileSfoo1GqxHrOuqoCf1RNEpw8cYUg18NzHzeaEeQ9gn9rjBxsIHBnrST9VvuJIYLv12RU1ss
 NLpW3opkVhZBMlYJzQm+f0+don3AVOIR3jb95eTU6C1vsyq0Yg/rfeb
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: cgzbq8y9cxr5wqtieahqsp8cxjy6dgei
X-Rspamd-Queue-Id: 0989A80006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777418719-621074
X-HE-Meta: U2FsdGVkX18KqbSdQAc9uw9N+hWZd8aE1MPbrbrhLw5fRkf15ODaKlz0grF2ynaOdo+ZHTvNgv13sNES49L0iRuRklpY/wUJ3a6nENWmHk7RX+kzUvNt1Bp8bgv+zWRJgvE/Q7ZfLYY29Kjl4xWaYGltcfHl+FTVhMuXZa+vxDIdOl4lgKRLPWvPYS/xHo1lsBUzHe+WVFFBZAm5Jo3U9S4CaYDrvpBK2dGmpkFS7U7IrSMniBlw6xKggjtfcz7tFRYM5cQecKNjHnFrQVA4Nh6zklyO76d/vmlecxXughvbU+QupDutprRbmcFKIqVwfjRgDl514NqWzlALuEVNLkMjosXyl+hkXg0cLNzd3o6SSXNUd1mLce9u8RQ/GPYVt/hJmoF6d+ul1xA1UgXNxyVfs2GedbksDurRd5wvf8I/+AEgFhTuxl7ujUnp2T+cqis7iGyzVWoniLGJZWxtVD3Zv6HFTJ4r6GZa7zU8UgLR2SeKvuVhsJEydQwM6kDs9AKIClFdFoBVonBa/y7Q1/etENl+CdNUObEi+HsYk3k9dIeHp9ldkCEwrElNxxWPGXwKvJfA1z9dOfrLKJnc1uV3wfLhw0rpgXAzlZ73ypiePPD92duKt2GV+6q5z9vNODCU/ELDweI4xms1m3kofzKWEBVMu6wLI7161R2CzTZ+fKaeKojxQC+uYR07OzQPhNDNKsN64N6rWg+QEc8rMnfxkLQdDh0hdyvIL2ajSM1pg81oR6wq1n3RuRSBGyh8eowYt3apVWgFrgCIwJtZvWmM+4/qAGWYJiXwZR4odlCoEVxW5ymaHwdAZSTtX3FiofkdAhOA3VcqF6kA1D5DYf9yCS52AbSRBTHQuzRmJO1LCRoVqqAxzLN5eZQhQFHSo0RwelEE/IocUdDefRJjmfWsnReCjXpU/a8PQCjBkk8WSEldcJq5dWc/0OyC2dPd9ht7pqqhh36GNk6XdX1
 I3MV733b
 YeNhDZYMUVhTmJYVSYYm2NX6k0CoS5qi7r076q4yO1Ad2YVCCYIRIGCLb9Ugv+6f1RSb6bGn7QbSDqO316VkUKb8w79sulPYlbsH2vwyVfnj8bAYPpQb+PAm0Ga0Kb75AzjgSOmnub0DbLYDbeFxTdsCeftSB6fgt+zEoFPu3/J26jT4VZwU2WhNNlrTlSK5ygL7WonMPerglF+KobLwgIMDuDyrdeyzGfNvNIUN37xLE1ZAKY3sghElJLHbo1sUvkmASOT+gBUjoUoPpoV8K9YgEuJSo1vM7W3GIns+h7sDllEfbxCqzabJecmbI9PdwbkWaSOw0/DBJHfIlxitVP1vr2pYbbj0y44Rtd25OPDFm+OnjpRhxIYobCMSqsk5XCGOSeo7D/99cGH/2g/VgWHyHH9kx0wf8NtmdWHIbCzrS5a57dEnDhq6lnRdZvGcKm/3A/b0Q81zz7zdrLCHPghr8ZA==
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
on a per-guest_memfd basis, and no other memory attributes are on the
horizon.

This will also allow modifying KVM_VM_MEMORY_ATTRIBUTES to be
user-selectable (in x86) without creating weirdness in KVM's Kconfigs.
Now that guest_memfd support memory attributes, it's entirely possible to
run x86 CoCo VMs without support for KVM_VM_MEMORY_ATTRIBUTES.

Leave the code itself in common KVM so that it's trivial to undo this
change if new per-VM attributes do come along.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/Kconfig | 4 ++++
 virt/kvm/Kconfig     | 4 ----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 26f6afd51bbdc..b6d65ee664d0f 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -80,6 +80,10 @@ config KVM_WERROR
 
 	  If in doubt, say "N".
 
+config KVM_VM_MEMORY_ATTRIBUTES
+	select KVM_MEMORY_ATTRIBUTES
+	bool
+
 config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index e371e079e2c50..663de6421eda2 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -103,10 +103,6 @@ config KVM_MMU_LOCKLESS_AGING
 config KVM_MEMORY_ATTRIBUTES
        bool
 
-config KVM_VM_MEMORY_ATTRIBUTES
-       select KVM_MEMORY_ATTRIBUTES
-       bool
-
 config KVM_GUEST_MEMFD
        select XARRAY_MULTI
        select KVM_MEMORY_ATTRIBUTES

-- 
2.54.0.545.g6539524ca2-goog



