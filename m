Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7754E9A031
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 18:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FF8E6B0088; Tue, 17 Feb 2026 13:36:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AD3F6B0089; Tue, 17 Feb 2026 13:36:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AF866B008A; Tue, 17 Feb 2026 13:36:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0492E6B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:36:35 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9851A8ADE8
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:36:34 +0000 (UTC)
X-FDA: 84454804308.06.7C36939
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf28.hostedemail.com (Postfix) with ESMTP id 57410C0007
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:36:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jivbenFJ;
	spf=pass (imf28.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771353392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yKajDEOKb2YbRCBKt7UgZWxuta6aP/Ox0M0jTvkoeMk=;
	b=3O4Nf4ig4VZSIjUIxiYO/M7YRlKxRJmuly2AIwhJBymEXHB1HNpZZpQpRri8gGvTDdH1bd
	NaZ5jBcTX/L+tYO+eKRnnBplDD0Ak0abfHfurXrbwa7Qtn0vmlGD3jRb1tbaEjhn5f47h5
	4xL4xU5k0hy63DLMpas3TCP6AYt/cZQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jivbenFJ;
	spf=pass (imf28.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771353392; a=rsa-sha256;
	cv=none;
	b=3oAhLJJ+cZEApiZq0CDovPlfcwOO9s3WJ8cJvCBi2IaApj1OvGEF1eZmIM8boecJL+t7T6
	x8V85RGEqVgFMJMKYlJDBNALKLWG7qM9MBpPpz6Oqcg3Wq96B3C4KXuTLumPa5T887bbt6
	5OzdCIHNevEIBiFIKjxkZ6aybAJVv50=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61HBfUgj1201555;
	Tue, 17 Feb 2026 18:36:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=yKajDEOKb2YbRCBKt7UgZWxuta6aP/
	Ox0M0jTvkoeMk=; b=jivbenFJB5+ir4PKC0a6OR/5c/D3rdoY6bxeXB/2Wnk8M+
	EfooQST/RbjvaTvqlcspoKrwffOVx091kRFdaJxOkWFNQ37WcjGlPLfLXvE553Q4
	l1/OSX6A9zVk8Bfc/SC7/vauxbSxMP6kfrJ5RM7l6GrjXcYpmq+276gOUuH1e4Nn
	jeizff8WGTjdVDMNPDb4ONX1iEv5BFhjylaRpmYx/g4Et0wKYxFJ/d6FozJBFWAW
	ja0u+TmQnFcrprogw0kPUVDQ6Y88qKuO0j/O8TrheGFvEzCqP45c+4U4jsPpOapQ
	gimlESwNqmSGA0nRC46SNBdDP/r09JyMzG1+vECQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cajcjcsbw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Feb 2026 18:36:23 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61HFnIOT024414;
	Tue, 17 Feb 2026 18:36:23 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ccb454642-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Feb 2026 18:36:22 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61HIaLaS53674384
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Feb 2026 18:36:21 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 574E620043;
	Tue, 17 Feb 2026 18:36:21 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E834A20040;
	Tue, 17 Feb 2026 18:36:16 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.222.71])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 17 Feb 2026 18:36:16 +0000 (GMT)
Date: Wed, 18 Feb 2026 00:06:14 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Pankaj Raghav <pankaj.raghav@linux.dev>
Cc: Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
        Andres Freund <andres@anarazel.de>, djwong@kernel.org,
        john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
        ritesh.list@gmail.com, Luis Chamberlain <mcgrof@kernel.org>,
        dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>,
        gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com,
        vi.shah@samsung.com
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <aZS1HreP3ZTbfJVJ@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <w3vwdaygcz3prsxwv43blo4co666mragpdwaxihbirt5stl4vr@agyz4mnaxghj>
 <c29d36eb-0706-4f3c-aaed-de7d9ef74bed@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c29d36eb-0706-4f3c-aaed-de7d9ef74bed@linux.dev>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: VqZQkfvPpD088y7s_ZIuXzDZ85l1fGd_
X-Authority-Analysis: v=2.4 cv=Md9hep/f c=1 sm=1 tr=0 ts=6994b528 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=pNaSbsGRAAAA:8
 a=_-3aNh2cLU6TeR9iss4A:9 a=CjuIK1q_8ugA:10 a=cz0TccRYsqG1oLvFGeGV:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE3MDE0OCBTYWx0ZWRfX54UuNLAijDPA
 frC4GZlaugcZmhlaUh7PoMQytLIux8dJsBoQQwJ8ABImLjIIR2tCOCZGs4amQEVk53E7y3ZWCJG
 SwpZ/CJfXQYlFI3kS8R6a4KrvXyaK6auyHKCkLZxjV5I/G7iYObcAXn23NINKL9PKSqXoj+Pn7B
 NlyRRr50wFri48nk+WZRGYnmSgCcmctsEM3nQH9o62CGlzoLlIWgWbcBOXRsdMPLBlX/+wUhakC
 7rtaQEZNnMbgaSeHcK14v6Vv3TNj20sr9FCT83RSS5thbB5grbecuSsqHwf0r3MqFw7Md0AVs9T
 3xT7JXTu2Rv7XX82VSWCTwp2hS9Ll1w8yA5g0ydf2Zp6QGWPqvHnNZDZKHWq5gdzXc9wdshWik4
 NfMb8fISeEVpnyFHv0NSeF3WD/vxY1RzDlreEpRkhlVzHPtZG8OHTClFlomRt6HBqZaDHABu2tW
 ANvTybK5GXxCSbABj0Q==
X-Proofpoint-GUID: EAXju9l5Vdzng-kr7mVrOXvFL9mVXBcs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_03,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 spamscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602170148
X-Stat-Signature: dr5r69fmubixr5pwhdx46fz8zgegb9oh
X-Rspam-User: 
X-Rspamd-Queue-Id: 57410C0007
X-Rspamd-Server: rspam01
X-HE-Tag: 1771353392-422676
X-HE-Meta: U2FsdGVkX195V4d3lirA3IQHtxsveMusFWfKCgYyJDnxidtKWwLgOuzKSGyDs8pCm18dxAXp2T2vEWazE6kOe+GMBSsf404vFfdPmyIxLVu/G16rRCcJL7/2s694lEQHWE0g7CVQOSrOA5YPI+V+NUOBOGxXiR0FlPTKBjDjHUG5CFiVFgXzM70pQfo/AkGqCCtYHLbhAgo/b2vjLm4lNwTMANDO9iWlBKZLaTmpGT91V7CHKjWiT/Osc2sOMPfblgVmMqY0lP/loqqCqAtu6NSUKcjiDpeMGg+CJlLYoBwsvG8ElmB+XRfmcm3I4bxAxv/Ruzsb1AFkv6IIGqyWuDLa2NmlSUJ8Hjd8bG0XaLaAr22oJtA54pIzmav+EspslPYHC5gaPMo9G1J23znCT6Mo4zl+ZFPHDJkcRKtbKHAQN/+feU3YlazmEpbP/4qZSudefpFzYqIlJLyuRrYKFY52XTBVPusGB0Dv2G5YfRj0T5yvrDxDzP+Vfpvz1/wUwfFtT7djlIMg4mqsKq7Fm/CAd18/sLRkbpxOn7y46Yu9q9cJPLBbNutW9IXt7IjmXAlYhmc24MlhESzWn7Cqwey/j+SjthXxNh000+0vayJmQIIJx+GwPuyPPPdn80Wc11eD/8m7whPGuXSJ4dDmsuBkUP8trrTrLfklK/Qo489AXs+yHJa9DBMm1lGW1pQ09G3EzIwlcWRoEGn8w8IPOS42BXIHyZtl4abPvYF+f8qK2pWEcnzGLQi7Gua2NbL38Tj9Y0ya6f+Fz0MxiNn9Vsm69oeMmzmtlkd+kzEW/HJUI/tv2si9bBzWQppnFVUNd/Dati2siTFgUZuC0ZZJt5c0EwDYJg8D8WLUv5rzg81XHiwvTyUyXm7zsn6cO0jKXQliggTtTqonTLbMsbzO+oziDHGcaTC/z7XU6S6RvLgLd/5QtgyEuA5pzVaUczh+JBw1rOR7LaAE2nCXhQL
 pdf6rSQ3
 xoaLltVrTerI4w1wKdpZMVWlt5JkS8nNNHq+62ajzM4tbMPfE5bdYiLT7sUjKId4EzXnh0rA6YEEZfK6Wk0ngTJDspwAL0pbXKZl414zvcxnimCo+vHEIFXbuLOC4EE1iffZa0F7Pr76qY26s1vzhBIS4qULen7Hecbui02lD+QC5KWhhCylbaWKQeoEfVUMqN5i4FPXiaqOk1Zp7kyaXKG45griSLfi17TiM6k5KIFt7BawjNuxZfXdpY8HmxYWZkmm14CtOU2YXaFeWOxVsNhUs9C7+zIv9ccGJIsHvK3eycyPUwkrzweOkqOe1f3jtgqjvcmWAH5DXEU9pDqwxEkx9fByTdMf6bxNNFun48fivce9CroHVgMPgTsFNlJzPbU6LeCV89gDjruBkArdlD0dvuHJ4IFP9wE0WXNYaJWpPEKmMVzGq8JCUfUZ7AsV5JhEFMGiXZD7cbDTUvddrnvBU2EWDy0pKbLb/vU7X4xTla2wl5lFjLmwDxRss5AvhygVCxRSfgsZH6BA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 02:18:10PM +0100, Pankaj Raghav wrote:
> 
> 
> On 2/16/2026 12:38 PM, Jan Kara wrote:
> > Hi!
> > 
> > On Fri 13-02-26 19:02:39, Ojaswin Mujoo wrote:
> > > Another thing that came up is to consider using write through semantics
> > > for buffered atomic writes, where we are able to transition page to
> > > writeback state immediately after the write and avoid any other users to
> > > modify the data till writeback completes. This might affect performance
> > > since we won't be able to batch similar atomic IOs but maybe
> > > applications like postgres would not mind this too much. If we go with
> > > this approach, we will be able to avoid worrying too much about other
> > > users changing atomic data underneath us.
> > > 
> > > An argument against this however is that it is user's responsibility to
> > > not do non atomic IO over an atomic range and this shall be considered a
> > > userspace usage error. This is similar to how there are ways users can
> > > tear a dio if they perform overlapping writes. [1].
> > 
> > Yes, I was wondering whether the write-through semantics would make sense
> > as well. Intuitively it should make things simpler because you could
> > practially reuse the atomic DIO write path. Only that you'd first copy
> > data into the page cache and issue dio write from those folios. No need for
> > special tracking of which folios actually belong together in atomic write,
> > no need for cluttering standard folio writeback path, in case atomic write
> > cannot happen (e.g. because you cannot allocate appropriately aligned
> > blocks) you get the error back rightaway, ...
> > 
> > Of course this all depends on whether such semantics would be actually
> > useful for users such as PostgreSQL.
> 
> One issue might be the performance, especially if the atomic max unit is in
> the smaller end such as 16k or 32k (which is fairly common). But it will
> avoid the overlapping writes issue and can easily leverage the direct IO
> path.
> 
> But one thing that postgres really cares about is the integrity of a
> database block. So if there is an IO that is a multiple of an atomic write
> unit (one atomic unit encapsulates the whole DB page), it is not a problem
> if tearing happens on the atomic boundaries. This fits very well with what
> NVMe calls Multiple Atomicity Mode (MAM) [1].
> 
> We don't have any semantics for MaM at the moment but that could increase
> the performance as we can do larger IOs but still get the atomic guarantees
> certain applications care about.

Interesting, I think very very early dio implementations did use
something of this sort where (awu_max = 4k) an atomic write of 16k would
result in 4 x 4k atomic writes. 

I don't remember why it was shot down though :D

Regards,
ojaswin

> 
> 
> [1] https://nvmexpress.org/wp-content/uploads/NVM-Express-NVM-Command-Set-Specification-Revision-1.1-2024.08.05-Ratified.pdf
> 

