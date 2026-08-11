Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC3C1C5CFC1
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 11:22:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A330C6B009E; Tue, 11 Aug 2026 07:22:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0A186B009F; Tue, 11 Aug 2026 07:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F9286B00A0; Tue, 11 Aug 2026 07:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BD006B009E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:22:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3A75A03FF
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:22:53 +0000 (UTC)
X-FDA: 85088751426.22.E43F1B1
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id 06B6C16000D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:22:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bhjbuR9I;
	spf=pass (imf08.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786447372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1AOkCrY9bi28aQzDGxTuGUu2U3BAeGsVy+sCSxaGiak=;
	b=s3ttfhhsU6AW6PwGKZubtxIxfD10TOgABEqOdVZ3QK9+UZV9A+IK3O31INKBZBFzLHvJhb
	s5fK8hjq0tNvbu1Hqc2C+uLSOc1M0q4Mvkwd/l6ZJL8Wz1Zh2vlQstSgQpzyOSh8+34G+t
	SbSx0q6Kdlj+Ezvn15hL9yTFuRPjGVo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786447372;
	b=NDCZddFrVzYuTnA8lkKc7PrR+e71JcbGtIfecDsoKfnufsgbw+OdI9rx0J9zhItQKldNOa
	EEiTkZ5+ap0Tv2FhCYDANFG97zKXkhoZTjrRl/exrINQkNV/IZazcCHUwQ54kYERxt12HN
	D4jwUHEhG1gO4mR70qo9OhemXKiY4AQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bhjbuR9I;
	spf=pass (imf08.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4954df200ddso20125415e9.0
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786447371; x=1787052171; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1AOkCrY9bi28aQzDGxTuGUu2U3BAeGsVy+sCSxaGiak=;
        b=bhjbuR9IXGmOsJR0ez1NpkxQJV0DH/1nXVPKnJ1GQJGKhYd+O/iFsYxm9fjnTiAsQz
         QVfiMfA0/P8U7cyly6fcSJOrD9Ex48G4PLOdr8C971iG7E21iSgLyGiabIH3CzdW93Bb
         +MGgPCTPRbvpevOFfZqVVCt1H9kOV9hJANT+2PlJp7wDOkGSdzccjnuikX45nk2e4Jmj
         OUcFSW8v5pH4NjvtiCEuvA3hSr+bmfqTSwE8dPd6nNWjKkmm4HT8UntKuQJDt8eWW4cn
         Z5y41OJjrHtUFxfN0n6ANoam11uxNNpjfyB/Rzw7vrqE6B9FTQRki/ikU2xl4WOG89Eg
         m8Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786447371; x=1787052171;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1AOkCrY9bi28aQzDGxTuGUu2U3BAeGsVy+sCSxaGiak=;
        b=T+1v8znDo9Fjo+nopnHPcbG1tC1PrConNmuTfbRkMRz4k8k3xzVyYxKaYDw45+43h0
         WJKYxTRw0+Rg+H8miDXy0NZBdD98/llSZgLiNQvUgVGx2pVbzKItPozJhXvxLk77TmWK
         uuXTBZbItlkikF1dgeRhZQEDZZ11uDMW6ipKgA0F/52wJwI0IP9annX+NBiKJCHQRW0O
         8NsqIzRy49dm2XCTamAzBwW0gSqnZaDZO9dQ2Z9/Qdg/apI3M0oIz4QxG/0lTVEc0loY
         iKMueL3OU6UuyeiU0qeu7w5ncEDtmPE9j9nVD2n8EfCnybQYQfUX135W8cwyl5OqrHQS
         Fq1Q==
X-Forwarded-Encrypted: i=1; AHgh+RocByupHtdI9B/aFfGviiuYRXe/CYGP+Mbll+MDfuBCStVh2/rL91EpaLLvUG5nG/mC0312Cx2PgQ==@kvack.org
X-Gm-Message-State: AOJu0Yw1RhIwxJqJ2TjKcPFRSyPUWeQVmAPC0QDBAkCEuUAZHelS97XC
	fZPKoxQ62pzNbkaufxQfX0kb3lWaPKxb3ruD28inK5vwwtiSxBwyk+df
X-Gm-Gg: AR+sD11cqAGLVi0GC6jpzkB/7sSq69BBDiAXhGdUs6L/b8cJbHO2ywLSRd1EDGiWG44
	e/FrQEjk8zYM/nAjFV7ou3sMZw40evMxAITv+SfJk7b0CKCoF0vCEmVySTtLCSQpJccBMVx1vqq
	XAfeglwgA4HZduK+vooBd5FT8chEDdZyMGoKL/2qrLcDvS6+cjjst8PGcegkEPFPYDyEARFbHDC
	lMzBsfyGCvsQzBDB7zeSFQ3rl/IHdrfeHliPXkykVcL8z/ssHl+lqF8tvr/wSILk37WUmGaTQSh
	xWtgzPZRWfRtUY4qGvFIM/CetWIImYL738Kym+6JFns9smhCYbxTvGOS0TBUFFahOiiH2ptU8J/
	cvBAwQmuqGarPAHV3z1nvXNyMLEmypqtqivmnkwPHT7ngy6YWK3RcW5vmdRygizfLca5bL6NEvE
	zXaSUZ6v9Y2m98oKGW0q7GBPKaBNReE5kK5VZPsToGym1l/MaMYBJVR1vq0qK319T+rDK+ebk+G
	U5x
X-Received: by 2002:a05:600c:1c07:b0:499:484a:81d0 with SMTP id 5b1f17b1804b1-4997845f6c7mr32679415e9.9.1786447370443;
        Tue, 11 Aug 2026 04:22:50 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5e:1100:7303:647d:7cc4:8552])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997889c2bcsm47547665e9.3.2026.08.11.04.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 04:22:49 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	kpsingh@kernel.org,
	matt@bobrowski.net,
	song@kernel.org,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next 4/5] selftests/bpf: Test trusted-or-null linux_binprm->mm
Date: Tue, 11 Aug 2026 14:21:53 +0300
Message-ID: <20260811112154.94053-5-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811112154.94053-1-tasos.papagiannnis@gmail.com>
References: <20260811112154.94053-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 06B6C16000D
X-Stat-Signature: oxrbqgsj9b8fjchyy8xiocaas4anq9d5
X-Rspam-User: 
X-HE-Tag: 1786447371-509462
X-HE-Meta: U2FsdGVkX1+Nibfuzd/Fgko6HsTMtYI2aJxTwssUs7wU5ls38HAAsHIw4Sz0HNnyqt9r5lbM49HBKAhG0ko0BqcMEWUIA2gQ7Y8fDK5fxceHw3K6O3rSJMIvjUME2P/5ZZ9iA4xHn29bNkfbCqSD2EtiyPb8J0xsuS5UNnKfPgUKmL2fzY5L4KUOuvqbcdxmw6Hd5qpWzWPTZLE2ospEO2eEuVTtSe1uT6W+W1OhJPOQXCo+ALOLQ975M0IKdEcSZkhCNJy9HProIJCiMmosEx0e5EGkUpItcJhiMm2L2+Rqu+E8sj37q7+UGr6RidLXI6hCZ7NGgPHUL0zjpHCxDZGH6GF23UgslimtJ5sTm9QIlzPUQRFRWP/pHBBmJhceEsqZNchT2fWOgRbDr4zfgWAWs/nzqi2rPR49Nfn4OnwPAEODIC7fPLH1cI4Cl+XsCStMTALKPIa7hoE5RpTFVYBeTXv9qxKDleSrRoKqRhWwI+Ty1fNbxtLw9EoSIdGN1RqrX9KwYt30vgf2ieeTF/iLJ8F50nePcIiHGasWxIoDlIsJ3sj4CGlo2PPm1q/TMC0mcQH+iSU9DSWUxIA66vZltq8mNjb6+pzvdnCYB4Uk+P48lPAEF0C0gCumIxI2D6jDvUzB8n3WygZdwQUA+Qw/QEjO9KIJgtcvx2V94RC40WsjFJiFi7e5DnrKu+Le19XbSwZR/+/yZGSQEeo0B7xXy6XL9kqwlOlLI+nNZpTBj1YqQnwhX1YYqnMMDlb5q/z6DCWY9J8QqRm3JiYf3TRuJHnDpr/WIC3CeLu36zRt45n/5K7ncI2PFuImYyiaqZSyRIN7DVrYKtL4dBh2FDbPfouDQKGuDNE6Xu3FQJ9mvjreNm/sJnP2zs19FSkQauMbs2m2CvL0OIS4YoeD9UaCWbOFzwS9BdIyWVJ1yL9IAczh+y34UyNQJ8pMi7gKq2Z+J173WH7/JQ+cTVl
 P5Kx8r/P
 7+RI2lq2hPmA8Snw21j6DUZRgFgdVSkvnMJT68WyJVhq9avzESAXq+sv1gXtUuNX6mqlQtmr7MvNlDWrw9TVeQdguTuPwBHisF5M1ht2xRiOaisQ/nF+W8gMLZ9BujJie2cHqbRisJFArrSbrodKNyvr7Cq5IbTmqGUbXO5XQq80WgjyOpjfspsnkuZS5syAdnQKTmLBbXAuBCnsyAt/CxKTHIv1nyvm+DZOzUdMPZm9MBQR8eZsleZwVo/X0HWkgr8IrhXU1eApzAx2sm4xQDb/L5XGiIZ3fO7okabnHt3QMmUpwNFdbD+//Hzz74IR7RRtn31bKwH1ka2Z/Q/YTFYxDG3x8miyKnjJXmxBAux8DVNFIWVo1oedv6Ju7+Uuvu2I1PpfQOfltqdsaGRQEmJ2pkV7SyBRzOqDkIDJPeTiL3MkT+hi93iD7+E9TQFtcRP4vFX7RpcpV2ZHY86nSpQ9cBo5MmSQJMdgUQjPzyGBxWmWYrMtzU+153skNnQtRWfVS7UJ/RBsyUZQVzjFtDrueGCVrl3QeP4tL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add verifier coverage for the linux_binprm->mm trusted-or-null
annotation. Verify that bpf_copy_from_user_mm() accepts the pointer
after a NULL check and rejects it without one.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
---
 .../selftests/bpf/progs/verifier_lsm.c        | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/verifier_lsm.c b/tools/testing/selftests/bpf/progs/verifier_lsm.c
index c724bf389f5c..4fc835432af0 100644
--- a/tools/testing/selftests/bpf/progs/verifier_lsm.c
+++ b/tools/testing/selftests/bpf/progs/verifier_lsm.c
@@ -5,6 +5,10 @@
 #include <bpf/bpf_tracing.h>
 #include "bpf_misc.h"
 
+extern int bpf_copy_from_user_mm(void *dst, u32 dst__sz,
+				const void *unsafe_ptr__ign,
+				struct mm_struct *mm, u64 flags) __ksym;
+
 SEC("lsm/file_permission")
 __description("lsm bpf prog with -4095~0 retval. test 1")
 __success
@@ -212,4 +216,31 @@ __naked int retval_load_resets_bounds(void *ctx)
 	::: __clobber_all);
 }
 
+SEC("lsm.s/bprm_check_security")
+__description("null checking trusted-or-null linux_binprm mm")
+__success
+int BPF_PROG(copy_from_user_mm_with_null_check, struct linux_binprm *bprm, int ret)
+{
+	struct mm_struct *mm;
+	char dst[8];
+
+	mm = bprm->mm;
+	if (!mm)
+		return 0;
+
+	bpf_copy_from_user_mm(dst, sizeof(dst), (void *)bprm->p, mm, 0);
+	return 0;
+}
+
+SEC("lsm.s/bprm_check_security")
+__description("not null checking trusted-or-null linux_binprm mm")
+__failure __msg("Possibly NULL pointer passed to trusted R4")
+int BPF_PROG(copy_from_user_mm_without_null_check, struct linux_binprm *bprm, int ret)
+{
+	char dst[8];
+
+	bpf_copy_from_user_mm(dst, sizeof(dst), (void *)bprm->p, bprm->mm, 0);
+	return 0;
+}
+
 char _license[] SEC("license") = "GPL";
-- 
2.55.0


