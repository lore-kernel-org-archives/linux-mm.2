Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06DD2CDE009
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 18:27:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B723F6B009F; Thu, 25 Jun 2026 14:27:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B238D6B00A2; Thu, 25 Jun 2026 14:27:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ED246B00A3; Thu, 25 Jun 2026 14:27:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7831C6B009F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:27:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0DDAB1C5450
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:27:00 +0000 (UTC)
X-FDA: 84919266600.23.29BCC92
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010009.outbound.protection.outlook.com [52.101.46.9])
	by imf20.hostedemail.com (Postfix) with ESMTP id 324401C0009
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:26:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fi4qdJmH;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782412017;
	b=Kvin/CbwdLrAQQTHLjjFycp/VKjqkA2IHgaN63cjp5y2TYPlfZ//TODnTqW1ffooGV4AkH
	otd6AKs3JCxzhKOar4y1nGiRxH86ammJbTvPyQ4QnlW3QTeaGwFW0e6B2feg6K1BP28Eyw
	xauYK0FCeS4F8+G8F1uxbCi0dIIP7OI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782412017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fuwztvLU5nGoOhyPcQkOeYY+w2ohT/S4bIN2BafKmIs=;
	b=UgSK4DT3LHNFQlUjLXP76+npjgIlMb68zwfqVDDvwSm2YEYwePhs7L9YEujWqN2mEBb6q2
	jGJf/dvhRkgR0vGgwb7t51wErKdHHkj2jDMhWMx752jLOE47jRz0DuJ5EjTEplbKpjH76t
	seMzV+4ITqHSYFvzO9QFsxKBH61Q1Ck=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fi4qdJmH;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=agW43CtSoV5hQnFe1QXxYt55424I20MfjLZN4DoSlUb0ixC1EUbb+bdYg+Wni26sxDB1xKAzOfweAh37yp73gWtWgIqz+/CBL1HNbMZDMqqbKW/TMByLuPribYOZBKfPWHuVUtyCRoPyjKwSUc5Pm4gJHITzaoQEOelRrC/RncAnUqG9r9qdaEN6M4mgS1B1ADKXl/MGkbrK3w1gMob+Wmyu+MBVxmNNaUQc8oaPNc7EQpQGuBepqymcTeUIafz+sxTHrAciiQT0HxTdNQbqtJ5jQbd+MHAxWvOAs5s1w5zTg5aOTktdZNK9Ec9nwsiCUg6zZPLxlkm7inIffAdQ9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fuwztvLU5nGoOhyPcQkOeYY+w2ohT/S4bIN2BafKmIs=;
 b=Fnz+svWzhRkmALahteIXE+lnaQ0wPeNlydeWxNndpgE6p3dQoIN5BgG1i2C0Au/C2Lkwe2BHA2E2AyQHfTp6b8OcX1HAGsYute6a6dOQnpoQapthbA+FHMYr9/M/iZZIYt9u8et/safmNChOd75OIVhilOCSkg44h1QklP8HC1xADFcR6rNdvVsTX0ufls1311S/DzvS/9rLX0STZsAs2NTIJqzzz8SqYWFNJg3aKmB6oR83Y2llTHInIuGVw8XfuL6D6pa/Baa7ayQgsYSqMmt2qKLuxAUl1Ku1xFWSWvxzGoJF0PKgSww5hrNKFL4Ds3aoazDWWPWc7wOZFlWtAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fuwztvLU5nGoOhyPcQkOeYY+w2ohT/S4bIN2BafKmIs=;
 b=fi4qdJmHEeQcHahIcFj+wzLiZ0M5z4Mmr1C6mIJpr8bOpgUs/zptK8saagOwwvmci/5jKm4pNBNPDCLZrE3oWIXACSTnaw43eUsNyW7I5qjpcJ9TjTMNm8OVb4skfJr7K0WW6rNp5Pw4fW0tcKyAVTVYEfVyc3GZX1jPMRShhtE7li3sMAkzi98vvu7ysLPJ/lfIjVpYGd6skMeo4ftjU2ZCpNTPiz4Bwbb0LzM43Rs8TAmYGtgpJNxmLf/72n56+7tFsbSraKdkWzVHDNpddIodlmBeYU8gA6tzo8EDC8IzTSSovtNvth0OaFBdBNcBRrit5chXYyFcLvLJwVuLZQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN6PR12MB8541.namprd12.prod.outlook.com (2603:10b6:208:47a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.17; Thu, 25 Jun
 2026 18:26:52 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.016; Thu, 25 Jun 2026
 18:26:52 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 25 Jun 2026 14:26:51 -0400
Message-Id: <DJICBQ0OIM2I.3VWL2AQBX12F5@nvidia.com>
Cc: <surenb@google.com>, <mhocko@suse.com>, <jackmanb@google.com>,
 <hannes@cmpxchg.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
To: "Zhen Ni" <zhen.ni@easystack.cn>, <akpm@linux-foundation.org>,
 <vbabka@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v11 1/4] mm/page_owner: add print_mode filter
X-Mailer: aerc 0.21.0
References: <20260625043101.338794-1-zhen.ni@easystack.cn>
 <20260625043101.338794-2-zhen.ni@easystack.cn>
In-Reply-To: <20260625043101.338794-2-zhen.ni@easystack.cn>
X-ClientProxiedBy: CH2PR18CA0029.namprd18.prod.outlook.com
 (2603:10b6:610:4f::39) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN6PR12MB8541:EE_
X-MS-Office365-Filtering-Correlation-Id: ba2a5f1f-5a9d-4c43-325c-08ded2e75459
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|6133799003|56012099006|11063799006|4143699003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	fay/kAIWHcjvTkPhNA2SO178EWIkK5PajDpwAHA4or8WQcz83sW48wn6yPS8IJU0dXzr0hQArHwc0ssL2O2JplUe5/QokAo10gCWqdGHVzLYkGjfLw9/e4xmsnmSrWc4RjLVgD/h9aapI4/tudphG6LZAUmwmxALdjCHw544z8LmdztsCeFSp5rkkA08+RK2NuVBcUNbPscd/YxpsaS+QyQf3FrdsQIplceiS27CmBmD0qswzG2fCAUxNLBVXjvaWbYhYlFs0G5vyUI47HPe3BW8lCkQreghcY3aPhBRcGKpFavSPfvYhEqrHZMuIL+Mb564lKjI1OtAVIpEnJQxsv2t23SMtI/xCuDBXujLHlZjjGldv4mqQ+TtyMjCHpajcyKCb0RZSPM3xXQ23256lFoZnLoBC+Bi+9YhBt7Gyeyyoj2hSGFSeAlNkpQ0XOa3CkyvOTdH/FIz7cHu4K4LYgttHkoGHe2FlscA53LE3/51G8rrUI4VktdMtSUakVkYVh9bEF5wLm+oRO93U3MIneuIaPVONdaTIKe2tYGRHFVwYOktlJkIZCUSGoEOrassQjzj0UiqHSpcTEoKHx+oi6MNngTsQIu+NQd8MiUV4jKYtdJ71KCLcWC5Vh0NxZEDpUH4fx8VVOMFEO8oOQAHpwCn4I835IeOHaInLWzNxjM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(6133799003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bWtWYzF6UzdPc3dVQ2g2Yy8yWEF0N215bDBwbUxYMTdpUHBJcHRqam1jOFA3?=
 =?utf-8?B?RGoyYTJmcUd5MjdBTi83YTJTSWhSdUNsY3kyUmhjR0lteHZBK2txMTNXRklw?=
 =?utf-8?B?amswK1c2UHlNRG1FbGVQNnJHVXVJUExNeEJ3SDErZFUzWjFiWEVueVNBbW9W?=
 =?utf-8?B?STdQMUwyU2twOFNjcjc1RUNNZTU1eXFtUis3T2Rady9Wd3NLYm1ZL1BiOTBR?=
 =?utf-8?B?MHdSeE9PNmh4bXdFalhrZEgrZmpjTU9sbDdnald3QjNuMDZnV3VhYldBK1Ns?=
 =?utf-8?B?aVpjUHpjMXZUMEMrZUNLWW9RYUpreW0rdGp5QW53ZGJCd0ZQQ3p3U3F1N2RO?=
 =?utf-8?B?VHY4Qm1CNzBQUkx6M1R3ZnRjVjBxZVgxU0s3RDI5TCt3NzFlQ3lwS0hSeHh3?=
 =?utf-8?B?Q0VaM2JxbWN3RjQzSHdiRFVYYkZlcUxyblRwTnRMeVcrR1Q4Q2Z6UitXUnd1?=
 =?utf-8?B?ZGZWdm1QNEdvUnFNMzc4NHp3d2s4aW9KVUovWGZvbDJmR3pnR0g1U1RVNy9x?=
 =?utf-8?B?STkwR0pqUzB3dXdFSzZpSFowUHk2R2drY3I0U01kcGdwb2UyL3lvbHplN3pD?=
 =?utf-8?B?TnpsR2MrRjZZK2JDSjBrYVZ5b0JPUmJkQnRzQTd1VDlnZmtLSGw1cUZpaVlo?=
 =?utf-8?B?WWhNVGZXSjhISytyRnduZXpyUXlMOGJQNjB4QUpra09BSWpSVDdiMzZhQTNE?=
 =?utf-8?B?ZER0dWUweHVhVXgwZDIzeW5hZ0hlaDhZaWk1NXhWRmE2V3ptSGNLZTJ3c0RE?=
 =?utf-8?B?V29BbzJsalcxZm00TTcrRzh3NExaMDc5cXVSS1U2OTZTb21JMVp2WXRYWHZk?=
 =?utf-8?B?b0hzblN3TUlPUzVWUHJ6bzFCQ0VjZEZiSC9aNFE2UHRSSWQ2SnMrTE9uc0p0?=
 =?utf-8?B?cmx1VE8wQ3lWQ0lyNGhudVkzbHZFNDA4Um5uZTFHanROa2srVDBodmRrcmUx?=
 =?utf-8?B?MHFnRWRwWDkvb01KWnVGT0RUNE9NYitpQytiS2JMWTVNK0RDcXF5bWdCWDlS?=
 =?utf-8?B?M00xVnc3VklDK2l0bEt6NXN3cldGRThrRXdaSkdaU0J2dEdESXZXTXZkTzV0?=
 =?utf-8?B?WnBCUWYyNm9UZ28wa3RkTC9TUUUxTXExNm8vZlJlUFJ0OStxV3dCQWVpQkYw?=
 =?utf-8?B?QXh1cUtvcWRHWmhYalRjaGRaWGVlclRXNUtqRVBTZGdvbDhVK2xML3QvK1Nr?=
 =?utf-8?B?eW4wNnZ2ZGRRZkx2Ryszb2pIZDZNNm9Eb3pGSU04S2lKNk5WYjQrSEQ1SjlW?=
 =?utf-8?B?M0x1RmFHZnUrMTR3RkhiQ0dNUURmYS83Z0VNNDlsaExZUDI4cHd4eXRsTUEw?=
 =?utf-8?B?SFRTcmltZis5VXd1RysyaGJvOGszRUx5WU94bE5SMUlONng3TXJlWm00VWI0?=
 =?utf-8?B?bU1iL3JPdEZMdXVHemYzdnIrcEkveG02azRveFZoQXFOVkNDT1BBYnJjQ0kv?=
 =?utf-8?B?V2I5bmVwZi90aHAwcFFudk1xUGgvK3hHK0ZIUlEwU0NuSU8xdmxsRmZPSG9I?=
 =?utf-8?B?cHdMM0dmcVhMeXlXUFFwckxlaSs0RmJGa2FCY2lHMDVPbXBkb2hjK2dvdHhB?=
 =?utf-8?B?NVBlejhNcFVvQmRtd0R0cG1nZkhISTZTeEtWZFVJSmFaUWozVjA3VXJVQ1lI?=
 =?utf-8?B?d1JlZ2t4MUZoOFVlR1ZiSEhrN2xtNVIzSEZSdFlaUjJNaGE2Y0U5a0hGV0Y0?=
 =?utf-8?B?WjFzSThIbTB2SCs0UlNhRjU2OHFWS2VwL1oxczk1dFBKdEVSOHhPSGxqSjhR?=
 =?utf-8?B?OEtHZWJ6Qmt1WDNLVnlJM0t5Y0VyeVc2S283OWprSlBIVFNXb2tTUzE1TWNH?=
 =?utf-8?B?ZHNjUjJsZzZtUlRYTW5Zb1dIM2ErRUJpNVdEVHlOUERPc25tNE9jWStUNER1?=
 =?utf-8?B?M1lyNlFWeWh0ekdmdDZ2ZzZ4YWFObkk5QWc5Q1VPbXlFYmhFdklQOTRPY2x1?=
 =?utf-8?B?Q3dLVC9jc3M0K1hzejNKZFNhSjJsenF4K0d6Q213ZG1XQkptZHA5SkFvc0NQ?=
 =?utf-8?B?U1ZIYkNJc3dPZCsvM0JGSXN0cjRNL3BNc0lxaTREMTJpTEJqUXYvZ3N1dXBJ?=
 =?utf-8?B?WFFhVDBFYVFqOCt6R2twRk1yTFFZSzVMSjBmNUZEYzZQRG10SVBsSnk2WS9v?=
 =?utf-8?B?RkVrQTZvdW9OMzRybHJLWUlTTVF3cHVwMkpIVW1xa0ppalgzZ0FaZzdWSnZj?=
 =?utf-8?B?aEFMeWNTSDNkVnZDS2hMY2NlR0xSTnRNeGEyRHVBbW5jblJmRWJ4bVhWZ1Bp?=
 =?utf-8?B?NWxOSFkwZmEvellkYlNUUGhiRHBwL09JV2FYSWxUOVpMTENxMGNFMkRRc0N1?=
 =?utf-8?Q?fHvBB611lEq8R+81+/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba2a5f1f-5a9d-4c43-325c-08ded2e75459
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 18:26:52.8899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l9HjUTm3iBTfaDxYcWFI8g279D0ICKXWAPw40aKFpXlH9bVq8K8ARV4qFEI/aDER
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8541
X-Rspam-User: 
X-Stat-Signature: f4gdzfuwn3dw3tznrsqpx8y7qitd6w5k
X-Rspamd-Queue-Id: 324401C0009
X-Rspamd-Server: rspam06
X-HE-Tag: 1782412017-532309
X-HE-Meta: U2FsdGVkX1/QbelWHz7jQu8Tk8WPIAv1DeZeLVIEw3AiW+tlcWBfDRDQ8DHjYyCFvZqMRNcC9MsGRdVT+IK4sEcaTAo3EvWTZ+Zpnk9N3MM1RibIpxJGKBf/ixmlmKMfKrIjZJpDeKiy1uEsAapmgUKDgiEWKAHvMiYV4PZ6DJjaLe9WfS3jIXRpfQloJlW1kpSZYaOkKylcEAqTrV4RBoBBKvKFvyD3YS9ftlDJnzpweqv1SADpGacnPFe7JWBRmwYnSU1h0+r1RrhHaM/jR9nVFJdYpvogy5FzQim0zN1Ed4SbL03pjxKtX/kPeaOoEcJFJkR+6ZnbAHHvnp1cOzVGrjCCgYg86e1CNTmP3ZtS8uLUynU+399UiC5sxElg+G0t0pS/uQeELFaOAoCvtSOGNnXbcPFhStbhkGTdaa0ci2ijtmdALrGVbG0Ex6HaiTW1K3ZvNIX6wo78rKlVDtMG12dn2YD8ydrSodyt++Uzva4Ym/b5JCPlOtkk6DfJRpI4v22+C4Hx/CK6tGQhtXpic/SXCPs3TNwKttwyWDuhXaVfhnSvnE50YemXoQGFCJrajINBU23CsmXnwaut1W0BzGNbUl/u2un8x1gL4pGSB1imGGcH0ZvmDf7IN/owhobtseAyZPFGklpRglN2Tt2w/snHpcbbn7/T9ldszf6eXVNemyfKP4Jo+f3zNnHQ+3ifUtC592JUpvG6jzD4VBUKov02Jg8HjNF+MmjBw+OW2iVo2fRwcGgd+Jlh+ftnLlShuhYqBAZR1yhyqW9FEwMqO/lHOGuOfHqnLcnt8TglgSmPRVvLKmsrCXK1B6/oHuX0vWBSO1kRhE98SfISLL3TWVHvoh4N5Wk2CMrE0MQR+z1UmiMBe6QkA8fLuymgLyQYmDUGZP3AAbomspdtk4QuLURcsOlCX1JeLmT8FlQNcgYUvvDjUsZV1/lqMfWm2Q2VG5VDRU/vZlaNI9n
 tkzJ/0+t
 saReWSYDQuJeUhvFJylYIl8iBDWXYNAUx7c+wyBxNkCfC38tAteW0IFt/GIpuY6/MIAcvErOCfg6rGDk8j0Mlgv+YYwJEE3DafVxVCd/xcAVvQ5OnT4xB05LTQNYt375/HSdR9yfROc8+EqWaHB0KIBLnIUR0P3oEObCQA4kGwmn2sKkkvlGAv3JT0djUMkVUWaGX/209LB9u0lMupxX0hjUCSvywwtEaOe9+LnPF9G5kRA7qyBk5oW4Xg6933KTM/U5OhBbjh7gUw1gc3ErbCAxwvCihAs0wqKTrdrML9Si/LFMzF0CWcG+5GMu6fDe/vKmhjjku3/e0BR5jrGwNU9vozLd/zIL6KYEIhDbJDc2rinhbuw4N6fmsdoGJXQIYRFvg/PgZ0GJYZ93tzpHScSmiYsUH8ooGLnL8jo0MVFrxUZyZiQ6nMaJyIb5lGruoJDhxXujM5x9bUshpt3gUjsv8og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jun 25, 2026 at 12:30 AM EDT, Zhen Ni wrote:
> Add a print_mode filter to page_owner that allows users to choose between
> printing stack traces, stack handles, or both, providing flexibility for
> different debugging and analysis scenarios.
>
> The filter provides three modes via page_owner:
> - Writing "mode=3Dstack" prints stack traces for each page (default)
> - Writing "mode=3Dhandle" prints only the handle number
> - Writing "mode=3Dstack_handle" prints both stack traces and handles
>
> The default stack mode maintains backward compatibility with existing
> usage, displaying complete stack traces for each page allocation.
>
> The handle mode dramatically reduces log size and improves performance by
> showing only the handle number instead of the full stack trace. Testing
> shows handle mode reduces output size by ~66% (84MB vs 244MB) and
> improves read performance by ~4.4x compared to full stack output. The
> mapping from handles to actual stack traces can be obtained via the
> show_stacks_handles interface.
>
> The stack_handle mode prints both stack traces and handles, making it
> easier to identify pages with the same allocation pattern by comparing
> handle numbers instead of comparing large stack traces.
>
> Example usage:
>   # Using the page_owner_filter tool (recommended)
>   ./page_owner_filter -m stack          # Print only stack traces (defaul=
t)
>   ./page_owner_filter -m handle         # Print only handles
>   ./page_owner_filter -m stack_handle   # Print both stack and handles
>
> Sample output (handle mode):
>   Page allocated via order 0, migratetype Unmovable, gfp_mask 0x1100ca,
>   pid 1, tgid 1 (systemd), ts 123456789 ns
>   PFN 0x1000 type Unmovable Block 1 type Unmovable
>   Flags 0x3fffe800000084(referenced|lru|active|private|node=3D0|zone=3D1)
>   handle: 17432583
>   ...
>
> This implementation uses per-file-descriptor filter state stored in
> file->private_data, allowing each opener to have independent filter
> configuration.
>
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> ---
> Changes in v11:
> - No changes
>
> Changes in v10:
> - No changes
>
> Changes in v9:
> - Add spinlock_t lock to struct page_owner_filter_state for concurrent ac=
cess protection
>
> Changes in v8:
> - Fix buffer overflow by adding bounds check between stack_depot_snprint(=
) and scnprintf()
> - Fix unsafe string handling: use memdup_user_nul() instead of kmalloc_ob=
js + strncpy_from_user()
> - Fix strsep() memory corruption by saving original pointer before strsep=
() call
> - Change format specifier from %d to %u for depot_stack_handle_t
>
> Changes in v7:
> - per-file-descriptor implementation
>
> Changes in v6:
> - Remove unnecessary braces in if/else statement (coding style)
> - Use stack array (char kbuf[33]) instead of kmalloc for input buffer
>
> Changes in v5:
> - No code changes
>
> Changes in v4:
> - Change from numeric (0/1) to string-based interface ("full_stack"/"stac=
k_handle")
> - Merge infrastructure patch into this patch
>
> Changes in v3:
> - No code changes
>
> Changes in v2:
> - Renamed from 'compact mode' to 'print_mode' for better clarity
> - Use enum values (0=3Dfull_stack, 1=3Dstack_handle) instead of boolean
> - Update debugfs filename from 'compact' to 'print_mode'
>
> v10: https://lore.kernel.org/linux-mm/20260618035750.3724613-2-zhen.ni@ea=
systack.cn/
> v9: https://lore.kernel.org/linux-mm/20260525081652.2210206-2-zhen.ni@eas=
ystack.cn/
> v8: https://lore.kernel.org/linux-mm/20260520075641.1931080-2-zhen.ni@eas=
ystack.cn/
> v7: https://lore.kernel.org/linux-mm/20260515091942.1535677-2-zhen.ni@eas=
ystack.cn/
> v6: https://lore.kernel.org/linux-mm/20260511033017.747781-2-zhen.ni@easy=
stack.cn/
> v5: https://lore.kernel.org/linux-mm/20260507064643.179187-2-zhen.ni@easy=
stack.cn/
> v4: https://lore.kernel.org/linux-mm/20260430163247.13628-2-zhen.ni@easys=
tack.cn/
> v3: https://lore.kernel.org/linux-mm/20260428071112.1420380-2-zhen.ni@eas=
ystack.cn/
>     https://lore.kernel.org/linux-mm/20260428071112.1420380-3-zhen.ni@eas=
ystack.cn/
> v2: https://lore.kernel.org/linux-mm/20260419155540.376847-2-zhen.ni@easy=
stack.cn/
>     https://lore.kernel.org/linux-mm/20260419155540.376847-3-zhen.ni@easy=
stack.cn/
> v1: https://lore.kernel.org/linux-mm/20260417154638.22370-2-zhen.ni@easys=
tack.cn/
>     https://lore.kernel.org/linux-mm/20260417154638.22370-3-zhen.ni@easys=
tack.cn/
> ---
>  mm/page_owner.c | 129 +++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 123 insertions(+), 6 deletions(-)
>

<snip>

> +static ssize_t page_owner_write(struct file *file,
> +				 const char __user *buf,
> +				 size_t count, loff_t *ppos)
> +{
> +	char *kbuf;
> +	char *orig;
> +	char *token;
> +	int ret;
> +	size_t max_input_len;

This can be const size_t max_input_len =3D 32 with the comment above it.

> +	struct page_owner_filter_state *state =3D file->private_data;
> +	enum page_owner_print_mode new_print_mode;
> +	unsigned long flags;
> +
> +	/*
> +	 * Maximum input length for filter commands:
> +	 * 32: print_mode command max length is 17 ("mode=3Dstack_handle").
> +	 */
> +	max_input_len =3D 32;
> +

Otherwise, LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


