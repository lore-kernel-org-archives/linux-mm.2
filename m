Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B601CF364A3
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 16:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 043636B0005; Thu,  9 Apr 2026 12:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36C86B0088; Thu,  9 Apr 2026 12:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E25276B008A; Thu,  9 Apr 2026 12:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D23126B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:55:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6AADBBAF2
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:55:55 +0000 (UTC)
X-FDA: 84639619470.24.B0D50CB
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013015.outbound.protection.outlook.com [40.93.201.15])
	by imf15.hostedemail.com (Postfix) with ESMTP id C4D19A001F
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:55:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Glv4Jp9l;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775753753; a=rsa-sha256;
	cv=pass;
	b=QiVyUhlojylj5xlcViUvG5mHLRc4o8vSiYn37kU8SaoheFRFfgvjrHPFKBr9ggQrK9gFhm
	K10/Imjtp9RWktaw8sIJMJG3f7DEKLS9IUC5Ll/3oFkpJp3jAnaRH0TLLc6HntgtT7NMMZ
	+Noh0akV8JRF+ErJpnMZvnGC2Nmctn0=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Glv4Jp9l;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775753753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjYdKGYwESNlmkEWP58Pizo5OysD7aK2uWlWy8tfkdg=;
	b=5bMelggwiuA/HQtKOvMovdNv0eKuaUaPomLK41W4kr21IQp0VMWjCFrokE+VaJxMgcEg0O
	H8SYaG0lYZvvIRQ9IY51Lx3LGLqiQaOIZTWzQZaHx0k8JURwLctiw86Dw/bY+phk6ypTf5
	VMX7Kq2I2t9uYjYlP7GLD5h6tgI0ZVk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nz3mAnh9PqXeTlhBcfs/i+4JXzUQJzAPbRp+GFMmnpIrLye+5qNcO/poT6EEge8VC9cOFy6urWeiPknXHFXJRHhs4NO3Dad1rWwzlchnLWkSEQKNOZ+Q7CK4Z2SrxA8c+zLJZ7PzrmZc4s5yhe4lclwVnDgObYHsS8wXGeYGkFi3XfmzKL1wG0HYjgn7p0bumnS4Bo7s58ubEuuBmNTJuuqX8PcfUb7UbGSH/MTLlp81dxWzjR3NKrzzjouFt7ZK1tPQnkPyOO4ClncF1QxBf1rwfiTqoSK9AeBSEvAA7XhEZeXan3JbC2iUcm5V8QmOgwrih7ZGgxH1xAQMFilX4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kjYdKGYwESNlmkEWP58Pizo5OysD7aK2uWlWy8tfkdg=;
 b=uZLZHpkmpAGNTlA8/wE4DYALA0nNjwMXA+1i9JpMtG4XmOIihlXwkSWjx2GRR9tkIbU6dYqfBcweHAemEYc4RdNup0JmWxevuoeo4Rs2ChT747g0Xai0WwDL+4Gg9S3VhTcKNeuxLrql6C+uTxQE1Z7MrA2A2IPCsTRPnXuz2uYVwH/LAkdzZd8ZihFxTxis2ToWlJ5DmSxeipFmMvL6Zl5jiKZVLclWpY3tLLmzEVQaObEPopsbLw/AoWgmsJY5nDzEj+qll6FEa0aDauoOGkFSy+VJaZE6NXe/3R13q+j+ZwS4c7S9sJ86PhPHGZ3xB9+pxi20UK4S1HIS+reUiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjYdKGYwESNlmkEWP58Pizo5OysD7aK2uWlWy8tfkdg=;
 b=Glv4Jp9lVV6IxkCo8l66CFFxUYoRq7Vr6FaLNp6xXFAHN0U6nOlrcIxSUc06AG1flsdyKi8FvJSiDUx2O4rOPFV4jOliJ9BZhM53fvOLPx31JwuiI4wrzptYS17VXk6u5rCg/ykVAO3AegsSfYgVVx8/KD0X4nPFKZDR1RJojR/Lsx+bveSVV5uN1uiC87vqC1dvmYNAXuZ0OaboefTKA/rvBmEAgwoeZmR+e/kHEGtu7rg8Y+7JRf3S0D8jJ47gQUC7lQlhChdBce0AoemqfJyBLeANkoMSRufzhhzgvUsrBAHyh9LU9VY/O3bvqrS+jvOKNgFpu+RQP1azPo5/pw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH8PR12MB7448.namprd12.prod.outlook.com (2603:10b6:510:214::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9791.32; Thu, 9 Apr
 2026 16:55:47 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Thu, 9 Apr 2026
 16:55:47 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Peter Xu <peterx@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
 Sourab Gupta <sougupta@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: Re: [PATCH] mm/gup: fix GUP-fast fallback for NULL-mapping order-0
 folios
Date: Thu, 09 Apr 2026 12:55:43 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <1A7433E5-C8C1-45EC-A0B7-2BDC7D065B1A@nvidia.com>
In-Reply-To: <accf843b-ee4f-46a2-b187-a6d8e4115ca7@kernel.org>
References: <20260409014647.397515-1-jhubbard@nvidia.com>
 <4d6c1af0-dee5-4f1b-b74c-2ebc23de7baf@kernel.org>
 <D74E0809-E673-4CD0-84DC-46CBDBB06F03@nvidia.com>
 <accf843b-ee4f-46a2-b187-a6d8e4115ca7@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0P222CA0012.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH8PR12MB7448:EE_
X-MS-Office365-Filtering-Correlation-Id: f1058930-bcd8-48cf-e251-08de9658d87b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	OPITiOYkX9fC/siZD5FALJHe6dzslSCCnkenztGOWBG2A2UyOa7NnT+z0jcVhGyrUJA5uTYGeh9DUKQWc5Q6w5eH+OpNQlIZFMbzMbgehnZSxMutSiItjKU04oj5pUyAGGPUW25SxRhWuRAFZ0QBuWPeUewyTl4mvPKnNFeeKJSS3tr6Y/tJZBeonByzDB+iEYTs+kJGtxWBXZYCHUG0oH6jYPtcDHahhxGVzQf9j6//3sBKQiAh6L5Y24Osi2mtgG7VaVhvJgs576wsM4YM0NXjgl12ucIyIUqAdRKieocaWv9wmxMkCvYIqrBc6cls0ANitVbuAza+lhi0DUw0SJODPeQR6dlWTYjvfEk2vK5I9qLjMLgSqJU24A9wJQUeGrLCnLDKxZ6jzPz+0BZgTDVATqdTPfRkTfV+qvFMUTVVorGEREvEM6JIznNf+9xS5s/FIS03KCOIJxNXAYw8lnukr+r5vEy0nuh6ZbHxnWdbcz81OLnjJS89GSoCL07bf339Mr0+cOu8MWQDjSFhpCeLpbhr3hNHKYufFNkbliRjUbiGFtt4WnuIjA2chpROm7iayCenrjajaslUEFVder+mHAQHYOpw+4Rw+jZ9a/1/CEEesfRIf+N0Ftsu4ejgx0NTzt+jek2QTPOdKPW7WCNWOhd9NX0ZbbqYMEiNihnAoGgxml+XhVQtuGXJKvcrXE33A7kGx5fLLz/44nZJAh8vTwqIOagusKcjX2ewahM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8+nvmZ58hGdqUUmpZ8i8BarJEf3sLYc8YeGviuAQDD5DJw+s41XV3NUpChxo?=
 =?us-ascii?Q?hooTjau2EZdf3bzn5r08s02VVWkSRbuBNNhVbmNR6/x2gHrRG/UxjNqCjOBh?=
 =?us-ascii?Q?WWjFrK4rTvhamYGqqqd8iwSlCJDxelCPnuDvrW+vm/5zxhg+hRHlzx/5IpnB?=
 =?us-ascii?Q?aGTPMAgbvyOBDxc3bKX/sbnQVeCNvPLVgUIv9rG5YRCkKKDzqwH8OQrpmJ2e?=
 =?us-ascii?Q?cMs6UBO7M3sBqiREm3iy8FGu0marSb4c0dwqGthS2RdMUQv5MyHKmU2280X/?=
 =?us-ascii?Q?Q+2GjUmiweO3RIiORUVo+haW3QPxzSETvRjvy9JGv47+FWYJeMEWU6v9UsyK?=
 =?us-ascii?Q?YCGYhppTC6d0wP6tCB58yqIqTKbzdX+OSjegcQcxbL/RKX+CeLr3uH3MWKDB?=
 =?us-ascii?Q?KrltCHxa98MfRMXYVqtHez+xkKlvKqX8MC9KqMMyYupSEDVSCObjFZ2FgpNY?=
 =?us-ascii?Q?Wla61n9VnkO6E5V/8xguIBwz9YYh4BVF20rRs/oHK3l6ixcXJfDKfCoZCofo?=
 =?us-ascii?Q?Vy1bvuqMWhI0ULYhC+JDOqoAH7ab9mBjxYHLIjX79uWKJEDQYEuzxsrUIp/h?=
 =?us-ascii?Q?u/UgZbSjz5jzKnby57WnwsP3U3pXHOgiA23Jt6jS1F+YZDVLN7Qw6G62f0Y0?=
 =?us-ascii?Q?zhFFqU63Gde3M4B/It4sb7Guqe8ECu0dk3/GayL00UQlg1VWStLUI5DOexCP?=
 =?us-ascii?Q?v7YtNbK/czrjFs5ibLFWh5bziT7bmFwbh4CnDat/aUMlmwGZqlUxzZul9XKr?=
 =?us-ascii?Q?MUZ+BvU9rkgIx8zQgeFIdPMShSZUExnLNvU2bLyd/TtpClqhsSKHt8ywZYfV?=
 =?us-ascii?Q?9YnJkGlDDuESsMB2j92Fimxn8zRDDmvtK7+MirR7uS0qvcJ6Lv0vq0H/ZYp8?=
 =?us-ascii?Q?E6RLtbYH6xMCTT9qOJx0DggRyq5Sep1Zrq9BBYg0KxbDXD0gUluDs2+Hfj5k?=
 =?us-ascii?Q?LRHn08+eY594eTrjM3md5+D8Eow8+MtWyNxSVe26WGfYksfbMgjaDU1fRLD8?=
 =?us-ascii?Q?90YbJ3EYCLDeWTUZ1WuK0r61bOzgxmCy4CzurnBaWgK1qrBYjad4xJSL208r?=
 =?us-ascii?Q?Oik8JRmeGibu36L6P6sOembHYtkPeoNJCXjrxh5u+PGRmXMp0mSXVB0yAtU5?=
 =?us-ascii?Q?JoJfwn6wBPkDWYk05XkL0EZUih2wXzXST2k4hyKKpFfV22HgEa/aSmvtboLk?=
 =?us-ascii?Q?FgjXqcla4qhtSCkqxtJYp8zpgGALfncU3zCHzfVoYqS7Dqfjv7UrsO7moyp4?=
 =?us-ascii?Q?6N/wIqpvzIEqbM5SAyk/Jlzdcd9Z2nGnm2te/U98bq5gi7puJrj947iUeMVJ?=
 =?us-ascii?Q?WRjtlBgzwa58s2dF6FJi9Igm13SPBS3V71rQ4rjb+19jYgfO3oh/wE9yH2RL?=
 =?us-ascii?Q?ShJeseWrYYf6CSI/YmwkfdqDZqJ9F5TMHOb8H8mqRrTAh5POAc+mjlXSmTV8?=
 =?us-ascii?Q?OZ9igYpJ3G+mhRnVzxyv5xDO5s/nFK6ITFsK7O7pW03Fb6vz7gX5CgJUe6G3?=
 =?us-ascii?Q?doDf3zW36M7HebcjXGRHpYIsfJftT4OkBS+KexwwXr9QVNoZq9hlL6JfUMkC?=
 =?us-ascii?Q?wJdeIepADAaJ0DRfg604u7a3J+gNuzxC2JPygR+vlL8xUJRfst/RUfcw4sjN?=
 =?us-ascii?Q?DniO/icFlUNLmHKz8uOWqFSMayWHb1JL9Z4R5CoazClRcMd1j/KDvUwR/UXp?=
 =?us-ascii?Q?di/w5zXEJtPlDs9VHdm3FHzHvVDMZfiyOnNM9mVBK3c/SauM1dEBv2XJpbc+?=
 =?us-ascii?Q?vaBRdu8bbQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1058930-bcd8-48cf-e251-08de9658d87b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 16:55:46.8912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OGWcJtTOGkDi96VoOF/UNdAAANiypFme5RX8L5esKQVxjo3Gws9hvhIbGVY5p8JX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7448
X-Rspamd-Queue-Id: C4D19A001F
X-Stat-Signature: pu4xrat9y6ik4b7ec7bt69mryauszrdm
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775753752-628658
X-HE-Meta: U2FsdGVkX18EfUqCpkqvz9tTkJPE8AKJ4s3Tpxn6Z/WOE5r6dAEfLSQtfyHxYwGsV1kXIUwBB8zITi4Fb53u1iXAKlkWMFezAhn5ZHGxkxToA2ik/PGSwqsGqCKXHPDbbbg0/lZFfKzg8O2d/+87NKDlf89YydVyykGyR468C36WLwVSNZWp1j+z/fOTAwJkk4hCUImY/dI3ELgsyNLMjH5DaJCo+ArlgxW2jEZ04u+MxfH7EfOGpxOiT8yNpcjVofZ2+/Lq7XkNDzeMb0uBy1x3vvnA7gcji7rS4eJ4rFdj/EXyZEzz+8Eyt5vrQobO6TUYZTYx8oR7wJKLSEgMY3H342CPS5+QjfpJ9dT0nKirx9mE5BA54vOZPtuZBGlL/Do3FCB3qoDEvsyzGlYGmuQSvFcYK8rMtZ85+GuuArmCY3fNCCqoIHdyHloEuJmJRft479RdbK5tAx7Ue1tJA43Hah8EpcDDOxadDxTxcClCRikGAfzhpAQ2EcUV6Epjl28yH+tGElAjOw32VJjfdwhRbL4nBUN5F11Oeab1eu9Bi9GjFl1w/vaKCAaNzKq3snBQ2ZSBHT25e8l6bDASt2zkqVRKnDoBRQASy9GNaue35myaSXB7/VIqFtHu2fx4C9ha5eM10g1E5M5AhYWpkigtVveQhczQy0nFmx2IeCbbz8dNGWkbd5irVuGGO7xL3XKJ+kXa9tOs/8ndVLF38ybY/LCYZGRA122GxW0ModWgFIP5Z3Uccl2Qyqz3cGlqHcAOVlf6zKqgetDkrFYse1Dk5LQqhOGKkTtbMTL5EgeLT0WL6YcOF8A/xzlf+FY0HeYUYZI9Gb7qRo47J1Cz8vgVwxBpxyq8051Z4eiEvac19Oi6fARxbheuNN6cW6AhIPm7Z5r0lYA7/SHmlKOKV+UuMeptyM4imSwZzaz1zcvfzccft0KoNcRA2g4e0dQboKq5FGg6haT9HUUVX1C
 CBzIYT2L
 3GBHb8TLtUgjTAEvWBJLFeM7bAeHq6nq5sCdHSxmuU0EJB075cpA1kW+D/hF/pk3ZR9B4eS8uJiAR5knq49CQlreliqJvh7veMiM7zeaHl5ySx6Acxn8cwucItHs+hOKANLpe8hStO8XZLQso6AnF9+/DkMO8jDTp+YRzLfwu9LICB1uudzXfWpRI5/6QUvj+sVefGMAsGWv03VjGy2PqKNGGDrRngSaRhSUI+qjmywqqR0SJwCS7eeA7bNIfse36807mThAxRIubBBfybNmvJyVkRTC6SogttI03I8OQOE7lqePVS4QwTnwGcdKPCXnPTSw7+OquJ8VRNw+JCMdngG8T/S5uxMvIoPigfzjYDwolzx7TI9B0YIBdWMt/LlnlebI0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Apr 2026, at 11:11, David Hildenbrand (Arm) wrote:

> On 4/9/26 17:05, Zi Yan wrote:
>> On 9 Apr 2026, at 3:52, David Hildenbrand (Arm) wrote:
>>
>>> On 4/9/26 03:46, John Hubbard wrote:
>>>> Since commit f002882ca369 ("mm: merge folio_is_secretmem() and
>>>> folio_fast_pin_allowed() into gup_fast_folio_allowed()"),
>>>> gup_fast_folio_allowed() falls back to the slow path for any order-0=

>>>> folio with a NULL mapping when CONFIG_SECRETMEM=3Dy. This causes a
>>>> performance regression for drivers that allocate pages with alloc_pa=
ge()
>>>> and insert them into VMAs via vm_insert_page(). These pages legitima=
tely
>>>> have a NULL folio->mapping, but they cannot be secretmem pages.
>>>>
>>>> Secretmem pages are always added to the secretmem inode's page cache=
 via
>>>> filemap_add_folio(), which sets folio->mapping to the inode's i_mapp=
ing.
>>>> A folio with a NULL mapping can never be a secretmem folio. The
>>>> NULL-mapping check was intended to handle truncated file-backed page=
s (a
>>>> reject_file_backed concern), not secretmem detection.
>>>>
>>>> When only check_secretmem is true (and reject_file_backed is false),=
 a
>>>> NULL mapping is sufficient to prove the folio is not secretmem, so t=
he
>>>> fast path can proceed.
>>>
>>> Hm, what if secretmem folio just got truncated? I hate to rely on som=
e
>>> handling in the caller to detect truncation differently during GUP-fa=
st,
>>> but this function returning "true".
>>>
>>> Zi is working on a way to distinguish folios from non-folio things: t=
hat
>>> we can identify whatever was added through vm_insert_page().
>>
>> The idea is to give every allocated page a NotRmappable page_type and
>> 1) let page_rmappable_folio() remove the page_type by setting mapcount=

>> to 0, since page_type overlaps with mapcount;
>> 2) allow callers of alloc_page*() to change page_type from NotRmappabl=
e
>> to other types.
>
> Could we instead just set the special type in vm_insert_page(), after
> verifying that it does not have any other type?

You mean in validate_page_before_insert() we set the page to NotRmappable=

if it can be inserted, then in the rmap code we reject NotRmappable
page/folios? And NotRmappable will remain until the page/folio is freed.
That should work. So the purpose is to avoid setting the page_type if
a page/folio is never going through vm_insert_page()?

>
>>
>> After these, rmappable folios with any order is a folio without any
>> page_type. HugeTLB is an exception, but rmap code has special handling=

>> for them, so it should be fine.
>>
>> I have a draft[1], but have not had time to refresh it yet. I am plann=
ing
>> to work on this after my two other jobs (make READ_ONLY_THP_FOR_FS ena=
bled
>> for all FS with large folio support and ensure ->private is 0 for tail=
 pages).
>>
>> [1] https://github.com/x-y-z/linux-dev/tree/remove_mapcount_for_non_fo=
lio-2026-02-16-23-27
>>
>>>
>>> Because that's really the key problem here: vm_insert_page() pages ar=
e
>>> not actually folios, they just look like a folio today, but looking a=
t
>>> fields like ->mapping does not make any sense.
>>
>> Based on my understanding of some callers of alloc_page()/get_free_pag=
es(),
>> vm_insert_page(), they use GFP_COMP to get a compound page and vm_inse=
rt_page()
>> individual pages of the compound page. These pages might be pinned.
>> During past THP cabal meeting, we discussed about it if
>> 1. we should disallow such uses and only allow order-0 allocations, or=

>
> Right.
>
>> 2. we need a new type like new_type_folio for them and the type does n=
ot
>> have folio fields except ->pincount.
>
> Right.
>
> -- =

> Cheers,
>
> David


Best Regards,
Yan, Zi

