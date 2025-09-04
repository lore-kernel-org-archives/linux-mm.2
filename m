Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8EE1CA1010
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:22:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BB9F8E0011; Wed,  3 Sep 2025 20:22:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16B968E0003; Wed,  3 Sep 2025 20:22:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 033A98E0011; Wed,  3 Sep 2025 20:22:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E48CC8E0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:22:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7677D8688D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:22:45 +0000 (UTC)
X-FDA: 83849667090.11.5E20C4A
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id 887E814000A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:22:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OwJa1XHl;
	spf=pass (imf09.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756945363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U2npOZMsLAhal6oQPysy/cOAT94aswbe5KhIEvIg4+s=;
	b=3XjuIinBxTVEQRU47tGv5GTe3Ku6Up9/kyzmtukZmeJHlsi00L0VnsHAm5T6DV7vetiRZT
	0DNaKJLlAZqxDSqnbS7Pq3W8I168O3XIqkpY4y/BtlZefsbugYloS9Iw59Da3IpWmIEEzb
	r3vnL1pVnxjG6PzGX9dH7NvWxGB56Wg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OwJa1XHl;
	spf=pass (imf09.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756945363; a=rsa-sha256;
	cv=none;
	b=XXAaRh7xXUfSojphZ1Me6HFpsSoQUTVdqR4XZzNvEICRtnwlNVMDOj5PkCfrc7UPklHHOU
	4psDoCRN7OhinNTPv3Sas3zK8jI4XkwlFSaKvUJUMNT+E0YD0VMpiURwMvUsOkFT2bBVle
	/0LeuH4h+QdVlpMTIThbR9++gXTQ0r8=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-77264a94031so369055b3a.2
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 17:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756945362; x=1757550162; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U2npOZMsLAhal6oQPysy/cOAT94aswbe5KhIEvIg4+s=;
        b=OwJa1XHlx1ilQs1RuyiEcY/6TMBhuIEwDy2SAq+kWU7AxAPABjKMpCQuYfIfpyzxM6
         ZMzj8vR7MxFPNvDgA1N56+mCaIGLd9uTVTaRgfPQp0B85EKeifcHp4ZPNk0znBynh8He
         N0Da50HtvRQ/96jI/F9zUXjZV+bSg96690PFy769R5TmhFiTfXzrDHrtCO5hVvgPXPP0
         PMz8wYgHzzbPe4aEdI7a0dY+S24LAEK07KPU3uCZXIuDiKlRzmL2RL7uZWs094X88/TP
         3a7ipc+BqRrgLnuA/FtDydV4r8FvCfPOB8tv4MKDczDe6riV2uFHnpXmfgH2sKDgCAbZ
         WXog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756945362; x=1757550162;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U2npOZMsLAhal6oQPysy/cOAT94aswbe5KhIEvIg4+s=;
        b=XujC0p1+tmGN4Iv9bd34N5X2qM//PdqPIa/AfGCTg0T+KvtcG32s3Iv8zNpcIuB2Vy
         pT3FEXIWOd3xdkUmyhbduu+MSSTjG450c+NBaVVbz9nRZ3eOMiq7ZcxTQ0QxEPKAoxjy
         b32u/wEhzbzdpEZrvOxUIffH7JEF5pXM1Ri07M56AyG2Vacx/s8lYpB9PovRf8PCqzxL
         KaWlsit5CVV/3qx6ctHS33HmLbg7cDplY/74MQBcLsZ4YrkVd+y+jYSTQyb4eEU0hM3f
         BwvX0+QbK7RUbuEJCvrcGAGqeRLWQ1x8vvrYorA5veXt7R6XzwBwvnCl1YvB7mtzbE4E
         leXw==
X-Forwarded-Encrypted: i=1; AJvYcCU1/GGJTnW5oSpfHuWSqDW0ANFBALqKbgxUZ9poD17vCRgELO4yoFELsqK9cJHUo+WCJGGis2GE0g==@kvack.org
X-Gm-Message-State: AOJu0YxJb7LI9/qJFlDzXFk+HJGRj5fPY1dll2GtVNaRAFjIqxHmBbtd
	7Qx8+1DVx8CHlYpM7tu4kV9YkRDGOGBOtwBnini8ZnkX7PDUyVefPi6f
X-Gm-Gg: ASbGnct9gj2b7c3p/USNPTH0dPJKIDAMvjudZpdlnJUC4HwFtgBSHzyTnSe2tCdHeSj
	33AH8Ljd4QvIGNXSITQRbbijIC7mwN/5OfWekd6WQu53Jb2jbSgTxGXZkmeT1GhwrEoaq7H2uEI
	bwXFbb4SyxEeTY9B76IFlFFQ2DNEdsN8Qv+sTc2jShauJCCGMjHU+6KGsSzqIzvJ/idrLXW+1Re
	ppgrT9+9bQ9ehhBfaDyXerBvrqZaJ3TIBp5RWPAAUQKuqO6KPjhuF0bPd66vxZePv7XeSEQtwxE
	vv/CHnzpp/4cAXOT/OJWJMMRE/IMKMsyR4aNqESJi9KDMA5z6WxZ1McK6JTbH64QyRK4UbSa4vP
	MBUOFjz3XEgjshaIUqy12ndq5/PU7ymFG4JRmGHIjkNodVACkOLsXqpktCg+MqmU=
X-Google-Smtp-Source: AGHT+IFse51pKuiC/VP4GKbWvaDWcMuhZ9D45Q5y3eF7fSZGFZeaEsbe60FdXrOe2iwXwBkbBGQYEw==
X-Received: by 2002:a05:6a00:2e86:b0:772:306d:a1ed with SMTP id d2e1a72fcca58-7723e3dd39emr25528212b3a.32.1756945362315;
        Wed, 03 Sep 2025 17:22:42 -0700 (PDT)
Received: from localhost.localdomain ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4bd2aesm17579551b3a.48.2025.09.03.17.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 17:22:41 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v2 06/18] perf/hw_breakpoint: add arch-independent hw_breakpoint_modify_local()
Date: Thu,  4 Sep 2025 08:21:03 +0800
Message-ID: <20250904002126.1514566-7-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250904002126.1514566-1-wangjinchao600@gmail.com>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r7dbe6byrhpu1yohem6jkqbuuy8xf8b7
X-Rspam-User: 
X-Rspamd-Queue-Id: 887E814000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1756945363-168494
X-HE-Meta: U2FsdGVkX18VNdwv7E2ajSbqPNOP8VkHYFigobi1zkU/qdBWGhOPic3YbgG1lWIxJ7k3FuDDgY3uO1fLcZmN4Ourkfge6ciRQ+TeGmooHo6SDD2z/Upq7bPlY2T5jjGcUsr5s/wfiPJDdD782BSTx2ELSNrUOfgINlYJOAi4Amb0TLXGMPrPUkzU++MHsRVVdZU3fVBv4S/S9vC+0UcIwn+8SoqAv0iX0pNXBfJdygqXr8B/v7En9lwDqJJCRm+sD8vkopBkdNMSnZnWUKt0sI7tCb7Rdy9YVlrIYKql9DlLpQDuwstpctdInXOF3lz21+k6dU1foI20Ol7FF+0H8iUa66XyARIPC4XKsEtfG4LDXcAXo0KuVK+ekUybCZlbC0VZzME+WqxGxn48kRl7jeHZo7tZHpvToHo5cOZhrZRxxqV0rKcUgwgvyD3A4AGClSabQR9cfcQ80PQw/H5PwzqEaNf0sRgXm5ykVL9C6PAv7XrtN1TCgbhku2sJHVGGzqrhV0LrXDI2ytcl7mes1gaPfcSVbKw6k0OGy4Jd/cWkt8XNB56LQ98y8yj1N5G5hptfPPBLwuGZWF2PPoCik5GT1j+VizGi11iAjnlRqmqi6mlSqn1b/jHjanGk0mkUE0IHlwz/7prrxtnDnYPzxUqStVQOGz669/5VgZPCv7qMKP4li6kemtjzepV1nUlVzhA3L0jLd44VRDYkmS+z6T3whkvoP0p3iujUWNuO6SwPjT1XcU3ZnnPjyV/tnsPnkKp67YDVItCpxKK0iKpowDkW1xS5FXUB0DK7PE3HONbO4v3l1vXUyCfufynpo7JMhgz79pahaw7Vh1bnAchX8c/ZaFBEXowmDPzT+qPhE9pT544eKg0RTgDm4pFWiio6eTccweVc+uYcEj3wD6YK6OUkSxVZP2VW3QkbrpFLsN/3wmdJZpn40Ia0RUZQh+qKQa6NOGYSem8SbMk0MZg
 GMgiz0oo
 a0bxF0vVYYF7IXoE7V6MXIi5xbTrxHS26vXa5d5BXeCfu2rSAJfb8CuCrVT5OJE6WsRy0kpsAHWSqFFFMRwSRFFtoMWETJsLipGS19PSy4ZvFjTuU5TZYLAvamJ33KKs+F2y73R4raM/w6nyzJ/8c5M7sR3sOf2ve5KHyF05z2XVFUg20aO/cQ+XfqM6suGn6OqTR/Lc/Sxj10s86mFjPi9chY7YkiO2qprf+ViaaA3nkO4w0geKkdNEj86+8U+qqXv9Twke/wl5jjlrBf8JcXkN4AVBJ2H6g0bbj8T9Ql2kZAYcY4xrj5+hwdLo3cSTX0/4Bz8ScC8SROntCCaSQ4JQR95/ObyZvPmo+W2RlNhe17mmURQFmyJYcii5zbirPVD7BfIsaPZrgVvsw4OkdThDgS44b8Lfa/o7AF7UvyY0xFM/cV2KG+LY6cKkQHCi+GT3tEKuxGpv8/oy20VpmS5IcA0/4Gwp7rDW6nUKx2Sn6E5gxRmjFwJfT7XJg6krJYibCxjxfw3cquEA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce hw_breakpoint_modify_local() as a generic helper to modify an
existing hardware breakpoint. The function invokes
hw_breakpoint_arch_parse() and delegates the reinstall step to the
architecture via arch_reinstall_hw_breakpoint().

A weak default implementation of arch_reinstall_hw_breakpoint() is
provided, returning -EOPNOTSUPP on architectures without support.

This makes the interface arch-independent while allowing x86 (and others)
to provide their own implementation.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 include/linux/hw_breakpoint.h |  1 +
 kernel/events/hw_breakpoint.c | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index db199d653dd1..9453b5bdb443 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -67,6 +67,7 @@ extern int
 modify_user_hw_breakpoint_check(struct perf_event *bp, struct perf_event_attr *attr,
 				bool check);
 
+int hw_breakpoint_modify_local(struct perf_event *bp, struct perf_event_attr *attr);
 /*
  * Kernel breakpoints are not associated with any particular thread.
  */
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 8ec2cb688903..ff428739f71e 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -983,6 +983,24 @@ static void hw_breakpoint_del(struct perf_event *bp, int flags)
 	arch_uninstall_hw_breakpoint(bp);
 }
 
+int hw_breakpoint_modify_local(struct perf_event *bp, struct perf_event_attr *attr)
+{
+	int err;
+
+	err = hw_breakpoint_arch_parse(bp, attr, counter_arch_bp(bp));
+	if (err)
+		return err;
+
+	return arch_reinstall_hw_breakpoint(bp);
+}
+EXPORT_SYMBOL(hw_breakpoint_modify_local);
+
+/* weak fallback for arches without support */
+__weak int arch_reinstall_hw_breakpoint(struct perf_event *bp)
+{
+	return -EOPNOTSUPP;
+}
+
 static void hw_breakpoint_start(struct perf_event *bp, int flags)
 {
 	bp->hw.state = 0;
-- 
2.43.0


