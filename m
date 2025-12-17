Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06D02D637DF
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 00:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EACDB6B0005; Tue, 16 Dec 2025 19:34:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B976B0089; Tue, 16 Dec 2025 19:34:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D12E16B008A; Tue, 16 Dec 2025 19:34:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BBF896B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 19:34:32 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 42925140860
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 00:34:32 +0000 (UTC)
X-FDA: 84227091984.03.75467C1
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012059.outbound.protection.outlook.com [40.107.209.59])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4E9A680002
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 00:34:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YNlOBkR7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765931669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y36AGVsQdhonPsxH1KjHHqG+OaYogameWVEHHPIS5Rg=;
	b=J8m7dJRBOLqeuvF5bboMOpAYrBjORHpK720oteucMxnsmeIU5PSon6Y51oQPFk4hlvpJtm
	XwUiOFfv2X6/Nb1W63safODxRcOQsAxAqzg90Ew1+wiTv4CLGzmgZpf+SgWawJRU5/fWzV
	uo9p8c+79WHxYlzmqp5XCrZGL5qhmco=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765931669; a=rsa-sha256;
	cv=pass;
	b=ILJrCVPgn2Rjg/1k+ADG5xTi9wzSGAfrjLRBvcPwizDoVbGAYrL4h4uKwI1wppBRv6TThS
	vuo9iM7u7OHSp3heY6BbJvdBW693FHipvBpTm8FjVJqpeJImQ4eRij+tcdbX9gHR/hdxLs
	k19huzwxIyZcOcWWcHKf+QBr+QAZeMo=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YNlOBkR7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vf8638wHpdTQxQowI6q5dTNjRwivP4q/dn8bHgLUoVKIufNo+dMW9Q9RokaOnmbvwiMC40NvXFMq0SwMTek3dMYrAMYfp/TICNf5QbM84L0qtgIkwH2Mx0TVJiOjAC/XsKndH8bt9c/dVrDNY5tZhiwVOtX+0FnW8fAi8pae9plbNBV0bdUarf1FlbB4lOC9eUXzoPpaoPHNJrhh3RAws6ZerOrlP6Luj30XgFATg76c2USjwfApWVzRDXbQxITHiK3VfM0pa5C7BU7WeJta3AAzLpsmsj/6bryPsmLdN3dTiDg+u1uJgwI0hr5ZdNhoTN/WRN8h3FdtGgUkZWH9kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y36AGVsQdhonPsxH1KjHHqG+OaYogameWVEHHPIS5Rg=;
 b=FOCToo/hDL2S9QmFoPU5Wl6YHREiAa5WiMhFQlFIUmbONByAVGdgdqGx0+t+6bL0VzXw3lN4GxS7t2nMm2BHooUgMy7iTe41ygjyesQVwmO0onQdwBerkdgN4qLCuf9sPg/Wo296yMu6PgPJGOKQBZdJ0fpsfL6fjlzL0X3SsTcbBrnAi58uJjUvEAxmN5dNALqX/brFekvDU22jCkXktUMlWodHRuMvM3F1LNYuftrHZKYeETF74DMfY8cYTXdaekrXnLzOh6fA3oBhACh8TSzn93EwlbDPsIsWo4m8vyTThY+Z3LpDdOIP53xWyw8p7edUBv4PNI3BZnapVfi7Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y36AGVsQdhonPsxH1KjHHqG+OaYogameWVEHHPIS5Rg=;
 b=YNlOBkR7YcwHJ0TuB6myFKWqyoxFcoB6/a+5wF8bH3YvssrFegvanDDlwxqw2FekwkWyKh3Hgm8QtsIOoFTgrX3xvJGT3b1bILOJbtDUUXZVU/nFipJ0dlrwrCiZUXbZhyOzN3GJlWRtk4Qe0E+rXg3K7zhf7AyjyGKZ7Eqq+rpo05yK743x9m+nHLQGb0S5rCuC//FQxptJbP1UhnBtGlX/WvJ4uah6lA3q/nb5u9RioMtSPySKh5cXyV9BsQs42Wn/fQUZKWNVeRPqpxZuW2t2AE7kYQaf21Y6mJiFN7iO3dlz3MkCO2PMs7TojfnIgJw5oBC4xnX4Aw9+EEBJkA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW3PR12MB4378.namprd12.prod.outlook.com (2603:10b6:303:52::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6; Wed, 17 Dec 2025 00:34:25 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9412.011; Wed, 17 Dec 2025
 00:34:20 +0000
From: Zi Yan <ziy@nvidia.com>
To: Bijan Tabatabai <bijan311@gmail.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shivankg@amd.com,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH] mm: Consider non-anon swap cache folios in
 folio_expected_ref_count()
Date: Tue, 16 Dec 2025 19:34:17 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <0C218C18-916B-4BB0-8B37-AC82503E4AD9@nvidia.com>
In-Reply-To: <6b4cadb2-6246-48cc-9c76-64ba0a23198b@kernel.org>
References: <20251216200727.2360228-1-bijan311@gmail.com>
 <6b4cadb2-6246-48cc-9c76-64ba0a23198b@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1P221CA0025.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW3PR12MB4378:EE_
X-MS-Office365-Filtering-Correlation-Id: c3233cc7-436a-4fbc-dfea-08de3d040497
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5/8oZHP0QIA/GjdFBMy0c5AI9PvFmnRdgixY+O/WO2l0BjnQ5/h2qAM6AJUH?=
 =?us-ascii?Q?XODVpm4G65g4NGdzuYnSGhDY8YG+zqq1tD55f4n/0ezaWD/JuZG849xCzQgG?=
 =?us-ascii?Q?PfkJpa9CKCeO661qAITupTyOHiVKbECtVVdVnz1LRSkMNT0Vf5DfNdVrGr7H?=
 =?us-ascii?Q?mIn9V+XKzxzRFCy2Jpowx2v5B8s6TYkkW/0z/Ea17n1KFqwtgVI3D/rSGPer?=
 =?us-ascii?Q?QY3aGxQe0IwlDzz3VE/aqNRiWY1kq7dAdTWt6lh6MCvm3p0dncmiUfSQ3Nef?=
 =?us-ascii?Q?PO+mkLncHWvE9qPZvTjhOHwZdBVriOBJ0anOEYiDhLfAP0j8hHOsNIiiHiqx?=
 =?us-ascii?Q?i+NQJwUcGYmGBRKiB8iugq4FsSf+V1AUD1lD6KscbFi+WUhjEcnEFlO565/A?=
 =?us-ascii?Q?0zxxF2i5BQGMWE43diziZHURqc5EOVYh96+G5d0zVO+jMPT2LRMbidNbDj+B?=
 =?us-ascii?Q?kk3I/LAKf/8p34rQzOgJYOmA0XeiL1ynaTFpf86onX4Wbma6fydV9C8lF+CZ?=
 =?us-ascii?Q?MA5zMl4WdJ78H8/Cdlv8+vEIHBkfLMhUkqId1ezIjn6B032YlfRveZ/mDR7D?=
 =?us-ascii?Q?gKp2r5HXnF78SYTy7okYYmkZImHy+Y7OMVAlvtuvCfLgFWENMD7eGDa71fow?=
 =?us-ascii?Q?hLaW7BxDDUeMpi6V9tvzilaGElQKv9Snb4WMXhVyie+FeMqqVrkleROAZBRH?=
 =?us-ascii?Q?cY1WL7ybtqn3x10KFh37/oLvCK1ntRr3kdN4WkpE8N3DmCxTw+ZCQrJUcyIk?=
 =?us-ascii?Q?BA5JweiaMuuGMxLTaan+49VqA1k+cWYGDxQwtvtW6S81XvPXXYUBLH+4bDtn?=
 =?us-ascii?Q?IKRwMxQipRy2yOTx9ehiAfZISpcoe9vExtHQq9MkSvTpzsPsfQ7RPZllo589?=
 =?us-ascii?Q?BKG2K3Fbp+4YocAWv9zOwIHtP88ID0ec+eG2ITQqzP7ulRqg83jpktNJVHn6?=
 =?us-ascii?Q?nGiN8IWc2X0Y2vbWNCEymXzXRRqZAz/bIFN/s8SI1noOVKDGy3y0s4dOM30E?=
 =?us-ascii?Q?ppUiWD3KETYOAr3/cfTeClPkTwht0Co8pDzOa0V8ssa0CPY7TqVpAydaHO1t?=
 =?us-ascii?Q?whfSre843uEup/P/N/Ro+jOUhOtLv2SwwzZ4T5HqXKAtIBtmNXQr1Z7JrDmg?=
 =?us-ascii?Q?GQu32bbDwIhMeS4OYDIIGEzPTRi/AB8n22oYA9StnGW14hXrB3gPVysXqiI+?=
 =?us-ascii?Q?T+LRbgkXHLx8snQWA6Bdze2nKHW8KLADou+2Wy4EXRtpn1M0rVhXTGFrz+3m?=
 =?us-ascii?Q?5BbeLwIRGQua1Zrz20MK93k5rVso2/jDqTC6TcXkS2MMakFxF8wlCrYjLQhv?=
 =?us-ascii?Q?gYtQB5zaCMJvUtHhJXDGCPOoHBT6M+RKf9gATwevoxo3L4EuaI4Cjf99PrJW?=
 =?us-ascii?Q?JCiOQpZ5MJ9RYAODdGIBWz66LpSCyiFudngnow9NyRK2eTAkehu6jAHo1hgJ?=
 =?us-ascii?Q?uXYnBxXXWh+WvxRtv0NjHFVDplS2Na+uHfvG2Ky/PBc3LvdV3CWr0A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h1a++MVLjU+wU63/EMNwOIIWp9tK+URNlyD8/KXxGmO2fHy8sFWpr8fFH4pP?=
 =?us-ascii?Q?PfnCTqbWaS07EF+eGjYJBRU4HCoE6QBn0iDhdFJRNVmuQB/n2pVBqJDwm9fD?=
 =?us-ascii?Q?RvJMJG58CWjtwu9AYOeFcJkNxY6Q6Au6zlG20mZlBFlRDPXiB49/ic+aFb6E?=
 =?us-ascii?Q?YYxRvxf6XosVcS8jM+C3m1lSAMdcLbLPNW1h7oma9Y9rMM4vJpkDzrAAkkBk?=
 =?us-ascii?Q?heVkfLaFIM7uQMvMSAtnSQm7wApGVoFTXKP4mUbmG590hKxSkQ3psZgj+lnH?=
 =?us-ascii?Q?qtA1U8dwmqdHQpEYcwSijyrS8/jn7ZBdUhJ49JSb3yVrqQE04M2s6SYNEYP6?=
 =?us-ascii?Q?QedODLN806+N7exTnbMWCEMxPf3hRxJvVMOrXnXJ9VLQonGy8WME43qwwMPG?=
 =?us-ascii?Q?EaHYcKGBhDXS+KLE0K5QwJ9/bWUN0QNhUZ9k5wD5L2ywQTChNEr3sFzUyATM?=
 =?us-ascii?Q?aALyOzP8+M6hEDcG4k6M3TMsR7IxY10+rd7tvfkLl4UigPjZFx3wr5EBL/Xr?=
 =?us-ascii?Q?qjh5Ua0WfN2MY2PwaJJBvs1zSeCcCiLg8DZNMnjrOkVcWr5J88xSRY8RE+/K?=
 =?us-ascii?Q?DjTT5czOeccJZ6oxQ6hjYctaWlkkmXtj0K7lFG2XBzQHRcw/n1yKLQ1Hw+cm?=
 =?us-ascii?Q?qdMrllRsDdhZAsNFP6Wo/NxN8OPyX8LBkp1kS84ivQPsDsp+SvodWDlL3Lno?=
 =?us-ascii?Q?D86H7hKtbsQ2s+gqeTDUPRaaablQQXZlRaFmGEMWckhmajiICRcT7QOCziZu?=
 =?us-ascii?Q?epX48MjPILapFBFE/befMdAcE+2YqKFR2EMuZ6aUdCDSxa8wdYChDvH2P/pE?=
 =?us-ascii?Q?z0aI3bW63xwR1QoAPdruYlI5neMPHecFFcNv1vapp/9a21cbmnaMyqYE3BnJ?=
 =?us-ascii?Q?YxeHIr1Wmg4ENSMSHklvXtLkaC+VXbkE56kdoJJKW6bDLgpDFAYkhCqlMIS+?=
 =?us-ascii?Q?+yTEPLiUZQcGhpng57KjFE/Cbe7lH/TtmbX5T5n2dBq7KNzzoAW+rfK9Zq4p?=
 =?us-ascii?Q?ZlXr0t9sP20idXh/ofoyaq4DHHJl6yCK+tXaJ2P8Wdmrl7pbGmKc81LEOagZ?=
 =?us-ascii?Q?Lp78gFt+IA+W4lBRtFCHqXBuSDOzHK8EVqPFicKl3VhdTUmA5OS3XexCyVS9?=
 =?us-ascii?Q?+1gsS+2w9bgCKJ45gi1na30MxZoq/JZj6SpbHSdMhzDohXy4VfX94DUj41Fa?=
 =?us-ascii?Q?FHRHYcy3Mj5tv/i4178zNvFH23SyvRfF4WutLnpxdj6ENnkqE6tn26MVsAIQ?=
 =?us-ascii?Q?f8fDdkxGer8mvhTWKmCgfIrlJIck/6SKjB9L0paNcx+TGknlFvBwdQnUhtkS?=
 =?us-ascii?Q?VdFIoHa62GGA6/iYtesR0LkXmT4T6WgtYgRAuZEUdqMSyl6a1oi0XYbEue8t?=
 =?us-ascii?Q?e5gbGo4Juaio7JhMEDuRgpO3Rpl/wbEWwBjfg/g8BZwmXrjOIPtA3owQXAkz?=
 =?us-ascii?Q?fs7/DhdpfNhOoMkHyOJEcmTCRDlJ6NckqCGzXsH9I+oHGEqHhxypIi7tVufP?=
 =?us-ascii?Q?2kfAZ3oxcQu3sGvZeSSRTLiUfLJxz/tNPB4z3Zzbqql4/v8B4WqfAq1qLwF1?=
 =?us-ascii?Q?aVka12EMagGvJssuGdLHORnGy32cs0rknSD5atTB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3233cc7-436a-4fbc-dfea-08de3d040497
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 00:34:20.2086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eaZu5AiJy3Gm8hVxDdwotdXA0TIUzW6gTqk0TLH6hRuy18ByAiEuKtoLXPfBPa2A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4378
X-Stat-Signature: wdkxjfuzf985sgjczpdg8ztg4tzekaau
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4E9A680002
X-Rspam-User: 
X-HE-Tag: 1765931669-389365
X-HE-Meta: U2FsdGVkX18gx3oiHSjiPIvfR8zOHaaZB7uqOAViRRL3vy4/qgTRzeWbWQ6XFZvE3Qo9eQLnWe0Pgh0LSV4C6dqVFQFiQrSg9JvxwTj25F6IpkUDp6WV/IcsIy78BUVuYO1Wb6TY4n1JDxcbpRUadCGDa+MGHg518fIB1sGZ6Gwg5TdFTx5AdAXVm3ifSNdDhs9/wnZsyeYqj5BuXjTNc/DQYon4MQBbKkRUkFUB9I+/SANocDTkzc+WfiWHHFRMUE5PkuWRJ5eNFE160NKwch/qIU2N8WfG4XKCiII3zoGCgQl81y+zAMcvV2SpPP4X8FhatT54rLxUwsGg8zaVsYv1J0TEv94aXmbaeil1el+4yzpYMeANjBhfulnnZiP2jgciQS7gZ0h6eC8mrgG6s7SNOjUMEXAiulk8xu7a2HyxMiV5nBbuHZSLPXmQpU/oIyzKFEdCNP2r2PBTL8zkuXwYFYrEewu83UdSfk0E00A8XuaFXi8V6AEdzyLugoOcphsY41vJFl83IaMBgcV88vNEdRUTy9vzHbHI0zx/B9CTiFITPCRsb5SjlltHKlVOFAnyGjWHNdUfsU8yBj8pGUtbU4FoMmdgJETbexIUqH3ceQmy87IMMeTWFNvkLv8fdNjRqt2RbLDrgNeQtClBAumcoVFgFrxrbmvlR9R9oRVygjuPIyCzKvpAvjYBlYOMFTY0+M2Et0vzpA7wMRhNZFeMFO7Bc9E8M5l6HhxtDu8FGWzOI3u319E+5Y4omw/XorPx2GoRq2vCyqvVEFckyzBn9LobCkIxIIzQWpbSfOzSvI2TVmo9uN2KMdk2CfU+xYOKyn8vFCCarTE6AZhgblmiqXGzfzw1eksK/1Jlkk5VQk/YWDWgPxZ6yFsH6vP0sT6Yst0zOL1C3+h4uje3a+lhqUr+ovg2W2uHHmMWg861fWzmUP7SQrUmqfpHGK0BGrOoNFFUHzPYUu9qyeU
 +J/itbux
 mCdmppe7awVaQA5KQtn4icjR2Punb4PAQGYcao1aL3MvhlRLjFLkq5JzEEXqHejzzsGDUEXQntWJ9/74O6V/2jK9Te0P8GfhgwO24VHdoL/n6Nfj0yPHBEIwYjOszrvkP1HmFjsam2WVxI+GSEJcYtLv0KRhOsmmUeuAWnxQtF/nO2Izvsea2l2vP2QPKx2X222IeKTipyPqZBY1uKcGf6b6VmMLv+3QyfkFEsFz/Q38JQaLhYQwNNiRQaLrmlC/0Xaevz5z7bUTyd4iqBoQS34GpOEL1jKdRuSIOsdvLnViLL/E6UOMt98vyn/f/i3W52zS/TcrX5StEwjfYfK19eSI499AVEZmb+3t94potvn3OvzFu/QBbUsEZ2A3YVjzwe3E5/h0Emhtb+uw0e6dMQPVGKWgUnETD5MqjrnD/+jAeht71rBXd6z6ib4WguxOFa95dADQdQLOy3WD8Q92YeUZah9YpQhmSLxowiyHKlw/xoBl7zqv3T0G0UMKHFKnKf7KPxh27ZvRFq7LGM5zfAvV6poTaC9kRQSkIp/LwcthhfZOBT/A3Ax/xt2RNHdpCmvdu+Jx7+bSLh68=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Dec 2025, at 19:07, David Hildenbrand (Red Hat) wrote:

> On 12/16/25 21:07, Bijan Tabatabai wrote:
>> Currently, folio_expected_ref_count() only adds references for the swa=
p
>> cache if the folio is anonymous. However, according to the comment abo=
ve
>> the definition of PG_swapcache in enum pageflags, shmem folios can als=
o
>> have PG_swapcache set. This patch makes sure references for the swap
>> cache are added if folio_test_swapcache(folio) is true.
>>
>> This issue was found when trying to hot-unplug memory in a QEMU/KVM
>> virtual machine. When initiating hot-unplug when most of the guest
>> memory is allocated, hot-unplug hangs partway through removal due to
>> migration failures. The following message would be printed several
>> times, and would be printed again about every five seconds:
>>
>> [   49.641309] migrating pfn b12f25 failed ret:7
>> [   49.641310] page: refcount:2 mapcount:0 mapping:0000000033bd8fe2 in=
dex:0x7f404d925 pfn:0xb12f25
>> [   49.641311] aops:swap_aops
>> [   49.641313] flags: 0x300000000030508(uptodate|active|owner_priv_1|r=
eclaim|swapbacked|node=3D0|zone=3D3)
>> [   49.641314] raw: 0300000000030508 ffffed312c4bc908 ffffed312c4bc9c8=
 0000000000000000
>> [   49.641315] raw: 00000007f404d925 00000000000c823b 00000002ffffffff=
 0000000000000000
>> [   49.641315] page dumped because: migration failure
>>
>> When debugging this, I found that these migration failures were due to=

>> __migrate_folio() returning -EAGAIN for a small set of folios because
>> the expected reference count it calculates via folio_expected_ref_coun=
t()
>> is one less than the actual reference count of the folios. Furthermore=
,
>> all of the affected folios were not anonymous, but had the PG_swapcach=
e
>> flag set, inspiring this patch. After applying this patch, the memory
>> hot-unplug behaves as expected.
>>
>> I tested this on a machine running Ubuntu 24.04 with kernel version
>> 6.8.0-90-generic and 64GB of memory. The guest VM is managed by libvir=
t
>> and runs Ubuntu 24.04 with kernel version 6.18 (though the head of the=

>> mm-unstable branch as a Dec 16, 2025 was also tested and behaves the
>> same) and 48GB of memory. The libvirt XML definition for the VM can be=

>> found at [1]. CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_MOVABLE is set in
>> the guest kernel so the hot-pluggable memory is automatically onlined.=

>>
>> Below are the steps to reproduce this behavior:
>>
>> 1) Define and start and virtual machine
>>    host$ virsh -c qemu:///system define ./test_vm.xml # test_vm.xml fr=
om [1]
>>    host$ virsh -c qemu:///system start test_vm
>>
>> 2) Setup swap in the guest
>>    guest$ sudo fallocate -l 32G /swapfile
>>    guest$ sudo chmod 0600 /swapfile
>>    guest$ sudo mkswap /swapfile
>>    guest$ sudo swapon /swapfile
>>
>> 3) Use alloc_data [2] to allocate most of the remaining guest memory
>>    guest$ ./alloc_data 45
>>
>> 4) In a separate guest terminal, monitor the amount of used memory
>>    guest$ watch -n1 free -h
>>
>> 5) When alloc_data has finished allocating, initiate the memory
>> hot-unplug using the provided xml file [3]
>>    host$ virsh -c qemu:///system detach-device test_vm ./remove.xml --=
live
>>
>> After initiating the memory hot-unplug, you should see the amount of
>> available memory in the guest decrease, and the amount of used swap da=
ta
>> increase. If everything works as expected, when all of the memory is
>> unplugged, there should be around 8.5-9GB of data in swap. If the
>> unplugging is unsuccessful, the amount of used swap data will settle
>> below that. If that happens, you should be able to see log messages in=

>> dmesg similar to the one posted above.
>>
>> [1] https://github.com/BijanT/linux_patch_files/blob/main/test_vm.xml
>> [2] https://github.com/BijanT/linux_patch_files/blob/main/alloc_data.c=

>> [3] https://github.com/BijanT/linux_patch_files/blob/main/remove.xml
>>
>> Fixes: 86ebd50224c0 ("mm: add folio_expected_ref_count() for reference=
 count calculation")
>> Signed-off-by: Bijan Tabatabai <bijan311@gmail.com>
>> ---
>>
>> I am not very familiar with the memory hot-(un)plug or swapping code, =
so
>> I am not 100% certain if this patch actually solves the root of the
>> problem. I believe the issue is from shmem folios, in which case I bel=
ieve
>> this patch is correct. However, I couldn't think of an easy way to con=
firm
>> that the affected folios were from shmem. I guess it could be possible=
 that
>> the root cause could be from some bug where some anonymous pages do no=
t
>> return true to folio_test_anon(). I don't think that's the case, but
>> figured the MM maintainers would have a better idea of what's going on=
=2E

I am not sure about if shmem in swapcache causes the issue, since
the above setup does not involve shmem. +Baolin and Hugh for some insight=
=2E

But David also mentioned that in __read_swap_cache_async() there is a cha=
nce
that anon folio in swapcache can have anon flag not set yet. +Chris and K=
airui
for more analysis.

>>
>> ---
>>   include/linux/mm.h | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 15076261d0c2..6f959d8ca4b4 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -2459,10 +2459,10 @@ static inline int folio_expected_ref_count(con=
st struct folio *folio)
>>   	if (WARN_ON_ONCE(page_has_type(&folio->page) && !folio_test_hugetlb=
(folio)))
>>   		return 0;
>>  -	if (folio_test_anon(folio)) {
>> -		/* One reference per page from the swapcache. */
>> -		ref_count +=3D folio_test_swapcache(folio) << order;
>> -	} else {
>> +	/* One reference per page from the swapcache. */
>> +	ref_count +=3D folio_test_swapcache(folio) << order;
>> +
>> +	if (!folio_test_anon(folio)) {
>>   		/* One reference per page from the pagecache. */
>>   		ref_count +=3D !!folio->mapping << order;
>>   		/* One reference from PG_private. */

This change is almost the same as what I proposed in [1] during my discus=
sion
with David.

>
> We discussed that recently [1] and I think Zi wanted to send a patch. W=
e were a bit confused about the semantics of folio_test_swapcache(), but =
concluded that it should be fine when called against pagecache folios.
>
> So far I thought 86ebd50224c0 did not result in the issue because it re=
placed
>
> -static int folio_expected_refs(struct address_space *mapping,
> -               struct folio *folio)
> -{
> -       int refs =3D 1;
> -       if (!mapping)
> -               return refs;
> -
> -       refs +=3D folio_nr_pages(folio);
> -       if (folio_test_private(folio))
> -               refs++;
> -
> -       return refs;
> -}
>
> in migration code where !mapping would have only have returned 1 (refer=
ence held by the caller) that folio_expected_ref_count() now expects to b=
e added in the caller.
>
>
> But looking again, in the caller, we obtain
>
> 	mapping =3D folio_mapping(src)
>
> Which returns the swap_address_space() for folios in the swapcache.
>
>
> So it indeed looks like 86ebd50224c0 introduced the issue.
>
> Thanks!
>
> We should cc: stable
>
>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
>
>
> [1] https://lore.kernel.org/all/33A929D1-7438-43C1-AA4A-398183976F8F@nv=
idia.com/
> [2] https://lore.kernel.org/all/66C159D8-D267-4B3B-9384-1CE94533990E@nv=
idia.com/
>

I agree with David. Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

