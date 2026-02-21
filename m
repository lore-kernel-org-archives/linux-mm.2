Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BF9BC61DDE
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 09:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62C9E6B0005; Sat, 21 Feb 2026 04:39:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DA4D6B0089; Sat, 21 Feb 2026 04:39:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D9966B008A; Sat, 21 Feb 2026 04:39:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37C526B0005
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 04:39:57 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BFB33160358
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 09:39:56 +0000 (UTC)
X-FDA: 84467967192.01.7366CE3
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id B78D880002
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 09:39:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L+7QMAVr;
	spf=pass (imf02.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771666794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eRhfRltQOpryarjivZ7aunnsdQEKu4QRgnr74+an19Y=;
	b=tdU101tzve4zqCKJdxzEsr8atWa6StbbYqcukbR9iGIZeCPfQPxExaiMsB84sGBW17JnQ1
	RpKUC2T8edsrO6KXLAfU7exIo0QwerQ9F2zui+KT1iihLUm+gd6cpBMrarRZWLUilWn2yz
	Mq6empu9I/PG2RutakHT4QOT6Wz7Mz8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L+7QMAVr;
	spf=pass (imf02.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771666794; a=rsa-sha256;
	cv=none;
	b=RQ0iCGWivSO1Ra6Cd/bCDBHiPfpDdsLqe2SkITMA+OQKGaHK9OquR1K+wguuH1XMBPvroV
	sxq9zL6y1TDjMbzfmmccLRTIEv8gto+riypw79XS98y+4StJp6mBLJJqRxdaQhztsXm/zx
	tIN4owPFgXO1+dPG1ASznX+3vBuaVFg=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-824a6f2d816so1314243b3a.3
        for <linux-mm@kvack.org>; Sat, 21 Feb 2026 01:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771666794; x=1772271594; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eRhfRltQOpryarjivZ7aunnsdQEKu4QRgnr74+an19Y=;
        b=L+7QMAVrsgtsWhfo6Rifbf7m1e+ejrXdci0rucbNIebqcpnC6BaXbqLOzPzGAw1Fxp
         1ycGXuHFznyCU/za3BMwG+cm3XO6lXWAKTijTvYW+fGMWCupdsVrNe1O6ZYgcoI+OOwn
         OqiNYXvEJHMA1zDWgmAXKwF0oatekiN/iMAW/rac3UFwWcjCdXbJXjVCCwkS65Jub9X5
         hyshAyLlsnGCvYWboN0OtQLx3RN4lZ1rNiBZYvV726KjosS18cYgG+7RayVxeKamRybu
         UqSDqyc+G+4i6Pz0guHulfBII6frLzN+2HO5VJgdLB1rShkrZbLNACPGrHQKSQZPU1yz
         d7jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771666794; x=1772271594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eRhfRltQOpryarjivZ7aunnsdQEKu4QRgnr74+an19Y=;
        b=f+IaoUy9hHRAjv4GGvaIVkKf/KiOQ9xYRaHaCVZrJGnlxEWDuXxMiothwXC8GlXmR3
         XMEfxE6rWUI6Rx7Gf3ELaPhCYOyjRXgKdF1QIh6QZcnKtgWRVRkdylLdZqYIXRpWrmV6
         od0lBbSCE/SUEHI0JlDbpLngB1ZTuGuXNQS0UMK25Pv2lZOYz0Ta0d7CeRCZQRIASywy
         tHAFHGbsqByuNPhygS0PCtH0k5UulcGeTezmsb/yggCMuk3aKeNtBS2ol0vS4/8nmbRg
         7swLxCckqOM4n4ZccZznP+DVGTuiIq+Vc9g0LEnQ4zmjC6IMoALS7aedh42m97f1M2wk
         f7XQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUIYSBFhnTO/Mmzn9ZuYnx8s/fuvslsIqRuT6+a4wx7ICxZoJILiO6j7YKxwXoFMZCOyyAXUY4/Q==@kvack.org
X-Gm-Message-State: AOJu0Yx1110d1A0tiu/HVzZT8QFthvfStgx8otUOY/jpT+J8A6zkszYg
	t24mCc6fphTnEVvw9xwnZJPMRiwdnyw5JBJCu/7ejBEV71Z6HVSyKLt9
X-Gm-Gg: AZuq6aKIL1wT+foqdOeLCfNakNQzwdhjdta6m9n7rIlWlprEWMcaC/uErVMuik+ss60
	BqPtVx1KgX03uNdQCwSBBp+QYzO6ndVaNjj+QWa7pjL2uSLLAD7mZTlSSzTFuB4HSnOZQ2ysIPv
	BI+qqZuzAjDLOK3REJUXhE/n7iMEqFraeEowwXHWHimk+U/exrFgS+00Qm2wySc/Y5rYIfsYhmB
	14AU8lEy9zR87wO36wTo7s9fl3Rd3Td4XhMHASMhNXG2CRkmCPPuic6UWuZoDa5jEtl7cwstWbU
	JR63/Crf5oRYM0MO4r7qXio5EwyWU+SItvz/5qHJhYLTf+pUyBleg6Tb9KNwIGrFh9lnUVKAi9G
	/6YDTT1LJa2M6Yv2ENwcHe6yy7ADlC5m35vMju0TXXjqFHbz5aN2STYhCfIgeEByUluEyecCJfw
	h85x4pAKCjauGlQQ7HOCSyDQ0Ts2FHnPL43igVaG/WpLwd
X-Received: by 2002:a05:6a00:4189:b0:824:a8ec:ed51 with SMTP id d2e1a72fcca58-826da91f743mr1678128b3a.27.1771666793584;
        Sat, 21 Feb 2026 01:39:53 -0800 (PST)
Received: from localhost.localdomain ([49.79.21.101])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-826dd8ba11bsm1761708b3a.50.2026.02.21.01.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Feb 2026 01:39:53 -0800 (PST)
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
Subject: [PATCH mm-new v8 1/4] mm: khugepaged: add trace_mm_khugepaged_scan event
Date: Sat, 21 Feb 2026 17:39:15 +0800
Message-ID: <20260221093918.1456187-2-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260221093918.1456187-1-vernon2gm@gmail.com>
References: <20260221093918.1456187-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B78D880002
X-Rspamd-Server: rspam02
X-Stat-Signature: jgq9t3ie6aj63xebks6wrn9qn4q6cddi
X-HE-Tag: 1771666794-883479
X-HE-Meta: U2FsdGVkX1/AG97acjacdVHIjYpeQ5LjbhJ1PkKNQn8xEyGMtGYaNeffrLVNYNI3L5s9Fl00OaWMlXkZIYxKGlmpBbLnqvTFFI5rNAsYcm01Pf/hrNxw3It7QFqk2EUWDS4JUsmAGwc+k7TY/3vaxZEj42dpMKId5X+8IXPNmIpFbaFBdvEsi6Y1zPOwHg6eY2bFH3Yx2H2gh2YtiTlqrAl3woiZHQeVoEapuX5lAHkvaaXgqkO5FilJsKLQgcQVeRukBNEIC8AkIgeb5G+GB//sCNpnjmnqEBu5uq7ACPoXqSQtQkd7Oip3TTs4DSPf5Ci1MbAdH5oVbkckKnVLF3Dm6TfPxKB9pRSzZlu6Ee5Rlu3U8PYcR2FZGEJEncNDw8APu464uJg7qrgucCccMs6DskMcZ5Hz/G0rjyjyuS4KSBLu2xQjk5jadl0YF9gP1lXLFKMCRFcEZj0HUOsqOVnV+1qwy+e91zJgckU7SyINGFRlJTS8x/Qefeiv6b1Oi91XZdPo8yAKE/ypBGWxgZZ/nNZx+2jn9fuuGNFdoqKkJZUUx+2hQKd1XBAedYThgT7f+3maUoTruETX7wv7k5DwNC4zhfqQItVrL1BL5APorp0B/FwXTGoCoY/I9+GfWb9WJRZQv99yPLYAQvMn56WBYSjjGFyRAhhVEpdTAdUtr38KDHAz8wYiqe8gEamvqPFeWCv+QV5jn465uW3McKDEu6DJnE7BlqUN1JGW2h9U2DLXn2rqS3ZzHFeyj7Q3GxYc4cv66sPss5m1v51DRxevDXaWw6sO7PlFbCgniQQ0u9dMVFfvuqaYayttkAxmyob26T8Z7IUOuM20iu+SKdi589j7Xcd9udfXzuMhq5RzR7tOMsYKFJhAlsyoPOaYg8j4EygOaSSMMhJxf4whELgUXltlqvDdiEWVD25jALyBbRBmcseRPPKxUDzYXOfyI8brY3RZb8GR9aTg6NA
 LuY+05de
 noAkkXhlRxB0rORNsLtojDIM4M73owB3dAvWqISZatOhhsJhKq9trfKVQwfMkeRruJSWdzavafuets+M8DG5ha4S5qS7w1xmAVW6z3Y4WRrZy5HMIdoXrpoqrwmv6nHbXofgqQ6zDNSIXWR94grexG8ZihvsLveRuUlMN5oLo770ag8TolRrL/w6o5NUv+4OPFzL0Uq4/XPhkABe4XTUmk6ul0m6cbXYSSH7BIgllPIIouENbay0neQd1z34xlGn7V2y2NKNFc3M5nwwhhj6jEuvKelCQknhZwfJxEzaFPfmKTjkAaIJmvLJ2mLD/1tyFD1x6KVYZ+61NOX8PuPDGcCjCbsiF2pI++yXLKVNz7p0nSE9SE6kQJSWBoTzj8fSsHOQivYM8g0Dr6Bys7JaEbemuTCDOEb/JNoDl+khbd0YGsERRVHZH+8LPaHukFdJ98grKzm0LSfh5BYNI2y2ilrilPv/Q8Zetic7Lk+TtfvVNWKzSOm/P/Nq4u4YOAN+eA3WWBMTDO7fisZ8pT19d1jcQEBPbhbg4nlrO5hZiO7EzQyMOO6EM+O3+KTLwlOBpMrIiIkOKanbPamKIuPWIQyjdj3xNV7A/ZDYN7v0YbXYjYxs=
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
index c0f893bebcff..e2f6b68a0011 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2527,6 +2527,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 		collect_mm_slot(slot);
 	}
 
+	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
+
 	return progress;
 }
 
-- 
2.51.0


