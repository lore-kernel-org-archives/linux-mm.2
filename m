Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 451BCC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:20:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 275176B0005; Wed,  8 Jul 2026 07:20:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 226076B0088; Wed,  8 Jul 2026 07:20:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13BDC6B008A; Wed,  8 Jul 2026 07:20:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E313F6B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:20:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69FEA90D53
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:20:19 +0000 (UTC)
X-FDA: 84965365758.25.FE7CC8F
Received: from mail-wm2-f1.google.com (mail-wm2-f1.google.com [74.125.225.129])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9DEB420004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:20:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IbZ3tJCS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.225.129 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783509617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TPkv3My45SxpjKsyVQCvC4w0harFXVp1zLBC8ihZ35k=;
	b=Mzi7lSeHT/GWJLj+zvhXjbYEQOW2/tcFfyAIRvjEpd1+e1QxoDhFi7n/yGl6J68OxqVRsT
	9fo69LPEK58+xDOOIAAot5sp/Q4pKXQLcH7zqfFr38KtnShIsmOzk9byzYoQproS+I6QOy
	9J135GdB9oglnC5qM4VkE7KotyQlvGE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IbZ3tJCS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.225.129 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783509617;
	b=TdkU46xi3yHgfUHVKGSOQARH6QE4H9WU2PmBGcfCztytvclnasc8PBe96XidK7431X+rGC
	kpKdIFhaNysf1HK9x76EZzaOvl4BjSDu8DgfD5GSVpstJh657B/GddXcm/I9W+t0XsSrRF
	e6KNiMY17W2aaPJaM1sn8iX6ef07MFo=
Received: by mail-wm2-f1.google.com with SMTP id 5b1f17b1804b1-492367f3094so1751455e9.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 04:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783509616; x=1784114416; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TPkv3My45SxpjKsyVQCvC4w0harFXVp1zLBC8ihZ35k=;
        b=IbZ3tJCSJNU/H4tne6Z9x0oa522AYoYyaWgdt8C5xQO/EAKIc2JUw6awh6RQ0/PTN8
         2VKOjFTAdez2SpnNh5nItZEAuYfjwpzsc/A2tvd1UaLyu/SwXP05pSL16tFoOzwgm23y
         2MQA0pn8nPn3Qqr2a2HwodmgfRINzSF/iGaPhNybpgt863FGqcfMmUf6yV8demI45D3y
         k8GgZLDaK5xG8au6DOHewTdzKKW6G7hbXaQ79+w15irzUmwN+l6BoA64lY1hJ5bN/LYt
         rjEpFpRMePuSnyqqDHdMtuVV9TftEPvgSyBz34NTEFdrYf6FkvTH9EsMzTd9MOkCbyXo
         iQNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783509616; x=1784114416;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TPkv3My45SxpjKsyVQCvC4w0harFXVp1zLBC8ihZ35k=;
        b=SxBmylFdhzrt53ITxfZRskq4TMcltudUuZiqNJHquA/l5/JxJKUlR94an1kjX+QEtY
         nMNYTclckURgEvsfZiFvUnNoCSfmiEMjuMgHLj49+w5QXyTnsoJlM/V/vbtaCyBmCWI+
         QgxqlqvNjmihffM5YXFbsznJhoOV2XJupGo7/FsZRLr3lIlL5HPzGQw7706KqyJkUs4/
         jF0Wwp0tRk+yX9Z7adQECRRcgvbwMuHeyzFoycBHcGMeDxldZmTK+I5KzULtQedUgf9z
         mmtpt0+n3ANjJ8qBRCD0ckkyb4Rb/2fP5GSrdXG88XyhEhQxaMB8MuxpyLD3+t6HiSCU
         aN5A==
X-Forwarded-Encrypted: i=1; AHgh+RqnNc+nZWu07H1P9tcGygxi+q1AoEgactKZNehI5F7M6RRlRGLhxsmjYXERdLjwl5nrq9r4h4QqYw==@kvack.org
X-Gm-Message-State: AOJu0YyL8OTf9wIzXne/iyLV7SCjUIaeyKSOIf7xh9AmMp46e5eKtenS
	twfIy5rpy7kAKaPRv3jucSw8GZSEMnnMjz8s03w+laCvgGyF1bt0UW1E
X-Gm-Gg: AfdE7cmkHTS7kdbmiB+OIyrH5ZkpRswweBPRFjZTpVcXEAedTqV4jtFw/pyJFsjovkM
	ChMTHzvCUXKYlfcumsDC4AF/dOxOZIaQy9rRi+IlpdfDVBZW0gjYxWXSdXEF7utZ9FtFymyM1tG
	dQJhLviQDmmVnsLZR2G0IPwzDjgcod5KxfU6UsXdgfV1SOCCzMXq1CAGGDTJxkhhxKKVmp2ferX
	2W17O04eUhReFADAgC86PZldOg3ITiBQHUPj1AhYFBuBns1aHkeiMQxHtvrk4SlhptLu8wYgwMd
	JvpzRsJYg2NxCPamTUDJzfFcDL0zIzEzWw5ynJdnKEB6u+2849rMRLRzBGXohyyttriTTP04k0R
	4SbefJ8gviXr049n+S2nd0epWbGswNrwV1+4lpp3bArisP1dvCsjXVQ8rC7O2dY4XX/IUmKtDyL
	mH/+qyiQNB9T/DWRPsKo+Jpzh98Or5auG8dtXzOKwZqwg6SLj6Kf1L+Y3gzYzAb9kY8/2g2CGTV
	Nx6Vn4PqOCm4MqYVh3UKpm07PWnj1m0WJOaMUKN
X-Received: by 2002:a05:600c:8288:b0:492:4e09:9fc1 with SMTP id 5b1f17b1804b1-493e68a50c4mr22022485e9.15.1783509615875;
        Wed, 08 Jul 2026 04:20:15 -0700 (PDT)
Received: from lima-kernel.. (e237-117.eduroam.tuwien.ac.at. [128.130.237.117])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0faed92sm122363945e9.9.2026.07.08.04.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 04:20:15 -0700 (PDT)
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
To: akpm@linux-foundation.org,
	hughd@google.com
Cc: baolin.wang@linux.alibaba.com,
	elver@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>,
	syzbot+dfb578404df369f6599b@syzkaller.appspotmail.com
Subject: [PATCH] mm/shmem: annotate benign data-race in shmem_getattr()
Date: Wed,  8 Jul 2026 13:19:41 +0200
Message-ID: <20260708111941.35460-1-jaeyeon.lee.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qpk48yn8b15p339fu59zy4hpzm9iti59
X-Rspamd-Queue-Id: 9DEB420004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783509617-295597
X-HE-Meta: U2FsdGVkX183/tX4Vg87NxvrUf7VIRbftudmz3xkIosNkTXbcYxjdwRQHnGOv7dVmizeQ0eMCY2bT/jRb8x0h/OzbMxv3Xcvs6S/2vyPCSn83QKyy3J9KOJ72YcclJaUTFQ/xyjZ79F/Bio/NVIPqzROVz/y0eU/+XsvSh9eBodIwqtoXlkhYD4jjalZNfC5xmvYpexJMRwhfXmkBtgYfG4Pob9Nds0Hcitw/+mHjKGQbP472pVuI2mOukyFrbDRuPynQZ6wGUmnoaZ4Y1dSDkgzkzZg+S2z2UZ27pLMyw/ldwYTY7TOHjjJCp4Hor81TygZX7SvhX4yRw2U88S758aE2kS7dsU6jXIh2gVCBfiINA3NL8GBibow2he1ImSvzSavLH7gUudy3TAO0rHFl7G+2SbnuLR9swT30moo4MYIiwBXaxe05gba74IaIHFG/vHu5ef6ic+chX7awwhgBWzWA/QEbgmeQpmBZ6P93N0p3bfMB49cYccttT/rDRE7JRjRzkUD7Mi2tlyUvSqOB6ShmfKF316Uza3P9MFmwAGhcZ5rR5Vbf5jIhQwwg9ApxR8PY1x4FND/k9FaM1ulYXh+ZwCkfmuX6OIyUm6ctlLuhVtaRAFSEI7I8mc77DplrRmq16WMUKPJ5mS9qBx8FGZdL1FAKGV7Iaa7zbi4NzK3z5rh63GMXTc4AMY2+9EG+oMbcWCfm+t477wxFWUFiyhqw1MelWnd+1q/qQErPvTD5NGXMOUAs3agKAazSTwDmz0+jORqOmsVyirhcwWf3obSqMlqDc/mf6p6GKzHCBohZg9fhBrlTWu/MYv21GJpidXfOszQrtJJuLdKltooX7t3R6Ch23EFcC82r5gtn/Kfh6IrqObrRskF0ooN1+aU5aOEd/4aAC2wPgW6Zo/k9FXe+mXyMagHV7VJdKWwiGTFoXpqsrz5UCPSoQWT/kwf8hHvXJf1RD917URaLT8
 2bUfN0zM
 PW6dIV3oED9EkDcO6ghCuFyHa94cuq5YwQSbyajXw5hH9SBS3pkbFfM+J7Xcm/N78CNx4KOXAtPTkr7Td2pCoraMnUvxk8wF8apgIVprl9vNB6fXBReb8k0qc2q44iQ2P2nPqQM/Vsb+mZ3+pQbpLH4L6+/eGYPjIfYPzF2nCw/BKtws2/OcP+rIlTCFLhSUiR/Y//OKsSK/aHybrjsV8rS+8mSq1FMjBFE8O4zj/QLNTgKKKIy8OQpVcufLwmEGlnv10iEaxCoN9Q8tDeR5J3OYK4/0pGV1Th/nadEkBILAsHZQz0aAS1n0yC8SLZ07ubhTQOR7X7xA7BOblm7AyHJoGxUP/JYj9LOQlMx3gyMolkOjD2GvN+q+3svqgGYsODdiGICaahhswwMwmR+OLqRE6ftOAvKWsHJxHWajd/e8tZ4+27fTR4ZtwMLl3Y4/voo2Ej9NdoXjKEtcTRZ0UyzxcpZvnZHyvzOdoxQlmAidzoYSqHSjd3Y+6Ng58tdDZ6DuXnPti9520nXjS7C6STUfLic2YZTz2xumcqQ8eXzSoRhzsr0fiMBWda4Ypq/4cp1TYkzzTXNqibC6akTfpUGiN0zPYI7yHjdkHgPtEzy3WAzYqSzXuz5tj9j5TvUQNQgO4vw+xyCJ7QnSoCfjqSe0StV+4pIbj1MzNA+2v82PA0urRbfEf4fQkBTXskDmebLZldFiNRtvCboM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shmem_getattr() reads info->alloced, info->swapped and
i_mapping->nrpages without info->lock to decide whether
shmem_recalc_inode() should be called. shmem_recalc_inode()
recomputes these under info->lock, so a stale read here only
affects whether shmem_recalc_inode() runs.

Annotate data_race() to silence KCSAN.

Reported-by: syzbot+dfb578404df369f6599b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=dfb578404df369f6599b
Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
---
 mm/shmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 0ea74fa84f25..3fb6dbbfa20b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1287,7 +1287,8 @@ static int shmem_getattr(struct mnt_idmap *idmap,
 	struct inode *inode = path->dentry->d_inode;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 
-	if (info->alloced - info->swapped != inode->i_mapping->nrpages)
+	/* Fast-path hint; recalc under info->lock corrects any stale read. */
+	if (data_race(info->alloced - info->swapped != inode->i_mapping->nrpages))
 		shmem_recalc_inode(inode, 0, 0);
 
 	if (info->fsflags & FS_APPEND_FL)
-- 
2.43.0


