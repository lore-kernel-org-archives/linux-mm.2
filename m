Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 812B0D29FE6
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E61A56B0005; Wed, 14 Jan 2026 06:00:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0B016B0089; Wed, 14 Jan 2026 06:00:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8EB46B008C; Wed, 14 Jan 2026 06:00:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B77546B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:00:46 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E949B994E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:00:46 +0000 (UTC)
X-FDA: 84330276492.17.B2724B6
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id DB7AA40010
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:00:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aoGo7P35;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=AEf7fDEt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768388443; a=rsa-sha256;
	cv=pass;
	b=SMNSffdrogL4twRSUZIRShc3VQ06z6k3yfNujS8PBURvkhBBuEksRpaAUSljtBzIX9O08J
	7DKenF3Gr5uibUo2T4KSq28E6kSzA7klsoUPwcNXT2/T97msP8SHBqiVL29Jc3YME2QP8h
	Wn9/ac1AGJT8RvM8hfBG9SUvtuuTyOc=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aoGo7P35;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=AEf7fDEt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768388443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=923u/wz3Jr4nqjLe6ihn0gSPwU9Mbob2LTHFwUnEVg0=;
	b=BKjJHmZIHq5PxqAOpTVtAcKF4P4EGHQSMvGZQvSIaV7bLGoK9igO7AaRclrpnH2rcD17x3
	bU9kNm68sXkOwlu0PuGMhUbD0S88hoXlXdzpJzyyy9E8BMkk7xpVRiPL+1kqXMEs6IaxLr
	lHOqwBL+gqyGCmdBNLnfiEFl8zWH950=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60E3vojq787278;
	Wed, 14 Jan 2026 11:00:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=923u/wz3Jr4nqjLe
	6ihn0gSPwU9Mbob2LTHFwUnEVg0=; b=aoGo7P35JzoMWMzA45hHXy+sLMxWQ5Mw
	JD0FzEUj86FJoMGVxecnPdLOahMzHg+KVpO8GFcFnG0mZRiwRTkKLIxPC+JCyxIN
	Gilh9urgftvX/4bNMzOdtTLKa0chJNKsDwlRtGRWvBRcdvWFL5ocnKiAyoKlF3dy
	LwsFaOvjUVKS9y+WUWxeUvcn3CaDxzOBbjZGgyQWRyUjSq2bSnUKwIQfFi8qEO7f
	GAaIv7dvY0TqgZJpqvCWr24fY0eJJ/nqBX/OtvL6Koe4YE+QLYVi1HhIn7v0Upoj
	lwTIxWhHORnxxj71orYQ0t6N2znQpqDghqS5EbTHs8VzsJ4fxRUfVg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkqq5507h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 11:00:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60EAWd0E004405;
	Wed, 14 Jan 2026 11:00:36 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012021.outbound.protection.outlook.com [40.107.200.21])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7kpn68-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 11:00:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IG2Wl64ZoTpdASAuQchd+3JPAkHbUz/t7IZe1c7bDyZxvoloqLSKMqzIts92OJbVdu+IHrXJtNWzGi9NuGoOWA9YUZxXbXOKIB7Qxt/dHOlT0jPfc8q1L+VzmRf2de00nrIV6GMZ+I0Q/ZbRxByKlbzWXAQbdVOA49eUVtXb0KTtSFujJQurmTArPf/2ekX2dTK7W9wmeVOYeh4RGQv0qwTlH/PiGalxTx2cPBzSO2oRUdFJsxYeFvMRmhNPvIXNCTQNFtoWAFWXIby+4byn6S1n/XQbgXFI1QmhEDCoKk4TK+Q0uoO/yv56rbMyOASNTx3xuVm/w9X+S0aSKAsrbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=923u/wz3Jr4nqjLe6ihn0gSPwU9Mbob2LTHFwUnEVg0=;
 b=dnGTSIE/ZLZoTge/FEUowNw+UonqeM3eCQlSpz5l54GAzckX0gSRnA8w8eSHA14E2w/4PgPJWXxpYuyoFK6g2JBD0KzaaEdqgmchK3eKu4E82urOybNCioGlctOhhoXJEhQtFbQC+0hcImgEUjPdugEvlpQzXdUnOP0iWIy0dr+AVknTkU8jP6ECE43F2YhV9nUAP5qdLeYQQhnaCgXbndhJ/RJxHonDBDBYrhWXJN1C13DXtb3CRZEsWVgccxyG8S78m/8l0/WvD0iVAKev1h9RSJKyT1AxiSqn1Sc/QELYXnqNS3n87wAnJBs51NUbZ2/FXUkuXKMWFoLehE+bjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=923u/wz3Jr4nqjLe6ihn0gSPwU9Mbob2LTHFwUnEVg0=;
 b=AEf7fDEty/nSvXFi6BxRg9nB7oqILWuLiaCVL/4riCgDzcJqj2JWir7+xPpbHBUr1UG0pbQC9ONMKNSqPPiFB0zlEiNgPYcH5Cc/zLKh1WcKABsmX00UbqU1hLnpHJsWXvz6sRKLor6VVFtdyFwaj1O7AkpLktd2JbHux497Qpg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH5PR10MB997757.namprd10.prod.outlook.com (2603:10b6:510:39e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Wed, 14 Jan
 2026 11:00:33 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 11:00:33 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Chris Mason <clm@meta.com>
Subject: [PATCH mm-hotfixes] mm: do not copy page tables unnecessarily for VM_UFFD_WP
Date: Wed, 14 Jan 2026 11:00:06 +0000
Message-ID: <20260114110006.1047071-1-lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0002.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ad::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH5PR10MB997757:EE_
X-MS-Office365-Filtering-Correlation-Id: f60e57cb-8d7f-43ca-a330-08de535c2310
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?1hc5h2Lvf0u3/CnNgVN/TBSy+laDtkh0+/bQfxTXC9Aa1IPysSiLjsAJKJzc?=
 =?us-ascii?Q?cWQU+kKayI3/EBYE1zFgkjjJkTOKtE/3OerI2x672NsXGDp1AuMR5iTebkhK?=
 =?us-ascii?Q?jluDEXrSsD8C12/L9367kdt7QYCIcpAtyJ7jp0I/kmJR+MLqaPDNCz+kNsTU?=
 =?us-ascii?Q?vjIwVck+B8jaqWyn23fSqgDMW9oVrvViIJnU1t+nuc/4bTahUbsAczW3ps1P?=
 =?us-ascii?Q?WT8rOcwuRdzCLTWktX1IVDGXY2wztxLbwOXfzbSlp9Uj/wEQ+Sssc92HwEXk?=
 =?us-ascii?Q?uL8KjtcqrXEelYl3GMiBGkEPUYuaWQppDcF4vod3TZzAV9hlnHl3GUXWWMEz?=
 =?us-ascii?Q?SqvFH+sH14AchKA9gDWD3+eLCZxZDWNsOcM8VA6/O771Dyajo1pDAwOy/F1x?=
 =?us-ascii?Q?Scqo79MaR0TmAtwWQrZOGBXHOAWbR8hBYCnLCn6K5Rkzdm6rTLoaZ9bu1KXo?=
 =?us-ascii?Q?UXFGNJSIMMmonjZihKQPpd77JgsGols2B/MrYZ35pyC/abP3AGwRvJ2PnHGv?=
 =?us-ascii?Q?yxsuCfpv28JZcacBXxeGB3prB0fSXOBxbaeSVVGcudsrwLMHiJw95jng+Oqj?=
 =?us-ascii?Q?CH78rOJPdNdI/RlHTD0ttFwhGK35iDe2eTGyplmQM+tcokJzMC2H7+zH6Jp+?=
 =?us-ascii?Q?XfXMH79+GDBhvzk193x1rmaVlMvCX1Yj12xhOlHvuj7LCCTEl4SPWeszxhav?=
 =?us-ascii?Q?9cyxwiDEItdht7esdYvNOl/U5MQ/0+efrjcn2dlDl17VBxkJsl+CUH7KkAqT?=
 =?us-ascii?Q?8LsplcWtUOeybIGzuetm5T/3g3+19U4e7LddqkyP//8P5Qy6auRd2yXChJPP?=
 =?us-ascii?Q?td6SIU/EvVnU6Mc9FQcGmb+cEos2mtpaE/r1UtZXgLidAE6cop/j45dOEZZ5?=
 =?us-ascii?Q?LkmGsfJ21Ug9zULhFfw0ROAMCUIMBF7YcOWlg5VNBCKiPnbRR7HwhhcWMFd0?=
 =?us-ascii?Q?32MvF7+3pG4QbiIBFZ6q8cuIyQxqT4mh9xWBLFp24+kHYF/mJ9Ukiw9TwPiC?=
 =?us-ascii?Q?dLYfPN8x8o09w37mRj7vXAhdmt9UoIUu5vcjIHPfUnpuGMakywTqqES4YzVP?=
 =?us-ascii?Q?QZ/2pP9ltJIocwG9tEldMNGMH4pe726skWhoAw/N5/mQ7xbTnvR0lVKH2KpJ?=
 =?us-ascii?Q?P/PyPAL6vyVITPrwcTbuD7PWMHS3Z8CWUUuy6PpNd8SaK3zit4x8xIqYHoB0?=
 =?us-ascii?Q?92UkZuUbNU778feqvaUckuD2g5L4IcIPlwsZlTj+QfFjT2GersH1o4NP3fW3?=
 =?us-ascii?Q?wLUzwIyxzSB6SoXh3b+H01CoNPUu6XYYt+vMzgHIQCH1bcfFHHq765ZDwk3k?=
 =?us-ascii?Q?osp2rbzEJQAbE719h4eM1Gv2znqHE0h6tFw5ucCok5G6Lls4xlJNFPVfTWtM?=
 =?us-ascii?Q?iOZZ1jDCqzrc9iXQcJc5OZ5FXfi/IZ5Y4lSa54txLJJ9JnvrUd8jDKzoJtKF?=
 =?us-ascii?Q?TbuUvVMjVi7RrJ03bAVfK5LmqdDlsDlPfnyWqkYLefwuBwDv5EHyWBVvfDKO?=
 =?us-ascii?Q?Up1NaE4GWgUK76oJTV5Iv1z1WgB4OQvC6oT7lzzHXiRmI5LTcl0JoqSzxLib?=
 =?us-ascii?Q?9JVsC/VK21ui2pH6Uyw=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?rDn9Twsx47bPds2POpNIRaT8NdGocqyYXKJ8bho6ArkoaoPhYK15tTPSBqQD?=
 =?us-ascii?Q?HIsQXKZcPU4ADCy2BxTKSlsoXYgJ3xOtglmIhMvf0ECzH5b05XXkXCyhNyt0?=
 =?us-ascii?Q?j+oHOrgfIm7xRhsl6VqhF0m6MsnLLhVMUeocc/Eaj2xX23ar14H9245KBcPv?=
 =?us-ascii?Q?k1wp1BQGizrsO4VRk75okBUtaBLBbG1EfW31nJ0GUkmL6AUGyrrZbGs6FUlj?=
 =?us-ascii?Q?BIfxIjSxY/YQ/wqCrN4GJxz5xyPgxoLKmDt/oxkmCEC5n6z1H/F2Ido3mOX5?=
 =?us-ascii?Q?UQyzGVJDsVsh7ZNG4KKUF2m92zcaISUsCzSp24SSNwIoOMCJBABvvIzTG+Lq?=
 =?us-ascii?Q?YM3EPcwhX7u9Pf/QbMks+oHrWwSGQwCNyWnBgTUIXNU9fZ4cwC5fhym7XEMn?=
 =?us-ascii?Q?m7xiIH5lUTROqlBtCNvnPe7xP6S14QcprHspnJ18vz81ShjqGJxb02nfrGb5?=
 =?us-ascii?Q?O043txPN9UuLlDzbnnqGmqjKnN+tsL3k9O+C6tu7Bc+VObOsA+c449Nlht4B?=
 =?us-ascii?Q?6vOsOaf2TkaiUjPNo669UbxR4X3XzNp/mgC3whwggneXsdX2THrEKlISv3pq?=
 =?us-ascii?Q?s283yDNoDpDuHuvuWy8INe/mXKZ9b85fJ+4cFLHx8AxVsliwCewtVFJrMpQC?=
 =?us-ascii?Q?wJsmSmdn/A24ViK1qctH79MdUnyAbNOgnuXHbe9Z81DcxkMhTYqFzV2B9paD?=
 =?us-ascii?Q?5Yvnb2JUjhw29F3D8a0QfZUy5/rfl/01OU3eivJw6Wat+B6mNTSMWpNETXB+?=
 =?us-ascii?Q?iOJkMVsUYrL8hzqx89qJWYZpqH2tvywd1kw1txkRoZblVR3MafCiWZdKEL6t?=
 =?us-ascii?Q?YFO0TBqKyHQcmkKMs4bI22F4qj+WLhZI2d6fe1tcQNe3aS/KVgEZBERzTGQV?=
 =?us-ascii?Q?JtOs8HiUOlt1xFDQxu/ctUbshf6FFpPAWb8U1u+tYoPzA28EZ4eb0ujyKvVT?=
 =?us-ascii?Q?AoPCPq0NtNZEtikTPoqzyDcJi8+OdDFzGORkM2K49eYH1sa6gAoRNTXZCfTM?=
 =?us-ascii?Q?HCqVriD78O1WtMoJdlzotK9YSX7Ty7yAgiIQdFLKxQj7/XiAT8xcCBstxZjJ?=
 =?us-ascii?Q?bSv/K/KkcLws9Q4f4gc4zs7woPAL1qIHdaJikuMTz/k6u+IxxpuH9+KAMx6J?=
 =?us-ascii?Q?UNKkKooIk3wrLJrh1vdUqQaU2/xz3LXQ5Ned7LTCCHJ41c79+30Dlz8XHQ1x?=
 =?us-ascii?Q?IwTibDQpkVdyXH6J7xYcI3PCrjfd6meDGQGZSaLSiyTedxdicCoPVm2HqdGs?=
 =?us-ascii?Q?NoQ5rlpdfZ+RbSuFB6d210FqWjwwRZaPoFQbDHtFdIdcsF/hPg3KdvEmQ37G?=
 =?us-ascii?Q?TD1O51xuJvjOgDMx5PWtExpBHa6xqSwy8ET30f5tPJEOu/pyiHazNAdzkvVd?=
 =?us-ascii?Q?QBtpqz/4rhJuCOiqAT5jElbmGvgrXPCNNgoCczoY/B2ZRG9+G3H7HqHXeqFe?=
 =?us-ascii?Q?uEhfSds7cCA7APwQhUnZoBSrQjtOKElJQeaBl1ou7XuhOgdotK6r08DpHekB?=
 =?us-ascii?Q?2sUPddMs6xK30cL6Wel2YiZ1L7GRa5cOpD+HOuCAjapGwsMX0H0vKzKapJ96?=
 =?us-ascii?Q?FWbSnwCYOeA8VOBTOy7C7TSo7dS6z9Bx70R7yfxk1msP9eSoyapxQ3R8KmY2?=
 =?us-ascii?Q?VTEeUIyb+GvE6glUd1VgZe9YgdaF9hszEEPq2Y+lx8MMhuWjDd8jSOsbHA5L?=
 =?us-ascii?Q?7c5igm5iamnmYKztokWCvk0BH3dJ59qld+oxi+syb1AYoVCdLtycReUD93DB?=
 =?us-ascii?Q?6/HDCdQQLWQhHmHn+DAzzb8cgLZHOlQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BIMy3h6tLWc01L2JKPdISzRMjqhTVQe0aJvpBElAn6uxtSf4ua+lve6TEStf8PdeWdSkBUz93zIE6XKrZ+HFL5xCb361H7iXZSPMbFbzFXBTHGRVJvY28Fke1bhtHh9Ldk7PkjbyJ5IgovbX3lc+e2cahoLCNJK/i/jbZ35SfOuOd2cTq9vob7/dERUMiLZb3Fg1I7X1Wku6N329rs9bLdCK5yzP+2zR6Z+LDiDeI9UrVxjlp28DIuLkq5Ewy1sN2UaKzHKVQPBAV2d6iWsL87Hc5EJU0cVRIqeR+Ps+FVkDowMHkHhRNBrNiWpOjAnBmSpEMBdSwfyHUfg+YSzP9SNniUfdCYsPtc/CfRuAeQ8gCrqIU63EMgVy8uGcwfOFShJ1VumHvciCBFz2BSl9QCQfPtCdz1uw5H7TAh+qRvPfwgPriDRdSIgdNyUnxiibSXgVW6V5D1k8X6Sjx+PRuCaHOCvhjga/jL97vOZVwWdqacTwaks52xLIklKKYXRPDQJ+dMHNSK3cUoOWZZKKc4re0cmu/58iMHYAAEI2XgHGKHhVULVqwhDiwjgjeENW1UF2xDksyh0wpPJQnHif8u40lnTB2Odga1kVMjIJHww=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f60e57cb-8d7f-43ca-a330-08de535c2310
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 11:00:33.0935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qmh5uWFW5/zqwj4PH/ygJCty8ZMCRDL5VHIrwVNe+tEf2IuOi33KEg1bUGSl1cffdp1WC7yoajsAGOmwGmq4B500XmpB++rD/mLb1uvnrYo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH5PR10MB997757
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_03,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601140090
X-Proofpoint-ORIG-GUID: kzxyzwVGvhU8r3oSAhvjjAGDvYJYRg9j
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDA5MCBTYWx0ZWRfXxin57Nk3d6kO
 vx/vnTi2YQeqiTcS+NiYoKwxdgBGt1Ns/mpx+rJzKPogxcTV3jRhNiWqSuWiXCWlIJZWhT5PW0b
 0gRgkNk9BLeJOEF1N8Xmy94CkWBRpHWiisfkBQ9CN5NaYZXB/5TA7GCmYojwNpvgwC0xK/iVaX0
 WG7uT97bvHpyng9ae/oOkgMNWUFdCpr+Fe14OoZmtEpc5b071xSmJYV4hd0YBUjvN+0DXFg0qct
 3Ho5MymjxuqXQMfApeU/uP+VS4dYNNkjHY1Ep+DtlU2Zp50yYU1nNQEeoCdYXBLV7ByNh0hBXsE
 DTqOGkl8/FK431T+LO/zFIWm8MqYSPRCv/i5B/qy+q/kOtefsLAKjAFBmecuzPVFfhunu4VaF2c
 Iuo4Wfy/+Hb/1uZUhxRuADQeZxFvrkklkgo/IePRtSHGtDTTsgwGNaU4YyJBUBxbSKVfGN7RIpq
 7Y8giXLCSfLLHV3FY7MbDcM4Iha2y+65Df/jZCfg=
X-Authority-Analysis: v=2.4 cv=J9KnLQnS c=1 sm=1 tr=0 ts=69677755 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8
 a=yPCof4ZbAAAA:8 a=T9WHj2KOTr0Z_LdyC7sA:9 a=gKebqoRLp9LExxC7YDUY:22 cc=ntf
 awl=host:12110
X-Proofpoint-GUID: kzxyzwVGvhU8r3oSAhvjjAGDvYJYRg9j
X-Stat-Signature: ww8t6zr9drx139s618o9uymqxmnpiwnc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DB7AA40010
X-Rspam-User: 
X-HE-Tag: 1768388442-673575
X-HE-Meta: U2FsdGVkX198aSAQ8omkx6Y3UIuDPF82V244ZEHr47piZ2E6gZQeL7yYe/Uvlyfg1E28oYjrRN7PBLQsdFwdjCINmhM9JBInjtCKieSX78rBCTlIv9PNYfdWu97pjXLbZcQGZfvrYqPDHLFZKmSLwBxVsZdYBdzsOuTBOHPEt5enOi6pdNUWGnkTi+43F2Wp6+afJeh5z+VrTEb+rbL903wR04N5U8vmR9TrpbrH9BwSLtM4piBdDwtoO04djVat7i7H0g2p8rnIeqvt0YcIqAXJ30JCWRmNtQJXp9gUhVuM4PVdZG1j+e7sq8NT8FBskrVHMBAXgxmFke/YqbEFIzC4glxo0QK/rbgDV8yfUpxzF29UaofZOe4ReAn0jNSM4E81XPIt3RDMLgXxyDDIf2CPgdLtZPLic8QROG3q8Uo0SStYyil688K1X0XE/8TbQTqwwQsv1z91E+ze15cd8nfZVWFRhFwP4BV36XWFcwdqFRhn1PKm7301RRac4Y9+tk6/qJKi9e1a/YHpRkjlsa52cKaPnfIHoTXXTNLq4sLWn3g4pjzh+PF+bAlrcNl9UDvKNxNOHZEvHIOWN6kgPfnyMr0+l03ijJhHhA9nDuJnzsYgEnvRV+3OoIOUv+2bW2pQoqgKndHX3D3C4DNI0NjyMcT6m1Y6/p2Tw1wUFrAPi+xkia0zGBxP4zB5FA0aiyyPmhUlLmicTz3LiMjGAf4jIX4kWLcZaWzCvchb4CiPOO3dkvHcsg8Src5SaZtR/wFeZX/ZONctHko2y8xGHRQP3kxBtsbRm1jBpZF1FYW9btUbYX/D9Q7eaUH7094aEu+1tufxsCYqxk4QgcdeQq0MkJASd4AE98kgwshLzRt67gCjBciBx2qVx1BlA6xDesWm/BR7nDdkJMi+oS2kOJOpHUT9TLIkYFptxjjdh5ObJBRr6faKJxpEALmwMtWKM6EeW9dT+1/ExLYOWz5
 ifZqIEgY
 +L7lK6kN9jiwvqrP0TEDtZlPeJ1xAEi5SeudTFjOL+gmBwyhIX4fbDWZC2vDU2aUAxKrzUFCpU1F1NrfFyiPKaVmqL8YsmE8CXqSZNk/vFM/CalWzFiCiS0qdcEg4wPf+nlee4B6tqve94nQNFtQqe8cRsrtfQzsI9TNJM2UZfjbyRqoEarmcQPQglVkpYPDoNYO3hRtJXCXjJl7brYnQKxJTnVtzk/gpwmrYl255LzXUSAphr3OvI1kEx9eZ1CaDh274e/H0OJMu8MEXxUSys074LDm6qJlwXBuasit+IhoYwxNdp7/aJmu2SD2rohvvG6MWvfR3gCU01fznbvmyfnBQgXNc1twvMws6qWj4Gp3VOrYpzbgqYlWur/inhwVAEZjTLB0j0MSncoqMFk2PZR+EEYGDIzpiHk4eyGa0yQBVaduGCxSmvfNTsGWZ2W2kBRaAxBFIt7me0xw4YBruPhNtiAl/IlQY2bThXlSbaJ/FJ8ExrjEgw74lC9JJGUmk1cQGJTr9ClGAZV6d9woSOz2HO+ETgUWTIKcQ0Za3NoQz5Q9xPt5rp45o9qVsfJS34cBLQagTmfCAU5AWhmOgdqPDOS+/4rJq5tU12BsB7WIfCaY6L1XQqcOBg/RVm9Y7oAbd6bRGH3/arHLV+ECz05NCS/lRaRxIZGLKSqKIBHzfPRkoXWgh6pfMCpQnNB7qw39Pzlt3jUa6vO1OC1sqdX6CXh+9gu4isaAsM73MOJZLO2joQUMlpQA6Nlu73trlxguLyPvxHbbpvuA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit ab04b530e7e8 ("mm: introduce copy-on-fork VMAs and make
VM_MAYBE_GUARD one") aggregates flags checks in vma_needs_copy(), including
VM_UFFD_WP.

However in doing so, it incorrectly performed this check against
src_vma. This check was done on the assumption that all relevant flags are
copied upon fork.

However the userfaultfd logic is very innovative in that it implements
custom logic on fork in dup_userfaultfd(), including a rather well hidden
case where lacking UFFD_FEATURE_EVENT_FORK causes VM_UFFD_WP to not be
propagated to the destination VMA.

And indeed, vma_needs_copy(), prior to this patch, did check this property
on dst_vma, not src_vma.

Since all the other relevant flags are copied on fork, we can simply fix
this by checking against dst_vma.

While we're here, we fix a comment against VM_COPY_ON_FORK (noting that it
did indeed already reference dst_vma) to make it abundantly clear that we
must check against the destination VMA.

Reported-by: Chris Mason <clm@meta.com>
Closes: https://lore.kernel.org/all/20260113231257.3002271-1-clm@meta.com/
Fixes: ab04b530e7e8 ("mm: introduce copy-on-fork VMAs and make VM_MAYBE_GUARD one")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mm.h | 6 +++++-
 mm/memory.c        | 6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index cb3de0c73d03..44a2a9c0a92f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -609,7 +609,11 @@ enum {
 /*
  * Flags which should result in page tables being copied on fork. These are
  * flags which indicate that the VMA maps page tables which cannot be
- * reconsistuted upon page fault, so necessitate page table copying upon
+ * reconsistuted upon page fault, so necessitate page table copying upon fork.
+ *
+ * Note that these flags should be compared with the DESTINATION VMA not the
+ * source, as VM_UFFD_WP may not be propagated to destination, while all other
+ * flags will be.
  *
  * VM_PFNMAP / VM_MIXEDMAP - These contain kernel-mapped data which cannot be
  *                           reasonably reconstructed on page fault.
diff --git a/mm/memory.c b/mm/memory.c
index 4b0790c8fa48..2839000cd26f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1465,7 +1465,11 @@ copy_p4d_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 static bool
 vma_needs_copy(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 {
-	if (src_vma->vm_flags & VM_COPY_ON_FORK)
+	/*
+	 * We check against dst_vma as while sane VMA flags will have been
+	 * copied, VM_UFFD_WP may be set only on dst_vma.
+	 */
+	if (dst_vma->vm_flags & VM_COPY_ON_FORK)
 		return true;
 	/*
 	 * The presence of an anon_vma indicates an anonymous VMA has page
--
2.52.0

