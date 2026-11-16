Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFDDD606A333
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 17:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=H7cBltWa
Received: by kanga.kvack.org (Postfix)
	id B6B1C6B05B3; Mon, 16 Nov 2026 12:24:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1C096B05B4; Mon, 16 Nov 2026 12:24:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0AF86B05B5; Mon, 16 Nov 2026 12:24:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 79DD26B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:24:36 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F22451401A8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:24:35 +0000 (UTC)
X-FDA: 85441656510.16.D8FD8BD
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8EC29140002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:24:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=H7cBltWa;
	spf=pass (imf23.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794849873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dEx5D78mD3JLl04XVy0Lx8vy3qVm1Ne+25ZFs32wW/8=;
	b=kZKjjVYsEB+TY4jrYfvIEE+xa0Rm/AO18BzUfqyPiQMY6RTCOtin8eP8DG3DWqRU95uRO6
	FSL1KGzNFMd9QYdnfBQ19zl3DOuJp+JhF6fbwJfruuoXaFZbElKasBCpFcvnVjnU/Wd6QS
	hasXUkYaxxj09UuRqAx3JVPTdwSYeCE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=H7cBltWa;
	spf=pass (imf23.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794849873;
	b=E8sm0F+YzB9iLpAlVydkIhfnU+isLE+x9kb6YqoRlyt1E+04STZeiC8llSmhqPR+BWsUPI
	I8I/V4gqdiqFEMlRUOT4FJjIhpivaqGAb8FF9u94d/Zxb301jPImKzKjv9Owatqr7mwrl8
	9sG5+F7DfW9eatwpkq5DKCE6NfvK3UQ=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGGQIR33952496;
	Mon, 16 Nov 2026 17:24:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=dEx5D78mD3JLl04XVy0Lx8vy3qVm1N
	e+25ZFs32wW/8=; b=H7cBltWapocpfh5ET9BzUPRMtQ7SO+VjNYPp3n70wHcU1o
	Q2mTJ2KnFL/SnXQpbZglrAvu01FSlv6Uzu+K2JxGxSTMBeXmuzWWUlhw0cViuvMI
	xRCa0z/zFzKxYzyiO+ccbp/sPEjk+sT5UP18qGWMNBMsRBOgRQ+Ww4m6AT1S3FUB
	XTz/HQWxtQlJzKu1CzowgINKLxDtPzfIbGAfW754o8/4NcS/eMkyjZZOSDKtdXOS
	TKmZpPxslVoQwzbAiS2+MYhM5dAjZeV6SfedxjXiK0UKfZERTT3IFtPOi7HA6jmm
	/0khABj+Vl+YGbhp+sx/hON4D+O4A4S6MbkV/Sgg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hxf566s75-44
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 17:24:30 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGDH6xb006236;
	Mon, 16 Nov 2026 15:22:24 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j02ju84xe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 15:22:23 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AGFMIYv38470036
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Nov 2026 15:22:18 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9184B2004B;
	Mon, 16 Nov 2026 15:22:18 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3444F20043;
	Mon, 16 Nov 2026 15:22:18 +0000 (GMT)
Received: from osiris (unknown [9.111.42.169])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 16 Nov 2026 15:22:18 +0000 (GMT)
Date: Mon, 16 Nov 2026 16:22:16 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/14] s390/sclp_cmd: Replace page allocator calls with
 kzalloc()
Message-ID: <20261116152216.165348Aa5-hca@linux.ibm.com>
References: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
 <20261108-s390-sclp-ready-v1-10-3e7c90eb6676@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261108-s390-sclp-ready-v1-10-3e7c90eb6676@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA2NyBTYWx0ZWRfX+2O5PVOBGRm4
 FWIhneTChQLXoZ2kIFlgINqRwVfxwlG1aOUmR54AO5jxUjfFeRpvjfs/bg1ZR6wS3v8KVfZXa7S
 DKcTlz5BUBFqHvFz9msLEubK1Kp9Bvg=
X-Proofpoint-GUID: f0uxqCT8GrkzDgYIakB12Bhvko1PUInj
X-Authority-Analysis: v=2.4 cv=ROImjIi+ c=1 sm=1 tr=0 ts=6afb3c4e cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=oZZkxJ__kemSVIr8SkYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: f0uxqCT8GrkzDgYIakB12Bhvko1PUInj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA2NyBTYWx0ZWRfXwkwVlvTf4uTT
 12kAiApmGoF+kNpkbSzOVu/+Xk8rrCIsFmh6Z7k+ube2a+BXMt5GJX2316O6yaRb5HycaV0wTk+
 8do/yExt/pAj/feV2lTtD8TfcpmwK01VO6BzQCz4DWLXrKj/pfCzIUlMPRkKNUG+ORry7iYM7Ka
 47eEUdIqT2315BGgDXp+r5FqOm8rsZGnPoY+zXIIHGm4zJtN0T9v0RVloa5zzh6sIijCRVHQ0yM
 VbtAta+uH+vA/WY78IgUdyoL7sMgujABnwIEe0GQCg4KHT0sqlEgKqhvJ2sBke2R4KAaEwbdpFj
 2AdA1Gk9ysYsArMj2vj42UsM/w9319ZcAs6k5gQEYYWNx8btnEUp2zq9b6lkD5K1G9D5WaK7RXa
 8Ab8CeybvxSuwqDfLjKJdIGjTI6FwkUE43fwcdc39if464BaWeEzsCDsPy3HWBsvcZgSwysoyGw
 YtMlfKJTeRZvGz754/A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-16_05,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 spamscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160067
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8EC29140002
X-Stat-Signature: kzc3itqeanyespm84h5icx3pibtge5jp
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794849873-82467
X-HE-Meta: U2FsdGVkX1/iaV4gC0oNI0ZXdKJP6egEQdz7EpqoUI1lDQ533VWNNpj12twAKir8XdNbC7KqlcphgKhx5+R+0ot6ywHDODSQcjDSrW+2+pgb90ZKva8hBM9dJfyB/p3X6NfjekIFHhaOoSTZGBKtQpzohkzqvHggjQgWsdWs9q5yw7+TV6WiB3uBBtRUCvlJbZOMy+V03OITT19u3YBDgnY7rBvFbgGjKXb38L63fPVVGurETNkRDvu5ktspijSWA6s5Yz4+3zea0Y03H0yk/B3TFX9JvbB7GLsLqX0E26dFG4sY7ZzuXbvmLdC5KI2v515ClkGCBaVk03IWO7rcUQK9qG2+DAkgdfDGGhknAQHiEntNaZPEaoDU4HPU4YX7rAej8VV6/VuD1jI1d1mhUnT/tlJf9ldcNQZqubSMZtXXD1mFeLfZOG68LYKcclBqay6SrArKjadOFUmAnljuhfMKcP1SwOuYgSq2G1pPyYj+iyYeP0nbAmM3k7w+Amt+yv7CuwKWwfxxLssDjsqIVtS1NW9e5+VvbeDEoSXXFevgDhpGVnNJ15h5EaAKYouY2GGnzCmFODebYzMt1kjTAlKjhmy6fhAYa3b0X2F+HhXco2YR9B9hYCE+JqiWre+u9G2MDhDYDdvaT8um5dLTsUNAK/pigU6tcCoK50BRI+2Ifk/wYlzprx4cRl0Nk/npoc2jYqaFCb9NAaH+aaT6tOpIvYoRm9CaOGrnArruzCN92o4WLWdARvk5SZL0aatH7sR8BL4Va/kUtQpZFJM4uLhSsFJy20sc1eqgOyqFn0UOjwyNUeR8XAdrjm4UUVRHgL4U97nyhBGhXsoyBIhS/crHCj/wBA7x9ZIR6kv2ZkOWx6PIWFGGOr0ZoVG/t4rgeUU6y6GzDvwZJdb2MW7bjiP2Xshh9X8eweKMgEnjtsTtrItr6qb2WD0ulJiTMc4hqhHlm0hWp/xyFPPeTW5
 Th41NKbf
 J9HmGXfI8cWuKk0Kj484Iur0W9dChmXZkq6RdAAbksIdiGW72K2aycu7GxDSCIbbscNNF5hNh8wDDP7/VvNplCoJaBBgkpS3x+vqNd9VStq4uR12saOti0mX1Z9pYW9XGEgYyJ4yXydGz9jja7BCj1/GNhyKX8J3ZpD5ddF5IMAOkAM0YKvwBHX7Us2cuTrmvOfvZUCFMuNNysti2MeRxbT5atTexgH0vZSF2cGuvisZhGEQQqmHuqmCcVFW+0MDNLJVv4jOgwIBlS+2h1Pmn0OFlUqOuH5QA7QRdGXX5zbXX4Oex2hEvPVAnm6pgsOTXNaUZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 08, 2026 at 10:58:41AM +0200, Mike Rapoport (Microsoft) wrote:
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
> While on it, allocate only the amount of memory the SCCB actually
> requires in _sclp_get_core_info() rather than rounding it up to the next
> power of two. An SCCB must be page aligned and kmalloc() guarantees that
> the alignment of an allocation is at least its largest power of two
> divisor, so the extended SCCB is still page aligned.
> 
> Replace use of __get_free_pages() and get_zeroed_page() with kzalloc()
> and free_page[s]() with kfree().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  drivers/s390/char/sclp_cmd.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
> index 1dc93d945be6f..6aaf1f6a3633f 100644
> --- a/drivers/s390/char/sclp_cmd.c
> +++ b/drivers/s390/char/sclp_cmd.c
> @@ -102,7 +102,7 @@ int _sclp_get_core_info(struct sclp_core_info *info)
>  		return -EOPNOTSUPP;
>  
>  	length = test_facility(140) ? EXT_SCCB_READ_CPU : PAGE_SIZE;
> -	sccb = (void *)__get_free_pages(GFP_KERNEL | GFP_DMA | __GFP_ZERO, get_order(length));
> +	sccb = kzalloc(length, GFP_KERNEL | GFP_DMA);

It is a bit subtle that this really works. EXT_SCCB_READ_CPU is 3 * PAGE_SIZE,
so we end up with a guaranteed 4k alignment from the slab cache, which is
indeed sufficient here. But this is really not obvious, and not as stable as
before, IMHO.

I'd prefer to have this changed to:

	sccb = kzalloc(PAGE_SIZE << get_order(length), GFP_KERNEL | GFP_DMA);

which comes with the same alignment guarantees as before.

