Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2298606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 21:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F10126B0BF3; Fri, 23 Oct 2026 17:24:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9A1A6B0BF4; Fri, 23 Oct 2026 17:24:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D61446B0BF6; Fri, 23 Oct 2026 17:24:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A924F6B0BF3
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:24:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DF529C01D3
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 21:24:11 +0000 (UTC)
X-FDA: 85355169102.21.9348BEC
Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020104.outbound.protection.outlook.com [52.101.196.104])
	by imf21.hostedemail.com (Postfix) with ESMTP id 34CD61C0009
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 21:24:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of atomlin@atomlin.com designates 52.101.196.104 as permitted sender) smtp.mailfrom=atomlin@atomlin.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792790649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=puw/qPN/2s5qKranZlNIwJ7ickyu90fHGW05cGQJZq0=;
	b=XlialaSEhS4k7Ii0P6KwfqNYNOCfUyesK1CZebN0B8JJhCqUfvU1GsoZIL1zu0jpbqUeNc
	pp7MGAO8GJtBwv9yf89PUduvHBv4Jjck4jax50D8gj1uHJzBODiBhg1NVAscwZ78bL1XKc
	PWtMQ+Otut1bJeALwobqdCcbsH2Hh9E=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of atomlin@atomlin.com designates 52.101.196.104 as permitted sender) smtp.mailfrom=atomlin@atomlin.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792790649;
	b=epGf/NHPR9kgDde5TjlWj1/vryMpdcTUoXbOhOHkkl1hbMf7q/fNPhTP1xQ1mA8q6DEPNx
	lK1Phf9FZ7Y0WHwW9/mE7JBeQhE9A4kwTKIRUuS6f8PcORErKOUD+V5HjIWBVRB/CfUGrQ
	IImYwdwahhMmoujb3qN0i/fUBhoCQ+I=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LlOITLCPbXKevFVo30XE2rgtnIVaM2HNuvkjTog8XzKC0/JZVmp5zpPHgRDOZRvzZ1VaeAuErXRZsYtZroUJxaiM7znfXD+dYKo062VfhvzRTNpk484s9CQ3ua4F8RABDS9MQEurnNHooHpCsYgf1yK4h7o5KUbXWoRkKnW+4p3ShOdE60WoRNz/hK9KpljZvgMbPhoYBepc4NygkU5Rs7NTEFXilmYrc+7wY/OkKixjqRM0lTOQgZgA4SMJj9N0+z5xC2SUZAwD4k7qcycUzDnVEbQYsFpgC0feVIh8jS5PoUrup58qnEEVn1iaiu8XkHqiiThwDR6zNgt95ZLWaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=puw/qPN/2s5qKranZlNIwJ7ickyu90fHGW05cGQJZq0=;
 b=pixiNQSBHx3Wo7vzmU4BBdc3JJX0VuSkylf9oOfqYH6E/s/q0JxV+yJpMJ2CI8W1Td5R11niPFefnzKtvYk8tRHZjFTeKf8OLDvHgeVH+ChvbFXMpVABVRjNGV7TGxFyn80mgywNI9qhfHAz85nQAxdQbKmMLYPZQusCaCQFHWnWDkp+9SFBqDQPJXjtaKS/AYgu/76Uvr56UqJ3146m4ACipclsNvEvEOZg6t7DG0/AEVWpnL8T0XASi8rxoaV0o+OSHx+/C1LsXCu8M2a12mJsukzid9qTEQU/NB/41K0iIaCUTCpsTIrUM0cx/KJK0Pl9QwSshQwg2bLswFxPtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:183::5)
 by LO8P123MB7563.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:3aa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Fri, 23 Oct
 2026 21:24:01 +0000
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230]) by CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230%5]) with mapi id 15.21.0546.017; Fri, 23 Oct 2026
 21:24:01 +0000
From: Aaron Tomlin <atomlin@atomlin.com>
To: akpm@linux-foundation.org
Cc: osandov@osandov.com,
	sean@ashe.io,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] tools/mm: add script to display /proc/buddyinfo from vmcore
Date: Fri, 23 Oct 2026 17:23:56 -0400
Message-ID: <20261023212356.215922-1-atomlin@atomlin.com>
X-Mailer: git-send-email 2.55.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YQZPR01CA0106.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::18) To CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:183::5)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB6607:EE_|LO8P123MB7563:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c1c94a4-da96-4e87-bcb5-08df314bf4a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|6133799003|18002099003|3023799007|56012099006|261022105027099003|261022075727099003|261021121427099003|10067099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	YVVpQYTia7VBPZnzaRJ5RjP+VeU0YR3bBxo2u11/EfZVvjUSjiKVX4ePpdEXAzy1qw5aiLaJmdgtkeKfBa3PRhv/sMlI4tXywuHQ0xxufkjOlkHXzs8DxiSDTr8/ns7vJfi0aN9NzoPg1+bkRiCgn4UliyYVI5ZJ4FK4jctIFXEJyAL8iTC3/aFXMYNCvCxLzBCIPPLrLmvYFw3nWCxrGVDz9Xvje2/MvEqaD4Ix8K0gMRVSfDCtZX1X5Y0+zPqFmhOMYtmxl6bRyIDW5WzM9hW3YxkZsN2CZO+IRn9hjadNn6DlOWQekFGvwPnLaBnwCFc/9y9lsl+Xq+1sQ4bcUbi8i1QgAuu8F3sODMFkyH/Rc8G3o8j4JoS+l734ZnQR/+i40IxXoiA2BBy74BO++ftq3wqJK68hMyb/V+jNyIfCXOxkKNjyd4yOlXZtgIphTdzdSmo8TIRzDLpTOQH1DA0+l/pxzX8A8HeS5Ad3IJt/6Y9fv+HccJAkth9aMYSlVTrGz/FG4HatAvVovE57FqKK4fur4YBSNr9mWvNgzmNwXDAse1JmSXdFsfZvchSVG5OEBEXA1raimSx+/GSl+WZ76h6742V4c3M6198nyezTjJjwSYru1diCG8FI9FKlWuH9UzR8k6HoEntnEzN0Wu4RWCX1GeA/a7uoGJR7XX8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(6133799003)(18002099003)(3023799007)(56012099006)(261022105027099003)(261022075727099003)(261021121427099003)(10067099003)(261009223027099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TWQrWFROTHlIVW5NeTlKZkc4T0loNFV0Q01hVXd0TG8vSFBaREtaOFpXT3lv?=
 =?utf-8?B?L0daYm9pSEFBL2p1c0pMcHJPZHdNTTN6OFJVSzRzYU9JejJNbW0zWUUvOW9S?=
 =?utf-8?B?MVBqUE1Kb3d1cWhEM1lvR1cwSDRrUE5aS3J5Rm9sNVc0U01wVnVpQXBTc05h?=
 =?utf-8?B?QjFrVklwZ3lPbFFEQnIvMUJpdDg2bWZoWkI5QzkwczJmWDNVL2FJcWU0R1RD?=
 =?utf-8?B?bzBmNGlvanlyYkRpY05tK0h4bjljOTlXdGU4L1o2Z1ZMaWF3bnVwSjZaNHBO?=
 =?utf-8?B?RkE0cGtoR1k5RlplWHZ4OFlkb0k5OGFlclBYWWpRNE9ZUUZDMCt0TVdDZWhO?=
 =?utf-8?B?RGUvMjdKSXkyWHd0SlBFR3dHdEUraVJDUWMzZmhIMzFUeUI0TW93dDdrbGdK?=
 =?utf-8?B?WXRlc0haVTFJanJ3THMwMnQ0MXhmT1N2OTFwbCtha2hIRzlWWnU2Zm1hOFV1?=
 =?utf-8?B?SUI2aTQyLy9qNm9DUnFneEgwSE9Md0V2dlQrSVFOZHJOY3F5Y1Zud2JxbVY3?=
 =?utf-8?B?cU1tVmxjYnNGejM5TDdIcjFWUHpYd3hEVnhqVFNpVnFxSm5lTnVVN01pVENn?=
 =?utf-8?B?NzhpVVRBMGhkWndFK3lOTlZSNG5aNzlPVDRpeEpOQUl4NzFmSkJsdW5sLzFU?=
 =?utf-8?B?SUFVMzdRN3g3S21ma21JVjJDWmU0aDVGSStFZEY3OHBRT05lenE3eVNmOGYr?=
 =?utf-8?B?VXVMNHZZQ3Jyc29jdCtmTjVsSUpkQ08xOXRTYXUxb0tlMGJ4UWZNUTFrQWJH?=
 =?utf-8?B?c3F5SDc4N1VkZmRwUnZ0WCs5Z0JrK21JcnE2NlZkbFc5RTlIc05LTTdqR2xi?=
 =?utf-8?B?T2dGbkJod2NMVUNzVFhkR3I5d3BxekR0SFZKeFBBb2tINjJReTRybjA5dFo2?=
 =?utf-8?B?VHV1cmMyS2hPS3V4bWxTZkRDRzIzWmJ3SVFGMWk3NmdxcVBVNTc5V25LZktu?=
 =?utf-8?B?R3BBSHJMdG94T2pQSThvMTRkRk05dUM0Q2VjM3NCaGxSZ05tRTNzVHBuL3dX?=
 =?utf-8?B?bEtJU3M1ME16S1ZpaXdNRzFoY2x5Qnp4a3l4UVphVkhrNTRGeVRtcEtVQUt4?=
 =?utf-8?B?K3JNVVNvaGFXNzVBNlYxMis1WWV6Um5qTjlFL2FaVGxMNk1kdGtzb3pqNmVV?=
 =?utf-8?B?TFlxTnU4d2hNSWFqVVQ2OFlOdzhNM2oxbmRPZUtickszSnBvd1pnVUNVSW1L?=
 =?utf-8?B?TmJwdDBpdDI2VGt4VW1ndTZyZk03RVFOYXF6NVZtdFRaenZBbDVNWW9rVHU1?=
 =?utf-8?B?ajhJTlZvcU01clE3TkFiSzMxdWd2TEpsVCthSDloZGZkaldiQ29XTnJVeGRB?=
 =?utf-8?B?cmMvTGthUG5DdzZoYzU3Mzl3TGx2bm4rWi85L1RUOXg5YXFLV01hVFFSZTVr?=
 =?utf-8?B?TlUzQXNveWh6bTg2Y3Zpa2dTTmIvcDRQeWY1RHoxYVJwRDVFbkhVTDdCa2tB?=
 =?utf-8?B?UmpQVnhubFFDZU56U1NaT1FFb3pKZkhxZEExTUdqa0FhOVZHbHlnYUo4Zmx6?=
 =?utf-8?B?YmRTZWR2OG9sMlFRUDRudkFCVlR6cml3ODhST3ByKzFjQnBYQ2RydWVaV2lF?=
 =?utf-8?B?ZkxkYW9ucHJLc0lpZ0gvQVd3RE90UXNxR2NxR0VnM3lOaTRENFFFOVZvZGY5?=
 =?utf-8?B?T3k1cGVFL2oxR2g2WE9KMmZBNWtjMmw1TWhya090ekpneTlNbDJlVWZtWjVQ?=
 =?utf-8?B?ZlNKNVZRRW95c1dJbWc3SlBCdzhTOHk1cExLOVRONDZOckozejVWRWNvdEZS?=
 =?utf-8?B?TWFCc21XbVRHL0ZmQU1aOVpheGtZS0dqRm5jVVN1RUJkT0dYRHlUYlpEVWJL?=
 =?utf-8?B?YXlXZjlpbTVSZ28waW5vRCs1Z0RETTZzNEd2ZFBLTDZlS0FDSHJmWkx4dVRr?=
 =?utf-8?B?KzNrS3V6MS9OelJqQS85SFQ1MDMxTkFPMVgxYi9LUjczWFdOeTc4d2Jxalpv?=
 =?utf-8?B?ZmtCMG1LeFpkNGt5SkxsS0FKVW9hWVRBcFdRTktHeHNRRFo5YXJMSlJYNkZ6?=
 =?utf-8?B?amdCamdPWEUrZUxqWlBteGp0aVlJdHFrZ1dveW91bnRIcDJYT25hTnkrVUdF?=
 =?utf-8?B?L0xvbEE2SjZNYjI1QkFGR0FXUmRXRXA3b3FFQWxKNDhCaDVaVk5POTM3Sm9j?=
 =?utf-8?B?RW15SmpJdkdnZGl0aWZXcm0zWUdSdE9jSnB3amlJZ3Z3VTgwQlJ3Zng2Z3Mw?=
 =?utf-8?B?MzlrTjY1L2ovUEowK2d1TmRwMm1rcUJPNkNpYUtCL1JzbXFhSnU5ekhiUThr?=
 =?utf-8?B?SGY5aG9BcERCVHlETkpaUTdsZkFLS3cwcXh3RGl4V2IwcXhzRS9HdXVEa0Nk?=
 =?utf-8?B?YXVPWjVsWGpzMGtVVVFrT3FlQStsY2V3dkE2Szd2UUlkNCtld0ErQT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c1c94a4-da96-4e87-bcb5-08df314bf4a6
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 21:24:00.9323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JTJggsP/zYUWcPMCm+o2gNvpvyINUpJgi1RMVdz4cMy5A6+tTSZmR0lyWgozTQoPzRCnYM0fMlMwNjBsThzepQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO8P123MB7563
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 34CD61C0009
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: apecpprdeks9euapghnxqh43g3hiyeya
X-HE-Tag: 1792790649-733987
X-HE-Meta: U2FsdGVkX19F+PIpe3yhk3GDB8a+5Esu86gg9lqyaWCD1+iZjafBpOmzjVae72S0vL/Gn1iWmXb/kDKDBBhn2GYVinKKK1K58rTeeahpXvofq8u9LXTnKIxp85TE9uZ568Awu7+GWVeYD4xERVpZCb99q7GC9lzpZTBr8amUAm1yf1GJPgMuEc+5BQRQXBGHY3s61nEdEWkrtyr3wN+uIkCpg+U1lKeEGPi2Jmze7t+fH6/nQiZnqMuGyhFGYgKsrZm+9/aY0Gw0Dfn6G6OWsXOXMLyJ5B4+4NJ+Wc4T9RuCWoEnAxtARzztzKugAgpgQYo7SVtYQNCucjiJ5LNO/WDcC70tNMK+JDYaE8evd7YOtiFohw4lc9E2YL9s2VlsAYUXH/wqHC4+Dr0SVESkB7tJgOSB1K8Bk3aDgIDQ31jhyEVNgevEf8L3XQKn64gSIqH/pfvk5cqQaItW1ALXvZkQGRsDOEpp2x4aZRaBMKaQmOPTAP8gggMpwan5z6s3d3Si5tLbn2HiYL1Etso6nxn6YHJZ4mqGAZ5d2mDOj2u0H846MVNPzNOlTKsmEzchbKLBinS+kkX4Z9h7Rv2E2jnaDsgfSWWrf/SMNXnKatgAzfOyR/2eLjObNhIMg+2dvHuoW/zAPu6E5weu9/kG3lzewI/9+MW8ulwVa75/C5XBs9J5dHkC294S2EcQm2pJp0rmhonNAvhuUacSlzhS40dJsJbeMroMN1Q9XWleqsFpZoXJ7z3yHWIHiCmvuB5+i5bdJL3tXNPVNugo7mGV2kDnMNgJWnRJc8dOAe4YkxjYWlK26MYd8i7I6j51xgFE//k+I0ezlNmXYtrkzaW2PJQqK2ZcCWd48m3rxxX8PYosZaLFeg9E9FtNth8UUf7fkN9UcUnFCccS7V6quPgPxxxUZjD0uFzbfWTb6Rh7vkcp6lKadVuyt4+M9ut3WWSfJmqHDrbh8/97TnqwXxc
 gSSszlOK
 9vJbu5mRwCatYRyuCWDcCYFcrMPx552a58y4qP1cY2Smy4VDirhBk0ZS5xDMG9K6yWNX7SXxzqwBLSidezw043HAOjGL21pSdabCgmZEeb67W6gPAS3sIDr53v2L6DqS1F33ANw9+N0HexNvtII+QGXq/WyOAH0fKTuyy3S6195yKuHP9Z5KiZ+3g/v6dTt8WIgkQnFpw4TbR1qNsue/IBAJt/VL886RCzL8tc/49G3loW3lm1Ui02kQGtRA0Vb3WexKDuu12qU7VdjgRRJPYPmLtSJJi1UHO0sd0N0zasv3Xxz6ygysHF58+LR9esMXTsPUg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When analysing crash dumps (vmcores), inspecting the buddy allocator's free
page distribution across memory zones can be useful for diagnosing
allocation failures, fragmentation, and watermark exhaustion.

Introduce tools/mm/show_buddyinfo.py, a drgn-based script that traverses
online NUMA nodes and populated memory zones to inspect free_area[].nr_free
and reconstruct the standard /proc/buddyinfo output.

For example:
❯ sudo drgn --no-default-symbols -c /proc/kcore -s vmlinux tools/mm/show_buddyinfo.py
Node 0, zone DMA           0      0      0      0      0      0      0      0      1      2      2
Node 0, zone DMA32       907    831    581    423    214     85      3      1      2      2      0
Node 0, zone Normal        1      1    143    731    552    182     32      0      0      0      0

Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 tools/mm/show_buddyinfo.py | 48 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)
 create mode 100755 tools/mm/show_buddyinfo.py

diff --git a/tools/mm/show_buddyinfo.py b/tools/mm/show_buddyinfo.py
new file mode 100755
index 000000000000..70372329e7c1
--- /dev/null
+++ b/tools/mm/show_buddyinfo.py
@@ -0,0 +1,48 @@
+#!/usr/bin/env drgn
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Copyright (C) 2026 Aaron Tomlin <atomlin@atomlin.com>
+
+from collections.abc import Iterator
+
+from drgn import Object, Program, get_default_prog
+from drgn.helpers.linux.nodemask import for_each_online_node
+
+DESC = """
+This is a drgn-based Python script that displays /proc/buddyinfo from a
+vmcore. For further information on drgn, please refer to
+https://github.com/osandov/drgn.
+"""
+
+
+def buddyinfo():
+    """Display the buddyinfo."""
+
+    def walk_zones_in_node(prog: Program) -> Iterator[tuple[Object, Object]]:
+        for node_nr in for_each_online_node(prog):
+            try:
+                pgdat = prog["node_data"][node_nr]
+            except (KeyError, Exception):
+                pgdat = prog["contig_page_data"].address_of_()
+            for zone in pgdat.node_zones:
+                yield pgdat, zone
+
+    def populated_zone(zone: Object) -> bool:
+        """Determine if the specified zone is populated."""
+        return zone.present_pages.value_() > 0
+
+    prog = get_default_prog()
+    for pgdat, zone in walk_zones_in_node(prog):
+        if populated_zone(zone):
+            print(
+                f"Node {pgdat.node_id.value_()}, zone "
+                f"{zone.name.string_().decode('utf-8'):8s} ",
+                end="",
+            )
+            for order in range(len(zone.free_area)):
+                print(f"{zone.free_area[order].nr_free.value_():6} ", end="")
+            print()
+
+
+if __name__ == "__main__":
+    buddyinfo()
-- 
2.55.0


