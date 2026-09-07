Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1640DC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 06:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB6A36B009E; Mon,  7 Sep 2026 02:03:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C67466B00A1; Mon,  7 Sep 2026 02:03:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B565A6B00A2; Mon,  7 Sep 2026 02:03:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 86CAF6B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:03:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14559120665
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:03:10 +0000 (UTC)
X-FDA: 85185923340.01.293ABCA
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf01.hostedemail.com (Postfix) with ESMTP id 900D240003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:03:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=k6q7up2c;
	spf=pass (imf01.hostedemail.com: domain of nilay@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=nilay@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788760987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ksb5J1kFmRG7IMX5VJXWmuOrTscqVKlwxv+1yj74CUg=;
	b=qgsTLwYv4MHdpcFswnXtC8ytW09Co57ePqGA4QpJE+g74mep+F0UGMhA0+Z+k7hf4I6KlH
	C4oHjoyJspa+dpOo8tDtE0pNrVCXW3tyCEDjPO3AEMYJbad0GmhF6J1AC+q4OcLzHYiEZM
	Tm6QrZhS4S0vuwsNn8rTdCetJim0hHo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788760987;
	b=ykc5zFY6rYS+U8APP4RV5g0rJTIY84/p4E0LE3NTQkyfmnuBBAS4kqHsbwanlUrtAzRyiR
	ihQXmH/jJrLn1DvUPG9G4fKLsVrOg34FZ4BzzPqbzwDe6GKy9w7PwV88hPjYdHt2ib5qO9
	CQTdDnTjvwzm3rAAMkc98REFGxFWwQ0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=k6q7up2c;
	spf=pass (imf01.hostedemail.com: domain of nilay@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=nilay@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68741iLQ821207;
	Mon, 7 Sep 2026 06:02:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ksb5J1
	kFmRG7IMX5VJXWmuOrTscqVKlwxv+1yj74CUg=; b=k6q7up2cShkCwnKg3qcM+J
	3OKFVGYl5ffUd5g4riCP2Lq9CxtBm4aCnITrClbP6nXXQXVz/sWejThstwiSnmwZ
	poAYZdJsAZ3Wd97mtVzgA7TRScDZIc5UfrX0GroHiY7DdZtT/WFxT12yDhHN18Zs
	216pm3b7xsRslesr8WcyrzJmMCoFl8upWjSFtiDOP2OK1LOQWzIKaZgCeq8bvevH
	MFy4zH422iwJw0j1aebibAxZ2MZT0qkMOZ0XOGmXs1c+Rp68zxfAb+W95e6SU/7D
	pPxp+VfMb1kKp1P2qDD3hBcl4aNs839+0UXPrjiNgHkqHHnkymLQdChmIytgrhHg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbheprn1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Sep 2026 06:02:36 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6875uP9b030858;
	Mon, 7 Sep 2026 06:02:36 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ggxwgv5ay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Sep 2026 06:02:36 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68762ZOB43254018
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 7 Sep 2026 06:02:35 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8375E5805D;
	Mon,  7 Sep 2026 06:02:35 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A18D458053;
	Mon,  7 Sep 2026 06:02:19 +0000 (GMT)
Received: from [9.123.7.57] (unknown [9.123.7.57])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  7 Sep 2026 06:02:19 +0000 (GMT)
Message-ID: <a123f309-6ec7-470f-b5b0-f08cca6d2627@linux.ibm.com>
Date: Mon, 7 Sep 2026 11:32:18 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] blk-cgroup: store blkcg in bio instead of blkg
To: yukuai@fygo.io, Yu Kuai <yukuai@kernel.org>, Jens Axboe
 <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Christoph Hellwig <hch@lst.de>, Tao Cui <cui.tao@linux.dev>,
        Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>, Coly Li <colyli@fygo.io>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Alasdair Kergon
 <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Benjamin Marzinski <bmarzins@redhat.com>, Song Liu <song@kernel.org>,
        Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Dan Williams <djbw@kernel.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Ira Weiny
 <iweiny@kernel.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
        nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
        gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
References: <20260823133045.970199-1-yukuai@kernel.org>
 <20260823133045.970199-3-yukuai@kernel.org>
 <49d724b8-57c6-48fc-8099-69cd1b072351@linux.ibm.com>
 <befbc177-f7f5-4c44-b02e-20a99fc64c0c@fygo.io>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <befbc177-f7f5-4c44-b02e-20a99fc64c0c@fygo.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: im8OC1-EmKXczbx-h1qS5bOwxgKAaWN6
X-Authority-Analysis: v=2.4 cv=RIaD2Yi+ c=1 sm=1 tr=0 ts=6a9e537d cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=3B2c1Lu2D3hCyOpHH_4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDA2MyBTYWx0ZWRfX41bv8i9Ji5b5
 khAXgMgA4wj06LIds34mWjHokFZI5htPa3CcCYMzkMltQ3HbC8kwOJZUNARuqYjQ3TPdyG/HODX
 vLmFSG4SdgheEUgTIxq9rj8tvz9D58I=
X-Proofpoint-ORIG-GUID: n5OGK1j4LYtHzHpx4KZ2qyT0H7DzsKco
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDA2MyBTYWx0ZWRfX9PiRfBZRsKiO
 CX+4bhydjMEyqMW0Fa1P0zb0/Vxvvu/ZGl5CDMSuLOs4q5kXF+sZXNNrsiWxNvPLt0ZTPCvf3W2
 FEYMlSilDZFBf/kwoTaf//bU8y9gtYJCCdWiXQ6p1bQzQzFsYfVQUiW2EzalUnnNiv84ndOnn/T
 8sIQWvaEanwTKBCDHqXfyMrixhlF2BR+HrNKLL1mZtiUePnF9Q0oxzWRf6p+VmRwInrlXDOFnkG
 icAa0fFzxWnAr5o7Kp+y441RcyP59HAkDdqe0ASiFnLmKSzzBo4GBekCkFm7orKjID5F7VHBMHs
 PYHJHFkgCC9CVBXXx86BkHmuSi3otCFap/OIt6bBQ4pYSs+wIuRJh5PMGVzAQZIkUIlXtMNl7xE
 g1lLq/MfjeBSh1A/urFKfg+cWYG/vs3riyno/UMGvCo2gk5S8kVNYKHIH6GtDFcpMH4I5pmYDgE
 +V28/ums8ewFhwRZIeg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_01,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 adultscore=0 phishscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070063
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 900D240003
X-Stat-Signature: n3ewps4gnas8j5b3qrqjd3jqx6wuo7br
X-HE-Tag: 1788760987-475283
X-HE-Meta: U2FsdGVkX18U4j5YYTiE25ugXDxzDHdU0fqS81MN/FxPgPo2Z24JuE4u7fU5neD6sf1gO3nPh/E8kZtISMl1KrKUd81gTSjxWraRXzeSEQfjHEH2JbuRZ6WqJnzfUmBQRNQSS73xkx5eijBEBDQH1HD8e0T2lGOd3UbyV17bVeD1UN0bIzt39kfHS2grZ24JbjjdqT3xbovRyvHR4ByW3UFzHOp6NJefGBObBicU1jl+2n/UxaZE+xyECrg4WtjFvBp+0j4Bc1cmq2lSyZuZWO7L81wL4aF/hsPwpt9JgZoD8ZVrjoinp0wBU8PNtZh+O9gN/+QC7e56yqE6XYkyLJoe1+hS/vUBOx2usTYONaeFbUH4+li3cgBWLQQrz1Epf/+5vaMCzPArlAh8V6VUFVF8vxgRS3zWXbLOZK4Afrj43mS92kBQvX1ItzEAOQCQPVPq7oMHxMcmgDHi5LrxkjA5r68BYS809pKjnUwokf0iVov7KjgcvkWcSz7kb1BGoXdD+MI2JJzsmkPk2cDZhoHPZfpocoglSAsdFOB+edW+Z6KHz6lgXIlrMCXCgiij20s7OYZcYwPHRj1KIjJiwExI+FL1hRR629GrCCtZAyH/PQs9ObpR+3DJn0k9KjpxnXaHmME1ZH89h+KElDtmDBgdTHOZGJEOq7OBEkxfJ9V/pchJyb7ZSyLpaWwtq/D1EOEUlC6e/OjFJMGrIUwL8OfIYfTCZXohXbcPjtCl0oYSWutnhV4JDQYF8w4rOF8WXZ1F2zXRw/xUGrG4kXatxqy7iPFfvvKpLOpiD1e+28jeWC8FoN2hPsQsuYh88fmTeisnb1Lpu6ACIY79WtgOd6jb3DX8sTFTTWZ47pgLbFPSl5LQZTQjG/4F44rm7gcyHaHx3AUatp039yXZsF6S+N+FImuLurcf1F3E15BDy3f9fmc9Meq8rts3XQzPL41v+YMViGVpbZJrLgs9Bo+
 s9+fpd6h
 18C50vMY20cPESP0247oPApO1mmldDE7e2EEtwvmmt4JnsoKn/SPxKTTU7OJCNUcb69wEB/0iSwOM7bZH/DniD3a1gkcfpIiVQgmlEbrZXd7ugAx0fH1R+S2TO836TyMybTmJbBW4DzZ01fRdOMDtC1zkWwDa93IW4BKawMaNyLbSTXqv1lrWSJzpLkPHNrMCaDKi+7tLTZVCl8f6dG46mWPqc0B/+qbp2ViTVAqlm3Qv2HZOVynMbM0tHZtPLXvhXw2WbFldrEePOd4WQaM3qIGeSFPizH0UzJ1nHyRWNokO4pOZUhY0PAs0OFetUPiraNEMv68tGbEu3XWK2jQDAG8lTo/CG2XXIt8E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/6/26 5:09 PM, yu kuai wrote:
> Hi,
> 
> 在 2026/9/6 18:56, Nilay Shroff 写道:
>> On 8/23/26 7:00 PM, Yu Kuai wrote:
>>> @@ -257,20 +262,21 @@ static inline bool
>>> bio_issue_as_root_blkg(struct bio *bio)
>>>     * @blkcg: blkcg of interest
>>>     * @q: request_queue of interest
>>>     *
>>>     * Lookup a blkg for the @blkcg - @q pair, whether it is online or
>>> dying.
>>>     *
>>> - * Must be called in a RCU critical section.
>>> + * Must be called with either RCU read lock or queue_lock held.
>>>     *
>>>     * This does not acquire a reference.  The caller must already hold
>>> one, or
>>>     * have the blkg pinned by I/O.
>>>     */
>>>    static inline struct blkcg_gq *blkg_lookup_any(struct blkcg *blkcg,
>>>                               struct request_queue *q)
>>>    {
>>> -    RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
>>> -             "blkg_lookup_any() requires an RCU read lock");
>>> +    RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&
>>> +             !lockdep_is_held(&q->queue_lock),
>>> +             "blkg_lookup_any() requires an RCU read lock or
>>> queue_lock");
>>>          return rhashtable_lookup(&q->blkg_hash, &blkcg->css.id,
>>>                     blkg_hash_params);
>>>    }
>>
>> The changes look good to me. However, rhashtable_lookup() is annotated
>> with __must_hold_shared(RCU). Since we now officially support Clang
>> context annotations in the block layer, compiling with the latest
>> Clang/LLVM generates a number of context warnings, for example:
>>
>> block/blk-cgroup.h:277:9: warning: calling function 'rhashtable_lookup'
>> requires holding __ctx_lock_RCU 'RCU' [-Wthread-safety-analysis]
>>    277 |         return rhashtable_lookup(&q->blkg_hash, &blkcg->css.id,
>>        |                ^
>>
>> The same warning is reported from several other block layer source
>> files that include blk-cgroup.h.
>>
>> This indicates that rhashtable_lookup() requires the RCU read lock
>> from Clang's context-analysis perspective. Looking at the call paths of
>> blkg_lookup_any(), it appears that not all callers hold
>> rcu_read_lock() when invoking it.
> 
> I was not aware of the above clang warning, this should not be a real problem
> because queue_lock should have the same protection as rcu, and I was trying
> not to make this patch too complex.
> 
I agree that this is not a runtime correctness issue when the lookup is already
protected by q->queue_lock.

> I add the rcu_read_lock() in the following patch to covert queue_lock to blkcg_mutex:
> 
> [RFC PATCH v3 3/6] blk-cgroup: protect blkgs with blkcg_mutex - Yu Kuai <https://lore.kernel.org/all/20260823152926.1043863-4-yukuai@kernel.org/>
> 
> Since this is related to compile warning, I'll move the rcu protection to this
> patch.
> 
Since rhashtable_lookup() is annotated with __must_hold_shared(RCU), Clang's
context analysis still reports warnings for these call paths. While this
doesn't cause a build failure (and only generates warning) when CONFIG_WERROR
is not enabled, it could do so for configurations that enable CONFIG_WERROR=y.

So IMO, moving the rcu_read_lock() protection into this patch makes sense.
This would avoid introducing the Clang warnings/errors in this patch, and then
you may accordingly adjust your subsequent series where the q->queue_lock protection
is removed and the blkg lookup paths are protected by RCU.

I also noticed that some paths already take q->queue_lock followed by rcu_read_lock(),
so adding the RCU protection here should be consistent with those existing paths.

Thanks,
--Nilay

