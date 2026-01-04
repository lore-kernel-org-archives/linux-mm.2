Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FA60C2A06C
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 05:41:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66C246B0095; Sun,  4 Jan 2026 00:41:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 616126B0096; Sun,  4 Jan 2026 00:41:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E8066B0098; Sun,  4 Jan 2026 00:41:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5DE6B0095
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 00:41:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC36EB6D44
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 05:41:34 +0000 (UTC)
X-FDA: 84293184108.30.262C9DA
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id E4325C0007
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 05:41:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z0M1TEdb;
	spf=pass (imf28.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767505293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rpl0DJg2v/KakAKdFhQZ5XDWhxnaAUoonNHKQfZhl3w=;
	b=vII5XNptaWA2JKOmI5PHbqFbQIAGjyR1cXQxc9V2SoHAnPCEi+4nM9LBuj9oWA8krv1SIX
	1Lv95ZAZ68KNLRAANbFR21ciYsc5aIzfKvfI4LxM1wYC7cjXg8KpUM8Q2jFh3G3mPywjB1
	r18f4SRbFekAgb4vMDwrkzu9Vw1HWr0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z0M1TEdb;
	spf=pass (imf28.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767505293; a=rsa-sha256;
	cv=none;
	b=3RerB/x6AWg/THK/PtPf+uGPlsQAvPXOjo7IMF3Kef19gIKt3lKXJjfI66AleeBdb7u8C6
	/a7G7w9/9lUK/pwDXT+KHYQQbtUJ3xQMYW549V0xhJf4PxoBJpYZTC71tFvdC7a/t1gmqY
	4+wEljqAcBR3W4RgO/iuO9teL8lsvAw=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7aab061e7cbso17428733b3a.1
        for <linux-mm@kvack.org>; Sat, 03 Jan 2026 21:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767505292; x=1768110092; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rpl0DJg2v/KakAKdFhQZ5XDWhxnaAUoonNHKQfZhl3w=;
        b=Z0M1TEdbkD8vLSCSmMEE4IMtuKR1hbodDf/BMYmQ36tTpGN0WDhTUUZ93fvAVJq1j9
         Bf9lsecI72YqAhERs6VSi/3nKg2hJoTmBDw+U4ZOjgB/YoEmz5jevJboJeWafIi/k7sC
         BjxnJOnEhgGDk1pcNUFtvylJKNjbZUjyD50mehiBvlLWwft0lP2rB4WONKvwvlUvTt0h
         GGvITzRDYFBXzLWhbJ3b3mjZGEJg+ZqjtxnLkNxL3ViTUm6zgDVdpwCdbQAZEaYs5tZM
         wY0FKhl3/h1+FmAZlBIqSvLjd8Fyypr71CTzHDrKmkaO3fSVcxIv9iyBJv1yQP2mW3c/
         Xm5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767505292; x=1768110092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rpl0DJg2v/KakAKdFhQZ5XDWhxnaAUoonNHKQfZhl3w=;
        b=EUDeno0/dFb9O2/81ZHFdaWAH806Cv2oRKvFs10pXbG3nos49AmNk3WSZ0AVDs5gQj
         f3ukAwRfYxU5uqVqk7z/EuWMF+01CXb0T61T5S6MCpDNR6UEDKsuq31LwBIIzg3i0dVx
         GjzdMQmf3qRKjhbcovHclT0pjdqG3w9R1Sp9krWqXSxQ1RAehx8cM0soIFy6uGlmvt2R
         1STm9OzhxJ8i+TP4GcPzEn3LZKIN/54gDbNifkm5B/NwqcfUE83/InQYWB4w81gBwgQE
         XsvLS7eXNyBzhmUcbNy+7uBxfuE33/WMJtBZqzWjmgUhyVEqy4zD0yu2Y248R9vr33oP
         OqaA==
X-Forwarded-Encrypted: i=1; AJvYcCUFy9tY4z6+j+GKdcTatQLEFmHCbahY5lu81JvzsTsLlmxgWu7+iwqUkUVxJjkaIxRB5YoJX8A1zA==@kvack.org
X-Gm-Message-State: AOJu0YyNo6TthtCXRMZdNnPtRkcRHt3RogmiHDayS6JKKprWoLr2uIJ8
	5iknhDHqDTEmF4MFSMob9/5Uq7fNsHIWiI4MHT7Wnj7Oku2Ao3pIt1pR
X-Gm-Gg: AY/fxX41yUkKlvu6to5I2/0ONIb/gx8uyZmjxCF80LP3/s2QCLff+ET5C5gZ3pZddP3
	vxaXNDMVfJvE8ZKBrkglw7Qg5Jgv/jdYPkJrqdfZaqCA+xzSmZ65QBYxyVA/6TX9v22kavxytRH
	SYBLD5Bt829CyaZ0yJsQh/EfBeTSRQF5hQGpdkhLIVPIAAOaXxfA9Uc5TfvTPO+rOWGkZg54QT0
	FNZrMfVbFyE6jCSI7CX6475O3kbCHj/YgwjAPb4/tp5sshr4Ye0PaJePWEuUSv3cltCe7w7xcWy
	U4I6XgZBfrlr8/URj5D/857Oyf4esB0qbPpYjUuHVDHgJ4Whdw7ORsCAwbMKpb16ybdV2u9R9Dz
	Xk+5r52jCqJXMN26nwchDdthr+Drh2II3hW1ndjE9/A0xUlCM2rCwyFr3wXSf/eLLmEqMW1gGva
	M97dttZq9q/lf9a86S+KihW9vJF6g8
X-Google-Smtp-Source: AGHT+IFdgXlhA+f0858RuZwqzqH7rMm8CggQEup+GBlChYcdnewuKcV3RbKYDUtgdiXOZ/Cbz/FXfA==
X-Received: by 2002:a05:6a00:4217:b0:7e2:c0d5:372d with SMTP id d2e1a72fcca58-7ff64404001mr41125060b3a.11.1767505291778;
        Sat, 03 Jan 2026 21:41:31 -0800 (PST)
Received: from localhost.localdomain ([121.232.80.251])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7b31c479sm44378305b3a.24.2026.01.03.21.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 21:41:31 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
X-Google-Original-From: Vernon Yang <yanglincheng@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	richard.weiyang@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v3 1/6] mm: khugepaged: add trace_mm_khugepaged_scan event
Date: Sun,  4 Jan 2026 13:41:07 +0800
Message-ID: <20260104054112.4541-2-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260104054112.4541-1-yanglincheng@kylinos.cn>
References: <20260104054112.4541-1-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E4325C0007
X-Stat-Signature: 43xusf8pnxjr54oaje3zom61jhu34w9b
X-HE-Tag: 1767505292-337921
X-HE-Meta: U2FsdGVkX183hJ8cmSCxMwFj6YA23tUk5mmPKYSDdhViuPtVcp6aaly6SNdrW7tavzwEmZ4OKMKGDZKdl3GccnqLeVOo9lolFKYuRhZ6no1A4Cpb3HdOxZsshQX+sBI50qCr6Q5ZlgaFD//eL/oEMiviPK2oMXQKSkQ0+FcHOorSyub+rySgo2F9hXFFb/lvZhHo/iGAXcd/g0hdp4UwhK+47DWOoQfIxP5R8dtJXvEuSc0wF/Tx5hNtf5E/zN1mCwMkyV0Elm8xA7SlIM3c47Wwofhs6ikExx269f+1PwspftMfKg2t2w7VnSHGGchnvt2blwTvYlSvBkOjKoBaTnpA+GT58dQDiUgQijxYRHVWDRea+VMCX1W5fEKu1lOvM2z7puK8PLJdIsUHecLjtkuBJS9HUyNgTn/R5WE6awHobeIha5n80gVLCakZmh5IGng9opsZXznAm2T45axkPS2Bi3DBDl3JOjHhvNTC5rMX/Y8ZhG6UB9lfN0hSi+XLUaJNGJSAhAKLcPDGxrIvwZAmepjx7Z5OtQzgvJizoeU3+oMPrDVP2PS6p5tXdMwBNosb2wftZWh7XbkNPNijiazGBuhLG37lwxdq1BD0dyRtixQy24i+LeDc4D100lvYifuAPT4Z6EC/y1RCA88nOKl83fD0qcRdZeN3lsLdqRz7BOO2c2o08Qgnk0/W8tAZE1HPVFF+jQilIzfU1ZMsGMpNaVApNENb/s9HvJbxKt5KR/FD/m14qotNNrlMnUgX/6UlpmEYEhroNHINWMmYimwhZ12M+Z48pVcuM9ZLDxDQ6Kfb2H8tfIIQ2Habvq5fMJNlJrcNNGvQck53y+0BoGAlx5J9pItVd15lbQSvCgimuixiI1pvMmwhb2ZqpLChzayeAXPZ6rV0AbZDgORda5UG9zZg7MsZ+5M4pKdy9gv1JLPm+bSPfG2egqTxSwOw0zHRARJi5H1iuFl5ioP
 3RMVzDKO
 YUGZG2XN/1Kkphdh7XKWL416Iibn6o+Ryv+Ii4YCeBEoe36MQ9X/JH8qgun2DGWci80tt3jAgO1v1yF44RxhHFrsBONFxjSw5PKJRlgIAY6MobXVMj5Gi6VV+rzCrEsftVoSK/6Y5WCYgnOmt7ctdEuzQahxJ/z7uP0C4iC+hAQ3NEnOUBKyN5LMsdCmuAmkJ/4Fl2/eYAmbkj1wK13mueNO1V1owp67zz68GBfxWH7TrPYAsh6LbIiLX9NJI1oAuIM/Zbdsd6sayfSVLoQe5woRFeFYxYgcaBPjeGRm3xeq9+iBjw6fl0x5Bbn+ZG6L65lX8xoM0UeOzP0VwXGPm5y7a/6/xpHdDelLLt2qtTCv9ymO4DeveorwD0Iejry3MeRxi/N2AvKCeYoAJXWapj7D4sSXxarzAS3aM8jHP2BmgyXn9EWqZ2ebfCygr/K3VYJFJR0ZylYaQl35VpeTRjTu/n3rVU2Tp36o1UcmOqkDAKZfv7IPzXEUK2cOV/E1FMo7fBGw5bLRZDC6WmgcHytlsW91QcdBFwEy871Vh/EoBCQ8BWRltF5Vwbg==
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
index 4cde53b45a85..01225dd27ad5 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -236,5 +236,29 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
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
index 97d1b2824386..9f99f61689f8 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2533,6 +2533,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 		collect_mm_slot(slot);
 	}
 
+	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
+
 	return progress;
 }
 
-- 
2.51.0


