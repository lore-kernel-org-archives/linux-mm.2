Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F8C2C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F49C6B00A2; Tue, 11 Aug 2026 13:53:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A5EC6B00A3; Tue, 11 Aug 2026 13:53:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 294E26B00A5; Tue, 11 Aug 2026 13:53:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E99626B00A2
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:53:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7FDF612018C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:53:25 +0000 (UTC)
X-FDA: 85089735570.21.3C59DE0
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf25.hostedemail.com (Postfix) with ESMTP id 81EB0A0007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:53:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=QkWk+O+I;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="J DK0hyL";
	spf=pass (imf25.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786470803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=drS8nyfS/5n/9X4otzCRfuA2cT+uvRCf3SjirFiIRoo=;
	b=kJK56J+YpS20xYmeB1TQruG8J356UENhx+OuXmDmlV0D+9tNpQhsV8lR8D+cC7176pC9/d
	NmNBHR1df3ttffOJCtI2ORWVA9Dx27gts5+COy8aJJ1IEZAGf+ioCgd3XxAExvYFCEPAsO
	hKQbY5HQLyAbd7o0CoPNEBd1KReadyc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=QkWk+O+I;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="J DK0hyL";
	spf=pass (imf25.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786470803;
	b=EkbKZDbKFw9gY/nDV9fIVGPDVcjV8lS1guLQMGUQGDYb88koVC2kiwuJbINsX1/qxwE8mx
	J4F1rCbQPsLSBWugBOvGTl020NP+BQA4qs/T7x9of8Rw2sLMT2RDRhPvmXmmYwFU+SGxef
	vhbRKGpcYYyE5L2aEvZ0FM2uzIL7tQk=
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailflow.stl.internal (Postfix) with ESMTP id 6B744130016C;
	Tue, 11 Aug 2026 13:53:21 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Tue, 11 Aug 2026 13:53:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1786470801;
	 x=1786478001; bh=drS8nyfS/5n/9X4otzCRfuA2cT+uvRCf3SjirFiIRoo=; b=
	QkWk+O+IqbOXXrBukMGBQdbUdPA1KgNBvThM4OEZTKN8XpOagHUofAFG1d1GR0ao
	/lYX1uSnQOpRvbvBo8VQVpXEd+yKNzZBvE641sl2Ttw5KCW90N1yb9Xc9aWTvJ+4
	xvr5xnDrHDEAkJAPTfIN+w27hRJFgxz3k/73vpih+tg+BRUVzXl3xyjuCF9AKkX4
	ui+Mo0rDMoxmZpHVqNTF0DmWMAdRdfhWu7pk5oTYovuv09/KgDB+MZdvbDavQSH7
	rx6blAFkBeLVeUMUFKx5/AfC7mkG2ceQc6gSeO3jDjRn0c9F7A50k4X7JfQdp36W
	DYaXkdMfmfOE5iyBgwWj7A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1786470801; x=
	1786478001; bh=drS8nyfS/5n/9X4otzCRfuA2cT+uvRCf3SjirFiIRoo=; b=J
	DK0hyLPHLvx4qRVfCyhcGaY3Y1afb/Vr6BSxZ+SPEkbntfgaOn3F/kaQ55e/DxpY
	MF4ppmUTtSC+i3NwhKwiUU8tVt5edI7hjrpkhlgm8jHHb/vnsiqQlbQmwKe2gElS
	Yxt8h5eVOzzYCSAw9E8TNszM0vfl9lRNNiykjDUWSsSaaRdIdHpBElBkLvT+wo7h
	LF/926SMCsrhNUHaIx06eCNigbGYwQwANiIXGVuTJEP2ET+U0v8jnyrTC/LaUMFm
	3U6E0p1RUXgaQrWhipCy3DiU6Ztdr94fYDc7ollSUWH7sZHSzTojL3uivjRFAHCg
	cTMFmqJEuklLuwg+uoKqw==
X-ME-Sender: <xms:kWF7ahPL-vL3tF84f1TFR9W7IQw7kPkSUVz234bdzUjweCdAL6k4-g>
    <xme:kWF7aqh25gYsUv1Slr7d0IyOkpYuU6WDllfNUjmUCT6qyUKRl-zshfE0yW7h9ZfmV
    ZVd1FTHJXqI7KVbWSRN81HrjwJFURiy9FPpCGaD_fUsX16NC8CcmA>
X-ME-Received: <xmr:kWF7atAKnwG_L1Az0VDKSMi6BdZRPeBv8cEo0ZDxj9uHgueAY6Z7Fe5AyeSiirFdNPrA7RsCuIiD-TCb3SZafg8>
X-ME-Proxy-Cause: dmFkZTEJEGuCgn7zSteBDxNtSJjV76+V4CnevXg+/HpV8pBcUcuiCNODIEIDrvYJtfUig4
    YbV/QY7F/5FmNh0pRZPVmKSRgYy7+KF1hyAgmaSBfjrBu1Tf17UBdgE0OKLaTkwTcf35M8
    A3BG9gU1kUODTHqS0pdsippevO97iASgI9eCstdiieZcmNJMxjp+Dk/kb2yyT19QSKiq2/
    PYmZLQclF7ZDW1mh1YN6ilSkOCjygxJsr5eR/wz7HE2fkmdnLW9InISWV9kR+irzxvtO9I
    pnBZF98lSAmI852yZY0IsRjcC4lEqWDe/NVDMPZFCYAeAfD86idfVCQ6A0RRy8MpCwFrGi
    JaamIhViNAMRkMCXjV9YL6sd6IHyq/tf2HlfDMjgIP2APCVaZFFwrE7zrV7ovbBban3Iu7
    W/Uh5FMdKsGj5pZx7P6MCTneY76byI6K9C/6cbEqr5VdWRn4duFZrtBn2D1tYrI8NiPdWc
    ppdDBXno6JjG1NA7VgMw1eNcNKfSPsYaWA1j2XBlxJK1+DKisAb9rbUMzR+NeEbFpeQxKg
    w7AZvvx58bqYqiXZjVrLVsnJ4IKjr0WeLWQcsrUy/zeFdUPOGwdqK34r2DtI5AwmetFmPP
    0W7aqfZ35Td15bHqKqCcppuR1Zm69cCvNfIMnYwrbZbhpOtGuGMgQK9/Qtsg
X-ME-Proxy: <xmx:kWF7amVlkY6EEuDIyC0WoxRvqtGq5ILKX5as1F-XLFce9eQpdiS7uA>
    <xmx:kWF7auOvnvXF8D31HFphofi61ah5tcQFkBu7TeKHgioHgv92EAB4_w>
    <xmx:kWF7ashsgsVXibL7meABAHFLlo7CAUmBCG9_7nrRcUqZrWwBnbtGiw>
    <xmx:kWF7artRJK5afcegwONALqXLII5e98jHTVHA6TFoouW-ondHQiaCzQ>
    <xmx:kWF7avUG4Ti3NfPHjv73nO4mc1ldjlFs9gNabtv2uLpn8YPIE-JzZ_ON>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Aug 2026 13:53:14 -0400 (EDT)
From: =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Date: Tue, 11 Aug 2026 19:52:51 +0200
Subject: [PATCH v2 02/13] crash-core: Flush caches on CRASH_WIPE_SECRETS
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260811-crash-zeroize-rework-v2-2-9561d13c2340@jaseg.de>
References: <20260811-crash-zeroize-rework-v2-0-9561d13c2340@jaseg.de>
In-Reply-To: <20260811-crash-zeroize-rework-v2-0-9561d13c2340@jaseg.de>
To: Andrew Morton <akpm@linux-foundation.org>,
  Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Pratyush Yadav <pratyush@kernel.org>,
 Dave Young <ruirui.yang@linux.dev>,
  Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,  David Howells <dhowells@redhat.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,  Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
  Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
  "Serge E. Hallyn" <serge@hallyn.com>, Lukas Wunner <lukas@wunner.de>,
  Ignat Korchagin <ignat@linux.win>,
 Herbert Xu <herbert@gondor.apana.org.au>,
  "David S. Miller" <davem@davemloft.net>,
 Keith Busch <kbusch@kernel.org>,  Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>,  Sagi Grimberg <sagi@grimberg.me>,
 Trond Myklebust <trondmy@kernel.org>,  Anna Schumaker <anna@kernel.org>,
 Mimi Zohar <zohar@linux.ibm.com>,
  James Bottomley <James.Bottomley@HansenPartnership.com>,
  Marc Dionne <marc.dionne@auristor.com>,
 Eric Dumazet <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,  Simon Horman <horms@kernel.org>,
 Eric Biggers <ebiggers@kernel.org>,  "Theodore Y. Ts'o" <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>,
  Alexander Viro <viro@zeniv.linux.org.uk>,
  Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
  Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
  Mikulas Patocka <mpatocka@redhat.com>,
  Benjamin Marzinski <bmarzins@redhat.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
 keyrings@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-nvme@lists.infradead.org, linux-nfs@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-afs@lists.infradead.org, 
 netdev@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev, 
 =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
X-Mailer: b4 0.15.2
X-Stat-Signature: ssp7fm1y5nza4pyr4ayzxb95zjem9kxi
X-Rspamd-Queue-Id: 81EB0A0007
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786470803-143938
X-HE-Meta: U2FsdGVkX1/XbpoWNP41Yq4KxPaDPwG0sCYrnU4Qz2mP7m73hfa4H6MPT9yX5X0eL6mCNaaOKb/N6RhFIWnmij8zenwN8ojAbFYWTW+9a8vw+28Sjw8JScNSd5brh0pdoiBASArTpaGfkRci1uZw7tZYaiRZEbsXj2BFhyG/DgThmWtbOgNT/dGhfJGRjvLHG7h2sawTaYFQLx0BgE4ffov6Pk7o7LyorejwqQMM81V9P/YwzRoDOwbzYYMM2XTxctn804ng2/SdW0hgGBLKJnUCiTll85M0Xg0rSaX4kcgYIEn9Sqgnj2qcbd4yzvHvt9kgnIhUDcYkdjdOUNQJELbAtTkOfzfoBYHfLJ0EJnBRc/ZORUCaU1Rlidd6rQonvIFZBTuCZlTysXx+f84+gMcfY4TVzqUL8rGJO0Rf1MrjQXcCaKHt5bfBdpKpSosQNzhxSnyUtbFE9a2zR7y1cA9++DuXhq+pyV0dim97zWnOk+5+DU5gwIpNitdoqz8itmo+h1obKMLgzp5kc0ft1Xj9buJBcy5CymGQ56Pqj1y8SSb1/WXOzknsW+FiR1Lr8Utfw1nHer3Zl8a/Minv8W1s+35Y+Pyjx/jvZ1Jrdpr8hJTY1l39YBc0/rDrO7FRMCnod1PKP5hqOn/i8RSEw2l/QMEZKq7lnpKcLd6gtEAVZ+twqULECKWTd7tnJAwqYvJDxarSVJlUBTyRZwnBKBjsHZoI+6VvcD/tNCWU2KB0rIGAbrmN6gfqB9wkuFmt4VlbOeViTA0yCSJnAI33cCJNA3TLBntlKGQrExwU8kpq2UiRDF5V0u+OW0K+0TCSjSd+3iJGU3WLZ6D4vXnFin2WCvLXcau6pYEcfvGo1YHOWfnnZn9xkPc+7qDU+LqFnUaOth2fO5g5TDJWvzJ3T3+VrgB2OAyR1yXAKwx+dfIjGmf+R5c+1DR/+Jlwvr3pjf7cEQPZR0ZF8lQqASe
 gLuMuLPI
 Hx/N6uXL153T4hHhZVkNF5xZRywoCDDRG2ODpHJKMhxA8qoLkXCyPnMvCEtx+xva8H5JlIgDwrqNRyeoc9VgtMgr2vsSleODlM1AIovhwFuAKbdTrLFxgeP81PZyUZ1A7Lhi9HXoP1+CNEjZ0TWijm/BDDZqR4uI7uDtjrvRWxOpVs/SFw6FA7E6NTVPWdcwK6fSKU/Tn9Tk1koN9y5PQc/pg0cbAM7Qt2vU3CyOQAETK4unYwCRJ02c02Nm95ZMR9K0lVr5g/t30BI6TsY6e1S3xsOQNOLzmEDeqiLuGjvynt2ZZecZIvl5AeV+z/RMIN/ipzstPJvt5XNLQQLxE/rff88a3RqX2qkcDI/WgOnPdcnKS4rvGGObu5e+Vt2fCRa8cJqwbewqx4myZ6AP6siE1IjjdXoD+hcBQ8supuUSY9zbtIcx6RDwAu8cAfJkhmbOa7IhouQkKMnbXMzIkEniqCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace memzero_expclit with our custom wrapper that additionally
flushes the target address ranges from CPU caches.

On ARM64, while memzero_explicit is already reasonably reliable for
wiping secrets from memory during kdump, it can theoretically leave
residue in DRAM when the last memzero_explicit writes are still in
flight in caches when shutting down the caches in machine_kexec.

We need to swap every memzero_explicit call because ARM64 do not have a
wholesale "flush all caches" primitive and only support flushes targeted
to a particular address range.

Architectures other than ARM64, notably x86-64, are not affected by this
cache flush issue.

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
---
 arch/arm64/kernel/machine_kexec.c | 20 ++++++++++++++++++++
 include/linux/crash_core.h        | 21 +++++++++++++++++++++
 kernel/crash_core.c               | 23 +++++++++++++++++++++++
 3 files changed, 64 insertions(+)

diff --git a/arch/arm64/kernel/machine_kexec.c b/arch/arm64/kernel/machine_kexec.c
index c5693a32e49b..12bf3c90f519 100644
--- a/arch/arm64/kernel/machine_kexec.c
+++ b/arch/arm64/kernel/machine_kexec.c
@@ -6,6 +6,7 @@
  * Copyright (C) Huawei Futurewei Technologies.
  */
 
+#include <linux/crash_core.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/kernel.h>
@@ -15,6 +16,7 @@
 #include <linux/set_memory.h>
 #include <linux/smp.h>
 
+#include <asm/barrier.h>
 #include <asm/cacheflush.h>
 #include <asm/cpu_ops.h>
 #include <asm/daifflags.h>
@@ -221,6 +223,24 @@ void machine_crash_shutdown(struct pt_regs *regs)
 	pr_info("Starting crashdump kernel...\n");
 }
 
+#ifdef CONFIG_CRASH_WIPE_SECRETS
+/*
+ * Queue each wiped range for cleaning to the point of coherency.  Deferring
+ * the barrier until the notifier chain is complete avoids one DSB per range.
+ */
+void arch_crash_wipe_range(void *addr, size_t size)
+{
+	unsigned long start = (unsigned long)addr;
+
+	dcache_clean_poc_nosync(start, start + size);
+}
+
+void arch_crash_wipe_flush(void)
+{
+	dsb(sy);
+}
+#endif
+
 #if defined(CONFIG_CRASH_DUMP) && defined(CONFIG_HIBERNATION)
 /*
  * To preserve the crash dump kernel image, the relevant memory segments
diff --git a/include/linux/crash_core.h b/include/linux/crash_core.h
index 4230463f3faa..d3e4192b7e6d 100644
--- a/include/linux/crash_core.h
+++ b/include/linux/crash_core.h
@@ -6,6 +6,7 @@
 #include <linux/elfcore.h>
 #include <linux/elf.h>
 #include <linux/notifier.h>
+#include <linux/string.h>
 
 struct kimage;
 
@@ -15,6 +16,26 @@ struct crash_mem {
 	struct range ranges[] __counted_by(max_nr_ranges);
 };
 
+#ifdef CONFIG_CRASH_WIPE_SECRETS
+/*
+ * Record a range that has already been wiped, or wipe and record it in one
+ * operation.  Architectures may use the ranges to push the wipes out to
+ * memory before kexec disables the caches.
+ */
+void crash_wipe_cache_range(void *addr, size_t size);
+void crash_wipe_memzero(void *addr, size_t size);
+
+void arch_crash_wipe_range(void *addr, size_t size);
+void arch_crash_wipe_flush(void);
+#else
+static inline void crash_wipe_cache_range(void *addr, size_t size) { }
+
+static inline void crash_wipe_memzero(void *addr, size_t size)
+{
+	memzero_explicit(addr, size);
+}
+#endif
+
 #ifdef CONFIG_CRASH_DUMP
 
 int crash_shrink_memory(unsigned long new_size);
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 95f5c0415e60..42faf8d0a4c4 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -51,10 +51,33 @@ int crash_wipe_secrets_unregister(struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(crash_wipe_secrets_unregister);
 
+/*
+ * Some kexec paths disable the data cache without first cleaning it.  Give
+ * architectures valid virtual ranges for the wiped data, then let them defer
+ * any completion barrier until all crash-wipe callbacks have run.
+ */
+void __weak arch_crash_wipe_range(void *addr, size_t size) { }
+void __weak arch_crash_wipe_flush(void) { }
+
+void crash_wipe_cache_range(void *addr, size_t size)
+{
+	if (size)
+		arch_crash_wipe_range(addr, size);
+}
+EXPORT_SYMBOL_GPL(crash_wipe_cache_range);
+
+void crash_wipe_memzero(void *addr, size_t size)
+{
+	memzero_explicit(addr, size);
+	crash_wipe_cache_range(addr, size);
+}
+EXPORT_SYMBOL_GPL(crash_wipe_memzero);
+
 static void crash_wipe_secrets(void)
 {
 	pr_info("Wiping sensitive secrets...\n");
 	atomic_notifier_call_chain(&crash_wipe_secrets_notifier_list, 0, NULL);
+	arch_crash_wipe_flush();
 	pr_info("Done wiping secrets.\n");
 }
 #else

-- 
2.53.0


