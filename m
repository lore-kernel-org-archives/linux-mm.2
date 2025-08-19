Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D44CA0EE4
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 03:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD08A6B00B0; Mon, 18 Aug 2025 23:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA8686B00B1; Mon, 18 Aug 2025 23:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E54A6B00B3; Mon, 18 Aug 2025 23:27:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C82E6B00B0
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 23:27:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 39D8414020A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:27:04 +0000 (UTC)
X-FDA: 83792070768.07.EE83C87
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6D9D280004
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:27:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X25J5cHp;
	spf=pass (imf30.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755574022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vr68yBZi3TFfbnXKqi+esYUOPsHcYPZ3pVlLEo5gGLw=;
	b=t7RLiSbTzjIIA9qG5wdIF5p9V5I5qWRz1gxEHQGBScUzdJvtuUy9y3Nb6T08f+ANq0pv2m
	tb72k3b6eJKgXOzldAHL6MqHVyJhw5A19gjP/A/r1zyoQISnY+6NFiwixVnHg70LeEq/z0
	cVkZEBJTzvtKS4xeiNHNG1EhmLrs6v4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X25J5cHp;
	spf=pass (imf30.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755574022; a=rsa-sha256;
	cv=none;
	b=ztNJ7n2IDKXziDDjKQcdjgm1FmXymF445+0wSc7C3XjrWJWsqHTd4Qa1MEemLbSME6fN5j
	iqXELP7ZhE5komTfod1ApSKnWsP6oJoIXqZe0cv33JbpwZ5DDSDVu6Jod3Unz2Qwohiku6
	Tc2dkpcF3YXEhkKfiwa+EUO3asYptqk=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-244580536efso33746935ad.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 20:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755574021; x=1756178821; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vr68yBZi3TFfbnXKqi+esYUOPsHcYPZ3pVlLEo5gGLw=;
        b=X25J5cHpZGk5rDdSRhiAcoY4+8a5+qTj1Yk7wGMAgq5irQ2k3fXmUCNtU9vdOs7rxv
         Dq8e8qQVi5nq624Zbtdi7AwY0FmU+z/Y0HfwUID+SgDzmDL1KaGz33HoyfHbU0ONNYgU
         NwtFy+teSrymgVfusfeFLqkB7VDY0Wgklxw9UIK5ywkoHkwxZ0AkyjRygV4szdCH2tUY
         XVPH9XZ2lJzHiZlsDGta9Gxfk/UvIb6IjIZVnTxapVZBlJZVGqdbSG2/IUUvmuWwWIT4
         CpDYvNc1AnqwCrZhf1iww/1ehOZYYqQsi4SRc8pXKLASsXSGFuzac81ohT5NjLNrGxHP
         qhBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755574021; x=1756178821;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vr68yBZi3TFfbnXKqi+esYUOPsHcYPZ3pVlLEo5gGLw=;
        b=GenD6XYnLU/2X5brWkIe1SDPJJWydjDENJb0vrRvp76d8xjOKeTT3mk75b7xLsSLA8
         W50u8yvelNRCsgRNKlxpTWQzbY+OGRrpH7gZTy64iuKYe5ov4oMbU4UowFhgFiAEgG3C
         K4Mx15j5dlwQrSS1iHgqqt8waDqu/frDJ4EspxrR1lMvsb3vz/IHbFRDTLsAfXpVOjqM
         SOAKYUjshoFMwfhUUO496AYf3LTAGIVWY2dv2Y4na7o1S/n0JWvy+jiQg0VxgedmgWjU
         CVnobte8IyiK2p+KUWC6FU2AozYrMWZ9fT+QKe8D1ddGJElm8fUxEdIEtfeVEgHDp0ke
         FUQA==
X-Forwarded-Encrypted: i=1; AJvYcCVJYC1edlA5fvppwnz6FdmK0d5L+m9PWrNeqFFJNgNk8a64KS3KkthQX7hTXxIqGFQa/JtKADP2Iw==@kvack.org
X-Gm-Message-State: AOJu0YxBOczLIrLKD3DQk+4bZ94kQCLjb3P4BOwmlE7FuGMbWoIKRnSj
	8QHX3nb/WxseZOQEy9RFC/OVZwzi+rgT7LInlj0ZuJd7eCGLAgeW3tve
X-Gm-Gg: ASbGnctXAiKc25B1+CZTEs9rcq/h80+kVVTeLKVCfC36+L10p9uEBZM4pT4YvxAcBKu
	QJrxhXscjrr2K4FfG+GrC8scbu+cMHKIiamp+q6sHYZLBtZcQdjFutxkRYXZGE/6KQpeSwfAfoJ
	80RyBNmLA1KpZdzXjTSgwybdw9bkvUDk0DNY9wo8AgGrMMYP3rSNBDlE1mlZHtMAPMCkchQNPba
	H+EWd4aNTargHSH16Q5NmK9g9e0298qgXA0NFAE/dujfhNif453klKIgICvk2Sxtf1/OQZutEgA
	i0nfbn7YvW2e+IXBAUehtLtOmcRYsA2IbAqM/QpFGLWJFWup9WPvUjtM+gCcRLrGoffYw5hlnOi
	bas8tZRAV6UDgDR5oTE0hAGy28o4PTKWOzg0Lo7Pn9UlViMQ++otQnUopXKhz0r1e0TnJitiPWK
	Y=
X-Google-Smtp-Source: AGHT+IFwjWO9fZD3g8LIFOJO7X2Wija0jcyJGdc8SrAd/SCDg7XngqtnwRQL5pP5IA0IXoJApdAKBA==
X-Received: by 2002:a17:903:3c4e:b0:23d:fa9a:80ac with SMTP id d9443c01a7336-245e031010dmr12452115ad.16.1755574021175;
        Mon, 18 Aug 2025 20:27:01 -0700 (PDT)
Received: from bj-kjy-standalone-gaoxiang17.mioffice.cn ([43.224.245.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446ca9d99csm93979715ad.24.2025.08.18.20.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 20:27:00 -0700 (PDT)
From: Xiang Gao <gxxa03070307@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com
Cc: lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	gaoxiang17 <gaoxiang17@xiaomi.com>
Subject: [PATCH] mm/cma: add available_count and total count in trace_cma_alloc_start
Date: Tue, 19 Aug 2025 11:26:54 +0800
Message-Id: <20250819032654.4345-1-gxxa03070307@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 44f4nde3b5s778p6ej5qkn8cdw1nimcz
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D9D280004
X-Rspamd-Server: rspam05
X-HE-Tag: 1755574022-642034
X-HE-Meta: U2FsdGVkX1/1HKqi5HbcbUq9F2BU/p8m+pPG5J0yrNrq5lNaHtNtDRU/dGIIaEiwnCbvQugq8gAjb0w7dTGLl7a/pQGATzSRmLfIdZydRYDbbfHy3No95JmH7awdcHpIceVsU7KNJMiR4hXZEZWVPqNiNVfWbhJCXO60t/KqeE49p7oXkwpj5uN2DmZHYz3dfDc+F825PdctKOzrEkLE2R/3wV1m3orVaWK4/llv1iOAYbnWE+VEZGlYthLGtGz/O+sse23SnR11LraZboIpNyDaBpAiQ9tlM7tmQ1/IujbVf5dTjgIB9aDTMYBS+Wt2j2bW2ZTnQbur/8TlZe8adE48xOpQ32bzraIU+rhxDUgSb9NKsAW2Zp73wGbVGqjPUHJrkbCAN+vGeIwHIIwqfrCQiLdGhJTe1GTjV5JbqFivfDd1YyNEJGpHl/65U9AOehDy6ibR1tNuEZO6gEzljNp535XxX4VFQj4TLNocUTUccl2OA7rRcIY3F4tDj+IS5ZusOLi07Ls2x6cMu5MMD5E7csjnjFRSSvXMyGjjeq/y8UStP3pZBRpvlGcftxJ0lEAoLpOSuald1X4L3Q3C2FtaafUJuIDYqT6WS7uI6WIs5ZP2cJ9jjHKLe8aw66FeV+HSlHhZyG0/xcA5U+C3/iAXHrue8r7n7viFpHMA83TV+vkzvLE+PzR7miAZ2LgVOuHt2hAJOcrYIOoPJWBz2QndUeqZX4CH+AxXjjuiFl7NDhsEDTr5y1RcEHHvze8Zgv1XRTml8lqaF7oQFYH/WMmIH5bEZ1vIkOSgaTMd7dZRZLAad2nexRBoEVIFnKnJ1FTvY2pkTYzpN97uajgGVzidr5IGmvg4VzBVIlFO2RzLQL8ArFKmiD8BgJeuJlZ+xSM6KyN2ZWkQJHAJOOkFGGc/AkAqq4nG/u3QSEwWtAiVEze2RT1nlPk1myIE+NtKcZwzqlEwy6nn0Y7m82o
 963Xzq2L
 HorZhAQbo/M59o4MEemp1yT1naVonmIjMWpSic0GcMlutk6bs6YgEqjKVMTz9N8ytHuP2TxXyX+OXvrN7wpqw4GQAwBkw5XF/AemXw/Yv10t2/8SF1ttDTE2yxOPT8v6Pu5LDJIvRhF7lIf2zt2p1QkZs9ZDcs+l5avDU8mGU7T4rBsjGa262GbwChp0Dc6Br4hBRjv3yOaIF0IZTIAqof7PcxF8/TZDzMj2i+i+8h/LWgcJrEOU9i8VXBEIeOGq+YHhz0FqS5Anf99hSeE58jnHD+xC1TDe/oahVlCMfBlYCuQ1CwMZjo/mBwRZe3g4Q3slCAy4cJWsg+jBzOP0b9nvL/fLybqi7FA8ejeIeMgM6VbwqV5R0HCpVuLk28uV4sA4NUm6QqB5gOyLUbGqzceSomxGeeTNihGxV7UaetKVjx20J//6XyDkY7psNLrSyhLLUyE7C9pzu41E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: gaoxiang17 <gaoxiang17@xiaomi.com>

This makes cma info more intuitive during debugging.

Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>
---
 include/trace/events/cma.h | 17 ++++++++++++-----
 mm/cma.c                   |  2 +-
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/trace/events/cma.h b/include/trace/events/cma.h
index 383c09f583ac..fbe70008ffc7 100644
--- a/include/trace/events/cma.h
+++ b/include/trace/events/cma.h
@@ -38,25 +38,32 @@ TRACE_EVENT(cma_release,
 
 TRACE_EVENT(cma_alloc_start,
 
-	TP_PROTO(const char *name, unsigned long count, unsigned int align),
+	TP_PROTO(const char *name, unsigned long request_count, unsigned long available_count,
+		unsigned long total_count, unsigned int align),
 
-	TP_ARGS(name, count, align),
+	TP_ARGS(name, request_count, available_count, total_count, align),
 
 	TP_STRUCT__entry(
 		__string(name, name)
-		__field(unsigned long, count)
+		__field(unsigned long, request_count)
+		__field(unsigned long, available_count)
+		__field(unsigned long, total_count)
 		__field(unsigned int, align)
 	),
 
 	TP_fast_assign(
 		__assign_str(name);
-		__entry->count = count;
+		__entry->count = request_count;
+		__entry->available_count = available_count;
+		__entry->total_count = total_count;
 		__entry->align = align;
 	),
 
 	TP_printk("name=%s count=%lu align=%u",
 		  __get_str(name),
-		  __entry->count,
+		  __entry->request_count,
+		  __entry->available_count,
+		  __entry->total_count,
 		  __entry->align)
 );
 
diff --git a/mm/cma.c b/mm/cma.c
index 2ffa4befb99a..e56ec64d0567 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -864,7 +864,7 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
 	if (!count)
 		return page;
 
-	trace_cma_alloc_start(name, count, align);
+	trace_cma_alloc_start(name, count, cma->available_count, cma->count, align);
 
 	for (r = 0; r < cma->nranges; r++) {
 		page = NULL;
-- 
2.34.1


