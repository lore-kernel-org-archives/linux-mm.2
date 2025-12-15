Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92F4ED5B86E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 20:49:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EAAB6B0089; Mon, 15 Dec 2025 15:49:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55D0F6B008A; Mon, 15 Dec 2025 15:49:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30C436B008C; Mon, 15 Dec 2025 15:49:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1265F6B0089
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:49:55 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A8E1C87A87
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:49:54 +0000 (UTC)
X-FDA: 84222897108.05.377DD70
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5BECF120013
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:49:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MBJwIhAf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=t6kBRP3S;
	spf=pass (imf29.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765831791; a=rsa-sha256;
	cv=pass;
	b=Co3aLYreJiOb30i9d+LFFXTKTYYaRg3ZNqbG4lzdHaIGJG/zwuwVr1CCPOaO9QdY1+RUpD
	A0JsZLhk8qrW4EWrvUkqPtHyfzKuoRKTVeLuC89Nze3XQoP90LnMfVRxff/zyaw+CBjFn1
	ZMQNgtGPntAmmB1uRtdF2VLpd9G0q74=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MBJwIhAf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=t6kBRP3S;
	spf=pass (imf29.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765831791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4XJtbi3GWKQqVsBF7tIWnV231xFv4xLpXrn8tZp1Qs=;
	b=6GCH0I3Nh4IlxpNINSE7wRQ5GVTuBrTduASoYuW2+snhimbG7gSoqXwx03QY+kgYDHvMrQ
	QuSZf0RDHgjLN71ffhyblK+O3dkPIL45uASU6L6Je2T7lD4Q7os6PQUqBrFmk89cvrFuS9
	gChoHSD+Vu2LMMfIkU1X90mj4okKSQA=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BFJCMnb2789064;
	Mon, 15 Dec 2025 20:49:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=w4XJtbi3GWKQqVsBF7tIWnV231xFv4xLpXrn8tZp1Qs=; b=
	MBJwIhAfyVKKTyWDveuc5GkFhl41S3Vtjs3WK9o5lKE+ImzOXyxrkoLlfroYNS0x
	NG4JNshsJQi/QuJgGA4dGiuZzQikkc1HJkkUtz1YSqNW2ciC7YaQgC4w5mE7VMkC
	qIiWEvlhTSjrIcPyZRNMkCd+4lm9oWu93ZjbWSRF7kkDN6qT2hCfzzqHef3mDKch
	dMa/sBb3o/5WgG8DIuh3FNgm9SBkecwKNDHvLFOUZxM3943YBk7mm0idqoWZ61Xn
	yp8k+dJfTuUp636PxMmkBscbngX3VNDL67vytAGyIylZo68XcHPhkfuOVYtN7sOW
	EYoiopNKh7cN7DCQVx3UBg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b10prjst2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 20:49:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BFKAmZY024769;
	Mon, 15 Dec 2025 20:49:34 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010065.outbound.protection.outlook.com [40.93.198.65])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xk9nkv7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 20:49:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kwCq3wWS0FZ+xeCJfb9NBV9SRstielVqRJsDuiWcffayOneWnyjp2tMq2KTQnuwDvyCwtta4YbKTVsyU/rFBOSN4axrhSys8G/Eva+ws7KBtcCtNroVYZBevZ8atShVl/SjgUNRV8bMu/rYYN0/Dph58zzLSrkEeOvyswmvSds9JxIsNDdwvEPtnpyq5UVUsnrbV0CfWs0TJhBTj8i9eFrpBZVHxKlX90UFtITa562/nnZ5YXqeoUolF8/Zgjo5bxNku5BL9FRaNurntLfw+ObDt+1otRyctrPuriPC9JyujCOdqpM8HTFsShc2KTGydxrvilUzoG5i5BFfsTuKcjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w4XJtbi3GWKQqVsBF7tIWnV231xFv4xLpXrn8tZp1Qs=;
 b=hnFz49TbaP5QSD8Di4sd/gbbbIeSvGrPsMmGmmKKT15J2/sIuhxh1gkAjGMOfiRv2BMIilD/IZ4iFYOgtCGi764X1uYGYMvTIWqERSvLfVzdUmPZqfgyzA0AWi4LEou+7Or4do3zXTeOpk2COirYJ/gGaQhtcQmALM/sQOmacYWZg/s8yozlo1lBgn0vQpFyllRYK+6IeCFDPV5h0lurnSb539suCExBWPqQn1huXgfAX+OVln8B+rmS9CE0/8jjavyAfI1RkCelq/rwdqpCGRwoVDenXWhtPcC6A2MpI1fEoaFTotl4mXFphZuSsU6OYndrkcpYz6er/KoXOBFTaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4XJtbi3GWKQqVsBF7tIWnV231xFv4xLpXrn8tZp1Qs=;
 b=t6kBRP3S+hanWv6QUwsvUjGeP4CdvmvTLDqbqG8lNjx7MqC24owdOYBxhOAgEbvfs5COTysDtV6hx6SlGlG/C88EyK0nX+ycCJ6gtkrT4FCmoRLEgPnT5ijn1+vCjoAvu10KlBQ/lXUIqmScl1IR3rpl/4XJmztJQjXf7a2vrUg=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CH4PR10MB8049.namprd10.prod.outlook.com (2603:10b6:610:240::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 20:49:31 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 20:49:30 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, ankur.a.arora@oracle.com
Subject: [PATCH v10 3/8] mm: introduce clear_pages() and clear_user_pages()
Date: Mon, 15 Dec 2025 12:49:17 -0800
Message-Id: <20251215204922.475324-4-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20251215204922.475324-1-ankur.a.arora@oracle.com>
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0134.namprd04.prod.outlook.com
 (2603:10b6:303:84::19) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CH4PR10MB8049:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f1d435d-a006-4ce7-3acb-08de3c1b7205
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xvvesLdVI2BhpMGnmM9U8c1tIWFalcQhfIBIKOvgOE43we/G86xliKRumHD3?=
 =?us-ascii?Q?FQk3iORgmhPqkWek1py+l0riIXq5vgjteyij9VAg0rGYji1joMw3eWgvz+Dj?=
 =?us-ascii?Q?SKnCwf0hRvbeYKpxvNDh07wP1A9VGVDAac8JDppmTm3+UL9mWtv3f71Dll/J?=
 =?us-ascii?Q?aMx1HqR4YcEyTlstjOFgyNeVPhv2cotRx4zCRAwV9wuLuPEbk8qBnYnfqVyc?=
 =?us-ascii?Q?02HxryU79AnJ+RC3avjmlsBCjyr/U/Arl9qNTVFzKEBAjziZ42u84w52mne5?=
 =?us-ascii?Q?w+n5Vwt+YMnYlt+BdiAz6g/6FpF/jzYVA1jXcrpYObT/WlnrT0LVqVV99Y3g?=
 =?us-ascii?Q?Q5Ae+/FWI5uUQIY7Lt0liNhfo+pKH1zi/UdfYbqefoHVIen9h1/izvViafJP?=
 =?us-ascii?Q?zY5JRPmdL4qLDADoKM/5wZs9GEh1zV0fPDLfNmxY6xylZ+2Q0omnkRGrqMe7?=
 =?us-ascii?Q?/OQcZePxUQmu3MzamSg+682E3FsvXbWMEVkC0W8Tl/RuVYpCPtwrW1qXXLER?=
 =?us-ascii?Q?JoLuU+sJXpQONEil5598dgW+nEt9VL8PHS9YhksyJ8pZ/gIL2IifUQcf2Hh5?=
 =?us-ascii?Q?01WSRabEymmqiSpcA6SmaptXB7wZD1Z+TzRCwqf2tTOzz5Cc7po/AsrOo3bI?=
 =?us-ascii?Q?suEDGuf0ss3w4VYMcmhRwZpyMtMCsZ6we44iM7Cv3HL+BgueyOCo5AFvIEPU?=
 =?us-ascii?Q?DjH1TDVIfP/39nru4nNCbACB6Jc4elhYgEfH+zAV+rQanwbNAy1Sp2GlNuMg?=
 =?us-ascii?Q?BmYiUGwgEsUi5BiIlBZ+lT2LxxxajO/Lc4hUwCNun+4hxChnYJtekWOPRvQC?=
 =?us-ascii?Q?6QbTjRk84et50WS1X2xjQVcMPgaZYwG4pfxbKysxr8G4vC7Oy3LFnLabPvfA?=
 =?us-ascii?Q?Keoy/x0OC4GD8N8XHcLWuTNMpuNUxHeDWvuS/xQbvSWehkIrCb1co6DLLMRE?=
 =?us-ascii?Q?u4yfUcrG1OI515gHgacLEsLEQsRuAgwIz0LhSdj0zIreydPyDRcssVTAhYxO?=
 =?us-ascii?Q?+7EkNwTPaFTCTrZTOoUlivYYEWtu/R37oosI+VFiok1BpYzK8EUXl9NwEkBz?=
 =?us-ascii?Q?k8iVdnnjLvvZU61mReJAmLcL7/QXy4LaLwa3AuhB/f6VB3LSmLA+nQjqTHTZ?=
 =?us-ascii?Q?JM6jxUdthGf9eUYKqO3iQ2Xu0R3xTqhDXCvZzNiQfRVM630nVTsbW/xtrDTy?=
 =?us-ascii?Q?hRLOAhDbsJWFgmC2jE6gR8cC1rdMM+6bfAzqV+cDY4URE9+T03ylhbAFrScx?=
 =?us-ascii?Q?U0Y8Tw7obnwhmAicp7E1FA4y5eYnEqETUGTEdDAKQak5zuRh4fayETBe8DUD?=
 =?us-ascii?Q?wjhTngnPeWRMcptTYLFgA8fFzyUvcZyHFOrhTjQHZikJgOMnmLKuncJzpsue?=
 =?us-ascii?Q?GB2eHrx0wiXtO7IvuynftSK6DdxQo+acJNUMSi3bs6zxJRsiBDDjvEeU67Ai?=
 =?us-ascii?Q?aaUGLUkbB/n5IRuBl4law60tDgom5KMx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dqsUHg5dvjff0SvWMlMjwiO5lbDEBdTjzZHeKvAzo67JR8/TeFK4qzP3fQgy?=
 =?us-ascii?Q?3auYN8A0UIkvFjhoPSChzFS7YmkMkzGMLB83uyC72H/y3HmfJBmXw6S0E8F/?=
 =?us-ascii?Q?OswI9kBgkZjtKWpQzPNzMwf/Z2nMCrLfWuaAIWZBwajY+vl+2eW346FVuvXn?=
 =?us-ascii?Q?T4Tvao+HJyd8U0frz1ISoHlomoGujDjSXsLnPACgNDyftIZ18a9CJE92sID6?=
 =?us-ascii?Q?goVobQfrNgPklRd1AERvsh+TZYDFRnke7XBoXoaxABDJ8y2IWdPUfdN+MCgL?=
 =?us-ascii?Q?+R0m+fQmMH0ur8PE1keAEw/ympawDx4IiXc4CeT02eWLRE0EjaEry7yBmAHy?=
 =?us-ascii?Q?oIqvhaqwe4qDqqSvRQG1VYa1glMAiI+C3oI17YQuew8Mvov6Vka7tcY63n5h?=
 =?us-ascii?Q?FcM+/Tc/lApswVAua1c03C85KClS1mLyGOVXU6F188IG+wUJldnVUorjHgNk?=
 =?us-ascii?Q?qCzsqXm2lxknisnmVW5I7Wyowqv3K0WMRn6zoJmXysS7EAkRYK0B+f52wPtD?=
 =?us-ascii?Q?FfR0m6tmu2jKoOkxlCXH4K2N8yY8mkRKlQRns+CSv2TS7OBTnV+glmFjRLMW?=
 =?us-ascii?Q?Zu2dv5MZ3M767FknYBrGrTTTm2JSC/yn8g/N0Tdzo2AWrWHtaZ6jJsjY52c1?=
 =?us-ascii?Q?cVmh86FZZAT6Vj8LgHFIlOYurOcRIxS/ezDZPFPtK3X1wutFVxlgtAbcwa3D?=
 =?us-ascii?Q?nW8kHNVNnQz5eNPnmI4gp6a9Wl5Q/pbkz3pPxaZQ4OLMdUpfiWrnwZPnhskE?=
 =?us-ascii?Q?67DMZR5eyhll8ZhpfeE22641cRUERHJTZE0mG+m83rDJhO6T48f2vKcJCMG6?=
 =?us-ascii?Q?htgtW1ZRPDfmr9qvwTM3Y7ZS+CTk+jRPCUjlEFHS3gLZZQhWfKS1a5sMltoK?=
 =?us-ascii?Q?+uWegb20RY89izTcTAkZERqksM68Iuma+SNkUaaEa8ShRaql90Jmelw5OdOO?=
 =?us-ascii?Q?4E1+xe6qC4jb8g8J+fSd9dyKXJZ3ZNEBMa0XUIHkZnVtrD7EbBQDWZvDatwv?=
 =?us-ascii?Q?STxLHpC8iKbJNo+c6+XwLAGW0DY/BXU+iPD5bcAJ1KphfPPAeJ8J2Y7AQnOm?=
 =?us-ascii?Q?+JbwDizcgoi0LfL6ajysS9GILe8Y65iy6XUFJPaNa9Y5LzewHfn8ikAHdB2B?=
 =?us-ascii?Q?BqoSJLXdWEh7YV5PlPCIR29VU96BHYdt4ilFKMM4B0xjwRf9pEly6wVg4ZDS?=
 =?us-ascii?Q?Ms7skSJr0o00vFQymyCjVgWYPdQVIoPCjkUucDVwQOOlvm6DyYPJbJc7mP8d?=
 =?us-ascii?Q?GHB5Jf47Vcjli+9mETcg2ms+adHghTKkDUP9voXr8h6tQmHA0TSzUcBEzWxC?=
 =?us-ascii?Q?zk3LsiH5knfEZur063HGKfGYaRnm8BkWLD1Fq98tQq/RTervwAGX2uscWXS8?=
 =?us-ascii?Q?djCe1WB/xob7x7dqiQhwTUDRPvbhcrbUHOGcJ0DSZU8uXUXFvYzic+dAn2Ju?=
 =?us-ascii?Q?cwke9/sPo1LBxl1dBI10Ri/vUbDCY+Oq/rLv+e/0yfvnfCjLlfiSABFWp2Cr?=
 =?us-ascii?Q?Ifoh0DEVngKP3XtRvqkV2V3N5rbLKttTkuv3CUB2daYZuWrH0LeDZh0cXMdx?=
 =?us-ascii?Q?E+n6in75oKGe+gkr5l/PrYQ05jJ6zvqJR/UWPbN0/aNgoJKIYZRywqYkevcp?=
 =?us-ascii?Q?6A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rSVWxV8BnzFoOUZu3ebOd+HZaCFR/jWzkfAL6tLbteTC2b+5uTHlFp7UZgkWYGmv+F3Bx3wt5h6xPQ9veA8gIN2aSHTkH3bC8OctPRbcwD6FOTmNS88TDMBvKdkyzASKmOLplm3EHhbO1RjiLpUj8pWY71FjDf+iNuXOA+olX2bWgvWYtK1x58aZXoOgT0YNrfFaEcXkQhIkbhiQAgCsmCkTmjdjr74EXzFvFdVQxI/nz72YOLY6lZ/o0qeTyIxpX0ROvYp4/AFZKOPkLeguFkI21Zsm4NjHQFLjsL2qTT+Kux5zjSIo/QDKmEq502q+39itCDQx76DrL7nW48W6d81l1xT1WKVVphEwI2+JdHIjPvCetGXyVWnDx2i/RucOhXChCkWBBynD3FWtbDUhqbFB4l/zDa/WE5HC5+200kRehj1hJY1qBTdD6tJkdSmLUywUL9JY9C5K/ITLwSZaXQYOEcutKcC56lhE6Upeie9kUZZUPx7gB76qWs1Wr4h+IsrFJ03DMQVnRycYpxPTkvs+YbYgzKXlk74DvTSt0XkIIMNFrKunwz/eo3cgEyObsiUowEFf/0r4qb8dXGFGkzwrrw5Skk9q9F9WonTkDpQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f1d435d-a006-4ce7-3acb-08de3c1b7205
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 20:49:30.9499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OPvXdycD/bfibInbGUSaHM2h9gt3Dl266tkqHGmBbw2MzFRbkGZSlPqFfaQGiXtFeeMrExV0JfsWVR3wPa8QstD1ZG5PI4VFIDBDGaLq1wU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8049
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-15_05,2025-12-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512150179
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE1MDE3OSBTYWx0ZWRfX0qLHSGxxWcBB
 0Mz+O2u11kWmUrVX++ygP++D2BC+d0G8HMQQ1n5VyhDWSFAlix0z4VlRy/BxkP5+pwu6AiJtqxN
 tL1CP37Y0rxx66B+rq502241lnac+un4IFeWw92nt7nQZ/h9Ho+UjM/IsyVLGMl73kBmJu/L3Dd
 IGd3izZKBfaFLwKH/ibmihkDYXMJgs/l4SopdDViIf3CELocT7Ts3AE7doM+ADLQk9VK11+ORUn
 4d9SwbZPMZHs5jJi0qbfMu0Bdt7RGHs6Y4aNZmxD80RCqtT3qfJVcofpNEPpsjLS5Bs9drz3oYV
 aqLbEfee69dQy+9y1kpen0XiOGvO34T5Mi+XquvUs6ab3Q1GBotr/Av3nBg/bL2oM/vDmp1ePKj
 LEmSSl3/7iOjSmShSALiuXAGDU747g==
X-Proofpoint-GUID: iz2CW4g5OP_lyC54zSyQxBdOPQNr0y2U
X-Proofpoint-ORIG-GUID: iz2CW4g5OP_lyC54zSyQxBdOPQNr0y2U
X-Authority-Analysis: v=2.4 cv=dParWeZb c=1 sm=1 tr=0 ts=6940745f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=gTE4AWREPhgkrBsjIOwA:9
X-Rspam-User: 
X-Rspamd-Queue-Id: 5BECF120013
X-Rspamd-Server: rspam04
X-Stat-Signature: hk77q6k3oxyhckfnci3iqzf5cw73g74d
X-HE-Tag: 1765831791-797680
X-HE-Meta: U2FsdGVkX1/xgz/I9m0+Vf0BTLEwRLmH6EqyVj3U52LVeQIp9CbT7kaMF3P2Wnx+YE1h6mEuHoKk8m60fLNRE+jKmgRWreTYkOVFzTR+7gVrMSprZu8iWDTGF/hVlQMEtKz5YbjoW+vH/sqrn+uBABv/yJda7dkfgnSpAXwyE5Q2/eXeAhsk89l/IkT0y23+jZfKjGHo8bnWvpzPnwnYP+yZrQprajdeYXAP/oaiMleZtztQ5/Y0nFJhrSOt5HpN0/vRVai0A5YkwP1Z7D4l0MVc+zxtJlrSa8bUvi60nDN+zWqrQvB4GK8iOOq2nUOVDSadI4SmDxqVUyX/JB+vgqh5Re8nPWihL5oyrBsZZcGQG4hTZJM9QjPf0Cqg/0/EAu7iWxTuXCxoL9FU7T3NHcOgPvHJ8WAjBnsLcN6x7q9fz9GKCuOGpek2beyxDlH7HSpFlN19GEB7/s0AUMZjtlqkybxGf5PBHhTXBbov3Dbh7VwnhZQYnlYcs788N7hqRdOwLm2IGUeSGTENCYn18enc3Oq1kJXeHLEw0tkGUdPjnOwRn8foLGxmmTHw/n/dbddvhE+VB846YobY6qUOtHJQH3YnJcr/TdaLjpM79nRulfa8icwqtkz/Bfb6+1jPUOZVCv2IWKNV740AlE4b22/oCOmJZKhCA5D/4ZnJ+cX3wYkhTrbWlITDgCchCyuPtJ+qiYcfJ6eKQX2HZ89j1uKCuQkmzkL4qDP0+yGaIo0+RqqH7RpP162DoNLeqbSwwrmT1cFZmNhIaAA5+FPpXTnaf5dquRQLolVv+l3iXUWveVD0mpViYn6QWoSEodoOZu5tOKjQ80LSLRTPV4Au+eBBe3DiVPKV5ywdZflZTmnnuANiWXZtQjt8N4hWbYNJIMy0BKCU+bxFCfLWiPRB+z1sQCtTsIQHuQo6ciw+jEQLhcTP56M4/KbIF+EOSiGs3a6HNBDNCg6Hizq3yi/
 KfU0ZVm0
 ctbYikTgPV01i1kx8pGwUuxgB1ZHRwVTMBIkgwmaRwfx6ojLR5TcXaX5+i070AQeSD6gmehe/D2GZjg4yMeg/b534PHPFVsBUqr1LpoEZKhgdyyW/zKb09IVpM03SOvps9E/ZoSgAMRWcyF74US7sZaTXQN8HLCHmiPVFpb16b1heX1w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce clear_pages(), to be overridden by architectures that
support more efficient clearing of consecutive pages.

Also introduce clear_user_pages(), however, we will not expect this
function to be overridden anytime soon. 

As we do for clear_user_page(). define clear_user_pages() only if the
architecture does not define clear_user_highpage().

That is because if the architecture does define clear_user_highpage(),
then it likely needs some flushing magic when clearing user pages or
highpages. This means we can get away without defining clear_user_pages(),
since, much like its single page sibling, its only potential user is the
generic clear_user_highpages() which should instead be using
clear_user_highpage().

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---

Note:
  - reorganize based on Christophe Leroy's suggestion.
  - Dropped David's ack.

 include/linux/highmem.h | 33 +++++++++++++++++++++++++++++++++
 include/linux/mm.h      | 20 ++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 9187bfaa709d..92aa1053c9c1 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -217,6 +217,39 @@ static inline void clear_user_page(void *addr, unsigned long vaddr, struct page
 }
 #endif
 
+/**
+ * clear_user_pages() - clear a page range to be mapped to user space
+ * @addr: start address
+ * @vaddr: start address of the user mapping
+ * @page: start page
+ * @npages: number of pages
+ *
+ * Assumes that the region (@addr, +@npages) has been validated
+ * already so this does no exception handling.
+ *
+ * If the architecture provides a clear_user_page(), use that;
+ * otherwise, we can safely use clear_pages().
+ */
+static inline void clear_user_pages(void *addr, unsigned long vaddr,
+		struct page *page, unsigned int npages)
+{
+
+#ifdef clear_user_page
+	do {
+		clear_user_page(addr, vaddr, page);
+		addr += PAGE_SIZE;
+		vaddr += PAGE_SIZE;
+		page++;
+	} while (--npages);
+#else
+	/*
+	 * Prefer clear_pages() to allow for architectural optimizations
+	 * when operating on contiguous page ranges.
+	 */
+	clear_pages(addr, npages);
+#endif
+}
+
 /**
  * clear_user_highpage() - clear a page to be mapped to user space
  * @page: start page
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 15076261d0c2..12106ebf1a50 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4194,6 +4194,26 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
 				unsigned int order) {}
 #endif	/* CONFIG_DEBUG_PAGEALLOC */
 
+#ifndef clear_pages
+/**
+ * clear_pages() - clear a page range for kernel-internal use.
+ * @addr: start address
+ * @npages: number of pages
+ *
+ * Use clear_user_pages() instead when clearing a page range to be
+ * mapped to user space.
+ *
+ * Does absolutely no exception handling.
+ */
+static inline void clear_pages(void *addr, unsigned int npages)
+{
+	do {
+		clear_page(addr);
+		addr += PAGE_SIZE;
+	} while (--npages);
+}
+#endif
+
 #ifdef __HAVE_ARCH_GATE_AREA
 extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
 extern int in_gate_area_no_mm(unsigned long addr);
-- 
2.31.1


