Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 445BAC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 16:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B9A56B00A4; Tue,  7 Jul 2026 12:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0922C6B00A5; Tue,  7 Jul 2026 12:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC3B46B00A6; Tue,  7 Jul 2026 12:13:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4F356B00A4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:13:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 33D088EA7F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:13:18 +0000 (UTC)
X-FDA: 84962475276.30.B55E4FA
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013049.outbound.protection.outlook.com [40.107.201.49])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4EF8EA0002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:13:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uVr0J3wp;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783440795;
	b=EDRCMNNLdUzbcReFSVZvSYczocglm96cv8tUQQvhYyRGSdrDXcdBjoFH9C4lQwEM/n4eeg
	cXl2GeM7x4q8Abu5JTCcZ34IGxr7Pi1lPpNwtdBP+zVy9kMosP35HKYaQ98ChRrOVJ/jam
	eAtd81lCyEAELz1C0UV8FvIKcf/LaMU=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uVr0J3wp;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783440795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=25FjlUSL7hxsYSdSscrrl2zJLsnGL7JL5Y2QBrWtH+g=;
	b=adWbjzVDKFX40CS9JOGYSUaL/9Fb4IG/jghVskOT7vLcKT0pi/WcMI2j7bsvWckafYCW81
	bIu0D8UBT665pV8qc2UC55W5cw5afPPFQnd4nCtjM/3Xynt1ZYDF22qhZfrhM80d6eXEG5
	Xjz7cAkYeFPc9YS4iZd+Jy+sON/CqeM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gT1JLgUjuboFJdEFFZP73ch9AAfdCcaAh/IA/nuHxQ4mwh/vUqQ+OEGB6ptlFbcDcRua+UvE2bpNgaU2ZljqiQ9YKyOpnH5CEhhqjWiyYSTCOpJteu6kKbY6olEs6egAOgDdcADMSvNt4Usyetwlc6OQJe+H6beocfF/EQKqbDl4gp3dhKrQqYdfHuTTpf+ifNJjrMLXXOrSK54ItDOQ2jyoV0SuBtFIVwoh1trXGs44q2JWLWtXr9eX4O2MZTTWQ2P6Jgh+osSKewf4Wr8NtqSnxFnScdPS7zmkx3kxfeXS9VVKWlbK+PD/ps6z0l2deF9rpYDMShIYt/gH0+7qqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=25FjlUSL7hxsYSdSscrrl2zJLsnGL7JL5Y2QBrWtH+g=;
 b=sLSsXyRVH7/IrYOn9Ri9457kq9MP6c0X5EcjE3RXQZZC9O2M1Un8xFXcWQeIF6B99s1deYtQ22+DubkaxCeqRitfb0yyUEZaOtkewAf0iackGCbHpIxW5DA7eX1BCOOfytMgpcSnvKAWsgGpOcF6DlTFe0YivSS2Gp8JTycl7wtTksxeCwM6OaYl0h4WESKO1RR+zOnOfD5XyiZv4ExenOSxpMuXu6UpxYfgCfdXCWdfh2AGAcPdt6qhlCV2X55X0AJMD3shO2D28mm8PJzfta6L3IOUlIMyE1/STepQLzRvp/4R/8iM94QHTR33t38g3z6vTsVtXz9DIEwmes4Mvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=25FjlUSL7hxsYSdSscrrl2zJLsnGL7JL5Y2QBrWtH+g=;
 b=uVr0J3wpo9/8PucLUgudq2Bkmc6xzdxaMogxusMWkOQDaSj/IJMQMYd185i6x2Rd2quMnozQRNcKYbewNhfncyNEm69sM86pUCwIPD82msYWOeCdMtoCisx6dGXFGJl3L4IU3ccY6AVhadqDyGPbG57OWZLcZkUK7NIuj42aRkGhsWNwT5kY5JfM2n/x9Ky5fX6PIPecHp5OIDb49bvb+twvj2p2ZNWRz4eWX+LrmDNmUpuzvayYbiaNZjld/6gqllL6r9LN08p6pbUdRjahC1r0BSrfAx+JKlntqfsXVOQTI4hNXQgDTWypzFzirRA9DeW7HY50Kz+kBpJbTT1c7w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB9727.namprd12.prod.outlook.com (2603:10b6:8:226::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 7 Jul 2026
 16:13:10 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Tue, 7 Jul 2026
 16:13:10 +0000
From: Zi Yan <ziy@nvidia.com>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 4/4] mm/page_owner: document page_owner filter
Date: Tue, 07 Jul 2026 12:13:09 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <90085A6E-57FA-4FE9-914D-56378AB42008@nvidia.com>
In-Reply-To: <20260707115411.1714314-5-zhen.ni@easystack.cn>
References: <20260707115411.1714314-1-zhen.ni@easystack.cn>
 <20260707115411.1714314-5-zhen.ni@easystack.cn>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1P222CA0020.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::25) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB9727:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cc071b2-5881-4d5f-a4fd-08dedc42a3ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|56012099006|11063799006|22082099003|4143699003|18002099003;
X-Microsoft-Antispam-Message-Info:
	w0iRPM4A//auL3Y5Njb6RO3deue9HMFwwJaD9lzFDZX+LUL4Hp9TiN3zqQ+IsEslV+hcFNsj4pOwK2JxxwA1aNn6/OYTJct8g19YSZG6fmmO9nzL7A28NuAIxBcxwrLl16I/dV4/e6vGTejkw/ZQJRpdzeAp5vYB3RHU+Pd8KkGkAhu/Y2ojlcP6b1kUfL1+xINXEzVq+86sMW/nOcUUUdXBi36x/XYCD2u0GEEGEdrY8a2Z44ZSe3XhfL0hDBaaUq+HuW09EwHD7LpesQHeFgPS5KzimIeGziWm7YpPf9CAc+29mmtfcWDRlFIQ9gfjBCdx9q0pWVVeZBvSIFoPM/gJjsKf+Fh0DqZxvFgu6lDTwUBgvo1aFGGUky4zZOTTPo52QVhYOHAi8UlneOBJfKiVEJqpEra3dX/tNXlX+uEPhl9nWzaN0I520V2TQFHpP3bzPS8t6kmKMuThiIPNGUp/DUXzGRVeFlj0klUZE0CMIBnOt5YcLkF20PxhlAMswpkhyJoEn8GLvjJ5akF6AMEdbfb2JRZH9tcGY7abfdwnM1+Mp/UVQh0bkIfcLRlMtON5D8Z7enh6z11yf0bHH5DA0IWYa+O0TYxIONvZ9ebBPBorYXPmZBruxg1r82LXd13KZN26OLeJO1nZrm+8jjCXd/uzQ42ABTUwXEjYdp8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(56012099006)(11063799006)(22082099003)(4143699003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pL3Oa6t2fOwGghPscYv2tq6U1R3luWWoQdTZaDVXsMKbU9sYneUfqHfuQrCk?=
 =?us-ascii?Q?VwRHC2dCIARurb2ZSGFAnFVH+NBBvqYrGG+0oJlSoubgKt42FOPRIY5yk0X1?=
 =?us-ascii?Q?wzrEefhsWnPcf1NYGVvFrEY4nPTcIOOn2TgpK49wDBscEl9IJszCmwtdVwYj?=
 =?us-ascii?Q?ueoSdMMv8/u1A4Yf6o1KdZhdzlG3MDjOx22NqhlE4mk75jOpkguNJtVvDMvn?=
 =?us-ascii?Q?M1Cp64eRUz53HCswcctaj1pLD/y/CBBb/lGhCiFzRdBz3aeBPBY7/w+zOBL/?=
 =?us-ascii?Q?bMS19TJNtwlNwEScuOFr1asTK0ToJiyh2Uel3IRrLWOkqTMkSSvnSOPASdUG?=
 =?us-ascii?Q?ViK97MpyjDDPK86IK24BmBBB+qvKiGUVftpucRwMFEwxR3qReUNcIDjzfJT2?=
 =?us-ascii?Q?ZAnnndz587Q6VvFC+ZoUoW0jwqslk3QOlvOfClK046r9d4Vjv4hZ52yQUWNQ?=
 =?us-ascii?Q?bpHhdDkBkaViqBF9aoi9V8sSLuUj77h+YBpdJvPeeX2T2kbJn2xI9LfEg5Gl?=
 =?us-ascii?Q?T6H/c5y/5jPjeSqWOA7N2qUFWQPx2UgeX3pbS/YnWoUoo+7Zqhp1K57LfLBd?=
 =?us-ascii?Q?SQs8wfZ5OLs7BmdxO+BqyuOooDkeGg4+9RRol4U7shi/xiSrVi8+VZh6oVi/?=
 =?us-ascii?Q?I/x378qe84JnrkdIpT5554sZAmRP4z3wnuY+0dQazRzy4lxWBn73ELjxiSSA?=
 =?us-ascii?Q?Nqf8sV6sKj35svIhwaGxVzbanoG0owoIB8gWyd7lp3+ZAg8xf61ByGwsZu/6?=
 =?us-ascii?Q?ZZDCNKui0KYLqnAl817ggSwVszZ0ZHD+FUoUZjUg3kAup07Rb5da4ciMwRg8?=
 =?us-ascii?Q?wXQFtNdg41qmOQnjjBinHQPgFloVWkjiIefMxb9RSHa6cAxzuopx3qvg/dF1?=
 =?us-ascii?Q?oJd9Uqb6Qaj8ZvbdKceqf95R/N5QhnTIdOhe0OmegT1ecr/Ad3yqXMBwYAhw?=
 =?us-ascii?Q?u0AWB70JslJAKPQDjOAN9adrF6Ny0QyeZwMQWX0APSL/ChEiTgm9SvEOnmkY?=
 =?us-ascii?Q?9i7f1XJM6cbjSu0NFdkd+CowHxaaSpH6bw8Pyhl7zUtdYv0U01EqA/F2eWk9?=
 =?us-ascii?Q?bBGuuktj6Le7pHMoI/xr0PHw9IuM7hD4kGJYxN1SmJ8n5ibufv/N+aIPZwyA?=
 =?us-ascii?Q?Erxyd8GjChdVaWInmUyMAnGpCe/7JPfqb+kT4pZy2KwUUWkxqRAbjCr/vZC1?=
 =?us-ascii?Q?LjQx+PNcWabcXjQPALz3mPPofvWxTbC3bhjhC9DiC+7Q3Z3ATptMVDgKIXxy?=
 =?us-ascii?Q?aB2mP/1t9o4zY13cI8byCpcx4cg/WJnbbaPIx32eehC4pv2CAVbuMjVSEKU7?=
 =?us-ascii?Q?8zh9SYckf9F9ujTXnTISTqdSj0ZnByH1SuSWtSHYru1lG28L9Cr3+g0gkcy1?=
 =?us-ascii?Q?G+K1JsrbXbsVlG+gwUd7g67Cdor1o2KYnZI1il2gMP3Rx9d1ME9y+nXNsutD?=
 =?us-ascii?Q?d0M+6ahzBb3MTOwrBTlFR4EmpgBdN7XhSd4YXxKcrSoNhLvFS4uSOQLjuf1s?=
 =?us-ascii?Q?zoPuK8uPTWpUcc0GcNtnGzcHo38L5DW4vTIE5ERg4B8Gu3tZLDt66o/3x7M+?=
 =?us-ascii?Q?+jf4NWEiAYbUgvf2X6QY2ZGqlEk4FoJ7kE1tnaAtQkDidflWzUGUXSB5rfOT?=
 =?us-ascii?Q?3IvzSVShAFEPm9mpKEe9mUGdBQM86uRu6BaFUwgrafbHu3hN0EEid8tn5Axy?=
 =?us-ascii?Q?oU9kH7YHiur/BqD8OXkeSBCvmP3/VH9REe8JOrdBZYRZF44y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cc071b2-5881-4d5f-a4fd-08dedc42a3ba
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 16:13:10.7468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cwVl9tR64+W4VqEQEJVJLKDp4mJxSrJq9JE9SMs0/d1GyI2fYdRKZBGP0b6v5I4M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9727
X-Rspamd-Queue-Id: 4EF8EA0002
X-Rspam-User: 
X-Stat-Signature: nk3do7tf437wpp6iqtx8mndsancygb3m
X-Rspamd-Server: rspam03
X-HE-Tag: 1783440795-490660
X-HE-Meta: U2FsdGVkX18K47JMF1GMoYkzyPIBMj2sbj1CFEDc5czEWJ7wbf0tP4nSPCg0xN5ELYANUJAWNO4jGX5tR08YiDHU9Ncdn/KO+kXGzlgtqUZuWOv4JrRfQW4WuhfZuOGVLKZQKxLlIxPGFUQq2SHL/BVtcm2uKmnBLtuIfbAtegPFOlihKu/DB6y5GdnJuiTjOUX00UHG1Q0V5btzT8COf4fPXr8nqi77S/hwePmlIgvZS/ldbiWDvGfFXhWmeGBoeitLul+pm7rvYZ3S+kkBmvHl32c7tDoxMacwPqfB3ob4ijsstErhP0zBliW/8ygFCYrw4OMWQhNLxwVvU2IdpTgZS5c+/5Q5Yj6gGoFAr9q1DdzGxMZvwk+Fk3GkH2wplPPUoJGOPaooMasBlbkQ6PVNFtghmzBP07m7UKQJ20XeM/frmDogPyx+kAU5pTVUzFjPU051dNl8Ga2z2eojyXrs2penHdG4UVC7QwyQXIefbI141cS+cncRwRuaQaSlHuaFa50YWkHmjsIdOnEPGeHX2tAdUPRJf8VVvq7WPwx3cH6uA5kcpyKQVsih9PL5AyAOu7ygmdBCQQFih31EF19nUxtu67FvlQrgI8PAW1bZXj6eVeYFavrJ/8SOH98HiT37iL2iUrXbZyINlCunxrR7v0ZUPlt81GHbv+4yyAIj5StJf5jr6n7uFXTMlQImmD0i2cSftPXNLgFzl2dmnKRGtPi4c0sfYlQ+iThoKZ2AT1YiSN2N7rc1xuHI4olKH195u2Vpmbv90qMh99v2tK/9Y8hO3vP4IKd8L47NJ1r684IXCD6iEztcKmK5njgqNNkesXnW6Kd8dMuM4LHaeharrMML8ml8J3m6rpOqsYDvvBP5qdrMfeXqLoFaYzmA/xz8ToDTqdIDZwlyhCNMxFe4qEaSkJHUFd4a5OZ7ftbLeVXSkpZX4WjPl9ncf+nIDH0ibURrd1HF8rFfgp3
 /5rDFJKn
 hc32O9N75ha+jpF8Xtf5haTPM4urBbhZHWqZJswn2pA9K+ovwh3TqNohepSEp9UkEV8YeklbWqMqplMWgsu09Vj8apGbn5ku341sr4/t8X6YOr0uMTqBwSVTB9nOjQrRCUBgTD5dva76brGmkAlRohoaqSsN29pq0C6OBigXNNgDFcisE3oaUdrLRpWtZj4xWlq9xfVZ6N9p7qOQCHuwbLLtbv8RXVKGFrHEPC0koyquzbiTJhG3yTCqTaIoADlwmZmmjQ9UdyFAqeekUha0SD+CfNyUElZsRFX52jP8M0QAZumYxuO9T3860NVjF9Lt2/0fisjRZqtiPbyVkuWynFd17vsYb5YStohY4B1aaeeQx5AU8FkrHfBblLm0dtJZc/DeOXk7qZprYjzfURtlOAXAm39gZIsiGVc0J7KPeJETwniUzM1RUYtpJZ226vIHm74LEx83+Xk9hg8k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7 Jul 2026, at 7:54, Zhen Ni wrote:

> Add documentation for the page_owner_filter userspace tool and
> kernel-level filtering features.
>
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> ---
> Changes in v12:
> - No changes
>
> Changes in v11:
> - No changes
>
> Changes in v10:
> - No changes
>
> Changes in v9:
> - No changes
>
> Changes in v8:
> - Fix Sphinx double colon warning
>
> Changes in v7:
> - document for per-file-descriptor implementation
>
> Changes in v6:
> - No code changes
>
> Changes in v5:
> - No code changes
>
> Changes in v4:
> - Update print_mode documentation to reflect string-based interface
>   * Change from "0/1" to "full_stack"/"stack_handle"
>   * Add bracket notation example: "[full_stack] stack_handle"
> - Update NUMA filter documentation
>   * Remove "-1" example
>   * Add empty string as clear method
> - Fix indentation: use tabs instead of spaces in code examples
>
> Changes in v3:
> - New patch to document filter features as requested by Andrew Morton
>
> v11: https://lore.kernel.org/linux-mm/20260625043101.338794-5-zhen.ni@e=
asystack.cn/
> v10: https://lore.kernel.org/linux-mm/20260618035750.3724613-5-zhen.ni@=
easystack.cn/
> v9: https://lore.kernel.org/linux-mm/20260525081652.2210206-5-zhen.ni@e=
asystack.cn/
> v8: https://lore.kernel.org/linux-mm/20260520075641.1931080-5-zhen.ni@e=
asystack.cn/
> v7: https://lore.kernel.org/linux-mm/20260515091942.1535677-5-zhen.ni@e=
asystack.cn/
> v6: https://lore.kernel.org/linux-mm/20260511033017.747781-4-zhen.ni@ea=
systack.cn/
> v5: https://lore.kernel.org/linux-mm/20260507064643.179187-4-zhen.ni@ea=
systack.cn/
> v4: https://lore.kernel.org/linux-mm/20260430163247.13628-4-zhen.ni@eas=
ystack.cn/
> v3: https://lore.kernel.org/linux-mm/20260428071112.1420380-5-zhen.ni@e=
asystack.cn/
> ---
>  Documentation/mm/page_owner.rst | 77 ++++++++++++++++++++++++++++++++-=

>  1 file changed, 75 insertions(+), 2 deletions(-)
>

Acked-by: Zi Yan <ziy@nvidia.com>


Best Regards,
Yan, Zi

