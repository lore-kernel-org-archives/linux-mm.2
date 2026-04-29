Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77E92FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 15:40:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4BE26B00AD; Wed, 29 Apr 2026 11:40:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD66A6B00AE; Wed, 29 Apr 2026 11:40:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C76276B00AF; Wed, 29 Apr 2026 11:40:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B40306B00AD
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:40:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7EAEF1B903E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:40:19 +0000 (UTC)
X-FDA: 84712004958.03.4321ABC
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010039.outbound.protection.outlook.com [52.101.193.39])
	by imf03.hostedemail.com (Postfix) with ESMTP id B0A032000B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:40:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kzJiPm1+;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777477216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ncFy16fh9vBpcNHLdWex7ED8szgaNv9WIQY9UAIBWk=;
	b=hHs311wpIce61xkUr+FQQoYDGPmLYFdMheBN7DTV/7RmWyath5X41KmQImxNDZGu9+D4na
	w43LAfTHdQB0scFS4HnKpKvOgwclme6vcCJsJMl+L3Ukz8bLrPG3u5MAcmvTVbPB5QGRKn
	kvcQtO8svUymA+yILpym238Ftxf7Q+I=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kzJiPm1+;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777477216; a=rsa-sha256;
	cv=pass;
	b=0rLdO35Dt3q4cJGVip/QpL/GcCLGJ9IeceFLcf5/88/6X1OkbV0wkBtWEg62+1rIy8/sLS
	qjRp3F1R2gMQPWEGrXWJu+lrNNGwoqLbGDpoGMN26Wd2rXMyEbXtlljf1jqtyhdmPm7/7q
	kCPmNt0plPpbeO65hFkRi96LRVkWzcU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=llDpoLBp8F6UgCcVgRzllSLw841cpuIRLJOc41y1gpFE1dIBGhdmMnzfs6WNMmFD2sUWy+q5H3ZhxMSExgn3oEafMODivnLhmzJOTl5MwVynzU+EazTr/RQfqNmRD6J4/LP+2Gii0alXOvsbOrupl0ygTgnynIns9xkY4EkmkHCmlt2KVkAAEe3TpF29INn2rGXVA7umT5vTSoAn/mTqvyQI+LNXGUnyX3NGm60W6B6FdhnrK7qteFVAcYhenLJX4HGkzyvvhZw9SzqMJS479XnMNlcnA3Uu6bgEbkHjSFLtfm5QInBtM3zcu3kOYAyQLMpeKs6WeExkS4x/VMyO6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ncFy16fh9vBpcNHLdWex7ED8szgaNv9WIQY9UAIBWk=;
 b=uy8iDYJLVaUOAZyyo8WCA1rHoV/zy3zaHzRALa7tp8g02d9UhlFxpWDx4BPI9xlYmdyY4LFJP22PvUDRMcbhXPqfcWGAYfV20qABzMxfCdWT8ke1m3kEZDFtRjsZa1mAhYXo4/PZm5SCImJgNUCFvsTaFMqdU5vK6qqTp2bNWcwvNvhiI2ymTZ4T/u+eVoFeB4r4F0zeef1eKY1DYUTfdg+ZXFsM8++IsEhqNGkK7YvJjKrSzWH4p9KbUf637YA1WLnSHdTCfVIYV4QTtIhuw+cR99SM/uWzEvmvD+drMJX6vBLbjJa6Dg1p27tLBbv11/wUPbsmCAudP3fPIQz6Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ncFy16fh9vBpcNHLdWex7ED8szgaNv9WIQY9UAIBWk=;
 b=kzJiPm1+2aq2j3qp1CWhvh1pBo/2mTQrSn8SBhccGICuAWBrfnTf+CZ/GO9QmlqHOI3WPrXlqMOOD20RtJkSwrNQQA1K6764DWmNGiGSyr5UMeivaMi6EucymwzjiGR9pYeTLP+ZglJV57uV3mROa6gvpLU3dG/ePlWhEaDyoVAAaIvzS6AfdlU3m1BH2JLsxyvhgk04ky3AFU3WYvG+7V66+DFKFYNxXRqNtsxFh2KJSQBEPDb3Nh+eHDJ5cvhNtmhwCBPhA7nR/X/sECPRylc0HgexO9QNHCl+COO4ChTpq8DtzpikEx/PqeEYSP9ftAL3kTCMC7fbANiL4gfbTg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB6230.namprd12.prod.outlook.com (2603:10b6:8:a7::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9870.13; Wed, 29 Apr 2026 15:40:12 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Wed, 29 Apr 2026
 15:40:11 +0000
From: Zi Yan <ziy@nvidia.com>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 2/8] mm: use zone lock guard in
 unset_migratetype_isolate()
Date: Wed, 29 Apr 2026 11:40:10 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <11C90845-D175-4971-B840-C501805AFBEB@nvidia.com>
In-Reply-To: <815c0905ea77828ed32bf56ff0a6d3c6548eb3a2.1777462630.git.d@ilvokhin.com>
References: <cover.1777462630.git.d@ilvokhin.com>
 <815c0905ea77828ed32bf56ff0a6d3c6548eb3a2.1777462630.git.d@ilvokhin.com>
Content-Type: text/plain
X-ClientProxiedBy: IA1P220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:464::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB6230:EE_
X-MS-Office365-Filtering-Correlation-Id: 8eb72779-b131-48ee-7e19-08dea60599b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	x2hebRoDq9POxvv000B5uPvaFlmp5aNl61Xfh9yu+iu6ZJ2Rf93Ae/6geSW0DQRbi0TCsnonXIhO6JrNB7CSKWsGCplbpwA6XbCsh2gsXBai9r3AtEghUTvnEHnRvikTCCsV27xBcdXJXVmBPYSZXP0y4E55N9v1BHOmKpq9UinpRDWn/nMg0V03gbjGu56C+K4ZmyAxEMfGUGfR4L/3maRblOFFhGgMQr7Oq9CbYxIILlr0ebaO3URQnc8OuvsFjUeDFUAQF9HZxgIL9llgKBHdzbP4P5wDcMNkWEWTpuxZiZLWHUsWWW4j9HkZXrkU0x8lXHhGVWIz1i/CVTqG16pUQR4QAu/cg7WM/FEeujiz3HOUZ6OTpotBHAh6/CZUTgnosDFFhIrsEX8wP5jEGl9CK7YnNCWWDeGeJM+P9Njwz6L8eUF9OVRSfdhPlKJBr0WcouYnew/lrcS4BoF6z4IvSONrJtIqVb7eOPiJ6QxvSc51+HijqdCZup2RhknMbuLoMZsEs146k2r4WnTSzlyvLI5xQIpOEr0Ebs7jhlWPBEPmkfRpwsTafaj50Qzwu1tIdBR0E54kvWTmh+CMJKYb1XIbSOb9QIDpb7PTQUkLEyjcgfDmLuQm5JGNw5BdB6z3A6wjih6HlUIPZHXoGaksNUwjesQmMKjy2CPWObdcfjPqq+2dC+yuTPOJqQMLyDv/xGuL9UWIIox66szmqlnD8YUmrOFSknNR+dODbnY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h8lAjbjrT3PziD1anYTkkbDHaZq4hIDvYSKCbJsOc728enozxAuWBqOfAQm5?=
 =?us-ascii?Q?WPKMt1WX2X04HPF1EgQfRTZozGQvPBxFop6HHKmb/8U8OBcrM8+t1E9x3ST9?=
 =?us-ascii?Q?qoKpFmN2zHInK1gXl3oaIcipe/EexQDGIPCDJ96vTnaV18sZyhxb7i/COQqT?=
 =?us-ascii?Q?qCLWsSUqruAj4gNi++JfbE7ocq5xa4D6Dx/j7EyAp7y/3bLlnUvcuXurLwKN?=
 =?us-ascii?Q?tPCqUENXcMKAmBtKq7JsewpzB/gKPO+NkDG87zdTmjzfqToR0CwUdPmqeaIZ?=
 =?us-ascii?Q?GTa43Oi3M8oZF7WAo+ItJcNRHRbPYFRpOSaw5L0qxvVUfy1vTi4xlDeOeCAM?=
 =?us-ascii?Q?mHH+Dby6tcKK5PCnjaDc/etb88r33gpNuKsbZcZOhv8MLMOxmF9MdBZjPF4A?=
 =?us-ascii?Q?fhG8QC0MFG1+b6VdNlpzw3JWWxxn3QdyV64MyPTRtR02QGa1pdaCUlDiUAzp?=
 =?us-ascii?Q?S86QPf1EvGkL6cBoTv7ngByTnupZMvxUadNaezT0RUC7LhScIMcabK2NntJM?=
 =?us-ascii?Q?ezLMtRLt+WlaAJjFhMnjm9SRNFAE4z/hHH8ufipZj8QnEP91CwdL9Ta+pj63?=
 =?us-ascii?Q?SyDay5DKU7kLPwhEh/aQqdI/xfF1pEaxZerGP/UkfyhkARUiYI2l0aJzYBm9?=
 =?us-ascii?Q?EKCkrw1e85FMLwAZJyi5CbF0iQgwXvRpr3E3A4g61sNkPOiCcpyBrMsM/G5n?=
 =?us-ascii?Q?oqtbf78sCGWjSR02MFPLo6B9TtFCq9M8wodZ+nJewsy3ittuWaxZcnR3a1XF?=
 =?us-ascii?Q?HUon1FNUTxwwM3q7YyXP9kLo1iMLzvAyA3WWNYDnMatNYoaPpliHMo1jTU9t?=
 =?us-ascii?Q?i/q+roMYxBH6cnO5ZT9YtvJuf3ZaYnQroCh12rVSJKqksKkwpl0VZiD26hIl?=
 =?us-ascii?Q?ZM6pM9ejB4oJJJSuFZOj7X6ZK/HoyinEah2TM4dImzdqZqbdUGvj+LS/lbI5?=
 =?us-ascii?Q?AJNhUc9gA9fB1G9+AyrAglLY4PuSmXMQsJvqcmRiU45niQsyQKfCTKe2MJVZ?=
 =?us-ascii?Q?wWwpCqeiuMyTu9twLkYWC7ewLnFm41H4y/hYNpAVR4AB9Y+6N/fA0bBaK1RM?=
 =?us-ascii?Q?tHSj3gTnkNXOWntIuGuwgYQl0zXrIq/hf9D2z6pVLrIpBdGY4FUvcx2eaRof?=
 =?us-ascii?Q?N3EMJkvZK/myx2S18Z15mC9iqRAvkAnVMKy0kgK4koT8E+BpJ+er/XHA7k7F?=
 =?us-ascii?Q?S8CIsHkNBMaCT5/Tuw/cwCrcrKtzKjsrw1EuBPPoJ13buzCFoVorrKkWOdjW?=
 =?us-ascii?Q?WFFxyVygrjm0KTTP0Q5iJ2+3LTOQdX7xQyAHgHFu9DrH5Iv7RgDe5zx2kp+e?=
 =?us-ascii?Q?PXRYqcjfI7v/Bmg2o5k1spDM5AAklJBlNbhAWsB2ZgL5Bzf2JKO/w2F+Edra?=
 =?us-ascii?Q?rBcEfPa3YmULbD/GbM5i3BJkV0ohEpw1OSYA5OH/AJSVQ8UvMYDF9MD9vtbm?=
 =?us-ascii?Q?oA2YDHe5wMcTZTA2S2hDHyLnW3+QXF+KHHOmJm5rxScLDrYEUmRBcYDm2LSP?=
 =?us-ascii?Q?QVnNplPnOlc1myh2ria6r52wjfX+FX1ced4EtCqjGOQIrEHRcO9TeMsUMuH/?=
 =?us-ascii?Q?rmexscUGVBiS1MfSVkWQ+J1FG/ILBM3KYP//DGNHM5/0UT3brU2bRCcdYcEd?=
 =?us-ascii?Q?KQtmYbe3BxePHrpxE4U9ee7dpB6mbMdpU6/B6Fokytmdrxf/gaWUB8ZLL83L?=
 =?us-ascii?Q?ytRpOrKkeNRUo0QJmGmGAPdGtpAWfkjCJ+AVjjCAzKOuIyMt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eb72779-b131-48ee-7e19-08dea60599b1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 15:40:11.7887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rHOiYXSopdUysCUXBQdSJFclrCyVP7QkbDJVVg815SgZFWBa9Ujr58tK7bjxjwSW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6230
X-Stat-Signature: inm8u7tnesk7fa4ycbkjwmzyic8j9jez
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B0A032000B
X-Rspam-User: 
X-HE-Tag: 1777477216-54840
X-HE-Meta: U2FsdGVkX1+dhi6Eayy5/6m29qPSwxpnNDr+0awD3Ubj1Ve/vB8OxaifZG+RbxW24ONVFG20Q9yxmwYqP4DgXWQcmzKlbEsCypYr6xxYejS7XViUBLEMWQDvy2rsn9D0FOirLoA+23wa9/71/zYdTHwSFW9cTzNbyulJvxdWrmkJv7wk3ynfnaQEzh5tBYxrapZM7bqVjh7u9xqpAaEC/2IicHHUTVa9ZrAeyIO/nK2O2ANB7nJmBaporprbV4r/nrrPzG/3xhDWfalKsEbeYEcdI/7PM3fet56R6raqoL4tr6VF5N1CVGnkZy2p5TThgg+yXhyH1KTRtvf64IleoMOtfbXDUpIjRfg3A9qeG7PPv2VCyEn/zlhT8kSK2WedCkZHMyFvZvSixSE8zAuaG91MS57LmJ9PfYHwQ4FnBr+9abOQyLu1aAG6W5zTMP6+YDYPnwhVyS/q2cOu+wsoXgY7/P2q9MCtP/0HmpwDE0tu+web0znxOujy0mLtazceF9KDhsVuU0sFawYsMTvMrXguRQItVFRMiG1cC6fy/2zMlTR2IHXwxa1ESWRdcAuoygLyP5x2I2JQsEQm3CEWU7MBzgNBo9r2NEsibcIuKXcTE0qEROK58BiLirGCW8Y8ZjETiY4xjZY6FUEdK9ZM+OWzql1xv7xhzPbYkZqCtC1QDy7kyu0nUQQHGZ3KAEExxcJ6UDCGz8BLTuSYm9Hbd3drVDGAsycQaxWZhpPSPQ0Idv/Tnj2V84SB8hU2DmEYnV60OExmdgKpfITnZ4DwoFmsV5QuqOYmMrTfde3jb3/7p7re8w1imLJqFQjy/cu3hy+oK/vk/i5tjhmbg9PaPc/BEHYn2/nr5AWRKHYyEoAj/F73cT4XVAdn1WatCWrdoIp5LSonAm6Q+xtsF/ggAJyfPWcr3MSk/a07npJBIqDC/DmkckogZ3kOwS2hOxFEbb6Gvu8MbM9TF5lPjei
 Q+80rgwF
 8fjYG/a/YnsGdgt4Ey4oNGEr3+9JOU/Ss+7UmndhSKyNQetmI0sIH8Ov5PkAo3+Z/dlsgQG+VdbANwfU+nFNAgXCn4eiXCmb/vMG+RTSIISAJrJJful+N5RgA5LgV5UD4PlAKTTxORnowPzfemJEDJ5JzKniuT7Kl0nFOIjUffp0n8NrZpYbC6hve1HW+i7TejYICsB0uGbIw3PDkTUkIc6beBu/9DHJQNXYv3ucj6uheNbFnVelVfFbo9GtDCyrTONnEnM/hPHzm9yNZFtnqR4GUqPtvhROK51R0TNVX7EueeW/e34QOprBzRqEB3SREh50eMPuD5TCxLe5AgQ47R++Aczl8z9x29ie40abY501o7l/qS4Q/T15p5D2EUiJyLKBjqAbEaioIRSIeGvZ5W4frDEMUOulP26h8N+U/WTqCJ1jFfHEAxaavVKtUyEame8vz4dRvkifAk7wUP1qGAB8YRvQZ6XU2gxLJS7q7xeiNCNO4CnyVOmblTAdXXhm/SbyDbowD9+UKghBEf4IxY6sot6LnRz2Q+2rOFBIMEDdSDOla44VcuBRyrXOldyCBMfoq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29 Apr 2026, at 8:02, Dmitry Ilvokhin wrote:

> Use spinlock_irqsave zone lock guard in unset_migratetype_isolate() to
> replace the explicit lock/unlock and goto pattern with automatic
> scope-based cleanup.
>
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> ---
>  mm/page_isolation.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

