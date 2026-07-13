Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE2A2C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 10:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 838156B0005; Mon, 13 Jul 2026 06:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E7386B0088; Mon, 13 Jul 2026 06:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D6B36B0093; Mon, 13 Jul 2026 06:27:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 481256B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:27:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC5131C9759
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:27:09 +0000 (UTC)
X-FDA: 84983375778.04.101DB6C
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id AF1F920003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:27:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t7KmIKiI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783938427;
	b=VYV0idK/2BH1n29q29Xx5YqqcBgb7io52Wvvkbu3hDi5bhC+YH/kul5E3Qu1VUXW1/4bOR
	oX4B7oB3S8ryU59jD9wxKA07J1/1HK4inA6+BIzEMrpFwrQcYkI1EIC13p/TFXDu+Zk98T
	UhYbrCS/ElQ5gnadF6Ch01Hp4Do24og=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t7KmIKiI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783938427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hI0ulS+e7/Y2oO5fBiqc90A7kYsME7pKoySFXxv5Y8o=;
	b=GNjsM9o8ggdU3fKjZ96wiRDIblW1IiqB527orLUYQsoQ2CRKSbx7rMnGkHFYXTwelzYzhs
	OlMbpIibqTCM7rwad1SGJKjvHhADjpGGv+Rq9Nx5KYeq2SnOPPGO9f3qUOtLVc0ni3xWid
	BysxWJxW5eEo1D9oOfC7Iiql+wpCOx4=
Message-ID: <877c39be-d4d6-4d9c-b824-18d9463c62c7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783938425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hI0ulS+e7/Y2oO5fBiqc90A7kYsME7pKoySFXxv5Y8o=;
	b=t7KmIKiIfaH9vl5ApL6tbaX1tiOn/PaCox8ALC8rjDdI01CWo4AmLTP0tK6BQlWieFWasG
	0JO4hkTfq9GOdwbNl5DqBRt225BskLmxXZfbAVmz6vFMi2FQ7hPHhjyRUltdm1FqaK6hPs
	48nvhCZmrCrmd0yqgcc0L3n3D12Qv8w=
Date: Mon, 13 Jul 2026 18:26:58 +0800
MIME-Version: 1.0
Cc: cui.tao@linux.dev, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg-v1: account vmpressure event allocations
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Stanislav Fort <stanislav.fort@aisle.com>
References: <20260713085520.2953121-1-guopeng.zhang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260713085520.2953121-1-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: AF1F920003
X-Rspam-User: 
X-Stat-Signature: pqscak3issp5a8neoe4eww93gr8tjuwd
X-Rspamd-Server: rspam03
X-HE-Tag: 1783938427-400617
X-HE-Meta: U2FsdGVkX18j+FCq6L04phIBoNKvyEDpokd+4aE41ArrFbiFPPOEZsttLyqR9H/IwEWP1IjVPoSRIyCk56z8Kr3jinNNqh8HAuVCobDpimh4ImQUzj/tCzzXrRyJ0VdhCkcSBfjKkK5xFEmdhG8E6g0x5vRMu7sPQ2vuj29KCXXsZF0jm6SPdpjOVtiA67cDTjBF9QH4Wj6lvTYRntD0KgjnRjMqir9hnulj360cTK20xaT4NNoE96gqcWdRtO62OJkSKRFhnCZVGT8LEBXnqfK6DObKzO/Xma87+dyLrDcw0DQbD0YAXda6RyQveU9Tvy8LVtRzGyQEL5ZB92HNJlYKHcnVe6hAb4CQFYHaIBXMCyWqQagpz3CWBJS+yRN8jpwbvG2rPEtu/wcAB9zvWQnWXEAvSZMHxrBY/Bc0WfyaE7dMOTBQyLpoY3UoT5p93DX5CvHxI+qVU9QhTjgdmnbb7jtgmVEOLGnaa2Gpz7cL/bUxxxMERz1zeKmvk315Vll3HzBMy9yvOu3nS7d2mGmhAxaJW3GKXcb/SdvixTmnbTrAHcpiXzWCRzLBen6lSHZ4GEcFA9zZJNSZvVYsEOzB8oRv8RdAprdoPjmBtp0MZhW1CieBa08tsiS+LnTf+GZYeEWN6lqua6lX32wvz16p8LP4lY7cqfIJDlr2ULsDoKZBoFeUoDMQ4qYMC6TxbFGher2245bTx9EUZhUbPzgg0iRbYECn6z/pmor48AI6BwkH+ERNz4rQpxtqZOSM+C6hcfGmE1tTlu8r6+02UZWsOs3QnsB2A1oNMwM/QgrQ6yg+cDygO1l3NW29qtw6jw13wxLDJXu7cjWqUpXBC77O29t9VYEGRo8t+y1NJzy0YQqC7krBl3oMifb3Lq2Th8TirT9TxbX78e73RxR4m4vek7vV3w3NVd4PsgaNyc5HOxzJNt9aMYE7B5y2w6+5qECt1g/reTWU42gmxpc
 Vsa0vKkT
 8dAtaN0tK55B/C0ZmsNykQCZDcHYGLVEKgSXkGApnBKFry8lfTIdl0iyHdhk0bMc4CbbvME05a7swLvKbx1U1wLEzoYeCbzhVCgj34heIlSdersKqPy+/7W5Js06jtl858tJ5GW8ph+hCODBWI2m431o9cV1oYR/7FWHsYyffI8kP8IPbsNtnjDM1nGaE7T3xmUcZxni/f13+bRjxmkMn4DpLbGGLW0sQH9GCecwZPCO2d9Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/13 16:55, Guopeng Zhang 写道:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> Commit 72797d218b43 ("mm/memcg: v1: account event registrations and drop
> world-writable cgroup.event_control") accounted cgroup v1 event
> registration allocations with GFP_KERNEL_ACCOUNT, but missed struct
> vmpressure_event.
> 
> Use GFP_KERNEL_ACCOUNT for this allocation as well.
> 
> Fixes: 72797d218b43 ("mm/memcg: v1: account event registrations and drop world-writable cgroup.event_control")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>  mm/memcontrol-v1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index e8b6e1560278..f8424ec3734b 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -1721,7 +1721,7 @@ int vmpressure_register_event(struct mem_cgroup *memcg,
>  		mode = ret;
>  	}
>  
> -	ev = kzalloc_obj(*ev);
> +	ev = kzalloc_obj(*ev, GFP_KERNEL_ACCOUNT);
>  	if (!ev) {
>  		ret = -ENOMEM;
>  		goto out;
Acked-by: Tao Cui <cuitao@kylinos.cn>


