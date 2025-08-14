Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9613ACA0EE3
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 06:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35BF99000FA; Thu, 14 Aug 2025 02:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30E91900088; Thu, 14 Aug 2025 02:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ADC29000FA; Thu, 14 Aug 2025 02:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04F61900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 02:50:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5279B9F54
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:49:59 +0000 (UTC)
X-FDA: 83774438118.09.8B7EA78
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5985D140002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:49:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cO8H3KqP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wvrK9O3r;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755154196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nR9CWjdwrbcglCyorWepfRiuLcqhvAXZjUggggCoSOI=;
	b=ZAcdK1JLRjECTOkdVvvpTwUvIjxjecVMMJ8AXkUGf2TV3nJ+YnVHioHmed5iWCWercEau8
	0mn8kamZG01Ddea6Y9hFZkoAhqSq2UtBPy7DYAuzoGPDrIHighKBEXfcgPNPSj7M/kZZ24
	Zu0F++OTanYiTC2YLQy5NAbsejhZJFQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755154196; a=rsa-sha256;
	cv=pass;
	b=IJlfsw8BzVBq56P2FaOG2Jy+x2r2Qwo2Cp+LKS02Fc1XEM8RxfPi4EC1PWOh93OTHokRmP
	qCYX9FOis3movkmMEqo8EORZ1eHq8s01/SmQnm5krmvMCY79czV3BdQusCp2Ws7RzBopBh
	H1R0rZeBtMkmtKmYZ3K+IdULGhcZN70=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cO8H3KqP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wvrK9O3r;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DLvZ7C020834;
	Thu, 14 Aug 2025 06:49:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=nR9CWjdwrbcglCyo
	rWepfRiuLcqhvAXZjUggggCoSOI=; b=cO8H3KqPT0n90RAgOpgn5ipMz3kuMxVe
	67m7kqK78mc/A05yrfZw660T5gCX4GKr6XMAZxbGgNZWSSS9EbN9rsKCekE0UnZV
	62eWX7qLQgzc0T6geUbhL4LYl3G2EuHyiZS6YHvB/v0Ig2eRcCs27FkBWFsQDrLA
	VsRsDj9Ri78GeXQO4ZtujS90tJWGSeGaU9A6jyouD6fAtLhek4mrsHn9hobNmcL9
	1TP0RnmFSvL957GLART3qYU7n8GWdwfkZ1Mc16cL8ihQ8HrfSAcQR3FI4auhuQIx
	EnOR05qSwIm5uDEM387KEZDZzbWFTSRR9WJLF2SrxBINwAOHtUXLCg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dx7dryd4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Aug 2025 06:49:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57E5WrcT032645;
	Thu, 14 Aug 2025 06:49:51 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2083.outbound.protection.outlook.com [40.107.236.83])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvscbqs5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Aug 2025 06:49:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rwU8v5q6Mdyj5SfFTyq6TsWHgPmJKQ5UAUzBVdy7Sx+MQ2bm7wvtmJd6N+GBz7f32nlDSFJK6q7J9iawtRDATZHhIugoMPTFF8etCsPmNdldPJqqRFW66C/fLG4xDXP19Hrhiw6/22WMW5t+qx0Chs+YiP69yME4y1JcBh/Yg1xh0DNFAWYPEjYqTI6RjTuzVW6X1hNpLbQ+EOjXCopWZHlpai8EoTixRGHX77h3Omv4mLXhu9GPsWfJDTg7AvejqJv06B/M/0SGmbPimWIH7JoxjsKgh4GlCGWzdLzI4QnEzAijo1Li5BN3CcxzY9RNMfGaZcAqnVfmqt6XfIPmQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nR9CWjdwrbcglCyorWepfRiuLcqhvAXZjUggggCoSOI=;
 b=JkDE7wFCswxMWeJb7zAln88aIu/POGqNKTnHpsXlk//MGmovuA41secQpE/zHsbdWZpYatLQVPNIQM0T0YJQh7BQ+LD+UWM6sB0xVD82hJimuhV+KWKCr7iEKu2bN9ABk1iaKwG40G9xiKeF+gEtcX0oXOv9aVaKj+ijIrbVQou7gDJym0BTD6pgxukwvGpH07n9+FmaIosqosfNc2XDt+PAxI4mMlIJe0/AYI6PmWlSpRR1D6/sgF1clSNZIo38tntyOhpSrJyKaDRG2QmlZtmFnMbYEmhxq2FlONbTEMLBeJ5iYBntq5El6m4ypbbu1wMHblwZGleGFJHbiRietw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nR9CWjdwrbcglCyorWepfRiuLcqhvAXZjUggggCoSOI=;
 b=wvrK9O3rpCi3ov5/4WrPPm9kFH0XHTjqI1XdNe/fPwqUgWc9cfWZIEF9Dco1w/dh7Mra+uuvsXBJoIfSX++4MECBzwjzE/X3GY4I9LblvNdev2yusd0hdqoCXPNenBUicY+Ghf2UJxzkcNR9WRSGYf6S5PSMb1317r527xThcxQ=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA0PR10MB7205.namprd10.prod.outlook.com (2603:10b6:208:406::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Thu, 14 Aug
 2025 06:49:48 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%3]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 06:49:48 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Pedro Falcato <pfalcato@suse.de>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] testing/radix-tree/maple: hack around kfree_rcu not existing
Date: Thu, 14 Aug 2025 07:49:27 +0100
Message-ID: <20250814064927.27345-1-lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0069.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:a::30) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA0PR10MB7205:EE_
X-MS-Office365-Filtering-Correlation-Id: b9ab3dac-3177-4644-a23c-08dddafeba7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lXciIWCG2Ye+Do3g7g9BZU37GGy7FLtyNAA84odD13zNWviqFHJUKr+YQ7Pa?=
 =?us-ascii?Q?hIxybcU8EVM64CPJm8cfRPNpqkdYP81I4JBN2DpIP/o3Thiw41rl79cUCAHB?=
 =?us-ascii?Q?MjpYK/ALzp49KjmrXaRIGso4E4gTgZMHPv1gWG2tYzJVnj8YyJPyfrH8rdIK?=
 =?us-ascii?Q?W/fEgv99Gs2ch4d3DJ6V6HRSSbc1LZSvxfqJQhehsY/w+FtWh2ZrY5Hz98Cx?=
 =?us-ascii?Q?hUYkZanI9Ora/RnkfOmEOOOFTilJAh0FmdYwFdw1hG/CJbPx1eOw1AIu7vjg?=
 =?us-ascii?Q?q7W8wl/XsQ35urmFxqi7+msylZzbBF9hu7kggTOg0pD/mspvkPa9r3lczfEp?=
 =?us-ascii?Q?90AxtLkBWCmrgVUE1+2ewiBUNA9bsp6QeoACz8qLurJunU0a/4VdtXunLCoP?=
 =?us-ascii?Q?2/OBb0aKkxKnmqy41ZIqGou12b1+hSc1XjsvYt2ihEmi51FzcS6Ob3uyMX8z?=
 =?us-ascii?Q?5CahCsEc1N+Q7l2b0TGKQZKHI8Dd4ChPpYSDq54UO8zQmwBvOeBSN6fxYs42?=
 =?us-ascii?Q?8S8blPKVn3k13jTpdPWEu6L6HLpu/N7MJNc5XnCPR6Jw/VOajKcrL4yfEdDy?=
 =?us-ascii?Q?jlYQkST3lEco1NzDQz3CVayMghw9+bPI/lbrIz+6YAkrZi1WZjZP9BUCHdYK?=
 =?us-ascii?Q?38PDknG/EO+MYBZ0fo19kHf2WfNcPpr1s5sPdbmtf9xK9vSWcBloH2KeY4v5?=
 =?us-ascii?Q?YKDzzrA9S4KgTf9oXwkEG2HvvtEpP2GYhl9TTbSqUUQvSEWVy0ERHUHjNkLL?=
 =?us-ascii?Q?twUxsZ1eAIV0oQsEJKhqL+ZkpKGNdUX5scVXBSwN216EH10oBB++aVpm65Wa?=
 =?us-ascii?Q?EXwo8XWnaMqiZcqlbcafB4R8TZrU/idhIhprKKNcSDb5AFzgfhAFAoGJE+yT?=
 =?us-ascii?Q?ZyE1FKh0Os3892irMcotpmYx7USOikzC0VTUrQzssoJDCaEcus/aom066ill?=
 =?us-ascii?Q?XmmrJky1TwH/hvn3HFC04pepc6LSoyDAwHQpfyC9YeHJTA9o9Oiz18dPCeKy?=
 =?us-ascii?Q?JO/A/S7bOS48xtlZyhKUJSc181hoFHsPL+EBQ4nndiNL9lC8SL3Fpaj8GfQI?=
 =?us-ascii?Q?f49/WssYYXaX1XINGNO6RVn9E6XFKAvBA8Gza2aovbNuPAjst375CoNXzST/?=
 =?us-ascii?Q?1SymXESaQ3wgHSxGK6VlqoVPabmNXDQBZrTKCuDATZgXnbVAqGxHLR5prEta?=
 =?us-ascii?Q?EIDa8hcLX5DdxqyLCuvVPF8ry4afYNBvqltNE4KFBh1gp01ECE0EavcFSk2V?=
 =?us-ascii?Q?0GwQethX+rrMMD8MnL0wUcjbP8rPpmPJ/2u32Z9pMB9XJYyaq4ggcR/mn2kx?=
 =?us-ascii?Q?FveZmFY1mSKf6WExbRlvp/mMZE2+pkzOs1/tcWZZqEOl7tMVYdK6KKgByrWg?=
 =?us-ascii?Q?Abi120Nr2VziZ4wSKCwSreE1Bw+WI65nxL/kj8z4aUBWdBwC19311cwQ5KYb?=
 =?us-ascii?Q?ikziJVQKcXDcdpMx5oMXc4G5Fsh40R7B?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gCmElWpc8JycKgEszq030ShdkRx4uZ3rvNoLYyOrVjG8X+de7Vl84/hvWWXU?=
 =?us-ascii?Q?dPHhGw2DHyuWo5i5ze/HHSQ0oMmULFvXLxEe7UroFN+wdwDhBAPkTnUzEmeT?=
 =?us-ascii?Q?6w39E0UGJiTtv+odqc9QTZLH5AAUBXj6c2hPW2aEzQkQJvfkPGcSyKdok9cI?=
 =?us-ascii?Q?oySmrIqsaA4Sre1ztLJ3H6te6vFIlH2/E+Bns/wXG8zrcuYd6Vzv+M9Vky8U?=
 =?us-ascii?Q?B8uergQov5g62TG24OZxKtdP6owj8FfXFddgZjy9T98pKkCz3AOG2kbIwGnp?=
 =?us-ascii?Q?3Mc/DJEafPKrY1u/JNvt+yPdq5WqViJL6x3BnK88dpn/xkBivBHyuwsxq+xf?=
 =?us-ascii?Q?Y6wpamDD3QU4jXh9TospJ+w/ou4LhawSazrVEkZzVWtlSgvtZhbhcn87bb5C?=
 =?us-ascii?Q?jDGnuKrD4uG4AExN3rWJQ5FCJNhh9kGA/IbC9kmFNTiDBboTUvfMr9JPbt+s?=
 =?us-ascii?Q?IN+FQ7sWbJhWWeFY+PVV1Zg35s2r79D6cklnvB2Z+4QAsUMvVA7rDkm3ZsYA?=
 =?us-ascii?Q?N2VKPheG8XODBreSN31ke8K7jFjjnjmk6W/m6LCxCFrwFWJRz3IVt9A4WJKm?=
 =?us-ascii?Q?QxW2ejRyCP4cSxcTr3ile0a53cx1j/Qajcb4tdOkyaTvCNTnLyMUHUIVO4iG?=
 =?us-ascii?Q?5oImdyaELVlidCOLcYwNkqJWHwsssH9Edp0TmPzZ+YXHp7+Me57LkHZzetf6?=
 =?us-ascii?Q?K3fNMQYigRAISTLAKhlnnRt2GORLUNs98dFyuIst4A3mWQCZ5VHHa5qZJ56Y?=
 =?us-ascii?Q?9CKxuAGkQ6kh/EjJaS2Q+Oo5PauE/j7B78BfrSrRhunZEqhNvVNfof/gbnvJ?=
 =?us-ascii?Q?K3iO+AZ9a1iNmywDEZZg1AGAXUJlelLzsPAWQMD9vho1jJQa5+L9kkIN9vNK?=
 =?us-ascii?Q?B8vJPldJ8kr5RrutgoLSWrFuya34NPLToZgJqJKiHBR6rjDiB77HbJqbFjtV?=
 =?us-ascii?Q?REz2B9gyU6GGly2fSgPEw2ochptCW5LrZf0MU7yRvFbO/HbJ38Np3QiIFWU+?=
 =?us-ascii?Q?YLO6XxNQ/ikwRp6NGeSH66rWzvSWeB1shkspnzj7u1SGMc4PRcnZe4O1duzt?=
 =?us-ascii?Q?51XHnA2PeB3BuVwYMHgUZWlG7/fo0FDu2MtuSaxtuxxZ+T4gnxHVeZ5Cym2p?=
 =?us-ascii?Q?v7ea/QVfwDn+CT33VQp5R17idZnTsuqnzgK8m0UCEofjfvoDJoT4NpP09/BN?=
 =?us-ascii?Q?xeRu2/GxSjhSfXwW1QRPqy7i/6wEglo8B1eUwsUZjlVTr7ZGllf6lEi0LblR?=
 =?us-ascii?Q?kF14mNF2QTCzxaUklhWG6rnabMAb0hdrypRZRclnXvpsqTVUw/2/YBxHgQ8I?=
 =?us-ascii?Q?QnAykOTzj4BwOQ6JkN0qI8Gsqxv3ztGm4KnnDyC3F1GTz+FrSc2+gyTzK41u?=
 =?us-ascii?Q?60PDgqtkioX/88gA0yO8zfZ/J1jI9C5g2nsZgLDYgaf4xhlzxvhnQNuQuzQK?=
 =?us-ascii?Q?95/dD8i67v7rd7Aqq+YoPx4MOcXRBr5O1lQKDRRL/OHI+3VHeJSmnQjEVSRt?=
 =?us-ascii?Q?/kve1nT4r+lXkMCjUscaAP+yfUx9iCVLCeyunoO1QhQsQjiRzC0TQTlcF9Xo?=
 =?us-ascii?Q?tQPtZAYG6idDwaJpcldrYNZ6t0xUnugbtiVqzyy7CvMEjsGRDbUVq+PazJCD?=
 =?us-ascii?Q?Gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pr5KXN0IEM7q9z1V3xBv/8yaY2TdQEQzYa4POmVf8pnx7zRde1vBjv+EyTLKZtqba+9BoRsiZiBBWglkagJvpTEYyOGe9EFjiGka1ATxyqc0lbvonb+aRglzwaGfKOOkeh7Lay8jBjVgFf+Q0137bk9KP3jIZ6cmPomiQ9up4ZDz6P9Tf8y7YyQsnUPwkQlT5iTw/8sNVybmb9r077tcdDnEA6m6WbW2FoSDFJttjN9T/IjUCKbVBBqpexbFRMG4OYln80aqmxMFa+PHllQWKzXT8PIFqBUgDKlM+WlnXA2Ecy80swaYveTMhjv+u5zLp39TvHIB1VgsRqFx4WJCL+HnShDti0Txv7WIYILClaVEQ4lnZCnxyY1LO5sdeDI2L6PeWfgVOK6jB4wAuuV64Gl0/quIRLr4p2leRxUjLBTpYzWpUVm6K5ZzpVY4TSVPMOWm1SekRDTbLn+nidkgOiR6RvF9a437VLf+nmAIl1SdK5HGRt4ktk48hw2NWmuon5M3K5/dykejBRrGsFStWzwyNabsX+83SIK1m2atGKDjYXGxrPIoiV3Q786mrooJCgNvuzyRmYAFs+hvybvu8aklnxNeldjwiJHx+JQ0Rhk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9ab3dac-3177-4644-a23c-08dddafeba7c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 06:49:48.1731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kyVDxIaZR2vrFSRBOwSh8myWd8FRw5PPYWoSRGxGWcbEJ0Yeb5OxFdPBFDokIYd1kStNUn5CWmHdDPo+rnmrTKNpx1zyx5kdMd5o9rBTW0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7205
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_02,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508140053
X-Proofpoint-ORIG-GUID: McLC3nMI4oQnDBYNlFfon3NXF_MpTJ97
X-Authority-Analysis: v=2.4 cv=WecMa1hX c=1 sm=1 tr=0 ts=689d8710 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=PPewDV2dcNGJeLM6cIwA:9
X-Proofpoint-GUID: McLC3nMI4oQnDBYNlFfon3NXF_MpTJ97
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE0MDA1MyBTYWx0ZWRfX2cEEgf5iz7iN
 AZxjByq11lc1FVnXIexVX5uUITvLbA09jZ6juOrGVrMd/OvoRlpCHovWsmPwztUOLNddGV3+BYr
 s7r5BDH18oVN1EuUPG2bq++JbIx6Vqe3x3GUSMwsObXtxDY3IIbixjdvKGvFGwLXblbCeO0XVO3
 6jX8V+9/g2fpnw7ddnZ1V7OA4A2FD0NWiIk2k7Diq4RF1IEtcNLzGf6OZWNwxTUr7kEmeLFDysx
 FRYcmw8DDQUlINUW6qeeoDFMAB6IpaLbM5/XoquUKGWtPoy2vIFM7XdGclxUuIqN2J3pVBvntHH
 iRFkuUzQh3/WG3mofOBMSAA4PdNoSV95DFyS6ecp/jxlie01J7Nso8SM1rIo220cAdWc0CLjQwA
 zNuH2Xj2LUK+HH6h0/kk+W8xdbtGJwx2ag87aSihF+zHSL5KUMYadqodCuhz1VGeYtTCfC02
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5985D140002
X-Stat-Signature: 5pj1ogtmsbqhai8tzotsd3uzx99z1a1e
X-HE-Tag: 1755154196-960005
X-HE-Meta: U2FsdGVkX19OH0hjgY2QWX+VUjv20QN3FYMFG4dLGGuAgwbih/FU2cq4M1GQVQK/Z7GKfTxNSvqdHLDxTo/CR8on+j+8vW0QmwbEG87wa5t0LaFUYLEKbL3biXOmuXkzypUDO30WyiNEoeNkbwMRlcwj6p4QPyFOsXuXhqvujJltpdVHVNB0YqJDXNZgWwH8EZyT7PhVrH1WuWYdO94F2a7Z8LSOb+5Zy6upMPW/9L38iNPAhyIhbxJlKEkwNIkWzwDMmpVF+omCKkGKvgEJg/O8XZVMnaXXZAqBbG5bDQ0tatGvW3g4Lx+YTMa87ks5Lfi97t21vLqnYdLniQSnfj/T1BtJbqfiZ28feCeQofUx1+G2OWKPI8GnoS97Y/Uzom/ZPCeJ+Kxbr3hT9B488E9SIjfuYW/b2nwFGd+W2LaOosAxkucdyMCrNS/77zdFdievitBuVjHNWgjR6rTC92V725PTFwcyfmEWRdGwC5QutGxFCy34r02Iv501hwItUUlN0bqkQmINlHHMev/QWQYEGGPOXbVjyu1EcM0N0WSs8WUq07V+La/PhNJIcoyIoRy4bAYmxCrG7Ml+9b9zjxaJbXwUiXYH38ncCNOBQV0wSYCz9qeI0g40iUacYTcUNU2l0TJLaaPiekEq9/UasGZJoMtJdpsPUwSWrke0NJ/AJz/iMAuTS47NluWHDMSAIdatUm9okY1L612hhvTU/kka7wnMJWDd3tmcmSuy0ro2wruMwwJG8PScg2J3KSKbOREocMuNWBTbcU89pXhN4/sI93BdUQ/2NXO6gaaYg04Wg6lcMMFUZHrJ/qtHgazgaVa1SZiLYlSLPFjN9te/SiAaX9otJHDJYgySrxt1ze7ik0r7Fcx0mNkg1QZEo8bLThPwyyfwz0TAIj4puiwQUvxs0CWzAypkL/5LN2f+4dIwGhIKMhAW/PKsU1o2vOhL5Bt071VeVajFX3b5Wv9
 y74VKCB0
 guiOdE94XcNqOb4B0p3eJbE8dXkkHet2iKGVAn7SNV+ky2wt6v54F5OY3Wju6rD+CU6CG0lb2SP1ecXq7/3sLi7xfBTbi2pgZj1C8jLkR5kvyHSgaF/wTKsfFwbpHYPH6a95PG3UIsVG0PUCS51c0y2SqEirqrVdH8QfJnz9gnHXnKS2snEYW+P9tUZ1oPI5aK1QsahvMvVbs7ReQBQkHjc25fIAbtxmdMooDMn7pAmOGzzX7XhWgjrT7ZuoY03O5a969tNPkNLXBRjhGMU4z+v+zRogny30u4GqRpqqX5eZ/QwKnGSJIhN1Z2lN8ntyAJNrUYfD16YvNjEuvf0RBXzk6e/GEpmWeb/8XecR84OEEDOQZajsGbSepja3Vw61/L4shp0QvPK3tfEfKR3J9P8d6/niPKhgYr6HCxyqJ9SIJYq64Pu9heApkEDWyVowkMr7aHRq5DBOVvECASdD/TZUTiDYn+tYIqulcmlXA8gSBFW7IadzDvEDvl3MhUOBTDktS/IVKQoygDQkPxcWx+Xv92J5pSyt0Kl6BF5V4Of1Uu7jMcqG8b7jWhdhPpVlsz84GCNR3b4tX7G9MjL10PtyDpOlsk4u5EmiVzQ1CZPiQIAS9f+XD4YiYRS7qnKnOkYW7eMmAsbf3McNv0ILvD9jwfuPpKLYqpYpkRPys5HN+BAUIVyH2PHNacQXF+7inXqINm+o/InM1t2w9U01yOTRXyrIej9tAbn83eB0M385u2X9ypXxXyz8acQs3af4f4kWFpSmoTs4MAss=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pedro Falcato <pfalcato@suse.de>

liburcu doesn't have kfree_rcu (or anything similar). Despite that, we can
hack around it in a trivial fashion, by adding a wrapper.

This wrapper only works for maple_nodes, and not anything else (due to us
not being able to know rcu_head offsets in any way), and thus we take
advantage of the type checking to avoid future silent breakage.

This fixes the build for the VMA userland tests.

Additionally remove the existing implementation in maple.c, and have
maple.c include the maple-shared.c header.

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---

Andrew - please attribute this as Pedro's patch (Pedro - please mail to
confirm), as this is simply an updated version of [0], pulled out to fix the
VMA tests which remain broken.

Sid - I kept your R-b as this is fundamentally the same thing, just pulling out
shared code from maple.c.

Delta from [0]:
* Removed duplicated code from maple.c.
* Slightly reworded patch description.

Note I didn't put a Fixes, as the relevant commit [1] is not yet upstream.

Thanks, Lorenzo

[0]:https://lore.kernel.org/all/20250812162124.59417-1-pfalcato@suse.de/
[1]:https://lore.kernel.org/all/20250718172138.103116-1-pfalcato@suse.de/

 tools/testing/radix-tree/maple.c    | 18 +-----------------
 tools/testing/shared/maple-shared.h | 15 +++++++++++++++
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index bfdc93c36cf9..fbfd4fcc634c 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -23,23 +23,7 @@
 #define MODULE_LICENSE(x)
 #define dump_stack()	assert(0)

-
-#include <linux/maple_tree.h>
-
-static void free_node(struct rcu_head *head)
-{
-	struct maple_node *node = container_of(head, struct maple_node, rcu);
-
-	free(node);
-}
-
-static void kfree_rcu_node(struct maple_node *node)
-{
-	call_rcu(&node->rcu, free_node);
-}
-
-#define kfree_rcu(ptr, memb) kfree_rcu_node(ptr)
-
+#include "../shared/maple-shared.h"
 #include "../../../lib/maple_tree.c"
 #include "../../../lib/test_maple_tree.c"

diff --git a/tools/testing/shared/maple-shared.h b/tools/testing/shared/maple-shared.h
index dc4d30f3860b..572cd2580123 100644
--- a/tools/testing/shared/maple-shared.h
+++ b/tools/testing/shared/maple-shared.h
@@ -9,5 +9,20 @@
 #include <stdlib.h>
 #include <time.h>
 #include "linux/init.h"
+#include <linux/maple_tree.h>
+
+static inline void free_node(struct rcu_head *head)
+{
+	struct maple_node *node = container_of(head, struct maple_node, rcu);
+
+	free(node);
+}
+
+static inline void kfree_rcu_node(struct maple_node *node)
+{
+	call_rcu(&node->rcu, free_node);
+}
+
+#define kfree_rcu(ptr, memb) kfree_rcu_node(ptr)

 #endif /* __MAPLE_SHARED_H__ */
--
2.50.1

