Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD8A4FF886F
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 07:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA4386B0088; Thu, 30 Apr 2026 03:06:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B54B46B008A; Thu, 30 Apr 2026 03:06:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A44B26B008C; Thu, 30 Apr 2026 03:06:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 94B146B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:06:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E8D9C1A82
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:06:58 +0000 (UTC)
X-FDA: 84714340116.08.F87E2F3
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8E2F2A000A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:06:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ZOR5Dha9;
	spf=pass (imf25.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777532815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KVe1rkQoId2M0q+G7vAJ7I0Stq/EZ6R6Ou9i2ZV3qVc=;
	b=ax09DeViLkz3A2QZyv5bqZvlGnG5EmF6uBI29c7FwQWk/8zXeuaLahMZufctS3FrmN3CQs
	LB1xqIIQN4xph9BOyIJNAcZELpaRN5OyUIb+bcae/Nbku9oTs5O2HZpZOpNCch70y3S3Ya
	r0hiTPJvESxn2LlfPbHOWFcyWJeQe9g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ZOR5Dha9;
	spf=pass (imf25.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777532815; a=rsa-sha256;
	cv=none;
	b=EY5ntJlOvhmmgCWeQKyB2Fd5TceKF9bAmtxVoXDj2lnWHNDESIaPzdn5clji0LtZvQ4XcX
	t7sp3dWs2LHgKQGJOv3Ys9BBiPHWow28ytJRyk6BgAL9+Ha94lcu3i9cLe16DepUE/O7Di
	y0qHNgXfaHa5yk5wE3UR+BDlL7IXKJk=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63U0vCEP3558379;
	Thu, 30 Apr 2026 07:06:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=KVe1rk
	QoId2M0q+G7vAJ7I0Stq/EZ6R6Ou9i2ZV3qVc=; b=ZOR5Dha9BGwlY7odxoaWVs
	kAKJGE84Tju3JmGXNugos9uVE/8hxwdKhvJbSBxaVREUWVvVaUWto3KfYCeagv0L
	fPwMWEAyIN5QsXbjLyP1bTyMfrT3DYImdJqoaLjebee/S/pwsB58gJAQ06ND96nv
	IOYl/X4tVrsSvlLLwJWsY6zYPjMCwVT7HckpUnEgdw/uno6TA7RirOtmAw8rkIeB
	OJfiQmZzFqydld+Dad78rgsrRk55jdYQeAMZJjDQ9jmxDPSHMnqQbhFtPvUK/94U
	wzhjmou0dcJc3za2knN1gzhJpb8s2Ub8lHwJZpP0FUU5u20iOYWxdpoad3ziOIOA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4drn44xget-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Apr 2026 07:06:26 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63U6rn7f031286;
	Thu, 30 Apr 2026 07:06:25 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ds8xk9u67-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Apr 2026 07:06:25 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63U76OhR26018546
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Apr 2026 07:06:24 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0AD605805F;
	Thu, 30 Apr 2026 07:06:24 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 12E2458053;
	Thu, 30 Apr 2026 07:06:09 +0000 (GMT)
Received: from [9.124.222.143] (unknown [9.124.222.143])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Apr 2026 07:06:08 +0000 (GMT)
Message-ID: <32d03cb3-2199-444b-94de-ff34cf2d5315@linux.ibm.com>
Date: Thu, 30 Apr 2026 12:36:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 3/5] mm: Hot page tracking and promotion - pghot
To: Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: Jonathan.Cameron@huawei.com, dave.hansen@intel.com, gourry@gourry.net,
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
 <ce8bf715-5e76-4c73-9523-8e7309821404@amd.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <ce8bf715-5e76-4c73-9523-8e7309821404@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 91BIh40wuEno1H4PmYjBoi4c67XxTQ0g
X-Authority-Analysis: v=2.4 cv=Ft81OWrq c=1 sm=1 tr=0 ts=69f2ff72 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=6e-r1iUsFtuhjnILqo8A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: dyPF0tdCOfGRIY6TS_xnIayZTHdQJ6sc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDMwMDA2NSBTYWx0ZWRfXyLBLQs79Ttgd
 j8v0qdv4k+xEcJ06YVy+7P674P2JlZBNM7LTpyXeGE9HQ9Hj4/yTNjAZMNzCdwzIedREWKdmpbd
 +fhCCpOA6O3pH4X/TJGzK/Zd5wnFhXnP0O2ZfpaaeXTr5/WYKs1qLCWqkXWA4m4tCtaEzCvGYlV
 kuLG2VvOjZ1zT7xaJeUFg2ZYx3alx5DIgWO/uDCcIAupsSEBLJ2zikMPKHw/0u7x9nwMBXQWJ5L
 IrAH3YZwKIt0O/9EXOW0ODt7BptNIvAWoz/vataLrye9h8eYMTWfKOJHOc+QmG/mafUvmAm+pKL
 DkBotB0NmqFxCX5L4cf9boBnb6fHh+VQMfsTIANEKIza8akmM3hfXqCYYRvGLNoYa2UEQzfcR4B
 lgQZ02mlXyX2g7CvvcZ9aVTovX3jVy1WbQGXY1fWbZs0+dhveJqSiICeONQimcsaD2jzrzSZ+5r
 vuQNNzGbeushqt90ZFw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-30_02,2026-04-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604300065
X-Stat-Signature: carzppqxjgfajqqftfimgsu4f7srfkee
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8E2F2A000A
X-Rspam-User: 
X-HE-Tag: 1777532815-960289
X-HE-Meta: U2FsdGVkX1+7Jg94Wxpv2U3GAncIINBWAIe7wyhGLKZ7svYrUNKWwBAMoQKezNNMp1rPeWjxq/Kqc0uHaPBA+zx4SDmD3C71bJraQmi88d0Ls90rqe13EyeFBGNWLXTl9V2hZq/CCrlKUxS+5jSJyzsvmppmQzbM+GfrD1Xtwgz0nAV3muLFIXYQJ07JHiKYbrvSjRV8g+Pfr74T7XN9Hnpkf204HZp65IjqOOc+klseB9RXqztM25l0031WU7N0Zm46NAGFAe1ME085e92vk+3RiiXw5/+EzOQAHbB7znRQyqY5v9Sj8lyOJOZcJm7yOHe3aO6YYl7kfcrYqEEJuewo/51AwGYxmahowFoC4xROFf7pPs4q0qck9+J1y5n/Y2NsS9FlH7wy9aumHj+qxUN8i5V1NlnFtze7cXTJtZ1tAAAm1sAFU6of6QRKRft4/TaVotG3xG3o4bxG4/vjIoaifG0mIQPz2EJEtUM8YelbsHMzS/aE+5sX9h3U61ldj6Dy5bS+ZWEHOEg1S0+bjcw5wpwToeZktmhgnxCtFuvRJzbj8tfEBE8WddUQFV4nrD2wVNP6zJmk5OdGBCiSEYYUwuLml5wsnp98gdbNN+cU6QJxp56RofKM+QqMFWHlNrNLHwySstTs/LIEWD1WAG4SCvDOw8xIOA5aylKAx6T2iHJFSRAYkOKDOE0V728pPf/4/W3ChL7RtzMjKOgMFBep9EkWIFng1bAzrQrH9C6fihye+F8jUCG10YpramLY5BtMnlX3N2ZT2CdgUiMaL0jx5ian4eA0YBMV7C+f34H/DNwcFvVpjkl+osZTvykR841Kh3EX+kYTlCjYJAAV+mKdBaLyTbBSS1npaUCSJkwCLjMOKjCH3Mtky9I0aTA7FnuU7+JXTBobDUzV3p2E9KRH+Neovl0ez67DNUEzKzH0bc0wiUBXUZErtYr7JF0/4Z27IP0F/6WDelzYiiL
 gdxwlqp9
 WWZx4BVBvZRoYWnmiBSEQZ3iFPUmOdlb38rmvzSyXOzOuE1swDXQjGKNXpAxnJwzQ0L8Zvdub3eMTGTDyB3LBY7wEOLD5KQhOawC+wTHaXRwcLaRZLs1j3GZynpZXrC7g7iTnJvefhAnCFNNbSRGuDFY0gWAOQVrFAItSu6sm11nDk5w7qia5SM58RI9/qEjkHRFR30/FDlBSWKipf0dvOJF8KSpfd9SlIaYDY6j5EZOgZrQ2TDFmkitqOBxCS1U7zIDwAo4R4yv5MHDfCYrV9DQptBz5MtQYkbUAw1Pmp83ltzeGaHjdta7u6oQDp0LfwzlZNNmzrxTZ3Kw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Bharata

On 4/27/26 10:54 AM, Bharata B Rao wrote:
> On 24-Apr-26 6:27 PM, Donet Tom wrote:
>>> +int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
>>> +{
>>> +    struct mem_section *ms;
>>> +    struct folio *folio;
>>> +    phi_t *phi, *hot_map;
>>> +    struct page *page;
>>> +
>>> +    if (!kmigrated_started)
>>> +        return 0;
>>> +
>>> +    if (!pghot_nid_valid(nid))
>>> +        return -EINVAL;
>>> +
>>> +    switch (src) {
>>> +    case PGHOT_HINTFAULTS:
>>> +        if (!static_branch_unlikely(&pghot_src_hintfaults))
>>> +            return 0;
>>> +        count_vm_event(PGHOT_RECORDED_HINTFAULTS);
>>> +        break;
>>> +    case PGHOT_HWHINTS:
>>> +        if (!static_branch_unlikely(&pghot_src_hwhints))
>>> +            return 0;
>>> +        count_vm_event(PGHOT_RECORDED_HWHINTS);
>>> +        break;
>>> +    default:
>>> +        return -EINVAL;
>>> +    }
>>> +
>>> +    /*
>>> +     * Record only accesses from lower tiers.
>>> +     */
>>> +    if (node_is_toptier(pfn_to_nid(pfn)))
>>> +        return 0;
>>
>> Just a thought—could we check this at the beginning of the function, before the
>> switch case?
> I am accumulating two stats here: How many hot page intimations pghot obtained
> that are attributable to different sources
>
> and
>
> out of them, how many turned out to be actionable
>

Understood. Thanks for the clarification.

>
>>
>>> +
>>> +    /*
>>> +     * Reject the non-migratable pages right away.
>>> +     */
>>> +    page = pfn_to_online_page(pfn);
>>> +    if (!page || is_zone_device_page(page))
>>> +        return 0;
>>> +
>>> +    folio = page_folio(page);
>>> +    if (!folio_try_get(folio))
>>> +        return 0;
>>> +
>>> +    if (unlikely(page_folio(page) != folio))
>>> +        goto out;
>>> +
>>> +    if (!folio_test_lru(folio))
>>> +        goto out;
>>> +
>>> +    /* Get the hotness slot corresponding to the 1st PFN of the folio */
>>> +    pfn = folio_pfn(folio);
>>> +    ms = __pfn_to_section(pfn);
>>> +    if (!ms || !ms->hot_map)
>>> +        goto out;
>>> +
>>> +    hot_map = (phi_t *)(((unsigned long)(ms->hot_map)) &
>>> ~PGHOT_SECTION_HOT_MASK);
>>> +    phi = &hot_map[pfn % PAGES_PER_SECTION];
>>> +
>>> +    count_vm_event(PGHOT_RECORDED_ACCESSES);
> which is this ^
>
>>> +static void kmigrated_do_work(pg_data_t *pgdat)
>>> +{
>>> +    unsigned long section_nr, s_begin, start_pfn;
>>> +    struct mem_section *ms;
>>> +    int nid;
>>> +
>>> +    clear_bit(PGDAT_KMIGRATED_ACTIVATE, &pgdat->flags);
>>> +    s_begin = next_present_section_nr(-1);
>>> +    for_each_present_section_nr(s_begin, section_nr) {
>>> +        start_pfn = section_nr_to_pfn(section_nr);
>>
>> I may be missing something, but in pghot_setup_hot_map() and kmigrated_do_work()
>> we seem to iterate over all memory sections. On large memory systems, could this
>> become a bottleneck right?
>>
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
> I didn't just yet optimize the walk. Since there is one kmigrated thread per
> lower tier, this routine already is aware of which node to scan. We can limit
> the section walk to that node instead. Something like this:
>
> static void kmigrated_do_work(pg_data_t *pgdat)
> {
> 	unsigned long section_nr, s_begin, start_pfn, end_pfn;
> 	struct mem_section *ms;
> 	int nid = pgdat->node_id;
>
> 	start_pfn = SECTION_ALIGN_DOWN(node_start_pfn(nid));
> 	end_pfn = SECTION_ALIGN_UP(start_pfn + node_end_pfn(nid));
>
> 	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
> 		section_nr = pfn_to_section_nr(pfn);
> 		
> 		if (!present_section_nr(section_nr))
> 			continue;
>
> 		ms = __nr_to_section(section_nr);
> 		
> 		...
>
> 		kmigrated_walk_zone(pfn, pfn + PAGES_PER_SECTION, nid);
> 	}
> }


Thanks. This looks good to me.


>
>>> +static int pghot_online_sec_hotmap(unsigned long start_pfn,
>>> +                   unsigned long nr_pages)
>>> +{
>>> +    int nid = pfn_to_nid(start_pfn);
>>> +    unsigned long start, end, pfn;
>>> +    struct mem_section *ms;
>>> +    int fail = 0;
>>> +
>>> +    start = SECTION_ALIGN_DOWN(start_pfn);
>>> +    end = SECTION_ALIGN_UP(start_pfn + nr_pages);
>>> +
>>> +    for (pfn = start; !fail && pfn < end; pfn += PAGES_PER_SECTION) {
>>> +        ms = __pfn_to_section(pfn);
>>> +        if (!ms || ms->hot_map)
>>> +            continue;
>>> +
>>> +        fail = pghot_alloc_hot_map(ms, nid);
>> I may be missing something, but after pghot_alloc_hot_map fails, we continue the
>> loop. Would it make sense to break and go to the cleanup logic instead?
> There is a !fail check in the for-loop due to which we break when alloc fails.

My bad, I missed it.

-Donet

> Regards,
> Bharata.
>

