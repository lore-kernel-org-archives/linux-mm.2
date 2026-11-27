Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D3B6606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PS8HWMwM
Received: by kanga.kvack.org (Postfix)
	id 55A5B6B05BA; Fri, 27 Nov 2026 17:15:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50B716B05BB; Fri, 27 Nov 2026 17:15:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 420AE6B05BC; Fri, 27 Nov 2026 17:15:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F27AF6B05BA
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:15:58 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 48F2D140516
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:15:58 +0000 (UTC)
X-FDA: 85482307596.06.413AD21
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id 742A920009
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:15:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PS8HWMwM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of vitorhg20080@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=vitorhg20080@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795817756;
	b=5oTaZ8W7rDrCDTsgVv7/eg8xlJaYXAX+lOoHjOWRYzvajAXKE1TwE4p1GB1zLCgtXLFEFo
	RMnrpHqMaGMawrjoVIQndMHqZSUPJU78cc/TgIdddXmqhP77Ob3TmFuyhkuCJ3yrf9cXvc
	cSij2idg8dIOgp+DdrcxB0VabDUCEG4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795817756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OerVEdIvJXdeIvWP8SxxgV/sDV2JyFJEP6u72p5i/Oo=;
	b=lVPB/cVByl9DJMwqN53+QtHqWJ2vzljgtI+Bx0zKVDSRkVjpHtyIeqgbLlkT6eZEFmD6Sf
	B61EXX4UAmd2jfdMHqSnoD1kWAD7Hu2Xbb5qSJWZjLJA4R622AkZTgrBLofmamV3GtnqKt
	h5wDuFkhXA+wMGXb5aWbT/Lg9O+IC1E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PS8HWMwM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of vitorhg20080@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=vitorhg20080@gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4bb606491faso45218355e9.3
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 14:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795817755; x=1796422555; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OerVEdIvJXdeIvWP8SxxgV/sDV2JyFJEP6u72p5i/Oo=;
        b=PS8HWMwM3/SIrDDS12nxf0VFAhf1kJBhdk1IYYSTWeyel1qTfyI6OJKEKLafqCsFmg
         mbZ9ztRoF6RKSTNvwGsgkooFamu2Wo/pRkbWb8pyCeOp655E4B26tmdHpbkn0+c3JRuJ
         2L1wx+H8xu1DKmOyOFCbmuhLy2897EtWs6ruzsoEMlZ5AbbLv6x0/QfS/l3Uv136qvdl
         N6LDnHLESqOJDayGTMKORXgovAIu9lR5DC+1iYQNltZ6tP+X607B1U0psXm13A4LLVjk
         g54+yVYImgRSrwK4pPx62/AWcqwS/UDRZ3nLdqzHkXhygxbkg1e7YUhyB15Urv0LScQY
         OL2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795817755; x=1796422555;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OerVEdIvJXdeIvWP8SxxgV/sDV2JyFJEP6u72p5i/Oo=;
        b=OG7xben55ZSkWop21EvcExCRA3ZOhNRv9Ut2fBKTrIl/tQ3aL19k+dTTuUJu6pH7r/
         WBIjVU34MB3796mk9ECSoXaGmc7SIF5IBvMOPyHXECZvkeFMplXFvUR70vIO0QuZOgYF
         fC2PTl6Go2NUiIM8/5aIdEWkpf5MzVccQFosIVozVM2zPFsF+JBDHXReZVCU2Qxa0fZ3
         sz5XLBx8BqR8Tj8V7rlqE6O1yKP9OiPs/8b4hl3/OIO43Y6u+FhSZL6rlxSxMFKJkj4+
         p8Qc4YchrhQIbc6g6vYS9V4STxhy67lkIh29ygJRBvV8FEoybKzjZKfBzbAgH49/pwlE
         j9cA==
X-Gm-Message-State: APuU4Z8b1KY5bThV0ZnWEC6hOfWaq+dO8agTNnPv6ag67kXoC8W7OjgX
	RXHn5PW9/rH9/WAxo4cr8dI67FbjGWTpTqGLbpMBtCZFTqtL9hntSoZW
X-Gm-Gg: AZFdTZeMFEwfb6hUlbBIan6lwW/hMzb0/NXFZFXcioyqAqvVhiIkXcfKGt53WmO4sS1
	9V376ld1UZbJtwTCnn15bszryiKpilPemJLtUWPIMJbBKx9DxBQQ46de9LS5ip9vJnPlzPBOvLj
	BiaPechrYwdRkLBlC7EvjEKi7CBhcHePjSLoKXBbRtqPNPyO18OA2H/7jphvirrl1v5EHJf9RDX
	3nclkimA5nFmn6NFrXxMVXLB3G2siLhPeiSrSE2oXXLW7Y2RHZcJTHuadMbAo0oFKPxvaQcRmRq
	dMOPLr04qYUdqfvw87e6JAs0MggDUZdklZuUgr0S05W9zsIh/SQm89B8mapYFpJYn6XMCr3HVdq
	zswU7l4a4qkaZJO7sqg2UH5gR9EpxSYgyAtbvXRHvaMvUJksIN7uCETByBGN1UOUkEm9Cg23MbN
	zS5Z0RwCrMzxHI/l4K8w9oq2MgkUgSvvc0YVfKNWUhITEWho8Wbal/fnHOzEFAU46TjIeYXrTMz
	wja2H5o8iZGfI0JxAW+Vz0pwv0rCecRdcH0bdUpDT+cpgeIC8Iyo0JJ9obnrxXKoNBksG+zG5bh
	MTXo/4vyeiAxI5cUpD7kt7Xee0YbFsCru7VzuhqsD/8t0cPAGKhF5BXQTnPju6kixjeIvKKqrtc
	vS24X4/k=
X-Received: by 2002:a05:600c:a085:b0:4a5:26b8:4507 with SMTP id 5b1f17b1804b1-4bb8881e6c6mr508013085e9.21.1795817754689;
        Fri, 27 Nov 2026 14:15:54 -0800 (PST)
Received: from localhost (bl20-90-91.dsl.telepac.pt. [2.81.90.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4b70c05b9desm25203563f8f.54.2026.11.27.14.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 14:15:54 -0800 (PST)
From: =?UTF-8?q?V=C3=ADtor=20Hugo=20Silva?= <vitorhg20080@gmail.com>
To: linux-riscv@lists.infradead.org
Cc: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	kees@kernel.org,
	david@kernel.org,
	sashiko-reviews@lists.linux.dev,
	=?UTF-8?q?V=C3=ADtor=20Hugo=20Silva?= <vitorhg20080@gmail.com>
Subject: [PATCH RFC v2] riscv: Synchronize instructions written to ESP32-P4 PSRAM
Date: Fri, 27 Nov 2026 22:13:45 +0000
Message-ID: <20261127221346.197911-1-vitorhg20080@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125233020.1380594-15-vitorhg20080@gmail.com>
References: <20261125233020.1380594-15-vitorhg20080@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 742A920009
X-Stat-Signature: kygm76e9oemsww1and5axkxinzeqh4iu
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795817756-676703
X-HE-Meta: U2FsdGVkX1+BVmHaCQDAhL259rf1ilw/XFr15KNEq3yp5Pc/L0nxS3kMVjkSLmA/17QSxmICnAwRrIZZPElnTFd0GXx2bucEMBMM69kOj8TwSHvz+Xrky/yizBOSsduXLQeX7LtRMeKIXlk8W6eVhcX2g51ALl3PbhuIJ0ccTAGpv6dBtk1ie5TJHUjRmIGvP4/6SuTsjEnOxd98JGC7gt54h6Dv3AAmwCbMP5Lx0jskKhA2mrv27UlMu1Hv6vMcT94EZItxrYLDchH/BjtyBA1AB8TaLbWPUsmsiSgqv92lbwTJtp/0QdmyHQvf5W6agyESQXi+T7cEN+02ZUHpv7MXS0MjR0YDMCXX2/PRJs+L0xNUpZcKxtUt21qce9krVXBCGey2WH45d6i0GGE4rT+XCHrv+7QgSkk2glRlOHHq+0rszfnIb9qkQvn80Q2h5rE2YkKM8C1Ktxsh5aDekEo9FnxshgETzvgWkRDo9c99TQvc6XxCrlucylvzZQJ8SYoKchh4Kw6qgRy2nYt/Hxty3hjQrBOBxQkqUUdPXVdQrf0pGRyitd70syaHEMGfdkP5brYyCyfQHeWh2fZlwXLSXh8YL8xjjpeZp4opsh327AHpOL2KTMFfD1+vM9AW/rpFVDEhKUXvpWc7qvqXhzxgr98SjkE9WHcpcufBCJr7UyiP+qcpa17cKJWVai0zSW179ONWvGGvbL7bnkQjHwxsBUKAZ7NBf4BrzJN3Y1BywEYwHl3J6GIPL9yJNgLRQXD9BlnZXWFZBE18QVUkC1MHn+/wqawDa04NQnXYa0YbYptwn913QZkQLDn7KnKMGvrjtrhi0lGtq+AIuSmLXzNR5zh2QAFTtC6a4YjJThMObTZGJyIPsnS6Y5V958BbkQnEcHqNwVsrMoez/V//7NmFvNXXgXgma8HiW77yfVI/jLIB9qDS9esiITx4b+Lsa/jUEb3MhWVSoAxjkRC
 z9yjdhgn
 GOb3eJOlRGqGoHag3h5AEwrwTLkoOs+P4CPbqiYpcU75/QJbr5oCwcHByksMHbSTdGmLwUzJXQTtR4VMBB6ywexktVCKwcRGwi9DqKJ//5AegWPgAzxc+tvQ443mZUEGLL0uqGUZOZ1kWMS96OABAYDKy9uEnhZVOdrhSDusPwq/1rKidm/9dGF2XUq9HYKWmaC2v2cg474nLPdYG43K8o+dpN0MFcLZCBMUBJFuLq3rAlFcweNOGPJsnfXthRHTgyN7XicyTFpIByU5kFxXadElWG1mZzSjVfFAArNdCT++eN29oCOkNngNd0XHBFC081DMc2/WNKSKMpRPXt7fk/m/M2EpTMhN01g7i+arrEx3zvJFtwnabDVWb375ESAtIsa29474YVWaQMfee24zHTk1j7ZWMSnWKev5vWGOEEgslv9AnjSZAkkyyQF/V5lbFYgP2tzKclLYjlmA2AVm4CoLnmfGDmp06664L4GuezjaAn9caxyuLDt1seIw020KBsjNCfo46nXCojZpeFXyNpk+WyNsz8OcAexIfRMGbfyD8sSNmQ/PXzV483GcsYMAdw1Fs/GAJez8YyfWMSNAimFwV0yc29c7oZMAbPHv1g2R8qfdLFdTvqC+kRD/u/MkhP3oO1pXdgKMkcCHWXbVoMdyWGB59BldIEJ/LLBHR1XOI7SXc0a8alvkFCrL7UyE0bSStY+LCrwo1RJOieVGo3Y9Oj+UibH1JsMpLDEMB9kN6/MqmRTo6B1jmF6XkqJ6vkC4h7iFHR6qesj0dKrPIHJt8GbDqBRZt5rF6sk6ny/DsrEk29Syaqrmd1+NGY83+G1HDsDijqu6Yblhwq6TNMDLelr61kANBiFRcNibrKlZf5Xg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On ESP32-P4, loads can observe updated instruction bytes in the data
cache while instruction fetch still sees stale bytes. During boot,
runtime constant patching can then use an invalid address.

Write back L1D and L2 for the affected PSRAM range, invalidate L1I
and issue fence.i. Use 32 KiB chunks so interrupts can run between
chunks. Bound polling per command and stop issuing commands after a
timeout. Treat failure to synchronize patched kernel text as fatal
and exclude the synchronization helpers from kprobes.

Use checked synchronization for executable loading, signal return
trampolines, the first executable NOMMU mapping of a region and
growth of the NOMMU program break. A failed mmap synchronization
discards the new mapping. A failed brk synchronization returns the
current break.

On ESP32-P4, honor nonempty intervals in riscv_flush_icache(). Check
that the requested interval is covered by the calling process's
mappings under mmap_lock. Return -EINVAL for reversed intervals and
-EFAULT for gaps. Propagate cache synchronization errors. Keep the
existing whole-cache flush for empty intervals.

An earlier board test reproduced stale instructions after fence.i
alone. On the Waveshare ESP32-P4-Module-DEV-KIT, a userspace probe
received SIGILL at the first instruction written to an executable
mapping with the published v1 patch. With v2, the same probe executes
modified instructions after riscv_flush_icache() with flags 0 and
LOCAL. It also checks return values for unmapped, reversed and empty
ranges and invalid flags. The board boots to a shell, runs bFLT
programs and delivers SIGUSR1 to the shell.

The syscall also builds with ESP32-P4 support disabled in an RV32
NOMMU configuration.

AI assisted with the cache paths and the test preparation.

Link: https://docs.espressif.com/projects/esp-idf/en/stable/esp32p4/api-reference/system/mm_sync.html
Signed-off-by: Vítor Hugo Silva <vitorhg20080@gmail.com>
---
Changes in v2:
- Synchronize after filling kernel text and exclude cache helpers from
  kprobes.
- Propagate synchronization errors in NOMMU mmap and brk.
- Validate and synchronize the userspace range in riscv_flush_icache
  on ESP32-P4.

This replaces patch 14/19 and applies after patch 13/19 of the RFC.
v1: https://lore.kernel.org/all/20261125233020.1380594-15-vitorhg20080@gmail.com/

 arch/riscv/include/asm/cacheflush.h |   6 ++
 arch/riscv/kernel/patch.c           | 146 +++++++++++++++++++++++++++-
 arch/riscv/kernel/signal.c          |   6 +-
 arch/riscv/kernel/sys_riscv.c       |  41 +++++++-
 fs/binfmt_flat.c                    |   6 +-
 fs/exec.c                           |  10 +-
 include/linux/cacheflush.h          |   7 ++
 mm/nommu.c                          |  31 +++---
 8 files changed, 228 insertions(+), 25 deletions(-)

diff --git a/arch/riscv/include/asm/cacheflush.h b/arch/riscv/include/asm/cacheflush.h
index c2b0a29..a5c20d7 100644
--- a/arch/riscv/include/asm/cacheflush.h
+++ b/arch/riscv/include/asm/cacheflush.h
@@ -85,6 +85,12 @@ static inline void flush_icache_range(unsigned long start, unsigned long end)
 	flush_icache_all();
 }
 
+#ifdef CONFIG_RISCV_ESP32P4_CLIC
+int esp32p4_sync_user_text(unsigned long start, unsigned long end);
+
+#define flush_icache_user_range_checked esp32p4_sync_user_text
+#endif
+
 extern unsigned int riscv_cbom_block_size;
 extern unsigned int riscv_cboz_block_size;
 extern unsigned int riscv_cbop_block_size;
diff --git a/arch/riscv/kernel/patch.c b/arch/riscv/kernel/patch.c
index 2b5adf0..7ef5565 100644
--- a/arch/riscv/kernel/patch.c
+++ b/arch/riscv/kernel/patch.c
@@ -3,6 +3,13 @@
  * Copyright (C) 2020 SiFive
  */
 
+#ifdef CONFIG_RISCV_ESP32P4_CLIC
+#include <linux/align.h>
+#include <linux/io.h>
+#include <linux/irqflags.h>
+#include <linux/panic.h>
+#include <linux/sizes.h>
+#endif
 #include <linux/spinlock.h>
 #include <linux/mm.h>
 #include <linux/memory.h>
@@ -173,9 +180,136 @@ static int __patch_insn_set(void *addr, u8 c, size_t len)
 }
 NOKPROBE_SYMBOL(__patch_insn_set);
 
+#ifdef CONFIG_RISCV_ESP32P4_CLIC
+#define ESP32P4_CACHE_BASE		0x3ff10000
+#define ESP32P4_CACHE_SYNC_CTRL		0x98
+#define ESP32P4_CACHE_SYNC_MAP		0x9c
+#define ESP32P4_CACHE_SYNC_ADDR		0xa0
+#define ESP32P4_CACHE_SYNC_SIZE		0xa4
+
+#define ESP32P4_CACHE_INVALIDATE	BIT(0)
+#define ESP32P4_CACHE_WRITEBACK		BIT(2)
+#define ESP32P4_CACHE_SYNC_DONE		BIT(4)
+#define ESP32P4_CACHE_SYNC_MAX_POLLS	1000000
+
+#define ESP32P4_CACHE_L1_I0		BIT(0)
+#define ESP32P4_CACHE_L1_D		BIT(4)
+#define ESP32P4_CACHE_L2		BIT(5)
+
+#define ESP32P4_PSRAM_START		0x48000000UL
+#define ESP32P4_PSRAM_END		0x4c000000UL
+#define ESP32P4_CACHE_MAX_LINE		128
+
+static int esp32p4_cache_sync(u32 map, u32 start, u32 size, u32 op,
+			       unsigned int count)
+{
+	/* The caller holds local IRQs disabled on the single supported hart. */
+	static bool sync_failed;
+	void __iomem *base = (void __iomem *)ESP32P4_CACHE_BASE;
+	unsigned int polls;
+
+	if (sync_failed)
+		return -EIO;
+
+	writel(map, base + ESP32P4_CACHE_SYNC_MAP);
+	writel(start, base + ESP32P4_CACHE_SYNC_ADDR);
+	writel(size, base + ESP32P4_CACHE_SYNC_SIZE);
+
+	while (count--) {
+		writel(op, base + ESP32P4_CACHE_SYNC_CTRL);
+		/* Order the sync command before reading its completion status. */
+		mb();
+		for (polls = 0; polls < ESP32P4_CACHE_SYNC_MAX_POLLS; polls++) {
+			if (readl(base + ESP32P4_CACHE_SYNC_CTRL) & ESP32P4_CACHE_SYNC_DONE)
+				break;
+			cpu_relax();
+		}
+		if (polls == ESP32P4_CACHE_SYNC_MAX_POLLS) {
+			sync_failed = true;
+			return -ETIMEDOUT;
+		}
+	}
+
+	return 0;
+}
+NOKPROBE_SYMBOL(esp32p4_cache_sync);
+
+static int esp32p4_cache_writeback(u32 start, u32 size)
+{
+	int ret;
+
+	/* Repeat writeback to avoid losing a sync with conflicting writes. */
+	ret = esp32p4_cache_sync(ESP32P4_CACHE_L1_D, start, size, ESP32P4_CACHE_WRITEBACK, 2);
+	if (ret)
+		return ret;
+
+	return esp32p4_cache_sync(ESP32P4_CACHE_L2, start, size, ESP32P4_CACHE_WRITEBACK, 2);
+}
+NOKPROBE_SYMBOL(esp32p4_cache_writeback);
+
+static int esp32p4_sync_text(void *addr, size_t len, bool fatal)
+{
+	unsigned long start = (unsigned long)addr;
+	unsigned long first, end, flags;
+
+	if (start < ESP32P4_PSRAM_START || start >= ESP32P4_PSRAM_END ||
+	    !len || len > ESP32P4_PSRAM_END - start)
+		return 0;
+
+	first = ALIGN_DOWN(start, ESP32P4_CACHE_MAX_LINE);
+	end = ALIGN(start + len, ESP32P4_CACHE_MAX_LINE);
+
+	/* Allow interrupts between chunks if they were enabled on entry. */
+	while (first < end) {
+		u32 size = min_t(u32, end - first, SZ_32K);
+		int ret;
+
+		local_irq_save(flags);
+		ret = esp32p4_cache_writeback(first, size);
+		if (!ret)
+			ret = esp32p4_cache_sync(ESP32P4_CACHE_L1_I0, first, size,
+						 ESP32P4_CACHE_INVALIDATE, 1);
+		if (ret) {
+			if (fatal)
+				panic("ESP32-P4 text cache sync failed: %d\n", ret);
+			local_irq_restore(flags);
+			return ret;
+		}
+
+		local_flush_icache_all();
+		local_irq_restore(flags);
+		first += size;
+	}
+
+	return 0;
+}
+NOKPROBE_SYMBOL(esp32p4_sync_text);
+
+int esp32p4_sync_user_text(unsigned long start, unsigned long end)
+{
+	int ret;
+
+	if (end > start) {
+		ret = esp32p4_sync_text((void *)start, end - start, false);
+		if (ret)
+			return ret;
+	}
+
+	flush_icache_range(start, end);
+	return 0;
+}
+NOKPROBE_SYMBOL(esp32p4_sync_user_text);
+#endif
+
 static int __patch_insn_write(void *addr, const void *insn, size_t len)
 {
-	return copy_to_kernel_nofault(addr, insn, len);
+	int ret = copy_to_kernel_nofault(addr, insn, len);
+
+#ifdef CONFIG_RISCV_ESP32P4_CLIC
+	if (!ret)
+		esp32p4_sync_text(addr, len, true);
+#endif
+	return ret;
 }
 NOKPROBE_SYMBOL(__patch_insn_write);
 #endif /* CONFIG_MMU */
@@ -208,10 +342,14 @@ int patch_text_set_nosync(void *addr, u8 c, size_t len)
 	int ret;
 
 	ret = patch_insn_set(addr, c, len);
-	if (!ret)
-		flush_icache_range((uintptr_t)addr, (uintptr_t)addr + len);
+	if (ret)
+		return ret;
 
-	return ret;
+#ifdef CONFIG_RISCV_ESP32P4_CLIC
+	esp32p4_sync_text(addr, len, true);
+#endif
+	flush_icache_range((uintptr_t)addr, (uintptr_t)addr + len);
+	return 0;
 }
 NOKPROBE_SYMBOL(patch_text_set_nosync);
 
diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index 59784dc..05266d7 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/compat.h>
+#include <linux/cacheflush.h>
 #include <linux/signal.h>
 #include <linux/uaccess.h>
 #include <linux/syscalls.h>
@@ -21,7 +22,6 @@
 #include <asm/switch_to.h>
 #include <asm/vector.h>
 #include <asm/csr.h>
-#include <asm/cacheflush.h>
 #include <asm/usercfi.h>
 
 unsigned long signal_minsigstksz __ro_after_init;
@@ -453,7 +453,9 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 
 	addr = (unsigned long)&frame->sigreturn_code;
 	/* Make sure the two instructions are pushed to icache. */
-	flush_icache_range(addr, addr + sizeof(frame->sigreturn_code));
+	err = flush_icache_user_range_checked(addr, addr + sizeof(frame->sigreturn_code));
+	if (err)
+		return err;
 
 	regs->ra = addr;
 #endif /* CONFIG_MMU */
diff --git a/arch/riscv/kernel/sys_riscv.c b/arch/riscv/kernel/sys_riscv.c
index 22fc9b3..04c6883 100644
--- a/arch/riscv/kernel/sys_riscv.c
+++ b/arch/riscv/kernel/sys_riscv.c
@@ -5,8 +5,9 @@
  * Copyright (C) 2017 SiFive
  */
 
+#include <linux/cacheflush.h>
+#include <linux/mm.h>
 #include <linux/syscalls.h>
-#include <asm/cacheflush.h>
 #include <asm-generic/mman-common.h>
 
 static long riscv_sys_mmap(unsigned long addr, unsigned long len,
@@ -52,6 +53,33 @@ SYSCALL_DEFINE6(mmap2, unsigned long, addr, unsigned long, len,
 }
 #endif
 
+#ifdef CONFIG_RISCV_ESP32P4_CLIC
+static int esp32p4_flush_icache_mapped_range(unsigned long start,
+					   unsigned long end)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+	unsigned long covered = start;
+	int ret = -EFAULT;
+
+	VMA_ITERATOR(vmi, mm, start);
+
+	mmap_read_lock(mm);
+	for_each_vma_range(vmi, vma, end) {
+		if (vma->vm_start > covered)
+			break;
+		covered = vma->vm_end;
+		if (covered >= end) {
+			ret = flush_icache_user_range_checked(start, end);
+			break;
+		}
+	}
+	mmap_read_unlock(mm);
+
+	return ret;
+}
+#endif
+
 /*
  * Allows the instruction cache to be flushed from userspace.  Despite RISC-V
  * having a direct 'fence.i' instruction available to userspace (which we
@@ -63,8 +91,8 @@ SYSCALL_DEFINE6(mmap2, unsigned long, addr, unsigned long, len,
  *
  * sys_riscv_flush_icache() is defined to flush the instruction cache over an
  * address range, with the flush applying to either all threads or just the
- * caller.  We don't currently do anything with the address range, that's just
- * in there for forwards compatibility.
+ * caller. The generic implementation uses a whole-cache flush. ESP32-P4
+ * also synchronizes mapped PSRAM in the requested range.
  */
 SYSCALL_DEFINE3(riscv_flush_icache, uintptr_t, start, uintptr_t, end,
 	uintptr_t, flags)
@@ -73,6 +101,13 @@ SYSCALL_DEFINE3(riscv_flush_icache, uintptr_t, start, uintptr_t, end,
 	if (unlikely(flags & ~SYS_RISCV_FLUSH_ICACHE_ALL))
 		return -EINVAL;
 
+#ifdef CONFIG_RISCV_ESP32P4_CLIC
+	if (end < start)
+		return -EINVAL;
+	if (end > start)
+		return esp32p4_flush_icache_mapped_range(start, end);
+#endif
+
 	flush_icache_mm(current->mm, flags & SYS_RISCV_FLUSH_ICACHE_LOCAL);
 
 	return 0;
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index b5b5ca1..890a81d 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -32,6 +32,7 @@
 #include <linux/user.h>
 #include <linux/slab.h>
 #include <linux/binfmts.h>
+#include <linux/cacheflush.h>
 #include <linux/personality.h>
 #include <linux/init.h>
 #include <linux/flat.h>
@@ -40,7 +41,6 @@
 
 #include <asm/byteorder.h>
 #include <linux/unaligned.h>
-#include <asm/cacheflush.h>
 #include <asm/page.h>
 #include <asm/flat.h>
 
@@ -830,7 +830,9 @@ static int load_flat_file(struct linux_binprm *bprm,
 #endif /* CONFIG_BINFMT_FLAT_OLD */
 	}
 
-	flush_icache_user_range(start_code, end_code);
+	ret = flush_icache_user_range_checked(start_code, end_code);
+	if (ret)
+		return ret;
 
 	/* zero the BSS,  BRK and stack areas */
 	if (clear_user((void __user *)(datapos + data_len), bss_len +
diff --git a/fs/exec.c b/fs/exec.c
index 8d2b14e..9066d2b 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -23,6 +23,7 @@
  * formats.
  */
 
+#include <linux/cacheflush.h>
 #include <linux/kernel_read_file.h>
 #include <linux/slab.h>
 #include <linux/file.h>
@@ -827,8 +828,13 @@ EXPORT_SYMBOL(open_exec);
 ssize_t read_code(struct file *file, unsigned long addr, loff_t pos, size_t len)
 {
 	ssize_t res = vfs_read(file, (void __user *)addr, len, &pos);
-	if (res > 0)
-		flush_icache_user_range(addr, addr + len);
+
+	if (res > 0) {
+		int ret = flush_icache_user_range_checked(addr, addr + len);
+
+		if (ret)
+			return ret;
+	}
 	return res;
 }
 EXPORT_SYMBOL(read_code);
diff --git a/include/linux/cacheflush.h b/include/linux/cacheflush.h
index 55f297b..6a7d6f4 100644
--- a/include/linux/cacheflush.h
+++ b/include/linux/cacheflush.h
@@ -26,4 +26,11 @@ static inline void flush_icache_pages(struct vm_area_struct *vma,
 
 #define flush_icache_page(vma, page)	flush_icache_pages(vma, page, 1)
 
+#ifndef flush_icache_user_range_checked
+#define flush_icache_user_range_checked(start, end) ({	\
+	flush_icache_user_range((start), (end));		\
+	0;						\
+})
+#endif
+
 #endif /* _LINUX_CACHEFLUSH_H */
diff --git a/mm/nommu.c b/mm/nommu.c
index 6c6f953..f310d1e 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -16,6 +16,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/cacheflush.h>
 #include <linux/export.h>
 #include <linux/mm.h>
 #include <linux/sched/mm.h>
@@ -395,10 +396,9 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 		return brk;
 	}
 
-	/*
-	 * Ok, looks good - let it rip.
-	 */
-	flush_icache_user_range(mm->brk, brk);
+	if (flush_icache_user_range_checked(mm->brk, brk))
+		return mm->brk;
+
 	return mm->brk = brk;
 }
 
@@ -1193,7 +1193,7 @@ unsigned long do_mmap(struct file *file,
 	/* okay... we have a mapping; now we have to register it */
 	result = vma->vm_start;
 
-	current->mm->total_vm += len >> PAGE_SHIFT;
+
 
 share:
 	BUG_ON(!vma->vm_region);
@@ -1201,6 +1201,19 @@ share:
 	if (vma_iter_prealloc(&vmi, vma))
 		goto error_vma_iter_prealloc;
 
+	/* Flush the region before publishing its first executable mapping. */
+	if (vma->vm_flags & VM_EXEC && !region->vm_icache_flushed) {
+		ret = flush_icache_user_range_checked(region->vm_start,
+						      region->vm_end);
+		if (ret)
+			goto error_free_mapped;
+
+		region->vm_icache_flushed = true;
+	}
+
+	if (region->vm_usage == 1)
+		current->mm->total_vm += len >> PAGE_SHIFT;
+
 	add_nommu_region(region);
 
 	setup_vma_to_mm(vma, current->mm);
@@ -1208,13 +1221,6 @@ share:
 	/* add the VMA to the tree */
 	vma_iter_store_new(&vmi, vma);
 
-	/* we flush the region from the icache only when the first executable
-	 * mapping of it is made  */
-	if (vma->vm_flags & VM_EXEC && !region->vm_icache_flushed) {
-		flush_icache_user_range(region->vm_start, region->vm_end);
-		region->vm_icache_flushed = true;
-	}
-
 	up_write(&nommu_region_sem);
 
 	return result;
@@ -1250,6 +1256,7 @@ error_vma_iter_prealloc:
 	show_mem();
 	ret = -ENOMEM;
 
+error_free_mapped:
 	/* in case that the region is allocated via do_mmap_private() */
 	if ((region->vm_usage == 1) && (region->vm_flags & VM_MAPPED_COPY))
 		free_page_series(region->vm_start, region->vm_top);
-- 
2.56.1


