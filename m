Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE72DD68BD5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 03:08:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43B586B0088; Sun, 21 Dec 2025 22:08:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E5796B008A; Sun, 21 Dec 2025 22:08:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FAB86B008C; Sun, 21 Dec 2025 22:08:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1CC826B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 22:08:25 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AC0F61A09F1
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:08:24 +0000 (UTC)
X-FDA: 84245623728.22.671FAD1
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf06.hostedemail.com (Postfix) with ESMTP id 094E818000B
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:08:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=vkbKgYK6;
	spf=pass (imf06.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766372902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YAtcsFclq4XbbiDB67SzXvz6gDgLwNXWJVv0Anqspv8=;
	b=b6YwjifQyd6BbkV7n+PItbIvTMjPJFRfufozZNZC6vwjI3OYF+be+34RGcHrOhstjaNXpP
	rjE6is5q50Ql3NGvpHvnMd6v715cTO1A38hSBe6SuMWufHHJszNNL9TfdBmrhgD3cj0cOV
	IB5oAErHtP+tmKY1sdM7IAfHRkQkYks=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=vkbKgYK6;
	spf=pass (imf06.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766372902; a=rsa-sha256;
	cv=none;
	b=x6y1Y8/yeVxCQSwjuVnGxNxJH5DFKs5La+YVtjRnushyBPiOQoDse2DPW56d7ab+RuFw/I
	ZZJ+obOy5TSJQZF6kiHTE9xyytoogbqogLWhDW3TI9hZP0VNmkQglXNDTFyEhuD9Zp2c6F
	4xMDwmmzjsX9PlQ+M5NrAZ8V/1GbLjg=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=YAtcsFclq4XbbiDB67SzXvz6gDgLwNXWJVv0Anqspv8=;
	b=vkbKgYK60ruqF4U5mf01kZydopn2LRnEQI6R+SSDVzfj+svFpMifDb38+biVY+98G22ItBIi0
	mdtMEOHoKmSCocuR45YW7SoquJnmUVnZrtQYo8swTeIb3zW5X5LCktCEDoDPR7O1qTeXlOkFd7+
	W7aNsb306Cstb7F1tB9kvgU=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dZNM30n0DznTXZ;
	Mon, 22 Dec 2025 11:06:07 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id CD56A40539;
	Mon, 22 Dec 2025 11:08:17 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Dec 2025 11:08:16 +0800
Message-ID: <68bffc9a-f067-4e67-87ee-9fea769950d5@huawei.com>
Date: Mon, 22 Dec 2025 11:08:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mempolicy: fix mpol_rebind_nodemask() for
 MPOL_F_NUMA_BALANCING
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
CC: <akpm@linux-foundation.org>, <david@kernel.org>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <apopple@nvidia.com>,
	<mgorman@suse.de>, <linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>
References: <20251213082911.1509735-1-tujinjiang@huawei.com>
 <87pl889uvg.fsf@DESKTOP-5N7EMDA>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <87pl889uvg.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.179]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 094E818000B
X-Stat-Signature: 7dn1dujdtmsty46ruxeqipfbpfznrfn8
X-Rspam-User: 
X-HE-Tag: 1766372901-630865
X-HE-Meta: U2FsdGVkX19wATkujuY3QPEsqSvlhUyZn8t9hCaqPv95kP/eWI9d55YnwZX02lVsqjNs2BeZGwOvxI4MyrH8F2psjp+jSNYW0BQFjSpBn3R12Wx4IHyEdh6tWiet244VxVAHYRVLA4rOKWGvWEAOcK2fi5EZ3E9uOtbJRbrmXf38N7RbL1BAH3trD7UngEaBCUycYR9WYlop+BDNrejsJyyche/K9lTpOFo9Q+iJdy0lmaYvI5ZFUxDmo5JA5ILoSrfyfK/Og13vFBwRpQVbi5PPaWy4BO1WthKq89C98JSR2jVp1N1GdPUqWaTxoF5nkNCQKcnybTqZyPcDuf9FrjGeedWkg5U/+L09CDvR2pJieWsfHDfKi9V08of2AIifI+YrwlZMfzDkJrJrt8azGNcwLo39gxQmRSEyD05jwN1i2krYtmFCm9limenv9JrItKx5GmoFm193Yf6qiNosTE/NRcs/zYjNCYOP97k2gRfxTb5zDhwH6dCsfWC6bBhfX7C0lyQnmki1vkqprkMYa8jhoIWCFGqTC77VIPQnDJQBaz9ivi7wht1GRXP8IPF7rd+JFEGHt3hlNIX6RUUzRA318Qc5l7LRuhSy0gilfN3c2xxoJ6XLN1TW7AFP+WqSfOXB761Ec3OIZSnDKQQ1BpRWhCjL0SpPl1H6g1Avl21/ncWisQlTLhGhyfIZo5fpiIHSpEK+UtZR2fueH23CKcVUox6118GygMKJKu7Hc6WC+bVfJ/N6QVGy8Y7XUiSe0H7gSIYXzJvkproTNJ0LXIUVfGEuC7RRWvP6lL8Up9f0G6/xwmU3d12qYdTRnZnJ7TEq6GZGLRRCl42xn8ROT1xMaBKTlQA92fWpOg/mDuyfL/se+/ISNxtHlCKIqhDfaerXQ3GaUays3gwNYOar+0ATAvw/8Ba4WLMCJnKTEN1lL8DAg2g7ItAhiJcC3BCnLpVg8EWVLutbXJafpKK
 xJj3RHvS
 eErjPXEAfXB9nKrhA5GXDITOu8M6apQVinNwZsHQinwd3e+88cnntcXxphZ9ot4TVL+OASz4QfkH5Z9EQKZM/m3EUlCUFIJqKvWA5REmoCabUqcPF+XZP9KNhFUhpwHGlB1Cx/XmOYhiJ7IbAsVq5ksqsGc12s1Ygrk3pdreJqZII3JM4L/43LqiBOXlGyM+qtklNueQZ6KXv8LwHQ5F64fQd4+JPk/+YR/PMVkBMUWe5TjPDb5vhBXe/n63PZIEaiOu5zN16uSOXOyZu/cqvbTh8+3bbeeytdCkVJbO/62KiLORQNI4ujse1mwm8Eys/lSvjFPK8iE2LGX6bfw2IgjKtk8WKoKtG3QDMISrNzPJhO68u0PfbuQPITmCAIalMsJFDD5a38glSbb04ziNxWjUN+JzLIpEstO4+oJz+NPl2AfIe/0XiZcNOAi6JeF8CWkFzTPuZvpAWbE1KDDF9YYNwxcpD8810CfAFbRxBef34Etg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/12/21 15:06, Huang, Ying 写道:
> Hi, Jinjiang,
>
> Jinjiang Tu <tujinjiang@huawei.com> writes:
>
>> When mempolicy is rebound due to the process moves to a different cpuset
>> context, or the set of nodes allowed by current cpuset context changes,
>> mpol_rebind_nodemask() remaps the nodemask according to the old and new
>> cpuset_mems_allowed by default. So, use mempolicy.w.cpuset_mems_allowed
>> to store the old nodemask allowed by cpuset.
>>
>> MPOL_F_STATIC_NODES suppresses the node remap and intersects the user's
>> passed nodemask and nodes allowed by new cpuset context.
>> For MPOL_F_RELATIVE_NODES, the user's passed nodemask means node IDs that
>> are relative to the set of node IDs allowed by the process's current
>> cpuset. So, use mempolicy.w.user_nodemask to store the user's passed
>> nodemask.
>>
>> commit bda420b98505 ("numa balancing: migrate on fault among multiple
>> bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA balancing
>> for MPOL_BIND, the behaviour of rebinding should be same with default
>> befaviour. However, mpol_store_user_nodemask() returns true for
>> MPOL_F_NUMA_BALANCING, leading to mempolicy.w.cpuset_mems_allowed stores
>> the user's passed nodemask instead of cpuset_current_mems_allowed, and
>> mpol_rebind_nodemask() remaps wrongly.
> Good catch!  Thanks for fixing this.
>
>> Fixes: bda420b98505 ("numa balancing: migrate on fault among multiple bound nodes")
>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>> ---
>>   include/uapi/linux/mempolicy.h | 6 ++++++
>>   mm/mempolicy.c                 | 2 +-
>>   2 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
>> index 8fbbe613611a..1802b6c89603 100644
>> --- a/include/uapi/linux/mempolicy.h
>> +++ b/include/uapi/linux/mempolicy.h
>> @@ -39,6 +39,12 @@ enum {
>>   #define MPOL_MODE_FLAGS							\
>>   	(MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES | MPOL_F_NUMA_BALANCING)
>>   
>> +/*
>> + * MPOL_USER_NODEMASK_FLAGS is used to determine if nodemask passed by
>> + * users should be used in mpol_rebind_nodemask().
>> + */
> This sounds a little internal in a user API header file.  How about
> something like below.

Thanks, I have updated it in v2.

>
> /* Whether is a nodemask specified by user */
>
>> +#define MPOL_USER_NODEMASK_FLAGS (MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES)
>> +
>>   /* Flags for get_mempolicy */
>>   #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
>>   #define MPOL_F_ADDR	(1<<1)	/* look up vma using address */
>> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
>> index 68a98ba57882..76da50425712 100644
>> --- a/mm/mempolicy.c
>> +++ b/mm/mempolicy.c
>> @@ -365,7 +365,7 @@ static const struct mempolicy_operations {
>>   
>>   static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
>>   {
>> -	return pol->flags & MPOL_MODE_FLAGS;
>> +	return pol->flags & MPOL_USER_NODEMASK_FLAGS;
>>   }
>>   
>>   static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
> ---
> Best Regards,
> Huang, Ying

