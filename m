Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 057C0CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 14:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 544198E00AA; Fri, 24 Oct 2025 10:46:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F4C98E0042; Fri, 24 Oct 2025 10:46:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BCC28E00AA; Fri, 24 Oct 2025 10:46:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 23C548E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:46:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE823C0F07
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:46:55 +0000 (UTC)
X-FDA: 84033284790.30.EFA259F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4138280017
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:46:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="lmSMe/Hc";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=K14NN29h;
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761317212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HIwv8YXD1DIdtqjAH4XY45XxJl2Hu33vClPbMR8esV8=;
	b=RdKzd7+pcyqJH0+0D5/MCguTYT/hPp6MDroU9ccVadfGLyEL5XOYWKRrwM/nVkp7B9QcD3
	0elPsm3QATN8qf3RQpTj3hAuluN/FK75g1Sxr5IFFNsbfcAEa+cgVOCV0Y+TEYcg1kOasY
	ds5l9afKciG9bpEi+EP2yRWN1/fiO8g=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="lmSMe/Hc";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=K14NN29h;
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761317212; a=rsa-sha256;
	cv=pass;
	b=pkYUhBnD/eEu0Rmq9GXpuRi1YA9tDjBu7yyUbJnWF1xzBGxPY91zL7a4/Aa6/2I15JppdO
	920Io48yeC8XEpwKEOQ7GU1G/HL9RMwUBRj0JU9ji88+zCRKe+e18XjvL3ej8HrgbZq2ir
	rGK6MNN9on10X4MZcPOXzozSeKz6CgA=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59OEgOaK002510;
	Fri, 24 Oct 2025 14:46:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=HIwv8YXD1DIdtqjAH4
	XY45XxJl2Hu33vClPbMR8esV8=; b=lmSMe/HcnnTTkNwpqxyqWSXIOhejqGbvjr
	jCDBiGCr2xJdbXMwo0+Y9Ry/pcX+1NHyB1au/hOetq8/gT4tn2Fq+Ali0Z552QbB
	KnE5SWyPDpRkYuJinmJB8E35W0b+XpqcTsj/79ZkPMlvWnytU07bGF+IxYrXhz2u
	hjJr+s+lmmm2shf6dEmW56G1c9CSKRwD/X+qQd5cuMsUbCPqBgTgY67FB9J5Rw3m
	Tg+nsu3neu6B6Z9zCnkGxGNf71q6Wl3lVG5lqwCxlZrANvexfQMct4a18GVTKny1
	00Q8dVbym6zaYSqILSioj3AZ2mdmZQgh2+uNWPFHgI6A5LVi/VTQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xvcycxxe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 14:46:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59OECOL2030454;
	Fri, 24 Oct 2025 14:46:43 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012002.outbound.protection.outlook.com [40.107.209.2])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bh1unh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 14:46:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MTEAgMknGbwKlOj1BrhBSa/Ka/44IaS+ZHtp5V9bpioIui2eUrbuu2u7Sqbeurokb8pC5Rwy6+dw4iPYGrgivCeKQ6AgSUN7oJKLQh49LvWh51d1WAUW2UJL+UrxBg0fdKZWdXMO2lWYkn62sHqxqVXsgCQrWNqGUVSbYhUPVKI0Ck+YfvWjLQbXFuub7z4jwsWye1fEfEATsaPn2DtyNMxqQKFuUBEdiFu6UaWApzRuSVyUWYcpF6m0nRRHKKWUmmYHsR+wzSSzgI7v2tnc0W6vtYgVbwbz1wdLfCvB26rYncOCbGOzRmMG0xbw2hvjmkHICq4lsF39zXer8KcdOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HIwv8YXD1DIdtqjAH4XY45XxJl2Hu33vClPbMR8esV8=;
 b=vWbkC8nzaFcZ+C+UOVs1hiW7ZT0TLixjJJRstQBBN8HuDnUJ8iw9E5N5lj7jDESgNhPv0ufqMNhu0GwHLWvZlGdko0GzWstHmyq5UMUc+WtIHC//p0qIXE7+wEMI58Fsn/jToMvb4mLKO9WvFd+imM3ljSG7E/bmjlRMInBYZsFh8aHOaFDJt+y9oNHzzpUNGSWBr2yThRhcnPqoA1mfc65Ulut3DlGnntIHg1eSmGpSAoAKUfM2tiCYLLr/i4v6Uyaoev4QstmnrYaLY0L3iSGPUp4MzVDy2RPqDBzGORj7GWNo+Xy5DPPSTB38GY1nlLPZA9qwYqOwczmff64DIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HIwv8YXD1DIdtqjAH4XY45XxJl2Hu33vClPbMR8esV8=;
 b=K14NN29hm42GLGnAPqofbhTbPta0WY+lKXBmjt1BU//W/OrbLoRuJuOUVqm4ggGPLRSdq/h0fBBIJSRqwbENPlzx2IOSKQ/aK3mRb4vM6SCyu6hOaYezBDe1/chd8HN3+jJPaTzwN8s2QlFmxm6a7QxxNY68O5AJLx+cuWlWYeQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BL3PR10MB6139.namprd10.prod.outlook.com (2603:10b6:208:3ba::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 14:46:35 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 14:46:34 +0000
Date: Fri, 24 Oct 2025 15:46:32 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
        wang lian <lianux.mm@gmail.com>
Subject: Re: [Patch v3 4/4] mm/huge_memory: optimize old_order derivation
 during folio splitting
Message-ID: <f1830e4e-1630-4242-be0d-1cf65f20b54b@lucifer.local>
References: <20251021212142.25766-1-richard.weiyang@gmail.com>
 <20251021212142.25766-5-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021212142.25766-5-richard.weiyang@gmail.com>
X-ClientProxiedBy: LO4P302CA0030.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BL3PR10MB6139:EE_
X-MS-Office365-Filtering-Correlation-Id: acbb6e32-faec-470d-8f1c-08de130c20cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/Ht3lQK0aPGRI7zqZieNdHVOhDJuGKZg4p/wx4ImjjCdLSXOWnPgJqa2kSSS?=
 =?us-ascii?Q?erOBpRpvM8EVZp5X5bBFOCswZnKa/rvu5P+DQ9ENtLck98oxivS/YnsUFVlg?=
 =?us-ascii?Q?e0T94o936XNtz3PSmyr3Cl/KMupmqHRnIGQ2EjmA8CduMA0VNq/c4gB7iHsa?=
 =?us-ascii?Q?f5fVh1MZirFS7Kg29/UrfMLPWJzV9emVs9fOCuLTGIYgau5BcxyJcmVgHd09?=
 =?us-ascii?Q?wwhJuLLSqTrjE087WnwAY0lM1A/zaJceHQFLiMBurSJ2k80N/Kuwn0IVPI+p?=
 =?us-ascii?Q?ll5Ujvg5oEmr4fK7pbDOJ1CJApDbUrcLgE5CCMJYZanlaaKkn0ECZ6MEl8Gf?=
 =?us-ascii?Q?0SiITWnDiodNko2s1fWwcCsWd+duW4bUQNHe6zUE77IiBmHsjus9r0YY26nS?=
 =?us-ascii?Q?ul48K91Z8SuBgIsLSlANlDVnH+F8AG5FicHIEcwf3wHJuzRqR8t/ovT2dSvK?=
 =?us-ascii?Q?BdsMR5Q3KTa7wybLv/7IjVUMyDhsJK622cX+40FQMOUw5ZtiR2bet4e6Eeyc?=
 =?us-ascii?Q?UDCCCy9VdLj4RkxPWcJOQnk+jgZMxskl6GJYyO/uwUGjfDQEKsfB0XIO9YK4?=
 =?us-ascii?Q?dhyB18PchQFmXvYw+Br6oBkdPAS64kA5CkilcHPZhvmbdgRraQnxGeNSV72T?=
 =?us-ascii?Q?DJXOE9IcaUtQ9Ydvx+q/5mJ1LmslHLPR1LvoJkz4WCXKrrLioL/A201vnqAi?=
 =?us-ascii?Q?k89/zqsHwXu80zWUOfSRkGrziNl+OVmpaIi3eLRN6z6HIFFWZ4JiFqygtOBk?=
 =?us-ascii?Q?B1R/0cwF0NKNkrLWVNE1fnLbFE87dTZwqooiir7MO+5cMaRiVkDAqC584ajU?=
 =?us-ascii?Q?gbFGQzQYJ+S+KzWPnbNeWn/RWZJSpm/gp70eXrMFjViY4Sd7Q3oOd618c09Y?=
 =?us-ascii?Q?hrv+bO09VJQtdmtyKzF83rTSW3h+54j5+n07seN4jtF4zo3Bmg3PRHqmLzZU?=
 =?us-ascii?Q?VuIx40NamOJMo6fdiVcoWweZjxsa5aY3o/0ActYyR5jymKWGhmxux5LV98MK?=
 =?us-ascii?Q?hF+0wiX1DAzr+tpBNg/SmHsiMnl8r9IPIUHgp2EbYFODpTkkHZI1dm6gQd67?=
 =?us-ascii?Q?XNXdktvmeLNOwbmug4VhbwGP4rR2H13doKARDpVxf/JCMFHIEWOb9wLEQH+t?=
 =?us-ascii?Q?+vSY5+gEcVoPJ2Y4otbguwwm8t1nCAuF7rEzGLd6wf8L6zUuokCOO2nNxDOK?=
 =?us-ascii?Q?gSgepUKofr5KSFqm+CK19bDr0LYj1HX85xoJaxpufGxblJOTztmAf7Xg9yv5?=
 =?us-ascii?Q?BkeOPppXwe6vlA4c5Cxu5g5O/hp3BssCO5+EuQK3YPZy6gDc0//expjDBZ3o?=
 =?us-ascii?Q?nSiq3olDw60bLfcunLpRpuuLpaNpsB6R1z7Sk2ftDe9L6vo7CDUU7lBykfMt?=
 =?us-ascii?Q?7wJ/lLSZTSMFGvVAbmw4J5FGO+m05yWjRnUIXBrB1g+Zk7dFBmZvWjBa/J6f?=
 =?us-ascii?Q?/QxnlV4kYMuyr/2ZkdlaaMFJIGaRRYAM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j8Bf1Hz1fZ42vzldwY6/cFHpziMha6Z9B/8t+sUyuDC+goXZQ2E5fxlelCGD?=
 =?us-ascii?Q?IRFGjtHCr7U8K0idi3EvtKoxBP5NVSfAe2j3zzcpfk2ZXLthwWUTgn3cf8ni?=
 =?us-ascii?Q?zqfKL3zgPkE3k5Qf8LnHz+vrY9zulkI5f8kFhEb4HGWKqHsm5iuO3FcEJ0nY?=
 =?us-ascii?Q?S3cwOW6/1CMqcyQXZxevU5X6LX8ELdbR95t29SdCOrfdxnvTceL/UMz/JnIn?=
 =?us-ascii?Q?evcfkqQtWlSgGwlW7kZXVv0Gs/GsmO8kJMsDkQfLnVTByd2k0Deg0PALzJkk?=
 =?us-ascii?Q?1gUwKBSqziVsmekWgqiotmMZH7MW5sjSShmQPwO/UpxWXSy6FiGpx5bh5qYg?=
 =?us-ascii?Q?gaJ4TOEoKPgDW49BLFmcQ9G9Dx12t29B0j7OwIWTjw1HOI4fAq9nWaoL/eNf?=
 =?us-ascii?Q?mfsThoRObJoKkiGMxZAfOE8pkYai4vsBxVh0gR8Kh+ff9ubqAYQcBnT46ww0?=
 =?us-ascii?Q?5Y/cGkvDl66W0qr1mk2eTmFebQ4yLJOx+gM1FdHyEB2JUUiTGKMHaWw7Y2dK?=
 =?us-ascii?Q?PZ4HhSw9Iim7dZyu5lxc3245JTZePn9268l/7/hHCSsoS7iiKWj0tEDHy8RF?=
 =?us-ascii?Q?JzKfCNXyvnUfPiCFwL1AQdMbHuby5Kv8nbEMBImdYPYdsvr406RgD9G4YIC+?=
 =?us-ascii?Q?0i0HBA0SCtcaOTaUIRi1S0zgbzhBUOwcJcgR/gohgFhSQyGjnF02I2YzdA4u?=
 =?us-ascii?Q?gFYvp4dLRQim/4hZWAt/OKosFjMKogrJ0aooE8oXvolxj+c6F9OtNEBLJq+t?=
 =?us-ascii?Q?T69EBIbkB6udI5c8nId00sbcIOGYoJtYeEVWOLm+UGxeB8hw0pkf/eeej1Ph?=
 =?us-ascii?Q?X6bjwRgeAqo12xoloKLQbyJnxEZiECf1haNN41nnwyqQmAvJNlJjBJ4KEjMe?=
 =?us-ascii?Q?3Z03NW49vVng8LuQ3CCj7t6x9GUJR7QeENrZtP/QAoOnM8IleHX85Zd0tX2E?=
 =?us-ascii?Q?Gpi69X4q7QrpYWIPt7fTkqQ3tZt4plVdl888GdvAfjkBFNs2OEoflqHIgXqe?=
 =?us-ascii?Q?H1eaA+S42lKKzev6tmJSVyzKeC4NRs3lC3jOTRlSdKKqbgfYJIIQyNG51cic?=
 =?us-ascii?Q?d7Hm2rczXn/UE9gHRtB6ADmnzfoXJHZFRxALLOvYdROhRw+5BYyeT6QHD+nM?=
 =?us-ascii?Q?0347rafdmN3xc+SSg1PM1Qgl98CRSxfsmYlISfLv3gM7J0YWkssD3MbdWLEB?=
 =?us-ascii?Q?8hr72nfnAbznYxU5HMP59TL+RlUXCy9oZb1JT+i4eUbnWQhnZy7cqssY/+en?=
 =?us-ascii?Q?/aIBKwQRt1fwdvAk612o1bYh9X7VbHo9GTl4I0JGfb+LPi8eorAJ/insOsDh?=
 =?us-ascii?Q?g8bnJrx+XqZmiIHUO08+jEpkP+VLl5esOZqmZ6tas5H4EOZl8pPP7utAUP4f?=
 =?us-ascii?Q?DN/5DBtTeYqxAweKhU7vq5vx9FPigKl5mKaWXb4QMFJzZV66s/BAYGqLIDOd?=
 =?us-ascii?Q?L6XebPjlMiIi1Y/C98MgEHhulHzp2NkL44KnaTVet2dIsSTJaLVoUXDQmbGE?=
 =?us-ascii?Q?5KQSM1hTVmcD6PVYg+Mmy2yH9TxQb+NzTDnk7GESN1WV70Ob2y/cjQ5obXV3?=
 =?us-ascii?Q?qwD4PfmRoJcniPPEJUPJgNg90dCWqGH8J/ChIT8vZzNiwlo+qlz7uq0TM5jz?=
 =?us-ascii?Q?qA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2Bq7vgybcK396Vo2fioVq+GsqPgv5Z1lrTGYDJUq1YKRZJOh1Frg4cXedWvVKdZl/oe1/H2JNn2+2vBv+ICc3oToHFWT/KPyTFdqnqJGzEF7LEdiSmzeK74xxOHP+UJdxfSJYcyPqaxkAtLZMqjMfKpsIymMEfNfCBYMmQHu4BnWvJRwmLOO07kN74G3qA8GVQ/KIzjoi8GcC7ilLV9SALR79LeqZ2+gh3gTEj4Chswx/9om3FZ72jX+Wai3qr4iAuVnt+DSE9RzWLQOUJzjmQafLWXvEops3J68EFHojz6P+G25aq573mpdr1ZdY5WPrfR48xLFGJxNrby82Rg/dzDf2Tt5EFu+eprJupCWYthU5yytGhQOYRSaS3SD3ibNMXAli9PAbTz6jy8hhSjonoKOZu1fa4VM6qiFcIPgJH6Md8UqGzsj2V24mvNCI3JI0Bwj0ox3j814+g/XT3jDFmlopEjLl5JTfpz85hYeWBmabJf8Gi0vZb5Qh/FzJHtsnJ8yiyZqt+5yTP8Dyf1JU/NUNFU1jzw8xGZQTCMQGNhAtnworwNi9LvgPz1l2jog2ytzT1nM9MpypaUxkoLcdxj4cuz3QQhYPEfwe++CSUw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acbb6e32-faec-470d-8f1c-08de130c20cf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 14:46:34.4814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 79mtxEBimQpui7q70qZMUKPmknJT6FfCDS9yXOVt1uRVucbUq+jpWCFpSqAO7iZCnRoE3IwQf8liK3pMsMQxERLyXuVEmQ3xawotVH2Lwg0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6139
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_02,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510240132
X-Authority-Analysis: v=2.4 cv=GqlPO01C c=1 sm=1 tr=0 ts=68fb9154 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=Ikd4Dj_1AAAA:8 a=u0KvptDUXjxDJ2SQPZ8A:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13624
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MyBTYWx0ZWRfX3WmfxL5Z+bkQ
 xdCiasJ3OP0HIcIe98zzRVvWc89rX7uIvh/IBzH70Ec86Oyzdt3FZn5BMAGjwyEu/CImA2rRfH7
 1RUF1F1DcFkj4FL/4+iYfF12BCI1oV9yy6gPyZ1FDqDKarmE8B9g8E0z5lYk+vIJ2vYpD7EKuQs
 ht3qEusPuudwSKmCrqxl6x1yMLrRWbRPQDfL1Mm205Cm5SuG9FL50I9kMu2e9WgLRwXs01+EMGO
 9OsjWvNduucTxv+pwOwCSe3exa4TlRJCN3iLv8UZ+KIJtdUM73fmmZGy1mibbCQm4YL3us2+3Pa
 OzRcgGswSSC34P27+9O+fxF27BvaRRR4UlDURWcuTKxx+fjtBVVvVYBE18yKQew0qxpzC3jHKVj
 rqR3D5dehkBKIpoXCKMfIczTJgZ0Ho+0KMpqNK3RN3LqTYcseqs=
X-Proofpoint-GUID: lvQqlKmsBGwpCKmAmXOZcOX9goPaFSjO
X-Proofpoint-ORIG-GUID: lvQqlKmsBGwpCKmAmXOZcOX9goPaFSjO
X-Stat-Signature: oxmrddouyojs66bct3mxf7mnyjskqmtx
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4138280017
X-HE-Tag: 1761317212-285708
X-HE-Meta: U2FsdGVkX19EidrvASLgNetXv/kKljxw4VgXX51jplNwA4kUFnwamLPLP+0jTK7XeSgJi4+KN6s3wuMDBRnV5L6ApBVzLGFQUl+H5nDJbZmmBsLrKv2emTBRbestKqmPXs90M2Jj76EPdxQ2A4dVFkhNhhgj3wHDgsO1H8N0CMO8Xeb/O4xlWCHlJu0+39AS3alQJD6AV292zVYVuz+oP764x3YUycIJBwKMnQktbpiMsR9nj3jeLa0OFteIF5k9kmizqEtcmZwYAzDKA/2jifOGVoKMS5j5j3JFfFRmdxffOPV0GgfWgXVtfTpUIzR2eNlvRS5eLK0AJN50LoSdR8EXbXjhcV+/uXOIJAtaZ38WMkEDNy/WmG2q9BZyQeii5m3NbCLqIsnEBSXBWtRn9+ATB1dXAVJtKw2NjZeuifgRGRjnWHa1SKWjxXP65CSzm2rMHV7LxlZX/dLnNIkSCyFKoe++t7PZcJpNX7b4CG4IF6DPxqVJGSQfToM7+T7W0j7plEP+yi+8IzQdXn2Ce8C0jb6WiEQSBirflzBBlPPVJHvFGar85QFDT3ZdB3wXq0V0OThYmmrjoE3qP4Kh5U+Pk+PqlIXqIBcBESWhIvHVq1yFn/itT9odAmdyxY0P31xTL86ryu9L69VFDTGrG4TQiME5YAsjvVkYQDkKRWul4tzGi8YEioDZbyzOLy96kQUcvIEZHVkwcms6pvXNPsOiyO1e+xndT/TJAybO0jRI7zZDOvOP7IlECJJj8vKpCc+ywIi19xmxDqKYY7BXZwPQSFzZiDudS6FH+zE7d6qfWKCABHXSdN9bXZQMghyJ/j7IcoI8wDB9DO9byzM6MmItQvupwuvgbNR5MsXQfBn+66z2WltDr61zjNbfZ8cmknuTW6GL014wO+okWb0Rn41JPjiGPGa0PBEJoKQA1O3MeWiSiE6qyRUkwbPDieckNJnPFPzfIoNu5t9me7K
 UO0PFd0s
 JW8s1RKwcKPU8s3f50GsFfSOJbo5UqzMroin3luE+ZANS2/M6V3roV9osl/f6KhYxEm+gz7CFLnn9dH8b1cgJsQJc4utZ3ED8RHOiUGEoEBkSymHACOytTK0fXJ1odS7sXkWjMCfZZampgOt/YG+aeF2XPa7NSZirEJL9q+xBVIGLrZzg0oIiVVqHodfveKr+zy/KbKSfz2MdZg1PYZePIjnFUtNgohVJWNkzsUsnBZP46WTB5W3NbX4yVp/66H6AU3RjE59vIfmmmRYtoaySEI81fwIkkAQHlNrLJgmNUivbdU+MbM0fPRAJYhsrZTv3baBycUXLQiM4Al0OfOa4uJSa5lWjXuDv+6WqMwgNw9NHKqzdKHkEEW9OYIapC0DqaqwP434xXiwssq7/tkBo7H4/sDdPOQ/qfuS+6uQ28j0DUuxQR9734wkPQKYshu1gVQ96UQLEqAkWV/QGpJ9UgD38PbsGPSJ1Uc5jMqGjoP6RlICewdR7X/TdvMxdAhjQ2/NIosmeCGfMOIJvK0UxIe00TkPMLawBCcllCyk0sYmFbkjsmmMIK8TG5iVm9Ce4ODo1PTGjjFnQ64bo7+V6i4g4vXi8kOZr5dtl/BayFDscuHGvoVJ2KAJyvp7BSAtHutUrnH3sc8TtrINXFd7NBZcyOGTinIaemrxHG/eAKDM9DYQN0afu5Vsjn+F5WWiHg5ic5sLt49wt92vJkjCpuq8h+HzIYMIsfP0XD/ojtc5euym+vdFbo+g7Gq0G8LFuQdwwURUGDHwKMApQyluoBQSPILcAz2F8hlEgLfVn6i2VU0hNfuZoEnyJxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 09:21:42PM +0000, Wei Yang wrote:
> Folio splitting requires both the folio's original order (@old_order)
> and the new target order (@split_order).
>
> In the current implementation, @old_order is repeatedly retrieved using
> folio_order().
>
> However, for every iteration after the first, the folio being split is
> the result of the previous split, meaning its order is already known to
> be equal to the previous iteration's @split_order.
>
> This commit optimizes the logic:
>
>   * Instead of calling folio_order(), we now set @old_order directly to
>     the value of @split_order from the previous iteration.
>
> This change avoids unnecessary function calls and simplifies the loop
> setup.
>
> Also it removes a check for non-existent case, since for uniform
> splitting we only do split when @split_order == @new_order.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>

Thanks the separation makes a HUGE difference, much appreciated. So:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> Cc: Zi Yan <ziy@nvidia.com>
> Cc: wang lian <lianux.mm@gmail.com>
> ---
>  mm/huge_memory.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 093b3ffb180f..a4fa8b0e5b5a 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3596,8 +3596,8 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  		struct address_space *mapping, bool uniform_split)
>  {
>  	const bool is_anon = folio_test_anon(folio);
> -	int order = folio_order(folio);
> -	int start_order = uniform_split ? new_order : order - 1;
> +	int old_order = folio_order(folio);
> +	int start_order = uniform_split ? new_order : old_order - 1;
>  	int split_order;
>
>  	folio_clear_has_hwpoisoned(folio);
> @@ -3609,14 +3609,11 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  	for (split_order = start_order;
>  	     split_order >= new_order;

A thought for the future - now things are simplified, it might be nice to just
separate out the core of this loop and have the uniform split just call the
split out function directly, and the non-uniform one do the loop.

As it's a bit gross in the uniform case we just let split_order go to new_order
- 1 to exit the loop.

BUT - let's please save that for another patch :)

This all looks fine.

>  	     split_order--) {
> -		int old_order = folio_order(folio);
>  		int nr_new_folios = 1UL << (old_order - split_order);
>
>  		/* order-1 anonymous folio is not supported */
>  		if (is_anon && split_order == 1)
>  			continue;
> -		if (uniform_split && split_order != new_order)
> -			continue;
>
>  		if (mapping) {
>  			/*
> @@ -3643,7 +3640,13 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
>  			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, nr_new_folios);
>  		}
> +		/*
> +		 * If uniform split, the process is complete.
> +		 * If non-uniform, continue splitting the folio at @split_at
> +		 * as long as the next @split_order is >= @new_order.
> +		 */
>  		folio = page_folio(split_at);
> +		old_order = split_order;
>  	}
>
>  	return 0;
> --
> 2.34.1
>
>

