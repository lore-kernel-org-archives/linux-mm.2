Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84075C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 13:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6E36B00ED; Mon, 27 Jul 2026 09:16:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77D2B6B00EF; Mon, 27 Jul 2026 09:16:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66B996B00F1; Mon, 27 Jul 2026 09:16:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 316576B00ED
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:16:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A26D4A077E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:16:54 +0000 (UTC)
X-FDA: 85034606748.17.9122170
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf17.hostedemail.com (Postfix) with ESMTP id 27C3040005
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:16:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jx5vvqa7;
	spf=pass (imf17.hostedemail.com: domain of borntraeger@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=borntraeger@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785158212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b7oXRdOHpe5VOc5/RkRpb+TE2mckMDaNGkRwDlKJufE=;
	b=cp8+GLZi46jpAKguv2pA+jodr0XGKgStn0vJZbjArAyEzWimttCnj38ixIhjy9IyFH08AD
	qcjiOcAOnrWw2LF1GnZnUO8nxuLRG49YvxJeI/79ZuLTXHF/FWiHAmUgvqNdv1DAugKOwq
	ehvCK7G1tuxKM5HnW77gZ+ucu0qf9pM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785158212;
	b=si+Jzx1EBMc4JgAlChfRdvrvMA6pzdEJC6yWi28P/lmrBG5N0C1ejsvnSKD1zqHWipEGQJ
	zfg7ySB1L/1IgAuiCVkvnES1b7cR6s74uxtSkslzOH92Tfn/R/4CjRw6/EBVs3ADbkuEQo
	cKUmqDwrfagfKnernuNhikHpZEQEDFo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jx5vvqa7;
	spf=pass (imf17.hostedemail.com: domain of borntraeger@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=borntraeger@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RAJHo7063305;
	Mon, 27 Jul 2026 13:16:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=b7oXRd
	OHpe5VOc5/RkRpb+TE2mckMDaNGkRwDlKJufE=; b=jx5vvqa70E1aq0iHV+J7vi
	DMDFI+/QwFdABKJJiKKLV0HUfjXtd7EEl2dHsUgDiQRQPnuTDE3XuEiPmMuLmD18
	2GRPcAEleKt2jXNQPe/AbezY6kZvVoDzs4XxiK1lehC+blqZgdD3UIbxZUkEvUjJ
	3WQfYttpVUyKTNyxopgsaYB5jPUOISIGQZIv04fqDJF4klZKkaVc7ckRXhswzHqj
	dYTceBOjIMtXSnfdxf65LV2J+Xu2RHJx2Pswg2JEug8LXVDGkJ5hz3c0ZaeTMjGQ
	OvYYryKTCVMo3+7DElyaSIN/8oQUjEJqCPkFhPO/XtEJQh9GuC5ASk9/aCO8tB+g
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuyc857u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jul 2026 13:16:41 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66RDBGl8015749;
	Mon, 27 Jul 2026 13:16:40 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fna5xw7pb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jul 2026 13:16:40 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66RDGclt36372736
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 13:16:38 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 757932012E;
	Mon, 27 Jul 2026 12:59:23 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CF5A2012D;
	Mon, 27 Jul 2026 12:59:23 +0000 (GMT)
Received: from [9.224.77.173] (unknown [9.224.77.173])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 27 Jul 2026 12:59:22 +0000 (GMT)
Message-ID: <46a7fe72-5caa-4593-a2b1-50696a33915d@linux.ibm.com>
Date: Mon, 27 Jul 2026 14:59:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH/RFC] btrfs: fix folio lock leak in writepage_delalloc()
 for folios dirtied behind btrfs' back
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Boris Burkov <boris@bur.io>
Cc: Matthew Wilcox <willy@infradead.org>, linux-btrfs@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20260721191152.101118-1-borntraeger@linux.ibm.com>
 <20260721191152.101118-2-borntraeger@linux.ibm.com>
 <b226a6e9-fef2-49bd-b17e-9f9b015626c1@gmx.com>
 <83290932-cb8b-4741-bff0-6a7d8df2c637@linux.ibm.com>
 <224d56d2-fcad-41bf-afe3-6f5f5108172a@gmx.com>
 <f12f70e5-d84d-4a9f-ac94-693be4c863ac@linux.ibm.com>
 <amC-J7yzwk4Z5tHW@casper.infradead.org>
 <ad6eebbd-07f8-41ce-b04c-edd50d91a6e3@gmx.com>
 <amICQYTK9Xu4KLtH@casper.infradead.org>
 <d948c88b-dec5-4e29-b30a-3ea368997ceb@gmx.com>
 <20260725062614.GA2792359@zen.localdomain>
 <4f7b99e5-62b6-48ac-a141-24f25af125c1@linux.ibm.com>
 <0b0dc988-61e5-4dd5-b2a1-52699fd4391c@gmx.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <0b0dc988-61e5-4dd5-b2a1-52699fd4391c@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: NuSZWSAOhfVc2dvC0MiYRod7SzIRoyJx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEyNSBTYWx0ZWRfXwoh640Uiz+mp
 83rkQSVLTNKE2OpsX0YaHTOm9xzP2T4xH97+nqAzgIi4/PineDHLcjKQOaAtIaOrhkvTua2pcYW
 nhlSHydCgRolmb5WguQpHIQTPQofCMFqVTKnj4DYRy1U4qDc+OGWP9hxwtR8MR7s5AGXBnP3pJG
 FUh4AQ1pAIJ0urDW683yo0EFyAQucLWGuS3S6tqKXWh9Y187ncBX0cTbCnKUpkKpCs5hDEsu+9O
 Ynmh090bNsTih2KrtNL6zKc9ugJKrUCSl7RlA7nCs2C0MLN0cfohUQgFypGBFuqCxhxAMk68ko2
 4eUiAgIcqX23VTbUKn2pzrhZy+c61fswJQldmQH92jDIvJXwKKBEwWXOBRgjJOwGAUmqjdoIbuN
 WkzXFDCUrONoum6nErb/bgQcgDpPaiEHeunqtxVEtWMY2iqUBWUKTXyT/Iz74Lhjj/z8vdK6YPj
 iv41CkgLEPG0p+4TGOA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEyNSBTYWx0ZWRfX+ACalN23wlkV
 QsX/aqSUjlDt3TChnTDNxvc+HvAk5PrCTCyN+qiuaK/dld1u90JuO8Qjmm/MhyhGxRFBEOXdMMS
 NXAVT8yIqjgwGF2peYYS751TPMl0Apk=
X-Authority-Analysis: v=2.4 cv=AZeB2XXG c=1 sm=1 tr=0 ts=6a675a39 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=NEAV23lmAAAA:8 a=9NPKaJfuwyM--1QCZjYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: kSJjuLGpzUim82PvK6nuYdzKhqdd369W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270125
X-Stat-Signature: fjgarnqo8p8njb3dtnnxd4u6t55aysx8
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 27C3040005
X-HE-Tag: 1785158211-972099
X-HE-Meta: U2FsdGVkX18cYUbWcf5Zj8GBrmzCRu9KGlAZIqV2JieYYM7HJ5tRzsrep2JYoh+yk6hoU+i1YywSWc7KNN/IxmJXgbFPDTf7nXwJHd3T1F67PJ5SNivmxJv2A6EkN4IS6V9g4mskfOiJ7ZHZq2M3rynNTmpJ3O0XOgkcwLEqe1ReJUr9D+yShdKCjHS4Hhb4Yj1vjhB6XGY0gbnAgKhvr8SWsiD/T2Q3elnzFOidD1wSYYN4HYwrx9WutHbRObFUr4nSrFdiQwmCaNLEpo+nrBpm5nxyUGDPCmjpkdpq9q9jqzSHghLbQ6zStL/ZvvrPSMlDgVoIVsBxioKKabjLP1+ndIVb5JYcuYmc6Xkx8EIadYObRZCFwNuXD4mE5X5h/rrIwpQAPvGTajs6GZa5RcdMvOdqFXvvvkwBDTZguvu6fzXf4POm0YGs+NU3t3o5nJYlXoqyvLh1AtimppGmvnaGGC9CSp+dxTs8v9wT2qvzlElC6rxzPQyRwIT3OzLsmgMi1Nam1X6pHxweaJEguMuIwTH8lzZ4vKZ0rx8DCmHRgeLNfjEgsnSK5z1HRAsunEEYVJ+oVvBKBwFjgJLie0zk3LljO7wpviZWGRh2K4UP/NOix9KpjrtDt3NOufdeseZ0uaj1qEoMcjYrzZy/RoAnTKnY4l1jxAYrMjP6Fpg5MVGo8zETMfn2asySdO+uih1ghQwYAryfGHC3GAshtBUC/pG4mqlkDH0H1O53+I77xnr6Yau5tX9YynCyuOCFCtE6EkIeO7eBMufHvOQdMkhXamI6cciZW0fc22CzVPMysgfPGjwrBem6biRuJ+zp/oqpS554t5BGnhYGeTQVBAPxnAP+nqL3rWh9RiHlm3zqeKVl6QIs7xrt90hIGtzF2dRPRaTGYi5NtjFZu1I7gdK8jXL/6cQuI347WzXDUShqXvg5bQhVKdrUgRr9PebDiSkBqsYLowxdTDn94si
 k+t8YZ/U
 rIRZbvai6QaIl1jGL+SSqfL0sVoDKZw0VwLq8OhAqedSWBMnnJwqRsRJ3ZhdIGC6KegnyQN5A4BmxLg1ca8kVdxUm7qvsoZIFTGLkrQea0l/9Os2xJU+86Z/7KbDHtSAZI6fF9K+orUgP4AftLMIwkxpJhPW9P7OX1xDKoqormPcNJEbFAuZhNNfNgC9GQiMHSGFVxuytg3MbJkv1A/t71riiGpK2ZS+Hv9KVXhLX+rzPM0G7yQeqVsESX2oMJy5dI1QLSkrW1tU+STHwAE+mVeSkzvKKOIj2RL9O538eI18i8/lBCFraJdQPaoAXATCF+aID0RO1jFBmQoVmmfBotj2L0qAE+3xGT/PhDKsB4mfUq/XE8JR27UWrtC5F6a0qqQkn5MfFpBSCJzDZ7KdntJPRwtXZh2fL6PAvEunYQsMwdrho9snCyqX/cfSTJFWg2Je4kp5qtm0kEyrgQb1R9PpQnTo+TxIOmJQR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Am 27.07.26 um 10:41 schrieb Qu Wenruo:
> 
> 
> 在 2026/7/27 17:41, Christian Borntraeger 写道:
>> Am 25.07.26 um 08:26 schrieb Boris Burkov:
>>> On Fri, Jul 24, 2026 at 08:10:36AM +0930, Qu Wenruo wrote:
>>>>
>>>>
>>>> 在 2026/7/23 21:30, Matthew Wilcox 写道:
>>>>> On Thu, Jul 23, 2026 at 10:12:27AM +0930, Qu Wenruo wrote:
>>>>>>
>>>>>>
>>>>>> 在 2026/7/22 22:27, Matthew Wilcox 写道:
>>>>>>> On Wed, Jul 22, 2026 at 11:29:36AM +0200, Christian Borntraeger wrote:
>>>>>>>>     *   4. Thread B loops sync_file_range(WRITE|WAIT) on the target file.
>>>>>>>>     *      Whenever a full clean cycle (clear_page_dirty_for_io(),
>>>>>>>>     *      writeback, bits cleared) completes inside thread A's
>>>>>>>>     *      submission->completion window, the completion-time
>>>>>>>>     *      set_page_dirty_lock() hits a *clean* folio: filemap_dirty_folio()
>>>>>>>>     *      sets only the folio flag and the xarray tag - no btrfs subpage
>>>>>>>>     *      dirty bit, no delalloc reservation.  See the 20-year- old comment
>>>>>>>>     *      above bio_set_pages_dirty() in block/bio.c describing exactly
>>>>>>>>     *      this ("other code (eg, flusher threads) could clean the pages").
>>>>>>>
>>>>>>> There's your problem.  filemap_dirty_folio() documents that btrfs is
>>>>>>> doing it wrongly:
>>>>>>>
>>>>>>>     * Filesystems which do not use buffer heads should call this function
>>>>>>>     * from their dirty_folio address space operation.  It ignores the
>>>>>>>     * contents of folio_get_private(), so if the filesystem marks individual
>>>>>>>     * blocks as dirty, the filesystem should handle that itself.
>>>>>>>
>>>>>>> fs/btrfs/inode.c:       .dirty_folio    = filemap_dirty_folio,
>>>>>>>
>>>>>>> so btrfs should have its own btrfs_dirty_folio() which does whatever
>>>>>>> metadata updates it needs to and then call filemap_dirty_folio() to
>>>>>>> take care of the page cache business.  See iomap_dirty_folio() as
>>>>>>> an example, but many other filesystems also do this.
>>>>>>
>>>>>> Thanks a lot for the advice.
>>>>>>
>>>>>> However it looks like the sub-folio dirty block tracking is a little
>>>>>> different between iomap and btrfs.
>>>>>
>>>>> My point is not that "you should do it the exact same way as iomap".
>>>>> Rather "the dirty_folio op is the entry point to tell the filesystem
>>>>> that a folio is being dirtied".
>>>> And since dirty_folio() is not allowed to sleep, we should introduce some
>>>> extra mechanism, e.g. page private 2/checked, to notify the fs that the
>>>> folio is marked dirty without proper preparation.
>>>>
>>>> Then during writeback, detect such folio and do needed preparation for it
>>>> since at writeback we're allowed to sleep.
>>>>
>>>> That sounds feasible, but I haven't seen anyone doing that (including the
>>>> older btrfs cow fixup).
>>>>
>>>> Will explore that path. Thanks a lot again for the dirty_folio() help.
>>>>
>>>> Thanks,
>>>> Qu
>>>
>>> Here is my proposal for a candidate fix. It passes the reproducer in
>>> this thread as well as several more intense reproducers (alluded to but
>>> not yet included)
>>>
>>> https://lore.kernel.org/linux- btrfs/6758d4f27be0bbdb865cee7dd5adc435c969f4a3.1784960646.git.boris@bur.io/T/#u
>> I am willing to give it a try, but that does not seem to apply on 7.2-rc4
>>
> 
> The latest version is out:
> 
> https://lore.kernel.org/linux-btrfs/9f7a81cdd022d9e3f69d347a17c0a25438ccec14.1785131713.git.boris@bur.io/
> 
> And you can apply it on the latest btrfs for-next branch without any conflict:
> 
> https://github.com/btrfs/linux.git for-next
> 

Ok that seems to work for me avoiding the lockup issues.

I do have another issue (performance) with secure KVM memory on a large btrfs file but I think
I will report this differently when I have something to tell/show

