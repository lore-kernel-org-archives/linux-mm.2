Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32BCDCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 19:05:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BFAC280016; Wed, 17 Sep 2025 15:05:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86F59280002; Wed, 17 Sep 2025 15:05:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 710B3280016; Wed, 17 Sep 2025 15:05:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 56057280002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:05:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF0A8C065E
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:05:37 +0000 (UTC)
X-FDA: 83899671114.20.742F65F
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11022096.outbound.protection.outlook.com [52.101.48.96])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1A9881C0018
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:05:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=ASNksIwm;
	spf=pass (imf18.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.48.96 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758135935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fj5/zJidYXn4o0QU6amCmc4XKjvUhXn2C8luOwIwcMA=;
	b=Wch9yTho4gWrd3L2Op70sF/G3XjAH27s/gl3Odh8mhlHXrfOVPPwslq3bbawkd2jMGtBos
	iQmwhIjTAIVLSQLJLTo2WbWkA67Nq7BpTLOVpgxcpLZwfmn/q+f/zOu1eOlw4H0YAgfavu
	gVCUNqyP/OjQDnCxKHWwKNdQUS6upNY=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=ASNksIwm;
	spf=pass (imf18.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.48.96 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758135935; a=rsa-sha256;
	cv=pass;
	b=oj5C/WiNZBFt0Ihqb6Ppk+vhXIYH/NJQ6Ffl2y/QyMG/JPRf2Le8nqo4gByrFszRMI+6hW
	ZZSI82cDdtl+OcJrbQAHRm+0P8g61vYvTW0Nw0eMjrmMjHmsxduT3rEuRr+Rn1FxqVCOzq
	PDaYDrd2VP1RDxCanJWx7FLnuDMr8AE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ERRNNheifIDkoeKZdYZU9vZvLDslMZX4+3U334Doq0ySNfFBeY2/yuORyzZvFN6F92hqPCPGa/0fGkYrvtUQjywItz2lQ1FxexUNwO69yh10HWY8Htq8c/bB7r83uoDvehk0klxaPgrybsQtSxmBDJNXzAU6xn/fPS+BmQP3FJYpDoczE+xYKG9i3sQuvK21GT/fM8RBJMBUHeXkWnfYZH24B98tapWaUx7qaFHSWj7CgYZW03AinuC5Nc5YyYSHxjAlBnMZ7nrCkE72NxbYlQjee9RTdgjWMzgRr8XdAICocxhslzYNHwLLQhKaOnaP4B69gTIKtVqDd8VB6SZeiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fj5/zJidYXn4o0QU6amCmc4XKjvUhXn2C8luOwIwcMA=;
 b=DxUw0gEP1muvouP3Wx4LAUhslsLeeqhvBGhXGomb1+UM9MR7OmLmIXgmGetUItFqIzEqv68iKP0xyFN+HXRsOYx9c4wxV7NDqxzPd6jVwRs58jU/16peut8wYNqf2oM6JNfNyPOMOxf4YJ0ZYqYMETJRoqUmiFB9Fd9+GaKhlwOEmgFj1OyZOsk3s1tfBlR7TLSIR+r20fLTJCphbPprIjPwnm2TKP1whprf2kMutu6m40hu4OJVn/tyHFzHsrp2DaXcQke8D39ek2d8SBD4bNgn+ANeSVjGV3RZogiwU4Poq4hD0sNrIXwhO2IZ+q+/TH6Wp36he1YX9oU1DF1lUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fj5/zJidYXn4o0QU6amCmc4XKjvUhXn2C8luOwIwcMA=;
 b=ASNksIwmyBNP5uEXBeQ5YBIX8CvNQDkiwLYFUIAZIK4vezq1NWwv9e9qf8pzyehNGMsOiQ1e4xYZHh1QufcrnrISJEUazKUzcU3PmdiKStvg21e2JSSh2jO1TnpSrI0pu4JGXueHdSYNyooLkp2a6IYGOydZW6kdyKOp3NrAGfE=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 LV8PR01MB8429.prod.exchangelabs.com (2603:10b6:408:189::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.19; Wed, 17 Sep 2025 19:04:03 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%3]) with mapi id 15.20.9137.012; Wed, 17 Sep 2025
 19:04:02 +0000
From: Yang Shi <yang@os.amperecomputing.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ardb@kernel.org,
	dev.jain@arm.com,
	scott@os.amperecomputing.com,
	cl@gentwo.org
Cc: yang@os.amperecomputing.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v8 0/5] arm64: support FEAT_BBM level 2 and large block mapping when rodata=full
Date: Wed, 17 Sep 2025 12:02:06 -0700
Message-ID: <20250917190323.3828347-1-yang@os.amperecomputing.com>
X-Mailer: git-send-email 2.50.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY8PR10CA0010.namprd10.prod.outlook.com
 (2603:10b6:930:4f::16) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|LV8PR01MB8429:EE_
X-MS-Office365-Filtering-Correlation-Id: f85ea38a-975d-4347-fc20-08ddf61cf705
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|52116014|1800799024|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AQLvkSnJRe2xXoYBe3wOVtjMJYbIdnI/l2a5qqcEijHno2X3pAIkTtCRMGuA?=
 =?us-ascii?Q?94lPDedt2S9kRKTWB6r3ctzhwykRvlRC7Q8GYdF5zdRoujkeA5aM1JAgkFnl?=
 =?us-ascii?Q?+kAzQVjkRzVtc6/XDFjHlwDYqsIv7UFUnisl41JtQQqaEuUVm5jwvMJxVLkF?=
 =?us-ascii?Q?5pcy1akXF2WI4wCvEQ453mAD02Ty+E9mqfkYsH36M1al6OYt3EGPtoQXhkkT?=
 =?us-ascii?Q?vSkgQWrLRqJPJhjhjYQU7jGn/2fUnXtbyaP1Ogj043vnuUTNIBAA71nYLdjQ?=
 =?us-ascii?Q?thRAJDuVlNaOsea/H8eEGD+7LvbeHM3XOox3ZTVpTP6eCXdAh2CbY/3xJoQk?=
 =?us-ascii?Q?d+4y23msbnjoOb4vxlNxNtxTVMwB61fIy12MGGW6olN/otAuGu7vnPiX9R85?=
 =?us-ascii?Q?8cVCX6Lme2VeMp3FI++8En1MBQcJ4QncE4nFSLkTF1csFMo6S5YNRrma7tq3?=
 =?us-ascii?Q?mFInRN4jtCaMp8iPmPED5xfV5w4T84VJfExeCXGckD9wV8yBumVvNC6wRh4B?=
 =?us-ascii?Q?ihCLqPkoIY+4B3tlBPVmKwXAEd/9quoYk5h0gG1e+fLzEH/shCevG3brFqPZ?=
 =?us-ascii?Q?VUMC5iA7La2r4wJiEKjwMSY+Xt8s0/m4/mOndn/KmNSXFJCyalBqdN/PVMGF?=
 =?us-ascii?Q?hmJoprFJT1WxeDwSr15CdHfGFvH/lG7zsD6RcrmMz+2SoSNpdwYGH36wMiNp?=
 =?us-ascii?Q?N/EQwP6spDYrXlI7BT8iaxcTMJD+0gVLMMA/CGhX/BNQuoviwiPSpMFxtwua?=
 =?us-ascii?Q?SuFDaVnj2yiVP3x7eapCczbajvdyduP9y8Ypuj7edUm1RTKa2X/mv0zQGZKo?=
 =?us-ascii?Q?5PFcuvPEFvZ6teEr7MeNUtaV9ARA0lvnX86nndmCorkxagY7OVanuKhZJ7vi?=
 =?us-ascii?Q?4knboaYA97FCJ7O/wefC3EvnRbK9XWYuLXWYHjVYzOWJruXFu6FPihj0ZOwK?=
 =?us-ascii?Q?YyYlOprTIuWBQayZhrbgZ5DpguRB3gFoJWhVuBHcJGJwIt0f2aFgH963A1Cs?=
 =?us-ascii?Q?SSVrsr0zxoKsy2K1Blec5zXux7zpdlM9BkadhHcNLxyW8cLx0WfIDZZx1YsR?=
 =?us-ascii?Q?SZ4LmkvuVWB0j52XzWoKtGR8SponDSSG6hPPGZCIr/7Bb237jU4ekYIKZADi?=
 =?us-ascii?Q?GN8ttCPfO+P5nFwAfSDnyJnmQWgbkTlPNXuzhxMSkp1QEYkUS5G0bKfnz/gJ?=
 =?us-ascii?Q?5ttAf7EPmEsZDVZ1I/bZObvGLKzie/iQ1pC/Z8hPgTXFQK93aKi8mBz/pMAU?=
 =?us-ascii?Q?aSBryMwMGDAqHXwBvKWO/x6U75r90u1XbyyfO6e/B4vOjUwPpt3MxJAkURQm?=
 =?us-ascii?Q?gin969Pt80kPDTKqIWsnxz+1l4DuPRsmFCRBKhtgcOO+G76guhxgQSDnU27I?=
 =?us-ascii?Q?tzQdKd4VqAiVf7V+rx5h7bZixwWj8OK/WpQsfu8xklPXLKcUVF4r5NyPNRYR?=
 =?us-ascii?Q?jcjmLsf9qHIJp4VL/XVzRGPxGpBvRx/ckpLdCIsV+oCnqZ1rSH6KCpZ664a4?=
 =?us-ascii?Q?u794fL7wUsTv7AKuv9wDHruKdPJvDH8mkE0J?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(52116014)(1800799024)(38350700014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D8x0LvQSZt+Sd3D9n4iOB56WL8WbLghM80cNIiAa20v/ilfH8MJ/f3dnJh1N?=
 =?us-ascii?Q?kR4OWDQkGALKJTP7j3e46vfyakFlkb11o0VI2oeWwQEtoqdYL0DgTCBCdEZN?=
 =?us-ascii?Q?+UmRJm8JDgJinYqUw2z1E3dz0RnMuiK7/REPHqQG1iyzTkuHcEF12gukDwdX?=
 =?us-ascii?Q?GYg2sxdMppNwHllAy5vKFrIXQoENQJu/kWHnHmcpUhblN9L0Ksl9O95LeIe3?=
 =?us-ascii?Q?LR7kI1yQbTQu65G2Trk8el+RKI2u9gLNhtHyyU19w/2/hc8k5X/O3dZoORyP?=
 =?us-ascii?Q?WxGEwgeCQRlAuVC15tmxQwHto1NTAvuGrJxGYBUH0wLqeACL1yJ+UOaHcP0W?=
 =?us-ascii?Q?3VTIuVSblkTgeWqOrKD5IX9G7xN4gJnCRu4VQj18PvMpq5RjfHfL1L1yvseS?=
 =?us-ascii?Q?3NGt8yLOisECn1lc6OA2R55gPNxRe+ov0z5BEr60hDuXQ0j7J1CcMaI20B9J?=
 =?us-ascii?Q?zzdi6lpnX5oAVP6fQ1vlD1tsXgFVYeRqS5bXOt904rV9x04CnGVT7dpeKniy?=
 =?us-ascii?Q?PYeYLYsPL30AjyGBJbg+uR795RVUW3xaeaww21fnN7Kk4RSL6JQNdKJHyimU?=
 =?us-ascii?Q?iFTEunRYniwZU0xMVOmweFui1IfRt95wrpOjeVrXXBVzO6EGDBFP8jBbYkMK?=
 =?us-ascii?Q?gdfJguhQSE3dBxc3/P6OZKgmtLdHtmLczfa+c4ZvY9KH1f+WC1uMpYIRqWdf?=
 =?us-ascii?Q?YghTsiiohvw1lWAkvT4UBBCWUpqemydHFhuUxsGSFO6D2be4WRt8xzNdGHlx?=
 =?us-ascii?Q?JKO/g0VD3r0Z5ZWqPEJsWozqfiBBq15tChk43Dfd/VXEPMB088Z9E3H5DENf?=
 =?us-ascii?Q?X8l2wI7D9G03lT0ydhXcsa9sDwHyZJdhnZDtK1dhxPBwmw1A1qRnfpZFCqTq?=
 =?us-ascii?Q?3J3Mso6NtTDPeVFRxLFuTCPwl7WBKwsLLt3cXWUZFo6KH7YIkw4C2hPMbTQj?=
 =?us-ascii?Q?Rel0zji1TJK1HKNKXyN9wUOIXogsMFd+dCIaMmZef4u4W5HfUtDNnaWmc85v?=
 =?us-ascii?Q?ZvREtztXpBJ8EshrGBfCVopR+Fgj+Eb2uKv2gtBBli2ZgENQij7P0Fmwg98h?=
 =?us-ascii?Q?92amGl+5gYCqyXLZZif/WmcCTGCvVAjHBBmdgnHwEQm/4Y5wrVA7/7niieyd?=
 =?us-ascii?Q?zew7D3eneqj9iObbgSAEKob3a/7l9RoapsNJkauuGL0Rtc8rzMhCRLpPG9j9?=
 =?us-ascii?Q?lyZX3aJ3foBOXMnzcMV1zjnF5oTyDYBNgemkNxbA75JPUsTEpJZxODrkoc4a?=
 =?us-ascii?Q?vxRzJ7fvSPyACXyWbKGNJcI1mhku8QSpmS4MzUqLAE17f/bZ0NfQm1NGstSF?=
 =?us-ascii?Q?JouhOAkt8ejpOxM27IE6WhcZH0rZxP3dlQUvrrI1T8NODFoZwc1qt6mIMue3?=
 =?us-ascii?Q?1IgqG7g5qRZMyJ+BjX6NZHHhUJ8dRoBHySjXAaKkaSQcngkAIJGakx7XrTIw?=
 =?us-ascii?Q?8RcLgydXNK3VtRDgjZaELSA/hLW6Mm/BOS0DdtqD8RDgcmyljRnqV9NtFLZ1?=
 =?us-ascii?Q?3jKhkrP1j45Q18yQIDv+TXLERkaqC5HrSaP0nSbjmzvNu78vwtFoUCUB974t?=
 =?us-ascii?Q?Mog3CDQKYvghona0zMEaS58HG1GQ1ZyrRawVz43zV/rXtoLYekPCh71cwRhQ?=
 =?us-ascii?Q?UhslRC4xv09EmdpQ2zm8gM8=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f85ea38a-975d-4347-fc20-08ddf61cf705
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 19:04:02.1926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qh7iQf4lf40hMaT7/XH+qxbyPkzcLEwtfVLt2FV1Q/tvk4Ls3+Q5ARtBxta3OQx+l/YLddsnGf365QkgZ0AaCn6QMrNyybElA7ZgOU9ukZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR01MB8429
X-Rspamd-Queue-Id: 1A9881C0018
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 8iizbop7npm6j97o7q4xtpomwrixrr54
X-HE-Tag: 1758135934-372524
X-HE-Meta: U2FsdGVkX1+sCk3q8ghVtLRFwAlnbCa8HExTISL078zdpRi5utwy3sj+Vort3orKrGOMTR3DCbm9b2iK82DIitPTO28aZGpB3kNoWAx9GICxkx/0czCxM8vE0sLNFqfRYm5pzZpIFz6b/9EyqY/JqPd9O/FKjmNT4j0SMI8kojVHRD3OkgPCZJdmq2ECgLnZI1imJVsz7SljxDq1xVMPqID97MgNPmrVvEqnHj1EjPSflisGqXbMmr9Q1BdTTrrSzJhbDBJxnh0EpgRWFQrBpOBZvDqreJdEKltVQwf0w9o3Mg3ir/CHuPD0saXxGW961zukEmx7zirqo2niO55oMPVnm2wDPETZwBpB784RWHl1JZxTHf1m11TpIvwDF1EhkpF2ukSfOCdNDwoWlWWWiv5YNPdKb20yCyrXdhRU4y/5oT9RX3ZiGTRRwiLip5+KRmLz2a2uzZMpIyu7ZmFD/zIjWfT78ECklIXhYGKxAGyh9hdvknq8qz4Hl6XTZ4ggHcaI3UvNg23HCuOEuPxmYOAtXs09GUvnb6a8aNdWgQec5ddK2JR9wh2OgWAllZxgI2CTbDKJE2Zrt9m9NztuICMdAdKntG1j57TAtn3rjHroY4yRzUdsS+IUFq9apC5buM/eMfpfjlsesQypQwUKYBkNo6ufKhhmDeKD7Ml4h96Ai+ImVzzcpWwRgRIjKqH8cNUcoWxRlTEj8mMZnkGzJFnRIMHOzjD3aDlBOxIow+OEF0IM0OPOjSHtoUINtyWKZDpsAr3OVPFV/9P53opYHrzu06K/IyOCprqe0qKjQrb8GlD+kiy4qy1xXWGYfuFnpwRReag/SP5AIy+dqTKLLn9ILeNLXBYAzx5XzkFEKrDYzQ8KQTfRiUUrDbyfT3ul07Io/4EM2UVg7a6/ofVMrjVdLRmh5zs1B0KDt0wVkWNRqC2sjb+rYpU51LuI2ZeqdEedRzO8Mmm5SrDVZ4g
 wFs0bxeq
 BUs7ZMGG6YPccB1LDGbCTmPOUownYW3SoEHARRy4J0HHfRqhgzKq2n1kc+zhRUF4P6nfbyxKhqZIf5GPgrx/zN/zLKVZljnqdUlwhwWtAb5e5BUffA5ymrvV6KRhsr/MXgLTpHZQQm6Fi31lUsIMONgDD1Ns0L9E2dm0vp+5zKpbjKBEILAUked3yson5vjuiGYSZ7/PJRhWJm/hWaZc2TD8xknm0263143bjB+od+fXdmhPFW1xZ3r2PYILt2+bc7AiZCsCuFsd1Aj8b4LDzSvgCnMhLXF7DxtFC4AIKERcQIu6RrFwZTaTiSNueX5qptyZj+XIlpWH8J3daxkdT1Y5Kz6WStPJRcsF7ojjbTVTLDHjxvM/u/H8UzQ2Xnxk3n8EpR/DAxvu0MYzEO0GXKqc+utgFdgGQzJjazVEKX1IgKH59+WxLoEf9TE51kbHU94cGOe83088K4aVGtr4nJ6Sgn52Ay787YqMe3g+ts/05KN1bZpXkOcA0XlEBgn3BzNw0B6b9N5ZMVBmQ+NhLHHf1QH8wErOOTj+xoWwfPJjp9PCLoI5qWpq5l2tKZMxFXQINcEgbDqtFM8I8B5Yzj0dC13YxQ0zUbqvkAs7+xj0boJtINg2S8fRKlz9H7oVNWhM1xxBl1xSz2/QNhoBzH6ljTxrPfBSjz9D7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On systems with BBML2_NOABORT support, it causes the linear map to be mapped
with large blocks, even when rodata=full, and leads to some nice performance
improvements.

Ryan tested v7 on an AmpereOne system (a VM with 12G RAM) in all 3 possible
modes by hacking the BBML2 feature detection code:

  - mode 1: All CPUs support BBML2 so the linear map uses large mappings
  - mode 2: Boot CPU does not support BBML2 so linear map uses pte mappings
  - mode 3: Boot CPU supports BBML2 but secondaries do not so linear map
    initially uses large mappings but is then repainted to use pte mappings

In all cases, mm selftests run and no regressions are observed. In all cases,
ptdump of linear map is as expected. Because there are just some cleanups
between v7 and v8, so I kept using Ryan's test result:

Mode 1:
=======
---[ Linear Mapping start ]---
0xffff000000000000-0xffff000000200000           2M PMD       RW NX SHD AF        BLK UXN    MEM/NORMAL-TAGGED
0xffff000000200000-0xffff000000210000          64K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
0xffff000000210000-0xffff000000400000        1984K PTE       ro NX SHD AF            UXN    MEM/NORMAL
0xffff000000400000-0xffff000002400000          32M PMD       ro NX SHD AF        BLK UXN    MEM/NORMAL
0xffff000002400000-0xffff000002550000        1344K PTE       ro NX SHD AF            UXN    MEM/NORMAL
0xffff000002550000-0xffff000002600000         704K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
0xffff000002600000-0xffff000004000000          26M PMD       RW NX SHD AF        BLK UXN    MEM/NORMAL-TAGGED
0xffff000004000000-0xffff000040000000         960M PMD       RW NX SHD AF    CON BLK UXN    MEM/NORMAL-TAGGED
0xffff000040000000-0xffff000140000000           4G PUD       RW NX SHD AF        BLK UXN    MEM/NORMAL-TAGGED
0xffff000140000000-0xffff000142000000          32M PMD       RW NX SHD AF    CON BLK UXN    MEM/NORMAL-TAGGED
0xffff000142000000-0xffff000142120000        1152K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
0xffff000142120000-0xffff000142128000          32K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000142128000-0xffff000142159000         196K PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000142159000-0xffff000142160000          28K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000142160000-0xffff000142240000         896K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
0xffff000142240000-0xffff00014224e000          56K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff00014224e000-0xffff000142250000           8K PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000142250000-0xffff000142260000          64K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000142260000-0xffff000142280000         128K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
0xffff000142280000-0xffff000142288000          32K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000142288000-0xffff000142290000          32K PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000142290000-0xffff0001422a0000          64K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff0001422a0000-0xffff000142465000        1812K PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000142465000-0xffff000142470000          44K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000142470000-0xffff000142600000        1600K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
0xffff000142600000-0xffff000144000000          26M PMD       RW NX SHD AF        BLK UXN    MEM/NORMAL-TAGGED
0xffff000144000000-0xffff000180000000         960M PMD       RW NX SHD AF    CON BLK UXN    MEM/NORMAL-TAGGED
0xffff000180000000-0xffff000181a00000          26M PMD       RW NX SHD AF        BLK UXN    MEM/NORMAL-TAGGED
0xffff000181a00000-0xffff000181b90000        1600K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
0xffff000181b90000-0xffff000181b9d000          52K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000181b9d000-0xffff000181c80000         908K PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000181c80000-0xffff000181c90000          64K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000181c90000-0xffff000181ca0000          64K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
0xffff000181ca0000-0xffff000181dbd000        1140K PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000181dbd000-0xffff000181dc0000          12K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000181dc0000-0xffff000181e00000         256K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
0xffff000181e00000-0xffff000182000000           2M PMD       RW NX SHD AF        BLK UXN    MEM/NORMAL-TAGGED
0xffff000182000000-0xffff0001c0000000         992M PMD       RW NX SHD AF    CON BLK UXN    MEM/NORMAL-TAGGED
0xffff0001c0000000-0xffff000300000000           5G PUD       RW NX SHD AF        BLK UXN    MEM/NORMAL-TAGGED
0xffff000300000000-0xffff008000000000         500G PUD
0xffff008000000000-0xffff800000000000      130560G PGD
---[ Linear Mapping end ]---

Mode 3:
=======
---[ Linear Mapping start ]---
0xffff000000000000-0xffff000000210000        2112K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000000210000-0xffff000000400000        1984K PTE       ro NX SHD AF            UXN    MEM/NORMAL
0xffff000000400000-0xffff000002400000          32M PMD       ro NX SHD AF        BLK UXN    MEM/NORMAL
0xffff000002400000-0xffff000002550000        1344K PTE       ro NX SHD AF            UXN    MEM/NORMAL
0xffff000002550000-0xffff000143a61000     5264452K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000143a61000-0xffff000143c61000           2M PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000143c61000-0xffff000181b9a000     1015012K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000181b9a000-0xffff000181d9a000           2M PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000181d9a000-0xffff000300000000     6261144K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000300000000-0xffff008000000000         500G PUD
0xffff008000000000-0xffff800000000000      130560G PGD
---[ Linear Mapping end ]---


Performance Testing
===================
* Memory use after boot
Before:
MemTotal:       258988984 kB
MemFree:        254821700 kB

After:
MemTotal:       259505132 kB
MemFree:        255410264 kB

Around 500MB more memory are free to use.  The larger the machine, the
more memory saved.

* Memcached
We saw performance degradation when running Memcached benchmark with
rodata=full vs rodata=on.  Our profiling pointed to kernel TLB pressure.
With this patchset we saw ops/sec is increased by around 3.5%, P99
latency is reduced by around 9.6%.
The gain mainly came from reduced kernel TLB misses.  The kernel TLB
MPKI is reduced by 28.5%.

The benchmark data is now on par with rodata=on too.

* Disk encryption (dm-crypt) benchmark
Ran fio benchmark with the below command on a 128G ramdisk (ext4) with
disk encryption (by dm-crypt).
fio --directory=/data --random_generator=lfsr --norandommap            \
    --randrepeat 1 --status-interval=999 --rw=write --bs=4k --loops=1  \
    --ioengine=sync --iodepth=1 --numjobs=1 --fsync_on_close=1         \
    --group_reporting --thread --name=iops-test-job --eta-newline=1    \
    --size 100G

The IOPS is increased by 90% - 150% (the variance is high, but the worst
number of good case is around 90% more than the best number of bad
case). The bandwidth is increased and the avg clat is reduced
proportionally.

* Sequential file read
Read 100G file sequentially on XFS (xfs_io read with page cache
populated). The bandwidth is increased by 150%.

Additionally Ryan also ran this through a random selection of benchmarks on
AmpereOne. None show any regressions, and various benchmarks show statistically
significant improvement. I'm just showing those improvements here:

+----------------------+----------------------------------------------------------+-------------------------+
| Benchmark            | Result Class                                             | Improvement vs 6.17-rc1 |
+======================+==========================================================+=========================+
| micromm/vmalloc      | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |              (I) -9.00% |
|                      | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |              (I) -6.93% |
|                      | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |              (I) -6.77% |
|                      | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |              (I) -4.63% |
+----------------------+----------------------------------------------------------+-------------------------+
| mmtests/hackbench    | process-sockets-30 (seconds)                             |              (I) -2.96% |
+----------------------+----------------------------------------------------------+-------------------------+
| mmtests/kernbench    | syst-192 (seconds)                                       |             (I) -12.77% |
+----------------------+----------------------------------------------------------+-------------------------+
| pts/perl-benchmark   | Test: Interpreter (Seconds)                              |              (I) -4.86% |
+----------------------+----------------------------------------------------------+-------------------------+
| pts/pgbench          | Scale: 1 Clients: 1 Read Write (TPS)                     |               (I) 5.07% |
|                      | Scale: 1 Clients: 1 Read Write - Latency (ms)            |              (I) -4.72% |
|                      | Scale: 100 Clients: 1000 Read Write (TPS)                |               (I) 2.58% |
|                      | Scale: 100 Clients: 1000 Read Write - Latency (ms)       |              (I) -2.52% |
+----------------------+----------------------------------------------------------+-------------------------+
| pts/sqlite-speedtest | Timed Time - Size 1,000 (Seconds)                        |              (I) -2.68% |
+----------------------+----------------------------------------------------------+-------------------------+

Changes since v7 [1]
====================
- Rebased on v6.17-rc6 and Shijie's rodata series (https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/commit/?id=bfbbb0d3215f)
  which has been picked up by Will.
- Patch 1: Fixed pmd_leaf/pud_leaf issue since the code may need to change
  permission for invalid entries per Jinjiang Tu.
- Patch 1: Removed pageattr_pgd_entry and pageattr_p4d_entry per Ryan.
- Used (-1ULL) instead of -1 per Catalin.
- Added comment about arm64 lazy mmu allow sleeping per Ryan.
- Squashed patch #4 in v7 into patch #3.
- Squashed patch #6 in v7 into patch #4.
- Added patch #5 to fix a arm64 kprobes bug. It guarantees set_memory_rox()
  is called before vfree(). It can go into separately or with this series
  together.
- Collected all the R-bs and A-bs.

Changes since v6 [2]
====================
- Patch 1: Minor refactor to implement walk_kernel_page_table_range() in terms
  of walk_kernel_page_table_range_lockless(). Also lead to adding *pmd argument
  to the lockless variant for consistency (per Catalin).
- Misc function/variable renames to improve clarity and consistency.
- Share same syncrhonization flag between idmap_kpti_install_ng_mappings and
  wait_linear_map_split_to_ptes, which allows removal of bbml2_ptes[] to save
  ~20K from kernel image.
- Only take pgtable_split_lock and enter lazy mmu mode once for both splits.
- Only walk the pgtable once for the common "split single page" case.
- Bypass split to contpmd and contpte when spllitting linear map to ptes.

[1] https://lore.kernel.org/linux-arm-kernel/20250829115250.2395585-1-ryan.roberts@arm.com/
[2] https://lore.kernel.org/linux-arm-kernel/20250805081350.3854670-1-ryan.roberts@arm.com/


Dev Jain (1):
      arm64: Enable permission change on arm64 kernel block mappings

Ryan Roberts (1):
      arm64: mm: split linear mapping if BBML2 unsupported on secondary CPUs

Yang Shi (3):
      arm64: cpufeature: add AmpereOne to BBML2 allow list
      arm64: mm: support large block mapping when rodata=full
      arm64: kprobes: call set_memory_rox() for kprobe page

 arch/arm64/include/asm/cpufeature.h |   2 +
 arch/arm64/include/asm/mmu.h        |   3 +
 arch/arm64/include/asm/pgtable.h    |   5 ++
 arch/arm64/kernel/cpufeature.c      |  12 +++-
 arch/arm64/kernel/probes/kprobes.c  |  12 ++++
 arch/arm64/mm/mmu.c                 | 422 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 arch/arm64/mm/pageattr.c            | 123 ++++++++++++++++++++++++---------
 arch/arm64/mm/proc.S                |  27 ++++++--
 include/linux/pagewalk.h            |   3 +
 mm/pagewalk.c                       |  36 ++++++----
 10 files changed, 581 insertions(+), 64 deletions(-)


