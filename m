Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE7BECCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 15:55:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 183D88E0103; Fri, 31 Oct 2025 11:55:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15BA78E006C; Fri, 31 Oct 2025 11:55:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0235E8E0103; Fri, 31 Oct 2025 11:55:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E3ADD8E006C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:55:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A90134A2EB
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 15:55:40 +0000 (UTC)
X-FDA: 84058859640.18.61C8BCA
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 640B540012
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 15:55:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nZg0ZK9b;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sRRSkcIq;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761926137; a=rsa-sha256;
	cv=pass;
	b=vkMfgSeWRJTrUyce7uSZzSu51Qsy1jBkTfTQ7DZKJGQVqf73ZrFqpVQmT8f+E4AgIMCUuO
	hWHjLrCoDe/p0Wqo2l23f8YkqMmJTyBqsWIOfMS9+5QCjx6v9zrGG7wlrSTU3LEFM+9g3S
	Ecwi6FqyRmUmoDorxhtHMNQDlLP8UVk=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nZg0ZK9b;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sRRSkcIq;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761926137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6QYluTfd3owg3QdgfWsyFXl2Dcit6+VmV0IategEXRA=;
	b=GjXKaJVP84s3e0XBbHty0O3fG+hxYzygy1fT+edliy3PaegJGQFKtSQ+2oOkus6RUT3SNF
	/FA/L8FaCddGaV6Dun7rZaimUaJaIeUYOaKOGx/ngK24sM8h/mwu05+yT0rCQx5kfXsExe
	GO1/8hafXGAt5ImmxEHroB/cFQD0aGU=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59VFitNx032479;
	Fri, 31 Oct 2025 15:55:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6QYluTfd3owg3QdgfW
	syFXl2Dcit6+VmV0IategEXRA=; b=nZg0ZK9bMS1KAouZXyv1DocDNsIqEs2qqp
	3+mBzrMRcEl4d1s6RuDU5qQAVk8oRMyrm8grlw5eJFeTDOhJ4Jjveab0FDaIinwt
	zlJfdQHguvL4rdnVhai1GTrob0wf+E1UtQW/bqn+9lifI6imGehXTEQKgiJ5fQAi
	+pdTKeALJi2rrvCOGZ7isWha6qmbexorKKa2OnbvJfz+p50jj5oTYE+B2UQgIbxx
	Mbxjzz/F2R+Xu9k7NwPc0KywH65k+QVGz3oL/q3FN4Nm9vg1yydKpeuNmTegFdPg
	dnlvBrjhTHo0FP75YhV8oYBT5u6y8ARUQMV9Pdj4BtESzy/soDZw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a5011g19b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Oct 2025 15:55:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59VEbMCY000472;
	Fri, 31 Oct 2025 15:55:34 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013007.outbound.protection.outlook.com [40.93.196.7])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a4k7c1e7t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Oct 2025 15:55:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vtD08bDRuo24sAYS+2zhHorEgOpkBUTTYFVr6DhAbqeOQGR4cKysWngRCnTKOdt8MxkLFR6uOK6oRApOO9JM+mTx9OrP4ce3QZkMH9JVQOnOeQpCPoPpjak4FSWQJzgBgcFJ+h3J3sPkRmTiV4hP/iRATPzU7FwT1hZKCyoGVvghyLFid6NhJy2zOISLIs1JbZn2wBCjMqtKhXt/gkb7XLBHm+uFPTlLC89V6SHsyPIyeYy3TmAlg5fzjf36AM9Nm1Q83UEdkIank4ee0l9QLbbZ+ckT2X6oIAJaAwfnacOQj5/70MuVds75tIiT9NyyjzYxudHa4wM0cDM+tuscew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6QYluTfd3owg3QdgfWsyFXl2Dcit6+VmV0IategEXRA=;
 b=QgNswWG0Vn/+R1viNcZ3A8KiETEu2OYemOlY7F6CKaR5YoMbdkBqv9XU1uELMIYMf+M4Hwq1GVl7V+ZKJAQRKjgrlvR4VS8WMWKH+SQppdIU+s/RFvWte8SIrJodTD392N5zDAs2e09GuiuzRBlFkqjFBfKvLrv3VPA16+w2uxBBVbjVwSCFNfoM0cE+2IjhrE9Fg6lgJVOXuvhAzIxuXqGh2NGt9ieH/7GG1GiMW3WFb/P62aSCFkOMFKkCwHB7nxxEOE+qu5ZisB6qhHf+DbwS/yQ69ZrXq/TZdThJB8X6Tad91EAJcW3vZuwuRyY9sBpFJfoDR64DkTEj/OhvkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6QYluTfd3owg3QdgfWsyFXl2Dcit6+VmV0IategEXRA=;
 b=sRRSkcIqzLHrGDC6CitJSlsT+b2ncwRIWP0e5jLA6O7+2bcaqSVu5tZc0Zq9AzY6snJmJ6yTpVaB6gGH3JyshmsjFm8dTahWGW7MGWZGPJBmCQFwIJZnkuuMydEU09cQqmHPUeVKDnbOWfKP5yJY8gefYncVLlB0iDvR81s9OKY=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CO1PR10MB4689.namprd10.prod.outlook.com (2603:10b6:303:98::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Fri, 31 Oct
 2025 15:55:31 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9275.013; Fri, 31 Oct 2025
 15:55:31 +0000
Date: Fri, 31 Oct 2025 11:55:27 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vma: small VMA lock cleanups
Message-ID: <luqoixa23qf42f6wcywbrtaitf7mdqwwm3tbkxmvkwxbnl47aa@bna6ddoshdfs>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251024090902.1118174-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024090902.1118174-1-lorenzo.stoakes@oracle.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT3PR01CA0047.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::11) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CO1PR10MB4689:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d86d44b-92da-4af3-1dcb-08de1895eb0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uOurl8LlFBT6dlARCZjAbJYK933WrYnoCYzA2B7d6jBeej9tW0+8c4aCSkDv?=
 =?us-ascii?Q?kBgpH9sNv1iLtGvnz8IU81+EgNkBsndwzlO/LUowcv4w4xAq3rxByauLzW5v?=
 =?us-ascii?Q?VTIkptNJnG6QJIpIPVyE9w5ow/f3rxNCCcDJZ2cvfXbchGAWHiH3PDCYy7oW?=
 =?us-ascii?Q?zqO8bVKnCTP/BboaurZY461P+G+lGQAdqE8uasZino+3gd4oJYneE7yERTHE?=
 =?us-ascii?Q?teOuxz+Ot4d+Aklf0eVGNRFPIL0UB8bK6/qy6c0murMG53rUt1166wuc5rYg?=
 =?us-ascii?Q?P/G4+jqXilqnpieyCwOxl5841Ydo75MBmap2n3mPVJ2AdfULD+/2HcuUBAGv?=
 =?us-ascii?Q?VQlauw0/6CoPIiuRjfZIbRyVIjr1KR8Sc3TAJGWAbtsa2RdSWpgPUqQ98Boo?=
 =?us-ascii?Q?xZfEMR4aqP3Mwtvltlmw8oT5tNxKt0qFexoQY2/0xSVil0lQ4DxronHfNHbD?=
 =?us-ascii?Q?58CuLUyPhXGN6ifK2/5zJuk9mNK1yjRkgqg1h6sA9mvsZgpblhBwKHiZv6Jf?=
 =?us-ascii?Q?RwoftcSBunXXStHAfhOWHUEQs5vycDuQcc2QDw9wiSVngDg8R2/u29CB2AB5?=
 =?us-ascii?Q?5strKVrzGQxpWuvuZn7DzU/9OnCRNGUZv1ToIJAXKh0HjUy74flu4HD79AW2?=
 =?us-ascii?Q?je34ZG8EyfFX3eoD0kYYZZHiTDNMvqsxvFPSSTAEzU3WJ+pA7qQq5qTN67zV?=
 =?us-ascii?Q?HdpBzeGfNjz7lvLDc8Dxy+5ZKATpg/YwKoYG3A3k0RcR57Njzqmo3/b6PpJg?=
 =?us-ascii?Q?X8dHlycRAa83rdOz9HuqRZkFU5daGBIqVCuFhH79+LoHrD4ykvFzLc1DILX3?=
 =?us-ascii?Q?g7HsRz0TIDwHgQjvRZiSmQaDi7Ahb5o22aqspBB5jxiD7IYqsqUuxtkPq88h?=
 =?us-ascii?Q?MrzsOB39J1ApBm6gO+QJj742oWRvAGwloGZMnYSAWTC03R5UJ+V/fpRLwsSb?=
 =?us-ascii?Q?avWZJIW+OQ8uM22LKlD72EabyF9fwoUZtW9NMRsSjteJXXEWPzIu7wkn/kQ3?=
 =?us-ascii?Q?SpNnWAJ3BhuZIxuWqtVQhj6pzPtbiHj53HA3AdWMSug8qecuq40wp5gLyNH6?=
 =?us-ascii?Q?EAkAFySMcYoRi+PKTUL0RuCeMksqN/CH8y5ePKM+T7q5CY93aXS/Vmsy9B99?=
 =?us-ascii?Q?HaIw3IToIjQD1z5QMPX/aukAlfhA7bZ39GAkhAF6q730kxe80E3wML9RflCk?=
 =?us-ascii?Q?rH6ngqFgSDPqu8JzcixT6uTb7QwIYgLDnfL+zdi4mJI7HYCFsG7X6pCjWhix?=
 =?us-ascii?Q?/55ciyb+E+RhHEiLXG+A5zEcC5CwBTY6G4iXiuN9oKZ/xdEjpjkXC9mwWYCx?=
 =?us-ascii?Q?no6YkIuF8KWtn+5E/7qaQeOmcAUUVKEi8ue6P49Q/B9ijocKeGFtkptMEHlt?=
 =?us-ascii?Q?5CmNM/b7guAmmjKhfQ3jX07guxNTlH0HjcIeTSjzlaA5lUdewqGLV9cgd4L9?=
 =?us-ascii?Q?NCRXygEvog9m05mw2ADkxXnDrHqTRCJ2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7P5ccTRKImyjq9ZU3ChD3JFPH3iPOJ2o+9+/sJw04iLjaIuAOWS+JmNE5Olv?=
 =?us-ascii?Q?wEyAORh7HhUBb1obcjr9d2HDqIxz9/EnbImSqHbLg5t5VJpd3x2HLw6dmO44?=
 =?us-ascii?Q?pdOb9K25kTZ1EG22inWFQYQeDU9cYjeSqa0jDnDAJ2N+VdNCu70oIZsmFGMP?=
 =?us-ascii?Q?bMVmqKVjDMjrOUwZdjf/AQpuyYPvX2JO/5Ntkb+xlNvEFlAZxx+cqBwuNfE9?=
 =?us-ascii?Q?2X614k84b7P8/V8rm1iMOD0vsU44nuOxX6o/MFegAw/x4KPcLvKkOc2GUIBa?=
 =?us-ascii?Q?U1GXq8DZcpeao/2CAn3FvMQIG5tETKzpLNjVjFR6G9t/muKh0Nq56Rk4OT1u?=
 =?us-ascii?Q?uCLVwFi3MN4f9PddcolNetybPwGeV6tcWAvF1af3YKoamtDQ4kUgdxxGndiG?=
 =?us-ascii?Q?05WfhVdk8NdD8GKq6br0St3QrtEiYgkOt7F1/5GBOwsbAUsptVw62VmN+1Mi?=
 =?us-ascii?Q?2j/S7k8dfkpuE4Ny56vpTnOhZmxNXJ2kxDb/V3P0sRXYZhGid5mT5/hnc4En?=
 =?us-ascii?Q?AZLK4u1CsHu891jAV1ZvDn/5L6bd+hYiEOGflSKwTEh0WTE0Yb5NoUwt6rfe?=
 =?us-ascii?Q?fcwBsv9rT4M7kAOJbNpeKo7msyqXJ+biVBF1cA7UxeRZEpTAxJzp/rbWg6cV?=
 =?us-ascii?Q?tQb5+qa09Zel2kvv0C4BJWMMlNzsc+QbwNCADUCpk/IZ+rCp37hReNAzNwyU?=
 =?us-ascii?Q?76dq+lJfygdPYcjmoNUbo4D1KC2WThxw4r9KHtr14h6ckcT4l4jERJl+NKXk?=
 =?us-ascii?Q?7sSAdrT2LjC9KJx+Ax2X3hIsY78pPB36fOELECzotZ3mrUpoWgJaVUH/AVr3?=
 =?us-ascii?Q?LI8u48j17lM5mo5RnXgx/575kJaBR8qQ46tivdPqntsS1snG9VbPn7nxgVik?=
 =?us-ascii?Q?poYo3ZyNoEWxeDqc7bQAKs/EurIZFnInUTA7jKRxcg9vLGuK549AFhQV8wMm?=
 =?us-ascii?Q?N0seYSIFM/3kVLbC3Xo9crKAUk2DTd1gQmEZO0vvlUEJ5ddvJ8gmZRjYtIXF?=
 =?us-ascii?Q?2qeLCUptfY5Lmtu6wkHKY544+ToiSubzsEbRbYpIe7CgUNmedD7ac9eX1QWg?=
 =?us-ascii?Q?cUQnEGUbZLv+Iq9MEPp4ddAlZR25PF3wm01Xsn9zmqfdxkRSTMfBq5o5DTnL?=
 =?us-ascii?Q?+wfonRiWl1Uys9y/erz51qTbwaA3ppp0iD5u+WookJ8wS01+XbaNX1gGFCzb?=
 =?us-ascii?Q?ZecPBjYSCdsAW2nC29pUz+WwcwbplsAu62BZ4mKaqpUqSmKZtkiLUbq7IGh3?=
 =?us-ascii?Q?vEhBYfAnjP79Xwztup+blDoS/UXJxfhin0syyg+hHts1Lvbebcs5M3EZM3+F?=
 =?us-ascii?Q?Jzs/2ZlBqw3wej/YXtfASu5yMYfTJYaFTAXc+07FGNQhcKB/kdQT2a9Fjflz?=
 =?us-ascii?Q?j3niYY2apIUPROPU2Q8E2wI8ho1/duZeXeQEXhaeGiWJMyJDPjCWhi9mAdyt?=
 =?us-ascii?Q?V+9H+Yi9O1vrSsJC8mACB8vu9V/5jahDL6J+A/eQUhfqkVqcwJqiwWqzpnFG?=
 =?us-ascii?Q?WL+4SM10OhkC87Up2ychv/8yrJKZSo8qxvDhA+LH24eC+kmu7UvkBLx06K75?=
 =?us-ascii?Q?5DLK2a6autBTuHTEiz3PHG9D+IQp4aYojrdUnUqB?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9+ZX7b+Z4WH9ZTk+focCJbyOZs7INe9ydc2jWPzYRgv7IjR3jiOey0u3PhH2Cz+kp13KxCh4f57ThmtIZg5g7PQHKYArtHS64POrCTNNV8+gBKjNR6KQtVQumLN6DGTdIgP081GP70qYbc3uvSjNenYkD4EVGe7/1NTVVJt1xZzoi077drtvHb5qNXqeUdsA9bBW6Ituim+/wAUtTkYueSg+hPPBsUhGx853fGKQdz1RBw426Ux4yXJgY5jJ/2q1j1t36Y4KOzUb5zwJiHY876S723eKLlgspE2sHrOqXc7rIi1yZHLk/44KLdiyZ2My77fnQX6TjMccNnjd096GIii77rMXtBojJxX/Z9gzPpwg2tfkpMA91kvwYwuaNWhi6BcQ/DUydPYMuNuhjMnXrt4kD0XRv/eKKY7XmN1ptfFum1pC/tk11fPFE+1QFHYH2r8V9oSNHsQQ+Y+fOODjawIX+jtmxSrM/5JeAbu1ZBFbBpH+dpePZA3NA4W7aJ2Ew3+jPVzkX6ng5dBIhnZq8IK++edaf0aG6rysET9SfRVMkKsaLVlaF7I14tFLj2QsVVwE4dCmBuASDW1bgjAjd7Ah97PTzx7xUgrfQrDUoxs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d86d44b-92da-4af3-1dcb-08de1895eb0f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2025 15:55:30.9064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nY5xKHQxSL9I9QNLxnDabkmS5ypByubF+uA3yrQ9U1MvePqR/zwX4xynqdtX8He3DF6CO/Q0LjyJEGsJsd6YcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-31_05,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510310143
X-Proofpoint-ORIG-GUID: hJnhSmhR0m7oVJe3GALSjQ2hY6y6zenN
X-Proofpoint-GUID: hJnhSmhR0m7oVJe3GALSjQ2hY6y6zenN
X-Authority-Analysis: v=2.4 cv=GfoaXAXL c=1 sm=1 tr=0 ts=6904dbf7 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=Tuv8a0UooeRabBwgraoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMxMDE0MiBTYWx0ZWRfXz41Hzi/OfqN7
 zC9aOBr1LCxRiwDxANDZ0iqzdOZ9WFI+1k2emFdM9DjmANSl07RjZkoF0macYoXp1CkO1eWyy7R
 LuFnogIECXJmVpoS/hrKIoBpg92dXJZm2atjGPdMAiNVvaCdy//KETf28gGCYjErvVRuqVUw0Fb
 i8E3N7M/EPQJ6uykWJ1I6JKZskGcqha1aCppGFqizi/49andBVhqnQUvCnGnjSqB7BncUeF3rwq
 lVkfmbuQGQg5ZFMe0VWOAYsVJoZ078vuWou6xjehjTiXEb1lLdQsdoiPDXw4eX6uTAggTIdhN+u
 emoYqKD1yAFd7PwcIUkHLl90lPbjWS8dwaYqMthoT+pDoZbN5WsksvXPbTH0MIFfwRneuU0eUda
 UFLx/Y5IRtgyGDJLqBKXyhSZcsUt0Q==
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 640B540012
X-Stat-Signature: 9kfr6qs4p6gz9s8ex47wisi1rqid3fjq
X-HE-Tag: 1761926137-861711
X-HE-Meta: U2FsdGVkX18sL4Nun+cLV/VRQugzG2Cq1lSfJ1E8VYJXWqjJJ9AvnYmeXMIOLSjzMKkTHGAoTa0FUYtasyf06JxmggiaCT3P+UcM5j16Sb7lrEVM3EzXfLlSNKDsJpTjve/+N2YrPnPZ4bD2rqpxIW3+GB8qROhZ3TkOfyWYTesbeGXIAHqCHqXe+nTWgbjsefMBV7DyjPpwiexT4I3KlWaYeevTTe6lIdQzGXpIzFRLgY74XRBNkNmw2mCkziCm/Rg2MsUf6gvtgckMbsnGOPaSGide/Yh7v7m5g1OdKUIdkc65N1Shc9JfjMvf0X5wjmKi+/aAAkKApNgiDRyS+81NhxrmK+ji0ErAF4h2lmhiwpVw//UHSOR4xrT1HNk+6U+kauJuuUWfAIEuYD/ics8mbS8OK6ajtiWvsu3AInvyb1yk1nl5os/seHbPf8FnQwORRn7pY26Xg6DieuyLNTuPeYkjUjWypuo0qEtc5Bwiby32fek729VHfvgsTehJ1TPifJQ7vj+RACuPAoQAiSBgIYuImIN7OOr1n2eXEtFnHx2CmtJJwlUNJY1bGLbyJw2Ac8iNBwOnXM8/adzvw2wjHg3kryBmcNXqBCSkDNjGFyD4yzcclDwDGsNMcEhhXE7qAC5Wx1Kq85bPMdf6kHaAR3gZRacI911bgFbhhI5Gxa5P8oL6uU5Dy8XNt8lptQEvyPI4wL/mv+d+jIU+RH2i3gpGT4p2bq+WwQ0+AYx55irP8D/WhTa48etCjYAt3qZol6c9C57Wne5KVQaBvkJE4A3ZfhtBU9q6hoC7OoZLsNjtZVnKJAjXmSmbE6DxlOqpUvHjir81I5FHYiEvHwSmoO6qfQMxqZtJjqf7Gj//EHTWJ/b27c3k9HDNuVtTPJBLldTmMawZcaBX/2OrG/nv63oI+zI4zZsbue1+UcOul5nftrVoc7lvQi8U2rC4G9TrZ1DEm1qcnEuAt1t
 R4nd/J6e
 BSlay4iriNTPq56qvmrBu4G9oyls6N2XvkO1lRv3oEdcVP4YHQEIWwxVbqdUIgSyOh/mQ+X5tYBCNcqE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [251024 05:09]:
> We declare vma_start_read() as a static function in mm/mmap_lock.c, so
> there is no need to provide a stub for !CONFIG_PER_VMA_LOCK.
> 
> __is_vma_write_locked() is declared in a header and should therefore be static
> inline.
> 
> Put parens around (refcnt & VMA_LOCK_OFFSET) in is_vma_writer_only() to make
> precedence clear.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  include/linux/mmap_lock.h | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 2c9fffa58714..e05da70dc0cb 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -130,7 +130,7 @@ static inline bool is_vma_writer_only(int refcnt)
>  	 * a detached vma happens only in vma_mark_detached() and is a rare
>  	 * case, therefore most of the time there will be no unnecessary wakeup.
>  	 */
> -	return refcnt & VMA_LOCK_OFFSET && refcnt <= VMA_LOCK_OFFSET + 1;
> +	return (refcnt & VMA_LOCK_OFFSET) && refcnt <= VMA_LOCK_OFFSET + 1;
>  }
>  
>  static inline void vma_refcount_put(struct vm_area_struct *vma)
> @@ -183,7 +183,7 @@ static inline void vma_end_read(struct vm_area_struct *vma)
>  }
>  
>  /* WARNING! Can only be used if mmap_lock is expected to be write-locked */
> -static bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_lock_seq)
> +static inline bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_lock_seq)
>  {
>  	mmap_assert_write_locked(vma->vm_mm);
>  
> @@ -281,9 +281,6 @@ static inline bool mmap_lock_speculate_retry(struct mm_struct *mm, unsigned int
>  	return true;
>  }
>  static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt) {}
> -static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
> -						    struct vm_area_struct *vma)
> -		{ return NULL; }
>  static inline void vma_end_read(struct vm_area_struct *vma) {}
>  static inline void vma_start_write(struct vm_area_struct *vma) {}
>  static inline void vma_assert_write_locked(struct vm_area_struct *vma)
> -- 
> 2.51.0
> 

