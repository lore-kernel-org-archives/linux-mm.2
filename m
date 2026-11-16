Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9441E606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 13:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=iH/vRTNF
Received: by kanga.kvack.org (Postfix)
	id A04EE6B00EF; Mon, 16 Nov 2026 08:11:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DE146B05B0; Mon, 16 Nov 2026 08:11:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CC6C6B05B1; Mon, 16 Nov 2026 08:11:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A1FD6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:11:13 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9D87E1C3DA4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:11:12 +0000 (UTC)
X-FDA: 85441017984.24.8C24975
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf09.hostedemail.com (Postfix) with ESMTP id 43E1014000E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:11:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="iH/vRTNF";
	spf=pass (imf09.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794834670;
	b=XaL20ZyHGjwJzvXKBsAAjYtNet3ds1QlUFwY5/HILstH5X4LYjTNCx70Vdrx5AOxsZdu0U
	l/MV5+fveilpxi5xgxfVRo4uy4H2wDMe66OE1SH5AW3leZXLz9OmZMa9dRubNkWeEl5fzz
	tX/puxYWAzFR/jHfoBJ8JaSATOCDfC4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="iH/vRTNF";
	spf=pass (imf09.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794834670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RZGav5VBwE05/edcFKd6DvQjJV7onBew1olClaU4Khk=;
	b=Rl4yijSWIjy1J+prhQ7QVQVHsbaeyH+BYOkSAd6qvJCmeKv66kIQSJ8lrtzBQetaxaAqCV
	uDA7UWpkjo/B818QV1K0MFfOQfS34PEcCVuivECHRHMnATFlCvQd09U8MUzclId4ngm1/s
	3YoCpyc7Fs3kuGIqu+9IgwkbNc6JMDg=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGCSFe13278619;
	Mon, 16 Nov 2026 13:11:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=RZGav5VBwE05/edcFKd6DvQjJV7onB
	ew1olClaU4Khk=; b=iH/vRTNFvfIt+8VTNU0NODeXzxr5PfToQQc2RxXxNMmxwN
	tz3/spAte0eKSp35mm/PFh3NjoN/vy6vTelBsn0uo9bHwP5SzBzfppUrbYfu0zxm
	BAl8CeToJf+TKRLSwDqkwA+sb9JkqXvhOr7WOuJUjhOLWxCmAyAJowFmxuSZ2ouP
	T8g6fVy9tfIhOn+tF3sMC5kTR843pGqLvYdL9OJVwXL4UTKzXycmp8bYcAA0hCa5
	vDSOSZrylbofpU7Py22fmKpq2PMc8eVqarKR9Q31jkoE6jbb00gBtS0aw3HZfsO/
	QE4zz8nk9j8vS1HPwOdry8Ti4Bn6bNG4VistaWVA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hxfc4wu3m-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 13:11:00 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGD54Ef3095320;
	Mon, 16 Nov 2026 13:10:59 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j02df8131-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 13:10:59 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AGDAii140173868
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Nov 2026 13:10:45 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E23FF2004F;
	Mon, 16 Nov 2026 13:10:44 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E6522004E;
	Mon, 16 Nov 2026 13:10:44 +0000 (GMT)
Received: from osiris (unknown [9.111.42.169])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 16 Nov 2026 13:10:44 +0000 (GMT)
Date: Mon, 16 Nov 2026 14:10:42 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/5] s390/zcore: Replace __get_free_page() with kmalloc()
Message-ID: <20261116131042.125125Be9-hca@linux.ibm.com>
References: <20261108-s390-char-ready-v1-0-3db507722530@kernel.org>
 <20261108-s390-char-ready-v1-1-3db507722530@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261108-s390-char-ready-v1-1-3db507722530@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA1MSBTYWx0ZWRfX4Vt5A3LJOpJy
 0XdUr3DO1Af4d9Tkz1UwnONNH/UsC2i83UkCe0GtdgMGWqCK1Qy5uH0lOt8asBNnhd932KsjZaP
 SCBWc6zQzLW0p/36Gsi4pLTKSieGDOk=
X-Authority-Analysis: v=2.4 cv=Fu6QbGrq c=1 sm=1 tr=0 ts=6afb00e4 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=Y6TpkvVB5ZIwULgkomUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA1MSBTYWx0ZWRfX5WKg2xhkqX3a
 +mn5URnuTpnAuQTeVueZz/+Cvr2qdxs1AiGUW59818IwBq3kPvGnm0XlZxjie2nXXYNu6VOFC/5
 dYJEp079OAUzZ1l8jBMqWyh+nERMTiUr6MP9R/bzTUHqQCmrImh3yeXe5xCwqbS1TdTOQ01t6jn
 leguscywOUOj2ZT5f9I26t+/uRiG0GnH6CuHpnLn/wwLd4qTRaiB1puhK7aNxHx1oQxhO/7gEOg
 EEXVUIfT3kYQ4slLn93t9jhT6b1vN2jqZiE8QXr6EdBDKOt6tWL58BgpX467ZBO69tnRAF2/gcj
 nCxBwIpeljd3rWbsFNVRaf5IG4K2nw/Us7enBWeIP7ZMm3ZLB4kEfbsb0CPgSaoWy1HVGRVlA5S
 4wxh8F1hXszvfKfVEiRPDRn5Iw1ZAfoRhHna8YlJbxBHywqJKEZWREVsjGSah2Z3sqYBzdZi5R6
 iCgIN/TJDNSRvxN3W4w==
X-Proofpoint-GUID: 4EnDG3myrhPma2aarqXVW-FwqNCfXQvB
X-Proofpoint-ORIG-GUID: 4EnDG3myrhPma2aarqXVW-FwqNCfXQvB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-16_04,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 impostorscore=0 spamscore=0 suspectscore=0 phishscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160051
X-Stat-Signature: 8bym3w1i9nxna6bxcg8ifwhkyqnp7x7j
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 43E1014000E
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794834670-26877
X-HE-Meta: U2FsdGVkX19Cg2NDSsghl/SIYM0aD32//02f9QzJviduT9TyjXDjGWkqzLBpOQuuBdd3PppDRvyt7a1IirvHMfGpLJ2ncPjWe3He+4jXqrldzssGZlBKiSM8KIwS8JcMJk4FxLgSMrryH9hzmdajOW2UO2GC6uNfmuLk+Ok17D4bdYkOOOaQrd6rQv+GoKY9tc7OeZACMnBCknjwfS96H7osMPE2k0NonZtQB050f87+gK5MNuVnSiZUEJQZGuu5WvI4OHsBl4htFiXKu6uX/WdEP+NtSmo05XlX0jDiAzxjobyHfyRUEOtMGfcvuzEfOVm3K8iM2POJEw64Ag5LT1fFr8VgqqmJN4qZ9YMA/tL1gZtM4QToY/vHwEwBKu6EZzTmNy47udGSg6moWPAP47aJtnd6IJ1nn/JhCzIEecUepP5+4D0703OPXW1MaDuHt3Dh+H2eNtQkMNpELU7Xk+jlALrHOAIFlNixKjqLpZcmrUQtQBVWbStbr5zuFPZ+8kQnvin1cv+MDiBKpwrPprIF74Q8LcVPoz+EDDKB5VtaaFFg3edrIniBqa2+GcbcBZYaj5HOJv/+JFBmU85NDP/x0GiRGhH0QKKg8SuwZF72dN+3k8WdjAl/EERp0sc+KMVfluzWvZazmBV1vX327sC5MrIPitUPB/3x0pU2F4q4iI59spYp9e5AnJymyhtqC8RyQptbn9wwDxHTRHAQko96c20K9FNMeGSGlTAqpdBfXz59rx/0YamD030xyhDHZwDQepZfrdOqpd3truyR2ed/9K7Ntb9LPII8AZGURvNxy3AzpgezYB/HPj7wfBqxNZnYDhejzTqC4vHaAPDQsB9Xs6rLQWbWUMEu2VpOvuftvpM8xDPKbSo0VT6x+9ycBcQ9IWKg5nFdjJLQsSodvyPileFtYyQorkB0ep5P1lg84NG4WFhOdXlpExYxHQQuXP8QWi4WWG0sOXVwXtq
 xrImV1s2
 1CIWxv1PuDt+drPoQe9VKRiu4Maen+3urqBg0KMD7mR0IcpGMMYZjbyCEY4DJO789fppVJbOcW5k3ZwuGWvwpVI5Qds9aRZoPrVfFeNkMvKPmtyTr8pelsW/IFgcrMXkpbz9zpwUjgIlQ8qxsa5UkT20LenBhqwwjCgMRPHFQA5IDFx9N6EcyrnYsB3rOPCnvW/dngaVPWB0k/HbxfVDBSmwwMJY8SR37QuZeHB5sBZu51w8mHdwXpcTu1rMyoKIb/QMJ/hEEoCwwKnRR0Op9CfFwDqvx9/Axh0w67DlGpBJilRaMpgdX7ID2xO/huGMUtIMMT/ePMB1HOMj+mDkHv/tkrGVgkguTmTVkdv73yeyrFa57/7p413d1kWRr002IBIhFYFtuI9+LDE1OD43BSiuE226LICfpPsi6h4P5Cy91JfIy6fy1oNT/oA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 08, 2026 at 10:48:58AM +0200, Mike Rapoport (Microsoft) wrote:
> zcore_reipl_init() allocates buffers that keep a copy of the IPL block
> and of the OS info structure of the crashed system.
> 
> These buffers can be allocated with kmalloc() as there's nothing special
> about them to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> Performance difference between kmalloc() and __get_free_pages() is not
> measurable as both allocators take an object/page from a per-CPU list for
> fast path allocations.
> 
> For the slow path the performance is anyway determined by the amount of
> reclaim involved rather than by what allocator is used.
> 
> Replace use of __get_free_page() with kmalloc() and free_page() with
> kfree().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  drivers/s390/char/zcore.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>

