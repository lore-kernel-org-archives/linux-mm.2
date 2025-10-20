Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ED23CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 11:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80B4C8E000F; Mon, 20 Oct 2025 07:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BB818E0002; Mon, 20 Oct 2025 07:55:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 683688E000F; Mon, 20 Oct 2025 07:55:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 57FDD8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:55:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 08634B5042
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:55:56 +0000 (UTC)
X-FDA: 84018338712.23.5B805B5
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 70EFE20003
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:55:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CK71QpFs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Vh0ohRvh;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760961352; a=rsa-sha256;
	cv=pass;
	b=YiycaY2Us8vVvYTqfU4JzJwAAassB2ntuSnhRlQpg0/BCgGDLPtKDi6QT06rMDCAqUl3As
	EBWuHkVMHHcEFa1GhT28b+zVyAbK+lFMsAYWnTH31rufeb0mDiVE0sVfwxmvn12IHEjr8+
	KG5MZu2+4tMsnD8jj8ikUw+iI1bwzLQ=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CK71QpFs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Vh0ohRvh;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760961352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sC4ZKXRzROBWth1lZdcMVGNh5k0t4stBW5bjgqO8puw=;
	b=ZXkYUEPhX+OHK+HoHV5yhCBJZBuK0eY3VzhEi1GIvysnlDO+cZvXOEY6dLmuZ3Kw0PDFMY
	T4IAv5MudQCQTPim6ihVkH72W8X5vtLn6ajtUooED94W+AiC+6ElNS5dcejiIiy4ED2suI
	AGM4expZumYJjD8DqwuwVX3HSIQg414=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8SG3N025718;
	Mon, 20 Oct 2025 11:55:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=sC4ZKXRzROBWth1lZd
	cMVGNh5k0t4stBW5bjgqO8puw=; b=CK71QpFsDieFxxRIRLTbsK25bO9Uk8B6nV
	njaMKP1CCXDivkw475UKAYDlTRvNrKy9QQaWqjxHBFTVds/cZ7jEooAzalhyo1uc
	2Ad+sKweV/OqQAmNdPJ2xETYD1Fk/9m3pld2pj9U7At8rqe+7O8XB8c5sFF/8dS2
	fU8SKwXm1KuUuFab8RZx8QVFFx9JKpKoLFjVSAATk4zfuROxIFRxaDTwdMinLQgS
	zbohbLZLJ2D8HG7T9Q0y/fW1JahvOrGkNwhNyxP8w++w+eR3OXm64jVBWNu/GSK8
	uiPjEP2Db/Crhk9cLEwSmsAjsj+EkUNOo7nFxEBDAYuYouVxC2ng==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v3esj2sq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 11:55:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KB6OCQ026301;
	Mon, 20 Oct 2025 11:55:45 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010011.outbound.protection.outlook.com [52.101.61.11])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bam50q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 11:55:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LOdO2uep1keCSyK7U/F4/aweg48mC0LNhH7FpN8nTwIAWvw4T5crNv0nhUwKxiwvrv9wmhV1rTava3RDa6YSWnLWkjOn6ZKH19Av/+o976EnKE/SQR4zvQksBcoosYq3RhCDO6yKJmFgIe5SuwnW8fEd/kpvvRirh7MhUL3FRd9zSK6OrK7M0knolB5uVQsx9RENJtDK9qoTkz+4SYaKHYkJjn8RTS/E6hIGMGm0zBawdmbMHAMBbENo1sU04/9FlNMAlpElnKhVI1gJDtRlNxuar0ZwTqt+Fip8OIJQqKieS3hc3Gq0pCF4Ohsv1f7CSulO/uldW7JNigGUnl4QFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sC4ZKXRzROBWth1lZdcMVGNh5k0t4stBW5bjgqO8puw=;
 b=XMTxXnYjlPUhh3GzbylL3htIETrZ7mVWp2pFYKfoo9CqoziUii0Fe+2K97/XkvtAObXigfRrjTunZUcmwcWe2+SxacCMCVdL6hd6r+7faNEkU7nfh5Kd/gdPhK+hdlHWeCYFehDFadb/dOJX9KDORFwVg63AHCvDCLWzzch47Q5b2YVITSmWkJWCgyfhz9QUf4+6MnqZ5Hg4BcwVaACuaQTyQCS4Gx602h8coexvoiCQqR3X6kFdirxLothfNq29oVSNWhp3LmIjmqigMj5inK/e9doCu2IMiDAgdrkPs+oZP3WtnzfqORd/+XEzLX9tNu3cQG28HVKXHeYB7lQiWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sC4ZKXRzROBWth1lZdcMVGNh5k0t4stBW5bjgqO8puw=;
 b=Vh0ohRvhbniEojerY3gqJQSfgDHyK4isvk/Ql8hwy4YZksk1jdyQmY+G8UZH0WTsIwtLQCbgWn+SpbAUATPL+9WWztrKn+p+QuJOyhtK/ZDwpTup9YYuhmbYJGqaIJz1drJ5ou+1sEvkO62PiV6PJt5j1Y5RUth5VdLzkaUZ2iA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6205.namprd10.prod.outlook.com (2603:10b6:8:88::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.16; Mon, 20 Oct 2025 11:55:40 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 11:55:40 +0000
Date: Mon, 20 Oct 2025 12:55:38 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
        dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
        linux-mm@kvack.org
Subject: Re: [Patch v2 2/2] mm/huge_memory: Optimize and simplify
 __split_unmapped_folio() logic
Message-ID: <fb1b1436-c782-4db8-bc42-98718a0befda@lucifer.local>
References: <20251016004613.514-1-richard.weiyang@gmail.com>
 <20251016004613.514-3-richard.weiyang@gmail.com>
 <7ed84d61-0a7b-4961-82eb-fc8d38b77162@lucifer.local>
 <154924ED-0CD0-458E-B760-F9F0A92CDC89@nvidia.com>
 <d0a2c81b-a0e0-4457-b355-2363f30ecfb8@redhat.com>
 <cdd37933-d2e7-4675-82fe-62b7f0ccdd80@lucifer.local>
 <20251019080017.oewm4744rvdtcmzx@master>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251019080017.oewm4744rvdtcmzx@master>
X-ClientProxiedBy: LO4P123CA0185.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6205:EE_
X-MS-Office365-Filtering-Correlation-Id: 972841b1-eb85-44ab-4692-08de0fcf96fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R6NgX+aLNU48tYnrgiBOyBQQPVAHAqqhl04NO1o3fXi02RUsihOsHUGq4NeG?=
 =?us-ascii?Q?ZsaGoEPm5XWz/p0gtsBV4+2R0ycEjzHliggDwXgtL7pv9J0+SEevH2W9Bqyt?=
 =?us-ascii?Q?aPClrymmqOjB4clD1HSEL9iUITaZQ21OPkBLzuP9X0ahlbbQqcX4+prNyRvX?=
 =?us-ascii?Q?dB/hGoLNxHBjMZIfEXOyeKwV5l1Jqu9ns9B7zNrS0CvsaAzscYsVCF0uViEm?=
 =?us-ascii?Q?rSXNXt+BzwO0wZfXFki9bWUKS3hmyr3zE4AHtAuVh6WPvoh2+VK36V11B50P?=
 =?us-ascii?Q?aGMdGgT6roBRiwVvvth/Ys4tUkqwTUWWw3FECzvXRNXyBoJ6MVO+y/gLDtq1?=
 =?us-ascii?Q?RK+Bt6LPH+OsoHFe+Pb/SYAV1/7/kLcAjv2+WYBUmYMZPJMQAdRpMGCyZDvP?=
 =?us-ascii?Q?VYhm/nAreu/RAHRGomnNvMTdnVit+jX9C7AdR229OMbhgiOfgrTz0z4SguZ5?=
 =?us-ascii?Q?kKQiKoupYFbBIjE5WkicEJJoLCz35BRQ3BVXfvOFQnwPxeuFBD32LMW04ofN?=
 =?us-ascii?Q?1T+GhudfA/psSrjicBbA8EMPzKGjMHFHYMrkhA367d0ladTALgisOfMoosQL?=
 =?us-ascii?Q?/dPZL7wPPqfrpPO49YqGs2jRtfBHNV6GCpBIFgWTAOOWWa+bYhayb/wpdzJa?=
 =?us-ascii?Q?NWSUQbuXH97nbOd5G1HVy+S1+A6PqtRCHZ4/fV/GY1PfptT/9Eir90R6Bljg?=
 =?us-ascii?Q?5UYwDsfDi3iRpwH8kN5HTIPQ2Ju22uteGsh9ARACaxblGrMtsmXnJa39jh0h?=
 =?us-ascii?Q?4/5PLuL/iyrD4wAD0XRItoH1SzVk13Q+rICywiY4AcxYzGUP0bigTEg9eJcU?=
 =?us-ascii?Q?Fp9jsTJQ1Lrzf+GGx+nFz9/YZ0zs2kLHwrWU3sqDMlMqTmd/fa+X8tK84dD3?=
 =?us-ascii?Q?dwm2Pv1b71xQpzTLbWfFBt0U990kk6z90oPGv+59U+qfAQXNlDBa89bTux6V?=
 =?us-ascii?Q?uGsQPAShM+h5Krh4bNtlCkbiBPW+uaisKwTzbBrQ0cW6lygU+mNdfGZwhh+t?=
 =?us-ascii?Q?yunl0z78rtGf1RC8Foqufij3BTsf2ipQFMHa/ASuZkL0GZ/qGbMu7g13OpXu?=
 =?us-ascii?Q?1SNRMjFKxpmrDwHowS08T6freJjxtK4aLr7051PVuGDR4VBtZgsdeKoQkIAn?=
 =?us-ascii?Q?qcKJlNTyxU6hGS4hbB1vWP1eWrkhXWeHDl7c9Prxlp97LxQyhaeiEAQWJCTD?=
 =?us-ascii?Q?UItxfdEEpkCfbt7o2oxvET4P339vDdE7vi8xS4irnwCpJa7zJQs7Eh1Tl1MR?=
 =?us-ascii?Q?MV0sI8nKdfjZ+arzoZtiXEd6jschoNizb1YpBFEsiSbDCwuHbsgrxrowkXOS?=
 =?us-ascii?Q?MBwbJuTtRitD5YiAH0WUmAn+ux4BEfaqm5tZQNhzv6Os4+RIKxLeFfWEYCvp?=
 =?us-ascii?Q?a32GGaE+uxVTJrmVjDFeymPDKKNdb/YI7qedExoQDddptepxwr02DytBIKf7?=
 =?us-ascii?Q?XNwFAVMvRg/FdQedN9bxr2+zrfGuUp8K5VqdY+YZifHG5/3yyhzDlQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QDFNIseorC4ntxKYPjUdKt6y5c654A8Y8tWdU9XuyiJSjmLYlPdNA4fBxtuT?=
 =?us-ascii?Q?f4Y34QN+bnli0KWBbXZw3c/eZXQz2t6/dJNxIG5HdPgECfTG/W5ggAaC780z?=
 =?us-ascii?Q?qh4jpFr1IF7M1cYhqPSyn/8zJnGCv9JuSz3WAcWYumiRqdGxeVbQAAU5h4H9?=
 =?us-ascii?Q?MY4oWd3J1tA46u0oRFdchphwCscR72sGDwX02UhZmo9MTS+PMS+yH+nEK4kQ?=
 =?us-ascii?Q?UpTGgU03k7I63p7JsRQE0UIRNnzAeDPvIQjFQH2O+40zk+dhNkM64cUkn25S?=
 =?us-ascii?Q?TYzC2IVhfkjpUsZnMVZisCYH4wmU8UE/CnQvRXa6/OlkrE6LxCNUTBsT9lsE?=
 =?us-ascii?Q?TYxz7phnw3AqwgjXgeVioNLQxn2aE9nZgLbcaQ2fybgSizbRjNEicaj3Tko4?=
 =?us-ascii?Q?I86l4Vaj7i41cfADLUtz1R5FYUnU1/b+IcKG2IMrZxJ2ubBavvp04njolJjF?=
 =?us-ascii?Q?6lAuU079emJYGKtZfyCLhodbVqQm98JXjvtcM421+Qy7X1M4UnM+LzVRrdI/?=
 =?us-ascii?Q?45SoYsrZxAh6JF0OOAlXHD5Z/P0IoyeblT0dXceN3suPrQn7zRpz7MIPyB/e?=
 =?us-ascii?Q?UJVi5/fd/K5fhSXG/fZ5aJEKcXgfNL7QBtJPmeQ7FXjcAEXOXOf9A60DtdEY?=
 =?us-ascii?Q?e3BbQaiscqR1aTohokapbfIZeSGlmb2wnwA2ylCL4Qp97RCYe2ekAz8bQYdp?=
 =?us-ascii?Q?+HhHP3hdsFE5G1sV2NUZYduoo+v3AbCroVyBRYFZ3Qx2O43i6SdBV4pK2tY3?=
 =?us-ascii?Q?dLe+4KrJgnkHkZgdjAwnEJS3T+GgFsS652O3UKdQTwkLlBska2TUpMA7q1N/?=
 =?us-ascii?Q?Hmp3LDEa1c1NoMoZE9qREOECIeILZZhutUgPNejskUOD368fGMYVwEBXyM5t?=
 =?us-ascii?Q?PRKSsMK7huoa5xCIhadN4rF3E6aqLXTyxuKxh1AU0MGUveEZe4tBfkrIrND7?=
 =?us-ascii?Q?rCrzLDorUlzp8q1GkX9191S5nZ5ZLkk+TN/p6bkCv5exsEtEQRaSYEfumbHn?=
 =?us-ascii?Q?q6SXJxpCxv27aTh7Fv4fs73G3OBV1gBN1ErasliLzBIhji2YM3NtK99zKkM7?=
 =?us-ascii?Q?WNgfSg9jRP0v7mJJgcxtBmDDvHr3JLDYyev8mDsvgZkZ9WUod8MHR4g3waYC?=
 =?us-ascii?Q?e0sV70GAGExtD8RumQ79V7e8wI1e+XlXOpF1BMSAMjs5iRgi4Lkv3/wUQXNF?=
 =?us-ascii?Q?WmBTHlmE1ofiJUpiJvwZCr2zmPwRQFf4bfKmN6llurXXBueZ3Jf5tsBG5LxV?=
 =?us-ascii?Q?BHw0QcWbhTrI20w+jHDrLIZoxf+jnyuy6jbRSSHCSRXSIh6nt03pp37uOFeC?=
 =?us-ascii?Q?USwXYu23ek367s7o+vJy7cApAY6sdK6zhkYBHZ8wn50F/E4ZecyYxEjNAdoN?=
 =?us-ascii?Q?vXDeBeG6/QQOAS1l/sobiC/37uzerGkiMkuHYsaGi2Z3COIYjsvUqKGVb+DM?=
 =?us-ascii?Q?HOiwTNe65OJx8SeCq2bQ6mNTMKo/y7HNU8dCk/KueAOv61AgH1W5PXhqXuxg?=
 =?us-ascii?Q?yMWEXtrreA63AICQuEWEaVcizMhf9Q98iGDzW6ajHyLSjaEOlnh3lZcEROL6?=
 =?us-ascii?Q?VTmtFodEAx/6U/Mx6LLJKUvrnpAsCUHnJsFGznufUJktVAxQSp/f94LHP91G?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QuCSKgxYfvaJcfVbB+oVK8lwaG/tqGmeQLO6ffYAssE8ydhcbmiS5wJmbANmPfokJKQFstw9Gs+2ovX5YX5AHxqAILijwQuwR6vLfnbAYEfHNCBcI7B2Jw5PRt2Xe9pXhBlkTFrkOidgX5/gBN3iXf2J/DymAtY5T1dMroxE+kEyULpr+jlzX2YIGcJ8d0NUAZjKQWnoAMTocg9W1RE4r19AXrtMVHbmEZfwE8+yDxIvg1SYNaKZC6ymuoiNtFqFxe63iFUncvge8eZzmt+9ncVXi0kHNlS3wCLx1DYnPbOv+vuNN3ZyF6vN5MzkSDlWZLJ1L0V+OuN0uTrs/0hBKDYx3wYbeaFJqcccSLjKEp/3M5ikHPUXAAup2vf6RnBt74CM2cSzxfHt6JiIqOPMPQJ6jH8T9IBA68buFKEKsHHlYeTf8HEuxbsj0R5BfXGdQmsqoGCBkH9Im7MSI2vpxZ+ouNsTjgE9u0VaLGWW+D3yUWw/REMfv3tdCtIKaGFShR5JvhpJKrdSyMdmMpphYZ2jigDTHKoehigL4E3x//kCgRPWJcVP2ALy6XDHI7k8wMSoIEUaB1d6fLkJ/NTsn4d+jqk/bqGESaYTyuSKRzo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 972841b1-eb85-44ab-4692-08de0fcf96fa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 11:55:39.9452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eMu3l3ORG8oWs40SGw8JOdYSBN9PlrACbHIqqEwwbgx+h6jWsNm7jF+7qN6GgLaBVVXFM1KeihRfhk/jaSB/UNLYiqDpGt5p7I3JmQKSIgo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6205
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=629 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510200097
X-Authority-Analysis: v=2.4 cv=N8Mk1m9B c=1 sm=1 tr=0 ts=68f62342 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=lGCp5RX4qPt-LFdYNfkA:9 a=CjuIK1q_8ugA:10
 a=QYH75iMubAgA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: Jyxe-1OmqJLJfB7mwpG4DOQnXZHO7tst
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyNSBTYWx0ZWRfX0XpYVA/Z62EU
 NdtdLLvE8/T+M7oOAP3DpNrxUcmB4+BtCot483M/0ob4OM2PN7+m7p2N06vB0KCydF0o2AvVi5m
 cWissw8fK8MGnw4xQwEbG6hysIpj4tDoK4FmY8jDiZ+5kOnFJAYal7pZhaTUto//xBFTNRW5tcJ
 YszHMRLR7sI7axfKj94PVjSfW6cc+gxmtGcH0O/iDRzKvQvNkwgI41KsmPi0ZL5N8ZUehBqFtG0
 TshYjdQ4iTv9gqwMcqAFaoqafLUTNaooxyyH3LM+QWAPFrToPpzEAtp/+HOPbA16TijvmGDJagE
 /FmiIhI+5UBJR+R/s/xMWVcRkFbWhCEGycdPTDeRXX3/Gc2EbEXGZUlVKe1ALp/SZxB90JkNitj
 4bZ9bRyLUbwp2Okp5nbfVnK2GXiKRA==
X-Proofpoint-GUID: Jyxe-1OmqJLJfB7mwpG4DOQnXZHO7tst
X-Stat-Signature: 79njrnpgrqkkctehocm5hmzhu8c7ets3
X-Rspamd-Queue-Id: 70EFE20003
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760961352-305460
X-HE-Meta: U2FsdGVkX18m8BVhkwAXBaS/tyJnbheaj9xLWVQwC7hbcEynkExblcAMdT6B7Cg7hDvgwGe1SO0MhZMUcxDlO49ecXks9j9R0AKmJK/X/Moo/rXiQx7MCCEoQY5p5ZM0kOx/VlLxID/oLjqrTmHXo7HEXryxs8W1vkmtIizR4GF/FXjTmqpZhxu9j7hAo4mCV6Zz7Xi6A3YYhluw2SOBGJrePchRi/k291sV1bMceVrG9CP7rWJHBQP4hBs8ia4TAHrqS63845VUYJhLhSiVpxnhOFYdoS14BGO+coM5DrbkZvVgf7bkzElipN+3FmgjFZd8zb3o5fYlZN/PBVc4Q1Cy/M04ZcXTGgzzclmv8RYtVBJlE75WnWuZ54XeBY0qIKUCKv175BUsrkiMgSjQvYoYH/GyCPBo8nHL0onTNDv7myJn3uQ4b06skWSr+V271zpga0xmDajGjatpjKSDi/JGiXEBdkh77Do1mEBVtHvfqTQW0j8RUKhM4MeQ+KqBSjKlX7xgttVF/hwCOvDpEb655W+iOECPKWG4T8jSdfb64I5XeKkVWJEDpIgZxty8iNOT72cCeF35oCaVV6G/5rf+rVp/JHyyoX8G543kXy787ysAYKPQyKe96o2mpBWNpOgOhE77IIvhjvwL+TerfQi6kAT4dFDQq6snJ6z4c2D6j7BzLclcF0bnXXhFD+BJETocLFroVpapaYsEZp6Mpgt0zAI+wAoRk/Bw9XYAloI3wefXg8z98Lx6WRYuBXVdH0bRSsaTgJNP9YKIMO8WgbeDTT1KDtBe6OXBhiLxo0BMZta4P5bPqk3YpiprD5KZh5+Vdv68vulz57VVLg7ZsazgH70UGZTVrajqHw8cvTAL+9qO2Y9f7VtHe88Mt000QY8Xc4GMzrw52UwzTK4XwWmnoz3drqKrR8slv0XINm4FcJ9pRUDA6oFf3cL/aQfBzlr84GoTj0Apl6oO+xs
 k+Atrg9d
 L8AEkWOBnHeRATnbGT6YdM4SUTKKewY09Ux0oTlp9UQhClhdzxb53MSG1J71Iz1+6N+Y65jUEqhC4zNPKiZ44mM4HoHVjdzfM+taf985o7sjGNUseSnZCp5PciRHvQj/ChzyVVUSfoCtqH4Js8C6l4WM7FoVtNdI9cwtYWeg1pBJf7pIj7HvhkSBDjYNfDzK6cdSNxk5J5RlCnw+RQTHEXmWtu2Bdqr8l2pjaPqEqin8Sb99OPZ4Y/M6M5viWb4uXfQnXgicmaKEEeesoctPF98pjInl625bUSmlCiJLA8ZyyamGoAH8n/4NS+k95/g09HggI42az7dmEU6jI2TmYPefG1+rfQAuyxq8a3suWuw0CoAI3mMFlEV7zjSgmmDWdzdJtFzc/exSFKIdSXsBiSHwtsY9cYjhp5SpxJ7sruIUDpNsSSW4ygFX8sN4yG9kcvlK+S7/tQcgoiArWlVOjhu48uPnA1eYWpaTCMiZcH9t0gWxsyKgqRaHpv/puLq+Ihh8Nm6halWBF1NHhP8+61wXLyl7W4ygglojwnI27XadmGYySd+9jdvwYcXPNK4Q+zIVNKgpGHK+WQQduShVoWd6QwVxL/7SlKgBxyzn9VlIsxwnWGmpqQ9W0VvITVe3iTi2dJy3CzIlP9GiuisTYbKy6V2UKfrOeivG9bjqnzooDxTZf3JzCLbc66rIgbWOearNBuoCJfHKn+XbbVuDOdrGYHyRh1/fU/6opkN4J5h+kg59aJ6ozAksLYYHkXwqoWpyKhvDMbnosTZVxUN498++KQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 19, 2025 at 08:00:17AM +0000, Wei Yang wrote:
>
> Is this version better for review?
>
> http://lkml.kernel.org/r/20251014134606.22543-1-richard.weiyang@gmail.com
>

No, this was _too_ divided :) I will look at Zi's reply and dig in when I get a
chance.

Sorry for holding this up but I think important to try to get this right!

Cheers, Lorenzo

