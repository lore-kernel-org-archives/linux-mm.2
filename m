Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB342606A33F
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 05:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=R/JRYwop
Received: by kanga.kvack.org (Postfix)
	id 7978C6B00EF; Sat, 14 Nov 2026 00:09:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7489C6B05B0; Sat, 14 Nov 2026 00:09:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 610996B05B1; Sat, 14 Nov 2026 00:09:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 30DC96B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:09:33 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2ABF6C02A0
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 05:09:32 +0000 (UTC)
X-FDA: 85432546584.26.1545752
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012042.outbound.protection.outlook.com [52.101.43.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5F777120004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 05:09:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="R/JRYwop";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.43.42 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794632969;
	b=wVJJq6xgvGSlwRpwmBUovZxXDRLuw9c645BaoZGyZsaMglDNZy+gq16I0cKFfDYDQ25njr
	BCuXgQMl3w2NcBC0iQUukJm4cfNg35MEoN9xixIipoiqI9t3uOjgONE4hyiKv8PmRg37E3
	zWLkZdNcctQftIPbpIwrIQsyEnFaEFc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794632969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kXU3btpdlVAqrk+XU3KVn0INEYxWt2dxRyJSuiFm0dk=;
	b=dZsCM1EPByzufyo1Y2oVG6j2eKA8NAVcNXqtjkMXULW0aTaBYK187B7NkEIRszptWTBu2b
	jbutykZ5LNdsGRIqmGaWeUvSGkK5fzI1oc2UPcvGTxjMiCwlAL5r8ft6dOu2T1h7PSkRSH
	T4OxXizf3y1vYKPzYh0eO3koPU2lkUU=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="R/JRYwop";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.43.42 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JpCw0YzB/E+rREVQVx4e8LdnAUoGwKBAH31nCpGgpMI/93EJ70hNrg4pSmSks7tvBd4obMj5HtbXVTnFhaVRuXkYQIZtaTpsraSRGLw1am2NnCYHwBElT++O7nQokv1bOs5QYwQiX0owyQPDfvTSI6hbMIW4Vn1MfflaI31wUVD5cpu5uh0fKzDR8TTP9uAVREOX2Dp2BfNf90IHoUkx/g7te/ir5sABTmUpE7svZty7cp2sygLlChoQ6cHaWXx6t6LZA+JFWlw3DnewauvhrvLk4W2TdKo8BTD93atR/p6nX17Z7f8H59fjuGV8jlG1/qQyeYaaRDVGWmcGDnft2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kXU3btpdlVAqrk+XU3KVn0INEYxWt2dxRyJSuiFm0dk=;
 b=fk/58Nv4tYoeesKtPan7cbYjvbrR4+Cr77T5LqimQDTl2PwD+iSDmlPdRTSDOYPWG9euRHYxWFN7aoTaLgY/b/Et5nh4EMnWawyNSu2nhWm3LcAXrqD0p/aUL4YwTrjmXw5o6MJAMRkvOLNDTtEtYKvqtbhKsNMJSI436ng0MZ17LshTNKIdhXXq82PVkDf4noRqLPAD8zmpCTJ8TTOPmohqaO1YNrNcZTHlQOOpKCm/ubK2Ma7YHBFuZSPqFV8a34i2ZkfIE+nUrLU3/tW35XhfEMMeQZpZ0Ovkt5XOL53VskWXWhEvl0ji22pGlE5cZ6sfgWILyh30zkil+Yd1QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kXU3btpdlVAqrk+XU3KVn0INEYxWt2dxRyJSuiFm0dk=;
 b=R/JRYwopIrZAgYfPcSbkI/ZR/h949unlRwPrfWD/Bc4+pvG6OAnPglPrpagWUtREWzvdAypW89lLVms6+HSNfUAqGeebmSgHYBUgToNErE/9vMlAi+TaSF0HgLPX0tc8zjF+ewYEjZPPRleBaYddKLXd+JXpCJBJTMYQXMnf+xw0TwrtUc7atYuFpkOy9L0LHyvgG46dz1uxzvE1mTb9fDbPIJKsNJ7a3l8clXePL65CapoccoeXbuM0f5LXvfe0cj7vVy5ZKLctPwcgmOvpnnjGAZo7/OiRT+UUz9kZOm9uT2dYSWTsEUFRostbLFtu9ucauB0H8G/FrsVcGOoTfg==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by SJ2PR12MB8135.namprd12.prod.outlook.com (2603:10b6:a03:4f3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Sat, 14 Nov
 2026 05:09:24 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0615.009; Sat, 14 Nov 2026
 05:09:23 +0000
Date: Sat, 14 Nov 2026 16:09:17 +1100
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
Subject: Re: [PATCH v2 05/13] mm/migrate_device: don't collect a range twice
Message-ID: <avfrWjzLQdDcmXO6@parvat>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
 <20261113-mason-migrate-et-al-fixes-v2-5-50a2ed382b61@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-5-50a2ed382b61@kernel.org>
X-ClientProxiedBy: ME0PR01CA0029.ausprd01.prod.outlook.com
 (2603:10c6:220:210::22) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|SJ2PR12MB8135:EE_
X-MS-Office365-Filtering-Correlation-Id: 45bc9639-1977-4cc6-677d-08df420d72aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|18002099003|22082099003|6133799003|261009223027099003|11063799006|4143699003|56012099006|5023799004|261021121427099003|261028144727099003|261026140227099003|261026121527099003|261022075727099003|261021123027099003|261022105027099003|10067099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	k4LqaJn3vUsQWU2UtM/tgvFhtJtjuypayktnfbfE8gXdksVgA/K6XU1x6JrPiwFnpfAZuq0aionD6AkShKoNNQZpJdhB4RZcBy4JYdJcZgDjgUsbdxAA9w0u5xLUhFZp2tF7EU3YLOsSRhms42JkDPZXJ7764EYv+ry/RW7wzf4rdAG+HKdylenIWQTeYldZbzgTaGY15KBQCj2Qy1HIPSwZUYPC4jbwplJLxZUBJsvo6ZCpZJCAxD6XypDVY0z3a4aoDnfriIlhBPd6QRZnEiqRIDyOh3l0CbeJH57uJgU/k6Oq97PSm/loB91Du4Bm/Wfw05QEaWJBEkJTXfF39ARm2KpwZjmfcOpUD6PmSZyJ0O8XEfvEYJ00zRS2/jQJbz3Yxh9nzndnvYul0lsN3p83dc3CT5l4uEGVhbYPX9GWnX99w86HWLaGwu1pWpYr/nsIjwDCyHm4Tp0+1+Cb0wc88Im3ShRrLRmC+yf08CKaTojtBVlXhCpgzE3aWUA9sODchUUjNLl9FrsK8tOIZQWxTz43uBwLvxYyigs+BWR4/pC1G1YjQQ8ZdU7GnORjT7vjVwuCRpdMaIBqB2aJOnc2uzE2a7AtNmppWOJhTsQBF3SI0lfufdbB3Gn65e3EvmOlWKosXgSw+vWk/v0Z1WnOqJq8bXIqCmgr8c7apTg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(18002099003)(22082099003)(6133799003)(261009223027099003)(11063799006)(4143699003)(56012099006)(5023799004)(261021121427099003)(261028144727099003)(261026140227099003)(261026121527099003)(261022075727099003)(261021123027099003)(261022105027099003)(10067099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CQka+0aj3Ic5GbdcIY3v7fTIxTZIagJTgIp03kyxckuJuCV0jpgyaDQW/WDq?=
 =?us-ascii?Q?Q+O1Jm9sO7XfafLzXGAV+eg4wrnRjvYbBw1dDn+Q5t7Myx5+F1Y5SV16lrIV?=
 =?us-ascii?Q?6EnpqlKmjI7k4TjoJ1ITX1pMohllsygBlge64XuWmvIpuDybcjpMzytE8y+N?=
 =?us-ascii?Q?X2Ctt1PXvT6grlpITPhXuvmuN6hwWsRO/zdBnI9XTm11V5+DMtCwoAjn1Gjz?=
 =?us-ascii?Q?uJre/kqJeVzKZktPRP7a+CzFalbpcYACDJlpGi/ZuomABhslrZu2C+13Ib3p?=
 =?us-ascii?Q?6rP7aFfFr1CRGatg98n5BGLhLHR/vDSTK5GeNV4yKAor76Jn/rpG3FEnY2G3?=
 =?us-ascii?Q?MQxKWP/LWeGZsfY6ydSb3SoRikqa7ZuoAbzwr4mAfLp0Rlah9o7N2ZyPrYpW?=
 =?us-ascii?Q?HBZ31TgSoxHiLEXycVLfKmSzDBsImsxXBtTBy0qgIh3ddnwirfpqqBW3EVC/?=
 =?us-ascii?Q?qfnZLK4mXNx79MBdvkmy+no93nQxXle8ouNnpUDWJwwoDWQfOpoq0F0r6P6F?=
 =?us-ascii?Q?OlZTSbQXr4AkloUtUWYGQeqz2OSW86dl00FJ+WI7PLgz45aCIBJW2bLczEih?=
 =?us-ascii?Q?O2BwkIdkpN9e7lUTABUHBvyeCzQZ6B0GhKO7KBxJSR2PA6+0rs3lULq4LBPK?=
 =?us-ascii?Q?/4O2ftA2f1/EVJV08HNTa47SFUHnxQHhPGSkYpfC4P5Gi8vgbaA3p9zclicX?=
 =?us-ascii?Q?KZ89Vg59RuOdPxK19vml/PzIn3kWiEFXl4OLpHRj3blexeTx0v1/h0kY7GdC?=
 =?us-ascii?Q?gpnCffsWtow8dq9tKYnFk3UMkb9QKCg/xeoCvQneDiJkPHxuQBLcRsjFfid0?=
 =?us-ascii?Q?HzRoRjZQqKZH/+Wc+1OZsuuzQwE66dnVzgKpHni5ZYJYNC+d6wXFKeCssp61?=
 =?us-ascii?Q?NHjZllpC8aH6/82TtZoStGEc1qhV2x/Jm/reKrZ949KMCNb011hRIenSGvRA?=
 =?us-ascii?Q?CVC8RsyQsCvM8xyNtbHU0Uvgde1cjHDq2/IMpgnXigAYpUos4dHEi/nFvl1N?=
 =?us-ascii?Q?WcgWh0HkFQg3LQjsJAZx+p+vidfzME20/6UZTot6DunDXBDtANbNfVMG1M0Z?=
 =?us-ascii?Q?aGqfTvqJV9Gj8LbkGOhq9IZgpjpuhK9bHlSAz0+Qi3DcVBi1iTJOXF2FgUaI?=
 =?us-ascii?Q?fCNDua475jmz6HMKTMMlPGaTKBT2ee3Hn9sLoDjZKekGXx7F/UHJWpRjteo4?=
 =?us-ascii?Q?KPwW4bVBqqz8V07Oy1ktCI0ghdJBdnxZQ97UBcmHqsPncFWAhV1sHOneX3FM?=
 =?us-ascii?Q?304ayZWvkoid+aXIVC9fING8npuVyG7Q8Vx/O5rAQ8Sdll9ZytS+8sEPWFQv?=
 =?us-ascii?Q?yIQlLnNMz7SvCeZS+xbqM1ir+TRf77t7STauBZDUMTq+nxq+zENXZwxncFcy?=
 =?us-ascii?Q?+rJQVDPfvpNR/CLi4zN7uOyZEbNsfJPBW4dtqnJi/XscQAy3UzLBkcGccSUF?=
 =?us-ascii?Q?AbsDUysHCuClDT/Tp8cYqyPdxA4Qtunt3YES/byF/Yps+loxXlRI0GDY4puH?=
 =?us-ascii?Q?CAbyLORKGxEfNV0PmEDhpKOQ1mf9q3i95g+23H5ZkIqTPltQOwaxhxWh7DvY?=
 =?us-ascii?Q?JTXrYeuA4hClQaxDOy+aRJbsBEAxPLuMTjqaZNNKLFY8C+Bn3U6ZlB/ZKo4e?=
 =?us-ascii?Q?2EQu/LwCVAVumzFZEluzXAYbrzXjbBGwdux0c7J6w9EMiwk2YHSPdKDV9U8z?=
 =?us-ascii?Q?7d2Oq3JjIIU9DfE0ou3iJXzcsQOsnEzBVLnyBg05fg6b4TPjiLQw1T5HFw+8?=
 =?us-ascii?Q?X1giNUA4CQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45bc9639-1977-4cc6-677d-08df420d72aa
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2026 05:09:23.8433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f1mZt3ENoyHKpmXPbYiOm4BfQ/WKNIQ1mvo/w7EQh+Xk/7KwlDBC+eDH/IUjT4UwT9pgE6rzSovzTHueEpdEcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8135
X-Rspamd-Queue-Id: 5F777120004
X-Rspamd-Server: rspam12
X-Stat-Signature: aeo7rna1i1937ye6eeri5juuissbst1i
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794632969-902976
X-HE-Meta: U2FsdGVkX19sltTRdmr9dO04DXK6OcY8SdvsW0zVS42L/CFpSqaFUjUAsX+ac2CWruSsG3/2sdVGlEEi4kua/xrT8/QYh9Ly7ZBpuBpqq491znCmEImMkBTvhhkj++oQLKz1PJevXl0dUV8wOuQZXJ9D6Ny177cuUtA2UmC98WNko6gIR4/6IJUxNW9XRj23dUqReVKG1IfDnIgYn6u2OUW1JKNOiobOQ1YsVPjXRjl+AdXzuGhR9uaPUlHe7SxztQG5zddAWNQ1ofKMtOzjq52A8s28TFtVsE50r4lod2I0CGefjyGFft4JYh0FS70CU9MeIUX92AoPerDpL+zQIroD9Ba4/ojMaHLHhbMGB91PVBn5zeUI5AyJW+WJnC+brV90Dkkc1B7euTPQyO+L/h1LGP+C0vfMw3C9cKqX6v8RQh3CWr0AW8TxDJe8V2GLT5/WsAgnOeVQ1iSvyiw7Oe2QXMXu3m5WYw7Ozp8LT30yI5I2e4iHoxlySyTpcqVR5KIi5jT2+1s6vJdxGcY7jdxV8LxV/RIzZ/BvPjf4+v0uN/qdrZpIkz9umBUQEJr+S1/YOqlVD+D+EGT+HRdIt84PwrONS++pvkPB5ST4MzQNRBFFi1NOK7BEZpIBsfY/ZfEezvfxFrTqjBLZAn6cYNR+2U84X8EnZ+7UafDASwH3AcoXvJRLXCaUriYIIodlHG6palqEvf+jwwvqE9BIlwRNuk73mYlnAK0bfj2+JyG87Fg2Elvzkl7bOfir+U8RUNyhNkhKWFxJenGz9n0ac5o4jtyyVulyxDdn6Iaut1aH0cJa7FsN+FdR7md/1oqx5du3IGTXf9TQ4oQ04Ls6c7ytvLGdFeJhYotIgyTdXAw67wPqsQkLFHKdafcIRsDNgqH1T2u/NMScpEqiRWgbbn9V3tKuW1AWlSJmR/pPCuCcRfU8uLxcwdAoe8E30rl8KJkkp8PysrGeHTYOzY9
 Cjuc79JO
 dt83wLILlo7T/4dmjpgJYE0dyGtw9oGuRfBQXPnAKTGU23LtgwWdnSVFTHtflabh0H+BjVN1R/YGC/H3FpUoGLI/dVXqXOcRYZoVbhl2RMgzHDiMAJZB01ZhF4IfOVKYv8SLA91+VBf1topa7fqJeGXivkER3FVg965hlBsNc65SCQuBMMFgxg4t9o/StqjrgwThlKFmaLeb5J/frR/5tP6u57glRCXT7vAabdsXe7F5Y7V+FuCSMSDcyFntXjyfzaLKeCoONtScGuWbwpZj6DAnd3ib2tzYv4DssgQtg3YxOlLi5cR20Fpiu90y3Ixwxx+wh6GGrqhSYxPtZEgVh7Or+gszDLfus00QKLHsk7PmHGKf+0u5FevpROAWyUz41ZSwlqaAGmXhCBdmzI8J6/h5hg3fX2itdd87okODJAyQyz/0O7VaKSMo9zktop/QeFMntI9zAUpKRlXhwnezTfCQ8jkRet7i8uwNDiK1v4Gta87ofaAzXwK/7ydg+/J02rVhvgV4WRXmEiTE4zlnUHqReoe4PNRAtwIJqnA2vUeJ0fS+r0mnoriOb20suV7dMdzT6A3HMl41nj5fMCB/DC8XGPsmSqaxiTtdec5Q0Ddghkjtcu+rWaAjW7cN7x7FEKQwCb4VLRrSFBdmwwkOZPOfkGruxmyEW9VV4DsoPnpb4kPzISsRN03BOEcGchMoPm/6CGeFJtfAKoZYkMFSeLpG1esZVtU26e6SHG+bVDVqzWmTkn0xSn2gDiE5SboN8S97UWDXxraKwAzspQfUVpdvXCv4haac4DOJTE2aRFW7ZJ1sriOx9eLA9yR1C+ybzsQNKoa5E7A3Ay7qLqNb9tokyRUWm0rKLDBUxzxJjVAygGYJEUdhVDIiq0HjKkEm+nHFW5eFK3vxIT8H6maTthHvbjUA6a+mAEB9J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 09:45:23PM +0000, Lorenzo Stoakes (ARM) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> migrate_vma_collect_pmd() drops the page table lock to split a large folio
> which it finds in the middle of a page table, and then starts over at the
> "again" label. The entries for [start, addr) are in migrate->src[] and
> migrate->dst[] by then.
> 
> While the page table lock is dropped the page table can go away, in which
> case the restarted walk invokes migrate_vma_collect_huge_pmd(). However
> this is passed start rather than addr, so [start, addr) is collected a
> second time.
> 
> This can result in migrate->npages exceeding the number of pages the
> caller asked for, and therefore in writes past the end of the
> migrate->src[] and migrate->dst[] arrays.
> 
> Fix this by only handing over what has not yet been collected,
> page-by-page, and flush the TLB for those entries which have been
> previously replaced, similar to the other returns in the function.
> 
> Fixes: 022a12deda53 ("mm/migrate_device: handle partially mapped folios during collection")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ ljs: cleanup commit message ]
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/migrate_device.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 9e5dab8e1b77..28ed706109da 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -257,13 +257,17 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  	pte_t *ptep;
>  
>  again:
> +	/* [start, addr) is collected if we get here after splitting a folio */
>  	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
> -		int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
> +		int ret = migrate_vma_collect_huge_pmd(pmdp, addr, end, walk, fault_folio);
>  
>  		if (ret == -EAGAIN)
>  			goto again;
> -		if (ret == 0)
> +		if (ret == 0) {
> +			if (unmapped)
> +				flush_tlb_range(walk->vma, start, end);
>  			return 0;
> +		}
>  	}
>  
>  	ptep = pte_offset_map_lock(mm, pmdp, start, &ptl);
>

Is the intended race a concurrent MADV_DONTNEED reclaiming the PTE table while
PTL is dropped for the split? That would leave pmd_none() true on retry, entering
migrate_vma_collect_huge_pmd() through !pmd_present() and taking its hole path.

Thanks,
Balbir

