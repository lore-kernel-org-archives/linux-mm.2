Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0E93C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 22:37:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EB3A6B0005; Sat, 27 Jun 2026 18:37:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39C576B0088; Sat, 27 Jun 2026 18:37:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28CAE6B008A; Sat, 27 Jun 2026 18:37:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 03A3E6B0005
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 18:37:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 789EF1C1E1D
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 22:37:22 +0000 (UTC)
X-FDA: 84927155124.02.4B716B5
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id C5488120002
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 22:37:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="d9R/wUuR";
	spf=pass (imf29.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782599840;
	b=xcf3l7Ya+UCcDpKjiwjD9KsMI3cELqkDqyTD8ZolCBjzV8YiIWWCNB4mOVErWTleUGgPVy
	aJ3YsAfSUtfp3K3M9+Sd7XgqHo7BMvvmFndJ4MINq+WTJU4K7NJFuSOLDySUd4oJdIAe0a
	MhPDCzBg/xb2qX0BxCzP6yz35OzYu1o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782599840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ftHstwGsGNHVySY6WyJrlGTgEX0ZtiUlQfSBunj0DQs=;
	b=iRhRS2TAQwuEdDTdORDOiupUYV1DjPqb9eVLSEOEgmQK3t31FSp42hYwI58svc0E1Tbbw8
	7sNLjERtU6L8b/wzQ/FFPsru1Q9P1V1zJVPPA6s59bJPsRL5Vwqa/CYbimgUVqF4DJatsH
	qq+/RXFJXbcFfmM0O5AiFA7sbjK3ppw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="d9R/wUuR";
	spf=pass (imf29.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4629051c9d1so1092545f8f.2
        for <linux-mm@kvack.org>; Sat, 27 Jun 2026 15:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782599839; x=1783204639; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ftHstwGsGNHVySY6WyJrlGTgEX0ZtiUlQfSBunj0DQs=;
        b=d9R/wUuRsThi30LfyWHvKR32BBhUe6UFPtNV7GQQDxFb7deC26DGa5HlenFzVXcuwn
         jbcOrsk9bhe00AiQGjc5pPgK1NbA3XTSVyTYY9WK7fdNLeOHmPNhCsha209HGtbahy/f
         MTkUV+bEJ7ZQSvGSW/wUnMzHathnOrqLpWoqu8D7t5ATLyMbi3jiEk1SvcfX6vj/kjiW
         bbYQD3XhLq+bR4sLf8bHXNNl6vTB2UuCuzt+Cyx9Y9+Z/oI7vuXr8rZis2yZum4WsDEk
         IuF1i9joou61+AZErSgb9XZJftwm0Zv7QxGaZHXCHV9ql52dyZeUE1stP3pu2tkmuQgv
         K1vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782599839; x=1783204639;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ftHstwGsGNHVySY6WyJrlGTgEX0ZtiUlQfSBunj0DQs=;
        b=LYeobHf/UwnH35OAAd8daSiu8wk/CwVQgkJMwmGhaWFAie7aEpWY2Tv5ux0+KPka2o
         +0tYyVwsyqJ7HsLmMfi3tToAO+FQZRkhu2yxrzn1n9lyFnvcci79eiKr9wx41m5wm8gl
         Lgbl7B0Tc8CX6d9xtQm01IaTi8xeFfpiPiK79Nb42xDKccn7x59ZOPbapLsFZbjvy6/2
         9p/4J6SIYS0oK+XJkKH97iApFAbHQG1DJSgceBtjDAq7RJUmyXIUCc8cO6/GZcIrH+qY
         VwAPDOkge4flZa/gj8WuPGkcXGFlkc2BDpyvzO4L3tG4Mo+lUnBaaZ+3C+TD23uj6P6v
         d1Pg==
X-Forwarded-Encrypted: i=1; AHgh+RqUwudEOu1S5rDk0TU87dZLvyUke9d0AJIBp6pOqWslSylwUOW4UG8Q3N47MVdtiXRj/FzOSxtMcQ==@kvack.org
X-Gm-Message-State: AOJu0YwnD+1Qcr4nF1ivHWwe9ssYQu7tYD4V16dCs4Ch+waENVTKjYNY
	rozP7DqM367tv3cgeCh3GBJTyKX6hCUWX+QT/VH7GjlVUy1b/lgq/TFM
X-Gm-Gg: AfdE7cmKcPcTl1WCoSEhlCK1KePVJw6Afl2WDLH3251/KkHWN5iWIxYWu0aHgqFECEQ
	zcijZijPnfPeXQFCrsgLORzKrbVjY1slOXGFVzWGYRImbYNX6bFJCkyyD/HwP3d9niAd323ER25
	VlxM2QYYlsDeRA/WQKY51pwNfffC9r8yON5VaZc6hMkSp6K+Bpb3Rr6IRxhhLRSla+T6yN38mEx
	c2LF7b4iVwMpevKhn4eweO6TqQYyR/wkDXg94LnZy4IodtmCMC8HicROcbIXMtxDmXsCbKYPodq
	uuedFxXnoRHzZa0lgQQkfUQoKIYgQOYIbsmeZOSma2f+9VO3Xwmlt/7wigC0O8PbMMLufSAYQnR
	SbGwr2etlHVfh1LI7bTGeoGipQDS1Nj0BNc5CelRyrUJUD32ct0fhc5dZlatpo9NVFur1ozB2Ed
	QHzdHbM6HJys4=
X-Received: by 2002:a05:6000:2203:b0:470:2fb1:3dca with SMTP id ffacd0b85a97d-4702fb13e80mr6329910f8f.30.1782599839120;
        Sat, 27 Jun 2026 15:37:19 -0700 (PDT)
Received: from user ([104.28.155.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c1ee018e8sm40869097f8f.11.2026.06.27.15.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2026 15:37:18 -0700 (PDT)
From: yahia <yahia.a.abdrabou@gmail.com>
To: hughd@google.com
Cc: baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	yahia ahmed <yahia.a.abdrabou@gmail.com>,
	syzbot+76cc716982cf0254f302@syzkaller.appspotmail.com
Subject: [PATCH] mm/shmem: Fix data-race in shmem_fault
Date: Sun, 28 Jun 2026 01:36:56 +0300
Message-ID: <20260627223656.181988-1-yahia.a.abdrabou@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yf3z8hyp7ztfn5htprrtjdneibf84rx1
X-Rspam-User: 
X-Rspamd-Queue-Id: C5488120002
X-Rspamd-Server: rspam02
X-HE-Tag: 1782599840-742042
X-HE-Meta: U2FsdGVkX1/PzYmLZ9LRe3oo3GYrU03Cpkvw1bdh2VyjhX2YllSdaoKERcPib8tA3K3UdV1xbHYZU/bZ6Y4XvNZITzwILVnpgNa+K5F0KxnOp8aIODlrbTTQh5niMGv6dnw3n2ZzLMJV3eBOX6bqQm/Zi/eQZqcj8aIHKrnlaTo0LW0sd1aMDDi428BXljYR338owrKD+9MuhddZUfju5AxDtjxskDfxdzw3UjcdJnmCoW4eBJsCL2lxYwisXpvBYIRUk0tmjUUyZhqkMb+NrBCfnf/qBG+xKulPz7X/6dD7/pPEEWaZwu9aeM9+YeAG/FlCG/LrPcsJ6+w4zpblqRFFeHlNhfynucI1sHTwKubsox5UBKckwREhaHuAmxrM7q365FyCsL5d7hEcq4g/yhsYMyE6Us8SYoPkDduq1HqNQzwxBOuteLhYwdf2IzIop2R+K866Gao5B0RNjPE1foAxKv9JCCB4xQ/l1pMphsuQZa7AORFeZWbt4AouaL3ZowA8DkQ29u2uTkrK1/qyqFNNbAKOSXDDmdGrT7WUCaKA7oftaWMka/BVF3iQ9i7B/bSi2Y/Q//QIhAsQMSXJwEEuw0U5jnsVGhfxfL+GL13Syq6QgCBYFJfQ0m6JhIV6OFgAcYuhkR849rTLisXk6gMH54WFoIedYF/qq34fBFT3s71BaI+KShvjDxsH1ub4/8+VnfsMRjhsuoDSXvqKAkDOn/n/OyIXERVUSYi1g7xS+U2rZ6vVPHWRiH31007wDJqBkqBneLo6UGHpqPi2Rfdwpw5sp+OQ9yf/dPTmtgi3UvRX79Rlme/Qm3qANbBeG/2LC8o4NX/f2KiX6i9MEWShMWOCvQlbho5QAxx1+Z6+wbUVh/N+nwnbAppQjNytyk76OU+1pHg9M5CcKyCZmK2t+5XjdCEsqkg+h58XJSc7dZHtOE8rpkxF5TILkq1srq1yYKLn1abhpyP+CpV
 8xlvepV6
 lckQoWw0yjqsEeq5X1XRYeJApda+zoo+zOTzSpWmSeS3apYt4RDiyMCxTEK3jpuWQi66AklGvQPKcInKZVKcC17d/oe7ZQkBhI4GGu/uNd6ko2mNi+2hjN5cr2nr4rAreJoexgm+LoZvoIbtMXVMqJ6piWfggcibSbvPDI2WTil3Sy0Lq9xmy3ctnPAN01qYnIzVIPQCEwwUZMo7hx5DVkAnHbPqXnRcGb5o+tm3vSKgE96SfLxUQuJ6isFX+QWlYgqggaJPBAW4f1ugKhemRmS94tVB+04px7B2eHztLHJWM0RBO9YP24agQ52Jx2THOU2qWKc9hQ6Ii1ke7n2YaRRQd4//njNgaqaIDssB7EhLBdTixe/kvf26hmZ6hwuFF2LaOOuQj9098a2TWFfHGJIqM0/rjigyCrjUQvDGm5s9lH3J1Ko73q/v8XpVhxXvDTvp49kNzVXwfwvR2BYEfpGYATr1o5X0UNSuD1UsyOEu7WhIHu5byfP7FYHHtWRCjJh9pU9njCPkjoLDikFcfAW4itq1IoyFSCX4CDp5Ep4tO6fQxPpA4ZOSveCAqRsa6QnVjbdesY0f8sUlpjdCNf88TbycWYht/eDI9nkV9YekeTnbq54UD0ZOO8yM8uYkYrIwj5+0FWXLfqD8gzS6wsiX4wkhkP6cJDc4QZnNfYzwFFD32Df2WJJjKOh5/oTNP/Q6oyynskkzShD5V/QjdaIiuWKVdXUit+jpF0gTh1Pp9BKuENBd3a3c35Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: yahia ahmed <yahia.a.abdrabou@gmail.com>

shmem_fault accesses inode->i_private without
holding a lock, while shmem_fallocate is modifying
it while holding a lock, thus a data-race is created.

Fix this by using READ_ONCE, which provides an atomic
lockless read of inode->i_private which prevents compiler
optimizations such as caching registers. which is safe
because subsequent call to shmem_falloc_wait revalidates
the lock.

Reported-by: syzbot+76cc716982cf0254f302@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=76cc716982cf0254f302
Signed-off-by: yahia ahmed <yahia.a.abdrabou@gmail.com>
---
 mm/shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b51f83c970bb..97b3913144ad 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2693,7 +2693,7 @@ static vm_fault_t shmem_fault(struct vm_fault *vmf)
 	 * Trinity finds that probing a hole which tmpfs is punching can
 	 * prevent the hole-punch from ever completing: noted in i_private.
 	 */
-	if (unlikely(inode->i_private)) {
+	if (unlikely(READ_ONCE(inode->i_private))) {
 		ret = shmem_falloc_wait(vmf, inode);
 		if (ret)
 			return ret;
-- 
2.54.0


