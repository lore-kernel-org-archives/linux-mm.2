Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1398CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 17:05:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EF7A6B0099; Mon, 25 May 2026 13:05:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C6CF6B009B; Mon, 25 May 2026 13:05:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DD066B009D; Mon, 25 May 2026 13:05:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F17776B0099
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:05:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8F3768C116
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:05:07 +0000 (UTC)
X-FDA: 84806567454.28.EFE528B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 045EA4000E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:05:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HFaDl+ss;
	spf=pass (imf01.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779728706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z5IOJhY5s4BFHeiUSPpmIVhS2IhxEwNZmsrIdtBR4Hk=;
	b=tIsp9WJ/6MIMAkzMUiNZOCeNr4FjQ7LU9FIfJozGNvT/qpAvg0ycjS3LjuBqufGrAZL/0f
	TW29SI7+ZSp7TLLV5rioxU6lBb7UHpVg3x8YC6EdcJhFjZlLwHQxT8YhA8tr6vnuKDJ9EJ
	uMgHRPGlwL+EOkF3w70eVA38BE925To=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HFaDl+ss;
	spf=pass (imf01.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779728706; a=rsa-sha256;
	cv=none;
	b=W8Bn5Otv0vnKiyv+SSu9gZUbJ7ZtttkUflDBWz5A1ofjvldOonMmeWKXR8cCMsMYoYPHhv
	ZHA+IiSKoh6iytRhXhELuTQhC6HFnq6AoCz+S/TeAdqpT3B84df6H/H+NCi3xHg25Fah2J
	nVVTYAkqTmhbVcjKbW1o2KsRyIPvSkY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B8216008A;
	Mon, 25 May 2026 17:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C80A1F000E9;
	Mon, 25 May 2026 17:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779728705;
	bh=z5IOJhY5s4BFHeiUSPpmIVhS2IhxEwNZmsrIdtBR4Hk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HFaDl+sscIJhvLTUeOqNibUngqgyF1Xx3moBnJ9k+a+eRXJhK0W0nogcjmSdMkXB/
	 TqTBD1L/E0Cw725+bjsRF+Fd1980xVK5KutNv/caIad7CUZCHpduamW/kByoiRlM2W
	 ogqUTAyl+tQHaD+bmPk0jTIJYMeBELqp9A58JHaxS++9pKwkkUJW6fIcFbEVhGWAdI
	 psdTbrTt3qlkQXW5X+viMG5tpFLcwXil4MrD5azDubEDmB5aPs2FEAl6gYdpabTnCr
	 BghyOnwcKkRBCJBRg5PFvgKJqgaIlE/yWhtqUFnQ52tLnwYD+naKQB76rzIcsEzeW0
	 3nMiVlIh8qidQ==
Date: Mon, 25 May 2026 19:04:58 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb_vmemmap: fix incorrect vmemmap restore in
 rollback
Message-ID: <ahSBOqyYHU6GptxO@localhost.localdomain>
References: <20260525025213.2229628-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525025213.2229628-1-songmuchun@bytedance.com>
X-Stat-Signature: yu874xazxmmyu5hhjxtubjaqz61uf91j
X-Rspamd-Queue-Id: 045EA4000E
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779728705-415940
X-HE-Meta: U2FsdGVkX18A7AbokGQftP/u6s1vAObA5ioVJv/AiJrIc4fTEzJgaioLaBDY5o/qFnyfVv3A9IUsJei4GQr9Zq1arvB9femI/Xn6W7EDAvTTog2M1SnTOREmW6muyFT4YpB8Lr+VUp3DfINQbCg8LerD3jVzuI+MrtUBz4NE9gJxGdn73ZYUjzUa5jnhYlC/DpcRlPooC5yZQY8KcJkHuRC6SWMbmtN8GDNaEvVK7UJNyqiOGvd4uapc7qsObw8LGDJII4hHkc6BS3b9lO5H5a4VDNOCpQkFk6ooub5jt2SI7DY6DgwniJHGJCJeq/R/b04/DLYeGqxitIv37UWGWL7laaFvyvMHn63359UKPEZmB3sAIgqUIKlImzf58JpY3XThh5cnbqlWnCndaz1398pJiDe3PeQuvtjGvt+o8SwrhqC2/IU1i33p6KlLtQ2tbyifdKJWai8Xybx4IyIda6ajchD5b3Wg/roUT3xHR2QX3Ozlc1a3OGJRIS3Fu/ZX6dM3l1nnJBKa18He7ayMxQZ1uCy2A8hq0W9+WK98GoUxnJQq0BI1qjKDRUlu7qGAUPHczvbW5GbvwMF5S/4PIU4ciGvPYNrkiFFGNUIy0yt//lIj0h9NW08C5nWLq0DJNDHtV8ensMYK3h8lJRp4UWsHzgBN1X3wuqXuSsAK3MR3pOvB4img96vmbWjcYtOZhDGIDA/VN75iFWkdqJggJCdK+B3Zl1BRvTh1C7g8mJS39moy70bEw88FKITzPjNwiXr83wu4OAbnei8k5Cr+L/2I9lkWUoBTCOrAmaijnRivKHz/z5b9LriKnxT9t2Y3cJve24wop8YJ2XdCaGbMyI2VRsJeLwU1ucGYBiPKeFKBAvZhIKaXzokBgFXQPzNk3arkO3+U9ZTxXlXNvje+mn1uqfJNCTwwFpOUCZ2yi232BbtMBrPF4SOITTqheln8frq0G1tYLs+beRUHB+A
 p6se0WZ4
 d6ewA9q0BQZwWwNfzEOjLl8qoR6YWW11G1OkEdmj6iZoHg+gYOSu8Dp3ByecXwouRIDbFwybNd8M3sUnC+hqlVqvwv97rt7xFWW2SjEM9cPsl8Vb23SR0eu+sXN/r40lWXSbTTDVJmygJWIC3lVjN4Pgv/vftTfpJbN9lzx1Kta5Wv6lghu4jdPjnJdbyWJkTy9UtXD3ww3Nua0OthQ/7EvCDD5uHMC0mV1CrJEo53N5KaplVEfveISyTqwiJyfNiDZGwCzLAwC1knX4DC2mWgLtgG+NOwSc+GqKrzBXkD3Wv0GnCOgL1lohJDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 10:52:13AM +0800, Muchun Song wrote:
> vmemmap_restore_pte() rebuilds restored vmemmap pages from a
> tail-page template derived from compound_head(). This is wrong when the
> current PTE already maps a page whose contents are not tail-page
> metadata.
> 
> In the rollback path of vmemmap_remap_free(), the first restored PTE is
> backed by vmemmap_head and contains head-page metadata. Reconstructing
> that page from a tail-page template overwrites the head-page state and
> corrupts the restored vmemmap page.
> 
> Fix this by copying the full page from the page currently mapped by the
> PTE. Also pass vmemmap_tail to the rollback walk so only PTEs backed by
> the shared tail page are restored, while the head PTE remains mapped to
> vmemmap_head. Add VM_WARN_ON_ONCE() checks for unexpected cases.
> 
> Fixes: c0b495b91a47 ("mm/hugetlb: refactor code around vmemmap_walk")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

