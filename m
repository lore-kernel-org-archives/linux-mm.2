Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2E41D7234B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36CAC6B043A; Fri, 23 Jan 2026 03:23:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C4D96B043C; Fri, 23 Jan 2026 03:23:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BE936B043D; Fri, 23 Jan 2026 03:23:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 09B2A6B043A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:23:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B515C1A01F4
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:23:03 +0000 (UTC)
X-FDA: 84362538246.27.B3C8AD0
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id E12DF2000B
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:23:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CxjUcNtq;
	spf=pass (imf03.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769156581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NPVrcdkZH2YRU1Jo6XFkYQwOXRIVFhmIZ9Yfhc/+QHk=;
	b=616Rs1Np/6QO87ZKHzJ/k7niyL2YHqnFUwY2hvf0FAROgqMfUpKTEYSSfDWV2ZDAa5EVjh
	W2dSMY5s0fibahzuwQOBy7G7zOcKlDFridnue2UnjBpjJZ2/5lA7SJ+Vo1gpC4nfxNjAgw
	MDfOF/ciwDZmaCdHM0jlUSRdJ8OYWX8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CxjUcNtq;
	spf=pass (imf03.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769156582; a=rsa-sha256;
	cv=none;
	b=srQvx+4HEwObO7v3SymeOiq8FX5OUd4rNFVh8YqfpbAe2HBzYv85X0iqReDbDdKV6RRQMA
	1liRdFqdjMHrneOw9SdNuCLmsemfRfk8t/hxyAm/D2482OK6Ii8ao8kgUpQRAzijhvXOky
	9bdvaUxf9ODP/CmkSLbP32nzzlDG72c=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-82307c6902eso773798b3a.3
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 00:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769156581; x=1769761381; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NPVrcdkZH2YRU1Jo6XFkYQwOXRIVFhmIZ9Yfhc/+QHk=;
        b=CxjUcNtqqFzImhRqoqq3WM5I4GzBwXgTck2h0JgB2uv3g75XSjoVmNyCQaYh0CVWOh
         j345GyIz4nswSlM4EBDuqKDtFitLi5o8O9WwD88956GewVLO4jzY6JJ4v3iArLISYsQz
         Xn6ek83pA8LuCWYKynMmS/nCGYyH6CttobdniF2wDQuUfwqrLSKpVR7G1teJX1rJcq4o
         XqTAakiZpk2KiEv5YehpgAwtA6zYFwq0UP3r1mnN3KYoSXMSq44etV3o9CBI/vtAu1iS
         pzRoyetGhI2UvVpCdv1bh7yMfNHE/vjhYg8C33mHtmpjuigSZzxtOBCIfPxVpQs/F4P+
         xucA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769156581; x=1769761381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NPVrcdkZH2YRU1Jo6XFkYQwOXRIVFhmIZ9Yfhc/+QHk=;
        b=JAKgdw+L7Mw5J1EoyfGiVj4F2VhYCmU0t5+jUs4amkaXx0fkil+shNZVQs75tYgwiy
         xstnCLah3SzmmJE8ScnNtcOq0owVCQmCawj/cvoDUaOHRH0vJHIlPOPPaiNL+FuKmKjx
         tXpaQD9w4Zm9rau7EmXwsgUIvFLtqvFQTPkAXbQ2Q+VKLvVLMyg3KUl9id39MKOHKH//
         BQfcEWLmbAXS5ameeMCsXAc4A7BAKJepE0aWQ00tHwdwhJ/iQXKP6ObX+6uIT1TsnLng
         r10U6fX99owMYtiCFFRpHymebXYdcw+YmcJsPkRf0J9q3JWZTDp8skRyqCDY867rDrSE
         5Z+w==
X-Forwarded-Encrypted: i=1; AJvYcCV16dt/HwhwBC1ZW3jlapDRaBE8Ul2kOkSA+O9K+NDRcfvMZ/KGGjBTE0KpBbzI1uN745NLbel5iQ==@kvack.org
X-Gm-Message-State: AOJu0YxvT0Tl2diuPY9QTfIEd6oS0Wb1uk3rUIFhM2VAzZWhZkaQgq4D
	YalW8gX2xeHuK6zDkbAFU22cMEZq7xe7qo66NS3oYBH/V6i4oBzybZJ8
X-Gm-Gg: AZuq6aKSywq02XR7kZms9ihrIykvDUEBRS7PfrnoJ/uAIk8Ppgf/JNqKEdrp8At8Byk
	QrgLMJTYKOE6ABB+/Cg5vvYv2o3hoKzogwduabKHa0NugHCXdePgJxSR+/kaCOxhJdcpeYTG1yu
	VTFmvyCPVGLWydZ471MI0tuJkD+XxhL7mfWTBzCi935cVlQIGjnmvx+moefp6gtbBIxdgWeLmJM
	Xdt2azyGLk4PL0Sk+GF33nqAhFaFW6Y7zKIAYIpxCFHqbjqxNn5C8b1S+Bj7lcM/DrhwpF4IgKK
	oO81MXNDDt5lboQXtrxg4+LIZebG16VKCu6wvA4jcRHA2rbeUXvN1Gm+2ci8tUqWUZlrVXP6LKZ
	R0wsRpN/ppCTevb36ZnYqQQQ1hTkiqOebx9vh1wEXe1ttv+AQJrmxuKcj3RuM3lNwnxPITquRmM
	IETPUpkokMwsS+P0uWTbvXFky2N3ZaSPMI8HU=
X-Received: by 2002:a05:6a20:7490:b0:366:14ac:e20a with SMTP id adf61e73a8af0-38e77340a5dmr644811637.72.1769156580724;
        Fri, 23 Jan 2026 00:23:00 -0800 (PST)
Received: from localhost.localdomain ([221.227.246.159])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c635a43f11csm1348363a12.35.2026.01.23.00.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 00:23:00 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
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
Subject: [PATCH mm-new v5 1/5] mm: khugepaged: add trace_mm_khugepaged_scan event
Date: Fri, 23 Jan 2026 16:22:28 +0800
Message-ID: <20260123082232.16413-2-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260123082232.16413-1-vernon2gm@gmail.com>
References: <20260123082232.16413-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gtp56kc7dk5jbd6wkcjz8r3rkbgs5smr
X-Rspamd-Queue-Id: E12DF2000B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769156581-371094
X-HE-Meta: U2FsdGVkX1+BBM080y7yfNhQ+L+dCd19AHIqqlHKH65NJpJo7ZVwcVgrX+LtjHk2yy6AEU6SKN3ccSdF6etXbSXaXFtmKUg5TeTWhmGVVf6ULC1TzPhHSKBlH8Fa6eVsU3/n3yZrsS6Y8FTwBGN60NL8OSBjqPfY7gZXXSBIU70i7MA8CdcBcUR41XTwooygIS9f6BuJb+pizD+QkamnMHBVBUy+li+Fk8nqIZ5Reg78mvixBEEFpIRMgvmNzx3sKQ2E4LWfyCf+lp5gUJ7Ll9MkVQLWrIY7vWoT+ByVci36eSz+C1iU37ABC4mlrYH4E+nw1QguALHL6wjHSggZSlG7woc7UZd0qPISOmMyb9DlGzaP4Y9d+YyycHVYcBw88THzwNtfIG1aJqQSSlbhSVLC+Tg58b9VTtyIXh3pRGCCYV3oisy+d/qrQt0/etPagU+UapsNh26Z3hpn+uyJJJjiJthCgp788j4mkQMaWtZYF0ichEKqys4GG5b8D+p00mcleQKZ3axrEbQO7tMknZ1yl2r+54Q0Def0DVnAwY0SB4os9WIGW3NmKoLUmpVioTGFXHT3EhxKXWellEwvj2PlaN2GhhPKnCWkZyEP6o3eBlFomMVCFrNAitPyjhjqrblI7YhyT9pI6659OJql0NmWwwxEhujz+9bQea5AX7HjgH9t8nYaUewO49N50cjB2/Fy660aAcEjI06nMuALo3k9r4Tdgg/Ms263dqKTZxuRHsOVIVCZQA+6DIdwn/m+mYqZGd3H34GUVh2e3XAdsF7mpGgfaXps6rW8poVCF4YnW3zYhufFcht1K9f50WFgtrKJmlP82WCjQbXFpIk/0K0iiozoT3iQrwys5cd7a/xpEagRr3i4x35la5evGxOR1J1VgL9J9cZ6aAbWrG1PVjnvYyc4SUv6UGZ9IiZN1kXedTwV6ype/tdGwmBNK+Hed+Ru91qoJ1J9kv32czR
 ITU7qU+A
 4/FWBQ1pD1OttpZ15LzsczP5YLjkNAHqe9JJyX5ivNXdSqo8zwlIHlOLyiB/1pa1Aq0R25IZED3tJecT409/RcuzQw0kDS/RX5gcsFXOAlFeYe2g4PsPfgfPNxwZA8mNLX1LFGt0Ju+6p1ssFFe9nRvav8b5Zhnqsi5U4cNV9DPNnqzuWflMwftqiEzHOTV7DndQZp58KohqeQDeNqosnhTnBUFaoWo1b9K5kt0ghzmTHVH974vQwR5rjJWxRfxy2UbCAyOSfwgdlkx21CVESFJknaO1fClrOhdAkuTpbiPvP8H+V5JJOLnHoQLTgKLQa2V0YAznA8TxoEcQDtTTdOzdmAy0oYi8yFBlj1WfnBYgebpl3JTJ2567abUrK6z58ODBRGpnVycM/Y/YAAsd0QpccB6aq5yGVb+Juu2XMXfhPRBRPOKbK2yb861cZt0Q2IkYp1OnL3tL83VQmCb7HnzwVJgYK911jojruGXHBRROprh3OmRtJBh49vrtdSOvAXZYNRlGLNImM4IW4ftkjqFFtyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

Add mm_khugepaged_scan event to track the total time for full scan
and the total number of pages scanned of khugepaged.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
---
 include/trace/events/huge_memory.h | 25 +++++++++++++++++++++++++
 mm/khugepaged.c                    |  2 ++
 2 files changed, 27 insertions(+)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 4e41bff31888..384e29f6bef0 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -237,5 +237,30 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
 		__print_symbolic(__entry->result, SCAN_STATUS))
 );
 
+TRACE_EVENT(mm_khugepaged_scan,
+
+	TP_PROTO(struct mm_struct *mm, unsigned int progress,
+		 bool full_scan_finished),
+
+	TP_ARGS(mm, progress, full_scan_finished),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(unsigned int, progress)
+		__field(bool, full_scan_finished)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->progress = progress;
+		__entry->full_scan_finished = full_scan_finished;
+	),
+
+	TP_printk("mm=%p, progress=%u, full_scan_finished=%d",
+		__entry->mm,
+		__entry->progress,
+		__entry->full_scan_finished)
+);
+
 #endif /* __HUGE_MEMORY_H */
 #include <trace/define_trace.h>
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e76f42243534..6f0f05148765 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2535,6 +2535,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 		collect_mm_slot(slot);
 	}
 
+	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
+
 	return progress;
 }
 
-- 
2.51.0


