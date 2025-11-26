Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4797CD11197
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 20:36:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6393F6B0011; Wed, 26 Nov 2025 15:36:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9AC6B0012; Wed, 26 Nov 2025 15:36:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B1D16B0024; Wed, 26 Nov 2025 15:36:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 395566B0011
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:36:15 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C623C140751
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 20:36:14 +0000 (UTC)
X-FDA: 84153915468.29.0B77A32
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id A5E42C0003
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 20:36:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QkEd4m4p;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QLqVhNdZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764189371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Xj9Ro9yZ7sPZT8T1noiIU+PpM5nSz3F0a55PpZ0Pjg=;
	b=USbMS9QCNjl1MaU+wCd0VRT3QVvhm+dYZsWsnFxzZSjwS/2XWWVcn85zmPqLhI7HLfWwMR
	Cyz/CYPXMCT/m6W2FrOrNIw3HhwW8YEfgOc51Ad18FZDV6EvRygUGstfxV9JuIX06JBzQg
	K4tF+Iqr3ggEwIm1bigIoignRfd6xyQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764189371; a=rsa-sha256;
	cv=pass;
	b=3FzGYNvLUPCm9FUxf5GY6CwqmlIYrVEXUCkdeiDH7mZcv/lEiwH3E8mZsUXu+zfUxS1PPF
	fE8X5d5DbMwZd3+smYCZ/+KpbS8KehnfZidde2vZQe9XYyGd+BGOnu3CWg7hef74VXmJP4
	Mw52ZUUM95DgsLoHu/uwTQ+EgRBNxSQ=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QkEd4m4p;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QLqVhNdZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQJuSxD3031307;
	Wed, 26 Nov 2025 20:35:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+Xj9Ro9yZ7sPZT8T1n
	oiIU+PpM5nSz3F0a55PpZ0Pjg=; b=QkEd4m4p9Pc8ieGwHHa2xHXyhLWThuFJuM
	1LI1IfNj9dC5H6WYrUekEbszBAn2GnpWu0Bk6fEmsMIe1tK0DJB+OWhYiLxjYGYS
	BINBMYLsiK3lgDo1b8YasF3pRhwqtyu+Rhdxe6tPKhdmbXHnOlYyqFai0aAV1FR6
	2UrjVla03oKfBDb/GBEo+TapIACC93XRcaWB4UkwdaZ9xeH3pA3pLFVJOVFl6H+0
	0paIQJ3f2IgQXCn8l9ko2ySfY40CFAGcziI+O4N9bCj0Q7ZofuAj5pjtypkJgYXV
	wU7sSV3Ghz4SxEdrGGvfIee3744OWO+J8BeyToCaJJyeWh0A8w8Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak811wa80-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 20:35:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQKKi5L018874;
	Wed, 26 Nov 2025 20:35:56 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012066.outbound.protection.outlook.com [52.101.53.66])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mbf0u9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 20:35:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D8JYaZR5eD0WHlHrPxiUQswJLksxpr25JyINvADEnroH1Cv5GVV27MsZmWsx3jw+s6pHKOpd45YhsaPLLcBSoss3z4L+B0t8P7GdNOqdZcedK6qb2EcPkNDu7shYxkvcidWe7SuGcTJhSE8hQffjM5uNllNawWO6RJlQSWUB0+PWJ4p2spCX/q4pNLaNQLl0hQismDaWEkYyMPYIy2vbDeZvoykFHzJhBTjWYbQirBzMryeWEUi3GiZAHayo7RdqkRQ9PLrGUKuNLn9mF3WfWfsIzYpoOnq2SmDm7LWojcpR/l1YEg2tQvN2DfTB3zgj+JX2B2DkwNYfErt1pyd6jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Xj9Ro9yZ7sPZT8T1noiIU+PpM5nSz3F0a55PpZ0Pjg=;
 b=nCtNDHK/ZjWDcZHH1iakeBRWFmrygacWHnfU92uCywMgxGiQ57rRmgnohIOr21zj4om7G0R7I/yb5sp5icjenyQSgaHKFN2ELpqt+MWHS1Q8BhgwQZ/JseNlT0EQCnj8wqZ8iBO2vwa5AkIbjZkqP59C/eQ0V8AtkMA77x54egN4tya2l15XkBTTmlI7XHQQqrkIy8yBmD/PbmKehKJmlAIVSoPNlVlM7ASbBhlIHo8uY5eYNTuITm22ef2psD6p7JsIKUak+j2dz4Dfha/2XG+eOFDyk4UVZ0wKg2hkGsr5uaMEy07RIxDSRvNQNJWrTqoqnQmYMsS+8s89/lDtrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Xj9Ro9yZ7sPZT8T1noiIU+PpM5nSz3F0a55PpZ0Pjg=;
 b=QLqVhNdZHByo4totAR+BLIliDrBRD05H7ef+Q30rLtLuGdem0jaoYAQhzH8KmH4MJyXmXGofanIn9WP9mqXyWAnSBoxeVvZgMZeZtVa0KCCYiLVWqRG+OTycvnduUgRVfYta4JKKrBrMaOgjRBA4sbnEPG3fmmThBY3RXBiSJg0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB7484.namprd10.prod.outlook.com (2603:10b6:610:182::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 20:35:50 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 20:35:50 +0000
Date: Wed, 26 Nov 2025 20:35:48 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v2] mm: fix vma_start_write_killable() signal handling
Message-ID: <bffd231c-acfe-435d-be79-48b8617c37a2@lucifer.local>
References: <20251126174500.2498895-1-willy@infradead.org>
 <c35ab0c0-97c3-4565-ba2d-5c418ecac593@lucifer.local>
 <aSdGvY2UzrXdR2e3@casper.infradead.org>
 <d70b3309-348c-4aa9-9b62-33b8191955fe@lucifer.local>
 <aSdYkYYAuATwYqbD@casper.infradead.org>
 <d8c2a266-fb2c-4374-ab14-4ac910db7ad2@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8c2a266-fb2c-4374-ab14-4ac910db7ad2@lucifer.local>
X-ClientProxiedBy: LO2P265CA0004.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB7484:EE_
X-MS-Office365-Filtering-Correlation-Id: ab76bbec-87f8-4404-ab78-08de2d2b62fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Vr9zCKvd0pGK4S3iyzWPHNOfEN2lbDm0rxAuj5hSKqS8Hv012y8Jdkn+3B9q?=
 =?us-ascii?Q?i/i2Lr6jPJjQjzgDt6E2mFu+xK9n6sHAdYV9GMuymIh4iutWMj+TJNfqG3jB?=
 =?us-ascii?Q?iMe25CrY37NKtYzUdr+Q5WzYaQxdzxEMSeRRIlSYnsixSiCxuhro/oPj5Vjv?=
 =?us-ascii?Q?aTHmOTDw3j96muifaMyXvfrFswVbMwITiRaOI0q9QacsW/uyLUrZUPDaABBu?=
 =?us-ascii?Q?5MKxzwIpVPDLP7L7U312Db1p0FIbYYYICtUyjsNDTIoGgo9c6hrDPfYWiDos?=
 =?us-ascii?Q?kgyYEtOOHTZH264Cl+4pOC9rbuk8ig0dOtsCD3uVGfsXBRsNi5gU8hoaQU1N?=
 =?us-ascii?Q?Fr8QuTPRj1m2g/+HraitkS1veZ/l8uJltY0PEFzeHlFqxCRJ+NrC1CVlVMFc?=
 =?us-ascii?Q?3OoWPBf/HOJqeW43ODcipZp+0hdBCHqM1U/POyPLRLbFbizgD1H+gucX9cqe?=
 =?us-ascii?Q?+5WChqQY9y4TI6WgleoDrPigf1txNV1VZRv99Hou50cClyXwDT106Axjj4vb?=
 =?us-ascii?Q?4q9j0iksrxpIOF9yptlgwkWtkXTnZcXUj/ZEWH1aUS4PpRmQ9TBqfTE1q1rm?=
 =?us-ascii?Q?rruy6/YBw1vVgEVYhuxTQAtD2e4unO34kgOkRSwVSn28QSQ9w/G3JecoBe4f?=
 =?us-ascii?Q?8cNnUtrdJ9wsJy5xl1WeaQVEpkbWldyoGmBCFk/7XSvA6u5wiQQ383B5FQ2D?=
 =?us-ascii?Q?0lg6QRRooQonbeEd2TbPO40kenMgj/eLlRellGCYVDZKYeLRhElsMtFldE1n?=
 =?us-ascii?Q?44XZM8MRaikNu9vfQmquIlu1IVdlHmPzREj53YZmN25jawjYbEZJcolhI/3M?=
 =?us-ascii?Q?MZtDB52aEbpKTFNaKpqe44B1j25QY+ipSbCdY9deftkoqhOjW+4Ev/qYLawp?=
 =?us-ascii?Q?2g8yTbTId0c9Ldh81sjr/lYxuGSueoy6FUMOIc6U5IoeI1DFp7ebv/ljecQk?=
 =?us-ascii?Q?tO2FZilAFyxWRvvOBp3QzjiiPa6fEO/w69zSS9DkkUJ1FUhgY/SIM6/46XAE?=
 =?us-ascii?Q?y+OZViGgmzUJtbHYBfos146EV/LxWyZvNji9DsRbf4GgfEc9J4L0/4sYTnuu?=
 =?us-ascii?Q?D4IonL5x/kwsIbL5kDGtphEIuAcdNp6q2GuexaMdZNh/gAJDhsDnSpOjkNQ3?=
 =?us-ascii?Q?s7EyyWqi3YBrFhXbU0PASFoURbjXpSNB3lvJpVnHejxXJ6i2fcBl75vMWVmx?=
 =?us-ascii?Q?GYQ4k75i1VmeW5gawAFwE0R1e/ZItVS/i30h4w5kEV/tbj24zzfW0fHOVBuV?=
 =?us-ascii?Q?zg81zjkemtevC1MfjTgkpB1w2sydrDIRxVM1qTRjkTAvf+whnPaKFP/651EG?=
 =?us-ascii?Q?eJ2hLtY8SMIZrghvZmnlIuiaaubQaMaltja9pXlqPjDfGCorhpIcuIYPqLwA?=
 =?us-ascii?Q?URW5UrpPUyNstjMzFc6DXwxNjxwtSliaMhmY3Q3HHa59K7qpH8leDb7ijH4X?=
 =?us-ascii?Q?GosjM8X6bYF/HZDi0dSN8ASaXCxZxsni?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lR+Tnn9RJeVohY0xJe8rQfQ1GKdRrxwkW7K8K+FWbjI1TqsZetDhjROqrqnN?=
 =?us-ascii?Q?UBuk1UCBAtcot0lbpjsvtXVU1Yz1xCrk+u3Sj/t1vQxout21Ud5NVk3lgLS0?=
 =?us-ascii?Q?AYVpXhesyFioD4E3NdwUfodeW2OtqkWJSfLpVKz4Awd+LpDpHqEFNkenLcaS?=
 =?us-ascii?Q?/P9jn5s/21WYVh5oBESCB3RnobEW3ljbzLXVZMAGDAa6NlZ7e6BtoAnsts7T?=
 =?us-ascii?Q?03WIjic7lm5HpDxPplZG+Fn12Ubjx0X8KixXJuuLPbx81a5/9IPd5LZ6bE0u?=
 =?us-ascii?Q?3Tj1I37NcmbwKRjKOqdJMVJ4rnOItbAteluhFFpiBNzmBs4LAcNA5dHe9/Sy?=
 =?us-ascii?Q?/d++nlsPBVtiFhsYvjAGltcmqgSGkzczN9qtbKMIUMqX5gbn71YhPzEQD6W5?=
 =?us-ascii?Q?q4ht2EHf5CwV6/uiqT/42PM9o272jHSUYeYvM6/954fNtwD+/CDzAdWfY7c9?=
 =?us-ascii?Q?ThPZOAH+La3vJibTuCmd01rXXVh1qrTLyMiaIWhwI0uB9wpmw4hLyMR2X1ug?=
 =?us-ascii?Q?CFskKIS72lTEG5x1e0MprLkJsTVSvBi/4rcT86bXyN8A6/mQaYdZq4XAvnV6?=
 =?us-ascii?Q?BR63K9EoFUidXZ2jsQxvsJDV5BrOpWGDms117JaFf/+Id0EuhMvU8WiMfVAU?=
 =?us-ascii?Q?eQSpgnwwvpgwPgoyJVAJjCC+bwX4BMUhvvbWlY/NbEqiDjoaFLjdsVhpltCC?=
 =?us-ascii?Q?kATjg579ODYmZFyuDYXAwJkmUFhFcGyVYcqAtkAGQe0KvCWgxOlHn614tkmv?=
 =?us-ascii?Q?4HekDHv4UZwxFnbZFSNkvILxuZc2ylM91TzrAyeDGAf5kq4xMMyv5SYA7yeA?=
 =?us-ascii?Q?GAl9/INAx0VBB8j+AltA9IalvdtGG83t+tFoO3kseb2WTb5a5NCztkuAIeWb?=
 =?us-ascii?Q?UlncCxooVvQ5wnD/UF8bNxsBRVR4thiCHgVKfP/E7X1qSb+J5IwRlMqnKQKa?=
 =?us-ascii?Q?pLH2Bg45kieaYd2PgyBDTyNjyMnSsjdBoYyINrbAFiJpytpCYd6uH/jopMOP?=
 =?us-ascii?Q?u8+aUK8MF1qiTo2xgvLlIOgwB5Q4y0AYPLtTeU/TaQwUt68f8pBWVZjANaiu?=
 =?us-ascii?Q?z5oxYAlbCNCM8gofckZbqjfu4COeV26RHPro+BSShQlISa+6S9ajT/2GdnU0?=
 =?us-ascii?Q?enTWaBBQMsZTGjvFTMXyfTyCDX7YDzJpDVoTvvSe14VDXFz5oRQxZsiTkbia?=
 =?us-ascii?Q?q/A597XDz3MYUIr7LucB84DwoOHtHOsJ8QrZMbteLJGSHBPp54GD2VhQMCv4?=
 =?us-ascii?Q?psDqk1uMAZZF4B7WRnbCH9LzYIZ7Ag2zpInW7yBktag1ig03d/8EjqiWPPa1?=
 =?us-ascii?Q?3B/Zx2OBGyx2cLWlE2nO3H9on1eHKVcdNKP5ztBrOoqo7jX3gNJ4H4S22DtA?=
 =?us-ascii?Q?MRVoA7u5K3sSCMitH/ZPiF9svKALNVrfBBhUNXVwAZ/Xb/OHR7XPortsYTcf?=
 =?us-ascii?Q?l4SNVLfqejcn8d7EvwhT6vWzWeL3xaClZ6ZbIs7qvdf7EW2fzk1Fv78SswhQ?=
 =?us-ascii?Q?V2HAUP1Hfg6uauPR5IJFBvv0k+yyDQycbHNxKemK13kGCCXWx4HcHSNvjg97?=
 =?us-ascii?Q?fD8AumiWLSncMiFbFdRsht58+gG1Uh/x9PmLhdzpMaehShoL39xd8UcnGC7v?=
 =?us-ascii?Q?Qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dD4OUptan5/8pokonNmqFo0NDPQSdMnze0UY3BBfpn4golU0/QcE9Th9V2xfjKYMFyrylUZ7SvR23na3BsLW7XZ6NHVOubDZe58MM1lW1AvS8NN9TueP+xwxTRFLkizwLJLr23cpSfVOERsNp6SSsUmSva335kMqJ/bZ6HaaJkelKfgImNlc1myitk8gJIYTOxdVSwupxD+mlUXnW4dL61qJvAKCinbiLwF2nl8WgpPGa5ax5E5VYdsKrLW3VflSl+DTHZ7p+ZVMsF5v80fYFhHgoXU7TXi77m9569JQk6Xz3DXKcvMA0+IThvCHrfksgEAXwsKwuFDYz9C00wIMmEu8pGZPjVdrEzdWz5dL/p0WRJI05fKR8Xbaq0xGrqgOPKFJntmYka5b/F82msvQZyrEjN/yxOo7C7Th6R78YiDSnw/qqV90uF5qyeQG/3n0Og3/1tITZxCol3Lm951DghrZM3hydOOhw0EbmRh5EuNtqiENbeGi9fdIZyMRo55rWAE8e8cNc5cnvW0bi0R2Z4lh3zXTLOxYwO9DGQsrryT0obLAwSvznJGxbiB1yxHFynn5hzhOOdVpNMNflj8OfrD8kvbSCDpUp9MMrcq4G+E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab76bbec-87f8-4404-ab78-08de2d2b62fa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 20:35:50.1236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YRkGUFozAr6OHx7ZFO3gteHmAhsfzMY6Ya9iqY1QjxunKkHrlvHez0ShxHSzH4MIGEzeCKiRrZOLn4lIWhV8KkSj4FNVWVStix2xp5Bfcjw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7484
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=731 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511260167
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDE2NyBTYWx0ZWRfXxc/eSJEcYt5s
 LVOBZiLxuKnSBZO2DfX2jfzBqY6afH2n4y8mUK0K8v1sWigi4W6Xoesd3meivpkhorxzZ72fnZy
 XXXSOxppyp9XICUhDA4ec3TBCfqX9g40SSKhIT3RuNJdbaT5qCyqLXvwhyr8KFQsZPhtMBa1MKO
 emZakSv5F3vs7vXnyDOQsKwF/v2eADwscu/TUFU0ho4b9BHit2tkErX14r7h5t1SAixB0Lvb+dL
 5p2FcfliX3t/9SmAbXgtNUog1Okt6nLFXMDPwMwqVb28dLCV4vwB/4g8jXUFDvtj1f7cRs2pBp/
 KVosTJdWOuV+KaMXzAv8ikrLVGbDJs55RbIfOtVvOw2AKeKz1bEb4TyHYQnuTFeyXOIR6LGKb1m
 1A6Osa1jg6bOPX2XM4i5eAmVWSBADQ==
X-Proofpoint-GUID: ISk_12YeVSg9dizqEmyRPjfExJHuvBaV
X-Proofpoint-ORIG-GUID: ISk_12YeVSg9dizqEmyRPjfExJHuvBaV
X-Authority-Analysis: v=2.4 cv=KKpXzVFo c=1 sm=1 tr=0 ts=692764ad cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1lrepi5NhnmCZB4Fq9kA:9 a=CjuIK1q_8ugA:10
X-Rspam-User: 
X-Stat-Signature: bhuo3onbzjrpd3rtbeg6mjyrtjptdhcf
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A5E42C0003
X-HE-Tag: 1764189371-635259
X-HE-Meta: U2FsdGVkX1/fI9VHtSlVoVcuD32FchG8DtZAzw4BSItdJZSO4/wtydUHrXcLeUMuA7aZtw+uAfl4kwg+IdzfQpdTMIwMzKCBc6ldnJznyZufQ6ZwwekbaZ1N50T2oIvHk3ZYwMrTi9WXX1hLemsyaCkzA55tzlmUc8AsTGOivIveNxiRtQYF50K0DLeVJtRho6RhEhTabtO9zB6SSWFloemaeZiuHJUNRLRFMkbNtIOK0k50FPiOSjP3kB7IZEm8r7l9TkiNUVgl/KSv2QC9xEJuWMOkW/5i+EamI+RzQxdlF/8Nv0yyLoUSzkTD/AqdH9ZjhsfKGEolIdFonxFikwh+6qGT4/WXm89Ik9kh+g0KeaDy0rnBr03N9gYlmmvm8rygX84nBHMUGxnNEI0NK6ULQcjo2aZUtBY/fCI37XgwpE4YP8Z/fqz6WT9VRWPZQ2Qcd+Pta80R+UIZ2v/4z0GTKlI+0cCyMrtZY+PPNLp5JNYwCVUufuGc4e2/E64hDnMZlRpDjTnaxzvxRAr4duuUCcYjLCMKGsmm0JUPSODEz5y9eshWQkP768yP342wZ6H293UJ72tkhJGb3T5GiA38dA5dE7X7/oB1GP9HYaPrMaDRAAOJvwUDwx++s7lLTJKkKsJpV/lV0CwZiQ/hwpELspLuT5bDiixAEoWFdPwjldP1mPynBPmhnezJSHzqI/tA/cP8jGknaQvacwT1VstW11X+M+jL/qgZivyMlhcK8ktzr5UdrMXPQDSdQUlXcwBk110d7UwTdf4XaWoQ5YuVhbPcKv18cYy9c5kR6u+pitJ61iwVI8cicxM3sWm5yDG672BdVFpu7UJ9rCV94nxZmyWk4azsd5Ath0HFsuys/nDxlaB1XOC3J4iuU/Hf7QA/tkywdWtrI10us1TltGRJVrZhGvBtymvzO0S8fDg9oBt5yFecnlCr8z9ks7CKa5qgD6ZdCVZAC6+X200
 OGxPG4qH
 5S+eMSFpKvTcVdsX8llfv/ae5Z0s5PmS4zGfONDIKZGpVLLfFcDx/0FlA30E+FZ/q98f5HRr9zBtxYBQvRpc6pRIIJIHkygp4vgEZcA5xE6jt+32W8UuBeTejWLLEYGpg+KXh1mo2vN7o2BS9lmP8QlxG4z6KFEOmrdzK8DPhP/6f4kNklGnwH1937g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 08:33:47PM +0000, Lorenzo Stoakes wrote:
> 	/*
> 	 * We tried waiting on readers, but failed, likely due to a fatal
>          * signal arising. Unlock the VMA and check whether the VMA is
> 	 * detached.
> 	 */
> 	if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
> 		/*
> 		 * If the VMA is now detached which means we lost a race.

Obviously should read

'The VMA is now detached, ...'

:)

> 		 * Let the caller know the VMA is detached.
> 		 */
> 		err = 0;
> 	}

