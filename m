Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05552606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 17:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aAOnNxxr
Received: by kanga.kvack.org (Postfix)
	id DCDB56B05B3; Tue, 17 Nov 2026 12:36:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D57EB6B05B4; Tue, 17 Nov 2026 12:36:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C468E6B05B7; Tue, 17 Nov 2026 12:36:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99F5B6B05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:36:35 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3139840537
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:36:35 +0000 (UTC)
X-FDA: 85445315550.19.3554090
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011022.outbound.protection.outlook.com [40.107.208.22])
	by imf10.hostedemail.com (Postfix) with ESMTP id 44768C0007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:36:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aAOnNxxr;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.22 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794936992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=acFQAvj5oowsvPYTuJm9/E4VuOuVQQXZLKjxZBQzLp8=;
	b=J9JVOOnQ9w2JUZhUR+mjW1gzjAO7/RmhQ0OBT8dun8HX7RvPmwCDALmKoAacfA4nqvMi8t
	tCBkqUWVsTUZT7/HhxtMlgVzH8rVGjcpB4APlTm3H6RibrYN6Ta8clhtQkWQjJgilMOFr5
	IRBC6QeInSzLmQ3AZL+pfZOSu2k6RBc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794936992;
	b=YB4mP3l35j6mjXvueGmMLglWM+6PnalzPGOb1o8yIV8kZOunR2yhRAnMDG2Q1xTdzbHFeZ
	9RotiCv6YQvEOIp9R/PPkA3FlBSVYqqa+F10UIP+tGZbElSKKSRIcQIDmad7KTTB/FsVVs
	eUWftlkCdnJqGvWvLeIIc8rpf+WSrKA=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aAOnNxxr;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.22 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aI0tL9avWkoTWCkKD1qfqMEKg+rxoIyrziHA5rN+ZmZD5ozeHxU7Rg2UfsoDllSbFEoihwqR8EDn9kM0ovLjguZpMlS6Gz/6PhcbbBPvekAK+L4suk3KpxFqtp1IBSyzIYAs9OjT+c7Pa4T3qllybmZUX9zT7ouq4GOftzYJumddtYXWajoPlP9dkrIv+tZXWLn2D1tjgFDg7Mk5FL633cKDWrfgcykhfaTAghh5Muy4xxhyFybovsUZmhoXyfSMR8Ot/XB1qD9tB2yWrxvmWHvXXckS4s7pePvtfjlvSDUFzjlINR3EGcp9uWHVN92qivp6uH6LEN9+CbqXbzcx8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=acFQAvj5oowsvPYTuJm9/E4VuOuVQQXZLKjxZBQzLp8=;
 b=WLbgMdNFNbC3NwE0LF0yoayWtPm+jkJRQ7tCai3roVhITRO51coU5kny5MsVaeyzU70At7DiINORV27Gm9dr9GJXLfU9+BO3fJJD1QD4BnFsV1RKLC/ALW35WQZv/GlwTB7MJxa5EL6MFWi0KvDcZYw7YvfHrxsxAahtFpL2l1Jk5mRouTfGUsv6S3UOcN++/n/wnt3M6sNQYVL4aYr1TsttEbihs4OhDqaepchfPI11JxyF4Tcn/hGhS97YJdRTTAabFBDse3BDvfA3UcxCbbPDbPMKp8EyPt436c5qNbBqWnQC6djr+RqMlYXMOXuFavjLVKHu7K4VqnbYM8b+1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acFQAvj5oowsvPYTuJm9/E4VuOuVQQXZLKjxZBQzLp8=;
 b=aAOnNxxrc6U0/hMpH2zD9RmKuu3QIY6Wq2xw0tuHVQeskfjhMUhO5+U1PJF5mmhvovzxDzbtsXs81N01WiemzJAazI7nPTXCjdKchwzTV1Zuac/aNoseTEHRVZgSYwQR/35SBHDxFWfwTYgxynU8NTYiJPjRIwxpWLGJEksJ0YfOwB6emOijbpFIeEwBZq/RuUogLAdoHHqw/f5jrV6xRV/rdkqM7M8vwjmK9ddGqltIJ1ZPP3PubYkxG9asXls8jMN51KX/kjUwHk2nxsmzrkhYZBXQnEZasso5bBTYZqESh35hd/6fECNmDGouRwNsZqEd7pI7GV4jTyEihNmv8A==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SAVPR12MB999121.namprd12.prod.outlook.com (2603:10b6:806:4e7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 17:36:07 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.009; Tue, 17 Nov 2026
 17:36:07 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Alex Williamson <alex@shazbot.org>, Peter Xu <peterx@redhat.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>,
 Roman Kisel <romank@linux.microsoft.com>,
 Saurabh Sengar <ssengar@linux.microsoft.com>,
 Naman Jain <namjain@linux.microsoft.com>,
 Michael Kelley <mhklinux@outlook.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Eliav Farber <farbere@amazon.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/memory: remove racy huge PMD assertion from
 walk_to_pmd()
Date: Tue, 17 Nov 2026 12:36:05 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <BDCBFC48-EE2F-4D4F-8C0E-C28311907102@nvidia.com>
In-Reply-To: <20261115-huge-pfnmap-fault-races-v1-1-537605643f6f@kernel.org>
References: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
 <20261115-huge-pfnmap-fault-races-v1-1-537605643f6f@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: IA4P221CA0003.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:559::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SAVPR12MB999121:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a2fe2c9-7ae3-4392-a655-08df44d14318
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|18002099003|22082099003|6133799003|11063799006|4143699003|56012099006|5023799004|261102123227099003|261026121527099003|261021121427099003|261022075727099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	7jPIWFmHEs17sRhmSnXIz6iZUscZC0LoDxIVcN9Cn6WXPSbj1Aw8O1UWw5qryXhKqLyR7aUBEl4KeWZbINclj+KKNI81AHE9SmPHU8VD9HNWCzUfo2atHCLmlme1lgvIUbjCNFESWLENgyYA8n20SOCrcIe4n9jZeeEyq6IhxhizfClGq4qoEL9AA9PNuAQNYkknEu3xSh7j0eM5JgtPkDJPvoQ+QAaN1XhVhXe9ADxrwsmKxow3IYXY03PF8l6w/AbPKOttuL+DUYt+78LNJniur1Zv2T5i6rP/5zVDDuqA9ghr19LuxcJZLQPmhIUbhwuQB8B/JdbTZ4Q4fq6FLGTjizkDWEj4Q5ZGBWNeSq3y51/kCLDeuAZa38LxQV2Ty9tvsKAsq+ku9XZQmzWAtZ48mI3+e76TVmRH6cjGZaaJvO0bDjsMpgenmftrwEGr8+nLTGOxUE1E/wi+kwY4dv+4d5t9dexG416XrcMLvnOs7wIma31Bw8tVL0YAXik2uNCrFsXklO4sZwULOKGL24rA6rmy4pRbFLBo5vPWzQqHW/XTbX35bF1TrSvsv8DpH4SD/SkWdguIaZLkMEbcnCyPT58WTSSELYLtQErB+xTDHOqPSJGuy4lXgRbNaKdkH7cgXREpf+9dp+LdTJJJx0BYZXxLN0ER3vUOqqpuOmg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(18002099003)(22082099003)(6133799003)(11063799006)(4143699003)(56012099006)(5023799004)(261102123227099003)(261026121527099003)(261021121427099003)(261022075727099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rOV21GbPaMBG089fde6qJaEMBSnhOiMWIgdD1iC5lB62xQAnukxHS3wkRwO+?=
 =?us-ascii?Q?mbL7FfYky17Hszd3G65ddhC25GtkOqO6f+qD9EvRlD8KSw+eGBDV6C/fuUZA?=
 =?us-ascii?Q?Nb2bjeo18IUUhJ+W1ZScbgXypqVUv36Cv2Oe0m4lEg+v/RYKf9jI0+P/0tyP?=
 =?us-ascii?Q?F5hVk6kA+UqP4hmAPno3NqDg4OxoIZiDmP/IE85CcBhyOHGKt3s7D+iTofHV?=
 =?us-ascii?Q?7vd/+RMeT6RzSTophA3OZ7U6PzvshKPtPArElrAE+fmnulas+sjoCDpeX5Ib?=
 =?us-ascii?Q?ZVJtwUZ9hdAjbSC3JCYPlzD1vjKAEicdOgn+vdqAA9BUURNtmbZD4SbFC5d7?=
 =?us-ascii?Q?5VwufaS6uflC6m1w/EQhP5l/HDYWG0NlV5vpSkPNSdFkKfHnrUSUE+B5Z7QZ?=
 =?us-ascii?Q?OLW15uA9NqnIBb+k1ZLpoiHUnGpK95IqJ6YphNdHij04IInSDrBx71aesz29?=
 =?us-ascii?Q?qIUiDZbvf/2NkUhwK8+U44cULRUWR4ubT0UAZaeDqx2Gl8El9tRW7HgRVkqu?=
 =?us-ascii?Q?usn1oB1zav2+TA/B20BmMGRBCTu5VO/gvST50kEUV+nPHWVhgYC6ANL8z1Cl?=
 =?us-ascii?Q?oVHCdu/bmuJj+Lw3ZkihENthl+nrsbeVDtOqyh5ZWWFLo751Inj3hDqedNqO?=
 =?us-ascii?Q?F9ydQUZhRIR5bpLnD+wxTOPuQDXvp0rJcN0ua+gE/zy1mAxQnB/SVlCEX6Yy?=
 =?us-ascii?Q?5fN0MuNvXvgRQoXr3e4XJlZOizbPR0qSdnxJyiX/p2dnLDovLh8WxW3SgZDo?=
 =?us-ascii?Q?yTHtVjHnSucMaMwwXVnEVN3LvPicwQnFhJnCJTqQDv66v2ekx++8BD9Co2Jd?=
 =?us-ascii?Q?xJNCKqeJcmLdut+lh6Qki09wjoSq3LR2kwcMYjmvi4Sem7tddgpOOgZeM5Zj?=
 =?us-ascii?Q?wILS6IwZdkQVZvR91FJwPLiOi+iImwYH6lmZMEKXlBE5Lds3OpumdiwOcLPD?=
 =?us-ascii?Q?7aJkPS+jbKPEbMAiYDYp6W09komgQK2WZ6eoMwvCH5Icf0CnwYReUUDoV3XA?=
 =?us-ascii?Q?NBuJ+Ry2UESqUYRJgY6YR1bbiXem+RQgY9cMW+9v4Oc/e/vyLS6e7KEfYRi+?=
 =?us-ascii?Q?r2MpWx36NTLLW7PR6uvVHDDJ8nRKltQwx17vkT+jmmsnKpMfCfLi3eJ3zNgM?=
 =?us-ascii?Q?drU4kCplRDcuEqJPmtt+L6M+kxFvGFr62CmYEHfZ+8Nuen71uofS36so7V0P?=
 =?us-ascii?Q?uxG/COAhEBlJ5V3ym2H/FFzp+KDrJmkLRhY10Jwq9nO5mq9C3s+b782LifGm?=
 =?us-ascii?Q?jgUEQGNMAo8fB9+MO4roGfOk395x9jUiitt2RqDR5pf/QJ5i8Nb8Fn1amPbv?=
 =?us-ascii?Q?7uyq12DqiZoK7vDix9SHVfUFbho3DkLfRm9EMt/SdJWO27+FxwRfZ04EZuOa?=
 =?us-ascii?Q?im5+haBlmXBR2HVESzI0kvJOi/qOoLwoUa0eFAd35DLl+OEHUpP/j2R/oB1+?=
 =?us-ascii?Q?c/ZJNKEUa2jzzbc1JfCHuzLtJV5YgBKF9uAYsSWva6jr58t9P29REyvWXibw?=
 =?us-ascii?Q?vkAML6t+Yh3TNYvHEYrRe4w+Y7Nv+PyMkpzSFyk6az5Gi2PjNa4WY96fcjof?=
 =?us-ascii?Q?AGP09NGAdn/1WBepODE1j6drufxS/lOKMDO9wvMT3lxfg4utGwHn98+2ShFe?=
 =?us-ascii?Q?HUpbDq6AyAhPA2XNfeGPMlXxxwzXs6o7b2Fd1wDBEfnbirdjj/VIl8eQTf6r?=
 =?us-ascii?Q?dAnzO7TqAlmAdEHI7qtq35cOgKo8BJ2ybeV7Sytqu9m0H3tj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a2fe2c9-7ae3-4392-a655-08df44d14318
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:36:07.5467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P7g7w7NgUTVGHC2Y+D1UO0ugDgnj8Tq4Xgp+u1lfFRsbHQd+t4ixdycgsZKWzncz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAVPR12MB999121
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 44768C0007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ptdzihdu3h1ageyfoof87rrqut6di7oe
X-HE-Tag: 1794936992-7772
X-HE-Meta: U2FsdGVkX19233AKnYbwxgiGEogV8vFdes+AkhryicqMNhbRU65v/7kv+4eCShnkFMbBPnFXJxC3pPrcee1SiSRd3qSJ4KUbLgBhGpcX1oTVhuYiLD4Awc+udKhOG7mEoKUopwPWmQcXbViBQcSCdxB5/WMMbC5hrN7+eANExcMdz1Dwa9f7lrTvqcahyk72KoXswvisa8O0SbKuqxhT2E0omViwuX54cL/Ku7GCwyhlwwDjcqN3WmapmDBCAaPTLiV2MroL8Xr9Oh7d1gPdOdUif9X1gsUDT1aT4e6y4vIE6IAVsSKwCfqovT6UBA1QOAT/UKyMPt9kJpU23QVhKPCAqW7n/owkaBVAS+OYaFDtWw1vQUsJD9oIh/BNKBrjVxD4u/TN2VgxEVDzgeSoiBuilnBPE/GLOOkgX6/Jyk0fgr1BvVL2Nv6fg7QF8Hlw2h1evuDeGfzOeXltNjLuXOHDyetHhJ3GZTE+IYE0Q07MECWZVtnb6zqIjmTrRbTr4WejRs9WYZ/NpuGudt+QKCTotgbDa6zc/XQkNICVO/1LMtZeyVuo4DAcQ83qQgfcwbMaKoeG1bNE1iFWp+m3nWQIg9Hz5ravjCTt/4+S7tIbOGTuyu6y5MO9/XscMcKLtzh2pif/rUQxpE9kQR7PMfZ5VTltMreIuwG12/Vm7AqYRJEeNr7DWCmMFU9+GbssoGcYZVoN1IMn9jYiBqih5WN2ffXHeK2lDjn/ahc3oL7YWcX5t+iO7d71LwJ5za7yqzA2b3hybR/Wpvg0WvKJe8kVVsFglvZ4y1gexJ9Pg7H5I6GQLNmjVbYDYHC/sNjCxnG8G3qDOkcFf9Ebf7gnKzS2NvqXlxjfbD/hzqrDKkuI/HzVKipELuEQL1Pmv+guYK5UFDaFI70LCjAYV/HpiLNnBxEk+Lx2HXvAQirbCg/KG+QlKAweUojlTqqmqXeSnNN8whNG8iC5AjNU9Ed
 cWGcJiha
 vbPouI5Z5xVOTy0DamEud33khyk4J7AVgpyiYVDSpjbQNm7Y5dSwzuANpEoOBi56E8oscV9LEpFLVthLxgch4NHVaMKc7msTRxagDZUA+TQSlaJvQg0XYXtm+99qaK2qDKqHI2+LRKQxjyiMn5H5N7M3GjGHn1Y1rE540Zbblgl5t7+XD7HUk1DezXk4Sd7QpPbukThOOBK4PNOaqeueuFto/L7yobbZb5EguhcPxfzblZKnALDs43J/qiT0s7JN9C46oHHlkj/5gxLXPNftTs0O4hDiF6NOZ0izG+Qf21PPAwFh6F4JUhHecwCQOJOxnpngRsAjsuCoR5FCDhm70mbUVhXMeZVF02oAD80kbUsiaTi+90Bx4kbtBIg/pEJsqw3VnkchtnO1Yq2fRFjFbGxvLGdoWhCycJ9FusphBiVbT+238iB4RjR2y3KZKXCEJ0BHYVLv+KSxDQt60CRFMglqBCnVi6t0jNCAr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 15 Nov 2026, at 15:58, Lorenzo Stoakes (ARM) wrote:

> From: Eliav Farber <farbere@amazon.com>
>
> walk_to_pmd() asserts that the PMD entry it returns is not huge, but does
> so without holding the PMD lock, so the assertion is only valid if nothing
> can concurrently install a huge PMD entry in the range.
>
> This is not the case for a VMA whose driver implements both ->fault and
> ->huge_fault and which invokes vmf_insert_pfn() from the former.
>
> The existence of prctl(PR_SET_THP_DISABLE) is problematic here, as it only
> takes the mmap write lock and faults taken under the VMA lock are
> unaffected by this.
>
> This can result in two concurrent threads faulting the same thing
> disagreeing as to whether to attempt a huge fault and thus ->fault and
> ->huge_fault running at the same time and triggering this assertion.
>
> So just remove the assert.
>
> Target the commit which introduced the first driver able to do this for the
> fix - vfio-pci. DAX also mixes fault orders within a VMA, but serialises
> them using its own mapping entry lock.
>
> Link: https://lore.kernel.org/all/20261112051440.16140-2-farbere@amazon.com/
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eliav Farber <farbere@amazon.com>
> [ ljs: rewrote commit message ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/memory.c | 1 -
>  1 file changed, 1 deletion(-)
>
Makes sense.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

