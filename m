Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6D91606A327
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 17:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=kO9Mwnf4
Received: by kanga.kvack.org (Postfix)
	id AC7666B05B8; Sun, 25 Oct 2026 13:40:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A51686B05B9; Sun, 25 Oct 2026 13:40:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F1A06B05BA; Sun, 25 Oct 2026 13:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58E4E6B05B8
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:40:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AFD6FA8160
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:30 +0000 (UTC)
X-FDA: 85361863020.07.6D4BE37
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0B100120005
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kO9Mwnf4;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792950029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1V5FDGF/e6SVBVJsOb1x0mGzHREcuT+Gfnqc1J4W+DU=;
	b=UsOnYvDjIZp4TEXW4TYPJC34BPdZ1T+tX2ql1rtxsXuB/jNU/ZLXGheLjAWgXaR4pubWSw
	XRsr7AdmjjxdSrzFDY0mL/w/PHI9WceqjkJP+GBmgwm/jPJa49VGjXPyI+7uhFIcPdjDkJ
	e68ZWFTGSfUNkFEMbG6YUqn6uvj4CDk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kO9Mwnf4;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792950029;
	b=4b3mjdoCiQ5CB9oVFzCu1MSKT/oc/XJdfCXZgknhm2S1w6N/dFJh//5wT6VyBgxzmzsR+z
	nPWCBYx6n+6r/bgw0DBaTIo/c+fILdEQcjDwUABU0c42OJCm5fpOFlcguqAJTSWzV1bVRE
	mWUGdBmgZ+koXzmBdCubepKszpxDQgA=
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-5eaefe5b523so1831990e0c.0
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792950028; x=1793554828; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1V5FDGF/e6SVBVJsOb1x0mGzHREcuT+Gfnqc1J4W+DU=;
        b=kO9Mwnf4i/fmvfi/GmDpBF+SAcWLqMjoXvGMRUfz1stny318ShNw0CkrKmNKAiXDF8
         DnH7Plz66bvsDZNzl6GfEGQncZQgjsp8vC1ELfc4P6bIPJgAHgpW3Q0EjauXNVEbpnmP
         armX5UaRYE5QBNqj2EPhFel38MzVi/ciClv3Ov+NYHKrNzrozI4PIQx+q4vEUPITpJYO
         g1ef92CLbJ+ynNuOewbuXh9ZHGltbIgYwL/nAJ+Z2IGWkkIVgMslwh01uCiZPJGhlm+Q
         8raYbcbDWrDvjEVpZNEJTfk8OLOdC8MAoY6bCnFuiABjnRq5sLmLqQqkgLsBOJ8lVwL4
         Y5Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792950028; x=1793554828;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=1V5FDGF/e6SVBVJsOb1x0mGzHREcuT+Gfnqc1J4W+DU=;
        b=J9Azk3WbwUPhc/VRqPuAGEghOk/U1QJptZDMLTeTGLW1MizftBLPEgjr61tZr/BCjF
         CGH6i4L+FJ42KHWQnLq8Ly3t/T3wC8o2LWMptIeYalfPmqUNhTvX11WRk6RrfKFuKiDx
         H/SboGmyWQzNxBDNxfQMZgLPZhPpnhTQt54SEt3a5jZQbCwRO1CueSmVWf9q/ZFIagAz
         bR31H+HEvMKo0b82kqtCq6/PyvGIl84YptPM8vJUWYrFEjRkI6r4vyB5zUzzh6tvIrA9
         7up1v6w9V2NLqQdeHZwYrYDIFFmRF2U24rOjak7vNm27GCsfQM3BcPPgKGh51XF89B1L
         tqaA==
X-Forwarded-Encrypted: i=1; AKwUvBzzc/9QpG1cmmnge66J/NTZJ/0uXDypxqNuy+bO0oPH+29iIWKrSDYr6jXJktkNtBM9n/F6Pl5zhQ==@kvack.org
X-Gm-Message-State: AFq9FYKq6NUGTRTh1uq6E1GVB6nzd12o/Os0smSIQlLnzWsIG+cK4ZUh
	78QonjC7JcsnTppQRlArw1lbA3A3RS+MsujS/eUqcrMT5l1v7XVNXnx8/W151hgal48=
X-Gm-Gg: AYBFou1gmme2iPM7b/4VAH1t2pK8XfmBYaZ80lkRIZApxpdtBeGpOWma4mLn841Ut2z
	/vUquQRTq5k4d7gaTQTnMXlGTZ7sFIpCZ6yELUXunIS9Wc481bQ/mEtXZdtJhNygdIN6QoOcgd8
	rDFWD/AyscS+xXOLaFUOqVUobXTPk5iPkpwQB6gfO2+g1oZ2EdeuzIKdgNzZutUEVfj31YeQTwu
	7O74f1wBSynQDPhmO9eVoPXMXeIffKc/Q6t4rVzVkvIFyZjnecF8O5OxFPlWu/1onuZHmCNNxjq
	yxl4Chbk4tEC5MdwpuNQX2RqLL+PvXS5oHOAEo4Tdz+zCQfZqAFj0uWKcrPTOedzjaRjhNhJR6H
	KvJb8cyAu/BrejT6/p81QXpoRJVh/7qa4OO2dzkULTFPu0j4N5haIidAtegL8ZYH6jYXTBjBWwZ
	kgeCySmqb0NdlcRpVhpFTF/sC/k5YXugy07Ha/2xoCvlR/x7LP4Fpenhe98XvdGqCP1Nz7VD6YX
	aaPD3sfQhgBTt8wudHoYoAi8Q8keo2NeK5t8cJe1PZkQvg9tjTSw4bumYakQxmwKTvX7scQKrVr
	dscbb6e2j/hwco2fjIEFHfVrsK5TYgospulCr2oZsVzAAPI9cG30Qn7EyAXIhUjvMciyFlgC1w8
	GzKqVNnbz698p98P/u3QGyw==
X-Received: by 2002:a05:6122:50a:b0:5ea:be1b:1b66 with SMTP id 71dfb90a1353d-5ec22ecf5f6mr1525623e0c.0.1792950028135;
        Sun, 25 Oct 2026 10:40:28 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec234673ebsm5783333e0c.13.2026.10.25.10.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 10:40:27 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	kuba@kernel.org,
	enelsonmoore@gmail.com,
	bp@alien8.de,
	shuah@kernel.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vbabka@kernel.org,
	dapeng1.mi@linux.intel.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	surenb@google.com,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	elver@google.com,
	graf@amazon.com,
	lirongqing@baidu.com,
	liam@infradead.org,
	jlayton@kernel.org
Subject: [PATCH v2 6/9] kho: support read-only KHO mode in KHO core
Date: Sun, 25 Oct 2026 13:40:13 -0400
Message-ID: <20261025174017.3870481-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
In-Reply-To: <20261025174017.3870481-1-pasha.tatashin@soleen.com>
References: <20261025174017.3870481-1-pasha.tatashin@soleen.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0B100120005
X-Stat-Signature: hguxtfqnjrnpa5kpgjrf9s5krxq3r9kx
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792950028-875318
X-HE-Meta: U2FsdGVkX18svweC4kfxnFI1AC4XOd3mjw3DtktM40sty5PTFG5aj0Vlw4bqrYnzIryfWYIe9qRP+fKcw17cQ1w2hETzvRTApRh0oonVii6AF7gSPbByaGrTAnnHknS5pTRDecGFqA8dVl9wXZvUrspMPDMTLbkto5uIGsGFAL41g1KrJbdkU2rGbbVp2Azls4iLbV1o4HqAUuWTZ/fprZCqCzEgJppPBsvO4FFKR2gLiLUU8kk6141P6K3fhemuxxJzybRarDeaQRK+o6m3CGLz1P7TgT145+XUU81U3C2LpiyB2lyJkAGhXnrPpZA9Jbcj6Ehe+35NszjVDjoEqEPmDwNHRidwsL38d3rQP6DOfPD8lMD2O7fQZPzTjshcqiQp/VBGi40fgV6NDFH19yy3yiR1maZqCfJd3XvPb/9ewH7qTc/1/wd8imJu5cR6MMSEo47xHkA2guLdfE+ULc6J7tuF8adxJLWGPH0rPC8PQlcPQR7G0NmjcCVWkAW95pe9tx1BRYir1xqwFzunjtpp3QHeGTbREkqgCuPRIe7XYz1OD55W0PvK0Rr1T/NMzwzsvtJ6CnGP1FA5gQhuMKilSkB1I+2aiJpivbi2gC7oHHcTtgtnDlfwutVvIREs8IouiMT/IyrrIt+3j7EpwbPO2EE1q0uQapBSlxH9J8CrsjfMVBLsIiwVpC0zPjMEs4i2Wc1t38XnWsCcM1MuM0MA2kRakjPUYW18VzYzraAfvq9eJlQYxyxyLiE3pxTRuvkxj+j3TBhzjk6yLXHmkv0y4iplcC4ARhFWLcMpGaKsQBz7IoIAyDbz5Cd5/JjVVPVCTFIy2IdUKIL9r70mr0WExRS63CgwBTSL1KX0qT3PymO3+ofE1SwFqezbvfY/DSU1x70vnqYnsyi8JHeT7TTckxisayIPdSkZ4Rl08QQt10/0mNUE+JU4K4fP7GAUxH3r694JIr/QPKcDnaN
 nSirRS6o
 /jqMB7KMr8C+GZf1+Na33z5PMpXJ3hpsYfFqNdzD9fEFn4cG5jHJjLlgQ3l1GSSdwcqNjcuUyU/lS9h2spPz9ixPNwYbxJd8V2DG5SxxEPg72Dszodj7/04GEOwow5cca5P4k8e0VTJSHD6UajsIg722q9XEuB4len3QvTwUtHsxbCQMxV/US8qIfUqhdCe6UMwROjemVNseSTkzsdvQq1mqh9cUKgtBmp7G1TP8cTMqnGnuqPitHgv8/x9KWwgnWiYq03xXC7viSDUOP2fH33S9wT0rXY79aXd4uMfisYLBP7RrSswFx2Q2nW40i4dEAGjSufVXQjFaq5ao=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When booted with 'kho_ro=<pa>', skip standard KHO bootmem and FDT
ingestion in kho_populate() before early_param parsing runs, disable
standard KHO in kho_memory_init() once early parameters are parsed, and
use kho_ro_get_fdt() in kho_retrieve_subtree().

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c        | 8 ++++++++
 kernel/liveupdate/kexec_handover_common.c | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 67efbdd39439..cc56caeecba7 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1819,6 +1819,11 @@ void __init kho_memory_init_early(void)
 
 void __init kho_memory_init(void)
 {
+	if (kho_is_ro()) {
+		kho_enable = false;
+		return;
+	}
+
 	if (is_kdump_kernel()) {
 		kho_enable = false;
 		pr_info("disabled in the kdump kernel\n");
@@ -1841,6 +1846,9 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	bool populated = false;
 	int err;
 
+	if (kho_ro_cmdline_enabled())
+		return;
+
 	/* Validate the input FDT */
 	fdt = early_memremap(fdt_phys, fdt_len);
 	if (!fdt) {
diff --git a/kernel/liveupdate/kexec_handover_common.c b/kernel/liveupdate/kexec_handover_common.c
index dc25cb4c08af..a9bc8d45d3ba 100644
--- a/kernel/liveupdate/kexec_handover_common.c
+++ b/kernel/liveupdate/kexec_handover_common.c
@@ -263,7 +263,7 @@ phys_addr_t __init kho_get_mem_map_phys(const void *fdt)
  */
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys, size_t *size)
 {
-	const void *fdt = kho_get_fdt();
+	const void *fdt = kho_is_ro() ? kho_ro_get_fdt() : kho_get_fdt();
 	const u64 *val;
 	int offset, len;
 
-- 
2.56.0.307.g5fe7bd680c-goog


