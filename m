Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CE6DCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 09:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C355B8E0008; Wed,  8 Oct 2025 05:12:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0C7F8E0002; Wed,  8 Oct 2025 05:12:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B22688E0008; Wed,  8 Oct 2025 05:12:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9518E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 05:12:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 106B5C03DB
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:12:36 +0000 (UTC)
X-FDA: 83974381512.27.1A81C41
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf26.hostedemail.com (Postfix) with ESMTP id D3F38140010
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:12:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qvdNYe4+;
	spf=pass (imf26.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759914753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aK9mCC/RHPHdTK5kHYQdLWTNRy23qH+qQ26TBsTBalM=;
	b=nRLir6G0QXeYSm9YHQxvc3sfN7W+YDTTA+mxspII8RZiPH0pn3bX8bKAk4ML9lbX5bR58K
	bC3jScU+J3kJVVN/TqSMYUfkh4qMWgVCN1SYRE4AVPfJTOg5sJoAdqdid0SEuhoxDv5/7C
	knaQJ1wR3Qi53nh0Ywb024m1aH/owqE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qvdNYe4+;
	spf=pass (imf26.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759914753; a=rsa-sha256;
	cv=none;
	b=bKefeZ/1z7ZB/Qh1kcF/4ZWd1IxS0aeTgmyX9JxMsPjVoxKSuzFapYM43/s0j8qDKQ77d4
	wNkXywdZymeZxFvmpQRVm+2k2LoEITXG+7fi2i/SX+oRP4KMcaQSH16xCJDr6W9t/bIaQl
	B7AKwbKNkQQoTt5lcJAOwkRcZb4B6p8=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5980ZHXr032558;
	Wed, 8 Oct 2025 09:12:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=aK9mCC/RHPHdTK5kHYQdLWTNRy23qH
	+qQ26TBsTBalM=; b=qvdNYe4+5EA++mkwOCUGVGO+t2OONxB1DygeOEhFhJ5hMY
	gk/gCN8a1/xtNWL0X8oW6VJ9t2nfHg67GfVs1J6jEIAA7fBGBXCMZGoS0M9bGAiu
	movKI9GmUUVyfDFXZe7w/RXgp6Rirw14jCYkiLnvQigQOfgZ29PmuribvX2o25Ak
	ykSxexPnFs03HU6QAYwu1yn7dLKciVfAwGrdCA51oTOnjvxFJC1uvZQPrOXWUrsJ
	L9Vd06JsF5jRFObwC9YQA1jK7HiO1KKhjhaLFaOraOMjSj7RPqeAhfMY2UCEh8xe
	aEFvEqbd5uDXcYPbOsd95OIm2GF6dGPKDBu6Rn+w==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49jt0pkh2k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Oct 2025 09:12:32 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59892jtF000922;
	Wed, 8 Oct 2025 09:12:32 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49ke9y7vvb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Oct 2025 09:12:31 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5989CSnE54133064
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Oct 2025 09:12:28 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 08F2420043;
	Wed,  8 Oct 2025 09:12:28 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C1A062004B;
	Wed,  8 Oct 2025 09:12:27 +0000 (GMT)
Received: from osiris (unknown [9.155.211.25])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  8 Oct 2025 09:12:27 +0000 (GMT)
Date: Wed, 8 Oct 2025 11:12:26 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: Re: [PATCH 0/4] Support dynamic (de)configuration of memory
Message-ID: <20251008091226.7407Ba1-hca@linux.ibm.com>
References: <20250926131527.3260733-1-sumanthk@linux.ibm.com>
 <ab366c03-8c78-449d-bfc4-2d155212d9d7@redhat.com>
 <aOVUNmDiWgrDJ1dJ@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
 <5e3b16ec-9ef9-483e-b97e-bff0c1915b19@redhat.com>
 <aOX_L1_2S30XhLRA@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
 <1efcb368-fcdf-4bdd-8b94-a705b7806bc2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1efcb368-fcdf-4bdd-8b94-a705b7806bc2@redhat.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=XvT3+FF9 c=1 sm=1 tr=0 ts=68e62b00 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=jU7K009U6UgGpLyiXvsA:9
 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: gQe57XFfwFvGSr-qkxi9m24GyXfNLFtK
X-Proofpoint-GUID: gQe57XFfwFvGSr-qkxi9m24GyXfNLFtK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA0MDAwOSBTYWx0ZWRfX/lr/owc4waxF
 aHEV/cPN1MWRV5BM10eao/zGoE2x2fKeLvek1NljdqlnGVdRUGXcWyrA694yVz+M1GLdJnB5dIk
 i91NXmWl8V9L0dDPfHzcA4TnMB2T59mYlEbp+PyIt5LD4oyvdmC2FjkeDTrsa1L4zRLVn1WwOdG
 +R2k1RGEaGso1b+mWHbRNFM/GgExy7PDrkBIalJ3dHM64PN/hvJ3B3/Exx/XTdiJKnA8OlSagza
 XrXADd6SUsz2d8ytrwwTrX3qILR48CuBV4klUs8izLjYHzv225xCAO+heSkU39+gXr3SsXuaQDI
 WmERe9y+E9uRhNW9opr5WthMidZt+GFktfsA9TkhtvOPF1dI6UUA8hoGAHEKvDiND9gqJLCmS97
 ZB6MBbYm1sx4nAtvoaCUsTDmusz3hQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-08_02,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 phishscore=0 priorityscore=1501 clxscore=1015 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2510040009
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D3F38140010
X-Stat-Signature: iuk1whox647qee5gaawushyc8re9ttjo
X-Rspam-User: 
X-HE-Tag: 1759914753-134478
X-HE-Meta: U2FsdGVkX19btun1bej/B5R7HgeEtYzwQEzsWekDY+8uM+uCijOYvSj7UrkiSVsvJez/fhpZmSt8vziEG2+If8ogcWsalssjRrIPKlQBQcGB2VTpf+dndpuDXwJHqso8nic6w3Nhrw2pesBxiQZjI5m1onhSGRfktmELc7l8KGKBVHtgf7aBjs17nAWgQ/d1KDu5osRcnRaFy7zY5gKR9ZUBk+Ri8S+nI/DWHUdXg3bCr6ZHdV8xt7vp4KdSvJzIO+R3OVNQLPcUmiLDS/SwnMeh8XiHD+0MLJOhQuzFBFTTuLqhmotqDWz8Nw2VRIjxmAxBbHJZIBvn+OTS5RPk/7HUdTnqkBTLeXXNg4rODRbNPb4fvMtDHtUBPJfaswdAiB/M+RMo1ruqvN78H9t0H0Sj5gid6xrslloPq+Ct4HLqBYw79P194qZozqMCtVuhxUMeT6yrGiW74iUIdkxAOUiV7SF/5YM7ugzd3+hzdAEixfgsoKmNOgHfqDtjSTKMv0aNry79neOYkwKE5zntJYLe06KctFEbwg7+LCF1aYIpjBj3XSFrQhmxBgtjyyUE/i4cx8kYCXLdg8N65rubs7NPbxDMotJWsCwAHNpem0JPWOvtcxPuec0IHW4tvVbSGCi+S8MsNIz34srZBrEhyuIgKXy4MQoA2Ihs2zWCCuIiLUqD+KcidZ4HSrLdaWpTd/+gCry9efDVaPkhDvu6cMDk942KBCf0W2EfAXhYbiBzQ2f0zdWDzrujSIG5gIBw2Mmpg8RqE52ZUNoPHwVmfWBVJ3nThdt6aIsBiE7RdbPi2Ow43nEdfJdui24i6chje6dXIrUDzJ07FvA/LFlB6QtRi0+12Hy4Rehc43t2Pi9ccJwRjNf5ebPL7UhhxnOyT6NgAwu/qBr/UnJndR1nTe1iVh9htJfx1Pxw/IjCPPF9caF4qiYxPF9dEDL567h9LTJsreubgnZDnZL9N1z
 sy/D7sFH
 zCwNW5KP77tLXaTjXcY1n5QzQ6yrfAUE3Zb6MUw89eTtlGxN69evQk13KagOwSnm+1bZIrIS2XTaFeZrOz1aUZgW8HqIztvCI/bSJ+LoO8ZysASoQc9eo5SZdjKzdUxxtzP+wpCfJba42nQF9D3An6a6tDLvWWgLoI0+eGl4l8+JeaxqhNTMwhc8lMbtfTqtnJQMUSnjmPEyvFY45wLDGQFDh9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 10:02:26AM +0200, David Hildenbrand wrote:
> On 08.10.25 08:05, Sumanth Korikkar wrote:
> > > > chmem changes would look like:
> > > > chmem -c 128M -m 1 : configure memory with memmap-on-memory enabled
> > > > chmem -g 128M : deconfigure memory
> > > 
> > > I wonder if the above two are really required. I would expect most/all users
> > > to simply keep using -e / -d.
> > > 
> > > Sure, there might be some corner cases, but I would assume most people to
> > > not want to care about memmap-on-memory with the new model.

...

> > 2) If the administrator forgets to configure
> > memory_hotplug.memmap_on_memory=Y, the following steps can be taken:
> > Rescue from OOM situations: configure with memmap-on-memory enabled, online it.
> 
> That's my point: I don't consider either very likely to be used by actual
> admins.

But does it really hurt to add those options? If really needed then all of
the sudden admins would have to deal with architecture specific sysfs
layout - so the very rare emergency case becomes even more complicated.

Given that these tools exist to help that people don't have to deal with
such details, I'm much in favor of adding those options.

