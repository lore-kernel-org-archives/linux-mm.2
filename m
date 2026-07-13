Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1118C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 06:15:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB14C6B0092; Mon, 13 Jul 2026 02:15:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B381E6B0096; Mon, 13 Jul 2026 02:15:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A27DC6B0095; Mon, 13 Jul 2026 02:15:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 799316B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:15:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1664F1A0AA3
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:15:45 +0000 (UTC)
X-FDA: 84982742250.04.FEC969F
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by imf10.hostedemail.com (Postfix) with ESMTP id AE970C0002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:15:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783923343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hjkoGu1IiaKioNB0B4RsTgk6xI6wmTC6lEI6UKL2gqw=;
	b=24rL23IabtfvOcSsiC4E+FONkHP6z0YRlkC590aU0o7Dzwkj00amVlm5HBUIkUIHNlm3Ia
	cFxan/FsiWZKkB4RbJjF3AlIvDmHVGMAXGjlJVsW/+uB8aGlADateNDP/DE/lrdpHXiJRr
	4/xrJqvWOPFKbOODIvOBXozXgdyQXSI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783923343;
	b=ahS0BJIs75CCEHc3a+XqBDtHXcOGMMUSTtX/nnbKU/CVn5uzdYSDlDLCFhxUR/l0ay92Iv
	zSKF3ZD4kC6CWEPmtj7Jwz3S6MhFFsSE0vFRn3spXh/ul/oBDb0lAyoO3RPmp4fObhAhSy
	Lm1Mc7C6isEn9R8Asq+QisX6A9T8ug8=
Received: from [127.0.0.2] (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowAAHF86CglRqddeRFw--.29971S3;
	Mon, 13 Jul 2026 14:15:31 +0800 (CST)
From: Vivian Wang <wangruikang@iscas.ac.cn>
Date: Mon, 13 Jul 2026 14:15:20 +0800
Subject: [PATCH v6 1/2] riscv: mm: Make mark_new_valid_map() stuff depend
 on 64BIT && MMU
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-mark-after-vmemmap-populate-v6-1-b945ceba29d4@iscas.ac.cn>
References: <20260713-mark-after-vmemmap-populate-v6-0-b945ceba29d4@iscas.ac.cn>
In-Reply-To: <20260713-mark-after-vmemmap-populate-v6-0-b945ceba29d4@iscas.ac.cn>
To: Alexandre Ghiti <alex@ghiti.fr>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-riscv@lists.infradead.org, Vivian Wang <wangruikang@iscas.ac.cn>
X-Mailer: b4 0.15.2
X-CM-TRANSID:rQCowAAHF86CglRqddeRFw--.29971S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJr15ZrWUXF4rXw18uF1DAwb_yoW8tF13pF
	sFkrn5Gryrur1xZ3y2vr1DWrW3Kw1qga4aq3WDur15Xa1qvr48Jrn5Kry7AryDXFWjgFWF
	kFyxCryFkw1jy37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIx
	AIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2
	KfnxnUUI43ZEXa7VUjhFxUUUUUU==
X-Originating-IP: [36.110.52.2]
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AE970C0002
X-Stat-Signature: 4ocsyhbaq9e8dgduexzcmy9akgyo8wq9
X-Rspam-User: 
X-HE-Tag: 1783923341-959858
X-HE-Meta: U2FsdGVkX18zC8Sb7OZwXsRivGVa15sau4Ox2CiXi4TGkwS174EiEoLcEVcuV5knJbKJ31c60hqtxRupaXY+veiYMWir/PCvdMGbVG4lvc/bQ5MhW8B8EYRL6ah8UTsNdFoo2Nw/c10Bt4IdrGuEaPLdpa4GmHcSwCzBJp3fTY+YRpHBIDCxf6cy8ay9lCV3k3YOckMer1c2xXY0i2ZD3OrYwiZjiAlfYJovvJ7zigr3PWUywpq74KNcMo7VmLwHp4LAj30KBK+8KSb+D9PKxO98iTvL/isWVusEXcG5XU+sjy0kVhDRy8QCW4Fon1fhEkKGkBXPqsKwM7SDMfhr6sjyU5Il8qQ8NV2EySGUCpzD0OFII3UbJJgvDveT+KrV6wo1RRKNbruOmDFPWKLAwDgHBH5aG4ILwGCDVP7qN79F1nBq7ie0Zlku8hkxAfdH4DsV+Jsj/AZdNvfDrwwF8OvAbzwiGwsqlZGUuZO9rqAQr5vkM+HJq3he4jyV0MfEfIX/H8qZnnNzoG3f6w0I5fMFr2TIFJSizpOZbjWMuPY89fi26xmIPq+76Nc1yNMxg37UcNL3a8zRvVEZBwU7SDoBuaHONEp2Cs7H5maht42RdRv2RPVqEzfWhoJwHiZSn+fZ6igCFC6rul7NY/q3GRQaTphKSyEtLb7PbRBdy2zhbEeeTf53voRi4Pz7H6fll7dRuerEYyGR+F0ir3OBRCoN0TBwo56CUCsj+Q4QRjNVGAzwcG/scOjh482q7SM52b5pgtj6nwEuTau9hbY82w6/2thp88Y9Uh/40wAU5oyT/MbbnnLM2iX+ZjnNprcqMtpxAX5uyhk2Tn2NnqpDGdj83h7ge7iu2kcj8Nhp+vODNNr+UAQutEES/TRDhDfLQOyeAmc3W/xytK9kNNsB4OQqDCRLZD0lWmddYZAE4Sq5bkH0ObObzJr1VyIjPlyAUJR/II0jXRBILr6brvu
 A6FQsNQ3
 Pr4CiKUMHR/wyPWK+tzUAKo9HH0NOepT6Eh+G5vvaeM56xuvKtkeu13kqCQPBVJrFUsxvQlP+u0UJzSSBUVERWox3ch9jLp5UXqkS4yjGoMHU9nIahOt1PUKxbWUYkBlG/9/9z/tUt3jsOKmLzDkrLf25MFGjZ8H8Lj5W3zZq/nJi2joM/pJWAgumvb+g4/+Uz+Yvy1Wdw4Jyv/FzDIqQGChjlvDhcy8Upfd0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

None of the code relating to mark_new_valid_map() does anything useful
without CONFIG_64BIT=y && CONFIG_MMU=y, because the
new_valid_map_cpus_check code is only used if CONFIG_64BIT, and the
exception codes checked there can only happen with CONFIG_MMU=y.

Therefore, make these conditional on CONFIG_64BIT=y && CONFIG_MMU=y to
simplify programming, since we do not have to handle CONFIG_MMU=n when
changing this code in the future. This also removes some unused code on
the entry path for CONFIG_MMU=n.

Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
---
 arch/riscv/include/asm/cacheflush.h | 2 +-
 arch/riscv/kernel/entry.S           | 2 +-
 arch/riscv/mm/init.c                | 2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/cacheflush.h b/arch/riscv/include/asm/cacheflush.h
index 8cfe59483a8f..58e787fad029 100644
--- a/arch/riscv/include/asm/cacheflush.h
+++ b/arch/riscv/include/asm/cacheflush.h
@@ -40,7 +40,7 @@ do {							\
 		flush_icache_mm(vma->vm_mm, 0);		\
 } while (0)
 
-#ifdef CONFIG_64BIT
+#if defined(CONFIG_64BIT) && defined(CONFIG_MMU)
 /* This is accessed in assembly code. cpumask_var_t would be too complex. */
 extern DECLARE_BITMAP(new_valid_map_cpus, NR_CPUS);
 extern char _end[];
diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index c6988983cdf7..3ae498779adf 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -137,7 +137,7 @@ SYM_CODE_START(handle_exception)
 .Lrestore_kernel_tpsp:
 	csrr tp, CSR_SCRATCH
 
-#ifdef CONFIG_64BIT
+#if defined(CONFIG_64BIT) && defined(CONFIG_MMU)
 	/*
 	 * The RISC-V kernel does not flush TLBs on all CPUS after each new
 	 * vmalloc mapping or kfence_unprotect(), which may result in
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 5b1b3c88b4d1..3e450890be07 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -37,7 +37,9 @@
 
 #include "../kernel/head.h"
 
+#if defined(CONFIG_64BIT) && defined(CONFIG_MMU)
 DECLARE_BITMAP(new_valid_map_cpus, NR_CPUS);
+#endif
 
 struct kernel_mapping kernel_map __ro_after_init;
 EXPORT_SYMBOL(kernel_map);

-- 
2.54.0


