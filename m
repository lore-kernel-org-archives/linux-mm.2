Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E442105F7BC
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 15:27:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 950A86B008A; Fri, 13 Mar 2026 11:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FEAA6B008C; Fri, 13 Mar 2026 11:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B5E16B0092; Fri, 13 Mar 2026 11:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 679216B008A
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:27:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 107471B6C01
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:27:48 +0000 (UTC)
X-FDA: 84541419816.26.9C1BC11
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012056.outbound.protection.outlook.com [40.93.195.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id 32B43120002
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:27:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rRDYtP+W;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773415665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jqXN54q+8fQ5y3QlTp72ArBpHFjr2fC069vojlgOKoU=;
	b=V6krxYCk6qc0QBfJk73Xcg3J3GEPO7CpQ+B7o53dkg5cxi6NYGXkWMrt10Bp6wLHDgPMDA
	XDQMIyL66fx+C7YbneSOXPYYTE4LUQGpE8nV1gENr2sfHz/pCsgxieyjYG+tJsIZ7dbyQU
	45iMxu1ey4zelY+dvY0WvajakssiEmg=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rRDYtP+W;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773415665; a=rsa-sha256;
	cv=pass;
	b=5Xw7NjfJCc+8qpNCROXxJ8k9J9hbMvkowEQrRLOiFkNADZDxFZjGH1a6me110QzYYk6WxG
	k7tKms5CWV4saKtlwEoH44bEKDgcf2l7PE3rlxEjudThr8xzKFDfAkORqxbO3NKC4jBLpX
	u7+ktP0VfTjTMoMwjUydZnQ2VYN242o=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XatkMuL9wfR+LxG4ZMysbxmp/ualSWPUCgEikCwVafle7bril0EUCoIhYhe9s/A1tmR4Z17fx3hJvT2tsSp/cvXzKiTtSy4QOA6WzlDn5fgmUM7kqKf1AvmSGdBS3eYB+4UjGgN0yogg8Udy44svh2+WYNwlZtRmUFmNOYeGdyR9KjqX3WRV2xCHqwe/VUdQodpcrUZmqZacNtWTudu+nvdviqkLfXHXifGNRPk9Bp6LCEKq0NuMk64jQirP+AIqZChwU/7rvCoIpWj3OGKH7GMdUnRRambhIVeL/muB05/2uwqq3Irj3lwHOd721+JffrR3ENDnfwyZrwmfL58Hdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jqXN54q+8fQ5y3QlTp72ArBpHFjr2fC069vojlgOKoU=;
 b=gLfBQFssWvgjSoIdLpYaVD0O9/TRML2zAAxHoFA1LXQUawJRP+hNwClOliW+0DpRJy6+1ynnN3H/I7qWL9fHeOhuZhKRprsfnCrA7hl67pg9nIgXeGpm3+R+gC69E7X/KYVnTvZhhgJ6wLVn6mupi8Ub9gGPjkWgkrhAoq79j/R+e+P60tZKQNh+QHLIpczz17bdOP7jHaMlhXdZG5NNs57mHFOlKp317wBTnMMPEqrYM3O5aolfiOPY4v5bCeI/kt7ZYTU2w1KWdL06ryVX5dO4T4JvyOqjIzNY2IY9Vs8c6iKNEmVkyKHPegxmCxa29zkzYTzH1MF23ulyDlcFdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jqXN54q+8fQ5y3QlTp72ArBpHFjr2fC069vojlgOKoU=;
 b=rRDYtP+W93wjTnx3wDKdeCBTykcFBu9cA4R7dba+hL3I8IQ6cKZtPssUKWgwddhAvcv50pMnlodWzQlarEnJoavui7X/lp1vW+rjhDT7v8FOfYr5PnXLmHVQSFJ5X9fh6f9SdzxzI/AWFhwpnzAoF3zlZSxS/PJk8BYR/wEreRIkhi4yBJqe5VsJstlKYXTa20G0Bihs5AUShjviQ6Eqx+ok35avHNhcFrRoEXzO0BaD3jOFAyyxXNr12TDkx5EAhD1MdBmM50Uea3hPKF77AGvaNZhqSSJNPstfHxXl/r2QB9Ym+CzWgxyn3sok5bofFHxM14fnu0ZGaFkiE/wtBw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB8312.namprd12.prod.outlook.com (2603:10b6:208:3fc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.7; Fri, 13 Mar
 2026 15:27:37 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.000; Fri, 13 Mar 2026
 15:27:37 +0000
From: Zi Yan <ziy@nvidia.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org, david@kernel.org,
 shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 surenb@google.com, mhocko@suse.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, Li Wang <liwang@redhat.com>
Subject: Re: [RESEND PATCH 3/4] selftests/mm: split_huge_page_test: skip the
 test when thp is not available
Date: Fri, 13 Mar 2026 11:27:30 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <DC5C1A71-2250-4723-9CEF-EDD300DD26E8@nvidia.com>
In-Reply-To: <abQqLQ_6QqVgzunL@kernel.org>
References: <20260312114027.634559-1-chuhu@redhat.com>
 <20260312114027.634559-4-chuhu@redhat.com>
 <CD772D2C-F489-498D-A61C-9EA0D377B174@nvidia.com>
 <abQqLQ_6QqVgzunL@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR03CA0296.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB8312:EE_
X-MS-Office365-Filtering-Correlation-Id: 0acdf10f-0dd7-4cbb-748b-08de81150e5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|17002099007|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	smzV/JU2/4Uo8Su8A9fAPk8l1hIrge89KIp48Ea5+1uZ+Y+GUqDUqTWNfHjSUsoIJ5jSxCxw2IHlDjDlCt+ACrGmgux0v1Xck5gmgMPhO21oB6j+9xs/qZcb5HNBum9GXlcyWbUV8KorsxDOeq7doThj72hnDNhrMLb++we61rs/0C42kSrr/cxG52SQJwIGzIf1SI3bUwewfnci8YrEmcZnOkDteqru4LWJGTgi5reSqpZbRTrUNWtxWWhx8qaasjhSOoQ+CK8q2kAyLAQ4UDtzFsfaS7rB3VNfVU66HYURA/v5hrMBEjdVoLPKqlWIlLLKVsti8r9sM6ez1URv4QqxTb4YuLcl/7v30Fqi37oArbFjFgLLecSUWoKH6g8WpqA8tlFYsRbnxJMKTnRaOCx5RnnbAXqz1yQ526/TsTCPL75o9tOkfspgmjKx7EOlB/tTzW4ukRJqYZd9kmWb18hCz/V3mS283MBwxuQxS4hronrzfnqyS+OAlujyzF8fPu0zqPxtfWGZ4IBWIbgKUIpqEjc44+b+N30AvPJHqvrVfOu2eHajAYeg9EyW1eaFWjlftZQlVvXMuz6kfRGCLYUlQl2V4ke8pGc+MQD4b2+hfTsD08W1jWPY6RsDfWgSG26pqi6dB+Io9LFhQ8D0MMglAf2TeFp+DD6sGIXp7scEBKzXRuN+IS5sVDNO0y5Cbu8K5h8jD4nxrdwAvTQ4sFZlvG3zsnkXepilHA+xbyA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(17002099007)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aHVKWm9oend2eXBmL3ZWcHB0bGJVdGhzY053SXdSMTUxZGtTTldZUGJQZ3JE?=
 =?utf-8?B?V05NNHlCTW9aSGx5UnFobmlXbkdLZFoxRnZ4MzlVY2VncHZCZm1XMkxCZENU?=
 =?utf-8?B?ZGF4OWNFWm1EbVNxWXpVdnIreXhiU1MrUTlBanZKY3kzZTArMDVlcGs2YWx2?=
 =?utf-8?B?bmRsRDV4VGJMK2UyQWVWb2theFQ3M0xrZWtmckpSREk2LzV6ZGdtVEdPUzBy?=
 =?utf-8?B?cEptY1ZuR2dhUGdjb1BqMStjVlEyMENRSmxoeHhxZS91cU5SUGMxQkxPYlhR?=
 =?utf-8?B?WVkzZzZTVHZxYTMrbzYxNFdWWjE4ek56d0ErMytEUnJpWVZVbjR5SjNqSFp0?=
 =?utf-8?B?UUs3ZzZxRnlNUW9kQ2Q3a0t2Qm5JTmdaZVU0azNWSko5TDh6TndCNXRiV0pL?=
 =?utf-8?B?UkVDL1hYSisweHpoaDNCTkc1K3c2ZkVvY25vbXQ0Y0dpV1AyUjNEKzhQYlZr?=
 =?utf-8?B?NE9kMW1zeVAwUjVLZjlabng0Q1lyR3pBRWlOcm81dXo3bjdoVHk2cStYU1R5?=
 =?utf-8?B?a25HQ0V4ODQ4RnBWMEtWTGE3aDNPMVB4TXJ0b0xSdXpCa3pQZ0ppZHlxN1FU?=
 =?utf-8?B?VURwVHRNdEN2NmpxNE82YjY4ZnU3OFJyYWpFNllsSklFakJEOW9PZVRrcTZV?=
 =?utf-8?B?dCt0Vkk1bTdVY2Z4Nk5TWXpxb1V5Q0Jia2kvQ2xPcHdMY2JXK0NjY3pjeG04?=
 =?utf-8?B?SVhEMkNtOEpseWc2UUorTmRoQXdvalNGMUJ3alVRZGJMRmJuK1lqWW1xVVZK?=
 =?utf-8?B?WG8rOGNPNm1BMXhoTThqVE5pM3Qwa1NML1dmQVpRZTViYTVtTW1GTURpWFNQ?=
 =?utf-8?B?K2RENHRYTTJtUCtYV0tob3NMMUNhRHdmM2hLZ0xwcHVETkhUcDlnbGpHS2V4?=
 =?utf-8?B?ckMxSjYyOW0rajczOS9rNzk1YzdSSi9xMzdyQjU5WDdwQmNkZ0gvMmFRNGdK?=
 =?utf-8?B?QUZ6Yy9wTlpVSjB1Vmw4RldMUUIycXRXdmNLNFZhVll3cjN5OUdRZDZKZEF0?=
 =?utf-8?B?a2RUMDBqRmpFcVNtL3dMRXc0T3piU3ZzbUE1R3lKcGtJbUQyQ3FORGxIbkJQ?=
 =?utf-8?B?a3ZVNHlyS3Jya0RHNmNSYnpXVWVnRm9WYUU0MnRuUmo4SFluZGJYTm5NQmlq?=
 =?utf-8?B?VStJck9mV1UvV0VoWlJnSC9haFZEZDJCcGNpMm5GdlpGWWdtWGp2VUNmbkFI?=
 =?utf-8?B?UjJZRUF2aTBnL3FSdHBJZncrT3pJczFxa3JISWF3TWw1cW1LcjE0TG1QaDB2?=
 =?utf-8?B?eGxqVnUzOWNaNlFaRklRYkdwelBkOFplWTNNT2FJWnQvU0lnNXJDcnVtTkdT?=
 =?utf-8?B?RDhrQ3p4QlNkLysyOGVIUjRBV1dRRTFrWWQ1d01tbWxGS0t2Qm1JdVUrYW1B?=
 =?utf-8?B?cXA0OVpYTkZrNlhQVHp2eVMrQmtJUnVhb1REcENkUng4RmlMZTlMZVRyUEZT?=
 =?utf-8?B?djFUcC9HSjNsZkI5d041aWE0elREbUMyMlRFQ0tmeWZQcE9Da1VZb04xbG4x?=
 =?utf-8?B?cEwxNkZ2dTJGZVpoaTVubzNUNDJiRlN0VnlrTFBQWFhhRDZVRGpmZkNJWksz?=
 =?utf-8?B?RlZ0ZjdaWWtiSTJLdGp0NzdoQXJ3S2RGKzVHOHBNR0ZCVXF1bVRPVmtWZ2pw?=
 =?utf-8?B?OTBEUkFqak9oTE9GclNpYkJobWxVS0loQTBiSEdHT3o4VnVpNysvNnBBbEQr?=
 =?utf-8?B?MXpCUlFZMlpMcVFIUEl3bk9pYVcyOFhFRzIvb25qSXN0U05UNHlMUEJvSUZl?=
 =?utf-8?B?akJVOTIxOU82bVpRUkJSMUNmRnBiM2VvdzBhWGp4NXhZNDZJSUpIZGRnVUlD?=
 =?utf-8?B?Y25kb3R2aVNpMk1ZR2tTZkx1YkwyaXdBdXVUQ1o0c1d0MTd1TGdtVUxKLytv?=
 =?utf-8?B?a1VXd1N0RWFMdnVqYTNxcXc5K3hVRkp5NE5LTWlnSjNsVHFoWE14RmJqOTd5?=
 =?utf-8?B?aUxldXIxVEVrNE9LZ0lxR25kdU8wMFpqYUxRc1lCaWJvSjNaNDN3NVlBL2lz?=
 =?utf-8?B?ZCt0eTVoS3A3TEZ5aUxXSVlhdExkWCtHNWo3Ky84R1dhUDlGNWs4RDIvV1Vu?=
 =?utf-8?B?YXFETFhrS3ZvOU1kNFZOUVRSZ2tCL2cvVlJIeWV0RmRQT3djNzh1OVdJUzBx?=
 =?utf-8?B?cDUxYUk1T1VqNS9YY3NMV25acSt6Z0NpSnBQblpWL1JxaFNyaWR0Z2JtNkR1?=
 =?utf-8?B?a1dNQWhUcUFHWHhzRy9VLzB4WTlHM2g2bk1rZ3NDUVZsM245TzNSbm1HM2Zu?=
 =?utf-8?B?Yys3RnF1UWR6cG44WWw4bWtCSFYxR0M0aEhwV2pMMFVmYTNOelpReWEzMVk5?=
 =?utf-8?B?NW8zQmZPZ1FDRVA2Ulp2enJTdWtPbHlKZXlSc1p2RTk0UUF0TzNOQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0acdf10f-0dd7-4cbb-748b-08de81150e5f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 15:27:37.1441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NEZhgflGly5imFIfEkFVQ8MaW8a8FkyB4fVKVWYQGc7RsO5iyaoAtFDbQMhcc9Vg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8312
X-Rspam-User: 
X-Rspamd-Queue-Id: 32B43120002
X-Rspamd-Server: rspam08
X-Stat-Signature: ohfhuk3k9i3fcsdxkjcb3bahjgdu6gr4
X-HE-Tag: 1773415664-775787
X-HE-Meta: U2FsdGVkX18aY08edc4hqHfRlmDrejhzOVGgVNmHE0n2CYLTaCzHdmtyoXnv3w6gp2LVl0+u/7i+znTpib1vEXIwfsvZRLxiB7Rxv7WlSQUrwSYiopztWO+qnwhPkw7QNIvakDCTPx6G2XrkMQAOFlRzL5u8NB8OLLzvu8Cr7+s60LBziOCMtgFDdv1HBQjsZQXKEHqQVRViNjeV7ro9Sb6vttX5f/iid2GMKvNL+j+q2ol1W3Ax6/+ZpjC62yOVEC//g7r/igVFDb/n8aqddL8wDGT+4cDT8xD825lBoI6k75ppg2tlVy1rvyPTvxZBizj1ALNWHXQGgOR9gfO6trOmvh3S4SpWNoBD5Sy3GhZBAy5hLHjiRDNEyyirvXbXpo+Jx+vjx0dTynzAov0ISzpdmTeqL2CuqKG0zPcYHhMFa7tlP/FmEq1xgddhdETVZM4yF12DId++wXk5XdNKtR5T/dfFhdK2OnK5XWnc3gh94dSr3EskL+7SJ7uivqBUKqyJ6dy6HdXwqyGqRQCrgnC4waVQPFMoehYkbLER8MNOgTmJSMig6rfN7HBtEh+bVMzWlcZFEtQkPUQ7PAyEnd09RnziGfUVdahHrBPOWz5TjNXwetwsiNilmHvPl/cjJtiJxH/1/dknSIeEgPfX++pE8jR4s+jmJqMUcLMZupoIqvVL5FLSj6/oKvgi2SBDziqMXguiSF5u1x19yJmQnvM0JVcxhu2E/A4Q/SNwqSSH7t3W/C7ok5EZ++Qh7YJopHH8gmYddM2up661j/frDzwVMPXES9FU7G+FsH4TQgqQpMBCj5F0cdOp5SlUrLOLJWJn3Mkt1Q4DJ4dLMx9Ek/lPhxnessUE0A3LiWZb7IckQsdS/GvQlevFhxKzv7tDoDpPA8lSvZrjtAywKpPtsQFqrxllgdqusTHFnHNmIYveqykYhPtDBba1h8l5F9qM1EBmHb0yrS9L9X8FljA
 JyQ4ZsR4
 WRs+72i+nkrDW4ALb8O6Rs2+DCGVaIICmJRQGfbKwfMXEAksotrOUOX0v+79LLBz+bNup6yZF2+9fyfATBPvOvIOv7H00X2ZvpL+jWYoF9OH6uL6Ro9C7DrROyq4fUbTpFUVljFoXx7SeHNct/mYoa+qtvbMSugS5NO74al67qQfsSU6bKWFKAgN7DjLulU8N6UHsfmlAkhhmb6ZXiGbuGusVKkKmauM5ErbAagtQFKHgUDTxi2C1zkqdiculJABk9kxc8rhdwflI5H5ZoB7nW050v3frf/4ldQfm/JsySyK1ii2E05MS3u3PwceILPpvR8j0kmul9NRUTRU+XRo3Uj3e7qYTpEdNjGzjHxW+zYLwEhncqenSBeYwIipcnzjxpOSsRdCjifeqlDGsRzKHMYrsRKpBZYJWIw2HlHEAUFKPwOveFRz1KlCw1OeEEY5NwdXx8KUIAvCyrYGA2FRwrixVKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13 Mar 2026, at 11:15, Mike Rapoport wrote:

> On Thu, Mar 12, 2026 at 10:11:12AM -0400, Zi Yan wrote:
>> On 12 Mar 2026, at 7:40, Chunyu Hu wrote:
>>
>>> When thp is not enabled on some kernel config such as realtime kernel, =
the
>>> test will report failure. Fix the false positive by skipping the test
>>> directly when thp is not enabled.
>>>
>>> There's a naming conflict on write_file() function, both thp_settings.h=
 and
>>> split_huge_page_test.c define it. To make use of thp_is_enabled() helpe=
r in
>>> the thp_settings.h, rename this local write_file to safe_write_file to
>>> avoid the conflict. The reason to use 'safe_' is it does some error che=
ck.
>>
>> Both write_file() do safe checks. Actually the code of both functions lo=
oks
>> almost identical except that the thp_settings one does exit() instead of
>> ksft_exit_fail_msg().
>>
>> Can you rename the split_huge_page_test=E2=80=99s write_file() to write_=
file_local()
>> and add a comment above the function like
>> /* add _local to avoid a function conflict with thp_settings.h */?
>
> Looks like we can move the version that uses ksft_exit_fail_msg() to
> vm_util and drop the other one.

Could work.

tools/testing/selftests/mm/khugepaged.c uses the write_file() from
thp_settings.h in file_setup_area(), which is part of struct mem_ops.
I thought struct mem_ops was passed to some syscall, but it turns out
that it is used locally. The only downside is that file_setup_area() now
has this ksefltest friendly code. Someone might want to clean up
tools/testing/selftests/mm/khugepaged.c with kselftests APIs. :)


>
>> With that, feel free to add:
>>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>
>> Thanks.
>>
>>>
>>> Tested with thp disabled kernel:
>>> Before The fix:
>>>   # --------------------------------------------------
>>>   # running ./split_huge_page_test /tmp/xfs_dir_Ywup9p
>>>   # --------------------------------------------------
>>>   # TAP version 13
>>>   # Bail out! Reading PMD pagesize failed
>>>   # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>>>   # [FAIL]
>>>   not ok 61 split_huge_page_test /tmp/xfs_dir_Ywup9p # exit=3D1
>>>
>>> After the fix:
>>>   # --------------------------------------------------
>>>   # running ./split_huge_page_test /tmp/xfs_dir_YHPUPl
>>>   # --------------------------------------------------
>>>   # TAP version 13
>>>   # 1..0 # SKIP Transparent Hugepages not available
>>>   # [SKIP]
>>>   ok 6 split_huge_page_test /tmp/xfs_dir_YHPUPl # SKIP
>>>
>>> CC: Li Wang <liwang@redhat.com>
>>> Signed-off-by: Chunyu Hu <chuhu@redhat.com>
>>> ---
>>>  tools/testing/selftests/mm/split_huge_page_test.c | 9 +++++++--
>>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/=
testing/selftests/mm/split_huge_page_test.c
>>> index e0167111bdd1..615b75ca62cc 100644
>>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>>> @@ -21,6 +21,7 @@
>>>  #include <time.h>
>>>  #include "vm_util.h"
>>>  #include "kselftest.h"
>>> +#include "thp_settings.h"
>>>
>>>  uint64_t pagesize;
>>>  unsigned int pageshift;
>>> @@ -255,7 +256,7 @@ static int check_after_split_folio_orders(char *vad=
dr_start, size_t len,
>>>  	return status;
>>>  }
>>>
>>> -static void write_file(const char *path, const char *buf, size_t bufle=
n)
>>> +static void safe_write_file(const char *path, const char *buf, size_t =
buflen)
>>>  {
>>>  	int fd;
>>>  	ssize_t numwritten;
>>> @@ -283,7 +284,7 @@ static void write_debugfs(const char *fmt, ...)
>>>  	if (ret >=3D INPUT_MAX)
>>>  		ksft_exit_fail_msg("%s: Debugfs input is too long\n", __func__);
>>>
>>> -	write_file(SPLIT_DEBUGFS, input, ret + 1);
>>> +	safe_write_file(SPLIT_DEBUGFS, input, ret + 1);
>>>  }
>>>
>>>  static char *allocate_zero_filled_hugepage(size_t len)
>>> @@ -772,6 +773,10 @@ int main(int argc, char **argv)
>>>  		ksft_finished();
>>>  	}
>>>
>>> +	if (!thp_is_enabled()) {
>>> +		ksft_exit_skip("Transparent Hugepages not available\n");
>>> +	}
>>> +
>>>  	if (argc > 1)
>>>  		optional_xfs_path =3D argv[1];
>>>
>>> --=20
>>> 2.53.0
>>
>>
>> Best Regards,
>> Yan, Zi
>
> --=20
> Sincerely yours,
> Mike.


Best Regards,
Yan, Zi

