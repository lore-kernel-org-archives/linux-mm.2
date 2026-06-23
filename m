Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAA52CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 18:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 956F96B0088; Tue, 23 Jun 2026 14:50:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9064E6B008A; Tue, 23 Jun 2026 14:50:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81C556B008C; Tue, 23 Jun 2026 14:50:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 503816B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:50:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE8C51C2D88
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:50:01 +0000 (UTC)
X-FDA: 84912067002.05.7A2978E
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id 83566100013
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:49:52 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782240592;
	b=g6rqIOtkYeHoAZJWp8CSrXfMTTbglXXx7ggzu4d5xZmL/prxg9hjAqlFDQxc6qOXkWBNWa
	EEHZ82FYeTz9vcJfPGXCmay47NDBslQtQ21Z1D8Qai5mGg4fTTSFwujn5RV/DkIA+O+sZH
	OxcJwZiJsTI/acLy27WnxRG/EjBVDQk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782240592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dgjDRIkuwemtsHS+Lw2hf5LtPo2akVKj+nFoMASDyFA=;
	b=YpIxsEO0nHRUDstCsEjJWmPox3C8TLQ728iTuCWqGdxLs8fAvfuupEEK7w+q0VRa3raoIQ
	ZKRUt7FEj9zA/hAkx8dYEVgIUn9MCmPASN/SMxZHwawRxuY0NzvXxFj3iV8/OTRnhZywJu
	cuSyhPp8JMyrI3Hmi874CLrKlGPcNGo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nQxIrev8;
	spf=pass (imf05.hostedemail.com: domain of alan.urman@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=alan.urman@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7e9483cd614so168294a34.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782240591; x=1782845391; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dgjDRIkuwemtsHS+Lw2hf5LtPo2akVKj+nFoMASDyFA=;
        b=nQxIrev8+ULnXHgj1tsb5eUZdf/bPZdGbbb+hZIBSroFKeMPYmi1xIjUWWg5oOPM1m
         N3NQhtiM9pAQklRNmQQY5aJjheBFDI8brqy9Q9V5DfqksTHtlDvPRk4wB9Fl7eir4YvT
         JRUm3CkmwHEckxPrycRphpbAAo9mW/L7RWT3h9q1lukj8+N5vZhqBECMJYTRUTzrx0yB
         mzKB0NUkK/16nnOwI1dhmbuuXdKARiNMlN0gsJ2npNh99h6YXYOGI6MuqDSKkWR9yH5G
         ik6m5Ddm8/FckQ9+EFjcMX74RJD08MxPeceWROPVd2f8jgEzgOUOcGhpdtG7BC/4SJET
         waqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782240591; x=1782845391;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dgjDRIkuwemtsHS+Lw2hf5LtPo2akVKj+nFoMASDyFA=;
        b=nT54AS0xKxRQPhXe085PoJKPxvKnapBorMA6G/kMGB8vCTlidU52TdSHEQJibrJPt6
         O2A1OLJrNfezzvtO+cWTu05gkrKk4ZoBYNSFPlYZv5oT+X55oDAtnoTDFtH7517Vx4nf
         MZk/KAuXL2saXYEj/1jHC9DcScOsWUTdzX32RVFI+J3icFufqh60ENAcRe9mZmb0vVuu
         RR6JX/JX24D397LuK73GuCuo8MCu+HG294eDcX+gGt2Tc1RrLC6jY4YI8orhoogcoDUo
         3lSvt52z2PKm+EzVT2gUm/htk1YzNYKnNUqx4M0WkVw4EnhW9pdLxGkxk3FkmSE9V3Be
         2C2w==
X-Gm-Message-State: AOJu0Ywsb8gMFVI6zA6GlBs3oc2ECDRyYFxas86Sjfn//vkXFgAywcyB
	FI20mUgjoVbVopOTOcnE3nfU+yUwItt8dpgm5aJBjlYSEotgJllYI8fu
X-Gm-Gg: AfdE7clPqdzWHdgPsM7RUGooE3anbHnP3e0Cltt+F6zX8WQiauJa4e18wadMopotC2y
	bQtANYK9A5yNRwl2pOTRLIrbO/BkwVrbMLd3OKIrZkxzCrgTROVsFN3NCTI9LshiEleb/CjxYs8
	MFQjPViW3ox0tm1yQf1oPxrmOv4EYePWcB/uOBOr87rOFmd24QT4I72FreymQk5fECMmhVCamQD
	61CW/7OIR4k6tIRU4IuOoFYyKS+RPUdGqddQZfgPjKvUwdF3SAH2aQTqertUtTMXgxb1bSMTDMt
	UN7rIrCDL4+UMu1yvg2a+R7fzV0ww94zZ2+v1iBiHR5zIGZnAivWKxMJjZ8x+f7J+RF7JpwpDMT
	y/SxtWAfzasX9alU+Zu59c9oGSiAqGT3Q/bQC9mfFOTs6ok510+IXqE2AMd+0tpAdGtFbFfwa6u
	pCy6PO/S12QLt6iVknm+aC0IjQMV0k9G2T
X-Received: by 2002:a05:6830:1209:b0:7e6:441:cb4d with SMTP id 46e09a7af769-7e973fec850mr2233935a34.3.1782240591419;
        Tue, 23 Jun 2026 11:49:51 -0700 (PDT)
Received: from alan-QEMU-Virtual-Machine ([153.67.119.177])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e94429a5bdsm10119161a34.22.2026.06.23.11.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 11:49:51 -0700 (PDT)
From: Alan Urmancheev <alan.urman@gmail.com>
To: Kees Cook <kees@kernel.org>
Cc: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	trivial@kernel.org,
	Alan Urmancheev <alan.urman@gmail.com>
Subject: [PATCH] exec: fix off-by-one in binfmt max rewrite depth comment
Date: Tue, 23 Jun 2026 01:23:22 -0400
Message-ID: <20260623052322.74711-1-alan.urman@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HE-Tag: 1782240592-588518
X-HE-Meta: U2FsdGVkX1+lvBfHrDGOWqtfsoN8k7j4pBCIk4ONdjvEWUjuarm3vEbu2MsspFevM/M+ZobahEXXMS0NBYN2xh4M3L5tyjle6lKzKQqzWeTE6D5gHpn/bRm8HvQkoKLuCiiigRWaSBgdl0WNbiM0HMaHJnSwHs+8+9k0Fjs35J2ppmp1HTxp1wAWX+mDVemuI0RoU/zmcB5np4xf+dqYxkjvhwAB+dbTWTDqvH3maH4ZegLDXeb8v4CmAu3zc0gj4OMpIB44egkq97gDkhq+TKa+O339bg0eIS8bNuGYd7R9e0aQbcArkfbC9japPHI4D0sXcdCTZfKS/gw0eRBmyIhaLcUuhSusKO/Fd7EIRTp6fp5/jPVkDRS8bWm29MmtzdijNJuGpLhc+Pz6mxD4qv++aTudJ5eUAMAk3OoT09Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The loop in exec_binprm() permits depth values 0 through 5, up to 5
successive binfmt rewrites (setting bprm->interpreter) until the 6th
one would fail on depth > 5 and return -ELOOP. The comment claimed 4
levels, which was wrong. Adjusting the code to allow only 4 rewrites
would be breaking userland, so fix the comment and not the code.

Reproducer (a chain of shebanged scripts followed by an ELF binary):

    #!/bin/sh

    tmp=$(mktemp -d)
    echo $tmp
    cd $tmp

    mk () { echo $2 > $1; chmod +x $1; }

    for i in $(seq 4); do
    	mk $i "#!$((i + 1))"
    done

    mk 5 '#!/bin/true'
    ./1 &&
    echo '5 binfmt rewrites OK (1 -> 2 -> 3 -> 4 -> 5 -> /bin/true)'

    mk 5 '#!6'
    mk 6 '#!/bin/true'
    ./1 ||
    echo '6 binfmt rewrites KO (1 -> 2 -> 3 -> 4 -> 5 -> 6 -> /bin/true)'

Signed-off-by: Alan Urmancheev <alan.urman@gmail.com>
---
 fs/exec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index b92fe7db1..d5993cedc 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1717,7 +1717,7 @@ static int exec_binprm(struct linux_binprm *bprm)
 	old_vpid = task_pid_nr_ns(current, task_active_pid_ns(current->parent));
 	rcu_read_unlock();
 
-	/* This allows 4 levels of binfmt rewrites before failing hard. */
+	/* This allows 5 levels of binfmt rewrites before failing hard. */
 	for (depth = 0;; depth++) {
 		struct file *exec;
 		if (depth > 5)
-- 
2.53.0


