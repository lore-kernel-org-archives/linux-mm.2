Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C860CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 17:11:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E16E88E0068; Mon, 13 Oct 2025 13:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC7448E0009; Mon, 13 Oct 2025 13:11:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB5E08E0068; Mon, 13 Oct 2025 13:11:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BA25F8E0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:11:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5ACF68611E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:11:34 +0000 (UTC)
X-FDA: 83993732508.27.9383A43
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010025.outbound.protection.outlook.com [52.101.201.25])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8BAFE100007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:11:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cDn0mz0U;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760375491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=em39exKJ7jZsV7XS0r+rD7tf6tgFfbnSGHn2PSCwB0k=;
	b=m3MyL5l1Vn+Pg558aHkMFFyjsZWASIQ/Sq4l9YzLBmxEIOdTxskCcmiAuZHZA24VpM9O1D
	KMnXCzj6icZqGGgCWbVCRZZeqY3IiH5+NqnVPaaKG0ZaYIE/N/uN5pPbheU61rwmLBiIZU
	aHvYuYXMxcCxzSBX6iKB4G/I7pyHtiU=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cDn0mz0U;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760375491; a=rsa-sha256;
	cv=pass;
	b=xL8ejRQ7Bts/QUOMywg//T+QBPW36qlGPgToim14NR6je6C0Ea45TmOwRBtLaNOK7Fyi+t
	oxOEdwvv+sI5pjfJLykew+S+KqlJOZCmMskkVhbEqm98+aGBHkb9N9q/lCy7ck93hXFFju
	no9cm1cEI0ePgIumaU/02vUHQujFagw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tk4GdmEMm5EEAtdRiQJQKyFAfrQ74+iU3tE/VGgBTyWKJ63rRVHZR56yLZ7JC6+2eT1me36UrNro43coa6uZOzmcEKW2CCEAkdIaOxY3ysMj7XTymhZSLjFBEg8pSHetsTyovEamKv4064nYwI2Ihtwho07aszRLbY7lGObBPuGKLpXHv5Apsqp/GeYr5UiF0D6Ylu58+K9xBscy79/7gbr7ND1XVvJ0Cydo4fra02zTZdgHRfVFtnwhB62eDxuS8piKL0gKMsa/zCOklvgc5AtKi7SgV0HxkB8rfDN4k5lwPZ0sawM60ucxERlEKnewTiWFsVkpHUCSPU+1yCwDiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=em39exKJ7jZsV7XS0r+rD7tf6tgFfbnSGHn2PSCwB0k=;
 b=ftsrID29Y9qRx6KGwlgza1It1MY1oMiv7RKQxdYV4y37RKGdFYGoRkcPLa4iitCKSvVnq8dTYL1RpbZAd98iUgnFFhsGaI1oMVL1GjqWfFOS28wIfyNKtqitVocdA7wVq1FlT4VALZXlFnPaVO87taKf4XKj4gzbPfL5cPoITETnCQB1kdpaQA0ey0BloQDY9ptO0Og8O20mhz4HENeEdZTk0sM1eFQVbrnFlLVb5f+Ogj/9rkQ+tl7moErqWuNPqx0vHVpT1ftG0PCn5gsTfHLGH/kEUak3aGyx4ZSe18OYU2pu/gIpnGDfbCMPZQZZUIXgUCwu+js3ZynPMiaI3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=em39exKJ7jZsV7XS0r+rD7tf6tgFfbnSGHn2PSCwB0k=;
 b=cDn0mz0U6Uo+heBTr1Ek6L7+PhmBFWZzT4507M+cS/VjrRFfd+tVMh+1ZUmf2yfnaNBJCswmtHIPkXb3gxPX1jkDxmWvztWCUcLWfas1zGji61A71OLtVxeFELHiz965Ib/VrwlfOyrSEt2ryAtylS0+kseEGXXHik2NmtlQUxF36XmD6lhsUuYqk3A2O4VE1D9DlGzSJe+Ocn7NAI28ytfmxhz/FD28mxDieUcK87KcHB+tIe3vmFgIgLXVQiya24Ap/afHNOtEfLCzUwTlsjLebkYp838mOZUOp0O10ZepPtf4BVDjjrTfIicB5R+tPJvrtD3PMECpp+jRGyc/PA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB9728.namprd12.prod.outlook.com (2603:10b6:8:226::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.12; Mon, 13 Oct 2025 17:11:27 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 17:11:27 +0000
From: Zi Yan <ziy@nvidia.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
 kernel@pankajraghav.com,
 syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com, akpm@linux-foundation.org,
 nao.horiguchi@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/huge_memory: do not change split_huge_page*()
 target order silently.
Date: Mon, 13 Oct 2025 13:11:25 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <F6C18E5B-F39A-4E3D-BCF4-0DA6C1ADB206@nvidia.com>
In-Reply-To: <aOlKK0b2Ht8FrDXS@bombadil.infradead.org>
References: <20251010173906.3128789-1-ziy@nvidia.com>
 <20251010173906.3128789-2-ziy@nvidia.com>
 <aOlKK0b2Ht8FrDXS@bombadil.infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:208:23a::33) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB9728:EE_
X-MS-Office365-Filtering-Correlation-Id: 74ec1ad9-5768-4989-4055-08de0a7b8bd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Efa05MuyKNKLEoWqTBTVIGGFXoZbBX7KSc7MICpMByRh8QNmpSS6zxhx623A?=
 =?us-ascii?Q?4DIUm1HsUJQbMFT2OxdbwL5hkkJhf7gmuOXz+22mN4lAp9jN3zJi+sl/qHqR?=
 =?us-ascii?Q?7MPWBdtRU6p6/EJPRwKnB+8w5rILLBIUpOf+Bwn2/a39T2vMcT2WiX83bLK+?=
 =?us-ascii?Q?0fUXYj5ps532fiCm9JPF8dUot4hatIOr5pgwPqdr0aDy7b4ZQaxFKI675+n8?=
 =?us-ascii?Q?tk0EhAyuod0IZ+/NEKvu79NArjA05HmtQ/kiVcDkPkWIjkiEUvMS8EDEFFwQ?=
 =?us-ascii?Q?EP2Yp4N7C7yzol+4YkNyfP3zhLsxb8KwTXwdHesnFV/P8aUksm5ia0jBDZau?=
 =?us-ascii?Q?y1/KRVY2HP1Im0v7RpoFYIAPk8cCvHm62Np4LdQyUPWekJ4FjJ0L8tuOdz7c?=
 =?us-ascii?Q?qgAfrgQhKCUEKARzyC00LVY0jITkKD9W4MdfveC+pkNRZ1vzQFZs6uVc3KOZ?=
 =?us-ascii?Q?BTfmPE+/YwkDtUW2NIR0iN7QVAf6ajjllqBtwH24Iv0xLG6zIESH4DReKg9l?=
 =?us-ascii?Q?i/1HXVsHrKUfrN2kbXP/+e0qnN2+c46yJDgynN0+55evO6u+UJq8+eQfNzgg?=
 =?us-ascii?Q?PnhDgt7D3m7OqSas0TEzDt4Bjap3yertjqdbpSvVdwClCiXgoeu6pcAj5Icn?=
 =?us-ascii?Q?u64R2RaTXSdN64gOJ2yheKZ0NO2UVC5+I+O3onzEutlwzhV4IIHT4XJGadSv?=
 =?us-ascii?Q?YwoSLuOlptQEvfte0+2wBbV/i8yjKXp88HlBAY4OZPzP5UErV1oThRTnLuI3?=
 =?us-ascii?Q?ZQFbTN5I9xiRvM8u3Nm7PrnK3FcJtyfXlCpD/xvGUTLwGpef0vruYY50MeV9?=
 =?us-ascii?Q?i7mlXPYKZ16Ni1ZIcy82W0VqLAnni+flUIYfbetfs9tSTX84yuH4pEyNjF7L?=
 =?us-ascii?Q?QAjKhpesjgxaO37cjFv53EHjEAPQ2Whm/FliBiVjfYNk+UaSfclMVV91oR0b?=
 =?us-ascii?Q?MK7Yw0Jz+j0iv3//WsVyXbLABfPhrJS6HATm3Oa0WxRa29uX9HKlPrXPlPTv?=
 =?us-ascii?Q?45nsWSFpIX1yEvRqu/DWBitwyifvA9sxk884ITfTjmCUwlNu2K8FFNSIBlMy?=
 =?us-ascii?Q?4HkAlwnbiDNQr/aodS3venYZWNWxEBQcbZHO2RbSGYgz+w5nSPgROsWFPx/q?=
 =?us-ascii?Q?N3elIykHWaNuOmw1HXPMqvR8FSlHUcmR7ajQpnpugEZKBnDLxeriUycIbBWR?=
 =?us-ascii?Q?LYR0v0YOmYmQSKmgT5mDTvCMePHlPwAxOu2FaxL7qzIWuwqdCpv9WKbA4ee5?=
 =?us-ascii?Q?Zi95nGLf7ySgHP9kkdpoHqO9WxdJaVAsA4RY0C/CRA1RJ9G1jZvPlzVpk0bU?=
 =?us-ascii?Q?PZoL/Ms5RRSL4CCmGY0eL5Vd0KuGpALdqewnJEPt8u4l14bUjRf6dz5cB52Q?=
 =?us-ascii?Q?jt8mMbGLkaoGAwp/avIywc41F+by6C76WkbbXTMEEc2TgC44nDBCBPAXeQ2F?=
 =?us-ascii?Q?eC0PUvpYLMhxBE+wvo/nomgp60jLuLgm7/8Ujw4DqsiFL/6T5WtZQQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FTeOf+XLrqY6tCVPkhV4xeDLnoFtf0wg5cQVDTHjsKjlRyyNRK39hXCVu4W1?=
 =?us-ascii?Q?kqIerqN/WVf0w2lQhZ29wSSmZKTJp8UCmqtgW4Tocl1PQGNTX0Xl39Dy2PEa?=
 =?us-ascii?Q?tWb3StFN1DixRD8znjutsO76Vn7ayEcvcw9vuzJlCegN+zULI8Hly9Cqeqa9?=
 =?us-ascii?Q?VYXdO2ZJVOPih9znzNZDKntHy/bN1B6Fftgl9PxGayjTW1tXlnq0Q+T6xQTM?=
 =?us-ascii?Q?t9+iw/0gFN8h7p8MBMDVGR+I5wNBL8Pa9r2Ib1tXGUivfD7okK70cMKNVYac?=
 =?us-ascii?Q?M04cD5HuPa5MQ8y99dN0Yh76RS6gkqS5S8AYeUVGkbO1VsvzTiwvBQmIFsaV?=
 =?us-ascii?Q?1jzyef15IdHBEZ8QkikiWyjtswe7rdAah7gqMUoMlFcxRFcovEU8c0UDR/DC?=
 =?us-ascii?Q?OjZip1oKofICktyxuzasWW10RPd0KCA7/2JXVULo1hEUMXrCo3glaY1IUUYA?=
 =?us-ascii?Q?hJmPB30NmrKR38N1Rxbrg/D8eo+DkR1OQ5Av97h6Ya99Kiv+gppxwcfQEyNU?=
 =?us-ascii?Q?KzOGNkhC2lNH1jgOXXWqiTKkYRgV++xVW0yTEAqaloxlQ7ja4BC6DNu3Rr9+?=
 =?us-ascii?Q?QvDfUZCJnt7I5LeVEyhlvRRxUyq/njzw21Tak99PWbb1DoBBm7eTIVqKGj6A?=
 =?us-ascii?Q?UXosLYnyzmG15MWO3jxIjxG7NftBANLCgU0v7gd+rXeR8TRwp5+xWkXtNt8s?=
 =?us-ascii?Q?VWek9Jdr4uV/ROAf9f6We3s1DdmKunm5yDS0szxZuTvWokcPDYaqhlBrz/f3?=
 =?us-ascii?Q?RXsS2b1VLWT8htIxprYu7FGbsyN6Lh/5eB2zcrO+dRYBpANkCxMgMCLuBxdG?=
 =?us-ascii?Q?Bs22LDuv5nwj/7IankMIgSk207QXOhpW2IptNOJA1xSDMBqP7xFLNmnfGGzP?=
 =?us-ascii?Q?eVL9uY2mmxpaHVAuhjRw4cHouu8q1LPVcWUiddTSXpVhUunO36G2/1RuXPQe?=
 =?us-ascii?Q?J2qvs+gOiZJrNMGLeVklBixYaNSzJzNnbLArboH57N62RzDNhaUwlXs1gJeG?=
 =?us-ascii?Q?4RRZPf2EoqAtUOIU/FJUbTkTMmZ+UMGFOY+fSGGI770v7uiOfZKiUQ/3L9LD?=
 =?us-ascii?Q?kKEH7pqDERvaJzALeDPgIO8xPSx+vO8rO0IdWjGd9M0WrWpuJ3RJU5kMZopW?=
 =?us-ascii?Q?9gChdzNhMyb8A6P/a8PWVWZsUdyd0rD6f1j3kKXWZtYsWaLTqvRKU/OHLJM9?=
 =?us-ascii?Q?ZgWyuFgydMHRYbEiYkkJUFzAYqeX5XiPcSDskd2dM8O6G6xKe2MiP4nfqcV3?=
 =?us-ascii?Q?+itnOdLGgmQv4cCPfBon2vw3Vocbm2TSl66arVVYFFIoPPybS8Jbi4krwJ4n?=
 =?us-ascii?Q?tocdNC/ypBJ7NkcpYZ6j0D8yELwwTpXNNqRmxSwthxQ8wxqE/FBdfGGyqK7u?=
 =?us-ascii?Q?YRYliGvmpDNbok6nCAYPLLRL0rhed8e5Yl/Vpv/XUW2FvnRqzirnv4geG8mv?=
 =?us-ascii?Q?oNzSFNymTa3rr2SDOBQ5ZzJ4kiRRV8YPISh94V46ftwYnB9oUpXdeZDC1LDm?=
 =?us-ascii?Q?wN4ljyfbttzPcpQl8d90rk5hEvMnEMyI9EO+l6bVhzmgUAQhZGYjTOvDpcZC?=
 =?us-ascii?Q?NN5OufKAWyE9yO5T0iGGz3uKLRi6HIC0crmtm6Iz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74ec1ad9-5768-4989-4055-08de0a7b8bd9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 17:11:27.8024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aKt6HqhsiqgjEdu9KjTZ0j1dLOoYaJtXIY9F7aBoocZNnD1qHvz2faJs4KdSKkHx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9728
X-Rspamd-Queue-Id: 8BAFE100007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: a3k4uqnjttzpzb4o57uobfbwtx4pauag
X-HE-Tag: 1760375491-174865
X-HE-Meta: U2FsdGVkX19Qs7mg8ZN/EyrBECChgOStR3Vmvh/JCQaZ8y4c8fbPa4RAbWGIj1RA3Q/zavUeROYKARrzwBOnBK0bqTXMPqDwc8ykWMSdWEX+tFY6Lg90qsBZHpK8WgZuRMnWWwI6XyBE6bLYLnC+otwIlHuXa1+SFs5zGHR9hD4HnOFisinBqcduOUnCy3sfaOl16Zn2grAybxEHM1tKzl5SBS2WEnG+QCC+E2g3NRHXazyMCWfGOOH8Er6oLCOwmtPiZTmSnw+c+StYXv19GHF5dVG1iNNjIzmAiTz2n9mAo3HEsbpZdm0qU2G8VRzqxgudCGrC9Q9bBqOUGx8OUNTfUIsy9A8ACDDU+bFaliaPZ3ObifKqXnEUaokZaWzZiJjbWK8iKwV3Ws4x0xZTweFgCcEWTkXtHnqy0fDh/F6RMRcCJPTYbbp9qJlFu/tNZxdNzAo8gzazzwFOGCDU1o7QW1e47hF3JS2li8g8DWnzU9mnIj1bsPk8EBCz/NkAc/5OJq6n9q8e///UYLGJd4GIKsJDR2rxXuDbsZ3LSpjKrjpVO+RTVtNoTKjG3Z5gJUidceFev6LMagFnVAXAU7VxfQkOEYwf6GxZ3UmTMaqVnH+tpkQkTdhREsDbW5/fjLDAlyqrm8OQbK0sX7H5+ZgdXHmNoRfoqtDVj/kMq9vIemX+s4NFHKnAaBpHpiDUFLAmXn85Hmoklr0Dl5q5HKXvOUq0pU6j7mREOK6fvORKbTOSXvg4Mk1hkV2ttDcVdWEUt0swRBPhflb6Z/4RUQBY3g+WhwA48d3cUVQL0K3QwBipWC5OYz+nztin2BK+t57vdZepn7CAEQHRhIwgyinMCFXonymuRxg4V4lrNlxR0Wo+9HGpiDj11qmBBBswndaGuo1BcrsIw4R2Al98dWiD7ptWBbnDyKgRzf/JH0pGANzYT5KyvZm/0Co1IGZ5sY0m4JY2xUjrwAdHvYp
 B4ieSnth
 IhI+5qmm0L0NBYbRiSv+9uGaq6odLs5LqIfHikO+8yYvbyI/UmTkEsnPd4zaPyFlUenPBFaTdXQn4w+eddxLeF1yQXgguIMQf7y+JrBLCK1p9Upvs3osol5Yvofd82o2de2beTzfMylLbdyUkh993KwvnyqE8LCLB4SrShfYnIsgFKZXxDQNwfW9gcc/ChmQUPeu0l+Mz9GckZDOfW/3+w1qcuHH45jJi89KmR9gu4W97RcwNQTjFXCJCjuQ0iqsCZk9QdjE+OIIyxyWT7ixmR3+Cwh+Q0hKlK2FLfdIiRXgOPB9pyFIpQioBvNO/48q1LB9yTqGQP4m/mlMOy5mYDSac3UhDXpKBQihcNR/IBBQZOQsAeRfZS4PhK5db1d0UnECY/4btJECuY8+BvunZQ8kcnlavC4JWHk360eCewfJ0JN2DVxt3JHrtsWBZtepI1UEP7A9grFG9TgueIDxIWuJLRv0ju9wSOBM6SWWkA4+U5Y2u031xvJeaTJisbmuR3c5eDzix72jxey4+o9IF5JzN1VSzuahLDviwxc1SXYYN4R+2d2Qo8VdCUnPJOrFOVuu0JQRZz+B400udYH3nh2BezKV5EzcQpUzXAeg/dy1SQc8KnhcLZ5JNM1rEGM1qvWAF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Oct 2025, at 14:02, Luis Chamberlain wrote:

> On Fri, Oct 10, 2025 at 01:39:05PM -0400, Zi Yan wrote:
>> Page cache folios from a file system that support large block size (LB=
S)
>> can have minimal folio order greater than 0, thus a high order folio m=
ight
>> not be able to be split down to order-0. Commit e220917fa507 ("mm: spl=
it a
>> folio in minimum folio order chunks") bumps the target order of
>> split_huge_page*() to the minimum allowed order when splitting a LBS f=
olio.
>> This causes confusion for some split_huge_page*() callers like memory
>> failure handling code, since they expect after-split folios all have
>> order-0 when split succeeds but in really get min_order_for_split() or=
der
>> folios.
>>
>> Fix it by failing a split if the folio cannot be split to the target o=
rder.
>>
>> Fixes: e220917fa507 ("mm: split a folio in minimum folio order chunks"=
)
>> [The test poisons LBS folios, which cannot be split to order-0 folios,=
 and
>> also tries to poison all memory. The non split LBS folios take more me=
mory
>> than the test anticipated, leading to OOM. The patch fixed the kernel
>> warning and the test needs some change to avoid OOM.]
>> Reported-by: syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com
>> Closes: https://lore.kernel.org/all/68d2c943.a70a0220.1b52b.02b3.GAE@g=
oogle.com/
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

Thanks.

--
Best Regards,
Yan, Zi

