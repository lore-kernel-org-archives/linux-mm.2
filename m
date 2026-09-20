Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EB8AC982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:38:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FDAE6B00B2; Sun, 20 Sep 2026 15:38:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D4E06B00B3; Sun, 20 Sep 2026 15:38:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39D3D6B00B4; Sun, 20 Sep 2026 15:38:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C2D886B00B2
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:38:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 163BC1A04EE
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:38:33 +0000 (UTC)
X-FDA: 85235152506.29.2558488
Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4D733180002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:38:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ug6LoGOB;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wVg6Gk8z5CmekkaH13r0qzA08Wiru8yJiEs8XX/Voco=;
	b=1vTHHnbVxc4NChuxe31Wu9WPZEJzplVWj83g5dyog8hu1OX8coH2GSgW5SFF/Mlo3Kyje8
	EKObZZCDwkzdBPMTncNFerJoCI5NJz/plIAPkrA4Hk7uRJp3dEERXG9PspM/miy595x6C5
	gSO6Jyznwx0ySXKQMkI4ETV1GwD+ciA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ug6LoGOB;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933111;
	b=sIHYiJfZ6Q1maknXrvBzRzo2KqOSzlvrK0Jlfv2clyni3/5KysQCDGoFvygdQ5IKo/x2i7
	C+BaujeU0c5CuqAQN7K9zka7F3PDZrn/7O4DXnjwywa/PkeRRCLufiYx/logFhMFiDqUlT
	GDwCVfotPWfrGDWsU2G5SIVSvm/Mtb0=
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4ab19125so2187660d50.2
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933110; x=1790537910; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=wVg6Gk8z5CmekkaH13r0qzA08Wiru8yJiEs8XX/Voco=;
        b=Ug6LoGOB8CI6HPxkpmbEE6M2zxY2EFjWdAsitGt2tU8/ZSIztH8lz7+eY11dF7zj8/
         Rm1ODxZrxzvc3Mv+Cm+Osc9yskAKJK7zH3HoQOqsrCeOvgK4DNiYdDGsPxCBF3+gL9PF
         9RFOlcw+m4Yzce5VYhAQnYueL9DFKWMEYWfz5MxJt5TRchJkcNkFt1EhFZ1N82yl1LEA
         Zba8W7ZKItV5uBSSnoKfZVLr3jXikJfl2eOzEqmKtpkWbuTg0jjOY+q/L6lz4DRvA2c8
         JQbjc0ArKNjb63UaegHqJt3At1c2+iZ4/t7Vwc2Yw0pFUkGyAzdKy726GodclckEgZhN
         pTNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933110; x=1790537910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=wVg6Gk8z5CmekkaH13r0qzA08Wiru8yJiEs8XX/Voco=;
        b=dgoWiiFXMvHKH7aWfOJckZDlVBPq2krY/k591kzcdNtkn0I9ip79MxPBIxGMJjZWQ6
         2sYlo3aKwJ1y7OFbJcgmJO/knm0bF6F3frLmHw0fsOaeh7VfstoEY405YV1yJE3FgKSL
         O7xmJO7OB3izCU1FdrNu1PJ1eIBfbDdOdWUQGQ0hajX1hkY+33JJAT7JQXbdgkduEP3r
         J0F0iyK3y9KIh8QSkIcOU/xs6PTtpTHn5HqCvvM0699GdQiznIPOTt5W9PZxY/nUWlkS
         LoQSxrNlUurbIadBOzXDSNFoQL4lzvRZMtL+D5nfNZ7tV9IZaXVv54hYheQADeLzYqWs
         d+6A==
X-Forwarded-Encrypted: i=1; AKwUvBw7mIEqmFsxxZY35tpVi/7nLjAFzJKVXheR8zjpFKse0nkAzvWbm3BbdWulBuX9KQkZY8KG+qnqPw==@kvack.org
X-Gm-Message-State: AFuF++k3lbpfD0VjsR20neZNyW6Gjr2cX/7bmOGuFPAu6VzSzy3eY6Qn
	0LYkenVaBTT9Egf/wcZs3st5761s5iOklaV/KfAQjYvoFQpEHLmknV3Mt8bGfd/BPHI=
X-Gm-Gg: AYBFou0Nk/njXlmjLHnktit2j4A95Y850XhYAVyo1h1vHLfJ/7UqGz7JbtQLYIeWEdX
	ZmlJbJmwTGUfJaDCVXXKtDirWUgjbT8gk3g+b4hHTDDlT/duJccrNxU/F7XUlvUb+BreWkaZgtO
	8wvXSdhc7HlGcSyGDnyuk1LqvpnHxlIMr97wtMEQSGwqXBK0DdHZ23vFpOLNXm/Kb0eTtAeze4D
	AULHXACpRlP0CSUVhH4irZYrUcIhhtOba6vEWF3FvAQVspkwDeq+Q8KdAeyQ6TCgO9J1IA/uHjJ
	06jPzXERxDIVsRecmrtaeGYK8n+ZwaxF2tZvo+whHibDmu9VNvrqzottFX+6W+RBWzT4HxWC6Ra
	UzHzalLB8KnXjEFqh2q9bxty/5TIxzSJu4JhAkv8Db+gJmYvnlMzu6va4B6m7X5qpunqwL0/gsF
	jZfMn6mhzXJUc+8lbAz/st7IGM659yJs+a0UoC86uFAPqKZluWoOeNHG5H+awImabwzaZK9Fj7f
	GFifcFoCwMgoqNssIs/EG0ZKabMwXHA+TAx+zOUbsNcJasSM7np9c/vqrGYzfo7kqckX6eRRQ/Y
	81hU1cSOXctud46Hozg=
X-Received: by 2002:a05:690e:144f:b0:671:70d2:527e with SMTP id 956f58d0204a3-6717fd6bc1bmr2723101d50.65.1789933110380;
        Sun, 20 Sep 2026 12:38:30 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67299104e3bsm2626871d50.15.2026.09.20.12.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:38:29 -0700 (PDT)
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
Subject: [RFC PATCH 16/46] liveupdate: cpu_preserve: Add sysfs interface
Date: Sun, 20 Sep 2026 15:36:20 -0400
Message-ID: <20260920193650.3373435-17-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 3nzr3mu7xpyhyim4hosmjomei786t3xg
X-Rspamd-Queue-Id: 4D733180002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789933111-712322
X-HE-Meta: U2FsdGVkX1+NnhNNgOGihAohE9JdLGoqkP0STQea0ZtqU/M+yo8KfkSUqd9Gv8tlSGlfqjQoPSjzYsnSU85HWYccnojhjzoYhz5JxaCOa2GfShK3K09K6fgjiPeAu4rstEy+qk8a5gJ/1inQtxgTvikWwaCbaGW4scO8YdpIdDhgiusqw7A8okB0hqXSUNs/eWEHz10ulSMlpuEVEr4ebh0m+SqgqAP6hvAC1H0BL3+3WZBzhnWxAUZqRnw+4T/kqnEKe7jz/8Q43+YaG8kVjk9sMGx8jGsdzO4Ej9Kz7ERnoRYufIQzQqfCDxGRUv3ZPuF5clJtVJslTnQbJHp4sTn7/xAuECPQ3Osri1HuywDkt+73EPzwU90zfPfsplDJ2HrWnHiAfylApvQhEYaUOq2MCamqMesgMlk06Vy7mHrHYLd5HXVi+J7/C3ZILurDLGEKWL1xovJqwTBjdk7nG6mp8U+t8/9fRVR/BM4i40eDqJlF3oabMoUpUAiXGuGb83qxVTUCiOQjlCsnvSAOXMXxSRaZATSsdGDK9Ng1lqqX6nMw5eZVgs0/gP4U7mLoMaOOspurYWs8PCewE8mC4i8/idWz26WdnYFCtp9RUDlS/WZzZfVYo9z4MhfyLYrSSAPc0lLWXlwSEwyZkUOIT9viG7mnr/xemFqRjHN9FabNgW5vKJzPmcoIItTjWVTaewQ1meLtWwOyn1VFfQfeAy/YHNJ04yIEa3cMtOeseT+nj400xTD1SgOxhJzASdsxHf5PoWpAJApBY7O3YY/YqA6luHNiuammmjdJkZtuvhMF1Rwa8WGFGvGxSoRlIr6BG4xu1aX6XwpN+nCKwjWRK1Y9VNGGzxFmNV2dkV96wWZk7LpS6naVr92r/6Lr6+BU3/xtFxHm+tV7nZ/YGdQ2X0FjBqaqnjhkIBPCTmmORqcY9mqKraLeP8Bhgi+8JaUno9geCxoEX+5RSNyBlEN
 fNkQbuzX
 sew+dT5vIXzuHRmaHWGLSypbOCSbW2pcNVhzpsBmmEKzA/dxf0o6A8OaxXULPfJ0gHahtDGBv6nCqj5zqV88BAiB8F/+XgjSIOd/QdraiS7yIKvjG4h749Sesblme1f38imf9ihPjKk5ZkwwzEhywWz6vUuwUGCK70F25UHq5f8UD5WIcE9dIkrhIVEQ3lGB+oqKR3dwsL6VUDT/cZlSctG330vCQkgZM1eMzc+KRkU99uk5EXhPZM8H8lBhpl1uYUSAto3MBdHyZBp7oQF0FOaUVfiC1uR82DL5W6f7IbMvO9UFoXAGqgzAxlWa5rS75btp//HmNZAVGS4TE9ZXn1pgHSPGtfrxtzpJ7hj3XUUZg1aLrw256wa6JPfmhLszzLLG9j0tNP7YQoDx0lDxFG+soJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Expose /sys/devices/system/cpu/preserved (global cpumask of preserved
cores) and /sys/devices/system/cpu/cpuX/preserve (per-CPU preservation
attribute and file descriptor target for LUO sessions), and document
both attributes in Documentation/ABI/testing/sysfs-devices-system-cpu.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 .../ABI/testing/sysfs-devices-system-cpu      | 20 ++++++++
 kernel/liveupdate/cpu_preserve.c              | 49 +++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 82d10d556cc8..88ab03efd433 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -806,3 +806,23 @@ Date:		Nov 2022
 Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
 Description:
 		(RO) the list of CPUs that can be brought online.
+
+What:		/sys/devices/system/cpu/preserved
+Date:		March 2026
+Contact:	Pasha Tatashin <pasha.tatashin@soleen.com>
+Description:
+		(RO) cpumask list of physical CPUs currently isolated and
+		preserved across a host kernel live update. Note the naming
+		distinction from the per-CPU /sys/devices/system/cpu/cpuX/preserve
+		attribute.
+
+What:		/sys/devices/system/cpu/cpuX/preserve
+Date:		March 2026
+Contact:	Pasha Tatashin <pasha.tatashin@soleen.com>
+Description:
+		(RO) returns 1 if cpuX is currently preserved across a host
+		kernel live update, 0 otherwise. Although read-only, this sysfs
+		node exists to be opened and passed by file descriptor to a Live
+		Update Orchestrator (LUO) session via LIVEUPDATE_SESSION_PRESERVE_FD
+		to request preservation of cpuX across kexec.
+
diff --git a/kernel/liveupdate/cpu_preserve.c b/kernel/liveupdate/cpu_preserve.c
index c5fd3a07ccb5..cc27d1624d29 100644
--- a/kernel/liveupdate/cpu_preserve.c
+++ b/kernel/liveupdate/cpu_preserve.c
@@ -606,3 +606,52 @@ static int __init cpu_preserve_early_init(void)
 	return 0;
 }
 early_initcall(cpu_preserve_early_init);
+static ssize_t preserved_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%*pbl\n",
+			  cpumask_pr_args(cpu_get_preserved_mask()));
+}
+static DEVICE_ATTR_RO(preserved);
+
+static ssize_t preserve_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%d\n", cpu_is_preserved(dev->id));
+}
+static DEVICE_ATTR_RO(preserve);
+
+static int __init cpu_preserve_sysfs_init(void)
+{
+	struct device *dev_root = bus_get_dev_root(&cpu_subsys);
+	int cpu, ret;
+
+	if (dev_root) {
+		ret = sysfs_create_file(&dev_root->kobj, &dev_attr_preserved.attr);
+		put_device(dev_root);
+		if (ret)
+			pr_warn("Failed to create cpu preserved sysfs attribute: %d\n", ret);
+	}
+
+	for_each_possible_cpu(cpu) {
+		struct device *dev = get_cpu_device(cpu);
+
+		if (!dev && cpu_is_preserved(cpu)) {
+			set_cpu_present(cpu, true);
+			arch_register_cpu(cpu);
+			dev = get_cpu_device(cpu);
+		}
+
+		if (dev) {
+			ret = sysfs_create_file(&dev->kobj, &dev_attr_preserve.attr);
+			if (ret)
+				pr_warn("Failed to create cpu%d preserve sysfs attribute: %d\n",
+					cpu, ret);
+		}
+
+		if (cpu_is_preserved(cpu))
+			set_cpu_present(cpu, false);
+	}
+	return 0;
+}
+late_initcall(cpu_preserve_sysfs_init);
-- 
2.55.0.1082.g2b9226bbc0-goog


