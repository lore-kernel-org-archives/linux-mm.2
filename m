Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 719E1EDEBE7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 01:31:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7BE76B0096; Tue,  3 Mar 2026 20:31:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5A2F6B0098; Tue,  3 Mar 2026 20:31:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C14CB6B009E; Tue,  3 Mar 2026 20:31:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AE0CA6B0096
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:31:24 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 721171B7B77
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:31:24 +0000 (UTC)
X-FDA: 84506652888.30.422BAE6
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id EBD57140019
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:31:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IS5lyUBp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gJcstTNb;
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772587881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p1pfgV1drFZ5J1vieB4uSVPLuWjx9UoNU8kMUtv5iFA=;
	b=EUbLshSuBFeIJjyL3Fgp+Y2VWQeu2M1N3MHnjkOegGtMPvZlItOFiE4gfufZ6AQuLbzUv0
	cqfHEhaqwVYfyBR5kEzR6a69RPo6eaJJ5DDOyGaqyNmJhm+TBmDyTwt7iJVhzXRuu5oeGO
	BBQZBJB9gmWNAcUJpNDq+DKOMJ9Zthw=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IS5lyUBp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gJcstTNb;
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772587881; a=rsa-sha256;
	cv=pass;
	b=fep6EKtX/iIP46ZCVgLzTVvvpT2tVeuKsY01pe0BlEGtKVeeiiCShKKsG6BaQiX4AwDqPt
	yhvPXSqAOeTD0qbPo3m+S/Ob9V48KJD21hVPCze6pQdmwwAcpwP2pUJXY6yDqQ5KR375KJ
	H+3B9rlsMDKbGDy3jg8qTQue/9xHGZc=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6241CDCK610470;
	Wed, 4 Mar 2026 01:31:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=p1pfgV1drFZ5J1vieB
	4uSVPLuWjx9UoNU8kMUtv5iFA=; b=IS5lyUBpGnoj0glDmLzA4T7XAuxmnVuJR7
	o4uo3pmTvGLY6m2Kzyim3h0ke6Ifcw86zEijJlITraMl0SDIJxhC5Y0jdaIbCZsE
	qYYqP6Lnx1O46tw/I6MI/PD/Lk1hb3Eu0JBXP3Kd8f78pKWtHVAypR3aHWwZOHRa
	/DTJFKCz50cgXAAFdepvo7A6RZnT7Ke05464tFIpw71gPSZHhHMEiKzKxvc3Pj3R
	o/iDQvMZsQwqcW0ueADKIRvfcVjB8zheRmHwcE18hoNFUS8nw2gBjXxYXBDhUQlT
	rHcbss7OYtyVuY8IoUkoJB1rM53DB9evH4ZxkmJI/sVEoPWsD0TQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cpahhg0va-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 01:31:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 623NdZSH023114;
	Wed, 4 Mar 2026 01:31:09 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012041.outbound.protection.outlook.com [40.107.209.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptfd84c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 01:31:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MYzn1SpQpZcd954L0GCtvycmGeYFG/EMYyiS0VsB0LsWiBHoIO7TaF0AyvrixE/pR6BN+MmIjakc5S3tVGdkGo/8b7z42MpbgTU5TsRFnnsJht/dkNNfYlUHnkv9cQDNRmTJRe44axoXXnjdGpeER0Y2PtMSZpHS/uwrWZkvMDDKmsfOjruDtDaElBEkmv1COjDVpXOQubeNuw97lB+DyleN0Hk8QYBwBfi9+yQ3Gr8sELTjicDJ/p/veAADgIHVmfpYQaKs6Sgf9K2N1R3NFVEZGAX3QDa0cFjcjhMqybkQA/4PYDyKVKRyYz04mswOjik1NyPtbVC7KZJJWS4dfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p1pfgV1drFZ5J1vieB4uSVPLuWjx9UoNU8kMUtv5iFA=;
 b=mrU1Wt63DyfbsHDh8q16jQlgCDm93ClE5/cOasToINI6aN0dmpRl38CcFrQZJJtnSmMaJXWpxFn9UGZVFpUHJB59DuFux7avAsN1Zltm8nZycLghEOaEvdifrHsN69fH+CddXbjejzblnruzvRFd5G80FbFDFg02e8GYM74BacL6Lcpy40toWy5a8IPb/2EUOs37Zt4+ePhbnrDxeSpyTpU5QZc9aRCW+9v9+wDx+wmUKONb9649BNY7V/DavmJkR0aFR7hfzoNeDdo0eXKb4DjtjWNAmswmywUP2lA4e3H9URG6qjLllGyHcAaQkcLQVc7XiBmjnUL0VB2XO1oJrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p1pfgV1drFZ5J1vieB4uSVPLuWjx9UoNU8kMUtv5iFA=;
 b=gJcstTNbeKvveo7Nw+cA+ZAIWs/C6Cjb4bDPLUvq/GrZK+LAbRIC8kDlrSnHOjAkgUvD/CfsW/dxJOX+n/BDj+REVixXiuwKZApvSaiI+rteoJX2g9MwY5+EWIK4sdZIxMtGzbFeDsOrTGIjDhvW/ogQLoDEVX39+4LN6EDIBXY=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ2PR10MB6989.namprd10.prod.outlook.com (2603:10b6:a03:4cf::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Wed, 4 Mar
 2026 01:31:05 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9678.016; Wed, 4 Mar 2026
 01:31:05 +0000
Date: Wed, 4 Mar 2026 10:30:55 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Qing Wang <wangqing7171@gmail.com>,
        syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org, chao@kernel.org,
        jaegeuk@kernel.org, jannh@google.com, linkinjeon@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, pfalcato@suse.de, sj1557.seo@samsung.com,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz,
        Hao Li <hao.li@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
Message-ID: <aaeLT8mnMMj_kPJc@hyeyoo>
References: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
 <20260302034102.3145719-1-wangqing7171@gmail.com>
 <20df8dd1-a32c-489d-8345-085d424a2f12@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20df8dd1-a32c-489d-8345-085d424a2f12@kernel.org>
X-ClientProxiedBy: SL2P216CA0224.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:18::12) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ2PR10MB6989:EE_
X-MS-Office365-Filtering-Correlation-Id: 31a646dc-a7e2-470e-8774-08de798db406
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	FC/DzIcEISn/3fp68f9o6BlK+K2ha8Teuybdjh7ENMUs3HbAtMW6TwxqXlEHSCR0cHrOh/AaMRBTHPVgzbx5Zk32GdA32M0YdBfR3c74YpMKLJlLFTBEMSHXOSOYN0WxFe+11VGClAnMfOmlf9zzIVH8KLPK3pyvJ/Gl5QiyZU4CfbvC/4bXF0IeZT1dS03EhbCnQcPL+xOyUYqfnpyw8PGkMj54GOX8nFbhIT2VGXrwWlRtPpTxS7CdguIxexPEIGM3hRt8U4FmzBiRfo6s+p8T5XHkjzp7MhVpoc6wODZw3aZuaCm1mgsJMytPYcecvpVqx91YNAGiVyp7FL5ciHw75RMcZBq4Jm75FXiBxGA7/ZjEGLZeCgG5SY3jJQUF9QxoHzhoEqfBHSKctluvm3TdDKh9PIuC7m10EEGYaje6qUq9gpDzCTmbbMBPSFBRkDVMMftzSFmEZInazfzU5ytS0y/x/78LO6yxUKOL0JAMu8RUq+NEWA0IjnAm0H89ThEclJoUArpiRUUK0j0KASXhiE8trcRDk13Uth9KJP+mRueqEXA8Z4B1MjZNyYmUEJWYA15pcUugki1m5vu8RlML749hye7Aa5ojIM8RVhUZqgk6MOhtZalO7U4nCQpmucDr+1tdCvtgfPsl+aQsdsEJclbv8t9gU39kJzgisuu0Tn/2JpfZmclZjZdT2oT48J06pdipzsm/Q/4n4uvwn5Kiyshv+rzHvD7ggROMVW8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2LEH143N2qcyZbRPO8cl+3HhXfztwPR8jbxvExfW5GlXKf1/FCLLGK32837i?=
 =?us-ascii?Q?CDnv1xJp1FDlIXJUbTsH0XL2i85jKIGch89+MQjSOSAkCdU40J3l+LEEIdu0?=
 =?us-ascii?Q?/YWnnu2e9GPD3uDMj6jxWg7A9c5f77iNgbVG72bABh7TnPKJlO+SHuysslpk?=
 =?us-ascii?Q?vUbcP5NlZu+SnLRVTS4Vflj7MwH//yVkm0aHrVfC8xRA68OFkobHKdwskr32?=
 =?us-ascii?Q?YctHEXZMIXKm/WkI67qgkIJmFw3S78XWJ4kJQLBPbV/xjz++5csEtBh6iU+M?=
 =?us-ascii?Q?8Sz/1VcXqdRw0sN9TNypbtfoJcsy7tlvChARdxgw8BGSvX+/89ffJXWvJV08?=
 =?us-ascii?Q?8W2V6FX7gKavdE0S3W1iXtjPuT0L1MbGRzXsX/hapFT5u9dMtrsPq/dPbtu7?=
 =?us-ascii?Q?ntz81QUvnZvvgfnk+p2labXmkcc2T3zQTVW22NAXAYGpPHpNqhfmLWIs84IE?=
 =?us-ascii?Q?2Y2YGJArLbXRW+koxTZ2fHVcP4A3wzsa5Dkkff6UG3tlIQh3Dn9/22ieLHrA?=
 =?us-ascii?Q?iZ9RQ+88488kOcUljyyvSfwkpueI71j6gKL8VHIE7MMGw6uWaKK2SOG087G9?=
 =?us-ascii?Q?6C+qkhfNDHsO9svj+02rO6CKNjRx6ivZoB7Ut2MHUQK0y9g7dD1dsfEZQZkj?=
 =?us-ascii?Q?Zt563HaK/m+OZlMSn8suQUpL308UFDRxk6Psg4ZVuAxjyfToy6PkcS+oYr8G?=
 =?us-ascii?Q?dRcY8SLLeATs3KcBftisbhahLYwV/d4jOSd8XVxVDaQogZbwi4+xTTomzSWh?=
 =?us-ascii?Q?eqUgLzM4KyzQ46XoPsJOZRzxayHrCtc8wnYqjvIcDvr2BSIlpN4Vqw6gmOzk?=
 =?us-ascii?Q?Wx9KnAYszoc7R+ljEYYf+HdgO6kXXTWD0pDnXmHzIOGcQPuj73ugm+ZYmcdj?=
 =?us-ascii?Q?URKdr8kLn/QIOENTvLD1YRHH/WroJIicqaddt7eOytasG7+wMJNK6j+evkLK?=
 =?us-ascii?Q?PUu04H0bnmX676/Lh5Tl+OL+9ZUhZb/0MancK8/fn9burrUXnF97Kli9wjsb?=
 =?us-ascii?Q?PmPrei3JlK4o+3GAXk7HSTjVeXRAA+0ozg26eNYZVn8Uxqb1ytipAJ1ICp0F?=
 =?us-ascii?Q?SRgvT7CZmz9EL2qBRszRgzp/BSA4M5fo/uPOkz0Huj/mt3SSSeHq3qsPmSt3?=
 =?us-ascii?Q?E6S4n8eM+tPohEiABFx4i0+vORxvQw8mFkPRdFPr/orlK9oZlLg+TS8HSdDP?=
 =?us-ascii?Q?gccXmaw39GXfhtpkd0XK3et4+NL5HmwMwJB03NkpbQFV9l/ki03Z2P3j7sXX?=
 =?us-ascii?Q?aW3/FQWH9CjRLzzZ3ANJY+Wo9ueHKpMnUaRECfClDU+NlgEJHFkP7ew2CSbM?=
 =?us-ascii?Q?gFHWbrTdaGp/JsbRDCWLq5ZigLWfH/ga7IpECxi03mbK95AUkern9kuMeLln?=
 =?us-ascii?Q?GYKtpN6M5BhyCOUe4cF/stekzTiXGNhzmy6n1jZ1NPwWArsAi3Jzkf9m779o?=
 =?us-ascii?Q?kH+E4NfwGLCYpirh+zVnU7J706ECtJmBPxcTb0RQ91GLmRD7oPPzPRsl6YWm?=
 =?us-ascii?Q?acc/bNW3x6RjgCdyxLqLNpt3Xm68JvI4jMJvnFzrTwXl0CuROv6kRYpNoXSo?=
 =?us-ascii?Q?0NebEbVAmtO1eIwEeM8smWr3ztMOi+L8p1+6mCVTJqE2jNPBmTREzxHtlkKz?=
 =?us-ascii?Q?a3YS5AGpKjeNh4pJOvhUf3UK6Jd/yG+v2gWJO0ipAdkL52HIjt8tvXKT1RFG?=
 =?us-ascii?Q?cD4ccnH9E4ECKY+eQX64ad9EpAagcKfC+aO/E0t1PgeUgyJEmV2NkeoYamE3?=
 =?us-ascii?Q?KmqDo2oK3g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RfbxEcB3YwGjBKcU1nwAryzK+KmQazUmxAvGWsMH1iSst4Qpuc1q2NfU+NPZlhkI6KIMAmKtLM2D8D6q0hONLPCd6bCcJ2YZsw5IpCElATO8Rj+DRPSrSHaT+5p8bZwv+4r4TIDaRpD1jOdQjzlTyxy0ofUYhDnpGAjcvnOOaVyborZGER/rcVCQkt6QCwmQn93V7W70CFkoJ/PooCZExvnAEw8tzbtHTSBKtTZkoUFsAoyMorzjLWSVAmpeTm3iIJN5qqMSNNOszrUiXt6XDaOkEEPY7sSGtUtK6FmV2Ot6IAPNJgp7iJ/+OKbH34DtKWSAV81TyhoqRJqBLJJsZDV/rXVYkkQTyivsO6S9YD7ru5AgREdsJW8FP8peJCuHA1ocydICPQLxr/B/YoM/XGPqecqOD4KcaItScv2hQTUAzMX2QcABIf+R/dOHXkHSFBZFiAMR6bwxAqHJbaVmG41eEq36bDt1sCmviUJnlqtdeEdww4uSCt7ukYy5XQhIKjjn6J/zQYpmauVZguh4TPYUvjV199Xc0VePmvnMIaazL9srTELYIjxep6kdlDwF+kLK3Pgc61vwpMdmKs2fmtQ6azLuc6KmKa0kX8psK5M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31a646dc-a7e2-470e-8774-08de798db406
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 01:31:05.2209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cguBaW3nUtkQ8Xh1+gVoUBs5C8feU6elSDyhjJNMsQTprAW6nKDo4t/mTtskTncY9A7VKiM7+21UAwaAl24xPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB6989
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_01,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603040011
X-Proofpoint-GUID: 7FofmWgRyxEE4PoNe7KQkaNl6Ha-kU-m
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDAxMSBTYWx0ZWRfX7tJQ2e6Kgy5c
 yqftRaWJV3XSxVU0zgq9PCAObFWlWmWZSAGfRFJySoNWwTSfuy7fSLDeBT0MUGK6NdCjlhanHl8
 AFtWYc4ui2ZePA1djGpcxdjJpeQ5XIhyYmv62jo9kq9T3B+WErUVbhSfzrmRzy35ON3HLfYwPBS
 uF6AHC+Us/A5otlTlfD4sxQCqtG+m+CMV+ubyI8j6jc4ezXxLlNZqeZiZ7qhtJ3MW32huOv8Lfo
 cMf+9nnjkpHHrnCzazrIwsgh7BVP7FLlMW74cN4twiJin4urw6wae6jMD4mDx9PwIlhOF0j4U9P
 ImYH4uRNhlS7bmpqlEFO2YzFb5IzFYpgdgLHf9E5Lt7y6BK0WTKYgYm1oRfGw6ktOT3azrgcMOm
 E+uruwHZsWjj9L8+6X7XGEjxXktC1n/zpATsYmcj4mmNbMgpeinHlWiHhagx7Waz9wB+xcEESKq
 Yg9fATjK4IBbTP7aHnyNnhuU72jDksqZ1T0F1fqI=
X-Proofpoint-ORIG-GUID: 7FofmWgRyxEE4PoNe7KQkaNl6Ha-kU-m
X-Authority-Analysis: v=2.4 cv=CKEnnBrD c=1 sm=1 tr=0 ts=69a78b5e b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=rJA0KjVYEokx5ObBIS8A:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12267
X-Rspamd-Queue-Id: EBD57140019
X-Stat-Signature: cxysrthuww316nbsbbkztzkpsrngkh3t
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772587880-138939
X-HE-Meta: U2FsdGVkX18Pct0t+X95WTfHdj2SlQIuz3P/jE8ZGiWveu/TCqG6muW4PjjePTBm5HT2P6vNg54wmhm4CySUFV5gmNUFwMrLU3CRU5CZEmAPPbCA2z7cuHD1Qh3XzyOWUwuCEnSx1NcXhvZVwkBVy/9mzGKwZ8MOfMZg06GXeQvioSfVlRtQJhJlEBPuYtmSXdx9WXB8Fv0vqpqgLlwDQ3d1jPMa4zpXKlNCxhy2GzVE2rIwuLgreFA35RaReKP2E555NQAc6hOQIqIQRZOqULs3PntTpcSaoVSR2CIbbTjCH+s69hd+g/S8B7KxH2JynhoztwdCSHN8xhjBKb+l/YX7kirc1lzkNpt+UV4QfYBR+wkflaQCkiyE4fFlQzbcuZhaEx0wcGVQlUQ7rPFneWE2ffe+epwsdxVOpUZ1id5XBsC7ym3OwOh/1lktIONuePRAYTmpxGhPfGLknilsz/rFzN7DriBJqH5FxzlcbVt3wu2nyl2yhwcOW4B/+tHjvr0qD/SeHj7sCyAI+PMt4wyHKykJgkbsTA2aVBa2i+T3K/IpOLaDXUXI+blcmo5A1EC3Xd5rWuPSo9k9y6tbMsZeyX8NHHEGNsXbGmpJSwQnEZyFRmFUl184ZrLgvjTKptanAS1DD83BTak+YWfEWOJU9QmQAWmgOqWHxPLAcm6sdfAurzfypCQKyPWc8JZy6H++6z26Ew9/PLnjxVuFnL+91cV2sRG6uoEIUMl+NwqymRYZjZ7my1Ilqj6E0I1SznAbEpu6jt2L5hm8vuaqQCKY2YMe/GkszcYV4tro1e3rmCuHb93nmehCRRk/Y6ELxZFA4M2PsIkt7VKnaQZJdVa/I78IfVgku7XhoHOUqCPu66JkA27DYLEVU66WSH49AHYi+ntutvisx9Ps9jx8DpMhnKeRAEXxrZe+3WkKOU7waEz1aA/meaviD87kMAVVu0S1MwCEwDd499Kt9rQ
 /XvOpdT5
 4XYtWS6bJcTkL2AvhuY3DcxFCKMeDahO5VhwMT8MpHv4mR3XHuybdKAiGTqBmlGkfcyposYIE1Au/6s1FD0UVmlUsf1bKG+fJ2/oJOqxUOOgw1fDbMU3i/OJ14q4xLPCMJVwqVY2t5+Se5PIH8CQyDzQLT5xAjPiMrnSvLSdhdWGEltJU9FaisjbAPXIvis1YcE5E4q+OQqdbNcBwxRzpXCUsgCT2txe0clhqmrW10hShy888Le1lfgIdRE4ab3vYy7dpBAbwNdWATS+1vhG5Bze2CKWVvf20GYGwMHj4JHU/WTb9KiCTZ3ljRG6DuISvetVsAK1R1WJhsecsDhSGQNAehJWkSt8wP6ph/juwiXEK1Jv7sWUJPFf7zKawhMBqo7pt3KAXasHjWE22Q4gEOigN6+t1omIcS7cBnT1+jHTlGToOfxXs5KcmdOeQwhMLh1N6/oBSoG7A5rGLp10yOHbaAOzwmiKQAm9PuzTwdu+cYA5hx1yyNJL3CRIb3Ov0Uh5fUPDy4I5mabbiEmTCiVAhFvulM46sQobLU7c9Ivpxh6wzL+PmWKtHdge85k7lhGWGw6z1giFux6wyf4d5Cokx2KbwyJbFSWZy5zZJgPOabFbuecXnpZXPNCgW4TIW6wamoxthCKZdFc1NheUAsxuXB7WpsAnqSJYL/CisF9B4I/+ig3AtDfh+/sYTFFug+X6Nl2Lyfh2/i/+VAFhhR3qKZv9Cx3DdPMx2TVdm651u1wze49lmIpnHWD9TWgQKxEpIUbBLQzVgc3Wrxyt7mUaxwhVH0noyehyOwRFGKZ6sd45SUnTsVWARjbL5dho/+GHSUBeWXFUwkZ6q0qNXkJSKg/CBXaRPp9Pc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[+Cc adding Catalin for kmemleak bits]

On Mon, Mar 02, 2026 at 09:39:48AM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/2/26 04:41, Qing Wang wrote:
> > #syz test
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index cdc1e652ec52..387979b89120 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -6307,15 +6307,21 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
> >  			goto fail;
> >  
> >  		if (!local_trylock(&s->cpu_sheaves->lock)) {
> > -			barn_put_empty_sheaf(barn, empty);
> > +			if (barn && data_race(barn->nr_empty) < MAX_EMPTY_SHEAVES)
> > +				barn_put_empty_sheaf(barn, empty);
> > +			else
> > +				free_empty_sheaf(s, empty);
> >  			goto fail;
> >  		}
> >  
> >  		pcs = this_cpu_ptr(s->cpu_sheaves);
> >  
> > -		if (unlikely(pcs->rcu_free))
> > -			barn_put_empty_sheaf(barn, empty);
> > -		else
> > +		if (unlikely(pcs->rcu_free)) {
> > +			if (barn && data_race(barn->nr_empty) < MAX_EMPTY_SHEAVES)
> > +				barn_put_empty_sheaf(barn, empty);
> > +			else
> > +				free_empty_sheaf(s, empty);
> > +		} else
> >  			pcs->rcu_free = empty;
> >  	}
> 
> I don't think this would fix any leak, and syzbot agrees. It would limit the
> empty sheaves in barn more strictly, but they are not leaked.
> Hm I don't see any leak in __kfree_rcu_sheaf() or rcu_free_sheaf(). Wonder
> if kmemleak lacks visibility into barns or pcs's as roots for searching what
> objects are considered referenced, or something?

Objects that are allocated from slab and percpu allocator should be
properly tracked by kmemleak. But those allocated with
gfpflags_allow_spinning() == false are not tracked by kmemleak.

When barns and sheaves are allocated early (!gfpflags_allow_spinning()
due to gfp_allowed_mask) and it skips kmemleak_alloc_recursive(), 
it could produce false positives because from kmemleak's point of view,
the objects are not reachable from the root set (data section, stack,
etc.).

To me it seems kmemleak should gain allow_spin == false support
sooner or later.

-- 
Cheers,
Harry / Hyeonggon

