Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84D4CCCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 20:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E16B38E0012; Wed, 22 Oct 2025 16:48:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEE748E0002; Wed, 22 Oct 2025 16:48:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDCFF8E0012; Wed, 22 Oct 2025 16:48:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA3698E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:48:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62A93C097A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:48:07 +0000 (UTC)
X-FDA: 84026937414.16.F706BF5
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012015.outbound.protection.outlook.com [40.93.195.15])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7F33A2000D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:48:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MctB1mKj;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761166084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8FTLrvAg50JWqHXkPWZ4lpNcBB3ukMj1rhYXGglUqnk=;
	b=sIYX3zo8Bj30S9e97fuqD0eB1gijgW4no1XRIMeP2ogQmFYgkwLDiGF4dtH6ngeD8HSmhE
	cuUo+CcF/oxdZFSieYqUj00XuapMcqPsdNIUKnMgB1YzDKV6E1xAP8XTw/P3aKN2vlqEZ1
	+SsQr7BseFYHTQn6oaQOKCOOYb8bTi4=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MctB1mKj;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761166084; a=rsa-sha256;
	cv=pass;
	b=Z41Pz4y98YunwU8WlzQzFQTgdDY7qCxM/3OtNzGAz4c1i1HSwrkp2yapVx96ewHpqTmhmo
	HHIgoy6WWFCTY+qTaYGuv2u4ol5xxwVwaz74bu9zkrQlhfuXQM9+cGloOy4ABSx7DlqkEW
	iB7a3nP9+VuybRRZqOS5XtlaXqo0wdQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r7ktlnMm3Gwx+Fbeeqk4UlfKmTdJObTQtmdTh+zCXG9whO4SNeGm2r6n24O4s9/UXy45fRTMti8CIK4uo+2P9qeVo4kDFFp9VsFbaHqxr04skf+KJlBtAbpHCgCCgCBmcFs+XC5HrOKDr7ZI+4vkQc3zBdCyYnlGLzZz6bb0Tf2/39tVNXdbAQic2IbP7cX7QMJHDX0GwOlYcOHf9el48tMLBPx65BSZplmWgUhXT+U1A7bRo7hZRjwfr8wYleWvGklKJYOiVDh766SFVaqNjqh1wiHcTWBcNz2TXUWuRuJH4+OC3vtFbCEneP8/zuGrn2k/rNVdwcsfRHDZ6Z0wjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8FTLrvAg50JWqHXkPWZ4lpNcBB3ukMj1rhYXGglUqnk=;
 b=JxunyRJlgXMK8wOruhhegnc5pRUd/zeIR+574FzI6wOl/9FvsymrbVj/REaCQXKSBHni9fb6HfURg7lPtopg9QMB0Iyo7p7uRclz3nRitTzpcL0WU23K7tU1/9DgWwj5n2+OTFDrwnPke83G3jgyz8B1uAMIxiXncsKCbjjFc9toLI9EDGcsVmcDQ6DNOmlh/meBXpJAu3SapaQ3nU30OXJV56c010SGFasnxjyrN6PBXasir7lvZF4CTWUplNE0WzKbsQkPSpAz8JjWjeWWhyovEkCpQgjLIB4WiE9VuRrUTPJHDWGV36vcldS5DctxsD89v3fQF8U1NyZCTNTKcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FTLrvAg50JWqHXkPWZ4lpNcBB3ukMj1rhYXGglUqnk=;
 b=MctB1mKjmJUVv90xMV8SJAZXX15692peb296wVfCPoZJAV0bKrCcy+Fhqqb5IeR/dk3N99qdvdK5cwiOaCxmeGOseZ3i76yOtv7Y0v2bXv9GTq/YdKkhBnyguSdrTrpOZkQYVnlV4DdYjForqQc+uI43mtfsMqcXCHf4CR0do2NKd8NKpqCpAcY8c8+ooqitpHOxohG30CaTj3GjWqkWWtWB8Y5jmAMDDltjNcxPUrEeWF4iTbJOa/bbXhcPIpoMehSFtT6+Mwqe0jX9j4l9sNBSYtfxZNI9ada5KFsGoCUzyQkmFOpJyiRYFEja48x6jwVnSRjrD2THuydVtaI4Hg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB6955.namprd12.prod.outlook.com (2603:10b6:510:1b8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.13; Wed, 22 Oct 2025 20:48:00 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 20:48:00 +0000
From: Zi Yan <ziy@nvidia.com>
To: <linmiaohe@huawei.com>, <david@redhat.com>, <jane.chu@oracle.com>
Cc: <kernel@pankajraghav.com>, <ziy@nvidia.com>, <akpm@linux-foundation.org>,
 <mcgrof@kernel.org>, <nao.horiguchi@gmail.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Wei Yang <richard.weiyang@gmail.com>, Yang Shi <shy828301@gmail.com>,
 <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>
Subject: Re: [PATCH v3 0/4] Optimize folio split in memory failure
Date: Wed, 22 Oct 2025 16:47:58 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <C2476537-4C48-4016-B3CA-393D48C9D048@nvidia.com>
In-Reply-To: <1AE28DE5-1E0A-432B-B21B-61E0E3F54909@nvidia.com>
References: <20251022033531.389351-1-ziy@nvidia.com>
 <1AE28DE5-1E0A-432B-B21B-61E0E3F54909@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0PR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:208:530::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB6955:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e3d8a22-5c20-4792-2690-08de11ac49e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JhOeaG7bR/ojM/WcAbg3cN4etFot5mvJXM9MFRZyK8ki0sJ+brryRUqoDrBz?=
 =?us-ascii?Q?z7Dmy2Cp+8IChI1oDHf77G0o19mP5mSdBalGWux/+PBpFFYml/6jLF7p3N2B?=
 =?us-ascii?Q?s1G5/iTlJV1DQIdOc5ZH5aA2INqEGeEFucer3DwtGGNES8KhebcBaxEcUBkO?=
 =?us-ascii?Q?0h8qGzpjLKrj7Op1mHagJRdaS7jWeFgIYCorqmfTJEjSi8ptjemCPW4RYRrP?=
 =?us-ascii?Q?m+Pno4yVpQSRvfPtg5AUH4tzREQMOpD/j40omGF1IgVdQJsdwcWVwirksz6C?=
 =?us-ascii?Q?d+7Tif4s2ubFuiGdudGCXsckUSDLsBocgmYwVsib9wbFWrIN2vat/ONVU137?=
 =?us-ascii?Q?dMqS2PCxN+0qaQPE/YPMP39z75tH1zvPvdFG9Ozw8AI6J0Z4SHHW506XPJG8?=
 =?us-ascii?Q?bUvi1GuQtIGtL9QlAKzYwdsTQYjzRdkqf8B3QnupFlv5SRf3DGUCX3z3YjEj?=
 =?us-ascii?Q?BV8p/wwhpx4HIE46ZKqM3IKFKvURPk+xSs2MqrCHMbQcTFBiSK3Xqo0Y0Ory?=
 =?us-ascii?Q?XzODoV3jvBcTIHjBi1+BkEczaObcSqBNMtvikkogMFUtnNL/CrCv3sgev6Fk?=
 =?us-ascii?Q?BC4OBZ/ZKcyK3orxoZaOCe3PRybO1zROOrdmvmnZFCJk0gPzGwSlxNRetyxw?=
 =?us-ascii?Q?R1iP5UzA4AInV0mClfEElrpUKKiwbVQYGIqWSZh/1USiOXbZxUKSggeTVQtl?=
 =?us-ascii?Q?PvrnZpLwmYvZmmin0u5rno0zkXUC1fZkASIbrgr+v4IIvW3U1xWCjRFsY/E6?=
 =?us-ascii?Q?6wKDxijphJHIGfKYXmy/MUjQEYpyfntLI6tIZ8v3HILIvRp/PRJsIaDfp8uU?=
 =?us-ascii?Q?xO5aD7qJ5gjXGTycmkhhkZ9Mkk1UhtkYdyOyOLp4V4XVRuZsz8u4PjcgqLSr?=
 =?us-ascii?Q?2heuQaSYciYsgy5jvNcVaKVB+ip8m559g03735tTprM/X2audYim7+LNXjQE?=
 =?us-ascii?Q?r5H4tZ91601oauXmuQFGnBZL95A6bod38w9IiY81pv6NqSWtn9rXxC17HWr9?=
 =?us-ascii?Q?NYJaDbxJFmy6gIzzT1wy0+paK4wYBHWYkQKvsAtTC9cORTehFThLv2zCZFdX?=
 =?us-ascii?Q?6li/prSoisSN7muDiGEjJDRuyvgnsW4S/bXoSE10pO2O0Nkzr1WkDaBqbuD0?=
 =?us-ascii?Q?MocH8x5wHO8Ym/lpyctIdXTog3fq/62DHYKNtu30ABWVYLc8/plEB58Zcpy1?=
 =?us-ascii?Q?rZu+pglLzaCJ3WpbFih8rGzbS1Y1nfvsaMEpkRV4WIJ4RoJOZYEilTaQ1NQw?=
 =?us-ascii?Q?pfwyKGPzpikAeEq8XQ7kfiOonYictR8iCJClSBFNQ1RCRbyvIdDMiJ1hwPq3?=
 =?us-ascii?Q?AkTRvDM2L6VWfxJ4riMeNeOWPQEpTjBvMB92u0oMxefstD0xmgwtF1dNUuRr?=
 =?us-ascii?Q?PdJ8DO2TvL90KYNwBGyngxty3lm0MZgMIkyiQa+wixe5gyHvfFXHg5WGJVXo?=
 =?us-ascii?Q?gbh+bokq/FqUkuuywEPvbGdOmfN58uzpK/v2I48YM26xw8WRBZWUFA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wUqO/IDb3oau3dyDeGB/nse5tDdHRpl+SDy0ga5fglED+GA6KLSc+f5Fc9XI?=
 =?us-ascii?Q?kOvdq0CW8P8N0VPOooEawJznmFARxD0VrCdR5aYM2FY9kQAI2e4eE3eTrtFF?=
 =?us-ascii?Q?RLf8ckNvR5zIhMIE+1abXs+y28W3l2n9Nv863VFcHlZk0gnmsD9Bo2u7zub/?=
 =?us-ascii?Q?WYfol2qUUW2cA+ZxJrmG/cFry6fx0NbUPx5agQGT/2HcQmZuMe6l7LFlizUK?=
 =?us-ascii?Q?Jw3UFbJV4P9xqQuW9O8NkrHcApDQczxpKq6OjXdv/D8uVA71sfV+0Q9vxNQp?=
 =?us-ascii?Q?jX5+qNWOYeG9JvrN6239d3SMF4bgifATex6xxGTJnAFtkXokg/jHJTXJIib9?=
 =?us-ascii?Q?vDmQJ6PGJDuBHyBCR9QHTVvYQ6s2g0rpdElVmiGPOfHKlI/v21leYA0+MCpW?=
 =?us-ascii?Q?8ZYAjxlIBiz76axQeXFbuZtZH3nbH4BxZpEOm6A5B7vzs2vwZ/r+cJVbo60Y?=
 =?us-ascii?Q?YZuUnA0rGVCq8pRLTRXLV6SGevSEMH4t7nm1lY9bxcFZZS2fHvIlnCpTYb2G?=
 =?us-ascii?Q?j/0TX3pHb+HRhIZC3xQ5Urr7pIa4zHZDyQEtcx6L+sNS2z/iK3OardptTdVE?=
 =?us-ascii?Q?TOAUCTkIhLwmay1z3NUI4Ztk/V1FhU6Qpxnlz3+xn9P+NBo8T4ZZY2p128jY?=
 =?us-ascii?Q?mBRiuDtO48TbC2s/Hjaf7WYYncDaDYCmd5Fn5WgTs5YmWrK3sfbhnfdeCvPE?=
 =?us-ascii?Q?VNq3bzNtjvVWWhec9apZc6BXfuUWNP5yMOs3aD91U9QirBTvUFjzWr+OWa/k?=
 =?us-ascii?Q?MxDi8WnjjKVoQcKqcL4H3dthgl9AFxQSzEAOLAsik7FaRTMmPttIpYomWUTL?=
 =?us-ascii?Q?z8bWFpAIjcZ5JdJDTDJWLf6lE6Ubhxhnpwx7KzkShQ3MMfXKQPas1CWJARDt?=
 =?us-ascii?Q?a/32hYONmTivTpVvwCebsfu6Seq5PxSQwVRmC9ASNWYRRwdy+k7iqsJ7p2dp?=
 =?us-ascii?Q?GIo6TeCPZYWSltb/hvVZpGaqx0lpp+7zK8JiHq3GBCWOMlGa9I+ZZTpzl/2S?=
 =?us-ascii?Q?oH00zPvXO5bjZvgMxZJfiGtQljROzrIzktr8FOSBJL/tH7qOtZ0g6ZmEN5Re?=
 =?us-ascii?Q?yVurV5srrV8pTCCluBFeoDeJQJi0xCmX1J9gVF20dQigYjPmyYqsepTNfi8B?=
 =?us-ascii?Q?Vu3rA8PUNF5mKopJKu8A2WH4OxeBzLZGTyE/IfQezwnXFAOfw4zdAQTCl0GV?=
 =?us-ascii?Q?UWh7WHm+kpuCBmINUjWajNjfVdx2bL1RFrtEINOupfiXkbxkmByVF+YUAcbZ?=
 =?us-ascii?Q?SeGIO0/5fIIo4wp4RjXwWlwlU6wxrZ6OqeILV3zNmX0Or0haoF8m1IRa8F3f?=
 =?us-ascii?Q?1NSBbXBt7wzMJCbshhIi5swIdTjsDlWBGO0ncngIPCAMBPqIcPzW9Ec/atAy?=
 =?us-ascii?Q?Gi8UKBVF8eHcGHocoMT2J9USJ8VFfL2VELXM5K6XoK7CAqYddVMyTiz2D7Om?=
 =?us-ascii?Q?uxrknT1T20Rt2TCEcwOHNbYa6btt+E1reeDAGdOSARLSLy/lgAUkDLVD5cLQ?=
 =?us-ascii?Q?YRy2GuWAuIfUHM/9yYyTFm/H3sTulozm/jrF9j7sj9S0/69S/vsC+mAuF61l?=
 =?us-ascii?Q?FX2W8BTyAMztkphrpUIugp8FmsS74qf3P+++j9vq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e3d8a22-5c20-4792-2690-08de11ac49e7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 20:48:00.6372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xFe0gSHGL32MYX3rkSuASpItMbTYsuQiAzixP/rKtQ5W5Vzp26rQ7tCmBy4Z+ytg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6955
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7F33A2000D
X-Stat-Signature: zbsp6xrt3chwpz7bpmr1ae6he5spw757
X-Rspam-User: 
X-HE-Tag: 1761166084-398438
X-HE-Meta: U2FsdGVkX1+fSF34QzPByyMZyPhbRH2dx7yOmJ/PHOKlIBc4XbjjyNNVNdnyeJC8NJwCnSjdnDQnGxxTptx8sBHrIj6rJbZCSa7eimc/3ygLrJyZodDHcSB1VWtuy/gMIOgDQ8XIyic3vkipi7+Lm/zTOzyT7XbMph3WMUB+y6x2oeIICcIUibj8D32jR+l87zn9bLUPmgD/FS/Jo5R2c3TZRwPbQGDa4AH/yrK6dMuuHZD050UDnQbyvbPr+iUXJpsx94L/dWdfYhua+68eHCaTO55A+LzZUUhc1aL5ovcxnT3dUjgJXrjPWVogiJxud2VKZwjDEspb9EbniL476E27aMXGQVbn7N/GzLSWcEEmErsZz/oqwEedMzLQweZ7ELNfUzyOc8YMAfxCj058B5bM770Zw3/N/LqkgNV1rBJyCjmUdWwQ0kIDgo0Ou1kAHNUbwJG6Hr5FClRa1n6Ng96VTd+zg2IFHmwu0NnIJFl3zDJg5Y4fuOH1V68f7dTYUq9LJfNFXrB8qY0MgVPkQkymBqDA6jyh/31WqbIHlegnaAbXFi7HwgpWwTMQoFikuYLRMal3PrWUZBhl19uepxapGcmYQ1kmmwDiL/oM1yodzQrwQUmOQ1LOBPfHH6SG1mB0Aroncv9dRUkGUZXbn1FDdI5dAoEfcRuZTIKVFwH1Y8aQch1kLUYhKNGYG97KmVDeaoDg3b0I32wx2XTYv6epmQuopHIqIy7eAUfsutY2Zx/i3cKvc4oDSh+hIL1aegj6+/EAEynQcH7OLLYoM21BkCoGVeS4VKmM020Rz3UVtRZ2qQFMd1xo8AKLx5trvH8zWOqy3txL8iNfQJjzCrTPDq5cVyhIFzVVVqFgvqGV+5kh2bxGDnxFh91dUiYlidIEg3qEKCMKxyYFngixqaNuv5tmEyjWzHUx96AcDRZzZa5lV+6budIS76HNf74U/2FRbtQJnsOfk6Q7a68
 P3IXnK5b
 wtXgC6HGzWpatthEE762zuNXmkGzLpl7TL9MaB1zBcQ+MTuVWfAt3/7wLmNtz9VLiPlYo7CuqAFNAQAmDC5hINpsDzof51O4IJeRNjeEy8d+/w832jXKmNaUlBAuyB61zDph7o+/wlTWHip5GebrDgzWbL4k7o49zhkViGzj7bfnkHond6PjnxNxOhSdmnfPa/U0GRESXjLbHHG5r/L43ji/orVdg9vYTnLqwkYNYzL7jC6u6yljI3zujxoNInEEHy3CxDB00CR/x0gCj3Bz9HADthtUYlSkpawj0eRhcqxNGcUGlb7Nr+53eeRoBHfBTvzjOvJYie6IPDC6Gstf6gKqMO8HHqkrl3cYtHrFPGSD8b7po26TozulB3p0u4XpuBXNaEfxXbFfkrZobu9SUBoSjXTRTMobwpHy1nel/Be7qVBc5Y/wUevj0or9dJjiE3Y73gt7x2lQJ+9qquTrc6WOU05zx1teRpp2QvzZ5Xous5XV1Q6ge5zyU9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22 Oct 2025, at 16:47, Zi Yan wrote:

> On 21 Oct 2025, at 23:35, Zi Yan wrote:
>
>> Hi all,
>>
>> This patchset is a follow-up of "[PATCH v3] mm/huge_memory: do not cha=
nge
>> split_huge_page*() target order silently."[1]. It improves how memory
>> failure code handles large block size(LBS) folios with
>> min_order_for_split() > 0. By splitting a large folio containing HW
>> poisoned pages to min_order_for_split(), the after-split folios withou=
t
>> HW poisoned pages could be freed for reuse. To achieve this, folio spl=
it
>> code needs to set has_hwpoisoned on after-split folios containing HW
>> poisoned pages.
>>
>> This patchset includes:
>> 1. A patch sets has_hwpoisoned on the right after-split folios after
>>    scanning all pages in the folios,
>
> Based on the discussion with David[1], this patch will be sent separate=
ly

this patch is Patch 1.

> as a hotfix. The remaining patches will be sent out after Patch 1 is pi=
cked
> up. Please note that I will address David's feedback in the new version=
 of
> Patch 1. Sorry for the inconvenience.
>
> [1] https://lore.kernel.org/all/d3d05898-5530-4990-9d61-8268bd483765@re=
dhat.com/
>
>> 2. A patch adds split_huge_page_to_order(),
>> 3. Patch 2 and Patch 3 of "[PATCH v2 0/3] Do not change split folio ta=
rget
>>    order"[2],
>>
>> This patchset is based on mm-new.
>>
>> Changelog
>> =3D=3D=3D
>> From V2[2]:
>> 1. Patch 1 is sent separately as a hotfix[1].
>> 2. set has_hwpoisoned on after-split folios if any contains HW poisone=
d
>>    pages.
>> 3. added split_huge_page_to_order().
>> 4. added a missing newline after variable decalaration.
>> 5. added /* release=3D */ to try_to_split_thp_page().
>> 6. restructured try_to_split_thp_page() in memory_failure().
>> 7. fixed a typo.
>> 8. clarified the comment in soft_offline_in_use_page().
>>
>>
>> Link: https://lore.kernel.org/all/20251017013630.139907-1-ziy@nvidia.c=
om/ [1]
>> Link: https://lore.kernel.org/all/20251016033452.125479-1-ziy@nvidia.c=
om/ [2]
>>
>> Zi Yan (4):
>>   mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split to >0=

>>     order
>>   mm/huge_memory: add split_huge_page_to_order()
>>   mm/memory-failure: improve large block size folio handling.
>>   mm/huge_memory: fix kernel-doc comments for folio_split() and relate=
d.
>>
>>  include/linux/huge_mm.h | 22 ++++++++++++-----
>>  mm/huge_memory.c        | 55 ++++++++++++++++++++++++++++++----------=
-
>>  mm/memory-failure.c     | 30 +++++++++++++++++++---
>>  3 files changed, 82 insertions(+), 25 deletions(-)
>>
>> -- =

>> 2.51.0
>
>
> --
> Best Regards,
> Yan, Zi


--
Best Regards,
Yan, Zi

