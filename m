Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E17CBCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 18:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45272280009; Wed, 17 Sep 2025 14:31:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403E3280002; Wed, 17 Sep 2025 14:31:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3190D280009; Wed, 17 Sep 2025 14:31:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 219CA280002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:31:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A5EE516066D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:31:18 +0000 (UTC)
X-FDA: 83899584636.06.7CBF368
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 111A61A000C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:31:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KcTTOeFX;
	spf=pass (imf19.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758133877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mevL9in9k0o64LzTDwhQ1McAAnZa+W8W/qEwfHXnsVo=;
	b=qNqrugJSUwbxInSX8guTvOVmO2Iz/vnEiP0xgnC1+3pHQgUlLzlPvKnIzulBezAjJVAGhs
	Tmyu4nY/0/OYgI73R6w+3d3BSPoyzLBDSGZ2IdVF7IxgxsDMkvWH8Z8rjL8L8kiddd63Aq
	6uBkt5/aIg3L4KooQLnzxa3WdkJmr8g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KcTTOeFX;
	spf=pass (imf19.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758133877; a=rsa-sha256;
	cv=none;
	b=iblwi6JAvC1bklhziSmnu1w77badvsrTtEQmgxdSnuxsef32woYtYXrwL3W/ugi/WQEnuE
	SVKxiK/VYYC3sb1897cjcf6dq/vcST8KarMxE4ysHGdbrinG+VQ2hY+duqFVc9fXBhi9RP
	1+bzdVGd3Id3Z9+8AKROz4yiN52Umyg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D901601E9;
	Wed, 17 Sep 2025 18:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61E1C4CEE7;
	Wed, 17 Sep 2025 18:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758133876;
	bh=qc2L6Az/Nqo9MlJoX5qAK3vvs94xYepHejoFP3CW/EQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KcTTOeFXPkJ39QfkZjd1hm+LU1GcwQTEzQRlYvljHLGSvvaSE6LpZD9kBUr5g3flM
	 3X/tSCXRL2zXvypjdD1V/1mrxWnRn87z4HzsOwZXJqCQQtWGEmOW9hATdqPVmS5JZ6
	 i1VTt0G4xQh3KBdIDm5nim6cpH+fhAXccliVaZaQEQGeuUt2O4WfdC9+7/Hoj1Ei0E
	 5wGisV00xMrac9Q/f3OSpzddKDtpLIIRfEa9ZM8B5ibZk5pYBR+39HyX6ZecM9j5Vg
	 UD0n2+fANWqpqOu754kjZMRglvxPp3c2TbqscV8BfSEGs9HNzIxSbU6YbmhIMhtuWY
	 UMXzyZa9gPgBw==
Date: Wed, 17 Sep 2025 08:31:14 -1000
From: Tejun Heo <tj@kernel.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz,
	muchun.song@linux.dev, venkat88@linux.ibm.com
Subject: Re: [PATCH v5] memcg: Don't wait writeback completion when release
 memcg.
Message-ID: <aMr-chVzDBfU7BvF@slm.duckdns.org>
References: <20250917150125.331701-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917150125.331701-1-sunjunchao@bytedance.com>
X-Rspamd-Queue-Id: 111A61A000C
X-Stat-Signature: jbyaqx6jer3ew3qcfffxogrb6fwzkb8s
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758133876-558337
X-HE-Meta: U2FsdGVkX1+ZIoXk1XvXMeoT3ypUZBo1jAaRL4WHbqkJqh5QLG8yUFZDiXAoF/8qdJ1bLC0KXaUQTW4eMOoPEIm69Wythsmu4x8h9UlymVqCNmVidzg1MVp+tiiGPPBK4njpm/0R97C/LIBfzrGGwwajZWpVvD3kUdWcz7JXJ0TJOgZlwpTmQHnG2+/GtGA0YwSS2xPUW8ED65+DMXnrBSUw4NwuaPvc2Y6Zl0gncXInbk9p6zeXCNpcF49HaP99d0cddOQv07SiU3pn1ZL5QGua7IcH3t2LRQZUkMyqaKHU7Rdij2aPc7Z4/JNI+Vd846ubUHwwncA1ZocafvdspkWjjBy2/xSneuW21D5WbGDkoYW8u7Xb3Tq11uegSVTBuMXHaSYfOf1dI7gvHQpT3/bQWsggPzJXyhPY2PvFpv1M5Y8QHeHDItqwh2gIBVWDBo9djpd55+3Bx2U8G6xgNlMgjrMgqgG3s8Y4NePpV3gxSPxiYkWQFLOHcJTUkmmoN9aMt+tFcJpCLgWYGGvTKOxmLjWzpVVDA4TQi9SKhC+Djh/Ic4NZV8a7VxFqDsTgsuQTbnlrPuFpFomOLw8VOCls+V73B/vXD1vR7n7JbyUSbVoYKjvd1Qw5PalZluLpvSYqzzio56ZBScSJjt0rQIzCGS9INK6UxtfFN2VW2WcRRTeAljikdJNC4Jjyn70mpUEMQm2Kd6zdJ8vHrl/VYJP0LRtIroYjyKxQKkepeP+SR8rQbY9iJxOVWTDeO3d9XZsne/DqHZ3P7DhXKeb6e5XhnThpFsU+q1mr9m4gSGQKwIET1dgWkfnYMjPuEqu2PDnQsKe0ifLhAkGsopaX1vFVt7v3JPYyTPcpi6HzbpYqFbKVWKHnDLA1/Dml3eitbbnOCfMxPj6CI7U4ZB9DARIRUDPAmSkN3v+224kQZblD2VnKNsQL+IB4zZDt6hRTjQOUDV08pA9PN4CN7pO
 QS1tyqK6
 yMqfApORcXkq4GQ2LKE5BNSRjJwqs+Z+3+LMCzCNUDrV8gpGxOZmDKER6n9m0veZ8B+bMAS22NcpAf7WxhkzC3DqToHVN4yiW6ahxo9Z092m5HIWIcKep7KPbBws8Q3JQFwFpKrgI2tBJBBHa1tLuCHTdIF6xKSKIBXckzB19RkY0TJIwsSnfCZG06i7vZIBcBf5Ebo+pQGbljN+9ZXYmCRec/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

A couple minor points:

> +struct cgwb_frn_wait {
> +	struct wb_completion done;
> +	struct wait_queue_entry wq_entry;
> +};

Can you add a comment on top of cgwb_frn_wait to explain how it's used and
why?

> @@ -3912,8 +3940,21 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
>  	int __maybe_unused i;
>  
>  #ifdef CONFIG_CGROUP_WRITEBACK
> -	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
> -		wb_wait_for_completion(&memcg->cgwb_frn[i].done);
> +	spin_lock(&memcg_cgwb_frn_waitq.lock);
> +	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
> +		struct cgwb_frn_wait *wait = memcg->cgwb_frn[i].wait;
> +
> +		/*
> +		 * Not necessary to wait for wb completion which might cause task hung,
> +		 * only used to free resources. See memcg_cgwb_waitq_callback_fn().
> +		 */
> +		__add_wait_queue_entry_tail(wait->done.waitq, &wait->wq_entry);
> +		if (atomic_dec_and_test(&wait->done.cnt)) {
> +			list_del(&wait->wq_entry.entry);

__remove_wait_queue()?

Looks good to me otherwise. Can you please cc Andrew Morton and memcg
maintainers on the next post?

Thanks.

-- 
tejun

