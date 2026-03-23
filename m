Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D09FED58CBF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:13:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B0FE6B0088; Mon, 23 Mar 2026 19:13:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13B046B0089; Mon, 23 Mar 2026 19:13:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 002366B008A; Mon, 23 Mar 2026 19:13:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEB5A6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:13:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8AA741A0D65
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:13:22 +0000 (UTC)
X-FDA: 84578881044.03.085E853
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id B1F671C000C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:13:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MJM09Q6A;
	spf=pass (imf20.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774307600; a=rsa-sha256;
	cv=none;
	b=lvlqa5iQT0zseQQ26Oq6847KfDt0L0630Agns6YIWwQvzjsSKGuvcf+41ZBI79bFKIb0yc
	IZt/BY0akHFizcoyzVkk/Tzy5h567M9SiPnfg8OOuy6kax0X8GV2TvD4KOYzO9SFDwbqGZ
	uL2hFg2+ldih9F5ybRjss6vs5Lwrgzc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774307600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JuXl9+fIjLP3gmq23BGApIN+T1D/hiJjVQ+FzhUhXKE=;
	b=O8IW5JpSrl+x5tyiLZmrugkg/MICmqOQUXfWcm9VTbNv+hOhpgME2/cd4vYEwgKGGOQHno
	krtqkuh3prcqJDt11Utk4M8YGfDoClDd3GDYK5Y0npoWb+Kk09QiVJH1Q/ZrGt2rMKUx7K
	MBSTi4y2QyIsF7TQ11YIC8ANDCvkilc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MJM09Q6A;
	spf=pass (imf20.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48702d51cd0so32603815e9.2
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774307599; x=1774912399; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JuXl9+fIjLP3gmq23BGApIN+T1D/hiJjVQ+FzhUhXKE=;
        b=MJM09Q6AkV4FEVQyxByw9Di0PIfWegZyurw6C7X3hpMk9Eu5t0LHMZQt6MWiSMObai
         QwhcR1YyFXMFBkfTet/F8AUlecHfWGYxndSk4jTA9cG65zwziW3beAIdhFdI/MbwFN29
         iDLwqsiXmfno1cN/FQ12IsQgKeznX5Yi9Pd4uuvc2EeZJikPSm2/bUcF/6KsR1l/YnjS
         ZfnLI33U/hfDLNIDD5yuSCsGNTTWVFfV73+RQVDuaCqMVnugTEnT6rIqO6N4yKh1TCWp
         J588wq/+kJ/+F7Pq0R0Qh8MKy03p4fJfm2SixoXumUGlPE3XB291XtZIy3YJKVmmYHHJ
         w6Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774307599; x=1774912399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JuXl9+fIjLP3gmq23BGApIN+T1D/hiJjVQ+FzhUhXKE=;
        b=GJxz/1FB56Atp0Scpf7gNPmrzn5vVmZseBsbACikDAOlRJ1sBwovfdQLWV7oyWYrz5
         +9BKUUjcVL8rGFbZztBiY539IOW7ExT3MrfD7KwDJY85CQhN1DIFLIvGQKN9wdAIp6b8
         qiP7IbAz36S3A2IWbOSOe9s17p8wZEe6SmH5/hnmkP58LBaNWVrpQSiY4M2N/TVpwfsN
         23gV1Rwy1TvELOJ63zM1i2ioxI/mnJcvOny6+Y1a8QRs/SamhgxJKnKedvn6P/b2sNdf
         Kr+4M7HrCDccLjHJMBW6IA2pXAM8qvMPPsoKxDfrqKXMxyqwYTxq4rhm6RJgWOY9CT6t
         9Lbg==
X-Gm-Message-State: AOJu0Yy+XaLomAIdQwT9phNPM1RZucB+4d3J0F2vdf/NmC111er3hmbx
	/nYoiH5KpqhEaV9beybITLCaeaigixVwwODfyXvvc4f26+GtMKoyGvwR
X-Gm-Gg: ATEYQzxWPfi70vO5SQk8/e59u1ayrFk9qzhY+0SpkWJpX2RLXaG9AY/Y9DaxX7NQJ92
	YjuI8aW66yXmge/4KJwQccBhxPbNnbX0FclJP3QB6FRwhmVVaqqJmdzU6MMUKYp/oAIhSmLDwZg
	+OajFtyXp3fnepOiZQYCpwFtmdv/Ns3mbHpLG0j1tvHs1VuYlhdjijZt90VZKRa8iryRh59rtTA
	2vNFtshcXDXky384te6sRgx/6zTLs7wc66Mc1g8YWnoFTUx+o1+AmVo6FOcJt5J5q3EwGW4w3jK
	6tJVXJit3F4DEjsfEsP7eQOuiptprpGXzbkg8OPSWmp0b0vOJ7wZJgm0iojo7fwpqIUgh6O449p
	pbpkbnDnxeLcfySa3ISFB7b5JJ6sfw5IftWVs/IkZLHbvuHTA/ASHoltUlKzBkTWmIY7k/YJIG4
	YN6f+EAl2XtQvRBSpFCW+V8fisyorgBbfzSyGMoS4J1N4DgoDOL2ulxfbSKd+57pNjbsLXeIzwh
	ZC1Zd9W4zI7
X-Received: by 2002:a05:600c:3b23:b0:486:fdc6:1c0d with SMTP id 5b1f17b1804b1-486ff02da9emr205816435e9.22.1774307598824;
        Mon, 23 Mar 2026 16:13:18 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b644ae048sm32851021f8f.1.2026.03.23.16.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 16:13:18 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>
Cc: linux-mm@kvack.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH] mm/page_io: fix PSWPIN undercount for large folios in sio_read_complete()
Date: Mon, 23 Mar 2026 23:13:15 +0000
Message-ID: <20260323231315.240137-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323170449.26333-1-devnexen@gmail.com>
References: <20260323170449.26333-1-devnexen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B1F671C000C
X-Stat-Signature: x1mwruaor3porzb9q4hzcfrjwmn3pe77
X-HE-Tag: 1774307600-462553
X-HE-Meta: U2FsdGVkX1+7QsYQhdxIJSk4/hmk4BrcYd98PHj/ptxjesMFyY+lYXcTJVCuNFtIJlKA98Ewijg6onpwdyElrds/2zsO6g88hRJHz/56aly29R1uuK7e3vS/D3QV5/qbTe4NWbu0InZlfrf+xMFaWvE+AgR9F4KcB8nGxURblMcxhgcERk9xdHgrL8ZkHxudc94Lvzz7evkBKdy2O2e7XelEGYQfGWaDMwQS/S40Gm2SnT+7uNHS5e4Xsa4tFBluAFGY6t/Lerx1w3hGvvxHPEWDstnoHNbc/eIMbwpXj6gdQmBDRXedskQm3P4lhqxCkrrCq1RzUxsDMPUm4K5l1PLi9mYHL3J1IN+YSH51njCBr/Sac5cObFhcKGrcYAhYAGe5Pglhle17wmHiy9hl0bTc6ZQMrGlLewKjlafwFQV2hQoEvf9345R74VCSjXVwZ5m0QojqhlHyKdADwxyKlrs7f15bwCCZPwCC1HK5Je9/9Hu8Do/a1JX1sz8oN2lHu79a4626Pm8bG0Pv8uDpCyB6JRkIEXF/xtAsDMPI/vifXTcWvJ12m8ZAgYtbVtF2jHkYgQ6d5/H4Y4dcIjhnFAOCKGkLlZBWnaHUg9qAVSZ8PLngeY/lsuKJrXUvjYQ6rxbzWijY5KvJH8fv30YIVy9t7b4mH8jTxiRHknjB4gG+IasLJn7EyefLi+2irt7SI9r+5dv2LDS1jDKvTHxUpGrKBRCbh1Ym8snjwul+9DhG9AI8maFoW9gmvqREM83Rn3j6DdSvDQT1sH5u8pPklNszqdueuridJrA4knjEuPvyzHtgPJ/jRWQIwL9J7rBOQpcKVEIne52GCd9utyWWUtGBrhnadSapk1ElM1BvsvPwzhn2hndHYcZBBFrlVZDdLq59zT1a4xj0aX2qsmu72bsJPiC2PpI3LxJX911OsiWlPVFj9wzd+m3EpXqSVysBf9KzT5IUANSRCQsbQOp
 328GJ6TH
 ZWFypQDid/oOYpxE7LHFfjK9xa3mDsrj3TamUeH0WjhS94hrVzI4kgEWZvvuoJOdIEAqXu2Hu70fGsEUbBwv7gLMJpWj1IhoFyxUcHln1mg/oorrRyN6WxS2scXP4hnV4UfZgsBHeQRrmM8yekfP9BKCjX3ZDsWCz0mx9+b/xzZWUeWyh3fPhaa03VcfhyPggT1B0xoi5oUBiRUkVXgCAQ5lVZeTOh3sO3n4hDvVJV34Hcaok9XSlZl29aFeP3Ej3j7JvEt992XJ/YCVQvzxeaPe1czumMLNdiSm365Xm3VVTb5lTlW0RmmsuH5dvHsn1A7hiEbj8RjvEe/U3WyZ3NvCa9ViSpN268EQh/t2BUmvPVx0lHYGmaUYyEWz8nNwiE3mgxOglLY6S8woqqazyAC11amY0hb+yTuPyRFgnbplcMA/1oJBv+oN3qC0VzvS+mCxrwVVduAPDNo8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sio_read_complete() uses sio->pages to account global PSWPIN vm events,
but sio->pages tracks the number of bvec entries (folios), not base
pages. For large folios this undercounts compared to the per-memcg path
which correctly uses folio_nr_pages(), and compared to the bdev read
paths which also use folio_nr_pages().

Use sio->len >> PAGE_SHIFT instead, which gives the correct base page
count since sio->len is accumulated via folio_size(folio).

Fixes: 6a8c068774ad ("mm/page_io: use a folio in sio_read_complete()")
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


