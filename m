Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7AD2C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F9356B0099; Mon, 20 Jul 2026 15:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9526B009B; Mon, 20 Jul 2026 15:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 124306B009D; Mon, 20 Jul 2026 15:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D1E4E6B0099
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:34:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 501E8C0258
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:34:59 +0000 (UTC)
X-FDA: 85010157918.11.9F92F69
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 88221180009
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:34:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dY11pEfk;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xdEOlYqIeVdUG1DfkuvgY4asc0OjHWyQnI3tw1EXx60=;
	b=N/n8c9dYFgx7mgh2yH+tasdELidjrIpUYLjpausdU/HNQSG+biw/sh7hzOhK5G2q22T4Ed
	p0ghEgXBEY9cxt6aAqB5hMVl7+A5D3NH2xErWBfZ/yPaf2qxG6uJnAWj9Ph7d6PO8JctZw
	w+ihTcL7YVePCMC5aqcEmLZEDOvlhf8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576097;
	b=VdkLF0eBL4qi5ckdmQk2rKF0XO/JcXkE7TfHDevs2JwxdcyGLff17QJYyWEgLIF6lEhyLa
	QR2OLaJwn2uMMeqqkIxr3NkVy8YqQltByBbvEQNb2sxOjUD4vlOOEnqn91edTEF8tkbycm
	Lx6TmUZQmqdGDSvJYH3pLb6/jMXVQgY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dY11pEfk;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e5cb052edso567146785a.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576097; x=1785180897; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xdEOlYqIeVdUG1DfkuvgY4asc0OjHWyQnI3tw1EXx60=;
        b=dY11pEfk3tIOcuJaRQ44gFyn9EZnk453l9ywX11Yf3dn70oFXWQ4Es9PJStO9iMQ5y
         Vveemk0nwGr+6B/Br/tnd8tyOFhRTeWO2BSjpJTrjicel5EDO8gdfNhXvtkcB3M+O5re
         dblWuf4RIvIftkzIuBIARoH4WfSxsrI4/F5DqGN7qOkxbbjpQp8FH1ZXz66As8p3NAvp
         MgmfZMmLlw1j/BTTejglzhcQDGdvduE9Drho0d0jUWBnaByl6P9feKUHk9OmUDJS0Ifa
         9uhog/PfdwArs2PBMtOg3msD8jEkE6B17m4WDGRLoxAeksr0Go60NHxS8E3XD0sarZId
         ElDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576097; x=1785180897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xdEOlYqIeVdUG1DfkuvgY4asc0OjHWyQnI3tw1EXx60=;
        b=NbqZ61m4edjYE2NS2FDPMKVaBsdRuoBwNufknyNyeAuaSS70cn2WThRXwyCYbq29wc
         t70wOnNzz/u2bFqf6qMmextPWxko0Ie1gRYHRjpE8jnE3DO6PTW5uZfKhSyIGXsR+Sj7
         VJJSJNyZt+UKLKuUA8RWbSBkHLJ/xR4VNQIXfdpSySOOmp9aaM3xcGqEvzsn8mrpIrNJ
         ZFF7qsPrU0MWnd1YAZLSp6RA5MLqEneIzuLcxbMIZZJH5KOFp7lx7W7pzEeIL8WqUkg2
         kDfvJnsOIfjheuXrKFLhi7EcGMGJRt58iW2szzljNbKomkkKBAnXXxOO3Rq/tjamet89
         4ZVw==
X-Gm-Message-State: AOJu0YzNPI/qdUkhEIAfpVNdoAh/InZCx5+FY1VOpxTFcp6QO7KWgJSa
	T8dJeC0faDoMHWUuM4vr/ZfOU4v3PFD+RpZgOOxV/gTEBOWv5UBLvr4XFEBGDf5heNis6tEs6Ao
	6hS/d
X-Gm-Gg: AfdE7clKZl3b6P5NBzyITalahlSxE3aN0lmt4PGK82rdJT0juSVtP4/aAPIWDtMbbPS
	QSAW8F1DW90dteKgVxWDWwltdm5wRb134G5VX+tYOlZnZxhV/nvIkqY4N9TNNLlAY8WMVsNhHww
	LCgETLMvXT75yD+7luYmvHt45zM/iIIaK2eqwKY8oB6XRMS0SUFrQAXaoqcaBt1dFn80xNaQ/iz
	VQpHdMicf3KahWBf1W2T0E6rObhv33r3CMLxnYoLA5Zey0chZAwicv4WBvmsrESmsq1grquiS14
	8LTI2foGT4GYQ0gJd2aXA/sls3Z6ft5CiRi2jMZhhWM0g6qTKKmjPEH/+zUf0fgE4+d1hsWjsnt
	Zei2FNXgV/L5AvaXFYQlY49Gc/U2i1gTPFTVPZtn3lnwit90EVsH1RFLoZVn/XhXDj75ZEQp4Qh
	T4dCpuKitKYR02yINQ7+9nLSm4x/CWo3y6JiUbb1f4AUE20lg51VBxau/29P0QKyY=
X-Received: by 2002:a05:620a:a2c5:20b0:92f:196:209c with SMTP id af79cd13be357-930b41f9aa3mr1179416785a.71.1784576096734;
        Mon, 20 Jul 2026 12:34:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:34:56 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 07/36] mm/memory_hotplug: disallow migration-driven private node hotunplug
Date: Mon, 20 Jul 2026 15:34:01 -0400
Message-ID: <20260720193431.3841992-8-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 88221180009
X-Stat-Signature: j9p71df45aoqjpm67cr7k3h4tpncpbkj
X-Rspam-User: 
X-HE-Tag: 1784576097-884495
X-HE-Meta: U2FsdGVkX1+TiFvWBa2Pl/JsJYVGRQZ7uYVSgOcdqO8Uw4amEm1sWE2Dh5JjUq35e1L/gfE5xzYKKvJC81+ebJIumH80tWVlayZVEneHivmHd/uptw2TlYgC0HocIxKbcs/kK4QcsGPwWiNmP/pJufDbkvyMgP28hFOXysd7DXR1xwHtlQKx6WMayoDZxU4cptewsSvgl7M6GCGOz5PYW6I5V6URnvgaLPs5qS/ss7Y7gVBwqDWkeO4nt5ylnlw/dKBq30mlzFIASz8odaEOEgtMV/c849IGeFj4h4EucmXV2wPA/ZzGnlMs7wLdhLlsrFmGyPOpA1pF5NKHej+t//6Y/IcczKu/vOuP7vRyD8s+VEgfhttNxYT4wOU379sRDeivzi2qoUhh1fk2WWUYOS9lI5rUMi4/KX69r+s3uTzMAAXI5FOzwOaPxblWbg+BH8g7bY9conmYEEJJ5J1APWNsIIdj+FEO4jiH7wd7fOpHalzFmFxoKNrLBzGgfqcKvwdkxUgwLDgdzHRnwu6U0S5N5wK7EINbs6rDdCuE7CNG75gSHH2/YIBVkrz9DGqN7twAD4aCvmazuJbq4XMG9AdRXqc6DGCYYoVjsR6+AZnOAUBEDndBsV8veCyTVpHeYqOtAq5uBY2Mc9wYPqmTU9PlqZNZ91B+evQrr/KVu/w0jgVARucxlxy0V10cvqOxkOp3OOE48/kNGhIszihTgTtu48B6hLk/306KWRG9annC0Bqajz1lPrdeRomKPs+JJ6RqMlK/v1+rzAHQBIRQK328xOFViunlbuoQGuTefvKF71B78QJGJ/UQd7Pgg+2T3/qmb7f4m2SwzNjsjA4kgfgUFyV415WtyIuMvGkQoV3C+7yrudtxdSgxW4IDOe02S/K1utFGfFuV7E+yGn07vcSPhgMepCVzgKKfeh/gH2F17sK/Q5bUyxy9ZzX2mcsseTkmx4GXBF0eHrJdYza
 U4jhZxd1
 jBZszFiE0CivvfWX3SaNpZAsaHIi8T9CEo+xUczRUilxvcm4hhc50aOgIgOoe7qrkHhqnKFWS1mC7GEYdfkr7XgRkSH6tswhQHlvkgbzuZpfwcLHjZ6brpZ95MpysYzTEbIYTTwMPqYolHADFTsH2hqKvl81K5zG5Gq+XKJxosnjogozCX3pxLd1Q2JfTJ46woMvuIJOqTOysbYcG7u9onAlok8X4CAm40PUuHsWPinX27YQuuK18TKoA2J0We6lmNQbrUQdAnjCU8QlDKaIKAxr4Cw6drjMQosSNlVa75h4whQD7V46o7QuAJgExdpqDbDwLE4QnxJBw7vbrXpAEnKf8Q3kS1JJysXt+dd6cgrvRForvM6X+OJVqI4C01Dk+HZLc8/QQGeR8keMOuA7szr23c9W0b0e3qxe8dVsk+tLK+kY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

By default, device-backed private node memory may not be safe to
migrate without coordination.

Do not attempt to hotunplug private node memory, instead fail the
hotunplug attempt, and require the owner to drain the folios
safely before allowing hotunplug to proceed.

Unlike transient / longterm pins causing failures, this is not a
transient condition - so we can break out of the hotunplug attempt
entirely instead of spinning forever on a failed migration attempt.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/memory_hotplug.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 226ab9cb078ad..2b9c0830821e6 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -34,6 +34,7 @@
 #include <linux/memblock.h>
 #include <linux/compaction.h>
 #include <linux/rmap.h>
+#include <linux/node_private.h>
 #include <linux/module.h>
 #include <linux/node.h>
 
@@ -1843,11 +1844,12 @@ static int scan_movable_pages(unsigned long start, unsigned long end,
 	return 0;
 }
 
-static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
+static int do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 {
 	struct folio *folio;
 	unsigned long pfn;
 	LIST_HEAD(source);
+	int err = 0;
 	static DEFINE_RATELIMIT_STATE(migrate_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
 
@@ -1884,6 +1886,15 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 			goto put_folio;
 		}
 
+		/* Private node folios cannot migrate, fail outright */
+		if (folio_is_private_node(folio)) {
+			pr_info_ratelimited("memory offline refused: node %d pfn %lx\n",
+					    folio_nid(folio), pfn);
+			folio_put(folio);
+			err = -EBUSY;
+			break;
+		}
+
 		if (!isolate_folio_to_list(folio, &source)) {
 			if (__ratelimit(&migrate_rs)) {
 				pr_warn("failed to isolate pfn %lx\n",
@@ -1931,6 +1942,7 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 			putback_movable_pages(&source);
 		}
 	}
+	return err;
 }
 
 static int __init cmdline_parse_movable_node(char *p)
@@ -2067,10 +2079,11 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 			ret = scan_movable_pages(pfn, end_pfn, &pfn);
 			if (!ret) {
 				/*
-				 * TODO: fatal migration failures should bail
-				 * out
+				 * A fatal migration failure (e.g. a folio on a
+				 * non-migratable private node) bails out; transient
+				 * failures leave ret zero and are retried below.
 				 */
-				do_migrate_range(pfn, end_pfn);
+				ret = do_migrate_range(pfn, end_pfn);
 			}
 		} while (!ret);
 
-- 
2.53.0-Meta


