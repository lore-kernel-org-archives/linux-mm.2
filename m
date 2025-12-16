Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA926D5E128
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 10:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D4A06B0005; Tue, 16 Dec 2025 05:54:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 182D26B0089; Tue, 16 Dec 2025 05:54:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02C7C6B008A; Tue, 16 Dec 2025 05:54:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E1BEC6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 05:54:05 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8606EC05A7
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:54:05 +0000 (UTC)
X-FDA: 84225024450.04.0430083
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 396FFA000E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:54:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=APQz9mZs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uKr8ynbH;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765882442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=weI1zJCX5OEXPmCLgywMXUdE/ktjWTotOcNIyzL9dfc=;
	b=mi1GduKnY9DX05roOADFNlioHF8GDs7thm6gf/yz4FmdPxcTbDTP2028AFaLsbTYXGFbxr
	RNsVbIzBQFPhtu//JpOS/ZLw7Vp0IkiPhT9J7JjsV4/qpTgbKgIuG0aJeMFGCm6pPcNDaH
	zlFU1GlaL4EuAHHtNd1rqyprYZ2OrgY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=APQz9mZs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uKr8ynbH;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765882442; a=rsa-sha256;
	cv=pass;
	b=g0S/dib61ZXZjIYPGaLEUEi15sTR0IdkA95sNcwvTUQTj1293o1rQbXjod/WLYxb9DblZ0
	SfcCRIEF/lguHI9okmbVCPpayCT0YbUifwL4aUUJmnSXrXnA/3ftqHHF2oQwJDSdq5VHAZ
	lRRDabScGga6OCDcxNNHNVZcYbxRZ/Y=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BGArlFH142099;
	Tue, 16 Dec 2025 10:53:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=weI1zJCX5OEXPmCLgy
	wMXUdE/ktjWTotOcNIyzL9dfc=; b=APQz9mZsFyUDBB74uQZS545/XLSPXj40E8
	LZBHE+7M5zCV1jyRVwMDPYZQwZgwajmMp5iFqYmdsyigvqxLrVp9NEeukMD+kqNU
	5KykC5mgARnZsl10bylUGG0ByHyyB/Mbm/BDqMBHfKWrHr4GdHU+Raky8LbttZY2
	BD+gDw8liT7dapBPDjrulnoHhvJzSbqbq/3LFrTQICl0R5PyRbc8f3Wa77BwXvHs
	RVBgRH/DWPaG4l1LG5dNFJv6HLyQa/Y0Ulolv3/Br6TpqeP05CY/1bnfxPSRhTCs
	QFyiYrhv3j6OYi3ooDJsEXEhXdHdm72Zg5G05DPcMsV1IUPqIgIA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xja3qhx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Dec 2025 10:53:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BG8fPKO022460;
	Tue, 16 Dec 2025 10:53:50 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011058.outbound.protection.outlook.com [52.101.62.58])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkk45d4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Dec 2025 10:53:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tr0Wvxbe346aS2pvXvNPjqCUK+bRaLsz30BmXK7A8ITl24icnO6dfXXDAoZVMqI7xaY+I6MlpVzxAgKsfq0bPOGl8R0P86P/iRyrt7Z/PJ00gJjN4H7gQX0S/KLRoMRAfoYZbJVIb80wsFhRn+PJE8Ud2qy+C46EVYxbSEFnOSm+GwfTKnMUjXpTYF5+G615+TfPiOLQ7a7wyut/m6UukuhYcekoGLf6vXWYSMGIrKHbDK4S3jUJ3Eng9TZlX13pr2pRr7XSIVxpstJZzKpKYwUZzfL7J7qSuh/IRO5LTVEuQPEajdDbnh78Zq2WGybTRfWgtijmDORkycSwZDOcFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=weI1zJCX5OEXPmCLgywMXUdE/ktjWTotOcNIyzL9dfc=;
 b=SJ3QVC8VaMjjy5FSloxoPDD+s/t/c95DewQZpFDnnKTG1wc1SFM+sO1oCw88s/s10pqE8Gj+t4JCgthk2xz0aXxTFpn0yH+tOSMLM9oI9H0xoWuYno/QB/jAMVMlpPT1ynmbRuF0GTVCOzIOCl7R4rabwm9RqqiqiYkpuZIoN2RrF4Go890MFFz4diYtNvcbEqN9hp9DD9mCqrNNWp93x9LhVAQ7/7heGG7X4af7dkbUPhOT/3aVF2EeMJ75GIlWe0y5fpU1Oq6FF2Q53fRY4XeuhbzQyhSBzhbOsqStSuHA4aJlgVvDl10XVZUYj6URa+XHkk3mdh/arjFfo1wibg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=weI1zJCX5OEXPmCLgywMXUdE/ktjWTotOcNIyzL9dfc=;
 b=uKr8ynbHD0MLpYTgz4xc81fOjTAERrbfQH9U3wi4PPm1xFhuEi9lhszYO/QLZA26FvfVQuACONDi6oyPWrHQFnNgxdxruYZokkL9WN92WVk310lis+5qo0kR82cb2Cb8XsFVwcv9c2wSDR/En3fa6J1Rt7DHOLz1roujb/VQYxc=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH7PR10MB6250.namprd10.prod.outlook.com (2603:10b6:510:212::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Tue, 16 Dec
 2025 10:53:47 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 10:53:47 +0000
Date: Tue, 16 Dec 2025 10:53:46 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com,
        will@kernel.org, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
        vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
        willy@infradead.org, baohua@kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm: rmap: support batched unmapping for file
 large folios
Message-ID: <b0cde352-0b8e-4330-8c05-fdbc68826e28@lucifer.local>
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <af330c9ea188bd0f28189b1e6e5803f6de9d2abe.1765439381.git.baolin.wang@linux.alibaba.com>
 <70d1dedc-b4fc-4eb6-baf6-9e54b6a62249@lucifer.local>
 <eb871ca2-47c8-4b10-a61d-321716f6c147@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb871ca2-47c8-4b10-a61d-321716f6c147@linux.alibaba.com>
X-ClientProxiedBy: LO4P123CA0005.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH7PR10MB6250:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bf29e77-d307-46cc-128d-08de3c91633f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IHI0mvOt6/SNF9dMTR+/SLCWt7f+hy/4eGdiOEj3AX+bwzjohMcV+ltWUxky?=
 =?us-ascii?Q?EZdVnVhTvLOgTkfECDOWcbpdkmsPa+ufmoVJgqDAKngJ+Y2063UWDEhCCtnX?=
 =?us-ascii?Q?jeb8ulNUCRIK+JnryK6OjWkHPVnHFlPEvCbAyrNjLrjCPL00gjrQYQtNDRpH?=
 =?us-ascii?Q?stVJxdHHlAp2qXJHbfWetqVkqo7QKgauJZuq0wM0LK8eTFtZwqF/KmZ2LI0b?=
 =?us-ascii?Q?lBLa1RAx5ArMARArQ0Couo+Y7OnBfv7Gl16agMJrGaU4fn35i8c7C34m6dvI?=
 =?us-ascii?Q?HIF2d7JwLvoKYBxqoyqClpMdQUW6grPAj+HLqTLuCJIRx2P7neZcIyUlI90f?=
 =?us-ascii?Q?2ixJdz24lxGTdQ/GqDTT6leFX4cmsXAqMf4Xj3mwH9DCYvpZjON05+qUpHde?=
 =?us-ascii?Q?YTAVAxRoabjvTDpOp+rNcPCiimgUz/mPsJLqLGon4i9jslBAAG7dIXOBs5ED?=
 =?us-ascii?Q?8spM6YIF7Z4Hjvla1y/YfhkEPXdeNuOJY7ItEhvXM8eLyXmAOT2xSgfyblWi?=
 =?us-ascii?Q?czmX/PbfuecBwZu4rFcMDrGakXMHMy6kBet91fgJIyetC9SVABZ8K3j098LO?=
 =?us-ascii?Q?GOimTqPgtz2IwATEpAzof/sUgMqCm0CDz/urNl9ZrwE24vvIS4N8cCdEeNr3?=
 =?us-ascii?Q?MFs4xs3FqJ7j2MfbCYXFzEHAXYMecrAKN4ak82WWsqFmcvrJr+sj/u9mlxpu?=
 =?us-ascii?Q?KwtjQOeF/OSN1mYrZLezqWyQQNLzDCnObkAKqmastkqq4NAM4FIpMy94e8be?=
 =?us-ascii?Q?hzHvESRm8x1DVlrVW0WwTRHFITl7Js10OxXmXIW/IuBKtUr+jI/XOmDJqkHK?=
 =?us-ascii?Q?qCIWDUe6oZHZY1qqyJX68azU+cSLoDgBopPj3v0k4nmdywCD5jjjZQ6vmjgp?=
 =?us-ascii?Q?SX4KmzPbJ9K9px1cuRP+gjZ5i2h6F9Rz5PDBS2dG6cZis5H85HUKbtxZsHyY?=
 =?us-ascii?Q?AwxvIFbHufob82l609z/0pV59pfADndh43G1Tja4ew1AcwD5We1R+R6lTNFU?=
 =?us-ascii?Q?e+ubX0iPxOgnKG7oX1Os9wUjqyRAG18Dt7Ln0lswOMoMzoGb6hqiG7CAlCmg?=
 =?us-ascii?Q?txiupyT9oU5uCH7rkmWTxirD48r7vncYUqZMCujAyZH7jrlRQD2SpOF5JdjW?=
 =?us-ascii?Q?UalpJcwo/XWv6kYSH3ILRpu8gww5OAiBxH2LfqyGIzUXbOVIRwvCURfsaw7O?=
 =?us-ascii?Q?VWhlPPuMN+EW5cyF3jU4EX/mYDxP65bSQyfFkztO9UaRgF3zmDTOmxosOHCE?=
 =?us-ascii?Q?KSyg75W/d+2w71mD3Qx6jpYi4fdxrWTOeqm12oiBvupSbwg4NRt+UuJc/JMF?=
 =?us-ascii?Q?KDclgpmK/1b5yW2RiUlpgE474amt58AZoce5e6V3jsk2nAe2ONW6SlB99tKQ?=
 =?us-ascii?Q?4FNTouoanOQbk7lWMhmeOuEUSFsWjQJ+jiA2DEzLP/oKJZ1pDg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2JAgv0lMr9RzCNzQK6XK/6FUALiGFKNwyYXMogNJSREFhHxAvqf0JEP3bsuQ?=
 =?us-ascii?Q?tERuWajyhXA5Hqeg2mmzLckiYwUuWV55kc4yJCnptTn9BA8B2Gml8QJeYByB?=
 =?us-ascii?Q?2rCEBy/XDmPm3nutu1LjHXYbKyQ+4B/YSu+RdPiL7+dHrYEJM7bGs69Siasu?=
 =?us-ascii?Q?QZ5rkFHRTUeRwj2eLQNjiRaG527bRxu1LHc5FQV3Gd52rom4fjcF5Uv/+FG3?=
 =?us-ascii?Q?/KSy6lS9YJqP5VG+fi75AY1u6ejq2/QDKOITZyGqEW/hzgysLz0nIktxtGIG?=
 =?us-ascii?Q?hIb2ylXvyIny4IvfsnJuf9z9z7eJcK99Kk0z0pKb+img2L03lXnpFB9z9Qyl?=
 =?us-ascii?Q?y7e5s/dbNRsnJ9F6/rd1pJir4kerTS0ovuXMhCXegTZ73j1+3XoiVwnSlr/L?=
 =?us-ascii?Q?PDaY0BZmZKvQ3r/sH9c9K+/dmdaFw86wGLU2l1bSIkEsyEty2LpTCpytO4Vc?=
 =?us-ascii?Q?DAHMPe4bCmsJWH/NipRxKk42oH5lbsnM5p0eURDSfEoUCyGJIeLfwVMTcZHp?=
 =?us-ascii?Q?TvDcgvispv70QjhKse5fSOVs/GZbcmAEDrvsYV5PBLSiiQ9V0tFVyyFpBSUg?=
 =?us-ascii?Q?+W6ICjv97lswf8+2WpJY4/DSp+FZ4jqG6iGYMX5D5iuJSVgYDA/QuuaQbukA?=
 =?us-ascii?Q?l4Z3VVzkKW7my/Nk1AEwPJtvqEQgpsZjiaa4ZHp0JbybwL+gPLbOPGWZSfAr?=
 =?us-ascii?Q?0Hi98l9k9823PwrsLV7sKAVSXzPDf9RT89MuUhG5gNPdGutLUpBaMBXyf2BL?=
 =?us-ascii?Q?fCaXVyP+GQrWg3NmJz8HBXduRWakOWrN/4GUMBUCaQmpCXapzo2BY4E/B8Gx?=
 =?us-ascii?Q?0sbXxkjsv7NkjQyYwrXZV5OqR+b1+jq/zLDoCFcZZV3N6RGUFq+DY+SRWawz?=
 =?us-ascii?Q?mKjAZfeduENJIzpdJEEaGeol7jgeRYhIuGM5/wgf6n0aTAW0WTJxQReefeyL?=
 =?us-ascii?Q?V9mY6L/ptXyP/6GIerLD0aam7rLiaiuOeOxZ0aRnrbC2OaojqZ3Z+a0DAN6w?=
 =?us-ascii?Q?mP5jg8RRILg4Gj0oepuLSQ9/kBVc0TgtLNWwuJ/7CMk/IldLcj+MH16p6R2V?=
 =?us-ascii?Q?D0LEWZDqbS+8RCPDn/8tan9UbNuIspE+PEwOtllYAAmp89VGVc4LZo9PuMRR?=
 =?us-ascii?Q?x8t+hAWeG3PglOo8SQ5/cZbtROJDdfb5YkLYT3ZJgu7CB/zC7MyGrDSTobIe?=
 =?us-ascii?Q?nBdhI70CL+01Uact2XE4XgoRIcAB+iqPZuFSTygJitzf8JwOw9R273wmog8i?=
 =?us-ascii?Q?bafdNwYEbXEf7Nv/KzGew7n+7fAOOJC2Qk0nqLnom0Na5cM13D/2w847nEpR?=
 =?us-ascii?Q?eq0U9EVF+l4vwXbKuaIxX8yQ/+GvR/F3PZKHOfF65v4+slYFRwpZMQK7L+ld?=
 =?us-ascii?Q?maVFYFGa6jON9a0eHJaeADstqDOHVXMLp6Y/GO9NMx5q559IRo1nzI3eEg4n?=
 =?us-ascii?Q?ehvlLAhlkAJ6CUv0+Y3LsSu9T9F30EoOFPvqDZjCaM65dISXDtsDaP57xYco?=
 =?us-ascii?Q?edhW43FXJh2YFh961/1uk5uxDewz9smnsfG3Ig5S0YkIToP3j9HlGhm3AwhB?=
 =?us-ascii?Q?/fI8ZeNbbxzvaFOWYJtVkYz3w6PWCwQX9FnameGoKCPWelgkRR/ps/oBfMBe?=
 =?us-ascii?Q?nA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NMd1XXzkX2FQOyEATUaSJdKo4CaHN2lgpqiDRQEi9CepSwkqwL7DyVXCpTBozI3jrmWtmrUQ0y/JDkRiueffWv/zxM9YlihSaORHbIS4K8kIPPNRpZTw+UrqekrYi3AK9vXtrGxAWTRiFVvHrIPUcx43oIdgT87uccpiXYMNT3TyzWNd4XDgkRKGT2uS79Hwg499LAQTBofJ5YsW2Afjs/hRgr9ze15zjbtWpK5Q0RtqtlymUxZWjAf21v8aWBZQJ3AXCLVts6UnC2R6dfLdG10XFFu/z+f4ta+as0jATcGfvnSoTmfPHUaM7gMmsWda4n6H7tuNkmkIESbQAskLtutOl+qT8zUeallr3S+/7EpihKPFM59GvmyDOQZ5PXVhVViVIJKX85EYbzD+Pu3FMbY5t4+o4PfzW//7jJ+DbiFhtkoamOSVTt12XUP2XwjrSd6ILL1FkEMS5uwwBjYz/vCX/jFzJ3+bokw5VNX3ZQ799Mr4uJuTTObwhfOXXm4ZB6XQQ65leQUwcElYnYAmILVDIoVUWSIrnbbHYvDwI35z9RF0PirOZAwIjy2wdg6PzL/Y1MCYH5wc7OLRuHlbt6AUIBOEr26eM0mIgIY+Es8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bf29e77-d307-46cc-128d-08de3c91633f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 10:53:47.0169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dfdgZwKnjowlTatNjpdM0fWjRWOW7g05jsiLdaXvp45ub0zl4wd6vlfFscRwjH28Pp7EIPaaw5zMR276rlyAK0PX7PKP+IX4ShnNU11+23o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6250
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-16_02,2025-12-15_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512160092
X-Authority-Analysis: v=2.4 cv=TbWbdBQh c=1 sm=1 tr=0 ts=69413a3e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=SRrdq9N9AAAA:8 a=XzBnalfdy0WIq3LgxNoA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13654
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE2MDA5MSBTYWx0ZWRfX7by9kFoKHIqt
 p2zbWD2+TmsZ78VV21erq8juFrQVV8I2dTdC20vtPpk8ZUe0U5x39tDluH5mrnexbwSKMjNsepM
 JvsyD6iJvCa5tywi77+pgi3GwjczkNkrH58HxIhXPCMVsLXak3cbqnOtm6oN0+AJzD2aqVXvDs9
 yXDOrKkKT36aXByK4vRbwBFvNElIA5ftfIaYX0YGy0JPDDxtZW95joj9NW5XkngjYEta5O7LUxb
 51qgDc4dGXt5a5sFZosCBpfkCgAdNvolcuTbL3+LdU7Vo0nRNDgRIWGhHVRoJS81XFKfQVXvsIM
 3SkK7wJELhRUmVimn/gfJPbD3kI/mlkvxTW7ow+oj8SQoph0Wi8Ag492SQwoEs04aDh0a8KXRng
 tN36SUb6LXhfbwknte9rilWgnrrwil9gSnKJiNnW0OEYJb0BpCc=
X-Proofpoint-ORIG-GUID: K7tonjE7JMV5EeM3hLZTw3LnTJUIZu47
X-Proofpoint-GUID: K7tonjE7JMV5EeM3hLZTw3LnTJUIZu47
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 396FFA000E
X-Stat-Signature: 98n5uqu4kpx51du3oywmpuigga6ojgig
X-Rspam-User: 
X-HE-Tag: 1765882442-596628
X-HE-Meta: U2FsdGVkX1+V9Cp5u2vGPBpATTLqeuAvIBotR5MwRcy1canbmwygHIWQIM4vdCpBf0TevOxX1dqWOBqRx490DeqGwsmFhvZaUMm+h3+jmjVSGduGPMopwjTD5KIKye44g4823zSLFx2C+LJJipNJ/1UJVlXHHRq445x25JLQSsX+ZZsGtLym/a1GrCHkZLHEXmpmseaU2Y3wk33n83VZ8UVD2DwGwvg8WCzmwM92E35bC+JszQGNRxVD3t7oVoW8hPGPYHfh2OEahTkHcjSeRMm3o7MMFgyhp0ygaF9bV6Iaba3gPbYdY+aV6U+6+mio0+UAshfIzpMUjRHUkY21YuDpNGrcEOsgIkXZizVbKQfn6DNpbDkbIS35azOk6P2+rNsGHvHNkwRLFDyoxd1NNi8c+Rzp/QTCF8bIz/7M/S5eF5vx832fU6jFMzjZRavc799bkLeriPcN67NY5EgaeE7gClHrepnTlTrDa+xh2vYX5LD0IbR+TwIVvXiOqa75AXTL/m6EwHk1HIgZGjSsYTCgS/OsXTNjdnnfnzI2Z0TAGmMxx2pn28Nih1GbLUA/LxSnV//QcuJsvS0SVe2WUNwYp4QG+JwC+Jxn0m6hNCM2TK2nFHuC/q/14YUWH33UZ5Qxb5pYmWbbcNeRPXWzl8vqhyuDdEmsk08ox0qSr49GWyohLCg4UwtZ++DD/7BxmncjuJo67rwQMJXqbcyu6gPh1LbNEULMA1rs+cAckDxMhz5tAgNgDJ4FbKnaj3hO/HCbWRPW4AAbOO7GQANWv1H2wtQp3GQKFEzlL7O2ceplbPRS+bFb+k6N2CnuPO0iIMwy32+5+Q4ZhSNzSrbAMG1eI1t+9kRFVyrz1+qXPEqPvN9rj13WFRcvRQW3Cr0199F6JwH9R0duXIKmY4IobbFhBBK6jZkTiAXsJGz/HNk4r2/DqA+GJOLhjg+1IiF9iF4TL+UCnHGmO8zA/Fh
 vJAxITBj
 Cs4q7dEpaIV5L8LSuSjSkxPnYMY7EZnIfDw4XOp46wohRreekxBTYb/2cDPWkGbOKLbqkscCjcXCXWFNgCKh+fP/V+Kcxlg+njqu7xeuFnED/C0EfKv78NlIcIkuVi9hftTJ1o8fQN5ip0sWcJANs2/7ttllznj0V75G6ye5IqisnmV1Su9oeVKFMu2nfr7SDanmeSexE0mRrBmu/Wnedy+u81KoAm80MITOzQfSVQUGPFYBQBUK/u9rC+SznjTeIRFTZIgWT/Oz8qBNcN8e/Sd9Ph45fQf+dV0N1KqMc2rkYcyvXG0K/ha1jR+uVEFhNlqTHyW/p46u1dygtY0dd+qCYx2P2M2dFThb/g0EOAV+ykn1/MT8WzunRQWh4p+JYLXgGydFnpc+rDGMNxELxi3Y/JVmbilkTe6jQJG131qIF7zlD45DLSKsR6Y/1bC/+n1Blq0FI2fsZD5T5wUJiFZATfnw6DVFBjzFdPpPpohFJ05zJQDBRVj9bqQvvdM0ECmZWSj8rUwbVzUSOT0k5WnMsWY0I9J48EvXzgJxYKx8JD1c1HhRneRA3wATBBs5Tqa22i20KqAgxT7AgMOojMMJqbUCK7FhuleRGv1A9TmjQb8fWf+MZg5v8azG8VoVMi7YatFqZxoNJnAphYc1+l3Lo+IJTLnzZrWgHqla8LF9aUIHIvMP8gdr4TxwyurUJTubB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 01:48:52PM +0800, Baolin Wang wrote:
>
>
> On 2025/12/15 20:38, Lorenzo Stoakes wrote:
> > On Thu, Dec 11, 2025 at 04:16:56PM +0800, Baolin Wang wrote:
> > > Similar to folio_referenced_one(), we can apply batched unmapping for file
> > > large folios to optimize the performance of file folios reclamation.
> > >
> > > Performance testing:
> > > Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
> > > reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
> > > 75% performance improvement on my Arm64 32-core server.
> >
> > Again, you must test on non-arm64 architectures and report the numbers for this
> > also.
>
> Yes, I've tested on the x86 machine, and will add the data in the commit
> message.
>
> > > W/o patch:
> > > real    0m1.018s
> > > user    0m0.000s
> > > sys     0m1.018s
> > >
> > > W/ patch:
> > > real	0m0.249s
> > > user	0m0.000s
> > > sys	0m0.249s
> > >
> > > Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > > ---
> > >   mm/rmap.c | 7 ++++---
> > >   1 file changed, 4 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/mm/rmap.c b/mm/rmap.c
> > > index ec232165c47d..4c9d5777c8da 100644
> > > --- a/mm/rmap.c
> > > +++ b/mm/rmap.c
> > > @@ -1855,9 +1855,10 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
> > >   	end_addr = pmd_addr_end(addr, vma->vm_end);
> > >   	max_nr = (end_addr - addr) >> PAGE_SHIFT;
> > >
> > > -	/* We only support lazyfree batching for now ... */
> > > -	if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
> > > +	/* We only support lazyfree or file folios batching for now ... */
> > > +	if (folio_test_anon(folio) && folio_test_swapbacked(folio))
> >
> > Why is it now ok to support file-backed batched unmapping when it wasn't in
> > Barry's series (see [0])? You don't seem to be justifying this?
>
> Barry's series[0] is merely aimed at optimizing lazyfree anonymous large
> folios and does not continue to optimize anonymous large folios or
> file-backed large folios at that point.
>
> Subsequently, Barry sent out a new patch (see [1]) to optimize anonymous
> large folios. As for file-backed large folios, the batched unmapping support
> is relatively simple, since we only need to clear the PTE entries for
> file-backed large folios.

Yeah, but he sent an entire patch changing a bunch of logic to accommodate this,
you're just changing the conditional and not really justifying it in the commit
message?

It really needs a 'it is safe to allow this for file-backed because blah blah
blah'.

Is this relying on the prior commits you've added? If so you should say so.

If it was as easy as just changing the conditional then it begs the question as
to why Barry didn't do that in the first place :)

>
> > [0]:https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail.com/T/#u
>
> [1] https://lore.kernel.org/all/20250513084620.58231-1-21cnbao@gmail.com/
>
> > >   		return 1;
> > > +
> > >   	if (pte_unused(pte))
> > >   		return 1;
> > >
> > > @@ -2223,7 +2224,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
> > >   			 *
> > >   			 * See Documentation/mm/mmu_notifier.rst
> > >   			 */
> > > -			dec_mm_counter(mm, mm_counter_file(folio));
> > > +			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
> >
> > Was this just a bug before?
>
> Nope. Before this patch, we never supported batched unmapping for
> file-backed large folios, so the 'nr_pages' was always 1. After this patch,
> we should use the number of pages in this file-backed large folio.

Right ok :)

Cheers, Lorenzo

