Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67D3CEE49BD
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 04:38:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9BCE6B009E; Tue, 30 Dec 2025 23:38:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C73A06B009F; Tue, 30 Dec 2025 23:38:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B21C66B00A0; Tue, 30 Dec 2025 23:38:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9AEBB6B009E
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 23:38:21 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5769D8B5DD
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 04:38:21 +0000 (UTC)
X-FDA: 84278509602.18.CA11555
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 276B08000B
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 04:38:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Nyj2xq77;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Xhq8saAL;
	spf=pass (imf30.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767155898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YrHOnT4E3pX8Db+j7NK8wz43JQPJ4+CvH9me2Nok87M=;
	b=aQD0EObMfjYOFti7G2ZRfELkQyaNuzNEf3ux0rpqzW14N8wPg7nTH1lqnR9tjjnoZ+aKew
	WTwvMUa/CCKjN80ksNZUJTzSxciqsuEyYfWFF0FiVNbftUTLT6Hv8K2RDwm8grd6L/bgyD
	AzN9lwaFA6oN21aXgG+jEjfsMtsYekU=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Nyj2xq77;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Xhq8saAL;
	spf=pass (imf30.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767155898; a=rsa-sha256;
	cv=pass;
	b=M8ULoeDk29t44Vu/CZJ9NrZe2L/eRkwHXd6Peh6IN6C8DEB5+uMKh2sNKi6yNFCI2EamzR
	q0NmU64qE2Qv1pOoGp5V2uuMuadO0GZJ+x3RKpoqfsp2HDNRPps+LmgtiNKuwcO1ikFPpy
	ScYmucnbtEt4wSaG1Ky8cFKidra07aI=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BV3RNvO1358975;
	Wed, 31 Dec 2025 04:37:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YrHOnT4E3pX8Db+j7NK8wz43JQPJ4+CvH9me2Nok87M=; b=
	Nyj2xq77/LUVI6+/WdLu0cQQRmse+u0vlarapZ4h+8WyU1i5nogAuEVpsmmjAX2x
	foXELSFLH0+xb3ZBd9Ipwcqhibdf6mDMpe3iirkEQ93a4mKD+COjFwSWjAzZ5MKT
	ma6ulbceVNO2hGI7Fo2zjzrUSVoThgK+7M64f5ByaVdwf81/uLs6CLYDukS/8Ooz
	R+WHcZrgRzkj2+BPvW1MaAKthLRtJvCegt1Cbre+j2zAg0ZuHV8G4O1dvyxjSSc2
	UXApO5+ivccrKL0/Uxtg/WEr3UHqOgyNVDR4EhjlsIUVk0M142L6askcTzxnx8gp
	tpT4pSYgcRmJiaNfd7aC5A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba680kb1a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Dec 2025 04:37:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BV2YUWm018165;
	Wed, 31 Dec 2025 04:37:49 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011021.outbound.protection.outlook.com [40.107.208.21])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5wca64b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Dec 2025 04:37:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZhXyODd8vlL11ccA1rddM8rwoJgSrvZYtkYTNDZRnuTlE8pTUGP83Yn71C80Ehpt/V4ICK1DPUDPyIgfG8W+Pfqx0tIBg+sDOa277N51IxJhmGW8qT3kIvyudXGizzIA2iEX+ZKHjTIj1+PPvkIqnAQu43RX5Kah/3nS6L3J9NhUIZj3aF3VeG43A+5Tb28kfsCn7hqM3foxfAVEyYRAtwpzPOO81180aZVCnse20SUscZvKhllpdnY77IuIfCF78ix8KLuQINoQAoqXNDbM2ScCeNPYnM0hKkHk7GvVZ0lGhBelCOJ+aP/yDDBHIsEO/GXr/M+oPtTR0kFul6w/PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YrHOnT4E3pX8Db+j7NK8wz43JQPJ4+CvH9me2Nok87M=;
 b=ig+uFLSzKZlNZaMBIi0ZLZ9sKjiW6fMhTpfRrfh6tk/UehXC5FpUoRI6wIf7xoHy7mEsvdPiVU1d/oFIMYneH7WyxQITeDZn19a2Yrc4PT9jPYJTgVwChbwbcsxXPcSEIpd4pRiJNXms4VvNylqrgr7v9w2bTfs2zzwtWRQLZgIHZYMMLYv3hc3behTJUVASTftGv1whYv3ulFAf3I50UqD/e81prLpTqV1ohrxwKoz8elG79WKI9bo/Wdt6h0nMM5Y4eCNidJgST/6KMEziC5mkqgA42+R3XlpD4evMywqKiWbFh4qpne8oyvz4FgSQDbZzIMJhTemhDyIGb7DWpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YrHOnT4E3pX8Db+j7NK8wz43JQPJ4+CvH9me2Nok87M=;
 b=Xhq8saALARhWgbu44Dch7cz7CigNnTL0k4/bRXI46208EA4wW9yiyLhle9tbenxjWs6WfQBsI0D3sKdN2ERuSaRZu3JNVUu3d95pKtvko1w3ft7LTedWFB/AVaYTQmcK4qlh65xW+/uLUIx7RTqYrRIi0JneWlcaSfjdDjVd+EE=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BLAPR10MB5106.namprd10.prod.outlook.com (2603:10b6:208:30c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Wed, 31 Dec
 2025 04:37:46 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9456.013; Wed, 31 Dec 2025
 04:37:45 +0000
Date: Wed, 31 Dec 2025 13:37:32 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com,
        ziy@nvidia.com, willy@infradead.org, nao.horiguchi@gmail.com,
        david@redhat.com, lorenzo.stoakes@oracle.com, william.roche@oracle.com,
        tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com,
        akpm@linux-foundation.org, osalvador@suse.de, muchun.song@linux.dev,
        rientjes@google.com, duenwen@google.com, jthoughton@google.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com
Subject: Re: [PATCH v2 2/3] mm/page_alloc: only free healthy pages in
 high-order HWPoison folio
Message-ID: <aVSojEWdFPsb1fg7@hyeyoo>
References: <20251219183346.3627510-1-jiaqiyan@google.com>
 <20251219183346.3627510-3-jiaqiyan@google.com>
 <aUolGHkJQwKi0A8A@hyeyoo>
 <CACw3F52hZp+xC51bK=UfrfdAWdFEEqhsiJY2+0fzCLzB_3=XYg@mail.gmail.com>
 <aVHWOMa9n40_8Yu3@hyeyoo>
 <CACw3F53p9TyAZs2pn+aHo85=aZx0+unaoLjeFtEK8DJ8A5TD4A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACw3F53p9TyAZs2pn+aHo85=aZx0+unaoLjeFtEK8DJ8A5TD4A@mail.gmail.com>
X-ClientProxiedBy: SE2P216CA0161.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2cb::15) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BLAPR10MB5106:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f827ded-418e-46db-0503-08de48265805
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TkVxM2NHS014VUNkU0x6Sy85YU9JYzVKVXg2MzB0V3lKZk02d3Y2UGFnQmpk?=
 =?utf-8?B?L2xLdkFmaURwNWxDdkNHY2FtcWpCc0FHZjlZZDFPc1NXczdHWDMxMVZJMGV4?=
 =?utf-8?B?MEZMZndsN21zeUFOdUhlQ0c4eERRYXRlN2JvQXlTc2VVZDZlNGxrNjFuRHRo?=
 =?utf-8?B?aS9RMFNNdStwdnZBNldVSEEwR045QlZYTFlYcUNKYUdVQjhxTHZPTUVrZi9n?=
 =?utf-8?B?WC9DT00zdEkvUDVlSFEwNWRHaGFOVkk2V0pJbURtMHYvK1F6TmhDL2s2WGkr?=
 =?utf-8?B?aFdDQVJvczA0bmRkN2gwK3loRzJjRUNXU0xaYTM2dUJHQTJyNjVoMlNNM1I1?=
 =?utf-8?B?c1dKOXJ0QSs0b25HTVhicmJTN0xDYUxnUHNzODU3aDRsa3Z4amxBQ0tHV1Nv?=
 =?utf-8?B?akVSSm9MQXR4czNkV2NEUTRRODNSTVZTUldDc1JDTzM3K1JZcENyQ3NQQVhL?=
 =?utf-8?B?VzFGQ1VCY2VkdFlkZk1mYjZsK2lpdytQZFBnaUVFSGNNSlNJWlEvemd2MDA2?=
 =?utf-8?B?SGhxaEtjd3dvR29reVA0MUZEamlYVnVVc0t5UjdtQVE5bkRyTGZkNDUxV0Na?=
 =?utf-8?B?dHBBYWpZcURmRkh5a0JBQnJpUEkyQUhNajNNU0p3TlN5SldxRGduRlROcHdz?=
 =?utf-8?B?N2JoNlFTT1p6UW10K25hVEdGVkFKYlZoV2xQbWJucTRXUVh4TG1qZzlGd3pk?=
 =?utf-8?B?SW9aUHR4cU9La29Gb0luTFo3UC9iMHZnbElUZkd1QzFwNVQwSEpmRHNzSDA4?=
 =?utf-8?B?c25SQ0JUSlNRaWoxNWVRRFkvdVd1bUtBN3IxZEM1WGErb096OUlxdGw2RWY1?=
 =?utf-8?B?aXMyWnBPK1JZVXBPWkU3aUVMdW9naFErZXEzNkkzMS9vemdLTTV4cjlUSDBx?=
 =?utf-8?B?djNZZHlWNjMzaXk4QUNqb0EvMTlJd0wyOXhZME5qZVQ4TkdnR05PdElENVVu?=
 =?utf-8?B?NmV6OUNJODNTUDExWDFCOCt6c1phc0JramRSQUM3cG5XcDFOSHVVVE9aYmFw?=
 =?utf-8?B?Um9uSkNYcHlaaGZGOXRWVXRDdSthMHRDM2xjMEZweHZwSEJ3UTc2bFNPMDFG?=
 =?utf-8?B?NXhROFBpRUliSXZmVk90MUtZZ2g0Mm8ydU5BcVIyQm02WUhHMG9qNW5qMHdn?=
 =?utf-8?B?UFNrcjRlUXByTEd3dGluZUs2QlI2QWJNT1NGM0hyOEdRWXhSaXBlbkNnNW5x?=
 =?utf-8?B?NStERzVDOGRSYU8xRXJ4dllrc2RDeXlDdXM0MGVaZXlkVFhsdU5xdTJHZWN3?=
 =?utf-8?B?ZTRQL3d6cDlENHNCSi9VbXkzNDdhSFpodzRHYkpGOGxxOG8vekxMNFVnZWkz?=
 =?utf-8?B?eCt3RkF4WkhYUXZzdzZXZElBVGxaMmVDdk9va1YwWnVwUmd6WTBZYUdQbVZp?=
 =?utf-8?B?ZkFWdTVkT2wyUTRqTkQzcjFyZUFYRWo0Z1F5cHJRVVJyQ0JoM0JJM1BCRzU1?=
 =?utf-8?B?WWZWRDhsWi90U2RRVis4ZUhWTEVNWG8zaFBYMGdJVXFOaFBBOGtxdWsrUFd5?=
 =?utf-8?B?M1hCeHo2UjNXUlR1WmNyZlI5RTdUK2xlWHkveHRkeWc2N2JEcDg4V1B5M042?=
 =?utf-8?B?WUhmenEvVlo1b05ET1lzVXFCQU51WFk1cXlZaXV6YWs0NVV3blRKR04wMHNv?=
 =?utf-8?B?SDVDZlhzRFFYYUlQNzJVcUxUenZJU3k3V3lMOUduaXFHN004ckxLZEFiNkov?=
 =?utf-8?B?ZS9Tb0puczlNVEtmRENkU1RpamZEd2ZWaWI4RGdoT3NPT2FkbmUwYlA1c1Rv?=
 =?utf-8?B?VGZlVmlLQjJQY3RqeWpONmRoUTZxYnNRK1BiSEdIYUR4bjNpTjZsaHlkNlpt?=
 =?utf-8?B?d25KeUMrMGdHVGg4eTJyNFc3NmMzalJmNndnMTZpeHo0NmtJMUVGbWI1VW5U?=
 =?utf-8?B?U1d6Rmg5dC9sYWhtdXZJTUZJbjE3aTJISUxNdENHSmJzQUdiclh5Nk9rcHZI?=
 =?utf-8?Q?q6HrsqWFPotyfjhFLD5E/TxPgK9R/oQH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OEpoMnpWQy9CQUEvVGFyZ0Vpd1ZQRDNidHBjNFkzdEZDWHFGaDRCZmJ5a2cv?=
 =?utf-8?B?S01lRTAxWHc0emw1ZDg0TVhNK0JYQkp3ZklCQVpzWjRIdGZod0t6dWt0SVNi?=
 =?utf-8?B?SDlUeHVVRXZaZ1Rhc3hybVpWRlYwMUFRbHViTXBnZ2pFZ0JRbUQ5ZUJXMUt0?=
 =?utf-8?B?UlRUMVY1VmNOVG1FMWhlS3pXVUdXQ2NNTllvaHpaVFM5eHNyR1FaRUlEdVhC?=
 =?utf-8?B?cVpOOW96Yk82M2xyODZNY05paG00Q2psY0JqblFwalZiekdzOUpYNnhPbUJI?=
 =?utf-8?B?UXRkUXc0bHQvcTQ2Y05ONTBQQ2JnaWJMQXZwOHkyNmQxWWVib2tXQ09Vc3M4?=
 =?utf-8?B?OHJRYm9XdEN3WGFaSnlqVDZ2cmZ5OHVjYVBueml2eG13TTN3UGtZemI0MzZv?=
 =?utf-8?B?RVZtTUxhelNUWWQ4VHhINUM0Z3ZacU9iMjZmdnNMbTVHZDFLb2ZQTnhSUUxX?=
 =?utf-8?B?bW5jY0hWTzhWNUJMaHRtMTl4NVJtWTQ0L2xRVEMrNmRjWGNEcmdtWDJBMWph?=
 =?utf-8?B?Wnh2dG1sYmRxbWhTdmRVSFVTYUU3Q3R6dlF1YVpSL3FndzgranZFMEFSUW9Y?=
 =?utf-8?B?TWRDVjM5Z29lR1VhcHB3V0dWcnhGdkxKZGVDaG1VcUVxUzhaZVUrRjJETCs2?=
 =?utf-8?B?YktuNkpqbmM3ZFRMSC9VTHVKazJlZTBjbUlORXN3NVNVc21PVnJrcnJHR0Nw?=
 =?utf-8?B?dUtIYjJrblJDTUR4cUJpTXdLSExBTys4dndIcDliNGJGZzczbXY3eVJ3NXJt?=
 =?utf-8?B?RCswUHcvT2NDbE44TEFjZHQ5TDZESW1XRkVMZG5PMFRDU2xaZlpGdzBNTEpK?=
 =?utf-8?B?SUhmWXIxV3NkaklWRVJqYkJ6bHR3T3V2UlV4RUFhY01xVTN5OHdiRnNaVEhD?=
 =?utf-8?B?SWUrbTBPbXRHUlA0cCszdVlKYUhjalJxK0lVbDZiWVh3dGZhcGV2R0xNY3F1?=
 =?utf-8?B?emRsY0xTWHlOckVnTTRaM25HTGR5K2Nlbm1OUE5oYVpJMDZ0S0RER0d6MHBB?=
 =?utf-8?B?QVh1QjRGcmJzM0FvUVRLZHRXWTZNL3FaNHU4c1FrSEYzZjF1UjR2R0JWS0pQ?=
 =?utf-8?B?ZmdnaFdYTGFDeGNhS1pUdFkzRnExQTBha0VudlFZSkJGV1QzMGg2ZHFwcjUv?=
 =?utf-8?B?cmp3V2hBMVM4QUJHaXJtZWVHNy9MTk43M2lTUTZsN0w1aEExa3hTWk5XN2RW?=
 =?utf-8?B?c3N6VlVqazB0NXBhV3hlNjFBVGU0R0ZqTTA2cm5YUzNuSS91WVF5citUUGdo?=
 =?utf-8?B?YWxUdTBrY1FFL2NzRnRRdlkzVGd3M1JXSFVzZlBoSzFlVENWam5BUE5GaFlq?=
 =?utf-8?B?RzRLN0xoSVpTY3NRanJnUHVSSUl2YWFmV3pMZFk3MW1PZkh5bFNUREprZkR6?=
 =?utf-8?B?czB5bzNCeE1ocUdRanVmODVsaHhzRzVUUkxoeDZpVVh5c0ovQVhCeTBkcy9t?=
 =?utf-8?B?ZzdqY1R4NWNDVnJkSHJXRVdHeDNxRTNxejg2eGlRSGJpNmt5OFkxOFNlcGxa?=
 =?utf-8?B?TExmc25FdmhkcGR6YXpCcW1pQllnamRSeklOTDlEY215UmNocmZZUUJzYkJn?=
 =?utf-8?B?WDZvS2d4ZkhHT0N4SkcwaHMyQ0EyL2FnalByZC9tZTMxQ0YvRGs2UVFRTjND?=
 =?utf-8?B?UDFsUk11dlNKVDRJSHpVUy9mZFNkNnc3VGdIR2xYb3h2Y1V5cFlIZnY4VXVm?=
 =?utf-8?B?c1dqaXREYmJWSkQ4MmQzb2lkZHUwM3NUMVJHWTY4Tzl6VXhxa0JCUUY5V25B?=
 =?utf-8?B?cEtScFdkREJtTmh2VzdjVVJ2R0JzUWZnT0NxODRRZ3FRNkRqUUZSMWRVUVBB?=
 =?utf-8?B?dmZkd0FCSTU0Qm5DbHlHV0Jtc0NoYXpOcnYzSkppT29aK0JqOE9uUlh2YkZZ?=
 =?utf-8?B?ZTNqQ1Z0emt3UVFlS29DWk1MZkQ2eWdVbzhhQzIvNzQyTW52NlRad1dmVXBs?=
 =?utf-8?B?Y1JPaHRvV2RvdG9oN1JqMXVMWDVDOVgxTllpNGU1dFhWQlRYQmpxam10RWov?=
 =?utf-8?B?RnBKUUo0SWFTaVFDMUlWRWtGR2FkTUh4ekVwd3JFaU9CTGg5QzE4UlNnSDhM?=
 =?utf-8?B?MlhTeDU3OGNBeXRQNnZYZHZiQU53UUQyQk9ac0JUMXBsN3Z2NGE3QktiZkFj?=
 =?utf-8?B?WVNBU2NHMGxHL09Xd1U5MmdEdGNjUmhLalNkbnVzMEhKN2JrdUZaTU9ZNXRS?=
 =?utf-8?B?enFpU2JmanRoL0ZKNzNFbm5uTHUrcjFsMXpCakQ3VHVUTmEvaVhWOGxBc2tL?=
 =?utf-8?B?NGhTRlc3VytTcnF2ZTQ5RnBubXdHR3huWG14SHFSWmVTUWd4Vmp2Z2RpYWs3?=
 =?utf-8?B?MjltT0VaRlYveEtIcDFPeFlOV2RNSWFCa3NxUXJJUkVQVlBhNkNJZz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	F6RqAUdS9ityzjBoTKgbs+/u4dVSeZFGvVssAHGidpswFEvfoapu5dI4gLw6KxFQptvd9wCkPt5yJ7NS4kiy1h7/DVZURz6fHd5g51U0KAxcSvsVC585d80/WGg2FSBDCwXrDZaAKgyZd3VlQvP91sA59nGr3Zwzvev4phz1bGH/lm/i+1FeahwyBhjVTk5MMR9Udawr/qYdTYjZ7Ou2yxLGuTO5mzm7mRTpz9ld6RPzPKkv7ldXUfrAo4uO/8hPjsnt9GA6zvnBbpc67oWPTS5xSAWAhzjiZtZtyVW9+5/mmJW3P4KwzxoMXGxjEqPPqtr0zgUn9cIyzw6Wd6FauPNTkpR+5fwZIN34nhhJVbjbtjsf/71iqLKlVMIOkAVPUzx76DkN4mxRnoDB74a3fopFW3CFOC7Q7yroHZXAtlx2glfBSdPim5f34jFzDGPrwmbuK7qxkqpcSURPyL0Oio7nhG7pUp6flzFrBpAwXKIdkmmtNWzvwTdY2f/H+IIVb4EYOm8oJy0Ld27GtT4wbgl3myiVgfYLFOr5Wx8X+xPLMXyVmU9jYg66nt1qQoyYOVGhS4lKX+nGv1dM8Jl+b9Sqjs0T2qEN4Gcgq47utqE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f827ded-418e-46db-0503-08de48265805
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2025 04:37:45.7726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RZ2Je0hghy1qg0HiFYgW4Wi8zyui39LdwS0b7PlLQMJsfAIGKPAJgZbhyktjn6yLAunjfLooYV3NLzNzACkFnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5106
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-31_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2512310037
X-Proofpoint-ORIG-GUID: pGaqQMst-mdoILpxBxP6so5jCIJ5-6rc
X-Proofpoint-GUID: pGaqQMst-mdoILpxBxP6so5jCIJ5-6rc
X-Authority-Analysis: v=2.4 cv=HPLO14tv c=1 sm=1 tr=0 ts=6954a89d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=YOWgNTBo5pOilgfUn9cA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12109
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMxMDAzNyBTYWx0ZWRfX04wO7AZ8N1Ns
 vMCD924wJURdvjfWXEM4BKwJSsW2KR0tat3qni0DhI6PPJXmILAzJIUaJ/oSPmfQewLMudhKJ+V
 LfVkTcarDkgCFwwu40guBGSrPLxad0MKKHumt8qxFYRSPQPuiT6vFXnfZGMcKilYmY2HsFxeTsf
 1c1VC/fVHW2D/WyHrvgAiaOS0rAZF67JlKH2r7UbRRw2y7yXwWI8kPpqaSqDDTzI0xARPgUlAnF
 PBsHeUCIPHhEA/hALpZD9NkdZ/UNEhNqSBLezr+oauD3kif/chaAm0N2yAes7jocogYGg65QbFN
 j8QUT8C3IjNwlHQf4/B3TXpfR6ZhIHPkyvY/qP7za5ABKfcKO6sDiWCRPsOvEaFOjPx+kgd6Ds3
 KM2BQdLwwSKgQmY04Qjz+MBC0qKI0IyDaik386A+X9qiKO4SllomZEqiRV//W0SjE/s9QpDP5xI
 69qdsdiqImcAganSS2AshaedTKfy25OTO9g8aKRU=
X-Stat-Signature: an8kioe9x14uogb8howmnx9xrmoe91x9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 276B08000B
X-HE-Tag: 1767155897-849156
X-HE-Meta: U2FsdGVkX19vUDVxSq3Om7QxwBnfDVNmIM1r5QTQT2g382IRMkCvhrzP5Q9UdbKuI9CSVcCrOHpgbvvGeS22HLybgAtGQRdRIXeNa2IrFdddW9Fs6TbNEEQ1XnUW9blD2LB0PjM2V8IBS1bz/YQWnwuVM3j9LxzPdGTCmAKpPTdLKdg4B/O4acna2RA6p/L9LDRBgmLxiCRbEA9IXFWbSBl1LEjjibNHFNWkiGXx6zQ2cLbSfkVBuaEGoVxHeqFrC2lufCyhdIJoTJN7kn2NIArsD6nsEJQMwN07E95k6EUrrPTE7iavFk4b+Y/NlvAGNs48wcxSrq1IhBDLve++2ID4Xiw/R8+exgqxpqVpRqXFm0H5FES+s/3FjPY9JJI+7KKTWKtp6+mGBbWOr43E5+IgKyhD4+vok3bMn+5pa5Js/qMhS5mPcrB0B14VPQsHxH0qLX0IdaZDA4jCO1HcRYeT/Jiv9RiHHaUQucFccJcyddYZvPd2yoaJOGu1rU0XRRoeVbGFSlbst16zMkYsofY6tCn/HMfEw+NIawFLK7gElLZTZ/Gbkaoue0YExmG1e1qbVu5gMFxHjlXrBiIWvaNQ+5dgkWME8EKMSnbMlI0ps34bRPOgO0NRkhz5xhKy7NnVY/4EHXSTy3nlbHt6MwqgHKJrOOy43RMsYSP/pQcVvzrX0mBLL6hUoCF9jV5+hBT5y+rDB8j1oDlXc+G1e/InDIhC77/uUZXehuDybn80fHXVtRqXuuLDGGLzLwtiGebfT4OvS/x0n+gHgCWgig+JCCyd0gURmPpUbXRTPoVBkBPWtI54+V9yQXdKikphvzCUoiZmTX3xwDZSIkJYEAPoUCHFH8alciOkkytUotZdGuu5qo6PTicG1iZ41IisGs+8HMAd+YF2XjMnskoGJsKaCau6sPHaQ/9D3sVNnDSXxZ6VQCl08kcK3OcZLMJo/OzRSj7oKuSi/Mehyao
 LgrBS35i
 d7sGbVsDh3F1mwAMIlynL3pSjVGd6jX5pWCXAF8NrQ2E+u/eg5hvnKQ1MIWaF4+qqFZDL5ApqDeDOehbYg1cYkGckyCtENnfAi/VSualP5w2A6kU1oYz1tyoQXwNCLWCtkxmCMQvqtP9UzWlUDeT1DNf2x2GvIq6wROe7RFRgP+ktGL+jn2+DOZrNYnnysV59/KXOUVUs6KXNB3w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 04:19:50PM -0800, Jiaqi Yan wrote:
> On Sun, Dec 28, 2025 at 5:15 PM Harry Yoo <harry.yoo@oracle.com> wrote:
> > On Fri, Dec 26, 2025 at 05:50:59PM -0800, Jiaqi Yan wrote:
> > > On Mon, Dec 22, 2025 at 9:14 PM Harry Yoo <harry.yoo@oracle.com> wrote:
> > > > On Fri, Dec 19, 2025 at 06:33:45PM +0000, Jiaqi Yan wrote:
> > > > > ---
> > > > >  mm/page_alloc.c | 101 ++++++++++++++++++++++++++++++++++++++++++++++++
> > > > >  1 file changed, 101 insertions(+)
> > > > >
> > > > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > > > index 822e05f1a9646..20c8862ce594e 100644
> > > > > --- a/mm/page_alloc.c
> > > > > +++ b/mm/page_alloc.c
> > > > > +/*
> > > > > + * Given a high-order compound page containing certain number of HWPoison
> > > > > + * pages, free only the healthy ones to buddy allocator.
> > > > > + *
> > > > > + * It calls __free_frozen_pages O(2^order) times and cause nontrivial
> > > > > + * overhead. So only use this when compound page really contains HWPoison.
> > > > > + *
> > > > > + * This implementation doesn't work in memdesc world.
> > > > > + */
> > > > > +static void free_has_hwpoison_pages(struct page *page, unsigned int order)
> > > > > +{
> > > > > +     struct page *curr = page;
> > > > > +     struct page *end = page + (1 << order);
> > > > > +     struct page *next;
> > > > > +     unsigned long flags = page->flags.f;
> > > > > +     unsigned long nr_pages;
> > > > > +     unsigned long total_freed = 0;
> > > > > +     unsigned long total_hwp = 0;
> > > > > +
> > > > > +     VM_WARN_ON(flags & PAGE_FLAGS_CHECK_AT_FREE);
> > > > > +
> > > > > +     while (curr < end) {
> > > > > +             next = curr;
> > > > > +             nr_pages = 0;
> > > > > +
> > > > > +             while (next < end && !PageHWPoison(next)) {
> > > > > +                     ++next;
> > > > > +                     ++nr_pages;
> > > > > +             }
> > > > > +
> > > > > +             if (PageHWPoison(next))
> > > > > +                     ++total_hwp;
> > > > > +
> > > > > +             free_contiguous_pages(curr, next, flags);
> > > >
> > > > page_owner, memory profiling (anything else?) will be confused
> > > > because it was allocated as a larger size, but we're freeing only
> > > > some portion of it.
> > >
> > > I am not sure, but looking at __split_unmapped_folio, it calls
> > > pgalloc_tag_split(folio, old_order, split_order) when splitting an
> > > old_order-order folio into a new split_order.
> > >
> > > Maybe prepare_compound_page_to_free really should
> > > update_page_tag_ref(), I need to take a closer look at this with
> > > CONFIG_MEM_ALLOC_PROFILING (not something I usually enable).
> > >
> > > > Perhaps we need to run some portion of this code snippet
> > > > (from free_pages_prepare()), before freeing portions of it:
> > > >
> > > >         page_cpupid_reset_last(page);
> > > >         page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> > > >         reset_page_owner(page, order);
> > > >         page_table_check_free(page, order);
> > > >         pgalloc_tag_sub(page, 1 << order);
> > >
> > > Since they come from free_pages_prepare, I believe these lines are
> > > already executed via free_contiguous_pages()=> __free_frozen_pages()=>
> > > free_pages_prepare(), right? Or am I missing something?
> >
> > But they're called with order that is smaller than the original order.
> > That's could be problematic; for example, memory profiling stores metadata
> > only on the first page. If you pass anything other than the first page
> > to free_pages_prepare(), it will not recognize that metadata was stored
> > during allocation.
> >
> 
> Right, with MEM_ALLOC_PROFILING enabled, I ran into the following
> WARNING when freeing all blocks except the 1st one (which contains the
> original head page):
> 
> [ 2101.713669] ------------[ cut here ]------------
> [ 2101.713670] alloc_tag was not set
> [ 2101.713671] WARNING: ./include/linux/alloc_tag.h:164 at
> __pgalloc_tag_sub+0xdf/0x160, CPU#18: hugetlb-mfr-3pa/33675
> [ 2101.713693] CPU: 18 UID: 0 PID: 33675 Comm: hugetlb-mfr-3pa
> Tainted: G S W O 6.19.0-smp-DEV #2 NONE
> [ 2101.713698] Tainted: [S]=CPU_OUT_OF_SPEC, [W]=WARN, [O]=OOT_MODULE
> [ 2101.713702] RIP: 0010:__pgalloc_tag_sub+0xdf/0x160
> ...
> [ 2101.713723] Call Trace:
> [ 2101.713725] <TASK>
> [ 2101.713727] free_has_hwpoison_pages+0xbc/0x370
> [ 2101.713731] free_frozen_pages+0xb3/0x100
> [ 2101.713733] __folio_put+0xd5/0x100
> [ 2101.713739] dissolve_free_hugetlb_folio+0x17f/0x1a0
> [ 2101.713743] filemap_offline_hwpoison_folio+0x193/0x4c0
> [ 2101.713747] ? __pfx_workingset_update_node+0x10/0x10
> [ 2101.713751] remove_inode_hugepages+0x209/0x690
> [ 2101.713757] ? on_each_cpu_cond_mask+0x1a/0x20
> [ 2101.713760] ? __cond_resched+0x23/0x60
> [ 2101.713768] ? n_tty_write+0x4c7/0x500
> [ 2101.713773] hugetlbfs_setattr+0x127/0x170
> [ 2101.713776] notify_change+0x32e/0x390
> [ 2101.713781] do_ftruncate+0x12c/0x1a0
> [ 2101.713786] __x64_sys_ftruncate+0x3e/0x70
> [ 2101.713789] do_syscall_64+0x6f/0x890
> [ 2101.713792] entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [ 2101.713811] </TASK>
> [ 2101.713812] ---[ end trace 0000000000000000 ]---
> 
> This is because in free_pages_prepare(), pgalloc_tag_sub() found there
> is no alloc tag on the compound page being freeing.
> 
> > In general, I think they're not designed to handle cases where
> > the allocation order and the free order differ (unless we split
> > metadata like __split_unmapped_folio() does).
> 
> I believe the proper way to fix this is to do something similar to
> pgalloc_tag_split(), used by __split_unmapped_folio().

Yeah, that will work.

The difference is that pgalloc_tag_split(), split_page_owner(), and
split_page_memcg() only support splitting the whole page into many (> 1)
smaller pieces, but we're trying to create only one smaller page from the
original page.

> When we split a
> new block from the original folio, we create a compound page from the
> block (just the way prep_compound_page_to_free does) and link the
> alloc tag of the original head page to the head of the new compound
> page.
>
> Something like copy_alloc_tag (to be added in v3) below to demo
> my idea, assuming tag=pgalloc_tag_get(original head page):
> 
> +/*
> + * Point page's alloc tag to an existing one.
> + */
> +static void copy_alloc_tag(struct page *page, struct alloc_tag *tag)

This should be defined in lib/alloc_tag.c

> +{
> +       union pgtag_ref_handle handle;
> +       union codetag_ref ref;
> +       unsigned long pfn = page_to_pfn(page);
> +
> +       if (!mem_alloc_profiling_enabled())
> +               return;
> +
> +       /* tag is NULL if HugeTLB page is allocated in boot process. */
> +       if (!tag)
> +               return;
> +
> +       if (!get_page_tag_ref(page, &ref, &handle))
> +               return;
> +
> +       /* Avoid overriding existing alloc tag from page. */
> +       if (!ref.ct || is_codetag_empty(&ref)) {

Is it an error if the page already has a valid tag?

> +               alloc_tag_ref_set(&ref, tag);
> +               update_page_tag_ref(handle, &ref);
> +       }
> +       put_page_tag_ref(handle);
> +}
> +
> +static void prep_compound_page_to_free(struct page *head, unsigned int order,
> +                                      unsigned long flags, struct
> alloc_tag *tag)
> +{
> +       head->flags.f = flags & (~PAGE_FLAGS_CHECK_AT_FREE);
> +       head->mapping = NULL;
> +       head->private = 0;
> +
> +       clear_compound_head(head);
> +       if (order)
> +               prep_compound_page(head, order);
> +
> +       copy_alloc_tag(head, tag);

Do we need a similar thing for memcg? Probably not, since it should have
been uncharged before freeing (as long as we're not using it for kmem pages)
Perhaps a comment on why we don't need to split memcg will be enough.

Do we need a similar thing for page_owner? I think yes, although it won't
crash or cause a warning, it will be inconsistent if we split page_owner in
split_page()/__split_unmapped_folio()/etc but not in
prep_compound_page_to_free(). 

> +}
> 
> I tested now the WARNING from include/linux/alloc_tag.h:164 is gone
> for both 2M and 1G pages. BTW we also need to copy_alloc_tag() for
> HWPoison pages before pgalloc_tag_sub().
> 
> > > > > +             total_freed += nr_pages;
> > > > > +             curr = PageHWPoison(next) ? next + 1 : next;
> > > > > +     }
> > > > > +
> > > > > +     pr_info("Excluded %lu hwpoison pages from folio\n", total_hwp);
> > > > > +     pr_info("Freed %#lx pages from folio\n", total_freed);
> > > > > +}
> > > > > +
> > > > >  void free_frozen_pages(struct page *page, unsigned int order)
> > > > >  {
> > > > > +     struct folio *folio = page_folio(page);
> > > > > +
> > > > > +     if (order > 0 && unlikely(folio_test_has_hwpoisoned(folio))) {
> > > > > +             folio_clear_has_hwpoisoned(folio);
> > > > > +             free_has_hwpoison_pages(page, order);
> > > > > +             return;
> > > > > +     }
> > > > > +
> > > >
> > > > It feels like it's a bit random place to do has_hwpoisoned check.
> > > > Can we move this to free_pages_prepare() where we have some
> > > > sanity checks (and also order-0 hwpoison page handling)?
> > >
> > > While free_pages_prepare() seems to be a better place to do the
> > > has_hwpoisoned check, it is not a good place to do
> > > free_has_hwpoison_pages().
> >
> > Why is it not a good place for free_has_hwpoison_pages()?
> >
> > Callers of free_pages_prepare() are supposed to avoid freeing it back to
> > the buddy or using the page when it returns false.
> 
> What I mean is, callers of free_pages_prepare() wouldn't know from the
> single false return value whether 1) they should completely bail out
> or 2) they should retry with free_has_hwpoison_pages.

I was thinking that once free_pages_prepare() returns false, it already
has done all the work to isolate HWPoison pages and freed healthy portions,
so the caller doesn't have to do anything and can bail out completely.

> So for now I
> think it'd better that free_frozen_pages does the check and act upon
> the check result. Not sure if there is a better place, or worthy to
> change free_pages_prepare()'s return type?
> 
> > ...except compaction_free(), which I don't have much idea what it's
> > doing.
> >
> > > > >       __free_frozen_pages(page, order, FPI_NONE);
> > > > >  }

-- 
Cheers,
Harry / Hyeonggon

