Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47722EE0AF1
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 19:59:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 236246B008A; Sat,  7 Feb 2026 14:59:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20E326B0092; Sat,  7 Feb 2026 14:59:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11A086B0093; Sat,  7 Feb 2026 14:59:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0172A6B008A
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 14:59:57 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8FD5DC1CED
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 19:59:57 +0000 (UTC)
X-FDA: 84418726434.30.E3E8CDE
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 99E5F120006
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 19:59:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hSiLbOID;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770494395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6OXJ4VqhuGT/CfXgMjy4IV1o4Ev+iXuopy/eJZiNHX4=;
	b=JXrDI01nU5Ar758OJehgpfo/Rq+6XEuho+iQ0GKvlRhYRMsng2gDbV1KbrV0VJgmt7q65X
	iWDMcn5xGKQ24YPPCCBG5hGl4v5vTft+2F+ewhEnkqahiAWjDlu49wwfpK5+8MV6dgzxUK
	rcChiB4/kjA0v4B45fZ2mTjzoqWvL5I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770494395; a=rsa-sha256;
	cv=none;
	b=zqdDGDvOhR5uEW0QeAs3hWwQd3S82eQ6LiCQZouY0T05ETHzw4vEIgB79SwjWeFayjAUQ1
	vQi7nF8xBVao+pzPga80DlMfZO+c7RksTDBUTajrdA19XZWGYnfToR6klFWFGGtf4Y1ubC
	LdrUlX/zYa9rgqqkB/9bhYHBuf02unQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hSiLbOID;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47edd6111b4so42526785e9.1
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 11:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770494394; x=1771099194; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6OXJ4VqhuGT/CfXgMjy4IV1o4Ev+iXuopy/eJZiNHX4=;
        b=hSiLbOIDIIBVGb18pdcta1lTvvjL4sqOj8Enw6e3xo7oAyqUhFDhUzvG/ceyO72tlO
         vOp4yK32SZ/2jFZiKz8cvbuGiF4mcXr9SKmtEUUhnkIvDIneWMjshoqWkts1IfNalzJe
         r8A8auaDuTF6Ag9HTSVxi0UEXqDkOJYGmLytibfmId0KP0EV7zIf2yU+j9AWqvuQiOGb
         Mrorl/07rnHKNrGDvWdYD+IjXpzWmbcLtPjUf4FnWfy1KDJepTFTnssFZxETjgy0fbGH
         2G+jUctcR40f3+YeCtqYkLQzJYKof6EyMjo4EkmdRY1GtlClenq+iCPWH7N0vnX+MjwT
         XjhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770494394; x=1771099194;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6OXJ4VqhuGT/CfXgMjy4IV1o4Ev+iXuopy/eJZiNHX4=;
        b=AVh3fp7LIMdUjpNZ7Wb54WOLhNvxcuwIr4ZgnOgVuVVrg7tvyXDLzQjNT3r+Y+sYMK
         PMD3ERsBnKSuSalKAJ7zHobK1C6F6BR7xw4ai0DYKOQA0zhdkqqULjNzfUQVFju7MFJd
         DaOtSc0faszH8XGdGdzrmKRMqnysVGaaArZJuOVu9UkmWyUqy+3iAXHZZWSGXjvusoMa
         Ow1UDCuHSaSR0Od+RwCVu5Cz70zDijmfIRkz4FjzEVycJVb/tyPwa/U049Gff4Ra5XWG
         CbtX8V6rTVVZtlpVOlIOQYFeE36DRwKjZXu9XgiXNjZRlREdk/N4OUlVwDP5RUVz3PNz
         Rxpw==
X-Gm-Message-State: AOJu0YzUNsYBeSis9HkyB8swTL9+PM/OQBrx4rWskdQGss8Y5pcY6VnR
	E9D4lEKpfhHYi+MloskKeTNBUFqJLjVF9U9mmC6nBmNFiljsdlsBckHN
X-Gm-Gg: AZuq6aIOl+v/hfCxnX2OeRAAKT6X6R3krBW4YtgDwyB/94obpqpqWRHdQG4WzmL6hgp
	3BO80S1BfJlwn3CzzSc37mfycK5Oyl0/2YNT3a5aRMMYpro7VwDpD1VabzY1JLTZfYxYor1yZum
	dWuWhSorJQVkClqrGF3kv0754MrkErgZzIhvrcVX+P5c/8N64p3xdWAH8aChvYz3faNAHsAtjUT
	WSoanXjlTx7byLh7e85tizwqLJrQZegbP9UC4BgS05m8FAyHanrV9DxD1k0GYg73CkirKJVjgcr
	bQTkMDFgBgIXLmGL3itN8vPS4/aCYCJf6PpcQFNlZeNy/UVI1/+czn7iqrCLm2eG2OouVUvaaOv
	gsamuUbwCVh5PlbXNA+4MezToxyWkKmPR68fd8nX500cB64X9fP5485bRvKnBi1xuHZgrigXAZE
	kDReQLO3G0D4dJ7wKccSh2IoL61n6YXXOhryttbzsxqh+tTlA436dfxvi/j6yhKY2rpJ0bhDcNR
	b6tmBFCYwDQwK0=
X-Received: by 2002:a05:600c:4fc8:b0:46f:c55a:5a8d with SMTP id 5b1f17b1804b1-483201dc396mr100885895e9.4.1770494393810;
        Sat, 07 Feb 2026 11:59:53 -0800 (PST)
Received: from ?IPV6:2a02:6b6f:e752:9400:18cf:c773:ee86:c436? ([2a02:6b6f:e752:9400:18cf:c773:ee86:c436])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48320719b8fsm143031285e9.9.2026.02.07.11.59.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Feb 2026 11:59:52 -0800 (PST)
Message-ID: <c921485b-bccc-40b6-b2c7-5163739de9d9@gmail.com>
Date: Sat, 7 Feb 2026 19:59:51 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 30/31] mm: memcontrol: eliminate the problem of dying
 memory cgroup for LRU folios
Content-Language: en-GB
To: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
 <9e332cc8436b6092dd6ef9c2d5f69072bb38eaf6.1770279888.git.zhengqi.arch@bytedance.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <9e332cc8436b6092dd6ef9c2d5f69072bb38eaf6.1770279888.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 99E5F120006
X-Stat-Signature: xmn4xfy51cstjbrh8feddpt9mz3iy8e3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770494395-23950
X-HE-Meta: U2FsdGVkX19tMy/9UD8zlpmG8kDEif415tihgN51lPPDmUY+S/eXDx3gMOIxWNrRAs1AS48UJRZ4mXJ3G1gEaX7shPa5Wu1wE37C4YJBkfQfwBaT4ZILasZsjCEVQ9PVgAVI/bKrGqbOmKHf2V39S4QXPZvgNJdGqG0fpWY0r9HxJRd9X79OUTS7690aEHXhjwbg2cP97u3KRxAeOuyfqLAmQQ4WVo3UGrMCN1SGlMLBvY3DVEvA0c56ZlxTOzfFIBejtZBqGzgGBo+q+8z5nn3jZGHjJoyp/PInpOOCP9GHg/w4eJJMLe9yU/x3MTVdfSSw//BtnnxNeKm+UHICtSxDeXji/rj4rQIuuy++7aygeN81mRWr4aIPn0RXyPH4u1Ko4+mex2kxOboWz7oEf6RdCb0bfp3mm4IP1Ziq9tDpwmLe1yaFE0w8pPiZSe5ASAmcFaIXlHjE29xnP+qLXy7qLxaz2mMWvY/OQp7ilQUYKTpuYv1TvODwPp7smHmxKQScpOK0CuMvgiHgwR0stpULdyX9sqWoOX6IJm9la3uIvr+tfCBAmonGz5dad2frNn8cxrY14NwNxa9T75eQkVRd81Ud+eqPVvJV5Kyg046li1XVkyYAnm7wDgj4/JraANJxJKe5n2YTysw9GYzkNsu3RU/EgPfsiC00uaSj7hkNS9ur2TrdCY+hp2mdWCxLp4qL4xwAyj9fIZNC6RGymCkMYRcO8fYlMGc+D/0heZAUCjx0IYnRC9impfY8+6uazsBIjhF2NX+CLnZYWlWYlalwR70TZoNFRi9kAVVUwZE8qJu3E6yreRXS+AS++iFJzXeNPbwQtJnIuK88b13idty9LmJ9SVM8SR4MVY53mh7ib4K6CNegsulj1q6eACd71viFPx9hcc48HRUkSUfw9sPvH9naTczqetbTl24mZFzueEMDGQSM1ISciiDISc1a+vIl4l2Z2au62z70U6v
 JHds+sPN
 VFeOAzT1/74rIORewskv2IUHVCjSeH0C7jS4Rce8m+HaPdGuggx8kUyrdBzdV5X8VwBf19v9VNAtZzvzeB/itmGEp2SDJwOZePjTVepV9sz9tFbXDIywBAJUA0KqzFonvRTbJBFddSf74Nw0Owx2lqpLOwfRotD2crgZ1RUgr72BVwyZL61+oSN0zasZUIwCDFK9bLJl9ZhIWS/y2cW8ub40oho63aZezjTweIRwLE4T39rEO1P07sXdoUhpNQtbhM/dZ6xHseZdNrQHPfoLaQKsqygzz4sxU7rfl/7fbuFCwb1lF9LXFxzpQl1n5+XlP0yz4kPXArERiUsHQGV97UCiePXwPR69EzktcHSlQFxIU2Aw8SYJJvVAe1fmc+pseFFeAaUjJzlnyl7r7DW6+xKUfMLWGfZYS4x8vfbSWxsIFsA0aTm4NJonriXBgXnUhY1hYIT5k/G8zH1rJzwV0qJkKGSh39K9EMlrkAMhhzutCa3+H1MVQSaoW2dm9wpYijOc3R8ionTF1dUqSS0DPxha7vygVHdQqSyCE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e7d4e4ff411b6..0e0efaa511d3d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -247,11 +247,25 @@ static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgr
>  
>  static inline void reparent_locks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>  {
> +	int nid, nest = 0;
> +
>  	spin_lock_irq(&objcg_lock);
> +	for_each_node(nid) {
> +		spin_lock_nested(&mem_cgroup_lruvec(memcg,
> +				 NODE_DATA(nid))->lru_lock, nest++);
> +		spin_lock_nested(&mem_cgroup_lruvec(parent,
> +				 NODE_DATA(nid))->lru_lock, nest++);
> +	}
>  }
>  

mWould this break lockdep on more than 4 NUMA nodes as MAX_LOCKDEP_SUBCLASSES = 8 and
2 locks are being acquired per node.

>  static inline void reparent_unlocks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>  {
> +	int nid;
> +
> +	for_each_node(nid) {
> +		spin_unlock(&mem_cgroup_lruvec(parent, NODE_DATA(nid))->lru_lock);
> +		spin_unlock(&mem_cgroup_lruvec(memcg, NODE_DATA(nid))->lru_lock);
> +	}
>  	spin_unlock_irq(&objcg_lock);
>  }

