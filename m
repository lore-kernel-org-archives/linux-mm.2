Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46D42C5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 05:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2C9E6B033B; Sat, 15 Aug 2026 01:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDB9A6B033C; Sat, 15 Aug 2026 01:20:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF1E06B033D; Sat, 15 Aug 2026 01:20:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D72F6B033B
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:20:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 169B2402FE
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 05:20:12 +0000 (UTC)
X-FDA: 85102352664.06.E4B80A4
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5075E40006
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 05:20:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y629Zw6T;
	spf=pass (imf07.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786771210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2LNNcf+87LrqHmKQ3ILDbepTdxy8o+GDR7o/oD8fAmg=;
	b=0T5AEnzcwXPRuo+hcRznMjzWsfws1RIBGE/3kmNzH7UdzIvf2gfvwt0eF0oJ1eDb/7JINR
	BXdHhFbH1rU/aN/uGebmLQU5INSYBXoQR/nxTfnAzGjEHoTBIwUqiYtBQls/dx5Ixsp/3U
	kJFX9YNK2yCaowrvW9bq1X5JX3OO5SY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786771210;
	b=jF1A8SExgitWM1mi50+KLZ3q+R9Gb2pKguTr6RsbsEydJNUORJaI5TNcrm0M14Hrn8y2CO
	m9K23ZfyB0m7rfVTXaTzhfanYxlYRYb5ACBP67DDp2Rm+v2cSl8CgwpquT9pXsRzTuYDsF
	C4KRvgABk8U9xvlMWuIQqgzAiuDb0ls=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y629Zw6T;
	spf=pass (imf07.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-381b831d535so2693008a91.0
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 22:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786771209; x=1787376009; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2LNNcf+87LrqHmKQ3ILDbepTdxy8o+GDR7o/oD8fAmg=;
        b=Y629Zw6TvCmb6JG55kDsO/KNHcQSsH0ZsghG5voHcvgH2G5mKmIP19gav5C0JezDbX
         2qrGi1NG60JmLz+qSQE82TkEgnTAlbtFN7BKTVquoNxvlGDVHgCEQZZvAMnRgbUT5suL
         f6txBfZR4Eql2mawZtj7lTNkZlQX37ywJqmREyLa4cwtk8FM2JUBvEtv3vDks/wH86aR
         1DmbPVgUcThA6yv6ZB1JFzbbiMCA/u/r2Xs7H6io4llF7z9QvfnmJcrn08RyMe+vAoZd
         yVDhyHBL/0MJoRdOmWJAdxpWXbvJxopfVA0+uN8y/FsKautooTWFe7UgJPTuCC1CPljp
         M7Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786771209; x=1787376009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2LNNcf+87LrqHmKQ3ILDbepTdxy8o+GDR7o/oD8fAmg=;
        b=Z4UKojm+WIwB2cb5eZzoCoVE4LG1kmenCCOcqnScKM5UN5P6NGErIM+rkp7l3FAkqJ
         n1954f0TeonShj+xBrK17HSe4VdJXtjFzFVRj/CcQWItdH0qVg7lbIW7Mghl7br+SHb5
         paLmho8H0oblV91GoT0sNBEfnCwQRl+D8jZ7ES6bHZtLc48mJoGU+AxHqf7r/FJWp73I
         e1cA0JqdNJ1p2D2vBxMLSPFT3EX3Dd2KQixvCH8a9q1m2Zq60qBB7NHTzh1gtbYkcxyW
         ehyKauyr3P3jIWFVm39pCt+Mt/VWHada5AFDTU8X+bdTa12ybvqhr07S7CudYOVeQySh
         zuhQ==
X-Forwarded-Encrypted: i=1; AHgh+RpM5duphMvLt40aCotC1tDVdKRGyupXvUBlBPIxuW3Ln7YHA9nxvPQaNUXa+Y9jRk0RyaO2TX3q1w==@kvack.org
X-Gm-Message-State: AOJu0YzXkrH5Xjq75zz1GUSVZ8P++RS2CFEEWNIr5O9GJTCcAxUO5O/J
	T9sSjkeRuOSQidVs2fJpLW2IFhaGop8tdMSTrcqtTRljlXQkIpHeM8uM
X-Gm-Gg: AR+sD13OsASG6+oMDUHOqyhqkcBB9QBwprKkxqRkkioRzUkbYrSNf48EkThjsm82agC
	ubIkbCP3Sf7HikQDKdcisXsoOVJXklm1e4phXogCeg1uK2QpEdQrAMQI4yPEw0eTMy0F6O65XRw
	Oc5nhN2s12JMfbvgB3BfMqRO71M3RnmIVkutbSAr9xXG60OBwpNLcg04S1T+IXQiUDWwpcppVi7
	do5rqMITSVOuO0hY2AuruKG1mZhl44z6azxnduCv50cMHcXXCyoqscRSQ2ebl9JtMCFpso1PlDI
	J35NaFrcBic/lc7JJFFNASpINmRBs9RYaStLMHneXl0/Wm3Bhk2yGUdd/mKJbPuENl5ChrIP1HA
	Y9pn/SkY5ww7AuKaefzgJav0zUhUDg+t2jIpOlxua6JpPlPvaKGU0Xhn3MXD6pFF/rgVPKtLdnE
	GImlcvlRZS8MtilK3q9cwlCbEB9tVCctKsmrLK9IW7tnB0RdXbJPB59oRT2yoe0LxJnSfsqdfp
X-Received: by 2002:a17:90b:48ce:b0:390:b41a:b92b with SMTP id 98e67ed59e1d1-3933b6d05c3mr13639215a91.4.1786771209186;
        Fri, 14 Aug 2026 22:20:09 -0700 (PDT)
Received: from localhost.localdomain ([49.79.111.198])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394ea96c7fcsm5269702a91.3.2026.08.14.22.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 22:20:08 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	zokeefe@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Vernon Yang <yanglincheng@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/3] mm: khugepaged: fix folio is used after pte_unmap_unlock()
Date: Sat, 15 Aug 2026 13:19:23 +0800
Message-ID: <20260815051924.194810-3-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260815051924.194810-1-vernon2gm@gmail.com>
References: <20260815051924.194810-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 39rw5immjrjmzqd9dnt167k55bm59bh3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5075E40006
X-HE-Tag: 1786771210-610062
X-HE-Meta: U2FsdGVkX1+Crvxr6ESJJ1O36xRGvvD2JXA7RADvDSVGw281WjEUsv2cil5rqdNVb5DcXv3flfb687Swksp8tY5uzq9SbGmmefAUNoUqKI7rHKm8wE2vSwUO/B9dE0n2mKVgSpwR/zZdW/d+y97eN2oDb7iOSJqwwLC+3YubyrYpl2capoUoDQk3MqAQlKNT6vtx7JS6Fc60kH2x2wxJyFuzD9fCDr85u55po66zltkAiyXMj5WEb8cxOsPjoy5nW8uqIpJjdnxHdoRGfVpYygWcMLwjvuq037CjCEExq71w43Fd5d+we9nixEBQ+bXeQe30r9j4C/TBgjtX9DlZQoBy0yA87hYIinl+UmVp4kfSu4RfEv9p4Wf9c3M5Bds658L0UlHRcccSTGWpy9/GvMGil1yHa5dR0wgi26n8KnNItCZX9TNlS+UeObVBUsokE+aVPPDnZRO1IujYCPRUrpnvJ2tL5OXYUkvzqxuCKuLA47n6+SpARnQn8yqUaAZu0Aft36Lk/Tdbj82ajVWsmM3xqO0pM3qiiFtTyBd6c0modI4EenUENmiCG3WbUj6RTYQcMIgwOVuzRPGZRtTPfoG8mJqiEZNJ1kLxJyZrqzbXFk3F6ttbIpFZ3ItMhTZbw6CDveCtboi7qWpsr5o5HfERVs/b/3nYttXJti/UXr+JrcznO6r8gtPjPbVkyiciF9SUCaByW4gsV2G9u1bnRVVx2gKSttFnnozzZZZwXvgG90MOeznXhysWznzXd4joEj+QKrmPPiEfRm+AsfP/znxghDgOXmJyAStK+oZI9dyj0w+xbj1JYzEOVV9o7u3greHgTVpnqZPg0uzbF1c6gNErScB0PGodUiuHg8WF8yBOpwYPkW5SD0NSjz/LtYzs/zG6oalbB+dvb1b2UTVQ4+zwINGXE61LXE8UvPKajH5V/V5oewBUx07iB94QGZSazaw12yonKJ82xWUsu2z
 /YlzdWEZ
 NRQD7bwmvfX6rfTEGQwugJxxqd+DItn+dc/rujLmE2y25LsvBBlWcIwnwL6/A3urWTdgnm0SuVyvwtFQAMM9366co32TcX4vEA4MNCFZuBNxbjV3df9N5Wro2+UePM+HEQfX7qvzvvUIYwhUjUmZ+s0LME+Xr31N77+2L3kS+1s6QZh3ROm9lwKsEfjyQWQFERK+2O4lV3LLaAPVh3jH1+wTY8fK8vzbd8ACyi4S5G1M/mz5Y6UbHNtdX4sN7dkOI7r8dxr1xD7x97qt+vqVniH+CagipdsIW0j43r9Vf2bSg+Lh5rnIlOUcfm3pyStpigN3W5SUt9TmYv1VYwhyYohyqELufK/T3HjJJSx1gQOZxm29c3OkO/o8RTq5EEac76wWiX3AoPADJwnXUg8D2D9sP28xF0oLDZaPa6mN/0Brf6xJHD9yoH9DI2DRaQY1AFXc/NzKkyK9zRdo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

After the page table lock has dropped, the folio can be freed
concurrently. The trace_mm_khugepaged_scan_pmd() is left with
a dangling folio pointer.

So using the folio_pfn() before dropping the page table lock,
closing use-after-free window.

Fixes: 7d2eba0557c1 ("mm: add tracepoint for scanning pages")
Cc: stable@vger.kernel.org
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 include/trace/events/huge_memory.h | 6 +++---
 mm/khugepaged.c                    | 4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index d3572d4ef453..5dc71d292f47 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -55,10 +55,10 @@ SCAN_STATUS
 
 TRACE_EVENT(mm_khugepaged_scan_pmd,
 
-	TP_PROTO(struct mm_struct *mm, struct folio *folio,
+	TP_PROTO(struct mm_struct *mm, unsigned long pfn,
 		 int referenced, int none_or_zero, int status, int unmapped),
 
-	TP_ARGS(mm, folio, referenced, none_or_zero, status, unmapped),
+	TP_ARGS(mm, pfn, referenced, none_or_zero, status, unmapped),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
@@ -71,7 +71,7 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__entry->pfn = folio ? folio_pfn(folio) : -1;
+		__entry->pfn = pfn;
 		__entry->referenced = referenced;
 		__entry->none_or_zero = none_or_zero;
 		__entry->status = status;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e7830761d3a2..7c8c48577408 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1603,6 +1603,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 	enum scan_result result = SCAN_FAIL;
 	struct page *page = NULL;
 	struct folio *folio = NULL;
+	unsigned long pfn = -1;
 	unsigned long addr;
 	unsigned long enabled_orders;
 	spinlock_t *ptl;
@@ -1778,6 +1779,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		result = SCAN_SUCCEED;
 	}
 out_unmap:
+	pfn = folio ? folio_pfn(folio) : -1;
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
 		/* collapse_huge_page expects the lock to be dropped before calling */
@@ -1788,7 +1790,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		*lock_dropped = true;
 	}
 out:
-	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
+	trace_mm_khugepaged_scan_pmd(mm, pfn, referenced,
 				     none_or_zero, result, unmapped);
 	return result;
 }
-- 
2.53.0


