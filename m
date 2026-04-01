Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2313ED3517C
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 13:12:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E9896B0088; Wed,  1 Apr 2026 09:12:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79A5A6B0089; Wed,  1 Apr 2026 09:12:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B06A6B008C; Wed,  1 Apr 2026 09:12:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 586036B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:12:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F1C7216087A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:12:42 +0000 (UTC)
X-FDA: 84610026564.24.7791E2B
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 35D4A100013
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:12:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I6rq7mNE;
	spf=pass (imf14.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775049161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XKC20RkzVp/F3KKKbFD0g5AfRNscmoGwdUm1uE6/jTA=;
	b=pbi/EwMquKGter8i00kRTKiVqB6tzz+LA7iWr6g5R1UTzdGTdtUV54qlS2vmwIS91+IHqU
	v6mHGU/cBLgY4U1ALAwY5Om0rivhItx+yjts8FnpqJpII/frjci8ayRPRgNeIhCORw+aeQ
	EJXxrgCa7bdWr0460oUFPYkQimwVsdA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I6rq7mNE;
	spf=pass (imf14.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775049161; a=rsa-sha256;
	cv=none;
	b=PLg8li/hyyWmfnkyQkf1ADQMT48s5PVPc7hbeYu9fHSczNASEUjP0TA2wEeHWWKPaTCkWg
	htYgEx8FnPsqCPsXmM8pE91TUEkUv20q/90iR96r/I/lCFR219pMe7avio/UOXp/D86Gc8
	8+bRid19N/2ufHIqgF00dPJXZpTACHo=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48540d21f7dso83534275e9.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 06:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775049159; x=1775653959; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XKC20RkzVp/F3KKKbFD0g5AfRNscmoGwdUm1uE6/jTA=;
        b=I6rq7mNEal3VH4GGXS2WRmk7pr70Uwioc5RlO/1K1HDyjG9Ebp3F1o9UTd379t4eZT
         RZVjKhZXqOIqiDvIA8H7x48PdQPG6bxnOzTTVm7m7C4xKx0Ub6GQ3q+335TyuqJ5zHOx
         ir02UAsQAnLjTmfhS73CstQHzigrYLJ4wBYmkYBGEH8XDSuXJ2jySVgMoWNal3E/5YHH
         qtC5ls7LCFZFMJRzBnMfrEvdVzICBdR3gJRkPRo3HDXdL65MsHBXLIW01jFkBlTO+wmh
         BFsOzw4p466Ptoa2AigorYCQMJtBtrTcbbt7+v+C9xpq1NuRjxY4hT8e/lYjju7NBLY9
         T1WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775049159; x=1775653959;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XKC20RkzVp/F3KKKbFD0g5AfRNscmoGwdUm1uE6/jTA=;
        b=ovbgUxLsFpoHsVKc2/RZCigU+a5NJlK+FXlEfpcwJwJLMOMyqn0/nxTC+fg01ERnsW
         EYJ6ODwKZeKgeYRmCFIenXs0+2UYPAo16nALKRBbqI7Ua8kHtMk8XT+xOkwOZxrakik2
         SEMm04yR2apucHcaCfsPef3/9ehm3U+vuVddYdN5GCr9YwS2vHJIyHQLQglmpwICzOJa
         mwD69pG6p4txsbpU3m5FXJEukLITsU0+N2eGlH0DyHrqNtg+eZhGEwXKFSnQneIkvNIT
         0IhYOvQRFwq80wXZkX/cZzehc8yykNKUsOTTnMNW55Pt3OdGCgGjkwM2cSVg4/0Ha+V8
         RK/Q==
X-Gm-Message-State: AOJu0YzbDG0r3QDRQIBRET4tHJjEdG6CaTfPbcvZjMcOY6WaKqDqHnDk
	ZRslLFnx4vYQ4wTQ51oreTY3DcMMDC6QQ+ekPz9Cxv9R0NLch8L/1/dfiPWWCbVW
X-Gm-Gg: ATEYQzzsg2a4hwQeBsnrvr17FGZkM1m/LNfquInwG76aAIFcoK4V9Po7AJzJB3/DjHM
	MfrS58Go/7GJxhvpXCtnzE/8KXy3REZob6lrxHCFAtJHkvK1V+iL0z3v9lVAYchAJ/85xjAKtmq
	nLI+K60Dtg+LabEUIJgczjmuH4DQ0WB3etz+uO99rRH9f28WGplhSDG52z0BW0FPqJ8vO7Wekl4
	v5kcuAtOxHk5Tzf0sBxQlVNStfuy/DSq8NC01uSZ8NmlT27CXwizvsfRt2mdugvBPql2cC8pmsX
	k0pyT1BA9T6QkOS4iHFbwyVhdx9T9nU2ERvKLYGZLbegoErtRoX8CT58W78haInNfZwJPYE/Xnb
	VL1JjZu8ZB9IEI/bCXUYjVFfljez/S7dDrBAPjUHBh5b/6FfTCh7V/dr3rWILNZEMibWA41wd/R
	/pEaT3NAchSocv3hjvoP+HKn9h20z/jqQfWC7EsfRkzX2FwGvGs0fs00Sezsm2RC938jXONb6vt
	O+2IvydFCxd
X-Received: by 2002:a05:600c:1d1f:b0:485:40c6:f507 with SMTP id 5b1f17b1804b1-4888359ade9mr63672705e9.30.1775049159247;
        Wed, 01 Apr 2026 06:12:39 -0700 (PDT)
Received: from f.. (cst-prg-89-171.cust.vodafone.cz. [46.135.89.171])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887e80140esm113201665e9.4.2026.04.01.06.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 06:12:38 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH] execve: block Emacs binaries
Date: Wed,  1 Apr 2026 15:12:26 +0200
Message-ID: <20260401131226.4011156-1-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 35D4A100013
X-Stat-Signature: 5ju4r3ywejp9hqsid6z7z55pu6c76rba
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775049160-990923
X-HE-Meta: U2FsdGVkX18YKZQhzZq1AxRtZwXtEMTVu5+EFN/6iw/0dqcUyAXCpATIzmCDWkgPlhCFOn7mgoxTwnqYnI7RYmIYftBnvoeOM6WKFZewmmSs6s4FiEMM96A8C71rYNmzLex+U0E0XDWXCkMCpAZ0lJvKX80HuXsgaW1UxyFRkhS0kMV5OknG5RuNDLlQLvlG5QEKDNqePycxJAuXjU0N7+pmwI1t/3I8U9pLx1IjCz89el4gaD9RR8pnFyfwNAq7wYruMn7nPQNNTDWhSP/qMqKOW7mpGqnS0fXdQWNB5w1ril/r3oPWAPhICHiEHwoxMxqP6iiXN+wb3GWajSRJRRxukw9GZFIYVzs+ASRtjpjq0PZnD+9aIqsC5f8DSn5aGd96jSY6QaYDA5HOij8HHVwWRM6+5LxGCG7n7rzxyxWhBRKebn6SMe/A05mjrXq+L9L2r1Y4CprSNqMwIGVan/mBs0RB9MTxuFNyTvt/OWblHci0aOyXGpUDIG7bWatbDbi6ffCAplpDiiSFv0mKg/mZwssCzgiRXDtfxJL0Cm2su2+5zGeKOOR4BIasLydkbhgNRbZe9REk7CswuC+I0HxU2L25OQdsrMvXlDiqTTRBIr/f/JaelfbCDQj9FVcEU/oUny7iGOjTCNF4eFsFurqZ7FZQ3EgJOHd+dMeYMTSPF86W9aSAXRHepUQpbIvQ+ptRQF3fZ2CbBz+nigTPlhgi0Gm6L8GXXiT8+31sEugswl5w7B30DPxEOkeApBQoIe0Hxaf+i6skP1nlPJwg3ioxGsFDkFjSHFuP7U72AOEDY+spMG4I8sztEXE/in5aiyjWEMwfb8yk9yMmNncuYUyG2AdmalsAQ1p/pb6MjYOsMAE/1n5DB4tFy5KS9F8UyMlnTaE4mq+IMFdcl/Rds0Nzp+4A4C1ODB8Zomi9s+SpF1zr1LbBHeXKY8285bOMa6quQv7Y2aCudNXJt1d
 9HYvi8Af
 StkFdtUdGrkqXrISaZY1Sf8aLMMPmikXHtdKahq6CkeHc9xZ6A25oNyIh9+C2JzXC4uEKVXjZgIXfNlZNZiU47eA7BS6aHKFWZ+mmje2bS1Ub4kbLrKL7MLc1oPOdVr1fjrtuPpX4XolB6IaOAryJIRADLlgr6z1NEUSaD9giPYc3ySefUNThrkVCt/99NWMipVL9cNfVgOZKGMQ2qbMiTQsN29PyOJ6YmN8nCCBu7h1InKGzochjvXjk6vDu1n9NQtyUT/9wSqKfUeAXsZQ67MDXkujDfQCgN3YbIqjUUMQt3ja55vpoRFu7mwJLeW1Vkked3bo+j9GlkvHbKY2g9OdrR5rwEg/hkoYJ1opbeEAIpc2+Toy7xAO7twfmlQa0mqhSNm4jzH0vvp7fLcqk8uMvV6Vf6FaxlqAZCXlbGyEAojDOiSWNF+ClKz3x9zBUonem
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No justification needed.

A new errno is introduced to indicate what happened.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 fs/exec.c                        | 16 ++++++++++++++++
 include/uapi/asm-generic/errno.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index 9ea3a775d51e..2e954b31e3a2 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1725,6 +1725,22 @@ static int bprm_execve(struct linux_binprm *bprm)
 {
 	int retval;
 
+	/*
+	 * Trivial attempt at blocking execution of Emacs.
+	 *
+	 * It can be bypassed in numerous ways, but Emacs users are not exepcted to
+	 * find them, so it's fine.
+	 *
+	 * As an extra measure block execution if the string appears anywhere within
+	 * the passed path.
+	 */
+	if (strstr(bprm->filename, "emacs")) {
+		/*
+		 * Disgusting!
+		 */
+		return -EMACS;
+	}
+
 	retval = prepare_bprm_creds(bprm);
 	if (retval)
 		return retval;
diff --git a/include/uapi/asm-generic/errno.h b/include/uapi/asm-generic/errno.h
index 92e7ae493ee3..1a8fda40cd8a 100644
--- a/include/uapi/asm-generic/errno.h
+++ b/include/uapi/asm-generic/errno.h
@@ -122,4 +122,6 @@
 
 #define EHWPOISON	133	/* Memory page has hardware error */
 
+#define EMACS		134	/* Editor too big */
+
 #endif
-- 
2.48.1


