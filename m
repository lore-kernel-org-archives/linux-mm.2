Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70A1FC88E65
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 14:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69D616B008C; Sun, 13 Sep 2026 10:24:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6209A6B0092; Sun, 13 Sep 2026 10:24:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C4CC6B0093; Sun, 13 Sep 2026 10:24:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 176FC6B008C
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 10:24:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4B958C062F
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 13:07:48 +0000 (UTC)
X-FDA: 85208766216.29.E8DDA27
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id CB6F7140004
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 13:07:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fWHzwufV;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf09.hostedemail.com: domain of nilay@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=nilay@linux.ibm.com
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fWHzwufV;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf09.hostedemail.com: domain of nilay@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=nilay@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789304865;
	b=ns2HxBedsFbomioU+8K/MaYEl27RC9UWsanm0qKg8AMjuT91UOVagELlPks647r/EDDVRL
	f+vlerzMnygdNeEx7nFhyAVogFV4Ye0q1WoGqsYMb1yQ8TCgxO4Mxl99G+TTvepL7JYeo4
	uJgs9JfLzQbiM7BxaSVeIV4w5TgVuec=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789304865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUit5ih3a9kjbGO/rFlGJaDtgvCiUmUJgFLme1f3Lo8=;
	b=A8B+8hX2G98C1Zht1WuFO5cYcrBPXbm4izEasZzHj455Qle1JrOJtHdlPp+vZaA4nO3/qk
	wWLs9davlEuucDfy3UnT21Ka3kann5cGGOaW/ce7XmXh/SkD3FNb65jA91x12kFrxtVsQy
	fORS4zPSx9cNxA44iGpiq9pGQo/kJS0=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68DAVpCb2995231;
	Sun, 13 Sep 2026 13:07:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=zUit5i
	h3a9kjbGO/rFlGJaDtgvCiUmUJgFLme1f3Lo8=; b=fWHzwufVj/J9rMJwnbjjIQ
	GDpO1v3/3jvVIMS4uDLYLuILwVbcb78H0kuPVeSIElUA/v4IJmdcRw/EtrT/P8yo
	AAKrWOpD3i2upRVEOLsFC0Xv9Xhs/kU8jU8LvFKEkAz9bu5OyML7hxYJQDBI4aKD
	4o/l7V1DGh5fIhUUwUSRASqHzzy5SLPy2XHK3rI0nlR6N2SljsVDKtF3DISCoNcI
	QjHKFL5XirMi8tKq+Z2sL241t5SQX1XMGvUP0PQHZjJC7pctqqzfhmflqTe/WI0m
	FMnLgF2OmT06hohsQAtQwW9hLM4hiX1FvL87Jh6xOlQkt1j5W+awdJmPFQoX+3Lw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmv5hcuxj-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 13 Sep 2026 13:07:14 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68DAZ6P2509113;
	Sun, 13 Sep 2026 13:07:13 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gnhevsmuw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 13 Sep 2026 13:07:13 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68DD7Dk017629810
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 13 Sep 2026 13:07:13 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 23A3B58043;
	Sun, 13 Sep 2026 13:07:13 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 308055805D;
	Sun, 13 Sep 2026 13:07:00 +0000 (GMT)
Received: from [9.61.162.129] (unknown [9.61.162.129])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sun, 13 Sep 2026 13:06:59 +0000 (GMT)
Message-ID: <7bc52e8c-403e-4323-be0a-04a2019c2aeb@linux.ibm.com>
Date: Sun, 13 Sep 2026 18:36:58 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] blk-cgroup: store blkcg in bio instead of blkg
To: Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Josef Bacik <josef@toxicpanda.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Randy Dunlap
 <rdunlap@infradead.org>, Coly Li <colyli@fygo.io>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Alasdair Kergon
 <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Benjamin Marzinski <bmarzins@redhat.com>, Song Liu <song@kernel.org>,
        Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Bill Wendling
 <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>
Cc: Yu Kuai <yukuai@fygo.io>, Christoph Hellwig <hch@lst.de>,
        Tao Cui <cuitao@kylinos.cn>, linux-block@vger.kernel.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
        gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, llvm@lists.linux.dev
References: <cover.1789237876.git.yukuai@fygo.io>
 <ef547fdb7a6c8e39a25a1b9473c444f24a0f03be.1789237876.git.yukuai@fygo.io>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <ef547fdb7a6c8e39a25a1b9473c444f24a0f03be.1789237876.git.yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEzMDE4NiBTYWx0ZWRfXxK218OGK9G+d
 ieqx00sYrTS2O7U39P54JyrhIlLhTQXnA018MXuQk6idxb0GAC50it7KgBMF03xDZiOOHzNcjIv
 P8WRJeCRCni3OcqRSMyqZtRZ9QCpIwxlH94d5Z0T227QL0pd62kFw2cdDC7XsP/nZu3ejskXkh2
 52h8wn/lgpqrbwqanFAgg5F2PZnJMXIktWqf7IT5f7mA2lrJtahGQAN2v7Tqo2XAlIhZu+qHful
 OsH4FbpzXqKEjvpJ6tBEW8Zcb2hZ5Nn3SztZzam3jxsKy8Q/E4SQ/4uqmyzwgfG65vuzQ3EKKFX
 xjm4w07PckyYVZTKjM+TigC7z8YDLgrVV072y81IQcbPVSpmeA4DGHDQNMmcW5Pf/YLpoDhkR/B
 TelWS6kiZInnyPzDtckYJMPtZhLhIS2tkTIFWRTb0lMLov7pMO+zKGO7p9wMow5oL+mQB+flgoX
 RgklE28Ct41OoDi8RIA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEzMDE4NiBTYWx0ZWRfX/MQqZbvS+Gzy
 etUs/xCHf/qWmVvUT7R64IKGOhySjcnMIX0zucYle2D2rehC1E+xLUz8HfOu0bQBmdOxUniGENg
 Lw1fGV23bSz08jBbq6NpoWRLg9SYSvo=
X-Authority-Analysis: v=2.4 cv=Zsx4uN7G c=1 sm=1 tr=0 ts=6aa6a003 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=yt32EUx3BFOMUVNgjeUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: ZzmVE4qllAbHTRtWN128oiDfrMAK8Y9I
X-Proofpoint-GUID: BDLNBh2GfEW--t6G2CC94m6fmLXTBin0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-13_04,2026-09-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 clxscore=1011 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 adultscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609130186
X-Rspam-User: 
X-Rspamd-Queue-Id: CB6F7140004
X-Stat-Signature: pudxi9kkg9qcoez6439n4tmc63xkohdm
X-Rspamd-Server: rspam01
X-HE-Tag: 1789304865-144580
X-HE-Meta: U2FsdGVkX18snOitCDwmBmqI31QwO2Ml52vQP8oRdJ4rhhcy4B86RRIZ4fmky6i/VdpuZZtj/t44GmrLfKPQ9KK+P+0hoGN3j8sgMdiW2VKQfg9OrRDcLrMiP5bs+TjssNZtFwAwJCASUNqjrjY+u792wEHdbgekhLx/ksXB7gs83DAAfEjlSaeRjRD3nH9SvLL4f3SiK2Wa6+8hIkdjxlyED/7EozW3a2cztOhqNNd/SPHsw7pAEuwt5JPytLC15yBE8/O6ZD4DFulEc+CGLN/eUb7v0VJzNV4LDgZuIxhGpCWClwtUNbmZxXVrHHO5q+Dz1FQtE2RccleYzHy9+VJy3VwWfhEmUcyYOH9zFfXTEi7G9/5EK4xQDZS6FgQPPFo9U+ckZ2pAIhEBmqURJq3bs/c4Wn/E2aX2H4jL9XXKkPWazvr3urG485SzyeSuUMtWWLDz7pWsZBsgjPyWsQSm6XDggZxlSeFsmpHUeP6uIKuRXcxoTy0RpH+NbIsEs1C3CpJQZUSc5q0L1X1dd0f+7uanQTLSgKP1Orx/9b39lfwSIRnHLLDZBxFAh5yVOcbBYthb8rNabkjTAks5M53I4HPWCZZ6ohiIIFO9LfaPcAZBTLgdyikZXDheKNqZFKtIUV21F0ZuecRDA9GhCbOYzrP1Z9tCTOXvZEVi5zI9TlmIa+t4378AftyiymaOIsSFBadgRaieiRuaWn3qG/wBNX0hCAAUIoqVeV2koHZH83GlI+//zOyI1T8Rs4HcV6L3fd9W67s08k+GUPbquXmIrH1at4f3l9VQVsmab2Qo6Rld1S/3nEOK8DUB2t6+0r/WwtSQVJ5rYjTsaqgnyinyoyA7Lkxq+pU9d1wklJq38k4c0SQAXlNunR6SKwzm+KHM1v9LSjbZzKf0QpExG62BoPoTcEuvNyVA9hXcWS20jVcmtagMVoXboqCtvs3GjDNRFwU+kknzJfr4lcH
 0xRFspBL
 NXFJWQLsFnGU5r6aiBOilelmNatsU6s2r/XqVkO6TCc49wtqQP6vPIxBn2L7ne4+idYg9xWFmZiHf5RXF3x2eiqDJBEWL06EjOtIxOZ6nD3JirQceGUR97gSGGZT9UC4LEmMX88acgJM6ncuCoLHwSYqS5Qt/o40uGBevqTnJCOrSuwn0d42eWL0NjHQq+21EvQm/Og9gWaFEGLzZa+0aDshoB3BEg9j4gPcnsUk17+bTjmlIUDxkV9EWcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/13/26 12:24 PM, Yu Kuai wrote:
> From: Yu Kuai<yukuai@fygo.io>
> 
> A bio currently stores and pins a queue-local blkg. This forces bio
> association and remap paths to look up or create a blkg even when no
> blkcg policy will use the bio, and ties the stored state to the current
> block device.
> 
> Store and reference the queue-independent blkcg in the bio instead. Add
> helpers that lazily look up or create the queue-local blkg when a policy
> needs it, and pin the result until the bio changes devices or releases
> its cgroup state.
> 
> Keep completion and accounting users lookup-only when they do not create
> a blkg themselves. In particular, blk_cgroup_bio_start() only accounts a
> bio when a policy path has already pinned BIO_BLKG_REF. This avoids
> creating a blkg from the unconditional accounting hook when no policy is
> enabled.
> 
> Protect every rhashtable lookup with an RCU read-side critical section.
> Annotate the lookup helpers and recursive wrappers with
> __must_hold_shared(RCU) so Clang can verify that contract.
> 
> Do not include BIO_BLKG_REF in device-mapper saved bio flags. Remapping
> drops the associated reference, and restoring the bit later would claim
> ownership without reacquiring the reference.
> 
> If blkg creation fails while walking down the hierarchy, use the closest
> available ancestor and update the bio's blkcg association before
> recording the blkg reference. This keeps later CSS ID hash lookups
> matched with the pinned blkg.
> 
> Signed-off-by: Yu Kuai<yukuai@fygo.io>
> Reviewed-by: Tao Cui<cuitao@kylinos.cn>

Looks good to me.
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>


