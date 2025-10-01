Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EC96CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 19:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7D2D8E000B; Wed,  1 Oct 2025 15:26:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C552E8E0003; Wed,  1 Oct 2025 15:26:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 995B28E000B; Wed,  1 Oct 2025 15:26:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 831068E0003
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:26:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3B0051A0259
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:26:56 +0000 (UTC)
X-FDA: 83950528032.18.E7660BD
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id 55351C0007
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:26:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cb1OdtoT;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759346814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FuOmVyVQXsumRDN0WySluCU+eClCoeXEAXwSkpYGp4g=;
	b=2mytwmt8FGBs1cr3CfAW2nohLrbIr8zzh+2VoAW8qgd3xr59y2j8lQPtLPh6T0seJxUO2l
	PHaHr/IUHJFFXZh3yk6DrEWCPMC7m0lM0ms/sF8s8VPFxtebIRBgqjPCSDFOy12t6UjvfQ
	dziVRfMUzq82I68owptoyWBsxo3w8OU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cb1OdtoT;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759346814; a=rsa-sha256;
	cv=none;
	b=0G9yx1JuXYpsBq0mhLpBjPAHDSWdScr4LGXqkLLHK/p1AsTXVj/3opjBunTrrLZhmn01Iw
	X5I+c6iuFr+NzPR4S/2KxozqKDqgR6L6mSijIabX/YCz+ATqINGjKbNhJUzGgUrbLBrlzL
	vvS3bYMSE6QFwZFALFBs0zIhAeedlPs=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-57e36125e8aso196935e87.2
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 12:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759346813; x=1759951613; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FuOmVyVQXsumRDN0WySluCU+eClCoeXEAXwSkpYGp4g=;
        b=Cb1OdtoTsvoh6FfvRRY1ye1+gEPM28ahl/dPz7vS3LrX2R6Pop13QChm35MyMPUunw
         UDq0BT4rGGyAXbt6Z+JngM4AVtRmK22YmeO9Ip9ysKDe2nxXVJKo5qngmwZ/pkTWPoFr
         KR+t9PlOuiVQZ4oFScwMoXI3Hvsiscn/t+qEujjhreRQirjnLXe4Gf88PIYJpGAmYuaY
         qgNflYY5CXANoLcg+hV6J6VN99/xOAQJTeBHrxJMaVroxe4d/cwtdQU+UKNS+nuFGbL7
         ZKaIdQg/W/jsW55+HksNg5IXgKxT3MUsdqbV/eAgaM2GORGgDw6oEASMrcDEU9raJ6Np
         /6HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759346813; x=1759951613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FuOmVyVQXsumRDN0WySluCU+eClCoeXEAXwSkpYGp4g=;
        b=omvMXocbQ6uCvJf+7JZkbYT5AjefKV9bOFEu+5Md/8ElB53prhhl1txJv377fRYg9o
         JzdHo1MitQKSxlF/AfE9q1oh180vQEoTGQbZZQ9oI73frUCvz7NplLZM1Uv/LARrLMTg
         6bulElT1+5BVY0uxWVb0S0U6I9PFkI9dUSAhGNfC2IwPVpH2NOXGNC6UuUe/NXZ+LSdz
         E1cSLldkao7Q+OT6FljvwfM1ZipOmZSDbY2R+wBWwgJ3sqtbyMcLKhKDHElu6jB1gbkI
         1SGBNezzQg0h1aOvdBBtOXk5g6gNOV50Ar0F2k/06cju4lYMnIu2VESz+u9Nhx1XCP0c
         DI2g==
X-Gm-Message-State: AOJu0Yy59iFduDJ4VuywtFJ85G+Blz6bSknNowmL5DWbc5pRq8zqkD7+
	viOIWFkelJLnH0LDqu246aAQK4KDrs3qjblgglx/vM4upzxWaSpfdilJsM0NbqsNlqU=
X-Gm-Gg: ASbGncuP2VxDTazZjeBoV/DIptEF/1vfJNcHiOmk+162PDjCXdsNjLGVFgZOhUePqyt
	uk3tPK6i2gKRJS7/N0wYfinq8gFx9fJS6wha/MOFIcY9leg5HlPjRQAfxsO2l5DdRmaquqYrU0e
	mSI7TlN6+Qtzwl9962eweOXJ4DKnj7KCz4eFZx6z/H4aqD+P4ZdT2pZ5IJzhS8lHaRJAtWmExBG
	nkM+r7t8E90TsGUpmjX1w7DyjSakAzVyJwhWGSDk9LgJymtqENlccLHwVyfQ1+RTdB6qNDszh6Q
	KpdgSMxuIL0Z6gD17mOlSGSmVFR54y/HLAhcJAGRPArFd3BS3sE3O5nDht4hj/d/fIqgT6C0ViO
	WduKqbH+LcF3uEuw8ZeybZtUXkza9k06myjQBczrtJDNle8QbtR4=
X-Google-Smtp-Source: AGHT+IHZQHFJ0S5f1OcQHCfxhezQQXZPltJgxW4zc1dj/mXykewUGOJa1V03DnNOst08ID094gfxBA==
X-Received: by 2002:a05:6512:3e0a:b0:578:ed03:7b70 with SMTP id 2adb3069b0e04-58af9f6afccmr1528057e87.28.1759346812509;
        Wed, 01 Oct 2025 12:26:52 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b0112414fsm136627e87.28.2025.10.01.12.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 12:26:52 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v3 04/10] mm/vmalloc: Defer freeing partly initialized vm_struct
Date: Wed,  1 Oct 2025 21:26:40 +0200
Message-ID: <20251001192647.195204-5-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251001192647.195204-1-urezki@gmail.com>
References: <20251001192647.195204-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u1b5ut9m6pjza5i7bxciybu1ncpfyr4w
X-Rspam-User: 
X-Rspamd-Queue-Id: 55351C0007
X-Rspamd-Server: rspam04
X-HE-Tag: 1759346814-137800
X-HE-Meta: U2FsdGVkX1/w4Dz/l2KqfXDlMRzoYyZLLMbtfPYCOAKgixeS+TSpfBeDZYIrV0LuBhT7CUuw3JY7Ne2vm7hEWlrfo/9nQ8CAAekHBRaZ5EAOmAZR3hnCKHAKLmn3LaUHGPCxvNHjTB53QHBqEgCMZ4YSC2d4PrrK1J5PGJAEf8B52wo6oLSI4YTPt6/xAq76ovjkN0Evz6n6EgauVyOLYFbEtnQNXiqoYLSKdbSs9HKDsr3Mpk17kUFVnyxfYk7rYc2PvOWgIal66PjycccNmfVzwqQ9VDt9HEsPnZpMCxmIXz3GByzvUIcIIH7SNuYbG4t7Fqz263L429lMmWL74gBC243txqq9xX1PD0D9IzssoDIVLRd342IeO03Rq1OsF84gWoG+CGsPlEsLYvcTbyzT/q6cZ8/0QGeqhh0IR1ol9O17ehy80ptQ5m+GZNn9QjuTW+v8lV1DkWlZvFlaqGej6BRXuhcOwdHYraziAMt/YDbjm2TdgYsNfk/9DXnl9xIoCxDXnruMTyHMuy4FpRAeMQG3OlmaXsXxiamXNWxrJ71FaNQf1L6gNSsm5j1A+gf/QvI5/ovH48fsvrU9Te7B/z+kdwA9eTvk1VtIqBa3Q7kYK2oz/zlC5MSP84WPOpswLr0fCJ4RK5ef2RMmPGkt0fg8o3zJsD/2m1ahza+X6xkj4RuKP6k9Vv20akuwqIpvZww/T+B+T7N55kcah6QlmBES3qqWSnQGMQsiht8Dgaww5rjcmY8BuLXwkeIF/yI+3iL526aZl94qDk5CYw/ikxftBt0vIw7t9DmzQfPxWo6y8MGUpXJfBFQtws8R8YQHnqGWE6QNr2FBmzGDF1INGVWg4jD26lFvDBGFfCzFfvsRppKeeUfSJB65iLFq0+i9Otf5agQ5Ustgv7GGZ5iGXPMFwBpNDHZTuFV+kB8u7jL6miwD5nhSQrrgsYufxXo6JbX8aEcpaitv6qo
 yl6dCefZ
 XYqnJuuI18FHTw2uIvUZ00Lx4rmQFOeYSYpdFdnpLiO1nY4ivGI7EoQveiPNJ87tvQj0puoDbL6LcXy8AHTbOotYDTbQcjzI8xAG6+f08DNm7aLQ3BjLaByKOIRNoasrGX/l7OjLCsHLSLLbzP2OKnz5XKaLO4wPLzB3dtTlHF988GiD5I9o7JegTO3LMinGJ17lJEjqGLMnJdU0pRtACqDqNnLxaLWQhXL3n6xdkYB0Nm4wmNMfSPXACWc+UrHUg9r4HB+4HYdXYZXcO9OcJuvnVd/lXvbLmdNxkAP+2s2D2UoMJiWPU+jXQm5f9h+8wTkEj6sEjeN1dGHe18y8moBnkQEywoLqziLHGDuxnDn8J4cAJ8OukuF9yoKpwj1vcTipNNDuDgNq4D6O8aB8kAb8Q3kBPe2DmtLXV7VAq5Z40mv/MqEStbgya0jJt+9uGYHzqz2sxIjAVquwrhJXydVOBF15O/WRAw7oesZSa3DqKnMRUJhjj42ogN0CTReTgrlzchgeF0rhhp29nLj4TFz04FnoKRbikH1svr+RKMxXYi9q1O/VXoajB4xgCPO1bt0o2mhdoTQJj5Yc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__vmalloc_area_node() may call free_vmap_area() or vfree() on
error paths, both of which can sleep. This becomes problematic
if the function is invoked from an atomic context, such as when
GFP_ATOMIC or GFP_NOWAIT is passed via gfp_mask.

To fix this, unify error paths and defer the cleanup of partly
initialized vm_struct objects to a workqueue. This ensures that
freeing happens in a process context and avoids invalid sleeps
in atomic regions.

Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 include/linux/vmalloc.h |  6 +++++-
 mm/vmalloc.c            | 34 +++++++++++++++++++++++++++++++---
 2 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index eb54b7b3202f..1e43181369f1 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -50,7 +50,11 @@ struct iov_iter;		/* in uio.h */
 #endif
 
 struct vm_struct {
-	struct vm_struct	*next;
+	union {
+		struct vm_struct *next;	  /* Early registration of vm_areas. */
+		struct llist_node llnode; /* Asynchronous freeing on error paths. */
+	};
+
 	void			*addr;
 	unsigned long		size;
 	unsigned long		flags;
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d83c01caaabe..9e29dd767c41 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3687,6 +3687,35 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	return nr_allocated;
 }
 
+static LLIST_HEAD(pending_vm_area_cleanup);
+static void cleanup_vm_area_work(struct work_struct *work)
+{
+	struct vm_struct *area, *tmp;
+	struct llist_node *head;
+
+	head = llist_del_all(&pending_vm_area_cleanup);
+	if (!head)
+		return;
+
+	llist_for_each_entry_safe(area, tmp, head, llnode) {
+		if (!area->pages)
+			free_vm_area(area);
+		else
+			vfree(area->addr);
+	}
+}
+
+/*
+ * Helper for __vmalloc_area_node() to defer cleanup
+ * of partially initialized vm_struct in error paths.
+ */
+static DECLARE_WORK(cleanup_vm_area, cleanup_vm_area_work);
+static void defer_vm_area_cleanup(struct vm_struct *area)
+{
+	if (llist_add(&area->llnode, &pending_vm_area_cleanup))
+		schedule_work(&cleanup_vm_area);
+}
+
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				 pgprot_t prot, unsigned int page_shift,
 				 int node)
@@ -3718,8 +3747,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 		warn_alloc(gfp_mask, NULL,
 			"vmalloc error: size %lu, failed to allocated page array size %lu",
 			nr_small_pages * PAGE_SIZE, array_size);
-		free_vm_area(area);
-		return NULL;
+		goto fail;
 	}
 
 	set_vm_area_page_order(area, page_shift - PAGE_SHIFT);
@@ -3796,7 +3824,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	return area->addr;
 
 fail:
-	vfree(area->addr);
+	defer_vm_area_cleanup(area);
 	return NULL;
 }
 
-- 
2.47.3


