Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BAEFCD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 04:03:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E29D6B0005; Tue, 19 May 2026 00:03:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093B46B0088; Tue, 19 May 2026 00:03:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEBD26B008C; Tue, 19 May 2026 00:03:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DFEAD6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:03:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EFCDF1C00A2
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:03:35 +0000 (UTC)
X-FDA: 84782825190.16.E0A1474
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0E00F40002
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:03:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XzAcTUhX;
	spf=pass (imf12.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779163413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ca3jQmgYoBxwt2hfWOIQFk+4l+px1wE9D3uZ46WvRh0=;
	b=CSZ7lVY8gV0bih+Vc/lZUAEbNAKIqsgt69Zx7iOAYdNdGXNYpbOxhFjAIu0yi6dh69DxRZ
	4WAPybmU9k/u9KGbCHX7FQAt/HUAzWtbD0RuVA0v5kNmlzUQu1L8fS6lnnrxPIj9IHwe40
	nYVyFQsB9xfLGEcbyOy6TtM8A9xDawE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XzAcTUhX;
	spf=pass (imf12.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779163413; a=rsa-sha256;
	cv=none;
	b=qZ+dHs9m/J1fo97p1IQPKSIffqLWzVLWGRSLRp3tkkTaRomdOzROo6PP+Ngyg9vIBg4qjw
	1DteXZKtOfuWO1DEJNi6DiQre0fDYRSOl/yqBTCCuGjb239SZIPt3AIEVNiPnTSZTeQxtM
	Bp4E0ezHgUJ7qy5TcaLgvkvJigCuZ68=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64IIY5SU3601206;
	Tue, 19 May 2026 04:03:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ca3jQm
	gYoBxwt2hfWOIQFk+4l+px1wE9D3uZ46WvRh0=; b=XzAcTUhXYo0iuGZnk4r/LH
	e7BHU75pPHzA2f6oIKuXc28kfH4gMc+uja55SVGA9XWeKn3nwBzimD9skbofbzAN
	JpRnuRp5vOOxiMhuJ4ZDfkXLrPDseSHxN7Lg82BITDXRdv6rInvGyTIKzsadhM6h
	2ve6ftBzF+EfVjxtnnvbaLHZSOt93W65yc9b+691ZMN4KyMbsn47aI9YKv+Q4th/
	jdur41iBNQKEQ+XmuUfed8VJIXd2+TM6fE4fGYlS7lBbaXnjfp0dFFB2539xrsTg
	h8H/Cls3yVtGxfxUgoNL2aDznylzq1gkpUylOZU6zH15J+es+5jHaKtBMdim1urw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h8mk2e2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 04:03:28 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64J3s9aG021158;
	Tue, 19 May 2026 04:03:27 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e73wk0vxk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 04:03:27 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64J43LdI48824700
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 May 2026 04:03:21 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6183920049;
	Tue, 19 May 2026 04:03:21 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E632020040;
	Tue, 19 May 2026 04:03:18 +0000 (GMT)
Received: from aboo.ibm.com (unknown [9.39.29.16])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 May 2026 04:03:18 +0000 (GMT)
Message-ID: <a315968224c2f22da8dea7f7fe16588221378f8e.camel@linux.ibm.com>
Subject: Re: [PATCH 0/3] selftests/mm: assorted fixes for hmm-tests
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>,
        linux-kernel@vger.kernel.org, aboorvad@linux.ibm.com
Date: Tue, 19 May 2026 09:33:17 +0530
In-Reply-To: <20260512200631.b52b15dd47cdbfb887ab3e3b@linux-foundation.org>
References: <cover.1777870179.git.aboorvad@linux.ibm.com>
	 <20260512200631.b52b15dd47cdbfb887ab3e3b@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (3.60.1-1.fc44) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jq04XcvYFihocjfvOVCOObX_xZCw9uuG
X-Authority-Analysis: v=2.4 cv=GYMnWwXL c=1 sm=1 tr=0 ts=6a0be110 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=c92rfblmAAAA:8
 a=VnNF1IyMAAAA:8 a=WStnval94jwVSkObcqcA:9 a=QEXdDO2ut3YA:10
 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-ORIG-GUID: jq04XcvYFihocjfvOVCOObX_xZCw9uuG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDAzMSBTYWx0ZWRfX309KTbWepcXD
 7CUmOuKIMXG+RhTWfqiellPXKHYAe4HggTZOz6Ts+X3hWK+PCCraW76zH/nXisS/BoyzANNqIKU
 zkZbpLxUByPWAbRBLCSayIIyUUTlzQ482p0kO2YKn7GAD9ExWR5UIUf47zNafITBsVNvw0kNzXU
 GCMXwExniWnM9n3RcBLsqEuxoJvbj2FfxJLBDyQDqPqdv8UkGIokCly/lANN+ffpz1TBeGNJRlC
 00ThDiR3XUxy6nF4WoYvS3tAxO5kdFILNwJ/BOa/X/2akK2iHzx5KHl3ynVgxfhavm2cT/DU7C9
 IzMvaz6GQNVQ6IN8jN592XO31gCFiZzCWOcFwnPOVNR6Jt/lpXLB2ARzBvwzOirxdTrRn150OeK
 k5USKq7sVEvzDPUsgpG5FJPeXP0SYjV6nCNWbQxGGT4mjXM2UD7Y4/Td2CquvGQ7TMUxpdGj+ZV
 8FSADXAiZqVX9GNPiRA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605190031
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0E00F40002
X-Rspam-User: 
X-Stat-Signature: fucs99txjapphj7jokzcyjkz9brnonrd
X-HE-Tag: 1779163411-447456
X-HE-Meta: U2FsdGVkX1+ulIr+Po8tX9rbynJ1SdRBIWGivfn5EH/DbcAJrNssKRZ6H13FqDEbmwtZi6c+YG2aUptqSmWJRFhsSh9Yutcqu0B/4NAG5YuOkYIvPnbfH1iYzRMN9iO1fELkTR7noZ0fS+t6aqXCpABP2Xxn+siKBDJ2/zJzvdDGokL7kxNzg4bJkVd5f8pYtDqA2pKx1h0fmM0fLDc2g/5Xd1MKZopuxHDne9f4N8NPBd0VU3MkYU+LaMFapBWx7/uAYq5gmp2qF2zxxOsZ8HHEdL4DmMnN/sLzs0hPbF7n2CNYVXd/qZPesB4tA6U98fAwplzmQ7cg2loM/dI5p4ydHzoKV7vBdIJ64gjq66la7Abq2mBR7Duwxs4/+U1IwRCCQXgRdUUewSJvpcjdAQLKB2VB9sHdccG2J28a8/UaRiRk4/aQlVZGNFYnXiKccdXWMzbMt5ICbI+CQDSSgkIuCop7t9T9gIoIA/d58PkmHC2kxt3LMB/ZmEsStkWA3/CijZJgq1iCNfRnKk2qmKIP6SS8kPIFI/9+rPo8b02IxrC8WWVk+UiZLV6q0C3GMBgDI17tCijuK/EyXuhR4F4pEKWzMo0E1Fp11rdWBAQi0GR1keQwlmsFF9wH8ui8ou7B55GowuENuKboJkyJYBtzt5nBb9N2b1nhfOEbxsZld5aFD6wbLiD7WKdbwPmai5opun2Uy+vo+O01Pdvl6cUZ65M2r0B6IXYose3NxNdRudgx7NlyVPIZ6o29gHv63jNctATIAyLF9FLFpEuvFS8HBT2pjIiwxfVZ8ZhPPRShaMr6YdEgcq7UR1GEtQ78rFb0218JMUHj6SIK2xmRId30KdhgdQ5ptwby+a+aVdu2bKwZUqQ4JA7YjQ/bwIYiEW2ZDMwLvBwlrsE+qRr8tKKbF+1LYEf8vb15qLRD4sefnKbelzBLfSWIuGzRjmWRkf2Qj18g2SqN7DuOB56
 tubytAFB
 LSy4/CC/jSSyK0/uZ8r252dUJut7RVdMBzhY/Y8pz8wnTnihQhkNHMhY9+D4CBWZN+ELmhZKaGCNIq86/DckerJZgpDiXdn9MZXftHmLpfw8pBXW35i+4W+jUr/IIXQjbt37zpjGC9gwYw8AfJPdsoDKeywqNI6y1R9InIVkfUXvCt4aXUkEbEZgi8a9ZEV6n1+TrBz2WV1v0fNrhHGjcm5zZDnMrFwq1jCjpRyQmmpVEhc48DeDyi3BxfotjtO3pyCciYYoLu2fG0VQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-05-12 at 20:06 -0700, Andrew Morton wrote:
> On Mon,=C2=A0 4 May 2026 14:41:05 +0530 Aboorva Devarajan <aboorvad@linux=
.ibm.com> wrote:
>=20
> > This series fixes a few issues in hmm-tests that show up when
> > page-size and huge-page configuration differ from the hardcoded
> > assumptions the tests were written for (PMD/THP sizing, default
> > hugepage size, and related cases).
> >=20
> > It also includes a minor fix to exclusive_cow: the test ignored the
> > return value of fork(), so both parent and child ran the same teardown
> > path.
>=20
> Thanks.=C2=A0 AI review asked a few reasonable-sounding questions:
> 	https://sashiko.dev/#/patchset/cover.1777870179.git.aboorvad@linux.ibm.c=
om

Hi Andrew,

yes, we will address these and send a v2.

Thanks,
Aboorva

