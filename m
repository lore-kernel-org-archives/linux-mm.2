Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 984DAD49C9E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 10:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1E46B009B; Fri, 30 Jan 2026 05:54:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09C426B009D; Fri, 30 Jan 2026 05:54:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E90176B009E; Fri, 30 Jan 2026 05:54:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D61086B009B
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 05:54:06 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC3BA1B1665
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:54:06 +0000 (UTC)
X-FDA: 84388320492.07.A2F11B2
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012013.outbound.protection.outlook.com [52.101.48.13])
	by imf17.hostedemail.com (Postfix) with ESMTP id E700140007
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:54:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YR2BHzyK;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.48.13 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769770444; a=rsa-sha256;
	cv=pass;
	b=nrqg5m5cSxCBImeEiTyAwwK7MIMqb02Oji8S79A4jngl10j63yw2fyp+UrjoEihjRnYrtP
	xMgpeX/G4YSjWESjHtbz72n2JXBMhqPMJIPlcEDYsUHFSObEHXiDIYtnuhoDz1SYU6Tge2
	P84kxtc31DQJ+B9acYyFmqD6zyBK3Q0=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YR2BHzyK;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.48.13 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769770444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rD54yMgfMF7FCT1Qj3EdRxemxK6Vha0iIOPny01QeRU=;
	b=prcbV0ebT53+/EiswFwuFjASSLQJqKGC0c9EUuMCRem+d51JhaBR52XttxsuAoPpR1SEH7
	6u3Kqz5TY0qwRUtPWzNOpFsbvEuDQ+t+g3XlJKKpU/0T8wBQQFXE7DKGVkWSy85JCM7Wo2
	DY7jgFM3605EsRgFtd1l9xO7kU39xSw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P1fcEyN9XcPuHcG6llxyhDDbdgis5s7sLdX+LxpKa8M9rwWyCxTnW+1Ctj060LnyCalce+Blq7/kAXwFkwxitEQ7sUxaOsGl+RK+gZTNbasDhxNNml4H91UhawXucM0zujq4YifkeYghR98qS9eTIVp7v3ZexBTVtnwmvNGGJAnMoVG+eh1B22VIaxCuTxjpj0+PcxP9XFaCI7r8nt8GlA97fId2DkcRypWj7pZBzA+EkD4ko7HGgE+2b/AL7s02wUbg/QQd3rlVvtuC7M9XBvIyhe1/z6Vj2QpHtn3Jh07M4PtPg0ZcARfGfb6fAZx/k66/8hqhvxQnQsM86R5Jlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rD54yMgfMF7FCT1Qj3EdRxemxK6Vha0iIOPny01QeRU=;
 b=f2uITA7aSlxA2ohNpDaq1ZA34G2uEXB5QByW2k6bKgHrg2QI06O7iRCmzPyP7Xd2MdpCFmJmZKcNuXXah6d3YvFfBSBFt14HJBI+J4lN1gycLv20kc/YxACx9MCMMpTenA2h2SMdDk/+0Q/M9U6sk6DTkHqGL910Fbk+cFWc9CULwKNgzkhkuErwRWxsY9u2Gx8sVNWGrbvyN0ekevCoDqPYV0XYoDtcA/Gn6mJt5n5WbRy7QLOIVIFz1nKrBEnuMglHNqK7Ac3WACN/lapqKJGUttf7AhwSYE7bzWGHrQu5HUQWa48fcac/8VQEGILX3l1xb8Rbvg6Rzi2DHxd75Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rD54yMgfMF7FCT1Qj3EdRxemxK6Vha0iIOPny01QeRU=;
 b=YR2BHzyKILEwnbpADqmI98rnDmPf/37uWrDB2+YQVXxu919a3Xgk8r2bpYPX7uJ4zsAB30+5/vOlPW5T6C4NBGlxfvrgNEaCZPCLxJjRwMq7GzonINt5AIKW6GOhu56B24n5cBlmQote35TT6rK1B2EsLxDt3419osN95jliP4MpwUIo/xeZiuwP9kBmZQ4oXo8faWpu+c7ckvXzNijf4vE/Kt7UaMMa1hmBclIHDMxrtHwHSSe4TGdpNaBq0XGhN7tx4CfMnTWmoO4ZXUH7B9tzS74riat5vW679uZs7J3m75nZS63hnRxcMx5wocEOOBx1KF5lv+PW9au6+EV/0Q==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 CYYPR12MB8730.namprd12.prod.outlook.com (2603:10b6:930:c1::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.11; Fri, 30 Jan 2026 10:51:16 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9564.013; Fri, 30 Jan 2026
 10:51:16 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com,
	jniethe@nvidia.com,
	jhubbard@nvidia.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au
Subject: [PATCH v4 04/13] mm/migrate_device: Add migrate PFN flag to track device private pages
Date: Fri, 30 Jan 2026 21:50:50 +1100
Message-Id: <20260130105059.51841-5-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260130105059.51841-1-jniethe@nvidia.com>
References: <20260130105059.51841-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0013.namprd10.prod.outlook.com
 (2603:10b6:a03:255::18) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|CYYPR12MB8730:EE_
X-MS-Office365-Filtering-Correlation-Id: 77353d46-d91d-4d65-f424-08de5fed7e59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/0pXWknLPHOknPKbSyXujEaju6xdCn2kWZ7nfx1Lqley4yl1HoRUTQzUyskN?=
 =?us-ascii?Q?0oIqPR0WeTI1vK7870cCR8kRfkxKvfBWnXmc7wnmX2UUZLIXTAN7n4IHZSY6?=
 =?us-ascii?Q?1q7mhMHS3HvYBfjgAPx413MktEkTwdDEZrH2qSWuDF/fbEam8yyxLtUeqcDr?=
 =?us-ascii?Q?Rw/PUPhzhEERfoS9ytcAFp44hR/3ZISjl6aiWfFsPMmlzrep5k7UhGvlmcFK?=
 =?us-ascii?Q?+NdsbBIzS7Hws+9YAgWkT6UC9j3detyHa8YspvnkPLWsabMfAuzf2dNufYJC?=
 =?us-ascii?Q?DOLpmz/zsPTqPjUgS72GulxM0/VPuSlEctCeOJqi5/ZzNWO6V2LUR7V5fw+k?=
 =?us-ascii?Q?NtLbXvUeD4Z2SUspbXxFWyT3St/IKTBnszGEMtTju6w446MB2QdkaCuSdegZ?=
 =?us-ascii?Q?MzDDju5HHJz+9MocJVU86cg7QZAhbjpZkhS1gpAAATZ6Le8coavjYizC1bml?=
 =?us-ascii?Q?fEtBMFeBr7i0220lajP8lvl4ROCw+ZdYEO2Q2IMLFzBIf8yfIjL825Q1jO5z?=
 =?us-ascii?Q?P2NYCH8pqd9rJzSDz8lH7gL63F2ZeN/8TZtTrF9IOrCivrPQSnwzvZoLjw/6?=
 =?us-ascii?Q?kYAji7fb5zRaETrLbT+wprkkuBzD23I3+PwjqwZHn9aaWB4WoOcte9T8qyOH?=
 =?us-ascii?Q?6Hq2Jib5bxZhm7yP+brxR1kwjTvhe14xdJK5I6jV+dnYOSmU3kH3cixaW0P2?=
 =?us-ascii?Q?EJIBY0VMX3uFQPblR0vz49Y6PtMokvJFUXa/oKay4eQnRNx1aG4rLkndUGU9?=
 =?us-ascii?Q?TMgiYo6vLyRp0aEXlq2qGh5ciUfUxtx7VuMK9pOpQkPWnVosYsQgsPr4i40q?=
 =?us-ascii?Q?sLAiwwVf6L4wSeOdTXOklScWVGg42pdoyZFMt7zN+W2m9OgTBDRA5k3+13BS?=
 =?us-ascii?Q?r4y/eflVPOG2UTousW+rlCCL8F6ldTi/OoctukSYjm1W2vmsBwWg0Y5Fv/f5?=
 =?us-ascii?Q?PxtrKiIT1njDcTNLTy85i+f71Ny6Yvu1YEv6PHp+j+ugfTSeE+XfBNSxfI5t?=
 =?us-ascii?Q?YV12BI615NP/a8qTADkeuo0wkiWGyiXX7ykf/TQNuX6oAYhSlQeePeLK1kWN?=
 =?us-ascii?Q?ptOmUUn4hUR7c+RFMNH4oFtw6Ekok7TLuCtlNwkgdJLqRSDnpp8+wejUcbuz?=
 =?us-ascii?Q?D2m9JSRfcXefydyMeP6ztLXy5+ToNjLF3QJEgT3T9F5tvbGJtJoqlnDfvdze?=
 =?us-ascii?Q?AtUplLIJLulNCqg77TcsDmuWKUnM3J9tm8OlTqgw3MImSabeOMNWJvaH/dLX?=
 =?us-ascii?Q?wjaAh2dpWZ2Nyg6IdY9RGFYD+zB8ErlG+GM34fTdcxa6I/GnKG4sGwtfxfii?=
 =?us-ascii?Q?+qc7s5vua6f69icLAwASOGURbY0aytcoqMX7KnfxIzcL0PN1rxFExpe3beFM?=
 =?us-ascii?Q?kTMLJpTBs95k2Z8nl5Nmsi1feDYCHQZ9iPd7zDfFUDHPCz8v2WImbuSfnAxP?=
 =?us-ascii?Q?hyxn6O4/F8Kz7r+JR0UyrjrPAuBSGzzQTdpWhtjJuQGHWx7ogE0RliVG46Qs?=
 =?us-ascii?Q?oGhjNtK4XuY80rnJB850fZLtWKLJ66Tehq2Jxj6tnivPuDtoEsjJF9uMi1qF?=
 =?us-ascii?Q?zqL+fBMW3CF5UYOJBeA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NRAeIAV3AS++TDdKssrhgTVVhd32RiNu/10ajbkmxbxTH/fPlxgq1IAo9IYZ?=
 =?us-ascii?Q?5OX/wHvbtnxMStZhSIvYlrOIxYZst146nf6hCyKrrUwn9jLS9Bnv+mtCcb5x?=
 =?us-ascii?Q?d996FbdGWq6DKe6JwWo4+0QaGUF85rnHTAeFeN3TeSx26n3ZdyBq/QJXEd0u?=
 =?us-ascii?Q?zJOcGxDrRXqMXFB0FghD+8Nyf+qAfPPYyAZHR9I9sol9OQHTHruESEAI4Ms9?=
 =?us-ascii?Q?zI9Z0vQ809O+oQAbgSfNSAA7HjHCtDoK2nMdlMmrC1mAgKcpp0AA9ZLuaL3P?=
 =?us-ascii?Q?JpUB+6bvFfaxObjH1R1CtOzOubNh75ObiQKWp5bBMco20OVDZGPxBUQZca8d?=
 =?us-ascii?Q?R6d1RW/N4UY8OclpwephzxpaGLFEmOWqo4e2O5OZWDd4H9/4Vmv/QZwc7qM7?=
 =?us-ascii?Q?LJ28c2VAw2Z/xVlRLwzbCGaK+eP7Or2NfpdhAfvNmEUbpPAJMWwA2QwVFeD5?=
 =?us-ascii?Q?qAmJ6R9ROX98DaG6mVtBkPnfBe1t6H/3shgz3cwznSCe5wA6fSGZE2eoHnb4?=
 =?us-ascii?Q?IBVPwpPbp+neoPpxEG4wLhnJLjY45rxqFXAa0BhDBw1ZnYGTqIWiTxnZz4/Z?=
 =?us-ascii?Q?R1AKHdfkANZkNmSbWV8W1iSLG0FJYrqi5sh8ZIhrNvXVVSGEKVgvQtGUArcn?=
 =?us-ascii?Q?NgARqK9C5V3tN7yAuaQQxguOIyjX25yMlLTfu+LXFsm+ZSYWn39XGIRZlqya?=
 =?us-ascii?Q?OBR7C7gtev0rhvEuBoAf33VdXR9DT1l3A+0yPrNnu1jyrYZjMk9EOZiFVIG7?=
 =?us-ascii?Q?tT43ay6J01zgsj94Fnynmqm5+J9uq+rsRCvVQer7TK5ldGKIwv83Dtu4jcSd?=
 =?us-ascii?Q?nvIkgrpksc6N3q/d/05gUj0elGJWn+1pBpKPX1pb7v5Ucvbij8Am5yHLt4lh?=
 =?us-ascii?Q?4wIIt+VYA5SZj5cnlwgRbji3Cv9OmWcXD7Cjy35Y7UY1XW+5K0cTDUAp9DAy?=
 =?us-ascii?Q?ni6xvBR6qb3sBdzT6CK8YQ1urfduRUGiPhzZZkGw126AjkbkwsW3EHNWsGJx?=
 =?us-ascii?Q?Gbu8sOn16OZBmloCmMm7luFhTt/ycZHWIvqgSFqyb8VJehm3VvgnB+nl1kzN?=
 =?us-ascii?Q?VDWki0VXtakLVdutMNldPKZXjoNFyLf0RCbsvm0EGCze5zCEK9+q/QD3ZNup?=
 =?us-ascii?Q?4YdRk2UcZc8WerWVnlSmtGuNzpOnzrzPFcfRntHT0AKEpaaeRh4AI0wAJuOv?=
 =?us-ascii?Q?sQkFGx/vHaH26TAKbMSEQj/j5C92e22lKBOWEyJCh/glOe+sBhmveYMCDjK5?=
 =?us-ascii?Q?mCSnuD2gJpQVK4MvA9o5WyTqSKTxksleGDbdPgxNVHRtx0mCEamFy7YkgCub?=
 =?us-ascii?Q?qv27lgoPx+IXAJ6OSbV2ZUANKHSm4T2nmV0E+KRZWAFgX4bKOHcq1GaDyrCT?=
 =?us-ascii?Q?R5eKFCHVUEVd+nLDa7h7iJKkE2SHy3pN4xJiDYik4bdiRfz7cIxInBLxJ7Yr?=
 =?us-ascii?Q?1TdMeEapF5t5sJMLH0GoPjyuR/MB3n7e9s3FOtX9JDqKo3toHKSAgN1j7EWr?=
 =?us-ascii?Q?63Ez5F9r/MnVeer42kXBPv/+vvYpHnP1KaWhMHIoIKnfvOkfFtxsdBGAy8Xu?=
 =?us-ascii?Q?xosf25p0KibOIyoUxKKrJuvmTr+/Ygz5+6U/SIGwEnmmwYh0R3G6wG2Wv18s?=
 =?us-ascii?Q?O0lO+yXfgDKY2HVVwTWqgQc2l+6l9BMhUWAGUSknMWMA2s2Wi1seX8ZS+tY6?=
 =?us-ascii?Q?PSJ6C7n/h/vXVRXTo6c15tnoG9035Ci/YieVn2EaXkTiDpeUIWfiy0rg3HP5?=
 =?us-ascii?Q?+VZMgv/7Kw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77353d46-d91d-4d65-f424-08de5fed7e59
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 10:51:16.6079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: taoCBu5BbehZg/JCzCcrMPXBVOmLNwTS92LSfck9/KxSUbijS28RqdkDllfhI+0P0yZebT+4N5PFZyQ1YfhAzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8730
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E700140007
X-Stat-Signature: r3ey3dz8aki68fniowesyf3bnnq3xz4t
X-HE-Tag: 1769770443-937347
X-HE-Meta: U2FsdGVkX18/nnotxmaWJ0/1TSrzXaGDyU8IwnGpZ6r+92Z5HZ+xin/lBcybMRJgENBKGImGJZ9tJxnMGIFAGPbVEvITaFfybTO7oUoTfjQlap3eGZPmlEs43JsH7h9AzZ+M+0WN9aqLtX8F3gw9UPrAYLSve9LNuDfob+Sz2LmF1meYyKa+XFqPlj87WxEpxiEDn5eduriI4etkrng7v6AIQcyp8I/pS8JyZxXJ3t6ummW1hkUm7+YKIzz+6D1OHNF98QFDYn/8BdxVnXXmOyAeWuLS1Vex9lvjjVcFU881/Ftv7CVz46T8Mxshlgt3p3bgxmKxqYyuJxQ+zG0kWuJQWx+K0wU5z5XmEIXb7SkV4JXq9z0J2hwLI54/ot8SymYjv89wXxnxTGfB9Y0B6Owp37FXJA7yoAsfSRTtgb2AElHWnqcK+HbgDKmyw9xcbf7ouIy9RR+3GzIxMVQhOA8Eii7kgK1R5mVVizQnFD3pkXG8zYiE/o3qmnSCAqQTEnoX/qZv/01CALAdm49BNRdaTAUWe1cJfwxtrlsUMLEEQma/4PLPxj+45iblBd+E46gvtMGaLO5vjlkLQUuKxOqucrodYl8QxSzaB9wpdUgBb+VsAj/RUFaKSEoXlo4TUXaH0IJTUWg+CkHq9cB0vHmvrJ3IIUbYnk/N2bTQRawd/ROCymk6ZkYtRpo4lqe4MJYEt9zu+0+p5yKZ+GBvjBcFJjMf+gJtcfAMg2hKet3i5cKk0S+964ojFemdWsaLQHd6IW2Hl7PQFbna4Xkv7fC93rkFEGZgIALnlMLKdaK+4rwVuev4ML2Cb5P/OK86hL6lC3oRHiBZYTY3HFMj8e+06iATkcjm8WdH6C20I3h3wgYInBkhnTdfzPacUn+NYK+95wsCCZbWXBaZJRttjMYIQdKurM3rXrvPDNnJjhNL8vKVMxwphSgRToa19xF5LRWIjisfIPJL7rxXtPA
 B7sneOl0
 Gs4fnhCF/6V/NJ0/UVBJV9u/px7hGB2KFAwFUBazKZVQoYxgpUztB/fA0IHON+6NmfCgRGpi3h8ABAXJ1LU77/8MMq7n89ueV8rHs1YNGqW5yja/erTDA9qlz8VcdyeBAAyuZqhX55TKbj+kYhcMj133KF6gaff1TrR8hgz4aMffV2cc0DGV8KlBhHMMKXdpDfym18Q6ZKINAMJhLtD3UHOE2gKqkA2QGwiwvSBysKz2yuXNytLxV29/vXljkPpCgc8k48VjVaUeoTHunt2Ayo1bgW2n4lgm+CrV5T7xeztKYZm699l2WOnKu0AGmEkEGLs3FAg8fH/DrsKNjjS7OyxrrN87uq4X1Dhi+lrhyB7CYLypUPksLgBWuIfXts944PTqfb0CHiy7l2bAJe5Krwi1BEWWo/6SDtEB/KHW+HyeIhUChiglVRYDJlmQUquWMBNGDFw36ZREW0ir2BNoMwjayMgMMjvuPZUnCfa+NkMuml6GbxvXOQ03cI/j2g02PQecCru2bGj0HKcAC7MYwNcxfsX4ZqewH03A63ABIohQD9mwuTEjiLalsoGi9H2g2Gv0/R05lSG/k+XE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have
normal PFN and must be handled separately.

Prepare for this by adding a MIGRATE_PFN_DEVICE_PRIVATE flag to indicate
that a migrate pfn contains a PFN for a device private page.

Acked-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>

---
v1:
- Update for HMM huge page support
- Update existing drivers to use MIGRATE_PFN_DEVICE
v2:
- Include changes to migrate_pfn_from_page()
- Rename to MIGRATE_PFN_DEVICE_PRIVATE
- drm/amd: Check adev->gmc.xgmi.connected_to_cpu
- lib/test_hmm.c: Check chunk->pagemap.type == MEMORY_DEVICE_PRIVATE

v3:
- Use adev->kfd.pgmap.type == MEMORY_DEVICE_PRIVATE

v4:
- No change
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |  7 ++++++-
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |  3 ++-
 drivers/gpu/drm/xe/xe_svm.c              |  2 +-
 include/linux/migrate.h                  | 14 +++++++++-----
 lib/test_hmm.c                           |  6 +++++-
 5 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 3dd7a35d19f7..5478e41877e5 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -212,7 +212,12 @@ svm_migrate_copy_done(struct amdgpu_device *adev, struct dma_fence *mfence)
 unsigned long
 svm_migrate_addr_to_mpfn(struct amdgpu_device *adev, unsigned long addr)
 {
-	return migrate_pfn((addr + adev->kfd.pgmap.range.start) >> PAGE_SHIFT);
+	unsigned long flags = 0;
+
+	if (adev->kfd.pgmap.type == MEMORY_DEVICE_PRIVATE)
+		flags |= MIGRATE_PFN_DEVICE_PRIVATE;
+	return migrate_pfn((addr + adev->kfd.pgmap.range.start) >> PAGE_SHIFT) |
+	       flags;
 }
 
 static void
diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
index bd3f7102c3f9..adfa3df5cbc5 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -484,7 +484,8 @@ nouveau_dmem_evict_chunk(struct nouveau_dmem_chunk *chunk)
 	dma_info = kvcalloc(npages, sizeof(*dma_info), GFP_KERNEL | __GFP_NOFAIL);
 
 	migrate_device_range(src_pfns,
-			     migrate_pfn(chunk->pagemap.range.start >> PAGE_SHIFT),
+			     migrate_pfn(chunk->pagemap.range.start >> PAGE_SHIFT) |
+			     MIGRATE_PFN_DEVICE_PRIVATE,
 			     npages);
 
 	for (i = 0; i < npages; i++) {
diff --git a/drivers/gpu/drm/xe/xe_svm.c b/drivers/gpu/drm/xe/xe_svm.c
index fbf5fd284616..a8aad9e0b1fb 100644
--- a/drivers/gpu/drm/xe/xe_svm.c
+++ b/drivers/gpu/drm/xe/xe_svm.c
@@ -770,7 +770,7 @@ static int xe_svm_populate_devmem_mpfn(struct drm_pagemap_devmem *devmem_allocat
 		int i;
 
 		for (i = 0; i < drm_buddy_block_size(buddy, block) >> PAGE_SHIFT; ++i)
-			pfn[j++] = migrate_pfn(block_pfn + i);
+			pfn[j++] = migrate_pfn(block_pfn + i) | MIGRATE_PFN_DEVICE_PRIVATE;
 	}
 
 	return 0;
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index d269ec1400be..5fd2ee080bc0 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -122,11 +122,12 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
  * have enough bits to store all physical address and flags. So far we have
  * enough room for all our flags.
  */
-#define MIGRATE_PFN_VALID	(1UL << 0)
-#define MIGRATE_PFN_MIGRATE	(1UL << 1)
-#define MIGRATE_PFN_WRITE	(1UL << 3)
-#define MIGRATE_PFN_COMPOUND	(1UL << 4)
-#define MIGRATE_PFN_SHIFT	6
+#define MIGRATE_PFN_VALID		(1UL << 0)
+#define MIGRATE_PFN_MIGRATE		(1UL << 1)
+#define MIGRATE_PFN_WRITE		(1UL << 3)
+#define MIGRATE_PFN_COMPOUND		(1UL << 4)
+#define MIGRATE_PFN_DEVICE_PRIVATE	(1UL << 5)
+#define MIGRATE_PFN_SHIFT		6
 
 static inline struct page *migrate_pfn_to_page(unsigned long mpfn)
 {
@@ -142,6 +143,9 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
 
 static inline unsigned long migrate_pfn_from_page(struct page *page)
 {
+	if (is_device_private_page(page))
+		return migrate_pfn(page_to_pfn(page)) |
+		       MIGRATE_PFN_DEVICE_PRIVATE;
 	return migrate_pfn(page_to_pfn(page));
 }
 
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index a6ff292596f3..872d3846af7b 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1385,11 +1385,15 @@ static void dmirror_device_evict_chunk(struct dmirror_chunk *chunk)
 	unsigned long *src_pfns;
 	unsigned long *dst_pfns;
 	unsigned int order = 0;
+	unsigned long flags = 0;
 
 	src_pfns = kvcalloc(npages, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
 	dst_pfns = kvcalloc(npages, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
 
-	migrate_device_range(src_pfns, migrate_pfn(start_pfn), npages);
+	if (chunk->pagemap.type == MEMORY_DEVICE_PRIVATE)
+		flags |= MIGRATE_PFN_DEVICE_PRIVATE;
+
+	migrate_device_range(src_pfns, migrate_pfn(start_pfn) | flags, npages);
 	for (i = 0; i < npages; i++) {
 		struct page *dpage, *spage;
 
-- 
2.34.1


