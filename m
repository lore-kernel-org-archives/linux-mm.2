Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47280CA5FD9
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 08:43:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 636676B008A; Fri,  2 Oct 2026 04:43:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E86E6B008C; Fri,  2 Oct 2026 04:43:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D7E66B0092; Fri,  2 Oct 2026 04:43:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 280006B008A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 04:43:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 423E71C3765
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:43:27 +0000 (UTC)
X-FDA: 85277047254.24.D260570
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf12.hostedemail.com (Postfix) with ESMTP id D90F940002
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:43:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jIKPSQIV;
	spf=pass (imf12.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790930605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u6z+3rdxCpmFRIgq+wc4twpDVt5mOnf1HDB51hXWov8=;
	b=J0S3p1nUA1UDGbVVxS3x7ubKtcy2OLLeE6JiI5tILXuE25rxDKIWQEEPpFK9YhBrgrfojU
	kxMI9oqj90ZIljgETbtaGgbwSWAG4M0UWlUhoG9yUdTxu9JKqi/Hl0zEheu8Vr7Vhymhxz
	SBI8RbVdY9KQbrCGbw7bwc3mmPYg4QM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jIKPSQIV;
	spf=pass (imf12.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790930605;
	b=d2Ygsx7uHBiFHQWWiCz0YmmMrE/+yb17AMj3GP2Ah2dJHOnyOoQD7uoxoAZnXClNs2IHco
	Yhv3PP8B6rLhOUb7OGNFHUql/PpM+sn8HF+yt3agDEeSeupygOIDTsAIZMKYkRRjlHCIOT
	SUJ6dFc0FbTh1AyFQ8PbYt5wkS3ASLs=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69265WwL2088968;
	Fri, 2 Oct 2026 08:43:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=u6z+3rdxCpmFRIgq+wc4twpDVt5mOn
	f1HDB51hXWov8=; b=jIKPSQIVk6KNxtc/6eeC3D+n0Q14wPmbj+GNIBIjOvfi/m
	N0KOPKmihSaUwxx/PbB3T2LNU6vBlzzdSY4T9IbnbvhwMTdCMz9tjdvshqwRSd35
	2Shfj53gu1d4QbtQElw2U60kvq+nbaLYr3DqBIcPrZA6qYmeJlEZGi6fWRaMOQKP
	Ici1Mp8mY+vP+rRG1m0Oj8G/gJyKFfIBWA9FyZSZUh9hMUEdl8bVloJ2Nl6gkDYT
	kLcuXDxUJvaMthHQW9w/2ztHJDDyH/45ZrdCTaWzKLyVcbPPKgCyuFrHa0REPINA
	N03lLyWXPshCMi2EZOeFoeKTfeEKMvBg8msWiZng==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5qrr8wn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 02 Oct 2026 08:43:22 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6925lVOq2118894;
	Fri, 2 Oct 2026 08:43:21 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h1aa7y2vk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Oct 2026 08:43:21 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6928hHf914483878
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 2 Oct 2026 08:43:17 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5E0BC20049;
	Fri,  2 Oct 2026 08:43:17 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EF8AB2004B;
	Fri,  2 Oct 2026 08:43:16 +0000 (GMT)
Received: from osiris (unknown [9.111.12.77])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  2 Oct 2026 08:43:16 +0000 (GMT)
Date: Fri, 2 Oct 2026 10:43:15 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com
Subject: Re: [PATCH v7 2/4] s390/mm: Batch PTE updates in lazy MMU mode
Message-ID: <20261002084315.21787Ba6-hca@linux.ibm.com>
References: <cover.1786956464.git.agordeev@linux.ibm.com>
 <d7fd78377a7278108ef501cf76571e80caef5968.1786956464.git.agordeev@linux.ibm.com>
 <20260824104048.11040Cdc-hca@linux.ibm.com>
 <b66a61a4-a532-44ba-a1c6-26f02193fb05-agordeev@linux.ibm.com>
 <20261001082143.23106A21-hca@linux.ibm.com>
 <15c64970-d54e-4b8f-96f6-50c021079a94-agordeev@linux.ibm.com>
 <20261001154117.23106Da3-hca@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001154117.23106Da3-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAyMDAzNCBTYWx0ZWRfX0vVeOY0kF+3J
 NWKGdzOYiO82EYkAsXFYkk1KKZ9fgTuztzoLR0D1fCkXagaE57ZJfrVl82GXSxSWHhkAnGfvrYk
 jRs9B6docluiyT5MyMmTRiOiVkOzmFgXTX3mPIOicUhRZD4CH0YrwBUv0K7nJ/+8guzVuZI81KC
 9s2a++VSgvIIjGDN0PafmqnYFMKQ7wo1M0oxmPxAO3u1YNiwvKPKuQd1v4lHNn2qk0NB8nmSQJG
 WIHY8z99AgONLNNor5Re4eo6VbC+nTzp9rmB945i1gSmUfhcOWrdcasSdYVsWaLLm04GrB3g7Mt
 7p5Lx24oblbO6rtOGP5UFPhhguNfaZ+gNj8BwSYj2wz1895fKzI6n0ZpkTkCIzTcLtGG/vpW8cD
 wozqXW3m4bb3nYRTs6VuuIgJ6mTR20Fmq9cZGLtjBVNKAB+Ua+YKwuhZB8XRhI2na2QwKGgWfOW
 Yq9gRH7z0HjX9r2Dptg==
X-Authority-Analysis: v=2.4 cv=SPbXx+vH c=1 sm=1 tr=0 ts=6abf6eaa cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=hn6UQabHmHydwZO8yBAA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: lRuAwIK6Fopk7AAW-iZWQgLxoTE_Ou_7
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAyMDAzNCBTYWx0ZWRfX1XOzeZ9O5c2w
 h2ipSBR1G04ILge6qI1WJeWrRr4u2RZgZ1MsyICf0vTnxp/5cLTv1ARVF11xH6ZAkyD9/M04YdC
 DL+VghzPillylu5i2Y4+FvzvNC5pqmw=
X-Proofpoint-GUID: SeAopY6G5RbSUVqw5rHMiPfVBHNLJEia
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-02_02,2026-10-01_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610020034
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D90F940002
X-Stat-Signature: p13gkzjrjkqjw7k877x7nr3jrnoxk8gh
X-Rspam-User: 
X-HE-Tag: 1790930604-921824
X-HE-Meta: U2FsdGVkX1+ahi4/veTq4Cbp1tW+g1CZPLtzHqqpWGFkArEfByNXUYJax2GC+dkzcoGctFqqd7MZaslMG89AnpP575rdacYY7X2jJYwX89anTy4QbO0iw+R/EBfFihJ4QSe/6QnKsHf5SDFFjydFoNygF8543b/RNSSqYvwEnRqEAx4Sr5Pgj2W4/F6RCM91XJHLjpTkWnq92EvbrfZF43/kjYbmk2LKQAaQknUjpwx822wIWXvWUeDFg/kVnOxZs8sOEyx4KaQdt56iR4C3DOWU3aI1Uo10sfjs+sqPCwXZ8+TXjs4rmch/avEPuPSuDB1xWPEfyKyzLJqpYAEkRmJeusdhrm2G8czVTrBJIAdjAHFmwgxm64k4R9RTFtd1hcqtzuAGJghAMAqMdAtK0qI9Imq3rUHBhopG+IVYRQE5BtBKjmRxVUi2VlPekUA1DnxN8Sc9V/I6EFGOAt4O/6if0zPP5in/4V3rmdHALEUNylmW5JBXQ3V6q7kXgqvRFStNbIxX5zZq62zFiyDLWDbERZ/e+M6tP1sQcD+zJYR9zeMkAkUPyMMoz0WyykGtjZ5OKfijaIaXwe2vR3FpjxgFFkpUNPEtZqSUKejPs9PHzQudWIRsp+abvE8u/nNtzTR6fySmb5HipDnFzC6JckRNtkn9WbFfAlEgJP5c+DJX0OFbwLMBvrg0CClbKKLe7oBnI04LXgs7PP8vt/HxQX1v6chiCUBuepFvQ8SOt6M+paPmr2h+iQY49qiinB8lwfLp/fImnf5XdZz7KARcLZ8CaO8AbYcCk+0/15AVzpD0N9D/rYtwpP6rovx4banTa8EpDjNdcXOPcA/Uhx1SmoSJUlgztGSXJwauvt1+CNzA8chvPQSNDLrcvaLsZKvWy68hD7WnhJxBY6O+3sBlCUOeqCsnsWvvxHBOzRon6fX/J1vgv7pZ3ivNLellbws2+QLUCsYuwdWVk4L5g0T
 8osWsxcz
 aagGmmqVDL23SYc/wxGBv3XPY9s2+BI0w1Y3rC3AWdrXHAtP8vE9XqP88mVKnp/AcQcLO2aW25B3hlr+2kRGnqdv+zGzSsPM0RhYAXoIoI3GmoeTUMAB0RIvfWN9VzAFll9OEB4T95PvQM7ZsXPumzrp5RZRH8YFnMhyTEfWuIRENR09VQjk7be7ehtqICcYklxy1+ipQrXNg5hCRmpYoiJl84Cf4+5HTd2vyQYHjQ2426DwQ/7dnqrNVF8w8gbuLaYwNYhGa9Ou7BPu36rPlfP9YWVh/ye6STBX0P3XjS9PsKFs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 05:41:18PM +0200, Heiko Carstens wrote:
> On Thu, Oct 01, 2026 at 11:20:17AM +0200, Alexander Gordeev wrote:
> > On Thu, Oct 01, 2026 at 10:21:43AM +0200, Heiko Carstens wrote:
> > > On Thu, Oct 01, 2026 at 10:00:55AM +0200, Alexander Gordeev wrote:
> > > > On Mon, Aug 24, 2026 at 12:40:48PM +0200, Heiko Carstens wrote:
> > > Not really. But why is lazy_mmu_count 32 bit? Do you expect a nesting
> > > level of 2^32? :) If you would reduce that to one byte you could use
> > > tmy or cliy.
> > 
> > Good point. But still, do you think it worth dropping the KASAN check?
> 
> KASAN check for lowcore? I don't think we care - this is initialized to zero
> anyway, so what could go wrong? Also given how frequently these operations are
> used, yes, please drop KASAN checks.

Of course you could still add an explicit KASAN/KCSAN check by adding an
instrument_read() call (see e.g. s390's fpu-insn.h, which has plenty of them).

But why do you think that would be helpful for a lowcore field, where it is
known that is initialized to zero? What am I missing?

