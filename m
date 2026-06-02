Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77064CD6E64
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 06:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A6EA6B00A3; Tue,  2 Jun 2026 02:54:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 657346B00A4; Tue,  2 Jun 2026 02:54:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 546266B00A7; Tue,  2 Jun 2026 02:54:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 406336B00A3
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 02:54:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A09A191F64
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:54:35 +0000 (UTC)
X-FDA: 84834059310.02.AC991E1
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf02.hostedemail.com (Postfix) with ESMTP id 56FA180011
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:54:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UjGZRuJT;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf02.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780383273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=azyPBhysyV4g+I5FC5hYmzOA7/DTfOzRYV+TgiZsgAs=;
	b=gzG+0i7IPd5OirjOyhSfORV9ato5V4ddJdCAD4M07daSuB3YCtviCVXW2ySQHfUiOVc88N
	9/5Oub9QsjCFokE1O/3mBpaxBK54bB2NjycLnsxHyPGxNW2NcJ/nLTK9f8Df3sneM6ssNL
	GL/aeWz5thp5E/BylPTKEhidpzEcR7Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UjGZRuJT;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf02.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780383273;
	b=20EANNCeCql+FjAJxBXXj/IqFho7okMNOBVHPqNTvrCPp3hzP1Srl9MjcoNu4UEVCXx/9J
	DrLQXPNEXrcpE32MuZtN6gBMgHKKDbBToX4pe8H3eq5EMUIsXC5T204kgdv6kncFTodapC
	UfYqTFCdXepZEuRFPBgZej6dhdB13+4=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651GQdOW3295133;
	Tue, 2 Jun 2026 06:54:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=azyPBhysyV4g+I5FC5hYmzOA7/DTfO
	zRYV+TgiZsgAs=; b=UjGZRuJTIyh+wW4psq3TgQ7K7y5QfQMZH6OTp+BG4dkmDJ
	76D8oBdy0p9O/urR/8A9KXVobZY6plDHefG66EdBbNw2lgb/aW9Pq5aMU6+olXXc
	qCiTBqXOZ17cpiCJJAsQ5B478A8dAUv6rdl8XnF9gocPknGBG6v4Xv4b57ywGEWu
	Z5G3CctaAZl4sYGGe67ZlRj2UrYAwsGOzGj65i1zcefgiye4WyxPAZIziVhXg1/4
	uVZuE2TMNMoqdBXL5oLR67k5US+hOM9uMBoEizkH5v0USXiuoP38FznVc0N+pHH0
	3oee0PyrO8bgNU2cK4oyDgxIhEABK1vpJQG+uEHQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4efnahmech-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jun 2026 06:54:16 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6526s8P3013816;
	Tue, 2 Jun 2026 06:54:15 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ega7qa6jf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jun 2026 06:54:15 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6526sEVF56623600
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 2 Jun 2026 06:54:14 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 26BF120043;
	Tue,  2 Jun 2026 06:54:14 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B8CFE20040;
	Tue,  2 Jun 2026 06:54:09 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  2 Jun 2026 06:54:09 +0000 (GMT)
Date: Tue, 2 Jun 2026 12:24:07 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Daniel Gomez <da.gomez@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, djwong@kernel.org,
        john.g.garry@oracle.com, willy@infradead.org, ritesh.list@gmail.com,
        jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org,
        tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de,
        brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        pankaj.raghav@linux.dev, Daniel Gomez <da.gomez@samsung.com>
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap &
 xfs
Message-ID: <ah5-D51KPxM-lgHi@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d5d99db2-9d34-4caf-bcc8-c4a3af561901@kernel.org>
 <agQPtTx2EXHr10Nn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <ah24DlQobLjjDTGt@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <20260602054743.GA32657@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602054743.GA32657@lst.de>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDA1OSBTYWx0ZWRfX+71z47PaWB2B
 vNndWMdiWWmMj3ZIPpVWGD5p+2c/9zFyNcAKPRkFbRotwIDGDJLrRhZgh471UPw7eEuuMYnSJVe
 5xVWVUl9Xx8wcfxINn8nVtsHhozfCcAqmE6WUIGDkRappWMKnxnx3+csdzcXFWUEUiZX/7OtWRE
 V8K/VI6lQhn1/3spDBLGIiBUvKdqD0LNlX7z2deGGup80ykjxVRlco4ntQ0EPzKpZcsbqbrZ9dy
 yqDXcTDwiONwmM2/DPLurto/AAnqj3b5gN6Ue9BVGHTi4KVggFFe272HumkkQt6uBcxxxhzsH8N
 pjoC6WOw/goXFrqFsmgGAm8c8k81wQGB8xuIJLNLr1/p4U9S2GMePFWUnqgrxES+ucVQQEKrWEy
 FPp+kNVWHQxZWSD6L6YA9Ose2Et+djg0FYpaLoRUFCWgnChkYscsk0m2xmSIKDXDP0rRDPK5NlS
 p76bQLOoLhK0Wt1A2DA==
X-Proofpoint-ORIG-GUID: nibAEZvf3c6xmr4xgEIJIOcU81GPtqOV
X-Authority-Analysis: v=2.4 cv=cOzQdFeN c=1 sm=1 tr=0 ts=6a1e7e19 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=hhuWuiOL4SiSWFdKcnEA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 2Vk8eMUcoTVI1KE_6lVXeY-buYjiBWU2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 malwarescore=0 phishscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606020059
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: qcywyf1u5hjyn8uk7nnft1p1g3xcirha
X-Rspamd-Queue-Id: 56FA180011
X-HE-Tag: 1780383273-354171
X-HE-Meta: U2FsdGVkX1/baCEOsCipbdnYpu2+Gpvzy2GG/M8RCGOlqtrwTGZlL6zKAbqsAhQM1qTom5kHSriFFcFHVGgSbi6E5f2NNmYEUkC7K6iZIxIMA+6qn5ikh1gdElBOvuA20VL6hapfYS5SUPf54z7oSSqcnkhbAWkByCBlLh4o55mEyxLObRXbSf/9s1+og1hX0ExQijm0aMKKrWNeHM+YgjKSnbgBlOVURALjYS5/NahWukuKBxeJMFP/KGSVffrb3x5t+mJ0Xcm8yncg0elfIyy9dgwD6AlNCwY1Sh4sKC7jEoL9bG/EYy1IBHiONuDk+EUZoJnWiXOv2yfsJhWGR4lhGmkC+PJAfJ1GM8wL29FmphhnDyEALThLIUBy0tgeCHw20oFogG/6gfGBz8J/wmr8sIeYSQcf9hrhhwa8HmpzIMyq5zolgLRrwk1hXBdAnDsyYjXiafrgkCtEM0O1qXuye9BYOzwEzGaP9Wyjo4P4DqciVWxvwHooXUM18iiTmsxBRl3WMMym1o+zcbKdcLNEIuAESAS52aHz/QfCXl36Ac7yee91W+4Kre5QngsZ/hoMy5RsCV5ClyQfIADqMDeoOQTLBgRX7x9guyKYOU2CvrPcAnhFGm+reZ4t0dh5hNxIElabKP02DN2NNbL2KPISpaFHoTtSB0LcVugYkUqcOAtrIgXtEpuIlSSuSThghHdGKKqRkbsPfwMi1VqlXfehP5M3p1bd4aEkJAttFwe9dyBMPRWGKZxdNI22I5XDfKg6gZvTECTk1ri58X7OcLsjY7G3rbOiI07nxcdZP9htp8b5IoaRSxJu3xNVwttMYNdkI33Yz60SQQHn+XRPWCdpnARsUvczA2Sz0Pt47zVq+3ilR5cnnf1U8oKprmrZhagsjqM0Bxn7ZKKz1bNE+8irOLHvqsqg+Vjl9twecXv2DcEWEVIwrh+bpdWWbxnupVwaLwrFDgutht5n5C6
 PTgB0UOV
 Kanl6Nk+tb2gn2DhN8U6bOPUdI0fVhuTYZUyk/+Mi7A9QAUpit2e5TeSDCL3YTvjwNFzXAaP/eWbPBdeWXSNPbxYEe90B+AG9hgtFQ04jbevAbNBvgTNhJ17V/8w16l736qzMiribXtEXVwupnwWr8DxXk/bi/b3ori/5nuYgxlYzIGOh5AZ6ouy3ZfAGAYUZq90Tm2j/M2mMLdf5P5U829lbg8bF37kVUEhzRMpaBDOyiB6IIF9elGN4yDo1Pb5CYLfwdcXDxL/RSilORS9BudoIrnOOGmHH4WxDO84gCrSAo+EASu1xegkAHUzAvxR9uMLTo4tfjzTAd0cuZQKTnDojbhd+IO6G0ai5o4htHrVEPvYHMlCUBXjwLapuL6t1xUlTjSsbHFOJD/c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 07:47:43AM +0200, Christoph Hellwig wrote:
> On Mon, Jun 01, 2026 at 10:19:18PM +0530, Ojaswin Mujoo wrote:
> > 
> > So this week I spent some time looking into the failure of g/457. 
> > I was able to replicate it in my setup and after analysing it, this is
> > actually an issue in my xfstests patch. The issue is that to verify
> > RWF_WRITETHROUGH support I do a 4kb write on the fd during the test prep
> > phase. However "out-of-band" write makes the actual contents of the file
> > different from what fsx expected (It reads it in before the problematic
> > write), causing the test failure. 
> 
> Why does this get out of sync?  One of the arguments for RWF_WRITETHROUGH
> vs direct I/O was that it avoids the content getting out of sync.
> 

Hey Christoph, I think I was a bit vague in my explanation. So this
issue is not in the kernel but in fsx. Basically fsx does something
like:

1. Read in the file contents and store it in a local good_buffer
2. Detect support for various IO types (writethrough, dontcache etc)
  2.1 To detect writethrough support, I perform a 
	pwrite("4kb of 0s", file, flag=RWF_WRITETHROUGH) and look out for
	EOPNOTSUPP.
3. Start running the test
  3.1 Whenever we perform a write operation in fsx we use fsx write
	wrappers which also update the good_buffer before writing to file.
4. During fsync, we write the good_buffer to a golden output file and
   also set a dm_logwrite mark. Later, we replay the dm_logwrites mark
	 and then check if the file matches the golden o/p file.

The issue here is that fsx's golden output was not correct cause in step
2.1 I was using pwritev2() directly instead of using fsx wrappers to do
the write which was not updating the good_buffer. Hence, good_buffer
went out of sync from what was actually supposed to be in the file.
g/457 thought this was a corruption however it was a bug in my fsx
writethrough support patch.

Regards,
ojaswin

