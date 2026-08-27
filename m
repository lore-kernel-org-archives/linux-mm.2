Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1F59C5DF9D
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 08:38:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBA106B009E; Thu, 27 Aug 2026 04:38:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91CA6B009F; Thu, 27 Aug 2026 04:38:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD2286B00A0; Thu, 27 Aug 2026 04:38:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D08D6B009E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:38:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1DC07140390
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:38:26 +0000 (UTC)
X-FDA: 85146397812.22.6480BFA
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5A47020007
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:38:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MvfBY5uf;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787819904;
	b=51Wz1w3UdjWJ9l5t47RcfpjhE/UZmQUrAyi1Vnk4tP6Sw22AkFuUzTnQiuz+15SI1qUAMu
	KCQQ4ZQ5GpLrfJT1/aYyK4oXSPHgreVj08yqA2Q9YTF5EgvonoZk4AB2OMMJ6jK21S+RPp
	fu5dKY6IupNkDNO9BW94n49kOKpsC8Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787819904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S0b5mtUWJPOlKR5LLS2V3xdKfgJHqZzr0zXFS4YHIDs=;
	b=ok0Nvoz0+KM3jlgS5rG03svN0fyUeR/kbDL0CCQ2mS+gjnK85bsR3fPE8DRi5chCDQluEZ
	c/fwNF6O3FrMTFdvEUOhR0tkktF5UmJNg+H20Hy4qT231ik6SATR6gXDP4cuzPwH3wvZxh
	/5OtTfpbLwfTUsQJM/ppxZtbsGhIXrY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MvfBY5uf;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787819895; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=S0b5mtUWJPOlKR5LLS2V3xdKfgJHqZzr0zXFS4YHIDs=;
	b=MvfBY5ufu6MUEazPGMRj+ZGUWqdCW4KUM4oXrRuQmneWX+kVvZjDAxdKVSM0dOAy4qkNZbk9SUSSVtcj1pf0fMHVFawQeBAM59xIib6hNoumbOvmgjNU8gzjCpVpxUlVtYw6jPZCac3LBWq8EHMzYEvz3qJ0ehT+kT7kqorb7I8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0X9jAnny_1787819892;
Received: from 30.74.144.120(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9jAnny_1787819892 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 27 Aug 2026 16:38:13 +0800
Message-ID: <25baffdb-fd65-489b-ac9b-94e1ad676eaa@linux.alibaba.com>
Date: Thu, 27 Aug 2026 16:38:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: remove myself as THP co-maintainer
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org>
 <ao7Nr_FALfP7cTY5@gremlin>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <ao7Nr_FALfP7cTY5@gremlin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5A47020007
X-Stat-Signature: r19nq9y7t44syzgpd9g1o18tqjoqj1fd
X-HE-Tag: 1787819901-491712
X-HE-Meta: U2FsdGVkX1+zooscMMkId16A2Aeg1+7Baqv5Jp9LULPksYcLce7/aRR2wDF0mbQOWzvt4NaJ2Fk9jbLt5P/M29WBN/1zxRmViD6IAAgOdSzYbRI9M6u53C41mdlnch4ap4Chu0KgbxOcwCbogEI9v6JYqgWa2sGrRztaRYUi68tDdaeBvTWhQARuY7F9wzzqLDc1x0LoylzT8p6mlaHk1O1WrqSd5Zc7G3FTtOnLgkLTSO+Jsf+FaKdYz+CudTzd2s/ji6W520NKtPA6oa/BN5SmxJmqU7hC+RLuyTCGL+EJ6pQnyATU6odC0a8Ud3VUgjXTcCVMPB7jXgHpE6i9er9Aj0ETGXlJO6ZseQCkegbs4RcGT6cZI+QVx7nVViwPZ9PJaKoJjvgjuMRlPsp6EWpBZidjvCPY+gNAhD+alD/8nwkoKoQYv4uTpR7cTdESMXTS0RBSUZp+U0cIft4vCmyCjJhXjb0xsRgR6N8Sop5Sk3P3yQRI4ZksxqYEk6tZ1G9nt7FC3Qq2XLlX8tii/gzaCI0J7z+BWEo8GO+KyfATuuQiQYb9jbY2/EqLCZ/x1Z2SgHSKuj7El6OQzFvcT3LmR3bVHvFkuCBmuNHfoJpjC0HXZ/w/FT3yodUHRLOEVNn0Zvf1jhso04LL5mUgif81v2hGKg+pa9+jVBNoA0F2QuP2YXhBCTDEHpJixaL8EVExRnU+g3QWZOyW7s86SAQohQj0iCUXfG/a80HENKyFdf2vxVREOxC7HfcPWlTsYVPPKLCZJatu7NjNeTWW9gsaU/LqY86rppG9tY1Z/ubimRxeq07TC+p3gaE+O6TzUBc4VhDqn7VU6jnknMV/sUwQghQCSct446rwGUEJsNf0g/FS0Nh7U4CtGu1SQQsitUAakRj4jM65JmutrMYrAjuFcVzXtt9khQqoltx3lLDPTfGZmU25xInJgErs2u3qBmvhLhXnSROtvB6PRG7
 FBF3/m7x
 X95Ad8M4AgM3GGr+NArQBlQR/Pa4Zy9Qzh3VFVrMZQucKnQduhJFHc38VvXFeGkOceEL5ph/55aXIvuIadpuUBUG5mzg8CENQqDW7PjoVViEFusJX95PIKEKkznBKuRh9VEIaWdlK9RZfVToNI+guVsnF8OMUapnbg/SBK++21aA4mxeXY4o1u7+9ClcErA3ZzYHymYsssmnama7Iw7wCFiEp7GYqT5Cp4H/icE/VIsGhCnDr3Pwplml55AK7+YVwBnaV3iK7ZVRAw/LBuqfPPaWnKzOcvHvR4KactF0LXHFVlaqZJ8IQp+jRC3dsKxuJHgPq0eSAcI2j4p1fC9kPn0Hjgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/26/26 7:31 PM, Lorenzo Stoakes (ARM) wrote:
> Since it's 2026 :) I asked Claude to look at my time as THP co-maintainer:
> 
> 	~107,000 words of review across 948 emails (in 279 distinct
> 	threads), counting only prose you actually wrote — quoted text,
> 	signatures and attribution lines stripped. That's a full novel's
> 	worth of review commentary.
> 
> 	Along the way you handed out 194 Reviewed-by and 15 Acked-by tags,
> 	and your longest single review was 2,404 words (mTHP collapse
> 	support, v12 — the khugepaged/mTHP collapse saga accounts for most
> 	of your top-10 longest reviews).
> 
> 	Estimated review time: roughly 300–500 hours, centred around ~400
> 	(i.e. ~7 hours/week for 14 months).
> 
> 	1,615 THP-related emails in the window: 948 reviews of others'
> 	work, 278 replies on your own THP-touching series threads (~31k
> 	more words responding to review), 382 patch emails, and a handful
> 	of MAINTAINERS bits. Busiest months: March 2026 (131 review
> 	emails), June 2026 (113), August 2026 (111); quietest was December
> 	2025 (5).
> 
> Think I can be happy with that!

Hi Lorenzo,

Thanks for your great work as THP co-maintainer (we all know THP is one 
of the busiest subsystems in the MM :)). I am glad to work with you and 
very much appreciate your review comments and suggestions.

