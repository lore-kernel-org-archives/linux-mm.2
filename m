Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69757CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 13:48:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E25D6B00D3; Tue, 19 Aug 2025 09:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 094316B00D4; Tue, 19 Aug 2025 09:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEB236B00D5; Tue, 19 Aug 2025 09:48:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC14C6B00D3
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:48:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9E89DC0801
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:48:28 +0000 (UTC)
X-FDA: 83793636696.23.FDBAFCF
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id D543C180002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:48:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TC+ZmUoS;
	spf=pass (imf24.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755611306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vr68yBZi3TFfbnXKqi+esYUOPsHcYPZ3pVlLEo5gGLw=;
	b=L9OJgnmI73ZAMUmsCNWjyaFI9KpEcKQK+9pTsrOFdXIp4N25RZRPTY9MNfNGqTei8PJMIg
	UthihX3Ew4cC15lH+uquUF2gpcNSvJZX/zLFHoXrFCDSkKCj+TW9wuzrQeK5w8RjLJH2YO
	o+HJsGCwONmbvT2vHBqqPBCCURZyadY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TC+ZmUoS;
	spf=pass (imf24.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755611306; a=rsa-sha256;
	cv=none;
	b=ZSTx5X1A33z5v0eqp1NZZ+wB7sHwuntk7HJDiTWyM9Iv2KHidWk/7Q7xgjj8vAERUQDHl1
	C4yjUB+SagONSF8UCHO+AfO7GlMKwjfx1SEgLN9lQh525JQ360EKE2KgRGDFlJSALEWsN6
	CtualXNxZ0hswVFOvCa+bvLbR+x9Ew0=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-321cf75482fso5777464a91.0
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755611305; x=1756216105; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vr68yBZi3TFfbnXKqi+esYUOPsHcYPZ3pVlLEo5gGLw=;
        b=TC+ZmUoSZ5JUIRY4L5OhwcVybt0nEhQAZOBuigVCIJLB6ryDbPMklojEKuvdOgcx4b
         zXByUUMJDOLJ/qlQB9HRSS0SqqUMfTkDJwsjJOUarG8Qaz2hAnnDnGj1ERRwQYDMle0+
         5lrCpZ7lo5snI6qug7kQnmew/9KrdPV2VWceoLT1OWn+reo1GfD3jJQ+LEP+cgm5mgeT
         bjL4my8vyA6Jyp/i5QTy7DUNU/XbXg+/jU42vRLEuNbFvQ1O1Q82LiWH/DGg14ibR+Lq
         EtLvMTHy3agMgu/HUlUElnnEjAd6pzXF1snWHX+g0uJPQKetol50OSdrBg/1cuAcwvVH
         v4zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755611305; x=1756216105;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vr68yBZi3TFfbnXKqi+esYUOPsHcYPZ3pVlLEo5gGLw=;
        b=gGdhjxumu+PkNgLQflfFviaCcImwewbC6Kl/aFnbsDX7VbY9myIcV+IksZC0ZktvOq
         OrtS47uafH0Rdf7WbtR5dyo3SmGuMZnS7cg7b27u6vTlycE8bBEJ4QxdVvBbRB6hefYi
         dW3U0uaJdpipqxFB6Jv8ZPfywdRR7CbY7c9ebNIpOniu+kG6UYPeXCqku+WaNzDtRuDk
         UiltxUfAWnLZDha8lCzdEI/VZUzvnIseGGU7DDKT9qASrp/2+Mb5rKflgctP+XMRuy0q
         dmfAW1Tgqt4zdAmFWEnpbOazwxjTDlIQoO3gSq9bXKwYINReEvf1hHS8rUOEff5tNeHJ
         0uOg==
X-Forwarded-Encrypted: i=1; AJvYcCW1vqEFfE60aSHds3SEPJKuoQ8lvBoCg/lQesR0gbzusAkYYetfzJNSfSJkDpx4OKvQMEFJIFsQXg==@kvack.org
X-Gm-Message-State: AOJu0YzAO917aLjF2CsZ34fRyXqrl9Yq+Jh6zEUn8WNjLb9hPKvWNaSB
	SDTHo1lNEipUKqCOe43NC2uEfeLN5z0kES/OVF7CAdxiYuHm5/12iqE7
X-Gm-Gg: ASbGncsBKdrmFIReZa9e/TMiww20Nd7sdjJ5aCZaj5FxfuR1kkbhKIWtUGWVCjhpFLl
	Vre61kqA2s3IXI+SMGysmHDofyArh01DxQkn8Q4JulRGX9GJxL0833J5w6OtOjrt5GCqdnjUJpE
	Wp2U6CpmJSRTeKddP7EEPAxQnAOpTMkWpwb5dMhQOhEXL57ba76OTU37mSQQP149YW4wMgjtj5H
	FWt34EFHzbpfZXgB2rv36GoMWvtlxJcepSdpYV92TDx7b+IS6N1mbbJrq3/KMOE2PmP6BP3gy1M
	3kNn1d5SIoUWCLlr6nE8PzuUKpDVJep/X6ZyjpjOL02zWXcrHyPEmaNof4KVPlWBCvpIL2Beb4C
	ndwgO41Tqgtlzrw5WGbsGc4En2BiTXmAx
X-Google-Smtp-Source: AGHT+IFmyQHU0KuB7WvcyotnFbvRy12e45ykFdU1u5ZoWix/rIQxSCTZPZ3xcSSDMU+wjxXxseQ9Pw==
X-Received: by 2002:a17:90a:da87:b0:321:3715:9a3 with SMTP id 98e67ed59e1d1-324d37ea418mr3137717a91.17.1755611305484;
        Tue, 19 Aug 2025 06:48:25 -0700 (PDT)
Received: from xiao.mioffice.cn ([43.224.245.230])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b472d5ad0f7sm10719364a12.2.2025.08.19.06.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 06:48:24 -0700 (PDT)
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
Subject: [PATCH] mm/cma: add 'available count' and 'total count' to trace_cma_alloc_start
Date: Tue, 19 Aug 2025 21:48:17 +0800
Message-Id: <20250819134817.247495-1-gxxa03070307@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D543C180002
X-Stat-Signature: joy9wzpiw81pdjo7fd4b5b5n3sa9aos7
X-Rspam-User: 
X-HE-Tag: 1755611306-970864
X-HE-Meta: U2FsdGVkX1+EQNV1PzyOhRXfS2+UXFgGQQPHBnCnzdoUpFnr0tjqEd/fb3YnTO7Fi++Mt+Z6eL706TIE0sbp7Bx5Nr8iZh/0yBZDCIObNmfNZV5OELWUuz0+gOn1MLns1TTvl+LcGeLU1vj4QA5hqhoXBPL1v/z1kOAMkcsYcHpAap/+6JI7tswBFw77LsNqD8jjt9nJBjyJPSddbQutsR99jWQuNpl1W+fzpkx3g6F78YMSsK1+a4QMryT4MnmobhfQ06V4LxbNf+7B+IyjNsfONuAkK9ikXgxCFy5yrjVRV88WeYi4bY4qZE1XurQBJpLTTPwVkxgJUBfTPm2pyzlzGHSjFOTbj5qwPmAe5tM1dyYc+AuJTD7gRjSc+0i/1RYQj/GyQql0Hxxqm/PNQvWMr0v8if3zuvTVhg3/BdSMhzWi310sGEALDo0Yrm/AfCNf4ymy1AiGvn4u2INv0e7E0JvtR1aTTL+7yCNcamPNcf9rSo3nwvsZKctR9rlFJ/s3AYT0RfBEhOxA0EJERZ99xtdJUK+3T+qjnAcQPRvgfXnn/MPkIbwT2oZEFzpGbvzoakbEYXLFWKZgW9rOZGKjgbhoTpezBnMHs0X1LXB1gbPqgRnbgKliAfdaof9PhDVBokQl2ZfzSVtkNn15K5Jjdx1pv4xx9WkpZLx721VkwxkcCbwdFOm5JpsS6CFscddgdfxjwcdSAfvf79BWjlnCA2fB45N2sI/HL4jpQzCBX01pOM3IV4Y4Ki67oi0w+DJFKAfyZ3upR9PDIrMjT4RvLXPlZF7YPg7gklOc0c4WWbenbYuILaaabTUWEjKI/J+gz+BtZY1VSIE588WkIOAP/7QN0I7AVu1chieJYRpDCkph0lhh1wM4apX78zXB+P8fhmlyw+pRzSOjtYe4utw+ztELP6cAWzQYAFEBvPqvnwjHuDk1R0LI76lr3DTy+sLoC6E0rJ8MugV+m9Y
 B1TE1SIv
 rt6c118mqZCClIRH4ZAJYLfwdrZoiLd87I4aN44yhTX4DCXxxg1EZv3v57qIal3SN0tnpiyAJPfMWoG4Fws9YdbweOu9UZZDBx8ILuhoFZ1Y1c3Fha2QyJOCVsb/0Cck5/QRTIaLPwn+2uxiMErZM18l9D5e6XRMLJQswcJj7A9zEd3Zv8Je67z/gsbG/kgJg6YmqCeVzeGKw8AqzPWW27qLxvH5sKoteJ9qMSI/YmyMHj0hG4VbFM5cVg1BLFB0/CwcRtV5l+84O8b9fmhveEGNE1P+UIbAAy09hPYiRAyAfaQEhszOhxaiqNEyO1vVjt07V3kNA85vebdfsrlvGVul+gkgBV+sApTq/KtDQm+2Uo30jBI7Tx9gWU4xB0h4iAfO2oqkZMZnVrdkoe8e1WWErsWFSrtUtEOHcyxfeGmhNJgK1OhiU2LSov4J9i3TQt4HuNJY2vLLr204=
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


