Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A844CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 02:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7981D8E000D; Thu,  6 Nov 2025 21:07:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 770AD8E0002; Thu,  6 Nov 2025 21:07:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65EDB8E000D; Thu,  6 Nov 2025 21:07:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5714C8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:07:33 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F08AD58601
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:07:32 +0000 (UTC)
X-FDA: 84082174344.09.A30A3BE
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013011.outbound.protection.outlook.com [40.107.201.11])
	by imf02.hostedemail.com (Postfix) with ESMTP id 47C178000F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:07:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EYpYJMRl;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762481250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EmPmKSZ4DPusGz3sLQaULfunEGnFPLIFLBCCp/NCZX0=;
	b=cCKqCZUSM7z/aHzusWE0XRI4SPZiGt01lfFaMfcA48xzvqabU+xkgq/Ak9NUPZUD55JShs
	Q/CZMj0HVb7SzEJ3T9WA+gI/LppAzX91jdgasL0GTW/xrVt3g4gteVBRz00lzeJxK3M5ff
	rSYuIcr1EgSLO+m8dmGmEVGSICI23SI=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EYpYJMRl;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762481250; a=rsa-sha256;
	cv=pass;
	b=Wui3qm4wjkIBIDWpN2UkRgs92qrwt4x3HGFrzYNsVhG9HFvxoKNqTd9XgktPXB48TavwmD
	pqHii18ylqcGd9IeQGl+euh9WNTT/ji1sBAUUfP0o8Ij0BYTVmxamP+sHmLCJAQ7ss8Zg7
	LQl5UFyTZY4ERw0MFxto+4o9sGTjTZs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f44xzA27HRGnWaW5agqRszXOpJq69tmQyRSPiaN4EG1heCQTlf37oe5EtkcgiqCsAyEAxqwqp/zdYD3ou+mKVTADoDlRg198Lm938yGDwX4xSjxpV5SWIY2BshrNptqC0uMNsN0o5fxbAY5eQwsGx1njGjz7M6qlo7dj/EwVpIqWmnzOH2Wv/aZTny7dm1qmzh88VtxNE8j/zD/I9Sqqi9koMbMrsu01gw0yyP6yhRM2C/6fgf02UE+NGu+47kXuiUI6P+erYye5z9UueQ0Qc2IXImyl30Vj1cxaZZBm01sVFzUj3JXtc+Kwp1dOv/DXbqOxmwYH2XkHr7i9W6Z0rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EmPmKSZ4DPusGz3sLQaULfunEGnFPLIFLBCCp/NCZX0=;
 b=R3l66GNsglcZ45lu7nfbkUMuaC6QDP2B0f7T5+xqWOJNjY2blHaVTAAws2L7ry5ytodCadDipQ2LCLHAC2SYUe9nGIyeNXS76QnVoHeBmgfzN6u05gV7up1IpG1UIhRHzZLTuqWXzOamOW2pe5JsPSDnHIoTQN1DBa2HJNNWPLGtO+myfdhgTccmEKywHR00hV4CkzWGxylTAl0rPFq9eBu3CttctaM7Cei+51Gj3/i7Ch7bj0kn4HiRMUlaPKVrWx5V/isz6eKa7KgGhJrkW3J7THXga9STHQnM8hDawxdLTOcGO9TfWSctfbqJ/Tu3BfI9zEGdLsGij/RDeSnSlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EmPmKSZ4DPusGz3sLQaULfunEGnFPLIFLBCCp/NCZX0=;
 b=EYpYJMRlELzeHuP3wE6UbVhlacFRxzj7XcDSbs6mRZp2ecUxqdnYqT+k0rw+2OaN9OOPsBuTWFRMrPhAcDolCCroEbg0rl1UOvwN5WaLEz1edc9f+4kmnv/8bZ0DLnwEuwvIosDVOLN+IPJ7uG6qxMPXa0G2vtwPkPEdjGJTkJDGVK+efItyrKBW5SWDx97N/7aaNAjO35W4iGa/qdopQpHRgaYn50PmguiGtZz1GjZYg3l4QaTQosDdyUQstbVIOzwMDUP1McnUHtSGSx2GVzjqHcMDvll0WEPdje21vS37zng929MgY/xTkLIqT9HHFndhFJQmHg1Azye8EmavMw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB7154.namprd12.prod.outlook.com (2603:10b6:806:2a5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Fri, 7 Nov
 2025 02:07:24 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 02:07:24 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Date: Thu, 06 Nov 2025 21:07:22 -0500
X-Mailer: MailMate (2.0r6283)
Message-ID: <136E8B1C-3352-412C-8038-627F5CC8A112@nvidia.com>
In-Reply-To: <20251107011721.ez6pile62o3vmjz3@master>
References: <20251106034155.21398-1-richard.weiyang@gmail.com>
 <20251106034155.21398-3-richard.weiyang@gmail.com>
 <0D94CF57-A9C9-4C01-A9E5-CE47AE3F10EB@nvidia.com>
 <20251107011721.ez6pile62o3vmjz3@master>
Content-Type: text/plain
X-ClientProxiedBy: MN0PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:208:52d::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB7154:EE_
X-MS-Office365-Filtering-Correlation-Id: b826b64d-87e5-4664-3d6d-08de1da264a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JXIr6WFnmjpGEaFVMXNOf+GMLNaF1HSWOGzxTSsyB/lTxAFY7ojr+Pr0W7bH?=
 =?us-ascii?Q?CTbGjbZnn4QhtsdGnZe5bFIZ8ekb1jBwdhkxL48FkReoXYQroSQP/DdHHl8k?=
 =?us-ascii?Q?R0ZpojdT6eVwdZFmbL4iVo0mQ0RFv7DTBH08WkjukmtFwpIEpOkvEM2zCdaH?=
 =?us-ascii?Q?Y2Q4i93MY18blhVErvDlFY2rDwLgxEme+6dgPTqWSuKMRW93f8n4jbpz849P?=
 =?us-ascii?Q?kOa5l0YPxkemoLPkHIQ7wHXHNq4JYQ4E1/Lp/mku9gXo5ZIr9y4DUas/GOHB?=
 =?us-ascii?Q?56dQkA1uU/fl15QwFriHHVSzV9ZybiI/AOIwDRaQ92sxxshw+y8f+FkUgBe5?=
 =?us-ascii?Q?8sPbg+uMYU0t8DcQyPJrCsH3crPHi5fGquXS8Km3s9rqcrtg/xbzQ06aO0Wj?=
 =?us-ascii?Q?NbzYsVv2Q13W17r7BrsSEBnAw9gwpQpP/JRL1fSRyQ/ZLNAqN6K6hifWMAwE?=
 =?us-ascii?Q?kqD7/3Z0s4vcnmcrOC5NIxvDjtS32ctWTxNwXr6l4mCW/Zb87j7/r4uvymce?=
 =?us-ascii?Q?5W3d+iZoyJ9KtOuj1KTuHgHwDKelmW+b067zhVueAO/Wv+vH/+cJM4/mLlHk?=
 =?us-ascii?Q?/Sg2Oy5QLBS4WudVNyRGjl6l+pS1Fv4pLVHZoNFD8wpk0QdRaMPk+UlNNEY2?=
 =?us-ascii?Q?58PlFwCeLnATM+RsBz7TMltj8mYUDCeY6H/m3phDpBi/Sc9ADt5R9Aat+h2Y?=
 =?us-ascii?Q?knMKWcsCC9LVrCrWVsxT/v2DdU82qj+OnxPmE7qXAORW+YbCJvSV2Li7n69/?=
 =?us-ascii?Q?uM3EBPxEEGeSWpRiaQoc+Pcg7EAGySRq3KQViE3pEhF+roj6IC1LEJDdMlFQ?=
 =?us-ascii?Q?bwFAezB9YHAdJjvw8FpoGjnv9xt6rZ6LkBqIiXkB3zfnhtydXa5LaIhMwdGS?=
 =?us-ascii?Q?SJKYjPPQQ30Zbfl2TUc984coz6ke3SlOxvD+f/gJelga2WngYh6tQA8IH/uo?=
 =?us-ascii?Q?U8ysYHTJAnUNgxNeapTAJCzvoOTiIUma1EaQsBDy00RdVvX7CNpkwQSq2zXx?=
 =?us-ascii?Q?C6+Oj/ArbGgZCvTrt9uKuIa3jTNXWRQb7ysM40phT56O4F9CRwtUsIGU62d/?=
 =?us-ascii?Q?P0I9jQISbxw7mXKrzRwb/KnmT10OuwEIClPFkwxT4IQumKQBN+ndIUYazahr?=
 =?us-ascii?Q?j09UBj1lDJirytOe9gk1+gmUSMQJ9cBpfKpW/3mvXYKQN33O8qgJnT/hbg83?=
 =?us-ascii?Q?vVac4oY4lCzYGNnHC3a9IUaZ20225Ik23grbrUce+gjTtcXlh9RAGhUcMPwg?=
 =?us-ascii?Q?qS7kXqDiMGBA7/fsBE/XT2oG80vvzxlB4WmoTCK8cbLN/KDpaZYermmvpAZN?=
 =?us-ascii?Q?Zo/g0VHanLjtQYvg49oiUwFCcAi5KZCRlhILuC6oCmnffYnIpMwHx42/8KNo?=
 =?us-ascii?Q?8WBY8I+4vASritGCT4imE2RF6I/7bJ5LTTp2Qt3D8JBKceSM75nyEYSKcwhw?=
 =?us-ascii?Q?Y8oLRK47BjT+KxR9BCwYI58qKg2BRVBP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+0iD3vOTIsFDVfaVgVX5yWewj8I0VhMr8oNP0m+ILx28lmPwo/i+R22aJTMe?=
 =?us-ascii?Q?qy4SDsBRD7VUB67nCU4qTVOLEY/Ka81dJvHaiwxOiiGVAs+pjxm3MgazQaDT?=
 =?us-ascii?Q?keZex9j/YDw1mZ9fE3iQGuUkSWeEZjbFfO5hMlxbSUbWUAcH05ixupjXW5m6?=
 =?us-ascii?Q?F0cGsN77qL+G5U1/ltHS3BWVW5rtsZ5/fZRd5csRuFhV7uXSmsGQRjgBVKz4?=
 =?us-ascii?Q?qZtX5w4W/rY0NoWuoPTW9Ypqle/KFNIyBf4Vtv/t8bUaS0V5VxAdDpI1cUqC?=
 =?us-ascii?Q?lo7g5cRBDfB2wCrJMFx9/czVDDqNKaUWzDUQgAcsX4OaLhTpSFrkahTl9Js3?=
 =?us-ascii?Q?mh+a6s6w1ucdkRiy+S6zopHGIQd9WByFFF/I/vSKPHRZq7Sx4oGblVhPh5IU?=
 =?us-ascii?Q?z881rx/XnwQjt58Fz/iSwAs1H9FORt+78+VQaXWZ//vLHWZZEZ53s/i2kHq6?=
 =?us-ascii?Q?BopkNFgHA91Z+mpdJgXPA5UI0Mo66cza1uY1OG1Glp+z+ah3NzfMc9WWgtfk?=
 =?us-ascii?Q?1ZxcLQ/u9xJhoL4h/q3oOob6NiPyMpu8ilIcSWc56yBqULhy2Bue12PkhHyi?=
 =?us-ascii?Q?QF4arlbShKo7jG4W8eqr2IXC+8VFc6VjqqgKvPZZLWAecLiZ748HvBt9T3AY?=
 =?us-ascii?Q?MgK/6ljYUEGhT8Ynq7+TFVurkjAwd7DDaO358l6FahaP6mDizhS6yMgf1Fzk?=
 =?us-ascii?Q?vJrK6fhoJp4Sss2HuVyvV2QQofY7yfYZMq4nNmb4xsn+dfU63SbK1fzDbUYn?=
 =?us-ascii?Q?mA5s3CB+BMnrWisVapLGHsP3T58AMyvKw7VbLTL39GNO7Fc/CE27bXUeCMv4?=
 =?us-ascii?Q?GH35/h/Kd5LM3l3XwEnTLKZPx0PGjkTMIm2x9Uy2OY5z2R1H+mV3d4+Q9guu?=
 =?us-ascii?Q?ko58nnE66YMz5AIa5/j4joaNe++PPgcdUq3V/Tz4Zfa02EfW824wqD3cOpxs?=
 =?us-ascii?Q?97K+zdw2ICijlv8WZQB0UV2WmDXXfMBk60edfPau2fGqG8Y0z+3ArMdy24Sq?=
 =?us-ascii?Q?CR3lXgQTyFQSjmUpq+Kq8Urx+D6CJG+2HwmH1Te/vI1rpuRt2S0ZVCiHni3W?=
 =?us-ascii?Q?WMnKhLjTwdeFW8Fj52Y9PHcvlUGWfHVI1JwYc6mfUlRsCvieun5quCahTux6?=
 =?us-ascii?Q?AJjJq3+xcIDf9o7cEYR0T03Rjt9jFDBpdDg3TrYQiMBZAWy6oTzJGDgFbOEM?=
 =?us-ascii?Q?9ypeP8261b9i5KgQRSWmXMB7IIvrHVBU6xZX0ZhqaEBD/8rHHHhE9JkUodf3?=
 =?us-ascii?Q?aWw4G/PpVoAVG7fvAYIA8QqB3HZVMN6Cunz3rnhYV52gxwXccEkXPEIhPaXm?=
 =?us-ascii?Q?3n6e1KnmfMMaDqIojPEtK3teX+iRvD+I9h2z0WMy1g+whcPEmnkf7EupdB7m?=
 =?us-ascii?Q?lHhRnMRTQmlqCDYGIAfgs8LGPzlnw/JzLH00+7O3Rbh7fmHLQhBD0S6PWiqD?=
 =?us-ascii?Q?YHjmCmEEsniIY20I2H3JXOOKZnGXywOtE3tL6nbo/RWs37S2cPWnSo46lvLE?=
 =?us-ascii?Q?DIYk9gumP/w1gVnNzX+squbb5YOUsVUzdEhuxLHt/luzfFiCUfI0MG1hq9xq?=
 =?us-ascii?Q?1kUow7nYargZ96VbOJgZmdzoakWcVUog3n14hTVp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b826b64d-87e5-4664-3d6d-08de1da264a4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 02:07:24.6157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 65HDbSxKA9BvZS0ivHfBJDEwGZ6Rbo+14cWa7jrcP0VIZJKbZjb2Q9qW0ACE2N0H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7154
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 47C178000F
X-Stat-Signature: ts7o3o1gjzmg9ujjgu6w6hm1mynw96md
X-Rspam-User: 
X-HE-Tag: 1762481250-903776
X-HE-Meta: U2FsdGVkX1/toT0SY5zb+0w9oaEkatXYDVh+dHMdNlv2QFdNtuoPidn6HVBI7IF7xk/pVIvAjWU4P0O5wzQ3H9NJBhfofojo4bsESivP0dusRf26eyNv6NmoVfGNIVvOr+7orX4ObG4rCmeKvT8XFBruxFqXiiQ2YW2XJY0Q5iRx6vkpO4Mrm/+efH7F2YKjxQX8QzuFb66kUtahdqZcXB45pxK5rGdVSCj2h/m+T4AIoYGKmgqciCZ/Eef2iziw7VwdUx3+VQMjdcfToHGlfwQfXYvMnv+iDWCBJDOeJ79DoC5CrbK5IRyG8roSsdc9gGPvmY3hyI6XPGvzGNwgFnUcgVkwt08QC+3LHNlw54et87cWgZC7wbDheuj5mpFr56zq6Ocgbgvg+zjwBnephOj1YvzQy/1dvLX9MBm7t8kTUmqxLKez7bsmk0MYwdi0kezPz5OtZNX7EBXmbSbER8pr2dA1aTZiwTQrIsbm4j8FkRghmSdnU5DFfyOERdln/Ys92lhPVf8UghERdTfs6BKMk0GSjxxn/Foqx4zI5AGOhpZRQbtplYOlMOx4fdJs3giVG9zyugSho6CgFVAohT7l4eVH4hxMv60IsVYI6ZEc8dcBLqZepMMgAiKXFK/PCYdgt4deIH43wsjmwseeDOWcOYvacAcMXqJI1GTMI0VQMf21aE7RN7TZaunSrPDuTTau8NSC7ExDmLbRHDIuiT5DDQYsJkfOxoDzc+XOkBJvPE221GKCzlCecLPWMSYRutSBW8ElH9d5GTh3kpVFWTkYQJF209lJ3FVsyR+PT0ApMc3UdzmAMjcS5+SjnavuZhVlRzKT9z3xPkQh8HXYMSlt8pM5+vqhZI8Lr4sKs0Vo6iS6im5PmKraJjc9cs4ai4kzJjJ3zeKxIc6U6YkQhmT7MK+kyHwp2Fg0fs6R7QHbumzmcRpXT3F8vgDvTtFZTS/6OvEO5D/yrZ759IT
 FxdEezrY
 87I+vT91bIZVvOXlCOv1wNajxPkPVvKNOzrAUmWLBd6+nhNjcj6GjrhWPyeHupzTsgQ18On4HSuhrOcYL3ZjMt1rDluzFHScYmSiOLWuLkHYxE8RTxy7v0dknjpUsrJIqIc/whiuUJ5ZOdc4KmOVLHbsE7+pas9vvS3K2RvQMbY/oC//J0oWOIKrqL77SUSTvBUg+UWFAJBebT7okCjNjMTvsrvaMD8NqxYj+qocyobZbbeob4oGzUc+Whl8asF0qZZ8qLPKc/nMZjWVZcjR5mveR+LrZeCHvPOAQf16PzTmjY4waonG0lRp2iOGKNUDA7Fqqly9U9ImcqpyDNDm65MZcIQGLLGYRUzcgaGjwY8fGZAW9Gv2FTEIqspTCFlcsOhzqLqCqF5wK5VcpuAzl2Etg5Rgfm3dPI+L9jRrZs4aMGJ4x74RuiQJy5GLuHs3ghXGnGL+FLnUdxebeFOo2WX/rhl/qadTvntQGykr5NW203MvWRlMYWmV1+jiJxJoypLTH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6 Nov 2025, at 20:17, Wei Yang wrote:

> On Thu, Nov 06, 2025 at 07:46:14PM -0500, Zi Yan wrote:
>> On 5 Nov 2025, at 22:41, Wei Yang wrote:
>>
>>> The functions uniform_split_supported() and
>>> non_uniform_split_supported() share significantly similar logic.
>>>
>>> The only functional difference is that uniform_split_supported()
>>> includes an additional check on the requested @new_order.
>>>
>>> The reason for this check comes from the following two aspects:
>>>
>>>   * some file system or swap cache just supports order-0 folio
>>>   * the behavioral difference between uniform/non-uniform split
>>>
>>> The behavioral difference between uniform split and non-uniform:
>>>
>>>   * uniform split splits folio directly to @new_order
>>>   * non-uniform split creates after-split folios with orders from
>>>     folio_order(folio) - 1 to new_order.
>>>
>>> This means for non-uniform split or !new_order split we should check the
>>> file system and swap cache respectively.
>>>
>>> This commit unifies the logic and merge the two functions into a single
>>> combined helper, removing redundant code and simplifying the split
>>> support checking mechanism.
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>>>
>>> ---
>>> v3:
>>>   * adjust to use split_type
>>>   * rebase on Zi Yan fix lkml.kernel.org/r/20251105162910.752266-1-ziy@nvidia.com
>>> v2:
>>>   * remove need_check
>>>   * update comment
>>>   * add more explanation in change log
>>> ---
>>>  include/linux/huge_mm.h |  8 ++---
>>>  mm/huge_memory.c        | 71 +++++++++++++++++------------------------
>>>  2 files changed, 33 insertions(+), 46 deletions(-)
>>>
>> LGTM. Thanks. Reviewed-by: Zi Yan <ziy@nvidia.com>
>
> Hi, Zi
>
> I am thinking whether it is proper to move the check (new_order < min_order)
> from __folio_split() to folio_split_supported(). So that we could bail out
> early if file system couldn't split to new_order.
>
> Not sure you like it or not.

It sounds reasonable. My only concern is that that might add another
indentation to the else branch in folio_split_supported().

You can send a patch, so we can see how it looks.

Best Regards,
Yan, Zi

