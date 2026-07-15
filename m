Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50C0BC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A1466B00A0; Wed, 15 Jul 2026 14:06:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1526D6B00A2; Wed, 15 Jul 2026 14:06:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0CCD6B00A1; Wed, 15 Jul 2026 14:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BA4A46B009D
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:06:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 442DFC024D
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:06:02 +0000 (UTC)
X-FDA: 84991789764.05.F36FF4B
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11020078.outbound.protection.outlook.com [52.101.193.78])
	by imf16.hostedemail.com (Postfix) with ESMTP id 680AD18000B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:05:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=vFq1UpQl;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.193.78 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784138759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sc4DDd+cQ6kv3hKNLVMRVQ+JpaHxehsf4M1/oCbtNBc=;
	b=zwqGVnxmsvXvc91OgnnOeXVS5xbNFkfTIh+rKWtbpP3HlyUVf9AkrlRljy2529TXS1XH+Z
	7S5ABX7yQuHKSXghQPxelRHl/fXQIOMJYDIQj78LY0sBBy3sUoHtUNMtpl/A5VN82QrMu1
	LRJN3X0FOg2WUQI5Sh+er0eqvjMszXU=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=vFq1UpQl;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.193.78 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784138759;
	b=BwGqS7+4pu2oRP0LQx1ZVd/Wn61CMkCBjs+lElzYXoDjZu9SCLN75FU4y9Prd0ey46Euk3
	n2Ooa4H5/a4PPmr2LdcWiXpl2N/QCANlrv8m2EwnPKSt7Orkf9t6WRoBodDn7olEKIYJ33
	1BDP2FPwtUuZ2QNyNMVvF+NJwH9j8gk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=opKWfv/BDktkF+XIkZLR+jqRzuh7kmvcPRq2gAwAkTrubPkK4Raz7TSAtrSiuGCKWDpyJv/jUbGA7gHh8hHKBs47YKOIPJvGuP+oUZ1Q4PjJjv4jsgWYe4Gywyk20hR0GYP3Aum7m2WFiO5niG8QIMECGMjwXMnWvg83a+4/NLerpTS1h6ZGRpmH6LP+ccgz3QHmQXtsrr8ChgsL/Ad42NLXQp0FQeew7lJ2p/3W/nu2tDGA582t7fUK6R0QCBGPcTHZ8BxuteHtJqgx5CCvDXwNWTJHxH54Eo7YSUG1eAYfSTzN6dVeRUQsQUOmcj+IlfWaxPyNxpY8ydp+foB6gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sc4DDd+cQ6kv3hKNLVMRVQ+JpaHxehsf4M1/oCbtNBc=;
 b=k4HDgkgvKTOWSoMJ6o+/WA91xlFGqCzwsB4u5UZN6MX9sRlgiXeJ7JyDEWF0aRLqovcmmf7N7OWCn9v4OV6dvQwAsRp41DOYtp8HK6Pz/ILVSEi0xN3H6a23nuixN+uCmy7CF+pmY61spdCfPd6bXVgYXossXy7bbIZoaNU2ByfnZtdVByzOUyfSCykwddFz4Mch3Yq3tFqdbWO6y+wFTYXXaOukfM3s55hH5L3hv5OFO3VsHm5hOhWQ7Eg/h5BjY40nEa/jInr8/ASmEdtdo7Z0CJV4qIPAPDjiVD2Hx21EI3LK5HcW3O8yEeNB0rP0F+nVygedD/O27es7RjWQrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sc4DDd+cQ6kv3hKNLVMRVQ+JpaHxehsf4M1/oCbtNBc=;
 b=vFq1UpQlYQ0XzqLTnBdhecGsj1sYSqHEBjRuDaT2sX4euyXMILT2l2bTwku0J6M6qt3i4OtHRDapoVJJFuzoj3R1yMonXDviq3Me9G/iVCBfcIwi0IIKTt+3iVIcQAbIgvpgc9xvRveB7XvvnE68TC2lfi8y/+Wf0QU8Oziu5Ao=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 LV2PR01MB7767.prod.exchangelabs.com (2603:10b6:408:170::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.10; Wed, 15 Jul 2026 18:05:45 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%3]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 18:05:45 +0000
From: Yang Shi <yang@os.amperecomputing.com>
To: cl@gentwo.org,
	dennis@kernel.org,
	tj@kernel.org,
	urezki@gmail.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	david@kernel.org,
	akpm@linux-foundation.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com
Cc: yang@os.amperecomputing.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 10/16] mm: percpu: prepare to use dedicated percpu area
Date: Wed, 15 Jul 2026 11:04:12 -0700
Message-ID: <20260715180455.515692-11-yang@os.amperecomputing.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260715180455.515692-1-yang@os.amperecomputing.com>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CYZPR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:930:89::18) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|LV2PR01MB7767:EE_
X-MS-Office365-Filtering-Correlation-Id: c18bd9bf-4020-4ab9-b56d-08dee29bb0ea
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|11063799006|56012099006|10067099003|3023799007|22082099003|55112099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	lYTJ5qU1ar3ibmVjeEeClgHS5kqjfnNpGhRxS5MhZ5e19lN6aTin7P4smSSnpb4XelL2MKzFDz++nAHQSPO6VS4Wq2qhb1QxiADaWC62rTJ+tH+agEonvU3U2ArKAuwGPPdGe/g6NbJcjiIU3BU/pqpjBHoiI5WLVDAJksjJlXvA1Vq9eimhUGW3LROyjF9KVBDov/Fz2jEr3yK9zcvUBTQCmCOFzd1/XOeY0mgE6HUl15uoGCBVI3y0Oh/GJfo+5zWUmby2OEXfIXgOFqvDDt08r+rfiBcfdhorI4bp+V6+4f0ymu+j/KOn5srnTQvihA5J144AgZnPq8iU2Y+HhWBhmuplom7y044z80uZeqzn7it1bWdx6TMwsfMq4ApZT+4HXQaHehSXDlK2rmHGgsyzrUR0htCn6j5A4GJ/uqKbf++DQ/wHgL9ZN8Ipf5KukTz3i42s7znsxAwN6AB7YCsad0eDwHbeW0EKCEI0d9NEeANDpVDMFk0sTXu+uQndCLa2g2YuF0JVFQsVLpbm/qFqGeQepONR/jlvO2o4CbFeVkU4RnlVNhCx/fR5PsRvMmiDkIZF0TAxMSq6y1Af4v5bDIEs4VaYF32I5ANZAQL7rDpmCe16VHMP3QPiqiq8Z9OAMVPGLO00wOs+pvdtTBWLgGZPAe8Hd8rjQYn1QL07lxa9JuyFkyg82cQdCDWMkzSiLluZFl2A0tBeSYmI3w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(11063799006)(56012099006)(10067099003)(3023799007)(22082099003)(55112099003)(18002099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XWgfVG1kkHYXJy3qYlSzFF445WgKrl4StXgYktOkEcXUFWnzwoizwZgZKJ+0?=
 =?us-ascii?Q?KyEYW+kLGH2A1T4tVTykzbZRO3eJBwjYrzoZtOu5pYecTnymnpyrQ+DilefO?=
 =?us-ascii?Q?jaA8fveW5M/gbYuGMx2h+gByxtGOcPXRzAJkMuIGnj2szB/Oo/tWweSYdSay?=
 =?us-ascii?Q?oA7VDPTALDw+q8D6a/LqVQFkLV7Snsoj6GfxmQDRWp/TqlcZlJyCoVjSucqx?=
 =?us-ascii?Q?jYZIsBxh3Z96HpIqqsOlM4hXHpvV79171p52Kv4TYb4ouEtw1m8NJlUkDDph?=
 =?us-ascii?Q?yLzFBFGzfEGcqSDw6H8PKFIsT1w560gE5trqKwYmFeGNjFD3IohwtVkd6XQF?=
 =?us-ascii?Q?8w3SroxMy0qVe2RfArFdxJxChVzVpwS1I5Q3uVLjgoI7NzC46eFDu33bI30N?=
 =?us-ascii?Q?XyFZ/E7cmNi/uO46Yml/9SfjJAVFBWz6zw/9FhBop8uLfkx6/8ujpKkOXmso?=
 =?us-ascii?Q?Ahz/valVc5TrPOecxIMYNuiz+TTjg1gUVdsUlUVH82vWCZ+HoNqzg/r10Pcl?=
 =?us-ascii?Q?WknRL/I2nD7VgXnggosoZgyXzASCNguYDi+/qAD3YEZcgX6HwB40XKnF3aFl?=
 =?us-ascii?Q?Q5TdQh+dfrIxlnkk6cIPXbmpv5DgLv9YojBogYjWNdCOqeRUtt5pPKE0qDxO?=
 =?us-ascii?Q?fTFvU5vvKl2ReYMnpWgo7LXuSCN7s02pWztBRJ2I75OqYwnSPATyTvUf+syL?=
 =?us-ascii?Q?ZRjMMC0Agmp+/aTpTOX2x9kgo2sjoH6QMdmv1EwuR//weDGv27CyDHV6Zshv?=
 =?us-ascii?Q?2Mt+CSkADp3byGGGJhxHW/6q8pDDbVkYCwZnga3jeeWbvf2g0PX8V2xKotm9?=
 =?us-ascii?Q?WV5Tidfem/8w7YiOQwCImEf6QWAkjR0qUxfrZ5Peh+c8afm6ALcjOpg3qx9H?=
 =?us-ascii?Q?XlmS4FWi5RpzSlJK3Gj0mlKnDMe2ysIwVrNaCEMtzngXkPQpGMa+Ax/tnf77?=
 =?us-ascii?Q?McLksGrDpPRthtRD3jhfFxdc0cEF9xHSMRD8fG4qtI/61eJ/+BcC+CaI52tj?=
 =?us-ascii?Q?pWRKcFK/qSwqxGonAYmo9r8ki+veO8HVZphUs5k85llG8ONcWstmfdvDY+Vg?=
 =?us-ascii?Q?ctDfWgl3/NrfbCr5fi66WBTTtMRaADYvhlZ3b7gi4hw/X/fcVZ+sxFs1uZpn?=
 =?us-ascii?Q?xhpR+qmGLDCtz5p6/Pk7NLiTvWAeg9LJjr6wVvL++7hM7lftvqYEDlrVP6KP?=
 =?us-ascii?Q?IVRp+5JcB6Vud3HCEwmbWw5+6nY8q1f1iVgjqc0ZjhrXiAzpa30LeZwdrER6?=
 =?us-ascii?Q?g+OKeiPDSW1O3caJOOwIDA+rCYS5b8ZytUDj90fiNEg9ola1DeDmzSadQ9is?=
 =?us-ascii?Q?SdOvtbbp21ANMr3HdvrwKFeLXzQlyjPir7/pEs3qCGCI6zR1BsyY/PbDu8fr?=
 =?us-ascii?Q?kjNDoihs21uaDQ0eUhluKmtxNHa1dAmSg5bRufg2TJixjKNkSOQP+vP/KB6W?=
 =?us-ascii?Q?68saiQCXRP8aOxY56O6F5e5dRfuEtip8+3tf0f9RQmYgJIXyREPEkJlAx9bb?=
 =?us-ascii?Q?Ce9DDU5WS+iS/JL4OfwxTPcJ9SwLKiYoxOwaHbt86IXSMR2ryIEhnSgaEsft?=
 =?us-ascii?Q?tJakY9nLZ/0vs94yJ+B1dEQ9blWOGdIrrpk59sok94sp0jC6SfKm938JLBV3?=
 =?us-ascii?Q?dJRnCPyYW1NTfgye4c/NX63eeJhAUeAu5bZ+cSJE1U1r8NhK6NIKAUgst5tZ?=
 =?us-ascii?Q?h6zDQeEJ8UBzNWq8Xz46LTtx4Wwon/2sk1Zx0NPHZGiGLKXepQC5Mj/34IqX?=
 =?us-ascii?Q?3glOWfqpN/fTARYwBKPC93NSMZ6XsqE=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c18bd9bf-4020-4ab9-b56d-08dee29bb0ea
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 18:05:45.0305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E6BwwYx5TWqD3wOQM1Alni5OxCsi/gdZFSkguIaaL6r2K6SeZOYSCw4eCuUKnxaOWuPXpCF7LW4przjxbg6f/LfXPQguJqXP2BbpnPe8J+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7767
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 680AD18000B
X-Stat-Signature: 9yt4ta36ebfuf4bmntxu8gg7z74p5dj8
X-HE-Tag: 1784138759-388098
X-HE-Meta: U2FsdGVkX1+4DQfKj7aLop3f5OIOVOGUOLdDOuYZWo/ScArGAgJA3Uzzt7fxnIOc66smLcAzCSQrn5928oqC8fRBOVtWzwmLWXCiEA6vbcj9TLufUatLLcH5EmOK4GbH/nS7ayXoWa9ZUzWV8Ok5yW3DxPIWmh1NcshPIsirhxth0ELleaUtN0p6dRCtb+RxGieHMl9EIGZTS9agR85Ok2pILMSdCueA6kByDzmAfrCvbwKQrlf8iu6thBWhABIyA1pHp/mdO0RZ2v7LXdJGa5dNdXAJmdYI1cVbiZ4P1K3gc/ERwelhBo2MsepVb4MMfnBJVfU/jrwSmdcm7rd1JGdMe9lZ581B8TPngeNFh8R4OlMsiNOl61mcBDa7m2yCle9YCWhFUUZ7j3Y9FxFRHQOyi5Z5O8vkdhGS1K0SPo6NHjI4bX0fieC3GYKPgI+9y68veLZrvAU5N12rCJlJ3CjSZYim28jSBeClUgDolZmnC8LwBuRwcMBhN41t4n96pnIVpl7bkxx4LcTpFa1ZDgXctH8vvc+btn5+qZ7wbtaaRRBIDRkf6C7csj6v0p55dIbDGFWdUaberX/7DKzIPTf8NFRU3jDozj9ZKzoLO5JJmY7rJIlE+FTrpO+5VH4bps7dTF3cyCjoVmY0UqbBQk3OcTWv6M/qXB9h84NIqIGkMY0e1S04FoLI43mm2t3gOykaLqshMwADpcEnh0UePkEyTW06V3l5jtNkdLt0zql0/4xNDXBlcx8gIGFzSLVvYT3li2lNuptHRpbnd3FUIY9BLCCZrJJvleJd0u+wKvJEM+FI8erDqL5My6SrixNI0xWJNCukIVtv0uZgN3ahebFXAD1MA5MkLihKOj/UHCZnXMWwTR/ScoqsnbsR8sbLchi1+2MiWoPdc4brE3KcvV9q+kqNOQUfrEEuWu3rooMSLcPl5ILEzh6Ybnkw5nH+v6qHu1XOGOnMgQI6cUc
 YcxfkCRT
 QKF4IpDLCYz2ABTblDS8q77YiXoLfZeW1k8q3yBz2mvOOa4FK5w9Tn+MyFxj183VSoKcGzFUfZVD5hMxq2SYFdax/4VN0srcqDjVK4XT7uoLswtmzwUhi2/rVCDbIy6SEfNClPsVIuZ+xBsSv/UGD0pGHDj7+FmtyLr1OYDULX/O52OlFpy8Z2X/D/7ZZBDjItpBBCh2i3KBvzq6EurLjKdFfRDFAaExEuU2X/7HW/GaSbkSKGlX4uAaQ0kPlOrXZVkx/hBXRPVzCPnQb842jnOHNVGipaWU3YCLwH7y18+f5++yhwsv09WTCqkrfYbWVRBFGB1U83BjEpXhh17iDQwYigqRqYPVyq1xN3jy1Qs1w2cYDwjcV/5Co8kUWVQkvGiWHydUIlzTwP+yhFl/rpHdg7xN0CwqQLlxb0CCwkXxgKhOZ5+PVGI9wWKsWloZOUmjIflS9u2T83Bo5U7cAC1+UqXZvwWkWAK4rVQZs6Sl4FMIMFh9lx18OhcGB6FqxJtcF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The percpu variables are allocated from vmalloc area by default.  The
architectures which support local percpu map will allocate percpu
variables from dedicated percpu area, for example, ARM64.

Introduce a new kernel config, CONFIG_HAVE_LOCAL_PER_CPU_MAP.  The
architectures which support local percpu map will need to select it.  If
it is enabled, allocate percpu variables from the dedicated percpu area.

But still treat percpu area address as vmalloc address.

Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 include/linux/mm.h | 11 +++++++++++
 mm/Kconfig         |  3 +++
 mm/percpu.c        |  8 ++++++++
 mm/vmalloc.c       | 23 ++++++++++++++++++++---
 4 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..c8c3800fbd9f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1858,6 +1858,17 @@ unsigned long vmalloc_to_pfn(const void *addr);
 #ifdef CONFIG_MMU
 extern bool is_vmalloc_addr(const void *x);
 extern int is_vmalloc_or_module_addr(const void *x);
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+static inline bool is_percpu_addr(unsigned long addr)
+{
+	return addr >= PERCPU_START && addr < LOCAL_PERCPU_END;
+}
+#else
+static inline bool is_percpu_addr(unsigned long addr)
+{
+	return false;
+}
+#endif
 #else
 static inline bool is_vmalloc_addr(const void *x)
 {
diff --git a/mm/Kconfig b/mm/Kconfig
index 13ea4b29ee7b..e1910c332638 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1061,6 +1061,9 @@ config NEED_PER_CPU_PAGE_FIRST_CHUNK
 config USE_PERCPU_NUMA_NODE_ID
 	bool
 
+config HAVE_LOCAL_PER_CPU_MAP
+	bool
+
 config HAVE_SETUP_PER_CPU_AREA
 	bool
 
diff --git a/mm/percpu.c b/mm/percpu.c
index 45c30c6531c5..b27828602c32 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -3243,9 +3243,17 @@ int __init pcpu_page_first_chunk(size_t reserved_size, pcpu_fc_cpu_to_node_fn_t
 	}
 
 	/* allocate vm area, map the pages and copy static data */
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+	vm.flags = VM_ALLOC;
+	vm.addr = (void *)ALIGN(PERCPU_START, PAGE_SIZE);
+	vm.size = num_possible_cpus() * ai->unit_size;
+	vm_area_add_early(&vm);
+	kasan_populate_early_vm_area_shadow(vm.addr, vm.size);
+#else
 	vm.flags = VM_ALLOC;
 	vm.size = num_possible_cpus() * ai->unit_size;
 	vm_area_register_early(&vm, PAGE_SIZE);
+#endif
 
 	for (unit = 0; unit < num_possible_cpus(); unit++) {
 		unsigned long unit_addr =
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 17c26e9796b2..9ec401918736 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -80,6 +80,9 @@ bool is_vmalloc_addr(const void *x)
 {
 	unsigned long addr = (unsigned long)kasan_reset_tag(x);
 
+	if (is_percpu_addr(addr))
+		return true;
+
 	return addr >= VMALLOC_START && addr < VMALLOC_END;
 }
 EXPORT_SYMBOL(is_vmalloc_addr);
@@ -4926,9 +4929,15 @@ pvm_find_va_enclose_addr(unsigned long addr)
 static unsigned long
 pvm_determine_end_from_reverse(struct vmap_area **va, unsigned long align)
 {
-	unsigned long vmalloc_end = VMALLOC_END & ~(align - 1);
+	unsigned long vmalloc_end;
 	unsigned long addr;
 
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+	vmalloc_end = PERCPU_END & ~(align - 1);
+#else
+	vmalloc_end = VMALLOC_END & ~(align - 1);
+#endif
+
 	if (likely(*va)) {
 		list_for_each_entry_from_reverse((*va),
 				&free_vmap_area_list, list) {
@@ -4969,14 +4978,22 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 				     const size_t *sizes, int nr_vms,
 				     size_t align)
 {
-	const unsigned long vmalloc_start = ALIGN(VMALLOC_START, align);
-	const unsigned long vmalloc_end = VMALLOC_END & ~(align - 1);
+	unsigned long vmalloc_start;
+	unsigned long vmalloc_end;
 	struct vmap_area **vas, *va;
 	struct vm_struct **vms;
 	int area, area2, last_area, term_area;
 	unsigned long base, start, size, end, last_end, orig_start, orig_end;
 	bool purged = false;
 
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+	vmalloc_start = ALIGN(PERCPU_START, align);
+	vmalloc_end = PERCPU_END & ~(align - 1);
+#else
+	vmalloc_start = ALIGN(VMALLOC_START, align);
+	vmalloc_end = VMALLOC_END & ~(align - 1);
+#endif
+
 	/* verify parameters and allocate data structures */
 	BUG_ON(offset_in_page(align) || !is_power_of_2(align));
 	for (last_area = 0, area = 0; area < nr_vms; area++) {
-- 
2.47.0


