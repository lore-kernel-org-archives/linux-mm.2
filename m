Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36121E6FE51
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 23:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 676B86B0005; Tue, 23 Dec 2025 18:11:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 623536B0089; Tue, 23 Dec 2025 18:11:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 530E96B008A; Tue, 23 Dec 2025 18:11:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E8726B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 18:11:01 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C52691403EC
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 23:11:00 +0000 (UTC)
X-FDA: 84252283080.30.EA5E590
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0C2DF8000B
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 23:10:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gnUyhTEn;
	spf=pass (imf30.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=klourencodev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766531459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Rke/w1+oY/WAEber1QpL2TXFwGsVEPZM8zD6/y1cmFM=;
	b=glXnLURI6+wkjmKMAwDqoiJvH7MEDHqA5y3mg40azAZfDYGXRjQk/2V6Zq1WCQMglE8ONb
	munnEIpliKDU28hbMvOaZ0ba58mUknXmFIyKe9WNXQD/GrxBbzplzQqqXK4RGnXTbo+ZEb
	Hw2vs6phXCgJ64VnDjV0I5RKW740p/U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gnUyhTEn;
	spf=pass (imf30.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=klourencodev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766531459; a=rsa-sha256;
	cv=none;
	b=t7g0APbvnFn5K56D/4MHrfEzZKGUUCVvTmcYMEs8DtoGs4Ji5Kh1tdkW9YXHJTZwsv96X/
	L7bL6y5J3DEUe1GcsOwdIemW42jt3ltwntUMUllrgCdP6N6/9nGn0K6THnQHFJlCobEteG
	oIuBsQCKUjWUI4pUww/nIDicBUUKsOY=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-477b198f4bcso35749665e9.3
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 15:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766531457; x=1767136257; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Rke/w1+oY/WAEber1QpL2TXFwGsVEPZM8zD6/y1cmFM=;
        b=gnUyhTEn6/8IZIgGvD7eXHMiuYkD78eNytUTcPhKOL+1cOa+HwWOZsSE1Wq3UbIswb
         h8hHVek5DLAtBsSVRY90npzJV0uXeRm3PMLACkIphlYNM0zbBTbltVbdS6NSUQGxbfc2
         8D2K+QezKbEWb91AgL7FVGVitkE+CVS9X/QZ0c5fIoEePYYeKB2/v0I1rwQyvchRhpVy
         WabBEG2CAXYfYrGsebPRpm1rkQZDMD6PdiZLeiz54+rzX7ryeL3U7P17vZRtFs9QLRv/
         EuGT9ABruc6asgl4xJTSjgU1aaEe1t2vRBUl52FZurAj1hoS3m/9L8QdIf416gIU1pKE
         Zglg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766531457; x=1767136257;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rke/w1+oY/WAEber1QpL2TXFwGsVEPZM8zD6/y1cmFM=;
        b=lAeqFagk+pzGRJrxdr2p9Cj9SHcvOaheMQhfhbbC7vH0ixphz1LEPANAl1pB/AsV2n
         hQRmL0e8Oz77svuKueOiiyNtOaQ6GdRem23WQZBEU4bNRTK1V8IE8T1i9+1IOPGlrJ2p
         l8qneZwxzGu0pjgyK7lpCHlpkrggRUuw+g3EI5BDVXIpdqfWzK1NhZK0sJM3m//aQ2PB
         qSBiE0nNjc+Cod/kGLrlfuX+qfF/BCjZ+otHFRzkTwSks8CdShFrzV+j1wKMyS+TxgoZ
         WQ6nzemEZvswpY2IEmDlet1hrUqF167w8Np5f2I1NyuVul8nQpjs50iBbAeqTnllNnKn
         /8Pg==
X-Gm-Message-State: AOJu0YxyeMa28aY/1P3i0UF/GeXOBm8fBCpcJOQtVceSI/3ifw1M1bDB
	4r6RVZvOdT1tnXdrhOjVasu7IJK6AfM8N9SfZyWc6oxSdii6Mhq0SXrc1De8AQ==
X-Gm-Gg: AY/fxX5CUo4GKm0z5IlPG1o+0E7t6ESV1uSS83AMHbaQW8SYBmY6OeW29BptM4yApr+
	jbgfwP4AWlmO0gujYO8FtU58rDIIw6r8q1tGb0RLw2qX/1+7l9lhpO93VRhsiWAgN6kZVrfle6U
	hbIiWRmLwpA8tkFEiNXmqu5715yx8o3LNGqLGMMWPgufqFZM4spMpcRk5haM77PKi/KHl6P3vGh
	X0X6ER+ouVXzOIgnmEe4uqGvjtC9VZwrjUM2ejf+q9M9rJo7QWITVvqpP/M3gn0sMupzVSUnUJc
	LmC72OCuxJm4/eEpxJgVcfrP8+UaJLhyBHZ4vH7E/LRPteqcHR0WiESy6Xfk0RZ1+TG8OnWSzlQ
	PK4nlLRyJqsi4bUVdlgBWsH7sQaeMbbj8AfUyYlJDUH/rBSGrEHW4E1UdnqpMCGYmr2ADz+y0y3
	YsSgmcaB6E+Qid6Kd9cEMC8cwqWVWW/seaWiqShqYIrygwcq4vZrvbuH3UpavOtUBFAdWNdx6rQ
	xka+n+gJ8S+GCrj6g==
X-Google-Smtp-Source: AGHT+IFqM5ZolQ9sgXk3Kh0/+7fWNmQoGF3i4FyCrKo7u5QSQgnUc91+rhutW9XuQFQ0SN0XwCAlzA==
X-Received: by 2002:a05:600c:c494:b0:47b:d914:98a7 with SMTP id 5b1f17b1804b1-47d19582a05mr140590215e9.29.1766531457002;
        Tue, 23 Dec 2025 15:10:57 -0800 (PST)
Received: from desktop-mu90jgd.home (2a01cb0006769b001185461c960a9b50.ipv6.abo.wanadoo.fr. [2a01:cb00:676:9b00:1185:461c:960a:9b50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eab2c4fsm30828557f8f.42.2025.12.23.15.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 15:10:56 -0800 (PST)
From: klourencodev@gmail.com
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	vbabka@suse.cz,
	Kevin Lourenco <klourencodev@gmail.com>
Subject: [PATCH] mm/mempool.c: set @elems slots to NULL once freed
Date: Wed, 24 Dec 2025 00:10:54 +0100
Message-ID: <20251223231054.16061-1-klourencodev@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0C2DF8000B
X-Stat-Signature: ixycx3mpjjoioouubxdikqszbqehbobo
X-Rspam-User: 
X-HE-Tag: 1766531458-10400
X-HE-Meta: U2FsdGVkX1+JxANf2FST+qwJOwFMaWCOxNtNIMvKFq4q43QFS0nC02dM9keKt8xIQzOtSvg19hpOzZegnaHF46J4BqHrL7KneF9XfL253BuulFQx4ccmgt1deyXqeY8vYtiWRgr2sERVZje4a6tYIIrYtU+GBOiKPuEmHyaDxA00+lcHUn+cC4rSa1shnELEKbGxTECSW3mENLxr9itRpKb1NE77w0+wJdT+o+BecBleSFRDikvjWbHOuV84wprTsLEN2G8tZ5EO3ZmzZvDHTQ7LvrQg3BHhDTkqNNwbNwIBtRqZFyP7p0N6kvO2QplQaNVC+bcdd0UdA9HPw5GWiiYujxMecMab8s29zE7Vd1Mg6ugTa4G9HFne/WBHGvI5uxvZfdSwWDsKzf40i++o+QJTmVOjRLBcW33D8/Rcm2GWZok4R8JXJCM/dRn7usieeMxlbFi+zjoeFue+eio1b3B3oJoZB7UIfsIdGVwZ48HDDSoTk8DCSas17Wc+aLwLwh5pH788slwk1z8EqMxN19082wW/wXqNNSwMexkoHfXN+B+nN7PJoov+s6wzNFcE9spQh5yrHEx0LEAYJAHMm4snM84S+tQz23NwiYe6HqxxrL122whR8yABJxCSe8oXognYea8/P6snI9KFk9vtodOVzoEKyPko/ah2f+D9PY56DwwcVxAaWBXchKAsxWMnli9XAK/OB4gEXfAMLpOvMdDGeASsgPimjaZYcAQZCF2u+cUqGdIcghjnrsKZW7KKfE1M8pUtRgpcmsajwSLEy9wEiDO0EXrSvQKxnrwHPl7XlTXTJUhi1KK1XUdLzDv42qao5MLWiR8ehyOl0+tIr47s8olKCbvPo33Er5F6JqH8p0pGf4z54ctm4WK/CgO97D11L5sD85KrL3RjWQOxcGvrwe/quSGJzUYsnh5USi6emeu60IDZaYRQ3QUcMmXDBkWrNfj1nQDBlU24RmA
 orRuWDzd
 kLTHivamstpHZsOtBtw2cK7qJWYL70hfemmPZSGa3OZ0Uc2g7XgBXeBaKcjTRwIz0ihw3up2wX4Vb1jbDlapMZD4/9h3WjYwzrsYmAkAkK46M2bAwJy78G0odcVj/YDpoyCTPntkQCjBzUTnI1JlDGadBTiJK0pGp8LwT1mi2rtm/ywhdGEtAdaftVoXJ5niuhzOPlQlVRT4wYQEmQVhnUPwkquKc2PTqGEzqaJ52Sm2lWRjoVzVE+0HizaM75MJJfZNNwCgI46mAuaxsD4p4tfhGCijycwWl0UL8Ongpv84ZPMmWpBc8+eNpxvbm1fFwiskDIZQC/tz4PU1AhHywDCcPo5qU30gnOGseNUc/aTvSldAsh4fn7utIBYP7ml6taS4jLb8+b/KiSB3X7jsuGWX4AL3v+Okq2/n/Ic0Z2iy8g67O692zjTpxFfJSd989wH071x5wnPASWWo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kevin Lourenco <klourencodev@gmail.com>

This is documented in the function comment as "...and sets their
slots in @elems to NULL.", but it was not followed.

We need to follow the NULL assignment, because elements newly returned
to the pool must not be touched under any circumstances by the user.

Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>
---
 mm/mempool.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index c290e5261b47..1a2060304fd4 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -674,7 +674,8 @@ unsigned int mempool_free_bulk(struct mempool *pool, void **elems,
 	if (unlikely(READ_ONCE(pool->curr_nr) < pool->min_nr)) {
 		spin_lock_irqsave(&pool->lock, flags);
 		while (pool->curr_nr < pool->min_nr && freed < count) {
-			add_element(pool, elems[freed++]);
+			add_element(pool, elems[freed]);
+			elems[freed++] = NULL;
 			added = true;
 		}
 		spin_unlock_irqrestore(&pool->lock, flags);
@@ -683,7 +684,8 @@ unsigned int mempool_free_bulk(struct mempool *pool, void **elems,
 		/* Handle the min_nr = 0 edge case: */
 		spin_lock_irqsave(&pool->lock, flags);
 		if (likely(pool->curr_nr == 0)) {
-			add_element(pool, elems[freed++]);
+			add_element(pool, elems[freed]);
+			elems[freed++] = NULL;
 			added = true;
 		}
 		spin_unlock_irqrestore(&pool->lock, flags);
-- 
2.47.3


