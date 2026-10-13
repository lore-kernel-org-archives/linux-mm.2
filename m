Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C22B8CC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 17:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E7FA6B0088; Tue, 13 Oct 2026 13:18:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898C56B008A; Tue, 13 Oct 2026 13:18:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 787C26B008C; Tue, 13 Oct 2026 13:18:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3C46B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:18:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D3B24400E9
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 17:18:02 +0000 (UTC)
X-FDA: 85318260804.22.BBBDE26
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012060.outbound.protection.outlook.com [52.101.43.60])
	by imf25.hostedemail.com (Postfix) with ESMTP id CFB0EA001C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 17:17:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tJ72ARPb;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791911880;
	b=xwqy9p5ONeH3JL1qWaq0IjXbxh1aqULdomFb1AjArr9pcoFXb9EGK1Nwr0/Inu8XcYY3k9
	LEOt85TYd48mDPFtE2X/qh3Gq4ZM2J2OFzfsQSxbD5/yyT+kF4XmGXIPu2Rb5wfN7uSDhW
	f7Uq/X9bhYiFu7Ax8oWYgKKN2urDYoU=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tJ72ARPb;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791911880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wH++rHX5RJ8pU1kte9xB9stYVy5Z8Gq/JolXseyDHUA=;
	b=TFCxldx3XlLYbJI3QlnZgnZUxEcghhsbnu0Pb0jggUrKfSCqcVPJCiIRJtJ4yk/b73A5EF
	JmZoGUpozy41emmddt3UuclMSlS/NplddGUojM9yDEEDgD80MM2o/aVTIGREl2SwqBDxf7
	DT+PCVqXNU5bJCbSOY3scPszzHXMv1o=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jQRzIy+O21g5hrFKihTfV5zuDt1JgK5sRXVgte8NiemklFZut/rG1ZIQPLDjVRZlD1loXtdnWgdvdMqq62ycyleK0gi0VnOf+kns6LX0nW4VEg2AUunIDKFaIPSCcooGg/79wtD8NNtJi8yNEqo5AnIJZz0t2k0rKfmsD4vqJb2+X7+VxRAT5Lc2WmezpRSYkLWqL9cytpKM53vYdPOZEDkq2fhBSYH4ungGXnTyv6OVZJdVStc+YByGl4mOw3BPDUTKFvyLIKnT6ai66JxVCfJeX483TFHFSV8Iu9PpkSRmCyNpseswjAFUPFI/V6U4BDteTJxIV1PExSUHlnakrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wH++rHX5RJ8pU1kte9xB9stYVy5Z8Gq/JolXseyDHUA=;
 b=M3TLkg20gv0YAyVfIpOtfjv1SLgNB0NLU0CqUioWdUTJXRncjJeblFpgjaJ2d9wNNB7+j0N/Mhakovy341ywY3lbf0U2/nO8tTDYGfXfWFW+K2ThEQQ1VDVXPU9aaAwlw2kqHQ/jGKPrTKjdKgy1Ow7USfN+l3KE+WP1w2vJYqI0H57ib83OEVbuKGzIZfi3ToRA/mn6OC3jNLgZPTz+fXeo+VSzIbOZzpenEhoLUr254+9ufPfeTg3XPOyQoPdOOrzFl3OZkcWjo7/KqxfdXJv2RfVbtkcuBfxD0znMqbef+JxocrK8DC8o8pmCYYUsAuY1hsQuBndPv19KcCRmCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wH++rHX5RJ8pU1kte9xB9stYVy5Z8Gq/JolXseyDHUA=;
 b=tJ72ARPbLa2GG7OMlxdTaHIYiHFYF2jx0+AUaAyKsCWitqy79nc3/m3kjxscuOUrbsIBbvjXD80YVG92UoIYp9S0uZRvrAQpZ5sQzMWcGrwBkIgfNz87FtdbbVjFJcoT2ta+0324EHdWhsYO59u0Su+4gX6nx3P8DPEIRVIVIsABemvBoCp6MriITL8ynsUoAt06uvq+9NtOjYLd+l8DY4wpgwelDglEKR/EU+Gf3UvouJ+i0sJ8TtFLxgacI3QlB5YGYFxg9GlPM3O1BlVC3JxtWcw783y5iSGCPnILraJQaqYoV8uqEaExcsk52KqQzK6oLFS3Z/CxfCcFnK/Kxw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH2PR12MB4230.namprd12.prod.outlook.com (2603:10b6:610:aa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 17:17:47 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Tue, 13 Oct 2026
 17:17:46 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 13 Oct 2026 13:17:44 -0400
Message-Id: <DM3VQQ8KZGGF.FODPE8YAHBE7@nvidia.com>
Cc: <bpf@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: "Zhen Ni" <zhen.ni@easystack.cn>, <ast@kernel.org>,
 <daniel@iogearbox.net>, <andrii@kernel.org>, <eddyz87@gmail.com>,
 <memxor@gmail.com>, <martin.lau@linux.dev>, <song@kernel.org>,
 <yonghong.song@linux.dev>, <jolsa@kernel.org>, <emil@etsalapatis.com>,
 <ihor.solodrai@linux.dev>, <akpm@linux-foundation.org>,
 <vbabka@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>, <shuah@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 0/6] mm/page_owner: add bpf_iter and kfuncs
X-Mailer: aerc 0.22.0
References: <20261013122125.843451-1-zhen.ni@easystack.cn>
In-Reply-To: <20261013122125.843451-1-zhen.ni@easystack.cn>
X-ClientProxiedBy: YQBPR0101CA0259.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::20) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH2PR12MB4230:EE_
X-MS-Office365-Filtering-Correlation-Id: 890d9bdc-a891-45e5-18e8-08df294de663
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|6133799003|22082099003|18002099003|10067099003|11063799006|921020|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	VUjnwpW+IBisauPGGqJfjPbCGTagrIF9wrCi4kshjzMC1UADgGhYzbklqyg9+OeWcyJIOb7+7EKcoHsGnzMHVWNEPluOldXj3jXu+IFvOczd8NLt6z8jbatT0Mx7W5PO9ul3o+OUyu/Ve6q80i7OJyOsw5D2gvTDj1it0GAnJ1ilUROFa29Yax6EUKfqV3ZAy8OFjWeQJLM6O7Zwa3qOv2e4TSCz3lIk+bBvX1tio0LQiKJhSwzU8ANTYaUUsxw1+F8+0vVcXXCp25H52b1AUuenJvb8gc8Qx6OOn0bRLB5Ii0E1VlxUHyuTFaeRgPRgAC1ZRB8KT11euZmSHAlkJTWLSmh1fEo+l2r0rjwsXHFAAExxYL9n+cMWLOuIisUg4K3oNQDRJ9HVD4QHzMfn8rlKiYbzdlXQVZrAr1daOetwZW/zIdhu65fWLhvO1rrnR+khgqlKQhAHYBMNyQzS67VA9GrQ4CsFU8WVdftVe3iiHD8ZXuS++SvreOAo1iSfXVS7kYbM7ft4CTGuLIvAHuZT3xk7Asvlz3DR/bpTJG+8AmhJxc4qIHfnqfUopt04W8pE3kP7y0vbTGWyLp6ib0VzdtBoWMAUybGPcAH2VoqPS+UaHGhpTo+b4j1PgXmEC/00fPlDMnAsN1rynKUqOE56A6be3uSyqrHL5PV/ptfrSb5XwIHnOmjVvJvQutOHMZ5fhnflwIC3Clki2VqEqQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(6133799003)(22082099003)(18002099003)(10067099003)(11063799006)(921020)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cjY2dVdpYitHV3IxZEpvdE5YcVNGMWZycW5TZHVyTi93QlBJZkpNY2t4K096?=
 =?utf-8?B?NkNaamthbmJ2MXZpRS90M3VSalVlbUhtMWNIQlpaVTRFUnMxeEpqcGh1VVVn?=
 =?utf-8?B?N0FjOW5uNzIwczc0bTdUem5adHhEb09SbytmTjlFUlNQcERoTndObXhhQlph?=
 =?utf-8?B?WU0zMUdDejZlZGR5SFRDZXhHdERCVk82SjI3SkExM09FTHdLdTkyOFEvaEZx?=
 =?utf-8?B?SUYrKzFHa3hTOTlwVlpNUC9qbldaak42WFcraTM0clZISnFkaFQyZ3k3TUM4?=
 =?utf-8?B?bjU3L2J0ZXQwTEpYb0ZWQ3B5RWN5bEt3L0poS1pQZDk2MnFYMk50QmR4ZUJZ?=
 =?utf-8?B?VEl2bmxxaStpcXVTaTVkMGVIWm1xWVZFS1JYOWx0RUxLZitiV1RBMEx3QjBn?=
 =?utf-8?B?ck5HeTBxdUNhRXYzdjVNT0xrL3RwU0xSY1pFUWQybFIrQUF1U0lGTm1BY3BO?=
 =?utf-8?B?dmFnU2Q1bjJOVVhjMmt3YlNSNVQ0UXNKcm45R1BIMmthclRNOGJIOWZnbWQy?=
 =?utf-8?B?M1VxeFdFK3M0c1RvcW9mTElwV3BWMmVTNnNRbkdHQjFROTRMK1liNktiNXdX?=
 =?utf-8?B?T2dwUTZsV0IwVWYybnJCVlA0VTh0SXFZNWZzLzFJV3dCK1RjSHA0TENOTEhh?=
 =?utf-8?B?R2JyYUI1ZzNTcXdXZ1NDek1Jc3FMSGdDMDlrMEYwMXJaNWVaVHZpL0xCNEdh?=
 =?utf-8?B?SlVpQjEya1NIclRNTVFKaVgzQ2xEdmRCN0NwR0F0RHVuRmNjcnlhczRuQ3Rv?=
 =?utf-8?B?emhzaTE1Nkk2WXEyRTZycXRWTzFsVU1pSWVpNmphQ0dzQXZOSHVRNkpOOXJE?=
 =?utf-8?B?VmJSMlZ3YWY0NkVtRzV4ZjhtV3BHdlIvMlJ0bFF2bjBSdmFhS0FnQVdsTTgy?=
 =?utf-8?B?aTNNNDA2Z3FqR2JucTkwbHU1Wm5pc1NyaGh5MXNET3JvQ0tiMGQrLzBESXIz?=
 =?utf-8?B?VkJLZ2NzNlRXS2Ruc1JrQ2tkWVNhYkNhUUlOR0pXSkh2NHJRL2Y2MW5lS2tl?=
 =?utf-8?B?R3hJVE4xcTE0MUZDZ0VzNDdEV1hYdFQvSG52VlNGQlpaMFJSZFgrZHgzTGRZ?=
 =?utf-8?B?OS9obmFhKzVFN3hNWERFWE03Tko1QXVOQnJIUmdqV1dOME9BVVoya1pQNUZR?=
 =?utf-8?B?cFFxUmtkY0VCemluTEI2dTB3MlpGcWhSVE1IT0o0WnA1angzK2RJNit2Snd5?=
 =?utf-8?B?eXZDM3E1eC9oMjhSTkFVYXhxNGtIR1VPNVRpVVRaMVlndG5iVDFVR3V1ellE?=
 =?utf-8?B?bGtJRXlzT2d4aDdvTGVDUE5TSWdLbWQ4L2k2UWdzTG1ZamdkUDhIMU0zK0xX?=
 =?utf-8?B?QmpoTUdCZGhpZ2NhaVRJZkk4TXMvNTVRNFpBRVBDL0NUeDdNdTluM0trbFFo?=
 =?utf-8?B?QThaakRMMUJkVG1JdVphY1VhNFA4Z2U2UUo4Q2NaMHFCMFdUVzBSM0hOSGZG?=
 =?utf-8?B?dzN4VzRIVHJDRnNuTTNudkZEeTQvOURoNVpJYmN1emxva041NnFoMEZ4Tk9Z?=
 =?utf-8?B?WWM5NTFVOG9RTmpRS1g4V01tbWhROWQvdmM0NnE4NHV0MkVNR29ia3ZMcmdj?=
 =?utf-8?B?Yjg2aHdKUUJReFdrZ1JYenJGOHh2SUpRYnlyLy9sb0wzVnFTd2ZtamIyZlpv?=
 =?utf-8?B?Sk1NMnc4UjV5S0RJQ3RQVFd5aC94eHM0UENXZ0JlcllSTjlUQXI5a3gzbHNV?=
 =?utf-8?B?cEFLNmNrZG5SenhZazhzeHcxWGlpMG55U29zQko0VTFENFM4WHNiYjZDaWt0?=
 =?utf-8?B?MXlQTGJyQThZQlVNaWJWRDlHc0k5VFFSd0JjaWtGUGRGbU5GVEJnU3FKNmJO?=
 =?utf-8?B?enFjZWJYYzY3b2FSS1I0QWRoMUxRU0syc0Y5Sm9LMDFienNVOFZNVHErYWJ4?=
 =?utf-8?B?Nm1xQXdZOWwxd0R1ZFQrTFErTXZ2M3FJTnJoQVJRSmQ5RnF5ZmVYT3RzdDhY?=
 =?utf-8?B?dFpsM3lUWW1KWk85c2JrTzJWbG1ZajJzUDRzUW1WVGtpUzJ0WXVKdXdFWHhs?=
 =?utf-8?B?NXEvZDQ1UVBjcnhIWDdERFdoRytkSWgwMTZvZ3B3MS8ydTBUdWpUbnFDamxX?=
 =?utf-8?B?SHZsRW1SVjIwMTZ0UG12dXBGNUZMNUNqbFNSYjd2b0puaG1sYkUyRjYvaWJZ?=
 =?utf-8?B?b0FpQ3RLMEs1RWVpUzRrVGowa3ZIbWlybWwzUm1OUjhVa3VBOVhUOHNZOGZE?=
 =?utf-8?B?cWVHcEFiUEo5QjNWb2VvWEZuZFFiMXVOM0NuSjQ4cWk0alJYYUY2RzlXbDhL?=
 =?utf-8?B?N1RWbUtBRFJpUW1KRklUYXZZVTBjaWhzWS85UlZRZkNiejVYNVNoSXFvb0da?=
 =?utf-8?Q?iUm+aElHqw0969tiJW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 890d9bdc-a891-45e5-18e8-08df294de663
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 17:17:46.6494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eMSQfLI8W/dLoQ8aKZLldWjoD9wQPWQJi+Mhc+jM/wKwveFdf/Bu+dGIngCjtS7e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4230
X-Stat-Signature: 9gbo5qpkznysdc7cdxqi5g5anoe8c755
X-Rspamd-Queue-Id: CFB0EA001C
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791911879-659364
X-HE-Meta: U2FsdGVkX1/9zMT1KkK6U5H42R24b57T0TzoZUlzQKtaLnNvQk0MLSfV80EfiVEtlcCRiETbVF/0Z75QsD1PQqySID6GgQf8LJB1Q2eu7CRTPSHJw5DTr9S9N5iC9C4ztWUhNFmnXrDbPNX0VSwRmpGEmaFX0wCMHfXmH+4dOZEEX7G55X/e3GlpewgENW7o5dJyh6pAQk7O8eo8I59APoYAliP0f/8ComKYJTy34Pw9kb9HYhoEH7K/u47wwdEzykpVoMC6J3vHuHvvQNvQp3UgjD7N4Vn4V2LJuw3HCTrSbcyXecOb4qQnpGwAtMGGr2e0TBNXGdfbhDK4WhKvhCLuOTUjGKAHCHY/JW0sWTbzplIMjwWnOwUP7qDTLxDghME4j/il6V021rrIU83nVF+PWnlyCI8PFAvz0BlS/jNrJpMIgP0JKxXmSw1Si5V+3l5xFdrF/Ur8fu3LbBs/4P1NvQEpRFaJ0SI4bpUOxa5KGC9w0aRBXK93rq0bS8Qz/JqCgvc4lxcg8Ls8QzIrkJCft4LxGe/pG7zdNjtn2jjsJOe4vXjCuqHsRL7kyaPv5Hrvdlx2dNXzNDhoNE+1nX95QVkPQoDE1xAkTV6/W6Ausv1AfeBV1rLy6+iXPbU8yvdfICuGKBf3oj0DM0wqAxWxFF0ApNne6pTgxRah84rjb3wkKjdbdjUNZyeKL5DNSfQRzLwZnikuRQT3yazedcULFfq5m1vj+obr7vLpi4a5ST52aUCq8jHbCRAclC3E9+cEk48RYe3iJuQtxYyk4FYeQg7X1RaJjMmIx2x3KC3cr6ml9q/4Q7WjcyAzyEgRmBW2e2OjLnaV00SQ2Ea5CP/Xi0oIgsWlZc+INvzEPG7icAU8Dz6K1OJvXp+q6CMjhU6Zi2qUXGhPJcwK3KJqiXTO1vZd1Rfp5L4FlR6hhmgDtwOzdN+qhg61hlCuXo6wpfBnELwj3lD99jH1PQE
 rPsL91YW
 O84u02HQOCDsXTvUJkBTMwzCVWyf4kor7CEekrk6MpD9IgC9hEroudtaO7705avoa3TzkMOTgmwU3Ei2YXeR3FpT5/8Y05REyjatRfcthVLeENRc3Wu2bwEZDpqBwYRAMcGPsD316N6Unl7U/IcTAq1rDW016RJk2wgt+E/MDHCVQ4FPIGUVwZ8o9FfgKRzw0NT65LYcVcy1sh5dTBPQ/phFI2DCskISgudeARCFAjp6bi97IGL8IcXZcMAQqn5+f+fWKT4VqCS8MQKt25FCrGDOmDl9lhfiev8O7zzgzMRQMed2g4tpf/0OYYdwPbeT192wfYZ7OwjAiQLaJhBEX43lYoJh8jyMO50Jshc18X9eUx0ZzyEspVi5XpWrqDClzh4TWdmf6hF6G4yhOh2cau5V8XXV/8/Nd5s5/hqwNt7o6ZQBqG46ONEZ4qTkYJA29CDiI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Oct 13, 2026 at 8:21 AM EDT, Zhen Ni wrote:
> Hi all,
>
> Introduction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> page_owner records who allocated every page and is a core memory-debug
> facility, but it currently reaches userspace as the debugfs flat dump:
> slicing allocations by pid, comm, NUMA node, cgroup or stack, etc.,
> means streaming and parsing the entire file in userspace, which is
> expensive on large hosts and hard to query live.
>
> Exposing the same walk to eBPF lets a program filter and aggregate in
> the kernel and surface only the records it cares about. This series
> adds that access as a seq_file bpf_iter target and an open-coded
> iterator.
>
> Implementation
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> The page walk is factored into page_owner_next_eligible(), shared by
> the read path and the iterators so eligibility stays identical. Two
> kfuncs expose information that a BPF program cannot decode from the
> snapshot alone: per-page memcg info including the full cgroup path,
> and the stack trace behind a stack_depot handle. Each record is
> snapshotted under the page_ext RCU lock, so consumers read a
> consistent copy.
>
> Testing
> =3D=3D=3D=3D=3D=3D=3D
>
> The selftest exercises the seq_file and open-coded iterators, and
> validates the stack_snprint and get_memcg_info kfuncs.
>
> Changes in v2
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> - Route the zero-handle case through ext_put_continue.
> - Drop the scan->pfn++.
> - Fill page/po/pfn only when v is non-NULL.
> - Implement page_owner_seq_stop().
> - bpf_page_owner_stack_snprint() now takes the scan cursor.
> - Buffer args renamed to buf__uninit/buf__sz.
> - Removes the v1 get_nid() kfunc. The node is now stored in scan->nid.
> - bpf_page_owner_get_memcg_info() now resolves the page with
>   pfn_to_online_page() for an offline or removed pfn.
> - Buffer/info args renamed to info__uninit/buf__uninit/buf__sz.
> - Drop the get_nid kfunc coverage.
> - Enable CONFIG_PAGE_OWNER in the bpf selftests config.

Hi Zhen,

Thank you for your patches. Review focus is currently on hotfixes and
patches already in mm tree. Please ping us on this after the merge
window is close, if no one still has not looked at it by then.

Thanks.

>
> v1: https://lore.kernel.org/linux-mm/20261009112308.240769-1-zhen.ni@easy=
stack.cn/
>
> Zhen Ni (6):
>   mm/page_owner: extract page_owner_next_eligible() from read loop
>   mm/page_owner: add bpf_iter target "page_owner"
>   mm/page_owner: add open-coded page_owner iterator
>   mm/page_owner: record the NUMA node in the scan cursor
>   mm/page_owner: add bpf_page_owner_get_memcg_info() kfunc
>   selftests/bpf: add tests for the page_owner bpf_iter target
>
>  kernel/bpf/helpers.c                          |   7 +
>  mm/Makefile                                   |   3 +
>  mm/page_owner.c                               | 219 +++++++++++-------
>  mm/page_owner.h                               |  58 +++++
>  mm/page_owner_iter.c                          | 197 ++++++++++++++++
>  tools/testing/selftests/bpf/config            |   2 +
>  .../bpf/prog_tests/page_owner_iter.c          | 193 +++++++++++++++
>  .../selftests/bpf/progs/bpf_iter_page_owner.c | 159 +++++++++++++
>  8 files changed, 758 insertions(+), 80 deletions(-)
>  create mode 100644 mm/page_owner.h
>  create mode 100644 mm/page_owner_iter.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/page_owner_ite=
r.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_page_owner=
.c




--=20
Best Regards,
Yan, Zi


