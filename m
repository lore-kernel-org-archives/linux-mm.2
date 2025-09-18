Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAB9DCAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 10:16:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47E568E00E8; Thu, 18 Sep 2025 06:16:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 454C38E0093; Thu, 18 Sep 2025 06:16:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31C5D8E00E8; Thu, 18 Sep 2025 06:16:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1D9FE8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:16:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C43BC13BCEE
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:16:25 +0000 (UTC)
X-FDA: 83901966330.10.D0A0782
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6D85A140013
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:16:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bgYRWn03;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wvt1sQsH;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758190582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oZkvSWxj8SluT4/lpnNRGQMkf+dmYfx6mR/mhiQ1SzY=;
	b=aIin0UQfVT58a314SyusyV3V/GtJABX5xb+7ZBo2EmCUudzvgWp9Isntbl0bVFtooKEOXY
	9WVZIYsA1lMF/cQY2tPiHCho4PuijKoAxZlX0tr2bzMPlh+vQzZM38C8FOXfQE7XwOm92L
	S/fp613RGQUiNex4pQQ9nWwNqiAtun4=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bgYRWn03;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wvt1sQsH;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758190582; a=rsa-sha256;
	cv=pass;
	b=frFV8Wpw0MZyswM+NCZVbq+yBBeNgWubfWMgEbREFVP7Yncu5GgIurEVJF/3lC271eIT6S
	rnh5PbrlrxafdiWuCKWNfUtv6bVNwd82DIkMjcOSD3qyJjnPhDqKA4Awus4TJP5ZG/ATRE
	AkOSOWmiTTpL7rshWRZxk8b3SP8pgdw=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58I7fvUI021255;
	Thu, 18 Sep 2025 10:16:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=oZkvSWxj8SluT4/lpn
	NRGQMkf+dmYfx6mR/mhiQ1SzY=; b=bgYRWn03GVGz+J4a9PqDxOCa0x5+isyjdH
	0oL3z7DKHw0aJLZAATxjaYKE1+s1/qvoVXTb9sMiUxDFOgpOoKt6gfllHquWoyQ2
	ifg09eJnkKdn9q3YeAnUQaI7SoRAGnPTEt7/PqZCeojbZQpRRfE8LZ70OgtyVXP5
	zrBFcbPymTRNMAIYBYmvtRhuqcGQj7vAjvYi5Oi4Q9b3BFLqbtsEUxKgJUTCGmFy
	hycMQ7H4I/EYR76KDW8kPYxvlVQcVuY3aCWcwsIpgQLcGT2udLMx9PMe5kG14DFl
	bSW8tiOJSQq0IC+zo8VJCM4RerEUvioawCDcClaSkpeWEnEdrPmg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx9u6ps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 10:16:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58I9unW6028813;
	Thu, 18 Sep 2025 10:16:14 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010068.outbound.protection.outlook.com [52.101.56.68])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2ewqps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 10:16:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xr8XclNgfdAH0l6N5x+34kYbBZd4EoGSfhuJxSrPaa8Z3z4meFUyyOjrHeaUn6UKIsOMCENAKJiEuaNciG+MFWV1dGmxgMxc8eMeCy4o4BYAWJQEhDlNz1MhI2yr2JU4VboxfnpCXeBO8trOxLKgptfaUlVrab5TmB8cj2lLO4byHiGlfVcNC91yeCniF4Dz2ic/zac6bwXkubExP8xb5ulNEtuGLvr30tLmhTHdsW0AmmdgW8g0o5YIUImrZFiyPP1cwUvQ58CHoWLZTvhPH0afbJ0yiN1jxrAfD/cfNn8NpsEyXvjGF+X4ckRqPy9fuMSFnRKckB/5AdgrKoFRNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oZkvSWxj8SluT4/lpnNRGQMkf+dmYfx6mR/mhiQ1SzY=;
 b=IbrrgvwG4JgLiIZGoPBDkr8TxgqvEY/fZoZwe74yiBqkcr6QeUJ3ZF1p5C+97iXYD24Zex1mgywT3IRY6q4HH09CMw8vIdlqbn9cIsipMyNiwhyBYzaCHshJk2ZppVyLPzMrbBCN29ec1Tq1FByUJmrXuN8KMsLlbVK1GKbtSpkWNbV07J+U7oAD52Wg1nSRfmd6r+cB7QEje4vPwjDM1jQQfB8HRjeUqJ7ScNjTSjHjjrr2Yc+C3VE4zoFCucOpwumnzxISc/m0Eypq1Wll0raS+Orq5cLK8X6l6kxWLDH8XmIDgkW3x52pAgZ0VzlMJgEEfE5ynqlyhoN5eUKNDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZkvSWxj8SluT4/lpnNRGQMkf+dmYfx6mR/mhiQ1SzY=;
 b=wvt1sQsHD5GI0jQoKhA0ICBqnHrGj7KDA3OaZfM5uwYdDmOSKHCpIYgki+aVS/6qKAcimtZbiNj1JLdDmdYek5Cr/r7aEbwhpkIfybNzAGusCjxs99d/b7Uv0XRmN4ghm27w2TZ+LT5knxqEEh4ujMyU3B3HIb+0SIfFKtcoCPs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB7108.namprd10.prod.outlook.com (2603:10b6:510:27e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Thu, 18 Sep
 2025 10:16:10 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 10:16:10 +0000
Date: Thu, 18 Sep 2025 11:16:08 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, ioworker0@gmail.com, kirill@shutemov.name,
        hughd@google.com, mpenttil@redhat.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH mm-new v2 2/2] mm/khugepaged: abort collapse scan on
 guard PTEs
Message-ID: <f05ae786-b516-4338-8129-e7d2b43d2dd4@lucifer.local>
References: <20250918050431.36855-1-lance.yang@linux.dev>
 <20250918050431.36855-3-lance.yang@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918050431.36855-3-lance.yang@linux.dev>
X-ClientProxiedBy: LO2P265CA0406.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::34) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB7108:EE_
X-MS-Office365-Filtering-Correlation-Id: 6004337b-2898-4c14-5206-08ddf69c6391
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q6RrsuVgesdP+lAUbSJkkpC7b8R4VdSHPBNWuPikwQrmOnfXGwDeeZc/fMCQ?=
 =?us-ascii?Q?vx8fgptW+EDTPkCfsd90uWTL4eQe6jzfWhPA2opCeHRB2PI+DlwiQIJVd508?=
 =?us-ascii?Q?f36PWvtuV/t2UR474ihVHpp59v9UJjYXuTrp6ZYJQW7r+vcMn57dGUVew98U?=
 =?us-ascii?Q?hPuupM9uRnUc36JfuDowwzhrfiQtw/ji+yVU7H7+pDD2WrgR80J5pml9f7zA?=
 =?us-ascii?Q?Qaa/tZ9VbZwZ/jlXZAkpeWshInX2cGxiuszymQFhjIzgZdcuxqalMBQHVTl7?=
 =?us-ascii?Q?+3HJ+1RWGugPrJIfoQtuBD//T6v4DBz0mPHUBlnvvKzGSHrRJFFmxYsjvqY/?=
 =?us-ascii?Q?SdWtoPEfq7OkaC0VdU1YmIztl+9K2lP9zC4DxuO4Yc1CgcnZDiIN24/cwpvI?=
 =?us-ascii?Q?TYgK8JOG2/OlU4HtvzDQwn2eP873tobVRyuAb0bRDmy6yqgDDwf8lQQk7rsL?=
 =?us-ascii?Q?bPhXkWMZAaNzzfNW+qgG5lQqhCX53K1paC6thJ/44judcMmE+VnROqZUVfXd?=
 =?us-ascii?Q?DbjtZ5BcbKp0Iw251dHR74DkpaSMV6RQuIJsWoawCtMggunoqdraLAV+eEOj?=
 =?us-ascii?Q?2pGRBeIyAZvDqDyrnVxynsN7N9eE86XWzUIxxKrnTwurb6BkWSuxL0B+kGeo?=
 =?us-ascii?Q?gKETcrLg/CWmAJTneyiPaRx7D4Ynw1YYk/m2FMa6r8dwp84N11dVV1NtXifX?=
 =?us-ascii?Q?mTemLncZ+t2v49hs/I8tZyOvlkU7hwjiLCCFQNrRJFRITDvUAWl+1KGbeMpu?=
 =?us-ascii?Q?CIe/Pck3KIlYaEXFBgDvNzx/F9yhRW5yGSb4Fg+2PSoxnpFIyYo3IVnWChf5?=
 =?us-ascii?Q?XxzRl6zolvxxhT8hLgLyRFP9kqBDe4zaMoRe3tKrsddi2Am48neM5ijpiHKs?=
 =?us-ascii?Q?wGL3Wxhp2kIJ0kS1NittaVccg0mY4QHv7JPGiEsCD+SqAial1FDV+jbc9Kbl?=
 =?us-ascii?Q?GyuDnTkxQWhEkm6zsRXcJ/DxdD1ys5PujmNHiH9YFe8Shkzk7EKGDgjCpDM1?=
 =?us-ascii?Q?StWXw/xHwZGYJqmmVGte1WHFX5gEyLkh0+M/Cb6ZLbpd/tLeb1+ich8NdtNj?=
 =?us-ascii?Q?KDZ+XRifkS7OAWT5lAfakZiOv1oILgILTK8R+eLnaHhnqLLiKgLX7Ea0fQFX?=
 =?us-ascii?Q?N33EljzMx1jA8TlcxPyQzd9NJQeAchIQdaqap4bi7C/zU2+RvOcV0mGIK8PK?=
 =?us-ascii?Q?M2acT8FF5bou19WGdfsaT3F8VYN+aaOWbpLNsZ7bny8Alok4GAUgQkpNQHG5?=
 =?us-ascii?Q?VphltSFa0ljFTr6XNgBAXrNPrSysAU3yQiiDb6WEezH9O0of+gqzjyO9SPwG?=
 =?us-ascii?Q?rHChaqPDHsuh58Xeim5HwxiwLUzWMshVvQgKUByvyubxF5fOI+SwhX2pMZUR?=
 =?us-ascii?Q?pj4wLqw+usvjlZAw89rCUZUH3eefMbxfzVTlYTVjzo/YiixLg8/kZLWCITRG?=
 =?us-ascii?Q?UwgUTt1ruEM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WVxgXS2Sonybq363fx1t1kJLco4snPyVgsn9m96WBBPCPVj8pgwBKHGkkzKj?=
 =?us-ascii?Q?YRbX+XCBl0XlEMTF6ekBrzfl3jrfVb7OnIo2LFfEl10XYBdglO+hEcJysn9S?=
 =?us-ascii?Q?E7BbI9cnYCU8BrSWq3L3g8aCzisWZVUq7F9xzAS0T6rw/o/2XRI8vOSM/zm3?=
 =?us-ascii?Q?Rhw7QyjdmqFJVCG54wM1aEMA9Q9KFnWaiL9ESkBwWzAZB+YC7aXU6NUiTwdf?=
 =?us-ascii?Q?jcKCt2BBDeARt8/X/0g+/Mm0oosQ7GmuuFuvHQWxAI/Xr+vzsoHCer7YVAe3?=
 =?us-ascii?Q?/C0O760ud+k++xGT3z3ebYfnTBwYcUaDLKW+7WuXlAlBhHZv0ffLCelaKFJ3?=
 =?us-ascii?Q?eaiza3cWs8tpQLstEt86QRKrjoBldLJdokD14SJ7h3G/DaQPcxMkUKymfJiX?=
 =?us-ascii?Q?kxMag0XGZWGhsDHIzlIdapFqH8lceuiaVe4L4Z38/TCEEPnTurffut18A8R9?=
 =?us-ascii?Q?JTjnYzyds340Y/M1dxfnrHkAkKqVw3V5JIwtZ+fxkOYZJSP9TJvWs23+65VX?=
 =?us-ascii?Q?IbrTNB5ILjkvBqacQx8ELIue84akv6z6yFB3Aqq4dgCRaSh1erVsHSBySOyJ?=
 =?us-ascii?Q?MuHXwBjzC6vColIqeLUlONI+fLep56Mtbs3tqW1p9cDKJgwE3QEVGpK+R96w?=
 =?us-ascii?Q?wMIn8bPYMl5VEN3zYgAgycwXmtjW6V2fMCd/VhO21G7AX+ehwD378X1cJk5Z?=
 =?us-ascii?Q?ya6Q/gIO7WYPp6mowT6go7U2GnoxgDonNGN1VIrN4/35pfX2gji7vpZ4j3aW?=
 =?us-ascii?Q?kWn/hZWO+1aOdmnx/9XavjsTHpEiSkGtg4UXYW/1n5hZydB+dsx6exYdPeyG?=
 =?us-ascii?Q?fGGmd2asORiE8sv3QjFUottRItQXgxyWJwnPbnh2puBon194IZ3ZBiSdCOUh?=
 =?us-ascii?Q?Qvr8gH+b/vEjTQKWiXRatcaDsC4k1IrsosGUBRJfSYljkPmIz1eOiqe4P3uV?=
 =?us-ascii?Q?eBTwqJGQg1rjICUhbtK/V8awkGh1VOR1Lu9JHhyh5e6NvylNCJa1SzLxVTQR?=
 =?us-ascii?Q?AWph7AQ/MYtGM55ANNIJZHVWqXePp8jA3IgEsIP1ReTCo5XWxojThB0TzoGv?=
 =?us-ascii?Q?wQqcZz+UZmZZFkG+J55lyXj6jE5sUj8xJQ0O52iLvpkjlSYeqr/FsDWzsc2E?=
 =?us-ascii?Q?oXUN9qJvAWRcYDLt0rz0Fj3rGXWov3DW1TX0kbnE6qMuNoOGgJbYZWE6KXAT?=
 =?us-ascii?Q?4XErqRX8goasHIBOtUdfw0xU88rUYc6MMFbSe9QyWnPU5W9Ps9LBpKijWq9m?=
 =?us-ascii?Q?17CV5zvgvyxsBboFwApvA60CE+aUDe1VD8Xc5/KxFlGsYLK2d929LG3wArtL?=
 =?us-ascii?Q?PKPf039FqjqZtKpzL7Vvmk7FVBWl4XpMtqytvD6Yf/sdSGFJdH6JzHIc8bmF?=
 =?us-ascii?Q?V33X0fKZt82yEIgYpLAAkeJ8qpyZXkBtesp71RlcoKD1nalkCeiEf3mkdPXS?=
 =?us-ascii?Q?VIZQ9RAYTBIMljQjqK050iLWAzEM6SSzUO5RWiTK//5B1D0ZmvkzQEsnWZ/r?=
 =?us-ascii?Q?htGEKelGlf4cccFQf3p8+38ZLIPRilLMTO7qNBu0K1ljteRJuU7+TP3/d+TG?=
 =?us-ascii?Q?Wesm1vXIbcg8nPPvIflBT4jLugHGIss4P9aWxoA1yhUULNkxAhvoWlQPek48?=
 =?us-ascii?Q?9Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	s80naEBKWh25p0nr4HXrmjP5YXjEYA7g4N3UzSO8knPbpsuzUjVDkm4AXuOG74lUW0Qsdi6yx59ckYYzSVQjI1o/FSi5m18F1se9Zftp+7JnZ+kafXTOY/SsmfD7JKMrabTLweVaB8rOd55kcp0+mu+ONwnJIXzt4gpD5bKlnUPhet/6EGoQqP1+qtfuoBOxT2vs9dY7mFsKjmBFH/liviGeXfKbUcNDk0BcBRmVHtJORe3+vhoyKjH9UigpnjDKNIVh+ELvg6aaGLcWHVDVUVtcyva4y2WQFxoOvXwx5eL6G+jwoPcxueR5jMf1MBbnImA+hXdw1a7FcwnQP0L51v6tWUdILswlhmv3q+i6bHFq13/GV6XRrGF/rNGVx1VBvl3XIGQlW7H8brO9DOCkIF8NtOcD6OqYX42G87Y7Q1rP1W11dS5iPZMGTOTh9z1MpD+xv1si4wXLtpPfHNadS3VELAU6gF4AxQwhJZNgXNpv5DqkJQ9grXpH5hKtCzvibL71RZxrFl76NmYc1mGVs/i0Cv02bvfwdPMIv045gByDHEEvi5dtjQBVIJ5pTSUcY2sAGZBJZ451vRUK558fQDFzf1iW5Zc9tzFb/5FIz+s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6004337b-2898-4c14-5206-08ddf69c6391
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 10:16:10.3043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8V2EMKaSOI+n3QX0qIKQ540J/WUCOy2ZRn8oArKgDvSWNDBu3NLpl3qiXeO7Qd5On4B58N6QnLJFbj9neKYswhPb56AVL/M3Yx3LnDXq/X8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7108
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509180094
X-Proofpoint-ORIG-GUID: fa9VQmVEMf5tKwSB4vLv5niPOAul8nko
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX3/9bkJ2YhloR
 7mVKsYO5nVowhJVggnE5gtN9RjIHtCqnr4h1DATezYxZ1FfOJPR93aD/OOHlWaSGpBCNucaRCPv
 aq/nrvBXeIaTgZVJoJWH1g86wziH5MTy0W8MhbrkdvElgGA6IcheFC6X94duX9uujaSaEzYPGYf
 7H3pBWVpyLrt9RkBqfGQc6/mVkm3uV4NR+YoSa8uHbMpMN8yJYHMtvsGW2nJ9HQhqjaNC0siiO+
 L3PS0397WkAWaMUAIApm7ZNglqZyHIA2j2sNq5x/XVNPhQRIi5aq2T/qRW0+a67cD6IY3ip6VrN
 Nb/DS/BxnpQU1/tX0IXT2k9LvFr9kjc4mkMjyP1hpx+xfQ1xunHEXyi4H4bbI/GRq5xfTawo10w
 jSpq6JWY
X-Proofpoint-GUID: fa9VQmVEMf5tKwSB4vLv5niPOAul8nko
X-Authority-Analysis: v=2.4 cv=C7vpyRP+ c=1 sm=1 tr=0 ts=68cbdbee cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=zlf6558ox928DA0oqJQA:9
 a=CjuIK1q_8ugA:10
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6D85A140013
X-Stat-Signature: z6gjei1iss1kbrdaazet8j9z3764rckg
X-HE-Tag: 1758190582-892409
X-HE-Meta: U2FsdGVkX1/MufQ71YmJcq1wLztiTVYhQU+7Rv40PwMe9B2ZpbY6sHaNBOolDM4aZYTBDp5vvQMN/ujVjTEg969jkjhde5N6+YoiYU9va0dSFawXMUziCkPQ+T6ESZv7f0U7QnuXcSYrNU1RDt8+aL5jG4n0UhwCclTh1BMxvW/Gti7AS8FFcVwqYWy7crNqhHvkYVT77Bq3tSjVOfGqk1as0yi+WKGxOuPb/izq/tXF0Gcq2kmCoxq44qPgTo5PhzBKj/l9DzFSJ07jE4rfjIuTlX5sajv23yotAmH3A/lfdfP3wLQ7T4FnWFDcV5nOJDbY6HKrJeeq4k/mcD+sTQUTVJjEQR5BprJ47EavNW50w4N6o0lOUa3yepu68kXgo4Uar3fPBfR25TsRhMXa8S60G/aWi+xHlJGfJldY81zUDRqvjvkPApk43/s+0QYEM4hJsXrPgg5ONAWaTV+vdRROj746zYmC2ZZgtMgq2LRXNDkZQCZOHVFtIOGek4U44KadWRoTiVpAYEuyOGfiS7L44Bbq9+GqkAzUvN3q00tkDusa9tDPvaIR6Cc8+8BgS3bkJAQdLZFkb5O0i51dr9MIo7nmK+nQ+FGg7jr1912xcIpBpTRlikO/SuI2tg9z9sqq41mEtBlisRlMGfVO8RjajGUHFOSWUdLQG3RaN5abqDI2eBuQ6Bh04VazE2Y1memU8iApss/W+kP71jcaVf4FDZLs8P0CQW9okwj4ytSmUEdVby425irVQKWvVmFRZet0tyfH21JH7ASthoEC465GcilpmNBosfwLQOXS4H+J6R/MtdOMp2ueevKm/119TSFVwwW5YhH598zwUdarbb08oGHvdfxGtaHI0wpZq91sO4vW2zL1XzZOjBMmg0iYQrVBDopWOlBcfgodCZFXXAI41wZfHTG6DvNoo/rHixSs8FHC9Auoe/+eptveScruFNPdAyC6hxIv76t326g
 OuuGZs+9
 IQxIK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 01:04:31PM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> Guard PTE markers are installed via MADV_GUARD_INSTALL to create
> lightweight guard regions.
>
> Currently, any collapse path (khugepaged or MADV_COLLAPSE) will fail when
> encountering such a range.
>
> MADV_COLLAPSE fails deep inside the collapse logic when trying to swap-in
> the special marker in __collapse_huge_page_swapin().
>
> hpage_collapse_scan_pmd()
>  `- collapse_huge_page()
>      `- __collapse_huge_page_swapin() -> fails!
>
> khugepaged's behavior is slightly different due to its max_ptes_swap limit
> (default 64). It won't fail as deep, but it will still needlessly scan up
> to 64 swap entries before bailing out.
>
> IMHO, we can and should detect this much earlier.
>
> This patch adds a check directly inside the PTE scan loop. If a guard
> marker is found, the scan is aborted immediately with SCAN_PTE_NON_PRESENT,
> avoiding wasted work.
>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/khugepaged.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 9ed1af2b5c38..70ebfc7c1f3e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1306,6 +1306,16 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  					result = SCAN_PTE_UFFD_WP;
>  					goto out_unmap;
>  				}
> +				/*
> +				 * Guard PTE markers are installed by
> +				 * MADV_GUARD_INSTALL. Any collapse path must
> +				 * not touch them, so abort the scan immediately
> +				 * if one is found.
> +				 */
> +				if (is_guard_pte_marker(pteval)) {
> +					result = SCAN_PTE_NON_PRESENT;
> +					goto out_unmap;
> +				}
>  				continue;
>  			} else {
>  				result = SCAN_EXCEED_SWAP_PTE;
> --
> 2.49.0
>

