Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65E12C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55AF66B009D; Mon, 31 Aug 2026 05:23:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50BBA6B009E; Mon, 31 Aug 2026 05:23:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D3AA6B009F; Mon, 31 Aug 2026 05:23:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A7676B009D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:23:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A354EA3FE9
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:23:50 +0000 (UTC)
X-FDA: 85161027420.27.8A93A0B
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id D975DC0002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:23:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GUGz0HgM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788168228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zON5T+icRRTPJe/tuLdlxvvWhTEjuOvsxI3luAAgobA=;
	b=4nVndezErDK1zK03BvpflsIbP1fjMa5skQLEsh2lj6yJHjFKWPiojlNvEx0y7Tod+fMcm0
	+BUvbzFpnznRjAJ+Ovx3Zvu6WIEn/juhMy1peq9UECiEJzp39rmTnGHcXLhjTXFLRDRGFQ
	Hc2OPpROuIausTQxDSIaN/MrON+C7jI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GUGz0HgM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788168228;
	b=HBKU1WGaQ2vgSLuGG40ybQsw2wB6rXr8FCyqDOGsK5Te79GErodX2OLdmWWOwirOSncVQV
	M62ndfrvargulWXqMIt4Al+tgPiigKXJ8EwH1yF8XhQbNBttQMXffCuufrIvzSf40NCKq8
	+3SJNtZJMGtc6Y5fmx/EFGOhq8uH/CY=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49b0d8bc2aaso31948195e9.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788168227; x=1788773027; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zON5T+icRRTPJe/tuLdlxvvWhTEjuOvsxI3luAAgobA=;
        b=GUGz0HgMnnbEPG4bXva0QdhuS1ayjKdT2tZMJs43SnNgUSfHP6CRGz5glSuOmHun9S
         lB4wmFiZKo08Soy2SYgIupAPaXSHqfTJB8eGkPUxXV3IHZPsXkt7I/eERWokbi4xCbfQ
         9WkoKo/lDtbNHmJvTKWBdwlhiFyTvZppJnZ0rSb6dsFREsAbsK+4zGa3EzReR6cVlh5A
         NWyNpiOJn6m69ZoPUZerYPdm1scYw/DFK1UWYp1NTDo8pETvLlGS8+oXohgqZtMSpKHv
         vceIA0x28bzioY8EwiW2e1aKZDxyIZt8tds70JfQ4EZPm2vtcim7leZXpz/sv+acEWvF
         kcog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788168227; x=1788773027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zON5T+icRRTPJe/tuLdlxvvWhTEjuOvsxI3luAAgobA=;
        b=DYbZTgC6ZKH2Z1t/yK6CiuoV0761UEjCqSaLqnfy106OdBPiIeNudhkqqQ5DrH8l+4
         d5UEsHvZSNwK8A1sM9lAHiz7HQid326bWcnLAcqBl8FijqIT18qTg18KY1m5Z3x44T4c
         V64ou+2xoz9QsXA3AtTgKeYxA0D045hFra8uPsjxRKdxHojfgYwBK8MP2ioQ9XMGCY+I
         Z3s0QzalqXf2IAcDQ69NuRIkXOxSPOWdFfVAtkX23ajue1DbKfjawoFMSINd5MiNutRp
         kvGW+GN2/FffeWzC/rv8/fg7Cq6k1S1W7b0pEuRBP3eLohiBBMS6zUjjVu++7PA+RqKh
         m9Nw==
X-Forwarded-Encrypted: i=1; AHgh+Rq/R2qL0qXpeYxdq+Asx1hC0dMpWP16Tji7SfpUgZXffsvtL1NTuKRZ9Y7B5zPDaUvJZxzaooGjCw==@kvack.org
X-Gm-Message-State: AFuF++mEwGEde4DPHDtWTEYBIvSM89KJlF2r5+lmoIucOP9yNLSuWPHM
	GXuFGvSVhA7hPvBBdaOO4bx26YPYlMfajQSx/PDGHh1l6Ll5+fMMykJy
X-Gm-Gg: AR+sD10pyrma0sC4yn6qmG65HICSkSyEIkYCb1n/KHB0vx+zdOAgfHVPI82EnGtjKM6
	up59MpcHJoIyI7eVXaZuFVeDDEu7G8yFsQjV2R6QMid5A6jWzJdS+ferzNpg3PAdpdW6j2303CX
	KbhMHI+HlOKUjlNYxBkdtl4rrTJa1YPJ0+2ZW0XSjesHshzVQ07ayLqOdqlo5fRat76uh8/IrgE
	rG9Kd5tg5hht6y/a0GI11xgCHYeuqplAb3kmIfqsrls2l6Adx5QfpLVtlZg9qw3q8ptxkxf0EJ8
	i7UGBwQsBgw8+KCkVLkWj6UIikr+d0l3N1OcBTmB0B7t22gtjTJuq9jl8Nd16xX/lXozaQpaGAs
	N9/QC6XBzzYQdTVfgi1fYZ31YJWNKhVtYupCqYZcKNGyDtE0z0m13vabjYZUv5J57wKrJm3KTxx
	21q+rDHAP90Z08ctWr2DVHABoH2q6IrbbRJlGNL0RkB7OOdPO5IWbQliNo3kdU7vaetjeCqLQk7
	g==
X-Received: by 2002:a05:600c:b85:b0:49c:c96a:d36b with SMTP id 5b1f17b1804b1-49cc96ad411mr286995945e9.12.1788168227398;
        Mon, 31 Aug 2026 02:23:47 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b9500c80asm318248155e9.9.2026.08.31.02.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 02:23:46 -0700 (PDT)
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
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v3 3/7] exec: Clear bprm->mm before dropping its reference
Date: Mon, 31 Aug 2026 12:23:01 +0300
Message-ID: <20260831092305.42062-4-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831092305.42062-1-tasos.papagiannnis@gmail.com>
References: <20260831092305.42062-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D975DC0002
X-Stat-Signature: 6di81yxrrt5zfr5twsmqjyngfuprohfn
X-Rspam-User: 
X-HE-Tag: 1788168228-426246
X-HE-Meta: U2FsdGVkX1+TVu6wTDj3oVBP0/hGu49a68Z1n21zU+FK8SyHsv28s/8Ema1xvfGp3zYPMTtul9md+RnP0zJlDMnVP3VQ5/CxydR4EI77RuaTmTeIiHxdfzSzRqbVIfLG99r+jZ+hi+b3vxnykLO4faCsVjz8zM357EzTyeqBvnqdor9Z+YCOxyw/ef6zukIlevtA0y3QwZCzSBZ3SDNsIFJ119FgVphF2GncjlzU0Z8ppuhMQlB2aHxwJicvz/7MFBKLc1dqIWMfCkfCGd22jKFZkyhHYFS/3/C0QrqdgCRNR4yIvvQtsHCQkbn90t8BmlHfb2Xq7goX+kSNirz5OcGW989sC2VFJmjh4ASeJYOy/qBNtkCXBcROPqBtlAU95CAxqVnH4Aqsc78p6lEd3IX1jYYW/Pt7vB96Dbi8dBa9O4l6hdLEdlieBVlv/oJh0F2XPj9aIWRfHVJZOM5PQ48zmHtkP+uJM3PVTR4xONDUTYkAk6vi8BWr+BwbtM+qhO0xhsN/QxFpTVINdcz+rXqSfiT/PjLRiFBSAID5rHg/yk8PpbIHDTI+KTIA2s3p/ZZUPVuVLXJH6itpFLp/79Ppk6Bo3B8Ry0dgKAiN/kQwL778oWqusOxJMjXBJQ3U4WjqbWV7+OHHl32PQJLe1BxwDv0j+awficRKNkqBTUc2diY/1c6qx9rhs/V9Vcl2m5PpIwcoQ4QmyGiZSj8Tn3kJCGwUzx313fUPeXV5ePnksDGA86LNaiy754sHTUEsVmQpzB/TBdsbFZVFEiujeThrNQ6f0GS5UgmuSywdQhleZ1lbURV3r6SyGa8tKgoWE/MST3GqJBv6Jtv4ANqX25y2Ctagy0MdgJPS5bbUaD6f7U6Nj/ligFoheHvFQdHrMfxeOj4Nnv3Vm02aiCAeJZwFC34VLlix6+aiNWKryRERPF/6DLSmM2CUjEW9u/dyJ6qxsuYGTXlSg1PUfAU
 29/C9ESk
 hg+Y7mDqOc8LRACBKxH6+g0ID2aFDQdzT8gsHixfXb00fNaD+dqZNHl27VgZBGrTJTo+c6Wr508W4wXn7roGVSQ/90RnbuZcOi41dQeW3XL6fllPeC3v8N+c3oBhxUZ/VMMdFmXDDW0PtTUria6A5CZOK+pnOQG6gRCa8xfkRtE6PLu+WuP5fg0fgCiFuxs0BJSRvRoOXhEj6AWoSydVf2vLynCkox0qiQGiLsRttXP85WTSfy5MiNYP1bxD5hBmOVrApck1xv+ge6qmaiGNK7et2rSVPf77f17EDMftKqeUTo63gPawJxTb3Ny6kEJjpIWCFQpHSebFMySpgbUKSheYwnAfTSU9m+45wTiqwYr+uNlav5JVHvWzngYc5gM95S6rvz8PdEI9iYmdRIP+6puqx/stqGKZHEEljgUzDNpbN2zROo8SQTnkX4dCsb34DPNLpkRUZskb4Dic4oRuXbUfatsofdi8N15a8cSibXAUr3jAzeSdruPfykw==
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

This is required for eBPF kfuncs where bprm->mm is either NULL or points
to a live mm_struct to ensure safe access.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
---
 fs/exec.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index a14f28b15607..4b4d8f0627a7 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1453,9 +1453,12 @@ void bprm_drop_loader(struct linux_binprm *bprm)
 
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


