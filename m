Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E807FF4941
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 04:46:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8EC66B0092; Mon, 30 Mar 2026 00:46:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B65FF6B0095; Mon, 30 Mar 2026 00:46:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7C0A6B0096; Mon, 30 Mar 2026 00:46:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 96D6F6B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 00:46:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1FE7D8C32F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:46:36 +0000 (UTC)
X-FDA: 84601493592.14.6B184C8
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013047.outbound.protection.outlook.com [40.93.201.47])
	by imf02.hostedemail.com (Postfix) with ESMTP id E30DA8000F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:46:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=wkIKLMSY;
	spf=pass (imf02.hostedemail.com: domain of bharata@amd.com designates 40.93.201.47 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774845993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DyrqdJUcmq03H96fGIEKHLnzq/UgP9UdVM0CH+pn7N8=;
	b=s4g0KkY8/Tlip/k1+CVj82CqAWbG50wijPKBp+aiy4i0Vfsy6YCV08PanA8EyIvnwIAxLD
	p5Ft9OfcKJnJgboqYymibBvLtdgZwOrsY1T+Mbk/BApVdGkZes/jmTYSQs2Nkl5QsA851c
	Zu4wbcMmmQbtaItn6+2UI5bhbm8W8KM=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=wkIKLMSY;
	spf=pass (imf02.hostedemail.com: domain of bharata@amd.com designates 40.93.201.47 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774845993; a=rsa-sha256;
	cv=pass;
	b=d4boS/gVSHC48XiSPiXimfLru9MFlKLAQQvmmolTETVCUgqCHHsAIYpoKcdB9botk227WA
	+hFkHSTg/cG8AVJj8iNsSM+rzfYMYHA5rcmzw+SikmmtAn1z9jTgfnWqSd8cJxakMdpksE
	Z6R/7Gbts8ak4JsDFjfvhuwJp/ZfmwE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ij4vKd91KKUg/Xr6pOyqtPKXiv3z+k3jxjswdRoEZjoOzzLeVNZ8hWH3KRyO9AcfZs8XFhv9i+pQcpja8SMbamdK5r5oQxNTruM7Ra4Hxw6ib2+/g/KkFKiA60taD5/9RelSsDqZeuu6zLr2cMQGHrtqAEyg/5IyPwEkT7TQMhjjD5KKCQtrqhQA4qbElLQxx8eunPJm0ZAa1pKGMuSxAfS+elk54xEgJUcFLejK6z/pzhhPb7ONO8fDSXBiak+zyqmkAAwreifnMLZfrYo01FmBnynq0j+vYzA1kfdcRudndHo7C+u5lSj8o9AuJ6MCVr8ekfeRpAXZNjeSawqrFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DyrqdJUcmq03H96fGIEKHLnzq/UgP9UdVM0CH+pn7N8=;
 b=uooFi4D4at4XUWLekY8xFuhxYxwjOZdr/mzTk1Pwu/qJALT4dQ7oKoCH2mvoroW6ZsgxloV21P4d3JuI0MfGS/YPoN1eD25SufckFYVBV1g9DT2AHb99vtb39jEM9cv99HNwB7nrHs/yEcovX/05s94bUnuXGODxEbDYPCF3gabG+nBSuQXp3aMIuIanGUVv9W9M2mPBUuvMUxcKt98AU+7UQO53h6QqkEPT3nZoh09DlMI4o8oem3oIeBZJDa90BW+t0BZLs7/+Z+S569OMuUc9ndc71W7KBRfNDdAUmxSDeBD0Gvnk1EqqkVa1jT3l6A84MqZiu2Xu6a8QLpm0Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DyrqdJUcmq03H96fGIEKHLnzq/UgP9UdVM0CH+pn7N8=;
 b=wkIKLMSYk5yeHFf7/oyIDQYTHfIJOmcoQNVfnkN5EY0aZ0oEvNB/hwgqo+qGXDXcEoyLsiH9jlpOO6Yfy2oF3YLxKApy25k9imgU7tzN5Sz8IlIZk1lewZ0tPvavBkob8yOE9ddskXlW38mYWLXTwIr+QDwy1MCW63vlrPml9cg=
Received: from BYAPR04CA0016.namprd04.prod.outlook.com (2603:10b6:a03:40::29)
 by DS2PR12MB9822.namprd12.prod.outlook.com (2603:10b6:8:2ba::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.14; Mon, 30 Mar
 2026 04:46:27 +0000
Received: from SJ5PEPF00000206.namprd05.prod.outlook.com
 (2603:10b6:a03:40:cafe::e9) by BYAPR04CA0016.outlook.office365.com
 (2603:10b6:a03:40::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.28 via Frontend Transport; Mon,
 30 Mar 2026 04:46:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ5PEPF00000206.mail.protection.outlook.com (10.167.244.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.21 via Frontend Transport; Mon, 30 Mar 2026 04:46:27 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 29 Mar
 2026 23:46:26 -0500
Received: from [10.252.223.214] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Sun, 29 Mar 2026 23:46:19 -0500
Message-ID: <12112823-f4b7-4854-a32c-c40985c65521@amd.com>
Date: Mon, 30 Mar 2026 10:16:19 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 5/5] mm: sched: move NUMA balancing tiering
 promotion to pghot
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
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
 <20260323095104.238982-6-bharata@amd.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260323095104.238982-6-bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000206:EE_|DS2PR12MB9822:EE_
X-MS-Office365-Filtering-Correlation-Id: e4b5f041-b1a2-4884-2d4c-08de8e174dc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|36860700016|376014|56012099003|22082099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	WXLZ9q02rpnkRbbM4jWngniHQHf/kudJ36xm2RGafIjXyfLcBx/FXldnkmQ9V4qiSS6MDkfZdGMdyIww0rn9s3/mHkBwvlOyB0KGIrLWiVXgcUUZJOp4MNd3z3cBwWGNFkYjZztb7AS0g01leEWuD3r74rgZYIYafLRLJuGoHj/SXqLnma+IUKHdVC314N+WJyAYw+uBc6ALJarhGB1Q8HGXl5hmbI+LXtBvU210eG7+dFHWem+tRaLGu62TqAynAEckoasTaxGA9cjJd/nuDrQFYCq0Lzqap3rCt/yEBFJne9hUKHru/DFufcdsRLup2PG4wWJ2xFLHhEU50jKiyaZeUaBBVgxf8qaSuRG7cgypnHzrvAHs9iH3pZT0eC4BoinEcqEyHogVZmzI1JiippWzjH28lr3C/Ykf17RhD7lSst+Z+3Q4gEZe8Gvk7orA0JWzrrYo9yW+8MpkkfW+LFXvsO4XHMhlD+AJBfNTjFenF1w2Y0v0/w1BmGlmJnZt4Kwkcmiyzt6YtiyPer19Xwk6CURWs5dZBg/rnI/VdiKd70gV4iVt8OBdeMXAYy1pEa48bc8uJt81dxt96GJghtnv6vIJHnk9QR6E/Z1RmPeJfzmJsfuPVDmvKVA8xiPHSmHu2C4KtcuZxN21C1inSctQ+3Yz2blbVesIHU1YHABGYoeE4JDWBo33uO5bvRvOdl6JKa5NS8OW6jyeQyaeqw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(36860700016)(376014)(56012099003)(22082099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	urtwY+ECSojrIoDL8p/qnzyzFQDDqu2nHaI3r/3G91PebpH5werM+Ccf5Il0zXC/u9WmgpF6pJPI9SMI50snD9OjW89CLynTGXTVBwTmAoyhpZgqnGFJq0Kg6hMA7nMv/H1nNmRfM3yIuWjh3Sj0RBmsQL/Oj5Kdq7zAVFs1qT60A8lYs3kmN7mdjoZbvT/ra8nlOa+HZyL2EtXYn8pa+b7A4vt/H+91sXnl77KuB8LuGMBSHYLrjRIkMDDEzh/hA4ch4qI2gqpzjvSL7kADwG8YG++itywih70BhcawUpC7Y9k94O4X8PtmUfLxvlPKyGlOIB1xkuJu0u7vM7di6yRlSCU8wUwuvosuUxSp5npeDcdgaFbFbmtv4Re+sYZVr+PhpszabQQJmjpGEH1xHMToVuYwU1zK9QAHkec5F+bePo3flIoNCSKpIftWAbxZ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 04:46:27.2201
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4b5f041-b1a2-4884-2d4c-08de8e174dc8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000206.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9822
X-Rspam-User: 
X-Rspamd-Queue-Id: E30DA8000F
X-Stat-Signature: wd3h1sjb6r1xxakiykerww1zohntwzkz
X-Rspamd-Server: rspam06
X-HE-Tag: 1774845992-464769
X-HE-Meta: U2FsdGVkX1+oR3YY/m5+ulNi8PFJQbUHkJkW97DnTKNlwRKJtGJTFFUx64ihzjzrgVNpLd9stXmNhknwYRVIAQ2kYe0nA0pPkgcuAHKP8pdiD/GJsteDWI27eP+d2iy4Y6zfzEE8IJg9hANx87G/qQBq6B2OMz3DP3ld2unnvHHHv1fkhm6DSLiPfeGYZeqZ63/+1rEEgfxttBvSFo+nEq/9C/z2NuFytm4iffCEKtCzjeV/6lZyOrDeIQPKJ/9sMykJ/q6owLeeY3QCI0tmIK9IBAu17cbCkA2LhXV+hF2Ib7u86jfnrlMzBVyzFgs+EfrYiIiUFfc7bMjp3kb4UH3sBIZdsRqU9OvJ5ye5ukRCm3suljAo0nBuwLdZLK++LGvJFXgnmF/giIhcBejEwQlu429rwwArURvzbj85vzI9q4l7SRrFZEfP39EcHwLnRFEt/gsnOc0fOzSUflapOcjMKndsexIRcga8D+n6jNo66tY782PgyAg7sNnMVXvL17bvtH7jnmHXNZgM2vosHQjW19Wi9qMgZNMqJg5c2RYI+0M9Es0JKydHpb948leuv9sb935OSp7KXwV2CNakWD+yWs6eWS/vGECsEJ517ShCCxbm2fsEkudcqpjeS7aN4MS5cnyzWEhOjRMLluntJ3eIOFS9IcalLKYdilJlICVPdFzD/r6MBf3jxgK+8PQBlCdJreUEZTHcKmbvjuU6mnWcyb1ZFLYa74+OO9UPNA+NzXu5uGspE0HWB36/50BAztoJ07EytoRjy9BvQl6YWAyMtHLSloSXNTzCaPa3JEYrpLqb5WsU+S2FxA66uqa/ooDleNgfK5WYIRvMSbFUEXIRD3GYn+WmOTo4uBzoxu8hI2JrNr8sEzFCEMd0CT2DNvClzdFl+VD+ZlKCxdgzNH3AnZb3kGCiXrYG4PahDDADuO9kojxlqUtaIRuShso0OmU5PrmSVmy9iyB+7Z9
 R3mTEpYh
 ONvsDFyaiJEOvqUIwssmhdn9JQXa02WrlmIkQJlnjWbV83UTiA3fQ9RvmAcdhuzc5oYFq1/TfdhknB3DfwlNDxFackvteq7/wh4sAxyCKC8HDKN8jTCs8vj52DVs9WRBVTVwn6kEfblRjY8MzzLx5uXR10BAWftisLwKKjBF0eOWic6cxn7EwXgXt7PxDfrHo5S9BP6Hd5yLy9e2rD8D4C1E1swDVPMhxforSTYZacvfg14iUKZg8ybyXTT6ayunXaMQ/Y7Nun3hiZFexZVGQwo7IyC3K07BRs8VS1mlTLKNklVOlaJXKTzIySUYCMjelLL9sj7oyqvs5H5wwRfrPb9nEVZosBwrsqXSMLvrglnvBmauSfwC78e0AA/Nmel78yJpkuQmgznKNjJ5rNOUSSL7VgO7pda3jZlnOMlNy43vRyhGzMQkJ8L2VY6KY67iDP5Qhsru2iWMYgVoLcvDL3xrfAqJF3WhuCL6mx4BkZ+EnnXYTVXce4V7Cgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replies to review from Shashiko
[https://sashiko.dev/#/patchset/20260323095104.238982-1-bharata%40amd.com]

>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index b298cba853ab..fe957ff91df9 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>[ ... ]
>> @@ -2217,11 +2218,26 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
>>  		goto out_map;
>>
>>  	nid = folio_nid(folio);
>> +	needs_promotion = folio_is_promo_candidate(folio);
>>
>>  	target_nid = numa_migrate_check(folio, vmf, haddr, &flags, writable,
>>  					&last_cpupid);
>>  	if (target_nid == NUMA_NO_NODE)
>>  		goto out_map;

> Does this code inadvertently record pages forbidden from migrating in pghot?
> If numa_migrate_check() returns NUMA_NO_NODE due to memory policy, the code
> jumps to out_map. At that point, nid retains its initialized value of
> folio_nid(folio). Since nid != NUMA_NO_NODE evaluates to true, it looks like
> pghot_record_access() will still be called at the end of the function, which
> could pollute the tracking map and trigger useless daemon sweeps.

While for NUMAB1, we need to call task_numa_fault() to just record the fault
stats, the equivalent of it for NUMAB2 isn't necessary. I will make the call
to pghot_record_access() conditional to this scenario.

>> +
>> +	if (needs_promotion) {
>> +		/*
>> +		 * Hot page promotion, mode=NUMA_BALANCING_MEMORY_TIERING.
>> +		 * Isolation and migration are handled by pghot.
>> +		 *
>> +		 * TODO: mode2 check
>> +		 */
>> +		writable = false;

> Can this cause a regression involving spurious write-protect faults? By forcing
> writable = false here before jumping to out_map, the write permission appears
> to be stripped from the restored mapping even if the page was previously
> writable. If the application access was a write, it might immediately suffer a
> spurious write-protect fault when it retries the instruction.
>> +		nid = target_nid;
>> +		goto out_map;
>> +	}

Since there is no migration from the fault context for NUMAB2, we don't
release PTL lock at all. Hence I realize that I don't have to modify
writable and ignore_writable at all for the hot page promotion case.

>[ ... ]
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 2f815a34d924..289fa6c07a42 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>[ ... ]
>> @@ -6086,16 +6087,31 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
>>  		goto out_map;
>>
>>  	nid = folio_nid(folio);
>> +	needs_promotion = folio_is_promo_candidate(folio);
>>  	nr_pages = folio_nr_pages(folio);
>>
>>  	target_nid = numa_migrate_check(folio, vmf, vmf->address, &flags,
>>  					writable, &last_cpupid);
>>  	if (target_nid == NUMA_NO_NODE)
>>  		goto out_map;

> Similarly to do_huge_pmd_numa_page(), could this also inadvertently record
> pages forbidden from migrating when jumping to out_map with an unmodified
> nid?

Same as above.

>> -	if (migrate_misplaced_folio_prepare(folio, vma, target_nid)) {
>> +
>> +	if (needs_promotion) {
>> +		/*
>> +		 * Hot page promotion, mode=NUMA_BALANCING_MEMORY_TIERING.
>> +		 * Isolation and migration are handled by pghot.
>> +		 */
>> +		writable = false;
>> +		ignore_writable = true;

> Would forcing writable = false and ignore_writable = true here also strip
> permissions and cause a performance regression from spurious write-protect
> faults for previously writable pages?

Same as above.

>> +		nid = target_nid;
>> +		goto out_map;
>> +	}
>> +
>> +	/* Balancing b/n toptier nodes, mode=NUMA_BALANCING_NORMAL */
>> +	if (migrate_misplaced_folio_prepare(folio, vmf->vma, target_nid)) {
>>  		flags |= TNF_MIGRATE_FAIL;
>>  		goto out_map;
>>  	}
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index a5f48984ed3e..db6832b4b95b 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>[ ... ]
>> @@ -2796,6 +2808,8 @@ int migrate_misplaced_folios_batch(struct list_head
*folio_list, int node)
>>  #ifdef CONFIG_NUMA_BALANCING
>>  		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
>>  		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
>> +#endif
>> +#ifdef CONFIG_PGHOT
>> +		mod_node_page_state(NODE_DATA(node), PGPROMOTE_SUCCESS, nr_succeeded);
>>  #endif
>>  	}

> Should this use mod_lruvec_state() instead of mod_node_page_state() to
> accurately update both the node and memcg counters? PGPROMOTE_SUCCESS is
> defined in memcg_node_stat_items, so it is exported to the cgroup
> memory.stat interface. Using mod_node_page_state() bypasses memcg accounting,
> which might cause the cgroup-level promotion statistics to silently underflow
> or remain at zero.

Replied to this in one of the previous threads.

>> diff --git a/mm/pghot.c b/mm/pghot.c
>> index 7d7ef0800ae2..3c0ba254ad4c 100644
>> --- a/mm/pghot.c
>> +++ b/mm/pghot.c
[ ... ]
>> @@ -141,6 +166,110 @@ int pghot_record_access(unsigned long pfn, int nid, int
src, unsigned long now)
>>  	return 0;
>>  }
>[ ... ]
>> +static bool kmigrated_should_migrate_memory(unsigned long nr_pages, int nid,
>> +					    unsigned long time)
>> +{
>> +	struct pglist_data *pgdat;
>> +	unsigned long rate_limit;
>> +	unsigned int th, def_th;
>> +	unsigned long now_ms = jiffies_to_msecs(jiffies); /* Based on full-width
jiffies */
>> +	unsigned long now = jiffies;

> Could this cause spurious threshold adjustments during millisecond
> wrap-arounds? jiffies_to_msecs() returns a 32-bit unsigned int which is
> zero-extended into the 64-bit unsigned long now_ms. When computing time
> differences like now_ms - start (where start is an unsigned int) in
> kmigrated_promotion_adjust_threshold(), the subtraction is performed in 64-bit
arithmetic.
> When the 32-bit counter wraps around, the subtraction could yield a very large
> value that falsely satisfies conditions like > MSEC_PER_SEC or > th_period,
> which could cause a regression in rate-limiting.

It could wrap around but due to cmpxchg updating pgdat->nbp_rl_start to
post-wrap value, it should be self-correcting. However I can change now_ms
unsigned int to be perfect.

>> +
>> +	pgdat = NODE_DATA(nid);
>> +	if (pgdat_free_space_enough(pgdat)) {
>[ ... ]
>> +
>> +	return !kmigrated_promotion_rate_limit(pgdat, rate_limit, nr_pages, now_ms);
>> +}
[ ... ]
>> @@ -218,6 +347,11 @@ static void kmigrated_walk_zone(unsigned long start_pfn,
unsigned long end_pfn,
>>  			goto out_next;
>>  		}
>>
>> +		if (!kmigrated_should_migrate_memory(nr, nid, time)) {
>> +			folio_put(folio);
>> +			goto out_next;
>> +		}
>> +

> Does this correctly advance the PFN when encountering large folio tail pages?
> Looking at the rest of kmigrated_walk_zone(), the loop iterator pfn is
> advanced by nr = folio_nr_pages(folio) at the out_next label.
> If the loop lands on a tail page of a large folio (for example, if a
> previous iteration failed a check and incremented by 1), folio_nr_pages()
> returns the size of the entire large folio. Adding the full folio size to a
> tail page's PFN overshoots the end of the folio, potentially skipping valid
> pages of subsequent allocations.
> Would it be safer to advance by
> folio_nr_pages(folio) - folio_page_idx(folio, page)?

We could end up on tail pages leading to skipping of some folios but I think
they will be reached in the next pass. Anyway I will check if your suggestion
can be incorporated without any additional overhead.

Regards,
Bharata.

