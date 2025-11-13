Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBFF1CD5BA1
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 08:54:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E812B8E0013; Thu, 13 Nov 2025 03:54:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E31F88E000B; Thu, 13 Nov 2025 03:54:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF9BC8E0013; Thu, 13 Nov 2025 03:54:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BA0928E000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 03:54:19 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 719331A08D1
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:54:19 +0000 (UTC)
X-FDA: 84104972238.09.AB126E2
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id A8559C000C
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:54:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Da0dN97Y;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763024057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dpTnA2MUAj836lGOlG7UmadHMuhVvcz41++jJ9KkuhM=;
	b=gV4aOoZC6WUYRVZ6se02LrQOkwv+hjOpXDqx1gCVeSj7IQ6ExPgRjLYQGZ36gNtJe6Y+Oy
	9J6i2LZWudDd/atMXWRBeargLmARuQ7bqpU5VUKlEbPeW1kY3LxioC34JWPejJhMiKGlGg
	sZsZvDarhaqyAMiz5Nbb5ujTtgnEsx0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Da0dN97Y;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763024057; a=rsa-sha256;
	cv=none;
	b=TBXLuf+7bE/rPsL+PbHf55cMaqfihTzYAqLhZKTLAD0Gx0WHX7N3+jw5LoY18iMqjKfrzx
	qbYfN6F0+aefF3MP8f3aPihbbytE5y/EOsn9G3pQ5of5S77v82XhcC7jmJ0zbuxwQA9K/Z
	ijFkArq4zOeN/HDpBDKRG9daEd1fCSE=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-297dc3e299bso5518245ad.1
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763024056; x=1763628856; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dpTnA2MUAj836lGOlG7UmadHMuhVvcz41++jJ9KkuhM=;
        b=Da0dN97YOxWapZJOreKZnZjawhOApLBgc5Z8rlPcYUF5pYmnJqkjCBCads33Y6peog
         aAlWf/dzl4dG9Xkhsu6bKcAxvRAVaaDKrU0ogD2VOIlu8sVm8u41zj3niRxJSm8Xh1SS
         BZE9DHtBZgHApNvD6CnukXFc4d6w7R+bY4T+Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763024056; x=1763628856;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dpTnA2MUAj836lGOlG7UmadHMuhVvcz41++jJ9KkuhM=;
        b=HONH+2UQp55Q2UtdbMMIimAEIv/jSh3jiIT5vYobUvo3ElMkm2ujSeaGmB64MugS94
         vV1pFC8ByJVLP7ClxoJZ4NdbEGcGo5n2SYhNOab5f+WflzdtWsP9ryAfbzy/tMinSimU
         QXtOjC0w9G2hB4QFVF5l4q9JlBCougPXiEsbks9y5/UHcr3JoyFQh8p/uOMv6FWSV7DI
         UxZsXn69LYBd0fUng2kwrPyX4c00xG2ctB1NB+RCBrYkhSoEDEtbPqpQCzJDJL7mJGsW
         +UZ1+zi5FTM2QGMdNvi2yw8XBmepWEg0kH1Jd3R3E2dqt58H+g0nSHtWAYdJXcWPnnof
         WnHA==
X-Forwarded-Encrypted: i=1; AJvYcCUq81cjJVZxT3fxwY0VWAXVzz3Nt4sZNGgtGKEKRTQvamO0Xb/ElGnWc+ZcIM4xWxJ0DWGpCumKNw==@kvack.org
X-Gm-Message-State: AOJu0YyMvgCZvLzEbXBG8/XeY3CDTcdO2n6TF12bbUXpgHUPPFNWWQ3o
	fT1BLP/ckIrZdhaQRSlIeGiRJvcUQogzWOKut0ZhHMACfSIvXFtsOWO2KE1k5WC1KA==
X-Gm-Gg: ASbGncuLCWVZx67/xzoQj3Knmc2yhu8Z2yZ6vJZV4MRffHQeAnYBR7deLyNnvgIy0eK
	oJWqja2Q1LBjzXlV0u09zzU5dAs49F3a9kO+wOZV7X6I5tbepdk/nIMdkGgAy9MGhaqgO5XSfQU
	umkes7hAm7AE1qoIAHD6QumKhlThlIaSmmVjNOQPq+VWkJ6yuRjcfXa2pX3yxztbJ8WTrrkrQEP
	cXxhOklzoDmD5uXL+4KeDj44J7Ax2okU17cpmcbUt6oeh5WpsvfjYQN1ByeijXhEf6eXdKp+hiY
	3Cq0KFS1JljNNTPOyjZ82W3pxcWEdT6HPF6yUJbTBSQRrWjyPJV+VedS1cnEjjYtyvYFxSfCdHC
	nWN7qgsbkIhYH/t63LAMrYmQ+QyF5x2y9ijypdjOyX+ECQoywqIKZ7LqWZriNgurUJs/4CsvFsb
	rSLSEO+Hs5P1wJLJRTBqE7UuyQf2o=
X-Google-Smtp-Source: AGHT+IGlRYtrFj/4YjKWjf1OzOHSeLUgv3Uc7+FXohdQ3S1q8hcdNvpoDApiTwcA0/LloW0V+MPPWw==
X-Received: by 2002:a17:903:19cf:b0:294:fcae:826 with SMTP id d9443c01a7336-2984edeedffmr89237465ad.59.1763024056517;
        Thu, 13 Nov 2025 00:54:16 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:6d96:d8c6:55e6:2377])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2346f3sm17486465ad.18.2025.11.13.00.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 00:54:15 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Richard Chang <richardycc@google.com>
Cc: Brian Geffon <bgeffon@google.com>,
	Fengyu Lian <licayy@outlook.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv2 0/4] zram: introduce writeback bio batching
Date: Thu, 13 Nov 2025 17:53:58 +0900
Message-ID: <20251113085402.1811522-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A8559C000C
X-Stat-Signature: e3dcedniqw6u1mk848j9wd8uodxjg4os
X-Rspam-User: 
X-HE-Tag: 1763024057-164951
X-HE-Meta: U2FsdGVkX18UdQS5S2ZnbO6SoVFnqndEq91KKZvNurmSxweQNJ7qhfBGp8zhxOF6TD/aVUtzRlpFKU57DDerB7C/hOmfojKMtGrgc3z92BSUldY08yjPNxT2PwlqGOwBCP6HlQYswHsIswRFhXoBVyD3z5H27Dwxrdj5G1vewMFpmZ2YwCcCppHd1nfPyuW9qmBjqt4fO+jN5p0OHX8D02NbC2sOBOrh0QXK9H0FDJPMHMkA3ToRUnV5l8qBiG9hLwgAxrA6mnSX7VcBHlUAZ8FwO0pZ3bP/9Y6WZ9uc/zXjecIllVBelWG1ymgKx11PnN3ctvjlX2pF+jzzIV/GL5YqaOlG8bgVvs1OkZne80chJ9u+cra5ytRNJw/SuGh/QIoJonSzj26AxlN6JtFz7VEaJu7w2w7csmfQVcH3JyOlLkg3A7jhTuhKSRyOAv42hv/14XGYfTVhLYM3MuGsiChXriTowzNhwsxDcuu3maQsXWjaCZSOd0BtRXRVjAj+5RXBM9Xkt8XmG/+h9N8vycwYbs1r3Q9LMYFRdvo+3WvWwKIVCy0HD4UQogxBrcnhYgXXjbRFXl5kWrUdSaDZ8H79mF9PmmQQbAZ5VgnCN5m0dOKrwsbbnueDnly2HaEFsU4H09QM70LqM+u+voFYLvKDlCDIStMwtPlLEyM6JazoYTfGuVw9HewoBtEihSnWwKDkpdZPBIRhqWGUWMUaoukyl9wDSXIZkHBc3oi7eagmoIVR7BdY8MKu7kf71zvkxRRKCZ3lfwqj7PEKoMXUGokrNu8hqOzzCd+VEi+0UeYaCbQzZgcedz9R6q2oz9343IWcPDpieKIo/FGo89+CgtL5durHl8+WSi3rHBMRl8aIpt1XjZxaE8147CELtc5BWlN7q0jWM716CTy20vCgsV+6w44sAMJaDiu0MEXlxQZmUp3FVvS4GQPeOxQqqqIqh/u2/XOZX1bK9ZiPRDN
 oIhCUoTX
 DwTtvzmDdmvLgTWXnSM1AO2eE6W8KcBxn9EZfM1AiMj0+g7hX5+wV8iGAWAxw8YkMDP6FCgQpcgUHhRFYksL1VykYalHF/uIQwN9FBmOzg93estHIC2gLpLwKdFES62dCUo/mAw8ZBqDkmmJOZuD4ZadlPxPA6Yk7xQIMzMgzkN/BAyWcDIZDB7IlPlAQWuffkeBsPjq5Jr8UZP+3+70iqCT2sMeEgiPeAjQdIK1iqYiG1fmP8SOkfimf7IlON4zMNpTAiyXK7pHymyN2VC5gNGJkpJF23jFE1XQZ/k2F6/gM4B4wmdcj0B720bgdo48qsHv5fYOPu7DieMKeFLBQ0ee2Ld7ts0JF0369eRXSQ4fOYlg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a rework of Yuwen's patch [1] that adds writeback bio
batching support to zram, which can improve throughput of
writeback operation.

v1->v2:
- moved pp-slot ownership to req before submission (pp_ctl doesn't own it
  anymore after it's assigned to the req)
- do not take spin-lock in bach_limit handler
- dropped wb_limit_lock
- moved wb_limt accounting to pre-submit and completion stages
- introduced simple wb_limit helpers
- more comments and cleanups

[1] https://lore.kernel.org/linux-block/tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com/

Sergey Senozhatsky (3):
  zram: add writeback batch size device attr
  zram: take write lock in wb limit store handlers
  zram: drop wb_limit_lock

Yuwen Chen (1):
  zram: introduce writeback bio batching support

 drivers/block/zram/zram_drv.c | 410 +++++++++++++++++++++++++++-------
 drivers/block/zram/zram_drv.h |   2 +-
 2 files changed, 326 insertions(+), 86 deletions(-)

-- 
2.51.2.1041.gc1ab5b90ca-goog


