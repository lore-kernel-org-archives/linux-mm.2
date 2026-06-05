Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BFB2CD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 11:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 673FB6B0092; Fri,  5 Jun 2026 07:13:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6252B6B0093; Fri,  5 Jun 2026 07:13:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53B0F6B0095; Fri,  5 Jun 2026 07:13:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 447FA6B0092
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:13:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D925A8E13B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:13:12 +0000 (UTC)
X-FDA: 84845597424.21.E08D781
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf22.hostedemail.com (Postfix) with ESMTP id CA67BC0008
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:13:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780657991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/QEsQwTfrJ80Yu9q+iUcuaiZpy77wKLkBx4OjYCnhu4=;
	b=CvkxGE6B/lcrl6VpG6LebCTJq1ZxvwsN1q9TxF0sKLrkGClc5fHdAaxfPnj/zUSxLOYXF8
	Hc8nmc9Fk+Rsbc4I6LdYrhr/XHZp6ALQ9b02+lHrNrIvk6OqXv5XbOb7FFy/nhpScd8k8h
	SeWMH6WBeEzS5ViMKjb97/wRqAzK+v4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780657991;
	b=4Kw/MDdD7QhioSjz+1HtWzfOj6MKhrlbqtCWh07CWC4MJIdmdobyCzAX4R6n5c5L/N8qo2
	1L1pgkpA9I+69siN1jHxfeAeYEbhWPKW9jFgGyZzRd5vDeCCxYlWW7tGEPK70qg4BmQygv
	vr5r6CxI3NvU18Pv4VZjZwN9H2umiIg=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gWzKg3MtBzHnGkZ;
	Fri,  5 Jun 2026 19:12:07 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id D09B740584;
	Fri,  5 Jun 2026 19:13:02 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 5 Jun 2026 14:13:02 +0300
Message-ID: <a9269eaf-a567-4dfe-99a3-cee4b13946de@huawei-partners.com>
Date: Fri, 5 Jun 2026 14:13:01 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 2/4] mm/damon: Generalize ctx_target creation for
 damon_ops_id and add vaddr support
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260605005023.82747-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260605005023.82747-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CA67BC0008
X-Stat-Signature: phgiixnwrr8zxbtahg6abgxoxxt5s1wt
X-Rspam-User: 
X-HE-Tag: 1780657988-95527
X-HE-Meta: U2FsdGVkX1+n6M3bH0e5ey5HC5WAAchY4VMypvBV/FJVSsPNyIxotQ1MtwkbT3HHNfI44TCTOqlO2DiZKLZbX2kZwkYxYCWNN67xyoJRY5O02ZOwNzWSAVdr375CsghOxcFt0rcIwudTgsD1HtkCpX8qwMAoIuJ2wM0ZMegJxvbHHg8KMbAr5z4FiZJF6jLcUvvLvpqS0XMTTAx4KEWVaFYHUVN9UJxKtRl46KOjILw1WgQEUZ+22QZK5swgqPMLpsMDQrhwcjKJ1rhQK/cHLf+uZaqPRei3D+wrueiT8AkSSnbFhX3W8UpR5c/QbawQfGT9xxvmlBla5I6N12ByQWGlRAuSyOInxDxmUcim2iMaQDnyzOaFxb7qTjaRKyI8BuXlGxS5IfQkmNpD+pt7GU8sEbUz5Xbh9Ll08DQqu5JwqrqyRP7Te9Dp2uQ3TJtfUZB8CXd8gSMkyVUciTKpyajIcvd/ubh6w17ZZofPoQew4ngwTC7+aVQ5wUTCyxxvJ7T99REZaGLgOcE2OwCRMg6mFVhJ8kfVOAE+0S87lFiAawyPuYPNiaTpemQvI0tGfKk1r4J9jempMqYc5Tlux8Bz0UbSCi0zKi4cKf7e0oEI3ZU6dtABLXbQNDRJlYNU37fuZh1foU8RPmiuU3ekF9j9a+CoXZXvUSxaltqDZhS8eMCs9UsIdd+iCsC5zmq18kl9sYCpwA6XQn+pM8e1sDPZEB2SLsvCdmYrLR8cwr84wsp7RHrcafoUoOsQtC+S+1pmTswY3bqTGh5CDIBqv2NE9s8fpR4JdM7ITNphfX0tNuKFGZkgtZxI3G4dyGX5QPFWpYASGCfZj905rdYigeLcXadVFfqPSmdeKDrPZE7Ut6wmNauhWTTZJ6s6rPf98gppZSuMNoUeTYZKvSta7PQ3EW+5bkZCTyY4Rn1m7m2CYAP0JweLhc0HdDveeP3pb4Gw5m9ml3dQ/aY8jWL
 F/7e2HbW
 55+pzHCaJXPZpHg/tMeQhUyHdGDBB1RfBRWlWH78N/Y5WWzoT0k7QvPiunCcRBwIsp8J9AfqxkqNiUYhn+fqVW27ZKZJ0REYJLyBuEN0YakmGFuRgJW2j1uAc+rSZruh7MXPXJAsW2bxBXgNBFIHchzVq+DUsRglEsXYD+smXefRsxgV84/ZNZfGMrubguCnj16cQ0mKFaASTeF7up5vBHpn7nNE7joV/bvA813eksl8IVq38/0QiNpCMWbdCTVId0KwrFMiLb3tZT0gUygVdnGPDYKmDAQTlOGQdJJE0K8LJmMNe0gqntpF6TZfGftNPvGEkbBddgBPUWbg0wfuvdat/NTbgQ0G6Sv+4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/5/2026 3:50 AM, SeongJae Park wrote:
> On Thu, 4 Jun 2026 15:03:35 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> This patch adds a new function damon_modules_new_vaddr_ctx_target.
>> Since ctx_target creation for vaddr and paddr is almost
>> identical, the logic is extracted to a new function,
>> damon_modules_new_ctx_target, and vaddr and paddr functions
>> are left just as interfaces.
>>
>> This change was suggested earlier1 and it is needed to allow
>> developers to create DAMON modules that use DAMON_OPS_VADDR targets.
>>
>> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>> Suggested-by: SeongJae Park <sj@kernel.org>
>> ---
>>  mm/damon/modules-common.c | 31 +++++++++++++++++++++++++++----
>>  mm/damon/modules-common.h |  3 +++
>>  2 files changed, 30 insertions(+), 4 deletions(-)
> 
> This change is for the sample module that will be introduced by the third patch
> of this series, right?
> 
> I'd like sample modules to be simple and completely isolated under sample/
> directory.  Is this change really required for the sammple directory?  If not,
> could we please drop this patch?
So, just create the context manually in the module without a new
damon_modules_new_vaddr_ctx_target interface?> 
> Thanks,
> SJ
> 
> [...]
> 

-- 
Asier Gutierrez
Huawei


