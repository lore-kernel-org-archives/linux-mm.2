Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89E9AC5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:54:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF9E26B00CD; Fri,  7 Aug 2026 17:52:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECE866B00CF; Fri,  7 Aug 2026 17:52:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D715D6B00D0; Fri,  7 Aug 2026 17:52:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A28886B00CD
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:52:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E56EA156B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:59 +0000 (UTC)
X-FDA: 85075824078.20.6D5D302
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3671E40003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XoyUtaFO;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139577;
	b=mESA3d6iC5Cawh6ky547MF6nc3uWZI7vKqXnmaAKGnRAjJPDVadUnRla2iYy3QAHw63Y3O
	7Mx+TNr1UjehDkkrI+CgThOKiobfKa3hUbPlE5Ftw5rbUFeRLuGD66tNogu+Vd0tZC1e9H
	uR7WEuS2wJMkZM5wF6Kqa/cKVmzB5V4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XoyUtaFO;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139577;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jimHixiK19yy1D2YCwsBQYA/DL4UhXXallEUT+C7EZ0=;
	b=rEsh1Z3/W99pV5UPh5i/8te4t7YedkH/eJcS6px3oJsKnEvBZPuFBwPRvIGMO9WDxKYzQ8
	ajOZoDe/y9YEVoDzmctJ9rsk9KS8S5clIQh986Lt4aOPbT2aRxOQg3G1m4P8mJc2UUx4GG
	eVJpe0zvdJvSb5RjbvEvjyWZlJMQqBQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B95F645199;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 89379C2BD05;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139569;
	bh=2EpBA5sGDET0qt2T2epup75WyxodbT/NsUKEpK8prA8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=XoyUtaFOTuS2Be191isNuZ26ETbtz66rE/oCWcdLe5cOnb9gNkjoEZN/Vha8YIFvU
	 tgPlG8hkygbNLamvgLDVFj7DBE7/1oLiJvme/NcpM0BCFDYT16LxsEKlTunf2jF1m5
	 LHfzKXjp1vAXc8FkgfjLYj7r2PkVo7LukambYNrpsDMvNuZx1nOTwiLYAn7QKlsM8M
	 Q/v4+BX4vcGCuXlqnpYx1PYTgCTuGjLJLLa9ZlnkpBHa0wLGG9slg8HIsAYsPLItXa
	 xYSiKlE4pQ+Kxroc40P9wE+iJii/IfIH/50D818WdCFWZAlQXjapNG5vdMhAb/nHei
	 TJ2wydTWKwHUQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67232C5ACD7;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:52:58 -0700
Subject: [PATCH v10 19/41] KVM: Move KVM_VM_MEMORY_ATTRIBUTES config
 definition to x86
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-19-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
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
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=1945;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=+JOgNYzvijHAbgsG714d2CFgRX+TpUch731NU30JkJw=;
 b=qa1RDK48ZoSRufWd3VcENYFdgzxg5WzQA1log0T8jZiNU2/DF9PGN9GgSFYHGl/wJ2CoWclDe
 SuehuYSCVQNDv2bAvArbWAzQ5d2REkZybveET4JY+WVWBRXal2ObNBE
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3671E40003
X-Stat-Signature: ijxtfjdforbad5c1jcq5kdgxarq3iwju
X-Rspam-User: 
X-HE-Tag: 1786139577-611475
X-HE-Meta: U2FsdGVkX1+zStrPCuzf5+NxYRfN4RdY0fABPSd1MS7u8fFNAIQomHqxnFDvHEbi1iEX+lnShb07FRxz6rzE5/WcBtSlzj5+5GaH3slpG6BnHQaAan6EwP9nFf7m48VN99FoxwjSUpd5snxv6EoEq7g5l0elS5PIeZYoQKf8d+uLHQUEX2IOCVrVduxhhr7nxD09iLSXzpzA6PvuSh0td/Q1eMixABhI8leVVTJjq2AWMfJaE0TJTQ/Ie8f/LL0nynoI7DIl3fr9TykF3BBWAPmd1e89uwpmOewKi5C4LetRwBj6fAljBQOwiRmHOty4tHCWvAOWnUcSlK9jIg8EJwusSgW6wDEaz2esgWD647aI9KgD8O12OqeyCDXf555sdtvdUmNN0RtiZw+XtbItJg8GVzjQFeHKcq1NpSD8IoWAqpuV7hMqCw9TsxzU/SpMZgf14U5S/OabLil26QHEbZgqpyTVBWwx+NSf3+bO4bcr/5PNP0ZCiP+SmPE84mvg/HSEsufaOH0O7BletnRwklWiC3a6fc+iOlzDhKOzoQXKWmms+f9+DeR1k/jePNjqjFQTJJApgQy9iRlR80vuKmMlhn/GD4tbYVll3EZ5oPxaadUA4kOZS/7J9AjlIOr/eNxDFEDbzGzVtGvlQD/41q76wI3RQRFWOhGOQmYxzGTwhSpcSlPVzzzjem4mOfw3ZrlTqZFhvmEop+uWkvpXz9qCnFjhEu0LgsVzrnmb2BblQuOEyk54YBkC7p+uJ1Z/ELnIVAxbBKwfd5muR83q/ZgagkllqEMVuXlPsC2DEan/TwHcF0e5fBFzmbZsHlqwo92ThuLYQdzzBxEpUgTdKja4Pcg9sUTU5lViRKAYYdzIhp4+21pe3fbC0ROLxzBuy1Q1NAzIIP2w3QmlrjaJeNDeAWj7WzUA8AiujRNfxYkUJkdGp9F8FIaOYTcLX3kqw4LeScOuXnsiIRG7i1b
 qs2wMuM9
 an8vJkQ9/t+ZC3GMaOhtfO9QqyNJzjdf3KYI16OwXMojJj4BEWLR2TBkIDlFTk23TaKYYz0AGedCipOmwSJSpOK8XT4v0bXV91HJyekvOzqaSCaEQX0aEhUnkw3Ppix/TkwF+qZJjnmZ9IZLT4KzLr9D02Fk3q72Y/qpJEtmgHuC2vFBUMS9urDRcOaknC8zUj5GyuhYJxc0AxYKu0IePsUFs+cST9AskLbPv144YjkkXcq4G66aL2ZhaGQV2t4oG7MZGSbrfLj5ZEy9mnypeAEmTL6zCBn3PU5hPkQUdGmxz6rxxQvmU7ppabrlsBbEj8IA1Jt8B7TUQCUD7rGf8gYemeKgbuz43CxzfZ5GT4iCBAxt9VqTYBfBMwv5d68INWuuzNQydsYgB6OUNBlhgBMBvk9gzXj9Kp0r4tNizp/8ZrQQ5Pz2VXYrFUlmTqPfTFnfQ5uI1yunaNkAWePoeX++7fm098Ik+PafEg9DIkW3VwMXnpXezBYY14Bl3q3x8gvq5jmhQ0grnaZ4xtVzWMsucSL4NbD7CLZilxsafm1OBwCrs1iia0O1fzj2E+RMHRxy2HUhaJYTIMUBjw4gm1JyJ9A==
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
2.55.0.654.g21b8a5bc05-goog



