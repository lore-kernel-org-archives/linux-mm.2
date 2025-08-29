Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1584CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 00:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46E698E000A; Thu, 28 Aug 2025 20:29:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41ED98E0001; Thu, 28 Aug 2025 20:29:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 298E28E000A; Thu, 28 Aug 2025 20:29:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15C838E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:29:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95119B9A07
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:29:47 +0000 (UTC)
X-FDA: 83827912014.13.135A8E1
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1AC07140011
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:29:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nhXSu7jG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fjTFsQtD;
	spf=pass (imf09.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756427384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7co799GYQ3s9+HiQt8B79X4fTR1elTZSB+dVFw5DFSo=;
	b=rZn6o1WYoOTQA3ymaDoKo7tfbqVtD/ZJzY3eaEgciPqDh0srh7++Exw4AZ9Ic+ls5dMAHd
	B6tmNRPfxRRKpI1hzNvIuSfcppByNU/BenfQASypXAYQ4cWh9D1+ewbmszUIqppfCr5/ia
	tiappzj0M20FCE7/dsz1CbtADa0DQOg=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nhXSu7jG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fjTFsQtD;
	spf=pass (imf09.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756427384; a=rsa-sha256;
	cv=pass;
	b=rTCC+Yc+6lHNwXjrYCxlDX5LBs7dS55Oc90SaEruWyVXeOp10GOoxAjbFPEDHP4GyiQDI7
	iV86QP0yEd+hFWz4r1zprQVw27+vVgnPgXTG06JGtGNoMOSnHKrc5dVo/2pz125PeF7aTo
	aYj9BCt2nMd6BZE+p4rEHjClFWTGM3s=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SLUukF002663;
	Fri, 29 Aug 2025 00:29:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=7co799GYQ3s9+HiQt8
	B79X4fTR1elTZSB+dVFw5DFSo=; b=nhXSu7jGbosxkxu+IQu4UCahJ9IzdjNQXE
	ngdgWMX1039R9mMq/hF2KzYxv923b8l+lUBnwxFiIdipdLHdmofiEQXbwZrH1gBm
	5i+ht+eZ/avP+wds7VWOFORtpedC4DGBywSt8QIuera0u5+TqPM4JK4ZyGgVXN5l
	Hq7sC9o17c4sCuT8X7oS4kgdExSGRJzjDDN6kpd5XKaN+K7RCTWMuntUP/VH54x6
	Zr9Tt7z5b0Y/dEvsgvzPOuQWSUCWJc0w0QAW/C+fXgCo45kJ8OoCmA/cjkXTyd8h
	HlkQE/LmzEZAmox+ofgX5lV4YlpfQy1ay8QyKbQPw4vjxSx0V2Sw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q48espfh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 00:29:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SN6fX4004995;
	Fri, 29 Aug 2025 00:29:30 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43cnwnc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 00:29:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=alv0MLskOhFu1dTSbh4GAE1tnNMCO//0VTh4xRAYC2W0tJUzpIrnAO8+oPJmf0K/3bQxXO5VuvJiOqatTVExlRZQQ0AMF2+GLZnyOLMS7QhxNT1T6r2P42EBJ3Y74YbWAP0XPBqBO7B+Y6SbRVXU5eSRj1j1/Gn8aUGqz+UojX5JMQl61xjG1iVG9weS5jmHW7z28yhGj0vMPMswsAu2m1XRf/5ePgNpbYe2K40K/CxsDpBYbrfRhuM2+EnLUanBFrGoks3lgUkh7fR6FPJ49EK3jD65psTzpimVky0yjOGQzgPrCsCrTrGaKIMu3PWQYoByfLHc1V+D05CRlIIH1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7co799GYQ3s9+HiQt8B79X4fTR1elTZSB+dVFw5DFSo=;
 b=kOU49YrstILTnh9rUbVic924GhxH5lgnJrKuxjtpDFSUdbt+PvZLTlkmpWrKp27Cgkbd4fpqYUx7iXBc2F3AOSVhNFD61E5OwY7XHA3MfV0YW00bg7VcZbPYLoo4aHG+VAeJFOE3rIVdkXwNE7RA476caVvscxdF6XzU50/HN2TUrsGqZ5QCSf+4JU5neLHHivIc9tJoOr4SYsR8dBcMzgVMzy/W3YnPox9/G8L14ajtPVjE6m9aBCRIczF4GM6txdjfNkot6E0EiZJ3GzgRuG1nqnxEeiuJssJJm+6lXHt02pdE3Uol/OFm9iXgT7If+ZEtWUOXO4M3WwqWxmT5Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7co799GYQ3s9+HiQt8B79X4fTR1elTZSB+dVFw5DFSo=;
 b=fjTFsQtDIxxcUM2SwsW1HDo9cxQ4ITURXwcSfCXF+hj1zwC1JJmNVLR7RQL7SxnmMZzj3w6RbEb0MCjdMTb2ZlcYAFlpsnc7FauEtkiDejkWwNKyG4OzS0+bJ+FTvhXtPwi3VZVUO1RSSD2lQwca+rUIOF3nXhtA0KQS6Fhaw+A=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH7PR10MB6481.namprd10.prod.outlook.com (2603:10b6:510:1ec::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Fri, 29 Aug
 2025 00:29:22 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 00:29:21 +0000
Date: Thu, 28 Aug 2025 20:29:12 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Shuah Khan <shuah@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brendan Jackman <jackmanb@google.com>,
        Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
        io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
        John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
        kvm@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mm@kvack.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Marco Elver <elver@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
        netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
        Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 05/36] wireguard: selftests: remove
 CONFIG_SPARSEMEM_VMEMMAP=y from qemu kernel config
Message-ID: <faqp5sdyrkcaatjsnvoxssck7l2qf2e7kivuepobmc5zdg4mnl@b5ie7764mkqi>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Shuah Khan <shuah@kernel.org>, Alexander Potapenko <glider@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Brendan Jackman <jackmanb@google.com>, 
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>, 
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	iommu@lists.linux.dev, io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>, 
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, 
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com, kvm@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org, 
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marco Elver <elver@google.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, 
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev, 
	Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org, 
	Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-6-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-6-david@redhat.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW4PR04CA0172.namprd04.prod.outlook.com
 (2603:10b6:303:85::27) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH7PR10MB6481:EE_
X-MS-Office365-Filtering-Correlation-Id: cde7407a-9262-45ae-453a-08dde693194d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rCTIcoIGcxsmdQiQZdSZki80GEYdQkG6vXkBErKdHFnT8WkPrpoj7RgIdn85?=
 =?us-ascii?Q?2T1YQQLbGN8Xo5CqM1JTphVorzyct3pzrgCqRKdXljpb60FDy8DnCYHX05KY?=
 =?us-ascii?Q?IPvHW1KYLbHv15yC3mGX4OYGjmQZ+zj1yZS01VY1zSUdh7d55113oP3JWzfH?=
 =?us-ascii?Q?TnfZJxT/UnL99JrHJLNYew4Ei48+BsY6vo6hcFiDO52bMqba/keF/qjx11DR?=
 =?us-ascii?Q?p+ZH2bz+fpAyDEJgYSUVCjHVf52RGfq/RDOafusCLMz23q9sWE5LKZ5BFS2X?=
 =?us-ascii?Q?MTSbluHnc4u8XhxAYGwmlHXqgne8+fFwd7V6Z9emVh127QX/rNS/BCmqDPxC?=
 =?us-ascii?Q?+p/XbBw3JivIAXddFB3PHxRw4aAAhtKqkKgy/o18+mvg/UkO+EoeOs6naagh?=
 =?us-ascii?Q?k1SME7QXdPmh2q9otLGlh7hHam320ohhUCfMxXE8eafN2uTVhMJjTm7FaUNB?=
 =?us-ascii?Q?PXI7T5upfH8MAXKjDyHHw5ugT4AaUWW6m5xeh4Pf1n7Onam1YaZ56yX0oeEq?=
 =?us-ascii?Q?UrWX6WZRk+0JEMbB+yQwAMzDTvKEIR18fayb+IpVsveYhy0T/LtIwrp5MYW9?=
 =?us-ascii?Q?Dosh9aJXmmcTYw4jTKh4eChIA2dgPtOXTcWcKlu5KkiukvYlrbvuJl/b4hUx?=
 =?us-ascii?Q?QafLrypII90eyBAs8BFX8J7GFh/UtNXMbDTt5D8UwoUpFuTug2CA5wgidY4T?=
 =?us-ascii?Q?D31v2lZqZuM/B2S33BoHCuXmoJour/+N5tL1grlCQJ/HEXIei/kFqMNB1GDM?=
 =?us-ascii?Q?tXOw6r5CyN1NoAwNLZlTwjh2fvbGF1dMTStyCrBVEaMsU2mC/gzxt6HiBnQM?=
 =?us-ascii?Q?KJfoAHhUmH+EUmfPDLwaGjgjQOdZ54ursjK+rQbQsJP16H4nTC/E02JbwC3T?=
 =?us-ascii?Q?Iq9KCYO9A2+5YAggrfZ+9hDyEVhFO2aHGYUH9T+H2n2/uNr3/Yr1MUWKejg3?=
 =?us-ascii?Q?zs6Iz8ezLHIa4bYyGMHNEg6TJ/vxrsFpWv0PKRJsR+myIn3IbSdb+qMB6xEF?=
 =?us-ascii?Q?TwoyChDnTKkpGJP94zw2TCLLYPz91j3tpFfIv17Ze7tsPhQL2+nAxrmkGvNJ?=
 =?us-ascii?Q?4BYmq5AWAFzI+EfYSKj0f1RanvJhRXRsNoD50rvv5zdPD2yqwQedK1v4FYlh?=
 =?us-ascii?Q?OdwhBLef/LcQyRlbu8/8npeIjj96spJ2EbOIGpca1CJ9iwDN3W6vFPPo5nEN?=
 =?us-ascii?Q?CO1d2FgKGpUPNLPmXoY0EVKzGxYori1AdxiIH7TuPMqZnHGG1J/+i9NR7ug+?=
 =?us-ascii?Q?Zqu86fYo70fsWRHXVQA6QqkT+o9rOjHOzwWlgHsX5Cdo5PRHnOO06UxumQeE?=
 =?us-ascii?Q?FxVLSm8EV2pQRLmjBc105XJTtwsnrsEIULHEJiKayzHY5DwMQQye393SEQl4?=
 =?us-ascii?Q?vducpUwMHYQKnLQxzsaw674GqMELxEzkWbs//hhpzhEofh9ZaA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yFy4+6XqsJ+IW7bVX9hEFhMg12KI54isEmcEcn2G2a1Z07+ju/NEKZutsk7K?=
 =?us-ascii?Q?QHSKWZ+aRdbFRJ/jUzDZcMAEXDG3Mrls8nEtGfeoXK7mZAEWNl9jl8N/FqgB?=
 =?us-ascii?Q?063lMa969WMGXP+Z3QkyDq+3KC+bjZKNHyHv2eOyC50O46Hmr5G4mbKOkE92?=
 =?us-ascii?Q?DMI2YAFo6f5GpkkEiIqfy0JyWfigDOQqAnr4jBZzBZbZm9ndzEhKC52JOPok?=
 =?us-ascii?Q?RVtpIwvEulvd9a4EVNe9FjRQAE8w1XWhsJCznAPtPbNL+/nVlIIQm/9gGpHW?=
 =?us-ascii?Q?a/jzIC4ji9PDVrWM9usz2wX8ErRd/YaUW0IG47AqTV4cLZwEh6SoMD7PnTer?=
 =?us-ascii?Q?fGoJs8aByY2d57ejiJJsSE/oXViSq5umKC5vxEH9IMXlsPJPR2lsWKP1IJ0f?=
 =?us-ascii?Q?vq1lVOqLee6lOrrSgIcIPYobztp/Kl++gVq40PzUs5UnEOx3dcQUuYcOjAWt?=
 =?us-ascii?Q?IabhmraGsI62/6NRLjJ5RNoKuuoChiTQJS9WmFVax48Euq37yJICGlhx3VRy?=
 =?us-ascii?Q?RkK0ZxYpfJ5Z/3sbeR5onL8BmGqvItHmsC9KRTXtc0hpna1uNPMK/mv1+MbJ?=
 =?us-ascii?Q?+OWIMT+fl/V1zcYNid5Ngv7g+zeHPF+h9+KlaZSk7JEVc01BydhYm847E/yq?=
 =?us-ascii?Q?PZwQ8XhWMcuJ+OBIZE9CoVQUtg/J3kgY4DXRoQWLyAUwpIr7WG/fmScPdEzh?=
 =?us-ascii?Q?C/8SxBNtJn5tD5oE1EAOlgvgB4aV4tMDWiMd73nx5Xi0MC5ndGr4AsRsWgOq?=
 =?us-ascii?Q?poizh5nYKWF1Xsu1DhI/QaZ7Xo7ipEbSNYv8bPrW0F8jXlsmIFf+4/gxh+LG?=
 =?us-ascii?Q?aNVJr/vblzFGbGve/l44Uz+Fvpq/DNdWSCrqqW39YOEo4OJnAEWhdRBzWO0Y?=
 =?us-ascii?Q?JiEr3bCSSvEaY2d9RLPQ0kOIe7wW4IJhGESB0j9GscEz1yYymCaXRoqJF+ts?=
 =?us-ascii?Q?dDn3ZO4QVauwwkqC3La1bhmbUO7yDU77BZfYp1xq7JjGWH1F/n38bXA+GvKd?=
 =?us-ascii?Q?RfMf1aecnf6m1qa9eAH9ETWZFRK767Zkb2JGDVuke6ZNgiPO4q3d41I5CG50?=
 =?us-ascii?Q?U3L8IPtCBcRr+scQX+wRklGk48tGJpiaQe8Ifh5FNnIzF9U3aXG8LzD6OzhQ?=
 =?us-ascii?Q?QEaT0HhtCWxXlYqPbHySP0O3cH6DS7OlPKtYGr/fYKPKLZxt+ZBRUM+sD7Qh?=
 =?us-ascii?Q?vqz6O6tmpVn58dufOJrt02J1RLSu7DoSRvrCLj1fdTMQNrGtXZV4jFOhU44G?=
 =?us-ascii?Q?6dp7GzMfN8NlVfL5tuAm/KsHoepLcy7g0s/gz7TgI0VWcmpO/IdecJ54eWBM?=
 =?us-ascii?Q?xTgy0AYYDSGTGc+uBdakI9PYjmptzUGXrrWYtcME/K5uDr0LJwiyYGzguAnD?=
 =?us-ascii?Q?Ouo+OXkcn6tQOBUsV1yOeTpnw5EDULhTiJIoMFkwibp18H/bWUQdt8ZnKpWM?=
 =?us-ascii?Q?FwhsTeOmd6HDNx59a2kIvrGYFrBZ39lZDJ46jSuoWByeOSdS3RZFuNyvPkdr?=
 =?us-ascii?Q?eg2qihkZ7RA8sxlXb0tvQTTJoZ0/kKx4jo/7nA8foxPwkgmthVKIWS7KMpI/?=
 =?us-ascii?Q?wjyfKHJeIsr5EpNPjSRS41+BS8tUcEYr8nlUjBfiJch5Pd8zL2CwKS8ZURXZ?=
 =?us-ascii?Q?sA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FgBTxNNJPuddJ5TX7T0qn+Sm1T1X8ikMwLPkPJWVf6rf+aTK3sVybk52zWqzIDsgztyLlASoicVM5erMu19+DstuXFizMReQaQ3gm0ErbU69ON+vduG6hbFmk2Uj1CZ5Bp5fs79FbhyS70AYKlMEK0JX4KNItOCcXt/GcXVmB6SjiplCu/G8tmtrkI/djNTV52092GBIsgfzqhqOZcJY8VWBX2iBiCilEWnU+0EUssdPAvteD8SZQLeTHLXrSHGwCml0rjBAf53pDHvC5KS6fklPbwura0TnSHCtc0oZ0UyvPTyVCkZRnrkBVRWdbUi8mpT+tjSD7s/uXUQak58fQQg5xmGijEQEfCL9JIM/ajvdMxtt+agCNywKGpRj5gHBJqZ7epjSwEmiRNmXv2kSqAEIQZpxX/1qF6VccnulkugYVCKDlPSUyC6SrBlg/imuh6qxgGzRktra6a4bqxrQjire4vO+1kpQdqFRRD97XVPDaZbt9yQzk2RTUqnFcjSIXvcFTO468KwSMWC7fs9rJAHkUpbuPYHBE1szIuHmrzaVSmrxaA0oYkZDBrH+ZF4SVGg9nwzmSREL8/4yKuucgclSqikLUe6T5jWV9XamIuA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cde7407a-9262-45ae-453a-08dde693194d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 00:29:21.8200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V9MmB6Lao6UPCh4P8OTAs3ObyvJnyn+uI2dfja5kJ8I244B+0icxOrY5Cr8fiAvtNJCz5ou9l/Co8UcCg4W5ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6481
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508290002
X-Proofpoint-GUID: i9eAXED2WWudCeVYHg1Avbk_R_mGcXuR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNCBTYWx0ZWRfX2akbItr/IGRd
 9ylyFRPDs2DGYA0VeNupiDhV/+HsP+oei0AzrLfowBT3zBAHOpRsWITS4v/I8pRBeTjU8WqrnEs
 mQDvOGAld6PhX6hf5kZ119KajKC823oUsEbHxna/AA/5iMaELDfDw1XL61g5/zoGgUWyJxRi6Xm
 rRH6GRI4WEc9huQbc+56I77vnwM76Fle/IHAcW5GEDYKMbZ6O407GtOFGMdxU0e6vYhzSDv2xLA
 Ri88nwKapKUkXr0cVaIeu4PPJqgG7oIejpJFZP3WJ+nGS2hU6wvch0RFOl7OQO1dPICDDky8pi4
 oAVkTkyWusMDN9WxpeOQkzlmR2cz0WUN8aoQ2WRzFQZIEXo14IGe1nPoxQxzrHv6ah1FGbXFQYQ
 xIxpyZNH
X-Authority-Analysis: v=2.4 cv=FtgF/3rq c=1 sm=1 tr=0 ts=68b0f46a b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
 a=UGG5zPGqAAAA:8 a=yPCof4ZbAAAA:8 a=S4hedQ7f9s0DpHPo1gAA:9 a=CjuIK1q_8ugA:10
 a=17ibUXfGiVyGqR_YBevW:22
X-Proofpoint-ORIG-GUID: i9eAXED2WWudCeVYHg1Avbk_R_mGcXuR
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1AC07140011
X-Stat-Signature: 3d46o17ycas1qqw1xugwcrkzxuwhkemx
X-Rspam-User: 
X-HE-Tag: 1756427383-447614
X-HE-Meta: U2FsdGVkX1+7CXmiJ9l+ZmIsVUKhh3ysWca8ivtMfvsjUuaZtnhwuCnu0IuLIB+qVs/uoN9S6S6+aMBQt32DtBdBkCJuJT/CoL0h84Y/uT5EYRG3R9ezVLyfu22xNfIixPsvuVIfhNE9m/nlGx2lO0IOCUSSQlKDGOomfdyAKRxTojY+N7vra1T8QBs4HtGOAS1kDLx3xeou1EQxPNhNUoze28cFISiQrv0J9LadbptZlTtz+h9Ue2I8eRlWwN/ELLPW7iavYie0Rp7xYGrcNDWTy1ZfS0+2hxNmvwYfzH/Sw7sL/fFVDZ9m5KlEy1WAR09buGrgkhfpbJgmvGfyR8ow4Fo1pgDH3LpXrZIuiCyYI8yzWCBJLaeYGqt4bWI8htc4ps1XI35oxatGuOn08eQLIH30/KnTbKghZ5a7IUMgIyS53V1UzyQ7mNBHTp5Hr0wEHroBnTW1nmnau/5X7E93yJLJLS5+Z263oOjcMb+aFnusd7QhuBP1QZN+oZMVsOUTSMzM6X7rVru+1Yxl1P8g0OEsML3I3XY2jZ2wSzTeVGR8Hx5woLoaqm8zHJ8Rd0quRljf5CodlWjX/UdzWLR0i9BGsTPsQ/E71OtOrTpzhV84ZnzpFDsWP2BE9NpNgK3AcqhsiEb8dfgDrvhkZk07YEkdO4hec6aoh2hIn5/RoUkk5VvRsuQXn1kgJMaoCI9JFgqeQ/R3yHbIUh8PjS+yrqZ/17m/Mz9aP+f7GYdGQAmYyAu5CtyBk8IgQw+7uz6oKRntMlJkaVHWq1EzYK2U9FwOayvE6sNVUEHH6pgs3UTG1PUlpAimQmP0RGT43c+xwBrrpETUpzPsodrzasUWxe9XZGqwIB0O+sg/dZaDRt63GpN3UJFGa3wrrnJH8IgQFSO4Kz9P5h8lHo+i0m082NwIXbWbevNVMEgWc8RUNVXsyo38SzKwu1sNHf6Ieh+LWchB0mQMFi//hve
 W653lZPc
 Yjm62+JcSnFA/fG/cjGSwCkfd9WB8Zn4w9OG55Eky2EKX4oo/gMt9jUHi6Yygh0jsE8DuEl/l7XsD9WS1x0CZFP5mFtkKm1IhGiLU39sNWa9UURYxa3azyZmDsqg9SokRUDebN6hVYYHnRXg8sxGx1SYlEX+X7s2nFvczBAGEOCutxkU71O9fzNZ2eoGYjk8toAZYwkdQZwbQVAs0FeYdp0K6n6FEj+poDrASxe6g/jyY6UJ/b9fvpBPvHHzjHDz6TAPLk/p9jhCG0c0ui5YlPHFZ0AbbjhO0no9X5szwDq+djpMcZwlplF5rVQbLVqfG0FDuP8gwUD5cLDd/wLqSszXftD3x6N/PQdIw9TyWP6f0mFvPOYATSQqJu/6L6GWSVaCee1S3WzOXuh3EnVjDoS59WBugUrQg/GeUeCzUwKRrQPuIiRDQcOuKbkFXjBS6RjYTxF0PATUypf2eOYzCd08IHftaP4PftnHcRmjGR4yDkowJ9eW/GXL3E/HME6iV0hOj9CGhoixDpJxfBKhE1xFoivcZnQIqS0AWlAl6hDHhT2RzmB6gM1Xa8ighv9D5SGONfmA23/lQuoA8adlZPDqGBAsF6jSMfNr1plcuzLFs9OEojMDcV5uyT9bF2iCWhhUpd4yHaw68pr7GpcTSEJ0q7/DyZaoMdUsIO8EC29oMYPNIDWskn5W1BCaGclRtjkl5Guj1aCiWvzl0f72aPoyIxQc/YDCmmkGVeEg4NAR7ryLI6RGn200H0AgjbjfFsYr/pnpgdCvc1AMLGxGsDYEDQOSHh5jAm21mNhqUFbbIyEkfuz6HiU6FtzdYTT71Cpt77qFqTpjfD1mHNy4lcA9lQA989gBQzI45ayp1KsJD9Ua2PvB0KDqjK2Db8AELOxEZn3YhpBj+LX8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* David Hildenbrand <david@redhat.com> [250827 18:04]:
> It's no longer user-selectable (and the default was already "y"), so
> let's just drop it.
> 
> It was never really relevant to the wireguard selftests either way.
> 
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  tools/testing/selftests/wireguard/qemu/kernel.config | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/wireguard/qemu/kernel.config b/tools/testing/selftests/wireguard/qemu/kernel.config
> index 0a5381717e9f4..1149289f4b30f 100644
> --- a/tools/testing/selftests/wireguard/qemu/kernel.config
> +++ b/tools/testing/selftests/wireguard/qemu/kernel.config
> @@ -48,7 +48,6 @@ CONFIG_JUMP_LABEL=y
>  CONFIG_FUTEX=y
>  CONFIG_SHMEM=y
>  CONFIG_SLUB=y
> -CONFIG_SPARSEMEM_VMEMMAP=y
>  CONFIG_SMP=y
>  CONFIG_SCHED_SMT=y
>  CONFIG_SCHED_MC=y
> -- 
> 2.50.1
> 
> 

