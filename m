Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 204AFCCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 12:02:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CC2F8E0031; Fri, 17 Oct 2025 08:02:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77BCB8E0006; Fri, 17 Oct 2025 08:02:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690CE8E0031; Fri, 17 Oct 2025 08:02:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5601C8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:02:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E7B3D137DDB
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 12:02:54 +0000 (UTC)
X-FDA: 84007469868.30.056F37E
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id BB954C0012
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 12:02:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="U3k/aCbs";
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760702573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/JPR8GH5hcgadFN4LhX9XG9fVjAZMNhtsFHX93XBRmk=;
	b=zy/zNYaxf5MCzQjJTSKTXQ7lnse1vTCUCVmGdYefAtnifY7zHl9OCMdCN1HU4mdWp/pWx3
	zC55jrC8VdH+DTlab7L23lhQRLK8Ov9LfYMm0SupbOYuLSxyGI0JG0/Xk2uIUcMXXcSDOy
	rDByrp0w0B40U5CgcjBuOryEKqi1QeA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="U3k/aCbs";
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760702573; a=rsa-sha256;
	cv=none;
	b=mwTRa0wwQYO0eHj3fcxM9EfqbdwV/2yAV752+DxnkC1iUGZunbr+p2ecsi+3WMUmCL75Mf
	5JT0miAH961k23B+CoU1TIimp+GDx9uRAWFTch6E44za6DdXvj/Fa/nVWdwKIRQ0c4UD6i
	NtdSM0B9Zzx04cCGfaKGb9fiytFxmJg=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-427007b1fe5so1072899f8f.1
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760702571; x=1761307371; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/JPR8GH5hcgadFN4LhX9XG9fVjAZMNhtsFHX93XBRmk=;
        b=U3k/aCbs8o7vYULApAftc3j+JjMy9Y8ZTPMXsyDN28pKQXmBizqkPDWlcr4udUOUjW
         Vl/b6dsJAxqE/P3FW+D4bsCSAvtpw4fBGx43uD8bzvZiHLKjJbqoSvAPiBSUCJ1eNlYH
         2WMN19n4Clvz+wBt7hf+3T2sVIahn09kLKUSvferBwD4yG+ULPmHq4EKz0emlfkZ7si6
         Lsw/Ijq61q1MtaPq7rU1P13TvoSGrP4QZNj0HPWonHvclsLzYhoRMMUNIuC4wnEX0Vsp
         6BHqUK328EpSW0Pug0qju58qCEzOFL4kOaPu5ZVILQ6i6UiIJi7SP9AqZ8SjfHCYWmf1
         mcWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760702571; x=1761307371;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/JPR8GH5hcgadFN4LhX9XG9fVjAZMNhtsFHX93XBRmk=;
        b=crCOgP0vKL0h3cZYg6ivrhrsaDM8n30mC+QpHvjmEoPsD/Q9j0bVgpIG2TzoQx188v
         3nybUEMNWFzC/BURGHEMMSj+z892yXTf32dIzoae0232NYFSncctiqdgd0G000XwwBhN
         YneaDQeKJkYxP684+/cyVFln6c/3vuDraFTq/RJlFCpN6tlFjYedImlNXxpfiUQ3m2a8
         QHE5epQ3DABu+QBGiR8IU17tQEVdq6kXavqKSLfpuDB3w0U22871bF+lkzCenJ0T18+D
         KLOdUCVsqFpxRzKso8Zp3PkPZgAkCXZjX9qS8hTXGh7D/bXWgB8HfjvD+fU932SVgRji
         0j8g==
X-Forwarded-Encrypted: i=1; AJvYcCVLc8Tpd7Wc8KreKbiuL6iyRp5jEKOy/ScPfN5DfK2rPM/C1mOE61plXxi3s/xDJ6NqFBYrFoZBNA==@kvack.org
X-Gm-Message-State: AOJu0YwT8JyvWJsSR+E01Vif4gvZP3FVc364RhSXUsrN962h3PRp0+7l
	+tX+2YiKwWCu21m/A0xmp9g/0NBqZCSaQbzhU3jRafmWJotw69ycm6QP+PiUziYDLBU=
X-Gm-Gg: ASbGncvs4pugB4qPMNOqJcFwXblwCoadnn8rIb+ZSHPOesWVZ1h/gjS7QEfCVciyMwL
	/MBIXna4ZbuLfxr7UIyhRe7mjuyU5tPMJ6bwiqBh05FFwTAOhL98Odx2jhFHLDB7LtvnGxdleV5
	/Cxoj9tbERhOGwoTIkpAmjyOqBuiQ6GQHN01vW0AEPZw3D52B3WP8ct2Gk40B6dEXQFnbfIN86+
	lXUsLq49O0KXsowHz+xFyzqbqbO/r02/77Pc0oz1as1kN7LdY3NzHJI/95/odRBrNsBpA8GgXsW
	bP3xIPsAeiWEWAl4pGRPwEzCKgZQy4o685aaO4O5+4fHO1AmXUnjYwjvBsDmbqMvSHtHdqu8c67
	eR2OsmGYlCe5Xv+oNBhhF8MpZPYEw37yPnBxJcFlKc3tB0F/kRxj2l2DSAjUEgvk57KA9Z2OMR2
	00X6m3+9WUH+0=
X-Google-Smtp-Source: AGHT+IE06r98UHWFT2Xk7ldaGKsG7wzyanlhTrg8kwfuMMKG0UEDDaMDa+nIp24NV8a0FkDRNf9r/w==
X-Received: by 2002:a5d:64c3:0:b0:426:dbef:9abf with SMTP id ffacd0b85a97d-42704d8e0b2mr2471395f8f.23.1760702571075;
        Fri, 17 Oct 2025 05:02:51 -0700 (PDT)
Received: from localhost (109-81-16-57.rct.o2.cz. [109.81.16.57])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4270665ef67sm4048567f8f.28.2025.10.17.05.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 05:02:50 -0700 (PDT)
Date: Fri, 17 Oct 2025 14:02:49 +0200
From: Michal Hocko <mhocko@suse.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@redhat.com,
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com, hughd@google.com, willy@infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm: vmscan: simplify the logic for activating
 dirty file folios
Message-ID: <aPIwafJOKUh3N4zX@tiehlicka>
References: <cover.1760687075.git.baolin.wang@linux.alibaba.com>
 <ba5c49955fd93c6850bcc19abf0e02e1573768aa.1760687075.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba5c49955fd93c6850bcc19abf0e02e1573768aa.1760687075.git.baolin.wang@linux.alibaba.com>
X-Rspamd-Queue-Id: BB954C0012
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: mkj735n5atfnw3hkdmeadko6hr6d95zg
X-HE-Tag: 1760702572-254933
X-HE-Meta: U2FsdGVkX18nfQoOFv/FFtZlse5piOLiNFIjXHggMw/Y1EMhAeB+5HMYiJJRMFXe1DVRDmYjjvFlJU7KT7IQQMqKxPMYh4YaUg22mrGd2rqQpSR0874RFsHp9IWVupnD0j2X16E3wfOL8YXLzREu0IbpsiO1rcVaZc/6kxYPyQdfNGMb8Qc/yzNYAKOO0sbhQmpTmvXc+FnCG1a503U/y6vstUaMCXHQdvGSEjlz5ihG1XLK8XCB16DLQNYzMclX/ePlU++Gd5FdHkrbA/cusUvfnQ+sC5/aeydYUTy6/C+Jcy4mZjvmZUx3IP6afchEcOPGIClcpMqaLB0k+lGsaeWyOvp9SnadvrdBwRRpaxEb+3nQHc57tcveOLYc95wz/cqDczQ+bO2nNOw9KMigKEfg/MzNVHJRBhaf1fZCIcW+vXsH27iYhtvhII3nFE92lepqqxnEtKzJSTCfD5p9Q28dmvzjO2gIgawRH05oLvmeE4MaGIb5QJFNb27gRb9+MrX/8l+4/4v0dh1dEZ4r7wDy/onK3AanGOE39tGR+Yg1hiuKbhD4Yu8+Rpd/9YdMTciyOEeLtQRypX/uvbZa/jWP6FtEWRhPOvyAUPoDyNobivNQtGdxIqcK3KT+wtLUQrlk6Ys48ssWC0eso3N5zKSmDMYY0Bg7sEaKxQkeHpmff8xfcoL8qSXxqTvshj0Txfgusn/wY9wk+MeOx2BsQMGZ7TJnteggLS1hF6yAnSdgT0P6HIDpUi0Docco7rNq1wDRNEjv7Vs4XZcFgPzHXZPjc7sCrUeOl82VizS3YSjReGdNkI34nqFjVSwngqWY0kuke1X/2EQKajfUzQlgyXQrLR6BS7BYHeiqx6Vf3lif4WaU0ENKoZQbPf4rUGViCsW6ASZgPPfIP5wrBBgwV0a8XiQ8YURWjBmd1BNJz6rLva1hn/KXcccS51zrt97F92W/D7HUqzKIEOor8zo
 1m1clQAq
 faBASWubx0jQJ2sZIbFzevsoaq5LPm0D5wjHn+NGl71PoZj1SR5BHxUiT7QDmZe4nk5xhUSGJIGyomrbTf62FMVz91AkToiV4+7sOSzqRKorcm/kn2safJIfW5LcSUWTJyRjeLFAgSEUaHTxn9kIFYrbfdZh0SMZrvDlMR9dAhhdwg3KniyAHz+xN7afG73OEubGQwyYYNvWhUdAf6hwbnZyvjP3dUafDLejHlSYrInG2i1QbBswmp3ct2BKDjh7YdmMqRSdqrO4mg5nvtRfZSh0bImthBB+Uk+8Bb6gVjH3saG1wCTN6K1tKYqEnj7436AEooFr+FeJUHMVnxpcAVtXc2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 17-10-25 15:53:07, Baolin Wang wrote:
> After commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no longer
> attempt to write back filesystem folios through reclaim.
> 
> However, in the shrink_folio_list() function, there still remains some
> logic related to writeback control of dirty file folios. The original
> logic was that, for direct reclaim, or when folio_test_reclaim() is false,
> or the PGDAT_DIRTY flag is not set, the dirty file folios would be directly
> activated to avoid being scanned again; otherwise, it will try to writeback
> the dirty file folios. However, since we can no longer perform writeback on
> dirty folios, the dirty file folios will still be activated.
> 
> Additionally, under the original logic, if we continue to try writeback dirty
> file folios, we will also check the references flag, sc->may_writepage, and
> may_enter_fs(), which may result in dirty file folios being left in the inactive
> list. This is unreasonable. Even if these dirty folios are scanned again, we
> still cannot clean them.
> 
> Therefore, the checks on these dirty file folios appear to be redundant and can
> be removed. Dirty file folios should be directly moved to the active list to
> avoid being scanned again. Since we set the PG_reclaim flag for the dirty folios,
> once the writeback is completed, they will be moved back to the tail of the
> inactive list to be retried for quick reclaim.

Is there any actual problem you are trying to address or is this a code
clean up? How have you evaluated this change? 

> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  include/linux/mmzone.h |  4 ----
>  mm/vmscan.c            | 25 +++----------------------
>  2 files changed, 3 insertions(+), 26 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 7fb7331c5725..4398e027f450 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1060,10 +1060,6 @@ struct zone {
>  } ____cacheline_internodealigned_in_smp;
>  
>  enum pgdat_flags {
> -	PGDAT_DIRTY,			/* reclaim scanning has recently found
> -					 * many dirty file pages at the tail
> -					 * of the LRU.
> -					 */
>  	PGDAT_WRITEBACK,		/* reclaim scanning has recently found
>  					 * many pages under writeback
>  					 */
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 65f299e4b8f0..c922bad2b8fd 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1387,21 +1387,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>  
>  		mapping = folio_mapping(folio);
>  		if (folio_test_dirty(folio)) {
> -			/*
> -			 * Only kswapd can writeback filesystem folios
> -			 * to avoid risk of stack overflow. But avoid
> -			 * injecting inefficient single-folio I/O into
> -			 * flusher writeback as much as possible: only
> -			 * write folios when we've encountered many
> -			 * dirty folios, and when we've already scanned
> -			 * the rest of the LRU for clean folios and see
> -			 * the same dirty folios again (with the reclaim
> -			 * flag set).
> -			 */
> -			if (folio_is_file_lru(folio) &&
> -			    (!current_is_kswapd() ||
> -			     !folio_test_reclaim(folio) ||
> -			     !test_bit(PGDAT_DIRTY, &pgdat->flags))) {
> +			if (folio_is_file_lru(folio)) {
>  				/*
>  				 * Immediately reclaim when written back.
>  				 * Similar in principle to folio_deactivate()
> @@ -1410,7 +1396,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>  				 */
>  				node_stat_mod_folio(folio, NR_VMSCAN_IMMEDIATE,
>  						nr_pages);
> -				folio_set_reclaim(folio);
> +				if (!folio_test_reclaim(folio))
> +					folio_set_reclaim(folio);
>  
>  				goto activate_locked;
>  			}
> @@ -6105,11 +6092,6 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>  		if (sc->nr.writeback && sc->nr.writeback == sc->nr.taken)
>  			set_bit(PGDAT_WRITEBACK, &pgdat->flags);
>  
> -		/* Allow kswapd to start writing pages during reclaim.*/
> -		if (sc->nr.unqueued_dirty &&
> -			sc->nr.unqueued_dirty == sc->nr.file_taken)
> -			set_bit(PGDAT_DIRTY, &pgdat->flags);
> -
>  		/*
>  		 * If kswapd scans pages marked for immediate
>  		 * reclaim and under writeback (nr_immediate), it
> @@ -6850,7 +6832,6 @@ static void clear_pgdat_congested(pg_data_t *pgdat)
>  
>  	clear_bit(LRUVEC_NODE_CONGESTED, &lruvec->flags);
>  	clear_bit(LRUVEC_CGROUP_CONGESTED, &lruvec->flags);
> -	clear_bit(PGDAT_DIRTY, &pgdat->flags);
>  	clear_bit(PGDAT_WRITEBACK, &pgdat->flags);
>  }
>  
> -- 
> 2.43.7
> 

-- 
Michal Hocko
SUSE Labs

