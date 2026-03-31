Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9387FF60CE
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 06:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 140E36B0095; Tue, 31 Mar 2026 02:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1189C6B0096; Tue, 31 Mar 2026 02:35:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02E086B0098; Tue, 31 Mar 2026 02:35:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E6A256B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 02:35:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7A0101A0B66
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:35:06 +0000 (UTC)
X-FDA: 84605395812.11.6F1181D
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012043.outbound.protection.outlook.com [40.107.209.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id 77B2F140011
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:35:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CBhfIC4Q;
	spf=pass (imf23.hostedemail.com: domain of apopple@nvidia.com designates 40.107.209.43 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774938903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tkJBRq0zp9dAMeBFZXZnaOjmVQcTgDSxU9x7UGOmats=;
	b=aUS1vHrjYkpSdBHR1YRBkcTxuWx/Ejz1B1LJJFIFlNe2Io5ryAl3GtN93Ee8V4vWTn2MVW
	DDuhpl+8/QjkZ/UTiJuwofLkD+vyr4pyvvlhapO1+q1GViHZw0hMzhjzPjNZ1zSrXIX14E
	xwgTHIi2Wjf9rYpDH/0eoDpyopSkey8=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CBhfIC4Q;
	spf=pass (imf23.hostedemail.com: domain of apopple@nvidia.com designates 40.107.209.43 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774938903; a=rsa-sha256;
	cv=pass;
	b=OXAMZzjTxA4rpYbVw+Sdlf5TUuAt8e8coYhAGdSyC8RNHur0o99TrNXjTjrWMhu9prlLSm
	7apyPdKaqxf3v10K6X62iZ+PPPA5eeLdrwI/W60FwmpQ8CxqLBXTTA4Wy0zPLy3pYTb5Ug
	9kD/XiVUA6NrCzrrKdBi9InuTzISs2E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ejVgyLDEf5B+W4egX6KXd02f0d9tvOZ9epBr2U0fM/ks4FIOUx6c6TW53OQc9D4AjNgEAWR4tbK7FWU8qtsXijYoGUNsjNch8PlwqtrKwHCojdj0QvWwJQ/Nm/mFjH8WzRsg8wBkmiDiWF2KEwmDqmM1Ek9fnP/ah9Xfm1UaZlRW4bC1Q6Vfpx/MvPffukgpiW8C8m4CjWHw7N3wcu8iiG6sfU2xGazlPvasqDTr7aK3e8LY59xqrrZrFdof/oNNBY+hzgLZbC+C8EjArfPEWKn3uv9uOCeJcOWotnIYWEf9YpiaB6EESc8OxrMORfxS4iKUw+Ey8AjksY5LZOtftA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tkJBRq0zp9dAMeBFZXZnaOjmVQcTgDSxU9x7UGOmats=;
 b=tPO5ckjLuJN/MHZwWXjizuklTxKasxjryj7SQSPcWQvhgiczBXq5PMCJv1t3X181irNhvYy4YOsXc0ngY4Ms2GLIONGRUX+qVT0dJ8PIyS/tE4NYba1vDYYJsva1PRGbLTxK5FMr9DxSFpqwRJcSNKoOD7DLqROGba++++z5CrsP7qHKlvKjApqKyQd+6n2a7g6z6i83qtV8+YTCFKrBFdXs67CVIK+8M4K01s49b8rFJaMtuSlAUdl6Qq0tIu50+/N4x/2+wnO1mkF96CRUGCeBK97I8X4ZvJyeYO8ogqBCH7m3rm5SQXpMP2woAQieJ9rNXc72h2qPQ0mDr0r3gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tkJBRq0zp9dAMeBFZXZnaOjmVQcTgDSxU9x7UGOmats=;
 b=CBhfIC4QetqaNEIzq4MRsqaSGn5uNgC5UEYPSrWRwos1iEOYvEG5s+IFGft/aglkRGCTy3hnfxOIQS9qdGhY1UOdFUe9R8g77u3DOwuHCBPqquh1ULCe8aBdA+dIMkCJeN0f06N1BYsnFVGRyvkx7sngv5cIwR2xxOxIxlDCypixb6IZnrOtugrWk6r4Ouim7k1orEo2iS1nmkh3tbv1/3dM4GoZCoYZLjx6pv8Zaki/vXq9ONtWRcYdFU+12OsvUQyRS74oDRI+QYxaqDgpkZ9alrr38o3s22v4QX3AaFedxo4n0UPWpUofj/LitRiHev+muT7wMSpyVXuyexYTmA==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 MN0PR12MB6150.namprd12.prod.outlook.com (2603:10b6:208:3c6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 06:34:58 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 06:34:58 +0000
From: Alistair Popple <apopple@nvidia.com>
To: linux-mm@kvack.org
Cc: zenghui.yu@linux.dev,
	Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	dri-devel@lists.freedesktop.org,
	balbirs@nvidia.com,
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH 1/3] lib: test_hmm: evict device pages on file close to avoid use-after-free
Date: Tue, 31 Mar 2026 17:34:43 +1100
Message-ID: <20260331063445.3551404-2-apopple@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331063445.3551404-1-apopple@nvidia.com>
References: <20260331063445.3551404-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5P282CA0033.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:206::10) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|MN0PR12MB6150:EE_
X-MS-Office365-Filtering-Correlation-Id: 26c813c2-6507-465d-ef3e-08de8eefa11c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|13003099007|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	HsVsdvf6RIhFLi0TvJURS89xIT8CbJHtBVrzhDz5aj4TWq+qmIVxXGX/A5hc5axEOcvcipiQurBKNXpMj7KoqtJ0/p8LhOXOxXrB1My1t13pOAfd48wjT7YUenXzFL7YRoBLJrL/PDkJiFc7w9TBpqyBUpywPCcRqj9ip+8H6N9LFs977mytZehuyC5niyETQhNXbg0NqAEkxXmhqLA/2V0sUWcFAILx3DC6EVOAx0HM7LBrxEijaK58NCloDw1tcEZr+4pUsThBdNdnucm0rYT4g/OOwd4gp+aGARKuaympdz3mv/gIOGi6UBGwTi5uKPJ0QXVvwF+ySp+sr/PjiX71DRuyy6Q7lh2070paeqBZH72IwdWXaI127qs2xIIwalvGvYuj/BWIYIm/gs+GPyggU7Xu9/ONkFhWb7BTOoB3o+DWuTwC7caOFW8WWZ+Kfdq56c8pg7l4Z3JWdirwk2WYrtaQ7rDgekSV3kX1D+xXCoX2jN5ymNdRf/tH9KF6XgxWH2z5cfDEeqRfct0WJGcg8HyHBi72qsxwcZguTveWbb19vtoJl4k3dsgGb/244EE5wcA6a7F7m8/EVNegMjwiWoKJOF5puRBAlm1JYhxPosJTxcC5qfM1ip4213x5YxTUY9DKJLSaEZaLEEe9pYUd10fUfDOPS/eTbpUJTFzI2RqBM8oNMkSkm6XZLu05sKOEPGN7YaRbBeAXOM62H1sjKRB5/6x5XHMQZyGcmhSa3/s28ZWzrJZeEE3vTtNo
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(13003099007)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OQL3Y8Wdv4K1Gvttq8Bn6Y6zjwx/AH0QEptoJuFsnzd+IMp6vaH0VSEtFI/2?=
 =?us-ascii?Q?5xf2juGNfNbymfGdSrSTytoQf029sDPYB2Z+xYSQzazUldDG/ksoCFnIJfj1?=
 =?us-ascii?Q?NjMpWBXAN18tEMZZYDJ8y669mc/0SipZZQP1wPpgxCg2XQNxBpZJqHa5Gxcq?=
 =?us-ascii?Q?oMm4FPa3TszssUi7QT7zpsbPlZGsl+kJ/NiWTIDPhvPbKHSupDpvRRGpttXm?=
 =?us-ascii?Q?UlvzbZufh/53g7ih7kVFMwy0ljo/TDEzv4Vzwnf4bPINJ9iShBDlbcni5MC3?=
 =?us-ascii?Q?hr8jNJgI1ge5nEJrJWEXBsAHy7gU2+Phr4cXkRSBJJF5tGZiI+bq9TEktjnj?=
 =?us-ascii?Q?ASUVypHHVtV8D4+hIV0epUcC43e6YnXWnTFMygLicy3zfyqVm6FNbo36wQ2E?=
 =?us-ascii?Q?ZFENQCLVddCt+PRQFJNA5b7uFh0Mjz+VX9NeyP/fdwdO5/PZ6zqtrdfd+yDj?=
 =?us-ascii?Q?7tVF1/d4/GjZGCUUKLQ3DBp4VoMqsyyf4DuPxHnBLG7rDx3azIxelbvm8tws?=
 =?us-ascii?Q?5K/rS8jY6MsqjGecsOdtldo07Mh/TYbC56cupBkbGenpNdozTnLHiiJXzV9V?=
 =?us-ascii?Q?0rMcq9GRqGhszMb/FHQXW4ksir8xWKNzQ499X2PbwO5hYt/LhOXbEJjlMirH?=
 =?us-ascii?Q?/ClGIVqxTiQgd3QfLXRH0Ik79OaXou2m2+gJzPyirDCPeLNGxmwvONDqvD6Q?=
 =?us-ascii?Q?WZES+fJ5E5yAOFtwl/1nEp4THd81Kue8z4/2yVmxQGOJHTg07KVlTPQS9xMd?=
 =?us-ascii?Q?K9xHemukfBt+lTQyxU7c5dYdPrxsPiqc5Hhs6JizL/Ehu/k9JayLXe+EVmsP?=
 =?us-ascii?Q?Ph7cISXnvzzMFOptxerAikg19LuqM8LCmv23+0Ue4kbYEJK1p2ASS/Lfl3pz?=
 =?us-ascii?Q?O9rR4+E7shkUeGWIZ143wSPxMfOTL9jbCfEAIeDYUsIyH6LsXwQQZ5FszStX?=
 =?us-ascii?Q?hz+qTABp7lBHplZxAZGdMmKS8h+0c8U9hbOO6otCZNRi+8GMh/pbA0xZQ8PJ?=
 =?us-ascii?Q?sAvd55UK1QRKqYkTH4N6aYqg/uBVHYhP+0/Y7DBEjSwSxmuahqHz2F9ugNR0?=
 =?us-ascii?Q?9fSS/bR4l5E20SEfx/V0VTLlYyKE4tmkuAeKZ1tUiYpxvYzLHOsSeTiAvizo?=
 =?us-ascii?Q?ppXGYzlUkeWOVdkpF4Ri3Rdq1ewcst+tUxbwa83h1F3/x6dhArAFJirR0hVN?=
 =?us-ascii?Q?+U2wTO6U4c9l8vy26PIK70XQk0/KmAa6F4gL7iMWW1299AUpbdsgX8cUEbZ3?=
 =?us-ascii?Q?YYcfyIXu2JHXsa7e4DJWl9CY6muyZl0i4KpUqjo7gwfK6Arr3JXrKtw01x3w?=
 =?us-ascii?Q?UAF/9FE/gBericGmXBCrPCLFJ3X5k1SGzEdc9BA+LMB5udRknOcvHzt30qHy?=
 =?us-ascii?Q?TvbqhMi8a7lR84/DQ9osQWVyYDccChcH5+opN4IMONBC+em7X8SGJjsa9xRp?=
 =?us-ascii?Q?6POAWG+AMsYRizTh4Kjbqbnhd33v8QDvpb08b/EBHY2c/bjO/m5gouHkWmat?=
 =?us-ascii?Q?/YmMPd2+BNJziUOl6PCTS7xN2ML27HOqg2wqGz3Pf05CtbCObVGaRlpehqrq?=
 =?us-ascii?Q?IIfZn1qqPpPHGCLnp7uHABT6Tyv0Z0mP1zQlRIUj4e1x/s0MI/GTTHT30d/1?=
 =?us-ascii?Q?2gQWyp8rSualcBg7Krqf+aZS+4BmK9gXJ6fBfEk4JSoUjdyczeBrCo6A4Aw8?=
 =?us-ascii?Q?c07kO8RSxVy319wLecZ2s92CxWEu1RJvmAOn4m2C3W54Aq05DKupyBglrfDE?=
 =?us-ascii?Q?wSxj8kU8Kg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26c813c2-6507-465d-ef3e-08de8eefa11c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 06:34:58.5997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9qoIk7+XHQPA+nQMO1Hq+pkbzY7/D5d1gcpOjabnboERtM2guXovuVDOR87JJUOZGGMG8wpGM+hfKR0qhJwQeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6150
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 77B2F140011
X-Stat-Signature: e7asomwwbrhisgbozfu691fd55poqgrg
X-Rspam-User: 
X-HE-Tag: 1774938903-7059
X-HE-Meta: U2FsdGVkX18VWutDwICQiMU6PqjXQVN7XrxpQK2o5HjrX7zNmgXmnvKJbrz6lhire4/kWUPB71V60ncQGnkQ6gloWI+uDOcPvyrhm7Cb3Jm5Pk8THC50H3R7UpreCn/v0BAQfmCx73F8n97Tb9yq51YJbkkNHtqixX4VMAyIM+yweuke/EtnzuiX06Nz90vKMd4nlL777faB58aBFNICT9Yxvns9sgtSj8smxvm3QNBjUXleAMsnNmH3x6JgzFf5kPRm2vDNwjdYS/v6JjD6d7jw/eDHdKXQ8i2rb2l++ip8JQNtDcNgrf9OKpRc09ypsqpeGVc2UEY7I4Dv23vHKFcVHngc351ORxpiT0+e34wNLnXiSEvVLmArl6Z1F/XX5GL+678EDKS3BO+1lBBopYW9uBcLRhj8zEpVXDTUNnDGR7DQWKptTg5WVbUVAF9DX/OEOjhyVo3eIkhip3Utk0Fr1KKrr7EXbUWvOlBag94wR/NMiadHa1G240YVCtZ1wynR2EItP3BRZXifdtM2eV8Y6lxBQGeDHzXYwfUCCAlTNSt4caKleWGMwFJ4PMJ2rcPzbBH6Vn4GFJOmS5YQcox56AtqtfUysHP407PrHXtlOxrDrs3v+xWPC3HrNdg1TTbQkrn951n+BSKg7h4sMhdgIPBh4CuwRcxck2QPRvqh023ieXij4I9xbLo7x6syL4yHbNoBbJ++QmcHqSpfaclPdmdhnA34wes6i41jE6R/lq5SMXW2j7Ic27GWPEkCG5jB4Ecr9AAHwH2+jS8DUIZbWfkuVHvKKy1P3lFCeISRPY8LPVAbgO1cSPC2Ykqrx28++Gpov76ywDM716TIiBmG37Edt4K0cg8+y5IUMM7Ej7Vg4nXhy682kpIKuU5WNXVEJppaZnhU1IcdmoZICAGB6Mo9wpGvULkFBRMkBNDa9BrmawUlS6VBjgzESSiW6XhH1vSi2oJOXT8JdBW
 nJ+zNbWE
 mOP24s4DlEXji7DSas7SgYdvZZr2m7xNN0Vpdbv/zSL5hBDs+8DgiJXJU0sa9vPd0QFPfqCVBeydAywqKxX226Vf4bjdy0TOrYCqx2nlU+CZdqCvkrKLSt3vjLSR5LmwvMhG3EwRPc4CEpgGAmOk8WUO4cnig1WNkW1qwn++Nrz99Z6ryUkwK/CvVUPcK7G8Un7DVTMV+B9Zu9e9b/2bCSLqU8JyqKhbRoAOb/giveU69k+nt8Kk88v6K3jDqj3uw+0vP3w8IHkQs8nMxn7yecqDStAZXVT4VIoGNqP/WKr47MqSU3ciEytgt4bE4gqd5o8Q66Hov69CPrwhXxpglUlpzwgUjNLgeAgxcGsmwWQxyHwFFRFi4R2gTpnSasRMzu8Ar9kaA694nkgbZ/iPuEi0STVPTowdL/lHAmhveW5HXaN6qc9DpIuk8+lGz0z4+ELS45IVBnxWOL8o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When dmirror_fops_release() is called it frees the dmirror struct but
doesn't migrate device private pages back to system memory first. This
leaves those pages with a dangling zone_device_data pointer to the freed
dmirror.

If a subsequent fault occurs on those pages (eg. during coredump) the
dmirror_devmem_fault() callback dereferences the stale pointer causing a
kernel panic. This was reported [1] when running mm/ksft_hmm.sh on
arm64, where a test failure triggered SIGABRT and the resulting coredump
walked the VMAs faulting in the stale device private pages.

Fix this by calling dmirror_device_evict_chunk() for each devmem chunk
in dmirror_fops_release() to migrate all device private pages back to
system memory before freeing the dmirror struct. The function is moved
earlier in the file to avoid a forward declaration.

Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
Closes: https://lore.kernel.org/linux-mm/8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev/
Signed-off-by: Alistair Popple <apopple@nvidia.com>

---

Note that I wasn't able to replicate the exact crash in [1] although I
replicated something similar. So I haven't been able to verify this
fixes the crash conclusively, but it should.

[1] https://lore.kernel.org/linux-mm/8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev/
---
 lib/test_hmm.c | 112 +++++++++++++++++++++++++++----------------------
 1 file changed, 62 insertions(+), 50 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 0964d53365e6..79fe7d233df1 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -185,11 +185,73 @@ static int dmirror_fops_open(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+static void dmirror_device_evict_chunk(struct dmirror_chunk *chunk)
+{
+	unsigned long start_pfn = chunk->pagemap.range.start >> PAGE_SHIFT;
+	unsigned long end_pfn = chunk->pagemap.range.end >> PAGE_SHIFT;
+	unsigned long npages = end_pfn - start_pfn + 1;
+	unsigned long i;
+	unsigned long *src_pfns;
+	unsigned long *dst_pfns;
+	unsigned int order = 0;
+
+	src_pfns = kvcalloc(npages, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
+	dst_pfns = kvcalloc(npages, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
+
+	migrate_device_range(src_pfns, start_pfn, npages);
+	for (i = 0; i < npages; i++) {
+		struct page *dpage, *spage;
+
+		spage = migrate_pfn_to_page(src_pfns[i]);
+		if (!spage || !(src_pfns[i] & MIGRATE_PFN_MIGRATE))
+			continue;
+
+		if (WARN_ON(!is_device_private_page(spage) &&
+			    !is_device_coherent_page(spage)))
+			continue;
+
+		order = folio_order(page_folio(spage));
+		spage = BACKING_PAGE(spage);
+		if (src_pfns[i] & MIGRATE_PFN_COMPOUND) {
+			dpage = folio_page(folio_alloc(GFP_HIGHUSER_MOVABLE,
+					      order), 0);
+		} else {
+			dpage = alloc_page(GFP_HIGHUSER_MOVABLE | __GFP_NOFAIL);
+			order = 0;
+		}
+
+		/* TODO Support splitting here */
+		lock_page(dpage);
+		dst_pfns[i] = migrate_pfn(page_to_pfn(dpage));
+		if (src_pfns[i] & MIGRATE_PFN_WRITE)
+			dst_pfns[i] |= MIGRATE_PFN_WRITE;
+		if (order)
+			dst_pfns[i] |= MIGRATE_PFN_COMPOUND;
+		folio_copy(page_folio(dpage), page_folio(spage));
+	}
+	migrate_device_pages(src_pfns, dst_pfns, npages);
+	migrate_device_finalize(src_pfns, dst_pfns, npages);
+	kvfree(src_pfns);
+	kvfree(dst_pfns);
+}
+
 static int dmirror_fops_release(struct inode *inode, struct file *filp)
 {
 	struct dmirror *dmirror = filp->private_data;
+	struct dmirror_device *mdevice = dmirror->mdevice;
+	int i;
 
 	mmu_interval_notifier_remove(&dmirror->notifier);
+
+	if (mdevice->devmem_chunks) {
+		for (i = 0; i < mdevice->devmem_count; i++) {
+			struct dmirror_chunk *devmem =
+				mdevice->devmem_chunks[i];
+
+			dmirror_device_evict_chunk(devmem);
+		}
+	}
+
 	xa_destroy(&dmirror->pt);
 	kfree(dmirror);
 	return 0;
@@ -1377,56 +1439,6 @@ static int dmirror_snapshot(struct dmirror *dmirror,
 	return ret;
 }
 
-static void dmirror_device_evict_chunk(struct dmirror_chunk *chunk)
-{
-	unsigned long start_pfn = chunk->pagemap.range.start >> PAGE_SHIFT;
-	unsigned long end_pfn = chunk->pagemap.range.end >> PAGE_SHIFT;
-	unsigned long npages = end_pfn - start_pfn + 1;
-	unsigned long i;
-	unsigned long *src_pfns;
-	unsigned long *dst_pfns;
-	unsigned int order = 0;
-
-	src_pfns = kvcalloc(npages, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
-	dst_pfns = kvcalloc(npages, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
-
-	migrate_device_range(src_pfns, start_pfn, npages);
-	for (i = 0; i < npages; i++) {
-		struct page *dpage, *spage;
-
-		spage = migrate_pfn_to_page(src_pfns[i]);
-		if (!spage || !(src_pfns[i] & MIGRATE_PFN_MIGRATE))
-			continue;
-
-		if (WARN_ON(!is_device_private_page(spage) &&
-			    !is_device_coherent_page(spage)))
-			continue;
-
-		order = folio_order(page_folio(spage));
-		spage = BACKING_PAGE(spage);
-		if (src_pfns[i] & MIGRATE_PFN_COMPOUND) {
-			dpage = folio_page(folio_alloc(GFP_HIGHUSER_MOVABLE,
-					      order), 0);
-		} else {
-			dpage = alloc_page(GFP_HIGHUSER_MOVABLE | __GFP_NOFAIL);
-			order = 0;
-		}
-
-		/* TODO Support splitting here */
-		lock_page(dpage);
-		dst_pfns[i] = migrate_pfn(page_to_pfn(dpage));
-		if (src_pfns[i] & MIGRATE_PFN_WRITE)
-			dst_pfns[i] |= MIGRATE_PFN_WRITE;
-		if (order)
-			dst_pfns[i] |= MIGRATE_PFN_COMPOUND;
-		folio_copy(page_folio(dpage), page_folio(spage));
-	}
-	migrate_device_pages(src_pfns, dst_pfns, npages);
-	migrate_device_finalize(src_pfns, dst_pfns, npages);
-	kvfree(src_pfns);
-	kvfree(dst_pfns);
-}
-
 /* Removes free pages from the free list so they can't be re-allocated */
 static void dmirror_remove_free_pages(struct dmirror_chunk *devmem)
 {
-- 
2.53.0


