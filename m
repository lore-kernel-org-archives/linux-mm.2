Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D6D6606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 12:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=uVOogPO+
Received: by kanga.kvack.org (Postfix)
	id 3A7AA6B05E7; Thu, 19 Nov 2026 07:11:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37E5D6B0604; Thu, 19 Nov 2026 07:11:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295CF6B060B; Thu, 19 Nov 2026 07:11:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAEDC6B05E7
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:11:13 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5FFCB1A0A13
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:11:13 +0000 (UTC)
X-FDA: 85451753226.06.4213D70
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010007.outbound.protection.outlook.com [40.93.198.7])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5428740010
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:11:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=uVOogPO+;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf12.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 40.93.198.7 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795090270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UyIvIqAejQlQEW90ieZXPzm+/wzkfYQOe43O+uTLzTg=;
	b=uhvgO5xijeH9bK/e0Nd2kqouhSZbqwmBEAkJ7n8nJ28ftl3VUrdtrWovzl45Bbci3/IwLb
	PO1k4oKhUktHEbbspxZQUXukctlhtsTTo2gw56ZYi8r0H5SYZDnHqtiFfvr5hHVJqZDeu3
	rbnB3IPWc+Dvr4KtIlS5pC0cfwj84f8=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=uVOogPO+;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf12.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 40.93.198.7 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795090270;
	b=ml2UrQSna3Xl+magZ93VE3uiTu5dGB41OXW+qL56cfyOqU2vP6s8Hgbi0cNHNwOlHpos/1
	s2y9F98RKl6VCNMs0aTH48QIcw9ZDRCuBowxdQo9p0kmcxQIDwDH4JeqMZMUPsxMsWLE0R
	f0pK3/beSjlfMYne2hKhM4d0qQ6yffI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lqBMOjTqYoeUHcYtM+gE3LQ8zkoTJVakQZwn3pU0k1xgkJIhiHjndyUDOoNZuFQyYgtRDj0OV/NA9gHafFobLWlge4Ul9X9x5UCqGd7prTxHHJNm0msDdaAaW8vjYFHnGYAbS38oNnp7EZKrcdIPqONxBXYOWNCXwAsum3gEUfGY9sWwvD4Q88LmMiZ2ze89EhEi9iAMtY1CwYYbDRBzIJWN65xAxqDLXMIUBHfibE3sp7JSboTKchlTDX8iLZy2YyOpzMLdF+1OPUIAcwiivNUyHt2bxlGcNaNSo1/4ta1YS9wyCU2qR/CA6/kSv0AxjW9vDW7WKHjmp2M+yC9+6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UyIvIqAejQlQEW90ieZXPzm+/wzkfYQOe43O+uTLzTg=;
 b=O3dzaUxYwCA9E15TQhzCVmQoSMjd3VB+l5ntrYlvq5GyGEYyvB7Q2Boee9XqPgJApaGQQ0p8cmsJe8vnYTx55A4NUVYyvrsfBFA8T8X6fJhSN+aUeBv/+n5CvP/wmzsc/HOcB479F1NAMl+sDPpZXpHBgi+0Q5znF0eWVysJ9ff8KxCLhXFd2fOEKgqO+y3rRvMQMwgEZZbLsd7lG8WPc5wf02a6cwZU8eAfGne+H1/2uwaW62qpV2S3V9clBEMl3wnjj4vRRfoagYnDzw1w4DWRFDpCbLR4aYBcDHag9Zm02nOt9RBBQZzGns0kAhfasnfceWNYE773J2toi1JoRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UyIvIqAejQlQEW90ieZXPzm+/wzkfYQOe43O+uTLzTg=;
 b=uVOogPO+EkdZ5+WW6vNmAldKIGI5RudjQGgZn+xl5hfRU4sYomsu4EtUIkNF/J/Vd02Rb3t2F6IPAGoOy+h/lhDF1pfBPpnlhpnlE9cY/Od+S7co17n1JQi6KkzMHeIfxoYgZmJQCV2MXq17BdwiZ5CmheMfU3XY7dmTaa1H0i0=
Received: from DS0PR12MB7771.namprd12.prod.outlook.com (2603:10b6:8:138::6) by
 CH3PR12MB7522.namprd12.prod.outlook.com (2603:10b6:610:142::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 12:11:06 +0000
Received: from DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c]) by DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c%4]) with mapi id 15.21.0615.013; Thu, 19 Nov 2026
 12:11:06 +0000
Message-ID: <f56b0cc5-7529-4481-9f17-f940283d62c7@amd.com>
Date: Thu, 19 Nov 2026 13:11:02 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/userfaultfd: reject DAX mappings
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Peter Xu <peterx@redhat.com>, Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Chris Mason <mason@kernel.org>, Jingyi Sun <1045704958@qq.com>
References: <20261118-dax_uffd-v1-1-d776cca1ae17@kernel.org>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20261118-dax_uffd-v1-1-d776cca1ae17@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0339.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ea::13) To DS0PR12MB7771.namprd12.prod.outlook.com
 (2603:10b6:8:138::6)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7771:EE_|CH3PR12MB7522:EE_
X-MS-Office365-Filtering-Correlation-Id: e02e1bb0-d592-435e-b8b6-08df46363035
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|261022105027099003|261021121427099003|260925021311599003|260925021911599003|260925022911599003|56012099006|261026121527099003|11063799006|261028144727099003|261009223027099003|10067099003|261102123227099003|261026140227099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/9TM57Zam7VMxLw9BkkgKbJzCoeWenMwgZkrP8s0gC2PumrAPaYEhvpW5wbJdgeLsmbSg5r1M8ElR4IHaNJ2XLDWTkRpynYmMwBkEVow5uvIkJ8KuABnbaISBVEac5XOQDC1etjQjMj26F9e72XM+TXcVOrX6jfUySeenhr5e8j2eieUUL4U3HmxKdWWlNoiXerkqD8c+XX0DzMDxX2ysL0AnmAiFNrzdT8PPiBCqehLK0o83yfTGrnmcdCEjj+IkqNAM2BKxaDYm5A5QqU/2DAy5S3X90VeJxSX+SafKyY1BEb1lrWRHmsen4ikepMr63lHPF8s8Ttb6iqAoVasJJDFAc00hkXMj4seNUAejmPziA2JrJaL3Z88n5uFrRVS6WKE7eEHtFIepNMtAjbtw3cK1VTYM9zHzcvnRzkvn1RvY8SXtn6z9fhoRQQ42SIVH/QWN3EsGwgX0dgwBk7mn7eFgdnVstcBlEci+gFE1Lo1p1YZ0PWOux7IX/pL+G9RacSkc9iI+Qq2TJg7Cd6WSiBhKZ+QmnOUHGVKzhVP02/aEzfowFGSVq/mEa6rPPx4xAKRYL++a5Tii+IjgMSssIgdotk/DK/sKOjubluJrvJ5YA6kPT4bcQlsxzl3cPJ5
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7771.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(261022105027099003)(261021121427099003)(260925021311599003)(260925021911599003)(260925022911599003)(56012099006)(261026121527099003)(11063799006)(261028144727099003)(261009223027099003)(10067099003)(261102123227099003)(261026140227099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NWdKKzV3RTQyKzQyM1ZUUEpMbC8yU3FIRFFUbEluU3lZSTlITkNYblQ2ZHU4?=
 =?utf-8?B?YkpWb2wxRm0xUHRIM3U5OXVUbXQzVzY1d01XR0JTRWpwMVZyRnBlRFV5WWFs?=
 =?utf-8?B?MW5aL1U0K3BXcitYZUN0WWVaQVY1cXpaOUFXektlYXFQanlmbStHZnNGTzR0?=
 =?utf-8?B?R29rY3lER241OHZUdlNVbEp6aDZIeXhZZUZCeVc2ZDNydElpT0VDU3MzYlBQ?=
 =?utf-8?B?OHRlM2w1WW9JVmJVMDFXNFhZSC9TMmN2aTRXN2xHZGdSdkUzZFRzQXB4K3Rp?=
 =?utf-8?B?K0NBZUgzZ0cxWEpvSVVOZFFsSzQ5Z0l0QmFnNGJ0N1VCVjFqNjQ4dG5SUGdB?=
 =?utf-8?B?SHZVU0FXQ25MTGkwa0VmZ2ZicitNOTlBOUY0UUJPNUxmUVhQQWZuYmNwZDEy?=
 =?utf-8?B?Mm1hM2lWTzZ4UHN3bmZzamRHZ0M0TlI2d1k5VkFDenNyM0xjUUVxT0Y1N0tE?=
 =?utf-8?B?bktCVVpMS1l6RElQVjFUQjhtY0JMWlNycEhQNUtuWWQzc1l6WEFLYVhsbWhR?=
 =?utf-8?B?M3pPVGdSektyN1gwOGNYVmprQ0RNeHpxaXErWDJ2NkdKZTdteVFyaHpEVlNx?=
 =?utf-8?B?aUZrL2ZBOGIzcGZnQjRsanVlUkpoeXZxT0gvWmx0Y2k4T0R3OUdGM1RKUzh5?=
 =?utf-8?B?Zm01RVlHaUlqaFBBUDlGcE5FdU15YU0rNkYyYU1mYWdKeDh6OVBWTVhtSW5r?=
 =?utf-8?B?M2IrN1o2dDNDL2sxb0VoNU5vOEN1Sjlsd1VEOXVXRGF3OW1lVXM3STdiejh6?=
 =?utf-8?B?eS9BVWFzUlloS3lTdWFUWitCalF3T2VSNTFSZGp6WDBzSTY0QWQvQ2Ftd3lo?=
 =?utf-8?B?eldodGp4N3BmbnNJWHJnalRTQW5HenZOY3U2WWw0c1k5Ky9PUkxIWjNBVFdo?=
 =?utf-8?B?aGVoUS9WeitsTmg4OHo3SUNaTldxcVpZdzFNTThYNjY5OXIvUlNGczRpdUho?=
 =?utf-8?B?TllFN1NHSVNhMW9VdVJQbTM0TVpwSm5wamVpbzNJOUFlMVJ5c0hKYWl4Lzhv?=
 =?utf-8?B?ZDNFM0lUR0F1NE93NTFFTmhvTUFOeFU3NVJ4Y1VUcUJLOE0vMThTcWt4Qy95?=
 =?utf-8?B?NTBmZ0NuelF2Q1laWUhZZDh4UmVVK2tMdy9mbFp1MlVsamxJeHpCSEJiV0Fk?=
 =?utf-8?B?bGVHNFB0Nk9EemFqZzFQc2d1Yzd4L3AvV0hPRGJpck1pYzYxc21JNXhrbVpU?=
 =?utf-8?B?TTZRcGRYVFRhcFlaRDJNK0p2NEFISzlENHQvU1E5amN2QkNIMm5ya3dEN09O?=
 =?utf-8?B?K0I3WE04dCs1aU9jaC9ZNU0vbURGUWhEbnE1RE9yQzk0Z2RzNktRYVNFNVZZ?=
 =?utf-8?B?M3BuY1dQVjZ4MVdoaW5IL3orYnNIbitFazV6bEF4TTIwaXZ4d1VvK29kUG9X?=
 =?utf-8?B?aHhMZEVUY2VRUXQ4MXBtQVFvUG85WUtTbGxxVFEzODl5cmZCS3Vwc1RGWVNx?=
 =?utf-8?B?RHI3ejVSNXArZ2xlUVhhTFlVL0tSd2ZrcjRvQ0hDVzJQWWJyU0YwbWUvTVNo?=
 =?utf-8?B?L1M2cnlyckhvbHI1eFllTURMeVgwWEZVbVhGSU1Kck9ZQXZrY2ZWd3JTLzdS?=
 =?utf-8?B?UWg3MTBha1lodFVZUjRXNXJqd3JzYjIyTEFaWHA1aFFyUDlnWm8zZHpCSDYz?=
 =?utf-8?B?dk91dGVhOWZYUnBwNW02bUo3ZW83UVZ0NmU0dUtiREJMa01CYXloNDcrQnVX?=
 =?utf-8?B?NHVpdDBSbWN0NW1sVVVMWVlaWUFDVHh6NUFlaHFzeHdoOWgvdVNVUEZmMWxK?=
 =?utf-8?B?eTRacVRWbUFhRThwZTdKNjJjdUNWNWp6NHNJczhhZEQ5V3c2R1QrODg0VlZx?=
 =?utf-8?B?RFJIMVJhODQ3VytZL0tML1dYWElHTWVmdXpPMWlrQlFEZ0hYOS9ZVTlYOTFF?=
 =?utf-8?B?R25QZUdBdUNKcWdlaFh3Q0Zkc0h2eTg3YzVWMFBFT3Nwcmx0bDRSUFhEWGo4?=
 =?utf-8?B?Tkt2SGdNVUdqOWFHWUNuVEZJSE1OdS83ZUNGZzFJeDJJa1FrSlFEL05HamI1?=
 =?utf-8?B?QXI1WTRxU01aYXBWVGJDTjNXSDhPVHNWZEtyeW54dGwwMGNpMFUxSldPMXFs?=
 =?utf-8?B?R1JtS0JMN1Y1YVpZTHIzSEZINSt3cStUWFpNaXhCS3IrRGJtbDFtNmtMNEc2?=
 =?utf-8?B?SlYyYUhKeFc5dktsbFlkREl1L3lyZWxtMFZob1MyN1R2VDM3aDVoNjFPSmcv?=
 =?utf-8?B?MEtxcEM5Q2txWEdpd3lWRGpsV2o0c043dlh4cDNtU1ZzdnhzSzd0RjFLb05E?=
 =?utf-8?B?UVN0WG1KYmIvMVhubm1sRVRBY0ttRWtjNFpsZ2RZbjAzajduUVI1bDl6RThF?=
 =?utf-8?Q?4FYAqqU+UevsNodjVc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e02e1bb0-d592-435e-b8b6-08df46363035
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7771.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 12:11:06.2789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nekk73IBbYiAAQmLodz1lCLwKYHa6tpXqM2WNB15qhIkNPvJdFXBi6889o53nmCn7PmOWUkQ5ZsDexCcxUVHfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7522
X-Rspamd-Queue-Id: 5428740010
X-Stat-Signature: u7p4jwjtkpbb31jgwaftooitn7ijecz7
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795090270-575248
X-HE-Meta: U2FsdGVkX19ajRqdqtq3+S/UbZ2GrzCjbbx4vFwFDXjCmcxErgmBhami/1Eznc/Fv48ywjWffjI9YV0OB6/QGzHLqHc0fWRTVvDa8pVEwv3VuErZ31yPi/MMrkNX5ApOuHLChttmjPxt0ZQS2YGe7YNaxR++2VZ0rVOPdCOrBnYoFHPjCFsRtRdxDyk4GmT/4i1C97TXJl3RUcANcRYWu2V5kdoyuQHEaLNMH20QJIVvorjJo0TGsD4i6/yE+oWyPkt002ZuoqZDbv4AtIs1J46AWt1XPPuY3v15OSjPWxGv3Xcb0Dggqb+ToWBry6XfBoah7zlx5ifqnbl8W9c81XaBUpSkBKHL+T7wq76ymDZ2KWouyBpzjLNDs+y3uI2FJ9IuznC8n4u9NFFElnximStgRkcVeRKhg/1U8JzoLalpydgXs5HXvTtJwEKDSf+pZk+546qU/Rg80HvBj0OyQ/Gv4S9/kvoLkzvr0hUJrW8idbU4uJtskKKUbB5ntvdZd42HH/7zEU7Y3ZE4OiQ+CRJxmgewf9wnF3zZbinfTH2QWfx7iXR3SyGcLi1cZ+EJ7qZCshv3Y4Gj2ipaf1SJ3fe1GgnYvtcEyqnpc/OYk2jqEIfjZPy2oMldgkiB4tnEIyE1jSE/elrQYU+U5yNvJ6PlE+UflufrgG31qf29Fuv7CgeAyVNU6720HtEEarDLAKIdDC1jfL9cg5DzdvG1Y52fAbEjNiv8iSDfuwTRW5xEVSZiFrxF0rCbBLLCuws+dpeUH//2YewR/B4hUV/vKZbZT3lnTfSCHea/JFp8sBNoYYWmPcRH/faSM65Pbl+Gp8NlPO4cscyGsAoptgwjbOa8n9wxclSU6sZtYItKVkslL0431Kyhcqmqn1WqMnrnaA57+llFr/74JY290UT0EjvaqH9LZXLTOVJusP9vbbfMsaM8+/uISZ9Z4LT3x5bVEoxvO95gZk9onBnfWp6
 qk//kFEK
 d+zoTuOA0Kkfk+wPJF4idrPWL5NUe42ucO7GcNYJ3ylBQOdgxhu5UTNckVI2MfOd/hCDYo2p92jmYIHmlz1w85yOmtzoE9UepTxa1ZrAjqvIM4H+LkHWTbpyZOzcLi4f8/OLup0KojHOEYwDkxioAl8X1d1lwaJy21zvmXrUbH/qj8TvOH9hnM2T2MQRDcWgO50pS0rAXCbl9cqxgcPbHtB6crw3v/V7fJrXTQXYPXgvzUTZG3rKkV46NSq27TqS19K1XFp+7Sn/ayI60aBZwGIFEbeDBcRu8RgJsRW4x3Otksn6BixEHwABwbfb/zzuJq6Ut6oXRQ1vjmyw2BOKBIu4LkK6ibs5dhjug2Kr+1JWnGGT4D2Gjav4vLqqQrTGFnKjUXoPZ7Ct/jwgtxWO118YPd6+2ttibLCgjgnIGl9U8Y7fG7kEPTLpnTjbfE187Neas4eXUk6XVDInfDL5F4oUh9QjDZ9UNuDPvhd82VKzWRi9PAzxmFFVtU5s5IX22NUKI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


> UFFD_FEATURE_WP_ASYNC made DAX mappings eligible for userfaultfd
> write-protection, but the DAX fault paths have never fully supported it.
>
> DAX faults use vmf_insert_mixed() and vmf_insert_mixed_mkwrite(), which

Should we use vmf_insert_page_mkwrite instead?

> treats any non-empty PTE, including uffd-wp markers, as an existing mapping.
> A read fault on an uffd-wp marker therefore returns VM_FAULT_NOPAGE without
> replacing the marker, causing the fault to repeat indefinitely.
>
> PAGEMAP_SCAN can also write-protect a DAX PMD, but the huge DAX write-fault
> path can make it writable without clearing its uffd-wp bit, breaking async
> write tracking.
>
> Device DAX mappings requiring huge-page alignment and cannot serve PTE
> faults after UFFDIO_WRITEPROTECT has split their huge mappings.
>
> So let's just disallow DAX mappings in vma_can_userfault() entirely,
> making UFFDIO_REGISTER fail with EINVAL.
>
> Fixes: d61ea1cb0095 ("userfaultfd: UFFD_FEATURE_WP_ASYNC")
> Reported-by: Chris Mason <mason@kernel.org>
> Reported-by: Jingyi Sun <1045704958@qq.com>
> Closes: https://lore.kernel.org/all/tencent_1874C71D4177A1624528043E008DB1A5EF05@qq.com
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   mm/userfaultfd.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 169f681f9849b..6656233d5dcc7 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2131,6 +2131,9 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
>   	/* Only mm-backed memory can have its faults handled by userspace. */
>   	if (!vma_is_mm_backed(vma))
>   		return false;
> +	/* DAX fault handlers do not support uffd-wp. */
> +	if (vma_is_dax(vma))
> +		return false;
>   	/* Core mm may discard droppable memory at any time. */
>   	if (vma_test_single_mask(vma, VMA_DROPPABLE))
>   		return false;
>
> ---
>
> base-commit: fa4ad798f6f681031775266044ba1b0cf3c670bd
>
> change-id: 20261118-dax_uffd-0fb2c6d1c087
>
> --
>
> Cheers,
>
> David
>
>

