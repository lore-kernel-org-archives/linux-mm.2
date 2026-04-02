Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D844CC6B03
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 06:14:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 532F96B0088; Thu,  2 Apr 2026 02:14:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50AAB6B0089; Thu,  2 Apr 2026 02:14:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 447F86B008A; Thu,  2 Apr 2026 02:14:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 364C86B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:14:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 702EA1404B6
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:14:15 +0000 (UTC)
X-FDA: 84612600870.02.66CA0B3
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 99F2AC0002
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:14:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DAJYgNsj;
	spf=pass (imf22.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775110453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7XA9auQdQyCrvAgPefJTXScmZp4GU2aYW4S5DL3KDZo=;
	b=sntBdPSSEi1p9OcsGPcO5d/kbOs8AJ+1BXl4dGfcEPWkJPf5uhYCaE29p1QYxtyK2aD0Ei
	vyeQZ9R736JBBQncReM2QIgHAA16B9ytk2+2rtKIwBJI6z79NVNqx8PLaJSOBQmNTs5IDS
	gpDHKL3haxWa6OUOCQ0KfVwsxi61m1I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DAJYgNsj;
	spf=pass (imf22.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775110453; a=rsa-sha256;
	cv=none;
	b=X9XQfjsMSHvOR8rI0ol4CGMRDygj0nAZ6aHypP7y2IBRVSLKC2Z71mdAzr4bAwhCHJjfd6
	Zoo0wD56Gn1/rlOaHAY2nPedR8Bu8QyBFjLLrF2gBHZmAiIpqLcs4IZh/J80qZGpljhlVy
	NECkLvRy8nvQEjO43Kj1b67H/4tMOt4=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-486b96760easo5020045e9.2
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 23:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775110452; x=1775715252; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7XA9auQdQyCrvAgPefJTXScmZp4GU2aYW4S5DL3KDZo=;
        b=DAJYgNsjs7aio7g+au1xx0OFhSRp1fqh/sndVht2wa8YuCKz6l173V9AsfqxQZQfIK
         LhL92RUWbCu6SSqS6hyNp1TQ5k0hRuDMqFPL0B/RCUpQ3orkToBlB3gpeEXJPpmYm03h
         hxtHH53d+LthRRF5QY89MSRBIaTKzCuY9dEQBh8qBeHqRIPF4XeQpa6Bh1MJHNRWzNqS
         VUUQhgFFqwP5Q7yn8siNIRsrt3+cIWlS0YrsQIzQBuKvAbrFiNjCLHRkw3u/ibKXSqEg
         hqUatuMGXMqUnk73ABqkRwzSneCsTLywzXWNyzmJFyiJcb8sJvkaVbbFpckADQPJDDXY
         r+KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775110452; x=1775715252;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7XA9auQdQyCrvAgPefJTXScmZp4GU2aYW4S5DL3KDZo=;
        b=mqn2Lwrc39z1Av637hzwzv1fH2t4Mncmyz30QdNHrf9h+rWPOsdZ3ySas2L6cZcKP/
         PSyt1RfMupxnoo105ZQrDM23q5ij//BUENYCRc1mGDCbimqvEYkwX6dKHBG2GBHH3LGt
         ZJN8Wpp0H37BSVTNOxsahDaND3kHJo1cEWo4QvMvuhmCkYwokQr4umWPx1rAoDrD2pwk
         zLV9xPxkzu0rY4sDkS2VUOLpSn57UoF1svNgqjtGPYSw77nrxX9uL9ZicSEQEulFSnzq
         Wyu8dPXlpTznBFPrwP2eh2ZHc6RlqTouP3Iuu3O10A54Jvjn0okTlZpWcjcHXcxiP/eU
         e9VQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCR4JDK381JzLJzVyd+ORfR0cpIhECTdTIvUZtplMJ2Kv9cS46YySEgxsx1wYqDs9Kny0P9LiBzQ==@kvack.org
X-Gm-Message-State: AOJu0Yy/vaLx+KdbYHQBz0vEWJtIJkoa7VAAhEpx5pjjgl0QrV2n+zcc
	A8w4ub4GDRRuNFKfAv8oEzzWOUlhGuHVvnuZce6D1B2UapUtfb/nSsNT
X-Gm-Gg: ATEYQzzFb4iop426hnD4IkOJGkbKotfxcmlt5XkOTvEHz9hdg/QCGGyRynOQLK97kXp
	mV4gMdf/lTQgzVNB9fzi5ILcIlaFr5kDs6uD0Iz1mTi3q+ioCKUxn3K2m5xEMP/nZdmohVumEHb
	cB40Y+Jhq3DvZfR+akoLn/8ntrgkgoptUfwHddQilknQigmH1CxVwe0MpnQcv3Lx73XpC2jWm7t
	ihpr43HL8UQk5S69Xf6uC1FH6s3iQW1O3idC+MnkM5/Qc6Xmyfvz9TITCmDA3i2BGnIbyVjUsSp
	1e9dBtaMEeDPCsw5ewKy3yDZaJYEIxDQ2vX7me52qoMhd89clUd8fbdrx/ebJNKQKoArbKc7beM
	ruYsfZYjJvR2R2JRRCGCV/bMUJZnRXMhHpjRQLIHRrxK7YdPCHUyfnmqKBQ5SmugiG3W8aq9Lk4
	mDxGEymQWS7nyAaE0cEcfQ7gZqyApf7l9tTf54w76V5NekFh73ZL9/WjSoIyyb8iiuYkVHzg/wH
	CMMd2DwhQuG
X-Received: by 2002:a05:600c:8903:b0:485:4533:9c47 with SMTP id 5b1f17b1804b1-48883595155mr80505475e9.22.1775110451858;
        Wed, 01 Apr 2026 23:14:11 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887c8ee2d3sm61916095e9.32.2026.04.01.23.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 23:14:11 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Youngjun Park <youngjun.park@lge.com>,
	NeilBrown <neil@brown.name>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH v4 1/2] mm/page_io: use sio->len for PSWPIN accounting in sio_read_complete()
Date: Thu,  2 Apr 2026 07:14:07 +0100
Message-ID: <20260402061408.36119-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 99F2AC0002
X-Stat-Signature: z4tqfrx1xjrdkzkgxs15e9zh4ntppi6z
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775110453-483918
X-HE-Meta: U2FsdGVkX1/A4iKTOpu1dwaEukUE+ruLzvaBpDbbaquYRpSV16Y+u4MfVsZzFshsORwv8PvAI+NAjqiN7g4b36Beip9TgAj0pLNT+fwj0SNtibSoAEQ/Th7pHkR43HTImOy+3e6Isx+wIflLXg0PSVsNMwGUFhJ8Wfn+wOGJE28UEQsBtAnn/mUtZgE2z3vjH/6XQ9P8bMlWOjb3tJeFBmgXbdQrSSCpfGEcs3uT4sw8Uqf3m9NlJWsxohw+BDCbxK1fvM4NOw3ee3iKXNEzTtPs+rXlQbpsMWSvzICQfF74f2968rAS0jwrDpyY0Rm8rkT1gZtC/Rw+P8DlOen6BIeignVS3BU6W4qXbriBEipIa4HIgZuJkIz8SYQisfDb2j0B5K3trPRPxSaAw8G46u6lon40CC+8q/qnTGqWWjn+dxCQixwPYQEq4HzyJvwfWxkZuTDtgRCgWsw802zK5BUMtGuwK/vT8iNNtd3MEEHVzJgnq0csyvxV+IVe8DRS7Xs0JuG6lHQkzqPHIF6VQzMHNpbBvyu0VrJqcoJAZfBcpEpku5sXmwNhiLcZqgElPiDCJZRquySvO4+EOqbL1faKcFH0EgBdRKUHHiyRasMh2UII3sykY4cXVAtgNfcbRDyavALPOuSgNBhD5Nv7I4xkEKEwKJR/kE+ENgt19uaH4ylki0gCsMwb0ESvlEGkVqVCmnhBsP30+Ef62TZGmxQqhqUBWSnZr/VPvOuPGuAMOzoVtLJ5PTj4ib3bKsb7K7GlZnJVJeRRCQTt13JCWcWZnbT2FTmCfSkuNC5emwNJ6zLiJtU6PhcUi8SVlTCokJe/mL/Nd+CuJe3Rd1aT1xv+eSJrFrvs0nYQDClKjNzFZZHJ+eKLt7oCxMLVkHQruBhiN0Fbef5EBBEe94IyJyznaGvJGBoUx+P5oaDrTK4Okd7zVmqvd9BrAC5+SZh32Cvnix6Wm8OgOPlD+aA
 wMxozWD9
 XYj+Vn+RY0Pqou7KiWt/zgZipJgCHPwG1GakFjRBKHzU/MJko8ZO7vdOObb0MNWmPuzyCQVBPCOpGT4uOn0CMnIcWnQeNtdvdUvgyBrNBiMpiJ7YY3QBUVCvNk6coaHSTFRWu0q0De7VfCp+VIt+iCmK/jdx/iRWjHukVs1H3xa/osbZLw+q1SGNs0qa53Q2jBiEuSUgXth+ugqiHJI0WiY/f7RjkAODAofzBmR6WNmRnUl44G4qQ+tjV5GPRFSc3yUEl4zUCSwVmKvhGLpv2ciY4qk1Rf4lxghkBlZMqDv/4y3yrn7q4WqUGBVihhBZDkipuN5hwJqxHvb8j98VoYzxBG079XDL9v4NXincTuRmURXehrxaxFnYevpPRyf9DewG9xiheG2PNCRA09qQqZUECH51GqcSfYwONQ+pkK7vqFwKSXPhx5NsTr7mIg+HeqEVB2zJ2hSqJHjF28+D4e3lteMtzMahyQ/uQn4yRlSiaqxUInOQiz8iIpBuXzpjxR9aTAuO6Hw6gfRGRFb4z26Hjvrtffb+aeGodLvvE5C+OoSs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sio_read_complete() uses sio->pages to account global PSWPIN vm events,
but sio->pages tracks the number of bvec entries (folios), not base
pages.

While large folios cannot currently reach this path (SWP_FS_OPS and
SWP_SYNCHRONOUS_IO are mutually exclusive, and mTHP swap-in allocation
is gated on SWP_SYNCHRONOUS_IO), the accounting is semantically
inconsistent with the per-memcg path which correctly uses
folio_nr_pages().

Use sio->len >> PAGE_SHIFT instead, which gives the correct base page
count since sio->len is accumulated via folio_size(folio).

Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/page_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 63b262f4c5a9..1389cd57ca88 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -497,7 +497,7 @@ static void sio_read_complete(struct kiocb *iocb, long ret)
 			folio_mark_uptodate(folio);
 			folio_unlock(folio);
 		}
-		count_vm_events(PSWPIN, sio->pages);
+		count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
 	} else {
 		for (p = 0; p < sio->pages; p++) {
 			struct folio *folio = page_folio(sio->bvec[p].bv_page);
-- 
2.53.0


