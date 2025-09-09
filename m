Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3423BCAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 16:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 611028E0005; Tue,  9 Sep 2025 12:08:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E8388E0003; Tue,  9 Sep 2025 12:08:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D6868E0005; Tue,  9 Sep 2025 12:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BA158E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:08:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3BB8C0675
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:08:07 +0000 (UTC)
X-FDA: 83870193414.10.6AFA866
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6DD18140002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:08:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RMUDHvIY;
	spf=pass (imf23.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757434085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yCzij3lwPXWu6sDllPHsxlKV1DFXRLK5f2LdkRAekRk=;
	b=RHDo6/ABOhQHoYxuVbKB9YodTadIgcDhR8imWpj2pYoO5Cc+sbO79/4Fmq0QCDxk0GIDu/
	WRxMkTSR24BD4jROnjphQeNx353mPOf3CyEszOYDgy5m4Tjo7mxlH7PWIIyf8n9/dIAiVK
	AsPjCZbnKdbiDNoRb2osQiC66XH0F0g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757434085; a=rsa-sha256;
	cv=none;
	b=Fg7MZ+HC0aEu8WbvnYaA5mjEGgKBbteg2ar+DvKEdf/G4LdKfsWUWsaPys1IM9CzwE18LL
	q2Y9Ukfw4ajksU5OG7JZ8geEKKpsGd2qmZ6E0sOlzuVwiZOKQU+iuy75J9n5ZQMVdsfp4m
	fxyG8wuxyciotuRKP27wk7TOZ9UchgM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RMUDHvIY;
	spf=pass (imf23.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589G3Fq8028539;
	Tue, 9 Sep 2025 16:08:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=yCzij3
	lwPXWu6sDllPHsxlKV1DFXRLK5f2LdkRAekRk=; b=RMUDHvIYarO1NPovxTczAe
	k5kcMSb813GbwXwDV6i4ZK6LkfrpQy9OPMQNkzLid/8iOJ6UFiFTB4v662KJj/Dd
	58SKurn/jRaW9EbkWjd9mvj/oL3ZGkWTdv+F9AdhVcOdqo/Imn0V379zX6kGhInN
	KQFzFw3Y26OWLJ7o+VadH3+AiWiIWFLwNOzEwZCgrAhljE3ADExSzJvwl7KmSDYw
	Fwa5plZVDKk3OKh/MWTFoUZfTSyVwKrHnu5upR4CqRtOBsGoeqjh97OR+9ZUWk7H
	JDeAyo5z0C7YZvO+lfYx3MaH6X5fDTu+DuamWysIUvPbfo/my5hNE1zNthV3lImw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490ukee3pa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 16:08:04 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 589F1qF6001188;
	Tue, 9 Sep 2025 16:08:03 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 491203bpx7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 16:08:03 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 589G81EU33817068
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 16:08:01 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E31020040;
	Tue,  9 Sep 2025 16:08:01 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EB0812004B;
	Tue,  9 Sep 2025 16:08:00 +0000 (GMT)
Received: from p-imbrenda (unknown [9.87.128.215])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue,  9 Sep 2025 16:08:00 +0000 (GMT)
Date: Tue, 9 Sep 2025 18:07:57 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton
 <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard
 <jhubbard@nvidia.com>,
        Peter Xu <peterx@redhat.com>,
        Christian Borntraeger
 <borntraeger@de.ibm.com>
Subject: Re: [PATCH v1] mm/gup: fix handling of errors from
 arch_make_folio_accessible() in follow_page_pte()
Message-ID: <20250909180757.1114d727@p-imbrenda>
In-Reply-To: <20250908094517.303409-1-david@redhat.com>
References: <20250908094517.303409-1-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDE5NSBTYWx0ZWRfX0lWyfEZGUS5w
 LXY1c5sfuf2PvmgsPHWuzkS83RGsrAWpM95nq+N1tKo5UF9U1zi/qyS98B9Hrdtgd1vd4oX+MDw
 6T2KHaGz34IVzW2xyMI/VgeytPjmtz/W1yF0ZnuXiMeUho0dUtN+zS/YAwgpqrTs7YdjO+tT24t
 yAdj5SMIAFUOcJvRoThf7tu33NkqVNw/wY3iIc/DXVjYak9T9G0zxVgnvWup4U89NMJU8XID02F
 SRy8zxIXVOoCZbA9ncIax4x19FS1Zjl9EAxURUNtvQY/I/fnoNp2xTgIZqGkRjmQSpgzTRNdxAE
 1acb1XLGrt1uWX+Km/KDVO831wf7CYoG4gRzGAHNbMzX5PO6sn+wPJ61we+6JaY2RJoHEZVIc3b
 zY4ew97r
X-Proofpoint-ORIG-GUID: vj4YCukf9maoZjMYBKZeshE7HQm4n5R6
X-Proofpoint-GUID: vj4YCukf9maoZjMYBKZeshE7HQm4n5R6
X-Authority-Analysis: v=2.4 cv=StCQ6OO0 c=1 sm=1 tr=0 ts=68c050e4 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8
 a=Z4Rwk6OoAAAA:8 a=9jRdOu3wAAAA:8 a=Ikd4Dj_1AAAA:8 a=FgLdBiW5u0QFqUhnriMA:9
 a=CjuIK1q_8ugA:10 a=HkZW87K1Qel5hWWM3VKY:22 a=ZE6KLimJVUuLrTuGpvhn:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_02,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1011 adultscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060195
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6DD18140002
X-Stat-Signature: 1jxryheh7bh35q7ewk1uac19ryckps4y
X-Rspam-User: 
X-HE-Tag: 1757434085-733658
X-HE-Meta: U2FsdGVkX1/Xqxzm1KVNof46sttO/5Q6dzz7GGF6PREaye7oXAYbeHkP0J5vIFIvn2yrQctWo7xRJsX5vaTRO/4XEAH2LfSiCD/tod50mqMGT+LnPKYWd41kQrBZBv16HuLCARfaMqOWD1hbuU0fmzu5e+WkM4mBOPRa5AiGAcd36TMGF7tBBNMnfSEYCdaX26Ru5CQgXB7+Qvj35qXX2hsaeOWMFv4ga4eGkTwPw2GBqRcqu0+WYUY2G4RsqegngBLRs+Z3OERdt4F06WHM+jstby/R2MSiyAi8H8Q303WDgWYe4jcyqVsONiUqEFuobQyoij+l/GT+ABhw8mYul5K4wCgLkVFssXenanUuwKdLWP+7I+zUKWw9mzP/pAsfKeHni+dUwxpikSXeczvwLPHD+o9gzhJHAhonCGonNEmdVMouB+BDsGaLcNwFrdb6Tf10MVuNrz+PheOCF2Wjzx9w0P50Dn0tv7HLc65bQeizxt8cQAo0ueLhjufbolyT66WLslOEXEPA28slKUfIHKIlTos4X0mtLx4arogNfJAoRAPhJQg0UyKkEFd/nwgc6uN7pMvTyeh10HRwyxOpqKTbnmXgVLdyE/aGk+/tlwejTCBSn2MRVbGHvgEYVkTavCvkoCmfD9WzCK0khxof4B6bHbVvoG4MBubfyBRt14TxCqBFKl2Co+MS+v34trdv88ytkN+seC0rdA+jx4a/mZpIXRsuvCZ8Y0pwPj7qPFDPISy7gbxghEDdg5oz6BctiYx9+OH7U0RpiBWBw3pqlpxxs+p+L6V3xGfiTsVw8VYuD75ZJ/PXriR8enPPBqwZOm2cQpSD38YcMSutj02KtGSnjBWzGvlvC+spyn0HUPjVl6jgDJIaYkfYOggM56OSbPMyMQtpx7vFdqRFiHxPfIYVQ36XOqi/zQjaAb7hSFIolUrBzAXido1Ha8XGvtd0RfIIvzCevM8Puw1KOEr
 XLAwgS5T
 5DW/HXcoXpmG4F/oOzOkAEFw6okOENqQ3AXo4QtXZPOKTs0+PBDkogxFq5Gsg8VHYKGRcc7o5KTUh7YAHGkQGaEYL0t/ZRhDnUIQXCna9xKtpUSXjDDDallHsA1ijp84e4SQGVTFlgVweENUi8AweyyaUEi9ENbJlZaQV2fAPkxpfA2V4m0z213GkU3hqkMQMGiFvf4xdXe6QxTd4+3E4YBS7/sDrY9uxcCdRIwlWxBhJ4kX5BN7R737BddMjGB+x1Nm5QSjs4dRybx6Dtvax6Zxem8JY7SSLo9u2FZ/YAC5tP2l6cQW/romMJys9OcUl3ojzlYR3VyI7kxumKtQndCYhEI1HEN4y1f0oiBvxNLHnV1YGklCoJCe/ugCSEP8FZHcNUR66LNyMBt1rpEcFzVetYgpzT3OfrVn3W5NgYMdjnQRim0xv+i/D0dvoX20nM1dfDHRnEoN5d5P7ENNhrlDYqxAdmPJTE+jEBU16FcTkByjZyg0TfqFAhHZ364V5k5DOK5yFwUdOeBiu47oeT1wrmbRaw54p4CCIh8cR4fkJXzPwccEcvbQQCll+9MjU4ox/4ymWUgPiIMQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  8 Sep 2025 11:45:17 +0200
David Hildenbrand <david@redhat.com> wrote:

> In case we call arch_make_folio_accessible() and it fails, we would
> incorrectly return a value that is "!= 0" to the caller, indicating that
> we pinned all requested pages and that the caller can keep going.
> 
> follow_page_pte() is not supposed to return error values, but instead
> "0" on failure and "1" on success -- we'll clean that up separately.
> 
> In case we return "!= 0", the caller will just keep going pinning
> more pages. If we happen to pin a page afterwards, we're in trouble,
> because we essentially skipped some pages in the requested range.
> 
> Staring at the arch_make_folio_accessible() implementation on s390x, I
> assume it should actually never really fail unless something unexpected
> happens (BUG?). So let's not CC stable and just fix common code to do
> the right thing.
> 
> Clean up the code a bit now that there is no reason to store the
> return value of arch_make_folio_accessible().
> 
> Fixes: f28d43636d6f ("mm/gup/writeback: add callbacks for inaccessible pages")

Ooops!

thanks for finding and fixing this

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/gup.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index d27b6b9818a18..c969259d095c9 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2920,12 +2920,9 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
>  		 * see Documentation/core-api/pin_user_pages.rst for
>  		 * details.
>  		 */
> -		if (flags & FOLL_PIN) {
> -			ret = arch_make_folio_accessible(folio);
> -			if (ret) {
> -				gup_put_folio(folio, 1, flags);
> -				goto pte_unmap;
> -			}
> +		if ((flags & FOLL_PIN) && arch_make_folio_accessible(folio)) {
> +			gup_put_folio(folio, 1, flags);
> +			goto pte_unmap;
>  		}
>  		folio_set_referenced(folio);
>  		pages[*nr] = page;


