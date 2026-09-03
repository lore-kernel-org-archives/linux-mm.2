Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DCEEC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 13:09:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 291576B0088; Thu,  3 Sep 2026 09:09:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268ED6B008A; Thu,  3 Sep 2026 09:09:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17F986B0092; Thu,  3 Sep 2026 09:09:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ECB976B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:09:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 782421204DB
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:09:07 +0000 (UTC)
X-FDA: 85172481534.13.8AD8D05
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf17.hostedemail.com (Postfix) with ESMTP id EDE4F40007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:09:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mRvAWCzr;
	spf=pass (imf17.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788440945;
	b=6vLdmZHWtd2Ip0rnfEQvS/ve0iBDvfDo8+aHsoAHhyx3ZlaiDVVzkXRHE/ROJlxTvxwrIz
	+5Ae/RK20xg7MyZtBVtKnWqV4FoYPwI0KWXYZw3zmkt012boAmgD2e1/rU8vugC6MwgJNV
	x2b/2xaqaE2yHHYXBEzxA7BMeZWpWOo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788440945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T/jc++tLbSNEV7AK19qKe3n3s2kGYWtmrMjM1OeDxiY=;
	b=k14MvAxakpKHo/j3SRqVDNxRGhxym64p5ZWbBx0zFwywL+sebD/qWgVoJLCXadLO8YSiiL
	bCTv5Bo/MiJ2QLpFiRb3iuc4A6Pv6/+/6k3Chjulgx0kTdLR2yCeQqG0+JRvW56PZvInpQ
	wnG/I1WJwV2KZZadGR7t9NdGpLheMB0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mRvAWCzr;
	spf=pass (imf17.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683AVeBB1606233;
	Thu, 3 Sep 2026 13:09:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=T/jc++
	tLbSNEV7AK19qKe3n3s2kGYWtmrMjM1OeDxiY=; b=mRvAWCzrQLAh18x7/tXZdp
	OFAxEWgR7PVgJ0IR9yvF+XpqSFJ3m3p3uWdi10JSyi5lTIFQEBUHHp+fLbPRJKmS
	8k/zSPUwevBKM/KbD3F76vmIxmBJwSb/oJqQUPif+XaqKPu1UWWyzXAWg08IYsnu
	ECat5FPxV7rdV81Xpj0X7R/aqoLGHJcosctRFh69kwJvp4d6ONwyUIty+Vk6Vxkq
	vMsNEU/Pr3EHxC/mirkKWwi98DUWOY73USXnXIplcBi4kGv0BHBFGnebvRb6R+KF
	iyZFYHxSf7FOPy/9dzZtysaLWqqtYb7/z36jN9k78qVgOdmEKonxTBZuO2zjImGQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbnue4kb9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 13:09:01 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 683CuHfn024949;
	Thu, 3 Sep 2026 13:09:01 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gcb8hqptw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 13:09:01 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 683D8uKf50332152
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 3 Sep 2026 13:08:57 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CD49C2004B;
	Thu,  3 Sep 2026 13:08:56 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 81C5B20040;
	Thu,  3 Sep 2026 13:08:55 +0000 (GMT)
Received: from p-imbrenda (unknown [9.87.146.55])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu,  3 Sep 2026 13:08:55 +0000 (GMT)
Date: Thu, 3 Sep 2026 15:08:52 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        David
 Hildenbrand <david@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven
 Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: s390: replace page allocator calls with
 kzalloc()
Message-ID: <20260903150852.518d6cdc@p-imbrenda>
In-Reply-To: <apkqHLgg7nqBiYW7@kernel.org>
References: <20260902-s390-kvm-v1-0-3bc0986550b1@kernel.org>
	<20260902130612.41500808@p-imbrenda>
	<apghz4XAgv0ro15t@kernel.org>
	<20260902165315.06996af6@p-imbrenda>
	<apkqHLgg7nqBiYW7@kernel.org>
Organization: IBM
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rQsTroj8xn3GdbO75jzE15PR6kvzF6jW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDExMyBTYWx0ZWRfXxC/CioTB8XFW
 bXzXT7CVmLTowOI5tl6/4yAw6jKpBBQpmlAb4Q7P5G5PXe39cUj1QomSXEtIbf5l9l6bQ6vP6Ls
 oEvhWUvILExAAMl0sQqMY4Cw2qZPlQk/B6mc4BFdOD3dkf8fY+7EVHO2uDYN3xsJHuBpbm+Ykjh
 TgKMx2JGDniBOu7MpN/QBKrgW0b/OAZM73SiKTCzZeKQGV0hYIGESWecFgWrmxF80sPpNyhmdUo
 SRadS7r3Dtp0pkYfJCRDmmsEm7XrwyUAX0TCsh7B6CcQkBYLJ6YJEUsKjcKNHq94zudpCKhbdby
 bBeJT3eo9HSyC1ohspEtfzc0kQsg8M2N5LGsJz3u8ksgJhjfjdDb+JhnoylQmabsOOCrUyqOYua
 i2+eF65Qoaw5p28bRQMOV1GcI+dNKq8C5sz2leviV+LaqUQ/vjqo+aOcVOD+gZ+0xq/492z7GVn
 ID6mzmVBfT5KQ9KY2QA==
X-Proofpoint-ORIG-GUID: rQsTroj8xn3GdbO75jzE15PR6kvzF6jW
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDExMyBTYWx0ZWRfXyG1RdVQm6qAZ
 GadFcA8vNVNNkirzwOcjbz+I5ItvsGbt/IRMHTgQU/nTsee4yZ3pdL4uury0bGiwMOzT34WmHw8
 ZKP0t+AuWlpk155FQmOuf2jFWLSs/Kg=
X-Authority-Analysis: v=2.4 cv=B92JFutM c=1 sm=1 tr=0 ts=6a99716d cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=ohm-7uY5D15YhrtMo_UA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_03,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 clxscore=1015 suspectscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609030113
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EDE4F40007
X-Stat-Signature: k7zi6i1rknninnhymqxf87n58idhkczz
X-HE-Tag: 1788440944-975965
X-HE-Meta: U2FsdGVkX19SYuNKI2dGy2eH/WzXAQ3blVto1e9ZRoC5c8nX5m4fbwNy3fuNECcHYLga4d6KHMYbC7EuefU6iB1vfn7DvKZa2b7fCxigffMjTy/KDNhtw78g93EoM6w9rubNvKv36XMDPU6Egqw9yEWMHv/vTPBBgCVsKi3FtzcjHRRG7Am6p63yLxeflPN9xW9tLt9xVIVpxXy5hy8zWVHFLKfNLiwZ4rbjChTUi+p6l68jrJk18mIxVj5i4tSP16fGhkDtUce0krNTObSdEeCSwF0T8gvHYnvlp4gVtsnUw9AfdVGzVZLLaQMvSKO7bX5xN/JaUtT1Ry2+jb54fjUQXfavjARA9uMS5NI+4UA7rNWCvdwil061PsnNH4tyV4B5Rh1goaYrbmCWz93p2jLjm8tFMii1Wa/t7Jy1qxscbOMHXS+l9HFZ2D8aayv94QbiGbKulhOddU3EyWH9VU9C0ZIZN0gkfhygZcorPWOVK+9TM5xvHyXYm7c5ZQXUIyUN5K9p1WFN0EiJ1zdYiFiA32H2bN+gadri+EzSRUJDqbDo9XUm+8KN4p54pLn8U+ycBsa3ehnjZi9EfDwMAC8Qt3Mz6hLGd20OLpkvD1cQv8620i7zeaRGOBVqpnUMf2p4FxyAf2n8hm98Fh75N6pNJwsNgEAAaB7aG9wwTAwR3nzjK5tfBeL6teTvphOwhQv3Uhpf7G/N1Yx4FEl3iCIVitn2GuW843v5K1gV2Vf4eUg2y8zoBQ/EanlAt19cIHBbMgeRCYRE3RkxvzjXhuqG0pbgp0KWPWTcj3U1fbw5br6sgdzbZfSLTsOeuheyVeiSgbdjWY4dQugXvOpkYzvgAPc2DXtJXfHvO8Nalbx5D962h87zq8buXzoLEvMt1U18VCrqg5B2WPmSxP9RTeWO/Qusc0l6pGlAm/eYyHNL6Kkc3DOcZPVTjqkjzMQykg37eK4y+3bb3J2Ag+K
 8bcHIaWT
 8nm3x0r5WIkLR7zTCC4zEz1VGhUELS2HH7Z0cdaFN/5aBc19bA8F/zbkLL4KHsGor8jGFOkHQrdnreBWD0jN6XJoxMG6p8msCmZsyvxwWqhFyKN3HM9/bcIgYEoxC1tefhjRr1t6z10yPrgi8qhJJWXoKrUuK1Cm6GlQTw/kOciv8cihxwPr/q4O6SYvIlTR8Abnztbwqh1vkoZxHn0iqgIpmPHy+EJfqy6VaX+7eoZO00tu3O7Xd3Rdbzk/sVN3FachVWtZcKuFDw5pkeR1XOyN47w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 3 Sep 2026 11:04:44 +0300
Mike Rapoport <rppt@kernel.org> wrote:

> Hi Claudio,
> 
> On Wed, Sep 02, 2026 at 04:53:15PM +0200, Claudio Imbrenda wrote:
> > On Wed, 2 Sep 2026 16:17:03 +0300
> > Mike Rapoport <rppt@kernel.org> wrote:
> >   
> > > On Wed, Sep 02, 2026 at 01:06:12PM +0200, Claudio Imbrenda wrote:  
> > > > On Wed, 02 Sep 2026 09:15:12 +0300
> > > > "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:
> > > >     
> > > > > This is a (small) part of larger work of replacing page allocator calls
> > > > > with kmalloc.  
> > > > 
> > > > I have some objections to this series, but not because of what you are
> > > > trying to do (which is actually nice).
> > > > 
> > > > I understand that you probably wanted to touch as little code as
> > > > possible,    
> > > 
> > > Yep :)
> > >   
> > > > but now since you're rewriting the allocations to use
> > > > kmalloc.... I'd like them to be converted to use the __free(kvmalloc)    
> > > 
> > > You mean __free(kfree)? Sure, I can look into it.  
> > 
> > yep :)  
> 
> Well, I looked :) 
> 
> The only place where __free(kfree) is completely safe is handle_sthyi().
> 
> In all the other functions using __free(kfree) creates a mix of of goto
> and cleanup helpers and cleanup docs advise against mixing them:
> 
> https://docs.kernel.org/core-api/cleanup.html
> 
> The cleanup paths are quite involved in these functions so using

it looked trivial when I gave it a cursory glance, hence the reason of
my original request, but... 

> __free(kfree) there is really not trivial.

... yeah, it's actually not trivial at all.


maybe refactor the first patch, and leave the rest as it is :)


