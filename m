Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9503ED111A8
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 23:33:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E07596B0010; Sun, 30 Nov 2025 18:33:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDE6D6B0011; Sun, 30 Nov 2025 18:33:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF41B6B0012; Sun, 30 Nov 2025 18:33:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE9FC6B0010
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 18:33:31 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 602C651A36
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 23:33:31 +0000 (UTC)
X-FDA: 84168877422.28.85603AC
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012017.outbound.protection.outlook.com [52.101.48.17])
	by imf04.hostedemail.com (Postfix) with ESMTP id A0D574000A
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 23:33:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JjARPtpX;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of apopple@nvidia.com designates 52.101.48.17 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764545608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RJ3Sx2ICuYoWnso/y0gtB73sRFD+Rmgz+NZk9YCm0+s=;
	b=h4+Q0z4li0Z8Rgq68ixT9w4K6DmaYJac3QVIGhNNdzMLxresblkEWdmGdF/ypYdK7mGXZK
	I9eZzeo5L+G2/AXRnkcuZPVRvsYmbEK4OkTadX6vkgoTK/xmyaYxg8u9vlSH8KqkRfFrl9
	slZS32hV4K0O7fDrNRt3UDKMync34nI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764545608; a=rsa-sha256;
	cv=pass;
	b=E0XoUW4Depjv4pUVpPhZzQ2xhXmgAuJ1v8ARcYF/Jenf8stt/sOTBjVY6TNMuJpCN8Oe11
	MkfBaGm80SEZNG6BpkDCPLjMHUEIEJVDuXD/Rqif/hvUr3iSlkUQZ/n5Ap2QYceWa8zDBj
	2+/mhPoKPPZlYAW4yAtds1W/3OkAZwE=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JjARPtpX;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of apopple@nvidia.com designates 52.101.48.17 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lRteP1VcJoM67SjGeMiLmwloA9Vbw14CBrqxsjF+B2vY69ax65MNvhPOJo29cBT2NQ3UPcQzgi6SDOUwxpD54/sEj6xCLBwJd7SZaiUBXKeq5s/1RZxVc+yZkM5nByw/z4i3kwx5xV8leh8GZQX00V7F2GEwt7EMv2O9L0UNA0zIrMANGREJ+Si6X5S1tQE4zdEdQJeNGO82gLiNh89OvmSDLWJPS/2fT19ZYVe4MQHKBSk/Uv5zC2uNUU+oJJRCdjefFxcLCX+sVjAo3tNU9VWP2ax+zXnUL/2jr/njlsBJKqvwqftbuGvUwMcUUieBqyCivFcUZbRAgrmQ99VunQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RJ3Sx2ICuYoWnso/y0gtB73sRFD+Rmgz+NZk9YCm0+s=;
 b=HnRlAwsaKT20aYZJQj7pznw+LzBMpeai3QfFeYBTRSkLWGG1gknJTkYVcgL4HNRfkRsJcQWHlECaIsUlYHw0NxnAu4y6c4oA16by5VrWUr3dAdA0Lnx/f9AroqrNHUZDg7JdZAosjY/atRqhWUd/rxsUDXNXRxYwyLSeGgz8+JTjOAAph5uYNvNNPmKd5vSEclWd69Q6FkrMLN5mPWJQy8wT1mA7xNt29d8tJF8izpRtVg2u/5S/s7VusdMlpbS2W7CHfMoO+6HcXBtmD2KAggdbDwnwbN4abybHbYUErQRFLh+Nc0Ee3K0Hq+qjQJgVg1AyN35beYyYL71A71C9pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJ3Sx2ICuYoWnso/y0gtB73sRFD+Rmgz+NZk9YCm0+s=;
 b=JjARPtpXzA0ufNm/Ec8/lvPm+Y40peZflWRPyNhiXdBbhwRJXDI7McMQPPmb6QugUCrg2fqg2cp1y1boZxbfiQsOwks54308VHHn6h3rBxF8bHG2yw/H/JmuM8btM80+DjeowGgwkS0QPMKCM72bbOwDi83s+vnE67cCDuXCN3WIGkJayVB0OiJ2VrBDU0r/zJVecWenK0w3XsbhawDh0SgrfaJJ/Z4tBUXIXXX/83kwOx5Dvlm7sdYo2MtnEqU/E154+95zGFke65DL0DPuLmAfq79/R+cVbOUXD8Q7L9BAFbhjoXfNEUZsQeJ21PhwNfd487z8Y4v0qaXTWJ2kLA==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 DM4PR12MB5961.namprd12.prod.outlook.com (2603:10b6:8:68::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.17; Sun, 30 Nov 2025 23:33:25 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe%4]) with mapi id 15.20.9366.012; Sun, 30 Nov 2025
 23:33:25 +0000
Date: Mon, 1 Dec 2025 10:33:20 +1100
From: Alistair Popple <apopple@nvidia.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org, 
	balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, ziy@nvidia.com, 
	lorenzo.stoakes@oracle.com, lyude@redhat.com, dakr@kernel.org, airlied@gmail.com, 
	simona@ffwll.ch, rcampbell@nvidia.com, mpenttil@redhat.com, jgg@nvidia.com, 
	willy@infradead.org
Subject: Re: [RFC PATCH 0/6] Remove device private pages from physical
 address space
Message-ID: <dklhe7gbudew5mdgrxzhrw3wqnnqigapbtetnn4gpaktlkpiyh@kohwt6syeapn>
References: <20251128044146.80050-1-jniethe@nvidia.com>
 <301376ee-3439-4d3e-a2c9-8604e7bf49fb@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <301376ee-3439-4d3e-a2c9-8604e7bf49fb@kernel.org>
X-ClientProxiedBy: SY8P282CA0006.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:29b::20) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|DM4PR12MB5961:EE_
X-MS-Office365-Filtering-Correlation-Id: 87d4e14e-5116-41dc-e1f7-08de3068db68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J/bz8+uOdWelXe08+6Ux/QROQDstjEx9rREckIZUOjEdHhsnzzcKsPatLaIw?=
 =?us-ascii?Q?hortirKcMC0dF0RwubjpnnvYJnjJKfQnbYItE0z6LY0kiHmfe+qfpcH632X1?=
 =?us-ascii?Q?E0HHE8Yzcqksgi4F8RA9AOH997TfJd1tJksKFg3y99AvvbeqqJ4oIGd/zVU/?=
 =?us-ascii?Q?mpUZGYEsPofF8fVqnLrS7oXS8J1Tc1UarFuID/CPw4RmAYTrWQjm8f7vyW/t?=
 =?us-ascii?Q?Ibdhs9DE5GoHbJ/4b4YKw0+AOuvzgUJbfc7/40/WtlutHZXYTJ/IblMknDhk?=
 =?us-ascii?Q?joM5xOXbHCiZifhBrR0q3pWIqztnqNmD/G4+9adLnn43ima7L06I4u2FVV85?=
 =?us-ascii?Q?7AaHAxmAvkD60DNaTxj+iTvD2OWC0b0nvvMWuh+8IgLk8jBkS2eS5veLO2y1?=
 =?us-ascii?Q?2WNkeZqWjZIOdLaQVVNDJI1mDX1/cPpzSn8rYkNQ4/K8dou5+Aaa7piZY4Ti?=
 =?us-ascii?Q?2Jq2PRV+JsGxlYlwY6Q1lJpV1O/cp6Ev2rnQ8qk22iHb3ybXkUJTBrR/3oYV?=
 =?us-ascii?Q?gx+T/OaoSU7St+C+EsN8zCEXjArmLL66XCP/fzsXuRWeBbc2up2uSzkuR2gi?=
 =?us-ascii?Q?jrOUuBx3nAwsXHvlyVGiFIpCjVq4UjnFIZnbs1FZiNa870t6/VBxjJpcsWcf?=
 =?us-ascii?Q?7sIS55DpA0g4k41CMMKNFEtt1dr1wln/XdjN1/jl/yqQXb2wPrhboPRrB6PS?=
 =?us-ascii?Q?A/jjMcWQ3IkmNoV62zCjPR2ZyfplOk7S1f3W7JmkE9U+vXv7CM5dbzNs/8LU?=
 =?us-ascii?Q?yk8yYgnL9YJojPZLPfV8HRDhvyppGcD8c4zFLS6DMyJ8qClrg5dFzT6ypQoo?=
 =?us-ascii?Q?sQew9bPS0DSk6s4XXkZPFxJ/RKWdJthC7EuKrKqUl1HzwPojn9AmiOfRbLg2?=
 =?us-ascii?Q?hN1/7L3Nfc6RbF8iODcqAYs7oTZjOTLaurPCAh58FrKwTm78Q0QwQjt5Ub9/?=
 =?us-ascii?Q?pSV61FphtyGtagFPCOBQ6hPw5Xt9hgeGaYHR8WIhinQ+8muCmkBEbB7FzFDQ?=
 =?us-ascii?Q?UNjq8ogybc0FpdNgUyik+gaC2FoziURAFwfAr2bKQqaGZOJGuaM2d+zEtZDd?=
 =?us-ascii?Q?bfnzOnzcF3IbYo6BJbIe6aW182QOERDBwOjI3VBnFMQjI9N0U2TYgeCMp0FP?=
 =?us-ascii?Q?svGv3iGi/oPPz4lsN+ElCMCQrvC7WKD4Dj+WS0C9mMcUOEkgmhfcRR38rG9q?=
 =?us-ascii?Q?igOqj1R98ZQEHN0eJueTHEL8nfMof8Pa08gslAcb1qQHzUeFML15UGDBd+1P?=
 =?us-ascii?Q?7nwCMssuJGz1Nl24Z2qV8tYpJRSmnOcClCSZ6oP35vUE0IOWpJHrodar/Ech?=
 =?us-ascii?Q?df/+ew5ZspOQYPZM0jjU4Jflqy6M9265d9en12hxJkKszcpEgTH1LQCK2cEL?=
 =?us-ascii?Q?p9K7xA9QExkp8U1ZBgy5R0uI+9mIyHnllQ34l/101miNh5/+Aa608nLdTd/f?=
 =?us-ascii?Q?mn+DEcRNxLZLVythPgXfZLu9f9N3vWQ/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ldjAPZ+Kk9bUownhgvYva87ecwW16jz+g8AZG/rzIuuIxOyNqsKI26wJwsgB?=
 =?us-ascii?Q?JSMOONf/cyX0oFrnKFlOIJcrjs/o3eKEkm/iJ1jVJ3t01jdEfi0e5tSdwKyr?=
 =?us-ascii?Q?gvsmmkrz73/8Pe9r2xuVVeqjl+jA4SDOf/hulj1g7yrpuoclVR4pfjfnnqGj?=
 =?us-ascii?Q?d9E8H0stfJp7ZpQ042VoM7ZRxnxMEij1omXrSwbs6AUJNjRexHkBb8qU5tc6?=
 =?us-ascii?Q?VWrI/LPmLC89/ZyYq5ORABHG82HtDlaf3W5Py7F/K51SA6UEU7wr6vc/XpSf?=
 =?us-ascii?Q?dTncPpnRN6t6IuB26jwvj/BviW/0Rz4PGwV1EMiCjK9uhrbZ+F4B+5kITHQX?=
 =?us-ascii?Q?ekP6WOnb8Sxxi+lq+wOfdJcxCLuxVAN1YhGJYmzcOFspx6xOEJlbuZyiITsr?=
 =?us-ascii?Q?msubPa2eqZ7p9cBrDJlNHa4IOW+iFinQoD+xo0xdTLEzfe0xMccSXL5IPXfD?=
 =?us-ascii?Q?ClgFFU9XfDwp6TYZJR+84u6mdwR1Qgz5myggpRNaOILS23Vyu/hM4He3lDlc?=
 =?us-ascii?Q?t1P3lPoBU8LxiMLecg/90DcagbnMPosylH62KmkPxId9ExfXrla5wXjnFe44?=
 =?us-ascii?Q?JL9P4MkOdDSk0o1wq1F4AxqGaHPRhDc4oKkQDfwPBx+N8ak0vmhQ7rEMLRXx?=
 =?us-ascii?Q?+BowNrpF9koRhKZol7PcZI9T2uA9Nqzo9LgsrodEzlEhYmVqYuljyAYAZSnw?=
 =?us-ascii?Q?ZQWYu4GGPWTZwYrrclGiRshjL0AsIF/BFFIWqqTN4DlCmSZrS83audwEJLP6?=
 =?us-ascii?Q?T8SWl9pAH5WVa+7Dt1GRnnXJNls/mXf9cFWN5RfhcGuMZ8cSA6EyUv45z15c?=
 =?us-ascii?Q?EvCT/gFb4nxIU8Fe+LADLmyK9PFbHUj7RepUzRd/gGZLOfD1UUPJKm4hXd/j?=
 =?us-ascii?Q?t9cWisSIgZMpx3cyeREaZ4hzNAYeq8itdJASGi8MlD5d2849FAmgvtxl2oA9?=
 =?us-ascii?Q?wg7We0f6SC+yu2pbaK1usTna4z4aE37ihsDcfjL9ee5LE5gojqycDy/AgaqK?=
 =?us-ascii?Q?ysczFXS1kBhY3MU25bgxrasSF3I2xD7+tezCXRkxQM0f3oewppgR4Ed5D0Yg?=
 =?us-ascii?Q?Xb8xlpcaNIC7LamGPCMKF1ONJw6kLpLjmJlzlNsZ7CoN6t62zC6E5X2JMnum?=
 =?us-ascii?Q?f6XeIyVlfHTtHInSx73PT6Se0LQTqhQb2bYu+kUmgR3mkK4ctGzPxezC4VV4?=
 =?us-ascii?Q?by0q/JTfd7S4kd1PPJMl8VHWrfIvd50FT4NqolSj/HOQjlOR56lf5ThhoF5W?=
 =?us-ascii?Q?QdqKECvtlvYNQhXUP+1/p2HcFl36r52joyuDYDiqhppJCbYfvAoacS1tQomE?=
 =?us-ascii?Q?I5M0/nI0VpjKEQQzzuyhJloUjFybLfhiyD2LsE8Ch2522zvnKZlcN+IPo/L7?=
 =?us-ascii?Q?Eallcw+f+FcIe8jel1XH88T+H7QzMHtCBlJQj0ez98ynKUREST7pf7V+KHHh?=
 =?us-ascii?Q?kYTzp1NHfYIQO/rWwSZ/u1CWEkqbgfgjuZBAI3b87FfAtFb9uHyXYBNtASx3?=
 =?us-ascii?Q?Ja/rSX4n86I5TDQXg999UaOzzZ9PdF59oWpKcG9HBpjWp1BAcf92KVfD/+9h?=
 =?us-ascii?Q?N/bn/lO0RNaDXGk9Q7FroNfCH02FdH/PPvhtx39B?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87d4e14e-5116-41dc-e1f7-08de3068db68
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2025 23:33:25.0310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qmLJMrvGqzDwFJNEjlPNwmAUWkQzirbeJTp8UU7Mii6BcXKH3zR5dj9FeKl91TVuu5wGVTch5cnkXc8T5QFLZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5961
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A0D574000A
X-Stat-Signature: azopfchsx6k1hqnsqzmsby864da58z9o
X-HE-Tag: 1764545608-117881
X-HE-Meta: U2FsdGVkX1+pq6UXKn7bZ/iW9MVcjaIQkLC0oKmlZQhs85sEmI5hL/hvIj5zTfnDZK1uMSJevL7n8+bkaDDghQZIL30JtT4TrIqdGHx8dW7asJ/loZ4ugubUX3/Fqa8TG8GUn/DMimPknbSirWkPmCVlNesEahg0fX8waT68gVaTdNUhsHNPH+ozeoBoQqiMWW/i+AxQQvlpSXFoGIaWMecOSIhdHbIQctKMUZCGkiGj+tSKLgchX6n4tvTPXPw4OpEUoS0QNW5XCvdoSqZkv8Q8koJzWTm7IK7eiZfm/3Gr+WUqwUdqT1J00EvkIQ1SW++Uw/C2FCOd+fvT+6Q17dXRMOVnbtnXzFUoztD2ZDgP47Mqiz6Lxc0rhCaPFLodglpyu11x1TBdDqP6l4JlqJq1r8yDJv6IojBn5bMq6m9OrOZE5Vm28YxTYqoh/U83JssKUBoZQLpbCCoyAnWdJJNl5C7oAECS057KHxAHNcZrKVq+P0Oz2f3VJbbIkDkQosWsgJhUM1UldrhSyg8CIIaU+HpCvGrkWGPkUSpRoZXkAzKcsyoZG+dkGA8vxBR77I+DOZoIUWwQabtaNlULUhdSrSTpiRt15SLAnAE8n6BUGex/mQro19NB2eu1bwY+Dt0E9nkdYONkkaf9B9hh+oU5+6b8Xeg9YuwwO4WVz5oJMVTBVs4lrxOpIJHjl4ji70b6t3zT5Vx72esgOL9tUDdmQBhONU6MFW23xGba/32K9xrFNESuCk6A4+7a3gcwsPffJ29ARIO0vNfMNzcX8V+6yH+VLmRnkK3GRJgoqR3OrLBOjutlJoezOHll9jJOhmEC3AulZIrLGDEW3PSoyWfck85hCHethdIMBhr+6K/WLscNTld4OPCsv3KsJrx3JX33mCePICaRVZ6JyRFWM5VoX6LKY3swi2ZfLT9w0MfIC5uTMgAvP6PaJQb0PISLB7uUqFfAfMPvlmERQ1O
 VsAbrc6K
 8FJUr6iV8VFnpSVlEpmE9ZYS9FtTQDUwgK7rABKml7jP8kqfttVIufOs4FSe+NvE4013Pr0s2iWsiiVCBNiwiLkJ8KuIxJ0G+lW4c7nGlxgiHQK3Uxhmiif0tDxvv8HkgJNJTv2WK29lr8zSBTLQBgP+5emowcjIPrRivr19sCyl+Io90Z5yfDrCR350Z9N11VOag6abpgVPrivMJ09Z1mFyye10a0PfzLDdUy2m/aE7JOzuBSbkbq9T5puWd5DHOAtPeEvRk3DVEkap+OWff/bSw1UJih9T65dHm3Ud55NjYXFRPKDy3RhxRBRqbgoo/ZA7Mhga+Da5TF/rixCpyh8OoLEzVBt+Wh9TiRVZUOxBCIuvLipb8hqm9VCnkn5KpeIXPEhW/T8FgQxVfbrBJuVQYzL+3pSk1bu5Pb94tPljZPzWFIMcslRoNuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-28 at 18:40 +1100, "David Hildenbrand (Red Hat)" <david@kernel.org> wrote...
> On 11/28/25 05:41, Jordan Niethe wrote:
> > Today, when creating these device private struct pages, the first step
> > is to use request_free_mem_region() to get a range of physical address
> > space large enough to represent the devices memory. This allocated
> > physical address range is then remapped as device private memory using
> > memremap_pages.
> 
> Just a note that as we are finishing the old release and are about to start
> the merge window (+ there is Thanksgiving), expect few replies to non-urgent
> stuff in the next weeks.

Thanks David! Mostly we just wanted to at least get the RFC out prior to LPC so
I can talk about it there if needed.

> Having that said, the proposal is interesting. I recall that Alistair and
> Jason recently discussed removing the need of dealing with PFNs
> completely for device-private.
> 
> Is that the result of these discussions?

That is certainly something we would like to explore, but this idea mostly came
from a more immediate need to deal with the lack of support on AARCH64 where we
can't just steal random bits of the physical address space (which is reasonable
- the kernel doesn't really "own" the physical memory map after all), and also
the KASLR and VM issues which cause initialisation to fail.

Removing struct pages entirely for at least device private memory is also
something I'd like to explore with this.

> -- 
> Cheers
> 
> David

