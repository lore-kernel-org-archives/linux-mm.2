Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8007DC87FCC
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 00:31:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08B788E00CF; Thu, 24 Jul 2025 20:31:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 063C28E007C; Thu, 24 Jul 2025 20:31:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6D0D8E00CF; Thu, 24 Jul 2025 20:31:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D50D88E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 20:31:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A936B8978
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 00:31:37 +0000 (UTC)
X-FDA: 83700908634.18.B4F950C
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8BFE71C0007
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 00:31:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=J7W2Ddf8;
	spf=pass (imf20.hostedemail.com: domain of apopple@nvidia.com designates 40.107.220.60 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753403494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=McHpF7fs0ZtWgt9rj63Lo1qjo0W28rnoOicxQ79ZbcA=;
	b=OjaFAUNknUJ5ErxzFKXi2zqsfbvSL3RckEzpa0ziuHWCRvQx0Oe5OcMVapwbk6orVKBZ9b
	/o2HJ2siGvBQHI2b1POUnIT1eUJB9M7obwhOF1ks+po+TEX585/SIoeO7L9SqzXLClNYks
	qQxislyuFB1nJhdQe46qNhMaQER+ZB4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753403494; a=rsa-sha256;
	cv=pass;
	b=VFzGC86gG9oYiDUh6Xu7/58HS8e+YuHXkbnmju21ixQDdmg5vt8YJBUecWgHRu/Pdj9xZC
	cv2AQ/8pfoLxE8LVsqcAgMnrUzVLE44Vx7XVgk3lBXtRw2W3X8643MUTo4QowgTLnunQvT
	yBng2xpLcWXXfsIJkMyE08zWnAXV2IU=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=J7W2Ddf8;
	spf=pass (imf20.hostedemail.com: domain of apopple@nvidia.com designates 40.107.220.60 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NAkKw/SWfGoeG6tWtKOQWLeIHyfinuo0xpUyQeX0h25uOpJUgfB38lBBGudGOEIfjkgogH1v7RsWZMHXjrpl8UKV2EqNzoyDaEH40+MR3mx2bePOH537/YrqepP4J7eOagqrogLNDOVGyNzSxwxSswuJ2Bf8CH6tH79NvRQJdftAbJ1X373mA+7eSpZlQCFh0V3FhpwpYWGb9yseokpj7BiHiXdcX1WtKMRe4tFF3t0GUT0Edu6Olx+t/w4drsLeJYKHZHtjHRT+7j7ht7nrqj5RRpZ/nXlCYjuIYU0l+fmMncOOEKbNhJZz8XH70a/JUrmPFd8Blxt5Z52f0DAs1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=McHpF7fs0ZtWgt9rj63Lo1qjo0W28rnoOicxQ79ZbcA=;
 b=plvZSwnRaMDXVPrFERstflsxALr6TYVJlAq1nu+sbopDXjwaiMg7lAsb+BneA2qAhkqLdF2T4Al5jMg0+b0BYS1y4ZZw/Rix5ndjWhnLIZWEeHVgOBPHUD+UsM22dgziBEKnJp48eZjvb+x74KIK8yLA5vEE3jQhnnROJ20jQMKSExZGU+3yH1pbUFC+S5B95WuZMChAClj/UXnmHuyaGnfcOAWh+l/XnGUtR7QF/f1TW7N+GGokHSKE4MTqpQaup8TlvqLT59NiWnZ4Veg2faFTkj+v0ka7BLY0hCa0v9mXhbPuxuz+jjbz/PDbeJusqnPWFGEoXLnsVXj5ZMCqIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=McHpF7fs0ZtWgt9rj63Lo1qjo0W28rnoOicxQ79ZbcA=;
 b=J7W2Ddf8uZLTz7e0M5fPxQ45OQiQRxLObxojJhQZFkIbmyoi61vPz/LawJvUXG4LnsPEF87+nN4UdDkYFgDDULjZ+bb95myTZHyo6g53pZ6jVgBTsPuc2lHJ5qYmRaLt0/e8YO28WZ0B+xc4zi0Pitq1hDO5p/6JEe/u7uds+b46f9RqX7/pIzrydS9QOdb0a6qwXPRDJXpCuAmtixBcAm2dWimvsNIWl+ZzRmDBk6Cc6MchO3ilGlPcRkqLovc4hTNAmpS8faDOQ87mtEjjCs0eyfe4lEUdYbXwknwEY4LgTS5gW/DqtBANiD6J44ltBETtu9CER9IFW+dSU0B9XQ==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 PH7PR12MB5949.namprd12.prod.outlook.com (2603:10b6:510:1d8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 00:31:30 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe%3]) with mapi id 15.20.8943.029; Fri, 25 Jul 2025
 00:31:30 +0000
Date: Fri, 25 Jul 2025 10:31:25 +1000
From: Alistair Popple <apopple@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Matthew Wilcox <willy@infradead.org>, 
	Yonatan Maman <ymaman@nvidia.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Leon Romanovsky <leon@kernel.org>, Lyude Paul <lyude@redhat.com>, 
	Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Ben Skeggs <bskeggs@nvidia.com>, 
	Michael Guralnik <michaelgur@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, 
	Daisuke Matsuda <dskmtsd@gmail.com>, Shay Drory <shayd@nvidia.com>, linux-mm@kvack.org, 
	linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org, 
	linux-kernel@vger.kernel.org, Gal Shalom <GalShalom@nvidia.com>
Subject: Re: [PATCH v2 1/5] mm/hmm: HMM API to enable P2P DMA for device
 private pages
Message-ID: <i5ya3n7bhhufpczprtp2ndg7bxtykoyjtsfae6dfdqk2rfz6ix@nzwnhqfwh6rq>
References: <20250718115112.3881129-1-ymaman@nvidia.com>
 <20250718115112.3881129-2-ymaman@nvidia.com>
 <aHpXXKTaqp8FUhmq@casper.infradead.org>
 <20250718144442.GG2206214@ziepe.ca>
 <aH4_QaNtIJMrPqOw@casper.infradead.org>
 <7lvduvov3rvfsgixbkyyinnzz3plpp3szxam46ccgjmh6v5d7q@zoz4k723vs3d>
 <aIBcTpC9Te7YIe4J@ziepe.ca>
 <cn7hcxskr5prkc3jnd4vzzeau5weevzumcspzfayeiwdexkkfe@ovvgraqo7svh>
 <a3f1af02-ef3f-40f8-be79-4c3929a59bb7@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3f1af02-ef3f-40f8-be79-4c3929a59bb7@redhat.com>
X-ClientProxiedBy: MEVP282CA0051.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:203::16) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|PH7PR12MB5949:EE_
X-MS-Office365-Filtering-Correlation-Id: 57c29ab5-8a14-4095-279a-08ddcb129984
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OK22Ro7AaxJnGBLNRBjxz0+pZf7WaIzm118c9VTKX6diHqJwk1YF3ru/1rv0?=
 =?us-ascii?Q?H3Hab+Ja4U94vAt0EG46vuzVjOXwAopEOAPmLbePyeDnPC04faSGyJKtN9UH?=
 =?us-ascii?Q?fGWes/H+/GaF2NK3GbJhc6oJh6olzK4UocX2OyztliCyLwHVWkRpoQslIYOV?=
 =?us-ascii?Q?PHRIROHX5ARTrUiPFxpA7IG7yqcHa8d9/aKFxEyC7kJI7IabsX0mFBeFTbxT?=
 =?us-ascii?Q?40mMm+216dU6Zlji6J1TmamE76vtmB1QuZ15JUXJDZ4HNGJLeSFubWr5siEE?=
 =?us-ascii?Q?Sr0Nvje+Tz42d4O7IL0wo9s52FaGlNokDO9oYhz8JyyS/jcyE0mdiuH02Oin?=
 =?us-ascii?Q?+9ebPBU2zMd9XmQd9yGinvvbr5YrEbaD1hWh4TazZK+aAY4Ycg2aBe0GorAc?=
 =?us-ascii?Q?OpzZmjMkfu99+Fb/tUni/0YcbiIZ0plpMBHQn+J9CgUM3ipkrCUEopbKhh4+?=
 =?us-ascii?Q?CEy2Tu2LKB8NiJhFi1L6dHGW6jVR65kle1wpjIXq3l7pjIP9P6G8f5bN8IrS?=
 =?us-ascii?Q?8dV4x6OIS4oSQeVcNQQxH0mCLKIYxstcGRd0Z5v98V3Q1rfKPpaNEBCTNmpk?=
 =?us-ascii?Q?aRgSQIsH3+0Qagrm2nUMgZPPKOUz4P4ihzOpx93P7PEuLIbxtvr70DdCSLF9?=
 =?us-ascii?Q?a5fuSoq9ICUbuEFaZm/qTvQyKrF2EPDW72yhCZC2NODIVVwFAJYDzZmDDq08?=
 =?us-ascii?Q?7/TU/oOUmuOJs13pqDH72VRjfDbKdzmyRcxttPBp5SFS9i50cC4Uv9f2oliq?=
 =?us-ascii?Q?W4UyRJm4vPd7gZiV3gMTPWljuEX5TP/BtEVhnVOt9svUdNlTc3VcFK6elUEF?=
 =?us-ascii?Q?3pbBlnpn+Y2FGor3NZ5uvsn8SBO7lqR0TlavdMO5C6brgJX5E0agAPOk7Sxc?=
 =?us-ascii?Q?3H+3C32/OCbKrXgVAlt1Z480oDnu2hRNAJ9R3e8AdTtGaJ5BTr6GaAoU14wy?=
 =?us-ascii?Q?Ohc4qG88GpQdENvLqqqTnx32KxgmhTrROiwMd9jTEpLXksTyOcCiRFgDnwBV?=
 =?us-ascii?Q?8473D2fDFrFlx4VSAy4WPCuSM6eD4V0ElnbJYioV5N70dkgVpCrwGtWEGcK2?=
 =?us-ascii?Q?fyHKATyI+YeXHKCvWLgjyCDyIQLRBgHmEUisRapc63/Qx5BFqsghtu9ZS4Uv?=
 =?us-ascii?Q?8oKJH3pyiT/ONLzwVzKcqLc9E/yWS/WyJ+vdhKD6n7qJto+nrOzRtj4NaLlz?=
 =?us-ascii?Q?rcCzwp8FSOlFwGSRivEdLnBKxirAb4IuhfP98WYeAiN/wipjgOP8WqW/3oxa?=
 =?us-ascii?Q?lJMeSmx4yIGYLk6f2NKnFj0q0JyvOIqE280PkXNH5t359FH5lAbeAn0Vh70n?=
 =?us-ascii?Q?dHnCnGHYQk0kstfX5ivYpR8J+dKX154LVEeQBOhG/GroIqPFSKBVSp3IOGaH?=
 =?us-ascii?Q?hg5V8lNMMvcwWz078CYAodzXJDEqrG1W6ljC0Zt1ifelmA8lmA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?M/zma5Eyff7c2na5r7ZCFgcTDee4MhnuqC9+5+8M8L73ke4FQqf99IN9XzCd?=
 =?us-ascii?Q?nmEates+6gXZ/jBRtXUOrHPGCqgeqPaA/n+OFzzY49nnyly3RufBwgm6ts4J?=
 =?us-ascii?Q?duplRlTTRD0gUsJSUywsOpht9o4uyMzRbAJaAkfT7Wc4X2DCDjg7wswQVxtR?=
 =?us-ascii?Q?zGJZtszuuePrEf0ix1S93E6SaL9eEocYith5rSWkPkqe3qdgPsFgGzzaO93R?=
 =?us-ascii?Q?oWt/2FNQf6+1QOB/E3a1F0YflhOtRmIFhErCHaUiB70WV/6xWso1zN3qrbF5?=
 =?us-ascii?Q?WJXYrqFY3bI4XaTp7dRQ5Mec3s8CPZLeYNiwsQlWOUOWZztLgPDT39CHk+ZX?=
 =?us-ascii?Q?9zaA+sIq/yYrLwMnG9ZO6wWaQ9k83qOB1hT/MVMJZGFmzxMRhWlHoYb8ESv1?=
 =?us-ascii?Q?2ZZb28OHLEYZoOBhO7RIg7Phiz7Td+sDykOP4x4EWdKqnYwPsptjJuClFFIf?=
 =?us-ascii?Q?9bT9dAouC9Fkk4ldAp/emyouHB9pm/j/IKoELQmUZStLTctAq08m/4txXWsq?=
 =?us-ascii?Q?EtISrV064ZVaC+7nyjYe5lj2EGpLg615CeOsAc80SKzg7y75qFKQb/NgeeyE?=
 =?us-ascii?Q?9ldIXMMvcPmEToCh9m1geZNNYdU4qVUKuyk4x4wBEdxgy2LBXGRdm0TEZ1yj?=
 =?us-ascii?Q?oIbjx5hy56wWTCxxPDm716fjgWrKK4qbb4wukG/hgdLu3WyaIn8cnJehaZMm?=
 =?us-ascii?Q?LuE3yu+GC1u2K1w2zHnKgvDUe2o7akLe2+faMyHEI4nnjiO09kR0eFzKErbd?=
 =?us-ascii?Q?tYodfwfOEKzTqbngjimO/Wxyw/TB8Vlo7jHtOl1Tu9eGYiRwzr3QqmM9MWJp?=
 =?us-ascii?Q?45cSuklX4BMtcI9V9ayTxn5rKSQDauW77X33v0uHIuW1/k3LtbB+ERRRGgi8?=
 =?us-ascii?Q?W8iJWOJ0yfVoTivRfq/b/sPrKU5mYV0E+N0sxUmVMBCpX+BIErsqUj8g0UYS?=
 =?us-ascii?Q?BRlvxLzTEiRCuANS/shTX2zL4NOFBThMhLc1sTAopacH8iEgeeTS3wBBDt/d?=
 =?us-ascii?Q?TRNXgHojXDwewwUXbyE5fQVKOVvmyMXQUcFRp2h92cBuJUB32rgQOmxQ9fB1?=
 =?us-ascii?Q?bFLLBYIHc87uFwjr4Brk5hYwOl5yev6YxByvyehNZZfNM2SjuMo7pPUoPBLN?=
 =?us-ascii?Q?b+GhC/7hqweuhy3BZXmDMl5Dju12jSITg3vf3rNcQ0Fa4m1neZFtXHMvbpQm?=
 =?us-ascii?Q?3x8HmAR/nEPoJG+nxxm34XRRMlBDfSk0L2ZyIcYLIUV6oiB6Ykcv6hQtVL7U?=
 =?us-ascii?Q?Qz8Bz9v1I6tQuryX7HZKw5p7+gYXzi9E+R6w+E3OciZA/v69v3JvKk71cHtZ?=
 =?us-ascii?Q?WXLykcDrGRzCo3ksLy2bRJnahujuwt5OMlMVZBufePrDvkhjh8sIHQxErLjr?=
 =?us-ascii?Q?aZ67nazo2bo1tZMVULzfCDtVbpapdrtBpjBv+cJcq7dVIQnLitQt3hXe3o8F?=
 =?us-ascii?Q?IrQNhYQzMEWgOEt6Td+dyRTuLXpGbCNQJZ2CilFMB9JnTaZkGdXJLuwObUMR?=
 =?us-ascii?Q?SsfVySypNcTeFJcTdA5aulx1Va8eZIRz/rvRhVDIoD02Oo7/HoQK8CzME9Rb?=
 =?us-ascii?Q?DVpdHYJgB3KnzWUWfdUfBU+tuDUHjsn0a5WVdS6v?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57c29ab5-8a14-4095-279a-08ddcb129984
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 00:31:30.5811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 094nw2hLueplsYc+eRIO8Amyqd2gg5bYrbCJSEE6IUVohMppScYPFhind01gK9qcL4gQ72cS0fCCwtMzP2Z7yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5949
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8BFE71C0007
X-Stat-Signature: ygj3rzgu363cf8znyfu4yyzht5b5xxtt
X-Rspam-User: 
X-HE-Tag: 1753403494-412792
X-HE-Meta: U2FsdGVkX199bTkSYxzeNXoqm/NWC+m+gKtwIcy0CU1xKDe3WZ/poficpjIvlEF0VN2AXx9fvakWAOKtVFeeGheRYECZiWjv1fMnfrZ/xw8TybGXjnGLecHw4UUtpo3cS+vW2TSrFWdU+0PmcJ9rN59QNs6hmJ2RFWLalD239l5OOonCbgrdVjuLd+Q8pm3K03CKnii5MWvfyXNMJ8ELakgaamHlUp9LahOW1QKt00nYAAQHgL/RtgK/nxyFycF67eLCmlaOISE2PF7GnO3rAVLSCpB7zOZH0jMZmNVSo+H3OIhFBosjXEwXkXvcB6nXhpIpdgH80+WFbbRzQjAgvyNU+DtOWt8WQGh4vTATB0LwNrLsGWVQz3GpVA4to4MjNpwqr2b+6RdVtEf1FkcT0ce+NeQ0qWasFSC25Z/TvPLEENvbGNMaeEqJJmLg0YBH1go/KXHTtKB83ikYJIFGcXBvlGxTWLkqdn4XID0FEBPrL+dcg69MnBCM2PFwaS7NJkaTl6VDBd1Z1maG6AoxBx+esQcMu0BmbUktkklik4LwAAHPSUdBi+nqC3GXOtN1ZwKk7LcTFgyCekZFJXeehgMadOxO9C+QiJZlYhL2K8ayoNOn10RP8q9qyqqw202fXRVull6fNqF373tFBH4knlSNIFoMmKtkeX8RVqlJe8AweZOZmvGQw7+mhY2n3wYhGulugyBiXkcNb3gqJyDDQ92mvSMKn1Bvd9Rs9wgOO0oa6xFPXnUMThQkk9M45WsawviiWekaDBFJVkjctOBMIcKGJKrCx3L6Np8ToZqscQ4Ub70BP2OZxqf650kUnf9kQCIPNKp3xsybt9LLbsmG6PAobj9bk8iehhow+rdWuqzS/6HDyHGytBodXJmyZmDz0UAfUtuPVDAGTfB64J8hoimC++gnYvid4zCaeoU1COLePAAmam2KHAj+0BDOEFjYtoERAwY9sgMRhTmgrEs
 rzHNc6Tu
 jxs+7pWZCBqiitCaoP+dkAe1KZ6mWKZ4wifdXKeW+iXGyoxLPFQJoLViVggWn71vpWpC5+wQN904Kt1rvR/5CHv966R1dqFXvDFoCb6xRO2fo+OXOVn/D5M3XOvywiZcNDLcU40vueQtpYrg19IZ6SXNtPcFpLeKRaH22m8YyzTn8ZSRe5Uely86+WFVG4a2JeoQKcnS+tg2b1L55HjdhTwP02v7q1XTs6uZiiLWMr21weS+1R3tlLv0NLpdo6+Vveb/PGnRA42gzKAwhryllTMBcXqizm8opZgJyTsWtYc84jYjDzxYP7DPj6GQM8QIBZaXVV3NBeuBD9DC/XBTT9nzCcRlSsR+AUigOBWlnfdfwdBtLCXV9QhameT5eT6kJsFIj9ORt+v7RUuaim7oKF0DkLwZg1+yS8dEWklO3BxSFvnlyPEv5fqwYGDqpVWlr5J+21KMRkeS+eEs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 10:52:54AM +0200, David Hildenbrand wrote:
> On 23.07.25 06:10, Alistair Popple wrote:
> > On Wed, Jul 23, 2025 at 12:51:42AM -0300, Jason Gunthorpe wrote:
> > > On Tue, Jul 22, 2025 at 10:49:10AM +1000, Alistair Popple wrote:
> > > > > So what is it?
> > > > 
> > > > IMHO a hack, because obviously we shouldn't require real physical addresses for
> > > > something the CPU can't actually address anyway and this causes real
> > > > problems
> > > 
> > > IMHO what DEVICE PRIVATE really boils down to is a way to have swap
> > > entries that point to some kind of opaque driver managed memory.
> > > 
> > > We have alot of assumptions all over about pfn/phys to page
> > > relationships so anything that has a struct page also has to come with
> > > a fake PFN today..
> > 
> > Hmm ... maybe. To get that PFN though we have to come from either a special
> > swap entry which we already have special cases for, or a struct page (which is
> > a device private page) which we mostly have to handle specially anyway. I'm not
> > sure there's too many places that can sensibly handle a fake PFN without somehow
> > already knowing it is device-private PFN.
> > 
> > > > (eg. it doesn't actually work on anything other than x86_64). There's no reason
> > > > the "PFN" we store in device-private entries couldn't instead just be an index
> > > > into some data structure holding pointers to the struct pages. So instead of
> > > > using pfn_to_page()/page_to_pfn() we would use device_private_index_to_page()
> > > > and page_to_device_private_index().
> > > 
> > > It could work, but any of the pfn conversions would have to be tracked
> > > down.. Could be troublesome.
> > 
> > I looked at this a while back and I'm reasonably optimistic that this is doable
> > because we already have to treat these specially everywhere anyway.
> How would that look like?
> 
> E.g., we have code like
> 
> if (is_device_private_entry(entry)) {
> 	page = pfn_swap_entry_to_page(entry);
> 	folio = page_folio(page);
> 
> 	...
> 	folio_get(folio);
> 	...
> }
> 
> We could easily stop allowing pfn_swap_entry_to_page(), turning these into
> non-pfn swap entries.
> 
> Would it then be something like
> 
> if (is_device_private_entry(entry)) {
> 	page = device_private_entry_to_page(entry);
> 	
> 	...
> }
> 
> Whereby device_private_entry_to_page() obtains the "struct page" not via the
> PFN but some other magical (index) value?

Exactly. The observation being that when you convert a PTE from a swap entry
to a page we already know it is a device private entry, so can go look up the
struct page with special magic (eg. an index into some other array or data
structure).

And if you have a struct page you already know it's a device private page so if
you need to create the swap entry you can look up the magic index using some
alternate function.

The only issue would be if there were generic code paths that somehow have a
raw pfn obtained from neither a page-table walk or struct page. My assumption
(yet to be proven/tested) is that these paths don't exist.

 - Alistair

> 
> -- 
> Cheers,
> 
> David / dhildenb
> 

