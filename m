Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A928CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 10:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3FA46B0088; Fri, 12 Jun 2026 06:16:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF0496B008C; Fri, 12 Jun 2026 06:16:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D07316B0092; Fri, 12 Jun 2026 06:16:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C08DA6B0088
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:16:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 904D3140349
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:16:55 +0000 (UTC)
X-FDA: 84870857190.22.0A7229D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6203E20004
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:16:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KxJidsNf;
	spf=pass (imf03.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781259413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tp979dOtptTzRkrt7cWz3mNJUs8l3Jn3MYNI++Yv9oI=;
	b=q0iPOdCBGyJe0oyzYT66gjn3WJTGS448PtEb+0gUJhARWEqzNA2JBc0Cou1scqvyat43mQ
	GW67NHgZVob5+OH3P/nqqPkybEQHjx6agxGpxM0HkPLAWmNoufc+a5RtP/tajV9R6ymBzF
	6lA65u2qHNpKWVLFT8YDtCsWl/zm9QQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KxJidsNf;
	spf=pass (imf03.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781259413;
	b=JTWZ0Gc2xGTTLBb8CKtOdMLFv2Y1TiveF91tiJncZ4gUtksokwplZdyHuShaUw5ryo4VYW
	N2VbeHv9VO1J7Uyif2TPFNCo3uO4UTALERjjeIqVKyYGuJVVB3w6ksPrv9+5Q4w1bmIZR+
	4oti369zD232q0k11Gkzv1fI2Z81Gwc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 870AB4051D;
	Fri, 12 Jun 2026 10:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4571F000E9;
	Fri, 12 Jun 2026 10:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781259412;
	bh=tp979dOtptTzRkrt7cWz3mNJUs8l3Jn3MYNI++Yv9oI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KxJidsNf69oQW0KQKUAZaie1bUEXByiLwh5nLRR1MlAI4Oyemcm8x9Zpd2/TelgXs
	 4HmTGCj+jqKokm9Ufp+9BPgjA+auWrJOcZU136457TaCap4KJVqhMZJRlPqJI97vm6
	 TPDe18mlypGNJeiTaobCwIGVqWUJS4j4kaOiSkd4w2c0DJcdj1Cymp7GoUVVKR9VxJ
	 /deDrCi4i8HKL/oVv5VMViOYuFnyoVli1rfPXoIdgU1kxv4mC2mnsRGWgDipMoxXrL
	 AfbOY70Jh3r8F6hP065+ubCzu4T27FZgFrGygE2uFHr5I8mzP6HZMRyqNocu85UzR4
	 jAjKKLqREdqXw==
Date: Fri, 12 Jun 2026 12:16:45 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Huang Shijie <huangsj@hygon.cn>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
	akpm@linux-foundation.org, zhongyuan@hygon.cn, fangbaoshun@hygon.cn,
	yingzhiwei@hygon.cn, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH] mm: use mapping_mapped to simplify the code
Message-ID: <aivcjcl8OYadEHJC@localhost.localdomain>
References: <20260612073032.33228-1-huangsj@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612073032.33228-1-huangsj@hygon.cn>
X-Rspamd-Queue-Id: 6203E20004
X-Stat-Signature: 1ks9pcakzx4grrrg6f31x8knfi3jqnk8
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781259413-305471
X-HE-Meta: U2FsdGVkX1+NhFvIW9sdwjY2Nc5dtjSu17nyMn5FD2TDqzdBNKDSFwbbEshCt6Xc/HCO9Vvn0PaXR2rZx04up6LKTCQYJwPLFdvJTp7/g5AczeuHuYjNWOnCdJMG6W0p5Bqq7xfDAKaT1NzGitZQQ4iOmED9auU2xGYKJsj6W5VXOIBeRj7gTrJE72RX3DC4PTBrthlXe0jgzh81tx96WMqR2n5IyL0HtJhzrc+g2LEVhukVgd/WSXAM2AfjDdavmacVcg0ZLfW0ovjwwXiuMx14nbQ1Be5NpMUXF491115a/F7Q+QLmLfmz6MA7UWfB4hlNmmaN8xqXASG15z5R30MmbFn7uZ7tqC5qT/g16c02T9ZCQBuqGbnZixT6/s+A80kvNgKjH6ONV3sQNDH7qc2qi1UGC/lLZJj4Pgi3iG7C3xiXzDEjXmCe32GnMkh6k7Zd7nkgBezKyGV2EpHsZWWkhxyHQUEVHw0J/NoxZXwzlsMNcvmekzEPeV/4pQyNPZUX3IND4oBdxZAFCHIkJPrkeNHMCNFd5eq+KA+7dtG2TkIbe6bK7gU159oFf8oq00irlVUEnhkLhy8yDo0nejmY8y8C+OCpzyMmvui3M4eiLoGRTNTXSs1gJTXjgVVNJ1zoqZnV+ifeb/vQfTanvhKoUfhabJMnUUiPvkWU6H3Nd5rIjXGhsRPiYRInyDLYA0gjkzun56PLpNPq3PfOVaAz1pWp0h7Lipzks3xW5scWaDxmzYSIJNSIBwM5b4FYYHK/W8lqhQfzshIT6Tll0MPjRiI6qAnzpl2Jr39l2Mkr5TOdb8z3g3c+k0IEqmnIELnOzWU/J9mSJWOq0x3EDAt+wMXFJGpE7Mh07Zo9J8TKPNr9k1bQMbdd/DvdHLsrhKbtw6+MVU1xjP5HocptqqBpq/1zd27K2heHmPAD8jV59ZQ6osMz4uIPeH7kfDeUoV4td9jJ8PIlC9cev6n
 rQ8WDNJh
 jicqkx3jYKo7trtJkeg3NjAfJRNeT5OKAfv6qB/Q8gXGxBnjjSsZUJ0vPh7/UPWHVYW0cQiNTG3Pj8YXEbAnaEk9KTsF7WKzffLIJHZael9UV94qsiIgjAPCBDDRLtx+wKBlnRgM59eFBs7bF2ZCVj6h5biPlYE77dZFqJciXOjzssXsOPQ4Jp9BOcexVzMMiQTiX4yuB3IlOLcwpUrsR8oPhvhl6mV2eyAqGMv844GCFhUINFQClXPY2lGJCwdRtiifpXPC4Q8aZs1xtYa1z5Gh9Jfy2YbayCfjei8dQiDIO9fdCfqeMCHlFyIItAJpi11LO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 03:30:32PM +0800, Huang Shijie wrote:
> Use mapping_mapped() to simplify the code, make
> the code tidy and clean.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Huang Shijie <huangsj@hygon.cn>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

> ---
>  fs/hugetlbfs/inode.c | 4 ++--
>  mm/memory.c          | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 78d61bf2bd9b..216e1a0dd0b2 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -614,7 +614,7 @@ static void hugetlb_vmtruncate(struct inode *inode, loff_t offset)
>  
>  	i_size_write(inode, offset);
>  	i_mmap_lock_write(mapping);
> -	if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
> +	if (mapping_mapped(mapping))
>  		hugetlb_vmdelete_list(&mapping->i_mmap, pgoff, 0,
>  				      ZAP_FLAG_DROP_MARKER);
>  	i_mmap_unlock_write(mapping);
> @@ -675,7 +675,7 @@ static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>  
>  	/* Unmap users of full pages in the hole. */
>  	if (hole_end > hole_start) {
> -		if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
> +		if (mapping_mapped(mapping))
>  			hugetlb_vmdelete_list(&mapping->i_mmap,
>  					      hole_start >> PAGE_SHIFT,
>  					      hole_end >> PAGE_SHIFT, 0);
> diff --git a/mm/memory.c b/mm/memory.c
> index 86a973119bd4..5335077765e2 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4386,7 +4386,7 @@ void unmap_mapping_folio(struct folio *folio)
>  	details.zap_flags = ZAP_FLAG_DROP_MARKER;
>  
>  	i_mmap_lock_read(mapping);
> -	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
> +	if (unlikely(mapping_mapped(mapping)))
>  		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
>  					 last_index, &details);
>  	i_mmap_unlock_read(mapping);
> @@ -4416,7 +4416,7 @@ void unmap_mapping_pages(struct address_space *mapping, pgoff_t start,
>  		last_index = ULONG_MAX;
>  
>  	i_mmap_lock_read(mapping);
> -	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
> +	if (unlikely(mapping_mapped(mapping)))
>  		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
>  					 last_index, &details);
>  	i_mmap_unlock_read(mapping);
> -- 
> 2.53.0
> 
> 

-- 
Oscar Salvador
SUSE Labs

