Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35280CCFA1E
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 07:30:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E7348E000B; Wed, 12 Nov 2025 02:30:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8976B8E0002; Wed, 12 Nov 2025 02:30:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ADAD8E000B; Wed, 12 Nov 2025 02:30:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 690848E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:30:25 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3A4E4B91C2
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:30:25 +0000 (UTC)
X-FDA: 84101132010.02.56DE4D0
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011066.outbound.protection.outlook.com [40.93.194.66])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2E4DDA000C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:30:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=l4fy3y7V;
	spf=pass (imf15.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.93.194.66 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762932622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pf2ELnFyESlPrHFJ8OdaJqsUv1coTV9WKEJXHjvGbmc=;
	b=KnUL5Bn0pE6N9nOF1SyGAcC8j0IsNwpy4UcD84zxsnYX7sCjLbnsl22kF6NK1ENixhkp+O
	6XHfPmTAtoUKB7Ym7aIL0Ab3n6qugWlfDpaJcFL+wgxfUJUjwjy4tpv7ietbUcnVqG76nC
	xNPykBSgQ/nZSZdsAUHZsmnqQPRA5JA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762932622; a=rsa-sha256;
	cv=pass;
	b=JrOmLGxiZER9mkYirUXHqyAfhVa2nJSJLxiMFMXkww+qWy8csEIiEf3MwTtlDfe9HeNWwP
	61rjNoM20JfnhteVKuXkuI5TxPUvQT86e5kMu5yBfDjmn6kELlpva0OWI92t/PT5noMa2n
	60+kRvE/L6VCzCHRpRbJZzORi4iBx/8=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=l4fy3y7V;
	spf=pass (imf15.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.93.194.66 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qxn3DEsMRmFUJ8di12yiD1UHdwfF1mSDcgt2D1dGruM0JpO8pWf3GcSlQrBxAAhZD/wRsmdlHfVhltyiVOUbTihZfWFcZig1h8GmpTf+hbpzsshYOy26mCtNLi5/TBnyIKJytxk/AmG6S1aCWzmxCt8Cy/IOkUUE9OLsPqoo5wdqtlXaOv6ofUWRmVwvcBqrzBEeJEWuIC+tpg2PPZzM2F22NYxAfFn1tQx7NRVgyNnrNrZR4QhnKYzxM9oKE6y3CNUoZxlNoxR5DhMW4QBzedRhu5u5CaAXBUUHdNyEdldaBsSf/Ku0hmi9nrKmdtXAGYoQ6itsSPh8+Fyjh5sylQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pf2ELnFyESlPrHFJ8OdaJqsUv1coTV9WKEJXHjvGbmc=;
 b=T7YTyrq9Prv+8wuVbqymc7WYIr4IpzwieTXVNKEk+qtyd0xsl3eiEzYIl9UzYVRH8IUgN2GekrAUj7eOscnRpLjIUj1U7H1A2vYjMehEYi4mwsjchFYacu/2nOR+6rAOnx9iD8Ym9cPPA0Ua/4DH3BYsgvlA3+2lmgpVqLWIWUCNJdaDJih5x1Dfk3Ni/hgzbojfpAoSbg8zrMMJPRruO/3Fk2tbtOdkyI1i3agfl42dt/eu55ZoG4YDNzqlnUUtooxKURIs7+dCa9J9u9tVIFjQvvcZuFGArAYXNJ9fcDllNce8EpysR4ZuOPeBrHE60f921KN7I1pQDNJcLvEgng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=collabora.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pf2ELnFyESlPrHFJ8OdaJqsUv1coTV9WKEJXHjvGbmc=;
 b=l4fy3y7V0ujS4c/w1LsxzBr4zVPdnzz+GfO75hprocLtsk2KC+DX+r0+cbCpG4FE4m/jauXVBVwVbjOutpN6bq2W6NTT2Ts3BQ/3GvqkJ723eBPHxa42t7JvPCuTD95gMu7b4W+rLEMYW/GWfd4Sv2gfZn1mxgkFSTkn1n/0hXA=
Received: from CH2PR07CA0049.namprd07.prod.outlook.com (2603:10b6:610:5b::23)
 by CH3PR12MB7667.namprd12.prod.outlook.com (2603:10b6:610:14f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Wed, 12 Nov
 2025 07:30:16 +0000
Received: from CH2PEPF0000013E.namprd02.prod.outlook.com
 (2603:10b6:610:5b:cafe::95) by CH2PR07CA0049.outlook.office365.com
 (2603:10b6:610:5b::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.15 via Frontend Transport; Wed,
 12 Nov 2025 07:30:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000013E.mail.protection.outlook.com (10.167.244.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Wed, 12 Nov 2025 07:30:16 +0000
Received: from honglei-remote.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 11 Nov
 2025 23:30:01 -0800
From: Honglei Huang <honglei1.huang@amd.com>
To: <Felix.Kuehling@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <Ray.Huang@amd.com>
CC: <dmitry.osipenko@collabora.com>, <Xinhui.Pan@amd.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <akpm@linux-foundation.org>, <honghuang@amd.com>,
	Honglei Huang <Honglei1.Huang@amd.com>
Subject: [PATCH 3/5] drm/amdkfd: Add AMDKFD_IOC_SVM_RANGES ioctl command
Date: Wed, 12 Nov 2025 15:29:08 +0800
Message-ID: <20251112072910.3716944-4-honglei1.huang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251112072910.3716944-1-honglei1.huang@amd.com>
References: <20251112072910.3716944-1-honglei1.huang@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013E:EE_|CH3PR12MB7667:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e18423d-4356-47b6-6e5e-08de21bd536e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G6PplAgkXJeRyMne9prz6gQflNPZawFGvLoTIRpQOWyOLKKpGit7cEoMMPDW?=
 =?us-ascii?Q?5N9/3TtVMkhdhvAjatCWdQzuVF6AksaaibaQZXwPKB7Ds0EtUKamBlExl3Jy?=
 =?us-ascii?Q?zUZmunB4jkZSMRa4zDB2fgIMdfnsWv4eHMyr88kc6seyoEO2xH5pQYaPGXhR?=
 =?us-ascii?Q?ldNxXF8b+wty58M9ndUMRCDlJxJeFF/WWhEM9GmshAilg4vW/qTFwRt0hfCL?=
 =?us-ascii?Q?ccAw1yJEN0MNRzg0pkvn3wU0DrQDWzprA4qC1s2weKLG1xQvQfsW3YQq/iiw?=
 =?us-ascii?Q?EN0uMuCh2598EMxOTcZyyE/pJ8NOpTRv8R/tcGsISMLdMFvTXAu0mSFQ7DQa?=
 =?us-ascii?Q?/d4bSjGH4Xw36ezw7ChLdTCWZMSoEEuvj9EC5oeZACFYiBTXDNn89cAwLgKr?=
 =?us-ascii?Q?yXtpfeTd9mySp8gbZuIuC1/z/m/lI4dmlr3VnLugbfwwXOF8/rTyY9ZwNdg4?=
 =?us-ascii?Q?2Q1S2XAlMYzbptybuFblFfOwoa8VEukrZLx/b5o5T00iYEFZyK1esJNBMN3U?=
 =?us-ascii?Q?eh5Zij08+VbqJV7yegG+phJCr7LRkIZA+OHJu+tMkfkobFpw9jlS9Ngdc3qT?=
 =?us-ascii?Q?GzS8VfJMcAi1Wz5PYe8uZzaXg8qPXwfg/aQPeQMi45lhBbuLMBShjLGV6hbq?=
 =?us-ascii?Q?K2fQlm+zAUrJj13oivsDvBLoyl+MqQYZwKm83uYNQvcQthQr6xHs50ceOJ9M?=
 =?us-ascii?Q?u7N8JkaI6VrGnZyWnw1m9UcB35Ye1iG9/QjNf4SaFE1+9+GfG1zkxfOq1NPQ?=
 =?us-ascii?Q?RzE+MaK4aUD49x6kU/Tizpgy2NZcp1TG8dfAlJ3bx+Gs8j+1fbU9bRaGZV6T?=
 =?us-ascii?Q?+RJSS+t0d90FWKpREX+AWJWiitjBHEETfe7SHKeT8+Hjz9TtVIsT9A5JyAtM?=
 =?us-ascii?Q?eAgJW6SUkP2ifuLj0ZPIO4g/YWVfXpOBHZjsWrQlbLSYTmBQjdt1XET+TNUa?=
 =?us-ascii?Q?Y5kVOcSX/3Bc5dFnuz1rbItbG5Viwn1HyUb6fj3XRnjr6KOVwZDx+XnckTW5?=
 =?us-ascii?Q?TMtMqvWCQtVenl9WyINQHFGOWlDU+LFfcWp9y5aRslY4+XECBFhUXmPBQSaQ?=
 =?us-ascii?Q?xwWrNS7gZe7XcKy2tjpl/cYfH2NzokAUG2PYCL9yXeVLa8FvJV1/2LYYY0Wr?=
 =?us-ascii?Q?3fs+q7X+dQiXrSbxoAWg+aTVyHYboXutc2oLzA14G1rs9QLr+vqIgAPjq13R?=
 =?us-ascii?Q?gQtYZHYSlqhIj3dNOqHns3GO9HbXyLhkOBtifeD6/4Rq/6BWcvezSzE0IAHI?=
 =?us-ascii?Q?HoD0J3d1L1ds3ypzmIGJE1lmCVVMRzQKh5PNx93X2ebzDLeWvsF3hvNKB9QG?=
 =?us-ascii?Q?ZHAxVqpV1zF9Us//wdEGjtcdyqVusnS7gglLyvkXK9GGY2QlqkTg4E3zqpul?=
 =?us-ascii?Q?nS1fg2vRd+cTT3d4BRYVGGDOlBYKFYX4mQQxteDX+50AiYCjMOR8BtzPlE0i?=
 =?us-ascii?Q?L/LphLRBeNEwKqXg63KFhLFv+YvsC/u4AXilKJz/oz/S4bbnapro5AvGlnJ+?=
 =?us-ascii?Q?VmV3yDFhwH1wdFo99gC+EWWC/HpoGUFSfltuz2K95+tINE5zoHofEKmMQf+y?=
 =?us-ascii?Q?1qB45VpwyS6Jd/2ango=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 07:30:16.4936
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e18423d-4356-47b6-6e5e-08de21bd536e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7667
X-Stat-Signature: o9ko44t5n69xhxig9px9d1j7utudnz79
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E4DDA000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1762932621-802073
X-HE-Meta: U2FsdGVkX1/H5U9Rp6O5I9ZKtwXT+Cd1lxejUTPNVLSopy3PkHvHCcoqGMUhS40DY91tr+n9kiFGewTrqiQqClX8yynnm0UNWZ/Kn32drNgB4dwgV5KXar0FF+tWSqYryFDukc3qUYVTLu1LeLaqXWgVBc3dfCYk1I3IrVyQlj4mP6flt1eZWHf7rn8PWOYyufwCVbPXh+ya2qWQHRW4ieTdnxIGNU4p1lDxY8AiB/Lydp6kl4sDJW3HSwBOBgkLY/Ph3bvF99fWR09mmap9/xIDD3E0oxBRpyp++a/4lpBaCCpj22Km4kEmjZYFns6tAfYrCffIeUkjNFaQh3jwReXs0CDoRcEsCP7KzT04pnQjCFIqXOxgxLXjxuYz1IvZQzL392nEddhjeirOiDfrg1p/cwz9ZjaKINgUchT9nNLBab5jbCA8MQ5DGnrHllUL04DA1VnIQHZu5lWVlqX9mL12IMnzMOEosXe5EmRl5nxPAze/+yqRN8/vr0fSy8DTJpnQ1+BajzIwLtexsj+E5QzgVVtE1URkN03qYTT4gQtPa1ZvTFQ8BNaeBOHcUdmh5T8AFccRB+aYDp2Hv2HZ8eV8ce+Pm0wtdPQak++ZgqM+fyq5WQ3xjUoPE7Td16Cnjo9qw0ZXaHWUz0PF8lHMmiBxGkZzg4PhHWqZzUdqlMxp4UXw1L145VA04UEbelfjH2zipue/v7cKju6F929eNfwDmrHU+kYvvuxqJ870b8pGltsVwK0i5+6jFfJ+1XQeub0oDZMQ0ThPsiRxiifRPcXmUuR0ev+5SRNhV6jH9onSA7ERY3yfLbx3UVreDc3bHXrjg4z9CfiWprlbwtUMXfreYw0mbHvwrHMpxqtURXJ9bBlqgUrPlM16SasrN/+l7CpmV2HTbspaZPZhNOs9ay3M3uD2hxrn9pMBInGAI3MxWxr1XAfVsWW1APxaXZYpCqMXyFyV4OfTp3oT2u0
 SBL91gei
 nhZWb+uT4TzR2A52ET6lHz4uDBdYk8x2iugQNsD0uaqdxvEkuiwZgpxiqk4SN5yvTQ2I+2i1XZqrsY/9E9Cu1jQvUAajTmOFSlDbpWF5wmOBBiY+WKs8kRdFLYC26/UzrsBpJHirKqymbF1s0nTUASfNRct5o5gzK0qf9IRTL2ETTKByKyiALxBgHk1yQ9BPoORA7BxLdCK9IzYb56WT5fbnI+K77DsIRQiQTGlVaKSsZVs6LKWacKxB04uPnP1GPLr3m2MwdgaXBAGN7bcwoADLiQE6CkKGyBJju4V1vT4O9CUpJ/xaDqzKxc2/6vm3RkWhcI1NVem3kpIEncvKKq77/q3iE1iWmQrxCu948NbWN8IKwxy2BlfI5LvN0UPmxGsErnp5D1PVW4Ei+JyqecO/42xH+qbzmH6j7ZpEObDon5GvPc3ZBvQKP2O/6rzEbmON2Cju0v4Qh89GdrOcbL7885AhMdRTcafoi0RoELKp3m1JWnWQTxZUrmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Honglei Huang <Honglei1.Huang@amd.com>

Define a new ioctl command AMDKFD_IOC_SVM_RANGES (0x27) to support
batch registration of multiple SVM ranges. Update AMDKFD_COMMAND_END
from 0x27 to 0x28 accordingly.

This ioctl provides a more efficient interface for userspace to
register multiple non-contiguous memory ranges with the same set
of SVM attributes in a single system call, reducing context switching
overhead compared to multiple AMDKFD_IOC_SVM calls.

Signed-off-by: Honglei Huang <Honglei1.Huang@amd.com>
---
 include/uapi/linux/kfd_ioctl.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/kfd_ioctl.h b/include/uapi/linux/kfd_ioctl.h
index d782bda1d2ca..c5f9595ef30d 100644
--- a/include/uapi/linux/kfd_ioctl.h
+++ b/include/uapi/linux/kfd_ioctl.h
@@ -663,7 +663,6 @@ enum kfd_mmio_remap {
 #define KFD_IOCTL_SVM_FLAG_GPU_ALWAYS_MAPPED   0x00000040
 /* Fine grained coherency between all devices using device-scope atomics */
 #define KFD_IOCTL_SVM_FLAG_EXT_COHERENT        0x00000080
-
 /**
  * kfd_ioctl_svm_op - SVM ioctl operations
  *
@@ -1622,7 +1621,10 @@ struct kfd_ioctl_dbg_trap_args {
 #define AMDKFD_IOC_DBG_TRAP			\
 		AMDKFD_IOWR(0x26, struct kfd_ioctl_dbg_trap_args)
 
+#define AMDKFD_IOC_SVM_RANGES		\
+		AMDKFD_IOWR(0x27, struct kfd_ioctl_svm_ranges_args)
+
 #define AMDKFD_COMMAND_START		0x01
-#define AMDKFD_COMMAND_END		0x27
+#define AMDKFD_COMMAND_END		0x28
 
 #endif
-- 
2.34.1


