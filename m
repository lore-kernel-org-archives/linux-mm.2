Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEDE910BA422
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 03:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C5E76B00AA; Thu, 26 Mar 2026 23:01:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39DBE6B00AB; Thu, 26 Mar 2026 23:01:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28C1D6B00AC; Thu, 26 Mar 2026 23:01:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1405A6B00AA
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:01:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AC34713BFE5
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:01:02 +0000 (UTC)
X-FDA: 84590341164.15.9F8B9DF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 76A9A180011
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:01:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JPQBBhYS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of junzhao@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=junzhao@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774580460; a=rsa-sha256;
	cv=none;
	b=c2AcKttXDzrv1jCuLn5v1awjPLKHU0KpUhBrX1zjLgH62WmOH/Sfh2qzhNiSixguYrlTAF
	SHnUSmGU219nOhewAWnuahj8SyAwFScETFFE8NwYgFQq7DGxwMUtiVhIONhjZKeyt19Pq3
	Y2w+IlTCsUjBy/y+/8gYJJDtFCr1TaY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JPQBBhYS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of junzhao@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=junzhao@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774580460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KxXsUliqYzfkqIh03PXfVwMjyp8lPMaw2T3hQcpy0bM=;
	b=DIfVbmNqvfqBKCYne5Fh2tbklRTeOluGcJqxbPNfQDoI6YboEIA7q+TZap84T4qNnIqeBr
	kHjcKDGVMtzQ+/XQm+50maMLzfdiZkh36Zz9C3sdupwI2Rw5CJijE4ow0ndPpm1E6fqz8t
	uW5oV1X52B1Zq/4GLRaXSo+N2Uo1xIA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774580459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=KxXsUliqYzfkqIh03PXfVwMjyp8lPMaw2T3hQcpy0bM=;
	b=JPQBBhYSA24KgR4b5OQcqCXLqx09hjs43LXlDNw/TXgajSCp/2lPrz+QQy1BvYFTZWmalo
	FUMKqqN5sUdt2xXI03KQDDYELvQw9CkV3nqnW9xzUQZqKd3VY1dG6Vm6lLO01ujt69ZrFE
	YtrFLOqKWJuT5Tk+GVUTvOcTSdtUVYQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-14-KOb2S1KIMqaYQOlgQgEZpA-1; Thu, 26 Mar 2026 23:00:58 -0400
X-MC-Unique: KOb2S1KIMqaYQOlgQgEZpA-1
X-Mimecast-MFC-AGG-ID: KOb2S1KIMqaYQOlgQgEZpA_1774580457
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b983ca42edfso225580766b.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:00:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774580456; x=1775185256;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KxXsUliqYzfkqIh03PXfVwMjyp8lPMaw2T3hQcpy0bM=;
        b=NMU1vqimyiAPc1st6lBAsYrPEX6nH4d0KBRATPti52pOCtfcVE5wevAgpmwqCFG3Pj
         Rl+5S39w848Ps1l2Y66uJnkurHmq5C7f9uPmY66h+gG4vNMiT10gHeotpnIbe/CPEVXG
         xBb+4G1jOTpuE5uF1IOcjcNC05mu/fCkQjiTXv8Yot10hILSZXQBpcBVf6evqph6yK4b
         peVSJJlUVsfUdMiY4cdCyMNNtwRdCCvYO5ElK3ZQ9bgtMLBb2VTIFqe6FKk2GSmbEyZd
         C7I28Wy0f4YHrth33yxuo6gkwskw4Lv3p5QtaEoqGMx2jDQEx01lKLcVcvPp+Y5p4sjc
         hA2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUrxKCEqa02VWt9bjpznGBoXJMwGYnmrTCweNIw0yhrIxLeoMkMdWmvngh/ruhLVFFm1sPdfwT5aw==@kvack.org
X-Gm-Message-State: AOJu0Yxv42uMamKMyKlSwJeOpEHdo995VaZ4IFTJxrXSW4WDo4Gu3yHa
	Ls7DvMMaPtja6YnvB3MNUpnz4DJEb0HmwN80mrV4osJH3B8WlO7Yyw5HB7dNS3RKMT3C1WCkPUm
	5Kgn4ipZhvDdJN7g86LgNXcP0ECzoh4TL/FO+Sch8NOvhYODOuloXxantRfvocAoN696MgI8kL5
	wOtplLboLCqvAOkDxEgV+jli+Z+4M2vCklZi1WHA==
X-Gm-Gg: ATEYQzwQWJjF0zSEAP8jMd/GusTSFxtmnu9NCYPY+6ZUqhLaCiVmj8TJMci+SxhxCg2
	Edw3lhEcx8DdZd2KlDNsW79vOQTSPkW3VRXIBQDhqLG2/LFQHMUYwcjSNNbcJ0RHsA7ur4flj9H
	iUHtAAvzJFonDWX9PH/D7FZ2qo4TkYMK9rJbJ1vyJZ7wza884EWfrcI0cN09UiWOohojspzZ9cv
	lmfLDY=
X-Received: by 2002:a17:906:b0a:b0:b9b:54ac:68b9 with SMTP id a640c23a62f3a-b9b54ac9144mr14233066b.12.1774580456396;
        Thu, 26 Mar 2026 20:00:56 -0700 (PDT)
X-Received: by 2002:a17:906:b0a:b0:b9b:54ac:68b9 with SMTP id
 a640c23a62f3a-b9b54ac9144mr14231966b.12.1774580455842; Thu, 26 Mar 2026
 20:00:55 -0700 (PDT)
MIME-Version: 1.0
From: Junyao Zhao <junzhao@redhat.com>
Date: Fri, 27 Mar 2026 11:00:19 +0800
X-Gm-Features: AQROBzDaezXtEDNsCvayTZ5wEuhmDYFnTwT5H280-OnTH2ns8HlrQwTzV0iYz2I
Message-ID: <CAMZL0nYFrtfQbVs2F63S3y1kDnLGeQpURxd+OqGE3YkZ7Ad9Tg@mail.gmail.com>
Subject: [PATCH] mm/page_alloc: fix indentation for VM_WARN_ONCE
To: akpm@linux-foundation.org
Cc: vbabka@kernel.org, linux-mm@kvack.org, Junyao Zhao <junzhao@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: o1PCdx9vFwXgNuNMJ1xIXdnUUc2XVExFC_fMvtBwZ6I_1774580457
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: hq8snw9tib98bw71teo3cqahsysg6wj3
X-Rspamd-Queue-Id: 76A9A180011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774580460-119726
X-HE-Meta: U2FsdGVkX1/R4+Fa95ArtY19u8/tQePe4ypXzaRAD77gvp7i6MGQQrvMd+e/mFScKvJB1pdafg5xBX2t2P+7t+Cfn9TtcRGGdiTqGdknFgP5m+6ocJhhlO00/LpkaBhDTueGIZfVTeEXT6cs6Kw+MARVrnBaAwJBfi3G6BxUiLh4XqKe3ENe/IdQFi659E1GVHACT6je3PNxeD6aRs0cSuWRlvRIJeRvKYAnlKI5BmPWLMuVBf6Gv6pHQy7/4DSqFoJssqjVQybzKeDA7Lf1MbdxQWjGnEQZ2vR9Y9Kq4KgUiZBfzEqENQCjyxzmaBnRHox/rQQRGiQAd/dElWFO20TZX9ZrH+8lY64iYFtQFrdat8/t/9kQZOtb7JtIssEtTCC3XaEIcgzFkPTwAe7sdz8c/PnTRe/nzxvdrSI/ADIQBOc9PNz97ZmqJfsko49gf8cRTsaC9+/Dlr6pfswJJRWfjYg6Ko/X0aTuYhXEAMrq1UsnFEvcaAAblm8UvLi7UzOuT0kPk8MTe3PM2hEpzpa0WZQl8Cjnq7Pv2Af7HPw+cPrE5KUFktcb8OuLmbPNSlp+qDxok0G40gvriSiNxUnljNIb1sdfzsOC6/Pxn5hx3rusfwoLrTk6V7q/KWOkXJHvSYCiO4zR9x4gBP55fBvVXIIldp3ey1t1GQchiV6SpX4okXuRkYw9T/KwsFd7VURI8BoPbDnGrN8GUaHGVtxelA3ZBiDDWWEJGbem8Vnklzd8Zbo8r6bLSfaDrPI/bmV/0Wt2RYi13V1suKW3pE+SO2HZPqgOUL62OqFvmGbJInIoXGrvTryffVDBU6ZmY4jx9eOpE+Hb9JGiBu22fMbmRzC8xk4sDECDZN7EwbPVdz9A5Lcs2TWdgf0uhafe1/NctSmXFG8xz9xllMBi+kTgQR6brRQCGvMVWXf0yqnGbrkPZWMCpQPwUd7dp1ziB0jXps2giSgMVOOxxWv
 vK10+Y0l
 /baVrOThYhqEBU9mVkBPIBhieyesF6euPO4/lI2BOqk6+ma300vNxQ40/gtbb03tfFQ2ggl3JunwFF8rTc+NONEi5YfveuTxq2GbGzVJbi9Dri4MICi9lcU7LIekNYMnSNHqDVfqXZ8NXIod3hIW2Z5CLibYw97IPj6sd8VUt5/u4Vk02fhQUS3hGwmCmX6OI14XLo5cu0gt7LIumrkcLmFrfbIGNQHNpgovwYSfwDUD+ceVGdAU48TPMC6SNlEE14LMgU39+jUjbdM99CWWtA+nVxMsscRcOPk1F1BpOIXYu36SYFxI3kGET6HPD3KDebbfzVk5lwr+SiPNIL1n0pabSOozY5xNOs89pZKduudcitcSn+CV3BtLr5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From d7442d455218ffff67f890bb39d273d7555bed1c Mon Sep 17 00:00:00 2001
From: Junyao Zhao <junzhao@redhat.com>
Date: Thu, 26 Mar 2026 04:58:14 -0400
Subject: [PATCH] mm/page_alloc: fix indentation for VM_WARN_ONCE

Replace leading spaces with a tab to follow kernel coding style.

Reported by checkpatch.pl

Signed-off-by: Junyao Zhao <junzhao@redhat.com>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554e..d2e04ecddb8b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -884,7 +884,7 @@ static inline void
__del_page_from_free_list(struct page *page, struct zone *zon
 {
  int nr_pages = 1 << order;

-        VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
+ VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
       "page type is %d, passed migratetype is %d (nr=%d)\n",
       get_pageblock_migratetype(page), migratetype, nr_pages);

-- 
2.52.0


