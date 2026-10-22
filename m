Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77CB0606A325
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 10:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=selector2 header.b=zkjJTfkA
Received: by kanga.kvack.org (Postfix)
	id 8F8B56B0909; Thu, 22 Oct 2026 06:44:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A98B6B090A; Thu, 22 Oct 2026 06:44:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7745A6B090B; Thu, 22 Oct 2026 06:44:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 490276B0909
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:44:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C76331C3F65
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:44:51 +0000 (UTC)
X-FDA: 85349929182.08.2AA423F
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11023081.outbound.protection.outlook.com [40.107.159.81])
	by imf01.hostedemail.com (Postfix) with ESMTP id C183040007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:44:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=zkjJTfkA;
	spf=pass (imf01.hostedemail.com: domain of khorenko@virtuozzo.com designates 40.107.159.81 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792665889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/H9i0/KxS03TPL9mZSA7OjhCtF4RVQmDgrKmsDMoVbA=;
	b=S6mse7u1n+k4K2kzT8gCs/Cl7air7vGQ4ORG+ssYEoo1sPGt7hzLvEXLnOSTOf9XVKeHWT
	dJiWKyGp1hLt+/HNlfTVnzKjU/S0mRrmhtEQLnRZeqxTNj/bd+XJqOJchIjGB9bS/zVtz/
	WAvgIwjnnJAJAinXTIude+4HlAhNbU0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792665889;
	b=KvhI+Kvs3xhvHTe+kcU4nfFVbjL/uMj4cHkDRUX5zQ46FAg1Wsb6JsRzFqxj2GUTeXBCTn
	yEF1dPnwKrWPrlJ6UI0V0gv2F9wQqO+TSK4CUdMLMJF0TXMdwan9HrhoCMzdZ2YnRiQEY7
	iI5z+Wmp0ZPpUaBiSBXYPb1H/qVzcUo=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=zkjJTfkA;
	spf=pass (imf01.hostedemail.com: domain of khorenko@virtuozzo.com designates 40.107.159.81 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zv7aae5LENvPcEjaGYLW8o6Gaf9uaF+b4Bnro0X6CLlyQRIKx2lUP0MbUbDWdJYc3TSiw4rZQOlzBs5xcAyEo7+X7I6AJDMYw6RUVWz3Sjl9moupVtjGsy2a3drHQg2uFrdSGOrVvnyQUbdL0sMbqYqTQhTQ+hllSfZpcXE5rT5MUbXGDey85hyW/4DL1YZ7J1q/ocWuPWC3Q0d3tQ24urw+tHMUP6YnF85uJIzepICL6GwPBm6qXE/9R9exiaUdVQpTYIezqak0NqviL37/FJ6zbGC4v50YOiFkR2fS+ZkzPEodrezCl2tWH/C2yjDPQ3CGcJA0bZ4BstuyyZ7LMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/H9i0/KxS03TPL9mZSA7OjhCtF4RVQmDgrKmsDMoVbA=;
 b=duk9rs2ZygJzOR/0TynV7RrKCVGlXGXB6cCCdoes+4dv+cOZ45ICtx9yefeEzFFemmb4QQ5RhwBSDOYQea2LC7apCK6zIPZwubvwMUAFoEgVadr62edg+hPEEb4mJkS4sLeCiafBFflG/sMr2/6QtxZGsOWiYcDaTnUMYcikCe3aC5HrNJjlMS5u3IcwIWM8X4s8cu8JxF92NRC/FhId+KG6dXAZ9x6T8zh/NeURajGjfzuFaPk49bNzprY/XBSPpZyPRYxhDdUZtMJuOo1pIIoS1E4wH2pgUplC7b0l2xpyT+GU6lGWXB5unsZfBtHfkzJ+6yX6P+wZuLv3rYQarA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/H9i0/KxS03TPL9mZSA7OjhCtF4RVQmDgrKmsDMoVbA=;
 b=zkjJTfkATwtHx9y/HdMX6fkeH3G3XDWDURl/3pg463QAcCgtfAgNdb3KEkWiVYZiVDPUvqOBlEFO6TeXWo3FTpGwYX9DAkV7saO48bwl0KcLdizsflHE2VgwgDo0nwB6KXDd9xIqcN9N45CXi94Kjffi1K7puanSedfD0+Qe7uW1LTJigpEPjlHpxIVVprAke4VeScqStMpVOjCrCCsCEi1DjDK+1hKDglQIj5OkTkeRRpw6wvI7C2CsaT/Ro7gByIK6X+N7jdARHuv6wmwgN1aiWf/Yl25Ee2VAQFv/i/aEOLv/mynGapInnUWlOuEsEffIqoKhrfCt10ikzKEXIQ==
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20) by PR3PR08MB5722.eurprd08.prod.outlook.com
 (2603:10a6:102:8f::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.16; Thu, 22 Oct
 2026 10:44:42 +0000
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a]) by PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a%5]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 10:44:42 +0000
Message-ID: <71101695-339d-4f8f-b9d8-dfadf7dbd0ed@virtuozzo.com>
Date: Thu, 22 Oct 2026 12:44:40 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] mm/rmap: duplicate a PMD mapping as one in
 folio_dup_file_rmap_pmd()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Peter Xu <peterx@redhat.com>, Alex Williamson <alex@shazbot.org>,
 kvm@vger.kernel.org, =?UTF-8?Q?Lo=C3=AFc_Molinari?=
 <loic.molinari@collabora.com>, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
References: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com>
 <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-1-66f00b7a564c@virtuozzo.com>
 <atnEFyGRYGGf9shA@gremlin>
Content-Language: en-US, ru, sr
From: Konstantin Khorenko <khorenko@virtuozzo.com>
In-Reply-To: <atnEFyGRYGGf9shA@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR10CA0010.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::7) To PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA6PR08MB10708:EE_|PR3PR08MB5722:EE_
X-MS-Office365-Filtering-Correlation-Id: 52c1a9fe-e817-4e6c-b34b-08df30297af1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|6133799003|22082099003|18002099003|5023799004|56012099006|4143699003|261021121427099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	b65GT7JpOIhauj1iDxG9MscqpG4tRFgjaKiN4g8INQmWciY+ct0ssmTiZ8GA8mxPe9ke8iRR5ZTS4Rba4i/rC5gKK5dhlEGyp4i2u7qrIvQwcvlMjYzCIOf45cLeYL6U/TuZ2Jt5cOVGhWk2LgUort4wpgY9VtGh1B9JBaPRW28yEasLFK/qbfjcea5uEtVMj3QFc7EP2VVKglVijHIXuVl9N78Md+ykXdyWsPp5lZQ//oGGyeefu5ycj/T9rNw707ni18SFd0CMksj3Hhr6WBTJeYfN0V8TxxfmLr4mH6n7AmwAXHePIFGURHpK6mjLtpgob7Whv5yhQ1QOq5tYg8yH9mo5fXFkHLLzKT5tPjrZLqCuD6joQS5yR1W8B1AyF3jJiBLRMtws0xW08xhOCu5EDvM9lyARZkF3Xn8ZPadIAgpno4votOC718A6jLzcBrkndzg+StIUS1tXbXLWIzOkZFVLaWDBTR4o6QGna/naR7br3QGZ+OlMvrr/M+PIGWPmPFMRHZMqZxtFyuW0im+gO+Ziep8x5jVf26hmhmLBJeguaGtO26X4DPSG2+HKZg+6uyasyb0xN3IPbV3IIIPkss30ifcTdp0kGkwg0qrI5+ot9GYjLzj2b0mMpY+1qlz1LJWDayLz0cwDqgRO3bFx3ICnmcwAfqZoLBmuDFc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA6PR08MB10708.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(6133799003)(22082099003)(18002099003)(5023799004)(56012099006)(4143699003)(261021121427099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OXBrZWFBL3lCY3Y3N1pIYlF0cEo3V1hYc2Q5dFQwbUowOThlRFZrRkREZVRG?=
 =?utf-8?B?RkM2ZlN0ZTJzZzFONHMxTlVXaVdsNW4rNU03cHJyaHowc1BkVkExL29ZVTRK?=
 =?utf-8?B?SXEzQk0zOHZjMWZibTExbW94UDlKY1JsOFFURndVRnNOdE9vczlFckdGcHpY?=
 =?utf-8?B?ZE8zbXhqVjZwSCtaMjcwak1ZVUhNZnBpQUpxRFNpL2lYQTgvOXkxSHpsTlll?=
 =?utf-8?B?YWlNY0h4WVBQbXo2cGlQMVI4c1l6cmhmUWJ4UDc3bWhuQlNyUm44dmdLS1cr?=
 =?utf-8?B?aUVyS1RyK2g3ajlocUxqMVhoTmlldVJ1bER0VGwwRnd6V2tnVjJESUVxYzJ3?=
 =?utf-8?B?Unk5aklxaFgrUEhKSlFzNDdJUi9ITVBHYWxtK1hwOTBCTnlLQTR3dzV0dTJN?=
 =?utf-8?B?WkRHNW1mZlprSDRGaFZlczAvWWFqd2Y0K3U2b3BGckRqREdqUFNrdHp3WWJT?=
 =?utf-8?B?M0p3bnJwSmFFeW15aXdCejVGVDhmaDBsRTJDa2luNUJTNUI1anBKQUpjQjNW?=
 =?utf-8?B?S3ZMSW9wME1neGpYYnkrRldjRnJBaUE4aTBVQ3pGNGFPUHlCNGFTL0pCRkR0?=
 =?utf-8?B?cDV1L1BOOWE4VktwTnI1dkx6dUtwSTZ6NEhPUzdjL2NpazNjanhqbHp6NmQ2?=
 =?utf-8?B?WmJ4Z1hSL3EycjZJNDdsb0lDclFuUU84ZlBYRnZhSWtiSThxUTZVL3g3NHli?=
 =?utf-8?B?UU1UWkVubVNPZHQ2VlNCbFVRRFR5cUg5M3dNbndXN0drMU1wVXJkWmVyR05s?=
 =?utf-8?B?SFBDZEpXNnJIOW9IdlQrcTJLYS9kY1U5dHlXbTNYUDlGQ3ZnVVlNcXdYTFdu?=
 =?utf-8?B?V05YcXdnSzZpcmg5VFJsRGFQUC8zRS96ZWx2cmhFc2hzQjh0eDBiRmkzZjVO?=
 =?utf-8?B?KzFyalJKUDZWS3ViL2srRjlUNG5lNUU2ai94YTFOcityZGdZck5CRDBiRTlr?=
 =?utf-8?B?ZGNvWnJDM0N2NnVnMnRVYkhCb2E1b3QyTUdCQjlOWFljTHVWVkxrZGxlZDZu?=
 =?utf-8?B?cnBuRVFmOHRyWm43V2JTQm5tdzcySlR3TkdQRXFEZXRsdXhtWDdhWG1NOC9n?=
 =?utf-8?B?ZHZiVDJPT1BYck9GVkZGWWtzV3NCQUtCdUhVbmpUaDM3MTgvUHVyLzlSUkdO?=
 =?utf-8?B?WnNpUXZDRFZWUm5wOWhBdUJPUmpNTDAyYjFScnM1TUpzaDg1UXQwUmRyMG5n?=
 =?utf-8?B?YkJZTDJiUUVXM3pPZW1menpnK3RCT1piTG0xSXlyWjVDallxQU51NVkrSEtX?=
 =?utf-8?B?TC9TVmN5eVBvRDZzb0d4RDlKbnNTQXA5aXNNZFVYK3NJSUNIVFFkbFJvalVI?=
 =?utf-8?B?RmtRdmNweUsyM2NrUndwcGNyN1lnTzFCL3lOMER6Zk1TNE5vT3lTWklGcFFK?=
 =?utf-8?B?bVhrWTZ6dGYrclpldThlWXAxRUpYUmlsVFJKSkxXeXpybXpiNHRPNDR0VnFO?=
 =?utf-8?B?bThjZDUwMm5MU3h0VFBhUEdPM2dSV1k2NzRPZ1BidEFkbGc3VjJ3S1BLd1By?=
 =?utf-8?B?Vm82bHZMZVZNRG0rQUNIalB0ZEtZUEhhVW5RbDFwVEpVUkpONWk5aFJPcWQz?=
 =?utf-8?B?cy80MDVHNFViSzRPTWNXRGYzVnlVaUwzWTlPdm92V1J1L2VLZUs5K1N5M3Bt?=
 =?utf-8?B?ZkZ6YVdhTUdZQTJZakNuNW1kL1IyYzE0ekVrTG13WVN3NThOWFJZVE45dFJR?=
 =?utf-8?B?Wk5nUlJEcklUalpmbUh1ZW9LY21qTGlpN0NlbnczNTBYUTlXNjlwR3ZBTGJh?=
 =?utf-8?B?WkJtQXR4OVY1L2pIajlkK2dmc2JTUEdHK0loajJadzdtRVd6VUJISzZYbU1t?=
 =?utf-8?B?TVAxNXUyWjBsa3Z2NlY3YlZGM2dvY29XVlNkc1cvcXhXNEVVdzB1eUNNbVI2?=
 =?utf-8?B?S1VHTll3Q080bytHdjdDbzlrTGd0QUxFWlp6bVF0WFVzNTk0YS9yY2RGWUlZ?=
 =?utf-8?B?Y1FjRVlXTEUvTEZLTlY0ak9PWmIyUDBEbExEKzFpbEQvck5ENUlTeTRnWmQ2?=
 =?utf-8?B?TFloTE5SSFMwS0pidGY4Nzc3YVhyNUtpeGR4aFhEUFA0NTVXSTN1am5xTUNy?=
 =?utf-8?B?bWozbkI5K2dONHVsdHBRR0xtSFBNS0tXNmFmV2VDV09NY1VjdU5UbHhneWhs?=
 =?utf-8?B?dTFQYXZXeUZJZVBsYU9VVzhpVzkwMzU0c3UxMzdzRXBabmdNWXQxUXBadGlL?=
 =?utf-8?B?aGozZW84QUdiQUEyQkhrRkErbStZQlR1NC9qZlBwcW5nVjNvb0thZWdZbnJT?=
 =?utf-8?B?di9DQU5zVmRHaDN0dkprZzcza1poRW85NlJFZUJ1Qi9zYXBBVTU0SURvN096?=
 =?utf-8?B?Wkdkd2wzOVpMTFkyNVU4NmtrelFjcm1GbTlCaCtydVV5d2pyT1VzZz09?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52c1a9fe-e817-4e6c-b34b-08df30297af1
X-MS-Exchange-CrossTenant-AuthSource: PA6PR08MB10708.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 10:44:42.5871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XmzK/r82wdRxVlLxN+MFiC/2g6Mc0FcAwdzIEKMrHvjtk1LWlqTWTgUE5XqrmMlxwyyJn3p6HdyPrjoipTpUHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5722
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C183040007
X-Stat-Signature: y34658zgn5b5toc6ebow9ajspm9mpujz
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792665888-32908
X-HE-Meta: U2FsdGVkX19u8RFSk2B0A7Cw4zHu87VMdruEQ2HPVzr4a6FNokSmUZzWwnaPs3r9oS7dpWWur1bVSR20Gm1sthmBkuLOckgSMDls5nq4zkMxsEHikRX1H40tMcpoi6Vpfa33JtQLi1/aJnXc7U7bMwVesajWvfk50+K0m/OaWbON9QBaJM5nGs7ivMU2AbRIKHcPfT8go11IJq7p3SI5KRAfcl3pgSALwMT+817eHwEG/MiHMTbESELVKuV5rNjJDaOmaE29Ys434tqmuuXuKaY26hoIHDUV7nFtRURkypKk9D5ZfLj9Rob4u3CX9q2mrlRixGCYWp+RRIFLB8dcJJI4+/aI85YzDqHMw49lbeTUYBWv6XWcyIOUtUsmUQRwVh6NWAa3G/JRLJ1qB4/SsYWEZnwTkwy9/kw2nEEW7Tr6H09GPje1MXvwm5pob8s8nVRgWGrsem+RYSuSJpIqmYRixxkXQcIST7HBVupzfOXUecFeSTKR46TX+9erS05s0OWUJt0ZWyz2dX9z3z+lLBbQGG/tKFLjAJY7qajf4DmvQFP8rXcaYAm7iKj9Yn8Ll/ek7vOPTKf2AW+907pJCQvblohC/7ZV8VRGyHYmE6a7MetZ2zbjHK4qty+/9O9DWyNxMXPoIrg2b7swEwYrUMmsh7jYeUkET+WMAKZ0n1yZ4XGUPbFyD05n04BlnNMov360WLiJP/jSmEYh7wgdvoEsvdPBpDG9GKTWfUnwTczNcF3RCDhJoytVhl+EunAYcmrIGO/TYrV+WdYIDi/N/cvgB9TqBg2B72ltfBQGfPPwN6jYdmAoTfZ7LnnyDJMsFMZu+1c4zWcz8vkcnl+8vPsoqeIHHWLDdLyIEm5zQsKWfguepRULY2Gd99D/YaF8G5FIKdwILt6dwMY31KyQbxzhYsc3Hf4CviOS5oF9XSQTTYHecrn51P5IsLRA2Lw2oubCJ7jfoapFcSFA6BH
 EsWTrp5W
 pr/fXe2WfjJAfOmMDBDKn1jKYSudZnig4p3d/Sh+neTCoFYkrYVD17lo2t/B7jK1ocb9U1H1WuVOYuKB128vG9NXt3Ypy9XqzMt9QFR+qgqAdqKmnDuE1Txc/jBjsBRV+8puCJjeUd63olV5s5qZIXn1VuJodPT/apB5CCg7NN2OYnfzSkVVEyagafUirptk0VSSqYaQLYjCyUBuE1MqX5SiGnz3b2+ezkFxqJ200iw1WiFXYI0+kEuwhzNZu/qJpJuon4UsMgTjJcKoZu22fKtixQ3a34zcO7+Nbmz9Q6688TvVXJUgBu25c6vSzL2WlvNPUscayLcF9CaC477Gst3IrQuTdz9g+J5VLUCXHs0L/QhUb+ACwPQURPquHcI65yxNHsNB17LXNoZQbxOYofIetlc8alsGYrbi4TJ2I5OqzXKvShGOE4DqNKeFJvRrB5aqdrGn1GFGUZq4p/4rXjrMqeJCm6ic8g41hPBcOHuaGANUCYjZb1BYnk5memDXay1GDDTM4Eh6qAzWYUZ3lnuwJyQmYR175WHP51F2VPGp9O1k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/22/26 10:07, Lorenzo Stoakes (ARM) wrote:
>> Fixes: d8ef5e311d7b ("mm/rmap: convert page_dup_file_rmap() to folio_dup_file_rmap_[pte|ptes|pmd]()")

> Was this a mistake in d8ef5e311d7b, or actually intentional for whatever reason?
> If the latter this shouldn't be a fixes.

commit d8ef5e311d7bfde54b60ab45026f206eff31b2d2

    mm/rmap: convert page_dup_file_rmap() to folio_dup_file_rmap_[pte|ptes|pmd]()

...
+static inline void folio_dup_file_rmap_ptes(struct folio *folio,
+               struct page *page, int nr_pages)
+{
+       __folio_dup_file_rmap(folio, page, nr_pages, RMAP_LEVEL_PTE);
+}

...
+static inline void folio_dup_file_rmap_pmd(struct folio *folio,
+               struct page *page)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+       __folio_dup_file_rmap(folio, page, HPAGE_PMD_NR, RMAP_LEVEL_PTE);
+#else
+       WARN_ON_ONCE(true);
+#endif
+}

Both functions were introduced in a single commit, i think it's a simple copy-paste issue.

The helper never had a caller, so nobody could hit it. If you prefer, I
can drop the Fixes tag and only mention d8ef5e311d7b in the changelog, as
there is nothing to backport.

--
Cheers, Konstantin

