Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D42C0606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 10:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=Bcbg/1s0
Received: by kanga.kvack.org (Postfix)
	id EAEBF6B05B0; Wed, 18 Nov 2026 05:09:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E87476B05B5; Wed, 18 Nov 2026 05:09:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D79666B05B6; Wed, 18 Nov 2026 05:09:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ADB226B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:09:22 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 84AE04050C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:09:21 +0000 (UTC)
X-FDA: 85447817322.01.71E57BF
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2583A40004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:09:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="Bcbg/1s0";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf12.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794996559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZmVqOTHxTktTcU1qGgWrv5Bi4RVG456/6Vfq3swBUc=;
	b=XQCw5DbQiy5tWbWqo5f3x3DIM1+Zj4RBNWqj/4AQ4aZy+6Th2q+i12RohBJLiUAXoA/B72
	l7oWgnLshnCG7mEYNjd/CtLw7mVsUuMYg79YzMCbUP3lEH0YlQWZU79Np5ITU4gkBem5J0
	SzsPZ0MBvNiLSN+JtuzMs2BIWYvjQxY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="Bcbg/1s0";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf12.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794996559;
	b=3dCbrpbD7ksMeOCKO/fKvGGpJZEGlOgWmpK9ksCSHhElG1x19+RS2FfbOGkLoxAMkf2kiK
	RfnqRDOzNS9c6RVYC4uju5NzJqNia7ukGJhvpbOZT7u5unLTicZ4h4GbxXAMR6QEv/tUUg
	/nnjXn5hgaZZLVKPr5MbG8QaPtmVmi0=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AI9uNIE3354313;
	Wed, 18 Nov 2026 10:09:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=MZmVqOTHxTktTcU1qGgWrv5Bi4RVG4
	56/6Vfq3swBUc=; b=Bcbg/1s0GgB1RP+bYURvuotiA2w8Y75Bzqyt5qLKKiZzo2
	LDNvjffwdVTfd4XtKdwrkWjig0tX4LEcBZIIK3gRY0wiliR8+Bf7KuoPs+DHuWLA
	jzlf0wKaIrEpZitA8GI8S1JD5Ng9CSUyKygSgDnksd0tHvliBqIrCNNnJEbdw33G
	5RjhaZTTG5nZs3XNzfaTe9ItXqS1p2os0B9ej6Cb6ftiG4YVtPTpdysa7vlOFAI0
	wFTNflHbWbW91X7wQphs4AwOi59x47WqZtlpovRtRTXvrloBF0xT0i+Rp42RnUwb
	yB3C+Tr2b+7w9rpxVJAcwUfLsYGwmmK3ZC6BaQnQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j105rhwjb-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 18 Nov 2026 10:09:16 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AI9nx8p1832149;
	Wed, 18 Nov 2026 10:09:15 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j17c4rfvm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Nov 2026 10:09:15 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AIA9Bcx15139110
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Nov 2026 10:09:11 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A6CE20071;
	Wed, 18 Nov 2026 10:09:11 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5038F2006C;
	Wed, 18 Nov 2026 10:09:11 +0000 (GMT)
Received: from osiris (unknown [9.68.31.201])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 18 Nov 2026 10:09:11 +0000 (GMT)
Date: Wed, 18 Nov 2026 11:09:09 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/14] s390/sclp_cmd: Replace page allocator calls with
 kzalloc()
Message-ID: <20261118100909.14542A04-hca@linux.ibm.com>
References: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
 <20261108-s390-sclp-ready-v1-10-3e7c90eb6676@kernel.org>
 <20261116152216.165348Aa5-hca@linux.ibm.com>
 <20261118091126.25efaea8@pumpkin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118091126.25efaea8@pumpkin>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: uBfXR2dxc6PwfwtKlUHYdBmHv4j8jsO2
X-Authority-Analysis: v=2.4 cv=e8uT2qp/ c=1 sm=1 tr=0 ts=6afd794c cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=uEPgcOoI_TXTlIU_0SwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDAzOSBTYWx0ZWRfX1PC8daa1Jvk7
 kb7SppLX7bDgSgLGDXrqWZvoZjaZsy0OBNj47V+QkvMFtEpy1upJVp4Obwkcjmc9WLP5xKvkFuR
 3Ccg5XihKbJjdILw6E7cdQYLhn57gjo=
X-Proofpoint-ORIG-GUID: 4mmnc0ttL-ybd-Ur_WVKaNC63vTULTZU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDAzOSBTYWx0ZWRfX1ZOHf78Ow3Bn
 a11wztO6vKtFxp1JIaE8QMgqv1fumQWjCsBqOtQUsXKafPyBfUt38EBju3EYnRYvi3y/z0lcfkQ
 Pq4lGYm+QUbB37Ftd/xSUmxn6yEgyWTe68+0z17WwCyDyp8fpKDa09d0z+kNh42cfXxxXpfCdjO
 P0J+ehhP/UFtuTN2FZakVZENsCc/2U/U0GklBYMYGmGoGJo7jSIOCZCsmZorSJPEGPH2c9pdA2H
 V/sefKeyBHjuLWfLX0aAM6nzraJHWht12H8OLYR13GCa/ARQVr7plfQi8dGdq/9rFrw36JC8Vp+
 TDp2oc2RjpsRN8/g6htKrLHxVi3piWerqADEhpQ943xwHyjqL3nJXYbb1MPTQiD5aGzeiChSpug
 XEyKKIW1USy+PxGvfjjETYWZouTucb/Nu1kY1HzuvQ0G1fcj9jekfy7JZ4rvY0KIK4r0FnXGm24
 c0zfyp+IezWGn/ovfSw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-18_02,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 bulkscore=0 malwarescore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611180039
X-Rspamd-Queue-Id: 2583A40004
X-Rspam-User: 
X-Stat-Signature: hid3hj67yf63gofnttqyq1u4abe9czhu
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794996558-53538
X-HE-Meta: U2FsdGVkX19wX5S+XlRkNFm/zk35HHhYlrGdrA78t7tiRYw/jnibH8Xbz7zhee76qW3kGyd192gBxYpOCqqTO2ImwYmKQGDw8tSqiFS9eAbFN8lwL19gjv3mubo8fm889cJZ515LS0mg5YT8xMD+bFvl9LggIgWRCZHTj2BNFNDq0A7tKi3ZliiVxTaxUUwR9Q+ZzQ4xkkgJPVSkUYQ36lFO1GUutw4Kxa49bvIvrbYMs9aFRiLOn4hysJR7P5Yo4ps9KrCoVb3CCG4KsUexjmJkd2csh4r7WJB0WZGPjmRii5bRD/TtZTroptGdB1YgrHC4243pBkpa1jY3StEFbgbOjqqggNHG1HQajhNtAu/c/a+QG0nbN6Lub3fWaZeYOePJvFgSGoeNTjvodoylRprvrQ2KZ5x3Y1EjBwyrGWlQQ41RLgbaeTawaKj0nDJSU7u9k+5PmwjEIkfI3t0qR21PhbHKUpcil7ih0NlSywOWHSRVs1r8R1GtCGoCEpbSwkUh+3KVMAiaUZnF0waZuLNrztyw8iZrlhBczNP2/KFqRxjNexVfTTRJcO9H8V+l7H+iIInx1NCBcdcpqI7wSQDnR0+NLgYwBlkWfpavHFYjfjqnASWF+hRcStwEfkhDaET0/JSKkoXprNqIxqFt6fBFtaB+U9qvQLikefCzl8J3/lUzrcGt8YoIeRztiij/Hdv5oUET6UKSbjh5mV6+rZ6uN0eJtuxjDa/GLOKHSZw5lAhyJz1jIjqt+nB9bYAPAZFauTZyyUx5k0BgHrb2UibKg04XWwLnA+aO82pmki9dCNXKGwkvigGPXnJ+DIQrCicU44JzKFwYPhy8+qIiX/AYyULyALRfoxOgyvjeAZgRbbOtFvvC0cAPKg32HYzfszxjV1sAodtooaS2V7NOp+uFomNQbk6zNQwf6BupZj7l3CZFcusFQ23tK9Zmi94eaziG42/6pb0V40cqBWJ
 WV/LMMR4
 PVbhmWVIv+y00PpJEIC7nNhLRnkxGIQnMdJAcOQjTHyoqzlbMaGxSBie+18/qQddJ9Pa9AhcLeNUkJCyblCafueRLgAuj6UaZKH08FWSaNBjG8dxESIdkgPcHkgtptHdKU0b8KoibZFzxbcb4l4J8XtIkioANCEzwMYHxcZLhI9TAjTK7vVf9EFEJBqYnYOFPDbktyhVclGO0PzA8XJNDIyvc7fOYyhizbDbB6uCt6S4eYLjHSrXr6t5glTEY2wBL60a96kAf7Bbu01/tAmtQqOWQHlMuBIQwwpVu/PwTyTpcvODpZoVV99vz6hUlLRPVmuS/ZLqlI8NZZ2LP3sR9Wnxzrcr8dvLKmbFT1QGQByi4TVquhn2XphkZ8Jfq9wNsGjdp5h/3P0JTT1JG9a4ZzFzk/CZ2heLOJKag
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 09:11:26AM +0000, David Laight wrote:
> On Mon, 16 Nov 2026 16:22:16 +0100
> Heiko Carstens <hca@linux.ibm.com> wrote:
> > It is a bit subtle that this really works. EXT_SCCB_READ_CPU is 3 * PAGE_SIZE,
> > so we end up with a guaranteed 4k alignment from the slab cache, which is
> > indeed sufficient here. But this is really not obvious, and not as stable as
> > before, IMHO.
> > 
> > I'd prefer to have this changed to:
> > 
> > 	sccb = kzalloc(PAGE_SIZE << get_order(length), GFP_KERNEL | GFP_DMA);
> > 
> > which comes with the same alignment guarantees as before.
> 
> Would it be better (more obvious) to round up EXT_SCCB_READ_CPU ?

Mike sent already a new version; this is now good enough.

