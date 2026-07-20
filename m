Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51207C44512
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 02:33:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28EC36B008C; Sun, 19 Jul 2026 22:33:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23F436B0092; Sun, 19 Jul 2026 22:33:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 107E06B0093; Sun, 19 Jul 2026 22:33:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D943F6B008C
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 22:33:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 026C3A0568
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:33:29 +0000 (UTC)
X-FDA: 85007583780.09.00F1CF2
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4DCE040004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:33:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dadKjXLz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784514808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xFNn/gqLdYPzgx2CqKZ3opCnuLFj7YA6xkcjVFnjCJU=;
	b=v5mh1kYbCusm5Y4o7tJFrE5kDBXUvwXdiCTTSR0muds3MR2ToyYX4+MVZbPw+QpHpeWfw9
	uskoZiw44bX5ooEab++K6XJtl3Ag/B/Kj5D8Fxx9noW6r4qhho0cxTUQzY2rgMVLRgc+rn
	R7YeynkV4qONU8ivmWuzlNgbxy1HKEQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dadKjXLz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784514808;
	b=BBIUwsa9Yy7eIbpGEBllVCsHmR4/HFE6dL6dbVWO02QGe7xk8toXMD7XtbDpsaWfB4eALd
	rMOdIJfBTuDiUN86a5Q+yH12raRjkkpr5ApIdjx/ifcXdN+n3aHwyiyE2/nHe9tt2Ybg7d
	mhh/3402rn0ZqA6qtDpyTW33RfpfpTs=
Message-ID: <19c17e7d-9331-4578-9557-2db5ee42ac69@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784514806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xFNn/gqLdYPzgx2CqKZ3opCnuLFj7YA6xkcjVFnjCJU=;
	b=dadKjXLz9ARZYgeTWO1Ey0wEdxocrEuhGm+HWa+PB3/86qMLmwpXiVfJNhcn8ONlMyhtwn
	5ziqaFyV7w4D3VLu6lPvsV1i2pU31I7mCB2I1qoRcjjhNS8r81VRBT1ExNHjradc3x7yRy
	qjauOLXsh8OzFN0y7+prejGzEXhnyFA=
Date: Mon, 20 Jul 2026 10:32:24 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/4] mm: vmscan: propagate real error code from
 per-node proactive reclaim
To: Ridong Chen <ridong.chen@linux.dev>, akpm@linux-foundation.org
Cc: hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org,
 shakeel.butt@linux.dev, ljs@kernel.org, kasong@tencent.com,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hezhongkun.hzk@bytedance.com, muchun.song@linux.dev,
 dave@stgolabs.net, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20260718095251.82937-1-ridong.chen@linux.dev>
 <20260718095251.82937-3-ridong.chen@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260718095251.82937-3-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: pkmhppen75ibmi6dzkru35am3p78o498
X-Rspamd-Queue-Id: 4DCE040004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784514808-471635
X-HE-Meta: U2FsdGVkX1+4XC06ezhjvvs36ppR7rVa/3/edzeoUv6oYcQd3bSB9BbEuJ5BRq4c9C7NkYLFRMcIKRMgw8k5fmSZAmLiBETtzMHCdzgzq1yRwWCf0PUMFhRrg2TbYrTZzHxENbH0eYxtrhgCSyDDqS1tdrV4bYiPfYqJpWa1QbJXF/F+8vJRJZOOGh/ifl/Ir9MBQ3XJq+qTRJldvvs+aW81uKfaKJR5/GNwnkJxBaNkvmGWy3bBTEfcyiM+FrNPm059IDGHOWqaVAcz2A8PL4D++CVF1HiTY2mrOqoR28cdt9f0IBEYY0g7H/PgceuYv/JYv31X2TwvN7IpnsBZLFQ3ivyGw54F2AVhyWnvdJZJ+FfARiLzGx1ReWlpYtk0HKCnAQaRS4IUvAJvsxqbaWWJA1Zj04ui+ZJc31QJ+fIlPsRZ68esrI7qT2sa+z4QTK0ndqcr/4VxbJ6ioPxyOtXQvsDC8aaYM1kRpXJtlGSpnUVwMB/qRjtxRg/qsYksrYMI6ffSDIVBKhIFU/k7DZKi+mhcpp45s9kYd8/IjimtDU0x0GhD5aDOTT8gbS8CwWS0fmqOgLI4QKASdY1LvWh2O9cPEQk908LrJrfltnLrAcOKY+b1w22Vfdi+ZTc64/htg/qfNCFInpBKkfj7T+vIACun5iz8zIbdQl+l0PJu6blWq07KdU2t82mCsdZ+OzQ7acsdymMXuP7a5UJ/M8uqonysjum7LcLOXqvaw7kgwtdgJA0K/UTRWRUQDju537iMYe4KCJGV4zYLDbynqgfFgcuo/GmKpv0IQln8L5XCmeF6p3bkyaCnX8c13XiwOYc+JZrQjCCwY5eI0qvLv2XBQC+FRSiT6pe4acSl7TettC16/mjCdWmLh3jwWgXhesULNZMEUPqNY5HPDBn1FGZT2rTHpglTYJ+dmFQ+PtiHZ7MJ2P7p4NFDZOzBiE6mnXiad1Q/o8QTwX3iPsE
 fo8dAom+
 VfTUO5dYyVBu5sf2Z3e5owXee2rXHzq8i92LUGVwfVcuJp5MwHc/VoKVfZN3GvAEWrc88fQtTiRlK550W/+oltwr0qIuxOkm6I1YCtcY4tLgZIL1DgV0QPWb77shVhdgA7u0kfOsy3SwdE0yF4w/LZqECEaRVq9e5SL4zujlewCKOnOYssw7Y1/M3vkzkhwrwDEZ0nSqczzM9Jh0uK25t9r3uJfzK9A2T9pMW1z+A2gvebNXF0Dy/qNgHarJjOPeNRdd7joLQQ0X2KByn/DJkhoL+kmTLxvZm1MJt7BcDTNj+WZ3AYPoOcsgVVOvyJd6SCBFp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/18/26 5:52 PM, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> It has been observed that per-node proactive reclaim always returns
> -EAGAIN when any error occurs. As discussed in the mailing list [1],
> the interface should distinguish between cases where no reclaimable
> memory is left and where another entity is concurrently using the
> same interface. Propagate the real error code, consistent with how
> memcg proactive reclaim handles errors.
> 
> [1] https://lore.kernel.org/all/20250717235604.2atyx2aobwowpge3@offworld/T/#m3514718be82a31b05726a49da9b61fbfc69a589e
> 
> Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>   mm/vmscan.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d6b383d96a0c..cfe4556c96d7 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -8017,7 +8017,7 @@ static ssize_t reclaim_store(struct device *dev,
>   	int ret, nid = dev->id;
>   
>   	ret = user_proactive_reclaim((char *)buf, NULL, NODE_DATA(nid));
> -	return ret ? -EAGAIN : count;
> +	return ret ? ret : count;
>   }
>   
>   static DEVICE_ATTR_WO(reclaim);

Nice catch!

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi



