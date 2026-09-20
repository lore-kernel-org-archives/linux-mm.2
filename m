Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF360C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:38:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8DC76B00B6; Sun, 20 Sep 2026 15:38:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B64926B00B7; Sun, 20 Sep 2026 15:38:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A540B6B00B8; Sun, 20 Sep 2026 15:38:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C4886B00B6
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:38:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7D3CB404BB
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:38:44 +0000 (UTC)
X-FDA: 85235152968.24.1F439CD
Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	by imf06.hostedemail.com (Postfix) with ESMTP id C1BFE180003
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:38:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fVn1lOMt;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=748fu/RuSuWEHxLL4+C7te7l41PPhxbrrdqn5kAp7do=;
	b=iVGQwCkYNBW5bWvu/EmDYSun7c4esbOHP30Cwi38G/jfEy6E5L0stHhHhXDhG6h8/nlF+T
	A6Zv4thOT1ZHeVrjIVqxJuqlzvg+Trb8kj+z633wYBcB6u08GtTAkdxKYsEQ5/FBHnAp8C
	oZ+j5mSjOTaPbzXVlxWAy6UYnW64hNM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933122;
	b=fOOH5Vckox6ntUfXyN50Y0C016DBabELBt321+/rOl+mKbtJozDWT+V+59kcg0a9egIzqW
	AUmCfpeCuW+1iorVAlZVUgaalQItPkOjW/s965enQG8F8yBtcpRHDI8IFlTUK0LOPlzrdM
	serYsLjLHKccCDDOR4dgwv37+5jC/iw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fVn1lOMt;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-yx2-f13.google.com with SMTP id 00721157ae682-85d43ac6072so20937717b3.0
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933122; x=1790537922; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=748fu/RuSuWEHxLL4+C7te7l41PPhxbrrdqn5kAp7do=;
        b=fVn1lOMtQUPBx4uwZujWukOFyqNAYk1qvAmzk6aEPSioTaHrQ5V6MfzAC65LHp/prH
         JeDcPC0lJZ2Hn5WddpNyykqXUvX0zvmV9UISQikGb4eb84BH8UosCUmak9WkQ86i1Ldr
         XkdhAgQj1XxOu0P7G0JbrvJ7UEeUQDCNxzbK+eYr2GvagQVIFTn9J3DrrL8Te28atTLY
         gzwpy8g2z3StKbvKvK+4pHHrwxofzSl9AoJwjv+igcWoCZpnGz0E/kF/M/7itnmM6fdn
         Newk1/yQZIDS44OIYdC4d+YPKl0s1QXCbGG9bGaJWyBehmX+kAfazySVyhoOxcyk7h3j
         ujww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933122; x=1790537922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=748fu/RuSuWEHxLL4+C7te7l41PPhxbrrdqn5kAp7do=;
        b=wfbUdv9LAPlHKYFBsVf8NkIypRj9uzahmT27rzZtIJI7BrlNKTZzDdmcB1HWMfeOqT
         rhYfdgf+9b76g7gwmJ+vByu+UlMAKMxOO1IHcgCSPzRYuZxJ1cwnyjX53iDOS2iEq/+k
         HTb+lXmg8QxKjczOh6/maL4kdv2lpY5zRpTlKZ9PLY15l6FsVESJ3AdRnd8oXalXZf1A
         23V2j+1IUpEJ9Z78Iedp4ZqGwiDFzaba8MeRChbtSdgzwxV2kc+m+8iba+kTYsVfg/xj
         78pNu13DHSZ5AWbA8spJ2SPehqf0vWZeXUBHvtqq8CtQx+88RarVmjS/bHNMcQ/qEV1Z
         U7Rw==
X-Forwarded-Encrypted: i=1; AKwUvBzuhuSUmC9G+Zon6ru7mp1MgoIzkRUWdMD5sNEDe6BKuFnMEHQlujCw0uz0sA8YqqiJcIrDb02ZAg==@kvack.org
X-Gm-Message-State: AFuF++nl/heIyPjydMeycHbXe9sGfAUn4tfQfImJ1XzRntijcR0sExZJ
	bw9+zP+vWtmPqGREzdCzpJxmGXE611MXby8bkz8eh+W6B50SvepwsubUz0BAGm4X2e4=
X-Gm-Gg: AYBFou0RbZubHf1j9wtiiSmtlwzgrMvSQSAuBzvAH9eBWifCxJPgoFKKRPVHd6SPwpC
	gD7HWG4ZMQus2wZ5CP5nc7sbbA8mhPrVP+21Rpv4ddWkPOy5bZfpLeJWUgHk2WyPChJIDHri4gk
	V1IE98ylL3B0WtmhcTouNqCA9qEaRBkNKFWlJ/PaLZs0RlPmDDy3qSp8QlGpvwMWo+esISANbCM
	cQG1Rdp06eUrnD2zysu2piUHkt+AMqJDh241sRPt8nSCKY98+ZjSERZAsipeLksz7Q/VLe1e0PK
	mYYPklqjOfOEFSpp5ihWx6Zn3PTgDX1cm6OMx+dCKFzXSFC4VVhJsGqS7qP32PNEMsdjSiqT3Hm
	cxNRo4xDbEBSDVt1oy8DGEaj/y4PTyz5vZDdNJO0lVhN+NcWEEOaVByyCDn770990iNhs6uFN/T
	fkAPR54zKk4YfgcfmcTOzk6AcpUpmmAvmkKKA1x84UxWz9i6JwwD2nSrT7qNJJoif9n8Bs+yqSR
	6gMhFudmHH/avIRlqr7ro/+p0EQqrjyjWVAt7qH+Na6qQA5jxei6x3LhNR/7BV+x3OO/cj2R7jL
	xA+EJf68a42qX5b0rZprWdtJWWurNcc=
X-Received: by 2002:a05:690c:6a0d:b0:857:f33:6f1d with SMTP id 00721157ae682-897311d51a6mr25294217b3.6.1789933121962;
        Sun, 20 Sep 2026 12:38:41 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a41521d6csm18803647b3.1.2026.09.20.12.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:38:41 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 18/46] liveupdate: cpu_preserve: Add LUO file handler for preserved physical CPUs
Date: Sun, 20 Sep 2026 15:36:22 -0400
Message-ID: <20260920193650.3373435-19-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C1BFE180003
X-Stat-Signature: kx7eiuwuhjeucx9ome97tjazcrd5qjod
X-HE-Tag: 1789933122-961505
X-HE-Meta: U2FsdGVkX1+qv/qY86w+mPqQqei/dRFEZUWj5PM4SSd4MkvXc9HBmQ9zJUxGO2dOBwGFPC8JinPfp1g9StDfONlZq4wHLgjWjZwhC0XCOb8kf/f5kCxsJxGH02MZT0I8Tv8Blt8NdbNlMWamfDC80O+/arataeeqx8+qgll1tGgF86x+IUH5NNPhmyd5jByEhPy+gkZz0VLSBmICAf5haHuEl4thQFmXMRubC8bfnO8PWEUXs65Y4TrBs3jUQBqdnl0jBGz2Yh9VbmiP9bZ3uIgvKXbsOsCr3zSSA5B3AQJiMjEnhkvJ/ZbHOGU+yF+ET9NE6rgXxCQwt3VZVW04x1G1VSiQ4awdJHzEgzrznH5CeHmo+nFFwYuO70hTI6gXxXR5W+QM7u4inuF94ZbLeAJYP2KYFRT+yvZBkDGlnsMT5DVesFA+cZH5aVAsBafSIsAKAKoubKHZO3jb/vGOZpv/F1PP9pCH64Y9ZN2GRD+9JN3hYPAkFVQhpZRUxWGeqv5IsYPE8+6mCxr6hdXB8ZcB8jbPU9UNSl4bpIlOxiZ3+dZWWiwAVHuM6VGfgrphEP81F9lqzB2uNPHWpcP2tKjCOsjSMfxIdsYSlqdz2acc7VoCHTwUWoFq62+ZwbEJr2Il5x47xMESdcL9zmSfy7kTYU6vrlGgCvLScc51hWwhkS//RNfpot5md2KGHQMbmr/Z1j2Gb1GanigliAvofgGq9da1PlkwAdGIfK1EnfzFgO9Gpy2oqZqC9DgJfhvGMR9MrxeDgOH4mPQd1PLqCNwfT0Xsqe1VgRXDa0p+TwqOnQ5153NkznBZh2i3fQRsysioEoax1VaDC9MW5HVWQqjqpD6K2CDWzebKDZ6optZfe2wgpey9sbqjbp7H9j+/GL97XRgq0URg+EYaIC3RdH1nb2LYyPoOWhiOrsNRKYPxWlyWlWa7CJtVz+coU8+qaCDKTSngFmmuJqfYx8w
 FMcP0IKI
 0puwE09EtL91zpRIuDPRPP6xyhYMjy18r9PdYtiboqYBeFF+nmUMO11syEHI2436L2kaSxLunQiZNraPlHd7VIQN8NbH72a7Z3Osr+qrAzLDkbamrKbkOAKi9h2Lbb+CCXmEYDkJzpR3v9CZBPJ+OZPWVgXMssahxudzxfehsIw4eEB3YcDSp2UzXHfkjPSw5iYKY73kQUe43uBGyWE6BRJHHLTbEUagpcbRRiYjm20/kVbzrmn6Hx9/B64TE0Mx5AV1ajM/I/PazwAmQGU9JHJGUgYVJ82ttmcMywx+VvkiidDqaxGb4HwnmYf/RQn72cpYT9a2vmqggKU0RhtJUqN/DHaPvTjXC6Ybn6RNjMCSW9CUQF8XBglBU5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the LUO file handler (cpu_preserve_handler) and early boot
incoming CPU adoption for /sys/devices/system/cpu/cpuX/preserve fds.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/cpu_preserve.c | 189 ++++++++++++++++++++++++++++++-
 1 file changed, 185 insertions(+), 4 deletions(-)

diff --git a/kernel/liveupdate/cpu_preserve.c b/kernel/liveupdate/cpu_preserve.c
index 2f92dfee82b1..9a039ba9e912 100644
--- a/kernel/liveupdate/cpu_preserve.c
+++ b/kernel/liveupdate/cpu_preserve.c
@@ -837,8 +837,10 @@ void __cpu_preserved_text cpu_preserved_set_dead(int cpu)
 {
 	struct cpu_preserved_pcpu_ser *ser = cpu_preserved_get_pcpu_ser(cpu);
 
-	if (ser)
-		WRITE_ONCE(ser->workload, CPU_PRESERVED_DEAD);
+	if (ser) {
+		smp_store_release(&ser->workload, CPU_PRESERVED_DEAD);
+		cpu_preserved_clean(ser);
+	}
 }
 EXPORT_SYMBOL_GPL(cpu_preserved_set_dead);
 
@@ -1097,8 +1099,6 @@ void __cpu_preserved_text cpu_preserved_park_loop(int cpu)
 		switch (READ_ONCE(ser->workload)) {
 		case CPU_PRESERVED_EXITING:
 		case CPU_PRESERVED_DEAD:
-			WRITE_ONCE(ser->workload, CPU_PRESERVED_DEAD);
-			cpu_preserved_clean(ser);
 			return;
 		case CPU_PRESERVED_WORKLOAD:
 			cpu_preserved_run_workload(ser, pcpu);
@@ -1131,6 +1131,7 @@ void cpu_preserved_park(int cpu)
 	} else {
 		cpu_preserved_park_loop(cpu);
 		arch_cpu_preserved_park_finish(cpu);
+		cpu_preserved_set_dead(cpu);
 	}
 }
 EXPORT_SYMBOL_GPL(cpu_preserved_park);
@@ -1498,6 +1499,171 @@ static struct liveupdate_flb cpu_preserved_flb = {
 	.compatible = CPU_PRESERVED_LUO_FLB_COMPATIBLE,
 };
 
+/*
+ * LUO File Handler Callbacks for /sys/devices/system/cpu/cpu<N>/preserve
+ */
+static int file_to_cpu(struct file *file, unsigned int *cpup)
+{
+	struct dentry *dentry, *parent;
+	unsigned int cpu;
+
+	if (!file || !file->f_path.dentry)
+		return -EINVAL;
+
+	if (file_inode(file)->i_sb->s_magic != SYSFS_MAGIC)
+		return -EINVAL;
+
+	dentry = file->f_path.dentry;
+	if (strcmp(dentry->d_name.name, "preserve"))
+		return -EINVAL;
+
+	parent = dentry->d_parent;
+	if (!parent || sscanf(parent->d_name.name, "cpu%u", &cpu) != 1)
+		return -EINVAL;
+
+	if (cpu >= nr_cpu_ids || !cpu_possible(cpu) ||
+	    !cpu_is_hotpluggable(cpu)) {
+		return -EINVAL;
+	}
+
+	*cpup = cpu;
+	return 0;
+}
+
+static bool cpu_preserve_can_preserve(struct liveupdate_file_handler *handler,
+				      struct file *file)
+{
+	unsigned int cpu;
+
+	return IS_ENABLED(CONFIG_LIVEUPDATE_ONCORE) && file_to_cpu(file, &cpu) == 0;
+}
+
+static int cpu_preserve_preserve(struct liveupdate_file_op_args *args)
+{
+	struct cpu_preserved_file_ser *fser;
+	unsigned int cpu;
+	int ret;
+
+	ret = file_to_cpu(args->file, &cpu);
+	if (ret)
+		return ret;
+
+	ret = cpu_preserve(cpu);
+	if (ret)
+		return ret;
+
+	fser = kho_alloc_preserve(sizeof(*fser));
+	if (IS_ERR(fser)) {
+		cpu_unpreserve(cpu);
+		return PTR_ERR(fser);
+	}
+
+	memset(fser, 0, sizeof(*fser));
+	fser->cpu = cpu;
+
+	scoped_guard(mutex, &cpu_preserved_lock)
+		fser->stack_pa = cpu_preserved_outgoing.pcpus[cpu].stack_pa;
+
+	args->serialized_data = virt_to_phys(fser);
+	return 0;
+}
+
+static void cpu_preserve_unpreserve(struct liveupdate_file_op_args *args)
+{
+	struct cpu_preserved_file_ser *fser;
+	unsigned int cpu;
+
+	if (!args->serialized_data)
+		return;
+
+	fser = phys_to_virt(args->serialized_data);
+	cpu = fser->cpu;
+
+	cpu_unpreserve(cpu);
+
+	kho_unpreserve_free(fser);
+}
+
+static void cpu_preserve_restore_incoming_cpu(struct liveupdate_session *session,
+					      struct cpu_preserved_file_ser *fser)
+{
+	unsigned int cpu = fser->cpu;
+
+	scoped_guard(mutex, &cpu_preserved_lock) {
+		cpumask_set_cpu(cpu, &cpu_preserved_incoming.mask);
+		cpumask_set_cpu(cpu, &cpu_preserved_mask);
+
+		if (!cpu_preserved_incoming.pcpus) {
+			cpu_preserved_incoming.pcpus =
+				kcalloc(nr_cpu_ids,
+					sizeof(*cpu_preserved_incoming.pcpus),
+					GFP_KERNEL);
+			WRITE_ONCE(cpu_preserved_host_pcpus_va,
+				   cpu_preserved_incoming.pcpus);
+			cpu_preserved_clean(&cpu_preserved_host_pcpus_va);
+		}
+
+		if (cpu_preserved_incoming.pcpus)
+			cpu_preserved_incoming.pcpus[cpu].stack_pa = fser->stack_pa;
+
+		cpu_preserved_clean(&cpu_preserved_mask);
+	}
+}
+
+static int cpu_preserve_retrieve(struct liveupdate_file_op_args *args)
+{
+	struct cpu_preserved_file_ser *fser;
+	struct file *file;
+	char path[64];
+
+	if (!args->serialized_data)
+		return -EINVAL;
+
+	fser = phys_to_virt(args->serialized_data);
+
+	snprintf(path, sizeof(path),
+		 "/sys/devices/system/cpu/cpu%u/preserve", fser->cpu);
+	file = filp_open(path, O_RDONLY, 0);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	args->file = file;
+	cpu_preserve_restore_incoming_cpu(args->session, fser);
+	cpu_preserved_detach_workload(fser->cpu);
+
+	return 0;
+}
+
+static void cpu_preserve_finish(struct liveupdate_file_op_args *args)
+{
+	struct cpu_preserved_file_ser *fser;
+
+	if (!args->serialized_data)
+		return;
+
+	fser = phys_to_virt(args->serialized_data);
+	if (args->retrieve_status <= 0)
+		cpu_preserve_restore_incoming_cpu(args->session, fser);
+
+	cpu_unpreserve(fser->cpu);
+
+	kho_restore_free(fser);
+}
+
+static const struct liveupdate_file_ops cpu_preserve_file_ops = {
+	.can_preserve = cpu_preserve_can_preserve,
+	.preserve     = cpu_preserve_preserve,
+	.retrieve     = cpu_preserve_retrieve,
+	.unpreserve   = cpu_preserve_unpreserve,
+	.finish       = cpu_preserve_finish,
+	.owner        = THIS_MODULE,
+};
+
+static struct liveupdate_file_handler cpu_preserve_handler = {
+	.ops        = &cpu_preserve_file_ops,
+	.compatible = CPU_PRESERVED_LUO_FH_COMPATIBLE,
+};
+
 static int cpu_preserve_reboot_notify(struct notifier_block *nb,
 				      unsigned long action, void *data)
 {
@@ -1555,6 +1721,21 @@ static int __init cpu_preserve_early_init(void)
 	cpu_preserved_incoming.pcpus_ser = NULL;
 	cpu_preserved_global_ser = NULL;
 
+	err = liveupdate_register_file_handler(&cpu_preserve_handler);
+	if (err && err != -EOPNOTSUPP) {
+		pr_err("Could not register cpu_preserve file handler: %pe\n",
+		       ERR_PTR(err));
+		return err;
+	}
+
+	err = liveupdate_register_flb(&cpu_preserve_handler,
+				      &cpu_preserved_flb);
+	if (err && err != -EOPNOTSUPP) {
+		pr_err("Could not register cpu_preserved FLB: %pe\n",
+		       ERR_PTR(err));
+		return err;
+	}
+
 	/* Retrieve incoming preserved CPUs before secondary CPU bringup */
 	if (liveupdate_enabled())
 		liveupdate_flb_get_incoming(&cpu_preserved_flb, &obj);
-- 
2.55.0.1082.g2b9226bbc0-goog


