Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCB55CEE34D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 19:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FAB66B00A2; Tue, 18 Nov 2025 14:24:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D1D06B00A3; Tue, 18 Nov 2025 14:24:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 099586B00A4; Tue, 18 Nov 2025 14:24:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E600A6B00A2
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 14:24:28 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7538D160190
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 19:24:28 +0000 (UTC)
X-FDA: 84124704216.26.D78BDCD
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1C6B440010
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 19:24:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SNRZ1kye;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tGEFTTwT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763493865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=frUzjQmVEjfXiXPDHMOulhn4s68ZZj6gvCnoYIdtVmg=;
	b=rRLbXSq3NH+8/Y9knnHV7p9bYFKhWIt1VL+3mPOd4hSnz89prYwekctqrrkQoNLvXXleY6
	SI8E0oReSOaLdUPH6w/gShjBcp2bJW7CngPCwutTNiLROfMNUHbB72mCcJ4Sab53jsh5Ne
	X1TEEuIuugZLuhVSPpdJat+eIVoPyH8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763493865; a=rsa-sha256;
	cv=pass;
	b=hhMZA6rQWTsC6XLrxMHkzApo9GtxOJUninOBCZXU8hmvH/HfIr11awx12KbbFWuJzP+lfM
	qZ5o0BgLIzB2AK0UDB9ecGVcjf3VbIjHNpAQcjeqiBWUQ8ijjY0dWLDWSQAAusMhZOeYoE
	zAOAZNy1mBHS1pgE0wDHyBbgvsJGwVo=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SNRZ1kye;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tGEFTTwT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AIHNNcS007983;
	Tue, 18 Nov 2025 19:23:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=frUzjQmVEjfXiXPDHM
	Oulhn4s68ZZj6gvCnoYIdtVmg=; b=SNRZ1kyeyD6uevVuUk+nbGLnGDG6dG6dzM
	bV/KX1TQbfjB4q3q/2o9RM46IEgbmmK+6ocBjTbbT1UwbVUbe41DYgLywx6O5CMi
	9ZJrkWib0s034PoW7hFZDzzYtyypRB7Xz84r7mf8yuh+a3BKu+KRMNf49KDDCT3P
	L+b29MMEMFeqz2BdW/SV7cmkq55g1jUis9NxhB0isRhyfspAKrNsw2mufQ1b+vuf
	hI2Xc/FJzcZhze2oJz4mqadKijYhy0Dboj48mb8mKTL2IRHv5wcKwsRGb2As6BNO
	txYunWotReqciPGWo//cSAsN3eLhXd5XkRhc3MmzGAat1ulnp/4A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejd1dfnu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 19:23:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AIHgGx2007832;
	Tue, 18 Nov 2025 19:23:40 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010018.outbound.protection.outlook.com [52.101.85.18])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefy9k55k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 19:23:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hdSQWJDj6L5NGKx0WS5ZOQQI8/WYMOANDGYcMX0MOuFksGo7La9K1N8hSL+2++H4HMoFDinK4QPJ+W8aN7RcDkEFXyuSMeKmqYCzkxHpi06uT/aw8pQRHrgSoS1snaq275ndurY4W7lIexclUs1NNi8bgZmORAdFoC/hDGmggSeHlUYuv5TFEOx6Pq7YLa0SNDOiuAEY1/s237tF1A9+GVzFoo59F/x5IhON+1AUHynpLEy1jvJPPU27OXXtUVKfT8eRXs5ww9SXaBZPqtKKl2PyBdSpsXAks7A/fyA8q7O/zHud02R7MDBXhfkSrGA8ZtdAXx/VyLDqrdcLmpK2gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=frUzjQmVEjfXiXPDHMOulhn4s68ZZj6gvCnoYIdtVmg=;
 b=vIXxTJ5BcQyocSE2OXbZwfz25Dxg02J/j8UJfPNirrGSgvybrKREgWjdNHDLNA64OdG6bLpwXejQj8PIDI2PvZ+D5Ur1LxrAISwM/PVsSCUrCcgL87y+ps3ryGT9076DwQRSRI/yvOy0c2msBahI2sydvM4eJaqow5ZaAopLXxoeHzF7G2ODXbTbOm7Zh7lvbuaUeOGs/T+i+kVBubHJiKsT20UvQMYA+F0/dCNAt0ALnJFTirjiERQdt4GrfkE3+kJoVYhyF1bKMfRajqgZglaWICLMM2ebxLJKxADnvvz0Kx99jXHprkLMUtobwSYM/smpZZzjlJU2l9mLcENhiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=frUzjQmVEjfXiXPDHMOulhn4s68ZZj6gvCnoYIdtVmg=;
 b=tGEFTTwTVVNxXdAiHDfhMcqS/aQJPQ01RwfeWZ2mcIuh9cFZdLuIs2k0yPHqFF/3V1leu/gd9eymjYbMfoD/RF5K1cdwBEEjZncJdzaWqN6pezb9Kt4W+41uB0nOrCdgBtK2ZlOO1TLCkPjD9qIWBc1CsYjy8bkHyA+rr9UcGSo=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BN0PR10MB5173.namprd10.prod.outlook.com (2603:10b6:408:127::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Tue, 18 Nov
 2025 19:23:36 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9320.021; Tue, 18 Nov 2025
 19:23:36 +0000
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
 <20251027202109.678022-3-ankur.a.arora@oracle.com>
 <11e86b31-fd8f-44ab-906e-019fde89215c@kernel.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v8 2/7] mm: introduce clear_pages() and clear_user_pages()
In-reply-to: <11e86b31-fd8f-44ab-906e-019fde89215c@kernel.org>
Date: Tue, 18 Nov 2025 11:23:35 -0800
Message-ID: <87o6oz9mbs.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0383.namprd04.prod.outlook.com
 (2603:10b6:303:81::28) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BN0PR10MB5173:EE_
X-MS-Office365-Filtering-Correlation-Id: bb2c1a44-eed1-435a-b912-08de26d7f877
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LKW1T7QhvUivISbXpGR9AYMMfXbJYzTLgSwLuKIXbW76QIHIsJ6yF3QbsgGi?=
 =?us-ascii?Q?oAyIMFc2tirFd7V/AF3BWDyowgzg5Av2CmZo8kKQ4ahcMUU57geDZ8BBRycz?=
 =?us-ascii?Q?7Jq9pGcCp07arkgEYkzldpKpilPeTtgXcph9u372GYc5wfzNO/yrCq6wE9YX?=
 =?us-ascii?Q?rPmG4T5S5HVsAG5lAKZ5f2XGx4kHt2LVOzCLMJ34xF+DLogL2yWgaAIaNvB/?=
 =?us-ascii?Q?uf9ryNGvQVVd7vHKHqj0TOYyUeh1E2PCdpMdvIxT6tBWPNiKFo7NF03wzBti?=
 =?us-ascii?Q?2u+3Mz1pfhE1aR7y84RgLZzKeAAot9ovvg8JxmCOkDcTwKkt9uIyceM7CIyb?=
 =?us-ascii?Q?L9tUNIAMIJTnbZtYXMnzwJnBt1IeGuJCaGaq+FYmM0BdQ8T3HxW9Sy5u7Ikq?=
 =?us-ascii?Q?GkvNg4LCGC26c2SGpQDazChvSQg0Pi4FpEs0c88TXbNpwdABjTT25MaU3nHN?=
 =?us-ascii?Q?7F88bFYqGGsVZCCqrpIZXDNgfMbjj8H5MdduGTt5MSkg7rcjsj2EeN8mUaZm?=
 =?us-ascii?Q?EMCQ39Pql1GDKjp/Wi80j9j+mupLXf21zuWaTyE7WjwafrKJ+GDJ0p8Yvgqv?=
 =?us-ascii?Q?PcnBpcex+ymgbg45mNI+gVJYeE8mMtzFfmNGhUsPFng3o/5TFwl2XcHdIU2f?=
 =?us-ascii?Q?+1TNBKXFq8b/YXkjVkRxLnOPaXkbD9m+Vf8AwY/nCOp/tFEwKSf6MG+3mrOU?=
 =?us-ascii?Q?9dKBpiUZgSrVBRvRCMbqsvfmCriSVfDgiYMSnLcMbcyX73nNVetwYYSEoTCR?=
 =?us-ascii?Q?Lc3MQoC6qZKosxT87tQJUAbzhb5VIlMn39JWWtdCOH4QLet9S4WrlC8T3/3h?=
 =?us-ascii?Q?Y/0QH+Yq7GVjPLP1Ayx4jGh1nn7CMfXQDdT9cGJydXrcSEHPz1TUcXTedG9R?=
 =?us-ascii?Q?xLMqXyZaxEz8yYSzRUIsXMHdczMvNTWuzLVEQfLuepQaVVTJWdqz3UXEwOJm?=
 =?us-ascii?Q?8ZGofHXq8nAVZpYWZAtF84zkksIufcjWlVFxX1q+HtYUrmIyUWqdWE0XLgFB?=
 =?us-ascii?Q?WN9Vh8+FpSeekc/HALZdngtQAWuKr854fONvqll4MLx8u2vPH2IG9Qa4wins?=
 =?us-ascii?Q?N0r2hjT4Toytf/Xkn7zyIhMneGQlqtYOPN+DSvGRnOmGR9L3EvpGulRPRHq3?=
 =?us-ascii?Q?L41st/yqagY149GFItM2mqu0HfcPzrwMR3V5O2UaI1+tab+nvlg8a5D2HQvK?=
 =?us-ascii?Q?fRIZEq4IYds/HPie4qZjT70ZAW5KC3p6UG9NzkjNGREL+Lk7NWdbnVHRjFUw?=
 =?us-ascii?Q?yvwNeG9FFCAwaj6sQKWksu5RHs1fD/Uz4Acgvy9b1CSg1e84ThyJ8+haPVwE?=
 =?us-ascii?Q?Intnbb7mQvN8+20ulNvMnY/Hj7rIys2OgC8pYT8jP6I+GKLt98/fShFR/NLC?=
 =?us-ascii?Q?2Eo6OP914gCU1F4v1xHKVWwIfcITx/+NW9iVjR8fZ/dv5lo1S+iBBL/aBj0E?=
 =?us-ascii?Q?DNNuUbWAoaJm9ku765y5/s0mHai6fMlo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TX3uPoFKuJrOkQWwfja7OAVw8vU5+8o77wLLVhbkTfH8Jazm0fm5JFC+QNRn?=
 =?us-ascii?Q?bJ/PVXOVr7UgkRSU5mqPFy49hZ2XVtYUIIRq5vDNSV8uj1/HigDRI3lqdqD6?=
 =?us-ascii?Q?bKSzhHmh+Z38/+6bqfxv/nvQ3RP7atQ8l+NUeUUfcqlS5BdCqtn+SKm8onK3?=
 =?us-ascii?Q?PxyAzoV6zmuMXAiP3O43kQ07Lp4qOui5T2r5x+U2/i2K+HReDTTvnrHJXT/r?=
 =?us-ascii?Q?Xi/qEusJAfYIcTwVmUlNxXEalACByV8/XnBerXmN22tUP2TZnkBiqZZ/3wUo?=
 =?us-ascii?Q?G/myLcN2FhVXqN0YSc8Gkkv/ELSYb9zQLQxwCJcAFFWEt9t3bq55GZQR3Wu9?=
 =?us-ascii?Q?nEAmtw4cpSWwCWw/yIOTef4A729rNnnqKF2zkUgEWVmO+UdA8xr/k4V/1zjc?=
 =?us-ascii?Q?Ek7ySoM275ENf0RRSYB4Y0+0WRx7asJYo6tMp52vk+7V5vkJNlQin44VAs9H?=
 =?us-ascii?Q?S4B3CNVx5qI6h9wQdOir6ZL/0FAxxuNJix+T5EWnFY1JDJcKyDW81MHIrHmv?=
 =?us-ascii?Q?xs1aZCemPWl3nWg278h+avUpjTFFMarUTfKkdOml3FsGMlsNincNwYve8ca7?=
 =?us-ascii?Q?wRUoN6p8UXXWPbsgl1IOfO8KsUJ8JpbZNHeJCTwcjOflWdz4gMiAVcK1dZlZ?=
 =?us-ascii?Q?5hmi6YeEdaFP8DecuZoz8mO9GmZQ11m9Xp0TU9MkApC2/BrnToeDOBYFti5T?=
 =?us-ascii?Q?u5LqnonAOrmGe0DQGfJFO2jWF/wiQS943i5rvYDHBrLWOQg5pk+IFqDu53Wl?=
 =?us-ascii?Q?O5osgmRMoOWsp0O/vRO3itIyD3VOsDRydVT4xrS2XwwI6D483bJq9gfnEQEu?=
 =?us-ascii?Q?+HF0ckal6GgWT1K06g9iR15ewF91Rk6Mguojks0CFPUo6d+HbhGr0Ce31doL?=
 =?us-ascii?Q?0dbT+HgzgPzZ0xoAiL9E3aUyNtKas5uOm1dXD+d2Rn1NAh3N058QSNge71/V?=
 =?us-ascii?Q?Rc26f+eVNXIt1EwrgoMTTPJzk7jWCbEI3UIOjW5gX6rjsBara1h3ij90vVws?=
 =?us-ascii?Q?Ow3jsP35NYpxozwwCaqzJ24KBLHKhfJQMnm8t5lqyCkv4iYyZxgY7FgvXOoS?=
 =?us-ascii?Q?fkdzzLWA3+E+i8GeFcOpNrahtZkviMkQW1IkClbGgL5SMAGmSx91aJ75uZlZ?=
 =?us-ascii?Q?kOKuVBIll0Yo+kEFgLhJjj2+z/yyvSEgkdJ83WgzyqGEfnG9vlzTwRSifV67?=
 =?us-ascii?Q?POefZ5XrH16yzq617Rh2UU9ODDB1mRn+qscCBP8fATj+AOpD7q/+Pk2FI+BY?=
 =?us-ascii?Q?4l2LCT4Kpsv/gg6UVCSRKX7odkQdoqh7q1enEWj0q/9LqFyuKjnTrh1PItXT?=
 =?us-ascii?Q?kVhFh4lV/DhPnqONawrblkjq3Ct0nFQdw9cjj+XwFxPqy2Yr8tuGda1ye2eR?=
 =?us-ascii?Q?D4BJfcZoJijPRKbMY/Sf7dHA030XVbgrDXXsSyf1gmj/w1TwRNdeLgeHhHkC?=
 =?us-ascii?Q?JMqiBNa4yHn3EoH+yT7+I3mP+l6xayO22YJ6lK7XP0kND6sEnzpL6uzcSH/x?=
 =?us-ascii?Q?75GZlicstu2x3OTNzDAKkIw1/q6EvIdGHgcWmkWmW6ewiYxkFLgfVwYtr+0W?=
 =?us-ascii?Q?jISZJ8SPoH847+bILKFMHs++jy6++neDg+ZBEDin6VwPHUDdZSIrGpxiWQtZ?=
 =?us-ascii?Q?zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yzzpme4rQ4Tp66wqC8L9tsGAcsFIVnoBu6nVHpPi/bjRw2p5e1bFBICHlONJQ8wikObOVgmBpvRyjaMKcd7fB40fgumkcXeC0COcf5UJlEEx077IXICw9amp+2+04C18RUAm3SwZebf5v3bcyFDT13Fyet59XTM6I/XDnrSitgM0QuorWx3gSySQ9Lb8QgvgmjahBaH8FqYg8W1gEwKZz/lnscAxI1ickFPME4YinkZ8IJou0vLYNCjfFpToZ60KrbAKzonwcYEpYV6COiEa+sKmUwXRIGS8cifjsOhS8E2FlP8OX1SqBhfiyErTlH79mHyYH9+fuIn0HSOWJkIL7cIojAEmvOSabN05WWSdfRoLkZfcJY2Yc+bVb3CpLd1Cv4NJRgFRA/cIwSKZIik0I5BGSCIkhjEcqI20xEZCzpRPJ20Bel+7LV+qBje12Nl2a6v4v7+h2lmx7Uis+VkeZvHMWAt6vdNYLZVEzYvGWqNFW1MYFo6+z34bB2ojc8b4NRzlWGIlkRVc3fKVNSKjF1LaZf8YZSaCRMZmtS2A34BF0RyB8JTlb+H4wpIe7pn40VK+99Kr0NA9EnO7+eJyKtLrOQRXp4LJYK2y2OyUAXs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb2c1a44-eed1-435a-b912-08de26d7f877
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 19:23:36.3286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EVxWq9IM3xhhNFeWTunDOY9QXCEEeuPNJE5970uJTRweUxJ4PxKtG99mBdcyqeE647N7nkInmHEpSKZhNsgS/ndGdi7jLKXhS7PYMtCSN9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5173
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-18_02,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511180156
X-Proofpoint-GUID: XJW-oMtOIyVKblv1aXwRk3qESxmlZkh2
X-Authority-Analysis: v=2.4 cv=Z/jh3XRA c=1 sm=1 tr=0 ts=691cc7bd cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=MiB45YfnJT0v2DVLkKQA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX6VFdB78ErvJI
 1woRiZnHcY6fC4YvQIwF3pbJDI3zZCDa91VrGBR/Po1+LEQw3PB+jQzkDo8IF7BKWGkXpqKP+ly
 Mppg0UDPUSeYtDtV1nrNa0JYYymiS/YZZJ6PJMDP1yGWcu3AokUw7Ioz9ARjyntFduO8rpyHrF3
 0nKxSExHmIBGc6ydQiHkyAcvMFm9iJAZGfcH3B+RnpMt5PlzTf9YfRFdWrLtTi1Rg4m2MUAyxDI
 BtZXiy9X7mwtM5pJzpHKrOVtkPfmej0gjEBvgERRyrrWxULG4ZkaF9suJCsx8DISALq+FCwQ0te
 YtbQU0vMaUlOFBW9I1XxziS4Miqa1oBYreDvmuKbM0xxnHhjBdoQwbiiZ4MqLT1Yj1F4GqS4Yze
 A5ApXks6FJM7YNT5Uf7oFN9+S8nQdA==
X-Proofpoint-ORIG-GUID: XJW-oMtOIyVKblv1aXwRk3qESxmlZkh2
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1C6B440010
X-Stat-Signature: n9cuprti1wdhsmkpgpub4p5pn1mkib34
X-Rspam-User: 
X-HE-Tag: 1763493864-243393
X-HE-Meta: U2FsdGVkX1/3ScdmRS54KaRzCRIhpIrwFFBYIlkn8ha3Mk3pA05XO5W/6BbKVlIfEbwM5yhMirNmkQnOMn6Y/v4cd2ys0jphWipizKYAXh65A9rs5mgVFVq8FPXvVU1ZWOwdxmhsyeVVrqp3Wx5Rxm0FDQDyvGOa1s+ps3Ms9gKybsNJRFHOahiwHqQ9VJnlvlgSFoZ2stkELySMsMitUxxE4Qi3yjGy2+crrRKJi6pxemnqE8n+z2UKWA3jtnzXbEFEwzZy0kw74mmF34cFygH46mrRlrgGYWKj4qljTpvoEUj/AMEJemCGZle+AUeDHfuHDxxiFMaVnE1gSytpVui8jUv09FFNE7jCsC4wvxUdRFpu9NV+G+4F3CxTPTv/75GNXp6I+lH8BQrOY1y8AKmjoqiVEfrlJIACABSiQAF/7Hb2LrT/9Y3S9z/INKq5o2CQB3n8W/X7FA/jwJ11stsazmibWcnAHVRI2AzU1XCMjtj32vQign4iBlSgG8cmkqTWoGbz7/EuJ1PM3oxnefW0CelJuAN9xT6E5perr1Y10mr1v4Who1aAaZ3z2O8PY/IOZFqSku5Dq9DztAtPpSpBLHXIUPbwsRUqcdDLKlqzkYK/70GaYbnxskyYo2cYqHe2IqFhsotMPXm2go9RRwZ/pASq5FUBGcDlV/ebaenHTDt8cn7JVVXnHkGBZrrEocD8aiwt6M0yNm/hZ+XzRl+FSArc91Y4j25z3r5P6KMTvmgfhMlHWcnfR+me+qhAsg2XDbx/g47OwaEYAi63Qs3UujPKSVu/Bzvmf63jYxiVAS0fH10Szp4VSLN7XuEMBOEU5KRuzrL+08xg7c3/X8eanZ3iM4CNPbNkFzHJiF1Gl3w2yQKC/tgB8miMRRqld2KDK2y08fumH4MuiK62EtzjofqWw1PoNyI6f9waJwDNGEAO/nc247zPFresXR9+4cmEozEYNo0RaqCnH65
 k2plQ/KW
 406ICwqX4UwRvEwyvCCMRXGJ+6MVXPFRYtHlAcRyHGZ73GO4cMSPP9hIXF1TgBraaWU3bwIPEc1wEPGSWZupa7BijDHasJ5TqJCdhQKKCDn3g/ly2rd180Ykgabdm19I6uyAs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


David Hildenbrand (Red Hat) <david@kernel.org> writes:

> On 27.10.25 21:21, Ankur Arora wrote:
>> Introduce clear_pages(), to be overridden by architectures that
>> support more efficient clearing of consecutive pages.
>> Also introduce clear_user_pages(), however, we will not expect
>> this function to be overridden anytime soon.
>> We have to place the clear_user_pages() variant that uses
>> clear_user_page() into mm/util.c for now to work around
>> macro magic on sparc and m68k.
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> ---
>>   include/linux/mm.h | 41 +++++++++++++++++++++++++++++++++++++++++
>>   mm/util.c          | 13 +++++++++++++
>>   2 files changed, 54 insertions(+)
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 683168b522b3..ecbcb76df9de 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -3872,6 +3872,26 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>>   				unsigned int order) {}
>>   #endif	/* CONFIG_DEBUG_PAGEALLOC */
>>   +#ifndef __HAVE_ARCH_CLEAR_PAGES
>
> Also here, let's base it on
>
> #ifndef clear_pages
>
> and similarly below for clear_user_pages.

Sounds good. For this one and the other.

> (sorry for the back-and-forth, it's rather unclear what the best practice is)

No worries.

--
ankur

