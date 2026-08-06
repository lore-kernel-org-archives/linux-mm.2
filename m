Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A6FFC56203
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:28:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A64C46B00A3; Thu,  6 Aug 2026 04:28:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13D86B00A4; Thu,  6 Aug 2026 04:28:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DBC86B00A5; Thu,  6 Aug 2026 04:28:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 564BE6B00A3
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:28:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D1F1B806B0
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:28:09 +0000 (UTC)
X-FDA: 85070167098.08.6BF2419
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012055.outbound.protection.outlook.com [40.107.75.55])
	by imf02.hostedemail.com (Postfix) with ESMTP id A4A6B80006
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:28:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b="Wem80y/e";
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of xueyuan.chen@vivo.com designates 40.107.75.55 as permitted sender) smtp.mailfrom=xueyuan.chen@vivo.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786004887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JXgnGDHMrjFJ/navqxl286/bPe0PHXODlTow0ly9/zk=;
	b=SJ3sEEJHBJ3UWi4ebr8AMMI2kNBlaUQAqyvIbpLcdPJV72I7Jru6LjHBDk+wlkkU8nSv1J
	RgeuV++YzkgIPx8ICBSJEAjtmnA4w9KrjAuaq8fr8mkUZr8KGUJXst0runNI2FFma7kuJH
	Kx7b10+mFNhtJw8csg71/kyiUoP6/gY=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b="Wem80y/e";
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of xueyuan.chen@vivo.com designates 40.107.75.55 as permitted sender) smtp.mailfrom=xueyuan.chen@vivo.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786004887;
	b=umHegKnFPgD3wgweJWgQQws++gy1mIC9J0VEbimu0DdLeHEHO0WKzZQt34+aicMG8LgXHe
	ro6U96sSh6CCeZ99FXK3sfm0kWgnDRIdx6C2UvtHHVUTQMiz/YdO8NIkfjgaEnpNs8t2Y/
	hviwWlogR53gGYp2/YJ0jSia4HkP7OU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mQenibHH7z33vvSwr5RJUeFJbphvmmzvKi8enbjES9ckhABHyKSAr81BkZQzN7r/nkStYzfJP/pANOXuox3xpHQhppMESozHhDUX/JXuSpEZDq5eSeJz880/1xTWmcf6+jsjaIc7l7DjgvuWeIdjl5SjJQKuL++VOlne8NiUEBnCpf+pDo679Er7K0iLAK15kW2/p3nYYFRR2FUaa7heNbbRVZZyN9D13lB3MYOK7pdZyq5p/CfaMK/kIh/WC3bovigWQAkMmnLse6pJ+gnZCdH8C29pF6fWJ2eH/Cgaw4sgNMomhWWZ6acwcV2JyD+MUVlievRTSa/hhVyK+yaJ+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JXgnGDHMrjFJ/navqxl286/bPe0PHXODlTow0ly9/zk=;
 b=sG8wIEEL9NuuK8s/4AbRS14oZmrCSji16LXt85AbmHqclq2IDTQM/yy+UhTRm815kcrWtpNZNeeZXWXuLUtm2MIdvk/l+JIZIlyTe1ZMS1RlGmLS+eLDsbJKRs52FOlYJPxHxONXzHdwWR6X8qXui6Y+smdwKURyl2ZH6oxZpuzigVC4cxyuGbafmOGxD6A+lqRwN/NknXzIJ2J9DW5HZ7uDQ8nZ3CVlZ0TvAih+jd2AQ09eeishzGUKxnOX0RJm+yb0ch++7wXYF8yGTpKaeOy6jHzhneCjhG7hs6kDofVQGAhuVKHrpsZSYyMelYJZucocs/WM1Yor4VlqcPFgrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXgnGDHMrjFJ/navqxl286/bPe0PHXODlTow0ly9/zk=;
 b=Wem80y/eWb5PGCfkNxmDo3h8b6Y2CzMC8Jo5+/vdV24ygA+34ipncIE09Qre1MN7cMwj1IhMSJmodRoxlT6LpoR23aPwL624Qcp1XsMU+mzrzz0ItOXvtu7uZFevZkpoR5wOAc4hL9NmZpR5OVcQ3b9nJ92++OlGXWug9TBI/tS8GLk6JPZEn3tAdrNNLOYfWbr6DXqt0dVIiFIwwgN7LRBdg+PVC4vwzbAswPffszELMzejgOt6u0UtpnZCbFNm3zMUd6lIdlyWc8zfuLO/NVswSqQN09pgtb8a+f788q3MVUHFLs+9rOCIWip6FgPs2QbhNv61K21hCKubi/PumQ==
Received: from TYPPR06MB8235.apcprd06.prod.outlook.com (2603:1096:405:383::20)
 by SI3PR06MB9209.apcprd06.prod.outlook.com (2603:1096:4:2ab::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Thu, 6 Aug
 2026 08:28:03 +0000
Received: from TYPPR06MB8235.apcprd06.prod.outlook.com
 ([fe80::6ef9:8fa6:5ebd:96]) by TYPPR06MB8235.apcprd06.prod.outlook.com
 ([fe80::6ef9:8fa6:5ebd:96%5]) with mapi id 15.21.0292.013; Thu, 6 Aug 2026
 08:28:03 +0000
From: xueyuan.chen@vivo.com
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xueyuan.chen21@gmail.com
Subject: [RFC PATCH 2/2] mm: zsmalloc: use the shrinker reclaim budget
Date: Thu,  6 Aug 2026 16:27:36 +0800
Message-ID: <fe683af42ecbf7e841bf1a5614b9110253d6ed0c.1786003779.git.xueyuan.chen@vivo.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1786003779.git.xueyuan.chen@vivo.com>
References: <cover.1786003779.git.xueyuan.chen@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0188.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::10) To TYPPR06MB8235.apcprd06.prod.outlook.com
 (2603:1096:405:383::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYPPR06MB8235:EE_|SI3PR06MB9209:EE_
X-MS-Office365-Filtering-Correlation-Id: 91d29345-64e2-460b-42d3-08def394a1bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|22082099003|18002099003|11063799006|6133799003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	gf+gmRkX1S5xSrwJ12loHlBSOerXNZac9vHzTZdz1KhpuP+JKW/+1Q+pUgUq67HMEizZHUlXBWfWANTUSIw82+ApD3r1mKK4QGOQr9idRjrzd2US2JLOmRPH7Lpm7srlGjmT0Lj/jiN86FiueguPAWpjYvktfZHzAoM2KHZXu+oje998mObIRr3/4gyPNq0t/54zZQgktta4IeRpSF+lmVMdQ73mb/WYEYMmAXHZrdpf4zcjzVgCg52LwjxibQKYGnOXXLiHZvWqg4iEEsf1T9LqBSFKWaFZDTuFdL6pwDyaLXNPVQqH43IX3Bxg1UTVRFF6yDVl6J5uDebMDCiLMXWhXpuKVia0LmD7mXkgPrDgpmVDLCOnD+qxay178jgZsE71XALHDwnYYVq6VSmKkL/kY1g1lTAYHuEvUwEHYslxbgVGVxoNOr2OsvWC7oDdCgfnA4wtkndRkszvDQTOjudqJPyuyGaKX+kDxmPY0oE7J8PkYIIoT2R7FSncW4cJ6OQ+lJBDTURU/xkSoFhpfkDeUBP+B6dQRFvyRfAMYnRdowdOhIeodu2giGKk4J+G6sgn+QyaFO3PbNMlJ37Rve/Qe063VN/tVh8LQCR1JEnxWj+DxNrIKd2ophd9xZePslCAr+VaCsbobq2RdihPrZSO3ZO/3v8PXWVdZqZpH8U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYPPR06MB8235.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(22082099003)(18002099003)(11063799006)(6133799003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1kntjSf2zhvaStD+ZF+XiYBp6HDtlYyRCj2nBdlCOQ3sCacu9WenYm0Q5c/4?=
 =?us-ascii?Q?YlpXgryVgy3AJ9ZuvmrXvEUhESP2nhxw4wzLV+XcPkqFLoA5xzX4clmQxaS3?=
 =?us-ascii?Q?wUlkYv2DY0A8vqZMSeyulxmfN2C1TusajVdBrdb1XFCUBTNjiZgK02bs/6IB?=
 =?us-ascii?Q?o4TFWpszUB8OFUv7ob5vlOUhyCUfSXdjHlzYQHbp1fv2Lzvo4cwZnsGeikAa?=
 =?us-ascii?Q?RL4iiYNY8IS5eZ06eUY1Vh9Go6gOFM6vbRSpkMrr3wHbrdJHtRPm8PbixAvB?=
 =?us-ascii?Q?imjL4EY9h/8lMfJtdYLylJU93Fl+SuKdJROyYzxf+YXQR0vjszg2+22yKrQU?=
 =?us-ascii?Q?LU5v8cFF7/nb+NzAeRyBepj5BxANjvz/8EnUHJFvigcInBJHxG9fOsOEAvsH?=
 =?us-ascii?Q?tfcM002c/ukvG2fmv4dMFNt8aa07Yvuba5YYYpK5Cy8kHE4lV6vDxgOtHztA?=
 =?us-ascii?Q?PxsUN682RZAULR883FRJaQVS8cBtZruTx2b3C8wOKGl/d0MCWr7qxXaTcypH?=
 =?us-ascii?Q?tvQaQXhQEjCWYXJhgBv3MEJGfv6GC+ARR5+7ZVZfsAG4/f6jPO0c2/6/jMV1?=
 =?us-ascii?Q?pAfFoK39DqeZACOzmBomKIHZHMGTfvRATub4iT/4qHkQgFsizudkDS40CgzT?=
 =?us-ascii?Q?EcEEYzB3yNH3PUFgxdS2OP4hQJ9ZAex/A5m/BtDmHNprrPZ3WKoxdh/Whnzy?=
 =?us-ascii?Q?y/Me4xxmGDN4Mf764QCXPpFhV1nQ4FL8hQzIiV7lGFIZScV6DG2MA6vW5xNW?=
 =?us-ascii?Q?bGbnv9fn/oyja9/uoKyk2YW4xDid7ZYaJJ5j6ffIK56UI4uV4iBDWgUxpBdA?=
 =?us-ascii?Q?XY0Zs17EB9vwQVZ3gmpiIIaeuMHM3RwwxxO4EUse/cmR094EyMkMbxbtYtNk?=
 =?us-ascii?Q?zFBS/Q1N3iZlE9YvBm8bMJF1gkaX1LoNlA0mgTr1TOJOK1EHOTwbvlDUhSSf?=
 =?us-ascii?Q?/U8PT1z2F8RFXUhlA7kHNp/jdKdQluGMEEiErj8AU0MkUi3/yoB/iM4xtWwC?=
 =?us-ascii?Q?UAj39dtKrqjlmHeRMT7qW0CGK3coUpIPSMUUl4f1AlnuPGo7RarRIKf76NEQ?=
 =?us-ascii?Q?8r5KYj/TqPPUzGnFt7MQP8Ef8Dz3E1naFDKmC7wb32BYQBVDazN1n1PreXGT?=
 =?us-ascii?Q?VE+XJqW+DTj0dciCXJ062wOZEN7yUjg5iAUGwzThxe7mghPJ6PKjfNHZ7sn4?=
 =?us-ascii?Q?hBHHecn5fWUUI2AKRXp2vMPBDmPcvFSdNqgjrW9nrJbOoHy1NbNduYJ+SlFc?=
 =?us-ascii?Q?J95iwaB7KIEiSQd7sll7yEViusKUQStp3izAAsdxinwLLetVRduPe/soOhP5?=
 =?us-ascii?Q?GC17qfk8/64tfSAzWOv4E7JPpbItSgkARMGPmpkbbeqFM3q/mQA8UXOpgv2p?=
 =?us-ascii?Q?TavFHeXUHCchd2RAC/vRPLBp+rvGkYCFUhFyusacoqyQnWgprfwAan+9RCF5?=
 =?us-ascii?Q?Bm0MTs1GUKMpt13kncg0YgS7riQT6b5T9oR9oqGxefyrdFt+IpOsm0dSEKVm?=
 =?us-ascii?Q?0hGi/c3J2MSs0YNp7f1acLvjI7V/6DU+UC6NT2NYozVg2xzDdM1vq0AFS5kU?=
 =?us-ascii?Q?4OE/YsfKELKsnD3QNoPwIxYuNNNCsfdDPYLk1i99eeGoDKAkyaxkZTcThF6E?=
 =?us-ascii?Q?oKL8Uv4S7mFynWSTB1twuSlDLiaDDDOy/PYxNKX40sszkLUdZpW+WDPgcMAE?=
 =?us-ascii?Q?SBRc0SmNu1jwTkYg5DrQOcjf300d+yw5STQA7MtwtS9/2JYS?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91d29345-64e2-460b-42d3-08def394a1bd
X-MS-Exchange-CrossTenant-AuthSource: TYPPR06MB8235.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 08:28:02.8557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KX5TrS3qX5C2cn00meKA547pWV5DYgXyuE/FGXLf5Z3xBMOenxkPEkL54VuuMi0WvTjYoucrk/G3vbNmPDTZYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI3PR06MB9209
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A4A6B80006
X-Stat-Signature: ueruy3pyybi5iz1jt4fkzxu3kh9b5s3u
X-Rspam-User: 
X-HE-Tag: 1786004886-400377
X-HE-Meta: U2FsdGVkX1/6x5LXd3X/7zZ+Bz9+CDoiSiQdiQTpIMUAGpVyPTELDw60j2j/DWe9ny9u0UDyWN0bfue8YosusTj0Yfr7XpC8DWpGCh5N9eft+2TiBrERJOftMg6vlc+9hQ/XHZ0OTBszmGdkTrVe3IEx6nY7+f/ZYe9NBdUu9z5IZo0FWIolwiCEH1JcZG4hO5f+Cwy932kkQVUTqnOZS7gvCV5NSqAbj+w7OmxWDxwEBdkPi+kPubh0svWp5SZ2nkq82NnvbUBzBIMI/MvhZdzCVz1gsZ6sW6hDHbrpVyBz5AIVOWPQrvoT1MGpKeA/BT1G+kcYR4Ljjm1hCn0vQCaEeH+Eoz8Qgi6gxSc97TjAEyKCDPNoHuj0X/1T9y/RaeF1QglH4OI3BOV3QNhyoYr2zu0dd0WzpASDuIYhcFybjAv5+MrpoB3w+Sp/X0PRxaCoEVkne5kmzOx0CfzqDb4YaiIjOXuSJ9gQEriV8Mf6KM9YTWbK9Lvzhvoegvsrg1NDAtnFfs+Vx9D5jXWOwd5k//NtYlIf9Ef1aU5D4k5V6oJ/ZR80BFMQGEW+lGd2Jqzn0UTL47n5eoDgQIV66FJyk0mlaYHpV0LvEXFKR86nPibaxuuw91lcf1iq4NaegCKQAjc2XaRiHFByF+HhzFGHVxI3tX9XyZk7ou4/FAHEgFEzq23x4A/cDganJ4xViUAwqRiCzhWXfexcfIrylkzTiMi2PaELSW6IcRenRXNAUziHU5Okjq+CTRRQBaZJK4MQHpmOJPxIuXCOSSitZOdE/wAGhIaXqBnDgmQbbRcFBBW7dn28LHHns4G8QVLL1ijev8ueiJpI1uRI11bYd9Wnp2JDD8TmzWvWpXBYjTFIvvUxjvcTVArJrx/IQQRMV+G5hqz7XDK8rnaH0XneZ6pvHRkh32QEBoK7eDwrT6RZ0G0G4sD8GvBLj2upS6VIeXVNGlW0hybwMlNVzT6
 HTxD+jJu
 ZafJkcsjkc9n1jZ9UpWMoQpuoV6Ic1T9SZ/ktnYuZgtIFgQMe3LAoS7uv1ZZOMdvYHlmlHNV95UNv9vS6EXKdGqkDPvPdF3F9HX6MO7RmplitJ6xJOAdW3PUz4n8rMBGM6nnpEeNbugaKJDerJ6xflCsdrO9KQkSC2qe+3cCzXC9AtnJxiL4IOBaDQUHzAsw2dZD3qc30WAhbVZXH1hIKw6oNmibWDAlGLRlKNwCrRrCAF4S0eS+ddyKePFH9lI5yunPqUq4Key/Cs3nJrgrpbW3VffO14IcbxrCD4N8dqUpZslH2n1iyaVQtjk96fjowA2V9MX3W69tx6QBupw/hEHU9MO3RfDe+fNjpHXUZjXDzI96lSGiGpqsD/RiguDwzigZ9+s600ce4XPXyKnzlWZXBu4MRO6eCD35ryIryfayERsohbvJUMNsOGztIYoYzv1GGqCmtY6VJYGQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xueyuan Chen <xueyuan.chen@vivo.com>

The zsmalloc shrinker currently compacts the whole pool for every scan,
which can do much more work than reclaim requires.

Use the requested page count as the compaction goal and continue later
scans from the previous position.

Signed-off-by: Xueyuan Chen <xueyuan.chen@vivo.com>
---
 mm/zsmalloc.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 334d24093c64..aa5900ce2620 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -217,6 +217,8 @@ struct zs_pool {
 	/* protect zspage migration/compaction */
 	rwlock_t lock;
 	atomic_t compaction_in_progress;
+	/* next class shrinker triggered compaction */
+	unsigned int compact_cursor;
 };
 
 static inline void zpdesc_set_first(struct zpdesc *zpdesc)
@@ -1949,9 +1951,10 @@ static unsigned long __zs_compact(struct zs_pool *pool,
 }
 
 static unsigned long zs_compact_pool(struct zs_pool *pool,
-					unsigned long max_pages)
+					unsigned long max_pages,
+					bool use_cursor)
 {
-	int i;
+	unsigned int index, nr_scanned;
 	struct size_class *class;
 	unsigned long pages_freed = 0;
 
@@ -1967,15 +1970,19 @@ static unsigned long zs_compact_pool(struct zs_pool *pool,
 	if (atomic_xchg(&pool->compaction_in_progress, 1))
 		return 0;
 
-	for (i = ZS_SIZE_CLASSES - 1; i >= 0; i--) {
-		class = pool->size_class[i];
-		if (class->index != i)
-			continue;
-		pages_freed += __zs_compact(pool, class,
-					max_pages - pages_freed);
+	index = use_cursor ? pool->compact_cursor : ZS_SIZE_CLASSES - 1;
+	for (nr_scanned = ZS_SIZE_CLASSES; nr_scanned; nr_scanned--) {
+		class = pool->size_class[index];
+		if (class->index == index)
+			pages_freed += __zs_compact(pool, class,
+						max_pages - pages_freed);
+		index = index ? index - 1 : ZS_SIZE_CLASSES - 1;
 		if (pages_freed >= max_pages)
 			break;
 	}
+	if (use_cursor)
+		pool->compact_cursor = index;
+
 	atomic_long_add(pages_freed, &pool->stats.pages_compacted);
 	atomic_set(&pool->compaction_in_progress, 0);
 
@@ -1984,7 +1991,7 @@ static unsigned long zs_compact_pool(struct zs_pool *pool,
 
 unsigned long zs_compact(struct zs_pool *pool)
 {
-	return zs_compact_pool(pool, ULONG_MAX);
+	return zs_compact_pool(pool, ULONG_MAX, false);
 }
 EXPORT_SYMBOL_GPL(zs_compact);
 
@@ -2000,12 +2007,7 @@ static unsigned long zs_shrinker_scan(struct shrinker *shrinker,
 	unsigned long pages_freed;
 	struct zs_pool *pool = shrinker->private_data;
 
-	/*
-	 * Compact classes and calculate compaction delta.
-	 * Can run concurrently with a manually triggered
-	 * (by user) compaction.
-	 */
-	pages_freed = zs_compact(pool);
+	pages_freed = zs_compact_pool(pool, sc->nr_to_scan, true);
 
 	return pages_freed ? pages_freed : SHRINK_STOP;
 }
@@ -2094,6 +2096,7 @@ struct zs_pool *zs_create_pool(const char *name)
 	init_deferred_free(pool);
 	rwlock_init(&pool->lock);
 	atomic_set(&pool->compaction_in_progress, 0);
+	pool->compact_cursor = ZS_SIZE_CLASSES - 1;
 
 	pool->name = kstrdup(name, GFP_KERNEL);
 	if (!pool->name)
-- 
2.47.3



