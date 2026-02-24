Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27D0DF4BB90
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 21:41:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F09B6B0005; Tue, 24 Feb 2026 16:41:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 273FF6B0089; Tue, 24 Feb 2026 16:41:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12C4A6B008A; Tue, 24 Feb 2026 16:41:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 014F56B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:41:55 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9E3748B32C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 21:41:55 +0000 (UTC)
X-FDA: 84480672990.15.9EBB6FA
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011031.outbound.protection.outlook.com [52.101.62.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9A573100002
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 21:41:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fKrDPbzV;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771969313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uAuwhIDT5LJUb5A08skBHloRVGp1fad25oWn97pGiws=;
	b=WQZ1fzyGiRgG8FghB5sJAFVMC1G54GvgLdesVguQeL28GA/1Kt1afFJ1iMD85lZhZb67NL
	wVOVD/iPPbeU01ZeuTHXpVSU1IlDrhLYuXEQzbTzeO7vSFpk5McxPS4TaPtncpnJQPEOvZ
	xfybf00Th9cMdaNosVWZpyzX3rwP5T8=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fKrDPbzV;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771969313; a=rsa-sha256;
	cv=pass;
	b=jzuKJd2v+fZ1AYZqtO2DoknSVgmjiwzxRwHun2mYiSBdFs4l8YePfkkJIPIZf5vB84zzHp
	61uqpBQBAH3diXZubynwoFP2C1zIo9ag22CDP7Va94WRPFNgsAOz3vqgIRBIlk7+Y5DJ2U
	GHrHQf2I67PqoPIG8YC3NdlWxpc4364=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U+aLv8p80tp9ArdfHbOqtwrlgc91p97sz+Yhr3Ja1jj9I997zCEpMuF2+MmBmS6IrTSccXd1x1U28JFIDEKINFSTETjYO8bJjqJJVGA1+ayBaQrfe4JlYHydKJj6q3G/BVY3tTsIpi4VGWtgCybDNS7j3MlNou4iRpQ2htXHJOCSYO+nAYlRfps+ovT+FaGQz4YRRYuc29/PJFsfq6VQ78Oca1O00OCvGA3ZaoXXDi7IZKNteL/pGa2Ezjd/wdDbinqwmCktvDJH0n+Xmjg9qdWJs6y9Gs9bYRvMGhCbvaLk39Ch6fq8XUi6zd4v1A737GN26ugaOhhI15CvLmBYfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uAuwhIDT5LJUb5A08skBHloRVGp1fad25oWn97pGiws=;
 b=BxvbErS0eUGX3ZDt6A5bLX3SbrQxZAFQieYhXX7Kx8NhrXNpWcr9s3g4do8IjcwF/4jMnBrvLo1cm6r7IZgUCRWvX6rkxkYghWDjv9aauefuGClwNCIJdJ979l5ZLs3LFFTrEx3AaXocNC7VVYcQ6YanYZtOj4PkfvSSOjetOAxnGm2Gdbm4FD/59Kkdjb9hDnVXeRHNosJNhsIcFVyzEYCwJsnivUsmvn8/JYhUXElH+7uTEnTew5Wn0dCSktRboetNRaU6FZSSXkimowPHH55+uMTQGFdGmddcMZRPPQpItkse4/W3dq/FX73SHsn/yGXxQXiUkqVqut3j+NJP6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uAuwhIDT5LJUb5A08skBHloRVGp1fad25oWn97pGiws=;
 b=fKrDPbzVpwtPlYyBmRCMtXVWw+EhUnFdOEKPXExnXKweE7pBP0YttQWRZ9GupUhJkRx2HhxrkSkPPrV14/ELb6Y2Cc5w8pBK7aJGrNZPfA9j7aPwQ5QJ6t9xnesyx9H0IyGSwblPv8Bd5dUqN0dspssIXFhX5tSWECsVBxnbvTVMpPcWgxnLxEsG/Kx6GayBi1Ky+aLmYosrSIwMVLZdYzVnI2oisMccbHY8YGoryZapnkqwNjZqBtfNoMuMzeYBf29Ab0T4Q3Q5KBrJynLR98+iKtqezrBvpDvF0r2drvCG/M7JvbRFsV0ZNF75Dbxa9QZhdw8kn5y4zsexTO1Fyg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BN5PR12MB9540.namprd12.prod.outlook.com (2603:10b6:408:2a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 21:41:44 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 21:41:42 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ron Economos <re@w6rz.net>
Subject: [PATCH] mm/cma: move put_page_testzero() out of VM_WARN_ON in cma_release()
Date: Tue, 24 Feb 2026 16:39:46 -0500
Message-ID: <20260224213946.2328419-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0423.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BN5PR12MB9540:EE_
X-MS-Office365-Filtering-Correlation-Id: bf962a55-e5f2-4f04-659a-08de73ed8008
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KpCLKX6iyX3XNLwgtyOdyLVtrWIAx98ebUVP2Lh4e+NrOFwllWBbshc0WwwW?=
 =?us-ascii?Q?jLS4b8i3q+BGhju6+tV5VYCCVokWKgDh962K/80K82HsNl5FrZT1M0IpNNeF?=
 =?us-ascii?Q?5LMe79y4gzCDsuwrXXzN8rUG3WNEWPXNFiBy701N+ZclD6YcbM6AzK1mrKi/?=
 =?us-ascii?Q?neRm90rj+y5I9xjWD26HHdRqgPDabIfYOn3m7QAadUfwb84X7+Ie0S98gIZq?=
 =?us-ascii?Q?zF1Gn+hk7provYfaT9Uu+9E48pmUXCKQckXoOAyWhgs+txU+B++uPegU8puN?=
 =?us-ascii?Q?JQp/QE3iiAamFs/woyN/AHmI/AejYOwUnGSKCHkztMKt6ljgGlHyoihRlojl?=
 =?us-ascii?Q?WT2bsz/55a/qQe0CfVaBiTWK+RaN+shhk0dHbZlzzduvxQfufJTgPyQY7rue?=
 =?us-ascii?Q?rQLx3lPJSru6RnAZB+pqmAhh3ZBF9guOcMRf+shnai8Z1ry87tUQY5GNsoBB?=
 =?us-ascii?Q?SON5xqoGBAtz42XOgRHN+VcqdWWp9Nqslwegg9URKB+itHHFgClEeHfQLeQb?=
 =?us-ascii?Q?WT800ta52aqPYKn2f9y0NgCfHfWLrgHjems3BHA23ij7G89YmYJ1ECFnHZzD?=
 =?us-ascii?Q?kzt+bfYOYQWpVwNAnyzvlPPtSeInAYHeQqRdhIud0woBPRbrhpg3bdR9FOMY?=
 =?us-ascii?Q?BXiUWgsQPb7DIefUGvh43v4oC5jXYS2ZAJksFmzr3XWcEknw8OTzKmVtFH+O?=
 =?us-ascii?Q?vJ30O3UU95HIiFSKBq+w+qwooBaH8opXfcc3crb/tUmy83gVGXD7ZXXNoggQ?=
 =?us-ascii?Q?q39sKjrERaBr0BTyFbsYdqB5AdmqtI835N1vTZAPn3BPSuiDhgKC6gtzM2SH?=
 =?us-ascii?Q?nPIvvl8Smi/hBRWLRPRB5LMBp3bnCe5cC0cZp6Ggw8oWwFTZYTBoRoa3/Tum?=
 =?us-ascii?Q?tdYG3dHkgeLYVAlMUVWPINT8r1ZH/QAEpAvfDXka2nhWaMiv4Gv1geyOHSf5?=
 =?us-ascii?Q?u+073IYBRr9fC4GMDS+gOAdeAS5tPodE0mehapRTleBwAw2BptQb36Ewl7G4?=
 =?us-ascii?Q?i2qmjrFtzIsJICCfwQ+9UEJd94t9//3QPT901Tbu1n2Vxf356iQlYtJm8iO/?=
 =?us-ascii?Q?r58+0y1Vd4+v2b05YDX5l+CWLJoPgLaRVBsQGfaInOb15OlZ2aecoEr2hoEL?=
 =?us-ascii?Q?WQ5So3nBZqrRhwdQAKbGoYg6lNf1XLA3qhWSRS/Ukw2TCBNylyPaiF852lTA?=
 =?us-ascii?Q?BahSRCfi8QN1pPecNqZ9/d7UpNnD+DUZFBQH7f35HeBuzB/pWwqAN6fHLew5?=
 =?us-ascii?Q?jsEKCtAXuhTDVUJBetCoyNbyEg8LeJoFJe/3ypLw/EVgHCltuixfX1wHTQ0Q?=
 =?us-ascii?Q?SqeeR7kyOs02WRPOVPi7dARF2kuqRNfLDNAvpl3b9EBj/gA5T1DqJgeVoVZB?=
 =?us-ascii?Q?N4nm6jw1erx2bQN6qCfEESvE6VZH3mOYRRp4RgPaJrWYJ/Cos0fpsDpgHTnQ?=
 =?us-ascii?Q?yF+pC7gkSKr5Oj268BXPIG1AlRdY5L556FW7h+rf48eSBosJ/+JYrIqQ+ZdD?=
 =?us-ascii?Q?sW9XpeTLBtzOrxKrKg7vZFePBYwj2gPW6oBBPBb5xSEkzFnn3LTG+88TefAg?=
 =?us-ascii?Q?hShH+tr6uoUoLgqE8vg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ARRT76DnpGlfRdCSwDiGWkyHYo+M1AcCtwpVbp5YHa2qKWdgWj7QGeMlIN9K?=
 =?us-ascii?Q?DV1ztrzyAMPECDTP81CZvg71eVXEjEImxC2xN8bcR0N+x0ty7VmZ7j5e2rSG?=
 =?us-ascii?Q?+0XsgMItNEO+P2KxhdIi8mRfMYgTvvWoaROy3TGRAzRkgSaApNERCopUxeoJ?=
 =?us-ascii?Q?onzZRH9qtY2aE1BjhcuYUk7nPR3ushnTyT7lp119tNpxOCI59pyprmAoYBMm?=
 =?us-ascii?Q?waOiKYlkkYqWpvX+ykrT8sw9vj/NKPsWnXqhvvebZK9EEWFPnIOgH1S2Uwap?=
 =?us-ascii?Q?nrLVOKHTcVsHBwvmYBg/iWIPzn9rO6cGO/vcsnc3Pm7zcP+CHzeDhTDO0fqr?=
 =?us-ascii?Q?9/oNnU6CrHFCTMrcCSlSv6iA2VvhK1LWhmfSEXkwAKKZPeJ+7id+F3wZMgOj?=
 =?us-ascii?Q?byesBiL4Vw83s9da0YHhZ2bXYvbrhcPnxyl1RMSvG/IxmCYqDMzS89n+2xoQ?=
 =?us-ascii?Q?XOqn3fveAacrPNXu626Nx+gPNLlwhdvcCN88eoJSSZ7tjpzKHZuYF31yyWbH?=
 =?us-ascii?Q?najX7EfU2i8vj6il7xbDuiHABhqU7JBQ2Wy5Hvwso4TnuM9bQzVYoWRMEcLV?=
 =?us-ascii?Q?IoTChsYiSB2Z4atOnYMtEum9u58fWYbMZD9ah3O9/Px1P3zUXyuhXbg/NQ5X?=
 =?us-ascii?Q?CUqUANmoZT0qQ/Nk60zLCNDo4DZIs2TBg7rZetsV+2kmIM23adseRE7qvfxk?=
 =?us-ascii?Q?fBOh80FjyJtVyAiGyn6pvW7oXWmf5SmvpV1MuileNOZM+UQiJMmC9AimXtCL?=
 =?us-ascii?Q?d6wjKl34+OFFgS2T/Kbnjr9RRTbzKr5XnPeKQ2ED8bBd/KzvOBuvJ5/iZk4f?=
 =?us-ascii?Q?kY4Q11flj7DkbaOmJPVt7HW+xOOUK8csgRKgPCDyg7eUCWgd8cZfl7tf83N7?=
 =?us-ascii?Q?Myh6vKADJ/wCThmZbbUW6D+fXVVbym2aN6tvtHZ9MOMflLzE3x5Wu3CF/eXR?=
 =?us-ascii?Q?rjPe7AS4DlashaZrujkpRq9elECeT1CJS3LKUoKuvlyY4Dv+zTDwdofKauFy?=
 =?us-ascii?Q?j+vB3+JcfZKeoxGeRBtK2GJ9riUprScRIPch9p4BDE24nFz0CdUMIm9/Yui7?=
 =?us-ascii?Q?FbCjhjuAgzoA4cBHykGhppWr4Og9aR3eosixJ0yd3+D8mQ5zcuo5h8jrX1qo?=
 =?us-ascii?Q?hwXQvcMvsoZ9eIgEGXxi01ohe4ori5hICsTs2jyFR+e6FJtXSxuN6/wwTJEy?=
 =?us-ascii?Q?qQuZAX9e2dpKBa6vnDc8MSyf3GIoI/peSR0kgNmZQ4HvnodtS17aL9bZr87j?=
 =?us-ascii?Q?SsOYhlnPpfNZf4or2+SXZg91n153sLxP724+zgQnAh0m03sQvKrx66FYsxQ3?=
 =?us-ascii?Q?OuZOdesp5qirMKnxpGEpVRQbV+5QjrXdTGA2C44B9M5hhM1eijkG35wjsdNK?=
 =?us-ascii?Q?UrNyc0nXosKkuAnUGpJngzoCgQ/7tFaWcsCsldykNO5cd0OSWQ33av/qorcm?=
 =?us-ascii?Q?I6AM8Lltl+bvoMu1mgDWkiJON1744CxYl0maqD2jsM8N4ogmQ5W+0L3lDVbe?=
 =?us-ascii?Q?RonkH/6av881F5j/WHo5ZskaCw3waMRqVQcthPf1Qly1bwf3Oric810B9oSP?=
 =?us-ascii?Q?2PRxXFs/NDUXX3jerp4wfyo5/A2TBiXo9DzPP21PMKDnl8S39mO2w0qis3qI?=
 =?us-ascii?Q?1wm26Mx1KlSLu/uUgBeOOkdYkx3wZy868sQZt8aGwrCfCeGeLSc+WMiYuHqP?=
 =?us-ascii?Q?wi+dpgz83AJsHObzHy7DZ5ZFKY9B5rC4tewp+KFLN7CVWV+I?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf962a55-e5f2-4f04-659a-08de73ed8008
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 21:41:42.7281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GKs/1Ggpba62v7Lcsf3FvUl7Wn57ztNIOBXD2+STbCsGc+/bNsErTAinDXPttPH8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9540
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A573100002
X-Rspamd-Server: rspam02
X-Stat-Signature: qgjxqerm8frtsgasxgxynkusscpcxrru
X-HE-Tag: 1771969312-91574
X-HE-Meta: U2FsdGVkX1/16bYoq6NeHnHQxqvYtQgzQ02MSP05o4lcSlxPLGVGnlK1R6mASItWK7ZHVkvsILQyO8yQHufehSdVASS8q7+IZ8yxOEBVMp4PtAROfdDGfG117qyz/ugdo8FmgP3bhgOrC8SlRR2MDBRBfZtywakVfjbxDuSCa4ljB7j0K98MAI6S5HBDxDOS5yfLOrEr8dDaGuqR6zjYWDrZBlAFN9K/a5CebjekA3lB6MyJCngKCuCHpek5GDZzgvCyZvmQH0awGK2jrGju4s+EbB+MgxG6P3qTtHMr5pd1rE5kKEAXGLYobRSIYQoHzZhfSV8miuI624EqHB1Pn/+XMO7Zu3C7HdubKX6Eqf+xZrODuOL5vOoUI5bcvbCPL6A9bs/y1Kpl6wOb8F/erzrXIx9MfjOfbMrz1Z3vHC1Fuy25Li5LIyVXC1WOd59Z7CxLOy+29o4HAyLtV8O5gKCEsc7WCFyHi76WV57V8IxJwFpC+nNSgQbyVC5SJgtMeNvdlyFo6B3Ln2EYzjPtnrS9nN1J9TOWFFDebJhdR66gOQ9njDX079msgfoK4zxXxMyo8nI8aF4ZVkUov+6xzMHLvCMRaSVqQQY2ZFqZKfKE+y9XwCLyn3QCGNKSB1ZrIhp1awCYQ/9A1hul4Jv+BE0kIz/XlmaJVjjf2CEdTWuS8lgRv+bDD/Uhq2HVMVckCYVP+xoI3aoFGh03wnwGuBwHLYfsA4p9l/Rl9IhMLYdsL5fOuntgBqKouk2LdI/swMsP8/5YG+tppkrwcgTY8OJDhMGyvgQ6z44NJ+TtM8WfYG/PAylCrvoG8HkVgZGw5TGN91DM+LUOrMHpkIn3PPJHeRrCGlXT4mjI0oiq/NXyzmCZyYfRoK1aIVPX8KKuGFYEAdEBzyUQ5/CXgzzqOX57fE/QwgBdJaFny5uaKbPHzpDaDur5zrI2ZET80H01PUFm2ORM6LNVMJgYbNx
 5YOS0RNs
 eIyaM8Okk1PveSOoH1Me53Cqb5wTfTHOKKApxA5rZ7r1NsTbCIjPCtoYvxwCzNniVmyJYO/ultHT7+x9ox3IrJZ2scBk+Zcs8sDXSvncc9XdqPurr+ZA84DF+5TjoJxkJy3DpdZuBg/c1ye3Nxm2Mm95YWeDj0KrQMiV+PYSaKlP7bINQ3PFdbSR+ffiLSXlNWLK/VpO5Hi3KescKHgpRVJqRUnpXrF30z+Zwhuxui+elzPnYkGDjfouF71uHl5RVbx7+gofspPSMpVA4cyRhPp3hTxadvyGNi0l8akV9y+PHjqWSPK5ztImht2BBZaRrD58Fy2qyup4mGXEI3z05b4SnCAhm1syTXm/cdaGF+U9m02E5vMPfXCoYa2hOc429vwch4Mld255bIvL6OllVCQDQksMILm4jFUtMQw4IgvqLOR+SfH5rmFKhRDthsDIKXNugx4ChvXsDEW5Nmeo/Sq4T67xFG8YIN+fLlGaYFWh61pWyE5ALmTesbRFSEbja1a4IRlUjeKyt/kQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_DEBUG_VM is not set, VM_WARN_ON is a NOP. Putting any statement
with side effect inside it is incorrect. Move put_page_testzero() out and
check its return value in VM_WARN_ON. Add __maybe_unused to the return
value for when CONFIG_DEBUG_VM is not set.

Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
Reported-by: Ron Economos <re@w6rz.net>
Closes: https://lore.kernel.org/all/1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net/
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
Alternatively, we can use WARN_ON instead. Let me know.

 mm/cma.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index 94b5da468a7d..a9fe6e9a9215 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -1020,8 +1020,11 @@ bool cma_release(struct cma *cma, const struct page *pages,
 		return false;
 
 	pfn = page_to_pfn(pages);
-	for (i = 0; i < count; i++, pfn++)
-		VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
+	for (i = 0; i < count; i++, pfn++) {
+		int __maybe_unused ret = put_page_testzero(pfn_to_page(pfn));
+
+		VM_WARN_ON(!ret);
+	}
 
 	__cma_release_frozen(cma, cmr, pages, count);
 
-- 
2.51.0


