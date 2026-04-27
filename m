Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91F14FF8850
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 05:25:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1D526B0005; Mon, 27 Apr 2026 01:25:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCE7C6B0088; Mon, 27 Apr 2026 01:25:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABCAE6B008A; Mon, 27 Apr 2026 01:25:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C4306B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 01:25:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 469711A0772
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:25:22 +0000 (UTC)
X-FDA: 84703197684.17.ED277FA
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011037.outbound.protection.outlook.com [52.101.57.37])
	by imf10.hostedemail.com (Postfix) with ESMTP id 27AC8C000C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:25:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=XzEvqwQu;
	spf=pass (imf10.hostedemail.com: domain of bharata@amd.com designates 52.101.57.37 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777267519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IhMsT+V2w5TaZSh97hvpvQOhWz/dtxRTne/uxTncjng=;
	b=zWwnMmLsYNRIFVuHwRFPFposezusfry/GQo81UfbINeuLrHs8G465kcznh+DPfwDXsfUKu
	ZVb+tdOLO2ftdLcnsvZP5InQlRFbGwFGx1O/kkpm/paY+WlAmiqwJ1wHEFmjPJE3YYWILq
	QFctm99qzKT+E0IA/nixVPWhHlr1XI8=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=XzEvqwQu;
	spf=pass (imf10.hostedemail.com: domain of bharata@amd.com designates 52.101.57.37 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777267519; a=rsa-sha256;
	cv=pass;
	b=YawFKc3PJalPIS6NxpFOvWs+PXeZ55KAL8yYpHDbWhNdA3Ffyao+zUoYeMS2TJKSZAo331
	AfcgVkhObsU9mAqOX7U3oLRLQ3E+511aaGbKycmINB9YkRFjRmQDyY+jIRfJcblQBRsyRy
	O3Pz1Ifq6MSphWQFw/b8POWsJ5M+9q8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jYgJJPODl352KycyLnk08f35RFcGrNy/h6CR3DfYm1WrQBleY14RgCQl8BR0igeBPp1Zdj2JsfcvjMpdCJVDmuJKpS+TvZM9v3IeTzLPnmVir6OH/0Bq9Qt3KXHfJ5uUopCjY6qK0rjlHpJaJvwgIw5xt19jM2uN6rkBJfNNAS1usRP1I9RxWwdpkwH0nPKemw8H6ABCL+9+dC1dSxY+pWZKLzq3VmpqH/idmZgUinTeNMfhsKNxLeur2ShVKkV7XszxotAU5qSOHFWAsH/ImmlWQ/enlIxC7LCVvdRgnA4YSMCsJeNssLuCabWELX4QXDuGB6f8FcoUxwSjm4BmuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IhMsT+V2w5TaZSh97hvpvQOhWz/dtxRTne/uxTncjng=;
 b=cSIKA+u/Gs1v2mTldyuDELC6DwAC4h0tvC1sTWG0x/89nzphArywdVRfmIwZbJlz/BsnmvZ5kCn6tgsDvzSvsRI+3KigHIOzACOK9IXYxyZy+kxKq0j0WXosbfjZJwYHijQyv6FiztTSrB4wcjhuiYigpdnR1RptcdE9OsPga8iLwpHjluKwnbJcnyQ8Vv4v4lPzjU6COwwSxRu1X3kKE4YwEFk1BegWDAhJSjvGMOO4Y/8mWTdo1Ml3kN9AOVdzJRVHeqfTHcVmRhwVMcGC0OxqOdKoX1XZWsBuljN0PLrwsqblpkZZNcD6ZDVT+v2YGwFRWwFDk8JfMx807kGCjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IhMsT+V2w5TaZSh97hvpvQOhWz/dtxRTne/uxTncjng=;
 b=XzEvqwQuywjITvDMASaoyvMkheTvUQU6HfY8M6QhtNmO8BgTYsheZp8duTAjjaz4p7gUcHHtt2xvztEGx2LZrV65CmNBXgpLwQF3sa1OZ8GBv/cv6EG/lYJ5dIO12nEIBKAebbJ0tkm5I0NqOD3z6Ee+PYPKyM6VJ5J3ilArYs4=
Received: from CH0PR03CA0214.namprd03.prod.outlook.com (2603:10b6:610:e7::9)
 by LV3PR12MB9233.namprd12.prod.outlook.com (2603:10b6:408:194::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.15; Mon, 27 Apr
 2026 05:25:12 +0000
Received: from CH2PEPF00000099.namprd02.prod.outlook.com
 (2603:10b6:610:e7:cafe::e7) by CH0PR03CA0214.outlook.office365.com
 (2603:10b6:610:e7::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 05:25:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CH2PEPF00000099.mail.protection.outlook.com (10.167.244.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.18 via Frontend Transport; Mon, 27 Apr 2026 05:25:12 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Mon, 27 Apr
 2026 00:25:07 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 27 Apr
 2026 00:25:07 -0500
Received: from [10.252.192.21] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 27 Apr 2026 00:25:00 -0500
Message-ID: <ce8bf715-5e76-4c73-9523-8e7309821404@amd.com>
Date: Mon, 27 Apr 2026 10:54:55 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 3/5] mm: Hot page tracking and promotion - pghot
To: Donet Tom <donettom@linux.ibm.com>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>
References: <20260323095104.238982-1-bharata@amd.com>
 <20260323095104.238982-4-bharata@amd.com>
 <250e68f3-3664-4148-bfbf-52fd4230a3b9@linux.ibm.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <250e68f3-3664-4148-bfbf-52fd4230a3b9@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Received-SPF: None (SATLEXMB03.amd.com: bharata@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000099:EE_|LV3PR12MB9233:EE_
X-MS-Office365-Filtering-Correlation-Id: 07c87beb-42eb-40df-bcb0-08dea41d5b14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|7416014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	SdNbw6qwB8FAM5sYMn9eAdG4rc1FxZH+SRXPaM7fddxgdIz+OxBEtw8O+Oac+qtzDjNqGiXsgCrBf8UshGuWBuLmNfPWobT8hsbXAe6dmThaLf5AVZ/QP0P4NhHwXWMpgoxZVlFq0lwQM8qOQ8ER9Oq+ejPKn0nv//85kqUUaIfHDFpg/s8Xg76Iafqxvb2GiUd+P03OzLWPW6Ee3b1wQmDbiBe6VNLzjD8Stz0xbqIdmsOPNVN/aVhl1iJlgDg0F7E75WWyfLgwyOzoNotjIojEVdQp3RviAkX+GWHmeOPjFZmho2gsZYofkuzyn7vNvmwkDdAh+HssjyAS7IoZ7sPknT/e91WlsmSKcPZ3yDXUnjTaa32vr3ryn0lYFacyqUZeLEnyM9F7MmAZ9yc/8kgF6r2g35ky3Xnlv9IlfuBZGyG/gkk16jV+EXWrg4z4qQwc7mDzWE/EGxU9w4FFrTxkCRlPXB1Pcpt2m/qQp71d1baKzorzUtiV4zJl2d90IEtlvXGV1y9ykrWINMZcPlL7eZZdXw8F1lXnc9JMWkDNE2JVQtKftOQxDFjMEkOwMPStLTcOt6vACzRnMBkcnpGlKR4cFdIqu/zKma5pfZec5ouoeFkFQwowbhDr4971a0kxQBM4VGyMyFzy6OuJ2Z7cUTi+N6rLYIPyni3SPAbXQy33S96/L783zYzZY5uLslOSmpe3NWKnIEJcckrxZS07/rf9LsD/Lb5QlyhfERKbXaln6zPrw4j2wrmh48tnCY7/Yoy7wpSN9MKDtU2jPw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(7416014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SPJD4/67Ltd6gqnYiEuGu4ui1VtzWfh6TPpzPOk1HaRjb3mF4sTq8cEv1He65yvEc2zAEdMo257L+6WB9hoo+lL1V1XU2lodqOQ29BJMPnEIAZ85kIp61v0Nsszv59XHCK2OXCWOrfYZ473aqCogD+tJGG2Kx9IAZUu1gczZLPMWtvIsFbnXSrU2lpTILXK4rYng1Ts20fLsbLV2V4mL/gqLnIF80OHkURIqm+H8ighHiCLQI4qM7fp2AlOwtGsPSnSdHKRsH2Y9SU+C4/gkIAxbaldmxp5gNc6mBAyH2MJYHR49HbQ7s1kYjusR0PkNafLcS9wojhAdWq+9AxUrBo72qKAa32Rw96AhLaCrrO/4f6OxE74Ii0PzEJ+5nS5qfEGw5ppa89nKYGcmWbMzk/1i9ANP6sv0qJtxqsmV1kwo6Zjcywb5t7YjKUTfvnDL
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 05:25:12.1726
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07c87beb-42eb-40df-bcb0-08dea41d5b14
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000099.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9233
X-Stat-Signature: jsz7ehnzfc8ojqq18so5ajuk6go8r6dx
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 27AC8C000C
X-Rspam-User: 
X-HE-Tag: 1777267518-161962
X-HE-Meta: U2FsdGVkX1+D6fblkyKTvvkOAWZ9EvZXSawFoos7VbM8yw5REQu4DP52neW6NQHBgybGoDFECJKDy5JILUUxpTAOdfN72+E3iQaNmKoaFZEKiJ4xqfs3jzTdJv6eTxhPT1frsU6iGtcMTYCDE+blbHwjM7U2yrbX30oE3FNQ4LvD/4wkLkT1HLJIN+rW+3//HfygH8Gglk3uofLKmi+t1QBH/Ekd9hQKFOCKiyfoOPi9GavSPp0D8IsXWDW0TnhRTycBWeK9F2021c6F6GDRSb3/6+pJXPEt3hWUqEiC1kw39+9ytvi12K5CCD8NVPL+D07K5YRW0Yy7WnW5Ndsw5h7VzqyrHIAIWeOpL7VyVcSpYNJJ3gPKJ5wOCvhSBoeSLk+yFixMDW05wmTQZzF9h/6wxriA+4zZGZuM+RK8ny45FeROEC1/zgux5MDkLFK28tEMg8yh3RNMTTFD9RZZfPQcFp3FaUrhpn6WsisFSFIjWYeQBHHbUlpjwQhMBKv3OQKo/r6ZFYZVwlxz85UPJrij6FVvShjlBtteHUVw1owtrtRKoXGBSbcwQOVdzc1VdSfjDdsS/NrTskwHJb7P+iNG0EFxoUjfyuaGdlO23NjzI3EWUqWLqeOdaY+KB9T5G3k7wZU0VUs6L6uvMKlsrxZFjn492ezDm5fpURlxSqCbxto68UcTbti4mq7FXaaZZ/9ca6+13zp1IyPggVfFdH3T7BfuuO5/igoaIobmm1zrNOAMRwdQw+eJ0ZyIMeDBQ4MTV2vTEMrnBA7ayhsQw8vjIfkY+bv2XC3tHuMK+vHQZU3GHEm4co/3kLuiQ3nj7ZQn7V+XV0EFfu8++tMp78qovFxV7L0b8aSr++jm8moSSO9BQ9edDILaaIYBJOnXzvSIRD8PFvP5pF+BH2VssgJ75chwUfW3jNsx+pDmfKHq0S8I1cbPkScNo50NtDsFqhhF3FTl20FTt37kuMG
 wmKV3Njp
 G2YspJqtvP+QHxVCpTZ/NQrg6t+PdnuJoxTyGjqmtzW60oVLOmiLXYpuIV1DOjSxl6eausWNYewT61AUqW3O2roMvL7nf7deHtpU4l3qrnVzwAH55errjnEUL1JNpX4P6AMWVcDX0YFYONkFuAoApxgiNY+T51DOmuQEjGjGDPANIAw/JksP7I79VNYuWauJV30IesS1SzzWzclXDyHHQUChiiYlw3vVNF4Fhf3Hmr5lzifeeweAJpcPw/peVo3aDw2fOEc0s3O8Aafq3ffrGvU7q604RBKu8xKtFAVs2jtzgTdJgcOKnRC/yc1lAVRm0N6QjEhOBYW7n3FlG03VI+Ij/DEujoSRHzwjh7y3RzU4aEXd7tvWQZCfhuKOgFvxk127zWOWOhi0k79ihjsxOtssc0JW89gs9E7MvnaB8sg54wRp/UYNjg9EJ0HEBlbOLEQ1F7/nLdnuyzsF1NakXlK1/tPoMqUtE9p8jCW3Mv9sdDrtZXoioUetRqxswKtrC682S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24-Apr-26 6:27 PM, Donet Tom wrote:
>> +int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
>> +{
>> +    struct mem_section *ms;
>> +    struct folio *folio;
>> +    phi_t *phi, *hot_map;
>> +    struct page *page;
>> +
>> +    if (!kmigrated_started)
>> +        return 0;
>> +
>> +    if (!pghot_nid_valid(nid))
>> +        return -EINVAL;
>> +
>> +    switch (src) {
>> +    case PGHOT_HINTFAULTS:
>> +        if (!static_branch_unlikely(&pghot_src_hintfaults))
>> +            return 0;
>> +        count_vm_event(PGHOT_RECORDED_HINTFAULTS);
>> +        break;
>> +    case PGHOT_HWHINTS:
>> +        if (!static_branch_unlikely(&pghot_src_hwhints))
>> +            return 0;
>> +        count_vm_event(PGHOT_RECORDED_HWHINTS);
>> +        break;
>> +    default:
>> +        return -EINVAL;
>> +    }
>> +
>> +    /*
>> +     * Record only accesses from lower tiers.
>> +     */
>> +    if (node_is_toptier(pfn_to_nid(pfn)))
>> +        return 0;
> 
> 
> Just a thought—could we check this at the beginning of the function, before the
> switch case?

I am accumulating two stats here: How many hot page intimations pghot obtained
that are attributable to different sources

and

out of them, how many turned out to be actionable

> 
> 
>> +
>> +    /*
>> +     * Reject the non-migratable pages right away.
>> +     */
>> +    page = pfn_to_online_page(pfn);
>> +    if (!page || is_zone_device_page(page))
>> +        return 0;
>> +
>> +    folio = page_folio(page);
>> +    if (!folio_try_get(folio))
>> +        return 0;
>> +
>> +    if (unlikely(page_folio(page) != folio))
>> +        goto out;
>> +
>> +    if (!folio_test_lru(folio))
>> +        goto out;
>> +
>> +    /* Get the hotness slot corresponding to the 1st PFN of the folio */
>> +    pfn = folio_pfn(folio);
>> +    ms = __pfn_to_section(pfn);
>> +    if (!ms || !ms->hot_map)
>> +        goto out;
>> +
>> +    hot_map = (phi_t *)(((unsigned long)(ms->hot_map)) &
>> ~PGHOT_SECTION_HOT_MASK);
>> +    phi = &hot_map[pfn % PAGES_PER_SECTION];
>> +
>> +    count_vm_event(PGHOT_RECORDED_ACCESSES);

which is this ^

>> +static void kmigrated_do_work(pg_data_t *pgdat)
>> +{
>> +    unsigned long section_nr, s_begin, start_pfn;
>> +    struct mem_section *ms;
>> +    int nid;
>> +
>> +    clear_bit(PGDAT_KMIGRATED_ACTIVATE, &pgdat->flags);
>> +    s_begin = next_present_section_nr(-1);
>> +    for_each_present_section_nr(s_begin, section_nr) {
>> +        start_pfn = section_nr_to_pfn(section_nr);
> 
> 
> I may be missing something, but in pghot_setup_hot_map() and kmigrated_do_work()
> we seem to iterate over all memory sections. On large memory systems, could this
> become a bottleneck right?
> 
> Since hot_map is allocated only for lower-tier memory and the hotness
> information is primarily used there, would it make sense to skip scanning
> higher-tier sections?
> 
> for_each_online_node(nid) {
>         if (node_is_toptier(nid))
>             continue;
> 
>         start_pfn = node_start_pfn(nid);
>         end_pfn = node_end_pfn(nid);
> 
>         s_begin = pfn_to_section_nr(start_pfn);
>         for_each_present_section_nr(s_begin, section_nr) {
>     }
> }
> 
> Would this approach be reasonable, or am I overlooking something?

I didn't just yet optimize the walk. Since there is one kmigrated thread per
lower tier, this routine already is aware of which node to scan. We can limit
the section walk to that node instead. Something like this:

static void kmigrated_do_work(pg_data_t *pgdat)
{
	unsigned long section_nr, s_begin, start_pfn, end_pfn;
	struct mem_section *ms;
	int nid = pgdat->node_id;

	start_pfn = SECTION_ALIGN_DOWN(node_start_pfn(nid));
	end_pfn = SECTION_ALIGN_UP(start_pfn + node_end_pfn(nid));

	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
		section_nr = pfn_to_section_nr(pfn);
		
		if (!present_section_nr(section_nr))
			continue;

		ms = __nr_to_section(section_nr);
		
		...

		kmigrated_walk_zone(pfn, pfn + PAGES_PER_SECTION, nid);
	}
}

>> +static int pghot_online_sec_hotmap(unsigned long start_pfn,
>> +                   unsigned long nr_pages)
>> +{
>> +    int nid = pfn_to_nid(start_pfn);
>> +    unsigned long start, end, pfn;
>> +    struct mem_section *ms;
>> +    int fail = 0;
>> +
>> +    start = SECTION_ALIGN_DOWN(start_pfn);
>> +    end = SECTION_ALIGN_UP(start_pfn + nr_pages);
>> +
>> +    for (pfn = start; !fail && pfn < end; pfn += PAGES_PER_SECTION) {
>> +        ms = __pfn_to_section(pfn);
>> +        if (!ms || ms->hot_map)
>> +            continue;
>> +
>> +        fail = pghot_alloc_hot_map(ms, nid);
> 
> I may be missing something, but after pghot_alloc_hot_map fails, we continue the
> loop. Would it make sense to break and go to the cleanup logic instead?

There is a !fail check in the for-loop due to which we break when alloc fails.

Regards,
Bharata.

