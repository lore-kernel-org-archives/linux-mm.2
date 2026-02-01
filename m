Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EE34E7C71C
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 12:26:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A8B46B0089; Sun,  1 Feb 2026 07:26:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3491D6B008A; Sun,  1 Feb 2026 07:26:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 241076B008C; Sun,  1 Feb 2026 07:26:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 178E26B0089
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 07:26:47 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B01C25BAD1
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 12:26:46 +0000 (UTC)
X-FDA: 84395811612.07.3BBA3DC
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id DEEF940008
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 12:26:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MtKHy0jv;
	spf=pass (imf12.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769948804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S2QkQq6f6BhxvJCwuPAb4algJqA9XG0jgqYj1vlwjKY=;
	b=xh5L8a5M+w3oiUkcXUubqqUXS9OY3iKjaP8nR2bJEc+EQGhIzeN+9pMH9cJF4IZzsbOC1Y
	ASKfUbiSjlg610caRWCdG2FwVVgNJQjxBWH1rIOEtWn1kL+qiTquHC+mHoJ1apXm6wat5W
	4vYMimRNXaANirmcu3lZI0A48la5yQQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MtKHy0jv;
	spf=pass (imf12.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769948804; a=rsa-sha256;
	cv=none;
	b=jUVbU2gxJzQmbpGmZr3q4r+XRf6+/3Wp7LtX16LQiK/eJnm7dzBTDOwfYXedPM8OGdtfdI
	VEOy7BnMrNbYw+oQPZNLjVVlKt/Wav6Cj0dgu5FRXgZTzgrtjO3qzmBu+Q3C93OdCxknkH
	EgLa+Ws3vR7+h3dBUvlrShUnshPZDYk=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a7a9b8ed69so37402035ad.2
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 04:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769948804; x=1770553604; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S2QkQq6f6BhxvJCwuPAb4algJqA9XG0jgqYj1vlwjKY=;
        b=MtKHy0jvXJ4NiQnvI0uqY7/J9yTIGvcrnRhfKY2wrJOhWiB3lYtkD8wbE4vj9SpNjd
         JSnGIVdZ1Pxk0AsZhdg1pe2GO0JAtiTtj7+Xw8HPGsnKyTFsTvXT8/TzJtGm5tu1q1TD
         YxZGRb5flNUqICJ0eN5X/FOX+bKpaAX7NiowaFPVXXz3D5Nmah4SDB4fKGxriN6YbV2u
         f6WuMjZq5M1UFSSpX0xHeP4KgO+Q0MY+83mz/S9V3aJSoRrVcsD6uQVll7Kfo6EKSBug
         TOdvn4E8k9MiV4fSxXVSVl/TCBbtFry7yJO6RHr2mg3S7YcCF/chwgHlX/Sn3aXILRv1
         gWZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769948804; x=1770553604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=S2QkQq6f6BhxvJCwuPAb4algJqA9XG0jgqYj1vlwjKY=;
        b=VNivsKwp5JzpmFSHSA9RWbPwPTSP3fs4AL7o+jOQKM+Sv7S3ZsbxzJdawcpAYfvFiK
         3sKfqA8VtbGxYbeekdE7zNZ53V0v4J1B1wyrXt5MXyo2p39gmxfkMyuwKRjVQMW6e5Bc
         oMcbUM2NnTzi+6FNj+EU4SRzHa0XlTTZ9Cagqvzw5m9FdN1Z02f2ZaURzORYgKnsW5A4
         5LSHZDxbOkA9ylnwk2L4/5HjsOvLgw2qJ2JskPFvDcouRNI86KY+A/kqvOvoU81f9Cn4
         CwivUUzhC86otHO7XEZVgNxMNi7/YMYk3dww8gpxBQDxSrjV4VSG9j5znTqOOn0y1OG8
         8ptQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwkO33Xqq51rxYtKcPxNMvyiWap0Nsaq+w+Tb6/HsDeu1EzEzowHpbfLovn0x7KljiUTpLAkhL3g==@kvack.org
X-Gm-Message-State: AOJu0YwwuzgNHbrA1urM091eln9/jpPwfpqOSoqbWeNyiKFDBTkGRNqt
	6TRD7qb97jQZatmEwOX78oQQ+CyjmokjZHIH7cgtW5/Vz6l+lQvtIW5Z
X-Gm-Gg: AZuq6aLQLnhx6/L0Wdt27AcWzN+6CGBN3Nsko6NmBFW62NkUiuLRoSmkFGi1tWSRMf1
	9Bgx4aSODsN7QcLhLSk81a9jwXWOSTNXFfBsQP4oVIOh2RGsKm3chp75UpwiI02puGHnYDgM2g2
	nI7yAQKKagEPEmA+7oqsIP3ti7QIuyIU5q4DYh06JthqS/dNQlrC4kHwBRMTc/d+xivE4Wy5IK+
	ZqEnfNlpPYH/LzwDvZ5wPDSyCvr3/ui2dm4zBpF0HvOCysjLyhXB42nfp8ItoFZhSn0JX4yTnCV
	eDeoi4ZgTWQJ5uoWpjr32vEshTeYvZSHCjx0LfZraiHo+gnCYoc2499D7spwt8BDaKUYn3phxvf
	+e6Dz6d9vICfcjzrpVn2fx6xs+OHCegMwujS3+CPbwUKy7+YX3OmFKRR5EQD5DZzHdHaR6OgqgB
	FnYe8OzXNShl7yH+dSnyqiStV6
X-Received: by 2002:a17:903:388d:b0:2a7:5171:9222 with SMTP id d9443c01a7336-2a8d9a62833mr92541075ad.49.1769948803766;
        Sun, 01 Feb 2026 04:26:43 -0800 (PST)
Received: from localhost.localdomain ([114.231.118.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b6e5ac4sm116941185ad.86.2026.02.01.04.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 04:26:43 -0800 (PST)
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
Subject: [PATCH mm-new v6 1/5] mm: khugepaged: add trace_mm_khugepaged_scan event
Date: Sun,  1 Feb 2026 20:25:50 +0800
Message-ID: <20260201122554.1470071-2-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260201122554.1470071-1-vernon2gm@gmail.com>
References: <20260201122554.1470071-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DEEF940008
X-Stat-Signature: qzswj36gefgfyphurnupgoofqbbpz9qx
X-Rspam-User: 
X-HE-Tag: 1769948804-707726
X-HE-Meta: U2FsdGVkX1/uc9nUPIiZk04SdvnoNGyifMQRoTek/CqJxOoj6lxNib7n5s38LdEtN42GltjxiKic7hBw8Y+7MB5TQSFAwosWHEoC8lTkRzLSGfa5bK7KI/RROea9k5pGx3E+B4DKxNN9ygLjgwOkMXBAQmvIb8Z08k0cLRi7ZZ5mNM22YB5GbV+DP8ELZwdZbUp+2eZ4EH2us+pIh9XFTqvQKLd2rjow4P3GAD4WBKy07jPrZU6It2pO6x/fHXZBCew+oVvG/JBY+xdNNXlY/HK/PaH4i+vIZhYLEs/4aZ4cu3PKzAROP5kEa0GPAxYbM1XWlq//BSW8JfyhdiaernkjSYPcj6MTqxv2ylJ3QAZGfmZuD74ACgXpvsRbS2jDAlsD58kz+J8crbgg1ek1l6iRlg2P88uZGRtuXVxY5YJ8jDFePL3alm3JjOWxwIhM7adw2YO3ZuGW7zjNqd5bfBewC2mW+S4/z4SLylhYpAUbw1lwyUaqHqgTD21teBahrq4v/sTag82d/xvq43o0cOWNH+aVXwRN09kVbmV1eD9KlEILY5eGKhgJfw4EFE+HT10mRd/DjcMPDIlakBAstuSAxf9/a5EyuQciTfgd8ZjTqKDWBqgUDWOQfjkBxZmoh1X6fUAMYohHpcmLw89zMRo8LysisZBoUCOJlXMaJAZk1qxwDE74V1eL6QcfHGjbqd5ha6JIHqKpT/PMqjIzVH/v81yNojQKtB4l9WloLjKEX0HPYzPJwdbEnBmWP1JNICZiLC/ohFjkz8oWFSfQbIMam3r6N8cn7a7g9SVEzQFoIFBt6OlYYi4ErxSRdqK+KKGN6lvx0bEVpHDzuxqPAU4PV5QC7T949mbKjqq4C1FiX5JMCOWSvc1dLKOm8+6iYyaBA7xLKHg07apTGQhWlNA7hnWbqH0xHYNXRP6WT7QvYei6YBbTkUYAuSBVGHc5Dy1e4RJIJKl+Ahn/vHE
 Ntt2+lyf
 nDgKOlNqMDFInlt0bktg/90dhhc7kE1P+y/qThFE7BVb299vVTGNbnpva315BiCv6V5q2N61HpAEH5nZvhPWl332RetcR/SVBcqVnWG6al7PTybwbasjHj5okoyPv0uu51/yMtV17LJyVduOOMiN4D8TMX3u5tAjoNueXvWV1GKmU1tbDbTqLGfzu2ePVkhIPTVZlILQAEV/rAi3YTYXWWmX8D/7xaxHeXun5GpPkGEYgrbnF5KB/M393kzDKtJoOHnTeLeMghm7slX5V4OdpdTp9Di2MhGyzeue55teLpG8hyXAHCpXgV6WYujp7RxmbJaJeMSejKx0yQQaWCIE24MfdKB6gdHpnaCSOPIsV2EeZV4oMg7TUPVnC56bxppoqq7Dxdomc40WucPET1DzKQDEN6Hk/pgMOo/J/fm5UzVLZq5Ao1YOeLOA/n+ZX4YXrKo3xyAGM8zrlDTgJdJ9U86Y2/XEjR/zK7bxHdK4XR08uqt+jIMPBS1CIs65tCGkLHbwF3qz9vUanT38ll/5KpxHTRbzSAVBO+d22Ccfi2zSEjt0H2x9NK0sNi8kuZ87c+mF1t6aF6lXu+TwgD7p5G1PmYGxuUIhCdlOSFK9JphE7taM=
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
Reviewed-by: Dev Jain <dev.jain@arm.com>
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
index 1d994b6c58c6..d94b34e10bdf 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2534,6 +2534,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 		collect_mm_slot(slot);
 	}
 
+	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
+
 	return progress;
 }
 
-- 
2.51.0


