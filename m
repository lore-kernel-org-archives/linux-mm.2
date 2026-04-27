Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83253FF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 13:24:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F15676B0088; Mon, 27 Apr 2026 09:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEC586B008C; Mon, 27 Apr 2026 09:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E295F6B0092; Mon, 27 Apr 2026 09:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D121C6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:24:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A30E1A0176
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:24:15 +0000 (UTC)
X-FDA: 84704404470.02.85E0555
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6FB36140009
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:24:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf09.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777296253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VeLzrXJeO6zEBT2IRSgMl1DDUMZlXaagPzcAWHa4OcQ=;
	b=l2h7svH1gy5RExaoDdDn1A7jIf9Y31d3mB8ipcRrWeTM08m4hP0gzx6zahThwQ/j/QW02d
	LLJXrzjYGKa3nzTc6/TS5EM2lolHRDWsO2J5+LPWXFKrde//8ihSWH+YwGxJ9CmSHMvCc2
	YeNACDGgAsCZmuMAOBqObVQRvM7Y7K4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777296253; a=rsa-sha256;
	cv=none;
	b=Qrm17j7IHAPCTsAEiVEvWw2kyZ4d0UF5bscc+YHnqKDAzKI4EwaR49bhDPSPzsvTNQhoXr
	yjU7AXS8AI1PtS4i1zl7FX+Y7gqzaMQhaDuRSfC8o64kpjCBAyf+AeEgRX7BB0ocNWNc9R
	nj6IqTMcKNNdtCjWvW9fGhnCI66wEwc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf09.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4g445H6DRxzHnGkb;
	Mon, 27 Apr 2026 21:23:31 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id BAE934058C;
	Mon, 27 Apr 2026 21:24:11 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 27 Apr 2026 16:24:11 +0300
Message-ID: <666090aa-a679-4ce4-b66a-a5bba8284268@huawei-partners.com>
Date: Mon, 27 Apr 2026 16:24:10 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] mm/damon/sysfs: implement filter dir files
To: SeongJae Park <sj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260426205222.93895-1-sj@kernel.org>
 <20260426205222.93895-14-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260426205222.93895-14-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Queue-Id: 6FB36140009
X-Rspamd-Server: rspam04
X-Stat-Signature: zspuk8uy6qf5bhcr5ufsnkes1gxgtqhe
X-HE-Tag: 1777296253-674509
X-HE-Meta: U2FsdGVkX1/zjPJ666q129OAQF2wf0tZ2rUssOY91Te6Stukq38+zPtRQhsU7mo29pMCQeVlJgHo6P/xURapsCzj7RvFQmc3iolivAXQ4AJhQvB0HO/CNdyOcLH+VgcVNJ0KXNedSC4cxjaC96OaykFNiUIl6/zKM6w4B2dM4fdPFli79Z3q/Um/jCOa7HDMOQodPjc7Xt80b+/Xp22ChVxzSjLhwJNba+dk1vA+tpM1i3tQi3YNKVzVmB6A60nTyvhzDc59EeTOqIgGuXQHFvmLH/nWnkl6JbcUUIfizNlwY131wqjsnbaGFURoSlt61CIBczdfwksLc9wr3PsuIbPOEMVtK3Yyk5ByT7C+8RzHi2j04yt2wlGYaZTh/WS3G3Ad0GUqtrey5Eplq2DsWhoUrctW3u6HGM4R2V0cVHrlP9VIzG8bgfFxnofdjkxePWZW8z11AxVYgOZK/7fsC08A9Rx3XnXSNsL86tipMxNXZdgHrLePWc9MjKHuqlUiofEjZI8iSx2LLxYHLYjPE6/qQxz70vFSdYd+aPzJNWLTKl2nxYTGutFRm4mAbUJsjkzqzogSiZf4iQw+IBSHYBuy28SMj7hP4f8fPtWSZ75dqikGHzFA0WAEqnp80CnO2bYHiSjKMvNzk5/Lr0EtSwD3NgCziHMWhHEc31/DQw6SuAi5e+KeSKPHH2T7AzY4TNnY44BOlSiNCIiZbUaLiOKt5SyW6P1DnhOhJ+wvsr7CSqQnGHg0TWtVUDhPi1MnS94zX+yTdGcNt2i1khNJzQrn0g1quAc6jfsO+5W+jkEFjQ8eguDxOqGOLHvbP3sydc/EY/ppiNA2eiUczLPNWCHslsHvVya3r1r8cs+rS3+xKdYXeaxPZSCjCxAU5J9/s2xWSOM0Kf/WXS5zJj1l15CqxlZturJLicjWnHXGzJ26HggXh8KU2DttIRF5wl3zUFrg1TbiPQMQ44ACJ92
 G8JIsNcZ
 9o+/pRAyjZ0TRj0rgJztiHgL4G/+bomYLoVZW4qf2l0nBuheC97qRdutOFBx2D+nIShhIA1/DWk3//zO+y1/AuTKjS5n3/5swHFmiQBt+syGIKpX3t4RUByLStHou5HK2jZcaix4a403k8McPxjTuwRRBK5qAW6jf00WYP0fZOQAx4PDuQTqXBBRbDRC8Yys/3eRqZJxFpp9wiygFOgg09/hREVXudOl9J2/yrHjoOpaIvK3t0YD1Yr8psWk/XKnOgLBU1nCQiuH/1ClMOnx+94RQBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/26/2026 11:52 PM, SeongJae Park wrote:
> Implement sysfs files under the data probe filter directory for letting
> users to configure each filter.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/sysfs.c | 114 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 114 insertions(+)
> 
> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> index 25487a0268cbe..2e0b7eca6bcbf 100644
> --- a/mm/damon/sysfs.c
> +++ b/mm/damon/sysfs.c
> @@ -753,6 +753,9 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
>  
>  struct damon_sysfs_filter {
>  	struct kobject kobj;
> +	enum damon_filter_type type;
> +	bool matching;
> +	bool allow;
>  };
>  
>  static struct damon_sysfs_filter *damon_sysfs_filter_alloc(void)
> @@ -760,6 +763,105 @@ static struct damon_sysfs_filter *damon_sysfs_filter_alloc(void)
>  	return kzalloc_obj(struct damon_sysfs_filter);
>  }
>  
> +struct damon_sysfs_filter_type_name {
> +	enum damon_filter_type type;
> +	char *name;
> +};
> +
> +static const struct damon_sysfs_filter_type_name
> +damon_sysfs_filter_type_names[] = {
> +	{
> +		.type = DAMON_TEST_TYPE_ANON,
> +		.name = "anon",
> +	},
> +};
> +
> +static ssize_t type_show(struct kobject *kobj,
> +		struct kobj_attribute *attr, char *buf)
> +{
> +	struct damon_sysfs_filter *filter = container_of(kobj,
> +			struct damon_sysfs_filter, kobj);
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(damon_sysfs_filter_type_names); i++) {
> +		const struct damon_sysfs_filter_type_name *type_name;
Can we move this declaration to the top of the function?
> +
> +		type_name = &damon_sysfs_filter_type_names[i];
> +		if (type_name->type == filter->type)
> +			return sysfs_emit(buf, "%s\n", type_name->name);
> +	}
> +	return -EINVAL;
> +}
> +
> +static ssize_t type_store(struct kobject *kobj,
> +		struct kobj_attribute *attr, const char *buf, size_t count)
> +{
> +	struct damon_sysfs_filter *filter = container_of(kobj,
> +			struct damon_sysfs_filter, kobj);
> +	ssize_t ret = -EINVAL;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(damon_sysfs_filter_type_names); i++) {
> +		const struct damon_sysfs_filter_type_name *type_name;
Same
> +
> +		type_name = &damon_sysfs_filter_type_names[i];
> +		if (sysfs_streq(buf, type_name->name)) {
> +			filter->type = type_name->type;
> +			ret = count;
> +			break;
> +		}
> +	}
> +	return ret;
> +}
> +
> +static ssize_t matching_show(struct kobject *kobj,
> +		struct kobj_attribute *attr, char *buf)
> +{
> +	struct damon_sysfs_filter *filter = container_of(kobj,
> +			struct damon_sysfs_filter, kobj);
> +
> +	return sysfs_emit(buf, "%c\n", filter->matching ? 'Y' : 'N');
> +}
> +
> +static ssize_t matching_store(struct kobject *kobj,
> +		struct kobj_attribute *attr, const char *buf, size_t count)
> +{
> +	struct damon_sysfs_filter *filter = container_of(kobj,
> +			struct damon_sysfs_filter, kobj);
> +	bool matching;
> +	int err = kstrtobool(buf, &matching);
> +
> +	if (err)
> +		return err;
> +
> +	filter->matching = matching;
> +	return count;
> +}
> +
> +static ssize_t allow_show(struct kobject *kobj,
> +		struct kobj_attribute *attr, char *buf)
> +{
> +	struct damon_sysfs_filter *filter = container_of(kobj,
> +			struct damon_sysfs_filter, kobj);
> +
> +	return sysfs_emit(buf, "%c\n", filter->allow ? 'Y' : 'N');
> +}
> +
> +static ssize_t allow_store(struct kobject *kobj,
> +		struct kobj_attribute *attr, const char *buf, size_t count)
> +{
> +	struct damon_sysfs_filter *filter = container_of(kobj,
> +			struct damon_sysfs_filter, kobj);
> +	bool allow;
> +	int err = kstrtobool(buf, &allow);
> +
> +	if (err)
> +		return err;
> +
> +	filter->allow = allow;
> +	return count;
> +}
> +
>  static void damon_sysfs_filter_release(struct kobject *kobj)
>  {
>  	struct damon_sysfs_filter *filter = container_of(kobj,
> @@ -768,7 +870,19 @@ static void damon_sysfs_filter_release(struct kobject *kobj)
>  	kfree(filter);
>  }
>  
> +static struct kobj_attribute damon_sysfs_filter_type_attr =
> +		__ATTR_RW_MODE(type, 0600);
> +
> +static struct kobj_attribute damon_sysfs_filter_matching_attr =
> +		__ATTR_RW_MODE(matching, 0600);
> +
> +static struct kobj_attribute damon_sysfs_filter_allow_attr =
> +		__ATTR_RW_MODE(allow, 0600);
> +
>  static struct attribute *damon_sysfs_filter_attrs[] = {
> +	&damon_sysfs_filter_type_attr.attr,
> +	&damon_sysfs_filter_matching_attr.attr,
> +	&damon_sysfs_filter_allow_attr.attr,
>  	NULL,
>  };
>  ATTRIBUTE_GROUPS(damon_sysfs_filter);

-- 
Asier Gutierrez
Huawei


