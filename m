Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1160ECAC592
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 09:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CA0D8E0010; Thu, 11 Sep 2025 05:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A0EB8E0001; Thu, 11 Sep 2025 05:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 469818E0010; Thu, 11 Sep 2025 05:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5EB8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:23:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F104358EB0
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:22:59 +0000 (UTC)
X-FDA: 83876430078.04.508B838
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 92B95A000F
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:22:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=m7+84+xI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sZmaQpzd;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757582576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VSKwZLv/YUIWfqsGz0/9GgtKV/ed3YigqVniHiBKFJs=;
	b=L9twxesQg5tx7wjSRQNSc4vF3HrvGrN1J7yoS7xqbAoVRfqafE42aABv783rZW9Xiqyuxf
	6lVpUzF59Ef2JXssHjQw3vWJcndmZuUWGPKQLUw0IHt8LCy3hbp56z/zhZf1w4J24dCH4D
	b05IRiMtJgqaZ+W/XWzz1LmF0LMWZws=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=m7+84+xI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sZmaQpzd;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757582576; a=rsa-sha256;
	cv=pass;
	b=4WbnRbkbFeNOVdakBS+hKE5KP/feco/kGaF/4Wq+BohRV3W+R7mOjL2FAeMBZzBp3qHSu4
	tgFCRgwh7PsUA48NGg3IERu38OX8K/pfRaroJH76QAUw+d4OoW4FPw6+xG3PIDYmhCf/ci
	56rX620EHuCRxwTtRc8pjxdP6ex4ZFA=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58B8h1Bx022091;
	Thu, 11 Sep 2025 09:22:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VSKwZLv/YUIWfqsGz0/9GgtKV/ed3YigqVniHiBKFJs=; b=
	m7+84+xInuC8YwY47Xm43VkTdfFj0EAf28ax2bSavT5ONBxXA64eMPxLb2BQ/idp
	818aYKcTQ9cYCdp9uwK1rlkYkVKRRzwbzyOFK7MGQF1z9m37PZc868x29mfEDB60
	WMHodjdPeoCfj7qbTubF6TfHH2rRQuDg0awXEg4J84HB8CHAPqVziFomblBxsZv6
	/D8K99mRnDikuocN8Q//eNlgWicJOYol3LS5+VeGE1bm+9vaNXpxM6qbfm2KPeQ+
	56E9SnSEUqf92l/WRIfzhBR0SMG+YFscrio/5JFiGqwleT+TzbvPJrcbNxJHwqxz
	WErz25usD+uKKg0piEbcEA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921m2ww56-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 09:22:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58B7FsFJ002808;
	Thu, 11 Sep 2025 09:22:42 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010004.outbound.protection.outlook.com [40.93.198.4])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdjqprv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 09:22:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K5zNvNVC1/3FQie6Ui7EKJaitDi7Q952OCOwJadzL//fU4v/bezFUJqWScXN2CJK9wJEG0KkFn+cN6TnbF+68emCaodm2f8sKhcxJdBeD63idgw4N/7QDmcIINR6h1uoD3yrkjxRWj05XSxoegkxUvjKBwQcdpuBqhFS3D+nFzbghJKBFc9BP6+y9Xbup3UlwgO+UInVlMrUy3qayCx0nvnc+HBWI/yQXdKVidkvb/7fpDtAD4XbxZhTp2BTxxyhqXIPy9h5r++rHJnQnQFFl+TLQ9wHdKxjza1b2yE0b/beYp1s39Ml9IzZk65jDO2GCJkbrIGNRy8MqPVuBX6cng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VSKwZLv/YUIWfqsGz0/9GgtKV/ed3YigqVniHiBKFJs=;
 b=ZqGf4xlWP+Y4NNfpngg1YP4psGeVgIjwjdxxkxvAC5WdWqWvL2adnBeLEiLmszjQLBm6/i7ObTztXYVgvVv9YbXoRZ3b+yGFK1/tserd3iXC6Ouv5aXc5pxrWta4lgQpUD9AuU4y7Jjfc99LzHRZH11ZlJYqewjSElrLFO/RdfYW8cwTOAJIP5EKj0LdBJEuUPcVeZGsM2Eo+9F0QYcmfilQKlQjKSuRaIdLhYUHROrtNeN2VeVR2fl5bQxwH9GQ+eIIJt2EdE2OL47tp44kk/OYUJ3cYZi8zXDDf7CNY7qt1Aq9Bu8WZf7LSFInIBoGQwE0GmxJkKaowSK6JaLV5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSKwZLv/YUIWfqsGz0/9GgtKV/ed3YigqVniHiBKFJs=;
 b=sZmaQpzdth/MszMorEYQMHBWH+rqEs+SYUhfH3omJP7sX5I2ODiF2ND9me8RUJcRBdaERbeGJCoEf8PHjjm24MXxTfuQVgf4FoSHWvmNxszX3GxUIOjXS8JMvm/i6ePk26if0YM7V9nTF6SPwYB3N2y1WwbQ0ZhKnyRLYoQ65vw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPF1F8A3E3BF.namprd10.prod.outlook.com (2603:10b6:f:fc00::c11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 09:22:39 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 09:22:39 +0000
Date: Thu, 11 Sep 2025 10:22:36 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v1 7/9] mm: Introduce unmap_desc struct to reduce
 function arguments
Message-ID: <dfd8b8c6-d697-4032-be2a-569b9629c564@lucifer.local>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-8-Liam.Howlett@oracle.com>
 <CAJuCfpG4D4ikZO1c8zN7HNgLTAco1ggk21rg9AUFwoztA95qSA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpG4D4ikZO1c8zN7HNgLTAco1ggk21rg9AUFwoztA95qSA@mail.gmail.com>
X-ClientProxiedBy: MM0P280CA0018.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::32) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPF1F8A3E3BF:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a6a34de-10cc-41aa-6421-08ddf114c0d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YjI1UDZ6ZVh4OUFpYU1oU3k5RU1SeG50Y3ZZNVhWRENwdE5laFpJODFxQlhB?=
 =?utf-8?B?bGVrQ3pSRmIwc1EycHZoUXJwR3p3V1hPWGRYcjlrbm1JRFFNaVB0TUUwOEZ6?=
 =?utf-8?B?WGJiK3RXdU9DbTVDUVJUbmUycHFUUXFJOFdEbnlDbFZ4alprU3dvMnFudDky?=
 =?utf-8?B?eTFwOGlxYm9rS1dNdW04RnFuUEphamNUZWlFbHZlbzhzL1Nud1V6cnNrLzBS?=
 =?utf-8?B?YnJaSWE3aUZKRFRnWkxhTklyd055cFl3OWw4TFM2dmxwR0pqZ05sUWFiYkNo?=
 =?utf-8?B?K3NXZytVKytpVHlaTk1WMjJERzEyOU9Fc2tUTmQ0ay91SStiMElEdEVlRkpE?=
 =?utf-8?B?ZEwzTW8wTFpGdFZaSG5aOXVqVkUxK3cxd2hoa1ZROER4REdPQWZKOHEzWkVq?=
 =?utf-8?B?SW1tNk51N2VTRThscnR0ZVl6S0p3eDZjK1dTVTVYTHQ1dkN2dnFaeDZIeXl3?=
 =?utf-8?B?ZzFBUktxb0lFWlRyTGYxMmwxVGRFdXhPUzd2UGNLMXJEM052Ri9tWHBHYTBK?=
 =?utf-8?B?b1lVM2dGdDBtaFd2TEY5RWp5Q2p2QVVhL2ViQjdTS041ek9YYzA3Qm1hbDgy?=
 =?utf-8?B?dVVhdGNLcFZaeENjQ2cvNHdtRURrQXp5RVg3SWoyU01TNW9uRTdUMGZqRUlj?=
 =?utf-8?B?ZldsMmF4T1RzcThzSnpRRkJEUzMyVzhSVTZKbHU1NVl6RGh5cFVja3Y2SG5p?=
 =?utf-8?B?UXNkaStScVNPR0VZU0tWaHdnK0lGcnQwTUJnM1dmZlNZOEVubWdTNGRXQ2cz?=
 =?utf-8?B?WFlObDRGUVg5WUJLL3c2TmorNloxdXJsd0k2SGl4WlhiNWZXaVpiNW5DMTRS?=
 =?utf-8?B?T214dkJWaVdaRXhkQ1RNa3c4dzdpSjZtRXhzaThoR0dURTRNWHhMa3ArOUQ0?=
 =?utf-8?B?cVVjRlJacU5EQnFCVlhuc1R0cFRMTHVZbE92ZHZHSVA0QVJreTdlZHRURnlX?=
 =?utf-8?B?V2FCS3JkeXhjU050ODlkWm9VcGZvT1g4aEJEbFdvV3RKRXFXMzhMNEt3MGp2?=
 =?utf-8?B?RmJoWG1iRCsyTVVDQlNOcm40UE9td2hqWEplRUlvMzZrK0dDWmdaMW1FMkdi?=
 =?utf-8?B?Rmp0R2dyWUhoYWx0ZFA5SHJheUVseFU5Z3ZLcEhMc0ZrUUZzUDRzTGszMnBS?=
 =?utf-8?B?cVdLaFhZQnpQUEdFU1NCa2VXREJSK1hTcnl2Ym0wQjQzOXpmTU5WMHhFb204?=
 =?utf-8?B?Y3FoMlh3dGNyNGxyL3NPQWFCZzduV053ekptd25wdGo3QkRRNmJTL2R4cWpz?=
 =?utf-8?B?YXczb2lhSURNdDgxcExzVFBrZ2l2MnhVUmdIbUhsT0xHdjRVTzl0OFVuM1M4?=
 =?utf-8?B?TGoraW5DM0ZMQU0vN3BnNXZ0QzlOQkV1d0hSSWJ3TGd4THNmaXh6ZWR3ZUhy?=
 =?utf-8?B?OXdHaXQwdU5BbFUrTzZGME1scXN2RjJZYms0VE8vb3EzMUM1bS83M1Jvd09I?=
 =?utf-8?B?MGlRbVV4aHNkZjJESHZNSk4reDR0MHREV3RDVWZVcy9JV3M2N0ZBbkZ3UGdR?=
 =?utf-8?B?WWlMaDhLaFlraU16MGYvZklIMW9EbjVUZWZJUE5nZnNVTHBIeS9zN0xyMVdE?=
 =?utf-8?B?MytZRUxKWnJTa3NsQWRjMXhuaWZBaGJ5ZytKT3ZBN0NSQ1Buc1hXbEEvZktx?=
 =?utf-8?B?Tnowa1ZHVGJkRVdqNjR6YWJUMW5kdnJQbkd1T1U4d1pTZitWcmFibWdaTzBh?=
 =?utf-8?B?UW9mY2ZFbjBNbllaamx3b0xQZk9lWGdXd1pSUWR1VWdLdVJoaDdoRnlTZXhw?=
 =?utf-8?B?aWZ1R2ozQzM4Y3p1bVkzdERjblp6Z0pwVXRzQWlDUnAxS3RRQTlMMHFEMDVZ?=
 =?utf-8?B?YTZoTVBjd1FJZlByVVlBNVFiRTlDNVZJYTVnbUdUanRZSFBraGJDREpUdU4v?=
 =?utf-8?B?TGdQVWtoRm5IdGxldlpucC9pekxuMEd2c25qNFhDSWM1Mmo1SEk5SjlOQW5U?=
 =?utf-8?Q?GgzR2tg8wbc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dDZ0cUtqSXZWbDBlcU5TaVNpWk04SWtmSllCM1RCdHh5bzBhSDkyMXJQTlR4?=
 =?utf-8?B?UmhKb3lwbjhiVE41RDhLVnp5VW8xd1h2Q2NlS1dYdTBxOExBQkZDVWl4T3lS?=
 =?utf-8?B?RHVXdXp3eE02bW0za0hRUStiRkRxSzJYUXRBM3Y4YlcveG84SWE0dWU5L00z?=
 =?utf-8?B?MkgwQjloOFpqL0xmZjNKaWErazlrdXNtNU1aNkJxQURnNEh3d0RsK3I2THU2?=
 =?utf-8?B?SU1ld3E0VkErUVl4Z1hYbndNcWZpbCtMZG5JN3ZmTW1UYVF2bGRWWGNsbmlv?=
 =?utf-8?B?dkdMUWk1SFk4ZG1EZEx0VE5qdGNkT1I1bjJlbnp1dGVaYVVYYlFFZVMzVkxz?=
 =?utf-8?B?VjVBRTVQblVFZytjblhUMm5yRFhhSldnWUtBZFNYSTlEbHY5Y3hYenZIZERH?=
 =?utf-8?B?SXBHNDllWE1MMGxVMy9BT1lzQ0VrUisyYTZ6Y0plSW8wKzEvTDZYRHBrVDhv?=
 =?utf-8?B?eVlhQS90QlI1ZFo4eHlVT2RuQ3ZHTEtIUGVyaWtINXkzWFBGRlp6T1htVTNO?=
 =?utf-8?B?NzB4ejZsVDVvTzBoYUJ2NlBFUFgzNVM5S3F0UklHYWFRMURxTm9nVTJFb2pX?=
 =?utf-8?B?UEVtYkI4cjZXbDlWNWVRYmp2bWVWd0Q0UkE5ZEVSMW1lblQvVGtQZGY5Z3Mr?=
 =?utf-8?B?eXVJY1QwSkpZbkFtQjM0RmV0WDBvZCtFUklXMGk4QjRVT1djajFkRUZEeEJm?=
 =?utf-8?B?WVhwcEc2NjBHWGlXME9GRktDRGhWbXVqS0Z2VWlTdlVFUkttVWpKYmJCUXZq?=
 =?utf-8?B?b0tXdVNCTlpZcE1SYjZXei9pTXY4a3VKUk1kWHpZZ2JuUzZUQ0xDdWRWZzdU?=
 =?utf-8?B?WTA5ZFI4ekIyMXUyMjhEOEZEVnIrY3RLMUIzcEtVdHU2Q0lXdU5rcVkrMzVm?=
 =?utf-8?B?cHk5cUpYaStYQWlIblAxa3EyNmtQbzFFbDJIQ0JFZWFtOEc1ZU5uVHd2d1dv?=
 =?utf-8?B?M2Q4UEZ4MnNmVDFoVnVlSzh5TGFXb1BsaUtqaUNybUNvUGFWbG9DczM4elFF?=
 =?utf-8?B?QkFsbXR6RkJNNXlrcDdabmRUamVRVWp3KzIyM3hJcUMydFJuSXVBRGYzeWtU?=
 =?utf-8?B?WHprMGEvVkxyTmJPSXZXRVJJb0FINXk3dVFSVVo0TDVReHhRYkp2V2pDdE9B?=
 =?utf-8?B?UFMvUDA2TGN3bFZ5RFZ2WGFDNkVxYXhvRC8rSy8yU2JWcXRsakdVazl5RVFG?=
 =?utf-8?B?ZXpiaHhkTW9vZHhNNEkyclV2UUFtRFBaY0drenJqeWEyVEdEMWFSSjYvMFph?=
 =?utf-8?B?eW9sM3VWWStzcEZnNmFwcXQwcjBnWXZhTGlqVVBYWVBRNVFta1VtOEtTWFZs?=
 =?utf-8?B?dHI1aCs1WXRCbHMzNndnSzdOb0dSamNLSERrN1V1L2ZIczVlU2NpbnVqU0Jt?=
 =?utf-8?B?MmFORmdqTTVYb0JsMVIyYlF5Qk1YemxtdjBiRmxIN2ViVm1NNWY4K1hSbUl4?=
 =?utf-8?B?VmNqVU43OVArTFUwTnZvc3V2a3NwaUVmbGV6MHkxZUFERHBsSGJza0VyT0lR?=
 =?utf-8?B?bXRuUTVWZ0NCT3lXQkloZWs0djVpM2VTc0ovdG0zTTE2OEVGUzdlRmZPK3U4?=
 =?utf-8?B?RGptREl6aFd4V2tlQnMxN2ZzVUJrUExRMGlsNW56YStFNkZBRlBKRlZDMTFG?=
 =?utf-8?B?OS9tUDZIK1hvVmdVQUFSMm5zWXYwSWFPZGwrNFQ4NEpEOEpLaUZnd3Z4VTI2?=
 =?utf-8?B?Y3hCVjJZSzFiblE2Tk93ZE4xNXkyRFoyaFJydUdMZEdQbENXT1JDS2hxdnNx?=
 =?utf-8?B?MCtxcHRQSGVBSk95bHV6ZXBnbnBYb25TYnVURU1rZGJwVVhabklVNmxlam1n?=
 =?utf-8?B?MG42YVdxMDMyVCsrdThsa3pQcm8zWnl0YUI2WjBZc04yVS9mdUFmNnV3VFcv?=
 =?utf-8?B?M1Y5ZFFlWDE4aVhyWGprVjZxRFFxekFoNC9jLzhTdHhMb1VwSkRhMTN4TFBt?=
 =?utf-8?B?dHNQaDl2RzU1TWIzaFlqM3djbUM2TktMdG43R1NOaEcxa05RQ2JISDNlWmxL?=
 =?utf-8?B?cTVWUmRSeU9EQmI1M3FXWEZ0UVVISFhMV0FNLzhmWDhWYkhJY0ZDRGx0UTcx?=
 =?utf-8?B?UEU5R0kxN2NFQmUwTFRSalkxTTB2QjJHbnEwRGNQU2huUFBwNjhrd1JaajA0?=
 =?utf-8?B?UFYxaDVkV2xpSjhWSDVCeURkMG1VTXFTUzZzcUJYdXFvOWlYWEo5MXhqcG9B?=
 =?utf-8?B?cGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PfGW9K+FNmoe2jjgMJcn1IzZDhYVkord7KIpCxzpR1PPDFLAWJT/R8B2GxsMU8P9xUKBkH8o8ZVDvqJefpNBD+iLMrYJXvJtYNNkx7nEED4xLfOKp4a78s6432YOdvyTr7CCoMrBpT3OQLJ1lVHA2Wh48ktYsvMdZJmXyFBGwPqCqIXn1XZUUJvic2sgFSpqpScTUdzTJoasvd6YHA+6tcC8fQfU5wFjDeqp5ZYq/g62WrqeoXxwcBAQW2bx3Hwcp87gQVnCCaobcniq+Pluz9NrjcWsx5/JWwi1qoaKssEzkkBH3NS4Dcxvyn9X4/is7+QY3hZlACCS7VBEmpQ6G+0PgLt2fCQ9LzVnoGfzn14Gw2TxmhMvvsZJrqEka+5/30ugiOUPZ+W3wpjF97TyPpbSwRQcxwcb2RCdpXea59xVuVGf2GvrIBIrnUHI3WhjObgeAL9nuXMuxjy7N6lRzUI2Nx54weby+A6Hl5ZeBlvoPIrrGlVpkNwT7GBsQm0v5sIMTGvenK9vuZIlsBO+070aoV8tt/uhFJgvOBftwCA/JVfvBxsp+LgBSoEJYsg/EjSaq58iex7+j2qeB5PTm60+ii8+VdWrI462+b8ohNg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a6a34de-10cc-41aa-6421-08ddf114c0d0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 09:22:39.3626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7o2saEwI1MrxocW3y9zxGygwMFc4UfUtVqmTvGkN4gHeDCT2lQvUKUOLboeJ8XxiHKeXJu0DOic7hzKb27GDyOp2wVdlrlcRZ9kO6EiiKEk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF1F8A3E3BF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509110083
X-Proofpoint-GUID: 1YiJrEsY5vTxQhTTQh6m2Szs_yBHOLIK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MSBTYWx0ZWRfXypCDD1jXnGon
 i1scLyfeNoLSGc7YAnUMaiy8996yBT7hKM7kS+GUhvybTuCVVYrPPUmhd0EsBVGLDVT5fKXi7yL
 OmBBYzuH0kI0kKilhC3IPLiOH3vQ4th8ux4852yu/56tMCj5HaPz/OpVKPl2O64kgNvzaDXOIK9
 r1MjtRQSdbVgLXTb5tPkT2dbse/lW1FBio3y4oOhxAmO2XOCkYblPQaivL6f0fLEe9Qly66J3GC
 T+eoquUm9hRibm470nMKE6nl1sSgh+jW96OwICuDLGe+Ht1jy66g7UWy4cGVoNd66MRb8kNzgkO
 +ChVI0628jgv/eMYdlx1o+jiDkOW0ADt3THZ2rX6ASNy7/mU/3h+2/krzcMAecVE3yFGSHtocNT
 ap24S1idzespPb56k/4LCpY3IDtp6g==
X-Authority-Analysis: v=2.4 cv=Dp5W+H/+ c=1 sm=1 tr=0 ts=68c294e3 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=1LnDF1F9z_gXde_Ch2wA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12084
X-Proofpoint-ORIG-GUID: 1YiJrEsY5vTxQhTTQh6m2Szs_yBHOLIK
X-Rspamd-Queue-Id: 92B95A000F
X-Rspamd-Server: rspam05
X-Stat-Signature: 6mc13e5j83fboywn7nfjf1kp4cijjt3a
X-Rspam-User: 
X-HE-Tag: 1757582576-137809
X-HE-Meta: U2FsdGVkX1/jVMdjN9XkW6cWlROuXVBtQ0s4jTnsPyFUGSs2wU2fG3k6fuyn5wjBrbj+QdtSDMMVD2jL6X0HRtJSVYpQLSnHM9sIPvaU0YZhdnN6HyuPMviz7ypwcuBBOHAhG7zIkb5nhfFpAzTJru0dZNew+d+zUJTaW5mc6EcYRy42pjJLyq908W/Jq0BJzlLbWHDKXNrIFaWrG0EqHi0h+R3SDaTpLoMz1l2gYw3o7Yr794aDn1FRZGsrwrlx/GFJ2wxAr8+3R7MjmG++qF0M47erNdCyoYyW2rSWJanjx5YoJkwvHXy1fxxm1HZ4Iixf6G3Lfp3vkB9xFkO6lGFLeUSc0CjOJvyRbDZr7uU8DC7JHabP6uKXKEnO3xRdeBLG31cqJ6CjO7aENa1UyTUlzkX9tn4UCgHeJfFgzUcAMWAk63GgrsqntV3XhYxLjFdTytvle2EZId160LuzlXj6OF8q5yLl46O2HZALfPINwmfqUZDxiNsfUXKB3ZhUaA3yi+C2jbcn0gsR/VKs2kWuwr4ldKMO/l2+OxmZtOf2XoseYL7rZeXcOJQbdRfAD0m2BVMjFMGfOJxZKCrN67i/IHgqGQcge9eAGq5X3oCBanJZC8od1Wcj5DDSSnUquAn7SHcYZpprM3d57zqHdZIK2bU/ZzQNeKcH/Y4vYX4HLvI7Xz4BvzH4uhUaJAfK+UiRkT47GxWKP6UUUy2TKqdV39CxqdpTlrIhmldOj/N2R82N11noGy+rCpcxjEgJ2r5LdGogrolRUJvE+akjCuem2YKM0hvbFm2wlLBU951FeDiwZbXqOhefOKsFiodHNmYKeHVw+hDaOUqNDi4TecS/8ZBDe8zDnAgexLYboulQSAe5mZYBA75Cp4nGv9/kBcGU/aDHqZtjKe4YMqHKOd8CQO09qVE8COdlndKfMLPZ1EL2puCVEuOlbhhSKrUfjCajmbPhKehLCqEQoe8
 B8b2hNmO
 fZNcJWnnqwdY7GQxg4Y5NwcX6/HhoxaesHEEgU/+2PqThWSntBNy7KTLejXcwCfqhe2rZf872kQ4f95LCcNbMvAMFfg3T4bjJGdRSi1u/okUYNo3yYO/nVai8i2zfV2eqLleIS50ZNPmKu8CbGTSGjSg8E5RsuIe6iU+z52m7eMH/cedZ+dMwVZy+d/IEGKfjZF8+cjf7x62wiWf/ohJcd3fin9VfN03WV0X50VIOkmeDKopz1HYr+Luj7xNbZVVk5r+q+jnGFEjihSwZEqe2SQNXv9VSlWovzEMEfcxrW06xr5X0r00umUEQOctYKgdkUXlJF7p6kdRcSyUXhATSz7WluaEYdkwm8oL/o2RWAI8HvNN7jG6Us3THnbhVW+92dIeV4gcIpVsYvTNSCBo6u5iuM9Shq9RyQqrMvs3Id4aQRDJ5cjKlxCsuGCJpGjv0MAWQzbyZw4iA1+ZgHoOeeIgOzeF9PbXDZIUB8AhggUr7nnD/R4DX7ocIg4dRQ7PvXyhZYIiOS37wq3PXNXGLKSe7kOpfQ8IpZCTtU8UclmqArZk3cMjQCH4LveVSj3nmnyg4A8C8vmF2jAK+/H5srb2LVzWKAtSUu21hYVuw1Yw3tk59ZSZoeQxKlWYl6Gy+g+kHAEpy6vryDam1fHc1Tpiu/ljs/DFQOCqsrOsJek3F80qpsoM1Z7oFM6DHRa2zDqAP1Fbx6mira6ytkx6+tmvSBGiw1c7UwWSx5AC4pOddj3WL4QY5Z9AN5up4g0Kq+jasXMdTDzVa1+W45+uJC4tsLsY/85JDiDCKz/W+QNCRwF7XE6rR6hV0Xw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 02:44:05PM -0700, Suren Baghdasaryan wrote:
> On Tue, Sep 9, 2025 at 12:11 PM Liam R. Howlett <Liam.Howlett@oracle.com> wrote:
> > +struct unmap_desc {
> > +       struct  ma_state *mas;        /* the maple state point to the first vma */
> > +       struct vm_area_struct *first; /* The first vma */
> > +       unsigned long first_pgaddr;   /* The first pagetable address to free */
> > +       unsigned long last_pgaddr;    /* The last pagetable address to free */
> > +       unsigned long vma_min;        /* The min vma address */
> > +       unsigned long vma_max;        /* The max vma address */
> > +       unsigned long tree_max;       /* Maximum for the vma tree search */
> > +       unsigned long tree_reset;     /* Where to reset the vma tree walk */
> > +       bool mm_wr_locked;            /* If the mmap write lock is held */
> > +};
> > +
> > +#define UNMAP_REGION(name, _vmi, _vma, _vma_min, _vma_max, _prev, _next)      \
>
> Maybe DEFINE_UNMAP_REGION() similar to DEFINE_PER_CPU() or DEFINE_SPINLOCK()?

Look at MMAP_STATE(), VMG_MMAP_STATE() for precedent in vma.c

