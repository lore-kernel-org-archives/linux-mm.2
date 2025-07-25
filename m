Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32885C87FCC
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 03:15:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0C776B0095; Thu, 24 Jul 2025 23:15:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE4706B0096; Thu, 24 Jul 2025 23:15:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FA3D6B0098; Thu, 24 Jul 2025 23:15:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 90A4E6B0095
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:15:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4B0A88059D
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 03:15:44 +0000 (UTC)
X-FDA: 83701322208.20.4C329B8
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf15.hostedemail.com (Postfix) with ESMTP id CF361A0007
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 03:15:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=hzDYvTiA;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf15.hostedemail.com: domain of maddy@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=maddy@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753413342; a=rsa-sha256;
	cv=none;
	b=Ju149flB0i2w/2eie3SGQ4xYJQnaOvi2tfm/KlaTOk6l+PyNtqgYuiQ8NMGksUS0EgRIgJ
	1cf9k7n7Vcb7ZDoTULanzd6HRvSNxIL2a+6BSsy/EpPQVXXTjUB5rbbju9g994T3nFYuUo
	p7DHSnUpxW6Liy7QaMKrpU+5J+m5EeI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=hzDYvTiA;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf15.hostedemail.com: domain of maddy@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=maddy@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753413342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XML+wVDDRUmvGG8qWEzvXc05uJKnipeZiRtxzBQTwjg=;
	b=oH0+2eJxZPU8xPz425Oma1xw/46ePYw6BL7/fdGfpG3qEO+iju1O4Z8TwUoT2/EDgnUAze
	y8s6rQMWKdn0anBTBgpYPlYewNoSfsk7tmqBfxqbJFzeg6Ao0vtd7QcNL9J6x34C2Zhs/x
	NsP7/HTJnL9i3AcBa7BiNLbrct5aCqU=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OM9jXU004457;
	Fri, 25 Jul 2025 03:15:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=XML+wV
	DDRUmvGG8qWEzvXc05uJKnipeZiRtxzBQTwjg=; b=hzDYvTiAKOMUcOX1zyQAHZ
	kuZqt+R66M/2QICVFKkr24WWyFQ6MxARpTmtyERZSQVj1zUYzT6ig+GXXVgExB0B
	tPiBMeDShbpDE2tFxncG4RK/j5hgz3YSFJT0N1FZF8xirTuI96kQfd3KgpGZwpek
	Ns58uBvq/u5kTXTnqn4vfkUvhIS39sqd8uJBHX1dit3YE4bahVegrclRGWCbGKsj
	TYQU4NvC0u9pYbytRpQqqss5HSaYlpvHD/SfMROL7VVgbsOqZuQokSv3AktN1V5r
	kQngqY3R5xarLpVj/LHSTS6iQCJN8vIhdhMui+fvcYvV3droHiKgfxKh368zrw7g
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 483wcjrrre-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 25 Jul 2025 03:15:20 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56OMvWlu005253;
	Fri, 25 Jul 2025 03:15:19 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 480u8g6ud0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 25 Jul 2025 03:15:19 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56P3FIjD24445492
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 03:15:18 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BB7355804E;
	Fri, 25 Jul 2025 03:15:18 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C84AB5803F;
	Fri, 25 Jul 2025 03:15:15 +0000 (GMT)
Received: from [9.204.206.224] (unknown [9.204.206.224])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 25 Jul 2025 03:15:15 +0000 (GMT)
Message-ID: <8306ebfd-0836-4ed6-bd2d-0a8039f6a8c6@linux.ibm.com>
Date: Fri, 25 Jul 2025 08:45:02 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] powerpc/thp: tracing: Hide hugepage events under
 CONFIG_PPC_BOOK3S_64
To: Steven Rostedt <rostedt@goodmis.org>, LKML
 <linux-kernel@vger.kernel.org>,
        Linux trace kernel <linux-trace-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>
References: <20250612101259.0ad43e48@batman.local.home>
 <20250724092847.1aa83756@batman.local.home>
Content-Language: en-US
From: Madhavan Srinivasan <maddy@linux.ibm.com>
In-Reply-To: <20250724092847.1aa83756@batman.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xIeP2VPgqZ_7tUbLAhcZoj2tFQPExAmH
X-Proofpoint-ORIG-GUID: xIeP2VPgqZ_7tUbLAhcZoj2tFQPExAmH
X-Authority-Analysis: v=2.4 cv=QOloRhLL c=1 sm=1 tr=0 ts=6882f6c8 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8
 a=-C49POrsBXEG1DwCQcYA:9 a=QEXdDO2ut3YA:10 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDAyNCBTYWx0ZWRfX4txqFrmfvDry
 eeLijhpzzVPIK+Xxy9JnO3plf4ZmR7y/qVKpArEuapN3I/GF2FDDz9rD02EO/ZAlX56pZ2wW4tw
 cAcJbT3SFfG/++B/6J+kuaxV8AHSa0SnDTURgNW/utU/1OVlMsG9AMcmflg7YuPB8Q/zIE5Iyvl
 50/U4qTyZUpVTZiCjPS2tTMaQPeBBNpPBVz3aUSCTPZA2yTpIpVUrjgMyuAyR00Cr0UYn/OVfPE
 K5vxa9/zfH/JOF/mLoU+tI3uunYzSWR6fhKf0BCIdtoL0BA2d6cmYuLWCzdqyiK/oA7t6utOUDH
 Pxrh/c31yz4PlhU1aLvcnhh5KI+eaC1yHKRow6RBAIMSqgQ/y5Y40+xVRo1Z1cqQ5ma9modXpT8
 KChxayUReuPrbUaztK9FJ7EGGZje1MGm+S8hS+GYL6ij6eAzs4eOs2irdHf47GeTSH2mSQi/
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_01,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxlogscore=581 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxscore=0 impostorscore=0 clxscore=1011 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 phishscore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2507250024
X-Rspamd-Queue-Id: CF361A0007
X-Stat-Signature: id4ozf753kmjwq8ei7ffgupgiz7uehbm
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753413341-530769
X-HE-Meta: U2FsdGVkX19+tSlaDAHRaITu0WbirDYDMInlUowTfgkyhGirubVchMFyQIsYI52SLHGLZaR32ssUOrXIdAHS+XbUdPFrNimTaha5OZznnMTtreVwTr8r+YTzTpkrCe2XHlJBkJ1pub9gjqSdte/ub3YkhYJX/IF5b06TXrZXaF7L8MFwqN6G3GH+o1eC8ZVtVR7SO4Of6Cp5k1SxMy+ZCcDCoBonfj1ddHsMSQx10WZYHcmR91vu8zMpqARsJ6Senpw0Z9GLbd66IxPCP9XJ+S18OxbfvJC5c3MyYUSvj2S0g1HtjuIRD+H8KMdw5Zn84k+bxNk8rbAyM7++lEC8WkFefW/0HgM9F47iFOOMSD1AHOCirZp9F9rHP0iJqh2ev4enguQmeNQzhpjXVNzp0242rWodHJHXffvQon/hK5E80+aoYoN/T/WpcsXEm/liUxLHqbx2hrA2kZFW+uBezoya3fBtBGiGCyPEIpXrs7RSbNsHnm6l6+OmoJCWHtlxOMEN0/BgcMlY17szQ+lFE2eWXe/y0kSszYU/DuFGnrzqUbz1aW8qcl2Xl3bAzlSAu+FCsim1YtdYkwJIz4Ul9HzMyX7dupb3a49W9z0rqpWmQMH54d+Kt3S05tiF3suvajBcMI9KmOpSfVA+XHEBOvy0J4CPjnU7vahobOGl8JtXHo8keFB8yerxNIpfw73y3Jh5/cobUQh0b19R4+Y0ZyJ75b6cvVcSnkRwEIpPgxF2JKrqV/NToiDQDljmo7fseXauba4hK+M3PDDawOiY+On4gjoLm0LEgrBixD+eUX9+i9GPtc47PuiikjAqpnLcHzXHcqLiKGMTFA1ph7zN7OQaZLWmXu84df3+uBrX025RDn1jh/Q3xBiPrmJSwZWyn7AmXb6tmqW9yxKrBiaFrf1Q8Yc9yhLhmzpLFpJO9qli6mQyxSnj7ehc0Z4BfOcuaj0yC67YccCcxMuShwY
 vvktUaPR
 NBVyFto5Sq/yjaqXK2ghnUNfcdXffntQ4qFAtZGAG1id3+vROsu6yd5uXUCJCh6IObcoXazksOp0/ZjXi79ONsO7QK/IPO5K8k2lZMgcMDXOPFc0TiV+vE5lRKovjdw/3cHtM56QI4fdmfb1KvqV2qpefTPhOl8bmf1UprRpuOZ0W3KDCw/05KEJqBjaLxqy+b+rCyHXW1pVpZTORi2lkffq7/UndAULRTfpjLcatkcfiupQapYhHpV38pWHEj2n4NIEK8mFZNGJj8ge4MbmBwRozaLLrxZtYGjEySgb/sQ2h6JouRCQr5SfZmCmUl7EDKjjQD5elzwdyJednxKeSR4WPWqkwPbrmofO8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/24/25 6:58 PM, Steven Rostedt wrote:
> 
> Anyone have any issues with this patch? Should I take it in my tree?
> 
> -- Steve
> 
> 

Acked-by: Madhavan Srinivasan <maddy@linux.ibm.com>

Yes, kindly take it via your tree 

Thanks
Maddy

> On Thu, 12 Jun 2025 10:12:59 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> From: Steven Rostedt <rostedt@goodmis.org>
>>
>> The events hugepage_set_pmd, hugepage_set_pud, hugepage_update_pmd and
>> hugepage_update_pud are only called when CONFIG_PPC_BOOK3S_64 is defined.
>> As each event can take up to 5K regardless if they are used or not, it's
>> best not to define them when they are not used. Add #ifdef around these
>> events when they are not used.
>>
>> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
>> ---
>> Note, I will be adding code soon that will make unused events cause a warning.
>>
>>  include/trace/events/thp.h | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/include/trace/events/thp.h b/include/trace/events/thp.h
>> index f50048af5fcc..c8fe879d5828 100644
>> --- a/include/trace/events/thp.h
>> +++ b/include/trace/events/thp.h
>> @@ -8,6 +8,7 @@
>>  #include <linux/types.h>
>>  #include <linux/tracepoint.h>
>>  
>> +#ifdef CONFIG_PPC_BOOK3S_64
>>  DECLARE_EVENT_CLASS(hugepage_set,
>>  
>>  	    TP_PROTO(unsigned long addr, unsigned long pte),
>> @@ -66,6 +67,7 @@ DEFINE_EVENT(hugepage_update, hugepage_update_pud,
>>  	    TP_PROTO(unsigned long addr, unsigned long pud, unsigned long clr, unsigned long set),
>>  	    TP_ARGS(addr, pud, clr, set)
> 
>>  );
>> +#endif /* CONFIG_PPC_BOOK3S_64 */
>>  
>>  DECLARE_EVENT_CLASS(migration_pmd,
>>  
> 


