Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B473DFA372E
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 11:31:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6242E6B0088; Fri,  2 Jan 2026 06:31:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D1A46B0089; Fri,  2 Jan 2026 06:31:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45E376B008A; Fri,  2 Jan 2026 06:31:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E76D6B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 06:31:37 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6CBDC3692
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 11:31:36 +0000 (UTC)
X-FDA: 84286808592.28.7F843FD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4A6EA40006
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 11:31:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Qg5QgugD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QcTbMCw0;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767353493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b5rkAiJHvF224LeqKpVkTf4Zr3/uZtE3L+IZ69ArbiY=;
	b=0sZmQqSulyLMSWd2WF/KXxdfFNlAupNXfrrOSm822ATQy/NqQaNrpFsdrffDmo3VF8dLSb
	+S1d7PgT6t08bIVdwMDttjSUPXQFHTNuc27rcUZSiPUMXgktoLlyOwSpeWMEjZ+wtWthWO
	iVcjRXd8BWVthuMX3GnNHCh3KzSXKYI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Qg5QgugD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QcTbMCw0;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767353493; a=rsa-sha256;
	cv=pass;
	b=0vOvXFQD/ekwcMn0sEsCE5Dd7SPgJK45Z0BVxCl2OLlpqHLxhcd/Ri7HxuXjQSq66NpaZO
	r+8rxNnFs022fZJCRDLstBW9bbHeYCkQGpMjXv1867sI8L8oOf/nmfu0q/bYCA/ARYfkZY
	9120N4QuMsQ8MnkQ8CUI4ssnGJ/i060=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6026ooYS2501478;
	Fri, 2 Jan 2026 11:31:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=b5rkAiJHvF224LeqKp
	VkTf4Zr3/uZtE3L+IZ69ArbiY=; b=Qg5QgugDu43Ej/29f7JchfgH930gmpQnjd
	T77smKLnsdjE5Vt/6Op2eWMxmk3lHGu+MReqxaAXYYmDoPR3+HZW6XwS54kiJUni
	16+KOrOzR4AeSVYD5k5FqIAIjP9x1FisfkCvJnSQt2NtRHfRIM6w6hGBjGcTuWM6
	I53GpqzlFPT+M5iHobKWFy9lmsEeHxvR+cQVvOiPttHc5RoIB9m8mBgqMgBNnHm1
	CoxCrrdhShrgFg7I5H3+je9zhffFcSGex/2wPn1vtVv0of8Nkbbkhdh1FM7CVPWe
	V8X/wMLPExFKnzlg/ZNNZITeNazdb8Muru6H5fznhDzP17L24pmg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba5va4yrj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 11:31:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6029oXAM022952;
	Fri, 2 Jan 2026 11:31:26 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010006.outbound.protection.outlook.com [40.93.198.6])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5w9t2gb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 11:31:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OmJAU/X6VGJUEqtK+lMMbYiP2y2Ob39p5NQZF6/TYFbpR+iBSmljw7mmVDy+1iq2WLqnxOCmHAWPHaJ53goDrA783zVUXKe5tmoML4kMFxw0cIR7BRlO7yqV5NckzxGW7V2hPlSsHDFwjyou/R5DCrGgHr2/JZCjWq72MPtQmm+VzkPZUzCK3m7xzAgVUkVkevdYVQp5XJFEO5tQaSE4NsB5+BJLEohyKd32LhsPm0D7MkR3AIr93lwQOUyS/AGUQ+X6uN3TUuEVNLAtw8VRr2xix47z2amd1clAHx43h93rXB4K8Wl74xOlFJaAdx2Fjo64v/FVnpjrlaBwMXWUJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b5rkAiJHvF224LeqKpVkTf4Zr3/uZtE3L+IZ69ArbiY=;
 b=OvlV4FdVif8qBZOabpwqurY8bre5hFSDC/FpP64N7Sw2ik0fLbQOQuPfbWkDn26ZC3HTbjiezYyHun6p6dw476/J4WdqANpx1HVplzvqk4B6y+YVrKazQC5ibqYgiXOfn3WyrlvSUzW4+Gj2IGdeWJgBMSCCtBlxcsCZdSuWzlkaEORLkJrUdLwymlH3HG86XowYWKBo2MV84cQ4fLP2b+yqZJ8V1cZhPYKDgWTDdNYD3g1dPJ+1hZr2XQYAZdFmXsPI8WwdVbyr42niJhCev/p6XY2FxhjyxtZgLM9kzNPDhbSEaZp+gsn8ALLSGrvDTtk2vJDB7U5tPWZAXqCEcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b5rkAiJHvF224LeqKpVkTf4Zr3/uZtE3L+IZ69ArbiY=;
 b=QcTbMCw0twLP0pvfggOAnGbKu2GfFsVgqasGFUrb6oNtuV8UGsapvLKtuVq+8d3zRui5TjWs/iKR/KCAtL2w/JF4VUCxzuOE0N7mJMIY7OgWmE58CGWz9FWQueDIioEMXtXW3uJ9tBEr25unasWknqkEOl+ywavGySC79MBW5+A=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB7025.namprd10.prod.outlook.com (2603:10b6:510:283::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Fri, 2 Jan
 2026 11:31:23 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Fri, 2 Jan 2026
 11:31:23 +0000
Date: Fri, 2 Jan 2026 11:31:25 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
        Jeongjun Park <aha310510@gmail.com>, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org, jannh@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@surriel.com,
        syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] WARNING in folio_remove_rmap_ptes
Message-ID: <0bb8539e-4952-49e6-bcfb-262b8fc474bc@lucifer.local>
References: <aVTJt9M-A1BL8w5O@hyeyoo>
 <20260101130906.839504-1-aha310510@gmail.com>
 <aVZ6b2ri1iRpM-7y@hyeyoo>
 <CAO9qdTEzgQQgV8HixsckHhOd5OgRk=_wRRaRbq4d5wJADMrAzg@mail.gmail.com>
 <794095b5-e9ee-4fff-8e3a-1e6b98e670a2@lucifer.local>
 <dd304877-1010-462d-bdf8-9d824250a05c@kernel.org>
 <9306c37f-bc7a-4a7f-931d-452ef6aad358@lucifer.local>
 <aVd-UZQGW4ltH6hY@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVd-UZQGW4ltH6hY@hyeyoo>
X-ClientProxiedBy: LO4P123CA0201.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB7025:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fba2d29-b79c-48ed-ee8d-08de49f27599
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?P9Tmo2oMjkqmEcF1hgALOSDgAU84+FpERVeIRlCVC/P2PRYTXHmXUPeMdj6C?=
 =?us-ascii?Q?YVq+4urdeQr0b+XX/vgliL/7aPcqsu+X4dX0BoXreSpzf78NmxFtcf0v45af?=
 =?us-ascii?Q?2NyKOZ3JuslK/4VRHv+TTj32NAXr1hQurU171OfvOXLigSSBrK8rYVsa1RAf?=
 =?us-ascii?Q?cn5LNgbKx0wBcHRln1EYSocXbS0k3/J0QvDikOZkwwleA7+gn+nyM7VQyPbp?=
 =?us-ascii?Q?XXBW/QhzTN1hvt8oO0+ZsAUQFdYjTZqL0QHUhnl/Icp4c/q6YWKOA7IMXOlg?=
 =?us-ascii?Q?MgyqwXOfVnv+5xHSMD517DIREb2AzYg5NPPqn9ptadnkvhKsDyV0wJZpvsuV?=
 =?us-ascii?Q?2a6DraagaaD4Fs8oNTf8dhfIXfZ3z6ao7bFws5FZiWz3cs6t77dsMGkXvK9Z?=
 =?us-ascii?Q?yocX4gBztFOaSkAnsjys8vTUJGXj0v0QPlqsi2gh7gdziTHdCukpV0VuFwpF?=
 =?us-ascii?Q?HmFJRm06ofsIQJqr1UxuKb7j5VfSTzmv9f/OOx6ugk1hO8x8s56nhU5qTSjx?=
 =?us-ascii?Q?XZLO2A/rvhibEvIHoGD1KmGtW9GFwsvosqfUJWv/24d4ecvhepc88vZ26Not?=
 =?us-ascii?Q?E3v/0+WMVmDie1ZVt+H42quJ6iweOhQNFxkZ1YUNf3INnwqKnisBs0HMwRLM?=
 =?us-ascii?Q?3PZmI8Q4Add7RhoJIYxaCBckQbF465E8kCnwsZBJZOZgxWn6az2HG30ge/PL?=
 =?us-ascii?Q?LO4AtlJx0JikiEoqDEvYUnpUZyRAsIf/LRjLMyEfGgt7dfxow2PVwLizttG4?=
 =?us-ascii?Q?a4Te/G/83jW5dMDP8uNfmozev/tIvNEXNxsB+Y7rESIU3nxi+u4a2VAEj9xA?=
 =?us-ascii?Q?/iTZrOcd5AVKkQ7lSHQkslYiv7gEkjNyaQ5ZH/xSTXuPCdSlPMzMFVpT3SUN?=
 =?us-ascii?Q?+mExm432CaM8Y5c4rEkDBx2mXYGGEwJm6/8PPW7oflO6AACEkW2/fw7aK+yw?=
 =?us-ascii?Q?+jrZiBLFbX7JQnon6qNhwTS02lnldPslGg4NBD5mQyGo11AleXkeCB+3v458?=
 =?us-ascii?Q?gXS8fwwt/lM967Ga0s7aO+DI1gc9MeNVVkbmBVbG+stGiu0v5UbVfSW+rVLA?=
 =?us-ascii?Q?ax3w3//nwdV79Igz0GzFewFdhgwW9kCz4/ipm5Bl5dHo30sGPVubpKpKQok+?=
 =?us-ascii?Q?bNeoyma9uZnOiIcoUpbHEZIc89sdYeu6+Blg+TI76jsmrlc6lO+v4vHPmrDC?=
 =?us-ascii?Q?Bynx9VKS30hlhMvJBXMJZgJK497WAE4qLWdePtEU1rEc1szgQ/6ZXCVS8j2s?=
 =?us-ascii?Q?LfqweQHkVAjBJyx3bg3B7fTlpxlsqfQ+/NdrTmCx5grY/ThR1eF9YlysfHV4?=
 =?us-ascii?Q?qBJDGMbQ+3e9ZtJwZDds6IeyUOq6dXkwl2a/JaZf6miY3tYDp/Y3YTjGMJeh?=
 =?us-ascii?Q?cNcQiBHo2HOQ487eAMiPwll9oJy9nUlOg3Wr4wKPN/Pxe1IuiFxugAIxSrYj?=
 =?us-ascii?Q?ZavZ9Sg0j857+/pNsRR6O1KhcrovvBdf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KIiyv4d4+EE6n8ySRKBoEBEzGV4np+EDOVnVl1LNSKAgFPE2UkErtFSM+yTR?=
 =?us-ascii?Q?Ws1vXRmQf8SvL4Dkl7FVtwFLk1DVx5TRsEqKFNPCWNttsoaPMI96Km2SPxxY?=
 =?us-ascii?Q?m2UbBPbrS5ZMyXFichr0H0VK4DS8MN2xQ7xdZQY4GP2gg3HTFYmLUTkPJJXq?=
 =?us-ascii?Q?4MoAiwJKyk3IIuozYxNYOOgCpMVTa40B63nOu3Ma87dflHGYQgFKmfvmtFCq?=
 =?us-ascii?Q?3U3rGtu9yW88uuzU6xO5jEx4+9ujkOKvppR6r9eepqSzJg8SYk7N08My1Q1J?=
 =?us-ascii?Q?vWxHHrl3DCl1I+osTlkg4P8+jyJjY+7rOSsNl4PddBUC6s29dESwHPJB93/O?=
 =?us-ascii?Q?xcuDHkHfkRvwr5sk1797vqPc9AyAU8z1avz6KhXavT4cD+uly60n5hRFRbPc?=
 =?us-ascii?Q?TYJjIkeKZdUHQYC/U8bbOf9BOGnlyTS9RhhDwMelCK4NgPtulBxVBznkaLCy?=
 =?us-ascii?Q?pfYfY0Hf/nEL4BI3ow2rNAsB8S0sPjK8uEoNSNwLJtPRxYDhfDI74Jn9CjVP?=
 =?us-ascii?Q?cd0nq0jnOBfAIkDUqqLm3f3aT1DOTYFayrpJUY31jmLP0uEf62GD2mjZa1fs?=
 =?us-ascii?Q?vivGO5RptSIvSIdbNRPg48a6TGRP7BwD3PDGRNwRxnyPRrbp3hBX2nOFiIsE?=
 =?us-ascii?Q?yhWjuepVrnifemtn39xXU1o427ffLwyKwzfCyswG2es4PWekgU/5Xo09s67a?=
 =?us-ascii?Q?nNlTp3YX5za9Fo+txeqqEHpZyMacPjlgo/sTdJ4YRJ658tcvBWFTPJOdxKeI?=
 =?us-ascii?Q?FY8AMzHl32ZmQ8TKV7m+dbrM5UaFk8fw3C75qZntb8c5zpBYqiXBMotx9H1v?=
 =?us-ascii?Q?wI3D77uS0ekUq+bfD+UmyynLTOy40KbgcoEG8mjJz0wGyzRc/Bv6x5jxRA5x?=
 =?us-ascii?Q?kYqZnHCNOqn5Yomre+ChrISUgjbgy2AY66gcx8GpYBsMXoB+9KdDjEPMXadW?=
 =?us-ascii?Q?HaPAWITnLwCQVFyr4aDFLCDz/3hUpcnAIsrFSBfysF4DmYx6sIR/LycmFzjF?=
 =?us-ascii?Q?qhCX/leNULsMXyWDdgZCmshuLDgzTsHzkQxrDBwEnZaU9zMJLAz3FEOVuYJM?=
 =?us-ascii?Q?0icwJKCUAsb+OTJSnwTZBzOoZhAgwChlX69eS3D6WA1YU3Y1T0lywT+GAF3r?=
 =?us-ascii?Q?i5i7d0fX72BBVKbXX8lM8APlEoOB8lBc/WHYtdPAFnsRBPrJEmNNDO9ucLhk?=
 =?us-ascii?Q?81/PyfQqNPCNSYY8hx9yP6pfvp/UGRg6QCAI4rdhRmKjIo0MEJlnpN+F9NIq?=
 =?us-ascii?Q?yYfhYmI46sksrqzB++lQz1W54J8yTalmbjUwOru6AyFYR9cuBsZ9p7Ls82SO?=
 =?us-ascii?Q?/adYy3O2Ruo1BejQQOgGP6u2U9rrrNNfoV3Or3kmMiMOjtsKxcMUIkGH92MS?=
 =?us-ascii?Q?3Kpb3MSNqgDSZzagSK+v5nTDAtCiSbEFbtXR27+hBF6ut+mP3S54pGPq2q7C?=
 =?us-ascii?Q?DBtrSEuMwmvaZOp8dTaLOF+M4vLlUq3gZDoO3rWXDP9Rq+nejn/nU9Su4ZYg?=
 =?us-ascii?Q?X9h1qxrAdXBslQiEGEvHAy5liZq6rHssD46sv1fAfyTfn1e/X0Jz4CNzT9Aw?=
 =?us-ascii?Q?BrMfXKMH6dJe8Qi/se/izJC4Miiz8Ge6rUQSf0+8Ut07iztGT//0uBh01zHk?=
 =?us-ascii?Q?hRmhbhu9f4xPWLHCIwj8VtuE1tN6ODNJVwRMRJgON2Qc1UZYjBnhB6CIChN8?=
 =?us-ascii?Q?lE0O5jejTydJOZRp2V7LidvFZughlPPoWNpo337g6vTYc+kymeODJipd/i3M?=
 =?us-ascii?Q?C0dlWlRjAlvuZU0u7aeTQttbSy4IHxk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1bE3GUZgrvE1gJ5JiTVsFWKWLLGUDZYvAOuxk8E+P4HZO2YcPWHu0zZpAsZZfVR73QFlljqsIQ4fAjX6yWltHpq0AN1YG4/FZiNWZRMZ+xS+po6mGKCdAJDFDcsLIc2qQch3xbRBgiJGblI4T4nsRTgI4KQ7PLOqmHS2WGAFppxdzOmrJkUH0KNQKBPC1ZBEkIMEOKKmHQJv7XpfXrC/FpJD1zOgX+0saneoRouHVAtcMN5N/wVvK/l3hnRaEiRNUuMl3vWNXPYUxdeYk0Ph+kxwZvDbSlss7vxj+0kLb0tlowTeYWwAOzHJB5krH2omUW5vZeJNbtS2/Q5M49BxgydtZh2MlcTp75JIcCVlrmE6ASV84+WyZFoVe8KGxjkkZat0cOb8yu4wGc+yTcfoKuoGj95nhm6UwaTKdeyGn2Fge8yT98iVHGkv2KhJPh/Dq8btjLQo1LC1S3LM3AQ/lwCIv4Pc7rH4MTwbYGcGBN/CzT+6H2htBtR2Gqw6O3HjrsQPUBpDx2OCrwkV5cMnNHeSNqbxRCbpNm2f20ptFwH8MmJeffqUuGMxMHyqrdCe5rkbWkOzJrQD4BjaKfOGtmlEPnGYV5/15UKrJczcIDs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fba2d29-b79c-48ed-ee8d-08de49f27599
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2026 11:31:23.9083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6APZoFaUFlyqbCyCysOuyAY+CSjUMl0m27A6iKKlFE52PzIfVH8u1VM8lsRkVgn1Is+pkP5hEWo0mvUMPh7iG/65ThiA9OL7n+0Or/aufcg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7025
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-02_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=972 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601020101
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTAyMDEwMSBTYWx0ZWRfX34l2CWEnsqbu
 i9DVicfAOzqFyE2iyep/dppX00ESRmI2GsKPUzDxcZamVrOOMkFZtFjC6f4f/FySXZMDXiJRrlN
 iaCtMUPwlgA1cJw98YuVXTTmc9YzPhULBLRrxUOZz7V9LY78+unXnRA2GrHqqzahYHpb/Fg5M+M
 oIj1O5nRW7UNQ+vYhiGpjj3dBX8yv4Xg7xp6/MObBbSoeCnVvfDWunSxnYmxeWnJbNQ76lyMMH8
 qZ1GDdBJcnRHlDbME/mKWALji1HuXdItT1IWrbeKt1ZMS8c8aR6Ut4SPbkuCsFwOcnQ39Sg8bHV
 7920t9iKHQwd7aU76ALISvvRIInFgqrxWerCqVNpJKXu9fhZnGKCDUpPKktJLja4CqMMhVTvNnU
 lUBcRqv7OEVniTaDQiZZb5uUJbo3pnt5bKMkgINsPhFYvaSQRrYQskxaiBUZLrBANXaPpH3MUCA
 a/bd60ZuSc9KlzNMZzQ==
X-Authority-Analysis: v=2.4 cv=NMvYOk6g c=1 sm=1 tr=0 ts=6957ac8f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=2C4injTLmrmYa46b_KIA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 8ImI6mowlBT91G9xCZL9PlK9PVSHjRFl
X-Proofpoint-ORIG-GUID: 8ImI6mowlBT91G9xCZL9PlK9PVSHjRFl
X-Stat-Signature: twqfcwus9rex1hsisaymfdmcu7o51ok4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4A6EA40006
X-HE-Tag: 1767353493-566085
X-HE-Meta: U2FsdGVkX1/cWI25Zt7P4NnIemqok/eDhkfZ3XJFCP6z5tY/+aWHc9r07xWWgaVM2dX4a6hmrt5gBHeoIWl10kDE+BXckWN6J7hVJ2eThs8tzvBtjm3W2BUSV95k5kn3KLEw4zAXDidjs6wmNjSfMGBV6om7/HB4UgWgxOMOFithJGZPWQoIzbaQIEqqK7kKIYsDnb4D67xjBLEk8XTAT6Bp3RfNmOmxfb8109nFx5TWAY0hhGSR1GiFD42dDLqKVftTXld4gQXutNrvup+KmZ276p6AndH+AhpoEwvUFgUOzPv8y/9dMQUolMuMjTRtBEysi0WIeJ2tTy9QwSXg7L6ANyPJv/rJlApdio5vvkiH5Mof39S7Og1P1Wb0fwpf53x2tRi0ctdZmyZzn49fparSXQ0RHl7OoTwQq1x7ci6dBXHsL0MDSoAm+RT1xwNDlOoH8Y3pHG6ewz9QRBhTp8fwOqXr6gVRpJNZ9PgQOtwNnFoN81wC6Fp+L/TnSzQ1u1zZAuOQ7Ke1jkdnkXnMkkKLN+iQq7ak7grxQT2vzmvxyYPc/IWIs5e1vdInkjJJVzMhV9GQRwEwhciakn6tneelpaNHCmYWDbTT4w75/mbWk9TGxCfQ4To3vrFW2klqkvjqWzAqYrrK8g6rPOzSwMwEdam1bMhqX2/pr1eNGBG+pnxPszPqWXYMzsIYLhTXyd0H/+3FNgizZXwZt9rrCZ3jFhjfaH4PECyp72hnxyVtjAI+sRxlvOOFfm7w24fLzXIx8KyWatxFPk8X8JMFVP21ACQcEmP7vZmQCj63Hb2cIK2e3P/yvWhWPYbl1UCLPBSrfjEUadaBRCLkZF0PibyVm4RPKTqXgmsQ04h7JdFayYakiCGA2CI2P3ChquAB0CBeYDZcVgvvMptDo8H5zKP2FO/0imKFIjkJeTFLCDXsuzcDlJBTTH2aL78rrDV6weVxk8jzIfHHkgHPV5g
 +AssyAOT
 kdpRqJGN1NcFGdUnJDohpOta7NX5vwDXPNiyHU5b/Bh4GwH88wu6ioDW3uv4c7hAQam48gqqk//ZY3z0gkVV3FpPhblspJKtHE0lXzpz+Ifql9wx2PhskFHLX2Mff99UpJ5/Q2K+HqX6PXnL8kQkBU4CdDMBP73bPEh0n30memmnCX24nD3lTyZRX6yVIB2TKQX6r+ZtsIMMVTAYQGxre9QymcqsNDIMci74iaVjy1CB3iOMQQ2HX1L3Ncn0WUe3+icVmu+zhqioGcTU4yDlhwEogSIL6Hcu5dsS/Ia+oHCVx3RvH5KfYz9ZxXnBZ2BTraxP2Sti/ca5HkSP5UEKyXSCtaOk0rLk97QeA+5Pzhrm3gh6vvNdSfxbf4wZwhz1ESKDmM33tQDa+S8ygDt5kIi/U7GnwcQokU33LewlztGqMzlnAPX75HOrBWHh1ezVQxKdPhBBxu5kP7i+T6ap1zGhOwPIa8Fy6jfqm4grzf6tWEEDmEjY51sAEBfEjJMX8htP4MRRVJt7UHYFRAEwrGBj6biFFDLaEySF+c7j/U4spRlrsYesi7Ww14H/noibMVMJ3Ql0pE2YXK5da5L30Jn9wP2jBKTrlDbOUjm5b94nQRzAc8gfR4fpq6+ZNcWyuOYWFVVPwalWwvvFKeDUX8PHqoEqZxZaZgaezOcXPQqx9Rt54ZVSqCe5LiY8dYyjdvCgzHQwvv0bPZ0mwp3wZ6TuNI+XmjZENrRHKNyGEk/ACXixK1DfrKiotrpVJIW7fkioNbXQfMMG1pyk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks Harry, appreciate the analysis :)

I will take a look through but first I am going through the now reliable repro
(apologies Jeongjing - indeed it can be reliable I did misunderstand you! :)

And once I've figured it out I will come back with an explanation and a fix.

Cheers, Lorenzo

On Fri, Jan 02, 2026 at 05:14:09PM +0900, Harry Yoo wrote:
> On Thu, Jan 01, 2026 at 09:28:46PM +0000, Lorenzo Stoakes wrote:
> > On Thu, Jan 01, 2026 at 06:06:23PM +0100, David Hildenbrand (Red Hat) wrote:
> > > On 1/1/26 17:32, Lorenzo Stoakes wrote:
> > > > On Thu, Jan 01, 2026 at 11:30:52PM +0900, Jeongjun Park wrote:
> > > > >
> > > > > Based on my testing, I found that the WARNING starts from commit
> > > > > d23cb648e365 ("mm/mremap: permit mremap() move of multiple VMAs"),
> > > > > which is right after commit 2cf442d74216 ("mm/mremap: clean up mlock
> > > > > populate behavior") in Lorenzo's mremap-related patch series.
> > > >
> > > > OK let me take a look.
> > >
> > > Trying to make sense of the reproducer and how bpf comes into play ... I
> > > assume BPF is only used to install a uprobe.
> > >
> > > We seem to create a file0 and register a uprobe on it.
> > >
> > > We then mmap() that file with PROT_NONE. We should end up in uprobe_mmap()
> > > and trigger a COW fault -> allocate an anon_vma.
> > >
> > > So likely the bpf magic is only there to allocate an anon_vma for a
> > > PROT_NONE region.
> > >
> > > But it's all a bit confusing ... :)
> > >
> > > --
> > > Cheers
> > >
> > > David
> >
> > OK I had a huge reply going through all of Jeongjun's stuff (thanks for
> > reporting!) but then got stuck into theories and highways and byways... all the
> > while I couldn't repro.
> >
> > Well now I can repro reliably, finally!
> >
>
> Great! still not sure why I can't still repro :P
>
> The most viable theory from me is:
>
> When we call mremap() and move VMA A into new range that fits into
> the gap between two VMAs:
>
> [ prev ][ new range ][ next ]
>
> Let's say prev and next don't have anon_vma, then
> we're supposed to link prev VMA to VMA A's anon_vma.
>
> But looking at vma_merge_new_range():
> > int vma_expand(struct vma_merge_struct *vmg)
> > {
> >         struct vm_area_struct *anon_dup = NULL;
> >         bool remove_next = false;
> >         struct vm_area_struct *target = vmg->target;
> >         struct vm_area_struct *next = vmg->next;
> >         vm_flags_t sticky_flags;
> >
> >         sticky_flags = vmg->vm_flags & VM_STICKY;
> >         sticky_flags |= target->vm_flags & VM_STICKY;
> >
> >         VM_WARN_ON_VMG(!target, vmg);
> >
> >         mmap_assert_write_locked(vmg->mm);
> >
> >         vma_start_write(target);
> >         if (next && (target != next) && (vmg->end == next->vm_end)) {
> >                 int ret;
> >
> >                 sticky_flags |= next->vm_flags & VM_STICKY;
> >                 remove_next = true;
> >                 /* This should already have been checked by this point. */
> >                 VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
> >                 vma_start_write(next);
> >                 /*
> >                  * In this case we don't report OOM, so vmg->give_up_on_mm is
> >                  * safe.
> >                  */
> >                 ret = dup_anon_vma(target, next, &anon_dup);
>
> For 3-way merge, here we're passing target (prev) and next...
>
> >                 if (ret)
> >                         return ret;
> >         }
>
> In dup_anon_vma():
> > /*
> >  * dup_anon_vma() - Helper function to duplicate anon_vma on VMA merge in the
> >  * instance that the destination VMA has no anon_vma but the source does.
> >  *
> >  * @dst: The destination VMA
> >  * @src: The source VMA
> >  * @dup: Pointer to the destination VMA when successful.
> >  *
> >  * Returns: 0 on success.
> >  */
> > static int dup_anon_vma(struct vm_area_struct *dst,
> >                         struct vm_area_struct *src, struct vm_area_struct **dup)
> > {
> >         /*
> >          * There are three cases to consider for correctly propagating
> >          * anon_vma's on merge.
> >          *
> >          * The first is trivial - neither VMA has anon_vma, we need not do
> >          * anything.
> >          *
> >          * The second where both have anon_vma is also a no-op, as they must
> >          * then be the same, so there is simply nothing to copy.
> >          *
> >          * Here we cover the third - if the destination VMA has no anon_vma,
> >          * that is it is unfaulted, we need to ensure that the newly merged
> >          * range is referenced by the anon_vma's of the source.
> >          */
> >         if (src->anon_vma && !dst->anon_vma) {
> >                 int ret;
>
> I think the "src" is supposed to be VMA A that has anon_vma,
> but we passed "next" that is unfaulted, so we don't link "src" vma to
> the anon_vma because both "src" and "dst" don't have anon_vma.
>
> BUT we reuse the anon_vma anyway, and by the time we call
> dontunmap_complete(), the anon_vma gets freed because its
> rbtree is empty (which isn't supposed to be empty because
> we should have linked prev to the anon_vma).
>
> Does this theory make sense, or am I confused again and my brain is
> misfunctioning :)
>
> >
> >                 vma_assert_write_locked(dst);
> >                 dst->anon_vma = src->anon_vma;
> >                 ret = anon_vma_clone(dst, src);
> >                 if (ret)
> >                         return ret;
> >
> >                 *dup = dst;
> >         }
> >
> >         return 0;
> > }
>
> --
> Cheers,
> Harry / Hyeonggon

