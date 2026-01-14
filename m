Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3DCCD38FEC
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:22:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 566D96B0089; Wed, 14 Jan 2026 12:22:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53B1E6B008A; Wed, 14 Jan 2026 12:22:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C0126B008C; Wed, 14 Jan 2026 12:22:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2BB896B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:22:29 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B3D931BCB5
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:22:28 +0000 (UTC)
X-FDA: 84331238376.14.32C1E37
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010005.outbound.protection.outlook.com [52.101.46.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1F69C1A000B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:22:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=g080qjAF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.46.5 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768411346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Y3RvWn1t0L+kRA/s4VUV4H+K/e3Itz9X8wPntmfM4Aw=;
	b=nRVJPneKuY2FRHS+0mxrjT1DUSJfWUXe15JNP4FAKWoNF+DHmfN4qyRBNp2aCs6LUOyE0U
	xOPlcx9Cg2YTpwxjlIftN1kBM6gyCpPbuDLQEUTPe6a9aJfnMQ6snHVs7JVFkLuU4C3cRp
	9d+93ddWhym/sp7Tkl38jrsQQAIfeTg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768411346; a=rsa-sha256;
	cv=pass;
	b=xd209y0Leeplf3st3AxUcCzGS3wDjBAR2cKYAvkSEbcExkrGFtBC5RC8shYqZ842aDzLCp
	Ma4vJ8ZrlolC3+10dI0aQ+EC5mqVNiHR6EheEz0/QKyyVTNDsnDypQuawtwkjkuXkTfTp2
	5sMrFi9ScH3m1BGkNDj5zkLBQmcgU8Y=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=g080qjAF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.46.5 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GMAoymQNEkZNT/gAkRTS2/JZTbD3DhXorEAO7excgcrNUZu6Ota33mv64sczYiVR71UT0KsejkLuSQ0ib2Irzu2sJDoDUwU2Qo4z8c3Fd8ThFo/UrWz6k1x9YLMtqNZty4dsygYnBI3yt2XFK2rEWRXI+ynlhGPwaJBo2g15AiMQnwxsDI092+riklH8BSobOK7Z1C5YKVPGI7s02woLgJ6FqAxIfdvwaU8mB6FdPyxoV6M4VUhAbBTiux+JWPY3GyR+1npnted71yK0GJ7HmRWC9WIhEMJfliktBi41ztjsW2b9aFmltYyTvzbeWy5xqfD84t/WyA8SGNyRlpNWuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y3RvWn1t0L+kRA/s4VUV4H+K/e3Itz9X8wPntmfM4Aw=;
 b=GMNrsfHmOK+sDtGUDBswVs/Ca50pOp/z+s85JahzY9JccYPjtJszH2r0/UnPHmRh+pwXuhYJcPKIewRLE1lOPFkEpbDc3R3p+f+mM9N1EoZiXhWNWat+odeNvIHlkHhPFSCdAA1KRcyHmlLhvca6YKNM5PVhX/e+J+abRNHvMcnd+mZruZkAmKWhYffYZ7H4l9KbHhk+RbBi/ppl4m+T8f8SCsRT4MTDonfZ9dafFmms8VhnRS1Z92nJ5MpSWzEn/MbFGEnJxdkkk9HUSlBMKxUtnLP/l5gnbJ66KWL7brBmYbaR7bMWKTn9r7ZS2O5EDjfwUdS72nxThpgqAWcAHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y3RvWn1t0L+kRA/s4VUV4H+K/e3Itz9X8wPntmfM4Aw=;
 b=g080qjAFfcMV9BybRj2oxxqiz/jNbAXe7w/IdDFF7Gr/QPZoDN8vVUS+UHulk0rnprhCWSm1SBzPUoYqKe+dTotBCpumkKwaYusturFnGv3aRS7g0mxSUpal6PSfixJ9tJftU4pZXWupBBY06LJcLwuAA540of12XFGcBwmiJ4OO+/IWjQ1EAP2AfjXq0nJ3A1qSfsXLQP0s3Mjcmvz1if62WIMNRexA61rUNFAf2wvLiiMbl93xpM1eZWJFBPViAFTNTjISrSjcuZ6+Mwn19LKsiJq0oRmk1ACEJR/AbWPrxVM/pUzoKH1/hyI9nhqJFad6AGcZGYzNkuMlfLLlAQ==
Received: from PH0PR12MB8800.namprd12.prod.outlook.com (2603:10b6:510:26f::12)
 by SA0PR12MB7002.namprd12.prod.outlook.com (2603:10b6:806:2c0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Wed, 14 Jan
 2026 17:22:20 +0000
Received: from PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d]) by PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d%4]) with mapi id 15.20.9520.003; Wed, 14 Jan 2026
 17:22:20 +0000
From: Yury Norov <ynorov@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Michal Hocko <mhocko@suse.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Rakie Kim <rakie.kim@sk.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org
Cc: Yury Norov <ynorov@nvidia.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] nodemask: align nodes_and{,not} with underlying bitmap ops
Date: Wed, 14 Jan 2026 12:22:12 -0500
Message-ID: <20260114172217.861204-1-ynorov@nvidia.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0247.namprd03.prod.outlook.com
 (2603:10b6:408:ff::12) To PH0PR12MB8800.namprd12.prod.outlook.com
 (2603:10b6:510:26f::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB8800:EE_|SA0PR12MB7002:EE_
X-MS-Office365-Filtering-Correlation-Id: c856e915-944a-4369-ba09-08de53917928
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?c5nbqAJ9r3A6MEGoPeL/5WCInkTO9AV9NVoU+KnMFpoYQ8d6EJI+qXI7nRzX?=
 =?us-ascii?Q?cKO41LslKx4FLGgRDw8ktyENGmPamBbGIa8HNOhCa1Dkay5jwSMFhMX7X1lx?=
 =?us-ascii?Q?RboqcStQfVyOfy9Rzbwco8ubrrBj30zyWAwqLQjnE+Fp9uppUO8lzCgNLQL8?=
 =?us-ascii?Q?wFZ1o/DmS9z7oqdYHXRJO0vgZyCYY2SkIN+zWSNGKKfeg3NhW7iq8dScFdCR?=
 =?us-ascii?Q?uFIFz3lwjQNP96+XnPN0q0fc0G4/1CFYGV20dBIJIdC5yB9gAyHUkYXmebCB?=
 =?us-ascii?Q?YkqDf1IQ1ju9Y45yQFZoj4Q4zpUsCZlNY/b011HtJE8ScO+9OSi3ZZyBjx3A?=
 =?us-ascii?Q?ENN4C2r1r+xSEDUKLGi9EzOK33Mu4WR2jsoI2H9wncdFWpYAUAEYnSQW+MpQ?=
 =?us-ascii?Q?DFugorPdxcsO2WRSBzY1aGLqs0EUMV8+GJTmQ6W5LQp7OHBj7eJGxOmeRjNZ?=
 =?us-ascii?Q?0lf14aJpKiWHITB40u1XWoQwcux6SuCB/qiaIwpY6j+v2bgGIeFwEGmLShP3?=
 =?us-ascii?Q?WdRZUjvUOL6zIhW9I7WTTcCV51D3hxed7qKDYDQ4jDzoSUxba4eVDGbYHB0d?=
 =?us-ascii?Q?o/t426TSB7Ah2lfe9EQUy/URJT5EchhGEyqiLUw21ugnIkvcFuo1w1YjTn09?=
 =?us-ascii?Q?fp6gXSyRoK0++55e3QsENgZe7icdS/43paONsugot/xGZaY1T6xmBXCsMTI4?=
 =?us-ascii?Q?fIozJZnwAyVKfcUNsQKFhUK/3ctYfWoYuWO3eqAvxTUJjmkbH+QZ352F5MeJ?=
 =?us-ascii?Q?cS5/YtGVtactDCVLZPCXQ4DtIf+0f+eKyGdSGDcdaMRi0QyT7VYWmKraJKPG?=
 =?us-ascii?Q?zxSt4CPrQoC+aye4GGxzD80wqltkH4h6uwTuPDIpjYJ9Q//ACHCX6FUx7dpR?=
 =?us-ascii?Q?OBJpaFBROtnRj78jn7Pi2D1nsQjxCf9L7uts4UsSIcfEVVvrbaUQ/HOFoa80?=
 =?us-ascii?Q?D9sKvtrQ9Xs1foqkMiXqzTm+5fyMor79MXAIYTnWPAPFGESeT8CmkV99zfN1?=
 =?us-ascii?Q?oQzGNdz+SdHsRVXhyqwCSeCFedRGxcq4c863WoeWYxM0QlqYWGmPbLOPxlZu?=
 =?us-ascii?Q?Wc96S4XBt173mFsMTWTsrXW1bJc7OO7hvq+kffmjU/tcZdK43sN1CRkzjf/X?=
 =?us-ascii?Q?sogjbhfaneLbl13F1Gz4mMRiVKN5KzaVq/4Ol+7f7GNIh3PYdr8KjD1u13Pn?=
 =?us-ascii?Q?H4mmi/pT0Txbz+wpuTv3XPH6aYQcKqc4ajbPRHn1K9yqK+UZeYtj9Gt1FtKy?=
 =?us-ascii?Q?l5+hNr2H3nGT5huG6xLStZRMnLicZm1290gpUDuMWvTWWWfjUHTNHQTg1DuB?=
 =?us-ascii?Q?MN2WJXQ5ownrRZxA1FTSmmaQjdxD6unIFo1vTkRbPY8ET/ffWZwHYlyIzN2W?=
 =?us-ascii?Q?PL4CY70cDjgISHBUIs4gbfWBhfqTQAtxx6AJuj2Y0ewwyGWCzsen+5wFAgaq?=
 =?us-ascii?Q?l2cZGcHJYqpU1kvxnya4wD3giwhkEdF4J1YQMix4ZVPYDwGB3jtECFXPA7XD?=
 =?us-ascii?Q?dHXa2zl6yoiHGrAW93z3LeygyGDNvBmgQTyItJ2SwtRdRdK7In26qA7Xvj00?=
 =?us-ascii?Q?ITsS8LkkPUrWOVMUgkrXseqovS4VPxEWnfgP/96/AV9mvbukMldcyHLD2tMF?=
 =?us-ascii?Q?rw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB8800.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VJjgOmCmd8Ja1+En2csP+mNKUdldLmngMnACiSSg6eZvQvgdRz3vND0BKCv1?=
 =?us-ascii?Q?E+CpKGphvvQk4FTjkLrpmXdKqOBSXj2yaz37KbwpKtqW+du5XVtQkcK+CTsw?=
 =?us-ascii?Q?nG+CUeiPuErCx/q+iKGQkxDN2mAKXYMNehmvFl8SOhPNLAv8j5O3cpkMy/bB?=
 =?us-ascii?Q?IApy64VYFwEEjn8Ou6nPhf+9+mmpiaqa/quqmqMsD7TnFi7w0+zShoomvhL/?=
 =?us-ascii?Q?CQvdyNQzkgoprsCQIhMsi3hjZGl5TjOwNJoJ480shkGMhSLorK8gM4OLcGmc?=
 =?us-ascii?Q?86hvAST9CtDDl3T9GPeGfpW+sqiouyN8Q8+xFXuzdzEoVAJczoP+flwFx2gM?=
 =?us-ascii?Q?W1pdITCLmzjo1Jg6+69HAK2+FzuDaa1T55HVAvCajzN3PO895vIQsSZAT6ai?=
 =?us-ascii?Q?3pZ0KFQsYRuhDJd8Iddw2f27/8ZFEeOZJMHm/OmLiGobOxwKl61NcJnNBwKv?=
 =?us-ascii?Q?vjOZaQtfmKI4Gbb+36dJyJNeMAyXhqjFSanjSaL1t5stcVhIYbeopYJHkPKk?=
 =?us-ascii?Q?WKRatz/dssksL+QowcyvEf+HhpZ362p0/tKhJj2N/ayCjQRCmWcrRGMrswR+?=
 =?us-ascii?Q?a3JxkvB9Lqy7xtPiuN25p2DpkcW6wdy6zYSxMc61LK8BfwMYrDw6eAzOfouK?=
 =?us-ascii?Q?zV+ussV3I/90bL94WeB8xhgoeg+tClczbI8ffRu8b3rMyrEJj291+pjCTxzF?=
 =?us-ascii?Q?9st4LfNse2f+vT3AE7pFjmK0AXQQ9he5UIQfhzmqLY1nHdD+BfcFbwY+INLN?=
 =?us-ascii?Q?U3xsf1JQdkAN1iDaSg49DLMN8fMVamRDOS5IAf9jy4htxKUrMyNinA9YJy+D?=
 =?us-ascii?Q?47Iv1KzsqBFlU47WsVCjURFccGNA9YkGFjzT/uCc7qYYg/GOosVlBcDLiWH1?=
 =?us-ascii?Q?WyTrFKIrYeAYv9TDb8akd7rbuV/4J+22AXlIF/BOamhv0f0a1CEyif71OD2Q?=
 =?us-ascii?Q?hqFHq04Wqj2sZ1MpEaHi7GF0d05wBMv7fWhO2xSm0LycLtrdFvaxPAIbQP/b?=
 =?us-ascii?Q?79AVHtA1DquoluYujpJphguJ/0jxaE0X5BEr9XjHTprSpkFYPk5pIoidmgaG?=
 =?us-ascii?Q?pCuGS9gKwmu6ZSRYV/wp9wNwwe+hd6+QAc5TutgnE9BehE5eeKZOqVHRmK86?=
 =?us-ascii?Q?kqTWfFbWeQO3wWxf7ZmjzI/M09uvqt/6zJLwN7gon5m9d3NRWja+d2p0Rk9A?=
 =?us-ascii?Q?pv6l7wcCMQH1UsIWq8vokKdAW0i+uxt3h+e/8wQoQ8CfcDcSmDu4dHqzNDR0?=
 =?us-ascii?Q?Q/gvSF48JefpzzSNvh0YGzZ8yZStCOq26QSruqUHAgz1xjghpbNoTPHHR6hj?=
 =?us-ascii?Q?FAmWdGo3u5gh9C83lBAUG7+Pmy/dnOgwj9XkepGAgOmXmpnC3gW78IdwZzKA?=
 =?us-ascii?Q?+kyNnY7zETvJH68TNXguIx6ygRBo6JwELJtJ3UOaPmTGEZ0wvtCs+Z4n6d8M?=
 =?us-ascii?Q?3B+ur07pB5I0IK9yXc7RsWruSnewJsIE7kFUc2z+AEkrrTnmiMi9nlwp9ZpP?=
 =?us-ascii?Q?nUFy6qIT8tZPhe55jisp7LNxUjXcFj1uwRg/2evt0cFQ5fAu0VG2xv37xHjm?=
 =?us-ascii?Q?pDGIbMEPuB7wpmwARC7QfiO3LIT1Gl8FNQnxI4Di9hLyR01Ee2EAwEhkoGoS?=
 =?us-ascii?Q?Qplz41LHej/iBEJjBLcgC/NO+MEXkJvlcVUHQXAEkWmb5moevFbwQegpfuSt?=
 =?us-ascii?Q?KiFjMx8dB5v4HjOgrevk03dsBBleJl6Ya4+rTDe/qd43OBGKt3VNM4F0JUze?=
 =?us-ascii?Q?1J++iQzgitvaX1rc2uVQf08XTQt7TcBFgj4MpbQBB0/QGnRED9kC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c856e915-944a-4369-ba09-08de53917928
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB8800.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 17:22:20.3124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mf06eGjg++Dpg7qYlqvq9Y6Sri42Pcvl+LCd+3Ek9c2EfnAd+/uJPvR5GmYFfNdjY1kYjvQzTEGtA/843PvqNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7002
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1F69C1A000B
X-Rspam-User: 
X-Stat-Signature: wdfoemznyu5e9a76tungndwwmqnpsswr
X-HE-Tag: 1768411345-216580
X-HE-Meta: U2FsdGVkX1+E8cu4M2au+OfcAOnR7NTeOAIreAddkBgvOs4tmmzmA5WcFfgtqsr+ELuFSqtGUeZ29Ls+K/EUf1EfuWW0CiviUmpVQfrf1alamdlLr3Zc9UgSPZqeDDbJlLIqEOwwr+IQvdj3cOOvrSARnt/zmMK1z0ZLbVGXOkwF3N0PgSG52xUeNuvc4td7vc0OtTmOZGRlT3uRACGWlaOIgzIVtRf8rmADInNjJKF0MOkID7F/2gqpc0WOQRIJ1f3tO68mRag1yI6luv7F85oAvCnSvCZFMPUS5+T/0h6ZuMX3J0GU5vj0kFvkvo3JlVoXJ5kqVKKWtmuOxsCRcumfa8BlDVrtzryzXIXn+hXqTWz/rhUwiRGR2/4zfFFzP3dNPAAuB2SoPdfYFuKM24BhuYMRjTCQ4iUMV5tDvjeGfbUEFcG7MXjjoCy2HYKKDW7N5Nohkg/l0/Jv32omAFZwMFGY+dnGysxAJQsryDg4CLV5TJkzff6YlTnYbHWLELMVQBoBazSMFGXQVTWNESGPLr8uG3yfUZiWP3Jb+FBuuUKxjJUV5XJ7OjNFvptSzamGnrhL0f5r8xbjCrTCy4HZniMwN6EBTa29uC8M+2mZ/omawlZ8C40pMI/iT0cfQ/u97fTbfuxsS6KriE8VSIbIBGuz6pd7SKAJY1T6BITYHKzQKrH+e6nJZ7X+SDlfP5NxJKGMXSpdiTSSM9TgGlGWDEybOerQOYs7+q9tBUIsLftdsh7CiqCmCISXFAcrLaEVVF1n0xAxENGS6sIj357JkJmJICCupBLQWiyGpXeyYqIdK+wkl4qJUt7fqSxqYjczNH1cXLppN99KfUvugsYXxEtplDjyD4Lf9Ky9JvJec5wgwGnPafk+uln+SRubP5I9rhQf4Od37hXhYMBCyJXGyQVSbqVKouX6nl7m4szTcxSSSiZKW7c0vTyZkqvxg8DrOaST0BsPnfnunLr
 C+7lTJyK
 VzU+6Bo/2edc80KeCjJ5b6i42ppebCJVzSuL3vxBjuqKhxQnyMnZ2cqD2RTPx1bxfzmbcsjOIDC7Quj8LzuXqdEDOSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nodes_and{,not} are void despite that underlying bitmap_and(,not) return
boolean, true if the result bitmap is non-empty. Align nodemask API, and
simplify client code.

Yury Norov (3):
  nodemask: propagate boolean for nodes_and{,not}
  mm: use nodes_and() return value to simplify client code
  cgroup: use nodes_and() output where appropriate

 include/linux/nodemask.h | 8 ++++----
 kernel/cgroup/cpuset.c   | 7 +++----
 mm/memory-tiers.c        | 3 +--
 mm/mempolicy.c           | 3 +--
 4 files changed, 9 insertions(+), 12 deletions(-)

-- 
2.43.0


