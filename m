Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6978DCD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 05:48:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9FEF6B008C; Wed, 13 May 2026 01:48:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4FDE6B0092; Wed, 13 May 2026 01:48:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3E7E6B0093; Wed, 13 May 2026 01:48:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 932D36B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 01:48:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F37721C05F1
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:48:14 +0000 (UTC)
X-FDA: 84761316108.25.529BD56
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9F4CF18000B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:48:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mWHMG0UY;
	spf=pass (imf16.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778651292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y5nkvrhcTp0ZLxYE/7ciAVLdhgaAzJxIEPhcn/2rpz0=;
	b=scA0v5+n+StVBtIaq1Rmkt9tSm4JP7Q4FcOXk42GL8UxYpeg1DjIlunrjRLqpYmQLuWRsY
	lpLt+iVNDCg+AF0xSpRG6XxMcLJc71b3Lg24tZd3HIK377GHH9j9NjMnSADUIghyuEGbE1
	sLol92q544bGuXgDsqWNmY49fLPz1aE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778651292; a=rsa-sha256;
	cv=none;
	b=YEP8tMg7D7siAMidTrc/kPV4ymflChV7+6czWBIJu2mIrmATSAvtr+VMkhgJ5/p0eF0yaV
	8V+9EONQNHeephAyTTsLVlgfIofHvzbggK3p5u2pPYEWSobwSbpzqTpMnkavQTQocGxmrc
	pc9+pMR8JmQiGyrps+uizabFhni6XXY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mWHMG0UY;
	spf=pass (imf16.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64D3AaU43179891;
	Wed, 13 May 2026 05:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=y5nkvrhcTp0ZLxYE/7ciAVLdhgaAzJ
	xIEPhcn/2rpz0=; b=mWHMG0UYM8GorUZEQ6kw4Q3J4qBRCotpl6kstECvJD1rtb
	xCfXEkIxJ4fmJPIQ+RSJsF3Eg3coBVehAPUDFIE0TaIiUmjJfeZKgZp1C5ytMBUb
	JDsPtELRt0bCLSIMeCGsEW5fmY4TgC6nLP2CYbjctaNNzkVGbkt+a/uLHLIgJDv5
	4Sa1F+TYCRFwkDQ3c7MWZ6ScuVXuh+CsAGRgHr5FugQdX71mt18waHUfRCt0Nrtg
	GbhjGWRYzOKOZabLdeSvo6LU5LhrFCbkgxy6KgtCLVvaNsDE6Ri+3E4smeAY/Clh
	uuHTT9OX4+uCDz8UsjYx2WoR6TZJowDRGP4dli0A==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e3nv6nxxb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 May 2026 05:45:30 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64D5dOtk018879;
	Wed, 13 May 2026 05:45:30 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e3nfgxe3m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 May 2026 05:45:30 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64D5jSiI31130048
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 May 2026 05:45:28 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 16D9C2004B;
	Wed, 13 May 2026 05:45:28 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A7B7220043;
	Wed, 13 May 2026 05:45:18 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.210.65])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 13 May 2026 05:45:18 +0000 (GMT)
Date: Wed, 13 May 2026 11:14:21 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Daniel Gomez <da.gomez@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        pankaj.raghav@linux.dev, Daniel Gomez <da.gomez@samsung.com>
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap &
 xfs
Message-ID: <agQPtTx2EXHr10Nn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d5d99db2-9d34-4caf-bcc8-c4a3af561901@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5d99db2-9d34-4caf-bcc8-c4a3af561901@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=Us1T8ewB c=1 sm=1 tr=0 ts=6a040ffb cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=NEAV23lmAAAA:8
 a=lcIDxHtVAAAA:8 a=6-Iau3dbAAAA:20 a=e6PEXMpC0EWP8Up90DUA:9
 a=qcg49hLlgF0N60+LroqrWnV/Vu4=:19 a=CjuIK1q_8ugA:10 a=SmPfr9tXhjlp3KZZvEYH:22
 a=bA3UWDv6hWIuX7UZL3qL:22
X-Proofpoint-GUID: Y02irxQB16MSD0o1gbPDksguta2VQXTm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDA1NCBTYWx0ZWRfX25Y19o3iK7En
 Szk95/27oHoKr0ldyYQl2XiVgKxouARyLOPuBzsiB8pV4pxQZ3pujNnmWnGnueHT9UoJ9H+y4/P
 6fxtxF4UwdvM2rayClHEDLdSIiqpIu5bFs5h1YnT9qejxm1KcAXSLozg93Qcts2uhgurM1inLGW
 3AETfqHMezU9dzoZ0mSaib7Sj3LJliaA4Ed7VDjZ1+iCYKLFMVwxcpGwhwLTythjtr4ZHuCea2J
 Tl4nt1AmBG0vV/g6D2RjMloZ0FLFoVfpoJHdG+85SdP8LYFmPStr5xP1z5si8N03UcWzRcV0uva
 PsrrqohchQwqay+/0W76l08NODI+CM0+c2Q2rvqR1xrm5JmodScB0UgxzVf5N7pXnTQpFMtXo0F
 FYyt/iGu8Bn2pEw5+OKzvAEG2RZoF2i5m49OFa6IktJ4MkS8ZBbfhdLT8osAN3lwTeejBhM6ZjE
 6lfKoiVACTgmP/6oduA==
X-Proofpoint-ORIG-GUID: w8tY36-yrZQPqJpaWnynhyVjgRf4QTu5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_05,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 clxscore=1011
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605050000
 definitions=main-2605130054
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9F4CF18000B
X-Stat-Signature: w5e91tabdx38ybk89zbuttf7hursx81t
X-Rspam-User: 
X-HE-Tag: 1778651292-109967
X-HE-Meta: U2FsdGVkX19FrcjC1Txr+j/esZcSk9KkTudUHzOjkmyVXmQzx9Sf9jmNKEZGBqQUwUas7xDIZ7dGlQ8PmQ3PPoqhH61045crCf7xo9pRWLZhV2k2v/xyI4HEC3wN07DbvwG0nPkenYftTEVbnw+4iOIkpCTPIdxJe/037wIXD+yNU3xRIM1rWBgbZWPSJ184M8z0qJ+J9LwDRI2WH/saUvHZJlyTOXhIkvhfFfNJamuXqiakQcX/nkWB3vEkDzddDzLkPQSD6mt04jUaKFrb+VjvZA4uXE+H+QJng0b78Out073JG//PYeiU8uBQ9Rqn103rovkR2CZarJH2qKu/058VUJJ5kU1G/Si9L8bYuXCew66NTuKYFtALeVPA/o4Ef+1Ii30eWKo+c/tDiWoNZXGn03OFSg5/pVXyJIMCb2yYoAQWNsBnnQqENB+btZUu0qhe6OgF/W9D367yL9IZGC8Y/dtbdYP5amdbRLoOer/JaqZy1utFFB6o0zymWuCCwA2r7VAgBTREXELc4K+0/XfA5/cpQPNdEP+qFA83XyPZic8jYF3Jic8BV/5WLEd/oqM+dZS9/5xef26PUaQhsCbMO67iByKWGzMzay469GdyDCREd4LNYHkq3jnhI72XO9ccwpGp1YYwNOWdARtvYbYByFa8DAJHm4QM6XhR6FM2YiQt6sRzLtAW4YL6IKLB6hAsFrXmeaUORo9yx39D0EbXQ195mW3weYIkAHRpTbw/kI991TAem5CRq6+RJiy8IVGTvStF98b7UFIZdcrEiL9YRbYkSxJ3vbo0aUgo1daX4Xcu6t0V6/dtPo6AQi2QopBzWyy+PZA6NQns3H0tCaIYseOoJuNYL5r9yPgU5UDeaBi+2O7r0VYo+YxrRTnNlEI+060KUeZm4wUJFfyyWeVOf6SSDaavWdHG94YEznwE2XCWhj2GD3VigJyFFi25LmxcZjbyedmA6nB4zta
 4aFrR8u1
 Lq4IQw1zpOaeZpnEJeMcLYSn7k523JL519g+OxDK/6wQ1auEdize7UKzVSr/F12SG0UNT0vnLKHCPdhuQA3mqoIKfVDsF+mOH/mJzqQ/8EC6E1z6S/yeck7FOPtNI7yErf0D7WeY3TleyiALgHM31jBUKkPudJtQPMzH1heX2vs4Kcx8LHAmHWdGWVnbUFUWZSTL+brpGzMyjPffxN1Mg2HK/Wwqio3wHhimPPimtdmZHr0yK3xH1njTkVXo9zCQRLGNlgkYFxxOHFzQMF5gL0xzBdJUabHGfMHd8CV9LdeWX6Kdht9fhLO3N9f03ZZxjwRDUMq6F0454IgYqv7ie/2FTQcevylgIoZPwSPRMhCsAxD1RghOWAHWoO8A3dRw+ptEmzE2rbGVID2BXkKrPHjkR0S6+2kcn4sWJGSLooYIYEJXsA8W4KGklznaYu9oTPBjK9Wbfw5bXPadglwci8WcFONSMsRa0MX+bycWEDeoHANgaYwMGMlmezmQv1JhD2vVAGM2K7U5tfPI5YhpU4e/ZdKJ8zlGlq0zoCU6XZog6RkBVbQccpy1sCinjQc/3yrU8JQpoPSduw1w1c1SbcMFCrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 04, 2026 at 09:54:49AM +0200, Daniel Gomez wrote:
> On 08/04/2026 20.45, Ojaswin Mujoo wrote:
> > Hi all,
> > 
> > This is the v2 RFC to add buffered writethrough support to iomap and
> > xfs. The changes made are mostly to get the writethrough implementation
> > more inline with how dio handles writes. 
> > 
> > 
> 
> I gave these series a run with kdevops and fstests using the following
> profiles: xfs-crc-logdev, xfs-crc, xfs-reflink-logdev, xfs-reflink.
> 
> Note that I applied all patches on top of v7.1-rc1 and xfstest-dev
> patches from Ojaswin have been rebased on latest master [1].
> 
> Link:
> https://github.com/dagomez137/xfstests-dev/tree/iomap-buf-writethrough2 [1].
> 
> In general, some of the results here seem flaky. But let me know what
> you think. I'll try to confirm the possible regressions with another
> full run.
> 
> 
> Summary per profile:
> 
> * xfs-crc-logdev: no regressions or fixes found
> * xfs-crc:
>   * generic/753 fixed. This test failed on 7.1.0-rc1 run but succeeded
> on 7.1.0-rc1-00005-gc6a39600d3c3.
> * xfs-reflink-logdev:
>   * generic/415 failed on 7.1.0-rc1-00005-gc6a39600d3c3. I tried to
> replicate the issue by just running generic/415 (not the entire test
> suite), and I couldn't replicate it.
> * xfs-reflink:
>   * generic/457 failed on 7.1.0-rc1-00005-gc6a39600d3c3.
>   * generic/561 failed on 7.1.0-rc1 but not on
> 7.1.0-rc1-00005-gc6a39600d3c3.

Hey Daniel, 

thanks so much for testing the patches. I'm back this week
from travel so still catching up to my emails. I'll go trhough thi and
get back to you soon.

Regards,
Ojaswin

> 
> 
> Here the full report list for each A/B profile test run:
> 
> 
> http://htmlpreview.github.io/?https://github.com/dagomez137/kdevops-results-archive-wt/blob/main/workflows/fstests/results/r0001/fstests-report-7.1.0-rc1-vs-7.1.0-rc1-00005-gc6a39600d3c3-r0001-qsu-xfs-crc-logdev.html
> 
> 
> http://htmlpreview.github.io/?https://github.com/dagomez137/kdevops-results-archive-wt/blob/main/workflows/fstests/results/r0001/fstests-report-7.1.0-rc1-vs-7.1.0-rc1-00005-gc6a39600d3c3-r0001-qsu-xfs-crc.html
> 
> 
> http://htmlpreview.github.io/?https://github.com/dagomez137/kdevops-results-archive-wt/blob/main/workflows/fstests/results/r0001/fstests-report-7.1.0-rc1-vs-7.1.0-rc1-00005-gc6a39600d3c3-r0001-qsu-xfs-reflink-logdev.html
> 
> 
> http://htmlpreview.github.io/?https://github.com/dagomez137/kdevops-results-archive-wt/blob/main/workflows/fstests/results/r0001/fstests-report-7.1.0-rc1-vs-7.1.0-rc1-00005-gc6a39600d3c3-r0001-qsu-xfs-reflink.html
> 

