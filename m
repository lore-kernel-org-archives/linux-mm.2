Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7465EEB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE9C46B00D7; Mon,  2 Mar 2026 15:34:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8A376B00D9; Mon,  2 Mar 2026 15:34:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9F986B00DA; Mon,  2 Mar 2026 15:34:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B3AE06B00D7
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:34:12 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7BCE2160346
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:34:12 +0000 (UTC)
X-FDA: 84502275144.15.69121AE
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011029.outbound.protection.outlook.com [52.101.52.29])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9E29E180002
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:34:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=h5Na3SZS;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FIJR+S3VvBRrbI22E4eFJrKOLiW/e1x3KyERvj1h3RE=;
	b=3/7J4qFChyriAfKgzYV4Dacho0Aw7KVzKSUDRhn+i3EwhcmNmXXVv/+UQdzjyCToXNp8fs
	MOfWNoobrzz6XXzgvAJYSf3wOmujwNfzbgu/pqzLS4Ucq+Zo8pzGARul8FmyiFXZ9TV2uN
	yOBV74fG1q6WkGFkyxwbkx7wS1gKsmo=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=h5Na3SZS;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772483649; a=rsa-sha256;
	cv=pass;
	b=PMO7TSz2Klr1Z/ZuDDIc57HvXuEvUEEI4UAXuWyk2uk6afSXnhUEuK+V0zVbQ0ZMRBP+XR
	jS9RtLk5QqaIanMGlScSdUoIxUtesnQCOvexBvzrL2oIfdwMRnKRBQnltuxIB3cX0oJ5Zk
	uMP8ecwchWeYS0pNeqspLOkp1UCp7Rw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=apw73pUQQJYEWAdraKoFNbL1Lc7QEnyf4DhDw9RvujAr+cQ4Cp+cS2JaogYeCNZzGVZXSsctwNWly7XNVlZzLSExxqEhGXV3to6Aew1fIdgcvPIuaznTDM9NUguAHT1pBpGiZJDK8PXZg77HHByaCW2KSXK1b7sFjVMNGumVml5cIplqwugFC9PyLa2xjwMri2XE9KBU+7X91ArXDcJNSIleyEveVZN7p0QC8/5v7OgOR86hip0iEFxs07khwm/wZ5LsYuTkSa/MYN/sPtZM4LT4UtegmhFXFZhdepzTHkujnGfYyHqk7A9IVdwU+9mHXQFDmRsTJOQu3Qj+Y4dDFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FIJR+S3VvBRrbI22E4eFJrKOLiW/e1x3KyERvj1h3RE=;
 b=Ma5N/cJl36Pip83xZFWktGnnWs0nKCxMb4UOrVrfJfh2FE7g1yui9xuqik6gTLn8o1405wsElyRIhkHiePUIeULQvLky0l/ap4V7Zwc6OrYxECY4RJMghw70KkT/i4/Zl28kSIjS9UWb5zjKIudxJ6EwzqGb2O4cWsBQWS07zL6+BNugKEXHEvNHSKd0dGSw/I/AuiJl5l084+1Yzm6YC1OarVNY85xgudb+3fboGyJnh7CvjvX1etJD/7ylFKk9vY3Vdn/+BwmEO8WBX29D+6NJeqQ7Do09r35xQgTGvlYSBB11GWXNmc27A5/TTmsOB5xkgfM+7ThDeEE4f8vHVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FIJR+S3VvBRrbI22E4eFJrKOLiW/e1x3KyERvj1h3RE=;
 b=h5Na3SZS2xuydCfTRz9mjr56SkBZIryh+0F2SmJ9u4/WLB0GyMBoo6klRxLkt20S+7wN3/BJ4CmdO0JtANmPW4ml978ozSuBhDAiIqbOBM5Gr5n2aGVlUIPyoBEmp00M0RTuofxf5L/txKa3btswePG6Ty+TJhJY9ydURLAGKb0J20veEPwh92jZvaETR/9g0MVGPUsoKUQDyWkBpok74J/7riN3bCfhP171Avip5sh9nMpiRnovZoLyJofYlFqbcZHiSgUtoRSVv7wgtf0cKNG1aZDvL+v9c8rUpn5yp/iopI4ca1xU7ULqEt3g1UJ0XhELm+WJ8Zo1HMu3snJqGg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB6373.namprd12.prod.outlook.com (2603:10b6:8:a4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.20; Mon, 2 Mar 2026 20:33:57 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 20:33:57 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Wilcox <willy@infradead.org>,
	Bas van Dijk <bas@dfinity.org>,
	Eero Kelly <eero.kelly@dfinity.org>,
	Andrew Battat <andrew.battat@dfinity.org>,
	Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/huge_memory: fix a folio_split() race condition with folio_try_get()
Date: Mon,  2 Mar 2026 15:31:59 -0500
Message-ID: <20260302203159.3208341-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0014.namprd08.prod.outlook.com
 (2603:10b6:208:239::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB6373:EE_
X-MS-Office365-Filtering-Correlation-Id: 0694e7dc-ded7-41dd-9410-08de789b0723
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	jk0A9PT7wUxwelh7KmAM0eLvjmCNCElqUQkexeLP0mA06EywAuMQu40X0Pv2TbVRmUICMbwqhe7mOQAyoacsBrdYF0XbL62Bfza8tsoghSVXxLBI5qr7DXZkqLIfeQ9pOlMhgpGpm9Z7W6MJDotUtD0g/Hy2op7xsTewCiZv77ZttyDRR1NlL2e8v6pEPyWCM/nMskyJyiuLm2cdZW89+JWM8Dn8ywScPp00yfkV0Dh+YFpn4bggHhmbzB8LRTrEDdmgSf5kvonfRZ1wPXs/1nBqjBeAwtShrBUKRr2RAoqvSt1gcyiVgf7te9v+dnNEx4aPj723xYPTy7mf0l7OVIx0Km+sY9NUIidN/SkGdX2RDqNSBtAHJoY/iiwTn2fUQ9BXvubeFkt4jUIrulPKe+e40d+sD1rkIAv1TF/JI5oJ5YJVYWNLqcEzOoAp7zDiUA53aXAkPnm5AfjzwueDMow2REnhUOLPtywr/HX9uVSnb59WwHct6ZkuyjrNU0pXDbZHnyjBVdc2TODZ+V3lZXQP7SF2FNsPvufZtxVuvBoRr7Wdi2vlaJbyUJ45+V7gHtZRpcHOvHTCrxcyhcMAYTeIrJikFMxu5Rkm1dumpHgNAeaD8aXbslbnDTF1VHgVaaQXDUXElvTvPQR8oJlMlCh9vp22ZE6YOdpFa7An/2dKZxN455CMfygaX8lsIMpsSu2EZAErCpusSzPrPlVSh9xxM/hOY4eQsANhe+gspYw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dsQTy062+n6Mdku4TgnfE4W5Q+YPcElZNzjEQhjTIfzxB0xvvqhVKUZod8wh?=
 =?us-ascii?Q?EHpijodYBvs8T4awiqQydI5MBc0kf1rNuWUK7RYffXBJnYAIkMw0c8m371x2?=
 =?us-ascii?Q?qA77FcealKxkLMudlJdoj5y2a90IuYLsho8nh35i5qty0tUW6HUdhU5ogiO+?=
 =?us-ascii?Q?RevaLeZFH0kDwfwCNM8kWi4/7J4WC6M5d/vVNI5TqdxJERBYoDbt2MxNK+8z?=
 =?us-ascii?Q?FJV5AOq5tZQDBrO1J5TgTh5HtTpM2MauJ154C/DZ1NytT3OB0YnpzjKphlFr?=
 =?us-ascii?Q?eFXqzb4mtAqN1JHyFImuT/fXVdKZDU17C3Wyu3bX8BcCRS5USoYHmqOoDEP7?=
 =?us-ascii?Q?j5c7np5ifalJnJuPfpN527tRLEqC47Ng+LX7o7oUA2pexdeSgvb01fuLm/AV?=
 =?us-ascii?Q?sqaTUiFowDLc4JnuTsLtjbIjW0nI1q1Th7e8Xkk+cah61pd4k5b1Itw8sjg4?=
 =?us-ascii?Q?26AKdq/O2oq/tn4n4wy8b2875iRiyjD9DaPmM0Qf5PQJ912xfZKPs7Cc86jh?=
 =?us-ascii?Q?OubaRi2HR2GNyqOvwupu72RL90JKxZaKXjf/XZDjP6uqJX713xcaWnQqYH0O?=
 =?us-ascii?Q?MVm6lFbM1PBrq7nvmgZaPKavQZl2ReVQv9skddbE6GFWnJba6RdyiCVoCLVN?=
 =?us-ascii?Q?OR82e5UQv4qxILQCMX6EE49GRQ2fe0+ZUKWuhzL7O0A0/vknkZHHDE1x7Ij+?=
 =?us-ascii?Q?YcfBhV0Jmh9BH8yqbyBGfCCFpogGsYkyS5LjBKKb3v4kpL1CBliVQyPAv1eT?=
 =?us-ascii?Q?f5Em7ikHOooClmISeIBPxbwHJT/FT9bgJcqwrKdyIna398uCEF16WeSSh2o0?=
 =?us-ascii?Q?bEVV2PFxdMKAPWxuqJ+PTA61GRjFARdJTVJqzW2GlSylq2Rc5mBxSDEAR7Qh?=
 =?us-ascii?Q?SAiyHqgcN+CsVO/lceVekjjApeEp8atGEjrTadQ2wTPrPf/i98/hl/9XLDch?=
 =?us-ascii?Q?hwiUBc6NECCvoG7L8p7Iz7EeqgaSNVUR2RVAfyEi9ZXbqyvP4zNKmXPQ0v6v?=
 =?us-ascii?Q?li4gMgxUkmqbu7cJPnav6S1HluEw715RWDriuB4Uq6C1dn3ch2ZWqUJXK0Sp?=
 =?us-ascii?Q?/1k7WY0lBkgtso2r5bfdvpUG9HtWa52nfrEAOf3Jq3Is5eimxbhNoaZnAvOB?=
 =?us-ascii?Q?Vjo9idLgzBAIqUfrgBRFZrb8SdF1EPSXLuBcRvVDLhq/DpNL2dERkZyj5hIx?=
 =?us-ascii?Q?q6YqMAs90Ca8JeqFsoiZ6XY2/qpLHWud8lTJqJRyX4nNd1QzXngaomXUPNdp?=
 =?us-ascii?Q?N5Ga/nYhS/Je03E+3SftK2L+7jg050cD4Evi9MsAhNlnMVKA8eyQ5K3wxB11?=
 =?us-ascii?Q?FCOSiy1dIav5k0NVjcZjTuf2PCetAn6FKVVHYEsEgSpyoAkH50zHZ0nWIiPu?=
 =?us-ascii?Q?YynaL0JZQYvT2i9C3G6DIHrkmZsMsdFM9L/SmHo/MXGnIivsX9h1HxQCZefc?=
 =?us-ascii?Q?/W2qDmWeJqpLNbNvL8dWMPnUfUn9vKmelGWe3jebSh94NFji+3Zp7VKEdefA?=
 =?us-ascii?Q?TR5DB0u0xTeUvsPGjih/bGFxDD8IU0S3GUb9cQveybIXYSk8+49c9L001x2J?=
 =?us-ascii?Q?ZQeQSclD0ITFzAGjxwwwoYFB+wrdc04hqPZhgSMQee2dJ7GIA9XSj4ZRn+UN?=
 =?us-ascii?Q?LdIE0Mnoxy1F7YjoQPwctlYUW0yb7FFpMHwUSvBdDDtm1Ild5jFTCLThFd0/?=
 =?us-ascii?Q?HT/7k7ca04ySaTvJbIOo7rzlXlkikdf7fdrIV12OgevwvDrk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0694e7dc-ded7-41dd-9410-08de789b0723
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 20:33:57.0184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eajFENui4QHHZD3rfgCEV67fI2vuw5vrCNvnt90QEtx2+SLb9YLtsUQF9o275+Rp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6373
X-Stat-Signature: haoiepitdphzpx9qniojs4henhp8bi4y
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E29E180002
X-HE-Tag: 1772483649-61814
X-HE-Meta: U2FsdGVkX18Su5CfnXJtILMKWC626nlcIUfRfGtTZ4yWH6A6ErgJoiM3snhNfB5bR8HXRUcN4Cs3qa4sg017nz+2xHwDwV3U2Lh6f2iwr1JTUkEUCPJ9dFBfiUmleL/s3b+wosfcg+dBfLKJKq9IjDljKayg9tDZFhlZI3IPL9NCrYMe4dZYfTjngHhYnlLUqNF6u8v/v92FQUBJW4KMt64s8fg+9zX0Gn/opmoiMY/vPIE47bgMF6MUdanBw96cYkvKYBGxdNmkUlA9K31g+GA2PaENbs3WcAjzuFVQyVp3azK5XLAE97NZFThbkuv0addIM4UawqyjsXZfYFGYfml33U+TASaRwmDIMuRWru7WR/0+WxOjTYa+dadUGBET2cPJoQcVfsZMEDuMuZktm0fPOT6Wy7SQNB1e0TVcZpT7h7uk5cERbCJGXpJsbO5uspIyjvPZGSxeZ3CAGWTUbG9Nq8N5yMUitwFN+Qjgdb/k/a+O55l/3PsQg+Z6rWfBKZgDSpyYMLUrtp+jayAXAZqwFrbu7NQw/sTt0ZrORUBzGJoOQtJVldJohiMSQoeSQ3EHP07DzgeXMikajszczrD4RUbE8gzqxcY4VDU/St0z/C1NkwskaDMMjy98dkQcDK9leY8SRIlB+H4U3ScQdy3ZNaUTzlWRK/7bRgQr55xWFmv2vNA6BOSTDIXmCoAmNl/s5IPc3BW8CbQeDbof1JmsAHCUevSnVGfdfs2Dh0IGS+R3+EcliFCZZ+IP63kSiGxgrvAWy6jmp+b7qcsmPryXk6VOs9FqKBZCW8OStEetNYUKnYubnsguNOISMk4JUatERUQMKoKS65xsVxUM651o1yz05hGIJrxXc0iqwKDtex3IRYfjGPDe2/B0fJn77aRSYgJ0ZBjljIN5BMuaz6ZyTDT5fDlGNk5xYBjbKU6UhULCUEwA1jhYW8CjHrPyTDdfhnTUq2BRmJH+FRH
 6Qor2t9V
 +IAjWtnuo3voyWmKBQ+IJN5bev2DoEt5TjKPoEG0UNU9oKJx4fdwQcaS5F2Ul+3aRsIDL7N/zuUyD7I65YkGZYV3ifBJfA61YvR+o9QIhAA18Bdso0mTFUBLtmtdcv9lTSDnExw3hvj0yijWslpwFNoqoQHSXvs+IBuhPYKPylxnGXXgkGJ6CSm5PsTaWOSEVkYFstNBAljTk3ZKy6zrylNaaDB3nPIk1mK169AYC+yNW1FdO+Cx27MWLRj10Nb8JR661lrNugHutoXo08HigQ7vMyIMvFFGL0mrOZDnJ5CqbnCjYhbV8EDhDDlMmzOzTPcm6rcjMlgAENZbbWuc07fsWQWFoQKG2adLJsETddDAvrAjF/QJ01RXiGFGHWa9QFi2KBYHM90D5iiHlUhy6TzCSQzgQ/IyoKOFF6GSDddM04lCcmMjH53vuyWo8mJOTPEtnPdgrbA5OhfenT+WWl1JuxQO9dDSIMLw5fzeOGT3UKDLIXUzqcyfnmKOnKT7PzJ7qkgopVf8+Yd5bqueMg6w9/MvdjzkgxHrl53DU7b1utX//0wmwSmDnHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During a pagecache folio split, the values in the related xarray should not
be changed from the original folio at xarray split time until all
after-split folios are well formed and stored in the xarray. Current use
of xas_try_split() in __split_unmapped_folio() lets some after-split folios
show up at wrong indices in the xarray. When these misplaced after-split
folios are unfrozen, before correct folios are stored via __xa_store(), and
grabbed by folio_try_get(), they are returned to userspace at wrong file
indices, causing data corruption. More detailed explanation is at the
bottom.

The reproducer is at: https://github.com/dfinity/thp-madv-remove-test
It
1. creates a memfd,
2. forks,
3. in the child process, maps the file with large folios (via shmem code
   path) and reads the mapped file continuously with 16 threads,
4. in the parent process, uses madvise(MADV_REMOVE) to punch poles in the
   large folio.

Data corruption can be observed without the fix. Basically, data from a
wrong page->index is returned.

Fix it by using the original folio in xas_try_split() calls, so that
folio_try_get() can get the right after-split folios after the original
folio is unfrozen.

Uniform split, split_huge_page*(), is not affected, since it uses
xas_split_alloc() and xas_split() only once and stores the original folio
in the xarray. Change xas_split() used in uniform split branch to use
the original folio to avoid confusion.

Fixes below points to the commit introduces the code, but folio_split() is
used in a later commit 7460b470a131f ("mm/truncate: use folio_split() in
truncate operation").

More details:

For example, a folio f is split non-uniformly into f, f2, f3, f4 like
below:
+----------------+---------+----+----+
|       f        |    f2   | f3 | f4 |
+----------------+---------+----+----+
but the xarray would look like below after __split_unmapped_folio() is
done:
+----------------+---------+----+----+
|       f        |    f2   | f3 | f3 |
+----------------+---------+----+----+

After __split_unmapped_folio(), the code changes the xarray and unfreezes
after-split folios:

1. unfreezes f2, __xa_store(f2)
2. unfreezes f3, __xa_store(f3)
3. unfreezes f4, __xa_store(f4), which overwrites the second f3 to f4.
4. unfreezes f.

Meanwhile, a parallel filemap_get_entry() can read the second f3 from the
xarray and use folio_try_get() on it at step 2 when f3 is unfrozen. Then,
f3 is wrongly returned to user.

After the fix, the xarray looks like below after __split_unmapped_folio():
+----------------+---------+----+----+
|       f        |    f    | f  | f  |
+----------------+---------+----+----+
so that the race window no longer exists.

Fixes: 00527733d0dc8 ("mm/huge_memory: add two new (not yet used) functions for folio_split()")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Bas van Dijk <bas@dfinity.org>
Closes: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com/
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: <stable@vger.kernel.org>
---
 mm/huge_memory.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 56db54fa48181..f0bdac3f270b5 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3647,6 +3647,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	const bool is_anon = folio_test_anon(folio);
 	int old_order = folio_order(folio);
 	int start_order = split_type == SPLIT_TYPE_UNIFORM ? new_order : old_order - 1;
+	struct folio *old_folio = folio;
 	int split_order;
 
 	/*
@@ -3668,11 +3669,17 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 			 * irq is disabled to allocate enough memory, whereas
 			 * non-uniform split can handle ENOMEM.
 			 */
-			if (split_type == SPLIT_TYPE_UNIFORM)
-				xas_split(xas, folio, old_order);
-			else {
+			if (split_type == SPLIT_TYPE_UNIFORM) {
+				xas_split(xas, old_folio, old_order);
+			} else {
 				xas_set_order(xas, folio->index, split_order);
-				xas_try_split(xas, folio, old_order);
+				/*
+				 * use the to-be-split folio, so that a parallel
+				 * folio_try_get() waits on it until xarray is
+				 * updated with after-split folios and
+				 * the original one is unfrozen.
+				 */
+				xas_try_split(xas, old_folio, old_order);
 				if (xas_error(xas))
 					return xas_error(xas);
 			}
-- 
2.51.0


