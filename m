Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 610C2FED3E5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 15:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE8866B008C; Fri, 24 Apr 2026 11:46:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A98FE6B0092; Fri, 24 Apr 2026 11:46:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 961A46B0093; Fri, 24 Apr 2026 11:46:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7A92D6B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:46:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1249A16020D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:46:25 +0000 (UTC)
X-FDA: 84693876330.19.B96EAF5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8F798180011
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:46:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=C2vStNEy;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf16.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777045582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IW12QXeUqQ4iO1J+QKHYo8CdHi0vnQi7orvQmQSOuws=;
	b=Mc32FbS4oup7EPvIO4ZAOryQRGCjf6FOLAGB6W+i1TdrPas0v6F6ft0/Id4IBbiMH7BCkQ
	s2EYDtP5RnIGFugl2p5OzJbMnKe8MHlrMgYYz1scEhNwa7qbXmzeG42XwhwiEAE4/MbBII
	HAeCJRV6eosFk4FU7ZCfCNCENN7dFdE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=C2vStNEy;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf16.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777045582; a=rsa-sha256;
	cv=none;
	b=3rYB4GGcHJv8W/P5KnA65Dafz+xw0O/Ri3bNS8L8YoLxGjhJRD1uqTjSCcWjDqW1moh5is
	SOXIpFQcauBMfs9gC9L/wu1TCJY45uvWtiUDk4kW5+JoibGEHR6srXYzNBdtsbQ/+rsqJX
	eclZuIj5tU7Mt5Z6S1r3+vyCjS738rY=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63OD0C2C3107427;
	Fri, 24 Apr 2026 15:40:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=IW12QXeUqQ4iO1J+QKHYo8CdHi0vnQ
	i7orvQmQSOuws=; b=C2vStNEyOJp+0XQWEvZM/yEq0LF9pYttrnhIZFlHk3Hn13
	D+Y0F+LihyJJiqdx4I7oyIj+QswE6cN2HMxyZR5teBZcvY/FwjROze0HhReZ/H/+
	JqZHvr/COrm3yv42oCN8QivW1JvPdBDngxufu+IfOHJdTivmLjmsHtZ0LVhmKRy7
	4ndJ841PPCGSnXN+MrRKr193YtkwsjF+s2MYWLyy9/QI+VolxOxfZJsTeUUaglOq
	7ZYuEc65ceXaLZvAvAH1+BlaHNwaQN+MoX5wy5h2DEeZ2isIaJXqXygeXCOc5BKI
	WQCzq0xLcfdLDauqBinWwafm0heWlMN/F1VUqDRw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dpeu6nqj2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Apr 2026 15:40:50 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63OFZYfx023755;
	Fri, 24 Apr 2026 15:40:49 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dpjkyucsy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Apr 2026 15:40:49 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63OFen3919333672
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Apr 2026 15:40:49 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B36758059;
	Fri, 24 Apr 2026 15:40:49 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BAF3A58058;
	Fri, 24 Apr 2026 15:40:37 +0000 (GMT)
Received: from [9.39.16.100] (unknown [9.39.16.100])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 24 Apr 2026 15:40:37 +0000 (GMT)
Content-Type: multipart/alternative;
 boundary="------------iDt0VyGXNTH8qQdgDii6cZmx"
Message-ID: <e49b4d8f-258a-43d5-af2c-9f4e94683ca5@linux.ibm.com>
Date: Fri, 24 Apr 2026 21:10:33 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 3/5] mm: Hot page tracking and promotion - pghot
To: Gregory Price <gourry@gourry.net>
Cc: Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jonathan.Cameron@huawei.com, dave.hansen@intel.com,
        mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
        raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
        sj@kernel.org, weixugc@google.com, willy@infradead.org,
        ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
        nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
        akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
        kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
        balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com
References: <20260323095104.238982-1-bharata@amd.com>
 <20260323095104.238982-4-bharata@amd.com>
 <250e68f3-3664-4148-bfbf-52fd4230a3b9@linux.ibm.com>
 <aetuZQFtb2dR50cv@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <aetuZQFtb2dR50cv@gourry-fedora-PF4VCD3F>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI0MDE0OCBTYWx0ZWRfX0T2LJZVrFyhk
 GAtioFUHC99VtlpzQzTb7aXi/CE87+tQ+uLKed9DLacAjjheqP6vPzc7cLslDqSz6KcBT9zbWxg
 D69jBexnyGQFibhI0gZ//Sac0wmY5Qv7i9AbEcRg/XNvsZuI6lFwzbcOHV0PkuSkeOf0YfMClST
 BpOiitGieMTc12lk/n5f4Ck8olRoe8dIjrXYW7kh8C/SkiWkhmxSIlNqMkGAvWIboI/9pt/1umM
 TD2hMwxhf6I2nRglyJ0qrB7BOnBteY4onfkW7ZJZTw0Pk57vn7R4FIu/lT1eMlGjTBBjr5dBhVU
 7UYD5iZlIorpbS7Z01Wx09qkmTgvNp25KJLTe7/euqiM9+G2z+9ngM3B1vAx57v8IiaXKwccapr
 7Zfhu2vm+dptqqhDFIjWnJWsNsa/R6pAYkWkmGU4SL8SFIa07aYfm9fdJiEZcP4Mn/7ZwGg0fXI
 asqcb5GSReg32GTBhYA==
X-Proofpoint-ORIG-GUID: MFx-T4WMH2TThU6Cjy4qxB82CDmxUzZZ
X-Proofpoint-GUID: DTDaDZ9NOgZ07Ca7O6yNdl7mUvqVrbsX
X-Authority-Analysis: v=2.4 cv=BYfoFLt2 c=1 sm=1 tr=0 ts=69eb8f03 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=r77TgQKjGQsHNAKrUKIA:9 a=iHGnLHXJbTmuMlrBtBQA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=CCbayXq0WYSliTnpkgIA:9
 a=u0vl1od8qqjih4ZH:21 a=_W_S_7VecoQA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-24_01,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 clxscore=1015 bulkscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604240148
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8F798180011
X-Stat-Signature: y8wd4rg4q1ces7tr5h3jdp15pzpxo15w
X-HE-Tag: 1777045582-634352
X-HE-Meta: U2FsdGVkX1/zYh21LCKBR/nfbBBikadCY+nTfiR061GJBOZ+IEUydptVCVOGlPHsIWaPgMR4v8RA5rEi81lSMGbrF7Vv86peYy7tgf5IPX3bAt1u8pXs6nV2dZh93dXVvvum7+jw/a0Fd5xG+YwvZD3SSCdHjGCbS23gPtx/OOF+Q5AvOqlrTT73k3vqLpJtJ+JtvNBw/3MUneCF1bh5lndvxHYlk3iH4jVq3YmaH3KtjAxNSY8Gyzct15ErstB/F3IWm8YBZzjSisWlO1o+GjmRZr+qVpE28chxe8LpFO8OMCygvzYfLjvYYQEvI0dnA4jM4ZL1GeE5fnMsaLN0n9iJ37snRg+Ww+Z4Csw1aK8zbhbhkmR+6bgD6IigEuqJzcACx69C+xlBOJ3WFI2uX0gs5MSwYlOTQgcK/041jAjlh5CWmT5vHdYIJ6Xx5bjZ4UW/9aaXawlJh3fv2OAFnLUoz7n808ANGyp8ZC2VXSGjEA23V+D/qwL6wpi55vGs8MNeDJMSXfPTZXjHv1nMbRFKwvhMfrRBWBMJeqY3TaO9VyWqDeS7/MLRfnjPu3m90XmIBmDsd8PxTLiQtky5OUSRWACusdzEo6DrgtdINJEp+2uxP+cEy2sJrU0OVpVbT3WKv1LVsWc2hWdCZPT4DEL+w2F+eGhvkSqAr7B2wSYDX+9UqbYR+HQD3qZPkrUO0lrczAdEYn0/Vygp5K38cbx/LnP8rBM6aG//GFTOUQQWcVhkT5f198nYklgj97g84KZFVr6evQq0DkGzvawwp2MN4vCncPgQwH11LsDWdpNWebgO8S5C+8+t1vitvOT3SvmrcIE8R2CHniiH4dgFWAJP1r5NMtQ0zwaycm1GAKnEpFN3DdV79uhDwjhTOMom79ii3mP5vnboz1FhMPIHQJ2/qgwOuvKFPcSXYohfJCWnVSnaDQpdfrrfdo4ExahoJh6CcUWviFd0lB0GHGu
 nfm3y7KD
 Xzs/N2oTawuz8/J1Eo4p8wNUFjq74k326LsIfSL1g8xAe+UI8otMxomfu/W19bfwfh9giDxwUbFiILyZFkpKoB1htkeECc1YATmWIJJSXLVCzfXvZuSUpWvTfTo8H23xlhDae88dEE4cJcv7q7maUkjxtYoNRh9SY0sUffGFuYfQnXr3mYy4799kX727hpI6ggGxpB3pFR7bKxrrKFEMsvVUD2Nit1Gt+XJyqhMb497OgxtnzL5Zj6zAIxSQT1aR6zQlXATFokhSt8fN9lIji7ehFySC56sSjZ9vTVJntAP8j9s3O4Mpndb72DTjy059dpJ7+OC0jv94+Ef7N8k6Nq4ZcUCM0PRZQmg5ixp21dx6i/nNqJIDUa255yUmTVSog5Xiz7R0j70EaayYJQqXd/rFPDZgDDE5MBpBNJlB3rYlPc6L6zLfiNNBtCfvMNhX9NIFt8Q3WExGjdttLFwSMCGGDJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------iDt0VyGXNTH8qQdgDii6cZmx
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Gregory

On 4/24/26 6:51 PM, Gregory Price wrote:
> On Fri, Apr 24, 2026 at 06:27:02PM +0530, Donet Tom wrote:
>>> +
>>> +	/*
>>> +	 * Record only accesses from lower tiers.
>>> +	 */
>>> +	if (node_is_toptier(pfn_to_nid(pfn)))
>>> +		return 0;
>>
>> Just a thought—could we check this at the beginning of the function, before
>> the switch case?
>>
>>
> Can you please trim responses to omit un-related code? Not all of us use
> mail clients that auto-collapse quoted regions and it takes a lot of
> scrolling to reach here n_n;;;


Apologies for that, and thanks for pointing it out. I’ll keep the 
responses concise and include only the relevant parts going forward.

>
>>> +static void kmigrated_do_work(pg_data_t *pgdat)
>>> +{
>>> +	unsigned long section_nr, s_begin, start_pfn;
>>> +	struct mem_section *ms;
>>> +	int nid;
>>> +
>>> +	clear_bit(PGDAT_KMIGRATED_ACTIVATE, &pgdat->flags);
>>> +	s_begin = next_present_section_nr(-1);
>>> +	for_each_present_section_nr(s_begin, section_nr) {
>>> +		start_pfn = section_nr_to_pfn(section_nr);
>>
>> I may be missing something, but in pghot_setup_hot_map() and
>> kmigrated_do_work() we seem to iterate over all memory sections. On large
>> memory systems, could this become a bottleneck right?
>>
> I think this is going to end up being a function of page / section size.
>
> I would hesitate to over-optimize on this early-on, otherwise we'll find

Sure.

> ourselves re-building a bunch of DAMON functionality that chunks memory
> into regions and such.
>
> But it is a concern.
>
>> Since hot_map is allocated only for lower-tier memory and the hotness
>> information is primarily used there, would it make sense to skip scanning
>> higher-tier sections?
>>
>> for_each_online_node(nid) {
>>          if (node_is_toptier(nid))
>>              continue;
>>
>>          start_pfn = node_start_pfn(nid);
>>          end_pfn = node_end_pfn(nid);
>>
>>          s_begin = pfn_to_section_nr(start_pfn);
>>          for_each_present_section_nr(s_begin, section_nr) {
>>      }
>> }
>>
>> Would this approach be reasonable, or am I overlooking something?
>>
> re: your note later on - kmigrated doesn't run for top tier nodes
>
> kmigrated_run() { if (node_is_toptier(nid)) return 0; }
>
>>> +
>>> +static int kmigrated_run(int nid)
>>> +{
>>> +	pg_data_t *pgdat = NODE_DATA(nid);
>>> +	int ret;
>>> +
>>> +	if (node_is_toptier(nid))
>>> +		return 0;
>> I might be missing something, but since this function is only called from
>> pghot_init(), would it make sense to check the condition before calling
>> kmigrated_run() to avoid the function call overhead?
>>
> this gets optimized out when static is inlined and optimized.
>
Thanks, Gregory.

I might be missing something, but since kmigrated_run() is not marked 
inline (static int kmigrated_run()), will it still be optimized or 
inlined by the compiler without the inline keyword?- Donet


>
> ~Gregory
>
--------------iDt0VyGXNTH8qQdgDii6cZmx
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><font face="monospace">Hi Gregory</font></p>
    <div class="moz-cite-prefix">On 4/24/26 6:51 PM, Gregory Price
      wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:aetuZQFtb2dR50cv@gourry-fedora-PF4VCD3F">
      <pre wrap="" class="moz-quote-pre">On Fri, Apr 24, 2026 at 06:27:02PM +0530, Donet Tom wrote:
</pre>
      <blockquote type="cite">
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">+
+	/*
+	 * Record only accesses from lower tiers.
+	 */
+	if (node_is_toptier(pfn_to_nid(pfn)))
+		return 0;
</pre>
        </blockquote>
        <pre wrap="" class="moz-quote-pre">

Just a thought—could we check this at the beginning of the function, before
the switch case?


</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Can you please trim responses to omit un-related code? Not all of us use
mail clients that auto-collapse quoted regions and it takes a lot of
scrolling to reach here n_n;;;</pre>
    </blockquote>
    <p><font face="monospace"><br>
        Apologies for that, and thanks for pointing it out. I’ll keep
        the responses concise and include only the relevant parts going
        forward.</font></p>
    <blockquote type="cite"
      cite="mid:aetuZQFtb2dR50cv@gourry-fedora-PF4VCD3F">
      <pre wrap="" class="moz-quote-pre">

</pre>
      <blockquote type="cite">
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">+static void kmigrated_do_work(pg_data_t *pgdat)
+{
+	unsigned long section_nr, s_begin, start_pfn;
+	struct mem_section *ms;
+	int nid;
+
+	clear_bit(PGDAT_KMIGRATED_ACTIVATE, &amp;pgdat-&gt;flags);
+	s_begin = next_present_section_nr(-1);
+	for_each_present_section_nr(s_begin, section_nr) {
+		start_pfn = section_nr_to_pfn(section_nr);
</pre>
        </blockquote>
        <pre wrap="" class="moz-quote-pre">

I may be missing something, but in pghot_setup_hot_map() and
kmigrated_do_work() we seem to iterate over all memory sections. On large
memory systems, could this become a bottleneck right?

</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
I think this is going to end up being a function of page / section size.

I would hesitate to over-optimize on this early-on, otherwise we'll find</pre>
    </blockquote>
    <p><font face="monospace">Sure.</font></p>
    <blockquote type="cite"
      cite="mid:aetuZQFtb2dR50cv@gourry-fedora-PF4VCD3F">
      <pre wrap="" class="moz-quote-pre">
ourselves re-building a bunch of DAMON functionality that chunks memory
into regions and such.

But it is a concern.

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">
Since hot_map is allocated only for lower-tier memory and the hotness
information is primarily used there, would it make sense to skip scanning
higher-tier sections?

for_each_online_node(nid) {
        if (node_is_toptier(nid))
            continue;

        start_pfn = node_start_pfn(nid);
        end_pfn = node_end_pfn(nid);

        s_begin = pfn_to_section_nr(start_pfn);
        for_each_present_section_nr(s_begin, section_nr) {
    }
}

Would this approach be reasonable, or am I overlooking something?

</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
re: your note later on - kmigrated doesn't run for top tier nodes

kmigrated_run() { if (node_is_toptier(nid)) return 0; }

</pre>
      <blockquote type="cite">
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">+
+static int kmigrated_run(int nid)
+{
+	pg_data_t *pgdat = NODE_DATA(nid);
+	int ret;
+
+	if (node_is_toptier(nid))
+		return 0;
</pre>
        </blockquote>
        <pre wrap="" class="moz-quote-pre">
I might be missing something, but since this function is only called from
pghot_init(), would it make sense to check the condition before calling
kmigrated_run() to avoid the function call overhead?

</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
this gets optimized out when static is inlined and optimized. 

</pre>
    </blockquote>
    <p><font face="monospace">Thanks, Gregory.<br>
        <br>
        I might be missing something, but since kmigrated_run() is not
        marked inline (static int kmigrated_run()), will it still be
        optimized or inlined by the compiler without the inline keyword?</font><span
      style="white-space: pre-wrap">

<font face="monospace">- Donet</font></span></p>
    <p><br>
    </p>
    <blockquote type="cite"
      cite="mid:aetuZQFtb2dR50cv@gourry-fedora-PF4VCD3F">
      <pre wrap="" class="moz-quote-pre">

~Gregory

</pre>
    </blockquote>
  </body>
</html>

--------------iDt0VyGXNTH8qQdgDii6cZmx--


