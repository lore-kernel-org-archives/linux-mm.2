Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBBD2C79F87
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 14:54:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B1576B00A1; Fri,  4 Sep 2026 10:54:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 161C36B00A2; Fri,  4 Sep 2026 10:54:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1D436B00A3; Fri,  4 Sep 2026 10:54:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BA1D86B00A1
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:54:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1652BC0143
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:54:38 +0000 (UTC)
X-FDA: 85176376278.10.B7E278A
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2D71218000C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:54:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lkWTZJF+;
	spf=pass (imf24.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788533677;
	b=Pe6jg2EOdAoO6UWn2vm9/9J3e91JydBn1Ha2y6DXrCKvGQngKetBeRxVEzCMbK5Hlu7p3y
	HhCZdUFFjWeVR2iThrtnroPWc3aysfHdv6tIqcUUgiRoF7zGaaf8C3B4FnBb1BUOeOLAJu
	J5PZCgdd37Y2Ci1jaNZNmVJpCF9CzEw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lkWTZJF+;
	spf=pass (imf24.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788533677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/JbBdz368b9964VnW5n9v0EGlaen6tXu6qawPHYWGBI=;
	b=PuWLhJz+v8eKVqIYF0Nzx4SZc7gEbgvKxhfiyaJ0jQxSTkXfCxNvWsCMyP/LGPQq067+02
	zr8sQZSh1d3de1o1xg1fmXrGH3WjJm6ClV+wIvG8Pn/hLd9Tegh/NjxNl20NG8sw9QwnSv
	nnQ9tJMmRXDGNpOVehfLUYhZDdnAhv8=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so12600465e9.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 07:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788533676; x=1789138476; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/JbBdz368b9964VnW5n9v0EGlaen6tXu6qawPHYWGBI=;
        b=lkWTZJF+Yrw3sX+ftFObzGxltNmgYxtHMS1yFUmS56mGOaUGw0qqYsXXpadEqSO8UO
         R4MldScHCPJsxMTHY673+Y+Pkpmv2YCSXWEEywqHC6xdLu/Rhi10mzhyL9LmLjT4cyx9
         sRvk/ewdeBsmV60wIk3l+gsomACfs7Py1m0ymKG97xq/9WeE/JZaxsKXVldYSp8YLXef
         HslhMe4kH9bFimuHNoiDrfuHKhjVzczKaK5Ptwna203xnZVQfwnTT58W/ravKIgcKDNx
         F37Lvn2sVPru5IaPIRYthDjnXA03nbBRKdDDb4irCCN2Gsl92eibYktIeHVMxw483knX
         CRrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788533676; x=1789138476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/JbBdz368b9964VnW5n9v0EGlaen6tXu6qawPHYWGBI=;
        b=rwpnoztdB2VD67H56B+1mrd5Rzu8IzsQ/GcG2mpmvl1UFTz4tiPCuiA0ZwFaYlp8QC
         LgTimbsCRiEHhGSy1S1f/vwi9G0iwy1Ta/WX/+fmMLHvszg9LfzhpxzfnTP9y5IAH5wr
         HtWV6FQPzWEWAzJhV2FdwfuJr8mep4VGnbyaCsv0QaKvwHYIdrhGobwEv4KNuDHZ543M
         flS4g2IFbinecNabIk/QmYniXA/chTA48T2c4Vg/1dsG7/moWHsH8IbcdsHOC50ZW4yL
         f00MYs93fJLdAR9k0R8PIicZ2GCIER5QiEH1aBxv999dNm9E6xMPI3923I4Go9Qdmq9/
         +SVQ==
X-Forwarded-Encrypted: i=1; AKwUvBxjRc+zuqmvKYnka9dzM7vuXWrfo1vqskbGPDHC0ksos4vlpsLJzYQWF2owGXMaZY6JcKUKLKHw6g==@kvack.org
X-Gm-Message-State: AFuF++nBA9o2ZOn5ElOYoPKOoEOl0w86EXQFQctWNMluDu+LwVVqGAQm
	eQUkRV06I8hoi6rN2MgLPWk6UT74I1M8Vd7Vxqrh/OH/aNZ999yd8jO1
X-Gm-Gg: AYBFou0Xxk97uTwEMbMdAWCgh36mAnP8QFSjKOFK25QRAtKI8PExaJR7rRledYZPQUc
	A6v795ZLUpIsDEioynLN2v6NwRSWAKKdO11AUfmNJdae6Lj7zuADUzzPPx1LKWw9x90nlpxsc2W
	Ng7+WrBDS4TRuVJIXUs/o0XPcFxqTUflGkek6knGXZf2qr5ddhnffyHRBCwJeSwHwpA+5KMikcA
	6FowBwfU2ALkLRpV7WBG3NkiQMZlAIs/enGaBVAfPaQVLt08DREyqPXpoaanokxXooU43f0PGpU
	WTCIFoB0X7KNgKZSo9uy5EDSeHCmnoVY/lT+Mv2PU0PwKzpsMQQlC079PbBLgPCPQo+jxqq3Inx
	pFya22zqg3e5ZWEQiXPUQogE/ZgrxZzKwp1ofZdJsAl01bze4KYAUpfOFU8fiFVxYD+2iNcz72m
	ZRrj7vRCzLxgKeS2N161a1G8/VZ+3126Jx8fB7pGUeba9vgmf4wslkwamjeT80qzdB6fAxZRNo5
	5ThOLBSDXlJ
X-Received: by 2002:a05:600c:4e90:b0:49c:f3dd:e166 with SMTP id 5b1f17b1804b1-49cf826ca60mr61264505e9.13.1788533675701;
        Fri, 04 Sep 2026 07:54:35 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485885cb03asm6802799f8f.37.2026.09.04.07.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 07:54:35 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
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
	utilityemal77@gmail.com,
	sun.jian.kdev@gmail.com,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v4 6/7] bpf: Mark linux_binprm->mm as trusted-or-null
Date: Fri,  4 Sep 2026 17:53:39 +0300
Message-ID: <20260904145340.40212-7-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904145340.40212-1-tasos.papagiannnis@gmail.com>
References: <20260904145340.40212-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: nshyhwsr6px1oscdz4nmmgcori4zznfd
X-Rspamd-Queue-Id: 2D71218000C
X-Rspamd-Server: rspam06
X-HE-Tag: 1788533676-621153
X-HE-Meta: U2FsdGVkX1/S86q0LJ0CEdRsDy7uilPzC9GxZ9fwYZqh17pmY9c9768m6Bz1xvSEpyeqb/F4SJpeuxyu+TQHO9mVjwFV5xXhPLXBQrXpYCcEe27OTP9GoV/MEGx3tQpA5c9GY0x54V4qHW6NOoU06623o1ARBIsJmQLLWBjKdJjJ+Ux3TChYc8zN4JFriu8nC1Glm2TS/YC+tD1D13Jy3cxBCTse/MihdLpi7/4Hdi2qQPbXa3sRP7oO3KNxc+zdsXIoDclUP53c0n71Tt/asCZTJpCtK/Tqu87cSKml5Yf8sbZMZ9z3m4g9jCFIuQPij2++aegwcLNElcrcL1/qFMfA9JnCDMH6ZxiMIBcr+h9GOjPjNE9+aAqCz+CAqOmRPzXPIqpeZ3/YcczHi/oFSydwE6vNtPFhmHSkygJrEvsB1XW9zEA1lxlSCORJ3pZlE6aVMZ3Lbo3NABarEBaHY1WxkV7Bu5QEtgGgeLY78rgNR7zpBY56tQ1W4fQHkglcXU2D85MRFbr4EnMv+SJEguzTxpKUgbjLRehd1cfH+7a+5C11hbpfEv0NefwxLf7PLcSYtB4hgOYSNbWcS8q6mvl2FdkgQVvuc8LMg3KB9cQY97uMANMr5DXLwnQOuTE6R/uB1HOVd0Iczn/8anoVb6R3e8Z0hQsfi6b3fOqDr+dZQ0xssnXEzh44Ott1Vcex4T2unRBvBu060eD2IofA7oW/K5D4fo9BJEuyejN3f7qWVh+tpI3rbmu0APIU1n8gwIC6Ts4VPID/QtX/B7Fc1wPwRhvwX84e4C1ECeqGhG3rHje9pSA69xPHSRncmB5Do9A5pyGdCekHVLea/dwBBIzRPiYsbZxtA5flpx7IUaKaNV2oga+zyOB3VBKQh/1ZKWOmNmzwgBQUmLaydPgC++dJQh66uJCWUUXlBSdOXN//uyvKhdsh2rR+arfZ2tXfAxLdhfhM3JsjUnxgW68
 8FcInkZK
 tXFkFjRlANrW67MgLTUQ44XWWjlI3ObXf4YUeXuktgFMBf6yJrjazzIh0yBUOow0cNcmSWGj2vUadTiRjTgQFAaNCBnCHRSvtTNac1o3xHwndsiDLA2MKr2yAkko5lb+BiwljRanYNYxXS2+MYAPqFpGfXJpU5m3OMoat4/cM85hRP81+xZB071rrGKCm7241AnErAb2AVSXgJaLq/2HLVTcaHkwl39KYzsGSHd/QndZIaaaKezypxXDvyx/CBhU5z6OvXoHxuWYjS2HCx3ovx+D2v0rriITkeAempl0Xnr5Wo4MbaTubJN8+EaB3ZIMP2gODpsvl7bCpXt5yT9WuLgPYSQQY12ic2flwWksb/vLElU6qBJIjr1U7SzRY9DtDcOVh4WDUf+peUUu2o+At3egkEbP75Ibuu7snQEnYngaL7c8v4xHgloUdeQcpgmpvt1pR2y7WXSigbYHFZLRjOE3limpQEjuUo+ZtPwqA7cc57cY1/YvTtpfeSg0TdDe9e4W2S7giEc/rvJypF/UQASJ74dMBzwzlT16zb1y+kXmhU9KIrP+dk/1VA1xZfcwr/oV2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mark linux_binprm->mm as a trusted-or-null nested pointer so BPF programs
can pass it to kfuncs after a NULL check.

The field is either NULL or points to a live mm_struct whenever BPF can
access a linux_binprm. On successful exec, exec_mmap() installs the new
address space before begin_new_exec() clears bprm->mm. The bprm_mm_init()
error path clears the field before mmdrop(), and free_bprm() clears it
before mmput(), as ensured by an earlier patch in this series.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Reviewed-by: Sun Jian <sun.jian.kdev@gmail.com>
---
 kernel/bpf/verifier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 386401fe051d..584c79326b9c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5958,6 +5958,10 @@ BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry) {
 	struct inode *d_inode;
 };
 
+BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct linux_binprm) {
+	struct mm_struct *mm;
+};
+
 BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket) {
 	struct sock *sk;
 };
@@ -6012,6 +6016,7 @@ static bool type_is_trusted_or_null(struct bpf_verifier_env *env,
 {
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry));
+	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct linux_binprm));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct));
 
 	return btf_nested_type_is_trusted(&env->log, reg, field_name, btf_id,
-- 
2.55.0


