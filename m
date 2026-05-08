Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32510CD343F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 01:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 213F06B00C1; Thu,  7 May 2026 21:54:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EAB56B00BF; Thu,  7 May 2026 21:54:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06D426B00BF; Thu,  7 May 2026 21:54:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EAD586B00BF
	for <linux-mm@kvack.org>; Thu,  7 May 2026 21:54:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8182714068D
	for <linux-mm@kvack.org>; Fri,  8 May 2026 01:54:27 +0000 (UTC)
X-FDA: 84742582974.05.7117F8C
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id DBA9A1C0014
	for <linux-mm@kvack.org>; Fri,  8 May 2026 01:54:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bJR1GmQn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3T0L9aQYKCCABI6UHACKKCHA.8KIHEJQT-IIGR68G.KNC@flex--fmayle.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3T0L9aQYKCCABI6UHACKKCHA.8KIHEJQT-IIGR68G.KNC@flex--fmayle.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778205265; a=rsa-sha256;
	cv=none;
	b=wbbkU+iVR/izfvtzw7on8sY8EaWn1ER0EhuMmiBKxYosgcnbFqUtO0HiO/PRyc0ans0WeC
	pNlgnKptH+wFk8yk6OUE4krZUW8CFh4FVW4ZbKHB9v8cMjgAfNt+TKC0GY+i6kQGgiveMG
	6sd/PIyf9yma2+tLqiyf9PueO/98680=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bJR1GmQn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3T0L9aQYKCCABI6UHACKKCHA.8KIHEJQT-IIGR68G.KNC@flex--fmayle.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3T0L9aQYKCCABI6UHACKKCHA.8KIHEJQT-IIGR68G.KNC@flex--fmayle.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778205265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nDCNoZ6k2LKNRaJd57QrXwFLyWNzjd5ZsttzB1Naw58=;
	b=rNbyhF9DKwB5s+W20xJdfHehs+7njVKx2V7FrzEDRW5Jj/v9qZLJpR6b9M8lAyixjvpG0g
	QWpkYznfbpZbtNqlAuovKpoW9FsVha1e08ASUQNvzC7ydp9auuvuWOsohMFn0MlyE3WaN0
	2MA3CTuoSUXqZTXSIAf/De+pB9+kYE4=
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-1270dcd11c1so3731742c88.0
        for <linux-mm@kvack.org>; Thu, 07 May 2026 18:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778205264; x=1778810064; darn=kvack.org;
        h=cc:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nDCNoZ6k2LKNRaJd57QrXwFLyWNzjd5ZsttzB1Naw58=;
        b=bJR1GmQnDaEn6z1Ln+YFzPClRPFl+4QBaBDyFh08T382OFwLRBUFfV5OBcijgsiP2E
         BkNPgPkBOW/JFmlQxvoqXAWsFI9pIJOiPFmPYrSsXIg55D6ThItHZxMVRDc0bjq4IyrI
         N9V/atLM8RMmWEZgpCmhWFq6a+gyB33RsU03ZNoIdy2wKAMHvLmGzW9nSSgQ0uHXY2I2
         /5RifOF4PZ9eBB8rhS1DwEvklUIsv5ZM9auj0lNKFSHwUMdOGB8QfAz6pvzaPav0UQQk
         WjHTAvDFY6souGprDKGUQY/augT4KtPOhL5+NOd52rw51dkr3EAZQDhL2B1fDYDNY+Ev
         /Zgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778205264; x=1778810064;
        h=cc:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nDCNoZ6k2LKNRaJd57QrXwFLyWNzjd5ZsttzB1Naw58=;
        b=fii4ZdbKUxuwIYjxVzpyHkj/6BEBX9GRBBeGB+DBCtiDa9aEUquB7bJw0BYvGHCGE5
         b3LNVy/bKyB/9RFY5/pgCuOIOnRkMF/T4I7U6teQPImPsgPW7ImI15spFkNomdH79Jgz
         YeN/V1ZJKrCIn7s8u0decbnKIM/H1p3eT/1JgrHMPHu2iRbqMCSQVrKs94QsgsjmQ0rV
         yiqcPiscdqD1L5lYI1dTwFu20l4pYSdJBo+Yv6NHQwbzttcHJ/Fh2RNDfO75t4kdCt2v
         wxs672Jy51PQPFnMxcSYp21f88oZJOno3NldcdpiKckn/qIGTtH5EO2W4OqJ52vdSjzN
         0qSg==
X-Forwarded-Encrypted: i=1; AFNElJ+IHeD8LFbnxghL44qxMsCb3MbFIoQ8YM8m/tRKZpxgzHWX9O/woThz+Gx1oyX3SeBHMNH4F1ddlg==@kvack.org
X-Gm-Message-State: AOJu0YzREnVo0xIoYrr4FhqGR3juGejG/LjIHRvRkJJyBRk1oFG+92gh
	QrUveEfR0+2MeGdCtIS1jcIegkVCT6Kt4bGCoUEhagBYnZK6ZbOzJ+PGNKgxg5VpjndcmgajvtO
	MJpVrBw==
X-Received: from dlbep12.prod.google.com ([2002:a05:7022:108c:b0:12d:c585:f600])
 (user=fmayle job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:7a6:b0:128:d9a1:b68b
 with SMTP id a92af1059eb24-131a69ece6bmr5011504c88.33.1778205263925; Thu, 07
 May 2026 18:54:23 -0700 (PDT)
Date: Thu,  7 May 2026 18:53:57 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260508015402.735441-1-fmayle@google.com>
Subject: [PATCH 1/1] mm/readahead: add kerneldoc for read_pages
From: Frederick Mayle <fmayle@google.com>
Cc: android-mm@google.com, kernel-team@android.com, 
	Frederick Mayle <fmayle@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: dj475tex75g679sp8x64qwkd5q3ejy9b
X-Rspam-User: 
X-Rspamd-Queue-Id: DBA9A1C0014
X-Rspamd-Server: rspam07
X-HE-Tag: 1778205265-829500
X-HE-Meta: U2FsdGVkX187BQ78S6FelZP3jTvaIx/yV9JDkP/8FEmQM6YfJUvC1jeb7mMp1+SRpBlIljzab3iW73Nf6OEGhQjDl0V3W+so8h21kTOxnN6xqG6qVzRWl+WsZoTpAFy3lZgbGLwHOiQ+zXHlDgnUJzjcUPJ0WTTe6dTNU4nRYJGUtJL1fEk8A5DVytTvhKmHjHT27ZuNg9ZTllrwSaSUCCxRetxOdJO6aHcetDypUyINqbV3yYG3R3q3jPGuuCsnWxL6ZOMRtuSEPnxW0th5SM8HQ8sAHzjXEccv4mv14rgSsl+4FdgH9sGYSNzewxq85Wlb5DhB1Twc2zRIL8jl24gTpvCKZO6LuEmTYAmVXD8rzi4aceLj+3FVVToMb8WNHy3zd2o22q9+Xg+fcfonUOfh80tIwcYb/RksPc1gRrWF64UppQi60ADi9slcCJJeFnT2X9+zc/h3so7hZEzWoZACidz9C4AE1fL57c577iWSoDymOZUUCQJ2jqhX6Sv6B9WG6KXbMvxqS2vocMcSnAY+Qi4T6qQ2pGt53B4vCKbsZTUtQtCTKOzmcX9agZZbpvveM95iBuqvWU3vFmkpcK0U+lPmlj8r6dPMhQI9ybMUSZU1U9oytFe/LG5gGcRAqkl/phGrnlJCsbpzUK1Ckv/EZNUip2g7ISPWlnEw93TJca0mO4hh+WSDWXUgqh2USpWclU8qPGrDEpch2GXT1prSUTJe8etGsvuMMPwg5efAPXYsOQMbKnvLb+jiAihDqg2N4M/6z5c55aPHgMezSagwpFkEjM9OIf523n7i5T6j9XqPdzWx60BMSpNyruGNbzjMd7wca3+F/t9BwIs8Y1HYCWdSEnug13fTxCvCrAg8+ih8ePNrvzO4YcPHSyB5R9GSteYl0MYM/Ylh2aka2AKodZrB2K69GF3r4WIR4BV6zvg1YmzAvXSzCAR10oQkFG7OB+jDOemOGMGzJbg
 h9sQTgcq
 X2iTyPQJIQfPq/2zXpeH3oMyxPeoJshq+8INGHrzfVLQn3Uo/816Xe4ORyRxrWSl30CNCdE3FlKisOaC108T6InnmrJtTbwi85hczuLFB5ZwkJJoaks+8I9cEsojzb/JEn7W8MqYb3+BmpR9vrfQ/C9TwBAPH9KUgo49zJA3MYDSKbnzOmrxv7L3vUMq4jLB6TCGNIFvhlfZNrC84hbzCi9yyhfgJWKyZKYcRDutLO2wCzAsjo+msQ9V2iEREBLVgnl2jFAIhyMa3PzxFan/JAVEk8CoI6Gr9TuWPw3e2PZNJBe/ENOxbsl5aulqnI/WQsHGHzF70btyK/mUrj5crs32gZbUiDVZOpljLIoCauBwrOLLw7Tcir79fIu4TTHnWwYzm3TnI6xVa5F/IxCfLOC9y/SW9I4V7w685kzbDfLg2xB9flRuJmHkTCWkTwPHC49sJ4dxMVrtuDs9BX1czvo5mkh3BX1NZj5lGjne98ON6cyx85Y2lJCD2sVg/3J2sGEA88wL5b52ghyBcU9qyVOTa3dQW+G6L/j+AHaALssQwSnjLrIarYogKv+NQc2XDyIR2nLPhhJePg1k4Ea+cPyj89CP9UIpDlwSayqSIn7GwG27VD1y2qfDmQTWCzTuEZzofuOK2pLDr0twjGUR5oRZ5tfZPdUZQk4zYLcAmpFGiZo0SPfsGNokzZa9+HvWUrMzsI2HcXjuZ7Waz3zdryMJj9pbIzvwoZBDaborIUkUiWRQ+sc6PInKU69yJVz3BhQ8m2v3DUiF+nHivn3q+66MiFWm4bKP9idZ2hxQKAmKft0sFzUGpHr6zeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Formalize one of the invariants provided by the current implementation
so that callers can depend on it, as discussed in [1].

Link: https://lore.kernel.org/all/20260501061146.6e61392d125cf1847d7cc181@linux-foundation.org/ [1]
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Frederick Mayle <fmayle@google.com>
---
 mm/readahead.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/readahead.c b/mm/readahead.c
index 8c12b63ccd4a..23bec5497308 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -146,6 +146,17 @@ file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping)
 }
 EXPORT_SYMBOL_GPL(file_ra_state_init);
 
+/**
+ * read_pages() - Start IO for a contiguous range of allocated folios in the
+ *                page cache.
+ * @rac: Readahead control.
+ *
+ * When read_pages() returns, it is guaranteed that all of the folios will have
+ * been processed or removed so that ``readahead_count(rac) == 0``. However,
+ * that does not imply that ``readahead_index(rac)`` will be updated to point
+ * to the end of the originally requested range because, for example, the
+ * filesystem may expand the range upwards.
+ */
 static void read_pages(struct readahead_control *rac)
 {
 	const struct address_space_operations *aops = rac->mapping->a_ops;

base-commit: 2d565cbaafd43b10b75da56e43e5db9852a56afd
-- 
2.54.0.563.g4f69b47b94-goog


