Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D072C982CC
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 10:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 518206B0093; Sun, 20 Sep 2026 06:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C8DB6B0095; Sun, 20 Sep 2026 06:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DE9E6B0096; Sun, 20 Sep 2026 06:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A5756B0093
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 06:08:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 91FD21C2364
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:08:09 +0000 (UTC)
X-FDA: 85233715098.20.AFCE447
Received: from cu-ua11p00im-quki07171502.ua.silu.net (cu-ua11p00im-quki07171502.ua.silu.net [123.126.78.69])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7AF2320007
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:08:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=JHkA0eRm;
	spf=pass (imf31.hostedemail.com: domain of bfguo@icloud.com designates 123.126.78.69 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789898887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E55+tu5KL9AnKSPgSq7nNcHqWE11x7RdNO/VLX6SJ48=;
	b=pDeG/MRP0T6rg/si5slvauf0QU8zx1s6KHohQWYcVznYLwDyh2+qLNgBx8vWycOpLJSY1P
	Y805XYYZn16ilV+SAc6uLUMLhOn0wSupZbZsPs4pdd8UXZ80feXWtsPN6sqwWZARdsrFrH
	jx1awcuMDONfbiRdp4fJ0yEZTZEMQWE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=JHkA0eRm;
	spf=pass (imf31.hostedemail.com: domain of bfguo@icloud.com designates 123.126.78.69 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789898887;
	b=t4/mCFnpshhPD+Hcch+HnCJ2knlN+UhkuILspmUWDnXZYyIA0a3r6WPji8VRr8y5N8hkHx
	3TWlPADSn7ZnCqc7LCaL4KGEXqRPMJjDNEEcvoPV2WQm4QEHhTtxSs621WYQ+S1OQnPfv7
	IfJAFIRlGThu3Gy7PwvDiUqYgveFzqI=
Received: from smtpclient.apple (ua11p00im-asmtpcmvip.ua.silu.net [112.19.242.76])
	by ua11p00im-quki07171502.ua.silu.net (Postfix) with ESMTPSA id 4818B28C00AA;
	Sun, 20 Sep 2026 10:07:56 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1789898878; x=1792490878; bh=E55+tu5KL9AnKSPgSq7nNcHqWE11x7RdNO/VLX6SJ48=; h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To:x-icloud-hme; b=JHkA0eRmHTEAbrTiOqLc/wgflI1kMXfD5f+z+E6+WiJmG473XO1KKygYZrUGRblQd37Qu0tx1tKGb3sxAxyPROuQL58z82D51Do3UJGPlZSler5+WnuBZ9UdfMeuaiuB4LeFAHp3X701YcatUh/YS5se0zSG5jrB+emKZ69D/4/aEa4BnUVBGIheejrWKgTz7aYKv9330qfE2frmPL9xxT86OCTP2KoqhTTYM65N1NiWnfSZG6U6G+X02HUfAJqB+uV8Ebxw4NPR6zLzkbfWIUCM5IQ8PV7yxJ0w7BW84pCEgufS+q475HoogLVdd1VQKg2PaX4tQSJ4SXyTdwtUaw==
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH 3/4] memcg: manipulate memcg private ID references by ID
From: Bingfang Guo <bfguo@icloud.com>
In-Reply-To: <aq2dkhBuFktQYvTB@linux.dev>
Date: Sun, 20 Sep 2026 18:07:45 +0800
Cc: bingfangguo@tencent.com,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <CA3A67DE-DF83-4B0E-81A2-AEDE93FF5F78@icloud.com>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-3-5bbf3220d88f@tencent.com>
 <aq1_Qhid7-62pHcW@linux.dev> <aq2BfYdMr_8JeY_Q@BINGFANGGUO-MC0>
 <aq2dkhBuFktQYvTB@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Proofpoint-GUID: 0QbLG567OwrrvR_Np6s0bqe9fIGmmYD0
X-Proofpoint-ORIG-GUID: 0QbLG567OwrrvR_Np6s0bqe9fIGmmYD0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDM1MCBTYWx0ZWRfX+m7HBmfAwO1j
 AtWl7t9WlxmlYW9eNvvo6Q1otP//97j1N414CgEtjWHPsyhBgZwytYaIEY7oQI06dhkSBiG7W1H
 4tCQgrsbQ/VQ8ECVV5qvLdSCOdPSAH15KYezyMtrUjOeiwcgDSCwydqy0cSBySIbziJxyVhZ/6s
 4X41epvGF5KKjnuBD+78goInNK+0qdx38bJQXLaNYr6TNl3m1LdD+GkFZFqf2nNxsVAvthnW6fR
 ziH3+zFFAK9EKTMqo+tnA2RC0StgxQI0JyIZzsQ6hBSRgFRjSDj0Fl0ZI9hetjMngjbRxXccUv2
 iUHRkLCl6UfAzWeuAfLDAKPme4UukO02ECorql/xw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-19_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=900
 lowpriorityscore=0 bulkscore=0 spamscore=0 malwarescore=0
 clxscore=-2147483648 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2609190350
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7AF2320007
X-Stat-Signature: 6kwdo5fk6z18dfq3j6tjrzurno5cgsz8
X-Rspam-User: 
X-HE-Tag: 1789898887-121532
X-HE-Meta: U2FsdGVkX1+Oyw0oO4rCU7Ui26vpeL6bV3Zfkcu9dDchbfz3IP6Yuz7fSqIw6PRiP24GCp9sG5Q7gi+Vq7EuiqFLdSRVeaF5EDpGd66psg1uKsC1I2MRNBe3jzFLa7Y65554mXHGJeNPskB4xWmqr8nw3TulUViYIpuQPuhoiLKX2Axj1GsBFdJu5rzMwYi3eSZmA+8PYxIehVo2CtDxdgsWoLS3on82uGe5yNHbXvKVuJqtRw63X4WKeO2eAeHxue0Mq9y9GKxBno9Pj0kHI6AuwuNLDc4/Z3464rvmpkHhUvkMNdlqsyiYXQeCd0GfE9an2P2+uyGNxNhkdlAh5I+mfn0L8FXiMeSK+1+A0Is827buOaiQC1N11v3AkCHp7IxY+XaEQTPj+9JoAMbe+9oNLG9tmDXeAJYZzCF+dRaz+od4RUgm7Fae5o0pNNrbNQ3xqGLAts/heHGgL5dR/M1uPDQLuV2Kl0PZ3kr25aAZjk0yCBMni9mBFh5Sxxcvt/5mDwlqTM6/EOKV7S2C5y0Fk8AIovsbV+88cEYU9k8ixjHuSN7Pe2OvojbYTVh3AxdZ2DiaXtjcMB+Lq8hDXGc8UxcEbeTadQ/VojxJo9Q8ik1Mb2uVrraTR/JRh51iV9I9XHAJL7eH98l4nt2GAkrJ3q4PyhPU0yeJPQ0PnqYDuRk4ParFww45bE/pCuKObCLvaG6WWDs+ji66HTudXdfZjKUIvAonrCKqDh1NsevHBEGFM3LYSfSm8WD6hGNWHtlQg3bgwvH40PAYAWbU1fYtqJoqn8UrkY43A375S+YPuqiC8sS2S1BPMTCFad5VpaPcLc/ojR2Ov2L6G+7wkp0Z8njX2NXxnQ0u1NOVi3QbHe+JkBFRLU1+A2FsWenWr5Q3ZjzE41filinJiChNP89Z0fNqI/xydVopD5vbg4lrwYkRW2IYr/RYAUUv0JRU3SkSMFNKIBFg0ArWIgQ
 JQsrqJwW
 JzE8tm+iCngqfnrZBtr0jFN9IhpDOafl+yFJYlrGtm4fvq5pnQb8XkqUDrIpCGdUIxXT6PY1qhVpsHMilHjKDMTOElOla0dzKIxtPzOJEz5oGWunmjtq1A/dyJUcdgK5GtzbMmGrvmTSegz2kwHVsHbEaNeZavozwJQq5Sj4JuffIIAekhHBYOxCNEvlyOj4iI/QzuGphNdGEjft63n8mtfhV/c3LX+Hn5CcNuV4RW4rCb7Kr5SuLDxvTpqI8KA2ac0a1ppOCzR8vxwhcTnRv7YGHuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 01:24:01PM -0700, Shakeel Butt wrote:
> On Sat, Sep 19, 2026 at 02:46:52AM +0800, Bingfang Guo wrote:
>> Thanks for pointing out this.
>>=20
>> Agreed.  Both two callers are already holding the rcu lock so
>> taking the lock here is unnecessary. So I will drop the
>> rcu_read_lock() and use that in the next version!
>>=20
>> My concern is that: mem_cgroup_private_id_put() looks like a
>> universal put function, requiring rcu held (which is true today)
>> is not that obvious to the users.  So I think adding a short kdoc
>> comment to make it clear later might be a good idea.
>=20
> This function is internal to memcg code, so whoever is going to call =
it better
> know to call it with rcu held because of lockdep assert. No need to =
have a
> comment.

Okay, I'll keep that in mind!


