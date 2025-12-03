Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DCA9D1266D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 03:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 692E56B0007; Tue,  2 Dec 2025 22:13:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 643B76B0008; Tue,  2 Dec 2025 22:13:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50B7C6B000E; Tue,  2 Dec 2025 22:13:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7C96B0007
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 22:13:49 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DE12D14045E
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 03:13:48 +0000 (UTC)
X-FDA: 84176690136.13.822D1BD
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013039.outbound.protection.outlook.com [40.93.196.39])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1A39BC0007
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 03:13:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nuEyvPbF;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764731626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x7VoKbGzDynTfjogxj24Fdo71Yl9p+ZaoAuyimlAwRI=;
	b=TNdxMyfVda1exIMzJVCTei3vTHu7bW4BbfM0PyOhrAzk+J9WEj5MdqN3SAiEScTf420qau
	XeV902Kory21vPNgM1LbiVvPdGxtnoVM+giq8e6RE0lRZ7R3zgAT2DLhyaWs4usmxRvqnV
	IaQSu2mIexuhrxN9OBuorpZNU6eSI3k=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nuEyvPbF;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764731626; a=rsa-sha256;
	cv=pass;
	b=MGHsdQ4aHiOD8OJygLBhE5Szb+AgxwZHIiOu7lsBdWKhZKq7S1F9Y8Q2m+cCHGiq/LwKIg
	V/gcAZig8IhLAfwsFiVBuqhToc3Crx3C5rKkJEtWZeSWX2/Xsb41gwlqVi8RLwtK4Zy3uN
	7tOYE9rq3nGmnWRg2uQBzaCjcypxOKA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eX7RVv/ARyn4+LDscgqiswHta+nyV1LdG8Vsil98F1ekcE3lZkv++PHqiMwMrEhoG2K+z0gS4SkNUgR07g7h2XQyvikOal/o5vBN7NmYAtLtDiK2hhbKudtO1PgrV6vE9H04d0AHqDGmDdF3HRXYBAKfhK7FtaZvxzIFrJom2nQGpk0MAD8FINfRkiw2HuawuRrFFTOODFWSMSoWfxbo8zjfjnz9zfuog9Z6GGbCOYQZszEMwN4URvUMjKqzuQ766UlqwUEH6ycAcCEVJisuDbxsRumzLg7gy7fPKUQFYGIpg13qx6mPI7AKAqMr7inf/bvI22P49fYBnt19FXt4yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x7VoKbGzDynTfjogxj24Fdo71Yl9p+ZaoAuyimlAwRI=;
 b=JPtVuR8KuvU6SqCX3B5vhNt9HdzMZh59akFympie498ILF7+i3kK9li9Q4ZL1K1mnuK3H1W3qPlx+RBH1WkxqhRKPYzXNul+8ZZ4DtaGU0e5JzwHA6duV4fMKJygm4qHHMEjT6fkzzxSYT5e8S7AUkZA1PjuFZaX4EL3Yga6wwYPeqDg7gGv++4AuntD97UtkudgY8Bjl+Oc2FFg1zoGaVdpxlieWyW7AQRpAO/YRC4u05AbRzZhn0W7YVVugcT6ibKzANkopHi/LNNID9SosSNgfjXOR5KyT861P42OTqdqa75lT4nQ4jZXK16D0nyWoyVn8YRaNKd91wVigvp3NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7VoKbGzDynTfjogxj24Fdo71Yl9p+ZaoAuyimlAwRI=;
 b=nuEyvPbFxbTJ4edVgJwE/Ta4sjrRWM/PzRko0TG8fE8ssYMs5m/eW/0Sqd1n3LIe+hMYx9Icu4Y9CgUbmTriG1y6JjORIbJoNQB2awRD0lwD/M7adShPQbPd/Im5+vjI1W9oNzTuqkEOZNGv1Qkq+OOPa6hRMwfczqEZ2JMfuh3wC8kyYNMzVIyykOeYARzxnWq1S9xIjKOJK5OEwcJ/bgIy9F9+VUmKVmM48p99+od9XqxELCVVfOpKrEWgJHacv9t6N7+h1ynkPR8oqeth4AkHrV6dDqBEML6IVcFX5xIQBkL3iUkMUIKO5c9bgHkJnQyQ36Ia1QDxcdlH8i2dwA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PPF9A76BB3A6.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bdc) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Wed, 3 Dec
 2025 03:13:41 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9388.003; Wed, 3 Dec 2025
 03:13:41 +0000
From: Zi Yan <ziy@nvidia.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
 baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
 corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org,
 willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com,
 usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
Subject: Re: [PATCH v13 mm-new 05/16] khugepaged: introduce is_mthp_order
 helper
Date: Tue, 02 Dec 2025 22:13:36 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <CCE3840A-A46A-4F33-8412-FC55161A6D6C@nvidia.com>
In-Reply-To: <20251201174627.23295-6-npache@redhat.com>
References: <20251201174627.23295-1-npache@redhat.com>
 <20251201174627.23295-6-npache@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0273.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PPF9A76BB3A6:EE_
X-MS-Office365-Filtering-Correlation-Id: 146eef07-625d-4cdd-77a2-08de3219f5b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CiRNrkNLaLDOHr5o0T3slR3tJYSO/Rkwbn5QIaKemutq39h01pIMnWLyLY6w?=
 =?us-ascii?Q?jS/Of6qmH1yyHDeLyx3MPrTGYkizI/lhqjY/zc1hHTsrSClVRkDd7QyhlRP6?=
 =?us-ascii?Q?zYrB1q7xpolyhDocz7a1Xwnzd3k+qio2aBanKqytGV2uw6rg5CkRq/Sk/+XO?=
 =?us-ascii?Q?P93m1cSvj9vILPyEOdAMKmEaZ50OBSwKM8EAQ5TGab8Vnv5RktYHVAP2HxH6?=
 =?us-ascii?Q?YLBFpkK+4s2pH8xg3ky2yHqPUvR+eIYm+0aKLGUehgxPDhC5rE7NPG20xoPa?=
 =?us-ascii?Q?5+JrDTuPTj7SlEBEO+Kq2pxyp4dQT1NYqKge5YOmm4ZokwQOFFLbnw7Lg6wL?=
 =?us-ascii?Q?SmVZRGc0JnjT9W6hQuGqtucZ04LX3we7uLKzXAzGGYrN2Br7gFFjVzrQHeqj?=
 =?us-ascii?Q?EIqg5eBZKsw0gD3GEahR4BBdbI697chZiAetwq7FiRSVVtJUlYHZXGVOO9x+?=
 =?us-ascii?Q?3ms+UTGF8IVtY8yjoIev2EpZDVemPUR4kZ8wi/PdlT09XhTskS8Y9UwawBLf?=
 =?us-ascii?Q?EFzZHbHDgoHNw8obkKtAs3KldESKoPSzUslFsdfdYMubZIbFWHMzidYxPeqf?=
 =?us-ascii?Q?tHxU+QqXrj2fffGsZN0jEkQlA3S+wM3npXUcj9rPEhhzRnPrT3r38vWSfhlM?=
 =?us-ascii?Q?kPT/ltdKJWptoToOESfFT7kirGQNIjDaxUsEuqYwkGBzCVAF7MihgIuDH63A?=
 =?us-ascii?Q?u7f2y4eudJ5q+wGBd38OgeMF+MHzeb3WbMtjfi+WzPpPmUFkZDA29nyUfPcX?=
 =?us-ascii?Q?bRL+ewaL1/HPWIu9UXemjQ72KNCZrWOJPlGOnmWIPdaHowq6KQiNZuwlL4zm?=
 =?us-ascii?Q?e50TB+TN2FTgl+HRt3hvoo8/sezr9bell3QWBkt7alETM9R3S+eYgtfP5rUf?=
 =?us-ascii?Q?LbAAPDz2hRB2Z0GWaAuQ2BxPPBjgnqgFaTxOGwYYexuOmuOmd8+q9GioC8FD?=
 =?us-ascii?Q?PcGm9fnWWRUnNqwFT5ZmxV6ujE1HuNWq2cAuqQiPiV/8fe7tVPymi73qRFfA?=
 =?us-ascii?Q?5oqgGK9tz0ekGQGizrL04RpA50n6JxCyCUDdYqLy9mlBt6Ka/ktjGZR2zEBy?=
 =?us-ascii?Q?fhyAGd1fYWTSkhWk8NGerYppo48Kz7wwMFUPdY5I3unNFPQfb4vvpzyl8So5?=
 =?us-ascii?Q?M+ZbdXLKxsAnmYbsZAIKzQieQyPlxJEwAbqRNn0YM5AX36To/TdkCfCdD542?=
 =?us-ascii?Q?eY7sJIC6tJl5x1ZKpTA88baH4pzCsMCNkLxPexsgEdbawF1ecfBYO0UT/LZc?=
 =?us-ascii?Q?vmP6AktD8P1PbXrBE/BnRZrUqlYfRvqY2S45Blx4lq0fljRcyAAuxNUHp64O?=
 =?us-ascii?Q?CH4wtdcO8vNQy7c+ppqbTN6yNFaggJh9h/w/+noKHSNdkI+GWy+0cspdOqM1?=
 =?us-ascii?Q?4Ai6T7zTnjAQsvHYuMzfrt22FIRRuotq539YyjbaL0Kb9KIwK6YbRhuipFIX?=
 =?us-ascii?Q?Q7sbU8nikJIuSDaB8UE/i1Yk2EdjLKtS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1Jma/0ioExjDJhlMq9j/rWzC5bWOqRMbz3iGgFvD3sdw2r3tpn8S0v9woUo2?=
 =?us-ascii?Q?WChWHto3vMh0SxPmduLnxaVB0s/Td7+j1so74Y5mwa4GviUNfIn/r1CvIvad?=
 =?us-ascii?Q?Q2LqfEyM7hkSAktj64cyXdP+UBqyeHytPb1syvx4BkqdocF3EHtyRDLoHwM1?=
 =?us-ascii?Q?otOkislCWv6sANNnX2LAVL+9IG8XMo01Zf9KgJkIJO7CWfi6M0cbb9uuRuVn?=
 =?us-ascii?Q?GhZTgrby1M3vqyNHJFEFUL59Xvjeja2YJOqjjvk4wuR7zxgcgISpkMLIfEfO?=
 =?us-ascii?Q?U6wPD4OKM1CbD0ZZLD9HgAkh5vlo2pk3oRgX603/sOJz6CYVJQrvh0NnIjcz?=
 =?us-ascii?Q?Hi+TZw7WOYpxOmrE6BxnKnkwv0MMal0ZxD/K75ma+41qbyh2/nXZl0UgH3JJ?=
 =?us-ascii?Q?XzJ26FUFG5cjUa++13XVU+RQvcDPJicBH1ZaTuom2+fSSS07QVhVds/lKbcf?=
 =?us-ascii?Q?BYVQrzGqHwrU9AXIYjnMRgjAUNpQ0NitMbWIx78+kR/btIPFGt+5lUuzUm0/?=
 =?us-ascii?Q?g/ZTXHUNeII4q1xSXoZxEKIoNscg5lUMFxHNKN972dz/bKKZh0RRTXMyaVIQ?=
 =?us-ascii?Q?iG/7WFTWQa9jQQmpKeB2aSn5kdTznH9X4g5QT4T4QOJNx5xMO6hrHBWQPHwL?=
 =?us-ascii?Q?lc76IBkfATd6pYM3hdjyEYEuwSXnCAI7m2JffoMzl90arN3MQ3PWhsHCJ3cW?=
 =?us-ascii?Q?mS1kLyyDg4xNRt/+g29N/XK6lvCzZuBkJn5goTjVLQWi9/SUhp4vOYQqRvkH?=
 =?us-ascii?Q?pFHzHZUHd5ZpnKerycmAgCeF1B3na/Lw+AbfoxVezHcN2n/zhSir/VtYwvOo?=
 =?us-ascii?Q?lQpfEThDhuvRroi0j3t1eecGY7dW56KMPimlF64DxmFD8KZlAbCaWa8yhfx4?=
 =?us-ascii?Q?QCdllmmr13bmNGhs8zDX7DU/9j7juUZQTYDGWXjvJIyoU7GGb80A6gdaAXMo?=
 =?us-ascii?Q?9N+oHTgsaiQgjcs8NnCIizuc3Nlb037HVpPdhdvvaEWI+jRCCs9hZpWHAFe5?=
 =?us-ascii?Q?ma6/HZvGQkL+Wkl0EHQqVENORYZ9MeZZtFZKhGeljch9HGOYtY35cRQd84WP?=
 =?us-ascii?Q?9amemgAUIzvLdhw8N9BNzQVi/ukrVVIJDpqGRn77yKjdOlwXjd0rr0sYv4jp?=
 =?us-ascii?Q?RKqcRNhyA4M0mwk3H9J7ANga59pGs0Sb8Bbbjit82SUqerdTAwFGEcYo1P22?=
 =?us-ascii?Q?86KYrewZxHhqbCcUCZJvgS8RAVXZJkT4G7tbcLFCHV2ZZnFlG4CJFROc0nJf?=
 =?us-ascii?Q?ZgnohBVzgqVXt0hAiwV/DW45YRD7Kbx5mpgc4OnTrReZoPU7bSEPIjcVHF4t?=
 =?us-ascii?Q?DHXJmTIotAB754jLXxeNpnktfSe7gBs0MgjzNlolBqeMqiNQATrpoxttAe0g?=
 =?us-ascii?Q?JObWMnLv0G4WyLsgMN9a+GcuZ54FD72PtZLJl6yGA5oQmeU1qNin0LaEDCmp?=
 =?us-ascii?Q?Jk04eiKfgHdtRdwF7/h4z1mCmaNlEhL8CbrLQTFZF5kxppx4H4HshjWG8LqO?=
 =?us-ascii?Q?Sd16lUO0ERV+g59Nog4HohTGFTa1gePQ3et83CRQazB/9xxYjuhzDn453uB3?=
 =?us-ascii?Q?vB1MHU1CleOX1OyONxAz2RA04qGbwWk/XxR6Y9Mu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 146eef07-625d-4cdd-77a2-08de3219f5b6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 03:13:41.1968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L24brxESDtcQgF223EYkTjcgfdeONG+S4UMNYrxsCKPjNzdMbCR+hRANxQ0iS5Rk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF9A76BB3A6
X-Rspamd-Queue-Id: 1A39BC0007
X-Rspamd-Server: rspam02
X-Stat-Signature: w8fac61tge4m5ef5k9aoe9gxb3tczib4
X-Rspam-User: 
X-HE-Tag: 1764731624-731112
X-HE-Meta: U2FsdGVkX1+NXi6kZYZEY3CccIkUWIsxKltDOgLxdmDONcpvN4G+eIl7wh9bdznQrfg3l8fn2mE/qQ0pyMztXDKqsWl7rY2imaw/4gyIkNuOSt+tdjSB1U5t7VxdcdvaE92+mgoskbPuVf0ItXdbs4wTyTi62MMAzAgPt/mbFRoh5Rnq0vKuoG3JSR11dk7jMbKH3HuG2ucSMqcd3YcH8INxARF1OQnzFDJU9S4Q7CzGCBVCntfOS6oQPOta0P6XvElsukhRGJgHTEz8i54Dip4e8fcyNfooKY8jprdBOBlJRhSr++fB81kaJlHU+8K7lmNedcE2cttfHGzY/nsP7zUrB0xvOQIi81SjfXEpQzCCH7T8o9Q1xLQJ9S80aT8KvhSIUuE4Je29wyCIuOGtVTKmmi/LJIbEZbNLh8yG+BnxE5OdT3F0ea7vDeqMKn+YzviLSGr0q4uSteoEOK/CLzZeEodIDLwOPMfYHxLsmQdQx+iNIFC3f44+98TM571/okwVj5heYJwhQqXtfcDz4KfLfyU787vSZCqHEB1gk2Vbi2Yms2/GieaFbm66FYf3upbySz4Pob1TGdKZi+NhPkcjTy0cKYfJ+ebq8TLIq9R1xWVcydaOuBuE4Rhoz+I91jf9xabMfrcc6K3v3kKEz+faOZhnMynuBG4Doe/RBjpEUI9ohr7+AjPPhJSUj1bhngbf2hrQXSBRthizWmz6HwbbYQ6P1lLd1KsVpYrCFUZtabaUrTxvIa5b4cQ9GUzZf+dpK3B+1ko/Qw5eLPsL7X/0p/bJCSjtJkRCQEiI29QVIqokUkfYRNQ9u51wAQxgjQlwLpbgFn7cFKgNr0NU7pdu8l9Njz/EWF4pAmUrgKM2F4YkX/KPuyfXhDPaFLOhId0wJhTux8oymvN8BNj0hW6XDQpmOMdsQAAUwGwszMDsG7nfEjVf+nweeX4Ir/LunLLpIi9pLc1ReMSZOyM
 +BLZSQYn
 MsaxctJlgfn3D9G+C22YcoqS8ZehEv1qtq7ESLaX475yBbZ4/r081orSdkU6AZLIJEua+gou1Crc1wYG3x+aAVZjbJjkF/i4hWpevfi2XdzN9/ZjS2muUpkaLpoWFeqDQTCiG5Fqy9bC1rXfbbHxESVJd9CldVqnCSDqOp9JpiXQmFMI9X9pmC/8a4i1bgsirM7Q5MXrxAvsrXE9+gx8cX1DyY/ovn/82eNFcXJuO50W4Uh1KLzo+yjdiSY1Kjzdg5MrH7lR4MLLrD0nUnrmlyA/RJNkfdZssLFcOPTHSFvUV7/f4Nl3ZbHkujWxZmFZkooXgQ9dVTv7YJ1BbxGJvuadyPTFsYOK4PnTP5iLAbiqDywqMWOE56xf60zJQkAJzez6GV0T9XhLN7MpCIyfr2VlasJ61kBJA8PADWuyqQbWBXXqjSt62UGx3YhaBmKptwYXmPWUQQKWX1AIo0Pjlq8A9fOU+c7UCL3/jhAKB0EPpvwI3e+n47mmrQJmFi98N3RmnQ7EISy5JKe4HpE4LtRzIId5nlpPXf9bzkvfw2F2l6YFpenWcnMUDEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1 Dec 2025, at 12:46, Nico Pache wrote:

> In order to add mTHP support, we will often be checking if a given orde=
r
> is a mTHP or PMD order. Lets create a simple helper function to keep th=
e
> code clean and readable.
>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 8599c7fa112e..9c041141b2e3 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -338,6 +338,11 @@ static bool pte_none_or_zero(pte_t pte)
>  	return pte_present(pte) && is_zero_pfn(pte_pfn(pte));
>  }
>
> +static bool is_mthp_order(unsigned int order)
> +{
> +	return order !=3D HPAGE_PMD_ORDER;
> +}
> +

The code at the bottom of __folio_split() in mm/huge_memory.c
can use this helper.

The code in deferred_split_folio() uses folio_test_pmd_mappable()
instead of order =3D=3D HPAGE_PMD_ORDER, but the code can be changed
to use the helper.

>  int hugepage_madvise(struct vm_area_struct *vma,
>  		     vm_flags_t *vm_flags, int advice)
>  {
> @@ -1071,13 +1076,13 @@ static int alloc_charge_folio(struct folio **fo=
liop, struct mm_struct *mm,
>  	folio =3D __folio_alloc(gfp, order, node, &cc->alloc_nmask);
>  	if (!folio) {
>  		*foliop =3D NULL;
> -		if (order =3D=3D HPAGE_PMD_ORDER)
> +		if (!is_mthp_order(order))
>  			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
>  		count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC_FAILED);
>  		return SCAN_ALLOC_HUGE_PAGE_FAIL;
>  	}
>
> -	if (order =3D=3D HPAGE_PMD_ORDER)
> +	if (!is_mthp_order(order))
>  		count_vm_event(THP_COLLAPSE_ALLOC);
>  	count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC);
>
> -- =

> 2.51.1


Best Regards,
Yan, Zi

