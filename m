Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E15AE73143
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 01:23:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C11E6B0005; Mon,  2 Feb 2026 20:23:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 796366B0088; Mon,  2 Feb 2026 20:23:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A14F6B0089; Mon,  2 Feb 2026 20:23:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58DED6B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 20:23:15 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 100C8B8100
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 01:23:15 +0000 (UTC)
X-FDA: 84401397150.26.DC6D46B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 64621180007
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 01:23:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U8Mv14IQ;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770081793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G4h3UlD0UOQX5hsaUQsHVAZQOi8G+AVztfEKELY+wlk=;
	b=yqIa1Qnjen3zp59bz8i42lXGcyF0eLgrVQBeFLCI4Qx+YkjyDhqqMomuKXKH2RlwZS8j2o
	LNaZLbR/vgYRVKRL7u7AZKTgYv79/wZ4JUPYfwB7lVn1GKeAud48Bgs5dk6cwsgnnDnbOm
	1M0d2/sVgUn0Pn6iYlUSbs9go8ev/68=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770081793; a=rsa-sha256;
	cv=none;
	b=5oEgLn1Msz6CH+q9noZIA1KLhdvxTJneVjuuBFAhMqVC8bnXcIxBIIbh0ASSNKQ8pEyuK/
	o2GBrfza7HVjFwuaDxbkfvZQHOZfvj/1kOB4HQwNWmrlmzdD6Pv519+pJ6ph1XKVXe9SG9
	0nbDfA1VjM2a2aRstLEwPoB5y/9W9RA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U8Mv14IQ;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C5E741824;
	Tue,  3 Feb 2026 01:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03677C116C6;
	Tue,  3 Feb 2026 01:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770081792;
	bh=IgpK8TNN+i/1sHRlMuthVmqs5VzwjRwumGrfu+Q/0aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8Mv14IQttEktkk7rT3/Ou6g3Z5Y34x2R8lMALQaNWDhmZquidqCuCpFoPn99pwLi
	 EMyPPfo0Yl1wXzj4Stk1e1dmRpir2Q3ugdwwSy1xm7//2OzAyKXc6Cuu/pSXQhm/t6
	 PonfpXnSpk/BuU2lt0jcRMkZQe/Pqj90mRoUSm3TIcmSVU+LBVEDyB2+TBD/K4/a7V
	 hd4UeVk/XQMzjJNIaGTyscYO78Vg/RNw2Wf5KTmwSEoEDkBBhT8N12XVn3e40BTEvc
	 Py8Zcj9HRxZb8vN7KQH42f0d8tTK43Vk5T53rnjDjt6eKlN9HwsaWPzB9mDRDmp6QR
	 Y+iNSJ9LUu9qg==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 2/4] mm/damon: Support for synchrounous huge pages collapse
Date: Mon,  2 Feb 2026 17:23:04 -0800
Message-ID: <20260203012304.67686-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202145650.1795854-3-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 64621180007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: mgjffchkzoofbt1k8do5oom8ga4bosrc
X-HE-Tag: 1770081793-919231
X-HE-Meta: U2FsdGVkX1+1fqDWxeLVSqPAFFb8rNjkajVNEEfdWkTEqeD2sX+d7jOYMDKf6lJaBmmuU0c+MWvZZNc2wCteWF20vt8wXHhLsfvzxwhIFqMR2LwS/dIKQG1nOC1ct/v13lNLMp5NepGCCZU44/nqS2kW1TV6SQ1ItQfKFk7xaBgrCGNLuWFh7Hi73wm/puuPVO1v13xJ2QDGV8K8YAnxOZ/Xy9VHo5YINxGMb5iRT6GLnGL2STgiqPV5ELbU0mN8BHK6BtODaYATBmeBqFdUp750Co+u7iabyM/qMBv8/HogllgtBD3oJhN8LwSsBJKCdEk7MJi8EE3xongVVZWRMl/XvVF3A5QSQgrIXTWP832DX4Q7KSNVX0SMh0s/xhw8Pu05GDfh2LQOBICtO7xEOGejHf4Dagx6iM83b91LdGixSGp7FqY0ldFHQOnHuj2gZdpUrLgSbhrWzD9mrdgy4Rdzz41ghUfpztoaACQozTpxfpvs2NfdjzbTegjwq2JsTHcIJ0PrttSzpHqu2ANj7R75YIyYgL4WyCcRuE2PGYTEkksTZmaXVCxk5pvUnaSUqR+ECA6VrxBcHTLtMrV5NA1AzwePlHopn96lVdtKN6hlkn/i2BE8RLGRR5ebQuDJiOqYE2w8M/dS3MURrTdjaDWL521cTuaLgq3OMvEhRmHwq6AcORkscePeB6K6rYm7GuNin5KpoqPbvQuDGHBhA7kagnHiQlE7q8iNjnKg9IqPgV/zSz/Gsy2nK0YjEbnnmfPEWjJ/T/06vNz0iYdyQTeURbYa/tYJfHGgRvKqEzDZPOwBV+JFPQEnTCGgLCgYXVwGMRsjBskmZ0oEtcsLOTmKC3MQB3yK34yz69P4WdpZGoow5L1oj+E2/UdBwlwDflszgoxVKM3gx5O+u4hr4ygu39r8vIuc/r4mmh61kZWdreVS+Vbquw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2 Feb 2026 14:56:47 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> * Support for huge pages collapse, which will be used by
>   dynamic_hugepages module.
> 
> * Include the new module for compilation
> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
> ---
>  include/linux/damon.h | 1 +
>  mm/damon/Kconfig      | 7 +++++++
>  mm/damon/Makefile     | 1 +
>  mm/damon/vaddr.c      | 3 +++
>  4 files changed, 12 insertions(+)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 3813373a9200..de5a994f92c2 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -142,6 +142,7 @@ enum damos_action {
>  	DAMOS_LRU_DEPRIO,
>  	DAMOS_MIGRATE_HOT,
>  	DAMOS_MIGRATE_COLD,
> +	DAMOS_COLLAPSE,

Please update the kernel-doc comments for this new action, by the time you drop
the RFC tag from this patch series.

>  	DAMOS_STAT,		/* Do nothing but only record the stat */
>  	NR_DAMOS_ACTIONS,
>  };
> diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
> index 8c868f7035fc..2355aacb6d12 100644
> --- a/mm/damon/Kconfig
> +++ b/mm/damon/Kconfig
> @@ -110,4 +110,11 @@ config DAMON_STAT_ENABLED_DEFAULT
>  	  Whether to enable DAMON_STAT by default.  Users can disable it in
>  	  boot or runtime using its 'enabled' parameter.
>  
> +config DAMON_HOT_HUGEPAGE
> +	bool "Build DAMON-based collapse of hot regions (DAMON_HOT_HUGEPAGES)"
> +	depends on DAMON_VADDR
> +	help
> +	 Collapse hot region into huge pages. Hot regions are determined by
> +	 DAMON-based sampling
> +

Apparently you wanted to introduce the above change on the next patch, but
mistakenly added here?

I'm also feeling the name might be better to be simpler.  What about... say,
just DAMON_HUGEPAGE?  We might want to extend that for general access-aware
huge pages.

>  endmenu
> diff --git a/mm/damon/Makefile b/mm/damon/Makefile
> index d8d6bf5f8bff..998bddc17819 100644
> --- a/mm/damon/Makefile
> +++ b/mm/damon/Makefile
> @@ -7,3 +7,4 @@ obj-$(CONFIG_DAMON_SYSFS)	+= sysfs-common.o sysfs-schemes.o sysfs.o
>  obj-$(CONFIG_DAMON_RECLAIM)	+= modules-common.o reclaim.o
>  obj-$(CONFIG_DAMON_LRU_SORT)	+= modules-common.o lru_sort.o
>  obj-$(CONFIG_DAMON_STAT)	+= modules-common.o stat.o
> +obj-$(CONFIG_DAMON_HOT_HUGEPAGE)	+= modules-common.o dynamic_hugepages.o

Ditto.

> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index 23ed738a0bd6..4acbc1a6a5be 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -970,6 +970,9 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
>  	case DAMOS_NOHUGEPAGE:
>  		madv_action = MADV_NOHUGEPAGE;
>  		break;
> +	case DAMOS_COLLAPSE:
> +		madv_action = MADV_COLLAPSE;
> +		break;
>  	case DAMOS_MIGRATE_HOT:
>  	case DAMOS_MIGRATE_COLD:
>  		return damos_va_migrate(t, r, scheme, sz_filter_passed);
> -- 
> 2.43.0


Thanks,
SJ

[...]

