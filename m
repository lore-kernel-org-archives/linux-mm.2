Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 299E7CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:57:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CE7C8E000D; Wed, 10 Sep 2025 04:57:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A5E48E0003; Wed, 10 Sep 2025 04:57:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 594FD8E000D; Wed, 10 Sep 2025 04:57:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 489728E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:57:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4169C0803
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:57:23 +0000 (UTC)
X-FDA: 83872736766.26.8696F79
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf14.hostedemail.com (Postfix) with ESMTP id 453DB100002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:57:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GgvWlbTH;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757494641; a=rsa-sha256;
	cv=none;
	b=zyfACxBM2C/FSgkAOHaQWEl+gqNAvZ8Gc54DTzmJQoHbuD1BVljWnOY+XIpUalhyOcqEnc
	Qa66ZOef3ynYThU9F1t/Wh7ytQB3SlNCi8Uhx7hpsXu6CBW1dvuLNg3nJ4UaZal3dTB3p3
	PkOaW+z8V53an4AbAFmkRTGfei0IaM4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GgvWlbTH;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757494641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ECIEW0PGugRg9d1uFzxZma7AlkWVruV3XIpKDi5wbKI=;
	b=PzAowSArig2J0s1uC8GiSSOUykKKv1LGG6gfjS+W205r/PvaVK6f/IgU/71ccFQeR2SaTm
	8tLIyF2soQldfXx7Y0PTYcTR29OQ/hPdGT4wzDEe+AxhRI+lt0rdczzgeWZm0gNgu3Brv/
	qOKezt3oTWZ/KN5aKJ3KoqFSTMPL8RE=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58A7fFJm010489;
	Wed, 10 Sep 2025 08:57:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ECIEW0
	PGugRg9d1uFzxZma7AlkWVruV3XIpKDi5wbKI=; b=GgvWlbTHQyQCC8P6Ohpq2O
	S3OW2SDO6MaEYqLta7SEoLxvbqlpsCazMmN2BQjAhYkCb4BAB+TbaG2yJEfRoEte
	dKbd0T7+v7TlsJjOKLRQ3CdqqetzWTQkAJOLmu4Sz3WByC59354Gw9sC9QdPhxub
	FVcjChd3VZDj6Q+SQzJl3cnc7f+cfR/ZuQT5pNZfqyDWfAYhogkwqHJLtEkj2u1T
	EqHVMCDcNO85DudY7OzGFG6FsamMm/l67KJ/bS9V1mOKP7l91aETXfaGNgfgpD9I
	XTTe3xjk5JLa8NMyrlbWSxq5lfYBWjyMbt2mvl6752clEnoRRI+L/IwOzHoTCIbQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cffd0hj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 08:57:19 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58A70fSo017187;
	Wed, 10 Sep 2025 08:57:18 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4911gmfcrv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 08:57:18 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58A8vHPC32637644
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 08:57:17 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 230A32004B;
	Wed, 10 Sep 2025 08:57:17 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E5EFD20049;
	Wed, 10 Sep 2025 08:57:16 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 10 Sep 2025 08:57:16 +0000 (GMT)
Date: Wed, 10 Sep 2025 10:57:15 +0200
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
Message-ID: <20250910105715.7f4f8495@p-imbrenda>
In-Reply-To: <1228a0a7-660e-4993-887d-66bc2c37b8f4@redhat.com>
References: <20250908094517.303409-1-david@redhat.com>
	<20250909180757.1114d727@p-imbrenda>
	<1228a0a7-660e-4993-887d-66bc2c37b8f4@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QRrBKBaZ89nXHwCvmJ9dEt-qtRQn2gBd
X-Proofpoint-GUID: QRrBKBaZ89nXHwCvmJ9dEt-qtRQn2gBd
X-Authority-Analysis: v=2.4 cv=EYDIQOmC c=1 sm=1 tr=0 ts=68c13d6f cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=20KFwNOVAAAA:8 a=nCIUJmz4GBJYDfQ3j3gA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyMCBTYWx0ZWRfX9b9+jsRX4zrI
 BlQMWMK5YlVzA97p2eodgwolIMp/eLO+pHH+HHJZS2VYUKORt2Ibt2r5yYE22ESNd9VYYFb7FVu
 M6NGrV9M1/QFyyLXD0NWhT5pjOBZ23FjYyPdm38n3dRL3kBXTVAudv64vdHWj3oRnksHzKOMo8S
 uz9H8dzH++wQVXvMZIhZjPfwdlaPS5pVFqKHpvj2xRQXwPiQEHcIjkBWU7fROQ9CxtAP386FQwW
 uzXDD8uCqL+PkiySP9tURCz/+cskJ8HKyPmB1bIPsYgnIgZCD6l+OLi2F/5IiFAz2oSafHbgTpI
 PEpIZLQcom1SQlttAtnQBIEEpErwvTxrpBTHSxmJxqsH52PwXW6XUhsP1qcj9xKWUGlF47VqWuJ
 eq6TWflf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060020
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 453DB100002
X-Stat-Signature: wybfaguoymyep8mymooahscqapbu8bgo
X-Rspam-User: 
X-HE-Tag: 1757494641-650617
X-HE-Meta: U2FsdGVkX19i0+Nwu8DQ44h7Bzv0I2NHJqkWt6B6PeAqwkVNNmLyLdFQwFXyMxEW0f59Wo9CIRxeScDG17CKa4DFbL8xuQ3qFP3JkW2QKPymlNIg3Yf8P5LuefNy5s0z9rYYRM4iDJ2NsDanLEmypA5qrpzYkEkBTwJ3UASNCYu40JmUtiacbl2vxnukwCrzXMl/oK7A4Emevf7b0cIPbnn2IoFOrqJlcvOwUtFGMGoPLuNYkrfS6YH3NCZxCjQ/rlAqO+w78X+M84w5jJ+pBNjaVR80leZhact1gMRi0dRQUuV5AYzKDrkWjInh6TaiEYvwAIwqRMJ4j1vXcFFLUjHs4CbLMS39QZPu0IC1jCwYKYUCsoBAUWb68QB2ysUnIt4GBu3rZmEi9Km23R7QK58XJUY+x7oL1v6CxVIvRASnNy+abQf+LE/QwVCDQYWvZc01comsO9RvcB2LiyWCU3gK7P2jxxLDiK6Nt1JJknUwRZm+66k5DaP1H1ULwukhYCgCMi0qutDUjERM9lDVR2IXBuGe9HTbxHwKWrceeL5Y94tXtZijcKwzqQhf7cDxWsQjWrQCftE4YP1awieQ5T9ZANK0xn5uSfCVfht2zntFFV/c3Wo9u4pgzhmtrdF0BmZISooEmg0zKceDeuumH2H5OnhMyORuWpT3Urh5qPP+ZcJ/GT7e8F9tonYueUk6kNP654MW1qJDbOV388hxRLrLMijmV19LvQvrb6Hnzx3r7YrYL4SD9V6VXSjNhN+/meRF0xmIibXnwALQ8BEPPUbbLCS6ePZzSKaqksQ67eJ9V54Kq9PDfcQbrzTIutQfLjXF3ZPWXkkFKC8YP9YfGzw5iNABl/S+tzlTskmazBTpSMD1QlvSRmaM07rPbMYgOQXD3hSDAqzfCNCtb4y71+FoCBbX5MJ58aVDWItRioUPD5UbYAh6CQorSUld+a20BS+jLNp7JDH+bp5+MVU
 nvaWyW4v
 uOTle+cwfp+BbOH4BZlJ5Gkjgpd8Is9+KMaL6hgD0T5ZqrS56IUJLb43g7YVrgZIRDp6m3rWvksEk+iqTK4BuuY03DsozQwUhpwtaTnWkn5zm/gBKl6Dnz8GhtMSohDLRKx8MajS+/Kr67ruac3uCrN4S6FOGjb1sdYZ+/uLTKh8FeRXnO+EPB07vOC95erDhslZUm562sRwOse4NxlZ0dWK0UKqxv1cYrvFvc08HFWqHlQ8qqBsfiGWx0RcG6Igo7Nbvl5xXTan/kX23s8i9tQgaIBQA6W3B/1Z8jDQicQxITvh1X/rdP0Q6usSLRpivM7PXBylwJlxhxxTFhWbbEF3u5gCei8EFkhd/ykuqg0ha8C3ACUwB52JdvgAPTT3834XAbmXfGI0G8aS6UoGANGQkdO/eS/GZOQLf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 9 Sep 2025 18:15:17 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 09.09.25 18:07, Claudio Imbrenda wrote:
> > On Mon,  8 Sep 2025 11:45:17 +0200
> > David Hildenbrand <david@redhat.com> wrote:
> >   
> >> In case we call arch_make_folio_accessible() and it fails, we would
> >> incorrectly return a value that is "!= 0" to the caller, indicating that
> >> we pinned all requested pages and that the caller can keep going.
> >>
> >> follow_page_pte() is not supposed to return error values, but instead
> >> "0" on failure and "1" on success -- we'll clean that up separately.
> >>
> >> In case we return "!= 0", the caller will just keep going pinning
> >> more pages. If we happen to pin a page afterwards, we're in trouble,
> >> because we essentially skipped some pages in the requested range.
> >>
> >> Staring at the arch_make_folio_accessible() implementation on s390x, I
> >> assume it should actually never really fail unless something unexpected
> >> happens (BUG?). So let's not CC stable and just fix common code to do
> >> the right thing.
> >>
> >> Clean up the code a bit now that there is no reason to store the
> >> return value of arch_make_folio_accessible().
> >>
> >> Fixes: f28d43636d6f ("mm/gup/writeback: add callbacks for inaccessible pages")  
> > 
> > Ooops!
> > 
> > thanks for finding and fixing this  
> 
> Thanks! Is my assumption correct that this is not stable material?
> 

your assessment looks correct, an error return value can only be caused
by a bug

