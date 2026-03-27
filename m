Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6A1B10AB83B
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 01:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 292936B0092; Thu, 26 Mar 2026 21:43:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2436F6B0093; Thu, 26 Mar 2026 21:43:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 158DA6B0095; Thu, 26 Mar 2026 21:43:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0715D6B0092
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:43:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AA2F71B951F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:43:22 +0000 (UTC)
X-FDA: 84590145444.28.1BE4D16
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013005.outbound.protection.outlook.com [40.93.196.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id E62D51A0002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:43:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fVU5uYis;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.5 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774575800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VTkf814KTbAKcjKFZWTyPVHXuunVLktqolPhScWqans=;
	b=7lF05PI39rYyBBRexmcZnA1VGlC1u01TpKNu7l9YahnCh7m3dc3f5ovdbbTtE5+DkaXnVP
	yEHfoI/kcjuRf6X1uvysSMiMLfoD4LC8TCB3rmSOcRxfg3J5I0EbYdM/KViU9VfTHaP4HL
	6xfkLD810KLBAdRMs/ATHeqvtMS6y9c=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774575800; a=rsa-sha256;
	cv=pass;
	b=DFodq0N/rE+C/8hp9zQI73AUoOCzbvE8fFeDezc++47jISC2m/HB3Estg7iNX38qWMEpKH
	8rBTFuSoqwvFUyhCu94Z/Bm12p5nqSkqtD9frpgo0Rk2zGEfKuFPQr9R9ucu2knWS143qb
	vWwD+HKNLP7pigrfycFV0w8QyCgiKe4=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fVU5uYis;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.5 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OCVQTQUWHTMAlAmqdaGwisfw9djlyqKYpf8MI6BULPMpsXuhncUfnDOJ3Dt9IAM1PYmNhOKBVYQdFEbTiRTxK4Yq1Gp5PjqA+YpS4wrHFCcHRUNW3O/3lfbayptL1WcNadQTcoL+pOmRYQtcRTyl7pg4vgspFCEwAJREz/+mCt2plBigTPXunkyV4jcAxu2OHNAUhSG2LqRRfG6TG3ztu06y7PHzZS3RD/CTWwD28YxHKfyr7eecGa+1lTa/annXxPWUEmq4H/XrIq3elm10rwRhA4E0Bm/dfltm/6hwiidqGgrEiQDZLUaOR8Y+vUtmzGu+09hrju9sTXV8CVvICA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VTkf814KTbAKcjKFZWTyPVHXuunVLktqolPhScWqans=;
 b=LyweZxSpTdyuhrEzbVpzRedWhn4u0RRF5ABWNTeJyyNQ1zrOqJ8BS/JO3CkOS74jc8bjVgq8voYqNjKspm4UjrzeRpfLyrdKEjBIEdCBgo9ZG6ff4YsP7/Gp3Xm/XmQV0ndoE2m/d4wIHExKUAyVitaMTgpoRbnWIRasHbrHjcgTiNfg3uPmhzAYzNLlonQOON5B4SKTq0Nt7w5hz+gFpxfTX895Tr5loC655sqZRi5550di+J3iGDJGpBAVc6QexcOCCq4259vjRAu2oGwhwcqyH6DVFa4irdpuPgsGi4aknp7FMmo8lAsHJcD2cm/yZZ+SH267QuImFjq/ByLFEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VTkf814KTbAKcjKFZWTyPVHXuunVLktqolPhScWqans=;
 b=fVU5uYis0tgO6m8A5lItYEDdqkjMA1LAdS/+abWvxjP2JIV0THGjJVY+sfFUTv820Xj8ccFtneBG+n1K+aBo8dSCPKBccQKabG49eiz/NnmjQ3KoqWNow5SV9EJxcu9pQ/CebJYIkSYrWFzKwGCqUAc85iOlH6WhSo72lvhYT2pvMukD8XZe5607jYlvzDXsVnkhBQVTV0PgEHO1MZpBC2G1KBobpgGz3KzGqiPAzjFlzMtUKAXj+0pWWy8GySHq3c8EBeGOg5IxDj5asus/bW2RPKxbarZhQ2e4Jp+DKNvBW+AQVnBCejoD5fFdU8JcWwFVoGr1JepKQM4Sjr+ESg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV8PR12MB9264.namprd12.prod.outlook.com (2603:10b6:408:1e8::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Fri, 27 Mar 2026 01:43:07 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 01:43:07 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v1 02/10] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Thu, 26 Mar 2026 21:42:47 -0400
Message-ID: <20260327014255.2058916-3-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260327014255.2058916-1-ziy@nvidia.com>
References: <20260327014255.2058916-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:208:32d::10) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV8PR12MB9264:EE_
X-MS-Office365-Filtering-Correlation-Id: 1295896f-2a72-4475-4af3-08de8ba231db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	aFWIFoREAFsHe3Mh5Op4FfCsSya7bnZgI0V5NkttdZRFUEVvyESmLGW7ZZLlp3g0wJrq2cTRNipO+aA9bEtYfdqoCL3fKHghGNrKK0TJgCZzL4CJsozSdwEduzRlATNt5/evKNQ348d5YaV+R8o8hXCHsCA7zW1WZI0xm7xHU9XyCNymCJs80ooKSwq9be0C2iZ/ez9m/yvm2+Dq2Apbsnw9G/mIDeMDqMl6CTt7Zbn9U/LYUYAL0s+BL/0tsLvqCiIw9f+oGHfuFYM/a8AupPbxKXq4dF2RcSbFAsEU6jZ1Ol+9EbygsVDCb5sySBPXTJ75JQNfMPsVfc5DRzdtifvAk2ZuwZkFH6p0vO58Qem4wxymQb6XKFhIfd+TiM4QQRXC7NrlmD5CcC8KDIPhf1hdQaxCoypmbhFgzPqGmgJIVtObR1sHzTepdLHWrv/aMnCVU8K7y7DVffZlfEAWvLxlcBg4uI3WGdx72m7q5vy2vym7reSAEZY7QSr7pbi83SW73easvsHG+VxR7nXzcXU8/558pD1Gw1iIhOA7SLvtN/Y66SfdZLGgfT4dpYzddFasE+CsZ4rF2hkUlUwaGwxmHcdvgBXdy4LWQfEJ0YQhTnyewt7cTOOdQdBDDZsPelB/fNo/P9KtH319yHM5zEu0E7APSWl0hMTPdJlLod/YiyrxLVksAgPqw09mzsD/CSeqWIkAMxHHfX1Q31qbuOES6f0J0cbdYN2VXYibEj0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VB+bMButzeP96eFyZ/yipb75SGm3QoVOuYDolVoPiyXDK4qUfFB8j7ZGixJp?=
 =?us-ascii?Q?5huDoXY8sWzBTNoDO0sCuWL061hOmzlU5D/7R9yh9715dT7bG3JENwOc2vEt?=
 =?us-ascii?Q?dhF3nZNSUJKGd3fsJ7R5bao05hb9Uy9nikD7dBmRMUinAXDZp7pZcgTSmW4K?=
 =?us-ascii?Q?PPNnXmqfTe+ktNagmaioU/vFBDMjjdPRRKw/W1+Kknhpn7jnph12bdx7RvPh?=
 =?us-ascii?Q?9G+Q3wlRzn5hUgl+eXT1vJw6cVC5rpF8jH8r95d+7X7BhInkHKb4N+lJ1m/Q?=
 =?us-ascii?Q?FwshJdmn/UZMvOUHamJfiRAe0u73y9RHuhcqY5W11Z8YwH8x9VYvCdHoyVon?=
 =?us-ascii?Q?tFcXC9VxgVmTv2qDB5E3N0fJTmTPIrNNg+077wWZWnHL0XHl2x/5AkMn6f9a?=
 =?us-ascii?Q?Sb2TSyAd+W//xXvPzV4Zg9MvCJWARZ8HlHghNJVm0MVKapOAGDIvTpTJpIGc?=
 =?us-ascii?Q?BuaBrRQz1p7MeLL/RJU3nk6D5gYADWzNGLKfydbtwp4jAvXioF6Voy1eo2oA?=
 =?us-ascii?Q?hKq5ZFGLv2uVrVuZQB052X5CM2YZGZQ/neJbzLfYihe79k/NLMqDM5WoHWgx?=
 =?us-ascii?Q?H3P0LpPvILDrR1sSxdQrIHI/REfk5TV6fItIimYd/GcJvNTRWLoyNQML7PQO?=
 =?us-ascii?Q?HGC/HveN9782wDtL9/rbBDHvqb/zdUVBLwD77GeCQFsjLsixC114nA0RTZGB?=
 =?us-ascii?Q?aT8fJ7dJFLXpGQwBJsxTuV8KO/YMhtDMkvRayvAcAcI7vYdv7mmnWIPgR/9K?=
 =?us-ascii?Q?+Z5m6Xt2u1rK+JaFEe6xnn8rZMRzQj4v2NbuSS49haeIIiSYeaEeld65RMo2?=
 =?us-ascii?Q?i3n1UsnQf4NTn/irM8uE2CWBFtMHpsdwk/qHEbYTdNlpxVCqczONwoNmRVGO?=
 =?us-ascii?Q?WyMYgQK5EcdvbnEkZaTwwJ1xBuxrwbRBJ36Cl7zDDL8LG4/lQaDxYUZW9ZEq?=
 =?us-ascii?Q?1T+xwfTE0QU5Z8WwR+0ofPMASVe5u98St+J79G0u3hLEqyeRq2MxmtaxlJww?=
 =?us-ascii?Q?je2dl0gAvhYm0FCNFFRUFpPtTQppeck8ksjkGUCW9upkg0yJgIjwTvOOtM+S?=
 =?us-ascii?Q?Xq+v0+E6SSDUqEjva5JQ1BT6ggIVfjtz1toDSCLhVyxE+LvFG5ZCR3TCNfv2?=
 =?us-ascii?Q?ZqOBQ4I6/eooLWTfl/yGcmBnOrFL80yyXtQSoXEl1ObPESF6zktoiCedOm7x?=
 =?us-ascii?Q?vvEPYzjA+XbPjKKwq3OF0BBKboXa3DOMVA+na0pzI/u9tP+CT1HWSNZc00Mh?=
 =?us-ascii?Q?uEC8xp6PyiW419GUh9X06+Pth+SI9xmSyxOtMpPB2Tb6AK+z8hOAWlNi1lYI?=
 =?us-ascii?Q?leY+2ZvC2ytJWKnP26ISMZaiDq1ZIDmL9E4JiuurdSXQqYZsOqVV+qXbse+E?=
 =?us-ascii?Q?Zk4yAVsCRmCJSO2r5yssu8ZVMxijgA8Ta/dzO2DJYSWOR+8XQGC9BbTFirjK?=
 =?us-ascii?Q?iZP8WeK6EgPDDodL/pt+6Q+BykZ/lgP+MRQFwnwIcvDmVRLphvk1Bgy2qAZ4?=
 =?us-ascii?Q?Zj3GY++snROxi5z8HOCw32zctJ/w+dKpCN71enS5cky0Hs7NKqZiQvTf4A5u?=
 =?us-ascii?Q?oiui+grgtFNsz8872p+TPHMTyr34MShhENwHaOV1Ltd8ubQCvdKWnJ0Z+r15?=
 =?us-ascii?Q?QAptaCn1YB3owbdc5HRS4BY4470q6F2AyvwdPcxjuuN+kiRl2aTE8Sk5VjFO?=
 =?us-ascii?Q?/CbpK3lKAFmGNoHlHOKBc5FuMugrzZkmfXwvw+N3KoIDBiyW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1295896f-2a72-4475-4af3-08de8ba231db
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 01:43:07.1441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a/UC/5UyBF+vZhMvAvc7H1vkVXiXfnJDquLPnp8mSovCizdtBbzDU+dryFKdYIH2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9264
X-Rspamd-Queue-Id: E62D51A0002
X-Stat-Signature: uzd7yq97bucjhpk5dc8oqeji6uoasnb7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774575799-703760
X-HE-Meta: U2FsdGVkX1+AI5Ovep9fHpdS7P8CBIwVJ5E8PtGuekLML1AuHMJLJCKzWG7Xv0zZkYQF+VpneQ4tDNUihFYKEzfDrBtQagZzNvYxSeLJ0K6zXADQmX5gc4CgdA2X4U5zdQN+HLCzrzmZBS+0VxsDJ1kCz1XStkSq4ueE4VnFwE0kXSWdkIrQybgc+1bknWfMLg+CgtvsleLNd5lJ4+8lYBbjWIigCIQp1ref7EytNzQ+KUoWKPJx7fmOjeyA++n3WXwhHnVX9Vnwa6jKAVSiVv3pw6MqYivTMZU6cbmkGtVqTGLj/4FIMq0Nlww3/+a1Y6FkhsSEFVH8fLAV35OB/ZBk4wB1PdWo51sK3fuvx6ZSZHYHLCUvfgjfFm5oAKd6uY1gfUcBtRrYc+7mT0d3rpJ/C2Mf6+xv/agywwpgkLqW7HiyZywZObeWoGAMmjAgiio2eiHVJ/TuJkoV6eNrj1a7EvMk4ts/0Rml0x1u2j6RDnZ+L5U56Av11rqaXG3SKHEOV4eW1ps4oAI913vMbmN96/O48dhcVuh1x4H1HiOolze240urhwTtOSJIxA0GhEh9fYACpsDoLMdn9666TVg6nrIpD4pH4xXGaeduNMShcRVAHSBrkV5qX5a9KqnCoKvQrCbKlpof6Whx0FBGi2dMauR67R+2IJZOgXWZ2ftKXnlvX3Vnpg8vZjU0HdvNBjgV+iajyUMG9tlPZ5Q9QTWV3p6soebxOL9wduzrdm4rSZADuCjSHvVoDB0H/DYlU6FpBH+Ez25iIMlCok5KEDbYvNmq8AaXfV2NWmZDkVob3AuUj+knU8Hi6ISk9uJgfl/dzm8Gsw44eLrj4e3dhwYoU3R13iLacpb0u3SEGevveDMkAYfmh44bKP53h/hRdfgAukFB0Ddf0GXd7Y99359Na6CiQ4MsWvBlnFZtyC/iqpuSbI+BwI0TKDgxz09in1D8hM7LjRpTCgyzleg
 ugTupbFG
 xdMAXvraQFwb6jQLmC7OHIbgc4Ocbo3/59R83NIivZQXfaa3WQ4ezedmgFa3hTs/u5vqCNlCAzpW/S0/Vj9e+x4DwavL1Kh43gABL5HuByhs20cr3ea4PbCLrlJOfCmhxxWMRlo1RqVx2NxQRzisdtLBt1zBeFa9yg3SDPN0Q3WckhmXJZ8+48qWpiC/3Uol5VQ0q7uuGzyn2bplTAsuTctCzuTkxcIC1kF/2DyHEfu9Z/wXpintb+J0x1QaWTUfHRllAIUDk7egxKruoLp8ToTBoyWC5OnFbInEZwPuCzy3vt3/nSz3uYAbpZtV8jt7xy7LtYQZh1W+zEVkoiFjdh/k7d8SXj7GbC1Np0/+DciUzkah9eLhl6GFsWCJ59tRiIgqOONUB8XnPszU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

collapse_file() requires FSes supporting large folio with at least
PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem with
huge option turned on also sets large folio order on mapping, so the check
also applies to shmem.

While at it, replace VM_BUG_ON with returning failure values.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/khugepaged.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d06d84219e1b..45b12ffb1550 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1899,8 +1899,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	int nr_none = 0;
 	bool is_shmem = shmem_file(file);
 
-	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
-	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
+	/* "huge" shmem sets mapping folio order and passes the check below */
+	if (mapping_max_folio_order(mapping) < PMD_ORDER)
+		return SCAN_FAIL;
+	if (start & (HPAGE_PMD_NR - 1))
+		return SCAN_ADDRESS_RANGE;
 
 	result = alloc_charge_folio(&new_folio, mm, cc);
 	if (result != SCAN_SUCCEED)
-- 
2.43.0


