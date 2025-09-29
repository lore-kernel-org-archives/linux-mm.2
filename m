Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9DDBCAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 15:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 104A68E0021; Mon, 29 Sep 2025 11:16:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B4C98E0002; Mon, 29 Sep 2025 11:16:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE65D8E0021; Mon, 29 Sep 2025 11:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DA7C38E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 11:16:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 791C6B945E
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 15:16:40 +0000 (UTC)
X-FDA: 83942639760.02.910BF75
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011034.outbound.protection.outlook.com [52.101.52.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id E4CE32001A
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 15:16:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QK8pAM+8;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759158996; a=rsa-sha256;
	cv=pass;
	b=IfHXCaz+IEAJUDhv3naQ8uYdaWiOA+0sTF7Hvr/09IUqUA5NDPs+hG8STTtnsivU0Z/kiO
	yXrhFLQ0G6mos9FiOVn0xYIwt77mj4FK+mD4U62nan9pWD0qATXf51+k3qcC+SjhpiMES5
	/iqHPzyZLQiHwLyj1knfnVqVerwT0Jw=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QK8pAM+8;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759158996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wr5Bv3ESKpRSOE67LwQlgIbL8dmA8SaA+AS9TLgx82E=;
	b=FWoYUnKgE+RVf1VZ1nIC4g6T/Fr7T4t+jVnzlevGeaIkDIvqz3YX/rW+6HsvD74furIr3j
	E4A/BudxIJyPnaWbQ3wjkNke6YTeQmoMtYVKPPG8dRrpSgWs2uz/+9fzKssMTGyw0N/tlJ
	/EI533E2A84fY6yWKUzUYOB2QUkCSDg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p7a0EuCqYqImYiUijHx1oKC8oAAuk0P2OZouwL+8HpOTMCE7+Mg/DQuK0pI8O5ZGNgtZ/JsGuVccYJpMbVePd+DVZeSiFhk1nUlgrnpoWTwOFsDV6X1DbGrlvGrR/3TTaSKWGC3KdmpkpaclqcdguX4dYGTQWfH4vMIIYZN9zLZSEHAYlRGxNeZ5rQqCqWxzYtUJqutXGx4e76rK58gelQsT0h/QI8M7HPZPjQIjjMV3928QSU2vE/29Wsp9D94+sDtWLhopPYB5OdVpulUiWQtfNY/LBiyCeYXosSScR3RfCazhLyw03ZBh7oabFPSKLq0h4p8oknOGWLj2K85h3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wr5Bv3ESKpRSOE67LwQlgIbL8dmA8SaA+AS9TLgx82E=;
 b=l3eXagIAT51bGkBN5d+NEYfZCF7XcEIhg4vOy/zG+iyP5kH5v0VAHp7Q6EKN8CPjsz3KxPGqX6058Km3/k+WU0fNY2XuNuw4EULHThF/gFj2XAQLQdPCfw+6Zv00diVaKDiMd+GLcuNRnHbvbuWHhWXCMAqdayz8mC+FbgIm6HQFphcKniRcss7b+lY7nZScTxPVg9SAtq/+dF7qWu9cJW5rlkEKsVOGPVynxhx8wZIj1nI/fKDC+NZGF6ciTWxB5vuLwK4Xn2MPzXTK4piF8SeMFBp5fck68hAuEahy1K3HsS3QFVAO1vs/qv3K8KuwtRgbHBaP8b44r4QTzVwg6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wr5Bv3ESKpRSOE67LwQlgIbL8dmA8SaA+AS9TLgx82E=;
 b=QK8pAM+8lgY3vM04h2ySYDkVcmrpdVkcFyRI0zR/0sGHhSWZW9FkkWM0dtNNbD61q4MJ4I7GCazVuFWh3SHYASv/jDRvzCV4FiMixdtB1kzheXPTWYzynSEAxL0BBEpGcQnybIOmhehBt9evMBqJQOy+wSx+hohj9ebaAWN7XhZ+yXzdrivoRIgYJf7aPlGyZ8h1jjZwCfWwtuWGYJ3lM5UQ6HY4lR2C2fsuHKuddFS8p5eFMuWq5x9xQEpOnJpRLkK5MnaKoYgxvFcK3wnPbGCw06quOXesgWD+NfK+LXkI1tcwNPVwB4cPNvHMh/lXBFqy4AgSfk3++3aDBjVcMQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH2PR12MB4200.namprd12.prod.outlook.com (2603:10b6:610:ac::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.19; Mon, 29 Sep 2025 15:16:32 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9160.015; Mon, 29 Sep 2025
 15:16:32 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
 linux-mm@kvack.org, Kiryl Shutsemau <kirill@shutemov.name>,
 SeongJae Park <sj@kernel.org>
Subject: Re: [Patch v4 2/2] mm/khugepaged: remove definition of struct
 khugepaged_mm_slot
Date: Mon, 29 Sep 2025 11:16:30 -0400
X-Mailer: MailMate (2.0r6283)
Message-ID: <6F2B513B-C0C5-497D-BBA4-9DB19E98D4BF@nvidia.com>
In-Reply-To: <20250927004539.19308-3-richard.weiyang@gmail.com>
References: <20250927004539.19308-1-richard.weiyang@gmail.com>
 <20250927004539.19308-3-richard.weiyang@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0251.namprd03.prod.outlook.com
 (2603:10b6:610:e5::16) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH2PR12MB4200:EE_
X-MS-Office365-Filtering-Correlation-Id: c65f8389-47c7-4d83-917b-08ddff6b2c1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UCTdR69bdb7+W9JIxhvE3EZT1fo+TQMri+n2Bk/P9T4BUdyo6QBs3y7SCCDj?=
 =?us-ascii?Q?Jk/HLutDWqexIgxmXyk0eJ3xiTpquN3jzwUY+j6trKZvTx+/7VZLESgRoy/+?=
 =?us-ascii?Q?HmvH5OgDpXKZk516Haadq/8JPmgAIO3HGS9VUTH5oZl/y/BEjEbpGTCIwWWs?=
 =?us-ascii?Q?E+52G7/8EefU9TvWqwDMTSlht9HcVAfqADFL50vdzssk1O44sJYIOevVFT7D?=
 =?us-ascii?Q?rRMpHJNMyshYNrvrNWeLoBr6dywLQHr+7DKDYtRL/iXCizdXPPWASnSokJDX?=
 =?us-ascii?Q?mkma5Du6fZyG3iKSexgCF4TovZ3wqg8KhON0cV0qMJZWnBMCOmE4+pd3W+va?=
 =?us-ascii?Q?YGgSA7wNMZ4J64gQoqBTEUriHGaTtja7zJ/h/k1FflfxjRGfD581wLxET2Xo?=
 =?us-ascii?Q?Zhz+VUOyDHagqxhvxfkH1RRTSoBUowmgUtCRZ5shejC05dDdygepeUVLb5ii?=
 =?us-ascii?Q?K7IPsq9kIpyq6Vp2T1qKsIiOOdxsWjPMK5URzRlNq/MTJrE3pRy7fb+MKJsI?=
 =?us-ascii?Q?5j4sm7xnuSLkF3eGAr4JMytmRzvFr7a4hQNkHxWdxWOPTIzEGFWg53gh1QR/?=
 =?us-ascii?Q?b7v+32znOsd8D5LLNk9CxYljxmdgqrw/G5cse9LRf9S8o6RATU/CR6vQRQ5s?=
 =?us-ascii?Q?PkJURd9Ia2BJl4G01QD6eTpqr9dQJvH34K8WCIP7SOQvOvhGbSP9Gc4IzDff?=
 =?us-ascii?Q?2Q/p9C+maQx5/RFUM/DwsBuxrCNlsXCGzmE/MXnuJpR/wc8CKD3m3YFRxF0p?=
 =?us-ascii?Q?RKicOnJze7f7XYzkFlr2KtLl65KrN8OU4N2VW1wRZDu7MpnHnbTTeuU7LhbJ?=
 =?us-ascii?Q?wftk5bh6/kzTRBI0LABMq7caYuUd7sV5wUBCJaQFD7+X2HDhoIY7aTjkZM+K?=
 =?us-ascii?Q?vepqsGpQA5YHncC+rGVfpL5NJeimCkUuYuyVbRiYcfSPjA8fO/cF7j2Df/Sg?=
 =?us-ascii?Q?Dpc0PpJZTY7we1AAoR7XrZgDGtrinWKewKNca3y2Y159V9sEPp9N+TGMQsGi?=
 =?us-ascii?Q?Wdkjg7AMiFp33YSeWhWTq8Ce6iZRFNqzmUbReDQxf08EwI7tImdWElvLJOfA?=
 =?us-ascii?Q?izGn/u55nM6zgbFr45qNResaiNv3+Rnc9eySNeD3/28zHHTfVIWG+Ewz/CL8?=
 =?us-ascii?Q?T5oS2HADLaXEZGoYSpWxpeOXxEhfKC0hbZDMCd4o0tigXspKtcmoRcoDerJV?=
 =?us-ascii?Q?SQtAD5i7m7iPvN2w33hibkyxKcNia/lbPJn2zBGMiTDX55iPpTBGAMrsoOT0?=
 =?us-ascii?Q?qLidWtwvGlP3TDExdREeKEErRM+LN35nAHAtYwOwZmGVZKGl0iToNMKjNwQp?=
 =?us-ascii?Q?cfErXKlLzg+D3ktehvkdBxrpCD3gtIu1kF95JUb0LODoKbeHEAZ6olSHO9vU?=
 =?us-ascii?Q?G0UfaC6m3CraoPpUDRp6HXC2RuLpvhrE7wGPi2p94LFJ9+M2jdmJCXHfxQUD?=
 =?us-ascii?Q?51FpQCEcETDlymtojcDoZdsYquvAx7aM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?M3KOOTPilNlLG2wEY0TqdT2TSeEZ+vwawnaNH5Mrq8HPJI3z/vxhz/4vBSHP?=
 =?us-ascii?Q?OTt87iqG7JBYJDRQHpfIbzBA06s4PnLgPus4XGdExeA6BeHrT3cB/uiI+M4w?=
 =?us-ascii?Q?H7MuDf1sMxsE6znOeCMSIOLHPKfKeinGFyF0tXINub6z+oU1P3acoCB+zWAr?=
 =?us-ascii?Q?rm4KUcVvdb+luCw2q89evSih6tsrhmi42R2cTIFnpPyGy9TCbXzit0zO7H/L?=
 =?us-ascii?Q?lhExCOM92YuO6XrvHJ1dBcSDBtEbOM8MaWIv8765NFb1DgKJsrEBfXuVYK9w?=
 =?us-ascii?Q?7tQaET85AXdxrNffVfFeZn3KBQjlbOUJx/xEV/rB/Xx1jf2Pu6IkE2Cmzdx2?=
 =?us-ascii?Q?NfcbEe/lEkJ9xejpnjkjjREWQZRxy+j+gmt1sFWS7K39MxYw4GBrnqpXwlkT?=
 =?us-ascii?Q?xprCPabZ63LN7F/CgDaoov0xmFgHRqbDXaJtTHOd70u+5p3J+5oQ0yg6VEdb?=
 =?us-ascii?Q?KnUQJeu0ZtVZNO313iqoPr9yiuu0AZIoK9A1GcslUkxHsK+7lhVVWYkqH/9g?=
 =?us-ascii?Q?o74+OAjHI6QzxMp1jq38dqWdEhU3QaPyIt0PpV1EHJFcrLT3HK9qeZlmtENr?=
 =?us-ascii?Q?oHHB8OiXgLw6E7TK+bYNoyC4HCZyBei17NjfS+Q7E8l2BQmqLuCq17/EvLuM?=
 =?us-ascii?Q?rEkm+I1MbTUFAX/Gf/qPSHBBUa/lzFv58JKGpB+YeIlAOv6hWY+n5TUf9IEQ?=
 =?us-ascii?Q?Wx/QMme6Y0s7MuH7DNBYroXeFwb7AS1f2bFuPz2nU72WPScXjpPDtnpSYunC?=
 =?us-ascii?Q?t8ifn685E6gWNSpgg0iYzGdY8g/c+SRODwz2L/QbrGep2/0iVrkWO7NLLBke?=
 =?us-ascii?Q?zr2/9QoxggFKYEtZZ8SVtruSeg2NBb857qDqfqFaHomW/c/IyeiaMH2EL/Ue?=
 =?us-ascii?Q?kNuuUQEXgkgL/Et7yEDPPGkS6SmeqfAXLSmDtf5jb4/DaYoJzBbsULtUGXGP?=
 =?us-ascii?Q?ZgoJNbugfb9LaIgrGAotr6ntalvJKJjQmpYsh8NLWB304A+GAGJLGGGFSC10?=
 =?us-ascii?Q?Va00pV4wnAdvoaBMY7r/CjCQB63ABvG/+CLEois7n76Qy3xBOmXluN54imDM?=
 =?us-ascii?Q?KkpF1cz1vqSxuqDkfZeKXZXMzGMp0WolV3NiWN8JN7pJwj0/VqN6f1zeMPjV?=
 =?us-ascii?Q?N1ACaxVeFRdd3JkIFbU4XTTL3n/lu/VaO/qTjF8Mc57jl7JWgaP1cGmNilCt?=
 =?us-ascii?Q?6nXBbawfJAVV/kKDBGo4wjLG35Vev82MalYjg0GIU0g0TaGk+wLSvleIQORF?=
 =?us-ascii?Q?8iWH+mZzE9HOTrCKP8pcXFHdnsd6C44J4YERNnLEaCV1JHQBtiBWbg3ESNkF?=
 =?us-ascii?Q?3xQMNPtJPBrsm6Rw8+Mbm1RI4sm9JqnXnZa+O/r46ELn4Io15aMtcS9wq2kg?=
 =?us-ascii?Q?xaKktF8aKLLV3DPjlHR9kCKempaKKTver6DvTcDvXycpaGLP+XYfTLY4KXS+?=
 =?us-ascii?Q?0cONwMc7c+Vb8ej5g54Zn7se6yJ2pYNvLIW0Ao170dIVUjWQuLNPqzdbR1CD?=
 =?us-ascii?Q?sKs+kot/qnmjVVVl6Rk30sGEkWPVB2Rrm8D86ZEslBVI3K2ruMBHf0TTAJOL?=
 =?us-ascii?Q?AP+DxLLokNSb23xXlTo+luQ1YufRzCq5oFodHdBk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c65f8389-47c7-4d83-917b-08ddff6b2c1b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2025 15:16:32.4603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Er1nvzPcc5oMbqoW0BKp2m7Hb5+pBY1xSYvWxWdeqE9goPLbUO1KbQ704RX7OyA3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4200
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E4CE32001A
X-Stat-Signature: uqqaikym4qhaduic6u3girasjni6qtiu
X-Rspam-User: 
X-HE-Tag: 1759158995-70518
X-HE-Meta: U2FsdGVkX18wOn4I/IZDcmRVXoP8+6KP/e2o8bzVKELdsImXuyK1GNSsC4jMpUO1zlva0ApXZXc+BF0BIOrrJVgV5heeNtklHUWYbdYzDF63tA5hKSG5eOpul5uVaQR2oj3QDMpeUZr2DkrAWWWUDNScSIFjQ0gP2uqCEqEcyTWW+QsKnaxP1i9gZce7qsaHQB8FDWlCpUUGlTGdQD6lkXKlFYGvntf8S5JMF+H6NB04v1qvUFazN9I1gii+rZ0aBM8ycqv9Is+/K4tZqxBmG0GyxdbBmrLeMOPp7B+ueegAdqajAHcoQssPrmP4/V7Bd1pgsP0HmNt9SSDAYJrmGlX6EcJbdoBW14FJI8WlH6dAayW9183w1y+wAVWXkrs1+uDUPH0lvvdZG4sgX7gwpJuL6pDZYAvMSvQPXcyaz4SMpreFP0EYzFIi1xMYIjwRYrdrYg/FSsfTHmYyX3F7Xr+l+PmIYsafwM+MxeNy5wI6a/0f3utXLCNE8r9DR3TaKYaw/X+6KvqQSEBEzpTuWcrDZd9m/COMKubRGHFJ6jiWBKvfCd6R8TzOQ+TO5cm4pguTIBFTYjVjw8nxRf0gmuOVd2IcC8ogkla1ehWkESGQq66y5DkiNspnHCQ6cyTSxoThrIQd7FLLOHXirXgQTIt1ibam1FwgRfSaz5yDifpUhclYNbvHEtvPBXulKx1Ey7PX6IijzHOyxOXOfgud3AVgRW3IWyBYPhXB5Fn6NcgW72p0xBfDQhvnD0dB+DrxSPqcNraSTJfyUbyCIdHda1Ii8l3gRujk1aBo+LDF0gr/sIp+s6KqlpzG3awa+aDmKOKvQ99Cpm7W4HvhR+Rlv16lbs7Uw7ICZYQ3/MtIqXIWa3tUZTb+JBL1ipYCVNoV5NzP2TPBRWMR90tVZPjm6GREoggm10nqkhDnTNNEhAP7bfTXeVYuJBe1ixGB+1mFQ3pwZyFXIMrTzzPvuFb
 W74aVKQQ
 FMnDVKxAqJj9QubMVWRyQjtThHc4Q0M7bbBsFkeJodNwfokq19iu6Jves2zmS+eKwkZI8o8KF8qYriioR8RvXaLEbQ2IKzkhW3V43MQaN8KE+A0Tf70iJmxpNC5rRHm+vofsQLAWJUGTS/Ou3YI2ftQfCnZJkBievOOGHEhrNQFIC29lhFDGLty/AhrFOjMU4mTn4Kv3sahPlruxPLbrJ1crgNci94cGYiAkCBzKutP3hBgsFYjCwyreGhCwRXMk/dlrR/9vZqvZtpsM6WhcLdecWpzbFWtcGjnio/Fkuqdv3avcocr1fOe5BVzYwGWj98+Lbfp2vbhEVp9t86+dvlbq32EtOSReT1EBkXwi+JjejOsqsJepHLiBEnbvHJKRVvabSA1pasY7CyK4pjwUg9y9HJi3oVRsjl+TODDyojF3Xne9Y/yYoyMaHoDOVwG9yU3DwX30aDbM3sIf6eH1SIN+dwuNhqm9Hp82uAghAejmkV67lzpBK1gB+UrIqfJGK+bNvhcljJHuGj+5MKKgUKkupJRHnt4B88XHTYVM/ci+i9DQ/c3uco2K/ZhUYU6KQerFhQNls/LmYVhxTe6Tz+zntL8m4BB++mQ2gWHp8TozJVtFyx+D8J3VhNNbI1fFgelwyHtlKFegR1+QyWD9L3SeXiakiajBYxXuMjaapvN2MjtmZo4vX+yPZ0cFVjoUtYjWIT5jS9PMGw9lbGPl4vx1ABdby0nblvjl5bAUWGe+CGdRbUx7rJ8hILg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26 Sep 2025, at 20:45, Wei Yang wrote:

> Current code calls mm_slot_entry() even when we don't have a valid slot,
> which is not future proof. Currently, this is not a problem because
> "slot" is the first member in struct khugepaged_mm_slot.
>
> While struct khugepaged_mm_slot is just a wrapper of struct mm_slot, there
> is no need to define it.
>
> Remove the definition of struct khugepaged_mm_slot, so there is not chance
> to miss use mm_slot_entry().
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Acked-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Kiryl Shutsemau <kirill@shutemov.name>
> Cc: xu xin <xu.xin16@zte.com.cn>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Nico Pache <npache@redhat.com>
>
> ---
> v3:
>   * adjust changelog
>   * rename the slab cache to "mm_slot"
> v2:
>   * fix a PF reported by SeongJae, where slot is changed to next one
> ---
>  mm/khugepaged.c | 55 ++++++++++++++++---------------------------------
>  1 file changed, 18 insertions(+), 37 deletions(-)
>
Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

