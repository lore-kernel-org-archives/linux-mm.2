Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D84CDCD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 17:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 256A86B0005; Mon,  8 Jun 2026 13:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2076C6B0088; Mon,  8 Jun 2026 13:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F67E6B008A; Mon,  8 Jun 2026 13:19:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0247C6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:19:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AD892A01E0
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:19:33 +0000 (UTC)
X-FDA: 84857407026.29.5E28410
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2FC2C100014
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:19:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UvkMWN8K;
	spf=pass (imf05.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780939171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DBoyFy+ciaxzSZRoZcPAmZj6N0IP7+wC188AvkIvM0c=;
	b=vp9ds0FuKf3wqHpiPe3TYjdYF4N4oqLrxhVtgjnJ6UK+//hzzFC+lIcmsRyI82qahn1Jzo
	yDGA6+wKEMvZLbs3FcNGWMd46N68s46CrsPfXgNbE4fbKKz00h6kUIX6Ja1nDnj/49/AIL
	m5zaFRXHG4VxN3U6mVQXlI5o5oYfsDQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780939171;
	b=FUUNHMHw4Lj7kwKnv9w3Ktv/ttpGNmRNaw3ynhEAKTLFeno+Pw4fPc+8YgORqOO0AuuiHQ
	gjeLs+1Pu8JYFqa64rD8mpo22CLyAjrQ0Yf0+4EVEqdywt8cBMZd9BGbCdO9H2f9fiAstL
	NIrpbpLs245fkwaKrTR/VEOi28xahRk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UvkMWN8K;
	spf=pass (imf05.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65898RFG2767293;
	Mon, 8 Jun 2026 17:19:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=DBoyFy+ciaxzSZRoZcPAmZj6N0IP7+
	wC188AvkIvM0c=; b=UvkMWN8KLfEzxmLpZ1sY2LmMpEnsERZql/SZu79GcacmVG
	nJ8RDAA/EWJu0QTBT9I8rhEVGVjsvw491qHDLjkWbtTj+G1ErEbNucmYNgefck3n
	sXb71UYeyoOJ3iHb9uGTlQa1c7zijbhSwJ3CbUZLqUDhfodU85OeYwZ9H99mdnC3
	r3SaOq0YfnLKUBrzEI/NDGMC4tmmsMbWreWWLpwy6XtaZOHoNm/OFg4ZwV0/I59G
	4KkrTmCjUm399k2RFD4LQ1FZWu4IhVjrWGpXHlQ1bMOozcExaJDEQwFU+NbG0yrW
	VBNpihqdOr0erSNa3EBLl3w2maw+J6eaZD+zOt1Q==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4emb23rg7k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jun 2026 17:19:21 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 658H4d0F008374;
	Mon, 8 Jun 2026 17:19:20 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4emwvpxgua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jun 2026 17:19:20 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 658HJIV950528622
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 8 Jun 2026 17:19:18 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A157720040;
	Mon,  8 Jun 2026 17:19:18 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 52D852004B;
	Mon,  8 Jun 2026 17:19:18 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  8 Jun 2026 17:19:18 +0000 (GMT)
Date: Mon, 8 Jun 2026 19:19:17 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Askar Safin <safinaskar@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
        Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev,
        linux-s390@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260608171917.3195488Afc-agordeev@linux.ibm.com>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260531010107.1953702-3-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260531010107.1953702-3-safinaskar@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=b4uCJNGx c=1 sm=1 tr=0 ts=6a26f99a cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=pGLkceISAAAA:8
 a=hJLVOhpQ1X8ZOlOX64cA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 3tuSXdak2Lf5xEGsGyO-r87wQWc8i8Fn
X-Proofpoint-GUID: j7w4f90-NzR3nJF25rOJJ_HWDzfwaa30
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA4MDE2MiBTYWx0ZWRfXwxgojXL3enTK
 T61FdACtj+lsvXJkGTaZ1LMntG/SQAyNxsqx7qEQDYTGBkhW1iVkn9xU8IIeIAi6Kga5+V+7UtL
 iYIpMyO4DXfaAYbvQTNintFAu1aBmf88vRo5JGUI7xPtSdf7U27HnjHgKO1xllzes1rUkqEpRCY
 0RK4JOOXoKptl9erTAE1uuredrMJXx2/J3b8CwV3QH88pSOZjm1JTRh7dN4oJ5fYs3VruCq4RYL
 2GY1JMaYgK0/dUlN9NXbxIFqt4YJsSuPxljFE7Bpm3cRD/BP6J0hZfbb/hvkJTaEqdRiJhiqUNt
 cKbtnKDwPQnTxeaZT9RKCKFsZf8G3p1shpV729SHu0m/RmJ3eMXqf/h22pjUEdP+tdOuVgJjWP6
 hcZnF3TOL6+y6UNOYsSgIsXQ8pphcaCfchOhsJ0XFT6pCWKtZ5yLbG8ytOVO04FBxbyXDcZm48B
 UQ2ogQT/HXxlK2bArQA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_04,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 spamscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606080162
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2FC2C100014
X-Stat-Signature: hfg1xtgsp89pk6cj8upp7h1c8dg9m9f6
X-HE-Tag: 1780939170-346779
X-HE-Meta: U2FsdGVkX1+EvsH5q2/a/2NrzJ3/v2M+bjbovszax7qOBj/vVCCOXVk7FkRTnYn33V/fekFNaWGHPPZ4MssjZkygkp5QLudbQ97vH/2rTspu33oa2aWbievD1MaqD85Tx1RZpNaGLykE25TuYjmXWM358s4AtYqhopVhgQKuztxKh+Ab8QdPHYOfRhpk6AamUNXsi+BhNuaWgy/cSW48bo7wqEvJulu/STZnX/y2mNY2/6/FvqF/7H3fvRGiBc7tFLpnjdCSlRM+bHjSGMntX2AXvhWpqn4AP0xSJaaryjJ6htljSdWNVyGWnm8+lumdPQUtUV8vK0W3EsEXAhLZ+AyUpOPsmw0a1SxaYliRdxX39AzyNFqdERTJ2jJOq7VXcxnrnq0wpAdM2nDpQ6/EyU3UQmG+mjkdigiCHOzzWNYo4A8UjJImASN/sV80j1+JaAOB0viHjYxi7v4vzCvVhd8UwPrehle4nffY+/VfaXK2G0iiXuaMQ6x8jCizPp4iF9UnGSidWh51ksnJBeiMZGr1YpxeV9NNP7yekQDsamkJ10IEeFzM3XAwr8/cssEpx1nImTU4bwnHBOz6ME1YJYVLCO1k3RZYbnOfcGk4DDl5dr+UwX4dTgoI/NfYzyvSvGmZCmjS/S5FHRm64ZPR2u18FjRMILDBgRjLihxw4S/P6w714yt9mykWnXNc+GB0RDznugyALXNAY0cEE8HajqF3pjaMIbyRPYHnpH+qY9VGY/9rrN1KGCyKg/VuKT/Esdp8L03XKJV5QySdkGwXh1hOBypQVvU7ZIK/sC++UMcEyUOrWiNazjBlvizYsdDDMIuyTQltvaTHUzBpqhvitYDsdUAmWuUSs+85sKcH5MUfMUJoOZ9AjrZSFGMzRZ7SvX1M28B4HduDkL9X4fnMdJeCzJ7Fw/wUgWCx2S96yX+1WR8RT5cR+ddYfZBqd40B3QmF/nFvmjJ5R8kWME3
 bNEDoCx3
 D1QifUmr7BR+KqKO3tnoH6folyd4hCqoNca7T4RFMcEOzp3hEg2540djT8HM/MPo8r8m34i4Kf1E0NgYkh5cDRPx772aYbSpKtSq8m5mTVNl1Tls2BpirrF5SueQV86Le1t9xNwoOgOBZalvwlmImxP3dbUx1eMmTkQd2U4A9nXgBsEaWx7Z07zsztHdsVveQWA0sOPAHQ3Zpc8DuTr66xi4pGDs2aUKoze/+gXDPl/Xq8S1MmWb08GuXh/zTM2au+aMh0nHAB1QqVwyUXF45SAE8FVDlSXZsPx8gg+fzM544IE1T0KiKwy6mfxr491MjCWlYaNukghlCv45ummm3HaWAhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 31, 2026 at 01:01:06AM +0000, Askar Safin wrote:
> vmsplice behavior on writable pipe became equivalent to pwritev2.
> vmsplice behavior on readable pipe already was nearly
> equivalent to preadv2, but I made this explicit. I. e. I made it
> obvious from code that vmsplice now is equivalent to preadv2/pwritev2.
> 
> Also I moved vmsplice to fs/read_write.c, because now it arguably
> belongs there.
> 
> Note that SPLICE_F_NONBLOCK behavior slightly changed: previously
> vmsplice ignored whether the pipe was opened with O_NONBLOCK, and mode
> of operation depended on whether SPLICE_F_NONBLOCK was passed only.
> Now the operation will be non-blocking if O_NONBLOCK was passed when
> opening *or* SPLICE_F_NONBLOCK was passed to vmsplice. Previous
> behavior was arguably buggy, and new behavior is arguably better.
> 
> Now SPLICE_F_GIFT is always ignored by all 3 syscalls: splice, tee
> and vmsplice.
> 
> Signed-off-by: Askar Safin <safinaskar@gmail.com>
> ---
>  fs/read_write.c          |  23 +++++
>  fs/splice.c              | 192 +--------------------------------------
>  include/linux/skbuff.h   |   4 +-
>  include/linux/splice.h   |   2 +-
>  include/linux/syscalls.h |   4 +-
>  5 files changed, 29 insertions(+), 196 deletions(-)

Hi All,

This patch as commit e2c0b2368081b ("vmsplice: make vmsplice a trivial
wrapper for preadv2/pwritev2") in linux-next on s390 causes the selftest
tools/testing/selftests/mm/cow.c to hang:

# [RUN] vmsplice() + unmap in child ... with PTE-mapped THP (128 kB)

Recently there has been changes in THP area, so the problem is not
necessary linked to this patch per se.

Please, let me know if you need any additional information.

Thanks!

