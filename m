Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C3FCCE7A9A
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 09:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 781E18E0015; Fri, 14 Nov 2025 04:20:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 738788E0002; Fri, 14 Nov 2025 04:20:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 647208E0015; Fri, 14 Nov 2025 04:20:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4DECB8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 04:20:58 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D853013A6FB
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:20:57 +0000 (UTC)
X-FDA: 84108668154.06.3907DDF
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf01.hostedemail.com (Postfix) with ESMTP id D65C840006
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:20:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=O23AHUJz;
	spf=pass (imf01.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763112055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qeHXUYMFSy8eRy5hcdz09NbECVSzhUF3RPksa1OX55Y=;
	b=HM3bOlbz5GZ90f7lFm8o/+5WLOlsO/V8D0f2f1Biwkoh+ZUNbIzg7jVxd6uz1AtmHF1sp8
	8dXVY14TM1JkyDY1/EXIMs+9C/yl9mQi9iG9U8Y5Mrl0QPiDCiqekguUZQ+BSJJHNRWh1A
	czXnnkMvcgAbHPHzJWLsG6GPVcFgelk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=O23AHUJz;
	spf=pass (imf01.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763112055; a=rsa-sha256;
	cv=none;
	b=EJ0qdoTunSeA3Xn67a/YnO4grKEmdsOr9aV11vafct63GlrFR/OnlWAWncOpccmAxrX1qF
	aJG0VTWGU2OJw15nzdUnn0rZYTstn5Ieg5oEgZKY2IC/7ZIJ9EpxwI08OOPT8gsU6TX7UV
	rY9dbecr/Ht7UTzB/ATZxfUYqNujAKk=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADMlP0P000482;
	Fri, 14 Nov 2025 09:20:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=qeHXUYMFSy8eRy5hcdz09NbECVSzhU
	F3RPksa1OX55Y=; b=O23AHUJz7ranXNGFgaqbiPJtfqqV1CiruQIzwI/JynZgWW
	a579AwNYFprV3BVB3XZXRk2K7mQpx4Rj77oF/JDot6EjlcIqCW2AVD2zHXyZ1FMT
	yVHGyq+vCOUiF/TaBZ20Xism4LSu2geobF55yMydsG7EgsAMdc/1YycnUlfATfrB
	YR2tKE2Qgbfq/qWFPGDJCUab9xCXx4A1kJ03/vwsRnqnVuGYGRgehbyHXqmnEUXl
	gnwcWVijQ9oEgVcuqArSQlB8U6Hfe6rKUZ1xEsl6cj/EzfUm4w4ihsPrBepInGRD
	BSIaGCr6XMAzRyXxBhwNnBmiXzI9KzjaxkqcdTcA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4adrechv90-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Nov 2025 09:20:35 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AE9CBA8001006;
	Fri, 14 Nov 2025 09:20:35 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4adrechv8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Nov 2025 09:20:35 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AE8tXwm011441;
	Fri, 14 Nov 2025 09:20:34 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aajw1t53e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Nov 2025 09:20:33 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AE9KWVK58327466
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Nov 2025 09:20:32 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 100F620040;
	Fri, 14 Nov 2025 09:20:32 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F74420043;
	Fri, 14 Nov 2025 09:20:27 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.212.173])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 14 Nov 2025 09:20:27 +0000 (GMT)
Date: Fri, 14 Nov 2025 14:50:25 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>, djwong@kernel.org,
        john.g.garry@oracle.com, tytso@mit.edu, willy@infradead.org,
        dchinner@redhat.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz,
        nilay@linux.ibm.com, martin.petersen@oracle.com, rostedt@goodmis.org,
        axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] xfs: single block atomic writes for buffered IO
Message-ID: <aRb0WQJi4rQQ-Zmo@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1762945505.git.ojaswin@linux.ibm.com>
 <aRUCqA_UpRftbgce@dread.disaster.area>
 <20251113052337.GA28533@lst.de>
 <87frai8p46.ritesh.list@gmail.com>
 <aRWzq_LpoJHwfYli@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRWzq_LpoJHwfYli@dread.disaster.area>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rsuUkEddEYzblp7K82O2A1ALKBX7yvA8
X-Proofpoint-ORIG-GUID: Hwgk37d6V1PX3jo4iq9ZXuUVV9Bmk7Vr
X-Authority-Analysis: v=2.4 cv=RrzI7SmK c=1 sm=1 tr=0 ts=6916f463 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=07d9gI8wAAAA:8 a=7-415B0cAAAA:8 a=wh1SXWFTCzeTCxTICb8A:9 a=CjuIK1q_8ugA:10
 a=e2CUPOnPG4QKp8I52DXD:22 a=biEYGPWJfzWAr4FL6Ov7:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEzMDE3OSBTYWx0ZWRfX150420s1nCiX
 7qQ5hJedJunqCODNeKz66X70QQJ0LdWGXEnS/cA0XqkCNH2SP6XgX8Za4MDcxPoAWtbbtILRwcB
 tw/ZL5uast4uLcZwLLG/LC/BW7p0HDcasm4eXCM3ZODuI6iR+lslaRCML7uH/FD39jel9jU+9FL
 hxRGc0iBPZWU19T7ldVHN6v42CtZsIUo6FnMu9EBibki21TQwsg9b4Vq8WtHn1xtyJhuYevVf5n
 8N2BBPcReUx/ag+siORfb773p08hMhPx3PIMzKnbsWnTVLVvR78TAdhnbyzCV3z2QU/e/R4Vas+
 TRC30GJfiU9nnGT4eYsKgornUKStXENev/cBPIBjMh5EVNLqnIP2VrJhouYE8IhZoU05bs+iYN3
 NI9ZnxRP9FjDNvPYlI1m0afTz8CgOw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-14_02,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1011 malwarescore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511130179
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D65C840006
X-Stat-Signature: a6xxkqb71doxbg1qpitdr3e6w1yfxros
X-Rspam-User: 
X-HE-Tag: 1763112053-455311
X-HE-Meta: U2FsdGVkX192SLvhpmZCKHGsZ+Kta1oUbo7QY6ZpLFIgAD5bX2KaGREHTiW+rEX/fS35G8s03okduMhlpT16YPWA4UQCZPwM15ALvPjW9eD7WFX2IDaftp0vC+y1GobjS1SDOxAQqQig5cF8y9StzdGbeOoRH7gWYj+IVg1k0TG6GY0YsVuVJ20ROheWA42FC9dacg2FfrtpMBFq/yeqVW03YQOvZpto8AuRtIlSSGatpwc9dCRJkGJ2sB1w3U1vS5hRbSVgiAz8WvQktuFWN26zFpmCiHjO3NsdOPuMLEWZFhmEpMcz3N3uhpEPkO+ggWenzCs968YYGkUpPLJUqzDGHxS1Q27rmaTpzm4jOtLK8ckWekT+2SUp5EfpOySMVCjjeGoQtb4KwQmHbP+J7+ZTGoshc1a1bWqJAXI3YJP0LUKAnguun9zu9OeZZQiLscB4sTUTz06JorJYXTFDXOSPDyGNV02aO+v+XYVcCkn2j8S8Lkuoiy9HVXWo2ei5BhTW+e4vCn//Swdm0+Z75/QN6So7aFiPkWKRn4auzCtUIeiyKQdxTHPrTxJuVeW0P2XwzUC2ih9cBlKeq6lxGD4vu5V4gn9xMcEdmwLf05TAINPchV0a9WhSsyARzbRjx6DcXNPjMmkG0iHNRguIxRckp/NDQGDR3pnKK6EvwbO3KQGbi70iochhby3Q1fQAMdzKVVKeoEPhoHkk2ruVIo3p4cgDZtfJ/bsusmYooaYeVigrodXA4AxRPWIdTFOnPklXVqqUwf4j/nwuNu3NA4Dy43+VY2radhu3O7k8NYocsOxfF7+JXgip+0jlVWI153U4vZ0gMF4+S4OVrjTAG1L5VgFJR/Gp90qLHIehTk+KK/ZW9LqAtn2nPxeeOo/uFcj499S0yJFHNkOYPF+YwEMyJfqkwbOvZq+7Hr2ILOICbxlNPFrY42SLDFusKpmzV4yIEbK2FoK/qByPU3z
 Yv/kHA2V
 180AMYI0lEw01ia3EOBJ/u8+jPpZksTdbx+N+na8ooahj8oCKbHmoy+rra0UOaN0wjk7UvXje9OSuMetp/EKZCvbardxu78K8htT4Rvx/I47Ci5kYkVy5mkT21lUTUjdMv0kxCHBE1iZegpLLCddHAPkY54gYLhyMkrtPvm3LoLa3CE1dfh3cH5nwHylPSOtJJK7gCqpoRKoCOojiSN/CT8hPYhQsvl7vtn4CsG1V73GbbDjJh6HdpxjIgZO/neRuyvikDFKVTKcs8Xd2eyEXkU14WHBLZyleADb0lOKoLI5pfRndHq/5J8eTBIqwxBksQj7X1ByzjEvQmRDVE1nICHJsL+DNCGO6mc/2dWFGmNvxC6pInwhFOqBg0UiNME9PpEzlxMoU0in0lzQGZdyJk0UabVrA1QEJl1iJ6mkTHPi71wOVBryh2x/wkdrpvnya8uGDNELjbWpe4BuKKOhOBWH1fHs1Bl0720S0BCGWDaQ1h5IH8UkF7PsvC4qUFD2q5Bnq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 09:32:11PM +1100, Dave Chinner wrote:
> On Thu, Nov 13, 2025 at 11:12:49AM +0530, Ritesh Harjani wrote:
> > Christoph Hellwig <hch@lst.de> writes:
> > 
> > > On Thu, Nov 13, 2025 at 08:56:56AM +1100, Dave Chinner wrote:
> > >> On Wed, Nov 12, 2025 at 04:36:03PM +0530, Ojaswin Mujoo wrote:
> > >> > This patch adds support to perform single block RWF_ATOMIC writes for
> > >> > iomap xfs buffered IO. This builds upon the inital RFC shared by John
> > >> > Garry last year [1]. Most of the details are present in the respective 
> > >> > commit messages but I'd mention some of the design points below:
> > >> 
> > >> What is the use case for this functionality? i.e. what is the
> > >> reason for adding all this complexity?
> > >
> > > Seconded.  The atomic code has a lot of complexity, and further mixing
> > > it with buffered I/O makes this even worse.  We'd need a really important
> > > use case to even consider it.
> > 
> > I agree this should have been in the cover letter itself. 
> > 
> > I believe the reason for adding this functionality was also discussed at
> > LSFMM too...  
> > 
> > For e.g. https://lwn.net/Articles/974578/ goes in depth and talks about
> > Postgres folks looking for this, since PostgreSQL databases uses
> > buffered I/O for their database writes.
> 
> Pointing at a discussion about how "this application has some ideas
> on how it can maybe use it someday in the future" isn't a
> particularly good justification. This still sounds more like a
> research project than something a production system needs right now.

Hi Dave, Christoph,

There were some discussions around use cases for buffered atomic writes
in the previous LSFMM covered by LWN here [1]. AFAIK, there are 
databases that recommend/prefer buffered IO over direct IO. As mentioned
in the article, MongoDB being one that supports both but recommends
buffered IO. Further, many DBs support both direct IO and buffered IO
well and it may not be fair to force them to stick to direct IO to get
the benefits of atomic writes.

[1] https://lwn.net/Articles/1016015/
> 
> Why didn't you use the existing COW buffered write IO path to
> implement atomic semantics for buffered writes? The XFS
> functionality is already all there, and it doesn't require any
> changes to the page cache or iomap to support...

This patch set focuses on HW accelerated single block atomic writes with
buffered IO, to get some early reviews on the core design.

Just like we did for direct IO atomic writes, the software fallback with
COW and multi block support can be added eventually.

Regards,
ojaswin

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

