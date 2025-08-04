Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FDFDC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 17:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5FE08E0003; Mon,  4 Aug 2025 13:24:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A10B88E0001; Mon,  4 Aug 2025 13:24:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1C98E0003; Mon,  4 Aug 2025 13:24:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 75D7D8E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:24:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 276975B827
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 17:24:59 +0000 (UTC)
X-FDA: 83739750318.15.E6435DC
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id 31A9440007
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 17:24:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i3CPW+Y2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754328297; a=rsa-sha256;
	cv=none;
	b=f0pnWwLMuMkYURAyHU3AJ7RF0H8jyNMshvXawtcQnNAtcVkGcyYGBm4jySPd/zjQrIIxc4
	wMowCOLgQik+zVsQqmx3T48e16SnwfhLm/N+52cPsQ7sSxci4YwmNZ4LhXB6bRxXbysxwG
	kSYy05SF7Eyx5MDIBmz92o5zFAOd0os=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i3CPW+Y2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754328297;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PZR0jWbWu/lG5CSlpgwY9+3+NvurMoK+b/pH3fKR8CI=;
	b=UUwQHLMMcufmjUDRS3rRVxesFwOVme72pizJt5PZf/R25OTKLXRdvrP0jImzX4u1ec4Qjm
	ffrlOYhPxLRK5BJvUmnwUyLQCblXCHO7LX3Rs32OwMXbjyrYg+2GHtvRL/aAjh+S4V3Sqm
	1ajYIHR8p91FZNW7DjZS9kd+bZTaNx0=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-76bd9d723bfso2845146b3a.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 10:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754328295; x=1754933095; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PZR0jWbWu/lG5CSlpgwY9+3+NvurMoK+b/pH3fKR8CI=;
        b=i3CPW+Y2wYIt0m393t8S7sXcTeikRYYzgyDWFDLt8IKbQwvkSF939xV0n/ylv8RDWl
         VFFuugfji20/732ab4RItv5fDgtiRLBdhY9fIM/PVzEMJ/6BF7gp16KaEDGPtRG+ekQR
         3tLMM6FL6RqGVoXPxpdqp2eqWJkoaMnwKvR3wQoJYJovN+mCQspx4kin8s3u9/nJsOZX
         KPHIViIRlZo+AQkdSmjq2LM/hwJHdBJuJD8llsF6YQlhQh+j1QTVOtVr89D1ozVXYw9M
         GJfURltBSil1CP8amakw79BPWnNw5qSfe0YDopCY5i6TFg8HGZJaMopwgQ5EY7Y6y2/v
         6BhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754328295; x=1754933095;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PZR0jWbWu/lG5CSlpgwY9+3+NvurMoK+b/pH3fKR8CI=;
        b=cThPa0dagGsud0gjF5rKpQ6o216H7kCGE3UdQ3WsOC/AUuaWByLpagv/wAhSufxqci
         UbzSHjTyvDPjT8n3hy3j+nqCGPNMfCmlx4Ay8sVkyz6oOfiwjdT2WLmK4gibEFnpcjL2
         MMvWdKyYwZ0SE8vxU4fnAr0UtNzqheRAemf0pk8FANSIgbFNnEfyMOq+c1o4S7Tnf8J6
         RR2E3ulrNWcnbJgyD6t0VpZk3+ROI5xFzLk1VFluDvP0lSnStRRF6sLnc6uiSHDgUtap
         UYuS26bwkl1EpTXliHIVUmd3XjtNXkw8mK/xCUdm2rdcaWdReeKMZkapJP6iP59df4zp
         yxKw==
X-Gm-Message-State: AOJu0YxEVcJ84mwTMVLgWtZrjvcxGSIJnL5Np0dAuUpF4LswOC+eHUj0
	FQ6IfOldqZ65IHFocX/zwjNF2mmYjjfi983kcsV1PLshbb8Y0UGcjxZAuQRbLM/EzBg=
X-Gm-Gg: ASbGncstKbfsFmdcgqkFLEjdTfbSlKmeJYbmygi22998rR00ODimuWObX+p+dS21jsP
	zllWDPtqxDcX0xH1+VQ1wmCUSIF3kT2Am5s1mNR2RnN9L8qQWEQvxaT/KrCloMDg5K0s6ZUu8vu
	V1lVVCFJG9OPDL3nLv9OOpoW+Va8Otya6xhoiSiKsYkgZERgEw4s5eyFVRossRb4PTZ5o6ls0tZ
	UWtIOaaCZbcf5a/C6d9f0rjGtzmxGJLxn+/FPp/RmeRVzOYcCYO97av8mkt5lbynI7qowwCpHSB
	4NSGqP4ia+Nw8YgK8U978+ENHMHiDSgwUJ1v80Y1eq3aicxlCYVOpJY8a4shTeoVHq1W7zAeSUO
	16rQE0tHdE1+9MTO/G3+PunfSEWU=
X-Google-Smtp-Source: AGHT+IGHdiNC7GNzQLwpVWRh03+lnLLmoCulHv8RNEfhsU1tU00VgfdWrwm2VCOx+cO0qpIIb4oOtg==
X-Received: by 2002:a05:6a00:1701:b0:76b:f5c3:2af9 with SMTP id d2e1a72fcca58-76bf5c337ecmr9874395b3a.24.1754328295484;
        Mon, 04 Aug 2025 10:24:55 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bfcb26905sm4194530b3a.123.2025.08.04.10.24.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 04 Aug 2025 10:24:54 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH 2/2] mm, swap: prefer nonfull over free clusters
Date: Tue,  5 Aug 2025 01:24:39 +0800
Message-ID: <20250804172439.2331-3-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250804172439.2331-1-ryncsn@gmail.com>
References: <20250804172439.2331-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 31A9440007
X-Stat-Signature: 1jjwft5g4mpj83cybsh6n9t57m7xszuh
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754328296-584657
X-HE-Meta: U2FsdGVkX1/0bCL7rv8jAbyirB7qD91DKQ7eTDZEAGgTtFR/o6nPaX32K6rmjW3gwO+XPzS89zcoTcltanWMRKuNxu6CHamhQi4VgecAhZD1XhKgs7FecoV6ZttDiRgtKaH1jB8b+HEdax5qDk5FQ9za8Bu5fjhHKD8iHcev+JJtfqj3VeeYiYHloH6pQqLRoX4G4a//LIKvLit4p00kQd1BpdTsXUXyU+AtCoAfL14PvLngoaF2SLSSKV3HjpN/fzmSw0h8Vgg8920BBxJFmdpEzZtYOW+bJQ10xiD9r93NUkEPc/WqIxzueseKbPBrNUGKgme6h1UvdacV+0ned+e+o+ypectvl4UbeKaC9Z0AP0pjYj8fBw7AIClBAyAoDOORAII79au/HcjPKcbALRbXW+YJhKlDK+xmv1FyEKst9rWB3gDu81lo9ROAStYKWmUsKo9T559umSJyNuXW/UiVwO1bA5gzMac+wGDru4m2OfJ1d8nc6ww+Boed+9ccW0oPRhLkHgDPtaK/GO9zft7WRFXggNpqQewhFYFPuF0pPHIzM4bIR3CzzKFMVTlYh+ik5rWcnhOw716x3YknOiEKKXPJGU/CWImNTNKEmcIQY7jGc9Y01kimvD5e0VotZbeN6vZ+3wmG2ukf2OwlpgIr99pcS5GXMgdv+Yk+aZ+TtTJT6dPw3IGjr83zTQ6jKtiZ9uqeds6heZ7vYgTkZKfsyXHFtNNg9EBfqkfO+stw6PwXXXsn0fGdDNFKh+TvfvbRp1FzVYRdzxd1KGrFeWqKD8aNh+vWkRNPGhcU43DYuYEY2pakaQfodJR0Tduly/bkQMX+rJL2KonNOamQD0WPZRFZ4D39GOeGRmXMLoJdLhricmOLPa0Fu06DU05E+lgcLFAJfdbD4IduzVllFMvAQIxUIhR8KnVI8Ej0HsBpRt2KAZzueWltaHNZEp7SBl4J3Pa45LdGMPm9lqS
 L5sZ1Srr
 sXtEx9aoHxsnHf/J+8m1edvckXkG402oa1CSm+jmmpltx1J8pGKojQV7BF0biJY7S5Kn7yduN9z4tnD9M4hVE9xwwpQcEQxfwAPAnnpooh8yE03lQFplWRHj7QT+X5UE88nrlwx/AIPM8xwEv5H3IjyIktyIVl1JOTDZhpzsDjcpnX4vlXKyx88A6TR0MtBw4GmFQ93OfFTn9HEsCFkTool6FPGpCNH9ALe9ufGuSwFXe37Zu8tSZJsO9nWf9Yckx5XhCz6uCMkkiambcE+ol4oh53U7O3cC4VgKz7cEJeE51PBupw4MgfziUfUd8LjGZQDsr6zPzayEI06u3cpf5FldElhd642BIf786EwQ+e0IssRc3GCVo32rmrknnKGwFIZcNqpW0fPdMSBtf74rAGWlXMGXa/Px+zVC+fGo7lrQAEH+4r7gUqNQkUmPJMpevasx5hEEONhV3RSHriICQ6Y4QLt0UBkxZyILvsL1w21oZgssxVxuIRzqBu+g7boeNerCxrNgTOj+PO6CL+zDV4ESa9VyYN5E9ulbq7blfv6XahNkeQH0N/g7/DDWovRRgrADggEGYkeTxxqb38pnqVJIjV4XZM4p2C+bL5HvROVvkqXg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

We prefer a free cluster over a nonfull cluster whenever a CPU local
cluster is drained to respect the SSD discard behavior [1]. It's not
a best practice for non-discarding devices. And this is causing a
chigher fragmentation rate.

So for a non-discarding device, prefer nonfull over free clusters. This
reduces the fragmentation issue by a lot.

Testing with make -j96, defconfig, using 64k mTHP, 8G ZRAM:

Before: sys time: 6121.0s  64kB/swpout: 1638155  64kB/swpout_fallback: 189562
After:  sys time: 6145.3s  64kB/swpout: 1761110  64kB/swpout_fallback: 66071

Testing with make -j96, defconfig, using 64k mTHP, 10G ZRAM:

Before: sys time 5527.9s  64kB/swpout: 1789358  64kB/swpout_fallback: 17813
After:  sys time 5538.3s  64kB/swpout: 1813133  64kB/swpout_fallback: 0

Performance is basically unchanged, and the large allocation failure rate
is lower. Enabling all mTHP sizes showed a more significant result:

Using the same test setup with 10G ZRAM and enabling all mTHP sizes:

128kB swap failure rate:
Before: swpout:449548 swpout_fallback:55894
After:  swpout:497519 swpout_fallback:3204

256kB swap failure rate:
Before: swpout:63938  swpout_fallback:2154
After:  swpout:65698  swpout_fallback:324

512kB swap failure rate:
Before: swpout:11971  swpout_fallback:2218
After:  swpout:14606  swpout_fallback:4

2M swap failure rate:
Before: swpout:12     swpout_fallback:1578
After:  swpout:1253   swpout_fallback:15

The success rate of large allocations is much higher.

Link: https://lore.kernel.org/linux-mm/87v8242vng.fsf@yhuang6-desk2.ccr.corp.intel.com/ [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5fdb3cb2b8b7..4a0cf4fb348d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -908,18 +908,20 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 	}
 
 new_cluster:
-	ci = isolate_lock_cluster(si, &si->free_clusters);
-	if (ci) {
-		found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
-						order, usage);
-		if (found)
-			goto done;
+	/*
+	 * If the device need discard, prefer new cluster over nonfull
+	 * to spread out the writes.
+	 */
+	if (si->flags & SWP_PAGE_DISCARD) {
+		ci = isolate_lock_cluster(si, &si->free_clusters);
+		if (ci) {
+			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
+							order, usage);
+			if (found)
+				goto done;
+		}
 	}
 
-	/* Try reclaim from full clusters if free clusters list is drained */
-	if (vm_swap_full())
-		swap_reclaim_full_clusters(si, false);
-
 	if (order < PMD_ORDER) {
 		while ((ci = isolate_lock_cluster(si, &si->nonfull_clusters[order]))) {
 			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
@@ -927,7 +929,23 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 			if (found)
 				goto done;
 		}
+	}
 
+	if (!(si->flags & SWP_PAGE_DISCARD)) {
+		ci = isolate_lock_cluster(si, &si->free_clusters);
+		if (ci) {
+			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
+							order, usage);
+			if (found)
+				goto done;
+		}
+	}
+
+	/* Try reclaim full clusters if free and nonfull lists are drained */
+	if (vm_swap_full())
+		swap_reclaim_full_clusters(si, false);
+
+	if (order < PMD_ORDER) {
 		/*
 		 * Scan only one fragment cluster is good enough. Order 0
 		 * allocation will surely success, and large allocation
-- 
2.50.1


