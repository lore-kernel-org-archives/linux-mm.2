Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECB1BD72372
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 10:54:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 479206B04AC; Fri, 23 Jan 2026 05:54:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 450406B04AE; Fri, 23 Jan 2026 05:54:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34F9D6B04AF; Fri, 23 Jan 2026 05:54:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 207946B04AC
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 05:54:51 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CAA6F1378AB
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:54:50 +0000 (UTC)
X-FDA: 84362920740.24.D213B9C
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf19.hostedemail.com (Postfix) with ESMTP id 462351A000D
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:54:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mUBcwFDA;
	spf=pass (imf19.hostedemail.com: domain of wintera@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=wintera@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769165688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=csXEFZ8Rtqlj0OhRse/YTXINvL5yKhREspaRqgErWlw=;
	b=be50ZTZCIQK2q3gYIkn2shBZYn65eG7z7QZnOlZRU/c/xrTVHae4lfrcAzqEphzTsQhIkW
	lvY/xzdQsO4DHpU9AZ2IpSlL6A+7M1upm/qvXAvzEnXNe/KFXkxN8KyYB0PQBwnGz/Sbfi
	ikRuETb0rdVBIE3H/LJ5pIn7ZzMgL8k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mUBcwFDA;
	spf=pass (imf19.hostedemail.com: domain of wintera@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=wintera@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769165688; a=rsa-sha256;
	cv=none;
	b=P0YIAitZG3E5hOfcW72mUFENLhbK2MbOEtLojJH/0F2t+Wcn1nYmZUBqNZ3GptBELZHstI
	lgsph2Mz0F8H9/KRPf7OAibYMoozP/bSd5L596rJ8cqo5VQvI0VG/axWh3i6WeXZBkZnVb
	MNtSh746jQ5i6398y4ynr2NCAfFFXbk=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60N0KvIF019648;
	Fri, 23 Jan 2026 10:54:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=csXEFZ
	8Rtqlj0OhRse/YTXINvL5yKhREspaRqgErWlw=; b=mUBcwFDAjlOKo4HvNcQjFD
	Lw+hDpFqSKossTzU/13dUEv/HPtAGVAk9aPvb1xYee3ZMS3VOE8JUnZJCKCZTh2d
	uKCgqqQNay1pidqH1NTNV0HUSLA23tS7ncJ6yGPi24uCUcxCz+dFpf+YzVCnDve9
	iixyNcRG/ODkCQymsXWNCkKrbG7tfQLlNnjs1955i4bh5qp5EAbpuUQ56JvZ2sfd
	o7S3vPud28eVBbSV+bdHwNoU7fsil4Mufs5mBPKK6aaa57xffvwQ3ZjMMTMhdvJF
	TgWt2QFPA0ICJGtfh1QpcGw011Fteb7usYZE3C7X5SXgJVNx79Gt7ZXOh6RYczgw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4br256fef5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Jan 2026 10:54:44 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60NAshMC006452;
	Fri, 23 Jan 2026 10:54:44 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4br256fef2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Jan 2026 10:54:43 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60NA5KfH016600;
	Fri, 23 Jan 2026 10:54:42 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4brn4ygqnv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Jan 2026 10:54:42 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60NAscIS59441584
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 10:54:38 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 352C920043;
	Fri, 23 Jan 2026 10:54:38 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BDFE720040;
	Fri, 23 Jan 2026 10:54:37 +0000 (GMT)
Received: from [9.111.132.48] (unknown [9.111.132.48])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 23 Jan 2026 10:54:37 +0000 (GMT)
Message-ID: <6f8de95e-b034-4ea8-a246-605047d142db@linux.ibm.com>
Date: Fri, 23 Jan 2026 11:54:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 1/3] net/smc: cap allocation order for SMC-R
 physically contiguous buffers
To: "D. Wythe" <alibuda@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dust Li <dust.li@linux.alibaba.com>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sidraya Jayagond <sidraya@linux.ibm.com>,
        Uladzislau Rezki
 <urezki@gmail.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>
Cc: Mahanta Jambigi <mjambigi@linux.ibm.com>, Simon Horman
 <horms@kernel.org>,
        Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, oliver.yang@linux.alibaba.com
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
 <20260123082349.42663-2-alibuda@linux.alibaba.com>
Content-Language: en-US
From: Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20260123082349.42663-2-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDA4NyBTYWx0ZWRfX283tG++MGNtC
 0z7k81OTUFvAWo+ixbiBlazIsDbhz7VdUPceTVZwVjGq51U4brUVXJQD7lyUtmt/eiYJLWJQutg
 jeJIbYtWU9MnxUU7spFhaIo/W3LmFSDbMPelFh7DWBW15bt1DG47RcQJV2v/z0lh7HStIgEZUZQ
 vLMUlb3cPycJR2CccAuzNUdKQVSSBTGl1f9vqB6wh7u2eACS2S4KI1UySoxwKUy905PLtkBy3Cf
 tz1txSC8iF/aDbjcbIiA+ihAoW+BQipjEegTc/NA3TDSHqxkpHx8fnbw7+0UsHNMzVeOX/tWVT1
 I8fBrzR+rebVdOwMUuxckpfh7M2jupKcSCNiXg8bns2EVhUAgSQFzKrWgiOBvn6+sWgbfKTiZHI
 Gs/cRM53KC3fdZfuROKWbAJs/pV579LJUL/5alri9+Uy64T7YxVvHqxxdVBiBWtwanW34RiGf9H
 By9XgjQY1rgtJ2DF04Q==
X-Authority-Analysis: v=2.4 cv=BpSQAIX5 c=1 sm=1 tr=0 ts=69735374 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=SRrdq9N9AAAA:8 a=VnNF1IyMAAAA:8 a=dTheS_w4H7qbiWTV3QcA:9
 a=QEXdDO2ut3YA:10 a=-_B0kFfA75AA:10
X-Proofpoint-GUID: 4DB0nUwNBqPXJw6bK7wTkhoyrtboA-7l
X-Proofpoint-ORIG-GUID: OPcdjeIHknd5ucfLknkVuotX6sIIBtrs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 clxscore=1011 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2601230087
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 462351A000D
X-Stat-Signature: 8houpbunk59564x7enc1rdwkg1ftgtbh
X-Rspam-User: 
X-HE-Tag: 1769165688-281808
X-HE-Meta: U2FsdGVkX1+VoKFrYSn/XIZVO5+WswFy6/Z0YCDc1IXbJPnvKnKxo0b3Ztq6uR659NUDIPrwK/A1TP+lXoqAoFYP75VOoPC6QjPd707cN2S/4Y0u/Jh/P7cyg+PMeGuqFfE/ugxQBK8RwyixXwyzxJgYokYSPB+xNc4n0X8uUNWkTsarN6Rd7cGRjlmkSW3Uapfk0omr4Z6GOOywOqRZNr9Mu3uvkQaWJzruuIqkz8W8cdRIL4baEeC8kFWQ90cPzG6MaJF4yXeXAvC7vPLd40lu7tbhLYw6SXR38IoOVVXvm24mD8ujyU01/lMrEtewQM/IXam3qZGMCeohp4of3ZPl2lkO+Mbnn4x73UkgFsiLqc+FU7IS8wuL5KhE+zUKNwR8NUExJl0oi9sMVwYkV633sx/+wXsjqHSFIwwwCRaLddho2I/2Oo0l81m/LKXUvm1S+mHD5b8OjgbpLujQM5QtGbmpgzdpfq4pZrVHf5XE1i2qXV0iCHGox723DN/czRsnI1Oxc9euzkiVDKuAbviHM1jGzByKVviE2OG1JDFzoDkbXH0mzVQD6t1uQ3hwXGepmVTlGBqjEzRCmGO/OuO0TtRAHqkFLANln3WJvH1KnBcbQ0q9ujXRqJkPXBsqfJyrH2ep17UvbW+/xbDUeRV2X2v3JrM2azfjO3ysvPgoXCwy56vIwMd6bssD1uXQvxHPvVEYI9/3V4kQ4qF/UyPUg42LblyX1Hm/DLrGemT8An4C3cLuCf5PB4ou/eWn7OrP4WWoSOUiNdbwqMP1BWGk7mfUNSa7/vV18XoD857LNVOiMbmhwqJaF8ey/fjOJB5zIVpK5ylahEZ34gLG31e02v2J0crFFfYvXiDY2vhfyxh8anzDyVALyR1ttIIZeeJxzROCdl+xd+fRbwGx2yUKL2Olphzo8WzeLMq876wRfArgfMcf2VknR/gn29chfgXr7mtEedqCmeqqOsj
 gRD5SoFB
 j72vkrsn1z3e0RQ2/LkDiKakEFEiSL7cu+m/UkRlzrbm5TWYISDFeIws44SzRXVQbFX8bVnh5aQPC+ZMp5daUdcvWqDy9GKU7i+8pfdsI8pCMzPP7ewuA2moLXIotYY26p1XdESQisI1W3uVGp5E5qyGkhi8DGpLJ+qTwLjqrTwiV271xamxGrfCBWhuPSc1x5fh/erLjJ7gNPudqLL77BI+gWWuUZb3PPYpAqNDgA2onKwC8ypdFgBlWvZqvzxPtG4bNuvwp5jQ95HIIyxgxUgUf9PL+w0n7xNMLKUETPw08tlCOzYDtqAto2FRCBjQafBHz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23.01.26 09:23, D. Wythe wrote:
Describe your changes in imperative mood.
https://docs.kernel.org/process/submitting-patches.html#describe-your-changes


> For SMCR_PHYS_CONT_BUFS, the allocation order is now capped to
> MAX_PAGE_ORDER, ensures the attempts to allocate the largest possible
> physically contiguous chunk instead of failing with an invalid order,
> which also avoid redundant "try-fail-degrade" cycles in __smc_buf_create().
> 
> For SMCR_MIXED_BUFS, If it's order exceeds MAX_PAGE_ORDER, skips the
> doomed physical allocation attempt and fallback to virtual memory
> immediately.
> 

Proposal for a version in imperative mood (iiuc):
"
For SMCR_PHYS_CONT_BUFS, cap the allocation order to MAX_PAGE_ORDER. This
ensures the attempts to allocate the largest possible physically contiguous
chunk succeed, instead of failing with an invalid order. This also avoids
redundant "try-fail-degrade" cycles in __smc_buf_create().

For SMCR_MIXED_BUFS, if its order exceeds MAX_PAGE_ORDER, skip the doomed
physical allocation attempt and fallback to virtual memory immediately.
"


> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>

Other than that: LGTM
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>


