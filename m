Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E79C5C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6B516B00D5; Mon, 21 Sep 2026 05:28:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1B316B00D7; Mon, 21 Sep 2026 05:28:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A957F6B00DD; Mon, 21 Sep 2026 05:28:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7910D6B00D5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:28:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D35ADC056E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:28:00 +0000 (UTC)
X-FDA: 85237242720.09.6CABB45
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf16.hostedemail.com (Postfix) with ESMTP id 61969180002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:27:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LbpNXzuF;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf16.hostedemail.com: domain of nilay@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=nilay@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789982878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G1939MElcb2kM01/7HPbHzZLx6pN/KmlSSE/eI9FBUg=;
	b=ve4+7zd1O+bSztDop0IBQMk3ttY9/zTUmH6rmN/PTyyhDubuQ7Pfu4288IWheMhBSqstyq
	wMPkNad70kcTPsgyahWA8uK1RR8cz9o8cVk0Tial7ZZusEv3NwkOb7VaVEQKTXWNy+1JeS
	dBftdk/sK5aKCfI539uXoR5KHOQRL1Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789982878;
	b=vxRlg8uzjJzSxvaUftw7hL3eECX8DIY3AT2gOLYAQoT4Yc6tPGYw01iwbC85aOdF7QS73v
	7dryZSY159yk96Od27+zPBNa+rdjt6No7z3xSJnViMwadJyksxbj8YpUSMXwKCYP2U7ho0
	+1XF2kY+sYvIgMPZjb6E4sf78aAm8jM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LbpNXzuF;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf16.hostedemail.com: domain of nilay@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=nilay@linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68L7ZbnX672354;
	Mon, 21 Sep 2026 09:27:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=G1939M
	Elcb2kM01/7HPbHzZLx6pN/KmlSSE/eI9FBUg=; b=LbpNXzuFadRu4xefU1BRaQ
	h06fCzfQKzfgJVO+GdlysRBuw3CYS0h9INHzdvY3mycdGE8B4aCXmajbflhXM83m
	ptcP7kCNPw7U5yE7EQVhYZbolmvC65PE01R+sPRX1TAwDsp3zu59hoqOFt/AvSFu
	5pqA8S4gXwqDoq7dFjtx3V6977yRg6lME+gwPDU4gqT+I3OVD5aSSVh7R8w6dn0T
	kiKHMCbbohscsdNiKn1Zx2pPlBr3PIYgVRxD/D5LlFRG64591dn0jOnilV2QvhBv
	bToDpdeuPAeQZrnWFVRBLnCUhYPuTDfHfi8SVj+Rm2GBZJhlYSmRWoRw9xze2Cvw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gske17ksg-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 09:27:30 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68L7HTui924403;
	Mon, 21 Sep 2026 09:27:29 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gt4qq4sv7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 09:27:29 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68L9RTIS62783920
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Sep 2026 09:27:29 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EAD7558063;
	Mon, 21 Sep 2026 09:27:28 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F3D55804B;
	Mon, 21 Sep 2026 09:27:14 +0000 (GMT)
Received: from [9.61.138.180] (unknown [9.61.138.180])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 21 Sep 2026 09:27:13 +0000 (GMT)
Message-ID: <37de70f6-67f8-466f-a267-03584973dd3a@linux.ibm.com>
Date: Mon, 21 Sep 2026 14:57:12 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] blk-cgroup: store blkcg in bio instead of blkg
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
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
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
References: <20260920092351.2434283-1-yukuai@kernel.org>
 <20260920092351.2434283-3-yukuai@kernel.org>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20260920092351.2434283-3-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: -Xd8a0RVEhrxDFm6gn4h3GOonDYckOi9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDEzMCBTYWx0ZWRfXyA4xNH3cYzqc
 l3LhAHGkDdB9wr6wJVvzkOiW0PLTrY+6N2xnfwVvAXBEgUZUUlnqQoZ9S/t2ec53rKELusYcvWT
 di0gP2G3AgYQrqIZGwv4XAk6ZTbicrvfmdi3M2UDvbThVuKLxf2bVg5EnsFXBr4KXrs6etQpgoD
 euKLu2Q+XaIsRVuhlHm+asbpr7zvK5ks3HxoZmC3tfKIKTo9gLj/L+nXXm8Qa6LpaYS6fCQWKwA
 rPtKbOsDw0UQzNsyd8H9bnPf3SqR3/y1I/PXuxjss5kLLxairvDG61ZUizIHrj9aHnJa9muRUGp
 7oMtV5GSfddGruww+e3uDCJcaCC0OqzGH5jLo19DzokCNvtkRFr5gRuQY3TQAjpzacqfLjYt61q
 p4U3ri+iYIaoZm7NV0kKr27cQE0po2JDzt0VLOolD+KbjSIIi30aCQOJhnnHY4hngd24Su44C9I
 iTTkkhvJogiX4hApA1A==
X-Authority-Analysis: v=2.4 cv=O/KsLx9W c=1 sm=1 tr=0 ts=6ab0f883 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=yt32EUx3BFOMUVNgjeUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDEzMCBTYWx0ZWRfX5rV0t/6BeebN
 XqLIK4QGbSN4xT9UKi23paOxlW7Ykt3xnAjLGUCmr0jYvC/s6nTF8lOI7DuZlUqbCJZ4FsSaWjL
 tAtASM6ortzkp/bMC84v/5e+hKTSbak=
X-Proofpoint-GUID: STTiMO6o3fOhik_S7E0XjsEtuaK9UoBW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 phishscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210130
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 61969180002
X-Stat-Signature: 37ucem8gciman7hkiuyo7tq6k4rme6fu
X-HE-Tag: 1789982878-629510
X-HE-Meta: U2FsdGVkX1/m39BG2dgN/1B212cSRCiUA0BRc//cS1b9MZ78HoYzFjlKp7AYi3efdWPatkV2tS6I/2d9FaqltUS3E0KZEU/yt+SUX4GI3twBdSNSq6E+YUz9HhWp297HYlFWPpxrAiavA3iB2hN1U0mLLcBFf4lR02bpxMZ+RkWpz6Qh2cpPX9Q1OO4jxAe9t86DnydSId2zHe5k2evMmkAQzrRc6epJYacWwtB5ZzNJdxV42LxbwP3KJ+ugeOedvjXhacfWU9xjAVitADb2EqRN1fbQsLYsE5SDA8xpGehFVgg3FzyGm5hS/62eaHHWt3l/MpPP51xRJJlb873V+q4GWab9Kqb4hA8C2sxwW0Rn0+ycWupKUrY2SGPoBcIMluUX/5jzRpAe8Zfca10FqfeL/PED9VKy8bA0y7kV9DH1PNkqBTf7kq1M0qtAO1A3V/dM2ACkWEV2Hrqyf5j1R3XiugNay6iizwYhpVcc0BE+o9SXfGXILjsDeYlk3kLyCrgfTtl5gUeiTMel+kEOX5A0BuL5WLTQtnRgNCJDdvL3mSURyiMVnOZWjny7g2u7jWZBDVZIL5b0GsVAIs3QT27nzFX1IvRkHzL2bVDJuwQLjMfS/f/yNInlwvHfi0CwDpNo79theq5xG96nP7/4By2dgjHNf/HVdvDcbmi18X0nGgbzgyMmsVOFFtqk4q4OXJN5mPb4dCg3P/z3D0kIQlQzfeNbGypW8Rz8/QgzMoaowrjTXVHRsoXXN8KnqBOR0R6rQqAEF1dkbTwjyyPN6sWLnDWqNGXpcwRV7RqyccA2pOLq/RUVuAy1uNH0N9/7Eh7BOiqVozdOtivJATYH+ebhhh2eugVxOPVkEM0i4ZEvmxP8AUOZzq+cm+2R8t6hbxj9ox5vVwwfbdpeDPVh04q552B3b/K0cq+orMytTfeqerJ2qDu6PayRf3TqMB60xCP2vc+Q7USdI1xRBZ+
 GkEUz6SP
 lL+1oEFSkgvfuLy5K6woZ3Z4V7wbT8Hl3uGdOA9qb3Wt81DuDPpeZeHkEBuoalbhRTqLf7//YJ0q0XIIy6r96FAvFA6W/zTIjEQT8lUs9B1sPNcFYGq4ww7uB/UwyciKpzm/XxC23MQ+dj1GBhC27NWXr8mvywb39o00gHfg361zYl6GAn1Wbp/iR4RxxNhZFFIQpIyMragZiMK80o0YVr4oWAboCBfoyYJ52q5tQHl7mXYcQ8i2ETm1mV5Nrpqoo4Z/OpkXxpAO+l+eYTL6gwSPZptaJJIu/EpOCvPP9ffs6rtf6E6vYvqqTXFLBgD//OaSPA59Hz3nFtyZRtCCYXc188Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/20/26 2:53 PM, Yu Kuai wrote:
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
> its cgroup state. Look up and pin existing blkgs under RCU, taking the
> queue lock only when a blkg may need to be created.
> 
> Keep completion and accounting users lookup-only when they do not create
> a blkg themselves. In particular, blk_cgroup_bio_start() only accounts a
> bio when an online blkg already exists. This avoids creating a blkg
> from the unconditional accounting hook when no policy is enabled.
> 
> Protect every rhashtable lookup with an RCU read-side critical section.
> Annotate the lookup helpers and recursive wrappers with
> __must_hold_shared(RCU) so Clang can verify that contract.
> 
> Before entering a bio-based driver's ->submit_bio(), drop the pinned blkg
> after blk_cgroup_bio_start() has completed bio accounting. blk-throttle is
> the only policy supported by bio-based queues, so no queue-local blkg
> state needs to enter stacking drivers. The queue-independent blkcg
> association remains attached to the bio.
> 
> If blkg creation fails while walking down the hierarchy, use the closest
> available ancestor and update the bio's blkcg association before
> recording the blkg reference. This keeps later CSS ID hash lookups
> matched with the pinned blkg.
> 
> Signed-off-by: Yu Kuai<yukuai@fygo.io>

Looks good to me.

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>



