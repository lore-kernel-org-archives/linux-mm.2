Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81E10C61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 11:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 557D86B0096; Thu, 27 Aug 2026 07:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 508BC6B0098; Thu, 27 Aug 2026 07:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F75A6B0099; Thu, 27 Aug 2026 07:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E3426B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:40:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91069C03C3
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:40:11 +0000 (UTC)
X-FDA: 85146855822.28.7E3A6BC
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf17.hostedemail.com (Postfix) with ESMTP id 31C9540008
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:40:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=W7mcRDur;
	spf=pass (imf17.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787830809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hft1u0fMlCKnLKkYrKeD/za/SEhliPK6FjjWQWyvfYM=;
	b=7m+WpbabpiX2VrxBp6yHb2rzYh3XNH+u3MzYColgkZRH9lT/rFGDMkad8dQjsYBw6MXAag
	sOCA2AhXoAkCwJmvAk87f0u98QaNGuwVawlD4JTJY2soCLnArB1+NtwyoflO4saxFxCUt2
	Y8JS+QpKY2ZlV4zCGo7liR8DiqTv+1k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787830809;
	b=q/vdCZ5tcqAujM9a9LzQ1CAoG2K12lHTucZmGbJ1wJOiprskylbFNSGsYR93plcAEewIMV
	pUFGbVj7qy6k1lJrQRfANBatooYIYEYyH/pP+uob3Kvi1bAKLXdNVeIo11t3us0mEdG/KW
	Oa0KORqcLXTFyTbGXlKJPzlfBjbGdjA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=W7mcRDur;
	spf=pass (imf17.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67R9WGC0732911;
	Thu, 27 Aug 2026 11:40:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=hft1u0fMlCKnLKkYrKeD/za/SEhliP
	K6FjjWQWyvfYM=; b=W7mcRDurVpXKXB55mZGGe9La6bZgDc9lYciMeMiu2rbJXm
	KPA+TA4sg4WXgIFJ71KTTpEWnQ1vkTBvu7DxAGc/NxJWwl3UHVyevDeJsiqrlxV7
	2EamppUEs5WVo67b7Re2cKaD++JZxLOjnh7QhqmymLWUvFzu7rbuYbNmu4m/dQ1c
	im/2FBF1UciQ/pd54cUcX1/lkCsEfAZ7YM5rMO6mkvf9XM3HEezrv2JOAICbeBZ8
	YmOfA9PvilyNzksC06Xe294rBuYHY8yA75nmNVp6XJRl/HJsb+/jsi5DCvVIwn3R
	ZZAhRMtm914O0AhSqn+k+Dp62TyD1rub3a9H+fdQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g73er4yt7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 11:40:06 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67RBQIuc017201;
	Thu, 27 Aug 2026 11:40:05 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g7p3qg0yv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 11:40:05 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67RBe1jT53739786
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Aug 2026 11:40:01 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6D24620040;
	Thu, 27 Aug 2026 11:40:01 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ED8FB2004E;
	Thu, 27 Aug 2026 11:40:00 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.111.20.232])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 27 Aug 2026 11:40:00 +0000 (GMT)
Date: Thu, 27 Aug 2026 13:39:59 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com
Subject: Re: [PATCH v7 2/4] s390/mm: Batch PTE updates in lazy MMU mode
Message-ID: <b0d59b27-8d15-499a-aced-e5b247ed40c1-agordeev@linux.ibm.com>
References: <cover.1786956464.git.agordeev@linux.ibm.com>
 <d7fd78377a7278108ef501cf76571e80caef5968.1786956464.git.agordeev@linux.ibm.com>
 <20260824104048.11040Cdc-hca@linux.ibm.com>
 <73a0a916-b39f-4ebe-bffe-448928b13bef-agordeev@linux.ibm.com>
 <20260826130257.21444B1a-hca@linux.ibm.com>
 <87a3147f-e993-4629-b0dd-a54aefbf20b1-agordeev@linux.ibm.com>
 <20260827081156.3869103Abc-hca@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827081156.3869103Abc-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: g852VGYQV57aImlgpSXSr7lgSbZAjYga
X-Proofpoint-ORIG-GUID: PCitcdLPSed0qO_DEQY_0xyJ0WeyIiyY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDA5NiBTYWx0ZWRfX4RPE8U9cgIV/
 uZuXvUy2N/OSt5fdeft120XXFoPOeSxq5mpMTDWgjf0B8YgADiHIcbjHZ4d3enc+6hgg2ZdaA22
 /oxqlpOQDunoOSzqq1pwfpw/wYgCvgnG30Y8fyVZ0hHqtzqMQ3AKtMZwInH5/PieUY5qeZxeZUi
 GjTBjWqHhjVpB+ljhHKEUPQtGqbVJd1Wv8jw8DhkbvsAgOwlo0u6HHGKoNqrpqwxZD9cPA99mrH
 GcldPPcYeKBJMvQVs15E0ibrP9zQUIep9K6BcwPD/YCFfpoGQDL7vS1q0+T++Cbi/+4EFZwky9y
 6JOc7E2ISFoErUjxCYV4F0dNlMVcd24A8TEEry9Hw73Q66ANksoAKbvtGQGDvAMlWXQnX9Sa2Wl
 pLEcUaFZkxAWsGDH8cKyUFEY87SB+fzA9qsupKVgNKEuExEhjzdDRcaN48i/3SGLMS+o2tmatmg
 QlQFIb0RGCnJ1ONr38w==
X-Authority-Analysis: v=2.4 cv=QsRuG1yd c=1 sm=1 tr=0 ts=6a902216 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=uroAWBtYYZKLiyjPLxIA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDA5NiBTYWx0ZWRfX1bqF5R//rcDX
 7ajB85l0g5erJqSt1ReSbQbS39Zs89KlZJ/9gb+NpHGL7zgLBfqHpWSzJpaXn9HXvBWElJEBFuX
 DgVmsGff+ZojOtGlo8JcEbBsJvhNQ5s=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_04,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270096
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 31C9540008
X-Stat-Signature: cshcwrw8z6tgq9rae6gdhz7ny1gwgjbw
X-HE-Tag: 1787830808-653001
X-HE-Meta: U2FsdGVkX1+0JNAornIkqiSD8M1WEotGNdT13BOqQQwZsbN8uHA9xDhA3amXDwZ/vovsnlA2A4i2hMLAvRh0bBsWgKzQKPUktylz+DhDOwcufgX39+qdWeQlkx7Imi3r31sD0Lnd2Xplfd0KdTQ6UOQBoXXUNmhoEhryS4vwN1+XNXL5NIQuwoUhtdi+OleG1KQa68GOytoD45ZmY5KnsBFU09GMrOuPWhhD2JWOBrPHhe4m+wlgBeI8MIROavZxhkmQtrtgwV1dnD0brsj8uP+IvVjZUYlOq/yh7hIQY5s+6pq5Me/x3y8dzeSCzWKuAysRv+Bcw6FpqPnDL240RY3b6DmvK467+hM/Ey3ue1ratdmvZl8w1jTDIO6hop6SQne9K8wk3dhqvkbgpcvE5o48VNV9Q6Ywn8jDnpS0rk/nmcgo0P76OKijEMTwHpA9XvuE2woDGF8mwYQewaEoF90+HVCcDmzw/2eonpeFcmItUhvEsPMO0KU9lFtGJ0Wd/98BBSXa2aS9ehue9Gb7ldX4GxLrjPjTtHDCNO3mCb4dm4FQexGtwQDZFgH+/eL2EZ4nIspP9wrXwGfl1NAmLqMVNnBBqCX1xbczUSzcvbdLGFyIs420ACGIUmTKZl/Ewk7EYHJnUhWFDpAvghsEbAdgeyHSDEO6HOist7WdtwapaDKYnxYGB1dp8/r1Nfvz4Yyo+eTWKL4QVTw1X/UHjozFrVjhgQtTsQV4yl+63NJxqHisbyTEg2pHZWVQ/56NsHiJ0J4ppr/VA/NDU+2j8Ta9BgIY1x288V8mwWQzO6wiWpuE+QGm7wTw2HRgRfOVuSb5RONkUcHfRqPmYClQ93wvATaJlzZWDoxfuegS3HXGqs3M45DHrKKePgB0+pKj8IUg3rRhLHaj3NYWggJ53/JOReNjr64nxKwm/ED2pXPhFgjn+7ssUfA6E1LKbkovtbzzHvleVXLwVSKQe6V
 5YpxgVOF
 M2CfgwSIBxdShVYqwITwyYOljZSqlLJqxocFJlzDff7XaIpyoxuCvqmkL2r0s+BikuN9jomhfO6IicLV7RrAViF1AGFMvKD9Uz4Z0MDAIGFtDNWEyl47934rqzbluy6nW5ViuyaSW1D32G2ljpF2DmTkSzhJLbdk5fy+RTv4Im+GsA+BeIrOJLZZGtAnTnL15GCh+0UTAw2H0Ff5fM/V1+4IpIBPtCX0u3zrhs+9Bysaff+h0+5k4IFgTztRgl0Ojh+pAC3eryP9LEJlKQ9F9K2MQmuW/EZjrrBQYH/U1R7MKuj5nlujXkRrQZlGmr9t2nU6NcJtPtkqJs53Pd1X4KoQommGR2aIP/QIF46V/Z0PG12FIcCvtW7obw3qwuhzV2neA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 10:11:56AM +0200, Heiko Carstens wrote:
> On Wed, Aug 26, 2026 at 04:34:25PM +0200, Alexander Gordeev wrote:
> > On Wed, Aug 26, 2026 at 03:02:57PM +0200, Heiko Carstens wrote:
> > > Would be nice if we could avoid the not so obvious local_bh_disable()
> > > and local_bh_enable() pairs.
> > 
> > Calling ptep_get() from BH context was certainly unexpected, but the way
> > local_bh_enable|disable() pairs are used is actually straightforward.
> > This is a slow path anyway, so I would think the simplicity prevails in
> > this case.
> > 
> > But again, I will try to avoid that.
> 
> I do agree that ptep_get() being called from BH context is not what I
> would have expected too. But then again, nothing prevents people from
> doing that from irq context too, no matter if that is sane or not.

I am currently looking if any interrupt handler does such a crazy thing.
If not, I hope it would be possible to nail this requirement with the
maintainers and e.g. add VM_BUG_ON(in_hardirq()) to ptep_get()/set_pte()
implementations.

But even with BHs we have an interesting situation: calling ptep_get()
from a BH while in the lazy MMU mode is actually a read hazard. IOW what
I hit looks to me as a bug in generic code, and one that looks very
difficult to fix. So staying with local_bh_enable|disable() would be
still a good tradeoff.

> Imho the "final" version should either be implemented that it can go
> without disabling bottom halves, or, if that is not worth the effort,
> even disable interrupts, just to avoid other surprises.

Yes, that would be the last resort.

> Plus a comment why it is needed, please.

Sure.

