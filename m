Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE5E4F532C2
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 727156B00A0; Mon, 23 Mar 2026 19:58:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7AE6B009F; Mon, 23 Mar 2026 19:58:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59E6D6B00A0; Mon, 23 Mar 2026 19:58:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 463176B009D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:58:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 003B0C3E23
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:58:48 +0000 (UTC)
X-FDA: 84578995578.04.6DBF2F1
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id 31CEC140002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:58:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RVSDAG4H;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3tdPBaQgKCLgbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3tdPBaQgKCLgbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310327; a=rsa-sha256;
	cv=none;
	b=lIOWYa5gWaehXWKbexqPwCjwsCNmdsDp5QO6y/QLf9Lf5qQrJc6Huxh6MHtNBNnbb5gbEn
	HCO51mgNSATOOFzbBrieJusDt6u2lyihzJajv4Y6j9YVZhMJGGrHf0UNmN0yZxLC1J3p78
	97TLPauh3MwfzFc9INMbLONlbnC6rrI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RVSDAG4H;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3tdPBaQgKCLgbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3tdPBaQgKCLgbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z81MLxHKunKSpfd9G8Gazc1UStxzf4ZSRozQrfTx8r0=;
	b=2fd6bb4FMsKHuy1jG9mifcKxkhvLwIlokLLJHIjxa86ckAs/0tDPowROHtGfxA4p+Fdvn+
	0piR3vZIvaZufVwWXAlk8oP6trMjVvpG+NKr7lyeggFOqpKwGTBMp7dNlY7aWbX+iLjID3
	/qYf6Nzv9vQEmGotJ3VY7xXm8K+I92c=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-358f058973fso1103323a91.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310326; x=1774915126; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z81MLxHKunKSpfd9G8Gazc1UStxzf4ZSRozQrfTx8r0=;
        b=RVSDAG4H3LTQdZmfTQs58UVgSsDBxy+dcLb9psty+g5sHguVzuyiZgIQXtS7AVQhZq
         9C6v1yAlUXjrr/GTQug2aIDEFnrbgCSf/rL4aGjNVQPg3yQ0Pd7M2xDOzniAttP/AFIs
         EDVKtO3/7uCXg+bDkKtpZq1jdL1AIdjjrDHkNqDssr9CBcHflptleOMXfHy2vkmfBnoZ
         UIsNbzi2gPhOj6Vw2MXeQ23GbgWvtbtsaR/tZfwkz9CF8V/e3qPoLktZGckgvOUWMMwC
         T+MmwfV9nkAlnz2FzdgoqfGoMIVb17VZm8dWYSGgs/M+JLpxEMXDXuoIi0/bEivISAsR
         +KZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310326; x=1774915126;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z81MLxHKunKSpfd9G8Gazc1UStxzf4ZSRozQrfTx8r0=;
        b=pnspcSLTf4c9gG1nt7UjxDXeqoywUMo4O3l3YaflOu4uQ8M92UuX74KZdDJrbDK0Dq
         DxnqKp+VkljJtofXD4+DtKFTwyeRVq0M0MTg4B+STdkKlesWcnpG0X3l0exeGu0AhqFD
         nBJ6sHwLqsJrij8F0mvU/kGW/52NT1bgVlaStfweZ7H8Smorh7yIKD53XtBP2sHFB5Nl
         LEiVFcOMZ/EeJwR44adTKLwFsjWgE7/tQ+pwQkyPGuQ9/u5ZqFhY7E2OhU0O1DsSU63V
         I/bJGJ4wxQxo3Bv7adPJ9+MTJyEgKVGTRmJ/I+0Bkx0JRElmvsk3jJ4QNJLEn9USou0P
         VDJg==
X-Forwarded-Encrypted: i=1; AJvYcCXqbEqH9qKWBGbDwnZy7wGEOxzDThqIhJNznw2zn+co5oh9g1qw7fJIIrosMz4wNAHHSzUWXmGH2Q==@kvack.org
X-Gm-Message-State: AOJu0YzZdAo5lIfd6Gkml0ncYBPr5IFlMhX1ZY7UMJSYkUXW/hQWQNoy
	FXCx72Z+441fVfMvmTvddfhQkV0OudcNzdTIoMr4yFvjo3Od84SnfQernTtDs0sUvdoNtaaMrpJ
	iRnuvpbmEathjzw==
X-Received: from pjbfs13.prod.google.com ([2002:a17:90a:f28d:b0:359:979d:cee5])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5390:b0:35a:275c:4c27 with SMTP id 98e67ed59e1d1-35bd2bba27cmr10391028a91.2.1774310325767;
 Mon, 23 Mar 2026 16:58:45 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:57:57 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-6-dmatlack@google.com>
Subject: [PATCH v3 05/24] docs: liveupdate: Add documentation for PCI
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Feng Tang <feng.tang@linux.alibaba.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Li RongQing <lirongqing@baidu.com>, Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 31CEC140002
X-Stat-Signature: zmpjjdcf39ooax84rrsntxq35mf4pwqa
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774310327-628630
X-HE-Meta: U2FsdGVkX1/ziOqI3Gnv6z00a7/vR2YQjRQoBueGsz7cUFPAepM/lnf2w3bVKrp1gXJjcBGfFeWjYokqYLslNezeUfE84H3k18WUI/2dgIjs3cQH0n2tN/WvGdHVyBBGeuGHKDlYciaFb1e3XkUTS04DAM7brlX8o8o0LHe9z4I3fxCW3PC9KSgz0nor32rLprYU/5qsD8LtEVmV17kPW5hGStR0DCZIn/usXGErNCVp7QpFIuB1KYaep/Bt7/gBn+Pk8MuI4YqCHfgGgAizJeb9W3O2ZjMmh5EyxXEvEQhviJdMWl5vO9esgXwFvLvQL1SKe540IXiEgFSB+oOp5pV3OKzDxSvs92q3u97weE0fkC5UnPKzFIk1rIt+B396VSUszFoCR7Nguuk+xO/p3+iNiALHTaXHP1IoAOrktxlqhXYroPhNQxhrmfAixvS6dwCVvKZ5243su7DTWcW272Uu25HO376QhFwwQFZ29mexCT95bRcQ/ClqA+iuSOciHMn+OOqwrYG/oIDWYDOnsjW6jcNSAavEQ5QlhsJWAaDoFUTO44uG0RDoXJsCv2fM7eLt3B2uSGvesvI2S9H271ZLVhC38YUsmPZgQWeIyXSpBSIXaBBKyNGv826wOsWEROmvepic5Gx/EvhqE75ATZj64ZqdtGekz8mO+JxoE5oBkn14DZzgyB9Uzt8vwS+zvh8/4tQBCYpwcCSd3Bo8f6KTr7nqD2YhFTXiomrB/maW7rQwEKiuTN+olHZsVh4ML0nqP48NuULEoFt3zeG+0iBG8HIkixKQ+Ki7PfeOa0ha2SgPjh7x1FTvKqzkHQ78MsXGVLlT6zDysPmpPb6qxxln8ji/Bl9YpOosDoARh59c0cI/roP9TFRAtcdWlV8Oh1IPQBNKaYysd7umzmNhfW+2setqFmkQHEsyBnu8tkaRdxv82N/7ajP9v23pscdTr8c9Vq3nYpQo1a6adFn
 J0K5Iz9+
 UeevKXPJKVszOJBg/hbnJsxGdasiA/OE42FO8j66/1xpx8DAmZ03dHv6lLvY/6yYjKhw0KUY0GKm5648lceoPQYe85oVaY8vcA/s9gZsV3W+L0FPzLYy7iUlj4It74EviVnEf2Mofy06Oj+NwxypNBx807s84hMVa/1bCitS4WL7kiPjLAywDO2zVEOjFi9C31HxlhLdLEfoEcNvsgq49g+7cgdFCdHY4BMqbZ+JqSyV9oGfGcwiizRxFdZ3J+1ZbVELm+rntoVMk/YGREUnhE67MqwtShYGnfKTkR+nbIAAcEk7SQ+29LY9iBkuPq4skIt6rSCb9O0F4MEtaFoJF2Kw7eqYdHpr96ahJy61i02CuenhVgJgio5Ug3+PV0hzQPIZLnyf+gY1zHTbPjWFH9AIzEBPPQHia0ZVpgr+crWECioAHvLNDGh4BgD3bdqVuYAI2wZdVrlL4Nq9qUP6ij/LvBZVddWtnMqPF6ZjKuRuIPNjlfueh0iTZglFbw8Ki8y6fc+4FjAS18csdZWiq10PUZm3NqX7SdPKRMqRQ7neE+EPzZ9LGXOdFAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation files for the PCI subsystem's participation in Live
Update, generated from the kernel-doc comments the code.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 Documentation/PCI/liveupdate.rst      | 23 +++++++++++++++++++++++
 Documentation/core-api/liveupdate.rst |  1 +
 2 files changed, 24 insertions(+)
 create mode 100644 Documentation/PCI/liveupdate.rst

diff --git a/Documentation/PCI/liveupdate.rst b/Documentation/PCI/liveupdate.rst
new file mode 100644
index 000000000000..04c9b675e8df
--- /dev/null
+++ b/Documentation/PCI/liveupdate.rst
@@ -0,0 +1,23 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+===========================
+PCI Support for Live Update
+===========================
+
+.. kernel-doc:: drivers/pci/liveupdate.c
+   :doc: PCI Live Update
+
+PCI Preservation ABI
+====================
+
+.. kernel-doc:: include/linux/kho/abi/pci.h
+   :doc: PCI File-Lifecycle Bound (FLB) Live Update ABI
+
+.. kernel-doc:: include/linux/kho/abi/pci.h
+   :internal:
+
+See Also
+========
+
+ * :doc:`/core-api/liveupdate`
+ * :doc:`/core-api/kho/index`
diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
index 5a292d0f3706..d56a7760978a 100644
--- a/Documentation/core-api/liveupdate.rst
+++ b/Documentation/core-api/liveupdate.rst
@@ -70,3 +70,4 @@ See Also
 
 - :doc:`Live Update uAPI </userspace-api/liveupdate>`
 - :doc:`/core-api/kho/index`
+- :doc:`PCI </PCI/liveupdate>`
-- 
2.53.0.983.g0bb29b3bc5-goog


