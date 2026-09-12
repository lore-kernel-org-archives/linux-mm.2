Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4FD0C88E50
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 00:06:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8062B6B0092; Fri, 11 Sep 2026 20:06:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B6896B0093; Fri, 11 Sep 2026 20:06:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67E476B0095; Fri, 11 Sep 2026 20:06:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 39F326B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 20:06:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 47CA71C215A
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 00:06:27 +0000 (UTC)
X-FDA: 85203168414.30.CE29F1F
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011040.outbound.protection.outlook.com [40.93.194.40])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6EFE120004
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 00:06:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nl+7JrKO;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789171584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UAUHCHOnx5j+hbr/XNU1VgVSvEITj/JE72fDZmnOaEM=;
	b=10nk9bQXlyG4LJVfsM2Dq/9DKWRadLkpvRVw2knIsIg3yOjblW8f7iiEMnmr2CatkdGANr
	fsfa8CJLEjqVAlsUNrqJJod9bNmna/Bxk5i+1WlEbn0gOBLFs36nAdvGeZhKo0Yq8+tWhl
	RBoPBmCjjQDt7cZH4YSbiGqVv5wmyoM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789171584;
	b=2xU1B8SJ20hrrWdEnfE8Txzju5MuFWr+hwXxvYod87+XPAjOlmSUPHnfq32Wp/jegnBaBx
	lmlW3NgwqT23x3mvHVZd//Nz8VnzrUqZ4DAD4xrsKC+0hxGCc0RJ6zIw4lJDuBU8g+cyA4
	C5iRgLPbUIWpfTHbFSYEhllmfyqE9Zw=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nl+7JrKO;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kanr8iklBB6xxemk4hVAwj52iVPtVeBUEiNT4JSZ1TGhCDrN1lSiwLbxi/FwbwIVb9ofnIfnoVsrpRpgiQevC2rbH+2cEpYYnG9mDEqvILwVVUh7CY0cjkloQ5F49xKe3JATA+udMKNwcwxMft3tcJtKkBlC8jVTNFed7w3O+rjQpoLgNw1nL0YU6zWp7wvxabqsRjb6arSHd4if4NQM1s7WxwBe0rCsX0GSEbFwnpAKFRK9+tXEFx6tkVBiGzkY65sVoVYnUO9GOZzV2OzcH9BwQvuznb962DRERjSNyXxXTKay35D4ndfJf+U3lobsIMNXlOsFgIUObRIuPTJ58g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UAUHCHOnx5j+hbr/XNU1VgVSvEITj/JE72fDZmnOaEM=;
 b=ub1SoQlJ7Qdq1WKck00kKkZVBl8EuaZ1lqzHdGxENZtnGTvRM2TJp4DXOwbGw0/FcpXwuNk6Zzdgr/dUCQ7tBjScHdzND9DJZtXdJ9mq4GYMpRP7vhmp3TMcjyA9H4lwIzklT9FR/SJIz2F9ATtdAJkhD7JY9ddRMHG++AnvEIGrLoE4biYpx2qViXAPnyTHqkDKik5k9z9Jj+mUwH5MmozseJ22ku9FOISF9w5jbZeDROB848iK/N1po1mYZ4pu3+8LYW8HM/Repxg0W59ooRVkpGriYEM+0xUuh1SaNiNeqjtUWFAe2Xhhv/wAQi0QonBk3ifzsAamXkBTRxZpeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UAUHCHOnx5j+hbr/XNU1VgVSvEITj/JE72fDZmnOaEM=;
 b=nl+7JrKOZDqBl0ldHfqAxHKLPO8giaExyTUWWUqZvpTuBjkH9Sm4HLMM2ycpv8r+NYqwqyi7lf7mTWyLxyyWkdhbXyFlIMfmxLq8aMr3i29X2jVEGQHmO6EtQZQGX0yjTLnvusMU2KZN03W8nOzrBUDlTbDIlrEe7fS3vnuoX/c2aydLn9NkFdaLSuIwUtm5QDV5HwzB0grh2bs4u9kZeUPYWoZl25yQUz7xqSwglnQKbJjc4NAUt+i2j8XLVNeGyQJrUeib0P8E0Es2sWVxcb19ezwUMJoEfrbd8FQ+v27lggawKZtfvkHDF70FQIf2bIIZRY4xTGVKvEf+uj4VUw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DSVPR12MB999150.namprd12.prod.outlook.com (2603:10b6:8:388::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Sat, 12 Sep
 2026 00:06:19 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Sat, 12 Sep 2026
 00:06:19 +0000
From: Zi Yan <ziy@nvidia.com>
To: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: akpm@linux-foundation.org, shuah@kernel.org, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: skip khugepaged file tests if mkfs.xfs is
 unavailable
Date: Fri, 11 Sep 2026 20:06:22 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <CC87B3D6-D5BD-42D2-B84C-47745ACAD0AA@nvidia.com>
In-Reply-To: <20260911124517.63714-1-jaeyeon.lee.dev@gmail.com>
References: <20260911124517.63714-1-jaeyeon.lee.dev@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BLAPR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:208:32b::25) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DSVPR12MB999150:EE_
X-MS-Office365-Filtering-Correlation-Id: fef25f5c-51d3-4215-f82d-08df1061abd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|11063799006|56012099006|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	prQu7zIuuSNd0p4NgoGCvcnIPuIiZ7/lZkM9pk66ICQuLN4O1o8SNNgpgjzg2Vm31XJsUXkK6muIjEpbzhcNFVFdqsCo7N+wtsOT3qLsr1yTPYnLpj/dINXl3sfKTlXTzsa0yKjS0yJKhDaYw3YBwbF7/Ie5EBFSCzQDNZ8fSVjCbAsW/EMfzakEDhY44QmLaRbyUjMgbytIaNQ9AlSBHJNvpAtMfd/v4eNiGnRM8wwlB5OZsPdTmzhc7u6uz5eP2vtrtdxh3y2nQpPlOmXCgIxTStixkulWEVkYT3MdBTGYrNNZghCqTOSebtqGdx36JwtwlVVKxjvudOcOs84jZ2AZI8Wty0UqfXAADUC9kaNV3yx6TKii+5+LtOMgM71JC+TbyK9Fv86zFKMj4O0/rx0Amof5y1KBI4Yh8Ae/CYr9ymRi1wfZvMsqS+PgjovMxFCZ24qA3offDqQ8yx0msU2xsYL7L3UkT2LGNJroAcWU8UlCKzK15ni4Xf4oc9rERpdumcUmwibjK9KLDu3qev6mtdqA1s4LgCTT75gssISAkx9d8bgGd4THda1LoLPp7Z6kyKO90QP3Nur4vM1iWD93wUiQr9nzvDU59HtK5znr1SVzx43az/reWFAXdBjn+Uvyz70S11Um1OBW9nuVmKZswsTVgD9HQOdrWKv/KIE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(11063799006)(56012099006)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+diLE0SbYMXxhJuoP1GhrQG7aYTKRFo1AcMbj4ueSRZgLbThvoiSgGcm97k0?=
 =?us-ascii?Q?ziqjsVdCk8AYH7rEreoWZ31k3zCJP/pEMIWgiFxHTcto9Cw0I2EYloc59rDN?=
 =?us-ascii?Q?xEHR1yBEwfz+KqYnvE5AbLf5zYAuDxAjPnUifSgAWHxleb5S9khFKsv8u9m9?=
 =?us-ascii?Q?S/jwbSWJK16JYvGjGGEhqu64BwbzYq3IrCHv0pVOWbIYoW8pfUducUUY8G0Y?=
 =?us-ascii?Q?kmHvvEkW0Cx9uTtrnK4pQk65XV26pvUUpg4++6p+p5mT0lZ5/r5ST2UufcOL?=
 =?us-ascii?Q?uydlHxk1NivkfU+UnV9e/wAbvayacSLvC9trU8q1mMnyf0scuDqqizY2m2ME?=
 =?us-ascii?Q?lJWC+xsq8JNZcBC+wZSMzgNWLfmtgQ3XgGdeVSJrFdlIlFeVWfCZWn6u8U4X?=
 =?us-ascii?Q?lGoq+2kxjB9mqINLuVo5OxJZEOc7777SZriG3komNHlExhzAfuADtRYmoZHM?=
 =?us-ascii?Q?gjzwdEOMlovNZ8Pz24ecqXu6CBY4MtRyq0y1ipQJncBl7rBSuy4JGS+DPMo8?=
 =?us-ascii?Q?92uOvrZkG6Fg/sOoVbYGavSDvCW4mYsi47WooT//cnj0f12J5HEMTOTM/0ZC?=
 =?us-ascii?Q?IUejBkazQdPTzB3XgWaunP63jDk4CL5bNcxzBu4f+kduztOAUiv0CyIXT+oN?=
 =?us-ascii?Q?CyM6S8Y9iAPZpwCvygvuoLvrKJlmk4e9jFBsFLvJtNZQoZTCcxILEnMwEFXz?=
 =?us-ascii?Q?ONkvyJdJpghbsL5A7Tze76FOzKk+sAl2GD/aUMND9M71SHqX6Ip4NPhrZCXr?=
 =?us-ascii?Q?SE8Jx+t+HzzggXnK/BWc3af4as4qINhwOZISvVx7PWBAkC3TD97tEd7IYW1E?=
 =?us-ascii?Q?7K4CbzYLHxf5qkkF3MTEDbAkzndCDoJ0Nosx6xnMcD1Pr8toxr7houSLGln2?=
 =?us-ascii?Q?HQOzcLUS472+4W3jzfGM26Y728UxMNQlIT9Ztw0Pr7AvR1DCdHFWseIVVnGf?=
 =?us-ascii?Q?sBFv1fJvZClc/ba/TD1wS/OEKtr5L2gxOGqCI5ivWEbjtl9805FU8VhOhMil?=
 =?us-ascii?Q?StvG5JiFNVKdfNR/AyvJa6mIbY7ZHRf2Edo0EI0fX5/ur+VONSbcjy100uP/?=
 =?us-ascii?Q?xXe1TB91Bm4Hw2vRqmpmknnCGzytfNSoLAIA/U3cL9odV+e1FiHsJLnGP9FL?=
 =?us-ascii?Q?AGSLo9UDuJqx+UyDHnsII77ydevL0Mmdg0FKeJhX3btAPCmvAmdtW3U9WFvb?=
 =?us-ascii?Q?WEfx6UbTxhBldzTHEyOBXqXmjGHlFDdJ3LchSISiPWdysjKXMRAuBZSthA2r?=
 =?us-ascii?Q?T5sFuPUVMyuT/1F29ODUuV28measzGcPB7qhRb29CkOvZW04zKJzJCqRlCgd?=
 =?us-ascii?Q?84/opLBVMGafNtG/FwGzWhMDYkbals/GDM8YmTU+VupJ0okK/cRWlY6iwAib?=
 =?us-ascii?Q?vbYtsCMxv4l75dp5wS4q8srZlyb3AtyQpH9c8AEXciuOquYs+tblyPxmX0Gz?=
 =?us-ascii?Q?dAMkRmpBFywD+SldIsm79/XrafrPxNb3FZMAwgPKM60pKHcjjDNlrLq9JPbG?=
 =?us-ascii?Q?xZWbKFQYEX4Rld3N17wIl+WBmqcN69Xuw8HnlheA1oCs+EyVbww3AbIu/Iv0?=
 =?us-ascii?Q?rVhCaQuclbUKJiiW/YKzc9z1FOmuDj7U2RXkeIDfoqNBQO/+CoePoTCsbhkK?=
 =?us-ascii?Q?YEuNt091pd39S4+EB6UHr8agARCQVCFWCHuipVzotwNI9JakSCWOJJhESsp+?=
 =?us-ascii?Q?JX3nzImmeDZrX1TTN31aqhWZ+E+tW9SJzFezU4YMMsTXalXug311gDX3lczb?=
 =?us-ascii?Q?gjQjR9LvAg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fef25f5c-51d3-4215-f82d-08df1061abd0
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2026 00:06:19.1565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JjCsl2mT9/hk7flZrVT4P1G4LMJvlaSgsWi8HLg3BPbmK1/iZWwnm6TyoCSYHY+y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR12MB999150
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6EFE120004
X-Stat-Signature: 6c87oc73wgfeyhdgo9c87kcn53jgmx58
X-HE-Tag: 1789171584-409512
X-HE-Meta: U2FsdGVkX187hZz5/ZBr09+emzzoZx2EVtpLD2iZLkROHR0uQok5y7REM4Xkk/v4O9nrpDEn8l+rdwoJT3qTe+RUcjnoH6v8SQIeiWRFkqJErVAsvNMtR0beZKa04QURI6sJ2Drxlfn8s2e4DiSHymOJBYcXxhJ5hrCbpcNnWMgp5cKetq/GL23B6Gv0jrkXZk6ddWKhvUF+9DaAdAGrlFBQm3f2av0N1TU12hkr1ksVwavrN4yPmUI0H+lfqcZF55ZACaE0rFv6elBHIuiMG8UjXw5g1la8AbZyfZmVAGGCMVRiNT/zzmVcv9bxU+nbX/zeqym/I/OTKrmH/pl5iG9sFCmZRkqJHCOZfH9ZEI3k299WPN4xQACKH36CHyWnAUDiVm8GmfoZ/nAG5pHsWkAaKQO+UFy6P4CcoTvqHvj7+S6F2kEJiVeUwd/cqsY7KsN6rnqO6/X9944ORf8CR26TzYuUD/8tuE0i8Fy93idTPfVIWvjNjlPxNxaRdEYjwXATj3s5kGIPK2Bi17ADF8zEXX27xG17T5JYMzxcBfed1Egh6OnI6a/lXZe3HB60Lmv0Adf8vW5SPOpXK3SDk3QIVY6/pBUupHSFr/8gJCzBew/KOlb9hg/C37sQD18dMGlIOVn+yu38UrvzepMpJjr2s0AGUFIzQzyQmmcjTjONteudBUVh660G1ULWiNoZFtGJIS3VYj9zhFhk7OPaDdoBDREgB1tXVb+1zU+f61ETq36LR5L0ljhfZtXW8TXxxXlpRZ2GOj3loseBfr6gbQSPU9NSmmQacHSx3IPkPJNfhtSJiD7OKceKDKFAUBddqMV947fOZ1VoNUA/zkQCoC5FK9iRN8ZwGdnKWmfUIFjH8jqlOrj0tC7auSLCFZZZc1KYrRjTHWU9ECZB9zsPygHvhcS2IdnnKh+rS1/GltKAOCrEh6gB/vsFAy3UfCEhTpRmIIJGfCwPKbpWkCE
 WlbKoKx+
 cFijXL7+bYZl/qjFmqRXOox7adwg0jhknrNl9yt3wHaktjf8S16DgTYb7gv3rMaWujIOCJWcKhNG07WMOtgtM/UugdIqb5XERMMKRlsUkxX9n+5l0IPLCzfPd91wPpUzyyCtkYbkDCO2DrjoB5uwc+2rPdnHpOpiEFPiBtxeCe/nERotU9aq1vpfnGq93QVmUrIem7HOCL6FyrcNIeWDDlm/aKzkn8oNQmaZZ/sTqJ2aKF4o2L60x2O3WGESFkpJNg6oNRlR3KcDr17FdJ/IKbzZnsjWEZPlVyrbJRFq2PRUuGSNCXtNtppLdaRkEU8J0E8R90MnU5AynnVdhGulpu/8LXozET6yHrzmldcxb72k3slF0etvZBmhoVZmERflJJNfoxsIz6guv8MbvVRXt3ORVvmo9Nx+YNwpWBxr27VJmalTUZGmo/3fPZwsDoSSne/JMBhSTT/hhrOXy5doqS+WXKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Sep 2026, at 8:45, Jaeyeon Lee wrote:

> The XFS setup for ./khugepaged all:file checks that the kernel supports=

> XFS but not that mkfs.xfs is installed. When CONFIG_XFS_FS=3Dy and
> xfsprogs is missing, mkfs.xfs and mount both fail, but
> SPLIT_HUGE_PAGE_TEST_XFS_PATH is assigned from mktemp -d and stays set.=

> The test then runs against plain tmpfs and six subtests fail.
>
> The script already has a skip path for this test, but it never runs
> because the path variable is always set. Check that mkfs.xfs exists
> before attempting the XFS setup.
>
> Assisted-by: claude.ai:claude-opus-5
> Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
> ---
>  tools/testing/selftests/mm/run_vmtests.sh | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/=
selftests/mm/run_vmtests.sh
> index d09f9f6a384e..6315b67b6733 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -415,7 +415,8 @@ CATEGORY=3D"thp" run_test ./khugepaged -c 4 mthp_kh=
ugepaged:anon
>  # Try to create XFS if not provided
>  if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
>      if test_selected "thp"; then
> -	if grep xfs /proc/filesystems &>/dev/null; then
> +	if grep xfs /proc/filesystems &>/dev/null &&
> +	   command -v mkfs.xfs &>/dev/null; then
>  	    XFS_IMG=3D$(mktemp /tmp/xfs_img_XXXXXX)
>  	    SPLIT_HUGE_PAGE_TEST_XFS_PATH=3D$(mktemp -d /tmp/xfs_dir_XXXXXX)
>  	    truncate -s 314572800 ${XFS_IMG}
>

This might be more robust, since it can detect mkfs.xfs and mount failure=
s.

  if grep xfs /proc/filesystems &>/dev/null; then
      XFS_IMG=3D$(mktemp /tmp/xfs_img_XXXXXX)
      XFS_DIR=3D$(mktemp -d /tmp/xfs_dir_XXXXXX)
      truncate -s 314572800 ${XFS_IMG}
      if mkfs.xfs -q ${XFS_IMG} && mount -t xfs -o loop ${XFS_IMG} ${XFS_=
DIR}; then
          SPLIT_HUGE_PAGE_TEST_XFS_PATH=3D${XFS_DIR}
          MOUNTED_XFS=3D1
      else
          rmdir ${XFS_DIR}
          rm -f ${XFS_IMG}
      fi
  fi



Best Regards,
Yan, Zi

