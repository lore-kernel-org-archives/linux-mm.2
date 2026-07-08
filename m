Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8466C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 00:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B3F86B0095; Tue,  7 Jul 2026 20:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5652A6B0096; Tue,  7 Jul 2026 20:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42BA96B0098; Tue,  7 Jul 2026 20:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0427C6B0095
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:58:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 56E8B1205FD
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:58:01 +0000 (UTC)
X-FDA: 84963797562.27.35E6D10
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011037.outbound.protection.outlook.com [40.107.208.37])
	by imf25.hostedemail.com (Postfix) with ESMTP id 83285A0002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:57:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=l3n5s2yS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of jhubbard@nvidia.com designates 40.107.208.37 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783472278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=23m56iZn1MB9t0Y4oD8PA1MUIfkQs2vORVV3sD6ibmk=;
	b=O6AZqxmZZMD5Ud1PVjJxX/ZtTGngVeWyQeZkQBuRcILLCjkMGXrqu1EVIyUsYY/skZQaJG
	6jLhlDFdShTJM2xD9CQB9rHOKQq7PGnBr7b0tMjaeaVpcyro5XgLkGFzNtUY78ZLVFbPrX
	qI9v6LbIlg0cA91f5wETp8KdZ8TElLU=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=l3n5s2yS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of jhubbard@nvidia.com designates 40.107.208.37 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783472278;
	b=Ib4YPqHQNRtzVWTJ05M42Tm0pIUnD4CsVsDclYdQTDzIQ5/mpjFBP73QtEPd5gg7i23pet
	mRFhOEttAj8/8m5fDXuQKfvRQfYo4aSj7361w6un76uByWJkCSivodzMjYP8hpIA0XawJr
	qxn2MvW2lY7apDZrhTaomeSXehuJnWo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ep6uEoZ3JzxHzoQTNw8WYxAPg+hn0bRqNAFCyYggkIVJoHXUZkzhLT9/EG1xMde+8ODi6JpXwhqdJ702CkZY8/5sCSrv02+aQZ9xCNdFKSmcN0jAiFAOtCOuViGxz352zJTAmATPhKIotGp3yWAQ16F+3rAYpa5XmCvsDdJr/IdD0MnVk9UQAFEA7bPaEYk5LupSELCqJSa5muPx6yXkDXY/qAaqve0MeKoz6ZKXMY0IWKChSC3gO0+HzV4FlW/1el5eP+RlqjkcqlsjQp91wogeObbvh8Zehu9bLsmu5c8e5KsvudxlBX1wuq2aX9q3QjPeBwY0G5hDzu10JD7N8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=23m56iZn1MB9t0Y4oD8PA1MUIfkQs2vORVV3sD6ibmk=;
 b=shuutqmtRqFY2GrItLJy7bnOAYQKTn85ETUSN5jq63y9DVLiS32ZCdyLD66Lywu67gnJy+cNKkWY5gjOtaVBboAsvvqBtGWfHy8+ueuX4FIKW0VUl7+c2z5M/LExHmXHugOf34zNL2C1fI7k1+1ZlqYnywHffi5w+La4wseXCNrioul8ZTkUsxzDIw15FB7jFSTTUXRhneKaXzU8n5T4i9LP04SanwtPdUOoPqluUkgxDxj0NaDee82vV2rtNqY4A2uTPH2e8jl0wDAW8IJvvGqx+W23MhJPIPswAlyrQWhLTncWH+xmd+u0Oan8+zKwg7QFiPN9L4brcTFKvMZc/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=23m56iZn1MB9t0Y4oD8PA1MUIfkQs2vORVV3sD6ibmk=;
 b=l3n5s2ySkEKETjGy+FApFgBjb0KfhErEfVs+xnDKuXTDA33u5p09UZHgUdqvM/sqSiObEz+7NDAgXnOLxvBzaTBMcPViIjhTvy11cdUfJP5TbgvmpQYEmHqZJPhtXcgVpD9SzXcKNYBfGynQ2hVt7kdj5fz57GDspTJcYsGW5AdC6nf5CoN1LthHTQQsGi4DVu/OvfpLNgyRehZoYzvJP4w5TruclgnlTh12SyoMlRcU3EOsBInKYYZ2Ug/WuRZPb4qghAb5r5scKIcn26AT9U3xvTyLlgcNvJV/wxRK2AigcCd2uZkZ7xh5tYpjrj9CtFdJf3SDwecQDCvSGZizRw==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 SA3PR12MB9178.namprd12.prod.outlook.com (2603:10b6:806:396::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.10; Wed, 8 Jul 2026 00:57:48 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%5]) with mapi id 15.21.0181.009; Wed, 8 Jul 2026
 00:57:48 +0000
From: John Hubbard <jhubbard@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-mm@kvack.org,
	John Hubbard <jhubbard@nvidia.com>,
	Sourab Gupta <sougupta@nvidia.com>
Subject: [PATCH v2] mm/gup: fix GUP-fast fallback for NULL-mapping order-0 folios
Date: Tue,  7 Jul 2026 17:57:45 -0700
Message-ID: <20260708005745.164928-1-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.55.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0270.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::35) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|SA3PR12MB9178:EE_
X-MS-Office365-Filtering-Correlation-Id: c9a1d3f0-0a06-49d5-0fe3-08dedc8beda8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	FaBtUXVQORKBvOe8tZ+PBsJwv9KGR5OX0X5fbs+ABM2zqljAc9KWTzucsRvrVhleq6MKBd7BgDO2VEJkE+3A4qSUbpI2JMGfhC3Cl2/ltKL5HtWNNoLIPrM53fiA7qMJD8HUSyYzmQfZoI4Cn0dNK6Xuz92RCItToTEIrMMe8zXUxwg8oYfAfPZEoap6CHQEh2aSYelIdtX3gCjWV2Zm64dnRxdX7Qbb58e6aARUqj3ZWmLSwG3W7Q9aYL44mTK0qwrpiY1KhpEBDoVn0/Hp0/WQgRZ7+izLM3qt4Jp0NEdYcOtKYKlr1BHYtEg2+t6lKLn6z7mBhf2/NIghpnDwoq3BS+DrM+JNb8pl5/JS/fQ+SAWsEesYNe0zkqGtk/UGVmpgav5bepU0+55z1DLDcT0HjD4FBqSW7AlDtb5z45Z4J8/2UTbuxxtjiZuoQBAsFxVw7HYUJWN3BsYr9yv1Iw619//oj5rINseW5vaeHH0SMUYAndixHkPtp0RhEnizU0+Ua7KOCm5nvnbIrwDfD3UTV+LKd0/yM7Tr2ZjTWOc8UPbx3pZFYCDneF9SjA1ik9lX8LmlUOzvmwvV27oYJbGJdVZ4xY88O1rmvD5kXNXC+/Fhm15QJbrNXCSioBY4zTrdH2FYY/g0z0jfrw1bk0okbobunuNpKNOI1mGh+Vc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O7D9IVU6v75Y8ZbOLNwpwo2sJ7FGYXUEj5WtqHEVCbEbpk3+8TptiFXN9/Pw?=
 =?us-ascii?Q?8BlNYGb6WQt4iVixdLF3x3H/uSpTTdGIeHfpyP50IApbTkCLOTCQ+UKHjP9E?=
 =?us-ascii?Q?TQCwY3hndVoubJUFZsKRURg73Q9wXZEGejxaqsRoOp8Vg8BsS66lZQmA9sTT?=
 =?us-ascii?Q?27BtVftRjiwUVwyRUIAnNlM1W1QwLb56rMpbX+Yj5vDIdQiY4adO3iGS15SG?=
 =?us-ascii?Q?MWgkMkPAtAIwoAVD1m530hsUBgfYbbMwZimOMRfIZVZ8pu+LY639saGcgIo5?=
 =?us-ascii?Q?1d0/0IB23Cpfv0os8YZ2KEaSkWOUmb52Yt2s+ef9mcuSRyxcQhfmKPJ7zYlw?=
 =?us-ascii?Q?2ouyUmNGJ0cjpVTlaorb9w+4KQew9eKbEAsq4jfGAy1iisTO1qCge4Mthhnx?=
 =?us-ascii?Q?xGeWLBVbSBxZ+oKh2bcsV3jnHN3Gcy0Ywx7HJWQlP2Dnv+sHuEZlROqUizM5?=
 =?us-ascii?Q?UMIVFaEmja6+Bu7OhqIePPj/cVgyszD6CMnpwDuz4njuQfS0/L9Tn6hO4MCn?=
 =?us-ascii?Q?cyGx9SA1ln3aum7gz7S655AsjICoCpOgCCfXH2yJlNIs8Qd7Vby/2/qEC1Ku?=
 =?us-ascii?Q?XR+upSZiEdnuyxukJQMePS8uPknHPxxgB0u60ItAle0vjSxW8KPOs3rueoR0?=
 =?us-ascii?Q?4JlJDpAP2pLNM5x8m+oYpIK4FrVTWANEIDFxdKgGjNRlj/BhRzngVt8il0o3?=
 =?us-ascii?Q?brkcIJ1GfgZ8uTtJows1w8bof3x/u/vU2CVk4NXaHiv2r7hBOzqyMZ0fSSKe?=
 =?us-ascii?Q?FwXx2upuWbAuXmBMyUS1kvvXntblN/dl5mfBWef8SidRi5+wDDR9wcjiMB70?=
 =?us-ascii?Q?tgWRCbyLXFglF/qwSD5jaQK8ObvH4Y/wnY37Sh+5Aah/w/gBGTCa+PdoUlTB?=
 =?us-ascii?Q?k5nHJw0WD/F7s9XiCiXRmfyGh8r7ssPVr1uBMYY3xpUHCqC16ij1hrOJkyPe?=
 =?us-ascii?Q?SFRsEs7g7NPAUNBXtOj4v1ITV3vuVB0Byr1qDUelOmuvfKoxBSfqwzG5MmvF?=
 =?us-ascii?Q?Cuom7YJ1N4TM6g5ASsFPhoZZKvGd9v/9dtvJ1RXRD47JddaOZV7rnP/d8qev?=
 =?us-ascii?Q?1KWoO/LQtOMuyw0PRqlDMH+LQ66R5BcdCIKh/ANAfOX9qAmhg7Sy7dKpvufQ?=
 =?us-ascii?Q?sLBWRbFRAe/NE8KEhNns/RNwBt9k24B38lE+SA3cyFoo651G/VOZvgenR2z4?=
 =?us-ascii?Q?YJvNrw/1slT4vG02eQM4y16bidUALLghBvNIfLa/K60/cXEcFSG1McQxBYcA?=
 =?us-ascii?Q?Jgm6yZYOmheFFYu9xHDqqDVYy3g6wATfxsFu9GDvdQKhYgh5QAL5wouupr6l?=
 =?us-ascii?Q?JxYYA4tT/jwZO86B9uFHLa3ZkL+OJDGcgij6iclTLfHvKOfC6c+gsl45ho6X?=
 =?us-ascii?Q?Xraq1xngQ3Jj6Fv6oujnet7ZgDJt9g3NVx2VSWEQ6G8b7U2NYpazBlWN7n9c?=
 =?us-ascii?Q?MUfezUb5CqpzZUxuz53pCIK3d3ZHUKMqKNH+YkXg7TOEZYjGtOgPIzF/c6pc?=
 =?us-ascii?Q?zXPtCvvTsvuyyqE7jkxpYlmO9MCoQqQMb3L4uFHNTzC3V4LjKER5wRTZoslk?=
 =?us-ascii?Q?w9zWt2gY11qs4ArfYJ+U55R6TadNmn3LeZq9D2gwKhn41vHvEesW9kybFA8j?=
 =?us-ascii?Q?teeaMxChPvGTw3u5Y+U3MTdXkmVA+iGFoNhUpGQC34M2HRB4bH9+DW7WRq5B?=
 =?us-ascii?Q?qUK1xxrnoEAHu9uI7Oto3tT4zRFvod8T7EJfu/iO+qg61JuANJEy4WVMYtsj?=
 =?us-ascii?Q?3b60GABkKg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9a1d3f0-0a06-49d5-0fe3-08dedc8beda8
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 00:57:48.0664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ebE5ajHaQkBvxLOMIq62I8gZ+G7bPQIX33A78koGZOmeEAvNx5ow+bLD9wg2f92HMah6BwWYmhgyz9HNXABQDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9178
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 83285A0002
X-Stat-Signature: 53ewkrabc7fr9kdzt6cectyb5qteyh3a
X-HE-Tag: 1783472278-49650
X-HE-Meta: U2FsdGVkX19uGnaNhO/GGtSivE4WZEjuWldJ3avHHdjmsdzZNtFk6Gp266aU+GD4cuKwYZElz7iwhxyFECWJHgBaXWCggf+fbV7a7/Jlicc2hDXP4L8/Nm0LhxlqAyX6ny2C/ns5uyNtgXrGUSEpPWuBzhAlL303QTpvyG9HO7CpL4bDwMCgoVNrEDskdZFBypEBSyh6SPlnu0UT+w7LLt+9ldY86ZQWxeKC91HZ5HtVcxcBJg+A8yFVlmNgHyQnUTY3TB+TDjPeRZ5Orp7sCNozjhlf/SI9Dlda8t0ZGU1npWOs56pdurE8/KercZeEfdA869igAYrugTxBhlWMBLlq9qhra2Gc40Lrd5qx85f07y/yRbP7S562u+1IpmsonzgB57Sm1ZwJs6HQO1ToNCzX2JmfGHfrHkdzz74VPXGXKhpHdW6GN8WH0zd2eZstE7YG3wN56/L1cB/jTc+scGfBfgYff0DSv6JG0pyM/pHRwa2NYqjUnB4OiME+xIBqsuQJXaDQ01/yC5FJ49M/kuaWMaLpWDPqxhXN31dtJaHIvPaRVXVe9+Xb2rKxPlHdqJ9RRrsfeCTgy4cokgoPHaWFF2iYIseaUJEAWQ1MFj3TvNHx55zMAaOS7nb6AQLxLNGnnNqdhhqXmkb86w5UbV3KlbmDmn1EKwq6tRT0FOHsMQjNDwViCW0OlhkAOe59RqxjwRi51iZ1i4NIPWr3WcFqmAcYx1STYf4LzfJknhSMdnyQZnnZkF606VJ1TTCQOekOa0N4l0KWRH0LP0aBp1wxWIlrAi+OD8Tff6Gug6YdF3j3DajmdVZmm4DkYKHMriUzfvO4SvE4y4p1M1LX+gik/4EaTHlfUcIwotc0QFHojjEnA4vEvJZkP/Jp3PWZxqZ5LT0x4QPEnR6HbvkLpxXpq7FNTq5UAdNlSZQRyS8IIvffr4IFvr77cryr27Hijp7HrIQlgT4XWmj/Etb
 U7UV4J9C
 Atwz0Z7S0tCS80gcbFpmMp2Bm23HNHnrnZRSCIcwnLVNqycvU2fmMF7+CqSHlUnqBC8KHKopon48vQYq7V8pOGQFlX9Ki/ixOr6TpUHs7Eba9/ju/un564d2Not2774KiO99hZ4nI3IHoRSpJ6D32veMdSYN/1V0XioSUK7RDEx5RxuVrtmFJKPNaBCtnTpYE7o/pbeynK96Cuiodt48wC2eIfxDrfDZEvD4eFEjHQmwNNgbqqlOMPqlL8kac7gi6HdEH5GUKqb2kpjOT0OaRPBexL3SPb7FnqwcpQwJi7h8ykcyEsQTRMUiccQmxNFuNcPkc1g/94ug114gzFH3VDXBjcDpMfsSURKpocZVoiwN975s4yEeJaiIYl7cNxTaymGkrSVQZMqqP2JvwxrCcCSELjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit f002882ca369 ("mm: merge folio_is_secretmem() and
folio_fast_pin_allowed() into gup_fast_folio_allowed()"),
gup_fast_folio_allowed() falls back to the slow path for any order-0
folio with a NULL mapping when CONFIG_SECRETMEM=y. This causes a
performance regression for drivers that allocate pages with alloc_page()
and insert them into VMAs via vm_insert_page(). These pages legitimately
have a NULL folio->mapping, but they cannot be secretmem pages.

Secretmem pages are always added to the secretmem inode's page cache via
filemap_add_folio(), which sets folio->mapping to the inode's i_mapping.
A folio with a NULL mapping can never be a secretmem folio. The
NULL-mapping check was intended to handle truncated file-backed pages (a
reject_file_backed concern), not secretmem detection.

When only check_secretmem is true (and reject_file_backed is false), a
NULL mapping is sufficient to prove the folio is not secretmem, so the
fast path can proceed.

Tested-by: Sourab Gupta <sougupta@nvidia.com>
Fixes: f002882ca369 ("mm: merge folio_is_secretmem() and folio_fast_pin_allowed() into gup_fast_folio_allowed()")
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---

Resending as requested [1], with David's Acked-by added. Rebased onto
the latest master. No code changes since v1.

[1] https://lore.kernel.org/all/20260409014647.397515-1-jhubbard@nvidia.com/

thanks,
John Hubbard

 mm/gup.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 0692119b7904..99902c15703b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2784,12 +2784,17 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
 	mapping = READ_ONCE(folio->mapping);
 
 	/*
-	 * The mapping may have been truncated, in any case we cannot determine
-	 * if this mapping is safe - fall back to slow path to determine how to
-	 * proceed.
+	 * If the mapping is NULL (truncated, or never set), we cannot
+	 * determine whether the folio is file-backed, so a long-term writable
+	 * pin must fall back to the slow path.
+	 *
+	 * Otherwise, a NULL mapping proves this is not a secretmem folio
+	 * (secretmem folios always have a valid mapping to the secretmem
+	 * inode's address_space), so in that case, we can continue with the
+	 * fast path.
 	 */
 	if (!mapping)
-		return false;
+		return !reject_file_backed;
 
 	/* Anonymous folios pose no problem. */
 	mapping_flags = (unsigned long)mapping & FOLIO_MAPPING_FLAGS;
-- 
2.55.0


