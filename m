Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BD93C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 15:22:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D78C76B0093; Tue, 29 Sep 2026 11:22:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D29AD6B0095; Tue, 29 Sep 2026 11:22:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C185B6B0096; Tue, 29 Sep 2026 11:22:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 902196B0093
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:22:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A58C1C32C6
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:22:44 +0000 (UTC)
X-FDA: 85267167048.25.B4AF1D0
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013040.outbound.protection.outlook.com [40.107.201.40])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1402C1C0007
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:22:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gWa4Yq+4;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790695361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6TINRGfvZyvFmmuFms0s2dyeatvDt4vnhKf9+D+fWVU=;
	b=yPzmEa1cpMS2gX2HKw6qFDWsSmdcnaLi0M4fFp/CmmTtoNMVvWv9lPKu6qOsKtJbt9mrQE
	phxnAEWbPNBxacGIHeI4oDnRvnQlu0SHt3EGiH+yYSSmv8FsctEhAAJwdTHumfqFc7zm0C
	oFcMneL7dQqBYM1+5h3hE6gRalLti7g=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gWa4Yq+4;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790695361;
	b=4rbiZT9pbnmwnKS2qrEmQamoH088EY/W2BXUvnmUVp6vLz94aamkMBuZ/d3vmJtpILyUME
	dzIRb/p+Z5QLKg+6gyzwhvb761Jnm7qqU8w1k5AtFQI+oE24DfdwT8zhRUu8kt2Ta5FXBE
	ZhiPwwF2cEmN62idpH3bTRhGpXJdg+o=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vCyM3+Jf249x8+9alMpK9mlKjIsR93bKCMcZkVzeQabGLS/hsdNlXt/1cG8ee4n16SO/tEj5W2OZgPF+j9LWJLtJG/99C56jnDu5eWPcLjij4ZvljG9yFQhMW5+ss4csZlwFHA/UKtp/jQ482IKUOFINYLtNZFPNNpc2CoD17pE9cSm8VNxrdmScV2IOZ4CmfDyBT7z1vyp3LHEFiixfabFuKe5c7LeKPbevLs9uiHU/KaKCIywP3CuNtx3d7WPDrEyMBvIUAS1A7B04wWAIQdf1YfuY3+J9QdyCfo3CbH4sigG1cJybfQCT+rf1NT0YJKTAkBNoEyCNrUEY7MI+Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6TINRGfvZyvFmmuFms0s2dyeatvDt4vnhKf9+D+fWVU=;
 b=PwqciTUMU3o8w2ki0gJmQTAZd+jf4fUbc8I/yFFribtxHScfFRFXLklOTy918EDesnMfP9cpwS17pd+HNLrrLGXWcbKhkx/gmY/tZNyKHWpb6YLd9xU5dQYszY1D5Zo0w9ttsAGQaxjP1O2mAfULXWHw7lfou3z2FgCSezspnn6Qwl47sAi6E0NFKv9RFjydvs5HDsA90/4JGg+RqzOtli4Q9bfAcUABj3eE7BF17J3/8xUc0JYnPlCGipe3hUAOsJUYWwr6/vKNaOq3eaRUxmeXk7ZHcP3otFb5iviOwhcyj6cG7wz/WH3QEL8ahdGEZGIf8Fl3/pfAOdYPlnv4ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6TINRGfvZyvFmmuFms0s2dyeatvDt4vnhKf9+D+fWVU=;
 b=gWa4Yq+4UuAt1szt0jv0tGIghFQzyNd3HZbfEGromCZr5ZKBOy2/UB4xSoygtks7I88Z7fyDRE8NNcCbqR3+ybhZmnXFtF6roTTcC+Eei+rT99XPwvGoYhRIjBla38raSj7AUMU5iUa0l/8/t5WE2m+8S4fN+4HhfL6Y8c11RU10dCYhGsRbqXMhlHJD1HN0Fb8UMXMk4k1Ht0/SdgONkF6aQahY3oouHlYsbK11sThkY1vixWcuYqrVU0lYUu9kkWj3bPql5dfI2d2RE7s/WQ+yu1NP+VKDXKbiPI4HIx/WYLLpK+ZEUQ4QOZ13/ooEgSbp6ER599KfyltSQNj1Uw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA1PR12MB6113.namprd12.prod.outlook.com (2603:10b6:208:3eb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.22; Tue, 29 Sep
 2026 15:20:34 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 15:20:34 +0000
From: Zi Yan <ziy@nvidia.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 2/4] kselftest: mm: replace usage of /proc/self/smaps
 for __check_pmd_huge()
Date: Tue, 29 Sep 2026 11:20:31 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <45251B39-898B-4628-9EDF-4346D91399F2@nvidia.com>
In-Reply-To: <20260924-fix_split-v8-2-cba7359d882a@arm.com>
References: <20260924-fix_split-v8-0-cba7359d882a@arm.com>
 <20260924-fix_split-v8-2-cba7359d882a@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MS-Reactions: disallow
X-ClientProxiedBy: CH0PR04CA0108.namprd04.prod.outlook.com
 (2603:10b6:610:75::23) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA1PR12MB6113:EE_
X-MS-Office365-Filtering-Correlation-Id: 739d2a42-7a2a-4320-ed45-08df1e3d353f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|7416014|1800799024|6133799003|10067099003|56012099006|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	j8mIbJ2yJu0QobijChGXuLDi7AIPISys+yXwDb47KV0H8LIxRElIj4tSjaToINTEWPyUnxmTEm+16D26ItJRh6vNeMAJNLp3upYZ+NZTAx11maOCBD+gzde3OMORuYNufs4ZeT9vVRON8k2xESiHFwUK+sxtgkmHGBDo6pz9OZbJERRGx+okrMdR0AQKYE4TnSTrfxuCc6jIGVM0R1CFtuUc45L1YDW4ytQwz3pjBmoO6bz3RKrJmmmk9oYiMm7IqgnPk0PfQhwdBdTq2oepOXXKOLdiBntGVM4wo4eqqvqwGaFmW3pla8uIMK6bBcKI70ZfeC+u/3qf6jEa+AWBn+SbkxWYm/he/XFi4O5ldJ47rIGzQcDgcDFaJoPZHzelUSrjmtFqXX1SzLMHcJl3l/MsxPUudZ7itMcsL9AzFLlW4fSCYs6tOJI85Md76Ev/GaDs8KVEWiAXEAztGSlcPRcmbBLQOHFHh3xVwYMVhW4miKyce2W18rlQ4DGXWrrkqhxJAVIe7mi553cadH9JvKhsWYyBove+VDTEByUcv2zE01PeMhC7J4JKID9XtrIIyjMao1BnY9FeJxEI9Lv7MziKg21LftVT47AvrQn7kf3vvIpa3A+z5be1Xd2N1l3u98oFiKOBKNSaZGHf8KjgzPu6N33JQ4FMcQzWxM63eLU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(7416014)(1800799024)(6133799003)(10067099003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K3EwVUtKQ2JtZGtpTVE3Mlora0plZzFsTGNaS2ppTm8zQWpKZ3doaElrNGFa?=
 =?utf-8?B?bWI0ZmxNUTlFQnhXVW41T0lIM1BBWFNOUHNyZFYyZ1haNUwrSDdKUTkrazAx?=
 =?utf-8?B?dkpHV0lwU0NGRFlBTzZPNE9pRmROQWxRck5JbVpESmFIcFZUYkM4K0xuL0hp?=
 =?utf-8?B?NDFKUXhkeEJVcGRVQ0tmWTc3cGJ2ODZDc1l6czIzUjVTLzRiNWd3SzUxOExL?=
 =?utf-8?B?MHROQVhYdGZPbWVQMjFFcTFvVm1CWjJHTW1EaDFIclZuN21GeDdudUJYK2U2?=
 =?utf-8?B?cC80ZHNCTlRPMko4N1QvTFJJRnl0N0ZNZTMwSjVwRWdvOFlVQ1JhbXFIcGEw?=
 =?utf-8?B?N250K2RhWTBaSmtpNGNmb211Rkg1UFNKaE10WXpjVUh6ZU9iMWlVSWtyZTRw?=
 =?utf-8?B?L2FNajJJcGs3QWxQY3IwaCtkTG01OVV3cGo0TExJSGoyOVJjSTErOVdDVVRr?=
 =?utf-8?B?ZVRIS3pWNGpNc3JpUWxQM1pUdFdnZHQ5UDUzZVJ0VTd0VSthU2lxb1FpYUZR?=
 =?utf-8?B?WjA4bnIrRkt1akpnaHRReU5jM08rQk9YbkRwaDJ3bk53MDd1ZXBDb1dmOEtv?=
 =?utf-8?B?OU80VC9GbUZ2dmtnVi9LSDhlRUp1ODUydVJnU3dEcEhtVjlwQnlSTDVBcWhX?=
 =?utf-8?B?Z05ROTFWNEhtRWhzMkpib0xlMFZleGJjMXlLeGpJM3hiRjBOcUYvcURlK1h1?=
 =?utf-8?B?T0IydTJ0YmZDU21QaHFVWGFrdXc0ZkZGL2pVbkU4cWRyZG5RQm5KaTNTc3p4?=
 =?utf-8?B?VTJBYXQrUUd0M0lxRllCekxoaUlyTEtOS1dqYXVOeE1qdldGTDQ2Z1VQU05S?=
 =?utf-8?B?dUcwUmo4OXJ4QllRWWpxR3ZmamEzYkZ3SCtraEVGK3NYOWdMR2hWT0lTaU5a?=
 =?utf-8?B?RUhZc2dCTWlLTHpVbUxKNXVOa05lUGQ2akF0S0l2Q1czaEl1b1l5MndpOVds?=
 =?utf-8?B?V3pFWDBURU90VjE2bFJzZzBrdzRRUEFCNXpudHErRG1CSDZyMHBQNlVMV2Rm?=
 =?utf-8?B?RENleVN1bHdHd01CcDlzYmJTcDlMVFVqSXFiQXMrajd6VjY3bXZwZVdGeGgx?=
 =?utf-8?B?UG9OQWFjL0FIbUdMNkJKaHpaRi9QY21LbTduZlpHRExaK28wMGhnNm0rVXpP?=
 =?utf-8?B?Y2lsZzgyTUxwZ3VyaUxwZEtMbGxNOWsxdVNDWDRDcmVCU2VacU03VXhrbGl2?=
 =?utf-8?B?NGxwTEVwQlR4MnI4cTJ4VCtkVjh0aHg1dmg5YnVtQU9vZzFmRDljV3hnd3E5?=
 =?utf-8?B?aTFibC8vOTQwRW9HczQyajBVRlpmbFlUMlRWaHh6dkFWbGVEOEYxUVNGTWtD?=
 =?utf-8?B?Vk43Y1laNzAyWXdqb05rTXltWWFyTmd6cFh3cFp5YmZCYms0V0tPK2dSL2xz?=
 =?utf-8?B?WHRzQlJoVVUwU0hKbGU4ZUJDWnVDMVJvY1NGU0t0bmJybTFwQU1iMWF5ZWlM?=
 =?utf-8?B?RlJjWThaL05JbG9VNzdMSEhQNkphWHBnUmFQYzVvMEtKLyt5dVJIUk03R2Nz?=
 =?utf-8?B?d0c3MDRPemNsZTk0dS9JQitHZFlZM2I1R3A5OVRROVd3UEN2RXd5b2FwYzdz?=
 =?utf-8?B?L1dCYjNCRks3V20yTU9nZHYwY0p2OUd5R000SENZRWcrS0NQcTI4WlYyM295?=
 =?utf-8?B?ODVUQnZCOStrd1JwQ3hFdnBSVDRWdmJFWnFkZmtFZ0ZKWFAvWlBZOUpLNnkz?=
 =?utf-8?B?MkRnTHF2Zk81OExocGJJKzZDL3hGVVpoQ21qcGVPUnhobFlnSXdtRXBJSXk4?=
 =?utf-8?B?NjRMdDh1WGdMbzRtc2phcm01bGhYc3psdFZONWVKaUFkZTFWejJpWjNzbWts?=
 =?utf-8?B?N2VRRnY5QnJBL3JVV1FKYjJwcUE5L0ZPU2lub0d3K29kaDZaMmVmV09WQTlQ?=
 =?utf-8?B?TWthZzBRS1c1M0I5UkRyL3kyeldoSUl0SmxPdllYUCtJM2pnWENpQWNuUmtY?=
 =?utf-8?B?eFBaekhqVVhjZ3ZZWGhqdnI1L1Nnb00wUmx6YldCandEM2JKdkdqdFZHS1dO?=
 =?utf-8?B?akJsaklXSUxlaWY3bkFpTmVmNHhDT1hwRU9kaUFBcXZFLzR4Zit3ZTg1bmFQ?=
 =?utf-8?B?UkkycUtQVEJFQ3Q0MldRT1RKVm5BQzBGSFVjZzI5RXJqalIvMVczYlRZK2Fm?=
 =?utf-8?B?MmdmUkVmajc2NU8yanEzTVlSYllDY2V4bTM4ODYwUHpRVyt0SzBhUWR4RFJk?=
 =?utf-8?B?SXRiNThQbXBLcGc4MGRrVHBENFhiU0xUblBIRms2WDdoaFBmY1ZZTVdQUC9w?=
 =?utf-8?B?OTAzK3lSdDdkdmYvQm1keDJxblU0OHdkUjFsN0ppUlQ5ckJKem9Mb3JkZmV2?=
 =?utf-8?Q?ojGap6rC+FuAnj4Btt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 739d2a42-7a2a-4320-ed45-08df1e3d353f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 15:20:34.6953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rd5YdIwlBXjdy9K/Hk8vBpE3fSxUnyorL3Z1aCnCFyds47vnyL1kESKZNdPDlMq2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6113
X-Rspamd-Queue-Id: 1402C1C0007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: wbqwkgzpoz1gfgnaxs7muurr6csws5tx
X-HE-Tag: 1790695360-89098
X-HE-Meta: U2FsdGVkX19a6bNKC+kJo1RKSh7JqO5vB+6LKodw6hHgWSG3xgciBtxUHeZBspmgGk4/3o/AupaI6hjxUxxsLYCdCgtLIDInkNEs/Xntm7clnQDD+Lr6v/PLLCJ19VVSfUGVU6keDXNYMKQq/CqJhw9JtvYG8k6jw4b7cZlutM8IK0XsmDnP/W9Cd7sZLmBlJjQjo0NcVoo96APIQlAjbhrbTrhTOIvQ9JR01nP+g5LdFYJTdU/epbuxXDOW9Z/hJU5N6CyRTN+3393sLYltRRu1rmIUpIYOhppKQfWgNly/eXUZanI2xD9QsriOXmzXKzSiD44snfZWj0/fWiJNg2N+y9l8rH254S38G4uZWDabIPD22jmfpaT3Wvhj+bXYSsUZ3Y7Y4n3Vi4WpYi99vPJO6x41oSusTXe630F1rXtoPTFl3S0RbMUGn1HFpcYMKHr2/zpAkNxRdyN03nCRMnyG8/qFVoWlINfO0f0jRdEpntRbzvNIROJv7XuMWUrh2jVw+2QUl1UGITOOHLLdfIk9EN2xHH+y7Grfy83t4VpKrSiZu0uXbi8/qRqx+dEhAFRGhUlN0kJdSczc4jxgXKkBnHTEd6JQRKzLkXeyYIGMQ+L9/GF955C5ln+MuxXBDVAt9G+KF2W4cuu2kMBL/j+KxQjEe06I3VKFeBYlgGYaKQX77O5OQPynvz5wHHddin2J58xffGU81tJ/FSjSCdAzjhp+bfEiSMLRYbdhoCVVjKhCtqtaOooKRwIk52YxQOp3yfRqJF+yAYKsu5zBpNRnW/D6rDKTeTBTRvv3k+n4OPj2tWanwUmvpZw3ykQjqUfNuUg7zzCyToxOHqsJX7L8F6MNZUJMpQwnOIkPyK8IeWP/YeNvyX+s+xuZ2SJMxQZlwlwPgAVCx4ouroKJZvJPoh7Yjed7jk7iHCtfVODtZ0+btoxjhHXmAgsF4bKNkYrfbm2Wu1iF8lKvMkJ
 Ra9ABc2d
 Gjs42GxcCKif/upI4y/4iaxztwr39AyzWMeszBDDmfFj3VAeAavcOdEekck6u82edrzdEMbRxSsB/Y7HWkRkIOT8J7f48DlpiuRAOxR4JjTLmPamFjOroGnhot3gyAJJliZU8TpOvvxmNps5ZOK1GIiLLmHFJRJJsKQqmp3fWQSLxZ1KxN5HRlK8DBXWqr6UlA8Lkc0RJeGyU0GxOqp2HRlx0KxJGkUX8kPdEJrmS6dlNc2H0lcsvt+KFzY1H92STQ8gm9yLXAQ7MUzTDLN+2t1kOOYGj62uD1i8Uuj3EWnqlRfjnZ3ZVbg2hh6CmZq2Xe2QmB3nWenlcIhDwDO2te4eJgfBUzEg2sKSd0D1kTKMNc8hsF4faW0qnF8azMmTEn1BwnDfP17ca+fpbdtUi/bamV80BAu38zUNY+krLs/EOW7Dwj3abb3F8ppu7xQei5iIV9h+04OK9ttU9ba6t2njWcIxD7dZjpdhxRtZPek0MJVZ2VHzNiqgi34wkpZIvnk70u5M9dfe5Jcy9q50GG1wMSmyA+UighikcgNsbMU2fsyM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Sep 2026, at 15:11, Yeoreum Yun wrote:

> Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> made by memalign().
>
> The underlying VMA may start at a different address from the aligned
> address returned by memalign(). Furthermore, a subsequent
> madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> already set.
>
> This causes split_huge_page_test to fail because the check_pmd_huge()
> helpers incorrectly require the address returned by memalign() to
> match the VMA start address reported in /proc/self/smaps.
>
> Instead of relying on /proc/self/smaps, use /proc/self/pagemap and
> /proc/kpageflags to detect huge-page mappings checking PAGE_IS_HUGE
> and PAGE_IS_FILE accroding to type of huge page.
>
> Since shmem pages are also file-backed, simply check whether the page
> is file-backed.
>
> Fixes: 642bc52aed9 ("selftests: vm: bring common functions to a new file")
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  tools/testing/selftests/mm/vm_util.c | 78 ++++++++++++++++++++++--------------
>  1 file changed, 49 insertions(+), 29 deletions(-)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>


Best Regards,
Yan, Zi

