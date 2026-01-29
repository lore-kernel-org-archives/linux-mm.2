Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90835D73E9C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:58:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AFD76B00B5; Thu, 29 Jan 2026 16:58:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C2296B00B7; Thu, 29 Jan 2026 16:58:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 109AF6B00B8; Thu, 29 Jan 2026 16:58:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E678C6B00B5
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:58:26 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9EA758BB11
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:58:26 +0000 (UTC)
X-FDA: 84386365812.02.D0553E2
Received: from mail-dy1-f193.google.com (mail-dy1-f193.google.com [74.125.82.193])
	by imf28.hostedemail.com (Postfix) with ESMTP id CA763C0010
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:58:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QwNpxtTi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.193 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769723904; a=rsa-sha256;
	cv=none;
	b=S9QFScuNuglxDZIcmiL2D7s7bohGAhnY7DH3jOm5PdTSxecIC5RJxgD63UmbC+drSuwrNZ
	5yrI7BiRV2/Py7LGGdSJzTe66DYozql6S/quwwkaArxUU2PFArmBUt/ZXrYuhLzD2cHTwJ
	8xitqzMIC3MmSSdf5xBMW2tjMYEiJ/A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QwNpxtTi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.193 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769723904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nmNgqwiRPaM50yoR4bSwou2vHJzKZmxQW0OFYL7FLjQ=;
	b=NhWzrD9k9yk5O4p3LFWgjPJsA1SHllLNGB+ziBIvN8o4RqB6ta4g6aihrtmvB/0bfyLrl4
	LEk2/4YKYGLFy32dvVOld0k+W15dR3Igs9Qy3+UqUKA9/GGNkxZFH3PXqRv5JuWPE/75OW
	dWBj5jfkz9xVDSxZdUFg0CzqBTPvRp8=
Received: by mail-dy1-f193.google.com with SMTP id 5a478bee46e88-2b73112ab62so1615316eec.1
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769723904; x=1770328704; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nmNgqwiRPaM50yoR4bSwou2vHJzKZmxQW0OFYL7FLjQ=;
        b=QwNpxtTimXw3ozDPS8+yBOre97/Dt4VFv3Gt5HF9xDTC3H98111hj4+AkObpSuPJBF
         dLSac3wqblUfHe8eTux6+Duu7F/ka2iaWpEkMmeTS734qZKW30Ep0FuV+fwyUXHorDnH
         12faiVXZRj5OE4MoCi75rjJKSKtuMp+AZJvA8Kt40A9cmFqMx/Xy12nN2tzKabztz4ZC
         f9KyqowTmPTp3T5Otk44rTi05SMNcsgXxk4d1+KssMF+sYiqQfZeeZ5NIZU5R9jwtJwx
         fOYd/bUdOZU+AEwo2/jWhDCaoeYryOQnn1+8GHXcG9p/HiYlouUwTLT66fXL3LO/1cwd
         f11A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769723904; x=1770328704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nmNgqwiRPaM50yoR4bSwou2vHJzKZmxQW0OFYL7FLjQ=;
        b=F2wPU/a5hPnQHxU8j/e0cTMgsMMmfOybHXXCACeVa6Ur+F/eG35Noq7q/q/ysEZCCK
         T1BjlijiphX1fH1FZ/rbMbJWNXJEFdWhhTjAamSM64K9nqeIcfYAMuabROURjpq8xAie
         UJXpnKns6vWpRDv+MHFnJLi9dA1ea3q8hHlU2DuLbCNWzRz/eBz0qhXgwYxrQuneLqve
         oVhm1Ikqm8GBdW+zx+QbvA34FrtVUuKL2XjnSQGqu52j+OTXwuakbK/Z31e6OO4sooKx
         woOJukbl+MWaiNfxNeVX6ZIK/BP4SzznTUdi2C1ACP3DpJEhMyZTXpMhs4yxeyk7ZWyf
         wo/g==
X-Forwarded-Encrypted: i=1; AJvYcCWZ05W6QsidL7YdO/PDHD439Hpz/1yekoh2zjL1qQz6XrD4sKPvcYVPvkl/Khh8xJy8tTzA67DFVg==@kvack.org
X-Gm-Message-State: AOJu0YyzUntb7cLhN9bgS8OhLY0cusI5V+C/ZMHKEsMWObP2KYJZzNvI
	olIkG/NULTTeTNuvni87uyxlOwY0JOEyqbDS/v9IQU57uzjVSbdat+0=
X-Gm-Gg: AZuq6aLzEUSCirjOCNboFqhyet63BCGTbaD1hld++h7MGZbZt86dIuc5AE2e60DiiU1
	xZzmffp3oEzULjWRUBTTyELnt/RHW/k5m/ifhF6+SiuCdueiU9GdWOBuEPFudYmBvYV3w8753L2
	MHyyExW+PcrPDDX9Ch+OoZcnORvp0LaQsI3cQGEo4YsmgsXR93ky42WBELsWZevzKU8abuGVaSG
	8eZW6+nS7B/NsfYnb7kVnhd9vrEtqTd27Yd3q7kQJvDPXpT/OLnoWoIUEWva3RuicFGqDoDdUzU
	XbZFgb1ZHWBNzIVt6FQv5Ea9syhAorQGZkPVL1iTu9liTGZXFjCEgsZMPPOSH8WQtbNHcZJY55m
	3flsJMlIbCZ6IYUL9duA2XDJoyaqCOdAH+650PSSzsP665g+VWQuvbJG0iQVCqf74Rern6hgjyY
	utxjuLi/7sRQ==
X-Received: by 2002:a05:7300:a984:b0:2ac:21b5:f43c with SMTP id 5a478bee46e88-2b7c86db7e2mr415692eec.20.1769723903529;
        Thu, 29 Jan 2026 13:58:23 -0800 (PST)
Received: from localhost ([137.201.204.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a16cf8f2sm9659960eec.7.2026.01.29.13.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:58:23 -0800 (PST)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Subject: [PATCH 3/3] mm/damon/sysfs-schemes: expose NODE_TARGET_MEM_BP metric
Date: Thu, 29 Jan 2026 13:58:14 -0800
Message-ID: <20260129215814.1618-4-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260129215814.1618-1-ravis.opensrc@gmail.com>
References: <20260129215814.1618-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CA763C0010
X-Stat-Signature: 8g9x7d4bnbysutswiqabk8rpxypq44oq
X-HE-Tag: 1769723904-706365
X-HE-Meta: U2FsdGVkX1/ac8czErYoXQ4AAxA8h2qIbZHi2HjDld6FW2+JjMRwA6VmeFsmGTAfLp/Wax2EiDVe6y3iLQDhB4bYSdVEmqJne2sbOhcByLm0M4eQkfmX04JUX2sUAmdPBCp4oeh00dhCS4msbqGqgok5oQXutYcHE3Ym7/kGLp9KsJxrGI8qasqgI8ZVPMdvpOjpU47GjhNEeW9t1uoEdlflI+VIvNMpUxZsiclZtQ6KHpE2VJZ8s7Y0OdSdxacmuR7PSaKwT6S5UKCIhDKyk61T3lWccjkyKm4uNHaKyedqWHnbucBQX3IQbdNXPbcIHIM2Dn+nGtqE33D1yz+fwZPh9QqzLh4vQpmddAaMjXq+g3M+628dD2g52IcN0+/zTMWBi9zRdbqNyqb1Q/y78VorGjrn60l0ZUZrZqazUZ+QkGsQZqH50HKTIAY2vhIdqV9hNYIW/iquNqMjktb3j0s97N8e77OVTiXPOS60KottwTGyCjsNj8Ps/lVp9C+Ym+f79Ng0SDzMKsrRuxPkb/bK2snnvLq+y7ZYLS11l4rpb2/Tw5Xct73TyMi9vIpo06QR939lEWwGV8FPDovZ4uXFfOf5UUu1tM6c4lJEbKFPXr9jff6LrLAocypGB2HhjJyJEGgJfCg+jPCknbnrfoyFaAROwFk3KavRbrBWVFsdTcrQdsfzSnzkF3NqycMKuK0g5fd2urvtIdYCnzY3oQGYrahvT29XyWdKtMt3S3XxUlp5Rpp08zCyAuVVSB6uJ5fDCcGB7udWNyPK1GSDtP4reUXng7Zeike6IzCe8E6YRlGF8RCHTtV8gr1Zvbne4RrZ2kVL/uyXGfey+vX/smjIwWhtif+Feb+bTMLI40DkJMkZ5Bfn4rjFYxk44TdZGw8mWXcGC37AZg8+JrRuUFcVAQen9HwErswx+Kzcr9qOFZI9Rhsvb4VgLb0wN5ndExTKbu3QTHSp9gvhg/I
 +zi0MERf
 Rp9w07lamyjx9NsUFC4JF22bxNeNyS4fPnYUgNX7uZnoZxXWykxVdzatv3b3xwja+Oo9PovnPmR4BK8UpgNlVyyT4VAXxLu8LulBFtbmy0ak/CJ51H6pai0fYBDqQbP4Bm2+xu3D8D0/ln6lrq34gTRQEAj3FoSL9MwfFG8/rwQ9Y/+I7dtUAPeILiDj9qZXI5utLIS8Lj88+79VV64K2j1nb0ZQQwgmfuJsm0U7ee0MPCUebB/q4+uSWS++k0KxiYw8ceVd4czNb2a+5euA/O0u9c5VKukgG0NjWc2vqnrZQztqek98wAKuWyEK+69T1bXMqN5PK/Z/hzOVkV1pswL/zvNnbahqKn/AFehMCJCFhHqsJXJGWjMRPwiEfHVcC685JYljVMB7t+vO5YF2QM5m7axgd2wDA8evDltj3UUv9O8r5QG8X6lBG94DL83W30+/91+8WnQYdMOWvVc6WMAmskhN8PjPDuNrkrKmf8g1s5WcP6sT+A1cN2u9bCIyba7Xxse/0tE1QOBp2Wn+p9XJnt4xvYWjy9PTn9g0ildPAnxvvvnxpsR/RWnvIXRcVYE/3T4gu38oY+KXWm6gVD5DuzD8Q0OpSXeT8JFDfQdmQVz8Zwa1pt3857CpVzHWRvkgS0mk3GCMfFezm80bXX1fJKKQ9rJz2zS/DMRa8Q4v6yzVtm2RlbfuZgKkna5vUyKjDvJ4qul6qLoBMPYqw7FtBSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add sysfs support for the new NODE_TARGET_MEM_BP quota goal metric.
This exposes the metric as 'node_target_mem_bp' under the quota goal's
target_metric attribute.

The metric measures the ratio of scheme-eligible memory (regions matching
the scheme's access pattern) on a specified NUMA node to the node's total
capacity, expressed in basis points (bp, 1/10000).

Users can configure this metric by:
1. Setting target_metric to 'node_target_mem_bp'
2. Setting nid to the target NUMA node
3. Setting target_value to the desired ratio in basis points

The current_value attribute shows the measured ratio, which can be used
by userspace to compute the actual bytes of scheme-eligible memory on
the node: bytes = current_value * node_capacity / 10000.

This is particularly useful for tiered memory systems to monitor and
control the distribution of hot pages across NUMA nodes.

Suggested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/sysfs-schemes.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 3a699dcd5a7f..50133263c592 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1038,6 +1038,10 @@ struct damos_sysfs_qgoal_metric_name damos_sysfs_qgoal_metric_names[] = {
 		.metric = DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
 		.name = "node_memcg_free_bp",
 	},
+	{
+		.metric = DAMOS_QUOTA_NODE_TARGET_MEM_BP,
+		.name = "node_target_mem_bp",
+	},
 };
 
 static ssize_t target_metric_show(struct kobject *kobj,
@@ -2554,6 +2558,7 @@ static int damos_sysfs_add_quota_score(
 			break;
 		case DAMOS_QUOTA_NODE_MEM_USED_BP:
 		case DAMOS_QUOTA_NODE_MEM_FREE_BP:
+		case DAMOS_QUOTA_NODE_TARGET_MEM_BP:
 			goal->nid = sysfs_goal->nid;
 			break;
 		case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
-- 
2.43.0


