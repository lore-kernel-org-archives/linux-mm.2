Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00F01C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 15:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0A516B06E4; Fri, 14 Aug 2026 11:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9B5A6B06E5; Fri, 14 Aug 2026 11:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAA3D6B06E6; Fri, 14 Aug 2026 11:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A55286B06E4
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:49:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 46FE3160187
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:49:30 +0000 (UTC)
X-FDA: 85100309700.22.95FEF58
Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	by imf24.hostedemail.com (Postfix) with ESMTP id 73D7C180008
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:49:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786722568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FQjBX9+Ci1rWGKNyOuvQWcWs3yIxwDdBlR3IHagsrWw=;
	b=sisuPDNZ+GEvtPZ53BAiSs0tVRK/zUUnypwCTzXj1Gk7Cz+gIVZTTdtNVFUSQJ6MaiKM0U
	m9Y0BpbI2tWOflQjFwMyCcbf+eL7mMVF3BfWVt97lboULvpFHtuGhaymdb6rFaCho7sF1D
	6yVOJzo6ZIEOHHO92Ie9W4EL+m6UQpE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786722568;
	b=jAKIetdfOKlvDr5ZxG1UUiEc0NXKn19f/acg1eAncOL7UnI2YBiB3FotQDDXW85FMOyX4j
	Bl0aDKH/Dc8lfFKUg/XFMSlDFYEnWMVpjXO5UgsdRx3xneeK9zpNcXNPGoNzbU9DBEReT3
	qeLxocA35scSRV+E0tyekfekzpA+2Ck=
Received: from unknown (HELO lgemrelse6q.lge.com) (156.147.1.121)
	by 156.147.23.52 with ESMTP; 15 Aug 2026 00:49:20 +0900
X-Original-SENDERIP: 156.147.1.121
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.121 with ESMTP; 15 Aug 2026 00:49:20 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sat, 15 Aug 2026 00:49:20 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	baoquan.he@linux.dev, baohua@kernel.org, chengming.zhou@linux.dev,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	riel@surriel.com, gourry@gourry.net, haowenchao22@gmail.com,
	corbet@lwn.net, kernel-team@meta.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 02/11] mm, swap: support zswap and zeroswap as vswap
 backends
Message-ID: <an85AJ8auvXQ3+nk@yjaykim-PowerEdge-T330>
References: <20260806184254.3790858-1-nphamcs@gmail.com>
 <20260806184254.3790858-3-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806184254.3790858-3-nphamcs@gmail.com>
X-Stat-Signature: khrdyib1fi7ctpp38tdn39igarj6pu3n
X-Rspamd-Queue-Id: 73D7C180008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786722565-798972
X-HE-Meta: U2FsdGVkX18NXppsh4z9d3KS3aYXmzrY1NnsW2nj9teyE5DZCR6NX7jfz+pwbEp1TN0oCL2gZcqFOlUCOwHguIHQ0soaS7yyGY3sblSQOLlI46js+W+7fyspwyIcdH/ptdcPX4VADI1Xig7Gq5sjQjbPvBkKOnpIe5ndmX9E3Lokd37OHwWR6/eWs9khFF3D2IuS7voB6fk+OjhnBM+vyeiXPgLjhI9f1pMdprj/rW2gRLNuEba8kE9OOyi7aX/GsHa3GIKIGwZmgDUisPpUO7vWjC1afqNqn8r9uJPDPgiNBq75B04yTnY1gAdhC6LzT/BIZJmvPnDbcVy1BCfzJ56IpY14+elKvOODW4Qy0NFPgF1KvamsMWDr6ADNFE2iVgfQ1s32wVhWW8/v/H7Hsq/EAC7jLb2DtjqJRzkIHkqjy+jTur93QXwcZArvbzOAWeraAQdInTVs8426kxvWR8VMLLznPB9nUXrrqxxSdWBCuL4OS0K/hki414+r47jtI6d2BuYta13tyeZLk+lv+HcohAksYCCz+J2U0piTuKqi9fpdwqCxexL7m7hz0EpF1jbsjSLxb4NQSXcufzQTVwCrySzZSg6cbLSQ+seuJdeD2zpm7shh4ECzM3BOVAEzHFnWzPvST77OknVvh7v64FOwUsf3OR1e4CNH9B0+sj2LKbL9AH1U0d0G+4RL+Z6L51e3EIKzxRIoTTeX+Mp02hAhVnjIt/RiHbxxlsxdmV3DEgJ8V7Gtsp7It8MbN4XqYz40/DKFiZ01qMmqeMNs22F5sLasx4tSzLHaMm+EO6bsdW2AMbRxA19AF4XnuQrNb1Xq1tlXY3SyMXl/bTqPr3X8Q6rHYYEZuV1XZoGNvXimqdVryFsltrRupOeggDxTeE8/Sss2C44wHXUqCzVWjsuuOwidliOawigKfz/Uvg7dfE8Tt6S8TiZBwXKcD6s18IxU4h7l+Oi3olHc7zB
 wbCqk7Nt
 odHbWwQjWiYooMcMuQuvB40j1C6ThdW4fivbO2YIMZAqpn7swzd6JuXa1WFJ3YgkqLO07d2bKNccU8t4T6t1TRCBIiy3QUZ84RkW2WR1qDnk4ZMxR1KG7pT3w8d4uSl/PzpLs+0DypwvHbjKdbrhdi7PgtnDoT2CYw3NrdJFfm/JWffKZot61gGv04A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 11:42:45AM -0700, Nhat Pham wrote:
 

> @@ -537,7 +562,12 @@ swap_cluster_populate(struct swap_info_struct *si,
>  	 * Only cluster isolation from the allocator does table allocation.
>  	 * Swap allocator uses percpu clusters and holds the local lock.
>  	 */
> -	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
> +#ifdef CONFIG_VSWAP
> +	if (swap_is_vswap(si))
> +		lockdep_assert_held(&this_cpu_ptr(&percpu_vswap_cluster)->lock);
> +#endif
> +	if (!swap_is_vswap(si))
Hello Nhat

Does vswap actually come in at populate time?
For free clusters (dynamic ci), 
isn't the cluster freed immediately rather than going through this path?

If it is right, then just validation seems good enough. (assure vswap does not come in)

Thanks
Youngjun

