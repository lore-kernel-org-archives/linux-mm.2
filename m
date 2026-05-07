Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFCCBCD3427
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 10:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22ED46B0088; Thu,  7 May 2026 06:32:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DFB96B008A; Thu,  7 May 2026 06:32:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 085916B008C; Thu,  7 May 2026 06:32:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E70396B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 06:32:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 85EE4C1C70
	for <linux-mm@kvack.org>; Thu,  7 May 2026 10:32:27 +0000 (UTC)
X-FDA: 84740259534.01.E9BA75C
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf01.hostedemail.com (Postfix) with ESMTP id E4C1640007
	for <linux-mm@kvack.org>; Thu,  7 May 2026 10:32:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778149944; a=rsa-sha256;
	cv=pass;
	b=xKLNbfRWazQ0WU2ADGJyV2KfjGT/ilmdKkcnVxIQKpPwBI0rrEqz/2fb2tQnVRHMA0CkRU
	8bgc9H0s9hujgoO314kIeJnH5ZRuI//ZDTK2UySdPUq/PoOB4bXVJx3YQDFdDHLpdKo0c+
	aiiGYK3869hUq3GuIvV8Z80GMzrd9sk=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778149944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b5Ddx+MuqAF6oUS+rxqJx6cEL60cvcVClEjL1dSCRSY=;
	b=Zk2CqvwaxS4BAIu0yfeWu666PA7lQUPwsCLHdWgpAwLHn8WTzzTG/+oqoMhyR0kWWPTFJH
	cJrIloUL7nw2Nd801lYt5JjrUIhDXq2RfFAQQti8SwBEnYk6tOePim+d0Ls7KDOBszRL05
	OfnVpIk6tSW3bnocbgTrJBLklQe9zVU=
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 68D6EC1C81
	for <linux-mm@kvack.org>; Thu,  7 May 2026 10:32:24 +0000 (UTC)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0BD4A8C987
	for <linux-mm@kvack.org>; Thu,  7 May 2026 10:32:24 +0000 (UTC)
X-FDA: 84740259408.05.1643859
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id BDF0040006
	for <linux-mm@kvack.org>; Thu,  7 May 2026 10:32:21 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778149941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b5Ddx+MuqAF6oUS+rxqJx6cEL60cvcVClEjL1dSCRSY=;
	b=lVR4nqIMts/e2xzeKdls9QficNqBMSNuTDJq+BNDUZeMllV2rJ+/7U6n6Z0k3sXHP2Svhq
	8Fp2w+npT/SnkqNvLlD8nqBjheAq++kBoJqGwpH0ZD60UG1LRHYFHpO5ZRtRYQNuTx0z8P
	XQQux1+KbZzVDMhwqVnNgYJ6vxhD914=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778149941; a=rsa-sha256;
	cv=none;
	b=h5cPCctUb4Dm7Y9sgXJn1UWa9an8pK22mPvPwE0hPi0Ho0IvuUB1qbRW0Hb3bu30UG5tPa
	Oep871TW4EzvRmIuhe1eGJggig14LzYvWKFhXOPkxiXcLovIlg8BNRkfpx07MvOXR5o+Z+
	ncwHUHpPW6o3fkONCvtdgYGlHAf1NBQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=TklwlF4e;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf04.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6478pJO81944676;
	Thu, 7 May 2026 10:32:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=b5Ddx+MuqAF6oUS+rxqJx6cEL60cvc
	VClEjL1dSCRSY=; b=TklwlF4e0x+q6seZpNY0NLQIC8wtaXYIqdVEBH8mZDp3Ty
	OqOwzRkVyi4jiq9OsOw0N+zgIUYR82zAXEYvJgHTDCkXoN/ZJ/dkLoU70TZ7pySd
	WmMiLGJwy7pIUNqSnN5gbCxXrKHtzih920PWJ+5A08JrUzyApmAgiR+X/FT3T2t5
	UY3IlIrbge6EwL/N1AVwNa8L9DtnqJS4eWMU5M5t+fZm9xslDHsglusW9+iXWRD4
	ftHp74KVcQhq2sgwGnhTe7YfrAvscOza1saAqJjtdbU5BSH//69Zk3bDNg7yUiri
	J6kbxaa1NVYPJ4GK6Khti81spZLF69Nba5EI/W3w==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9w6mp2g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 May 2026 10:32:16 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 647A9Yb0027865;
	Thu, 7 May 2026 10:32:15 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dww3hanwb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 May 2026 10:32:15 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 647AWBUL49545478
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 May 2026 10:32:11 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B81B520043;
	Thu,  7 May 2026 10:32:11 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CDF22005A;
	Thu,  7 May 2026 10:32:11 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.111.66.252])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  7 May 2026 10:32:10 +0000 (GMT)
Date: Thu, 7 May 2026 12:32:09 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Oscar Salvador <osalvador@suse.de>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v2] mm/page_vma_mapped_walk: Use ptep_get_lockless() for
 lockless access
Message-ID: <43815634-29d3-4fa4-b967-0e251ff32f73-agordeev@linux.ibm.com>
References: <20260504130434.2285053-1-agordeev@linux.ibm.com>
 <20260507093433.q5xybwumryxclnqy@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507093433.q5xybwumryxclnqy@master>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=XPQAjwhE c=1 sm=1 tr=0 ts=69fc6a30 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=D19gQVrFAAAA:8
 a=7CFNzQo_ZtPcNetzl2UA:9 a=CjuIK1q_8ugA:10 a=W4TVW4IDbPiebHqcZpNg:22
X-Proofpoint-ORIG-GUID: 8QOWfc7k0b7o7pCZUW67IeWT83QfImhq
X-Proofpoint-GUID: qN--_Yog5Tix-ByckweoU--16gQTXerf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA3MDEwMCBTYWx0ZWRfX2wTtXQzvHzvL
 xI8BnlJ8Pxm/3TvmS47XwcJZexg69P1SXrHM6Zyz/Lmif+mjbOqNI9O3UpjG6WHrx9tsMNzaTwa
 iVOWgkeh+TLRZO96TOmQTUGXaRJTIleMJC09wJpG+pvyIEeNo9qBC1Ir5asWJa4YNRDyJRHcb18
 aEEFXQQQ8pzT32KUPHJxQ2n2tT0TFk4Ocb/WCIhT3npPMra0Qf2kC6B5WasnW8oUbcyQDTziI+z
 SNERrdIjFWMpS/2q2Qf+S5EyBC4hQpOX+BvTvihoSsJxdx7Y+2WJpw1GmEmr8aZlDiqpg3WzQ5t
 ommhqmlI//BmBSpjvaZpeCcO7SXDU6+0HhVwFbJoel/lbDwN9tb0Q1Fpfjq3OJFvK1aP/mkkOuE
 P5FRJRKcna2FfalADhYzlKVSwAkrN54krW7KT2emrntOZZEVu+6VClcqx1cjQ1Uyi60W56xnqOW
 wVIR9MK2vEYAGnNYntA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-06_02,2026-05-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605070100
X-HE-Meta: U2FsdGVkX1+JaYjONNpANzxJRXxxftqX3/R97KnH3w5pjEN7lUQJZiYEy4swpwi6TGWpEQhnomKJI6au6x/OZNbwZ/pMf1BULQU1EGv7mxWASsyNXnZoJ6oKnJ2uzp+j5xhAj3JZUGebuvK1hOrNySKZ2SACzgImTn+k8ypEWpzBYZyj+1tfkzvb/u9PPibqoazQrVB1h37goWh0vV3eivRuBUUXhf+6KgtKFwOlJf6ypgjSA8fdpOYsG96O/vIL/cZeFVm/tzplafxZMPAyPAzxDUhfiaWcG09qGNWGVhbnu8W+W2AjaYRxrUcu8SY0tmJmyCvUMnU3ulVFDIFMLY2CFOC2MraOmU70gQEa9MG87A8TrjWYE7mBexPG3VrQ7uYR4srZjFR34hmU8OdwNSoMOrytS2kvrnF79SENzhq/sqJ/80KXPhWpTFRYXwb/pCN/7KdhjpoXNajW3rw0LX6CBmYe3BZFAPD/DSKeucexrllS3wRgjtjfcHvuyJ0pqfTRxZpddSeilpZgl+LMF8LYSNY0iPvZF/fghb+o9Ezt2Yaq7pHSDJaDfWReJ9Uo/QAHZKPP67f43wZyYEWtjhW/Dy+KH/jmmkhzlo9H7lQu4tTfh6CmOFjSzoQYMnechapoFtcqIft5K8xyrqwB0ZSrQiG8I7twKc3cdz/FFLzbUMbYe22VY/xdv79SjeJlqmSwzuXzVdqewtK+32idPy3Yi+1DMRiGR5PluC7XPE87Bh8sWlc8yra/Kp8F+07MX0IQy4N4GFbWPuM7fFGANQJlmAkkh43DgpOzqzvJzA0pPGpVBX5KCFAAP716tQmb/NCkHKmt+5dwXKx9mznBz2obe9WmKQpBojK1iXC/3NFeumlNmKETdhFhElgYeUGdt6NVSJkWjM4F1VyHUbIpLLXZi5uBo2bz+Obl6EUxdRpD5KASfZ1hNQqtlSWjKulwFk45cDmHL4xbE5BotkY
 hP8geieZ
 miUUjDcnpzQ/VnIPTjqn/5+IXUWRTk312Slbmof0HVl4zHTRVX2lFlCJWpJ7IJw7k0p8w/cNAm1AmIyDAO0OogAe+m+YQnvNkJx1soIo1U+AamQntWQkqndbiZxhD8476nEd98+GpSmv0ydhGygLLpN/ZlGkmmOgMog7vEscpXz87bEopXGfV0SaniYGutxlQXHvXIcUjBL3tmMstaSTEKr1nKn8QTqnrw+6+I4rCr7aIOJHBKcbD3gcwCKf4UIntplnLRKrXLJx3Xi2oDXa/QSMV1iO3ccb4067J6OKWGsupjgaJKfRuIKZ3iwYDHmA+tKZXxOSwSKXR99I++D4Um+srI0ph0XjSIrSYkAxJ1pJzWig3Z5G/+1g5uQxHa9JAXtMOKDndIxWV+XwrRqTfJOHj4A==
X-Rspamd-Server: rspam07
X-Stat-Signature: 8yr7ckj7wk6i6fiu8dieqxmgnqehahh4
X-Rspam-User: 
X-Rspamd-Queue-Id: E4C1640007
X-HE-Tag-Orig: 1778149941-397880
X-HE-Tag: 1778149944-973986
X-HE-Meta: U2FsdGVkX18I6B3GB4aY99a2zfNX/cV5T66IAX3grDwMRsJMH2MLkSG8VVNZbzixHqWl+zzrb3A23WKcGaeSGvDX8xaKnFDrh3wtY5acKBCiuxhDtw6Kh+YQ/HbUNz/WHKzTWCEKIdqvKbxBE+FwoYEPetbQ1vOCnYgE0a6YYFNNB4HOJdyKZgd2DW1lxI52JDyARrVwj2g0k9qtG8zrlYKPqEPDkhvnWGaXz7Knek1iaBygpNZa+H5GueGLQIjTnQmC4/SukgNmg0YuEVXlVeqRaR+zxoIDeRhV+0+otJv54Dc45f46bPPsuiZFLHeQkUD0sO/chSSWaCqNOXBCL6DBDKlEBQu0tuOclwQ2BQ37E8zPW+w8SQHvF3WZtfnRnEP/YzQnZmx4CMZ2YaN16og2+76uCeAmF0zsldbSMMy2SJjX3/iMjLXnI8IdwS5/E7Gp0eSEmS696T5HFkaG3C1UZw8/hQ82INgtjBp8IvDhsZtNLttia1Pxc/zdDTif7ir2vCdRVICiNtTRXPyu/O+E+FH/T5LQdm+bqujrTeQRLs6+/PpRDicV/6CU80iwQdYs4tvhAMY1oN4EsklgX4BGV1T6d8R8aPuH46+T7nY7vzwJ0WeQ4MNIE0bY+prMJiKs3sLQlH6XeLNYeiag6MTH9QHw6NGv2kldv6dpwno+Gs5VOUMbXshkjq2fgNV3vjPEfNyPaexDrH07k3sWLU24Sg5aqSuYCHuVz67sFjeHCkg/62e6RJjajZ5o9d1bxl+Et/67d92UtkKq7aTGBphWKApkDV8OHZGcUmJBXsIwq08wpzaHGbMrVmd0WdtwmxpjyTa5dBzZevpb7nOIKUyHS8sc4id92yX/czn9qGo3zeMZCH6psy+nBDoiCNilj/LbB0wgejpjAM3mVnMyPAfpG7roQyRqf7FgZTQaXWDNvH8gDDEDGSif+T1z7LUcFDZxH88GDbZba18yRh2
 h7VEIsLH
 e8vqky+tB0GMpv5z197GWEuBewvmrbwkGtdRyLVjHemIHr10XKXUEjQMNl8hCBkoSKpyPjOEyMamZPC2TYessNx49tG3vALPoW1FN/w5GG1JoCXfnntz4G80qiIH75J24JPkNGAyOd2Mt72thaFdnTLJ/ecTKM5lkh63pwVLCC0g+OpC4HjmpsLyMKKU39sfowZfM25OYNpDmmfekX7Lzi6MEgO4rkdQNaAXbFmTELrGfGdNmGYX2omugqR+gW8WSi1mbe0ut7uo5eXq/Oo47nUFwiFOQxN5GwhAzB8DWN7mgT8Kq25fijbLRujpeVAmZMyl2xF9UTUg2baNPXOX7HyJOy2zTWDC0N/qIim/Qp4428c7C6Uz89TeZ/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 07, 2026 at 09:34:33AM +0000, Wei Yang wrote:
> >@@ -310,7 +310,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> > 				goto restart;
> > 			}
> > 			pvmw->pte++;
> >-		} while (pte_none(ptep_get(pvmw->pte)));
> >+		} while (pte_none(ptep_get_lockless(pvmw->pte)));
> 
> As Oscar mentioned in lkml.org/lkml/2026/4/27/630, map_pte() may take the
> lock. So probably it is not right?

If I read the code correctly map_pte() might take the lock, but also
might not take it. If it took the lock and uses ptep_get_lockless(),
then it is fine. But if it did not take the lock and uses ptep_get(),
then it is an issue.

> > 
> > 		if (!pvmw->ptl) {
> > 			spin_lock(ptl);
> >-- 
> >2.51.0
> >
> 
> -- 
> Wei Yang

Thanks!


