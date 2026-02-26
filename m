Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7715FC5921
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 19:29:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1495E6B0205; Thu, 26 Feb 2026 14:29:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D7A86B0207; Thu, 26 Feb 2026 14:29:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF09C6B0208; Thu, 26 Feb 2026 14:29:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D65C16B0205
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:29:44 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 98E091B3EA2
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:29:44 +0000 (UTC)
X-FDA: 84487597488.12.62000AC
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf11.hostedemail.com (Postfix) with ESMTP id CB4A140008
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:29:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GTFTfHGj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772134182; a=rsa-sha256;
	cv=none;
	b=AbekGkiI0CUi9R+FkJOwsn1pick39Mtkt9Wh+2Yh8u9TqwIgczCLl40b9Z0ntCFwpqR1OM
	3qVDPPQEs6j0VR1IA0UQ2CV0nsIBnEX7COl8cvjAw6leYgPWrhrZjQ16PmoLaZnq5G8gin
	mQ3+/9A3s+sSDAxK/Ok0cQE9UWcSXbg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GTFTfHGj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772134182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GxU9M0uqLwBLhcOAnkTTmqCLiEjdRi64cRGLMJGuVY4=;
	b=i4nnZxj8fTxz7quTXzIF5Qlb+HuuLTRXg1VXkhO8noivDB+NnlRtjdZdp3gFc6t6rUQF+Q
	N+Kl7cBojU0+J6pFqIMxxoQPeUTBPf8gpcrbWicXAgcVRShSS4slASPk2g2q9HTi3O+auw
	zpSwLCEM+dv9QcWgWZAHoLdqRi9KZcU=
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7d1959ba05cso555432a34.2
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772134182; x=1772738982; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GxU9M0uqLwBLhcOAnkTTmqCLiEjdRi64cRGLMJGuVY4=;
        b=GTFTfHGj362BhKERx67IvN/a7cGA/YjXezGrKvri/zND0pdlX1a/DVC2uy5wsgpLlk
         oKV0i14ATSEk9+4oqWE4tko8cIUd0/iWTbPc7WChCFVsFSKcNWnmgH6VfPRm9G+TGGU7
         2Pne+oztd3E0sQMo4gRyhkXsm+vr+yGoPsXRfyOJYeh9Qoc/D7mR/1qfbLPSTA2jW4SB
         VEE+wF6GuGN4qDEgSOaOGzC4mAcQU6tQu2UirNapVOBbhj8/YEFMt7NzdGNDgGyMZcqo
         xWii1UBwFH9Layp9QpsB2melfKjwV6H671Fg59a10d5q7Vc/jJjwVf6zN638XmCPvvbt
         tZrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772134182; x=1772738982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GxU9M0uqLwBLhcOAnkTTmqCLiEjdRi64cRGLMJGuVY4=;
        b=guEp6OMDispOy+sEtlBHKZaQOSIZ2AB7Ul1vTbsi4A3axcPN6k54154cxhNdXAQ9Zb
         862KRAS4UlJfw668omgcxoTIpANWQSDl2/zTu5KbGeG+juo0FaI4EoW8HNuuyo9lsYY0
         vGvdARFYQd+hw12XzYkv/f92O66q5Siksw9h0zzOfXT0SSMc6FSsmgpXQ5Tmv8jIcLYO
         GKEtpRWuZksyvFLrKmtJYISbcKDe2PuvI/NTBFSO4idECU+vXGE26rNdAltxHCR+Rv8f
         TjMwywWwSwtg3lj5r3XFLi80aedfOXri+Fu4b5QZAaOq20WIoRS8he45naMOHqLPDIzi
         PPLA==
X-Forwarded-Encrypted: i=1; AJvYcCVdP5RTD+TniQZSnJCjBq1dIP3bkN4fzF03EhrN0rKbV9RPq8lWmPxyFFNphMJpZe/hmQurimu2zQ==@kvack.org
X-Gm-Message-State: AOJu0Yz9tc3sdtUOcXmL4XT7p8Ih0sni7D9IUeGCsKwiNZgWuAs6Jo4d
	ajLRE1BqFRWnhBQ54sRKJkMQd8cHawi+JsqyFJAAA19j2rCj3ueqqpyF
X-Gm-Gg: ATEYQzyKxt+P3WcsgUhncCvcozP/GFhHVb7XYVptEDbmSK4S9iCVZ1N7QCqCU/XOS2N
	o41wTw8SVW2pajuzPLmiKEOvr5scDtj8Cmid8THYO8CkVj2aJhA9Fc6DY+f2NTSMogIeDe7sEEa
	u4y4LECkR29ZS81XzZmRR6Rpj9nJSnJPtoVC2HDV94DEaD1FllyPk0HEcl5nf1O7gyE+3guhotr
	qQGB49EkUBDboU1Tq2vfZjig1y6rzpZGaCuQhg7MGANFqPAlIkayiqZFYkVOnCSlZbJT/KwDEpj
	exT0sKaH0efXImr/cZ/T+5tHToZIJi6x7CjipCviJ/ouFzEQxubVw/bfDrewluGp1d58f2No1J/
	TG4+HW0bxV+ix3hRb3o7BgDlVA2SJcBzk4QhNX9mgF7qiMgO35HPjXymM8fISWEayvnW5PsL5oM
	U2wLZvavHsLLZqTQiFrnSG
X-Received: by 2002:a05:6830:81ce:b0:7cf:ddb7:8823 with SMTP id 46e09a7af769-7d591b34e79mr366803a34.11.1772134181770;
        Thu, 26 Feb 2026 11:29:41 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:3::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d586625e4esm2415605a34.15.2026.02.26.11.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 11:29:41 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 1/8] mm/zsmalloc: Rename zs_object_copy to zs_obj_copy
Date: Thu, 26 Feb 2026 11:29:24 -0800
Message-ID: <20260226192936.3190275-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260226192936.3190275-1-joshua.hahnjy@gmail.com>
References: <20260226192936.3190275-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CB4A140008
X-Stat-Signature: yexacbxmtuqpzg384qk9ypekktn7tr5m
X-Rspam-User: 
X-HE-Tag: 1772134182-348202
X-HE-Meta: U2FsdGVkX19L4LLB6kV9dVZxsZ4b2N4WekmjwIbO7+af3tKbjPr4zLVLXJSODaOiZgCqlhHuQqwaeVKxXJuaI6qDgZoKDlq8rytufZoEZ1rKR6FZHl0xSQQcPU6d2o1iKzqxJvPLqLSyX3GS2ABvMLuOz2VdkGmAiorYAT4szTyB5bXdLbSGAFIKqp0z2j1DWe7Z85alwUvZEaKY5wK9TAH3z5AcPt/EbETW2hOMbKxMyA0hpGmK4PeKWPDO5oIB5l/SpQzdYM5TkMCJep0XZKxTYF4ALLcxijAyFoMmdkIen2JYrpapqLMd2C5lpGxoQuxvBaNs4PzR7mXcNpODm/VviBC8GCXRoXvGU2pxSMLtj3AyQrfYOKWQ8HZCYS0rdtxNCPs4DZs0hqndoIurVyNQ+ZZTNm+dxWFCpcQRXZzOXCQOxU9qdTPRXhvYHjO2RqqNH57mZOOwmgmnF3gdCA+XCI1ZEtDLTvPiYGp1iES4TfcdOu5wB8Tg4kaz+YOPSQxBZcdvyPP8yTvy8v6UC77y/IqWGpCcq/hi6asweWzmgE0l2OwkMUsbW1wKQUwaxRw/Sz3B2i+qfHAsFPPNj0KmtqRlVMWPoGLfQ7mZxBipe4fjyfndyt546XpVziTGe5ryPoX2NtnCQN+Mcn0pz9+vG4/EvsWtiUUsWhGrji8p6cp2ZELTMb7vNM/m/YpwLlygU/ZZmU/94/sIKs9LVT6Af1JVSTeEdXFAsGJq702D0pXz/VCdJSjij6W5vkNHKSNv4X3Huscsv45I0FiP0YufBYOjVpovvkuER3sg80w69xAsxIWKdFTO56uVWbwTX8qfx7MqsxjXs/W9yPnjP2CiSSthdoGCv2pDIqdQReFioxUgyfM7YIV5GQUaSOG6+3uwpULXYUEKCeMjoVcUGAbDK4QjRxmziE/OhNtaNwrZcX7GBGsOZdv+bHK9LQAkqKwMiHiW64SDvkgo3fM
 H/c337sz
 2vT728QHj+7hTTRdT7mp861CbJK/yZNT6BVPuDSuoxuQvz71fWmgazW8RMLCXDzsnCXgobEiiH6qeLTl61igPYi2j6XMk3+5V+QG+F5s+nF0tSEAQjH/VNa2cQZokfcSYs6JI+eE2xZOMqWygqKGxTlLNGMtPhOReS1WIcOfLtnTCq5A39TLuGgI5aUL2fed7O6RxgtnReYrOd2htD5zn4c9l+TsCK09S1daQiOuaFairmCJYShPpmhSFyb0jpVouArTBOmdq4Ief75LInNOvvyOjlx0KqcRWXoehbM3/yhi9KX5lHGp9XOnGWHPG6OvsTbmytX1C+7V+OQcXVStFjt7ilacJkNCwrYWTr5+7AT4B0Pi7yaWu3MsWTnoWGxTdpPxZqlHFiZeDdzb5jIRrMhL1VWfg4t/tj54RdGX/z3SfWoH18pwDKhkSjBeuRd8hNoOzGFmIrdRG3mMXu7NsvULkF6CPKmAYSYKW3Rf8ZLNY3hUTNRdyJ7lqJNSk5yfp+1WlmasPK3/QHew12exh/eq8qSNBhc6CVZSs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All the zsmalloc functions that operate on a zsmalloc object (encoded
location values) are named "zs_obj_xxx", except for zs_object_copy.

Rename zs_object_copy to zs_obj_copy to conform to the pattern.
No functional changes intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/zsmalloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index d5d1c27b3852..0ca2e94af5ad 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1416,7 +1416,7 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 }
 EXPORT_SYMBOL_GPL(zs_free);
 
-static void zs_object_copy(struct size_class *class, unsigned long dst,
+static void zs_obj_copy(struct size_class *class, unsigned long dst,
 				unsigned long src)
 {
 	struct zpdesc *s_zpdesc, *d_zpdesc;
@@ -1537,7 +1537,7 @@ static void migrate_zspage(struct zs_pool *pool, struct zspage *src_zspage,
 
 		used_obj = handle_to_obj(handle);
 		free_obj = obj_malloc(pool, dst_zspage, handle);
-		zs_object_copy(class, free_obj, used_obj);
+		zs_obj_copy(class, free_obj, used_obj);
 		obj_idx++;
 		obj_free(class->size, used_obj);
 
-- 
2.47.3


