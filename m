Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5E9ACCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 11:31:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C9088E00C6; Tue, 14 Oct 2025 07:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17A1E8E000D; Tue, 14 Oct 2025 07:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F356E8E00C6; Tue, 14 Oct 2025 07:31:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D64798E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:31:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E12711B024
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:31:39 +0000 (UTC)
X-FDA: 83996504718.23.2862F31
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2A55C180015
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:31:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ek2yTocv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=N3bvczj3;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760441496; a=rsa-sha256;
	cv=pass;
	b=O9WPno4LNtf6/4mayUddIwXLy+e/zXKuWlcsz2hqO6194FFLiWkJUBzIEjoj3XagZPbA3e
	2G8InMXVm34V0m9RkJwLsqHy8QSXIgvwYJLKatutJr1l0ghttNYE5vSldMvGm8MFLUw9GW
	P92Vtm/a6vxOi49YXoRvkPEf1XoA/hA=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ek2yTocv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=N3bvczj3;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760441496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ex8KgaZwzwZqKyNvm4GdZlZb4HLcsCNdNB9X7j3BMmY=;
	b=mlHDwovLwKcAcXr5aJpFcc7YNU73di5HSq0o0d8gzCMbP0N6w85dAazIXL4zWgLXDHSBwu
	/Cx85xIR71906uo9jmy1+NS0mSkwnREVkqxBVFxH0j18oFNKqcu3vPmfKPgl6Jr7mBDUh2
	7QUH+ob4uOBbQ1VKwMdvR6dG2xqkmi8=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59EB9ie8003656;
	Tue, 14 Oct 2025 11:31:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Ex8KgaZwzwZqKyNvm4
	GdZlZb4HLcsCNdNB9X7j3BMmY=; b=ek2yTocvzMDEIWZBE2bEg+XFadjkjTVF2I
	uDx0FqXpslDSBIYk2trj3ClL7Mk7uoxVNyP6K36k9ivfOOfxIrkQ1YGB/JLla1QJ
	ug68hf4/FeR7AB2BgKRKeimHFQGOUEw1lyy5ey6t0mMp/bYE4zJadEp6uUMW47xT
	S7cPJWW5ZYsqczfKqFsxqqSO/sNMcKzHn+otLR9gf4wpahhsHRInnvudgw3e/nlc
	i9JFgjtUaiOQgGJ8NXdOxT2A+SBfAOgIrdkh2Gy/zO9g51dBNRe7u9lKDAYZpGPl
	FLj1xoKRNaCcmbfh6UsDbTOfWE+xxLnHLBt8SsLdF7/0uhG7U+CA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qeusv2me-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 11:31:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59E9k1v7038325;
	Tue, 14 Oct 2025 11:31:27 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013065.outbound.protection.outlook.com [40.93.196.65])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpeu7hm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 11:31:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PcH8bgfNqcKLso5cd/jVYao0zm57HkkPNpNOnhyxNB7Rt+CK6H7/7kHUQdNnrq38K2fGisYCFKsRkWTp5EP9OtoubKXbKlrudatQwhqvENn1+Im8TWKqgyzGDfOnJ0OBbbuoAw/Lxr0MoznEmtKa/b3CQFdVccsm81s/x9oBLWH5kyVErpo+9iN7l3mEIWBwXPXphfn1LiA+mMPoLRKmd9GjLjSI1ni+a89uwkP84bODdbZQcw2l7zfa+KnegMZsw7gB5K+AFf2xNJ/jKP37qNAumqHNOaRLTVySgH5dqe6uDWJLFUX4v2RqHDO6RqLrh6QkngpYQ150xyTLraLNHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ex8KgaZwzwZqKyNvm4GdZlZb4HLcsCNdNB9X7j3BMmY=;
 b=vSMP/WVWx5Wg0qwGHPNUkSYh7yP1OR65kMZWrPV9qI7NghVp7fiemsaoL/bz2SW1fLxuvTJ1J6IWhASUcAnKhco2Z05Un0WOsyjmoUOVTFXLJYRfz9P0nIrlKfSG4VFZW61odRzVOfhkJj1llXIEtbdKjlXAAx3ej3lhQF5/gf05qQ+vLAVP6skKkQRj4QnvQWR0nXx3agtACJ5ddsXJhfW9Oa5hW9uktR6q4FfotHx4Wu+VNdXxVr/M/XP1bQTqvHIeOCH5+XTFJy2P5PL4/MoEyqVdRu/8RZ1yj7feYqMmHJRQTwRjb/j/cgGuJ4sURLiIWgf5TgtYXOzPeLj4Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ex8KgaZwzwZqKyNvm4GdZlZb4HLcsCNdNB9X7j3BMmY=;
 b=N3bvczj3SLyARAP7N37yUKA9aLuhkJAINSJ+pB1lW1+8o1MDssamzWdHxAxtCteTcYmQQ8Szu+AX/esAhfEBkZwFpWdyYMWTSV4MEQoOe1E/znNJ/LJAT3fZW68v322YWryf2pl24tzOt8HrzhgRFpsAYApttFZZUdRbfLpDK1U=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MN2PR10MB4173.namprd10.prod.outlook.com (2603:10b6:208:1d1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.9; Tue, 14 Oct
 2025 11:31:25 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 11:31:25 +0000
Date: Tue, 14 Oct 2025 12:31:21 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm: Consistently use current->mm in
 mm_get_unmapped_area()
Message-ID: <06121497-4f42-415f-baf0-8f02d4f31700@lucifer.local>
References: <20251003155306.2147572-1-ryan.roberts@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003155306.2147572-1-ryan.roberts@arm.com>
X-ClientProxiedBy: LO4P123CA0632.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MN2PR10MB4173:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dc8b6fe-566f-453d-a07b-08de0b15355f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ppyNWjAkkYaPtgJy+xk/XhIsrdEp/lFVJf0yr3wV0WCX1nAlyqQpxAM2k3Xc?=
 =?us-ascii?Q?53KZbI3+FyescZQ4xIXotc3QEJK5lf5QsGVyW0JvhtG90oaETsC70KE3mOp+?=
 =?us-ascii?Q?lku67FxdIEer4AKUaeUM/4M+gmUnXCmGvIbxMaqvcc/jONaDNrHF3BNV4mRd?=
 =?us-ascii?Q?R6zTHf+tKHiZDpcq+QHyvI5IU4pXXzzcUk9KxmRhULUQBrwlbMHy52AyeevL?=
 =?us-ascii?Q?lQG+KBqvJ2jWhtF9pB8qgaRIdLN58KUaFsTSfUFVq0Gs3azWoD0P8IXYgOVh?=
 =?us-ascii?Q?DsT1ArRGpiDmWuP399xuHeaFplR6WRZ2xEAn8XpZk6U3iTB4S626clgnH8jv?=
 =?us-ascii?Q?gVq+MK/i12RRNe2OJM2qBIM//wLZfgwHuW/qR87mNSrvWDERsAASLw4ahChm?=
 =?us-ascii?Q?gabDyM9+S0QE3MIMxZVW13Dwl0CNy6GEVITh9NtIujdWbAUuCbuSNgHnvwze?=
 =?us-ascii?Q?u61u3qzoRvC+yZjszMyyj2Q5r/ROdZ3s3ZcG7it+UYJR7UNz4Z5JWnKGdIfy?=
 =?us-ascii?Q?Us/mU46rujZnxT6UK+F8nOw2KWUUksOGI29JeQMr7tRMbBdGrz5aA6G14SWk?=
 =?us-ascii?Q?ekJgWNBwPR8wZe4Njpmeq7ygg6TumFgZHwlbI3dBy9ecQ6diUHaeSCNVw3ND?=
 =?us-ascii?Q?oR4AQxFR+WMfx8idzHTvkhZeeIfOzKC6puYUlzxF9SQO0u5FiEbGJIVT8fCC?=
 =?us-ascii?Q?JGnC29DIHQe68ahGwv2TsL4QlZle/13l2XL4s6ADiBNSIGbQgOaq1CAnGD6k?=
 =?us-ascii?Q?83VjuWv/dTfc3wTWocyJ6srFIRvTzR9AMWTQlp+c29gI3v+bZijFXocLwlFn?=
 =?us-ascii?Q?uZiF0ASnMUl6INAt7TdAqjPRb5Vut/eqkJ2cNfJ+67Ryv6e4hucqTJFnPgku?=
 =?us-ascii?Q?CT3v34gK4uRG4pNR8uySI7nqWSfdTDf6B/X0zmHJr7hgWl0gMr8Q8aDkV8wI?=
 =?us-ascii?Q?W9aA3iQEbwl3sXeH9IJkIH18nvkN8tPl21yH9zAjngWbr+RvZryBEZ/RnrLn?=
 =?us-ascii?Q?D6j039EFOud1E6AHdN3O5yp3aSqFU/bplGdLjnb5L/XaG/4RxQVmaSpOUbSx?=
 =?us-ascii?Q?Z3uw7G7zLHuvwjK3Tb2RrdOmvh6u5G6eJoDObNtydiXMkDuc24x6fgIWjItc?=
 =?us-ascii?Q?GxPd7XAhUlfto2NYkrF0X79bYS4qcIppw4bQcOFwU39YlqXrmiVxoxMBheOd?=
 =?us-ascii?Q?JuWqMsAUFBI5wcEb1eKfaxhIgR7KlAddHW7Gp/HHQXcEw2nz33NQYX3nTUjj?=
 =?us-ascii?Q?0EkHmYMOd0gYwpJCrINxYmBQu9TecxZqCxWC/asEUwA+EOs1uacSF/VDm/+f?=
 =?us-ascii?Q?Dot1TGrIrZKoWS4VMz/WqpNFNx9HcCU3KRrZ3iADni4Q8IWHkW5j1j+Bb+yV?=
 =?us-ascii?Q?mlsIjKjsUm5v02l7vNCl8+Jy+6lsP7DhReyOPxDk1Uu+h2nKMJNg/uKmOovi?=
 =?us-ascii?Q?v9g4SC4dwqsSq7djWSMf+HY18UrU6e0w?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?at863y9NhmkWWMe1VAZHXcxxzN/Exr4DGIJDQDhcOGZHsPUlO1IzJPyoZnsg?=
 =?us-ascii?Q?XniejQqNPbTPG5yXYBzj+nyPBIWBYpDjq6hnzT7to9BePVT4JGlMN4aE7PxZ?=
 =?us-ascii?Q?QHYhx6mOfIWlaIxWWDqa9a3pjZuVY7Zf3RC2BT1AE6VA2BXEBEaHBxJ9zLFN?=
 =?us-ascii?Q?Ea6YYL25Ym3c6WaTeFwngpkqNaF8VSpw8yDCUpUFv4Knfs+vKy2Fk+oKGHYZ?=
 =?us-ascii?Q?Yeq8heQMWmZ3pHuDIE6U/7kbg3DIsUUIQC2D0KmBNLBd4ZDzv9DQ6c974xf6?=
 =?us-ascii?Q?cJmnYa0T7jW95Xwl5a8EszlNgbfh9wZJbUwcHBZcwyvcLZXhBYkh1xqsWhNM?=
 =?us-ascii?Q?+8kDA2eeRFAr7rx9He3TAoTt5FiaSNxkHSBaQ5hcuTJjatoDUhfhOhddTDyF?=
 =?us-ascii?Q?A+m1s2yJ70q3UoZmjvpqPkETvSqdY0rMbbtB53QVQjuBzqqPtoNOCJnn1K7m?=
 =?us-ascii?Q?kyl8Rhwwu8AbS91elYpqbu7IggAF2ZImp9h4IxolQHD1dUFy5Ip3JSd18gfC?=
 =?us-ascii?Q?x4/8sIIT9zeyFvfr4KxYxv6wMiJ272UuA1GIcl+gUARbmFksBtLzgFSsAj7l?=
 =?us-ascii?Q?ujZqo2OYSIleXpcuVobnkpKH6xOtHUX4jE0+IUvd57/FMpyEiAXCHAXXvWIV?=
 =?us-ascii?Q?isk6nJpovqg33c6FyaeF5fuwxMryCNe14X58yMQA/Ri1WF8loET1/szEtuzQ?=
 =?us-ascii?Q?GvyDfa7ojLSiWtgnnPrvY9qd1PDCUWZTN1jATtyiItKpVj3HdRPMsAog2jnb?=
 =?us-ascii?Q?ZU9QQFQKCfsPoxgaYwBxc1m9vVft76tsF6t5Bh3Hs0RROybEvvvP6b+CSleL?=
 =?us-ascii?Q?AzQGg2OsEr53ldRuQigU7uPdhG1SLr0vAPE1ykGVlUWnetZO/kpCA5wbuDf7?=
 =?us-ascii?Q?VhltABMyY7RTQNHkkleQTp/Oc33lgcm/Uuth/wN9xTDIBYOtH8N6DyW+wsCS?=
 =?us-ascii?Q?zIYzAKs2VygLE9jp4Vl4vt1WfDTaQg7nspRv5pEaFA0GIj8AySkV8x73lyB3?=
 =?us-ascii?Q?9vcI3OMgaZyzYgXnPn4w3+pKVlSasALUOOOLG8FElGF3nBfpOT7Jq9gp/DKz?=
 =?us-ascii?Q?9R4hrqyzAqvi+uG2QyFzAJUr/ROR4ZVfEFeebXkz7KuDqNxGQxT1TEPSF1mI?=
 =?us-ascii?Q?XT96BKudCWzx9nyX0C/D/NUu+SgH2tDAp2viRzGeTX/85vkjKuqzhOlHoBbx?=
 =?us-ascii?Q?76HHn7FY1FEThjoUaQ1qan4BMvoSYe//f1xvUkc04h+FQqDtf694xXnXImue?=
 =?us-ascii?Q?a4kgiwjlOzh4rQ+k0Q/APGCLKNce6P1mgDbaHYbXlMlRa3rC+bILvgHy83TK?=
 =?us-ascii?Q?M0P7jQcGnHTqJRojFvltuHS1KT6jIwhhqAxTE2+AqHyoYD2CAriFGL78MB2L?=
 =?us-ascii?Q?tWfm6wIsAYqy8cnk4jwvsS8sIu/F8CqcU7NUHWP9/YL4m4VVPvyYaMovO98O?=
 =?us-ascii?Q?qBgKolciNbi1ooInj41OtSdXq2w23Ew2nWjfeSo2zxCmvsxtNuf/I8TJ+blA?=
 =?us-ascii?Q?Gp9xxbgnaz7vdIDt3wg52srTji+aKAar3fzSA+wgvbTiDiWOXJ3g3X8gusQz?=
 =?us-ascii?Q?TbjdDbxbg8mZBqk63f+qD3q65QnhFlozQO8IJaqGLr+gZO3lw/fj0lZgFjAD?=
 =?us-ascii?Q?Lw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qtHLJegALOgsZEEJa6xvbdNI8aMCsTKx0bKK0jGUC6YPNnSfGqHFTIzEjgnE0AvoaNXocMJcdfeSw9Zxk35r+M/fPh8ZJXPFDKmTA/FCcHb50UDK25FQa3JmqfjjFgNNAjyymP1QX7H4mw8+vxDjlTPuH7dUMBykUfYn/yO09XBFcPXrhbhrkCtez001Ze5Exb4h7GuX9GMxna9NLuq8g4wJidfqCm2W44NnmjVkavb6i0pnbhmfF8OLQKcFIqIBmWAz3ckiaQceHbx+wTqPYpNmuKEx6SXvpn5W57hgCKCeKsGHVywkmVMGyQYeoyRMfZu38+WuKrxzLcKsXD4WXQIff+3wPuZNqihe15AxNLlBdjMeXkUxhanpGamZO65ya41vfZoH5aJMpf0bnG+GP8f1fr+kzvAdGKJzQIfXrbmYnvHYUONVsphhz+469AtQV+GlJ1jTu09ua6h70LgQLu0I2aMUpZc0qt9zMNjH+MKLe8+ZhWhzx/HbeP9yXxv4syamQgmMgN9WVoktx2o3hqJXf9zkRvyQBlD0h/B0eVNIzW4YOkiXk0KQEL/9X+Y0bG/CJBD7ubAH9odxRnYy26AYtSxTq+G4fS8ST5EZgy0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dc8b6fe-566f-453d-a07b-08de0b15355f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 11:31:25.2519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p9KDD/ZNrDvvPihAET4WJ1zPJFrxD2oD+HNLcPFeznHcMEWpk0bMztico4v/tD9S/PYrwwxSdpf+PkeTFCZ+O99k7GXocP58iJVzWOdHo3s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4173
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510140090
X-Proofpoint-ORIG-GUID: mxfHpHhmv8syU58iBd2ZWEHZlGcNogpe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxNCBTYWx0ZWRfXwWDWGtsMvJRD
 g3vLxhV4w+4Js8Abos1Q7spp8IaJrDrZUqIGfcSLcjT+D33MwIhqcEVoUjwvDtBS6H4hr+6ChWN
 7+kB0enlCeYrCJetdCuPDn+FGI4veoLjUbMu5Sjc2ZV/8x3teDIm/lN427DzpGoZAc6F+JBaEFe
 VIGsilbqijigY6L2lQ9SberBPbIVMx/1/U8+tPcLH0LmRtOF6rpF2P+Qu13QxH1r3MlwpoKu+JS
 QiND8+Q0Hza50HnrNOIG0h27fIKpATFeHbJXMx8fUzqcFjPEC35+gZ9imzRU5O8rNns95Vv22UF
 mcVVS3GlBzBhSPLLwsAsPyXZ4E2baozauBqltd3HWML3qbUrwpRpXUalZQMVRqRYAvvu7raGzcu
 OlI5FZy+4n9oHm8AZszq7xnLfRVQaFbVukUKqI+CbXUBpBTLx8M=
X-Authority-Analysis: v=2.4 cv=E7TAZKdl c=1 sm=1 tr=0 ts=68ee3490 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7CQSdrXTAAAA:8 a=yPCof4ZbAAAA:8 a=8QX-PRIVUFofSj77pJwA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:12091
X-Proofpoint-GUID: mxfHpHhmv8syU58iBd2ZWEHZlGcNogpe
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2A55C180015
X-Stat-Signature: m6hfs7ejobfztnj1p3sjpger3whgnwr9
X-HE-Tag: 1760441495-613163
X-HE-Meta: U2FsdGVkX1/uOGAcKQllESTCvQI2pUATl+YDESEqKDWWHphx80kKDLzWtM/KGWEBnee4blkrecCVXZ5Z0Hb8gJdxss8y7MaydBfSojdJ+upNX4q9eukT8gU8VVmpZr5jTyqRvQOWK5SDVh7iC5cx1r9RVN43bzltUBEJ7f0V58qQAxSQnnp+DrHUCtJk/TBnWfDCkC5kF1LQBDPhZzgZaT4grGnxSd/8h35ODrESNoWKxI1WZN/L0/zD1T7jCaPPgsu6jr+J5eGUEFJFhyOtGnTeT6TG+pO+m3HVlzviFsQ2Q8EWM6TmzVPeUFIKxP71OMr7KSg5Jh9ukTfzqV6+7tZuW0169hR6thN1FjBJ75HDOH1r+rWyfO9IyUkUgDg9Lg8MOjQDL6wVlHmZAlawK77Y+cOJTTikbqjaqSNvjVCd1zXBQhCzG+ZrU57GbTYldudhvRZrTR5w5LzGRI6UKPxDuajpiiTzT3yN6OWCrMO4pBF+s8P4Jh887gx8ngVVkI33vv10IKooHn4g7x/rHP0WfFe6d6M06zC/wIoq7FR9GsYDXnMWPr+mSLMObCW7B08OBnIMyemvzHcQB/AqsHQpHratej/0nZxiTj2iXtKqLFEDp0kW6DbrnjyYrK7drpKxyoOLmKgFipatI6E/DQmHadqJa3F2YBMvW9EED8DTQnMOUT4X90xhXVDx4lCy/kvrGhtz/8mJ5/AhoiXYitFUYZ0NsQc3QkZxNVqYl3/DbqlRm2PFRXpL2pfbrMrHlNIfU/APHDKkMv4LlTsB9bNuMOg7D4VhwmrT8+NuKHYeLDNpGxKWOwHLSnrqp8UWadunaDkt2NVn2l9zbsBLmVUKd68bQD6b2lJDLORj9Lnzhw/6qZG3TFWMiJzHjwUMMv2ddDvGJJudguj2s9Z/nQ6iizy2oPzt3YNysY9dybI+Jtf96ul7V71E4m8TFHv9aOseqEYkAY4ujCkNkrZ
 qrZrW87x
 nlOhP+ijJLKjpiK2csc4KQYiW2G6ih/AcMGCY9HRlkjXwxB/4g0OhxvnkpQsOYSlGJu94k99FRXCfvA97NcjBzcyS6NsAHU3is09xF2E6WyzjdCAtkuwcZObP/xD8Nshl2wBt1DLf3/Rjwqws6GG+nydEcGbp0LmTklf9h7NxX4rx+cgAf/0tSHvbPP+ItSnLCzeZpCrwnqjJj63C8MXwH0Advux7QqACh/6owSdSILHGXIIcDFlZMAWqgvSuoJ3/R/CJRldJ2agcqZbXAKB9kiq2qgHaNGfNDPtkajY/Nu0STwo2s5qxnlgbH5c22qoiB1nhQktsuaebgQP5OHoImz9KMt5UBdzk5Oz5tnF5EzWsDpWkyqbpq/IpSPmWNoQRIWpzvx6BkmGP6nLOd+oijE42bAQOiK33lf6zVeEMbAg4h34EZo+45Yk4Gygz4ujaFIqQa01++2nW7ezPQa31G7i0Wi3QwT15BPEd6PeogTYArucwAJLgDpdw0kov16g3i7Yb+l6VhoVh49CzuH8zQfZp6FFuHPW8RW17uePELZ22k/4tjyDg/X5BDuSoQq9N+q4AqKjyTnXjsaECmRi2Q8dI5hAfGTJHeAklVL0YNJyHqb0PbPCxcINEM4t69iTzdFGit+3U9Gc166o5zlW5vwmK6QYv6xCYlHo+Blq4xQm4ZDwztiU2PRx2Ww2Fb85exqzfH94UPP13cr1t60HVMV0Bt25Y2AAO2Qkk0nFCgyWXie5ksbVAKB1dIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 04:53:04PM +0100, Ryan Roberts wrote:
> mm_get_unmapped_area() is a wrapper around arch_get_unmapped_area() /
> arch_get_unmapped_area_topdown(), both of which search current->mm for
> some free space. Neither take an mm_struct - they implicitly operate on
> current->mm.
>
> But the wrapper takes an mm_struct and uses it to decide whether to
> search bottom up or top down. All callers pass in current->mm for this,
> so everything is working consistently. But it feels like an accident
> waiting to happen; eventually someone will call that function with a
> different mm, expecting to find free space in it, but what gets returned
> is free space in the current mm.
>
> So let's simplify by removing the parameter and have the wrapper use
> current->mm to decide which end to start at. Now everything is
> consistent and self-documenting.
>
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>

Ohhh this is very nice! Thank you for doing this! :)

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
> Applies against today's mm-unstable (aa05a436eca8).
>
> Build tested on arm64, x86 and Sparc. mm selftests show no regressions.
>
> Thanks,
> Ryan
>
>  arch/sparc/kernel/sys_sparc_64.c |  6 +++---
>  arch/x86/kernel/cpu/sgx/driver.c |  2 +-
>  drivers/char/mem.c               |  2 +-
>  drivers/dax/device.c             |  5 ++---
>  fs/hugetlbfs/inode.c             |  3 +--
>  fs/proc/inode.c                  |  2 +-
>  fs/ramfs/file-mmu.c              |  2 +-
>  include/linux/sched/mm.h         |  9 ++++-----
>  io_uring/memmap.c                |  2 +-
>  kernel/bpf/arena.c               |  2 +-
>  kernel/bpf/syscall.c             |  2 +-
>  mm/huge_memory.c                 |  4 ++--
>  mm/mmap.c                        | 17 +++++++----------
>  mm/shmem.c                       |  8 +++-----
>  14 files changed, 29 insertions(+), 37 deletions(-)
>
> diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
> index 55faf2effa46..dbf118b40601 100644
> --- a/arch/sparc/kernel/sys_sparc_64.c
> +++ b/arch/sparc/kernel/sys_sparc_64.c
> @@ -241,7 +241,7 @@ unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr, u
>
>  	if (flags & MAP_FIXED) {
>  		/* Ok, don't mess with it. */
> -		return mm_get_unmapped_area(current->mm, NULL, orig_addr, len, pgoff, flags);
> +		return mm_get_unmapped_area(NULL, orig_addr, len, pgoff, flags);
>  	}
>  	flags &= ~MAP_SHARED;
>
> @@ -254,7 +254,7 @@ unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr, u
>  		align_goal = (64UL * 1024);
>
>  	do {
> -		addr = mm_get_unmapped_area(current->mm, NULL, orig_addr,
> +		addr = mm_get_unmapped_area(NULL, orig_addr,
>  					    len + (align_goal - PAGE_SIZE), pgoff, flags);
>  		if (!(addr & ~PAGE_MASK)) {
>  			addr = (addr + (align_goal - 1UL)) & ~(align_goal - 1UL);
> @@ -273,7 +273,7 @@ unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr, u
>  	 * be obtained.
>  	 */
>  	if (addr & ~PAGE_MASK)
> -		addr = mm_get_unmapped_area(current->mm, NULL, orig_addr, len, pgoff, flags);
> +		addr = mm_get_unmapped_area(NULL, orig_addr, len, pgoff, flags);
>
>  	return addr;
>  }
> diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
> index 7f8d1e11dbee..3b3efadb8cae 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.c
> +++ b/arch/x86/kernel/cpu/sgx/driver.c
> @@ -113,7 +113,7 @@ static unsigned long sgx_get_unmapped_area(struct file *file,
>  	if (flags & MAP_FIXED)
>  		return addr;
>
> -	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
> +	return mm_get_unmapped_area(file, addr, len, pgoff, flags);
>  }
>
>  #ifdef CONFIG_COMPAT
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 34b815901b20..db1ca53a6d01 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -542,7 +542,7 @@ static unsigned long get_unmapped_area_zero(struct file *file,
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  	return thp_get_unmapped_area(file, addr, len, pgoff, flags);
>  #else
> -	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
> +	return mm_get_unmapped_area(file, addr, len, pgoff, flags);
>  #endif
>  }
>  #endif /* CONFIG_MMU */
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index 2bb40a6060af..7f1ed0db8337 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -330,14 +330,13 @@ static unsigned long dax_get_unmapped_area(struct file *filp,
>  	if ((off + len_align) < off)
>  		goto out;
>
> -	addr_align = mm_get_unmapped_area(current->mm, filp, addr, len_align,
> -					  pgoff, flags);
> +	addr_align = mm_get_unmapped_area(filp, addr, len_align, pgoff, flags);
>  	if (!IS_ERR_VALUE(addr_align)) {
>  		addr_align += (off - addr_align) & (align - 1);
>  		return addr_align;
>  	}
>   out:
> -	return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flags);
> +	return mm_get_unmapped_area(filp, addr, len, pgoff, flags);
>  }
>
>  static const struct address_space_operations dev_dax_aops = {
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 9c94ed8c3ab0..7a39ac93495f 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -184,8 +184,7 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
>  	if (addr)
>  		addr0 = ALIGN(addr, huge_page_size(h));
>
> -	return mm_get_unmapped_area_vmflags(current->mm, file, addr0, len, pgoff,
> -					    flags, 0);
> +	return mm_get_unmapped_area_vmflags(file, addr0, len, pgoff, flags, 0);
>  }
>
>  /*
> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index 129490151be1..a1968821a55d 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -443,7 +443,7 @@ pde_get_unmapped_area(struct proc_dir_entry *pde, struct file *file, unsigned lo
>  		return pde->proc_ops->proc_get_unmapped_area(file, orig_addr, len, pgoff, flags);
>
>  #ifdef CONFIG_MMU
> -	return mm_get_unmapped_area(current->mm, file, orig_addr, len, pgoff, flags);
> +	return mm_get_unmapped_area(file, orig_addr, len, pgoff, flags);
>  #endif
>
>  	return orig_addr;
> diff --git a/fs/ramfs/file-mmu.c b/fs/ramfs/file-mmu.c
> index b11f5b20b78b..c3ed1c5117b2 100644
> --- a/fs/ramfs/file-mmu.c
> +++ b/fs/ramfs/file-mmu.c
> @@ -35,7 +35,7 @@ static unsigned long ramfs_mmu_get_unmapped_area(struct file *file,
>  		unsigned long addr, unsigned long len, unsigned long pgoff,
>  		unsigned long flags)
>  {
> -	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
> +	return mm_get_unmapped_area(file, addr, len, pgoff, flags);
>  }
>
>  const struct file_operations ramfs_file_operations = {
> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> index 0232d983b715..89274cb5daf3 100644
> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -189,12 +189,11 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
>  			       unsigned long len, unsigned long pgoff,
>  			       unsigned long flags, vm_flags_t);
>
> -unsigned long mm_get_unmapped_area(struct mm_struct *mm, struct file *filp,
> -				   unsigned long addr, unsigned long len,
> -				   unsigned long pgoff, unsigned long flags);
> +unsigned long mm_get_unmapped_area(struct file *filp, unsigned long addr,
> +				   unsigned long len, unsigned long pgoff,
> +				   unsigned long flags);
>
> -unsigned long mm_get_unmapped_area_vmflags(struct mm_struct *mm,
> -					   struct file *filp,
> +unsigned long mm_get_unmapped_area_vmflags(struct file *filp,
>  					   unsigned long addr,
>  					   unsigned long len,
>  					   unsigned long pgoff,
> diff --git a/io_uring/memmap.c b/io_uring/memmap.c
> index 2e99dffddfc5..55984007eabf 100644
> --- a/io_uring/memmap.c
> +++ b/io_uring/memmap.c
> @@ -387,7 +387,7 @@ unsigned long io_uring_get_unmapped_area(struct file *filp, unsigned long addr,
>  #else
>  	addr = 0UL;
>  #endif
> -	return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flags);
> +	return mm_get_unmapped_area(filp, addr, len, pgoff, flags);
>  }
>
>  #else /* !CONFIG_MMU */
> diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
> index 5b37753799d2..11f6543c4a07 100644
> --- a/kernel/bpf/arena.c
> +++ b/kernel/bpf/arena.c
> @@ -334,7 +334,7 @@ static unsigned long arena_get_unmapped_area(struct file *filp, unsigned long ad
>  			return -EINVAL;
>  	}
>
> -	ret = mm_get_unmapped_area(current->mm, filp, addr, len * 2, 0, flags);
> +	ret = mm_get_unmapped_area(filp, addr, len * 2, 0, flags);
>  	if (IS_ERR_VALUE(ret))
>  		return ret;
>  	if ((ret >> 32) == ((ret + len - 1) >> 32))
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 0fbfa8532c39..7afd94172765 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1132,7 +1132,7 @@ static unsigned long bpf_get_unmapped_area(struct file *filp, unsigned long addr
>  	if (map->ops->map_get_unmapped_area)
>  		return map->ops->map_get_unmapped_area(filp, addr, len, pgoff, flags);
>  #ifdef CONFIG_MMU
> -	return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flags);
> +	return mm_get_unmapped_area(filp, addr, len, pgoff, flags);
>  #else
>  	return addr;
>  #endif
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1b81680b4225..8b44f026a0b1 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1126,7 +1126,7 @@ static unsigned long __thp_get_unmapped_area(struct file *filp,
>  	if (len_pad < len || (off + len_pad) < off)
>  		return 0;
>
> -	ret = mm_get_unmapped_area_vmflags(current->mm, filp, addr, len_pad,
> +	ret = mm_get_unmapped_area_vmflags(filp, addr, len_pad,
>  					   off >> PAGE_SHIFT, flags, vm_flags);
>
>  	/*
> @@ -1163,7 +1163,7 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
>  	if (ret)
>  		return ret;
>
> -	return mm_get_unmapped_area_vmflags(current->mm, filp, addr, len, pgoff, flags,
> +	return mm_get_unmapped_area_vmflags(filp, addr, len, pgoff, flags,
>  					    vm_flags);
>  }
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 5fd3b80fda1d..644f02071a41 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -797,12 +797,11 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
>  }
>  #endif
>
> -unsigned long mm_get_unmapped_area_vmflags(struct mm_struct *mm, struct file *filp,
> -					   unsigned long addr, unsigned long len,
> -					   unsigned long pgoff, unsigned long flags,
> -					   vm_flags_t vm_flags)
> +unsigned long mm_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
> +					   unsigned long len, unsigned long pgoff,
> +					   unsigned long flags, vm_flags_t vm_flags)
>  {
> -	if (mm_flags_test(MMF_TOPDOWN, mm))
> +	if (mm_flags_test(MMF_TOPDOWN, current->mm))
>  		return arch_get_unmapped_area_topdown(filp, addr, len, pgoff,
>  						      flags, vm_flags);
>  	return arch_get_unmapped_area(filp, addr, len, pgoff, flags, vm_flags);
> @@ -848,7 +847,7 @@ __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
>  		addr = thp_get_unmapped_area_vmflags(file, addr, len,
>  						     pgoff, flags, vm_flags);
>  	} else {
> -		addr = mm_get_unmapped_area_vmflags(current->mm, file, addr, len,
> +		addr = mm_get_unmapped_area_vmflags(file, addr, len,
>  						    pgoff, flags, vm_flags);
>  	}
>  	if (IS_ERR_VALUE(addr))
> @@ -864,12 +863,10 @@ __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
>  }
>
>  unsigned long
> -mm_get_unmapped_area(struct mm_struct *mm, struct file *file,
> -		     unsigned long addr, unsigned long len,
> +mm_get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
>  		     unsigned long pgoff, unsigned long flags)
>  {
> -	return mm_get_unmapped_area_vmflags(mm, file, addr, len,
> -					    pgoff, flags, 0);
> +	return mm_get_unmapped_area_vmflags(file, addr, len, pgoff, flags, 0);
>  }
>  EXPORT_SYMBOL(mm_get_unmapped_area);
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 7db01567b645..354ea20384fa 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2756,8 +2756,7 @@ unsigned long shmem_get_unmapped_area(struct file *file,
>  	if (len > TASK_SIZE)
>  		return -ENOMEM;
>
> -	addr = mm_get_unmapped_area(current->mm, file, uaddr, len, pgoff,
> -				    flags);
> +	addr = mm_get_unmapped_area(file, uaddr, len, pgoff, flags);
>
>  	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
>  		return addr;
> @@ -2835,8 +2834,7 @@ unsigned long shmem_get_unmapped_area(struct file *file,
>  	if (inflated_len < len)
>  		return addr;
>
> -	inflated_addr = mm_get_unmapped_area(current->mm, NULL, uaddr,
> -					     inflated_len, 0, flags);
> +	inflated_addr = mm_get_unmapped_area(NULL, uaddr, inflated_len, 0, flags);
>  	if (IS_ERR_VALUE(inflated_addr))
>  		return addr;
>  	if (inflated_addr & ~PAGE_MASK)
> @@ -5772,7 +5770,7 @@ unsigned long shmem_get_unmapped_area(struct file *file,
>  				      unsigned long addr, unsigned long len,
>  				      unsigned long pgoff, unsigned long flags)
>  {
> -	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
> +	return mm_get_unmapped_area(file, addr, len, pgoff, flags);
>  }
>  #endif
>
> --
> 2.43.0
>

