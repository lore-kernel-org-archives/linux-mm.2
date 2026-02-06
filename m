Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27DE2EE20B9
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 17:14:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 097746B0092; Fri,  6 Feb 2026 12:14:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06F5B6B0096; Fri,  6 Feb 2026 12:14:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5BFD6B0098; Fri,  6 Feb 2026 12:14:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D5DA06B0092
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:14:42 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 913B11A0285
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:14:42 +0000 (UTC)
X-FDA: 84414681204.27.9BF06CB
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5EDC114000A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:14:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZnGHnWYB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=m21Xp1yx;
	spf=pass (imf23.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770398079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TvgY1j1NADgw00EY8A+lYrNAfmyPcNdFkFhleITcrAY=;
	b=rXIhSIuGdqEU2FLKixx15nurigNI7l5HXdkTbmHf60dlYJu0FYruky2tT6bby30Y+9gKJU
	lvKNahi4QXI0GHskdm0bQV57lPHiwQdM+mEvJx6b28oJLbmdwpD3V4FWhSRh2I5fMMASMm
	7T0kVrqS4KBet/o4xE1gWP6tnQR+GuQ=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZnGHnWYB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=m21Xp1yx;
	spf=pass (imf23.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770398079; a=rsa-sha256;
	cv=pass;
	b=tbaYesg0h3zMdj2aHVksBe29wRcpvDz88ALo7JZjcWb6QSfWbzmIBgFj33OtPvDWWreyPz
	O/RbVYsuoW3RIgO+ogTITJMbzoLTpHk9zq1dJAUkxtoADLL+WNqUhhQQVIa8M+m27BIa1t
	ZARTw7+1VeQa+iu68mxi0QkG6EzaXjE=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 616EvQdH3420288;
	Fri, 6 Feb 2026 17:14:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=TvgY1j1NADgw00EY
	8A+lYrNAfmyPcNdFkFhleITcrAY=; b=ZnGHnWYBnFoWhGl+pBDNm8/XwTgu4eiT
	eIwFrBLdtUphlybH5zQSmxqHsN7oWfEHYQa+j9CWADVWHlzOV7dL/ThBQVag+l7n
	aCH8HZrLpbWOk40rUfKvFPD+S5808vx7aBd7OLI4geX9+3EZFy8d4n+yXsp+n5ke
	ObxDDgMKzanze8pXqtBEITL1Mbu/dwwz8JMT1POiFI5ZExW0+hJW7uyGS/f2/VwK
	jUV1zJGOpgPy9BTiOc+bz/dtrvN7KW0xoIMo7SNCGqUhlukRlbEmOcUBnaG0XD6q
	woe0ERe8D3fxYSLu1RJEeynzoT7zgHShOT/cDiAdDwseWF3CMNNfcg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c4dc3u6na-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 17:14:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 616Gqlua030676;
	Fri, 6 Feb 2026 17:14:28 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010044.outbound.protection.outlook.com [52.101.56.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c186eu1ne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 17:14:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eCnytGqcYPj6LsGi1cfA/bpZRwQJHEAxu/YxapHuNexjHGiuUgyluRhSy8C5CkDF2P3WWTdfVxLpepxJuSzCQOq+cCnSWgq/4jbNtYrlbXjMT3lkm201CIiBUIF4v3uiTurZMSWvAXYbzM/g8PRRpzMdQlJrySI3MlpP8NbX8I3s6MLsLDgPfX58yiD57aRdpDe9H2Tu1Z4Im9rybVGwMGnGajolsHyuxLw5+1GqSvHsvJ2SWr0UEBQ8ASgc2Kuuox5vME7esur6D86s93Yq8/EJRNlKp7bOUQXywX/AKYD222i7ifKLbu4Xm1I+F2ihODPSUdvZgZ8a+0YetdbTmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TvgY1j1NADgw00EY8A+lYrNAfmyPcNdFkFhleITcrAY=;
 b=XTgO4JBj3xf10vWFrhl8+TxKSg0FvRrmR4dWOWGw/BiGaX2ESu3+iYO6Km2Cia7WaFnQudqTAdueiYQRZkpTJPEfqkBcT8joYEC0eWUJguQVf1t2RMxkhVd4qWau52RpFbCQ2Rbth0ir1FUrHxlcfHtoTKWmc1p4/RWkOwdcp9VKQo8hH4h/o9H2pOj/uh5APec/u0DPk7xILuhfFUGwoUpKghwCEC1NQYphW+BkdNxB1WCe/VIlX9BPOhzITd9VO4/e1nSCTBlNU9Pue3kC2451XpFhnZEyjpTTNTwGbizWICkhR9wSWfpgUl7A7j4l8rQ94HwfMxnIUepClzQlUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TvgY1j1NADgw00EY8A+lYrNAfmyPcNdFkFhleITcrAY=;
 b=m21Xp1yxKeLN+0q/+ly62imSkvUqDFxldOg4lRFxPDvLK5pO5rCiOGeBR8lv/+XNzum+CiIxrwB9AHEaq1E12VUwVPuksKDFeuulgyYMDqF594cWx6u1VffH6fbDx2S+WDvA28IgQBwNKQpBHtXrfwShbxQfk9hEDgJpaidVReQ=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA0PR10MB7579.namprd10.prod.outlook.com (2603:10b6:208:493::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.14; Fri, 6 Feb
 2026 17:14:23 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 17:14:23 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>, Alexei Starovoitov <ast@kernel.org>,
        Hao Li <hao.li@linux.dev>, linux-mm@kvack.org
Subject: [PATCH 0/2] mm/slab: fix lockdep warnings with kmalloc_nolock()
Date: Sat,  7 Feb 2026 02:13:46 +0900
Message-ID: <20260206171348.35886-1-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SEWP216CA0121.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b9::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA0PR10MB7579:EE_
X-MS-Office365-Filtering-Correlation-Id: d601ce3a-923e-4b76-5a2d-08de65a32c8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3rAXm4X/4fhEK8fHARqkmng+lvNEf6MTxFE8wr+QYeW/urEDpwX+FS5Z79as?=
 =?us-ascii?Q?wvNy7kUEat7bbu1hTlrjdIDnc2r3rW53WIRVVRRMRuMIaBYm7O64G+TPtzLO?=
 =?us-ascii?Q?0q8WqYsahM7D8fYHgX6oB+UPOpsnNmuUmuf0x5bHIMCdnlZpg8ZLMgh/TbBw?=
 =?us-ascii?Q?t75kCRbr7xQo5bVkEAWLyD/UZjMCuF0QF3dWLY+NbRtv9m5/oBOlJpK+YEu8?=
 =?us-ascii?Q?GzsAd0we4j0s0q72a8SLb0aMPiVaGMclQUuwTL4wMinKE4vSc8VeF+F/zeBT?=
 =?us-ascii?Q?RORWhdH+te19u2XiGsg6KbhhC+XMqYfVZXE9zV3KqODplU74U3mUNSdS1fAB?=
 =?us-ascii?Q?SMUCy97fcpZ/W2qc7KWpz9tpMce1TbDTcDcSClsfugfbgc0uhaxVA+NG/SIW?=
 =?us-ascii?Q?69dSiFEEcPMFgWYpl2zdl0HoQ8VbrJyHHWb+colhhgMTlRs02kuPU+Qi8kcb?=
 =?us-ascii?Q?QLdtLwwzK3faWQPc0QlkbYZFixGDLyDKv+LZvgNvE5zJfZ5I3z2TZhDp0yjA?=
 =?us-ascii?Q?ADOROa6pLtF9TG6A5S/goTlItVVRzwkS8CSnv0dWMJHhOQVyfj3e2yQVbGAB?=
 =?us-ascii?Q?9/RkEXqsEgKkAMcNHGAMNSTLMfyLK6TrkhBGpA5+cYCFGu0KDJ0w4va6LgWe?=
 =?us-ascii?Q?EDegq2/SLEu4z8+bAyKovIGAzqnO++A3/jYI7YtUOHNQn7cMwJmU4cPz6Zk0?=
 =?us-ascii?Q?Bzqg/FWTjq9y1qS8Bjkn4yRrRuoU0l4+troY6ZaJkuyymadCZdi6EVq1VTz3?=
 =?us-ascii?Q?xKppBPCd4ikeumDfxQzbqbsWSdVtYRPdJAH7v2AK/u8pxLUq9bKWcSb7+KZM?=
 =?us-ascii?Q?a/wi25Vhcawv4HOhyNRlkqMYjok2FmtN3tHn47D0ntcIlrDauQuFDzgnyFHP?=
 =?us-ascii?Q?j8g2bvMNic2A+y5oKBEaT85Mpd3DMGr9jwNa6KKK3FHP6nhws3lcM6UyDR7U?=
 =?us-ascii?Q?+FsXkeYnQs2B0MynTiQUbyubR7tUI/ULtLYq/MJb/RkQoLO7Rg61NUZXeOiA?=
 =?us-ascii?Q?P6k+uiXw16S3GP25J013i1mld8qNNgqf6F6/auFJ2bw25y+pbVsQ/a5ODrv1?=
 =?us-ascii?Q?hZJ8uavqrMd9NieCB1poKxpv21nd/dQfsxsnbSnAJVsJm4q2UhKtzcjT0sVE?=
 =?us-ascii?Q?hS12VchholvYcAEMh1zXXWQeK0D+npCAzBbFJPdm5N82OAZ1U1noTtKg3xmU?=
 =?us-ascii?Q?JGX0+PN9IC4rEjKvibmOfIQTYuWVa8Z0X6EsYCAblEmnf1Brv5n0QdS6KPJX?=
 =?us-ascii?Q?Tjlh+6oQzAiBBJwLYYbVrb9d7zio+uLIgJJsthVQE96BrtVXUKJZlvBaoHwS?=
 =?us-ascii?Q?6NCGmEu6L4+0PHXh8VAshRIBT8jOuEAwtZJRIFkaw2mXKRaslIJxv2nOSaPc?=
 =?us-ascii?Q?q3diLfabnln8j6/M7dEQ36bg7X0exZJsmuKxw2TW1lEAZ1Ktg8zIBdM6v2nm?=
 =?us-ascii?Q?/6yD8mJmlXXijTcfa0zC2bDI2DBvJ03RdwT8WT6UqdBAJyiO1CUmyHu3/jdz?=
 =?us-ascii?Q?NwutYZPZfatyhzuvC9YEJoMViqFRhdUvfReBxtWgS5uZRQCPYy8nwbJbY/Ng?=
 =?us-ascii?Q?mMQZbYBOQf7JTNmY69Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cWYnJvk12wjEkUkkrM64/DhSzViaVxSj7Q7sasQqC63vVN9tgx9DXiGN6rxV?=
 =?us-ascii?Q?Em8mzs/Vld7bRxbRXrjuC5m/rNstuGbbdPVjeNU/WP6nGLyfPiMEmkXTueTt?=
 =?us-ascii?Q?1PQVTT2ZlXSgLpMrnLfVz/T4iq8PF7pmA0Kgwb7A5cBUbqkrWYIK6f+hvpmi?=
 =?us-ascii?Q?XvSVcZqBWFlX07fhzDsiwK5ua2WjDrVPRMemgmJoE2er9q4ftFyKPKPwBbyp?=
 =?us-ascii?Q?D3DPcbrAGohPtrDrODHZILUs2cLBVvm5bQtnzIBnhBqBE6gh5/OkRYZfNVb4?=
 =?us-ascii?Q?lU3MEekwKB2GqcCTdpKAsV5zET7Yxos9E3FpzKrMHuG6f8CKh9pouR7bknIK?=
 =?us-ascii?Q?apiYWhx066A+ljcid3dmCZ9GE5EJCARsIfV2gODk8MefcRRGnGr24QAMlCeF?=
 =?us-ascii?Q?bAXynHUM9xchs4xI80EH7ZSeH/MFJdSmLC1Hfy1eIa0y1z7cfrmvJwwZ7wJe?=
 =?us-ascii?Q?6ONoId2l28DkH34JDYNhxv4D+AD3OiRbWPRurLxc2EnCV5b3Td6SAptfvMXv?=
 =?us-ascii?Q?+LQ8QviLTzhn6E5VpZM9IwXLS0OdbPpXUt/vrCRGolbqtGO12/CSh7YcDJB2?=
 =?us-ascii?Q?l2doUugZJSJqJVEIw0Qu0UBfvgUiv45TmX8SgUzCfjDG4gi3Xmvg4+3HuCqE?=
 =?us-ascii?Q?Z2DgDoVYf1KWYR80/lGmY88Fv9ECtiKTVkEOb0irYAk49LDfsvO7gpoL8G5r?=
 =?us-ascii?Q?8RQGDwCHED6sbwC/Xhn4Qp1ogJuKHuPEqiTGTlyHIFc9TN1HL9I00jS0GGjr?=
 =?us-ascii?Q?0fMC2xTPBDfq0kyl316/DLF933qgP9o4nU3V5Zt/Yk8tjEZNdlHvGaIufS4F?=
 =?us-ascii?Q?EkCKznohsOFlSHl7YJOs2y3Ip/Hl8KBJkS7bIDTJ2llMBxMdoWMdJDSePHcW?=
 =?us-ascii?Q?WPtAe8s2zvahwtL/JKU0VRSjGC5Hn7hOLISMGt4hX7KG+BjPWLeyC9gxiAFa?=
 =?us-ascii?Q?WYk00BrkyRF0MMHBTKkNn1+UWm8vKcnHdyTsB026ZJnw/0VGUQb8Um1SshPT?=
 =?us-ascii?Q?+jIGu7kCINAei030+7EzRWiZSQ2V2UYEd92fDOed0spkcdWCJt42YhbdTUit?=
 =?us-ascii?Q?PxFYj1f4umy66G5SN5OBENQ7lMThXhnxsJaj7YQ6vB6gyf16Z8+1us16HqXJ?=
 =?us-ascii?Q?tn6j6DUjosdazjOWwTj2EUmGQXYkOIlcvTX9VLOXGvdoSb0GuXt/G/vdmGRS?=
 =?us-ascii?Q?vWcrE6S8sdarjebCBnSIhqDbwKCKdflGXV439OFLhhyC8bbP3CA0eS6vsoEk?=
 =?us-ascii?Q?G2BZPxz2X4yBeytKfEtdtoMQFOPTi5bWw0oyb3eSyU5sQDi8MlzIKPh9f6Fv?=
 =?us-ascii?Q?G0RfihMar5n3jQtvFUcGf4uvZZDhl7LfZ51fPYEc9BIyvb87XxgWfWjW1yCI?=
 =?us-ascii?Q?b1QiRHe649Tm9hYuaKisiQ3439EcQA4VEJ1FizDl3ZUoqRr5RmPP6ojDiM4z?=
 =?us-ascii?Q?wC4L66u/ltWOuKtQ1RQt5YjHBBQrQhTxDZLKYUFTm2p6j4zMppE2VggMDeMB?=
 =?us-ascii?Q?ls5mvqswgvfEjI6zMk3V/zxAk/RrS5/SI/51NUnQBRVH4ZSyCsCkDBWveNpQ?=
 =?us-ascii?Q?I7YzWyAtGGFzQQgis9pPwFXWg7Vzr6lrUEDabxeOgNGuZv1+KpYubOd35y5P?=
 =?us-ascii?Q?Xvo+A9Al4tRKgsWY/NSM/luNxd2Up6qON5GL7OFScjbRonLN6XQwIsp6TT7c?=
 =?us-ascii?Q?5qIXsOaDxxon/23X2nIlcYbKo5qy5ArzfCsBAx8tljiB09j7eNOCdB6vh/QZ?=
 =?us-ascii?Q?Lj9wqEbbjw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NVje1KXbPmSEo/OWGlxep140De5oSzoEw6gRhFufPPlY9zvKTk7rC9w2oRBFF7mOrkaBCIRLqLmj3pAePN6Xjo7AlinlcEJIOgmwA3LnJuegf1KsLFMOU4uXNlAQVxJzSQV1hW79q5NE+OOmYkWRYZc0LX8VEeNhetZlATUkdXO+hGiSKlPnVjBzGWkAuExn8YG7jcfL4VVR9mPSO1x908lEfID33WljHPnecBB09ElkL9YBQrDgLF/WtrqI0uECYbmVSURpklJl1pEAM3D+RW2pGkiMWF9M8AOUS/R0WvMmg3MuGM9Vp9y8JnSNc7QTozECcP7IS1ic9aU8tPVyXoMYL+IgUlGKlTq++r8U19L1w+ugYL8ub6MDtQCd21irv7fne1COjRutZHL3NR6M34nfXK3SOMwGe+4C/0mv/D04EfL13qPQ/J8HoJ1cuP4RqeHrtV14+9/e4Ejw0eFyESWbZAsGakLoqaVu8NklMuEO3jJWNZCyu0gnnf/cy6o6Ep6kxsvrZOeJX58TgCPn59mt0tZU0S3hnDTtDAtM7GVHG8ftWyeZC3f1VB65BeMTqPTF50mGGK84fptcHpwvPp29L3t9NgwH0wB/uxPaDBw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d601ce3a-923e-4b76-5a2d-08de65a32c8e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 17:14:23.6081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kcRhhKkeoFulZKTumCURJOOSuAkn3QTlgKhiykOTcNME/05q2j7WQa8rewWLBATKD3EkRTsAk5kxdwV1zYrbfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7579
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_05,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=791 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602060126
X-Authority-Analysis: v=2.4 cv=SMtPlevH c=1 sm=1 tr=0 ts=6986217a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=2n7QFGqKkFCyng-BKNUA:9
X-Proofpoint-ORIG-GUID: xARmgT6zUi_nDuWzcLK505RZN8f66aa6
X-Proofpoint-GUID: xARmgT6zUi_nDuWzcLK505RZN8f66aa6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDEyNSBTYWx0ZWRfX3QmY2nvGcoUx
 6YbNeCI73VXsn9HLyMbOMzm9bPA/53tMVOvFrUuMGfTEc8JbOeMkD1J0M+8jlDjVTt26+uKOBbW
 4Jsnum8ERrUvF/sFi6j+b6Yzg7axl6V9VXrWh+1Xlf+8aXCzK7FsGg0ViHm/rzyduvd5TLPsSgH
 yE7SZ9P4ryIIa8OFLjqzAbll1nOKqlFJqnjqh/Tb3WzY7ylSX+vISE2kP34jzeAa1Sjf0eozheO
 Np8sXkze4v1Cl9ZOXU9S9Lxe34q+mr7fbb/QpVogV+lnSAs/u/L8KwURVB0SVEAITZdnifCxdGM
 vgokGKQfuLESqwE8gW1e2yvcXz+01UOO8E+WSygnbSGN93vZlko8xKPffLTF9DMWvxudN4O4iXy
 gGNjM47q9/XknLbXMDL7136k7enEqQcEgC6d5Kj9YvW42Z74geqJrDF2cpZoqdNPVbOInRIm4vN
 u5NG0BlsutL/VE0+wCw==
X-Stat-Signature: bz5198439uw4fjxi9ydngsy9ts3zyrj9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5EDC114000A
X-HE-Tag: 1770398079-846777
X-HE-Meta: U2FsdGVkX1+Jsd4Pp+TDr2ktDKBvmYAhDByAP/Jzq0sCBSBTKQMAIewwWZal2AG3CVBxn65LVjcSmvzpG6//a9vFIEAqLs8eZoADK+8qoxtq0S1oKEAEjuaFhJ5GTcavXz1rvDNbq3lNbtx/ftifTFJQsqKUPK2GESqhGPSgrZertJ0ROVTwmEVWDAIbH4102DEwjmkhC4QhI+y4+2tDO5jvJ9VDRw9h8eOEDpBuHApJ9PBJP+oyhZ/8vAii84KfxBDfBAxtL3NGzqAu5JklY8joxvFw/Lv5+ioYFbRkDTn9MRnz8/a1r0H/oM4cANLRLmqn0H/Zlq6UdwpzueQjW3Z9HXscd5U85lioyAZD5eXRY22oP+jrECD/uhofAeU36hC4iCFAZDAruW31frhWZQHvy2thJmBvs0WL/MYJKhwvEB63RwpqjTv2Z9VtRUs7KL/lHj43NTCEwjQDYPv1aBv42UP23eYOWlQx7dKD1mhVnt1pmEv8UoSwbGSZuC4DvG+7vCTPYuateOP6QTIiovxukqpyqngedDaFyzpQTalZdcNoybtQT7Wee50Z+t8VpwJ4GV5bRQvWvMNzrfCxrXHThHfD2jFHLk848t6JL8GOjrDTM8myQqontchmR5US76muH+JvH5G+E991XlB6iM9Z8uMSCJE4UIt0nTN+RBznqEPlmO7km/g1Antk1aslDfjE0QsOKo070aq/TPcSJH8SsiIozvPBQ+cRISzVz+mehpiX3A/pDk7IP396ErB9Oguvjhv0nLgznHnwraUVh/tucwniF+F35HIDmYGRm6/wb0s1V3+Y4nJ0GySIyzUYZ9mb1CKSe5AQVOrkWkqGNOsyhPdQWJa5kOBcWVOpRvFGX/L4/LkAeGSF3MkYfiPENq5vvcMtA/c4wo0CEPS5ddI+4zMRfSH/LwFQSCyv+TRY7IZQektiNVPwILj/2lhsYcOeOd8GwJ0Wh8wKBB5
 LdOLS4+Y
 UlNdQDrPv3/uUDJlffZAWOdf/wLAlLhqzc4fbgJV0uT1WDVIbDEGSeVk8KDSjprcikd0hpMhYyejj7giuDjqF7UHjK/gRyDe35kCYywn52G7EhZpwS5G3Dk9RnuRRh+XhHFO8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, I've observed a tw lockdep warnings while testing
kmalloc_nolock() in NMI:

  1. Accessing current->mems_allowed_seq seqlock in NMI isn't safe
     and lockdep complains.

  2. w/ CONFIG_SLAB_FREELIST_RANDOM, get_random_u32() acquires
     a local_lock, which isn't safe in NMI and could cause a deadlock.

Let's fix them.

Harry Yoo (2):
  mm/slab: skip get_from_any_partial() if !allow_spin
  mm/slab: use prandom if !allow_spin

 mm/slub.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

-- 
2.43.0


