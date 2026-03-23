Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9856DF483DE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 17:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BDC06B009F; Mon, 23 Mar 2026 13:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0952A6B00A1; Mon, 23 Mar 2026 13:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEDB16B00A2; Mon, 23 Mar 2026 13:56:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DED966B009F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:56:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A85581406A3
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:56:09 +0000 (UTC)
X-FDA: 84578081658.19.EFC566C
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011065.outbound.protection.outlook.com [52.101.62.65])
	by imf20.hostedemail.com (Postfix) with ESMTP id C85CB1C000F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:56:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PIRnSZBD;
	spf=pass (imf20.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.62.65 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774288566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K8g7ZziYJ8aW92tCcT17LZ6pN8SwyBkt44Z4So6lue0=;
	b=nR+2Tep/IQrj1GCIn4b6EOvTEvbbbX+1kNr7OnU555g9goltno3vAAzjtdhmhl9gjYIlAx
	cEIs6uQ4DmoaiwbjXdOHtoD7LSeHuQrug1jVHNBw8R52AvboMdWsafv9wa5uoTQri9grik
	ar/xBzB2YtAcb2BQj3VwCbOy/25tMk8=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PIRnSZBD;
	spf=pass (imf20.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.62.65 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774288566; a=rsa-sha256;
	cv=pass;
	b=BIEYck6GMrGQVeVWSldCve5TcSJcSr+7HkONfiy3zRzm/aR6IMlbiChvk5xt1jaWBoWlPP
	NSKxWp7sxSFS0zJWAuyK8Lk3Y17TXA+58r5Vab9xm4uXX1cadh9S6Q30qSDaKfoTyC9x/S
	S4Pm3kqBFTDd3ivKfFVaiRVSU6V882w=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uHFrSgHW+2MAHo/TmQa9KTM+FazexkF8qqSsh6gC09uPZOmIuUKlleEchtp9QvtitHIUfI5/082xTNBj6c19KdVPRfo1y9kGjh+OxUrzrli8r87a1N5DLCVbWSCuPbntYmGN6OgvOHWkZvf84qm3dc+7VX8T5PWWK/3loHvf9/ntD/XSd1kzWZNsCqo1BAQpJBtx5eWqxktyC4hsHI9++QnrOvYb7XyZ78RYv/xX8oqLRDMbKEGwqs/cKbXSRqqgX7ZBoiQVOUQ7VQoUzDl/GaM+JYwUWhcXtNlX7qC3ZrPXLfu1O83fLyDlDI3LjQ7rqPFIdzHS9fnrDUl6dAwHBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K8g7ZziYJ8aW92tCcT17LZ6pN8SwyBkt44Z4So6lue0=;
 b=q0PLfyN0DFUzCx6FjYFPBsxOYSd0Mie9vmV+ZZQZw4m/XALPUKx7yl2ya/apnxShVpEyH3j7Ah7qSWm0QcMeNBFI4WiBE74mzw2KF7Gekr2MJbVhgTUJgDl4AbFsejL0O5IEc59KJ9OPQ5/IN4en/F3LlAJfn3zaAKKYJASXyT0zgvo3fKsH3OxnxUa5IdwAxGSqt3jrgbO3u0QAvDMf9yMco3ut0w7lCi0U+Zm6Koe7+rzSp3cg0jEq+qCDEIUZj22z4UR+FLVhWlaQGgQITRt/4mhUgU+r/8j74UBTHqH7G/rTkLiWR8MUs2hy3ZwO8yzQCbAyiZOI2Mij6LTN+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K8g7ZziYJ8aW92tCcT17LZ6pN8SwyBkt44Z4So6lue0=;
 b=PIRnSZBDANgNwpqPR5kwL0roTYLnrQ4UmZndrVXVAsxe9GgV2oETuTL9f/fjpEB9sTCk3ALlbMuXGvIx/ZPqLGb+PcCT3RWkoTNHFB7t9jSOVhsRN5p8uzhqor6XsI853Pg6OBLIHo6W/MDqgv5sN0lwKnMSLVKZoNDenWOaG2sdCfIZ5aRaAESYW7ddYLg8rTO33HUcBMCt+xZVzZKPHXFxW/ewUrPkmN3SFhwrzFTRF5k5lPMpi7/L+gt5/7uYRwFdootQBbEYYwIoiiVHFN8K/AljfeGxxBIfpaLSsA1nk9g9Qz7CojyP5ABQ/EbiSFn94+g2QE8RagfwlmYHkA==
Received: from PH0PR12MB8800.namprd12.prod.outlook.com (2603:10b6:510:26f::12)
 by CYXPR12MB9441.namprd12.prod.outlook.com (2603:10b6:930:dc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 17:56:03 +0000
Received: from PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d]) by PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d%4]) with mapi id 15.20.9745.019; Mon, 23 Mar 2026
 17:56:03 +0000
Date: Mon, 23 Mar 2026 13:56:01 -0400
From: Yury Norov <ynorov@nvidia.com>
To: kernel test robot <lkp@intel.com>
Cc: linux-kernel@vger.kernel.org, oe-kbuild-all@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 3/3] bitmap: add test_zero_nbits()
Message-ID: <acF-sTWyjdZk6jbD@yury>
References: <20260319004349.849281-4-ynorov@nvidia.com>
 <202603220114.k5BHBav5-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202603220114.k5BHBav5-lkp@intel.com>
X-ClientProxiedBy: BN9PR03CA0079.namprd03.prod.outlook.com
 (2603:10b6:408:fc::24) To PH0PR12MB8800.namprd12.prod.outlook.com
 (2603:10b6:510:26f::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB8800:EE_|CYXPR12MB9441:EE_
X-MS-Office365-Filtering-Correlation-Id: 21837e87-8a1b-4ce6-599b-08de890572ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|18002099003|22082099003|56012099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	OJUaEGf166KM77vrwAnR4kPdPZi504zVaf5C2TXZQ5BrUf4/J+U4osomZ8STASaCLb+UNr2CJfTaWzgRVRCdSkUUl1SiTf4HqNK73IJ8Ybe77OM9qL/9grEM9AeI8plaevpakieoWu4YMmbQcTzaxgT65VaSRfCeIuhFrpXtUCLz1cZTQYdGgJNQDe0rWzx3jvxVtHxH+xC6xlA4Z80SDgYOY4/CH/9DT81nrzF2Nl0StqHxBgdZEAuqg5C1Gn1yHOtr+OTOXsk30HnkZUmPeXhYqONqO7fGdIn8nTukO0cGIgEjkuA8ZIo4bXG2OzGhfQ9Lpr7XkDKQi0QyA0jWlNN1+4B9QM1bPNe+9/Q9I1l74PQa85BYZw1kk/RRi4mfkA9ebOKj4qih3XcahVODALIRycoZDWNl32APp+jBfD+oBC9rWPwZz8bcKGNGoGi/+s5ZcENNplQ24+btw1gdrLumY/o4al3paULFKeJi7PqWjZzswN1HX4iYA4RtWSQEaD6gg8ycWeuolI4ET0gy0DNLK5i5BAWA0KwwGffDN2RnWcoPwytBEpxfMm07fPTVZsIMb1iAabaxC1XdKwa8t2qpN0mx57Ewqif6m56rWjpW9huOLEBuZKUL/bI9cEF/xQNbNYVWoKLUBzdmfOVv2YrQg4zKZULnjQ1QML91aAimLNtmGPQGiBFsdYnMyzhHKQ7+FVevC/pcAwCJXAsW4G3adHy6Lwp0K5DLgAD3HX/j9fbEzqlAmuDTErABGKBb
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB8800.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(18002099003)(22082099003)(56012099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JDgYyJZk3iScCVbWKk9/kR+PwnthhMFdL2hJGI/OGOuCYLPkemfoFjodHee2?=
 =?us-ascii?Q?WL7e33WET9arZBMTgEtdgtMzcdLWuX0B5AQfPZh5b8pk7Izn1+F+3Y3xR5TF?=
 =?us-ascii?Q?E0CkNE8Y6c686A4vOO1BqYWjScn9trt0S1EwjpZK0Rd16tEhifSOmh80Pt1l?=
 =?us-ascii?Q?aKTKtAfpeGUmOf+W3UOxIw2zjuqU5f0N6GTWsdnk4fhISnlvhPMMfMShNGqB?=
 =?us-ascii?Q?95a0EoRC+wMqCnxps7eslKKkur9O36lTLtSInXdCEuFnOxycAGtuLmyVzsKc?=
 =?us-ascii?Q?/PX+0aiyxW9GH92K7jv7rVzy77I2ZeqntHBOoawNrhlB8I5x7AhZxXdJhCFg?=
 =?us-ascii?Q?lDv7Q8ihYZT/3zZpi+/RRVNEMDK+VJ5iOoJTF8uSS+lHQxGf/xuwFhZapznd?=
 =?us-ascii?Q?AktfbpCTNagu4IN+1HyNBKV6ZFzkIAnS8a2N5NnbQzIDbaTxjmGkpnjrdgXX?=
 =?us-ascii?Q?6ETyNZlp83cy+sNsx0bTlMdKuxp/Eh52BhOBevVHNRJxX8VeXi5OyjLokZ29?=
 =?us-ascii?Q?ShRwNmVjECtSrRq7iGnyf3u8IOzryTsiFj7w+yziUHTmkVDF8aajI2Et4/eq?=
 =?us-ascii?Q?9pLXEE1LfRfK37szQGBQh1qcVhuQaPGnv0EJmsfyLL0oFVBIGmuG/QVnr7rM?=
 =?us-ascii?Q?xT84haVXHjkrRN7D0CheQPGHItRA5SRrXlnXJM7xaO97aISXVPEkGHHpWAuV?=
 =?us-ascii?Q?qXbIblrKq8m2ccmbfFbRS1+g0VZK0qh9kS3njbL+oUDwcQhxdj5ikdVPSXk6?=
 =?us-ascii?Q?HB5hitkV4j7Is+t878Buaha9Rj8UFs9gECDnr8XsLaEeumQLrzH6EjwBfeRF?=
 =?us-ascii?Q?jw12zD4HSXC0vOiE8XDzyQw4KCTlpYXOqaWwJc0W8kV9igYC/0DR79q3niHk?=
 =?us-ascii?Q?p3DDCH4Fs1v55cyafENOCtY0OZmhuthEAKjQ4t9kkPJ8IGm3Daox6rZIQd2N?=
 =?us-ascii?Q?vJ7Livkw7PgMfWTdXpIxbcYO9g2UsFSxcvEkBhAPZkqj4ElY/wG7/tacPprt?=
 =?us-ascii?Q?Q+EbwEofpP/vylUzbZe4SX5/saRLXkJik0oJkNBGrytJ43JbFMZdMsTLk6Cw?=
 =?us-ascii?Q?jHIhiWYP3/PfKqTjUAA7QhucgoPZxN+jeFkw22Eqk1NcoJs8wY3eYMgN3Yd2?=
 =?us-ascii?Q?E2oxvbvSN8IucgKVSLnTClcEQU2T2vYMSTN6zqIkldvy3VS7ntUfQFpkAOi9?=
 =?us-ascii?Q?4f4JEGXk7liJ7H7jUVsJPpPiMayiBkuuQj0cNPa1VXHvGEivsvvLvS8sOLsg?=
 =?us-ascii?Q?epqJSocvGpO7sy3TTwBhfWcZ0VjUTUD8lvbHUmSYAQQhVwKi1FeJ0pSqAbSm?=
 =?us-ascii?Q?ZDuGNtrgXpVQtNZ3SlBoCw960+4M76qdUJuOdDdc7G8MVMPO/MeQe4zWulJk?=
 =?us-ascii?Q?t+GtwKu99EQY/zwJalD5WarJPE+nKpoDqjITOtK3TAikO3t9aUZs7SR20LiB?=
 =?us-ascii?Q?PlK3EmSJqssf30ZD66GMX7VZiRtQOtttMmRu20vUKWMyygd7cDvChQJgYpNP?=
 =?us-ascii?Q?17hAGuAPYEYwyAu3VFc2nsr7PnMq8HPoCm1ZDsR5S2z8WsAe+BnrZ4Xp3e8+?=
 =?us-ascii?Q?qjosVE4Oix8OEomD9zgcXwieS1+eLsddOisDCXk3cesPwmvH639ZoPYb/BF9?=
 =?us-ascii?Q?RrOJ5o6O/G9KjP11tdfREdIRd2+yK6hslUvjKVrjuotKo4/hzg+9mxWs33R1?=
 =?us-ascii?Q?cGjtJwoZYc30lnbYEtm4Dqm1bDbyRKpdMR/7gR7/fE8tD08y9faIu+6beJZB?=
 =?us-ascii?Q?Hi3U6bRY2EHRBDA48Aazo/b8q2qOGQ4g65mETJjOeUfjFg6t6x96?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21837e87-8a1b-4ce6-599b-08de890572ee
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB8800.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 17:56:03.0874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ggdGPqo1FtsnkZsdl6TU6WIs5UdbUVLOvneVs1TeBIyqT1Id9Cnjct28wDXlPmuQOLc8wgWwX11IjA0mcQcGbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9441
X-Rspamd-Queue-Id: C85CB1C000F
X-Stat-Signature: u43uk31wki5b87nxqda3de5s468n4bm9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774288566-239087
X-HE-Meta: U2FsdGVkX1+Qa8t8icqpWI1THzK1MbOhcgRVzqyZay/z6z2dYkm/DafppHgdfU7ui7wSLdRTNRPlEQ/EG2DYmippa7ohClH6Ya9bS5MsTOS451ZQOsN/+r3nTUiwo4OsJ6xJPVnfj2UsdqssnE9vTjv27BhocTsPcuJCZa75VUUa0weXd2fiRUkasZMNxoulJhJSTAiou+vd88Kf4H7evZJ+dJfp6NyHuCyXQWxf33/zkGb7zS7zOuKw96FaIx6BYZWQ6m9xvoe+ZFXbJLzQCs+Y8HURi49IutkPXgM1OaAv1yX6XQU3dPXtbqe2js7Xmf3LqhAAXuCHA3hTE9MBu8jbF+m19qmHsjhLoQP8kF0jZWze4WHd7nzLwDt5UNtzfRLSeEHMqCi1xPDZW31p5GRuGKaIRT+KrbPbInkC84YaSQ6apMljdorvJqaMWoVQazt5f6QbiIA7rYzurxD2MMcBKdSIqAN4+xFiEvimm7QS8zBvqyWDXwvKU1NYfJZe5yclXIwWIEM0EPU+rGNaz0NG/fI0HSwV/Ia86kLaPFoRG9WvHH8EdkBT3ySCbPDveOyKzeu/GHF+Jvjf0b2FW897k7l34qVmEXEEUn36ySqpUwiR43BrfdpEXO2VmWaK65pkGIFeZ284bhF1u21T0tV5bNHakAGD+hsbLZJPhd/wRMbIxNTeVhMezs9Mk3MS4iyjPncC0yoyWypAundckiGkSwkfVEmZWnzdh3icAjALyj4G2ZAf5mtneQUXoC3zhv9/EUHOAqIViLCAbSIZhhAtpqme2D3N86jmDh+kBtUtKQSnX44hM7DYJUaSbNhgiVcxY5Ht/F0+jUJiwd6HjEOqVJCwWE6OD41XRtEi0syynz2NiZ4CErS7ORvPw46LwIaxsOCOSzJM1JQP5pg9/z+dmSyi6qeJbKjsPaEi/XVhM8Uj3jaE7HJjztXQrt3MP61O7C9IzW+itQcCYhz
 uw3UMWPZ
 8lRWiidUnJ/yFUQPR9yp71Ww4Ym6VNQaz5ZcqJAPPU32Stze1HSqh4AnoxEY31RCgupWIW80P2EPsd2RKWOL4tNyTkcyINHlIrg2jfZAO2PIV9ztBM80Qykv6vjD+Ho8B1ajwvWkY/1ntVL3qeVFSBMZFNdcxUJIgwtcZU0zpUrMXnFQD0ZxJZBzQQvasKT8c1hBHHQeIY3cCFhPlQvOIX3tEuvvxu2BCQSzcpGuHalNuboe2FfME6CbfaUdeIQlHfTehAGPWJlPKnNpPxgp3UPD47z/sNII2RQO2k5q8YWkBEFtiqvwxFick0nXcfomhTJs6e8Dw2ayZ/GDmmUvbc4uApz1qy9Cq7LDm7/5vppE4Kjiqqp8jkDfeBnZYDcgmryU3+jpgD8oeWaW/KpL/PWnQt9cdNToWsWi7Hxw6GgpuM+3+uGaIr/y5NzVFbWnw3pj1qoCCE11zrFMGGL9evPwj1Uu6IFbj9GoWEzmYUMMEq9zoahW7sxdmF7DbDFUJSPuOeTUVspHEJlM8bgrfFXwaUa4dC3T+ln8Y75iZYeduEauEwxp+SElvcILZgYhVBc/iVu8yn/Sb2Fz/4LPwUclW34BPBc7zgRw1M4eA7K6uY+PeuEpQbCLrug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 22, 2026 at 01:09:51AM +0800, kernel test robot wrote:
> Hi Yury,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on next-20260318]
> [cannot apply to akpm-mm/mm-nonmm-unstable v7.0-rc4 v7.0-rc3 v7.0-rc2 linus/master v7.0-rc4]

Just as said in cover-letter: apply it on top of -next, or
bitmap-for-next.

Applying this in bitmap-for-next for testing.

Thanks,
Yury

> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Yury-Norov/bitmap-test-bitmap_weight-for-more/20260319-221930
> base:   next-20260318
> patch link:    https://lore.kernel.org/r/20260319004349.849281-4-ynorov%40nvidia.com
> patch subject: [PATCH 3/3] bitmap: add test_zero_nbits()
> config: nios2-allmodconfig (https://download.01.org/0day-ci/archive/20260322/202603220114.k5BHBav5-lkp@intel.com/config)
> compiler: nios2-linux-gcc (GCC) 11.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260322/202603220114.k5BHBav5-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202603220114.k5BHBav5-lkp@intel.com/
> 
> All errors (new ones prefixed by >>, old ones prefixed by <<):
> 
> >> ERROR: modpost: "__bitmap_or_equal" [lib/test_bitmap.ko] undefined!
> ERROR: modpost: "__bitmap_weighted_or" [lib/test_bitmap.ko] undefined!
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

