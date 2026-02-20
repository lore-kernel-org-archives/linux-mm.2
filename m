Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50ACCC56205
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 15:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5726C6B0005; Fri, 20 Feb 2026 10:03:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53FDA6B0089; Fri, 20 Feb 2026 10:03:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CCEC6B008A; Fri, 20 Feb 2026 10:03:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0486B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:03:53 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 89C3D56EDA
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 15:03:52 +0000 (UTC)
X-FDA: 84465154704.15.B2AA64D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id E454B4001D
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 15:03:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="cx/07hcI";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Dv0qQI7y;
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771599829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zyO60CBvV4pK8grhIkDy12AeYTgNisQOjInp6Niy0hw=;
	b=BG5P4VvIHuqT7sLF8gSVtpTPJKQgCwSbjD4JVAifRBeezYn8qDGupLLfT6RF6mrr5DODQS
	fuKMWeiiELcU1Fq9ec6u3raRY2hIsBoMgIMHCDdIWYc7POyQAqYHCkqbwgw4CndqiniVht
	6l7AYLZexKLPOQ+PqvLX1LF8u+mbay4=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="cx/07hcI";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Dv0qQI7y;
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771599829; a=rsa-sha256;
	cv=pass;
	b=RieOkux11eQrfLwS0IXYrVclKervNWhQirVf16iaKmAJMwGVE3T1l4+JzWrUyXp3PEBTOX
	yYhqTl29R++YZmocrUkrPYZXhS7/eL0VoYFIrVHY6k1S8ekA2HGYepvCQpF9VGEVos2MOh
	7fArcPQBibOBqQ2JNRYIw9nHgAmIXF4=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61KDjQrB1575116;
	Fri, 20 Feb 2026 15:03:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=zyO60CBvV4pK8grhIk
	Dy12AeYTgNisQOjInp6Niy0hw=; b=cx/07hcIiMdNnBZb3G1XjNPLt3JQXQFj5f
	iMAaJiP8US5i1iwc7mo87Yy3M0GhS2m2o/dxvJ4XYB2qi23WeyCMwTJn42bYTJA+
	/mR9CzGoDxuBfOlIzCtcFeOSyW81MCVxjgXnR7jFHysHBwXMaShpLO5ePGVI4LZG
	FDW1XO9lcspdEI0/9LYT7PtwYRkqf6gc3BEGrEREIV2ETmWYB2g7rZqdtS+Q8qvw
	vXzm7VLwL3iq81r2UVWVo3O/as51AF0LuDCF0NP8/VlSt3wPRJOQ69qukQBK3JkB
	6ktQNaJmI1Bw45d7YWsUvkvFQ+MJuuf5vdq8wFKIN5u0+qvD7m5A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj0rheg0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Feb 2026 15:03:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61KEEZSu037241;
	Fri, 20 Feb 2026 15:03:38 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011046.outbound.protection.outlook.com [40.107.208.46])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ccb2bdb13-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Feb 2026 15:03:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AFYnfdf5Ny6PoCjgK7dxpImzwEQamq+z2rvDu8LmATh0TNLT64QiaGlEQ9WH38nuAvtLRcUkcVmJIm9UX3bOLcazSvtm+igxMjESwmg3DUU/KgQXnTdfXNwGrOlrienEn2uF6nIWKEfZJ7f1AYWOA3+/kjlAdF4Om6/u+kjWSiVoUYs4M16wiDOC5PFLtuKZZBy8yAGNIWPx0D3mLrlZcxWaaskxTmo6liacnMIo7ncUA7oYIj1/1vLAcvJCvisD0Z31IUwvNg3HmpRp5SaIND6CJAGSORq6YkNwv6bt+xMVYxWB+nOMjRDL6NeQ/5GPARvhO8+vSem2gOwiuMIHwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zyO60CBvV4pK8grhIkDy12AeYTgNisQOjInp6Niy0hw=;
 b=gbRbJnfr0O3PdAKTPhj9M3m7f8JUBt40xWSTJOQbAlN7zR6vTPuphzFaAeHKG9+EhTeOegqwC0kPeBh2PcrSx2FlaVJW1ihlNP1FCaf4I03bVeb7kkiT2FEq0sJ9e0PILIppcgW1d/ygY7XwSNCYLHRGCAgJ6/OelMti1xDTEMbn6Dr2VdZD8z3Y2kidsvOXxWWsk1GF4rRqFZBPoYfP+I+yCnobnoLf6e1g8Vu9t8F98notTcUT+I4dxCQ9Et3TnLRXxzr4SzwqwD7CjeFwy4IsiXHiEEdGR5m9AcglBvf7NyvDM9c45wZ68ufmhTISZpGm5jXyXhIarQ6PEwhbPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zyO60CBvV4pK8grhIkDy12AeYTgNisQOjInp6Niy0hw=;
 b=Dv0qQI7yx5pevXh4HKo56PtU1+zxDBwkFTMFIWw/oeHHIzXb0ETgSuc/LUz/QzckUs3wSU9sLw7T6xRZGtFfYRE/JArRQh+h0Z4iY1CrUEHSQ29VEDf1d+YVDUS0ao9WBTg37kMosy3bUOyVFeMvmkcAgfc21XzDF15HlnvQoS0=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CYYPR10MB7652.namprd10.prod.outlook.com (2603:10b6:930:bd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.16; Fri, 20 Feb
 2026 15:03:33 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9632.015; Fri, 20 Feb 2026
 15:03:32 +0000
Date: Fri, 20 Feb 2026 10:03:29 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org,
        David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Ryan Roberts <ryan.roberts@arm.com>,
        Harry Yoo <harry.yoo@oracle.com>, Rik van Riel <riel@surriel.com>,
        Jann Horn <jannh@google.com>, Chris Li <chriscli@google.com>,
        Barry Song <baohua@kernel.org>
Subject: Re: [LSM/MM/BPF TOPIC] The Future of the Anonymous Reverse Mapping
Message-ID: <4qkgoulknoxxkefxyrpnugwmpwbwh324pnnpy6hg2tkdh7lbkc@2i3ep6aoh2g5>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Ryan Roberts <ryan.roberts@arm.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Rik van Riel <riel@surriel.com>, Jann Horn <jannh@google.com>, Chris Li <chriscli@google.com>, 
	Barry Song <baohua@kernel.org>
References: <8aa41d47-ee41-4af1-a334-587a34fe865d@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8aa41d47-ee41-4af1-a334-587a34fe865d@lucifer.local>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0242.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10f::21) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CYYPR10MB7652:EE_
X-MS-Office365-Filtering-Correlation-Id: 24b3367f-76c7-4f92-51a7-08de709136bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?H12BNJsxxFlgpyINKsayHNG2nS2xiRdYRNtlzqkANReS59MmBJlOETEkpuru?=
 =?us-ascii?Q?sm8vmxXhtHwmXaGqmArPYWjLRxYP1QaBU2UUSbD5m8C1mxTrRaRZoARsgRP3?=
 =?us-ascii?Q?LIr6/hdbcA47ympkxg4Is1N2CnplBvw1D0M3+oxxiVTKn88YCnThpfQGmx+J?=
 =?us-ascii?Q?+I9YaeNv5MBX7SoyJDjzhi6kaf6cy3gFH18/uVa2HEyddb4rE1zks87M9uTu?=
 =?us-ascii?Q?uLReDs0ZqZndAqKe0w43DNz4/kVJWaNMFSttz99rCDjAFFedqLiC+pK/4Xte?=
 =?us-ascii?Q?j+neaZ4J3ox7BPhPFqm1XEKngZ4UDbCO0jshKYIKTbKIj73DEEPQ6M34Rw9v?=
 =?us-ascii?Q?40pZt20y4S0waIdm20ehD419k4Wv91NWUwRCSBEiToU/Zakw5ih8gDGfnJ0F?=
 =?us-ascii?Q?lpPzpuvnWqXmudtO9z/GP8Yf1IeQ/VtTWyEFHS1cvNZ/9k7n/U7G2pYSkPbs?=
 =?us-ascii?Q?ZnLQfErWWfWyXcTmueoA1R0sVrmQO1Y5JXcWWI9wfW2X2/Kc619oilylgBOZ?=
 =?us-ascii?Q?5Wd8Nz2R8SOA22sFcoHeO8p4pllo3Xkh3yinytNjb5PX/M1VHscxH3jCLUnj?=
 =?us-ascii?Q?UaVk64G87i3153lGU+CzE29fVmTf6u15aFqBhgDEattGpgL/pjDEZTvOuIpI?=
 =?us-ascii?Q?JKzz0JkXr5TF2vFGwv+AYD5RRVFDvXINBRGY10GKufdKjVS1L2CkpjNPTtgz?=
 =?us-ascii?Q?MADETVLpsqHiMkoBVOPTqs0gBKKZbURkoVt8hkNbSM2+nv1j/MMVs6o3XjR0?=
 =?us-ascii?Q?Eapk4AKa4/CLxyllApzwRA3gz6ho32wogTj0G+Negzb3n+bClWsqgDsuYMaQ?=
 =?us-ascii?Q?5z9CVltF2tEMlqPIYAVaVShP/D54rbRxd3t3Ox7/nuXr3hn9MjX22fnQ0NoX?=
 =?us-ascii?Q?bM1kPy8I0PStHZQwOUkDGST1znPVumyJHl5S4FMx22RKha46NJ5OEDig7yuA?=
 =?us-ascii?Q?y9SbY9ndEVtZyW6u4L2ATl7S/67tp9DM5BRzlWgutaRYoDhnixRtNiQgZelI?=
 =?us-ascii?Q?WjCMqHcyZEBjsAzBBP+BQnEjIoKek3fAh7O4cmPdyEQV6mtCKlBNc+9sQBVy?=
 =?us-ascii?Q?H8AUVTVKNhw/qqnhhXXCPC0yARXDQTVbJahc97jkHf63JUIKMbvk/cnRFkb6?=
 =?us-ascii?Q?opZeRi/BJK9eIJueP1XfjAul0AcAUj+Kgf7QGBVueCB35bk0JsY9U2PV+dRt?=
 =?us-ascii?Q?JSSZxUfGG3r6lQwscvVtPG3KgO6ucJ9kIK9OCpn/RnR8AfDunaL+yVaKWwgX?=
 =?us-ascii?Q?S/xJX3oTCDHxWVlOk9I54kZiUZ2SsY9CrLcLlETJysm4++qsKa0Zo+VNFAyS?=
 =?us-ascii?Q?CkM97ZV6JZYVwzQrOvjuco6WKNJ+zo2L13wtQMgJYJFjfibs0N2dDhh2mTpC?=
 =?us-ascii?Q?FHkx8CICHuDOtdYW/x8h303zuyCUo3Dm3hBqRApW7CrkRTzs/ZFq1gBTEGmq?=
 =?us-ascii?Q?JBvH6CCrfVz0FvhUZbt0SxSC/g2Dwnv2sb+fr1+wbJ73j3b4aoR+ZJINrqrh?=
 =?us-ascii?Q?7rh+8rDVjJ0ZEysRNSc5qMy9G9eNMfA2TVntUYkkqbBw7laO8Z0MgsMeetec?=
 =?us-ascii?Q?Zib2cpk2IJzW5n+rt0EnH2W1opkNNl3sQNMSQHXm?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xeNneS1ocVuAf+d+kn3KvaHrKZAXl7Lj+5Oa31Cv0fnbKtpSA4KbFK/p14T/?=
 =?us-ascii?Q?hyQKhGCR7whbqcvBTOL/XkfGdPbsLJ0fUpiyEjM9c4IgUMLw8EiAHR6GQhOp?=
 =?us-ascii?Q?QwhLT2t7LO/E8xTMg0MBiDSza1BQXXbjn4XsRp21M9ji+M0NxAQSfVi+9hTa?=
 =?us-ascii?Q?N//vhDFcCTXb9gs6OH1NyybFieaEukM35y0UuHOIKDDQIRm8Z6KYOAF5e8+8?=
 =?us-ascii?Q?xqYSY2+eLqCFAYQkpTSoUxWwbNmEHVDIjbHQU6rBgQcir1KltK4aWXMqtrdg?=
 =?us-ascii?Q?dGrkZMQen9X/c03z75Ap4cTsgQ1kUm2fe35TN22RcqfrsG2QXJD3p6HOQvf2?=
 =?us-ascii?Q?SCcTDfC5GfLWwcLd2ZKMbyjgOe9nFkUOSWxMZ1aJwydR/F60A5sVYiQQFhlu?=
 =?us-ascii?Q?6Dqg7WTNTwy408NxeqKs0wveSbsQWkWAwGdEm643XuPsxyvvJueclgxivQVl?=
 =?us-ascii?Q?QvzYUseMPZFZU6jTFMS/kwR1zvsr6yiTDYz1yQnJZrPDWsZmfrC1lVPDfDxp?=
 =?us-ascii?Q?kP3ItaosY7uRfDAfr8mWcxAVQ6QRprcicMXlZUhftF59B2ZIbsd9eAiNXoj/?=
 =?us-ascii?Q?zu1WpIZynnOUJFzGEv/3uZGrrPUVmFp0SJR1NFqFXv/rknCEOU8q0hIdwOZX?=
 =?us-ascii?Q?bqrljhwe6SLUPEuxvCVNdr+ezOBg7vKr7w0wI/BNJ74RrrRNeIqzSrQ6Efy6?=
 =?us-ascii?Q?va8uWRf3HREpsFwoI7KOF6i6v8PeKNrMLa1bNZGagExufJBHw+Glt959bSEI?=
 =?us-ascii?Q?T+/karbJSJMKLOfTlMpzzI00vqDhReLoD574j3yzp5turdtGeZW/K3TxHUpW?=
 =?us-ascii?Q?qI7iE5xWOhkyPnb+8lq0DqmEk8rSZ8KEmSTXTzfbIRXRs21WvfBDF/XDN0Sa?=
 =?us-ascii?Q?tZERfd7hAcE74myjVlpOpdyoENhPmyHxz6rBk3K4NYX0yyKaDS0S/LR8Fq2b?=
 =?us-ascii?Q?NqqRShGYgqWdpYW5kwhKMDiiE8szpydjHxGaPBiKA2ilmlceytLssETVAA2b?=
 =?us-ascii?Q?5DapOKasefy9VvK/UqFTBTy7BOP9poN4uc7ggtikSyv2KSf+HTxJqYm7Jz9Y?=
 =?us-ascii?Q?asoYdTJcQgJlRkqVmAjLYnMqo197sAROdh2Cz/qinfKP9Av3tHTUQagSznO0?=
 =?us-ascii?Q?8QlLfO5+N5EzkeSQebg/zblXnGDpmyZO+ZCeVvwYuKy5vGUjt6FrEOzN5bWt?=
 =?us-ascii?Q?/Uhl2/6YqEQgtKtFoYNLO/6mRMWOyQY8DmUxJKHOFCXp3n36mK06syAyORbS?=
 =?us-ascii?Q?MV7drZKP2YZyGj15B+39JpvbpFjp22fWCyM6E3vvBXM9teUjRWNxmejJqC17?=
 =?us-ascii?Q?FQ66nAecFNamaMUdcJizyKb8FXZp1PNS5yPyXV9Ucko6X59hU8g1Ezl/t19C?=
 =?us-ascii?Q?DgCegXChcsuQsz/qXVzhXXd+DmlOch8baTPFp0TRKrnOgbXmaQ3El/sA6bk8?=
 =?us-ascii?Q?cdsieuczOTl0HqU59GuT7OA8Rd3kFhAHcmqQqAMYNLqN+bOvTEny0OAiQSm8?=
 =?us-ascii?Q?5Ey3AmPbfnIU1v0/YdzkxnrPuqFHR4/gSuJBJnTj9lnqFIiyVnJUeHqWoB9Y?=
 =?us-ascii?Q?glPi4kzZuvZ409jC4krvL03wEDaFppBwXiLuFOc2B4PFg94eJl5BOCEQRMby?=
 =?us-ascii?Q?487ugvqLcDvuzYtvTEHz8f5bGj+scfIZ1vv+QvceOZYmfw5P0p8b2xSllHdG?=
 =?us-ascii?Q?iovVvyiAT5fgJwOXmFXuT9Nf+Uq2loyTKISiKZitxSC4YZJNaOUle9Yz8pE3?=
 =?us-ascii?Q?InPYSlsIZg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SC3cRQREbIZB3j7DRYG/vhjdnz73U5Yj1GzxRwrLtqEYchXBphM7z3vr6fQlAS6NwlPQB7h8hba7AhxD7Tk2WeArwoNGKPpIzWrAOUX2/UzDsJXtLmXcRh1KablTFd+FgxbJZLi/32o3du33kAcvx4ZONH2dxfaqpAfMzkADsJGCuHHmej05YE0ETOB7S+Hp7fOIQoKdfkLDz7ZoUCXmFDyez6Nr7vSMTeuw1rGyGCqq5S//9npfmg0t3uRIy7Op2WKjtzusThNbPUWmxZ6JCg9fQjvxQTsk62HYOZ43dQ5LXIxa8dGO38/f2FU08xfAKOYuOknreXf5F7CxSsDlAkUC36N3i8yUA0D3OZ8GosriWXuoCD6bg0oe11s9tMrR/6ZpSqycRi6CoTWvZiFuMz17UC5O8I3UAG8phvGNexCjaNyDxIFDTpecFL6FsUFOxG6MyarYkCBIcDWElJofgjpiTkatlmsahgU6EydukOvRKo+A5W6nM3Csgpk1fzd+3myiIMxTotYfbM0ATSPCLm5dsmtQDA1c629Zvh309DjD9ZCOpJqIslWJPMc8mgVcydaheXDJNI00iKR6NK5mIofiNo6vAO4WSKqdcMYhd6g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24b3367f-76c7-4f92-51a7-08de709136bb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2026 15:03:32.6964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Z4sm7dhIuILUpqPHtnJ5AK+QYO51pB7okJdDfnsekhFv2+RsVsYJ+EkPkYmz9pTHxXNSNGUx0myHB1iTkBhUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-20_01,2026-02-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602200131
X-Authority-Analysis: v=2.4 cv=V6RwEOni c=1 sm=1 tr=0 ts=699877cb b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=9vaHkfgAfSuIQS-seTcA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12261
X-Proofpoint-ORIG-GUID: MWsjxYPcj3R22AolIKr37UlHfahU-TjU
X-Proofpoint-GUID: MWsjxYPcj3R22AolIKr37UlHfahU-TjU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIwMDEzMSBTYWx0ZWRfX+aMtVofta0SH
 kkwcqYH7w+3oJL8TdfousGaQUz7mzKebaHob3mmFDai2M6+WHlgTy5rf5axx1ILjQdX1+uybJ6X
 Z5mkRTQHxNsXBY52wKrvfcxC8Q/UUVS4Uzd7nXaxWgMMUPPQ5X37GV+EC+CCNDaIutHEEchFN/N
 OQKbhEtSaWM8Bq49L4rcwL5lWHpwG+9/HLL8DMQ8UzoaF0MhTNEMXCas0l3en7AxP6j18By5rpt
 bhfhSu8YvkbeWnRuyfDRJfuIzjX7bA7MLV/UGkkoInuLYHXVkGOs27L94r9ughHr9mVLxDWdPpa
 5N6h//hy2civPsik1SUTTcdF03B2FlqvbUT9eFWKlG37nTz3g+CuQe+jhwXaTKk6oR+9lgxciex
 /cMVEGpkLUWDfiMZ3OoR8aoRAGVpbtVfNBZ8eJFvSauT9gkJQHt+QNGCrDW4jKUyRKoJB59NEZ9
 2ICSZXdtrNCwCrVYO/V/fNpMRNqK/gS7EYyJfTC8=
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: E454B4001D
X-Stat-Signature: jwjxuy6p5cwxyriy4km8f4n7jon9erc8
X-HE-Tag: 1771599828-667490
X-HE-Meta: U2FsdGVkX1+nx8yC6HVDWB6iCiZ6YSHcnAM/sNASe39P3a5iBDpYpFYjSvR3/wZdrQnR7BXSzpCVCdNzAt3QAG8ZjVRNhVjEpqdsmENZ4bWFhvmxWjV5ickNHFVcJMnFAHriCULIIzTRYpVUylsh0vr9YiKsp7UGK4qbZ9Jmp5O0QEax3hFlZeswCntYl/bX0kiQ+KIFkW/q6sa8B1naxdml+8yef3RFC+7c+4/WW32BxNKi4La6BUAGkrK9yw7CCk5l6VmyK/V9/9z3cpfXCEXlVMPfNe41nNT2Ha904RCywknLEQQUp+pVbERrG8tDSWp14ILlqQNx9co4ufY2xz/V7pzSLUP/WJaEfGJjLztKkW9gFIUzAoBr2YoFfZkE2S6kNMVg5zEt/bxH0xqZYJmcitwm3kb/vdxmJQrdoWlQBVp0MeQEtClM+E/ut7T83hpQxzp6Io8VgqLrBUU2lawjXwn3PdLJl8wAMOdCqyiTFPcZZXyBceXNK4siApYw8JlQAIbRfZlqz/6pl6D/Zp9lvVlODmH3kkkdIk5rC6bulIVQXylpiTOQ5Wv3PMfx5+nPiERTBzuE1Rk1Zmkv6b0PqKzAUPgRrlemPHIEIY8Bs6bTGETtdb+4CqFew4H5VMrMSpISDuoYpWlavgpPCAiWSTiT4UV5FfWjy5LaKGmMLemuD5IyATL06/kquytIvLiyEr/czhLyMuhx5mPszn7p77AAGN2pUK9OGmrs+T4kt1i/gLkonDfJX1GWUtTewMpaQ/CyQO+iKzc4XgxbIh/MAwNYd7nXPtO8uXmal10LEZ2MFb6TjOdiqvvDYbIIre/SKHRSfzGscmnAaPIR36mtrtgf2b/kasqlX4Ik1VD+HWdGzUbOk1fEfO2iVNCvCR+GTItBPeFhR0+sUv5HdMni3s5w4hNN1Av0CiDNjMJvMvNvhyigNloIbpxaiFo0OBNKfaWO9mZIN16mG46
 ba+GIiY7
 SpaWGQShoqd7pdAs8I4ZvefKg7DMJb6WcV78JgsiCf8s8zDz6+cKxW27tzzDAfv9+quX6Xy5WXb5PrpYbHZsMe6KEoWf1irVgi1qiWG2gME9aerHLHQPsDIFkfB5nl4b2227awVRVqGog4b2JU8czCJPklBlgm/OhcHuOo21ncOIoozL5BMACW5MGH1rPU4v72F1+Ft/rLixdfgJNeg0KE7rFVlN7Ft4F2QulMS9ELHcTDQ3k0sGkdjoB4mNM4HMUIcjB7EHQ4hY27SgRAXAtsuGs+mDcoOxcM4oKTrnw9POXH3OtGe9y4NueCsifqDSnvb1jNC4BElDb6ejyQqdM7tDbxRzO7txb7GN/sQbnCw8iG0345YQbYMmOwLBzk0HgtJ8xwfCMnTN9vlWjFESnQd1j8fy/0kD6fFOOVU0BisGz8Ni8bNLRa8ihznWoXyYhsMJzh7U0Oq0+nICAzWZQSDPvvDV3tAQ71oN3F7NxH1U4GxxUwzSkxGQdQxGaLOgNDAMEJjLL7ee7p9shIQKN6r7ljkND7VkgL9gD2g1u77OSRVZeNSgyX6p/ZL1npQt0caVaUyGIB7XUtSp0WSKfDnU1yUl3farBRlSClJlAGsB+qgb/vL6722dCrVK7hZHcRbH/uEp2Txj31o6K11O8A1E3yjGAf/BQfLk87BsYTY6a2utpA1e8QaMvhdDF7Wu/v46TOjuc4NR/h364Fm8YxqE9vg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [260219 14:28]:
> Currently we track the reverse mapping between folios and VMAs at a VMA level,
> utilising a complicated and confusing combination of anon_vma objects and
> anon_vma_chain's linking them, which must be updated when VMAs are split,
> merged, remapped or forked.
> 
> It's further complicated by various optimisations intended to avoid scalability
> issues in locking and memory allocation.
> 
> I have done recent work to improve the situation [0] which has also lead to a
> reported improvement in lock scalability [1], but fundamentally the situation
> remains the same.
> 
> The logic is actually, when you think hard enough about it, is a fairly
> reasonable means of implementing the reverse mapping at a VMA level.
> 
> It is, however, a very broken abstraction as it stands. In order to work with
> the logic, you have to essentially keep a broad understanding of the entire
> implementation in your head at one time - that is, not much is really
> abstracted.
> 
> This results in confusion, mistakes, and bit rot. It's also very time-consuming
> to work with - personally I've gone to the lengths of writing a private set of
> slides for myself on the topic as a reminder each time I come back to it.
> 
> There are also issues with lock scalability - the use of interval trees to
> maintain a connection between an anon_vma and AVCs connected to VMAs requires
> that a lock must be held across the entire 'CoW hierarchy' of parent and child
> VMAs whenever performing an rmap walk or performing a merge, split, remap or
> fork.
> 
> This is because we tear down all interval tree mappings and reestablish them
> each time we might see changes in VMA geometry. This is an issue Barry Song
> identified as problematic in a real world use case [2].
> 
> So what do we do to improve the situation?
> 
> Recently I have been working on an experimental new approach to the anonymous
> reverse mapping, in which we instead track anonymous remaps, and then use the
> VMA's virtual page offset to locate VMAs from the folio.
> 
> I have got the implementation working to the point where it tracks the exact
> same VMAs as the anon_vma implementation, and it seems a lot of it can be done
> under RCU.
> 
> It avoids the need to maintain expensive mappings at a VMA level, though it
> incurs a cost in tracking remaps, and MAP_PRIVATE files are very much a TODO
> (they maintain a file vma->vm_pgoff, even when CoW'd, so the remap tracking is
> pretty sub-optimal).
> 
> I am investigating whether I can change how MAP_PRIVATE file-backed mappings
> work to avoid this issue, and will be developing tests to see how lock
> scalability, throughput and memory usage compare to the anon_vma approach under
> different workloads.
> 
> This experiment may or may not work out, either way it will be interesting to
> discuss it.

Discussing alternatives to the anon_vma and anon_vma_chain would be
interesting.

Just to clarify, this is to look at the complexity of the data
structures and not the locking, or both?

> 
> By the time LSF/MM comes around I may even have already decided on a different
> approach but that's what makes things interesting :)
> 
> [0]:https://lore.kernel.org/all/cover.1767711638.git.lorenzo.stoakes@oracle.com/
> [1]:https://lore.kernel.org/all/202602061747.855f053f-lkp@intel.com/
> [2]:https://lore.kernel.org/linux-mm/CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com/
> 
> Cheers, Lorenzo

