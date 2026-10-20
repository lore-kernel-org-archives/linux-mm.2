Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE52F606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 16:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=stgolabs.net header.i=@stgolabs.net header.a=rsa-sha256 header.s=dreamhost header.b=oO+pji7m
Received: by kanga.kvack.org (Postfix)
	id F327D6B052B; Tue, 20 Oct 2026 12:59:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0ADA6B052D; Tue, 20 Oct 2026 12:59:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E21E16B052E; Tue, 20 Oct 2026 12:59:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C6CF56B052B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 12:59:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2DC571201C4
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:59:25 +0000 (UTC)
X-FDA: 85343615490.06.132C28C
Received: from silver.cherry.relay.mailchannels.net (silver.cherry.relay.mailchannels.net [23.83.223.166])
	by imf03.hostedemail.com (Postfix) with ESMTP id AEF5D20008
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:59:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=oO+pji7m;
	spf=softfail (imf03.hostedemail.com: 23.83.223.166 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792515563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lsWi/+vV7HXNVefv/HtjTalVTQdcLmOCgb3JgZq0tdU=;
	b=2ovmKXwxX50BIZ7B2X/ZiVZt9Dc2eELsAV/e6bKXIG+NHO54o/dNkxPfSK7D1U7eGDC385
	aG4mPDPqL6iHIeiUTUGIJolIaG3G5ch0QPYJchJBx7utttP9lMSeWVHtIra/as935mk5qa
	LCfCx7jf5OgYTa3VdPrKo/og0h4rkEU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792515563;
	b=ZGjaXzgsboaxPQklbFU3WdljebPJw8cD+nW8amSbhaCdeQmC5AgoO+wqhVhGXNS2PwNnZJ
	SRCSzqKi4JHjGcznIBxSnHI/KfqGc7x25pv9v2jXZPfxlKQtz0EJpPTQa2fkTjiApgRQLF
	2kkSgGh4iGIEewVZfMVsPNFoZI4bncU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=oO+pji7m;
	spf=softfail (imf03.hostedemail.com: 23.83.223.166 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net;
	dmarc=none
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 5D4144E1526;
	Tue, 20 Oct 2026 16:59:21 +0000 (UTC)
Received: from pdx1-sub0-mail-a252.dreamhost.com (trex-green-4.trex.outbound.svc.cluster.local [100.96.14.12])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 0784D4E2152;
	Tue, 20 Oct 2026 16:59:21 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Illegal-White: 046881b50e36c100_1792515561217_47232638
X-MC-Loop-Signature: 1792515561217:39543921
X-MC-Ingress-Time: 1792515561217
Received: from pdx1-sub0-mail-a252.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.96.14.12 (trex/8.0.2);
	Tue, 20 Oct 2026 16:59:21 +0000
Received: from offworld (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a252.dreamhost.com (Postfix) with ESMTPSA id 4j8JY362KGz102x;
	Tue, 20 Oct 2026 09:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1792515560;
	bh=lsWi/+vV7HXNVefv/HtjTalVTQdcLmOCgb3JgZq0tdU=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=oO+pji7mYjxFCtP5HeJroc1ODXuNr+hSmiBedjFzv+CkBkdC4rXtomtMA8pYA411L
	 Y4KYhZI9YuLsMR5JuKet/LVeKpDI1e/mvhnASaxXJlGNUtZEuCf6N9RyuJTAqhVNMy
	 svK6XA9lxXnHHQif44dKKTJpn3keotg0Fadrttv3Aen9PhLg5P7iDGeHkgh26V6+ra
	 bhATCmru40mhEIAg6PEOmw7J/5D9pdob2Xt+ncEmh/lLcAwV/v/o0yE0GqHRLSGAwc
	 clt4tfkkZtfmBLje5J4Z13wNA+k+uoq4a+VZxlqkCzEGZmHA7grLgZ2lLJ6jmI+gDF
	 cMg++eo1SGvIg==
Date: Tue, 20 Oct 2026 09:59:16 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com, hannes@cmpxchg.org, david@kernel.org,
	mhocko@kernel.org, ljs@kernel.org, roman.gushchin@linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: reclaim every zone in per-node proactive
 reclaim
Message-ID: <20261020165916.pf4gxd2rulrqmdso@offworld>
References: <20261019185002.3428594-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20261019185002.3428594-1-gourry@gourry.net>
User-Agent: NeoMutt/20220429
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AEF5D20008
X-Stat-Signature: hwxn345izcph5yib66qrdy7cbbbj1axq
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792515562-739961
X-HE-Meta: U2FsdGVkX19H2IBlWjGC/6qHLjUwLkJFBPHdvhf/dKgGGLwEJG+0uKTggiCbrGdp18yO1iY4cK2vhYH1Bozsft9SAig29rOBK7JI9TvQNkP6LWont9EcYwJ0znzo3OY17WFb2ySKFy7ezYC4MnjgAEd5gcQvLNDL5RJVtgp0JF5iPCOAbF6e37MZYwQC/MEc4QW3p7bKhYBtWI3/Pxzyz7fC83hsLL/FBxKe2vsqrmIAO9LFvk6ae/2oL4FrO4vfjBDLmR1ZK77AlBm9eznVLKNL5T1H+HXzHY1MCw5xSinxKU8vFcts8M/tRzkOMSKF6MQi/RBzKDudqDLiJ9iXE+Jelubw+4Lzk1w3x3DlwKgE6txos8Y7ccjw8T6O5XqzuQQhn9SpVzLNk+q4dtkOONkWpGA2m6g7+4pjxB5PeTAm+mWWYexkNrARDXHz+nn4M01O9Msz4IYGwrIml0fps867nXXubvmEYhJytRjrnhqawtIYYcD5rvvIqTwzCw4IIIVBg9tg3lbGQlD+ZXsc6ad/0QuiaDad2Nv54TC2FYDDiMlFrcRzU32az7t1YS5rHP+xx0TKykN1xdcunOzUhkBjHMsVMj9UTUFXGEchvmMCKg5JJmIFyD/dLXg9pAkRPY9NOH+ywaPMbC8iqf/CKVKHIs5OnrSJUCwqwS6UZ+AiwoCvraWn1Re7Q9+EIZcIWN2pz0qTkeLPxnmxSMJFzDVd/hEetAEMKdJDBC5rqtNBvlT8YSmNjxuUTf2MWeXoEaukWBaprAcpjxuQUOpt2qicNQCDXDxqFKxSvarZomydcdoZhrj34WyFJZNEYudOfbKZymcsIOH+Ek1gx0AgEUFFY7LXY8Ph6EeYgdjyNIXMA3oQvvE7LVsX6ZdIfH1aXUe47HhCc8wcseHZRLzB8xbPsR3reuT46DvMh2tTWewWcILi1vDSQUn2HoMMhQ1sms/L+BwghsJ2jBmQI+u
 1Cg5Qmkj
 YcTUmFbwqP1cHG9kfd478nbhXDcUQT3o96Z6/91Jh6+6ZYCBU/WmJ8UuZ1tG3vVghxSQm9mE7L34n/dfud5F/LeRDrQmY0mV2jSV1YWYKXFnReadOl/pycqpmmKm2/obgIRPU6l1i8bLIMgzvdRo+LQD9VfVy817lOeXwuneX8H3ELPuD4Zpgcy6DI7DpVUpAXF3gT8tYuZgAe0iY4vLZI0kczNLNcB8f89Likkj+F9bJAJC/IpsbZiQwIYa/dkEi/d9BwATlq6JCNMiR04kFOi+BOKTpryda9Mo07X6a83/6QIKggtpz562bsKvflfthAUBF+NXrywc3hyzltElC4nP4nhCUP10H8mOL9Tzl7PrJ2P65s5YSB54KHv8QbsytlQAPOrXZGIvgymqHX8CMQiH/vjcMW24trSVX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 19 Oct 2026, Gregory Price (Meta) wrote:

>user_proactive_reclaim() limits per-node reclaim to
>gfp_zone(GFP_KERNEL), which is ZONE_NORMAL. Proactive reclaim serves no
>allocation, but that limit makes shrink_node() skip every ZONE_MOVABLE
>folio, so writing to /sys/devices/system/node/nodeN/reclaim never
>reclaims a node's movable memory. A movable-only node, such as dax/kmem
>or hotplugged memory onlined movable, reclaims nothing and fails with
>-EAGAIN.
>
>To reproduce, fill a movable-only node with clean page cache and write
>200M to its nodeN/reclaim: the write fails with -EAGAIN and the page
>cache stays. The same write to a ZONE_NORMAL node frees 200MB.
>
>Scan every zone, as memory.reclaim does.
>
>Fixes: b980077899ea4 ("mm: introduce per-node proactive reclaim interface")
>Cc: stable@vger.kernel.org
>Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

This makes sense - sorry for the trouble but at least glad to see
people using this interface.

Acked-by: Davidlohr Bueso <dave@stgolabs.net>

>---
> mm/vmscan.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/mm/vmscan.c b/mm/vmscan.c
>index e82ba737c028d..90f7a7bf4e426 100644
>--- a/mm/vmscan.c
>+++ b/mm/vmscan.c
>@@ -8180,7 +8180,7 @@ int user_proactive_reclaim(char *buf,
> 		} else {
> 			struct scan_control sc = {
> 				.gfp_mask = current_gfp_context(gfp_mask),
>-				.reclaim_idx = gfp_zone(gfp_mask),
>+				.reclaim_idx = MAX_NR_ZONES - 1,
> 				.proactive_swappiness = swappiness == -1 ? NULL : &swappiness,
> 				.priority = DEF_PRIORITY,
> 				.may_writepage = 1,
>-- 
>2.53.0-Meta
>

