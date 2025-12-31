Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E7EFE9410D
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 04:34:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DF6A6B0099; Tue, 30 Dec 2025 23:34:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A22E6B009B; Tue, 30 Dec 2025 23:34:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5772B6B009D; Tue, 30 Dec 2025 23:34:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4387E6B0099
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 23:34:10 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C4647140498
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 04:34:09 +0000 (UTC)
X-FDA: 84278499018.05.127E04A
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011011.outbound.protection.outlook.com [40.93.194.11])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0470940003
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 04:34:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Fv4eS5tv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.194.11 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767155647; a=rsa-sha256;
	cv=pass;
	b=S79QPjXrQ/ETUhWbKDCQ67ncxqvxpsc1QNNKRy0/pM4jFs0/F7mu9flh4hCg0l/MKLdvSH
	HxJfAaS/zsyh8YEPQywDCkSOopjhxsgZH2QL9VyC4fBPNuGQZLHV4YTijqfyXQIgHAwmIt
	c5OCdB/4/Db8Qa6oaipdevHKdC+V6u0=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Fv4eS5tv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.194.11 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767155647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jzyTAGoufa0HQKfpkbJWtD4x04UmM5YLXoS7DsIxpjE=;
	b=xJPTI1wiuZM4uMAVwrsWJ4LY3+BKRRbqTU2Wvrq/oAzBt+0Ko33OQytZorj2RCuOm6o7yk
	8FtolWuDvYWv5x3eq7eqycR+oxGjFRp6xBF1sLJK25+pj6M00WZmMfFvLdSH5IcsUQLkZ+
	KIXiUkqB9kiClHRjclJC73L+BUmTtIs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Eu+q2L8th3UU7v3WROUiyepZ8ZEPGZqAtVZbKY0lkgmGBGF6rNjfHNmVTn5Yt5eitFFa5ybwOo2V93XKY1fRPJ7gs+X3WmCUiExy+dXhnhLDqy7/48wYEs47atCaxnyU3ExdD6dXWBwJ3eHRCeXRruNmSO4vGv7CHGf2DNOY/YZvZl7+6ysT28rqrLnTtD8kRGv6O7/0o+5YUStNL3+JLYuOAWIjSLFvODtIyg1grMETg7bNUvAD5D9BedDDB/cPNNyhAS+ibxXuBEi46rr7bVvqOAY8/zw/iKbR6R8J4yp8mDKBN8BvYgqHyLHgYQ7hJW6SOCNxuAADWZMqz4Db5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jzyTAGoufa0HQKfpkbJWtD4x04UmM5YLXoS7DsIxpjE=;
 b=Z776rswIKE9pxAhzgjGYMr6J+Rw+TYeSZyqq34JWmJj6HttzpKfNY56fsDiB+K5EJwfi67h9WWsyQLeuQrTDi8wJ+s+SEifKpkYzTlL7QBSHYf29wIND+yLq+LHo8K0uIY7+LafjeXtM8hKXi7Dni+bF5HTFsxBlVZcPBm5P1QO/UxH9VqDMQ9d80H4+My0tljZp6Utg/0Sh9pdxr4BQhw2bfXSgVlxRzTF9+m8E+l3sxwRE9yn5yrVTcPuoS40+DP9OWLfZR/2Y4v9DKiigATExAe06H4S+8Cjr9eTGfJGuswr/oH6d8013gaoBR/JM5oGXtNziMGHQ6b0C3e4LmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jzyTAGoufa0HQKfpkbJWtD4x04UmM5YLXoS7DsIxpjE=;
 b=Fv4eS5tvFNLSVfShQwHOliQjKFC3aTOXefrxmVWaTQIoHZEZk9mJ9AIATESHl8IMfW4IUYqI93ZXZyyd8s/qkwc/i1LIqr5BsKwrRX+Gq8OcPWGmHNAk4h7/y0me41e9YzKLMQFtk2QPEujTTveNrFzfmhpJHxMutqukoBG0PZgrbUGDNYmxE3uuu/+Vp7+Nf1SZ8vhv1zdfslwH4ZspAFQrRwpS9XeHwXl3B8UD85dwjhNKPScYuClcJwHozqNYqlTz8EGpLpALHxOHjQYuZUMYJhO89dI0ZOe2m8KfYVj6OzgddV26hhib8158vfUl+BEaPZdrIf5mNPFoh0McCg==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 DS7PR12MB6045.namprd12.prod.outlook.com (2603:10b6:8:86::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9478.4; Wed, 31 Dec 2025 04:32:40 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9478.004; Wed, 31 Dec 2025
 04:32:40 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com
Subject: [PATCH v1 5/8] mm: Add helpers to create device private entries from struct pages
Date: Wed, 31 Dec 2025 15:31:51 +1100
Message-Id: <20251231043154.42931-6-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251231043154.42931-1-jniethe@nvidia.com>
References: <20251231043154.42931-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0061.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::6) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|DS7PR12MB6045:EE_
X-MS-Office365-Filtering-Correlation-Id: cc1553f8-5a62-4e29-880d-08de4825a19b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XYwxDUa+saQcx3hpGM6zBGJVcV8i0aQtJrrtvtoVbXLILWk/cU1Jgyd+lLAM?=
 =?us-ascii?Q?VKTxry7Db2eveoKvmAd70/GLtSnXSGkQlML9r2R68uqJ4tD1zubpxsm31oYV?=
 =?us-ascii?Q?CxWpUh7IFeqDNUGPux+5DAQ2pDey5eDu3EgqC8exs+t882x61KvN33OVIpkz?=
 =?us-ascii?Q?KTravwPdCP23jKt5CdCPCqm3fnjwzYmfIQQGaEEhxrKmF3PhdTuCMGUa5D/c?=
 =?us-ascii?Q?qXaK8z99ipId+rvCCOlkGbqHIoFMT/swDVfc/x8nXA5rXkOh53N/JYF6N0Fk?=
 =?us-ascii?Q?u+rosJMBYREu/UxwzLe3jT+jqKSO70Rpv62ynM2eZnWG892UrZv1jXRSx7M+?=
 =?us-ascii?Q?C2LTUxNRHIDPWh/bCNyd2qEPKs5fPaB3aOQ0ohxmuCAWkCaK++WJVjIgNjdy?=
 =?us-ascii?Q?7BQbtpK/6Btzje/TeaI8K/1q5sAC3BInersIgAtocxDUlmbTjFqMqFgFGcFP?=
 =?us-ascii?Q?NbUm79tK0lMvBEX6189636elKwNIPzX8wKEKO5J48CrtvG+m6FxhoIH1jcQq?=
 =?us-ascii?Q?A8IiJ6/+K+4gW4Bf1sEYMxA/RUyVb+1esTUdNYNPRcDhprHT61PF/PUft7Mg?=
 =?us-ascii?Q?DDfV8Fz+Wut7dY/XeGJMiNR6CIvHH02eb+GHNa/ZfT2AzaQ2urnP8kZv4o/R?=
 =?us-ascii?Q?OzoWkmXr/DS7E3ZH+edJGinMefloYn48jVT56W5716In0PjCLOcJR24C2Xj+?=
 =?us-ascii?Q?T/Db06sgTYDtZ7NXA/OaRIcVWsNDLIhyiy/fTFgkeUDuRgqg87IIqTWUQ7Li?=
 =?us-ascii?Q?nA566O2m4eVqMsW+a89/lkibhfzXB1jbyaf6+pGj8dBDZ3xgrc9Vot/7Y2SB?=
 =?us-ascii?Q?YVmVgUBr+cZcb4XvYTOMlBpffmgCYO8yAEaXeDLfddgmddy/MEwgvgenj2u8?=
 =?us-ascii?Q?FwtmJJ9zVLZiqjM5uUqgOgk/6BbqfpddLj0/fjbHpus5kj814lNwtrYKCoqg?=
 =?us-ascii?Q?YbxdztmQXQCDdwXxwt5he3asfwVPa62Rsevke+grGfuTXusMMPnjEd6x/ETl?=
 =?us-ascii?Q?1HqQmrSywi3YSgy65gwMOwbi/rKVoV08kLUdvfOmiXHJLAhjczClIawcxkRh?=
 =?us-ascii?Q?LMlu4lytRf+3KIFgTH2KRHG0P1q0FEgX8DSahZsXtV6Xw9bvE6uvzw7r44hD?=
 =?us-ascii?Q?Xvxo8bCRsG2kmWlKUm+aOt8ASL9Lwcfg9sTnkW5kUz/n/0/21jhVAzCNXGX8?=
 =?us-ascii?Q?vSFaPMc5fkDUKKftHtz0ikmmgoMRBEw1aEGPo6O31zPW2K/bohmA0uql9sy3?=
 =?us-ascii?Q?h5l0y6IEQSf2GA10IH7ILBShTXofDI2PaueA6tJKWrOLfx9kG/E/BTkr0gUt?=
 =?us-ascii?Q?kCZvVn+hKWQMarpyuI+QmWVYSZeh7oS8+Di7qZhbkA0IvsEcaOkN3u1Q2+Yr?=
 =?us-ascii?Q?3pjr/6adCYVaRzDHBcxlcVpOs9TpsKBFkU2uI0o5IO+BHCYJG1b9iV9ALlrG?=
 =?us-ascii?Q?SBnY/Ta7UESwtMPX8hCEJN9sPV2vJfSH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vJ3dkN1pcvfV719r23DTdVX2byzyNcrUbALMCNQqLFynF5W/FEPthf+3KCTX?=
 =?us-ascii?Q?ufQiunC2lO9GoZxCTZTDxCUmSFBRfJUVmcmCjw45ipllNqZDkBIYGeFJfQuH?=
 =?us-ascii?Q?bt30DifJf+QqNG1+IvUNs6Gm8lDS61hxbQtFYP9qdo5BxjuZPTpG/jPmJ0Zd?=
 =?us-ascii?Q?Z2fvWcva+ppq7ohWk6tdn1tiBYsrfGn8uIKz81TQK9Kwjv9xED8JZn8wRzT8?=
 =?us-ascii?Q?BEJTj8T4kBnX/FqcA8jcoIoywop2jiWUvC6ewwa40IbHH/QYFFMXYBATAVvE?=
 =?us-ascii?Q?RQNMVg2euVvX0HKgyR9Rup6L/BzkFcXcoPqyiKWpG20jHmoZtCPuTWhJteK1?=
 =?us-ascii?Q?qaGnTU1CIe+caH1krZzQMZcS+SAKj2np9CvJkySmC8j/16aQKW8gDW+UGn+O?=
 =?us-ascii?Q?pPT76CNGBXNHp61ARk/uh1QPW73mdTCkIBg3Un7Y/5KvCxhYsLUkFMqT8hdT?=
 =?us-ascii?Q?0wgEW5Jcy64e/aW6Gqkib8kVk8Ual6dCtBR00s/a1LfJeK15NVYN6k3Q1Y0G?=
 =?us-ascii?Q?2QFxpfy51QFkPzGFLHw5YAKIgBkzNIao3qYETIvGsLhzXCEOaFVL5OP3hueY?=
 =?us-ascii?Q?07NUvntCMAHeSKkMsv3MEmfLHveii4zPfE17jORASJrwUN73M/o6goi1Tu1k?=
 =?us-ascii?Q?1L1ZDtr40NFjqTZDL+ge0kE+UDJdQjgbtbj74GDtIXktDXTXryk1hqSL4GT4?=
 =?us-ascii?Q?dp93wWW/0WNzU7TgF8HsQmBBP98NlYn/yzS7NKVKY8ovWyQW4JmBSFE5Tf6y?=
 =?us-ascii?Q?kNYUcHloEdikH3DvNYuy3+psA8OUDyRIvrhog6lQLlSlIi7pUNvMbDcrpMYe?=
 =?us-ascii?Q?5eotlvuefcV9b1KvZs+d2OO61woVGxKt/pWDeuoONHB48zwslJBHNagrMtl0?=
 =?us-ascii?Q?t5h3n95xpzEBpD4nMWr9PQvxxQ80+I1+Gop8Svw+1i2pDyjHuVNFawZXAs+D?=
 =?us-ascii?Q?NRZSTD0YvdRUS0hn/FtW82AyvzSTgPI4oOpFNHE78T5eToDfxHSsOwGWkNlQ?=
 =?us-ascii?Q?H9QIrPuRarSBj7o+qwCsldQUEs4tdaZCAQlOa6bIEcHFFBqQUZWGslsdsGxD?=
 =?us-ascii?Q?uHUGUqxHpM25/mtBAJgij4tBevHWbSqaUa6EllGlTsAS4YYDLTTV1BWCX4qh?=
 =?us-ascii?Q?EGygNljB/lcVJKPwR+jsEgXLS/G8ZZnsIbBhNY2nhyof03Q72HnjVYvRetjT?=
 =?us-ascii?Q?MH5JKQolBOnuyR62kXIDD7XbpRRJ9HSyU4ZnRMPJ9MyJ6wEWg6Q3I9zx3nW+?=
 =?us-ascii?Q?lvybkfJ3a1xMfMmrlCAhx6tZzQa/E+H9DS9KfzkFjk75g4Ppl6iwwlozqh9s?=
 =?us-ascii?Q?Z1tHyAP8tFLpfKe51EDtcgMKL7CCKzLN5+reoYwpO0dDPPKj2dSPfM0EyoLK?=
 =?us-ascii?Q?L677l+zWEVvltX31V8WN3XsavqzU1WqYIsM19TUi8WCe1Np+F48E39KuRXla?=
 =?us-ascii?Q?bVy4a4Z9JjnG3oVo/1Ox5vXS2uzd1a2nsrf8UD45/kcJV8U161AWaFaXKUZ9?=
 =?us-ascii?Q?uvJPUdERKIGD5gMXBxAbjsgJEOsVqBp7+UOmg4KboyX7O7Bn/DZ7IJLB8+c8?=
 =?us-ascii?Q?SiDJfEJibTJCgGxTxiHk3XMlmqzrmqzEPbcnPw83mSIBH4gb0/uGd9qML8jS?=
 =?us-ascii?Q?O3lYIKdGWQIIagWFP6rYxqnMw6AFj/MbzsRI+PvsNoanTWCuGSgKccgdqPkt?=
 =?us-ascii?Q?PZK6ZOn1b1dBzaOGzK/pZ3C5CH/Snm557KFpXBd1eKl7f3svUybwZ9x9sZcN?=
 =?us-ascii?Q?vjHrvc7yFA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc1553f8-5a62-4e29-880d-08de4825a19b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2025 04:32:40.1146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IVZwewLDonYFnPtjhz7UvdndC36bka1EtrZevP8cJ9yva+g1ehYUSF2jS0Ry9UbGhwJ3AF/+rRcrPP7l9PE9iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6045
X-Rspamd-Queue-Id: 0470940003
X-Rspamd-Server: rspam03
X-Stat-Signature: 867curwk7zz5g77an8frjwqxg5w6huh4
X-Rspam-User: 
X-HE-Tag: 1767155646-209521
X-HE-Meta: U2FsdGVkX19qtejcJpyQ+O67blhwAth/Y35o5OBNCNTlX5pb+0gTK6d/3WAD2MYsYpiPhBhqO5vZz43rsbss4iKlOAlVoNTwUu1QtFqx9OD9XLRKLQbpjud+NOca/+S8NcfvHdsvFgRM0dT8DFdA7j9qphaGDpYpVstMORdLQo1yh/GqDvECf5OYrBYgdRc38MoWp+C+9sGajUCP1C8cJ3aWKYjbSj2CzwJ5LFEBuhd25X0/ybuU3Py/ui7HtZjmo27v7EDpjU+wzdhzlR1urAJkMsf3WbR9UJ707+XBxC3iOw44PTLE458ICNpGum++D/Vvlxtp7zmknWxCIydvs1XKI1KZIPxa1VBzpTzU0owDT0dMljP60FkKyYXxyZavnZllYBnCeq225p4KThmjR2wmVBZwU7JJ9eoOv+hOtaTT015PIzcqAU/JMS+OTXo+SJTseTN7HEFtVHwwxD5/SElu1O4Msvz/tbSPUG09Ev0oGgOp3E1VFfr+gWH3nkp0OjGSI7tOnky8vLT+4n+2ryAA75l4UYVtS/GvDfOgf7wuPZhWbkMJPwMCn8pXnLLYPv9pE5VNqw+ItfQlLwNnZHYrXradIVu6NCO9jJjuKhV42HNmgrc8OrGemB/bnNpUy6+KFXgL3igQxR3r6/+G6TTlRtNekT2vlVzXM20OzOrh+y4xlUZ3m77Oae+xD/ZFA8aa6QGYbUUjSkMznlT4GJfnaRmLT5oQA/p3S2kREXNtMjQCUGH3GTXi/h/O0SeVYGsY7GAogmtk1LMpUtZylQkVTbS1DT40Pq9NsZc8tdJ1x6QSK8asOuHLzwqWTJ/fw+jKQbsF7ZUgCdl4eo/8S8ebfJz8ayz3czQWx+j27aMEByTcPS3d6gb3rReuO0W/aRqHwUu0BkGg/f+heulA7h+4ChZay+ex+x8rDF9E6+uyJaAy2RWgTAr5x17EMk9468EGdFgmobL+2kjYTNt
 EjMnxHp0
 0eMiQIv9P9d/8RfrtnGwngBLks1qlZb2Mg4d+oMm10ioLoIVUeyNZykoCf80UzbhUzBkcW9dDY/5xRbWC8fewrNUZzUuMkSI5X0RqnqGaq1SFMTLKdl9KEAh4kgdCJZ8RqIsv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To create a new device private entry for a given struct page, that page
is first converted to its pfn, before passing the pfn to
make_writable_device_private_entry() (and friends).

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have a
pfn and must be handled separately.

Prepare for this with a new set of helpers:

- make_readable_device_private_entry_from_page()
- make_writable_device_private_entry_from_page()

These helpers take a struct page as parameter instead of a pfn. This
will allow more flexibility for handling the swap offset field
differently for device private pages.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
---
v1:
  - New to series
---
 include/linux/swapops.h | 20 ++++++++++++++++++++
 mm/huge_memory.c        | 14 ++++++--------
 mm/memory.c             |  4 ++--
 mm/migrate.c            |  6 ++----
 mm/migrate_device.c     | 12 ++++--------
 5 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 2bd01f97b4f0..ddf2763d69e9 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -138,11 +138,21 @@ static inline swp_entry_t make_readable_device_private_entry(pgoff_t offset)
 	return swp_entry(SWP_DEVICE_READ, offset);
 }
 
+static inline swp_entry_t make_readable_device_private_entry_from_page(struct page *page)
+{
+	return swp_entry(SWP_DEVICE_READ, page_to_pfn(page));
+}
+
 static inline swp_entry_t make_writable_device_private_entry(pgoff_t offset)
 {
 	return swp_entry(SWP_DEVICE_WRITE, offset);
 }
 
+static inline swp_entry_t make_writable_device_private_entry_from_page(struct page *page)
+{
+	return swp_entry(SWP_DEVICE_WRITE, page_to_pfn(page));
+}
+
 static inline swp_entry_t make_device_exclusive_entry(pgoff_t offset)
 {
 	return swp_entry(SWP_DEVICE_EXCLUSIVE, offset);
@@ -191,11 +201,21 @@ static inline swp_entry_t make_readable_device_private_entry(pgoff_t offset)
 	return swp_entry(0, 0);
 }
 
+static inline swp_entry_t make_readable_device_private_entry_from_page(struct page *page)
+{
+	return swp_entry(0, 0);
+}
+
 static inline swp_entry_t make_writable_device_private_entry(pgoff_t offset)
 {
 	return swp_entry(0, 0);
 }
 
+static inline swp_entry_t make_writable_device_private_entry_from_page(struct page *page)
+{
+	return swp_entry(0, 0);
+}
+
 static inline swp_entry_t make_device_exclusive_entry(pgoff_t offset)
 {
 	return swp_entry(0, 0);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bbfe5e87884a..31ea473cbcbd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3225,11 +3225,11 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			 * is false.
 			 */
 			if (write)
-				swp_entry = make_writable_device_private_entry(
-							page_to_pfn(page + i));
+				swp_entry = make_writable_device_private_entry_from_page(
+							page + i);
 			else
-				swp_entry = make_readable_device_private_entry(
-							page_to_pfn(page + i));
+				swp_entry = make_readable_device_private_entry_from_page(
+							page + i);
 			/*
 			 * Young and dirty bits are not progated via swp_entry
 			 */
@@ -4956,11 +4956,9 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 		swp_entry_t entry;
 
 		if (pmd_write(pmde))
-			entry = make_writable_device_private_entry(
-							page_to_pfn(new));
+			entry = make_writable_device_private_entry_from_page(new);
 		else
-			entry = make_readable_device_private_entry(
-							page_to_pfn(new));
+			entry = make_readable_device_private_entry_from_page(new);
 		pmde = swp_entry_to_pmd(entry);
 
 		if (pmd_swp_soft_dirty(*pvmw->pmd))
diff --git a/mm/memory.c b/mm/memory.c
index 8e5e305bc2dc..076d7acb7267 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1005,8 +1005,8 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		 */
 		if (softleaf_is_device_private_write(entry) &&
 		    is_cow_mapping(vm_flags)) {
-			entry = make_readable_device_private_entry(
-							swp_offset(entry));
+			entry = make_readable_device_private_entry
+							(swp_offset(entry));
 			pte = swp_entry_to_pte(entry);
 			if (pte_swp_uffd_wp(orig_pte))
 				pte = pte_swp_mkuffd_wp(pte);
diff --git a/mm/migrate.c b/mm/migrate.c
index 5169f9717f60..9ec9bcd37882 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -399,11 +399,9 @@ static bool remove_migration_pte(struct folio *folio,
 
 		if (unlikely(is_device_private_page(new))) {
 			if (pte_write(pte))
-				entry = make_writable_device_private_entry(
-							page_to_pfn(new));
+				entry = make_writable_device_private_entry_from_page(new);
 			else
-				entry = make_readable_device_private_entry(
-							page_to_pfn(new));
+				entry = make_readable_device_private_entry_from_page(new);
 			pte = softleaf_to_pte(entry);
 			if (pte_swp_soft_dirty(old_pte))
 				pte = pte_swp_mksoft_dirty(pte);
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 7eef21d63364..5cc58a5876a0 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -842,11 +842,9 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 		swp_entry_t swp_entry;
 
 		if (vma->vm_flags & VM_WRITE)
-			swp_entry = make_writable_device_private_entry(
-						page_to_pfn(page));
+			swp_entry = make_writable_device_private_entry_from_page(page);
 		else
-			swp_entry = make_readable_device_private_entry(
-						page_to_pfn(page));
+			swp_entry = make_readable_device_private_entry_from_page(page);
 		entry = swp_entry_to_pmd(swp_entry);
 	} else {
 		if (folio_is_zone_device(folio) &&
@@ -1039,11 +1037,9 @@ static void migrate_vma_insert_page(struct migrate_vma *migrate,
 		swp_entry_t swp_entry;
 
 		if (vma->vm_flags & VM_WRITE)
-			swp_entry = make_writable_device_private_entry(
-						page_to_pfn(page));
+			swp_entry = make_writable_device_private_entry_from_page(page);
 		else
-			swp_entry = make_readable_device_private_entry(
-						page_to_pfn(page));
+			swp_entry = make_readable_device_private_entry_from_page(page);
 		entry = swp_entry_to_pte(swp_entry);
 	} else {
 		if (folio_is_zone_device(folio) &&
-- 
2.34.1


