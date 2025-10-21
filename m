Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EE42CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 14:56:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9DF78E0015; Tue, 21 Oct 2025 10:56:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4E818E0002; Tue, 21 Oct 2025 10:56:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EF5E8E0015; Tue, 21 Oct 2025 10:56:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 88DC28E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:56:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2AC7CB9DF7
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:56:48 +0000 (UTC)
X-FDA: 84022423296.25.F0C1672
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id C661B8000E
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:56:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="pjEK/gRS";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KnRJpaTc;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761058604; a=rsa-sha256;
	cv=pass;
	b=4yd5819y/LwPGZgZ2eLBNyQ/wFmH3BNJN/gJzev+0ze1mGNT4uNcC4O2qvBblzojvOADoF
	APTZv3CRhXL59OeoeHu78SZIrd/WvmWOC0ua5wdAi2W0Q+tc/oRRZ3coWLbVvs6LF0k9iw
	QT19dTz3uh72eDzs2ZrpZXSUdsHKMxI=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="pjEK/gRS";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KnRJpaTc;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761058604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b+Sjss1Fa5D6+q27XpH8FiJtpob9OcAFSfWbTTzbvcQ=;
	b=lbeJJHXmX59mwVq730GY3F5akql7ukt2ZfpTITSfoq91FmQmw96HGs1KyVBQdvH8Qmf6Md
	PCaZYL9iOgfqEImj5jIsDGqNepxqUF7kqK73Cn66SXo/4mDkzPermnmFU7l1L0USo8X0Vs
	OB0q+cznyF7ZjOM9ylVhK7+3oA0ihIU=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59LEJ05H032124;
	Tue, 21 Oct 2025 14:56:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=b+Sjss1Fa5D6+q27Xp
	H8FiJtpob9OcAFSfWbTTzbvcQ=; b=pjEK/gRSiIwl7JY8ctkbO4+1T+H0v9kOw/
	cA012tI4Rnbzgzn2WoHla+r8Fi7QUIWEsK67WEHIP+PyZSjlUAurPziW+jFV+8i0
	EICa+iGBOYh9s00fj3nDFgpzEUwyc0jLV6mD8adhcQU9S66aT6TzvOXp2Ov6ucW8
	Xo/EAG2Hi3zW9yazOFSr+Qy1ehjHKKXlcNdgd1Yi/BoKpvSeSzidFPz4hIG7sCf9
	PPe+Wpuht9PIBjSgYAr1enJuS8LicbwsiLGHGbirknSI6/PwRIrPjx2DXzrf7u6F
	T3mfGy1zxz0zxfC8xOtPQE4dgWjRrVJfQnB1dZ9/B4rFNoKRsaeg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2ypwev5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 14:56:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59LDuCpv009331;
	Tue, 21 Oct 2025 14:56:34 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011001.outbound.protection.outlook.com [40.107.208.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bd74uq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 14:56:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vVypicLrC2pJToG0qesneXwKPdk7mNq27CLHqMssTlO1AFGsrjOEVOT9KORH1yJFvzyW6h18VeambGufjz+0uxUhDWRwZB2/xlhVjCpMOhmcm0so+PFG+BeTUYKhszaxgvhOG7PgPOFu6aBzURqhRSFd7gZEBHrujStXSwUqIq42hqm2aN9xCO46z52T5ck7zT2J+uscxkmFqttd0mIW79EKK4nIURwc0cZ5m0phBXC5bK1iTn2xZci4WBrgYoCXhKq3CVa+vIFPF15C14hYsRfMJ9XgFktsYPOQ/EtILxVtRS5wVjrivzvfNUSwieoPFU9bXRH0rMiycIyu/Z2emw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b+Sjss1Fa5D6+q27XpH8FiJtpob9OcAFSfWbTTzbvcQ=;
 b=PcBzaqbgsdDfTd6GfX85Jgz+rc7B4oOFzxKZYj8XRe/3ouFqXawF0BC5V+dmqCVhciuaZZuqLu0o/oNK6e5pNf4k6GKq0jm1nTvDooZjSvY++aqIwD/WMKBt8nQy+JGx6YexMeeBRJTqPaJ+6TGvRYk0jNrI+BEb43W/OJXspeEVLFWVHpnxiSKtCARA39POSVwo1EjpZog+UBoVTnkThLRNCjRi68cFmZ+g/aprP75sdXgi3NWQswaPCSTPRaEfcTFfN24N689UsVbsNuikhqjOs30jLU2SdpkSEwIw4IiWXdN732J9SLCCVmnqKvvzDO8nfK1gQxabA4h0OjKPsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b+Sjss1Fa5D6+q27XpH8FiJtpob9OcAFSfWbTTzbvcQ=;
 b=KnRJpaTctbYc25s8uuyt8r14cbXDUULQVVuNq1hjOAiJeWHaR3LW0yEvNLH2g/TY9s9bViBbyw+iJjcscH9qqsP8zDoyIiVysb0GhepF52qqa91Ee6HRCZhoSf6506p8w7bO2vbjx1dfuz/V+F3ycw4SsyKNdeZAab6+kBObpko=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA4PR10MB8611.namprd10.prod.outlook.com (2603:10b6:208:564::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 21 Oct
 2025 14:56:31 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.016; Tue, 21 Oct 2025
 14:56:31 +0000
Date: Tue, 21 Oct 2025 15:56:28 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Liam.Howlett@oracle.com
Subject: Re: [PATCH v4 3/4] mm: mprotect: convert to folio_needs_prot_numa()
Message-ID: <16ca4c3d-7c18-4cb9-bc04-d2eccb5d9b67@lucifer.local>
References: <1a97f0e2-fc97-4257-8540-cff06a789e32@huawei.com>
 <5ff1ee06-375b-4d5b-b513-7b8cab4e8139@redhat.com>
 <f1d3d11b-6ac8-4747-b2e7-952d4fc3e09b@lucifer.local>
 <719c8df8-b4c9-4a6a-bedf-d62becdb09d2@redhat.com>
 <759578b3-d582-48cc-90af-491210ecd90f@lucifer.local>
 <3ee89484-9cdf-4c50-a5db-79b9f2ca6886@huawei.com>
 <967f61db-0ee3-4257-a44e-69ef15ced012@redhat.com>
 <944fe458-6391-4cb9-8719-dbaf69f3958d@lucifer.local>
 <72e2f6b9-d241-43aa-9a3b-2f13c763bef8@lucifer.local>
 <3554c866-5087-4beb-8d63-6a3cea02d431@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3554c866-5087-4beb-8d63-6a3cea02d431@huawei.com>
X-ClientProxiedBy: LO4P265CA0223.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA4PR10MB8611:EE_
X-MS-Office365-Filtering-Correlation-Id: b63b51df-7fb3-48f2-82f3-08de10b20560
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mk5PzwADuuwzRGglyWLYrlu8ewqZGxN4Kbee+Wm6y7IWaBQh4ONia5suvFx7?=
 =?us-ascii?Q?BpeGa4tAIhA+iWCZCTn2cIb7hhcyYRDSSRhFycQd/jz+Mt7U0Qzk/Lf/Ml40?=
 =?us-ascii?Q?i/RE4L7JCW1CyaYW9dnNcL9TSpbwVMWeXdoQUsCQnEZSizBifE486eFO75VF?=
 =?us-ascii?Q?IdGSPJ2GYFuahX4VEviYC54+hl5KcDwt+N8hOUfH/P80ujMMXk6m6uR52JE9?=
 =?us-ascii?Q?1v9w4CvhYquRhrsyToY7EcKMmB0NtV9C/2MqL0+TKj1M6jgAiKZZJM0bpen+?=
 =?us-ascii?Q?oBCF7p3DYZYimwAqytWZROvIMsHpfD81gPNhSG9ed+tARbVaA88tMgCisiB7?=
 =?us-ascii?Q?7pLuDw0SIYGVp76gPaAkCR/kbQFKos12mezbbyIXErnu/OrNUJBekyZ+FT/j?=
 =?us-ascii?Q?Jc83odZ4sABDFKo4VoDn30qZp3HvLwH6j0LilImTreB3DxymRbO0Voc1NTD+?=
 =?us-ascii?Q?CIYDoAaEKUJkrIfd/ucc0TOe2vUlN2A9IlqsGZ/MC/bQu6RX7lQEvA9PMQrn?=
 =?us-ascii?Q?CX3c21Jx/MTsHlJsYy1vL54IwIsBEYhqtP9We/gSu6d7zs0gul2J0RpJjV9A?=
 =?us-ascii?Q?Ba4gq5pfeQPUdf0SKQNmOb/9CNGHD5IyybcJPQF6vmuZyJPnVBx3ItbBOfhk?=
 =?us-ascii?Q?giCFkiquGULVTC4psJK14Pbcp7Ceu9TmFgInLC9vbJKBPoNS+axgAmTAsPLv?=
 =?us-ascii?Q?MK9yZrqq/78f3I9Nq7UeEPxSvSgQTkN6/PDdRTbPSC4ULXiqnssX2RWLcJsE?=
 =?us-ascii?Q?Cj1TCQtjHfuXHCdJtmGnw8UtlsgN60u9RyMGQyctK6zpLJUh6Cs4EwM1zB4S?=
 =?us-ascii?Q?OhmuwYzV0HUER4GkizpOLumiCS/sTBppoAhAk0HzQJddj8/Cwbt/uQ3c0tos?=
 =?us-ascii?Q?fI/hBbY6FrbncgYIGkea3EMXtZPhBCkrUuLsKEywwkxBgZninYDY7UqnJpIX?=
 =?us-ascii?Q?2D+n8D+v8L20UNrA5Cpgrg+krbHb46Us56FNXyhO3bgic05Ha9P6N2SxS+V7?=
 =?us-ascii?Q?cn8j6CB+RdPVKztocxkd63u/5Wt0HPhtMXXV4CE0ECChM5JcoDJGnyR3p6/i?=
 =?us-ascii?Q?x1caSBLMdLMrlO3LrrR8HC57lmzjAFwZYJgMPX/RpX5NX/Bo4ZcrMgAmKP6N?=
 =?us-ascii?Q?yFBOPeqUhwGCqzSF10TrOxLqydV5ybsLNNADd5QQCJNjS3Rkj4VRDVA4XugO?=
 =?us-ascii?Q?RH0IuS7C3IErPsGNX6VsSQcqWQA7T0uFPtuPgPjPaV4XgYnGfZ8lXOW2wfgd?=
 =?us-ascii?Q?MJeyBBfI9ddWOpkIaeMAyurplHKDeDHnqZ7fzwEeUIT2SlX+BjTIpNC97BWj?=
 =?us-ascii?Q?814x63G+VOOYud4ZIREvjmFLTArDld4/B+i5zUwClQy5bsVYecA25lZDpfdR?=
 =?us-ascii?Q?DHxayH0rnyvbYMUaLymV1DUSigspQrUf+B13X3abFGNEr5hfSOA4juF9bzHV?=
 =?us-ascii?Q?DPads0ewRpfEns5JhmioiCLdE5Wy56q5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oR67iEk3DmS35Sw/6I/QXwj13Jt4MHlsO3WM51PFIiyuiD602yUOLnDfK9SP?=
 =?us-ascii?Q?z/76lPrrZyKeqz8eqz8JiwhnE9ujCHZYsZx/jR/A8pMThSMuu13U8HR+5SZw?=
 =?us-ascii?Q?+J/+8yBZUXfA4rIhoU2GmC3zELWDa3VUxD/Sn0l3Wa+1xWlduFNYMYvG8Lxl?=
 =?us-ascii?Q?ZlvQqsg354LjkWYLJwjvi0A3+VBQASZt5PwvPwJvqD+9JKl2DfbPlUNdyqUA?=
 =?us-ascii?Q?3tCNIqtYkuuo9xjR/ctGlEjT8qlTJR4xEFYTZh6UKFPa8WzdZl00vTRFWShY?=
 =?us-ascii?Q?auZdoB3TxiXUpOTyg+roeXCw4vK66gZ6W3r3DCDaYGVkzxlaUjBHgdIDa74j?=
 =?us-ascii?Q?JJBPqcu/cdmc0/ZIY3M+Vb4BqS4oO9uAsfDl+p06LkOZB7dWk8RU3FCyL4uJ?=
 =?us-ascii?Q?pioGlxQ3KMJ0PL6N3gE5wh2N2AGPqVtJoTCegi1nXYS1u6ruAKZZi1OxPYjr?=
 =?us-ascii?Q?5oLTEdvsYXT5o3bjk+9RlS/L56vSTBZKGslT/YkoO2/+dhyQKWPmA86/ycxB?=
 =?us-ascii?Q?NATYWnL6vD+aYBc5vzF46iD8TYgDQ+sHL9WzltYjhlKy2cu/KhfEQltVQMeI?=
 =?us-ascii?Q?ZUSh2f4Psf+AaqHkP5sAyJoxUVCX1Ffnpzfm3smAlQn9WmL8cfC1X03p3GcU?=
 =?us-ascii?Q?v2IYa9u1Rv2hgaGb3kRjtBAKYCrpU+Aft9OtWD6tgLhqYpnZ86hKL7L/m2Yx?=
 =?us-ascii?Q?VzkixZFeuieP3Pm6S2XyZ6jKG7fiwvUUj0nNhOcz/BqoCzCH86Qv/e2uZK8x?=
 =?us-ascii?Q?XAEZmh4Zlu70cSL3YW8NBcl7Pv+gumSp5fb8febT5WL65ucoTv0ZgFFDwmsg?=
 =?us-ascii?Q?ivO5LHrfIeZNQT20eaOE9647WKY+qQXftOgx8lJVJH7J6WCHfyRLGsvZ5/z4?=
 =?us-ascii?Q?NPOYk5UbDQtJ9z0oM2hB0UMTZJ2WvdUTpDBJVUMoe9iw00p1Rg2Jcs0xoNrY?=
 =?us-ascii?Q?CrqWOwrUM38gxGBbeRFeAv//uz4kZjOJTsvTTOrbxvjEpEImbI/Jjp6vwrmH?=
 =?us-ascii?Q?ZIOlDHDcSQc3vfsv0SDMTzZXN47fHVO6ElQHxfFYkxqsM0acz9O5Lsi2y8Fv?=
 =?us-ascii?Q?565Hn8Jwd1BLyTuk4Exj46gYkPw5Ibr6UYdEfzfOa5nteIBZwLhLwhDcNMJd?=
 =?us-ascii?Q?CDAQXLQ7D1n5Vt51zEz9vKkvMCxd3E04zxhdSLUUJiO/ZT8K+uiwLQxep7UN?=
 =?us-ascii?Q?fwI6dr0q7ltv+wDN4mtumfVB/hZT/ZTLhCwr9X6W11MvJAkDtir2fvnvOoEX?=
 =?us-ascii?Q?/qVQAcPbZFuDdrLm1D+yW2bLMqTav8C3KUtXkEkj9ykmKqaZtryFD0Zcj2Yw?=
 =?us-ascii?Q?duebaFbKyAUuWiAQWvX/UH8faDbl1vLwZQYvzAasQYP1518pmlQJmIeFL1Hp?=
 =?us-ascii?Q?op5rn0XWQSgITUk5w8vlAvjQQoLKJWCy52oa+QkVjqjwKOiWIJyDrw1o/T96?=
 =?us-ascii?Q?oZhMHGV+yg7guUzkBK5mZZH7wL7SrevpCHb4Le5XRrdgX8TXMu06DJXsDaeh?=
 =?us-ascii?Q?HNByeOiDDT+myTK7HwxWJRaJjkQiGOAMtIBYPyuCmiDHxGN/BvAb7fRum773?=
 =?us-ascii?Q?jQTzUwGqf/WnF4ZtaaYh1JivvDzQIR7KEvZvag9qbjD5RmnOlcLhy+Juak81?=
 =?us-ascii?Q?sQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xxL3G+7MWf4LJS2BaEQgb/tO6W8Xd0nWQ5tLx/2p1Oo+J7aAVtYXuw3lkWrKNxtbQPRUG7VV2Cc561T93u2ARXcRm7guRjoTFRnOt5One0luCDe0inB8tjVXlvLZ8abE22aKugnOUv4l9Ksq50t7DE9QfXNjZx9Mc5w266Pa3TauG8jIGLvdmtmh23Us4Zkx75WRHRZeC4Yq0Tja7++kNPP8cSN/uXthBK9fme2jq2X9xMtUhZrhUq3xjbUouP4eKTIljpkJZfLsfzN0/7yqmJS95Iu4p3Xyjspvuv8txHkTK/VtrDuq/RlFWtoYUnjp5vX69Y/sz5PaKuy0x/xfy/h8FcMI1oUP8/CwDkBL5XIwsyBRT7XtHBpYtcG8tUXsWz6uYhfdFerTGnAepzP2aDjD7a+hrTo+Kg3knXqzz7/nMSkRhBYeCd0TSMSf9VmS8BNzTwZXtiT51CZJWluUmVD6wNbpd2sERptBoho0MneyEktLQwgAdINWOyCgKQQNJxxxFL5wCfhn5tlUowsaZ1NuTfQOX7ByJFwQ/yJOnaSl98uwVWfyy8uU+va43vqficSeceF/gZDkXeVVyC04Boc7tEPU1dFW9XJbp/PIFXQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b63b51df-7fb3-48f2-82f3-08de10b20560
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 14:56:31.4258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: npBaUJyZGMnOYkXbQO8SeHJf4llCvgj1lFJm65Qk0sjC9kCyIXTLuYl7B5KtXlWn/lqrvTQyYqHQJFUCXPAw6Y0/+xNUosdDpuzWk+WvRsc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8611
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-21_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510210117
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX0OSA9+1OsjCQ
 mGK7GJi9IrMyybxKFv/r/tZoftz9KLLwJWdINq9LKTY2LSJ1kvYsCt+EuVc2FMEmZv9Rro+ujIg
 uSdA+v49lTCZwI7tgKRVbHGjO1Vypd4/0uuRfDqd0RbUWpid1QmXrez/pNuXcG3pGWyNdc78bic
 L6KKt14jePVM7sfBQbJKqr1gq6T3oW6jpys/RTz5dx9A/TgmN5A/ZwSla2DzTV6urn6x29d3uA4
 oHmSIf8KHal4UAy9Umm5bV4zvXg3wzXR3dsCVaqDmoEN72jRxiRz8Ooa8U0tccqSdwJtrq+NPoK
 KOkbAy+MlZ7PfBMoS1zBXL7Sw9jwQrKrUr37nqyidj9stvXbMC8XT5kBQ3/K3c2ktr9COxWhD8M
 UEOGJnmXy7YhU6IYcJGOF756y0PmqaOq+/4i28EOXCcUrqnyEjk=
X-Proofpoint-GUID: SeuZVZnCnMPH_ycac6h1G-zxN1byhqvO
X-Authority-Analysis: v=2.4 cv=Db8aa/tW c=1 sm=1 tr=0 ts=68f79f23 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=wkPVM9HH4d8cYeML_YkA:9 a=CjuIK1q_8ugA:10 a=ZXulRonScM0A:10 cc=ntf
 awl=host:12092
X-Proofpoint-ORIG-GUID: SeuZVZnCnMPH_ycac6h1G-zxN1byhqvO
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C661B8000E
X-Stat-Signature: tqz4bmfmh44yp4kdu4y5a1pewpz57w8c
X-HE-Tag: 1761058604-192994
X-HE-Meta: U2FsdGVkX19qVQgTraRWqh7kvXg0vYjPTXlVfJ9ly0pjaAFF5X99EBytbAT1DyzypfTOUbDqDrw3EYs0TC+HsD1D+Eh/Gtc1b/M5lbhZradO1GOgJyipfMLpff0dbQRAv683vBIkYQR6nihRrRSGN9GRX9zkAf2WlNAYODU37WIS7cwDgGjoMk5GMI1PpxopHYDH7DkKYV+Sj4H6YcSnH/ne7quqnDJ0A4ovgikDRgT92peL/MAr64eBHvg3bzVfA+rZfXkM6Il2y+RG8TX5Gnimb0pyCcTQs3ygMPSHLFo0y7ER/LDGDvdmfPYNJIeChy2gRBh96JfPHlIcpOHFmKP6MK4wy+cqWINEgs+kjXE0Dx80U4FxgpDNX0hpHF/TGA/FDlTpZvHlSMf8r+jmmHstUPV+IQX2JodhDJNfyDib48SBu6HfZT8GYRIHwTjptX9vgLGP3OPAjlZzk7p0W9SYkHxVzPmpL+udseH6tefnCRr6/ymaib2VIZmNS6Qmvwb2N9OeL+PUG0oV4GoPyfFgzg4YDBK97hLljRHDGAgQ66u3B6LCfbQshZ/cWAEhzL2sBepmvKPJuK9y9/jau2MstnJ7SmcOYOkaZbqbFDFj470f+ErqnM7Dnro4Gn5ZMIQf/mnLKVv8hQj2h5naEB96695JLXIRICXXB5cFqQAfu6VyaoXnVhGWwrkV4Dzxm0m/Ecsjk07IwMYXmMP1xt0flnXiHjxFo4FtRCZcrzYBqV1fgGGChBr1no5PSSj1MfM/V3TikcbvdqlBDEfnmQNj/jEVJdDoaJLGVOzeqjOm6vMde0o9mZDS775Z2F0YNeWgkxiFWOsOyGtAcQq0ffRBz1Moih04ceMhfQZ65DIhUTjwQPeofm682zldsdU/+rHF9ETG7iohzHdU1XDmNs+BkN5D0TLLhe2wnxzV2POEq1xZOhHkEr+TKvVv9WXSlMVhuMJyExsPCkPtnMh
 Jvf7bjpq
 O50xtjVQmLQ+fJfvubbXUVvp7nE/M1LFaRUw+ZYRI4Ugtb8Q3WhVNLIp59Kkef/hiOa0lsyOu653E8op+6U4tf8sFCVX2cwt4uinmUBxQ1Ncf4qTrIdFiAkYqziOj4N33My3WScHiST6LqrM7d2ljz9Qrz2HyxGJey+2VSxp9TJK5UJkF/C11uPbDBU0qOPGLgQpfu9vDhKF9CMUoL0v5pPXnITZnla2BiVxJZHww8a46N6DcFjDhRUOuz9nmgNNOj94+LVIWjPJfdBkFHDTPJwv8ifn4Hys/9cdY6LMEWwpYkzrp/s5lgVJcrtWhDjgM9YN2mWTvKcHb8/PxGHWJM6txmQFruWNqkGHUGPQVkdwR7knH9sBKJYS4uDV127LI2C4scZoFTse0zRx+iSGyAK3c89vYhCcmOlI9BQKFXSwLXAUqH2mSRHq84X3fhID7VIx3NEgxigji/gWsnS9gedWi9dbq8m2Qp3umVljdG217BKP3JjUvIl6W2RHrx1nfmKZ+W4SNln4WKQkU8KVf83bbsxZPaXKQ3sLlK4ehSTKOaznE96B1QimsUWSzkfGkU38voRBfgUUWRAtavKr3g6jHNETH1PLXGfMyKEjcyUEnfC6EZ6PNY/3C4rPSaUB5NhQ64dZckULmFt2RQwvPZC6ZbJxy8ybaMFuZI4sHKXeyHPjeV/j6FlCOOVmjCyjhC6HA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 08:54:08PM +0800, Kefeng Wang wrote:
>
>
> On 2025/10/21 17:45, Lorenzo Stoakes wrote:
> > On Tue, Oct 21, 2025 at 10:25:08AM +0100, Lorenzo Stoakes wrote:
> > > On Tue, Oct 21, 2025 at 11:13:32AM +0200, David Hildenbrand wrote:
> > > > On 21.10.25 10:41, Kefeng Wang wrote:
> > > > > Maybe folio_needs_protnone_mapping()?
> > > >
> > > > I think prot_numa should be in the name one way or the other, because we
> > > > also have ordinary PROT_NONE unrealted to NUMA faults.
> > >
> > > folio_can_map_prot_numa() semes to me to be the best choice.
> > >
> >
> > I don't want to hold up the series so if you guys feel strongly, leave it
> > as-is. But this reads better to me.
>
> Let's keep things as-is for now.

It'd be nice to have an argument as to why (I did say if you guys had
strong opinions...), but never mind.

I had other feedback you need to address please, so you'll need a respin
anyway.

Thanks, Lorenzo

