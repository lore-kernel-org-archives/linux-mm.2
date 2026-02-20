Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FF0CC56206
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 15:39:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67C646B0005; Fri, 20 Feb 2026 10:39:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 629ED6B0089; Fri, 20 Feb 2026 10:39:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B7216B008A; Fri, 20 Feb 2026 10:39:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 34A4C6B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:39:26 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C76591A0202
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 15:39:25 +0000 (UTC)
X-FDA: 84465244290.11.F5F4500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5BFCD10001C
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 15:39:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N8vtp5XF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NMFIO4QS;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771601962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FdKtA0bG3vQeYu7TFHvCEX+8JuNOgb2SJ0ugnSC09rQ=;
	b=G0j3pUpTFVxC2dsLFX3biyqfHJ5zxccS5xmFfKIOjBrD1XR+MC31vBoZzbwUMSZ99auXGP
	m5gX7TWcEGZbaxPW/qpc1Xkp5QO5d0n7dW2eHK8iody20GWA1Y74KJR1nJnhF+Zp7U4lLa
	86Zw+UapbJljHXrZQMYyZ33TN2TiD0k=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N8vtp5XF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NMFIO4QS;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771601962; a=rsa-sha256;
	cv=pass;
	b=HkIB80u+Q4OcS032oINuz5hr7p14ZouUsaSC7QUeS1b9skQoP0vkOtxzDFU6qpbR1ZlDEm
	1e/SAzOOcNVIH2rzRFV3Os3lfAFLI4GvLHq6e8ld60T374EIimQgDHZtMTfpRRvsNFP0jI
	xAfMmA7tw9qAEmgPAtfe2AF+9WemZ1E=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61KDegbA1575068;
	Fri, 20 Feb 2026 15:39:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=FdKtA0bG3vQeYu7TFH
	vCEX+8JuNOgb2SJ0ugnSC09rQ=; b=N8vtp5XFMY+9k8qN2YApNDQUUwBEMhtu2z
	5tTldsmGNkAdYqzU/DA9Dgxoyv8l6KRCp2j6qopn/Ud9YnV0BWSCVPV0qc0XQrLT
	M7MsX8MXNbnjg8zgCHeW1jSIqvmWvuHLQspsV1F4J42VnuLSli9c9Y23iR94NjCa
	ingR8zKZfJu73uMnqPAh9T4L6ikIcYOFS8gTjSWWPvrsBVUGL/IzDiBqhYl5fugj
	QkMpY8xILEn25T0pAkEy37W4HwxnmdgA5Jwtqgotm4xCVtnQv+5sC+t7fnrztYyN
	k+tVuIn+kq7Z/GxrLSGO7IbtRNFzf+QPtbEJcya3xC6U/HTNflBw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj0rhgfn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Feb 2026 15:39:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61KFQfLM015019;
	Fri, 20 Feb 2026 15:39:12 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011068.outbound.protection.outlook.com [40.107.208.68])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ccb2662yv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Feb 2026 15:39:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CwHPm+uRlGELfptmbsEKryWqq2nP1c8hqZHWrRShF0abU09ckU0C5oME4WT5+FNtjvrT9/xKuc4qpBFlVQIb8dkcBqNZZHNkBjeUCwti5El5zaUy/WPSmlGCth/HiHj3GjrUAX02zBrOfdOYEaFe/SxKq7XV+hhXDtxbL0ff7ovO3GkRMNTmYPR39JxLTNCwkxzjznqLxL0eKh1zJ43fhDNIXYAm523Z+YNbK7axIl/nTVgdD5iZkzs7sfpmsXmeSJXR0S+3c+2D6BgmOTwaJw5Bmpuhpa2++X46k8r8IGg1/FNi7P9+aggOetiCKDEj33oXydpXvvklfqlXFiEF2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FdKtA0bG3vQeYu7TFHvCEX+8JuNOgb2SJ0ugnSC09rQ=;
 b=GwRtf2krpTtN3gOB0y/lfDklxEIV3fxwDvs85ovrhrtAxIqGbdZvOUPZG4I6z2dnlDYOAl5j0IR4NUTxg/dvXVbqUvLpL5n/Ix5dSrnYlLVUklV5MjjYkTAr8jRm0W+c32n3j/Wg4HGsD1Z9P8FbHqNReWTmXuNkVovYzNdylyUMJf6cVn7dwMn8Qtx/IyYhND7j9oWF/9we9ifgQeZ6FSfPANiyxUGPH5RnRUkLFmlPOhYPURVLnCLMaUYYVkmbufamgYnWYaTD8ve1JAef7M552p8PwzHoT8ThE8cr0jyCDcXukax877LJkk0bW3LSt5zxAbMA9oxl6r+8yt0TCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FdKtA0bG3vQeYu7TFHvCEX+8JuNOgb2SJ0ugnSC09rQ=;
 b=NMFIO4QSllCueIH5y3N0WMtAXOEBjGkssZ4vpLqmoqZrBSD0UCcN/nflJgtwFtD63nQO6kDV1pe71u9EPdmqqyzT5Tb746Edq+2cvlUsYq5QbteG94yHgb+ElL72MXbnWNoEIwuy0ZPFDXr9M0vnkgm9qz3kWmALdw1WlXktgsw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA0PR10MB7325.namprd10.prod.outlook.com (2603:10b6:208:407::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.17; Fri, 20 Feb
 2026 15:39:07 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Fri, 20 Feb 2026
 15:39:07 +0000
Date: Fri, 20 Feb 2026 15:38:59 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org,
        David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Ryan Roberts <ryan.roberts@arm.com>,
        Harry Yoo <harry.yoo@oracle.com>, Rik van Riel <riel@surriel.com>,
        Jann Horn <jannh@google.com>, Chris Li <chriscli@google.com>,
        Barry Song <baohua@kernel.org>
Subject: Re: [LSM/MM/BPF TOPIC] The Future of the Anonymous Reverse Mapping
Message-ID: <76b8c24f-22a5-4af4-baea-087e0a2b0e70@lucifer.local>
References: <8aa41d47-ee41-4af1-a334-587a34fe865d@lucifer.local>
 <4qkgoulknoxxkefxyrpnugwmpwbwh324pnnpy6hg2tkdh7lbkc@2i3ep6aoh2g5>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4qkgoulknoxxkefxyrpnugwmpwbwh324pnnpy6hg2tkdh7lbkc@2i3ep6aoh2g5>
X-ClientProxiedBy: AS8PR04CA0135.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA0PR10MB7325:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f93e07a-5fe6-4e0f-1502-08de70962ef9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qKWmeVW6nGFptDc8Ccho2yhwR2iu6flYy/g4SexWEqCmuUPal4WiRtIChTkm?=
 =?us-ascii?Q?ooraei2yZnmBMRkiACtaf9Tfk2zsPThekMsbVnROXREA9aO0hObx1dE4JPNX?=
 =?us-ascii?Q?rM65Gygpi5ZIE5RcMIcjoU2JsLS/GLOfy2PJF77//ONf3+0wj+3rp0NRIbh2?=
 =?us-ascii?Q?PRhy8+aBsu/Ya4q5+tuxAQHyFV2zCGHPVLHSblELUeWX+fmYkU7sS9yeLMpV?=
 =?us-ascii?Q?Q8Vv3CtgV6w6Oh52ebXlfIjsjo4TMJne+rbdAaVPhvcGYkcEqNv+Z8tHba+B?=
 =?us-ascii?Q?tYDQ9nWtSn8JG1SWvqRSGYcMAbaJkm/bsHXWHtkoVJE5bMWDs7Fq83pgILKa?=
 =?us-ascii?Q?PVMeEFxRW4aWLp4srWey4Dsf27ccxZwp3ZjB0NfjXV/gi/vB1k0b/lxyrKSG?=
 =?us-ascii?Q?i/UITwRmvTFkcfHwJYbzSrc5Ov/g9xIYuyw11n9Mr7m3mAiiOjPk4gdr1F1V?=
 =?us-ascii?Q?e3hbRUeqHqo9QJkZRBmnz+9uWv6NX660wEeULldbgsqLY9qNyyZLSQteGKER?=
 =?us-ascii?Q?J9zrRv6FfrHUiebO5cd6oye0TfPS5YBGX6cV3AI4+grNIdKTD2x+YwnGLZ7m?=
 =?us-ascii?Q?ndsmT8eoff2W4ie5HgPUsH2gTHMQzjMseJLsfLQ7W4PAPTmobTzeKohoSk4g?=
 =?us-ascii?Q?kasyxObcuSGcpi8R1mEuURr70xq59+um7U11pEl7S71uZebvQ1xjjNzi8TsD?=
 =?us-ascii?Q?0ULSSuOy71mREiWF7rCi7QLaJAhu8O/RCRV1ZnZs7zaSMyQX1cU2HcOsMEp8?=
 =?us-ascii?Q?AqFrRm49rDiFIQyc6I1O0/ooKQwsmB0z3IK0UHuqDRnP90sfFPsoIn8+x0+s?=
 =?us-ascii?Q?ZjuwxjGnnQdnG6Rw3QM5SJDLW/SHH/bjG7xrdFJOBe8oK4/K26klvRvWHG2m?=
 =?us-ascii?Q?Jv/Tt6tq09W7dWJntL+p0Em+ERquLGRhftrJaYoMelGJneTSZoL7SasUwr9l?=
 =?us-ascii?Q?N/fpp0J4CidcIVkcbkPyfFl8OctqAm3wscl4TvwDsJHoZy4aKeKjLAVwL80B?=
 =?us-ascii?Q?p5f1FJ+nIAndbNNEMjYssISoH2rWnLU+JH55iKWZnpn3VG+E2nEundJytHdl?=
 =?us-ascii?Q?mvYLlFn8pZnIYN1ev2oc2sw5LrLiFiAqjZTmWirUB8o6xtGlTC+NhKwRnlmJ?=
 =?us-ascii?Q?9ML9i2H1YsaUiYv0WBsrvQiQDJ3cTArriuUI3e7w/YP+02utwR27x58EDvTE?=
 =?us-ascii?Q?wP6Lon1MYACWJIHR4aff+WW+Jyx+kdGzyecjGZqVdh19P/axK9plAduoPLKP?=
 =?us-ascii?Q?ket3B7HKO8zF9vWzQ6C3hyK5bornfChHrNmfSzHp8l11BpytZMRIRU5Y/nvu?=
 =?us-ascii?Q?jklJQ4xZ/KufG/8heBergboVsv+6I2oGqUMwKa/Sz8ybGVP77wMAXnvuChu6?=
 =?us-ascii?Q?hemIKEOF887LXsHvXpzR2azC+VZN2Z25k1aCyT/pxC+JqG4fmsXoDngA8kXY?=
 =?us-ascii?Q?c7DqSrSvhngbbdN4lEDK35MEw8jZo/Fd/niDTxUT6h8eXPbQm4yYKmuyy/pn?=
 =?us-ascii?Q?u8glDrHMwYIL5kterFDhaVGZQvAATEkDhKne2HfQGQ3b6tLTpiY6CCt1BCGO?=
 =?us-ascii?Q?V0BMBqzg7dH682YYOcw9Tgs5yf9B0ThwOEgIknWhjWdaTzfmA29dkwgPcyGU?=
 =?us-ascii?Q?NnwWPRTYmMqLL46DHGQVZSI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A+/LzK3xDb6rvqnv37+tZOgQb/uBHKEXwZvYjmZ9xtlKTvDX0ZhH8MDLPVxi?=
 =?us-ascii?Q?MfcPF0BdN1OP2TSkGYWseH8ymXuFnq8XoaYHJ5bG4Z/P8pwe2Fk/ACkJFtrF?=
 =?us-ascii?Q?8Z0rs4g+8SA5ySz/PqALQ+5Sl3aNGObhNneFhSQ5S9YxA8fs288sBnW+DdY+?=
 =?us-ascii?Q?+VOym8VULOkM1WXpZbUbnL/oj2oo1J7Ameinv3KyRIMEwN/YyDTZMVcqQ4E/?=
 =?us-ascii?Q?7k83Wam+ATDrxeDdr+slKqiQJJZmw5KgLqle4uzsitVy9PRHbXKBt6hMun8I?=
 =?us-ascii?Q?2+JmXPWQ+HVz6v32IMUE75qEZiOuaMC2wg4L+mKy3N1EO2vXhz8oYTV9NaEw?=
 =?us-ascii?Q?Gssh47RtRPNGHPiNuhhbv+7zMswKQjkkgem7oPhRMxjKcXsRPQczmAJ28akf?=
 =?us-ascii?Q?LrOevM063qFNrfB+oWlrU7bt0FoySON6JXQXNFZaJUi0LrjZnii4U+YwBBbV?=
 =?us-ascii?Q?frTUSyQcyhBP5PBuSEgjq+H8mHmjDjEg3eTfZvVwVDgr8/tjXDo/1b+wijJ3?=
 =?us-ascii?Q?dm8c33Gdp2CmdLVUKfA18VRu5u+h+FPkQ49+ybcVSmEoLNV9exaxphoF9U5P?=
 =?us-ascii?Q?MqmLmVu5OEMi/3u7X7N11No3gZ5zhzvcbmyeJ09ymJRiboCbJ3ycxVDSdmIW?=
 =?us-ascii?Q?bkLhetYESqy+Kvy/uoU62yg1uF0gExc6lRtycwuWPbreY5mKtcVDM5VftGw8?=
 =?us-ascii?Q?l64BTRoMn7n/a7a2e2JiMcVl298UbN3GigRuAWJ/vjs4Pbk+Ca6Uwny7hYqF?=
 =?us-ascii?Q?/8MVDdihGHUXWkjMkGo4qLKaZtvHN7HABr9yBer0ZyWC1GmdQE6NJUxS+xQC?=
 =?us-ascii?Q?zuZGm2hSIJnRzz5Qjkx3dxeS2Rfzku1Ape2pScIiSrIctJS2Zhph1kuhT+Ku?=
 =?us-ascii?Q?Nn/06bmT3YvOmPUJygjjkN4TjxyOy3wzLIBMXfF5G5DF15xbhaA/oeQr2V/c?=
 =?us-ascii?Q?IHIfp/wMF03aYEx3shi7Ck+u/51maXoN1yBeZE1bT3/DWxskvIrMMqDEgeey?=
 =?us-ascii?Q?p55RbkigLlTHUFPvaKIBth7H1QgRacxLp0HZTmhMZmiijNVmRnAWp/tkY0Cz?=
 =?us-ascii?Q?nkIc500fcCBCd+FHcfAZkwO5CmNUDi83MVD7SHYvkpBLI96NpfoNUIvSTec4?=
 =?us-ascii?Q?vuQ4WzqRUbsoz76F9vGheYHnCrbIVzEB1msu89CHHlOp0BFPSVaEkp4pxCNF?=
 =?us-ascii?Q?RxxJjVGfh1mlhhX6rl0c8yEzHYNLx+CdURj8ZsHdiENWuuH4txV6xBrw3YCV?=
 =?us-ascii?Q?XtzIk88TaGiMFeccXUqa5l09Ovda4jddVQk31ISnoWxByVqRiW3eO5+uqO55?=
 =?us-ascii?Q?JrMGbYEyn0wEdehB64A3vW8wCTbyfpWh060L5fY7MGNkIz4rJPLcmy/6OP9x?=
 =?us-ascii?Q?7sl+EYlUQYEgSQTp8V/MC3nQVyz6VczYwBycq7WIpkpfRd2vVBXIEIByLPA7?=
 =?us-ascii?Q?DcI6yUObkRL+Bt1vZFGoGO0SLOCilSheRo8DWoCohfb1VwkFQbZrL84DMnZY?=
 =?us-ascii?Q?LSpSE1saQu72RWK/CceTQwmuOjTs2ktlc/fg671otmNQGUm6Eu321Sb6fYKU?=
 =?us-ascii?Q?jp+BCnAkbh4jEKxGdt6DVNdj/81wuRwr4v9XcT3zLPHu4JIayiBRh2GZLu0r?=
 =?us-ascii?Q?YG4kK90e6zJp9ARJawTjt1KE4Z4UCbCYGX0aSe+N3sFVnPkw6TO1pNQQVxI8?=
 =?us-ascii?Q?CoZj9xwgXLbd50IUJgCJOzVymwe6a6fie6DdW4sKP2VrHtrxwyQ/7y0vqGdk?=
 =?us-ascii?Q?zt1IKsgBUMZgubVOoImNhGpnmGuu47I=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ssVMaoCc9lvvUEyKhOGUp4X3EEf49NSOOQgm0LR/GqN9MqHZH5nY/O50Sq1LROXVOUBooz9PcUlo+YpEJfL7Hv+amAmwq4XY3TRZAGbUF70qb8mnxZEp+7GSzddc5JTCkNhg/p533Yy2drTHsxr4s2huOOm4BsXLYYmkHD/r5tVZxlFOgjO8ZbiDNst9WypnCruIRKnuP72c2g0p/jPvbIYPB07MusOU81H3niPNdlaV+cvA1yCcoDj7LDsC3QVu0PnQf9lUzKVma2lKoK+7KYYlla7p7ZlZ4fsNYDDYLem5lXYdEU80l23joXK3LnlFHxBScbGT4oiQsKH1c/PX+IQTrQ5KlcXGtHfhOZEpggmEBpP8KrLgFO/JAR/UyDUvkmPIw86RwmAM+85OKcIhdlrC8wsUx+MZLaxIlf5Zs2e9743IVsj72fnxqjjH3rvRshaoFYJ3JfmxfbQ1qCBBi7R3MJnNmZxigJIngs7YhPVylbaZGxIgLDBRzK9hRXrhC42K9njsFZGOdbcW5/IAYF1An3GPJyk79Z4PefnizMQmd1oJbskHGjlx5L4Z037YVJrifn8IaqQxB6DEC1qGahnK/ukMnII8RIrb5WlsGqE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f93e07a-5fe6-4e0f-1502-08de70962ef9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2026 15:39:07.2927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b9SUqOjyLd8R8/7PfTDK6HZYUqi5l0+es7CtEJxi2xiqKARzQ79wMWXw7i2qQ/cC3HK4CxcbkZ6fyPnxYR0QzHCxb1NWvnluJ6ujXUHJu1Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7325
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-20_02,2026-02-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602200136
X-Authority-Analysis: v=2.4 cv=V6RwEOni c=1 sm=1 tr=0 ts=69988021 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=Qyq8VKlXlCJeo7Ntx7wA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: zX8HBcfF70jbpjCcxmRTc9UaeFfvfBne
X-Proofpoint-GUID: zX8HBcfF70jbpjCcxmRTc9UaeFfvfBne
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIwMDEzNiBTYWx0ZWRfX0EgfQoGkw5Oa
 263OBZM/HvIqWYgiO2R0eFo1njlE08qZULNuyUR6U7tEFWSE/gfZZ3h45X0DrJH52EZTznx9mkT
 k72iJH+ptvb0juy8+aiuwu8N1wG0hDraNWkfu5FjN0khYejqAjzLVvndbKtEqlSj7iHHVa9PsKx
 hBBYPNURRrBBWwdAefigoTKMttsr15FwFB2BRcOIMHwCbhvVt5q7weRmHK4LQjwLkQtVuV4uqx8
 P49IWtK98VKgXMZjk4SwNseYDbFrAyDIHlGuZCqcjK9xYAu5zmwJ9pox4t7rlfDyw48HDQNcx8E
 TquepeCCAuVgO9RPHtfx5BqM9wOTwokr2icaIGn+SXGcvYFCOYYxAOTjDtn29B14s74bv6hbF2x
 8O+AbRixnO3utSUbDOiXWJ3GGMdCYRIrntOE5lSZwQMXwkvwPDiU+mkyvEKy8xSv4uTe5tNYmry
 lbWKp+AGw0xXx5spnDA==
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 5BFCD10001C
X-Stat-Signature: qs5pw1ok13t7399q3fc5e4jepy6mnx1e
X-HE-Tag: 1771601962-662474
X-HE-Meta: U2FsdGVkX19kV4/BTdNeGvXqK7hXX1T3B0yTsG4kCdqgwNzqcFnFF6JxJSn0rwl2DAekDvqAkXzxRolAMMuSAlKeyU8pKQTyhiClwdwcZRGjULqMGlrGL4prkrOxg/m3aGU+9AJbdVW/Br8ujH2/k1LQS4KV615y58VRtjQFT51qzTJ4PskQmhsdXSiOib3zC+gAhylhILvn5ktxHsQL7EmPx9H+6LruvQ6VblcmCAxR7nOEaIAlPSE85bx6FW88zJ0SDgJJPWRNExrcidI33cLkZkTTZi1U06xQMqNOELmahvZq8cIxxCRKOyn9DjLq3MqUoTmlVlw/JwwZb2zNj0riN6u63OFY1NBpdk5bQA3zDeLyo7bdDL/vJzA832Tzr8zgT+qCXVq/TeYagWu+z9BacnLQnhSln+5PF0h01LHLWvHQnVzdJzMJSJ0P3Yde2VMptPmUZWD/gNXRy4i00tIGQxJE7PwUoll+n2DLhTgq+ssS9ICHkXlFTiIVgV6CrBAMeAkMSFBH6I8EgoV65VxJ/BRS5Dd2yuIoDFY6+obwwuweERrSeNFhcSOlF31MYE3GpCx5AePclkdE0deoTRu0iTUrXERYp52/1dW4LCG0QH+PSdk4mtjPuQjwNyl5HrovjLSJvOvVF0TaCAU/nvXuDKUKuY6+OZgEpyivkG8wmAAoaxdVJDvrJOxt/wyMxL4yMt0iOCdFnbexaQXqEiEwXcacxWnp0oaCLI4Q8FLmfGqvkCK2AiM7EvJTWHSlN/we57SX2UmpCDFLThZLO6PNHEKrHpVhshIe28VYHS2F/f5oUCYDxpX/yorWyhjPFmJU7spEfbkDlaBR+IPPEZnSRtasm/o2pPEUHLa+HsVrnWZnWq10guIRUOwmr6cp/n39phMV44iTXq1a0AWmJCDEMNYMWgbMawdp2fQTXaS1QNXW+lxra9u513wDk5MMM3UqF3xkH+8TErhLRj7
 v4eOHGPh
 Rgk/AhFoe97v1vOkrnQ5Xj/yte2Unxfzw89sI+/xRLhz91gL4psUElu1RCtccUipS8kTlV4wdiBWENDO6+KBh14Q7De3m9RKU9Gaxdn6jnFb8X2SakmuTLIFehWoII+IFxfejzMzU8u+Zo0E7sfEGpn7c8jJztEzT1MWSqFvPV0xiDxsxFQLqiW8MUc1WI9zz7+ZHw/vxTPaRuH16zFymBaXnY3faybp5OkrlDQOz4cgodOwOgiyH/nzdzOmAwWRNktaBEXE3sGUu4K0pySeGzCwP6IubzdGW3t1iHXe6KqXUcEoBp9iQaygX9mFZcgU09TdVHxb2fTMEZjq01vHR13euCTRu7KkDBEcPmxDvRqAbRvVJld5nc8pMvRETsIuyxwxm5ZAdhlYTk97o+Rw4+/Zqqhq1ZBVzS0Bbo1X+qjShXar6ta40xIuP+4Bo60tATCHxoi2WLZFRvqK2gkllS2aqX+DSHAv3yaPiqH9tPGEQ4Ar+elgCx9vLPVExjK6rtAYym/3Yeq6m9f9/tt2bRo+MSvIdUQoKeru6MLkFm32GfNQzIbTzeDf9nwnnTQioDqOCOtlib7EgpVCwI3Cbs4y8GNBQ+pCXuvNF3XGHqEi8s93hONH1kHKnr4YuezAviON+lF5U9McP3cA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 10:03:29AM -0500, Liam R. Howlett wrote:
> * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [260219 14:28]:
> > Currently we track the reverse mapping between folios and VMAs at a VMA level,
> > utilising a complicated and confusing combination of anon_vma objects and
> > anon_vma_chain's linking them, which must be updated when VMAs are split,
> > merged, remapped or forked.
> >
> > It's further complicated by various optimisations intended to avoid scalability
> > issues in locking and memory allocation.
> >
> > I have done recent work to improve the situation [0] which has also lead to a
> > reported improvement in lock scalability [1], but fundamentally the situation
> > remains the same.
> >
> > The logic is actually, when you think hard enough about it, is a fairly
> > reasonable means of implementing the reverse mapping at a VMA level.
> >
> > It is, however, a very broken abstraction as it stands. In order to work with
> > the logic, you have to essentially keep a broad understanding of the entire
> > implementation in your head at one time - that is, not much is really
> > abstracted.
> >
> > This results in confusion, mistakes, and bit rot. It's also very time-consuming
> > to work with - personally I've gone to the lengths of writing a private set of
> > slides for myself on the topic as a reminder each time I come back to it.
> >
> > There are also issues with lock scalability - the use of interval trees to
> > maintain a connection between an anon_vma and AVCs connected to VMAs requires
> > that a lock must be held across the entire 'CoW hierarchy' of parent and child
> > VMAs whenever performing an rmap walk or performing a merge, split, remap or
> > fork.
> >
> > This is because we tear down all interval tree mappings and reestablish them
> > each time we might see changes in VMA geometry. This is an issue Barry Song
> > identified as problematic in a real world use case [2].
> >
> > So what do we do to improve the situation?
> >
> > Recently I have been working on an experimental new approach to the anonymous
> > reverse mapping, in which we instead track anonymous remaps, and then use the
> > VMA's virtual page offset to locate VMAs from the folio.
> >
> > I have got the implementation working to the point where it tracks the exact
> > same VMAs as the anon_vma implementation, and it seems a lot of it can be done
> > under RCU.
> >
> > It avoids the need to maintain expensive mappings at a VMA level, though it
> > incurs a cost in tracking remaps, and MAP_PRIVATE files are very much a TODO
> > (they maintain a file vma->vm_pgoff, even when CoW'd, so the remap tracking is
> > pretty sub-optimal).
> >
> > I am investigating whether I can change how MAP_PRIVATE file-backed mappings
> > work to avoid this issue, and will be developing tests to see how lock
> > scalability, throughput and memory usage compare to the anon_vma approach under
> > different workloads.
> >
> > This experiment may or may not work out, either way it will be interesting to
> > discuss it.
>
> Discussing alternatives to the anon_vma and anon_vma_chain would be
> interesting.
>
> Just to clarify, this is to look at the complexity of the data
> structures and not the locking, or both?

It's emphatically not about a rework for rework's sake or a de-complexifying of
the algorithms, it's really focused on:

- Memory usage
- Lock scalability
- Performance

And these are the metrics that will determine the way forward.

Talking specifically about my current experiments, I have totally reworked the
entire thing, it's a fundamentally different approach (as briefly described
above), which also completely changes how the locking works.

This maintains a per-mm data structure (which also outlives the mm) called the
cow_context, that tracks anon remaps and the CoW hierarchy
(i.e. parent/child/etc relationship between mm's which have forked).

Since we don't fork that much, RCU makes sense for the connections between
parents/children and means that we can quickly read through the VMA maple trees
for each mm without having to contend any locks.

I currently have the code working (as far as I can tell) with RCU alone, I'm
still testing this but obviously that'd be quite a nice property to maintain and
could lead to quite different characteristics compared to the current
implementation.

But I'm still figuring things out and MAP_PRIVATE file-backed mappings remain a
complete pain (they are effectively 'remapped' from the start).

Whether this approach works or not, it should give some interesting data and
insights that can feed in an alternative approach if necessary.

>
> >
> > By the time LSF/MM comes around I may even have already decided on a different
> > approach but that's what makes things interesting :)
> >
> > [0]:https://lore.kernel.org/all/cover.1767711638.git.lorenzo.stoakes@oracle.com/
> > [1]:https://lore.kernel.org/all/202602061747.855f053f-lkp@intel.com/
> > [2]:https://lore.kernel.org/linux-mm/CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com/
> >
> > Cheers, Lorenzo
>

Cheers, Lorenzo

