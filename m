Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D8DC83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 14:04:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A91EC6B0089; Tue, 29 Jul 2025 10:04:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3BF26B008C; Tue, 29 Jul 2025 10:04:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9035E6B0092; Tue, 29 Jul 2025 10:04:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F32F6B0089
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 10:04:02 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3D879B5A69
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 14:04:02 +0000 (UTC)
X-FDA: 83717471124.17.CF497EA
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2051.outbound.protection.outlook.com [40.107.93.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5E8B41C0026
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 14:03:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MJGL0LYX;
	spf=pass (imf20.hostedemail.com: domain of jgg@nvidia.com designates 40.107.93.51 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753797839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u5lfGgoFWb4/4+iV9JZkuHXLSYAa/T+6htV4L/MoZs8=;
	b=otSRa3zHSqnXXBpkZWVjkK8LbHszsAeMxJhLze/N1zXtwiuEppGMnqIQ/8ULIdVN2P84Uy
	6fxD+K2HDnPA00+ViQUYhtCNF/VjxFY3c8YE2/7pFqnA1+TJ0EsNOPY0Dx473ZKhAej7HH
	ZpP8tIo6IvStvFOGBBC02kTqXVdyQxE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753797839; a=rsa-sha256;
	cv=pass;
	b=qpHBel0I8zH2qPEyiTLopNquGksMJryYlc2PhHWZUAfs8YvKD7E5jWo6LHA/7pdkuQxt6Z
	BAVKK0nwsNu7EeAO8tB65FIlqYCNY0736ctO2f1R1h+atTHOzIvn4nLjG14ZwkQ88+IjsN
	A9OrkQrzx007jIMfNgk4BqKS5BPYYYw=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MJGL0LYX;
	spf=pass (imf20.hostedemail.com: domain of jgg@nvidia.com designates 40.107.93.51 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q286QejTJDIXHFapfkibLNE4d0vW5g+yEXNtM7EoPxHznM6tdcrfV9yTmGPv8bbk5J90mOjfiEkTqlc88pslH1zmCXHlDwXhGdyaxL87Tf8LLCSIu/h8tqLRx9Y5hq86j5TCRSky2h+3HmvgHvQ12HSs6bKDlIhkogwMuryL4wuyGQ0lcFPNpWaaFPF/IF4Qlz+6u0zXtKes5XWtVo2YMe5aaJk8P+Fn+WF65S8kTmPD3I8O0vQp1LqMOE5RpO30vs6N04n2gpZJDrvK0Pf5+x+lNciEZDMpY0Q7+wf+MhNEbee9J8vD7z4ZgiVqYvZCDQokvuZtP+TJmJqYCKhQRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u5lfGgoFWb4/4+iV9JZkuHXLSYAa/T+6htV4L/MoZs8=;
 b=Jpx1eV21ynmpqWNsWbpKm3/qanQ1OiPnbRMUrrIBFhZMjMt0tdV4uqFmdzzs0cTqKeTlUfhT0Nqp0B9B1Ep0hBXyi6YdUdgzheZSQuPus2n/m4Sko18LYJqqMGS0GwLju4/jUTcbZq9mRTGvyOECzo+67EE9cN76SS2k77Adp3wwzyvnwhDFR0tATgr9aXSiB+yzrpkgzuS+2HaHlnn7OGpiafrgwHal86f9uPytR37aa4WJbCgHTKY4xPhCjRSIsTlBwPNwRA4SBiBP8rM9QgpBy+vW65pbhk1MCjxtBqL7iyid2UzcOvuInJirgXlx716iwwVxaYEOrCty7/SGQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u5lfGgoFWb4/4+iV9JZkuHXLSYAa/T+6htV4L/MoZs8=;
 b=MJGL0LYXiYI1W+QNgkFkOYcm2ik4hCNRzFRQXflSgzV9S5hVwPZkggteDh0oMatx00Um4H3FtoHu0rOtr6+zUtpqq4sSB5s5ONTH/nZ5j7jYSu1/RLDPbrdIK7G0J+6g5PsaQ2S+Pe49/KPDSiQz9cthnPZ6ss/PvIgoYltJEH7vrxgj6/TBfRJYmkpAZdvgbe/AAkTyv2/f2Cm82Rr4H5CGvuvgBgWhc4UIlLniKxJMmrZ3dqbWKDVtkv6pV4Y+5pnqbp7Riw17eEThCfuFBcjb1Y1d7PwG1fzrMy9aBj/AXZh02QDfSbDUkZXC0dZsyPNXmsrBvgoq/NLdeId1+w==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CYYPR12MB8923.namprd12.prod.outlook.com (2603:10b6:930:bc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.24; Tue, 29 Jul
 2025 14:03:56 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8964.024; Tue, 29 Jul 2025
 14:03:56 +0000
Date: Tue, 29 Jul 2025 11:03:55 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Christoph Hellwig <hch@lst.de>, Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, iommu@lists.linux.dev,
	virtualization@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/8] dma-mapping: migrate to physical address-based API
Message-ID: <20250729140355.GA72736@nvidia.com>
References: <cover.1750854543.git.leon@kernel.org>
 <751e7ece-8640-4653-b308-96da6731b8e7@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <751e7ece-8640-4653-b308-96da6731b8e7@arm.com>
X-ClientProxiedBy: MN2PR07CA0013.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::23) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CYYPR12MB8923:EE_
X-MS-Office365-Filtering-Correlation-Id: 321d8f59-e99e-409a-58ef-08ddcea8c21a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gBJ85slrc/H3Axac9i3cCda2aAxYQWMhciU4YT1ZSRIY3Kfj1odW5Uu/4uzZ?=
 =?us-ascii?Q?Th2nB+KKROUt3u6rz9IdwrR8/TMjCbN7YpyDFFLPyJUIALGgkA2WF7SCM8BD?=
 =?us-ascii?Q?N0j69f9ROq7UIhu1/5nfiyfke3rPQPVXm8RfwqcuZlQnbVRk8p4RUftoXwyR?=
 =?us-ascii?Q?IRdn2vASVZCKP3zaRumg1ZGu+r06zmH+q2013BUz01OCKwXVKKy+Hw8UTKOT?=
 =?us-ascii?Q?5Q/V5EJ80NxpqLH+pNIUPoyjORO40+JDgUd57m6Xr19x4x0pE4VQf7ZNc/Na?=
 =?us-ascii?Q?RdNX/bNh7T7QBRFnAPFE3kbetAvuoprNJhUeCgVjz2lCAr+hmo5oKK44/dPq?=
 =?us-ascii?Q?w+Mac16vk5mqZq0uuWaTvTIb5hu0eQ8ZEyYXqheRkategZEeVU4Y/TgvSk1G?=
 =?us-ascii?Q?PJRSItOO9GujEq6dHTURGE+HON9LT4Zu4fn3LNSRcLWMqbjYO/5LnX2clhoh?=
 =?us-ascii?Q?/j72Rj4sxB4f7ewSsdhlQ1EzVk//FhE33XrXRdmRoyX8XX5uRSzGMdz1REZs?=
 =?us-ascii?Q?THdBB3S9L7sl09+ZlZliJNC92nXYvDmWVQbyCELiPUHNZCi5CsdKm47n9Msw?=
 =?us-ascii?Q?mj0DL8V7unmIvsHOU3Rf8L2P7gxvj+7D4OUeae/2EJkdVrkCLW8ctWlCu27p?=
 =?us-ascii?Q?yTjH/vptPB4ZM2ERifpougXel9iCDO5HQKeW5JLXSocGXF0Kpcl9zTn1XyXu?=
 =?us-ascii?Q?0NO3OVL5VsNmVz6LitocZXxZ3GcVfZzX5OmOYeUVTyBLEKxpBMlAAoDQ7AtP?=
 =?us-ascii?Q?88j13QO2n/n7ixeLPN6GqN1Kh6mmstX2inBpDcXkl+RFTO8rTKsMfbafuhq9?=
 =?us-ascii?Q?lZEtQ16IZT1zMpsEB0XyrbAjfwQB72vXkE+7YhssvjGK71tvUwn9fr9UPbIi?=
 =?us-ascii?Q?1wUWlYdrOvqvpw1VOJI2xPvCwwX6+hPqMMRgnH4kDh9+dEm9KQ8x1w01Me8U?=
 =?us-ascii?Q?V5rMVNEPKHNFL6RlxRHmxGl1DQ/o4DihgXMFyLRg7FWNpGx0DkG+BibqBCFM?=
 =?us-ascii?Q?mjlFyK916g/pCunDrYOdDWxw7aJRd1H0dmBxA+lDVARx736rw9tatnN3Y2vL?=
 =?us-ascii?Q?gYc+T2mPFuqQCUeo+nGBItlQIGzdnI+qOdkm8dtrXZETDbT91oeOGpiY6wkH?=
 =?us-ascii?Q?olqsT06as2CZ+gQUhcOuXnmau812h5/MaLQcYcLMnfkitR+D3fx5PY/UR4cw?=
 =?us-ascii?Q?FtOHYqXIjjXmWbmnzTOLsL9fOeYRQP4tNVSVbRuX5mlceZ1yvqhpi2o+zsU4?=
 =?us-ascii?Q?NSjEuQpKmhPUsW+e9gLRVcWU/frzhLhgs64v87vKw2PzijOI8VdxABFtdF9c?=
 =?us-ascii?Q?Gs3xt2UETfVAgTd3/0IDhYjJvOkjUoTRxR+7Mc/1fZDkOZXgjE5zwxBVVuXk?=
 =?us-ascii?Q?FK0aY2bGBnYM8AMsJkl18BySU6wZCFMTEO9bPRke9JJi+e8I9dOmu918iAaK?=
 =?us-ascii?Q?VInu15SYAPQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5a1dp+PcEu42Bl4LnHwXyTw4eSaLO+UzWWWpSfLrouzmGwET7/dbWIljD0mZ?=
 =?us-ascii?Q?CqPH6aXmSdGs4teQg6zaU5brTHgD7e9bNxvGw4qsJvik+a0hHu1CSkmiQrK9?=
 =?us-ascii?Q?dCUqNmWNMgFkWq4iqpZ8fjRZccNQ8/zw0B4j4CFAsDXvOVNnwOaQOoR1Er1i?=
 =?us-ascii?Q?FPnLdXahxGGUjZTAB+bBIyIxTZwLmTEO14tNkBLZafgRuWxrDDpBMVHyASfI?=
 =?us-ascii?Q?POlKLSDszgJ/TKgFiEE/9IUyT0jB0HOQd/jkioQG4gL5omeOGKXGWogZj7kO?=
 =?us-ascii?Q?QHLCRaKAMNEPptNoNC0bWMOzDk6uO+OZnsa3XuBmsWI0LDFCa/g73PhZwPBP?=
 =?us-ascii?Q?6hNCEbwD2z0DaCJnGH2xynjxVPaEPanwjZ351oTP1Wgf+SfkqiSrSQk4DMVC?=
 =?us-ascii?Q?KM76VulrzGW2+TsxyVx3/iSGNBMqWRArlIsJGPZ33EYuXvt4FuzRcB1yLNrt?=
 =?us-ascii?Q?qJAwHrQHCpoVR0VvjJBTxluNh0xUaCfAXy5vN5gQfxM9kqK7sgF18vo8VqFV?=
 =?us-ascii?Q?uPaK3RrMsYzngXpRpbKfv8EC4mGVto+EZNw6ZeFQFGBmZuOMYZ6Uo7nFzccs?=
 =?us-ascii?Q?NDthcpIoL1qEiqrY3rzI3XMatWoo4Xu01JhkZhCH9klsZJ7cWwgThyU/abq/?=
 =?us-ascii?Q?3hbIE5muaIIHLO7stJImcl6trGCdB8ISgJ1aYLredv3xfAmXVtE+1RauvVQp?=
 =?us-ascii?Q?xTMZNTzC3D3+xLl2BJF7/0MNo2d+9giIbsVEK1424l0SjAVCu/EmVPgQfve8?=
 =?us-ascii?Q?IQAIF+7/jJUCSGb5cDtEjWIfp7cBsmoTSpMbvem0oE8qml5a0SHOAIICBYiL?=
 =?us-ascii?Q?HAtZT3KrX6cr/nJrat6mOZfsylmrdwTYtg/aVg7koMsDOFJKQqWoWtOsbxXj?=
 =?us-ascii?Q?ZoPNBykCwjRDfT/ou0WgQI6Ejcisub1huUrGeqDl8carEa98BL0M1X3J3hMP?=
 =?us-ascii?Q?gUyxRYOA5Tw9FpdXhzs9lsC1hXoukq6nusIdFwiJYDVBcbtcgLUJTDMm5zuc?=
 =?us-ascii?Q?r6dzw+LaJaVy5KcJuozT7WyMinjanxiweMzTSsNyu7rbbdSltFwNpAE5Cv0W?=
 =?us-ascii?Q?r+fTNIEguGVqblJwp3NBoxjB+5s16aeB9u+MxVIzvQvdh40YVqSbqYrbSLqy?=
 =?us-ascii?Q?y9Jwm0hymchv6jQXLOInE5Bd6Cq06tuEFKMZIAmg/CamXzQV/KErVsxG1T4S?=
 =?us-ascii?Q?yHdDY6Qm9OCokTOPoLLET3C9HFn/vS0AmM1nlzq0P/9XbtEypa5XbtKzBUIp?=
 =?us-ascii?Q?8aEOprdpGrlK9Ozowi7xn8YKS1ij9Yx1h1hOFs3yAJx82IBVokA4LbZ2sZlp?=
 =?us-ascii?Q?aqI7vFFduGfhaqKFRIYasvPgkRNnj9OGKpnSvWlIsk1/QfIJM30cRl0lc2iQ?=
 =?us-ascii?Q?Id6+TNyaeEMgyxgiNR4rruaLm4i/3CPoqBCEf4ANExLAdfkYUYcRKc3bL9ef?=
 =?us-ascii?Q?02hQHm865f2g36+CMO4vy1lVqUOj6pjOaTeQ3Pq+LRRs2hc60uSoPyulLOXH?=
 =?us-ascii?Q?wAXeNeaesJNf1zN0674/HdTpKrORnwcaj9ypKitSHA1eZ1LkOfW+pUrGHDzL?=
 =?us-ascii?Q?pL70o21MA1cmbIY0/lk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 321d8f59-e99e-409a-58ef-08ddcea8c21a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 14:03:56.5173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yc8LWxbq5e0SbTKy02jNs5Q8GqwjmWV3o9MPp6uCqLldf7/dPEmD7gEtGg23bxk4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8923
X-Rspamd-Queue-Id: 5E8B41C0026
X-Stat-Signature: fegqkk5iy59i78xze5uzdcd6spotbb1q
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753797839-365853
X-HE-Meta: U2FsdGVkX1/Z+qtCi9/2A+WL1gGd3O461uYwNKfRpO38+Kmm6Yh6PmBbenTiBBPpHk9C/BEFwA53jJUI6trtEThRQXYcLsDKj8uKYslIrPa5c803FZkqOHNnreoyVSX05gH55AWxjo62CI00s1yp4qwCXHml/EmCtSu//VnW1X7+luj7igxhfUkdznRuQixZiC91hMMTQUDyAoKwt2yCdogTwdgDR+p/NclkoBNjVJB0XMQlG2BhvtCc9jT9/YcJCWDpEIYIau43zcjatatXR/aUKm2xjTyxzfqbzPrCfF9cR+WGbmZi4coxFoOQQni1NB+cyhF4wNcP7Fa7UIScMbrXkAX+B3OMB2ubjdGFxcjvGkCWErwu62r4+NIdFyUJL7Aw8fCDbgMJqgsrncNb2OD/w/OMzZUHBFFT6RvbOi/phUKaszPc+cv33P3nff7tMm6t7ulEjC1lna37GD3k+yHYFuxs5vH8TRMnUOaTEd3Oz1Czv07EXUbZOwRUxyUbI/S1W1SxYQ+QpAbNVQ4k/vz8pTXVs501JmySrAfvMpH9aSwOrF6Ecmao3ArsjmcICRUrDm1UMkNOcfDshrcVKQNsupj5N6eHTuVjODA0iSOA1+fagr7/Ss/SD5xcaBtjde2PlwKzZ8YARozulg/9aKzFHa8KtF3bIiGFrb//oPDuQ4nijSqCItgTexi7xw6x8YLlxqz046uolXsWc2MaFufYI0htH4pPje+WrkbJpFQx1OuYH6QZ53Gd8FinejTouzG1yfBIWXYCgHZl4J6ESuaKwDKZGSHdxDck16eGaQ0QXpCAOZHd7nrXgnLwhPpN5EFKIrM45BxnnR7CjpNmHf2uNResQ9/4KRaUt5NZ2fcCjP8TV/P8rJo9aPaQTBX521BrwqJFFnX1cdjEpWwY8ITNown8Ux3QZ/W0X5HuoJQGvNO+i8IgfSesEvsP4n8Jvq0h2DJpXkjdPwsuQj8
 sPOXuwEm
 UdfoGtFR1Snz9StpDw8J+s9NbqqjW2Ypqf5sVm//dkOtq9v4NfYQugnoMTLQIab3/gozre45I6TjFCrudHvJRV2ype8o+sPsih5sWuEbbUB1voW7/83p9BjxqB+euivvWgeVMrX6/26IIR4BuRB5sq9I8TwgGjTp0QeghO6FeCIoAII1s/33vynMP73CouTsiHS66nRMfOk33JI/eSiFDL7JePAuXqHZVLekfWe8/YAL+DQKqFGa50n/m/ocQg0Lid0GQQdcqiwpfz0NrVXKPeD8eO5bQA9UkAI5k2YuwDYd7/RpNpZPAxkk0XfgawsbJqb5VfdXIS7e1sAgds4zeRuPbWwke8klGnZlwAoqsOQwoaHfjGuWVbZDL51TaK6eViQz/nFUpqdDjISyLb8GWBW39PQX7KEnYC1L3vk+9YtYivyNDHZ1DPjnPh4nmF1aqT3Ayxa5HjGFbj9vyiPq54s3lcF4gnH7YGGZ5gqvEuk37iEsq28kKarTOMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 09:05:46PM +0100, Robin Murphy wrote:

> But given what we do already know of from decades of experience, obvious
> question: For the tiny minority of users who know full well when they're
> dealing with a non-page-backed physical address, what's wrong with using
> dma_map_resource?

I was also pushing for this, that we would have two seperate paths:

- the phys_addr was guarenteed to have a KVA (and today also struct page)
- the phys_addr is non-cachable and no KVA may exist

This is basically already the distinction today between map resource
and map page.

The caller would have to look at what it is trying to map, do the P2P
evaluation and then call the cachable phys or resource path(s).

Leon, I think you should revive the work you had along these lines. It
would address my concerns with the dma_ops changes too. I continue to
think we should not push non-cachable, non-KVA MMIO down the map_page
ops, those should use the map_resource op.

> Does it make sense to try to consolidate our p2p infrastructure so
> dma_map_resource() could return bus addresses where appropriate?

For some users but not entirely :( The sg path for P2P relies on
storing information inside the scatterlist so unmap knows what to do.

Changing map_resource to return a similar flag and then having drivers
somehow store that flag and give it back to unmap is not a trivial
change. It would be a good API for simple drivers, and I think we
could build such a helper calling through the new flow. But places
like DMABUF that have more complex lists will not like it.

For them we've been following the approach of BIO where the
driver/subystem will maintain a mapping list and be aware of when the
P2P information is changing. Then it has to do different map/unmap
sequences based on its own existing tracking.

I view this as all very low level infrastructure, I'm really hoping we
can get an agreement with Chritain and build a scatterlist replacement
for DMABUF that encapsulates all this away from drivers like BIO does
for block.

But we can't start that until we have a DMA API working fully for
non-struct page P2P memory. That is being driven by this series and
the VFIO DMABUF implementation on top of it.

> Are we trying to remove struct page from the kernel altogether? 

Yes, it is a very long term project being pushed along with the
folios, memdesc conversion and so forth. It is huge, with many
aspects, but we can start to reasonably work on parts of them
independently.

A mid-term dream is to be able to go from pin_user_pages() -> DMA
without drivers needing to touch struct page at all. 

This is a huge project on its own, and we are progressing it slowly
"bottom up" by allowing phys_addr_t in the DMA API then we can build
more infrastructure for subsystems to be struct-page free, culminating
in some pin_user_phyr() and phys_addr_t bio_vec someday.

Certainly a big part of this series is influenced by requirements to
advance pin_user_pages() -> DMA, while the other part is about
allowing P2P to work using phys_addr_t without struct page.

Jason

