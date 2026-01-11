Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E360D2502E
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 12:19:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FD9D6B0089; Sun, 11 Jan 2026 07:19:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A75B6B008A; Sun, 11 Jan 2026 07:19:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F16226B008C; Sun, 11 Jan 2026 07:19:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE5D56B0089
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 07:19:42 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7EE061AD32A
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 12:19:42 +0000 (UTC)
X-FDA: 84319589004.24.13573DC
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 92D9BC000C
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 12:19:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rd4CMYKr;
	spf=pass (imf28.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768133980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ci4bwqZz1BI8ky/Etxr2jWaIj/tqNbukbL1aId5SFks=;
	b=bHOLVKf6hmz2mGNmb7r5BCKs3UnFWi2FBejA2UjRrfSWQ46YVEyTgUzXNiPYrWpwbAPYgV
	0S69Ie479HuEzlgOejc44ukibX2pdfSShR5GPc57nqKWr+xjI6DDoa2oM+0KVEQQGk6Jzv
	H24MsOWMDBG6FLEy923LutMwOC7lWuE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rd4CMYKr;
	spf=pass (imf28.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768133980; a=rsa-sha256;
	cv=none;
	b=LAN2+6gAKFBBERJzfwvFvV+5gkOCkumxWpOwYhvSeFB2qqqFDQ8chRu7H5m6UPF4FFlFNZ
	w7nTC/hb8Xz7Juic1MK0w4z/j9sIi7QZmX4HTEgaJ3+b5m5vXdr7j3vWau4V+np2p/0lUP
	6Lh9pduZ8bxZfG9TD6KaDCKoubwV51A=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-34c7d0c5ddaso2389822a91.0
        for <linux-mm@kvack.org>; Sun, 11 Jan 2026 04:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768133979; x=1768738779; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ci4bwqZz1BI8ky/Etxr2jWaIj/tqNbukbL1aId5SFks=;
        b=Rd4CMYKrU2PQqy2vULwevcsn/DpDRw0q4sUqSB6jeAqv0yx8ua5x+/KuMcwK7BjXBC
         7ofFAnyPhFByo3Zb93wF2kbzK/uSxLv0eimyXpMZs5Tr5e0u7AzWze8SNZbLymGH6OoX
         61Uj7p/CeHCc9NgewzKxoNDHn/gthJnDkDaDu0GjuIQ9DOKzgMJ/8NlxTOy5YBuQUOXf
         BojPWx78kp/Dqsssv0bfBnUny+p2wZEnHKIHoh7A2FY/9KUn9dn8X2NKn3sX0YFhHRC7
         5Lou8z5D4RCwjtzlnlGe+Fr2Risw6a3lhPcftjwI1f2lFyedc4vJ3WrhgE6EgeeuQDlG
         jDxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768133979; x=1768738779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ci4bwqZz1BI8ky/Etxr2jWaIj/tqNbukbL1aId5SFks=;
        b=VFHGgjc1J1ZhiL3feAPc30ynobiYentFBgmcL7yCJtXQVIz/bf2nfdnuKtONfkoMcS
         3XkkCS0MyYdD7dVVshTdTMuiOaWt2zXuQy8iZRSLeCMocFHzjc1CEV9cixVkGGORLNkk
         8z+O58oqlvS4poeBDVrrpxn/4cwJ8ToKWa753ifOkasa8gCac+hXXby+fEWUw31lsFuN
         QC+RJuW+DJZYNieRALLjNeAqmtMbbS4Bb+EPB/AiZFgmIhunH9kbeVQqSREBhmjyiMfm
         9MtG9ElX/lApIpqQdcWa82QT2u002/KnRaRZcUk5lSeD8/n4IOdf+8Rs2dNNw1lG0WpG
         vFQw==
X-Forwarded-Encrypted: i=1; AJvYcCW/7u/SWmSuDK//HxcbSyTd7ly7UcuHYkX1o/HOoSeOuCdxk1N/y//iudHzwdo+DrLZo9+jT7c9SQ==@kvack.org
X-Gm-Message-State: AOJu0YwO4AVWsG0sTCCSYcJ6vArb/WZ3p3dBGjLksF1F8Lp2ZcsvvSpk
	0Rll5QjcaaGrmP3CrCbsrr2GghVCyuDUHr2+hszN0Vj73tk5P+Nc/eyW
X-Gm-Gg: AY/fxX4RhUn1wEceMvSa9jimgy2y3uAojZqvHr7ht9dPwWJYLoe/Eqk8q/sUoLYSAoN
	YvUwRNsuMPWKfUaMraePwwBuFSwzC+v3ej8KizKFpDfU1TxeMNLXGCzrb1gV+oUW+sG9T8VbUns
	40I3nZ1nHf5gN7g/gcKQsVjXmT+69Cy2hod7KCEJwevH5YmVHewzf8fzNHzLQrNkqbzDp7DYjRN
	aAKnSqH1c2djKINPrwTyQDk2oSpI9Fz7sESV85kAS917PtFc/MCar9UiTNYRJwnrPLDsTR7+M3n
	+1ZL/lDVwYxFOxjPRd6ZFe0X26OB0LqmKxzLGlSfHtv0/s6qTK9ZvwYqkY9ZE/VILkh4fLT6pw/
	mlNONjNG4EFnPwQYS2JX3JJm5lx49ngGI8BrwzVo5xhLveDoh7j6Pxywr/LaJCIgezpJEBZbZ/A
	dRW/BAnD5V0jBPXFnXON2ODFmBAQefwlELg944xty1
X-Google-Smtp-Source: AGHT+IFH2xsCT3CG7f7DYogW77RlqSSEClZMKIQyo43ry1EWvc24Y940VBQIwPn8aGgvf8ovWZ9/lA==
X-Received: by 2002:a17:90b:57f0:b0:343:6a63:85d5 with SMTP id 98e67ed59e1d1-34f68c2799emr12946073a91.16.1768133979341;
        Sun, 11 Jan 2026 04:19:39 -0800 (PST)
Received: from localhost.localdomain ([221.227.246.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f6b07029fsm4877954a91.2.2026.01.11.04.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 04:19:38 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
X-Google-Original-From: Vernon Yang <yanglincheng@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH mm-new v4 1/6] mm: khugepaged: add trace_mm_khugepaged_scan event
Date: Sun, 11 Jan 2026 20:19:04 +0800
Message-ID: <20260111121909.8410-2-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111121909.8410-1-yanglincheng@kylinos.cn>
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 92D9BC000C
X-Stat-Signature: 3x4tzh7mztnc6yb11pyca4qwoy53kucy
X-HE-Tag: 1768133980-842400
X-HE-Meta: U2FsdGVkX19WDOfrkb+znEJ8VPaSsw2lXoCZHLuRH6POK7JwYi6o2G4gVY2GOJ0Fco3wVvGt9QxUY/Q1LjrJU5xAtnD7jEOTTko3Sdz+A92M2xlRH03cQhIq5eJJ/KWmxVj7RjH9jH+QlFu1GRYv8IeE0yKHtIDzAYS7vXo0XahoPEEpmeczw0bVF+8iy4G4v1yF7KtNEW/7gFP2wL4fl/fZHYGvpxUyBg2WUbB0OXn16xOrKmiAqgB2eRmY221ddKfoOgQBCXyaPwTp8CFkvjFTowHnT2hqOJzrfwUGsW2PZK36+RnZB4X3/1jlXrwFpExjuHMYepM9QI2Qgq0b3a0WfohWuxqfypb3boXIt54oz4c5FxdtKFgQGIc6KPDxqNTpG74/XbQxEED3NBUKU5pTw3jSgi1WP/ungRAnE3ViqzW2NJHEy9O8sOrBezFfoW66yPV9aXPUyV4GmAWenrNvnBQmAo1kbGYPqNqamU3USiai8qyM2PbczJFmrgV0UwgzhfKa/9vCIUzEtTlnmI1dBQR2kQVzopvfQN5GUyYp1iEGMz6f0gnDK5yk06IsmOVVg4AWlL+54lb2BH2KoPd+GGhhMrGbus1c90BHEqO9eh/WdS6bbMLYq+qqp2xUd1jk5iVxHUKRmWByVF9WComwmMXkhTxRCmErWpRbMq7fWLPAU7rObWiQExC4Tq9B7GFrGhnbfCrwv6JS86Ke4h8OoIZgY09h54OZ0cZCHMJ7LMNNfFRDLQeni/CCid8K1AziXqpVKJUYcPOBaJY6wjXbtB1HOnhSQjiCuuqSlZg/BnxZiCMg4ySQqb6pxY7pqU6XwcsSvHdZqPi03sS+M6ma9CdhISVhT3N7y1A6HadBofALTAKic+SBPhc7xdjgJCoOLkGKEZETKYEz2eAFOv8bbDyPofstxyrlcOSDBJfhmoQGeynXVxCdi0yNImRBw9d4nebp2YulXS9oPE8
 pWZEdvEU
 l531459Opka1xUVTIf4Z9U0+mcH3oa+6K9txxZRD9QYHpbAGyjYz8fQ4/2+Fn69gSKruEwBW0eoHiM12F1E5lRnypb+/H2HHU15XGr3xGpAlqtPBNekVqlqUTLHYZthQeUCbVwoRpBXBKJfsbd966h1nRgE9j378VAEunC/1G1mKn0nEwxApXUlYjvZ9zFcq3YH3nyqrF7Mw5DQETCuWo0TUZV6hBWKcOUubronY0iziTFhGP4DBQRObD43Dir7PuUtsHFZy8JwBl3657JS4qFxnUEJPFEAbYfLoFbyN+fW4sI02rn5ze9cUY09MzAwxTm3Bz1r2R/5HEJU6yFy1kWU9U2+Fpv5vQ+BhsX6f/4ha1Ib35XTTnFS7R8/S8Q/JGg1fZqj4XreT9jZ2sAnHORzW4r5WEUTF63r8pZHLtNcY3O+iX8iwSHhaxk6N7B7pK39S1JJRMnodhImFOip4ztnCxg6UW84457d/MiFCvy/k3xas=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add mm_khugepaged_scan event to track the total time for full scan
and the total number of pages scanned of khugepaged.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 include/trace/events/huge_memory.h | 24 ++++++++++++++++++++++++
 mm/khugepaged.c                    |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 4e41bff31888..3d1069c3f0c5 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -237,5 +237,29 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
 		__print_symbolic(__entry->result, SCAN_STATUS))
 );
 
+TRACE_EVENT(mm_khugepaged_scan,
+
+	TP_PROTO(struct mm_struct *mm, int progress, bool full_scan_finished),
+
+	TP_ARGS(mm, progress, full_scan_finished),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(int, progress)
+		__field(bool, full_scan_finished)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->progress = progress;
+		__entry->full_scan_finished = full_scan_finished;
+	),
+
+	TP_printk("mm=%p, progress=%d, full_scan_finished=%d",
+		__entry->mm,
+		__entry->progress,
+		__entry->full_scan_finished)
+);
+
 #endif /* __HUGE_MEMORY_H */
 #include <trace/define_trace.h>
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 9f790ec34400..2e570f83778c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2545,6 +2545,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 		collect_mm_slot(slot);
 	}
 
+	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
+
 	return progress;
 }
 
-- 
2.51.0


