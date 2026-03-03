Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C853EC1421
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 12:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C30126B0092; Tue,  3 Mar 2026 07:45:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDDFB6B00B1; Tue,  3 Mar 2026 07:45:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE1D86B00B4; Tue,  3 Mar 2026 07:45:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3656B0092
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:45:43 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4D4A85641D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 12:45:43 +0000 (UTC)
X-FDA: 84504723366.12.B272AD9
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013065.outbound.protection.outlook.com [40.93.196.65])
	by imf10.hostedemail.com (Postfix) with ESMTP id 802B8C0004
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 12:45:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Az/ekstt";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of jgg@nvidia.com designates 40.93.196.65 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772541940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b0+EyePJigODkQCX0fGeJySIjStyI5vrn7wuW0Uzxuk=;
	b=KVFs9hsNKKwtvUJ6ssindfWmiBpscf9NhbcrsIwB91FtjQxzb+nxFYSDQp4t6rbsmWBKt0
	myxuUhEviiK/9YkXQwz+c2egqoU5t7ubZmml2SL+qSP1BM458NgHB3G0OGi7t2i6a5+ZmD
	ek+yx8BH9jxSGRmvUm1uvMlf7z7MqIo=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Az/ekstt";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of jgg@nvidia.com designates 40.93.196.65 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772541940; a=rsa-sha256;
	cv=pass;
	b=bbrg91mFgD7bo8CuXgj2Bpar35/6hGDfQR+qdP7UMrT4o7OSSt3NikfIzbWn01KdvJ/1V8
	eCWJyXXo8qT3/X8vuyti6eqwnY1GYiuPsOiViGC2EXcc1TEHBzm4mspG/4KCHWvZx7wl/o
	T8I0PcPJpt4FvUfAhgRNETO9JlPi+14=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=heqh0n7uV51CYE4xQwwKpAU252aNQcXrXulVsBCAyV1mA1Cw29XoDkyu8pVCKVRAFP8SOcVNvdEyrwxhRS/H5ReGQsj4CVlT4Z/Lk7cpN6WQRWdhy+BKiswGbe7n3yDPINji3IiXdlLkoMHbaNP+kX1xxE65quXzp/ofrZGl17t/ddnwGOoBNHR0huxIIeKyR7e95o8bHe5OC1CqFf1aYi+U8jLyA2I018N7kS8cZBstvR5edvQ6uYO99+nDpLKyjnkA+Gbmc4vcAFfB4HOGWmuQcTSN5tNhSfJ2q5CHbIPQkzqaaEuU9IBqVEgiId3b5At/a2Ar7f2ypmTcqZkJQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b0+EyePJigODkQCX0fGeJySIjStyI5vrn7wuW0Uzxuk=;
 b=TeUtbclmynPSF/aGOYPIVLEg0uNtK8D9iYr+A362wl0zwfakMdk8uWfNqTKCJ5U7GTHDfvclvINPDg0T837OH16KXpV+B7dch5zBCA26ZICWZ7VEN35VUbTlUmuzTFLyyt9dZcZbLoUPp7FvRC7J/F864KQrAZUsxbnrLcc2ZCF/xQI4sim8m18/HcWHdwK/RcPu4wgA+Wv7C/jTlPuZxxfglEpdxxdm+FAKyF7E8MEgNgmbqZpG2xl4SH2jmeZsoMNXFQtHyPPlO47EKh5AHPrKLeDNfwWGoKFNh3rTGSL/2oBFJRV0M/Vw9xYDqE466XgtC73huaDPuUzo1qqJig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b0+EyePJigODkQCX0fGeJySIjStyI5vrn7wuW0Uzxuk=;
 b=Az/eksttVohjSIo5OA5EE6gGXDh0I0tpQxKJQMgTtlPrEO9UjdulY6DmB8pFbJ/fiOLPgYz5tqSmlnPMtcGHgtBcS/ze2mFHhh/OUHGuKx3F1rizqyrpoCBRwsfOZOFvst5By3ewGosLqzaA04+We15heAsNuaocbBYR3FAxB8lVEyy6ZubqewoywWd4+LpE0YowG0YtqdM0UgSI5SvoRepKuUJJDtWd7knkPFVGsYdqveZKVNNDK/CQOVy6FlMs29HEHXUq0eYQMdtJ6/ebBX0FBZp1r1ORMW42TjCkdHSVGvDOI/+0tPUkvWRvfCVY6ul1JfxZu4eW9cJ0oSMZsw==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA1PR12MB7271.namprd12.prod.outlook.com (2603:10b6:806:2b8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Tue, 3 Mar
 2026 12:45:34 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.022; Tue, 3 Mar 2026
 12:45:34 +0000
Date: Tue, 3 Mar 2026 08:45:33 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: James Houghton <jthoughton@google.com>
Cc: Piotr Jaroszynski <pjaroszynski@nvidia.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Breno Leitao <leitao@debian.org>, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: contpte: fix set_access_flags() no-op check for
 SMMU/ATS faults
Message-ID: <20260303124533.GA972761@nvidia.com>
References: <20260303063751.2531716-1-pjaroszynski@nvidia.com>
 <CADrL8HXaTz-TS9rYiQkZ6NoRWhHm0t4Tv0t=TtDXS4purLnDJg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADrL8HXaTz-TS9rYiQkZ6NoRWhHm0t4Tv0t=TtDXS4purLnDJg@mail.gmail.com>
X-ClientProxiedBy: BL1P223CA0044.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:5b6::17) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA1PR12MB7271:EE_
X-MS-Office365-Filtering-Correlation-Id: c543519c-bc9d-411a-aad8-08de7922c2f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	tRx0n676EuXLC/NbCyBMEKl51emlF1LR/AAwcGVLl0egtzwca/EbWq0LU89OmZGhWb9XjBTA0Zv/nuPDyzwAZCK9zPLRUxgt1kYXTXPO0wgFVS9zgcWpYwJbSuzzCcZjdbzYuTq66GVpqnIB6aVRYLgCrex9oHkpX5kUDvImwVqiNgKvCeVQ0GME4t1TnFBz5po+Skm+S4ZK0ujDHdoSap3o3eXJHhdTdih6unEaHUXQ+AY+IWoPLlALivOsWyIew2cvRKHv31kEkf75qfG+eJ+Ty93vxGs7zed5nQHtyoXVNsQlP4jrr602NFO/TV3pO8rB9RA1lBsjPuaTfRrkXb5Lj7HSTvlKLuOY13UI02E9FboSFIxwEKylYFkwhQjVQfNNH4siLc/eMv9D24nrgNZjxEcQYfWPnfhbYQs+nswtQjGnYpQqvSALNZLM5u/aUWYd8Q/3EFi7jEtz36eodf/AGi9cRtP2ZPQlAgp4iFiB2iNCOf0VWp447m4AehCghlhjDqD2DZEf0xdIsv6zsPKe19Oo/wo7EEHq+SP5F5z3N8RMzyyCIw5wxOIpg1xL2FSilbiI9igXqJ8aZYnwewMOkNHjuaadI18CGiYuL24EBhOId1a+yzj87p/zqNSw73ivKA3WxBVCo3NkPsOFGTnIbvy6FtlHKJKpsYSdeuKq8KGv8DWAuCQ9/vLkRWPMiBsXIhOXgHGAQFrpdGt/7ILWE7X6tmYOK5zoi1uJTWs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Zw906pUMEcMxm0DMnLPRCWicrl2r/TItvInbdoE8rlO+FAVIVa3axc0WYI/4?=
 =?us-ascii?Q?tvNlIG9PuafM8Y+hIv7AW/x7vtVIeuS/WpyzCYqCvhRGjwl8u0NIcDwoGB26?=
 =?us-ascii?Q?gH3tpmryLOiYZk+VBG0w2DzhHYP2TUNuMQK/NL6bE2Q4qLR1DTHuEl25QMm6?=
 =?us-ascii?Q?W55KDv7LMTxPCINqHfH2j/f7nP8H4ZLSW6uatSM1d1hOi3HDE9XRBKYTg3ap?=
 =?us-ascii?Q?mCGQqVPU+N19RJ5izbSHyaoE+9ioas9jKV4bDVyiilQ6R2+70Qnxz1CmBIan?=
 =?us-ascii?Q?j4djIJFcmK1hirslSNy3e1MMIEuHjzmI26tL+cbuhIViBWtm1ZhL+QNybpwm?=
 =?us-ascii?Q?XJVl6AV763LUHf9NyWHnFbz5bB9MN4g7T2jJf4S7zF5DgGeqW2c/3AL04JJT?=
 =?us-ascii?Q?uC/oRPdEfEZ7EDPYWu2QZnLoLrqHTeovpWiB+GCbiQrYWRLYjWRkesKO4+fR?=
 =?us-ascii?Q?3VAqGIiimltU/shwbz2HqdK/qGe5B9A0m7rqYLU8xefeMkvGUv4rh/h985b4?=
 =?us-ascii?Q?frlSmKtTHDhMZUFkpxRjeFvkDov/+KeLYnhvutT0BeN1YFlBoXFMDHe6EclM?=
 =?us-ascii?Q?OUv+L/aJJDBb6+hWOVzEp4oErRHSt4riRoV7HlFF8FS1Fb3buYaaYZdtqVoz?=
 =?us-ascii?Q?OVEZDbmsi4vEzSLZCKhDqEHiOBHwcKaG3NscQHAHLYgQqkOFzSOjn6YiyzJw?=
 =?us-ascii?Q?CozcwmAhLJNRixgTCAQAt0D9mVE2zJ8kYhJYMMv/9MJiDotCLikRlmkUD0sH?=
 =?us-ascii?Q?TZip4/lafo09bdvN/ZGAmtQCSEc015oYMp9sLlCbfgtNJYW8lH58U/vrNcWu?=
 =?us-ascii?Q?GoSl76CHcVePSQTSLJSPOwlkoo9XNNThL7kgFJjuJGNR2pnEsbaYav+WP5ld?=
 =?us-ascii?Q?aJiV5S9tAUZ4Zmq7m0TCGqiscjvBD5+Rf7Q3WqRfvNtn5MiDQD3tkqJ3+T/q?=
 =?us-ascii?Q?G41mxYgEDQQ0GRTjAq7FeDVmP0P746m+MNTzn6r/v0WA7zLg3r5N09QneMaZ?=
 =?us-ascii?Q?XNvGlAVr3mOmMPSsmTuOhwptCaFd69rR96L7GQG1X5qkxqAzGv5Wwqb7z8TP?=
 =?us-ascii?Q?ZbP0aCPoNuRK5o0jo6BywVfCoLCEPxkwee4fM62XUgOt3sXeeozj0Yv6qYKs?=
 =?us-ascii?Q?LTHbQ3BVR55GiYdiEDAOaZCNVQRMq+okCuzctJJFuaP2IDPAQP3cZ96rQ4cj?=
 =?us-ascii?Q?gvLKozcdCRIhsMNDth0CpnZJPnOPuYc3AxX1dla3/V39xXHFSYVLKxxx94ch?=
 =?us-ascii?Q?yaf0IZtyX2ed+iIJLKZCjGppxWjY8S4gASnZOrmwNX8HSK27Uaux6hdUs/GZ?=
 =?us-ascii?Q?8ZsgBxGUEKISBNr7uk83h5+NG+d7H9L20FItc+k1wJfcpr0plZe9Ge+DJOcH?=
 =?us-ascii?Q?tBf7Zqw268KmixAcT6VZxB/x78hMwZR5JgW3y0g27aQtNUuFZVVn1gHUx0Gt?=
 =?us-ascii?Q?XMy5ksYePbqofqEXFbVbGYBysf/B5HSO8zE6LKbVsJ59r9HmPHlJk/xHiTYZ?=
 =?us-ascii?Q?YTxDnGucCoYO8Fmg8myvqludGsipsROLdRt/0a4rc9KooRF0PoC2NseS73LL?=
 =?us-ascii?Q?NUdRC+nd9YjrMI+bTAVJqDz4TiER7I7yyuHRnbJr+Z48/AKe4p4IHJqEjCCf?=
 =?us-ascii?Q?YrWrq4EuPZ3iganDgr27RY53al1641dTEYWbSZhb3DCmvyitGAfTruUx0/4g?=
 =?us-ascii?Q?tWfXWvk3tkrLSRzQqRLEMWG8JlkWFWDfGzYtcxKN24u2McL6sBxZG5bh7kwP?=
 =?us-ascii?Q?0Q/4XVVzwQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c543519c-bc9d-411a-aad8-08de7922c2f0
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 12:45:34.1200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jkDQhm+eNDHeEoaBDNe26YFIr3SDrQZqRJP3E/T3vcWtelmz/VrGnAerPMRBMC3B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7271
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 802B8C0004
X-Stat-Signature: 9bmkyt3tznn834x53ufkut5gfg9d9n9s
X-Rspam-User: 
X-HE-Tag: 1772541940-64373
X-HE-Meta: U2FsdGVkX18iUCb/NEX49BD+/+vDUIg78Aj85F2FlJ1PcXROonZHQzDJGdzVxSoIdA1HbZVH+skRUxwrg7qpdFOIQXAgjsNLsFgjJyFGDWNCx7FpM6oias4zr/NacCJrQu3o518h+mXPqtyKqPw8ytAPqAq/SQHCIu6/QWQRPcolVEHjgqfI7ShiPSYQctcbaTPAmDwGTqC5YwN4iBKgfQT6xDu2/kjpwKZ2RlfpALW+UQGFZNzcJSYQ0VHEz8BJ9S2eklUP8BZH7OAdAsy+ha/c8sz4T6MK1haRhyG2Z4ocEuXpImKXfC8xMTf6Uoy+JQDZ7gB6ATbZfs160vLdKmsbJ7bGCDGCXaKQa5JHU0hzZ5UQYtU1b6i1yFtpfm8VDU5vK6W4OvrbgasefRTXbcM39pAr+OUwvonYsD2NdymqcovZfD1Km34wU3jnw9U/rwJg8folQzaXn5giyoLqPo5qf49j6Zom8xqw8m43UXmPJX495twsiFs/FTs6ZTaHHHf3n0ea2Ro9ZpncHEc/xUf77ybyRNbnc/tzkkMjoDlIKU9zC+wg0F0qCeMKMWz+Pgb1MISpd3iiO7aWgEkPc2A3qZJUQXcjlw3+U7AO7By45g69bOrbqrUB4V9htz1u1+rMv4Xo3VqjNaJrAM+rXrORtvTjTYgSDrjE3n2XhnGONE85HutJQNONi1Y7P66VQExW9k75ZtFGII7NViDgFOebhEBgwZ6I9yN+oKioHtksTXjJy6c+0vCEj//I6Dmi2vRB/vFYpaJ5zRPRAffG8d+aZ6AoobTNUxXEYxgh3fNEKkkZesIzQHUn729dpCtfJDxM0k35MH07HTVSaD4+rwqZ1wIw4T3t98rELF/XCSmYeC7H/9f0iUY9CbTSavNb43F1bJUGsnYlr8T2fd/OpliaUy9/Braco+RmdHESMXBw+UW5H7UjWPoeyMAdNL58LOFVmHr5a3b1R7ZvPK6
 /XbuIR3J
 PLm+3HFE3PdnvRqjg1wqyqV5h9tRU5OcvZpW9VDsXME0G/9gYC4CldTNaHkEw0YstV4tn/HpTvenms5QANeI4kEghti9tJxUOKJcMueJ5LQaGVW1BYZ4iYJUZyZ11MmVfPXGzJXbq3KNKx0SsX2aJzjBlWsSGBgBi6ez8RG6Cvo8JmBPdvhTYh/jvYG4XUI3yBjqDuTDtIOxswL/8RhUQDcxlRBtO00ww2dEreFxsnqM1sR3x9SL3ccn2Bw4SmQ5/FHt9ddvtmEfjQQkheARxleouXrMrTaqHG6Cz0eJXY951uKcrRuKOZepOZWnmdSGlPCxVbN7+7gWO8vMikVy3GWHQgXq6gD6t06KSiSGk8a7YjAWXoFB38BRgSWonDcZWAN60Mj2AE9gjY8v84MsjkG0Is4IkWFw2Sf99vyITXquGyMKqSWLIjzu6NxmghGa///j1/KvLbyMmxM0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 11:19:46PM -0800, James Houghton wrote:

> This is similar (sort of) to a HugeTLB page fault loop I stumbled upon
> a while ago[1]. (I wonder if there have been more cases like this.)

We spent some time here looking at what the ARM spec requires, and
what kinds of HW implementations are possible..

I think the consensus is that SW must never write individual CONT PTEs
that are different from each other.

For example, a possible HW implementation could fetch a cache line of
PTEs, see the CONT bit at the VA's PTE, and then always select the
first PTE in the cache line to load the TLB.

Alternatively HW could just always load the PTE from the VA that is
faulting.

Since ARM ARM doesn't restrict this, SW must assume both possibilities
and that means it must synchronize all PTEs since it cannot predict
which PTE will be loaded by HW.

DBM will only write to a single PTE, which means HW can create
inconsistent PTEs. However if SW is fixing a fault, especially for
different walker IP (SMMU vs CPU), then it must restore the
synchronization since the PTE selection of one walker may not be
compatible with the HW update of the other.

Thus, I think any place where SW is creating inconsistent PTEs, or
leaving PTEs inconsistent after a fault is a bug.. We found a Rule
statement that seemed to require this as well.

Jason

