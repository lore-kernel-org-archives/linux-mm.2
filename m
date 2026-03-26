Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21FC9109E532
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 00:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C3D36B0089; Wed, 25 Mar 2026 20:15:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29B6D6B008C; Wed, 25 Mar 2026 20:15:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D8266B0092; Wed, 25 Mar 2026 20:15:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BABD6B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:15:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A197160B5D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 00:15:01 +0000 (UTC)
X-FDA: 84586294002.26.599F69E
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8BDFF4000A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 00:14:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UHH5LKHY;
	spf=pass (imf27.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774484099; a=rsa-sha256;
	cv=none;
	b=d2yDQLxMrUlMFgWBB++DwqOH3gFoCul0SWo8vsuz4/xmU3LmhbVWIkBwaTddBfT3UHPkBX
	WC46jH7Yq503j/27aQhqbrlWoa+VEz/LIynFiAhEuxUKTl3sJ+bwBrSC4B/rzgMp97g/Iz
	QbPd10IbqI8QmYqZmy+tYGtRIgE3pfY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774484099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yrBenhGvRwHPq/Mdnx3w0hWhdf5xW+E3HZRTVhRTrU0=;
	b=Hb2vVQqaqKEbXE7lnCfW0OuZ9t4UXLLgzvTCFVfAUHaVaGIvzc5P96m4NvOcIZimBxWDin
	Ekj9jGYpL/cCGd2Bn44owTBnTnxZnBgaIDedI0AVRY5gj3zH1Uaf0488tnBoe8ht/JWMGK
	oO5qhJAII+MU2sG9xCQaEig7+xcPa3k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UHH5LKHY;
	spf=pass (imf27.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-82ae378fff8so280560b3a.2
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774484098; x=1775088898; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yrBenhGvRwHPq/Mdnx3w0hWhdf5xW+E3HZRTVhRTrU0=;
        b=UHH5LKHYsn8dww+qNB8Gf8QU/P/tjagycBOiFBztAP+rBFRDwyPcuySr9toGIi6mFm
         b6qQUNvLhmlZGd2L+BH6PPqtf7Nc8mOi+NVnxzBUizIME2nHnHYuF2yALWefRzHI3vj4
         8jBF51aKLqO3yZU/cwTBqVfmEC4ySocLHl/xAySVWwbgNXAaubsH/OoA0+lSdAaNp2Sp
         b5c6Kxxnu+mfowLa4jMXfCPLhILfc7lG0QIZH+Fmg7C0ObQbBOAV15nXkHPjLvbi0qnL
         JxnoPWughLY6rQ4XWbRe8KSV7aorbL2K0paCZWYuhlOnn+xcbqH0NCDb6PEW9I+1Ht3R
         Vs7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774484098; x=1775088898;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yrBenhGvRwHPq/Mdnx3w0hWhdf5xW+E3HZRTVhRTrU0=;
        b=gGS6JdSVpTI2KlUdS0mQIy9tNiY5PR9hHoJxwPv6SFQjqLlSGZOAa4zmDGLagQ0Wxl
         lByBcYHTVmczYL6DYL4un2cLhDGEs4sYdum89Vj0F+8ZlttUvNZRSu/cVNwPWEqznIOT
         jVyiQ2vc4QJB/QIig/CouHSqiZQmR6ihELcpb2fBKkmrZzfOuE9MvzYE4hfI+BhTlIjj
         EkuepnICJGLnZZ44wRxx4qbVarJiExNZ5/T13CvySQZJRR9pbDusdWWTCRbGcB7PMKPt
         oq/9p+ZAtdgHYQU2n8H5NQXFfyjlJS2jh8kuUz2AykIROmErwsOc06TWJBpJCalV8Xr6
         1Qnw==
X-Forwarded-Encrypted: i=1; AJvYcCUoeRKRdtE4pqGIttJ839fsKU8PGeG5huc8HAN+JpzF+gvaXcICxyYOiKiFx1SgRG09zgmLVyBKMw==@kvack.org
X-Gm-Message-State: AOJu0YwmrN1C6eAEYTclkQp+oWbdAMyWkKxRzs9VwWRyeuniPXfCUUcv
	osJsQ9wkBzS4fyaBusHklIvm4vSh5LnptQzAqam4/SedPzBcxXqfWDOY
X-Gm-Gg: ATEYQzw568m+1iJKBGdHFhpimKNF27TWL+h9o1v0fY32HjP1NBMN0zavEHK/gPvQI0h
	ZP7y4ejWRutEVfupElLRZaYnc9Ko6IK3ZZaAjs1MjBn8R+W1SjObqFG0def3rm8prczyoUN7Zgb
	U0e3xRXSN8vBRbLBEbjQFbWCNaiolnhOIu6E3KTqoRAvi6hnfpN5WtrpwUTvZYdIRNJ1P8tqPJF
	SiXbmSPBeeO3duspws2ttQj9UyJaETVrSMfP0hyRaEFYTRJ+a5zFEU1rCwSUtbg0+JxMqheS9oH
	6qO0qUWBmQhaGjptAnPLGpDA/pccmJn1BPEzTyye702o4MnxOGHIcHE2rMUI86K/y2Mo4yubDtm
	LDcFckgtTZwGD2NSUuuJelDEzMJcDbDGWd7qs3O35iD7g6dhq1Xub4nbNR8h5HfhJzMv8cXzNgM
	ATd4Cghe7lkW6i9WQKgQ==
X-Received: by 2002:a05:6a00:1310:b0:829:71d3:1ddb with SMTP id d2e1a72fcca58-82c6e11d7a4mr5064000b3a.59.1774484098088;
        Wed, 25 Mar 2026 17:14:58 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:13::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82c7d3bf324sm897008b3a.40.2026.03.25.17.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 17:14:57 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	jack@suse.cz,
	willy@infradead.org,
	miklos@szeredi.hu,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1] mm: fix writeback regression for strictlimit BDIs
Date: Wed, 25 Mar 2026 17:13:37 -0700
Message-ID: <20260326001337.828947-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8BDFF4000A
X-Stat-Signature: 3yjyuxjxgofuk16quukjg6drhu1rj86w
X-HE-Tag: 1774484099-990930
X-HE-Meta: U2FsdGVkX1+pvPCu3XoEm4NWnB8JNHvIz6TJMpvHpJKdReDHim5f71Ufb/QUYYPRru06rNB55mAnNI+YiqKqdU6lsFlor6KJE0LB6CBR2cYG0hZm6TwmEqcmvpI7qxO/bkKl+T5dMhSX+CGp151UEIxMhfwWj4Lxsum9hrxtbhtK7o9zpWI9qTSJPo1na56Qdjaj5Acrg+lLZ9E6tLm6WKbxqsskLCffIJUz86jdHyQ0GWu9Jr2DQYAnQCfyk5dSv6JcnvqfXWFKmVxBEBSGTrICGtUcAO3GJ6b1W/vQGBWlUqOmQCbTxQjUuD+QNlc/Y2n/P18kC4fhSxN7jDDPx65ZsyF8acZRqwXJSkiJn2xkqxgU4jqhlKjc2nchaugwTprw4Vhuzy9uOCqI53pAMdPCZWNFq9u95GjiYT2b+mhB6GEHXDkJ9RNHxLFDBOHpDxghUL+fDy4cUZyIr76+/SDv1Z1cYaITgrE8S3rg7DoDzC6b9fXk1IzFCvE4fLs3klErv5P1a2DG7azmVtkgpYNWK0P8SQuf5BL5cZ3mPPIiMD+IAIzFjL5ocMqtace+/+cx6/U3gKGjCTO1SSqHY97kI8BTOfn+Uv/KhZu5pWMdVrXT+dF8C70iAl9HCDUiCo3sN+ZDcm0f6n4ia22oaMccIfWGclLMsY88CI/HYJbB7VeR38WhvcprHvjF9Nq2Gxsvm6gAb9kDXAiXpiBSguglvUd451zE269VFY9dWKoZ39Fjld414YTPorQyALQgn1FI1lqx1+HSs2jDRAQ3+p/eFp9WKO7P6ure4AN6eec6dh72BEwxtt1RzZjyexFnuBq6Qjkvbrk3QJ8qo4xfpldIuEkEo7uwR5WLM2wlRwxoxHWvQP+YJkDojocnpsJGuF21SrXqbLj6b6cBo3Qi11cVfO3ypid0PI98f/z3nEabmIy79dui4gmJWcwCiA1nqk6LkuMQo/1ixauPxTN
 zLUWk/P+
 TBo3Bb1IhywYipLewjaRdlMUiP0q3Yi0Ha2pkfZKaVnQLxfRXwmCDpq4pwCkwxNbD3KdjEdcpurTkbz1BaNFmErq5I3t1GICk7qUfm1ayA5ucU1UbKWaw6q+CNmY93BiTVeCP4z9ni1EXWA7u8Mpz/s9XgLAO8W2cQRH3zlEJmLV52FZmqAS/y5l6kWbxwjHHF8Fxa2YuwwEaxbxr+KY0AAKQ9OBM88/noBy4XEgC/TgOzjqDeq679CQivT2lOE2/Aus6TzTZdSeVaAXqg/+K/CWiHDYgZLW8HMh2WGDWhWDkWpbiv1vx9jvSN0+yvd/6EmzYg2zFkxu0Ma9US6CMb18JYp5BeKycUBcWN3yB0PUyLT09ddphu1/QjtFaMTPrZEr7TZVOkQ0Mm5yMaK8hNkTpsQ1FPTrP6Ojw2v1YqE/68BeV1xJe1LTIQfe/yzaDXRYRUa2V6JruIz6U3Pmq64/TSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 64dd89ae01f2 ("mm/block/fs: remove laptop_mode") removed this
unconditional writeback kick from balance_dirty_pages():

       if (unlikely(!writeback_in_progress(wb)))
	       wb_start_background_writeback(wb);

Earlier in balance_dirty_pages(), background writeback is started if the
global dirty count exceeds the global background threshold (nr_dirty >
gdtc->bg_thresh). However for BDIs with BDI_CAP_STRICTLIMIT set (eg
fuse), throttling is calculated using the per-wb threshold, not global
thresholds. This means the per-wb threshold can be exceeded while the
global nr_dirty is below gdtc->bg_thresh. This causes two problems:

a) background writeback is never proactively kicked off. The flusher
should be kicked off while the writer is still free-running, so that
dirty pages are drained before the writer hits the throttle threshold.
For strictlimit BDIs with global nr_dirty < gdtc->bg_thresh, this never
kicks off the flusher, so dirty pages pile up unchecked until the per-wb
freerun ceiling gets hit and IO is throttled

b) while IO is throttled, the flusher is still not started, which means
the writer basically sits in the throttle loop sleeping while waiting
for dirty pages to be cleaned but no writeback is running

This leads to severe stalls and degraded throughput. On fuse, buffered
write performance drops from 1400 MiB/s to 2000 KiB/s.

This fixes the issue by kicking off the flusher if wb_dirty exceeds
wb_bg_thresh for strictlimit BDIs. This restores performance back to its
original baseline.

Fixes: 64dd89ae01f2 ("mm/block/fs: remove laptop_mode")
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/page-writeback.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 601a5e048d12..3f89b08b11b4 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1835,7 +1835,9 @@ static int balance_dirty_pages(struct bdi_writeback *wb,
 			balance_domain_limits(mdtc, strictlimit);
 		}
 
-		if (nr_dirty > gdtc->bg_thresh && !writeback_in_progress(wb))
+		if (!writeback_in_progress(wb) &&
+		    (nr_dirty > gdtc->bg_thresh ||
+		     (strictlimit && gdtc->wb_dirty > gdtc->wb_bg_thresh)))
 			wb_start_background_writeback(wb);
 
 		/*
-- 
2.52.0


