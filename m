Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF5EC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 16:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC4046B009A; Tue,  5 Aug 2025 12:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D747A6B009C; Tue,  5 Aug 2025 12:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C63A26B009D; Tue,  5 Aug 2025 12:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B47F86B009A
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:37:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6377E56E72
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:37:02 +0000 (UTC)
X-FDA: 83743258284.14.BCA50A1
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7615580004
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:36:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754411820; a=rsa-sha256;
	cv=none;
	b=TXiw7Q99OKe+4WfgsYy59+uCRqVkw4QPiH6IquDwr36V/W0LFpDi5bhvKrq2/KSpHBsqBV
	ryE7KsoyV5qgra9Hn1E5SF5mk6W7baHsQuHCP+503pjYBszlXAcXdQap2UY70zk85reN3U
	/jVWXs2KKNTFMYdZsM3ZuVMoe+2W3j8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754411820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=li/CsApt/VWD2vK32y27H6wMkTItYYjtldE9KWBf/r4=;
	b=32O0IEVeicJ1dyMLmJLdvLJ/KjRAMOmtRqIc7mXZYUP/RfRiylhXfWwW+zMHHrk9LsIO6f
	iUgN+31GjiOo92ToM/Ys/d5hU9TqleGH5X7xpBlfNQRQMCwQIrNSVHGuPhebW3zByBwSZu
	UWAd6RCewN+zeqEf1ptByO50qmlsOcI=
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bxJtk1pj9z6D9f2;
	Wed,  6 Aug 2025 00:35:10 +0800 (CST)
Received: from frapeml100007.china.huawei.com (unknown [7.182.85.133])
	by mail.maildlp.com (Postfix) with ESMTPS id 13D861402FE;
	Wed,  6 Aug 2025 00:36:56 +0800 (CST)
Received: from frapeml500007.china.huawei.com (7.182.85.172) by
 frapeml100007.china.huawei.com (7.182.85.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Aug 2025 18:36:55 +0200
Received: from frapeml500007.china.huawei.com ([7.182.85.172]) by
 frapeml500007.china.huawei.com ([7.182.85.172]) with mapi id 15.01.2507.039;
 Tue, 5 Aug 2025 18:36:55 +0200
From: Shiju Jose <shiju.jose@huawei.com>
To: Mike Rapoport <rppt@kernel.org>
CC: "rafael@kernel.org" <rafael@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"dferguson@amperecomputing.com" <dferguson@amperecomputing.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "tony.luck@intel.com" <tony.luck@intel.com>,
	"lenb@kernel.org" <lenb@kernel.org>, "leo.duran@amd.com" <leo.duran@amd.com>,
	"Yazen.Ghannam@amd.com" <Yazen.Ghannam@amd.com>, "mchehab@kernel.org"
	<mchehab@kernel.org>, Jonathan Cameron <jonathan.cameron@huawei.com>,
	Linuxarm <linuxarm@huawei.com>, "rientjes@google.com" <rientjes@google.com>,
	"jiaqiyan@google.com" <jiaqiyan@google.com>, "Jon.Grimm@amd.com"
	<Jon.Grimm@amd.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "naoya.horiguchi@nec.com"
	<naoya.horiguchi@nec.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"jthoughton@google.com" <jthoughton@google.com>, "somasundaram.a@hpe.com"
	<somasundaram.a@hpe.com>, "erdemaktas@google.com" <erdemaktas@google.com>,
	"pgonda@google.com" <pgonda@google.com>, "duenwen@google.com"
	<duenwen@google.com>, "gthelen@google.com" <gthelen@google.com>,
	"wschwartz@amperecomputing.com" <wschwartz@amperecomputing.com>,
	"wbs@os.amperecomputing.com" <wbs@os.amperecomputing.com>,
	"nifan.cxl@gmail.com" <nifan.cxl@gmail.com>, tanxiaofei
	<tanxiaofei@huawei.com>, "Zengtao (B)" <prime.zeng@hisilicon.com>, "Roberto
 Sassu" <roberto.sassu@huawei.com>, "kangkang.shen@futurewei.com"
	<kangkang.shen@futurewei.com>, wanghuiqiang <wanghuiqiang@huawei.com>
Subject: RE: [PATCH v10 1/3] mm: Add node_to_range lookup facility to
 numa_memblks
Thread-Topic: [PATCH v10 1/3] mm: Add node_to_range lookup facility to
 numa_memblks
Thread-Index: AQHcAwip/H6S43K2aESNS7qE2UciQ7RTvVYAgACIBKA=
Date: Tue, 5 Aug 2025 16:36:55 +0000
Message-ID: <bdbb50d7309741b8b282c2e8a1fc72ae@huawei.com>
References: <20250801172040.2175-1-shiju.jose@huawei.com>
 <20250801172040.2175-2-shiju.jose@huawei.com> <aJHawm1zE62x1YH9@kernel.org>
In-Reply-To: <aJHawm1zE62x1YH9@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.126.168.187]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7615580004
X-Stat-Signature: wjdc5szy4xj8mpwhiwkuqdwjgk1h5d5i
X-HE-Tag: 1754411819-841195
X-HE-Meta: U2FsdGVkX18AzPSSwWS5Am5eBldzruWFawOVsTLr+gv2a3qek4IOkKcFuX6ENEciEn1AYByTU3aF+hhhHYZll7dmiSC9/N4md/cNI9arS7N9gOMyj0GKZ+Y92qfXhgoIXs3q3f4Ji7c2jwNm8YA95McB/vkO5C1yOJn0PI79ULPICF1XzRm2Qnx0Vf9FnBV5dg+T3Qns59Tvcs+NcH8P61DYzzAfhYw6H5oGvSUpgFwUU09ir8Oze9br/9EoP08+m4m/gxT0d9JHgwD/VsBLDXTa25RZbZ6DtkotbDygCDqDQxiyqTx04dScDMaLY39whM0zGan5Y/tIBdMf7taAtn1UsarxWXhOvJG4knyUQdx4MxKWZ498vsvBLM8eyJ/bIrLe9XtRlcQd0x+GBdXVyGEexvCP/0/amZHqm8itntvpoZtnrDalHs5TmngrrFVxV1hMV0b22E1V1L064Jd5nn+mRkNmKWQSRbnaClYTXk83i079UWhA6emQ/f0s9X/nzthzzIgm2HOsgDJTWqK9eEhhNsZH6M9LLKv8q3JG/HdPpUr5IEmzNXsTr8AJKZ5P6+YqosrB0ZOJseDpPZVEm0iBYN1kacEsYOvRrd8JVqtJmqVGwNwxdkqTHsxoNM7wbuJB+e2ZM+nKJEvjMjBpUMhTRMNy/Mj8wmiBk8EjSNAa5mi9axZJO272oIu3rPD/FYeyf53NhE+DOtLe9WvE2OGpfl5gz5c9Jf9g93FGbhpue8bDQYRBN+LAola9iO1uItA5vzel5SHPoXWFQsKNZEZZbUUNymMDDedpD0wLb/Z0PNBFtbLDUUOlyh96o/HWl/RmEuxRG/qvr99/Eysi7aE2peTq44YAFkeeJSkIrPFqMYiDpOvAtGuzeaANKqx9/lnso6OoIPpRKT3lN979SGaEwO+lnc6QGckEQi44p6pA1gGBMwFqylvvMMi8KGiaJseoh2xmH2TG/TLcgx1
 t3Qq6bZm
 laI10YUMtJg/5Y3DzFFj4T2Q30UGku9V/dFY6l6fPpMWFdlzh5ILmmwCQ6NpRUCgb64rgRy/d+JC/igWZPnLBGQjy1a3tThK71U6GpXgrBhuA5Xo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>-----Original Message-----
>From: Mike Rapoport <rppt@kernel.org>
>Sent: 05 August 2025 11:20
>To: Shiju Jose <shiju.jose@huawei.com>
>Cc: rafael@kernel.org; bp@alien8.de; akpm@linux-foundation.org;
>dferguson@amperecomputing.com; linux-edac@vger.kernel.org; linux-
>acpi@vger.kernel.org; linux-mm@kvack.org; linux-doc@vger.kernel.org;
>tony.luck@intel.com; lenb@kernel.org; leo.duran@amd.com;
>Yazen.Ghannam@amd.com; mchehab@kernel.org; Jonathan Cameron
><jonathan.cameron@huawei.com>; Linuxarm <linuxarm@huawei.com>;
>rientjes@google.com; jiaqiyan@google.com; Jon.Grimm@amd.com;
>dave.hansen@linux.intel.com; naoya.horiguchi@nec.com;
>james.morse@arm.com; jthoughton@google.com; somasundaram.a@hpe.com;
>erdemaktas@google.com; pgonda@google.com; duenwen@google.com;
>gthelen@google.com; wschwartz@amperecomputing.com;
>wbs@os.amperecomputing.com; nifan.cxl@gmail.com; tanxiaofei
><tanxiaofei@huawei.com>; Zengtao (B) <prime.zeng@hisilicon.com>; Roberto
>Sassu <roberto.sassu@huawei.com>; kangkang.shen@futurewei.com;
>wanghuiqiang <wanghuiqiang@huawei.com>
>Subject: Re: [PATCH v10 1/3] mm: Add node_to_range lookup facility to
>numa_memblks
>
>On Fri, Aug 01, 2025 at 06:20:27PM +0100, shiju.jose@huawei.com wrote:
>> From: Shiju Jose <shiju.jose@huawei.com>
>>
>> Lookup facility to retrieve memory phys lowest continuous range for a
>> NUMA node is required in the numa_memblks for the ACPI RAS2 memory
>> scrub use case.
>
>If the code that needs to find the lowest contiguous range in a node runs =
before
>we discard .init you can just use
>
>	unsigned long pfn =3D node_start_pfn(nid);
>	unsigned long start_pfn, end_pfn;
>
>	memblock_search_pfn_nid(pfn, &start_pfn, &end_pfn);

Thanks Mike for your suggestion and help.
=20
With node_start_pfn(nid) and memblock_search_pfn_nid(), the 'end_pfn' retur=
n=20
different value than the actual.

Found similar function get_pfn_range_for_nid(nid, &start_pfn, &end_pfn), se=
ems more
suitable as it takes 'nid' directly and both 'start_pfn' and 'end_pfn 'retu=
rn correct values.=20

Thanks,
Shiju

>
>> Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>> Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
>> ---
>>  include/linux/numa.h         | 10 ++++++++++
>>  include/linux/numa_memblks.h |  2 ++
>>  mm/numa.c                    | 10 ++++++++++
>>  mm/numa_memblks.c            | 23 +++++++++++++++++++++++
>>  4 files changed, 45 insertions(+)
>>
>> diff --git a/include/linux/numa.h b/include/linux/numa.h index
>> e6baaf6051bc..d41e583a902d 100644
>> --- a/include/linux/numa.h
>> +++ b/include/linux/numa.h
>> @@ -41,6 +41,10 @@ int memory_add_physaddr_to_nid(u64 start);  int
>> phys_to_target_node(u64 start);  #endif
>>
>> +#ifndef node_to_phys_lowest_continuous_range
>> +int node_to_phys_lowest_continuous_range(int nid, u64 *start, u64
>> +*end); #endif
>> +
>>  int numa_fill_memblks(u64 start, u64 end);
>>
>>  #else /* !CONFIG_NUMA */
>> @@ -63,6 +67,12 @@ static inline int phys_to_target_node(u64 start)
>>  	return 0;
>>  }
>>
>> +static inline int node_to_phys_lowest_continuous_range(int nid, u64 *st=
art,
>> +						       u64 *end)
>> +{
>> +	return 0;
>> +}
>> +
>>  static inline void alloc_offline_node_data(int nid) {}  #endif
>>
>> diff --git a/include/linux/numa_memblks.h
>> b/include/linux/numa_memblks.h index 991076cba7c5..ccc53029de8b 100644
>> --- a/include/linux/numa_memblks.h
>> +++ b/include/linux/numa_memblks.h
>> @@ -55,6 +55,8 @@ extern int phys_to_target_node(u64 start);  #define
>> phys_to_target_node phys_to_target_node  extern int
>> memory_add_physaddr_to_nid(u64 start);  #define
>> memory_add_physaddr_to_nid memory_add_physaddr_to_nid
>> +extern int node_to_phys_lowest_continuous_range(int nid, u64 *start,
>> +u64 *end); #define node_to_phys_lowest_continuous_range
>> +node_to_phys_lowest_continuous_range
>>  #endif /* CONFIG_NUMA_KEEP_MEMINFO */
>>
>>  #endif /* CONFIG_NUMA_MEMBLKS */
>> diff --git a/mm/numa.c b/mm/numa.c
>> index 7d5e06fe5bd4..0affb56ef4f2 100644
>> --- a/mm/numa.c
>> +++ b/mm/numa.c
>> @@ -59,3 +59,13 @@ int phys_to_target_node(u64 start)  }
>> EXPORT_SYMBOL_GPL(phys_to_target_node);
>>  #endif
>> +
>> +#ifndef node_to_phys_lowest_continuous_range
>> +int node_to_phys_lowest_continuous_range(int nid, u64 *start, u64
>> +*end) {
>> +	pr_info_once("Unknown target phys addr range for node=3D%d\n", nid);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(node_to_phys_lowest_continuous_range);
>> +#endif
>> diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c index
>> 541a99c4071a..9cbaa38cb92d 100644
>> --- a/mm/numa_memblks.c
>> +++ b/mm/numa_memblks.c
>> @@ -590,4 +590,27 @@ int memory_add_physaddr_to_nid(u64 start)  }
>> EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
>>
>> +static int nid_to_meminfo(struct numa_meminfo *mi, int nid, u64
>> +*start, u64 *end) {
>> +	int i;
>> +
>> +	if (!numa_valid_node(nid))
>> +		return -EINVAL;
>> +
>> +	for (i =3D 0; i < mi->nr_blks; i++) {
>> +		if (mi->blk[i].nid =3D=3D nid) {
>> +			*start =3D mi->blk[i].start;
>> +			*end =3D mi->blk[i].end;
>> +			return 0;
>> +		}
>> +	}
>> +
>> +	return -ENODEV;
>> +}
>> +
>> +int node_to_phys_lowest_continuous_range(int nid, u64 *start, u64
>> +*end) {
>> +	return nid_to_meminfo(&numa_meminfo, nid, start, end); }
>> +EXPORT_SYMBOL_GPL(node_to_phys_lowest_continuous_range);
>>  #endif /* CONFIG_NUMA_KEEP_MEMINFO */
>> --
>> 2.43.0
>>
>
>--
>Sincerely yours,
>Mike.


