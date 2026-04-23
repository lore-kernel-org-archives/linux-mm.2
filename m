Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2DEBF99369
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 10:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53BFA6B008A; Thu, 23 Apr 2026 06:13:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 513056B008C; Thu, 23 Apr 2026 06:13:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 428D26B0092; Thu, 23 Apr 2026 06:13:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F4C86B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:13:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D46A8403AE
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:13:13 +0000 (UTC)
X-FDA: 84689407866.13.4DFB5B9
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf17.hostedemail.com (Postfix) with ESMTP id 690744000F
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:13:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=WCZmRDi0;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf17.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776939191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dlMyu09z/j1n9Md0vd7d/g/7lLJhkeD2jEsYTzV9u3E=;
	b=109gIbd1MLC9b/aGmCxcOH+M9jGouFWC6X0ia/RGuyRcAD0L/XceHo7lYu6Wjy92bOUfR6
	aqDL7pg28sfJTeopWZ+24NqRCgu25MX3bf1/OjLq7Y4F9VgdOi7p3lESJEyZtRAFH/jLkC
	QbKO/hy55IlcpeRxgDt76JaeHXeR7+4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=WCZmRDi0;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf17.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776939191; a=rsa-sha256;
	cv=none;
	b=oq7A0thk98yYlsI2Z8F+ijJZRFl1/vkrynOUW8HGv06AStuwX0ythz85GZgfrOy+wR43iV
	OCBUB5e5/9N7DuqszmeUsyjGtbqrakM/tCiXp1UJ0LNB95PPWw74HqP2HIvKw0P/pWD4A7
	/fkoQjGIPOy0gEOUAly+DmPh3P9WS5g=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63N72hrQ3514991;
	Thu, 23 Apr 2026 10:13:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=dlMyu09z/j1n9Md0vd7d/g/7lLJhke
	D2jEsYTzV9u3E=; b=WCZmRDi0ZWi0hocRIo/9zaCYREzzpmcm3qyAnfZoCp+s7G
	2FlPC+bCu3bXVVnx30SxnciE8FpnVmlfGfMZqVLC8e3YCfOSrBDUB619DaL/jWt5
	LPHFuXRm6rchtndKwNV3r9rqus+BvXBy8CL/L/V8OS6HtEwYHyekbP2w/Wle9I8b
	gm72L0aoiK30TRsH9s/MVd6AX9E1rBd4Ezr1ZfDlL8baR69cbBzHZsZLeLEj4VmF
	UCAghll2sx7o3lSk1T13V9/HWfHts+djTsLmVs+H2XLEW4wCLSz0WHMbPxD4CTSW
	3mLgtQeUuuM9TZcPebJ8ghpczdI2FPxtRXgrs3rA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dpeu283dw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Apr 2026 10:12:59 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63NA5Gdc025791;
	Thu, 23 Apr 2026 10:12:58 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dpjkxx4pk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Apr 2026 10:12:58 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63NACvI151970556
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Apr 2026 10:12:57 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1260E2006A;
	Thu, 23 Apr 2026 10:12:57 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6C6872005A;
	Thu, 23 Apr 2026 10:12:53 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 23 Apr 2026 10:12:53 +0000 (GMT)
Date: Thu, 23 Apr 2026 15:42:50 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 1/5] mm: Refactor folio_clear_dirty_for_io()
Message-ID: <aenwolyKbNkEUoNA@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <a35d5d65953cd9bdead0843d09c4cfc9d1fd65aa.1775658795.git.ojaswin@linux.ibm.com>
 <20260415061423.GA27588@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415061423.GA27588@lst.de>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIzMDA5NSBTYWx0ZWRfX/CHxngqa649t
 j9M2qpy573q8FzPAryA9nKtjALTKA1XqZxu+ypVGk6buxzA02ZNfKV9gU8LIuIe6mJClgHpnkVw
 MJQkSifxA23ZzOAAasAuvhvDzfRRnQXWmmscmeI0pgwG2P53w1DWFDR1r33LDW3bAhbulxqlPbu
 2neJ/qORAgkLz0b0QujvpQL+CGcuQEo2DLTpqabmCeFotFtYG8oRWQbnVWv0p6x0RomZp2b890H
 XYIQCITKaw2I84n6a4WdqNmrw7zKFRjARTfDY73aJIIkGxJgWCf9KUhhNbEVoTBg99hsW+cX/bd
 Tjj6p/ncYdzeJ5yiPUb9c0rJGHyyEWG84BaCP1qt47aEEQb3KiUSI23fIELXmLFjVeF4flyjLwG
 9TiQfevMFEe2FfijYZ3A+bkH7xg85LVfUi0vWwzXA23p/vch4Eurb2AlZDOZRCpVAnlTlrGxdGV
 rCQgPJIuZ3ZOT6bRFLA==
X-Proofpoint-ORIG-GUID: XTTshxLL2roUixq6z9yt4ZsXIEIoXVk7
X-Proofpoint-GUID: U-rVCM7FmNZ9J077xKzi80K_3zE9V6TE
X-Authority-Analysis: v=2.4 cv=XMUAjwhE c=1 sm=1 tr=0 ts=69e9f0ac cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=PBd0Sfe-wFWcs0skatUA:9
 a=CjuIK1q_8ugA:10 a=ZXulRonScM0A:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 priorityscore=1501 impostorscore=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604230095
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 690744000F
X-Stat-Signature: pqk5f4hgdw18z9n4o3hm98rayurp4nge
X-Rspam-User: 
X-HE-Tag: 1776939191-703605
X-HE-Meta: U2FsdGVkX1+ZXJ0epd5btYLcnC+fBeU9ZKTkoKzS8Mmn0Fp6JTd1NwHtyMI8qR5aqK721Epjcc0+XGHyfid1oYI4CM17zzwK+zQdSa/OLCwMg9gI3ZJ9JimGSt/jb0QwrKRorobF7xnvPlcX9xD4lfSFt5CN5qxSjABsgRDp55sYutLvEz9CKPKkN3jCpKtUzMaxA2tscV7Xpkg/Flk3Ol7gTbhmjuNl3mthy1XmtrdAVFVKNYUWhFkQPdvPV0vLm/8YJa4lwCErFHemfSzK5mCvATpv0D+Q4zTKznBfw9KD5vFhnJkwsWCg9GRSEacKBOtHtT8pLtG/RKjQlUlguhdZSNDyIGqwHUFQaGbzt4OZTnskmOHNGTo2aP31UoQ7/6uNQlFklxuW1cgeAlnBv4Ql+DGJhv0r02aPnUfZL1EIv6i3pntSactWHNh7t66vDKATXCLXNxb9u5tKCB1+iQvYQQ54A69Lqu5gVboyUwpsDe8ElQV1JSKEs34ND5NdpSMPUzYjgrnw75ZjFU9M9Aj/d6mu3cq6aTbVcR9RYHoYUXhwsC/0PgtsGsFNGXNNu1WQI16PfkV+ax4v+JLRyWVVdHJjrLtzReEHvGlw3LRqxDDrgn5tUdCHn4+HQIMzNsQiEvPcHcGdVjElwtwQPwt8dW60ZzuBjHewFkmam/D6F/h9glf/aSNuzcaV7jIkcEYMnQJFZi7zORiGBWlCw1bafsQJTUf2Rc94LobN5UyDUSth92nWHNI5TE9Jl5TNxsx41PlGsAnOCKVaL9eOjllrXPfge9UxxiCZ7OE1moO014qELgRmNdIzuxc8ot+gvCA/MAUODNrCYnX1PEc+C0TMjWHEhkABCj43s9YSktnF1mhDji0ffDSJCPJSQnCd+wNxidLpwVM9N9+qhdYdFwkkozDmiqGNAR8nsHrGMhOAPoBAa/vD0EJShen/JBaHUWLYu6rf/S3ICBiKdl1
 UeWLYoSW
 WZQLqkeisQH2cvZ1zo+EVNHhKeGNaAWWlx7Z7lKX1pZJPJt8Jkp+XQKPPqlLH0TDL/kYEDWEc6jH758PGaE+78kx8ex+SLIGIWrrj+DCD8Rwil/e+w4KKFEOeZkOmm0L8fPxbXD1midSFhvVmfxEr2Aq2iuGyVwpFzVCjK8mvoQTvj9kFXA9htPPPlIvyFca6FXCOZRKDY0BHP6yqNV8TKW4TUttAHci5KXhJvo2VB04iuBhn1FvUhYiv6bjOYUuugklQZMVA1kAJEIG0l0uBwrzBXoxpcRF8Xy9GUS+nCv8MOeegesvYnOhzv1nKzTArWMYb4NWQiEDQP/gCoJB9kww4nKUXH/Yl3rP3ahUD6vHR5STsvH23QOX8X6qeuFfsNUIFsJGGse8qzWjLUzXERJlu8AYxJpaljkch5Sv3v/ov1pWdUbqPBK044uCR2JvDSqw6XGrr0XyCG4xiK33cMpDt7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 08:14:23AM +0200, Christoph Hellwig wrote:
> On Thu, Apr 09, 2026 at 12:15:42AM +0530, Ojaswin Mujoo wrote:
> > @@ -2847,8 +2847,11 @@ EXPORT_SYMBOL(__folio_cancel_dirty);
> >   *
> >   * This incoherency between the folio's dirty flag and xarray tag is
> >   * unfortunate, but it only exists while the folio is locked.
> > + *
> > + * For some cases we might not want to do mkclean, eg, if we've already taken
> > + * care of it, hence pass the should_mkclean flag to indicate if its needed.
> >   */
> 
> The kerneldoc should move down to the exported version. 

Hey Christoph, sure thanks I'll take care of it in next version.

Regards,
ojaswin
> 
> 

