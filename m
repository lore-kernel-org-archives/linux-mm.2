Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F35CECCD1A7
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 06:17:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F3798E000C; Sun, 19 Oct 2025 02:17:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A35A8E0002; Sun, 19 Oct 2025 02:17:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 892538E000C; Sun, 19 Oct 2025 02:17:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73FDF8E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 02:17:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 462F011A6D4
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:17:02 +0000 (UTC)
X-FDA: 84013855884.10.3469890
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id 11625180008
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:16:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NP+FtPzh;
	spf=pass (imf24.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760854620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zvmrmv3hPe2oQTJQT8OKmJhhNCe47YQRwxqYt3ifUEE=;
	b=uz88anz0NujT/rpQiS9miZG5AxcEcsW8/5JDUpCEoKzzuqg11xH93qyx8xonzed6KJGaQ/
	fDWbRC1GL2K6irH9y95Bj8e4FaadupuqSe3d0mnBcst3YR0YTO/XfiE2pUZJf9LnWw0LxL
	SNqYtFh786I34q65xeKSXKAfHO+tviA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NP+FtPzh;
	spf=pass (imf24.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760854620; a=rsa-sha256;
	cv=none;
	b=HgZ14iuv4jgSL+NLL/2LSKQzY/4whlFZodyIj/TogqhGsTc3K4RghuS1FCXfN6+RO3ka45
	WO1CtukODNgns3SMnuEe2x/VcwB59nievkyvVbAlr7sNPg2f2BeYQ9G39tOjYsaPyMOqLq
	54hRpcZpXrt7oT6MBpgP8686h3jNcrE=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-290d4d421f6so20238125ad.2
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 23:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760854619; x=1761459419; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zvmrmv3hPe2oQTJQT8OKmJhhNCe47YQRwxqYt3ifUEE=;
        b=NP+FtPzhNf0JM6xvF7csfHLSgFXnRCYnc9XT7zaCKxMasc2xKVsJHDDEI+lV7p0nBX
         wV4P2tv9QfJJyt4nhpHLaQ0LtfM/yNVI0BaStgiHNTqQPcQ6zD1/xoy/vvwcEzfb0hPX
         bhynPFImuTTol0qyVMOlt/I2/LPW+r3NVVVbMGRFmRrgqN4QuhOnW8GAP7gE2uk72ujd
         w9Im/6gMwaao7N5U8iKxGvFSW1xfSNUhINDP9Km+1z/u/UTl8IjKhiTczaHFSxUMxHbq
         5a9Rnmq8jfNPP4Cn46CKY1xQc+wgSaR2PwxLlxXLmFTxIIl7X68pb5ZTB1c3PeLNcWVL
         s52g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760854619; x=1761459419;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zvmrmv3hPe2oQTJQT8OKmJhhNCe47YQRwxqYt3ifUEE=;
        b=EBehUs2fcL2fwFvjX5Hm30b9BqFIAtOtUauOC79xu75fy4RC4lH2UgkjhlBiAJUWsu
         iHtFcSztXrS5hZn2jO4DM6XoiQGI5JPNWR/JX+h87TOoo68oKZp899uGwtguWZXQG1sU
         r4bptV5AzCMaiQEVQv8dbbeSUtLGvFm0I6Em5HFlHJobowkxQmhwGW/UEgcsOnUZkjkC
         jELx/inLjeX6cStYTyABWz6Lzox4zA0dD4kIhntCcuJGkz5cXiBDD+dvOa9JRoHOsQAK
         ltJ/dYW4metWmlgaN5ERnWd2ydVdzCxw49Qm4aHK+iwZe2yJxfJNpkjQXVq/k5JM12OA
         tqzQ==
X-Forwarded-Encrypted: i=1; AJvYcCXSHq5EqfY3FxZRq8Qx5FKoE8SRZufrEdPX2+HciVKW7S4q0UyKkkQ4DmdYMVC6H9rK2eE4nHkzag==@kvack.org
X-Gm-Message-State: AOJu0Ywd3kV7GQTU6b4myj8fiItGKXM9H4Kk57aQOm7vfOrbaJfmW9p1
	YzBaJXOhyY+wUDsAbwQ+JsA094kQTkAQjQhvCDAGpCMUq3Ws7NuxKZUv
X-Gm-Gg: ASbGncvm9GAfHqlrKtBzeazVV9Ji1RaVBKRlvYBcL0JD+4FzndTcaS4pX8nd5Xv3rJM
	SQoOn2QM16T3qkg59Ya7RqjJkgM7aSGszYxizTcLaZ30SveKO6pZMUBFITjZ7g37xWEJobFrQVp
	BCpmLv/Ue7t3ml9koKfnm1+Xaf4InFND9rdHmSZ8c6yD5Ui/UkOK0gWWF573Lt41mBGeB3QXDdO
	sSlOGcwYfA8s03z6DSBRTw59DT7RKdSi53CvFRs/O10aaRvuPWCRpr4gvGXiCVjAmDpTdkGGwDv
	ZXpKxh3MaZXv8BRzw8NM25G6T0KUcGPcJ/EQ4CM+zdxuZzMgnpIkmHB8g/zW9jdOjpLlqGtGz5g
	9OrpJOCQN2qb6iiHeZ0rLEDOIQpfPBl8IpmWRvuUKkA0CVOknE87JAdQo2Mu1uAEdE7AQFHG+IN
	jJAAyxLWXCdkVhDVw=
X-Google-Smtp-Source: AGHT+IGr/O8zk+3lAXEyhTOS21GeRIQ7WsMW/dXKVowLJ0bFIrZpOFcNFSeyeDuMLrkyPKnaIvg3BA==
X-Received: by 2002:a17:903:298c:b0:27e:eabd:4b41 with SMTP id d9443c01a7336-290c9c89eabmr108602405ad.7.1760854618954;
        Sat, 18 Oct 2025 23:16:58 -0700 (PDT)
Received: from pop-os.. ([2601:647:6881:9060:bc87:d8fe:3e55:7ffb])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b6f302sm4332032a12.38.2025.10.18.23.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 23:16:58 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jiri@resnulli.us,
	stefanha@redhat.com,
	multikernel@lists.linux.dev,
	pasha.tatashin@soleen.com,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [RFC Patch v2 05/16] x86: Introduce arch_cpu_physical_id() to obtain physical CPU ID
Date: Sat, 18 Oct 2025 23:16:19 -0700
Message-Id: <20251019061631.2235405-6-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
References: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 11625180008
X-Stat-Signature: 4gzwrsh8zzeaoucp9j7u85yk9dm33wwc
X-Rspam-User: 
X-HE-Tag: 1760854619-921763
X-HE-Meta: U2FsdGVkX18IGnkYediDsJ+96CfJa6bmkINiQCWsGTQz0vY2tQo+eOUvm/znzmm81Smj4jopydlcv4BC5Ga5gmI9VIJXy/o5E88qC3MXgQngR1nRl3vzod/wIdxDhyr1400hUrJdhSf6pXKMqhBisnc2dNBPbH6uFiVXBHzYeYqRYsIH0SqQiBUZi5WxAuMKwRQoP4VhA3t6KnS1SCkRzlFSbC3by675j+nClkKEtj+w70sTJb8SzR++Whn2PsbILlcZpitZPthNOqGYA+RZLCTVhHd+pNN3pVFoWGtsCOpIqbSupIY5F9XyoCWiE3XcezEfMJ9a4CQModqO5EQ09F4asO0udQEMizg0jnzGr20b36PK7PFqCqOzBsn2smgoSf/f6b6iAGWKmbEOrmrFyWUVS5hNf7XWDJKYA4dpOIqaStEJGFivbmSKMwJkc6yrRShaDKT9hjZd6ZhDkrUIFMpP3FXL1Zi+bVA0dK/cZYHDBxWDACuDf5sJjRg/rnH0Q8F0ZsInyLA4Vhv7KVxkIaiLoje7lwCSThV+m2Bqs+0sRe259Y7Jv1peTB81hqEc4btEUFa45r6PZ7XDxUuHO0H2n0j9/AnjDD+HXtKRi88xiIwpG9o3RN4MSYdYdKfwKH0spzQi/EXZUzEZkOV7lVA3ZLDx6P7mMSZLc40lbLWDlcOPR0nGFKvxk16rHfb4n1fSiMEKgsmYrZuLtkua911fqopWOUqkm6tdorUfvnLTeQmrAMcCyk9FLBmCG6k1ghIqK8Hsue4Znq9uNPPeoRkx7GVnJT84IxqQCp+ez0wJvRn773+ZMslgIgqAw4dD1vqKbNcpsbCEkmdm9DOYx3u6/FRaphugfjNPZocvNnXfFNtFcC5ZN1sDfusiviiF8EvSOOLc8rN3t62vNECGcETp8tLHYPKoQy+XfBBzD7GESj2AzVqTMmoBvW0lgq+sPFvbrCHj0TcmIhxMA8C
 UhcxKbRp
 ardJ4tPYKrqJ0HyUhMtXVTK0k8EGsHhoX7hUD2hUA5D4XN0TzZtP0VTjxgzEQ5ZS03WoJ7nHzAASdRbUgskzydaDSWvaEGk1j8QheoTJ26FUI7odA4+A9X14mdDdoQaJ/TkJDEh+flD34xA4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

The tranditional smp_processor_id() is a software-defined CPU ID which
is only unique within the same kernel. With Multikernel architecture, we
run multiple Linux kernels on different CPU's, hence the host kernel
needs a globally unique CPU ID to manage the CPU's. The physical CPU ID
is perfect for this case.

This API will be used to globally distinguish CPU's among different
multikernels.

Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 arch/x86/include/asm/smp.h | 6 ++++++
 arch/x86/kernel/smp.c      | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 1a59fd0de759..378be65ceafa 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -40,6 +40,7 @@ struct smp_ops {
 
 	void (*send_call_func_ipi)(const struct cpumask *mask);
 	void (*send_call_func_single_ipi)(int cpu);
+	int (*cpu_physical_id)(int cpu);
 };
 
 /* Globals due to paravirt */
@@ -100,6 +101,11 @@ static inline void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 	smp_ops.send_call_func_ipi(mask);
 }
 
+static inline int arch_cpu_physical_id(int cpu)
+{
+	return smp_ops.cpu_physical_id(cpu);
+}
+
 void cpu_disable_common(void);
 void native_smp_prepare_boot_cpu(void);
 void smp_prepare_cpus_common(void);
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 59658fcd9037..e2eba09da7fc 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -288,6 +288,11 @@ static int __init nonmi_ipi_setup(char *str)
 
 __setup("nonmi_ipi", nonmi_ipi_setup);
 
+static int native_cpu_physical_id(int cpu)
+{
+	return cpu_physical_id(cpu);
+}
+
 struct smp_ops smp_ops = {
 	.smp_prepare_boot_cpu	= native_smp_prepare_boot_cpu,
 	.smp_prepare_cpus	= native_smp_prepare_cpus,
@@ -305,6 +310,7 @@ struct smp_ops smp_ops = {
 
 	.send_call_func_ipi	= native_send_call_func_ipi,
 	.send_call_func_single_ipi = native_send_call_func_single_ipi,
+	.cpu_physical_id	= native_cpu_physical_id,
 };
 EXPORT_SYMBOL_GPL(smp_ops);
 
-- 
2.34.1


