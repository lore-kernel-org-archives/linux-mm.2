Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9CA7E85367
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 14:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8B5A6B008C; Fri,  3 Apr 2026 10:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B14006B0092; Fri,  3 Apr 2026 10:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B4C16B0093; Fri,  3 Apr 2026 10:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8A43F6B008C
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 10:13:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E3E914065E
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 14:13:19 +0000 (UTC)
X-FDA: 84617436918.26.CF4C05E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1A2471C000A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 14:13:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mvw43mvB;
	spf=pass (imf21.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775225597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q7VPU0rCKfWfvPJl/4bosCPDJZ8iv97Cw6zG7IjIUB0=;
	b=3/tLeYV3gUzFL43aZMeomsN0opyreIBQ9URYf5mfF2WuofVOBPVlkAp8dZypINNYIvztEW
	jQb3IQqMBu/K8EqoabsisE4tIM/VRUEzTczQoNA55/s2Pu5Gocww+MsCj9deilcYuNrvYi
	ASapfCGnubLNqqw49E0OwDIaRVPqZL8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775225597; a=rsa-sha256;
	cv=none;
	b=OKjAW/Ecvn2tJcVEtrG76cb1mhrjLZlvFjDS80ugCZsmhGrqIustKw/feqbUckwxpQK04L
	6yeusn+12AP3YuodTKchwtgzts/AkIR52K95TNU8Ar7ONc60f0Ak5fE/BG/UcvsMsiS9nO
	xz21Nzeqd0/dJWlwGxtATjhscFyVgb4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mvw43mvB;
	spf=pass (imf21.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775225596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q7VPU0rCKfWfvPJl/4bosCPDJZ8iv97Cw6zG7IjIUB0=;
	b=Mvw43mvBveue6wUU4etsmb4EtRnjUYBj4bo1UKsZTpKeKvmVuZm46xXPF53caUFMCjLtzv
	pqARb/hvVXm1ylR5iG1HVzIU2/DAQuo8ioQQaI4Mpd80hKEd30DeVtw3QVhC32C3/MZU5u
	QgpXzoBRFvlbNp2kUIIU2dGjORILyVk=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-LrsZzz7tOqaGUbxsyqSfsw-1; Fri, 03 Apr 2026 10:13:15 -0400
X-MC-Unique: LrsZzz7tOqaGUbxsyqSfsw-1
X-Mimecast-MFC-AGG-ID: LrsZzz7tOqaGUbxsyqSfsw_1775225595
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-50d63962d83so23980501cf.2
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 07:13:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775225595; x=1775830395;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Q7VPU0rCKfWfvPJl/4bosCPDJZ8iv97Cw6zG7IjIUB0=;
        b=HBT4gsRCIueuXb8vdBTB2GPNLwI21oZ/cf8BZBNy441pyhKiUvuMe2NGP1KToAA7Sj
         KISNn7EA59AM4+DQRkStP+EtTyPhftJ/DCts6dqJdEODXvrTEMdom8zjp4JqeyHhSBJs
         RXK2wTG8FWO6IoZnkj1P2Lk6bbXkxOCZoBWOYhGfLsFnMe2qgo2IjgoKl+Qp51l9isFW
         nVD83psI4Kbs3nfmKryeKeDLzc6uGB9nv/4x1BswSojwtZTc4gAfBldjWZWKtszrHLEW
         J/zpmAryPndPf5o1VsatDHN5URO9Y30eWzIVa5BA9WXLsmA22/onJM5nb7cyG+Vh/u6A
         VVuw==
X-Forwarded-Encrypted: i=1; AJvYcCVIcp3tLsCWCyk8sKFftXjp9zXC9SiGUsbQ1i6Mz8B1ibyi8A8XS9hnMCRjhD2FlF091KqbTJ0nFw==@kvack.org
X-Gm-Message-State: AOJu0YxwQ2NrQNf1kk+NHXQjsG5pqBYVpCIT/GKi7UeiYMaXrL4XguxJ
	ZBJ6CnD24QWBWqmaIWOCX0cmuhAbI2XuOgk9u1r48mQ3CZoRI86/jBELyAG6OAnOy/F1ds0XmKi
	GELrgdN0iiaghClUre83fKGzNwrWRm3yLEwhQH505BbPvlHc3h42V
X-Gm-Gg: ATEYQzwkVDs+rM2AR8piz4F1cOG8CdbBwlqBMgxPLwIIpiIJVA6r0sGI4wRu6XWZOu3
	5NE38lvWXjkxeb4dHP15nExQOkz39yj6cOUsRO3ASO9EDS2k/HzFcPxFAVJMAqC++a+LxxqiHIh
	9Qi6D0E6x/lVg7lBL30aacWGwqvyyicS3Hf7BKDs33McR6mhr2ycknTYDFOT2DO7NfFTT5saTrN
	cYkI2s2rPUs5tj5psjFCWBvrPCAwNP5xt7lTQiiq6Yok92b39wJHu0RDCfdyqJFNpBD9l8vvRI4
	0nTxhMPKHpL+srVhu4Vf+mD2A5J4xKkog9R+DKYzPKMi893P4iXlwFIhN8Y1P37U57vAA0RfT2i
	jmosHtb6sl0lpaz4G15MliZEMI+k3ueZChzD1bVvClhQlULIfpl/TJWeT12n0Xow=
X-Received: by 2002:a05:622a:1922:b0:509:2ef7:7048 with SMTP id d75a77b69052e-50d62cd74e1mr43969891cf.66.1775225594379;
        Fri, 03 Apr 2026 07:13:14 -0700 (PDT)
X-Received: by 2002:a05:622a:1922:b0:509:2ef7:7048 with SMTP id d75a77b69052e-50d62cd74e1mr43969031cf.66.1775225593742;
        Fri, 03 Apr 2026 07:13:13 -0700 (PDT)
Received: from localhost (pool-100-17-19-56.bstnma.fios.verizon.net. [100.17.19.56])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50d4d9ad4b6sm40723031cf.15.2026.04.03.07.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 07:13:12 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Date: Fri, 03 Apr 2026 10:08:36 -0400
Subject: [PATCH RFC 2/2] cgroup/dmem: add a node to double charge in memcg
MIME-Version: 1.0
Message-Id: <20260403-cgroup-dmem-memcg-double-charge-v1-2-c371d155de2a@redhat.com>
References: <20260403-cgroup-dmem-memcg-double-charge-v1-0-c371d155de2a@redhat.com>
In-Reply-To: <20260403-cgroup-dmem-memcg-double-charge-v1-0-c371d155de2a@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
 Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>, 
 Dave Airlie <airlied@gmail.com>, Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.2
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vAumKdwholjm8VvSGzBTRLA-VFCHLxL30YGenE2AG5o_1775225595
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 9yr4rcuf6obgcss9p8fw5w3co4x5caw3
X-Rspamd-Queue-Id: 1A2471C000A
X-Rspam-User: 
X-HE-Tag: 1775225596-226349
X-HE-Meta: U2FsdGVkX18s/it2CrKHtVtewgO6D6GIpopsadGLNzg2I1cR3+GS+ECFvUPnvkazuW4o7BcOBeDGbzKODAUYEQBZOI1G7q+rdp7y8Q51bvKIevfyu43Jb1tknsYPEFHe0Zvbz9rRXdeD8kpxrJ5uJSu7+ed94sW1VzeCpBPCm61/IEfAOPNNuAVvaq7PFk/MusxtPkcfp4ZaFsI6AZxWjk7LUK7dEh+lbJZJNY69m65yKCZ2JOqs1d0cJTtU4o1UMuY2l6xhddnVb8/V72z/UyFQ4TzKBgAQh7dqIezQ9WOISAK8H4hPCe+GQonmoaYt30X48LnQo7jgrjKvCS7/bTVmEM3YuxBp1jSWs67ZW3nj1p7+ZhZySD5Mm/sjXl9fVX2g8aE3Rt+EtnRp7bqkOTYTl+k1FlA3dy8NWYbMVHwe0JeHXDgl3KRkwSxPYnsD6xFC1zzoened4Ytc/9aYX02N/qpncxEM874+e2NSfrsbG07liJ80rbnrhQMIYK+w6ft98m54RIg3RMcRw4tkAGoO2eJNILi8e9TWvItf1ZWSzahF8caiJiAcbspqvk16819PcietPn0LuuRr+DkbRv6KOgvh8zEBA0OsxrVD1uq2T/Ajkm2yy1RrRY4VNZUuT+RrJCvCRNGcK5M3T2w1dWJadDE+opdsNrIzdtH/dCzZScqiINsPeUJeOhefOz+gOrVDdNoDXbEhz5WvSySNqjXOeLGvHtaQb+NLnvGFHXWC4N2zXoiHEDoolVDOom/Dye5id+d9qsOlG6fzM+GhlM81V3QzVgvnzI5lR6q+2kfWbMaSD2aQhtjz+S5fsufm6ZBK6Ui/QbUdIPiFzKuzlFvfn6biNjJpxMPPOd8HGbnAkugIjDZcgr41xU3dqFM/hqiOl6CYFw7IqbWjvEoztOA0XAlp4dBNysXB3vWLkao2o1LPRBxWMeuQ4iMW31Mio4Le81kmJR73xtIYt6e
 lfYataIw
 vwTlpWJ7FW+ha0bG1sEhcY3ET3hY5sMrO9HcBVMJg/HHVyYhP3G64QVVkyzZjuq9r0nu8E2/BTKElse1r9cXKIpVUc6XK4MviSJgvlP1kCKbTCBhCsHtJBs67ikuICKF6hBqgY1CtmPqTob71txu0qDcnCM84WgiDMoeHQO9o1bhitTnRhlmxbcb6FJpnPjmz2+tBvu5Fmu4ETUpSJ4o3AqGd6gxa4AWWvRMbS0s7K4m5sXq0F8eW3Y0Voop71MxayZMYMvt/iuSk3P7wCRs8P3sp6zZIhkry0tMYBAjOJFcbMH2irflcyPZTeLTG1CO+u61R/T4B01PoQSm9Aa6YTaci6hLkYtRX7389HoPVz9o52EOToVZAbVc/ppNUAVEubHmNJTm13kwxWqFfrQf7D+dMp3uyX+LdFwlucIxe3BkxEJzGQiVkCYx0Daiec2AAQC9bfpVsN1VHecj3m1mynAJWIcK9ci8kcNang4ygCQLiLJN2+kiT7ZmkJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce /cgroupfs/<>/dmem.memcg to make allocations in a dmem
controlled region also be charged in memcg.

This is disabled by default and requires the administrator to configure
it through the cgroupfs before the first charge occurs.

The memcg is derived from the pool's cgroup, if it exists, since the
pool holds a ref to the dmem cgroup state keeping the cgroup alive and
stable.

The behavior is quirky. Since keeping track of each allocation would add
a fair amount of logic without solving the problem entirely, disable the
memcg switch once the first charge is issued. Having this as a dynamic
configuration doesn't seem relevant anyway.

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 kernel/cgroup/dmem.c | 86 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 83 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index 9d95824dc6fa09422274422313b63c25986596de..b65ae8cf0c302ce3773a7aa5f0d6d8223d2c10c9 100644
--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -17,6 +17,7 @@
 #include <linux/refcount.h>
 #include <linux/rculist.h>
 #include <linux/slab.h>
+#include <linux/memcontrol.h>
 
 struct dmem_cgroup_region {
 	/**
@@ -76,6 +77,9 @@ struct dmem_cgroup_pool_state {
 
 	refcount_t ref;
 	bool inited;
+
+	bool memcg;
+	bool memcg_locked;
 };
 
 /*
@@ -162,6 +166,14 @@ set_resource_max(struct dmem_cgroup_pool_state *pool, u64 val)
 	page_counter_set_max(&pool->cnt, val);
 }
 
+static void
+set_resource_memcg(struct dmem_cgroup_pool_state *pool, u64 val)
+{
+	/* Cannot change once a charge happened. */
+	if (!pool->memcg_locked)
+		pool->memcg = !!val;
+}
+
 static u64 get_resource_low(struct dmem_cgroup_pool_state *pool)
 {
 	return pool ? READ_ONCE(pool->cnt.low) : 0;
@@ -182,11 +194,17 @@ static u64 get_resource_current(struct dmem_cgroup_pool_state *pool)
 	return pool ? page_counter_read(&pool->cnt) : 0;
 }
 
+static u64 get_resource_memcg(struct dmem_cgroup_pool_state *pool)
+{
+	return pool ? READ_ONCE(pool->memcg) : 0;
+}
+
 static void reset_all_resource_limits(struct dmem_cgroup_pool_state *rpool)
 {
 	set_resource_min(rpool, 0);
 	set_resource_low(rpool, 0);
 	set_resource_max(rpool, PAGE_COUNTER_MAX);
+	set_resource_memcg(rpool, 0);
 }
 
 static void dmemcs_offline(struct cgroup_subsys_state *css)
@@ -609,6 +627,20 @@ get_cg_pool_unlocked(struct dmemcg_state *cg, struct dmem_cgroup_region *region)
 	return pool;
 }
 
+static struct mem_cgroup *mem_cgroup_from_cgroup(struct cgroup *c)
+{
+	struct cgroup_subsys_state *css;
+
+	if (mem_cgroup_disabled())
+		return NULL;
+
+	rcu_read_lock();
+	css = cgroup_e_css(c, &memory_cgrp_subsys);
+	rcu_read_unlock();
+
+	return mem_cgroup_from_css(css);
+}
+
 /**
  * dmem_cgroup_uncharge() - Uncharge a pool.
  * @pool: Pool to uncharge.
@@ -624,6 +656,13 @@ void dmem_cgroup_uncharge(struct dmem_cgroup_pool_state *pool, u64 size)
 		return;
 
 	page_counter_uncharge(&pool->cnt, size);
+
+	struct mem_cgroup *memcg = mem_cgroup_from_cgroup(pool->cs->css.cgroup);
+
+	if (pool->memcg && memcg)
+		mem_cgroup_uncharge_pages(memcg,
+					  PAGE_ALIGN(size) >> PAGE_SHIFT);
+
 	css_put(&pool->cs->css);
 	dmemcg_pool_put(pool);
 }
@@ -655,6 +694,8 @@ int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64 size,
 	struct dmemcg_state *cg;
 	struct dmem_cgroup_pool_state *pool;
 	struct page_counter *fail;
+	struct mem_cgroup *memcg;
+	unsigned long nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	int ret;
 
 	*ret_pool = NULL;
@@ -670,7 +711,22 @@ int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64 size,
 	pool = get_cg_pool_unlocked(cg, region);
 	if (IS_ERR(pool)) {
 		ret = PTR_ERR(pool);
-		goto err;
+		goto err_css_put;
+	}
+
+	pool->memcg_locked = true;
+	memcg = get_mem_cgroup_from_current();
+	if (pool->memcg && memcg) {
+		ret = mem_cgroup_try_charge_pages(memcg, GFP_KERNEL, nr_pages);
+		if (ret) {
+			/*
+			 * No dmem_cgroup_state_evict_valuable() could help,
+			 * there's no ret_limit_pool to return.
+			 */
+			ret = -ENOMEM;
+			dmemcg_pool_put(pool);
+			goto err_memcg_put;
+		}
 	}
 
 	if (!page_counter_try_charge(&pool->cnt, size, &fail)) {
@@ -681,14 +737,21 @@ int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64 size,
 		}
 		dmemcg_pool_put(pool);
 		ret = -EAGAIN;
-		goto err;
+		goto err_uncharge_memcg;
 	}
 
+	mem_cgroup_put(memcg);
+
 	/* On success, reference from get_current_dmemcs is transferred to *ret_pool */
 	*ret_pool = pool;
 	return 0;
 
-err:
+err_uncharge_memcg:
+	if (pool->memcg && memcg)
+		mem_cgroup_uncharge_pages(memcg, nr_pages);
+err_memcg_put:
+	mem_cgroup_put(memcg);
+err_css_put:
 	css_put(&cg->css);
 	return ret;
 }
@@ -846,6 +909,17 @@ static ssize_t dmem_cgroup_region_max_write(struct kernfs_open_file *of,
 	return dmemcg_limit_write(of, buf, nbytes, off, set_resource_max);
 }
 
+static int dmem_cgroup_memcg_show(struct seq_file *sf, void *v)
+{
+	return dmemcg_limit_show(sf, v, get_resource_memcg);
+}
+
+static ssize_t dmem_cgroup_memcg_write(struct kernfs_open_file *of, char *buf,
+				       size_t nbytes, loff_t off)
+{
+	return dmemcg_limit_write(of, buf, nbytes, off, set_resource_memcg);
+}
+
 static struct cftype files[] = {
 	{
 		.name = "capacity",
@@ -874,6 +948,12 @@ static struct cftype files[] = {
 		.seq_show = dmem_cgroup_region_max_show,
 		.flags = CFTYPE_NOT_ON_ROOT,
 	},
+	{
+		.name = "memcg",
+		.write = dmem_cgroup_memcg_write,
+		.seq_show = dmem_cgroup_memcg_show,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
 	{ } /* Zero entry terminates. */
 };
 

-- 
2.52.0


