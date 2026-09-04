Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD8D6C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 14:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5331A6B0099; Fri,  4 Sep 2026 10:54:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E3BC6B009B; Fri,  4 Sep 2026 10:54:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F9FD6B009D; Fri,  4 Sep 2026 10:54:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1284F6B0099
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:54:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9CE8D1C008B
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:54:21 +0000 (UTC)
X-FDA: 85176375522.19.C48F936
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf31.hostedemail.com (Postfix) with ESMTP id D366E20002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:54:19 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LunsX9SQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788533659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YZ+Ou2H8lPx1TAAGkvNkr9pKRWk8vksitXFvIwQOCbY=;
	b=fUCOspI9mNAsgZKbek6YmEyiJPqn7KpgwrNl6PHR7Z1YtzvnTnV1mYxJl8aEIF3oTwTAOX
	2ZG7/tAl8gFYQta3wOdnATXzAFhUIUTlMcTA1CKHqVDiM/erSXdUYPdG+hTd/omSQ2IHBI
	eVjTcmfF+oPcTiC0Yv3d5UvNlhAlHMQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LunsX9SQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788533659;
	b=Cyygrf6Nso5HXjba4NMKd6svRdEdGxLhS2K4Z0RPlkNmHTpdlKmu+UlwH/wy3k+oU9/8yw
	Hg3RQfnWo2gm4ZrtJlVgpFUbatyGR/aaNXq1agZYJbLDVKmttajWAWwess63JaIeHgnlNy
	lsrjPCfv2oof+zT7YQ2wfFwROc6KqbU=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49cd77e0f95so9779025e9.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 07:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788533658; x=1789138458; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YZ+Ou2H8lPx1TAAGkvNkr9pKRWk8vksitXFvIwQOCbY=;
        b=LunsX9SQsp9mnv5KLA+X2UYWQxzVXZEIIxFC5rfv4EQATQnr8iSNN2puSs6GmQOMsa
         Y2Ny/VwgsQumHzoZukgFCnjSj91gPIw41nanF42qCHgO0sbacnTxGMlJZCzMW62NIBL8
         USVEF4XCF1DbDf5hWrm9M7jsEXrSrmNcG387qDD96PjW6ecWVLFYdsE389Mg/GJRGI23
         fPx9Epca0LJneHQlO5veKMAIMkB596dJ53g+asNGpJF8OHw0bPymcOl20bpPWlBvvpto
         xgVUYZUm+ejbyRiMj7XKCluGHyiO0xZE/d/57L9duK2dtk9BmoW4IywiVR9DG4xcpvbq
         owzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788533658; x=1789138458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YZ+Ou2H8lPx1TAAGkvNkr9pKRWk8vksitXFvIwQOCbY=;
        b=Iz177HtjDhlKT1CfgkLFdOiUOHK5pRxNyw/3iKeoYwS7r+VpIIWFD5AYTJ5eCCQBeH
         ck+fSlswQsD0+K0yajC+wM+o4hId0Dol+vBNVWQcHlBNXiXkpnyvMDLhB0Rd54Oj3LuK
         7uQO3K3a2u5H2wT7Wyqpg/lgzwFcQ47tNr1NNEcfbvUpfEB9S5pLZBVH2zcuC3eCEgDo
         D3QPd1/2J7VhJscpl+Ov2zPgYFu4Djwg++jACNTPYf4uoe7rijUuuGXszE0uRBlmvmUa
         ycd2xheA5245R0NfVj7chZL7Qj/E2AhBnlQgqpGhksWNblenNtNEvkKQPkHtI+ipqV0Q
         gw5A==
X-Forwarded-Encrypted: i=1; AKwUvBz4aX76gM9gg7K+QP3CeWNa2ufLecBNd51ouRXESF0UsC6+PbJqupNtzkK5YVKZsidqL71+yOQ2gg==@kvack.org
X-Gm-Message-State: AFuF++l0OpqH6mG9/LzGIhuVxkUgC6D9LQy4fAVPsGiWNh3ZFrnCXCj/
	KT/FEbShLCNSwmXB9Wk/VAfqC6aPfw3Nlo8xRk1jPo7Lo/qpLvmCCfKK
X-Gm-Gg: AYBFou3IFqyiqPlallUTYWp/1IsG4DMM0IXFVcVvAngMIADt/ABDf6Tkx7euKDjJW01
	7BrnGmwjhQmtMpmgHKb8xWNFPak5kb0i06wigOZ4ooD1PMUQjvjaeGwKJQzMeeRlVBWEyjnTGvH
	2TnlDs1aor78P2KDkiOSWtRrJ9ToWozI0QzFdJaUPX9czgLFACaVxwsc0CliWSZzxQfx49zXUZ3
	yXI6sG9Eml4smfWz4k/9SOZYxp2dY2GF6o3p+lLuZxrlwC1QZ84fAerxQIamcy6FQsQffYlQPDM
	6bTmRwvM1IU+DcTfc717ckefDntLOIYJrSJACRSbYDxOz1gBziDNHSW4sc45vK7n0Wu0BfqRr21
	H0kCiCASUYh0RLULl/1giujy0DmjQccVBLF0RTX0oVl47r887ZfWnjmo5cex3sxQI3LiWvNXTGV
	4PhTl2DoxXIdGkQGJ5XUudWxRIvG26j5j1dzobnYC9TmgsVJ25PsloY9ISFixt9cbT9fP1fDGNv
	A==
X-Received: by 2002:a05:600c:310d:b0:49c:dc14:d681 with SMTP id 5b1f17b1804b1-49cf81e5449mr69837005e9.3.1788533658417;
        Fri, 04 Sep 2026 07:54:18 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485885cb03asm6802799f8f.37.2026.09.04.07.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 07:54:17 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 2/7] exec: Clear bprm->mm before dropping its reference
Date: Fri,  4 Sep 2026 17:53:35 +0300
Message-ID: <20260904145340.40212-3-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904145340.40212-1-tasos.papagiannnis@gmail.com>
References: <20260904145340.40212-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: momgbs98fjigkpcxfhbu3fcz4zja3g4n
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D366E20002
X-Rspam-User: 
X-HE-Tag: 1788533659-775989
X-HE-Meta: U2FsdGVkX18p3xDMf5LGt6eQtcyjNuWrNJbQzgTTghbl8PYjNxNwsrbnDBkovLkcR35aQueEEv2+pEctpBd5fV8lzeOJVLENB5rDSFCc4265QhmkCE/VNJ+8J4Ngv6l+/w51JesWLBp8oLU+hW79vHQwq1kI9TAPt8BsHuwEfSVLOUUq5A3tVR51v8vFI6G6GTU5B1Q+qIySRLbf9X+9q0sldpjPwVkGmeVaF2FG8HUkSJswnDdRoAL9agfWSbK4vgWBKZIplFoWi1IN5dzzmBMsgXAd9nEiJQ3AFXdQ26V0HhOq7quMM27T3LhyzD8u8zF8TEsgGUeeXWjW8aFqSccNVOms3/Qpk+cVxTq7L7TU9YX+eckAvorIVZt+qzDXeb121kWdK/XQfRZpoiX8qqUao52uRm48ED7hWYbDEfmIKGyWcOOkA/IX3fuX8eicK15Sn27YqF7ObUJeyI61PbETinox1KTmZ8zxJMjh3GBCzhFPHrlYu83enA0FOO99aBxOyfdjooW8Ne4VvFaATkay2OEKnNUszJjPApqAd0e6IvIw8wlH/psOIz7O8CcRElJ8UKQexeVtmVtEr4TZlPox8djmUX07H5A5kQLNDkpKTXf4zlkAsDXhUxC6qIP5GpPnEQTRyCPI2aI1K8R9e3k0Oa4qkJmbukeLAtI2CTvyOWmMVpzm3XczQgnLzWfzoiHVs6N7lacysY6b3n8Aclqy6OB02Wyc+Y6aOu/ItPGPJZWwLXscMSmN9lMIPVNtjOf/sgzKkgt/xW+oBDVh4GhSZwhY5KXcA1DpV52scwokgDONkgAke0agxLasPJ5i3VSWQfxV8CoHkdBTdd59iMSxk2kkhLnuCwh81hCFZPJPAJ3nv5YmaO2AD9JJ8Tvkt83WzAgb6Xcp50cYFfCNmtm4SgtX8MsaxuSZBGCQaWytxj4U6ovnzs08TkEK9/en2OGFcg9yyE7XNQ544Sf
 o32fVNce
 T7Nke7KJP8zNyMvxmqjyDzeVTJStgPTHXNwwHmHsA4BVswM4DCMnZPizBeH1hqgNJgB2Yl+eCnTTp9wcarooPfmD0kmf6oSESc5bHKVXl8dTCMANZUODfLma56/WHgA8T6+rpwxT4bfy2GkPBwtTlfOZEVMHj3vXm+c2f+CtbJEmLmPBF94yfPbCUqaEssooutHLOcpEGr31zRMfLT4KcCrCw6TYLJm3g6QMABNOalbId+K+BSSpybmHbrf6sHaU0MMVKqw4qs5ST0bmmBE8jJMrrhVjvYb3NIpX6k9ldlezVJupQZS1GUdY+6bBNx8nc6mycxTNpujn2UAZWHuQsEziLKpbeM/Vynxdt494hN88Qz+FNdyNxDz6Lb/YusG1Plg0YHX/PSeC2rNPwZAtoQXc7GKGTMtslAEXiAJkUT3buu1vE5GTuyVuuzNxnzpvLfreSU7yDeftjCP/hf7yP0Ys/gy0M2n4dhY2n/oI6bnq3Ge+Db9/XjiBaZQ==
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


