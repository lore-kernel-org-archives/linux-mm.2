Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA875606A9B1
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aW/jSL7y
Received: by kanga.kvack.org (Postfix)
	id 0A8A56B05CD; Wed, 11 Nov 2026 01:49:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 069266B05CE; Wed, 11 Nov 2026 01:49:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9AA26B05CF; Wed, 11 Nov 2026 01:49:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0E186B05CD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:49:10 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60F23A7699
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:49:10 +0000 (UTC)
X-FDA: 85421911260.09.2345081
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011026.outbound.protection.outlook.com [40.93.194.26])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6B6F8100005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:49:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="aW/jSL7y";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of arighi@nvidia.com designates 40.93.194.26 as permitted sender) smtp.mailfrom=arighi@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794379747;
	b=R6kuPywTiP9qRqn35p1uoPWw+FLxT8GAc8fhcjJ8FCoD8Otzxqmrj+bV9RKZ/5dHtoeIj8
	IpJmQ+ce1G3izTl3rEloodNWfHYSV0etEjcO5E/SBDbj9fGLFQtOE4gocs2LV96+gkPV4P
	Kn1qRfMjWApguZR9fLokXmVhBPt+p4I=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="aW/jSL7y";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of arighi@nvidia.com designates 40.93.194.26 as permitted sender) smtp.mailfrom=arighi@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794379747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/SYR5A16T/orH18uPISH2JnzAp+jr/h7YBAW8+d9ayQ=;
	b=URRrUGWaOK3+a7ykRRvqr9M90hC6NZ1zKbyIXVTUoERl3ZnDh6/oBVjvh0Z/IHIGjEj886
	fj5k5sLlqyJZ5OS06hqSS4NEfFaF70rg6UQuncmWEYLwtM1IafR1/s5Lf5Ti4brkDcBaEE
	E0izJFplklB6rbDVNC8QxZKoVFYnSrk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rgU91tHdOMXBaFs5d60yLylZcKqHlw+5PvamzC5F4PCDJKYQtCEg1qDqxf0EnKMb2ugQc13dn5+HeA8vP/coxkEB9CXQUjqwwqnp2CXwopzhGAgAP9jInPjYzL0qfm9wniJL2YH6q/z4zA2TlCynMf6Uepz9hHqXw1h9LWtswbHi72pAkX5+9pwwuUFDEGA/IOjTrz1tLFwy03Pw4ku1FwrNyUVOFa+bya7mVbSbSAwUOCotLMcDah7vQ+Xg4e37yGCsoHhmuAZpby+1udAzn3xXbutqS8V/UScpginjXcIy1/1od88VxqbihMUDc0KgPuX7TylVnoQr8BbxJ8hAtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/SYR5A16T/orH18uPISH2JnzAp+jr/h7YBAW8+d9ayQ=;
 b=KdlKoc5qAroXtDaydj0dUa969r+jtf3ynS4HBzyZNUq8FHcNDOk8SSr+6b4gcgNseZU4Ym8Sj/F3KgHsJ7busaD2A8XVT2rV1I9/Ki4zj1SlIr4RSB1uh8GLrPdM8rgyQfm6boEzt0XxzYJo41l3aBGg4FKb60Ra4plRIBpvEaz9ezqQFae9SgBlOXFUTPkJCr0Hed1DYEQ8N6bniCXoHHT3R6h12VSdpiIcqopbrr0moImUVjc67AZykujug81a27YvPRW4FxQUntOAjlZKpGokHobv2NZALJuO05Yiogfvg/qgF40C+HTkry9oO8qmCC+Veu4eIicq3ukJ6bJkPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/SYR5A16T/orH18uPISH2JnzAp+jr/h7YBAW8+d9ayQ=;
 b=aW/jSL7yRGgnIcksyvjScLEMxv4BwjnKloBbgUufuVhoweb7E9BLrqbff7uGuQXaQMHkajcPzsEnl8Nwzny/o9c2v6+0cciUVddRiHu096JjpdVIL4a/qsYmndD7tIYEHeurf6H9YFmCyYvv2o4BMp9nZiDVDTGvV+pVdsChMhX8GjYO1iyYpl9amJ7fPwX2bH/AWHnpzUtbCn2xr2MHKlMIB+imDhy8OLIk8o15HR1Jr3LZZoaYeeRG1Rf2s7NiBp4rgbgks9Cx+LPeg1AuP2Pd5qWEcKzbGjn10yvJrOn28yrdGJ3fYZW5Ak+ACXRhl0nyUduhLOsZ3WZyuH9LXw==
Received: from BL1PR12MB5174.namprd12.prod.outlook.com (2603:10b6:208:31c::19)
 by PH0PR12MB8798.namprd12.prod.outlook.com (2603:10b6:510:28d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Wed, 11 Nov
 2026 06:49:02 +0000
Received: from BL1PR12MB5174.namprd12.prod.outlook.com
 ([fe80::58de:822b:868:96e9]) by BL1PR12MB5174.namprd12.prod.outlook.com
 ([fe80::58de:822b:868:96e9%6]) with mapi id 15.21.0615.007; Wed, 11 Nov 2026
 06:49:02 +0000
Date: Wed, 11 Nov 2026 07:48:53 +0100
From: Andrea Righi <arighi@nvidia.com>
To: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Quan Liu <qualiu@nvidia.com>, Lee Trager <ltrager@nvidia.com>,
	Seth Forshee <sforshee@nvidia.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Gregory Price <gourry@gourry.net>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] pipe: Prefer mempolicy node for metadata allocations
Message-ID: <avQP1aXhe7nQuzt9@gpd4>
References: <20261110065219.894219-1-arighi@nvidia.com>
 <hbkxlhc5y2jkvuov5o2kjgpisx2pavuo3ad4c4ydixeic7vaq6@mpzzfmhjvtof>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hbkxlhc5y2jkvuov5o2kjgpisx2pavuo3ad4c4ydixeic7vaq6@mpzzfmhjvtof>
X-ClientProxiedBy: MI1P293CA0017.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:3::13) To BL1PR12MB5174.namprd12.prod.outlook.com
 (2603:10b6:208:31c::19)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5174:EE_|PH0PR12MB8798:EE_
X-MS-Office365-Filtering-Correlation-Id: 2faa86c0-a524-4ca9-e252-08df3fbfdefa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|18002099003|22082099003|5023799004|4143699003|261022075727099003|261026121527099003|56012099006|261009223027099003|261102123227099003|261028144727099003|261021121427099003|261022105027099003|261021123027099003|261026140227099003|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	WhGNtk3qWevdiHpTZBLHanow02VDQznJk9Wib+eI7a9F/AtnsaVpugnjEtghwUww4Nz1thoxLuFedlN6bJj2mGP4WySzafmJbD0tMrOxxx1XEInamqpW99fvD3GqNsU+2qtNz5AhBNMw4jZkmA+mpQ0JZ5elh8dz0WbqPV29hgQYzomK6Mfihx8iWghL9q+579GMUkLLPocqF3HCPvhZRVli1i2pqNjt/UmlGUh7zIB52yP3mU18O/3ONh4aoX5d1GoWeLehiIGnhiMGSfIZKq7JqHZxJlbR/NaSU+PQq+CXl+SwLtVZqe5IgDAnmTsP3sHVMy40ZV0wRv8fDJncA6otvCLYneK9QRD9gtzSJOl3g4h2bjWiLleiGBSVU/vCHOKJARdVK0dQWvu7iuZVBh7Oz6EedYDtj+358UhTdPWNjwzM8xiN7YjZkK7tbqgGKWTKRObX7Gz7HYCvMnjaOVCphN1NypGMq7qIBbZ3BmpCi4e4zoEWK9uJ7Pz+NmqXLGIlxRSRsXfd2BZtmZ2YaYow3dLwc5H7FB9BNRzZb7cnKTPcZKu5HVPhAFbn83i/Y/u+QddBjkX64dARZSEE2DtHvKL4PHYYb0lC/COoipRRMKTxwxzaeT0jHaGxAFgxUEQWyT7fO+aFtEPWhXZQUXw7WqFAVN4RMV8FxKP/Se8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5174.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(18002099003)(22082099003)(5023799004)(4143699003)(261022075727099003)(261026121527099003)(56012099006)(261009223027099003)(261102123227099003)(261028144727099003)(261021121427099003)(261022105027099003)(261021123027099003)(261026140227099003)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4ecVRzJpfTS+GXYc3V5DoUq8cALt8IkffN2aVDPbCltwxNo0x1d9IUvkE4wS?=
 =?us-ascii?Q?QNEmM92rCe3Goo0ZY4Spn/CryKdU5qc4YyG1ykfqg/44ZTU/+NLWrE7QESZj?=
 =?us-ascii?Q?sqP2bhN8U8vaItqJ6bhb0vO4nEXZ4FohJVxfy1cOcLXbWMYpxT80bHyIKypn?=
 =?us-ascii?Q?tmbHTWSneYzjOY3+i/iLqmh8fOBB72mgO3hben7j9W0VzUcQpX2yxePEkcRv?=
 =?us-ascii?Q?tUuuPx7npZooqneRO7JZTNkiBvfQPL075I1WpwDW1Wi4HLqMLnSuPxEStrtL?=
 =?us-ascii?Q?CQTHfWDstrS6Q1YdtSayUScaT4Ap977UV4Q0VugyUc7BFWSZIzCPxGs/LVdd?=
 =?us-ascii?Q?6m+0T75PEDoOg3TDZ3A1qxIqWylBeQmWZiWtphz4lz/riheqichgjdoD7jvL?=
 =?us-ascii?Q?fU1wKlkGwffM93EtNNag85cZWxKvesK1OzLEgB1v5ZOGOkCRyKAlq4rjw30o?=
 =?us-ascii?Q?CzArJluiJEiG7nU01q5IH02Ge/orWMzE0BnDfaKsTVYEgVumUYVZNZVZMVqU?=
 =?us-ascii?Q?8WAiUnDfMwBUjw9DCRlBj4z9Wz2rFFo29thS7MezhI4JRnxVyfjW9mtHMjpl?=
 =?us-ascii?Q?4sVp0DItDdDTy1v/fskto5yITkykSglpYb2wcSVuFAYGld3/FHSOnzYdXSGX?=
 =?us-ascii?Q?LfpN/5GFV+BN8xFFvTAowGfQToa+KTQgodsYCfoznX22PXrlMegN2idNpu0g?=
 =?us-ascii?Q?qrOm3nyghuYAOTCi3dyoTAe3z0JXg74lPSmUYZ+OvK1YoSU2yWCyFKWm4UKd?=
 =?us-ascii?Q?YRwoQ3qOcxrzl0hUk4eaHv6HIJlQ73CyngrkN4CtmyJzdYRihtRzSUZiawp4?=
 =?us-ascii?Q?vq0vhiC03cQBO9czt3E9AzO06rd0KOD6FhyQz8eOHKE2d7h4mDEOmKnK0lku?=
 =?us-ascii?Q?l3FsNgv+2PRMFB/aWT+cUqMKSeLIiekvRmQU6/2cRZdrzQuqWRX2EwI9T7bm?=
 =?us-ascii?Q?VIJCHUuWga35SKWk4Dz921JeXqCRjQpiKYX32uRuw1Ivi/nURLe/1m2Srt75?=
 =?us-ascii?Q?qEr6uWkGIEtj/yMO0SwhyNSO7Dvgsd5oEMv/RRVwvbncBlFaEgKqzzkI7xks?=
 =?us-ascii?Q?R6qD9uStbF7oUQza7RslHpNg39vcg/fkuq+J7PHXJJawMGaMaP2gL3T+X4n3?=
 =?us-ascii?Q?MXLqwsnTp1Wu0RSuLIOzUPAIc4jVA6m8nIa8XdI0M1HzKlOm3IBcKotLZPew?=
 =?us-ascii?Q?8qclRI44+TMahDWsWJzJZelJMPd6q5Chbw0Ce+AOD9wSIlldCoY3JSZgE0rG?=
 =?us-ascii?Q?MEetFIJFalaBP9/bPfYHaAg7mvk3k30Nr6MdzQUDIQlTzMu7QrOsiuI9HcU5?=
 =?us-ascii?Q?scdvHkwQOKb5C+9o5WTc2WbpEyn6iRGYk7aDe8cl7Yj8NQJf+WtpgoGiBIwQ?=
 =?us-ascii?Q?Ku78Qq2TC3RC004mirBwvRebKHY+H4V+xX5MxJP8W7eytp5HsbqmqhFNc17W?=
 =?us-ascii?Q?8ZhXOQ3w1zGbFi8B5Gk7H/iOHEbh4tGjGebE4wDq5lS8nklowYyuHLeHn2iV?=
 =?us-ascii?Q?I1jHe5+Aw4k+kp2EUY8iAxfwsZ1k7/rJtUvsY3b4IfNe/K6qaxZ0NRmPRXWK?=
 =?us-ascii?Q?KImOsiEh4jQv3Jqsqcr9uZJ+SIPH8iB6fKnb7yP3AwD48xIInvkXtxh0kjA6?=
 =?us-ascii?Q?g8fC3W+gl8rznAYKq95xa1iOndHIjoJQpugc8goaQK4PTLuZrUUIghznw8j9?=
 =?us-ascii?Q?psh0hNSfgycbqchSelPN592fzUR376MIc5gSmVYj2oxEjyte?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2faa86c0-a524-4ca9-e252-08df3fbfdefa
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5174.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 06:49:02.4691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j/ITPeMsJ9EDSfAa83jiWfE1pk/1bBkh5bKiS77bA1s/YeuJq50R7zDb5wIdPD+VokjnnYVTc+QxDVGYjmWNHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8798
X-Stat-Signature: dytefu77sd7c57a3jc6comr9h1eb6ar1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6B6F8100005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794379747-639301
X-HE-Meta: U2FsdGVkX19Ssf1ehk7X1Z7CMgghSJbtljkdJBaGIQJrEnhZXV4Nzc97YEr5rCtCnwrla7GmQYEemIxwrzkIY3vDFEfoJKNxuXyaRgpoFsa+jexZ8OXeWvOc8kvH8nHJidI4hmywRh/iLH/mI9tmDm8lEXdEeQFo9jmBolYyNJdejIqYzRu90SVPQyhIPNtbRfMlb4Xu7LOJtHbAYLshsxGDRIsyDjiG3O7KK3XyxXSczqaOjJ0+T+2q9UzFybrrP6DTYs1fgQe4qbi8RRsXaI8D6tAE6oGo1zn1Zu0e6j6yFqkSxvuaMuxJ3r8PLOJFzA3lCsJ9UTDsHYQNM0/Ev6isHnfbLbapUIkk/ZEhJcd9lEvx393obik4uw/J+yIZbVGD6pJvQqqWyztWh4cXH48VTeJtNTrVe++5fzn/6Uik3mlev5zUGnT6yaDB2fa4dvv+BcKJ39DY6C0vCQ5yTR9ibV8X+jQD0qaY2Esar6wpKWH2+4hjHD7Mpk8IzRGuGpO8VDdfv5RZrv48dlmSetsUIQEnXrrjGgGn16jFYTuwvudGM9WGMa2exASTIFBq4sGzqPvt3WCrVaZYYRXyZ/D34RAsZsJG2VOPepsua7Jv9pQBm19Bs+aMzZ2PW8mV/KoxRTANFFUzXuQUrOmQc7HvYl5vBTWzv0z0pbmA0S9sNlq7ALEdh3XBXJy3xIv/K1DikbLgLRpaWRbKKLOhBOeiQYzhuZ8a2HJlZ+PFda4Ovb4hPIYhj6MRQzbHWmoOna/h30rzfk3AqxSrsEHcIDk4fSWtR5ObWncEV7r0ohej9VpPrgd3Q9l7iEoW5czEUvd3cJ9TWfEYdz4gZ8+GuRQZU/h0leFN9kaR4kpt+/g/5IBBW+2hFMfXcUhs40VxrHddfKU+ZTC+JRLvk2ynm6MkOf9biHMJb2W3Kp8Q+b+E3vJ0uHe39blnPnT9SVIz86qzh6m3+xWyvGsQKMU
 chMzALsr
 t2j9Bx9FdCiK5ke1as+5UOqaldIp5pThUoBZXkYRk/R0JmaHFI4wJJBOwkK6dQjunzKaAQX3nDrk4StzTBGLfVNgS6HsydvE0M3AogXMw7+Hp4usbhNaGIyX79j4G11aAwIsMfUl7PzjqLUBFy8EJl+Vzkjs4nIlSIqbGoITWx8RBwhZI9z1DLGz1E+2/RtdNXY2WiM4CBYDrt2mVViyQBJw8+QVWNDCh6EQxLeuNaDqC7S38dlr7edfOIEaZPbK4MgcP/YSnEvnoXjoP7C/aaOW8YiyHz5jEuMf9HqR70mf7kO9+TG/aYhgFsOCGgkGP8PnpDy4EE84BOzGZYhSHKxNbLhMU66W4yhBL+ayOmYx/4P5o0yDUPYtte/EX4VWOyul1rR2/X9eYzWkOPtoLgwN01Cj8jn6aU/dbzQ07EyuVKluJvXuSGICvlTGscajt1uad2jipcjgj1kOJXBJQ+zqfMrEcpxd3Tf/d4C/5czaRLd8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Jan,

On Tue, Nov 10, 2026 at 01:27:53PM +0100, Jan Kara wrote:
> On Tue 10-11-26 07:52:19, Andrea Righi wrote:
> > Generic slab allocations can reuse partial slabs from another NUMA node,
> > even when a pipe workload is bound to one node. Pipe metadata is shared
> > between senders and receivers and accessed throughout the pipe lifetime.
> > Reusing remote metadata can therefore make an IPC workload pay remote
> > access and coherence costs on every exchange.
> > 
> > The target use case is a workload that binds its workers and memory to
> > one NUMA node with numactl. The policy node is then a useful placement
> > hint for shared pipe metadata.
> > 
> > Allocate pipe_inode_info and its descriptor array on the node selected
> > by the caller's memory policy. Apply the same preference when replacing
> > slab-sized descriptor arrays during ring resizing. An explicit node lets
> > SLUB try local allocations before reusing remote partial slabs.
> > 
> > For descriptor arrays larger than KMALLOC_MAX_CACHE_SIZE, pass
> > NUMA_NO_NODE to keep the policy-aware page allocation path. An explicit
> > node would otherwise lose the MPOL_BIND nodemask on fallback. Select the
> > policy node only for slab-sized arrays, avoiding an extra advance of an
> > interleave policy for large allocations.
> > 
> > Moving a pipe's users to another node doesn't migrate its existing
> > metadata, so migration can still result in remote accesses regardless of
> > this change. Generic allocations may reuse remote partial slabs, making
> > initial placement dependent on allocator state. In contrast, preferring
> > the policy node leverages the workload's placement hint to improve
> > locality when users remain on the intended node.
> > 
> > Testing has been performed on a dual-socket NVIDIA Vera system, covering
> > hackbench, pipe transfers, pipe creation and resizing, pipe_bench, and
> > targeted stress tests.
> > 
> > The primary hackbench reproducer is:
> > 
> >   $ numactl --physcpubind=0-87 --membind=0 \
> >       hackbench -P -p -g 10 -f 20 -s 100 -l 100000
> > 
> > Results (over 10 measured runs per case):
> > 
> >               avg       stdev
> >    before     9.811s    0.130s
> >    after      5.770s    0.058s
> > 
> > Before this change, allocations could reuse remote pipe metadata. With
> > this change, both pipe objects and descriptor arrays are allocated on
> > the requested node, improving locality and reducing hackbench runtime by
> > approximately 41%.
> > 
> > Reported-by: Quan Liu <qualiu@nvidia.com>
> > Signed-off-by: Andrea Righi <arighi@nvidia.com>
> 
> To me this makes sense so feel free to add:
> 
> Acked-by: Jan Kara <jack@suse.cz>
> 
> But IMHO it deserves a look from MM guys since this is more of an MM thing
> than a filesystem one... Added to CC.

Thanks for taking a look, and good point about getting MM feedback.

Vlastimil, Gregory, do you think this SLUB locality and mempolicy
aspects makes sense here? In particular, does preferring the policy node
for slab-sized pipe metadata, while retaining the policy-aware path for
larger arrays, look reasonable?

Thanks,
-Andrea

> 
> 								Honza
> 
> > ---
> >  fs/pipe.c | 26 ++++++++++++++++++++++----
> >  1 file changed, 22 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/pipe.c b/fs/pipe.c
> > index 4fa69192e6fba..2a8f9e9f70f84 100644
> > --- a/fs/pipe.c
> > +++ b/fs/pipe.c
> > @@ -24,6 +24,7 @@
> >  #include <linux/syscalls.h>
> >  #include <linux/fcntl.h>
> >  #include <linux/memcontrol.h>
> > +#include <linux/mempolicy.h>
> >  #include <linux/watch_queue.h>
> >  #include <linux/sysctl.h>
> >  #include <linux/sort.h>
> > @@ -874,6 +875,16 @@ bool pipe_is_unprivileged_user(void)
> >  	return !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN);
> >  }
> >  
> > +/* Prefer the policy node over remote partial slabs, retaining fallback. */
> > +static int pipe_slab_node(void)
> > +{
> > +#ifdef CONFIG_NUMA
> > +	return mempolicy_slab_node();
> > +#else
> > +	return NUMA_NO_NODE;
> > +#endif
> > +}
> > +
> >  struct pipe_inode_info *alloc_pipe_info(void)
> >  {
> >  	struct pipe_inode_info *pipe;
> > @@ -881,8 +892,9 @@ struct pipe_inode_info *alloc_pipe_info(void)
> >  	struct user_struct *user = get_current_user();
> >  	unsigned long user_bufs;
> >  	unsigned int max_size = READ_ONCE(pipe_max_size);
> > +	int node = pipe_slab_node();
> >  
> > -	pipe = kzalloc_obj(struct pipe_inode_info, GFP_KERNEL_ACCOUNT);
> > +	pipe = kzalloc_node(sizeof(*pipe), GFP_KERNEL_ACCOUNT, node);
> >  	if (pipe == NULL)
> >  		goto out_free_uid;
> >  
> > @@ -899,8 +911,8 @@ struct pipe_inode_info *alloc_pipe_info(void)
> >  	if (too_many_pipe_buffers_hard(user_bufs) && pipe_is_unprivileged_user())
> >  		goto out_revert_acct;
> >  
> > -	pipe->bufs = kzalloc_objs(struct pipe_buffer, pipe_bufs,
> > -				  GFP_KERNEL_ACCOUNT);
> > +	pipe->bufs = kcalloc_node(pipe_bufs, sizeof(*pipe->bufs),
> > +				  GFP_KERNEL_ACCOUNT, node);
> >  
> >  	if (pipe->bufs) {
> >  		init_waitqueue_head(&pipe->rd_wait);
> > @@ -1375,12 +1387,18 @@ int pipe_resize_ring(struct pipe_inode_info *pipe, unsigned int nr_slots)
> >  {
> >  	struct pipe_buffer *bufs;
> >  	unsigned int head, tail, mask, n;
> > +	int node = NUMA_NO_NODE;
> >  
> >  	/* nr_slots larger than limits of pipe->{head,tail} */
> >  	if (unlikely(nr_slots > (pipe_index_t)-1u))
> >  		return -EINVAL;
> >  
> > -	bufs = kzalloc_objs(*bufs, nr_slots, GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
> > +	/* Keep the policy nodemask for allocations that bypass slab caches. */
> > +	if (nr_slots <= KMALLOC_MAX_CACHE_SIZE / sizeof(*bufs))
> > +		node = pipe_slab_node();
> > +
> > +	bufs = kcalloc_node(nr_slots, sizeof(*bufs),
> > +			    GFP_KERNEL_ACCOUNT | __GFP_NOWARN, node);
> >  	if (unlikely(!bufs))
> >  		return -ENOMEM;
> >  
> > -- 
> > 2.56.0
> > 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> 

