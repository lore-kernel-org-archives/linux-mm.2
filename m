Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FC9AF417F3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 15:56:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DC376B0089; Mon,  9 Mar 2026 11:56:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 089526B008A; Mon,  9 Mar 2026 11:56:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA3F66B008C; Mon,  9 Mar 2026 11:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D96D96B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:56:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 318388A53D
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:56:09 +0000 (UTC)
X-FDA: 84526976058.07.F1570F6
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id AD71F4000E
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:56:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="kXHn/IKy";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=woNLhlFD;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf11.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773071765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6WB0Y/gXM3D52512s+/sE7CNxD2uckgxpav93xX7BT4=;
	b=8sAuCjgg8AZ5Chj2IZyzUnWHIHQ9tRcle1SlqrXZHaXNTxR0OICC0IWxTt8MTK82OudU8d
	jncOIM3htJpNDhczwjIGDHXBSthBTbe+jpvdVmVMbVhX3X+7jMZxq1e3E7G3GG/suwWXgY
	pi+QnGDO1JqVf6VCUe8GeyYG9lJHMUA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773071765; a=rsa-sha256;
	cv=pass;
	b=mNf3GzebIYpEVs4pPPHAhYRz7vRXdZCzVLaEHjrDBmyK8Mq0Tqd3ZdzvC2KnlD9igFPvRo
	Eyagr9n4VeNEySGR0B0vq8uotANWOb26cjDFdUPQ05x8JiNcl3W2U5qvD8LFlgZFcP734A
	x2stGCBSUOR0dH/H0LHAFZ6/t4i5pCw=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="kXHn/IKy";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=woNLhlFD;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf11.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 629EqfrV1787262;
	Mon, 9 Mar 2026 15:55:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6WB0Y/gXM3D52512s+/sE7CNxD2uckgxpav93xX7BT4=; b=
	kXHn/IKyexSxCue1Mjeg99J3YI6gMYygNCYqhJPwflVHtSaSz3oIFKw7mRF5RdNL
	cEWv8I6TWoQ+kyWACVMWeHGNOdu0yRGr20S05J/KZ0C7K3MAq3ceLHnM230EGTmK
	hUZJgeWd8FifDwt6MXb7UksQfe7Z9a1P2AZQhGH7HQdm0ao/w2N0srtxOVRvg6Zi
	0e3pvAPXTdkIX4ZbqhAX7IvGkYJkZb01XdVEeMr3jQXMY21lB+ac5C52TKTgW98K
	59RYNkuPatHk9+jcxRWBSD7UHHjsH2J+DCMVc3KRLmxpzer4vWU/fKvbzEvrWHu5
	y+qQhp+4ZYvP4keaQcSQ5A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csjnuh7fv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Mar 2026 15:55:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 629EegBm007001;
	Mon, 9 Mar 2026 15:55:56 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010026.outbound.protection.outlook.com [52.101.193.26])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4craf8ujfc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Mar 2026 15:55:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nD33++WJbsA3WZIrFjns9Q+T4nC+nTGb1t+Ys67ROnmnAeOGzuMKOiVxNKdClNkNOfliE/0reh0KUx30aWKuDevmzdCoqXuIpmA5h93Cuc87dbFdjVtJDjKessIHggMY3cLndBwEW7/USPV3vnRKchyaKQ3QFkhwR+Pd3fMO870/dKTBb86tV+1ycRw9HFGxECDfVSqHL/jpK1vWIQK2shUVEonweL8FSa4yGDxrtr+y8bfjVBf/CjKjuNTFSprQqQP5hdxdPYtOhKf6x5PL0DgKycyirr0uZDfM5mjl+AVqcqmwQ07QLTj12qEhR5CEkzWOBxTHJ8EARtAuykoogg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6WB0Y/gXM3D52512s+/sE7CNxD2uckgxpav93xX7BT4=;
 b=pblAL/Fa8/R7b5mmhLJe3rZVn4tYMH7DorsqgNwSNPYt6TIIEp/izeNDV1K2jHVfDwW8m7mneuuKlLx94tIXnoJ7dXbaLHvJLw6nIY0iBL8KHjqbJMxIQPrbHikNyBQNxNndbKjAhpIed4t1uWONjqEOmMcv37mxB7YJq1ugIffb19aTDc/duXxOelCHQnZzvSUBXQpTxtmk7LqZ/0sfvymIMRnLgetSfVPVBtFiw1HT0H5bFDVHrCCJmxuO8k9qxlNWnwk5c4O6q+403OYsIJexcSZcDj+6VWFehsDplKmODZnAtRbHV7PelVxC8Nvn8k2Bh26526lj7A7H3OQOlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6WB0Y/gXM3D52512s+/sE7CNxD2uckgxpav93xX7BT4=;
 b=woNLhlFDV+UG7RcipQzF5Ym9ttVcVDEmLCGWaC8wQVvTlHudbDmdqYJkpzFn+11u1Qf7vOj7yihXF/8GNETfO6YfJ7KwQq5WA0IDN00Wbk0TBjHtX+MmTZIHBFJWwauICeDRQfjK6JTA80Ygeunoh8G/6wW6Suky/ieP7Wa21z0=
Received: from MW6PR10MB7660.namprd10.prod.outlook.com (2603:10b6:303:24b::12)
 by SA1PR10MB6294.namprd10.prod.outlook.com (2603:10b6:806:251::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.25; Mon, 9 Mar
 2026 15:55:52 +0000
Received: from MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230]) by MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230%6]) with mapi id 15.20.9678.017; Mon, 9 Mar 2026
 15:55:52 +0000
Message-ID: <de764299-75b6-4059-95de-51b5c2a0e16d@oracle.com>
Date: Mon, 9 Mar 2026 08:55:47 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: prevent droppable mappings from being locked
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
        "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
        Jason@zx2c4.com
References: <20260306204550.8405-1-anthony.yznaga@oracle.com>
 <7c1db5ef-2457-46ff-ab20-dd4090570fb6@kernel.org>
 <2cd5fcf4-9094-486c-b74d-e2db77c4fc00@lucifer.local>
Content-Language: en-US
From: anthony.yznaga@oracle.com
In-Reply-To: <2cd5fcf4-9094-486c-b74d-e2db77c4fc00@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN0PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:208:52f::27) To MW6PR10MB7660.namprd10.prod.outlook.com
 (2603:10b6:303:24b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR10MB7660:EE_|SA1PR10MB6294:EE_
X-MS-Office365-Filtering-Correlation-Id: 12715152-4f17-44c8-8a74-08de7df45740
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	zM7hQ4fXdVzeiCR6HyRQZ8DPjWgj9nL6CTgsNJOHolz8WNlUUI8GcKonQiGYCJ2ur5hge52fyByBWnUHX3RdxbUmp6hq0mhFLBxgzFy4c3bnT8WpwkaLZJiVoIX7K4silt7V4Pq9OFznTHTemaG/jw4DUiVDlZgRk4WRco04YeGvhXNM2arZ4XjUdN6gM8iOeGoa8KAQ9iieD3TzGhJrlQjRIWD3dWBQFEsHo2UiZMcqysVEcM36Ta/DrfVec+cj8jgGAycVLlr+/tP12vI2y9regl3fzNFFxRkKCU3k/fMEqRT4Om//3xaTCwlvGUsmVPK2+sk85PU7F/P1j+3GEMmNNbu822M872HTW0W5QiDhVJAFvIGF4xuHOtolqXMRGxdnOjF2rXGrdu4C8w5l5TiZMNp0XytxxMCzV4NGdOofn5V6cDxDMut86lluYr4kapr4tBe7Yk0UDBhGAsfLIuRNvnpCdGUFsklKwKTyoLx9l4JnaaEbFDt0dOfbvYTh1KmhNjgXCA6EDmjdgD2/QZhPtstixCSCw9ooy1+MQmCpNPaYO8GHQSmEGmZqkkrqXOcgQvTvB86rhIHRk0jwFgZJjfHsK1RaotRHFUdJycRvXASVAaQmfjQvZsceYBK7fiWxqsr8SRBdwAuMx0Mtg+w27kpy82pbZZUR6n768Cy1KkrNL7fkZCqAADs2fc4c7K7oPm5e1x/cfQ4tMn3+SSNqaRpTuieo12XSrAJszw4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR10MB7660.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UFFDS2ErbDlCSExqYm94UzcxMWxGcXZkS0ZlUWhNKyt2dFQwL2pydEF3ZzVO?=
 =?utf-8?B?U2ZsVTYrdktSU3Q4ZWpYajJVMVRSS3ZYUW9XZkdFWDdQTU02clU4eXBYblNB?=
 =?utf-8?B?R2hMMTZuZWFuZGlCbEtRbUlWSmFGaVBPc09iSXd4OFNlWVpLdVp2dUQwQWtF?=
 =?utf-8?B?VDlIRjNrc0xyNlZWM3pOdDRkUG1GMkJOdGZVV0c5ZFBsQ3h2TmREMmsySWhI?=
 =?utf-8?B?RDNaY0ZKYXhpd3FvMnAwdllIaE03U0hWQUJ6NW5RcjBzcCtBaURjRU4wS3l3?=
 =?utf-8?B?aGJhZFR0Y255RlZKMGlMMklqWnJXL0RyTVJEdE1WVFhQMW1PUnltbFREZGZv?=
 =?utf-8?B?NDVZNTdSeWdJbGZVRHlIUWRZY1hqQUozRXltVEVsUlY1Y3F1cS9CLzBtTnBS?=
 =?utf-8?B?aElXT3JnUFVYZGJaNVNQb3VEbkRjKzFVdlZFVTgza1YvK2RyZlNMUWI2VFpD?=
 =?utf-8?B?enNrNjhXZDhqUEtBVEZ0RkdpTjdGcGZNYkluN0c5UG4yVFRYUXA4UGFCK0Zw?=
 =?utf-8?B?SnMzYk5udTZJSS8wOTV2YUZQTkdLTHAwK0tHL0tXdm1GWUI4ME5TeGtxamxO?=
 =?utf-8?B?cDREaCtIRk5nWVplSHl5ckZRZnBPN0V2MVBISWU3RktEM0wra01aNmEyNUZG?=
 =?utf-8?B?dm02NDd3eTdRVmxEVHBnQlNXZGZLdHpIQnhLNjM1UHN0Nng1ZlZJbThUd1RP?=
 =?utf-8?B?S2txNDQzb3hTQm9SM0Zic09HWm9YbzBRMmRNcDc1UkN1RXZxMzJLNjR1T0Jz?=
 =?utf-8?B?K3diTGhJR0hEdGZWMHU4MWN0N1V6QkNyaFR5elJSRjBCc3piNkx5dm9MU2FO?=
 =?utf-8?B?M3FEb2piUmlTTUdPWHNWR1Z2UHYvZWhsaitYdkdLcThUazNZN3FUQU1JeUJp?=
 =?utf-8?B?QWhCeXFyMzNKUTE0eWxRdlJYZHFoT1RoTWVHSE1oTnVTSUNLdnkyTjFPR2hH?=
 =?utf-8?B?ZkhHQ1IxWjBNL1lwRHZsZUZsbGIwL1lLMTcwVEdPaXdpeGZPYmduUGhFSVRw?=
 =?utf-8?B?dUErWWZnd0FoOVZ4MTMyVHlsK0h0cFAzbDRkUkpSRldEbW5TNWRMUi9nTlhi?=
 =?utf-8?B?Snd4d0RwSmpmRTJuUitKWHVTekZnZlRjN3ZhZHF1R1IvUXlERUh0dGNGdXNa?=
 =?utf-8?B?Z0c4b1hQWURacjZlWCtDckpXMEVkZFovVzJzRUVjMUNIbkNScGFlMG0vMFVH?=
 =?utf-8?B?U0NvMVFoZ1RPZGtlK0hVYm9pOFM3VEZsaGZva25sMkZhWEZuemZKUFl6ZzB2?=
 =?utf-8?B?WHRRMDdoaVBSNFc4Mm80UlE2VHlHQ2ZBODFVZk5mREhQK01VVkg3M0pIVFJj?=
 =?utf-8?B?YWZzQUJudkR3OG9FMFN2ZWNHN3ZrZFNnQkR4c0tNMmptUkRTRlRUZzM2N3FE?=
 =?utf-8?B?SHU4Y0dUdEtka2RlMVQ5ZlFZRzVSalpqUlJNMGdiUFhXQ1ovNzlXMFZTbHFZ?=
 =?utf-8?B?SHdrSWZ4RFdJU2dyaEdqMlRkYUZpQVQxeGxkVnBWZHp1NjI4TDF2YXRrZnQr?=
 =?utf-8?B?Q1M4TzRTaG9JU1FZUjRqQVNxbG51TnZGMi9BOE5QVG5EZXdyUzdLek9sV3pJ?=
 =?utf-8?B?eFBNMTRsODR2RG1yd3dsa3h3L1l4NGdZcytjaFpyUkdxbXBkWnEzc0p4Zkg5?=
 =?utf-8?B?dzZTL0t5K2pSSlBneElLeUFETjdSREFUOTk0akRyZUJML0tQMnljVTl3eGRh?=
 =?utf-8?B?K3RQNm5hZStPR20zeTlrYzl2NWcrenl1Um9YVzN6ckw1b21NVUhKNmNnRlVG?=
 =?utf-8?B?ODQ3QkJPaUNoRXl5TlRaVzFwTWhuUW1EajBXOWFSV1hMWXRWalhCZkFjeEpL?=
 =?utf-8?B?Sy8yL0FmNytYdUtDWGdPUjZ6TU9VcmRDeS95UnJ2UmM4ZGlQbkJLTFJ6WUdV?=
 =?utf-8?B?MVpHdzZnNlJVU3M0cnhRaXZwRmNQQzBkMktGVFZySUNWaVpSL3JxQy9Bcm9O?=
 =?utf-8?B?THZDZno0QUZIWnd0NVVLcnQySkVvQU14VlpMQWtQT04wcHpvUUh3ei9UeFMz?=
 =?utf-8?B?QjVSU3h6QnVRbkNpOWU4Tlp6Tm45TGYyODlMc3NITTlYakYvZ2VRT20yQ1VY?=
 =?utf-8?B?VFdubVpLcVZPUUtWeE02MHRWa1Q1RnQ1MEU1R1J0ajRHTk5mRGJ5SE1Qd2JC?=
 =?utf-8?B?NWlkajZRYU9Oc3VUdlRkN3NUVVZha2ZQMk11ckwrTmdJYkIrSzZ1UXZuY0t1?=
 =?utf-8?B?T0htRDBPVzdVRmRxUVBEdUl0WmFEV0JTRUhteU5lZDJMZ0p4ZVUxYWJOL0p2?=
 =?utf-8?B?ZHg2K3hiV3RtV3R0R2RIbmpTV0JzcER1ZWlJL3ZxNVlCK0JqblRDcE5rRGRO?=
 =?utf-8?B?VFlnalJyaFZpTkJPNFdLYjRxSXlkTU1BMmRJcktwZWprcWwyR28ySDA1WERs?=
 =?utf-8?Q?FBLmuWdX6cPZ7jlU=3D?=
X-Exchange-RoutingPolicyChecked:
	f8dqAgdONwCb8maz4EqNiGwCa12UXSbbJZrHSGLM3uv1wrMeto2l0P67Df9EW559dOiLvOa7Iq/ujH8fIws5cdyKxhiDoNyBK29oqACkePF2xukSUVslyaNrPcJVuzoHbREJxreBh+fgSh7dMVMGvyYThzHFV6mbQE5AeJAodsB+0708dHO1MkBsM1ar/uRSIpZMuUmYH53lHvULmm2/iyVpWn2vasktDjedQ2um4qSyaIA/gT4dKPmc2MRs2OIEfmdupil3I7A3mDz0Q06NUsm5axWN5DQgudVX52j/PokhLZAfXOyMTu5ysSedLBMefyofXEAar3q2a1+Eer/swQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HbJx7dySg+U4zySr34lMfw83tRi18d7NKAAyoY2NtYY6/jpUHswp5INwVl99+j/g+a9AQqIWWbxUykvHSRyUU7D0p5Ibn1WMG3FXHudvTiQiD3KvZxwSMUIYWgUh9Bh5L7lKqz6//GlcCS/NjrPTRnFOJCdTg3+GFeZFDDb22qN43xOxEr0Owdgu/zJ7ajw6MW5TQYUwQ9XvHvKWea139L81qZHSsc6Nk0M3XZG94qK8/cN2rcBPJ9Xu5bbWrQcvJDiBbhJV4uPecI3SEuGE5DP/utI54chH3n64Y2/hq5qCSZLjK0Elncru2oJaxpa0TYima5IX/x396ga2v9wsQTQ/V3lK61fSs7o+FjAUhrLEiRmNWq7hUl99CRQojxbn/BPtzv2IsJKlxc//gg+g5Tey8mMI9RgKETYSjJCLsrmdXpo5yh8gRkLw1xSYCheqQwlkZJ1QzKGalYn6Ku4y95gHMNnHaTuizbYGQ8wVbKsqa9ThYuDjowicAw+0nh0KfRzyMHu7ba4LmcwkTlfe0MHzIIFe/UCso0S2QE9MrKO1Cecg+Fhqiwrs5Q7hFktzuYQBja8ZLdYZ/GDPvWHwOXIgdNYRn6qlWSxbjpg06tI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12715152-4f17-44c8-8a74-08de7df45740
X-MS-Exchange-CrossTenant-AuthSource: MW6PR10MB7660.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 15:55:52.4855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ikLqeNpah0lp49VD1DXLtVL/60eG1AOgO7G2EPGjy2Yea7jy2DeHKyTrtAx6hVljiL+kuIB3AOCcAM7wbo7rxJ7DGNGiAaOyy8ufztLnIjg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6294
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_04,2026-03-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603090143
X-Proofpoint-GUID: fAzP8vwBs20QIg6MirWWMEJUfTdNO1D3
X-Authority-Analysis: v=2.4 cv=c7WmgB9l c=1 sm=1 tr=0 ts=69aeed8d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8
 a=F0Isg_IVgsN5smBfelIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDE0MyBTYWx0ZWRfXzjosTB2KHXd2
 IsDyeOhLjLJu3FZ49f3ub23xhBCDCluqCarUWRdXoWfiJpwFWlVQUe6dBBh3dI3Rqqpawj2bv0b
 NhrXsIvw/moMow7Zrlnzpw+IXGwoaTPA2OgdAp+ooVXonO1uZmU3MReCkzRipAUc0XZNKbW/X0p
 3JUPis+ibt8mo52IKZCv4SUua8pPqg2yduTAuIUS2xpznfvSzbsA7XxNX7r9B+J9ZMvEtHqpGUW
 sVP/kRav6WW3DvH2GJ531ss5dXHWp228pGBJidWYQfYsgBp4Qcu+Bp2B1xjfQs+FAnWs6an4qX5
 lUyi4AILp+O8sNPqcuqk3ry9lLm3hY7EDxzdSw5valuni0jv8E5FZPM9HlYbmQGHMJeWQEYioyv
 YhTJwP7Dz8M7wXEh5WzFBMmfedO1styo0Rjawft2mTIQhxSMjlHWMRMawP7UYzK1Om8blBkUgU3
 XoqimdNzp3c84iCIHlw==
X-Proofpoint-ORIG-GUID: fAzP8vwBs20QIg6MirWWMEJUfTdNO1D3
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AD71F4000E
X-Stat-Signature: w6uzwzhnabai3tdnyytaqig5zfxpayox
X-Rspam-User: 
X-HE-Tag: 1773071765-940052
X-HE-Meta: U2FsdGVkX1/DpzaXEhO603oniirv/YMz0KQ77CAwA8FLOVNEYCCpsd/siSiaGdNnudesuivf9x/Ny7q8PQvc5hvhf1oHgGBXwfPuDPGgp/sL3jkSI5x67m8eTmCwR+tIQTx9Igch2w3jfx6DXD5DlClPpFDkuW7ojihzsmtIIxrvl/JNR//UVshVjfBkSChsJHoytKzGBGAfWhlx2xunIQZjuRp4ziV0bAwqwO4wcxYiK8fUIQMDHxAkEkg28kothSBGZAy1PW9cfEPOhsLFQCTZYu+JY77hmuApB1yoNnDgdu5mnDnZV0cvQ93IOjKvozsDePINx0D+ibCbNy169G52jYA536AMRC2D7F9h76tvIQ3tmL3OBucrK2pxUbVt+cUnVBPTo5htkYc2HsQp/4CJEkU4aL/4qqPT1wkvImX6eh7ojDeR/hqbxHvrvaYDioRhn6CZonAYmuOiUF29Vct6KkaZaGK0J6fo87G5pVsCBuWTB3XEBeAdU2TwepDjFBZ/U4aSJUUNVTPx8o5cmlKAvaQPAKQNWhauXDb/zAEBYYeMoIuBwBqgY6ZiJKzOilwIEosSspXTcDl4GmlSEvbmueknUUqZfaNr1goMHLia0kF9fFsI+67eVzOeB/XA0OUCZVxDDDTPWVqi8RBLMrZJC/iRKXZoFi301HC72ZyYrtq28KKkGtnNh0zesnc0tzBqVbPvX3gHtjKq7yDvQLbyI/xfEu6PMj6TcmsjJhDYGgkWeH1BoEdRVkbSaJY2m86Qtqv0HlOVwDij2KOCx+pbZY3beca0yPdfIurcRpQieKxUgYVbuUFZw/m6qd1S/7rinM3k/D+8qKYgL2ITBox+lQmcpn98iV9LecmOoKl2pOf8FElneZUi5KU+mz1GrEQfkMJi3PJXt6yqYTCXXAnPN/AEmqpbpt02F3Di+xXqzIS4/82K27lXw7zN0RBFSsg3r0NPF/d7Oii4V29
 OK6KVIhS
 Nhfs36l6qv/2ztNCH9305ITIvM4hDjPaisNbkqwXWbzQq8uR/tQsS0zXN/T+QCicwb7uwoptNDBKNZxz11vElTc4qk5DolMW86h8X0lA+kYi6V/B2sqpcoB1VkilOlPdEYgnQafeanagTbxNMxKdJv2agi3x2j+5GVELlZnfy+Cl9ba0CRs1axYKAn9lvqYSZ9b3eh19z7vjfwN+79f+eYAy803QsgIpsg5QW070TlFq7jd2jXFx5mccL722BunHdoeZn/We2kwAeRC5gPxbyy5jGsABS/h/uvqUYIuhUnLEt1e/uRpdMieG8WO+NBZ7NgwXaHsAGg0ggesanjp4o8D3Db/vl5lWxfEtne/8GqkCYN2/CIJMdFV6iTJiFVIZZzEqRJpjWitbaBmXfvfgkoAF07G+DlZqZSZZ6LoMnyC+R/LxZu4a5A/ZgBeLxeHJjnGMGHQq6nHw6CmZtXNFIRQtlmQtao+E4Iy0S0lz6irtcFHyNFIJgS+rHXdX2usUDz6vPoRT4oehi6OxGsXthL3OUFl+mCKsKFJQoJB6Jeo6pIXKQXRrXoRMHJdTBPje9Gztd/voBrCoYQG99daXci5U3Qp1PJhqvN/q5sNa7/UfTbArHhYaJC+OFIQpHpCcqC7zx5C17ljdOKgrp5CjERSnv3OGURyQdwCWac6DvfzzdWOm90PxlaTZPMlS/MFU598TfuHNn0UcYmdkBnnqnCvg43w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/9/26 7:31 AM, Lorenzo Stoakes (Oracle) wrote:
> On Mon, Mar 09, 2026 at 03:15:24PM +0100, David Hildenbrand (Arm) wrote:
>> On 3/6/26 21:45, Anthony Yznaga wrote:
>>> Mappings created with MAP_DROPPABLE cannot be locked via mlock() due
>>> to the check in mlock_fixup(). However, they will be locked indirectly
>>> if they are created after mlockall(MCL_FUTURE).
>>>
>>> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
>>> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
>>> ---
>>>   include/linux/mm.h | 3 +++
>>>   mm/mlock.c         | 4 ++--
>>>   mm/vma.c           | 2 +-
>>>   3 files changed, 6 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 5be3d8a8f806..bb830574d112 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -574,6 +574,9 @@ enum {
>>>   /* This mask represents all the VMA flag bits used by mlock */
>>>   #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
>>>
>>> +/* This mask prevents VMAs from being mlock'd */
>>> +#define VM_NO_MLOCK_MASK	(VM_SPECIAL | VM_DROPPABLE)
>> Instead of adding that, could we cleanup further by doing something like the following?
>>
>> The usage of "vma->vm_mm" must be double checked, and we'll have to take care of making
>> the tools/testing/vma test happy.
> Yeah Anthony - please do a simple:
>
> $ cd tools/testing/vma
> $ make && ./vma
>
> To make sure that your changes don't introduce anything that breaks that.
>
> If you need to add duplicate header defines put them in
> tools/testing/vma/include/dup.h, if you need to stub stuff out put in stubs.h
> and if you need to customise something for testing purposes, put it in custom.h.

Thanks, Lorenzo. Much appreciated!

Anthony


>
>> Not even compile tested, so will require some more work.
>>
>>
>> diff --git a/include/linux/hugetlb_inline.h b/include/linux/hugetlb_inline.h
>> index 593f5d4e108b..755281fab23d 100644
>> --- a/include/linux/hugetlb_inline.h
>> +++ b/include/linux/hugetlb_inline.h
>> @@ -30,7 +30,7 @@ static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
>>
>>   #endif
>>
>> -static inline bool is_vm_hugetlb_page(struct vm_area_struct *vma)
>> +static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
>>   {
>>   	return is_vm_hugetlb_flags(vma->vm_flags);
>>   }
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 6e1162e13289..b70ebbdafe00 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -1242,6 +1242,15 @@ static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
>>   	}
>>   	return fpin;
>>   }
>> +
>> +static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
>> +{
>> +	if (vma->vm_flags & (VM_SPECIAL | VM_DROPPABLE))
>> +		return false;
>> +	if (vma_is_dax(vma) || is_vm_hugetlb_page(vma))
>> +		return false;
>> +	return vma != get_gate_vma(vma->vm_mm);
>> +}
> Yeah this is nice.
>
>>   #else /* !CONFIG_MMU */
>>   static inline void unmap_mapping_folio(struct folio *folio) { }
>>   static inline void mlock_new_folio(struct folio *folio) { }
>> diff --git a/mm/mlock.c b/mm/mlock.c
>> index 1a92d16f3684..e16b2ea234f7 100644
>> --- a/mm/mlock.c
>> +++ b/mm/mlock.c
>> @@ -472,9 +472,7 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
>>   	int ret = 0;
>>   	vm_flags_t oldflags = vma->vm_flags;
>>
>> -	if (newflags == oldflags || (oldflags & VM_SPECIAL) ||
>> -	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm) ||
>> -	    vma_is_dax(vma) || vma_is_secretmem(vma) || (oldflags & VM_DROPPABLE))
>> +	if (newflags == oldflags || !vma_supports_mlock(vma))
>>   		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
>>   		goto out;
>>
>> diff --git a/mm/vma.c b/mm/vma.c
>> index e95fd5a5fe5c..b7055c264b5d 100644
>> --- a/mm/vma.c
>> +++ b/mm/vma.c
>> @@ -2589,9 +2589,7 @@ static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
>>
>>   	vm_stat_account(mm, vma->vm_flags, map->pglen);
>>   	if (vm_flags & VM_LOCKED) {
>> -		if ((vm_flags & VM_SPECIAL) || vma_is_dax(vma) ||
>> -					is_vm_hugetlb_page(vma) ||
>> -					vma == get_gate_vma(mm))
>> +		if (!vma_supports_mlock(vma))
>>   			vm_flags_clear(vma, VM_LOCKED_MASK);
>>   		else
>>   			mm->locked_vm += map->pglen;
> Very much preferable!
>
>> --
>> 2.43.0
>>
>> --
>> Cheers,
>>
>> David
> Cheers, Lorenzo

