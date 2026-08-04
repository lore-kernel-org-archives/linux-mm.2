Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E044DC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 19:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C75426B0098; Tue,  4 Aug 2026 15:59:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C26A86B009D; Tue,  4 Aug 2026 15:59:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B15516B00A0; Tue,  4 Aug 2026 15:59:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8341A6B0098
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:59:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 092BBA16D4
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:59:24 +0000 (UTC)
X-FDA: 85064651448.11.ADA8F25
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011015.outbound.protection.outlook.com [52.101.62.15])
	by imf31.hostedemail.com (Postfix) with ESMTP id 287C820006
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:59:20 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=usw2EYWa;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785873561;
	b=C9kw8o21ppv4JrSVDGDvdrkKzeUnp6V816DBh1Gdw5kUql66i3wKTCmwWyoZ1lO6KRWvfC
	hHhQdvw8mp9YmxIjzf5Dqsm/5sGXmf6JB36aXLV0jHVwtMqzMeIegArlaoV+6zhNeXVAov
	IkpW/mYxno6KUmswUB5V/e9t31lr8fk=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=usw2EYWa;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785873561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zmJrYLNemZq5eJzgebwoj4EhazKrM7Zp5K32QI3gFL4=;
	b=zFol3MiIW9ExnrJFIetsa2CDfK+yU26hcagc+o/xUYyzhpLEMEoy89Ss9W12K52A6HlAJM
	dL7Zv+ynz/vlJznq1S3YAmCG2ggZOHNnR65bK4U+RbA3Ydme5FAwZ3ncCz24FgaMc1B/TA
	Zl8aidLNEh1JbO2tdnr9bOelvKQ1i8Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kylcZZICfvEOtzjAtTUsZf+A85Hc6CzX1GsCZPPBhg0qQabLjB8FZS14EMPZchU7bFz8RCi0kCJPSRieZbiSHD36YaMgppzUEVt7j/c7beXMplUpN9ywNSki8mfmMud8nNv2XtKd+0wzQTeTVMG9xDA3xQaNJUrciYS3O2vNqiaB5OGOHEqfVAiL0hJxmax6+X4etP6vdXKV2rR++K+gkmoHSswTu/52qRzIbBHAalfpyZXBn9n1qQ63CkxtM/Zu9m+O94jF+DiRcDi9yfSOx2cC19WHSIGTu7DEWlwKdPzyX2KqOOoQh6Ko19HGNhre/Xd/OO8a0NJDYm5KLK73tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zmJrYLNemZq5eJzgebwoj4EhazKrM7Zp5K32QI3gFL4=;
 b=NPD9N79asGKZ+kA3Tg+gvw+3zH+/0/LReAD4v2sMUVs16TJ2i6eIxtiOf2FB/wMi/iqwePFrrcp2Vho9WnSf2armVjAJ691Z3C7hRJUAHa+oucsGfyP9yR5ijLOcdTonuF+vhtAMXXVmqSauf6tLXwar2jnBiJsF70OYAAOQ3aC+M2y6VCXug3i9weRRDkWRf7kV/1NrF20moUUx76AbjB6jxjdyGIy0mWxNqPEuGYLmlvjb96NWf126Q1u6DQJECqtX7Ehg2BifzStx77hLx8i0lTw+EiVn0+PqkYaxBTYcI95n77GXwzOm/9pohvtjbu5r3HJOj2ixH4udA+FKOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zmJrYLNemZq5eJzgebwoj4EhazKrM7Zp5K32QI3gFL4=;
 b=usw2EYWaxWW1JTbt2GQuR0VUG59aMknGeZONCAa3bUzZDFCYiXJ8n9HG7Sczgsr5AhG8xG30Bp2lIj8yVVq4PsKARYBfuz8g/kV4ihUBIdEzHwTHf2g265ENd3lMpa6U7tKnSOWr2u4wZvOVYUQAsP7VkCcnncJIyDOoDzOH5G1np4zZyugJzML/xgHvljsYenDLvaz2+LCMd43El8PPDF0AGTVllCKvKMq+lzjaBQTSUszcMq/vecqv5dE3pi4RElRlGv541kApppRlWOuf/CsPPm57mlWVK0RxwqNjHk5+OI/IqLvX20hxTDeUCA8l06+nr7kSxfz7aV6Zl55eGQ==
Received: from DS7PR12MB8371.namprd12.prod.outlook.com (2603:10b6:8:e9::18) by
 SN7PR12MB7274.namprd12.prod.outlook.com (2603:10b6:806:2ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Tue, 4 Aug
 2026 19:59:17 +0000
Received: from DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a]) by DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a%3]) with mapi id 15.21.0270.017; Tue, 4 Aug 2026
 19:59:17 +0000
From: Zi Yan <ziy@nvidia.com>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, ceph-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v2 01/10] ceph: add ceph_folio_snap_context()
Date: Tue, 04 Aug 2026 15:59:14 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <F6B9E1A7-D812-4F28-B9BF-CAFEBE68915E@nvidia.com>
In-Reply-To:
 <20260804-remove-wait-on-page-writeback-v2-1-81f0ab065284@columbia.edu>
References:
 <20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284@columbia.edu>
 <20260804-remove-wait-on-page-writeback-v2-1-81f0ab065284@columbia.edu>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BL0PR05CA0013.namprd05.prod.outlook.com
 (2603:10b6:208:91::23) To DS7PR12MB8371.namprd12.prod.outlook.com
 (2603:10b6:8:e9::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB8371:EE_|SN7PR12MB7274:EE_
X-MS-Office365-Filtering-Correlation-Id: 72ca4e3c-93ef-46df-e50b-08def262dd61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|23010399003|366016|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	d7oGf2cmpDDFYRStVrPxxU4ZQzA50HmbZu9pbjlCO1V57HhtHs0xMGYsBJx2keo4thp6+I/S9tfmVqq3guYPPFRgUR26AvkMNI/F0aSg7U/XXX4c68VtMoDGDAR8yEm6zk3/l/u85qAUebSj++16OyeRxPJm+ZxxwzFv1mYLIHBoXyRIlA4Kuck21WDHBMqvaHEUL1RSizSnRF3q8KG3Q22akUoTTn5pIv3LTGM/mbVGoSWSFD8Kp/7OzPDN/rx+4cuqttGEjlJLtXExLkNrurqIWvUDnEYkGiSuLznDKg7Uz+mxG3gVipnHxh7E2athrrXd0Qns73IK9a3jOKSIBPhgQAtsrM0H4fVbCmTQg1ErGe7Co9c0tCdccYi8+y7rVZ9Uxq0yiqOxEJJQn/gXZt7dwbElt/xbDnNbC7g+k4jawUHHEfARC+nuRwhjkcRYTYAjvnoSoDH9PsuayR+ugJ7t1MZYKNVOZTPKwWR7W1jhyx4cx/ciGHMTy9rowELLchyEnd0LpASfuTXWmwQv5OzylYrZyTdysHUHOPNVDA7hoMoe1d/JO+PeMZzukt8kS5H/z7yH9CeL/yTgznChYlY0Xk8vvupFOkBQ5P+yrki68AaHaUajiqB+me4BkkRqyLQHngjCvPiCngeNrs+Z1l1/nYNRhJoe5ubiL20y7N0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB8371.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(23010399003)(366016)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SjfNn05A9cd+OCEYQYh5L7LVuYj9ppmso1jv3ukvzjg25NbeqkizMjCkS5am?=
 =?us-ascii?Q?f4rWkuGcnmG0L4g1JQnS4PctGlRJHXp7CPCjXRFzpiSOGMzyl1G3P2+0VyB1?=
 =?us-ascii?Q?dog6n4BlG8G3xSh5cwJMChFcYTl+x6p7kioTsNiqb0U9EVeAarevpkMjpUIT?=
 =?us-ascii?Q?S5X9srVsVJoYTqWiiAaSFEGCzQelWwTS9q5MjiHs6rLLg4MWocGN9YNNlt4R?=
 =?us-ascii?Q?Y0WpKgg2OGw1RNahSGb8h/C1EkIe3npzV6gQPCNGsEEydz/0APEuyaFujbzs?=
 =?us-ascii?Q?JXTUvLIy6xK8cTVDKtXu/xEIyQmBQ4hR+NeB7HDtpcnpPEdMVQBGtB63VpSD?=
 =?us-ascii?Q?a+dxPWF/PnYxvs9lGKz0X1F56SYFNyZtNGGiciefj3u7PRGJBPsEdKW9MZRg?=
 =?us-ascii?Q?fK6+Yx3ABORodtXPa4ygDGqiC19CXyTA2wTnr/3wBnaTPp/ZVZNbcsdymPQj?=
 =?us-ascii?Q?oYo7owjWsDlumWFd5v3oxFfe/2vQ6oTOsSIq9ZWgOlSaznKPZ6JC8+k5daUj?=
 =?us-ascii?Q?4C8raURZ0RC14vuhgqwEhLZP+kYBGgWnxH8Lxl9MCKwk+DKCvAjNxe+tOaqW?=
 =?us-ascii?Q?PQg0+YndKiU35BJoyKfkbm3BqMUul6T8qNlzdn/9C6oOCin+dhMF5SVOWeUF?=
 =?us-ascii?Q?OJ/mYUM2/+UNyfE3GBdJSZfO5teWUMRXYhvf1rXAJyCzhLHXIsP375mNlIHL?=
 =?us-ascii?Q?RKRe5CqfmD5uMLnIFa7IqA2UmIMhqkZrfQmwNaGOX8WulpVvRlrvg7q6meeL?=
 =?us-ascii?Q?SlB1DKNgPvIFgnEFrjK/F8az6emmPAHnvPu5E4x50S0WkSyVegrQTlf/TkJL?=
 =?us-ascii?Q?xH4+AIwjeGPMcCgyDRjV4nGF0eQGzuk9nGCRIskgS9QqOevaJbinNFu74cCI?=
 =?us-ascii?Q?kATlNtw8Kg/w4E74OmRREnCOtB+0bH8sQEVUW4KvdsxYeO9yu10IODK+L57t?=
 =?us-ascii?Q?Ek++025cSuc8aPf/rXrWDniDTYMgbwp8BQcZLGqKjkcfCDgLwCHcYyAKRyvU?=
 =?us-ascii?Q?V9ZksGUInNimWv+nasxap6miUvb/5mriURUSpL0PH87nqSWE43AIpalKs6NW?=
 =?us-ascii?Q?YSuStpC6yf+hvoAPPVTTqfX5+jYGAm1eHpgz5CJ1AUqo5Z82p8m5MSgIEJP5?=
 =?us-ascii?Q?jug8yNNWdiVfLp4c9wakRxRwDgzHdllNLYIt3W73W1XdrbF/E4iainAoHJmS?=
 =?us-ascii?Q?SQhACu9W/t3Nj75mjE9ShgA9El/0xoGO57yIqiL12PIXDx8WAESVS1uF0i7Y?=
 =?us-ascii?Q?RlntV9azdA8xUugVv5Y4K2qTfuVJJlNFRGiOExv2VrYY+VSCodMfRDJA+mZ+?=
 =?us-ascii?Q?Uv9oR4+H3X8DTjiISFuzh066rJdxK3Nj7qNy92kK6gUPgUVDYLyX3BZ38gnS?=
 =?us-ascii?Q?XWZ7D3E/pXkOflDwG5OT3aij5PSFMcIRQMg3NVp/8GAeO8J8TEiLLx4s6h+K?=
 =?us-ascii?Q?Q1MvgOY/GqQQO960t9o+7rhev+dMeDVByHWQ/+E9Un1zG1x3VTufu0pzZ4bE?=
 =?us-ascii?Q?C19JsOiBBsMx7QlaCyWj/EoaygKImndQT835lXZj4L0WhIH83WSqtbP4ymeQ?=
 =?us-ascii?Q?3ACdivykil1CCY8ldrtsSg3BVaJpc1x3x2an71ESx2NXH4xkoL9cen3cP9My?=
 =?us-ascii?Q?qVf+Y6QjJp4Ow33lpcM1h8FbZfvGBrDv2Mmj5NRK9gpKOwbH5NFJFJAV+UmF?=
 =?us-ascii?Q?mSanMr69RdrhtARgxtQjI6yRxXqfFAx/hFY7LzWSL055KfN7kwZ52mJzLeGm?=
 =?us-ascii?Q?/FRjrvd4gA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72ca4e3c-93ef-46df-e50b-08def262dd61
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB8371.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 19:59:16.9679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aiyhydHK1olWm2+4nGF9FBkx9kYOcl+d3m1cEarw9yqrQfOox86hjilohAIN5HIy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7274
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 287C820006
X-Stat-Signature: mkphegejmytttixrbrpypxn5pkxnac5o
X-Rspam-User: 
X-HE-Tag: 1785873560-80935
X-HE-Meta: U2FsdGVkX18y3zqG8foR5GHphK9HYMPVWfKqdi6+Y/O1Ect2C33qQcvLLPvZElQKLFZvhxeMbd4rCf5sqp5mh2KAJH55s1qwmjC7GoNImubrqjmP7kRrxvjtTQ27XkbxZiKN9sn+th20JGTJTWmcrF1K0IJCC9mVzUvIK3uCjlY7FOnCIFfOaRgNGsgXF0pBmBFJ2AVbxw/DxTknBcaRwMubNNHSSbEAxP/Az+iHznBtaKzjBIksZK47qEB/hQzJ3JMn8i5lCw9UAsn5hbPE27MuKJyf4ZMHdTsDWoNQkiEgFZgTNRDGNW6KYWkLRAgRGQFiaspV0lQ5FXaNGM9J7Xwi1EgXpwAOYjHSR0vm+Q+r3Joh3owKlY0rV4uJVEf78k7Ts5tjdWZiKn5hNI0glI+BLJt4iCpJjeBtD0+sitipIMF8fvZyWj+1awSsG8U5TkyV2qhdI70YcB0sKurFi3l8jZvQ9dnTi+h2TyFjoIxn3II4sX7ttoEKNQXZpGlMmt8KQvUlxOD+ikXhVL/6uHBXh1P3rXKS2X7bK9+qi2LTOkResQZ0fqhVSE8ZcGNLxqz4C8FgvnpNZCSda85tmAxFNI0+JqSAxh9DWhsaKE4lOzehJ17oiqZQ4dWJnFEJLl5Jk4wTAl97IumKrg2fFTlZDzFddgG7TOc/psRr0eXCB8RNHUXo4MlbZdtWM8Kc6LZV0+zZ111yqUiC9gV2LhxVtCDNfUKSWurrn6ZAzhVTWu62UpdF9xIVinOLNSK4Z/O89mf+103R/uAOfce3Duxcb6DqDiEHyNEOZSRAVkFUPr5cggL7Nil/TFQEMHcSNeO31Z4zB+GED2lzX/5Ug8MTKSlitFjIPLeSVmBYH+Eof5IJinfDzWh+RhU9ae7jpFgL4vn6kAIfcLwCP1X+7hMqcuzrY7yPgpt/jp6TM/0nHAhbYGAclHjXZoRT+Vjz+Gsfw66Z8q4o2/BNk7S
 Sbucswnr
 Sa5kr4oEQzIB2NGmb32zI1o9ArX3Z1TWMt5r1T9Txr23ivTFdWqv2HvTdJPdyr3vhjcQgp+nu0vF7aCC6Y+QmfaJQgKYZoBmuKTGHYEeFc1ITmUqJ/uz/FhbPHZeksuugYHwVEkawJKXMuGUT/GFpCAGU6cXVVHmBBb7QJZgw6X0G35LG7UV/aMkSDBu1JUfwwW3ulRJkx9aA4EVCxZyF+z6ZhLbRbV74Cv+jS1aNRQFw+36uEIyjxFEXu1YPKTuF0KfgoL3JlDyyBZPAPB5jTplGfzw5oA6IHJk71HE22ub+nwe38QIW099JCT79bUVFvx8CCY86rq1OF6fVGvNkKFDD0V1Gt9b4zxv1bS1vM5wiYKbx85MVeYfUu6FgRyjQxV8n2aPCJsqKO8RjeHcBFEhO1yB/B6MxUj1Ahhb7PlExvS58Y64aVIt/+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Aug 2026, at 14:52, Tal Zussman wrote:

> Add a folio-based counterpart to page_snap_context() that reads the
> snap context from folio->private directly.
>
> Convert the three writeback paths that passed &folio->page to
> page_snap_context() to ceph_folio_snap_context(), removing three
> open-coded folio-to-page conversions. No functional change.
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  fs/ceph/addr.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

