Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B98ECAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 20:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 174778E0005; Thu,  2 Oct 2025 16:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D6468E0001; Thu,  2 Oct 2025 16:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE0E88E0005; Thu,  2 Oct 2025 16:46:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D58C68E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:46:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D5651A068A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:46:42 +0000 (UTC)
X-FDA: 83954357844.18.CFCD263
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id C4BF71C0014
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:46:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dCeQUFXC;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759438000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2jwps1lz6jxYNn7Dnn5Z09tOaOeYs2HTQuW80UbgHqQ=;
	b=bDF7Cje3MYQlpW2UG5NnRgy5MRhqWw0BigjTlqc3GGhsygUJmHVsO39pjdXME/G4/8JqNz
	Z2NU1fxt1KYHRima6OK9J+bCMUX8yH7EN38pXGwBbd0wuT5UvSs8Fz3+huOUW0Mz5uK9Yy
	/OpJa39a+hiGU0+lJfVX3fzrhGRCq+8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dCeQUFXC;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759438000; a=rsa-sha256;
	cv=none;
	b=R24B7eIdFs/u6c2PmkFKapZ7vM0wCklLHjvXonZtKDa/GFWr0/rZJdH+fjImJqd9m8xl51
	Jb0odjHRcvzOjjjAwwBYC55J88JOv1N5Toy1o4pAKx84MK7zlg4JYf49Pl6cj5T4XENtyK
	CoHoa7T1iLN/mjI7j59jDwBEAgPgyNU=
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-71d60110772so16013757b3.0
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 13:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759438000; x=1760042800; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2jwps1lz6jxYNn7Dnn5Z09tOaOeYs2HTQuW80UbgHqQ=;
        b=dCeQUFXC5+aCI7TNbmQYuFT1qZLlXnYtvL2N6a+YTtUJKFAyZxh2ymT93B2yrHHkWv
         4/1yxoDKP6OPDWXbligWKBnujvdo8gSyaE4aZQQpBZFzb9LTxdS5u13ByiSPN8dZZi7b
         4A+OzDGa8hfKa9fE6EoVoDuG06KaDDzlPQANxlBz98r1SNH3++YUlH8v+96fAauampE2
         MvnmVT0eyGo+12STFUfmK3sZGwVeQM9It93c3lF4pj9lvTsA65WEDHGagJeSlx2hqBc5
         0jHdqvbDedWMTyV64UDrYiYqcuYuABAsdVvvK9gl9i5eS+6idRptM3X++BUoe8n3f4oS
         lTew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759438000; x=1760042800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2jwps1lz6jxYNn7Dnn5Z09tOaOeYs2HTQuW80UbgHqQ=;
        b=leZQ9btJB0AAgIWA0swV6eFwy3iRNQTGxCfQZgrqsbglkyZ/x4LO8S4nD1IrcnW1F4
         INGH9LmaMSCiSWWo8BRurLuBErMsAet0FNo1xz+PHU+lfQEc4awadRVBDPFtVVMu9KZF
         bUAa5ScNeY/uVc121rMutk0++SVhoZjFKD+Rzp2z7Mm1QOmPefZCSVBIITxzNbBgkQI6
         eic+zIgMlsqq+xwqb85I0tfcu/lv/ZEBCLIezHK9UJou8pHeVyzAJnv/8c5MsXKtcnd8
         fOLqZbuZG59mviy4RlpVyyaclgySV7vUnJOsZIIJuJgrYpL5mMP7oUiEId+rzuIxfWTa
         k2KA==
X-Forwarded-Encrypted: i=1; AJvYcCW5w5p+Xvp/CN7eWyYIj+6SDAgPd0S2pJB1sm69nd/nsNq47NFcQXzTZIwRi19ocIDvg0dI1T2EhQ==@kvack.org
X-Gm-Message-State: AOJu0YyFfQP81+ig2Ae2SzEXmOuYBIDU2lDEhJJFTng9Z/FfXaHIxSs7
	0+/wcMyu8zU4nPgpwCtihuNcQSmR3HyqlgR6FRpjNqjzuv8ZM2PDK75+
X-Gm-Gg: ASbGncvSZN/6HXq5ocGD0dzBhzEIWA6YoGFdOhdu0TzqI5MUVWjSiOek4ZPptM6niWQ
	oBJHiQlfpu5hltjMzd7s4AC3CdIXIyKkx85eZBFpn33h8QQJpNkCZWMGikdtIkrlhmYyyK0DLgd
	7PlJgEOP3kQigkZOdoI8plXh1T69Ktwp1gj+x2aLUW+pB8DXFvI0DF6vW3tGcrQ7k5obtELS88z
	VTtOUo04w5o9nFKGSuM9+1nskGfQwcoFtigEOelyB3M8+E5YqmBjqCiPQYvM/Sc6sGg0FSH+/C+
	2sTbzcQzmXz2Yjd1Czf4f17QTFI0L7AtdY/lOLgfCPFnV3p2fkYoCHVtioA74GxXUe6fLsvzwdH
	JnbbuLVrjLf8qDXTtzGbEdIiFN2MLjZObPaasJlp/LDlQyUdZMOYJ/XA2Zc219J8bM9uNgShaBf
	tCDw==
X-Google-Smtp-Source: AGHT+IHzWFTSbAUSJS7YF3yHmxIfnxGDKF6Uqmg2CyEoFyCqQ6BTPK8MNk89Gdh1FJmam2OVjyxg6Q==
X-Received: by 2002:a05:690c:6e8e:b0:772:3578:2ec5 with SMTP id 00721157ae682-77f942c2c16mr14178777b3.0.1759437999539;
        Thu, 02 Oct 2025 13:46:39 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:5b::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-77f81e370c7sm11291757b3.55.2025.10.02.13.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Oct 2025 13:46:39 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v3 1/3] mm/page_alloc/vmstat: Simplify refresh_cpu_vm_stats change detection
Date: Thu,  2 Oct 2025 13:46:31 -0700
Message-ID: <20251002204636.4016712-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251002204636.4016712-1-joshua.hahnjy@gmail.com>
References: <20251002204636.4016712-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C4BF71C0014
X-Stat-Signature: ark8ggjcnkafunqkyijpr16hekxa4q8g
X-HE-Tag: 1759438000-200152
X-HE-Meta: U2FsdGVkX1+/woDXEIHzJKAASOAjCHq0Qtrtjfpr71LpjREHbATZ5D00rAgXdJEAAlykLLqod5ZiOMuCMLG3zNy/Jl9WKMEuJiyTy7NGh5XLDjNJKAQxK4wU87GPZA0gLZL5mrnHNCKTsrTJtGc2+2Ed3mxoZ3nckqC7hagperK7+slGJk3b90uCiOjzK0Z9eReWmA9S4p/AZ4x0Us8yiqxVC6WXZbdd7LXoxHC4sNPpQZ/pt4uh71MHLzlSVv3MbDS7cshfEHrTgEH1afT9o8vMflVjRl1CfHjRiXAzSrnwNKAyo0zk8R4WsAcPvwCPQxULlZfmoXzSN6yXx4KYNXEQwvGUMoFyW2Cw98Xpfn7eRHrX8sQMg+ohJbI7iuX4xQNTP3byoG+O3iehwBr2ec5bqpDR1tJUekVTvBedC8qNPRh+pQeD2atggmSjosSa/FTQ3V2m4L4KimhEBuAqEUd0haMjtX11RoaQLQ2TZSTsr2W2a5MsMOg+IiALDOnJwNRatugRQ64VgzKfb67P8a3cjjmz1PnNi0zC3xryeJlCzq/4wApDsZrguIBTFzZbqmO1TekNNUCR0OApipQWcbSti9baS3Apc6UuvAARh//03uKidx/OhdQMLvezFGKxwXpg0hRkqN9NA5YZsgYhFwraYw1o/Evtt39G+8rUKdM2lB8ENKAzwGPH6sKeJAfFUAqO1PAbJ3XKLWuWnOkpf2QC2ateTw05RWUpdds6lKsNVyuXW6O2Az+9C5Dn2BYl8aWogeUY/ncwe6Gk9MGy5wSKurwIwmbpOwePiZJNCws24ObNUgYSUPc7bi3D6QNJxvZf6+MtVxzx1YekpWIuJPt757BV/R6wMFXtrUg37FAldRwbEb2hbeKt9o1FlFTnOTHn9+qsU5OyClXPlSC4+OB/mB9hYpkLadNLWta3mheR4YQMbNaYPflrSBaeMiLVLXXjTHPNTNbqxoPOGHo
 5czVQ9jY
 6iElpPfnjXFMcZktK45v8U2lcYa79Jx2MLe78eexGPZc3kbFTOdjrL0FVzTHOMAp/CFzZL9ZCDlw0B0HlPM7BZkHQW83dyUqqMaXS81zoURxkwoo3aZtPvZnuuqg0yBFWPnUbSAJZhG1CUB6j8DBCeB89AnUwTk3kxOD1jHZdWbtMwhlQCk5XydaPgF6X8qgWlXSFAQOYboq3kJlLSyYa+p3xEqQYv8FT7dtj+hWRBldkA9qK9g25jyUOcpbYCF4kdv/xRc/2S+Fdlv148EapCE94MHnI78gEf0F4+qtoEGywPW5qVrN4aM3Ae1rmzo6z74DZY0yw6wObEz7QlkbkiJkOsH3+dhwYtT315OTzQMPInaF8N6MUcEZS2fRuJ69Ozilo07x2T6P21Jp/9O3hRPvQlyFvCSUFfq71lX1cAQdn5bYgYJVY9yGcgJAGKEpu84OIe/Djnuu8/MciCcpg/lL78rfQ5OsPIpVrfW/KN4oFLKT65tQjqSg+tAwrpN4yRwwV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, refresh_cpu_vm_stats returns an int, indicating how many
changes were made during its updates. Using this information, callers
like vmstat_update can heuristically determine if more work will be done
in the future.

However, all of refresh_cpu_vm_stats's callers either (a) ignore the
result, only caring about performing the updates, or (b) only care about
whether changes were made, but not *how many* changes were made.

Simplify the code by returning a bool instead to indicate if updates
were made.

In addition, simplify fold_diff and decay_pcp_high to return a bool
for the same reason.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/gfp.h |  2 +-
 mm/page_alloc.c     |  8 ++++----
 mm/vmstat.c         | 28 +++++++++++++++-------------
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 5ebf26fcdcfa..63c72cb1d117 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -386,7 +386,7 @@ extern void free_pages(unsigned long addr, unsigned int order);
 #define free_page(addr) free_pages((addr), 0)
 
 void page_alloc_init_cpuhp(void);
-int decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp);
+bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp);
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
 void drain_all_pages(struct zone *zone);
 void drain_local_pages(struct zone *zone);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 304e12bf2e4e..b9fc357d2d48 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2557,10 +2557,10 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
  * Called from the vmstat counter updater to decay the PCP high.
  * Return whether there are addition works to do.
  */
-int decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
+bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 {
 	int high_min, to_drain, batch;
-	int todo = 0;
+	bool todo = false;
 
 	high_min = READ_ONCE(pcp->high_min);
 	batch = READ_ONCE(pcp->batch);
@@ -2573,7 +2573,7 @@ int decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 		pcp->high = max3(pcp->count - (batch << CONFIG_PCP_BATCH_SCALE_MAX),
 				 pcp->high - (pcp->high >> 3), high_min);
 		if (pcp->high > high_min)
-			todo++;
+			todo = true;
 	}
 
 	to_drain = pcp->count - pcp->high;
@@ -2581,7 +2581,7 @@ int decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 		spin_lock(&pcp->lock);
 		free_pcppages_bulk(zone, to_drain, pcp, 0);
 		spin_unlock(&pcp->lock);
-		todo++;
+		todo = true;
 	}
 
 	return todo;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index bb09c032eecf..98855f31294d 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -771,25 +771,25 @@ EXPORT_SYMBOL(dec_node_page_state);
 
 /*
  * Fold a differential into the global counters.
- * Returns the number of counters updated.
+ * Returns whether counters were updated.
  */
 static int fold_diff(int *zone_diff, int *node_diff)
 {
 	int i;
-	int changes = 0;
+	bool changed = false;
 
 	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
 		if (zone_diff[i]) {
 			atomic_long_add(zone_diff[i], &vm_zone_stat[i]);
-			changes++;
+			changed = true;
 	}
 
 	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
 		if (node_diff[i]) {
 			atomic_long_add(node_diff[i], &vm_node_stat[i]);
-			changes++;
+			changed = true;
 	}
-	return changes;
+	return changed;
 }
 
 /*
@@ -806,16 +806,16 @@ static int fold_diff(int *zone_diff, int *node_diff)
  * with the global counters. These could cause remote node cache line
  * bouncing and will have to be only done when necessary.
  *
- * The function returns the number of global counters updated.
+ * The function returns whether global counters were updated.
  */
-static int refresh_cpu_vm_stats(bool do_pagesets)
+static bool refresh_cpu_vm_stats(bool do_pagesets)
 {
 	struct pglist_data *pgdat;
 	struct zone *zone;
 	int i;
 	int global_zone_diff[NR_VM_ZONE_STAT_ITEMS] = { 0, };
 	int global_node_diff[NR_VM_NODE_STAT_ITEMS] = { 0, };
-	int changes = 0;
+	bool changed = false;
 
 	for_each_populated_zone(zone) {
 		struct per_cpu_zonestat __percpu *pzstats = zone->per_cpu_zonestats;
@@ -839,7 +839,8 @@ static int refresh_cpu_vm_stats(bool do_pagesets)
 		if (do_pagesets) {
 			cond_resched();
 
-			changes += decay_pcp_high(zone, this_cpu_ptr(pcp));
+			if (decay_pcp_high(zone, this_cpu_ptr(pcp)))
+				changed = true;
 #ifdef CONFIG_NUMA
 			/*
 			 * Deal with draining the remote pageset of this
@@ -861,13 +862,13 @@ static int refresh_cpu_vm_stats(bool do_pagesets)
 			}
 
 			if (__this_cpu_dec_return(pcp->expire)) {
-				changes++;
+				changed = true;
 				continue;
 			}
 
 			if (__this_cpu_read(pcp->count)) {
 				drain_zone_pages(zone, this_cpu_ptr(pcp));
-				changes++;
+				changed = true;
 			}
 #endif
 		}
@@ -887,8 +888,9 @@ static int refresh_cpu_vm_stats(bool do_pagesets)
 		}
 	}
 
-	changes += fold_diff(global_zone_diff, global_node_diff);
-	return changes;
+	if (fold_diff(global_zone_diff, global_node_diff))
+		changed = true;
+	return changed;
 }
 
 /*
-- 
2.47.3

