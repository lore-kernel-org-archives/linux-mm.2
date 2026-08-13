Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91B47C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 07:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C58E6B01F6; Thu, 13 Aug 2026 03:50:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B546B01F8; Thu, 13 Aug 2026 03:50:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78AE56B01F9; Thu, 13 Aug 2026 03:50:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 475F46B01F6
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:50:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BDECC405DF
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:50:45 +0000 (UTC)
X-FDA: 85095474450.10.6B16358
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf05.hostedemail.com (Postfix) with ESMTP id E2C3A100005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:50:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F9RDvaOv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786607443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HgBqYNXZCzr06f5NE3mn9NXVjLKoxOpoLRZ6XBqO/qg=;
	b=QMnKf3/vPxQppoHfggZNCuOcOnx5B0B7Lc511khKXu5OwA3uBhs2ug9T236XFOGtWwyFkl
	3X+fORc3fN2sCl702R6QwwPKGNv8jgpVCivgminCfOoZO6tzt6++i5+WfYOB5sbDQMrzEB
	hqclXL07MbJrCwGgSrOP0TNjA+1tPaM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F9RDvaOv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786607443;
	b=QmVpFLLeNWMc51xgwpV3H0VhmzxLdHPOkjKTXimDOC6CQGF2+0V0eLdR19Ljh8kFJRj8B2
	IUqb0rfdPJbRe9RRqSxMaRNkRTE5oWfYch9yqh6X2/0fYVJV6AXbBIe2e1/qRkhgR1Z9q9
	AuRYVK6NiGiXQtgroIZB8aUYxftWt7Q=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cf49dc28ccso3475165ad.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786607443; x=1787212243; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HgBqYNXZCzr06f5NE3mn9NXVjLKoxOpoLRZ6XBqO/qg=;
        b=F9RDvaOvRE/rZB7SJnkb6Dz60i+IL7HlIbfBeNIDSa7DR9Vf9jw1npdNlwFfArDRWm
         3SFC1ufreMevLlmvFWWWaaaQrpoj7sj3kZb+wwsmGxa/DJ2+KnTl8an2kO6e6aBs5P1+
         RzXQuflLFqFaogZLW2g5glAWIjK5gC67BBPEApSIpbP0Sv4ilNNtMoZXEtPDUyPi+u9M
         28eGdErzFTH99fLNgqv01ezkq1xe2dmft9sbr427Q9xDYHawwYMth8i23o08yHa1mLgt
         V0CgQh5jPFEkePPCnafgexurLBaoubB74lMEUrGA4bc7cRGl3+DGKZJMPZu+dwtlesa7
         4i+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786607443; x=1787212243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HgBqYNXZCzr06f5NE3mn9NXVjLKoxOpoLRZ6XBqO/qg=;
        b=corNy10hQq7PV5aMfkyV61d3LptszMOcpzQ/PJYNpaqVCyB9OtfdnhSRLMEIZPT6E1
         AauRm8jvX5Vd4DjuBcDPRU2uOVV9cgj51CaGDIJv2xb2dkda25OHi00NDf2b/R7Qedsj
         db4wA9fDh/MCF1jAXnkAVeAYmZpRne91eT+9FY8ch1TOkPACbSVMDtmAkZcc+yRrnp/T
         7e8f3OPYkLH5hU1R6Q/8hfcEs3kYKEwmHG7+rX4AvdUWCPDW40HRMcYF41dkL+cszOna
         tER16bfNWBu4Pl5MTb4A8Be7bx3ZNZhu0UaFoYHrv2GZ4n2thZZeJ26fCp0XSxRAWNGh
         3wag==
X-Forwarded-Encrypted: i=1; AHgh+Rq/mbVp+5sth4TGWFWmO9/8UunTKycUvWRwXA8c4DTa1jNcZHY/Jrptt1e/H+xPUfag6WkZIU2kwA==@kvack.org
X-Gm-Message-State: AOJu0YzD2tRKOHiLrlRMHAZhjcYycdCurZebzjjBm9Bzd18AItIXhejn
	rO9xKZH9yJFAuiyfc/auy1IHLRAfvZTbZLSHfMULEc5ozGyRR4OrXw8X
X-Gm-Gg: AR+sD10ABbXkC4QxkFqsvBU0PAh99Tm6vbRBa4LyA2LCXpsiQM5l/6kfyPgQTvE0XlG
	TjNNvaflkrLm/eJxHy3K2B3ac1D1YGvqNEsT0PFOy6Fe86hisJtqn0LblAQQRa8QWCL5juiRGpK
	PrWchu0irLRGVQHmJ35ZYpYZmey9jN+2L2BdYUdyTxMwBbTR2LLbOuZ5Oj66G8OV05SQKjvYezM
	oSGdsbNmzZB9XVlYwsI4W60Tms26i0KqmT3ohPfPH3dD4foYf/fQ13krL3UFTjQVp5V+AlX12RS
	GhA5mj/wcVDmD1v1fD4Ayjo0OeQOy4SjFW32ny7L5Pc/pkfvnPD37y4OPoWVC4yTrrhFlDxlgiC
	WfSxEpvl9NEU7RgtviM1N8hG9MsPSre5fzYSNWiTBb+BKURWHT4zGUSYVXVXduQnVGRj5Dm7jQq
	hQUcLWOxrZHJpvHiNvgu1DB2IQw2n3o0YOI3BWSRfAKy3BDtxwptg8JEGsHsbLvy7at7jHge3M7
	krsOSC9XSiDvt727yj9SJs0ZmisQMK2M7VXOe8D7GKrld+zEBj+D5guKkMu7VRrfoA9ZhJIiWjg
	VdmRdNsd6d2Ed/LR
X-Received: by 2002:a17:902:e5c4:b0:2ca:de3:15eb with SMTP id d9443c01a7336-2d388b7518fmr25969965ad.0.1786607442621;
        Thu, 13 Aug 2026 00:50:42 -0700 (PDT)
Received: from debian.lan (n058152058183.netvigator.com. [58.152.58.183])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d37c40d6b0sm5550125ad.40.2026.08.13.00.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 00:50:42 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	ryncsn@gmail.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v6 1/4] mm: add page_counter_margin()
Date: Thu, 13 Aug 2026 15:50:22 +0800
Message-ID: <20260813075025.1406585-2-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260813075025.1406585-1-xueyuan.chen21@gmail.com>
References: <20260813075025.1406585-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E2C3A100005
X-Stat-Signature: kqw4mz85s8s33auarfzgjs8h8c9bdk6c
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786607443-26920
X-HE-Meta: U2FsdGVkX1/bKuzzte8aUf5aOG+xENs1d/qzyruy8BKEMzO1dulkJReT7QQSXzBiae49F2/LhLJjlC3SA8t9ImfQbSjhDeI+51IN/64ayXNbVKJwo5W/tHNDcAmz3dfy+QanlfdWZxKHGJDeInANLsKqlS4For7rfuvXIXVAV9GG7AgaBADACnRo8kVLV0hw0TSWTrMVxJ+9Lm/TFrmA2AxrtZEyS9ogckp65tA+HQYzLE0mvayYKyJpHTsodqmnuxBBgqngjdUgyNrDEK6kcciLG3kTm60Xf1qZtETGKtoFeyYLnyKpbd71fRtWs+P5zkLSMn23TC2VdGM3wStMjWoyHUHBlsDYmNKWudLh4Sy83+jwbu1CEV0rqIsEWQIdrpXX5XJwp58sX3AlOdumDze65nA/KFdVQ6lWdpAFQ3JhGEkzIV0zkJsygF5E5bYzbOnGj9trSvLG0GbEKBcOJCR5mIYHOgKjMeiF2Z4hT9TzUOIIGHbNO8xfVnauN2esqson0smbmW3TkGmHqFx5AGGjA8kd3jb8gBRfBKpU/TNg8w7hhC/mGKkW1WStuiKdn+AHqiDahAZ9eK7hAClSJLz+8JFIbDJtEnp8Zsyh/Qe7KP/v9YRz0GkgC0FSPC3z19UGBvt90agP+FtC3D+eD2d3jomc7mrvtj9ijlqmshStMZlbpmBF/u6iSpVYCMto48O4GYKrhbTMrNxtwgWrosqdN7Y8XiSO6bEiXlt7wjao0sGfBpyAlyw3nWBhY4sPLenlTUdg5wFfcbqUJcKwoQloWyHPYSmhlfAx8Qp0E+Y0XD4mew5/G3sdFpTqdmOWcdmoQcXpS1hlCfUvPNuDgslz0ngplgrTt6te1JO78RRIEFfzVNAPXBz2WNTFcn8cxSHcNUn+zbwLZuYq+MSXWcb2pdv0Z1bPjVXEzdevFL0H8nr+620xEdPR4SQ9XpZWxU3gtBOMRUPDvLv2D37
 TAb3F0jM
 0JgauiZAkALSardEELyR5w/p+8HEZpty28AG+624v3p7/FbB3T2rN/hDxEVqhfBfi7vYb5u+c8+K2z4lE+4EgwXQoGiKHpbRPaEffboErhEUHogTOjeTjL+pBY1B14HBHXBy9L/mUg0p1WkhqtLXrRY6hyyx17CdQiD95Z8oCU+HfycEeXCW7pzm9Zb9vT0iyO9MqTmezT+/THBaMvtPNdVsiM3UBnocjUgSAIOsrvu1nkqJxfTaluRRqwdRrUasL6uR/iII+D3o64w4Sf0obI0jxorQOB5hutQZZWhgsEOsTeRX8lcXoBWz7eBNEg0Gb49KaB0SfNSppD+scc5yCEs9BZnKQ9kGe+hYMYSxd6m/faT1rbVst2/ZjVdl6Dr5N4H+ch2FdUunrVD9Xd7Z6ZtxuE8yRjs2HDVibxZF0DGQwML14jumSSzaB3ezbe3XQqh1F61pj5yZWhkYbxxpeS+9nbEjXLCYQtND+6z8YJOALeO7xhYkdCYBIjbbSq8eXxhzO5GPaD4I5y6ngOMax8KLSk07R5m2mweJHAr4H7WUvc0eyH7g30+Za7hOZWMPNsx6QjX3jOd8kOuQvoeX0Zq7fTNnUSiZ5iH2PBxK+uzkR2KCJT0zODYAMUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Johannes Weiner <hannes@cmpxchg.org>

mem_cgroup_get_nr_swap_pages() open-codes the remaining capacity across
the memcg swap counter hierarchy.

Add page_counter_margin() to return the minimum usable space from a page
counter to the root, and use it in mem_cgroup_get_nr_swap_pages(). This
is a pure refactoring with no intended behavior change.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/page_counter.h |  1 +
 mm/memcontrol.c              |  9 +++------
 mm/page_counter.c            | 20 ++++++++++++++++++++
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index d649b6bbbc87..07b7cb12249c 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -68,6 +68,7 @@ static inline unsigned long page_counter_read(struct page_counter *counter)
 	return atomic_long_read(&counter->usage);
 }
 
+long page_counter_margin(struct page_counter *counter);
 void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 bool page_counter_try_charge(struct page_counter *counter,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8319ad8c5c23..109c08be91cf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5670,12 +5670,9 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 {
 	long nr_swap_pages = get_nr_swap_pages();
 
-	if (mem_cgroup_disabled() || do_memsw_account())
-		return nr_swap_pages;
-	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
-		nr_swap_pages = min_t(long, nr_swap_pages,
-				      READ_ONCE(memcg->swap.max) -
-				      page_counter_read(&memcg->swap));
+	if (!mem_cgroup_disabled() && !do_memsw_account())
+		nr_swap_pages = min(nr_swap_pages, page_counter_margin(&memcg->swap));
+
 	return nr_swap_pages;
 }
 
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 661e0f2a5127..450543f4b318 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -46,6 +46,26 @@ static void propagate_protected_usage(struct page_counter *c,
 	}
 }
 
+/**
+ * page_counter_margin - remaining usable space within hierarchical limits
+ * @counter: counter
+ *
+ * Return: The minimum value of max minus usage across @counter and all of
+ * its ancestors. The value may be negative during a concurrent charge.
+ */
+long page_counter_margin(struct page_counter *counter)
+{
+	long margin = PAGE_COUNTER_MAX;
+
+	do {
+		long m = READ_ONCE(counter->max) - page_counter_read(counter);
+
+		margin = min(margin, m);
+	} while ((counter = counter->parent));
+
+	return margin;
+}
+
 /**
  * page_counter_cancel - take pages out of the local counter
  * @counter: counter

base-commit: c73b725a57f276a3702ca213bde78fca029bc619
-- 
2.47.3


