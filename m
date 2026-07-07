Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1418C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 03:09:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94E2C6B009E; Mon,  6 Jul 2026 23:09:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D7506B00A0; Mon,  6 Jul 2026 23:09:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77A6C6B00A1; Mon,  6 Jul 2026 23:09:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 388BA6B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 23:09:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7FEEA1C7B2F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:09:16 +0000 (UTC)
X-FDA: 84960499512.18.5FDB75C
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012001.outbound.protection.outlook.com [52.101.43.1])
	by imf04.hostedemail.com (Postfix) with ESMTP id C200340006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:09:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Fw4f9/Ey";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of apopple@nvidia.com designates 52.101.43.1 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783393753;
	b=vxOZDYt60aeCQrFbOx77dtA0jCAZ7UFB5KrDz6+oCcdDAgnOzKumYBEWT5FZiaAe+L1E5v
	cb4hxuBD8IrrwxU7ztD7qE6eRu9nwp0YkB6xc5mffIRQ0sEqxt6MapFwq22CjJHuGj0SlX
	awsxGRqlt+37dLLsj5DwDSrsaWVEaZ0=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Fw4f9/Ey";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of apopple@nvidia.com designates 52.101.43.1 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783393753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4t4UnRbPev6V92mwdFayNZ4B22D5taI2KmwMwZ7NZS0=;
	b=6kBwRj0P+vd21i0l+0smsHNA+ouqQX0iruASnku9ou4W+LF/xMhkXjx60zl1BctGb7h1xr
	w7xC4JlXmnIYS/wYoUon+vxbJZ9TWaKfPwmYvp+fGzj1I2yAHz+6vwtuoC4zT8C3tsbcS7
	04+MPV1sJJ6GlR88t+gpkHa7c9vlHfs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o3z1wTks6XKI6iS8jI2lL/9ETVE4OF33IxeAqqriKoeghTLsyDomJ4AhVE4Ktkte1fV+0KdILokheto1Thxba3QiFU5tbJJvDRBUd4SZkF3DhevTW0NFfiY47rHATaxGvzpomGnWw0+N55GIsL7lJ296uNT+IlQw1WuKs9i6/fsmh5FTHJdncntdPS1OW5GJPSyV9o4Sf0O3Frt1onTdNWhg31WEn00v8NuKbiNcUE+efQ3ACwS9VYtTPJHJN5UsK6BiyuPkqzs6xo6J+t2Q44EcJebLYYBPdCuO8tgdGwTW/5sn6w/j19R1z9BiGZwGDH2beL77eXs4orWCLA8ddw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4t4UnRbPev6V92mwdFayNZ4B22D5taI2KmwMwZ7NZS0=;
 b=FUIvPsjPH9CZZqP8XW8rcuwm2D0DhNjur82Me9XVNh8cnnN8MTomDvhbwOCfoWfPYic28RSf2gRj9kwSCCLufLYmF/7ITfZI1v2iuG9LFVJ9Pyv2ZyHdcOvP9AiF4MRY3m1BQ4WxQJMfcdCGo1/CFo9oy93YPL/8G0qtkbvHTf2iyhlRUTrQ5PLhQxKosFXqYDdYKxOrBFiA/FcZLtScFmRXw6rLbrVdt8gwQ1td7WYb9jInipGb8wC63LfkYtvqZU3aAfjBvoC+J85COiWL9VY/gIw/ToIEKKIXw878g+RCND/DTKLBzNF87hC1PRo2ujILSWfXnGzkHFoI/cVJxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4t4UnRbPev6V92mwdFayNZ4B22D5taI2KmwMwZ7NZS0=;
 b=Fw4f9/Ey8RksEYbmXb3VhniumSneZtiaYtHtVnY3BYVEUfVMBqeJk0freqirYFGSTxhYnuWjuwU+eBOstb+2T+ltfbiVwPHUGGPuAMzJBisZ3KmVQsVPo2ESMjmlPAeA3zK137bVdQMac4jlqiQBvPClz5mHpEU2gO5Up4VG/dzuuDquHa4SpcRgfgwu6wz/bVZL9pryRFHwJzjSws32IGTIYG7VGXLpbYP6tkVhcQQXHXmG0mqQMg8quzVluh5td/cpdGj7jT7m7Or6hrMqdripLoljexhfCfbsfHHJKijudWkzM4MR3dDSJe3D61DSRazMxaTZjT8mug45j8jA+A==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 PH0PR12MB7096.namprd12.prod.outlook.com (2603:10b6:510:21d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 7 Jul 2026
 03:09:09 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.21.0181.008; Tue, 7 Jul 2026
 03:09:08 +0000
Date: Tue, 7 Jul 2026 13:09:01 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, arnd@arndb.de, bp@alien8.de, 
	dave.hansen@linux.intel.com, david@kernel.org, kees@kernel.org, mingo@redhat.com, 
	rppt@kernel.org, tglx@kernel.org, linux-arch@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH v5 5/8] mm: extend the template fast path to zone-device
 compound tails
Message-ID: <akxtWBdz5XjoAAzF@nvdebian.thelocal>
References: <20260701090553.62691-1-lizhe.67@bytedance.com>
 <20260701090553.62691-6-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701090553.62691-6-lizhe.67@bytedance.com>
X-ClientProxiedBy: SY5P282CA0194.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:249::20) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|PH0PR12MB7096:EE_
X-MS-Office365-Filtering-Correlation-Id: c60e1696-4766-45df-bdb6-08dedbd51c5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|3023799007|56012099006|4143699003|11063799006|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	8mamLpxnK1HXxzhyv8fi6dtHeeUQLEzc621PTu6eSi5o4k8cBc1fGnr3q4OHYi/xXikFaYGZBCygBNKwAJAZ6i+pHZUisSj7UgJI2IGEhuLQVaV3Sgtlffey8PPsbELpv1R8DsD+M5VWJp2UE7O+PVfeL8IL3ueI2ucQ3ZnxalbrB08OjXpVip2bY9A+4XrDMxanJxjqU5sdpPSjx04BX9SIBi7kPjBkqUegKnxeDQmWhwbXc1xKIPR0O5DFMzstNfnY3kkEvlQMaNwd7QSKubmTPtF/h4FE6WEB+y+7ZFRrl+0seOD/fh3pJTaaSHM3gtcHQS7GfXSmrD30Hns57Cw3aL0O/n4vHFAS2kvGplu506b5Z2BPtgt7sBs3A6vLqLLRFR2E43w2BwQYwCb2do13W/c3FXUJ/GzOaeYBm4sabE8t8taVZ5ifTjrSWvcIZRdaooePmk+lMXBcJG4hf462816iY+PEm7I4n7W6ZzibXzQ+LPLpQgRpPpwslhkyG8ghaWV1p7DnmfVS63f1nOdzo3hY41PX7ca2xojFAalItTCZKvd7N3wYKXeBYInGPWIRfCcTugPTCstRpPYTdNDBDq4uqXVzPWwuGcfdklxq34AF2Mg5meAzVE3Q5wg+7X2RAAsjl/7tHtHuYl4ksJiraAC8magOy4dqXNk1izw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(3023799007)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KCmLvX1thLguPpcm3YHT0Z0cVt9ljj6KAi/dC3vGcSNv+mb7y4LrrsvDUQa5?=
 =?us-ascii?Q?6xTGPsWXF1EJ0ZsZpPmUc/XKw6BRLPyqbO/KXMf5Z5zVLKQ9OUeYoFF850w+?=
 =?us-ascii?Q?aqwD4z65YiAJrf0zKfnb0xdubhr1eVboKgYL1kxMue5UXHQY3yezN5ACyzMJ?=
 =?us-ascii?Q?KhTNpknhcK1DXoRY/pIVEobpVJ1YdLdHfauBB/EnIS8X5E0O1M5AyAZA6W8S?=
 =?us-ascii?Q?Gkbx8G3oav8fvDb0HaMmIQvzAm34s/5O8MkhCWSwYt1mDsD45TV93au2B3nd?=
 =?us-ascii?Q?g/TxbWbpfPw5Im/Ld9NV0VFMZYRuenFY9qvdVYCPPFXl30LPhij4px8wNiqD?=
 =?us-ascii?Q?w42+ouaReUKmEzaXbL0niIP2R+jCSlRB3kUQiGgmamkkPxjUlyCsrZnX5vTK?=
 =?us-ascii?Q?aqFPHCQQfFLNq+CszjTnNmmkqlDVUSVO1NUa3JxsAvvgSct/WwNe15jTlKvG?=
 =?us-ascii?Q?qPse/N+E4J0myTpaQBbn0Op8dU/ocDjSRFKEXneO+9cDOAwQ81rdnDfKDf0V?=
 =?us-ascii?Q?SdHGSPjvamBVbvJ3xZIK8iv0z5EuRZ4k1IYV1EJuU+ETPSLJLFtaO2tYvDrN?=
 =?us-ascii?Q?LjVN2gMYQnhnMOy8sMraMv6X4Z5HBCkmYWSRLWy5ORgOgrboH7u7slY2Kz0s?=
 =?us-ascii?Q?XwV7l8j4HMGQyCs+qp6FpKdaLBsU0WAq0AYA1j9O9cFvGycTUH+XtCPEfk/D?=
 =?us-ascii?Q?Ld9enomvtwJ/R/RrSuACqRm5mdiAR9IDOXF40fuQ3rKRnNObeb/dhIWOLwQk?=
 =?us-ascii?Q?NuR7psihKhJlmo9Me43jCiXAfWNwSTlNajP83PcdoOaAsT1XyPQoDCYrIhaw?=
 =?us-ascii?Q?sVippkDmGDFhyynKMLhH5BhYelOfPcAro8yK9BAt3zt5BfzMOfqHpQAgxjEV?=
 =?us-ascii?Q?IrrMXDgYBFPzHPXUfRVd3OYDS/A5h3Xm1ihhuwGnwd+Past6cF95TmrOsLq6?=
 =?us-ascii?Q?i3FnnY+SM4dyWcq0GxBhOKf48MTj8zQvM56C2IOFVsEiZLunXZcqiDHKs/NE?=
 =?us-ascii?Q?6oVh/+pvvY1iH84DLCaeRE6l4RCjZPd7p+ZW42c9x3UbJTvEjEWHUNAfuJL0?=
 =?us-ascii?Q?r8R74hXx8HNmYLwNx7oNbi+aQ+Q+E+sEWsmZeFTPzEsOD+iPnHOhH2uvN0ez?=
 =?us-ascii?Q?fomt9qF/mBnM0dvnW2MPMtsVeBtYilvhv8l81Tag7fWWLw8wjXLstaP5vAEY?=
 =?us-ascii?Q?rYdHa6ByF6Od1XXyDYeNFn5V7gLUcnc0S9UujpoNUPsMN1xWC7XTG8iygBXZ?=
 =?us-ascii?Q?8/RCWIGBFrSimHOVCKt86NhRV1Hf07P4qk7CrHKVhpEBky1skVBy/DVYfabB?=
 =?us-ascii?Q?3dRZsJ9Q0BIn53aIeTad8FbKjXw/MjZHv3haj4oK9lJ3SapgbhPPs2Xe0EGn?=
 =?us-ascii?Q?CCbquRfLlK/uLLPgNNvTLldzkNrXMejAl60bKdsYW+vlUV3IGqevIJQWk8bx?=
 =?us-ascii?Q?t6+/XY2RpzxAp8ziqo7Ns+i/u075KzMfTaiY4NCE23XykQQ0rfJX01dt1S31?=
 =?us-ascii?Q?qT5K9VF3X1OPAJcW5Zkn8rSUDy2S1qrqU1rOxDibP5Zl8T9M4f/EKAdmkrQc?=
 =?us-ascii?Q?CrcWtEJiPKTDGZmQrFpjpmAQO/ssDGFa45x8/rHeera8FkNrwKYqVH3wN51B?=
 =?us-ascii?Q?Rdt2vVZ1SRcNh1Ao9+XQXCzOu6OC84+lLoH8MWpX5m2KxU+W1RcxZauAKyqf?=
 =?us-ascii?Q?n/FcbGetrGEnteT1VaSiPVBjASQtiVvP740TJea2p88w0p7PEfrlcqZap4We?=
 =?us-ascii?Q?UmI5tpTxlg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c60e1696-4766-45df-bdb6-08dedbd51c5c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 03:09:08.8940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a+AMtJoHm47VyKrNiMMZnLTQVHcNAjBH8BqXLXJ5W9nQ1iCdp8SRvUtFP4t2ezOohKson70PVRYH1IcC2ZXrgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7096
X-Rspamd-Queue-Id: C200340006
X-Rspam-User: 
X-Stat-Signature: p6hwasp18bkktfuxn5f7bbm5sqzrntkp
X-Rspamd-Server: rspam03
X-HE-Tag: 1783393753-46326
X-HE-Meta: U2FsdGVkX1/HCdNER7zzvAUqIi+mfB+oM5KtboMWj7cpX6PYX0jQFMEYaaEKJk9gNpkuB8xTdLcVLO96htrdvrWDJEJf9UnP+1G9gsjDbhghqmb6lfQM19R8NdHOQfFQ+Il3m7KzS5Ejpdo1/+seoH/CXE50yrbpuoOWleQEz9x5y9QVWQ9uvznwfhQqZ65+C7biTUOEwUezxoLegv919x0GFar306HhWaGncp0K8foxEr/9C1XcQzgU0N3Dd4Zhmg2DZeTi+zL+WPqWoU3BAzANhDj2VomvkMUJSzxhqFnLM1lu5uL/Yn67kUTQQ3Eiu5xBY6KrMmilkNV8RQ48rSJWsUQHOocfaCF5dqJxvsWeyWj+KVohnRw5bxKeM2TJUhMk7WdfNHz+bN2id1v2NN2/H/n6QxG8s3tGAoyIO6sUNZzNOt5Or0Hyg5mDMJGBn4gnWjw6WiWrDIkMKmrhpMAUjQ4eHHGvT9IiaUw3n81LNf4RgDX/sB35J2Mxc+vtQYG5kCD5t9nArBhI+6bl2WktDKtbreubOsbn/0TR8iO54KFfFWA5fCBvwomyU183++JzfjmGPqO4RZstAmSxuYMvcEchFiTJCUp4iWTvfaRL/Hqdx8k35FfJ+7aXNjZyaCHqcedH979PfDr6HQj+fUtPWikDzTqeaebfzsI/MDi+dXGp+UIsrZnZV3Ib7vsK7/H0dkEXHU2qlBZXDmEsms9vIRN6BLwaJ6+1xi0Hk7P6Fn7kH8557X5K3DVgj4H4rVwyB6+g8b4I1CfZk5NFUF7TrU5vxJtOt7DADkwc39Arj9uGxjQOcYGzMY8AfAIiPqLF9ww3qk6IJuxfishje9Cn/HaErSzgJSjpSBg9KNLzw8FcytmatF3msc32iFAc5z3PATkm66g1X+71uIQH77hY4NQfcZXAlxJnLLbNSMnr1nkE/XOFWgYL7vVDIn9HSu4cTT3z2Bg26fe8uRm
 qocqLwWh
 AqoFkyfLkQSrmv1DXSIQauDjBb9P9cvwTRcC1m/I/AxfzJXXHPhYuEUB1IVD38AAv42/OmKQm7vfATqAaR4ilb9nVOwWS6MlNIFm2OdtS2YI3gn5kXeMBSjLsWeVj7s+zfVBvQCNZUWIn6s4ar8+zQt38VdHuds77pyCBDW1SAQRp3UKji1Sj1ujpYZQB7ml8BZH0bSW9sojFDf79ZzYtwaQ00f0otEWXdeo8jlFf98Z4n6L7GExRWSC6Trz3+/76CxY2picgdNvIwdcM162ZQLMQri78nPv1X7+simn3q69Fr4EbWFoFLTP6f7IOPRfZ9/cSPvqSRKwF7S4d9X8MXLgNBOJT6us0TxCt24lL2RUrCcjnYue4KEAi/0QLeT7FdQ6hvVFtP6nz3y4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-01 at 19:05 +1000, Li Zhe <lizhe.67@bytedance.com> wrote...
> The template fast path from the previous patch only accelerates head
> pages. Compound tails in memmap_init_compound() still go through the
> slow path one by one.
> 
> Build separate head and tail templates and reuse one prepared tail
> template across the tail pages in a compound range. Head pages preserve
> the existing refcount policy, while compound tails always start with a
> refcount of 0 after prep_compound_tail().
> 
> This extends the template-copy fast path to pfns_per_compound > 1
> without changing the existing slow path. Tail-page PFN-dependent fields
> are refreshed in the reusable tail template before each copy.
> 
> Tested in a VM with a 100 GB devdax namespace (align=2097152) on Intel
> Ice Lake server. This test exercises the dax_pmem rebind path and
> measures memmap initialization latency.
> 
> Test procedure:
> Unbind and rebind the dax_pmem driver 30 times, collect memmap
> initialization time from the pr_debug() output of memmap_init_zone_device().
> 
> Base(v7.2-rc1):
>   First binding: 1462 ms
>   Average of subsequent rebinds: 273.31 ms
> 
> With this patch and its prerequisites applied:
>   First binding: 1403 ms
>   Average of subsequent rebinds: 244.37 ms
> 
> This reduces the average rebind time from 273.31 ms to 244.37 ms, or
> about 10.6%.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  mm/mm_init.c | 47 ++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 40 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index cc8417951467..60794050bc07 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1081,6 +1081,16 @@ static inline void zone_device_template_page_init(struct page *template,
>  	memcpy(template, src, sizeof(*template));
>  }
>  
> +static inline void zone_device_tail_page_init(struct page *page,
> +		unsigned long pfn, unsigned long zone_idx, int nid,
> +		struct dev_pagemap *pgmap, const struct page *head,
> +		unsigned int order)
> +{
> +	zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
> +	prep_compound_tail(page, head, order);
> +	set_page_count(page, 0);
> +}
> +
>  /*
>   * 'template' is a reusable page prototype rather than a strictly immutable
>   * object. Most ZONE_DEVICE fields stay constant across the pages covered by
> @@ -1138,10 +1148,12 @@ static void __ref memmap_init_compound(struct page *head,
>  				       unsigned long head_pfn,
>  				       unsigned long zone_idx, int nid,
>  				       struct dev_pagemap *pgmap,
> -				       unsigned long nr_pages)
> +				       unsigned long nr_pages,
> +				       bool use_template)
>  {
>  	unsigned long pfn, end_pfn = head_pfn + nr_pages;
>  	unsigned int order = pgmap->vmemmap_shift;
> +	struct page template;
>  
>  	/*
>  	 * We have to initialize the pages, including setting up page links.
> @@ -1150,12 +1162,31 @@ static void __ref memmap_init_compound(struct page *head,
>  	 * the pages in the same go.
>  	 */
>  	__SetPageHead(head);
> -	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
> +
> +	pfn = head_pfn + 1;
> +	/*
> +	 * All tails of the same compound page share the state established by
> +	 * prep_compound_tail(). Reuse one tail template for the whole range and
> +	 * refresh only the PFN-dependent fields in that template before each copy.
> +	 */
> +	if (use_template) {
>  		struct page *page = pfn_to_page(pfn);
>  
> -		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
> -		prep_compound_tail(page, head, order);
> -		set_page_count(page, 0);
> +		zone_device_tail_page_init(page, pfn, zone_idx, nid,
> +					   pgmap, head, order);
> +		zone_device_template_page_init(&template, page);
> +		pfn++;

Similar comment as the previous patch - I think it's clearer to just init the
template page here as a separate step and not unroll the loop.

 - Alistair

> +	}
> +
> +	for (; pfn < end_pfn; pfn++) {
> +		struct page *page = pfn_to_page(pfn);
> +
> +		if (use_template)
> +			zone_device_page_init_from_template(page, pfn,
> +							    &template);
> +		else
> +			zone_device_tail_page_init(page, pfn, zone_idx, nid,
> +						   pgmap, head, order);
>  	}
>  	prep_compound_head(head, order);
>  }
> @@ -1205,7 +1236,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
>  		zone_device_template_page_init(&template, page);
>  		if (pfns_per_compound != 1)
>  			memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
> -				compound_nr_pages(start_pfn, altmap, pgmap));
> +				compound_nr_pages(start_pfn, altmap, pgmap),
> +				use_template);
>  		pfn += pfns_per_compound;
>  	}
>  
> @@ -1226,7 +1258,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
>  			continue;
>  
>  		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
> -				     compound_nr_pages(pfn, altmap, pgmap));
> +				     compound_nr_pages(pfn, altmap, pgmap),
> +				     use_template);
>  	}
>  
>  	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
> -- 
> 2.20.1
> 

