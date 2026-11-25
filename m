Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA598606A6AA
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 23:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=P6dEOo4H
Received: by kanga.kvack.org (Postfix)
	id DF3856B0B33; Wed, 25 Nov 2026 18:31:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA5A46B0B35; Wed, 25 Nov 2026 18:31:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C93696B0B36; Wed, 25 Nov 2026 18:31:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 996946B0B33
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 18:31:54 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 31947A01D0
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 23:31:54 +0000 (UTC)
X-FDA: 85475241348.09.609BED8
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id 43E5D180006
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 23:31:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=P6dEOo4H;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of vitorhg20080@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=vitorhg20080@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795649512;
	b=KCw4Rj2nhSgI0ldS8qdGnSG5ujA1WM9bBHhcXr+0U1P6hM8dQa+rrlJwywHstf/v5mKbuD
	+HhwI0/eHqmx4SK6XA8QZQazxtiJWpW25feclT156qO75jR0wtJCS7Xu2ekEXJxxHJdQxw
	m47yHzBXY73dhKe1r2Xui7MW/Xt0NIo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795649512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sM/bxrlZWM2gs1gGiWx18pCt2PsQho/4iB9t+kQihGE=;
	b=Unq7flH/aUrGrxeMf1NySOn/7cGHS9ifLo2Gifa3uv6pRCCMUwbHJYofd6AY/Vnxmsvt75
	y6uFesDo4xpEfNpYqj8cK318HPmf5Tsi6SDobBZc0c0+MwBVH3D3ZgBnObb4a4z00hrWve
	GfcdpGYde8vNWU+WMY5kMQQBWq9K18A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=P6dEOo4H;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of vitorhg20080@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=vitorhg20080@gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso5594460f8f.2
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795649511; x=1796254311; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sM/bxrlZWM2gs1gGiWx18pCt2PsQho/4iB9t+kQihGE=;
        b=P6dEOo4HjS2sato5b1jeBAz59Uwk+6U/5SwgW/u9sKr04YBSMfifYFJkUTiiv2Tz0E
         r70v4uWArw2Q9hcrgMlVUjpLGXb9qa41v5Xh624G3wycdPdMIf+UkUkTv719iQNzqeE6
         aOw23jKoPX2jIRtycTA+YI/+0RuS4/dfV8VIKwx24fCeBXIGCNkUCtj/8ZOvvjadi6MY
         GuJNT/H5ThZ2Zdykk3wyvqwZGUvZFPFk//u8YMpFMy/UP6iusMzRncUMU0OzVOC29BJB
         hhbLWcBmDEZ8iBrc39h/DhhRcOljJBMLJwAkjc4eZ8a9bkbcxkNsliGXyma5NL/o2koR
         +GVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795649511; x=1796254311;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sM/bxrlZWM2gs1gGiWx18pCt2PsQho/4iB9t+kQihGE=;
        b=gZ81C+nwDir9yyEz80S6HhN4HKyJ0O76o076nPZVgvUfQXwRDHb9R6dqCGwZriX88B
         O53djO/G1Y5+9C3pKt3HO6Eti5te3t3p4zt9ne48rVDQ6YLVbE328ZnPYmi1yw+Ower7
         XeKTyTMyf5x7K84rnzDMgB2FvkvozBzpijeZu4KLh9VKMnJ5BoampSreOZpLw4IzMWJ0
         5ZxN0HPnoEdh3e4SP9FcjinaWBq4d5fiyje+P/wq44Z5vP01SWnV7zuxgsCOeshbIUya
         mkVNpEQgjul3054K9XwAQbW8HS4SO0zuJI3nPBja2Df/PZJYRcqSsIj+ZY5boWzqh88U
         cGew==
X-Forwarded-Encrypted: i=1; AL+hErHuj2W8tLyoxYdvXFa3QS2p21hJuTUYvNL39XGkeQsD7FkjIDha2hkZ73Gh5vZsZ5XuicTiQLF1Og==@kvack.org
X-Gm-Message-State: APuU4Z8QjKlxse4SeEKGN6PiAkTkq6HgeWXk1BtJNARMiyla+/YV+M+8
	7DA1S8CyHfI1ECxCJqSux3Uc4v4eS00saazhiN7z/YvX5MbTZrdQEer5
X-Gm-Gg: AZFdTZdvDlx+lkdZtl7Ba/sTDdN7Tz0niikPi5JmqsYKnacZG6YgXBa1dRbcgNtdi2Q
	0npstghltRm6RKF09VJ2ghWsqWYkssuo7Zyh6QOzrRio1SHE3LVwxmvmA4Mi36/qwfWnAFIu5pr
	T0bD9PpYnheFxHy1uC5f5aHR6FfBXElVVYtNmGgCf7VA4O3UOW4A/7H5kK8LqI5GVMeQM8afDdM
	4UTSCOiTBZ8iJ6emZIj2rqu9rWGgv5PYOhHxl/DX7jydKUTshXzaC4kdahGexTBmZDExlq/OqAk
	s+j6uDPhjKw6XR9LP+uHXqZrX5nw6YvRbcTEQ0vJYA8RTGMiuPz730YmLtMjgo4qAfFU9CsyHrS
	eyXIYJ2vBdp98MFxHFZl6vpAGyL6rhAFNKCj+9mFe8yoT5i1rbonyFXrozp02mg7mUcNP2YlJZM
	oGPLqpIG0LEQ3Y0YF/bnKaKgRnwR0X9ENQCpk5cEklUkutVBJ9amOhxUO1iOaPSbGfjlHVuklQm
	7FQQx2VRGeAqaJYUlctL6yqsQ7zHTAjOraLKSbkF46QUXcw89c2HFzeZPUrGUJE/W+d0gGcXOKe
	4fnyoMT64DzeHGiNXxreTkMGOkh+wWyH7ojKrUt8AXX8KrrWq0z1YkHrOZXcsJ3kjGQTUWX8stK
	AZc71QzG6Giw=
X-Received: by 2002:a5d:64eb:0:b0:4ae:e824:1fa8 with SMTP id ffacd0b85a97d-4aee8241fc9mr26855783f8f.9.1795649510672;
        Wed, 25 Nov 2026 15:31:50 -0800 (PST)
Received: from localhost (bl20-90-91.dsl.telepac.pt. [2.81.90.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6ae2dcf9sm36628788f8f.32.2026.11.25.15.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 15:31:50 -0800 (PST)
From: =?UTF-8?q?V=C3=ADtor=20Hugo=20Silva?= <vitorhg20080@gmail.com>
To: linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH RFC 14/19] riscv: Synchronize instructions written to ESP32-P4 PSRAM
Date: Wed, 25 Nov 2026 23:30:15 +0000
Message-ID: <20261125233020.1380594-15-vitorhg20080@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125233020.1380594-1-vitorhg20080@gmail.com>
References: <20261125233020.1380594-1-vitorhg20080@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y3txr1zjogrcu4m13iy839h3aiip1wjr
X-Rspamd-Queue-Id: 43E5D180006
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795649512-738303
X-HE-Meta: U2FsdGVkX1/RjFDurtuLd3t14O5lzOumrDbjai5klQE6hxBXbktG/QXnyNbCzgRDkbJpwIDGhBK22AZAR1fP3f2jkk3TnX654S36+66VsogSR1SjJaUcfG17QxDXMF1gf57N84ghHQLYyz+caCz7rb7t/aMi7+5/kPOflgyiOeGVIU1V3QZgG8sYVfCrCZdYUFbVND20hljsLRIJM5uwZ3vP/m+wF1LkoX7Ruc0N9RaAGUX/syc5onQvNPMfisU4eQz5w5PNBM4g3twsoRGAXU+BefFs2WXKsGMJfQszCgFW2AD39ZXXCyNaZ1PUzORCWLFRaLddR1zwIZQuA45AZ5P43ATg1zwYrMU2cxDOiBlLnmxRpTzPIdZ6xWutyOyUPGqf45y1Ad/XDQh3qfw5DSBKPf2Dbyo20koydv4p0vfH08Jlqs4Ymc6J+Ju9H9fE4UlUB3CehhOIfjDPmUfiwy0XWWAEZPEqZXzIfl3w5HXSqCkGgXpxKY1De6yem1x6MIsTQaVTyrW+HiazhPdM3pTTJyTf9CrFsMGwVODJWys8HXaNGqi078anYxOjKaaEpaZ1kEQAp3frD6AJKKSFnpVXEFAKJjedIcHhapGYacc0g+YwUJmfRk+rxFLZSyATCY+RZ+FbrAkjnho3csTzVtqtWbtNFv8LUfGL6MUhWySh4gSyX/t7OSiM6L8+JkXxkelB7SU+y+T026Hgi5jbp2z4rccF+hhaVR/FAc+TBUXIGFCOCRR124XFa5Kk8IQZX+OR3nOdkVJd1pfXZXafqlDNlkWKBjr1VkRju4lYeF0BOo0EyBN0PqGh03YjHtvs8zO3EFFeqCQWsxG5Bbb1s0ft/a1vBUWUcJTOWPHBoeG0A3LVwqWb0N599qWsFHOliSHuF0u1QJSpDh65SZ/JN5FcKIZpGwMB5sykVlia0ZDEiSfvKKqILrRBZhbRFsZGr9TfLgxJaIQNTAPYoct
 6tz9cpUp
 RN2ohR9cDyNf/GuvtL3R0mxbBVhqeLr7uihOlm5qodA39MyVduz1NEgILVeIHDnMOa0Srv+b6b0cH7E6icBAafyiEPLcEfZoAY8ptqMVwdfiYE8k5AkzkiIm5JK4NtmllmIqKVh7bl4se6c0Ys1U5/xZlK6k6datlaG/uu0/ikQJkPHorw0w5g5GQj11ysj6y4jkMWaiZtaAlb+OV72zqIdW+X4VnqQZvH4yzc0HhLr5LfHCZot0rPPpmojTZ2+WWCmNTZqRuUZE6iD3bhJjLic0BN0MQJeJBMWOUZmWZ4T5gQtknd4ga0Zm6rWPXFndaJyFu7VqTnBsQdd1AfxSLDKbURkr6F9FyU8ox9NJ/HLXpF67cS8O9Rv5vdeEJdNiNYY4qVn37KBgoQF72Z4jALNOfAHoI7Mmzj8nz1rydtErZc06gMNg6+z6W+fGm7Rul78YCQEgIOPja4eZLxtFh7fy8h/A10ZKVvATtmMofEDcNAoQps5uBRn5CPCGhGJ5nYlpm59aj92ywtF8ZlZKiEdmXigfFGH5otGsczSBJbK1HzXD1OY0Yt0T747/UKyZAwPvjXrfB143syFsgtbDrCxDGplWSkCYxCjpAC8yxGrODqm/Rkj1lwOUJdRa5JP4OKBb7vBn3ghhdkFZ/y0h8R6oProXb/iLh4HvJO0I22leWeR3PH99tRlyZ6PmnK0Zr2Zej/EWnNEFPPEUZcUKM2HQcHUoNqSNrQWXL0e/2WAZzgjpezIGZRApOzfUTHDdIaWBKRMFLzt7QJMqWLj2VaiNQ3aaIbMxkk/vweHAdxBWkPeYrjwDTf0QHmh5bfC3N5HwuQWrSqVR9QdAwJUcuAj/4xOnZ9Jn2xyW9YPVvjT9Ejo1zQCID3gvbdVTCFaPhGyYo+IN1gG1TsuATg9SvyhEIbAr4k98yrUQUovVfeh4zI8s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On ESP32-P4, a load can observe new instruction bytes in the data
cache while the instruction fetch path still sees old bytes. The
runtime constant patching code can then execute stale instructions
and use an invalid address during boot.

Write back the L1 data and L2 caches for the modified PSRAM range,
invalidate the local L1 instruction cache for that range and issue
fence.i before executing the modified instructions. Apply the same
sequence to NOMMU userspace code, including FLAT binaries and the
signal return trampoline.

Split the aligned range into 32 KiB chunks and restore the caller's
IRQ state after each chunk. In instrumented measurements on the
Waveshare board, the longest observed IRQ-disabled window fell from
2.69 ms with 128 KiB chunks to 1.13 ms with 32 KiB chunks.

Bound cache synchronization by a fixed number of reads per command.
After a timeout, stop issuing commands because the controller may
still be busy. Propagate failures through executable loading and
signal setup. Treat a failure to synchronize patched kernel text as
fatal.

The ESP32-P4 board probe observed stale instructions after fence.i
alone. Combining data writeback and instruction cache invalidation
made the modified instructions visible.

Verified boot to the UART shell on a Waveshare ESP32-P4-Module-DEV-KIT
with SDMMC disabled in Linux. The shell handled SIGUSR1 and resumed
execution. With CLIC disabled, the RV32 NOMMU patch.o and signal.o
matched the reference byte for byte.

AI assisted with isolating the cache synchronization change from
the rest of the ESP32-P4 port.

Link: https://docs.espressif.com/projects/esp-idf/en/stable/esp32p4/api-reference/system/mm_sync.html
Signed-off-by: Vítor Hugo Silva <vitorhg20080@gmail.com>
---
 arch/riscv/include/asm/cacheflush.h |   6 ++
 arch/riscv/kernel/patch.c           | 132 +++++++++++++++++++++++++++-
 arch/riscv/kernel/signal.c          |   6 +-
 fs/binfmt_flat.c                    |   6 +-
 fs/exec.c                           |  10 ++-
 include/linux/cacheflush.h          |   7 ++
 6 files changed, 160 insertions(+), 7 deletions(-)

diff --git a/arch/riscv/include/asm/cacheflush.h b/arch/riscv/include/asm/cacheflush.h
index c2b0a2928f06..a5c20d7d1c9d 100644
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
index 2b5adf01c550..e0687c943358 100644
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
@@ -173,9 +180,132 @@ static int __patch_insn_set(void *addr, u8 c, size_t len)
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
diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index 59784dc117e4..05266d7c1466 100644
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
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index b5b5ca1a44f7..890a81d805dc 100644
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
index 8d2b14e1d455..9066d2bebd1a 100644
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
index 55f297b2c23f..6a7d6f425737 100644
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
-- 
2.56.1


