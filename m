Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8821CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 08:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0564A8E0011; Fri, 10 Oct 2025 04:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 007698E0002; Fri, 10 Oct 2025 04:09:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5EFB8E0011; Fri, 10 Oct 2025 04:09:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CFC9B8E0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 04:09:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 75FE58542F
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:09:42 +0000 (UTC)
X-FDA: 83981480604.28.E7882AB
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3A8F8C0008
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:09:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=MHp7l3M4;
	spf=pass (imf28.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760083780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gzdv8UWdEnCN56xKeWjK1CJF5EdNSu3Q50DKVSJHF8M=;
	b=sbQsnMNmsLY8mbr4z0f+9ygvZ76P8sqCFehWfTA/Kj/RHPMfz4mwUD+5jh+sMIyUYIqptP
	zrjErLSJgxorNpIlRUafVUAk4r6QeYtDCSFj7U/MH/Io9FFdqZzQZebjVECS2jti37Sp8I
	tJ1FMR9x9qh/M/iG1QSVHsMJnKlPLv8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=MHp7l3M4;
	spf=pass (imf28.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760083780; a=rsa-sha256;
	cv=none;
	b=CSC0alTRRAzJpr1Sn6xwnCl+7PItwUae8xu5xisJPnpkMtv3XI5UvpwrGtKGWYMXVhpbzw
	oLZRBCjLBH8nEBidtPn9nFkaqm4a0qErA7tjhpcyTne4Id7pCeq0esVs6L3Lx5IzwjQvt7
	wa/zhrtL0+hV0Ueth1Jv9PeLtKF/6Qo=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59A7QtOa031098;
	Fri, 10 Oct 2025 08:09:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Gzdv8UWdEnCN56xKeWjK1CJF5EdNSu
	3Q50DKVSJHF8M=; b=MHp7l3M4ztwAPc0fyybEazxaTSzDl6k40j9mZAP1C/tJ7U
	kbUp5DQOuIUQaxmLdGMjXvHerAo2ErrM29R6Ik/+YSmJ+YMChSrEVPbaIDIqlq8y
	OSekPQHyHiTzxEoSQ7MkkPayXXkvEb0Fq8ivunbIBLGkwmlIQO581cbcJ+9UKPW6
	VgJPqFFpabjODT6p2qZt889z/Rt1W8EqV/V4VaXhbnKIvDwe0gPVTCmziqy9UPvf
	U/DUeF6YbxaACXToUWMuQjApqkzAJZm7464jFNigAO8WUkwYNHPXUjTJmr6mM/eP
	BP7ljBDvLNk8MNO3reP5Rp0Axk1Lti5ciTjIN+TA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49nv81sa32-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Oct 2025 08:09:39 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59A812mC012997;
	Fri, 10 Oct 2025 08:09:38 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 49nvan0uqv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Oct 2025 08:09:38 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59A89YVN38338946
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Oct 2025 08:09:34 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A0B320183;
	Fri, 10 Oct 2025 08:09:34 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1BC6320181;
	Fri, 10 Oct 2025 08:09:34 +0000 (GMT)
Received: from li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com (unknown [9.111.54.55])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 10 Oct 2025 08:09:34 +0000 (GMT)
Date: Fri, 10 Oct 2025 10:09:32 +0200
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: Re: [PATCH v2 2/4] s390/sclp: Add support for dynamic
 (de)configuration of memory
Message-ID: <aOi_PL68QaY2YIAg@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
References: <20251009131839.3739108-1-sumanthk@linux.ibm.com>
 <20251009131839.3739108-3-sumanthk@linux.ibm.com>
 <ed7db8b9-e828-420d-a8b2-3e1b8aa8c95c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed7db8b9-e828-420d-a8b2-3e1b8aa8c95c@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IudfyhWzW7_jQh-hdHIgBVZ2osLZPOxi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfXyOplaghO3qUJ
 L75RtbN4mdBJFl14fqQH9v9Drb1zLgcbQrLPimgMiwkCY960GAY6pmTWsEv/n/mo04QazaooSg3
 3yFExSyAe5HMF8elHfGe+Croi+Ksdez4HldSerO0JrFdjnTDLkBMahK1Mp/MDNcWN/Gkxlk+LBV
 Z4hUYneSqMJrxExsO8wvAe8ajYAaXpQ3E32y0SNoSyInb/OzxT63lKTMloTXFs8xzeEjNHn7Mx8
 jsfjg6zk08whGJWpPUjv/25mVgXNGLg8HKoXXGOdN1zyhwKjipq4Y1+YgtcSPHYJtWhb2T1hVV8
 xJCxTveeuy+a3gB0+aA/3b7Hh6Q92RdtjC0OMgTwWNhI8gA24i1M4kuDXceuxARfzgispzC8qUm
 crltVkOGrjwd8N43EDcH6jn/rs/07A==
X-Authority-Analysis: v=2.4 cv=cKntc1eN c=1 sm=1 tr=0 ts=68e8bf43 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=Fw4thcao37LPlByLA-sA:9
 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: IudfyhWzW7_jQh-hdHIgBVZ2osLZPOxi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-10_01,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 phishscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510080121
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3A8F8C0008
X-Stat-Signature: n3xga87zctsg66pt3enptjfpeud8uhwe
X-Rspam-User: 
X-HE-Tag: 1760083780-275163
X-HE-Meta: U2FsdGVkX1+L7E+TIYbp5uVYMQ4lv/PVCdBd83lUiP+rBYbW9DoLUVyYUFE5iNE6U+FfF4PsVxPplEhVtr2oXV1F0/5AsioS4DNskp4Y2qBV8QXorqG0Pfoq1k2f8lpxhn3H7uk1RIHBfERyVFkvKrqg+mEOUS1jzsVj58HCmHrGhjGY3Kx2WutK9+coudal1Pfkn78YnP2QOEk55GgQuxkrJRS6JOOcmDasdiUIJyW5ZG4R7KfqX6ZkTUZI7+9FoDd7HNi4jHoH04lCnOCyEYC3MS4saWCc8hUiASHOwvo+c0dmfO3bIwIvBW1qws9rtfQn0tFD5lBoGYWHIeCz58HwU3nZ5tqlzJPRlaY8bwR59jQlZ4kQsVR12ccUyxD+dCmMU3vOFJvYgsqOVNBGxsTSK2qyGsXxoG2InfbyM7m2VJYAbovHduayq0Xe10i4Q++jxl+nYjUdQs8pwCGK5rIYMwR/pfh7NPOp4eYcZ7KV0LKFatYhxI5uI547aPKcCNysmqK40SuEC6mNBgO0c+5DXL4PtpqxSAodnO8LHywg7wGjmBS+92tiK6plR7xkYVYovslAJPGzfRzAmUuHf7eNZjutAwJ5EB/JGErSit20b7JG/4oAUkfYOyRdB/q6ei2SinZZNCjVeLFGvHt3d73VfElmTlBZulaKYmD+YbOI1HOnJLN3JGgQrDvOZyYQCa5kqpPSMqpmoxGkIj5g80o64u8A25WrasHCV/g832jmAeOGYZ21mjJjnw/GU/TFAHJmMzjcSb1bJP8spo6RzmUukqeWRiQTnHm+YpD4fsiY5mctsGQqYww/yb/2BRTIBloUWneU+OAiYgJEsxrFQwhY/pYDokOhOqDVnnh30drMdl6dlvaBDFdVeElk9bbqkRp9PhzYBfSewTElwHQZ8OWVVZSXHfevIPOcS3vz5WZGYtxa9/u6Jl3gW9hDeUN7PiFHK15K8dNRZS2LM3c
 8LwIXydZ
 S3au0bgy2H+2Mk68Rt07vjdRmV9/GwOg5pemZzZPtiZOpmF25IWZZYINIHrCZA6Tw3EGhHh/vLmwUZx7xfksVWlJf8GZ21gc8hEM003KMm4syqDTmEWcg/45tJQaTFQMNr2C3QcB+jj7QTOGCpRHubc1mz8gvzrKHoiUfx9Hpgnnf2azg4fd9mD4oB5bI1wJIAfzJXwgOJkuVRkp7Mr2t6S/ZbdLz9yp7TP9MUv9lzgt+mv0Q82Bw0K6NsIos1Ujuthcjs4KLE9Zh+aEGuKIlkcjKgs4K8UZGbPRoDg30O4JOZC2EGwVw3VnLt5U7SQ/KcQp8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > +struct sclp_mem {
> > +	struct kobject kobj;
> > +	unsigned int id;
> > +	unsigned int memmap_on_memory;
> > +	unsigned int config;
> > +};
> > +
> > +struct sclp_mem_arg {
> > +	struct sclp_mem *sclp_mems;
> > +	struct kset *kset;
> > +};
> 
> Just one thought: if you keep either as global variable you wouldn't need
> this. (I would just keep both as globals, but whatever you prefer)
> 
> Whatever you prefer.

Hi David,

I prefer to preserve the ones we have.

> > -static void __init sclp_add_standby_memory(void)
> > +static int __init create_standby_sclp_mems(struct sclp_mem *sclp_mems, struct kset *kset)
> >   {
> >   	struct memory_increment *incr;
> > +	int rc = 0;
> >   	list_for_each_entry(incr, &sclp_mem_list, list) {
> >   		if (incr->standby)
> > -			add_memory_merged(incr->rn);
> > +			rc = create_standby_sclp_mems_merged(sclp_mems, kset, incr->rn);
> > +		if (rc)
> > +			goto out;
> 
> Why not "return rc;" to avoid the goto label?

Sure. Will add it.

> >   	}
> > -	add_memory_merged(0);
> > +	rc = create_standby_sclp_mems_merged(sclp_mems, kset, 0);
> > +out:
> > +	return rc;
> > +}
> > +
> > +static int __init init_sclp_mem(void)
> > +{
> > +	const u64 block_size = memory_block_size_bytes();
> 
> Instead of "u64" maybe "unsigned long" like memory_block_size_bytes()
> returns?

Noted.

> > +	const u64 max_sclp_mems = roundup(sclp.rnmax * sclp.rzm, block_size) / block_size;
> 
> Instead of u64 maybe "unsigned int" like the ids you store per sclp_mem?

Sure.

> > +	struct sclp_mem *sclp_mems;
> > +	struct sclp_mem_arg arg;
> > +	struct kset *kset;
> > +	int rc;
> > +
> > +	/* Allocate memory for all blocks ahead of time. */
> > +	sclp_mems = kcalloc(max_sclp_mems, sizeof(struct sclp_mem), GFP_KERNEL);
> > +	if (!sclp_mems)
> > +		return -ENOMEM;
> > +
> > +	kset = kset_create_and_add("memory", NULL, firmware_kobj);
> > +	if (!kset)
> > +		return -ENOMEM;
> 
> I guess we don't care about freeing sclp_mems in that case? Likely it should
> never ever happen either way.

Right. We dont care about freeing sclp_mems here.

Thank you.

