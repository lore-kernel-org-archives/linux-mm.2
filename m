Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24BE2F9D0DA
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 16:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B5616B0088; Tue, 14 Apr 2026 12:09:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58D4A6B0089; Tue, 14 Apr 2026 12:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2E16B0092; Tue, 14 Apr 2026 12:09:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37BE26B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:09:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DB9B713862C
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:09:03 +0000 (UTC)
X-FDA: 84657645366.17.2AF8123
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9796DA0012
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:09:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UQCEAFeQ;
	spf=pass (imf15.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776182941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NOEH4v9NjjhJAHew/mjaIu3pWf52+D6D4Qn2ZEwR+XM=;
	b=ZUhe3exsl2td4yG2HPrW6ZBjELFTLbjzJuqa94GsIJ09+xRqSzmWdjVqQKoXU4mH4JiQSy
	q0VI8/5gFLQx9RrcalagyJc3Vmuaej1KyTUfkcLqFQudovbZ+Nq6qDxlvlpWo15HrTwYww
	YtPXlySf9zVAx3aNtHwl+SHTkBCzZzU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UQCEAFeQ;
	spf=pass (imf15.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776182941; a=rsa-sha256;
	cv=none;
	b=X6uev4CpmURxO3G1vUkHu5nBtNrW4vCEi5dIRU4p7eRSPShCnlQVynGz4LLqLMp8Il/pdv
	I56kuTrlqvkAHn0HWcFDwV2B60dhuoj+f0eQHQL7YhcG8fvNsWl5+NOyOYvd7fbAgsbAqi
	qxPpxTKeDTUAaM4M09aKEWDovoPNxrM=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63EDUuh91805230;
	Tue, 14 Apr 2026 16:08:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=NOEH4v9NjjhJAHew/mjaIu3pWf52+D
	6D4Qn2ZEwR+XM=; b=UQCEAFeQ2d4X7BC/ko1mVwtXwDvozgQazLJmrwwu6B+E1h
	lEvfMLfmltxkp2wHUsE9cX+c06sI4E0JnJcPQZh1DGaOF+rD60/gZ8pF1sI4a8n8
	A5w/zRL4avtCc976GsqaZiTUbNe0crwMTfr55jitBKfpk+LZcmrlTe0QEf2iqKQp
	AaU6xGPgfXUY/D8hhDaJ5JyPrtgXB3m0JWScnyvF7l3xxlhhQMWxKtcc30CQi1Gu
	AsRf7JQf8KybzdxW1ZuUXGwxpv9mBXfvb7HjsSg4erL3WyG3rG36RkfubggNjaOU
	JbT8yHkf/qxpCPpMn+AVNnWokmrV49lfeIsMt2Sg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89k3j5y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 16:08:55 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63EF0UMh025621;
	Tue, 14 Apr 2026 16:08:55 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg2ujj4a3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 16:08:55 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63EG8pFH13238622
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 16:08:51 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9FDBD20043;
	Tue, 14 Apr 2026 16:08:51 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 21FCB20040;
	Tue, 14 Apr 2026 16:08:51 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.87.149.241])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 14 Apr 2026 16:08:51 +0000 (GMT)
Date: Tue, 14 Apr 2026 18:08:49 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] mm: make lazy MMU mode context-aware
Message-ID: <384c5b93-7939-4a9e-9298-66397cc6fa28-agordeev@linux.ibm.com>
References: <cover.1774420056.git.agordeev@linux.ibm.com>
 <de89fd353a8dcd5e3bef4d91e9b6682d132ed9a0.1774420057.git.agordeev@linux.ibm.com>
 <44dd86c0-1845-4dd9-b4b4-2cef6d1c6357@kernel.org>
 <e096e88b-f1fe-44a1-bfa6-451eef028203-agordeev@linux.ibm.com>
 <665a19a0-47c2-404c-bd2b-482ab51b8f64@kernel.org>
 <896b3d93-8e60-42e2-b8bb-d3d4e8c99927-agordeev@linux.ibm.com>
 <534ed892-a6ab-454e-831b-e207930c35cc@kernel.org>
 <584f0f88-aef9-4a70-b0bb-abc797f741ed-agordeev@linux.ibm.com>
 <17505ac4-c5e5-4046-b362-830369b8d401@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17505ac4-c5e5-4046-b362-830369b8d401@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: l2htD7g09NdhV0U8xiO60AfRpB2sQ9Gb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDE0OCBTYWx0ZWRfX904Pf16kaZjA
 w57meJEwlyDesUl2y3OtaTkvqTum3P0R+CQhP2OqDmGmMoOm+C6Y/6D+ZP5CHib/7eDkcxVwDJ0
 6f5lCa7SnJv3ZvvJhmoz6L7qA5+4tcIm0lNQ8BAF6bRaIG2d+JfmmJlGybHeDaFagdr5GEVXbOA
 KSIc0u0S5HPNqUm3CrUKYSsxLDBOauBX2k0koCLMmxknuegAIh2IhzLODuPMK8PyZwTOJ4KvP9z
 qU4Zogqpv80oDt/DXWk0Bc3igU6xXPWvYcCblP0EhGxSo0a48Dts7lnTkXTMm1UmuUJY074MD0y
 yIEuiyA9RAP534p1DrKIzBx2X0aCUk1cD1QmgoCZ39Ta30CN0s00KZFXscdGbtf2mm0M6Sdcze4
 29Lpxc8x35SOvDlV0OcId4GErqcnIYsUW87yrJ7QnoyqLSPpLSRyA+xbEqJQ3dvghvP1QAjlAYo
 qZ23SQkY2a8rjO9fC+Q==
X-Proofpoint-ORIG-GUID: l2htD7g09NdhV0U8xiO60AfRpB2sQ9Gb
X-Authority-Analysis: v=2.4 cv=W60IkxWk c=1 sm=1 tr=0 ts=69de6698 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=MNWzyCX_VJYSxvCe8oMA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 priorityscore=1501 spamscore=0 bulkscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604140148
X-Rspam-User: 
X-Stat-Signature: dyjwobnwrd8mqmesq8mmq8jts9u7gxjk
X-Rspamd-Queue-Id: 9796DA0012
X-Rspamd-Server: rspam09
X-HE-Tag: 1776182941-173787
X-HE-Meta: U2FsdGVkX1+IOmyr0g56Yg2Jbsa3GVigVpvZGqZfyIzkRXayyd9iUrEbB65eFqMXdYzSX+CDJN/NbqxlZKSD4KWE9wpwmuMI6cm2gmTTaRx/j1l9sZzN4K5XMD6wVFYnrsfP43va8A8+hsmqPSI4BfMUQ823Lb/bjlEDEZsQg2mFWd7/tnWUNaQzJQXc4sNchVXVI3MzK+I9+zX5hGoez2N1X2eVv67YuSlIz2b+Tcv/Dk6LFEcf6L2EKe8CrzHhXJL5cd8/vDY3oUYJ78UNNhBg1mi4+UIPnQFyL6xHT6ivs+RyJuNLjHKwXhpv0zcM12D2RyI5ZGR9SYLdHtsou7z7PBMllZL0VB1ZhFmZVoqJ1i8oAr/Ki+CLipqzadxuCqeevPGZNa3SKBZHbSBsLN3oFC8C51T7bhSu7p/Bi3LffElrxGXQ+O/s8tRyNjdGJ2d3PZsltVSJ8qNBgE7AgwsBBUvur3W5YpDluu/b4+WvFViYoFXB/mcYX3W4CfkMQ2e/+d4z4y9WMBD2iRrH2EY25KRxXv5vnc8YXzBYkiUvvkJR3HsR8BrYaSj0eyKhNtnEQdNqEfa8qXfCD2KLk5SGRl2GJR8wDUueer3s9ta9EIu/e/Hj5z7PstFosrG3gRSo79U68n9rGJ4yztNe8zb3GXLH8z4vacBDDLuSTok8iunHJniW/4oDLS/DEwz8fjecVrJtGmVBRIDB0pRi8DTxPEpAWluY4YIC2l0jOhgvLZGywkRb46lmB+sOnNgmhWChjgZIQKDWA/M16l9jMpHDJAYuHkEaj9wY6hSpyG9YlwlF/CWDOiAlyk7iwPidJgAOuRo47A0lzKGoai+CmSli9V8G3QZfvHgAzvFK2oRcsbdiURf1y65rv74dNgN+k3IxeHWNGMSlUaA6xq5rQjkZ2PS2l9I5TsxGo/Ic6OPfbpxrCOSPCV8UhR/jRGYfdhaD9dTyb42zJn1TOwn
 ww8ik+uc
 qCcdVH9mLLHiGa9IHRh+0/dCfaW5rjF6nMvHm6XRZZBJkJS2NZZKjBtUV5WIsmj1uMicx26tOmeCVE46j1e1f6Su7Zm9oNX9Rx0m7ZXIpN88AFxJy1UC0as6mtcGpY6uf8L4b6E5J9r8RTD5HpOGM+/zwFyIk1MQ3PrQwH51JMBl3HTNeU+rgPJpdKJKU33Vz3MpnRc4AA4IYjDPUbhNV4rcfqYHH7yZOOHZ9sDioOdw0hV16DSJN+x1I8cESRzlK0dzYDHRtaxmTx+m42Aai087xV6YGjAQCixekmoZscdV5yh/1laUEkS9apg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 04:30:10PM +0200, Kevin Brodsky wrote:
> >  * @mm: Address space the ptes represent.
> 
> Not sure that makes sense, maybe something like "Address space the PTEs
> belong to"?
> 
> >  * @addr: Address of the first pte.
> 
> Isn't it the address of the underlying memory rather?

Will update both and also the clear_not_present_full_ptes()
comment, where I copied it from.

...
> >  * PTEs that fall within the specified range might observe update speedups.         
> >  * The PTE range must belong to the specified memory space and do not cross         
> 
> s/do not/not/
...
> Looks reasonable to me otherwise.

Thanks!

> - Kevin

