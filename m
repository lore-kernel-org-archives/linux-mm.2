Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9E0DCD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 20:32:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5009C6B008C; Tue, 12 May 2026 16:32:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8536B0092; Tue, 12 May 2026 16:32:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 415166B0093; Tue, 12 May 2026 16:32:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3489A6B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:32:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9287C2023
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:32:35 +0000 (UTC)
X-FDA: 84759915870.29.A8DF510
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3F09540007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:32:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KIFWRhxJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3YI4DagYKCOEIPDbOHJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--fmayle.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3YI4DagYKCOEIPDbOHJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--fmayle.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778617954; a=rsa-sha256;
	cv=none;
	b=T71xiiEXcsf3CCy+cfsWOvJrb/LNrpf6ZbDhdePfEzGeWJtFE6vXkwCe5lqY8ItlB4sYQI
	QjGTfdMdYzfhd8wVaM6cHNUbVNOUmrw6gPPO+XB9xCzzX6d0sUe4l8JLKDtMQKbgTsJDJg
	z7CYuaPCMqAnQ5nxjGcvhVMwHG0ADyI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KIFWRhxJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3YI4DagYKCOEIPDbOHJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--fmayle.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3YI4DagYKCOEIPDbOHJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--fmayle.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778617954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q6bLlWzsZHxTKwI8h2tfKnH8AsKS+KM39iZ5XG/RwLQ=;
	b=zZRQslhA4i9g1HtHuQLWMJEeeuJ7OV6vRxtZAosj+NpOWaYnPcW/ihmtUE7y0g40jfneVd
	hKO2Z7aO3xTUnxlHOA+uaKxLL4ZudBnR69NmD5e6EFZ7WkXqX7Ori9pyys8MfpLtS23opn
	9db+FLnak+7AAeVTFDkJiDQCzSrLXuY=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82f9429f49cso7528922b3a.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 13:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778617953; x=1779222753; darn=kvack.org;
        h=cc:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q6bLlWzsZHxTKwI8h2tfKnH8AsKS+KM39iZ5XG/RwLQ=;
        b=KIFWRhxJpAEGAIYTk0N8U7LQC6VSUe0mzFxbSyxHymZB16RWVB70TXuzyWyiIgRVLS
         zhkCIgbN+OTwmDQoREVcV4bsabVufwcxAjrgDjZ58OFVPTLIIvUDJvhY16d9tdZcAmI4
         wHp6VMbJEeukdybwO7TRyZBHVlMRJKeqGJH8tyIASZ77ziFi/HQHO28Hg1fWv8euipLa
         lgKIbAAT9kf2fnV5Ha+NEaTklpla5wLpjUhnL51/YY9jlYwN2RSBR2WT1x8uNGpI5ooL
         OJQEPYf10rjAakR8Rx1BWGrNYLfgBVKpMoT7e2B6YtVsQUu77KEjsezf5Z3Dso26/ffY
         B5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778617953; x=1779222753;
        h=cc:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q6bLlWzsZHxTKwI8h2tfKnH8AsKS+KM39iZ5XG/RwLQ=;
        b=UQm7h2iCONm1S3yMndtxw/rlQIQcSiKeoYrNbL8L0lv7wnmV7FNiPECGg1Z+mTVbF/
         t+kdxesHDHPNy1EfUnpT7t3f/NgCpHb34sN/8PpDEyItKZhv8SPBnYtrq2dcWGYgHefc
         VnF7a0Zay7nWOZTbiDkKcJEdyiXZnxNiYJiIPfpCcz7iYQ0mmAaYypuZdJ+2yJHH+0mv
         htTO3KdVHiZe2EtHTj8I+2tDpfzmseA25BJjoWV/3MER3O92xW7DTDaiXl/kJZ+KOB1G
         dlNwBX9mH0Db7KcIq7D5Tkhc4KC5nRksNkziedtl1BL+rnQZMudW9p37cI/EXFNq06y4
         uqUA==
X-Forwarded-Encrypted: i=1; AFNElJ9J7k3oMVts3I+GzXV82ZSZvf1UchW6NmXcoNFsYYHkQtdIz3fICg4VnSKk0/QmeDU0aaKczdAZdw==@kvack.org
X-Gm-Message-State: AOJu0YyDTT0aVvGJxxi7Q9+tBheHpB5u7p8sY3YtoQaPhy4iHrKoz83e
	YZmgWv6rHooMPuER9veNp+Y0VJQlLRVbuImvnP2rea9r1DbTcHIFLp8IsPaZ7yLrs6KGXSLyWzU
	kXyX21w==
X-Received: from pfbg7.prod.google.com ([2002:a05:6a00:ae07:b0:837:c09c:9cce])
 (user=fmayle job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:328c:b0:82f:2a78:6302
 with SMTP id d2e1a72fcca58-83f042789d4mr222577b3a.26.1778617952888; Tue, 12
 May 2026 13:32:32 -0700 (PDT)
Date: Tue, 12 May 2026 13:31:36 -0700
In-Reply-To: <20260512203154.754075-1-fmayle@google.com>
Mime-Version: 1.0
References: <20260512203154.754075-1-fmayle@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260512203154.754075-3-fmayle@google.com>
Subject: [PATCH 2/2] mm/readahead: simplify page_cache_ra_unbounded loop
 counter reset
From: Frederick Mayle <fmayle@google.com>
Cc: android-mm@google.com, kernel-team@android.com, 
	Frederick Mayle <fmayle@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: zowthkwbkp7c3mqgz4wp51ymdm1dse11
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F09540007
X-Rspamd-Server: rspam07
X-HE-Tag: 1778617954-379183
X-HE-Meta: U2FsdGVkX1+I5ZMNWbCMMrdsQC0JL5UgTzF9Pb7SOXwNiTr4VWI7YPRSH5dQPkMqs5qb/OAX6fwfSSQhWsuo2H1FdUd69XQs7uBzgW2UH5XnorY2gAGwf7UHuRCgY6NBhh3VltUyxhvl85M7h+q5wL4AVhCIY1Rnoq1rhRqCSja8AjuFAUM1+zjH8EJcNbcOa3hukvFXDvq3taFOtdxbDssSD3RJlgt+9UfbcC6U3H3iSckIFVDAMODh7CxYld49ArygSIYG75ngGw1I8wYv9xWOZjZYbS4ky8EQoe7bd0zFBtG9hk5WmYA57HGkwSfnwOOBmKY3snc369fWrRiToNBtbo2K+osE88Glh+RogYJax29J5O8zlBTzkeESfW77BxD0gtEsphx5o2iXqqvecvM+K3CUvJceHddLf+LDq5DEkwuIV70HP4kUaQPYwPf47gieXspxbJQCqLE4fUBVoRIHx22KGcRTyrn/ycDNp9wmw150pyl8cYEA2DLPpEORNNO9uxiYPKaGiroxzJ9t2vUOm8gHTY6385UafrECxjRQNtFiOpjmCQqH7AOKDTHtDMrs/rSgZlEXxxc0r3ipUTjJDnl3Ag6ROMNpJd+v+emuNomDrV+8inJVSpj3EizfmBYH78hskqVNzZRvTeEjWNPWK3jd2KeBkZKcMkIrbDIdg6MMekzldhdH9muwpcji58A3v4jesR8nJ+XGGs209pW/dfMfUqVunL/x4zJpF8mkDnVEsV1UAs5pgTAYKP9Att5XvvYQxLdOiRuFJqkg5NXyiQcoAhZyejKhFQ5IUqvDWxtbQuSiA5dums1y7czutuljANHJs1f9lyO22Z8YUJIJ8tVpS4hQ0l96YNQkY1plJcHrpig1eKamT4niSJO+CfDnU6KeucHrzygEi2lMLRZ0o7PzPJfU8I2L7WL8zwmpxiz0fAuFw4/Fu0gYZxLvdaa9gN7iAFW5+rHagNo
 4I8pEmHe
 OqCDE6zTqVIfoEleo69iqXXla+sqN0hWmh/w+75ZfNsE4VXWR4e/vmQhRez/kaTNdcSyOGfr96wLc5EuQQtaVJ9D5tvDyKRuxCw2RTlKbRRneA5QiTI0kc3due0sAOBRFQY13iOvfJA7KmHhIQk6djEIKGyPy/YNX2K9TQ2Rvrv4NyuFtgpiDFhwfu3xE1b3nWFCWf/iDsNrJuhCtcsUk6xJ1INqT7L5KNxP31Xffa8D20FmMQu+v9pq8m/kJtGGKh/7SD3FHBou5n8+ZJX+Pc5Q58Dsbq76PPuwpDz5o8/2T2xqOerzsRuajor/a/nCT6G8x5D/90K0d6b5VTlIAh5kVIAzT2oodVHhwmjc2hREBZJO2wN+lkphQrTBlyJ1FJOOqfFJnJKMRsd3cOx/O2Kj3gb9fkw+ezDt+46VPNL1FU8ILKKSc54GKTC2/y/AnoG5iHrhz9/rLAj8T2fvAzXUU2fy1COkGMw9oeVoy8q35fx78X3tEJX/P/08h5vdnlKzIAQJItN2tTRGkj6BMOG0BdIBGE7tfRQBA/1WwUlMKXXQSiD2flaJy2eojAzLgbaEWrfYqFHMev/BeLESys0UYHR531zn07FDtnZL3rq88nrfkk9MNFKmRo98bMr1aLmGEfjPdf7nA+CQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Minor cleanup, no behavior change intended.

`read_pages` ensures that `ractl->_nr_pages` is zero before it returns,
so the `ractl->_nr_pages` term in these expressions contributes nothing.
This seems to have been true since the statements were introduced in
commit f615bd5c4725f ("mm/readahead: Handle ractl nr_pages being
modified").

The new expression has an intuitive explanation. When filesystems
perform readahead, they increment `ractl->_index` by the number of pages
processed, so, after `read_pages` returns, `ractl->_index` points to the
first page after those already processed. `index` points to the first
page considered in the loop. So, `ractl->_index - index` is the number
of pages processed by the loop so far.

Signed-off-by: Frederick Mayle <fmayle@google.com>
---
 mm/readahead.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 23bec5497308..42f2f20633b0 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -281,7 +281,7 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 			 */
 			read_pages(ractl);
 			ractl->_index += min_nrpages;
-			i = ractl->_index + ractl->_nr_pages - index;
+			i = ractl->_index - index;
 			continue;
 		}
 
@@ -297,7 +297,7 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 				break;
 			read_pages(ractl);
 			ractl->_index += min_nrpages;
-			i = ractl->_index + ractl->_nr_pages - index;
+			i = ractl->_index - index;
 			continue;
 		}
 		if (i == mark)
-- 
2.54.0.563.g4f69b47b94-goog


