Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08CFCC56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 19:48:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D57FD6B0095; Thu,  6 Aug 2026 15:48:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2FA56B009B; Thu,  6 Aug 2026 15:48:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD87F6B009D; Thu,  6 Aug 2026 15:48:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91F2C6B0095
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:48:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19BD3C01FB
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:48:32 +0000 (UTC)
X-FDA: 85071881664.02.D8A0B99
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 79F2340004
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:48:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L8QWTdPt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="MPg0/gwW";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786045708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jeaBuhZDTej6ltJJ29Que+EMDm5jpmBSJBZE872aYw8=;
	b=QvgstOgE5V+akEm6EsIIDvG0XFGspTmXfliOIiF0jUOk1+5GSCLrFCoJH+YtZ0Hv3nU/dn
	ufUf5Tn9Ahm6CGBK7ByyQVLGkFRc+pcfy2PPSJLrkunuV7Xbjy1jolYMLvzkS+wL5KZtLD
	wNi8td0yl1f4Z0Ueu6JSbuFtq7H1WfY=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L8QWTdPt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="MPg0/gwW";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786045708;
	b=oLhdRvQeYOSDte6SfbYB5NxhBEWBlpFh9E1P3Ilrz0aK8CyJyoEcYNVQHXvi6JViqHEeLx
	0BSHZv3rRqSF3wZASG2hgcI3D42sF1J5RwwuDl8ei7oEw6ilmkKmQ/HFlQh4Pb4rNmoyTf
	Q0bLT2fym5mmS2oqrKbM1HNFuF8jD08=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676FtjpE3283031;
	Thu, 6 Aug 2026 19:48:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jeaBuhZDTej6ltJJ29Que+EMDm5jpmBSJBZE872aYw8=; b=
	L8QWTdPt1j5rwJOR66tbChfkAqFAkXgNlEJ8sk6GAB8EQBw7+V2HALY305ahKARY
	p0ERAA66rL5T9zqH5XAfn+9GIxJ5a85ZutsZvjYY8HKp1k1956yd4szvhUtZVT2M
	TkFr9EBOH4+Fp7XD9rafOcnxy3jSOuJ2bTXqQkJ4SbDaQ4soWDGW9Rh+vOUUZcrp
	C4a5IO6IeuNddCzdhTtaPGYhua79EsMLXPg49Mx/GsYtCjwZHuYrriFOCqs6J7SG
	40xTUHqVgQjaXGocVUpKGDH2JJF3gPhMr7DsfsxUbw0JQ2Y1d9fLchPaJI6mh+ky
	yiuOmyrsioXs2dvpRPAZdQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs8p9ecbk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 19:48:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 676Jj9LD019743;
	Thu, 6 Aug 2026 19:48:06 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011012.outbound.protection.outlook.com [52.101.52.12])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ftq44qt5y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 06 Aug 2026 19:48:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jUMbQKWlp4rFqHPTUUdEoWgOaOdoKzn6gJ5xza77gjhZq2pnPMSBFJsHAgupT7ccXGK5qXNVsJT4aAICe9bh6wvEJN2QY6qfFXQp8AtByymHcXVManO2YwvP4d4y0ZlrBDa/A0p5Ua/d9DeO67ckg/ZlFqbSna5tWdK7pZYmtPJh67yFfaGqFKyIiiO+TwT2fapIyJhtFRD9LXisqG/z4S5cwnFW8etK5M5im0TF3a08DqiHgwzom/LUw9IxY47l31nHwVGXW0ekcU3YOCICY/Ytt57ipZBiHgHq7j1c0aY6DNIWbGuTLwa/XSkRaxNlKpNUK5gyBYH2Lahn55pTHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jeaBuhZDTej6ltJJ29Que+EMDm5jpmBSJBZE872aYw8=;
 b=BGOOZgYPi9kIgSokpbBfMapwnXsEcXCS7NvqASpqG5wBG8IFGIt51w7bMqWTOICIDVPvYzidyZdcjP43jXQkt5wpvgwT7+OPxaJZ9G5GgZhxMP+LuLBKpuTWWZDucXh3rqyGHnEispUnjLSaWk8Ehaf4Fn1P3ua++hbxbSJccN7FDBMT0Qe1n3RfH0e38md8CiB34TO+7M3YMCQFHoePeEKQW7doeS+DAMDSvuAWpeTLciAlyCBgPZMjhZQTpHK/y1RrnTLIrrk3EiDCcE64x/6e1WIiW+mMcEgSv2ZjItUkjn7EKS60hbshFiQnIQeNCloaG08WP9xwQM/jYfo6fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jeaBuhZDTej6ltJJ29Que+EMDm5jpmBSJBZE872aYw8=;
 b=MPg0/gwWmFal5JaTPCmOHbJN6Vv81OwbA4dOSR6/XDLTxVS0aKWb1aa4I2kqxaAPW27wPStVl/WBXl0ROojM+B3XRIVolMW3gSwa/VORMQjkbs9IAYI9g2e5hAqUXNX3mklWtTX9gciCecNTxsAxZzWOSNQwVHaNcS3oq0Xvyr8=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 MN6PR10MB8070.namprd10.prod.outlook.com (2603:10b6:208:4fd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.20; Thu, 6 Aug
 2026 19:48:03 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%5]) with mapi id 15.21.0292.019; Thu, 6 Aug 2026
 19:48:03 +0000
Message-ID: <cceec094-ab67-48ab-8dfb-2a800021ffb8@oracle.com>
Date: Thu, 6 Aug 2026 12:47:59 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/15] Use generic_file_read_iter() in hugetlbfs
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>,
        Jiaqi Yan <jiaqiyan@google.com>
References: <20260805210557.1118966-1-willy@infradead.org>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20260805210557.1118966-1-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0061.namprd07.prod.outlook.com
 (2603:10b6:510:f::6) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|MN6PR10MB8070:EE_
X-MS-Office365-Filtering-Correlation-Id: a7ba777d-9995-40fe-3eff-08def3f3a06a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	YoWyPqo8ob52buUrGwfK0K2/jflgecnVxpn3U0/DHaXTgxfSVXIqJ4x7k/Ikp4X8U1Rb4jbyssaGz7b8Sm82GwzGicN4t97yMrjdEFk5MZgnbEISK+iFT++fp15k93w5iLulpPigXEajo415sGXxtVQeTA4b7qbVF8SKmPci0mYdNBoNUEty2DJPhZlZRvhOsSE1/5j/hx+lfkQJUBXlsiiYZVvLv8Rn72sU9xSt6xBTRSTgpwdeX9HVpdjNHz7j+92KiPCXtoe+amldL2+srgNnc0JSDbOF7TXSaCUd6yi43hiaqZja8Bw2YMDZvBkCLW+6ckH6O7sFsmVuYKoHTYrjqJtnRMESwCZLymdv1n1jWzh+8oXn9iouqGp8HYr7hYhiTIpvawmV5A2WWOQRjPTTCO/WKVXaDqhkRq09zIni3Qkr7abxjjc+fmZDeONN0lz9i8vXLmjTHkj/o1HfDJFi+R93UDW5tgBNC8ZK4BI3SlY4WjBcY7dhsxIw4yzyTv5Ynbezwy1Qv07SKkyBJAQ7PFy4zI3hLnxHWT/2c+NI5ClKnRKH21syLgtihcXHdZH8GqCLq67ZC6Agdc5iN9ynICkIj0t7XIxlb3Qih1AE70KF+Gy9pavokKbMj4cu049abrNah7F8v/AnEpvSN6RZryiAZ+yTTjPIVkZ24RM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YnpzZU9rckZNcHptY3pURFhuL21oR2EyQk1wN3lDRTlWby9kQklFRlVUVktS?=
 =?utf-8?B?S2c5elhQaEVoazQ1NGZsMWFwSXpVZ0hVVERQTDQ2MFpjZExCdStUUzhPTUpw?=
 =?utf-8?B?T2VuMUR4V3daUnNpb3FyRnZMWldQM3Y3ZzFNNWxnVEMybkZldkdZd2Q2bjBO?=
 =?utf-8?B?U0RaNHFkbk9ZWHBXeGtmajJ1Z0xKd3ptblJ2SkZ1VGxpM1pGdks1a2dqU212?=
 =?utf-8?B?SjRkMk5zcmJpZEE5R1Urdk9aVWZBdHdjWlh0eUtxK3FLTW5Yc1RXY3prNTR3?=
 =?utf-8?B?azk1LzFxZ2RobHlTVE5rdGpNNDVoVk5rRVQwbFZqcnEySjNRb3RGSGZYbTV6?=
 =?utf-8?B?M1I3ZlNwV0tUTExrSGwzWjJrT0JsaGlrVzZ2cHFLTmFtdzEvZVN3SUlIWkNE?=
 =?utf-8?B?VGMwVzFHSVJINDV5ZThTZzZOeUlEQnhxMFcyNHV3TGJzazh2b0x1UUp6bStM?=
 =?utf-8?B?OFd5K2dHUlRQLzFDTXF1VStRN0ltK1R5dlpWTEpmbmNxOGpHbGRMMTg1ZVBa?=
 =?utf-8?B?S2hCbU1LZXdGcjR3bHd6V0lyYlkwNTlIK0MwTFVJekdwRGQ0eUFEcHJ2aVhP?=
 =?utf-8?B?T3pUcXVST1l2NnFyV3E5RWwzc2tnd01PWjlKdjJtaytSTUVWdDVzbzBLWjU2?=
 =?utf-8?B?VVpRdnZQUGJzRy90bmxibGxMU0NJVVFGaTVIMEd2S1VIekFEUDVPajVVbFQv?=
 =?utf-8?B?R3cyQ1F0d0Q0YVNhSFp6cXhTQ3JQUjNwajd5ZHE5T25WVmovWUUycDVKYytT?=
 =?utf-8?B?Wk9RYUxEMWUxL1hBWXJ4UWJpS1dqM0w5STJhWUxyTk9HZXNTLzNlbHVCZ3lm?=
 =?utf-8?B?T3ZxY3A5TUJjN2FDWnE2THBQWmRTdVlrVlV2b3IrckZRUTFiVmJpM1FzM2lU?=
 =?utf-8?B?czdtRy94V2kwUFJoOStiNGt4RThzR0ROY0ZkL2RYMWFTZXhDQkpFR2F6eXRN?=
 =?utf-8?B?SXBQMmNqWkNqQWQ4UnFRcjluUHhOWUpoKzJjTERrRCt4VWlPU01rcFEyeTk4?=
 =?utf-8?B?VHJhcmdieTBFWnNiczlKcmNRN09NYW9iYnR6MFlXdXdHNFVicHdCUjh1L3lj?=
 =?utf-8?B?djQ1aE5CQTlNa0xGSWJTOXErT2g3OTd0dkROVGt2bU9YWFFORFZ6d3Y1R0Uy?=
 =?utf-8?B?c3hOT0JhRThPZVhlRTVpMkc2SlZzUzVrVGEra2wzWTFIaTFNWHZZaDNQU0NB?=
 =?utf-8?B?c09JaHgydFJ1bzU1NUdxMVJOcG1TT2tPbUFpSTZoeG43NmRKSnF0TEJ1N2dP?=
 =?utf-8?B?cGdZQW83b0p0bHU2cHVSMGl5cjlaNy9ZcHoyejkyZjMyeVR4S2x0SnZzaHhn?=
 =?utf-8?B?ZU1oYnd5QW52TjIwL1g5LzFFV1h0d25Vd3R4NDdCZXQ1emJYUFgrRXhrT2J0?=
 =?utf-8?B?Y3gvR1RUbjNhMlg3cnpMam1Ka0grK0FkaUNVZ2lkMzR6NVJKWkRzbW5xWFJD?=
 =?utf-8?B?Y2xaVUxsMHNRNTNKOC8rK1gvcmFJK0ttdDBHVFZFQW54V0dSUnMrRmdsakFS?=
 =?utf-8?B?VGpHNEJKQzNhajBsRWRBRzdjd21XVzR2Z2tTR3FIbElmRUhmNVVsUk9vVUVx?=
 =?utf-8?B?NXR3eDhPeWxBSURxL04vRjdzNXNNcW9qL1lsT3haWkpJMXd0elJ3aVdIdDdF?=
 =?utf-8?B?SnpjNU9HQ0hpeE1acGx5Q1BiNW9UakhWQ3pKalpjMGRqLzdUSE5CdFI4OUtS?=
 =?utf-8?B?Zm9aSCtpUmJmRDRTcEhFTm94S05sckFTVWduYzh2S0hZWnJsMjJOOUx0UjRS?=
 =?utf-8?B?QWVWcDZBQWdWZkljdTlrVGJUUVpuMGY1djBqRFhZUm9hZFgzYVVINUs5UVlS?=
 =?utf-8?B?UUZoMGQxdWNpaGJ0UzZubng2eE5tcWwvVC83Vi9NbmFWOEVvVHd0WXViZmNW?=
 =?utf-8?B?cCtRUWpPYktURnorazlMblFnR0grU016YkhnZm1FMHhqQ055akVzWHR6TGFj?=
 =?utf-8?B?ZzVMV0o5eHQzUmxzVThkeWRTUFBKdnJsV0NQTHBxQUovNnV2MjNVNHp6NUpI?=
 =?utf-8?B?OUdtS0w1dXQ4U2JYbmxTdU1YVGpOc0JmWlUyY2lZMXV0cHJMcjRmTGNrRXFr?=
 =?utf-8?B?bVZwSkhDazFjQ1lUMHpsRXA1ZjNKOE03U0VtSHhtYzdHNkZ1QzB0bmVnRUYx?=
 =?utf-8?B?cGlLbFBZLzdUN2w2T2VnSnVwQS80WGcyd2VjY2ZTbVlXU0d1S2x4ejBxOWpC?=
 =?utf-8?B?YkNUM2VLN2JiUVFRNHZTTnFxVGxZS1NuM3JraEhSeFcvL1gzV25VK3F6VkRo?=
 =?utf-8?B?aWlWajZ5WG9YQnE3cnowNTZ5SERCWFRkY0ltTUU2SW0zbEpoQ1BGclllc1h0?=
 =?utf-8?B?Sk9nOVBBYzFWdTBRaG1SVUxYV2VyMU5GeHJtZFRBRTVUbm5kTXMydz09?=
X-Exchange-RoutingPolicyChecked:
	kAD017E8qi/NkxpreebWpYpWpWyUEhzQKNZ+vIMOhmsATXLAxcVMhQS4nU9UpMdZRUGX9PLF054DsycO54dyBJEMCrhWN6AJITQEBpUfQZragmtjQ6tCENRwBj+1uz79ikoXixonNKbUhyhvA3eDvA9egg+F2ZQF2bUkdP2JfICDYakzBxKJFB0P2AAaz90f/O1c6eJeIk+c5GKQXGcI3/yXiKaYkPTujjngCjfLWCwPKP0BVoA3E1eBhNmzCVUKb322oPkjQCF57lrjT6VWcdzNV8++UQLs7bYAInPR58VWTVQ9k/DN4RXvcr0lAbER5cG9mjRBD+p3SFf7CL74lQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YCzN3lNaTGI9OJEGPulC6KHguRqYNQt0/fXu7f28lcOPON5nZcRjVkctTrkERl/Puc3OPbD3UUu4i+RmFxOAO4S7q5WGd6ii9s0mRLLa9yoFhu5YLe5mbY/zfBFBj3X23y+r1oC9Asj9eSr9eoDxMhnR8YHMsb1PVXapEsiv6aUufHXd2C4t17aYSdWPpfX0ZyrelFei/1t5szJOvIqp285oB02H1n6JgyT7d6tlCMaPbL9/pNky2pWgoAdDwaFu6pkZQqgRGRA4LTJCPp4F8ED8LqWaA/1Oa4ElTCmryLiDV0KQFT0+Gy+RtYRRRJagix5AGz7xXYWjsqECI/YslMxLRGc5gfXlbjGVLZcnSWi451gSLjb5/qZjdK/ufyS8VaLhVQKacDDiHqPMIumHu1UkOqb7q6xp1whyrVYbmOwJL5AKw8VBPy0zcr13PmMtdr9t8beMEaahYDVbaFGYT2/hWA3ClOYnCi67WIka4FsFTlo8taAjqcLmO+YI9VZKQSsIV28uI8bnQsVTIsj+ciqWiryxMl36JkRdojTccR/Fai1d9yuHSagrGIRQyV0gOaSYOhMBFV9Oq7mYzd0cvxc3vNUZalAzvw9VKsobe5c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7ba777d-9995-40fe-3eff-08def3f3a06a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 19:48:02.9690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g181mYE5JY3GRU6O6ZETMlSHvZ8VM/IjxxtwOkYRVby99C5gaOGIvdN6JoXx5QvZf6/ua6V1zHqDNd+nwXtvpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-06_02,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608060154
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDE1NCBTYWx0ZWRfX+NTpavyQRYJU
 tYpwJN45PrIRuxbuNvuky6R3sqntFS8+jkjuUaNZIBCzIFVEudSJ4Z0TzvgENbDlVdlrOYM0YwD
 Zp2ETuJcPZWPIuJXyvFWJkaxH/j89xZp4KseZzdbIf3UBOcUi0Lh
X-Authority-Analysis: v=2.4 cv=EPU2FVZC c=1 sm=1 tr=0 ts=6a74e4f7 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=g9Uqu3yHaEC6rcbQtn8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: svL1OOYooxyvG-hmw6tX5yItne8Mevkv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDE1NCBTYWx0ZWRfXyeru2CEDVHlT
 K2NWzHxMt9NbjfE/1/ZzwJa33dZ1FUEmWbBxqGL0Atj4HlkncdKw7dt66+ZWT+w/B2L50t3QrTL
 B0tJ9kpbARNz6kdHU8+kYqB2gmLdscHhK54eaNHUyIekCtsbnZ7z+hgl0aZu9I4DYBRFTIQE3iR
 IxiAg5r1YEXGrZD2upKjPwzZ8fxOHoo3FL4eZIJ9SQmAc6JijB2aTueA3jhALg+as0BTIBwvhX/
 wv/EhVVAvnv2vqBK9A8cOAlKet/+WkNAZjmjzyikO+gTMIetEEq85hlNOYmg31eCDP78HYjWA+X
 axWU6vG6Td0a/fDhDeLZaT8HRdqr46NYTcZ3Ux/ZVx8EWxunVMOq42ALAtennrBWfowYOjSSrOn
 qdrBcHPgJa6pex/f3VFmILLI6XWIiY7kG6/pjmVI7qdOKJ/D5ZweVlw3RvY2/k4p3vCmZVRRicO
 xOUZ0bCfdwegbRvZApA==
X-Proofpoint-ORIG-GUID: svL1OOYooxyvG-hmw6tX5yItne8Mevkv
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 79F2340004
X-Stat-Signature: 8bczswsdqtru74rx98hdb3ks7t47wf7w
X-HE-Tag: 1786045708-21127
X-HE-Meta: U2FsdGVkX1+vNiTH7nY3pQvVZSNen90x3/9NUNwgepNkkaH3Zy2ZzY05YGKhYlVMMANFKKga/ByQaYwYRNewQvOzPCUY87Alg002dxLiUw42rRTjeCaxfV+c1GMhsiBncXBLw5OosxzJ+i4wo/2g/RzYK1BouKpLAQW+S9LYd8KUselOjeTSC8onwSQfqfN3GGljtjP0oPA0NrV5JlseUkujMkBxxCFLdQEf8XS2H3e6qi/U/S63OCoacQCG5p6lWH0TUhg/2oAJRxX/8aK6VB5XmFL7qAeIcY5Pl/csUzo32lLIgqYNgEvDIeJISz8wWUyMv1Q33M6sE5sxW6oz1NmtDV5wBaz+Top8Xck7LiuP2NAsU03Qh/+JL2AGVEFupnclNJo7YcDttFx2Hc8Sqgo3qRtw4xfsVMkodXu7EbRRbyOIp/37TCpTv7THYQpjBbZCJKkpNV3rrZNv6UwhYw0YTMaaZlfppRsi4+IZ7bYSL4pvUoT16bYYYy1E3OpzdKS6YRQUpeSn+lvAoTE2boKxy7aHLZTHdSF0Fc+Dc1IlfVzD7b3VWq/pdqmCkmkxitCMD2hZCX0CPq2D2/rBPGwRh+BZx1fLapmSfVzovoja3CH+8wjzgShFdcl1tHYeX0R11GMMnte9OY3olsrL49hAa+GvamqBoR55rfuBWTk4vBkJf3PCAT+LOOP4qs4xalwlpKJTMc4zwmuKy6MfQ3tkvOy33BDbq86eagW0ToLtCCVJrtcfOBWsIveSQT4zX0qINemVvjqOe3x3rvKly8Y9mEsvfCWpS3lRhfnTgeEqax33LWfPjM1bfT4nwSBn5R/5nn1iLqW47cIdckmIHKDnewCcLPPOxHXx0gLqJGsS6Tj0hTGUQXs+uLKzD8dXD13GIvUV41lCugnJWEU3f3k1zEmS20dTYr2hIghwP9AAKDnFpXrXqUFnCpnfQytkPC31qyWWKZzjZnxY2tC
 8yitKpdw
 kjoxYgwCCL/YtnnVk/j+CWIp4RIysRzhGFAdSON0DUdpXOlOb/srpy7WGagyVCQ+KUGCkoBoDz2ZH5V9AKHXkiOKk2FJiFFsBKKOKiHFf8dUQLtcWTYcp7dWbxiLXed92KCCy23uI2LxpYE7uCuP+OpX4GTbQp/89ab0nyv3OxqSFUQzskGiBVjyf2LnF2/zYn1ElUDJcISf2R3nSlNn/T16UtwVBmZIn/MtSkH+TuxAM5li7bR9/oXZ/5/uMoAn+6QN+FDcxXmD0sgp/PBQuuS7Rm4rRNU1mK6je66AcVIv39ql3bmd7IuV59B9VKTi4vfNRrFLH0komtJLFc34MUkXjDdnKxx5J398oL576NnAGG1/6mIJTOaFfxliVqrpgigC5TR0F0zq1OCdMpoOceH8D35XvS0Q3E1LINR4gVDHeI8vliaX+Klxxdyt8BKZ6qZWNAKMzTdJtY4tJFkcoA03alUTNd4dLZQz+8H80joMLmA4jci67fGCqlctqy+K6nViXbyJwGPQJSu5DiZ+/ylwYRyqdmlDi2JK38ksUPTMZyhqkQcDmc7uibwncVwkaI2EV1YYjZkUNMo9DAk25d1q6C8pX902zr++xUYQ7aok9XLNRdRsfsKHZpO1eY4/9zq56YT09b/XJYLEcC52BXlbXIYLlGaAqC8+2ULQdce+8dIpdNw4jfhEO75S0GijOCqp/Zu1XKDqi//Hgck7Nqgqk8ldhreOQRlZ3cV9qDVom1E45lKnlyB4SfMAl555jQX5A14V6iRVGLcjmFLFBD2Jqt2dq5tpdL10yJEIwcdyoWlU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Matthew,

On 8/5/2026 2:05 PM, Matthew Wilcox (Oracle) wrote:
> This set of patches are separated out from Jane's earlier series.
> https://lore.kernel.org/linux-mm/20260617172534.1740152-1-jane.chu@oracle.com/
> 
> We need three things to use filemap_read_iter() instead of a hugetlbfs
> specific read_iter: hwpoison handling, treating gaps in the pagecache as
> holes, and having hugetlb set the folio size in the mapping.  hwopison
> handling turned out to need a lot of prep work; the other two things
> are fairly straightforward.
> 
> Sashiko complains that the implementation of AS_AUTHORITATIVE is
> incomplete, but hugetlbfs doesn't use any of that functionality.
> We'll add it when we need it, either when hugetlbfs uses it, or when we
> convert shmem to use filemap.

I've run some tests (read over hole, hwpoison etc) for the series,
the results look good.

-thanks,
-jane



