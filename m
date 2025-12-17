Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC172D66BBB
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 22:27:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 320066B0005; Wed, 17 Dec 2025 17:27:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CD4B6B0089; Wed, 17 Dec 2025 17:27:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D9F16B008A; Wed, 17 Dec 2025 17:27:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0E5A96B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:27:23 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B154B13539B
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:27:22 +0000 (UTC)
X-FDA: 84230400324.21.8A6AB7C
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id 85D6D1C0019
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:27:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=iHIsQu0+;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766010440; a=rsa-sha256;
	cv=none;
	b=kL4mUJm0v22EiIvkCXe9t1WGqnuOdNdqvsmv3oOBN7OysFgMNKUG2J3pVH5PIfQpz31G2l
	TbLSKmTsTVwgQpdO4UBK2ioCvCu/vwkd8kxlxcGlYekVkOI1qemu13wVsQmv772nvGXV6h
	hEZlbDVngO3XfwETt9beV1ECRwL5nY0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=iHIsQu0+;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766010440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cTCBZvRcuAym/h1xBJiWm3RRmoCS7sWaqtZ8qFwz41Y=;
	b=MwlusS8+VVW9Se5WHzta3W+rL/TtXZjodWG+5zaWJ2aQuE15fskMcbOvtcHR9Wv9I/nD75
	lFPYneMHdN4qyp8Gmv6tDTjfHlSdVELZjaiIZdYtvPilSGonUXf3R1QO5P57yWUIeFMyI7
	37wwyao0iQsOvjgM11GYyR5VYori2RI=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8bb6a27d3edso1454585a.3
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766010439; x=1766615239; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cTCBZvRcuAym/h1xBJiWm3RRmoCS7sWaqtZ8qFwz41Y=;
        b=iHIsQu0+aZfCjicN8nXJAW8rqYIDzbqNzjL7rXVWUHHXcfby6O+G2Qm7pqbedtdiYK
         b3GWvCWKIX6PpeAm7ZmL+OUFTZ8ssMDQyA5gcET28YyJJkmFJsdr//bJkFGtr1S4wnJq
         gW3KqsL0SGYRqfWoCYqnUNACU5tEp0S721/ZUsDzuSh26Ita+ontLY7/5NrUT/uLrnWn
         zRvSHcNT0nv+mXbA2aAbHsbvBHlktHLcpc7Osx/L6CyZ2DSOXVg/LuJvYMXiGiRkra0V
         dVi0SaRIs3Oyx59Wbmb0X8tpLDjIpwioxOSpddX9OlcJdehPmIQcgDfRuRzkTP2U6ful
         5u0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766010439; x=1766615239;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cTCBZvRcuAym/h1xBJiWm3RRmoCS7sWaqtZ8qFwz41Y=;
        b=A4mmnDbCsyOpVCyabdJ9svc1dfW+FhMgBrfeqMmScD0Avv3FvD2OMaMkUCBGdZ+o7q
         R5nD4HL0yodWjYM8oLR3zi0s967k5KBQfHGdY4wwFvqVvk1XGixt1jCX1o6U8hwnT1cZ
         oycnpbrlH/5GjMdLTeRbk1pEJGKG5XD8DpxoBofAxkd7m94N7SLdzSfUh9VVQV1k+FJd
         niragIVdyLflS7/FeAEeyfczPjNdGjeCZy5z4Qj2YIfq8tgqaZ5QO5P8RKrJ4Bfpy7YJ
         D6oP2YYRHz/qjsvu3NUlur2oobw93jPRpX3tNmIMgg+vLpIbFbogpJ7gedb4jmfN74fN
         Ge0w==
X-Forwarded-Encrypted: i=1; AJvYcCW7t3xvEeUSW9H9aFSenf/YtSuzWYRNb3QDQbSXQHCeQ/82IiYSuTciVlTzb6qXr8K0trNHMkZd/g==@kvack.org
X-Gm-Message-State: AOJu0YyF7cM4DJMhPLeaNPMMVEzi+zqWxQO3VudBTthbOxh8kM0NKODB
	Z6peBaYA1L5LqtxO3tlun3LM3XPsZKnDYuZ/d36+Z10Q8fEbqHINADnMPU8oxEWuao0=
X-Gm-Gg: AY/fxX4kYJI2XCaRtinihUVP1/WbZZbV8K6et7OfnrvxVSA+ZSm9hIvYQ/n5ILZFs2y
	2Kwch49r3rDv6pkDNu034ix3ZnSM4yZOWidQtX78ku9ziRUqE7Z9/wQTJYJjKMZjWt4Bu/lyv1r
	8lwwKOF1W5H/Wd39RgEsAn9tSbW7p+3EjTcTv3Ku6UMnH3rOxdr4nGB5RzQGxDMP2Vfezvd56rH
	SklL4uyonnbRcqf/OMu//6/m+nt42BceBDU2q6YeYPklMrgIH0q0YAIuby5kKcMdrsdJDZc01YE
	6dumcl6e+cu4aFgj0oXVaGScFkIiKa4DZblYnFvBqT9Kq5ovTS1qbejknBROxK516iwNVLjZpZo
	+iPCXZXTk42P2VgLL8lRcAB1Nn8Dt6FB1SoLdFg7frmc2muAKXUhfEMNRCj8oNjhJ9iJJCmpPwv
	Rws/cqZ4TsWg==
X-Google-Smtp-Source: AGHT+IG+jLH00z7Nhn8Cp9IOuvagD88qekrzPMEFtka9A/qLSzJh8fiL2TmBI1HmFYajwZIa0SS4zg==
X-Received: by 2002:a05:620a:4412:b0:8b2:e6b1:a9a6 with SMTP id af79cd13be357-8bb399dc35emr2782868585a.17.1766010439394;
        Wed, 17 Dec 2025 14:27:19 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8beeba2cd7csm37904385a.29.2025.12.17.14.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 14:27:18 -0800 (PST)
Date: Wed, 17 Dec 2025 17:27:17 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 17/28] mm: thp: prevent memory cgroup release in
 folio_split_queue_lock{_irqsave}()
Message-ID: <aUMuRfPVxkfccdmp@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <4cb81ea06298a3b41873b7086bfc68f64b2ba8be.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cb81ea06298a3b41873b7086bfc68f64b2ba8be.1765956025.git.zhengqi.arch@bytedance.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 85D6D1C0019
X-Rspamd-Server: rspam10
X-Stat-Signature: xtsxydqqnbqq9316wx6tex9oexikz8km
X-HE-Tag: 1766010440-990245
X-HE-Meta: U2FsdGVkX18ST19lImjY8OLAzKz2QC4r12i/V1N57RrXGi2UpYXE5COb8z+aY4WAsITviK8Di/rN6Yn8Ni5XXkP0ObT210aZvhmKXDJnF+0GI5P5iMf5JdrdRZhatpCyT064ZzEl85AEMqMA/LyufRyHkeMHLS2OuCiCiPvm/u9oqTVaNzft7NN2H/IOvsXz6G/18eqqCIcMf2O7CYw0DqMi+CX/U7Bft45UBatVnRoh0pQEBDR8UP2WdJ3gU2GzYjzS+jc6hRLc3+1DgglkxBPOdhUVr1qFqqxJjlgQVrMt9O352fTMNxXkQ5FgJpxXefRby16UBh5eQEEcEIMgL2d4dLQyHWN0d1FOa7WTqOuO34IabrOAPxbo0phqpW0ND4pf9Eg/eRMew3OPV7zljpi8W0ohMnTUIS5Xs7wCZl4ohIWREST+nLegjmX+1/CiNa3+vZKNadPiQbWPuAwYfkUVqp9DeRhOqL/GZKM3oqZUpEhCBgZiNqwVE5b9EoTbSfGLPp50nSSXgc9RAL9doW4mpDHgOx136FZTn9mGaCIggGtu1JVvTcfoR8kg/NrPsmtoGZAixy3yLmXS90VAptgRowChzbZSb4WS7n5HXFNR8PnTskEUpL4THR4xGXZIN//N9tB/t36vX5AEa2UdkF8TAF7gUb8PU+dJo/7XrOCq0v5rQuktp8AMr4cU20mXiOf5mzkcQSQFbB7gpf+zqtQJPK6qzzkNljpGVISE1c9dXLnTLgzL7AQmVIavJLqZ85pdV9hRjIeH7EnRVerps3hRwpZnIQdBg1W85w79QRKjpV0ROrsP80u7ariZi2xLh1Sh7DPc3yUgNzapjzB/mzVxJLi3CjcX7yLY90wbpcWKBFpuh8gUe2AwN+jXHs+c1Ep91vShHIPi0VjzL9BpGN0M0ewKkPhCzyC24y1GIxu3aaStVfBbn2paSpA+6/mCbddFYC9vbNo5iryXJZ7
 nXnkWJYX
 dtdj3bdXe9EtkHO+Gl5l32SDWrSDvEHUlpUEHk4jyD1rynnyj4W8WR+2bNXR26Q1NqAkIhRqUpKfi3g2ZTzIeL52LI1yAize+vGoM7Ewr1oobcw7a2vPSwb/BhB6ORy7mmlsBZ7lVfZ5n3OUcXbf4dEVs72e6KCgDLnBKiKwYBF81J186an3hM7qkjfAOyK8DK3hkTvKQgijt9y4iGST0nu2NWuaP//9CKDLeAM8FTKgsUhZeJGRcGwz52dlKolu5kVDkGeiT8c0cIba150mOPS9gVQ680Y871utnL+VvloCk2XZhnwamhLvKNxiRBCMiCv8P0X4d64vOdHRcaQWxX1OeZbM//kYDdcX/hvRRqVhunSioihSVsJYRXl0VjGfUcRu32IysiGPYMAPfoJpF7VEdtOfg7H7WQwnmkKKfI2USk/W522vwO1GYS0XQlHxBMbwNmRZpnSd7JXzTS/lVFStH2YaCRYT08hzVIGmRzN0Qa11jGsmyZXPJRTDsbz5odSfuIHIdBNzTpg0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:41PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding memory
> cgroup. To ensure safety, it will only be appropriate to hold the rcu read
> lock or acquire a reference to the memory cgroup returned by
> folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard against
> the release of the memory cgroup in folio_split_queue_lock{_irqsave}().
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  mm/huge_memory.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 12b46215b30c1..b9e6855ec0b6a 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1154,13 +1154,25 @@ split_queue_lock_irqsave(int nid, struct mem_cgroup *memcg, unsigned long *flags
>  
>  static struct deferred_split *folio_split_queue_lock(struct folio *folio)
>  {
> -	return split_queue_lock(folio_nid(folio), folio_memcg(folio));
> +	struct deferred_split *queue;
> +
> +	rcu_read_lock();
> +	queue = split_queue_lock(folio_nid(folio), folio_memcg(folio));
> +	rcu_read_unlock();

Ah, the memcg destruction path is acquiring the split queue lock for
reparenting. Once you have it locked, it's safe to drop the rcu lock.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

