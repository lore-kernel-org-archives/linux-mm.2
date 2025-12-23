Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FCDCE6B261
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 00:50:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC5656B0005; Mon, 22 Dec 2025 19:50:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E72E86B0089; Mon, 22 Dec 2025 19:50:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9F7E6B008A; Mon, 22 Dec 2025 19:50:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9C4F6B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 19:50:45 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F6E0137B8B
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 00:50:45 +0000 (UTC)
X-FDA: 84248905650.16.EDB5284
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf29.hostedemail.com (Postfix) with ESMTP id BA5A6120006
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 00:50:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kubvgjru;
	spf=pass (imf29.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766451043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q09zvtwJgJMdeiHixqAZ9rCDdFiSF8XUgOoFtRWwVDY=;
	b=7HlKu7hBbRrr9Be/EkvAfXqjD9h0fGcBty7JBRLxDXT5lWlhYLRKRAismnpGTYOu+8F+zX
	xL1bCuvtEpivvzN40+3nl5pw9CyIn/acuN9quNOThprXllh8XH0XO+/pI+C9Sx8JNRG9pd
	okpNDAxujEwTParfHtjVqrPMgRsmKS8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kubvgjru;
	spf=pass (imf29.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766451043; a=rsa-sha256;
	cv=none;
	b=xdfpYcxgqFtZCnK0Y2qNKSJe30ZSUFP1jjjycF3CI8Hun2DtubZaBLRmeESMuunrbUDxWA
	1Ao5Mr3XM3B0hxVL+C8ez8ihRxgUtsLx5Ho803iOt5SovDdL0CwO9/je85vRrRvGIfiEML
	vMONERufQs/YocCpBJqRnUhvoHWEi4M=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766451039; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=q09zvtwJgJMdeiHixqAZ9rCDdFiSF8XUgOoFtRWwVDY=;
	b=kubvgjruNw54H8lJe0BJvlUnXfyVVbmzSD7mUDsm0xMppUIO/HmkROq5WU18hWkWH6xyDxVvFxzrEu3iRElcgphc76tFsEyT/7vDxV14iB1GWQHAhjMgDvE7KktK8S7w033u/Gm2Ld0IMfkHyyDSG9wmVCvbMuzG//0nLd1OUB8=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WvVhBAY_1766451037 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Dec 2025 08:50:37 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: <akpm@linuxfoundation.org>,  <david@kernel.org>,  <ziy@nvidia.com>,
  <matthew.brost@intel.com>,  <joshua.hahnjy@gmail.com>,
  <rakie.kim@sk.com>,  <byungchul@sk.com>,  <gourry@gourry.net>,
  <apopple@nvidia.com>,  <mgorman@suse.de>,  <linux-mm@kvack.org>,
  <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH v2] mm/mempolicy: fix mpol_rebind_nodemask() for
 MPOL_F_NUMA_BALANCING
In-Reply-To: <4cf67d5a-af50-44d4-8a2a-c7fc76b304ee@huawei.com> (Jinjiang Tu's
	message of "Mon, 22 Dec 2025 22:25:44 +0800")
References: <20251222030456.2246728-1-tujinjiang@huawei.com>
	<87ecomalp7.fsf@DESKTOP-5N7EMDA>
	<4cf67d5a-af50-44d4-8a2a-c7fc76b304ee@huawei.com>
Date: Tue, 23 Dec 2025 08:50:36 +0800
Message-ID: <877bue9g2r.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BA5A6120006
X-Stat-Signature: dtm75yk8wohre58gnssw51ycp6h36a53
X-Rspam-User: 
X-HE-Tag: 1766451042-134615
X-HE-Meta: U2FsdGVkX18E9bEOFYBNX6fHJZYYsec4vDS79w89Te8vG0xZ2fiMqb8wHa7PAzNLJwYNJYD7suAQylShI79//D8NIRQxNZ8iySBrz7ntjwoMYpiMcjzc+yN8T2YuHbDvHHfjG8q2HZzVZhCgYDYan3rCfW7kbayw7xSp82O3Phx8bDfZRLPbSDPxJSn2nE9R8Eti81VUgmuOGImq63U3hZOUCeKmvFCvAml+BSQ+V3teRYHdKQ9yQOK5FEngE6+vRkuoVG72elAkCXfgmZfGWXCrDHFp1nV+c6J4bsmwexX1uPz3XUfE+iyFJEiHYsxw0yuNYg2D78iqx/VtgP1OlbssqYnJQHPGBpcTuYnkm5tCBr73YNJVrINscNRPv9o/zbS0UBYskUbkSDBEEOo/lCg1bqJ4PsqgjMzwfik99CqaXEKTd8lW4U0Jgm46hziwQjjHVeINCmFcHmPHO24wh4NYnhPuz9hJXF9gwDxf6ZJWiMzJ+w5jMW02U6pxWauZdkMdbZc9cJzUEFmwra4Xm7lVriF10GnVYeUbILq7Eu+NObWfInVJIR2HHoq4bpCwSvYBOKKzbhZrhTTyjfmwAkFJHQFp//8fkhBW0d0XUwozb7h930Lj1cx0Tg6Yawf2yDDx4DcpQUnXOguA2OfvzA6VOiMZpctQ1DFuvIIsYnvw6fdjUQUbZMXUo54HXvQTrovRY5YPO6LtjQeavIaXm9e329yEpE+o6qJSbbpC4o/K8l/XjZQqChC4n8oKsQT9trBq1/aJgTceCCTSsppvLqBF6DRQS+8/mewONcA+Xe2U98LgT0q1WM0wDYyAvaqP1WlHVmT6yJiUaSrcLlDRnBmtybB0m7fAcJbRW0YEz0jvLL/3eBwEfu1Q8eXlNuFlxNrBfUuK0YerDKeEnHpRw37d3d0Ghk5cO0FTk93SHLaGF5arQKs1JNHJvVTKr8JXWH+Xof52ByFHl5DuUC1
 9WZSqrFQ
 giZI/uamjU4Q0uNzWQT7cGV+Wy7Her0MMHBysaX+6WTSaXEP0mobQYggS4f9xu8QEhTURUmO6jDh7JKp96nbCum0m4KjPtQX4N2fV2r8Pl0g6bwXhDovYfx/0wDzfskFdfd6+tUdCCLcJKgJ0iBfDs8jqDUThbhMiAbTIxMsQvAyk6ToAAug4GMn1w8acqOzbksevXz8shDH/VKtSqf9pr5TtZRBfp9SFBUQ/Weyzx8r53uBjJ26DDeqotfVw6XP9GdC+pHKzlU2sWBvY7nTceDDkFCBTaalFQPs7I0rJ/b4FRjsry03CoR1WU9iCTu57JVnHKeAb2MRL3QoOFEwg2Zv9PR45JoXdnslSyfZUQeVMxyMAYc/0AyjLb2naKKF2YNMTuh/gy5wqMRBKEeGL8uaJus6RB2BM1kAsqprQc1DXxVjA1OPXBeA4hgo1tIK3pKzrojENHyPqmKg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jinjiang Tu <tujinjiang@huawei.com> writes:

> =E5=9C=A8 2025/12/22 17:51, Huang, Ying =E5=86=99=E9=81=93:
>> Hi, Jinjiang,
>>
>> Sorry, I found the patch description is still confusing for me.
>>
>> Jinjiang Tu <tujinjiang@huawei.com> writes:
>>
>>> commit bda420b98505 ("numa balancing: migrate on fault among multiple
>>> bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA balanc=
ing
>>> for MPOL_BIND memory policy.
>> Is the following description better?  At least, I think we should
>> emphasize that MPOL_F_NUMA_BALANCING is set while both
>> MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES are cleared in the mode
>> parameter.
>
> Thanks, I will update it to make it clearer. How about the following
> description?
>
>
> commit bda420b98505 ("numa balancing: migrate on fault among multiple
> bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA balancing
> for MPOL_BIND memory policy.
>
> When the cpuset of tasks changes, the mempolicy of the task is rebound
> by mpol_rebind_nodemask(). When MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_N=
ODES
> are both not set, the behaviour is same whenever MPOL_F_NUMA_BALANCING

s/is/should be/

> is set or not. So, when an application calls set_mempolicy() with MPOL_F_=
NUMA_BALANCING
> set but both MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES cleared,
> mempolicy.w.cpuset_mems_allowed should be set to cpuset_current_mems_allo=
wed nodemask.
> However, in current implementation, mpol_store_user_nodemask() wrongly re=
turns true,
> causing mempolicy->w.user_nodemask to be incorrectly set to the user-spec=
ified nodemask.
> Later, when the cpuset of the application changes, mpol_rebind_nodemask()=
 ends up rebinding
> based on the user-specified nodemask rather than the cpuset_mems_allowed
> nodemask as intended.
>
> To fix this, only set mempolicy->w.user_nodemask to the user-specified no=
demask
> if MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES is present.

This looks good to me.  Thanks!  Feel free to add my

Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>

in the future versions.

>>
>> When an application calls set_mempolicy() with MPOL_F_NUMA_BALANCING set
>> but both MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES cleared,
>> mempolicy.w.cpuset_mems_allowed should be set to
>> cpuset_current_mems_allowed nodemask.  However, due to a bug in its
>> current implementation, mpol_store_user_nodemask() wrongly returns true,
>> causing mempolicy->w.user_nodemask to be incorrectly set to the
>> user-specified nodemask (or an empty nodemask).  Later, when the cpuset
>> of the application changes, mpol_rebind_nodemask() ends up rebinding
>> based on the user-specified nodemask rather than the cpuset_mems_allowed
>> nodemask as intended.
>>
>>> when the cpuset of tasks changes, the mempolicy of the task is rebound
>>> by mpol_rebind_nodemask(). The intended rebinding behavior of
>>> MPOL_F_NUMA_BALANCING was the same as when neither MPOL_F_STATIC_NODES =
nor
>>> MPOL_F_RELATIVE_NODES flags are set. However, this commit breaks it.
>>>
>>> struct mempolicy has a union member as bellow:
>>>
>>>     union {
>>>         nodemask_t cpuset_mems_allowed; /* relative to these nodes */
>>>         nodemask_t user_nodemask;       /* nodemask passed by user */
>>>     } w;
>>>
>>> w.cpuset_mems_allowed and w.user_nodemask are both nodemask type and th=
eir
>>> difference is only what type of nodemask is stored. mpol_set_nodemask()
>>> initializes the union like below:
>>>
>>>     static int mpol_set_nodemask(...)
>>>     {
>>>          if (mpol_store_user_nodemask(pol))
>>>                  pol->w.user_nodemask =3D *nodes;
>>>          else
>>>                  pol->w.cpuset_mems_allowed =3D cpuset_current_mems_all=
owed;
>>>     }
>>>
>>> mpol_store_user_nodemask() returns true for MPOL_F_NUMA_BALANCING
>>> incorrectly and the union stores user-passed nodemask. Consequently,
>>> mpol_rebind_nodemask() ends up rebinding based on the user-passed nodem=
ask
>>> rather than the cpuset_mems_allowed nodemask as intended.
>>>
>>> To fix this, only store the user nodemask if MPOL_F_STATIC_NODES or
>>> MPOL_F_RELATIVE_NODES is present.
>>>
>>> Fixes: bda420b98505 ("numa balancing: migrate on fault among multiple b=
ound nodes")
>>> Reviewed-by: Gregory Price <gourry@gourry.net>
>>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>> [snip]
>>

---
Best Regards,
Huang, Ying

