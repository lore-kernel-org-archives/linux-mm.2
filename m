Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8311606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 02:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BUyDINjv
Received: by kanga.kvack.org (Postfix)
	id EA4D16B05B7; Thu, 29 Oct 2026 22:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E588F6B05B8; Thu, 29 Oct 2026 22:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D489F6B05B9; Thu, 29 Oct 2026 22:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD9E86B05B7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:12:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 237CDC05B6
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:12:00 +0000 (UTC)
X-FDA: 85377667200.17.B73A1F8
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010042.outbound.protection.outlook.com [40.93.198.42])
	by imf12.hostedemail.com (Postfix) with ESMTP id 470E840002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:11:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BUyDINjv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793326317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h+M4IRdbwygilqXWz4qb1mV9JQrGyhdpMRDLeQaCy20=;
	b=KgcCScm9y4d8+n23lUTMujyAQIi/6L6KsPbxF3bL7n+A/yBp1aUx+HvuhmInqCyz5eEbR6
	dfpPiHdxmjNGV3V+AtZ2fezGKj0JqErj/C5k0XeRIOlxjLVwZDAu4QvBo6/7539e9kLlW+
	+0+DsLCwOuh58Kpkkt65+cyD+ngxaTI=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BUyDINjv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793326317;
	b=BAkeLlA7CjheI9+RQuzUnWC5pFXy3u9QDsH5MAT2BkbRjEnG35RA9j14Ttqmt6a/39wveW
	b7RGSgsL3EEGGurM3XbrrtfjKDEota7OTqZE2Hw3CEH0n+36cob6zoU6uOwvrAdW27G+eV
	RBU2efDidKrpxM02GiPhuMYXNp/Xt/8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QMW8ROJB5cCLcK/nnHA9kySBdSGR8R0BQKkYsoqBIKri+SZ+7BfVTrptwiD65/Reawt7hfYVs4KupxjqlulW0ak0seqb351UJtesROKLTDr62R9RUazKvf68wqy2u6yk0YcPplnCh35PGOED/izO/YILEAIdDhBBL6MlRdeA5XaT6LkWjz2bh8OViMUtgcdwR02Oi11RIQ1e6wVg0gBpHMYyQEde8LzZKhThVb6KZqwzinOPjmQ7zOAIn4iJk0a8kAToceoNVMYPi5QIxNWimA5YN2cUuYeNo1v9SMSBbMAee9mlPuERcPjMGSGdQTtXk8nbtXNq7/SUsqfRi+ljOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h+M4IRdbwygilqXWz4qb1mV9JQrGyhdpMRDLeQaCy20=;
 b=xx1F7iuBYEf8/L7rWYcA5LinxQVk81wF98vo4NgIcc/okCrUGHRfSMGCxJtRHVeOtYkoWBilivUC6gzwE51/y8D9i1S1W/l+FLf4ZgrQNL2ASHY9vjCjZnHxHVB+EchS1q8OaL8nZYogM2FpYWy8b4SiE3M7LUVX8y21DRmETKpzYWVwCi866aGAwKMJqbSWZtHiRhK1xqYgE2iveE+17f+RdPj+gjjWydTgi1qw60yKV20iWW+pxgt1Vgwe8z/BW4NDcuZwylCn+1a9W5drSWh2zmSRmbmHvkeRTFLKDrC7l48iEPdcyBmEpPmLO6gtD66nHWEcflcVaZiL+iXJ9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h+M4IRdbwygilqXWz4qb1mV9JQrGyhdpMRDLeQaCy20=;
 b=BUyDINjv6jDVW7113XWXCP/XpQOBO2/qy5o6uC2AvCoy2op5QFaOV9bU1NGFxbJcApxUuPtLPDoxmr1hMQUW3rwp3WXMB3b3pj8Dhg6udFZEa7OGWWW1NPr//MAFk9XZt+BYht7qFVIR4zOsc2lhDRiVvjdSQNFWeGu0q+eoTEWXsKktfky94nckiW4nB/KQ+bUO4Bt0BULFOV5LuS2+odYvXVRk+tUEeKbV5jtKz0q9nMS0hjq44M4Rpe/vpeI1cQXbSiowFJFOqaOOioh+yPFa+6qu3hmtRcPp4upJPSrZ0qgsr6PLZxku/ryehKiR6A/jdn/aK5ob3cy+6xx70g==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV2PR12MB6014.namprd12.prod.outlook.com (2603:10b6:408:170::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Fri, 30 Oct
 2026 02:11:53 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.007; Fri, 30 Oct 2026
 02:11:53 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, David Hildenbrand <david@kernel.org>,
 Muchun Song <muchun.song@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Pavithra <pavrampu@linux.ibm.com>
Subject: Re: [PATCHv2] mm/huge_memory: set the mmu_gather page size in
 zap_huge_pud()
Date: Thu, 29 Oct 2026 22:11:51 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <013E1BCB-AAEF-4F85-875E-B670739262A9@nvidia.com>
In-Reply-To:
 <8b853e5f9f16145859407b28af654b0f79e12642.1793318297.git.ritesh.list@gmail.com>
References:
 <8b853e5f9f16145859407b28af654b0f79e12642.1793318297.git.ritesh.list@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR22CA0028.namprd22.prod.outlook.com
 (2603:10b6:208:238::33) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV2PR12MB6014:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f97a4e8-af70-44dc-41be-08df362b2a66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|6133799003|22082099003|56012099006|11063799006|261026140227099003|261026121527099003|10067099003|261021121427099003|261009223027099003|261028144727099003|261022105027099003|260925021911599003|260925022911599003|260925021311599003;
X-Microsoft-Antispam-Message-Info:
	M8wiGwgecCAjs9ydkL9T30qhEFk7uUlhWrB1jCiF25BedUsew/9S2e/gR1cXaX4YCTsC4KM4DAsfdn4ov9PYRTzWdM2KKSa8STj4fJu2Q522EMyb0X9OfAPYPBClp8HrCPz4RtsFtEe3eYzevkR6fcp7GhcGOQf25NPB9CXOppgVh48baq/mtobMU5B6G+MqknRpI65W/Nvkr7ZsqgNA3F1OiGV2950qR5V4KiN3oWEudZ0CDszHv/G4nLlcNAGJ7bUliZ7IVpNXmXfGaZ/IGsA24+K/I5GMLUrdw9YqxUskEuzuZlLB3RvFzjR1D5elmEHZdmlNeVLuY+oHrsgrcUYdGhFhSzm5XM1pMW+JcKfuw8yr1sAz3C87yNbfXTzw+za/MjnyoCQflCztYuuvk4WprjBX8lBJy/bRRVo34WkQfYTyEi4QAHeE7Ww0Wv3LQ7aw7jSKTV5scl3Wfzjpx1JDLSE5SHilajfQ7Qs5bCVWaAb0BtWU4Wxyz/dwTABneMF5QivNdYOdh9nIIDw5k8qNtR8U19e9b8xtwfz+VmVQdh5VVInjiHW2gLzbWkl0tPBWRM1jOKIZD0+5isX6dPPDqacJdgtG7xUR/cCTmhsC+hhpaEcXQmJZY4xDpDOT3yWT8Nnp5zV+WQb96VwVJ6EiJc0t9vA+LVKK2T7IaGY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(6133799003)(22082099003)(56012099006)(11063799006)(261026140227099003)(261026121527099003)(10067099003)(261021121427099003)(261009223027099003)(261028144727099003)(261022105027099003)(260925021911599003)(260925022911599003)(260925021311599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NbyfDrrrY379cyHibzCk7dvsaZ/Z/4GAST3Sjj6eLTcREApTn7hua4wtownP?=
 =?us-ascii?Q?feY/OhEpnU3mJxx3gjvbpV5Cw5IltNgsQZV765K6dZmhX8DMQjZlPxaoss0I?=
 =?us-ascii?Q?sL+Cq3Xx6P6ERknJR+Y4cuE735/LtA9OAQ+4Cp+x4LhtEndeegjdyNOcrucE?=
 =?us-ascii?Q?SghNdFKMN5cuYj7qMt4mO0DtqiWag0WWg/XQQTMm9RNetWxU+mxM52fEqppj?=
 =?us-ascii?Q?YN7GXV0BxrfR/qIMp7mvnoTybOoyW6/cP816IXZTwFRSX8rPzFUA3bNHVr4w?=
 =?us-ascii?Q?jkYJkLu1o4b42vLUMBPkGuZvpg2VxvoEOPbZkm5v5FyCp/4+Ui32ihqZ2oVx?=
 =?us-ascii?Q?9uB+RbUqhBSRSHT0EttaguJKu1qunkebyD6QxcyKiVOVu16w13MSWg9wxFHX?=
 =?us-ascii?Q?4GMVKvJb6KlJI68YGQHM7skIX/C3hPXpolDaCJrc7JktT6LeHN5ixLRoru+U?=
 =?us-ascii?Q?nHieam1pdFYQhmx0Hk4ajAxC0sbSSC768f7FWLkVUG2Z2PVbDpIGyLg2czJG?=
 =?us-ascii?Q?UChkrX6G3C9aU02209GusSru30TBBGlZL4Lf/sB92B0PYi5657762Ui8WiJn?=
 =?us-ascii?Q?V/L6HNrEAVfUyabjRfEcA3yz9V6Ig3TcsMURIuA3RIhiGRdD9e+1AFfGs76t?=
 =?us-ascii?Q?zOYU/5n2/wAvXEzckYQN8+QizOL1FJ3QdxHXA0WodiQ8uJ+iAp1+gexcLNvm?=
 =?us-ascii?Q?WeNlKHEleseqXiT7nP/3jPqyX/AEggoBXf2ppgw6fQyEhN7XkrSsM9uZq4HA?=
 =?us-ascii?Q?guoRXthT+OhUkiBViQRlJxnnRoNmgctXNXhGf3Pntftmh9Sgq0uvAildPFyH?=
 =?us-ascii?Q?HxTFL31eMkPwsNcQvFJXXAoHj1EWhEPcqv1cGjeBHSWYeXFGXiCmlX9sJpuc?=
 =?us-ascii?Q?MtP6LOQ2xCBzfivj1BYf96t2L5eCuA7nT3fykwVZaXCrFXSCEzOWQ6fhg1v+?=
 =?us-ascii?Q?yUDOJf7Z/0BCz/1kfJYb9M6w4S1A5j+1ZD7E5z2UXmw3Nlcv36g0wuSk9xok?=
 =?us-ascii?Q?9Sq26VeZkIp2HAzYzjNx2mVYctzG/dojz1eYux/3PH8OuM6QttlGGpQN3/9S?=
 =?us-ascii?Q?nFiD9joVZCawO3tQWpOflntw3S6ymkEu7orwdmi9XKcFMMN35vq0a+BK3on6?=
 =?us-ascii?Q?Ulx913keXcUGt1cuzjXDKYnLiooQIIc0PvVi6FsZpyYybc0n6lnz2MDJwGAV?=
 =?us-ascii?Q?5pk01j7muXZGZl9Me8jLRJzr+DGqZWjK0IxqrzsLDJPxloR6SJlchjKRIa3X?=
 =?us-ascii?Q?kn7xlhe7NJiLjAPv5Rf/04pFvebywO0jE7jMMPGmgL+OLynySo30B2b5xRFt?=
 =?us-ascii?Q?oCvuSNpm+AJ1huJcBOpdiDTWyk7MLpB41XNaQ9jrLU3dLxjXtgzR1jlclLfw?=
 =?us-ascii?Q?Lj0RxPxvYIUxlF2G6B+Vw5+Sxu3aYvl5GBHAdAOOjUDtXFJ7MoCh0zHGhIPu?=
 =?us-ascii?Q?EqHQQjqXjM6vFTvhuL3mY0jkuWZ558SCpRKRuxrRSS2h2N3va3evWBzXUt+/?=
 =?us-ascii?Q?4LKUCz9glGZIV9zWX2ivkJo2qZmuKjfBwODuEQEmj2WNEo54wjdW1VWkocDc?=
 =?us-ascii?Q?+g9zllgFF4NEVVvN9x2Wu5P/iG1eSoMX11LGzIQYbR3m2D3oYM7ROg9L/+ER?=
 =?us-ascii?Q?/0AegLwJ3y3zeaiFSZlBmllddDCfTlA/Vdb62+nC/MAYhfX2q0ileQtbS4Wf?=
 =?us-ascii?Q?SBYNC3GsaNahvTgIlS0u0PaM6K1M3n1eFU68AGiuhsRUsulM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f97a4e8-af70-44dc-41be-08df362b2a66
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2026 02:11:53.3831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sIDj3auhxVU/CdraN77H5uFGbAOxVlWp0+9GzybCQB2gGaqLslqjNm+GBthj7+nR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB6014
X-Rspamd-Queue-Id: 470E840002
X-Rspam-User: 
X-Stat-Signature: qnne1hycohspcmersxabmyj73guhitrp
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793326317-121622
X-HE-Meta: U2FsdGVkX194ZBqcXqj/Ke8g+YT1VGnioS367rR/A0R8jq3Wu8bf0osemgAwMC8yOMMy27jLzibEjre+h2jC5xjY5LGiabtjbkFBi0c8rCtHgqmRjdgbcnKvWIJVL9KKN66WTzWdU6TXVIs8AZmskSFGOEhpAIcB+hJa9fEOl295FcmXp3/E2T6jiyjThkKWhNCXllzvyBXAdWBY9uCgAbCtFlZfYud7zRH832OUVQUI3HogAk7aFlGE38VSMnLMn1ipyBGucgWCNukHhDEHue3RSPWW2X5oDSj0a40u6LpEgxR4iVk2lqTRi6m97X1OfFdTkCVoe5jR5pd97YCMYs6b/Xzn29XjQ1lLsb9I5surHDe/Ew9VwfxhmMXpexTn3NzVPo+yxx/qvcqSVc/ngDBHW6keIk6bzWUd+ky6DU2YYbqXwl1k0I4GbL3UGUkb/gFLer3W44WG5mmdej8oIhXpu3CVk8iCfsbKPg0XSwWp1kKqS9PMHfuoSD/ndfDERENn98pegaHtg1wGOQgVfbT6pTryOEieu8K6nM9gXVRVqNqw3+yJz3o4PkOQGET2AtxvvDg9gpbTFDagviWpc8JDFJcWwiE/s+SChyn4gUVi3q2ihiY44JnH2Dy/erjr0vyKaVckeei2jVpSei+AqUuGfso3bjy05Z56EIGT/4NOcFcEitNvGcOjLU+hEHD29M0VmyQCVPGbOyeAxrK1ZeTMUruZSyFV6YkZBSdfRGCTT6ss0vCcEibtkZ/fAOSMMWpx9iaTYkx6sM/9UXStfmsCWsgORiIgfT/305ByYCQwi1Rtguqfxhgl3Rwj//1dVk2+BrT0MIE9azowsHzNG7qDX6WM4Kt/Rzsab25vR5xTCAsPyJmqV3Tyo+/3Wc0dP4NtvtscnbNWPYDA7ZPvcOLU3T3SLLhXeQTqB1CzR1DGa8c2IgxWn92k4N6mQaE2b/VfpL0fqKLuPiy50Sv
 fqI2JA/r
 i0h50FRVx1yHo3kuODK2sxTSYKfn+hmGD6Ynqbs8oM8PrxmBXdp/A27mye2k4GSKJwe1iHpzIIiS+7nye6apSkQOn/i4XND9TX93Mf59IEuBcBTkp4YSFF4yTrYHFiALsXZZo1Qx1EUjaAXabhaAfibOW8uP41hmkJYYYSr0uLULD0LtE3o93Gb0xmPIj+G38aedzFQHOH0Tz3+y4RM0ihpo95nt3nwcYeMabxHXoFlal07YQ1rd68m2BOgMXoOjqizgUN2XS90RwpFnP4mz01rUN6wLXXPXyFk0+6c7d+aJmD6OtcFuDocruRAt6Om/qe1rpSeCPBgVB9JnXyOofdfl5caZELVqGgUigJz6Vf/QD25fscpLC5m0q9n5MtLqjHV+l6DzuVPptuDiYtjrkXKAAF7TR4NjZvwZ8zrM90J2gyTtYxpA0iQGNIPRHjTwvXj+05y8b5n0nc9c5vq2SMSslAXEAY/SqSlaA+3sa5yDH5nl/NKDuNAYGGopbajLDtkPm5Hne4MATKq8TEiJpz/t1HHyLoPYmAbkuyHUL+KC1p5Gs6Rcq30lT0JeI+zpKhbi7Vfd5ipQj0ay4vplNZvUVC2KN4Fkqr3hU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 29 Oct 2026, at 20:07, Ritesh Harjani (IBM) wrote:

> Unmapping a device-dax mapping with 1G alignment on powerpc radix kerne=
l
> built with CONFIG_DEBUG_VM triggers this warning on every munmap:
>
>     WARNING: mm/mmu_gather.c:176 at __tlb_remove_folio_pages_size+0x38/=
0x230
>     NIP [c00000000063d508] __tlb_remove_folio_pages_size+0x38/0x230
>     LR [c0000000006fb688] zap_huge_pud+0x1b8/0x2d0
>     Call Trace:
>      zap_huge_pud+0x170/0x2d0 (unreliable)
>      __zap_vma_range+0x1604/0x1e20
>      unmap_vmas+0xa0/0x1f0
>      unmap_region+0xb0/0x130
>      vms_complete_munmap_vmas+0x120/0x310
>      do_vmi_align_munmap+0x1ec/0x240
>      __vm_munmap+0x148/0x220
>      sys_munmap+0x28/0x40
>
> To trigger this - it is enough to mmap() /dev/dax0.0, touch the first
> byte so that the whole 1G is mapped by a single PUD and then munmap()
> it.
>
> PowerPC needs MMU_GATHER_PAGE_SIZE in which mmu_gather needs to record
> the page size for which tlb flush is needed. zap_huge_pmd(),
> zap_pte_range(), change_huge_pud() etc all do this already. However,
> since commit:
>   dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")
>
> a device-dax PUD maps a real folio and zap_huge_pud() now hands it to
> tlb_remove_page_size(tlb, page, HPAGE_PUD_SIZE). At that point
> tlb->page_size is still whatever the previous user left behind, which i=
s
> 0 for the fresh gather set up by munmap() and so the check fires.
>
> Fix this in the same way like how other similar paths do.
>
> Fixes: dbe54153296d0 ("mm/huge_memory: add vmf_insert_folio_pud()")
> Reported-by: Pavithra <pavrampu@linux.ibm.com>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
> [v1]->v2:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D
> - Split the 2 part patch series. Patch-1 is now superseded by a differe=
nt patch
>   from Muchun which he already posted [2].
> - No difference in this patch from v1.
>
> [v1]: https://lore.kernel.org/all/97f85592bb78a273be8519e6897e7f9b9bd31=
469.1793070429.git.ritesh.list@gmail.com/
> [2]: https://lore.kernel.org/all/20261029063601.1961415-1-songmuchun@by=
tedance.com/
>
>  mm/huge_memory.c | 2 ++
>  1 file changed, 2 insertions(+)
>

Makes sense. Thanks.

Acked-by: Zi Yan <ziy@nvidia.com>


Best Regards,
Yan, Zi

