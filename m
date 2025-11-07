Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0441ACCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 10:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46C468E0006; Fri,  7 Nov 2025 05:49:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41D2A8E0002; Fri,  7 Nov 2025 05:49:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E4118E0006; Fri,  7 Nov 2025 05:49:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1AA9E8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 05:49:40 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ADC7D4B736
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:49:39 +0000 (UTC)
X-FDA: 84083490078.09.3A61092
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3A481180010
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:49:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="eUoI/gb2";
	spf=pass (imf24.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762512577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dQNXGowmegNUGhw1zwL0CSsOd5LGDJmvsS5xKvlrqhY=;
	b=bvbzvTnCFQHJvh0E0ytsqXs9kfVPKxfUH45L2jIgKqWVWNgPqPjkVCkZ4Wa8hZ4S80x8Rt
	vtVSVdDJbqVMKUIi9Hr0TPYF2fgw66f7/u9X/JYOCRFOeHLcX7HrMCKkg9xZVuvzNchecE
	2zyxjAw7e/mZvNIb24UM5rOheI0ssWs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762512577; a=rsa-sha256;
	cv=none;
	b=OdV5TnkNckc4YHW1jTVFqSxW/gBmhdNycyPZDXi1aFE2CVqqSF+cP64i3CV5odn2rX69oJ
	dAPA+Agv7GgOepg6zLuY8udeHtIaMbvuAVQga26qhPSAhwMniDZFFb6oACGHbUsrCve6Oo
	pzQ95DvkE/WJCH7qUCcO9kUJGKZBWXc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="eUoI/gb2";
	spf=pass (imf24.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A78Rkns010216;
	Fri, 7 Nov 2025 10:49:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=dQNXGo
	wmegNUGhw1zwL0CSsOd5LGDJmvsS5xKvlrqhY=; b=eUoI/gb249trjwUmD8YncD
	A09chPYIHeRr304dMbgyMEjTnRYZaFug3SiFK97nkDCFReUTI1AAS66+J/CFGP50
	giQaIXqsdcDeXIHvMbQAmRoItH08FViKxd3M5YDpIjS63abtii0RNW9H2hMOsTSu
	VwGetTNoWKcxZ7wTu0X/5SjMfEkp9LoBoSy9F8VtU9XboLHtz08tLeCXXVcgLucS
	oOe46VI0K6nFAY6Tj+Bb6dMcatj7sfuvNAbYrdD76C+v4SUE7BKdRx8AYPdVSOce
	b3gZ1QdHrQAaxY6stqUsT9AAwA8DgTJCSTKVvO7gaCZxeEU0VqBo4lz9LOb+/5kg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59vuv80v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Nov 2025 10:49:34 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5A7AlRSb011750;
	Fri, 7 Nov 2025 10:49:34 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59vuv80s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Nov 2025 10:49:34 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A77889A018667;
	Fri, 7 Nov 2025 10:49:33 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a5whnt6tc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Nov 2025 10:49:33 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A7AnScR9961806
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 7 Nov 2025 10:49:28 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D5BA2004B;
	Fri,  7 Nov 2025 10:49:28 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A35AD20040;
	Fri,  7 Nov 2025 10:49:27 +0000 (GMT)
Received: from osiris (unknown [9.111.32.237])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  7 Nov 2025 10:49:27 +0000 (GMT)
Date: Fri, 7 Nov 2025 11:49:26 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Alexander Potapenko <glider@google.com>
Cc: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>,
        Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, kasan-dev@googlegroups.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Juergen Christ <jchrist@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: Re: [PATCH 2/2] s390/fpu: Fix kmsan in fpu_vstl function
Message-ID: <20251107104926.17578C07-hca@linux.ibm.com>
References: <20251106160845.1334274-2-aleksei.nikiforov@linux.ibm.com>
 <20251106160845.1334274-6-aleksei.nikiforov@linux.ibm.com>
 <CAG_fn=WufanV2DAVusDvGviWqc6woNja-H6WAL5LNgAzeo_uKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG_fn=WufanV2DAVusDvGviWqc6woNja-H6WAL5LNgAzeo_uKg@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xHt6csdp5zIfKXLlO9Ptb7N1pvutAy5R
X-Proofpoint-GUID: N2mW_1T8BvlehvL96DCCIfaE4a4UDLER
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAyMSBTYWx0ZWRfX2h2be+m4QKUF
 TMK0Rma4nsce0Rxtn3dZvd5VoQb1zdv5Ed2lwon8EFuSo6iCgmxqT9V0zVDfs9Ib/AROjhjNIEC
 7jJhaKBUToU8DAXSIJ0eb/VILLPl5GWE6jhg/2AWY43qAk2XGIbQzhYcxtrc3kDhcu6lWwx4rkI
 KN5PnPZT3lHKBhMCapRRHoKFX6NryZhWdFgLcJ0ot0eM4JGBvkBpx3pqhuc3317jTIUGunpSXm1
 VQ1XkTqk3Nc6yInG/WfNEkP4CgmU2tbpTSaoUc0m/1YdeDvm29gKi49Zz9TlJfewCb2MEs/ZXQy
 jIZYbgTCtnS2ZtlxlrpKcDqmE6mslnv20EjnFyGbNlo9COA1beVHSzpYA+Df4qKw0wVt8TNs0ig
 +QgcoX50Idh1L15KjpnY7Ws/7aATGQ==
X-Authority-Analysis: v=2.4 cv=U6qfzOru c=1 sm=1 tr=0 ts=690dcebe cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=pNHI5jXrFARJaYZssDMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-07_02,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0 phishscore=0
 clxscore=1011 malwarescore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511010021
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3A481180010
X-Stat-Signature: e466qi91r99eyptp8deurqb44qa6xczt
X-Rspam-User: 
X-HE-Tag: 1762512576-127208
X-HE-Meta: U2FsdGVkX1+4qjERf5gIvtihWojsY9jZh8nPD4Ab/evaqxZ/NX6e1oZn9SlPkHAzwSD6jTy4TPag0It0LNC4Bj/iavp1sTK4KSU0TEFo0Akg9cKJF+DuDXuDe2ENfsoIRMjiv1X2lPQu/Ly5FOHZUDxSpnFs7cPGWFervoE3v8DPuRtB6oCmbzZADYnCcLqRUEu7cGl4sdw1NufM+Am0wvllmMLADvJBE7fNuF6jvMf0w3oapNLgP7vsGK7Uk6f9YYVzV0+NSFxVATHlr0haSc3uMXk7p4Yxf4wNtlieUsa7+kSLDPHmaGbPr3Ev5pLGY1Pappk3M3nLd4FdjAEd1Qt6drOA2YpNVnBRNfkCCH3xCCqUJf/OqW4ceDwTG8mKmgxmwKvCPOuxZHR66rYi6zFOmtL2euX/HfpzCw/sgfJbwgnc5NefSE0MlzuVGPbELQ5NtKEzPaUmz552uUqxIH0C7DKETwiV3FHAu+VAHeXxfKTH4K/q0+r+Ycm3HVh/y4qdE0tinWdWrxOQk4r+ig1zkqMHaUhwCgs/44ZOdsqwjd4HbP63tIDaGsDYMG1/hkJEgsY1Om4DzGR4gAQDh/GPqI7x4nUlby5WIVC4VbDRwhcXVY50gGDdF+zRxiuTKeeV1rtsrqrxn/IrNxioY8ViMVHuZw/gjWcRCKkoZMOdfy0QYDgzKVaMdgdaA/l89C50k7XCh/EiEEbCE4JVDzxSIiURMMEXw/f+NQfCpxIqdbU1irmBt3uk0yuAOSf3RTcmS0zsvbSJUFExuq4CLd5HzAL0tA6skdvvh09Wn7CP81Z2z71nj/s4aHZuKqFWMiWj0TQ9qyD31mZSSZn8ZiSk0tU3RFPlKb7y0GdFIEBC2aTivGenaIxMdOYOMZwG8zl6myS3rBWt/CV+1Z5OxvMrSCN2JPKfGsVPrS597A+wNPpccnkM+eCefIBdf2JnT/qQBBLkMdwpZiKBAOy
 ibB+8//e
 I5XiPYVi3BtGjC9RimtaaqSTtWkagu47EEkzOCRCJR6rlWnTPqO5dIL5RfEUB9/KyXmza9dL99wz2HIX2sMTLTYeRYyOBEJ7IFpX24FGGxx820u3wrSGBr4SP4vVkQHiplsw5EWyPsH7fBImf53shynZMMxV/VyBKeat9cMkNT7RgYlPUwbH2mJzhI1fwZlw3JwAuOjvptHzSJ6U+jRlUM0LWPrzQM1qZzmQJKFKUeJwXIkNPZmajpuOVaX9Zno7erLXSyvTBfpTCKn5WWcK5tvF+Mg1AKf4YbC9tnJ2SehC0OFB2/ULlZrE+/nZPHxrw/H3g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 11:26:50AM +0100, Alexander Potapenko wrote:
> On Thu, Nov 6, 2025 at 5:09 PM Aleksei Nikiforov
> <aleksei.nikiforov@linux.ibm.com> wrote:
> > @@ -409,6 +410,7 @@ static __always_inline void fpu_vstl(u8 v1, u32 index, const void *vxr)
> >                 : [vxr] "=R" (*(u8 *)vxr)
> >                 : [index] "d" (index), [v1] "I" (v1)
> >                 : "memory", "1");
> > +       instrument_write_after(vxr, size);
> >  }
> 
> Wouldn't it be easier to just call kmsan_unpoison_memory() here directly?

I guess that's your call. Looks like we have already a couple of
kmsan_unpoison_memory() behind inline assemblies.

So I guess we should either continue using kmsan_unpoison_memory()
directly, or convert all of them to such a new helper. Both works of
course. What do you prefer?

