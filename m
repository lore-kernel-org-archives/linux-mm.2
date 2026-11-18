Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07AD8606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=R50fXzvk
Received: by kanga.kvack.org (Postfix)
	id D474E6B0644; Wed, 18 Nov 2026 18:24:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1EA36B0645; Wed, 18 Nov 2026 18:24:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE64B6B0646; Wed, 18 Nov 2026 18:24:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FD3A6B0644
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:24:14 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E770C408C2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:24:13 +0000 (UTC)
X-FDA: 85449820386.28.2028DCD
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011023.outbound.protection.outlook.com [52.101.57.23])
	by imf26.hostedemail.com (Postfix) with ESMTP id 064DB140003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:24:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=R50fXzvk;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795044251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Inlj0u00/R/puNIsf5+6YFVPEbJrhNmrfiHeOypdiRk=;
	b=09JGHwv6hoaF7QPDP41YVKA+KPc6GLZ0InpgcueVaa6PsyFBxH893HSot/a92uKDBhBDCq
	VdSRSic2QOF6FfgMuwaYoG/s/UnF/CAtI98Xewq+dh8FX5D//vtmzj0Kr/zGVRNsak/BKQ
	Jquqz2sUZJKk8mwQVgFBL3xtbG/+ZtM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=R50fXzvk;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795044251;
	b=WVriKftcKHr74i2J3Vfk/wL5KvH22t2wAGZHmJuYQDdVKcFUsslZRrvdHGPdr52uSjpMlJ
	njzK8cjPr+P5Q5VF6PTy+txKeYwpqhifO60E4o2itbNprBTs3vtsEHdRE31lq1KF4E/4tv
	ttveVTQBkifDuW4YCyHh5agzdxBC6go=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m1JuafkKWhdS96mUm9v0V6bbAcORgUoFfpRy8LfmQhmlZc7MEFwdFbNAvW472aZ+eayr7qY6Kxz2sKxTK8+/CI/0v+ilLDOvfP1tpA4vZVAq4boVeWE/uZPaXJekTJB3Ra84z+peqTE2b+JOgQacpLxzjoI+cE0KxEdYNuDiP3VXKtuT3k/Q6WV/D4MMudIQ860/0RZz/Nt/U38ee9aq4haI2i+iXUjwybY8xoEyB139sNpSeF7osOFHyKd0aR13Bc7EjOlxTXgMC8CD/BtB7v1pRbxDl0z4A1qnLQM2+1MnuTTVRNsnFNHMHtiWqwD22W7hNVwqlR5wR3zvtTktIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Inlj0u00/R/puNIsf5+6YFVPEbJrhNmrfiHeOypdiRk=;
 b=cBI8GK893b3+unqoffFiToOgm6ojHoGGsspQ+pFc3KoSTl08TVGTUmVtIfINpIiAuDwczl7dLlS07Uq+pjrR2odDiub4HzS1UfgQw/FFczhh14dh1L/p4JhmCyYFDdt1vlQwFSyzO/AbncHfhRf+NrWcpSD64GduY+Um39aQXbC06NUMRd1YtXjbOo+2PSLXB9nCtbmZ1Iwb5dvtGT7Pk6e8tz2ZhwFnZ9pFg+/ajCJSSI3cw8RyJAITJBNJAqg6Y6Y5DsqcFieFGzfrcyj76Wagmtg5iIIPSsWU9dGk6zQziwro4lpSagnr4yHWqlwms057s2cKbbsh/ZJKkHeOlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Inlj0u00/R/puNIsf5+6YFVPEbJrhNmrfiHeOypdiRk=;
 b=R50fXzvk+BNQB5vcAFEXxbDjVaLpKN9kRdO0ReUQtTqtWWyKIKApL9lmK3ZSPbgyWmorncINNm5NZ6v3G98cv0ANZHWsnC9mwc6ded4Fb8U/tzeOPy8FEmv1AdKMlMaaT6V7hW6hvrNDk6GAIRScNVl7P531U54urhnrPJKCVqkn28r44RAWVtYejDONbhyrax951+1a0537f9/6OH7zqPRWVAOSES0FGAxO9gbUgyZs1G4xZXW7QzCS90TRo2ZomZeBRCP/f86qNSxgX0vd5fAR2khD9/p2kIoUUaOc8wlD0EFKMO1NGCa8MqOXCgsc2dZbNDfpVDISft/NJ/R71A==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SAVPR12MB999144.namprd12.prod.outlook.com (2603:10b6:806:4e6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 23:24:06 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.009; Wed, 18 Nov 2026
 23:24:06 +0000
From: Zi Yan <ziy@nvidia.com>
To: Nilay Vaish <nilayvaish@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Balbir Singh <balbirs@nvidia.com>, David Hildenbrand <david@kernel.org>,
 Zenghui Yu <zenghui.yu@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Alistair Popple <apopple@nvidia.com>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/test_hmm: fix alloc tag leak when splitting
 device-private folios
Date: Wed, 18 Nov 2026 18:24:04 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <1CB074CC-E9E3-436D-8D04-8C203C825E82@nvidia.com>
In-Reply-To: <20261118230044.683221-1-nilayvaish@google.com>
References: <20261118230044.683221-1-nilayvaish@google.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1PR13CA0386.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::31) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SAVPR12MB999144:EE_
X-MS-Office365-Filtering-Correlation-Id: a7a7f1be-c7a0-4233-440f-08df45cb0a39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|261028144727099003|10067099003|5023799004|56012099006|11063799006|261021123027099003|261021121427099003|261022105027099003|261022075727099003|261009223027099003|261102123227099003|261026121527099003|261026140227099003|261102130727099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	GILW1LGigQv8Kcbvy+0JPcjGYbYBuAgsCU/G44huyhZBeDfayrPIypwZcHc+wbwjSO3tqROP/JI/bTH1cR35C3vlc9K+oVbVagI9sugyqCVBLk3mU4y4QQAunt6uw4flICI9MUrs4bHsFwVNO/yklELCm+fraohloWq2FGHFPj3rvjqvhRkfvCVx9lfn3Vts9c0Qw0Qpsm2ZNs26q3djsRsuADhM/hpgmNKFbJ+6nm+Gklc4KwsMidDSahEycjV5JpBlevXSXr0tQMvxdZ7lX3ZSvRKGqA1Qrzzz3hWo1CJYbJNuiOZzCRVAxtLzfd9iy+QndIhnYwUneERz9MegJv9gTN7H4caqfS8oA2iWoqUUW71nFKNpbC63hKGv3hWKqFPFwOGbzvgzlXQJsR6t2j6G5TGLqd2IY4mDD90zuIo7LYk7o9243tueBNVgTu4ngybixnwtiblHC/hmKZ7cGifXg/EZqklO9VCNvYUlt7jgr5hS7+LsH4pmhk21O5gHC/hYK+xAf56zDwfSzjwfXLimniOfG1D5rQOQYLFshWvzdMFxvoU3ecRBFMcveZ+COTBQVnWziGhhnwhYq3Fa6fxDQ634cdlngM0r3iTdmRGmaGx6qAi03fD3tWalNrhQsjdSDW53xA6qthkfVijDpfceVNZNNOVhxgBHM0OKggY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(261028144727099003)(10067099003)(5023799004)(56012099006)(11063799006)(261021123027099003)(261021121427099003)(261022105027099003)(261022075727099003)(261009223027099003)(261102123227099003)(261026121527099003)(261026140227099003)(261102130727099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RBo/AX/WvpKcCEEoalMwxrZQPjQLLk2cyEzf6TBqariiMDFy1ThTB6aqrJAq?=
 =?us-ascii?Q?Cz685F7iN1W+E8hR3rT7hg4pITUlZfjL2nCOIsV4kqQ8PpWuT4WTWXOMxZJc?=
 =?us-ascii?Q?A2EGYHNI1sfL5R1ido5crKFoTphdpo8F+mDiLHJy5BAqiC8dhOPrrniBdH0E?=
 =?us-ascii?Q?+h3WYefQBr+abGwfvNkAlljL1966paMDSzP9zAj0Ycl3Ch/MWnWUNU/2nHw4?=
 =?us-ascii?Q?38tQhCvvHnmSywNtObGXm1h3QaAdwFR6foVPWZGDPeVu/+eXrUKhUZ/+NwHs?=
 =?us-ascii?Q?xsZmnxmYknLVfeFhmRhxi7L4l0JgFc6Ka69uBuARDf67a+fOZ0+FIiseF7wF?=
 =?us-ascii?Q?yreKGPM6O94BmRZ+HyiqU7bmxCW5yXNhv6ZZWoGZiGdgW49SDLlkUrfBXnRX?=
 =?us-ascii?Q?2uLmQuc1ROhVfmYx4QDlzAiPm9jpXlc9yO28g6/1T3Pd4xbQjRty4E1Mc6HA?=
 =?us-ascii?Q?PCAwiOaXUEArfwZy5vQHWlckvmVt9xRPSPbjXpvhkW9lxjrDn2LbAJz0+tBF?=
 =?us-ascii?Q?NX07IzLOcjncwnc3Gx7aY0EiU0b2ZVcaukSZdydCbkPDlLv1nxl3P5WAJS4i?=
 =?us-ascii?Q?Cl6m5OigDAoxK5jQC0DlbpsC1K4v9oHUX4PInl/e/QqdxwEQvkFfN8TUrivu?=
 =?us-ascii?Q?2U04UZSr2wZFOUGABqi07yAdIs2KoPP+nhgbd/Y0A8DvjcXw93VSxSAXxcXB?=
 =?us-ascii?Q?FfYvbjYaWuw+W6qOwKsJMRqA5C5vTjXkHAHiWO8X1Citwu+FzRya09WpLSFw?=
 =?us-ascii?Q?DvQAaTgbgkkBjrbxCebEmEWvfjluto5qWd4Jx/41cN2ImVh2lulAl835om5w?=
 =?us-ascii?Q?vO8B7U4xGgewyov/GGqe/Su6c+/Is8DCIk5WieRVRZS909DBmpuGMfEL6xHf?=
 =?us-ascii?Q?Ko7u0mYX0I0NpF/EW0AktvVLSm2M6hJyjZBQov+Q2AvJlfPtZnw5sJKO0LdP?=
 =?us-ascii?Q?xUMvOzMmduay+ARP7xKfvX1RNwAjgphiT48BJNWetIES5cctGseTGbn6T39i?=
 =?us-ascii?Q?H97Sc5cnuEK0++ucosspBwF5PHFc2OGLZUtbtNCoZeqUiRZV3p7b8tvCZtnP?=
 =?us-ascii?Q?WEa/jCeNIp3XZlupXIlIl385dTuDEP02x2IOsDkw6bzrQB+wc/DvuTgj9iBN?=
 =?us-ascii?Q?WzTwmUaD5vRLW6rZotu4YRx5FzvZFCD0qJNyC0gdlm2SeFT6j4XF09bWvORc?=
 =?us-ascii?Q?6hX7v9cCwQiNGtmsThvWNOwgX/G3/R0rvp+OOEEzF63n0N2J0UyqfH6WxoI0?=
 =?us-ascii?Q?qhO/aN6mvZkTA2xWEqJPZj3a67VBz7I3Ui6WxolYWByTm+psucxG3M/HSe/r?=
 =?us-ascii?Q?3cNcwO7zvEYzu12MDOCzoY1JrxS0ETj4Nm/+JO0TYdgRNrSeHVxnQIAXbY0t?=
 =?us-ascii?Q?RWyO/qf3IUD8I4uG6qf9aYGXJZzsEl0uTye+foGvrLgIO1ZUVBuy/PIEd3i9?=
 =?us-ascii?Q?n4U6WnO5waZsr+tNNyv8WqQTgz3uGujCKpQ9auK1K+VUBUVbvllrM9pKIAY1?=
 =?us-ascii?Q?buXxhycD6TpwcOcD/OzMbWRMvyr/h/VKVCE8utSKypwixa2B+H8iX+OlADpg?=
 =?us-ascii?Q?gYP9rGiUVnSpFtxoZPHPoyVjSr45hvME2nUDapE2XME4pPnwQI0DRxzkiq2o?=
 =?us-ascii?Q?ta+vRowwQkSktKAHTmsL4T0FiI/JY7n+wffErzvpbjOZ0TUFu3p6nKbE/Bth?=
 =?us-ascii?Q?qEUo+NZMUloAZYLNI+WE3obxkRJ1osBuO/X8oT+E1bL6sAE5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7a7f1be-c7a0-4233-440f-08df45cb0a39
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 23:24:06.3626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7vuCDFZJk98XE2RA4TP5k7S4BBBY34T8PMaT/tD0k4bXem4ylY3OMhsq98Zmvc78
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAVPR12MB999144
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 064DB140003
X-Stat-Signature: p483w1bjxy4ms3s7n5bngutpzrcicrce
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795044250-260280
X-HE-Meta: U2FsdGVkX1/uHpguknE4OxrCgHmRfHbDImUIUC8kON5VQLaJDf4D5SPIsoBZUMWTWylh6xroOx/qTfD5g3R1xdQPXu8b4fxtS0PX1A0xlA20vkdE1L8/fYeZXKvHnFiXuU9EL2vUaZg7MaMOd/fz2m9EnxGZ6PqeKcy0dvfF+opFyeqrqaxtD+pIHMYWwPjT1yG6W06lvKYhRZ5HbMvCEF0npTBDRhaYZefW0yJ82Y1RhimymYz/u7Xqi8CNuVdd8uj7INL4JhlhT+1Qzv/DW9sIiTa+y9hm3QR+5C9O8bstdesq8n7uv46KVQgnVc37+5MD0toZKqsmLGbWG2/3Bo2rYQA3zU4ZNP+z+n5WS3YFCmpJTDb2j9sj16Vn4i0/HWF+7t1ASmyaoSpORCrRxDVPzddqdNqnsgMySmjAm9JBV8rhhW35d7Z39/oxtB+D05pSHcKx0DZKuF00JIyc/lNDaM51/V9A4d3T4IfsJ02YmHOSaFTKPEH7jJaT8tFrq2y8B64acWUjSioqd8MqPLX58ed7fOLm10FRt3yoGPLB2/0VC2mKCXe/2+Wjn4Yh4mxNBgtTJS47lheqDgSPyeTV2iWC2gaQDLK2YA7/NNzvz64IkfDJd1zihrKrIo5/8OM2UBkfQhq6FQGUnqY+Sk2rHSUf2G3mai2o0H323UmUl2Gml6JPgE0Hjmtismo6l7sgcnPpnkfkXOIoVB6Jz2gr58Q8Ky1wYt7L5xRt9LrvU/NAQ8+uf2LEV45vfwGh8+eP6BN0UY7OdY1IXm4km3L12u0fhA2XqHNvCCm392LrGqnx37CLA/SCosa/M0uF2LF2UdX/sECaKzg1FGWeMD7O9L0YL7TWnVkJ8IRNpavz8aBhiaqJBVIgebOVLRZ9c/uiz+ER3DmrfQN2+jrqHWGnflEjFzAnpZSrkSVsiG2L5HrOsiXLDawBUPveMtB9e6zwYU6uFMMkibsPHLg
 8Ovo7Sxr
 GNwBSDaJekQILTBXbZ0aCzTV+pNYWcisoxQV8LKUmboGjfabekQ0Y2gyP5X5xSaGp6F+IQvWDV/x0Q1DbiNajP4w6wF9CUBhaQL3UNvROZ7+8WuVFegpQYzK2gnOxX68ikFs5NVfRVzLDTlDoHdy7z3xgPRCpRAH9Q0M+FYA4CbdQ6YdhCLZY5S8rcfazaI3XBqm0AC6N+HYkuSc/qp8fmZX3wMM3aJg+/7EWhv89QOx2JcmHti18cMCfXr5+DQ13AXFQhzy0GWy3DLb34mxQZIb0+txUpBkbbLCXX8G7FsCvGWwrKaxvCZpJzDahIGyS57nUiWLb5NxtD+alariwEHyGJD7qu1Q5EfZMGGwDBCK5jr+FRgeNsjPQBpX218+3g6GlfVVSrub9QZ0abgNfaybbQlKDoG2oaePxIZDqiQZRRAfVHjksndfE/vAbQDbi7iZGwBvS8fUxCS4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 18 Nov 2026, at 18:00, Nilay Vaish wrote:

> For device-private memory, test_hmm backs each fake device folio with
> real system RAM of the same order, allocated with folio_alloc() in
> dmirror_devmem_alloc_page().
>
> When the core MM splits a large device-private folio, the driver's
> ->folio_split() callback, dmirror_devmem_folio_split(), has to split
> the backing memory as well. It does that by hand: clear_compound_head()=

> on the tail pages, folio_reset_order() on the head page, and
> folio_set_count() on each of them. dmirror_devmem_free() then frees
> every backing page as an order-0 page.
>
> This open-coded split does not split the allocator's metadata. The
> allocation tag and the page_owner record still describe one high-order
> allocation, and PG_head stays set on the head page. When the pages are
> freed one by one, the tag is debited for only one page when the head is=

> freed, and the tail pages carry no tag at all. With
> CONFIG_MEM_ALLOC_PROFILING, running the HMM selftests and unloading the=

> module reports the leak:
>
>   lib/test_hmm.c:808 module test_hmm func:dmirror_devmem_alloc_page has=
 16744448 allocated at module unload
>
> and with CONFIG_MEM_ALLOC_PROFILING_DEBUG freeing a tail page triggers:=

>
>   alloc_tag was not set
>   WARNING: ./include/linux/alloc_tag.h:164 at ___free_pages+0x2a0/0x2d0=

>
> The backing memory is a private buffer of the test driver and nothing
> requires it to be a folio. Allocate it with alloc_pages() instead and
> split it right away with split_page(), which splits the allocation tag,=

> page_owner and memcg state and is already exported to modules. It is
> still allocated as one high-order block rather than as individual
> order-0 pages because the driver finds the backing page of the Nth page=

> of a device folio by offsetting from the first backing page, so the
> backing pages have to be physically contiguous. Every backing page is
> then an independent order-0 page for its whole lifetime, so
> dmirror_devmem_folio_split() only has to point the new device folio at
> its backing page, and dmirror_devmem_free() frees the backing pages one=

> at a time.
>
> As the backing pages no longer form a folio, take the order from the
> device folio rather than from the backing page, and index and copy the
> backing pages individually instead of using folio_page() and
> folio_copy().
>
> With this patch the device-private HMM selftests pass and the module
> unloads without the messages above.
>
> Fixes: 56ef39899643 ("mm/memremap: add driver callback support for foli=
o splitting")
> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> Closes: https://lore.kernel.org/linux-mm/be9a8bae-9223-4966-bba9-2cbe39=
c8f4de@linux.dev/
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Link: https://lore.kernel.org/linux-mm/8ef6e92d-4cb3-444e-857e-fdbf88c0=
35ea@kernel.org/
> Signed-off-by: Nilay Vaish <nilayvaish@google.com>
> ---
>  lib/test_hmm.c | 41 +++++++++++++++++------------------------
>  1 file changed, 17 insertions(+), 24 deletions(-)


>
> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index b409c42bfe6f..371ead009f8a 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -201,6 +201,7 @@ static void dmirror_device_evict_chunk(struct dmirr=
or_chunk *chunk)
>  	migrate_device_range(src_pfns, start_pfn, npages);
>  	for (i =3D 0; i < npages; i++) {
>  		struct page *dpage, *spage;
> +		unsigned int j;
>
>  		spage =3D migrate_pfn_to_page(src_pfns[i]);
>  		if (!spage || !(src_pfns[i] & MIGRATE_PFN_MIGRATE))
> @@ -227,7 +228,9 @@ static void dmirror_device_evict_chunk(struct dmirr=
or_chunk *chunk)
>  			dst_pfns[i] |=3D MIGRATE_PFN_WRITE;
>  		if (order)
>  			dst_pfns[i] |=3D MIGRATE_PFN_COMPOUND;
> -		folio_copy(page_folio(dpage), page_folio(spage));
> +		for (j =3D 0; j < (1U << order); j++)
> +			copy_highpage(pfn_to_page(page_to_pfn(dpage) + j),
> +				      pfn_to_page(page_to_pfn(spage) + j));

struct page should be contiguous if their PFNs are contiguous.
There is no need to do this conversion, right?

In addition, dpage, based on the comment before BACKING_PAGE,
is device memory, so it should also be allocated using alloc_pages()
like rpage. Am I getting it wrong?

Best Regards,
Yan, Zi

