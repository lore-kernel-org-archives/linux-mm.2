Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C005BCD8C9D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 17:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E1A38E0003; Thu, 13 Nov 2025 12:29:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 091D48E0002; Thu, 13 Nov 2025 12:29:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4D908E0003; Thu, 13 Nov 2025 12:29:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD29F8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:29:25 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6A9D789F64
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:29:25 +0000 (UTC)
X-FDA: 84106270290.29.BA1025E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id AB465C0009
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:29:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=afAsOJcf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vGWwNJe5;
	spf=pass (imf10.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763054961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a/iOWQ5kDuefJ3SEC0aRUPx/FSor5iQvb3qTOG55S0A=;
	b=q1XbUPS/B7Eh/a/HoU3rgCnzCEnHS0P8JHq1gRA3j/6Gt7OO2cQrKe7nL0CwBWYycbQs7d
	owNDXcJMd9VKta66va0r8DZ5FFPRQqwQ+2s1Z25aHzantKpdLOPB3S3Ms1Vkt/w5zrLRy9
	4lza09MuEFtnG1quFz70Wj4afbV5f3U=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=afAsOJcf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vGWwNJe5;
	spf=pass (imf10.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763054961; a=rsa-sha256;
	cv=pass;
	b=JnjOKXbXu+ufwR126r6Z9xrBe8D6FtjVfdn7N8RjMbCgLZNdPAEO6bVQ6QPPMj2WTNtRAk
	LLm06V8KXMMyoUe1WGd4J8Tn33qM79kKcGlYs6o4NfflQwfe2NyvkMiAwiPnyEYskh5w7D
	OWHtQ/RQmD8Q0XYW3cRFGIc16ZTZo3g=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADE9tKE023875;
	Thu, 13 Nov 2025 17:29:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=a/iOWQ5kDuefJ3SEC0
	aRUPx/FSor5iQvb3qTOG55S0A=; b=afAsOJcf6F0OPd3w2025EuHdkHn74fcJl6
	o2QDWAUoRQIrY0E8WiaplxhS+eLcWE+NQCCoXYAsUmX2IAwiDf5J8JB8KpiupL/i
	lrHPRF2NCpp2XbB5RWzBNkKskyynldc1EoeqIB8V4rD3DX2sS4mn9sx9sDL3RsxF
	bpoh+r8qYZvzI6GsoSVbYn5qPzQUXl6ZJWx/uvRMSedEelQYRbXBr2PaGYU3Ms5/
	ypW2h5dt+77413iVOe/dE5qH+QkrR/76E9dzFYZ5dlIeSedw2mEQ9tzfpmq1Vq4C
	LKzReoyVznvqIvdRMk2zD0MX9PJr0PgAMoW0+jfTfFOqtm+2qGfg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acvsstrp9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 17:29:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADHRbNO027915;
	Thu, 13 Nov 2025 17:29:06 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010034.outbound.protection.outlook.com [52.101.46.34])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vaggdkp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 17:29:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VqgHm7vW9TbD0I/W5Z/q4AW8POIt3TjvqltT2jelV8tf+95c4uDxKbAtwZjIscG5YJxoW+n7KErW+r+45TlBR2iV4efRo7bJ1nZOreRo5LVQa68TxsrXQcphbzW9hN9kRqrOaC7Ma4R8/+45OHgwfX2ChHpDXgUw58JbOkIisFoid/8sL+VjG/J70cOCskVfHG0QArvxP7v1ju9pVswP4SbQ7wpIFfsXUAQdzJP/uHK2BIYqDExaO3OXHc/0uw3yTvNPMoxxhlipflHIdcGeu90rXHAyqbWasgBMtqC9He1RRmJgdjLKBCOry2uife5Ukf0U/K5grIW0ju1rZqh6ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a/iOWQ5kDuefJ3SEC0aRUPx/FSor5iQvb3qTOG55S0A=;
 b=YrMFwPCTALUahxVpadPvqWzessxmKtruJhrvrqI53PfmWp5UHuwlCuGltdDyvNaf/5akmxxK8FiPnyHSfk6FeawHGq1lR6VgrrDR/PnRZgsUeZzpPIj5xCv92h3TaHZK+0QJ/yRIO5lqCrGwXJdYz5aymok1ByGaIsVya6MAFTVFOuHOmD4Dv6HdK7uBQGNwaRPEWnHb0yAB79vZbz7IcgMJ68u8oHAvVXdcqhoCBsjoa5Bk0z5f0aqh2VEekbf+TaeOjD83vLNHCGjZBqNuxGLMNsA1f1W4ifTbKHUexFqWbsPn+CV6vePvIpnqxdXR7UOvBKwQEd5d6JPHQldTNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a/iOWQ5kDuefJ3SEC0aRUPx/FSor5iQvb3qTOG55S0A=;
 b=vGWwNJe5TrGcyB0wN3NWdRxbTQt5OT5CJQyBmnw+UWAdmiA087PgKDvdsCmS/5cvMX3/VI2PaHA1APL98cCppUUxS6qiDLnKCj+1w4sE/DDK2oug0W/jg9qKT8R3eCzg9gcVgWOb0bBBrEIQfGk/PBN0R3dw0+jJj8WU8gOHxYs=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MW4PR10MB6509.namprd10.prod.outlook.com (2603:10b6:303:21b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 17:29:02 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 17:29:02 +0000
Date: Thu, 13 Nov 2025 12:28:58 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        stable@vger.kernel.org,
        syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH] mm/mmap_lock: Reset maple state on lock_vma_under_rcu()
 retry
Message-ID: <ajnzlk33uzmbt5tdrv7m7cr2hktt7acuruunx4s5fwwvroc5ad@7hnx2ys6gj35>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>, stable@vger.kernel.org, 
	syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com, "Paul E . McKenney" <paulmck@kernel.org>
References: <20251111215605.1721380-1-Liam.Howlett@oracle.com>
 <2d93af49-fd76-4b05-aee7-0b4a32b1048e@lucifer.local>
 <aRUggwAQJsnQV_07@casper.infradead.org>
 <8935c95a-674e-44be-b5cc-dc5154a8db41@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8935c95a-674e-44be-b5cc-dc5154a8db41@lucifer.local>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0336.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::20) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MW4PR10MB6509:EE_
X-MS-Office365-Filtering-Correlation-Id: 07536426-382f-4284-15e2-08de22da22f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1LVE2dttlzZNbiOVrhpbl1uiU3+w04wlmPLcnPYyX6HX9IUtvGP+wLET64b6?=
 =?us-ascii?Q?P2Z6qgguEMeCJBVPzu3FsSgNrWotgcuKVTzcO3t5i8QVAOt3KU+iOcRxYFsV?=
 =?us-ascii?Q?xafwr/5Oe6TtMubISnpmPD2Jz5fpN3gV/Bfron2AZOR1t8mOT/77ZV2zIbj7?=
 =?us-ascii?Q?oHUt4NnGnHbAfQWKsP+0baj++YZhfhu/VqY257yKQqPwydKhx8pBbNZhYzyG?=
 =?us-ascii?Q?YuceHr8PFmXqNvcg26ZgulDpB0VBRUhCBwS+zBcE0RqCCM4uuipFcYinDw0S?=
 =?us-ascii?Q?uyiUEWW7hLqzFHpckZT0PvwgfsfQhX1yQFw6tT7tauMQWb3MWhA24iN1qUKX?=
 =?us-ascii?Q?PpZBmmTtuFmFZo8p95RfZVdejEKmYAXriZ8gXg8yWMU+YfOkWTwtncnh82Rk?=
 =?us-ascii?Q?vmhyLt5IY/yOf8QvEp0US/ZvDxjZeLZAluPjh6p61K0Gc7j3nsfRrEFjGYfy?=
 =?us-ascii?Q?QJnR1bB0UCXPmscKgWKtAQOv/iUr3+5m+i8TryAtm5owYEh/24TzK/xqxSTN?=
 =?us-ascii?Q?fLz3tZewE33uIZVfnLnOYQrzhL8nc6O0C9VzoaUnpET/stUC0H6yhHe1LEYH?=
 =?us-ascii?Q?Pm3+HavIezSH1WTvzi0gfyi5OXwkFNIJnTz2YkgsXKnPx97sCrMHrgzYJ5YK?=
 =?us-ascii?Q?45bCT56tZFf7/jezfg2F8jvXV6D6LJL2wigN4W7gUJ3GnuMRdOMnWHaCnFeM?=
 =?us-ascii?Q?/br6vOxNj2uKyLfbptVm7xyhmMI5TNeErWAvhwEo4PWzSQEHKl0Arv00swX2?=
 =?us-ascii?Q?I8c++nf0zjLAIbrhGdWU1mBiGM7+Ahp4ZlSdCaC7xV3qHp/l04FttK2rwewv?=
 =?us-ascii?Q?I+GVT5eAjRSVpcNOnxSNwdybVQ6jyaLVBVaxbKtnb4vzv1ZMJ2nBSlNCpl8O?=
 =?us-ascii?Q?qhzRd77gkPUzNidepFX9kFkf9htwzYUIZbuTIG+KqITX9vkovMPLIMkSRPsG?=
 =?us-ascii?Q?WhnF/Y4n41KmZiCa0+44NPPhfpkM4E+rhJVWYogpzsIU/xTpG+GEz4D22NvT?=
 =?us-ascii?Q?3y7euSbQSfT9ugNa2NoFPU+r1LIE8Y5+rPYhrU/xAebWIqnhQ8/uoJV6XU1y?=
 =?us-ascii?Q?uisGKrDzT0h+1nKHkrqddkMCSe2sCvF21mRsEu2ieJ9kNsPlJobOmKzqUv58?=
 =?us-ascii?Q?d+S6oDd69dT2ov9/Jg6ifdTzFcDfz0wBtPqQg1djIUgv0kEHLoB6TAdcOj0/?=
 =?us-ascii?Q?j+kj/9GJUSz8xy5Sx65RsxChZx8+4tV4j526MZjTKSGxnjFxr+0jVSJl7G81?=
 =?us-ascii?Q?Pi/bkyhuaa1cYem4QxBSwpZEVQHWfPN0XGTQ7usqYTPme5r3PzIVmxYmz/sJ?=
 =?us-ascii?Q?VHt5T1NI/+zQp/iCMbRq1sOpxJANY5VBY6IF/MgtRTPE2ZOX3HGO/ZulzWLX?=
 =?us-ascii?Q?kaBhih41H05WilSf/QDpWNmoTBxZ4TSxgbNVo3VAzZnpllDR2T0wepCKuqt7?=
 =?us-ascii?Q?DJpaBCan0QtPJQjGzf0mN57l4SAcMnNU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bBY/hV7G6Se8aV9WI3c/w0K2FqoGNlEddWaXmtewqtlVqvnK1pEHCLsHsY+f?=
 =?us-ascii?Q?hPHOnX6mfX/4xgVSREu6yw3ulZR9rZbL6oIvub/e9n4PRGOo8pAlP9kqBmnh?=
 =?us-ascii?Q?YFrZSkf9e6pEklNa+yIy8pSghr1A+XpAV3u9FcdKYn4G0FW/JK+/RiKpYx5m?=
 =?us-ascii?Q?hDXprHyOXCNvQCM3UV2CZAqBCdahZrx1MQ6b/5AV3ohtznPxaT9StwRQst+F?=
 =?us-ascii?Q?V83dsj0MW5LPUrgfVWnA06Ze40uinclaR7TD42uuPvEuRclKqMxWQfDxvAyM?=
 =?us-ascii?Q?ceayZMVhklYACtvif+Zcf3IZr+bugEPr47KLv+FbN/YKNXeJ9PPyX19IDtNH?=
 =?us-ascii?Q?/lbZ51lZ6rMQY4Fs78+mCpf7s+94WipA7M5mhvrzZP04BM2vQJG7HNChgJ00?=
 =?us-ascii?Q?ATudk4yS3zbMCxkrYmPbDOodcO1vSY/v1ejCOD8/GpixoNOCBd2vzLYUVdGP?=
 =?us-ascii?Q?tV9PhtGfCKJeSyN/cufVhwwecCbsQI2DViztDuAGYjp1YD2qV1yCaUhYqiU8?=
 =?us-ascii?Q?S3t9QtEpIgfm3/Fj1a+5MGuioPKjra7j+3CMeKKKf0WxP4SBalpR/23jPSKy?=
 =?us-ascii?Q?Db/4gX7OQ9uYgHUQl/FAH/CEVz0GlTn9eWyJ/EZ7tqV9EJYrMJOz8FNZtuE4?=
 =?us-ascii?Q?InRLwjRlhXMWZbtjoEDcJs/Eh3R7HLDy7WOOdsOhP5CCvY284LkCIO6dA+O1?=
 =?us-ascii?Q?HgKPUbUbdegvDUBSVrhvhNdT8CrPnBD8mfYyc3ATFIIJaS/bpnEclQx/ETIC?=
 =?us-ascii?Q?Q7XKk2qS70sx/e8CA6nY8VQZOJ12qdHGNMSh1JjoZNMOvqAeqkhJdAZg7a+2?=
 =?us-ascii?Q?iz4nPBNZmLi0fW/nJoIAxb3qDCPukn4ACMDAfbyJzinsKlfPQqWwVl+flFz9?=
 =?us-ascii?Q?ll8CQaYMVQZQoCJwJb2M44MB1UuseBHNI+Jw2IFJmZoIdzoO7uvOaOCiCUMZ?=
 =?us-ascii?Q?wIS6/+b5bbeg/vXzAHZmlm8GXIBCnNgYbvUcjh8b+En4o0TTvwY8q8AGH502?=
 =?us-ascii?Q?PQmW9tkciHJVM5DkVZDjA8mzcPT4q2ucfE+FgEgKVH/Kjs74husLgj1k8Taw?=
 =?us-ascii?Q?+guWpwKLCT/bxgpLuU7F8EdhyvbZIHqBRtQzI22HoOv2nF3NbBXe9Pnsvkne?=
 =?us-ascii?Q?+Kumbq3scw86w9Zr4NlDn1VHMf0pvkeG4R/5fTdq+k89gEdh6hGi68EwogLe?=
 =?us-ascii?Q?abMQirhy+LUPkpy7YLoNDR0K6u8tEnHLTlbYwe6fqqx+wcTWMlJKvuMp1czJ?=
 =?us-ascii?Q?0/6v8bMVLT62XL8Ul1VeKnIZnF+wvSy5rLVOeiAHezSmz5D3WsOfEjv4REXr?=
 =?us-ascii?Q?opBljqeMLJQfTIouo1uRF7x7LC5waUqz8GRpdWl400rTFDfYqBC40DColzou?=
 =?us-ascii?Q?Y1gIlS0I/NAIRKDI6ySHAY43fL0ObtUbfUne2sDuTpv5m+E6pwMHxwRdDjTl?=
 =?us-ascii?Q?g4nBsJ4k7rc5B+H7sBL7JvrID0muAv1BuVADZlcDg125+G5aa63d5UD0/S+v?=
 =?us-ascii?Q?e/huivZotspEx+iBiua12oVLgDva5/iuTQ9UdKZtSWZ1Ar1cMbG9bGCtmG4/?=
 =?us-ascii?Q?gg1o31z9KAgUCt5EMxJFv3gErfj57cN/h5Cu1x18?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RT7a2sw2UDqHcgb5e5uEHYL/uLUR5+0ctpX7OW56/+OZucnNnRYADJwRokQ7axqklALLoD6a1QZwDQX/ZabbHfSmBjy8OvAALQi65Z+CJlbJ1TLRiOfsHvJKF1XqdWbsf9F+0Cv6osBlwJ+3139yUtlWonK4/kxGZqrlUZ3a5N+Namf8nwax29nF4/Nqr8CA535GBcr6i9HdcQ7cnmAGOi6gZ6kBEmSOrq5TCmsKs5dInNYebaa9oh/h/0X+pwjjWOot6pkHHrW4qFa0SuQdv6/Ssl2iaEzuJLLupLu48iZX9WPQ5/ivMi/gbtTONr078i2EH+R9a8JSfjGV7ISL90JBbCLvK5SiFYJDrBObjbr3HvP0c5Lnnm9U97PGluvNSCiWi5s2WapzaUz1SwZVCBy2ntEm40NzxwfP0a9CO6xeq0C06abwvZXisGoeUYeVLKGuKCEqE+x+eQCx3872owi2X2hc2xvjzLTA5GU/4P8qXi3oXbCh/M4kfX+nsqtwtWhHbM31YrDz3bg2/cVz38J/oy8R0Z8WYPek6wr9pwL8A8p1dNHLJVASJ9e75bB/HHcuEFikSCm7wCxOkCVLI6p4T/d1wMMhmOhzXIDeNE4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07536426-382f-4284-15e2-08de22da22f9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 17:29:01.9817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L4eEy6r/yW+CQceEu5zvkiSrLrpaPRoje23MDFDugjuYTSMp2svEpx30joyZrdqTQEAVxdnd1fzR2za2KuUofA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6509
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-13_03,2025-11-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511130136
X-Authority-Analysis: v=2.4 cv=bJUb4f+Z c=1 sm=1 tr=0 ts=69161563 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=F5XgVMqiaMc-yAvIofgA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13643
X-Proofpoint-GUID: TYz8gCiVUJb3uc_VjSDdrBJ1U-VzSWNj
X-Proofpoint-ORIG-GUID: TYz8gCiVUJb3uc_VjSDdrBJ1U-VzSWNj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDEyMyBTYWx0ZWRfX0XTC0PN/FxTM
 ZAvP7Zw7aHVoQsas9HsN25NTwebCJokb3GVN3tkuXVDe/1h2hJ/YgeLbbDgSYJYu8vUuqUINp0m
 hnOv7zMmyCxtAo99hZseBupn6FHmZTPK6I1XWcMJvq9QYdPp1QuCh3pbmvGHTIRF5QmPNHCziDW
 84ymLnqbSFV2xaJzUVJ8AHvh8xYFFT/2JmoP49EGHSoyX4Uy3et7ztRn6WPRnh4bSIXjjNlJ4vI
 3oVlhJ8jkRn8VSV0M2OZ+O6fk3XRVgkPIO9wju+eCb4/Wjp+hG8Aa5k/s+qbo/N14BBA9pzVAUW
 sPNJhh3NR9avi3X0cvf3WgtQdRAfWR2HGk6urtWGnB9nJao+l6ESPCz/S89ueGQP0FO9AQhQKds
 wVcCHJGl8A7+0G2xdj8XY9qjsbFF4lVzGy6zqbgGHjMYoujIGQY=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AB465C0009
X-Stat-Signature: u3aib1zkh8qz6m1jibox97tfrc89z9qn
X-Rspam-User: 
X-HE-Tag: 1763054961-849448
X-HE-Meta: U2FsdGVkX1/SnUC8m8TqFaxMT9nrd4OOY0PCzT4N9NOwbd6lUkpBXl8zv09EXdZCGgK5n1DzYIuw2SNnUDpZxCYcHaFpgnQliQHSbFSoEFEAYsvANhunO5wD3OACZU5LjwmBcJdoDAB0vdIZyYQLW8QlyOjIpHs/+UNbq/Jmgpg14sivmuvpJHrjxal+1AaXLPOLvwt2GMmNtUCD2aN/NV6MbYVtfq8o2ofBuCCwwbZknjIAfX1ra+PHFBty7acekmibb+3wuVgmtFLeGoMNAeBTGBQhzrRw/5DCPKd/r3TAhD44gjQbyFjTWC7tMC2aOJEZbVe8xMJ3wIxAiu3OCGVK+htfTu364TF+YuGTBaQTTp1R0Cm2sRHp2ZKWqaBleIrhC7ePcd2jrW4P1bTOGUeV65kTL8w2GN6aLdW7dHYs+XJAWbBtjRCXNQGA4Gj6jFAMXVVACl3KtyWfrvjrzIkf9r6zFLLwfkQ0/pIpRBtp7bdFe6Wp43VioEfd17+aRdzGKc5jsKaBEFW310K7Y0XDSNiX1tsMd+NlwbZGN6e0UdgE8Ub1VxkUabKt5yhAM6s1L4OXYPhJmgDVXSCMFfNfD3XqGOlYQVRdTTJzwgPDfp1AXeujTlCP2QL0JdGXlnaRPop4phWUekr3rXG9JGk5M8uuC0cwCC6uRv+f2o6joEMNH0YJn5Xv4qGxBqRzC3S48G49kC4SEDoDCYO5srHB1Nt+IUn5M3u+n3iqQ9XTwGgjf2vwx5w6FG0ZjL6YVluq/jlyjyIer4BlGz6LGbpHjfuuT3MkI1jIEEcxx3JhK7+4rpYtcKLWkWpCq5CPtgSXLGutgWb9F8svHeW2+dKXfxqX9W0rb0vX2k4esYKPULet2bMR8yM7+7kYRYUAB9ykHzPmjNxdiju1QVQs4zQOSSjk+OCCIn3JWXqvyXJG9Q0OKa3hrxKN7xHjDcaFXoFXzZXR+kIT8GKXHwe
 d6Kcn3Wz
 NHwGqRycEr41I8i4KxYp5oG/6+wlVsATxHs8tHhFENFrWPIEgWIMpSTmm6CoWUIS3AiDjsBlpCVdHGsixEle6GNnQO+ZUWJWVrHDM5DHH+DPA4B6K4wQmXXsybaBEYU0gNWIdZ1OligHD8Gedkugl1h8PyzIaxgBblqB421sG5voMR5yVBCtvwMqwRL1kPygT1M6RvyQi6oW8yJ/XJ6b6DI4qp/NOVg/COUKHtJ7N1ZqHRc1mR03eiqYlemwxed/MDOGRr0dlR21QJ3tvEMHxgm6qbXOLRfzu4lCTocJhiXQACcqQCyV8fmiXnm51/hbs/MB+TZt67yP/aMGC8XAgUBH9/JsoPJwVZhBDQb29NJPGVFsV2A5cE88CzXsIeOF/BH1geMoDPoSRxVGRoXSPvdFFgE3+O72rGavMshZuAFsEY27GwMJcpQLUaitzdUPLLlL+c9bNNY8XSMBCLlUKv3gO5jNcFgNsGBzIxRMMbGk7lgQrhgnGDUsA9fi0y02Xu5SK10asrei1inlqyZ1QcKhLoVlpvvzIRkBUDMBp+pJB6FquOG46vF6peIW2X/Ekb+BRB9zitMTaKzFZH30UJOnPNIWafInVJpv6x0drcK2r7X5Y1G2+RQhuZPLZElp6/3uy5xhc4A1uVS7wFzSNo/0dylRGj8RHNOLNJnEHjxAz7CUzv867W7R6IUXYe/GJSlziQFrMCfXIddwJSWGpxvhld2RAfu03S/PiLkmoMHLU3fWxA1h8DVP9k0knnq/3ljCgcsiOhQcjDYpEEea7yv2/4Im3AXjt9j06
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [251113 05:45]:
> On Thu, Nov 13, 2025 at 12:04:19AM +0000, Matthew Wilcox wrote:
> > On Wed, Nov 12, 2025 at 03:06:38PM +0000, Lorenzo Stoakes wrote:
> > > > Any time the rcu read lock is dropped, the maple state must be
> > > > invalidated.  Resetting the address and state to MA_START is the safest
> > > > course of action, which will result in the next operation starting from
> > > > the top of the tree.
> > >
> > > Since we all missed it I do wonder if we need some super clear comment
> > > saying 'hey if you drop + re-acquire RCU lock you MUST revalidate mas state
> > > by doing 'blah'.
> >
> > I mean, this really isn't an RCU thing.  This is also bad:
> >
> > 	spin_lock(a);
> > 	p = *q;
> > 	spin_unlock(a);
> > 	spin_lock(a);
> > 	b = *p;
> >
> > p could have been freed while you didn't hold lock a.  Detecting this
> > kind of thing needs compiler assistence (ie Rust) to let you know that
> > you don't have the right to do that any more.
> 
> Right but in your example the use of the pointers is _realy clear_. In the
> mas situation, the pointers are embedded in the helper struct, there's a
> state machine, etc. so it's harder to catch this.

We could modify the above example to use a helper struct and the same
problem would arise...

> 
> There's already a state machine embedded in it, and I think the confusing
> bit, at least for me, was a line of thinking like - 'oh there's all this
> logic that figures out what's going on and if there's an error rewalks and
> etc. - so it'll handle this case too'.
> 
> Obviously, very much wrong.
> 
> Generally I wonder if, when dealing with VMAs, we shouldn't just use the
> VMA iterator anyway? Whenever I see 'naked' mas stuff I'm always a little
> confused as to why.

I am not sure why this was left as maple state either.  But translating
it to the vma iterator would result in the same bug.  The locking story
would be the same.  There isn't much to the vma iterator, it will just
call the mas_ functions for you.

In other code, the maple state is used when we need to do special
operations that would be the single user of a vma iterator function.  I
suspect this was the case here at some point.

> 
> 
> >
> > > I think one source of confusion for me with maple tree operations is - what
> > > to do if we are in a position where some kind of reset is needed?
> > >
> > > So even if I'd realised 'aha we need to reset this' it wouldn't be obvious
> > > to me that we ought to set to the address.
> >
> > I think that's a separate problem.
> 
> Sure but I think there's a broader issue around confusion arising around
> mas state and when we need to do one thing or another, there were a number
> of issues that arose in the past where people got confused about what to do
> with vma iterator state.
> 
> I think it's a difficult problem - we're both trying to abstract stuff
> here but also retain performance, which is a trade-off.
> 
> >
> > > > +++ b/mm/mmap_lock.c
> > > > @@ -257,6 +257,7 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
> > > >  		if (PTR_ERR(vma) == -EAGAIN) {
> > > >  			count_vm_vma_lock_event(VMA_LOCK_MISS);
> > > >  			/* The area was replaced with another one */
> > > > +			mas_set(&mas, address);
> > >
> > > I wonder if we could detect that the RCU lock was released (+ reacquired) in
> > > mas_walk() in a debug mode, like CONFIG_VM_DEBUG_MAPLE_TREE?
> >
> > Dropping and reacquiring the RCU read lock should have been a big red
> > flag.  I didn't have time to review the patches, but if I had, I would
> 
> I think if you have 3 mm developers who all work with VMAs all the time
> missing this, that's a signal that something is confusing here :)
> 
> So the issue is we all thought dropping the RCU lock would be OK, and
> mas_walk(...) would 'somehow' do the right thing. See above for why I think
> perhaps that happened.

But again, I feel like we could replace the maple state with any helper
struct and this could also be missed.

I'm not sure there's an easy way to remove this class of errors without
changing the basic tooling to be rust or the like...

vma_start_read() is inherently complicated because of what it does
without taking the mmap lock.  Dealing with a potential failure/retry is
equally messy.

The locking is impossible to do in a clean way since one caller does not
take the rcu read lock itself, but may return without it held in many
scenarios.

> 
> > have suggested passing the mas down to the routine that drops the rcu
> > read lock so it can be invalidated before dropping the readlock.
> >
> 
> This would require changing vma_start_read(), which is called by both
> lock_vma_under_rcu() and lock_next_vma().
> 
> We could make them consistent and have lock_vma_under_rcu() do something
> like:
> 
> 	VMA_ITERATOR(vmi, mm, address);
> 
> 	...
> 
> 	rcu_read_lock();
> 	vma = vma_start_read(&vmi);
> 
> And have vma_start_read() handle the:
> 
> 	if (!vma) {
> 		rcu_read_unlock();
> 		goto inval;
> 	}
> 
> Case we have in lock_vma_under_rcu() now.
> 
> We'd need to keep:
> 
> 	vma = vma_next(vmi);
> 	if (!vma)
> 		return NULL;
> 
> In lock_next_vma().
> 
> Then you could have:
> 
> err:
> 	/* Reset so state is valid if reused. */
> 	vmi_iter_reset(vmi);
> 	rcu_read_unlock();
> 
> In vma_start_read().
> 
> Assuming any/all of this is correct :)
> 
> I _think_ based on what Liam said in other sub-thread the reset should work
> here (perhaps not quite maximally efficient).

No, don't do that.  If you want to go this route, use vma_iter_set() in
the error label to set the address.  Which means that we'll need to pass
the vma iterator and the address into vma_star_read() from both callers.

And may as well add this in vma_start_read()..

err_unstable:
 	vma_iter_set(&vmi, address);

> 
> If we risk perhaps relying on the optimiser to help us or hope no real perf
> impact perhaps we could do both by also having the 'set address' bit happen
> in lock_vma_under_rcu() also e.g.:
> 
> 
> 	VMA_ITERATOR(vmi, mm, address);
> 
> 	...
> 
> retry:
> 	rcu_read_lock();
> 	vma_iter_set(&vmi, address);
> 	vma = vma_start_read(&vmi);

lock_next_vma() also calls vma_iter_set() in the -EAGAIN case, so
passing both through might make more sense.

> 
> Let me know if any of this is sane... :)

The locking on this function makes it virtually impossible to reuse for
anything beyond the two users it has today.  Passing the iterator down
might remind people of what to do if the function itself changes.  It
does seem like the right way of handling this, since we can't clean up
the locking.

Thanks,
Liam


