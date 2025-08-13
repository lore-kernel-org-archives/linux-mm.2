Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 852EECA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 17:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23DA79000B5; Wed, 13 Aug 2025 13:10:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 214DE900088; Wed, 13 Aug 2025 13:10:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 152289000B5; Wed, 13 Aug 2025 13:10:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 04012900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:10:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AEB83C0463
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:10:04 +0000 (UTC)
X-FDA: 83772371928.17.D80F9F1
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1B667A0003
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:10:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BTlViCzK;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755105003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DPtrsXvcL18zFRU+ZDu0oZhqiEC4smJeRTSbjhOcFjU=;
	b=H5V6Pn4C3LRORDjFJw1uNW6Ject9gkTnjTLoaPjqcVUJnltMBXLqDnn1YkRYr0foVYH6RH
	ZXVd1y/EiyxkNuhXeiXlx4bDbI+b8AfWUtXPcDcJbDvqY5UsdZzh3ZgJ0JTEdjJJPd9GA3
	iQYsrAD4YeH5/b+9GnBfRRUv6WruZR4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BTlViCzK;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755105003; a=rsa-sha256;
	cv=none;
	b=A2jAe7+NUwBBKjlTINPu5fc30vUZPHZvQwns+IiYm3smlwgQCnkXhxp+Cwa+Ls5AATt/rt
	wk6NZw4tkv0WdSdKR9jdjGKtBBwSJaCfbadbA0s8s/omUH56qS43mMw7iwnjYoOt1Rah8o
	tLVaOW6tMmjXPEHSCfRaEQmtCNdgUCE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 7D035A57ED3;
	Wed, 13 Aug 2025 17:10:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1832C4CEEB;
	Wed, 13 Aug 2025 17:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755105002;
	bh=AIWgF14roG2s1lL3N6s+OU/JIDgn+6qzvLO1PUr65lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTlViCzKJ6oNXqiiP+yf5NnjgQaXzeC5n6P9xOPggqWpoRaHlwaDI1mvW60w31f7z
	 Nk4wYDNWeQJqTf13oWXlarIYS4G7HXdpOctnUB5iWisAC9T5iXxijFqW5GDfRGiyln
	 0aar22OgoB+SxaiV6DVGdHOrsuCSOKwnlhkkWCTlavbdrKC+1E7kS8qppE0a4h+kfL
	 h396yxnoXzknUv6pnRL70DK2zY7o4hxelhQfm4s71BW2VoykC6HcM0DB7+QZ0KvKJH
	 YWjrJ/xKIpVm2cugUJElax/DsAw1ksJ5mjDQdz+mXtGuc4c0PUVtl+M00Dzoj2+q7T
	 qSWYD33zElEoA==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH -next 15/16] mm/damon: the byte statistics data type in damos_stat uses unsigned long long
Date: Wed, 13 Aug 2025 10:10:00 -0700
Message-Id: <20250813171000.6345-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250813050706.1564229-16-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1B667A0003
X-Rspam-User: 
X-Stat-Signature: g161brknz9qx7yzpkxdwahm66bbe9uz8
X-Rspamd-Server: rspam09
X-HE-Tag: 1755105002-145767
X-HE-Meta: U2FsdGVkX1/VyIvkd8EBW7lXdYmqL1lBb5vkhiTmscf4WphTQcyTZ3A+rm2dqfbrjoHPFFBWrJFzsQhyNvU631QoLOMD35/b81evFkiwEQ7DPi3MNpLcgp//N8M/K7azkAmOcxUwmy923dy9I1MGj9G0ldFIowqRzQdbOxE/GkueeJlUMqL1t+bYtlUwslTTic3AsN2Q1MWv8KMX41qIUmzk965Omr20eu8zv/pFwLfeQiV2LsI8r4fKl4szLeL9wc15LRAr5R+RQ26kQk/kwZBm0bmnF9TrMG9WyY2WMjjZFlhN61v60y89Ob4Enw9hjPcV1GEKzwPSirj+3jJkfug62VB9YFQ8ypkjGoE5Ml+hoZC3oLmrfuZAS25gzRJcv08V4fqm3QpU9fiVwpAJjrhbqCVoEgk9qwRVQy/PCUE4XkoOzDkgFh7OVILhrjO6RbtUTIoI+wwiNBbMVH2UwboHxclZDsGEa3zb4GB0BH8s8XD1jBW7AqVJYcbPD5+x9X0aL2rKkPj54sfAJNI/OJ3wL4eWkamLyFfG04SbFjiZJlfDqGKuCvg9pyDKgNOn+REtABMfcIKbLlOrSysMk+Jo9p0DKmp1cF1tebwMumipPc7jn1XRS5EUP2h2YY8ONzLB0/H3QLWog+/ruw3JRkknxVUzltoToXZpc8z7PmEKreNG8/bMhlEcAOAGOe3WpKyl49pM1yy58e6l5WCDgWU1Ak/1F2bXeW5JdG+X1UwxIROsAPKBgD7NsACiHTr906oQJr7yNMu+TqO0G5eDhMJUSH4DIC5/4svP24gfp7ackhh9q3aQHSM7ctGdGFy0Gb4wkSSqDX74kwp+zxXAepHVW9CdWtRlV6P+DZ/LTx2E6wM/npWm5VPSK8Xv6PBAoicjiKTzFBPX/Gkm5bY1NEtmPoVEgIoV4Y4KzZT61t1WWpVZZzv4IeLmdLWw7rhHt5WTmv258B4Ia8nG+zs
 3tVPK6ph
 Oe6XcGuky7tdgJ2eiPxMCVrAZpKtWcGI7GlmfhUwbieiIQxfde/A62p/CCdWMiMNayN3c2odU2uY/5cqvq/NGAy2XsFgQr5HZx45/SPYd6l9ZzJdIUrXmSfXWsOhpq6b1Qdltvbpk6nnd0Ceipg9xR3UP+YJDF8BwzatDdzjoYajFzYMpfk9BgotQhL4fhN6y0KMJu7Za2Qp+yjGdFgtJF1BsK9IL9lmBnLDFuLGiSzH3dYs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 Aug 2025 13:07:05 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> For 32-bit systems, damos_stat now uses unsigned long long for byte
> statistics data to avoid integer overflow risks inherent in the
> previous design.

I suggested using the core-layer address unit on stat, and ask users to
multiply the addr_unit value to stat values if they want bytes value.  If we
agree on it, I think this patch wouldn't really be required.

> 
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
> ---
>  include/linux/damon.h     |  6 +++---
>  mm/damon/modules-common.h |  4 ++--
>  mm/damon/sysfs-schemes.c  | 12 ++++++------
>  3 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index aa045dcb5b5d..d85850cf06c5 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -333,10 +333,10 @@ struct damos_watermarks {
>   */
>  struct damos_stat {
>  	unsigned long nr_tried;
> -	unsigned long sz_tried;
> +	unsigned long long sz_tried;
>  	unsigned long nr_applied;
> -	unsigned long sz_applied;
> -	unsigned long sz_ops_filter_passed;
> +	unsigned long long sz_applied;
> +	unsigned long long sz_ops_filter_passed;
>  	unsigned long qt_exceeds;
>  };
>  
> diff --git a/mm/damon/modules-common.h b/mm/damon/modules-common.h
> index c7048a449321..ae45d0eb960e 100644
> --- a/mm/damon/modules-common.h
> +++ b/mm/damon/modules-common.h
> @@ -36,11 +36,11 @@
>  #define DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(stat, try_name,		\
>  		succ_name, qt_exceed_name)				\
>  	module_param_named(nr_##try_name, stat.nr_tried, ulong, 0400);	\
> -	module_param_named(bytes_##try_name, stat.sz_tried, ulong,	\
> +	module_param_named(bytes_##try_name, stat.sz_tried, ullong,	\
>  			0400);						\
>  	module_param_named(nr_##succ_name, stat.nr_applied, ulong,	\
>  			0400);						\
> -	module_param_named(bytes_##succ_name, stat.sz_applied, ulong,	\
> +	module_param_named(bytes_##succ_name, stat.sz_applied, ullong,	\
>  			0400);						\
>  	module_param_named(nr_##qt_exceed_name, stat.qt_exceeds, ulong,	\
>  			0400);
> diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> index 74056bcd6a2c..3c4882549a28 100644
> --- a/mm/damon/sysfs-schemes.c
> +++ b/mm/damon/sysfs-schemes.c
> @@ -199,10 +199,10 @@ static const struct kobj_type damon_sysfs_scheme_regions_ktype = {
>  struct damon_sysfs_stats {
>  	struct kobject kobj;
>  	unsigned long nr_tried;
> -	unsigned long sz_tried;
> +	unsigned long long sz_tried;
>  	unsigned long nr_applied;
> -	unsigned long sz_applied;
> -	unsigned long sz_ops_filter_passed;
> +	unsigned long long sz_applied;
> +	unsigned long long sz_ops_filter_passed;
>  	unsigned long qt_exceeds;
>  };
>  
> @@ -226,7 +226,7 @@ static ssize_t sz_tried_show(struct kobject *kobj, struct kobj_attribute *attr,
>  	struct damon_sysfs_stats *stats = container_of(kobj,
>  			struct damon_sysfs_stats, kobj);
>  
> -	return sysfs_emit(buf, "%lu\n", stats->sz_tried);
> +	return sysfs_emit(buf, "%llu\n", stats->sz_tried);
>  }
>  
>  static ssize_t nr_applied_show(struct kobject *kobj,
> @@ -244,7 +244,7 @@ static ssize_t sz_applied_show(struct kobject *kobj,
>  	struct damon_sysfs_stats *stats = container_of(kobj,
>  			struct damon_sysfs_stats, kobj);
>  
> -	return sysfs_emit(buf, "%lu\n", stats->sz_applied);
> +	return sysfs_emit(buf, "%llu\n", stats->sz_applied);
>  }
>  
>  static ssize_t sz_ops_filter_passed_show(struct kobject *kobj,
> @@ -253,7 +253,7 @@ static ssize_t sz_ops_filter_passed_show(struct kobject *kobj,
>  	struct damon_sysfs_stats *stats = container_of(kobj,
>  			struct damon_sysfs_stats, kobj);
>  
> -	return sysfs_emit(buf, "%lu\n", stats->sz_ops_filter_passed);
> +	return sysfs_emit(buf, "%llu\n", stats->sz_ops_filter_passed);
>  }
>  
>  static ssize_t qt_exceeds_show(struct kobject *kobj,
> -- 
> 2.34.1

