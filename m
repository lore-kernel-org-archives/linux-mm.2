Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF3FAF94CB7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 23:29:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 341DF6B0005; Tue, 21 Apr 2026 19:29:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CBCF6B0088; Tue, 21 Apr 2026 19:29:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA686B0089; Tue, 21 Apr 2026 19:29:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 048916B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:29:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A47175B9D5
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:29:03 +0000 (UTC)
X-FDA: 84684155766.22.873EF70
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id D5336180003
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:29:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uC9WHgNb;
	spf=pass (imf06.hostedemail.com: domain of dennis@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776814142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TYKF52HbuWXD2OOfUs6TrDkX3prFZKPFLT7p3BWL6Xg=;
	b=RV34vYVwO5U8fuGEZRtGTS8F+4ygKJnP77/FwXQ2sZXSjPkmRB2yirTNN6jjCdvYZ7TY/Y
	vSzCrnbo3pSq7WgmZOtEjCb/Dm6oJ98ySNMCN2Tr+OCJ2Uk89VmDyCF82QRh0k6Yp8qK9v
	2H1FlaW4fqsHl/FZlQnQZ2wpa1cyaio=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uC9WHgNb;
	spf=pass (imf06.hostedemail.com: domain of dennis@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776814142; a=rsa-sha256;
	cv=none;
	b=g+M5XE+LIxJJsmP9LLs0Yn+Scu69lBD4ba0Oz2vnhjkzcGQ5vz7e/Tot/XV5vd0D/KkCFa
	HRK56PZxGtm2RIUDkKpzI91rO4vDcLNND3Z3qk6wVnYWDQPnrkSeHF8npuIHwn3mBHxVNo
	BLJRjkrLtBJoUAwmndnb1Zia8BtJPb4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7190243652;
	Tue, 21 Apr 2026 23:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F137AC2BCB0;
	Tue, 21 Apr 2026 23:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776814140;
	bh=yhS4w2iWbQXVD+c51oA2tUzJ48+g97qaeOGGP78n24c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uC9WHgNbcrEwpY9K7QCOmayEeQDTWcdMR4d0pcK3UVmff5/XtLW40S0xzobd/nhrv
	 jlWIZNygRYlxzeKp9DFFQx1gauYTAnLuM9Q0x3bqQv5y6Y6XVez79Dobepvi6dwqIg
	 QSJImbp7Xp3COjJHMOfHaralVGrOU6HG4/Nt+SJCA/b5ycNpumOHoOXEPIv0AS0Nq5
	 fhKfMg1MVeydNzMum7k8xWL5CONvVF4XBxiKiPULNQeMIazzQsK7hbS21nFRn9TwZj
	 dy7487mcln4R7A9mHygWbeooaxi4u4H7zqKdJX5UoDRaoklXiIXuJByTr0A2HST7yd
	 NQeee9mP3NYSg==
Date: Tue, 21 Apr 2026 16:28:58 -0700
From: Dennis Zhou <dennis@kernel.org>
To: Joonwon Kang <joonwonkang@google.com>
Cc: tj@kernel.org, cl@gentwo.org, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, dodam@google.com
Subject: Re: [PATCH v3 2/3] percpu: Do not trust hint starts when they are
 not set
Message-ID: <aegIOh-cC03ZNRPh@palisades.local>
References: <20260410174417.1450834-1-joonwonkang@google.com>
 <20260410174417.1450834-2-joonwonkang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410174417.1450834-2-joonwonkang@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D5336180003
X-Stat-Signature: 96xmq7kenryg6cega39q1cuk1e64du1j
X-Rspam-User: 
X-HE-Tag: 1776814141-171934
X-HE-Meta: U2FsdGVkX19Z7fK73CtFQt1CyRVDS375Xtov20WhSHnoRIqcs+dfmEQobcFRwdFrSd3yJ6GN7xHQnI9/4CGt1GVoFAJg+o28QVZ0EO6yaOqXaIkRFE9gEniF8QQJQ4uKec0XKVfJo5xpztD7Eh0EL+a3Vz0RVx3lmBMZvVaC3r5SYCVPAU9IIGFeEFp4nVeL9AjDFdc2v/7JTRXf/t86aIoK5FnI0Wzo4vVxegstgAuUMhjktCLBk/pNInmEMCoWHAeHNpDWBTdA/nR7AH1BiL2D+EnpQur/A7Zo5c4RkdxVZ14lG5MiZY7JWsFLk8Fa9HWoQSsfDlnW0CtNlXgppfIuy0b5XMVLN67sGOgeSlXmRfeYWBervrZtmImDDsZNd6nK83Sk278G1PqOOB9SAVbApCNn1BmojbDkphyXJ9CvaWW3v6Xlu7P/BOUYfyAwb8Hrup4lhMZJM+d4VY2EhFwSAQyfYag+lYpemRMelrObAIFz98TBBkYe2HGFTNOZQJ1LHf52RnAQtI/44JQCJ1YCN1QksuborqRiQvc35HowBRXu4wObN2/lnT+i172Q0Nln3xoepDCZPD+LM00RMJwDwU0es1p3OC6pSbZuwfWxM9uspQ9CSdHP2JJ+1IgzNdtwkKejgu1kwQ2F2R/f09AYMZjGJS5jpC7R9VuFVZLREPN6oFYq0MPylzcDiw57UnS9up2XJKkPjiRF5qWU/69Y9l6h/hQXA6xddn6JIapSQ0351hUypGOqqdt1dB+CLGKzRc74soO2V5kX0iZT5nk3je/1k4w7yoa5fr/QII9HdvsRGRACOJ3qh84or9w/5ghNykXoWPkS3fdowzuesGBIuWBi9OsesAXz+q/64TfnoPWLUfIDbKtNiOEHQxHf9vpV4enzeFiWjZxTd0PO119xn4HKvLnc8PgiCMc0pAcKwFMl5QeTT2WwMd6jppLgWqsQ1Z3+p0YcIoRaEB6
 DG5Hq0Rf
 iWEkJZfSrogdSquUNPyH9VMlDo2nOAMACJGmdCuliwHQIgatj/42rptewjEcURI6Kv9cjVQqVbL5vNuwvkh9+m/8I8kruq1ZideflPysxlIZSLch+FK1w2S0j1Cd01EhXMnQFxyiyEfU2aQJSIDp8EfoJVuGFXAMPGgvVl9W1lZQ+znvTxrCxP7UEArRhlGJfgmxQO/pxnkfqVfFMKHjxOlGEYw6kFonnLOr92manHbYDIu80rKtpTUwd1oB0d6V86FmR4QFiWM3s0vw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 05:44:16PM +0000, Joonwon Kang wrote:
> contig_hint_start can be trusted outside the hint update function since
> it will be updated everytime contig_hint is broken. On the other hand,
> scan_hint_start might still be invalid anywhere in the code due to the
> broken scan_hint not being updated promptly. If those starts are trusted
> when they are not set, it could lead to false invalidation or update of
> the hints.
> 
> Signed-off-by: Joonwon Kang <joonwonkang@google.com>
> ---
> v3: Initial version.
> 
>  mm/percpu.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index 3ecd86096641..f16533ed4a49 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -638,6 +638,13 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
>  	if (end == block->nr_bits)
>  		block->right_free = contig;
>  
> +	if (block->contig_hint == 0) {
> +		block->contig_hint = contig;
> +		block->contig_hint_start = start;
> +		block->scan_hint = 0;
> +		return;
> +	}
> +

This change isn't described in the commit log. I'd prefer to clean up
the logic below than adding this additional if empty case.

>  	if (contig > block->contig_hint) {
>  		/* promote the old contig_hint to be the new scan_hint */
>  		if (start > block->contig_hint_start) {
> @@ -845,7 +852,8 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
>  					PCPU_BITMAP_BLOCK_BITS,
>  					s_off + bits);
>  
> -	if (pcpu_region_overlap(s_block->scan_hint_start,
> +	if (s_block->scan_hint &&
> +	    pcpu_region_overlap(s_block->scan_hint_start,
>  				s_block->scan_hint_start + s_block->scan_hint,
>  				s_off,
>  				s_off + bits))
> @@ -889,7 +897,7 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
>  			/* reset the block */
>  			e_block++;
>  		} else {
> -			if (e_off > e_block->scan_hint_start)
> +			if (e_block->scan_hint && e_off > e_block->scan_hint_start)
>  				e_block->scan_hint = 0;
>  
>  			e_block->left_free = 0;
> @@ -922,7 +930,8 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
>  	if (nr_empty_pages)
>  		pcpu_update_empty_pages(chunk, -nr_empty_pages);
>  
> -	if (pcpu_region_overlap(chunk_md->scan_hint_start,
> +	if (chunk_md->scan_hint &&
> +	    pcpu_region_overlap(chunk_md->scan_hint_start,
>  				chunk_md->scan_hint_start +
>  				chunk_md->scan_hint,
>  				bit_off,
> -- 
> 2.53.0.1213.gd9a14994de-goog
> 

