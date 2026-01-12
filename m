Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C368CF45D4
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 22:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E48596B008A; Mon, 12 Jan 2026 17:01:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF33D6B0096; Mon, 12 Jan 2026 17:01:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA0166B0098; Mon, 12 Jan 2026 17:01:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B5CF46B008A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:01:55 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5728E1A0C42
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:01:55 +0000 (UTC)
X-FDA: 84324684990.01.04FFE17
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id D28D4140019
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:01:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sUSDbOSe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uilCn0gX;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768255311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vZ1IwBl4rtHj41wGkHmjQMTIeixuy7oULUJjGEXdSPk=;
	b=aEjRW/51e0nRupEaod8taEUvpaco+mZkmHXKtj3+P47oQTA5xdAB6j1hJ3tdWamP/VcCt8
	chOoUjOqL5qxzY+DVdDy8PIF8qHLsBXj2gkZ5HcJ/oQt9o7tfNHn86pX0JO6e+4BDpB5lR
	6ZwIDxmMjg97JizeUMVI39+1leSEuAg=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sUSDbOSe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uilCn0gX;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768255312; a=rsa-sha256;
	cv=pass;
	b=eI2DE5mQBrEuBDFUKfsNj7d3qve+jUfGsYH0ENUeY2Q5IwryDkXJhbI9nQNI5NE0OT4Ns2
	zVZ024AE4bOOoxj4kSXJCSL2QNVn35smfThUhyjZunknSYYMrlaOo+1N08enz7jEU4CK/6
	U5iwxmt5IGHwkd5pCoRxWz8Qef8t3NQ=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60CJEEsv2690844;
	Mon, 12 Jan 2026 22:01:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vZ1IwBl4rtHj41wGkHmjQMTIeixuy7oULUJjGEXdSPk=; b=
	sUSDbOSeWVRawwUzDb3Tel1l8oXxpdecQqegze+o4oYe+xU82p5IgGVCP8i3l8Pc
	fqcgR89rwMOb/UyPq4PhOvNRRy7oIJVLh5N04SaEAvlyJab6+rcU7r7I/E2gEbgu
	GXrFbhpdR+zjRCSu3Q92PVW1D3l+Txc3+MoqGWT8HrJfd1/apZBKFaHQY3Jjo7Di
	XYb844NDBhb514TsxjlnZc1O4bUuUHgCPR2UVw6XMwlCEDNUmdDtfPzYAC8AFlce
	pMitLy3kqLgc4r50jkMVRzycJCjx2OsI9dUfa++qCnOePVQKhHboduMC1Oeo6bY0
	kRVjJ6glZ30KovyxBtHBdA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkrp8jg6k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 22:01:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60CLWL0s035388;
	Mon, 12 Jan 2026 22:01:35 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010019.outbound.protection.outlook.com [52.101.193.19])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd77y1er-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 22:01:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g4RqlHqPemq04xcLylqP1B8JegLw/5K88w0pDi4PJ0zEJasiX0RYRpP+tp7eezE4TXomYyw/FQLyliSArJhJj3tzlxMV/lUYjkrBPP2YspgedFwW4MFoxOXsIVbMfPQwYpH9HnwmPUJB4Kq1mEqLWu3X5YjN/D0+oajlD3Hi+UXxu8Mmlnk3EP2UW6TZp0kioor0o9pnZ+xpsibVewG15O2TZOsvwX8MW3RlBsyJqs9S2krTu17HlQtmVjF3QyhxoeoSOa9FXpiLk/vXIXx53/7/9jj/vN8zA7TZdgQUakmHu9kZZTyE+kYoxJel6k+0g5g5msTgLP82WHt1t1268w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZ1IwBl4rtHj41wGkHmjQMTIeixuy7oULUJjGEXdSPk=;
 b=SONvoSPYqt8ykxYj+qbJRpHgEHh/5McvB5+AHo869VbrjwgThrVk1hxy9slpPZq45OgaCQxBuhj6BN1B88Wbv/iLVDszEccOdvKA5O4xPPg1J+w+IDlZcbZTTs3lUxfrow4cWsyPzLEUJn7KrUZzS43VO+aetrQVbMA99E119HbX5Mw0clkX7B3DAm1DCvAW9K+q8TW5t04aTGN+Vdeq/lX1BSTmaVjpkf0E88kqs7utIhnXi4xK0WU8PDQycXhekE9oCyUi1EZjiSws9Y/pDZ6TN2ENnRWNm6NcYm32p4gFBGWgWZjmMQgZlyp8fnhy0ctBjMBiyAMX5IIAUz/+jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZ1IwBl4rtHj41wGkHmjQMTIeixuy7oULUJjGEXdSPk=;
 b=uilCn0gXEb38mU2OnMUL24pplphsED/uqZlSXLt9PaM9Zcn4fM6Zjjo9CP0OhgOjrs7UEoUYWJwv9Tk53eK4VVcReaBtaJ964K6sPfYyF/hFkCkym3WASNsMoSmE/4mjfzqj2uaZ4wKG3vFKA1Q1KP/ZjHX5vdjjdKJrzd6QjjI=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BN0PR10MB4872.namprd10.prod.outlook.com (2603:10b6:408:124::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 22:01:30 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 22:01:30 +0000
References: <20260107113130.37231-1-lizhe.67@bytedance.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
        akpm@linux-foundation.org, fvdl@google.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
In-reply-to: <20260107113130.37231-1-lizhe.67@bytedance.com>
Date: Mon, 12 Jan 2026 14:01:29 -0800
Message-ID: <87jyxmjxs6.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MW4PR03CA0343.namprd03.prod.outlook.com
 (2603:10b6:303:dc::18) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BN0PR10MB4872:EE_
X-MS-Office365-Filtering-Correlation-Id: d05869d1-0f1a-425b-5d87-08de52262444
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NlBsMU52c05XUXhMSlI2amtaWCtqNHBmdmpMc0hVcjdIYjNROUxzK0JwbzVz?=
 =?utf-8?B?YmppT0lIc3hvTE4rWlE3MmhUWEVzTUVraUY4UkZ0ck1jOG52VVJEQzdXQkVz?=
 =?utf-8?B?a3lPbDEzMnpHbmxTSXBPdjc0WFhBZkxqUm9XQ2Mxb1REMmZkTlJhdHdhOGJT?=
 =?utf-8?B?Y1dSS29nUEtrVzdCRkwwQUJxUE50UFVMajlOMkt3WHhPSDdGSUNRcDRRRkJ1?=
 =?utf-8?B?UjhRaUxnejlpTmNsd1lZcmVrN1NKM2s4dnJEcmFsU3ZxVzhoOGliMGhRR1RJ?=
 =?utf-8?B?VFNIbmFXaG5sUUlUZ3NpZlpNSEVlbmNDMnlWMDFaTmVCZGs0MGM1SE84a1dm?=
 =?utf-8?B?TUFIMlo1bzF5VVE0akFUcXorTWpBUTYybFJrYit6bDh1VXloNkw0ZVAyQTJX?=
 =?utf-8?B?cERWL2cydUEvNm5JZ0pEU3RDdWhsbVpRd0k5My8xTWRGdTlscy9odjRCWDJZ?=
 =?utf-8?B?K2FNS1ZWbDVoZkFwY3pMSjFEQ1NvanByc0FKT3V5ZmZvYml2Ry83SWVETElS?=
 =?utf-8?B?U2cybVJxUE9rQ3pHNUptQ3crNTRLdjNtR2I0ZWMvV0VVUC9GdFMxSmR6UUhJ?=
 =?utf-8?B?a0h5c2MzakZSZ05NZzhqMUs1YzIrNStWaTBlTzlHRFJBSCtKeGR0eTNxM1ZE?=
 =?utf-8?B?dDl2V0tVWjJnYlpQSmdtRmNRZkE0Rkk2NmR2OUpPcWJ4UzNNTjRKekVEMWs0?=
 =?utf-8?B?WWMyS2hNeWlsT00rbVJqYkg4MUJCS3dwUitUQTFydmF2TTFlNTk5VVppUUpn?=
 =?utf-8?B?WmpZaFNtbXVHOVFCN2V2dG1PUkRYL0JlZ1VHZHBaaW8ybXdjQnVwczJSVGdN?=
 =?utf-8?B?Q1dOYmwrVWdib3RvNWlYaFZWZlM5S29peFdGWHljeWpCNWEvYkxPQUdIcVZu?=
 =?utf-8?B?YU5JVzl1OHUvcmx3NFdXYzFYK0tuNllLRkhDVUtwRlh6ZVR3YSt5aUN6SW5T?=
 =?utf-8?B?a1BtZGttS1h6WjBsYXZPYmxENUZlTmYzL0FJRmg0MG02cGdFZE4yYytvUDBM?=
 =?utf-8?B?dE9vM2RBMlZ1UnZLVGJYVC9PZUcxMkUzRFp2UGZHcjRjblI3UGpDM2dWTVBB?=
 =?utf-8?B?dWsvUXNaMmxKRjJIOEMxNVpLS0FNbHpTZXVLYjNVTFVzOUVZMWxUOW5FZnV2?=
 =?utf-8?B?WEtTZDQ3VU0rU0pGNFNMS1VWenJteUIvMGRwVVh5cjJMZm5WT2ZiWUdDemRk?=
 =?utf-8?B?ejZiSFV6Z3JRU21DanRUd0JhWjhuYlJ5ZHYzTk9Sc25KT0FOTW9nR2FaQUZM?=
 =?utf-8?B?QXdUOVlPeTdDUDdQdzl3cWZYa3RsZ2RoUDUvempvNk9hR3VtdFNkVWR1Ryta?=
 =?utf-8?B?eE9JWE1OczR1Y0pGcUV3UHVlNUgreWlDTWUrQU5BRzBKK3kvK1Jvb3pKcDBE?=
 =?utf-8?B?VHNxaVRnWURrVUhhdkhUUC9RR1pBcHhrMlBnelJNaWZodWxYN0hxRjlmd0NP?=
 =?utf-8?B?WlFVOHRQbkd3UFBkeGk4UDluS2NyQk5YazkyV2RCYlg0MFdhOFZPdXRvU3Nj?=
 =?utf-8?B?MnFMNUUwK0YrWkE3UWNlVFU3ZlRTOGx2Y3BHaHNQK292T0gyK1lNcDFrWEpM?=
 =?utf-8?B?LzdIb3B1dktkNmQ3VVhFelQ2U2R0b29xa2g3bnlLMjhpTkNmSU1VUnJsZENl?=
 =?utf-8?B?blQ0MGVDUzRIeFFpbnlaN3Znb2NCZEZ3bndYZ3gvejRKRlMrc29FZ1ZSTHpQ?=
 =?utf-8?B?QjVaMGpuMHpiTmpsSFJ4Q3J6bStyU1p3TDk3bXpsZDJTdkVrTVl6aStCZmxk?=
 =?utf-8?B?aHhDamYwTkFqZWRSR0d4Y0VoSS9IZ0ttWFJVMjFRR0RUVHl6QzFYaExXRHgy?=
 =?utf-8?B?akVwZVVTM1dGTGd0SzJjdWE2ZkRaTkcrN1plam1ZYjg1ZXZQRU13RHBVZ0lv?=
 =?utf-8?B?VW5kWEYyd2poUENvN1B4aUF4a3VsaURWSTFPSC9raHBEdHpYMDF6a0tCQVIz?=
 =?utf-8?B?aVpYMEI3YTM4Q09MOVl4RG5GTE9DVnRoMW12UWhnakpjWDUzNkF3Q3lhUThx?=
 =?utf-8?B?MWcrU1lPaDJnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VnEwWHhsUkxjQTI1WXF1bzVCd2VtS083NXpRdVo3UytYbXpJWGRFa1FsMStM?=
 =?utf-8?B?Yzh6b1BxNjVCVW5TUkt0SDNPV2J5ZDk0QVZsRW1Dc2ZGWG1PMk40eWZvYkd3?=
 =?utf-8?B?UU9VcWgzazZHYlNreWYvU3g0RkdZcGlpUzRScFhMSUlpRzlacWhJVWg5MStX?=
 =?utf-8?B?K1VVdkErOG9PRmtVVkFzMHpRTVd2QVB3ZmFrOWIrY1ZTOHNqUWg1T1BzQ00v?=
 =?utf-8?B?SmZoUVcrWFVNK3dOd0hiQkJtUWJDaHh5VVFMREViUEVBQmtKM2VMWDRiWFlh?=
 =?utf-8?B?S25jc2RYbzk4MmpKTVBvOFE2N1l5QVpNTjh4Z0tDTW9meHNaRTlFN0ljZ3Q0?=
 =?utf-8?B?Q2V3dXNPUlA1RFd4Vmlud3lCN1J3OHFhQzJjME1rZCtXOTRpU3pmd1VVWmNO?=
 =?utf-8?B?MzhEelQyaDlISGJXUEtXdzFwL3k5Y2Y1bFJRQS8vWWRYMzA3Nnk1dFhlTCtq?=
 =?utf-8?B?WTlTQmNPTVRybGFkSHV2TC9oY3RIc254aDJjaVUrblhjYld3Skk1ZStTckkv?=
 =?utf-8?B?dSsrOWlicW5aTFA2ZU1YQ3J3K1hYZlpLOWxaK0dGZVRpeTBNQVdWMmltUWJq?=
 =?utf-8?B?MFpZOHRDTjZCM0QyWVJWaGU1eUhJYTg0R2ZyenhHenlTQUNZdDFxdGtsMWNX?=
 =?utf-8?B?R0NCby9xMHp2Tit1WGZhTDJZM09vTTlvQ3J6QVJIeU4xK3hYaXFEWXBJMVQ3?=
 =?utf-8?B?d2RmWjc5YkNmb3NEWXZiWHkreGd5T3kweTgrTHROcU9pY252elRXdG5WbGVa?=
 =?utf-8?B?M1JpdUxmOVZPeEVnRmRBWFUvWFpDM091cVBpb1BVOTUyM05zZC9oWmtIN0dz?=
 =?utf-8?B?eWpoOE40K3JzbGYzbHhLYnU0a0EySjVBcklMdEhaRFdPT1RUa1dRc2hHMkg2?=
 =?utf-8?B?V2QwdEsrT2NqcEdFV2FTTUFWY1NIWHNXOHZ6NUhpcEJ2aW9MemtKclVRYVA2?=
 =?utf-8?B?dlUwaDBONGFDa3UxUjREZzBDckVvVzJSSU1ZUGdObHBpUnIrMDArdEhNbU1n?=
 =?utf-8?B?ekYvWDdMUXdxM3NXWGZBZ29YMFlFR00weWt5NU03TGxwbWhHcTJpUDArVTBj?=
 =?utf-8?B?aUd4SUxnTDZCSnZqZEZvbW8wNnJyUzVJN28xM3d3Rlprb2RJdEEwendQNGs0?=
 =?utf-8?B?ZUZvRDhVT3l0eTFaLytwZ1BwUE42VU1TcVg4UmJhaVBOZHJQcVRoK1FZbUxT?=
 =?utf-8?B?WjB5R01BM3FWVUViY245Q0txRmVVcVB5WVUvcmhINjJhZEFwc2tSUmU1eDQy?=
 =?utf-8?B?OE5FS24rTmpGcjg2WC94VEs2aUJjWTVDakk1QzBCa0F2TitPODlVSUszcG4r?=
 =?utf-8?B?akc1WGp6dWNxV3p5TVJtelJTMG94dkFsWlFjR01UY3FoTHZqLzZkS3lCOHU1?=
 =?utf-8?B?WDltSTlYNERUWkNBLzQ5bi9uMWFWV25lMnJxOFQ3NkloZVQzdnBoUnZLLzJp?=
 =?utf-8?B?WTRDRkQyL2o0QzAwRi9VUzMvOERiZ2xZb254dkRwbWg0Z05ySEMyWlUvZ3do?=
 =?utf-8?B?dEdmQTduWXlxZzdQYXZxQWt2cE1OYVFacEpVbE16TENYTXBQSEUvbWpBbFJI?=
 =?utf-8?B?QzF0YUt0L0ZmSTdISjdlbkFTM0pYQXdGRlhyMzByVDFiN3lxaitvTzJNTU9l?=
 =?utf-8?B?V01WTFBoVEtBTGIyRzhHeDc3NVJwYklsdFBoNXdGd1dWK25GdEVWNnhIZ0dw?=
 =?utf-8?B?VE1SUVlIK0dnUnovalpxWHA0SndzbDIxMThDaVBpN2I5ay9rSGpKV2pvTVli?=
 =?utf-8?B?cWx3M2dndFlIQldkS3k5M0thMzM5cGRUREtVVkxWSDVqdkRUWGU3anlaeEF1?=
 =?utf-8?B?RUtwRGZJUVk3U1pHWEFwMjhQcFZRRW9RSU1ZSEM1VnpWV2Q0VmpOUXYzQ3lL?=
 =?utf-8?B?ZE5IOTBGak5LZ2w0c0xqZDVSNUxwb1YvbDBHRWl2SERyT3F5b3orNFNEUXRo?=
 =?utf-8?B?WlllYUhBWGZab2NwT1FGUnhFdkZzL0ZrRWFVd1dKMTgxdWhDUHlZRkpiTm14?=
 =?utf-8?B?Um1CaGtsanV3bm1OYjJCeGNORHYwQW5xckVHbWJabVB3UjlLM2kwcGNBay9V?=
 =?utf-8?B?aWczbFYzWTJBdXBBbkh4MzJkbUpTaVR2MW1VR09GeHJ0dG9zeWxJa2IvK2g0?=
 =?utf-8?B?NkJINU1IYTdlKzVYUy9WazhLV3RJYURyeXo3alBYRjBQWkFKbllpclV2YlZu?=
 =?utf-8?B?eTd2OGw3RE40Um5WeVRXNnY5T1g2ZUhTc0lEOWNKWU5VT1Y4YUZVYVBXRWpZ?=
 =?utf-8?B?cGhNM0hMYnlsNTl6UFBYNXlFSjVOTEhXc0JIeVE0eHdpQU1Eb1RGNU82NjQ2?=
 =?utf-8?B?MGFEK0V0dXNFVWF3Vk16enNOcEVSUy82cktMRFpIT3lwdFRjR3ZabERJY3JO?=
 =?utf-8?Q?CHuyqWA6l7euASkI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ydjdb7rQJlVkkYkwqSONnVN1N0BrrWubnQnZ2eji6U6JZ5pmaArksn9V5RufWsTHnFleCECtoIBq7bmj2l3Ohqps8/hUH4vqiCaX66aglLtRMKAVZQ0KfAFwfZKqd8gGG3yFyxmLcxVHzYPzLG9ozvWINs+8FbWS0/qh62kyIWdPma0ovt0LVtCfsqc8BZ9+TMdbthyF9ln5BoEp06nVdvW7PT3CDuG/efXx1JRrgQk2WDLelR1R2tuEOEUVg9X/EPfxLWG5/X6wZFsqCFRTqCJtmcm+dJAOQsWu6DMnfKuhOXrB0sHI6iBlTJk2daPlExldAUqOSplYV0KNmyBELha6+SCU53pdyBCECJcvE0j6EdtQq/UaeGfgfHn4OHqWraXYe0QywUfFDsXyKlYBM2KTOli7q1HwupWdExaKppZKNz+4DnZlEkOYYw42lhxtPu5+WhsswBnTV1POiMhmJPKHXAU2CY3s1zyQutAqXoF+AWJNKTT7pONP5dNMfGSr9YzT6MT1fuWSMBJmExGFWsCM0touUwAIw3PPRES1EREhFC28UIEncgHiKTr1nurlXdDyc7+1RrJvqlIQ4Xz//hEZkndWh1j0GXQgB8SPXfo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d05869d1-0f1a-425b-5d87-08de52262444
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 22:01:30.5189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QedJoMu3DVYg+LEmy1F8Od7Oyl5y1TAWfvlwbkA5BHxaMnaNMhE6uMQiOzpU3YuKUOFfMPhuHQZCe7aOOdaEX8qLtBB287IT4XQUyPsMioA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-12_06,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601120181
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEyMDE4MSBTYWx0ZWRfX7kNlzNdnF7kU
 60HGJHjj6Q3rjYkVkjY28YhX4EwzTwd3cxNvvZHfmDJd4tuQpeRKuVerKUpcjdd4mUXIBDRrVWq
 IObm1kJP08jx+poJkRu252MLjjywsC513COmwcOZZyXWnmEaflqAsnUZILH+w9Giao7QRastlT6
 5U3Aq9rJJObyGOhrfJwk9okThQ/ABG04IuFVbdcWAFn64xrZZhuOHz511YfROmtWTnW8i1bV8GC
 UccI4hthMzMHatRVFur8IzO+sH6dvuzuvwkIx7i+YSs5oaEvXp3pDuejdYCPwjTatkUYOo371O+
 aXCWubGn+00aEhfFG3UgCtZNilglQvxpnAryO5OJclivvtAulZIZSiejZt6lSN6X8lIHJZEWb8Y
 Ah0CvzbgmPKcLvMwk2rIEXavZkt0sKo2UEAKDaaJ6hegM4YE9hJnKvThF0l4i3ATavyoSbQdWtB
 WWXMDogbR+5kpzIVvHw==
X-Authority-Analysis: v=2.4 cv=YcGwJgRf c=1 sm=1 tr=0 ts=69656f40 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8 a=968KyxNXAAAA:8
 a=A3-fYyU9wTht9raOatoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: x206t8GjwNmhuXw1wY92M4737QaQd9O-
X-Proofpoint-ORIG-GUID: x206t8GjwNmhuXw1wY92M4737QaQd9O-
X-Rspam-User: 
X-Stat-Signature: sy83zqmth4ex5d3a7iyc8mu4kcyrqstc
X-Rspamd-Queue-Id: D28D4140019
X-Rspamd-Server: rspam04
X-HE-Tag: 1768255311-550419
X-HE-Meta: U2FsdGVkX18VSlYXrXe3r25HKcfmrDn2yU2t6mDmqIM179ykSq89STQo6T7SaGlBuhdOIWKN12k7ERZPREJfoyzW3qdCvL1YhXDXKEfGhxzq1tIve+za9Y5wJCfVcvRYJ3akkXpZrl793O1mHQxNygJIy3mu2ryOXl416vkU4scRyqYyGfTCjImNR3mfTZcKrXD4iUh0p7WxT5Rxr1V/sEyiJ4HVIt986sP2D6XIEQP6DkJ3mvWjHUxEVHqW2VzWN2nXT/kZ6u6uIIKpqgOFvnEqman4o+hA8JyTuRuK3NUOiA4RZCXdrkMsvQG7eMBWvZJ8ZoZ4BSbXHFb0S2eonioYImNdUMT7/rn2+BOqebFx6NYeJHv+FiGY/U+6EpinV4KcHitvCVjS6cZ18QDerPTd9BLZ5yhSK/oVFmtjIlOSSjMoXQsk2Z1KVcymRr1MW97d9FbNwFtyCf8W1MLZIBWncuLW2fKxZ4G9vVcdZ31V7vZ3T4ARFflSw0Dc4PjUyA6ww/XmTQZXgMGH/fhetzrfYzYLDAOVc2yFcmxm2SzwV0nj7u3yaTxjc6GlPFXFvsnA2aZlF70Enp1XzxxYhvHbNo34XnO2yB1k78vYC6hgwMwFxSQYPBMQt21jLUj/YdTsqcItZ7Zr4unVQn7VvaWrVFj9FkAunVXiz5X4DKtqVpC18oa1AD/GtoSF+rQd0BCf3tYMrjysl1YXuPjUoKU84S4tWwM6zpkmGNzeCnd4k0+xyLKW17+o8mFOSonlyjKGRnxjfJBcnog3mAH1OiHPYJEg5df3jxzcwRDEUt7ezUS1NWZmuZMv8LhaVSLqfMiHjAyags4L8//p1BnHKNYFM3OHB2Ze/8JkvVPWz15aC/OCdMDqz5H8ME79pl9B6Sd7jq3QE7FLG4v5D/qYnj3OWxOeHIe4ECoIkDX/h0TwKB2RuE77jJzXPQr8dNEskToyVZQU1Xe8urnIq5d
 o8NM2ObM
 3KwegAB2eoHVmq8R22zTRMIN3Fm2S1KnacTeMCOEMzpjeEN0dzmbIFAPfgvP8TrXzfrHzud+mqIo92lkqcrwfZCw50z/EN/rW/eEwXZDajsuWriowLMBIjQfDM2UgRwviOoBMphnAeO3A8poxFeATryIdvW5BBmWbVaopSAas16ic6aeh+vFvx+Vb5aLA/MgzFY5rwbTcBPzf9itAhOO9N2louhhC5JrpGVemtJP80Wgg1LFrmWT2Fd0rcFNlQQpUEt/oIIXzWcovbBOOCXiDmrnZOguSft+ZBZ77hNBIB3CIQWE/WE84UMrDVk3VNA14AWzamCwqLCYPy9YRwlZ3edup7pD93TTy+vOJJtr0IuWm3HMHn8tyhoDXtC1EDlbWU1vbEnpM75iG/KlaPppXtAnYPJSEPFhYGJggoW8mWHDfiGAR0Nvz+c8YFlnRYZ4fHXtEGZcJLtTAEmBtCx5UlxpsDkHJwXJpzk3/urFm2U8V+FbVnQ+B7vkhbJV/G4h3mNS/+mmyoWc80WUZmqvBvuCkfWpaEYP4CLXjTXK2g0nMySLeHiHUUIh1jmLIXZEE5OgYWhXyeZ69MPYOXCUdN2Xe2Yf5OLi0dh/OLrPHjlPtM0pTegAfMpqu6s0iS4fkm8JWZMmc7lNVTwsGhGWFPunQJO00l+6xp6yzdr4m5fa7PQqqwVdT5bmDcoL3MueihCDvK0+TSnCnnrrcmy0q0P+z9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Li Zhe <lizhe.67@bytedance.com> writes:

> This patchset is based on this commit[1]("mm/hugetlb: optionally
> pre-zero hugetlb pages").
>
> Fresh hugetlb pages are zeroed out when they are faulted in,
> just like with all other page types. This can take up a good
> amount of time for larger page sizes (e.g. around 250
> milliseconds for a 1G page on a Skylake machine).
>
> This normally isn't a problem, since hugetlb pages are typically
> mapped by the application for a long time, and the initial
> delay when touching them isn't much of an issue.
>
> However, there are some use cases where a large number of hugetlb
> pages are touched when an application starts (such as a VM backed
> by these pages), rendering the launch noticeably slow.
>
> On an Skylake platform running v6.19-rc2, faulting in 64 =C3=97 1 GB huge
> pages takes about 16 seconds, roughly 250 ms per page. Even with
> Ankur=E2=80=99s optimizations[2], the time drops only to ~13 seconds,
> ~200 ms per page, still a noticeable delay.
>
> To accelerate the above scenario, this patchset exports a per-node,
> read-write "zeroable_hugepages" sysfs interface for every hugepage size.
> This interface reports how many hugepages on that node can currently
> be pre-zeroed and allows user space to request that any integer number
> in the range [0, max] be zeroed in a single operation.
>
> This mechanism offers the following advantages:
>
> (1) User space gains full control over when zeroing is triggered,
> enabling it to minimize the impact on both CPU and cache utilization.
>
> (2) Applications can spawn as many zeroing processes as they need,
> enabling concurrent background zeroing.
>
> (3) By binding the process to specific CPUs, users can confine zeroing
> threads to cores that do not run latency-critical tasks, eliminating
> interference.
>
> (4) A zeroing process can be interrupted at any time through standard
> signal mechanisms, allowing immediate cancellation.
>
> (5) The CPU consumption incurred by zeroing can be throttled and containe=
d
> with cgroups, ensuring that the cost is not borne system-wide.

> Tested on the same Skylake platform as above, when the 64 GiB of memory
> was pre-zeroed in advance by the pre-zeroing mechanism, the faulting
> latency test completed in negligible time.
>
> In user space, we can use system calls such as epoll and write to zero
> huge folios as they become available, and sleep when none are ready. The
> following pseudocode illustrates this approach. The pseudocode spawns
> eight threads (each running thread_fun()) that wait for huge pages on
> node 0 to become eligible for zeroing; whenever such pages are available,
> the threads clear them in parallel.
>
>   static void thread_fun(void)
>   {
>   	epoll_create();
>   	epoll_ctl();
>   	while (1) {
>   		val =3D read("/sys/devices/system/node/node0/hugepages/hugepages-1048=
576kB/zeroable_hugepages");
>   		if (val > 0)
>   			system("echo max > /sys/devices/system/node/node0/hugepages/hugepage=
s-1048576kB/zeroable_hugepages");
>   		epoll_wait();
>   	}
>   }

Given that zeroable_hugepages is per node, anybody who writes to
it would need to know how much the aggregate demand would be.

Seems to me that the only value that might make sense would be "max".
And at that point this approach seems a little bit like init_on_free.

Ankur

>   static void start_pre_zero_thread(int thread_num)
>   {
>   	create_pre_zero_threads(thread_num, thread_fun)
>   }
>
>   int main(void)
>   {
>   	start_pre_zero_thread(8);
>   }
>
> [1]: https://lore.kernel.org/linux-mm/202412030519.W14yll4e-lkp@intel.com=
/T/#t
> [2]: https://lore.kernel.org/all/20251215204922.475324-1-ankur.a.arora@or=
acle.com/T/#u
>
> Li Zhe (8):
>   mm/hugetlb: add pre-zeroed framework
>   mm/hugetlb: convert to prep_account_new_hugetlb_folio()
>   mm/hugetlb: move the huge folio to the end of the list during enqueue
>   mm/hugetlb: introduce per-node sysfs interface "zeroable_hugepages"
>   mm/hugetlb: simplify function hugetlb_sysfs_add_hstate()
>   mm/hugetlb: relocate the per-hstate struct kobject pointer
>   mm/hugetlb: add epoll support for interface "zeroable_hugepages"
>   mm/hugetlb: limit event generation frequency of function
>     do_zero_free_notify()
>
>  fs/hugetlbfs/inode.c    |   3 +-
>  include/linux/hugetlb.h |  26 +++++
>  mm/hugetlb.c            | 131 ++++++++++++++++++++++---
>  mm/hugetlb_internal.h   |   6 ++
>  mm/hugetlb_sysfs.c      | 206 ++++++++++++++++++++++++++++++++++++----
>  5 files changed, 337 insertions(+), 35 deletions(-)
>
> ---
> Changelogs:
>
> v1->v2 :
> - Use guard() to simplify function hpage_wait_zeroing(). (pointed by
>   Raghu)
> - Simplify the logic of zero_free_hugepages_nid() by removing
>   redundant checks and exiting the loop upon encountering a
>   pre-zeroed folio. (pointed by Frank)
> - Include in the cover letter a performance comparison with Ankur's
>   optimization patch[2]. (pointed by Andrew)
>
> v1: https://lore.kernel.org/all/20251225082059.1632-1-lizhe.67@bytedance.=
com/


--
ankur

