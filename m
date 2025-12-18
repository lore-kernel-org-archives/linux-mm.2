Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 070D3D6E2AF
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 16:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 551A26B008C; Thu, 18 Dec 2025 11:28:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528E76B0093; Thu, 18 Dec 2025 11:28:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DFF46B0095; Thu, 18 Dec 2025 11:28:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 253496B008C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:28:09 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFD89B7A90
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:28:08 +0000 (UTC)
X-FDA: 84233123856.07.B9633AC
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 509D940010
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:28:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VlwrmdBF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mrpi8gSD;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766075285; a=rsa-sha256;
	cv=pass;
	b=oRRlikoLVKE6PlNvt8EdJxnOUU/CPaJSBg3kqJLWjDxlwhB/+meo5xXLAgUdaYMCizzm/1
	5CP1kfaTeSirc0xRZTqBO6dSt0g9faxhUso5bPKEXGQYNrTYdKQ+lgpMQD02l1orbzQohw
	Sa72tkib1JFfDRSTHzsUuvy6oEbvevY=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VlwrmdBF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mrpi8gSD;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766075285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RrNcaJrOzrHO3B8r9777iYJsmrOXcBeeit5qcps9kMw=;
	b=06oF6wxeo5ww7Oi2pHHFqjHQr9VxrT03QxZlRdkWoaLMVbZPTWyUyzHRz3yEOBiyFOAblB
	blk1TzVo11IGRStc3uLOb+/297Gi0N4B9durXCAKkkRMVrAI046Ejl6ORayeykOYfdF0+c
	bq75+IZWLZzWMH9Kly8x7slNvgdwQ5s=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BIDCJqU1211485;
	Thu, 18 Dec 2025 16:27:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=RrNcaJrOzrHO3B8r97
	77iYJsmrOXcBeeit5qcps9kMw=; b=VlwrmdBFiI66lun16++zn7m0vRTtMF5Drc
	MJeawlmmcx5uOKBLWzA3vJeZJknR7rxf8RWhAv6ZDAR4Mm9sSY7LjE9XG45MPvZc
	yLbz5NiWKZxX5lHUlzG6qfT/9RR9gZ9e1rChwptJk1eSrIDLWI2yUI0icnJcUXnt
	taLH/NqOKqj3MZc5XiHFfT2Bx2LxEsphidq6swdywPQwLXxktta9VmjM+qpiXMYT
	T47eP6bvF8RZIv4aZruLDDoz+1yc+yK7ij1LEg085+LpcgU+kP7yOBwdrf4mu/9T
	pgN4l2dDr8KsGsGq2jW6HQhHcGWdglY4k9f5Yt3DKsOp3L4G8A+Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b106cg30h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 16:27:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIGHkxo016433;
	Thu, 18 Dec 2025 16:27:32 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012030.outbound.protection.outlook.com [40.93.195.30])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkpkwtb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 16:27:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NU7ilXi5O2q9qes/HE8Cd/QdRb1RbKYays7fyJK1ioWmQUrrF2xfl3xrcX7GW1Iehw337UJ7fGT0JPLPfryvKomvn6ZQyNMJtQuly90daHTGwCbjdnI+dIEJjGz73dBYW3TVsNdUOnwZqhhSVb3IxAumu3LUYrhkLw2c1LUgMBhSQnN5dOW5zgsK0ogi+XcVFQQ7oeh2NZd9NuhT8RMZg/csIrZnPgaq+xwcZNt6RtC/P4s0lEiQuVXYMEdtdOAhO7SB5Ei0kY9nYak2aS6vThcznTb/e6z+11iRGhIgD578ewY3NWkXaJjKH55O7Kh7dJnqArFNQXzWCqSe7GUSVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RrNcaJrOzrHO3B8r9777iYJsmrOXcBeeit5qcps9kMw=;
 b=LB33hO87/7cxiZRJu0RupsgesGZopcrxPyGtryp1pO7394omhNpTUyhs7LfRk2B+9YduZbE2cO8CU5YmhcRYk121ZjdQLBp+IDmZTSHVonQqlNkwW/G8t+G3CFuWTNfLWtn46wzRmld52pm8NTHLxhGnnCGTIdMbKQ5Fq8Bp8tMZEXO+6QRTCdr0aiU5n0Tgtmhhg4CrOgORfQxUvFLBbAPECwEtNBwnPeJgwExPBdWPXAfuFXrNHM3NAjZRVoRWZm68iEEt5LSYJBWaEO1844RXTqTYIjaK9CrvOp2+qVTzEk0jc3uqEj5XNtxSpAKVN0FzsdcGhBsrP7hPXfgRLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RrNcaJrOzrHO3B8r9777iYJsmrOXcBeeit5qcps9kMw=;
 b=mrpi8gSDBhO7LsMsrLbtA2W6acqO1cD6yLTx5Vi2dQzybeRItg9mD433bZezGSna73pGmQr2mjmAiX2g+r9qC5vagEwGaE+xxbwns89gXlLAPw+df3W4GEvEnmUdIt8gXaKtjF5zQ0cM/lJKsaagBz35NrSBBHLHiiND8qbmt4w=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB6774.namprd10.prod.outlook.com (2603:10b6:8:13c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Thu, 18 Dec
 2025 16:27:27 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 16:27:27 +0000
Date: Thu, 18 Dec 2025 11:27:23 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: chengkaitao <pilgrimtao@gmail.com>
Cc: davem@davemloft.net, andreas@gaisler.com, akpm@linux-foundation.org,
        david@kernel.org, lorenzo.stoakes@oracle.com, vbabka@suse.cz,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        kevin.brodsky@arm.com, dave.hansen@linux.intel.com, ziy@nvidia.com,
        chengkaitao@kylinos.cn, willy@infradead.org,
        zhengqi.arch@bytedance.com, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] sparc: Use vmemmap_populate_hugepages for
 vmemmap_populate
Message-ID: <w4ijtqxe5xnbp4hexccs7xwlqeiazzbix3rmlrskcwsizzityy@67kmfpp5pjp7>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	chengkaitao <pilgrimtao@gmail.com>, davem@davemloft.net, andreas@gaisler.com, 
	akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, kevin.brodsky@arm.com, 
	dave.hansen@linux.intel.com, ziy@nvidia.com, chengkaitao@kylinos.cn, willy@infradead.org, 
	zhengqi.arch@bytedance.com, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
References: <20251218130957.36892-1-pilgrimtao@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218130957.36892-1-pilgrimtao@gmail.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0091.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ff::29) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB6774:EE_
X-MS-Office365-Filtering-Correlation-Id: 85802225-f08d-4c10-d6aa-08de3e525547
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z0X0cP8eUg1BKLHywMX0sCIiyuV1he34bFOKA/xlj8wyys4LwZShnXzlyU8X?=
 =?us-ascii?Q?S79RZK7tS//3AJabL0J3CbXuGsx6XS2boA77lzIw365Or/DpFshTsQVtGTmE?=
 =?us-ascii?Q?MwLHWiuXis4eemNxIgiE5cgyM+lCTQjABByqVJE7GwN2VlIfxQCoJAEWBMjc?=
 =?us-ascii?Q?foSmN77xFrFCX5Aco5UtIqocmusqpNMo9MQDcznrDb5p76cAXrqzGCO+2MaM?=
 =?us-ascii?Q?1xUh5dOo+EjGcWDJoT3f5iI08mmCbaiIxUZ2Rq6NfcaTVjzUatLnm5/b0N7L?=
 =?us-ascii?Q?H6o9vYVDtzTBdna7DCw9XsH2yjTbGEsKEyu0dHZx0IxftzI0l0RoIV9YwhzG?=
 =?us-ascii?Q?MKGwi6tWagIbzxOcmq2cRyoD5oi+H6ZxlV66ItmEvolJy/OLmt0uigLrCBir?=
 =?us-ascii?Q?y4duXVWeF0lgfiMnzysuwIuRysqy/ng9AqbtYpbUj0Vh2++nD3Qoh5KjqjEl?=
 =?us-ascii?Q?yW9N0kBFZcEEXPyZLIREvFzb5UKQiPRMdAcs7eQA/0qoA9Nub8XyUYIa621P?=
 =?us-ascii?Q?Gg3vTEGhi4vHyrUDEmzYNtzkuLi6JVwL8/O+6Vqe9t+mKHHM5nj4eN4tmwxz?=
 =?us-ascii?Q?dz6Xn5PvryUIaKn1Wtk8Jx49n8mLg69QDVobRr37xjOB6wNx5CeefTOWKkyJ?=
 =?us-ascii?Q?EdxDT1TJWXk6Fk1+YL1Vc5Cfpbul0JUwORvPChoZcw4tgPasemEegufZpc5m?=
 =?us-ascii?Q?NlBNLGHflFjrOPtmyKB5/JeS3ewCik0sFZDfssKLomQOdExqD/ruA/fc/VJr?=
 =?us-ascii?Q?R9nz4rvrUhVa4dKpNWQvbW3qUCPR9Zunc1qQNLWC6qpWwaHbdfwkXz5uH4Fx?=
 =?us-ascii?Q?PPumrnp6Jsy1G5etqo9MRBMP4XZ7gwszPh8nj4ZBOjeLUPyFtz2E9+IeN4TP?=
 =?us-ascii?Q?bl5CZ8D2b/TAyhKkyW5QjXGJEAq4QD5XragsoGXA+WTmg6Frrt3zD82Dd3lc?=
 =?us-ascii?Q?5yhI9pNKvFqPZpQ5xVpXCrjje+KmZc807ChSnDTaf4dmi7Ih0zfxzZAnxYx5?=
 =?us-ascii?Q?B0aaZtGIMWtBx2UTXYIZjmNBNUv/Ri0TEa2UxVJ4Ya/DGGr+wDxQ+/WsoLOR?=
 =?us-ascii?Q?Lrs+YRz3H6JsQQv6SIJcDfYMznxs8aj1HIQhH7ZuKr8ZNTMkI+10WSsTrV0P?=
 =?us-ascii?Q?/BPS7iIjNit6uaLtURCDHi0c65eymaTgNxKp3qjT/lNkY1M22AZ9OsC2GA77?=
 =?us-ascii?Q?1X0U1JC+fz5wtPPXPkb8/Ni92heNkY9PaQ9flk6mHkNzbTJlh5qs7XCg+Vdx?=
 =?us-ascii?Q?o9mF9N4S0R2qGjGyz9bmrogFuAw+ER74PBFaakHrI0c+TTYx3sUteQLnTsKg?=
 =?us-ascii?Q?teM1QXQsZlm8jJwzVwddPBqp+omNJFXeWGMmdpsRbXeo5+lR0FbmjT/zcWYZ?=
 =?us-ascii?Q?qC2em7LhzJkcgjtUG0ROBXmSGHHx7c8DS97lH/w/rXbXnRjtvECTDMdc0ehF?=
 =?us-ascii?Q?BEsgxBsw9h66CqjmskjR5eFEOTZSAed5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Bu/u1vhIC+LkvrNMQewy/a/gY6FYNWrjdmERcjEWZhUFuT41lQMDo3b+GW4C?=
 =?us-ascii?Q?M9HTlNOe0tpXki+U3OPI+aAWBGCXCzNW1D1rsaiv6TQb87dH7WOVdXCi+2D+?=
 =?us-ascii?Q?GC8KmKET8+aaBjwdf3uCd6QCeBrwZBdhJGaGVIqUj0ogdwAArdDG0n4Jgba5?=
 =?us-ascii?Q?bZZt0iSCFR5Y+3ShCEUuwrzxYePCi3JWUloSQOLoE4iY5wzh5lPi1y2InPsy?=
 =?us-ascii?Q?llvHFWISyoBzeL0553HOzE3hVzr5Z8dDqjxVLRIMSRs0m6HCn1+zGzeUhBeP?=
 =?us-ascii?Q?SEwWSqL75IE4hYhCZmxgNgHHl30w3+pnnH3jqSeU2olAt4uhU80NFDM/frCF?=
 =?us-ascii?Q?xpfQBRLYILXJ8AcmopY8Rv6V3EUs/Ig5XenPYsr/xQMHSThjsdPqHPERYyhf?=
 =?us-ascii?Q?PnvX383hfmhmjGXdKWMUaJgOhLP/iMxpeyeivxnQAiBPrrxphCgeG86bWDZX?=
 =?us-ascii?Q?4GO2nFxl/XQMCRsZKhA3522xRoBuw12vKroqBDuh3UjFxOKLznTPfzS/w9lb?=
 =?us-ascii?Q?LCa/Ltd2hA6eUyHT6jk/oHqoYA6+tRFCLNh/VwYWBpdt14o/cbMBBt2JHcVF?=
 =?us-ascii?Q?Ao3fQrws4fbISOCLSPdPwq2Y/HbhcGLVIburV4uQyLs/smTnBIKGEa79oiqn?=
 =?us-ascii?Q?Ujwwpr3J2vC2L24UBzQtnUIvCXubr/dQjypf5Utt4w58uKEhPG1bhOX0QNcZ?=
 =?us-ascii?Q?l++E4CWurxN1PZqhBstw35veT+rPQ2DDbdTmWb9LLZGA8KqvkXNj1wTOFlTu?=
 =?us-ascii?Q?FtB843XYfreVUIwDX9KcirVzOMOYO6syri0g8cRvdSVBRxIN7ur9LfZIh/vR?=
 =?us-ascii?Q?nB0OcEFFdLIrG9cA1dMjqO/4P6DUhEZ8Pb9nt0zTDPvGQ8NSrm6aD760yLi4?=
 =?us-ascii?Q?k3YjEfY1ta9LxuU9QNzwWYYYEOYWi+p+3jH/Gr1TMOoyA/AX25hXUrubBvxE?=
 =?us-ascii?Q?xFCeQ8e/ESNN+ijuC8HVutn/AJtey1jpNoZjh7AzrPAU5cqo4rW7KqFqclGL?=
 =?us-ascii?Q?j1DHv0AhmHpqjRzKJNQA6EiRi9aVMWR0zJb1LmxI0A4q3aa6kUyaPen25xpI?=
 =?us-ascii?Q?6g9KK4OEEgNU2oO9r/WVsp8CIP7f3BrE1740a5jp4t1mNuRSD2ruZi6u4vS2?=
 =?us-ascii?Q?S+oTTY5NLDl8uF1PNDzoSpsP10Luml2ZYLy4LcVu457REYTTSzmcsTue9p03?=
 =?us-ascii?Q?AL71T3HbX90B4jnNfZ/LO294NoRK6m9IR3Xm4FWxOfWX5hv7bc03IP2hgiZl?=
 =?us-ascii?Q?rYcxbUCooCJRl3mM8r+e9wKHIAjU4a6GNpsdXKvaaY1yIeex3DfVuwgh9muf?=
 =?us-ascii?Q?LcyNn86qLy66R47kzMVfckmZskoZxvcQBLbePmojZvOb8WUXxh6yyTjZuIKF?=
 =?us-ascii?Q?YjJHdqsMjzRsfAMX0guPWG6lKjI5YI/A+bZ6qcAjXJt2CxkE5RlP/TXSilya?=
 =?us-ascii?Q?TGkYly4ctQiZdFOeIHNRU2HvuaT+g2kCi0dC/yuza/CRN79M/5xDMSFHhZxP?=
 =?us-ascii?Q?0luQZMqRd9GLHuTgOhlnsncb8YOiF8wIFA7F9Y0Mz0wqZCjypkzp1r8qn388?=
 =?us-ascii?Q?9cNvrxIHXIRyeUCMJ4M64b9jgM/2trHoA8TbG2Nu?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AY58h8IytiC+cPaSuFfaU6Wla9OT9OrVR9PGFRQgvb0Q4KNmvHCVS0bfMOXF8tAqTjp0uVSojGCxLMZ8OO3lQynbChIH3cOpI3aQBFArKtFpgsy42sHto8KxEka34R50xnG/F8w4X9HAI6i8Y3Lchupyckmz96TzY2HoThAITfxkx22gWq94vWpK8B/gMW3mC5ix7/1R+TO2oQkbNDUPycqQukUST/NCkScSAkdGwvLoNWwQWBTouSzxCjoFnamTOxgmtgDjnSj+2RMA4UfTpQgImJHCqKDC0jj6TRkvuoeS0e7RDACpfUfW9fJTtNA4feOjH0nsjXJWFupTmOPihFWcq15W03LwubLUkR7yDBoJ1Ey06732XEvNbKWDyD2j9JqSdrKpiFs3fCWq7woBzF9MXHD6JlCYAYa7m25t4kuDviebFidmXXpTvE4mH9fykX9uIU8yim045iAAXwhfKMZ/lep2IVmypgbGgw6ZjurO1P2CJvW1sx/dJDj/m5TMNs5Rl4Jx+rxw6YQGz3FnHmKWgqcIOswFTsHwXHvXTKCJjixC5riFjIo473xmZglTRtJpYiN0gb5bFo9AkIMwJIBoVBHlhAO03o2LBEtwh60=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85802225-f08d-4c10-d6aa-08de3e525547
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 16:27:27.3442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eh5VymmvPPdPCEsKDYKd6pnsE3Eq3fDnuJgLVMh290W3zR+so/qSdZYkS2tKMshiTcTZcGAg++LHS87ASSmjRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6774
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_02,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512180136
X-Proofpoint-ORIG-GUID: 1_aEF9OpHkcGh3ldYGAYNKLEtsEh98c3
X-Proofpoint-GUID: 1_aEF9OpHkcGh3ldYGAYNKLEtsEh98c3
X-Authority-Analysis: v=2.4 cv=et/SD4pX c=1 sm=1 tr=0 ts=69442b74 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=vXTRtSyLzAjqIVWTfoIA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE4MDEzNyBTYWx0ZWRfX1Kv5rad4j7Ob
 NSmk2tBw9qf747IAbmdtLl3iVvWKbyL4xlXFmLz3axj9cdnEOS6+Fgy12zAIknda6vLGUV1zgrZ
 7V3FVxZ60fTIabX8z9Ujra/b2KL7JnAuKsIaGJ+SVabSTBhZV6OFuPG2TqrZOlorJu775PcSFwk
 shbXWOPxTjWbsmkLaZrqALJ5dPxBRcGsUYMeicbsag6oluWDQqliu1rXsgyRLLM/PkhBf+YmpuO
 sljyb61mN0pGqiP/7ZSI3eWRb2Ps0aeOSfSjt9LoL+XPb+hfiQN6OFiOyvYJwd28JfI+6oU7ng1
 4yvcB7Lczv0tDKV+4OA3IaA9S+MrmE4uLIN4N29gy6yfgr6nC2aTYcdR/KpGu0IfYHlS+xHep9g
 onupv1IvsuUTT1lG4vWKUf4tuC998WQa/DaF0e/1EZ69YHVVWu8=
X-Rspamd-Queue-Id: 509D940010
X-Stat-Signature: 3uiwt4bs11emjegbjxiyy1ydb356z4ic
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766075285-352324
X-HE-Meta: U2FsdGVkX196wXk12iFct9xIJXM/XGCHgHshQIWSgAcN5M1MXI2L/DCkJvOBvtTOiC7lYdlsVUlXT8GJAsNbvkJ89Kp40GpXghKwPCVGoo66yKI2Sdm5+so0JV7mpkWm+EiuZy3pZuzOnlkMb+8z6IbNRH/iWAhfStf0H5aksjTPpGFoDbn08IOxAfV7cd143eKkV1HqnYproXs1l80bAFeegd+/Ea0rsBri9K/Z07Dgk7Qp1hlZeIYl4yWSds1L2HvOB2MuxVviHziSyPNergQOXG/ADU6k+ENLIBQI9GB9KDt+3AMs+dNik+kfWN26X8b+6lxudZJOodvsMwpSWt3kEnHPp80qaICqhSinPeOX9EnDh/HGHDGeb6T4YD+97RjMXbJAYbR+dBwbxNPnmCAsWSA0f+sXRSZ+Hp0gK44IQEtEbJVQuF6jiUN8BDxcsAgqnHgJFKeZnIcxZLTHyig4jihm4/HIRKS3KVCm+e2k5tCdWfZhljbp8bJI6kn1GBCy/ct2ctKMauTDMTQYXUqC4RI/j/1B7CjPVpxuFQscke1L33hffbgUNUM0Wf6p7vQNIl/lEjx6J0JwlR32p/BXFpy5mvIQ5ZdweS0x6U69ZoNu6vaC/R5LwGRGbqsbgD8DC1nUsxxKIL+cLGZrGff/bnJzCF74A8RKMFWEMlsFyKonjODX4z4Z3sslLQbgUXr/JpJbXh/r+yWRraiAy79VZHo+79FAfqr4YShjCBp4E3jvMnlqqRIDAsNbllkaeKa8L0dvFn/EzfCIhVzCPYwQO0UzjU69HAuD5ZFm+VYriornsRgxnC/LwITQTUVKHsJLN+8w+Wsz6H+b1DW2SIDtpIBd+w3FtJ4djpIE4j2MyCKfXsYW7lqBWlXFU4TWGXk+odMoAALkr2Iu+VIbeOjqqPFkGqsVwhPpWEA2ZZDJgzJ8Izjq4OG9GxPOXq7HgkN+2m6Td7HSAk7bblR
 OcgzTSfN
 CavmS8MNqibhaxPTpSB46pVGfnifnbGX8w2at3h87UKxWKuyZyuNd+nBNH4YuUVJAx7WSgSajKK6tK36q9AeQ5WPXdFqWI/URjIQ0fzPvufCcV7LP1qY0eNVAOobldE3783L4K7FFMBv/Geqfj6oWiQRHlAGAqV31u2JiTer/cvLUcZ0yCcYWa6m24aELixvMCCCvC2Ktlp8gIU3xeRJqH7+p3xfkeoGRNdPBCh3nGRZJc7cPFTBCkAHEVopQwrkDhmVTnLlN0kWuA4IzwGdRyQ1KPNyjONvyNVADav74N8ujPfdLp5j6GmD+FnB/KtPEs0RdnzHNDdOhzVGlQMsyiNhy0+YSH/ToSFn28UYpuch+c1QgA+37zBYryHNZqO7Eu6X19Z7x9tNSkSvDOrv4PGy7ljvchMySLctvWjA4uq833+BfsSkcsnz0N+TBkM/wTrVA3xYrQZjlowcvMOayLFIOsnsSDixBVawBly/74bFP+w3/rPYipJxIQNVtrC8AYzIiq8II5UEyW/JnQrIPtXf4ArM/+gPzlsrhzP+AKg1iTIEEHVZflZOZopE1eykcEpM0FYLRKbGx4e2pW/RguZzkLtlcO1/r99lU/VEfs3+SAlVtPv7b3hp4IIUfMfr2T5Npe1Gcwl+Fv+YKxkrRaNqb/tTNAhRKQFSHf6k+bQmzBjghH/I2eW/CXM2FGp6VF1XYhB0zaXCBNaS5fwHeMVXIqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* chengkaitao <pilgrimtao@gmail.com> [251218 08:10]:
> From: Chengkaitao <chengkaitao@kylinos.cn>
> 
> 1. Added the vmemmap_false_pmd function to accommodate architectures
> that do not support basepages.
> 2. In the SPARC architecture, reimplemented vmemmap_populate using
> vmemmap_populate_hugepages.
> 
> Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>

Can you please fix your email client?  Your SoB does not match the
sender and your responses do not match the From of the patch.

I assume a v3 will include Mike's suggestions on v1 so this is already
out of date?

Please rewrite the change log to include the information that you
discussed with Mike.


> ---
> v2:
> 1. Revert the whitespace deletions
> 2. Change vmemmap_false_pmd to vmemmap_pte_fallback_allowed
> 
> Link to V1:
> https://lore.kernel.org/all/20251217120858.18713-1-pilgrimtao@gmail.com/
> 
>  arch/sparc/mm/init_64.c | 50 +++++++++++++++--------------------------
>  include/linux/mm.h      |  1 +
>  mm/sparse-vmemmap.c     |  7 +++++-
>  3 files changed, 25 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
> index df9f7c444c39..86b11150e701 100644
> --- a/arch/sparc/mm/init_64.c
> +++ b/arch/sparc/mm/init_64.c
> @@ -2581,8 +2581,8 @@ unsigned long _PAGE_CACHE __read_mostly;
>  EXPORT_SYMBOL(_PAGE_CACHE);
>  
>  #ifdef CONFIG_SPARSEMEM_VMEMMAP
> -int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
> -			       int node, struct vmem_altmap *altmap)
> +void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
> +			       unsigned long addr, unsigned long next)
>  {
>  	unsigned long pte_base;
>  
> @@ -2595,39 +2595,25 @@ int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
>  
>  	pte_base |= _PAGE_PMD_HUGE;
>  
> -	vstart = vstart & PMD_MASK;
> -	vend = ALIGN(vend, PMD_SIZE);
> -	for (; vstart < vend; vstart += PMD_SIZE) {
> -		pgd_t *pgd = vmemmap_pgd_populate(vstart, node);
> -		unsigned long pte;
> -		p4d_t *p4d;
> -		pud_t *pud;
> -		pmd_t *pmd;
> -
> -		if (!pgd)
> -			return -ENOMEM;
> -
> -		p4d = vmemmap_p4d_populate(pgd, vstart, node);
> -		if (!p4d)
> -			return -ENOMEM;
> -
> -		pud = vmemmap_pud_populate(p4d, vstart, node);
> -		if (!pud)
> -			return -ENOMEM;
> -
> -		pmd = pmd_offset(pud, vstart);
> -		pte = pmd_val(*pmd);
> -		if (!(pte & _PAGE_VALID)) {
> -			void *block = vmemmap_alloc_block(PMD_SIZE, node);
> +	pmd_val(*pmd) = pte_base | __pa(p);
> +}
>  
> -			if (!block)
> -				return -ENOMEM;
> +bool __meminit vmemmap_pte_fallback_allowed(void)
> +{
> +	return false;
> +}
>  
> -			pmd_val(*pmd) = pte_base | __pa(block);
> -		}
> -	}
> +int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
> +				unsigned long addr, unsigned long next)
> +{
> +	vmemmap_verify((pte_t *)pmdp, node, addr, next);
> +	return 1;
> +}
>  
> -	return 0;
> +int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
> +			       int node, struct vmem_altmap *altmap)
> +{
> +	return vmemmap_populate_hugepages(vstart, vend, node, altmap);
>  }
>  #endif /* CONFIG_SPARSEMEM_VMEMMAP */
>  
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 15076261d0c2..ca159b029a5d 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4248,6 +4248,7 @@ void *vmemmap_alloc_block_buf(unsigned long size, int node,
>  void vmemmap_verify(pte_t *, int, unsigned long, unsigned long);
>  void vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
>  		     unsigned long addr, unsigned long next);
> +bool vmemmap_pte_fallback_allowed(void);
>  int vmemmap_check_pmd(pmd_t *pmd, int node,
>  		      unsigned long addr, unsigned long next);
>  int vmemmap_populate_basepages(unsigned long start, unsigned long end,
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 37522d6cb398..45eb38048949 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -407,6 +407,11 @@ void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
>  {
>  }
>  
> +bool __weak __meminit vmemmap_pte_fallback_allowed(void)
> +{
> +	return true;
> +}
> +
>  int __weak __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
>  				       unsigned long addr, unsigned long next)
>  {
> @@ -446,7 +451,7 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
>  			if (p) {
>  				vmemmap_set_pmd(pmd, p, node, addr, next);
>  				continue;
> -			} else if (altmap) {
> +			} else if (altmap || !vmemmap_pte_fallback_allowed()) {
>  				/*
>  				 * No fallback: In any case we care about, the
>  				 * altmap should be reasonably sized and aligned
> -- 
> 2.50.1 (Apple Git-155)
> 

