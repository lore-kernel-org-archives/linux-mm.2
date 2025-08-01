Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8801C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 11:00:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FA566B0092; Fri,  1 Aug 2025 07:00:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D26A6B0093; Fri,  1 Aug 2025 07:00:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 473426B0095; Fri,  1 Aug 2025 07:00:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F2CC6B0092
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 07:00:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D733CBBAEB
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:00:40 +0000 (UTC)
X-FDA: 83727895440.25.AF1F957
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 661CB140014
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:00:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XikW3R+L;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="f7Q/QHxl";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754046037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QNEUzIdEQEMD28TtcXmPmSx9p5o5bdPH43XOSoAIDX4=;
	b=639NKMl5Ci1w4ZB5ImWXUz/1120/pqx8KtEaFQk0OiZz+rijKu/JrH50GoA7vyNMKV75RT
	8l5Z/ghNo4lypvA5ryg8OGGyQW4Xl/I/1GQI9tVWRWc/d8OOOMtJuGXAUUMoXkxnBxmXHr
	rBooWIpSYXzvZsoFRCodO/kf7Xa+br4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754046037; a=rsa-sha256;
	cv=pass;
	b=NjLAAq20K6NAYkB4drmO8TIf3ggbSDD5fUUbAtxJb33mP4tJR9vilAb8wbNWii8g/r+9Cz
	Se6IWgXS8W1KB4mT13bLWEQWtpGvAPqrGQy3Pp8S/WRuKbJKspGfKv8SpRzfotAFmHZ+ci
	ShPu8iEJItPB5IdQwcqB8LGz8V6B8Yg=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XikW3R+L;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="f7Q/QHxl";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 571Au7HK016906;
	Fri, 1 Aug 2025 11:00:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=QNEUzIdEQEMD28TtcX
	mPmSx9p5o5bdPH43XOSoAIDX4=; b=XikW3R+L3W8mBXDQjHztDriG3CWohfV+GY
	mCiAHSVoNcFSNyu6OGuoIeyRWZulUcekQtAPVlrDi5U6DBe0qlg0aQ0N7jniBAxJ
	3JAF/CFaofiO/yarB+zxuVyQB4w8thqgwBC4P2CyY3LrryODFk1FnWHyD3+gGkvI
	HgkzlZGEU49Hy4q2FPGY3xrKy7XLlsOG+x48VhpLIsiI/GmlZNeDPuIz4oNGL4yn
	bkqJXB5S70qOaoToAHCm30ut2isxLT//itokycyxvuHxAIvbhhHfONJX7G5Qlp+N
	DtjdbBO01BGL8sMJLJ/qADgNLFdgoT1Y+m8bbG2R7lndzL24JSsQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q4yp0ub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Aug 2025 11:00:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 571AjHWB010380;
	Fri, 1 Aug 2025 11:00:34 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012002.outbound.protection.outlook.com [40.93.195.2])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfdhrgk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Aug 2025 11:00:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PYhOpmw/zTbGITcexiJaGj7VSSAjHvfCPeSMqdCcfZx1YrqQ6E3y7skof/oki3US/qFs8qqfzgU2GR4Q7DK4t+JpLdqpIOtDPblLocst/w76054tRr1dbzzdwcLZr2Y863hOxK5P2rXzeLFREBg4311qf6V/jXSMu4K5GcbOrPoFNWDY/3hr6RTKos1FSekY/BpIFALLFaaAnO6jdKwmGfi1onl8efA7XwgqZP+nwplNT8vV+ofEg1ya1Pl0VVpfo0dxJZp7ZZmpP3hk8awIzFL8crOl7taeRyzz6lEneo8r+/E0xM4qT5TMYJ6u+LUarDcZ74o14uT6FQeAxFoRqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QNEUzIdEQEMD28TtcXmPmSx9p5o5bdPH43XOSoAIDX4=;
 b=tqjESeEs3j07W58sNET8U6JKwxHcdlrZYLVjGLpjwHK423Xch5h7Mauhh3mCrPY200GATkpKOwke19HDSHmofNpA78dZz0jAi6IelOutrAPL64iTlRqBUuoWFr7pyYKfN89GsInznqK2fe8b2+d48PmhnQuSPgomMWx43m7YgKSaaN9asoEUbtTcc9r4EtllmdybfbAvANqgRcktvejVyFEY4TrpD6pwhA4jrr5y1vqdCNsP5k9vTVlV9SwVmIV873x3wXPwSYsM0A3GStaSDKjEL3TKN36v85FD6I+7DWirwKASM0BS0aM+PDZdxlQ2N1gOH8oTJ6d+XQE5P4xaeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNEUzIdEQEMD28TtcXmPmSx9p5o5bdPH43XOSoAIDX4=;
 b=f7Q/QHxlvfzulmBQbFRYOoWqaUbmAU25sT7e9pnz8gsvwBMgGENOMGlzTRtn6A9kuFz16npUPcEFtAAP3JfzNgcvLxptCyhQy6shoMkl416qzvMMDMoOuY51LjWqpQq1DsGLxoFDnakkcdeGIIG2qzwk2W3rVgNZIEDNLGlXKOo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6181.namprd10.prod.outlook.com (2603:10b6:8:88::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.16; Fri, 1 Aug
 2025 11:00:31 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.013; Fri, 1 Aug 2025
 11:00:31 +0000
Date: Fri, 1 Aug 2025 12:00:20 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, jannh@google.com, Liam.Howlett@oracle.com,
        vbabka@suse.cz, pfalcato@suse.de, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm: change vma_start_read() to drop RCU lock on
 failure
Message-ID: <4f2fa8d1-0f80-476c-9391-cbec67ec1ada@lucifer.local>
References: <20250731151919.212829-1-surenb@google.com>
 <20250731151919.212829-2-surenb@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250731151919.212829-2-surenb@google.com>
X-ClientProxiedBy: MM0P280CA0062.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6181:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d4faf23-1655-4cd2-ad4c-08ddd0eaa197
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lbC4GxTNto578FAa6+A8aSximyxZ8TGZFcR7iobE7SnHwkcuTDdJXzNq5IiS?=
 =?us-ascii?Q?Ja5yH6MmIOh2sX4H5d39N2ZrhYJu95odjciN0022vRM/VgU8i2yVB6PNsbsT?=
 =?us-ascii?Q?2coVcTqMu0qXPcpkn5DvbvTGXvXyPHqiuCBHYy1lXqgaNQ7YuYDvvgkXbn5l?=
 =?us-ascii?Q?wJcjpmJy5exZmF6636fCtsPApSE+mIeXf+EeNhplEPyXsjILF0enNHbvGnFY?=
 =?us-ascii?Q?MBw4HihsvwhO6dRJFFwtrftxe0Ii8h9657J8W/4qh4GqEYlDezAyU9ybEFQ2?=
 =?us-ascii?Q?JGAE0cqaSxtghdaatw4FmSzp8uzg0BZ1kSVDS41sUOcqsMvuhIUIUnLDn9Kf?=
 =?us-ascii?Q?Wl/ZEgRz68LrOIYgYrEpNUrFSKLzL18CHSkIfkApPRXplvCFmVW68HlASSbU?=
 =?us-ascii?Q?oKS9TRYH2z7B2OKa5wO87UDKN0aORdK3b22FS7lW497kyDep0AySv4VI5PQe?=
 =?us-ascii?Q?KUedo/gelEnHnBlXESntSjyXA3A8nLw88jMGfmAlyrqW86kcm0QKw56tNb/V?=
 =?us-ascii?Q?exlagng91Q/ptZFzq1PzCDt17pIYt//C5sGK97/B9rkVBCJdif+7fXn0loPv?=
 =?us-ascii?Q?T5LFH9mGQWOWusQKGbt4lxQqfhV1aSZyX9Cg41fJGjKMG1ZIUDcVflYEs3ex?=
 =?us-ascii?Q?qfPbA550Ex+kWTIf+C3vBiGovRVFr+yi7y2K383dj9TxdN/o0qcGE3rT4LE2?=
 =?us-ascii?Q?F4D2potJh8HFmYPE7/X5Lzv7zCJoGZQWoVcxlNoi3O/OD9/NRsw6T6bygE2v?=
 =?us-ascii?Q?9iebsy/60AmF5uvya7A0Z90oPG+rJ3sckg0QVwPkyJ0odem0wm2cXhNNm0el?=
 =?us-ascii?Q?dOrZ/b0kNZzayVic/i3DcC0+5CJ037YQr2O786ktOnJ1D49DqbGKXOJachFS?=
 =?us-ascii?Q?0IxFHPPAUjn3r3W2RszQiGqKH6WBoYjCnWMRGC2ZokjhRCwVa9lFJvnbfj/R?=
 =?us-ascii?Q?ZH9NC73VfxxXQLAlhLMQfZ2DtHQuTGGDk5BKEGbWA76lilRNjVdwNG8pszey?=
 =?us-ascii?Q?dXzJ/yHHYt5be9Yb+wOCVuccoCASPbN8g+sSfYH/NjC//Igh7BDL74fjOk5l?=
 =?us-ascii?Q?eWAaVeAncs6gd2yXke4Cc+2OVoorZSRFNAwpljwS0yCHOpK1YkbgSTBkPYl0?=
 =?us-ascii?Q?VvzOqZQGuxrpHq8I0GgPpGezySyeedec1pvKWTEczjftBFeee8N5ensPBPPk?=
 =?us-ascii?Q?ZEHEIZBuCqzXhVgS7hxej2dNbPBzAlC5lpblHJplYg5FHv5eMDqXRPPqrgsD?=
 =?us-ascii?Q?d06pZ8kTrVtQcW/kPDMyRUYOvIXNvQdPcjk181cT/p6Zv+ry/JHHu4uXrbKL?=
 =?us-ascii?Q?B39wOwRCRz+O8L3ihinEMy3vR16/pjb9wEt54J5gOugVwVieIuV7MPuM0qmI?=
 =?us-ascii?Q?822rNRZqW+pRUsUxjWViZ0xM2RW9ofhwyU/5FyeWdrlGrNMqtbwvKgA0LfcX?=
 =?us-ascii?Q?dMJM1ZIsLAs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a7RweX/Ri4Lgpy5YLP8yA8jQbiG2/MOBwL7QsmPJBYDzQ7FFxJE7opKR9Qut?=
 =?us-ascii?Q?6i5nXsYDtT6R9VvAOE1nphgO3+0lLa1t+shhaC/71mEDwobz7y+wsEknZpET?=
 =?us-ascii?Q?fBra5KSWcFelj1wdXKQ8zHCtvhDAdXF+WmVRQRQR28HW/xFXJyFNSJc/P8i1?=
 =?us-ascii?Q?t0i5SvtDEb+cQHyLQVlrQSNP8r26/c9RfvfplZd8dhAXi2VC0IHnnyYL6GVS?=
 =?us-ascii?Q?/n3kloaTCIK4AzIkOCf6QaXAvrROwsXlBxnUdWVV9VsyzKqJE/xpxEF0PW+Z?=
 =?us-ascii?Q?/RvFbftngjEEmxZhWZOBeIoihXzNSv+h4p2qMXvp1TlcOsKvhPFaraKaMzWd?=
 =?us-ascii?Q?aYozAzhqRRhY1Feaz5NMG2Cbho74hwAxy8inpB1po6AJQsLw3uIgtnBNPtjS?=
 =?us-ascii?Q?lU3AjQZcfg6KTVUJbKDZCMaXnsALYvr1xciZFXvdRejPcGqZCR58Zb7FU9XI?=
 =?us-ascii?Q?YHaLPkQUGtWQFinSCxB4uRltAJnCrevUR4M9mtQ1snF5ONQwJykOjo/MOt4P?=
 =?us-ascii?Q?fRDqCvBO93ff+0dgg4XmP54igygUGVKhO6EISGuBBtUeiIbiBQAYAGkyrP4l?=
 =?us-ascii?Q?USl2NsXVOP6rIP7CabhGDmclU6qKiul+P+4thgpAalF4LfNLKWdazR2aEjY7?=
 =?us-ascii?Q?LAGSUMn9DRYwq4pVEFecsx9lFO9TFhXVAQbE1GRxWSs6waIkOuCQWwiQCZe9?=
 =?us-ascii?Q?bjOOsVovx4sUJySqYGOOVZy7VBF9eQVWDeMBld5Oz2CPFRyIMvIF8ho0z8DH?=
 =?us-ascii?Q?xyMOKD0xmM8JDrIHZbABYOL3FDmkpltG103zMCv5JMWpnsCmMMlxFncaIX3T?=
 =?us-ascii?Q?aNjeSE26WpmgbD5NCRXU8S0/RgxVQMLm30TqBnQMGJ99WFsEm/MT6StuG0uY?=
 =?us-ascii?Q?7xNs+W6wyCE7QituLxd6pQPhZAcvPY8jHLkSPqVk9WPFAk9KE/l9nhng+SxM?=
 =?us-ascii?Q?Qp7+X4xqzUQ4dm5Vz+q1z10AsWQZNKuJjS7E4Ip5RatDuZqtOWTERf39PO/v?=
 =?us-ascii?Q?KhOILZzx+Z3UxGD/InAgKmIY4VG/2hWgVnB809PjFb/KH+1XzXMdaXZLmals?=
 =?us-ascii?Q?pnTZioBrNeIU0uqCX8JXX+A6K1NxOXQ2r1P97sbjDJnkfmNm5LQ39w1EII2z?=
 =?us-ascii?Q?fPnukNZStx3RQxQNt1myxyBBPKdg+28GgjvTsXpbDXbhqbwcgAHpN4R0cRfc?=
 =?us-ascii?Q?+VH0W67UFotxa8j22ehELeAtWJ92jcuyKD9ePk2Q3SSvOCgx0iInh779e8p5?=
 =?us-ascii?Q?RBomXz7Oy2rfflXnS9IW6FsF0UfqYJiuhoBQP+33WcUuitn5UWS5+fUNCkq8?=
 =?us-ascii?Q?xL4SOJbPOlLFyve3lDSBdYBGTvI5GniSK1PA0PWBBuTyDkVw13ajCz6txdKJ?=
 =?us-ascii?Q?zf2Owgz7/0+2X1ZZTrLCjnuzicfiSfHOunimzlOVmHcv90HP2PS9Vv7gZho8?=
 =?us-ascii?Q?RTxWiGkSBJAGhPQZoX1JY7mkdpPQGG5iht9wKz5Z6Nd8G+PBqmoEx97LzGq5?=
 =?us-ascii?Q?u1SjnqEyoUopg1shrTcz4Cyui6++OaX0EOnhW4p9FNpHUhFnP/tY68vMJXTc?=
 =?us-ascii?Q?Z0/9M8nWhxlItEeSsaeVoCxejSTSoS1i+3PqRoZACJzw9T5CGmnP5sVldQOa?=
 =?us-ascii?Q?pA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tUxLWbOFiwMuBKtmpunFPIiX7CiPE1NsgcShX+55QRT1C+XO/PkdOwwApCUQHMFET4qCEnQWMGJ5qhrlX1F7zcgLG4WbFYrJN5UmOTwqs7NA6wlDNEyXGRgQUbB0x3Y+yWn/ukEjfB3mnVxbzwXsx4BATnU5KV9nnkj6QVlwLqyR7IPRY+VlQ5SqYmDSc6dITZ7LLfjIwq5w1XPD5MPcEwqM0JF9mZK+b5dkx2R2GuvT5YrI+O3BwMRdaPgFJLOd9hWr02x/9q9hZLxwV8Ko00xTYXSghIq74du+YfC+CS+TnL0pLDyisDcIs2lybLvS6RLxnsImnceltA+/n4clrl9puqa+cTfolTturkXnX+bWtyzsOrK7DT48TektwmSXkB4Aa0yjOk7RTDxC3PkWmqSpFtRl246y7FR2aAoBtJb3RqTnbMHRCKR3qwEoEyRYUrYpsbldSUpVVi6ElkVyRqb+6PaLb8c6xx639twx080RfuVeoBbnIBsOaTplboVf0Sq3tVouKIB0xoJ4WPtibLU7lnvKMJjtp8Plk146elHs2HpRO5JQpJMlPVIQgBPNDrwUHajFiDQZD4dzYAX+1UZTCDRr5o9SXEFCxESG6Q4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d4faf23-1655-4cd2-ad4c-08ddd0eaa197
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 11:00:30.9495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G42owfPGlzLFv53g+Nn2tqwD8mAcXAH2uLYYj/DTjO8syzIeL0S/OxWCcZGvk4uOYtwJmpsSuo6GULAH53WFNScay1Kp/raHe4vPg9eIad8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6181
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-01_03,2025-07-31_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=743
 suspectscore=0 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2508010081
X-Proofpoint-GUID: x23ajlINEfJPnya_xDIMsGM8jTifBEMn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODAxMDA4MSBTYWx0ZWRfX9W2+EXHaWWYb
 yfz/h7x1vRYQnrmWQQKHyNyGk+KA0a/NC+CxmACKNh+fyKKBQ8RmBHn4r3YTAkxkU4FhKzZPkn8
 ofR8EYmA1ffj1ODaB05rQvm3dxgF99D8bFIHs39hSvzm7P17d2zKZIjqJyC9lNyctA0teaiHl1o
 tv+iwHgUkcnFxX7RvEwaUA73scBRXIZ+jqzxYyQnsLDbNhoIGLsaLTX2spkV7sL0kOH/MjwrscN
 lDMLIJ2HVBYiBsogpjKRdaP2f9oQaSO15jbfv4FabreiCASW50fJ/109x5vL0Gyb9mCDOZTLGwa
 KjHz6G1CXF5nkqEFpgG9Xappk8ixxlrPJYgeaW8lAXPpGpOdRbinC3CPYpydwiKo/cofKOcCjG1
 6bJufPZC4jGLfSKEIOv1Thmi43krCGYQ0pEa2TVuzKEX+UVbNdRZaenkrpBvyrdhV11do32x
X-Authority-Analysis: v=2.4 cv=ZMjXmW7b c=1 sm=1 tr=0 ts=688c9e53 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8
 a=yPCof4ZbAAAA:8 a=E8FL2OH8mw8bT491xkMA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13604
X-Proofpoint-ORIG-GUID: x23ajlINEfJPnya_xDIMsGM8jTifBEMn
X-Rspamd-Queue-Id: 661CB140014
X-Stat-Signature: 7xgjp9uyt7jbhgpamj1aq3szd85a9goa
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754046037-452973
X-HE-Meta: U2FsdGVkX188OUxggD8xh4W+r+qxgu0mO01VMjcAXTlvrJ1/l4H4cKmAASE7MMGuo11mq9M21094L426tlPSGVq/J829gFHZ2DRSizYuXpURY05tZr9i05GLHqWQIvAqzDLbQbR8eFzaTfpwIHKjhb76j9KDwutDW32BbyW5dsUyZNCHlcRrXH0lotMrO4K2tx/IP8pOrevYz2X9kdaBcg7+N54WY6/eKmBJz1AwF8qzHBjW4QRUannnhZXb8lB7iArNDzmH7NYULMU8rJyjSQe2TzKd8BRqhBs2KzkjH2v7rJ2tuutb4OqjwhqZviSpOJvsZpw9rvbTW2ehOjtqhMF2ZtpCMsq2m5wGOXHtXMrqVYl87pxislBO/UOJl1R13NsVBp/YEF6pO+j6NPSVljtTEBs7RJFMnuKBdNQNooOlIDweIqSBrHTNFL9XOaB3qoujLsLPzAWHs3U1pNMYRPsSY1IFUA/9A3YtRmRwNCo/I1BJTe0Q+Pif4/3AZ4J1PR1xML5t2j7NkrwjyiNpM2rBDpsmGi3i9BKpuuzO745PMro1yjkGPiODtnBQS2qzAaZM/3lAG0cfKSke+/gYVzS1r3xbnWVBITTfLSSnC6zi61ChYP1NYlmEvU31A2U5U5+H6wio6/p6d6W43FnkPO1rBP6xXWhX/6oR1vqUbBrd0gniAdO3EFKZiFxoO7Kh7zr7OCG0d6Wl5qjyHBVBkDQVBm+K3m2+kX40jHXqd68rINZ8qgWvk0i+n3ipXWGSf09GYjCTEIettMLJkdQKeyP10OOURxah6HnEs8He0NlbACMNKBQolcDv5s+v3/z9FtSrHbcdG+G3FXXdW+1wXiVIH/aa28ek1nuKc9314tqcNCiXylc4W+yvL1VXuE9PRJscVeYO4sQat3LKJs+2uN/5tfPfZcw8wZzjNdPo/fqY0vn+4BdHjzNhA94zi16fuKZm0zxaql4ye+PAt8e
 6LcMRum6
 BTvVMDu0ygX9W97/7r2CJ9niVkcNVL6VqxHPrZVeKRn8aJvOUG9HoPqVsrXsU3vcgQSJj7tHUpoANcLGVDCgmQPWVGswl7MopghcGb/Woo4x/XeqvLKiRdazVMEPC1cQ8qK5sSqFk8nIhMuHSrbtpMbhOE1sBCCK0hQ1NPjc8mmhKSJ7WP1cbmpML1YK+kQW6Z/ZIS5mdWaLwZpQw91Yoc9NhS8R8MSYrtSJpCeiIVHBr5Z/55B/JZgOqoMGK7SM9Q8CoG04w+TjMGSKMQ+HBYihyJmJybg3q7Fu6mEkIngJqPyYeokzUXxkXEIlAR1CGx4CMbUFYarCJ4KBgQCPlZd4SBCnNgOfhJ9/dWmdOqVJlpXw32oT0UiEtcVNOI3BgeD2atP1rfqpQMrCoANqJS3YkQgLu/lpnDQG68kK9NxtOnBEWmnrjLmW2tvrs30qLUeqh/nCqshvOrjlR1xn3xYwQwIxfZibEi+zuM/Vd76qRxfp4K5IvRlUQFmygeTqkMhUjCjPlW63YD/GD8wa+8bzlHXkxsmLJgOhXos8jLFNFLb5pA2QA1xYOo4TrMMn8nQbjwOPx4vzxvN9AikDLPEsoXIS7+L4YOSV3fNlPtb7PN8OtMEhnmuI9O394HGusKBvdao7kdiVYyHw6R+ktywk+gv4aQcozb645KVjnK4+mxm/FRPUYQbcTSpcFGZ6G4RNEGyOmx1tvQ3duaXy4GmCLmExtbJOwN/nZN9o7K4rQgYeDO/WkS06tIUvJmFkuCP3GY7ZKmrwe2xgPxYSNoDcKKeGMURM7PYLw3T+BI8xRs7EMzDDw6JMQnS3vNZzqGOAOMMMvHfiptp24pm/i2yP5/r0rRGXkGuuA2kErrDVvvRI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 08:19:19AM -0700, Suren Baghdasaryan wrote:
> vma_start_read() can drop and reacquire RCU lock in certain failure
> cases. It's not apparent that the RCU session started by the caller of
> this function might be interrupted when vma_start_read() fails to lock
> the vma. This might become a source of subtle bugs and to prevent that
> we change the locking rules for vma_start_read() to drop RCU read lock
> upon failure. This way it's more obvious that RCU-protected objects are
> unsafe after vma locking fails.
>
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Thanks for iterating on this so quickly - I think this is a good cleanup so
well worth having.

The change LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

I also confirmed this fixes the issue locally and ran mm self-tests so feel
free to also add:

Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
> Changes since v1 [1]:
> - Fixed missing RCU unlock in lock_vma_under_rcu(), per Lorenzo Stoakes
> - Modified comments, per Lorenzo Stoakes
>
> [1] https://lore.kernel.org/all/20250731013405.4066346-2-surenb@google.com/
>
>  mm/mmap_lock.c | 86 +++++++++++++++++++++++++++-----------------------
>  1 file changed, 47 insertions(+), 39 deletions(-)
>
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 10826f347a9f..7ea603f26975 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -136,15 +136,16 @@ void vma_mark_detached(struct vm_area_struct *vma)
>   * Returns the vma on success, NULL on failure to lock and EAGAIN if vma got
>   * detached.
>   *
> - * WARNING! The vma passed to this function cannot be used if the function
> - * fails to lock it because in certain cases RCU lock is dropped and then
> - * reacquired. Once RCU lock is dropped the vma can be concurently freed.
> + * IMPORTANT: RCU lock must be held upon entering the function, but upon error
> + *            IT IS RELEASED. The caller must handle this correctly.
>   */

Actually maybe this is better replacing the original, as it is super clear
and direct.

>  static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
>  						    struct vm_area_struct *vma)
>  {
> +	struct mm_struct *other_mm;
>  	int oldcnt;
>
> +	RCU_LOCKDEP_WARN(!rcu_read_lock_held(), "no rcu lock held");
>  	/*
>  	 * Check before locking. A race might cause false locked result.
>  	 * We can use READ_ONCE() for the mm_lock_seq here, and don't need
> @@ -152,8 +153,10 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
>  	 * we don't rely on for anything - the mm_lock_seq read against which we
>  	 * need ordering is below.
>  	 */
> -	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(mm->mm_lock_seq.sequence))
> -		return NULL;
> +	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(mm->mm_lock_seq.sequence)) {
> +		vma = NULL;
> +		goto err;
> +	}
>
>  	/*
>  	 * If VMA_LOCK_OFFSET is set, __refcount_inc_not_zero_limited_acquire()
> @@ -164,34 +167,14 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
>  	if (unlikely(!__refcount_inc_not_zero_limited_acquire(&vma->vm_refcnt, &oldcnt,
>  							      VMA_REF_LIMIT))) {
>  		/* return EAGAIN if vma got detached from under us */
> -		return oldcnt ? NULL : ERR_PTR(-EAGAIN);
> +		vma = oldcnt ? NULL : ERR_PTR(-EAGAIN);
> +		goto err;
>  	}
>
>  	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
>
> -	/*
> -	 * If vma got attached to another mm from under us, that mm is not
> -	 * stable and can be freed in the narrow window after vma->vm_refcnt
> -	 * is dropped and before rcuwait_wake_up(mm) is called. Grab it before
> -	 * releasing vma->vm_refcnt.
> -	 */
> -	if (unlikely(vma->vm_mm != mm)) {
> -		/* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt */
> -		struct mm_struct *other_mm = vma->vm_mm;
> -
> -		/*
> -		 * __mmdrop() is a heavy operation and we don't need RCU
> -		 * protection here. Release RCU lock during these operations.
> -		 * We reinstate the RCU read lock as the caller expects it to
> -		 * be held when this function returns even on error.
> -		 */
> -		rcu_read_unlock();
> -		mmgrab(other_mm);
> -		vma_refcount_put(vma);
> -		mmdrop(other_mm);
> -		rcu_read_lock();
> -		return NULL;
> -	}
> +	if (unlikely(vma->vm_mm != mm))
> +		goto err_unstable;
>
>  	/*
>  	 * Overflow of vm_lock_seq/mm_lock_seq might produce false locked result.
> @@ -206,10 +189,31 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
>  	 */
>  	if (unlikely(vma->vm_lock_seq == raw_read_seqcount(&mm->mm_lock_seq))) {
>  		vma_refcount_put(vma);
> -		return NULL;
> +		vma = NULL;
> +		goto err;
>  	}
>
>  	return vma;
> +err:
> +	rcu_read_unlock();
> +
> +	return vma;
> +err_unstable:
> +	/*
> +	 * If vma got attached to another mm from under us, that mm is not
> +	 * stable and can be freed in the narrow window after vma->vm_refcnt
> +	 * is dropped and before rcuwait_wake_up(mm) is called. Grab it before
> +	 * releasing vma->vm_refcnt.
> +	 */
> +	other_mm = vma->vm_mm; /* use a copy as vma can be freed after we drop vm_refcnt */
> +
> +	/* __mmdrop() is a heavy operation, do it after dropping RCU lock. */
> +	rcu_read_unlock();
> +	mmgrab(other_mm);
> +	vma_refcount_put(vma);
> +	mmdrop(other_mm);
> +
> +	return NULL;
>  }
>
>  /*
> @@ -223,11 +227,13 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
>  	MA_STATE(mas, &mm->mm_mt, address, address);
>  	struct vm_area_struct *vma;
>
> -	rcu_read_lock();
>  retry:
> +	rcu_read_lock();
>  	vma = mas_walk(&mas);
> -	if (!vma)
> +	if (!vma) {
> +		rcu_read_unlock();

Good :>)

Again, very easy thing to miss.

>  		goto inval;
> +	}
>
>  	vma = vma_start_read(mm, vma);
>  	if (IS_ERR_OR_NULL(vma)) {
> @@ -241,6 +247,9 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
>  		/* Failed to lock the VMA */
>  		goto inval;
>  	}
> +
> +	rcu_read_unlock();
> +
>  	/*
>  	 * At this point, we have a stable reference to a VMA: The VMA is
>  	 * locked and we know it hasn't already been isolated.
> @@ -249,16 +258,14 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
>  	 */
>
>  	/* Check if the vma we locked is the right one. */
> -	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
> -		goto inval_end_read;
> +	if (unlikely(address < vma->vm_start || address >= vma->vm_end)) {
> +		vma_end_read(vma);
> +		goto inval;
> +	}
>
> -	rcu_read_unlock();
>  	return vma;
>
> -inval_end_read:
> -	vma_end_read(vma);
>  inval:
> -	rcu_read_unlock();
>  	count_vm_vma_lock_event(VMA_LOCK_ABORT);
>  	return NULL;
>  }
> @@ -313,6 +320,7 @@ struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
>  		 */
>  		if (PTR_ERR(vma) == -EAGAIN) {
>  			/* reset to search from the last address */
> +			rcu_read_lock();
>  			vma_iter_set(vmi, from_addr);
>  			goto retry;
>  		}
> @@ -342,9 +350,9 @@ struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
>  	return vma;
>
>  fallback_unlock:
> +	rcu_read_unlock();
>  	vma_end_read(vma);
>  fallback:
> -	rcu_read_unlock();
>  	vma = lock_next_vma_under_mmap_lock(mm, vmi, from_addr);
>  	rcu_read_lock();
>  	/* Reinitialize the iterator after re-entering rcu read section */
> --
> 2.50.1.552.g942d659e1b-goog
>

