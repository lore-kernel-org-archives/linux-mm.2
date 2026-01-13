Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8B57D0C857
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 11:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65B0A6B008C; Tue, 13 Jan 2026 06:46:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62DA76B0092; Tue, 13 Jan 2026 06:46:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 485926B0093; Tue, 13 Jan 2026 06:46:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38EC36B008C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:46:49 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DB092139D0A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:46:48 +0000 (UTC)
X-FDA: 84326763696.17.00B667D
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id E67BB20003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:46:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=J7jAIiNR;
	spf=pass (imf13.hostedemail.com: domain of marco.crivellari@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=marco.crivellari@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768304807; a=rsa-sha256;
	cv=none;
	b=PqaoNRIyZfSVzbki6q5Q0tHfDkUmJFk4DFJRMjBt9MaW6/DGXgHLyKReGO0q1TNLHbKYqa
	n0aDgR5Rl46OlgaL8Xvlcy0BBHql3z63f5nJElXLbLMVv2JGLjkSeXUXMmZGXj+cIt/suN
	1ZDFtu8Uej9rx1tiGbMrOuvyoE3UAY8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=J7jAIiNR;
	spf=pass (imf13.hostedemail.com: domain of marco.crivellari@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=marco.crivellari@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768304807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xu2Gd9y2yQd69p5yQxI5o3t1KXuh4CilPfTzgbOnvsQ=;
	b=aCHpPDIMc0LhbhM3OPyd9EjbVQ06OBzVaQdphA/rrHI3faKNvYXwd0nT17uJDi3ZQsGLBV
	Z+ANKX6itWqb8hHPVtbsm4brD9X9cR0/yUb+TPohzvLOAdvJiT4oYF1+sByxfo9sJQ65jk
	VnBnPkacBG/NZfd0eunQS+TruWzBKYs=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4779aa4f928so75106085e9.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:46:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768304805; x=1768909605; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xu2Gd9y2yQd69p5yQxI5o3t1KXuh4CilPfTzgbOnvsQ=;
        b=J7jAIiNRXxyS28CZU8qWoIZ8r9YCGU/exVL5kU2mw1t6ROG3J8Y8AXreel0xBcd5m7
         TgNmXFQC9NUoPxkIstZTr+vgvRM3mu1LdpY5CtqztozFIHEe29YJaeI6kmFcFYs3e6Of
         TD6O3cISfB7a01pR9eUt2xdVMmZGJfUS3KLBg6+zSkleW/WYUeMFZPi6Lo8Eir7MjEdM
         qVXxJyZFzGDhJ7Z3rTkfgZk0FtcJPPZ8SP4nyL9zdDx8VW3sd1nj4rOSWMxbmQo5HhkM
         7O0ToiS3kkDB4/pP84DSNa6iubvdWVdfZNtpCEeNwde4DmpxKRnARAC+/w0nop9AC4W7
         v25w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768304805; x=1768909605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xu2Gd9y2yQd69p5yQxI5o3t1KXuh4CilPfTzgbOnvsQ=;
        b=qPpq+YTug+tCSpQKGVXeLwipjeazuvL8GgrNidAcQNmCzaSciqNeRA+bgU1zGRnD21
         kuBUNrqp9x19unG9qPYfNQ/YU3v3EgS8OATvzV2IROyunFhyEW9NiT2rh1oZykdWd5N8
         sSNpuA+BB1mDXkfdZjlydIhWPaybavQWyK7T1YDid3cmr3ThgAtpt4bpce+MkoCKVE8S
         lum1/4h1FgIdoxpYgvJMH7NPnD8aLDnX5g6pYT6o9vo2uJpaSuN/LB+ZHdMbHLpol9bN
         9HMldD8hkft/TYpO4eP/WMb3ECWtfsV6/9FRJtBGs+r/EdqRK9ZW4ecbRpzbeUu60Adf
         Pqjw==
X-Forwarded-Encrypted: i=1; AJvYcCW6R/Khi80RonCzBLX32wYBT7BmJuqgObveXpkEdeoBAcEcMNpohO8crAgWRNi4K0DbaqdC6cig6Q==@kvack.org
X-Gm-Message-State: AOJu0YyejKTLzMGWkN1InhzAkHidRr5A3MSFkZwGSgcTodYpYmhUNfUU
	Q1l/QTIj3s7eBXrKxLrJs5eAzpgogozRDkQnpWuOGaiowl0OvW5we1+Xy5QmSm2bRuNI52YIFHE
	xy/3O
X-Gm-Gg: AY/fxX6OtAQeCqQURMrrnmuCcWOgM2SfmovWLCtqNIfMvF46Iq5s3gOf2TqiNpkKSsx
	G5D/hh51yh9MGiPhEcTK5BqaSMfyQHmrf3SdKNU47c10GGjXc68fuycIu5gywR4w6PMj3qqoLLN
	DQxIRblkq4mKxZxbnQ+4s1jm75Vw4LjOY/NDIZU/fGXfa99cXFdMBhYavaYQzF/5XwVN8F4SHrG
	W37GgSe15SwQqRgCdwY0EJi2CnaaGm6jeSZoDW2EgyJ8SkAKkG9L/ApdaPmUcDk4vX5zNRAj+7p
	Tg9yDh4vj/yAj++WRCW2R4hTeDj3MiIvS9B1CAv5oktMDxKk6V09wSx1q32UaJ73ke97dLltlbf
	01JHkih7ntKOnOt8QQu4DAYJyhgWufM7/zR3mZJ8DO53cp34mUs8AJ02zhxxqO5o5hCy/NnddhD
	n30Mza0fzedzAt8w==
X-Google-Smtp-Source: AGHT+IGJVKB1//BjsB27x5bhJ5UTOToFDrmanj64A2Fh/canwPClEtWxgbJynfd2lfSffDVitB+ueA==
X-Received: by 2002:a05:600c:45ca:b0:475:e09c:960e with SMTP id 5b1f17b1804b1-47d84b38676mr247391765e9.32.1768304805515;
        Tue, 13 Jan 2026 03:46:45 -0800 (PST)
Received: from linux ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f6953fasm391850225e9.5.2026.01.13.03.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 03:46:45 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 2/3] mm: Replace use of system_wq with system_percpu_wq
Date: Tue, 13 Jan 2026 12:46:29 +0100
Message-ID: <20260113114630.152942-3-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260113114630.152942-1-marco.crivellari@suse.com>
References: <20260113114630.152942-1-marco.crivellari@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E67BB20003
X-Stat-Signature: mkh7qmxr79z6y56z76jzqcg95tjt8tdw
X-Rspam-User: 
X-HE-Tag: 1768304806-116242
X-HE-Meta: U2FsdGVkX1/9PXFSelZNNTBoCn9OPSZkIxe0dx4+nFWpr17gLk7HROI3opSTDyY+k81qrskKOVGiVG142MdATHTpxf8r3/91mAg2sEfEKpb1fJGs/wo69IOTlxjwENtcVF6+JOov/Cq58rfj8Cw3N1pkA+cvQX1+3/CMdpgW58oCkeDNRA78Ltg4LayNy1xsN2aTOF0kYop/FVcl0ZfPCRIIZAP5vYyyZ0zBEQv5sT/2WopHB4vgB9/ddVp1qP7ZNSXXOvIn9sTkQu3nWzFxe7JNuu1/ku6M3aWjKNsPDNUVH+lJGSVvpu4JCxLcFrV1zTaT+MNvRHRTMh200JEmwLn5wptnplvkE5RHR0UbY+5hDtUnF9xdV3HxlRdeioVQI4Vs9O75wMSHO7C0KRXUGGgGp0A5HuJtIdgJkCZVUqhPtYBpTHyJHtCAvnwkqEvZCn22gY6a8kEOC249aDW0GG7ItN0YGbFkPLpmghxpMIUuKd+gJeZyiNZ47fLPu03L9ZYynNdkU7yF2jCCgu6yRBZLH1/lixUzYXMBALBtyKwQVsF8t6QSh1qSbQ80I/QlzJR8BdeNVYfVlT9ip28mqy+QHTtfbtpq0YKnPTyAye+r4V9DYyyvaWeBO39JMzsbd5s5dS/lnxE07Kwj5RuY3Sd7/UNtQk2DX+OH/t7jyrel1LwdW5/3fGZSd76ldeq8cv5jTFE8KPQtpaGxDDzVOGxIUs8P/ltqi/ZesIv+eywZHWe8EOVFDz/ugL77OhUBdEGIvikLhdRHpoNJYa7B/+6jwVfmH7Den2heBi1zu2sXV22bpEfUpynuJPSVcsQvPwOrRcoh88rHwbIbTy8tRlVsKv28fnQgDwXB5WRl/P2ZruTLJb0U4qkTdP1jp1gHexNEmd+YnclQU6PcckBV2MgE2JPa/ezxyHICyqaZo57RfrrAcBMHdA0xe6kteokDTv7hxt7HX7otp6xRtLA
 tcoryogY
 JDFAyn5l1qKnRNzNqiO8xBtkGW9wi4wBUqeRrfclzYV1DQbkH3QDB3pMfmLNe9HTBcKfnT5rV73qLag82TdjUWt7Z2GOZ8Avr06dI+txdVZqxPgh7YS7+6aoNl3z0WEIsIS3fVCo0KxkFB9wTUYLDvzn+w/2WmMFpnc5QuH+7s6qGp+gir3kVMFEwXKwk3NL7Iu0wlY65YPztK6fHeeGENzCXfPR/whRJj7Sl1UugpkEYlVI4/wTiUmb/e0aUaLJpgFMekYVbEVU5VdmdQCX+Yf26LczvLAs4SJP1fe54/GZuGtwUFWDenacOILV0to/v6uE7ZEVKDC0jYYzIw/g2WUDm16oZQFEc2UnlCximIPV+fpKg+sNZCnsnC9VVRi7qhj+XiOV5rW67sPDmu28GFGSCuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch continues the effort to refactor workqueue APIs, which has begun
with the changes introducing new workqueues and a new alloc_workqueue flag:

   commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
   commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

The point of the refactoring is to eventually alter the default behavior of
workqueues to become unbound by default so that their workload placement is
optimized by the scheduler.

Before that to happen, workqueue users must be converted to the better named
new workqueues with no intended behaviour changes:

   system_wq -> system_percpu_wq
   system_unbound_wq -> system_dfl_wq

This way the old obsolete workqueues (system_wq, system_unbound_wq) can be
removed in the future.

Link: https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 mm/backing-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 2f65b5416228..4c6f0b85a24e 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -971,7 +971,7 @@ static int __init cgwb_init(void)
 {
 	/*
 	 * There can be many concurrent release work items overwhelming
-	 * system_wq.  Put them in a separate wq and limit concurrency.
+	 * system_percpu_wq.  Put them in a separate wq and limit concurrency.
 	 * There's no point in executing many of these in parallel.
 	 */
 	cgwb_release_wq = alloc_workqueue("cgwb_release", 0, 1);
-- 
2.52.0


