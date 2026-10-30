Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77C12606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 02:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SZ8jXkWN
Received: by kanga.kvack.org (Postfix)
	id 235176B05B5; Thu, 29 Oct 2026 22:22:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E6DF6B05B6; Thu, 29 Oct 2026 22:22:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FD136B05B9; Thu, 29 Oct 2026 22:22:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C42D56B05B5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:22:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7E001A061A
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:22:11 +0000 (UTC)
X-FDA: 85377692862.17.63D06AA
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012030.outbound.protection.outlook.com [52.101.48.30])
	by imf21.hostedemail.com (Postfix) with ESMTP id E56671C0009
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:22:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SZ8jXkWN;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.30 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793326929;
	b=z/lIhBeSnkHzGqrtI6UO9cB8qZj70B92ySpHvvHlKMur4qCJSgBqEx/oMxp6LT27T6LaSu
	JYXjfUbyvAhn9oTM9xYkx6ZqoIciPdtO7gZ3VZ0YoDRziH1UAn64JdiotOzdxhbjvFlLm+
	bIluOcKKudH8hclAYi+zZ8Z+p+aOrTk=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SZ8jXkWN;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.30 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793326929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cL8MylXspgrJ0jL5yWbWUPjDhynqUW0OugSNyaAfofA=;
	b=5GWL5cjfrTpAyiNizVgM5+vLaZS/UgwWewTnBTRxTHHOYxvDDLgyepY1kKpUAy4w6LK0ZP
	sneR+ABG5k/YW4HclAUHOnVruelyhWtCCJ8Xt1YaUNobIobgdaHv8z2X5veCuHaHb++82c
	gAHwJA/2qNBV6GcwCMvJrHdET9DRtTo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kEeplRUTDc4cZUtYi6CSkgMWUe7+U9ObspGHmIYcEdLujrjP9GVizUrE/8ng8YzRcrw9PG/pIM7+M8ES6J6FfLCjdV+jUSbgtIi0RfzjhMM95jHluBNeeAK5iz2ArsyLz9F+fYtVTW6UZjCGbRL1pHtylTLE2F4qeg0n6bMr19R0keIAJqeyf0F+icVwJaDt1yj1GedsvISF9U5XCt6cCIMhDggaW/O+jq4xZjdD9cdcxXDzTBAAdyJF8YTUyHftQdP3D7I6A7UTpy+DBItA9dkxwpx3NLRm37wVMAqRa8rPKWtsb2M/AZH9U16mYztvg2MlcopM1TqG7edMppLU4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cL8MylXspgrJ0jL5yWbWUPjDhynqUW0OugSNyaAfofA=;
 b=WEG6o83MyE/2uvTRMufQ3PJ1y0xqEPNmH/r7J3BuF8LKX1myCSU5T1f1AjIdl91gGXSHb58SSBc1zT6Fbrm9N14yMmwEk0wLBIrg6JqxUvnFuzkcJEzmahqzcveC/to3mTwfzn+EF6PMJCSCmduD4Wz3Cnuv/ZrVLMhELuPo2WLPIazNANjXqV6yG0ARn8RBcN8DGRZA13aW8HfmoiUwkiMsS58mlaPJ8HvEXrAB8V1t6HvxohT/lMXgrdu6O6rIdV6dyVBrlqSMO79Pe3t6940MybV2Glk5xMeMUy7Wjd71cSn3izqMlYncNEhqAUtrG+2cO/NzajM3wjthVjEATg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cL8MylXspgrJ0jL5yWbWUPjDhynqUW0OugSNyaAfofA=;
 b=SZ8jXkWNCoe3OgkwgN6WAuU9/SmjEgvenMbOTGsIq4DRmd4uunET8n7iYk9OuI2nAEtiB4qwZnKINB4r3iTs63prHxaUAcxhgRPDFW1xKHAYXUeFjVPbu4Ozvg5nKuj+bTgGgU/6Ss1UEKOMnDJAtznl5iLQquYOAxlhu+pYYTCFhCRHCAChn6RPS4AnvzzaTO8J7Bp8gi9Y8bXsYrPYwlA9IPetG08xsZ6j15cVXrlkx5dZR/9U3XycgDSBdX2uf5b3ARa6SQ3/OIefqsGFwTO+3l2hmCNxi3qagbrgljagCcIqtHFL7hkgGJVGmHJ1MllnSFWEXH+5pASHoECoOw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB5595.namprd12.prod.outlook.com (2603:10b6:510:135::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Fri, 30 Oct
 2026 02:22:00 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.007; Fri, 30 Oct 2026
 02:21:59 +0000
From: Zi Yan <ziy@nvidia.com>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, teawater <zhuhui@kylinos.cn>
Subject: Re: [PATCH] mm/compaction: annotate data race for
 zone->free_area[order].nr_free
Date: Thu, 29 Oct 2026 22:21:57 -0400
X-Mailer: MailMate (3.0r7038)
Message-ID: <96FC569B-BD1B-4B5C-BA7E-939CD769C513@nvidia.com>
In-Reply-To: <20261028090747.68086-1-hui.zhu@linux.dev>
References: <20261028090747.68086-1-hui.zhu@linux.dev>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0390.namprd03.prod.outlook.com
 (2603:10b6:408:f7::35) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB5595:EE_
X-MS-Office365-Filtering-Correlation-Id: 248aa49d-2269-4571-c86c-08df362c93e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|23010399003|261021121427099003|261009223027099003|261022105027099003|10067099003|56012099006|261021123027099003|261026121527099003|22082099003|18002099003|11063799006|261028144727099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	YxItFUrJml9/M33PkYOQ6RfXC6lHL52rucKkah96TRy/jiUQIdwBAr9/7SAW86f+EIPbHPtjf2Zp4XZIZ5iZ63O/JxQ3OM2nB2/1ui7y2ehdaoLs6mRWhY1cDX4xzHnXMrv4nJC1eSyEshVFm4F9fDkNR0sCuNYDsARIJ8heJ+NV+X5xs8CWqjHd9hbpZmDDqYpWbzLGieJ0CGYRw2DWuAZzlEwMLm7aBzkhPhzo69rPQC5TqZ9x7J/peSE4Pe/l4aBGIaokqexLz9afp6E7zshmJnaMBsK3bAfro8APVgkRa+HTcWpKgt7VkpicHJw99Sbz04ro6I74BlCuvW6u97WNe2OIVLP/XLjG5craTjJ97s+dZVrcADE4jzJz0l8DoTVeeWzcNDbiS6u7HCQg02U2XH5ex4CImH6D5qiaZzZy+hcj219BsvQehbIwbggzaRm0Dqdltc8FPhcNZmzLRLvHtkdfvMDGSRy/fwzSti1Z97MDfEtTPo803xp9npg7UL8BYSYkP9j6o8oFKPHkDsox9JJ792hUo8lxMaPrDZpQiLWqauSCH7NJugs36VHbm12bbqBC7ZUUx1/E5bhvH3XoSZyjItOlkTHalVm+zSz9VgLXJNzjE6eRHwr/qH6WMRx52fJny1TGhW7SYc/SCe07YuXT9wWVRcmTFILbsMU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(23010399003)(261021121427099003)(261009223027099003)(261022105027099003)(10067099003)(56012099006)(261021123027099003)(261026121527099003)(22082099003)(18002099003)(11063799006)(261028144727099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dL9zCl8LUqabqybh0ssmKP07dihTEnPnuTqjCRrVLhy7qoUevMtgad8Slz6f?=
 =?us-ascii?Q?Z6sQEFW78SIQHrzsVLgvLl1JzosqqZsAUqAPIbLKF+t/x+CFhm3y4rt/gAuv?=
 =?us-ascii?Q?XTcoHLmO+Ce8/dc3zPoy5g+1P1SrF6Cb/1P6f2QVRr3unA6nIKupBubje3vV?=
 =?us-ascii?Q?JUZxCLdPknmjfw8pKFUu+x3qVTOzOOicUYaKg1jWw83of0Kf6xCTqyCKoNku?=
 =?us-ascii?Q?frL/zvXGSQSx9aAa7zH4+FkTst9UB1wWwX3wF2qRWuSYUZXhfk+aIhlJKUTo?=
 =?us-ascii?Q?SN41i7Lkd1xMOxBzpJFX4oCai+niawBG419Xkft58d7UuP61EV4DAzAOqrxw?=
 =?us-ascii?Q?edfluS34VSkzLXqZiLuf/XnrCzIUg7MqT66xwAzP8+tTk7gvY8uXi/ZAJoek?=
 =?us-ascii?Q?KxC1xF9F+kJp/YqN/tRdD5LJI6JAKdqNzx7Io4jWmx9iHdoBoT3NxXODz09+?=
 =?us-ascii?Q?X6WYYd3fP/5+8qDdp1yqNCPJL8kzR7oYh0oZb3zZfjjpatjp08nVM2SicQqh?=
 =?us-ascii?Q?bvHtuSBeW1AHHibB/LDHz1R/KKKKCygbZEP7TCCkRPJXr0mZKce+ZXVpZbEs?=
 =?us-ascii?Q?q4oFwFV2aZHtGtG9GM6zFmiMPD+Ty/W8mcs9G7/Uxe+N+W9/ZuYKcfs2tHjn?=
 =?us-ascii?Q?L7sZH0Y05uRXGVetIS0dC3oMH7Z2vlPRWi+pkkqWFouR6adTJD4g2Cnk9uLk?=
 =?us-ascii?Q?Dw5H1EMYgGyC8nT1q7QVGa0rgWDrduuFaVeq4MpXJx4zJbgPCP4/ngbnyLGM?=
 =?us-ascii?Q?AQuVVQ3tvyPy+1MqHrWsSgv1UQLTWpe7njkAoQ6cJ32wjEaf7zIDiJGKq0eX?=
 =?us-ascii?Q?4lOXOFunD7iB4mOhZi9CDrD5QJEHYSmjfL9btlciN8o1Wscmvky5BHg98AiO?=
 =?us-ascii?Q?R6nBhEhg+ZGc1vdXxwfZofigL6heyAynixe5y1ohrUSt6rswEt+auBfgzUDy?=
 =?us-ascii?Q?S7xlVUEfJN37ZDw6dABHPXKvgytuyLWOdAXpiIhe/LzpcjOOi+BCvO7zwMd1?=
 =?us-ascii?Q?s4UC5Hd1V+rr24azZUNDWtLnSa7am8TFs2nxQb6aJA9j6WwPL41DJL7oKHQg?=
 =?us-ascii?Q?v811Tdrk5icAUq15l/iAN6lIYaoqKgWC6sxtnqQryeL/vUiEc6Kd8vsoyyeo?=
 =?us-ascii?Q?kjQHuegzJj4dudN6e9a7h+vEA3X2Ilz0PRaFw5dy82feofAV2o47mZzwXAv8?=
 =?us-ascii?Q?2gxCfzizLMBgwFh7mT+vReAxDwhdxrarNFaKlZMtL9D1Eo1UPewaxc2d7qs7?=
 =?us-ascii?Q?x5guwe3Aw3FHKITB3tr7OYVDE15px39qOVGoel6f974DprgfPChbC1UFwH6m?=
 =?us-ascii?Q?jYJKBn6K2mcBZHGJIXO5s9NdwexslBcWy7SjxT4eJe3cT1m49mnX+U0HCqZW?=
 =?us-ascii?Q?W0F0hosBIGMq4WTEjbdBdN93izVgkXpmp7ydm4LW6HUvOFd+QB+e94UzHfKP?=
 =?us-ascii?Q?mF2VLDN6w+lbTj/sudHCFnepxZ7IgKU4QQBGXUPZFzyFP+/yA+HBMC3l/WPp?=
 =?us-ascii?Q?5cGdL6Oh2WTl1+tJeIJjzTbvCelM+bkVTE2h+TfNnjdYf3Ui9qmGp2trGa8B?=
 =?us-ascii?Q?50XkZe93itqwj1sYTmtTObGe4W1TfD8OpYLrAhvkp8x31uTDBIQbvvzpW/RO?=
 =?us-ascii?Q?jM7l3AlNDL/jBrzwj7yXGxRc1XOOnhlaIBkFUtddf+z4DNSB5voAZBT7shDk?=
 =?us-ascii?Q?OZPtXYdjTzm0+Ux9+Donhna9SzhjGM6qRjWXLCwmbnfsAk0h?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 248aa49d-2269-4571-c86c-08df362c93e8
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2026 02:21:59.8927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pM0DS7IRNEKVvDh7686ncyYHO3wrSJsB+VpuVQP4SN4i0nsc5DbijmEaCct7J6ae
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5595
X-Rspam-User: 
X-Rspamd-Queue-Id: E56671C0009
X-Stat-Signature: cf7ttae7symo81js7gm4suse5q8yruds
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793326928-702147
X-HE-Meta: U2FsdGVkX18HybNoEbj0RFd8Lfy9QxVUgKUpS0ivlUCQD21kdsqUB6V/O31nxUs0BcvvUUjA2lv4aURrhEHu0dbbslIApw8fbcAKBzj7AgLpC6ANxJOVNgn/T1xmzz4XnPI0T5Jcy5iqwQFLvK1ETk1K6AAPD++QCmzHF0RxGxRNAxlCBHA9gqtggg/fw0bZvKvw/u+T+9dsTMzLP7T5mVoWB3Wf+oGGPono8FKc2sXQeXWMWbn0O9wYdLHcy5yL2LSS/adqecmbEzsdRfI5/2UIXYnnj5HdvYLORnaQXfG3mrVyo4FgNYTqLSfnOyQbtcEgrl05vzgLysXbJ63ADhyzyNsjoT4sNJv2d2aurjFqtpCD/KeFrBz1EAUM+pzFPLeHoOhyjZ4D7piGLyC21daKvvU/HvvU73ca0cxRsJDcQ8f1EI7BH3wS+svYzn5Yvl0RX6mN3aHFeE1yPOOfX/jFAy77W9R4681cyqGD1kWqQd9gt5O6d5MlfiiiQxIcKWJEkhztvf4rgnym/0xQZ7pF0EyJ1jgRAqGdT+bolzEXjee98rOAIMW91tFMoEjN8Da018qI27vlFU3YjF2TKn1FWb2wV3nPTu786mI2SY5HhoCTD9FwdkDrTeFvPKfEaRjQ3WokNITH8BPzvE0joTAtJYr1yaQrA4H7qkZRPTUiG0CHWJ4WQgqqrmPLiBMV27cj0YMtKFQYDSbhqXxaw/C3HzKXRBTad3l/wF4RGPDFmd0tR+ZIMsiZl5A0DZI+PXADNbH8QrMeeW4wKE2NbzF17dnULaO6TAxTfvudl4RD0MgE5BowMv/1CC0pw0y/Tn7dPafeaLwHusojb+A6wK0h7fM61nx5QecL0hcqcJt+B06cE8YJqIkjs0hSwVu2d0HQNHwDUETi7kEDxpP45I0oNPohrAjv3eJuWx6lOglp0xyyooDjOhBc18kkWCTS8MzCaLUQC2sLgbqsfZK
 n0U1Ofj9
 xs4q5pSxRWV38a027iROycV8L4BW2BWu7kE40bmZ8SFdWCctBw795/pzw167PSDyWlQE0d1jLmXK1Omo5R2kHcFWueTsT+tYWO/aZb7G9/mhcF6a3/Hh2jYC50vru0y4miRdaNYQ5WhNQSxezOeb29r6TpIDkzb1y46SlJVHyg9Ioa1ghzMJ4OGfF4ZfOLjlkAJPaWef9qieTDlJyUnPFFbpvRNwUxmyNFf7ha12hRTXRclIZ4DHD4BEAIWsCVV5AQagUGMh8JqelI/Ek5Rx9GNLN8qjIehFMHBqIZXT3jImAwfeDUlXc2FgMyY3VST6LQ/JP7bzJlO4XLfO58iS977LLFZKw9dXRrYITC9u6Er9NMIYKXq7vGj0lbQq9r6V+O1MX6y5ntjR4zqR9KxdKey5pt9P0i50aSb3i2lUgSWNzE6RQFg9nc26mBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 28 Oct 2026, at 5:07, Hui Zhu wrote:

> From: teawater <zhuhui@kylinos.cn>
>
> KCSAN reports a data-race on nr_free which also exists on mainline:
>
>   BUG: KCSAN: data-race in fast_isolate_freepages+0x284/0x1550 mm/compaction.c:1589
>
>   race at unknown origin, with read to 0xffff9894ff3dcb60 of 8 bytes by task 179078 on cpu 12:
>    fast_isolate_freepages+0x284/0x1550 mm/compaction.c:1589
>    isolate_freepages+0x52/0x650 mm/compaction.c:1722
>    compaction_alloc_noprof+0x36e/0x3e0 mm/compaction.c:1850
>    compaction_alloc+0x21/0x30 mm/compaction.c:1880
>    migrate_folio_unmap+0x7f/0x820 mm/migrate.c:1177
>    migrate_pages_batch+0x37e/0x1200 mm/migrate.c:1762
>    migrate_pages_sync+0xce/0x560 mm/migrate.c:1928
>    migrate_pages+0x8c6/0xc20 mm/migrate.c:2037
>    compact_zone+0x539/0x10b0 mm/compaction.c:2660
>    compact_zone_order+0x1b8/0x230 mm/compaction.c:2795
>    try_to_compact_pages+0x20b/0x630 mm/compaction.c:2851
>    __alloc_pages_direct_compact+0x98/0x2b0 mm/page_alloc.c:3722
>    __alloc_pages_slowpath.constprop.0+0x452/0xdf0 mm/page_alloc.c:4401
>    __alloc_pages_noprof+0x28a/0x2d0 mm/page_alloc.c:4794
>    alloc_pages_mpol_noprof+0x1b1/0x470 mm/mempolicy.c:2270
>    alloc_pages_noprof+0x7a/0xe0 mm/mempolicy.c:2347
>    io_mem_alloc_compound io_uring/io_uring.c:2848 [inline]
>    io_pages_map+0xb9/0x330 io_uring/io_uring.c:2892
>    io_allocate_scq_urings+0x231/0x300 io_uring/io_uring.c:3933
>    io_uring_create+0x29c/0x9c0 io_uring/io_uring.c:4091
>    io_uring_setup+0xb6/0x100 io_uring/io_uring.c:4203
>    __do_sys_io_uring_setup io_uring/io_uring.c:4230 [inline]
>    __se_sys_io_uring_setup io_uring/io_uring.c:4224 [inline]
>    __x64_sys_io_uring_setup+0x66/0xe0 io_uring/io_uring.c:4224
>    x64_sys_call+0x1816/0x1d90 arch/x86/include/generated/asm/syscalls_64.h:426
>    do_syscall_x64 arch/x86/entry/common.c:51 [inline]
>    do_syscall_64+0x70/0x2a0 arch/x86/entry/common.c:81
>    entry_SYSCALL_64_after_hwframe+0x76/0xe0
>
>   value changed: 0x00000000000002f4 -> 0x00000000000002f5
>
> nr_free is only updated with zone->lock held, but fast_isolate_freepages()
> and fast_find_migrateblock() read it locklessly to skip an order that has
> no free pages.  page_alloc.o is excluded from KCSAN, so the writer is not
> instrumented and the report is of unknown origin.
>
> The race is benign: a stale zero only skips the order for this round, and
> a stale non-zero just finds an empty MIGRATE_MOVABLE freelist under the
> lock.  Annotate both reads with data_race(), following commit
> af1c31acc853 ("mm/vmstat: annotate data race for zone->free_area[order].nr_free").
>
> No functional change intended.
>
> Signed-off-by: teawater <zhuhui@kylinos.cn>
> ---
>  mm/compaction.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
With your sob fixed, feel free to add

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

