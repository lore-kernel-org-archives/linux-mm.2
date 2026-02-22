Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FCA5C61DE7
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 03:00:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA6E46B0088; Sat, 21 Feb 2026 22:00:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7EB36B0089; Sat, 21 Feb 2026 22:00:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5FA26B008A; Sat, 21 Feb 2026 22:00:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F9566B0088
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 22:00:53 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 208B3BA2D9
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:00:53 +0000 (UTC)
X-FDA: 84470590386.01.F1AFB5A
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010000.outbound.protection.outlook.com [40.93.198.0])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3144716000D
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:00:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aHQ0pCRS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.0 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771729250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+oYXgyi1de/96uCnPfXe5AN3hRRvtsnINanfxEMvRfM=;
	b=5xqBokKJfhRQROeDe3tYg5/0QHAjVgnwHQEej/rPlIwCRkhY5TXA09XLfm4uEchpydqAJV
	77znVQrFL3mCmJE8jO2A6g+y94/VWW9iun3vYPGz5NE80vCWTF7NSgEmZVDfNdH4On+xQb
	He/nDdpLhkf6LHR5dHmNtj+hHxgSCGI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771729250; a=rsa-sha256;
	cv=pass;
	b=s5ohCnRbZGlOxTlKG0Z5WvWP2iIiREriL2PPbKQulWJrMtChkS9OHOaHb8pv4nphU9Q3z8
	qytUIE6HlVJWXpYcqfLeFeAK70FUbuDIi9gmh1V7h38P5TP0avOnlk0E+ncTYIFJKa4pX+
	ZLTrkKkdo17myh9AYjtdHevsxh0bSvg=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aHQ0pCRS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.0 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tNs5b9HX2HBMl9hPU/b3OlUcDCBHPDC4NIdDXEbzRuAZ+LBqkd9PCAbTKkA8D2C9OS8Gjj8I34zrmneSFNXdBwxM0zew9yD4yKWs8Rhz/dfPdNzFXoYamYoJrFVPoiRcQcMYNWrEvmrlEyllmSwKMdvxoTAAETQBQny/hRO6ekurJL2cGk0bN75/Ts30YhmUdYOh3+gszksKYj7AvI/HVUqyLhsUKW45Ph6sXZBq+4zfXyzR+o7SoB2c1zjb1TMgEu6O3aIdE80+23+kkSNA4e9wxHo+qoaIUp6OTCriFYkVKAtv1KSmGZa2++/1nx6wNnCvCgkxqieobOiAPNgCkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+oYXgyi1de/96uCnPfXe5AN3hRRvtsnINanfxEMvRfM=;
 b=oNY1qHEJ3euTTEyJa/KLUHax5K8WGcRS49OYosTFECqG/9oVTayKGTCkpVdXKh31rbunK04zFlII9ezwjINyWOEHgJXZYLfPFqK7tMdXfPLNPzRZM0Go5dmJ2CRbZesMWkKZfj9hjTIjgkxQyKqUrtDtDBgdq8B2uXwQOQuxuUuwour9upHQYe442j3GQ5w35F5IN4CjHWHWEYkLTOmLEr3jnsxFDZMFrMiqw2jchaGTIQZidkFwF9SeI76gNDBRl2npcEESligfG8/ktNtmOt/bYdN+XufZLqLowkArvNJ6N0R8Aw4Hc+sG/0qSr0YpLkpNGIHGgDwTkyNVjTSvWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+oYXgyi1de/96uCnPfXe5AN3hRRvtsnINanfxEMvRfM=;
 b=aHQ0pCRSbedb6OGe+Hc4JJbANlRUVQP3qJh1+UJi4EqDne31AsdSRBHAFrYrDQReN4ReXPJQqWbBAFOp/0rzeXLb8umyzroCEhMrGaER4v7OfsVj2CxlbiWDaSCdi6h0RSKHA9huw4YTAOKRdbFof/BrPRGqSY/DHHOBzkNXGHUhDwHsuWCq26OBTeAyaXVp6NnX67LsF2I+cs1/Pq395xspgXgcvojurOzE96juKbCPCb1+1YWGKkwOWqziT/fSR7FO9hlTmpdVcJoP4TMfsKkrWKEptI2U5evTAp0K30qhdKCaOZa3rwA1tX27/UdI6w/ewqOWmbufEiP1uWwcgg==
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by CH2PR12MB4277.namprd12.prod.outlook.com (2603:10b6:610:ae::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Sun, 22 Feb
 2026 03:00:46 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.20.9632.017; Sun, 22 Feb 2026
 03:00:46 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Linux MM <linux-mm@kvack.org>
Subject: Re: A potential refcount issue during __folio_split
Date: Sat, 21 Feb 2026 22:00:44 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <6346656B-7518-4A55-8DEF-C2E975714C8B@nvidia.com>
In-Reply-To: <20260222010708.uohpmddmzaa4i4ic@master>
References: <20260222010425.gbsjzhrew3pg4qrw@master>
 <20260222010708.uohpmddmzaa4i4ic@master>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0259.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::24) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|CH2PR12MB4277:EE_
X-MS-Office365-Filtering-Correlation-Id: d41c0bdd-2c92-4dd2-aaff-08de71be9332
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wUBK1Z9L6EQoJxLSHRdRiF3dNQsk+ad3SyagiTn3eBfS4nSelRoMRXPG/BpA?=
 =?us-ascii?Q?i209SRDBnetW0jH7BR9N8i18dzs0HFdNUFNQpaKPKsIy/0PaX9H9yg4zbPcR?=
 =?us-ascii?Q?mP0++RITdrSSIKndQEjla3kHLQfVg7ViupiIfefKoAkE3ecjqUEsg4WgOH1Y?=
 =?us-ascii?Q?+WEPPIRB50HD7QFFW5O7T7w32Ml44hD0QDp5r241B5S2nnLOPk2YFNSUuP+Z?=
 =?us-ascii?Q?y7b2tQy1ONb4r/DaAa3WuYP654yBrj/b35B3x7GppO0k5WnyWoOEvdTnuAiY?=
 =?us-ascii?Q?BYWI0TMq7eZQ/pVWF9uiMg1MkLN2TorNdlHmyVqoX7E9tXaweJDR6Fd0Z1+R?=
 =?us-ascii?Q?AZX9qEkrvy91EKCVo/+Hb8JJirH3zTuyRXNIV5Vamt9oD3fnUAwlMyd7Jczd?=
 =?us-ascii?Q?PdJaXI5jZAsP0+HMp+jW43GZVT2sh4V8SYX1bdGc5b4a5tCqaiU4bEgb/Kgu?=
 =?us-ascii?Q?h2WFP82U3bdAKGilRL/HANTxvkxkwxTp++G3K7cJi0xz1D0OMRMtThAUls2z?=
 =?us-ascii?Q?tBrqEsEvx8EjZqKoHqgRDQEqz1LWmYePkLBuf0iqv4mSDu67ZA5GxLIjLSZL?=
 =?us-ascii?Q?6je+YPjkMLqruk9ESuggMWKk3h07qnenfnnKFTjpZG8NGTUTME32qpXORzwM?=
 =?us-ascii?Q?MYGcs7gfbprq0xCnAZ2xEbFIcWe0BT/v22RMnZPtCfdY5ngHpEcpnxtoLoLg?=
 =?us-ascii?Q?kG7+ukINNy363CCKInmR9fuyBpzLhwV40XGI+s2RjktVwG00d67EGH1cBYgO?=
 =?us-ascii?Q?DUskSE0WHjh2Yd9MQ7QjNc7WCskpXJOWQ0wZmEbAraLaAPljhnILj2vhoK0J?=
 =?us-ascii?Q?iqGfQUhZNIjJUo2U72MGVIPpFMlEy0VytTaXtiQYX0/hI7A5Mh+oHH9fC+YP?=
 =?us-ascii?Q?9VBnU7ZZdnxCgmXwqjspO+9QkGAevZRBO7OA6Wf5KD2KxzLeAw/9BOoFTAaS?=
 =?us-ascii?Q?Ed35LrkYspy/sxl16ReMF6UpTowbpjtzz2ja2vW3Dmuc7AyGRnMp4yvWxpND?=
 =?us-ascii?Q?c2/xnje6MD9MrL0KARhyeEpANKYsTPySf2MplBTjjHNmR8UZlOHDmXv7mxrl?=
 =?us-ascii?Q?0+sn7xxdJmXAob0zXoi4F3X/mcz4/6AR/pvDimmRhUsSfpYUt+kBenySHTnv?=
 =?us-ascii?Q?BQVQkfwH3cobjxqax+++nQXFvrW3yE2S2WH56olPSZ3ptoiI7+g2SH7HsiVq?=
 =?us-ascii?Q?W2CEeFzF6tH2deQC+dZCn346/8e8e9u1QkajZf0fP7+WVdxrEkQSX71gIAu7?=
 =?us-ascii?Q?GZseb4HUgKdMfyrGazckl9yCtcCrAr0lHsoKC2zOBiXSGYElwYCxJK+u0vKT?=
 =?us-ascii?Q?LOjzsM8SzAsIrzbIi1SCd/E0Y/Tz5ul9wP+vApuwEQlQOsj64hklQzbtIvWe?=
 =?us-ascii?Q?m8cuuW5dmt8vyk/d/4LEDp4B/hR//3DLubI6MidGxeBOQcaD630a/1mm2Y7c?=
 =?us-ascii?Q?POFeFmh/sjXO/SlF995Dkl8pVzlDL7tt7NUAfipZWp8bsSzpustTA5VQn0qM?=
 =?us-ascii?Q?+UAgaPJZRxgn1DmeFhmlbwEjocyg91PXAAm3YurDa0uctqOcObTvcpAh5ydc?=
 =?us-ascii?Q?mD7Y0RETgP7rFSfOnpg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?37xM4S9rPpEJqhfrkgKlnmoqMUaGujmw4QqigEBCGzf5CA056Mbpv46rcYY+?=
 =?us-ascii?Q?0a0Ds8RUqIwkKzWR9ffqNbtqQVk6inE+XX8/sFqsHMAVQt9d7fD62/pBUciZ?=
 =?us-ascii?Q?3+x0b04sSb/b2AJlR6Utg4w69u+LMV++GMEY76SUcYHo0SWYqvh2T+3D3nIp?=
 =?us-ascii?Q?qrcFkRe1ApZK13Ny8goTX3Ku5/k0L4Cn0rOBTH7MP250krzXjIdsRZhD3+TP?=
 =?us-ascii?Q?z41jtkysRh/Q3qFrfmuSJyQfz6aw864bPcqeeG5P7QVzj43dowlKsZ/mnBJA?=
 =?us-ascii?Q?FRz5l8PMsIHTG5k8Emt3phpMdpoaJR9mdCnNU3WMmf2Ykcgt/7qrrPv79+ex?=
 =?us-ascii?Q?yxRNOxBhM0pGbQYiErB0ExlBzRINrcDXiC35DUWPpbwuHl/+lkhGg7QfVVj8?=
 =?us-ascii?Q?kC5/QiD83+uaLEaFi+w24A5bxIGt6kUCwYwUBrNKy32ojOmJd9EXY0TpU3f/?=
 =?us-ascii?Q?CVcWbf7neJDCWnW8gCPAaKFmrE8MHXLwJ4L+DhD5F6M5cECtEs4UeRrq0Wfl?=
 =?us-ascii?Q?SocdY8adKDbSEuy9j2gK5NevucgebujcJ/u2aHQIaJdfM59EPaVGNpoXQrJy?=
 =?us-ascii?Q?2ofn+BZpvM7o6lXxTMupL2oYDUfeURDQpAFqNDCoRZNshYkZG0QW8+euuBw1?=
 =?us-ascii?Q?xnmjUJZbOJmlaqmE7U2TR058GVHh4Zyd7mET8N56L3uAO+nUW8Cj1m/DnpYN?=
 =?us-ascii?Q?HXvP5hUMzVF5xYTr1d3welVrbqfdOqigYVwsEoRKmy1Tubd2wdUVFPRBq6C9?=
 =?us-ascii?Q?DHZGes2zGuK6Xv2bKZvWSu0Hgbe8RTyT1Ue2SAJT2RJwDGk5XEV3TO67IeTu?=
 =?us-ascii?Q?KRqxHHfP2704tWWOgfSFGLnJ7rSuC57JSELk0uBOqiFIKIz9Lionej0zv7m+?=
 =?us-ascii?Q?YG6zf3sDmHd4N9re5UF78fv4ywo+mBZQiuT6pkKgpg5yJsIxaMZbt80mlmWk?=
 =?us-ascii?Q?IUKe6jf3WyG1QuNb2X7uJt0SxzRRU4NVBViVMP8VDa+hgszjdTUckYKCeHtV?=
 =?us-ascii?Q?LpvjSHpyEJt0/LshtQ3NhLU1aUANsclHJo3QVS0brrooJZzGlI229iPYFdb7?=
 =?us-ascii?Q?FuL7yR+qA8v+3nocEjTv7oPIOAoemieymgZ9V7JyqXndJJAwFp4Sg3HaPwRt?=
 =?us-ascii?Q?fMwG9nQyJQ2AIuBAtNo9M2AFasivnrFrTvFRIBsqqVYuSbDNXNi+nuSU1IWE?=
 =?us-ascii?Q?Kzxo2d4sKaQDcDYr+QlwVkPqlgVp8cBd7h8VG8eNkXfP/QrFQosdD38Sx5f1?=
 =?us-ascii?Q?Q0mSF9ZD232LnarYNJb4xyShRS3QArLbQH8LUUx61hviwoQDO483gyp55YZd?=
 =?us-ascii?Q?RlOLsQ94aSgDcA82y7G81z3rstbly/dycz+NrwSSkyZShLrdNFHX3dmmw/ms?=
 =?us-ascii?Q?4UAVdgWudwQbM4FF82aNQj7PHDIDIJYWsthNGSt3yQSkbQ6oKCeUkWaEGPSd?=
 =?us-ascii?Q?7KVRKerqkyJo/BmO+zEMR0cvwpZNptTNbCKbtEP7OYDqQHEllQFYKhEKbXfu?=
 =?us-ascii?Q?N1AcFEKPi4A8YFJ/L+l0eI9jzV/9V8n5MTPl0SIO4l/aDYnXdnztBRLtkjR5?=
 =?us-ascii?Q?uj38DCD+W1rLiErCQ3wd9KyE/NLFUQb4fzYMtxK4N/+yuO2ze/djpnOSBkyZ?=
 =?us-ascii?Q?5/r7FS8yYocjqy+kXqkxSH8cwuhFFNeU2tSu4XhgMNn3d+1yTQLb0AeByWF1?=
 =?us-ascii?Q?um09RiKciygjIHTXnw7HKMUs6eLbKCMccgMiBG6M2mPlSLQ6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d41c0bdd-2c92-4dd2-aaff-08de71be9332
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2026 03:00:46.1755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QfBryUBpgAKePzp8gwMK67FVm6QKQZJeq14jteNFf4QWrM53Nh6DouxSzUzYfYrc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4277
X-Rspamd-Server: rspam09
X-Stat-Signature: 13dpyhytdetstmuhsu5tbmdudocscbnj
X-Rspamd-Queue-Id: 3144716000D
X-Rspam-User: 
X-HE-Tag: 1771729249-3459
X-HE-Meta: U2FsdGVkX18qLAqOvG1wpk38uL8mauNfdv3x7EWpvpP4Xt3VpABdLF/rW1RaQNHlvsWiZ0KmqakNZMsGkZ53TfY0rU+u0pAuV2NuqPun8NgN5lnfJzsUQ46ApGfyZHaiSIS9f5PNCW3dwBfQ1yyNFAAQN8fo6NC1oibDxv7vBOhrAw5W+jUHvwZ9nO9pciiHcgQtr7KGlpA2c832VaN6v2bQB/x13arRhFM0mtKAn46puBY3rQQEZjoXnhwXnJWziWX262MyKaGDsiyJtdW0Q5/TQj+eZDjYe6JBMmSBSAdoabbVaLPjFz06Km8KISDV8x08Lj8fHRmdx0gWd5zFhnca7+vCzbRvDq5SXkjiBD4N86lMPTfFVWOLt4wbQNARcOWNi1EnS+Zxb9L51iyJpJfejPViE29OYahM2OmFKK3DiK7EhztYyGk79B9jyYktefLjVjb7wrvhRirPzyYK1KgPNZxVq34denGpG5dPHjCiStuQgNqnDA1i/n09jpCsK6phxtO6uphW6boe6ECr0M4XNnJslcXUHkNZg07e2LbJsNX0lGu1yjSMYyhecDP5R+MrgE8wXpgxhayeGhEFmQ5BfSsgV0PYRl5Bup4qOSQFmckvikhev98jWukWjF+4Bhj5+vktyshI2wu9ep+3sRJkr1FKrWm4+w3nM98AlwM+yeQSkhygn6Yaiy7NEnh+gkooffT9BBe2UFVihpTyi/pO5r/6YyUBPND+Yk2cBg/iqewJLfL1hqb8iglhx17wejAVMlejUVz8cGGyc/UbiLy9ExpQh3d5rUG22YKQk9mj35l3wf3DcB2gZG1IuvSrtVG8Iz5IWHkU2M8YtBQ28Iqpt17bs3uxckFxPPxXNRzD4TbK5K0QWvZjDfKNADkWteRQV1TMTQcHDeaiJgQSK9MCIqJclVil6752lRbYKBpjEyXi1yfN13IIOKksti1XpuMiqFLkW7cFz0pj4iM
 NqOab4I5
 uZLKrsik2jElBK/cTKzNIrwfkSBWgtuZgJzvm4xNe2IqJz5CK4EI7PnvJvvHsaQmRI0FvKJGFo2tlxXzMb6PQ7UcMyI7L9yTLrzTd8YMBwQ/7UQ//u4ePBzla6ONwAT02hIColXWWHkxlM+JZQVlF/HjTyVTEU+0h2+RxgSwuckwiyVVphGv37zbWq+ury3xrtfGY8HV4ns7ruYF7YZ17sL1x+jqKsBObpgHY8mLHeIUhE5g89Qzfl57rj8eSte4RKh/xsPnfRnxCZIGrxyVmtrXCGpcUe9b/IYSQT8r/MpXurIdMevAzi/fouoxbW4fU6tj08myuiaQM3qcvUK0f04pt/fP30Gg4GsWXKDTvfG0AO7pSHSjwIxZNL3NUuZD/se+3f4vdgXwkVLs3bLG1T59tP5Fe+nLVK1ASig/uB1j0Q3o2B5l38Ah0aw5jPMCeevSlHcS6GimgzOM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+linux-mm list, since the topic is interesting and worth having a record =
in the list.

On 21 Feb 2026, at 20:07, Wei Yang wrote:

> On Sun, Feb 22, 2026 at 01:04:25AM +0000, Wei Yang wrote:
>> Hi, David & Zi Yan
>>
>> With some tests, I may find one refcount issue during __folio_split(),=
 when
>>
>>  * folio is isolated and @list is provided
>>  * @lock_at is not the large folio's head page
>>
>> The tricky thing is after __folio_freeze_and_split_unmapped() and
>> remap_page(), we would release one refcount for each after-split folio=
 except
>> @lock_at after-split folio.
>>
>> But when @list is provided, we would grab extra refcount in
>> __folio_freeze_and_split_unmapped() for each tail after-split folio by=

>> lru_add_split_folio(), except head after-split folio.
>>
>> If @lock_at is the large folio's head page, it is fine. If not, the
>> after-split folio's refcount is not well maintained.
>>
>> Take anonymous large folio mapped in one process for example, the refc=
ount
>> change during uniformly __folio_split() to order-0 would look like thi=
s:
>>
>> after lru_add_split_folio()  after remap     after unlock if @lockat =3D=
=3D head
>>   f0: 1                      1 + 1 =3D 2       2
>>   f1: 1 + 1 =3D 2              2 + 1 =3D 3       3 - 1 =3D 2
>>   f2: 1 + 1 =3D 2              2 + 1 =3D 3       3 - 1 =3D 2
>>   f3: 1 + 1 =3D 2              2 + 1 =3D 3       3 - 1 =3D 2
>>
>>                                              after unlock if @lockat =3D=
=3D head + 1
>>                                              2 - 1 =3D 1
>>                                              3
>>                                              3 - 1 =3D 2
>>                                              3 - 1 =3D 2
>>
>> This shows the refcount of f0/f1 is not correct, if @lockat !=3D head =
page.

after lru_add_split_folio(), refcount for head should be 0, since it is f=
rozen,
each of the rest subpages should be refcount =3D=3D 1. Then, head is unfr=
eezed
and its refcount goes to 1. remap adds 1 to all subpages refcount.
after the unlock loop, every subpage get -1 refcount except lock_at.


>>
>> The good news is there is no use case in kernel now. Then I am not sur=
e this
>> worth a fix. Would like to ask for your opinion first. Hope I don't mi=
ss
>> something important.
>>
>> Since there is no real case in kernel, I adjust the current debugfs
>> interface(/sys/kernel/debug/split_huge_pages) to trigger it. Below is =
the diff
>> for the change. This change could pass the selftests/split_huge_page_t=
est to
>> make sure the code change itself is correct.
>>
>> Then change the lockat to folio_page(folio, 1) could trigger the issue=
, when
>> trying to split a THP through the debugfs from userspace.
>>
>
> Sorry, the diff is lost:
>
> From c6d4c3d81e16f5f4b509cff884540bec0f91e6c3 Mon Sep 17 00:00:00 2001
> From: Wei Yang <richard.weiyang@gmail.com>
> Date: Thu, 19 Feb 2026 08:44:49 +0800
> Subject: [PATCH] [T]mm/huge_memory: test split with isolation
>
> ---
>  mm/huge_memory.c | 31 +++++++++++++++++++++----------
>  1 file changed, 21 insertions(+), 10 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ed0375ea22d1..65354c5edfef 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4621,9 +4621,11 @@ static int split_huge_pages_pid(int pid, unsigne=
d long vaddr_start,
>  	for (addr =3D vaddr_start; addr < vaddr_end; addr +=3D PAGE_SIZE) {
>  		struct vm_area_struct *vma =3D vma_lookup(mm, addr);
>  		struct folio_walk fw;
> -		struct folio *folio;
> +		struct folio *folio, *folio2;
> +		struct page *lockat;
>  		struct address_space *mapping;
>  		unsigned int target_order =3D new_order;
> +		LIST_HEAD(split_folios);
>
>  		if (!vma)
>  			break;
> @@ -4660,32 +4662,41 @@ static int split_huge_pages_pid(int pid, unsign=
ed long vaddr_start,
>  		    folio_expected_ref_count(folio) !=3D folio_ref_count(folio))
>  			goto next;
>
> -		if (!folio_trylock(folio))
> +		if (!folio_isolate_lru(folio))
>  			goto next;
> -		folio_get(folio);
> -		folio_walk_end(&fw, vma);
>
>  		if (!folio_test_anon(folio) && folio->mapping !=3D mapping)
> -			goto unlock;
> +			goto putback;
> +
> +		folio_lock(folio);
> +		folio_walk_end(&fw, vma);
> +		lockat =3D folio_page(folio, 0);
>
>  		if (in_folio_offset < 0 ||
>  		    in_folio_offset >=3D folio_nr_pages(folio)) {
> -			if (!split_folio_to_order(folio, target_order))
> +			lockat =3D folio_page(folio, 0);
> +			if (!split_huge_page_to_list_to_order(lockat, &split_folios, target=
_order))
>  				split++;
>  		} else {
>  			struct page *split_at =3D folio_page(folio,
>  							   in_folio_offset);
> -			if (!folio_split(folio, target_order, split_at, NULL))
> +			if (!folio_split(folio, target_order, split_at, &split_folios))
>  				split++;
>  		}
>
> -unlock:
> +		list_add_tail(&folio->lru, &split_folios);
> +		folio_unlock(page_folio(lockat));
>
> -		folio_unlock(folio);
> -		folio_put(folio);
> +		list_for_each_entry_safe(folio, folio2, &split_folios, lru) {
> +			list_del(&folio->lru);
> +			folio_putback_lru(folio);
> +		}
>
>  		cond_resched();
>  		continue;
> +
> +putback:
> +		folio_putback_lru(folio);

        ^^^^^^^^^^ cannot always put folio here.

>  next:
>  		folio_walk_end(&fw, vma);
>  		cond_resched();
> -- =


Your code change is wrong. Because when you are using split_huge_page_to_=
list_to_order(),
the code pattern should be:

get_page(lock_at);
lock_page(lock_at);
split_huge_page_to_list_to_order(lock_at);
unlock_page(lock_at);
put_page(lock_at);

So the extra refcount in lock_at will be decreased by put_page(lock_at);

But your code change does not do put_page(lock_at) but always does folio_=
putback_lru(folio),
where folio is the original head.

BTW, in the folio world, I do not think it is possible to perform the afo=
rementioned
split_huge_page_to_list_to_order() pattern any more, since you always wor=
k on folio,
the head. Unless there is a need of getting hold of a tail after-split fo=
lio after
a folio split, the pattern would be:

tail_page =3D folio_page(folio, N);

folio_get(folio);
folio_lock(folio);
folio_split(folio, ..., /* new parameter: lock_at =3D */ tail_page, ...);=

tail_folio =3D page_folio(tail_page);
folio_unlock(tail_folio);
folio_put(tail_folio);



--
Best Regards,
Yan, Zi

