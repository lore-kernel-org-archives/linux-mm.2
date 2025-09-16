Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CE89CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 05:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03B148E0002; Tue, 16 Sep 2025 01:51:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2E158E0001; Tue, 16 Sep 2025 01:51:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1C568E0002; Tue, 16 Sep 2025 01:51:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD5088E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 01:51:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34E3C1DFAFA
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:51:03 +0000 (UTC)
X-FDA: 83894040006.19.20DD187
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf29.hostedemail.com (Postfix) with ESMTP id BD24D120004
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:51:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=OZIIWg39;
	spf=pass (imf29.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758001860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ccT1bC7lYbAG6exxdO3CkV7Hot/4KAxkJYvN55BT0zo=;
	b=sMEbTOFP+OCR1CNdnCpzgOVF+K7ZN4AUJkZsmxFuqKREvGURYo7uSCVdFzKrjpgDvNxVBp
	Qp/XyMqbiu4/OixJe+WEdr7czGtIVtnXDQ+WkaB3VzhRAfWCgDOXPcHSnrC986Hbcdt88x
	u0YYpEwUDRlA+jpWBqKuNe3dukIeq8s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=OZIIWg39;
	spf=pass (imf29.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758001860; a=rsa-sha256;
	cv=none;
	b=nPK41EaEqO/hZVbczcJrPsIN1Xk65eBejf6k0bQQxkOR4mHqOIE6ZrUgRCrvytLbf8yq1S
	VMxTWFqHhcRQgmKZgLJUJ1h8Pi2iFkqA51UBixX/RmGIJAnk1NzoRIr97+7pVHg3DtrAk4
	gdaw5JtYHgtnvDw/9EiM3reQQYI7rpk=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58G38QFB017396;
	Tue, 16 Sep 2025 05:50:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ccT1bC
	7lYbAG6exxdO3CkV7Hot/4KAxkJYvN55BT0zo=; b=OZIIWg39Dwp/vQG8Ux0lVN
	sdJ9ZFaqVu7FThJv7doPD24vzEt6thLBDI+fM14u5YeBZGwpI5rHa0SH7/1ft9Ui
	xvrxs0I4OJy0ODpGcImX+SzHamtticZiaVdGb1KRCp2lEX+9w3otUtVZ4KL7Uwvo
	tX1wQbrc53kpsXzE+ibQCXq4/mLm1ofjslAAqOwoMbLecW1e39gOfc5YvRx2jL8E
	lHIeXqMB875hgFSsKJpXGADWX1zL4jLE5sEYlbXsMt4EujxxCVwiXGM/wKsrcpWf
	1YjJXoFPQV5MujyMbKR8GTWkxIVTgwrxtcXKhX9HKT+EmGXIKNU77FeZoh4E6cng
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 496g53584e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 05:50:57 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58G5ouVf002958;
	Tue, 16 Sep 2025 05:50:56 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 496g53584d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 05:50:56 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58G5mWKK005963;
	Tue, 16 Sep 2025 05:50:56 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 495jxu2ha3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 05:50:56 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58G5otru30868196
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 05:50:55 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3F4205805A;
	Tue, 16 Sep 2025 05:50:55 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DB6D15805C;
	Tue, 16 Sep 2025 05:50:50 +0000 (GMT)
Received: from [9.109.215.183] (unknown [9.109.215.183])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 Sep 2025 05:50:50 +0000 (GMT)
Message-ID: <7dcfab94-753a-4e60-b350-2a5f09613c34@linux.ibm.com>
Date: Tue, 16 Sep 2025 11:20:49 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/ksm: Fix incorrect KSM counter handling in
 mm_struct during fork
To: Sasha Levin <sashal@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Wei Yang <richard.weiyang@gmail.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>,
        stable@vger.kernel.org, Joe Perches <joe@perches.com>
References: <cover.1757946863.git.donettom@linux.ibm.com>
 <4044e7623953d9f4c240d0308cf0b2fe769ee553.1757946863.git.donettom@linux.ibm.com>
 <20250915164248.788601c4dc614913081ec7d7@linux-foundation.org>
 <aMjohar0r-nffx9V@laps>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <aMjohar0r-nffx9V@laps>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LFh1igVw5leCDBK86GUUJvHhLChJTO9N
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE1MDA4NiBTYWx0ZWRfXxgQQSHweHzxG
 k4h/GPcfLMPV+IWwJfSpfOJ5dqvba4B1kx+E70IFyvGtvJ5KtiCCkfA17s9bbUouirXhtOHk4A1
 zaYjzVN1lJljVEwl6wcH9t+7AY/XCfvOxx83to2rbgbM58JjsipA9kA0xMEh3k8HGtmWvWIfnUH
 MyDxY4++iDrvzHSAPPy5Yi08x1RpWD9vU7iwZ/WZFX+luJYMzHLKiZX247L8U1Nt6idkSgE/b1Q
 mUBY40pydAOq7FSnbF0reezdz1b6kuWWm8dFM6s7MNc+LDCmSu4hY8yxb4bUZXMuNy1irY4QXuu
 biBou/V8OM/olt9BDyyhz0yC0WvPdP3fweG2DlabevyT7NMHs5E7F/rmnO5QyHjqOgsFurlxf+4
 MofpqGRH
X-Proofpoint-ORIG-GUID: FdAcikb9w6k-2Q621R_EORuMfP_2YG66
X-Authority-Analysis: v=2.4 cv=UJ7dHDfy c=1 sm=1 tr=0 ts=68c8fac1 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=PrHmRqyh15Ml7F08pAgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_01,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 clxscore=1011 suspectscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509150086
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BD24D120004
X-Stat-Signature: jyuia61byca3jo8au13gamrn498e4esr
X-HE-Tag: 1758001860-475412
X-HE-Meta: U2FsdGVkX194Ta+BZIdk4EonSHQTG+XkieuugzEx4hJMVxUAdg6xYmTlI61AIdM47Cb2HmlshYL77sk1hGVjsEPoLhr/aGdnhZEwGR8fUtvk8JaabV6cHIQ9avZSrhUKDRC22mfcBfZwRyXWFCBtN+mPjgIBPI+3AaoU7YzDFCAtG9ovtGx4tj308qH7zLfhGH7ffpdmrN28HxtQCfcAvxvRoATANmLQ2IeOewqus85tYlZzpEOnrCrrkpcZYvwm+7AFb4t1BT9xp+Dkl22UFpPzKG0VjcQy89fOpPTW4FX8bUaMMDnWdoitVoGlLz9IOfZoq8OQuYGeSP39uJryLmp5K2vBl/knNrzrq+1v9b7UHeZss0smIZBCWw6JUsE5bsmDvT7WL/nFoZ59cawOA5+2jL7rhNM09POyXDsgQrPqFlfim3zaLWRT7XlMQcg/6qeGPlBaMoJxBR3b4WfGmXvprXb875upxCrTzZB0k8/9FAHOT8g6odUh/NZddYEB+5kEVkomx3OaJPH5dgWroh5D095WZlGChsyZt8R73XWOhPepIKzTo5iO8W9BnhYDBZfqYBNf4Uv958MZGYc8Hqwoi2JS1fjIwEmu5Q8EiGlcJEUAxkjxtrXk7e6jubqhN65xbyxrRyPIgGiQaDRA2r8+m8ehUWQvjAePFJ6qRMsd/nCmEtxer6upejeoiXZFBun37Prgd4bgX81E0ChBjk1scJ2ZRvR1WL/YLGs33qCTDVmiQkvvuSk8BJBEHJ12EgtEh7yD+P3/qB/LURGL/JSafK9rGwOg7WAwg4f+CmW3vRolJ459Um6qrX/0r7jO9+KWsQJjna88ITXsOUBkM3hbK8kYeayx2DsuyDC3g9wMt1eVFKaCffl5A8rFdVbz7urXfKuYgrP743NAdyYDL9ka98G5DdUjNueQEcYtVRPwaBRONehP8yjwNzdB1MGiIOctWV3Qd61mH41fiGm
 MaF4LoRx
 on3aIN8GH3BmbcQLLnJyblVK4nZC0AAmtQTWvLnTby7AluKVBUZeDGbDHNo9ISDd8KrofAXp0HWc+nNiAgZ/cwMZNHDdzrt2ZPoAU+ggeT1jmriKZDJj5tT3UVd0FRWR+EngYgoCRqB4TctV7Q0Q1EzgYjirXFWtrP6NAVPN2mBjcNyzosKsLYL18Afkjy1lfgXpNvGauiYT1bu+bvLO3X6U1QHStHQacFyYjid8pobjxfKmScEvx144aiZthm4I+/8subfhHTIMSoAa5a1zjpq/558SkHDAgVmDI8AagKxy9Mfm9+kSugrH/rj5i7QmAyGI+t429138T1VHt61uJPx3UKM2XYJy2X1djQkqEKtg90XB0Ha5Lxwk+wWT4HRVU5AR8bltKybhYVvlclv0brkKf93Bx/OId60/m0mqioMgGXe5PsB9zvgBN4VhMM57jl6JUdcBT6JJNGSMaiXv2o0KOSHkxnlANrqU/YBEETgu9EKHewXiB7TtNQ2eSneX5k3UrYYmH2Hlc+jCS8jl24wGckMmn4IDkdEte
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/16/25 10:03 AM, Sasha Levin wrote:
> On Mon, Sep 15, 2025 at 04:42:48PM -0700, Andrew Morton wrote:
>> On Mon, 15 Sep 2025 20:33:04 +0530 Donet Tom <donettom@linux.ibm.com> 
>> wrote:
>>
>>> Currently, the KSM-related counters in `mm_struct`, such as
>>> `ksm_merging_pages`, `ksm_rmap_items`, and `ksm_zero_pages`, are
>>> inherited by the child process during fork. This results in 
>>> inconsistent
>>> accounting.
>>>
>>> When a process uses KSM, identical pages are merged and an rmap item is
>>> created for each merged page. The `ksm_merging_pages` and
>>> `ksm_rmap_items` counters are updated accordingly. However, after a
>>> fork, these counters are copied to the child while the corresponding
>>> rmap items are not. As a result, when the child later triggers an
>>> unmerge, there are no rmap items present in the child, so the counters
>>> remain stale, leading to incorrect accounting.
>>>
>>> A similar issue exists with `ksm_zero_pages`, which maintains both a
>>> global counter and a per-process counter. During fork, the per-process
>>> counter is inherited by the child, but the global counter is not
>>> incremented. Since the child also references zero pages, the global
>>> counter should be updated as well. Otherwise, during zero-page unmerge,
>>> both the global and per-process counters are decremented, causing the
>>> global counter to become inconsistent.
>>>
>>> To fix this, ksm_merging_pages and ksm_rmap_items are reset to 0
>>> during fork, and the global ksm_zero_pages counter is updated with the
>>> per-process ksm_zero_pages value inherited by the child. This ensures
>>> that KSM statistics remain accurate and reflect the activity of each
>>> process correctly.
>>>
>>> Fixes: 7609385337a4 ("ksm: count ksm merging pages for each process")
>>
>> Linux-v5.19
>>
>>> Fixes: cb4df4cae4f2 ("ksm: count allocated ksm rmap_items for each 
>>> process")
>>
>> Linux-v6.1
>>
>>> Fixes: e2942062e01d ("ksm: count all zero pages placed by KSM")
>>
>> Linux-v6.10
>>
>>> cc: stable@vger.kernel.org # v6.6
>>
>> So how was Linux-v6.6 arrived at?
>
> e2942062e01d is in v6.6, not in v6.10 - I suspect that this is why the 
> "# v6.6"
> part was added.


Yes, e2942062e01d is in v6.6, which is why I mentioned that we need to 
backport it up to v6.6.


>
>> I think the most important use for Fixes: is to tell the -stable
>> maintainers which kernel version(s) we believe should receive the
>> patch.  So listing multiple Fixes: targets just causes confusion.
>
> Right - there's no way of communicating if all the commits listed in 
> multiple
> Fixes tags should exist in the tree, or any one of them, for the new 
> fix to be
> applicable.
>

