Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F034A606A329
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 06:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=pO1h3vNo
Received: by kanga.kvack.org (Postfix)
	id 213BC6B05BB; Thu,  5 Nov 2026 01:17:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C62F6B05BC; Thu,  5 Nov 2026 01:17:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07FE86B05BD; Thu,  5 Nov 2026 01:17:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C2E7E6B05BB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:17:26 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 452EEA0970
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:17:26 +0000 (UTC)
X-FDA: 85400058492.20.AD7C285
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012031.outbound.protection.outlook.com [40.93.195.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6AF6E180003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:17:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pO1h3vNo;
	spf=pass (imf16.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.195.31 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793859443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t+JJRMydHxdPqDIQ0OjJ6/jxtXOmSjWuwdxpd5R6SPQ=;
	b=VE84j0TdMl5IczW9jsnUIzWD0qLQJ9hvuHG1D8Q7rckUwLRdh4HLxe+8Ij84r52Wc4CzWW
	Tx5t5zCBIvO1n+egUqykRA/ssImEgO3DKu+wWDr0TxZlKW21aKICOkpMgMQ4K+310Wo82W
	t4c9I2YQeTw0QzNn/zGFQ+ZbX7Me9Hc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793859443;
	b=zLLNwz2XN3WX+3XOi6SqXujUsxOa9z8JSP8OUGOrhm2U74r2tOVpQDva2KXGASIlLnSniD
	YinUVblmgCPZ/KAycX8UbnVaVNae3+TFYqxiGM1FUOosNzYZs/r2T1B3tiW+PAA9L944RX
	Y0n5w67icVEJxLRUth+3KHut9M1b8nI=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pO1h3vNo;
	spf=pass (imf16.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.195.31 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iRppKhIZDe96P/qOjfMpRCR9WTXK3qttEtBy92qtE7vVDEZ1vvAOPgZSlFa32WpUz3PMdhervXupuakr7a9gPgw6Rt2ffqTwCd+neiKnQOxQBw7W+lOZZb0wV/1LIZMGxX2fl9qCt61o+mj718hj6+Ws1yDG+f1bI/7uZULcDzXKi1RDh4+X5joJe4a72+1OifvwFFAMsN7N2TucW+kMdSpSuVxjuBZRvVupJvkYDBYCvWAI4g67ktotgpRB5qYtwoVhHHt41lqb+ZXkDyzPwCJlQr+oPtogegzu+zgZl+WLIIAXybEKO9IbCw8p8PQbPsJEkj9tRudOEA14wr+pzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t+JJRMydHxdPqDIQ0OjJ6/jxtXOmSjWuwdxpd5R6SPQ=;
 b=ShiIk0paVkPPNvFeO2rqCf0Uqn/pD65kGrSTso467lqHjf1qQk0fo6HU/0PuZZu6BO3KIg9bqW5LtU8U7kd+wldNk3+bcD8oVNpL67gVNOVX56+7uHSVrNcA16GgGxNM4lPgwiTHHSltTIo0MMSq44dtafPGllwAHialb3pPHmwyE1Jsu2/P/HBMb90EoPEiqy5i682d+LDWzGknCiBBdhhRTMVpWzywJu5qQthsDAfqCiSfOu1/JfJNR/YlBaIeYzrnz30OltkBNJqNOsqPT4QO1u3b9E/UvnNuLJut3P+d8Es7t9tzHWlkgj3s4UvPWehMgAfG6DkZX1h5sU322Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+JJRMydHxdPqDIQ0OjJ6/jxtXOmSjWuwdxpd5R6SPQ=;
 b=pO1h3vNoym/mIoV89cxzcRtmBHFmifay3A86K1t/WwKSxO5Va5yxqKAdKFeuciX952ZSaTodtWGyJldZzc+Yyu5ukoBRD0EirAhVO9gL2zfgo5PL8tfyVDEJGi4Fml6A33CignCKnYhLPZOkzvZ5bwUyDnmZix0ZplkelfaluT2eK29FU6ykOUnlpx3L79Vf7JrxWfV0Bp/4v1cMuKi+Tkro1ZzPa62mQj2KeA8oR8Vvn8nFnV9RsQjbjfKPKGDllKSa+4vM6ajv6rSPY2jDq38MsMcEjy1lzLwRpeW3+YYmrchavbJiKitc1CALX2eD7U/c59o2tD4XEF7868xEKA==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by DM4PR12MB6496.namprd12.prod.outlook.com (2603:10b6:8:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 06:17:17 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:17:17 +0000
Date: Thu, 5 Nov 2026 17:17:10 +1100
From: Balbir Singh <balbirs@nvidia.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kuniyuki Iwashima <kuniyu@google.com>, Harry Yoo <harry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v8 0/7] mm/page_counter: move stock from mem_cgroup to
 page_counter
Message-ID: <auwfZj6QTwQqFIZb@parvat>
References: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
X-ClientProxiedBy: ME3PR01CA0066.ausprd01.prod.outlook.com
 (2603:10c6:220:1c2::19) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|DM4PR12MB6496:EE_
X-MS-Office365-Filtering-Correlation-Id: a88e690a-3473-4e0d-6d75-08df3b047102
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|10070799003|366016|1800799024|261022105027099003|261021121427099003|11063799006|10067099003|56012099006|261009223027099003|261021123027099003|261028144727099003|261026121527099003|261022075727099003|261102123227099003|261026140227099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	afxhITMZyoRsh+NYbEt4uHRpbfZq6JiENx3E5mQiuktCRWe3UZ0i40dlRH0f3L3v2hE/+Kw33yOaCvZPxho/W46HNfdO9zPVwZ0WP47+eCeIgB9untxO0aAPccvd2J6oxFxui7K6Cy2jIFxGR5MLXd2jrvT5TNw8IOwiGa50c5fvJ7tC3gwxY7y3wS2I+DBeLQPIWuLE2Od6av+P3PpWbD2E8HBwolZF807ExVimQ0Mpw74WTpQWuOHcAimQ+c0rdDDkiXNtisSq5Kjt1AXzBRWDw4hR1qX3iSgrP7k2E7TbrqtTwqr4iSv5YYCCMaAdT+UF4kRgMaE3zio4a7XCxiBZwn4e5e3378R/8XENmS1H4dHqbfhe1Fz/1xFNQlxxjNgcwCEcvKeoyRqywSrq2wsCbETP9+WQ+UdJOkvYv+AmeZREHCLme/wz79xh+jKHZp3J+0jEy1elljchNGFIc34+WrA33E0Me0tbuf7ZX6kKvzVdwY5t+lByhbGdyUdn4LZpd43sfZ/rB+Cmuy5E0eluCc/7ucvwcF17yQ5DiOOyBJ3Py0PEyK4ipCpSDC3wGOBxdeeSG4wJk/LwB9HQ/mLRf7eah3cJKtMXpdEeAgz8Ry5qg03csD7Y6vvTdX5znvaZQCkSeD+pmufuevi2X71Zq0EfjwqItqMy3zG30ME=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(10070799003)(366016)(1800799024)(261022105027099003)(261021121427099003)(11063799006)(10067099003)(56012099006)(261009223027099003)(261021123027099003)(261028144727099003)(261026121527099003)(261022075727099003)(261102123227099003)(261026140227099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wAtB9xsJlmbAQuYUCPjdkQm441ZDK1ibWGhKmgY7LJv9K0WRXWRE9ObsHiQ2?=
 =?us-ascii?Q?0urb6aAj0aUxwdAR1SaD9ae8wklAv1fM6DQrYndKHvSx5j/ayZ+e2SFn3PUA?=
 =?us-ascii?Q?E1hq1CJtZLPhE6rp3y5fCjBJwlZOFkY5ehZU+AQcN41wBm1OioRdIFPJKGdW?=
 =?us-ascii?Q?zQfUo/+XuErPf+KfQzfTd2oL90nSjJ0Y0bo15+IMYVqTCJji9fSdZ1N35502?=
 =?us-ascii?Q?411eBZX93vvuQyuX2vawJIDeQYBwn8lq93CfWqI0/jXYq4jArjIgBZ9w2gxm?=
 =?us-ascii?Q?Ide0UQcWJz5sepUho8MAo7H3F/hCMYtockbtM6QpiHxXqw65DGhbPQUdo8mi?=
 =?us-ascii?Q?hgK1veAvYy9bovDwPrW7hhDru2zRTFr3ZTQOqm+P/EWR+wMfiN9ynpMl3w+A?=
 =?us-ascii?Q?2B3+WPSv+G2+t3lUMat2C9Enzu4K1/XCy5+TubknSKSEUURWh/zkefPuIPx5?=
 =?us-ascii?Q?t8rIhEWHZF0ybP/M6xcDHJkGD1Tyz1N/lCKVSnHczT0DRIT8nYS2vpnQw167?=
 =?us-ascii?Q?rkhHft854kbiuUxezj5YSFRGelhhevLsSEgOOKoa8WXyJ/X0F3SrKh7NH9E3?=
 =?us-ascii?Q?Okrgq/tW4Ks4zQZ3EvJlIbNc7EK+dSCsK48N1sJSnzlH/K1/LCvoi2nEXW0k?=
 =?us-ascii?Q?eWObhzbON95zHH/fEepgqDCeCwCnIaSVqRjx+Ch90exEHA4JSe5jKKWdRfO+?=
 =?us-ascii?Q?hOFyvMe9Q87XcnWW3qQ6GtPUmdCwC/1bIcSPLApOgccFBMF2OM8XfDtzGuVc?=
 =?us-ascii?Q?i10jhcX5T0AFo3FxMAaHzeup7biCmftMIN9LrJLSf/pEU1+Uu95MXITmr+EE?=
 =?us-ascii?Q?A82CqibwhRAx1BAzAjORkR9HKkpoP9T/GLvLimmXwKBvqwCW4eeU36HPHD4m?=
 =?us-ascii?Q?Jn0TDjtoJlfUblD8zy5vpDIcNW0csdxI9f9sOzCcy5TGJRcNnKfGyeOSf0vP?=
 =?us-ascii?Q?09VGmwZUh1PGMplk2sQzXdUO1CpKYKLRBu9Lk+t/k3Nhyo8dyN2zDGHbO/nZ?=
 =?us-ascii?Q?KPY96bDbAKJmHDx+nVMyiIedbd6A2epuCXRNpQ4kUFJUIN/HNajwwsiHl+ki?=
 =?us-ascii?Q?8aaAckZFxKjhE2CtVw/ZzF1h5xlYm5QyQ3lzzVoojj9AuxfJmfbgC3yhhqJv?=
 =?us-ascii?Q?sd4QlxblIzffbRpyPWQ9nyQMQSbHj9U9LThOlB9Zbrf1f8Bv8O/zcOUa4HJJ?=
 =?us-ascii?Q?T2sUGhwhVptK0gLgEmbWLjYQq/n2kC0TMMyOiwUJMPxRxIq0xKPvvT45diOG?=
 =?us-ascii?Q?dx1K80XJh+es+O/987kympm3yL2eaHbWs03BG3ZdnFISobOmPYo8TccdYXDS?=
 =?us-ascii?Q?nCJwHUIDlVZmqPr+GGv222SoHSgOEUjWZEveSWEcQRdHWuCMTwID3kLJAeW+?=
 =?us-ascii?Q?vOnArwVrLYSVzi9IGd6AbbpA6lRfJcCUGEoopicetokZCtsz5cc8Tnff+87t?=
 =?us-ascii?Q?fLBQ+e9UCs7w6cTpipyBDxQ1UE0llyPW96LVl12v4NZsP8SrWGb8uBwIRcC/?=
 =?us-ascii?Q?sz4esGKZpvBKEGBGFV+DBhYWRn8fwAQr3cDDDQKPak9H1wU+c1hqAOlJ6NNR?=
 =?us-ascii?Q?CXLkun5sm41MgV0h6wgE8A2KsXk6h3Hhx4/NhUSUDYURSAxj6ZVJcyEWZlgw?=
 =?us-ascii?Q?PFqKGWSuLA7nSB/IPIALin+UppVoJk08Ytijt/WpgCJCz9ZPiU20rESD64AB?=
 =?us-ascii?Q?QDUAEphbuSnQKCU2omGW9rpF/2tcsHry+Lpb/8savBkAcL7UEk25sWplxdF/?=
 =?us-ascii?Q?LzRxkTS8s8Mt6EPzvDRJN1lAbxPa3RozHWEtpgzfLmdv0SCvKSyHzbJA5gYP?=
X-MS-Exchange-AntiSpam-MessageData-1: QenJdrpH/zE/yg==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a88e690a-3473-4e0d-6d75-08df3b047102
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:17:17.4500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5WGuv/XSnK/8pWy/MGNB26iIgQFkH6qJdjK5HcS1pZ0ibEAG7Qs7n7wkwrbbOxVPU/ddD/n8Vf8+JcVz0+/7BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6496
X-Stat-Signature: ky4ce6o6tqe8moobk9ec9eh8qm1y7n3f
X-Rspamd-Queue-Id: 6AF6E180003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793859443-374432
X-HE-Meta: U2FsdGVkX18UObPzsOed2eLHAR7vpqtRaAhLROt/mwVJxmxfoH5Id/CYGZjYl1Ub93i1XLV1yU2GIayFQ8/30wCm0Nle9k8cmiZK3/S8eqouaMB82y0Sf9MNIjzPyXDq74yFOwIP2xH4wXmgPDjTi+tL0nrMOxJMHYBz2T/7A31lgDR/dKy32kCuoKojxq9HRt391Z4tOtx7zKem6fRj0g9XE1Ssr2CpUCRs9VRoLAxVn5I2vRyQevrY2TR/v/0BbhB9Lyyhu5Agh6y8z32rN6YyUwdPJOE5AxIHE65rmsIDQDRYpEhA33w6Q5e2df8CWNOx+VIEPLkMYVaUwbSD7T76nmM5b8pIsPh7p486hlZ/8UEQn+TGeS1RIIPrQLh0nDM+fa2oK1klsTjvnrUlFUYL6N1IdQh7Qm6VodaEzuCHqX1/k25jmKsZsv7+osVUO/1fMgROLFxq4KXkhkO2CJKLyW664z7nBRS79S4L8/U1zl4bp+uZcFd2dJ9G5ZaZRLcMvnny2+OEk6IrKa1q/tjoBt1lSbBz/JoS5shz5GhobRZSTcBnVESZ55jb7nEuxvN8j1bz4VmoWq2qrHbiA+0MqZu2ph+t50O9o1LhgygN5yNVUsX4S+nlC4oc42VnKAmlk44BU3O0fQyHPdOgIZGqPv/0pbj4AkJb8nW6hpOmqCj3T6MAQ6OF/WlGoL8eTT+ZU0q8bwmzB2GSA3fpTyJCCyL8eDn10+b6Qv6WmnLrXyDKOfNhMGTk1nK29l+Hgw2T2QerGFkjouH/ZrJDAbhSiDh4/12Ud/xsOsz146SSM0cEZ8HGshLQPEmqgYMNgepQWgMrF2qn/lAQ9/A5GvoMuWK945Mo9tdJ1UbOGVhazCelDGOBMNUsLvbDUr4el6kFkvems7KNdxetoDWyZoDN7aJl5yza+kqjKbN8JkazkZNGLVNSf2yTMViiG3ml4LvZqB7FEw2/ogN8I4a
 k3ugQgXR
 GB1dmq+/YyI05WSZNSK4tApmgwxT+RwDM11EXO79WiF2DrGfCL0DHLEW/nGB4YU28zBmhh9lgpCV9So3C95Uj/rXnlgQ5JsQBhWE6DzXmfr9Asx77on98B6iG/1AhDJ+ROOwNyBACE6n12BpB0a2wnUgnWfp8zPpHgm5za2kaZzlg0GQHmR5DcnmwplsVyjOZ9M+69BaEn1rQjdfXg1CXAEvB5qdGmWYzK9p9s6y5RlbAt/SftvM9xaksSOuL/dZPMkRmD4Q4MQd25xv9z+92ajyaG/EVYo5Z1mZh25h/VQ006Ymp2AvrMGbZZpwaM/XwgJ4c3TqNknv34sPva0DvaUooqt258D2tp96iT6TLijypXhAEY01BN0PPeJVnHuaWy07+PhSpkCwPh3vslblXVO6uoVc+8K3JVvpnbIsRy6ZDWa/Ma/hfrVJ/4SvrIr9AGNq4dACKIVUcCXH+5ZN+KkhEmj6aM9ShrnSEqRhgCzhko97zglDOhI+NZYv0vXKJuVlAq9aXVsfbaduu04VtmnAg0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 03:30:21PM -0800, Joshua Hahn wrote:
> v7 --> v8
> =========
> - Rebase onto mm-new as of 11/03/2026. This picks up two memcg series
>   that required some rework:
>   - Kuniyuki Iwashima's memcg stock cleanups were worked into the
>     series, so the changes now live in page_counter code instead.
>   - Shakeel Butt's memory.high rework. Commit 4/7 folds in his
>     PF_MEMALLOC change into the page_counter checks. This change was
>     suggested by Shakeel.
> - Commit 7/7 is new. It brings back an optimization from an earlier
>   version of the series to let stock charge only accumulate on leaf
>   cgroups.
>   - To accommodate this change, sprinkle in READ_ONCE() for
>     counter->stock reads since the pointer can change at runtime now.
> - Cover letter rework as suggested by Michal Hocko.
> 
> INTRODUCTION
> ============
> Memcg keeps a per-CPU stock of precharged pages so that small and
> frequent allocations do not walk the page_counter hierarchy every time.
> Today, the stock implementation lives in memcontrol code, even though
> the operation it caches is a page_counter charge. This makes it
> difficult to add new page_counters to a memcg and preserve the fast path
> behavior.
> 
> This series moves the stock into the page_counter layer.
> page_counter_try_charge() consumes the stock, charges a batch to the
> hierarchy on a miss, and refills the stock with the surplus. Memcg no
> longer manages the stock in try_charge_memcg.
> 
> So the stock keeps the existing layout, which is still a per-CPU bank
> of 7 slots, each holding a count of precharged pages that it hands out.
> It maintains exclusion using local locks on each CPU, and for remote
> drains we schedule on the memcg workqueue.
> 
> This change gives us the following benefits:
> - Separate charge caching (page_counter) from charge policy (memcg).
> - Makes it simple to keep stock out of interior cgroups on cgroup v2.
> - Prepares for future work for stock improvement, which can now be
>   isolated from memcg changes.
> 
> With this change, make sure to preserve:
> - All locking behavior is unchanged from before.
> - Non-leaf cgroups do not hold stock. Specifically, their stock is
>   drained when they become a parent, and remaining stock (isolated CPUs,
>   concurrent refills, etc.) gets drained lazily on future stock misses.
> - Exact charging for non-spinning callers.
> - Stocks only exist for the memory and memsw page_counters as before.
>   Other page_counters (swap, v1 kmem, v1 tcpmem, hugetlb_cgroup, dmem)
>   don't stock as before.
> 
> EFFECT ON CGROUP V2 USERS
> =========================
> Currently when a cgroup becomes a parent, it doesn't drain the stock.
> Rather, it just prevents new charges from accumulating by nature of
> parent cgroups not having processes. Here, we can do a little better.
> When a cgroup becomes a parent, schedule drains right away, in addition
> to making sure parents don't accumulate new charges.
> 
> Everything else is preserved. We preserve all draining, refilling,
> and (un)charging behavior, including the uncharge path's refills
> and direct uncharges.
> 
> EFFECT ON CGROUP V1 USERS
> =========================
> The memory and memsw counters now have separate stocks, which can hit,
> evict, and drain independently. Their raw values can therefore drift
> apart by the stocked amounts, even though every charge is applied to
> both.
> 
> To preserve the user-visible property that
> memory.usage_in_bytes <= memory.memsw.usage_in_bytes, the memory
> value reports the smaller of the two values. Both raw values are already
> upper bounds on real usage, so this stays within the fuzz that
> usage_in_bytes always had (and this is also already documented, see
> section 5.5 usage_in_bytes in Documentation/admin-guide/cgroup-v1/
> memory.rst).
> 
> TESTING
> =======
> This series should not have big changes to performance, so I ran some
> benchmarks to verify that. I did testing on a 16-CPU, 32G machine VM.
> I ran repeated anonymous memory faults and MADV_DONTNEED to measure the
> CPU time spent per page. So + number is worse. I ran each experiment
> 5 times, with 4 workers.
> 
> +-----------+-----------+--------------+-------+
> |           | base (ns) | patched (ns) | delta |
> +-----------+-----------+--------------+-------+
> | cgroup v1 |     890.6 |        901.8 | +1.2% |
> | cgroup v2 |     893.5 |        902.2 | +1.0% |
> +-----------+-----------+--------------+-------+
> 
> Based on mm-new as of 11/03/26:
> 74d73ffcffe03 "riscv: mm: fix concurrency in mark_new_valid_map()"
> 
> Joshua Hahn (7):
>   mm/memcontrol: flatten try_charge_memcg control flow
>   mm/page_counter: introduce per-CPU stock
>   mm/page_counter: make page_counter_try_charge() stock-aware
>   mm/memcontrol: check PF_MEMALLOC after trying the limits
>   mm/memcontrol: move memory stock to page counters
>   mm/memcontrol: add stock to the memsw page counter
>   mm/memcontrol: restrict memory stock to leaf cgroups on v2
> 
>  include/linux/page_counter.h |  35 ++-
>  kernel/cgroup/dmem.c         |   2 +-
>  mm/hugetlb_cgroup.c          |   2 +-
>  mm/memcontrol-v1.c           |  17 +-
>  mm/memcontrol.c              | 430 +++++++++++++----------------------
>  mm/page_counter.c            | 233 ++++++++++++++++++-
>  6 files changed, 430 insertions(+), 289 deletions(-)
>

Is the main motivation ease of addition of page_counters to a memcg?
What would those counters be, why not add them here?

Balbir

