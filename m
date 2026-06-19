Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8865CD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56C846B0099; Thu, 18 Jun 2026 20:31:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CF536B009E; Thu, 18 Jun 2026 20:31:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F9156B0099; Thu, 18 Jun 2026 20:31:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7A336B0095
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6C9F11A02DA
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:51 +0000 (UTC)
X-FDA: 84894784422.14.2C68409
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 66D8A140002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fMoyFkWf;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829109;
	b=SxWBpVH/y+Vnkp+LxgMO0nvc3zHVDGOByzIleDs5Nm5NX7xOru5fwIVA9pVo2/K8zVfj1f
	kBhrQ9rE/ET0jF8gS0uyNmcuAZhJ1Qm5Q/Gt23wL7z0lzLH8vy8FLhke4twq3MyljTtAvM
	2HOQaUCy6uaThm/g5TPiMg0pVBQa0Sg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fMoyFkWf;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829109;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xDzSAD2J0w+aIX88FSA4oYtWFs7ZIFZYe1K3LN4/ZKE=;
	b=q5mhXv2jm1v59sqa5l0IVItln5lpsUTs6qX6Df0KG/9Pr94cIuUDY2IJObLGfuZnXsRlQ6
	70v7EqrYlNYCU5jGVjMqWvLzw4je6172eGEbYjG1xiPisHrhEme5yRsV1+iYCB4kZ7Qxnc
	mw1keoBk/p40qoG2vHyb6dG75/I6ZcE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 962D0445D5;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1F11C32782;
	Fri, 19 Jun 2026 00:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829107;
	bh=ollZgX43tFsLrhy2P1w5C+j92eAZ524GQL9W2DSYjJY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=fMoyFkWfuDioDLrStAD3888RAN8bwMPG74Dh23uMDFjUOb03nleS8WzhnsOH/bVNt
	 fQ9nzTSDbcgW7b3WkEeF9U0o5aHnwmtAxBWGo+zj5Ya3XnyBAZEu3FrT+7xwEKX8in
	 8M4R4SaMQ7KP3AnsdCzCW55tKhyEnp3jH+1rQZzNIqvhRwlk99sZPw28cZj/phGNTK
	 cvHqgTdW+vYiwXZhnJBJhHpW90+FM2U/qm7LMOipW/B44eV6TTG4yqmLE3V/V6NwOi
	 mCDmb76xofVkhHsW1ya6YSlv9hyr60x054E6S5ba/o4DYiOGn2LfvuBg++cOGKhNl9
	 YxuRqTEWX/m6g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E103FCD98FE;
	Fri, 19 Jun 2026 00:31:46 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:31:40 -0700
Subject: [PATCH v8 03/46] KVM: Move KVM_VM_MEMORY_ATTRIBUTES config
 definition to x86
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-3-9d2959357853@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=1805;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=uR+MEtIUTQll7OuVTSkz0gUaYaNmKrp/B9G+SURdKjQ=;
 b=Zyafotc3pM3F8Xww7Ysd3hx9sfWihc1USTcZBOWp6mbJPeMaaKXDQ8cdCLA3334Ml/hA1yllh
 wOlBQaQUs9AAWsJg7JXkRMpiIhtHKFInzhQiPZd5D2zDZ+x1FQbxWDt
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: umt7hqefhyfc74ae8ts85a9pfw9xbzk6
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 66D8A140002
X-HE-Tag: 1781829109-151872
X-HE-Meta: U2FsdGVkX1+rqR4/ganlYr5A9/TELDt79+kOaEfQq8mfvBdsJWlnoRQQhwqK4af5Ot0z3Ff4EQBLYFl5hoM3HjZ3pMDpjFpDj+8nsDZ/ilR7xL5O2r0ljBgljvX5HRibku8wJK8lq9X4uXqbn/6U3k7oXGzjLURyvA6eP7NYfKyTiE0nDlDzNWnBrsbCgNs5honD4tvKOOG7fWGozG9SUbb1UJ3PeoCh37ikTWTvjRiv9Ss+ir1Uj4ADF0aKZeE7LvzDCJeBABwLp8Qkz9u6DF8b9eWJDd3fkBYrlVS4FjA14WYUYaNTTIi3+Misu5Pat3zsTowakwL8AnqItjlvHnEwX002tWHkm0gOmldxDoW+vmydsBTHABBuMKOGG6QwAVqSpLEmk9v4+GWxKYpJkMBo15/vFqN8rIPqHKt/o4S/I61unDSNl/khZ0PefPyGHbEQ/IduqXQUguoDP5W3llJZBly6mPKlzJc2fio6I7mAkmV8CeromVOtocerjgzz+qZbIHZ4sLFBDSHOdpH3jGxZaqKxjXsinYdYgScsIHzGnziZyYzX+AKygXQw+vFvXm8yIgRRQ5On/xUwXt+VcUOCkojv3iqMymtyQAfjqbz+TGlFk5bPiNeV4LpeSHz9XPqUuw+tJGmVIrAMqutyWsWBh3IKiD1jZ+98ulg5h+UKRAuEcOxzOfvfInsjGd4+VY/ScxHRd25qCPPbUG4Ol1mks7FKCwH2PQdWbsPfRCHRi7fRDgw/ONqvDVQXZljF26TFYxmQu84gODdr4RTUCzxwZNqt+9GJVnVAPJMNWP6TZYraJGSjFnRD/Xjid9n4CLzJpJe+BI+rD5D0oB7Zd11rnbrjlwhK+KTBBn1ZYOJX8tTDlcdiQirjklcRsep5FrYaJ7uS4E+jcjFLTT9/tUZEAwj4i+0sEotUnaHSbGwyOlhvlwN6a2NoklHkNX5ytAZzzLD4k0DzNaZBZDX
 GCIlB9mT
 n5HRLs8smwsQhS6zBJVk8aXBceG8vbe0DpIlTPbA/GqZleMR4a2maeLstra7jLI6oE9BipMU3KpmCxtlLup7IUZfCuHV+MY8KWH2NX5zIAxJicL0UxnPVGBJY3TBudCwNFmAhmvynleS0bCTkziXCfqtMpIex8FPTUSIrN69NAhalwJDpromvUTL+/+LMDyqTXiUSVnvr6wtm1xImx/hZLyv8I5KernjGPJEehz4PArzIDjSp22zDZMkCp5cNjmYnfa6HhVXLX3PKQnjp+4QWEfBGVCphBcR69FfZhb9q7eZrrDmvg1qmYXV8Kfvg6Mxb6QlwKrR3EXqGt+mohsp6JnMtD6jbhQye+5cvlsF+GQQHRTlEGOrSTPiaa30YmnpVgBMiGedRyEs5ArUiU/zCk2LCJHpnv4pgkRUl7rf3MZX7IdpmcbYZsOQsIztj1EY0RO+4Km3BhRixjrWY9r7Qa1o6XkWYCrMPlN/fCzaAkLomFEmWGUwfR5jeU4zU7P6rptCIBnSeoAwybpvJp0vXxNgAbROYApD8pVlr
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
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/Kconfig | 3 +++
 virt/kvm/Kconfig     | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 26f6afd51bbdc..24f96396cfa1c 100644
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
index 5119cb37145fc..297e4399fbd49 100644
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
2.55.0.rc0.738.g0c8ab3ebcc-goog



