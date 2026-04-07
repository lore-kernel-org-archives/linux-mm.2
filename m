Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68CBDFEEF49
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 14:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D0DB6B00A2; Tue,  7 Apr 2026 10:51:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A8BD6B00A3; Tue,  7 Apr 2026 10:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 898246B00A4; Tue,  7 Apr 2026 10:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77EAC6B00A2
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:51:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F53BE24DD
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:51:13 +0000 (UTC)
X-FDA: 84632047626.27.59A16CC
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012003.outbound.protection.outlook.com [52.101.53.3])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2DAE78000A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:51:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IThjdNN8;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775573470; a=rsa-sha256;
	cv=pass;
	b=MZfzvuc6Yn65gw/IvoV6PTDSnx2DQ/QcZxdF9xBC4p91Py6FnC25+GqivufsW0+UtY5oLw
	8KU+ry5bqjzlQNnId/wp6xu8dWIy0K2SssfsUp5KoOzI3RVaARlkRDuco6W/vN2TAMT9WR
	Tj6JgUOfikXOAZBPWlPzmF7OGj7szIg=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IThjdNN8;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775573470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F0Oieio6GrKJSwCt0O0ePM3iuRFR+oD/yvBYL85+i08=;
	b=3g14k0RQpYANMebsdVidCJPQQM+uH7B0LyBfD3+bj6eqpdpB0JtCQzrsDGXbnqcJJ4FX9v
	2p3yowlfGa1+v5WGDoUYuWOGQf95OZkYMMZ3XGsiHWGzo2FQhnii7JP51EkAfoKTJk2Ih+
	fwlDsqueOz+2IWNNZc/z+DzNkNFPa/o=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hOkl/44cF6A1VMbRXMvsS3g9POTr3Dgcpf5JNmsOTrhZxYa1xBzNJ3srsYB8d6iR6TqhqbOgW+gviDU1Aun9R0LAaUJpZA7I94P1yqaVPLy2EoTLF5kkdXZPkK7mPynhTl2lUD8NIMUMrINBa/ZDEUieaD814bze34WFrjQHFB5/2g3EejYbxHfX9EjcbVj8moPpIO8poEtJLhkFCkUVU+JwSebfZrIhyGDabzjX/YIniygsMw062j+erGzgZ/w3LsdUiraHdIqqKAkwWpXevpIj8aiwPNLARFEceBDRlV2pkqFPMjZ6hvOerkOLXjTc34npiYRzEC3a2HdLmy1bHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F0Oieio6GrKJSwCt0O0ePM3iuRFR+oD/yvBYL85+i08=;
 b=PhVeDKQwtku6HruQ+58a2EvsXc5OrjcFtQ2LZxMovx4LrxklXNd0usw9hV3Mpj1pYh9BXkqCURAOnAOn1I8jy3UZfCSwDngNMeyzIiht4KuLrOw2t1kIU//BMSj6OwjUlkqvqepCDgOluEn+QwuatUp3jbddTzZ0XAlZAtobzZHGqfzl8mI3IrSlgaSArOv83lyxeGkp9A5Bf37srF/OzCBfVf28/r1ZGlMv01p8Ilc6EjnCZswwE5bSgfKVMJxKJ9WaEWrKARiwg63ZWZrgvkFLWP4pIWFKs8X2OMpsx5XMzagtRGDsGyEPC8lG8Wbpqq4hNpUKUYMT68jbrvGG6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0Oieio6GrKJSwCt0O0ePM3iuRFR+oD/yvBYL85+i08=;
 b=IThjdNN81fRPok+Quuar+qRmNR0PvlYcP6gi/vGBqjV6Vtx0TynOxlj5UPsvlLy64TDZoL4svyRQLGbKT57CifiEC/J7TEKFltr0LuOhpjKclYRk+rrqslr8pl8w7ab0o5Z/EoyQD5PdcytuZo/qnbfAUkgy6xHxmckUd6asPbEAxRYGl1KedWlpA4UEL8I7oPp/Yd78s2Z1PwLD5n35w4y693ldxCPXGl4j1PclEPThozgEPDjfxw3mENjK6UozOEdaMTwe9O9oI9zdjrKGH4b3DNWmFZbhd2Xewi4tFBvutov3r82LfJ4hfjO2cf5xK9Gr5ivWPgsrRKngMbtDpg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB999254.namprd12.prod.outlook.com (2603:10b6:806:4dd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Tue, 7 Apr
 2026 14:51:04 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Tue, 7 Apr 2026
 14:51:04 +0000
From: Zi Yan <ziy@nvidia.com>
To: Sayali Patil <sayalip@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org,
 Miaohe Lin <linmiaohe@huawei.com>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: Re: [PATCH v4 13/15] selftests/mm: move hwpoison setup into
 run_test() and silence modprobe output for memory-failure category
Date: Tue, 07 Apr 2026 10:51:01 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <8B26C697-4D0C-4E1E-A14E-D517CC9DA05A@nvidia.com>
In-Reply-To: <8ef8640092004d143fe80e6fc32ea8d30a9080de.1775466330.git.sayalip@linux.ibm.com>
References: <cover.1775466329.git.sayalip@linux.ibm.com>
 <8ef8640092004d143fe80e6fc32ea8d30a9080de.1775466330.git.sayalip@linux.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB999254:EE_
X-MS-Office365-Filtering-Correlation-Id: fe54ac7a-01be-433e-c5a5-08de94b517cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	NrrnE3Iw7Lm2PperBg6ILWZ7fN0g05MpVQO+6nDemxBxu04wi7h2/gqCM11EgvP8CYFjjRS8RjjH5A2SFHEBPUvrECwPEloLTBrUi/qMKUe8/GLVZhPm5uEX6LgM8vTn1ScoM9dfAtwj43ShfxT+KrloGNuPSdFD4L+NF6tAZ1RJHbFUoSgQUh/4qg/cSWFj8hKhQoGLR4mv0q02a1rEYqGAMk913FApxt2Fe7dHwg1DC34TQwzlVFi0Bw9Z2fFiSFoTUbggUR7p8YIwPblP4AJlwMIJWrnop0VjhrX19hEohQUQ+xbhO7XazLCqMKdcnXXoKmYae292jIINsfRe5nrvANqvbxZ8ufMRMsh+BxhbsQuKbp4gEKpERTC17FtFGv8lCF25C5V889dR8oPWf++o3MpGt6+IUw4XYWOWxRjPlfSii5oG5Eopo5u5iDWL0/wkq6VsqFH3Q08kv/jH1GWOnSmtsmR6/cr/8IuWm7g8gqE4NW0lYPYBiIMRgQqq1PQRrqwjeGFgYe7b5cRet15YczNd8Q9244ThNvZsxqyUtRZeua/PMa3PX4lS5SY3Jtz1NFL3I0xlpwL1tq70Hrqs92UH01t4xkfNfNUHKHFsa7j0d8A0DpY/grSVgoDqGZr7g9gcnPaXsy48ovnZSoRTMq63jgqnxwMsfV0+pM3ULaocHMQ9FYX3PWJ9eP8XVk5nlikbwjBOemCInnU5z0dkaiRLez93/6/cSK1Klvs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ye6kOQD8x26xv7rXz0DQBOqDfE57gox8DPOTfmIOgHrZ97i95xehluhhEVyL?=
 =?us-ascii?Q?uSKtNYqdYYPsok+/tIt097Nx/YpsUBTo0x3kuuJ200c988A3py48KoL2WhnA?=
 =?us-ascii?Q?Eo45qX/WfVl5K1Al3IshxwT2N2jytveHNWQlQoRTpVWEG8JoOX57DJXQjoAT?=
 =?us-ascii?Q?iFvhAEE6FhFVD86uRPOxFJmIGTbTYWxU5vtqzPF53ZBQyABfKrpTwJmtwPHV?=
 =?us-ascii?Q?Z2lRMvBx2XU3Vexy+Yg/8XrnIPlgkdyyfT2m6jNhSn3j3UiDWbr1uN8gaINI?=
 =?us-ascii?Q?ZdjdcYolVe5enAGq6oUWtDL4Di2j1loY0u9H9mxRuIEsnbemHsJ/jKA2MGMv?=
 =?us-ascii?Q?Ddqo+IWHlENXKPicJurTC7BIkuIh018lX9Amy8ZQ5WBAvr8k8I+uO2/uifqv?=
 =?us-ascii?Q?nA8wwyHHCTgMkHhrHKiY2TvHiyi0BIhtuDfpmQAXRdzNkOKjvyCB13/fMMqD?=
 =?us-ascii?Q?RArRv67u3BMTzAKgNRrxfIfRuVtB0lTKAMryVOTf4QRIqGEWs4TW1tTzRWwV?=
 =?us-ascii?Q?8v6oleArZkoN5ut/Wy9aXViZvthPueblXjfccviHD+EiKNnV7CbQj5/pSmoZ?=
 =?us-ascii?Q?PrSr9w0SO8g5vN8rdceiYg+ph2wGmKiOZZ0Bn1yndN8F50KyFhXCF88LnqTO?=
 =?us-ascii?Q?Kn68Ap6M0XGj0znBCPPDhlAGza4jouFix+dhMrpz25gfglalLcHC4iOnpuq+?=
 =?us-ascii?Q?4SwCuFr/KHh17yt2h6wJGPKgW9MA2rO1WW8EnwREld6De/zejewiJsetDYzf?=
 =?us-ascii?Q?08VDef4s6L9+OI6XxbUiE9o3GMNCS28J/2cDOljW89pEJ5lXlx/o/rsLhrDX?=
 =?us-ascii?Q?vRMI4gDExXXMsMxevHl2Sucpi7hNqHZLgD4j306C5mJuvB6Akgrm0gV6CHGV?=
 =?us-ascii?Q?MhFX8He/ns4bRr40GBQfFHHjQTOFQfEJLcHO+J1AitvD5jCgkqqh7JBSBJHR?=
 =?us-ascii?Q?orHwYJb2oteC7EG7FjgVjbAQJMDPZ/0yXKnNiuGMiQSujyMaop3jYf2ttcTI?=
 =?us-ascii?Q?w02/QNgPsUdsmHCHsOqYl0tgk73ikivT6/smuAyFIwak3LJMtWiphGCGsAq8?=
 =?us-ascii?Q?tOq1Nh5090nCualLoRhU3bpj0UCJPSpsO2VXOs4+vxryVsGWooe920+yV7p0?=
 =?us-ascii?Q?4krPNhefBypFb9oPD160OVYYuV59AJhgDZXU+cGvrOFldtYCK4b5gRS2uX7i?=
 =?us-ascii?Q?acaq+FrFbNRaAjkWrO8Zy/4pVvOZRSlKwyRO5UIwr3dLQO0Kt9RSWHChyZAT?=
 =?us-ascii?Q?lo5/WTcMSITF1OxnP2j6YkSfUTwnXiMCizwn6ruVz+SSUCHpuXiSlAm+qoWB?=
 =?us-ascii?Q?QcDZP/v6dDBRNeDhXnz9FD9a2B6W6KQAgP5SkfW4fAwrrfznJALExioMsN1L?=
 =?us-ascii?Q?Um0eu0qAmsfvGG2zG2cp9BNadj2vWDxIjeMH+15yynPTfM9CA/3B/8JVyn1/?=
 =?us-ascii?Q?HMJrdh4Zsk6/ielAQtC3iPHksC77i3MvX5+3SzKhPPUqzhVvY1r3OAlkUYqc?=
 =?us-ascii?Q?Ya3Vuz26qi3p6ifp9ygttt6nFcAxJQtBvFNYMZcmo7O8MHz5wVQNhEmRXkls?=
 =?us-ascii?Q?MvccFxoQDL6PlJGvngn1/qWqnYi4NTW2056c62Io0cfgzUldJ+2x5yYAWG0z?=
 =?us-ascii?Q?7ntOdvwRoFToVONZUaaTSaCMcrA+5MxRtIGAhRuJryrALwbVAsAKRLnUX9yj?=
 =?us-ascii?Q?375xlbexS3pJ1Ro/id02aQ8h1mODpkwALMrkXojjQnIQq/13?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe54ac7a-01be-433e-c5a5-08de94b517cc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2026 14:51:04.3466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EkT0uLVr5lBGWCAf8pPwQXqxsrqFUoPZwxWPn7SLafITdBI37sMtsaoLL2FMaXeT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB999254
X-Stat-Signature: rft65136atszrf3qqwcc9af9bgz4w18w
X-Rspamd-Queue-Id: 2DAE78000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775573469-590665
X-HE-Meta: U2FsdGVkX1829pG+nBULcOhjNpNY47HaJzqUBsxocoOW/ZUba5JefrdrbgQtuzs6eHVwoxRdT/ZGodlS/VoVXcX5JtLMiG3nbdFpLgr1vELLyF+nWoKHr/IQwQqVyWZbA+l5bNi7ycxB+3iUSr5PugIxlXOI+RWs4EpGni3dtcmI8Zf0dnGvYDvb4vbjEAXVK5fyvrIDnvPx08fisgmHshr+Pe51Mjfdxf6MZB3F0vbw7JVAWWu0AJXMNLLWZBzPQeuILmC9prUjM4YZz9fvsTAv3E/TgqEGdqfeHN1Gxq47dl6Hx0s6ooHe6RLfRLdS9q7Blc2hZKuiBxQqfYUnItYYcEKNc5niIqH9BzMEE1ijL5+e77YJEA+lCzXpVuiv9PyxKW4OUt3SJva5XLFywz9lhEA6I1GDaoIVWIq9J3ElaOU56OFv5hU/TO2QflPtXGCaxfaksVuQPt/+W+Cbba2gvNZ5RmU1Q8U65A+SFaZogUCcYt78+/TQuYReo/LL1cwDGdhyG1ckfihGCVoIArxH+mwNbbkoougrJ1un5lX+LfFxnCvNjUzNwfLx7B9Nk/DRbDmaoZ+27NR4n2wVd33mxurBwLJMAUqY1/35/M8ZX+UKDWIkoQnua4IvRsFhPw2ZdW8CcT+rwlmbsHHbw0MVSDb1DY/VLGRZV/zts0XikPLnXH7TLpJE51zNSfAbrn7XorTJBjU2GzFuBGK1iMgwW227MwWXHoTcVbtx27Zus/HcGRW3cwR3+pqiWEzis/Z/MFwB80/uQdNrSwkQsV1vsKm32o29vGvfwOqY/F4yiA6kXK1a0m+Q1g3dIQZx6t1BmxuifDpROaL265yZGg9HDPnlHJSaM5H5eMjiwUhlKKX2UzTQ9dOBIJuSM23j3CtTVZ5iqgRlKnrIJxB+iF92wM8Qduw5i2ndFBn1G46TEEvQvubIS96kvZ/YhJ7LXz25Cj5ItHXkZibfZ2l
 Fzf24vdc
 zKYJhp39IGZlrcHMlBo2o5xH3N+lNR8K4xsdPIx9ZCGS8gRsLGJEszWaprfqXAZj3Qo8nnqRM/bqNFvjhK+qp6/B69ZSV8FEZrHQ+W55h69RXQyHRL+uXvlfExbdgkle4ss4+EEzPDJ3QDIODMRsANECSdFK8df3diAtNBlaExJUhQOJxnX/QfKyG2c5pqCG1WTlDgFBE2oBkki8hCIJozZEiqaN34JhsISdmJINKYGjPOxVJQmvPTkCRay5jyjj+XPH5kfwCm9+Vu8WyxGrrAaYlpWzSXeEvg4rrUgoUFfNV1ZXoyIHEOqkFsZF0S6VESp3kkMD1X6x0etxEuwxook9+N06ojo6IYItXw4vs+K1ZDEO/q6FZMfSDz2v+y/zXYaVLTMDKeqUDuFqUfuqhl/9JklbGHIgRoUjl7/oQ9/+9JRblCnuAfT1wBLOvoRDZbbv+FyfsoXmkGhirtQ/SzpeNWgT8Xwnzf6tJ49NP86phm3kZM91xnw7mMUzXPQdS9Zu75KO7qeSlNwlVtcUhm5e8eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6 Apr 2026, at 5:19, Sayali Patil wrote:

> run_vmtests.sh contains special handling to ensure the hwpoison_inject
> module is available for the memory-failure tests. This logic was
> implemented outside of run_test(), making the setup category-specific
> but managed globally.
>
> Move the hwpoison_inject handling into run_test() and restrict it
> to the memory-failure category so that:
> 1. the module is checked and loaded only when memory-failure tests run,=

> 2. the test is skipped if the module or the debugfs interface
> (/sys/kernel/debug/hwpoison/) is not available.
> 3. the module is unloaded after the test if it was loaded by the script=
=2E
>
> This localizes category-specific setup and makes the test flow
> consistent with other per-category preparations.
>
> While updating this logic, fix the module availability check.
> The script previously used:
>
> 	modprobe -R hwpoison_inject
>
> The -R option prints the resolved module name to stdout, causing every
> run to print:
>
> 	hwpoison_inject
>
> in the test output, even when no action is required, introducing
> unnecessary noise.
>
> Replace this with:
>
> 	modprobe -n hwpoison_inject
>
> which verifies that the module is loadable without producing output,
> keeping the selftest logs clean and consistent.
>
> Also, ensure that skipped tests do not override a previously recorded
> failure. A skipped test currently sets exitcode to ksft_skip even if a
> prior test has failed, which can mask failures in the final exit status=
=2E
> Update the logic to only set exitcode to ksft_skip when no failure has
> been recorded.
>
> Fixes: ff4ef2fbd101 ("selftests/mm: add memory failure anonymous page t=
est")
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---
>  tools/testing/selftests/mm/run_vmtests.sh | 52 ++++++++++++++---------=

>  1 file changed, 33 insertions(+), 19 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/=
selftests/mm/run_vmtests.sh
> index afdcfd0d7cef..17c9bd910c47 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -235,6 +235,7 @@ pretty_name() {
>  run_test() {
>  	if test_selected ${CATEGORY}; then
>  		local skip=3D0
> +		local LOADED_MOD=3D0

Can you rename it to LOADED_MEMORY_FAILURE_MOD to clarify its use?
Since now LOADED_MOD is visible for the entire run_test().
>
>  		# On memory constrainted systems some tests can fail to allocate hug=
epages.
>  		# perform some cleanup before the test for a higher success rate.
> @@ -250,6 +251,28 @@ run_test() {
>  			fi
>  		fi
>
> +		# Ensure hwpoison_inject is available for memory-failure tests
> +		if [ "${CATEGORY}" =3D "memory-failure" ]; then
> +			# Try to load hwpoison_inject if not present.
> +			HWPOISON_DIR=3D/sys/kernel/debug/hwpoison/
> +			if [ ! -d "$HWPOISON_DIR" ]; then
> +				if ! modprobe -n hwpoison_inject > /dev/null 2>&1; then
> +					echo "Module hwpoison_inject not found, skipping..." \
> +						| tap_prefix
> +					skip=3D1
> +				else
> +					modprobe hwpoison_inject > /dev/null 2>&1
> +					LOADED_MOD=3D1
> +					if [ ! -d "$HWPOISON_DIR" ]; then
> +						echo "hwpoison debugfs interface not present" \
> +							| tap_prefix
> +						skip=3D1
> +					fi
> +				fi
> +			fi
> +
> +		fi
> +
>  		local test=3D$(pretty_name "$*")
>  		local title=3D"running $*"
>  		local sep=3D$(echo -n "$title" | tr "[:graph:][:space:]" -)
> @@ -261,6 +284,12 @@ run_test() {
>  		else
>  			local ret=3D$ksft_skip
>  		fi
> +
> +		# Unload hwpoison_inject if we loaded it
> +		if [ -n "${LOADED_MOD}" ]; then
> +			modprobe -r hwpoison_inject > /dev/null 2>&1
> +		fi
> +
>  		count_total=3D$(( count_total + 1 ))
>  		if [ $ret -eq 0 ]; then
>  			count_pass=3D$(( count_pass + 1 ))
> @@ -270,7 +299,9 @@ run_test() {
>  			count_skip=3D$(( count_skip + 1 ))
>  			echo "[SKIP]" | tap_prefix
>  			echo "ok ${count_total} ${test} # SKIP" | tap_output
> -			exitcode=3D$ksft_skip
> +			if [ $exitcode -eq 0 ]; then
> +				exitcode=3D$ksft_skip
> +			fi
>  		else
>  			count_fail=3D$(( count_fail + 1 ))
>  			echo "[FAIL]" | tap_prefix
> @@ -529,24 +560,7 @@ CATEGORY=3D"page_frag" run_test ./test_page_frag.s=
h nonaligned
>
>  CATEGORY=3D"rmap" run_test ./rmap
>
> -# Try to load hwpoison_inject if not present.
> -HWPOISON_DIR=3D/sys/kernel/debug/hwpoison/
> -if [ ! -d "$HWPOISON_DIR" ]; then
> -	if ! modprobe -q -R hwpoison_inject; then
> -		echo "Module hwpoison_inject not found, skipping..."
> -	else
> -		modprobe hwpoison_inject > /dev/null 2>&1
> -		LOADED_MOD=3D1
> -	fi
> -fi
> -
> -if [ -d "$HWPOISON_DIR" ]; then
> -	CATEGORY=3D"memory-failure" run_test ./memory-failure
> -fi
> -
> -if [ -n "${LOADED_MOD}" ]; then
> -	modprobe -r hwpoison_inject > /dev/null 2>&1
> -fi
> +CATEGORY=3D"memory-failure" run_test ./memory-failure
>
>  if [ "${HAVE_HUGEPAGES}" =3D 1 ]; then
>  	echo "$orig_nr_hugepgs" > /proc/sys/vm/nr_hugepages
> -- =


Otherwise, LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

