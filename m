Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6A6D1125863
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 18:06:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CD186B0005; Wed, 11 Mar 2026 14:06:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 050D06B0089; Wed, 11 Mar 2026 14:06:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E74B96B008A; Wed, 11 Mar 2026 14:06:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D47956B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:06:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 84026B8399
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 18:06:26 +0000 (UTC)
X-FDA: 84534561972.30.90FF78A
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 40A6F8001C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 18:06:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=pIBtlAMv;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773252384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bczgafP3myIIT3/uXjN5TcydziqRd7nkpIhTtM1x3Qc=;
	b=KQS/UYCEoiClwqNcVwjQzt/Xx5SrPNIdkW0+szAjTi3JoJdNtt+7snBAs9YhwXj4zjJz5Z
	DBuqX97268q40aEE3+wnilDIuf6fiL6p9gh9/5H2ZzZ7Ur3ZGJKOYrogdY2+HydNe1qxBA
	lxLXlk9J/rR1TtfMg1eTtuvrCB/XPmU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773252384; a=rsa-sha256;
	cv=none;
	b=t3sxEti+Tm/yhI21A4r3Niyv+lYaJe0ATcWxajCe77qoW2f/3reKX1gNqkMd3HLdWuKLtm
	lpIckxQH+NCbjp4RWHmHNw3gvYZd8/UIdepm1mMdN4YiW3TKcd0o7KckbnO/9yS1RZjJb0
	ZlWjxKAvlCOJmfbZMVN7ViUy4JsXpVk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=pIBtlAMv;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8cb40149037so11568385a.2
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773252383; x=1773857183; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bczgafP3myIIT3/uXjN5TcydziqRd7nkpIhTtM1x3Qc=;
        b=pIBtlAMvAHS8gztSaQjV0uB0wAbGmbA34y6JiT/ONOJUfVti7QjJR5nBKo74PAhEHD
         mCRPlPix6CcLeFAnCrBzn7OlNyqB6JxVM8yAtNtzhHxXsdMm2t3X4nYOPz8IieGomooD
         xW2keFw6NAG46iPMF9HxRtV4Wl1wMggrelshAf2/nltFg2tQrVrsA7ywApBYiJ4pwBU6
         AzIgj9Q9doajTTidgiTnVJ+9x7675gW4BMHXbtK+NO7tumm19EFcf1QvzTbKirOMAxpt
         tTc1EFve2uyetn3GrQ1IWvOGsVOwAsbR8/rexDwYvwt9f+Gjl8Z3OE5Qc3p4Zg4MYHfP
         AdPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773252383; x=1773857183;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bczgafP3myIIT3/uXjN5TcydziqRd7nkpIhTtM1x3Qc=;
        b=hyeDe76Jl1jOFk716ooGAKrUzDxdknub/9XT0Esx8ghJn263gBSHvCoxY/0ZHKGZ71
         9yr8iG9faZUE9hbFn7PBCV/32kD4H3IKyfcJxpdCkR6gYGtTfcUgH0Q4BJygD/GVyHGD
         3/R+WCn5O8/4Yz3XmBVmGBrXy/pWKrtTFaaeUWPQMGt+X+rIZq5CYlCLyIOVyZdYtzwD
         K7gD+EzQuudP8xINVDTxG/OETKMqH6s2gDAVkH4dT+mkzyi2CCC6LsH00Qh1lUT2Iw2Z
         pwjUQy36GBw3TI0AinDY3fJADqocc6zo8UV8/4mtg7NYtoSyGmbjVq4KTQF6qAl4mZm+
         iFFg==
X-Forwarded-Encrypted: i=1; AJvYcCU6BudRsLoLAw5q6OhdscWn3JAsLp1mnxmPLXtEocjbS1AF2TGEzv+SashrR8GxG6VC8f7Lb/u0ZQ==@kvack.org
X-Gm-Message-State: AOJu0YytYYQhJMTtbKRpG98eftAPTaDiPUefMv3QkEzfH2oLaprGelxJ
	kJXfFAsqdQYIGFngmL+mXqZR5o1wa3lNoze17xT7AILiZDCsPR6tmYWAoq7eWOFMotM=
X-Gm-Gg: ATEYQzyXsVbUSg2YTYkqM6U7YfDO6kiaG2PxkIC2psyXEBBI7S71ZW4nkNaGWQ7dd7k
	uqT6O+da5Tsr3KWuRdwNSCZVjuRZJdgsuE23SPNVYMIA7MBsMbNnJX4KAM/Z/11VdkJNnD7E9zN
	rNAAEOwSgLDRlL2KeISHVrF8DgfzNUGmlQ5xTD741om+oPPX+093V2oY1RUgZy9/4PPaygxo/dR
	jzTmMmO20RDCJyC1l0xFZfuWrMEMXuMm5zjPgMmwnPJIQq5hvvcuJ8Q1qlfFZyqBBDzJFwMX1vZ
	chkI/dUJDo6RBb74q8JVLd66nMfCr2elURAutUkxjaEYKQDNBBmXBK1JQaLd8u4T+A70lZSg6mT
	D2DL5fNMzHCr4taJAnRh1ZWbN/3XTqcdkXCROe70ZhpEXFjFZYHdEFdzHO3kAWtZl/AqRrgjf3X
	mN6Vtt3fU0QQbDuG3FSHzshA==
X-Received: by 2002:a05:620a:4053:b0:8c7:1118:c514 with SMTP id af79cd13be357-8cda19b1a5bmr446088985a.17.1773252383193;
        Wed, 11 Mar 2026 11:06:23 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cda21540f5sm172182185a.45.2026.03.11.11.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 11:06:22 -0700 (PDT)
Date: Wed, 11 Mar 2026 14:06:18 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
	akpm@linux-foundation.org, mhocko@suse.com, vbabka@suse.cz,
	apopple@nvidia.com, axelrasmussen@google.com, byungchul@sk.com,
	cgroups@vger.kernel.org, david@kernel.org, eperezma@redhat.com,
	gourry@gourry.net, jasowang@redhat.com, joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com,
	rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
	rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	surenb@google.com, virtualization@lists.linux.dev,
	weixugc@google.com, xuanzhuo@linux.alibaba.com,
	ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
Message-ID: <abGvGjqke_3gYe6I@cmpxchg.org>
References: <20260308192438.1363382-1-usama.arif@linux.dev>
 <c64681a1-2069-421c-9e62-bb63e4ce261a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c64681a1-2069-421c-9e62-bb63e4ce261a@linux.dev>
X-Rspam-User: 
X-Stat-Signature: 4un9gexx86xqu1bg9cgnafrb1x53eg4a
X-Rspamd-Queue-Id: 40A6F8001C
X-Rspamd-Server: rspam03
X-HE-Tag: 1773252384-850281
X-HE-Meta: U2FsdGVkX1/QT5A91jcLE2MsDb5ybRMtJTjfiQWPjAONM+7PQPZYbq8FAlvONqLW3g6ssHLp/wi0+4G84gFF+wlzIKcFCI5wyWQSToLW1rhGXatZgmYy0XZgkc5yB98YxTMoGph8Zo1F0xGsuX75KkkowAL0rVnklA1/s+q4Qzy3OfhmrNcLSP6vbbVqq9oRWunZmrTVHg+XW9LKoqs8nEcKBl4CvVdnNZ5ISWgw+dNK2tA8YtmKGbdsmpdKi3LXZIU+jl8RN7JANoByIqXme7Gxoi3v9D/UNowPMkBC3Lsc0XdYuvpkb8Faukv4rbyX+cB4FMqCPBMpa0tPPTdEuU5UjVKx2IRBYud2FgmWUIrV1D+2R1UiNUSud9inHy1EdEbBlIZ6nsYftrJhlCwJlO0MP22QS5dvVpT03Tg537U5mliwcrqDKOmqDUqM/86RrSq7noSNebwxgnNE1VqXtfOm6Q4bSbUuuCedk+amlxNaGSUaUL1xnnOJJqLX37eoWalDVUV4ZU2a9F2BlnCTjMMU0/d6IkKd/bjkysfkD67/LadORtK6rqfWWAWdONCL+Ch/p0D9/NJxZuAVH2YUTkXvT1AB07zCUlm+FEQXct20F/T0wwiS7nUtm/E+43LDk6N5AH/+65J4M5IP03P+Tg59fIXHcrE5SreWSQnv2gPhv17zff4qyhvv0UFJzqtWpeeAYik54OfnpzXfDsUDg7dISapk+ARyIqQ57mJN8AcdqSHZ/r/fYJKo1CMNHkLhXzBGVVW2ynqaKZD59mb3B5o3mhGbUO6gFXvJALGRjJE6gqgWMvpNg6qVgS3+dbk5/90mTw02UwNs/CfCfZP4781mbVrmt8t5QqQSt8z2O7YTAXF4XDeB6FifP+QQ6hWw7s4qA/+kCDtGt604S5glp6bpt7gXIBpgcrsOU6cH8zRCel2EyRSoQOv3/af3cGGvjvvUQ4zmUEMVtFKPfFA
 EiIYSCl2
 hyxeJaZsG9DaRKx82U0VzrDnT7MyZ5FBIxSUNlPeH+uNB4+QDUVFso21gEO7qSsiPcCBYJVGImptJVBZjE2yg1CGidepskXt4tLNH5XL+EmUvMdkcqaDN/afH1cPC1wCMadieT11izdN5TarQc7sO1qN5VAcJaNwvqjZgWX45SxOL33041/NtfelSojDZDIi9oBDyFFe6/ICyelvlXmznxnkkkvQbcGG4VwjrMBx9EBcNXYziSptowaFNc4NG/QT1vQsnFgGQZNHrItYz1zAcMZtglp316FKOHgSzoTofoJZDpbiOgKlUVLj5zTomHDPEkdQk2mNA08rySX+Eo7ykoca+A0cn+p6DuMf7SnosxPV9ScaitTx6jd69NpWWYVZQydO22XtTz9DSPBW3zqOK64tWOaaRT3MzzSWvwXJOf2CvOkRwVKEEOztLwXVs8WaoiavuV/Ss9B48607gGpMv9i/GZKkjOc8PRJ2Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 08, 2026 at 08:30:47PM -0700, JP Kobryn (Meta) wrote:
> On 3/8/26 12:24 PM, Usama Arif wrote:
> > On Fri,  6 Mar 2026 20:55:20 -0800 "JP Kobryn (Meta)" <jp.kobryn@linux.dev> wrote:
> [...]
> >> +static void mpol_count_numa_alloc(struct mempolicy *pol, int intended_nid,
> >> +				  struct page *page, unsigned int order)
> >> +{
> >> +	int actual_nid = page_to_nid(page);
> >> +	long nr_pages = 1L << order;
> >> +	enum node_stat_item hit_idx;
> >> +	struct mem_cgroup *memcg;
> >> +	struct lruvec *lruvec;
> >> +	bool is_hit;
> >> +
> >> +	if (!root_mem_cgroup || mem_cgroup_disabled())
> >> +		return;
> > 
> > Hello JP!
> > 
> > The stats are exposed via /proc/vmstat and are guarded by CONFIG_NUMA, not
> > CONFIG_MEMCG. Early returning overhere would make it inaccuate. Does
> > it make sense to use mod_node_page_state if memcg is not available,
> > so that these global counters work regardless of cgroup configuration.
> >
> 
> Good call. I can instead do:
> 
> if (!mem_cgroup_disabled() && root_mem_cgroup) {
> 	struct mem_cgroup *memcg;
> 	struct lruvec *lruvec;
> 	/* use lruvec for updating stats */
> } else {
> 	/* use node for updating stats */
> }
> 
> This should also take care of the bot warning on mem_cgroup_from_task()
> not being available.

mem_cgroup_lruvec() and mod_lruvec_state() already do the right thing
for !CONFIG_MEMCG. Add a dummy for mem_cgroup_from_task() and you can
do a single, shared sequence for both configs.

