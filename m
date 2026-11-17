Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2C85606A332
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 15:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=JQWrAeZC
Received: by kanga.kvack.org (Postfix)
	id DA8E86B05B6; Tue, 17 Nov 2026 10:33:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5A216B05B7; Tue, 17 Nov 2026 10:33:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C48DE6B05B8; Tue, 17 Nov 2026 10:33:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A44E86B05B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:33:22 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2DFB0A8072
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:33:22 +0000 (UTC)
X-FDA: 85445005044.02.97B018B
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf02.hostedemail.com (Postfix) with ESMTP id D380F80002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:33:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=JQWrAeZC;
	spf=pass (imf02.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794929600;
	b=8E+A2pFCZIy6ceCr5RiNUxR/ejKP6j1XxDMgjq4X2gGvqlAzqf98Pi4HwmR+gETon7VRp3
	hHgAWCUWN22+3/Gdz+dibL0rAp/vS8WUUJnVboME9aq5/GWQMrh9DRubkfSF0vFRIZkSrF
	8tVVFgVnxhr9uPvKVGAmUYkqCxLvri8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794929600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f/fjR6CwAs3q03u3k/OuMPCkcaJFzpjKdriSKK3suK4=;
	b=NawNg7cBVMqJqoz/mmw3/apCPrDkGRaNJxhH0HlrW4+NFGPo7ZgnOStGkbXUZ43pqunYQv
	v9r+E9ddlxbUFPmSJQUOOv4fjUKu2lJGa2eLzDhrH6CL4KIQ3yrhArsQnj7USOlg88fk9l
	lLXTUN289Txrg/yCmJgGREqi7toMK2w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=JQWrAeZC;
	spf=pass (imf02.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AHFQeN72711641;
	Tue, 17 Nov 2026 15:33:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=f/fjR6CwAs3q03u3k/OuMPCkcaJFzp
	jKdriSKK3suK4=; b=JQWrAeZCbPTRiP0X3WbGG+y3i5dlhCDYLS5NZzRNQVAI/i
	yoyYnzlMbQeYk1F0nuCu8cZt84NRpMeq7MDEV3+9A4dnFxcZxPyXkNosA1bFmQnj
	S1rPaCUrnDv1L32h0i5LOJz72I40kj2ehIh2x189IOQoQzzI0BxtvgI5OnPKEDN5
	5TnENXHrNUDnT+IAe8XnNBAH6CGK+6TwPO/tBYTvWBtxs/CK3ix5II5k1h3ri0eX
	T5Yuh/RxzyAGENAlRv6+ycFWvwKMRyv5WtHQW0+wvBjvqopkY4tEOSE0fmE31wpx
	BXl+bZZ696+JMcTsPV+9dxUyd1ASfUYVCwISNU/Q==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hxd2m3jgr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 17 Nov 2026 15:33:17 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AHC4svR471687;
	Tue, 17 Nov 2026 15:33:16 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j02dfdhwh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Nov 2026 15:33:16 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AHFXCeE51315008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Nov 2026 15:33:12 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 724D020049;
	Tue, 17 Nov 2026 15:33:12 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 177A320040;
	Tue, 17 Nov 2026 15:33:12 +0000 (GMT)
Received: from osiris (unknown [9.111.0.235])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 17 Nov 2026 15:33:12 +0000 (GMT)
Date: Tue, 17 Nov 2026 16:33:10 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 10/14] s390/sclp_cmd: Replace page allocator calls
 with kzalloc()
Message-ID: <20261117153310.32016B6b-hca@linux.ibm.com>
References: <20261117-s390-sclp-ready-v2-0-e518c99622c6@kernel.org>
 <20261117-s390-sclp-ready-v2-10-e518c99622c6@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117-s390-sclp-ready-v2-10-e518c99622c6@kernel.org>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=B6UsQ+tM c=1 sm=1 tr=0 ts=6afc73bd cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=Y6TpkvVB5ZIwULgkomUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: UE2LM1lxxkyDFML1Deg6Nq8QGkCrI9fG
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDA2MSBTYWx0ZWRfX776VWhTK8Cyj
 OrZz9G8TfA0SCnR4DPhv+A4igq4HI6LefuihHMmPhRYfO/fOkRY5+yPag0WxkS6m17AeFufRghw
 mOWRqd/+HNLRfFiFw2CFGVFYSAftFDI=
X-Proofpoint-ORIG-GUID: UE2LM1lxxkyDFML1Deg6Nq8QGkCrI9fG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA2MSBTYWx0ZWRfX6/jvNyvwN8AO
 TPYXKpKuHvlrOrZNnsNozkrng6Z/U//W1MVvDci+dcZ/KUNXIYFPCpFwbtZmlHpTbsaIBgksWLe
 R5xAe6TAwamKQcFb42JTVXf6BnlAUmZaRcM7ELNvBVXSHkb7+Ir1IkXCsgeK5NKlVVNW1GlFzUc
 2wMfVPEf+D4PF8Mldc517LY6Fy0icmLWvsDPq9ASws8pl9kyG6ng+AK7a7EkQKxvA64YsEL9tXU
 e6jz2UZ0vbFqaWua/UTPQEatpVOSkGFkeVtIPql6KzBcXB9KGvZls+51xb6GIPf0yH6OGHRAqa2
 F/EcsBLnbm52CFTvvnDYx9QXXIeHNR7OTg+8bSKiDDmVdiiPzu3UFrNB1IWjH+krS4RdyA9DHaI
 QoIYgtAdeumlJqKvAT+W/KDVYpQbHc245NOitBSg87r+p3In11FmpSBFVRIEhnBBJdGs4Jr3R8i
 a0ru0rj5IfP6yc9E6wA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-17_03,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 phishscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611170061
X-Rspamd-Queue-Id: D380F80002
X-Rspam-User:
X-Stat-Signature: c1bktpzmt1yzbfdgm7h4n3dcg8chqac3
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794929599-781077
X-HE-Meta: U2FsdGVkX18erPXRUeeJxS4+kpIfOrF4vb9r8yQiDug8fcv2j2ko5YynyjxpEYbHxWxx8N33u6KGHcQa8JkgcGOpG+DYciHPvQ/ZdL5FyVsg+d4nrsxsQcxzopiXIBwruEh4BdQ8mIB1kbrwRadJO1ySJtebBpAQOH8w55MnMHCQtRd+Mq/ZjP9MxQbjHzK3SM5xOwC+wirVPQ+04MkwaprLbTwC1dNUGw44hMVKQrgc6ixNCwPt3Ef1KTP8sXL3K4WvkRBoe8t1K2eFS8HXa8k9it2H9BYit8mD5BRZQHBHcPdyFARLE1QXRmCoBtZ+G5nEMaWXZwO4dJ/gBW6FCLV5djyOmJAXjXknse01DUs7O5+eCJVIrxTU6wljIUrSSFY8Y+MFOUGusKSPxN8d0Rrwn9YXjo02i5X4KVEeQ2k8+4mSp625vjbGf1FOA4bMo1qP8XTmoeonk0wcE9a1Op3JTiS0OFjg7p5rO1iDy70k+xcye21U02+91UkOwOpJfsaGydbAifttBr1QkhcYrS4ZcMVjjS6Qg/Hde/zFKDltZ/tP3SuhVZo6jnbiwexHt1QIfzcGRIWcdvjEYU7OBcvLYcUFUMMrj1I4JRjX4sadGccCgTMyq8YCu1aI5vGJwsZmymYGAO+9rdZ7llZMtvyIgAE7HH5TkfXHaFhUZwb+itGURJHt7toZ1lQMYEoYAX3oQNsLPxS1dMm7moSpPbexOeQhpCP4BvfI+ziRK+CBmAzt1ZfqyID3us+nweXrAeXvAfC1YD56Ge40+/INzQeA3PpeSSq4euNaCsOOAUAtQCZTXg7rHzRBQSW+6y2BJyWciyuTnL/q6IjEn05M//HSro3KI04uIEixhqSYbWFue1v9GbpVsqj8N8U4DTneZhh+5CjPFRdc3SYtA7CmzGSYtZc4BCdDdDLV58W47ndIuWMYitKt5gN73+JXr83o7DzpNccz0YspizHrZOn
 9e86HRga
 ev1lZTrOxeWkf/vOcywnmdZyN1UGX0gKk1EWQvLe3l1X+ZBcqqrsM94MyPO0LXX9qzdShwabkC7DxtIWusYeAOzss+CNr+Gu1csKSPwbtB5xwPsCXhMNB3IoFrB+yY1N9FbYAg/IKGllp/w87wHAXcR/s/pHyTVg5PMe5Lxh8nUApUDaTbWvWrGRzXVQou0rxWIpkRlSUsvFQM2Q6RL6Kier7f2Tz6DCqgfQXgHll3O81nKl2RlKqRZEyfSbNTi2cplXINXG4SX+FspuR2ycv52iboYbUi2j3UT9SAOSIzy+d8WHB2GaWR+SCqj9oyN3ZyBFT5qoHd/AdRt4LTJM5NPW8t594ZiDC0WKxQaxF+8NSpLWQC0rTb3o7LbWOmbszD1nNQ1WKNylYoN29xNPjmkx8/pgwgT68B4cUe8VR0LYV+lyybo/yuOfp5JwfOgaV3D0jMuHLRtQqLQ9SVCJ47ERndqJcj8HL+V9XIpnNe6YZAv8ZtSawaacB1YRGCXty+HFQeALFYTSU7l/o5wpJiiMlL6SJc9ILyI4JNsNX9C+4LtI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 03:07:02PM +0200, Mike Rapoport (Microsoft) wrote:
> _sclp_get_core_info(), do_chp_configure() and sclp_chp_read_info()
> allocate the SCCBs used to read the CPU information, to configure a
> channel path and to read the channel path information.
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
> Keep a power of two size for the SCCB in _sclp_get_core_info() so that
> kmalloc() returns a page aligned buffer.
> 
> Replace use of __get_free_pages() and get_zeroed_page() with kzalloc()
> and free_page[s]() with kfree().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  drivers/s390/char/sclp_cmd.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>

