Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E344EE0ADA
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 12:38:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E80206B0092; Sat,  7 Feb 2026 07:38:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2AE06B0093; Sat,  7 Feb 2026 07:38:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAEA46B0096; Sat,  7 Feb 2026 07:38:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6A5B6B0092
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 07:38:07 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 80117160439
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 12:38:07 +0000 (UTC)
X-FDA: 84417613014.12.8E50E38
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id D0CF8C0007
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 12:38:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=btRAbHNm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W3kZ7jvR;
	spf=pass (imf10.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770467884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KuBMSd+8fPeq7kim7nmVEESREqmxC+nku3wXjDNV0kk=;
	b=i/nGvAEzTqmTLgPuokT51i85TXUeiha3rmdIWUYwpsxYpvMv7V0JaaFznhCqeRIgfCwkPl
	nTM1jv35UmtGNkBVBInbHDfxyhaDntSWT1ogTEEksyg8TvJZvgjjmsdrNUQi25YOJTn+gT
	d+xFAR7MHfaevk/mCTsYDyrHngweQi0=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=btRAbHNm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W3kZ7jvR;
	spf=pass (imf10.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770467884; a=rsa-sha256;
	cv=pass;
	b=FTrALq189lZtCCK/zL9yCXv7ac7FTYeb3PLmm3w8TqA0aYGE7qw81TKo290Fr1tSHHhS/R
	6ufSdWC9KYGfn5f397AXqFGL+o/Nb3uVBB3evaQTWKhlX8SgZjKBTJJFBnxMAcHwL+1yf9
	CVS74NrErYJZx2VoZvdXTf8FMisIRFY=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 617C35ci666656;
	Sat, 7 Feb 2026 12:37:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=KuBMSd+8fPeq7kim7n
	mVEESREqmxC+nku3wXjDNV0kk=; b=btRAbHNmcdfCj/6CyJlPekCfqc2HW0UbKx
	fj8rpTgVTIsCHpwS6ep0hSH7bK5DvKZCJcfqmhe9l+b1AkvwppijIIM4sQ9EWlPI
	QKiTH56G70ODfQAQ0baoGYBTFI8ZUVCMaPbhxbe0zsoTsr6I033k7k/rggks5iui
	Km4dA0P7BYR0/aNuQS8djrI0Gbt9EM80pAUORNUckovc7ulDrDBYgnMWA0CnO/Wc
	vXKRI0rxkGOLbHB7xbp39yQ5/Od0HVrz7Qmv0oT7BKri8aUHpXk7L9TcYyGUoNTI
	5rwziGzNALuj+pYt3Dx7pboFC9qN8oBRb5QwDwRjzlvpJmAcSzWg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xes06q7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Feb 2026 12:37:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 617737st006461;
	Sat, 7 Feb 2026 12:37:26 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011024.outbound.protection.outlook.com [52.101.52.24])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c5uubdp8e-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Feb 2026 12:37:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aLWSlQss8dCcsql5EUPsLd2MjKdGByW9zC+gdmowDbcLuAn0cLNSzi+1GfRLRJn2rHUw7p0dD4iuVQnMupabB5oXafAqBE89J7W1KnCAe2u2Ralj2o0hQxfn575ymbS346aWHSmg+XnzTGSBdyztChgt99+x65nV9oClYNy2twejptQr7DQ5T8ce0J3Y9he1OYZrwXspzMKiyHQW6Yp6tn205gb8bIHRus4MBjKP8YhWj43Mqa4uRiLTbkBAlJsPSLuh9h18GtkL8YM+q7tqwGh3X9z9ADvmHb5q3ZWFTWdp1VAjoWojrabONE/6ONJvSpkaxCHCE8dem+lxQKXySA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KuBMSd+8fPeq7kim7nmVEESREqmxC+nku3wXjDNV0kk=;
 b=MOF2/yKNi0lQnyGTS8tDV3dLX2S954I2wKkEj/Vw7nRPPchFT5djPenJr5DjaVA256SEzBAp/gABlj0YaZrt643BbtO3JqDoX0NEDWR6Rc5atxyM0eCsIu7+h4hn7FDwcDqa3HdJPQ0yGe/yitvyGifAs/JBD1r3YG26ucIn5fMmMERzNNWhKWP4bhl0rCZSHoI54A8+OffkrZV7UDzxcJ2nb2VaBIEGYqeU4heqLxX4LQNllQI9djOEEo6AX03Kt6yzKN86Hhy2gdpnk7dCyTwhfvqApXxXmDZefw5BdUt/1lI16mS/dpuXf17cmFw8iuKOpayd/AxeK3dKsn+YYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KuBMSd+8fPeq7kim7nmVEESREqmxC+nku3wXjDNV0kk=;
 b=W3kZ7jvRAOxYlCHIUf7N61InqHY83cnqINE2bOhPW3ru1NSSwWOOH6pZh3LRm/VJy0j/X4mA1X3VmciU4Uz+CuiYq2fxp6TKhEAfDvC2TTCB4lSo50LTkqzOglR2wlNOKmtuzoc71a1t4cPT1tJ7Xhl4zmKTThSjGCZseHE6rSo=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ1PR10MB6004.namprd10.prod.outlook.com (2603:10b6:a03:45d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.17; Sat, 7 Feb
 2026 12:37:20 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9587.016; Sat, 7 Feb 2026
 12:37:20 +0000
Date: Sat, 7 Feb 2026 12:37:17 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Chris Mason <clm@meta.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 11/11] mm: Use unmap_desc struct for freeing page
 tables.
Message-ID: <bupca5z5p4obm2u5ojnxrdgobpor6c5i7h3uac7plynumgskj2@uppkothe7bre>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Chris Mason <clm@meta.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org, 
	Matthew Wilcox <willy@infradead.org>
References: <20260121164946.2093480-12-Liam.Howlett@oracle.com>
 <20260124184555.3936797-1-clm@meta.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260124184555.3936797-1-clm@meta.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0341.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fc::27) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ1PR10MB6004:EE_
X-MS-Office365-Filtering-Correlation-Id: 4385a740-6972-4e2a-def7-08de6645a2e0
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?ngLV1C+3FmpJtmp6RgHk2FFSfndHNWEsoOUvdm7OtvI4BdqLgEfAbnDRr7X3?=
 =?us-ascii?Q?2kT0e1FSwMr3h8cZiRyxP2PzrX1MqWGPBksZwTCVOeR0DXru9pvAESd62TkP?=
 =?us-ascii?Q?v9DQYbu43MZaoyXl943lk66Clgta179oos74+ZZwbFn+bizMeNhmJ51rmOqo?=
 =?us-ascii?Q?MG6dZ+q8FWyQfYyKyMvn2rWP3YQsXMoGaPERfjiUDGyCvc9MIt+rM+0Q0SMm?=
 =?us-ascii?Q?p08HEFEp2e+DFcuurEEPJ+qCXEq6+4Kyi/aJHWQPGhuYve8OQ9hTppJLLPMt?=
 =?us-ascii?Q?9DHy6MbWzubxZHEvS0f2gjxG3IJ2wyaxdjY61GagsnfKBj8nqch8F1nkwWtL?=
 =?us-ascii?Q?ykD1d+3s2ok2nbD74/8DEArCkht6POCw4Yf1xhW3/ZLldXOXiP0fe0yKD8KJ?=
 =?us-ascii?Q?X2iVBNz8AKw8o39L7pb4lQENVhoF18OaTT9qXyS0fwVqE1ObuqpYJMBa1jrC?=
 =?us-ascii?Q?RukUZh2AjuNBvGNV+pLEtNaS0mPZfC2E2kby2E+CYLMWrWpfY8vveZHLz1rw?=
 =?us-ascii?Q?F7Jz+HE5c/l0FlxOHn0/DXgZ1Z8RnxMSONX0EXCS1YfAbpI8RmzG/z9FB3kb?=
 =?us-ascii?Q?DhYU6jCZemzHkv5brZZcjf238lMIUA0TCphaNgS9G8S+HOw8x2+I503A51YB?=
 =?us-ascii?Q?1dv5paNdCFvGLGlAMbqMkFMoOr5a1YPlrfCHqabLowbOdar8hbX9k+Srqqlr?=
 =?us-ascii?Q?RZU3z41Ji/bMOZFyX2fqDmNKWzC8jDbVb5Zp/A6Z5YgxV6XWbCRYI1EhzQN8?=
 =?us-ascii?Q?Nx+gvOSdNx5tn7utm6P/2RK4yofFYkshLTDrePnxb6LKlWAAS5gvuS808a+1?=
 =?us-ascii?Q?Q4DVUNAO25RQYjhUIBx6ffraLPK8/+6gcyvXhSUjKOXhQjyzpvbBtU0byrpT?=
 =?us-ascii?Q?qz9CSQA12xb2bBC3DSUhr62O59KGPUJqXnBFfOT6zNoxX3rhnnVl/Qpzstle?=
 =?us-ascii?Q?A+xJI6TSI/UjfbnR9aUBcNR/h3yZdYL6Na49WJGlEb+FAOqYu/6gtlcOGI0o?=
 =?us-ascii?Q?HLoYbumWDLxT/LeSaEATRk/ZERqeZO4y85+IQq1kFHXf0lKSMk9x5Coq6tHp?=
 =?us-ascii?Q?t/pC+65K81uE871CfOxF9vlTPhiEaHPj/z9cz4aNEXLlOpuuSphfL9KYEZ0K?=
 =?us-ascii?Q?f8daXnIVx1dbzTL4TR0yO0S1kG/RUQQEWwYhtDudFRWtbfLA2NrXmblXAeN2?=
 =?us-ascii?Q?2KZw9cfC82UtTmVhIl4UYINVoDuEDie51O52S8m5JbudA9iW5ZKTqxZhA5RS?=
 =?us-ascii?Q?qalBI/o+H7/ohu5zIkEq5wouw1ALCt12ASbV7hm4kUU0t/K4vnwmCiMMgySl?=
 =?us-ascii?Q?DD1I+cl3FyEERGSz5+YyQ9CpnZVSTKyi+txwh+iqXPIreBKNg/BwK6KnhxTm?=
 =?us-ascii?Q?X5W6JtJW/8ClBRgVK5SHsmF8g1cEW1c1U97JfQpIXc1Az1YyfhRe4veZMkpK?=
 =?us-ascii?Q?zEMUR/GMNWThwQLzikbkLAMwhTjt1L5I4ds3NMawY61rNU9KDUkeETF8q+yu?=
 =?us-ascii?Q?N0pghqWi/Ar7hcY1lIzZ2PfwwIkplloP940vJ0EOyyk1BMd2ZFnVWs8ETrBe?=
 =?us-ascii?Q?qtyYHR9NfCq64OW8HdQ=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?xwNLaoVexusYFOp53xTMnDTXOkBnhl9aLEBoCgj2cebsgvhrn5vD2jD3GSDU?=
 =?us-ascii?Q?wu4Zw1y4lsWRyP/m2GCbA48lLyK3H3GEYjeOv488ckRGS+jVtkSc8BQin6ij?=
 =?us-ascii?Q?btZCjOVOHgyIDU23VgDxfyy3ZraI1SYhOCiRvD31wGtqGUae8yh/IxJ3p84n?=
 =?us-ascii?Q?QeUAkffrl6Y4vUU/w/SQxD8LflUFsFDdAdml6cWZJXQo39HUH+pHcN1bNZ2O?=
 =?us-ascii?Q?nA0PsCA5LygoLNaAtjR00dl1DRzeUslXEx64kKklHtG4xFhkZ3s4/rr+Wryv?=
 =?us-ascii?Q?m2031ClVzJwr0bN3HuweNkaVudRv9PX/n5ACP6jXwEsneu9ViVte7xG8LsjB?=
 =?us-ascii?Q?cYwQucMMdxLkkLfai5tNdJ2jznhZtGtmhuE9L85pIKzVFmYDm/Y0AOssKE59?=
 =?us-ascii?Q?qWhIvorP+C+tJixaABJcs9Yo0UFYowvPuM6Qoc8hyRmVbYQlXeZICjhRYVf6?=
 =?us-ascii?Q?spu55REvnnkaUI1myWiNUHj2SgNOlbIR1mEQ4lpZ+MeS7yVPyumAxWEj7n0P?=
 =?us-ascii?Q?Y6WUuS8mZssZCG/jPgyvbGIFzcoHkIOW//lXqLofLdeHsIePOi635GrRlQpW?=
 =?us-ascii?Q?MhwRTwecmqZm1Bz9BRyrnKGHrIPqbPR8pfKqMrA95cSXShJbzpxPcfrpCyp7?=
 =?us-ascii?Q?tzDEi4QAyuQ5q/gMDzrXZqQzEA4VMqjJoEHLGmH4mK781d8ME27i5+KT5vyu?=
 =?us-ascii?Q?xQWs2r9+j6wvCn3SLwtp1uuG7SzT4EFeNd9WCO1e1i9PgdvrFwlhNv7L4Rcq?=
 =?us-ascii?Q?XAmnmo2zpRnhBUTZZuazYp8RQE67FmknBHSkhqMbMA3u1YeGQV8lXufCTwLk?=
 =?us-ascii?Q?f5PDN40Ca1K00m3NyBAOQ27Tve5AgQHf7pt+flJwjfctb7FiTDFP19CV4coB?=
 =?us-ascii?Q?dSLQ7ku7OI6bLJm01uXk6TkL0xffljYjzqRVwZf/JPvwNuCD6Py6YKUjjhMO?=
 =?us-ascii?Q?yKNTX+KQWfUlAbl7Rt2TqJOKZ/N4WJCOY86oB5V2q5jYs1VkK3Ae+MABKPKZ?=
 =?us-ascii?Q?v/ZbEsurhtLf/DFYhFUedkjV619SJ/WQyJx2SvvGn1G22vgvSFiddRvU5glv?=
 =?us-ascii?Q?YAuQoZjsqTndPiK5GJadk3SixUXTOqQ9MDZqVoDy1KaHlDpBiRVZpK7fzZp2?=
 =?us-ascii?Q?ypkTfXYY927Z0lN8WrDlvV7RE7oVkH3UrNQRY5cOzPXbNu1jSgtM1e5ZX3VQ?=
 =?us-ascii?Q?A2PvPZNPKbvVsQNgEarN4u6YRRqyE0F5r1TmOVyEYr4l3LTxaWAgfIvBuXrV?=
 =?us-ascii?Q?blXXD73sK/Uh3IEAucmKOgu+5kizBTDVoWAzeHrsRQeV49JnX7P6/g0ZA1En?=
 =?us-ascii?Q?R+J8vuVpFBaNMn2dPgCxrfUM1R2iXM4JejwNve3eSkr9kB8A2cd8mz270Mc+?=
 =?us-ascii?Q?UXwYtOCK+mmpz+O0cmwWlupdD6YWe8Ayy1gn9bnnpu6R+Mi9mMxIlCghigYY?=
 =?us-ascii?Q?hncs4GqfG9hLpplET7FRRQ2QHYL6f6gVLcQdICt4Fpwj3830XRYi8dg8ISM9?=
 =?us-ascii?Q?H7Fbtv0ep7PwMCooAZQa+SoPETy4WVAwZN2k+LbobLnfLwV2iK/0XBqS7Sck?=
 =?us-ascii?Q?ymEyeR1vpZldj2L8G/sWrs+rtv/7xn9woHFSKc0+45krUn1pH27rv2YQnycq?=
 =?us-ascii?Q?lDN+AGjC176+rBuRGDPROOcTKyVZy5tahJdza3DDKRYWvYsCLLJIEphtWObb?=
 =?us-ascii?Q?/BUty9KnnzgwzKdHETEoRNYCvrHw0ot0EQHfahgF3V9xmDRvnc6SJQJp0rD7?=
 =?us-ascii?Q?PldsdjfoZw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yo7nWMAEMOe3HlxzwBTnrm6x9j3YZH/+dv4uD2BZLdTXgut0uYOeq4O9XlM+17v1W+JTzhiDQoQSr3Ya+A84zMCjrpqmxz3+R6kv43IE7XW4L+w2N5Wo/OIvqu5YVRPaF7ygnoPpwri+49KiWR1wg0Mu2gEFzsuQn6UAUM3tNvoI0nF2aqKwHYxzDtz2XPojVhsj+gpVAoFLQjIrL5JOZNQNedhRgc+44w50qAHaNIQBp87y5qE5JFt7Wvpd/alUGrdQkzNGJVbZZTbsbrnJ1GYA8mBy6Lp7OffaInMOcH3SXB5A9WJNbnlcv9zA8mXsOLtnrt/UamuoZm0YFqvhCo+vR/StdFNnm04b/GOGrB1jOOq8NtrRN3SMqhKAsgV0HrddYEvGZABHSDs3Eh3q/JQDI0Hil/qgpERzJdeRbVoUe43GQnoFoWeBZJukBTjrDHKXe7riFKoR9pRum+L6Td7UPwTAwMz7bzOHFN24A9e6CbhTmb5gMJgoq/OJ15NciDgIUtvQDYwFZfPVCmP8/65OdnKzxHyxzoHvT6eFcC/V2Zk82p5BVhen1cWFCK93LvGyyoRrVFQfvYGr3M/xMVHwd5naUMdBXERs0MHwPVI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4385a740-6972-4e2a-def7-08de6645a2e0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2026 12:37:20.6190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BDqZPcGOt/p5o9f0/aovdMfaCh9nT5KJFSXl029XgOrhi6EHKSlSLfPFsUTGicc/xg6lEa07Jkkxn5nVUTSwIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB6004
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_05,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602070101
X-Authority-Analysis: v=2.4 cv=KaTfcAYD c=1 sm=1 tr=0 ts=69873207 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VabnemYjAAAA:8
 a=yPCof4ZbAAAA:8 a=rdCDBXupEw5iuZ0RayYA:9 a=CjuIK1q_8ugA:10
 a=gKebqoRLp9LExxC7YDUY:22 cc=ntf awl=host:12103
X-Proofpoint-GUID: -s29nlDh0ENCDvSx2ywicsS6PBQQ56Rr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA3MDEwMSBTYWx0ZWRfXy8gWopUJy9fl
 tKYl7hNcdZQ4CPSMT8byn0jggxIQ2Y6TbVzvSnI6s/QCrdDc5qLtIKHYsjKZqP+ZHSIUeK9btoD
 AbAxEqGA4E+TfnskIjatdwvPBJV+v5f1otr/jlwiq1nNpwVSP/F8KSKbVcIe/t/A09l3iwWhzy1
 1MEh2cP0Z0xDIJAmAb86+buxb6rgAi6sTslnk0rA0ZfdayYpmXw/UBgvIvIgoUiK9RanDLoyyYR
 11ege1GvzUGmwt+DMMc6bIdtmTP/FBHLVcRzXPpIURHKpNs7vKra+TJuEyqqhYosX5vJc0dBTYv
 cmAM1PV8v1lYxGQrcCweSMUhUpu6wcmi4/J4esLK8TPOFkQUDAaUa3h5Coy1EMKtZGitL9zoLJ4
 Z4jTKrXSetduA/9p6D52ydUT+5KsMEQfjrBFlPBVrHSXD9axnZziKv8+ABcGETlh9CheznBRVIy
 nR4ckk/Gz40blnKwmnhQUqG0BLBjBhQbuNB5GBew=
X-Proofpoint-ORIG-GUID: -s29nlDh0ENCDvSx2ywicsS6PBQQ56Rr
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D0CF8C0007
X-Stat-Signature: 8kae6zjsj8e94uaekhdmaworujww3efk
X-Rspam-User: 
X-HE-Tag: 1770467883-383595
X-HE-Meta: U2FsdGVkX1+1xWy6XJ///GewX/2Z09/gRdj8rmRiBHEQg6GSduBiNtcDfKinks0lPx8bJoydv+KA27SId1tM/F2DHbPPF4OAidgXw6fO5jYWS5XPGtSwJXpUJfqSFr3ifjn9CyjVRxxNqpMNJ+h8O676oCGN6cyK35CfGgCr6f8sTWSGMz0TgUv2rIfGJg3hJsdL7itDVCP7DhFGVp2+aX72W0PoNl1DbNCGt+xT4JDONZxw6i2gSB8q3tWuDYJSeJoInz8/9+W45abLsLMzyXkwAHErsY7+EWtU0ejMYGgYqCcU4vLxDH+rRlF5+VTRzd59TmCIkHoocC2FLozFLVFPItaN2LNtzHrC8u3RpOI7/y4qCkFi8CdsKoEBNdVSc9DjJ7b77u1t82Qdc9+TCXUO7kI4dlpyoEq/gwXDkQzJ+QADGs35DE4w4fB4XBo8MjUIBcKKlVFREascJ7Bc/oHgd3X/W/4qM2IL0HJMTmRvw+fW4PqhEXZdRiAdPGEzKyINtMKhpllpZUKwidaivW5e5qcocelQeWIrLRU3eexn8qUWs6MQY5kC4JvluJ87L/+8fA+IDHsoVpvS4QgrSXhcMUNpgCnfF6IgQplJ1z5HYdjY3R1KbqRIGT91aFUiRC86ZR73LH1ww6eSg9EBf54efJlBRqSRS/YlZbX0zJ1FZSJlOM2Hcj089srZqT8T8UuNlbOAv3z1nrFvDii0bw8htH2Xv/SEiLC5NhBhkvtFD+yjXC0IS2d3v6CvpG8vIXBgeeT5t1fTXL86YLzmOCMft7b6ICPNYnB50M/CURcf7GJ9y80brx8lIljiju04myXssqlk7FRs5mYfCsNkVbGJZdhIGIjNocE5pD872V66HXs+ZjwSrF36hWGqV42+jaf4kIyMxK3sEdlEJJHYOX3Qd/ke3Ic2U843TI/FfJsaVWhVLjrYuRmACTc/On+zooLPH4Hsj+DyVHTrKLw
 sXPwJqJf
 hyje43PSdC0wYnxzTobjKJ6KwxWS3ZFWIS2Fr7kzlL1Dd+Vx9TeD/wZ3ERMzxgjjHEBcnlC/YP8Kdy3USObYz0X9uFVXxPTWus8v700fLBe1Qymtvw4jWhFKP5eY0GfZ3jH7wiNODwuY4uQPTe/2HsR1V8qILfxA/JJ279HSYydZzrz+GGKx/QRa5nRiVx43XjDSPx6mph3OyupV5wock7QhPg1JdqAXxAmKY00qdda53adrZUUTxwSKievHF0cbBBHc2S1RNX5MDuy8RrJNcvIBn/l5XozlGX4Z4FSTF4xiSuE9SSVX8Ep9iJW1gmO3DgD3vYGaeou6L1c9JJY7BUtx10e9VH1MVxlQTUnv8KkmTQIMkzFrZgJkhYzAzB5A2jEyZy/SMeWbMZs0bDC5jLOBSulCgXKeEcY8VkKdzWg7qqVuP6/u1/LYVdW1my/fcvK2RwXbFrdV6RWmUjrUxbIx99lT6uo4DlfPb38VnIkp95E4qxxoLVSV/B8pt5YN+wVbc4LFcEW48f1v6VbEojgJEzriUwxebqwottnhkahGovJaFtBUUNAL9+QWM9ieRMEHpry6v6q9NhqG/2U6dlnmQZR2uyoLFdQiMrcnCvu3Fz+9JChwjvG0JG+4uqEluO5TmO9PvbfTNLp8oP8mu6qFyI98zULhIkmNeREMQmtYzf4SsKxCVQO2CX+0zsNF+7LIVA2tgwyJmNB4kxnWahbgbB9KKCJp+eEeJznl0s7lXLTDMn5d96DY6jZPou1UQlr8f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Chris Mason <clm@meta.com> [260124 18:51]:
> On Wed, 21 Jan 2026 11:49:46 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:
> 
> > Pass through the unmap_desc to free_pgtables() because it almost has
> > everything necessary and is already on the stack.
> > 
> > Updates testing code as necessary.
> > 
> > No functional changes intended.
> >
> 
> Hi everyone,
> 
> I'm running some more aggressive prompts through linux-next and this one was
> flagged.  Apologies in advance if it's way off:
> 
> > diff --git a/mm/memory.c b/mm/memory.c
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> 
> [ ... ]
> 
> > -void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> > -		   struct vm_area_struct *vma, unsigned long pg_start,
> > -		   unsigned long pg_end, unsigned long vma_end,
> > -		   bool mm_wr_locked)
> > +void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *unmap)
> >  {
> >  	struct unlink_vma_file_batch vb;
> > +	struct ma_state *mas = unmap->mas;
> > +	struct vm_area_struct *vma = unmap->first;
> >
> >  	/*
> >  	 * Note: USER_PGTABLES_CEILING may be passed as the value of pg_end and
> > -	 * may be 0.  Underflow is expected in this case.  Otherwise the
> > -	 * pagetable end is exclusive.
> > -	 * vma_end is exclusive.
> > -	 * The last vma address should never be larger than the pagetable end.
> > +	 * may be 0.  The underflow here is fine and expected.
> > +	 * The vma_end is exclusive, which is fine until we use the mas_ instead
> > +	 * of the vma iterators.
> > +	 * For freeing the page tables to make sense, the vma_end must be larger
> > +	 * than the pg_end, so check that after the potential underflow.
>                            ^^^^
> 
> The old comment said "should never be larger" but the new comment says
> "must be larger".  The WARN_ON_ONCE fires when vma_end > pg_end, so
> "must be larger" appears backwards?

The previous comment was added in my patch 5, which is correct.

The vma_end should not be larger than the pg_end, after the underflow.
This was an attempt to validate what was being passed - however I don't
think we can do this anymore.

Please excuse me explaining things you may already know, but I would
appreciate you reading through it anyways and correcting me if I have
errors.

The way the vma space works is that the page tables have an upper and
lower bounds.  vmas fall between those bounds.

When we are removing a number of vmas, we remove from the start of the
lowest vma to the end of the highest vma.

If this is the entire process, then we should be using the ceiling and
floor in the page tables.

If this is a subset of the vmas, then we should be using the end of the
previous vma (or the FIRST_USER_ADDRESS) as the lower limit.  Likewise
for the higher limit: we use the next vma start or the
USER_PGTABLES_CEILING.

I believe this is due to mips having mappings outside of vmas (and not
just the upper/lower limits), but I always have issues tracking that
down (it's in a commit message in git somewhere..?)

So, what I was trying to ensure is that we were using a vma range at
least as large as the pagetable range.

> 
> > +	 */
> > +	WARN_ON_ONCE(unmap->vma_end - 1 > unmap->pg_end - 1);
>                      ^^^^
> 
> On the exit_mmap() path, unmap_all_init() sets vma_end = ULONG_MAX while
> pg_end = USER_PGTABLES_CEILING.  On ARM, USER_PGTABLES_CEILING is defined
> as TASK_SIZE (around 3GB), not zero.

arm32 also needs 3 level page tables to do this, it seems?

arch/arm/include/asm/pgtable.h:

 * Use TASK_SIZE as the ceiling argument for free_pgtables() and
 * free_pgd_range() to avoid freeing the modules pmd when LPAE is enabled (pmd
 * page shared between user and kernel).
 */
#ifdef CONFIG_ARM_LPAE
#define USER_PGTABLES_CEILING   TASK_SIZE
#endif

So, it seems, there can be mappings above the virtual address space on
arm32 (and only on arm32) that should not be cleared out on exit.  And
only when using ARM_LPAE.

> 
> Before this change, exit_mmap() explicitly passed both vma_end and pg_end
> as USER_PGTABLES_CEILING, so the WARN_ON_ONCE would never trigger.

The WARN_ON_ONCE() was also added in the previous patch set, so it would
have been contained within this set - also, it was the same, patch 5:

+       WARN_ON_ONCE(vma_end - 1 > pg_end - 1);

The error didn't exist until the below change.

> 
> After this change, exit_mmap() uses the unmap struct from unmap_all_init()
> which sets vma_end = ULONG_MAX but pg_end = USER_PGTABLES_CEILING.
> On ARM this means:
> 
>   WARN_ON_ONCE(ULONG_MAX - 1 > TASK_SIZE - 1)
> 
> This would fire on every process exit on ARM systems.  Is this intended?

As much as I'd like 32bit to depart, no.  But testing this has proven
difficult.  Thanks for catching it.

> 
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1307,10 +1307,10 @@ void exit_mmap(struct mm_struct *mm)
> >  	 */
> >  	mm_flags_set(MMF_OOM_SKIP, mm);
> >  	mmap_write_lock(mm);
> > +	unmap.mm_wr_locked = true;
> >  	mt_clear_in_rcu(&mm->mm_mt);
> > -	vma_iter_set(&vmi, vma->vm_end);
> > -	free_pgtables(&tlb, &vmi.mas, vma, FIRST_USER_ADDRESS,
> > -		      USER_PGTABLES_CEILING, USER_PGTABLES_CEILING, true);
> > +	vma_iter_set(&vmi, unmap.tree_reset);
> > +	free_pgtables(&tlb, &unmap);
> 
> The old call passed USER_PGTABLES_CEILING for both pg_end and vma_end.
> The new code uses unmap_all_init() which sets pg_end = USER_PGTABLES_CEILING
> but vma_end = ULONG_MAX.  This changes the semantics of the WARN_ON_ONCE
> check in free_pgtables().

Yeah.  I don't think I can have the warning anymore.  When removing a
subset of vmas, the page table mapping may be larger, while exiting has
always passed ULONG_MAX for unmap_vmas().

I could make this another variable (or check for ULONG_MAX and pass the
USER_PGTABLES_CEILING through to the free_pgtables), but that further
complicates what is going on here.

And it's not necessary - unless there is a vma mapped that high.. which
does not appear to be the case.  Note that free_pgd_range() still uses
the correct pg_start/pg_end for its unmapping.  And 0 - ULONG_MAX is
used for vma ranges elsewhere in the exit path.

I am yet to test this on arm32 as I'm having issues here with qemu
directly booting right now, but I wanted to send this out because it's
getting long without a response.

Thanks,
Liam



