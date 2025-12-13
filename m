Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA666D59F6B
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 04:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C11016B0005; Fri, 12 Dec 2025 23:47:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC1A66B0007; Fri, 12 Dec 2025 23:47:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB05D6B0008; Fri, 12 Dec 2025 23:47:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9B1A16B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 23:47:28 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A49913402B
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 04:47:28 +0000 (UTC)
X-FDA: 84213214176.19.A120234
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012034.outbound.protection.outlook.com [40.93.195.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 18E3440003
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 04:47:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="M9NeLO/O";
	spf=pass (imf12.hostedemail.com: domain of ankita@nvidia.com designates 40.93.195.34 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765601245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DiiObMMz0NWFcx9kG4xVH/DYubG8CNjsU8JCIhLQafU=;
	b=qWPDBNGYKFqRbekLPu/MQWkBKlQibJ1646Vt5w6b3xsi8441j9E2EQzdWVKBIZk68leSCh
	9zDTBS8KVpU3OOuNTLk2yhVJ5ZTYN8KIpUKWBqCJFsZHN1hJGVlhEMX/Vs9Mz6XVFiDtVP
	3XawaU0bHTa/F5IapCWcNcSufLd8hh8=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="M9NeLO/O";
	spf=pass (imf12.hostedemail.com: domain of ankita@nvidia.com designates 40.93.195.34 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765601245; a=rsa-sha256;
	cv=pass;
	b=ATsEufjnBakUrDfTWb3wn8VtVSiPilO9tiFiVHJqdo6c1la3/TLmnm0qk9wypNU1eYvpj5
	jY9L0/kGIi9uFs9j1mSyvWFDnVNUS4C/zTPySJMk1Ds7waUTwUg+DDRI774098AYgqXT1R
	Z6SxypBDVlgFCUHHo2y9t2/tjH354VA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m7kZE6We4pnxuVu1ut0rY7hKuzlRKPFZ0ZL1k92+gAMLF6BqPInMiqBPZWn5q6wurXYwhhj/y34O77F56EkvDdAD5s5WZdGDspQqxYYwij6PKw9pNb/1nYAYTK1Vv0oo8EcAbnYma7WTXhdnR233lthSM1sapIRoY8b362Dymwo5WGCjoZZU5GSNKgWiklAyyomQUeSf7Uo65ZA2HqOihUWoCU55W/afJZ2yIYVKB+3BvWYuhkkJWTMx+V1laxj1OZpKQ8cFq9HP51RgbzfhYLZmsH6z029uWSfEaIa7mC57Qzau1H98IGnCX7ltWK+6dmL9jiGvzEANMHtE3pFwOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DiiObMMz0NWFcx9kG4xVH/DYubG8CNjsU8JCIhLQafU=;
 b=iv2PmzRjNwXVHQZ2ss4o5mrEbAf6VJLvnWJC+fNS3WDVcOd8I/hYsGxcwvuG5EHneuXKt2Jj1sIbqa+9enm59QNrS871t+kMAUwg1T+HT+OGkr5DUCjGblqkanJZQ1FVYsZcP7VZoRih7IsU2BFIr0Sl48+CYT3dxghapgcsCbdOrtlLENArXbJ1lIHTjzHD+nJRlgWQ+pkZ2t6OTgg6omoRj0NggdOw6cuOSbpwhibQ+jIQucOzhXKmtqnuesoEeCxRNRzo+DCs49FWn9CoXSBKu4oZLpiMaDJZHc2yaCOv2pduJWjxWFCSvnlJbPLMELlzc8ZUPC02Y/RJmUx/rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DiiObMMz0NWFcx9kG4xVH/DYubG8CNjsU8JCIhLQafU=;
 b=M9NeLO/OB0Sqge7TM607c8yUyb/T7mwzHKLg3ePWw3Uq3NzTGlx12O44iZ+OS266VVvBTyjd91Xl0q1NoUcbKN1WXh7lTGvUNNuDNE5S+rB/zTSIHaKqgm/fJv9vVsbW7tkRLPOImjvI60fVhOTfESit/EklZNrnZdPrPdzuHlPgTyVfMejCUKuy1rAG1utG3YWmtFsWlmpEcoZb0J/OZ5tANSi6+5P/SlaJ+GrsN2xVassJGJ6lHxPwosquBWq2BxCiUXEyOEPwjpCpc7XTjfXSf16ZCwGCjOTVs4q+JjgQPWGDGIeqBRWo5oBswsEQwInugstPvXkUz0znuPgukA==
Received: from BN9P220CA0011.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::16)
 by DS7PR12MB6310.namprd12.prod.outlook.com (2603:10b6:8:95::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.12; Sat, 13 Dec
 2025 04:47:20 +0000
Received: from BN1PEPF00004685.namprd03.prod.outlook.com
 (2603:10b6:408:13e:cafe::bc) by BN9P220CA0011.outlook.office365.com
 (2603:10b6:408:13e::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.11 via Frontend Transport; Sat,
 13 Dec 2025 04:47:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN1PEPF00004685.mail.protection.outlook.com (10.167.243.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Sat, 13 Dec 2025 04:47:20 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 12 Dec
 2025 20:47:10 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 12 Dec 2025 20:47:10 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 12 Dec 2025 20:47:10 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>, <akpm@linux-foundation.org>, <linmiaohe@huawei.com>,
	<nao.horiguchi@gmail.com>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v2 3/3] vfio/nvgrace-gpu: register device memory for poison handling
Date: Sat, 13 Dec 2025 04:47:08 +0000
Message-ID: <20251213044708.3610-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251213044708.3610-1-ankita@nvidia.com>
References: <20251213044708.3610-1-ankita@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004685:EE_|DS7PR12MB6310:EE_
X-MS-Office365-Filtering-Correlation-Id: 084ed4c3-398e-47c4-aebd-08de3a02b33a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sj3AJT2qC2dYPyAHmwCSp3h/SgRGzkN5TLtphMRN0kkibXUFFJSpshzLHGc9?=
 =?us-ascii?Q?Rrs1DCKORnhxiyjRu8lClDOaznr0ZdMKIanbSaZRULkDoXjvjDcUvxoff4jW?=
 =?us-ascii?Q?lFzyzHcWxvNgnUD9l8oMyXGV43mIszyzx/7IwC+WNE1OTjHV425d15xe6pdU?=
 =?us-ascii?Q?Bp7apPMvHAvfZ4VH7dunBI2U8A3nNLtm1DnogyoeL61fhedGJW6RoIy2+iNV?=
 =?us-ascii?Q?hl+EC9QBFG7mMNOQfaVuq/N/KamlV8ajVNqqByKHoBPiL9FaWUalzCs6l4rR?=
 =?us-ascii?Q?2NbbcuL/pGYZq/ZeI5/B3Vo5+ybTRGUc0gSfW06QpDQqhQgZaRuDeYpn5/Cy?=
 =?us-ascii?Q?YC2hbm8JcWfxeaZbrX77LMTus/qvPNqRv0iH8I00M0UwThF1d+mK9kWIC+nf?=
 =?us-ascii?Q?Wqnp0mOaMfRee33EoDp/PFCg7Cg+ppsmpVxBWzn75K75VvCMqyGcZlFn5Py0?=
 =?us-ascii?Q?5rwyN2JtGMTgENVGW0GPj+qoMBumbOo1RNC0SlcxzTxYcSR+L6dJSEWIQeRS?=
 =?us-ascii?Q?oXL7PQnJ2VnH1VbuhJIVRfj9fP9+XxXGGig8P5FeBqWRWjFWUVO+1sguVWgM?=
 =?us-ascii?Q?GXQrRcnEBZJ1QlOSJ+1deHeT/u5LBiDWwWTKQtf/EvIedji9lYZq1RSm++DI?=
 =?us-ascii?Q?cGLcHmmj31n28YPruUSxXUbtXOPYqXPySbUdhOJRI9w67HOwCkM9tFjOvOYO?=
 =?us-ascii?Q?WrANOUTBRfZdQ0lPcgKlVkZ09jVEDTLcHgJFkq5t7FkWdbGlt72FR0Fqhxad?=
 =?us-ascii?Q?yOpkbKupdCEx9R7gjzCe2wsM1ZOf7SMAyn0Fy0IDG1xJNOXvOKcGJeHT/VLI?=
 =?us-ascii?Q?MA9LBtN7JebvZycbExPlTFfpQLm8PeJMW5YO2UzE5F+lqSxJWiB3eYG72WAS?=
 =?us-ascii?Q?pNFRAX884rUrxKuEv6QYo8G4dIeXwBJJzo3RYgq7Eo/IhnvsnBHRev4P6tOk?=
 =?us-ascii?Q?uC9RgWloKopfc7fNDVXmxnAEgghVctE9aYRiagovfWijtKoRWeZ8KNBDIlfT?=
 =?us-ascii?Q?Fl/xCnCAiFDsjXeNznTJTATXbiFfwv4Rhws/64VJ94fX0Kvwc3ABwaK9ScBC?=
 =?us-ascii?Q?JyC2b12pumKuwuiqdFhhBZTKB7jH7VVHGJbAxuCcQYzJ5Y4WE+e0/luTnDcH?=
 =?us-ascii?Q?wEeRCr2V1QU4CnjIYH+PlwSgUq23DzgTSF07pb9T1ZUcSnZ5qVhK5aHBuA46?=
 =?us-ascii?Q?9KTX09sMel09R9L7bOVGlWr8MFfb+WdZnDBn4sZzfSgiFmhOW5WmfEIpdzex?=
 =?us-ascii?Q?alzfOqI+3hT8meHbM6FUNdq3uxig3xOeQn4TbSn4pGxFDDX0fHJ9p+6wHqSS?=
 =?us-ascii?Q?HP+JE5uVfLIefHdwCymjdp6A9oKZvoyb4uiwsCG+NDJTwxuVEVsziLFLwqfs?=
 =?us-ascii?Q?gDHp1hTv2UWg9tMrU6rIGQf+kUo6aejJyMbF0HSzkui/zn/wJQmYuCi3FSO8?=
 =?us-ascii?Q?dV169L/WX3cQ0cELDg03ovsXpfOu+UYwuqfB3iJtpeS651BAD3EZbnE+v+Sd?=
 =?us-ascii?Q?dOXFKvsZbHq5UZwOuP+xhE5ZLUeSbOztZaIArTsOrbi7ege8JapWK9SBCUJM?=
 =?us-ascii?Q?NeJoEjrOmeU0mYTHNvYkL2pkTxxsuORwG3iTRrLu?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2025 04:47:20.2820
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 084ed4c3-398e-47c4-aebd-08de3a02b33a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004685.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6310
X-Stat-Signature: 9aaxczcrbub1fc5pa74xxqxtdcp5gqpa
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 18E3440003
X-HE-Tag: 1765601244-717871
X-HE-Meta: U2FsdGVkX19GzUPSToOSMVEEnrt9uEXaag/f33C+rtkUHHYcnWtvapRHGiCvG/wJjvzI7v/oSDxkiR+b2zw0aJ3WxvN2budQL9Vm8TZ5yFv/pziXSdbHH+ptPwHgkoNPRefxgBZKFdXZmpXZfMDcWzCV0dhDiGgPtnSwbgbSc7IwpJ1qosOo9NBmUzi4J2zpAqnfQfiqu5pTFm13cy6hhAfG9hsOP1Qqy63YPzoiNjgbURkACk+NUth8B8qBUHzb6/snwQtuPBmqDhALzGzrAQfZGfkaBeqeFiMTwFu1iWx6hrLBPuM4sqHJlQ693ztB+iAci01l1MrIBl6NaoDrgrh1T3VepCwnHLGsXpGMkgvv8K6AwzBJFttXBCkqMxluLwr1ut/PYnC9kRxQ7iY2zY3O+cYCpt14vAQIwnIyXO5CDXC3PZNsY9YVYwOAHVG+0Kf5YiSZbyDlNuiUQmEqBUMzJjfGzuhakXOIyVHar23MtKD8D6jkrVM3mCG+CwluNF7sqp02Q+P6kq7A/se7SsvOntEkC5aMRsj1mmhULm+rGM7xxPOmU67qRCWENkMx17yYpOiQGeuvHYklE3MPqDebm4HChzofEQpbbx/cOPIOluFZMlANhEPV0dCHnTma6bxbrVw5R9ALk4G6Rk58BOaHQfOlwMRxQsOcbF9d7Ih7rNrNnrzWFf2XYeSFZalLZ9iYENSS/5gmSkk5x/znXisztHdZrSMqyyu08oyHfbjuaQP1sv0aCFs/HnVrwCxMIHelUw0hrLUywJUbxcF5HjmPoTHE7UjTg+W4cH56kYHAan3e2O81xY4kRyyduH4HYL5CvSm7CeM4U+GAoSHbwz075bTX8acOYOar1Y8Rvb6sZqmgEETuf+AOBooOSU5T3kLo+GLABZgKc+M+ICCwocLt1Zce1PSFs4kGTjKVJ44cy8dq5kwBNgdXZNJV9n3KIiKrWuNJJJ9aOhF3iD+
 psaTsBca
 JnuuZyE8huyRmmtXcCKECBAVYdXHfGXYbHnibX6JnzO7HQppOxbhvsSkwjsnw9xMpD40qkHAFsfe+dGj9LuXBhFSGHFhJTCgi8nU4sWF9TT69Uq8DvMYQSmGN9gsCg/c5wAfzKCh1ckEp7nf5hYzjIqOX53aWdKYyMZhR6PFDUG+8rrrk7J+4XQt8MQe3wvwCpvRR+vmTFEuDF4AA6h5wbTC9Am/jl1wUYUb6QT2hrv1QojK+HwVcpDbL16ioDv9+pv/2RDFglhO6O2jVeaEewtddlfvKLfLqb+3JbeXX9FgnDuFQqBRCq28IgveCO9SRYSJddrM7RoVsb4hOmZjxZQ8cCw6Ky7DK0A2VzZZoomBPxfHL7nejdMbhWrH8w0COc8wPEbEkMS8qNtSru1y8SG7Hz9a3uPUQyVyxY2dlOSacpiTOWrcvN7u6cF0UA5eRyzC4iqQaJ8WeGMwPOmtq+Ez/4CT6SykCwI1x/4OqVklvQqM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ankit Agrawal <ankita@nvidia.com>

The nvgrace-gpu module [1] maps the device memory to the user VA (Qemu)
without adding the memory to the kernel. The device memory pages are PFNMAP
and not backed by struct page. The module can thus utilize the MM's PFNMAP
memory_failure mechanism that handles ECC/poison on regions with no struct
pages.

The kernel MM code exposes register/unregister APIs allowing modules to
register the device memory for memory_failure handling. Make nvgrace-gpu
register the GPU memory with the MM on open.

The module registers its memory region, the address_space with the
kernel MM for ECC handling and implements a callback function to convert
the PFN to the file page offset. The callback functions checks if the
PFN belongs to the device memory region and is also contained in the
VMA range, an error is returned otherwise.

Link: https://lore.kernel.org/all/20240220115055.23546-1-ankita@nvidia.com/ [1]

Suggested-by: Alex Williamson <alex@shazbot.org>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 116 +++++++++++++++++++++++++++-
 1 file changed, 112 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 84d142a47ec6..91b4a3a135cf 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -9,6 +9,7 @@
 #include <linux/jiffies.h>
 #include <linux/pci-p2pdma.h>
 #include <linux/pm_runtime.h>
+#include <linux/memory-failure.h>
 
 /*
  * The device memory usable to the workloads running in the VM is cached
@@ -49,6 +50,7 @@ struct mem_region {
 		void *memaddr;
 		void __iomem *ioaddr;
 	};                      /* Base virtual address of the region */
+	struct pfn_address_space pfn_address_space;
 };
 
 struct nvgrace_gpu_pci_core_device {
@@ -88,6 +90,83 @@ nvgrace_gpu_memregion(int index,
 	return NULL;
 }
 
+static int pfn_memregion_offset(struct nvgrace_gpu_pci_core_device *nvdev,
+				unsigned int index,
+				unsigned long pfn,
+				pgoff_t *pfn_offset_in_region)
+{
+	struct mem_region *region;
+	unsigned long start_pfn, num_pages;
+
+	region = nvgrace_gpu_memregion(index, nvdev);
+	if (!region)
+		return -EINVAL;
+
+	start_pfn = PHYS_PFN(region->memphys);
+	num_pages = region->memlength >> PAGE_SHIFT;
+
+	if (pfn < start_pfn || pfn >= start_pfn + num_pages)
+		return -EFAULT;
+
+	*pfn_offset_in_region = pfn - start_pfn;
+
+	return 0;
+}
+
+static inline
+struct nvgrace_gpu_pci_core_device *vma_to_nvdev(struct vm_area_struct *vma);
+
+static int nvgrace_gpu_pfn_to_vma_pgoff(struct vm_area_struct *vma,
+					unsigned long pfn,
+					pgoff_t *pgoff)
+{
+	struct nvgrace_gpu_pci_core_device *nvdev;
+	unsigned int index =
+		vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+	pgoff_t vma_offset_in_region = vma->vm_pgoff &
+		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+	pgoff_t pfn_offset_in_region;
+	int ret;
+
+	nvdev = vma_to_nvdev(vma);
+	if (!nvdev)
+		return -ENOENT;
+
+	ret = pfn_memregion_offset(nvdev, index, pfn, &pfn_offset_in_region);
+	if (ret)
+		return ret;
+
+	/* Ensure PFN is not before VMA's start within the region */
+	if (pfn_offset_in_region < vma_offset_in_region)
+		return -EFAULT;
+
+	/* Calculate offset from VMA start */
+	*pgoff = vma->vm_pgoff +
+		 (pfn_offset_in_region - vma_offset_in_region);
+
+	return 0;
+}
+
+static int
+nvgrace_gpu_vfio_pci_register_pfn_range(struct vfio_device *core_vdev,
+					struct mem_region *region)
+{
+	int ret;
+	unsigned long pfn, nr_pages;
+
+	pfn = PHYS_PFN(region->memphys);
+	nr_pages = region->memlength >> PAGE_SHIFT;
+
+	region->pfn_address_space.node.start = pfn;
+	region->pfn_address_space.node.last = pfn + nr_pages - 1;
+	region->pfn_address_space.mapping = core_vdev->inode->i_mapping;
+	region->pfn_address_space.pfn_to_vma_pgoff = nvgrace_gpu_pfn_to_vma_pgoff;
+
+	ret = register_pfn_address_space(&region->pfn_address_space);
+
+	return ret;
+}
+
 static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
@@ -114,14 +193,28 @@ static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
 	 * memory mapping.
 	 */
 	ret = vfio_pci_core_setup_barmap(vdev, 0);
-	if (ret) {
-		vfio_pci_core_disable(vdev);
-		return ret;
+	if (ret)
+		goto error_exit;
+
+	if (nvdev->resmem.memlength) {
+		ret = nvgrace_gpu_vfio_pci_register_pfn_range(core_vdev, &nvdev->resmem);
+		if (ret && ret != -EOPNOTSUPP)
+			goto error_exit;
 	}
 
-	vfio_pci_core_finish_enable(vdev);
+	ret = nvgrace_gpu_vfio_pci_register_pfn_range(core_vdev, &nvdev->usemem);
+	if (ret && ret != -EOPNOTSUPP)
+		goto register_mem_failed;
 
+	vfio_pci_core_finish_enable(vdev);
 	return 0;
+
+register_mem_failed:
+	if (nvdev->resmem.memlength)
+		unregister_pfn_address_space(&nvdev->resmem.pfn_address_space);
+error_exit:
+	vfio_pci_core_disable(vdev);
+	return ret;
 }
 
 static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
@@ -130,6 +223,11 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
 		container_of(core_vdev, struct nvgrace_gpu_pci_core_device,
 			     core_device.vdev);
 
+	if (nvdev->resmem.memlength)
+		unregister_pfn_address_space(&nvdev->resmem.pfn_address_space);
+
+	unregister_pfn_address_space(&nvdev->usemem.pfn_address_space);
+
 	/* Unmap the mapping to the device memory cached region */
 	if (nvdev->usemem.memaddr) {
 		memunmap(nvdev->usemem.memaddr);
@@ -247,6 +345,16 @@ static const struct vm_operations_struct nvgrace_gpu_vfio_pci_mmap_ops = {
 #endif
 };
 
+static inline
+struct nvgrace_gpu_pci_core_device *vma_to_nvdev(struct vm_area_struct *vma)
+{
+	/* Check if this VMA belongs to us */
+	if (vma->vm_ops != &nvgrace_gpu_vfio_pci_mmap_ops)
+		return NULL;
+
+	return vma->vm_private_data;
+}
+
 static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 			    struct vm_area_struct *vma)
 {
-- 
2.34.1


