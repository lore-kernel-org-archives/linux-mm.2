Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB546CD6E6A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 03:29:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AA8D6B008C; Tue,  2 Jun 2026 23:29:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15AB26B0092; Tue,  2 Jun 2026 23:29:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F17886B0093; Tue,  2 Jun 2026 23:29:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DEDEE6B008C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:29:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9F61E8C777
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:12 +0000 (UTC)
X-FDA: 84837170544.10.7D46E1C
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id DB6E41C0006
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OzoWqa7F;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780457350;
	b=dJNEZdWY+u5KDHwQAiuGNHnMYconQs9Bonle/mky8nYA8zsBC9J3hwXS1loJfTtm1scMjN
	aBWgnq38rFtZSJ/CnFJm0EWYsL+S/rZJRkDikicNe1OnJ3OlGr5QK14d7tayOzZjZQHwks
	zrn9NZrX0R+HytMKHh2xbSmLbpfyFFw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OzoWqa7F;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780457350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EeknQ7K2aMvDWr+2KhWa4BnSPX1nCQezxpcXmui2530=;
	b=a6184Ksi3Ya5/QjCaV3sC084pqz8ACuWgdUQftOywBKBPM2dsIK4ovT/LulHsXUcQJD7pU
	3DzUhfSQb5x+WMnvQStRXAtcJOV6ogYtd5oririo/6yr/Y+PcO33Sz/lygOCvtfNHPvA+c
	e6rakDE0Norb4581LV2vHjhV0eEbEMg=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8ce9e56f68cso25594386d6.2
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 20:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780457350; x=1781062150; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EeknQ7K2aMvDWr+2KhWa4BnSPX1nCQezxpcXmui2530=;
        b=OzoWqa7FQ2OkEsqqlr2o9VqE3uEUJDEymqsePCcqTnEnCJozmEgAPFI6+g6+MwICG+
         d0g8o8iTrSZcTO0cBpKOfjQHURYr8+s/PUWtyFlJwQz0D6S1ul1Y/YRxBaCsgrLYvdyM
         5n3QeMR/7o9z2aa8hnCYh95gaJSAKPN1suXKj6JVO9YR0/pWC72SthmxunJ7AYjNVTjC
         2kGFGJn8SVddAJSE+/e7Qc3i8eP1mQ8nkSIU450Aep4w0dt96CEdf1kzii12JxcRYk9F
         vTaKplTssZFt/G5+ifKd4wM/Kdj4ZJcb+Ya53vqnzTIigUyvigv9HqLjZD3O3pLMm7by
         n7Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780457350; x=1781062150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EeknQ7K2aMvDWr+2KhWa4BnSPX1nCQezxpcXmui2530=;
        b=hMLfOsRCWGUVJvhDdihKDyiOxWz+St2QmmLwzQ8T+LidYrpz6uz0Dd60G4FdVaRhBR
         SaoH5n3Nqw8vUF1WRptRAfV089DuTWRq7UETaPssZ0H3PbYG1ksxmpZIWdUHkJQllkY4
         fPvPwojOkDEuJWqbs7fpKKI/dowVWNTHjwKVdY578BssJwn56oKJXrDs+ahwVP30X7DH
         oAhE5JP1h+twr7NNpfwGlhryfy3Z3U+Txumqmi0vnRjE+zkWRzfJgMpr75sFTNqbd80j
         i/jk7tTiLknSWi68JKdNPECjPkz3gFqCxLq4/7y6tAM1YtttJanzC91ESLFYaUaB+Dsn
         43Ng==
X-Forwarded-Encrypted: i=1; AFNElJ91Mk8j3qWBEMW7h4aJps+jl9QWBqRDBb/TQZjRONSq7ODzOV95l9ieVn4qe2z+yuxxg58HPr3Elw==@kvack.org
X-Gm-Message-State: AOJu0Yysip7+3lqGfow+mUb2h+G6AgQP1Ce9wsE1Jg4xhoEv5kVLqc69
	lrF88P5g/efh/xF2r9/NkK9WMpjtgut6No1cEJKKrGMxtPNbB4vCZv2+vg5oX24Lyqs=
X-Gm-Gg: Acq92OEUfACIBYfrBAcvy1mrKMTu+s1l3Ai+2bDRupn0NMqpAIEUVjP379gGn0lH7uQ
	5JyUL4T6vpSbSML9I0nK8Ln4unvBgOJKY8pI8Xr1LW0IfT0MD3XBti7thzhRbL22e6PQEgf9ig7
	wPGpMjSBVyZccuY1Ir8/C/ZCdrxtofuMOAeSrJyF3ucL07jPTicTrNghsXSl2o3Nm2SN4NVXvD0
	71Io4p2u0Udx+3bk+i9ZVQcdKB+BxxpVBjHs4Qy14rde4xV/c6MkiUohmCxZak6nU/+amVHaC7t
	decHNnlbxZTa0lLMTtz7xLcuo4MjwpbD7iyfhzGhE3ynnfQP2sAufnk2Va4qsEoboVDfs7T8sMu
	MV/nPGamGQAJyc9ArlVhtxm4Cx31BEiOB1VVHW2B/Hpc5j5ZlplY2SLNCtAG5WvlET8cQSllluv
	CNmdiHEw1mknXrOrWFO1+8YuU3BAcDnz6JVbyP2Re9ShxpvzTja3COwwOKtlTP/A==
X-Received: by 2002:a0c:e086:0:b0:8ce:ade5:e8fd with SMTP id 6a1803df08f44-8cecdf0cdfdmr18753906d6.25.1780457349833;
        Tue, 02 Jun 2026 20:29:09 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd26b3b9sm9244566d6.45.2026.06.02.20.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 20:29:09 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH v6 02/13] liveupdate: avoid mixing cleanup guards with goto in luo_session_retrieve_fd
Date: Wed,  3 Jun 2026 03:28:53 +0000
Message-ID: <20260603032905.344462-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603032905.344462-1-pasha.tatashin@soleen.com>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DB6E41C0006
X-Rspam-User: 
X-Stat-Signature: upfrixk1zih7pem9cad1r9746p5q4yrb
X-HE-Tag: 1780457350-745693
X-HE-Meta: U2FsdGVkX1+QxT+dk8nQvZM1U12tpgGV9vIJIpkUtj2oEwRgU1IGkEP3Y9w/dd3APQovA1z0Pp90aHjsleV7IvXQXSKycYdtWSRMtTsAKeaosTmqEPY0y+j0AkInTSCPDSAdUrvHxKURvg8XxOaRrDph3ehujrXF53zhsPMYpyfte9BJYK5j7b5H93wVepPKfaaKQrwa2tHCAKiNYcY/pdp541nW1mhxIrcnYLs+7NVRtzgW3/s3qGYs81HOZ+D/aUtYyaenMiEKkIzs2pvp5Wa6ctEY4mCG9kbgfcDZPZhAvudOWF9be8ohOsJOTCokKi0qT+vhN8/VlBNkHRe7CjQzSIQlGo+uX+6JTtRnSPdPg6YcQOJKx5PMfEuBk2l0eiDpe1q3h+XJYqIzJ9PdM36IocXjAlHkZ9Z2FRnY59H/bUYdLdn6U6P8SHjjhWTm0sK6A7JeIzohhEhp/dqAGdjwY+VQeTgo/ZMg4WqQOZgMRxVISKuWYvnf7J+Cy7iUEf5tAbDK4u8Wh3+Oeascta8Fh5jXmPBEsuEHQk5IkjGIow/ooHXqWWQjG1kTN8aVyXrlkOZ8W68CvYSoXzvNrsNtWk2+VPu4+6maPBmZlNGVcdtbX14mIa1AwWRR82NA2jR/Ume+JYJ8ZXNHvhNS5SbpZfLO5xUobH4EdvRIHMGN9gxYwvmM/omQi3jKOBeBGgL6NodB31tM04AJDp+VFk7ACHLRLmOSj0mPY3etxbI2NgWFliBnvpy2bBH1PZjDc1xV5gEeBVaB/9DbOa9TMHzOpg+kwZYORmNAoaL6C83UVeRBcMNwA0NGtiF4Hjh0xTSYQBCEedd8yn1NRWQd6aj8JPCtpcwaVz8iEe7/qEBQIbO/B/1ogQHLfpO9Ad5pk8ssElnBq8fzHYBm5jjDJkBdMH3QSH+rbrQYpywWRj+cnIhbVyx7lkPJHJfEo022qkLNoky7R4vvT3IWgYl
 ESCuu3EE
 XJBkNItTqDKoZSbO0iKwxEqGZM05q3GhLt9gYpZE11/nckUbYsG4BSuau+O9BzuqnTXtcsrJkvv1JgDmuPgXbt5ru8GCOokYHWv2tTAP1IUEiK22S9phpgGYJphTwkLkxxFoDVJpfPVPXdFSS3d5T9f2GG7yidteE4MIvNIAvw/43KwcB6P3dttn9fLDsAyAjd0DXxeYRIICoeI8Hf/GMxzSWHBVUpcr8KfQpeu5uHXQa3LeUcoYg8jvAjhJ9aC59KOu4iSXzSEK8w+RxT60RxJXqSKf57sBRLF+k7uxz5IXeq1H60u6GqTUIDs+RF74DBHWQYU4BXU+2vzl1Agq4Uhr8TnzHavipOEGH/aa4J9neFsNBnkxK4drmUiFJFrNoeTax1CUVoZuEZ4Xgj4fItFbvdFtcHkDT1U27dIlaFrLtxFVxYLwJDpRHDjrDHIHC6LBBoqdZNakjBAJckvPZ6v3F8YmVDc4P5MYm+BIpJ5xBMns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactoring luo_session_retrieve_fd() to avoid mixing automated
cleanup-style guards with goto-based resource release, which is not
recommended under the Linux kernel coding style.

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_session.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 5c6cebc6e326..47566db64598 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -291,10 +291,11 @@ static int luo_session_retrieve_fd(struct luo_session *session,
 	if (argp->fd < 0)
 		return argp->fd;
 
-	guard(mutex)(&session->mutex);
+	mutex_lock(&session->mutex);
 	err = luo_retrieve_file(&session->file_set, argp->token, &file);
+	mutex_unlock(&session->mutex);
 	if (err < 0)
-		goto  err_put_fd;
+		goto err_put_fd;
 
 	err = luo_ucmd_respond(ucmd, sizeof(*argp));
 	if (err)
-- 
2.53.0


