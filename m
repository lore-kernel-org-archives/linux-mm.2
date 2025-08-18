Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82682CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 14:26:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A2748E0014; Mon, 18 Aug 2025 10:26:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A918E0005; Mon, 18 Aug 2025 10:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84748E0014; Mon, 18 Aug 2025 10:26:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D0DAF8E0005
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 10:26:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8EA8F1DE426
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:26:56 +0000 (UTC)
X-FDA: 83790104832.03.41AE4D3
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3633F1A0012
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:26:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=quicinc.com header.s=qcppdkim1 header.b="X+/fQxfB";
	spf=pass (imf19.hostedemail.com: domain of quic_charante@quicinc.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=quic_charante@quicinc.com;
	dmarc=pass (policy=none) header.from=quicinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755527214; a=rsa-sha256;
	cv=none;
	b=sdMfScXSSN2lcLXmzg7MvinOQn1L/d0NsQvw7YYe155iNaeDDCobk8hHCLDPbYopMoqVPA
	zB62RkW+q24Q7MbrnK+1N55TIo12R3acRrrhp1vcVPN7H6c77XN/j3j1HfG2zILx0XXxLE
	JNwasWkqzd0dGclfuq419/mawmAIXZU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=quicinc.com header.s=qcppdkim1 header.b="X+/fQxfB";
	spf=pass (imf19.hostedemail.com: domain of quic_charante@quicinc.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=quic_charante@quicinc.com;
	dmarc=pass (policy=none) header.from=quicinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755527214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N9XTtPIlb1beSEhqR68lpF56qfXbGpzXDW+vo24hduY=;
	b=UDnlP/svdtrpsx1kX3BDbEGQn3Xq3EyzTtJia8GxhMoeEBbTe4gAk2rdoStKu1TF8Lormm
	uWdQvqb1o1UfmSaKnDDOFrT987du9Cw/qYWZNI4PyOubCM6WJIyw0TlL9ytNRu18WIf+nH
	rwRZtY88Q03gTax5XqAIH2UCw4K4ewQ=
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57I8UcmF014629;
	Mon, 18 Aug 2025 14:26:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	N9XTtPIlb1beSEhqR68lpF56qfXbGpzXDW+vo24hduY=; b=X+/fQxfBXTRDcjyI
	AoxW4bMMKA7nuLTn3u2JeX/TnS6zpuU5c/HqlSPO1dtlXJsgQeNigRSd4AjRocfe
	QVOjROlbMSbiGYjOjoyCzN2FYRGD7WybBPEuoIyd27BXS4xhRPKiZiuaPX0sd8xs
	VU4/Ic8uBniVF2Ieaw9GsLX3smQhQ5TLXZjAUAUfqVVUSgfQ+1iTHNbqGlf3Ve3Z
	TQwrxR4WgmB+59F7/q24mKCwpoMh9mpMXu99RbS4fmXhZKMgxzmyZnK/+/LQPdCc
	9EYs9cLkvox+RDIRGuWWQ2hmxOR4LHe2hJLDPaqA+lzqye5xqOY4SgB87mnu2HW5
	SwzXwg==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48jh075279-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Aug 2025 14:26:30 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 57IEQTGY017650
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Aug 2025 14:26:29 GMT
Received: from [10.218.24.190] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10; Mon, 18 Aug
 2025 07:26:23 -0700
Message-ID: <ec37a541-0803-43b0-a0f6-aa3b632bcb97@quicinc.com>
Date: Mon, 18 Aug 2025 19:56:20 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] Remove XA_ZERO from error recovery of
To: David Hildenbrand <david@redhat.com>,
        "Liam R. Howlett"
	<Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: <maple-tree@lists.infradead.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        Mike
 Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Michal
 Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn
	<jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        <shikemeng@huaweicloud.com>, <kasong@tencent.com>, <nphamcs@gmail.com>,
        <bhe@redhat.com>, <baohua@kernel.org>, <chrisl@kernel.org>,
        Matthew Wilcox
	<willy@infradead.org>
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
 <3970cd97-2e9e-403f-867a-3addfbe399dc@redhat.com>
Content-Language: en-US
From: Charan Teja Kalla <quic_charante@quicinc.com>
In-Reply-To: <3970cd97-2e9e-403f-867a-3addfbe399dc@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: CVnTXHqcMte60tk48I5qtYhtMN12fvDh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE2MDAyMCBTYWx0ZWRfX0OUlx77pTTnV
 S0l6UGnrZ2CvWTs2XqQAQXAdJbV+CMBi1dZFhXoV12MyVHj/E2vxcftwtOi6bdgKGNbYHG+wIkR
 RqsOG7k3wdTXSq0kOEOHJUpnB2/mv/Tdu6J7OPW6VdM1R0XkXeD/vjJUnAPZj+7TuXQDloN7GgY
 gg4Edm5ztuZApPxqtlMP1r4HFS6AYOSEAuynM0RBvJM3vFeOQDum36FdqK/+SZo0O2HKmBZQLUe
 G8tYfL7jGHVURisq1rj5Qm/Di1cd3vL0jT1IXD02SGENOkEExqnGo+SvQUX2Y70qfFPDy6oHqHE
 zYBxFKtbaagMDevKZUeJ/UoRPfgnmsXC0ZphvKt8bcLc9VnCxpY/j/IoMeLEBVJ1Ig5cnecBb4p
 JBUB8Vcp
X-Authority-Analysis: v=2.4 cv=a+Mw9VSF c=1 sm=1 tr=0 ts=68a33816 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10
 a=XXfpJIKeY94Gd0witf0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: CVnTXHqcMte60tk48I5qtYhtMN12fvDh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-18_05,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 suspectscore=0 impostorscore=0 phishscore=0
 adultscore=0 priorityscore=1501 clxscore=1011 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508160020
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3633F1A0012
X-Stat-Signature: d66eifng4nmtc7b3od5pktbq3uayfxfo
X-Rspam-User: 
X-HE-Tag: 1755527214-199595
X-HE-Meta: U2FsdGVkX1/5fiK8xkzdvOEo5DIzAiuYSs8AqpVawA+PT6JGEWlPocvf878BCN8lQGCMe2LQOPXvr0yVAkQTWXE4GraY2S+6pYnulxTbSLWLnLmZPFJLheCECbvjd60Mbfs4hRNpKR+R8Y4b0Ko8MiolhQwH9FLUtZq79C5BUTl33+E3kOnat0C3t+mkln2re5nHP2tfXwSmZLAYQ+AGdKIkqk2kK008rv+O2fI8S6C6ydC+Zv/5wtacxeoxS6EGon5xfoUI2zAleA5SGlbzYCFpRlTQ8tuSVNLTx0HNF22rQl/7epzPDvKsRWP5U/TIBaEknmxMuzZkFpj2YEX4CfqT7QP10gzkgRPjY+7VgNvG8K7XQXQoJAIN/OP+cDYdNJKhWAGNr6dfyjUN0NmA3cRKcfzbX24mqhi7Jr84zhF73FQcbc1NPeNCUtAytQTBmTTzZ4E+RHWqzYa7qEqVcy8o2bgPwy2Ry2Q5hcgJnJETuH5eZzUpLsFonguwf1N525IF+eyc4ebJ1OoEYnxL/UgGn4UwqM0elzXT1nHAsKhDRX/NyOQNMJ8hI8PP5VpJoVU++2s1OYeDl4ToSOGnMGSK1VkWYyo8cbAiO8B9d4G9COUkYhG3XkFpY17cy7LEStLhjv09NBn/+JeLa8JlQLcIp0KgHuPkA7D/RnA5KsBw1cFoSgkRz3fr3/rytnaMuwMM1NPLMFKbA0SUFh6K89CYbH13JIDw6GYd2mt6mlsmSb9Yt4QwaAWBCkjCEAMobzdQIyazO1ot30mIiYfcu6fLHn39vUwWNpnilqUty+EEiFsX6aa60LBVQlZzXtVR81QpKh31xVMdh426wVctlj7JMzB9VISXZjuawQEV/+MRDcZqbeQvTxnAz7In3wFhvCCAglnoc62FESjczgU2b5jinYV/rfs44kzHa9c79sHSDqylbtKdZ0CD19k6Xb6S6FjZrmF3HDRYytHwmEj
 apQ0NGnF
 g5bsd8ze1iOUnkCKuXB2LefdUz2O6m6iYsdW8xVzvP8TSQDtqKfwklUZxwD+MwdasRzhkjWznmrsi2SFdWApeAvtGAV+PYrbmPFJg0JTAeqZgiRh89JzPP7Ldfly1QnBiBdiXVBhuc+/MFjEOmQyZx6K0i4w/OXATqDfdRaQF5d38EdtKfsfmYX91aTYLlnC0rlUbPkdxexS9BGmdDZuWEZxLHEFqfEVI7EveOpK4ydHrYq2eljOrhvxA1ewePYD5I7ShVEH3RHK2Y6oMgQaOSqp8UHa7ob87MlTrrRwlYLQvGd1KfutUFuiHvz9rhIHWYgaawtxLapJv3QhA91gvq3emyqkO5hfHsjdvikKr4aU/CnHxWdTlx9EtM8EFaoUQWHFBW9z0r+KNzI+Cf6QXwgs73BRpCvQjieyd81LWiVP63sM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/18/2025 3:14 PM, David Hildenbrand wrote:
>> Before you read on, please take a moment to acknowledge that David
>> Hildenbrand asked for this, so I'm blaming mostly him 🙂
> 

Just curious If we can go by the suggestion of mm unstable check just
for the 6.12, as it is LTS.  I can't see this issue on branches earlier
to it. As well this patchset is not getting applied cleanly on 6.12.

> 🙂


