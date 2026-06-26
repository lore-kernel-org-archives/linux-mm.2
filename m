Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3835CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 08:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D782A6B00B5; Fri, 26 Jun 2026 04:32:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D502C6B00B6; Fri, 26 Jun 2026 04:32:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C41A46B00B7; Fri, 26 Jun 2026 04:32:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8FA6F6B00B5
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:32:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EC219A03EB
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:32:22 +0000 (UTC)
X-FDA: 84921396924.12.F5276E3
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id E28D3100007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:32:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nzjs7Vqe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JjKks+Rd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Mmi38bNV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="hs/AdF2p";
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782462741;
	b=7SctwFmDG8VXwmvRvYhOgFYoRa5CVME/OHZARfDGAaRc1D6mAbv6SebsaxES2OmtES589W
	Do40plRR8LWjpw+bXv7Lreyce+HqXoDGhKMpeg/RF03+0EwwtMyMyqv71xR2KkLM5dG2f2
	iwjDSsflBzGsjknYtAiFbR8yCz5EBiM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782462741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xocu5qnTvy4+IFzcFqjfxD+zsBo6OI2gkaPHHHV94dk=;
	b=DAGo2aiiafF+W1EZNUmLFf/2jreiBb8W4MvlBx2FymcOZTyfF+8arfldfeTlQfxmWs6g35
	auy2meJBfG4zaNO8DXfvSFPHktLzuuAutuMGoTXBIbAd5wu74uo60XUXw35vuujMvBjcuF
	fhRJ2GEEgATxgrtFwkVlpCsPrW/3JAA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nzjs7Vqe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JjKks+Rd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Mmi38bNV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="hs/AdF2p";
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2A2E67174E;
	Fri, 26 Jun 2026 08:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782462739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xocu5qnTvy4+IFzcFqjfxD+zsBo6OI2gkaPHHHV94dk=;
	b=nzjs7Vqe94IwEmHT+dpEQBNiIks4/hsA/hpreRbClj4j+33JXW3OmJ6S94mB6p8a465S9w
	t/eTSOJc5zD7Sn2HGmsbvKt7hAu/8nEKKsQnYTk6M0i0/51AwAoyjGjziAXgcfG1VlIDYC
	ZFTJBpsUzIKJor+3pY7JGIP7mvm21qI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782462739;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xocu5qnTvy4+IFzcFqjfxD+zsBo6OI2gkaPHHHV94dk=;
	b=JjKks+Rds1p2WD+iQdm/y8/FA08HVAFej/MfOytgUxBXct2vs9mS//lbCKjSwMll7akmHK
	j8Fu4JIgn+lYWeCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782462738; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xocu5qnTvy4+IFzcFqjfxD+zsBo6OI2gkaPHHHV94dk=;
	b=Mmi38bNVsdAh2FJMF/9bCwDYWrp0u+w2D8zLakjUnNKzdvXz3dzZXVlWK8YrFJAbZB7U6k
	k7kWhxbjWNPu9x8QyttR7dw9n9v+AzBV80/lvjZtPSIPsM58/nHRKi3W5W92Pxm648JCld
	E8dSpVCn3FjHBgV/gngv8Tfyr7eje+U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782462738;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xocu5qnTvy4+IFzcFqjfxD+zsBo6OI2gkaPHHHV94dk=;
	b=hs/AdF2pbreD5/ACcd0Wmo1BJyupq6O+TuwXx3uFBrgPyas0CVywtwjxQNUkiRoLmfpr4v
	sYebFwGDY7jBXvAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C34F4779A8;
	Fri, 26 Jun 2026 08:32:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5iNOLBA5Pmo2DAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 26 Jun 2026 08:32:16 +0000
Date: Fri, 26 Jun 2026 09:32:15 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Xuewen Wang <wangxuewen@kylinos.cn>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, jannh@google.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, david@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: annotate data-race in cpu_needs_drain()
Message-ID: <aj44-zZ1LZfY8VIc@pedro-suse.lan>
References: <20260626053700.2036899-1-wangxuewen@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626053700.2036899-1-wangxuewen@kylinos.cn>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E28D3100007
X-Rspam-User: 
X-Stat-Signature: jrp19cmrxrawtb9sj4zjsxcp4737n6eg
X-HE-Tag: 1782462740-62463
X-HE-Meta: U2FsdGVkX19ZNdlicW0VEln7RxPYTsOA1FM5vKZDPmdHiQCMzDaql0SEODDuPeWTs3TXNK/me2l45dcYX9jUm34vUIpASAoi1L+vRAHb3PAs1uN6untlm+36j9fPUVrHWswjJnSU/C+QsiEtxxRTK7Grzc6vgB5cOt5YpMS5thXIyYu3NsQZbYD0rUcqqGjD5jHDaeV5SK3kbrNbNIxvfUUMsJvpQ1ME7d5UNm2Fx3EjM1xKd5kHigiFAtu/14Rt+St9TnNEfL348MKno9vM6h1CsZYqfMb+fMdKZh2fXP8EytRap9zztl+eL5Lq2GquHPWAFUTnIJN/Iguvqf8uJ6qDGt8g4m50cYxp/GOjj+aiJXDMLRt8f/eN6nsePEjBCDBPFkoVGbsRqfof6TRKpW0MZbOUa245p3EMy6WApJFBb2OrH8U1yxAPmoEVjg3thbpEqMoh5iIrZC1C8CSkZuqyMK/Y7W9nvE3yq9KmnYuucjwWBrxhuJlP7FITnhVf4iWx8QsQwbfxN10ZB7EB4Jn329lxdpXGGG/El57SRvF5j5q5qfgJevh7GbkKGc5A6XZxQpXduVfCx1BM4I2K+y/xcisdIOhaLX1/jJFrz7Fhwa3pRkEWHRBbAUbKybWeMHE/amI2mDlB7Pa+U8xOIPSdAjGmYq/9PRZ7oqQSVj29zb/sz2I+gczDi0XzTu3HuIaXKS9gw86TPlmEGi2HEykMhRwaWmbTIDLXChrKCFPVZos2Uw7c2MKZaES+uWXhbWJqWOk1H6K9TjgDTgee/jQyMQF+hstGHQV7dXO/0XHoOBxUDEgUb3ShfTJDaMwQ0uuYjFQUwI8ZTcRw35gcPFShVPVd23oYKGPCdpsFycGj6iNz4zz0kWkpLYLsTvt9BRkXBdSJUlIRM4lWDVoqkYVOgIF7MugyCqfVAWyUPQcv/dzRVaDuReCobK2OV5gh/qYKtJ39Q4+L9egm/lm
 aqAY+K1x
 4VLhvS7dh8Z7GTgL6rCJFBD0jtBLv5EVc3CivchaFEtvyPIQUQct4uaojgJt5jfY63zdTTJiHDpf/rQGW4NpeJyPlBcIBWiiwBTN+EkBu9ByrTJukJ7e3eCDVd4onclRqR9qFPeHQC/+38OR7wBNZQOxMtoqYw50GWpZw6zE1iEwjkYg09vZlKJl3hGiQl+4A/SANOBQUZtl8xtM/bpXiPsudroDdNb4aE+q0gPz9tlkMuBXW9X7E/PIbhgnbcr9Unz622CwJ2sCmsC92BBNngTW8Zx12QOvuflBgkyLUIblVgSkQdqeLdtzvJx5QPMiTkfZ/yPVkQ1ywbRV40vxXRmkPHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 01:37:00PM +0800, Xuewen Wang wrote:
> KCSAN reports a data-race when cpu_needs_drain() reads another CPU's
> per-cpu folio_batch->nr without locking, while the owning CPU writes
> to it via folio_batch_add().
> 
> Reading a slightly stale value is harmless -- cpu_needs_drain() only
> decides whether to schedule a drain, and the next iteration of
> __lru_add_drain_all() will re-check. Use data_race() to annotate
> the intentional race.
> 
> Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

> ---
> Changes in v3:
> - Wrap the entire || expression in a single data_race() instead of wrapping
>   each folio_batch_count() call individually, as suggested by Pedro and Lorenzo.
>   This is equally effective and more readable.
> - Remove data_race() from need_mlock_drain(), as it is now covered by the data_race()
>   in cpu_needs_drain().
> v2:
>   https://lore.kernel.org/all/20260625065153.1581419-1-wangxuewen@kylinos.cn/
> v1:
>   https://lore.kernel.org/all/20260624092606.1083449-1-wangxuewen@kylinos.cn/
> ---
>  mm/swap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/swap.c b/mm/swap.c
> index 588f50d8f1a8..46ea207e0624 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -828,13 +828,13 @@ static bool cpu_needs_drain(unsigned int cpu)
>  	struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
>  
>  	/* Check these in order of likelihood that they're not zero */
> -	return folio_batch_count(&fbatches->lru_add) ||
> +	return data_race(folio_batch_count(&fbatches->lru_add) ||
>  		folio_batch_count(&fbatches->lru_move_tail) ||
>  		folio_batch_count(&fbatches->lru_deactivate_file) ||
>  		folio_batch_count(&fbatches->lru_deactivate) ||
>  		folio_batch_count(&fbatches->lru_lazyfree) ||
>  		folio_batch_count(&fbatches->lru_activate) ||
> -		need_mlock_drain(cpu) ||
> +		need_mlock_drain(cpu)) ||
>  		has_bh_in_lru(cpu, NULL);
>  }
>  
> -- 
> 2.25.1
> 

-- 
Pedro

