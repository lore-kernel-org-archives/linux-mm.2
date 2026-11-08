Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B3ED606A320
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 23:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SN+Vwlfb
Received: by kanga.kvack.org (Postfix)
	id AC4F86B05B0; Sun,  8 Nov 2026 18:47:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A75C66B05B1; Sun,  8 Nov 2026 18:47:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93DBB6B05B2; Sun,  8 Nov 2026 18:47:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4C06B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 18:47:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DBFAF160530
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 23:47:30 +0000 (UTC)
X-FDA: 85413591060.08.50ADD36
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010062.outbound.protection.outlook.com [52.101.201.62])
	by imf09.hostedemail.com (Postfix) with ESMTP id DD179140005
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 23:47:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SN+Vwlfb;
	spf=pass (imf09.hostedemail.com: domain of joelagnelf@nvidia.com designates 52.101.201.62 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794181648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IpWZS9cPNLpCpEb8Lx2dVgIBiAiU2xuD/6ks6S4rHHg=;
	b=a0ZECZLUqqqp6Ksyx1dLwJdehiLZK0q77kPgr3ysnYvGHgwU0KFOABNyOQAJTCNMkSaoVZ
	FrTpBJBLNxrYylibGeMsPNUVWtuCh8A+1vT0wgtiAL4TBfHm2CMMMBV6Sxf7/rWy/xzvph
	E3BikVlfHjYAs6h6oVFJEDLSFjZzOjM=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SN+Vwlfb;
	spf=pass (imf09.hostedemail.com: domain of joelagnelf@nvidia.com designates 52.101.201.62 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794181648;
	b=WNg9q8UWZH2MtkXyYGBziZcZ4FZeSYW3D48aidlw1kKLLsV1n/iJZGmHvhEQSfqsWHbL8z
	tEe8n1blwfPfNucODned8J1CBzsfAa5rkiFnyiar9+fUw1DXkTfRZtGAQ5ikmYLL1j8Kw0
	Jr82aOorl3g2OzkdSjpEn5UdJQ2RHsE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=psFymd35XK3JhE+pbhjx4tvc+d0wuEJtXlgOvPbGfb6NIZ99t0obNNPKbkq6kR0oHoco+jwP1tdF5UiKo9Xx/iHJoIWlzZ/7w25Ks4K5JdKHZqrasrCFA3fW60PenbY4s0S7zoX2uxJ19NT9sRa3ORhLckaa4hJXEJ22ZCE381OS4iwy54nrp1ghPZWEDqTXx7F3SlzKMLVDj5716lDBmnnSmNwf7VGXwQwQ7jITy6blQxBA3Gd1sY1rWUb3jlXcwuxQMrSSwKXLohCWG5cbxxTMnHgcIrM6dlVMVsZtX+5fAwdNC2uKtYnpM21GaPKRRW5HU3+erMJ2CeZr2sudnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IpWZS9cPNLpCpEb8Lx2dVgIBiAiU2xuD/6ks6S4rHHg=;
 b=YdbSHWhsGOT2C/tJWen42zVf29aqxlozwXKO/PxDF3Jm7CBsOksSOsxBv+f5IcvcOdz7CPp+cVw0+nsHQ+V9/OVh+CNB+kD6p1F9+jpedKrc7A12Zm4hgChWauBsGHvo64QIKvmyZ0dw0QNZaJMWtMZdNXB0N0BwYfoHSt71Gvl/xKwkjplzPNaIJl61Y2VfWm/TyvqWI9/m9olJ2DMRXzBoOqJsbN0pGtVa2UgALmxCLX1Zw3+0AqUOMklTWcxIsYsszbOC9z3TUEemM+Khh8eVyrTqlV+ui9VQ7uY5VC8kzQO2aqZsgLF1a+kQLzeodHKjQ53mDweQzxj0tiDiLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IpWZS9cPNLpCpEb8Lx2dVgIBiAiU2xuD/6ks6S4rHHg=;
 b=SN+VwlfbUknxTfG9OOTwASXlFiwyH0pnApVxByICnRZ5KGJ0CXQEyXGCq4D6qg5dybONJ6udYrlng7SSM0bpHnDU2QDN3G2w9Fuc9CnIpZv9ca1YK7JX2zeEBPI1TEgQCOm8XYc6atoqX4nAtXkBhXrrXRrSbU58RXxOACoMySTYpfCHsgSNO3sp+3+r1ebBcJZ2/mwIKUPbupOFd5LrUf6ZpMoei/MvLRdnHIJpdQ8uwdz1dRBAvMa3mX+Ve8F/dJ1/CU5re0J9R4Ol1EI0EjgkySrnBMMfmFH1zeHGnOlRjyXvxsW05fmoc9J7AgJCIxcyXwpU6T+1m6JKDLIOfA==
Received: from DM4PR12MB7742.namprd12.prod.outlook.com (2603:10b6:8:102::18)
 by IA0PR12MB7579.namprd12.prod.outlook.com (2603:10b6:208:43c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Sun, 8 Nov 2026
 23:47:24 +0000
Received: from DM4PR12MB7742.namprd12.prod.outlook.com
 ([fe80::8df:c519:298a:94f6]) by DM4PR12MB7742.namprd12.prod.outlook.com
 ([fe80::8df:c519:298a:94f6%6]) with mapi id 15.21.0592.010; Sun, 8 Nov 2026
 23:47:23 +0000
From: Joel Fernandes <joelagnelf@nvidia.com>
To: linux-kernel@vger.kernel.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Joel Fernandes <joelagnelf@nvidia.com>,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: [PATCH 4/4] kasan: Avoid an unrelated RCU warning in the callback test
Date: Sun,  8 Nov 2026 18:47:12 -0500
Message-ID: <20261108234714.3713501-4-joelagnelf@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261108234714.3713501-1-joelagnelf@nvidia.com>
References: <20261108234714.3713501-1-joelagnelf@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0P222CA0005.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::8) To DM4PR12MB7742.namprd12.prod.outlook.com
 (2603:10b6:8:102::18)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB7742:EE_|IA0PR12MB7579:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a3618f3-531f-41f9-3c49-08df3df2a31d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|261021121427099003|56012099006|261022075727099003|261022105027099003|11063799006|261028144727099003|261009221227099003|261009223027099003|261026140227099003|261021123027099003|261102123227099003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	UZr3Y4iPdLgjMi8pPo+IVnfnKtlSqG0d9EG7krTYZh1UB1PpqkCmzX99BJlDM9oyuDD9SKrieahREmWSw74UGRrkhGjTraygzd9wEibMKpRsjOQeagcNA9/zmtv8Hm7+HMZm5anNf9GFAsXVxCcQfgyTmZpxw0Omq4muOBgA4wXXp381k2xWfF9D+mKNteUheoz8/5x//r8s/o1LY8Q7jFi0oklGLzUY36O0mZg237jgbxM5MOYR6FJSUtfi13JvPNnSspGjThRxMRRrJuQAqbuTqxLbdW/y+vI9efsu3idw5kuMhyxBBB8V+jAGV7ef8kgAB/Vj4BOitfcwJWE6HYITOvyLKf3dmLYOwBqroiS7pku7NyOFMKRvlKwwv1Rt7ZwKydQ2xKcGVzE38hW3LX1zGuBTH80Jng2wJd5+aZNkxtW2NTOquriMrr0pd3afs9Mk61yhnZoDLzwIeNGRMjl2cg0eaSqwHfhYD+8aR9/mSP+CZ2ZYJObjo3UhPtzsWRpUppmLADJD9XQz9cLm0apCh3PHoGbtHY8CtcXH0Q9yw1XcRUtEo/HHNrcvxvaad+Q5H+QbMs6SVWrLgY/cMslQ/iqxbHxjMsCpvxlQfd1UcvkT1jqvL5Zbh8nioPpmIMxFsQn04Qn2mQNLycvBhj7ZQta73ruhzfw0Q2hFX7U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB7742.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(261021121427099003)(56012099006)(261022075727099003)(261022105027099003)(11063799006)(261028144727099003)(261009221227099003)(261009223027099003)(261026140227099003)(261021123027099003)(261102123227099003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xyPB3RSoPErouTvf6n0sLwrwGkxWbN9uqk8rwWzry1PI+4vIhNoELJr2RlQ2?=
 =?us-ascii?Q?pvpB6dMblSBYUuziQ/uxXWYtGkYrdyfTdef5OsnJxJsnf04BcOjzNACbGnoj?=
 =?us-ascii?Q?nYsRYKrQc+ggcAoemW24Spx6RHVXkWJEg3X74JWJPrxmEpJ5iIK2J4d+NdCH?=
 =?us-ascii?Q?/5Mr0Hf75Luj4p8wVJ9RYxq4PH7Xvmq2/7ZbHQfyViBRtUh6Gq9xRDycR66H?=
 =?us-ascii?Q?oQWqwY5LCjSxZRGQyX+oDGOhANpRuG7N+G0yQePMyTi0Fbi65fOVjSogksT0?=
 =?us-ascii?Q?yJ8atx9w0NW+cam533FDJe/O3GXQ9A8++yhPapeLc/9cxV5ZrtTUt+eYm0vF?=
 =?us-ascii?Q?uQ+O//jrDnKXOEzrUQ6XeO4ueadE/q50dz5LyqdvPxy0jm3Pdv+IFr0JomBN?=
 =?us-ascii?Q?aig0C5+UPfHB3e8+zEcwVbEbEwo5JlEu0Rqrl7HMBf13vSCHJWm3r9PXrp/C?=
 =?us-ascii?Q?PNTyZfmHlRg0TfPtcM1OO3rL3mblFEIAx8qYmfzHkOkMK2HJc8d/TXC/xgde?=
 =?us-ascii?Q?y4lEWU11V9Ag0RcJmgQbVxoXh+DUMdyIO2I+atnAzNQNo9wZXRwBjI0733je?=
 =?us-ascii?Q?ttoOSLJAa/BnjPp1oC1y28UEm8wtHIxplwnQR8sfPd/Gj37gMqhnuupzQmhy?=
 =?us-ascii?Q?8BaTUJe76SNMkkIw0UARoOwtK8HSBsQFcSCCms85aCcHlCM0DrJQpkvs+twg?=
 =?us-ascii?Q?iCOYn8LZoL3T4D0QVru+We83nkq5rHh40mQT/HabVNkhap5pSKivM546gA8C?=
 =?us-ascii?Q?zNv3wswOcsDiKI4Vkd5rVItM3/qh5WKwyOoGI5uFoH8aEJZlHWHw/cGK8Tbf?=
 =?us-ascii?Q?vGohqnvfDi2hZ06w4+M2gTt1b9uFbT91feQd+UcKoRpLEoBL/0jqAuP4nO4u?=
 =?us-ascii?Q?8tk+a7vvDgLy4a2gObk9Yp+l4tB6d1yfxVlAEbTTKswvOUPXUxfTzWZXup8Q?=
 =?us-ascii?Q?gmqeW9EKtouT7XCX0fIzU4Kdqzm+jD6uO49xNqTm0z+8sq4XdOOX4gSAbLVq?=
 =?us-ascii?Q?Gux14GQn96sn07De7r7+ODS5HbIsdi8J1v2P7GyKpKcN6pfjCCPvaUQB7bVA?=
 =?us-ascii?Q?Q7r1sNbxrolRYbT86lHbY2n4HHDch348frpMNEtjLQmXEyxyWifcEGvoF9zF?=
 =?us-ascii?Q?MKZubRtf9AtR/rQnTGIzzacDLuEa0/eVBhsShrgot1tfJihTi/5qV5ie05WW?=
 =?us-ascii?Q?sEYGJ7pypSAH2Rjv2Bw435s1cFXIKiaT6FyGIdfl155NbDmo22XlHlHb5N3N?=
 =?us-ascii?Q?AL3+oqTLf6pBtHcOLb4Pvb72VHITizlr+dXdHoN3c/M522vmo+V2Zq2fSf5i?=
 =?us-ascii?Q?GypYdMDR/lxDuFDoXniKYZ/T1hYUcGEW9jn8YMWWjxn/otm6vv2848wL47Ly?=
 =?us-ascii?Q?2jB8oyBs9T1xnpQi23kpdsA5fyuiErHpCwN4ugH0ZAUHIhGVvkOU23sWKQm0?=
 =?us-ascii?Q?GQ0CP15WvrOiVALqJWKeurjkosBq0bO8uKrg1JA4NNmXaHrde5ivywco2mgg?=
 =?us-ascii?Q?2g3r94w+yRFdkflWGbmSsGsAOz9Ix0v8MuwAeBzozFYBaW5xfRNo7Jw3ZDMv?=
 =?us-ascii?Q?W7VAVpsZ0S8N5vEj4tnOr8p/ErLqrhJunzBLw5h1NwU4WMxuD96KTzvYQaVU?=
 =?us-ascii?Q?BMtdRqujhqU1PKleMYwdB1dpXH1Zb9tXBoi65qdq4np3NvghnCjTfTBAlzoe?=
 =?us-ascii?Q?IOEza4ZntK33FwOLweURA2eOMDOkCXOLeBJe3md+04lqiNT9lNcWNPDawQMX?=
 =?us-ascii?Q?rZVua4qYtw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a3618f3-531f-41f9-3c49-08df3df2a31d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB7742.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2026 23:47:23.9128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zVgCVi0N0IjjTmPGGziJgccIyQwsi1WNZ03yyGpKjAh6740k2aTILEBbVGMNHLRKUbj430Lb0yPYBTek+JhmoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7579
X-Stat-Signature: wscdan8qmcg9zwyhnuhbq6jmdtkk6ngw
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: DD179140005
X-HE-Tag: 1794181647-443553
X-HE-Meta: U2FsdGVkX187DuKP+zDr0uCaAqIDw4T5ZcaYz4T4+m3PwmER3ynCjBdCZZPSN/NgzpSLX0SDjGcyj17VW+GJb+zGl+O2NiQbWX7d8U2KLPHE2n9uHK0ZMPLkBRfCz7S2hwBFpGQlcM1OjWtPBkcU4g9RzM7liWQmjpZV1XOwnJO2SiwopukEUcaFvsvpbTBLe8/s9syE6eFtPUkcGozKZYhgGbina+/Cv8QwoRbhVHEoJ7Ku+LY857EqX148TaVfXrb9i8JkjRZniQWKgI0gPwX3/JEoTxmEOW83y26o6dGugOVtovzQLUQvCHvI6EDM1zdkalybrRZ32HmkdS0YiJCQl9e0dw5x82e4I5YJ8DZ6RqLEvchhq/LWA8qmaZ5Lg3olhvT7TvNYqgmrj1SOS2kFlfXrubK9dL+NAi3PdgRqG7xZEHtMGnV2PzryUeyrguf413WS+4LZJ8iCS/RPmuVne2thZOkJWWmTT2K4umlv5f1hxJ7qaCF2iFWvwUE5aDJDSC32hXAPtQIeVM0g3UZnyeoy8le5Ta09mks+n/5gk5J6xhhYOMNbVqXxyR1mJc7ejy6twsal7nDuJeY/wmNDOHP2jFXTWP3UvjSQZQgamUozK1+4Cja07qCWs9jyQF6TXOJB2N+4Fx7/Yqs3M03zZlwCRstdwxULdWFHZVdEUDapc+op77rBOdzvSPNoGjy/o7/1aUnI+DExT5HaieLO0G3mNrQigvvoDgl0xktcIvjAzRMq8I9dQ4qj0zgezXLT6fBtaIkstBfX7IvGjnu4uNPUQccmI9/sc0vMiNk77SrhNyq/g3BVkLhQGAXtN1iYeKN05d/NYxp9CjtHG62Ba1ACqzdbt80+EaKis/TNuHdxuVCw7LBXrrklGZs5ojCTf0RUIEhJONyh6c4QYVoK007fYREH+YzfE1sb90kPT6NKt/MOq2ThZdgkrbDrPMmzR1ustF44uamRyge
 DXYbhhd2
 qWrDdY2fq1CIMC4i9WuhmOZGhUVYCQv5z/Ejg06nEhI2vntMNVcysyAZcnQQI2o2/Sb+9qJJ2GRKwPXH0ZCDy1ztguqy40uXasZ1uZraQ2W9XHnpaquYPYbp9YiAs93PfqBM+UZkpeRHLr6E4raQxogNJJmm6t/9LkXIrOCTowjqbDYQf1KnCOQU2lNzYj/z7tw1VwTuvnbYlcWnsj0ZizVMaMI84bS7b43zcpx5morGKZL0KBMghjORRtWVv8sZdPfpAREDB9KH6Q9AhqtXps048uOBby3eK7dYMbkVpbj/6KI/lbJW/EjLYOPvteB04PtzI0vGBrcCbYsRAEU3r6tEk7Y8pfPzY8DXUGiZu85rzDOfmEnBo0kgzJOcpRLNaLRvZeddQaAtAo/Y2V59fANzm8UA4w+RPvqfqLeU1q89k1zim4U7EKRWf76PmlVGbzsW5HH/gUoQWv10=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

rcu_uaf() passes a false protection condition to
rcu_dereference_protected(), which produces a suspicious-RCU-usage
warning before the intended KASAN failure occurs.

The pointer refers to a fresh allocation that has not been published to
readers. State that protection condition explicitly, leaving the intended
tests intact.

Test:
Built with CONFIG_KASAN_KUNIT_TEST=m
Booted Qemu guest (8 CPUs), ran modprobe kasan_test filtered to kasan.*rcu_uaf*

Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
---
 mm/kasan/kasan_test_c.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index b9e167ed5be3..4e23765d722c 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -967,8 +967,9 @@ static void rcu_uaf(struct kunit *test)
 	ptr = kmalloc_obj(struct kasan_rcu_info);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
+	/* The freshly allocated object has not been published to readers. */
 	global_rcu_ptr = rcu_dereference_protected(
-				(struct kasan_rcu_info __rcu *)ptr, NULL);
+				(struct kasan_rcu_info __rcu *)ptr, true);
 
 	KUNIT_EXPECT_KASAN_FAIL_READ(test,
 			call_rcu(&global_rcu_ptr->rcu, rcu_uaf_reclaim);
-- 
2.54.0


