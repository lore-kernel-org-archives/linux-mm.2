Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB107EB7EB6
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 10:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DA7F6B0089; Wed,  4 Mar 2026 05:18:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 191E26B008A; Wed,  4 Mar 2026 05:18:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BEB36B008C; Wed,  4 Mar 2026 05:18:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F27606B0089
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 05:18:20 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BD89F140533
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:18:20 +0000 (UTC)
X-FDA: 84507980760.15.EB4509E
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf15.hostedemail.com (Postfix) with ESMTP id CE617A0011
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:18:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772619499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BvAsnVsTzGL+Lbxzk58rZ15ekcyNylK37i3XldSufhM=;
	b=aTtI1mjXPPMh6K5z4CHoFTOtS9ywDlaJB34h3CH3peE4EAwrrTeEn019R/D6MniQQemS6D
	ZbcvhR2eOl/ikYgFC+3Kko/JQ3Fr92uW56IrgNIxt4f8GaCmZNNzngMLDRjspqhDSkBiSY
	VKVlgTBUnL09vSoQZS765MBRyyWd+I0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772619499; a=rsa-sha256;
	cv=none;
	b=xbDLTUlwZQ+NghAirYQnLjb14b9OG6WAvbLAGucnUS4yZyqjEovDznK6XUsv9jOong0B1j
	R0qSdUD57n1/aphNBrKVZB5lXAHWPZwXjEHcVfnsDEEJYqKcwDyXFzflIldICMh/vsxjQX
	IS1B/qyqbxupflKKKWALAnVZvq8kFck=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fQpWP5v7jzHnHGQ;
	Wed,  4 Mar 2026 18:17:21 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 5AA2D40569;
	Wed,  4 Mar 2026 18:18:17 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Mar 2026 13:18:16 +0300
Message-ID: <abdb1acc-5f88-483f-af49-45276ab66ff0@huawei-partners.com>
Date: Wed, 4 Mar 2026 13:18:16 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 02/10] mm/damon/core: allow quota goals set zero
 effective size quota
To: SeongJae Park <sj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260304044122.79394-1-sj@kernel.org>
 <20260304044122.79394-3-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260304044122.79394-3-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: hk3ys9oxo55uc6nuwepkpiitr67y8t7u
X-Rspam-User: 
X-Rspamd-Queue-Id: CE617A0011
X-Rspamd-Server: rspam12
X-HE-Tag: 1772619498-519858
X-HE-Meta: U2FsdGVkX19RsPT+Yh8nQw9XamiVW0IAmEwnlFz6x5Uci2uujaBNDOhkFCjbbgIi809LZbp2eUx/yb4SviSJE/g1f0XVpQXxz5gvAQ3v+JEJFXyQy3YG4igV/lunD2S0mb1zwrEycIWEOdvlHNlcM7nnDQcGWBLTjrmrhHvxGdlOMQX2x4uDKsHm65z0rOPgvm8/ROQr0ARXlcsbzkACvi+f+zCyp3NJsa4lQyNPivax292StEj0S9P9GM7rasm/HZCJOLvedtz88m/eSBh7oF19gTVG74g9P+RgUUSqOk8wdQED1oHx4qlgQTJAYOkL/MOYt2iKjoihhj43eGHINj3WuoyZdAJOm4NixRq0Iw8VRl3E3GCSXhT3soCDswsd9D9/1SDWZ65eaLHZ5Hlvu6KqV1yI1UH1znu6tMUgMXxaGWf5vq6vN7xnM/y5dPnoJDC9Tb5em8bAlQ4yH2nULhb/seDsnxKeqGbr6zw2aAwWz9wYB+9LQQrh9L6+IUKaQINmT/1XQGPz3soidUXD8s8UMzQiiWB/0MOomqiBWbmxDpdeEG0JqgXCqfd9Ks4XVCp1PgcucYiZqpRnvEQvEgecoCegwhb4VPHLntDlgZjQxlAFCG7ro1/tfde357hPClZ8yWwt+FYVb9ixp04vT1tGNPJGfSO5YO7RLpmFO9rxP1m7UXhAZMyIW7sUXOs6DwQOklqcgQtRk2qnU4maUktS/KIUdTQzJY62zR1GMC/JMPbYsRj6xPTQGVlQ+kYUiKjqyiE4vWtVZZ9CFvFQioYVAVJ3YBAHgo0yjmIP7ZgUPBGD450Pchvsbga7RCJ38VqatM+0ESE7ignB5Cn1Du0t6/kphUCUMoaT0VKlShWz04sIu/ad+pBYfbK4t08bOWWxpPOM+IqOTAuAYOOvQsJ1MUOtoIqziBIkWJ2evp0oc8uqxVS2L89AaKqpoCa4kwjDulqK/ozuEDZO1TB
 IUAZFcw8
 H3640AbtEGvhyyCUpAYfyfWxRhyTlMvSoRLGUnF2tzl7r3BNXnjzgKuh78tprQAIJms0Nu+zGIhNZBGEqu8ghbCHD0JJc8Q8U3YacLdAwx8OFoh3Tu4QYC773CDVP08xf653q0niaXlF74Cx3NsHmxmrabWO34RyZzAvo70FV8YKAazhRZNuo4H0KhT7xHtg3jRDOgYEz3DNSMbDKl7w5gbxk65nVKH43LmT+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/4/2026 7:41 AM, SeongJae Park wrote:

I find the name of this function confusing. The function doesn't
actually set anything. Maybe better damos_quota_is_set()
> +/*
> + * damos_quota_set() - Return if the given quota is actually set.
> + * @quota:	The quota to check.
> + *
> + * Returns true if the quota is set, false otherwise.
> + */
> +static bool damos_quota_set(struct damos_quota *quota)
> +{
> +	return quota->esz || quota->sz || quota->ms ||
> +		!damos_quota_goals_empty(quota);
> +}
> +


-- 
Asier Gutierrez
Huawei


