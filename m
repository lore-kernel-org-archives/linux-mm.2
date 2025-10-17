Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EDD0CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 18:26:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD7918E001F; Fri, 17 Oct 2025 14:26:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAD8E8E0006; Fri, 17 Oct 2025 14:26:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9C738E001F; Fri, 17 Oct 2025 14:26:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8D5728E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:26:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2FF8557A27
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 18:26:50 +0000 (UTC)
X-FDA: 84008437380.26.3E6217E
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010048.outbound.protection.outlook.com [52.101.46.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id E6E27100004
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 18:26:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=PgJEafak;
	spf=pass (imf05.hostedemail.com: domain of Suneeth.D@amd.com designates 52.101.46.48 as permitted sender) smtp.mailfrom=Suneeth.D@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760725607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ieCfesjACEJ/SJsEQs4DTRcriEvIAR7+WXFZiF0M8kI=;
	b=15/AIgm7kDA0uVPzH+nNt2QVVSBgvoPjHl/LGiDKRCuQJcUr+z/d6mdKvKL7OdshyWy6dV
	GHUTJB73aPNK6PoH9BR5lOcoJBPYNQbF3YcJTHCVxoJFS6CetPdeUuVWD5oxvAuY0ttbVl
	NaxpwsvPMiSGKI4X7FYDuXI9/KPueMw=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=PgJEafak;
	spf=pass (imf05.hostedemail.com: domain of Suneeth.D@amd.com designates 52.101.46.48 as permitted sender) smtp.mailfrom=Suneeth.D@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760725607; a=rsa-sha256;
	cv=pass;
	b=uMZQ0wSsHxlQBZIR/ELH9YUMvQxyD8LxxOpJ/9Sk6jq5MXoAa+9nFz360Bs+aE8QVr+X7i
	ynTeM/aizC7QZTzZWFtSBg/7EZ9P0XQkJO8BefDEHcQAzZN8YZjCZtdKgpAtmlZH+oCqF4
	CSwWoLXEcMRRrmK5OKPHkPXBWoiDco4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bKzsFxq00o2IVeeeNSmVp+uoTAvQSERoynAIJf5YAqKzKMxp+J/d54aNpvHxS5r+v/kXsTvf5lXiKIVki9TKS+Ms/UcBhaptpzJ5/i1siiNLXf4erLywcyyzHIDRaLKMvN8Aie/mBtgdMrTwIlsNZV0bpEItydcF6gY1FlXNH8Qfjd/+Pb+HV9oxbdBm0KzBMIFxYOSJ3BeKGOENfeMI3y4VVI2LfG95JVdk3NgbIt4LTtgm9E+h2M7ElLhp+23oA2KUXEi2r3JZz7/OU49IhEXmTAH4rIGDkqfppkkn9Oy8gjmVVUj0ecE9B3Iglyr1/RXkOK3jmIG0b3nr4SOz+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ieCfesjACEJ/SJsEQs4DTRcriEvIAR7+WXFZiF0M8kI=;
 b=P8YIUtM1tOf8eHQmuFtgbTBpH+R2VoBn6QAtQP19U4gyaTnBQ46Vlsspk92CIf03IKi2vtQTesIHnUF1dlm31dlsj+r510Pxo0RRNOVsvETSDC+GpBZQzlsmV0uJ3//Xj2wVtvk7yv+m/q9vBh9iF2wPgGU/nbrZUEbdm60pCF9Yqds6YV/MiPKGCuqClTRuNBE+LrdXKF75PxOrQ941ylaASxQV8rwSaY+B2TAB7wzQueBJv1YIcR7jWstreLebCnVjTQAANu1u9S6fSTJSjtjbCRboa32WlDusBJ71pBkCv/eJO8Wepblxl2EvwA1+mceIR3LnO5pm162AyRlfmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=suse.cz smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ieCfesjACEJ/SJsEQs4DTRcriEvIAR7+WXFZiF0M8kI=;
 b=PgJEafakqcUu42FRqJt6q97QHc29tCZY9PX/o50JJ/RG9n6fmQznHFJI0XAJYwRD7Nf4RYFv0w3hUWZ7KSPrKyKB3GO2KTsJVXL+/O9CGIEyVx4JLrLwdaWiDSVpcI8pQIjR+C2RpJxJ0Lfg7IzfeVOPuhH0CI6xQbBGrpB7dPE=
Received: from MN0PR05CA0006.namprd05.prod.outlook.com (2603:10b6:208:52c::31)
 by BY5PR12MB4132.namprd12.prod.outlook.com (2603:10b6:a03:209::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 18:26:41 +0000
Received: from BL6PEPF00022571.namprd02.prod.outlook.com
 (2603:10b6:208:52c:cafe::ab) by MN0PR05CA0006.outlook.office365.com
 (2603:10b6:208:52c::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.7 via Frontend Transport; Fri,
 17 Oct 2025 18:26:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00022571.mail.protection.outlook.com (10.167.249.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Fri, 17 Oct 2025 18:26:40 +0000
Received: from [10.252.200.214] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 17 Oct
 2025 11:26:32 -0700
Message-ID: <156a1377-167a-4455-8a9f-6ad98094a7f5@amd.com>
Date: Fri, 17 Oct 2025 23:56:24 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "D, Suneeth" <Suneeth.D@amd.com>
Subject: Re: [PATCH v8 15/23] maple_tree: use percpu sheaves for
 maple_node_cache
To: Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter
	<cl@gentwo.org>, David Rientjes <rientjes@google.com>
CC: Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo
	<harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, Sidhartha Kumar
	<sidhartha.kumar@oracle.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <rcu@vger.kernel.org>,
	<maple-tree@lists.infradead.org>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-15-ca3099d8352c@suse.cz>
 <262c742f-dc0c-4adc-b23c-047cd3298a5e@amd.com>
 <ad9864db-a297-44d9-ab1a-61e0285eac5f@suse.cz>
Content-Language: en-US
In-Reply-To: <ad9864db-a297-44d9-ab1a-61e0285eac5f@suse.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022571:EE_|BY5PR12MB4132:EE_
X-MS-Office365-Filtering-Correlation-Id: bd0b8834-6592-4572-b490-08de0daab77e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NzlQbVVIOUNNZjRzUmUxUTI5N1I5bWNtQzN0UEd3TkpNbUpETlA5SE9uOXFr?=
 =?utf-8?B?V1RxWDlSVVVzYlZBUGU4RlliRDRwYzdITXlwRjZMK3JLOU5haVVxSUR1Q1NW?=
 =?utf-8?B?T3ZWOXpGTFY0T1BUbVQ1TFQ1TkhHMi9JblMwcS9pM1ljN0RhVnd4dzZ0Z2lS?=
 =?utf-8?B?TnhPdUEydHFIWmV4NnU0b3NqWjFnU0VZcGtLZi80TGUzZ1NhZUwvNjdvdkto?=
 =?utf-8?B?QVp4MzFKK2hObUlRMXFzSWw0ck9NODNDbTFsRjRKY1NoOGIzeHNJTFB0by9y?=
 =?utf-8?B?dXJ4MmlwaXJMbWVFcExXMlRXWm04bGlnaEtWZmlaUDdmNHVYZXFwL2R2ZE9Z?=
 =?utf-8?B?dzJ0UlNFUVhrVTRmb0tRK29SeU9BbWh3ZGdtU0UzYjRBOW1CeHFmSEVRRHNt?=
 =?utf-8?B?VXJHOElEeDBtRjVOOTg4MFZqZytXYkxjNmhVNGRNR2Z6UjNyZWZXbk9QSlN0?=
 =?utf-8?B?TFZ5ZElDTXhFQ0xEdTRiQUtCZllINkZXZkdQWHhCUkN6aW1zUG9DRHZtdldr?=
 =?utf-8?B?RmhMZFNGNEY5MUg0RVUwYU0zSVhlbmNkd1VuZU9FTmgzOVVhWXc0M1diYmxk?=
 =?utf-8?B?cXZtMm44RHZOSUFqVGtRbGFvcVVFUGxZbDByUERPVzA3RllyZVpjUjA5ckgr?=
 =?utf-8?B?dW9hNXh6YThHREJKTEFaQXI0VEVFVVpPUnZoRUQ3c2UrdkNOWmZyVlJwNFR3?=
 =?utf-8?B?V1p3U0MwTHBpZ0ZYMGZhMkgzR1ROV0ljQmFWcXd3bGk5YmE5Y1pHT25iditY?=
 =?utf-8?B?SlBLeVZYTFhBQU1vSVhHTFdaOXNWZFkydzlCMXNTdThrQ2tsM1NRYVRiK2dM?=
 =?utf-8?B?UG11OHMwaXo0YUJ1TGhzSmpUWmxQa3U1QUtwR04zbmZsakQ5bzd5NTZwREY5?=
 =?utf-8?B?TzZSMFIwSG9YM3BTZ1BsaHpIQnVOTlFaMjhkMS8reWEwS2JlSENMek4yQ0Nq?=
 =?utf-8?B?V25aUktPbXI0SjE2MGNpM2tQK0NqTGZvR3NPSlVaenZVMWpIZXpMZk9xT0Jw?=
 =?utf-8?B?TTVQT3l3ZnZVOEhCaW1GT0hPMS9hR2YxLzgySUZWWkJwKys1NTJNNHFwMVk4?=
 =?utf-8?B?ZlQxeWVSeG13NlppbG5WRVZxb0FDVkJ5MDRNczVmSWNHYWdmWkhIa0p1R1FX?=
 =?utf-8?B?bVpEMDVRS3FLUEhkMzNQWGxXaTFZNDNKdFVQN3lVdUVSUVAxem4rMWJ4Ylcr?=
 =?utf-8?B?QW9SZlp5ZXhSU1RZY1hvaktwUEVwR0VtN052ZzVpRG56U3ExVjZKWFFJbW5L?=
 =?utf-8?B?akhheXRKaFhQZThSOEljZ0JqcmdiTHJNdFBVTU9qdnlYOUxVSzM4SjJCMFBi?=
 =?utf-8?B?RVpQR1c1bzBSTklCRTRCV3R5RUE4NFpycTVNeWl5a0FlSi92c2RkSzltQitm?=
 =?utf-8?B?MENJVnlQb2hzdTQwd1lpWk1qSDJabExTd0Y4SStubC9WRWVOdnFZcWkrbXRa?=
 =?utf-8?B?MEFnemMwTGo5R0xqT0VNWlVhQ3cwWFpkd2NqMFJWeTdZV1RVUWZqdmtvWk14?=
 =?utf-8?B?TnRXRjZIMG9Id3FVMDhKOFY5bGtsU204L2crUU56R3h4QnBrNDJqVDlSejdw?=
 =?utf-8?B?aEIvOWxUUEZzYVFhZ2dvTmZiYTNmSHZYdENXVG5kMG51UDM0NThBSFpkR0Ro?=
 =?utf-8?B?dUFMcVkwdEFDMXJic016d3AwNVFINzkzQlFwSVFNR1VQYXBlTHpDbllEUFZT?=
 =?utf-8?B?ZGhxRmJYTVNtRllpbGNrLzFSUGpqa0loekJVQ2pUUlVVRzhRdk1GQ1g4bUVn?=
 =?utf-8?B?a2ZnWWptRno0eFJGRmN1TmdIT0VUb1VXdXVSc0dUV1pMME8zN0lCQkFlYVBu?=
 =?utf-8?B?TkRjZk1wdWZuVW8wQjROZS9mTWtkaWs5ZkVNb1V2Qko4L3U5TUF4bUFKbUFV?=
 =?utf-8?B?V1AwS2ZPSmg0L3MrNzArd3NlaGcyKzlTTTF1cVp0UjYyVGJOaEpsdXBlMGpl?=
 =?utf-8?B?UUZuSlNnWjVzaHMyRnFYajJUd3NjS3BoLzQvUittbWFXSlh5dFRKQ21WOHhX?=
 =?utf-8?B?UlpOOGZydlkreDJxTVE0ZEJDKzAvQ2d2KzlCSkNXT2owOGtxREN0UC9HWEZ5?=
 =?utf-8?B?eXpFaTVWN2d6YlBlNkpZbU5ERUNFby8xL1FrY1dwdFFpQmt3UjdoYVV2Nkcz?=
 =?utf-8?Q?WFzrrN2LSA+4rMvSMeedCfItX?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 18:26:40.6886
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd0b8834-6592-4572-b490-08de0daab77e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022571.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4132
X-Stat-Signature: z9ssibwsiff3ari8eqgkukc3mtzkmned
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E6E27100004
X-HE-Tag: 1760725606-966926
X-HE-Meta: U2FsdGVkX199mN/tBoJbhhpvR5H7OPfvntFzGye0TPKmfT2y6TvN4yIW1XCQHls9+iVbMYynZkVfUS2vkKLbvEXbchgmVmP5s+mMzZjxb8vbnQUZQ+WE8dC2AIl6Y8vaD6KXUl/I3jryYJcdwuLZs9AmmF1iyqkEf7D1vagJSQsIZ8xLWkIbaRB21R4mu2of2Zgd/fBDHL2AGSSC6S49ZJeDv1Vf6U/v3zPnWU/TlGdViFq7YGoABvZ0P8iOlLAvKzAJ9JhqVjc8LeBx8u/Z6cCGGkCErGLJlWcGeeSBBhO7IdS7pEoyjkoLc0wb9AgtVfQ7Va9i+SSgzy1gUpYpJ7HoDXcnUxpfGwmN5MNselpl+KYR0tg8V+kaU+jOZYiMPSN7BIVhpjTOOK9U6ALsgLpusZD+QylPAiQeOBdXeGPcaqa7FJSUtI8ZF8pXHtvfXiXaaIuaRin0BX7Dbqw7PRhn46vyhen0WFWqlZ9t7bt7wj07RX9sa8Onw/T1agnTQDRCEC+AXbh9zYfZLxreTQHpJM9jIr49sKjQObDJ0ujOMknaQ6MWMSSvQ0SrnIHsxxQwqcwvXnnEEgPek1kuRMkbMbgH9GOiibAP00IYPaX9IgS5F4P8RvjHppOM00x6SEMd28o7uPsPM2MgkILBbs0KI66ejG6M1T+wrh1mgXdtxRtC/9BGx/nboqNa/5QMZ21RNiuDQZZ4nF5JYHdhowLCd5NPQVRHyruL4VOjvZhx55zUa1UjYxsa0CsgCrPEfrDh/BN0P9JrKDKc++QnJop+JwfOQSfFfTxfQ1YGHBq5ATVQtME9tULNq8IRYpgGvlOTPjmZxHcRhqTk9RfKlA3e8amZLBlSrCQOk0F4A1o6Rv1wlH017U5EEtwFNphWibpPAG8euC/M0vlRAabBnXeeicdr5jqX/JQnecU3rHjoXx+PBE781nmJkX8YBB78GwZZpg7rXkbL2t+qvDt
 KUAk0bmv
 0amthhy+1HjSQMYWhzEZmCtMM86bBI29rfZOzfycDWiUi1OOo695BB2fZ4mLNfWruaf8z8RwH5d5g4SwmltMscMoqbFosNBcTC123uB4sBYPrvYLp6mIccmMCXWUu//ETzs4M4ZPS2Vycpeby/gd5oUGW0atdLwZEGkkk8GUXYka60Kd/2RLduMwovQE5pFXgy3f8nEcUv9SaKervPkSrSajrHvtiBjEE4EvkBfJxJK//OQVS+kJU6iXVk3EY41BGt/qMGUjz6ChLBOdr7khNg/FhCOhfQQHIxDpMfVSI7xYpnDXU+2AhhmHLpGzvsxIJ6Kqxx4g68+Wtvk0yx0aQiuKvebIrsbyv2MSn37JsDjf4rUplHuJS7YocoPIPVstZEGovYo712SglgmQWRHMwvXZlvThk5WqrnebE6gWenploMr7EgpoInkP7INOzRAwFr7m/qQXkAoukuyTS/RRjd5jVTjZXqxZV9OQrBQqUy/RC4Y7Z2eyjgod6yVE0K/X3Ai9/W3NhxEhhvkz6vc6tWyMwt3bJD2QieFlpw9XJoJe8I4ntAllHAcgWiIA/keJOIacQHRimcJyh9pOHrtpLkY4j4gFZsP93afqSGb0al6f+LyjwD4cCx2ItDOlhLfqDsSAN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vlastimil Babka,

On 10/16/2025 9:45 PM, Vlastimil Babka wrote:
> On 10/16/25 17:16, D, Suneeth wrote:
>> Hi Vlastimil Babka,
>>
>> On 9/10/2025 1:31 PM, Vlastimil Babka wrote:
>>> Setup the maple_node_cache with percpu sheaves of size 32 to hopefully
>>> improve its performance. Note this will not immediately take advantage
>>> of sheaf batching of kfree_rcu() operations due to the maple tree using
>>> call_rcu with custom callbacks. The followup changes to maple tree will
>>> change that and also make use of the prefilled sheaves functionality.
>>>
>>
>>
>> We run will-it-scale-process-mmap2 micro-benchmark as part of our weekly
>> CI for Kernel Performance Regression testing between a stable vs rc
>> kernel. In this week's run we were able to observe severe regression on
>> AMD platforms (Turin and Bergamo) with running the micro-benchmark
>> between the kernels v6.17 and v6.18-rc1 in the range of 12-13% (Turin)
>> and 22-26% (Bergamo). Bisecting further landed me onto this commit
>> (59faa4da7cd4565cbce25358495556b75bb37022) as first bad commit. The
>> following were the machines' configuration and test parameters used:-
>>
>> Model name:           AMD EPYC 128-Core Processor [Bergamo]
>> Thread(s) per core:   2
>> Core(s) per socket:   128
>> Socket(s):            1
>> Total online memory:  258G
>>
>> Model name:           AMD EPYC 64-Core Processor [Turin]
>> Thread(s) per core:   2
>> Core(s) per socket:   64
>> Socket(s):            1
>> Total online memory:  258G
>>
>> Test params:
>>
>>       nr_task: [1 8 64 128 192 256]
>>       mode: process
>>       test: mmap2
>>       kpi: per_process_ops
>>       cpufreq_governor: performance
>>
>> The following are the stats after bisection:-
>> (the KPI used here is per_process_ops)
>>
>> kernel_versions      					 per_process_ops
>> ---------------      					 ---------------
>> v6.17.0 	                                       - 258291
>> v6.18.0-rc1 	                                       - 225839
>> v6.17.0-rc3-59faa4da7                                  - 212152
>> v6.17.0-rc3-3accabda4da1(one commit before bad commit) - 265054
> 
> Thanks for the info. Is there any difference if you increase the
> sheaf_capacity in the commit from 32 to a higher value? For example 120 to
> match what the automatically calculated cpu partial slabs target would be.
> I think there's a lock contention on the barn lock causing the regression.
> By matching the cpu partial slabs value we should have same batching factor
> for the barn lock as there would be on the node list_lock before sheaves.
> 
> Thanks.
> 

I tried changing the sheaf_capacity from 32 to 120 and tested it. The 
numbers are improving around 28% w.r.t baseline(6.17) with 
will-it-scale-mmap2-process testcase.

v6.17.0(w/o sheaf) %diff v6.18-rc1(sheaf=32)  %diff v6.18-rc1(sheaf=120)
------------------ ----- -------------------  ----- --------------------
260222              -13   225839               +28   334079

Thanks.

>> Recreation steps:
>>
>> 1) git clone https://github.com/antonblanchard/will-it-scale.git
>> 2) git clone https://github.com/intel/lkp-tests.git
>> 3) cd will-it-scale && git apply
>> lkp-tests/programs/will-it-scale/pkg/will-it-scale.patch
>> 4) make
>> 5) python3 runtest.py mmap2 25 process 0 0 1 8 64 128 192 256
>>
>> NOTE: [5] is specific to machine's architecture. starting from 1 is the
>> array of no.of tasks that you'd wish to run the testcase which here is
>> no.cores per CCX, per NUMA node/ per Socket, nr_threads.
>>
>> I also ran the micro-benchmark with tools/testing/perf record and
>> following is the collected data:-
>>
>> # perf diff perf.data.old perf.data
>> No kallsyms or vmlinux with build-id
>> 0fc9c7b62ade1502af5d6a060914732523f367ef was found
>> Warning:
>> 43 out of order events recorded.
>> Warning:
>> 54 out of order events recorded.
>> # Event 'cycles:P'
>> #
>> # Baseline  Delta Abs  Shared Object           Symbol
>> # ........  .........  ......................
>> ..............................................
>> #
>>                 +51.51%  [kernel.kallsyms]       [k]
>> native_queued_spin_lock_slowpath
>>                 +14.39%  [kernel.kallsyms]       [k] perf_iterate_ctx
>>                  +2.52%  [kernel.kallsyms]       [k] unmap_page_range
>>                  +1.75%  [kernel.kallsyms]       [k] mas_wr_node_store
>>                  +1.47%  [kernel.kallsyms]       [k] __pi_memset
>>                  +1.38%  [kernel.kallsyms]       [k] mt_free_rcu
>>                  +1.36%  [kernel.kallsyms]       [k] free_pgd_range
>>                  +1.10%  [kernel.kallsyms]       [k] __pi_memcpy
>>                  +0.96%  [kernel.kallsyms]       [k] __kmem_cache_alloc_bulk
>>                  +0.92%  [kernel.kallsyms]       [k] __mmap_region
>>                  +0.79%  [kernel.kallsyms]       [k] mas_empty_area_rev
>>                  +0.74%  [kernel.kallsyms]       [k] __cond_resched
>>                  +0.73%  [kernel.kallsyms]       [k] mas_walk
>>                  +0.59%  [kernel.kallsyms]       [k] mas_pop_node
>>                  +0.57%  [kernel.kallsyms]       [k] perf_event_mmap_output
>>                  +0.49%  [kernel.kallsyms]       [k] mas_find
>>                  +0.48%  [kernel.kallsyms]       [k] mas_next_slot
>>                  +0.46%  [kernel.kallsyms]       [k] kmem_cache_free
>>                  +0.42%  [kernel.kallsyms]       [k] mas_leaf_max_gap
>>                  +0.42%  [kernel.kallsyms]       [k]
>> __call_rcu_common.constprop.0
>>                  +0.39%  [kernel.kallsyms]       [k] entry_SYSCALL_64
>>                  +0.38%  [kernel.kallsyms]       [k] mas_prev_slot
>>                  +0.38%  [kernel.kallsyms]       [k] kmem_cache_alloc_noprof
>>                  +0.37%  [kernel.kallsyms]       [k] mas_store_gfp
>>
>>
>>> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
>>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>>> ---
>>>    lib/maple_tree.c | 9 +++++++--
>>>    1 file changed, 7 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
>>> index 4f0e30b57b0cef9e5cf791f3f64f5898752db402..d034f170ac897341b40cfd050b6aee86b6d2cf60 100644
>>> --- a/lib/maple_tree.c
>>> +++ b/lib/maple_tree.c
>>> @@ -6040,9 +6040,14 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
>>>    
>>>    void __init maple_tree_init(void)
>>>    {
>>> +	struct kmem_cache_args args = {
>>> +		.align  = sizeof(struct maple_node),
>>> +		.sheaf_capacity = 32,
>>> +	};
>>> +
>>>    	maple_node_cache = kmem_cache_create("maple_node",
>>> -			sizeof(struct maple_node), sizeof(struct maple_node),
>>> -			SLAB_PANIC, NULL);
>>> +			sizeof(struct maple_node), &args,
>>> +			SLAB_PANIC);
>>>    }
>>>    
>>>    /**
>>>
>>
>> ---
>> Thanks and Regards
>> Suneeth D
>>
> 

