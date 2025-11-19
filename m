Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AE06CF31B4
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 12:06:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2A956B00A8; Wed, 19 Nov 2025 07:06:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDAB46B00A9; Wed, 19 Nov 2025 07:06:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7B6D6B00AA; Wed, 19 Nov 2025 07:06:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8F9856B00A8
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:06:30 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D931512F7F1
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:06:27 +0000 (UTC)
X-FDA: 84127229214.19.45F0825
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8D6C01C0010
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:06:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Byf5QUeo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RR3Tsyta;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763553984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fVhFfpHd1XkliNs/5mJPvxYFOv3ptdP7sRp9S4KDF6Q=;
	b=l0dfir5ukghQELNBijQKixTWwu6ntA+zBiWbakYY0phfR21ygORa12mF11BqHIeRRKdOEf
	nZhAhEOQLFKGsIAg7vunsQVywfMpg+Ny+X+trxHyr6Xg9+kYr4euayQTFtb2q3Psr9BHNH
	6XSQC1zT4D7spAEsNVcTVg+YPeCnYAA=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Byf5QUeo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RR3Tsyta;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763553984; a=rsa-sha256;
	cv=pass;
	b=BSD4lG3lIIWYhzgnhGVCMfH4MpSlJY0/6fiqzB3XmngQvhVJ8PibjnkTVCDjHE9ySe60/Z
	/xuVzRc2+ZMA4BDKrFJS3/nO7UKTaoSjNFCqfA8+XpbCQ7r64IDphq8v4XpXE1PsM3Sdq5
	x3nRxwUZhCFr45HJuF/k/x66NOApGqU=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJAnl6V009286;
	Wed, 19 Nov 2025 12:05:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=fVhFfpHd1XkliNs/5m
	JPvxYFOv3ptdP7sRp9S4KDF6Q=; b=Byf5QUeo9xxeoY/x84bAiocDMogTV87PGs
	+4/AJSAlvYgS4pVllgFb3/YVKiBaiyjkKY+jwGce3KnXNR/QgdbSXZXZKU+8L4xn
	nWqu3nbI6OUUVmx7DoN8jisr8KsUKo1TnqT5ccmFYjwv2PdLengshIfCQF7sijC9
	iU4AYF29lXLwOWjMDHzNiLdH8W714zBteqQ3wf3eH6YLGXWgUAoF6bP/bo6jJYGv
	W/4xBTfq3FW3WamYTx3erlFsOEbiJTVlnZbY3Duxk2+WkBS5VjfIr33j+fZ15dWR
	B2ByyQcmqa4EyP2RmyG003L9JY9NMpWC03a20M5hqZTv+q0lfXuw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej906xh0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 12:05:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJA6Gcr035973;
	Wed, 19 Nov 2025 12:05:37 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011055.outbound.protection.outlook.com [52.101.52.55])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefymrs2a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 12:05:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kxxof8MlMIllRsE2U3p6jP2Uqu0sM0IiYgn8EzCRZILju98AKHZNGC670VYNtIx9Jku0EWDl5xypwp3PpwH9+OWOsXmWJbxzDRy6F7dyMyodkmJXksB06v+Aeku1e4fQqG+tlZ7JhqJTsfISMJsQV5tAXouj4UJ8qIUsDJCLK7gsvj4Fi9KlZGwDvC8/SGWiPbexSjplx+Fip/oI63Y/w39LpTwJLDznKzymY3w/v5POlTU98MuXzLOAJ8c36uGwRw8FPq3MI/gU/Hdhw4ZxchYqx1Gu8GAzem+8U/ovzjwxJ4jZiAGhml/hUjxloc9IyZQ4oRIixKBN6hU4FdOVAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fVhFfpHd1XkliNs/5mJPvxYFOv3ptdP7sRp9S4KDF6Q=;
 b=tZdVv4f8ggshUyPZQ8IFPz5P/Eu90PSc7JlSSc853VlnJm6BDlwruDAF2Vge9KLCkpuh8NzJYE/gHlHJ+olXq8u9j9zK0GNDAurOB78c1wqOvvgNWKmEdAV8WX/iOsdMDzBYpcd2L54zP6oaUVlMegpR32mHuo48MKWiKlVI5qsUiOPzqHPF6Wrx01qID/5sfWdoMm9DIk9wJ15hNrxl+PqKPWGU+z+8DQnAB68OjJE6yP7JmpqLUV56YyDQ71dgMhB8IqD3HWyzbn1qrnEFN9uGz3uaWyvh4lzWHx3dv/BAO06+0HYh6HOLnCwhkxXoWA5hcEySfu1aF40HwafNzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVhFfpHd1XkliNs/5mJPvxYFOv3ptdP7sRp9S4KDF6Q=;
 b=RR3TsytaJsYTiOphqTIPT1OU8wc1zoKZ4J9yvMU7eWWOmNUszoWF1RSRTwUESQeyUr2Wi92MEgL+F4ym68t6btSxCieUdp+EU8NvDwFygBC/MtPaPVOID8n8llt5N5HZWMjWozwH3FLucS3rCuLyGXVnmiN4xdowxO59Q6pV3Lo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB4758.namprd10.prod.outlook.com (2603:10b6:510:3c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 12:05:33 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 12:05:33 +0000
Date: Wed, 19 Nov 2025 12:05:31 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
        rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 13/15] khugepaged: avoid unnecessary mTHP
 collapse attempts
Message-ID: <541a75fe-3635-49ab-b61f-d86afc96df98@lucifer.local>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-14-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022183717.70829-14-npache@redhat.com>
X-ClientProxiedBy: LO4P123CA0679.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB4758:EE_
X-MS-Office365-Filtering-Correlation-Id: fcd91de1-ac3f-45d5-5bc2-08de2763f15e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FGsJVZEywt591gbDQ8KPGnAs22PzLGlP0/a6WjPSOkOyyUM8oKocA6oN5IEq?=
 =?us-ascii?Q?owPynzW/jMP/vJ9l0nMTX9uqEPuwxAssZ+qswNymfPEFp8qXbkHlfqMZ+tlD?=
 =?us-ascii?Q?8ww1LT2gPh+3ba5jWktSv/x98+UqCBXghgmvx+eS3BtcHYdVt/rEnk1fXpyf?=
 =?us-ascii?Q?UZdgNiSjrYFwdtlvlOzfprwY3rZF9/8JzNaLzpdQov6H2W59cEhCbDxyEBe2?=
 =?us-ascii?Q?/RxZJgzjLRxv9mZ0kdXZOeZ/LboWoWMUxU/gPVi1+AzMzAK/76eac0jw+2Q+?=
 =?us-ascii?Q?YhokZVouI6vZie4v8VRmI4OEK3z4eSTRUA3K37AafWwugCatNqq5JgGRbmwP?=
 =?us-ascii?Q?4FEm219Q6ywU928yWsB1KaL5YS2Q9ivdwYCO2UvHnnSSt27d3zjox8qCYt2a?=
 =?us-ascii?Q?dZHR0V+oh3W7JG1jTLX1yFZpm4x2NfwpAUi9ByT+aHzWEjplc0GcBSTd+0jA?=
 =?us-ascii?Q?EOd8Fd5QN7Zqx0APTx7FUTT59pUzDnV09/a8/WMR9EReKIVXwT2hMP2fVO57?=
 =?us-ascii?Q?CZVP+to10ifhukwa9dAEUDCeJJD88QX7VrWUTJoDRHRkfmFyHGWjPq7Peb3r?=
 =?us-ascii?Q?Zb0bVHVieEzl92jfTso+ZQSv+vup+xtM+Q1jlj27IToXMOtthHOluho94RHK?=
 =?us-ascii?Q?0pMghC7DhdlweAfIyQKoRl2LF8FNQs4R+O97bU2DqTgsP5Bnbn0+JymDGbBL?=
 =?us-ascii?Q?RA7hxcFL3CyVoigPHMm8b/ehPNlxjwm20QIfWDO0tAdyqIAB0jrMOJpj3x6x?=
 =?us-ascii?Q?uJ/z/JdAV718W0YzAhWzWIL2/yILVC3qYHfuKGYoE8JzYnwhKEPXWw/TvK+3?=
 =?us-ascii?Q?H/Fgdak8KJ5YhiUykT6SvVAPlN3kjOWVPwR/N8bX/2v3qse8kp33dHHySeNe?=
 =?us-ascii?Q?s71T//0Y8ZxZZf025OvvSK1HNPZk10e2+P8xHGq9YvUxMfS4eIKPifJPVWvi?=
 =?us-ascii?Q?Hhuz1h3hCWkKKaeXOrg0Hrh/l3pXfM5tJg5u8hixikAjgkJpxZUPW7Om0Xus?=
 =?us-ascii?Q?0DigLnn4GalEeBogS/r8F1hanwIj//iFEJsed2FZrs9FnXehZCeNU35SN2cl?=
 =?us-ascii?Q?oivRWlt2ZcJ44l7nV4e3HAjncwJ2ZEo+OI7Z6UdChRcLcN4hC6PPCFpEBrpx?=
 =?us-ascii?Q?n/7LjY2j/JT3lUvZ/XgZcTWUtODzM/nAdAFq9mEpN1gVAnvLFYt0mZn+cTXM?=
 =?us-ascii?Q?ls8gNrqfag8hWZVOijS2IiagkOhl46eiRNvSJdss6MqnoWJ+lSfP1tfOznN/?=
 =?us-ascii?Q?qXtsRGBZJhEGWI0QQFobG34Jj4d3Sqp7IOlLUz2tdDHv30aUe6zm/hInWcZx?=
 =?us-ascii?Q?Jj8E3rJXRywhkoATcyWeuVBTfICOuuP3ynCQCpjlwpFC4cwB/BuYbiGRcadZ?=
 =?us-ascii?Q?0ynu3+uHb3Iu6K+lYLnG7y2Atsl/Jx199ESrJHS/gQQ1aivB0p9xgPitovud?=
 =?us-ascii?Q?J4vUZ2mq3oFqITvGglW0q2UP7VRZEpxQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mW4qvdJGD88lEAUz1yR+jVqbXhE05M+OWxCzc7KDWBWpdI6rGXIDA+n0ruLM?=
 =?us-ascii?Q?xr42KkE6rEht5/e2fJxmbXtiFO8THq67gxCCV99iXIJjU7le0Bv1g4WemD5m?=
 =?us-ascii?Q?bS3/23MU9gbuFOyyoo25jwZNZBU3anqf3RRfMl33temPtr4tgEkJVLzONfHo?=
 =?us-ascii?Q?hBpeBluX+9ip5gAFykg1jqQxumpegBIXxz1Qyp4iNqFlR1lLrRs6nRvZ5nvG?=
 =?us-ascii?Q?knTkQQt//wlNFgAPGMgNKqrZNU6Ui2jVFwwi1dNjFjW1dscGy2nM0PENJmFx?=
 =?us-ascii?Q?vm19KL5Pg5CC6+E1LGs0dH9MqpD7QHSrvxwR5I4DLua4OLdADpZq/IaD96Ip?=
 =?us-ascii?Q?BJnRZXalSBKf32GIhfG7s1aenDijyWIsPyTvZIgh7SI7L6Sf3Rv4dCLGHbGJ?=
 =?us-ascii?Q?mjWJngzosEs7PPSQfLwGAjd9q/ivrxKjQcB8LWm+jWHh+dsX7liRopnmu3jR?=
 =?us-ascii?Q?JvGEgHw5YEQxUhuNIhdwRwzRfqVjhn7cW5x1w+YBCXdRRtCYH6T9Y5C2jdzP?=
 =?us-ascii?Q?J7f1Vo32IWJyLBdWAiqS3Bvz4wKYmamM7loavJqnNnoIXOT/bxF/3MXxl6v6?=
 =?us-ascii?Q?DLdyI/gOVUzhvEcymx7fZtOz7Ugw8McQBo7WSGULyVkaMfn6nbgIBCPQfayl?=
 =?us-ascii?Q?CHPca5wBbdIHU0UdyiPyX5hWgUTqMqhQ9BrdbdnwL/Ua1GfSet0RrjiC3otP?=
 =?us-ascii?Q?grp4iDsPfqgTk9qs/nrdF0lUSDc2A1Y+lf4Jm5Vq1XfAWVwfyNAHw2ak8PmN?=
 =?us-ascii?Q?2hXiwxSJgxy/rBwfRquZ2uhZHzuxSpLkwJYZpNy12Dsh7WhrKcq9jrsAA0Dj?=
 =?us-ascii?Q?g7YwjL2NcqwGbDb2ntVDSu1Wn/Ly6smL+cYidzumTeBbb8dQ1WrG7jRon8BC?=
 =?us-ascii?Q?1yEFPY+SaP8UmRChDHkKfADhHceBRgYPZ1peS0eofDtk3ZiP8UPDukEor6yE?=
 =?us-ascii?Q?TNiu2MWqskv1mLEqTZxs4oFA0zSAw8GSlXGS+CCZNi5c21AIzf0H8Wb3O5e/?=
 =?us-ascii?Q?otakrHsT57dqxbzeTf5f3QigYNbBDkyCLX0qLfNtKWHcpkYu0CPiMyfyWlWh?=
 =?us-ascii?Q?81ITcW1QVE7DwEc7r6KgCvyQLcGoPtss8WBMqAXj57f0YOwsptvv9GxemUiI?=
 =?us-ascii?Q?/b87bMsnZOpQkHTzHUz13gtBzs5yJRfX/H5lPyoL6GBp+lfh0QPQAPZqwB7w?=
 =?us-ascii?Q?6o1qA3uvJ01l6vX41lsDGwiz/0qaINFn5y+b0C7K1iHjChypxegiu3gRdQWK?=
 =?us-ascii?Q?AjTqNS7oy7VpYWYj2CnZYLaa34ZBHemyAro6zn9UuQbjIXNk9uoI8/lmt/x9?=
 =?us-ascii?Q?6CdTEDaQI+7Ip0xrLFodgNax7BtETavTBQVyfKIpjDZEbaAi3I4CaZpGCwZU?=
 =?us-ascii?Q?OAot2GUl4cZG2YNy5LIrZs2tWshmEbRwteHJ0lUswgJPWeMXgPcXnOtTuGPI?=
 =?us-ascii?Q?jeovzRabFXjFA6zYKwV0BlobXaNGeClKKKQZrz3ICPo8NV3zfiSfaN6kOPjR?=
 =?us-ascii?Q?0yQUhxRcQZLCr1sqs51DglYqSYhj6nifzW/UXO9y2xgvxswXA+QuoRUdlJni?=
 =?us-ascii?Q?rcDAHTL6Df7eGkDix7lUApQw9IGP+vLKx6QMQboFe7ewaO0GqkavXg2q9dZz?=
 =?us-ascii?Q?0w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RlT0DwQ9JqoxxnPX4IeMGkSwR5eWl9s9DRf8uYEvteC8/m9s5fNlo2xXFvBcX4tj7y6q2K2gi/xbwThZGtamvtbNiKAXcscnD683esGUeAI2dgpoR42t7k0oIF2f5xCN4tnPhhuO0Je0jIMZICpzCJ8VP2/UEGqZnpsxO0xHZyb5DQ8NGpC6FXDX5YMmqCrmytQzd1naGQ5yPeMm9h7DNAHdN2QhpShlZXTSSSjjJQ8wdzMMQ8uNR7Gio5tTftmpTTr5RijD1Gm+PvQQzP5Xmqd3rL5AzCMC9RnK9vnUcuaWJ8W0bbAa0Iby5ZBivIlSb7NWOBI+DbLtmnB+7WL3uOJCklSuMAqkeXyT0a3MH2SUp1MGrhpJ19tj7mg+EmpCh2A3mazWcsYKZ2cesTdJz2bNIB0oyodMPGU4Qp73YaXZiwdryX2cBhDiVOKwCtVIMeZyy3aryROtQIns5kLUzzGe2OGIBa1vl9rH8WEav1Nh8FaLWjXNTgizbaTZ4O4PO5i9QXqo9xwAZWTesMWwDeHX0xUdHWuqwUwxmktL9lH55foYa6v0//103u2y/IEsEttxiuaZQYFjNvn9khDG/bPxhJOdvQ4EqATwfRwsgGY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcd91de1-ac3f-45d5-5bc2-08de2763f15e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 12:05:33.8624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DZYWoO9SdgyN9Wzd1Zaa9aHItspRaSW9s1PLBumP7bkbc/KKRUBozYirfJnMgV8mX3ZLFHb1Zmcmv5V6fEunGnkrDHR2K/JJxC1mI8XvvPw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4758
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_03,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511190096
X-Authority-Analysis: v=2.4 cv=OMAqHCaB c=1 sm=1 tr=0 ts=691db291 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=_NnVvNaueK72BoXf_P4A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12098
X-Proofpoint-ORIG-GUID: skIrKfv8O1-SD0RiyIjR4J-EUsKVwmM9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX8M7Gg0KaVsip
 u85zvi0+FiUPSN/7EbtZvdkpbQWCR2AXeWN7sJnaDUTc6eO0490jY6WqME66tqA1nSXg8GCXEHe
 EgtZ1r5bnwQnBXJ/WA/NZjcS16dcDD/8otCzrDCFnVple/sQd5zDHwEh/36r/uBwTPFKY8Sxhpd
 vT5jtr46xxIGHIEOteFe6sF69GpxeynHNkHd0e4USTSgblQHi5PclRP6fkd7a0IpE8taGwooZkx
 cCzoWx7IWtQeNOKpwKF4Ab+Y0riiKxPs4zrlJrO1viMnFiayNlltVN+YkTOOoxe/0OOQJSTBj7u
 rcmIb0nXt5xd8vAcEzK7yqUyaZCwSkDieqgapiPeH+fk1e5GGf3YT1lEW5i8WEAxS2dMMBZWoLM
 iYvA78mLQulplzNHFlY7Mp6l3lFTIbRHhz+/gFy2hOqeuV/guwQ=
X-Proofpoint-GUID: skIrKfv8O1-SD0RiyIjR4J-EUsKVwmM9
X-Rspamd-Queue-Id: 8D6C01C0010
X-Stat-Signature: h8nwwjt4975n81fn9dixzrwhoc7tg73o
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763553984-853926
X-HE-Meta: U2FsdGVkX18iV6FzPFeMY9C1CJJoGF7OVeqRr6urzIfxnRbPxGjGXYBENlJR3VI2eGaK9znZfWIlIScXUcOpOZDf4/+atwN/8U5TEe7W1nb5xFU3jQwdDSSAE4C9KuRun4SyBYpwAD86jc9Dcmpx7aOkv05RbrmpmhjNl8CHUdIWGbhXOF5nq9od/89MUGYCneqOfpOvRy/QTGGmTS9CvKoSCb9/HqnqcaHUa9em9cd9nD+cVYaQW7HdtlfhM4dDpqD6mXlJ+8a5YQqeCE0kYH2dCLhh9IppaK9U7gvZSpkYJRHVbG8m4Xks66OnlzoZX9/4wgmmaFMRLYMl/tYAYFUQp3bgwDGtd1IOoPnMg67GdjK+kRMbJu4HJwG5BV31ATAv6f531w6tYS50C8N8o7w8ItVRcLsiBXuVLlMx7IY9nSMJ33lmG2RPoUemzGhoprFvtfaXNDv07+YIWuP9dj85rdSdGhOJtcsrdgWXTGTLbvlBklF7Vre5SAHyRQkadbANWFHaeKMKreUGyo5P6LTxrxeo8F917GmBhxAFhBvNR4jrQSGerg/7letmGH85FsYtw+9AVPNBnqbc9mBJnz+jXk0cB4mIM/RSt3Atr6m5cby0/uN2qbeKQRpzZrnlWxN7S7QxPefTm9lSbqvxdrBD4mIdNyKBh7SFIiMf06dqOcU9xu3h/gnGvUjdQqA+L61r8Js9U8Q6XKDRnoZyKH9ZJ6NvToYAXgbbHfArLgaXYJLUOPY2mqlu2muSNJtTXj3m/pDaYkn5GbvQQ3gkEyUYdndwav7ZAAxZdbvWrqK3bFYnh2DxAHvbAnYn6U02tr9ywUj2iSKYCQJGPShpHWxfGDE17QF7u+d4c33aOuz+VI5qmJE4iSKFLyH8qWZXnOCa4LU1qqbyjda2LOoCcP+cNRnx1hFkYeVGJVeRoSXDbfIPltn3zUwRPrAt0TC2nB+m4agTAx/k6TH5Eot
 +rBFHJgk
 v9QFTiXJsNEmpV4rLZSRPhXOWfB15gh4FJa0RotlVdfwFSm3EDCPoopKLX8C9H15uXz7aIH/sVEcCH+p9YhhxZFtBPzRNtLS4SuDNUTIs2wdtv6+IP0gnOEv+8enpoadyX6HIyWreGwIFknsOrEf9seJtnUSahfL6gv3alWrVw6Df1vjNb57b4ONcBt/0dirXx+SKf/hj9FaN1xy7BXKCfg8bt7cnsDDRCBejoY9R7MPR4beJiTFUoQFICYo+iNKyUSyTbT0OJyZ1cgAYRoe5SP0KTk+qdHs752buPpa1XXRdl6rrBWxhMPwdcDg01j2di82tjbP1ljpG06If8zrdHOSMNmGBVyvWLvNjgovlVQ+A63kQ6b5wIJlV7xHRVT3qTt9O6NeYZwMMwKaMQBPcBtGXErHl7+ZyBZSne0Ph8Sbm4e01IIm7uzB9hRogpTdYkjK6DEJEzOhdUiGrab0lB9iIq66dAe1vrSHESazpyJMDKZINHtyDhopdRLwjoEMHTKkSQlqn2jb9p8izpn9gCL/erjc/NPJhX+CW695Jzxp+iV+t/QluV8PxKP+QoV64CTpxkVpLi4F0hsuYTNfesfE7gbzr/2npageVq3EJ83AXWVBQni7TgaxbAcO+R4rvVH5DkTLSY4wDucCJOAfcm669s2U2HRPjQkaYFhkwN42HHp0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 12:37:15PM -0600, Nico Pache wrote:
> There are cases where, if an attempted collapse fails, all subsequent
> orders are guaranteed to also fail. Avoid these collapse attempts by
> bailing out early.
>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 31 ++++++++++++++++++++++++++++++-
>  1 file changed, 30 insertions(+), 1 deletion(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index e2319bfd0065..54f5c7888e46 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1431,10 +1431,39 @@ static int collapse_scan_bitmap(struct mm_struct *mm, unsigned long address,
>  			ret = collapse_huge_page(mm, address, referenced,
>  						 unmapped, cc, mmap_locked,
>  						 order, offset);
> -			if (ret == SCAN_SUCCEED) {
> +
> +			/*
> +			 * Analyze failure reason to determine next action:
> +			 * - goto next_order: try smaller orders in same region
> +			 * - continue: try other regions at same order

The stack is a DFS, so this isn't correct, you may have pushed a bunch of higher
order candidate mTHPs (I don't like plain 'region') which you will also true.

> +			 * - break: stop all attempts (system-wide failure)
> +			 */

This comment isn't hugely helpful, just put the relevant comments next to each
of the goto, continue, break (soon to be return re: review below) statements
please.

> +			switch (ret) {
> +			/* Cases were we should continue to the next region */
> +			case SCAN_SUCCEED:
>  				collapsed += 1UL << order;
> +				fallthrough;
> +			case SCAN_PTE_MAPPED_HUGEPAGE:
>  				continue;

Would we not run into trouble potentially in the previous patch's implementation
of this examing candidate mTHPs that are part of an already existing huge page,
or would a folio check in the collapse just make this wasted work?

> +			/* Cases were lower orders might still succeed */
> +			case SCAN_LACK_REFERENCED_PAGE:
> +			case SCAN_EXCEED_NONE_PTE:

How can we, having checked the max_pte_none, still fail due to this?

> +			case SCAN_EXCEED_SWAP_PTE:
> +			case SCAN_EXCEED_SHARED_PTE:
> +			case SCAN_PAGE_LOCK:
> +			case SCAN_PAGE_COUNT:
> +			case SCAN_PAGE_LRU:
> +			case SCAN_PAGE_NULL:
> +			case SCAN_DEL_PAGE_LRU:
> +			case SCAN_PTE_NON_PRESENT:
> +			case SCAN_PTE_UFFD_WP:
> +			case SCAN_ALLOC_HUGE_PAGE_FAIL:
> +				goto next_order;
> +			/* All other cases should stop collapse attempts */

I don't love us having a catch-all, plase spell out all cases.

> +			default:
> +				break;
>  			}
> +			break;

_Hate_ this double break. Just return collapsed please.

>  		}
>
>  next_order:
> --
> 2.51.0
>

