Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38137CFA775
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 10:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 584A16B0006; Fri, 21 Nov 2025 05:52:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 535316B009F; Fri, 21 Nov 2025 05:52:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D5E06B00A0; Fri, 21 Nov 2025 05:52:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 217146B0006
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 05:52:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD5054EE4F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:52:33 +0000 (UTC)
X-FDA: 84134300586.10.5849FF8
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5859D100002
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:52:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hxR9vtPU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LsBZihy6;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763722350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jhR+fvlulLMMv6tAY+oJhl7qBZ30UKBOmKEnxfJXQXU=;
	b=0XKOW7GGcfs24+I8MShZjznqvIeCFvYnGH39xLub7leKOLh/WaHOgSNjOwfPSp2EnEe3YR
	NlAyc+GY9M0is6rnLRZzC8JUshe5Ccj5fuyuG7ATbmiglMWytGR1OdNnEODPStobvN4vgt
	KfIK8lizha+eB9+3vICYtoGxgydd2+Q=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hxR9vtPU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LsBZihy6;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763722350; a=rsa-sha256;
	cv=pass;
	b=US6rREpOjc63CfZgfvPeP42fAvVoHIVvLBtzrtxLisEpKLwnspnuN/Z42560pESTE7vRZQ
	odd3SBb7ovWWWj7h9OEMkKahdE5GcqmtsVazkucyusiOCZdJOUNnXcFkpgY0afvuQCwA6p
	ztVP4wffAfUYn9UAHnAZU0iHLQIP5PU=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AL1uLDW030160;
	Fri, 21 Nov 2025 10:52:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=jhR+fvlulLMMv6tAY+
	oJhl7qBZ30UKBOmKEnxfJXQXU=; b=hxR9vtPUzeEdBp6FJwW15VIg/CvGxTcOzI
	bEnVR8hOgumvVzNBLFzkpyuRFmnpc87OriGEbL5W5Cuazm/PtsvgDbj7EdF6pLyG
	7QU1oIXH7X783HBO4GHFNcyB8zl7auHoq4j1Z1GZDFEdZ+Rt3RLYfZpIY/1KeBfS
	DMWDxFBPhWv4JuqbjUfDnidlM2K1sCa4jdfWumn7VEx9CJgbQ9SrDrw5ZeS5d1u4
	s3uLHi2UMTvGXHT+7fcvRORpLXCwqS4YoUjzVI6xx/aj8+dy4NlJKN8cZLLBwjs+
	EpsrI4TBbPtxa671oLp/xq2myg3ofJ8kjMMSIe+M9rHFRJoY/N4g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbc2s30-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 10:52:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALAG35T009444;
	Fri, 21 Nov 2025 10:52:24 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010053.outbound.protection.outlook.com [52.101.56.53])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyhh5p1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 10:52:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g2ww+uUfzL4TmMEorRrJV5iX4FNDcHZ1E/qgGb1uPsavevLj5eMmqkPsomf2+b3UCCA3UnSs+yaGOgV889MuhBLDbIy45HW1F7eG9pyJvcuObLowpQ9wjJkhPawQWxwkzxEHf4Fp7kRXZCMQU9Nsn/c3Bo64+z2HXVCyROksbGSfAWv8uyPNxf/nL7ou8zvvKbu662cXmyM8dSApnkPAFA49zKkOlOuIvikeUMEFNVxkh7dLTRWecRVHTKAUHSBsdSKdXdEQI9gHb5cqq2uNAlFRvnaqNgp4gjnCxtcKhzCxMcsbrV8JKS7r2rXV+ZMtNv+mx0aNGkgdiUp92cTTng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jhR+fvlulLMMv6tAY+oJhl7qBZ30UKBOmKEnxfJXQXU=;
 b=iox5NADRjMeef8+Z3wJjNwOm7GSk8g32nQIyIjTGHsTw//WJ/ZroBNSeWP3JEQ5ur/kPqI5gDjUxOeNMfsM9AIYr+E4EjW/Oh1lEQ7q3c2o0NcfJEOe7PDgt2fLPKRQcZgqjbNgmjNJ2frbT8K91Mk12dtKfh8hlSK3sDKTVL4HzUFWQTJLWZQiTWT6X97hsx1wcg8nlsjUMkwT/sf2pboi4VmrtcyrEGGmMTPDcJrac3Uf5p2iBWqySA4jjHo/I8asjucI8DzmwZkbf6cUMbxG4QM8FJM+grj/7fIzQLaMzkoS0nzhD7htfOJrtxAiK7zaYrSh24kRTBkthWuTILQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jhR+fvlulLMMv6tAY+oJhl7qBZ30UKBOmKEnxfJXQXU=;
 b=LsBZihy6Ue0HhwAJOhcrbebmQ1cPNM+z0gEXruRfkX6BLdtqACQF4g7K2QKpzoRPPEtCZqXp6iYH0Pkslt1op1CwRTz+R/E9QBY3gbQRx7W1FKfk5j+2qHLj9mHZ6s4XxPHZxUxSCFOcUzbgESrYr7NYl2D6Kwsa0IYP9IqBljM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB997616.namprd10.prod.outlook.com (2603:10b6:510:37f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.14; Fri, 21 Nov
 2025 10:52:22 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 10:52:22 +0000
Date: Fri, 21 Nov 2025 10:52:18 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
        Vivek Kasireddy <vivek.kasireddy@intel.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH] mm/mremap: allow VMAs with VM_DONTEXPAND|VM_PFNMAP when
 creating new mapping
Message-ID: <29e0db98-4be6-42d6-ac76-7bb599031981@lucifer.local>
References: <976e9916-c949-4fa0-b92e-87f6841b5cbe@lucifer.local>
 <6e415c85-9ccd-4029-91fe-557d3946ef51@kernel.org>
 <4fdd31d7-2814-43ed-9674-d4b15b0ed780@lucifer.local>
 <584eeddb-9a21-4eff-a5c0-446204f9e59d@kernel.org>
 <75dc53b9-bcd3-4271-ba7e-2762bec36e3d@lucifer.local>
 <cad8a1a4-8eb0-4e18-99cf-e19f23cd8a0c@rsg.ci.i.u-tokyo.ac.jp>
 <9bc7573a-ab70-47c9-b6c2-4269479bedc6@lucifer.local>
 <c6dc4179-b2c8-4991-8bbe-662dd32a31f5@rsg.ci.i.u-tokyo.ac.jp>
 <a752bfd5-92ad-4283-959d-37f39bbe722e@lucifer.local>
 <8b750d6a-fcd0-40ac-9ecd-e827bc517aac@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b750d6a-fcd0-40ac-9ecd-e827bc517aac@rsg.ci.i.u-tokyo.ac.jp>
X-ClientProxiedBy: LO6P265CA0030.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB997616:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d3a743f-f924-4b5e-7322-08de28ec0c8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4LkkhCg2dRQP95xSQ3+oYLVt2ZjVf7wQglD9+58sQ1XvGY5AzV75QZRrTq3k?=
 =?us-ascii?Q?El/itM0xpa2vUOppqxOEr7CuIiEKshx49K5itapTDuS3h+UD0VhCxvuvRj5g?=
 =?us-ascii?Q?99Nv0BQyNeN4chE7ozIWrKWzxWpFR+rigNy3PQbdDNmrXaacKy/iSiB6yxfy?=
 =?us-ascii?Q?7LVmknmjORnZcSH9nOS0Abz/Iwtmf27+GZj5B62HPQTtsd7s64qLS6C5ZlQB?=
 =?us-ascii?Q?6nmfj7o+F/yuxiZ661TEtSP7bs29yxOjRz7tQkNkqCeQy230w62YauIVyDoB?=
 =?us-ascii?Q?tJeuiL4LriviaLY80hfBfVeaPAlAS/zBlHk6Nva3AMxrmnES84jjUeuaLiha?=
 =?us-ascii?Q?/MmzrywcBGTYdhKOD4bWnVxAWte/bZzCmLc5+pVBPIo3ANyjkjHnYLAwOHJA?=
 =?us-ascii?Q?gIgEHAcAG/hnFljmU+0hzvMGibwlab2h2SheyUnfUB5Rgb49YeO+QPuZ7Eo8?=
 =?us-ascii?Q?rEwz6h7SBQG/5YtIIIHn5wJ6YjjiGlbqhYQ+e7lca3Pzn/TGAmcyNYDbhOk3?=
 =?us-ascii?Q?xihjsV3ow37sK2HPxUiZNx5C+6/RqgKKFEgJZTUIpJionx10GdSebitL3aDi?=
 =?us-ascii?Q?/5+KXw5dOYLlAIktyrMAkZRQMvla5GHAMu7cPLixrHw96TqQ9jnorp6h7xXD?=
 =?us-ascii?Q?a6TSqkPQSVa46ylLDY8I1lyBAjTvWk/PfXCUP7nWR+6wVIH5FltrS2tGchfC?=
 =?us-ascii?Q?GmLF2IGKJcGQSG9RcsdbasVqe9i0k4V7pQncYlgJaumEWAzlpFu7GgC7Wi9f?=
 =?us-ascii?Q?5gqXjjUkBXgxpiI2/pamx+IDqjELOCNsz9PTcJBOvWbkgssEc5FWe28aQb2z?=
 =?us-ascii?Q?yYvCtzjT1YT3OJBckNMsNE8wxRs3pUjlPL9ef2rsMvLubKp5QDT1uZQIZT0z?=
 =?us-ascii?Q?TeH+D0Xn2WOKtMLsr93bOGarCz0+L/Ryh5iDSO2MCrxlZ9pvx2oGNPQ9GYxq?=
 =?us-ascii?Q?axNJlcluGhs4zmAOoDDY7oFv1rI7TlBG6l4onUP1SqAFTo6jwNxUSrYzOsH4?=
 =?us-ascii?Q?N7AJwQVQNSQ8guRQR0TVeMT/1HXsuSpWCuNsHz6hgUQwfCrf2v52VX266sc8?=
 =?us-ascii?Q?bQDx+qOcnDrKRIGEXe/AOm7V0FeSzWoNgvxBjyBUYsJ1QDI+NBJ60O/6AvDh?=
 =?us-ascii?Q?nlK87XBPFbnJfWm623/1eN5iyU1m+Nk98lZMMeuRAqkJeGxQ2qfQEjcsdhk3?=
 =?us-ascii?Q?x12HuxPMuW2RO+HWNzorvMHMtwx+Ye/mIeAeSkBWhvdIx5MK9yea9aCSorP/?=
 =?us-ascii?Q?wQtpkw4gbS80yfDwJJgXF5YHZnSjIid+IfefGOjYPw8OO+bgWU1D5/jjctUE?=
 =?us-ascii?Q?xPlt27Ic2UBrjUfvJOfBMRjFA65nW/7TTX1/gY7e2JJkQDmSjdnFmTXtfKmq?=
 =?us-ascii?Q?qyCYVAnl63d0tAFpJFClR74uXTlpGa8vxIUCb1LekN9EKPtfpA0wXX/6DdvO?=
 =?us-ascii?Q?FhteNKqRtb575/pTc3VCJwcpVxXAERfE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U9LI/C00WwH/02K5ioFDDrdxarigruejgRiwvMgO4Cd1Sq6F1OhjZrnNvG8w?=
 =?us-ascii?Q?t8CFSt8HJO+Z39JJNO7RnOwAzOo9r63eAM0yvMvoPN2C8kTQJGMvQeAlY5lD?=
 =?us-ascii?Q?foEb7xBKx4G/8zN7C4jFTy2zYfkmCXJDQnB5YD1ZhKJmNOsQcDnIEkRxEHNC?=
 =?us-ascii?Q?YsL7le6cqZqBS53laH6GHtZhJnbqE3sOxHnvGfKVJIclzobsoZaHv5p//OU8?=
 =?us-ascii?Q?4ysG1FrTKfubDNmicIKsCx6MKFpz38pH78t+PMf2wjYhAbXWQyU3eDR3iGYu?=
 =?us-ascii?Q?RsYz0/PcWPt81aexmpUi2MMmrOzd1/hZvuXhUofHpMh6jSJWJi8wXdf9A9WH?=
 =?us-ascii?Q?M0wPSoiwEbGh0u2P3VsOKQAAP8g3BkuwsBK20Yk3gZKqmQhN8l+eExxBvJ2/?=
 =?us-ascii?Q?GI9/eLH+C7RidvthjBVwjb61J207IVvofaQc976owFB9ahfrgOA6Bh5X2O1+?=
 =?us-ascii?Q?rPIrwSynBX8AJpmp9vQuzyh6VW0MvQMBZ3kpJrFe0cR9yU3UFoNY8m5wlPP/?=
 =?us-ascii?Q?3OTIUrnpMQRLQNUNmY05EGfFlCH41Uln6sfNsjMsb9YIdZEJE7FyCTFR9shz?=
 =?us-ascii?Q?IPddXMNKEC3CBr9emNnPujFQHIpEbATAExJIvvkGqqqYDe2F6BCsWNk/LrjJ?=
 =?us-ascii?Q?8+I5WgC3SdPUBaB8G4cGiCXssr0FvGGcGUWvh2ve1JMHuPw/YA0sUM6OJwFP?=
 =?us-ascii?Q?MopSDl7aNu4+ho/ThB0O5iL6UjsLtFAKcLu11Pl5OxHvLFqhlsk0RJtSq2gf?=
 =?us-ascii?Q?5SdMpFjSNWVARpqqfj7014wGMGzjKWJDN2BnkTmzJNQjK7FZZjqU2Ksb2a1Z?=
 =?us-ascii?Q?WS6+BIApKH7jD/X5r7eA3/aizuO7XRXKhtujZzQjM7T0IUWXkfmaG+tGfon7?=
 =?us-ascii?Q?uIh4O2ikcpPQqfTEmnYkTx3bAxOGFBooxw5Xcd7A3dQOzCNXQMe71A5XGkkK?=
 =?us-ascii?Q?bLqX72WQpf/7dmGEb7ScvDoIZ6mumEOvhcoQLtCt+PH2gSpIcVzq+0B8Ee9S?=
 =?us-ascii?Q?X+mohDj+Q8100b1Snp5whUbi+SsN+D/hHYQjlozPyHuzQFSByE+UUXUPX1oR?=
 =?us-ascii?Q?snaWu8RWFC24HPd9m1VI0G01/yJPL6RUm4jRpnnaWfN2XEKApg/trRU3RC/Q?=
 =?us-ascii?Q?somXoB8+TzF3ceKUGl0rwNNuzzKwfHMbB76lXxkWxJqRG2DFA4RRBoeiEqp5?=
 =?us-ascii?Q?xjRi8uA9p09d2OixfIBOWYl+0wYbe3EGc4L3r+4dbrpzMiGaoM3+p99Fmugx?=
 =?us-ascii?Q?VfkheX7y5mgFg/PA86k8ZfvvNk0Z6s5IiTbG84/2vYIa2BKzDjRAns5XnzqB?=
 =?us-ascii?Q?j7M5UFBYoIIOU4+Q9t97ovQI9G2uDLQb3cIZ2iM0XNSs9wesjryT48k3z7Ce?=
 =?us-ascii?Q?UmTR5rhqVBiy2e7XAO0dFMyFTGC/uYo/EbvLonVfj9GLROf5x64zLnfU0E86?=
 =?us-ascii?Q?KajtugpzOTNuSbHiPraVog/KY+Yo0DnVNHqrTu9ZC5oETvHfPtlq4sUOEeC8?=
 =?us-ascii?Q?i6uaCmSk5afUrg9AD886w785U+Yl16ULj4QhCBE7MvGKkmRPsj/gO3u+mfjM?=
 =?us-ascii?Q?pxl/X8lZvpEbMYHpaTo32IO74LUh/VV6ANP+cvNmkgmdeaR4I24yIs0L2rJc?=
 =?us-ascii?Q?Xw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8BQMg79Ef9FmgikCRV+vpG0jgOhI3eNVeJ6VT8JkGJGBIFNjoqSeN+GNzA0HnzW+p6EcJq+SLaUs74fzp5NAAL9FK9CrNl52Guhxmuip8w7qEaNqMzeWH+L3HyWVzKJMpSbQClrhYUgVZZIXxeIVulnUrm7jkrEB7QdwNNKdSODMYGHlB8c6qK8bdooOT4ZJAezyehHds9r4LKVDBVCYov80mK8zYNuT/qPXm9urFHl6NMtNjIpSYyoJ+BZ9sspaZxkBjRs24ht/yWSdB3LkF7gCepmj4mjHy9QJUvhquG0wphXsQpFu/bIpwv7jROFKKXDpnCSHdGY/AT2RacJqQnWbMfgj2ZW1lMFtdbJUY/YjiuNhdCbNqlb0IjPv05NFNJVr/U1l6+6VRGQpaA5vq4yWQ9dYec8yR/7CrnEYZq5cb5mDC9yZ4ZE1WpmHhyp5qZXKlJXJjbBHNA3jI06tlQQsoC9XzThfnQ+o6CdmoyfEkmhfHl5Gs0lyQQBPJNh4INoLSKG65jCKejD84p1uaTGshAhdR1hK4iEIY2WRwm/ILsLMZ5ES1aMC5GtJfcPwUPRL2LgP3mPMLsU8fiTAOzEwfSKL2Oh5dkwb2iRPZys=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d3a743f-f924-4b5e-7322-08de28ec0c8a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 10:52:22.1646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J7OyxqbJkIRTRvkwcKSFpobIsKLvBMZV3Nt5lS1/MyGrTRXPLDgf0sFYyipvCOjX2RvVKvP/fIuGXh3wiwCkiTWHsfckmc1N7Lbp6Gh4WFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB997616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-21_03,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511210083
X-Proofpoint-GUID: OhQUGEtCvBzbaTIUnT6IwLs0KK-8qGvR
X-Authority-Analysis: v=2.4 cv=JZyxbEKV c=1 sm=1 tr=0 ts=69204468 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=lhwZ89YZvP0pskZE0KkA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13642
X-Proofpoint-ORIG-GUID: OhQUGEtCvBzbaTIUnT6IwLs0KK-8qGvR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX4AOLy29zIiOS
 TFGNqXVLH75g0CVDoPS1BiErwS85kau8OJthCVRlqTgKVB4/+d6K2d/zeDrUGZbDn1KFEFxrddF
 tZFj7hhSFL3UQY8rySFUTwDFjwn7r3KQFnKobGmv5L4D9V+G5vgN8X6ZgVqbQpxAvvUalq5yfo0
 4PPTYfx0mWXhkfVY+c4K02nFt9a2EVFL+eMp80FXVJ2EpvHmS9uizTa8m5Kk10sPrF9SvJXZdUr
 7c9OnuQIwg16jLzyGN5qCU8PfI+59YCKnGEd91HfO6ZmcKE5NKKV+3Nh1M19dS22/7n62M8v5Bh
 0hxQaqRQvxGpdJy7gvIHsZwFxfDqNo4WSx7ZpfcMPeHDcUcE+P7E7aI9ypqQeLmE9JuAt/O4Bbc
 14FS3zhQeSmo6P30CjBBfvITg19IDNrf5SL+c/AtpiKxs/grSA8=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5859D100002
X-Stat-Signature: 66feths3s7f3ztowsmu8rw5zfsyo1aos
X-Rspam-User: 
X-HE-Tag: 1763722350-92672
X-HE-Meta: U2FsdGVkX1+ibRTEWYgJyueIC8oK4ukeOFt9iLmCA+bKfcQk/Svk7sz3DiokamWp8uO9Tg2J1juu3yhUHBCE66YFmmLE9vsGaJXL+jFGwq6TkwqTK5w6CftY4sKkPO98rhSQ48vgyHzWlvE1pfIFnXvx1Wc4RWsWJ8QO97LWkn5pwrBKl1T8vVmhBbrv+OJNeZE8lALWOYmp+NNQirUKfeXUCByrEuM+6QgHWQZMXV7YqQ7P6Ek+r6z7a+bqUw2hUNGP5b1fvnwptGZrM8zfZHtlquynNSeR14lPV/OWujGpXCjkOJ9lztJK7ypIEdIW8eSFqTGyNelB20C4+/gBM0VHrjc5aKvMS0x4uAfryLwqyV6j+BOQoAgCeofIupZD7kDBeT9jRmyaHgRa3eblONFWN/8p0fvbVbu0Cqdv430rln1inALmXHrFVqn8mPljzs6UBKD1bM34qlyHaBFdb8diUoKU1jTr6ry5Qk+vMWYLCc018GQW4f8wd+oBnFpkhKLTGDyFWjWxL8qmpxKfiHI7GxUwEwGmD/uaXkuKnbLHwLjnL3tw5dLlBXanZiYsdNalvlWEgLAJWhsA79r5/6AeY6QQrupgjtXhFJ7c5O4ABBdi9o1b8yGNMSPz60h00NY96Up3RaBBWp70qy5YB0A4SeaqcYV/2jTAuG99QGYEuly6P3JMVyGtUYK+bC2EucY3d7AhAQu/GpO74+UI6gZElby6fovCHanunucIHsrm2c5Ffqdd0EYUK5YaWblt1bUIk96tgaO6OHrSLUYJqYyComKVI4DqEeE4ELVHrrv1HLyEbJpa1dTQKyupAorq19KbCqmne67jJ1WNmozmesGUT+lPo7QYkR8t/K8PQM1N6WhRQaBCqpctC3UN9iJZkBqXD6R/t3oesNm43XHX4Ts15UADj5duyAPG/OeRNnFWhfyh0wy45x/fk0arK0wXH9E4/TcuKWG+7gRL+vq
 gOA8ov8Y
 LYtngXoyZLtB2oM+YsKPc+uXOGWWfA2XsmDEsF4tJjG2rRh+nMVJvmHcYtuyG90BKALpdUluSS/3mQP0spop04l71fBR4WPrL8ipSQuPvolNdM8s1RnhXo4b6tpsTjffoT0TaOBkiKF+Yob3bKLvznyrLgWQE2KBLTMMElpbI3jLt2dzPGecVwGvB/bIH+1Gj03utclmVzI9A92s3wBbdD5wRc5QYplq3drTEqPOOH60ZbvPeXoaaN9vf4bWL9iY/v2eErKn/Y0wsp4JK+BJ4pqHSeOnZAZ4Eri0cIaQPRgt7UBguhdM1efjtgteXp5T3ie2MAwcwhKDxgltdMcO8dS6S5Ao+EzQ1F9ARQJUUbXjHNBd2TEudQTgWTa1P+DmosO6Aq0vj2rtXYw66EgHRsSQxCqlRTWn0P0R52kvUmxhLBfPEqY6mVfwnb1W1/Ppam0ctU/PYqsJ4ANk3uTd4Yg9O2lulhd60wThGFN2PZVFwU/ieZQHnfW1uZop2s2rIv0ZQY5/IbYoXVg6ePOWkD2tjlm3wFOQtBO/2uM9ZVApzmzfbW5pL9fmgMKlWBj1coqpJWPmNoewJ0vL3Js03Pt+5VZtaEFZB04vOcHLRAfQ2t3csKKkw4pRcBQA+IyLxSbYCaRWBpqiSiWe1/SZemt6xhSsZ4wbfVRg7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 07:16:39PM +0900, Akihiko Odaki wrote:
> On 2025/11/21 18:10, Lorenzo Stoakes wrote:
> > It doesn't almost do what we want at all. All the drivers known VM_PFNMAP and
> > VM_DONTEXPAND will _not_ be mremap()'d so unless you have a time machine I don't
> > know about we can't in any way take the existence of this callback to be
> > meaningful here :)
>
> Correct me if I'm wrong, but looking at check_prep_vma(), VM_PFNMAP is
> checked only if MREMAP_DONTUNMAP is set or expansion is requested.

Actually it is the case that a straight move is permitted you're right. So
virtual alignment not a concern then.

I should make the logic clearer on this.

Metadata state + any assumption about multiple mappings remains problematic.

>
> So it is already possible to move and shrink VM_PFNMAP, and if you need to
> e.g., assert alignment requirements or synchronize metadata.

Well no re: metadata, because you're _moving_ an existing mapping so the
metadata is still valid.

And generally anything regarding span will still be functional if you map less
of the span (keep in mind you can munmap() parts of a mapping at any time you
like, so this is impliled).

The problem remains with a copy/expansion and having correct page table state.

And again, drivers are all implemented on the assumption that things behave as
they do right now.

Also as I said I"m not interested in us making mremap() _even more of a
complicated mess_ by supporting further weird edge case behaviours.

Most people are not aware of this cloning behaviour so adding in additional very
specific behaviour here is only going to lead to confusion.

>
> That said...
>
> >
> > >
> > > So my idea is simple: change copy_vma_and_data() to copy the page table
> > > without clearing the old page table entries if !old_len && (vma->vm_flags &
> > > VM_PFNMAP).
> >
> > No, absolutely not.
> >
> > I already went over the reasons, but to highlight:
> >
> > - There may be alignment requirements that are no longer fulfilled.

We can drop this, I was mistaken as it turns out we do in fact allow moves in
this case (patch will be incoming to make this clearer in the mremap code :)

> >
> > - There may be metadata associated with the VMA that no longer exists in the
> >    copied VMA.
> >
> > - There may be some requirement that only one mapping exists at a time of the
> >    given range.
>
> Obviously what I suggested goes against "the only one mapping exists at a
> time" so, taking that into account, I agree that it will not work.

Well also the metadata remains a problem. A typical usage is a reference
count...

> >
> > Like I said, I may look into adding some _new_ kernel functionality that gives
> > you what you want. I will cc you and Vivek if/when I put something forward.
>
> Thank you.

No problem :) in the meantime you can explore using the /proc/%pid/... to do
something similar in userspace, I pointed out some ideas in the other thread.

>
> Regards,
> Akihiko Odaki

Cheers, Lorenzo

