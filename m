Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1203AC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 14:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E932C6B008A; Fri, 11 Sep 2026 10:40:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E24316B0092; Fri, 11 Sep 2026 10:40:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE5FB6B0093; Fri, 11 Sep 2026 10:40:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 963586B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:40:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E73E80279
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:40:30 +0000 (UTC)
X-FDA: 85201742220.04.C0F9CA0
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010065.outbound.protection.outlook.com [52.101.61.65])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0ED6A4000B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:40:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=i0izMPWM;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789137627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p3W76SfmOEhwnMsbaSxs3K9Myk3Eq3usywFRyojbAfM=;
	b=tsXoIJbF9RQ96WHQEtEMjhqJAviMMUi2Y9/FFIay+HnyCfUVLhOWiatOcltSJlGUPQ6d7m
	W19aIliD4p8gytfy0U768DHD5ZlhZL5TmW4Rg4OveSI09bxwC5ufxE3rOiY+n699nLKF2J
	TrAlPWonVA+CCuGG2YL1FGEcqcFTAkg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789137627;
	b=EbLEBfyCq293pKFzSVREjyhcWU5WpzDn206/sgfJapKBuZi9b7GprW6Yh1KFQhMipUJLdu
	cbSkmKna3alkYCaaPBbFahBCNi40apPYqZPcprXJNAWk+aPUm0TenxrIZqO5DxwHzsQLc1
	Nx7c3DCOE+RaoCaU0etJrnDF8lxFaNY=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=i0izMPWM;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZSmxAsqPYfv85OVAP16The25dVXHkLw9Fsu/emsS/F8Z5FOTdMCOOe2nL7ofoDGLusrrFKdLfwGfDIS7cpmDn26m6mlL3I/Uv0GKIsIDd7y6pMVZCTNctWHo/aoUo4C+3hDkumj+fHz7ZZZA5ht/qFTUiFz41yjD4nYT4AnG3PspLVtaTe5WwHU3CsJcOc5ZTIJUFV+BQwu78Ui0fwanCmT2Deb0tc7YWj9vEz14P+rq35dt6K2bIPITKMcNXHs7T8moHooLd9Q5E2kOYppNU5+lHkcQesgr5qQ+N4/TTxeQX1fYx+9fttW13bhstMFEAScnUVHrPJAupgKdvY3Rlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p3W76SfmOEhwnMsbaSxs3K9Myk3Eq3usywFRyojbAfM=;
 b=ICVbnJsal6s2Kqtb7OYvqZ0O1gH2dzt4rFjWU5vbbjcq1h8CE6Ak8lBe+e9wCmluTGVNoJLMVtoD1VE/neZL4NfrUf5ngzAPqdQb/a+HB/QZDfOWneMqHpFDwuMRo+z4sM0M1Pir+n4UJ8mKYPu/JAyFFh1vjVXMl1wQqRrLMgyowjWAxxL34atF0dLCueF5wQVMBimR3Rd2iv4CUmFRgfBgJhEXsr5rveKM/q2IZ7WygLIiKkeTY7PLRe6DEgrsvLpmuNGSnHhMICVdkMtNS/puJ64CCNhYils734lhOX0JS3GXC6R6AMy+TOqqMtX/rrGAtYIcvi11hwrM0v+EKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p3W76SfmOEhwnMsbaSxs3K9Myk3Eq3usywFRyojbAfM=;
 b=i0izMPWMCAshrqYx88pcajHjp41/xwcf7F4zg86QDj9bGK2YI1bJli3jTHNt8eTW8Al1gsMlb10itDT6OxhX5uIUPs/30CRMMa/nkedp0bvlejA85QBd+ZfMrR2I1bYJEWBHJWETXU5MEsDyNcOzbp7+/7CZ0sFcZFD/K9lOt8x42PFoPMEEHmv0a37xUcjtsqwvnghV6Y4kRxUPFxD1T7UIadmEoY/qYDM69fX2cM89p17Y+Kf7qtISJzDetRiACQX81Vw6Ee8FWC605/VzXa0T079TpIBoQrE4/rqCX31NfjT4UNtqqqpy/IKciehGC0vt0DAPbjxyUVbPyhW2cA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA0PPF4D923B935.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bcd) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Fri, 11 Sep
 2026 14:40:15 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 14:40:14 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
Subject: Re: [PATCH v2 08/12] mm/collapse: separate scanning a PTE table from
 collapsing it
Date: Fri, 11 Sep 2026 10:40:17 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <51F4C9A3-E397-430A-8DEA-9444B6372816@nvidia.com>
In-Reply-To: <aqQDKTzLLvj-_Iw9@thinkstation>
References: <20260910120238.2529819-1-kirill@shutemov.name>
 <20260910120238.2529819-9-kirill@shutemov.name>
 <DLC4ZVU8JXFG.3SS0W4STZKWBA@nvidia.com> <aqQDKTzLLvj-_Iw9@thinkstation>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:208:23a::17) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA0PPF4D923B935:EE_
X-MS-Office365-Filtering-Correlation-Id: 89d28932-53e3-4e1c-5bf3-08df10129762
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|6133799003|10067099003|4143699003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	XlCw+UKe8YFKxIXsbAuW8atltJzDZd+oE6QJVSQd5xDCRclrllO8WhKTdBgucK+sPWxR/MCATQakO42n491H7TEH3yA4/jfaVIeuFLpKYO0iECmK1d0EUcX1J4PvOBU5hHFRu0s8uyHV2QBHUbiV+LkwLYiJdexzyMQm2Har40wP2MKxqpr8MVqLYDtpJtuT56kjljBf1f7I/9xjhSsEI4qKYCxYUvlm53aroGKrTObIS8Mp6K8y1df0ytzjnAM4Fo1EC1dNs3Ft0CJ1KRgjYs8akxEyXv7sUglcCSbmRjYvz/hOiHd57wo2W/43HGKDTpI0CJNGQrBRlemR91pzfsY0eNG7LR/dH4JUleWm6WElW9yTHgu3JaWqN3eK5Up84V4L12C9A+5qRiwxemTySfeGau5WxfSlkxuU39J51VQ1BL1LgLvlB7/2ABdRX2sdwFdWUBQzTkuYZgHAYRhTGnip8kU9FUasp8tVcjArNMJf32WToVOuJ+KEJPsk6sZDh6nW9J4GhjuOqqfe2zzl0ioZEFeWGOkN7A+trPToZy7czWtkYUjc7vw/0SfHhgSBE8UpchBnDBwmVs9CTFdhTULVid67GgrNLhRyyH5zz9+9wG8BPaC8qT3nqVuy2mU523vUQWFTAg3z5zry//JDX/EOSQBLDMDfDJN9m/FmZSM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(6133799003)(10067099003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wbGbrPgX68sNfGDGIZAwM8DfoIWvC6AQsnoU8s9XFLyjzfCd2L1uRx9ctq4e?=
 =?us-ascii?Q?JPiuovCI/I9XZUs5BC5P+8Yr3yk6f0xQd9mjDFBReuGqB1wwcT0PsLB/5jTw?=
 =?us-ascii?Q?uCvVtWi8nQVCuwP4WUMQ7TDVnM+GF0LMD23jknYlWI7Ck0WpnyBLQyDYToRk?=
 =?us-ascii?Q?gre4MxgGAzV4+YGSPVELZxt5FUy+HufIkEjDzBcXMGf/is20xotMN3n7z65B?=
 =?us-ascii?Q?tPauByVUMHMQgnekPrZQJ3s3tlZYYJ/nZHoxgTgiFSe0AKXwHkZ8tD1s1age?=
 =?us-ascii?Q?KuXa3Sn6dxi3HGEe2zXyLW+n19S53oBtQ5Wq2K12+tKwSCA19nOLmuF0iMYD?=
 =?us-ascii?Q?OhTE7kl5+zV3Zb45KnFJHfzaiIotHqjHFPlHASrux62/wnilUf+wweosJy46?=
 =?us-ascii?Q?oWd+wCjBAbuI+AIIYN7NqBrtsKSQjW7LkmtYmCjxEmRXZN335yBxXe8heziP?=
 =?us-ascii?Q?wtZYhRWwCuG+H/awgja/Xf5gWhRNNXuDHs8NmIQA5NkSNsVsFfrDxy0CliQv?=
 =?us-ascii?Q?+LPnhIvik5/ZGKL8j81bymulYPfyF/0H1D1JG7WrZ/Rd8nVZWVtMB7644Rom?=
 =?us-ascii?Q?UyIQKzXW1ylwVjtW0e0CVVUYR143jouRLN20HLif/Nx6xBkKa5eQpTERCiKI?=
 =?us-ascii?Q?p+OSWOPwiB/6jDQa9dvVYZVl35csHR2E1PeT30sdMyTCx2jbX7W1xMcLJ2OS?=
 =?us-ascii?Q?WcylSNf9EleJSSBSENoffut1SYhI9X6XFSdU4wrn6iWyfT0oEnPEJP33HS+i?=
 =?us-ascii?Q?oJWgzUhDNfw2qenLvpD1E/GxRnQ0XI2N0Pm7LnKUK0zXRJcP5a1b2lKagReU?=
 =?us-ascii?Q?dYLtx2c+juYv9WS4IZ4NoYm5MbtP1maoh8pjQthcvD6meaMSmtsGJGiamzWl?=
 =?us-ascii?Q?JMpLKmhZwNt5jckxpODxQ1iKVuoyiYZebiOOvUTOB1Mo+Xk174BdP86ZP2/t?=
 =?us-ascii?Q?LN8nVst8MuBb4E0kuOd3OgYn7INtz94XynIFEfLLQKxILn54A2ih3MClb7tU?=
 =?us-ascii?Q?s/f409ezfbX1beVDS/5VRUOn7n1r90tDgqmfuh/lQDr4XWpNQxyGLMR+Hl+M?=
 =?us-ascii?Q?MlNnCuorm9sWsyXW0qgY6rxtcZtdeIk+yw+pSLA0hAPQlIfWV7raEqgYdAeA?=
 =?us-ascii?Q?eq2jMY7r/AOHbxlXdoPyMJ7OKWOJwvbvjDmz9WKtyah6S50haONnhNm+slVD?=
 =?us-ascii?Q?pJYdtVwcVuGaq5Vi6YI0xzZWCCk5zCnLoEStfVMnPktHc5mD9J6DJTKYa/js?=
 =?us-ascii?Q?r/ZfFbhPOiMvD+ZWHjPsan/scfkdJFttY8aXDKCAtxRj1sn8VWka2EPMjCDK?=
 =?us-ascii?Q?+koDwocWK73JCBpZRxId7gIco/dVrTWlKwCSzMgZ44EFZGf/5JhATD9TaH5N?=
 =?us-ascii?Q?t5R+W/jxHZbo0c91qR3Y9TZIQPGUSTZhS7dZ0pnaDS5N938v4woyGMmzHFYY?=
 =?us-ascii?Q?xWCncdv1Cu1YwyBHIvo2MedsKvKHEMk/KiOHqDegMN9T0XtZVhuR++I8DemR?=
 =?us-ascii?Q?/Owkymg9UlI+RJgb30/Y/C2WZbdXHwIE5OyxYkyrPmLu0WLXXvfLX00OWBId?=
 =?us-ascii?Q?pN43qX/JGze4PcYc5RQ/TTJXy2ioaFzWaKNOdgnn3hO0m1wo3Pp3WAFbiLb/?=
 =?us-ascii?Q?RQNUbLGI5HyZeBKxammAdk3jxKK43S4aL5LfN+gG3eJALf85LHghvFt6/Xw5?=
 =?us-ascii?Q?GwGx9KKdfOI0eMDdC0+ZnuUpfX+P7WofdyzcWfMJtwq+XSn6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89d28932-53e3-4e1c-5bf3-08df10129762
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 14:40:14.6431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MOOpEFdF1vaCD05m3PbGeQhnkztVULvLuwzllBgHQUr3Gw5DXAxeNalRqiPL3CSR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF4D923B935
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0ED6A4000B
X-Stat-Signature: m9iu4rxeab7stu5o9a8sx6n53oyiiwek
X-HE-Tag: 1789137626-944184
X-HE-Meta: U2FsdGVkX19MYSht7S93VbkQDcRftlAClIwLiRgOW2HVqGfiYhN8LPyZMBlQwkgVPqjFyiDm+3UFlYcRMV1azXVSKyndkxoqLPDfBT6h02GWXIBuaGhHngosf3laZFs9UbTF8DYkJDgco57tLm15apAxzPWYJtimz/oWuv2A4NjtzyQZz1dFINI+JPipF0+YvMy4mL/5d1eekBPX0y1UbbBTxom7jkW17o0wwkipBhyTjojhLFOU4Yms58Wo/mX70zMae1N46TdBClhisUy9TYYbWdif2nID/BjH2JQVYkF8r+0jaZCeaps23A08Y+hCi3wmGdMAftEZMvDvzdI7joJkzm+bnDDmOnanjKAJP5R/J9nv/GWM/+SVZPXLdedwNpOqO/MX0tzcNJviWwMVwiVR+fUiurdrP/nmxf4EX+V/+x+yNbgGocMSSaOusJYwhVJzrQ1S74n86VaB150bSOl1ymazoHLdVcqSsBV0mDm6k6QV46hNrgkv0b82oGt10Af/XdfsqZuVkEF+CZ/0LpH9A73c2kW8vfq5XkQYHJE/j4fn+r6F5EdSZ0hvMTKwOCXfv2r0IHcr0lKDyfLGvkg6jUG2k3gulBRhBRnVbg/x4DM29Yut4/UlJZT1USgx9k3BCapWrmLOLC9T/HPIkNtr0CEw9Sek8pREjv7TTvGrNdeURryPKbijWaZXyvHoVHuTJXS+Lj0Mw6DddlkYim+k/jQH66Tt16sEfHGJzBmfwzsM+VVARMwnu/9XrGxSsPMYRPqDhqXPQLgahW/S20VjZ5Ghg/AxG8JcP1dlz6HF/ZCAeMObj5gTB1XQZrMh0Fh7ArBn2Mq+HPzKkjdlN5BqaMm9tHAautm0Y/jpCj6982l4ruHC2V0+biP5JI7FTD/dNFcYKePZ9JufypDxVEgZT3YdexO36DzpKFExvaQSUwAw49CxG9UR6WCKkNA/B5pQZHQCYyzYHejlcQU
 8/2c/xZ5
 yuUGSW319aOnK5RDiL0ryvORZ2Y+Dpz61MGi6hcfDYsfVasjNSKG+1z8fKpYMe9RN8/ZDRU+ui8VmnLvx9kRYnsM5jVWDp+9//hGJawcrGZiPI6dr0H7874QP/4P1Z7uupFBzJdKcheIO2aRp3S1zFRLmBC4AGfugJnXMrVG0C2tA8NBQXLirMJeR2g40tCv/xeJzZNIQtG74Kr9LR/iLn52ubGi17D8Xx0xuLj2PCHMb3NP8eBAm+TCrWCNVNLRSHAm8Vox8eXvj/yOsa4i2GkiGF5bjTcP0XvNyIHf0yCATpLRh/BDDh9avlcaHV6O8x2zQegTF2xiGmCiIrRhpGlTqbj8vPVwIpwg8SCwbr18nUbcEVI6w0ZqYz7OgWV1PKHzz2IN059nWL88pPs9KOUCPmoFG2B68ZAxY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Sep 2026, at 9:37, Kiryl Shutsemau wrote:

> On Thu, Sep 10, 2026 at 10:38:13PM -0400, Zi Yan wrote:
>> On Thu Sep 10, 2026 at 8:02 AM EDT, Kiryl Shutsemau wrote:
>>> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>>>
>>> A collapse is two jobs.  One reads a PTE table under mmap_lock and de=
cides
>>> whether the range is worth collapsing.  The other allocates, isolates=
,
>>> copies and flushes, and wants the lock given up first.
>>>
>>> collapse_single_pmd() did both, so the boundary between them was some=
where
>>> in the middle of a function.
>>>
>>> Give each half its own function:
>>>
>>>   - collapse_scan_pmd() scans one table and only reads.  The anonymou=
s
>>>     scan that used to carry that name keeps its body as
>>>     collapse_scan_anon_pmd(), and collapse_scan_pmd() is now the entr=
y
>>>     that picks the anonymous or the file side.
>>>
>>>   - collapse_run_pmd() does the collapse the scan asked for.
>>>     SCAN_SUCCEED from the scan means there is something to run; anyth=
ing
>>>     else is why there is not.
>>>
>>> collapse_single_pmd() is now the two of them with the mmap_lock drop =
in
>>> between, so its callers see what they saw before.
>>>
>>> What the scan found and the run needs travels in collapse_control.  F=
or
>>> an anonymous table that is the orders and the referenced and swapped-=
out
>>> counts.  For a file it is the file itself, the offset in it, and whet=
her
>>> the PMD folio is already in the page cache.
>>>
>>> The file side moves with the anonymous one.  collapse_scan_file() use=
d to
>>> run with mmap_lock already given up, and called collapse_file() itsel=
f
>>> when the page cache looked worth it.  It now runs under the lock like=
 the
>>> anonymous scan and only judges; the run does the collapse.  A file
>>> collapse works on the page cache and never sees a VMA, so the scan ta=
kes
>>> the file reference while it still has one and the run gives it back.
>>>
>>> That changes what a refused file table costs khugepaged.  Every file
>>> table it scanned used to end its pass over that mm, because the lock =
had
>>> been dropped to scan it; now only a table it goes on to collapse does=
=2E
>>>
>>> Two things on the file side stop being rescanned.  When the page cach=
e
>>> already holds the PMD folio, the scan says so and the run goes straig=
ht
>>> to retracting the PTE table.  A run that refuses dirty pages and may
>>> write them back retries collapse_file() alone.  The checks the scan m=
akes
>>> ahead of it are ones collapse_file() repeats under the page cache loc=
k.
>>>
>>> Tracing changes with it.  mm_khugepaged_scan_pmd and
>>> mm_khugepaged_scan_file used to fire after the collapse, so for an
>>> accepted table their status field carried what the collapse made of i=
t.
>>> They now fire before it and read SCAN_SUCCEED for an accepted table. =
 What
>>> the collapse then made of it is for mm_collapse_huge_page and
>>> mm_khugepaged_collapse_file to report.
>>>
>>> Assisted-by: LLM
>>> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>>> ---
>>>  mm/collapse.h   |  16 ++++++
>>>  mm/khugepaged.c | 147 ++++++++++++++++++++++++++++++++++++----------=
--
>>>  2 files changed, 128 insertions(+), 35 deletions(-)
>>>
>>> diff --git a/mm/collapse.h b/mm/collapse.h
>>> index 7044dc71c7c2..346859a2184f 100644
>>> --- a/mm/collapse.h
>>> +++ b/mm/collapse.h
>>> @@ -88,6 +88,22 @@ struct collapse_control {
>>>
>>>  	/* Each bit marks a PTE the scan accepted as a collapse source */
>>>  	DECLARE_BITMAP(eligible_ptes, MAX_PTRS_PER_PTE);
>>> +
>>> +	/*
>>> +	 * What a scan found and the run after it needs.  Live only between=
 the
>>> +	 * two, and read by nobody else.
>>> +	 *
>>> +	 * The file side takes a reference while it still has the VMA, sinc=
e a
>>> +	 * file collapse works on the page cache and never sees one; the ru=
n is
>>> +	 * what gives it back.  A scan that found the PMD folio already in =
the
>>> +	 * cache leaves only the PTE table to retract.
>>> +	 */
>>> +	unsigned long scan_orders;
>>> +	int scan_referenced;
>>> +	int scan_unmapped;
>>> +	struct file *scan_file;
>>> +	pgoff_t scan_pgoff;
>>> +	bool scan_retract_only;
>>
>> scan_retract_pte_only ?
>
> It is the PTE table that gets retracted, not a PTE, and
> scan_retract_pte_table_only is too long for a field read in one place.
>
> But with your suggestion below the field goes away, so the name does
> too.
>
>>> -	mmap_assert_locked(mm);
>>> +	mmap_assert_locked(vma->vm_mm);
>>> +	/* Whatever the last scan found has to have been run by now */
>>> +	if (WARN_ON_ONCE(cc->scan_file)) {
>>> +		fput(cc->scan_file);
>>> +		cc->scan_file =3D NULL;
>>> +	}
>>
>> scan_file should be set to NULL by collapse_control_init(). Anyway, th=
e
>> code is duplicated here and in collapse_control_release(), maybe add a=

>> helper.
>
>
> collapse_control_init() does set it to NULL. This check is for a scan
> that found work and was never run, which no caller does today but the
> engine on top of this will scan many tables before it runs any.
>
> Both copies become one helper in the diff below.
>
>>> +retract:
>>>  	fput(file);
>>>
>>> +	/*
>>> +	 * A PMD folio is in the page cache, whether the collapse just put =
it
>>> +	 * there or found it: retract the PTE table, and map the PMD if ask=
ed.
>>> +	 */
>>>  	if (result =3D=3D SCAN_PTE_MAPPED_HUGEPAGE) {
>>>  		mmap_read_lock(mm);
>>>  		if (collapse_test_exit_or_disable(mm))
>>
>> result is changed from SCAN_PTE_MAPPED_HUGEPAGE to SCAN_SUCCEED to
>> SCAN_PTE_MAPPED_HUGEPAGE to get here. Is there a way of avoiding this
>> result churn?
>>
>>
>>> @@ -2805,6 +2857,28 @@ static enum scan_result collapse_single_pmd(un=
signed long addr,
>>>  	return result;
>>>  }
>>>
>>> +/*
>>> + * Try to collapse a single PMD starting at a PMD aligned addr, and =
return
>>> + * the results.
>>> + */
>>> +static enum scan_result collapse_single_pmd(unsigned long addr,
>>> +		struct vm_area_struct *vma, bool *lock_dropped,
>>> +		struct collapse_control *cc)
>>> +{
>>> +	struct mm_struct *mm =3D vma->vm_mm;
>>> +	enum scan_result result;
>>> +
>>> +	result =3D collapse_scan_pmd(vma, addr, cc);
>>> +	if (result !=3D SCAN_SUCCEED)
>>> +		return result;
>>
>> Can it be changed to?
>>
>> if (result !=3D SCAN_SUCCEED && result !=3D SCAN_PTE_MAPPED_HUGEPAGE)
>> 	return result;
>
> Yes. The scan returns SCAN_PTE_MAPPED_HUGEPAGE as it is, both callers
> treat it as work for the run, and collapse_run_pmd() takes the scan's
> result as an argument and goes straight to the retract when it sees it.=

> That removes the flag and the round trip in one go.
>
> The diff below is against the whole series; for v3 it gets folded into
> the patches that introduced each piece.
>
> Looks good?
>

Yep, feel free to add

Reviewed-by: Zi Yan <ziy@nvidia.com>

in your next version.  Thanks.

I am going to check the remaining patches.

Best Regards,
Yan, Zi

