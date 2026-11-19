Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6781C606A336
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 16:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=nn4QsVcq
Received: by kanga.kvack.org (Postfix)
	id 872426B061F; Thu, 19 Nov 2026 11:04:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 824396B063E; Thu, 19 Nov 2026 11:04:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739966B0676; Thu, 19 Nov 2026 11:04:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 41F106B061F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:04:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 551F9A0B97
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:04:57 +0000 (UTC)
X-FDA: 85452342234.28.1A53379
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012022.outbound.protection.outlook.com [40.93.195.22])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7644980009
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:04:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=nn4QsVcq;
	spf=pass (imf02.hostedemail.com: domain of arighi@nvidia.com designates 40.93.195.22 as permitted sender) smtp.mailfrom=arighi@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795104294;
	b=WAzzyya0eHqzS5PhLH+Xp9M/QH99jZ0PNbxSX/FIchzSw168wUgCt2dsziZkY3DfYsdn5P
	efWdbTaCofgwjBUdSODo5ZCpoFci4J8/WV3cnG4RCrbQWmXbVbLAwakAABHcVLSiU3PEi9
	unAL2oOeMN3dcu7tcFNUX+6XD7MC4/A=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795104294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2VwYLXQRF1Oe4BHKGcYS9KbJ7dq3PPmwmcRcBHMWLoY=;
	b=mxBmOHv3nLWD6xhvq+SUDJMXN76sUbFo11Qi6G7Y1M6Mf7Je4eZscJj1egDNGIHwK/sUcm
	WuHJ9CZNlId38ViAi7DH89JrE77tEkTPB/Rbv+pwcqepZLk3ZO+ueCJecYHESYeqeK0hG7
	7Hfz4rS1g+6UAUciYWZsQegkDGl9os4=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=nn4QsVcq;
	spf=pass (imf02.hostedemail.com: domain of arighi@nvidia.com designates 40.93.195.22 as permitted sender) smtp.mailfrom=arighi@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LLigE3C6GCroX5Kv83TMz4Ea3IJpVIT50XVT4q694VsJMgyO6nh9zxuOwsbkNaZ9umap1vfb+uqJY/eC9kA6B3YDf8CH0bei1fXaEAbH9lfuDrXNti6P61D2zT1QZSBYYLOKlk/SDSG1lYJYfJaHsYpNtUw4/ySUENFeEO7QTJSyjNss/Qj/3HOumwbufXAsW/zj5zFhqKvGlk6m5vQrifRTevVJVeSQV+J1rb2cICcy992sanC5u3m/j4ZNUXgTJv/UcO7M09pmjFU5NnkUm+k+LPErZ7BskDsQBy1nIL4DOnLrVo77vcnw6ktMN4H94K4NXhBTznKknf+YQz03QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2VwYLXQRF1Oe4BHKGcYS9KbJ7dq3PPmwmcRcBHMWLoY=;
 b=Avf4Di934LvjQEpbnRcdRmNmN5/kmPoZq99AoUnUk2BTBT5FnlFFXWiPCT+EQSdBL8Qx5CqJdy7tHPvreilbCV81i/aX3tuZCEi0SMszHVEDyiaL+JpCkp9aNZjsAn2bi4ziEd22+aq60xKicgo5raqxal0Eoxfwj+hv89+NSnv2I8FzQQntUS8vyYsuVSO6JjoOs0zBdLpxiJP8r30oFf2/97+k1qmeyIbJXoZ6eRn9P3xfAx9XGFpwMTRoDIQhvuAkSZ7nqCz7oD+gx7cL7vw2p4ee3IFAd2Jy58Fy4CItbGufru8wvShxLT235xhRy+UF64JiO7UYeN/AljfV3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2VwYLXQRF1Oe4BHKGcYS9KbJ7dq3PPmwmcRcBHMWLoY=;
 b=nn4QsVcq+UVF36z3Em8LhHOcsPBojWYy9MT93Bs9vXwrhjQ2cQcaOIqyCWXUaEntm8gsgQGeRIX0qfkjMoxfZ6xoS48ys0JfiPS80ZM9HN0aWeHj+GizcaoEcAUtpQHO+PfOJiRXRCtGiVx6SuDA9qM/1kP+eEqPPNWiDbRBysKBMEVgJcsRO4Oxq20OLAPyD5Dbknbj/CWEiySnt1MTPDN4U0EiA98BmFvjPQFFtoAlCBAOa9thj/THShehB72KnAePzJdvO83UVav5FWKpqk3XAphhSkknSzRPQoFwegaUqULnMF+9FCZcrwYmJ7IQxFGKoddYGEf+PbzU9jbaEA==
Received: from BL1PR12MB5174.namprd12.prod.outlook.com (2603:10b6:208:31c::19)
 by BL3PR12MB6378.namprd12.prod.outlook.com (2603:10b6:208:3b1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Thu, 19 Nov
 2026 16:04:43 +0000
Received: from BL1PR12MB5174.namprd12.prod.outlook.com
 ([fe80::58de:822b:868:96e9]) by BL1PR12MB5174.namprd12.prod.outlook.com
 ([fe80::58de:822b:868:96e9%6]) with mapi id 15.21.0639.010; Thu, 19 Nov 2026
 16:04:43 +0000
From: Andrea Righi <arighi@nvidia.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Quan Liu <qualiu@nvidia.com>,
	Lee Trager <ltrager@nvidia.com>,
	Seth Forshee <sforshee@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/slub: Respect MPOL_BIND when taking remote partial slabs
Date: Thu, 19 Nov 2026 17:04:30 +0100
Message-ID: <20261119160430.1113397-1-arighi@nvidia.com>
X-Mailer: git-send-email 2.56.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MI2PEPF000016AC.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:298:1::4e7) To BL1PR12MB5174.namprd12.prod.outlook.com
 (2603:10b6:208:31c::19)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5174:EE_|BL3PR12MB6378:EE_
X-MS-Office365-Filtering-Correlation-Id: 3495c606-f6d1-418d-3e78-08df4656d2f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|10067099003|11063799006|5023799004|56012099006|261022075727099003|261022105027099003|261021123027099003|261021121427099003|261026121527099003|261026140227099003|261028144727099003|261102123227099003|261009223027099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	aQUaF7sKvUiHZbaec1I2g4rsAcg9SBl3TlIWrF5h1m5As6LBfgXnNj0iPm2OzBetdQMtkjLTZx8jYArbbfFopfyG5d4ptqI7vXfT62yS8Bs//CekzpL3tS6Qmyx5MCyLmovdmlmPn+RaPBxnOVVS0INlj6R30ZyaPEihjkZaklh7zeBTDmJHDHkaG1GPpP7uyM3WdZlcqN+XNDhwsdBs22dxO8mAKbAJssHO6k/P0MePUODG42LRTugZyi9HUP/hP4SSag6HdF9Bd7GOL9JICfFgOIKWwo87XZlaT/T7RUR54W6GSd+KT/psq+U2bxp1N547WnNm24kOzPRQvmTOeEtjFCZudjgKU9bIEgSJrsY6iSh5Fll2PoxBZBM8q3SVRK4YxX5+ZjMQeol+EJ/X9Mvge6f5Boo5rZRBZAGzxmkikljEl11zM1sv20/w5ijIcmBb+SdrjjyyJSq/GVjxZtdUqEYIcJJkuYTNZxfCENL0HfkP83tXTDa7HS7Hr+HLRrC5HeAsi1xe+dzehZJK5qBS7HSaV5qgbPRiaFCS0Et1cbqwrnVUJVKSXbpDVJaAUPDEIr0qR6jZakjpMFLtAqj9pPEbMm3tm9QYydXqFzNXg/A1wUBZaKXCu4uaKm5Eu+yRj5uJkZSGXBkYPKnnMVjazOGvk8ohbyfIJGwpfps=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5174.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(10067099003)(11063799006)(5023799004)(56012099006)(261022075727099003)(261022105027099003)(261021123027099003)(261021121427099003)(261026121527099003)(261026140227099003)(261028144727099003)(261102123227099003)(261009223027099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?e///1obahl0OQb2mRX0ZE9YKGakhDVIAu7Nv7wh+groUGwTIJsmgjqF8Hh8B?=
 =?us-ascii?Q?9Oys2+jUWdqDG30Y/JFSLOIelkTXFCHf5Mpp/ARbGf68bNLXCKpAUxHRLxKP?=
 =?us-ascii?Q?CbMHIW+zlSucI4UypI3Y80YJdqYrtOkehnE/rNBAJLUVFAyl82wpXN/RS27r?=
 =?us-ascii?Q?21OfWPtvA1sFRTBR1j9O9cRZdpyG7NOnMV4lQVmABWCGbImQjITI/fFSfmFV?=
 =?us-ascii?Q?iADcy8YBfRczCmVoM6DVXN/oDy1SNuGH563stbhWd2oy7NpFXX6QkF7tCGYp?=
 =?us-ascii?Q?g6aEoLqHuQbBEGeIX45R8kQ3apZ7h75ChEjRXTRpK0XZpZ1Aw/h6q7UyjuBd?=
 =?us-ascii?Q?Lv7u8yWHSgJ0cAkhhqPLvk0ISGzj4BEcfzk1MkPvhrLW6tNiuM9tahyrY8Gg?=
 =?us-ascii?Q?+zbS+uh2kvXIk98JJnYF+kEMD9sX8Fz3Z2OrBwgC9iWU6jTZMoKLK7aR+TR3?=
 =?us-ascii?Q?+W7MqVv4RwMRjIvV/UI4Lf+b0n+aMEVe76EfFLnDpr7yDQPJ0pLLk3jU6SCh?=
 =?us-ascii?Q?D6jWCZvgnrUFxx1AN3BonueRBcc8lPKmkXxYisYr+YqrbokK9GTFV8UosKil?=
 =?us-ascii?Q?0CsvWzd2ejmHAzLfAUi+fS9ujkb5ybRr6/LEJNzJrWt+xxzH0TBNpHn6xwnx?=
 =?us-ascii?Q?qCwd6cUzvx6LLrbfJdsSLirIubT1X12/H0H5tXdvxexSROGRKEMn4JqOo2x8?=
 =?us-ascii?Q?vQ7t7qkZlFt8byMxIB43y9JET1y0XRyYoq+V/grT0YkkO6KGkt/5076S/7av?=
 =?us-ascii?Q?iqwVua14ZLmLq7N84RJtSCpGcHa3MqOMQ0VcbusLQx1QshlhfAk4hZHE9e/W?=
 =?us-ascii?Q?MCXuvfWvDdJh4kXbsEuzE2NYpp29IK3yakKjA9+g/z5ZV2soZrmmffD5pSK4?=
 =?us-ascii?Q?Db2AiYN+IfCg7UfD9wws9t0OO3qseURyC4XrNqzzeaS99JrYuZGMPcYkRUNn?=
 =?us-ascii?Q?Nt08iDL8Jr8QfnzPP+AyplPRL3WLHKNM/rrVBH/c6zf6uQo0fO/tk210iSag?=
 =?us-ascii?Q?lRd48ULMKImyf7wwf90R7DgNoAkRLysnUdu7YEfWv4T+in5Ie4WbdHmZdHtQ?=
 =?us-ascii?Q?LAGJgI7vvxIautJAyDFNbAygZ8LAbmInEujUoqe/B4c0UoWQohvKWWdy3Bsw?=
 =?us-ascii?Q?CWRVytUZatokrslizCBvsfHs89kA9EHqjr3LhF5r8dT/Og+omh9Ec2rm9glD?=
 =?us-ascii?Q?FPE4VYC/IbBkXa3bJf7589Qr0LP+iwNRrrkFUjWDnNTlN9x9RoTpMiKlBxOc?=
 =?us-ascii?Q?72d2ocZv3ti6lAW19gxO7jMPw0coWLQGaJN1fQABT6K/oZ0PwhRnYNlkgDRv?=
 =?us-ascii?Q?YUu/OuA3mN+kQn9XuhPGWtJxpt1Ze4DcRiiVV2AtSr+qWdbYw2WiMxskcWCz?=
 =?us-ascii?Q?CUxo1V7FZXFMxmB1GHozPapaZtrq5e79TcCdRBy0pUmfvKJb/62Mafg83vgD?=
 =?us-ascii?Q?3PQismTzTzeJglyXpImQO/iyNiIwIRcBx3mOWgjuqg0D3SQEo6a2138VMFsd?=
 =?us-ascii?Q?ITyhFAmWwM/YS7F4qa1HfKmj3T7v80E3Odbytv1aHOV5L2C4lM9yLLMFOrKE?=
 =?us-ascii?Q?2Qjg7DDkFa0AN5+/aWDEFoB+44SBSdUHmxO5xvObwEqGbGNxtAvcO6wOiOjK?=
 =?us-ascii?Q?SJNtgHcIUnhQYKNqttMqC4VW6SaJOJ1kRmL6ueXv9iDLhs5MndlMuWIxlZ/S?=
 =?us-ascii?Q?tkdUgd/OvgSwberCrgkkrkXEl7520BINQbfqxaxAUb7uDJLyr4oYM2hpqMRZ?=
 =?us-ascii?Q?IKauwm+Shw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3495c606-f6d1-418d-3e78-08df4656d2f1
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5174.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 16:04:43.2109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ZVVBBLP2JtB2KnKjkrvMZL20MOwJojBOgNGwuSDzCfhJfiUPNRzk7bkLq++C1t0Ci5ULW2gmsErPFSDSVdjJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6378
X-Stat-Signature: 7b4teytwemqyzmhmy6enby7raoirhn1f
X-Rspamd-Queue-Id: 7644980009
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795104294-235728
X-HE-Meta: U2FsdGVkX185wE51/YT4eSYaNT4gQwnHIF/jBxaGrFLMCWiWLZaoljKirccuy2b5Sc0GrpC8fnQHlGUQwruDbvND2MrFhM4vliTxd1aoRlJWPxJjYm49Lr2mD/y57nAQ3Wi+dIHAh7KGkVHTqe2LeiUbyZ8Wq2B8xLbKwtOrwDRsPqB9GMaTta+RatOfdnuMQqaB/Idt0rDO9Q/tEeIVQAwpkEEXYh3o5qsyzttpsF6OVwz5KkRXTX2y6h1o8mfM58Y2sOZ7veovhTZydfQGkvaXspBHXK3snBB4ZW6q0R/06U8DbXgTy0IRubW6+W0Kp8ukzRpCSbI9DuVgiPY/Jrr5Ktpf6U2vRy0zOabye7O4DRrhxT+QJ8Q60rPTx+oVg7diciK2dfm77SwKF5rj5ey0G7a4EDkOQ0Yc3iYGEe3/nXKwsvEfj62uwH3P5+apO6wm2h7UHtT3xPVrCHd6dxatU68VBji9FbKzOGJPKNwcte8n8v/fzL5QkuseZ9mWnOHJaaov3NUsxLaFbX07OtFG3vYY4EGi4cqLtAIRSLS4P5M3zZVL7TwKYNUkO90dJZLmlt8x4lRzA3syQuSw8FFOUW3fi9mRWCMt8wJtEUQO2+qmITy9sE3B5Ws8iZ096DZ+IN6dDxLKsQONE9FfGrhHUtjlM7KLPxHeT7blINDCdZ/dUJyHRIev5y0di8qgTW1p+LOn3gYmEklVyWkgqDSc0yNj2FP9K8kFWIJgrAwlBApf7yJ8nDaciQ7Sm5BQZ8oA7dj20WXYeHOSPOKVEZoxvTLt/Q242DJDeCwlJH2TteAH2kwpSQDuSj91xrRfBk7XROLRT82pR6NLiEzXQtk/w8vP08OwwirVt4IcampuKod9VPY5taKOcTgbX/8wNJ8wR0QWP8h4HZsRRb2CVaObqXf2tiZPd4wbc7s5qdq3PJiWMA2k4X6pztVmdM0/CY6yNF2d4g2T2LV6CrK
 86IdHoPl
 N3YZjMrCAKVhbw6ej1VH6OJFhrp0RHGoYavgl8VIF087zz6nq/QJQ66g9gl+yNlIjJ0bCs+KflbLIAIrnuCQZDAzmGFmKcCn9ZmEZT4NLhGZW9bN6PFjFrbXvTIUi9LwSwQ3OVRPrnHe5Uv7ABRssoTWyGRDX+lc0n/6UR6XBF5BY9WNkx7H/56L89MNqrCVOk1ZfB5qFbxjQVtHcH0Q+aqvTyaoBy6avT8IH37br727vIlXc5vO9+g/q72XYN+c0PGJUeaMYbU57mNUiY80fcBXkrATU5/qXLgqczgZ1ZOFSkX7c9gkztIhHEFdpUT2zJzgsgDvtwklvKuMbLkF9qyioTW2zxqpjVW5Hn7bBAzeYuo5/lcfIA5sxuoivZhclbTfaSB3VAD1unXAh+YXjhICKfDltFme+5JcPBaO3l1uV9LwlE5NInvbJg+ojEciQ8eFTaZVhiunQ3tsIOL+zMhHni598uLGdLX7QDncq92O4lMoLUjWhWN1ONVYb90LdH11okvW9NdBQ72A/OvGeGRqd2rrME/+Ay5iRUYPgwdVYghsWKVxyGyCSv0Jv074T6i/+kDGo0A01+4maBzHaYt5M8d/DgQlT9d3Md1Tiy9wbnQ4hxH3r3lny4KUQHqWK8X3ZwGVvEwGaWpy52TJCvIFgrKmoCA9VoMYF5U8K0I5i5/kCqvZKji88hcughepJsNpomXTOoomhXqPgZYvdQERtvNY9Kkh6FxgZ0lSTvnnwVz6jbYi0D/hJb1KNC55thy5O9wceXOo9vKQQ8DrtM0guFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When the local node has no partial slabs, get_from_any_partial() and
__refill_objects_any() take partial slabs from other nodes. The scan
only checks cpuset_zone_allowed(), not the task's mempolicy, so a task
bound to a node with MPOL_BIND can get objects from nodes outside its
policy, even though new slabs for it are allocated on the allowed nodes.

slab_strict_numa doesn't help here: when the local node is in the bind
mask, apply_strict_numa_policy() leaves the node as NUMA_NO_NODE and the
allocation takes the same path.

Add mempolicy_slab_nodemask(), which returns the MPOL_BIND nodemask, and
use it to restrict the remote partial scan. The nodemask is used only
when the page allocator would also apply it to new slabs: the allocation
is not for an explicit node, not __GFP_THISNODE, not in interrupt
context or with BH disabled, spinning is allowed, the cache's zone is
subject to the policy and the nodemask is valid for the task's cpuset.

Sheaf refills allocate new slabs on the local node, so for them the
local node must also be in the nodemask. Otherwise new slabs can come
from any node anyway, and skipping remote partial slabs would only grow
the cache (e.g., a task bound to a node with only ZONE_MOVABLE memory,
or a GFP_DMA cache). Skipping it when spinning is not allowed also keeps
kmalloc_nolock() from reading current->mems_allowed_seq. Other policies
and tasks without a policy are not affected.

This was originally reported as a ~30% hackbench regression that turned
out to depend on the slab state of each boot. On a dual-socket NVIDIA
Vera system (node 0: CPUs 0-87, node 1: CPUs 88-175), running right
after boot without touching the slab caches:

  $ numactl --physcpubind=0-87 --membind=0 \
      hackbench -P -p -g 10 -f 20 -s 100 -l 100000

                avg (5 runs)   remote pipe buffer arrays
  before        7.021s         160 / 1010
  after         5.222s           5 / 1010

To make it deterministic, the slab state can be seeded before each run
by holding ~4K pipes created on a node 0 CPU (no partial slabs left on
node 0), then creating 1K pipes on a node 1 CPU and closing 7 out of 8
of them (sparse partial slabs on node 1). With seeding and the same
hackbench command:

                avg (10 runs)  remote pipe buffer arrays
  before        9.885s         1682 / 2020
  after         5.114s            0 / 2020

With --membind=0,1, --interleave=0,1, --preferred=0 or no policy,
nothing changes (within noise), as expected.

Reported-by: Quan Liu <qualiu@nvidia.com>
Link: https://lore.kernel.org/all/20261110065219.894219-1-arighi@nvidia.com/
Suggested-by: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrea Righi <arighi@nvidia.com>
---
Changes in v2:
 - Replace the pipe-specific kmalloc_node() approach with a generic fix
   in SLUB: restrict the remote partial scan to the MPOL_BIND nodemask
   (Vlastimil Babka)
 - Link to v1:
   https://lore.kernel.org/r/20261110065219.894219-1-arighi@nvidia.com

 include/linux/mempolicy.h |  1 +
 mm/mempolicy.c            | 24 ++++++++++++++++++++++++
 mm/slub.c                 | 25 +++++++++++++++++++++----
 3 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 65c732d440d2f..129ae718c75b0 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -147,6 +147,7 @@ extern bool init_nodemask_of_mempolicy(nodemask_t *mask);
 extern bool mempolicy_in_oom_domain(struct task_struct *tsk,
 				const nodemask_t *mask);
 extern unsigned int mempolicy_slab_node(void);
+extern nodemask_t *mempolicy_slab_nodemask(gfp_t gfp);
 
 extern enum zone_type policy_zone;
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index c7d4d149c9b88..8b29be7ee246c 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2198,6 +2198,30 @@ unsigned int mempolicy_slab_node(void)
 	}
 }
 
+/*
+ * Return the nodes the task's MPOL_BIND policy restricts new slabs allocated
+ * with @gfp to, or NULL if they are not restricted. This follows the checks
+ * of alloc_frozen_pages_noprof() and policy_nodemask(), so that the nodes
+ * are returned only if the page allocator would also apply them.
+ */
+nodemask_t *mempolicy_slab_nodemask(gfp_t gfp)
+{
+	struct mempolicy *policy;
+
+	if (in_interrupt() || (gfp & __GFP_THISNODE))
+		return NULL;
+
+	policy = current->mempolicy;
+	if (!policy || policy->mode != MPOL_BIND)
+		return NULL;
+
+	if (!apply_policy_zone(policy, gfp_zone(current_gfp_context(gfp))) ||
+	    !cpuset_nodemask_valid_mems_allowed(&policy->nodes))
+		return NULL;
+
+	return &policy->nodes;
+}
+
 static unsigned int weighted_interleave_nid(struct mempolicy *pol, pgoff_t ilx)
 {
 	struct weighted_interleave_state *state;
diff --git a/mm/slub.c b/mm/slub.c
index cd671b9347191..1177d76a1cb90 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3984,11 +3984,12 @@ static void *get_from_partial_node(struct kmem_cache *s,
 /*
  * Get an object from somewhere. Search in increasing NUMA distances.
  */
-static void *get_from_any_partial(struct kmem_cache *s, gfp_t gfp_flags,
+static void *get_from_any_partial(struct kmem_cache *s, int node, gfp_t gfp_flags,
 				  const struct slab_alloc_context *ac)
 {
 #ifdef CONFIG_NUMA
 	struct zonelist *zonelist;
+	nodemask_t *nodemask = NULL;
 	struct zoneref *z;
 	struct zone *zone;
 	enum zone_type highest_zoneidx = gfp_zone(gfp_flags);
@@ -4027,8 +4028,19 @@ static void *get_from_any_partial(struct kmem_cache *s, gfp_t gfp_flags,
 		if (allow_spin)
 			cpuset_mems_cookie = read_mems_allowed_begin();
 
+		/*
+		 * Restrict the scan to the nodes of the task's MPOL_BIND
+		 * policy, but only when new slabs are also allocated from
+		 * them. With an explicit node or when spinning is not allowed,
+		 * new slabs ignore the mempolicy. The latter case must also
+		 * avoid mempolicy_slab_nodemask(), which reads
+		 * current->mems_allowed_seq.
+		 */
+		if (allow_spin && node == NUMA_NO_NODE)
+			nodemask = mempolicy_slab_nodemask(gfp_flags | s->allocflags);
+
 		zonelist = node_zonelist(mempolicy_slab_node(), gfp_flags);
-		for_each_zone_zonelist(zone, z, zonelist, highest_zoneidx) {
+		for_each_zone_zonelist_nodemask(zone, z, zonelist, highest_zoneidx, nodemask) {
 			struct kmem_cache_node *n;
 
 			n = get_node(s, zone_to_nid(zone));
@@ -4072,7 +4084,7 @@ static void *get_from_partial(struct kmem_cache *s, int node, gfp_t flags,
 	if (object || (node != NUMA_NO_NODE && (flags & __GFP_THISNODE)))
 		return object;
 
-	return get_from_any_partial(s, flags, ac);
+	return get_from_any_partial(s, node, flags, ac);
 }
 
 static bool has_pcs_used(int cpu, struct kmem_cache *s)
@@ -7461,6 +7473,7 @@ __refill_objects_any(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min
 		     unsigned int max)
 {
 	struct zonelist *zonelist;
+	nodemask_t *nodemask;
 	struct zoneref *z;
 	struct zone *zone;
 	enum zone_type highest_zoneidx = gfp_zone(gfp);
@@ -7474,8 +7487,12 @@ __refill_objects_any(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min
 
 	do {
 		cpuset_mems_cookie = read_mems_allowed_begin();
+		nodemask = mempolicy_slab_nodemask(gfp | s->allocflags);
+		/* new slabs for the refill are allocated on the local node */
+		if (nodemask && !node_isset(numa_mem_id(), *nodemask))
+			nodemask = NULL;
 		zonelist = node_zonelist(mempolicy_slab_node(), gfp);
-		for_each_zone_zonelist(zone, z, zonelist, highest_zoneidx) {
+		for_each_zone_zonelist_nodemask(zone, z, zonelist, highest_zoneidx, nodemask) {
 			struct kmem_cache_node *n;
 			unsigned int r;
 
-- 
2.56.1


