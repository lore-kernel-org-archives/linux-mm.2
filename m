Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B3DDC44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 19:31:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 726B26B00DE; Fri, 17 Jul 2026 15:31:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FD386B00E1; Fri, 17 Jul 2026 15:31:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EEDD6B00E2; Fri, 17 Jul 2026 15:31:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2CBDD6B00DE
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 15:31:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AC621A01FE
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 19:31:03 +0000 (UTC)
X-FDA: 84999261606.28.E604912
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010019.outbound.protection.outlook.com [40.93.198.19])
	by imf14.hostedemail.com (Postfix) with ESMTP id BDBCE100006
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 19:31:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sl13eXxX;
	spf=pass (imf14.hostedemail.com: domain of jgg@nvidia.com designates 40.93.198.19 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784316660;
	b=GQubPAjNM6miMznn8EOD/JCR+pMa/2Sh2Rmdoc9zjpHEAySYE1xcPe1ffFwLFr0eYJWY2v
	Ho3z09VgnSodOe+mMjicWmBKu5lTKUbMCSR8ZNyArJktOA+az4o6zi9cfy0M/fOxWA4mzy
	FsWmrqgDYtjpUzyjNfI3ZVky7BYSgbw=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sl13eXxX;
	spf=pass (imf14.hostedemail.com: domain of jgg@nvidia.com designates 40.93.198.19 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784316660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6PA+TdzZlrljfX2n/J8l2NaTi3Sp0X11AKY0ezcf8PM=;
	b=pdlFhsxVVDamVeZnpKaqh4PvSqXEayVSCp2W9uGGfDRVlsZVgyD449vAfpjHPwAwf2g2G9
	Ad1Buzuq/ug98sFzqo79cGTYrXNxPvJLt/gGL+2bF3qkj9eYOuCz+cA4qqQev5rX03yheq
	Fs+1e+PDm0SblBS4D6633t/OFW31v80=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C6WIUEHooLVVv/uyisoWPzXRlcght4CTTjvVerg7nHkL3ObHyZBsC1Xncdy8vzbJSm8qn7AUw1HbLyaAcK32BHmJ46cRzmpVxd4RAwsWSrpe2khHcTVTUi5mu44KwyarafHHyvcasT9ryPBVTBtgznMQflWhlTO5elfzUVmf5RiXOwOKhk6AC8XtayCOJ8PQF5v3Uov70NHnEJ4vQN8ysu5Ct/dp3Gtbjl7TT3JTjtAFgRuKDRiiNu65eBj7IjnSLLhabFsqOwOznSY/vEuxFYcXzEudR4Y6+YE5cBzCW5j5Wm1PH1FkTgxom1SodWRmHcgfN5l72bdIR09+QN+yOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6PA+TdzZlrljfX2n/J8l2NaTi3Sp0X11AKY0ezcf8PM=;
 b=rBRTeXpDml8UA5QngxD8tP8oS4wm6mOQc3kUA1ujf8f9KRfyWMwC80Z+D7tR9CdXixqY3At0EmHmE9kb22MW5pbUN1AHyGhPbXZS8+8WAtIZdhpnd3duumjAxnYZwIKppUhAQi2w/z85TwHoZVOYZLKA7h57DSaiCC65Gx2TNzNZPRQTXeFHvbvWBuPCbhL6KMeX33ldoufgs6WvM4WbKOnUmhvRXU8raDIk7490axju4xZrGuHY4fR0s+YNUEoFQjw9IOM5Rh+QYvB/up7KYaiFazPWAntkd26zRjGHCJ+jl9HU9i0dnwvJmovi0+BkI9/L3WLCYC1Ag2PvszLd7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6PA+TdzZlrljfX2n/J8l2NaTi3Sp0X11AKY0ezcf8PM=;
 b=sl13eXxXjGmOEHCjsaVKTg5cbkDe0kI65hL7IITlQM0cBNU51sfM6uh/+vWTsdJTMs6twG92F1zgWNC2rZ4FHJuafmd4NYyywrix8YyFAbOeRfdyxXTAeOiBysq8iT66ARLzXoPbDDxAvYbYKJay1XzlKqNM5/q6mcXnwKb1a+V2436aOLGeqNOsHsi8Bi6vXicEpUfnXTYZwi/Afq1Oht99x+Hlaol3jH0sk1cvec/N/Qx8I/MVq7gVwlqtjnenGDvOvQbjeNh3TRtS1H7eLRLY3r12cWiKquxFv0mHZOHdb/7XSYfkVz2mPOTomyNwLx+2LGqh0WAGcvQw/dYArA==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA1PR12MB8723.namprd12.prod.outlook.com (2603:10b6:806:385::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.13; Fri, 17 Jul
 2026 19:30:56 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0202.014; Fri, 17 Jul 2026
 19:30:56 +0000
Date: Fri, 17 Jul 2026 16:30:55 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v7 01/12] PCI: liveupdate: Set up FLB handler for the PCI
 core
Message-ID: <20260717193055.GD699082@nvidia.com>
References: <20260710212616.1351130-1-dmatlack@google.com>
 <20260710212616.1351130-2-dmatlack@google.com>
 <178431652443.189683.17611165218179620081.b4-review@b4>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178431652443.189683.17611165218179620081.b4-review@b4>
X-ClientProxiedBy: MN2PR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:208:236::20) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA1PR12MB8723:EE_
X-MS-Office365-Filtering-Correlation-Id: 405a94b2-8d9a-4d67-2d28-08dee439ec6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|18002099003|22082099003|10067099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	D1BVNH8FiVHrz8lr4Mbhq1T0k6t953BUKzmhS3+ByV3kVrF8ntYuUypUzHlt2lg6e5yuhD7mD58gXm5dqaKwfqvU/AdTUQ23h0FltbtLMRwalA696HvvQhZD8kjxnKD/PBM58iHAClq2beI16NVem13x/Jv1duYHjPDeCLzriHRm2O488ZfCnvMG7o1LvasGBEQHXCMbFbXQckTHkiC3/lGegGZnmaVik7ubzbv1VD6CjPCR2XVRLb3/VaYmWHwWZCZn3Al5B/Y3KWSG17vGiEXYkLa4PakVNuqE8X+b1qSfoQepCkw8hW0Elo5bwpXFsfvWZGX0Vr9gTAAX4aMKcVe4mlaluPggjirctPzhfevLMDU81U/xhzlfLn0+dvKWCou03kkQGGCIztB2r9Tl0OkEpcNHVd0CZu1/E5A7U9JIkh9y4nVH0HxgxwbF/mjBrNLAhADKAiYwbwp8AqZy2Dkms6tfLXPjO7b+nIPFu8gN00LPL8YAxgQiPomCLUl0VK69v8SXiFd6MWTD8MvIvF5/s/drlCWbOPp71wyG/DH9tvgLp5Uv85MzmN5s0H+AgePE90VC4tPvu/+4UmFxTQ9xGQrTO6ZkkURI1Fezpkt/H3UDP5XIKIDcXn2fOGUtCysofn1L7fDQP/YAP8bdLzh0YubeFkR00xNKxa9CeLo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(18002099003)(22082099003)(10067099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZDRXUVFn64Ray6jmEfddl9eBSh263WCGOk21bymcIYiJYMXfWLf6hXFo7RRg?=
 =?us-ascii?Q?da09Uz3Uur4FFFeB03iLU3YRUQJXSVteV7ojzKK/U0DaxqoxTILc7iNdDqk9?=
 =?us-ascii?Q?4V2NZ4Xdp1qb/kFvcF/i+9xnrTN0xIT1afg7lj4xxZcn+PD3q+9Pi1ULIgxW?=
 =?us-ascii?Q?NyhpCx8eegH7IrsvJ5ZDn4Og+tUwNrzsFXn5j0+FSJCD6y7y1EXAMI/MbJmu?=
 =?us-ascii?Q?XNbO6pBhARAbb9QqOgviCbyANznXKqbCGfFvjhwFtiHf7Iek6DORv4cVnsNF?=
 =?us-ascii?Q?Zz3ez9mV4LAgpDMOyBgyRl06yquzYwj/JzcNIZsL0wKQwklGAbbF1tzdoZjl?=
 =?us-ascii?Q?WqDEnEaNKCdc/sAF2eTLDrx1Pi3IcOl6wMPJbOUCuZurGukFL9qR108fMdSs?=
 =?us-ascii?Q?PBdAr4754HFZDpYGDBh+tW2mrP349MmpaR865wYbDPhv6RRQ3Ow3Le7/nMiT?=
 =?us-ascii?Q?6FckSxBMTxQKB2Rvu8yePiH1Fty8O+GSmNXR8G4Sr5m6zS9Wd/Y9qbhgh2S4?=
 =?us-ascii?Q?eO81A4rd1SILKvZqLMTnWUrIC6AK3K2PeIBo5RW5j/MXoLgez2GICkmOnuyZ?=
 =?us-ascii?Q?u2W8o8NoYyzemZj7V1BqMYhTyy/KpoK+aj2m9pF/9WuBwY+WsqcLxPXN6iMV?=
 =?us-ascii?Q?gj1xGw3LRU+L8xWLdWdD3BoiNtqkp2H7J6HjuWTQ99J1SCUnwrrqoKFnBYpp?=
 =?us-ascii?Q?eUppRjPQSdOBeF3zDhzSNtvEnvD8VKQULNqMo/fH398p5nJrwcqRrBXv/ktk?=
 =?us-ascii?Q?fClEcRqUPOaNKidiVkNPUY0JjZmOlatswLSqheIFvqZICuAf6d98DHloYsIR?=
 =?us-ascii?Q?Y9z3ZfOXSy4oo16Ac00EhdCsyvb1wmog2ZQEngQ3rlmXk/VRwKObRMP9EIsW?=
 =?us-ascii?Q?txGWPY5D53yoAfMBMm5hUZZy2ivVMBApX3NhcnuSc7S1Sitp/nFo3806EilL?=
 =?us-ascii?Q?nnYWWB9tVtDOdqJpxLmAuoHXbktTE0LG00kar6qhfdpnJCeWSq949E/X00Gu?=
 =?us-ascii?Q?FOkTufDlN4xXAVx8J5KdJGVE2j23qYm7xPEjqVUnUXumX1Yh4uB7KXMuGwRR?=
 =?us-ascii?Q?qFzkEJtrCQ+fTY6dccTxIFidzdsnqUXJGRM8SIucGthljk0w7Qs7eNjfQaV0?=
 =?us-ascii?Q?BeNE+PO7SZy378G+/2hOTCUUsdsEbgcCvzQNrVh3AYKw9uxNaEbI5Upn3LKh?=
 =?us-ascii?Q?R0YXTIJhTQKoSWKhQnbcpTRuYTGsl8RnUJf2FjwWI6zfXurY3NeUYp7iUqMw?=
 =?us-ascii?Q?5Q7Kh2y/+RgRJ9AViz+s4LZuo+jeexf1FoQEwIILvmM18JrrfyNWzPJr02wT?=
 =?us-ascii?Q?OHuAY6XLWrK4OIJTDaB0QJ5qYlCwJETI1Gx0rZfWvF9RNBfVlsI51flAiTx3?=
 =?us-ascii?Q?1FRepmkfAeR8lU8+azX5UjGeqqFEpSEgAbCS3lLI3i2EEihoTlyC01kvQpM7?=
 =?us-ascii?Q?Q9L98qN/5Z2P6gZ9aFjlC2vgorqZtlPUiZI5GkWWaydM84I7nqUr8WJgKy/g?=
 =?us-ascii?Q?cwGoskFbU3M6igsH+HFl/z4gZHrftznADK+H2h+Sb2P/sSOB8vDrH01l7V6a?=
 =?us-ascii?Q?Pua9ydqPjQy5OiXDtoCy7qNjy8/dXbHczdBjuQBQeyxggGSGLUY+RwzKHSc3?=
 =?us-ascii?Q?CNNcxCLNAKk6+maj6Z/Np+I97BJnOLeafkWgryjVWV8wAJYQGIJ42VjlfBLM?=
 =?us-ascii?Q?HcH1BsALlEz2NhXayXwNeFniSI89pPGYxDP3qACIU7xUEsi2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 405a94b2-8d9a-4d67-2d28-08dee439ec6a
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 19:30:56.5693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eD17RG3oDH95D7h6xbPxBh+AwJmKrfS0SjlHPZAEJIoI3ECZECOCeFxB9tPnaAAV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8723
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BDBCE100006
X-Stat-Signature: c5ndcoamrcss45qf8yqct3upd6a58af6
X-HE-Tag: 1784316660-504085
X-HE-Meta: U2FsdGVkX1+ksjpZPv4E1paMdaPzafQw3t7zlaGwPXciTlBJC3kJc1hnzyx0/tfRec3g/F7/wCUrN3gcj2ao0bAqpdZWUDIlZm3+6milZBV38ZB3wplSSgtrN3emXwZFjg2NcC3QW5+3gs8sZN9bZ97c/1o+Wbd0pR0xqWz1+wgw0x5hrwBBTAPuZlfWk3wC7yn/y3KyO1xJpIAscQwco7TloYpeyeoJvZiwcNPj1Rr0nK39Lrww65KA/CU7fSsPo7tKtDubIqCTKiOY9VeZyMJTJuN1tbfSGBjIWeYwhXhqSb2fZJAGM85Ix+eZrHdYIoQPIHL485VsqdypWhj0i5hMuNuMfHUVpSFHo0gU6ktIEepdDpElsEA7WZ50nzS3K6ScmFbOR26Ey3iWwwSim9Bbz5VvCcbzfkL3UJobkbKSGcpfmfmmfwF2ZYllR+bmVinUDrro/dZVPTVtUNwf3GtgHDNrerHO5LyTccOH2IYrL47iUWJ/8nw5pXKJZOHDtCzxK8ZJ3QQJq66k0R4tFTeGwK6SSLX/nFmr3SmA8cWyZ0KZFt7zo8s2C+/sajvl+vqasrAZNp6zjafhEyxxvDvOMbIqcLC7bLuOEonvNlhs7+jJIAvhSVcemaPKKTUec2eV0WmmoQCeKbMCUWXrRRBdZYyFft3D6JKTtL6zdJtaDoFFxhV1q/JzVnrqxYMFOBXM+a4IS0EOr6eQZ6HXsbEln18u8PrlTizOBCGWS4qlIVY4rXD9/bXACLcnHetYr6+k01z2EDnvu14pW+IFoIydzuGRBpxqP4R57h8Mr+M/VBGWXOjgxNL8KwRcWoRWq9dNPmdmUscOBpi8yO1mOBKQdJtYg4mInnCWKyXlAFIGAjPoRf3aDWh8D/7olz1TXoaSvuC0yWo5LkCLgPOy76ugyWYBXDcXapROYdx1rby+0rBicZ1T1M8WxwzuDoyu35JyoV+QMLpkXuD4euk
 VxRMeknh
 fzP6GlUNBo79JDoP1eMp+39QpSbG+skpBTCLcqRUpyQJ71Mz0Ym70UJ7kLK/tKQP5k2mfFqXFR+pfP1HVbVFifFNlrOiAPnvXxVaL1lMz6s8c13lX99kzjNDlX2lqGLZI18jOioLZ9JLD7k9rcr2TFi+q+rvUvgvLUGTf8dFHdAIauaEwKHXFvqIAXqFa7aRamJbnOckG72alh9PTyWkw71ykgkySlqlhZ8Lo9eMxuuPofn9FSdQYDecyxEzbyGbO66HmjvN6LqYelwnrjoBpicymoD9XiddbwCY2tmRPF+lwgQFsJ+0AneKYpOJrFhfHduiqdtkSRv1kZQ5YswnqohujrH26XHjtyJG1IHdX5ljuuaWMpLaPUwW8SMjP4GnlgVO64NmSzRuOExzAI1pg1a/G0+kGM+FBkHcx2aTpfzy5WIdavnp+eZssQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 07:28:44PM +0000, Pasha Tatashin wrote:
> On Fri, 10 Jul 2026 21:26:04 +0000, David Matlack <dmatlack@google.com> wrote:
> > diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> > new file mode 100644
> > index 000000000000..899758883dd5
> > --- /dev/null
> > +++ b/drivers/pci/liveupdate.c
> > @@ -0,0 +1,155 @@
> > [ ... skip 50 lines ... ]
> > +#include <linux/slab.h>
> > +
> > +/**
> > + * struct pci_flb_outgoing - Outgoing PCI FLB object
> > + * @ser: Pointer to the preserved struct pci_ser.
> > + * @block_set: The KHO block set holding the outgoing devices.
> 
> AFAIK, these should be aligned after column:
> @ser:       Pointer to ...
> @block_set: The KHO block ...

Gosh I hope not, I never do that. The horizontal alignment is such a
PITA to maintain.

Jason

