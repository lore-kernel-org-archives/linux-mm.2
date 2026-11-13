Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43E75606A333
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 20:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dJh3r2FG
Received: by kanga.kvack.org (Postfix)
	id 619026B05B1; Fri, 13 Nov 2026 15:22:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C97F6B05B9; Fri, 13 Nov 2026 15:22:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491A66B05BA; Fri, 13 Nov 2026 15:22:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C78A6B05B1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:22:17 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E435402D8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:22:16 +0000 (UTC)
X-FDA: 85431217872.29.67E5DA9
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010067.outbound.protection.outlook.com [52.101.56.67])
	by imf11.hostedemail.com (Postfix) with ESMTP id EA40040006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:22:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dJh3r2FG;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794601333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e2RwzbOxIvy29ZA3zLLGwHwe69Cf+J9skwxB3S9b6yE=;
	b=TQK1G2/hf0wLo5e/p4xZw3+nh8uKMn5Kp2X4FnPQZinglP+gqYiqshCmHEGgIa8sgeA1d3
	9VVwpo12JV027S0ycnexygmTfm4OuHgMSS0jEzc00A1fw7KORWYdsT37qi3MCmUQXuYhUv
	AbzFaOPoIGP7OKt/qia2VjTge242AX0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794601333;
	b=LfQE7ruYoLkB9bQHh1PhE21uA5SMXQHUGcfF9lwL/k1QlDNUIis5D4DdFgY8r7X180JpXJ
	uNhpmuV/ZJFlGbvORK8Qy8/qxPVHfRcqq2CiL9qdGLQJ0HRuZxXk8fwmg2zNSgKcAQMT/M
	31LxepmLVS/h5Ug5J/6JRpGIhF63b9k=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dJh3r2FG;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ECxbXDqEYjNsxrDtHgRDd3hfP0VaDq7HxkI1nDSeCH3GY0sV6PjhhIsAoO+7E6gHgNqdG8T2Zc1mVjDabsZnxRBl8XNqauZLM8+ktPqOfHtnYqpiM8yG2cjYKZNl0b+q+Gs5q4kKTNbOGUTa7TFPyEEHSzwKz2ehzEeVuuHq64FRuSr0cx50Vt8aFbCsG6LLPSf12HZaoAbSxaTSZrtWCNfUsmK8NrB3qzNk9qsEDC5hETrySW6mATPzGolgHphv+LjzWztJfRAa1BpEeTgP5hHGXgCkXTCmBCqc1heaScOBI+f9LnR1iLEX0WL1R9TQpQIWngt+QNcKL+Klyr1wlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e2RwzbOxIvy29ZA3zLLGwHwe69Cf+J9skwxB3S9b6yE=;
 b=m5iM3yDcNNipDX2t1fhmB4Ia+yCs+M9cGZDbxJIQKHtIM4WOG+L7QhpyhYS2D0EPHJMEHdwmdzFfA+kOnxHtk1Wwcdl4BpbUYV7Kody1fdkYiCfTlg2+HfDdacGS6YJaxogmn/FDoja0xJ408+KZc3rG6FuIuxFjiJrnKJsJX1kqr3N6TW8MN7O58fKnRXI8IBcd7ac+TISBQNQ05LVv8D8m+fUZi5078BWNk0MB6VsYbKgzY09K4tt2xB7EaTM31leu+z0B/4auIRin+J5O+aez5jFWqBQGiCjrYRmEVJiPi25s/dw6Vp9gpiJzKXSv1WsB/ls7TDAAQ+pyBilwDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e2RwzbOxIvy29ZA3zLLGwHwe69Cf+J9skwxB3S9b6yE=;
 b=dJh3r2FGFExjcNzOUi5CD92T6+Gj1gLhJHu3FP/3YkEWAxxCR1yqpfOP9gmeLBSipyqldoQK5OFPGlDDWRQkE1SfClzL+jHWO8cnW0enmu62FQzSsjwsKzmui4i9w+QeJ5583zTjKM6hMFKpZnTsGijixb3bZy7DGh7Hq6y3KCNN0nua7n+49h+Xkw36bJdZwOUR5u9DiDuMawVsWXHKl2F6uy0rVek0Ck01Z1bn+1zk/NJIWapGN4Pc0kLxal/WRF4NJdkGaIv8QMnlDVHNb9TWy5ixGnmUM24Ckx0rCbCcDUe2bOxBJniPTcJmYCezuWZS0SQod9gJ4Zuu7Gw8Kg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MW5PR12MB5650.namprd12.prod.outlook.com (2603:10b6:303:19e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 20:20:49 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.007; Fri, 13 Nov 2026
 20:20:49 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: sashiko-reviews@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>,
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>,
 =?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
 Chris Mason <mason@kernel.org>, linux-mm@kvack.org,
 Borislav Petkov <bp@alien8.de>, Mark Brown <broonie@kernel.org>,
 Dennis Zhou <dennisszhou@gmail.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH 10/13] mm/migrate_device: refuse to migrate shadow stacks
Date: Fri, 13 Nov 2026 15:20:45 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <F185BA4F-F26B-48EF-AB3C-848D72FA630D@nvidia.com>
In-Reply-To: <avdveCV9uW1zwXXd@gremlin>
References: <avYJ-CxBEpdO1Wmu@gremlin>
 <816E22E2-C7DD-4DD1-AAC9-F51F4D1ED71C@linux.dev> <avdveCV9uW1zwXXd@gremlin>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0449.namprd03.prod.outlook.com
 (2603:10b6:408:113::34) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MW5PR12MB5650:EE_
X-MS-Office365-Filtering-Correlation-Id: 47cd258e-b7fc-4bdf-d2e6-08df41c39b4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|23010399003|1800799024|18002099003|22082099003|11063799006|56012099006|4143699003|10067099003|261026121527099003|261022105027099003|261022075727099003|261028144727099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	JmM43uP/lZ+UahEO/YjH0XKfGrz/me4BOblx2NIZjuXHeY36eb2dS9l+Q3QbV8DLsEQ4eF+nj3sLaX3dzVOguKpVRWEXHSBaqy9It9Iv6c0mE3H++kjfKRCSF4yeko4n2M+XQJmiZpR20DJpq2mpQSm+baQ3Q7IIYJyyycQW4a0vpg3Y6qdJwxdo5LacK7abxmCgvhM5nRt+smMBXqWpB4cQNYK9OEFdjvUdBYKC0XT9n5cF4aiGz+4KBI5NM0dQbvrAVp+SLDAbT54t11aVlRoy70PR22Xug6hAsJSLn9it8fc3vlOpG33otoZR6Z7fDz56Y1iPGcY8fgZedJ0fiA85js81hLc+dquCDoLs5UQn/IR3xNLRlauSZGf2bi5i9DA6M8qGDAxg7TfD4zLgx2Ki7Wte9kEO19xdF02Mu7o4f+NEhHxy2eAIUvdmaOs5RCEBIN0ejxUqb5Hwn1syhXADJ4sKCPt3rUVQUSep6yLTHAapvbZ5TDVlSYciS+GCxqWMODgI0tK5iHyAfOFzrmwKe6veV23VQqOuGFG734ejoIxHyz5/PQ/B7tOJOjtpWIfvBijYcexGxlXAW7e3J/rb/D0g1YxzU8hygtVaKRJEx695rKXZFnPuDbjQNlQP+ezVhbuIL3nm5HdFLJmrqczzoQO50Qi0RZJT+BwOXaM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(23010399003)(1800799024)(18002099003)(22082099003)(11063799006)(56012099006)(4143699003)(10067099003)(261026121527099003)(261022105027099003)(261022075727099003)(261028144727099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Tm41cmJPNmtHdXA2bG9rVXVBY2JyQy9xZzRKbWs3cCszZ3dpQkdJOXFLaUV3?=
 =?utf-8?B?Rm5URWFtSFM1VG9HT1AzcHZNUXdKVisybGloZDZUNkFjYzBFSzdaOHdSbTU0?=
 =?utf-8?B?VjZLUjlCMjlUOEtHa0pyMU1JN1pmaklJUUtkQmtLYnFibHhkZzRHRzFkRGxy?=
 =?utf-8?B?Q1hEdk9mOEgvK05ZM0ZReHJ2NUMvUHoramQxbXFSVVJBK3QwbTU3MUphUU5L?=
 =?utf-8?B?QTU5V2kxUy9JdEN0ZzBGL3Vqb0pmeVJaUW0xSHcxZEVZQW9RaEhXallOMWI0?=
 =?utf-8?B?LzZ3bHpqTkMxM1BrYWsvWUpyTU5RNG81M3F3NHRpWExFQ3kzZ3RqWVd4QXVF?=
 =?utf-8?B?RGV6clZoRWpCSlgyMTFXL0RKN3FmZ2dJdmsxTG1ZYmQ3VUdwWWMwYkw1RVlM?=
 =?utf-8?B?UDdSZTk0TU55cVV3YUNpaHB2MmRKaHorbG5VSDBvd0FLUGJ2bVhiNG1nSFUv?=
 =?utf-8?B?cmoveGkvMjFoRTM1LzF2WkIyeERreGVzMDVyWmxxN3FIcFNnYnpSNG95eEZY?=
 =?utf-8?B?a0xKNjh5dzNRNXEvY0tkMmEwZ2I3eU00enB6WERaM0Q3Sk0wL1NMcU9raEgw?=
 =?utf-8?B?YlZNeEovQ3RzMUZFMkFFc0RZU3hMSUJxUGhTSlBVelMxNHlDc2ZXWXR4dGFB?=
 =?utf-8?B?MEtiM3l4TkQ1U2JDMmFDaDJ2NXB1b1Q5c2dkVVc2M0dGRUIyd01zb3ZjeEpu?=
 =?utf-8?B?eDVxSEJsTXNNMS95ZFp3RGJTYmlCc2M2ZkRpQU51dzJMMzFWSkR5RzJqZ0d2?=
 =?utf-8?B?ZlZ3eForSjQrN1RQZmw4ZjNNUGJCTWxqQ29Nb1oxUGVMSDhCL3ZJck03QTE3?=
 =?utf-8?B?UEpnODRGUEx4ZzZnS3ZDWk1qMkJKU0Z1akxkZEtWTkIvTVVXdHR1cW53Y29Y?=
 =?utf-8?B?Zk54eFFPY3VNc3FpNXZwbnFuZWprNmY3aTNlNWg3TUE0RnZwREdBeGE0ZnRH?=
 =?utf-8?B?QXpyVmFUbWlFSlpmM3FmaGF5amRMa0Y0eFZWWjcwRDdtQldxUzBNOTdIT2pT?=
 =?utf-8?B?VjZUNlA4VFFNOXZGc3R5cEU1TEsxenBqMXJiN29BUHpLemRRKzRsT013WkFj?=
 =?utf-8?B?eFVwTEorUXA4VE0yRm42MEMxOHdJNUhKMGxJMSsybFVhb3p1NEFJRTZmS0Zw?=
 =?utf-8?B?Z0h5b1A2YU1lRk0wSmJtT0xCUjFuS09rdFdXRW9LQlJUMWtIS3VVaUtrSGpK?=
 =?utf-8?B?ZU53Mi9aMUhzbi9EOGkxemVRZ2NrYTZVZTNjWEZzTy9Xak90RlZwSWFGT3hW?=
 =?utf-8?B?Nk5nSkUwMDFKSGNYZlE2aDdRTWpTNSszZXJ1SmdHejZNQy80MVZjeDduSStV?=
 =?utf-8?B?bE9UWTNkL1VRNUtsdXhGUHpkUk5kM05JVGFtNGZFd0M1M2crZWVaWU80bzYy?=
 =?utf-8?B?QStCOXIvTjNqRjk2aXFjZ2c2RE9iWWxncmI4dVh3QUtLZ2JKeFIrNHVsQjVn?=
 =?utf-8?B?M3g3cWYrYmFWa0F2MjIwT25UN3ZtcUZ0N1RSb1ExcHJLOHhLNVVkQ0RIR05a?=
 =?utf-8?B?a2t0aEV0eUxkM3A1VW9GMDZlbEVaQjVFeFdzdW4yalJDaUZ3bzZwbmtnV1lI?=
 =?utf-8?B?RUZQMmxFQ0gvN3d0RHdpNlBFeCttS051MDZhL0RBS3hVUXgxb1lMcytkbmM1?=
 =?utf-8?B?V0JOcmIxVSt6ZmFhR1gwRzJqWXRUMXNuZWJoSEZ1Zi95dEF6OFBlTnd6cEpX?=
 =?utf-8?B?bE5LRzdUaDM0Tk1XWFJBNURYQ0pjMzVESU5BM3M2WE0wb0RTY0FORWtsZTNM?=
 =?utf-8?B?dFFBOVZZelp6MktwSWpvVmtDT2wwYlk2dVZWbXhoenNLNVRLRDlZdFJ0ck9k?=
 =?utf-8?B?bFI4MkVEeThxSUVRcGQ3TzRWMVdGWkRTQXpCOUFCbE85empyRURYQ0tmazZx?=
 =?utf-8?B?Q2tIdnFxeHkwcm9qUE44WmhnMm1LRWZTL04wMEpoRG05TEJ1amJ2Ly85aGcz?=
 =?utf-8?B?eWE5eGQxeFd2eGRyVTY2U3o0ek5UR21wTHJDOHFhM3UydUljK0hmNDA4Nis1?=
 =?utf-8?B?eG5ka2gvd2NYdE5sczcvOGxMWDQvZ2lDRXRoZHlqSmd3OXU3cHE3cHFQcERr?=
 =?utf-8?B?UFdxNUdBRDhLb252ZXZnWDRnV25jZjROQWtyQW1ZeVBlVGc2Q3pZd3F1cXpi?=
 =?utf-8?B?MTdMUFZhYTlMREhRZWhiWjRvaG1wZGRLQWRzMWhVcktSOUxyYmxrNVI4bjJ0?=
 =?utf-8?B?TEc0QnBaSTVmd1BJVlIxeEYzNDZ4MU5BR3h0Mkw1Qis3ZDVDUWVScmhjdzFV?=
 =?utf-8?B?dTlHNXZQVzBTM1RPUlI0ZFNPcU95eUxwejBiSmpuS3Y0VXQyZTVWUGZXK0Iw?=
 =?utf-8?Q?sMg2f+ZDq7E5JuWZG0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47cd258e-b7fc-4bdf-d2e6-08df41c39b4f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 20:20:49.1803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CtX97G42pX4OrbdJOrGFGCQ/bhvwnqNnOiFc6oEdyU1XdW3IwilMaiXMZAZuBEdJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5650
X-Stat-Signature: 4g3hjujmyn6k8oif1rfrwu6e3a6m7z85
X-Rspamd-Queue-Id: EA40040006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794601332-884449
X-HE-Meta: U2FsdGVkX19ACsqy15MXnm87leWQRn0TpvxaIn9MSm2UmqOCupQH6OMe9kGToBZlT3QYxKQmZb0iI14m0orHwh0lttxZs8ok9u70ufmbwOUzuzqGsrMaLSCH0dIG3vOuH0gjdatGAUL2Uq/N3HydjbNyQmWj8LiBEwBzKvy7ztAzE59cBba3pBL/IK/gwZxBrwdFTStPsA4krLaH00P8olf8KjLSPhYfko0XZikUrESpC9xNizoBxDOOcG04XYp39mBQKO97fdF2aTXZOWinItUg05DotoC3PKHOBx2651tHRDVdW4o+rPfJ2utfkD4b5g/RWublM45BEdGivyGExHh+dkSVHWK8cgaX2TfoAd/xT51/yQ2OZ6UDPculT5tKqcTdZs/gmI34qCIHustUp8Yt6E9xTqJxXcuz8i+e/G0FPHpcp/xR4dz/VDV3Xn9SjbsYDNUzPoPyWQNK0it9BmlV9G+Q8iTEOVhFA+LuMFOQC7FUuLcB9JpcjCWlqj7xzYtqiwGdN3WPJu1nDBekaYRKnGtDDH9xu1NFF8tuV8QKsLGm/CxqAEOOJLqQdO+kNUKkyIeNggj9J13kPNAl2+UCAv2hFOE866Nl/WBXGTcnFt1It1MbdaP2fMmy7IZRenpawHPSiYWSD/XS8gQLCPU1ocA3nhMd+4gqXwYwqKXEDBzQnZICI9VvlePvgfK+QW3bcD8HDd7U0Z8J0sPlLfbnIKHM2O34+qUBRtXVs4z/kFw6GoK9VYGuI8gyzr0Fj84J4ZERdcjb1ga+923feUjOMy4SrY6YYmk/J6TfuUQs7BXJP5fGYf0SIBW+uFRRgV3TaVKWf9mE2dx9ZSXFuQu+Cn0yN3KsMagq/psq3HUfHtjC7pYkGYnY9N9RD1oBcE84rCh/Xf7IP2CjFXOxJ1JVJSK/eV3lw11H0n/9iOW3rhWFCdyNUgEo9aJq0T+IJoSmH0rClJt8z0eIYyN
 pFSpj3nm
 iC+aHe5Qn8NuJrZxrJ3SSz2dNpIWPzFvc6Rea64Vi4LhBJcVjHxNkR5+RE5LFgVvr6mq48tWygRAoO38pchH65onFixUHpbGufE0Jbqrb8jDUjYz4HaUTfEaMrupb7OsSVM/WJMJc2kFb3p9vksdOrUQorDLl8OTkaybRsiz7RQ6XLZSS59dUvwqLfMi+4np9+RMahudTGaWVIdhwcAhIFAWQ6YhUZOzZFJihJKmy2RgE6Sv/nMLoSnX7LDSJUQgAeqxoyan5BblGb9yyUzo3O8s4PPhKZP9mmSmCZbzrlnx/KbPT1tixKz1yCe757ZqkBg/iWBygrsIogA8Egnad9e7ylMHQKqgKWHKckLO/RvjpsD6HAmz+X/DYixwAlzL6/eGpTbZw+gY+gz/Loz+9igF9jMhsdi76IbZ17XL03OHJfesqfaJKYJ8xuQe6Yo4OQGgUM08JqUREVMf/MP0weKZEYCGRL+08HCNvlfoCzgdBu9Z/+3mk0zxQBhbDeVKP0EUt8hvWRg2Wafjr648E2qMYsqMLJPQjeVnxlGkwPc3PLJE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 13 Nov 2026, at 15:17, Lorenzo Stoakes (ARM) wrote:

> On Thu, Nov 12, 2026 at 02:53:44PM -0800, Roman Gushchin wrote:
>>> On Nov 12, 2026, at 11:03 AM, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>>>
>>> ﻿+cc Roman
>>>
>>> Roman - see below - I was under the impression mm was not supposed to receive
>>> 'unrelated to this patch but' reports? Did something change?
>>
>> Yes, sashiko started reporting pre-existing bugs again, but in a better way:
>> strictly once (per bug)
>> only for the first non-rfc version
>> somewhat related to the proposed patch
>> not more than 1-2 per patch
>> not exposing security-sensitive stuff this way
>>
>> Obviously the goal here it to increase the chances for the problem to be fixed.
>> It’s global, not mm-specific.
>
> (Sorry only just saw this!)
>
> Ah, I thought it was an mm opt-out.
>
> In general they're spawning a lot of AI sloppers to go off and send ever
> more fixes and causing ever longer days for us, it's quite a noticeable
> impact unfortunately.
>
> And often they're duplicative of already-sent fixes so you can see the
> conundrum with this :)

I wonder if there is a plan to make Sashiko identify duplicated fixes
and send an email to point out the existing patches. So maintainers do
not need to do that manually.


Best Regards,
Yan, Zi

