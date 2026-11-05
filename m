Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA93160A261B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iMm4qeok
Received: by kanga.kvack.org (Postfix)
	id EFC896B05B0; Thu,  5 Nov 2026 12:21:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAD806B05B4; Thu,  5 Nov 2026 12:21:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9B786B05B5; Thu,  5 Nov 2026 12:21:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA5A46B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:21:17 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2EEB0A0BBE
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:21:17 +0000 (UTC)
X-FDA: 85401731394.29.9A15B96
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013031.outbound.protection.outlook.com [40.93.201.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7404920014
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:21:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iMm4qeok;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793899274;
	b=SpjRmPt1XHS7FQf/1m8meyGwzqlWMyuT3sf7A+9sYohfcINXj4Swa6P1u/vmcNStjQbje7
	SWXBKg9gJWoO7WNty101y16IxTsYIBxoy5W/kahIGzeWTwVR1q7Sfb7M2LlQVflUco5+W3
	3M+S9SzURNcYZueSmLQJQhwi66j9lag=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iMm4qeok;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793899274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dcqcYW3CqDcVHuMmYkigWSka/w4md+kOGUL0W7bhkjs=;
	b=hbMlvfeZ0ur8h33UjhTYWCLfb0dzF4a4wOOeKMULn7kR4iOd7DFypj+hYJmq2EBQYoQONd
	2wg3aDAQoL8kDkvqqbhf6uW9tuZD6PZmXDUOrgSTffjA34VF7iG//PVkg9PVJbRqabRwxy
	/gOotdltSWVYJoJbPB9UqbLyDWvrWao=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lS/KM6TeI/tD7ndQKS6sWJSaMv5q24wzLkUqX1qf3qWGnW/kcXSMc00ljDUJHwX1eks9AND48yKoUWHFmOFrMVWhOtSjZGbtGGnc5QtnSIznWHG+SgtMZD9C8bV0RnS2MY4Nf81V2G09z6KGqnbyjoyee/mRshWO4t/y4Ps5KLP405furTx3Lp+Pjhco5yV01/sPgZ2Y6z1AK/onH4kfOGw51zIcyB640JJinvJYYH/oK+MF9737PFpSOCOnXJ4wkYh0WzH0VgJQ3uHW2e/GijZgYOxdD3MnWNPteYxUKpknGs919Y59VLdVVE3eNjkQotyhKTqlTaMVrEBeUA1JVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dcqcYW3CqDcVHuMmYkigWSka/w4md+kOGUL0W7bhkjs=;
 b=JghLCq561eulCU/V8eSehbrzkCg43fwvPzLxh1IxfgL06kZr5sGfIb0Z74HNTlniQFalkcJl3f9tFUuC9VWrXstqmea1Tn4Yb1RxLIJlOBUHATe33137jvFref7PRyMwcvX10tVjnqS0XxDB3khh/FqEP7q8G761+39twPYBbLmeVU+RYOMp7rB8ysT6hECyDAtDI2VUML4HicdhQz/zQtvu1stlZc6EZ5GmzsAjtJ+zTawJ0XQnXES5VL1dk1oH6n/0kewG+42tJcuJ1X2UQhTQD+yfjn9T/WqkwMKgPxsetIaR1jUFn4IUDJHvR2cFHycvzE5u/1isq+Q0/GAMZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcqcYW3CqDcVHuMmYkigWSka/w4md+kOGUL0W7bhkjs=;
 b=iMm4qeokznQTe1ZV28cI+EoIx6wVcWXrTJ4eZLlLPK7csNLApeQc5k6amknkBmVr9YypPG6tR7CSTkgCoU87yk/AVNdzYJepThCXpfR/M1kW6/x6Rj96RWvZCbY1ggBLpJyXcMtfdE8HKy/3Ea5BzQ6F1d2e0+a39WxeITDI5J0OT+udA6ZvgDk/iK20YyuSWD5luSirB2BB9iiGj72qIoHLJtR2BWH9+8f3a7XGnESBwyPLXQgDjKkzobnURdv+OHnoxcl/KbrL1RGknaTsck8oWJL+tHFU0B1/NpAKSnlU/IeP30bbp85lTjnucRFoJ3yyJlUCIUwLigoMBXiTxQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS2PR12MB320397.namprd12.prod.outlook.com (2603:10b6:8:70d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 17:21:10 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0592.007; Thu, 5 Nov 2026
 17:21:10 +0000
From: Zi Yan <ziy@nvidia.com>
To: Sasha Levin <sashal@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: add CONFIG_DEBUG_FS to the config fragment
Date: Thu, 05 Nov 2026 12:21:08 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <3BC61F94-0385-4603-B12E-BEA458BB307A@nvidia.com>
In-Reply-To: <20261105171801.2189772-1-sashal@kernel.org>
References: <20261105030242.1241448-1-sashal@kernel.org>
 <4B926B36-D797-4861-B6D6-27E8D7870287@nvidia.com>
 <20261105171801.2189772-1-sashal@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1PR13CA0179.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::34) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS2PR12MB320397:EE_
X-MS-Office365-Filtering-Correlation-Id: 6dbe5fb8-d6af-4462-fee6-08df3b612f37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|18002099003|10067099003|22082099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	Y2Wy0zoChY35iiDxQPNGmL36chYAnPVsod+CGZDeqk+9z6mw/52Ik9n/ufwmH232llzXNFu83QRWrQk1iuTfOTIq14oClzk6ww4LCaxVnnyzB7Sqpi++w3XOlxnbAKfZ/NtHzZOvN8ir9BcsR3CMw9irfc9OSMaz4f5axEJdu04lKR2tWJHVjbbfoo7thYTvH9rjs8jORJOfIlfLurrWzUFc0fh6oN+u5CatL+7wPV4jd5RwR4oUrhRo+RB6EbxlOm7b/LW306+T6+4vU8hl2v6QYhjvFWfJCfekcZKLPulYpdBXx/6fXQMZfsX0JebptGtGgIm6ZNAUZbD+VA3T1mbonVvbAqWLXmo3hKV6lRSeKIQLE2Cg0XdwUKSiEyDoja8FQwDf6Hdw+kyQwe4SgC/bdngVveiICVaZc8nbxYfj53r1xNGAascu5uOjHAATx7O0n9jI0D92GjPmiz9JBn+k3GNvl+uc5eJX1SeBgaaXF79IlQ1P4OrDC//ufN41pesunccRqaWg74I/cvw6lO6VKcUQJppre6sz88DqsPOaJc8opzuShBwqbK1W8OiJc4ohItce9R9LrSGjytbgabBbcq2F7kCSuXcBV7SzZKN7v3a1NQeinFzA7dGV7Wri07iHYhH5EfT1alEb5yFoE9BKOFZza3NJ6LqYdtJNMqg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(18002099003)(10067099003)(22082099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4eGZplk78v6xwr22DbpLXAwr+OvOI1LERdpuKmh0JyxYvELutK6pE1Pz67A9?=
 =?us-ascii?Q?dGy8CfTZVc1Z82SaWd37Tj7SnwePrUyu6opbItLN/dtpYXUDDhHIsC4sVAIo?=
 =?us-ascii?Q?rWF4T2aNBnZ+jrqOEczjzzRVKgsHmJQ4rPy2KoyAnwMjvtsYQl4iHGShvFku?=
 =?us-ascii?Q?jrv4/6L2VSnFdpluuWuSFEV5YAolbXAJB1nbI7CbX2bG04jIVW8wgKFNdbIl?=
 =?us-ascii?Q?PowsmYPn83q1taIJaWeEySpCruo21q9ZIEYFHypllxkXs1KJS9QCjkqehxrr?=
 =?us-ascii?Q?GP5EMPlJE9llgnHQigHw8kpJdjBf7j90WbussL/h4flVzyebLgMS3xCYeEqS?=
 =?us-ascii?Q?382Q/mDpFxM2SEVgvMRUaYLMamkUGMf+L/F2QtFlhoefE3FWW+uY/+4DITC7?=
 =?us-ascii?Q?qHcBUZ/ICI+Aby+qHVEBYl/fcdSbB/f9p+t9ZR4t3gumMJZ4n3WWkGTJdXxm?=
 =?us-ascii?Q?F8Qk7+hoJjeiJppoHx79YKPH+XtGc6SP1x1m7+UA5Ik67fnJh0JLcX3uuSJ5?=
 =?us-ascii?Q?Y224dE2/zWSmoxKMB3q2NODhtCnrOOyMW152fpFnMQbVbUmq3Cm2Nnty4/hs?=
 =?us-ascii?Q?GhuyJ3Q5qzHpL5w2QqAT3yTTvtFohCU+ZTIZN+cwCW77YhsQsfTIYfdu7GK5?=
 =?us-ascii?Q?m3W5Xgy8s5YtYQF7OpUV6O329jglZoTUIELW6WUvKv1B1DyNouVfp9rjU39J?=
 =?us-ascii?Q?DuJLxSLG5z7SuYlRXpL5pcKoO8FhdUCn5Z3kRXk2frJ4QkKON9PSxhVyJNXm?=
 =?us-ascii?Q?9kMHxnm4d0O5kulw3NaRQz3RKkFi8vmBRPVdAVI24VNV8frba5wXwI4iQevS?=
 =?us-ascii?Q?daalEsnDLTyLftTgBdWETE35faIdwzchox7fMAs3RlpJLgaJfMc2eefiXTMF?=
 =?us-ascii?Q?fYJtWiQTlW90Zu5Kj81oYO1bA7z7ggIdctPOSZClNclW5VObl2FQ3OBak7C3?=
 =?us-ascii?Q?4itOtl6oTUChO+Tk9F+4QvoIvrnxH0NcZW3qo2dUA0TkA3TktWtv38DFadg4?=
 =?us-ascii?Q?C3qRUvfCxhz9d5IDE9oh4GueYAHVBdNHUzs24bJa29Hjxg5XpUGGcAB9w2MZ?=
 =?us-ascii?Q?UuModgjVvma4XtTL09LzPYrmYfHl3FKM7DUKCvuCzW4+Yo3Vk/EJsaQ7jrPo?=
 =?us-ascii?Q?B2IjjQqXy5AqfZ5kK6FXvB2vnR3LXE1E9VBSOWKHZl9SJbpI6gnbRLcD2wec?=
 =?us-ascii?Q?o1gsdNwdsT/OK/2Mhb91Szqrwzbvk1EPZLQ4git9U1wj/q4IKZ0NDDnKbcOk?=
 =?us-ascii?Q?11GamhQTDRk42NyMRfx7L7bPoOw5592VeFSbDFaF59BQC4BZYQmzeP8Bt4Md?=
 =?us-ascii?Q?LjYPwGUAEgX2ll6F0etnjVFVwcnJn7/ENEMXdQz9FdA/Fdid8ZROYCLzdExz?=
 =?us-ascii?Q?9vhhyTegdlG70ujugKurQ63oc+6HEf8thkCXpiBaj2TYCnL3dV3xtXpcfEiG?=
 =?us-ascii?Q?7hURkCrKdD66iyRG/ACreDtvFNUuMpQWDiIRq+L75sIUXOBPlguGLgeCYjPh?=
 =?us-ascii?Q?U61hMQP7PWElObFt62rxLKfOiM5/jteQbGH0cT4KSm+1ZrgizSrDwgj+RBmk?=
 =?us-ascii?Q?2J+vE09M89a9X2YbbWsVtm9UztNqGbux/v11rNlNMdn27dRtsW35d73VucVr?=
 =?us-ascii?Q?u2Fe9tAFjaKWC8qhSxS21tDLWkh5WY7MEXMcYJLU+0nsVWfpLR9+gnpj4iaV?=
 =?us-ascii?Q?h6KTk9oLRhjvB34CNBc7USYf5TENcFRIFeJMOltr4vjH+PP5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dbe5fb8-d6af-4462-fee6-08df3b612f37
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 17:21:10.1470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YXDyTG/McI/qKkUp5O/ariTbVfqDwNXHfrIdAmr/Ysq1gNj943Z8ydfjwh7OEPBQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB320397
X-Stat-Signature: 57iqwsb1yegoojg8tgrzsi1w4gbdhoha
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7404920014
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793899274-346376
X-HE-Meta: U2FsdGVkX19qhqz/hREF8nrJt935E2JIpa0G4WUD8xsRnGaBVU5el046Y4lCx0TuNFT6ya2F/qNP79M5hNUmOyCnDrP2X1aZ+/5UYPq/lwRmP9PIilX2VLPH+pORuHB+1G9eCDe9yJtk5SccOZhrvkcf6hRTHr2wlCfzcUJ0AKmS6cEiYbMC6OgDq4KtDhLduEEllyMGorSkXgh2wsRaUaXXnsMKBimiIP3nXa5JSmm6J5TH1E2wQLQ6sxWZ6Kr4zNAGqvVUPze2DU6BLwU1LWnFsVa4mtGFg4U0OYvoHaLKQQ7tc32dWL/1HZS6sDit/U6gGcX+A4iUu1705Gn38zmApYjo7/JVUF5HjAzcl+Igr26BiFyJIHS5rEMYas0+ciRUeYqVrFeL69Y02zkLt7zwuzcykBLgqh80gJznRRPzmtRVSMPsylDcJ4SP9+gKqQ0MiKELH3Po89vvlCAMsJLHXUhDOUKmk2OgqZMpH5sJUrru6HeQh98uO/f/BjzRuFW4cnefPHfPNI//aWbelvc8BOR1KmqDdPOLdYEB+R+xEX0mw657a977MoOPTFm2TRtXXOjlztmfLlo3EaKJv4Hxxl1JXYGuQxLChIVivLsgQ6A7ZG1YqjQCY69Xv7GJGtLOts9nfsIM9O9Ugk1JiM3F4G/dOJsDcGaF5I89765ThdG91bKQJtfczrY6sSxYMf8S6QzV8hvYJvub1j8VXr1MqTFR0r9NEU/qeguXI54QVtiicDXEwaPyllDLxwKgDV6zAJaAbbY5nPEWbnfC0Qmti9PMumGpDXXEMZ5531/nfmJdJAQbUF2ArlDknZaS+BNS1AwgbeqZeTwHfPzZ1p7GtaSvVbY7nDURSHSVeBOu+qpsywzDUeMW23ztZx0GOq+DojZZ4i9YHQcQMycZqinKvNaPm4gkPtCwJNAyGbZOabSRKpCWL6qdPqTi+FwKreU+M7qwPnjjaJgeAaK
 uz4QC/AF
 5z+SkagsvM/ta8b7qDDOtWBGEqGiLdURJ1EkWBgkS7A9txs0TQAPTrFs0QCwUvUXdPIuRsJCnJMoqFhFpSnF3vjxTl/AfLgVRm7lFAqOqL9NInfsl0F5f4ZUmvpQ9mzCumJ5ziluF+R9SzuPWgFPYDWjCGRrCUYgxWUpPL4DDxMYewr8mdhx3KTcA6Xy7WMH7f3NEGAem/9EBJeOZypkuv98PMhmIcbY0cN0ETh9Uv9KX0jArz9NawFYql2jXeaQbtI3Jm4obxj3BoPTJOTda+0ArCvKIi21Hmz0he/03UltowrJxI+6Lz1d+Wf3eN4w/zdXlWKOgzETUsExjYtITxTMfq/dBYFcx5H8OoThPt4Pywkx0uEU37rCsrA+d/k8eekbKCpWIU4fJC+4UvDXzAYu4i2J98fZjzr5nACsmnCPk6nJhqsslc3shDj/tXcjreDBSEol+IbM2JyI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 5 Nov 2026, at 12:18, Sasha Levin wrote:

> The split_huge_page and gup tests need debugfs, and CONFIG_GUP_TEST
> depends on it. Add CONFIG_DEBUG_FS=y to the fragment.
>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> Merged into an x86_64 tinyconfig, the fragment leaves CONFIG_DEBUG_FS
> and CONFIG_GUP_TEST unset without this change and sets both with it.
> x86_64_defconfig already has CONFIG_DEBUG_FS=y and is unaffected.
>

Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

