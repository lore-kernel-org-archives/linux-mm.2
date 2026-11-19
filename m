Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92BF5606A32F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 00:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=Gqy8kzfX
Received: by kanga.kvack.org (Postfix)
	id A654F6B0609; Wed, 18 Nov 2026 19:09:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A16076B065C; Wed, 18 Nov 2026 19:09:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92C396B065D; Wed, 18 Nov 2026 19:09:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FBD56B0609
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:09:26 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 16B1EA8540
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:09:26 +0000 (UTC)
X-FDA: 85449934332.15.EC6E7C7
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id E82601C000A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:09:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Gqy8kzfX;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795046964;
	b=F19Kn31ORUJU+aFsIlckUYUSAhLBTdZ//vsTe6yA0VzdR4vAYCusWHkB4WRSbnCSeL/3Ag
	/x9ZYTivVElSzHEF+HzCxcDsa1iA+FNlITpUlbhb4Gw5zwjBOmWr+BQbxVJtxEI0vFa9+j
	52lZON6NJq5cuoAFGVF7Fpy3Og5LbLY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795046964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VqcrwoCztAKpY/Tq1T0uZhbHihAEPIjWKmk0N4arOGA=;
	b=AxFoZuMxao9Mzg/tO06gPCStBcgXqWrbNPXBvofnwnm08A0E6Yly4ZrLKBKvzD2z0JyaLN
	QzJmYt0wj7QLgafTjaRykl+sXivofrQ7Dyj0VnV4vi+u6rJte8IKk11lVOJLrtmJCXfdG7
	Vvc+9i0bDhnfzqAwDbpCXSPaSkQiRkM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Gqy8kzfX;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-8b503e2a87bso12373897b3.3
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1795046963; x=1795651763; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VqcrwoCztAKpY/Tq1T0uZhbHihAEPIjWKmk0N4arOGA=;
        b=Gqy8kzfXHT6HYodaGQooVg9WPAaN3JLJlsOCOsfpF7xGGRMSPBru7MLUyrMGZisnxJ
         oZlM8dNaPO0EvcRIQUyzLTigj/5ZalxCpNk+RpauWawPloYf/syFQjDVqk0Qsi/L/YpF
         tkuVEaBjsztlziPVFeHsADn+VYEIOwKuNMFJ/bstwtLlSX3IpbLoKRqrwFrNMDkBNkYN
         L61N+Z3DsSEpaM82EK/iHq6bF+5+Kz+lEJQ+3XXa+AZ4Hb+DbpTrXSnyCOJAPZenhGKR
         6GnVGaNfkWtK3j7dvcGZoTO+UOaUDFDcZGTrZGhuwnyIo5+7IPAKOUGCDazhDnHP13KY
         QtWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795046963; x=1795651763;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VqcrwoCztAKpY/Tq1T0uZhbHihAEPIjWKmk0N4arOGA=;
        b=Dy+nOgo7i+/GEl5tBtAwOdjQyBdZJ3V1QJbLUZgvULmhNMqqkOHVhNHU/CTKM5cqc4
         Jyt65mzix8E4HZ4E7MBTvkh8Cb73ZEJE+RFbQH4XCub2WtgmqGAQJodwdYBtL2t8rJQc
         rux8ndbD+LbSIUXRk+XMFP2k8FWMEKUDEn6+iFPR/+NwGOo8HlWZ6JSPdmiDHasVsb7V
         rp/NjGgeYnYvJWWfPX/Q3JBCu+tgbAKsFIwaSeLs16JgyEpGt3hTFj9adwJGjdTxicxa
         AWiXpbcmZGSEEGMPEj3x+w+xgYk+WufFJt8YzwBvQuw9OTA5gTZOdx/byBFjRMNWd8gW
         l9ng==
X-Forwarded-Encrypted: i=1; AL+hErHN9vLzkHYVyciqh9K5F3cuKzEyW/smi4EtXotcLTQrUtwV+c4A2aZgaj5qRrjQWNvT649nBVuSXA==@kvack.org
X-Gm-Message-State: APuU4Z/q7RtvQpihPHu8uLgd4DVqIpZJyJpeh50raWaAUhEG0nx88IgL
	KIEHP2qB50egbkOXhjdl4arFpyIIHUv+4IqgGhuRNHjfCJpiCyUBLrd7WTCPw5FgcvQ=
X-Gm-Gg: AZFdTZdqj/atIhJAEr6r+SP+kXQowrUCnPKFlKHsjXu+zTuglTVcLv5czLpo5PoIZc5
	JzAQTe1o3s6AldPQtFRURmd/3sqAmR8i+L7PSEPT1FXw2ZG3IfANEkSYND2zdmofdA/bytCk4ZL
	II/Sr8S4jwIbpKJApn4qmEN/CVu2eZHYJARvYgfDlhMbfy4uC6sSHiQ+N+yD6EGHctTTr9pnCFf
	78smCX07mtXzv3JdYMGVJsGeYl9pyRT3bDfKQGIdBKBMdrj2j/oJAMEvDqwiAac57/sTvOijtW1
	wmmITdFLkBk1ZKBLqqiVr3bJOYhCnh2jFG5MAvRq8vGYLV/OlBi1rxcceJxQRvLV+BGE4FWxA5B
	OkNCr4q31GF9rX1H4tE9wWZ6RcHkOCVZOL6Blq9rYImHiB51nAsWMwmcsb11jRxJEd7ClAEyJK1
	DMXyLFPm0Y1QyXRKEH7qFGgCSMQyRbg8a1YndxVoQ51SP0lbE+oVO473vAhuD/6f9V8vUxlqHI0
	mDqb8GO8PUTBdjqFfSs1r33ga3/J2r2p4PCqZ0U23/olmzl27J77CACWeLDGoQiOt+v6o9bo0qB
	u6qV4oN26lycvTr7EBFZI2tRw6sFZHx1kFgvbvvs4ZdQYkafIA==
X-Received: by 2002:a05:690c:6d83:b0:8b0:df71:44cf with SMTP id 00721157ae682-8b4fed0a8f5mr20096457b3.15.1795046962815;
        Wed, 18 Nov 2026 16:09:22 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4fe03091esm26030767b3.12.2026.11.18.16.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 16:09:21 -0800 (PST)
Date: Wed, 18 Nov 2026 19:09:20 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jaewon Kim <jaewon31.kim@samsung.com>,
	Jaeseon Sim <jason.sim@samsung.com>,
	Youngchan Kim <ycshark.kim@samsung.com>,
	Dmitry Skiba <dskiba@google.com>
Subject: Re: [PATCH] mm: workingset: compare shadow nodes node-wide without
 kmem accounting
Message-ID: <av4-MCNVImLfcmMO@cmpxchg.org>
References: <20261106235904.1092712-1-tjmercier@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106235904.1092712-1-tjmercier@google.com>
X-Rspam-User:
X-Stat-Signature: rt4pir33x14jn3baz33mq19w7tmkmaua
X-Rspamd-Queue-Id: E82601C000A
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795046963-575028
X-HE-Meta: U2FsdGVkX19BYetOYW4Sdl7/MznQtmWRSM941By+wlQEC+TfmwfyP6xvWb+zoQbEzfVdJEc7z/hH2qTophgI4xnwVqF4ZnW5cdPVoZBr5P7jKgnUTzerqnqf+F4Jnl6YRMxMSrD7nydANvcgmsiLB7SPxUFm9y+hFy1NnGV/tjm2eWFauVz3UJvvTt/Y+vHcuomwJ4SI9altMOEHUSw5fKz0anZPfUIIx3mxdMTxW68Sb9Afb2wqs/EACIKRRj6GBmMMu8ulEa8BNMug8LKim0rX6MqTBEX8j0dnW3ysAm+odO+CRuO3/y3+OgRgxt3g8bs+xMtnrH5VW0ASIe3rI/EQUkHhMTbhTQ8SeuJye+djdC3PpFzBSUY3RSSFuHTZCwTRCYfeoGIX3iuTiipxqsm3WxEQE9FjNY7xg/g+CzVZZFJ90qhFlL2wH6jauxoxkiGjQe7dieol6UwIfVPd8U8BtUIXW6FWC56ObnF+5BTjk+mqcmQpv0Z0Der5p6+uxqEMD9ZqCHQSn/Ss+xPpCrBjMip0I9jJlvUw9y4GEbMx9oAF9uxwUEmKcfX0jMywP0vhKh0d6C9gi0JCgYVRhFj4UkjP5ZzfOAKomfxOPwjTj3qkHt0SeRNbyrT8hOWLS8epv+kbXE1WB87ZpT90GhLaL/FIsoMyqawB/BboP1UzyeHFge3HD5t/MX9RTsAYgoqTp+HDNzSTE9EW6iPQwKbJ9RbH8Glq+WSOuHU1ocQoSY+a6kZGNpdFSwCCabO8OHbQij408SpEaO0FR4OaKlN++MONj9qTmEGGhpDOv5dGw8jkld7qK8zsHTMNCQhkuiIFYnZJ7zu0D+yeBvVbs2taYh8MI2GN3QENe3yecMcNkzZ+5wxpFVRCLY/DAfGtXAwNfq3lSLg8A8kVbxOinzz9iPIxsmN/2TD/y/9hhlrQXLK/l7TQVLoK4qSyytx4N4zRGc8zeXomaa9MCvB
 litdU50a
 Pf5AcfFIZruJecF5wC47NYhCZQP4fNHNRzohFfY4J15qLV2ePFkYs/PWr2TJzISyHUj7cAcvhY691ku6nPl5HQOvFHoJ5xRhu9jEDKERITmsxZEChbsN2+3LEs+xpUaxffgnsHoqhtja8CBtFtOqjnqFzTrbbJJMaWao2M2rFhibUfcqIBMbOzZcxNHSkcMUM7ogdvGhRQ7XqYnRUajYbfAeGfeN7oGqsZvZM8qGlaPpXhbWwjRA6NxxbTZPEwBRL5vbiSYZG9jLWAUUpApsDx2mDQBx1AhmKHFRtqv93oTxSAf/CicySUzbgxg6AtNusVQ0EIXk0EJFS45Z75kVdBPhQ2zh5qN6dvGXP8CdmVsW48xOzV3yNrbsNjrgdXV4Yi+yudnEgYOs90CNBeJr+dTa9rN64OsVfIDul4/pZLAXpH+rGLYTLkqTnqPQcAiJAJZcYGoVYXp95x8IxahJSyNi6aij6ufRFegwZAUqUmeaAhY+kWCepB4/SUEzxNpV+BQCQfFoABwRwycSm47Ekn9BBSHKdiV9DYe1lCT0YbANd/Cua1Cyqs9LRR7EaRPGaiMtEqfDmuLp8By77eiIfrbBRsAQuVawaU+fr2ii3EvNBgfvKgmg3Qppbzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 03:59:04PM -0800, T.J. Mercier wrote:
> count_shadow_nodes() limits the number of xarray nodes holding shadow
> entries to 1/8th of the pages that could be using them. For a memcg, it
> counts the LRU and slab pages local to that memcg.
> 
> With kmem accounting disabled (cgroup.memory=nokmem), shadow nodes are
> not charged to any memcg and __list_lru_init() makes the shadow_nodes
> list_lru non-memcg-aware, so all shadow nodes of a NUMA node are on a
> single list. shrinker_alloc() falls back to a non-memcg-aware shadow
> node shrinker, which shrink_slab() only invokes for the root memcg.
> count_shadow_nodes() therefore compares every shadow node on the NUMA
> node against the pages local to the root memcg.
> 
> When most tasks run in child memcgs, the root memcg only holds a small
> fraction of all pages, so the shadow node limit derived from the root
> memcg page count is far below the number of shadow nodes on the NUMA
> node. Since the shrinker has seeks == 0, every root shrink_slab() call
> trims about half of the "excess" shadow nodes. Most refault information
> is thrown away, so refaults of recently evicted file folios are not
> detected. Refaulted folios lose PG_workingset and the workingset_refault
> and workingset_restore stats drop.
> 
> In testing on devices with kmem accounting disabled, moving tasks from
> the root memcg into per-application memcgs dropped workingset_nodes from
> ~37,000 to ~900 and raised workingset_nodereclaim 4.6x while
> pgsteal_file rose by ~12%.
> 
> When kmem accounting is disabled, compare the shadow nodes against the
> whole NUMA node, as is done without memcg. Behavior with kmem
> accounting enabled is unchanged.
> 
> Cc: Jaewon Kim <jaewon31.kim@samsung.com>
> Tested-by: Jaeseon Sim <jason.sim@samsung.com> # Galaxy A18 LTE
> Tested-by: Youngchan Kim <ycshark.kim@samsung.com> # Galaxy S27
> Tested-by: Dmitry Skiba <dskiba@google.com> # Pixel 10
> Signed-off-by: T.J. Mercier <tjmercier@google.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

Looks good to me. Yeah I don't think nokmem is used by too many
different environments!

