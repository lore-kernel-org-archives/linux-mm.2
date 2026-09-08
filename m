Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ED29C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F13F06B00A2; Tue,  8 Sep 2026 09:53:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3EF6B00A3; Tue,  8 Sep 2026 09:53:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB38D6B00A4; Tue,  8 Sep 2026 09:53:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7D706B00A2
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:53:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A5C21C27E2
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:53:43 +0000 (UTC)
X-FDA: 85190737926.09.2FFC330
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7094E40009
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:53:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WhczMZL1;
	spf=pass (imf07.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788875621;
	b=rYusyNKwnECmGWYts8ZL9Y65j6ZusfxYFa4L+yvOCqtxxErEZJm1wccQzXYfNlRlVwkQU0
	kFF5Ap2/mjht8VYWbw5wra6YM7ChtnQ9TyLsxY4xL8uX77oc0AP8ZQQzfkju0KfJ3eZY37
	zVB8GS5CYqByaVA9wIJGJPpAiA9PYwU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WhczMZL1;
	spf=pass (imf07.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788875621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BcITG13Gvl8i0HA4g724jWVmnWns/ceZ5ECxTEaQlok=;
	b=vJ91NmsFGqmHwNaJuymNJ91iN5lInow4h2Fo09XxrfzKvwQ+JDOnaqpu7Zu/98n6SgR7Hf
	jgtO2VduzFDm7zsxGr1BlkRbP29wkVZgOwrdFZWZ/kjzX7lOd2ZE04LHV/oHdWgPvSW8op
	QVIpVSo34rB4HpLBHU3+VZURekFwIPM=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49d0726ccc2so20688545e9.2
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 06:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788875620; x=1789480420; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BcITG13Gvl8i0HA4g724jWVmnWns/ceZ5ECxTEaQlok=;
        b=WhczMZL1xyv+2vf+HRhX+GngVE83AYgMS0B8XmPCr9devRU8Fe3kTeGm2XtDUFiPBt
         vKlvCDhcEkneX5RF/N1/M4t/azmgymf2mhzNdjIbNJZsEa6HK0tMkr1cjknitwcS+RLG
         MdQwXMM8LWWzij19JHQT+cEJDfHEsLp1GEydyXOeLcXvojsG0sZ4h2unISINFsKAbg0r
         SBWZH7y3Q52dXnbPDhHlmTMkkuirytvesnpuuKwJi//R8RXsJbE0sN5UYR+HWHPQsio2
         s3ezs/CiCiVeFLcj963QXKAG5zqkjUHorcEchIkxFF9BbmylpRB0wCY8NX+ZxAgouRi2
         VvXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788875620; x=1789480420;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BcITG13Gvl8i0HA4g724jWVmnWns/ceZ5ECxTEaQlok=;
        b=n+7Ef7hpgmwkiigpJKERrGUv2uB7NwPvlT1RCZPUVGmODw4pewx8X6KsxWQmL6a4RY
         m45KACUXpze9fw05fp4vBin4PDToi4ZblViVCVWjsvU35zPox5uIxISdY8K36MKePDyv
         86RZt8UzwPpHc4Iv7glG2guFu+SOoaDJUhg/MhuX1YVVjMymcIyHwFpLeLgU15mbi35u
         uNdbLJs72VAAYyIs9kHY4xsyRM9Nxg1Cx+7srgVMiBxm8gsb63GmPHg/hC/So6OMEhFO
         SXzH8y1E/ow9MHtRbhVYlFeB+LcvqjM3wU5x8kOyI58tDCL5jKfKLJK5cNDJucrskCkH
         wvhA==
X-Forwarded-Encrypted: i=1; AKwUvBzP1peJnXXbmUgccaNNrGwiMNel65PUVFZGm6M/++Wc+65GrQg2CtfeKnOM5+DJ2DXFYpR1AGLalA==@kvack.org
X-Gm-Message-State: AFuF++nGelZensEq5aWbxmpXDReM38KmG1Aj2aRO/zL7cwGzRqSvFF3W
	vZ287D434Gg4yJKIonkh2mZKvZPrGKrSGSo83wZDJE0MYrQne+8oAyyt
X-Gm-Gg: AYBFou3Q+X3nVEqaCNnvua8mNix0vaM54+Ny6rNddlZBfTdfYd7nrxYyPrvrGeQJ+6K
	CYbYW8bpk93TivCXFIGHaLs0K+5GqMaVPvy0V11eTdeXQkjx0T2hTOpjGU5AoDiWCENU6mYjp6L
	eWMM1iFIfseB5Enp7B1U+AlHbA0OKv++OzC3CyQ2ul94HjQhKfIoSZMD3pBD3flakvRksyHccaK
	tUS8vflWViB9vz3ObAouUOlP0S6t/4V1iVbVKfaiiFX70GuZpowJF6YUkQtqy1V89flbk+SqTmv
	zDrW0RGljJ67QRYe+ce6emr02DEYAXrMaL9tQuVk/OTU7SfWetW3lZotDmkIneDxyJs7gBj0FGk
	WYUwhZPM/tEvcMiIufy314pRDFzexwa6ZZox3uHa3R3HkHspLOmWwLSLuOzIeoBleLMOxEtWss+
	SB8TcqDhm2MHhyGmGPZ7fkqVMPiitqZ/erovArjbD26rUPOCi2IJlS89xZqqDbCG7JVNkUhp2/C
	xWM2FLcghpy
X-Received: by 2002:a05:600c:4e51:b0:49c:ff8d:b548 with SMTP id 5b1f17b1804b1-49cff8db5demr513325935e9.11.1788875620062;
        Tue, 08 Sep 2026 06:53:40 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce5533ffbsm377235005e9.3.2026.09.08.06.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:53:39 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	andrii@kernel.org,
	ast@kernel.org,
	brauner@kernel.org,
	daniel@iogearbox.net,
	eddyz87@gmail.com,
	kpsingh@kernel.org,
	ljs@kernel.org,
	matt@bobrowski.net,
	memxor@gmail.com,
	song@kernel.org,
	sun.jian.kdev@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v6 2/5] exec: Clear bprm->mm before dropping its reference
Date: Tue,  8 Sep 2026 16:52:59 +0300
Message-ID: <20260908135302.74963-3-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908135302.74963-1-tasos.papagiannnis@gmail.com>
References: <20260908135302.74963-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7094E40009
X-Stat-Signature: mdsnba73wur3y15zb9qkgy35sqjhe6d4
X-HE-Tag: 1788875621-43039
X-HE-Meta: U2FsdGVkX1/B43gFuVLc1KRbcNJaTibsmlnJ4HwVvV7dMmUMd0s/1K90blAQmdejoumG3lJ8uX4XbQwMPE11I7jFFRTHamRGi5cGFFnZCnaFX5A0N3yLHA/cTx6ZMhPRv+4dTy7pXADg31nll5KaBffPfVliz+mQDw6NeZnyaR6IDHICyw6+N7GVk25zttzovwGi6M4g8HIsfOLLhrLV78EWGxBDGUAJ2phbyd3ybvz+J6bUC+RdGmNGRcXDFUa9X76XKVFy0plQ2YKpbCw2Kcpb1gbe8UqxZ0jn/miT5qh0XlNh/aNhVkNMIccRR1Aw03q9G8Lr58/uORDitVV5ChmfzVYkwkmuPgktu69g4CRPLcAxOInJHvRO58/alnNUzxlBGVXUb0cTNQAsiHMybpYYiAtw13kUb3uiRgmiNYIfSWGWv4xW+Rhm0mvNprmw/AdCaanqoiYCtRNnE0nnKtMqLWd9vxYxwmUt2q7fDaLl53lei5AgzjaSpqsfPYTIAr91Rfbvz1LjnQGPhFMgCwg+qd3rwKuVv4r4s6f9p2FEG4CDaMXi8/ax9ang19KtanqEqslkPufg4jnA4f8vnZcZnGh5U2DSi/60wSvONqciBVa0cYnfiYWhTM/H8n1tGMNIUFUqXBTSnTKPusrXRjsJHvVWBpMH9qnJxc1W1a+zOg8nZwuaQiJFpCXaxlDgdcXLVmY503rtCS38Pj9Yf/ytC4ZZ1P8AVDDB6LOsfwiGm3aNWDsKGk6unozqd+UWDSNBMCNWCY6ApOTHnTExD/SR9cwkrstAfgFlBVmwYdNKfzRHcY0AgcI0fHgSAcsxt2IejdOktKoZFySv1dRx4oE5QdsU67zfCIYmTtYuiHo77AT89LvwXGJ4o3M4lcSFhGMvL6CijDlqD7SK7myrlGMTDuZN0p95fbu43yf1uIuu8QfoPv5NfURa54lVsYhsNcaKaSjwZEg2axlout7
 1UFBwOfb
 4atU0tYP7cDuBLBxYqHIdcwuaGeri38USTCcs2JYdtUApoRNSNxKSswEzhH8wda2eN0qtcHWWLyY79f+8Bas8kcRW7zT+W2TS/WMn3JDWnT10/hirPw75NAtmsqb9kmtOsN0t48K7JUOtp59SzV9qiFhKR6z2iWqqmNoPkRLX6/BRMLpbb02RHUUb1s3YIo0MmdrS34VYowVDLIfurCqo+lnrwJG8fMp1/R6IIEPwIZN31LjejtHGToyJmJjx7RrHRrhqDEVmBPQw9tUBv5FA/B5rkxvqsWWEJ3W977j6v6teCKjoKHcahXQ7XasYNaw941Mwr8L/XUr1smmaKVDCmgq/fsP4xEMy1CxgGivh+cXzbMlhbfs2s6NEUx03vG/hNCtMmeaqjIUsJCmGwmVeZZ+3kIAJ+MnG3JB/s/6aZkorEIKQcBOvTpQRmU3m0Ro9sqElMzs7aMtH3RE6ZBHaxg7JVL5m+PQHSQrBogptC2mZTSN+ekWLBKjJwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Once mmput() drops the final reference to bprm->mm, the pointer must no
longer remain accessible through struct linux_binprm.

The successful exec path and the bprm initialization error path already
clear bprm->mm when ownership is transferred or released. Do the same in
free_bprm() before calling mmput().

This is required for BPF kfuncs where bprm->mm is either NULL or points
to a live mm_struct to ensure safe access.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Reviewed-by: Sun Jian <sun.jian.kdev@gmail.com>
---
 fs/exec.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 745f6eb5279e..4ddd403fd91c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1456,9 +1456,12 @@ void bprm_drop_loader(struct linux_binprm *bprm)
 
 static void free_bprm(struct linux_binprm *bprm)
 {
-	if (bprm->mm) {
+	struct mm_struct *mm = bprm->mm;
+
+	if (mm) {
 		acct_arg_size(bprm, 0);
-		mmput(bprm->mm);
+		bprm->mm = NULL;
+		mmput(mm);
 	}
 	if (bprm->user_ns)
 		put_user_ns(bprm->user_ns);
-- 
2.55.0


