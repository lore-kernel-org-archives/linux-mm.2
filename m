Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53303C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 13:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D6606B0095; Wed, 26 Aug 2026 09:57:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5876E6B0096; Wed, 26 Aug 2026 09:57:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44EF46B0098; Wed, 26 Aug 2026 09:57:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A8A96B0095
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:57:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 880EF140110
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:57:52 +0000 (UTC)
X-FDA: 85143573984.28.187CD16
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf06.hostedemail.com (Postfix) with ESMTP id 08203180007
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:57:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=YsU0NAN8;
	spf=pass (imf06.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787752670;
	b=iOwKR75cJHxN0KH6mGZKuqd8FL1GqObU05kSVCkl3zufsFN6007xaamygt4H5wHB6Ffzjz
	7dCqthO9UqBuQkEMxF92qYLPefUAs9ijYf9hcQPPpgZWVFnHuB0xZRE952Kzjo+9FGAtDj
	O+3UMDJb2cA8atKO67YT8PzSIupjL0E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787752670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2LiKUNUJ1OiL3bYqU+s9DlRnAseVi3cKYOI6b9crRyc=;
	b=HDfivqtJUSTz0MBRSmcxY17dnWJCRe1lW3y5KjaTb1/UfadzOJpCYz6FhfnqZhw9olG67B
	SzHIy2di/r1Va4owByEf0+zQUCZgwyqRpOyvIOiVyjzUlfKDKEfBSuwBoRQWUQY4Lrt7ph
	u/T0rxt0JsENL9X+SYtG4J//f5qsn20=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=YsU0NAN8;
	spf=pass (imf06.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67QCWEOD3894025;
	Wed, 26 Aug 2026 13:57:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=2LiKUN
	UJ1OiL3bYqU+s9DlRnAseVi3cKYOI6b9crRyc=; b=YsU0NAN8ubXRkP699Yyag+
	++z/zJObPD2qbkgKdy/Y+NMGzk+v3l3MAQ53dM6POe5oMAxpiSCu/gErd+Ono45z
	YCNS03vUkwrd7NOf3Oyym8vkP02mExnkwnVi6GvKIMQpZtyb+X/qs1FxX692cgoZ
	dJvyRH7nE0AIP5mCbsdRrkD73Q37dcR6BO1DW1TeFZdqyhuzpaiqNf29TZlcgNDf
	5gWpxcP0owI5YAQFvUfHBsNGZLN0UCQCWWa8nDB0zp9CxssVYgGdxrhYT5aCMfZA
	A4DskgeC7F4VNjUM3aQzIQ4d0kGJPhXy4obYgW0mwgsNL3piwyoBXi6pizrCiFTQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g716hy57w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Aug 2026 13:57:28 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67QDfImv014111;
	Wed, 26 Aug 2026 13:57:27 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g7qkha6v9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Aug 2026 13:57:27 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67QDvPxn36307332
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Aug 2026 13:57:25 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7176120043;
	Wed, 26 Aug 2026 13:57:25 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E4CB620040;
	Wed, 26 Aug 2026 13:57:24 +0000 (GMT)
Received: from p-imbrenda (unknown [9.224.75.30])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 26 Aug 2026 13:57:24 +0000 (GMT)
Date: Wed, 26 Aug 2026 15:57:22 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Ackerley Tng
 <ackerleytng@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Baolin
 Wang <baolin.wang@linux.alibaba.com>,
        Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>,
        Christian Brauner
 <brauner@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Christoph Lameter
 <cl@gentwo.org>,
        David Hildenbrand <david@kernel.org>, JP Kobryn
 <jp.kobryn@linux.dev>,
        Jan Kara <jack@suse.cz>, Jens Axboe
 <axboe@kernel.dk>,
        Johannes Weiner <hannes@cmpxchg.org>, Kairui Song
 <ryncsn@gmail.com>,
        Kiryl Shutsemau <kas@kernel.org>, Lance Yang
 <lance.yang@linux.dev>,
        Leonardo Bras <leobras.c@gmail.com>, Lorenzo
 Stoakes <ljs@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Matthew
 Wilcox <willy@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>,
        Minchan
 Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
        Oscar
 Salvador <osalvador@suse.de>,
        Peter Zijlstra <peterz@infradead.org>, Qi
 Zheng <qi.zheng@linux.dev>,
        Rik van Riel <riel@surriel.com>,
        Sebastian
 Andrzej Siewior <bigeasy@linutronix.de>,
        Shakeel Butt
 <shakeel.butt@linux.dev>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil
 Babka <vbabka@kernel.org>,
        Yang Shi <yang@os.amperecomputing.com>, Yu Zhao
 <yuzhao@google.com>,
        "Zach O'Keefe" <zokeefe@google.com>, Zi Yan
 <ziy@nvidia.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 20/25] s390/fbatch: no lru_add_drain_all() in
 s390_wiggle_split_folio()
Message-ID: <20260826155722.0198d3ce@p-imbrenda>
In-Reply-To: <7bf68e7b-f88c-6ca9-39ab-e9fedab0c8be@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
	<7bf68e7b-f88c-6ca9-39ab-e9fedab0c8be@google.com>
Organization: IBM
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI2MDExMiBTYWx0ZWRfX6oBMoAXUz9b+
 R2tF2RTZdZcuqOBhxLba2axaGWhWg2Kl07rlyQKuFHwjSqkOxhSrWknwqzByANHgzXMIgsDlaEU
 Idl+30dokbx5c7aGM1azQMrbbL2NzlU=
X-Proofpoint-GUID: ic4DR_A9PttbjD9aBnZ6wMO72ql0cvfP
X-Proofpoint-ORIG-GUID: CtVKpmKXa-6fjrMbMK0sces9C8ZO455o
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI2MDExMiBTYWx0ZWRfX7/j9vZ3raXyB
 Me/IVg+MC4rfQk452IoupMj8YDfCrRb2aDsOD5v2ra95DbPAkxcv7e6jEP0qwG0PZO4yv1Dhl8A
 MDor97CDbv2jWwZubFtFo71f50APNaOXyPErDM8wuF9ANlsKg4R8mN1ETfKeEs7LY/eu1rcSswR
 ujmCkelqB5shvDHGHK7KQOqUTjGxr+/PE2dnk7Tzh0Q9LtWA/LNTZI2nOT5w+ACGn+182t/6tXK
 bPa8WHzBebLfwFyGylResRBGUAtgIcfqoeAZhfcwRefUAXVTJ8Ojiq7mZr55C0JybbHa7HV8jvi
 8uJw1ELRQYwi4ziuvlfXVFScGfFjx3IZg7prbBCfBy1ZK0LLB7Ui/X3wJ8bY09SA4c4pI3mYqwv
 qNrzli/jLZlc8rSiWLGU7lnDa8/sZ5pE5EOrVG5HVnBjdZ3HWdNB9DZb6M4ma79dfwpc/F0B57l
 J4jca6EyH0POQCLZBWQ==
X-Authority-Analysis: v=2.4 cv=H7brBeYi c=1 sm=1 tr=0 ts=6a8ef0c9 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=1XWaLZrsAAAA:8
 a=67rAruxoP-Qw-q3ESxAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-26_03,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 clxscore=1011 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608260112
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 08203180007
X-Stat-Signature: 9nnekcbb4y3wtnusrfnwg333rwpwm5fg
X-HE-Tag: 1787752669-769214
X-HE-Meta: U2FsdGVkX19Hbb91UsGmgzke/v/tgEJD6aWhvSC70Hny7pMTEKUjKKAHbwaQRtNa1VCBCPfUKcK7AdLCsRW9jbK02YlWIDEEmkucGwWY2vKWEkoIkxseiuPre3bZTwuhoa/+R6xUeX+CwgCdzqpMM1Y5ftwpB26GgMk4YYMtuuP8QGHphg5ohE51l792Lw4xJyUXRHgg+PkXMPGfQGEcxHE2qxQ7dwG3R6DrC2lejLa9akujd7q99HDaRgWOV32ag3Xjv/W0Ntb+8BTDN1ulM2VRBrA95KtURQzmzOcgIRf8RRP+HGM83Oy7FdHGrw4xCa+noECzwXw5ozZsfvHNEx5SqKXYWQnzs9dXfjha/RXZ3MH+qKH4bzDyd8RiH6RUNyD4TQaUhHMXhNM5gX9HoVHnXYsCbTJK7BnqaN+YHYeRQ0dCxrOeoF1N9n8ZGyxiBnP38a+20ZkvbkLVCLvhelxMqvbNf+kqEhaAW7KY1RLC95UGSRvmJFKTnCpmPtGdL/Yh3QXvXA9nX3KNxZSNfO9JQNj5kXOld9GLVEMlIHPvm7Taq0qRPfj9ruoSc7FDXzOZsrORI7+RbdCeRfuF3TXsWC06vbTz2MMjyoP6eD+spXeex5GZTemw18tBNCQ981WMoW0TSoxGZmuLyBE0egKcOWM72QdJE3yuDYZgNlA05dXOaBI7QOkLJAD0cYmX3GCazklJig5vfIBZmukGFUaTFZCUOwpuhNcHfmqWQ17QvptjT9EjmBA0nJHz+8BVelz8ESFfIgPVqvIqIKKkUz6PaqjZqjkCW+paarlkY6wpTvzG40IlliUiOsV10l8gDkllrn9oa0zXOAw+fbkRE82na06uMAYHo+wi2lQd0NFK4YlCES63UKt4aITGC578xuiWAvCQdOgKypOT68cIXN2Q/iXzcVYR8opoqb0s/etFRPsE/6Q9RUAEBDxBsv616xj+GAix+qxmZrnOVIo
 uf4uyXFx
 wKg6d26rOFqKS/GNd9tAs3cXKnoAmcspzHG3UHdk5F1+nFPRjcEG86Zt9jawykp1f24rxEsRBiMIB/JtD7eGi2JK9O5+cSd4f+l5eOGTkXn1nqtn7YtuHXHMpyJRi2AuR88bQVS/Y8ilKRmKd1qTT0ju2gIyqitJaIKcCYcM3P2mcJSZq/mCA2585hQmtHWWWOI5g2GYlp9j1aYkRIEWbSzCbbcTge90UX7KqRM72sFhEj1U+EDUuqJtbNwiCjlxNxt5MP6ZzTz/2YAIaUdA7kUjghXb+DI83giLWwtq7VmUnsHLNeroI7nUMFhrem053bYKWxmRxKtLrljnVFmJNJ3eR+crIuK8LOvU6f45NtyqxAYqO+qNCkBy9lA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 24 Aug 2026 07:39:12 -0700 (PDT)
Hugh Dickins <hughd@google.com> wrote:

> s390_wiggle_split_folio() has no good reason to lru_add_drain_all(),
> now that the per-cpu fbatch references are gone.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---
>  arch/s390/kernel/uv.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index dc14ebc0105b..120a467026a5 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -364,7 +364,6 @@ int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio)
>  
>  	lockdep_assert_not_held(&mm->mmap_lock);
>  	folio_wait_writeback(folio);
> -	lru_add_drain_all();
>  
>  	if (!folio_test_large(folio))
>  		return 0;

This is black magic for me, I am not sure I fully understand all the
details, but what's the new purpose of lru_add_drain_all() ?

will we have a guarantee that no stray references to mapped folios will
ever remain?

Any unexpected reference (i.e. not due to mappings, see
expected_folio_refs()) will cause a protected guest to hang.

