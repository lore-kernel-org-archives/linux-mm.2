Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A80C7C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 08:03:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAC9C6B0092; Tue, 15 Sep 2026 04:03:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80076B0093; Tue, 15 Sep 2026 04:03:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B257E6B0095; Tue, 15 Sep 2026 04:03:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E26C6B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:03:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 087DE1A034D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:03:35 +0000 (UTC)
X-FDA: 85215257190.17.FF66B7C
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3A8948000C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:03:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="UNxDcAf/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789459413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BcITG13Gvl8i0HA4g724jWVmnWns/ceZ5ECxTEaQlok=;
	b=Jhbig2NGcth6AeA7b+h2jFP2jLiheXUQhItsazL63qLEwLzbizRlGQn7NppzAqteOGcUar
	Z9Zam0bddbsN8HXEM3CwZphGRwT4PpbkBmeJq1Ri9n4RMi1IjNTSBX8mTJPMRZRiwvxKDM
	7HhiAUX0FYs+QuRfqDoZ/ILbuEEVn1s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789459413;
	b=qaU2BIXtSBYVGi+1Tub0lqBhudlcLCtLwM0LxqoRdLIVRJkHBInLqPGq8d2wPglmJib5IS
	JVg2rAoPvUmMxE+JQWmLOE4jyMgnkrFBYod1bN993fvECrFo9BT095GgXd1t8FLfU9u6Lh
	j0HFSdAceQu2LqRXeShwIPNZ9tsoMwg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="UNxDcAf/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-487072ffcf4so424303f8f.2
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 01:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789459411; x=1790064211; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BcITG13Gvl8i0HA4g724jWVmnWns/ceZ5ECxTEaQlok=;
        b=UNxDcAf//nu9FZdb3YTnwpQ8gGHOnIldzH4pb/AiNV2/ka5QyfBbkhnt6OFKcvxA6D
         dbRwMAXxac1tT3TbnQb6a1oSzOwehyAMXwSNTN95DhfjY5TGItcw0XlB1FMEr6ZeoB/D
         4iH1Z7sUI4Ln/M1nD/viLpd7Q7PG15FtPwSjDyht3QCNXaZuIKJk8M96Oc1wZ0eQZUQ9
         PhGF5WUNvY7zypCgr1FNTm7B4Rd1DOV1bqJflyfdLBqTD+OcFs8ZEmRR3U80nTgZrfGy
         opzgrT1USSUTSVPh/6mBjyxIp9n5AecVkO2+Ia/WlUTYAPr5YmnVPDU6DDqYvny1bvxk
         Gj3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789459411; x=1790064211;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BcITG13Gvl8i0HA4g724jWVmnWns/ceZ5ECxTEaQlok=;
        b=xpH6O+H0KWPZJuWHOZocAkgYqRrC2DGiC/yy2jhqeT6bUDvwx59+1+v0lge/lHorLH
         9YlyomfB0rKJhXeL11ZxaG7OfR31PICV6ctILdewr8Ak5kD038yVl0unU0Z2xlm4Vty3
         Clo2kPESrLxJAa0htMP26kRZUcrYI8c5YxZjcsTa4VQ4JBf76pBJ7PvnnguRLM8Dz1qf
         DuU1NoOfOm8aV8+4PJvCw5F/dFwsgVujgmHq3NeDtFaVQ9Q8PCMHW9KZBSC+yTEZdTTz
         1CJwrokGTX27SQZ9N/VezuLdTZEbbLfX5JuAH6eezq5A8CUoGBnEU7tLrvq4msdk4yfg
         joMw==
X-Forwarded-Encrypted: i=1; AKwUvBwcy7fXw/ZMvht6YaaZ09yKZlkAWd67GjcIWEcujiKZWTNQ/H3ZZou9JoeR+1+3C0vZzamaEWgSow==@kvack.org
X-Gm-Message-State: AFuF++n9IP0Pirgw1KuNhgLTh7ftsX3ldaSPZLehfLhHQ/3sAkIsob3x
	2jh9fGqN7jgceb0hvvdXCT+mcywfMcpuZc5uotf+cIsXwbucl7gYwnAX
X-Gm-Gg: AYBFou1N6Hxps95MXAc4PuiTED8vB354A78o9frcjJQQH72LPFSwnyC2nHmYqWjWOeQ
	J0/6xLFyxiZHpNU/Mg6JrdfAJ7u/JVnztKan6xvQtgzM5SOX0LldX/8VY5iP02YCfQQK1NRAKD2
	fMbPOI/DXScyBWHnz1rr4Av907nGbaI1CqAztMfcHquniNtTLEwh1h8WtKNxr6mZEmWkVdPTUXh
	tsCYxZL6F+nwXYB33NshWM1Fo/e2Z7Cw3gj7NMzj70v30z4CeQhPJM+AyYrBBAmKn3MkYA7ojDS
	MQJDfrk+kyBmEIu6sazh7ih4q+PSdoYhKevWCJBLyxCULl2feqePqhXaTqkHi65ADZTuMQYT6RB
	RdZcyjY+kzHgWiHHnyi6kM6BqFZK84Q6NxwCDygS+CnfsCKIlUS9OVFdrLX0RqmY+PuHi/o9OcE
	ewzKpglL5vOzlISUMDMxSqIiCgQnIufUSJR85xeaFexdtvT6+0uP2EUDyPPlg40Il1k8DWY84ZY
	S94FvZGBKHxmW+cZMaOggWvkmw=
X-Received: by 2002:adf:e19c:0:b0:487:939:23aa with SMTP id ffacd0b85a97d-487093923e3mr1057036f8f.10.1789459411449;
        Tue, 15 Sep 2026 01:03:31 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b4e:8500:290c:210b:1c76:5710])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb35c071sm33764675f8f.33.2026.09.15.01.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 01:03:31 -0700 (PDT)
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
Subject: [PATCH bpf-next v7 2/5] exec: Clear bprm->mm before dropping its reference
Date: Tue, 15 Sep 2026 11:02:52 +0300
Message-ID: <20260915080255.48929-3-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260915080255.48929-1-tasos.papagiannnis@gmail.com>
References: <20260915080255.48929-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3A8948000C
X-Stat-Signature: szumrbckp1m55rewzbdurndo6pazsig5
X-HE-Tag: 1789459413-441116
X-HE-Meta: U2FsdGVkX1+hwRySorHAkZj+SeofC7I+VzXzMGuYhxWZ00WV4NMAWq5+/KqlQfb7///DO6XfxKLrF7NKtv76poZ4jaQVevk8IFEL3mr6h95PjP9vpY2nRa/yqVVhlZ+DKPTk5vfjFwZIZdSN/Noa75BpFvMeInmGASdqDE0PXrT8lV1pLXpIInuZDANzK+fOK3neS7jEy9Sy2Mi0HklTvQIESgbU0JHfwy7J2jF7d1i6ET42VauBKMoukJzN6SkCPtbmN9PTLbw8C+6HeJPo6Q4uTYEzsy/YDuI8rKmutSSL9mwDRTRWNJ3KLT5eLTDx/ISkRiMvI081/9sYoVoBSSyHcTLsdvXhGDGiDrVPDszRLInOjK9L7zhyOmnrtdm4A3ddWjiHVDvw4kxzZ6R+cgJ/o55WDgjBadXkS66AphVMwQbtbHZEnmF3Qo4TN1A/jeEIzVmSqWAqU+4YDuAP+scXo7pqgx2daM8pcMwY21nGxdW2RUujmeX4No0YRvCipb6j0Nt0WEAGMd9lcekdGof9Z3SvD3UHAt3HKbjr1Bh9ABvSNTmAA6g75fIADvzhWxu5OCdsotGpVRNjPeICgWqFetxfCJtdPeLuQnpgdVtzrfb6NMzeeVsQjuWJyBpNETb+J79tOAVsw9y+p2qU2LH9/HlFGrAzU2oHaTseLKT1ypQH5EcgnZobVGKVc+4gYOrw1OSGPd8aNFyAIUDZnmEC3zBMcLVjnvuPsjaPY5SkSQrRsjR5lg0kS6CSF+Tfxtngko8Rc2/JyjnhTlFyNJa1jZSX6O/GBPZ0N64lhDiARniiZBBLZbvpWezGHjXv1j4r341Gy4QnQYLTBbGJbd8Irow/ci57/Q+9G8mR3kp72ynoG32Vyc7NGPtj3T00LUyDydod1W0F5zu6YwDAHE+hgqEQnOY+rPHIuwBRwU8cZcG6MIsRxgQHpAxJjQXXNZaGPzHKu0tzwlKoQUL
 ckODpGL9
 XNVDSMBQ53+lIriwcnbV0kT8hmOs1+5Lt+PB2TIBSOIJMjcXyGk/1lgGDIWqqX/zXWpkLLqFIP/fBx8GpU0OUUenX3ZTiGMOLGLtnrTbzLIdmjs1oyT3jlpRZknip39uloQdxnf+zPHZeNMUDV+NVueNMsf5Z1rZ+ye7xiJz5ipQbfcyzSBLPscePnKUq5C74phC8+DwfHA5aEZrlmeXIKij8uIykd1KrcCjYUdY1+0QTlaKhcOoQb/+yxcNgoW4TUsuRrxrAU9zhreVCm+j6eLfhx3IqexuKXU+PmiJaRsm+7mB70nsdw+QkfrV/NtD/WdRIr2JdrR6BM2JGm+BvdmnpxIpEeAumyt0hc7Tllvo3iBDkwMX4fCcDRRpx3mDUkP12ntR1UAn9rw8hD8Boi5R2rtF4YVgR6W/i1nwM68lUoA9xNNVr1hT41+4+ZAFD4jWZNUbQPJW4VCJx6obRg3dVXacQlOzZw1eJh9ERoT0WO7SSA+eRurJoMw==
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


