Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C397CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 20:08:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 651418E0002; Thu, 11 Sep 2025 16:08:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6016E8E0001; Thu, 11 Sep 2025 16:08:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2028E0002; Thu, 11 Sep 2025 16:08:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 382A28E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:08:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD7DABA2C9
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 20:08:51 +0000 (UTC)
X-FDA: 83878057662.17.74837E1
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 475CF18000D
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 20:08:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=evpE6urg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W+fKQYAj;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757621328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dlN5ZJnWv1zHJkXfnRHQHuf3UYODuLsD9mE3JMxYE44=;
	b=G7i2I6acyelu4kh7JdUMXA+6vOHNk/vUg1s2HLpQP7D/Fm79dQSBVTxsxOiXv+8brwcwj3
	YB5bn7EQem9VkfniJRT47L4UxhqjnwfayNkZB5uwvI1Xu8E7UmNpJKhuxb01BkQTV8T4LW
	A4vCLDdHiQRsTlG8uzL6R+tYbEm5tus=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=evpE6urg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W+fKQYAj;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757621328; a=rsa-sha256;
	cv=pass;
	b=RLuGt5Yq+4yFkwcUWcflnmD9yVjT16ONkSTsxAqDtDR7tQDru/yYy0C8km4dXOvir1r65v
	N05wbwtlZONEb4khVPmnhi8hUyTD6M7WQP+qWcQJTbm0rme4aXjvi6V/cuWfYDd2coGEHW
	xvKSvsT4mtWYt4ZDOakuQJde3Oq2TUw=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58BHBhAl020414;
	Thu, 11 Sep 2025 20:08:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dlN5ZJnWv1zHJkXfnR
	HQHuf3UYODuLsD9mE3JMxYE44=; b=evpE6urg0OKDnOvXDBTQLTM72IaPavq907
	OpymSTDDPpIgM0qmhlZVBRyltqKIqlheDxtdxO1h0b0H7mTSBH/ljrpcLrqnLVUr
	tyO+6JAtKUVx9Yvr9EHzH9EUuMDPFliMhDi+7lH69dfgiMch8lDC+57NgHPeBk25
	WBjZn0FuwiMLQus/rRKjbkvuAuhU1vfjTf4082qJ2e/LcLnH67X/QaUuGbS3rw+9
	zqoRG9WjDp92dg02xD1YnOoXIqVxKyxyxbgtmKtq0IBRRgUSXSkz+eBe3Gn3mGlr
	kINFUKT9PJLcKAjNJcvooCRttsgIWRQY8mwn/e8IRIhwe+q4sc/g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49229672u6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 20:08:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58BJUupC002760;
	Thu, 11 Sep 2025 20:08:40 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010026.outbound.protection.outlook.com [52.101.85.26])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdkfjyg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 20:08:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lGr76eptj3BTkhcbG2b3OKvowwuLKZMeW/RfRVdEZTEyWElFdNj6fKVAUJCHon1cpKzvw6enk+LaLClHScJjLqK7+8SFUVfBRi6PGBgVMxuJC71BiB9r/Cxj7ZaComnCoxnYHaMxClju4HFaymsVIdoneIDIQNEfjD+35IKanyc6L8QOBEBhN5siUVxSurkbTDJiqYgfdFePuKG6uqZDhpyEL396xoluRn9U/PEw99UKk+PZSPxkzjo5Pr0Wy/wGu3fK5dhkVzGg0AW6v/LPVvSBnkQMTNsXSvqa+dhJ/sz8xETAj3TmvZhNMXVMxlNMuoYLvDtuCCztxlzngD+ihQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dlN5ZJnWv1zHJkXfnRHQHuf3UYODuLsD9mE3JMxYE44=;
 b=Da6IfMBEqldorQYr9bqm8YsXlEVbWKgOdnjLGPKLfW2SxVMmBN7HKfvYlNLV1yrvWP12fOZNP5CgT+BBM4hKwk2Pya+5DHbBU4OYIxiHj1VKdtKh8L+cdagqd9oKQs0uRFi/TKrvx1V1bVacNjDekw9wmp8ma9QySG1uM9VIemLVhCEpvF33GFf2f/FdzvjzLBbTD5x22/U8dyimwxeXYUz3u+C9bDtNLI6qELB9iLnRpOpmcJNA+opjJu7BuGQJIvNrzg2ZFsDBWTPakz/h9PBSFO1GrULXE+MtRN+QllDYKpVzesePU0Tj9nJ3YM+sL6e2ZFepxT6ox8XO0es9HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dlN5ZJnWv1zHJkXfnRHQHuf3UYODuLsD9mE3JMxYE44=;
 b=W+fKQYAjbdieQCA97NK4L0Ic4FW0m1udRdL1KLdlrEAmA2pI1kishd7b/UD7ZEGT3408tjPs0T00Pe2C+ik4y6dExjJQrPHLzkMuxPRslxa5EUTa5ZUT/1DiZBs/9XmiOj+Sl5YTQEryX2oGOkKCYKyIpOJ8JWhLcFdrNcm1Zs0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB7463.namprd10.prod.outlook.com (2603:10b6:610:181::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 20:08:00 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 20:08:00 +0000
Date: Thu, 11 Sep 2025 21:07:57 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com,
        ngeoffray@google.com, David Hildenbrand <david@redhat.com>,
        Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
        Barry Song <baohua@kernel.org>
Subject: Re: [RFC PATCH 2/2] userfaultfd: remove anon-vma lock for moving
 folios in MOVE ioctl
Message-ID: <4fd821ec-74e1-464a-8e94-d6f0e4b0e7ce@lucifer.local>
References: <20250908044950.311548-1-lokeshgidra@google.com>
 <20250908044950.311548-2-lokeshgidra@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908044950.311548-2-lokeshgidra@google.com>
X-ClientProxiedBy: LO4P265CA0268.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37a::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB7463:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b40c7ed-55d5-4c70-014f-08ddf16ee84d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?70pJzkkOqB8qNAN005npVf2tDMveyFmhZVrkZofZIRYNgBisMCLS/tHTqLxg?=
 =?us-ascii?Q?zHxP9+LxUpL0LlsoNr5UQhtnhWGDe/WtikA/GpGVOE/y1h+pO+esID458Jt/?=
 =?us-ascii?Q?7OycmIUn1O4zhZi9vh9/JuBLobdhpRIKZidh7Z/NTDMGbxGdHwO9jVdgClfA?=
 =?us-ascii?Q?QIha/xMv+X3XWohwrIogrBLw9qEivl/SaGsnFkRqdIUjkZqdZzQhb4ISE0h8?=
 =?us-ascii?Q?26NifoVkUydpwCOatpKnC+uQ49t5wNxBU5wadlX2o88ISWlws55YYbhxdtCO?=
 =?us-ascii?Q?BUtpYWjybA4n66Yj7cWu5qpYOeD1ROvRIVfOUhkhWWdrXoUDCFRIrOjf9EW2?=
 =?us-ascii?Q?ycD8ufO7iBxNwh3DJuMvuUVXibeueelhCpJvRkdHi+Jgb0YF1x7CLTadj2T0?=
 =?us-ascii?Q?TTa+plUcCyGZGg1twtmZp1D+iDWpLLF5TcR6Yepalirdal+USxF3YXsVku1i?=
 =?us-ascii?Q?oKm37gRF/BngHQWqF0Vq42YXdo7fM3swHBDaxQapBm+GEJKQGdIuoGwuZo48?=
 =?us-ascii?Q?d8oNl2IwLXCL4SGIgY/Ofd6joBhb99dmWBoyfscvfUx+0vpHcVm5rzEZCk4i?=
 =?us-ascii?Q?kYF3sFeEe6ME85BGADVTgituaGlxo1dAem0xLifTyJtpMfKwSAxwvIbiKTNa?=
 =?us-ascii?Q?x6NRC64XLDoIY9sIfyhecQVs1oAgot/yMhCtK2QmNITtzvvJFY/B33Lc0Rd9?=
 =?us-ascii?Q?ljB6UlxTvPHaQWLmxvKds4d4SMZd5NiYEXFvqF8Hzh/s14suRK+TBGs5nirM?=
 =?us-ascii?Q?1CB5shMp61rc9s5eWH/UKW6l95dUO7rcKd9ZhSY9Oq5hNhu1bntBC7hhrj8J?=
 =?us-ascii?Q?voiOHPXUZJrImzQGYGcO/ryO9zUD0v08xpTcyWCBNjbt00frY6c4ZYDs8ZRG?=
 =?us-ascii?Q?YKqdvnc07ZCxW4Te9PuKS0Xle5qxiYm1Zbx732TWZZis8m54bxYVz4jvmrH6?=
 =?us-ascii?Q?sXXQtTJbYQdewgDd0CHk4tbwdT/SaJc9KTAw3pnQ1mdytVP8QcQyG5JWk9Wf?=
 =?us-ascii?Q?MjhvZgC807t33YUaJ1YTRAlNCWnV0aTq3TpX/o/SpYiPZWb6ypQGaqhvXE3Z?=
 =?us-ascii?Q?9I96lL5/s/fmfxxYaY7ZKMoW7sVtYhfRGayd0i4oO2liERMmBZcEi4uvb2C2?=
 =?us-ascii?Q?KN30G5c2u31JNpjEoUMjsIzx0LT+QKjSf2UbgXXwx0FV6rOJHEeWMQQr2+Gy?=
 =?us-ascii?Q?8l473lOmbhAHh+v8EK87fKw+EZeCnAFXRfk4d06ujHoNDW7Iw7bti9ioxSEe?=
 =?us-ascii?Q?XabSoNXdjz0hqP2r4D2m7w9LA8ycU9Gxte6xXylN8PMqIls04k+8jW/V+TLt?=
 =?us-ascii?Q?XLUcAMhx0FE2ss7WkrZcjr2kc04xggMYJkQKaX7ZRnlZWTFiLvRN2cfy2blq?=
 =?us-ascii?Q?/7nNlQiT/vxhcMcZi6HgTmZRLgv8yZdcNRghrMNRGJAeWTcuGxm1govDAlBz?=
 =?us-ascii?Q?NTElKA8zX5U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?J5CAjdsz3N0hR0W8U/911EEx4BlGO1q0vuHze2EFcDhvhzyHat2WUgSUEmQt?=
 =?us-ascii?Q?6N6ZclBX5UwpMf23mvdJXCNMHqIY44VhCwM6WVmEfe2nmy+G935hO9okBwS0?=
 =?us-ascii?Q?aXw7f2bnyyKFS+huefNBwQrE+n02Zl17B+NrdpTMB1XV6gvbjr8LzS8ZNIcH?=
 =?us-ascii?Q?HzUv+eGehx2bYYl6VxW0WqlK96dlygUh0Tx0HvKmnFQsT7cHbfFjI1RXAxjP?=
 =?us-ascii?Q?2WLLkLIZPaZuRcpGNuz/TcSzIiXBKyb8qNYM5SIsOOZW3X5VFzHdlnQCtjTA?=
 =?us-ascii?Q?swLRRTdDYBqFlCPHCYWf9JqWZUGphnCfOrQBiO4ADsYRRMdS6Po5wWOuq1yN?=
 =?us-ascii?Q?hUVHZGMD+k+rnuLPv1nc2dluDM1D7cTZzEz9EJBB0WN/6qejz7CSbqarf7j8?=
 =?us-ascii?Q?iumzIiVc1Nl2pplwN/m23vTLS+wQxzw+MBFw4fSwch2ajBmHjB9iSvib/6rS?=
 =?us-ascii?Q?5jlepoKizDckRswHqfH0gZTiG5Pqvb1mMFH5QubXKnyLfqgSBYJityC5STgE?=
 =?us-ascii?Q?Q5RCwROcjXvFLjBe7NxgxpLASLCv4d6ZCaagkjAiiiyu7QJe507i0ZXgFmNx?=
 =?us-ascii?Q?rsaiMZTg3WQxrsaSkJf0p0flSeXp+oCSYGaDQ4WbrYtfgA9xSXZQ7gssn0Bx?=
 =?us-ascii?Q?QHSDyi0CTjrye3q38JoXLECAgo/XH+Pq2g4144NS42CchuNp/TMopktDPS74?=
 =?us-ascii?Q?lwROGVNn7Np30tdzt0TiftvGDL9HLqdqHINqvQ2d1F2uv1vsho8pbGHMoFqy?=
 =?us-ascii?Q?ZK4r01YmJ6JxAG3FGayNXeZCUElkxyjG181g5WCtlf4RB6T72XDv/iEoAyBt?=
 =?us-ascii?Q?+ph3JoeFoVmTkYMLHTTgjFR3ep0fXUY/yr98+X1DGOMv+QJvWIP9fsuNd+Pw?=
 =?us-ascii?Q?GlHwlFMkqsPQ3ddGfq9ynjK/Kag6g8JjRfE7UJ2f3W3bXLAdgb/haxMcVkfh?=
 =?us-ascii?Q?cqLzmG/xpIZMB+0aFHp59R794EZerWVGGSYypux8UBsVLc0abUrXaETFvlZ3?=
 =?us-ascii?Q?IezSpA8S0idzDDsvsGjzrNJ2c7YXzpcQKFJfEC0zLxgU+WvjaVf79DR7S0DN?=
 =?us-ascii?Q?8l2yFinG3Tf8bNVwqsn8e5JIciJ5emnq4wC4O5Yg+nGJdwz/HrGltcTLL1oY?=
 =?us-ascii?Q?5uNcK8GJZvg8IWZZ4h8WqewKSqcEhCDoRkGAd1n+GNMffQ0zHJ4elIe9648v?=
 =?us-ascii?Q?OySKSGZZ9hKpxHNMGHYUpnZfVpDSsmOtyoUMeLajUSZPthBcbbYVC2qIo5Qg?=
 =?us-ascii?Q?Te+C0xvD966MOfEaAUVUdV4kgjSqhofdOqgj9grYH9/dMyAMmuGF44f27uuz?=
 =?us-ascii?Q?0cwUSZFRidpghO77mAxIBWiBD/swfKvFee9ftED7yl7rL1DnJBHz2QAKY2zT?=
 =?us-ascii?Q?QRrd9mXeu/fKzIgZ1hTIZFZOhLh18CcWOXSy+NwLOwjTLIZl6BWcD/nV4LW6?=
 =?us-ascii?Q?fqrQBZKT83y819EEo6xGRYj65l6F/IlEbgZTK3bv1VT8+HuxWMxeHEhuz7lN?=
 =?us-ascii?Q?EzmFhZjpXuNyXi5LOzprEbnbgEVbwz6hbqM6lbG/FhFT29fs2pormm4Te1rn?=
 =?us-ascii?Q?OluqWBi9VRpH4dDzYUA3PPAtZEidjMHpJuTKVlo+ZSChyvrlc7fR5ZPhUBCE?=
 =?us-ascii?Q?og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qEvmngqdOrOf9Pt+ZskYLKC9C9qHCwC501BJsQPhu6oHfBB1WR2Dvxq/MJpAyZwkyX7hdSXRoKBzSDxg2E/prvM0AyR6HxxPJ/BBq9BKUFk8eZv9vZnYBH5JkZPiUkoJ1wLVq6Vp3qzziGb+/9hjpkQ0lUMBbfEK8Ub36hjk1WvaSbXbZN4uMBXQjZtoTxJRTNVT+JcSTBw2hGPUeRc/XTSkeFXiK3Jm5cywYMwcXCJ2fDVC2jgvwJ6ONCWihppnXDVE8Svr4XHDiT8nSRf3qG26rYpg8cTTpPaZMkqGb13ezVxMbhw6siI2SZmyXcKWqYSIZkLOduAJ9ymSgqZit01GKCIIsGiug4A+XownJUcYzTp0wBgHmemfNiA9+01kE0J4N/pXni65rNOWGqwk0weMVXUeiP1exucOd9jAqkIKz2MGJoBuuK5Z2T57QviLc+zt7UptliC/eit8SJ+1SQoAOKNewfIA6+bUaAK58l+HmPEyRDIxUbpAGEuPweBevetd9wEO4nv/z821o0gpxyzSJNimlbNA1DJ3stYslw7mUnWrUkDmWcB+lLFHgJOVb583jd4laNBPS/j4fr9mzWIv2rDtrS6+1r6oqjQ3hQc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b40c7ed-55d5-4c70-014f-08ddf16ee84d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 20:08:00.3361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s5dKMiQfSTFHF+M6SiF60V78IXlA38Szx0uZzfP9Qtnef1Z7HUrWVbgF1L1O5AngPNAY0pDBiaRrqBRWNjl2Nkc5n3ZMQ8oX2Z+M8SNXjjE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7463
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-11_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509110181
X-Proofpoint-GUID: goPg_Ct09-Fkk3dOlwQ5G4gn7bCJ8-OI
X-Authority-Analysis: v=2.4 cv=CPEqXQrD c=1 sm=1 tr=0 ts=68c32c49 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=GZJ7jDfV-9NVMiDk1o4A:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12084
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1OSBTYWx0ZWRfX5xMt2BEDUU7n
 r+SgwfmSD6LQuPVoetbxRuHbe1/HLEkftUJEuvJaZzNQ5///+CeJd0ZoZDqcx2LygGbCrhOEAIH
 GwQDFnk3x07k3drWMQD5pjLIClHPqqWXPTNrjyyU1G3Cnp52g66PI+vUDgZv5YvUBiRsglC3jnc
 jECoJt3RY48fk/G42bV0JEMBAki+2/VXd6URJSzihX2CduAGpO2DONP6HCFRmhous8Bi4rnEcVs
 A1xDHmZdKZC3mDwQwuImeex29jwwv/5elWNr7ZIRpeb+NlHv8KGiJGqc/AfNmPKE1kIZopSy0kX
 H1MqME+rmNxI6+k8hb3ELfTcjeYAyQySW0o80AGshTp5lpgVIGIvJ1Z4MlNEAB6Jc9xFLssc1Nd
 j8pIjfkOm7m5oSTqlJpq8dZVwCmIcA==
X-Proofpoint-ORIG-GUID: goPg_Ct09-Fkk3dOlwQ5G4gn7bCJ8-OI
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 475CF18000D
X-Stat-Signature: dfembm17hpcyyzsd6cfgf9xkuq98j5cj
X-HE-Tag: 1757621328-878677
X-HE-Meta: U2FsdGVkX1+LF5LJknxoYswbQdnFxiVgM0JRyqei4QRqEe3O/uaNrvTBS2/EnJDUvn12ITPgSZqfHqI6ZrlwYyKsxFKtO4V2FEggRNJHNxLiCPLpQ1hJXlgYGhKpbd05YZxJyaHckVCeuD0OR0dsOFGE5FV5OTLGnrEs4kk+11AEGWFT7A7EwVtsumgaJGwuDTFSQ2V64kfzL/yWAFlukJH+QrnOeQSh4VSJ+tKl7wS/dsNs7V20ffmVZVmKEvhODO1IIO/YozxdiOoBI9lpNlRerK5AtLH4X1zbQClFW95fFWkfd5ZEUS2AGcWDFV8+qM7HfTNUxjx+6DC5DR7o+UH9xaYAKl0BzdyRQ30EGq0YBJAUS3N0Vo2W0jI0STuSOj9I/8Tm9fwY3s7SYuGEFvlv2cFr+d1oaW/WxuEHp5MoLxrrbpQMyfDF+i3wTGsG5GslT8wVeeYcjw1CTRsCq5YSz+6zDyh0SDRAMIVsKTMNAz9bk/IxGNNAeTzeHsm+isxET31CrcgunYi3JEOOyNSbJASJxTC3mLVthDmpPwlxenLRWvwDP31FNxonNiYUgZ/9V1d76SJQ3UAwvBzziLBxq36eUKu3geeVMjQRLrO5bGra2GOk2o0T74/mWcSeVYPzyFkdz7iMVnW6oJo3ZrNt4R6hVNyKwFatHDJ/ePdxc2CTgcUl0g0X+1ytAehGkzJB2y1icyt8HZDyaiARx07YCak/86Ag5/Algau0g01rURh5zY1UYNjrASwNKFNFDEBPsGcjRCbwLgL8euQOhppY91ascspOrbbnEsHbJC2KNje9ZRs/6hF4n7twTn6UtxnNhsoUtb5jMQNZAqi1zJpEto4y/oCw8jYE1P29RqRL+kOQB+M837hqY4hldSMOkGkhxN3jpy0m8EoS86bWTbL6DTTjFz67FD82UE45B+WnU8EwsSUZ0SIWuTgagz+kLQkhLBtqjkwAdvyj5DF
 7VxkatCb
 BhA0htPmqBOQHqG9JoBmB3CWn1z43vgw2xN+8N6wmr+ngfPkFDcid3hV6aA07yV8cu3lEMR24vRHWipoWTXfXwg/2YxnSeZvC3rOvW5agVXv6CRm5FIPprhGW8AXJ6+rkpXi67Dv2Iujvu59ljFzfoK6HJOMh0MWGZm4tsD3Y1NpJiN+T6Keo7sNQN2eLL/pAzHxf+7MNrPaQqsbsOIr45mRrasgOR2RYNvQlO5aHMQxO5FSd/DDHbBVz6Uqz7e0pQ1D7z94fvO+/DdxK8ZgU6X89LjU6V9RLnOkBiBbtf8grSn4TT0SspHma0GQkLAO8HJMzN+5MUEb6LR9/AnLI25FCoXwYpIokGp+mTXHQW4U3mUV1h/bnivWwYK3/Zu0JZ5rIGSjYBDylNuP063SZr7WXrAk60iLqEczSU4IGOYFDvT5J7prHntCBsr7L8f+k+BMUKj2D1vL1gv1R3HY6QLXkKgg/q9hv1S6AZ4oy06c+AJqxHm8Il8vqBBb8GPWbiN3GENGQRimIbRqRsiNo9JNRSnF8O/PBIBvbH6tqHaY7uh1RT7aKkQHxaJrIsIAOXm5VZ2YJKfZCHQ0/xXHd1RZf52JSoqW0Gs/aYLUxCZHanoLPPi8NQ62pa7NnjeWiwJ3ID/YxL1eG0YQEF8BC25XQpdgRSSEhYUY/bSPWCJD3EIKpgeVhj99F7oVZAh5n70o9Jmgk9k4Pp/ubbPm9gk6dCiCvBrHTceaDPIf/UdSr3sseBNGy8gUCzBEa9gjOIZUR8aJdQhek77jpIw8zbFfb0zCG0Y11JmbVyT96H4HTRngB50dDbf44R04y305P+DsBM7Tso2wUXumdbOvkF7Q0bA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Subject is weird, it's anon_vma not anon-vma and mm/userfaultfd seems more
appropriate as a prefix.

How about:

userfaultfd: don't lock anon_vma when performing UFFDIO_MOVE


On Sun, Sep 07, 2025 at 09:49:50PM -0700, Lokesh Gidra wrote:
> Since rmap_walk() is now always called on locked anon folios, we don't
> have to serialize on anon_vma lock when updating folio->mapping.

You're again being indirect about when this happens, please EXPLICITLY mention
uffd and UFFDIO_MOVE please.

I mean, this patch ilterailiy has userfautlfd in the prefix of the subject,
there's no need to be indirect here :)

>
> This helps avoid contention on src anon_vma when multiple threads are
> simultaneously moving distinct pages from the same src vma.

It feels like you need to add more here. I don't know what 'src' anon_vma is,
spell it out as the anon_vma belonging to the folio which you intend to move,
and be a little more specific - when multiple threads invoke UFFDIO_MOVE on the
same VMA.

Also here is a _prime_ chance to mention the simplification which is
something you do achieve here (very clearly) as a result of changing the
locking approach.

>
> CC: David Hildenbrand <david@redhat.com>
> CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> CC: Peter Xu <peterx@redhat.com>
> CC: Suren Baghdasaryan <surenb@google.com>
> CC: Barry Song <baohua@kernel.org>
> Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>

This generally LGTM, but let's revisit on respin w/commit msg update.

I do like the simplification here :)

Cheers, Lorenzo

> ---
>  mm/huge_memory.c | 22 +----------------
>  mm/userfaultfd.c | 62 +++++++++---------------------------------------
>  2 files changed, 12 insertions(+), 72 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 26cedfcd7418..5cd3957f92d4 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2533,7 +2533,6 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>  	pmd_t _dst_pmd, src_pmdval;
>  	struct page *src_page;
>  	struct folio *src_folio;
> -	struct anon_vma *src_anon_vma;
>  	spinlock_t *src_ptl, *dst_ptl;
>  	pgtable_t src_pgtable;
>  	struct mmu_notifier_range range;
> @@ -2582,23 +2581,9 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>  				src_addr + HPAGE_PMD_SIZE);
>  	mmu_notifier_invalidate_range_start(&range);
>
> -	if (src_folio) {
> +	if (src_folio)
>  		folio_lock(src_folio);
>
> -		/*
> -		 * split_huge_page walks the anon_vma chain without the page
> -		 * lock. Serialize against it with the anon_vma lock, the page
> -		 * lock is not enough.
> -		 */
> -		src_anon_vma = folio_get_anon_vma(src_folio);
> -		if (!src_anon_vma) {
> -			err = -EAGAIN;
> -			goto unlock_folio;
> -		}
> -		anon_vma_lock_write(src_anon_vma);
> -	} else
> -		src_anon_vma = NULL;
> -
>  	dst_ptl = pmd_lockptr(mm, dst_pmd);
>  	double_pt_lock(src_ptl, dst_ptl);
>  	if (unlikely(!pmd_same(*src_pmd, src_pmdval) ||
> @@ -2643,11 +2628,6 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>  	pgtable_trans_huge_deposit(mm, dst_pmd, src_pgtable);
>  unlock_ptls:
>  	double_pt_unlock(src_ptl, dst_ptl);
> -	if (src_anon_vma) {
> -		anon_vma_unlock_write(src_anon_vma);
> -		put_anon_vma(src_anon_vma);
> -	}
> -unlock_folio:
>  	/* unblock rmap walks */
>  	if (src_folio)
>  		folio_unlock(src_folio);
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 50aaa8dcd24c..1a36760a36c7 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1035,8 +1035,7 @@ static inline bool is_pte_pages_stable(pte_t *dst_pte, pte_t *src_pte,
>   */
>  static struct folio *check_ptes_for_batched_move(struct vm_area_struct *src_vma,
>  						 unsigned long src_addr,
> -						 pte_t *src_pte, pte_t *dst_pte,
> -						 struct anon_vma *src_anon_vma)
> +						 pte_t *src_pte, pte_t *dst_pte)
>  {
>  	pte_t orig_dst_pte, orig_src_pte;
>  	struct folio *folio;
> @@ -1052,8 +1051,7 @@ static struct folio *check_ptes_for_batched_move(struct vm_area_struct *src_vma,
>  	folio = vm_normal_folio(src_vma, src_addr, orig_src_pte);
>  	if (!folio || !folio_trylock(folio))
>  		return NULL;
> -	if (!PageAnonExclusive(&folio->page) || folio_test_large(folio) ||
> -	    folio_anon_vma(folio) != src_anon_vma) {
> +	if (!PageAnonExclusive(&folio->page) || folio_test_large(folio)) {
>  		folio_unlock(folio);
>  		return NULL;
>  	}
> @@ -1061,9 +1059,8 @@ static struct folio *check_ptes_for_batched_move(struct vm_area_struct *src_vma,
>  }
>
>  /*
> - * Moves src folios to dst in a batch as long as they share the same
> - * anon_vma as the first folio, are not large, and can successfully
> - * take the lock via folio_trylock().
> + * Moves src folios to dst in a batch as long as they are not large, and can
> + * successfully take the lock via folio_trylock().
>   */
>  static long move_present_ptes(struct mm_struct *mm,
>  			      struct vm_area_struct *dst_vma,
> @@ -1073,8 +1070,7 @@ static long move_present_ptes(struct mm_struct *mm,
>  			      pte_t orig_dst_pte, pte_t orig_src_pte,
>  			      pmd_t *dst_pmd, pmd_t dst_pmdval,
>  			      spinlock_t *dst_ptl, spinlock_t *src_ptl,
> -			      struct folio **first_src_folio, unsigned long len,
> -			      struct anon_vma *src_anon_vma)
> +			      struct folio **first_src_folio, unsigned long len)
>  {
>  	int err = 0;
>  	struct folio *src_folio = *first_src_folio;
> @@ -1132,8 +1128,8 @@ static long move_present_ptes(struct mm_struct *mm,
>  		src_pte++;
>
>  		folio_unlock(src_folio);
> -		src_folio = check_ptes_for_batched_move(src_vma, src_addr, src_pte,
> -							dst_pte, src_anon_vma);
> +		src_folio = check_ptes_for_batched_move(src_vma, src_addr,
> +							src_pte, dst_pte);
>  		if (!src_folio)
>  			break;
>  	}
> @@ -1263,7 +1259,6 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
>  	pmd_t dummy_pmdval;
>  	pmd_t dst_pmdval;
>  	struct folio *src_folio = NULL;
> -	struct anon_vma *src_anon_vma = NULL;
>  	struct mmu_notifier_range range;
>  	long ret = 0;
>
> @@ -1347,9 +1342,9 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
>  		}
>
>  		/*
> -		 * Pin and lock both source folio and anon_vma. Since we are in
> -		 * RCU read section, we can't block, so on contention have to
> -		 * unmap the ptes, obtain the lock and retry.
> +		 * Pin and lock source folio. Since we are in RCU read section,
> +		 * we can't block, so on contention have to unmap the ptes,
> +		 * obtain the lock and retry.
>  		 */
>  		if (!src_folio) {
>  			struct folio *folio;
> @@ -1423,33 +1418,11 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
>  			goto retry;
>  		}
>
> -		if (!src_anon_vma) {
> -			/*
> -			 * folio_referenced walks the anon_vma chain
> -			 * without the folio lock. Serialize against it with
> -			 * the anon_vma lock, the folio lock is not enough.
> -			 */
> -			src_anon_vma = folio_get_anon_vma(src_folio);
> -			if (!src_anon_vma) {
> -				/* page was unmapped from under us */
> -				ret = -EAGAIN;
> -				goto out;
> -			}
> -			if (!anon_vma_trylock_write(src_anon_vma)) {
> -				pte_unmap(src_pte);
> -				pte_unmap(dst_pte);
> -				src_pte = dst_pte = NULL;
> -				/* now we can block and wait */
> -				anon_vma_lock_write(src_anon_vma);
> -				goto retry;
> -			}
> -		}
> -
>  		ret = move_present_ptes(mm, dst_vma, src_vma,
>  					dst_addr, src_addr, dst_pte, src_pte,
>  					orig_dst_pte, orig_src_pte, dst_pmd,
>  					dst_pmdval, dst_ptl, src_ptl, &src_folio,
> -					len, src_anon_vma);
> +					len);
>  	} else {
>  		struct folio *folio = NULL;
>
> @@ -1516,10 +1489,6 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
>  	}
>
>  out:
> -	if (src_anon_vma) {
> -		anon_vma_unlock_write(src_anon_vma);
> -		put_anon_vma(src_anon_vma);
> -	}
>  	if (src_folio) {
>  		folio_unlock(src_folio);
>  		folio_put(src_folio);
> @@ -1793,15 +1762,6 @@ static void uffd_move_unlock(struct vm_area_struct *dst_vma,
>   * virtual regions without knowing if there are transparent hugepage
>   * in the regions or not, but preventing the risk of having to split
>   * the hugepmd during the remap.
> - *
> - * If there's any rmap walk that is taking the anon_vma locks without
> - * first obtaining the folio lock (the only current instance is
> - * folio_referenced), they will have to verify if the folio->mapping
> - * has changed after taking the anon_vma lock. If it changed they
> - * should release the lock and retry obtaining a new anon_vma, because
> - * it means the anon_vma was changed by move_pages() before the lock
> - * could be obtained. This is the only additional complexity added to
> - * the rmap code to provide this anonymous page remapping functionality.
>   */
>  ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>  		   unsigned long src_start, unsigned long len, __u64 mode)
> --
> 2.51.0.355.g5224444f11-goog
>
>

