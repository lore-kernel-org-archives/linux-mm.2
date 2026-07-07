Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE9B9C43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 02:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0EB06B009D; Mon,  6 Jul 2026 22:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE65A6B009E; Mon,  6 Jul 2026 22:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB0AF6B009F; Mon,  6 Jul 2026 22:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 72B266B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 22:28:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB94DA0235
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:28:33 +0000 (UTC)
X-FDA: 84960396906.15.B41609F
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012024.outbound.protection.outlook.com [40.107.209.24])
	by imf15.hostedemail.com (Postfix) with ESMTP id 26DD1A0003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:28:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=smn1IEtq;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of apopple@nvidia.com designates 40.107.209.24 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783391311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+0hx2vAEkxb+N40MUPog4OfdtJ3OqGYgqMA8QY7jAjM=;
	b=SYY2Yq4oZr+PB9Tm8SkqtnarQtIR+2e8rozkjn8o4lznG/iam17nlN4HcU08/kA1rubE9u
	wVJ/qovV/763zaUnoRn3qmGHo5VvRa2WX4SCCOyfnjtpEHy1mSBFhYw9GBVmw7bMNkARdB
	DCWmjvyhO4VoGIJ3PsLFCviY+SGgHV4=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=smn1IEtq;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of apopple@nvidia.com designates 40.107.209.24 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783391311;
	b=FrpD5Sd7Jxxv2siB2aPFGUHkZ+F39g/Mv20hGV1wcJjPPM0hQNpiXPkbsVnh9MFg7STztb
	J2KSDzJkmhMXqQNWygE5sKhcalSb1D3hwjiW+YGWOpw8ESl3/SiYWpZjafllp4w/pd9Wiz
	zEs+ohTDG4uwdyse08Ge6MLddUvm/Tk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hs7wWaHDIxIOuuC9UWCVpyQP/kOffLqx9CRiI55hvJ+fJOE8yx4bMxeCb3Y5bA3zzNLwMnwKJZIlWZHsx26wBQxj3FPbZ9KUT/5K8jdSh3uex4SD4utr5yvmS5twWtKmeU9AwOWzRqSP3M10KFbS5QgyhO2Z01AUcJ/3FS6VPV901bS8R8H5nnqZUhENnSZwoOer1quEdRc9BZL15s8UGB4sbOt0fqU+qq+XVfq63B5ugoTswfLjcdoQL+22bsughJrehZ2Pr0y2W7rRefZBjO3x52uLAoGtcbg0mrqYXujkiIeBSZeoLRDNxNAKR+zDHV+TB5LquPG6QkL8QX9EZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+0hx2vAEkxb+N40MUPog4OfdtJ3OqGYgqMA8QY7jAjM=;
 b=Ow+sD2nrCgh9MO+fq046QtQlwJiD1RQTg8lVMLkxlfxz1kisTDm+s0lc9fRkr5+8hqLar4IafNLyrg5TVCm8hNtvRs1OAls8JzTDPXKdODrn4QK0Jt71wz9NXzeMdEUhTcROtKpgdF5mg0Bs1q52H6+3rY5t0tFwwWrZNySeqBlTp4of5Jkbios6ApaptRhenR1ib3BXoYqx+MWTnhm59RJycm6kOr6uS3hBA8lEdQgilKi6K6r5zhC/3pIa5ksEsT/EDhDxZZN4YmFvP8uqoUQ0ZyC55l0B1VeXjWpUoBzWKA8HdWkW/svQQnD1vCOLrbM/P63TwmqNtmoJXZRSOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+0hx2vAEkxb+N40MUPog4OfdtJ3OqGYgqMA8QY7jAjM=;
 b=smn1IEtq1WS6V09lUVWlks+FyaKBiGsFjkoYFKIrpjl2oS/CDNomS4tOyjqXglTxxZvIgEGd0hAWKVRF4FnlnOtzGAQuancaGQdeH4NjTPJ7jRaar2KW4tJBv5TH7U/1J7DSxZzEgMaRq9qWuDtEIcNk6EfCzwDOinQP6TqQIJ99MjKeooq0yM55C/TroLom0uf3Szfv3R8LDdqU+zsqcLBIdiuO8TRV9ZukbI0ckNZzkc4hoca+lUpBrDAyB4La9dQPsEbLW6NZIfhUAq/jh2EKQ4bHxcrXOAuSpPgfI+vYPu0RCWOXcfXc+C9wacAhJKGtacr723wAIWKR8KnRGw==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 PH7PR12MB6562.namprd12.prod.outlook.com (2603:10b6:510:212::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Tue, 7 Jul
 2026 02:28:26 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.21.0181.008; Tue, 7 Jul 2026
 02:28:26 +0000
Date: Tue, 7 Jul 2026 12:28:20 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, arnd@arndb.de, bp@alien8.de, 
	dave.hansen@linux.intel.com, david@kernel.org, kees@kernel.org, mingo@redhat.com, 
	rppt@kernel.org, tglx@kernel.org, linux-arch@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH v5 1/8] mm: fix stale ZONE_DEVICE refcount comment
Message-ID: <akxkB7_lG-cPdzNA@nvdebian.thelocal>
References: <20260701090553.62691-1-lizhe.67@bytedance.com>
 <20260701090553.62691-2-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701090553.62691-2-lizhe.67@bytedance.com>
X-ClientProxiedBy: SY6PR01CA0162.ausprd01.prod.outlook.com
 (2603:10c6:10:1ba::20) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|PH7PR12MB6562:EE_
X-MS-Office365-Filtering-Correlation-Id: de79c827-797d-4be3-c814-08dedbcf6d05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|23010399003|376014|366016|4143699003|18002099003|56012099006|11063799006|22082099003;
X-Microsoft-Antispam-Message-Info:
	7IxiJdWemmeZWwMFwTPFhkKdsK9SVThdycHy2FIuAtbkZ9p5Tlt6/xIv6UTUIw/El1QOzyWNa1egoDJpm5LtYipOtmi95riEqLwFPV7TTMx7EImLEGeHRTCsv8Qhixult344irBcD1LVSjsiI0PdvCJq94qz7C41oEpVC1KDj6W3eNlvtImNmh8uz5pXcMusOdAf1EK70iMpS0e/JEzS8SssQqHkbMy47bHF8KFSwp2KgJtqr85Dcre8eO+0632+gymlvxk7KZTjHkdRPMWUejNTbvL351tbRflrFbzItrN1X556g4XU8IkN07DKj33qmWBkWFzzbDw8tSeCS/ec8/t+p54eQlmi6alSSoqzlWPyDob6PDSRW/kjtJaGCffC9Ke9ChdAwnvqFbfx7pp0Suo58FfK71wxl1vriu3z48w70x8rXPOIzQ2RdgPGBnmVc1bJwoTSwv0HJJN7qkGB43IFfoXZGeX82olTXLk9BnPEMDcxd56naZ17HWToNnEF+MfyRgX5XKFkV0aJqmytwmL43iTL8qbMn7ueTS0CevDopFvnGMYiU5mFHbIELo3e8+b83MX1QS0+YKLH6VM6IsDCWche5cpOSqLXC32S3No5mFJVpBjc6RvCVGnEXizn8SoXsW4i7NKzz5LGPxZ0bO594mCSsBVNTWbIZ3pl8l8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(23010399003)(376014)(366016)(4143699003)(18002099003)(56012099006)(11063799006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XL70I+Pb4wsPT87ywHYOA1zFowSo3MlrxEhMPTUDY7IIKClT3Kq0sQh5Fg5e?=
 =?us-ascii?Q?Hk0Zl/oAK8wXWJ4Eaz5G8L9siIjdVzXL3JGC3DTjkXTu6HgsZJR40KSNLwDQ?=
 =?us-ascii?Q?xPTk2fuiEjkRPGLBDMDV/Xz6vR2khBTFNyicssyesJdAm86bZEoEg6ynxnv2?=
 =?us-ascii?Q?QLXJvTK9R9RC0Q8+FQ0q4kIe6F4GjAXY1UDJrgjQ4qCq/CFxPt7lMdHs8Xky?=
 =?us-ascii?Q?P9W1n25tBbDUGB6G41GDNYqUSHdvGFlB+BwJBhwB8wk+iyCQ13gBssTVtyOV?=
 =?us-ascii?Q?XWyUBuyYaVgV+qPnOSGLktL82uwiE2CCpAyNxklxz9OG9du/GnOPcmtxQA4p?=
 =?us-ascii?Q?Jg8KFOFZH2uCJ4MQgHkK0oaxPtOwq8/SGETNPgHloz5UTDTzEkqxDkYcM78v?=
 =?us-ascii?Q?T2dWpL5E3wZVL/Kl4EfvQHaDHtfEaE9CRSmzEX0BWhGc6//XfKJxuA57LsZ5?=
 =?us-ascii?Q?Gf60bDb/1JYiWZ/vrKBP3XtsHViZnneY+7RpDptFXCWjpg1tihZSMMiydNAA?=
 =?us-ascii?Q?0oCBCIkJuEsQrZRq5+TckLpPxLohWHrSQvtqD0d9cV4r2FewgLITYy4YleP6?=
 =?us-ascii?Q?IeJOoyxUZB/FJaMYtMTlbCegzcVom9oAk7/kfU9SB1A8UiTTTsdEEKF8GKJh?=
 =?us-ascii?Q?KTb+F2fHnTlImh2QILFcFOEslyRJ+5pRnCLjy55TiYtLhbITCZ85qY5yWLyY?=
 =?us-ascii?Q?vgCpioCNFowXJ0XXCJ8A1v9/dQ/UEqQWrpJiUqewxnPvG/4F7hxfZBeXvQ+n?=
 =?us-ascii?Q?2OiZqE9fzPD6ade3OwKl5QUVSYAAy4tMoaZYq7qi8bxw2tbIWybNCU80ALnc?=
 =?us-ascii?Q?ozJW5Ei+Cne2vYVY1KtPkusL7jzlvLX9iRATf68WgjHbowqHAhJu8B97Q7Qo?=
 =?us-ascii?Q?FCjm0Juy9YCQoUWDH3+6F2nzsKZ1lFrKYMBEu+JkDfIC8VtYPo1MtgIwOP/c?=
 =?us-ascii?Q?EoC3cQDQs9SnhUeOYp2+Y8NYAyCPNl/hbrZskumup6wYTunfqBLxCeRldinW?=
 =?us-ascii?Q?+sQXu1H/5A0YDp7kRMXBMaWGtpj6ncQS4H3oM3wzexpvGyb+cBfX9gr8go4H?=
 =?us-ascii?Q?mL4po8zLIfOFV0NAEl7Nc/xTFb8JzfvY9CxkydxuvmpeThfyyZOTqWJlGfis?=
 =?us-ascii?Q?dYLjnV2BYAo3697+3OWbvHC8twerxTI05cZFAgeKfbRImT0RuXTgzWKDBpoe?=
 =?us-ascii?Q?ZVuvJ+61ZHXIiUbM+3Q5UHf+vLvvOH3MM/Bw+2Ns4zSUZUnYyZJZtQvNAAJc?=
 =?us-ascii?Q?31G+YIC5iL4FOM1McYwK6vmHOo7wm6xtKtUigBTAdXLkt6c4l5XXcx08WzfS?=
 =?us-ascii?Q?2A7YO306NjhTcdcKnaY8CtbyUbXdHvKB4tEQtx3ITGW4MNEn+dGVNYihU/Sm?=
 =?us-ascii?Q?CJqmngFT4ce08Z5jJ1kp5sf4zkIXE0tvus9tEjwNBj/j6kDmyvHl5bin7eEn?=
 =?us-ascii?Q?RjbpD2OI4KYYrwUE5QsLXP2ujOVHOf3wKPyBGSK28mxn6Ld+7S9Fg4MydPPk?=
 =?us-ascii?Q?UVF5zVmFxboDVnXIFaeVYpLGGxO6zchS+TMz6fB+LeRM1T3729MX5OizMtaB?=
 =?us-ascii?Q?nrrXzlH8o3WuHpOLRwSlshi6icLCGbaFFSdHJdrD59fU1IES8ciBM2jzHwXa?=
 =?us-ascii?Q?7BSu39q3434s3M+dSywvhoo/BMoTOObepf+DyaqtexT0KSX4pklM9oG5c7fg?=
 =?us-ascii?Q?l9lOH3UHCUMboMyv6ESPasOed0enGJ1hnw0NuRniS5p9oMdhB9lKrn6LnTPa?=
 =?us-ascii?Q?4CNSZ/z9AA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de79c827-797d-4be3-c814-08dedbcf6d05
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 02:28:26.8468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MntOzAphthj45sC8qzsnR/TDIKpWq0/NoVhsOzeRDAKDahrSlgLY2UgYPplv4sLHLDwOhesJIX+Y0uietIcC3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6562
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 26DD1A0003
X-Stat-Signature: kzmijthhpi36q4ubwh6iokwd5qbwhmtq
X-HE-Tag: 1783391311-871048
X-HE-Meta: U2FsdGVkX1+1Kj4LZ/Pc/126us6z+R7kgAHYal4pAXppENvhB6acxIySJ6BHs6W1qt+cxPeo6mpRX3Fwj1pHDwuZGSlLnjdZn/Ml7ttMClAVsrc3KpVycxy1R2oQsBahHrNh+Hdmw353mP17IRsENDXC15LzAeesnhznzMlVuObTRY9hua7MDPUfVDPJLRgI/XJ8O2GrJVn5TkD5tvBQ/1B21c9i/H8mcViaQXrpZoo1lNRplSVmcJ080dUSvRvKdETKXM/POrNXpS4/KNyslm2/GKiYjD1ycKaB2htRuu05QFdq4w7Jm4OsX1MNy7/BlF7PZ2iUTzilrkbSE5tIv7a9Zo3udx56GFRL0hjGKJ1S1ouTv0aIGm3+Vww7RVD9DxqECnihqr36rTzHsYA3gDkqmqBeJwxQWL5+GEPmBx39osvCVl+hteO7+OEUOIZh4jFbCo6Fetn9jLSUyWNO5s/TLXWCHrepPvrDsEZNj+EwbF6fN9ALEZLz3b0uTdhafcEOntycwWl82tlJYd06fHNia1G77bnwoUnZqdE9b95dfxc7Q1/gX13ZT3jBM/fN8LvRXUjMFnLxUByNQJCxGLsKEC7svWq2uAXcmn0wCBUgMCMNtKR5mt3/i8pPoAndRPIlCBGoaoL6/nCnJZM1ZmdEovmdZ9un2ruD490shygcIOeeOVDS7sUGcHcZgY1pdAzZj8ard4DZVkTteT+P942tJIUYK5YnMtSf4TXce72pAyGk18/QgLnx9CjG9Z9W3rwyl1Fi05pwFKVUBcJg40CidhHwOMkeQZaixQJaMk6n/1RJ7FmzJTnHCVYd7L9Gf/fn1nlRcAElH0qkV9vqfCdnnkNGKBVxUC6ivItTitVNxapmzgBuZXE2psyFyF1YMhayvwg97yibkDyL+kKK880RizTDwfo1PgSXP34zARUITkAjBLz/ibu240GsR/jqv5YFNflZ4H3AiaNGel+
 xw3gyh5k
 BAZsiE1GYMTZAFPvuIRHx6uJjl18aGPUGWpP4lib0mpd96dL34fCoKwngRypayodtge8n1zkO9mlJjGACyDQf1shc4ch7sQVK+tIr0JMuXrtEcGjZUhGNnDNzEIA2VBWT/9+dvLLsS0WoaB6BWbsIZ2kfMzGwUD2ihOLMes7oBwA1BuxHZcGlTms7yxX0SbyqQ7hwjuE9rWAJyOMuBq8JHdY3dqervPNE3ZRcw7tQPvWn8exkHtVHlIgLPrK7BdzBfvsEBhfHitEl9M0yo8Axe9kYBrqigP8fSUoz9gbBvIIGFtBxZ+divSMXLzJNounKS+K9VNpdXpni3tzmCr0Rm7Eb8M5WKxIwkuG0/WFEHndAVAOA3dJtXZUmBViGX+G7hxC7AaQ7nCzTQ74SouvsqPlTQUO+a5TbyPU/Ypsm7YTi/sr0OKOTAGtzqwDkdCYBwqnNkE5Rroel+x56Mj9XSTFfzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-01 at 19:05 +1000, Li Zhe <lizhe.67@bytedance.com> wrote...
> The comment in __init_zone_device_page() still uses the old
> MEMORY_TYPE_* names and implies that FS_DAX pages regain a
> refcount of 1 in the free path. That no longer matches the code.
> 
> Update the comment to describe the current policy correctly:
> MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free path,
> while the remaining ZONE_DEVICE types start from 0 here and raise the
> count again when the allocator or driver hands the page out.
> 
> No functional change intended.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>

Accidentally just sent my response on v4, but this looks correct to me:

Reviewed-by: Alistair Popple <apopple@nvidia.com>

> ---
>  mm/mm_init.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 0f64909e8d20..95808ab5cfdb 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1030,13 +1030,9 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>  	page->zone_device_data = NULL;
>  
>  	/*
> -	 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
> -	 * directly to the driver page allocator which will set the page count
> -	 * to 1 when allocating the page.
> -	 *
> -	 * MEMORY_TYPE_GENERIC and MEMORY_TYPE_FS_DAX pages automatically have
> -	 * their refcount reset to one whenever they are freed (ie. after
> -	 * their refcount drops to 0).
> +	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
> +	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
> +	 * the count again when the allocator or driver hands the page out.
>  	 */
>  	switch (pgmap->type) {
>  	case MEMORY_DEVICE_FS_DAX:
> -- 
> 2.20.1

