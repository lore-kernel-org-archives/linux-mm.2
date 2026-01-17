Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7360C9830E
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 01:02:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EADF76B0005; Fri, 16 Jan 2026 20:02:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E31266B0088; Fri, 16 Jan 2026 20:02:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3D3E6B0089; Fri, 16 Jan 2026 20:02:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C56AC6B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:02:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 55C661AE4AA
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 01:02:04 +0000 (UTC)
X-FDA: 84339654168.27.9D00941
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf12.hostedemail.com (Postfix) with ESMTP id B860C4000C
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 01:02:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="Ut9REQq/";
	spf=pass (imf12.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768611722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pwNa3+U98BbXyLdie5E6UGMOrnV5aiKPmQzqG6Kf1Gw=;
	b=cf9arogojXtyu6avGwH5hki7S5+1gwngCO8Ot6ViA4bwcGgVj4AYXi69dnejL8XylH1X+H
	5keQpRGYvWI+ycL/XMg+yKgGIcY4EKIrrnngaPSp+ajv+CtVYgMta/HxkcT90OlP3uxs9B
	lsfw3H96ZLTENfIaMM2gXQqCPID1+Kc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="Ut9REQq/";
	spf=pass (imf12.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768611722; a=rsa-sha256;
	cv=none;
	b=TL3bZC3ae/SjOjyoXH37P4rGnPWO0Zuw9iuZ3fTkwv21adPfBiFZ7XyGxF48LGvT/Sy3e4
	KkAQeRp+hsbqYI7GuIPkSXjQxCxEsLzM6f4uYEqG5TnGOk29E02Tk+GCOEDM2CgrBGIyH+
	MG9DT5VT7nVVMBUhLD8OHRJOr+4hVsA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=pwNa3+U98BbXyLdie5E6UGMOrnV5aiKPmQzqG6Kf1Gw=;
	b=Ut9REQq/zvtMk5kqnw0DljR7dr4WLut/NuWKXDpQil6L3/0Ky41BZS4whv7sMJlkSV3tkRfXl
	F7g+Lh6YwoLqaOJWRkpd41nWDlRLF2HcMHyxaql3SXlbkizZME2XFp3p6sXirnmiFhV5WbaM+Ce
	MKsofJQwhXTQsSimkobk6qg=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dtJH94Q2Gz1T4G8;
	Sat, 17 Jan 2026 08:57:57 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 2FA714058A;
	Sat, 17 Jan 2026 09:01:54 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 17 Jan 2026 09:01:00 +0800
Message-ID: <7471b637-537c-40db-ade0-ad373d7085f7@huawei.com>
Date: Sat, 17 Jan 2026 09:00:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/mempolicy: fix mpol_rebind_nodemask() for
 MPOL_F_NUMA_BALANCING
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <akpm@linuxfoundation.org>, <ziy@nvidia.com>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<gourry@gourry.net>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<mgorman@suse.de>, <linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>
References: <20251223110523.1161421-1-tujinjiang@huawei.com>
 <04b92008-f843-4879-b4a3-608cc5e1de4c@kernel.org>
 <20260115101252.2e0cbe0559e62b988e5f7151@linux-foundation.org>
 <1ad31dbd-6743-473d-9f66-a603b91d1e54@huawei.com>
 <70d46998-a6c6-4c18-b8d7-f813582d3143@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <70d46998-a6c6-4c18-b8d7-f813582d3143@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.179]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Stat-Signature: big1cyiju1iotc675dkfxqm4ome3g5sg
X-Rspamd-Queue-Id: B860C4000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1768611720-678485
X-HE-Meta: U2FsdGVkX19yOzueEoO1bG9WNbbcURejVwBRVDm2DR0gP7dkgCqG08z3lxkScBMYKe7PRQgMttl5NNebmCr7Tvej5g16PggH2usubuTm6GushTxERv/jPyRhwwvHI+7DBkVgmk4cbwMh0JUo1iXUVs+ALRbblSmyE+CSxpmSNEwoS96I6UX3OfXhrcqKlgO/rEM3BMSuYMPALHrUzOf2RURccfS0uOQijo9db8goAWPBxPxbuaDQI/W98I6wBnU1m4TXYWlB3VVG/9F/OZBjUjLPfStn6Q0tMrGLXlJHjphYOelbxdUsnYWVBvx19rV9AeGI8WIZ3l19iFsdMVRbdOosDNIJwdA7mrJt4jnWM30BT89xRrVL2P6VGJOig+7jP4HOIasDENkGnenMDK+zvG9PRI/1Z2BRPk63PY9KACK84m6hPo0Ex7N6Ssaz2VGFkki0ZgJUsIP+ka3UxBi1zTT+FppcEyAXOb/p6TH00CTMuKFIEM16IuIxFIYCjD7oqtkACDjIOX6patIOPrWbWxfDidkjebXe4yKo3AbZGIH3Gx/0YiQ83NLZRi3NdwXhMW01axjrds5Au1swU9QOy94ECNlgMj0hKl1E86CmmLJXnBNTgiV5FnZZpA+O5MFXT7jtK7mi1SdNQBEms6E4I/5Zydrkc3+lOsfJUi/AUHhNqpYMoaxrSOGkwnS2RTXTRafJ0+96CllQGMWlMyQaJePrBdkheQcs1yYA0Epx4L6tEEb2oC+9yNqoLobwMeunnzKj91F/mMUfrDYzC+az2k/+EwLYK8xrzgW5pLZrLUkowZIU+rFVULp1pyTYjZIs68goESCs03ChY70jHNRvdhF8xIsetiDX6OKY+oRWVWGi1hrRazvPnN0pf+brEBU3B3dEtHbEQPBAifDT9ZnHuLXKhATe7i9rggvlUunBZgtD+OSi6Lt5ocW4AcATOLNP994u4lGl4UWZ1FbDEk7
 MCpmpGPR
 pCCFYNoDiRRZ9VFvoBCIjlduoBGNVxGdVyU6RzSbSMPXexLnrhJKGcOCMd/knqu9nTPmrfc6ISiQcNYbTtTSk8F7myGvDwvguR4gKIF+4Pojg5Jm+981QgQsSqrrIfOIiYWGnWafX8/6aOBh0EwBCmDxCV0ZFiOxFpXvT5ESaRofvnSGtk+uzBCAnU4QkwW8gadGAMX9Q0jBHYplN5EYQM60ka2NENhyoKKtjH3qhDDYRBW6LhCjFPRzWnzVCWs8vAsjwPvbDNQcQme6E/z2QU3gFVKUg9oTEGHqzWygQyGnzr7rK2Vedp0ByLt/BZP0KDsoZossz0PB+I89jjqymkF5ELSqZmGSyRW970laq3sSRX+tUtVIelmLplHqKuMmU4oqjlKsjJYs29U1lHNgnWS/vxAQvGazWAO6z/v0fX8oP+Jct16fQSTJCHCNhZLZv9wWDjpgiuWKwB7IsAbxRDQzqNki1RIuaMW1gphnQjgzaPe8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/1/16 18:58, David Hildenbrand (Red Hat) 写道:
> On 1/16/26 07:43, Jinjiang Tu wrote:
>>
>> 在 2026/1/16 2:12, Andrew Morton 写道:
>>> On Thu, 15 Jan 2026 18:10:51 +0100 "David Hildenbrand (Red Hat)" 
>>> <david@kernel.org> wrote:
>>>
>>>> On 12/23/25 12:05, Jinjiang Tu wrote:
>>>>> commit bda420b98505 ("numa balancing: migrate on fault among multiple
>>>>> bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA 
>>>>> balancing
>>>>> for MPOL_BIND memory policy.
>>>>>
>>>>> When the cpuset of tasks changes, the mempolicy of the task is 
>>>>> rebound by
>>>>> mpol_rebind_nodemask(). When MPOL_F_STATIC_NODES and 
>>>>> MPOL_F_RELATIVE_NODES
>>>>> are both not set, the behaviour of rebinding should be same whenever
>>>>> MPOL_F_NUMA_BALANCING is set or not. So, when an application calls
>>>>> set_mempolicy() with MPOL_F_NUMA_BALANCING set but both 
>>>>> MPOL_F_STATIC_NODES
>>>>> and MPOL_F_RELATIVE_NODES cleared, mempolicy.w.cpuset_mems_allowed 
>>>>> should
>>>>> be set to cpuset_current_mems_allowed nodemask. However, in current
>>>>> implementation, mpol_store_user_nodemask() wrongly returns true, 
>>>>> causing
>>>>> mempolicy->w.user_nodemask to be incorrectly set to the 
>>>>> user-specified
>>>>> nodemask. Later, when the cpuset of the application changes,
>>>>> mpol_rebind_nodemask() ends up rebinding based on the user-specified
>>>>> nodemask rather than the cpuset_mems_allowed nodemask as intended.
>>>>>
>>>>> To fix this, only set mempolicy->w.user_nodemask to the 
>>>>> user-specified
>>>>> nodemask if MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES is present.
>>>>>
>>>> ...
>>>>
>>>> I glimpsed over it and I think this is the right fix, thanks!
>>>>
>>>> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
>>> Cool.  I decided this was "not for backporting", but the description of
>>> the userspace-visible runtime effects isn't very clear. Jinjiang, can
>>> you please advise?
>>
>> I agree don't backport this patch. Users can only see tasks binding to
>> wrong NUMA after it's cpuset changes.
>>
>> Assuming there are 4 NUMA. task is binding to NUMA1 and it is in root 
>> cpuset.
>> Move the task to a cpuset whose cpuset.mems.effective is 0-1. The 
>> task should
>> still be binded to NUMA1, but is binded to NUMA0 wrongly.
>
> Do you think it's easy to write a reproducer to be run in a simple 
> QEMU VM with 4 nodes?

I can reproduce with the following steps:

1. echo '+cpuset' > /sys/fs/cgroup/cgroup.subtree_control
2. mkdir /sys/fs/cgroup/test
3. ./reproducer &
4. cat /proc/$pid/numa_maps, the task is bound to NUMA 1
5. echo $pid > /sys/fs/cgroup/test/cgroup.procs
6. cat /proc/$pid/numa_maps, the task is bound to NUMA 0 now.

The reproducer code:

int main()
{
         struct bitmask *bmp;
         int ret;

         bmp = numa_parse_nodestring("1");
         ret = set_mempolicy(MPOL_BIND | MPOL_F_NUMA_BALANCING, bmp->maskp, bmp->size + 1);
         if (ret < 0) {
                 perror("Failed to call set_mempolicy");
                 exit(-1);
         }

         while (1);
         return 0;
}

If I call set_mempolicy() without MPOL_F_NUMA_BALANCING. After step 5, the task is still bound to NUMA 1.


