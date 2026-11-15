Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA180606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 23:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=EzaFuBD6
Received: by kanga.kvack.org (Postfix)
	id 0649A6B05B4; Sun, 15 Nov 2026 18:31:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 015986B05B5; Sun, 15 Nov 2026 18:31:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E218E6B05B6; Sun, 15 Nov 2026 18:31:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0D036B05B4
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 18:31:16 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 440551A0828
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:31:16 +0000 (UTC)
X-FDA: 85438951752.21.BBDD9A4
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013035.outbound.protection.outlook.com [40.107.201.35])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6F8A9A0004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:31:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=EzaFuBD6;
	spf=pass (imf15.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.201.35 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1794785473;
	b=zfORhSaN73m0wSulVYbk65bzmA0WEn7Nk5Gtd41t1qOOGkTWzl6bzX0RqopJxJgtqjexGt
	1FEAJ342t25foxAYUl9kwoO23ZNG94Xzs9iMf3iQisjbodlSpB66yB3d6pKQfmPWO5HjWp
	FyRDb8qn1YpQ9909n/MgfHKsb82HM3o=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=EzaFuBD6;
	spf=pass (imf15.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.201.35 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794785473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dZ8p6J/VyvsyA++Gt7XndveoKG9TYoskDEcyzNiaGno=;
	b=d4nUxs3i7zDkwHE3l+VzztFi4OT3DFSnYEa4AZde44JT0znZrU8x/KF3e9T/j3j6wooMTz
	0D5p9z0Hk2DoAWfyy3ul0JS+L2OUHXauTqIwlFwMCLaAuZlovMVALIik+H3VpDHHd5WYQR
	QRY035oRZIq4cyKxnJmGHL0y1nYR1VA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hoEgP3Mkgmx5LaMusAmUgVDsFLoxtdPoSJPwA3a7QwHvY0G2NJ0rj0a42CBq7c+tcaJd8btDnJoLcNJgBGpfD3sIrhVZs9CY+RQAigdbHeI1LAYWXNe52xRQYCuMbmJsMjVJZBaJQ+r6SxqN+qz++rX9SUmzR2MIIkOYdg/sBkOHfDRdWIHo1B7hBubjt2NeIb6+Xn8t+2UV0iWCfxIHYDHNgr6gh9A3MlpCPX0bellFxvjWN/735bzIj6osZ0BECwBzsUavWEoIPrb9bwLUq/rqk5BUGorT5f0OSkLlU6Lk6jip72WWe2WCbHuXNysXOfTFLi8C8cUv2BFARh1dFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CH/dnuZubYR4kBqdbpcvv4OTYXjKGVKv+0/jXTO5r1o=;
 b=G7YFHOypL9AFSctM+3CHOL/cLxXjurn+KDnCg+pead8vzgUpr6IkaL2NjIpLHGi8lJsZM3xTnn3l6LQVjGjybrK8+TFKpgWJXkRoam6g9LphC7LFVmcWXUg0PQJPBCs1NhvoGVcE5E5p9AgQPnwJSsjUT8a7nKOTau8KUdsYVgFXtV+wvfJJidr53SkuMdOV1CcLSinFpcUFZP/ll2tlUqG2fT3jHE/ZIqPmKMlCLHJutaL1x5gHwGfrcMVCgENt+APPqSonqVv/rUO5djJjyaT9ZeMlz8pjagBnUv4vjvYhRbiFJL/EOihA31LKWJT86goA55d36shAUrtuCVAz1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CH/dnuZubYR4kBqdbpcvv4OTYXjKGVKv+0/jXTO5r1o=;
 b=EzaFuBD6af/wiennerwRbrEWeyfEaT9ImJSTPB7n6rk+RpLCa0kKmDQDQvThrogVlUpuyLCGCuksAyBEQXrLkzH17eOB33fm2TuY8Y//Bt7PGOFc+8fg0S3wgx0CYIiLHecY3/d5EyIFZdM9GADnN5kJi+r5RD/k9fkjemwE10LCf1ukjGDaDMVqIi5aP86ZXupiQpqs/No4yDpUIQtnZtOjm2dqj22LjOrXFaRa49OGm8vDCI0myixhOm68mPhFySeljyuhUotS3LkeuDkroiw2pWNmbXcDFWpX2oFlWRZwMjafdWsKG9rtp1hSDotKe5nq5JqhZcHLx9EenYJMDg==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by DS2PR12MB9637.namprd12.prod.outlook.com (2603:10b6:8:27b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Sun, 15 Nov
 2026 23:31:05 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0615.013; Sun, 15 Nov 2026
 23:31:05 +0000
Date: Mon, 16 Nov 2026 10:31:00 +1100
From: Balbir Singh <balbirs@nvidia.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Mika =?utf-8?B?UGVudHRpbMOk?= <mpenttil@redhat.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Mark Brown <broonie@kernel.org>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 05/13] mm/migrate_device: don't collect a range twice
Message-ID: <avo_dxXxRxmvN6gE@parvat>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
 <20261113-mason-migrate-et-al-fixes-v2-5-50a2ed382b61@kernel.org>
 <avfrWjzLQdDcmXO6@parvat>
 <8c79ce88-7730-44c4-92a0-d760d6f8e9e1@redhat.com>
 <avinH6zgTzpjMCrf@gremlin>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <avinH6zgTzpjMCrf@gremlin>
X-ClientProxiedBy: ME0P282CA0061.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:20c::19) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|DS2PR12MB9637:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f4c0ecc-4bff-479e-141f-08df4370849f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|10067099003|11063799006|5023799004|4143699003|56012099006|261022105027099003|261021121427099003|261026121527099003|261026140227099003|261028144727099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	S6A0RAB0/Aqsvn+0OtTeIW31qxyhM0yt39Khlq8PabTnvTFQdBaFXmPN2CR+D27osVoBe7aptx5WuS2k7hKCQDAfH0BJdK42Lgpvipe1WZNEZYR52X/vH2ALYgGrlwPp7Kk8SE2f4+0JeZuesYdHE22vWX/JiY4WLlgkLUwCsTVXURPJUklnHv0iScCJwfdKxadRlICK/Ni5OOks1lg7LzCv0fTZdqmqTVvflhCYHLpCKSf/PCj8gIi4WEPNmsZ6oha96xBKR4FXZQH/lfJOgNioY1ECgfwXRWqE5f2HGvtqDuzyz+CUGpd1PwkkDRIMDA8yM4nDzz68Hn6rltZKUNQzt6Avf+W373N0pgWPSiunTAoSxlc8k9DMshUEKA8evyxeI0mnvALcwpqYzrIhF4tQpXPRM0plDq5BnVxCM1E5uksDIuceaQbP7ahM//eTBj+RzQEbnp1t7S+wG6Z8gfflTJGNiCatrlF6WUiS2uXYSvogN9+wwNklJ4K7f/wF8ufsbKtWIOCCmL87OLhxfeSLJPoElXMtBsaavu6O5WWpsduubq7e0r8p8sSJ4oRtKFvjGrF3GO9pevyvYPHly0qz1IHAc+ZIoqnGjRrkiGa0EbSEriNFq327zOLiCbaMRloFGdG84ajIJKGugGpuzw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(10067099003)(11063799006)(5023799004)(4143699003)(56012099006)(261022105027099003)(261021121427099003)(261026121527099003)(261026140227099003)(261028144727099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?VkO6c3pAcxjs4htDacqdC9mkb49WyNifw6PgWsksmLtwXtvlBYaB3WAgiZ?=
 =?iso-8859-1?Q?vm+KzlmhwTRyY9hjup8RjX4DI5ISIXBQWo9GtAwnTQ3yVmOJg5N8tpsZMm?=
 =?iso-8859-1?Q?nOX9PcuqtU5ldkbs6pqg2Iw32FCpRTe+M137m8saVmtI1BcgrIGrTF0Hp3?=
 =?iso-8859-1?Q?m3PHV5vXrE/h6i7ibj4D65H3TZnybA3aF5ZG5AtDXSi+aaUA0wIQolRInT?=
 =?iso-8859-1?Q?MvPQYsKLNgJXDwC7jm5Zz06N9nwEaMazjuLkcUyUt2iv71IdVrX0pHVHBF?=
 =?iso-8859-1?Q?ZCE4MW/oKet43uqp6sRpfOnwXrvPfb7DJieKfm5JwLJyAxiVKKtuMbL1sP?=
 =?iso-8859-1?Q?p415/RKMCefZV7h+8Yo3lV7nQ7CI9ZuGVU6EPcgOyY+ZGGjVmOqmTEKBf8?=
 =?iso-8859-1?Q?pz9OQYpNzgmwPyrRo0bDkwnS+GHXXn1+/nwf9YlpCQPR0Dsasgcu4Oz+Ik?=
 =?iso-8859-1?Q?sQGI4LCirUCFl6jYLyANzKDi3xfi0Tw85DpTBzYkGKM/OVAxfdpXwpROFf?=
 =?iso-8859-1?Q?jMEYE0eIEyJgvkfHdcbbmE9MCjFHYmswX3/BJGx3QDAijVN400aZPdsWld?=
 =?iso-8859-1?Q?/50jSNRPkE2jBqiRW1KJtdZlU8hAluLqr232EdvjjrjI8gWRwPSbaFh5Q/?=
 =?iso-8859-1?Q?bZNjIcRLjVziwjTOBQOfYViBcYdneMaTud6lIbDywIFcJwt4YohaLD5KJN?=
 =?iso-8859-1?Q?JHtZUjEcdtBo637NY1xlZzqUeVyHifVBj0kcspGdBd9J0f4E8msoheIWJf?=
 =?iso-8859-1?Q?Tknt/2b82kZnrN4SMD4/qb3JM7Q3Dh2p804C5uW77C7uei0mEcXxGD+24N?=
 =?iso-8859-1?Q?tZYAcWbo3sEdUqd3RS5l9AxqcyeTsghdGc22H7fg06muNskgUWcOW2HtNa?=
 =?iso-8859-1?Q?w0J5kujv+0UY3aTkH/mMuB2r/aU6Ce5SOISTOL18BdIshC35W0PlD21As+?=
 =?iso-8859-1?Q?9LJrLiSBjUmJmop/SnqnNKx+tXE6B8nIPXhfsjDVQnNfrQIi7GYZHbf4f3?=
 =?iso-8859-1?Q?7cPgJ3QXUZELykWTgb9hyTWJVnJ2S1I1acDyeXRN1JuMBfsKfgZ9e/Nw9H?=
 =?iso-8859-1?Q?Ai/JmWkhuFTOMKUa+s6NwE8r4zTcU8FewsGgwrqDKRk977MaflGOUjG8++?=
 =?iso-8859-1?Q?jx7wFE+AQtbIQ+Aij8HyWjfZ2w0h5iNjbqOpoipO3yB4QSHQEgg0Ra7MJu?=
 =?iso-8859-1?Q?xCBgekFtENFGa65K7TLvO/eDSSwiwXfZCwlsIf1ldwRAMgpcW555AH5Jba?=
 =?iso-8859-1?Q?rApzHwJfpYiVNmnPuF5oKGAVERjk2e/Ri6JMtrK85I/VI3g6lN51ZV0Eca?=
 =?iso-8859-1?Q?WEW9NyaWczgVFTF1PWUL18KZsU/INXF0xJgH0x10a7d9ikJg55uS1WpzIs?=
 =?iso-8859-1?Q?hietMxEdAcyX4nTK97RJiZudtAYH88pjHI23oCKzS88ZfdymiD4M9NfB91?=
 =?iso-8859-1?Q?zj7X9xf5nOJ5kl0tiV8zQ6llSRsCWDUxX3VLb4ofye5gjGOigJ9LP7ahNB?=
 =?iso-8859-1?Q?sm0ziU85V7VpCj5Lma7Xmy/WEQlgxIqRWMIIdUCs5gYas6+7VjoPXH/jE0?=
 =?iso-8859-1?Q?FiyPbvJDNHn9ZiIFd2DFwVgyyC7g7srw8kua9jpUh6udfH5p+8t9+Aasio?=
 =?iso-8859-1?Q?+UVxQwhmPwYI79dT9jvZeSln3ALQDMiLUtBCPN939yUJeJetUX/YKWoNZR?=
 =?iso-8859-1?Q?iNmpwBs/sp3d+3w2mWg3BLmsWBSACadNbhVGjscJJtvcR8egAbcJNWXLE7?=
 =?iso-8859-1?Q?JG83lHFsfdsvMHTt9PGRsDIR0j3/d4bda/SM50GSmlBdaM5zoToyixnNxG?=
 =?iso-8859-1?Q?AoiROgWIVg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f4c0ecc-4bff-479e-141f-08df4370849f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 23:31:05.3656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qOP2josbuuyqCv4iRsC9gZkN1/Eksy3AXyhD0aOMf7A3+hDCEDSjch3A/QvxLmS9vkbZWRVa/qXqj3NytNhYXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9637
X-Stat-Signature: 88ntydx669kooanpugkjirq5kei73zot
X-Rspamd-Queue-Id: 6F8A9A0004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794785473-432497
X-HE-Meta: U2FsdGVkX1/b+hvXb+pFimuU36haDMc2FwhngTLFnKgk+ROkbpMOLIahUjJeak393t7sDc42W1yanKUsW4xE0D5tqPPhjo+NB98OcGk5InJnV1TVoxkEzzyQwCvDBtW8q2pRwnJcHRVFf368sHDnEnB1X7jWkLi1NlhCd3bAp/+HvAWWAjNsDWpSALlRVy8TbvZ1LxdNtSrjvc4N4XfB4Ew4lqt1fFtifLWiOlIw8r50mnMuUurNpZ3exMe3Aj/JtsKB1FJchfND0lbB5fFSJqmlTR7Kbdy4hg2wg6u77z/vEknqGTWny0FuMFJC8HQ45JMrYa3c6r56HOQ+b/IJhU+u49e3iJ4Ci6tS42F/S5+xJTVveAnB5nSdWRdk0+TYeF+bUMFo9aXzvwybqpDAS40qF23jr/c/4hqKx1xvsTjgrG0mXp/Azv0gEbXQ6GsQ4+q0oB6F01x43PsdCBMwLjrIZc2WywF7IsDOrYKbF+Wd50ypR+2OErd5Li/GtKz7IUfa9Ln4MzbqhZ/krzCzO9NouXa6QuGKAL8Ub6rtlY9lpoMiJC5mVaWAwhZLWA1amdowSJjoEs5WLsVjqJcjCgW0qX8pRWOJEvrTq2XLqKZmiOR8UL/wjFj87hBAezePj6QGyFTKKmFL4QmMj+WHHsR3wWKT9B3lTCIDrzqLl9A1yVbnKFENmtOGwLLsceq00m+qkvVrgfXk5fxjB/Dfy4Ez1U7kKg7ueRaXR4KVWiR44hNNSNqfRQrwyVrFdWBwE+zavklokvqx7hrtXseotkAsQQ3BNsMHsanpaS+SrHC/9VSY3PkJ273yJvs0zadcy/dsYF9GUZK1NRkBnL0o6nUNvzGkA7IqvO0utEPMnVcj3vREn73mAAGCwbUziQVmbJCNWTFhvzkT2wa6WBtF9xMRr290581F2hkSvVQKw3M2QKDiW6VzxxZTPsUM2c7pAQWxnSLhsncjSRvw9z4
 uyXHA3bC
 U89yaiEPQVAFb3Ydmseu5pSjmaX6gx6cqvI+z0FvGTO0RTCg/MbzVxyUBqj4Ocwis36qxrF08EcApoOvFiihpLjatmR8USM60fx90nRQqIutdDAjPWoESkxNIeGqII0dB1UtmkRItxkMxYjvcjW60NOHGNDMv3KaUaotPT3zlYh+MGRXfD79cR79dQTCpQ9A/af0GrI0o/ApzgUk1mAbH8JokhNkOui1/YfQjEqKg+5Ih/Qn7pFsHEz9Ho8xJqmTCpE2HCiI4scA3dztByIMuM9wzCRsxYli/8RvJ4yzrOeLaExCgbrYVBn9u2Xt/WjpAKVWaoZtlxgTfC0Az3Wh0N5hOqPgptGwjgRkJvD+oUvLHJy5evd0FhU382rTVQXh9F6yPFoe0O82wBZpxqTYXZJGzdG4vLUCrrPhyLw8mrU1mSKlnEk7H4CsrpwwcBWq6CpM02uMb7//ZYYFh3s1cfpHXG6dGQIdikYHeNyZUNI/9C0Mvn6uWEeb1IgbUK1X92NCCcLGNfQGiB3s8JvemgzcC4+tRAqrpZJ3bAIbG+KvGz/p9jutTADRT2XCGMaBC+c3cdM9Ge5FXgOKkjKUgpPU57pW9aVdSEIoI20jQebW62b+ulntWW2/MOS2e8JwcWL9d51wNtodv6GGbHOaTdWKt52QhFgHssOEa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 06:34:19PM +0000, Lorenzo Stoakes (ARM) wrote:
> On Sat, Nov 14, 2026 at 08:45:55AM +0200, Mika Penttilä wrote:
> > On 11/14/26 07:09, Balbir Singh wrote:
> > >> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> > >> index 9e5dab8e1b77..28ed706109da 100644
> > >> --- a/mm/migrate_device.c
> > >> +++ b/mm/migrate_device.c
> > >> @@ -257,13 +257,17 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
> > >>  	pte_t *ptep;
> > >>
> > >>  again:
> > >> +	/* [start, addr) is collected if we get here after splitting a folio */
> > >>  	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
> > >> -		int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
> > >> +		int ret = migrate_vma_collect_huge_pmd(pmdp, addr, end, walk, fault_folio);
> > >>
> > >>  		if (ret == -EAGAIN)
> > >>  			goto again;
> > >> -		if (ret == 0)
> > >> +		if (ret == 0) {
> > >> +			if (unmapped)
> > >> +				flush_tlb_range(walk->vma, start, end);
> > >>  			return 0;
> > >> +		}
> > >>  	}
> > >>
> > >>  	ptep = pte_offset_map_lock(mm, pmdp, start, &ptl);
> > >>
> > > Is the intended race a concurrent MADV_DONTNEED reclaiming the PTE table while
> > > PTL is dropped for the split? That would leave pmd_none() true on retry, entering
> > > migrate_vma_collect_huge_pmd() through !pmd_present() and taking its hole path.
> 
> Balbir - yeah exactly the PTE page table removal, and it zaps the migration
> entries installed for [start, adr) too, so those don't keep the table alive.
> 
> And yeah, we would then see pmd_none() on retry and
> migrate_vma_collect_hole(start, end, ...) would appends entries on top of those
> already collected.
> 
> >
> > I think this is "ok" for the fix, the hole is collected from [addr, end).
> 
> Thanks. Yeah addr > start, so it's not PMD-aligned so always ends up in the
> per-page path.
> 
> And if the split happened at the first entry then nothing is collected yet
> anwyay.
> 
> >
> > But couple of things follow. It can't be possibly collected as
> > MIGRATE_PFN_COMPOUND entry, only small pages. And the collected entries
> > in [start, addr) are wrong ones.  Finalize will recover, but the
> > migration will fail for those.
> 
> But that's true for any zap that races after collection started, so there's
> nothing for this fix to do here.
> 
> > These all are handled in the HMM walk based migration series.
> 
> Ack great glad to hear :)
>

Thanks!

Acked-by: Balbir Singh <balbirs@nvidia.com>

