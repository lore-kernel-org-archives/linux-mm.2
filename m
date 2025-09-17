Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA03FCAC5A0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 19:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40267280015; Wed, 17 Sep 2025 15:04:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D88F280002; Wed, 17 Sep 2025 15:04:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C715280015; Wed, 17 Sep 2025 15:04:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1C73F280002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:04:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFB4EBA7C4
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:04:23 +0000 (UTC)
X-FDA: 83899668006.08.AB33CA2
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11023118.outbound.protection.outlook.com [40.107.201.118])
	by imf02.hostedemail.com (Postfix) with ESMTP id E190D80009
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:04:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=bs9evD62;
	spf=pass (imf02.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.201.118 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758135861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BXh54Be3gTyU1t/hTfMqRaGfJ/Y/mGCpnRBAH1QuTC0=;
	b=v0ktO3V68rMOVdfLOpCopD8rIsZ0+F7fzERiiifLLBSq2aoC8zQiCoi7JLQILIHCcvnXaR
	ANgsNPUjmZQH6cyVZQVG4Z8l6CKPZOok6AsxFAp6BSradz8isP4fwApMGCveNKs4r1T0zu
	qUaUTu5PWJhK0MFGLrGEeuSKl3h0on0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758135861; a=rsa-sha256;
	cv=pass;
	b=lq4Fe8IYflwps0EqCndStuvCEkcUedneV13N0UH+xZlrVNHxVHex9ZkIkymhH+jYHJYpJc
	jXXxaPN8fYzLV2tQVDRi3wvyKxfFV5aelN4CB5Oqs52YpSeakOGyXN9GyoZhbTqxElsPyx
	cCwJ6MPmyH2mYSCMTx/hYqXSMMCg9wc=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=bs9evD62;
	spf=pass (imf02.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.201.118 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j5A4hEpYcbTuYpW3zEJJTj/AjMVSCNp0tDDTtlC1cN0DkWo7CMxLYyOUEdOH2OnaGsobBQUsztHq7dhbL11T6SSQGpSixFO1TqWuBc560I+CCw+6aoSVItFkyssOafDd8b6MB10kiOftJ50bNnxlPCALdsuABoyapwdAOIAmqtXrqgdTf+7YciHFPpitcwfzpQuKr1PmUVEeHP74PUlFTkHbhbAA6ubUhLn5KooVLrieFgFCEzDkBSg8zbqP4RdVv5ZoZhHZ1C7rIXW/2c05RIRQFar3UIyC7rWPo/pP2Jesu6giP7cFD0cpQmcD6pWiJq6Wh3EHaratT5YaLsbfHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BXh54Be3gTyU1t/hTfMqRaGfJ/Y/mGCpnRBAH1QuTC0=;
 b=NMeWIMEC9tamfuMNOh/shSgSiJCTQ/E5vBDXpzP0hNWu8Gf6aVrQXbWOOWxm9NlUZGD9dlY4xyjc56MF6H7YVE56G5p+HyEL1l+uJFobFwsb54GXzfKkp5JAbeCNM0jEAMZuB21g+BoKbkFWuF+NmzSMJ792uVcV66/lt+YMlURPIzxd+hdBKQZKmI6jklLo8ebn376ncG9AeEDPq24o4xtLtUZx8ExAwB8QtY9yaV2KFCCgLhr6AMQQ3n2GtznENP4K8FAVF2K7WOsodg/8X8CsxAKE8Q8Pk8Cth6Ux63hkE+s8clQyos78IY5Hulh8ZUGLHuRISqwTbTBlAd4KqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BXh54Be3gTyU1t/hTfMqRaGfJ/Y/mGCpnRBAH1QuTC0=;
 b=bs9evD62m0zIFjApwQ+7uNMAc0YphtUesjVfD2DE1j7s+wyjBAffW2Y5OtzRRlHy5JpvzG7c/PgPWkrm4vvhBnO7fDzEUH8rSbKWq5gyqjdj8bAFRmAT3pNUem8tIu7vtk2nRU0DklEsHlQgZ9z2Kc+EBo93CiTGDyrD+CX+L6o=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 LV8PR01MB8429.prod.exchangelabs.com (2603:10b6:408:189::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.19; Wed, 17 Sep 2025 19:04:09 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%3]) with mapi id 15.20.9137.012; Wed, 17 Sep 2025
 19:04:09 +0000
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
Subject: [PATCH v8 2/5] arm64: cpufeature: add AmpereOne to BBML2 allow list
Date: Wed, 17 Sep 2025 12:02:08 -0700
Message-ID: <20250917190323.3828347-3-yang@os.amperecomputing.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250917190323.3828347-1-yang@os.amperecomputing.com>
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY8PR10CA0010.namprd10.prod.outlook.com
 (2603:10b6:930:4f::16) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|LV8PR01MB8429:EE_
X-MS-Office365-Filtering-Correlation-Id: 588f9dc9-d12d-4a0f-8d33-08ddf61cf8e3
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|52116014|1800799024|38350700014|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/DcPtZetTfQiqrtC2k/HS2Ceuog/Wu9b+VqXQK35siMFYat5lDPZ83qu4VZ3?=
 =?us-ascii?Q?wNYrJmrbd472HmZm59K3e1ioYW30cGpiNuRUiVHApxg2eIHD+DmXhU5b/TRa?=
 =?us-ascii?Q?A250F6IiU59paWsOHGtmXmqqaYaGrdQ+26zLtgsbGYtsMXiryvmOh0+HTBKd?=
 =?us-ascii?Q?dGURHUFHmMpTk7uWnunqpQBVTi/Gt4L+OkhUHxm52fc3wG5NXLZgL0jwOZwE?=
 =?us-ascii?Q?SxG8KlOYi+gFI2BjszVPB35NEKPEqN/vr9t7q+Y4R25OUxu+2rCpLfd5HUyX?=
 =?us-ascii?Q?9A0rX7oyYicUXenybcWrWclKkVM8AKgdmSskeEtJVA+8Ecs4baMDn9WnjX9x?=
 =?us-ascii?Q?kvn7SkYWN3oVa2ecDrMLwZrj/6S4sjbkobOF1KCVt2etP7miUe/cEiyDccS5?=
 =?us-ascii?Q?IzIiNG+ONu7VAsYDQNwuLljbCYPnDMekxW+3lpY2hRmx3YZ6M3tHU3ACunZH?=
 =?us-ascii?Q?z1SJvd7AiBYihPDxO1NfF75BoVgFgGM8/AY+RmyP9rUH+ddxguMOcBwKHqGv?=
 =?us-ascii?Q?+5rj3Ak3J+Sv7OWZ+vGEOdcp5mnXUMVQCJb3R8T7TJRh++amEdh6FD5agwRs?=
 =?us-ascii?Q?2gYuYReegAuYN5TipWnKozauOOnD92RpuDyQkGiC4pZhP3Fpox5npAvb1gKp?=
 =?us-ascii?Q?8pXsl/JJibwvtKDBWZbtSeoSpidTuqmfIKUqsiePgYaXOq2hpUIW4gkfw9l4?=
 =?us-ascii?Q?+QRmDF2tUWV8B6QdNsXCV0Q7HAQGkmo6u8vljppY+Jbc6awlKQ8pWp9oy0NI?=
 =?us-ascii?Q?XRqRBuL/knAo6e8oERnMDhE8qincrg2dn+ssc/IQRwB6Bw1KSx87XhEIppTb?=
 =?us-ascii?Q?EyWXVY3a4i8zroTpyW6l0SWU5aChjXvpUHlGfOES+7CXOZ6i7IKmyNEufaMm?=
 =?us-ascii?Q?OzoCJkhGPPY9dECN8TizLDTmLqjXwifGY9GQFVRwYx0gfg6D/tp6tRB6qQV3?=
 =?us-ascii?Q?Bab3FHBys0VVAFevctkuz4vZ4fvxriqUNK+bY/xOtDxkIhbg+VWefyxmiJ3O?=
 =?us-ascii?Q?JKxpj3ambUWp+BEYzfdcDjyZJLkF52bo//mubtrTu+avPdvNbJbe97hw7Fdw?=
 =?us-ascii?Q?8LpvkA/4Js6mAUdk07qjJqCmUcioHqxI0eq1hPzi1I42cTybOHNVAJkJtX9b?=
 =?us-ascii?Q?Y0waVQgamDtdOJ52tyxknLrhmpc9JArxh7wGeG82+k3H2znNZSX6WGyUUQph?=
 =?us-ascii?Q?s41z616VOYZDMIkglwCgh1TnS3eumgxK6MROdHYSlFFxc64BqIJ6kGF3/FU1?=
 =?us-ascii?Q?WmuDO4GPwlLEs2JuCxNbjBTvFDLoRdyE+En6r97L3BexRHJ/rP7dZ5PHMjqj?=
 =?us-ascii?Q?H9MvI0u1bSpRNzr7itddHGpHr+dumBgGvHpHiH3tXtOoq5B7yLAcflgMaFdL?=
 =?us-ascii?Q?OeMXCwLCv+u8J7ktNnfbpZ0W6yAVH9xaIILpjdwhbL5d2BmcxqyjgmtFvnBS?=
 =?us-ascii?Q?oUwkqHsAd+mnmyDuAmLfKl5RoJqroHCT1L0QFv2cWamfCK4pGGzYyFzOmDAT?=
 =?us-ascii?Q?gpLGfkbZDureSEc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(52116014)(1800799024)(38350700014)(7053199007)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/IM4uC4bX1J50jvU5a883V5Kq0hwSm0sO8Qdrynct9QPGEKeiKx2f+3pu1x+?=
 =?us-ascii?Q?GRVmhOAY+dh5nP2DN467m9gC1UJ4ktu0wtDHFdzS99fPnlFUcT6GIqz88Ebs?=
 =?us-ascii?Q?p+aElCRtW71x8mZv4d5WIpLFY5RGVSktWDjgNWv0xpw/z9woPQRcSnTeFSSj?=
 =?us-ascii?Q?Fkzx+CsGiyvSlVQcU72/WpZEVaLoqyuwdWurrCKjL9uO2cjhjOI7nxRpU7H0?=
 =?us-ascii?Q?MoUpT8OG6tHnt7LcnJmxtnAKIEEqDgL4IkspQ1dQERzkZc5dNTnQkMHuxTdR?=
 =?us-ascii?Q?cHl1chcGjRFVkkz4yTH0LmU66WdMF6yXUcGIqPtlx2wBJ+cKb/l4XDBytgFh?=
 =?us-ascii?Q?xJP4scOnR7yU70YY6NO0imuiSYgor0RTL2G0pp40w5oz6KRacq1IlbyXQU8m?=
 =?us-ascii?Q?+dYnk4jcngOXfrGFznDudAOQtJzq1uFr0jeuRjaIzpPlwgptOIyD4f+mriwJ?=
 =?us-ascii?Q?X/FVe4RijH7Al5qk6Tz+/EYr5wIzbV4UqcxkFuK33g7PWwRNcTeSp8cso3lr?=
 =?us-ascii?Q?Blzcv3naMjnifn3/ebj4j+XkXU2Au3+ZR011qMu0VMBy2R7Kn0Q2V2SdYfC8?=
 =?us-ascii?Q?R02TzbT5iOse/2wAZc+hZ24SVIbDYsclBnYjtFvVUeoQqMFlD1FuC2q8ZKp2?=
 =?us-ascii?Q?p8DAb250dfvBoecsFX5nAZX/FS9Iz/68g9kh+bkEueWBiElFYg9p2GAWG9CS?=
 =?us-ascii?Q?7xLL6B0ROLoC2QvhkH+hk+fkU//cCeNGtmtFf1Usb9HFR8tLalErHFvVQqQn?=
 =?us-ascii?Q?Sx6vu4cyQIir7Qg8ES3BXHAb1JPxoBDT3Ce6hOV7aelL/QU7TR5whPJBCWXJ?=
 =?us-ascii?Q?9toMTspQ8YxslnIf03I7Z7xFWhifPLNJSLAcB1B9FLO3GhHg3pEt6kgFMaZI?=
 =?us-ascii?Q?EL/PokCqivLf5kWag2pviwMd17ERizuMQSBn03gQeFihavJoX5ak1/NVGS+D?=
 =?us-ascii?Q?uFaCbVO1XaHOiuPbhmE2yPi5YM78MjDeLFqWP6NYw7fLWD1ULRJRfvb2My2b?=
 =?us-ascii?Q?O4RNyvrxJGgKrsC+mzImYYmyo+PgJhjlXlmqlqw8+WUqhrBxOgeNREVDHs9M?=
 =?us-ascii?Q?KFVh4Qy4rG9+0SyqlvGuxAp8p2AqGx1oUZMf/pp9301Nh+Jh8xK8yxzigViz?=
 =?us-ascii?Q?jSzWZ8Mf8cAXX84diwp/e9XJOhlZwaM9xTyvDGYlzyTRMoI2eUq+Qxfk/Yey?=
 =?us-ascii?Q?EoDSltGQ3ALJWzHoW1dtWOBjHu36rGNPAMThdPQXF8XwePdcadrcgUfk4J9B?=
 =?us-ascii?Q?0mGaX++9wUHbHLAlbNLIudj1JIe+jMGr90zEGHd3++1C54tSp+DGu3ifKFuz?=
 =?us-ascii?Q?zBmx84AYgmp0HjE1sfFI34jACrayEeKKuHTZ0kGnq1uxxMQvlYLBwAiZQ0Nk?=
 =?us-ascii?Q?i/WPrSD0uZ9OfygaZJFfaMNN+EbJOJveH5E472mKlkQDiXT9ftEyQ3fN32ml?=
 =?us-ascii?Q?YpWB7mObNYjhURa/jsp9liidFo/YJhrWWdJ/DrTGNMkgwOpGGsnD0l/wkPLo?=
 =?us-ascii?Q?NAn+0kb0BGtSUMkfVlz86HXmZQOtedQlDCOp96cUeKkf+1lZGfYiEn86JCjP?=
 =?us-ascii?Q?VZUhrNeiAZxfnS2CWer1CxZMC8fJzkN0Vo5OAJ0YfIgUsi9b6YXtOjhJM2sI?=
 =?us-ascii?Q?TgRM0aKv95SpwK2WS3kjf3o=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 588f9dc9-d12d-4a0f-8d33-08ddf61cf8e3
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 19:04:09.4669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C6gN9tXXlvBanIQLcbY3WOguwznL9drqS7lKs4R92CRaV35xNhAHnIfUeuuJe8M+BuBAq2RXGN+DzUmhpnu9ujSDu2PG0J0EGia63qG3lbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR01MB8429
X-Rspamd-Queue-Id: E190D80009
X-Stat-Signature: k7o13afde7dbfw16fd9mcmcoqk41c8rt
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758135860-545357
X-HE-Meta: U2FsdGVkX191uQ53A9PqYlNI7CTqE5Q6xTPp+N70w+mk8jsZ+tZL8OFMozl6PrrrdByDBU6lAbkv9i7Yd1GPFuFRc72F9hxFhU0NgnaTKWtmPuLzpGk931kb+JpHz3g2kwOxAvufzr3gka2SV2kxicQtX94YolpANALgL91+JyMHlLT/adVP/euo7oEDTCuKeHxuDVXRBHwr4KFDRiEQM68iAGDE56VFea5jP95tem29PuZQJJWWB71TZiYgWPSWLuewcA2PObnDhgIpSr9AXD0XqA0jZ3KT6htpuxWocx6UlRi/Ln+akRRCJfYzQ5ESj8FRVxn/o/1l+wFkuJA5Sh2IwE/cK0uHpv0Ax+yqt2V0CF3dJCWwDGa2M0UhaPqcPrsO706w5GWQ0MP+jrhm64lmkVrCWCxuEJpEmJ6+8+AY9MlG0hrZw0EGzx8nJQo7Byvu6xY4nPscjQLJkduQgakSmohTwwnssKfshmmVjUt2hJlvxymcev0Z031DC+zDiOxLuNznw1vqjqd5Hh5vQXJo4azeBo1ZmP228EN/90B95Tuv+uP/sTMNKhoGu/qSNZ3BsUqRioxWfD8MMs4Jt3ZQf/rd2ov6sVQqzatkgCThzoldQBogcoVrjQXNpVKIazZtb354T/VabEXeSz/5AyMoJ6EPUIs6RU6btn/aJX+G36sQKgujMt3ZkoQ5tw1NL5Suzus/LCUeMQ9leC8OiUydMC60ifgyUC30hay4MSiwOiEKgl/ZdSV91U2lBKzE+8XSOi517j0OPqhJuJhfY4icndeZdwNkbfN8hrsZHF//VkfN0Vphie64RK4yJe07M9AJ2dmKJj5xQqr+f99yU1I/e0B6ulRjZMvPNSUYJfoOUW06M9fouEFoJm2onIMd+YBIsYKSVv3jbKPg/5Cqg0BEfQmQCHDxJCBaKK6d4zSFawWvau8UOvzkR9oWZ3tF4B3VDpQsIHUbpweRrza
 AdUmesxz
 KeN0e/WA15MmwlVw9YTusBuvXfZGtVM0u4IsWRzPXbVhXZBk01oQTLk42pSd3ulGuWQ7up0jTs6FTymu8jSJ1n7TuJfvS0FUayfES88oPgjsxVztbGIfCQ7Sf/X+FPkbi2s4nGY5U8NKE9roRFP7zZ6Ed98inZJa4ouspDuDwY4V2XD4xOEwtmYGXaYgxiAj3/d+mSj8zK/5uysKAAySxppaQlaiqt3b5J9AK2druQINCNOTLQa1pt8byC4d1MVIWUUPD8mL6b0oWAlzBocr2Gci4sRDQZOZEZ4NtdPL+iVmr7lqrkK3Hyencv95EHGf0DkXYejX4P4xvXBz8NIQW2JmBhPRwGkRJP4BF2UiG4/ipaZFIo5TSXMUCKBJvjHqQvC2hKPrIfaiFYjfNzbVKfDw0xe1S3w2lMqxVn2K74Ve0rHf6Kam3ho2l55/dDwMfyEbUfFEs7KYGyFoVZv+WkVfKw4YhHTu+lnOeLYkO2Dxu2siitL2Jp68GzuaGeozDzdqQPMa2YIFgAmbwJOBhpIi//jgHHPc+lka+lQOpoHukozrmCBr+kR66b3jnWwOS2P9pmpp9ZpOBZoaKhXRHPhT+TQZl6qyRfbCUvxiKTfgbVx01NeNsYiAlPcyHyCt8MDmt7XpRxo/ZjePc8RuAsDOG0Y6iSV34P7wbsNQVy0rg3wnN9Z0QTQq9Cu91OKdFzMsP4knY4FAptopxyjDmig1slg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

AmpereOne supports BBML2 without conflict abort, add to the allow list.

Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 arch/arm64/kernel/cpufeature.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index ef269a5a37e1..ba07eeff2a8d 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2235,6 +2235,8 @@ static bool has_bbml2_noabort(const struct arm64_cpu_capabilities *caps, int sco
 	static const struct midr_range supports_bbml2_noabort_list[] = {
 		MIDR_REV_RANGE(MIDR_CORTEX_X4, 0, 3, 0xf),
 		MIDR_REV_RANGE(MIDR_NEOVERSE_V3, 0, 2, 0xf),
+		MIDR_ALL_VERSIONS(MIDR_AMPERE1),
+		MIDR_ALL_VERSIONS(MIDR_AMPERE1A),
 		{}
 	};
 
-- 
2.47.0


