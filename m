Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A34FA606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 09:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gaisler.com header.i=@gaisler.com header.a=rsa-sha256 header.s=selector1 header.b=jrLifdb0
Received: by kanga.kvack.org (Postfix)
	id 9742F6B033B; Fri, 23 Oct 2026 05:22:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 925756B033C; Fri, 23 Oct 2026 05:22:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 814496B033E; Fri, 23 Oct 2026 05:22:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53D966B033B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 05:22:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB5961A0377
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 09:22:34 +0000 (UTC)
X-FDA: 85353350628.11.D8D0A8F
Received: from MM0P280CU010.outbound.protection.outlook.com (mail-swedensouthazon11022075.outbound.protection.outlook.com [52.101.77.75])
	by imf18.hostedemail.com (Postfix) with ESMTP id AC9F51C0005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 09:22:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gaisler.com header.s=selector1 header.b=jrLifdb0;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of andreas.larsson@gaisler.com designates 52.101.77.75 as permitted sender) smtp.mailfrom=andreas.larsson@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792747352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZxgyOtelA43xGyCqL3z9foI6VDBnALn1MNcl+ea+qCY=;
	b=8GluwN9+2u5upG0t8WJ1KBI5LKNmyvhL9s5Wk6PUwuuYHC0KhxbgZpM3bOc/P4PLJWbG7O
	zYoU5duDaphXWZYUVHM1LX/siGpV6B1MfSE/Hm5sx7UCUtd/vdu5G67hdRyz+mxcInJ1o/
	HKtBatZxoaFYnfoZrhqJ+C4rAolTGBU=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gaisler.com header.s=selector1 header.b=jrLifdb0;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of andreas.larsson@gaisler.com designates 52.101.77.75 as permitted sender) smtp.mailfrom=andreas.larsson@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792747352;
	b=00Tsia+eHBMUSnMurkLKPoKSLBP2dOFpkWvfxNwGilpt4ssXsm9nGB3yT3p1yxRWmubMB7
	WM13D1QBUPs5oiMk3l0nAHgZ0YJrjlBjcvc9Ncq0dOWB1ytdAhJM1w5NS9ttPXAN7b50ts
	QRbR6/8Vs6C29eRt7jnCK91BRDGwMfw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HMF/nujSRtJR8eXM2vG6K+q3QB2802nqcHAI34mwuQ7lxbDuuscWO6t2vKwXY47emkbmeuOp7Dz328Y1oxOvTbsNW63gWr2+Jx/ySxfMzRrnvW0EsAyR0zr6LIdRR6T3qt5reZbs9SZj2PDk/g7WaFSdkkfUcC9xbbjsokXwB9rrqhqZsdch9inc7GamJgSO2p7h7kgGMgpGF31NwCcFF8ZC155/Jx/yuF5KJFJ7nzWITP8zLuMrsOGyepPAGty0W5zdD5uCMKN9OSjjmu+7b0OgXfxenKZ4if+ThUVi2uDIdd2r19fZyEvGRXzu0/j3XYZyF6mp9/HHiP8NLOV5QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZxgyOtelA43xGyCqL3z9foI6VDBnALn1MNcl+ea+qCY=;
 b=qmjHLQ1i1yIViO67z1gL3PPqzHjLQuQ6M+V3ZVhCiP0TnqhI83/eNYZltrj37g4zCexpltCiS3q77WwLK4Dhc8/pv+jAbTqGRioXYCvyKMqmwTtaoW09VYJZPD/jzo8VQhHetQAe6O+ivEoqX0MSX7ifFYCxWJf+q+jCGHBbLqzvjf0Y5hqHRSZRjKGcVZCIqLGrsMsb7L7Kq6ANqyLzC3/DSkHn4W2CywmSdKzNqisqbx7jRZE31ycwj6gjVDezSNWBK3ATWJbuvjqJ3aDpEaM/QgEy9dGJyXo3j8pkv2tZnOOdiYXNSPFVYhFWpWBwi7DSXhQrhVyuTyiKGW1XdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gaisler.com; dmarc=pass action=none header.from=gaisler.com;
 dkim=pass header.d=gaisler.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gaisler.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZxgyOtelA43xGyCqL3z9foI6VDBnALn1MNcl+ea+qCY=;
 b=jrLifdb0G5VsNskyJY3lhIhZHqiRppLglhd40DHQzleMzgA/l6wxTc6JKJDtIyyiTO6DhIW2lby8o/zzX91km/e57BQaMw9/5nHvkBnw02FXZtGWvsh7jPZqJSezQlzdSiB/J4Wf2e/yxMAV2w5wq2+fjE33vCwsuQ8DsGYLV/Qnfu+PkqkWDFR1Pg8Zon8oDnc1xS/1oH/ZI06+Uaijsam8cLxtv+V2gx9PuPKofVJ2QYJV3Rd6UyJSvupahssZMZUS274xucPgGzw4nviIOVjX3ItSmRT2zlA/QW74mmcsx1euWoLWyWDXurNpJOicFKurlZ80TlRkPVaYqhz+Ow==
Received: from MM0P280MB495062.SWEP280.PROD.OUTLOOK.COM (2603:10a6:190:2f::5)
 by GVYP280MB2143.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:34d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Fri, 23 Oct
 2026 09:22:26 +0000
Received: from MM0P280MB495062.SWEP280.PROD.OUTLOOK.COM
 ([fe80::1f13:f10:e16b:7939]) by MM0P280MB495062.SWEP280.PROD.OUTLOOK.COM
 ([fe80::1f13:f10:e16b:7939%4]) with mapi id 15.21.0546.017; Fri, 23 Oct 2026
 09:22:25 +0000
Message-ID: <87800728-48e6-4953-a705-048d38bbf9c7@gaisler.com>
Date: Fri, 23 Oct 2026 11:22:24 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/4] sparc64: D-cache alias flushing fixes
To: Imre Kaloz <kaloz@kernel.org>, "David S. Miller" <davem@davemloft.net>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, sparclinux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <cover.1792609488.git.kaloz@kernel.org>
Content-Language: en-US
From: Andreas Larsson <andreas@gaisler.com>
In-Reply-To: <cover.1792609488.git.kaloz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BE1P281CA0144.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::9) To MM0P280MB495062.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:2f::5)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MM0P280MB495062:EE_|GVYP280MB2143:EE_
X-MS-Office365-Filtering-Correlation-Id: 24f08e9f-84a3-469d-871a-08df30e726c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|11063799006|56012099006|261009223027099003|261021123027099003|261021121427099003|261022105027099003|261022075727099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+ovE1zeE64VlKFHBTJErLDa7ybD7Crx8f+LlmEMpcTT+EJRgwqYxvULH62L/2FJR9MfvwaDFAedYyCc9EkWjrv5BApbZieeYp6Hf3S7h9pPuaMrlC6MK7YoLLQ4J0RaCPd0+2fiOazkF8avygyJZgZ9UJTzCoXpqTmk8XHBiyopR7pNTWTAOAQgiaH3buCxt1EApKnuqgWnL40In9IVdPin3NTeu79A2EJsZHHvqDkFeb7Kq8T71VxsbRUT7T5+cWrChXnVe0vnooTOhYxxgnSwOMmv1DnJnhEX7wvHIESgLO0C1qilCE1yOEvGSWLF4ZVvDTYbORg5lv5wCJ0OPz5Ym4LPaIJoo6Ey7OmMN5rKk+TkTd4R5mdmxrR3tVR918C82AYqUPRA2FxAxUOntGOYx3hRhweZ5d8W+M/7vmEkdXGvjjGrfRB1SuVf9bS0r6NgaEFC7N4BvdSYEHwgm4LzWQ828SZM5/njP9L87tkCNENqHFQ7KJID8UM6V1Ke4fVQzKiPQOCZ30RoLx+NrVJFmCvfCk2xbVq796DMqRWgyquKYq/hRVESagsTetpS7MdKRRCyjwZg8APATPU4HZ7QJZlgKQ0pCOvSKY/kOVkVeYGpTQsIKaOH8Hl5gQ0dn
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MM0P280MB495062.SWEP280.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(11063799006)(56012099006)(261009223027099003)(261021123027099003)(261021121427099003)(261022105027099003)(261022075727099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bDcvWStBNE1DNk5YaHR3bTUvTlZBK1duNXY3bmtJaUwrb3h2eDVENFdmVG80?=
 =?utf-8?B?QjhpS2krRGZJWU1UMldxb211bWpZdFlpWGorY2pJVkt5SjN3ekRVc3lCQm1z?=
 =?utf-8?B?RE43b3NzZkxicjdBN1g2SVRvWEZnVnc0U01yejBwV0hwbngvSjg1akN3amZq?=
 =?utf-8?B?U25NaDg3OVk5RFU3cHZkYVIvUDBiUGlKWTRCVXlaa2p5NnNKbzhHMVdPdzEr?=
 =?utf-8?B?NDJ3ZXIzd3U2RVQyZE5DMS9HM0R3VlhJbmhqQzdJQUVNdWdQMkFJUUFTZ3Qr?=
 =?utf-8?B?WGErU1R0SWI1VXphNnk3aXVlQVlZUUx5OUJaa3RETkdCeTVPdzNKVHpiS3Fo?=
 =?utf-8?B?TjF2UWpwc3huK3VyWnhhNmVOQnhmY1dlYVJFOXp0OXQ0STlERzJGM05td2E5?=
 =?utf-8?B?WGFVQm9LZTJzK1N4eStmK2ljdEx0UzhDQWlod29PeG9qVTFCUXpQMVJHWUhL?=
 =?utf-8?B?V0FwS2I0aWFBMmpXSDFqdWhqUmUxdzJCK0tGa0tTTXBja3dTYVNXVEpNR1hS?=
 =?utf-8?B?bnlBNllCWlB6RU9yTzZoRkJSODl0MCtzS2hKdy9MZS8zZmFtN3FBOWt4V3k4?=
 =?utf-8?B?WGhTNUd4bzVrUnRtVnZIUFVkQ0NNbUJzZGE2YVU0d1U5ZlUybnhLN3FJbERV?=
 =?utf-8?B?L2dubllDaFd1RXVwK3pIRngyMmtQWWZpNzhZQ200WWhqc3Y1aUYxMmpvWnN5?=
 =?utf-8?B?Umh4b0kzMDdqS1ZlcHF0c1BIM01tOTR4NlBTSTNqWXpyZkRuZVVzdlVqeUpT?=
 =?utf-8?B?LzlxdGRPa1RyeHhZeXVUSlRkYUNOZ1ptWGFSa3RYL3hVeFNBUnlrajVyMXZp?=
 =?utf-8?B?bjFIeDhPNm5DY0VBd1EvZVpqZDN4QkpQZHQvOFdoWEt4bU40azZhckQ2a2hx?=
 =?utf-8?B?RTg4TVA4amU5aGpHSG5jdFI0S1kxTlVZZ3Y5dGVBSkMzeTRFb1pZOEtxOHEw?=
 =?utf-8?B?QXZPWFY1T1A1TGhzNjFzRzRWZ3MzY0NCd3l4U0pXbkplUEh2bjd1aEFkS2ht?=
 =?utf-8?B?dHEwZURQdjVCcVdRMHRVMWlDcVRWODBIaWFENWFxTlZkbkthWG1xUmkwVGJZ?=
 =?utf-8?B?UmhUOGxxQTJPdm9icGVPYk5VeERweU10ODJyQ2ljMW9EMVRBYzVGdlg3c3Fs?=
 =?utf-8?B?bGNoMmlXeUg0S053U2I5Y25LK1NaZm5kR0dCL0hwQ3VzNjFjbGtYVTFKVm5P?=
 =?utf-8?B?YkQ3bGNINkhURmJwZ3JPYzB1ODltdk5ib2NZUVMyS0xFNlA1Q2QxZ1U4YktD?=
 =?utf-8?B?L3JrR2tYc3dXS1ZVdXNmUk5VMUxrSGUxekkvNWYvcC96S0IrQkhYenhqRlUw?=
 =?utf-8?B?QlM0cTNhNHkxVGZFdXV5NGE3NXRoM2tKSlRHUTAxbW5xUVZCUEZneG9QRGZR?=
 =?utf-8?B?VE9qNUV4UjROVU9tYkFpaG0vbkNtUkJnM1NvRG5iKzFacUt1WkRIelBwb2Nl?=
 =?utf-8?B?ZGtVaURkWUwzMTZkS3FHY0F5UmRNWjRzbVpKTi96Rmh3bDdxeGFsK1VYcDJX?=
 =?utf-8?B?SUVLRVgweUJvMitYdlllV090Z3dkVEQvNnhXai90aGRuNnNjN25ralJ2OTJH?=
 =?utf-8?B?M0J6bW52NEtDbDNFYTFrUUs5dmlybGdqa0N5UVJkcWJxQmswMzRTT1MrSEVq?=
 =?utf-8?B?eTNESHdIWi9FNU5qNjk5aTRBK2p4Z3pqc3cxK1RpYXZWSmV0NDVvb21wK2lR?=
 =?utf-8?B?MUxQMUNzYXNzYWwwYkoxSXUrQm0xOVFvdC9RbjJyckNsdnV0c3cwS3B6QUd4?=
 =?utf-8?B?eGJCdDkzYm43WW1DaDkyNGNoSjJFOVBlZ1FpbTNnN2U5WTYwcE8zak5vRkpw?=
 =?utf-8?B?UE5wOXREL2FjaGE2YUdsMWo3ek9meExCMFU3dWR3ZFR2WUkvSWJNSytTK3pF?=
 =?utf-8?B?eEljQmJNdGxFNFJpK2ZQNjlDQWp6eFA2NlBtM2ZqcmFiWnIwTXNyRGg4QUc0?=
 =?utf-8?B?aUhHa1dGR0ZjVDUwMCsxN3V0aFBoSVFNcmk2NlFHRUNHdFRaSnNHcG1sSVdO?=
 =?utf-8?B?ZWdyNGRicnR1VFdBcVVtaC83UGF2UitndVpNN3J2QVhscnIvUUE4c3RpdUU4?=
 =?utf-8?B?VE0vdUJpbU1DK0RUMnNiMXV1S3lZakZRcXMwOVdTb0h6SVVoQXJhZkRpc004?=
 =?utf-8?B?M0RXanJiaFNrTHVDd3o4cTNFWXVGaVZTRlFJbWQxeURUMXRibCtDVmFFZ1NZ?=
 =?utf-8?B?NWoxc1QvWVFzTDQ2VXV6TGErMHUycTdndGc1K0JxdmxwdnkvcjdES3BMOUpT?=
 =?utf-8?B?a0ZOYXdTM3N1V2M3Z1VnaGZoaFNqSzUxSzVwNzhkMWROS3VIVEl2T3VkT3Zj?=
 =?utf-8?B?M0Q3M0ZqYkRKZTdwd2crZUwzc0hlQWE2NUZKRHpNdFNqZDBRQlQ3aUF4MERO?=
 =?utf-8?Q?S34wxYadsTv9NAxw=3D?=
X-OriginatorOrg: gaisler.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24f08e9f-84a3-469d-871a-08df30e726c7
X-MS-Exchange-CrossTenant-AuthSource: MM0P280MB495062.SWEP280.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 09:22:25.7056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 91fa4a59-2167-458a-8318-e45d80469d7e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YSnxjoZI6nNdQQzsc1GQ6s3xFfTHXFpNWQRx1X5dnyNboBKg2prK/pYh3/UAaMxOkOxcek5wAsvSqHjEUaY3w0+Mq61i6Mwp8gp2IzLpl34=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVYP280MB2143
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AC9F51C0005
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: t8krtadtbgd583h8jeua8jsxrfeqei11
X-HE-Tag: 1792747351-421370
X-HE-Meta: U2FsdGVkX18VuYCVxOoimyGsUP/dkjOJG267JoZHHCCf78PFDRP8oSOv57N/Q2sMXmNQFkoHoUZIhLnkT1K+h84ZeMCooBnlB38g0w3sW29DgEFBodSRRGQYBhUYRCxX5+HPbkv5Upd7wm4HnMlsgqDw7xXTl8EKPUC3zav0dRphDMB4ZzsZ0etJ3sB2hv4KVldqRMJZNF0Q9kSs6EKSl480kYeGOHhSQZHlFo3G2+vTClQCr7r/muz6KgCDgp9QVGinlGvLENRLeg66rw0uiM8HKmWdSfjsmAU6hK/++b45EpJx8kvC/cLHn+X3IH91dlJsCTvlvVSRLYf3e+YPTMLQTAiOn4XobiWrTiLv/UKJUfzgpCghyMDoqmornKBngAlRTK1FGue917Ej3Y1wkUNCRugb1sywHyDR425tEVgzh2JC4zvcVRvNcrCBCGff6LU/Xxf4ovKNpIaeemU2LkpgsrjSPjMT4iA6baBPrfXvUCTYeoHiCy+me4O53zdO2dLhcrUvb2kyjlVLVLMS+ziZKT3qc8j1GLQZnKQwcEigpt5WPWxSraA30Yk1ISx9n46s1GlDkQxznrWtq+UG3V1ZJsPCYyk9ZPvKYlRf+jPTJKhok7Cvd/M0jFeFGaarNskhHRjo1dbgtr2dz8X7EEK8l9ILvGEsUZ6g8wNh9fZ0FSvGP7GaXtDCk/sHcyukAg3fwOW+YLCwAgPg9rEjbfDuM34X/HlouJmTLd5NravwuOtVLeqcxOVZKGJTBzt/bJS8tgRB0QmuE0oGtDL/rFjq0KBUeapRcBE+A5yMSKNth47zrdRq25EbpxGrw/gRgBQONgx7Ha4QIRBoBl2pW7+oJqt9ECyL04TB+Nkb1LMORP21kiJPjSEAEaVUvOk+/NbONyiNOZqKnqcMuC+hGxt1V5C5aKfClm50kyEZlE5IqbMQq0vkFkvvfGOJIRbUpQ1rRBdei4AWhfJdyqV
 KbXDrOCU
 9LoK81BqqQUEXOF8hoZTwEhouS/XGJ4XlqNgBgJTDrp8nfiX6R2Pi+7ZkcNKyktm+qlKUXSJa8VnpRh2SyHcBKimv0CLsM/eArr4cx0DDpXgyIvIMn78WCikp0k+c62Y9YE7ElR6sgTq/NNW45pKV3O3seB6Cb3EG/+w/DWnteEZoCM2QDDkAd/LCCKQ06HIRccQhw8RVCN9fEy6iTP6HL6MUV+Cn0tOqwv+/CrJE2/TbIN0AAIoTIb3ENRTfVvn6HmKXsyz8EdwXAmu+XyV+nGzJ3TY44zVuU5NWUac5VS76f3z5Sdz3v4eoMVVDyiWtk4BT2IdHs8uaGpWYf4vug7zp/KhrQC38rV/qygyK/MNQmZmKgj51mHhCLzC3zSHDQcn8U+kW6ddAcZG25F6uMycKUozWlJPeWZxiLZkdsTCCVkCizDvb4zybyTVfIbd5BSjvgQOKQ/Kl2yUhohwmQo2JGPdcjKtcxYeEdogFzpRpjqefhaMta+83mH3Yqnn3q68x2iBp6jsg4SCiBdqjvq3oq3GtH/ZH1PO0xlOtNRpudc99M3+qN1RjH720swtn/KxxZLzyjcYtSSwU48nAzIgazaAB92SC2gTFEytqjr2OsE9+I6U0dHeJcPF4ZfKAIoXt4HemuU1FBnzHu/8e61srpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-22 01:33, Imre Kaloz wrote:
> These fix D-cache alias flushing on sparc64 CPUs with a virtually
> indexed L1 D-cache (Spitfire and Cheetah).
> 
> 1/4 makes xcall_deliver() bail out before it touches the trap block
> when there is no other CPU to call, so an early cross call, before
> init_IRQ() sets up the mondo blocks, can't end up writing to physical
> address 0.
> 
> 2/4 flushes only the page a PTE maps instead of its whole folio, which
> removes about a million redundant page flushes from a colour-changing
> mremap() of a large folio (7.3 s on a Sun Fire V240).
> 
> 3/4 implements flush_cache_vmap() and flush_cache_vunmap(), which have
> been no-ops. Stale vmalloc lines corrupt BPF programs and module data
> on UltraSPARC III.
> 
> 4/4 passes the number of PTEs to move_pte(), as Andreas suggested. It
> touches mm/mremap.c and include/linux/pgtable.h, so it needs an ack
> from the mm folks.
> 
> 1-3 don't depend on 4 and can go in on their own. 2 and 3 are for
> stable (3 needs 2), 1 and 4 aren't. The series is on top of the sparc
> for-next branch.
> 
> Changes in v3:
> - new 1/4 and 4/4, following Andreas' review
> - 2/4: reworded the message and the move_pte() comment, marked the
>   UP #endif
> - 3/4: reworded the message, dropped the Suggested-by (I have no
>   email address for nsafran1217, the Link credits them), noted the
>   stable dependency on 2/4
> - picked up Stian's and Adrian's Tested-by tags
> 
> v2: https://lore.kernel.org/r/20260928132102.1707-1-kaloz@kernel.org
> 
> Imre Kaloz (4):
>   sparc64: skip the trap block in xcall_deliver() when there is no
>     target
>   sparc64: flush only the aliased page, not its whole folio
>   sparc64: flush vmalloc ranges from the D-cache on map and unmap
>   mm: pass the number of PTEs to move_pte()
> 
>  arch/sparc/include/asm/cacheflush_64.h |  9 ++--
>  arch/sparc/include/asm/pgtable_64.h    | 14 ++++--
>  arch/sparc/kernel/smp_64.c             | 51 +++++++++++++++-----
>  arch/sparc/mm/init_64.c                | 65 ++++++++++++++++++++++++++
>  arch/sparc/mm/tlb.c                    |  2 +-
>  arch/sparc/mm/ultra.S                  | 25 ++++++++++
>  include/linux/pgtable.h                |  2 +-
>  mm/mremap.c                            |  2 +-
>  8 files changed, 148 insertions(+), 22 deletions(-)
> 
> 
> base-commit: 2bc58762a3d74e42de129d717ae3ba10ecf0ab96

Reviewed-by: Andreas Larsson <andreas@gaisler.com>

Picking patches 1-3 to my for-next. I won't pick number 4 up at this
point without confirmation from the mm folks.

Thanks,
Andreas


