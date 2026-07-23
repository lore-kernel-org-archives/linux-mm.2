Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40435C531F7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 16:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E21556B007B; Thu, 23 Jul 2026 12:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAAFC6B0088; Thu, 23 Jul 2026 12:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4DF66B008C; Thu, 23 Jul 2026 12:22:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 814926B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 12:22:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 09B4914050D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:22:23 +0000 (UTC)
X-FDA: 85020558966.24.998792A
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012038.outbound.protection.outlook.com [40.93.195.38])
	by imf26.hostedemail.com (Postfix) with ESMTP id C932E140009
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:22:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HQULGPUh;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of nirmoyd@nvidia.com designates 40.93.195.38 as permitted sender) smtp.mailfrom=nirmoyd@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784823740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WNQ9ZcEoUWNutCszNKjo7DsNDU/zqafN8r6FNP/UYI4=;
	b=Lav+jIesDKcmYf9Sv5oM9bixH6y3wKQgbQCiRrwkdhb2raZu8Tkjk+UenDWDP42xHbkBm1
	m/SYCkr2wNobKPkrzEB604r5Vc+rQcwkNTWPRWhE38TgkqqCBIXLImLworRSOl03q49LA+
	FYVDtmoMjeySB7pmFV/tXAcH0mWfVaI=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HQULGPUh;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of nirmoyd@nvidia.com designates 40.93.195.38 as permitted sender) smtp.mailfrom=nirmoyd@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784823740;
	b=1FICPinGJ/yc0szhy052Ik+ykNNGy4QeIYOolMol4XwuqY1ov14StmAiQjG7HOm98oeSrX
	noNYo/HcYpN6N6OXxhzTMPFkV/cQGyvayaXoju2DbYrjTRJYxV/YomGxlTv9MN7vbW9a4h
	xJ2G/pI8oLhW5A1NoFlYOcBBTegbVdc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sI0xNo5SD/ZeXNUZo1L+vIizoIikKwYmRWgKD9HDxbnkv5NsBcVlYZHltomJtOlNmplxQBVL7YQsXkRCyk7bTMOl62yclaz7PlJ2YcWy+09+vX9gOSTJl7tW/Dca0WlV4TYBha3pxgsF6e4bjJh/4TDDZkq29OJVLoBaDbvEKJN0aRV6BAbPM0BPo4zosOoVcWnA55zeq9+QNB8si8Cd3Pa2q/zf37cr1SiGInm0SK9y5vA3hSvndEtVFMlHzRTap4NmXiWZpjN4RQ0lhj3U1G6NJNlyloIQR1Mp0kKthsU5QE70OqwKni+LWDij6MPsQ91bzgPrcbjYVQsyO6CnoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WNQ9ZcEoUWNutCszNKjo7DsNDU/zqafN8r6FNP/UYI4=;
 b=uAKIx2yGugswy3ilmVf2s9e39nn/SUMQWBlevk4CdgBJSZwawHlhhe5esgS1eTUkaVf5EJiSbYOkhPculM1DNoWxrBBOJlCRmrdDcXKFdTx2v30VVnINUAqTjDcgpjt9jtXNihPhfPZrdsvPob9ErR+MUBo/MXEqHa9YaHnQTFE3fH4IsQrwG6moQT9b5SycKLUcPjxD8DYSCcjDq4Pnwj4bpDeadRPnyof/vXzCqXXVY2SpAgKtLTTkTH/b38rhfn8Fr8nY/36CF/pEYGFFIU6zna8GqNpnLSnbZRp0bXmvzmUaORBcuSKWnM8nD1Dgr0b4AnmLsvWXmrSfdO9ehQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=efficios.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WNQ9ZcEoUWNutCszNKjo7DsNDU/zqafN8r6FNP/UYI4=;
 b=HQULGPUhnR67WVzhO7DlrtEtqQCLSUsSdvWC2tN389ZOOKKCc5u7BRMMT8ENCXKT3bkcNKvL7LJU45TqC7Kh8PIP/QPw9BPmnAt2mofvCBqYQa5wPuPM1yAzc90CcDgrCSs+DPPThUuccwPZzLqEfERDP+uDagFDnK5703YlTGttzHYeQjL2clEEtzDnwIIXLo0Z0hdEU0BNYh8yXHiM8aiLMRQ/O5mRbPsm5XKZ5YoWV2S0A6IJl5aEj8FpfT4ASF2aVkGDjBOuel5+qGHyK9sv9HqQ+KEiyOMKHNnue9ObOUGDvMW+BAAwG4oxtXmXVeYwPonNoPAeyLZO8NMVHA==
Received: from BN0PR04CA0127.namprd04.prod.outlook.com (2603:10b6:408:ed::12)
 by BY5PR12MB4066.namprd12.prod.outlook.com (2603:10b6:a03:207::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 16:22:14 +0000
Received: from BL02EPF00021F6F.namprd02.prod.outlook.com
 (2603:10b6:408:ed:cafe::27) by BN0PR04CA0127.outlook.office365.com
 (2603:10b6:408:ed::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Thu,
 23 Jul 2026 16:22:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF00021F6F.mail.protection.outlook.com (10.167.249.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 16:22:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 23 Jul
 2026 09:21:48 -0700
Received: from 82875d6-lcedt.nvidia.com (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 23 Jul 2026 09:21:48 -0700
From: Nirmoy Das <nirmoyd@nvidia.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Nirmoy Das <nirmoyd@nvidia.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
	"Vlastimil Babka" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	"Suren Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	"Shakeel Butt" <shakeel.butt@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [RFC PATCH] mm: use precise current RSS for high-water accounting
Date: Thu, 23 Jul 2026 09:21:27 -0700
Message-ID: <20260723162133.877125-1-nirmoyd@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <bd3facf5-cc4e-4fa3-95cf-0f4aa926ae23@efficios.com>
References: <20260723134158.1473841-1-nirmoyd@nvidia.com>  <bd3facf5-cc4e-4fa3-95cf-0f4aa926ae23@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6F:EE_|BY5PR12MB4066:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e131106-37e0-4436-31ff-08dee8d68d75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|376014|7416014|1800799024|13003099007|10067099003|4143699003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	flJb0cr9lhC3f1oIx0Tfw8IZpM83arRIDwUm58ufdkgSSzbV/DePCaOkdpmVVQ6ArHxzmxy9lnw0lOTNTB4lJEEAG4abMjQ1L017A2I6DInHWEp3VZOsTUsVltBbDZa/L7ctyfmZ9aN2vG4nT2Vdz5Y+fPLs+RzXJOebDmJwKQHwmq2RfV8scrrEuiy6Ihh9EZz09EEHX/n4U0nG2Lig47Q45UzzDKazKz85nDaxvVGd2gTixPP/nLbF61ydrsUTWFFlpVJAAZTMA8msp5oTFAxquHuRCc4J8R8/PDCO0JAUPkf6yawi+ZApi34TQwhS30aAGRRIntOE5QQV8U9b1k/9yv1Kwr+31hG749wr9ouMC6BFdTJOX0uQCSoOUi+1WLvqki13ny5M4LCtTdY5JpBm65hpEXohEkAsri3QWHKCuny/J0t+WrblenQx3c3e8QD1Djhp3JrNR56DNA+bmxCVeEdKRrTz4tH6VYDQiy9GUfs/tMn6jW01c3RD7STqrCx917MooFYKOe0VHV6zz+JWwkf9bC1JersS6XrbOzA9wrziqzJW8skK9Wum86zvukGEJW2AQejZyyufqU7FzGWQQpR8Ounl+wxsjRnDVhtK9jqUohCXibP6AqgedgLMtv1lVhamkFlfeZtLeWgwYwstE8qOsHTuA+sut+iYOV727mwjNz+q4QSzeQuGjNIm/D9u4L+wPpnsl30M+DiIvw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(376014)(7416014)(1800799024)(13003099007)(10067099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kcg++CDdsz0ZG1a7xsyeY8eNrm0R0WseK8qNJPFB2LHmRZ2RZ7lbriVgYAvuYkagB1jjXXW60ctYNKLGFVzIwnTBX4uV/t2lDCsotNluij4fPDozOqRgVOv9uFodNrTEgpVvhUj+kt+nzWQfPFBYg6wXYTjVGcwSEjbJfzCT3kHKcXD8Hdqyvjpmw1bLmX/mJ2f0iBwzDTXVZsNg7IluKfMdpAplAg4YP7PAPlvFE7N3tXUPxzGfd/6yViYP5P6rRJZtZ7r14Sl/GZTN6gSLzrmtqD4XSQVcxqeBQSANKXv7t93Dp7XlCS05BpBh5SjSOWPbPVikZGBJ8r5Lsx3XtNkrIBZlYcfOChmowpW7QbymCtVgetld9HLiDhhYc5HMcUZYrhUpm9zwsH1dG5aXFFXw2wPVXBIfPSlHppkqFqCD/aYEI5d8XF4YAr7Ztd5p
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 16:22:12.5222
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e131106-37e0-4436-31ff-08dee8d68d75
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4066
X-Rspam-User: 
X-Rspamd-Queue-Id: C932E140009
X-Rspamd-Server: rspam01
X-Stat-Signature: tdatx419qc9yydxyecuzeomt8q3ruc3z
X-HE-Tag: 1784823739-465582
X-HE-Meta: U2FsdGVkX1/M1JQhFOPj1SeFh0wYYePvZT907QEjH0t2qoy1fNzpXTMYMAa/xkD0Y50xCHwjafjHYplkwGJnCwPKWCurVAmezM1ITyktb0rqVbvHAciKgLVj7ptY4znnqqcxMatHd0VlPKpZtZNmo0DpdrtYXvyQc0Gfv+/SWEG/00pisHrFPde7IoNrUH51HA9PiO0bsGSmyZ3+F2AjfLCDJwTg1YpHTuu3vbIgHyHo8NbIyd8LtWQX6QWZl5FKXaD/fDJii7DlgPqR1kgxH6EZ+RZ2Z9ApF4BsmBmlnvZNUhNvRCMtR40wVxWHg0gE+zeOl0X5UdjRdQKwa+SUtz6Z41qPou/0xgTghyOeKHFf2BI6IYQneI/OBsbghtGe7Gi6M4EM2PlR8Ea1eqnwouAxZfK2c2tqRxrZhhqNbjDG1HPv/CCwOSMc+wruipbQT4VamBDNRGkdhMxk/pwigbqvdpV3PaabPNQtWXGovmOOHTmc48+j5+PNWEB/7PmPNyx27lgjj04CnEwH9P23QRFbF1qFOLama5SivYIslrHqM8mZCJB4mREOXMIQrJK2ux2RNcnxcesR7j3F6LY7JvaFFIQcWk0TTZTUt6zgu0BL8QVZwi52MdlcaA/ph1D2/R6SNXvUTUB+hWPYFJQV1NzID+/ZPVvh5m20NKZ7uhviqgxCED9ryTRD6llEMmieCQL1SQ36AZVbf8cviE4cPimA1RY3S35IlU43hxJvJCkhmxzD8PW80ff3HJpJ96EPKBv64IZPwK6+meFCxksJPmz6MyaNPELHPzYNjkMOvNq3Foe/WatTg09dAWYXgQw3kowufgG/jdjmp5YZW7l1yXwMvAn0eVSmLUZdYRe3+qpcf+4U00OcXnf0pByjNRrvUTO/Wnu2BakIalWE8m1wxSV0BpJkq0wzGP9wI2XhnHarsWv/FVHMp8HpCmacXzO5jvO3xyXIgOUagCJB+O4
 VFyL5yBB
 iUsAgtEE6X3kXFPt0a7E1dwYPNiFBFBVAdA6L3tCizZEadF2PxQfSctgNHA1YnyrGGZb0q5LpulmPoNoYZV50aP3nxUzHm7iTsHMin+umDULiIH+6HOjUAR+YWn3KlmDtTPlcQ0T8s4huoo6Su1ji67N/2haRX+F2KHhrIu0yX3vkvWvYEyyiwFV+Co1qJTZH/P28Xynyle8O7Xk+iqFNKECngZfY+X9bQAR7vFKHoRckNL+SpLhcNHSTMJj/XS3nZOqRSRgUN+mVkUMaaNO9mDMcxx2ohl3/7//GrcCagWcs9mnlauPdAWRhiXfbQi+Im882OxPDQBQd7RyRyRtMxuxwgnbEORlHZnba5Pg059WMCbZkRegr8099TpFnmVURIsgODlBy1LSTVgGcXJjp9mkBEt9LTD2wGgXqTKFGIVQDtWbyxdKchPp5NL93v/b9xWuIVjLP61HYOVx6CAv9xgG+AXUOVI1uPfhdq/FtsW28WUxi5nXsZuhME2ZkrSKgr9cCgiQpwXM8UXpKYpaP+0qnCH1TZvNCBrEe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mathieu,=0D
=0D
On 2026-07-23 09:47, Mathieu Desnoyers wrote:=0D
> Did you compare this with my hierarchical percpu counters series ?=0D
>=0D
> https://lore.kernel.org/lkml/20260707131544.75906-1-mathieu.desnoyers@eff=
icios.com/=0D
>=0D
> I've sent it to Andrew two weeks ago but have not heard back from him=0D
> though. My series attack the same issue you are trying to solve without=0D
> increasing overhead when reading those counters.=0D
=0D
I tested the v20 series on a dual-socket system with 352 CPUs and=0D
64 KiB pages.=0D
=0D
On the v7.2-rc4 test kernel without the series, getrusage03 failed=0D
10/10:=0D
=0D
  TFAIL: child.children =3D 270336, expected 307200=0D
=0D
With v20, it also failed 10/10:=0D
=0D
  TFAIL: initial.children =3D 0, expected 102400=0D
  TFAIL: child.children =3D 262144, expected 307200=0D
=0D
In v20, get_mm_hiwater_rss() still calls get_mm_rss(), which uses an=0D
approximate counter read. The series did not help this test.=0D
=0D
Let me know if you want to me to try out something else.=0D
=0D
Thanks,=0D
Nirmoy=0D

