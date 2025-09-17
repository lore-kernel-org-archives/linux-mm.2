Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADDF2CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 18:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0161028000F; Wed, 17 Sep 2025 14:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2F59280002; Wed, 17 Sep 2025 14:52:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E455528000F; Wed, 17 Sep 2025 14:52:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D0FF0280002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:52:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7344786FC7
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:52:34 +0000 (UTC)
X-FDA: 83899638228.30.87C847C
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5CEBE100002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:52:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=jWFOpMYJ;
	spf=pass (imf14.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.147.86 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758135149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7LK4ZWeL13dQx21QB7xV/bkzeQZco1h+3vZiyoJhjtY=;
	b=1t2qOyrW6m8KK0Khp+LMvIAEaG1A4OToZGr8hf0N3q/iOIvayHJigfNB/DzDUJ0FTKq+nY
	ee51mrVYPzqQA/b9vYCtazyK5S6YAfnD+M8OCWn1snwkySG2z6CwN51V6s7QtQxWiFF3aa
	aThZg5SeSkyl+y9V0Gx/VrXaLXZZ2JM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=jWFOpMYJ;
	spf=pass (imf14.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.147.86 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758135149; a=rsa-sha256;
	cv=none;
	b=2bafYWIotzj1qtAw/Fut6of/AmPo0fSRhplVUe1UOffEuSTA+uKK5NRRK8kiabrgCVplup
	TCOI39WLeJYDsXgYlhNBe6VNfHRG3oocn6McQexo0aFDBhjlPWcrsFoGVFKU+ka3z4hizx
	6eRw0a+yUy/XjCYriO1efhuwUcQ8cGo=
Received: from pps.filterd (m0134421.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HEqJIo000856;
	Wed, 17 Sep 2025 18:51:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps0720; bh=7LK4ZWeL13dQx21QB7xV/bkzeQ
	Zco1h+3vZiyoJhjtY=; b=jWFOpMYJRJhXejKedoiFYdR2KftHonRBNBFdijPrKN
	Fm6jZCWSlpA0hrAKcIwQmZnEJQzA8SyrO8nzcsWr/W3MtBBR9XFjohkWD37IFii3
	JOBP27v4iTL3ylCoEl6DMsY8SGw18ikcfEEUjJaZ49Z3Po/5VtlstD0H81GgOkUH
	Mc8ozVMyq51PmpKxinbS145Q9c/ynFbkBSK56swemZER5/2ROeg7+uYO8syOIJbk
	+gHkNTK6mJMj8o6MLk8WZ/fmXoAFzq2cgp6P/vlRspwK/KuenQd5UKFhbvTMxmOA
	KxlwQbdFAEqnQTFtZkkOcXrNdJIwNv7DgI85CSuqZBWA==
Received: from p1lg14881.it.hpe.com (p1lg14881.it.hpe.com [16.230.97.202])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 497y4fstv4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 18:51:41 +0000 (GMT)
Received: from p1lg14885.dc01.its.hpecorp.net (unknown [10.119.18.236])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14881.it.hpe.com (Postfix) with ESMTPS id 800CA805E3B;
	Wed, 17 Sep 2025 18:51:28 +0000 (UTC)
Received: from HPE-5CG20646DK.localdomain (unknown [16.231.227.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by p1lg14885.dc01.its.hpecorp.net (Postfix) with ESMTPS id D65EB801FF9;
	Wed, 17 Sep 2025 18:51:24 +0000 (UTC)
Date: Wed, 17 Sep 2025 13:51:19 -0500
From: Kyle Meyer <kyle.meyer@hpe.com>
To: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, akpm@linux-foundation.org,
        corbet@lwn.net, linmiaohe@huawei.com, shuah@kernel.org,
        tony.luck@intel.com, jane.chu@oracle.com, jiaqiyan@google.com,
        Liam.Howlett@oracle.com, bp@alien8.de, hannes@cmpxchg.org,
        jack@suse.cz, joel.granados@kernel.org, laoar.shao@gmail.com,
        lorenzo.stoakes@oracle.com, mclapinski@google.com, mhocko@suse.com,
        nao.horiguchi@gmail.com, osalvador@suse.de, rafael.j.wysocki@intel.com,
        rppt@kernel.org, russ.anderson@hpe.com, shawn.fan@intel.com,
        surenb@google.com, vbabka@suse.cz, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
Message-ID: <aMsDJ3EU1zVJ00cX@hpe.com>
References: <aMiu_Uku6Y5ZbuhM@hpe.com>
 <a99eb11f-a7ac-48a3-a671-c5f0f6b5b491@arm.com>
 <8c3188da-7078-4099-973a-1d0d74db2720@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c3188da-7078-4099-973a-1d0d74db2720@redhat.com>
X-Authority-Analysis: v=2.4 cv=I8JlRMgg c=1 sm=1 tr=0 ts=68cb033d cx=c_pps
 a=FAnPgvRYq/vnBSvlTDCQOQ==:117 a=FAnPgvRYq/vnBSvlTDCQOQ==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=43ExOtPKq08pkoLMMGwA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: gURhVSCbrA3Jh1Kv2mx01oxTFQRbHNwi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE3MDE0NCBTYWx0ZWRfXxREiFP4uvNdQ
 luYfTSm6FT7NARVcxFXF5eDPm6eWrw/vSSRhnFbUJTExtryAN8OyHivFKXVp2DXjrrEYU81oEkk
 5q7sNERRo1G3rslZr4Hvu4wDXgMksi6DVcUcVEn1Jm9XGgnxUFqk4p3CoD+bPhwsqZxS1xcAYQ4
 Dp/MxMo4WwcXxCillnvMoPyyXCZGxG2pYV2uLdQA80IN1g6J0xJv+4+vtUBA7j1ETAufUhRib/2
 8R96kyTjXUhkY4eVynbRMr6M6ioQUcTk6f1tu73K5enqoM9wo/kkJYCNXloyiZa6gVd09xfpiQj
 uw8dvRGHNHlVTTSTUbjgc81C5t05O2spqBZr0hBznEYUw99l5wMGpVhU7QIqJqSMM3aXF7Mq7U8
 dd9rufKu
X-Proofpoint-ORIG-GUID: gURhVSCbrA3Jh1Kv2mx01oxTFQRbHNwi
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 spamscore=0 bulkscore=0 clxscore=1011
 impostorscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509170144
X-Rspamd-Queue-Id: 5CEBE100002
X-Stat-Signature: rqkcfd4u54jherfuqwnrqop1i7kr9w7e
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758135149-840988
X-HE-Meta: U2FsdGVkX18UE0ggI55hTABSzdlpVTE2M3Ne/q9CyqhxCfA2hs507OlJTQoj9sFBK7ue5d6gZgeVqSc9e47Ri6D8/gRSSX8p31vDUsVZZaSuVvt2m5EMyyGPPynMxEfrBM/zCVcV29nhSfBFZevQ8lJYySc/f/GUESYaz0TYh/fm5EKA+/roGJWWl2go8viqVouzUYd01gkKE/uA634XcASpt7NnoujtWPrMRoBSpWXkrzL2wOLV5kQrw62RqWtm1Orr0tZAaHDj3WZGhPENkWq2tezRcTajEEbv5ilwD0m0bxkWnKB0ZYK81s6ubqCUdr+RglUoYUU4XJ2b0Z9YGvyLvszkkkekfP8lth0YkkUMV6SSWPBaCPugfIqvYkCjlGQsZHiUy260U7jcnN7FNyJqj5jA82ELWfi3uYtxF0ob8bKdEjf798EmjjeqwqEuQhVVsgjzX6/dzEBAGNuZkeUHt6yYu9lfyzQ+kgIGhYyEpN3/faivgOTd40cQXmxtJNaVxdYEFeZZbTX5UY7y0gOYgkTRHFApzvWdmDabqQ6b2gyw8k7zRCkmQLuQOr3BbwdkI+KIFCB5qBO1pJJiYqqH+NXyHfY+8pFDGYx3oNWsS6F8+kjHIL9/7L4hxx4RZxFtUTcnhaUffm0euiEloSUR4IteCokilphq9wO6jzSYZqBPcAu4bssHwAzE03PnQf7ENZpQnTIxV7JMMduJH5IgcvwxDfh15nFLMXhp45Zl3yVMuBLMsuZBvQkw8Nc5baTABWDD9XfMx+T9Tu+CPZLUpH291LDNyAxPqf5aZc1L4n8kB10vicnS9VAl64K17D9j41wWWUqiYOTTWUTXsFQM/9Yq7g0Mw/c0xDAIaPSpYG1EhxuY4cRmm8pT3cGsGJtpEn7CyTTucy62FD6kLxWsF/UPdMaShd5oLzNFrzlT2C6pJiGxFp9Aef3OPyOdGHWgNtPFHdbIGygtzXG
 maCluYg7
 YnVsEQynv9mhoTOWCYWqEKS0mGJ1pAEg7oyi8+MuGPe+H6FKz77cq78Vv9pKBnDEYjsOu/stkIYDLbyaAEPBuvsTOphFunGdOOyCSldqmIZ4+Pnn+bBIqyr0+ybCiHeliNFhHvMN18xT+7UH8b3zxtCmgeK44vH1eY9CtgEKTyJYQicHFS2qnncLM8omRJNrcRVT1fM8uNwpmFvkkpIdPIb47C2Rqp2e+1OU9mlBdBsBhBqmpUxBpLqKO8YmQElkGbfyC3aojOZJVDC3ImNCPlyCLiWf1k5haWI+W/zbXr1IVo3FZazyLWbiIhw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 09:02:55AM +0200, David Hildenbrand wrote:
> 
> > > +
> > > +	0 - Enable soft offline
> > > +	1 - Disable soft offline for HugeTLB pages
> > > +
> > > +Supported values::
> > > +
> > > +	0 - Soft offline is disabled
> > > +	1 - Soft offline is enabled
> > > +	3 - Soft offline is enabled (disabled for HugeTLB pages)
> > 
> > This looks very adhoc even though existing behavior is preserved.
> > 
> > - Are HugeTLB pages the only page types to be considered ?
> > - How the remaining bits here are going to be used later ?
> > 
> 
> What I proposed (that could be better documented here) is that all other
> bits except the first one will be a disable mask when bit 0 is set.
> 
> 2 - ... but yet disabled for hugetlb
> 4 - ... but yet disabled for $WHATEVER
> 8 - ... but yet disabled for $WHATEVERELSE
> 
> > Also without a bit-wise usage roadmap, is not changing a procfs
> > interface (ABI) bit problematic ?
> 
> For now we failed setting it to values that are neither 0 or 1, IIUC
> set_enable_soft_offline() correctly?

Yes, -EINVAL will be returned.

> So there should not be any problem, or which scenario do you have in mind?

Here's an alternative approach.

Do not modify the existing sysctl parameter:

/proc/sys/vm/enable_soft_offline

0 - Soft offline is disabled
1 - Soft offline is enabled

Instead, introduce a new sysctl parameter:

/proc/sys/vm/enable_soft_offline_hugetlb

0 - Soft offline is disabled for HugeTLB pages
1 - Soft offline is enabled for HugeTLB pages

and note in documentation that this setting only takes effect if
enable_soft_offline is enabled.

Anshuman (and David), would you prefer this?

Thanks,
Kyle Meyer

