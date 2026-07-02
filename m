Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A5ADC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:25:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59EA06B00BE; Thu,  2 Jul 2026 20:25:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 550226B00C1; Thu,  2 Jul 2026 20:25:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 465C86B00C2; Thu,  2 Jul 2026 20:25:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 00D9B6B00BE
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:25:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7D5DA1C32B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 00:25:24 +0000 (UTC)
X-FDA: 84945571368.08.50CD129
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0B49C180006
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 00:25:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=oiopEJ92;
	spf=pass (imf16.hostedemail.com: domain of wenxiong@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=wenxiong@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783038322;
	b=ReTx0ykLh07oj5X6v6nRQyJ/sMdjQBYyk/AmMtqvrefWlSPrtPZvFT4TaArBre+/i8xtHJ
	4xWengJ0j1XuBpZumo07MRO4xyGk5C6h7QtfGGj7b1+1AErM52S0ablMPNZVGvPad+EN8Z
	fgwv63qzQfZETOmaPYXp91qJPsWT+XI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783038322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tWbKecO/Sdy/sI7WeY/MoFz9BeLH+k1o19XP5U9Ao1E=;
	b=4Oi3PB/QjJgfF9Qblwd91hL6zYIe13mYp7B8bAlxsSEsk/gfpv8Ru4fvqut2nH9OyT6oDQ
	fe92qWXgZW/alSMTgYZsb4/RBxVk0uLq/UNockHzrmjjk2rdt6o3yP+2satX+aV+A1tABG
	/pSk669Cjg1NfwKbQpMiJbHSEL5C+hQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=oiopEJ92;
	spf=pass (imf16.hostedemail.com: domain of wenxiong@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=wenxiong@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 662JICsb589782;
	Thu, 2 Jul 2026 22:05:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=tWbKec
	O/Sdy/sI7WeY/MoFz9BeLH+k1o19XP5U9Ao1E=; b=oiopEJ9261dd6ezDz1rQ7K
	Ni+OzhalrQU0pVw9BXzEzLwn4vfJxN+h/NgOaVzXmdjgc8sqpOZn3uxiaLmEtrV6
	6AtYKO18yYHOHPOOwumNQaGMt9X6D8opXhsWXAAynRy9r69Rf0LrFDDqXDUZKUIu
	vS/1D7xsq+n7bDT37xMV4LY9k3eR7mZhrON4J5BW+Kw4f8766oz0Bqs1tGLE81SB
	xV4gmVVvvpjpLE5b3T2bS2MUj9NzGZE4zMKZmErKsTX3ZYlgv7HzoUv4lbhdIBN+
	kQMWd47+TfGjqvmoT6nTv4KUi8gqaYfpjekL6hEheO72U6yHo8649LUA8Pz4LIHg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4f26pec9ry-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Jul 2026 22:05:01 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 662M10Hw011388;
	Thu, 2 Jul 2026 22:05:00 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4f2u2gnuby-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Jul 2026 22:05:00 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 662M506E18285150
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 Jul 2026 22:05:00 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE6F358059;
	Thu,  2 Jul 2026 22:04:59 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A7FF35804B;
	Thu,  2 Jul 2026 22:04:58 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  2 Jul 2026 22:04:58 +0000 (GMT)
MIME-Version: 1.0
Date: Thu, 02 Jul 2026 17:04:58 -0500
From: Wen Xiong <wenxiong@linux.ibm.com>
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Mike Rapoport <rppt@kernel.org>, Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Brian King
 <brking@us.ibm.com>,
        "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>,
        Matthew Wilcox
 <willy@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH 3/4] scsi: ipr: use kmalloc() to allocate IPR dump buffer
 memory
In-Reply-To: <05bd4fe1-fbf3-4849-96ca-930d04710903@linux.vnet.ibm.com>
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-3-494fb37ebe7b@kernel.org>
 <7c8f0e70-f49c-4614-af95-002fb2be11ba@suse.com>
 <akTjQVQQNdeO9M28@kernel.org>
 <d92f22b9-9a4d-42f2-ba67-0371f85fedd3@linux.vnet.ibm.com>
 <akYLdBME5kgyi8Rw@kernel.org>
 <05bd4fe1-fbf3-4849-96ca-930d04710903@linux.vnet.ibm.com>
Message-ID: <9eb64399ea51461aef8188ad5cffa9f9@linux.ibm.com>
X-Sender: wenxiong@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WNdsdVtpHIQyUudr2beV1suYvfyVA3dG
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAyMDIyOCBTYWx0ZWRfX+RpcbRKJNNKt
 gKCxLu/0D7fhBYJMfq+k83fcYk+RQ3QYSCYNPlPZ+IrAp5hRlxpF0lMThe3Y78J64erNp/LJ//4
 Dfv8564Ny7Mw7Bl3kIOWXZTBEq3DT/4=
X-Authority-Analysis: v=2.4 cv=edsNubEH c=1 sm=1 tr=0 ts=6a46e08d cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=0BNHoLoJkjV9DPgUaycA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAyMDIyOCBTYWx0ZWRfX6h63RbjHUs3+
 MMUd05bqiMu+CN476WSuC/OLph4RaPyVeCdvvN4srqQlRD1hphwJX3x+ZoXVfcapV2Tzfd/EQVW
 4C7WinzeaKNLAawkl4juNjFqfIxLwsZQxynt1WyPiQDvgJmpV4D97+3Ug4UxZmRj18xTQFqQim4
 qt37nGpoyeogka72yyjg/ed/r4W0+QJSTglMBQFctSrYZtPB7AAi1ZUgwn6yILW+pbI1n673RGO
 u+LsCf8JEiOhenAcXw0dlabGcQi0ce1jdHOSW7jOciHNSJkiisHv1xvrHy2f74DxXFlrMRFPtpf
 ZBzJuSE7X2aOqjKFInpARPpzZbo3n4EE57OUsQl6f1qMYMq7rOqAeBO+JzRdRJaxdHWfP77e5ea
 JU+vjqJ1MW9jAXvlpi1UPnK8uf9E+QL/hIRByW36d8FsGMDeuWMVSIVSnrzxrblf90X7UqrczR2
 Lc/+riA3tTf82F4xf3A==
X-Proofpoint-ORIG-GUID: WNdsdVtpHIQyUudr2beV1suYvfyVA3dG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-02_03,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 adultscore=0 impostorscore=0 bulkscore=0
 spamscore=0 suspectscore=0 clxscore=1011 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607020228
X-Rspamd-Queue-Id: 0B49C180006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: usygy3t4hccdt7uyhdfgu9ggnpouu16y
X-HE-Tag: 1783038321-877696
X-HE-Meta: U2FsdGVkX19PVyxgPqIv3/PpYOJHts3lgKsa3AZCJoPm5azvMeC69J02+AV+o0bvJkidQOM8yYGFse36yeCqdvJddutg0afmszM4aC7ZP+ZPMhhtGjtt95GdXKEISwD0YrrfWmKn115YoJzR5kd+RhOJ602Dwu2HDzHQywxQDQ/QYDHQCv+n+ENPdMrh5i1Lxb46R/dzU3ccvyarNzoPBP1o+VSi1o8dlRwtyVIQ/Hblqddh73ppkJW2X/+8WjzzSxJqaWm5vLOSxBngZxT44OJX82rzzeuyvzqjFArb3/jht/QPkgM/tQzi95Qb+QFsq3xWnZS0yVQlSR4jlxPAPwyLMDtX68Qq8z42kW3HFvs25wSVeifa0RhMtl6zZaxT6VV/ZN08R7jH3ZUEjrblTq1lb2c9Z/7IWFLu5kSigsJgrXSSnmMVoZXPJ1WVd/f40Z9Qq10WByOEeutfGXuedriu1/zknJLtjESOYH1VlXNBenfjAC7LJfhsLxZxWiUrS3tCmwvN/QX+gaobJiTCsTZecH/tiSNtV7xzNkSVo7Dyqp9z+IirhbkU2lXpIQqz78/IXdw/G7baDo0EDOQetueBguojcnUEiskSTbV3fvhr/XBsiB+xJ+h+aGx6igQECB3lHLNq2FA6QtEBQhbZq1Z2ie6O+PB6C7F1y+36qxiu0msUBCDxHA58hbLHusbDe8Te2VKqz/SKB3Aaa7fz+VhWTAF3vZyp9k+iWE7uQwhVbFYVXpDIreXixs4fU3cG9E1CifDiRbIDFvCnKzzByKiqTJPxxfyMqw/qKFdd3xdlD2unQJ1ZMw9ufcGs7yvjtgQMnu/J41if/HGyMhpxawRzg0uLiJiji2l3QXKqzqmHWXyYRtE3bYYZUG9z+tjA8UvS9svW0KCrb2Fa2vW6OF4O74p8rW9S2NwHfS94/TTw5LFO5WlafcHh3E1LqQ/J72W5eksCAOkz6jAyFVd
 6iWDHPnX
 hfULOzJGkULQeKvvsIhxOsoPH1HRdmYiHcXxi87HM+Ba+DXuETkIyzeY4/iCkWbmfVn3wZemcq6PD85dLxOBeGzj3/U9rGvy2NK9QSRalHplGrLKQpVgts97RAG5FOTpiKtWLyu5XVCD9kOeMdfU+ZKxXN65DQOQYpYOQaE7f56C7i49HXOEnb/vHBPuqJPjjceRwYGw8U1E9xJ6KopReMyEGbrPNsTH6dFcCq4v6KEe+yxyluMdkISzqEuzBm10Ia4l9gpzdmxO2MZv7anTZaeE2x4L5kpmwUfqXUshfPmwOpVELmkPauog3/s7Au4BrMFgZEndZqskMR2rB0rWNGkJdpstzwWus7ZRqObGWv1DJMEECkj4kbHw2BZm0Lj+A/fvs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-02 14:56, Brian King wrote:
> On 7/2/26 1:55 AM, Mike Rapoport wrote:
>> On Wed, Jul 01, 2026 at 04:03:48PM -0500, Brian King wrote:
>>> On 7/1/26 4:52 AM, Mike Rapoport wrote:
>>>> On Wed, Jul 01, 2026 at 09:03:06AM +0200, Hannes Reinecke wrote:
>>>>> On 6/30/26 12:54 PM, Mike Rapoport (Microsoft) wrote:
>>>>>> IPR dump machinery allocates memory to save adapter's crash dump 
>>>>>> using
>>>>>> __get_free_page().
>>>>>> 
>>>>>> This memory can be allocated with kmalloc() as there's nothing 
>>>>>> special
>>>>>> about it to go directly to the page allocator.
>>>>>> 
>>>>>> kmalloc() provides a better API that does not require ugly casts 
>>>>>> and
>>>>>> kfree() does not need to know the size of the freed object.
>>>>>> 
>>>>>> Replace use of __get_free_page() with kmalloc().
>>>>>> 
>>>>>> Link: 
>>>>>> https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
>>>>>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>>>>> ---
>>>>>>   drivers/scsi/ipr.c | 4 ++--
>>>>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>> 
>>>>>> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
>>>>>> index d207e5e81afe..5a212bfdeec2 100644
>>>>>> --- a/drivers/scsi/ipr.c
>>>>>> +++ b/drivers/scsi/ipr.c
>>>>>> @@ -2893,7 +2893,7 @@ static int ipr_sdt_copy(struct ipr_ioa_cfg 
>>>>>> *ioa_cfg,
>>>>>>   	       (ioa_dump->hdr.len + bytes_copied) < max_dump_size) {
>>>>>>   		if (ioa_dump->page_offset >= PAGE_SIZE ||
>>>>>>   		    ioa_dump->page_offset == 0) {
>>>>>> -			page = (__be32 *)__get_free_page(GFP_ATOMIC);
>>>>>> +			page = kmalloc(PAGE_SIZE, GFP_ATOMIC);
>>>>>>   			if (!page) {
>>>>>>   				ipr_trace;
>>>>>> @@ -3226,7 +3226,7 @@ static void ipr_release_dump(struct kref 
>>>>>> *kref)
>>>>>>   	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
>>>>>>   	for (i = 0; i < dump->ioa_dump.next_page_index; i++)
>>>>>> -		free_page((unsigned long) dump->ioa_dump.ioa_data[i]);
>>>>>> +		kfree(dump->ioa_dump.ioa_data[i]);
>>>>>>   	vfree(dump->ioa_dump.ioa_data);
>>>>>>   	kfree(dump);
>>>>>> 
>>>>> 
>>>>> I _think_ we can replace this with kvmalloc, and allocate the 
>>>>> entire
>>>>> dump buffer in one go. Once switched to kmalloc() it's kinda 
>>>>> pointless
>>>>> to allocate separate page-sized buffers here.
>>>> 
>>>> kmalloc() performance is on par with __get_free_page(), but 
>>>> kvmalloc()
>>>> would be slower if it falls back to vmalloc().
>>>> 
>>>> I'm not familiar with the driver to say if this could be an issue 
>>>> here.
>>> 
>>> This code only runs when the adapter has hit a fatal error, so should 
>>> be
>>> extremely rare. The memory is getting allocated while the storage 
>>> adapter
>>> is in a failed state, so anything running on the system at the time 
>>> could
>>> be stalled until recovery is completed. This memory is allocated and 
>>> should
>>> be freed soon after the adapter recovers. In order for this code to
>>> run, the iprdump daemon must be running, which will then read out the 
>>> dump
>>> after the adapter is recovered, and write it to disk, after which 
>>> time, the
>>> ipr driver will free the kernel memory.
>> 
>> Thanks for the explanation!
>> 
>> So the allocation is not on the hot path and it seems to me that
>> performance differences between kmalloc() and slower vmalloc() won't 
>> move a
>> needle relatively to the entire dump procedure.
>> 
>> And it seems that GFP_ATOMIC here is a historical artifact rather than
>> actual necessity. ipr_get_ioa_dump() runs in a workqueue context 
>> without
>> locks held so nothing warrants GFP_ATOMIC.
> 
> Agree that GFP_ATOMIC is not needed here, but we probably do need
> GFP_NOIO since we don't want these allocations starting I/O as the
> storage adapter is not in a state where it can handle I/O until
> the card is reset.
> 
> Thanks,
> 
> Brian

iprdump works with both of GFP_ATOMIC and GFP_NOIO.

Tested-by: Wen Xiong <wenxiong@linux.ibm.com>

