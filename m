Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71692C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 01:44:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7366A6B0122; Mon, 17 Aug 2026 21:44:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E8C86B0126; Mon, 17 Aug 2026 21:44:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D9596B0128; Mon, 17 Aug 2026 21:44:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2951E6B0122
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 21:44:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE9031A0A37
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:44:53 +0000 (UTC)
X-FDA: 85112696466.06.2553788
Received: from mail-pj2-f9.google.com (mail-pj2-f9.google.com [74.125.227.137])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0E863140003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:44:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DoCxHJOB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of foxieflakey@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787017492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Eq0Ctz1PSVt6+22tMq8H36+4SpJGE4A4JqTKseWdQds=;
	b=Vn5vcI4uc86jVgP8K3MkqFi8w47z2VsqvS/qUkHRkXRMNmkOeTzuD0nCa0jDBvBuPL6nOE
	8G5RQJ5D0QecnxAM2waj+nQjPXvKOCAEm4OnbDMtCMWP4NDxOlgbT1ilTJWZOLCNFN4PEA
	yMhXmGewxa2VFhXwCiHQmMZitwT70BI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DoCxHJOB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of foxieflakey@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787017492;
	b=IW6LwOMVLEEHSyLy6987RNL+SIGJvQ6lqY3cv0esl7JWAL1QS5GY9dxvPHJyEYpDv7JuI9
	fZg4Hk9A+ROU6BkafP/D+7ospcKdmMQ9Ov7+X4QAflGkHvYiabWUG1l37/QNfzMYo9eTaP
	cg62XjSJX5x/oBaq8k1IQQKrXzQ4oHw=
Received: by mail-pj2-f9.google.com with SMTP id 98e67ed59e1d1-38ed4d37526so2594245a91.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787017491; x=1787622291; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:date:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Eq0Ctz1PSVt6+22tMq8H36+4SpJGE4A4JqTKseWdQds=;
        b=DoCxHJOB357wYGkcWzvzyzRl3QNCd8jXZlCFuKqqlsoeGpOdlslefEMt9rp0ktZ63s
         2wWKCFqOP67jB6WZ537lWNDTIqkMVukUsFQyulp9W9dpOK0dKGXL+Ga+DTKLE0PlHPUK
         CTPcJKVGvJe9ai420yqMgT6tL6muyHXsCyQdrghhl/+z0rKPT6Mg/ZjWxhHCOsE88olR
         uiw0qra8LbTt/6tgVN431L5OOJh+o68oJrIMItRJC+zfcekzb7JTb4tVUdvJkVDH583G
         tVxu6FHZQy7gxxYiRpfHhgbEf22aqbXXRBxGJaXMT3Re7IpjzU4OJqELltyXnCt+B7pv
         QamA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787017491; x=1787622291;
        h=content-type:mime-version:message-id:subject:cc:to:date:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Eq0Ctz1PSVt6+22tMq8H36+4SpJGE4A4JqTKseWdQds=;
        b=UfuYvtoE/HTAyJPhbCu2A0jzbG0Q6xPSgHGqOfZCs4eUqEDSKCKhESLfkIckvdPoza
         SxYzEZg/pKDIxVOMpeL4/afR2OK3eBmcz/up4e9u5EjlZiZwQ8kMfPji8wQc20J4lg2K
         sjXaIEsO+jrwNATC4/GWc/ex9n5ZLCED8tSTtpfIAljNlPM4UbdI+jxxq6otbFOlRj10
         GsuZ/HYyXa2AWvz802YpxDhfL3tKEyyyg01ssKVg4xLDFekdw1Ow9hjiOvYeXpjBvNiS
         YIIipbUPAATGQFcgerqlnJdYcbXk2ddKPm7DStD8bq4kfNPvOch5WARZl0j1KyOj1Qfo
         ZqEA==
X-Gm-Message-State: AOJu0YwTbXLlTIzcriJgmKsA+VW2itbqEv3MAxwGKhcwuycgSAJQu/kB
	8vBW5+BTu/tloDMN+ua8RNgES2496yTPX2IXNpIBYTz9CTLwfczPJuYX
X-Gm-Gg: AR+sD11lEd7tZhwWER3OPH++pl9HDkILOxAF8xh4MJ+KERb8R0IM3gWmqv6TxCRaVJ+
	f/Xca5toeqHgk695rNkeSbUSYYn6+0Bwc6Oq9LJLIMzHG+p0YDQ0H9KWdq12UaVDrN4sfoAh2us
	4T7PlLchWfBzDqHKiGvUjTDQ8Dc2beOQtiSA+GuPRpLQuEWnV4W1Mrz7SqONbY//HBX2wNCyTAD
	AVFgau3Jz9gQI+u0zNAKCSZO8r649wON895Xwm9Ha5mr8wxIFhnDU6yLNqQjOUjpV62wDtdOJDb
	aukT1Ie8+POPGK27vyQ1KJyvRxhX+G2jBsCEBO8JLKyHZhhdZL7eG0Ivd8Y1LApLfJyKKEOc0/i
	uUTCiV2Q3qFfP/uEoAlfIvIoCHrfaBxAkYWlcYcWMFpo3/r8L8U1lq/4ZqRB1fPh4nluqDlpNPd
	ktyWhUUoFN+2VFts/LBnjoWOzcfYpTPUUepGM5OwN954TQxTsEtMVXoLP3
X-Received: by 2002:a17:90b:5805:b0:380:105f:8ffd with SMTP id 98e67ed59e1d1-3933b90d562mr30400906a91.16.1787017490752;
        Mon, 17 Aug 2026 18:44:50 -0700 (PDT)
Received: from 192.168.1.6 ([140.213.202.182])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14153073befsm9804468c88.7.2026.08.17.18.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 18:44:50 -0700 (PDT)
From: Foxie Flakey <foxieflakey@gmail.com>
X-Google-Original-From: Foxie Flakey <foxie@gmail.com>
Date: Tue, 18 Aug 2026 08:44:46 +0700 (WIB)
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
    Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] userfaultfd: reset err to be 0 when move_pages_ptes
 succeeded
Message-ID: <79cbfe54-41f2-9041-89f3-a96e9fb80066@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: hgxyf1wtyy585j3en7rt81u5c35318w6
X-Rspamd-Queue-Id: 0E863140003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787017491-126182
X-HE-Meta: U2FsdGVkX1/tpIHPUJVnSp0wd4dA8nwFNhBGQdPujBCwomL532cxo+hUF72a1ACCh9Xnsz29h/UenBjEIg6p6i0YkUIvrZv8x15KImOwlHm3GPr599guqei1VfRGVLF/Dq1GGwFIkmE4KCrwJMfFBnDPOJ8VEznus+pWstui9ldhxhhwqS365y47v0xo2VH+BJQifWXWRbuU7Z6148vY3kPnRydgVTxERSKJUwOac7v41XwOdTUk6ybt5QhqkvHjeqZyoboQ6AuPkRS+g18T9ivvFP0Pk2bd4n9/llj7PEP0fF+cvuolMUgu5yxPL+zFC1Car0hpv+QmupMlKQ/4xvSNWMd3+SsGy0bIT6tAvfpRwjbTl6la03PnguEQc18zt5iC+2rfagm2aHAuzlA0N9z81E0jcdO8A1q0jlk4zJtWX3hvCSR1uHZqB0madhlp3PywM/XIyrtogdFS6YhqfGUCenAphYCJUaAO2G9gsU7ah44jCONCs/CaAk15ms+6yUj/oNs2v24pDO+Z03Yx+QbFeht9GeiJSwkqMea9Gu/Yd7uS7VI/tZxc2rA+Os03AuuKZ/aY3waLeO8UggCiCr7GlsYDUBB32Sn/xmBnDjo1KAJC3nRBqC9dvhSFHse9suZqi8IAPqj+dk4w+GMy+Tla2l7dZycLblx1RW1wSPfPZ8mwru3VL/oTeeXDjriQ0l9SgokmWBASJIidts9s47AM19vMGwSAbGiMWk5lJCzhZD2rFuNcA3tG3LD18L8g3ZbPADKg4p2CK5SYhYC0hOLn2U1ebC2d/bo1vQyQ89mbcaPzO7edbtCdCTQgWyznuqPgVP2JKGPY5Acmoil9eSuAsPIETjJwY4+H1A1UhSMGWYBsP8aD+9P8TuhnfpUhtBgpX2vdiRHc97J/Pujho90dZYAFQzbfG8rTYCLPok7sl6uOpgOdexAaxRfB4yxOVj30NCtJo+YBCYCJ4KA
 dhjakPf9
 OQmFn5Svg8vXJeCq/r3+blbtdytTdGUNtet67msUVRan69xYEEdPM8Uas6KHXKWvY5GMGrI5+YQ++suI4qqBqsERixz/qk0JBRkdQFL5k2t97TxFbUiudeO7/kZsTUqxz+fKDTd0BIpLcIK1D+xjQWyoUMmoKroFBb8RiBYQzBFUL7E72lbViJCx6gftHSKWMoz7Wtlyfh00A1Hzd/Vu/UwliEvQj7K28MaJzoGnhNCd/wOfbJI8FICOmNgZV8Cin6M2+P0fsFTqts+L45YB7BN4Yq2yAyyblZwp4dYaM3yfno2zI/gjLNhFtMl9RJ71N5Zg17d6AjsB9p1knfbA/jT3cNH/0BBR5AQ2jLvm+Jz8o5IJKcDaDbRiy2CR9cvfBLFjvg1jgMaZ1xfhxinhzKmMSQ/wSn5zqKwIi5ed1qhLdFaCHJHz3/AmLc6h22/cqrPgP09+1tBgRrWmkIwRMToPnFHXnHaGfMS4LFje7hOnW1EM1TuLBndCXQBPpm24kXn/1GWUOKJjLyZwnFgsCie/AQsladHmo2zLg/Gh3A7qC/QxRP/+2Di0Rru2sejlWl4bn/EQJFh3f9WoCGgsTShMDh/R7jx2W/P+qmGdLq2Onf3eSnt3fKYAleLYMtGNg/3ZmrVygO5X57Og=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From 2599b924548175bef41ca6a601de58236a55a998 Mon Sep 17 00:00:00 2001
From: Foxie Flakey <foxieflakey@gmail.com>
Date: Sun, 16 Aug 2026 23:03:46 +0700
Subject: [PATCH] userfaultfd: reset err to be 0 when move_pages_ptes succeeded

During move_pages() operation, when move_pages_ptes() returns EAGAIN,
the error code is not cleared even after we processed it. This leads
to a successful retry but then the same pages are retried again due to
the stale error code. This time move fails because pages are already
moved, loop is terminated and move_pages() reports a failure.
Clear the error code once we processes EAGAIN.

Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for present pages in MOVE")
Assisted-by: ChatGPT:GPT-5.6-Luna
Signed-off-by: Foxie Flakey <foxieflakey@gmail.com>
---
Changes in v2:
- Updated on description to be easier to understood
- Reset err before retrying, instead of fixing right at the move_pages_ptes
  branch.
- Added Assisted-by, received an answer few days ago from linux-newbies IRC
  that even I just used AI/LLM as "fast path" of git bisect. I still need
  to add it following
  https://docs.kernel.org/process/coding-assistants.html doc.

---
 mm/userfaultfd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index c3adedaaf7d5..ec5d511bd179 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2085,8 +2085,10 @@ static ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 		}

 		if (err) {
-			if (err == -EAGAIN)
+			if (err == -EAGAIN) {
+				err = 0;
 				continue;
+			}
 			break;
 		}


base-commit: 62cc90241548d5570ee68e01aaba6506964e9811
-- 
2.55.0


