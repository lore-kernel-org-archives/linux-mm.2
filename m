Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8817BC87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 08:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BF668E0002; Tue, 29 Jul 2025 04:08:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 297D68E0001; Tue, 29 Jul 2025 04:08:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ACC48E0002; Tue, 29 Jul 2025 04:08:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 089728E0001
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 04:08:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C95171DABEA
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:08:51 +0000 (UTC)
X-FDA: 83716576062.03.03EA2CC
Received: from smtp237.sjtu.edu.cn (smtp237.sjtu.edu.cn [202.120.2.237])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4D71B180007
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:08:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of billsjc@sjtu.edu.cn designates 202.120.2.237 as permitted sender) smtp.mailfrom=billsjc@sjtu.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753776530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=lr0wOIO7dkPOzpMvGzIpWUJWaxmZjCQFZgw8k8cGP+k=;
	b=Uqf9Vrorau1E5k/FrWKX2Mz4VoX+g/XvRmTF2oaaS42mZWVdssssdFgEJnmwTgI/ALqqbZ
	YtHiZPcjHmAi42zXrgrYV1fLU8PM+S31X5CA/jsEKdkMKWxn6IZPoVZiCLEA2/zUliGY3f
	Df0npxbgLW8da+UT59CPW+qS/YTD9gY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of billsjc@sjtu.edu.cn designates 202.120.2.237 as permitted sender) smtp.mailfrom=billsjc@sjtu.edu.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753776530; a=rsa-sha256;
	cv=none;
	b=mFCrnElojwLircmOd8j6KkTT4Kd5IpWVs/GIZqy1a5hq7oUepixmr0OQOlNvdJnB2OcOXm
	NDTi5m5U9IR2Jnj9j6dNu6CgscIfa+t1Z9//ojeZtbP3FjfF2QM/yx+rpjyxjdNPLFXnSL
	4sg3zzzreWerx2YZs8EMYDtkkAz83ho=
Received: from proxy189.sjtu.edu.cn (smtp189.sjtu.edu.cn [202.120.2.189])
	by smtp237.sjtu.edu.cn (Postfix) with ESMTPS id 3FFC0856B3;
	Tue, 29 Jul 2025 16:08:36 +0800 (CST)
Received: from smtpclient.apple (unknown [202.120.40.84])
	by proxy189.sjtu.edu.cn (Postfix) with ESMTPSA id 70E343FC1C7;
	Tue, 29 Jul 2025 16:08:31 +0800 (CST)
From: =?utf-8?B?5Y+y5ZiJ5oiQ?= <billsjc@sjtu.edu.cn>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: [Question] About the PCP free_high heuristic
Message-Id: <212D6530-0FE8-4EA7-A599-48D71E8AFA23@sjtu.edu.cn>
Date: Tue, 29 Jul 2025 16:08:20 +0800
Cc: linux-mm@kvack.org
To: ying.huang@linux.alibaba.com
X-Mailer: Apple Mail (2.3731.500.231)
X-Stat-Signature: oobcxjx67i9msi6sh5k7mq4dui1s67dn
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4D71B180007
X-Rspam-User: 
X-HE-Tag: 1753776528-49112
X-HE-Meta: U2FsdGVkX186X+L/GEFAWdMmb3eDlLN6PQ5mwDebldd5h+bkk60InsDatUWY5Mpzq3hjjqj48071sQp+ld8kj/FX13ld+Faq4BJKZR9/TLMDx9FB73iPrMWN2qnh62Y4bcR12fagzIXxnh8ayWDjUrT4rsfpoTCe3l4Wy05RMO/D9nXKX4XWhLf+XKvAG2GzfcOp9Mznufos8lhJcJ7X68aeh55f4uVG+9kNL2aS4ObtvRfRU2GQjcfbA287HB7mt9bz8E5j9oF5Vf1hgYs9OA/9XClclR+unbHGk2dIRgAxK78Mym0L2XxnZvHoMpdvri2jOe+Al8IlCK72LgnyROzBt1vgP6Emps5V2Kg+mZb9gJvGbkPTwTFnKv3QJKUAN4/JgwR3GKNVse4k5UU7+3+q40g5VTAeOb1sbhfnv8vjYlz810gaHn4Jn6mgH9sv+rQf/1FV+Pg1dCFDdhwz7F/xlOZIlqcVTxuauTkYkMce90O7SrvUZYIkwATepl+nVe2EUKjhLCT9CsSO8fRj9IZKpdRfroAWgj0/ioRlbcLHoJpPknHnixI+BNT21zNm4M408g+kEjd8XmJ21QmVrvkAaTv/w4gomwIMCceVJhAnC/3BgHVFrah20dvnTez0GsOgglAYrVtbNiBcdwBKMJ/Q8XtNswVE/2oOcc4CMxZ3zdsDIdDsN5oN82hhRwlinGLyy6b58Y1rtWe2hcriUgbJWm5/k2gJLG/ZxK2cPCQVKSbQqo2VXYHxkyyNXPhPccIJp5xun/gIn38b/ct3yIGQmQ9HoCgBRbmV8ejiVNzIPdZO4mWRzdW6/vZ9EdJMgrcriPBv1odhMeB+v0IXBFV10Y9xC30VGv3heskfFyjpbpSE7/hoOTJvoOertxYB/Y8sLr1dF2LvOkfRx7py+fuUyl8THA4mlNxzndqhYw5Vtuv5QwLKbYTkqOlzxEXPOpXVTU6VjYSaT5a3OV1
 9Hl02EBi
 oJ6KyQoZvTCTMlWOzBATKsDF3YdU4oJ+nqP/XmWjLn21HDYa2bNm2FBBqKu14di4Er63gBNBHlcVPr5o2zSlWw5c/6dS1Ri69hqXeLfeWEFJxfaXX6926YafiBjZxqLn2eVdvZXp9SEvR14S/ejH7oL3BVGTTHJYbCaKxUymKboKNaNMJja0a5MMIl8wLiAQgReKgqoYIj+zfX2Z1ajO1DPzagw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I ran the bw_unix benchmark in lmbench on my test machine (EPYC-7T83, 32 =
vCPUs,
64 GB of memory):
    bin/x86_64-linux-gnu/bw_unix -P 16
The bandwidth result was 30511.63 MB/s when =
percpu_pagelist_high_fraction was
set to 8; however, the result drops to 21595.98 MB/s when
percpu_pagelist_high_fraction is set to 0 (enabling PCP high =
auto-tuning).

I first inspected the auto-tuning code, but the root cause of the =
performance
degradation lies in the triggering threshold of the free_high heuristic:
    pcp->free_count >=3D (batch + pcp->high_min / 2)
I noticed that commit c544a95 increases this threshold, but =
pcp->high_min is
relatively small when auto-tuning is enabled, and the PCP draining leads =
to
the performance degradation.

The problem was fixed when increasing the threshold to (batch + =
pcp->high / 2).
Is it intended to use high_min instead of high in the threshold? Would =
it be
more adaptive to introduce some new tunables for the free_high =
threshold?

Best,
Shi, Jiacheng=

