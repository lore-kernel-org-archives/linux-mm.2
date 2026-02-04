Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 002F0E95380
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 11:09:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 090E26B008A; Wed,  4 Feb 2026 06:09:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 061996B0092; Wed,  4 Feb 2026 06:09:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4D836B0093; Wed,  4 Feb 2026 06:09:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD2E46B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:09:06 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B324C2909
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:09:06 +0000 (UTC)
X-FDA: 84406502292.09.99CC627
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 439401A000F
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:09:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="eUrm/QoW";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=b4M9TKz3;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770203343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n+r9vsgZCU7Jlvwjv8S2ZLP5A6e9etDOA4B7my4rf7Q=;
	b=N7nnV9VJXFL6cxUJ7XC8gwf/UV70nN/xPJmaYyUysY+armKw5f3OB21OMWh4+XY8PWd+S3
	mE/C0xCdAMrepvyFBvWFJSfbg9C4uHTSd2ZJxcaJkm+KuE9DiQ7uO3GR3tIY30+RQCkaW5
	4M5H2j58WITGP7IkUm17INWzMdIqH2Q=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="eUrm/QoW";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=b4M9TKz3;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770203343; a=rsa-sha256;
	cv=pass;
	b=sX2fHJS5QHjJ3PZfsrANPaxhiEM8mcie7ja6+uUm44dKYIOPva6GARYs7cxZh0+qBNd1H5
	nABqAwzHaONBEPIF7sRO0U5FDecuRreiRDsxahoeUbkQIw3DbbQxf1ZrkRhpbv8coMLzbv
	zK7D+Fm96klBa9Dd1uxiSKQvWiGPLi4=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 614B11xx580155;
	Wed, 4 Feb 2026 11:08:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=n+r9vsgZCU7Jlvwjv8
	S2ZLP5A6e9etDOA4B7my4rf7Q=; b=eUrm/QoWFnWfPZkv7lcRyCESiStEPAWk6I
	qoi9vkFp5ZnQHPaTF6hjZlUoQRD9vCvtY9MVpa4kaFlE1su8ZtTDCOP2dsLCTeYs
	RLmEif+MXFGN6fxPg/TdLe8wPnauTQmI5GJlrZhHEu/GJ1AGXKD80pzeSG3LNUhD
	ewh9dLuleiL9nH9bvPZKpWVtORLMnPZ3ypbW0bvGJwDVODZSxUnzXiMMGvXDCpJ5
	f2XTMblPXvbkSzupBdKakGwRoqwcjrfOHiCPHNR9asX4q5BpsK7UVuu0zlBGia/g
	GJLd3h8hXAO5/ejXaOniwFLhZr3Jl/ow6H5seYsOEks54t8Rp1fA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3k5g1gkj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 11:08:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6149NhuC002352;
	Wed, 4 Feb 2026 11:08:55 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010007.outbound.protection.outlook.com [52.101.85.7])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186nt9ps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 11:08:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tET8sKUKvjKlXdRCe2cYHMWJnUTEutnAuUGm34jTPHCzE1TcngCtoRsJvfZ2oTm5y6XDca1a9TJKKLmm6J+W+8nqzaX/fbxcT2JnXcLrOmF0UeY3X3+9oQ5GEh+UNme38tks2fgXuyfS4xdCTaUKGEN2x8xZnw2Jwx4KlmEatI7y+fkSc/Moh9QQUw6jm9Gmg+7mso1tVOR7CdN4ac2m+R/XQXz2KsYsIIo3ABgDgRhnzv7a9eYczBN3Ar3SSWkdgqzfbWAu/GJZOPOnLcpx+a3InG9x9IE/vJDgdrbvAgCiWuBO6PEOwV4SN+TX/RXpOsbe2c7mRcG5B97QgWi9Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n+r9vsgZCU7Jlvwjv8S2ZLP5A6e9etDOA4B7my4rf7Q=;
 b=sCVtN8SZ0KUYgedwmxyBgB2UJn1hAN+uN+76Ig2bc0MiI5Npum8/4t0+qpGqA9vG0ZANRDTGUOoS3OO0aZG1lrgy9TAo3gLuirzwk138iGNxZfjytNpQqQfK3TDMnA8Dl6umrYQVZKh7X2G9BPLuDmtE55kp0WaSd9YPKclPDwiPCEyzAGmjQXoBl06+ra+8RTYsQ8Bil4RAScNufvV1wcJjcSy7T4aq4ix5hIH6T2DoJLRasj131sPWlpKQVjiaVo4f+miq1AAidkV1IwBQXhK1YJJTtPk3A7zda40b0S3d8HAoclSwphhBDVDOLRmq/ljI8R0x7VaLojt0O/4bEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+r9vsgZCU7Jlvwjv8S2ZLP5A6e9etDOA4B7my4rf7Q=;
 b=b4M9TKz3eHF8kq8SlJwBsHOtBwdghBQArsvlKzpImgkP4yE7fXLitxD2vsdQN9NB2NRvDLwmKnD4cU+pWqHaPOlC2QXjynruVMEqCxiii5z3dyoRhxPYzfAsW9WlV7frHNMypycU+AYM6eIjanksXSjj4jm/UdIRTf50eZfpUkc=
Received: from DS0PR10MB8223.namprd10.prod.outlook.com (2603:10b6:8:1ce::20)
 by IA3PR10MB8707.namprd10.prod.outlook.com (2603:10b6:208:571::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Wed, 4 Feb
 2026 11:08:51 +0000
Received: from DS0PR10MB8223.namprd10.prod.outlook.com
 ([fe80::b4a4:94e3:f0bc:f4c9]) by DS0PR10MB8223.namprd10.prod.outlook.com
 ([fe80::b4a4:94e3:f0bc:f4c9%5]) with mapi id 15.20.9520.006; Wed, 4 Feb 2026
 11:08:51 +0000
Date: Wed, 4 Feb 2026 11:08:51 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Usama Arif <usamaarif642@gmail.com>
Cc: ziy@nvidia.com, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
        hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
        kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
        baolin.wang@linux.alibaba.com, npache@redhat.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, vbabka@suse.cz,
        lance.yang@linux.dev, linux-kernel@vger.kernel.org,
        kernel-team@meta.com
Subject: Re: [RFC 00/12] mm: PUD (1GB) THP implementation
Message-ID: <b07a8d54-75f2-4d77-838a-7454ad559cd2@lucifer.local>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <e65bc740-8e20-452c-b66f-0e13cd4e9c59@lucifer.local>
 <2efaa5ed-bd09-41f0-9c07-5cd6cccc4595@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2efaa5ed-bd09-41f0-9c07-5cd6cccc4595@gmail.com>
X-ClientProxiedBy: LO2P265CA0501.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::8) To DS0PR10MB8223.namprd10.prod.outlook.com
 (2603:10b6:8:1ce::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB8223:EE_|IA3PR10MB8707:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e9470f1-4df8-4dbb-af02-08de63ddc733
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4ruQIJKejSEq00UONNq9R0K7hL7L0cLHP8afmjD62MmHzTd3UaCRrOvcvXDD?=
 =?us-ascii?Q?C9iMnbfUWqob8X3QkATldZhBVBX3jdUA2Jq71Mqiw8BbOW8ei2CvEO5yuA3t?=
 =?us-ascii?Q?lWS996VpXhIMfQsAnXcf3N/VRQQ3p9BVBRUxGRtQbatg+cUmLEcbjX4mNITF?=
 =?us-ascii?Q?0tWTph6K/RiRfNRAIiKP91h7iRxanF6TfkcJoITa7h0NQjeJGK72PKXMy0tV?=
 =?us-ascii?Q?Ftj6H6e0gYLxVK31MQIqQ4qPDG/fxBZNe+x+qZ7gCv/u019NgKYey8tCjonR?=
 =?us-ascii?Q?08bjP9IHC605zYCrqcekYngXvHZCotdrp/CssddkvK1IcV5viDmPVXOs2ft1?=
 =?us-ascii?Q?/4fQ6kzwZU9pOGQuf74kcOMc6WXiHZR53xhpv4ovIK30u7QMcHkNI4AphqwV?=
 =?us-ascii?Q?+zMqRWHSlX+aEWYgMgARfcO4NdZVCp2apHmh6WDs32fliEdWR+Cw6PTvQ7h6?=
 =?us-ascii?Q?3VfosAFkdUIqPNdwLu0JmWLzdtMZXlmGumUsZpSg+S5fQ5yd4SvWgLlzKqTn?=
 =?us-ascii?Q?3fPApjhzvsOJQjmvB5cCiAKuVA+Joo6rhL3/oBhG5pmEzH1Nml6JDH+vqpi/?=
 =?us-ascii?Q?6fSXbqevzpG3qlsbsI2TYQcJy+FBDP14jseYlwbozvfDuJXS2BR6GPRTlHo8?=
 =?us-ascii?Q?L1BRTak5f5t7n+EYDRGq+/WIYqEjmMv7z/fJoG8GG6bRuLhPSk/0yd19IWk3?=
 =?us-ascii?Q?pLocdbH4sU4nPqf63UDe7YJ4YKhdfn3iV/Yxf5qjYR3RRG8WaHMybccdaaQ9?=
 =?us-ascii?Q?6dPrjEs9I2r0a5QdMHv0KGM/K2KWRWEpZVEeUhiEEbETlix0EOQtffWkFWUe?=
 =?us-ascii?Q?eGB5Swru0xRbqemojzbQAVENAoist6hKM9TWnidFcdGWFGEwXPF3ZEd0dE3R?=
 =?us-ascii?Q?C8RnNEaK57cHO0klN0nzFG1ULxswjC8UHVfwCuvblAM1RMXWPMqCjdGxWcRF?=
 =?us-ascii?Q?SU5o6oQ6GU2upQa/VB7aQ6TXgckrBBZPL2a6wxZoDiPd/t+DH3WXWieGFKx2?=
 =?us-ascii?Q?V9yNiZCuUv/LG6mK4jwgRhVsIwOg36XlW5UjKRKEkT3FiHotQnuimPVEFBHh?=
 =?us-ascii?Q?iwk3HdJCvnjPeSxjR/NuQH1DO+dgszOjf7EhOp245UoZsXwm96Lo7zEp+Axa?=
 =?us-ascii?Q?XAmJZfLtJpVGeERFDm0Zky0e20M19tuDFV5O2eQwt2G4yULx4XvTbspmFj+H?=
 =?us-ascii?Q?fVBFvJtUKV8+1Jt31lFUqWT1odpBvf8f9ZddMIL/SC6CoSG7J0hdL8a81pQV?=
 =?us-ascii?Q?dhzjvxE57oDa3Ae2FRRHQgv4eFxAGa78IHsEaD1PFcZFB1zuK3bq+XqNek8V?=
 =?us-ascii?Q?MeTO/H1118K9cihG4hPkMx3Ucm9D/fpXoLRJwRsVDxSBUtAtADGU44F+KgG+?=
 =?us-ascii?Q?N+3W/IOPQE2gsUP+DYYtgUkWMJRR92GBXN5ckY2lkff7Z+Opv8WNXNrDWmgo?=
 =?us-ascii?Q?l7xGYlwTCllQWkwB5TwxSFrFf6gxF2pXvGbTW+AvQDnyXMaq8UNOzLdxUBIt?=
 =?us-ascii?Q?QUHMxfDEtGzgvRAFRkeGPWkpFF2UPishwPEj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB8223.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?51W7XBr2Ge1jHxB2tlCuWIP8mh8gc5WUvcfrJuVmSnoz2sIDjH8nLZInj/fb?=
 =?us-ascii?Q?XaBpW4OV5fKJ8r0i7g02TtKIQqCpk5Jg27FhuArcvLpTN2hR7gcKurv9Ocwh?=
 =?us-ascii?Q?ZJ6hOOUFm8zBXmV31WAFb5g5WVWYjPJR615G4jxMosBLMMGbjxMLpvNxRoiU?=
 =?us-ascii?Q?umwzQ1BcCBd6DlRCHvBsB2DsKPOdRigouKzhSZr1hPH9S7zH6apZGBuiUo/r?=
 =?us-ascii?Q?MPWwfmAwRKj4h+akHXoRCxRhVYEZx7gOcWGdzh51+9w7vRyAjTiSVO6oMrHS?=
 =?us-ascii?Q?pdml6jkH2U3wryrdVSQa9almJLti/xljrSp7pgau9iO1XqbGL3TN0rXw4H1G?=
 =?us-ascii?Q?wvcyfR++VdHBEJumlxIZAG5qX8LDGyI2D7tMeGOPP545OgvAYVojFK9ZV2Se?=
 =?us-ascii?Q?uyno+o9ap6KmVKijVHtg5dyVaUyOvO8jXRnyOtSvZXEg6tOZ0A7DL6KaKHpg?=
 =?us-ascii?Q?S/OqBpDLer7TPgj5rw4BUB+nCdlgF5r206y5k/tJ7MxqVDFhxZhh58PoyZOW?=
 =?us-ascii?Q?gIn4gUiInqr2lqBZD2MEVG06Y/UB8Ul3Z+ImqMfzrc1waNJNUpShZc6KLXcw?=
 =?us-ascii?Q?Q8GBtVadgaqHZNIE81wibSKyezdI5MBAAmKuygg2Jal6etjdDM8yBUOX6Q19?=
 =?us-ascii?Q?cmzgcippo4du32BfSjVDBam1rvB8h3WQ+tFUwalB8fprLOgNZsG4kpnY69Ia?=
 =?us-ascii?Q?X/R6mG3z2AlSPgRqRKgD2MsfLYj/LiZOlCnKALoxVhlNX5wfSF0p8l92+sbX?=
 =?us-ascii?Q?JU6Q8wrLM0QVzxjT79lbRdOgVCYtS07ihOXZzRfw7grroxCuivc1PQxLvoEe?=
 =?us-ascii?Q?ViiALyssLQ9y6inaHbcEa6leF99vaFtaezdxyO3kJs4U/vfAUdIScPA5jH/p?=
 =?us-ascii?Q?u1wu5y7s0GzPp9PkpnWwFgJFmFQyb1pVPs5Co0oTd4g1qiY483W/HBQF7FQP?=
 =?us-ascii?Q?jJD3E5jSE/dY7sQ1OcdUCR+ExXLK0aFtyoqQPobFKWb+ZeF1rvFElfp4aYpo?=
 =?us-ascii?Q?fHAC5lYk7J17Xx9GppE+BHsv0h41jzNx8tL9gxXaLcMwJ7buMDC/DhL8hqF9?=
 =?us-ascii?Q?S376G8UuX1YU5Q7/40ZNxOywWa3Z8KzhL/aSezGsjtzUMTKVEvhAaNsSr5D9?=
 =?us-ascii?Q?ikfoADpqT4bsejDt++JuWGLI1dtwAtNZKDJFto2D44fNxJMBS5y2D+t3xoea?=
 =?us-ascii?Q?1fpGK+W2r20YL29ljICChrrn/OmSQlmSor8hd2j2oOrAFjuDQpAwdpJyBhwT?=
 =?us-ascii?Q?W65KCZPO9Nz1IY1XJ6DQmubqKRH6r6EL7CubdJH0E+QX4E2DWtbhwYZHte3t?=
 =?us-ascii?Q?hGllSsNbBJNCzMCz5oaRgELgeFEQ/a31rt9iUw+7QhizjUc081Sdx3RGmiBd?=
 =?us-ascii?Q?Kln/8L4DoMsmnlU+INhdWwQRDcHmxg17JVJ4HwbwGQOJzshjDJgXSE+8A0HJ?=
 =?us-ascii?Q?m/BInjA0eRTExK7kxP0QPtzikeaXqM6D6MDRRvEMgYHZKrdSToSRTq4dnID9?=
 =?us-ascii?Q?riO+L7D+oHI2I2qH58lOFFfnC0CJb501dW+GzrD5vRop2H0Z0F12I99JHlXn?=
 =?us-ascii?Q?4KDG3QzVgmpSGr0p1wQInpvE+KE1KFd21D+qZVTmmnaSURTud+UylQ1yOFNj?=
 =?us-ascii?Q?hkJXc7EHsFwzImygyWC1hOYfarg8ZXBIFtRv57PidAVGTjOqQuDd2139G25i?=
 =?us-ascii?Q?LipUa/Mqu4b1k5UXtSLBBqhy8BycvRlRwBG0DslXYglXOENpwgYB+tUXdaFa?=
 =?us-ascii?Q?cS2n2+FEGBArmmV2HgoKJNq+lUFlUGk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dwp9XiPlkP6v6eaQhTxlRkhAcakOmKIx9xEXX4KVDHT4bZqw1FzdATYNxCP7912UyxgCtuGIZup6Nv+xAZuaggYSD4Qtqv1EpWI7Y1bz+eZY0kt2Hpwf4K90tGcHXc7pR05kjU+s5OyGrgrtUH32i9rDqNZVRnxRZ+jOE4cGL8V2XwQ2j7c6eXPxlfDTm+ZdPkqBc9c24WfQrK8Db6OPF0yiocMs7PRwtXh98AM4h9ZJwdZcNa58zdUU3jSU4FYE32qO+qxmcPDDNoOE1+oCuI8dTK2CMcYsshxJLeEeAfv9GK4qGiecjH04wXTFlRrxTO2wKp8BDNOAkIf3euIJ7MqCe/5YETS8/IhMKh4xLiZW2KFeJAFuH+tDkJYtRL3wH6tGBT8vi0sMdhJikvsG9s8jk4JoRHzN7wewx+ZWPybaDhpxagr2FjOOyhWRV1LC6/tl/Xuzj33PHxRnxIrDImINz4n8hL15Wro+9sEA0tLqOl66ZxTpT2tm4EZPo7cfZ7Z4UVuh8SjEmYgUnOu+IpaOJOKVUZL4ynakF5MII4xkGlr8hOlBU6ijr1VOb4DtKTZrJc7iWwEsRC8Jd420Ac7fXp18gHYwu8WPFvl8JFg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e9470f1-4df8-4dbb-af02-08de63ddc733
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB8223.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 11:08:51.6152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FqWqTFOtdvCt3rara6PFQYcdXzHN40G+KPW+nLBWvYFp5kZm2eptx2W5JH3EbH6cIrtYz6v+EeFq5+XESJWwWjh8nPT+lkTZ7WBfw6kgapU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8707
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_02,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602040084
X-Authority-Analysis: v=2.4 cv=Jor8bc4C c=1 sm=1 tr=0 ts=698328c8 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=CS22ST_NAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=Ikd4Dj_1AAAA:8
 a=QZ0Z86lmzTZcAOsB4NUA:9 a=CjuIK1q_8ugA:10 a=gc-ja-8jGzRqXEv0wHai:22 cc=ntf
 awl=host:12104
X-Proofpoint-ORIG-GUID: 7Nj0rJukRv_gvZl0GKnH-hbru_6LvZ8a
X-Proofpoint-GUID: 7Nj0rJukRv_gvZl0GKnH-hbru_6LvZ8a
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDA4NCBTYWx0ZWRfX0sgPh3I8pTFp
 smed3EG5xDljVUAkeuBJN0HBIGnoETV2J9xXB1fE/Sb15+Ukae0jlBRJh3kva9MQI3TJk9lSGKP
 SOlHR5/CYrcOfOq9JSN7wtTgO1c/fTYyrCmvityLC0qAzpxelLuHPn/OAyI6EAXki4xM6bevKcB
 3pEXgel0v3TUByK8OjTZQTYOBme7CvAFHhgRsRScTzGc29TI0qVXBM7IurQXE4JNVJF3cx9FSxy
 qurAo0tE/O6vH/5LfMivSVHvpBklb3GIPkvFXx2VLQyapHkAAU1+9rjF9O9iBWGIMPJWfJ3f7H4
 zh8RmUtJWCdaK28gERgk10EevFEnXwZ4SOghf0WTbYkdgdBYhhtge8SRNM9HXY/vz4iEuOWcwbP
 K1zNWEpuShC4g3HlBpmq1Ebtnjji0BM+xVihkjFiMuwHoBtHd35VcQcu/BbY3lB6BkfD5fi2Tqo
 QJzT+CRy8pXjaTBjCFH7IPIBAbMXuO+DHZTiDr5w=
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 439401A000F
X-Stat-Signature: o3dm8cmacupraqutrzmjeymuyirzu9ho
X-Rspam-User: 
X-HE-Tag: 1770203343-95326
X-HE-Meta: U2FsdGVkX1/2zl2TvTVlOrnijSg/YEpC7DTn41/VLjcGfX23x2RiNiCO3X6g1Y9ojo+2s+UaHoVDijMMeu873PUXH17xXIsB9qLQQLf5opJsnKWOTxR1BqNfMTIG/9my24VOgyQsP5WFsu0I9vv5tW8MgFah9ogOEpOVH8dSgVYD2/F088PuUph+5OlOD4G3DgHv2WXeOs06xgnJJ4dYe9+PBlPd1YLUlhDUeRgtzHn7IGxjQvHiBGmd5AhFlThnuq7Rt0chb6FRZuOOGTwxhiTe1SORr6BcZRxRDDjMH/uP4CF2nMd4Px9tPFL8PhUGFDe3MijULeR2TU6sKtotgDJhduULQhIlRPNdT9cY9VekSlQLTACrvNw2LM4fa7HAbXvo6SllBalyj3URuZOq9NTpVv5cAqOEwahD/to3xtCJPoMlKfdjpGfnl4kvr49ikHiKql6k1V/W4b7hcF2NXTqJfM1j7AannoD/aaSCiZo+lNL1bAZsprH2iWVAp/aY/SGjWSbAwN5skbo+gjrAIY7LnN173cpUKZJNUDKdeegpc4neLB8BuJ+YZjaEYMMlPa8Cc5KfOGP/mhGKmGMpBCnXmAayHdyl41/RWE1lyZXvtX/+/6z3zNViYWSl3IyU9fNQoiPvqOICBNnTqS5isMgCeKo1+2vMWSpWL/MlQxruqOUCHm6nrQdBAK0tXDKQGvMAo1D1LjYgSYkarTCnaID1gTp/UQ+6rzFteQBnBQebFE6bBaWuRFAXdlzQ4IkDEVLV0RO83/kfQbRcLqnMupDIT1gMalmDS9I/gIJGPnjGa7z448Wgls5YGUYMedFYPSbNU+jUm8cYZjekGFCKgeeYUXPV/yrMFRytBOKCQ9hVeea7zzLZ9XVYvIw8DjLz60FNcw0Uid9hZHej0RSrs7QM1f56JertgvIIhWLfIsXyN1GZW4EHNf246MhShYhVO5yZsmZGKvUqxpzltAb
 lJHvHQrR
 O0AN8CDi8mu9YRN8119sDF2bJGdxlswBwfCjUC7JUslv8YJg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 05:00:10PM -0800, Usama Arif wrote:
>
>
> On 02/02/2026 03:20, Lorenzo Stoakes wrote:
> > OK so this is somewhat unexpected :)
> >
> > It would have been nice to discuss it in the THP cabal or at a conference
> > etc. so we could discuss approaches ahead of time. Communication is important,
> > especially with major changes like this.
>
> Makes sense!
>
> >
> > And PUD THP is especially problematic in that it requires pages that the page
> > allocator can't give us, presumably you're doing something with CMA and... it's
> > a whole kettle of fish.
>
> So we dont need CMA. It helps ofcourse, but we don't *need* it.
> Its summarized in the first reply I gave to Zi in [1]:
>
> >
> > It's also complicated by the fact we _already_ support it in the DAX, VFIO cases
> > but it's kinda a weird sorta special case that we need to keep supporting.
> >
> > There's questions about how this will interact with khugepaged, MADV_COLLAPSE,
> > mTHP (and really I want to see Nico's series land before we really consider
> > this).
>
>
> So I have numbers and experiments for page faults which are in the cover letter,
> but not for khugepaged. I would be very surprised (although pleasently :)) if
> khugepaged by some magic finds 262144 pages that meets all the khugepaged requirements
> to collapse the page. In the basic infrastructure support which this series is adding,
> I want to keep khugepaged collapse disabled for 1G pages. This is also the initial
> approach that was taken in other mTHP sizes. We should go slow with 1G THPs.

Yes we definitely want to limit to page faults for now.

But keep in mind for that to be viable you'd surely need to update who gets
appropriate alignment in __get_unmapped_area()... not read through series far
enough to see so not sure if you update that though!

I guess that'd be the sanest place to start, if an allocation _size_ is aligned
1 GB, then align the unmapped area _address_ to 1 GB for maximum chance of 1 GB
fault-in.

Oh by the way I made some rough THP notes at
https://publish.obsidian.md/mm/Transparent+Huge+Pages+(THP) which are helpful
for reminding me about what does what where, useful for a top-down view of how
things are now.

>
> >
> > So overall, I want to be very cautious and SLOW here. So let's please not drop
> > the RFC tag until David and I are ok with that?
> >
> > Also the THP code base is in _dire_ need of rework, and I don't really want to
> > add major new features without us paying down some technical debt, to be honest.
> >
> > So let's proceed with caution, and treat this as a very early bit of
> > experimental code.
> >
> > Thanks, Lorenzo
>
> Ack, yeah so this is mainly an RFC to discuss what the major design choices will be.
> I got a kernel with selftests for allocation, memory integrity, fork, partial munmap,
> mprotect, reclaim and migration passing and am running them with DEBUG_VM to make sure
> we dont get the VM bugs/warnings and the numbers are good, so just wanted to share it
> upstream and get your opinions! Basically try and trigger a discussion similar to what
> Zi asked in [2]! And also if someone could point out if there is something fundamental
> we are missing in this series.

Well that's fair enough :)

But do come to a THP cabal so we can chat, face-to-face (ok, digital face to
digital face ;). It's usually a force-multiplier I find, esp. if multiple people
have input which I think is the case here. We're friendly :)

In any case, conversations are already kicking off so that's definitely positive!

I think we will definitely get there with this at _some point_ but I would urge
patience and also I really want to underline my desire for us in THP to start
paying down some of this technical debt.

I know people are already making efforts (Vernon, Luiz), and sorry that I've not
been great at review recently (should be gradually increasing over time), but I
feel that for large features to be added like this now we really do require some
refactoring work before we take it.

We definitely need to rebase this once Nico's series lands (should do next
cycle) and think about how it plays with this, I'm not sure if arm64 supports
mTHP between PMD and PUD size (Dev? Do you know?) so maybe that one is moot, but
in general want to make sure it plays nice.

>
> Thanks for the reviews! Really do apprecaite it!

No worries! :)

>
> [1] https://lore.kernel.org/all/20f92576-e932-435f-bb7b-de49eb84b012@gmail.com/#t
> [2] https://lore.kernel.org/all/3561FD10-664D-42AA-8351-DE7D8D49D42E@nvidia.com/

Cheers, Lorenzo

