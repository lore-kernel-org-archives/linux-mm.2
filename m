Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACF89CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 047B36B00A6; Thu,  7 May 2026 16:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E51EC6B00A9; Thu,  7 May 2026 16:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBC446B00A8; Thu,  7 May 2026 16:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9CBA06B00A4
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:22:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68DC6A060B
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:59 +0000 (UTC)
X-FDA: 84741747678.09.211A4CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6160C10000B
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FH1O/g8A";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185377;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3P+HImgEgtnmdGz6YKilqJcDpkI20r6ipyM1hXxgFPQ=;
	b=Id71MQQX6HbRlDpW4ZbRVwM5q4eDT/UmD1NoEoSH4YOhbvDyVCB9ZLlxBDviFr6eGE7X8r
	2XU/qztQG9lae+ADPujSlNr98QAsMWse/ZMTOz+3oP6REtLyWndD5FONwd8D7VfCf4K4I+
	MKO9Sq5h1BbphuVyILmzzs6BJgvRHLI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185377; a=rsa-sha256;
	cv=none;
	b=hcdT+hZkhppK8UH8Ty6eXLpqnFsQ1fc8WvteMA494o30j5llyKlRG+3OeXGMcDzcp9PNsP
	Ifcq7EbZeayy++HD4zkomZ7eJ495KJ6dOt0AFpjCBqFrFrzkSrJKo9OK6dGC2EpTLjk6Yr
	jPAKVDAu5AimYTIhFR+nLJ9yTXmWqXs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FH1O/g8A";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E82B644779;
	Thu,  7 May 2026 20:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD5FEC2BCB2;
	Thu,  7 May 2026 20:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185370;
	bh=mYQUiOVAFcdMn9F7AdXy5VHfulr7TgaYhY2jwKbtsXQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=FH1O/g8AuwXw+t3/EVlOrla+AQE3pzeR2LqC3lh/kQxltW5ozIBT0s+ETxRneT29D
	 Qhol/bKjqc5loxPvppPBcAe9n8Bvw8zZDU9YcgLKftoJsNL0sPyCjyDocTB7qQqSit
	 jTt0tb2cUY6eHqk/VbVSCwXD3pApKAp6Lue7ojtr0PA4VmaJXNiVTyLudDPXew4vhv
	 5AGJPbQcYmnL+Fl4iPwaspzhoDz6pJFahpLF7dSuC8M2z7LT7qUPD/s35eLLk0cNxc
	 f4yYd7jiOPmjVpkLmYWJeIl+cCXO1o8xzMnejMBRv/ThSHtOc+jVKbVeProWkg/jF3
	 o0+GkNfExKYHA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B098FCD3447;
	Thu,  7 May 2026 20:22:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:37 -0700
Subject: [PATCH v6 18/43] KVM: Move KVM_VM_MEMORY_ATTRIBUTES config
 definition to x86
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-18-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=1805;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=sJS3/lDGth1Rw6pd4XUSGVYiXYontCIVaCOzoTR3u2g=;
 b=JGShSJ98Rti7ZbiCYYkxz+p3V5w7W/pjltb7+fRSUMAdgBSmn3fLjYUvzZvwtWuLIY4dN5Drm
 Pgkb6tca6IGAM0h+YRw3FdKTyT0Ncl0F9tC1y/H4LEWSk+VwYnKlGCL
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6160C10000B
X-Stat-Signature: 4woenbif4f1zafda5ssqkkfbgdarw7sw
X-Rspam-User: 
X-HE-Tag: 1778185377-805856
X-HE-Meta: U2FsdGVkX1/WlbbOURoMPvBv/6KIp6RW9XUZkFhtCnzxVHcMgIJysv3M5iQHcFWPGLgTYIvIE57rEuUpdTHSETKu0FKdkCiC0D4gmZI0a3iRjKrRmuVOBETHBogcYbqizTT66dJQ1YU3i14POkaWPNQL/AIfiRyfLZ6mXD3gVzW8oG/rsfk3vACrLhm9/nBk1PyDtEP+4ECbJOdFIolNbIaVQFOE5OIs26FuX07M9Cbpj6vZIX7dVACz35KOcQN1S7F8QJAydzzYDtKfk+aMm6SeY3J5Pbh609N8jAWZtG02fP497bTHKATmQR7TSezcTxoFgdCFQ3XVFM1RtMWKWLwjRtkWpc7cHOv739+hWyQm1W1AcJxWrR6sQ4AgO/WkwiZJXGjQAz4nRZxFxrQBHlRgpaG2LQREQoiRVSjgAR9/PFIF8VQJM7I6kIaoYrfCHNV8MQ+ZCIs9Gowt7laxKmjmBfuFST9dtk0/2ZtHUKJlGWdcpbKxy5oYX8+Qhxta72+7JEJTNifOrV1yAvh6sTJIrWo6zYLRNObsQ46lWiK+XDfZSKwHQBdtY0yszjsMIMNtgftKJUjsddbRr+SEpcJOf9C4aPfNigb9QxK5isItgKc+4Ci5dURCGYJJJEnvie96IB3E68zZx28wRqn9TxbCbzTetxBA11AFaqSE5dr9Lc8Lc9h3dVp9+zxgu53beBEl3sOhNzcYA50pnrGjcze7UxER6DUfqnxpjOxu9oiwdQU0LEhvtCNP6ygymTQElnG96RWcSvXqxansOY3llQcff6lrFi1Hn+fl2kfwNqIapLk2qNh7T0hp6Wz3aeyXIgtcASpT+uKFI1Vu+gH2Ob7DPgoigH1GPY16CU2PALgBu2XUluxDxVIX11Mmy6DZIOnyGWysrvtg8YP8h2tVVXE33F0NUd3E0XCTxGwV1r7+0NNCs2jE+YCk2BirHptD7JLybviQQcENakITuEJ
 HQq/l071
 v34tsjwIujiJjiok+/OGMou/dMy5EREgpQlewBGW9HNcurOJ5vsgwN5VbEO59X4x0AXFJclVwgECy45ZmNNbiycsvTfSGslhT3Q/aggT/is2sNUGz3Q7qezD1pMqWUm4z2JNHp9uvi6VkXdkzhdHdIpPUdwbdyvCywfUVr1FNb0ueWuFKvC1saN3aZZm73HJM8HFCJco66VqJY64YNIpcx/aqaRtYvN5OD+mmvuoanSBhebC+ND1fY4qVDEdQCkP27uvm10IBnrWSS6/RtHavZO1i8GFdPK93s55Q42QlJKL77bGo+McFSwRii5g3kuHotJA76o8x8ESQryJbO3B1NQ9k26IuURMua3Z1DSSD8X5CXpMpu1cFuMzSBIiNKgdgsN4lPSpX+O7DblpC4DlLJ/YBscQJZ8m73M7blcKKTrVFBScw0h50p8WoKOfh6lZxzezcBSgaTkDMvGshxBBV3xQF+g==
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
2.54.0.563.g4f69b47b94-goog



