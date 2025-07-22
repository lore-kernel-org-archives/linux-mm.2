Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B6A6C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E58B56B0096; Tue, 22 Jul 2025 11:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE1D66B009B; Tue, 22 Jul 2025 11:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0D556B00A3; Tue, 22 Jul 2025 11:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A7D116B0096
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:41:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37858140329
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:41:28 +0000 (UTC)
X-FDA: 83692315056.01.9E35C8F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id C40EC40007
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:41:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QEpaczAI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SgYVtGe0;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753198884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LjIH44bhcfaYyeVGtrKOyWCdPyIJCfkyVsiHMgFvhlo=;
	b=GM5BQZ6pkDYcOINDJzI5aIWLH0i0BqrrItVpuMLd0PKMrjjLCximu/Xz9AIo8tlXV/cC5f
	HcK6zOvJsSsf0TSry9NXq1VlmGG1Vw6FPQSK+xNFij0PE1k2VXraffEpCgeoi+CWdtqD+X
	Odv9/KqRYHXyKlEFUut9roLz9GI/wSk=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QEpaczAI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SgYVtGe0;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753198884; a=rsa-sha256;
	cv=pass;
	b=mdg/9rIHZ/FCpfZFGueagR9k0pBrLg5N1rPC+u3Xfh5WVuSfL65asLW7ooUOQKywLoRLU6
	1RAd+OUWhBIFz3WEn5fqDLEh8PBnAE7uvMHP+VTnlQnljJD4d3pQ9A1W9/LuM+7Rt8sn8r
	85eJpfGsj0F92NMvBA0S7F6bOw7UzeQ=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56MFXt6x028599;
	Tue, 22 Jul 2025 15:41:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=LjIH44bhcfaYyeVGtr
	KOyWCdPyIJCfkyVsiHMgFvhlo=; b=QEpaczAIGUjlZ6JDahHwTdw3PClqW+IBGP
	qTHw4n67sSAqO5S8FOC3h2d5JjcEWf0frfHHSyEdWJcZQ7WKiSFTSOa7QqYHjKXx
	jkk+DAew3LlAjWvNgFcsp/Fv8bRkjpMyVq5OCtU3cwRWrzhrhJ7xFtA47LamHiyk
	b4epQfNlqcxjoEYWim4K6U2J/8HQRWab3FJXGNqx+9czLCeSoDAJRer5bv2XRWMj
	regyCvYYfq0CfW+224gSKCaNGp0wPy49b9YYbfZF/sO7IXNTas1trwKOSTEcCpsm
	KtYMDiIfZ71wnkDDJ1TCT75kYoPR1YvGotuZwDjBxduDW27HnkoA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 482cwhr47f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 15:41:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56MFHSJc005769;
	Tue, 22 Jul 2025 15:41:17 GMT
Received: from cy4pr02cu008.outbound.protection.outlook.com (mail-westcentralusazon11011037.outbound.protection.outlook.com [40.93.199.37])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801t9g0nn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 15:41:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XP/FLVmE3jqiGTEoDKjhSuFiIydnI1QBT5Afq4ch3z53BBQw1gWZSq5iiw9uIm0bLP5c3axLLVV2dmIo5gi6Z71nzId+IezRdeiWC7uer/ppmt0QiWmTKk8NXpVRVyuOFPRtWf9FwWjRm5vCvEiCJ3PmfmWWiBrgReUTNPb2MACJgyNS/t3vlfw2VrnkEgRi3FQoVsfyB9Y2LXpMw/PZ1uUHJfmytJ5MmYA7Qw/FKXsHE3rM2cJKddSf1lv7L68sU86SPqu6ap5YRNl8UZo+R2gFUpBC5YA+A4aNd7KhkV+QW24II4Tq4o4/5jGHNJuVKop2DXCKb7IU8+qECS8pMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LjIH44bhcfaYyeVGtrKOyWCdPyIJCfkyVsiHMgFvhlo=;
 b=DeUSJDxt8Kx6xNnuUuOWI0/G7hFLkoUzpU26eKY36KWAG7RCslP3oeHA+Bd1R/JUcPZGaKHuH0BID1q8J4QhgjsiwGM0onxJn3etMFbN/Q+rCWyd3r88XCnzAKdx4rbSeXon666QZh1xdaOV+oAwLvE9mNgMpMULee8e0a2z/wmPAT7cbph1ndMl1/Ic/7IvXW84H7FL06PYQ/OkATRfC7rc3Ano2xc9r3kZU6eL7x5XC3XuQZFSLRtfmY8fKqHQVi3DS/bJm81JQdcSNMD+vEZZ/sCOqSqLKvIKHFbil2vd4W5fJdKzPAZsRyoQTdJzAJdUWaGMSioppGMJD1sg8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LjIH44bhcfaYyeVGtrKOyWCdPyIJCfkyVsiHMgFvhlo=;
 b=SgYVtGe0YZZ7uG7zJLBGNH1JeIj5sDDwOeJeV5cBvapVKBFAbEtnFZgKMEeu6NJFesM1ZvyDPe01/FRU87Zy6qb21TjOtTl6b+C2XBMlRJ4IK5jmlKwK7llr5HXu0UqAHaUyJpuQlWMuPAoTa49Cduo12PVyiPOZ6il7u2Ukj0k=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPF545856187.namprd10.prod.outlook.com (2603:10b6:f:fc00::c27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.29; Tue, 22 Jul
 2025 15:41:12 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 15:41:12 +0000
Date: Tue, 22 Jul 2025 16:41:08 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: syzbot <syzbot+1c6607097b258f18065c@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, brauner@kernel.org,
        jannh@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mjguzik@gmail.com, oleg@redhat.com, pasha.tatashin@soleen.com,
        pfalcato@suse.de, rostedt@goodmis.org, syzkaller-bugs@googlegroups.com,
        vbabka@suse.cz
Subject: Re: [syzbot] [kernel?] INFO: task hung in exit_mm (5)
Message-ID: <4ca54a2c-46c8-435b-af72-7f871236eeb2@lucifer.local>
References: <687fab8a.a70a0220.693ce.0104.GAE@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <687fab8a.a70a0220.693ce.0104.GAE@google.com>
X-ClientProxiedBy: LO4P123CA0149.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPF545856187:EE_
X-MS-Office365-Filtering-Correlation-Id: 8af1f068-710a-4c53-c08f-08ddc9362fab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LNMRDJGYj/FnpGRyntDo71W41qfxO6Bb76AW3NF6E9ijSy4sVWExpCAMIthI?=
 =?us-ascii?Q?q0gfk5fj6kdOHlXSPpKBkZF+jYtLBxDxj+1+6z5CQTVU1IWIjjuEOYBYrzUT?=
 =?us-ascii?Q?slV1bAua/bivoP10OW6bRfejS4F/b1cCgmHS1uDo5tIr4tjamjtNVMwwB1uW?=
 =?us-ascii?Q?JdBYVQQA2aDoPKfy3lmyoJwtEoOwgXddaD87xOTx/rGGYMGqCIwYzJ8kv+aq?=
 =?us-ascii?Q?oO1dRTd0+bqBlyns9BKVz3gDU28R9xkNDK06Zu1YIZTD0A/4fwwpYNSXa1lO?=
 =?us-ascii?Q?IJHWOpw7e0UKI8hctTIrilmOWujIMZBDLmHnXXEQOfyc6Q5eD+EcF+2L7Gop?=
 =?us-ascii?Q?IoXxlflNV0jTqz8t0kqjiPkiBzNdYYlzZVHQg194tvZ6aKnqfGFDvisrn+JO?=
 =?us-ascii?Q?MumTLSRYSMCLfeI/q1DNfhzt9ruORlLy17hcTFCtN2YUqh1O0yTKxu3q4hGY?=
 =?us-ascii?Q?mS03/Ax5VkYBjBB8AVYTNxl3SjySQ3eOClGSlGsDhVaDwusucEotBqsYdk66?=
 =?us-ascii?Q?3MFikjCejva3ei4S65guHdfnskvcZChOHAVWB+hwbiXheWkv7HrneKzMTYlU?=
 =?us-ascii?Q?Fv+xMeEj8We90TEtaK9htrr+hEGgexi/m6q99/XzZuo48/yjyfW4o7a8Basd?=
 =?us-ascii?Q?sNm1w5w0Lg1zzVEZjkMM+pgpn4BxDMVhHDxxzvshJ/pMMF1VqiJCN/L27elR?=
 =?us-ascii?Q?sfGHsEnj3MmdCetfBi2+1wpCOx3COa9hbQMYnBVeqtriQj0YBzekWQRj+oDF?=
 =?us-ascii?Q?3gf/ONiX0z4sIQIbgoMgnwTjCkEv6lKImj0cS15ISjUja8e0S3AG33BFEbfE?=
 =?us-ascii?Q?luq4SIMxB3qsgskE1O5ClapUyyy1cTeQsaf2KYqTOJu+PvENxJorj+lk6nZn?=
 =?us-ascii?Q?xYI0lRtki1vun8t9tIUBbu4ByNHm3kpiEWJwzD9kjyPhknb+ZmxnKMS/ocu0?=
 =?us-ascii?Q?J5dcpQxnwB7binRpNKz+geSP92fjqETlZ+ZULx1fpvK1wn98rc0WerBp0PlO?=
 =?us-ascii?Q?2AzFfp1Fj8ze7rdb1+1iGlcd5JmjCwgYRoxWLQaSUpOtddwA3z6a4IVStsII?=
 =?us-ascii?Q?moq4upHQ6HNZ5dtfUZMg0GhQaOJGccMyRpBA90nQ8P5/zgjVmLifJvbu91sm?=
 =?us-ascii?Q?wlGxanlInqg460j4D6gVUUEb01a1cjFw+mpnlm1tHPkZ+a2F+JOrAmbedmh5?=
 =?us-ascii?Q?n/q6OPIV0d6dHKLHdB4XZcwfAwrYHACDFKj7lZWTX/1H0gZwL1wReSNGokMy?=
 =?us-ascii?Q?5r8vOSpu2Lx7ZbKwDNuiG4qfBYry2iQVWQFeTmulIOLG3C78ccgMBa0Q+OWL?=
 =?us-ascii?Q?sEBGJ5+78gW0pS7x0TnDlz7WMixl7s26UtV1ZW3gkU+Gsq2p0zyoPlQrV2RM?=
 =?us-ascii?Q?po5VaeEUZW66xsUWGNWEnNvJDPka?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8qK3V9tZGHTgHDFrbw1s74j1DGXB8h55G9jvpHKUW+dSA96rrH6UmG7TciWI?=
 =?us-ascii?Q?aqreOtp8sonDXb808Xe0utbz0sbgFU46RQfjZQhkZQNGpHbjD+D/BwAXVxrE?=
 =?us-ascii?Q?4lWrlz6ymOqLpgP2Ty1yzXFdXLpecgM8QEcHe1pU779ItigF2i6IAiBfGJ3J?=
 =?us-ascii?Q?rg6s1wCUNCGZj+pWMsCHxiRceJGXFUT1nT7TXGgE2srvmzuRFnE+YUEHv2Jt?=
 =?us-ascii?Q?lJ1x1iVciIXbh+9umw2qSVQtow5TCEbqkvBbx5/QnU9MLTuG/kfIdmXoVXi/?=
 =?us-ascii?Q?g3luzHtlT//+lV6l52jtubPWN/laBbUTdCzXdV8sYnRBkOB2Fr/B/AIXEpvZ?=
 =?us-ascii?Q?SvaCd9Gt8DyC0XAnOt0W0RLhiyZkl0mICAHKXEH42NxLZJMHPh1gzAwC2Roh?=
 =?us-ascii?Q?W248Bp2d0ql0PDhfepRAjD+hnStEbTEpB58nBTC3G2n0sy9EN6JkGjvtN9E8?=
 =?us-ascii?Q?ni+JAFquZ1CN/W4clsS/dc9c6dIlRsqE1RNqdmWgbLDKx+8J0yWrvv/4gHaU?=
 =?us-ascii?Q?EGZI746f9dERJQzPZo8LX1TLHZoYzaaPYbZVRBJoeiAI1uxlUwEpoEQ6eKMm?=
 =?us-ascii?Q?zme/0Q3qRpTpYUUP6ZdLT8jRgGsbztEWiUC0JlcgspaWkneDoA7nMl9eaPXl?=
 =?us-ascii?Q?Nfcvzu94dPaXFpF85SjdFNem1wDGEr5L0JdfRUFrgQXilske8M6SThoo1cW4?=
 =?us-ascii?Q?k4iqwIXGKtdphnSVVxdtrOS2telpAo+DTp50piOU0unFJ9GTAJpe+lVyX8/f?=
 =?us-ascii?Q?8UV6/tz2zwMTtHHPUJ/syZNn9wjCTVKm7Bv71f7S8JvA874o6KevbpKNbQ6N?=
 =?us-ascii?Q?luWrlVaI7BUNuLFkUL7tZciVZWlrlCB9kCDJhz9m9EKqhrdIFhs6wTbsy6B+?=
 =?us-ascii?Q?3sMJCc62lCWY58Ebpx5NY1hkRvc/LGAzKOf8Hjv/eP7V3OOa0arhQUsJlRbA?=
 =?us-ascii?Q?rM/C6T9UxOVPsfaaEuyV/rhKt+xBsN/hn4y8h24+qGZZQiwYSSn5gA0YYACt?=
 =?us-ascii?Q?mk5RH+oGsxAcOOMuQEoxNNDBCsK/6FwSohSXQlbzlZnrOLLJyzZNCCuWYvwE?=
 =?us-ascii?Q?8YnvQj+Po95HyfseI6PpoKRzT/FN8GZpVViGYzI0CFKVJUzWF9LPr39cdOb4?=
 =?us-ascii?Q?dWPyVhoJ1AiiZfYVKGLh3W+yJ6QqpaHjqV6rp57mdd0fTOTgRf3txkdB5ujE?=
 =?us-ascii?Q?tats8v8n4cExFn24ipYvLrMdX1LsAF5LsCzPBTKBnSqMJqo367CrvoC9E41B?=
 =?us-ascii?Q?BExnsxb2fcbS0poANqvD1b9AE8Pjy5GtgRvZafpU3BNynJt1aS/ivvQPtKAb?=
 =?us-ascii?Q?J218ru6HzTV5W/RJaa/1whVSjI8WAJhmPck9b4XXwL9zUgT0tqflbb38ZyVA?=
 =?us-ascii?Q?MbF/sVZGvqDOB1DJEwOjA5/Bttvp4baIKDtTRvjVf7YFNNr/yVXA8xq5DH/S?=
 =?us-ascii?Q?0JwruW9D9gkMF7t13Um5aXKzEET4c0ImiSqVnk/wmfsCy6ud9dQfuVScyU5b?=
 =?us-ascii?Q?w/jb6pXi0tyrMOkHyRrku+pu8RSIY+5xJosY71gUApF8g1HNoAn7ZA94yFYK?=
 =?us-ascii?Q?Px5jRBYrtAg15NtZUc4YwKPncX3WA7Xz+QYf3lMZYPS4vxE/cPS3XU7HOvPs?=
 =?us-ascii?Q?jQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zmCDiRK2Hf2q0gMlkfKNYb++UhY/rsNoR7BLp/1qwWY5cuvTqj8KG0P4CRmFnwlVOGANf2HQHrGYJA4HiE7IIVNCKo9wjm6rDUP6WB1+YeROC1bMuwFaGQEqDfaYucswEuLl/r6kuP4ARL5FdK2ZRPXnjT8ybUBHOa8ccyhDgISaKuFPErKfMofzReXPHSf7MRgptLz3KkZL7kMbfUFiZmQHmk1jAXTI1/Co7idmsGK3b9zjK1EvxOhzW+Rf4gT6bFvHY+EOL3q3JC2TUP/X6lpcccbKcLPMAEecsAxxSptGdlA1YBAGDYdpwVThYxGbISC1wv8ELHYLo1uOOHYo563pXXZo0FMFsQhXGqnlSj55a0bgK0wVIptJ5Y4JdNdszJp6h9+7K8sCHny2jYqgzvndQMWzodfVbgmlE2SmXGZYFvNG7CWvSxwD1jlg+Me9VvUDd8viMS+yyK4BNxBT4kQmf2JJIk+ka2I7CA+Eg94qbps2C9llT9viZ84GzKWWt2/RM4pVb4YNOpfolsbLw5UeVtDuo3WLpVklYFVN3nH7gvNgCn0Lcp0S2gGByMHKAMILDvPFqF1RR/I0IHM6H8aFtHKaD7XNGX7ZCemYxTQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8af1f068-710a-4c53-c08f-08ddc9362fab
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 15:41:12.2321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G3vzG1VKlvj7vPwmAWn6jxsoVRF/1H6u0cPUA65LwftrPQkMTljuTOa55iDar2Xiy3ce4TVp4EngP5UCT+v4GNttFSM111HXSC77+IoR9FU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF545856187
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-22_02,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507220131
X-Proofpoint-GUID: Gva0NN8FP5wbjMdAR0mHh_vlSAMkYf2M
X-Proofpoint-ORIG-GUID: Gva0NN8FP5wbjMdAR0mHh_vlSAMkYf2M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDEzMCBTYWx0ZWRfX+uiCSsVDONxg
 ZssHWdRyMILbdciMdmvEx/1u+bo4ZDJGvh5OfefOiv5S4GPi8zrVlrles+/PziVHCIm4x/J8mU7
 kXBiy1QTVgOzFiHKMT6QlYjasKImaY4RLbDVyG6H6syvIBPJeqy1PYmbPl7BRC0DFLZBhLnLHS/
 FcerjJhL03Q+Q3iJW4CClj14W2rdehHuP8M40NTH+lfjzv1qYUOaahzBxcgN7i1ru7/07YwOu7E
 DMnAh+CVzPg6jk8kco35m+setm0vKT2OF43RyMUIl8WUas0OVdNCgq1kJC7V3gLiYGRuMgVNBu5
 H9CBH0A8jwqlltui8RFo2+pnVv0qKSGnhS306Ki5WOBnt1kQUi2JjQZNrWRiMFtOBQv1tobz4dn
 LcimmKA2hAXcTKjpClthtKWIrud1voo3zLsOmweCI84VvSXz0v1mPkJ75/aOBrEA3a4AsT/0
X-Authority-Analysis: v=2.4 cv=IPoCChvG c=1 sm=1 tr=0 ts=687fb11e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=edf1wS77AAAA:8 a=3g80flMcAAAA:8 a=oHvirCaBAAAA:8 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=hSkVLCK3AAAA:8 a=4RBUngkUAAAA:8 a=cmfNEbHjUje_eIfDV0gA:9
 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19 a=CjuIK1q_8ugA:10 a=slFVYn995OdndYK6izCD:22
 a=DcSpbTIhAlouE1Uv7lRv:22 a=3urWGuTZa-U-TZ_dHwj2:22 a=cQPPKAXgyycSBL8etih5:22
 a=_sbA2Q-Kp09kWB8D3iXc:22
X-Rspam-User: 
X-Rspamd-Queue-Id: C40EC40007
X-Rspamd-Server: rspam06
X-Stat-Signature: b34k9h3bffe1u8c7apnewxqe3zkknszf
X-HE-Tag: 1753198884-778735
X-HE-Meta: U2FsdGVkX18u5OuNJ7xwczoEoUDfZELkscSnltNiO6OoWD7Dc9N60euAQ6IxJkouENKE6tFoKDwoKS/+QUKynv8x1XJlynwFzuPEvB1tSA1tAs4BtQUOPtwH1GyFz2733RwoUFM18C2IApKUfK/gpIKfUTtJAPyoX4OFuGac8xrAEJY33DDBNMWidlX0g2J5ew7MtD00MFTSVSTyB9KQy/kQApGkMotK1IRiPj0t4mg1XBwI70Nk25hYtr44IIE1ttaebExAdG2tQP5J/bXJQawX7gEeEIALu1SCph2SVVNutDQ5rAsIdvzvP22miJyVsKeoevZQIBi5vfXcMoe/r33fquMhwDwzPIM3/HDkcD7nO9yEr219NWECj39N1tvHK8HYUk6v1nLeB1Ta0YS9yAmfCeawyHBRpxCPmaDxfoWJMHR/qv1mbR89BPU19or0acVeoFprZS7qiNLlITndxVtd+emctmb3faBL2Vy4eH4Knor+p6g60TvOoGKMdC/wrI9e8fjva4EHtRKjXWrl89gbBDepwkmWziH20lADFBdXa5KFuRbOLyoYqwUHAmgQRkV8pReNr25GbvwA8V6rhV86RuVn2/8o2RYWdz5JpnIwrEv+wzGk2ZY/Ls2sCX1gFl+/kR0QRZ/yGoCcprf4nU/6OwbvG1qRRwPC+HaZ6/jF+Zf4NKcrFCNlGChehTl5iF2Uh9fT6Dajcn0eIIB1257bWwNasKcMdSuOIriKxc2jxQr+BbkXpCOPhovnn2ISccoPRr56piy0kYSty7Y8dU5pA7ZJZgu/re2grryIxyPuIsJpkIbxbp7CnJ1shMpgavTi3mViuWARInxisZzmTFQ/+XTpOzl94MSfxOaaspldBGXG/nPGkSVn0ZvvuEBWTchjdmUPDvnnOfhpDFJ2hGOvX1qWki2SWavrmk8N6vaKPZUmK++pE2t66OUTxTVlbfImWInYHexsnLAnzoc
 AUSn3B+L
 aERCdacc7itucUnxrnpPTNdn5HVnJ/G59alAOLuae1S8j88oEBUis+soSy4rA9F8ZopUdnNMbIhITL4oyp49tpJSZAm7sot5/FLUVU2HtunEaIX1XdqCkiKwFYeW0VjEX6nu8d1ZVNqtkz7/YdJ6k8OwdFzD4Qf7r96TjKGZNUOJBdo5jCi94eJcXkPxDlNtzvyZ7d/uiughxWeFqxj8+ZcJLfcmaGRQR4v9TnJsSyTukLFY2kfVciGtrAjMFGv6LNGwaRBt9tVN+HIuPOvRlOxtrfM9p++Nfx/bZFOosVVyKWFCF9fwyYnqBfDOXrSVKW7ZF99m1SdZfPII/CiB0HU/EdCI0mSk64ZOGtg5DsE1aoDbW2AgulQjtPMK/PwKeBH2naDDaduzuQv5MWB3aZRugUnLw5gEV+0EgqZw/M0iJJnfycdCxFzRnK4dvIrGrLecqAt8JhnGXkdRjf/8cmzVh+QnCJ5fG2+WBWBt/0q5AyQC1iCH8XhxMxw2t1WyPO6nAt2bU6gi81ue/FnrAExV7m/60pH0qtFV1/rXlY+J3VZmU9K7+fa4dtWvnj82aj2AHYPdEBGlU+T6PjAKiySwsKFkyDO0VVFtCrCGqdsHOSqcIT8sJk3eW4D0N0pzUOpUBKqn+JvOkYElFdLdbzTzoVKX3tlcmuDTlVySnU1CDjb6WCVgmaYzGHXDKpgSQdOipQSbFtk1vOFu/mFmvSct75JMImIFj2eC/rFj6H1yBlla916EHwzwDlPy5Zb8wg15gD6ToFtxfYfiJ1rUbnYoSKtZ9BPNb0xzx0Mv2+LGQBuRkMpnjEquEHVin6S7L8hVThnnDYsS6vv4Pmg/RXkb1JR22UONFQEqbgbhM/B8K2AdT4mzVmfTkpmSPlktLOL5phLbc7/rakgpe/2M2wgqOSz05WJGNulP7MZMAXvfmwYYQqW1x2v1vEk887IbmKp2kqvmvvWaFbPLvlG+coiWnElIQ
 SOL1Ht0L
 uulAv7Mmx+q8ZltUmagogZcForKdd5gu6j/RFtly5gXWe34LfA6RrYFwZlw9fm95PzeEwWnlR8JwuKN50Qhy7Dt1vbI/ezlXdx7hEbCP1q2Ui9UbKe9monnmAmlTiXLEY28HiD0WFqEuMKYf5BNaZpsqwkBLrwJsx4XnaI2NzTogYGpbY7JGHDuzr9B0RBl7rcyjD2dJwFU6WXg4U6dCPhbcLYZT+TP5ONzmdorelpjDMxqcER39x8CYW5aUVpb9XISg966ortfiVmJhQ0JDMKcU5wsxaAE31iTfx+YMED4XdU92Uox+00SfLoJ9wql4X5Gimb4Z3q1wMEg1XQ3ecajZ+7qedcp3oT7DW2un9hwElPAR/L/DOaqrE54AOqsDe/K47b+c3xAS3Qe46xlc0Y+Kx2BvM3Vjo/NjRhZc5hwLxQ3/Vv/jKffdXRfTPX4pSePjlf1fLvkxo2JC5m2aLhIVV91m0FJ9K60XsGXjMEbqRqdo/LPGvIrqXl0nVsUUUJhfXTV5p+xnungljIRmv81RfilPmRUdysZZGdhv+W1bMO7M46BWyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is testing against an old version of the code.

This version had a major issue with incorrect usage of the VMA iterator which is
now resolved, so it's highly likely this is resolved.

I can't reproduce this locally even on the specific linux-next version, or with
a RCU barrier inserted to make it more likely to hit... So let's see if syzbot
can manage it:

#syz test:  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable

Cheers, Lorenzo

On Tue, Jul 22, 2025 at 08:17:30AM -0700, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    d086c886ceb9 Add linux-next specific files for 20250718
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=15c4c4f0580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cc0cd9fdf69889c3
> dashboard link: https://syzkaller.appspot.com/bug?extid=1c6607097b258f18065c
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14f1e38c580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13c4c4f0580000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/4435f80a19c4/disk-d086c886.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/9a7dc57a5ea3/vmlinux-d086c886.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/da9f2dc22ae1/bzImage-d086c886.xz
>
> The issue was bisected to:
>
> commit d22f1d61e7d950dccee81e3ed75ff2908aecd1a9
> Author: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Date:   Wed Jul 16 19:29:54 2025 +0000
>
>     mm/mremap: reset VMI on unmap
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10e42f22580000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=12e42f22580000
> console output: https://syzkaller.appspot.com/x/log.txt?x=14e42f22580000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+1c6607097b258f18065c@syzkaller.appspotmail.com
> Fixes: d22f1d61e7d9 ("mm/mremap: reset VMI on unmap")
>
> INFO: task syz-executor942:5848 blocked for more than 143 seconds.
>       Not tainted 6.16.0-rc6-next-20250718-syzkaller #0
>       Blocked by coredump.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor942 state:D stack:25848 pid:5848  tgid:5848  ppid:5846   task_flags:0x40004c flags:0x00004002
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5351 [inline]
>  __schedule+0x1737/0x4d30 kernel/sched/core.c:6954
>  __schedule_loop kernel/sched/core.c:7036 [inline]
>  schedule+0x165/0x360 kernel/sched/core.c:7051
>  schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7108
>  rwsem_down_read_slowpath+0x5fd/0x8f0 kernel/locking/rwsem.c:1088
>  __down_read_common kernel/locking/rwsem.c:1263 [inline]
>  __down_read kernel/locking/rwsem.c:1276 [inline]
>  down_read+0x98/0x2e0 kernel/locking/rwsem.c:1541
>  mmap_read_lock include/linux/mmap_lock.h:412 [inline]
>  exit_mm+0xcc/0x2c0 kernel/exit.c:557
>  do_exit+0x648/0x2300 kernel/exit.c:947
>  do_group_exit+0x21c/0x2d0 kernel/exit.c:1100
>  __do_sys_exit_group kernel/exit.c:1111 [inline]
>  __se_sys_exit_group kernel/exit.c:1109 [inline]
>  __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1109
>  x64_sys_call+0x21f7/0x2200 arch/x86/include/generated/asm/syscalls_64.h:232
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f70d2bb1349
> RSP: 002b:00007ffd9c81a718 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f70d2bb1349
> RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
> RBP: 00007f70d2c3d2b0 R08: ffffffffffffffb0 R09: 7fffffffffffffff
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f70d2c3d2b0
> R13: 0000000000000000 R14: 00007f70d2c3de40 R15: 00007f70d2b7f160
>  </TASK>
>
> Showing all locks held in the system:
> 1 lock held by khungtaskd/31:
>  #0: ffffffff8e13d8a0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
>  #0: ffffffff8e13d8a0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
>  #0: ffffffff8e13d8a0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6770
> 2 locks held by getty/5605:
>  #0: ffff888033a1b0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
>  #1: ffffc9000332b2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x43e/0x1400 drivers/tty/n_tty.c:2222
> 1 lock held by syz-executor942/5848:
>  #0: ffff88807fbd57e0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock include/linux/mmap_lock.h:412 [inline]
>  #0: ffff88807fbd57e0 (&mm->mmap_lock){++++}-{4:4}, at: exit_mm+0xcc/0x2c0 kernel/exit.c:557
> 1 lock held by syz-executor942/5849:
>
> =============================================
>
> NMI backtrace for cpu 0
> CPU: 0 UID: 0 PID: 31 Comm: khungtaskd Not tainted 6.16.0-rc6-next-20250718-syzkaller #0 PREEMPT(full)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
>  nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
>  trigger_all_cpu_backtrace include/linux/nmi.h:160 [inline]
>  check_hung_uninterruptible_tasks kernel/hung_task.c:328 [inline]
>  watchdog+0xf93/0xfe0 kernel/hung_task.c:491
>  kthread+0x70e/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> Sending NMI from CPU 0 to CPUs 1:
> NMI backtrace for cpu 1
> CPU: 1 UID: 0 PID: 5849 Comm: syz-executor942 Not tainted 6.16.0-rc6-next-20250718-syzkaller #0 PREEMPT(full)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
> RIP: 0010:mas_next_slot+0x7b4/0xcf0 lib/maple_tree.c:4718
> Code: 08 4c 89 f7 e8 7d 0c b3 f6 49 89 1e 48 8b 44 24 48 42 0f b6 04 20 84 c0 0f 85 f8 03 00 00 48 8b 44 24 10 44 0f b6 38 41 fe c7 <44> 88 38 48 8b 44 24 68 42 0f b6 04 20 84 c0 0f 85 f6 03 00 00 48
> RSP: 0018:ffffc9000413f320 EFLAGS: 00000206
> RAX: ffffc9000413f4fd RBX: 00001fff829eb000 RCX: ffff88807d0fbc00
> RDX: 0000000000000000 RSI: ffffffffffffffff RDI: 00001fff829eafff
> RBP: 0000000000000001 R08: ffff88807d0fbc00 R09: 0000000000000004
> R10: 0000000000000003 R11: 0000000000000000 R12: dffffc0000000000
> R13: ffff888076c6d200 R14: ffffc9000413f4c8 R15: 0000000000000005
> FS:  00007f70d2b6c6c0(0000) GS:ffff888125ce3000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005634ac61d168 CR3: 0000000076c8c000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  mas_find+0xb0e/0xd30 lib/maple_tree.c:6062
>  vma_next include/linux/mm.h:864 [inline]
>  validate_mm+0xe1/0x4b0 mm/vma.c:652
>  vma_link+0x366/0x450 mm/vma.c:1799
>  copy_vma+0x70c/0x940 mm/vma.c:1880
>  copy_vma_and_data mm/mremap.c:1184 [inline]
>  move_vma+0x81f/0x1840 mm/mremap.c:1282
>  mremap_to+0x6d6/0x7a0 mm/mremap.c:1406
>  remap_move mm/mremap.c:1863 [inline]
>  do_mremap mm/mremap.c:1906 [inline]
>  __do_sys_mremap mm/mremap.c:1970 [inline]
>  __se_sys_mremap+0xa0b/0xef0 mm/mremap.c:1938
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f70d2bb32e9
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 51 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f70d2b6c228 EFLAGS: 00000246 ORIG_RAX: 0000000000000019
> RAX: ffffffffffffffda RBX: 00007f70d2c3d308 RCX: 00007f70d2bb32e9
> RDX: 0000000000001000 RSI: 0000000000001000 RDI: 0000200000000000
> RBP: 00007f70d2c3d300 R08: 0000200000481000 R09: 00007f70d2b6c6c0
> R10: 0000000000000007 R11: 0000000000000246 R12: 00007f70d2c3d30c
> R13: 0000200000000000 R14: 0000200000a96000 R15: 00007ffd9c81a698
>  </TASK>
> INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.092 msecs
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup

