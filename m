Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11A0ACAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:11:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E0906B00BD; Fri, 12 Sep 2025 11:11:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B8696B00BF; Fri, 12 Sep 2025 11:11:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A7936B00C0; Fri, 12 Sep 2025 11:11:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46F3C6B00BD
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:11:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0B1BA11AEF3
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:11:06 +0000 (UTC)
X-FDA: 83880936132.09.C4CC1AA
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1B2094000E
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:11:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=IUBFqS3n;
	spf=pass (imf04.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.176 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757689864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UNgnuqtXCBxfx2G2dXAsaT/aGFlSDDhwnEcansq3QOI=;
	b=BGwXajDN8DNac6MQNJ3a35sJ+c8IFSgYUeIspU5AaDFdvIXu+JFWta0PROygIPLndPNmT4
	tSA/bEYKn4FGqThsSff3uBIDJPGkezAsYyK1gRO178ac1/jXr1cllX5VnPD05LpLFdP1AQ
	GZS60iBWNkBUPjtoLRPY2T6GWLT8CPA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=IUBFqS3n;
	spf=pass (imf04.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.176 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757689864; a=rsa-sha256;
	cv=none;
	b=gzNM1ZriKqXGX2coxTmJNr5MSBKXxdbwqLTHwhpLZNSV6OpMuRd1C022zrHY3GeJUr2pZP
	W2zWK6gHGbf79yHJh+rUzP0DCGbXnqbOz15Bz/OaFGSUjSe3EpNNmoKiQp4rMjmUOlVrlC
	zuj3ZegihI+GPsdRg1QVAleQ8wIhj14=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-71d6051afbfso14337347b3.2
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757689863; x=1758294663; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UNgnuqtXCBxfx2G2dXAsaT/aGFlSDDhwnEcansq3QOI=;
        b=IUBFqS3nV2BFINFKit6IAu/e3dd3FhDETCWkEH/cqbA19HJON3S0jeX+9J/+HRrgES
         9cNo8jVR3MS+ZU0FEKX8k63wh5nzcMorV3Kz7Jw1jeYM1p49h3AnkoD23shXVIpBZc+O
         lh5N1JxymXpjZvUAi7NnhIagf1x5rT0I0E3750Z8rusY/qF29p7CbnhUkikTqOk74qCF
         IYo+TWJilf0ihGktgmvnkb3CGilcy55oer7i96VnOSvlCPYlhdpVSLeV1ohv6TJ0Zccv
         h6vx4FlPIlNb6lvM8F5T44Cv5UVIBAWDKaiOqHOBSevskYQUSWPqFw9atUPon56Y7dIN
         fPjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757689863; x=1758294663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UNgnuqtXCBxfx2G2dXAsaT/aGFlSDDhwnEcansq3QOI=;
        b=QJDgrOfo9Ygt6N2VzIxwPKJRoz6RZyH8T9OgSBV9z90VgrkXN026QP7JG/cgskeiX1
         qerbbiXcX0MZT3cMe7weVFtNjR/ROStJe0hNIVHgrCtVYrJ7TeiduA5KonQ3CUJFBFaE
         xUmQEl/yvYj5QXvi6eCwWUpIKDDZosx/g3x+lfLUWD4khtLQHd0JUDlaHMwAwZe38pbh
         sqOrV0R0BlmQPCodF2XKDbkTk3bglLHxjYdP/dl3pRmytyheA/wl8S3lpOMOYdurQDwM
         vW9RLlTcOe9cpf3SHC57IjkNV25P3tnE6QVjxUynV5C62lCzPiExjq1vw7kGf5pTqXDR
         RJfw==
X-Forwarded-Encrypted: i=1; AJvYcCU626pUqRMkBNiQVsbZHvvYAZrW7ttzd6/ftpYnA7939toyFmFjjfYEAeafTuP8TbHuTQhluJrY3Q==@kvack.org
X-Gm-Message-State: AOJu0YwYt4LMKtyHh46NJmLRugYP6+l0KS9aSgCWB+67xTA1LxcNHs38
	3GA/dgnstVMdK/NsUC6wBjGIMzEU9Fu0biM2C4N89a0M+p56lNu24DHau1ME+FyMT6k=
X-Gm-Gg: ASbGncvsxQLSbrjwvmWlRh0Fhz4FzeECDD/OI4HFzqa9U0+WuxfTk4Gogf0nt3fTZF6
	aM5dGQxKr30wq0jl/l+pZClgezcW2Hy5JVxOegsrffrAVui7n+53/CO8zzGiJTUPw8FJwluAzFB
	i7ywG9zEn+00qI9E0oCxwxDIczJMXwyeKeG8g+a6/9FWmn30x4X9BgNnB0qf/w84si4IaeEiEt0
	fZh4uJYxnQj0q60lAQAvrxvqtV/y3xbff0191kGaaEc00rsez+k8hLf3cEiOykz5XTGCeSInvIp
	ugw4uNv8t0qrIUJfun7RSaRghYWVfzO9BeKjIKAM5f1CNe/oRiJ887PsrkOGAR9OgWUbF52Zo2U
	VdxSMj8pS6EeWLSKZpNBHObP6BAKeSt/0aQ==
X-Google-Smtp-Source: AGHT+IEtne9c9aNxfz8OotnYXAiNsAB4JCtq87oaoJ7ML/Nd9NUoYp51pIa4pWBpc4rPSN6ehP6TAw==
X-Received: by 2002:a05:690c:9688:b0:721:1c48:a627 with SMTP id 00721157ae682-730627c990emr26695147b3.6.1757689862953;
        Fri, 12 Sep 2025 08:11:02 -0700 (PDT)
Received: from eugen-station.. ([145.224.119.89])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-624841586c1sm1302244d50.6.2025.09.12.08.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:11:02 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com,
	rdunlap@infradead.org,
	corbet@lwn.net,
	david@redhat.com,
	mhocko@suse.com
Cc: tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	jonechou@google.com,
	rostedt@goodmis.org,
	linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [RFC][PATCH v3 14/16] kernel/vmcoreinfo: Register kmemdump core image information
Date: Fri, 12 Sep 2025 18:08:53 +0300
Message-ID: <20250912150855.2901211-15-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912150855.2901211-1-eugen.hristev@linaro.org>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1B2094000E
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: wtb73m9c1nwjo68u6c464yzn7kyfqd8w
X-HE-Tag: 1757689863-874218
X-HE-Meta: U2FsdGVkX1/GWK61BEU8D6PoA5zX3nf+Rnwd5il+xd4JK3OyafoPtCKm5RptdBiY+iLSWkaO1cGCn8kBobrlOJLZUTtZsl8iHHf8eHl5CK2KuRBsL3cb2cXCx4xpREuFeJAX2QCZ3j4HePjDgeiMxYIF6AcRuEjU9OMRIhbR/fILs2dDzFjAeodSoZGtOk0kUII17tjwVqjGJjFrqSezE4Dk0H9s0bYOaSLM+9RPb7eDQN6dairDdxv+e65xVt3cX97kRHT0FDNDxcMGJ9iJY3ZEg1NoDMMmZAbgTKZhUSawKnB/Gcr5yG2/hCp/HRviR7cyciYd2q4GxKYnJOBErAfhJAEoXiqfHAKyyQ2DXJOZivCKpxi0YcBBAl9wO57qLf2HaJYkaY19w7Lo7yoDiYjETG95vQ1m5f6B5pwsg0+MCGGR6Pmin+eS3zKwiVie/GothAOXws7LghGfNr6od54aB60rFYnG1zN/E4cnG58+Oxa/VwmdhGkMobuPkdkqe8hglfoz1+5/wyT6neOIVCAZaEH4tI61iLCMt+P9qd8SbYI1tGUWGOpLJaBxKCiMJ+5SGb0ZyohSzOo2iBs1KlkBDgfg3AbOtGTKWIHcfRao1q4VgKXUPsS+GmX78Eac5Wg+ys/lt5Tn1psdqy8BKgjbmCE/RL18lW0+Yto/6ZHLqhTZnMRSUYhRZ3Ejox3KcpRVfF0ld+//27B/HYwYOG8XC9XykepHK/FsqYWWb4rTyc//z08cfsWYI2+v9UvJo+lu5UajJcHbS7xVH9B8S/xblMJ7J9D3h3xvGscRdUfH5rQOn51+yOXqIzR2e1Ua8yjpQJfCU/PWc6Tyo4kKObP/rHXiMBSErEnKj0q3HiHwI/77pzVv7ucP8lTgcXzuOd40xs0cVFfxVHRpqywZVosDHbWIp5lO22kH9ueBgWS9GqRwDhKLaxQECupSNMBXQeXzz56Ui0Q3uAxckLo
 kPgOTTAF
 7wr5i4UBLr8yVk1RtbCCtCjdusSCz648JDEg05sXRX5+5IdwHCVP1sdKHBhq3HOM7VkzR/FnJ6MoB708NUvTOE8L95xYS7AG+tCkDKHUfdTywXq4MGhmeNjyiamZgqwLZ7urIEV6aAC72LEqdkJ7IYsUhz30ase6zAJi2WvokhsRKl4zScFQhBf61KqTe4u/QXcaXdgDz3K8ZjaHNvXRLgA1O/191A2L94wYJjaj2LoyEMm4KVVtS81l0SiE7yylkVGY9B981sYUfKRMPL+sDVYmJ5hNTIW37uDZlYJDTraFF9OCRX4sAhc1v265VLEgONBHiwS4edu/OMNPcmQqYjAKGn3ZyxqEcTTQcG4f7LKmpI/M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The coreimage generated by kmemdump requires some kernel information
in order to be successfully loaded by `crash` or gdb.
Register all this information through vmcoreinfo once vmcoreinfo is setup.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/vmcore_info.c | 141 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 141 insertions(+)

diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
index 3e2e846ba9c8..1d83e95cf9be 100644
--- a/kernel/vmcore_info.c
+++ b/kernel/vmcore_info.c
@@ -15,6 +15,7 @@
 #include <linux/memblock.h>
 #include <linux/kmemleak.h>
 #include <linux/kmemdump.h>
+#include <linux/sched/stat.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
@@ -24,6 +25,17 @@
 #include "kallsyms_internal.h"
 #include "kexec_internal.h"
 
+void sched_get_runqueues_area(void **start, size_t *size);
+
+extern unsigned int nr_irqs;
+extern unsigned long tainted_mask;
+extern unsigned int nr_swapfiles;
+
+#ifdef CONFIG_IKCONFIG_PROC
+extern char kernel_config_data;
+extern char kernel_config_data_end;
+#endif
+
 /* vmcoreinfo stuff */
 unsigned char *vmcoreinfo_data;
 size_t vmcoreinfo_size;
@@ -121,8 +133,137 @@ EXPORT_SYMBOL(paddr_vmcoreinfo_note);
 
 static void vmcoreinfo_kmemdump(void)
 {
+	void *start;
+	size_t size;
+	int i;
+
 	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_VMCOREINFO,
 			     (void *)vmcoreinfo_data, vmcoreinfo_size);
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_linux_banner,
+			     (void *)&linux_banner, banner_len);
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_init_uts_ns,
+			     (void *)&init_uts_ns, sizeof(init_uts_ns));
+
+	sched_get_runqueues_area(&start, &size);
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_runqueues,
+			     (void *)start, size);
+
+#ifdef CONFIG_IKCONFIG_PROC
+	/* Register 8 bytes before and after, to catch the marker too */
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_CONFIG,
+			     (void *)&kernel_config_data - 8,
+			     &kernel_config_data_end - &kernel_config_data + 16);
+#endif
+
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE___cpu_possible_mask,
+			     (void *)&__cpu_possible_mask,
+			     sizeof(__cpu_possible_mask));
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE___cpu_active_mask,
+			     (void *)&__cpu_active_mask,
+			     sizeof(__cpu_active_mask));
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE___cpu_online_mask,
+			     (void *)&__cpu_online_mask,
+			     sizeof(__cpu_online_mask));
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE___cpu_present_mask,
+			     (void *)&__cpu_present_mask,
+			     sizeof(__cpu_present_mask));
+
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_nr_irqs,
+			     (void *)&nr_irqs, sizeof(nr_irqs));
+
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_tainted_mask,
+			     (void *)&tainted_mask, sizeof(tainted_mask));
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_taint_flags,
+			     (void *)&taint_flags, sizeof(taint_flags));
+
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_jiffies_64,
+			     (void *)&jiffies_64, sizeof(jiffies_64));
+
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_nr_threads,
+			     (void *)&nr_threads, sizeof(nr_threads));
+
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_node_states,
+			     (void *)&node_states, sizeof(node_states));
+
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_init_mm,
+			     (void *)&init_mm, sizeof(init_mm));
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_init_mm_pgd,
+			     (void *)&init_mm.pgd, sizeof(*init_mm.pgd));
+
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE__totalram_pages,
+			     (void *)&_totalram_pages, sizeof(_totalram_pages));
+
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_nr_swapfiles,
+			     (void *)&nr_swapfiles, sizeof(nr_swapfiles));
+
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE___per_cpu_offset,
+			     (void *)&__per_cpu_offset, sizeof(__per_cpu_offset));
+
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_high_memory,
+			     (void *)&high_memory, sizeof(high_memory));
+#ifdef CONFIG_NUMA
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_node_data,
+			     (void *)&node_data,
+			     MAX_NUMNODES * sizeof(struct pglist_data));
+
+	for (i = 0; i < MAX_NUMNODES; i++) {
+		if (!NODE_DATA(i))
+			continue;
+		kmemdump_register((void *)NODE_DATA(i),
+				  roundup(sizeof(pg_data_t), SMP_CACHE_BYTES));
+	}
+#endif
+
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_mem_section,
+			     (void *)&mem_section, sizeof(mem_section));
+	for (i = 0; i < NR_SECTION_ROOTS; i++) {
+		if (!mem_section[i])
+			continue;
+		kmemdump_register((void *)mem_section[i],
+				  SECTIONS_PER_ROOT * sizeof(struct mem_section));
+	}
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_MEMSECT,
+			     (void *)mem_section,
+			     sizeof(struct mem_section *) * NR_SECTION_ROOTS);
+
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_kallsyms_num_syms,
+			     (void *)&kallsyms_num_syms,
+			     sizeof(kallsyms_num_syms));
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_kallsyms_relative_base,
+			     (void *)&kallsyms_relative_base,
+			     sizeof(kallsyms_relative_base));
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_kallsyms_offsets,
+			     (void *)&kallsyms_offsets,
+			     sizeof(&kallsyms_offsets));
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_kallsyms_names,
+			     (void *)&kallsyms_names,
+			     sizeof(&kallsyms_names));
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_kallsyms_token_table,
+			     (void *)&kallsyms_token_table,
+			     sizeof(&kallsyms_token_table));
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_kallsyms_token_index,
+			     (void *)&kallsyms_token_index,
+			     sizeof(&kallsyms_token_index));
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_kallsyms_markers,
+			     (void *)&kallsyms_markers,
+			     sizeof(&kallsyms_markers));
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_kallsyms_seqs_of_names,
+			     (void *)&kallsyms_seqs_of_names,
+			     sizeof(&kallsyms_seqs_of_names));
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE__sinittext,
+			     (void *)&_sinittext, sizeof(&_sinittext));
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE__einittext,
+			     (void *)&_einittext, sizeof(&_einittext));
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE__end,
+			     (void *)&_end, sizeof(&_end));
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE__text,
+			     (void *)&_text, sizeof(&_text));
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE__stext,
+			     (void *)&_stext, sizeof(&_stext));
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE__etext,
+			     (void *)&_etext, sizeof(&_etext));
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_swapper_pg_dir,
+			     (void *)&swapper_pg_dir, sizeof(&swapper_pg_dir));
 }
 
 static int __init crash_save_vmcoreinfo_init(void)
-- 
2.43.0


