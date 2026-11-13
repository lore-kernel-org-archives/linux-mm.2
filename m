Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E41D9606A898
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 22:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Td34sA+1
Received: by kanga.kvack.org (Postfix)
	id 0C3F36B05BB; Fri, 13 Nov 2026 17:31:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 075226B05CA; Fri, 13 Nov 2026 17:31:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7E026B05CB; Fri, 13 Nov 2026 17:31:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB6466B05C9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:31:42 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C5DD120294
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:31:42 +0000 (UTC)
X-FDA: 85431544044.12.2C83882
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012029.outbound.protection.outlook.com [40.93.195.29])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6A96A160004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:31:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Td34sA+1;
	spf=pass (imf08.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.195.29 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794609099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2KRenzjE1xjf4l0cSRRqLkhvKtp/c/RjXVsCWzIIH1c=;
	b=bLU52787kwoqN9A9kFkAF0W/GJpSVLAg+SkgmaHvHti6HWeAlbSlo8JeV2vfGQ4DLuJJyw
	OMa21uoIgWmEagKGA7fxToYB0lTLo/1bwaJxXRoZkfUnVQ6ANxZw2Em5+RLCZCK0ydMPPJ
	tPu63TKpEbRH0wjj1jIMbcm4qetenJs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794609099;
	b=O2B9LpHKnKYA7CVSaIhpWd5eZFYVtq+nKX0/IGtwHKy8svB6Wr3Gxg5GZi5ySz+dAdn8pt
	rteSAc3uEtKE2V1OeVlNSPNtUOtIK/wLqk6sZI3gQRz1RJ/0ILWLHV4ycUec7DqKVpAecG
	Qyif4FoTdshMCOBo6Q8gEFWJ2IsJMLQ=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Td34sA+1;
	spf=pass (imf08.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.195.29 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U0eRG2uddsMSHWMCnStqHUKwJMY94kNvdZkl1G+Rjlh6+P8V2K9mfx8hHu1KqqHorl3zdPAgtTVx+UKznmXvgYc6NqmjMV+Wuz8xQs1deRmXrMmbLJjpPe54lfVq1sdHFN8VkyKpJr+mpRgo8mAtnYoRioLi7h5yHxfika9SngdSy/96Ov0JazX9B+7hQEKEtO5jss7KcmbRmHXFqy2K8JBMsBc/rRecleyNi9Thd0QJN0hTSvk1Eu30lHvsxzGjP6Ga55AKYVRgugvD/uY7d+JoI/b/eApZCPmIZJfSLyRuaZ8sgHEcNm1/leQr3edl6gGhhL4yjj7xUVDZZeg+cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2KRenzjE1xjf4l0cSRRqLkhvKtp/c/RjXVsCWzIIH1c=;
 b=Phg55zJQ1xcbA8Ei4e4My9HgjavDqqfui/8OtY9w2YCw1Uy8vswT8uPU3Qi77fDouPHHq90OsGuT4lXnDo/Oka8BRE2/6uyiEefF93A27TLcpo2UZkxiMojVe5QhrawpWhGjGRO/xuhoIDfHC2x4dW6p64o73bZlD/8RSBn2LnNyhwAUXViX1O031veuza6xNVRE+89mYxxseMfXC331LiLjrxNlJtbmu3MH7PGQ/hYlt0wDuEPDstYao8GGICxwQ2aFqJIQkrGWRqVgEwkbkBzG4mslpTEMorpyOvxVcLcaJti8Grasv1Bok9rRfLh80hrjsqveARNUkEBPwru9Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2KRenzjE1xjf4l0cSRRqLkhvKtp/c/RjXVsCWzIIH1c=;
 b=Td34sA+1gmSbmiuTBnz08pfaEQ+uLn/wVT+aTGIwJ4WrYzGXRSeU40a2fJ2T4fChZKyg1UqhOz/vKRKfQHu+UP4+gVYM5VF22zvcV3G0ydEzsNKVj0SzcJ84YFkp3OZ1sE04WFQlNV0ag/Iaj4CZo+PU5BwXYOF1Xph07j8w4fOyxvEYb4OEY1dmv/+Q5a6GGct8zOMejtNF/Dct5GFePs267f0fnM56Gkg8CAHh8oTxmzP0a6FmmeHNBH+47bNG31Hie0b0g5e2Wl0iDBc/5UD6r7u4IDrJU0AuPOxDOoUR5/VGqLQ3/7Ius1VWcSaZTTsvgUXzEUBCpsXY5KZSvw==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by MN6PR12MB8566.namprd12.prod.outlook.com (2603:10b6:208:47c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 22:31:33 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0615.009; Fri, 13 Nov 2026
 22:31:33 +0000
Date: Sat, 14 Nov 2026 09:31:27 +1100
From: Balbir Singh <balbirs@nvidia.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Mark Brown <broonie@kernel.org>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 06/13] mm/migrate_device: don't let go of the fault
 page
Message-ID: <avePdG1ePQhjg5fn@parvat>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
 <20261113-mason-migrate-et-al-fixes-v2-6-50a2ed382b61@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-6-50a2ed382b61@kernel.org>
X-ClientProxiedBy: MEWPR01CA0059.ausprd01.prod.outlook.com
 (2603:10c6:220:1df::8) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|MN6PR12MB8566:EE_
X-MS-Office365-Filtering-Correlation-Id: 334c50e9-6e9b-48de-fe36-08df41d5dedf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|261021123027099003|10067099003|5023799004|11063799006|4143699003|56012099006|261022105027099003|261021121427099003|261026121527099003|261026140227099003|261028144727099003|261022075727099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 Ub/wVqIfrvG27hrWO/BswKHS3TYaQPxo3iO8rK5o+Pnp55god3+sQRWgWkmBXmXYZn/YWF8QhiOh8ek5mgd6QjDix+B5zeuKtNEzSiySfux5FrKIVBbYG3hesnliQgeUhsfmVAchlAbkjGve9CPMiWjoj0X7cvubbmK3xUCznRi1jkgM6kG2ps4XoCL1b6VpqJcf+Ez+SAVrsSFuG6iuGFNxMV0zhjEiBPJVariaTEFIaCjQNqcSd70blcXeebpO+DALb/n79Kl3356a8lb76C/TF0GpBmPTK0HLfsBxHMiifR2u7CNFGSStUokQ9Qa/2THkgVz32l+BHF/TUX+zC/QTyW/aS7FRChF2sb9EcWg6VasOui59rABD2dSwLA8ZrBGhtq4JO8PGkl1LzpKw1QDHO6DcRs4kfdyzwGBvgcfVxiP6gyaXVhd2EF4xEONX+lmKD2FhUCVsUQwg0/C4LrTNChv0GCCUW9r5SNEwYrW3mSNKDkiHB9iq+Dv63cmgzEUSNdxcl87lCGEmLsjPAxsmY9CH+Jg3OecOMOlh/jsT6BI2ZY/4+eWL+yr99lEW1poSHIqAJ1nfdcCmZu82kfL2rYa2xw9vYsaVc+1lQt8+DFO5f7RtuExR4l8mvzB56xyAzJSf9AyuQs7JqwXQBX5f9UKdNcAOz/uw8a89zFA=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(261021123027099003)(10067099003)(5023799004)(11063799006)(4143699003)(56012099006)(261022105027099003)(261021121427099003)(261026121527099003)(261026140227099003)(261028144727099003)(261022075727099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?1ujHwtRJ8La8hZPq/wzGn2F89IAtfEkCqXw8CyOQUJ43Dws3bJdCBMolQ8Wz?=
 =?us-ascii?Q?q2FU+YjsJ4dwJY7cu9dCzUi9Ri5uvQo4XcZ3/Qu8O6yfkiAYqKqJ7NddNBhA?=
 =?us-ascii?Q?Jw9fQbycNKSUkvQcq7PT9TpOPB6QGSZZkYVL62wO/+gTg8EVSLeWbprycuuF?=
 =?us-ascii?Q?3biZ7Li6PQN6XNpmz85bLuw9d0FI//Mv8uW/scoHqmoDaJaa16xGmisSRx8A?=
 =?us-ascii?Q?+AuTX7DiVIAzMAvjc5hoWGsKHvlmr5n0IGxxWg9ugS2pw0ozt8VGrPvuf58L?=
 =?us-ascii?Q?OlNBI8xsWARrMDUDGe1M60TmAsXCKwTrEvAkSEMIzCmG+kguaY13MXpC+CeW?=
 =?us-ascii?Q?rRwWZtdP7GdGDYXX43LNbYSFOVLluMKrOwa4ugKZwcl1sZ3mOD4XTVy6VXX1?=
 =?us-ascii?Q?YQKFRhVVy7MNWD66jgYys/9nJj6Vnld4D4Ejslqgd4Hnw+/oBsS+ARCVsrnY?=
 =?us-ascii?Q?7Bp1ggNbNmi2cNU1gi2t7KIsT4BsQrLyeutA6TGkvl68wDYJ0vbF7JLHSiKq?=
 =?us-ascii?Q?DuLT7N6756e89nYE79rZkoehxfiIC6glDhCg92A5NwyValcCAmUcG5irUUwL?=
 =?us-ascii?Q?HhDua+Bj+jNUPVo/wkPoVObrppvqXBGJSkPY+uiFk5OTWhfzuSlVSenIRkJD?=
 =?us-ascii?Q?Vkjdk4sQV3le3M42ct/F3NQ1jDdLNcYCiWvLwR64i1TENZ35yLkXalZj5x4B?=
 =?us-ascii?Q?u2H35aZRmZPSjIEe79wWcN/2dMcoBlzUmbA64kSxv5MdP2u84ulXKskVk0sY?=
 =?us-ascii?Q?w9CsYhAJSM8MexC5LdX0ExeOpOvd913BH/eff9lAzBxDNAZPNCzKNsI1ea6m?=
 =?us-ascii?Q?29sf3MbjYAQ7R9XHBdwDgaVz2NFL/I2j2edtVlFvJCQcJ1HqcT4PqMziKcWP?=
 =?us-ascii?Q?0gOqkDn42IduFXAvxHjZpuM1em/fJablkRi6YtNWVtxnFOISNbDsqqF4mTst?=
 =?us-ascii?Q?hCMD/BhVbZ7la1lcvVcF1B6ycDo6SEnkl4Fuw0ZSVWM0WDGFc6Q412gPJLn5?=
 =?us-ascii?Q?75ZGE9XjieleU6JnhyLljACCtJcxJV4E0isYrUxfiBYJptbs8EyL63I2I8ne?=
 =?us-ascii?Q?J9MCVQdTGGzVdkGPKxv46Wqe7IvZ9BW4ujEkiFQTtFMsUCutqcrPFm4sTxnC?=
 =?us-ascii?Q?+gwhyW5GdrOrWOGpLZtNTgX2Zr6ZGDTurSXbOC9K430XbdpC6yu7ah8jmQT+?=
 =?us-ascii?Q?0lFCRzqz8D69KehDzVh9Bh2PkdAeUrRmLZB7m/naHgBNnZjQwhnR8+aCCnzY?=
 =?us-ascii?Q?ydJwlya1xOVxx3Tu7eoXHduBqL/8DUKrJpywvRynSNic4CBdAmAwWHg9hXiw?=
 =?us-ascii?Q?0SBpIGpacJEJp6ztbGgGUIEwQ9vUnh/3ife43woxs5Rl3NgAi8a3wW56dyRX?=
 =?us-ascii?Q?EJFuL/me0aS+x8Hfx3xKAAfKoLOSIaZSHlAKqyxDDahbDbpOACmlyw7Qzmtx?=
 =?us-ascii?Q?BinJarBGjZcqD8EDH4PvPyhPhCuVEoFQbHpCmSDRIjdP1267dNIANIJKOkXA?=
 =?us-ascii?Q?NnwhibNdPpaWDg4z3jbRcSlq8Xm2tD+ozsjOxXnKEH1GFtYQ8ggs54WIL0Yi?=
 =?us-ascii?Q?LborgGddLh3X5QX9tueonWPuX5xw5qiShCAsxzrD5ZmTScUABYaMZZCOrBqt?=
 =?us-ascii?Q?P8JxQ4CkbpDyYECqCu++iq5PBC7qvTYCmC5sRJrTJY4VpTBgimROj0odYRYQ?=
 =?us-ascii?Q?THhbthA3fA7alH40JbTXiXo8rQERo7eSB5swX7crrp1dpx7HUP2N8yG1QI5u?=
 =?us-ascii?Q?HArEkqHslw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 334c50e9-6e9b-48de-fe36-08df41d5dedf
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 22:31:33.4325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SGlyPTrneiAxoeBBRZ2VZ68weLCGvvjVS+03hWVHrr6EET5rAqEXkf0dSxTd3UoK9PLEIVihLiwpS1yKeWGeyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8566
X-OriginatorOrg: Nvidia.com
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6A96A160004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 87jes4swzib7zri6g19ohsgkbdkutzip
X-Rspam-User: 
X-HE-Tag: 1794609099-928912
X-HE-Meta: U2FsdGVkX1/hARf1+1ef4ykQL5dZUL7h6eNHA86QOLqbkp3bxLb58owW8hoNTnVFCU2SUCA4BtYaFQOwm3uQ9z1z+XU2UOJSN182GmEdhAcv+tsjul1rLWoy+k5YAL2X7gX6TiqWEAnLDfwZwJSF/BeCoCUkvvjvqE1wVdxu5Yb4YUd0htNWvZTeop4DLeUpZHSh6iQdQN4ELr9S+HGYM3c4oF81DIl802Toejadu1Dj1wwVhiQ6eRLbTbTejmJYmnXlzu4mHtoIPIUQ6xMdeUu3RDxcOWqWpZQFS+omFVwvER0t3TRPEyQ+CmIywDNb2w6c1ctl55JcfVJWdL8w/G5eQvr+jvOQakwye5KhUVv0CS0DxHT8PThP0eVNnsYTWPCF5fnYH6JmyKaUHuVK0AJWo7IklBOX7Qzdr0MGIC5RPjM5/v2TTf2G0t3RIol3HXR+rjR9ZyUBiuHWJ0wEs1fkpcOtv5cy/k6fkepo5ABcyUfFqzbNpfUQdZFhJeCfDlANbGi42lwqTLjXvpqr/qyVuHPmm/8PL4Szb7+qITmDCxss5bYpON6K/TJpr43s7gFC7bCq5Ifu4rqt0zMP8YxC4VnvDaC+fQK+vD7gacex0G5WDrlyuiZePzvDWvIcaV4K3gCb6ZY+meMRBnQxo4gq+IptffoFjUmRnzK/hfVpCcs8XKjB+WdLgoLFAWHlFCIpwfJYvMXOVklZDRInPtngE3STX1V4O9m6fniPTe5Qu9WYHPRSzbCWih/+ALITnwEpWw3+LFzT86HbV88O7DgU07rGZnC7IeEoqZQBCtxK34Tpa60X9IqvU7TejZXYC7e5GBf+ARYa6u7z4Ymb2MbiIKpmdby5Em8W/eLfxAg985/UnCRgiHKL2KeVgxa3NQWUDWNucUj7Qlx/MqNKySoIN6JsSoJ0u60sabO9glnSeaqnx5c7149y3eW/5nI7kK1zHcDLSg8Z+4J+lkn
 cZb+uePm
 swTB9wAHiDILSO+unCcQ+tF6iJGcHc4HmvIJbyqw82DFrLDyFBaQsW8EoeNA+gZbSygGiBmz7o4Rn2CADK2J8+PR8ft+6iUBz9yDqi7VX6I6XOJ+j5B6pnFOITAKyE7cnuFVreQX56o6MYWSD722iNtGFsed8OoX4+I1xhSQFm5jTwHbhnff9xVfHKt+mvXEWlON8Mhtq6buu/kLLkGpkTyk6ylkw0+mCE8hIy+zRlf7nvWeKsqhTfjU6hQlTqUcVpRIoYbxGrPrf3JOxM0V2+tCAV58kVMXYcTfoP7+kxGh8KFk5Rt/MbrG/BiiEHbHrcFwTP6TCep0PmdJWjvM7mWuZA87MmPo2Rid6EBS7ofNM2CiSGntJJYrb8mP+zfKrbO+RlQbs5polzheKcRAQZExVOKzHNUZuWmGUMWsbsw4yrR7/GmA6m9fZVG8hp0Jt3eHZgGqxx1D9KcRUDwc9rYxS0cdZq0rh33ZN4LQR1QpaiDBp1WarKDMWhaj/eMNQyqi8qnrPhP+KeY/XFFpJeo+8NgpSBdjPDPEDrTRKQmWxhmEqqxpHOr5p4g1ZcIsERkkjP8sfFD9xxI+Zs/0aOeq6QpZlLPie1SqlOQ69VXkKuQYdTOCcAu2gXIqL1YtCnNtDkfcgYvfXmH/0csz2IAKJENuwMl3ZyDQGC8tRrT4dkHO/IoWPtybYtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 09:45:24PM +0000, Lorenzo Stoakes (ARM) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> When migrate_vma_split_folio() has split the folio of the fault page,
> the lock and the reference which the fault handler has taken are at the
> former head page.
> 
> It then moves them to the folio which now holds the fault page, by
> taking a reference on and locking that folio, then unlocking and putting
> the former head.
> 
> split_folio() has unlocked the new folio and has dropped its own
> reference on it, so until folio_get() nothing but the page table entry
> holds it.
> 
> Only the mmap lock is held for read, which does not prevent another thread
> from zapping the entry with MADV_DONTNEED.
> 
> If this happens the folio is freed which results in folio_get() taking a
> reference on a free device page, which the driver can hand out again at any
> time.
> 
> In addition, folio_lock() can sleep here with the lock of the head page
> held.
> 
> Utilise split_huge_page() which will leave the lock and reference at the
> fault page correctly.
> 
> Fixes: 022a12deda53 ("mm/migrate_device: handle partially mapped folios during collection")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ ljs: tweaked commit message ]
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/migrate_device.c | 39 ++++++++++-----------------------------
>  1 file changed, 10 insertions(+), 29 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 28ed706109da..ae795fdf36f4 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -87,39 +87,20 @@ static int migrate_vma_split_folio(struct folio *folio,
>  {
>  	int ret;
>  	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
> -	struct folio *new_fault_folio = NULL;
> -
> -	if (folio != fault_folio)
> -		folio_lock(folio);
> -
> -	ret = split_folio(folio);
> -	if (ret) {
> -		if (folio != fault_folio) {
> -			folio_unlock(folio);
> -			folio_put(folio);
> -		}
> -		return ret;
> -	}
> -
> -	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
>  
>  	/*
> -	 * Ensure the lock is held on the correct
> -	 * folio after the split
> +	 * The lock and the reference of the fault handler stay with the
> +	 * folio which holds the fault page after the split.
>  	 */
> -	if (!new_fault_folio) {
> -		folio_unlock(folio);
> -		folio_put(folio);
> -	} else if (folio != new_fault_folio) {
> -		if (new_fault_folio != fault_folio) {
> -			folio_get(new_fault_folio);
> -			folio_lock(new_fault_folio);
> -		}
> -		folio_unlock(folio);
> -		folio_put(folio);
> -	}
> +	if (folio == fault_folio)
> +		return split_huge_page(fault_page);
>  
> -	return 0;
> +	folio_lock(folio);
> +	ret = split_folio(folio);
> +	folio_unlock(folio);
> +	folio_put(folio);
> +
> +	return ret;
>  }
>  
>  /** migrate_vma_collect_huge_pmd - collect THP pages without splitting the
>

Very subtle race

Reviewed-by: Balbir Singh <balbirs@nvidia.com>

