Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E38F1C5DF9D
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 08:12:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C891E6B0098; Thu, 27 Aug 2026 04:12:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C399A6B0099; Thu, 27 Aug 2026 04:12:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B01836B009B; Thu, 27 Aug 2026 04:12:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87C876B0098
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:12:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 76F854035A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:12:08 +0000 (UTC)
X-FDA: 85146331536.29.3025C6F
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf15.hostedemail.com (Postfix) with ESMTP id 22DB6A000B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:12:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=auqNg6O3;
	spf=pass (imf15.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787818326;
	b=H61UCmRjMkUbiWqO91ssOqnAg5BUVvh4fqY6GuNXWVqTti+hTO4CEysQyuH2+vLCuMbYZC
	PH4U0s4QbXYBF8tGQovHoUmm560nJcdh2fUVifF3IZTHXUH7vYW9Fr2YfkYuRFYUsweBue
	jLmeETOii+7RE7CacQkcYVTopFwuDcg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=auqNg6O3;
	spf=pass (imf15.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787818326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=azSgAeer7HRO/y/U3A+QKwgdoguOntnnwySyUoZBNDs=;
	b=6PC3dnIaRWyuLamTzLYr417ZeMxJda7kpYBA1NdL9weYJX1vzG18YD2uT03rKOf4G/Qn0c
	8CPfO+fY4pP5DI1lwHuJEM3zI/q3p3XiI8MiqnthxMZDXlOQzZu47uzB2tzwAKAGv+w952
	bW0wN8pj3gzURXhj+aagSVvb3xahhbM=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67R6VW9L2209844;
	Thu, 27 Aug 2026 08:12:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=azSgAeer7HRO/y/U3A+QKwgdoguOnt
	nnwySyUoZBNDs=; b=auqNg6O3BoLY8+feEtcc2xFRkm19PMjBOKm4OtVE0ZWujg
	ySY2mojk/B+hzG6VRnvQR5FqMMcyiRUPZl//l9PFCmWGbqBIvQb68TfYOPy3hHo0
	uI4E2JUgdep4YM9uWwi2S4faYRFrGeG6Xct2SK5t4CIOxBJ9Vovb5prBt6arNOjn
	txhTKBurWez3SZQSbMe6h6dbsT5zIYUi3l7jnyW86B6mMXCdUWRNzHusd4mkBgD7
	Eyq5HvX6xRc2i132SvwUPPedMuj22HbfQ8a+2P8V1yMTxZj5QPVxJ1jqKUSMOxZE
	l5iHg/NFyCX4EEtowXniH9NMedHIPcmZALktczOQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g73g544a0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 08:12:03 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67R8BHVM003782;
	Thu, 27 Aug 2026 08:12:02 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g7ragprt5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 08:12:02 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67R8BwMf50201076
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Aug 2026 08:11:58 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4DAA02004D;
	Thu, 27 Aug 2026 08:11:58 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0884820043;
	Thu, 27 Aug 2026 08:11:58 +0000 (GMT)
Received: from osiris (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 27 Aug 2026 08:11:57 +0000 (GMT)
Date: Thu, 27 Aug 2026 10:11:56 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com
Subject: Re: [PATCH v7 2/4] s390/mm: Batch PTE updates in lazy MMU mode
Message-ID: <20260827081156.3869103Abc-hca@linux.ibm.com>
References: <cover.1786956464.git.agordeev@linux.ibm.com>
 <d7fd78377a7278108ef501cf76571e80caef5968.1786956464.git.agordeev@linux.ibm.com>
 <20260824104048.11040Cdc-hca@linux.ibm.com>
 <73a0a916-b39f-4ebe-bffe-448928b13bef-agordeev@linux.ibm.com>
 <20260826130257.21444B1a-hca@linux.ibm.com>
 <87a3147f-e993-4629-b0dd-a54aefbf20b1-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a3147f-e993-4629-b0dd-a54aefbf20b1-agordeev@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: RMz3UEJ-r8qieNoHL4ycj93WaDCZbMla
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDA2NSBTYWx0ZWRfXxDOK4nNPsJ0x
 N8pNfaJzpB9X32TcR8mWrpXp/Px3HuuZuYx1BsQm6Zy8KPzmK6dtck4yDmQygbewzt1gzBQnROc
 0IQgPcFHarz21BoDZ01g3zdkD7F6sPk=
X-Proofpoint-GUID: jmFqgWxCJxbuJbgYxAqSnoMOcsSUPEsa
X-Authority-Analysis: v=2.4 cv=JZyMa0KV c=1 sm=1 tr=0 ts=6a8ff153 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=tYSU0nxKdXOZT8UyD_gA:9
 a=CjuIK1q_8ugA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDA2NSBTYWx0ZWRfXzOMYH3+JQgpk
 SERRZa/ETk+hqzm3M4JrFS+PKizommTCwb8ejt4dfPqJ9knc/mfyRBhYVQtGnYz+Q83ta4aeJ68
 XefgdioHOI8gqY8HC3xA//2gLsQ18py6CAWYAwMQ7KBsmfDuS2qNt6NhZmDgARLfqN7YlGXgPS8
 IXo9YUgXe8QjEpsxJAxaKye32U0Ljn6NeQK3lHmH4kaYhkq03wZUDw/QuGqLxn3UAuoJwEdX7sO
 UUkO3aHlHKZvm//sNZauHXP96H6yIwQqKoyZiV8zPGTm31RiCLxtzXdO9OpUCtlgA+hIsJMqevQ
 Dexqa8W5PlrVQjJOZizISywylE3D7PhTIHL4QdkMxbhPehw5DVwANokoAV0IJ7gvbcATviLqv/3
 xFwhu8doL4RX7BoGC+nF2BWNwi7URtJvcolHpHf/IFSapfpCzBAHhsqijbOvXmFB949LWPM3FTl
 O25+Hqzwf/gsZunLkqw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_03,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270065
X-Rspam-User: 
X-Stat-Signature: 8s3xs851em4h99yajyyz87pmgfhrqdfd
X-Rspamd-Queue-Id: 22DB6A000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1787818325-442492
X-HE-Meta: U2FsdGVkX1+yyxenxDQ7L50dH3Mrht6GJr9yBGUYPcDAL7D2GkJ4U1TNrTSi1ad63uA6MJFZ9gDH9/nyTMLnd52qbcW+VJq1UiVGnHSk5UQbbxE2GKYsM1xH0DgPUyDd8jDPiBQoBCa28gEFD+UZ0nH9dF3dlwgTXpxRCvm9rwlJ1vus23Jlqmq6zqxMvNEL6UvK3dh8USiMkIB7NNowRlUTAVbzmcVvJ0g9XB+Pz/XbiesbIXiC6XogXApp35Acj+jYa/S5759BYMnvPtYwP34nHSZoFj/eMfZGV6A3PQdW4X6WpS6D4nFBnMjRUdhwU6WGBmVccejvf7WbV9KZWNQ7dSyshio/zoH4cJOb9woP1Fqtq00IpziJj7vzO4a08I0MAhfjuZVwx9W2G0JgXLHc4jBAh4oW9D9+9kI50yWmDPLVRELnMPB/2/nwLNLEcybQuZrn0C9tKosexOs9T6bwBABfV9itpxQCSsUNaYYvJTbwqr8zVfTUiPtPog8K7lniKeamk3XDXc8odmz3EVaVA9n2b6s2EKwCRpFcuZ5P9X9K6P2JNbHb+eb4izpN9MclEiphAiqdv5xOm5Fw/uMh5yJ4XT+sXYW0yrFXkwrMSjc5RcXjNpxEN59cToyIHo+tzeE/DfX4oPN0/2kdBJACTCEzrwQoCPSpnwRYB2LNBZyAhkq8tBfuCMmWrKxDhuP1b+hBeATRXgpLiAyN/ViWJXtSHsHFiaFdL95FnLwEOef/MFpbGxxU16ou5JYXWZlLXDVPcpqy5VVF8Ml/O/RrVjAMTk8GoieHBqkQr/35jeX37YPlZowsUajXxCHN1QWmA+bTY/xt+V+On/GPhdojmyqEXebuVWbHKZGYJkavWznZiF5g3nLnouPY/WyHtbgvwv6pa62K8c9SgckabfSq7unrlcHAdIKbCPCPTxk5t5BBZUvuyPyrKgUg1hdf90eoZsWyZxtQg7mKgdc
 doop5bf4
 6+wUOsqi2VsweZwy4LcUlgtPjOBRH3lyPGo6Puzayso9rQlhTHf0bhajbU3iCUEjVpHJyyio2qi8bTRqlCc4qSVgMdjhvDen2poUrFA/V1waqn9ZNAGPuUiwY7b2wjevS7MyHM2QxyC8+fbncYk7PziavEYE2mUb3puJBuTRmRnFVWFb/alkyko5Wqwr/o3Ms7oTnoznfIZoZEDq7iq3LkYRoURg5cC9GSMCjdM/6Ea3E38ha8mJOTz8Uz3avoQwfF2Ee+JGDq9wZz5mkaRczW3+1+etMzEU1m0hBej8U3A2SOiM0TkmeWbMJSGI+0hzJbMz1Hoq0AF6ppqH5yvog1dxQuPOrh8Wgt59uvxezxPx4ZZeq03psJV2lPGr8lNeTEAsVJJurH0IXV0LYP9FKeaBRsqcRjbsAd8KJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 04:34:25PM +0200, Alexander Gordeev wrote:
> On Wed, Aug 26, 2026 at 03:02:57PM +0200, Heiko Carstens wrote:
> > Would be nice if we could avoid the not so obvious local_bh_disable()
> > and local_bh_enable() pairs.
> 
> Calling ptep_get() from BH context was certainly unexpected, but the way
> local_bh_enable|disable() pairs are used is actually straightforward.
> This is a slow path anyway, so I would think the simplicity prevails in
> this case.
> 
> But again, I will try to avoid that.

I do agree that ptep_get() being called from BH context is not what I
would have expected too. But then again, nothing prevents people from
doing that from irq context too, no matter if that is sane or not.

Imho the "final" version should either be implemented that it can go
without disabling bottom halves, or, if that is not worth the effort,
even disable interrupts, just to avoid other surprises.
Plus a comment why it is needed, please.

