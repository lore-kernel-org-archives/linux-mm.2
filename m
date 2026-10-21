Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2690A60A263B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 08:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Pm9Mh7ou
Received: by kanga.kvack.org (Postfix)
	id 4542F6B0674; Wed, 21 Oct 2026 04:32:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 405246B0676; Wed, 21 Oct 2026 04:32:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CD1D6B0677; Wed, 21 Oct 2026 04:32:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 00FAE6B0674
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 04:32:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 06FB71C3C20
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:32:22 +0000 (UTC)
X-FDA: 85345966524.09.18707D1
Received: from mail-pz2-f5.google.com (mail-pz2-f5.google.com [74.125.228.5])
	by imf06.hostedemail.com (Postfix) with ESMTP id 35E43180004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:32:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Pm9Mh7ou;
	spf=pass (imf06.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.5 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792571540;
	b=RmU4rTR6P+lLvuc/mSNAxx8FPhRFMLkZKWYORWAGvmJI+eExvQC/furPYa+DDffkKD9lFj
	8ZhgsVMyfECQo7feDIgkaKU8n/JvDECxLi7i52pkB6tNnzkCDBZ/CgnoN9lHebiR38/QZr
	5u2JEDs+dUvmEKFpiWYhn/faqwyIczA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Pm9Mh7ou;
	spf=pass (imf06.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.5 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792571540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gUG85+B7KqrDZpPXGb0QyiCfKe+tueHmqLD38rgeJ0Q=;
	b=dWtInsS0kBLlN/UgoxHL8fMdMCoK8MrXx1WofehGFbX77gkN3ivAbeLZ1zVoszrxV/awdK
	PUsJZtANF+OrpL8boHJ65Hl1AdXEZSZBGeC644Oa5pgUUbhDVZ8lc32MRx7MRiRkuhE+eq
	P8hWSTeJf9SCUfvlb6Kd736y6RhRpsc=
Received: by mail-pz2-f5.google.com with SMTP id 41be03b00d2f7-cc7c286026aso155132a12.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792571539; x=1793176339; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gUG85+B7KqrDZpPXGb0QyiCfKe+tueHmqLD38rgeJ0Q=;
        b=Pm9Mh7oueUJ0g9YqDqBMl4kS2KKic9PpQBhlzh08ZjsJ3yKjb+x9NkMCsFaVDo8nXp
         nqykaqyay+MLFiuUQsuV22ZgKnfV1vd+9OMqC+RxqDLrmhoyC8aK4715+NPC7ws4/y3M
         v/4hkDDczJ9aSkb8XGbcVkUh56UvW/r9ycxdQ1GwU/R9M42WHPKFncRYGfXTIiLcFFsc
         aRF94Yh9nzfRVd9nd+sDNQt6Qojzdp/+21RXtrl0abPPLzqBPN0y+8qk2NfaE0myrV1o
         dr28JW7Xdp+PD7K0jqwKkbPUssCC0AED9r5wo0K7cC8T0e1g3pxp23rSZIgSRfeNSYpy
         JmAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792571539; x=1793176339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gUG85+B7KqrDZpPXGb0QyiCfKe+tueHmqLD38rgeJ0Q=;
        b=h+2MU+9sjOj0yLblTrpIQF3AUs4mPAawbkbcAvI+LN5ed1nOImNBjpP62SQnbe6sNj
         W+pOf/X3nAU7St33FKp7/OaN6j1UhEMSx8UAsiwN5gXWIi+z1PUsvtwS6xyNW1b5G4RO
         jnpwLCG9Qt6DujbCuI7h60NTJL2MHeWbLxcOAf6jqgyFfhxurTv69wbQXZureBY1Yj0Q
         sDypkJBL8BeDaJTXFvF7I5R7e5vEfhxudSRLuPkxInFoLA20T4gCc36A9mg9RNRRVJKv
         MZIDzz2QmKonLvZWu3b9SSpuThiliTUQzawRuVFMiFotkzHNHEbiq7F9ZvHx+kAL0oyx
         sQXw==
X-Forwarded-Encrypted: i=1; AKwUvBzxnrfobfTpmnGk+jmfNmkGd9+EbjqVbi5VFf8gEL0j4ZN37H+MmWwe7mHPskGkR/070zdLOUswGg==@kvack.org
X-Gm-Message-State: AFq9FYKwNVM7riDHSEzCyndCBSbR5MRyaFik+vV/3RoQXuOZtv7W/5f8
	Qe8ohXVmJUs16Z1Vkg3hdLUitI0f4gdSwvUXOfMNezh7Fks6T1jJv50I
X-Gm-Gg: AYBFou2ZhwR4e3tMLNUE9mFFWJWMcQ9a8q7qEF7hr/BBtg+rbNmWrsFGICj1TwDrVGk
	w+Laszn7wg7fVFrrY3HNXcKzrTXiyA1PMbq+HdsFvPEltVMkjEqSW9Gb7rfYAVMn1PBGD9I611s
	XSdPJwv53UBzr8JFFc4GbQVUdnIAvxaEwl9mJvH0kD+bLQfknTiQcf4Lg0TSvMV7dTyBff1RvYb
	UZ8MJ1ywcxn9E3Ha1hrvRa8Qwe91Rnd5sy2X1BA8DQMAV907U/HeyYMGnt4TJAZpH+6NALob0K4
	idtB6qtHGeahLZSRbjeYt4nX8LLMeQdd58zsTvIy646rt4REBpq99v2oxSGtrBtcxiuQnQY0tdY
	GaxLFJ3PP25R6B7z5V5cSbbx23t55qIakIcet4/8shH8GS9GVvINnCQwlW4f5qqNeKwnXNY8lxd
	j8xB/j4KM1eECKosYQbZXtfujjD2rJjSWSXfcuaY3eUDV9XQ6GHh1A7sSRAvVU8RQRlLovR7Ung
	LkTrkQV0hZrNg9ZWISajiJpfVKpAkKTSGH8byybPrrVGTYP07ohMcNFeIU3LE7caUjr
X-Received: by 2002:a05:6a00:a0e:b0:8a0:1435:fda0 with SMTP id d2e1a72fcca58-8a089d4702cmr1201474b3a.51.1792571538862;
        Wed, 21 Oct 2026 01:32:18 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0895e273bsm600653b3a.41.2026.10.21.01.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 01:32:09 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v9 7/8] of: reserved_mem: mark /reserved-memory entries with MEMBLOCK_NODUMP
Date: Wed, 21 Oct 2026 16:30:10 +0800
Message-ID: <20261021083011.2170525-8-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261021083011.2170525-1-chenwandun1@gmail.com>
References: <20261021083011.2170525-1-chenwandun1@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ciihf8cwnd9s9qpp8535bfwsto4z5rp3
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 35E43180004
X-Rspam-User: 
X-HE-Tag: 1792571540-294476
X-HE-Meta: U2FsdGVkX1+BiKvujovjnA6FYV1IR1hZBf9QT9ubE5ze8Aa1rYSscW4cT0HI85hBEOtE5zqVKzSWV7lNS1U79DQAGzL/16Hhx/itnAt5kGaf+3aF6XYlSv/brt6kU5rDvT62/M/gt4wq9He9QniSVGk+isBFoZQePJj/IIUS9cYoKxI2Xyyjw3IrxScVTillsZcY9ZIWe3jTvIIHw9/A6HxYOSRppurhppP5I2EYvCIl9XhdCAiCyfcZu8B6/V19rL1yRsx0mOsrrgroT+tzkKprxaNRWvOYwd2nle6DHnf0hDxIZ/dBG5BHhAiH+JO54IY3ZwO4oaY4Rl6R6LTL3Vnhm8ionPJWJ9VwyK9zSbVJkEaenUyPTRF9J+39LZGcAOzppJMTJOP1ZIV1MJUBPFCWR+7HFh++im+0M18Fa1bBSSZICud5JwlZWu/Fnnbwz7B1qRA0Gx97fej5geqwHyiOJbG1ElJFSZd/rm51TeoC1WhsL4AcS6iJrUvAgJbwdQ1ryzx1GdzTY1PMsHFdLjlIhYdtjbSpctkMHYN9LDECc0jxdkO17lbSVDywex3/Bp7VgkiZN2Cs6FJD07YpR/h5ouKML8WdL3Hysm8glB7hsUSSI37okGZYbsm843irsDpKRnJQ//R/+QTbtxGrjNIKt2ROt//77aeUfsk0/lVx1sshvUFMiqVbi6M41HS9jkd8h7JhLTDT8wzKj7hxj23v9JjY6MbhAoHAnYXuU81hTgvnNeWhjwFSIhxZS8r3ubdbTwkrZLqKoxGT0/gAV8gMfxVeQRrK3nM2BsDxxZz1PSt834QuZaFd+KP2yk4xuPrEwPAhuRCwhrJHEtkEBu6FXLeeVm0DQQNiEWlDTW+gEALezeZkBlRA+pNXU6M4cMdF4RlLfTiY0iwsh/G1gisCmDdCTmEV5F+5NT1VBuV2Xk0WBN5vTlTcqYXVoA60rvQVmxF6vDSy+THn2ds
 75zkTstd
 buhcfyIEgAQkmiGsP7ZJjkhVdfvvLRfxJet6eHmnajzBs8tC75yl1yTzn+Ivln2gayPGAfnjbd1yfakR+O7z2T39QL8P7aMDZYor3y8rwZMCmEwRCCTvIbFC/oqL5j1q/0F3nMZVLOhZTwUmL7wrDJc4RoVZgPCMEhpxmWLTZzB5PQoeDjjjdzQpTT8sTtOy0N9Jeds2PAMG+GO9yhDlyIWE8n59ev7YKJRS0q02ffaYxEIAAp2kjW+JKHB/bFHJVAkNhxRGulDOi/+9D0a9hTSKHud9Osue2aSz0TVepVxOokZM/fZThvzwYx6NEQ+9D0ibKkqQpERk6APNoqqqYx3NoAqXSttfr89JQprA2ZLrOR64Nu54R53TF+Rf+1giiGmVe2iBT/FS02HPtr5Vgj8PoKih9OfVjr2JVp2B0JRjvWcOQqN2zjxFc4l/dxnzw/5ahP9f669fX8Le1+kfK8/qhuSsf2NoimsRfoU76V6YXI3aKUdR9JrJQass4d4Ma7yW/AgqEAI2MFgsZCD/MT1SJDaE9214WemxH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wandun Chen <chenwandun@lixiang.com>

Mark non-dumpable reserved-memory regions with MEMBLOCK_NODUMP so
kdump can omit them from the vmcore.

The marking is guarded by CONFIG_CRASH_DUMP and either CONFIG_KEXEC_FILE
or CONFIG_CRASH_HOTPLUG, so kernels that do not build or update crash
ELF headers do not pay the cost of splitting memblock.memory entries
at NODUMP boundaries.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
---
 drivers/of/fdt.c             |  1 +
 drivers/of/of_private.h      |  1 +
 drivers/of/of_reserved_mem.c | 18 ++++++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index ecc923102622..a5f223a74b7e 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1285,6 +1285,7 @@ void __init unflatten_device_tree(void)
 
 	/* Save the statically-placed regions in the reserved_mem array */
 	fdt_scan_reserved_mem_late();
+	fdt_mark_reserve_mem_nodump();
 
 	/* Populate an empty root node when bootloader doesn't provide one */
 	if (!fdt) {
diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
index 0ae16da066e2..505735732c13 100644
--- a/drivers/of/of_private.h
+++ b/drivers/of/of_private.h
@@ -187,6 +187,7 @@ static inline struct device_node *__of_get_dma_parent(const struct device_node *
 
 int fdt_scan_reserved_mem(void);
 void __init fdt_scan_reserved_mem_late(void);
+void __init fdt_mark_reserve_mem_nodump(void);
 
 bool of_fdt_device_is_available(const void *blob, unsigned long node);
 
diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 8c9d6395d6a3..db2bf76000d2 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -677,6 +677,24 @@ static void __init fdt_init_reserved_mem_node(unsigned long node, const char *un
 	reserved_mem_count++;
 }
 
+void __init fdt_mark_reserve_mem_nodump(void)
+{
+	struct reserved_mem *rmem;
+	int i;
+
+	if (!IS_ENABLED(CONFIG_CRASH_DUMP))
+		return;
+
+	if (!IS_ENABLED(CONFIG_KEXEC_FILE) && !IS_ENABLED(CONFIG_CRASH_HOTPLUG))
+		return;
+
+	for (i = 0; i < reserved_mem_count; i++) {
+		rmem = &reserved_mem[i];
+		if (rmem->size && !rmem->dumpable)
+			memblock_mark_nodump(rmem->base, rmem->size);
+	}
+}
+
 struct rmem_assigned_device {
 	struct device *dev;
 	struct reserved_mem *rmem;
-- 
2.43.0


