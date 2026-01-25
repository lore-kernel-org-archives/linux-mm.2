Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7151E63CA2
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 11:52:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B3EF6B0088; Sun, 25 Jan 2026 06:52:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 395796B0089; Sun, 25 Jan 2026 06:52:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C2456B008A; Sun, 25 Jan 2026 06:52:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1A8A86B0088
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 06:52:11 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C44C91B018B
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 11:52:10 +0000 (UTC)
X-FDA: 84370322820.04.18061D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 46BCF180003
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 11:52:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RlinmGtC;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769341929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hDou/1syS+JRCJ5qMonQA+5CbCcw+Ru367ifn0R2jUA=;
	b=D2aDo3ha0HLvxQRgk/npRYSK+CkCY+W3zVTg3SOj7XVuUHMcmtSKwe6UlVDUkui/rj56oP
	XGwpdTMmCDbVTi8vhiNYNisiwB+yI1QXY+d4ZhJhb0GEvkrgcPUDEXqExCcdukeTpiuePC
	LDthQV4O+JOMgoERsJFAtmSQ/BDYxNQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RlinmGtC;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769341929; a=rsa-sha256;
	cv=none;
	b=tBKsG+py6EgT2xXP+bbKTALzL81RumNScfD/umWGCsx5d9CgadQPF7HLQFslk+W42x2jld
	+rJcm2BWahXyY/gR774hIurLpeP8NDl/kVyVC5FX1i4RQ/F++jjtr6AbqJkP6IntYLsFTm
	Zl9GyGThDOXMwxSPEdOzH+QDcOiBpNU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A561C60018;
	Sun, 25 Jan 2026 11:52:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6121C4CEF1;
	Sun, 25 Jan 2026 11:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769341928;
	bh=iF5UwdbLx3lobfdhIsiNN5Ktf/ekLJHA9XetyqKlp6w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RlinmGtCV5do+fZPL7nAszMQ8paDm3KutZYyue7aB8Ty5G9Kq3P0jh/Bo931S0z6M
	 pAzQQWRdVzR1dpH1Fx377PGCxDPleGB6dYACGOs7o2M2z5TjZrKHyaFR/pRSptAs2x
	 0BCrsz25RPCRvQoZZDnwfBkXN4jvuyuZN7dJEwddNn8a46eQX6TurhH47R9yLqDCR/
	 4qQ/ipykXjpLdk2+SvVorfeYfo0gxv/1YwFKgpnXx435jBPuSH4gxrzXj2MgJNkHUH
	 xtXJs9LQDzsV7iSlqNsqs3gbVIwdSqh/Sqv9Qc1/2bTAgg9FXhrI1NLqAENq1OAgR/
	 p6+5MS3tT1E/A==
Date: Sun, 25 Jan 2026 13:52:01 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memfd: export memfd_{add,get}_seals()
Message-ID: <aXYD4b46LcwSodjX@kernel.org>
References: <20260123095854.535058-1-pratyush@kernel.org>
 <20260123095854.535058-2-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123095854.535058-2-pratyush@kernel.org>
X-Stat-Signature: qaqsrdtwqobsk3e9i6kwx4dcn73x4wk9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 46BCF180003
X-HE-Tag: 1769341929-303637
X-HE-Meta: U2FsdGVkX1+zuE/C7qwYCzkCPj0JTl5CadUWS3gU3XBM7kT5XAWbdthqfMh8aVdPE6K4rvAGsTVz6d+gDy746lRJY05ts43DpoTa1JDvIE6Uf+zQabbTp/4cv+K2UC0vfFk9sq0dWb2QW+kdeRx9yIZqnIdJvH/tXi+emZ+gqGXaTX47km3Nox2CtA5MNrdnkFplfMdd9hF7ZppZJEnArPx6ZoO1EhrntOnsCCIPO2cGdcPO2q/9l2vuFYU2gApKsgaLt7dKxmEzEHwRs1AqP6WsUzUjk4umv5pyyDM5YSF8SQ/VyJxHrWwtmviswwChwzdO4rU+Xi+2TWVTTZTr05ir8LJFaZQmiDdWqV/0tlmNvz0ieZE6mUESnrZlbEZnkkdG9ywWGkI2FTIRyvw6uXQgK2mp/pGzDbYfGQs5SyrYCtSudbu3SqsnQe57S40sHeGtX1tvY/OwhMSkzo6p3wEocg3sutRzVSX2L/RyMiKtbFk/7tWhtY0KXF38v/AmVS4BAf0VlqPGqBnKgJbjYYjlPRF43E/kpKAjxQsdmibEnk/K/gKFHUQBJrJqGgbaL0KKEwHXa8IO7qqD4tOPzen7lnGao5YMzSH8nrtau0RSGV2TqoRz4kpd4hgq7gNgEmsmv2yyepqq0JyMSOPhYTa+YC6+RVmF6bXPg0wIlNvrGGjjO7YBKBvBpe7tNhjtCALCshhZpF9nJasqUQKQw/RinOn8W4zfSKhlSxPd6HebJly7VgWHMDuNnPeAy1YavG07v3swevl5q/KsBJ2+d4pJjjV4KfDohSFXCx2fuX0pRi4y27cV+qUJuPkN9XLQhdZhwjw2xbgcX91fL+qmZ4oIKagqyk3iIxPGcf/90XrJKy1cO3sAg9ua2tGE14oC1UrlxUiF0n1B6EalUWl4gUULaf55GBeuA2xLGe1hXPQt/evJIvVnsXeZhP6fB9d4Bx9j1wsOoZdNARQxQrs
 xzX9YMhx
 7TRAvsOWA3AXE+FaSEazJl4dGFWcRpq5ATPW0JlRldFYWkBSCW5fmiTgW1wEncU9oegODKFW9QHaxegvL/gUFJJat32btXZjYdjAyTOX4/toNWoAlzdlTyy4WhqUEsrXCctu1p0uD/d4a/NDohhdztcVyKKSDkhG5teDv1Q/IuJsQg4eg4En51WyIUbSQ8riFy/KlG7oMgdWbom6XA0FFL2XMBdU2szH8aSlRJwtyDYWAJua02YxrSloXMb3zWUPhWheoRUIuaSnXCisPgv9FsIQc6NBqyk5zvz1R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 10:58:50AM +0100, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Support for preserving file seals will be added to memfd preservation
> using the Live Update Orchestrator (LUO). Export
> memfd_{add,get}_seals)() so memfd_luo can use them to manipulate the
> seals.
> 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/memfd.h | 12 ++++++++++++
>  mm/memfd.c            |  4 ++--
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/memfd.h b/include/linux/memfd.h
> index c328a7b356d0..b4fda09dab9f 100644
> --- a/include/linux/memfd.h
> +++ b/include/linux/memfd.h
> @@ -18,6 +18,8 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx);
>   */
>  int memfd_check_seals_mmap(struct file *file, vm_flags_t *vm_flags_ptr);
>  struct file *memfd_alloc_file(const char *name, unsigned int flags);
> +int memfd_get_seals(struct file *file);
> +int memfd_add_seals(struct file *file, unsigned int seals);
>  #else
>  static inline long memfd_fcntl(struct file *f, unsigned int c, unsigned int a)
>  {
> @@ -37,6 +39,16 @@ static inline struct file *memfd_alloc_file(const char *name, unsigned int flags
>  {
>  	return ERR_PTR(-EINVAL);
>  }
> +
> +static inline int memfd_get_seals(struct file *file)
> +{
> +	return -EINVAL;
> +}
> +
> +static inline int memfd_add_seals(struct file *file, unsigned int seals)
> +{
> +	return -EINVAL;
> +}
>  #endif
>  
>  #endif /* __LINUX_MEMFD_H */
> diff --git a/mm/memfd.c b/mm/memfd.c
> index f032c6052926..46c5508beea4 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -228,7 +228,7 @@ static unsigned int *memfd_file_seals_ptr(struct file *file)
>  		     F_SEAL_WRITE | \
>  		     F_SEAL_FUTURE_WRITE)
>  
> -static int memfd_add_seals(struct file *file, unsigned int seals)
> +int memfd_add_seals(struct file *file, unsigned int seals)
>  {
>  	struct inode *inode = file_inode(file);
>  	unsigned int *file_seals;
> @@ -310,7 +310,7 @@ static int memfd_add_seals(struct file *file, unsigned int seals)
>  	return error;
>  }
>  
> -static int memfd_get_seals(struct file *file)
> +int memfd_get_seals(struct file *file)
>  {
>  	unsigned int *seals = memfd_file_seals_ptr(file);
>  
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

-- 
Sincerely yours,
Mike.

