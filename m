Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22943CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 14:18:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B62646B00AB; Tue, 19 Aug 2025 10:18:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9C5B6B00AC; Tue, 19 Aug 2025 10:18:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D99F6B00B2; Tue, 19 Aug 2025 10:18:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BA716B00AB
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:18:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 349EA1A0423
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:18:25 +0000 (UTC)
X-FDA: 83793712170.08.2FB93B5
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf24.hostedemail.com (Postfix) with ESMTP id B735118000A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:18:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755613103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=smkfy8Ud89SAAYk5zqCqdxT/mtVR3MAt1Cih26ndZao=;
	b=3B3kUQ8aukbrDX2gg+lPF8oF6iocBQ9e9+Ex5KR8gDHoqsov/EAThRXxQMy6KCz8t50Xk9
	ajj++GBo4W0rkO+oHkDsKWoRvsoYsc3sTaIObItQLAqGB3KJXQZCPZIMEEd+rJaTByyAmW
	vEf2pCup4B93y9CKyIgsUIDJ806Ba5Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755613103; a=rsa-sha256;
	cv=none;
	b=Sayqw36K7rD7RLy3VgtY6jANCYPFHSOFLiuEQwRKNJxOYkCftZ0skCsQoB5ur2MuF4BdOM
	69YIEPN/2MfFFVqIX5I1ZWd3VYw1bk2cQCiu8hS4caiB+5k1yUW4W4hLcnkXmKVON0WQAz
	07yGFddvQV4E1KfZ+nDlhw0TGDk5Qgw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c5s6q3Kjwz2gLBM;
	Tue, 19 Aug 2025 22:15:15 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 36E1E140120;
	Tue, 19 Aug 2025 22:18:08 +0800 (CST)
Received: from [10.174.176.250] (10.174.176.250) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 19 Aug 2025 22:18:07 +0800
Message-ID: <6b9baf0c-fdc2-4f16-84f7-c4ada507f8f1@huawei.com>
Date: Tue, 19 Aug 2025 22:18:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH -next 03/16] mm/damon/paddr: support addr_unit for
 DAMOS_PAGEOUT
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
References: <20250819062613.39988-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20250819062613.39988-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.250]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B735118000A
X-Stat-Signature: 844ifq1m6cgumzmzxgfxabyqthizrc8h
X-HE-Tag: 1755613101-959849
X-HE-Meta: U2FsdGVkX1+XNAjA/jnTOcgqRNoK8KdPt096iiM6q4cr9DJeYb0oVsQO+4L9h66JOYADX37IXZCf4vUcYUpF08xt3zZTyKgjRj8GKDQG9hu0OfLb3klD8RKXkFkOTABsbkF9kxusxFd5lIHylDv0Znl0zbeYJzwmTnXH7ORYI1Z6ek9j9GFNBHErxSyCj1aU6dymn4AULm9tQIXv5+4oUTAVeNUNGEZCK5Q1cy1ncCQ7mYKzdR9ailrMP9aVcMzN5D5NUhSxkRV7RqGzyoHpKvyDUMpjKRcTOlUHChzm/gZVflbX9XZ3V9ATGu1LfmvwfmJ89htfYE0QjCbBNiS2r9IKbXDWz6UHvVwXeLcPasjlAoqn6yAkrxrYipDr8OB2VQpplPixO7UEwBBXM12ajtDy2gc1sakmCtikautEfOJWupeEzjTZdq1/o1v9a0siluP8QBXsY+VpTb+sHKT+vGbnKN5qw4aUy5Gi5eev/yIk1S6RHUZsBVgn7GBLiMH/ojcuQDGgW5Oo0O66eUdrWbMdt1oBUVJSCl3Z8yn8K/Ofyw9P7KrIsv/sAOr07m4EAew39yiu3UHgaYbbWvHPSZPGY7N5r5ciP1Yc66icDD42+XNQq9H8uYD4GOJsFTCMMXuvhTE+7swGl5uuPbUpWtOVmA+uGk/40B2ZkbJAZ23gbUjSCdaH5IIfNWBuMOxndIybUE8DWY4foX+fdua3+o/duRLLCjwKQ0QDwdtnKibItYsKxmx1cEuQhmFzMT2mW9Xw4AchdA96r9D0gWC4KW7t9VW9tIIDCKIixd7Vy2URp/v5Crhvb8PWSzOtnnOSpV3Cfo70g0I7ZRM21PIG3Z3W5v1nKO0AkqskeSAjpWde65fZD9ka2GWzzLb1n3J26lpfXfwqBUWEd6NDpPuITIyfY4qN+rSyI4jZC/2GHeFtWMZ4Na3fVIQbyz9WNHuzW/biXQwySb8HSMMFOfe
 zY42rHgs
 MZnnegUboSXrYdOxkaDQo884PY8R9wT+J7nI/Orbdqyq5FrHJ6ZeGSAFZWpLeDVgKUU4Hs4Vld+6ZITANdPfW6J5djVJGxAihN6bmT6aE+jsjgkMG8/AJwwaWg3PZXdM5GsA0Gh44xu7K+DU0IH4vpJ9repwX8o7lRZVIKjfQkJp4TMGf291U3KbHex1vrU2JtNQJMIGpuEmXJbE/xS2W3OMZ0VKfRyDBKQZGx177wLqjPMAzNMg37LTzK3jBpUfB5Kd40wq5cf84rWWXE9a8G3d04IHAwTuDFml+2poLjW0xx6Crayc8zox3WntvxsiahGJ5ujRcgPlDGFY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

在 2025/8/19 14:26, SeongJae Park 写道:
> Sorry for the above wrong link.  Plese use
> https://lore.kernel.org/20250813170806.6251-1-sj@kernel.org instead.

Okay, I've merged the corresponding changes into the original patches. So now we have v2 versions
for patches 3, 4, 5, and 6. I'll send out the patches later. That understanding is correct, right?

Thanks,
Quanmin Yan


