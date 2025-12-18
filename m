Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAFBED6ACFB
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 13:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CC196B0088; Thu, 18 Dec 2025 08:01:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 579D36B0089; Thu, 18 Dec 2025 08:01:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45B5E6B008A; Thu, 18 Dec 2025 08:01:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 344FB6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:01:00 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C20D9140155
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:00:59 +0000 (UTC)
X-FDA: 84232601838.17.0E26505
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7D6CAA0016
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:00:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=kPdNxkYF;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766062857; a=rsa-sha256;
	cv=none;
	b=54n9RI7rInKy3sZkt4sIXFMVhhlQEKZ+NNdoH+jgCWEAzagKSU1Vi3z+I+F3sXwwCWG1xQ
	FKdDQfetlyTBg3AIW5dfiCvjp50J6lbaf1toktho8l9EVpQbbs3aLXDm5SRwcu+Sav/LWZ
	v144HGxNMsG7qF5uAXEb1lgMv7wsBbc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=kPdNxkYF;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766062857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eyZ4aAJQTuFKnA4DRtBfOSsfoPJif64nSNk4YyPQ9Ro=;
	b=Kc1dfxSi2e9F73MiPoOEwWv74PMaHufrFTzGlBB+4qfGosDMwrGYMQGZOX6baxmBG3ttoK
	X+ei/vCqe7Qk73ZImjaecWL+IS5lDB87BI/dTjllwsSK1lsEiGhUx7sFrjV2TplIVzki+Q
	GUmPxigTBKmTIzRQ3sOI2g7+eCyyu2w=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8b21fc25ae1so59686485a.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 05:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766062856; x=1766667656; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eyZ4aAJQTuFKnA4DRtBfOSsfoPJif64nSNk4YyPQ9Ro=;
        b=kPdNxkYF7vZwS0Ng0HTnFhw9caEQJUwNA/0OOdqPMd7M6JEiHCfK+Ajuy1uT4REn+n
         hu4iAxLOz/UG5RGU2/DcaGxd2WKQp8yyCUHEeVopYk0TLYOcnT2wzroo+tBSJO9Fz/il
         epiO1iqJBn9KHS1tPLkglY+fNw+hhMgsEwNuU9xUoLPX4m1U5qwu7mUVEc9sB6f/o0rX
         6KhQyWcSxwUKJoiJRUXtICXrRi4kvtQReHfucGs7m9Nuva/D7D+/Skj9PwVTM+ImrsTj
         a2WK2/OZVy9tDrMgt6PLa16McuMaRxF4F4bVtVBytYaGcIFS3ap/t3qEoTP5k6BBntUy
         ekmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766062856; x=1766667656;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eyZ4aAJQTuFKnA4DRtBfOSsfoPJif64nSNk4YyPQ9Ro=;
        b=t/A3StJzsGBLsssV0ZD0GHcwehKvPpQA0w8dONs3OuaLRfwZlob0TssLukJOn5BfkK
         yySt47rIZxalRUp6sGe5i5j2UKNGD5AzhnsrKMsiE9NUilJOYstKcuH6Rd6Hv2rZzem9
         LnHyWjbDzUsfsu7C1lh7+Zq+5LGZ2MXF5FQZjZ4MNNaxJiq/Mk8JBbPdPj6EGaWF2A40
         ETUlSvcHWzC8hPaly1/QGq3fztai311KOJWFqDWI26q4z3aQY7eSQhgwLZK/C5ke6FkD
         VkUFWpms9iHycBnbc0fcalncBmxKZMSrAks2vM32Bh99GU78FLzOXICbxmPszNZBKPXF
         agwQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNmBKUS/DqfE3MYyHGrivv8GSzXE5WLZSnSKpSAn2/AFym8RbL2Gf71JvfT8QnaoBe8h8Je8kCbg==@kvack.org
X-Gm-Message-State: AOJu0Yx0iHzhtdUK14rDl3mTB50BqVdx3e28zpYjz9QkP607sXWGtyat
	ybaEPS/bX2wgHXvPcZG/DtN25fWGsabUbjSpVkTKu+7lAkBMNLiOpIhBooF/l29xcrA=
X-Gm-Gg: AY/fxX5zgd2cGBje8OyhcrdD7u/u8rVJCAhxdQq0BdPdBUEC8w/NgqceK7Z50YDrFER
	p0NRgkQrJn7eA70iuwMsHbbrAq7HjZSW84UXtCCjHtLQjj5YYBpBv3leJeP1zkK0dwQHJa/xlZk
	DGVuF4RCBsd9VdTxF4i7MF9g6Fdl2ylmXOrPyoMCuHoEn14snq8VLpbfdIbAN1lXLaJIGd+25V7
	gad28Zg8dHH7x1j3mZLWO5vsmz11KXmbIpzdnlu2PVKKBrIJK44g56uZ9YLdYFa4fvH5yAbz0p7
	v8ymT16aSt07O/LKffwJUpkVsJqqPc86K5OG5q1MCGmnz8eY/JLU/jrBCjBlgTMPhc/zW7KEP5c
	Je9MyUgOUwcHiAGQxPqHB4kweQPeS7TzhcKnm05Iq2bPZUwwSuH2m3CHcYhTXoU+subnJOcaabQ
	/g2ImB1JZ3aNh7PBwgVG8n
X-Google-Smtp-Source: AGHT+IG6q+Bxs2SFIn60tS6Ai7tNXLIL/tEA/j0R5OH5fPvCoMnlyzZLehM9/wUFoyArtHFrlTTFZA==
X-Received: by 2002:a05:620a:4010:b0:8a2:ef8:348c with SMTP id af79cd13be357-8bb399d9747mr2950051085a.2.1766062851153;
        Thu, 18 Dec 2025 05:00:51 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88c6089eda7sm15995056d6.34.2025.12.18.05.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 05:00:50 -0800 (PST)
Date: Thu, 18 Dec 2025 08:00:46 -0500
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
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 23/28] mm: memcontrol: prepare for reparenting LRU
 pages for lruvec lock
Message-ID: <aUP6_o9WqPv8Y7d-@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <6d643ea41dd89134eb3c7af96f5bfb3531da7aa7.1765956026.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d643ea41dd89134eb3c7af96f5bfb3531da7aa7.1765956026.git.zhengqi.arch@bytedance.com>
X-Rspamd-Queue-Id: 7D6CAA0016
X-Stat-Signature: qh5kumoc8q365dmgruwtb4kkdxwzs5ay
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766062857-561065
X-HE-Meta: U2FsdGVkX18xQPZmds86zbKK1sYDxwCjx/o/Tk/s4R9WP5e2Pip1TvOXCYSdHw/swnAumnQd66ah41aqimFof7L7yyYqlg+DslJpCzynArvsZKjMibFwK56/GnfzosQEIKu61gnG68I2w6RavYrf1jtcC9JmHH++5s+uezVjM/NbDKk8Em9cUYGcwCdv8I7AxMP9o5oxwAdpwNffjliKhr5ZaBz5MjKCcIAiAsactcUeu+zmCsApPoIEvJn6YD6O6RbM+fGfTDUqCbU36eH9MkNKE6/gDpCiTfaJWdjJYzFxCdowWsq3j0IDsfyyXIvkdowtuQaKGy9hmqL8lF45HE1QKaYgKsi6hhGLFt07qnifQTezeQRIEku/tZstNPH1vBBr/XsPguoTSOvzN/k/wilFkAjpBZnX2YDSbNlRXfgjnZZhxpseL5wdnVvKbdlTI52bjZmeJ54T9NglV5x1Qauk6Kp+jB95yq2GFjKXeTKAViohnO6V6pCsrNZf06dV2f4RCpRSt6RSzxlGKHfaJAnUfeb094CAM6Ia0CM9r9ISo11Tiy6eg8oInNemy1LCGeXKNek5i9UeOhpGciQ47HG8X0jihYf5T+jVbi8OX3HJ1UZZWXadGeq1pJMHn0dzRYJNVILDYcS/yTRAd2Kt5LALORa7ljb/3fSvf/FgfSzgoSYufwjNSIhcyHSeFJDxUE7+NXUXprsW6Wb5/PMuPwvxhQFC/7zRQnjTT+LhULCYkovDAnGLPyK6a82kaCmyD4O6CjxwcMbc7YFul8/GYhYfvcblrpQbd+qe2xAlLzgexLyqw3eUob0K6kvm/HiAit2M6QSkrojAkoJnVqM9dM20drZPnJJJ5HxsRrhMvE1+ptLsf+C2mafwLbgIrUQgH4Ew/+hOsaMUzSBN3LrX2gWGZxY5EGO0XOyXmXamGjGVyh/0BSthRgL/R1rnD+s06pj1IxdhnkjfUZdoo+7
 p3k2gG5e
 g3o0sHVZhehMjKCPrZn9+PZ77lPsjhygfpHei9QO397MlNYqa1UcDuQnfNgLSj9E5U0+dR/hgv41UCTiQb/55LxSJ1z9LGjHgnicC5RlOb5zgKEwheZk5nHeWM2smMlPnpWrmHtWnG1t7SVJl7Bgnv1eqaZDVkaw9bzBpHbkbYkTqIRc0sQn4bXH7ebA1lyYV4xFb4QxXSMEvPVxVM16IIgrXbjCA2DsSRHCXHnZ3FNhnwQNOKFsEeOkvXGQPHYGw5JKj62NeHHOjySU/johrKMUwcZ/oy2BQgQCHMLBCiDiT/8cpeHXOP6Xd1BrvReveJ594EmScnTWKS5JASniqmKr1POyZttn8BNaopLp0QzbaiajwLQrHOdF8Dnh21F9Se7JqtAlcZHMDDWlVzVhpMFLXaIRrmiFF3bG8OmCyOVXXfKpVq80eAPG5wR7LIhrWrHMByo+CZg/D5KY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:47PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> The following diagram illustrates how to ensure the safety of the folio
> lruvec lock when LRU folios undergo reparenting.
> 
> In the folio_lruvec_lock(folio) function:
> ```
>     rcu_read_lock();
> retry:
>     lruvec = folio_lruvec(folio);
>     /* There is a possibility of folio reparenting at this point. */
>     spin_lock(&lruvec->lru_lock);
>     if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
>         /*
>          * The wrong lruvec lock was acquired, and a retry is required.
>          * This is because the folio resides on the parent memcg lruvec
>          * list.
>          */
>         spin_unlock(&lruvec->lru_lock);
>         goto retry;
>     }
> 
>     /* Reaching here indicates that folio_memcg() is stable. */
> ```
> 
> In the memcg_reparent_objcgs(memcg) function:
> ```
>     spin_lock(&lruvec->lru_lock);
>     spin_lock(&lruvec_parent->lru_lock);
>     /* Transfer folios from the lruvec list to the parent's. */
>     spin_unlock(&lruvec_parent->lru_lock);
>     spin_unlock(&lruvec->lru_lock);
> ```
> 
> After acquiring the lruvec lock, it is necessary to verify whether
> the folio has been reparented. If reparenting has occurred, the new
> lruvec lock must be reacquired. During the LRU folio reparenting
> process, the lruvec lock will also be acquired (this will be
> implemented in a subsequent patch). Therefore, folio_memcg() remains
> unchanged while the lruvec lock is held.
> 
> Given that lruvec_memcg(lruvec) is always equal to folio_memcg(folio)
> after the lruvec lock is acquired, the lruvec_memcg_debug() check is
> redundant. Hence, it is removed.
> 
> This patch serves as a preparation for the reparenting of LRU folios.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  include/linux/memcontrol.h | 26 ++++++++-----------
>  mm/compaction.c            | 29 ++++++++++++++++-----
>  mm/memcontrol.c            | 53 +++++++++++++++++++-------------------
>  3 files changed, 61 insertions(+), 47 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 69c4bcfb3c3cd..85265b28c5d18 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -740,7 +740,11 @@ static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
>   * folio_lruvec - return lruvec for isolating/putting an LRU folio
>   * @folio: Pointer to the folio.
>   *
> - * This function relies on folio->mem_cgroup being stable.
> + * The user should hold an rcu read lock to protect lruvec associated with
> + * the folio from being released. But it does not prevent binding stability
> + * between the folio and the returned lruvec from being changed to its parent
> + * or ancestor (e.g. like folio_lruvec_lock() does that holds LRU lock to
> + * prevent the change).

Can you please make this separate paragraphs to highlight the two
distinct modes of access? Something like this:

Call with rcu_read_lock() held to ensure the lifetime of the returned
lruvec. Note that this alone will NOT guarantee the stability of the
folio->lruvec association; the folio can be reparented to an ancestor
if this races with cgroup deletion.

Use folio_lruvec_lock() to ensure both lifetime and stability of the
binding. Once a lruvec is locked, folio_lruvec() can be called on
other folios, and their binding is stable if the returned lruvec
matches the one the caller has locked. Useful for lock batching.

Everything else looks good to me.

Thanks for putting so much effort into making these patches clean,
well-documented, and the series so easy to review!

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

