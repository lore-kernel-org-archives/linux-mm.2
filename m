Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25668E6BF3F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 23:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 681CF6B0088; Fri, 30 Jan 2026 18:01:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 653586B0089; Fri, 30 Jan 2026 18:01:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 580126B008A; Fri, 30 Jan 2026 18:01:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4406A6B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 18:01:06 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14995160505
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 23:01:06 +0000 (UTC)
X-FDA: 84390152532.03.839EB62
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6A99B160015
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 23:01:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W0SpJ8wU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769814064; a=rsa-sha256;
	cv=none;
	b=MxxcstWcdj2+frv4S2SKlCA7eiKRjmNXDRpAU2ZJBnasxp6Uzw8cLj6cCVooYFwS9XUvSD
	Z2c6O642yiDgIKuursORhovX2zw7o5wOnYyDETFdPuTvV/bHTWS9MoBgQ4AHwpQMCKWiNf
	Ntx+H/ByHMGnTPUHO6gvKwBe4H3dPEU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W0SpJ8wU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769814064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=XpzJMKrnIvJPiY74TgzeTlKt0Hvq5aWJIdiYlnsoQHE=;
	b=Fmjjz4yopoAPaLpV+wHtg+UTrSJtL1VbyxbddHbwWevgeNqBDhErEMDYYd5o6iMbsquD5S
	p0d2WMRygQoth8eSuR79PjED9E4dDegDjqFxHhhmLUa3TJlfK2P02doBPcU2vXbobs34n/
	94cGhAjGxgscpNn2iYck7Q09bnDaR5Q=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b8838339fc6so490340466b.0
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769814063; x=1770418863; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XpzJMKrnIvJPiY74TgzeTlKt0Hvq5aWJIdiYlnsoQHE=;
        b=W0SpJ8wU+XxGaIlzkU21AJzVyHhJJGtw3qGKV8Y4ryQTKmWlzI5I4DpvxKbDX0FNS3
         kz5bJCSgXQNglD4+yKRmM4t4N/szit7MmD89SuzXHBtlJQoFs9tZeAL9bQnOx+gajZwA
         MJE60n8/6o6yCFNzopPO+ChrTk2cNmQgFkRQGmGez1/cLxXEwR+U6LW+AvmbkpnvPvYF
         rW6p2uJODdQSsEOH14j6CVEKGLlXdak+myxxCEIaWpChgifkL61pqK7KfL5PHWwwjisn
         AOshplSGpZEDD2odZZVCKBWqOWGAlC/d8jmdUfVYnLeOCQ6qM3RLfQfLwnImD8QF8FuU
         czqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769814063; x=1770418863;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XpzJMKrnIvJPiY74TgzeTlKt0Hvq5aWJIdiYlnsoQHE=;
        b=VzvoElM71/m82YE4hswttkFturpU7byo3ovl86+m+r5N00QURaQ8nM87SO0qiJJ6u+
         6cLzVcy/Ra27CILrTFD+MOG1MU7ZxRB3kuNaBwMlTwUxpi54bYVc6gvzDyy+TP+6TcOS
         augHipsclKHj/TDty5MpHurle4BLUK8dv4GOs1jedytICKJwnJ8zn//3yHPLaVUKG5Lq
         ZDgQrcGZK+UETEVuMpr6MP7DHhetTVCcEymEq57bwKFYOd/JYHDiwiCUR6ClW+FV6n43
         XiZBV6gCZEhn48nse9TH30D8wb8b//SWjjwQtFcQdg2g/tjtCVaiXMzt0SSBnNUcBuUB
         JtVQ==
X-Gm-Message-State: AOJu0Yx2HGuPzNLVOQokvA0H6+OCFz+xwM9EWPm3Ccat/tZIcRClZfNo
	IE7y7fZ9NCuUQu+NmGV1x1zIKYhwV8Gskjd9eCItdKiP9PFQIs0PS2H4
X-Gm-Gg: AZuq6aJmYP1JWxTxmNmRO1vPknzkBLExf1iBMKehdDXSC02aZSlgBUi46UC8aRyWLtY
	thzKm4G69nZBqkDMT00s/kvDH6iWTqIxLssQvkkmi86Jv/naLrH/kPpYLlDXPD9rM/YTIg49Km6
	QYxSSzkq6/sTqQ3DLOh0MfS90YI8cSpl0PC9cWKUxVysj44dV2/8K99C6Jy3MXnSCQczhIcevnv
	x9Dzum+HwC3kxGqVJTsIMtKUQx8moQcjgNuGoKWUyogkCMMoKwZgw+yS2MTsxl3l+cjBcECEcS8
	wf6uQPB1uK1K6UhUuVHGADxfddwAV3+mSaAJbNNPAkc+cnUdizACOUN84ZETekdkohMH4iqkpt2
	rNipUOyJPvq33lFpZbXWwypbQmrYcE7BIKJdfAjdNQifOt5PPd7DjOGPzGsPFhOgMCarGieOMOL
	mxtjb0rL2svg==
X-Received: by 2002:a17:907:2d0e:b0:b88:1e2:ed49 with SMTP id a640c23a62f3a-b8dff22f549mr298811466b.8.1769814062665;
        Fri, 30 Jan 2026 15:01:02 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8e0a5a3b1asm152556866b.57.2026.01.30.15.01.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 30 Jan 2026 15:01:01 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	riel@surriel.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	harry.yoo@oracle.com,
	jannh@google.com,
	gavinguo@igalia.com,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/huge_memory: fix early failure try_to_migrate() when split huge pmd for shared thp
Date: Fri, 30 Jan 2026 23:00:58 +0000
Message-Id: <20260130230058.11471-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6A99B160015
X-Stat-Signature: 34zbri3hmdh7h4ufrfxm5whensfzbecc
X-HE-Tag: 1769814064-333549
X-HE-Meta: U2FsdGVkX1/24kmTwmECBxZyXpARkr1ZIa+87MOMrXUZgGiymJOJKM6h87o2X30EMpZReiZ6lI5zvyxF01b8jIOhbIEnmh8pV2v2vUz6igrRrhxKTSjv/b/3PgmzWKbtWmT0gKqWTIHQvd0CQGNoAon1oufcbaeZNarMeihz9Hza4GzGL2ZwYB/fTNShyZGfYZZ0AY76hh2jR2CP2jsOzo+y8sI4/rpFuCyEeLpDAP06smjCGKTGiETtqwXeLda1gJ3ZmAaAEz05yUQ5ar745/8yx/oF8pMSWO2mSAnLXztHLFpL64P4vOXjFBFUHesfRNWpa2zxFSKvYfaW7ZK1DBBv9axwTFOG5jLj2bGGfb1cU8SWigWVAdYJkwv4bXUcrXp/38MU99WT8RezEZGn5HYxbBrEItV0PvbftexyMQJ98OO1smt4USAlTuE3j8QOJL1jqwhfPkUU0vBQ+MdQ0+r56Bwggvz9YKYfa2k/qQe2iTecrSRT48sLi+6dWx0aWbi3s/o2vgCswbdGvQ5fY+VtzMn4hJG8GTVpM8eKNh0ToCDKTc8F1KyDr+bHgkKjkisPiQBm/Bk7He3jlWLIAw/RtVAfNRoWXFvChnfnWv/Kn0Vrs/aCHBCj5o2h7Kkvt0yil1T/QsYZrJzs7sBT/A39V8ccb+usUFnZvnwyPMelfO6lpWKis/2ESJdQAhvGmIXhHrCkHeGXO7HUYXdknNEccaiMHihRlflwF7GvP8Q32kCz74HMWiu3plKntQcHLlyeIcmIqTWPjihfoLYegUJiibeUKzVsFBTrernYF/M9ndzn6ZZIsT7fS8sPUvbsHbgsrFiWuYeuorgYIof17DGXpcM2vAlSy3v68aLus60Yixx50VdCmCujdtKQmN+yMVszpGyVhFfFbXm1CnShg9GQsGw140BEPvm0tlSIk25gJy9xCY61Wv2EqpVBTw2TaFTjyn5B8pYK5bmGUSA
 jdY1Wunb
 Ny9Pb4OFkMDnJAmUWwsuSuYz3Ridx8IlRPROZQPKRrciA3+9ZK4Qcvgg9UCW72pbEQ/as28iApYdX30wQ0mLrsUO1bb6clkr/rJBt2SUQN7xziSu7pWwCn77x8WE6M66e3190s2muVHYU9D2SM/cb1bBDdqFuB3ykQkkAI/yQI9vl9epgVINYVNQiOUO65+aHwaJ6G/Bn3/9Pw95U3AgOncE7Ymzrd9IqadMU3Ek41R+jybdY+icosM50VtZX0nOPp2VSMsCXVClgLidgk5W/xQ5V6TRUEygU+LiXTi6d2ICd5t1T+do9OpBMrq8+08EIjNziFodHbPnfAv127Sos2LclBI9Hb2IqkdZUK3qJYGrEyGsCxCNPCJzOLBxNv4YRImbHfhWT1cHzoD9u5WUVr0hLHD9kRF/PQe3QD0JAGebShAhQTiXzweQklJNNEfBuZKDyv/u40T6zOWnkNQA5BGN0u8fjUifZ/gOAej6dO0QEoSqGUUuW2Ur87EXyvQXQpxAXpwY6LO2bNYmSzycdRIlglq4zLm7/ZgqrYEnj6HdX7gEUHIgvrc/wK7GQbktWfkrXyuWIpJ1B3O61/Z5d8J1Yh7Es6Sa9v1uWe8YYarI/eXrFyde9sOWWCIC0Roe1buaRO8X/nXjFIE5HU8jyX00of5cGfLvkg3M1yKgyVA4YhSKNIZKy4jefEHf+pJPk2hQllPA5KVZL5gxttlE2yzkWFsA4TlgkE80KODdWgK5IYWUoSetD1HkH83p6kgTjyHYPUMALX43XS8gQJU/TbndfVB8C2+WRra9+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
split_huge_pmd_locked()") return false unconditionally after
split_huge_pmd_locked() which may fail early during try_to_migrate() for
shared thp. This will lead to unexpected folio split failure.

One way to reproduce:

    Create an anonymous thp range and fork 512 children, so we have a
    thp shared mapped in 513 processes. Then trigger folio split with
    /sys/kernel/debug/split_huge_pages debugfs to split the thp folio to
    order 0.

Without the above commit, we can successfully split to order 0.
With the above commit, the folio is still a large folio.

The reason is the above commit return false after split pmd
unconditionally in the first process and break try_to_migrate().

The tricky thing in above reproduce method is current debugfs interface
leverage function split_huge_pages_pid(), which will iterate the whole
pmd range and do folio split on each base page address. This means it
will try 512 times, and each time split one pmd from pmd mapped to pte
mapped thp. If there are less than 512 shared mapped process,
the folio is still split successfully at last. But in real world, we
usually try it for once.

This patch fixes this by removing the unconditional false return after
split_huge_pmd_locked(). Later, we may introduce a true fail early if
split_huge_pmd_locked() does fail.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")
Cc: Gavin Guo <gavinguo@igalia.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
---
 mm/rmap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 618df3385c8b..eed971568d65 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2448,7 +2448,6 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			if (flags & TTU_SPLIT_HUGE_PMD) {
 				split_huge_pmd_locked(vma, pvmw.address,
 						      pvmw.pmd, true);
-				ret = false;
 				page_vma_mapped_walk_done(&pvmw);
 				break;
 			}
-- 
2.34.1


