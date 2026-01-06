Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90F19CE9D42
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 15:04:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0684C6B0096; Tue,  6 Jan 2026 10:04:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03C6D6B0098; Tue,  6 Jan 2026 10:04:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E296A6B0099; Tue,  6 Jan 2026 10:04:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB0C26B0096
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:04:45 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C23A14023D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:04:45 +0000 (UTC)
X-FDA: 84301860930.28.8050CD4
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id EE0D712000D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:04:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GBC9Dt65;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="GnCI9rE/";
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767711882; a=rsa-sha256;
	cv=pass;
	b=Jq+psiljbbtomKu7uHXouqjVAVxR8GPig5+7KS1m0GS+lT7XfSSXpkItx/TQ6iaV+xrfxo
	7tEbwXb2Gk3ersfx3/J0wImomhngNHRlb9/WRDVFAASu4afteWZdriNyjxHW25dNt2gDNj
	lFa6AYfGwy3U/rIgwnlDa5Ewr39IbLg=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GBC9Dt65;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="GnCI9rE/";
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767711882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5dtcIDZ3/H/lKOuxHXVipZZfu1Wei+KtEqkdS3Zt/Uc=;
	b=m0dvvYBjb7+ArC/m9JOMl1v8r7xcoEJtTbwQml3CQH5k0n9vwF9weukIXYoVNGWZnhL70S
	cGcGtOvN8XGm/8HopK7wceGPsyAmFkpOKB5wrUFUzp+PDgVZwuy1RzMYJDIizxiklzBuC3
	zeC/mjsrDW3eUMUvx2PlLdFp9smbBwA=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606EZPXL3954363;
	Tue, 6 Jan 2026 15:04:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=5dtcIDZ3/H/lKOux
	HXVipZZfu1Wei+KtEqkdS3Zt/Uc=; b=GBC9Dt650zmDeGaGn9koTPQcrxFZpnrD
	OXXa3JKmaS76gseaSwZxnQkVxXO7WZ0MIXcLufZJZSuic+4faHZa3G6A1C7KYJI6
	qMgmg6aNN7A5D54PmPoLagyLY1bAqCV3m5N/fAC1dgGdn6UTt4RSxu66+wbkSwWV
	hVXMoUgbGK+azxfrGyJlEs75HhgImjDOcKmDijPY0zcGCflK5jBaZYI9oKv61bml
	7m0a274DcxeuXCiQlkLSMViI5awXHdWkwQkaHCy4Inosb17MYGelzDPGv8jEZJ4v
	XqB0uCwcrRdKXoLZAiO5AWft0KR5Bu+zRDrniU2QMmmVwSb5luUpgg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh49hg1rr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 15:04:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606Eecd7026350;
	Tue, 6 Jan 2026 15:04:36 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010001.outbound.protection.outlook.com [52.101.56.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjjy398-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 15:04:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nV9DUZOMbjLVdlcqe/mSbcKacS4927PHrxcElXkFLoa+m8f0aEnyTa8bfjE00WYL2sJnrZYv87XTnY09hNCE3DN7etpV5cn+u1fzxVDfkTHPGqC3OxE2U0SUrh+RL+ipSrBiyH2qCveZUzD5oJfJTrdzFadgglgnyXh2XeD8Q5/RTgPX/XdH5E6PAvaPgcUG/6bCbnDKaBNMfOx+nmTo10W/cVIGTrpRDukE3OlqVUARxIG1qFqRBRTfOe4DSQx5VwMSgOp5gzu48W6w+ihagOLVpXX/e4Qq8wNtEbnQUAOLRkO9Qot6cEMzrzb3BLJdJCvszkYX7YDq8Lgl9yJY9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5dtcIDZ3/H/lKOuxHXVipZZfu1Wei+KtEqkdS3Zt/Uc=;
 b=Xpd8oBLrAJrGuEPNCbhSNiikPHSSdDX3VMOYuDeBkfzd9wnyhiiBN7kmlfPr3H3JQ4Sdud9MSH+5Q7EHRBvUsAxg3lc9b5cur6x9WF7Izl7kLk2E03czcqCW5cII/YtTra9xM9Kig0wvzbid4N339gtllFrcWkBb7AWjinWVtUWWFiXYRXssdUMXBC7i9I/aY8L3Dtrcfbzzkt6NfKkNSDRz5NnCwXQpVijix3y/T6o5FuTnuTkY+pWX+U1V6mdlBUwhHZDGpi3sR3dY7A+pmRwdK36s6qdtMTaubf3kxhqmYxNBJfLy80wDUkJ5WaBOEo5fKdSDEwReTaqFMhiQjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dtcIDZ3/H/lKOuxHXVipZZfu1Wei+KtEqkdS3Zt/Uc=;
 b=GnCI9rE/4YmS22CK2+BAaGjjOq9WqEEI8LBtXa+KY1ZhGKMFVB6qnxr1GKY2m54wgMsvAof0s5D/EpyfvbRlP7jxJpNRfK8X6IUqr0ZHl1hDnXznDrqZxNxSQn90UhxEceDJ8Gf8HJa+CMN7miDskQiYD2+oTOcH/8hB/Z+Zofs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6039.namprd10.prod.outlook.com (2603:10b6:8:b7::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1; Tue, 6 Jan 2026 15:04:34 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 15:04:32 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/8] mm: clean up anon_vma implementation
Date: Tue,  6 Jan 2026 15:04:25 +0000
Message-ID: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0652.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6039:EE_
X-MS-Office365-Filtering-Correlation-Id: 1efbaf21-f39c-4955-e903-08de4d34e616
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xmrQo4DRVDwsLvHVy+hYta4GlHcFFthcHp35h+h+d5V3ANjZgABPO9eCCopy?=
 =?us-ascii?Q?kvMlwFBXo6z6RT2Vq9Enke14hHIf2qO9zGvmAW1rRaUx0XC/30EQ2TcG1wCb?=
 =?us-ascii?Q?Myt8LE6L2nS5sf7IJ6xFMKuIiNsjxrXUcE7vK5bYCg+7WroU1UZZAvYooto4?=
 =?us-ascii?Q?ho66fOZ3afrO88Ogvsa+ktsGxmG5BmsRdGaimA8GHj85elOI7pw4Qn/NuSCA?=
 =?us-ascii?Q?VIUwuIwhEr3lLVwgcLuCOqpcaQVhptGAdiAN+8v5P+ve5US4CsaEwn7mO5fy?=
 =?us-ascii?Q?OuIjvn7t5OmhowlOPi1ZF1nePmnK8hV18mOlS9nC5+4uxw/I+uD3x7cJek0S?=
 =?us-ascii?Q?JJJW//PZR8midu3A8ZiTUmO7lHQI+hZcR/txAlG4mZ0fh3H6oT70Qnx00yek?=
 =?us-ascii?Q?uTjhFs+S8Y1AigJm71b29VaQTbaA5bbM6XakiSSzl52ZYwwtNlmAZpGyFNTP?=
 =?us-ascii?Q?9DwL6P+iXu3rVrnGrZp02kprCTFVpyZmXpzbAvsue6rQOHKwHOlYiBlOKArm?=
 =?us-ascii?Q?Uqgwe7RW5rotVze/TaqBV+HBFjVB6Cqacjwbv3MwNXpQDzPWsU+HRiiRoDZy?=
 =?us-ascii?Q?BaWgoQSMm0U0TPDuCkzdTZIuilYrtCCDAa1LFQ+CPI+thADmOwH45c7xH7nG?=
 =?us-ascii?Q?/396gcnNrfKhtccJgE/hWYgyiHa89wVPeTXa8Fc4UbCdoFGiAl4+zzFn0nIN?=
 =?us-ascii?Q?roYpEdB+E/avQWBottTjBCnWUk1VYrhSFvRp9ONFUgeVHMlN28cmpX+UpsQF?=
 =?us-ascii?Q?3yoPLaoLj2lPmQi2YI4yDIrgM5LCooXwIlOTnfhhCKXoGUb8OZLb4/Buem1z?=
 =?us-ascii?Q?JkD20QGLr62DlZV8UgTD+tlBLEPKOiOYOBtL1hjKxlnKzjrvSw33cLGj1GL9?=
 =?us-ascii?Q?+y+smSgPT2FZUaIIYIiCTBhN1NoKWpqXQ0ZQsUme3yDzAjXUDt8gTae1z9Zn?=
 =?us-ascii?Q?Md6HE/GFgqLeClweoFE/U0sSaUjNWalrXBuBKowKn+3PBsH0Nvi8WgkEpRwU?=
 =?us-ascii?Q?2MXRU0D/ObzN1r/+TeVSlT+PCMwyvpdzyRT3TKX9K8ut55LotUjbzxVeCCj4?=
 =?us-ascii?Q?V/SKmdlTjMz5jWWVXxGy5WlSxlT4VoIG/AYUkE13/kLs9EB5bMN56RmboNIe?=
 =?us-ascii?Q?ZwzAyXls17vddhSg1jviUE8goSQJqS/pwk93dPwFe/1cIGGfVkSq6xhXdVqV?=
 =?us-ascii?Q?eor8yJct5VAJBf/pS+f4zHC0ZJKZcwp1Cl7z4EfXbMoSUZNJlDnCxBMKzQTj?=
 =?us-ascii?Q?y1YqoLxxLmQU/XReMsiO1Z83OgF5OhkLKENJc0EJrRAIp4u35cbbYFKP2mvK?=
 =?us-ascii?Q?3BCk9OkdB1O8cgivHYEqc3FMFNvrYCiUV348C8EmDp3CvUCHKiJlDxHds8V9?=
 =?us-ascii?Q?ChluVr61llVstKoZKMaA9KP9hy04r0qYEHW8bA03zacflftokHKCZZbhz3Co?=
 =?us-ascii?Q?Ic8/ob6dKcQADDK6n18rHggHvXf6H8NFHhIin3XZPXuqs5akxdJrbw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QRNf4+lVPcO52c3nNzLq+KSiQfqLQt7L/ETCznWatLhwKMAfmtJAefqpfN/3?=
 =?us-ascii?Q?RfRY0/ryS4oPsVcDv5cj6/+xHtzK7yBiASQBZMiH0z53aHHTB7EVipcWsPA2?=
 =?us-ascii?Q?QD8edaGxyotn7kY/RLqO9MeDqbfeIlQ1uGXYMY5oZ1DV+OZadj/644dwu1R1?=
 =?us-ascii?Q?DiTmW2zM+v+HwFhYZ00xSkMaWS/N0p3VeXN57Y6egbx8MHwA2PeavkbqiKv5?=
 =?us-ascii?Q?vcu0WdJ92t8YR+A/q6BU5cdRKIveJMhrHU7zcrGRnH2Kj5Td+pl5QMpOaCWY?=
 =?us-ascii?Q?Y4vor97e4O49gAHGksFnW6s/jgixRN2hm+0x6X8CE9cYsMJ5pCQS49uQg1Nb?=
 =?us-ascii?Q?ljzy6aQtGq08geYL+NSRMaYaTLbsyi7YZgUiBY7n4r8EDIRo5qqCIO3fiqeQ?=
 =?us-ascii?Q?DQPwhO/8MmfwZ52WWNyZkZFmmUfLVBMlWEBOBdmCRr5qgGqjcPZC3Q0/cLmT?=
 =?us-ascii?Q?uFevTgXhLberjTgWGSZJV0D4azkf8LOZsusQdhC2/pRH+WV4EL59yryLGghk?=
 =?us-ascii?Q?yyF3Y9ClI465BJsceiJtYl7bKjKVZAXoC7rzrM4uM3Okst1n+yldyEhNxKLV?=
 =?us-ascii?Q?AACH0S9iamm+UUkO0bHKnpJhI3wezmMmsZJnjLghFGOT59qb3J+jiA9JNg43?=
 =?us-ascii?Q?3XBE1HHInsbHik62VdkB//lv8k+XK2IKu6AXnoKjxii+S1mQzlz31zdamN/4?=
 =?us-ascii?Q?vU6pXM6wObgRSYB2ZYIokajy0DiD4Wv7yJJ4u9vWo/V1JVol50toyQ/7l2R7?=
 =?us-ascii?Q?XJFxmi9X9JO78b1wl4WfEgO4n/wGRJ/IucnzAk9uEj7zgJHV1IENH6XU20qn?=
 =?us-ascii?Q?P5YcXc4brdIbAacJA4bq9cg7HNOI6j6p6cf3RPS7pwRQ2TEmm2YxIgLw3/wn?=
 =?us-ascii?Q?SABrVpQBRGu6kiOGbCgXgpRZ/c7k8Hk5IjLwIhDPhmoI+8auV93YQZ3YtzTm?=
 =?us-ascii?Q?ORQKii8zuDLwK9HL0Eb4kisWU3+GyD+BjuNDhsDiJNPl82zcsxXThrJ33AEG?=
 =?us-ascii?Q?GavucP4kOcvxwgxRKTlQbwUwSsF3IYuyZ/ZfMZSj6DxSwfZtyYUto4TgUb+K?=
 =?us-ascii?Q?enVlPxrd0+nZ79pVXDGBF8kfdsmri4KVsGpYEPY3kwy6cMvxAH97ZDXdxjyy?=
 =?us-ascii?Q?CLdyT07TH8rrxbjc8bnnPs9ivla/u2WJTt38Xwdkpsv1IBwqC4y2/P1m9Zq0?=
 =?us-ascii?Q?Gz5BC5ROh1o7SUdrEVkmFXgbFdvSQiHkzAh4m4f1Calya3kI+Jz1vGs5CPR2?=
 =?us-ascii?Q?IewAX/Pw2o1YGXeAiInjE/OV5NtLcwb7dQSXpqr9k/0zuksID8IYiPwEwdpu?=
 =?us-ascii?Q?WYJ8x9E/tWwuh1fW51g/CaBEhP+FJszqWYmdSm7eptC9OB7Pq4WMyJfS3q95?=
 =?us-ascii?Q?2H1l1RyYX+XeWlk7THy6fW9K/QVzFGigr5/Tw+XImUqkDiXlY2XOmqatOtPV?=
 =?us-ascii?Q?rwzLFx0/LO1JkroJ7dH2W2vW0E1C/Lyho/ywhRoV+W2tPR4JrRsDJ7WEVncC?=
 =?us-ascii?Q?DjlGSNoKWtqJpxlwqkSu1fujRuVc2e6LOmeLPt+Po851cN5u+dnEGqyM8Ixy?=
 =?us-ascii?Q?yjuDzbc0TfJATEBNTA/7vsZFL8mkmHBApi7WrWqcm1rcys1HUtarAaozgSpU?=
 =?us-ascii?Q?8kleEe/9miXmURWAN+kvwm05Zim7m7qI5+ZDLtJbc96I/HtoKWhVY9uaJzOK?=
 =?us-ascii?Q?LLsJ3IzJkn0h8BEQZZwZ5YSyCGTHbnKx+PuVQa0RGjzHtlhrvRoDs5J22i73?=
 =?us-ascii?Q?TIvw5VLHyDiO6KB5ELUMCoDdNbEdSj4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	e0yFV3uVybE4iJQOepSpcGWcMKXfxt5HYZaXEXF+ZLWpY7bA6kHQHplTj6U2VbGDp3k/0CUXkVNTvryFY+x8dui3syhVrKtWDg0UXIKmhuECBDmj3xWkaOEKXJn9P1EBfVVDNYObfas8ptB4O1P06h9yD3i7VPsVRleiOwUWM7Vcbx1vshb70hpVA2moEnF2s45WDZs9MoKMhepbucUJvJgA0/cTiQC+8XBaZPGdaVsmG5dgjFz8a3+dWPzVlc8ooXqhWbD+1gs+meAbIuIdF9SKeTAnHXXJzfWWwepZ9dgZ7eDE7b6AWSbZtPzRSrbAVZcjuU4O1xuxsY/wC32JmMpDrYYk4W6M9E+GQkdzGH/qXa7dGmtUyEI3jojZM3cQND0805f5lFJuKo6KsSSjGmPAT86OVmbwnF7MwmH3EPaD8EEMCSA5blO6XBrN8V5jv1FkuGLZi5cVRqOe/HhvaAfw54qS5i8Bs8nPX5sDD3koCHuR388sr/r+Xp5pziCqryMOpmZlxkHdtHmaEXZ9V40gt8XWacwSn84rfrPv2H9r6UA5jwXASpXNJsdlH6cDHdYwPQB2hT9AK0UKF4CcHT8pYLEZoedQm8kfJXS/AWw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1efbaf21-f39c-4955-e903-08de4d34e616
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 15:04:32.9192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ibOplmZN8AIUcO8uePv698GVsFdSBnhzZ2fLi1C8TqKVO10HZu3XNdilJih67P6I6ahOo5phpLKX90/SZzHfdj5DdnO1C74YNm7CcnSdRao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6039
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060131
X-Authority-Analysis: v=2.4 cv=WMByn3sR c=1 sm=1 tr=0 ts=695d2485 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=-42ZpbwsFlOO6XUma_gA:9 cc=ntf awl=host:12110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEzMSBTYWx0ZWRfX4qesowIMvucg
 KJI01JrQsfirVNBCiJBOuctrIFhab8I20UHa6kT4J/kgys9Kh49YyRiCWeFjwuEAydwhiJxKeRd
 WAowZoVkJrf+gOTpStAhNwZs0IsX5yRZGu7C6LYNPd+WBRdJggps9AFDoH8LTyWgJ0/FNjen91J
 Tu5U8TiuOuBdkX6ptDp6ShesoxCUK9DoORfZtTnH8KswQ8lGVfX6kXmFqtC2MTvEo2OT2gfLgVj
 qkrJQnJR4YPvxnR2cnKv79PpYDuMvni7lUKS40FYtHiDcEsXajT2ziUR3+IuuHVKFOs/EtvHevK
 bld1F+uI82TWzul69jBegwkIL6E/XM/1kJSvaFxPowR9/UJ2A9i4cQIe9Czgt8XmYVvJjjIcJI3
 CL23IkycL0jf6IckacByjlbhZdBeeoCXbYlBbEmVsQCzFjctQBBQkUmHYz6eMHqsd8Ne3j5hWR9
 mbtg+On+ZUGKuAGryPxyTU+CS5fuKujZFamuYRbY=
X-Proofpoint-ORIG-GUID: NUiEhwtJkrlu2qxNY-SjtIp_FUStr1E4
X-Proofpoint-GUID: NUiEhwtJkrlu2qxNY-SjtIp_FUStr1E4
X-Rspam-User: 
X-Rspamd-Queue-Id: EE0D712000D
X-Rspamd-Server: rspam04
X-Stat-Signature: 595kt863kbaot3nsfsda5ehzz79c5y3h
X-HE-Tag: 1767711881-129662
X-HE-Meta: U2FsdGVkX19X0Lb4G6LwH9XhI3Ta65iy1alKehMJHqFzZbHgRVpAZP9rfYpJ5cR2/CPyo3ZGDxsXJcyHoANhMDuNsggDQpRHh1NuO+z+k2ybJCHGiFPC5OfX7RPoexpKoFyVvYRWCIeLSVIiLupxgLcS+TSTcNvy2UoaTa4OJsLFIssmBHpCQtumGLogG59BgbQUI16QI2AOYf3IEDkM/8baQIbQGy239tR50MGlmbSYTRPgGy7EFyOjityk5E8bWweZ6c25KpQulgz6wBRu+QCK3kZSlkLwxRbdZzpNdi43WUUl6tdjNdOOqMEIce0aAP6V915s01Tbb0qTokrfkwUydS7ATqpF49FO7xut23vJWCCvy+E54V1hcRtuhB/kVNV2lFJnA2RorvoTUKZN/CVYv6077rb2ZKVHTP1pY6TQ89CUlGUGJxbcKSoUqZ3DH5Dl/Cq1OXwdEE8b681yhDJGwtqqJMOGB538xztFowSoGHtdl4Ll32lrGUZeATOtjqC6mQkMv0iqI1iq+tysaSkyWGzOqAzlcxIv3JOJvLicSqtKYO45QDntaVktASb5328L5iG9YSc2CCwuDU+HkjWlocmoczB0czevGwCTGaBzW1jvZbMEz7WDdZBDbJ0unN48ZgXBMPJGFeaNKfaVlStbNPGhK1wYkOkB9CYsO5+rgjsFftqHWQfMWOe9E2ajzGBkBaVCqDUzVDf2e0tcG0ppc0x1OowElQmUcAVBIXvJ+JhjLbfEDpolPGj32rmqm4qP97QqRQPjeIjfglFEqUsDz8t2aQde9ejamN5+njxqRJDJ79swJb2kbA0nqclkqLRjJ7fr32C/XA81cPbpu/DaXRGdS2wexn0/R7mVJyEqDnK+ieTa+MvyEkiZjFjZ6B0nuYJ9YpPq4YiVeEIXFx7L77+VED9ZVRX0bZeB+YPAVyaPHrx4tS1wOyO75/d/QWZ8w5JhZkLPj7kx9W0
 rE9ZvxAd
 El14eKHgbASkhnnrnipSJtUC51EYLO04AtnvPZXmOHpOWR6aAu0DQxKjsbyV4APGpQ7Q9Pq3tmNMFH7U9FAiz9lEqHfkt0Y5V4yjvrGa+GmldT687Iv39UuwLu4lTPxyVu6icDDtcNlTxk7AazEX+9BxOpAsx28XuJ/hps8o9rrwQBP9TzG/enOOGEG/Gyx+g10wd6LflnCgeuBkX53AoI5B208vvnLatPrT32bNoTivZXFsNuFFFEGXIlJD4iyXqWe1clSfHFZn2GIxvmg3ok+shtRgRh66aCYm/+XQctDZNULhjsPNtlcGCsxTM6DlYYX16eNN8LpYzHouvW5So4lGD3gsKa+9ZW0q88KWZhvcjZsOxkCjjeRjftm0YUdEOQRGQOl3WGz0Dl4nhBQ75EKIrs54S0iS4lJXQAjigNVeT8PuTy55NlBl+JjpvJ3lSqVt/VpSmCX6hcjCZPQPFTRSL/lxhu/C1Jpb0y/4zwfZxKoubRdbJjClp9M3bIkuQp92Oi4tyMIACPt84fd5DGSlXX9BabzjuRN5lKcMyFKqKku/C0wjMFndH4ZT9LfgIQKWp4C0+YaaRIRSN6SLXlvBaz5inIQXBd+s4NAhGCzXoz66kQWnhZKlC0iMamgg7lwmqWbGPMmg9I3OkWJrfE5ggNPsJgCCLZtsAqmov05sD1fs/J86BJvBS/p9Fo3VMMwSCRPpqEQQOgQOH0ugeR8AvzA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The anon_vma logic is hugely confusing and, much like a bundle of wires
entangled with one another, pulling on one thread seems only to lead to
more entanglement elsewhere.

There is a mish-mash of the core implementation, how that implementation is
invoked, how helper functions are invoked and concepts such as adjacent
anon_vma merge and anon_vma object reuse.

This series tries to improve the situation somewhat.

It starts by establishing some invariants in the core anon_vma_clone() and
unlink_anon_vmas() functions, largely expressed via VM_WARN_ON_ONCE()
asserts.

These act as some form of self-documentation as to the conditions we find
ourselves in when invoking these functions.

We also add kdoc comments for anon_vma_clone() and unlink_anon_vmas().

We then makes use of these known conditions to directly skip unfaulted VMAs
(rather than implicitly via an empty vma->anon_vma_chain list).

We remove the confusing anon_vma_merge() function (we already have a
concept of anon_vma merge in that we merge anon_vma's that would otherwise
be compatible except for attributes that mprotect() could change - which
anon_vma_merge() has nothing to do with).

We make the anon_vma functions internal to mm as they do not need to be
used by any other part of the kernel, which allows for future abstraction
without concern about this.

We then reduce the time over which we hold the anon rmap lock in
anon_vma_clone(), as it turns out we can allocate anon_vma_chain objects
without holding this lock, since the objects are not yet accessible from
the rmap.

This should reduce anon_vma lock contention.

This additionally allows us to remove a confusing GFP_NOWAIT, GFP_KERNEL
allocation fallback strategy.

Finally, we explicitly indicate which operation is being performed upon
anon_vma_clone(), and separate out fork-only logic to make it very clear
that anon_vma reuse only occurs on fork.


v2:
* Propagated tags (thanks all!)
* Corrected typo in 1/8 as per Suren.
* Updated commit message in 1/8 to clarify when we use a downgraded read
  lock in unlink_anon_vmas(), as per Suren.
* Updated !src->anon_vma no-op comment as per Suren.
* When anon_vma_clone() fails to allocate we have thus far been invoking
  unlink_anon_vmas() to clean up the partially set up VMA. However this
  means we have to account for this (likely impossible) scenario in the
  code and prevents further improvements. Resolve by adding a partial
  cleanup function specifically for this case.
* Fixed various other typos.
* Placed check_anon_vma_clone() before the !src->anon_vma check in
  anon_vma_clone() in 2/8 as per Suren.
* Retained !vma->anon_vma && !list_empty(&vma->anon_vma_chain) check on
  unlink_anon_vmas() as per Liam.
* Added comment about anon_vma's sharing same root in 3/8 as per Suren.
* Updated 7/8 to have cleanup_partial_anon_vmas() do even less - since we
  now allocate AVC's first before inserting into the interval tree we do
  not need to acquire the lock or do anything special here, just clean up
  the AVC's.
* Updated commit messages as necessary.
* Renamed find_reusable_anon_vma() to try_to_reuse_anon_vma() for clarity
  as per Suren.
* Added a new assert to check_anon_vma_clone() to make it clear that, when
  not forking, we expect dst->anon_vma to be set.
* Renamed vma to dst in try_to_reuse_anon_vma() to make it clear that we're
  checking/manipulating the destination VMA.

v1:
https://lore.kernel.org/all/cover.1765970117.git.lorenzo.stoakes@oracle.com/

Lorenzo Stoakes (8):
  mm/rmap: improve anon_vma_clone(), unlink_anon_vmas() comments, add
    asserts
  mm/rmap: skip unfaulted VMAs on anon_vma clone, unlink
  mm/rmap: remove unnecessary root lock dance in anon_vma clone, unmap
  mm/rmap: remove anon_vma_merge() function
  mm/rmap: make anon_vma functions internal
  mm/mmap_lock: add vma_is_attached() helper
  mm/rmap: allocate anon_vma_chain objects unlocked when possible
  mm/rmap: separate out fork-only logic on anon_vma_clone()

 include/linux/mmap_lock.h        |   9 +-
 include/linux/rmap.h             |  67 --------
 mm/internal.h                    |  67 ++++++++
 mm/rmap.c                        | 271 ++++++++++++++++++++-----------
 mm/vma.c                         |   8 +-
 tools/testing/vma/vma_internal.h |  16 +-
 6 files changed, 264 insertions(+), 174 deletions(-)

--
2.52.0

