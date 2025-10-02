Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3829CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 13:54:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F5B18E000F; Thu,  2 Oct 2025 09:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A5E88E0002; Thu,  2 Oct 2025 09:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36D888E000F; Thu,  2 Oct 2025 09:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E40A8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 09:54:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B98C7C04C7
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 13:54:20 +0000 (UTC)
X-FDA: 83953318680.06.708352F
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010071.outbound.protection.outlook.com [52.101.193.71])
	by imf11.hostedemail.com (Postfix) with ESMTP id DFA7340004
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 13:54:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=T1Vb7Jff;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759413258; a=rsa-sha256;
	cv=pass;
	b=fL2x3GobZBAT0S0BhwEOrC1px1KhaO9c+IzgqBR9g247c88lQc2PtcKaTr4FTTqkPdM9F6
	/fksz3YAP22hh6khOVA1XM2X4Ou7q7szLfylvjMNDPJnbicc8jCuvgxSZR+a4xiR/q07sH
	/RB7bIBemv+cdqFaehf5ZQTwN3XvanA=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=T1Vb7Jff;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759413258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WBE31DwClJBtVQtjB1gBKey13rmVJNYNJfawMAb+WY=;
	b=DUcSKSfX/dHiI1hP4PFfrBxtOjisQpiIbFICPWZ9AiWE4YXpj63PQPgI33wwchZpeKNDWN
	KwY2HnCzhQBaFbzel41CF6Pt3FJBmUkWs5gxC7dwQb+AA06nnrG2t/wvVfnjZGJfgwx71b
	g5TH7hzS1JTWTbbWSmpJfSgrM4AfNcE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cxHOYIM7ScYsGa7Xv1GC1PKI0oKY/desY2e0haXN3Wz7BXbJEl3mSr30LNFKlTvwP5Ef/zDfIlT/ei3mwYm1LtdR5Lswf+nGYiJP65g909aZFQqBPTJg57h81zXBpCCLR0aHCxpFcXHwgjBqrsrZbaQXdYiKzyqRnrAO3yCoMHSq+iDcBDc7AC42FAN8/7TN3whS4DC4ujBCwA/HRio5SpM+F5HjdNmfe5R1P4qBmn0W6kVSC8/Pgk0vQY4mQpYACvATJtRX1xkYkHmQSuoSPehS/O06qawa86yTHDlYNmDYRF5Q5wGeUj5/M3PIrcCIxnLYiL1DVnHIt/UIX9qa2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7WBE31DwClJBtVQtjB1gBKey13rmVJNYNJfawMAb+WY=;
 b=BZx7XCoK4k2d5jZv239Jx9Gd3vd1pHpAt8dcVxWy0lVmnRRi0sgjDCjpYPYBoteCa69mn+6y8lDEyH3okdb4vEnvm23hyo7XK8l6C9HJtWL1KEn7hK030HRrLGGABapPSM/Khxa3fkcDGfpbGT6rk4PdE1M2+q+qd8GoCL4j/jzMFC5Jx9JWijg+inzauyizdsI5EADrjoiOFLfZwIeAm+ItXVAHsvOSaszdJLUJZMuEfXioag7cyddbf+BJyRu1YxEl3vBksiHtK0O+h/48+2c7yIbIOMGwV+ZbzppWifDeeeC/DbhA8ifDcOTeudaS+sUsprPW6+rjKvjoZ0FQ9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7WBE31DwClJBtVQtjB1gBKey13rmVJNYNJfawMAb+WY=;
 b=T1Vb7JffVRbr/NDFS26PTzxyUKMNVEprG/t7yA6QsdZSf5YLkYqOKNOTJVAq8gf+VVeF4t5Rlx4qhrr0CiL7YDhG+2SMmxRgKfiKEvT1eBxo+ZUux28pbTE5UPv7WZGa76cpGG/lvJIhLI15ejHBR1tOVjLKj+54pc2f8/AbVnK8AcfTYv0liYM05SfYiJm7r8vyaMgFejJA2hV1iyxKclZcTv/0+FBcuSKeZFTFGmcYxl4MoiRZVySo0JblXs3XhPNCW2MCfxIVLydW34rTwRIE8VYhj85m1iT9NDfm9sAlzbMu85a2ln+HVlPQWo8GzLE8YSlx4y6BLYw7DLCyWQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN2PR12MB4254.namprd12.prod.outlook.com (2603:10b6:208:1d0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Thu, 2 Oct
 2025 13:54:13 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9160.017; Thu, 2 Oct 2025
 13:54:13 +0000
From: Zi Yan <ziy@nvidia.com>
To: jane.chu@oracle.com
Cc: syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
 syzkaller-bugs@googlegroups.com, akpm@linux-foundation.org, david@redhat.com,
 kernel@pankajraghav.com, linmiaohe@huawei.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mcgrof@kernel.org, nao.horiguchi@gmail.com
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
Date: Thu, 02 Oct 2025 09:54:09 -0400
X-Mailer: MailMate (2.0r6283)
Message-ID: <CD6D8EBD-F139-41BC-9A59-5033EF5A09BC@nvidia.com>
In-Reply-To: <57d9aa32-2fc8-48d2-b68b-3308c7d58125@oracle.com>
References: <68dcb33a.a00a0220.102ee.0053.GAE@google.com>
 <2afee6bb-b2f0-4a86-ba8c-d33b0b477473@oracle.com>
 <637BC0B5-B911-4A79-8107-BD7CDB351660@nvidia.com>
 <A4321695-9F12-4C7C-ACC9-72FD84B6DB2C@nvidia.com>
 <57d9aa32-2fc8-48d2-b68b-3308c7d58125@oracle.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR21CA0018.namprd21.prod.outlook.com
 (2603:10b6:a03:114::28) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN2PR12MB4254:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c5fed8b-9c34-4c0a-0331-08de01bb2b49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yAY1LVLlv0X8lbfbGJWZALRATM0SXslo8FF5xhmSUr1DvugE/BiXv2yUrOmw?=
 =?us-ascii?Q?38cG9r1as4Me0AkyzYAJ2m695LI981BAWVHik8Y4iUzwzioa2Y42VutPDGQo?=
 =?us-ascii?Q?wRQcfT5sxAapOxo094MvM4yFBGZgq3jHj6YdYoi2b/nTOQehpCqU5/taQVnI?=
 =?us-ascii?Q?rTX4Tu0AubSFcPEOUc+GlfBeMv+oiJh6E4UXKRnbMXoKRyrN4oVJP/c7lP2v?=
 =?us-ascii?Q?6zpF5SbVEeyBO91O912oaODD3xs2N5P3Dqz+jlILoJn1VzDaadSYoTykCmC5?=
 =?us-ascii?Q?3JE9gETMfACc965HKV43sZLXBBhha4r8iKKi9UwoHsfM0kWy87fE1yAFYXFa?=
 =?us-ascii?Q?M5DawEK8CBOBUOXS+FJ2TanTzpVj677MxrSLGwcas4nCfpGImBFNgYUDu/vI?=
 =?us-ascii?Q?ceqg+MFR2ZJwt4xSEUltjjy/aeCqDCbggcU3D+vHP6GAPVwMmNaUlxPmir3K?=
 =?us-ascii?Q?AiNVeELw1sA62R+Nde8dtGgh57n2JXR08biAYcJWInTyA3C5EPoZPDZHsvnH?=
 =?us-ascii?Q?SWV2tFltym6qMdPyuTbWEkAv16AyiNw7NKvJoyiOHDMpG51+EjSBtxVGuR5v?=
 =?us-ascii?Q?jjmhHVT5SS1sPLGRahnxaWb0LxLwLGB+3YX9i57K5SED233DslwMWNbO+vOP?=
 =?us-ascii?Q?x0wUigigGCnvA8wYqh5DrcRXY6U3VrHN3IRFrAfhnYzcdGqqHF6XknDv6jMo?=
 =?us-ascii?Q?9bu7cy+3HDx9+t0y6ce5FilJbev4jaow1WwWsTtoij2vNHU02thGmsK9SeND?=
 =?us-ascii?Q?CmrbhY5rbViOOJOR5EZ9ZFICSeq3CJfItR6tEmofQsSKYjWkNAQ8mkJGBMin?=
 =?us-ascii?Q?bogihOLlXEAzGzor+x/5LcGAY8FffYGz/CXKSw3jMCuXcgTEuFSW9C9FAtTD?=
 =?us-ascii?Q?X3+cOcOr5k9GyWLR/Gcue2vHOHw5gCBgOEWgz5Dms8Jq/DSmUzYZn3IOChUg?=
 =?us-ascii?Q?0hQL0fJWBjJ+i9bNrV/lWgW+wermCQxQpBtVOcU4AO71ncktxbsNkPKfFtff?=
 =?us-ascii?Q?ApWqzZBvP4e3ehrvEe+BdKNKYa9/L3qAUz0Zan+D22UGsQEgwgYI2lgl/Wj+?=
 =?us-ascii?Q?8u2mRRjyXXABNGOHD7me5FoWf75ar1SN1lhmS7kVAdZtOKnj09Fyu+xukpYu?=
 =?us-ascii?Q?HRZMj1SPTCQjJhMSSGoTAPY6BdOBmaYtujhkKI4c5uNe4zl4/gVSP1TruzEv?=
 =?us-ascii?Q?sGrWHi8pm1/L/4tqmwb3MThtQIFtivRylF6bNULbKqPR6bKFnEw9s+WiWZMn?=
 =?us-ascii?Q?LGIfpgk7Vz2qVCeZZyVkP8l+DNAHatTfEgn0YNQWTfJRSkyA+w9qdp7NPvMk?=
 =?us-ascii?Q?Y3hMQcRff3SfSdbhacqiDJQ2DhXfFkYbOXJU8nN01RhR8MMgQ1YSb44vUjr7?=
 =?us-ascii?Q?3EWns+cgTr9TFjC3a3o3euYva9P1VVOYcA8H5z6vF54B9X4VkKFFU+dv7kiH?=
 =?us-ascii?Q?V1yT/GwS63WtKSwow0IIp7+hRhL6+h9C1UQfy9zKkX0LIbrwPpsaOA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o2Kjgdjbw3I8+NW4jaICQthVMFO5AddxPKgzBzNgETkfdH72NqwO6oVUM+p7?=
 =?us-ascii?Q?4c/KrxcglybR5+LKsRj7yWskpnreZ8mTGuiSygRb9lLFMZjDOdgbeomeDk8+?=
 =?us-ascii?Q?393atWWND9rx8p52Tjqtw6QtPv7nILKL6+u6kuZ/qvpnIj49cpJbIRvijWhq?=
 =?us-ascii?Q?+RvuDrtrawqnDwEuQEmx1thDrNFtJSvGzPiXcWjb5wgHEL6cUxxY+miaAKqm?=
 =?us-ascii?Q?v0elO/nzd9nM7IpBs9hH5oAV970EhDjKj/kgqQvJA8btJSSG/Eol2PEfYcXI?=
 =?us-ascii?Q?99sez4vLqCmPzbWtrQkOcVFbWbnPs7MvToX+Xhd0AffoE8KZBMNrj/D0dqqZ?=
 =?us-ascii?Q?NZtRyi7A+ay+fOl0UTVgXPGOlraHJQgV2wrcwq4kbEccogImnJwRjxWPHuAB?=
 =?us-ascii?Q?U+IcQd/ySXt55hSmMSTqk0B6FoAVee36Dp4/MBCI3NGOfshSwBUF4rNUnYva?=
 =?us-ascii?Q?3ltJ7e3rPTuj6dNtHopmKm90pD7NqQoFPw2WkF1rB699o1Dd/4pMucFfmY9a?=
 =?us-ascii?Q?F27NPpsuwJnZV0PjzpoQlAfX4LdItPkS5+MX7RcvWYdErGUlF5LgiU7+rt/D?=
 =?us-ascii?Q?Kjrn0f83Au6AcQA4NwaPV7GhlK1BbHMaLlqnNms8jdAcIy5Fkziwr0SfUqOv?=
 =?us-ascii?Q?SKbEjMlPbV5Yktm+lIWswKl7jlRN6TZk1cSJWTXDPyiHnUazNG0fvMYsckfP?=
 =?us-ascii?Q?A8gT9gKsfyfVYlK8SLUlAQVIWLVJTS1GEav2ZTu21lBHfJha4vAfQLmvEaMn?=
 =?us-ascii?Q?Gr1bamdNUrNHwvhdR17DmwCydca4a6lnuqD2oKPVXFwB3EPWVykN8KJVfpZ0?=
 =?us-ascii?Q?AdtjYMjWs9laRp9EcLaZ1p1tPkcnUUpg4pBjkkHWHZTVoEgCBTRhoqtfKXE/?=
 =?us-ascii?Q?yjyoLcSjBORrxwcrUmYBEWo5ncal0UT40H2uYZr+8hSh5T3bpg6ve2GxAnfl?=
 =?us-ascii?Q?2CccCUtykLorHYYdHjIGsUbQi2fxC3xIduvBa7YwBAdkk0tOSiuQmn0KeZvh?=
 =?us-ascii?Q?fqTXrlZAA2qKXpHErlXFDmIKGTjJcR14Ar4ZlM6SFITeuorJmZ0CRJlkBT6k?=
 =?us-ascii?Q?kIpnOhTZu0howq3oaCgsDDJ9lF4tiw7bjSV3J24BImrZ1bRx6SuD3U4PEIyI?=
 =?us-ascii?Q?ngSj0p27cZoW7hJmDtv8vLAbypFaBNJa5tEpOCVjk6IK3d0FvRbK8QgiKvhS?=
 =?us-ascii?Q?pj8ljPUJjvWs7qKHJoxB+CgKnWyfPpwX1W0E3BYkqHlFFyR/bAF5K12cTvE4?=
 =?us-ascii?Q?vWM/cZtji8nQESlANg8ZQRSDFFHSV9fDq3Mrajw5k7icH8ivOo2Zwjn+38rK?=
 =?us-ascii?Q?iqdSr1EO84XTHoaO9JuDinDYEnLl0o30F1sguD91Dk37wKMxnkK5QMCsnmrb?=
 =?us-ascii?Q?lwuZCsMyC2q1JnYf2UwF1/KyIUwll1NeWWmdlMteSKWE2lAuB1Ul9OD2fdQs?=
 =?us-ascii?Q?UQEcED4/dcAaF17eI4pJbA8gnRX6YmIon8drLk9QdB2uIQKf30RflOmDH2oV?=
 =?us-ascii?Q?gDDb4WGYGa7jRDHeTuzuJbZxsaxaPr4/aE5c7vuaf+ARl7WLzt6gAQMvVnfl?=
 =?us-ascii?Q?baEUjS33KIh8SCOpXoI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c5fed8b-9c34-4c0a-0331-08de01bb2b49
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2025 13:54:13.1417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PQWxgeZdAGbvrREn9mOcT78LI2k3jRZyFaAvWR3FFWNiSoTCyMsQJmaPON7joeN9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4254
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DFA7340004
X-Stat-Signature: 5dnaeicaststm9fff38syge4c5bfzj69
X-Rspam-User: 
X-HE-Tag: 1759413257-1955
X-HE-Meta: U2FsdGVkX1/tJfdnxsxoHrg826YOPgDOBgSiOXurxzHBwfYRdPz5LDrG+Ai6qPOhT6ZSGFipScFMvHKgrSeP2lGlE5IV+dutC4OGXL1qiDqgAeze32KwQC5XVBv3XY8m/hLpHh3XOQKg5VSt1yM+eXiOqeOJJSJaDwR5NRsFYGe1GBJwWdH6D2TAizLdDC3wnTsQ1N+LiYSWl+kejbfK2D+4HmMxmHIbDyf0Tg5eaiCm7vLgcg3sfrA6XBSaSiOLcsRv5k3gCz/LtLQg9Lk8gHGsQ7J3TxI1vW8mHuF3wZGEcpR4V0cOelRgulAdC4k+zLie0ruGKO7ZbY/aGLpsefgjycUuPCConiNjgGFaho5ThWoVfCDEsA0MDJiUIlIS67AG70nUAZND0u2V5FjWO+AFzKwPHx8ucL4YY4ern8o0JWGNs73ZNnpI/hAyTXZQNdSYVzT+gOD6eu+0lb0BUX/SyB7foI9QRiBWQnZ3+EpAlJ2Ux5UOaHHJff4/lu51SlnAoV9LqQo2IWfLnhWoONZxfWQaUDPDSOMlkMDbr7jgo+8DO7YfZdn9rfREVQw8twsznRXvsZu40fiw+DDKxBAyPi/+URwwKFyELzdd3mgJZRew1h3R6Tl72QpTKAXMku3aOLxWjxPqznyKgG3ZvjfPjT0Sf5Ly4xR+I6w2nCWSgCKXjoa+29jFXi/JU6dgSgic5hzMcWQC5+m0Ag8U+z2C1Iog31eF2ZWPj4V1oQyurugplUL+DtMKeahJWK/Vx81vAaOl61GxGjA3Cfl8Yarn11FCL+boj6h76KkvPgDrT2LvuA2egI7DLf5JNAmyPptjYISFY0L5jF/fC3I+9k6TeOpxBxHbSCxqKzI+g6gwhvNm5Ea/PTad14W3pClRhAqIw8033BdXntnoKfntqJ8kQ+Bs8fPcF+TKF0a5CyQByjHZYJLYqAhoow+9WP7Ou+MeJLNo4e2im/DdJYV
 UZdPVsiH
 uaSnHuoQ+3CXrvSXDx0nfwOQpK6cGcc0skwZ+EBbTYZ8dENOb2Pm1pRodH0J23wIHlXov3XN0AGkU8R22FEI2TMupF1MYamakD6U3AY+tqom3wrGdD1eOwF30kl/NBTe4jhmNExMFhTnFq6y4f2RX073p+VQPt87vn01+8QqMP4QQzTVGDnFYZj25+OvKCjaeRrBc+S9o2CS7QFZ5H+c9j4kpndDl1XBDGdUw6ygzspc0g9bheEAHWdn6C+aewE6wrhsFu4MoEVrp3XFwLTpzSqtUBrd+DbRPS677g6GD35rPZyEhPIZFJ79NUfBXLerKjCaOxScCDcbkneX2beVRN5aFvIg4zbdP3iJRv+02LRsqBZJvKsEjbuvqbU8wcFUQTjzafxKGM3EH98JJONIsJArcBClvTFTsdZzptJO995lKIJLFBlrX2pOQe7c0gDhWN0UbdVxb0thQzEyIyf+IrWS18XUcvwd8MaVUdjJmBwyqQAtNMgjKpPHSXau7ulJqUytoDL6s+pnmx1XWYD0In4UHaGEG/1pYd/4+nC/sWEbZMo2dyJFQlhW8GDKEv9HPYAwQORcFPQGcKeEr1beNrqwH7E3E/kCQwPbxgS5ZuG6Fkj+gdTv/sPTDZXUkTwgPp2mTBdtEgZxqyHwGwvK6T8SoMie6trMkuE4lt7YH+mxEP5AX7e7Wp6zUYY4m5F/yLe+k+WCbL+q4tzBb5LA4zHgRWrvKUtt+HNCIJDssSY95kIZuDGDQ99qv6h5utuGbsEV4z+092jQO+0dPaGH0db53V3XqAsrBm3Fi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Oct 2025, at 1:23, jane.chu@oracle.com wrote:

> On 10/1/2025 7:04 PM, Zi Yan wrote:
>> On 1 Oct 2025, at 20:38, Zi Yan wrote:
>>
>>> On 1 Oct 2025, at 19:58, jane.chu@oracle.com wrote:
>>>
>>>> Hi, Zi Yan,
>>>>
>>>> On 9/30/2025 9:51 PM, syzbot wrote:
>>>>> Hello,
>>>>>
>>>>> syzbot has tested the proposed patch but the reproducer is still tr=
iggering an issue:
>>>>> lost connection to test machine
>>>>>
>>>>>
>>>>>
>>>>> Tested on:
>>>>>
>>>>> commit:         d8795075 mm/huge_memory: do not change split_huge_p=
age..
>>>>> git tree:       https://github.com/x-y-z/linux-dev.git fix_split_pa=
ge_min_order-for-kernelci
>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D17ce96e=
2580000
>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D714d45b=
6135c308e
>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=3De6367ea2f=
dab6ed46056
>>>>> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f9=
09b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
>>>>> userspace arch: arm64
>>>>>
>>>>> Note: no patches were applied.
>>>>>
>>>>
>>>
>>> Thank you for looking into this.
>>>
>>>> My hunch is that
>>>> https://github.com/x-y-z/linux-dev.git fix_split_page_min_order-for-=
kernelci
>>>> alone is not enough.  Perhaps on ARM64, the page cache pages of /dev=
/nullb0 in
>>> Yes, it only has the first patch, which fails a split if it cannot be=

>>> split to the intended order (order-0 in this case).
>>>
>>>
>>>> the test case are probably with min_order > 0, therefore THP split f=
ails, as the console message show:
>>>> [  200.378989][T18221] Memory failure: 0x124d30: recovery action for=
 unsplit thp: Failed
>>>>
>>>> With lots of poisoned THP pages stuck in the page cache, OOM could t=
rigger too soon.
>>>
>>> That is my understanding too. Thanks for the confirmation.
>>>
>>>>
>>>> I think it's worth to try add the additional changes I suggested ear=
lier -
>>>> https://lore.kernel.org/lkml/7577871f-06be-492d-b6d7-8404d7a045e0@or=
acle.com/
>>>>
>>>> So that in the madvise HWPOISON cases, large huge pages are splitted=
 to smaller huge pages, and most of them remain usable in the page cache.=

>>>
>>> Yep, I am going to incorporate your suggestion as the second patch an=
d make
>>> syzbot check it again.
>>
>>
>> #syz test: https://github.com/x-y-z/linux-dev.git fix_split_page_min_o=
rder_and_opt_memory_failure-for-kernelci
>>
>
> There is a bug here,
>
> 		if (try_to_split_thp_page(p, new_order, false) || new_order) {
> 			res =3D -EHWPOISON;
> 			kill_procs_now(p, pfn, flags, folio);  <---
>
> If try_to_split_thp_page() succeeded on min_order, 'folio' should be re=
taken:  folio =3D page_folio(page) before moving on to kill_procs_now().

Thank you for pointing it out. Let me fix it and let syzbot test it again=
=2E

BTW, do you mind explaining why soft offline case does not want to split?=

Like memory failure case, splitting it would make other after-split folio=
s
available.

Thanks.

Best Regards,
Yan, Zi

