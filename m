Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81283C87FCB
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF1466B00A8; Wed,  6 Aug 2025 21:45:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7BED6B00A9; Wed,  6 Aug 2025 21:45:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91C9B6B00AA; Wed,  6 Aug 2025 21:45:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 809A36B00A8
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:45:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D7261DD575
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:12 +0000 (UTC)
X-FDA: 83748268464.10.B1F9F6D
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6D993140008
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bLiSHa3n;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531110; a=rsa-sha256;
	cv=none;
	b=5owYMhzOFOygRFgfnHgpX9pFTDCFvz1A/+Lgk0vUnIzNZc179ZEA/d7D14tq41pp6zNVgT
	F/kbhLzujcf6QvtHjT+h4I2rmVu2XZNAsMYv96V6SRKXeAYBdi/ycoPjItzsaFq8hUClS6
	L1hOvZxukHetmIMQhnZwL1EFW3T+zVo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bLiSHa3n;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=535Ba2NCPms4/9++qm2Yq8lWENY5QwuViLFiaBWBL/o=;
	b=6x+jHJSkMqjSEA4n2zHes4oHyiJ7NRL9AyrfDh+BEpGUMD8AaqKpcxki8GbOIaPjVd3rdR
	EBSXu7vKeFbmN3rQQjoi6fMrAQCSPH2xZMZXQB5impOHKpPhYjTxzc5M4QTcCDWbB27oW7
	MCZAdiPy+8G9627oZtP/7DmYnCYR3zQ=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-70884da4b55so6135696d6.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531109; x=1755135909; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=535Ba2NCPms4/9++qm2Yq8lWENY5QwuViLFiaBWBL/o=;
        b=bLiSHa3nfKrchx9AQbWjUJruF+h/6VmXO1yJ/W4OAdc/EqfiNHkSRZYbQkwezIM8kk
         TPugYvFt6kTrFmTc7WKk+MXRhYWwfJofVEx0Yivbt+UoRaiSW+TY/bLPE4o/vxJBQsao
         5DuHR7KhTMlQOjlzaF0O0wHiRaVc1zQvr2QwVyhFYvYx+v3+aYldujMSU0LJ/mCkk0pR
         Zw2cD1GkvvvCOOD4NcBAJmK38B+FuFWqdHxD5muwzettsuemH3bDjx4+jpIfGe7mJBAi
         pczjHcQCfvZWHSxqKFZJeE5ITvNnhmmAQzRWhXeoXrOl4rXaAbH1XXDyEcYdNb3JagUx
         Vxmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531109; x=1755135909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=535Ba2NCPms4/9++qm2Yq8lWENY5QwuViLFiaBWBL/o=;
        b=bfTRrL2PCzjL/o0IudrMMIKOh9AuyPyFepef/+hfp0qfQuNuvbfcKTxVR/7ZY7JyUL
         21eHjBfrVx2Z7bwdSJgHlZceJ5YNYsHD0ZCL/adqMR8fvcbY9aDbabWT16WeqJDmoDQN
         T/KeDUyAU/4GTzRLPO2om+XTB+psqJ0Q2pDWvPz1Zyk4HTlbTZoxo8C1tk8hYQpSJvQg
         EbJ5L/LeuUi5+5hiVYW04VcPz7se4R38fY3l0IHrkDLa+s4V+uKkm21uohIlrdMLaAZW
         z5gaN/xyv8M1jLqD+Deo2elVjgmyYf8Oj7hn3Bv39Z0Lcs/1tuvOCZiLYPImRU9Xpj0B
         kjfg==
X-Forwarded-Encrypted: i=1; AJvYcCUrX0jHBb8N2gshZFNzUyueyThR0xQLzm6VokjBvQttXFTO8TnyIrr72KuiE2ZziHT4+sviR7125g==@kvack.org
X-Gm-Message-State: AOJu0Yy1Ld3jy19bKPishKk2y0so244JQxNJY3zr4YfTop8T4XuWW3B5
	H+6tfTG9wmh80BuVbxbnNs/EluIUMuw0FcUYJCKGa84xt7w7aox5VGkT5n6BO4+n8iY=
X-Gm-Gg: ASbGncspyHzToKwCXG3arGYSBGoaIEgv7XTN3ql/zHcjK/GYAYM8W5I7TQPQFhFw4Ji
	saDEly5TvGEgu5/vt3Rhog9U8y3AKVQF0PeSJlQ8lgCm7Lqhr4TGsGKJPAbzm8RKr6Ko0UmgY8z
	MUBwrUKvHJzDqIZCtQD033yPldvnenRbXFGITC3z72sKSpB0RLw64hcjip2svY/Dd5b3CZmifpn
	nKmWPEyYVfgxiGCBBGtYTnIpqcnngCorNQDCMW4gisPYciiQzyK6CzU5UjKIWq29nJBIc8fTCCy
	+pcNvXSO5CRmoZk/lQcLNP9Zel2z4Q926S0x0cHemzGTzzX6g4fYBeVz/IhnilkMFbhvC/l9HJ7
	zMbWYXjQqtQ/lYGiCj/vQE9T/Ix317WHOdSjNy/9oLUcgkpHAbzUOu9XHTnf1sLpA1M7kNlsFQS
	PtvfThO2iwCmHK
X-Google-Smtp-Source: AGHT+IEnMynjbrA/1kdM8QRErdkzAIa+G9lVVTQo0MaHEEKIMvABCbjhv49oP3YEo2mCQBJF30aYNA==
X-Received: by 2002:a05:6214:246f:b0:707:7cee:4fd with SMTP id 6a1803df08f44-7097ae10932mr70070696d6.3.1754531109452;
        Wed, 06 Aug 2025 18:45:09 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:45:08 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	zhangguopeng@kylinos.cn,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com
Subject: [PATCH v3 15/30] liveupdate: luo_files: implement file systems callbacks
Date: Thu,  7 Aug 2025 01:44:21 +0000
Message-ID: <20250807014442.3829950-16-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6D993140008
X-Stat-Signature: q3eman4y5bcx9ifrurgq6msa6w79yakc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754531110-827026
X-HE-Meta: U2FsdGVkX18/vyzZBfRvncLLylUo3TSNvsl8l7dnNK/V7Z0JTUV5YLphXmhksMGwdnmMpcoJ8nOhf9V1k0ffsRRvienevigiF8/1ONjTgaiHNtzHhkbBrVUVtdSp6nZW8ROmp/s3AgGStsPzoDV8XiO81fLMRbK8lc+u72TrEoD5HDduP20nyyTsv+JyBib/OULLdUfB/QdQW3KNDJryYnZ1hMEhFfz+pkN9o19yAHW7h4LA82jHlUDjyImOxuj7E8hzNpXXrO59kjIo5iQOowPMHDoCgDka1Zaem8h2pmkA3njyc2ZvIGfrKLb1Wff1yQSNO0I31Ct6Wemdi+TcWupXWE1tC8JJbuCykyEW+PQx4hoooADAe0Zb5vFasIBFEF+vgAR13JlAXse5FDeheJ+n6EYNLCZdF3wdoPmwiIoakGg9/L2ADE9tsMUXrllnWLEJUXToaaEMVt0b086Ih0geUcJdgyqZiPTJLanazfQKPBi+2WzSH9APoFgVXBDveXD1wJZHgb3PoFJUpSZVhF35t0g1AgJkgluAOQDM56BpKcJ+MixcCPey7AskWMaFtHi/20Dpi11hrtYxg0vA8qhaTdPef6nmKIxZKhoVcLSXlMaHx/Q5XOQDnOrOBcm6byyJP4dC8Df4LHO5byqXz4chDnPa2xLQeX4SGa24smFOjfsYm7uGCpebmLxMxt8ScGK6r2PP6RHacqjptyvX8YJkbf6T61mH/y9bLgpHR1mWTPUNaYAsq3ncVQbesEmqW1WnJn7ZxULd1jUTKszTHF7ixxpG9O9Wlyz51lvE4JXFnSmJyXQWAxdbL2F+Oy7nJcsYZ8su1WVR12c/OI2Eb4++13X+l+0dSPmRyc2ezP8zqbU4p/NwWkI2TV0ij5BUtaEbU/1PaTxeEV0Rx6Tv48r767ocXmjaKmvGHkEFSN/HJw17lqhyoGK2aL73gYTL0K+cxD31ltVhl6+KBKG
 xeuCrFgs
 4lOHlSwoRiGgmgJp/eAf/KP5lz5yan0BAiqiltzGFTT3ugK4a6slxywBI/aDlQNc76FmKQJ+y1N74Jw22Eei+SeYXXurP8ehzQA+ZifOlPWk8uziuGJ5EQL9M/NzqbzMQT3m4qZ5vPs57K+fBpyln+n/5mRGj6OcYvqirEor28n6xAnUB1orKvr2oZ7wnpwfSoFeYfHdK+P49Yf34d7hmZ+JUeLEg7JVYrSIp/GMGEaOA1mdLDgV5uR6FVOP/Khlw7OltMMJeVNN0DS7UBq+S7yiQGzPtT6d7DW/DJCgK3DPgEjeYfHKI1MsUN7OZLWrkYHMOdGrqBg83A0Qo9Se7VY2MuhAtKG57oiUjMpLe7LUbKyRPOYSt/R96diiML7B4fSrFaCMNSG1fGHumd6gnwaFm9XGOoGTvFnGuHCQPgSPDDgtwsvVIog5YNmbsIXPDraOi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implements the core logic within luo_files.c to invoke the prepare,
reboot, finish, and cancel callbacks for preserved file instances,
replacing the previous stub implementations. It also handles
the persistence and retrieval of the u64 data payload associated with
each file via the LUO FDT.

This completes the core mechanism enabling registered files handlers to actively
manage file state across the live update transition using the LUO framework.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_files.c | 191 +++++++++++++++++++++++++++++++++-
 1 file changed, 188 insertions(+), 3 deletions(-)

diff --git a/kernel/liveupdate/luo_files.c b/kernel/liveupdate/luo_files.c
index 4b7568d0f0f0..33577c9e9a64 100644
--- a/kernel/liveupdate/luo_files.c
+++ b/kernel/liveupdate/luo_files.c
@@ -326,32 +326,190 @@ static int luo_files_fdt_setup(void)
 	return ret;
 }
 
+static int luo_files_prepare_one(struct luo_file *h)
+{
+	int ret = 0;
+
+	guard(mutex)(&h->mutex);
+	if (h->state == LIVEUPDATE_STATE_NORMAL) {
+		if (h->fh->ops->prepare) {
+			ret = h->fh->ops->prepare(h->fh, h->file,
+						  &h->private_data);
+		}
+		if (!ret)
+			h->state = LIVEUPDATE_STATE_PREPARED;
+	} else {
+		WARN_ON_ONCE(h->state != LIVEUPDATE_STATE_PREPARED &&
+			     h->state != LIVEUPDATE_STATE_FROZEN);
+	}
+
+	return ret;
+}
+
+static int luo_files_freeze_one(struct luo_file *h)
+{
+	int ret = 0;
+
+	guard(mutex)(&h->mutex);
+	if (h->state == LIVEUPDATE_STATE_PREPARED) {
+		if (h->fh->ops->freeze) {
+			ret = h->fh->ops->freeze(h->fh, h->file,
+						 &h->private_data);
+		}
+		if (!ret)
+			h->state = LIVEUPDATE_STATE_FROZEN;
+	} else {
+		WARN_ON_ONCE(h->state != LIVEUPDATE_STATE_FROZEN);
+	}
+
+	return ret;
+}
+
+static void luo_files_finish_one(struct luo_file *h)
+{
+	guard(mutex)(&h->mutex);
+	if (h->state == LIVEUPDATE_STATE_UPDATED) {
+		if (h->fh->ops->finish) {
+			h->fh->ops->finish(h->fh, h->file, h->private_data,
+					   h->reclaimed);
+		}
+		h->state = LIVEUPDATE_STATE_NORMAL;
+	} else {
+		WARN_ON_ONCE(h->state != LIVEUPDATE_STATE_NORMAL);
+	}
+}
+
+static void luo_files_cancel_one(struct luo_file *h)
+{
+	int ret;
+
+	guard(mutex)(&h->mutex);
+	if (h->state == LIVEUPDATE_STATE_NORMAL)
+		return;
+
+	ret = WARN_ON_ONCE(h->state != LIVEUPDATE_STATE_PREPARED &&
+			   h->state != LIVEUPDATE_STATE_FROZEN);
+	if (ret)
+		return;
+
+	if (h->fh->ops->cancel)
+		h->fh->ops->cancel(h->fh, h->file, h->private_data);
+	h->private_data = 0;
+	h->state = LIVEUPDATE_STATE_NORMAL;
+}
+
+static void __luo_files_cancel(struct luo_file *boundary_file)
+{
+	unsigned long token;
+	struct luo_file *h;
+
+	xa_for_each(&luo_files_xa_out, token, h) {
+		if (h == boundary_file)
+			break;
+
+		luo_files_cancel_one(h);
+	}
+	luo_files_fdt_cleanup();
+}
+
+static int luo_files_commit_data_to_fdt(void)
+{
+	int node_offset, ret;
+	unsigned long token;
+	char token_str[19];
+	struct luo_file *h;
+
+	guard(rwsem_read)(&luo_file_fdt_rwsem);
+	xa_for_each(&luo_files_xa_out, token, h) {
+		snprintf(token_str, sizeof(token_str), "%#0llx", (u64)token);
+		node_offset = fdt_subnode_offset(luo_file_fdt_out,
+						 0,
+						 token_str);
+		ret = fdt_setprop(luo_file_fdt_out, node_offset, "data",
+				  &h->private_data, sizeof(h->private_data));
+		if (ret < 0) {
+			pr_err("Failed to set data property for token %s: %s\n",
+			       token_str, fdt_strerror(ret));
+			return -ENOSPC;
+		}
+	}
+
+	return 0;
+}
+
 static int luo_files_prepare(struct liveupdate_subsystem *h, u64 *data)
 {
+	unsigned long token;
+	struct luo_file *luo_file;
 	int ret;
 
 	ret = luo_files_fdt_setup();
 	if (ret)
 		return ret;
 
-	scoped_guard(rwsem_read, &luo_file_fdt_rwsem)
-		*data = __pa(luo_file_fdt_out);
+	xa_for_each(&luo_files_xa_out, token, luo_file) {
+		ret = luo_files_prepare_one(luo_file);
+		if (ret < 0) {
+			pr_err("Prepare failed for file token %#0llx handler '%s' [%d]\n",
+			       (u64)token, luo_file->fh->compatible, ret);
+			__luo_files_cancel(luo_file);
+
+			return ret;
+		}
+	}
+
+	ret = luo_files_commit_data_to_fdt();
+	if (ret) {
+		__luo_files_cancel(NULL);
+	} else {
+		scoped_guard(rwsem_read, &luo_file_fdt_rwsem)
+			*data = __pa(luo_file_fdt_out);
+	}
 
 	return ret;
 }
 
 static int luo_files_freeze(struct liveupdate_subsystem *h, u64 *data)
 {
-	return 0;
+	unsigned long token;
+	struct luo_file *luo_file;
+	int ret;
+
+	xa_for_each(&luo_files_xa_out, token, luo_file) {
+		ret = luo_files_freeze_one(luo_file);
+		if (ret < 0) {
+			pr_err("Freeze callback failed for file token %#0llx handler '%s' [%d]\n",
+			       (u64)token, luo_file->fh->compatible, ret);
+			__luo_files_cancel(luo_file);
+
+			return ret;
+		}
+	}
+
+	ret = luo_files_commit_data_to_fdt();
+	if (ret)
+		__luo_files_cancel(NULL);
+
+	return ret;
 }
 
 static void luo_files_finish(struct liveupdate_subsystem *h, u64 data)
 {
+	unsigned long token;
+	struct luo_file *luo_file;
+
 	luo_files_recreate_luo_files_xa_in();
+	xa_for_each(&luo_files_xa_in, token, luo_file) {
+		luo_files_finish_one(luo_file);
+		mutex_destroy(&luo_file->mutex);
+		kfree(luo_file);
+	}
+	xa_destroy(&luo_files_xa_in);
 }
 
 static void luo_files_cancel(struct liveupdate_subsystem *h, u64 data)
 {
+	__luo_files_cancel(NULL);
 }
 
 static void luo_files_boot(struct liveupdate_subsystem *h, u64 fdt_pa)
@@ -484,6 +642,27 @@ int luo_register_file(u64 token, int fd)
 	return ret;
 }
 
+static void luo_files_fdt_remove_node(u64 token)
+{
+	char token_str[19];
+	int offset, ret;
+
+	guard(rwsem_write)(&luo_file_fdt_rwsem);
+	if (!luo_file_fdt_out)
+		return;
+
+	snprintf(token_str, sizeof(token_str), "%#0llx", token);
+	offset = fdt_subnode_offset(luo_file_fdt_out, 0, token_str);
+	if (offset < 0)
+		return;
+
+	ret = fdt_del_node(luo_file_fdt_out, offset);
+	if (ret < 0) {
+		pr_warn("LUO Files: Failed to delete FDT node for token %s: %s\n",
+			token_str, fdt_strerror(ret));
+	}
+}
+
 static int __luo_unregister_file(u64 token)
 {
 	struct luo_file *luo_file;
@@ -492,6 +671,12 @@ static int __luo_unregister_file(u64 token)
 	if (!luo_file)
 		return -ENOENT;
 
+	if (luo_file->state == LIVEUPDATE_STATE_FROZEN ||
+	    luo_file->state == LIVEUPDATE_STATE_PREPARED) {
+		luo_files_cancel_one(luo_file);
+		luo_files_fdt_remove_node(token);
+	}
+
 	fput(luo_file->file);
 	mutex_destroy(&luo_file->mutex);
 	kfree(luo_file);
-- 
2.50.1.565.gc32cd1483b-goog


