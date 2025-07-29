Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9DF9C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 13:48:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8733D6B007B; Tue, 29 Jul 2025 09:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 849A76B0089; Tue, 29 Jul 2025 09:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EA556B0092; Tue, 29 Jul 2025 09:48:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5FDE76B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:48:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 33FF31A05DA
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 13:48:02 +0000 (UTC)
X-FDA: 83717430804.07.75BF791
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id BB24440011
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 13:47:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VB88PqFR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iYzgqVVk;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753796879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=33SVG8qly0iwwqhJHEYKBbaAIQCklIgB4OSmkeCYNsg=;
	b=Hn51ffZlU8PYpI0jn7OTLuJNqyeJf5dRyuYg9fiErGLuQ+JQsTbK5soVIgVlKM5jQkemnP
	t5D+tBc7a2mSfD5ER1pa6BhJtd8hQ32zsiz8Fjs2OKqQojy9WI2elsK7Zn/ClGtYRKuDTV
	oHzassQ5ToE57DTI87QX9lf3k0k4k6w=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VB88PqFR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iYzgqVVk;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753796879; a=rsa-sha256;
	cv=pass;
	b=8qTZHIpXW825yQFVwDXUStmRJMa3VMUNm5xaEfZKysRg6QgHUdFQ5RBssNqXSnXx5eYuGy
	SZflsbMDk1nDBwnDN2KMZY1OEnzr9F7unmVdPwIVCD+N3FA0FNNJrbJhsV1C7Gq9oF7x9o
	qhDQBsiNDHJrglP5DOskqFfnNk+s274=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56TDgB38015742;
	Tue, 29 Jul 2025 13:47:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=33SVG8qly0iwwqhJ
	HEYKBbaAIQCklIgB4OSmkeCYNsg=; b=VB88PqFR8x7K8nSY4Nnf29Na8HOJFwmi
	8MKzM3QGKRiloEyWfPd/9vCPggboSybTYwMyMWhwegUTNZ7wxL2G3ZgsmCLGNG5P
	4tzUyqHtWGQYYLp2HLmgPaDquAbqB2BdEeLgN6yD7LTmEqJgtlMMdhlY+4SuxU4T
	v1W+EsRBMNTGF+mS/q+ZP8NfXrhm7vX9XjecIPXafYKxXreC+A0ftbnE7PCVjatN
	13p7c766sYGWGsxOP8i10ZOQV3Y3G88LJ9edUePU/b5KReWxQj9u03ha/0u5nYSK
	bmY3Lm6Xsep742qLkfpSaKJZ5UKNLssEf2ZJKGuirD643BCVNEZNvA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q5wym7k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 13:47:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56TDLWul003097;
	Tue, 29 Jul 2025 13:47:53 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2084.outbound.protection.outlook.com [40.107.96.84])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 484nf9xwqx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 13:47:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=toH+PXfW0MtIF67V134hizvY7P1xno9GecPQXpdeCQGB+BImcFJLOX0FdUPN5Uy2IQjobqBCkqz36gnIMjRshBz74lfYrcgT0flp5mz9RspITPETdY7H7S6ti0KeAANpGJQkJVUb6IbX3UnOfQPOcpo8cptYg3PV0ts4uUavdrVznxKhTXi/Be4RjTU6T0wGjAwaHGyljJf6xpBt1itnqmtaAV/ZekXcf0iE24lqYN7Dl9YKJbz2krtKQ0v/Cj9Avou2YSY7xltr0DtpnDKV/NKDDNVuI6P3yvZz7M5yAyugIHhjNd6fO/T9lKNHJvMlb5NhU1HROlN1idlgrNtJ/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=33SVG8qly0iwwqhJHEYKBbaAIQCklIgB4OSmkeCYNsg=;
 b=AKPDiV9J0x0Hjq8z+zne+0MW449zttDr9zbB3bTiF2Tf3gOmYsVycvdR4NKTvklvJzlghpdKHy4Sc+q7Az/wRy8WflRQIIohLjzZXjEh3041d7095iRfHh7jJ0Fmd5obuPuxOxjMIpms6OKoPr5DLRQbBa1GMv67PDw+OAg/WdqKZ7keWXPQp8K7isCvVg056pRTQUWY5ZVBU3BvOzJPBzZdlh08j3iM05Q5NeYXMYYPY50r5uc/Gj2t9b464uSA564Kv5IaSx0BEomGBuZ6hPgdmLib38FpFJYbIuo/xrBknisA8zjukhfKD0Y6ooeYkyDmIcq0ipUg6Q3ISPzuAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=33SVG8qly0iwwqhJHEYKBbaAIQCklIgB4OSmkeCYNsg=;
 b=iYzgqVVkfQLT9xd9/vUJ3LDf36czl6FUVaw0iv375Qqx1Qf44FAgYvAMwb9cJxgpEIuK+IIOHOFKJLrX14Xvk5GUTV8KUhPPQXm76SI9sQX88IAsZhtoYkp0W3aiELMXepB5LDBL1W9acJhDmZbPzXru4KyOAozSJIB4ER6VooE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH8PR10MB6525.namprd10.prod.outlook.com (2603:10b6:510:22b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Tue, 29 Jul
 2025 13:47:45 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.010; Tue, 29 Jul 2025
 13:47:45 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: [PATCH v3 0/2] man/man2/mremap.2: describe multiple mapping move, shrink
Date: Tue, 29 Jul 2025 14:47:34 +0100
Message-ID: <cover.1753795807.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MM0P280CA0112.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH8PR10MB6525:EE_
X-MS-Office365-Filtering-Correlation-Id: b64c9669-5d77-42f3-6c80-08ddcea67f99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sMCZyaD1nMyx+kW0FmQqgKaynJlJBtkKkE9B4C0yK6kdQYzlGEkLMRmQ6EGJ?=
 =?us-ascii?Q?jC/tsCx4z9Q63idysCC/KAn30v8rLf+G/RqGBMNGC0rZaPYq/J4tY4Igdo3K?=
 =?us-ascii?Q?u9SzeN4TO+7O5UPs4Vndql+ZFEn8f/K9+hoUuWYI/rBCwWL1a+7vaxRPhEuL?=
 =?us-ascii?Q?NbpRgNL/r/wUf9GGHS7t5MdY8tvfeCnePLV/W4/jwF6pjD0e7Strv/0glyE0?=
 =?us-ascii?Q?8kolrexzh4WqGu/LwT09etk4ya741/S7jHTB3KNGeqsMfCCmd0oN6O5oSuB1?=
 =?us-ascii?Q?Hnq/HsCwmvH5OXlbh8q5+avFWm9q0RaH8Cxzx9SbXxfPI+xMFWzg/IFVsT4I?=
 =?us-ascii?Q?Y1K7ED48cERUK/CsQ1/SSyeJm7VDWBZa4j3hDzRQaRo58ZVVoa+lqk7Ofb/Q?=
 =?us-ascii?Q?q98210bWS78jEn83KaHJZDViA/Ki9X0UwEZ8fUlILn0XU4e3+z9C4BDf+XyF?=
 =?us-ascii?Q?Olay4zN4iNjALmJ8jtSWEe77qVfttgw/rFgJICvFKwJCzD5MzrdZG9tAP8sF?=
 =?us-ascii?Q?4SypAejk2O+j+SEi1jcViC3faH6+ig1/5hcLfkJD/LH5MqutA83VOvf9dIyy?=
 =?us-ascii?Q?0oV3tpCveWZlK/ewHUYH5pWwy2G6IlgC/ts9oyFXJLdPoAV1frSj+Xsru15G?=
 =?us-ascii?Q?uQ9mzME0YBXy2w3NkEG/NT+Dp6EtaNk2YHD5+0aliEDFuG9U75NyqCcOwoa/?=
 =?us-ascii?Q?hlglPno9/YCFK2++QhaeZQy/BH8wz8O4aErrucCgN8xoJjtpkkfUeOqrk/hQ?=
 =?us-ascii?Q?sGVUiTJdyAZNtdojWUVOCuqynoqiw8m4pfMswhdJvjWggRu1oFq7zbx4hH94?=
 =?us-ascii?Q?vd8YBzHDb9yfuPF/FPgC6nQSaJxc+Lx8NX+g5l8flgbx9OGX5+HyId9H/nno?=
 =?us-ascii?Q?5I/4jPrzAamcyT5T2eESDady9La8GJo7pwp6yICuUlPW54rl8PG6UxWf/PeO?=
 =?us-ascii?Q?ArQcPz/mzjb43J2f7jOP8xutzjnsORfRBD23kQ+/m6el9fFLydzVOAvK8QUl?=
 =?us-ascii?Q?BGj+t84KuqsNuY+ePF+mibKH7cW3XhI0TZYfjfBA42jShE32EV+5wE2C60rX?=
 =?us-ascii?Q?UB51h4+3a6E4FB0B2Kw96+0MyD/46k7ueInmS3vOlnQHd+0+jIxtL7iqRUD2?=
 =?us-ascii?Q?k1s6r3YvgwoZcePI178zbtjpa3gw466zZmYHAQdRvvufiZe4o9u7fu5Ae/kS?=
 =?us-ascii?Q?snj1IyCEtLpEp1Qt7sRcnkGE5ylIctcHtaEM0aiUT/DMgn9QgG9m0vgv7Sy2?=
 =?us-ascii?Q?ZfrQ8A9z+D6HcUz3CBCHwoesrQRzkOVbdnbJUGIbhTzK5QTCWc4Y/BDrFoCp?=
 =?us-ascii?Q?hZ7Y5GVdJqWQbdU9H4zJU/QRbt9tJQ2VoKh4WbVVxeu2PkMBkTDeXDYzMuaq?=
 =?us-ascii?Q?oweedKMHENXGtF0Rze+pStVjUZp1W91n2M6H9w0rHIx/f+oyH6Q7kfk3Yr/t?=
 =?us-ascii?Q?XO7nL5Nhp+E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Pk2cxI0LfUt70MsFHKN61Cxb6qzVKQ6FH0i6V1U87D8/jZdJk4nGsbK1AiPH?=
 =?us-ascii?Q?gjDUOpc/e3cElPlaLksvHn6fFwHYZAi0fkfWeA2EBsIH8x15tNOY43dclFl3?=
 =?us-ascii?Q?5dtW4aDiVyzyG3vWLp0gjGRccWS0ihjxcbm+Jq8DCqyKxdHxba7kcAazxfHx?=
 =?us-ascii?Q?YqGDa8YBJ/3qXrzMCBhI1xklvB7BHXjsATQRHO47E+HxxKl6nFgrDcrtrACh?=
 =?us-ascii?Q?dASAJOSyGYUBMKQ87Hmf5fJVBEv3vOLE1JwYDiK6Y2SSBAlRPPRLHMQC/h+m?=
 =?us-ascii?Q?fURC9sHIgYo7HC1Wbzagd2KGqWODSEblVLDt3MsMEy2P1UKa8p4VonaSyBNr?=
 =?us-ascii?Q?SMC3KY3gnLfWluvPJgmf+fIavc0HOg2/PLPocbcuQIc8WpCZebPqw7P7gUBC?=
 =?us-ascii?Q?3mWvWl7VyrW50SmeTtlg4lI6sjhLzy1dnsOJyG+YL7T0hPnGAJwFounwehmh?=
 =?us-ascii?Q?wDKt60x5Zws+/bUuclDT/roo7YXXGiwocF++W058W2PWafiPkLbKMnP2qaQG?=
 =?us-ascii?Q?VtbfpCtdJGiTc/YeA5tbPGYxRkQKhFcEEhWK4bB+jVKWIyW2mFDMP8BrLuvq?=
 =?us-ascii?Q?vYRkp8T2qIt+6MBwYN7Bsd46Bw5QeT+Q74DP+ARbhGbokweNwDMDcir9ZbXv?=
 =?us-ascii?Q?oi2JMRTajPxiasmms8mZZXThbCKCNPwaDpQMQdOsc/G0aNWC3fO1LG/4EaXY?=
 =?us-ascii?Q?as6ML4m4eELhNVMWX79T1QaY6yCHurLNpVsPWWmJPE7Ee0tMFQ8d1rLNU8IV?=
 =?us-ascii?Q?w22qwPbq8xKsJYnhYJ8+CeWWJZJPVZs68zq4R05ZVVZaDOVOZKk5RWdTrE3W?=
 =?us-ascii?Q?FJM2alg0aDRA3ndX+oVYdn9bZ3ayqHi1CkpzaISWp4O780y51FxlHZByvA3H?=
 =?us-ascii?Q?3UfEE0olDBB+dRtx7mTXErbVddaOsQ2xf+uUNTNHycS1xj5qcvZg4e8lHbgV?=
 =?us-ascii?Q?i1PDr4tf/rBvvGnVRNPMGnqkPvqoppikF4T0BXPCwHtXJGWYx3+Pnz6k/9e6?=
 =?us-ascii?Q?Vf7RO8EYZgbrqAuFiw0wAniQDgNq0/mspaKE+Hrh/c0+R0xGQkj4qUSlvHn+?=
 =?us-ascii?Q?fzFwkniZMXHZrgj1UbWi4EARWHIkV+hDj00jqrsIskIz7U0u8rSsM66YmgBN?=
 =?us-ascii?Q?p2V+3uiiJIYbRcjzFi8NDbKI68pAKnGQWemDmWrV+FbUzNoAovhf6H7z6iWB?=
 =?us-ascii?Q?N1QjGGnVOMKMEZw0HhW5G+kvvgfAwAoCCy+3fXyDKWN2bCjw+pkSEYMB5Ti/?=
 =?us-ascii?Q?Lprz/id2xV4efe70G/u7eNhFNn9GhMPx+eGL+dsjg7zu2zB7QFJ+iW3IF5np?=
 =?us-ascii?Q?2EsNnclzLnqax+aqE619zGBW5gps1708ZALXaVtTNLu35w9xpfU1cL2OmbSM?=
 =?us-ascii?Q?16457Id3UPB+ZTl1I4S4ULky5R7EGNyTLgPsWA+Vngtm/duEMKG7Ue2I1LhK?=
 =?us-ascii?Q?kxQxd2jkJcNAXcPnpdA7FX/NSzFbw9qSKsGJq8UUJ3KEibZPfkdjlTDA9pFS?=
 =?us-ascii?Q?j21/AB3HB0tNLEVXjASspFFUF2wXnO3RBDCT4FF8cyHogeih7gB+bLhbvgrV?=
 =?us-ascii?Q?mRPjN/ErfnC0uJAr456pgE811vZaGBvQi4xlL2V7JDFuWLejzbcxBTPPoGW4?=
 =?us-ascii?Q?yw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Dg7kYnYYmBejh2HvreSmVH/mxEyXyZmwd3F87l7OIi5zuwZeDTSW6WtpfjaYiqjJAWD7fcaHrBfEg8unkQyA9YhcjNcAzNlD7QpUg+sr+TR9cQ7vrmoXLVwlTKeU4YcYe1Mk10nk9Lz5TjNjRBucOGqAkhSmBZjw/DQ73ApgTEIq5/OAEk1klwRLSNkkmElrRYo5KznUMbMbLEIw1w0nyg2EQ0Tthh3XciH00izO5fGSC5aUUDSC0zw0RrNaOG7U004DaGrb9m9OaMrlV2zsJpUid9leKIa31NPDeNW3W9Iq5UKxGwBVN3Rrp7znYZV9m5ru1c0KcwqL8eedxzkuyVgbkQvZwALbgNP8oypDxmgCi0VVdswOCjXtd7y/QxnZaJDWala3YvItJaAiWvk7rtXu/e3WZ08pZ0Yez/YFwvT/mCaED4veAsYQ4LrACQl7GVnoMvI+gDcwLSYTkr1sBtmOXYK57EMF/rzdzd5H+nB3irVmc9KqXqM4PLpN+YtsMKmgh9pyzZQYvq6pCemtCL9iYn0snn5CpXSGfpVgj/D3hN9OebkQcZMAeRuNV7bMJdeiAqXNxQsPqOE9Hg+3ikQIxaTEJdXA62MBEP9wRlo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b64c9669-5d77-42f3-6c80-08ddcea67f99
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 13:47:45.8092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B6mJJoOmmvlAyjXW1RR0/hIVlQ8h7WD6YVefga00DXhczGMBz5rAzk6xSdGCsEQP9LzwSl17ik3BznLFxPRJvxgCptFQTzZ8MhAL2unDnDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6525
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-29_03,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507290106
X-Authority-Analysis: v=2.4 cv=X+lSKHTe c=1 sm=1 tr=0 ts=6888d10a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10
 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=9mf5EtBIIUb1FQ0h8DgA:9
X-Proofpoint-GUID: 3VjYftmmxnpq550qdAjFxtqEF4GE6f2p
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI5MDEwNyBTYWx0ZWRfX5zq37buQVtTG
 12+CgUVOPBbmiG4Z5znAuvO6PacLDLA1+x1jb4nlQKIiuAY+Kc7xYKyfHgOy4DGxU83nrmgX1j4
 Tjxxu0I6ImM17Gi0VT8gf+cKZ77hQN/lX+zP4w2ICVoOQV80ptRRJMSKsXlDODvtdjNzgzUuh++
 DOSdWhw/VXZHVJLhDeOISj0h6z0Ad2lY0uEqtxFQOWC3DwnLfz2+nZ4BAE1JjoGzdkwfa6EIEDX
 kIUO57y8nzp1Fe/CjC4ImY+naHkK/vnyx2ECvLAf3vXGoFTzLs9dzy/foX3sy9hcc/VGGCpAyyM
 W3goFalvRFqTlRvF1tOHnNUcXPnFEozzETb1l1qOj3tFRwLwMM+QDXiFYys+7PRbmXTwrSCnkjL
 k4/u4yGEJyfzQwth4cSKDm6PUqdrBFbpHW7UCLIjv6U0HNk8M0sSJ4S/7EBUTRETiiGeV9sx
X-Proofpoint-ORIG-GUID: 3VjYftmmxnpq550qdAjFxtqEF4GE6f2p
X-Stat-Signature: eg6qs5pbko36fxyyiqm8xpqsrqhymbmb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BB24440011
X-Rspam-User: 
X-HE-Tag: 1753796878-545483
X-HE-Meta: U2FsdGVkX19QeHXxgBqLGhaJoV750i0mMxznG+1Zdv9d+hZkQMRf37c/mTRfq5l6QS1ib7bK0QSjDmlWM+iGp66nsQJNjv+IsnolnUMTwXMxTjAc4TCTQP4Wcgb5PrvFUK657N1OQTZElEiVApmMiBLpEdtlrH5E449u8C3hdLasL4Yh6KcPOX+Qnqtb9eSs7azWWXN7Plac6ZblNUa4JuLkIr0ib8B0wxLhrpzoNzUME7s3KEsU/ehwrB4Cjz0ldk0M7UuOEdbT7x5kD5kgZH9TqUAdJo3bompD63TpJR5N93SDopkSzKr+RcRLCMw2gr+QO0GmD8nOTCqC/51Er5eU6Ocj3Y4nxY2fXourh7KyyHS3upsNfvJwCmuuprU4OdbemAXo8xh05Nyms8vEGZtyb91VVHAqWZH8gZc3t25GC3VhPFjiyDvrhVGjYShk53SfBMVZZwHYStuGdYbN/mflbogPPLwDwsWSSyrVx3OvVPLnrJmLFh1O0Y6o89F3isqfP2JmhWnrzZkthcV7sElUwWW00ztdyOAf9wXQYos22vfIlJ6sjEcGTATXO1HDWH6KPd/ODDEN9H7tVTqFolP1fb7SaIVP7vwbTj2Gks6z+wlAqKRr+3Qzwb6/+A57DPTMCRgaydaqaz7onMmhc3zax0YeIbAQAbjZSvXcFF7p34ldGvDrmyZHF/mAVJa0o660o6iagSdpr/OqUStc0qHFFEMvUtOTRNN4aYFGZOkPAdWbkexuY5sF1ErrUz5skZldGnGTlDPn7MtQAzmFz2UFyI6WUxuMDcLKSUWNIeFkrGs38lAH6hTvEH5hBeM4usvfirmt4NM0sJJ3F6DLCMwZAMlQp0ltbQRWZblwyhBtg2VJ2riMpzrM+I7nAnZgTlcP+U/p8GqY19XKgDqYTMmq2rkOxV0MfX3baOTf6/92UXv8SzHayD/UybTknfB/puZS5m8Qsvfn86hMtn1
 67P5nXBf
 oNqd1hYJpbYRcNyh5T2iNW2lKsZkGF3jme9vofNowoqcjOBsR8Ibwg4nlf1NrBydnCa1xenO/dcGi+Z9S/NXDvtVjff+jICIHng1+hegWZk57HX2KuJmcZwVV7zUjSW7VQOQpXndrw5ef38OiqK5Nt6/vBibNftPxX7bOGcgW/7tpG20Qugf2RwQFBVZAtzSqmESuSzuOkEEbpzPLwmHeE7as2iEf8Y3R+dZ2JfqumFqcH39flmvR+yUk6DgD/BCTXUbIRqWLVHuhsxzs8g5ZnXPnZDSNbeSo85X/ApzaKtVLIeebf9Y1xvozNWNn3boWtpqorSohlKbSmBWgJwbop0w0iZTgtS4Az2O5xCuO84nZCfmMZut6a/hny8RwqNDrb2vlaMGorSVU/yAH0P1JytaHE2fCSotpW91CC0iyg+imhocUiGMvD/5RdlmaKljm3GiqvJarFvFf9qJrBS9l98FitOPWlzooc2NXHsZg69aygh4cHDvnQi0Oia79blf9HzamW1ueG8uNhdh9TtzsJOyN140W2KpF5F3qB43CZA+xgSZbU1K//T29rP+NMZmLLWFRWYApnLBpdWWrmZ7DA6CR2H2TM3zUmxnkPVdrxGH7XBGxrSMmvznr9EliCuhf3faPk+u1rKsOQgwxAzf2UOh0HELANEBf2W/hD0lZWEX5labO9ipBAPYaHGDaLVgpTk3TG62rBqlz1esGSaIL+Az8RQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have added new functionality to mremap() in Linux 6.17, permitting the
move of multiple VMAs when performing a move alone (that is - providing
MREMAP_MAYMOVE | MREMAP_FIXED flags and specifying old_size == new_size).

We document this new feature.

Additionally, we document previously undocumented behaviour around
shrinking of input VMA ranges which permits the input range to span
multiple VMAs.

v3:
* Use more precise language around mremap() move description as per Jann.
* Fix some typos in commit messages.

v2:
* Split out the two man page changes as requested by Alejandro.
https://lore.kernel.org/all/cover.1753711160.git.lorenzo.stoakes@oracle.com/

v1:
https://lore.kernel.org/all/20250723174634.75054-1-lorenzo.stoakes@oracle.com/

Lorenzo Stoakes (2):
  man/man2/mremap.2: describe multiple mapping move
  man/man2/mremap.2: describe previously undocumented shrink behaviour

 man/man2/mremap.2 | 100 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 89 insertions(+), 11 deletions(-)

--
2.50.1

