Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DE9FCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 13:55:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B27EC6B0098; Wed,  3 Jun 2026 09:55:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFF516B009B; Wed,  3 Jun 2026 09:55:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A15AD6B009D; Wed,  3 Jun 2026 09:55:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8FE996B0098
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:55:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF28A12032F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:55:10 +0000 (UTC)
X-FDA: 84838747980.08.8920193
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012035.outbound.protection.outlook.com [52.101.48.35])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3F8B918000C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:55:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=amd.com header.s=selector1 header.b=VmbUMxLj;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf16.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.48.35 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780494908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z8KK7uIwBbspY03ApbIIJ73IHoUzCVvm6kuY7Ymlf/4=;
	b=wwqzeSCBj8EXWMDlTyGQAc1hEaUDqIzXi2wytMsFTdrik+0WNYBEEEtUVs3pfJIy9McWW6
	ieNObsalMMdnla1N6ln+dA+NAFNryg2AVs/XEPcqp5sd4Vb188WGJ2whDFb948nEFK5lAp
	HDANJO/miQFRngGkZOywIX2ltdaSLwY=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=amd.com header.s=selector1 header.b=VmbUMxLj;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf16.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.48.35 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1780494908;
	b=nlYfEbepPZsN7rBaYYiH0BWG2fcyyY0Pqpz32xr57RazDUaFVg+tGx6YRe6Senb11IwBkF
	NyMxC/orYpoBxiQr9kPQ1AYr+EccgQ9bb4JD1J1K97fr7S3oHh7WRDKAL67lvZ3YunX2W8
	O2INH6+YtyU8C6w6h4J0Yt7lX+iG4j8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qYmCoavDEMSKELSvlMkV7GBPB2EFPTFmjn9ddcZ/FPqvi1z/0kUp+a00PiNn3Jz+FTgvocPo28d+jYVqWiji9ziH8BjDh80m8szZv2bLFD14FGuYVts/NBMx8fd4NuMaA+auZdZbiTGlfXpmrDB6w889DqQsWvv9apzO4EDnTolGxuyMm5DbSPFl0ulujd5bFoB5T0rX37idK36zFBBaI6QkFDXcnXW6yZ9ZXwv1hOX5eQPmjMSwX5uTPsadYFc0tOEkxz29vTZqBehb+5dZc55jxJyKL45DffWpQ5EAjcY9WSke9Mh+KhOWvB64Wv/rNQUi1nPajz9d5UOHiPXbyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lWJJKq0XHaGHI5TnSD9auhv2n2Mb1lFzBdKs7NDxrRQ=;
 b=vQDsd/0fKnzNv52Vata+2kLSVLbvYnPrptNbaoZJ89J3dUKL6+zdeRv++XFBFZkbDoRffPPqio0Q9SXAN+uyg7WVDC2Ob+1pS6JaZauIrutpExiu+h/OwjyJgtyAaONP5hZzWByYtd/vDQLKBws3BCw7YUTONb4CG5Cizqs3InWMQbFyQHQoN4/SwZn/odj8Kt1s+xu4+bzmvVnROOt4rduZvkgtKP5/8EcLlvyA6Yymx4f/ZPGsytq9yfNd137TP9LfyDxIPWXnCYeK9CrKj54HID+Nv/6+w3oBlPB7Sp9AjfHPf3M2s49XyOGPrkzgt9vU3cRXeo3uDrxoYvixXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arm.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWJJKq0XHaGHI5TnSD9auhv2n2Mb1lFzBdKs7NDxrRQ=;
 b=VmbUMxLjBCW0HGGIOwvbxB72biW1VEdZ5YfIJNoTnTBDAcis1ucNw5bJHhF6aS3rLc0u2uxOjWmo8GqHd61QlbYTL1mrw4oLnZH6J1s3DhBnarEdjR1dz2PTNURP5NLWSfxxP8+AiF3OXtXDHIU+C4hjRyqjzxaVOW9QBPxtWkM=
Received: from SJ2PR07CA0024.namprd07.prod.outlook.com (2603:10b6:a03:505::14)
 by SA1PR12MB6797.namprd12.prod.outlook.com (2603:10b6:806:259::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Wed, 3 Jun 2026
 13:54:55 +0000
Received: from SJ1PEPF00002314.namprd03.prod.outlook.com
 (2603:10b6:a03:505:cafe::52) by SJ2PR07CA0024.outlook.office365.com
 (2603:10b6:a03:505::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.7 via Frontend Transport; Wed, 3
 Jun 2026 13:54:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002314.mail.protection.outlook.com (10.167.242.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.5 via Frontend Transport; Wed, 3 Jun 2026 13:54:54 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 3 Jun
 2026 08:54:54 -0500
Date: Wed, 3 Jun 2026 08:51:53 -0500
From: Michael Roth <michael.roth@amd.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
CC: Ackerley Tng <ackerleytng@google.com>, <aik@amd.com>,
	<andrew.jones@linux.dev>, <binbin.wu@linux.intel.com>, <brauner@kernel.org>,
	<chao.p.peng@linux.intel.com>, <david@kernel.org>, <ira.weiny@intel.com>,
	<jmattson@google.com>, <jthoughton@google.com>, <oupton@kernel.org>,
	<pankaj.gupta@amd.com>, <qperret@google.com>, <rick.p.edgecombe@intel.com>,
	<rientjes@google.com>, <shivankg@amd.com>, <steven.price@arm.com>,
	<tabba@google.com>, <willy@infradead.org>, <wyihan@google.com>,
	<yan.y.zhao@intel.com>, <forkloop@google.com>, <pratyush@kernel.org>,
	<aneesh.kumar@kernel.org>, <liam@infradead.org>, Paolo Bonzini
	<pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, "Thomas
 Gleixner" <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, Jonathan Corbet <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, "Vishal
 Annapurve" <vannapurve@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song
	<kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
	<nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song
	<baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
	<yuanchu@google.com>, Wei Xu <weixugc@google.com>, Youngjun Park
	<youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe
	<jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-coco@lists.linux.dev>
Subject: Re: [PATCH v7 07/42] KVM: guest_memfd: Only prepare folios for
 private pages
Message-ID: <mzbsmlljbqxv7epwh6bpjrlbsbc4yqdj456cb5hanxetco3thd@c7mdph3oi6o4>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
 <20260522-gmem-inplace-conversion-v7-7-2f0fae496530@google.com>
 <d01cf1ec-b85d-4af6-9810-8107c0e2a4ec@arm.com>
 <144bbb9f-39a2-4c90-8903-51521e022da0@arm.com>
 <CAEvNRgE1dCVAxJWd_hyFa8N=m9JLfn97ip9tAmvHxspWJ50oGg@mail.gmail.com>
 <88cae738-18e9-4ed3-8414-506a1ad8fb18@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <88cae738-18e9-4ed3-8414-506a1ad8fb18@arm.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002314:EE_|SA1PR12MB6797:EE_
X-MS-Office365-Filtering-Correlation-Id: 01fdd232-0bde-4b91-a416-08dec177b10e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|7416014|82310400026|376014|6133799003|56012099006|11063799006|4143699003|18002099003|22082099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	wGsDUj1VqMffVhv6PLZsn/UDfBQso8yfRbErvW2EFHXdDhQGSV0Y30uImcLMGsLd90tiGc6NMD0PEqPfNJCqwEz8UGoy04GngQOx1RHfPD0/R16l9Kdms6yLIEzXXaOuhoq3bVkvisGJuVSeX1LljM4ccybWG0pXg9iOZ/zrVKmLcVzLPP5R5CiIG3Eu0IWRO0Sxn+viDdZWC2QXLERVmo25dSCP10BEQjIiEubNO0fu87tN3inskd4j6IGSjSdoPxs0zZs8ONhvN61umymciIO4/oZlKnkwaZwnikq00nABmXDA3vXkPqQN0f2iv631C/IE47Zf+226DobLjTMlog6ZCQ6F8Rqs9db4cdioJiedFHQCVoMesiSG1X9mzQfRcaVjprziye5zQP6PXnumUgbricOuAqbSRT0iAN3NrLF+lSRBmwNo096+AmvfhLycabrRJLwQgKyC5gcGjnfPD3oTzOXg6Dhqej0KOYYLySxq0byEcVcAHXmYfGp7L4H4ZbNEYqE4euf1tmDadw2R3NXZJuiy/5lcsLRtISYszygsQOA9a390/mW5SR9Hedru1X578Gb75t8FZmwWM8+jYb/StrTsocuoeOxGdQkj225YKFUr9nQ9e2IaClLoqk1GiqQ7ykCRhjWxvLiQfULCP4ZOknD2h+UbSv9/GAfwWOCPjhuT/no+UP34wue+xwyocaxWNclPS1F0NV4U+zRbAmJq3D0f43vnqqQ8eNkftUg=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(7416014)(82310400026)(376014)(6133799003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vMtahuW4IGDeowK92ErtLxT3iBnRKNqnxnyEfRe2rBzCfsx8f9k9brqwDk0UoGKXy/xNp52GKAfBH1HrnsyL+4BH9BdA6u3dRhj2qSzFWN0AytLSHj8AGnle1tjA23biT4FB1vgvztZBouklQWWMXcjSlu6kIKoIkNqFJ1eYj6yJ/E+BUGH0X3eItSbmaUmO5M1vncUuxzBeMzVNv+zjNz1kv+7TMdS0wdLjgeghNdVxgv7LCK3HRND/Nt1ajee7DXYdPDXbDmx50CgRVJ5TljYSqR52LXnhfSOTm2ZtgmOxhtdb3o3/uye/M/KRHdziXv3C21opqNLIia5cu3cB2OkTFmA3IpZSkwkkKAOBYsJgFh++fAA6WxficmtlbpBkUsvBnQS06InLv9UWnpkaZ9yY8dN/uCCPiRpYkAgjS/jzP2294IM+JtxW+IJuSEyn
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2026 13:54:54.7713
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01fdd232-0bde-4b91-a416-08dec177b10e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002314.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6797
X-Rspamd-Queue-Id: 3F8B918000C
X-Stat-Signature: zzkf9hjq6wq3u7rqzuewiqomoxmbk14x
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780494906-487485
X-HE-Meta: U2FsdGVkX18C4Q2NabvGEEQAhKfpKU4Qh2F/KgDLYXlI5sJRyPwYt0WrOzfuNIGBm7Gwj1T8QTwWfZ633/ba8NdG2P1Lok7tvDZIZjZi8/a3h17y99gqnqMxiC9Nd8pBsBeviWTapb64+Fov8dlkF2jHpxf4J5k6N6VVxHQckRCTXOuDlseGeiSbjQEV7AfcYBwYr0f8H7f/8C3g2Ttott278F35k2oc6bLJNXa6MMVPSE/EB7YG/wmEu2Yc9CCfyk2Cl99ljHyxP0HY8z7kJ6c2SRWgxCq+yk9fHb5Q3sXJVrqdkxWfaxfu/ivaPBp64JcYGzcAp5vwVJ0NxCZWoHZXvgwboY5Z3zdX6TbJN51PGiziVp0MAnsZYh58g6t18YPk9UuOVv6DoMHFPsJlZJu++krIcrGqGOI2NRs54xhwMl7Unnz9lEcFpOfZyMGi4CN3Pi23U//mOJkoiP/YjGifltZiM/Fcl6k4UQ5hQhlquRCf0r7pvSkfPQhx6nE1EjE2HG90W5fa5r6gdTIBX/9yhuEG5LGJ20DXiZsgOr4UgIH+FPwlkfZxRa4m2xP9TUFaP8HZ7tYQD8vwyzeS77f/UFW+6EGrJ4rgQVhDEDuKaE13XylqTla4wYEVEOpVD2Znmm+HYOtimHKozNIplviivYEVV2oKvF38R8zYFqExVdXiOjVhgaovCVPgzKn6TEmmv0YQRyqcrmoobXWOc9Q6KCGnjB5VFYrK5ntiaHKm+ZaPpjz5LGUBoqn7QLnRzrLVFsMFYkXfj6Tyj0rGAilKVeKjxQzFGABHyNT5Wk5clO06KDDcFLWxBTJk+eMrs1b3QBnGIXXtelZJw0seEQnSAK9IGYJxGXCoaSMlS8A0NoFzCgIyJMHM9KNN/dTSjzRZbCR6JEWrrfg0N9HbWMks59nEdfXm/joQARpmCpebyI8etNAVKuDVVrpy+75iErUzB2z+IQpfamKZhPc
 uw/dUxt1
 hzI9axnV56wEpvQDoIrTduRf0GgZiOvM11DrfgL/KA4FLbEbFrMOVp47B4L+HZur0fI/geEq9iebFmK2DtTV9yZq4NkzbuFz4Q9uEMO1U8DnIGmt87tf4BJj4EQHUO69aJ0ai9pUiuknqzqicPpeDZTzw96bFpWUnnkK7hfSahVGkvWJ0uhoWDouP2yBDKDbfVbmGOX098D6D/cgJOZ0HjtWQGNqu6ZpMHX7R0NSCL5z3uH49I4fLLh5mJz9Mcq81mVNilMGGJWW9ra/WgoML19xHtlMZDAzVDaVpAaJCoTTL73M83pyrbye70ux+k+OrIobh1+m78qD0RdvjBU4JUm9/TAIb0gzagk2Md0Ukn8n0q+61Y87x1qQwSeiG0T/+csZhgP5nY5XEh3sv+bLJhrgInpskehCE9MKxzE3EYBex8K8Zg7gdcaU2k+1M6GYVriOl6EjtPBicl8O8vpE80oah6o02hjC/ltt42g6QpWnaXFsfBV1o6m7LIwJBpIeiIrpJcZWhk1VyI8Kbm9/UbVUsLwLppZo0CQCjKwCIBWtIrM3/NaH2hy658i0EI78QNu9jULPzg0hxUMFEE+dXhaxn0yHEwBnHMpPusbRgUwXpmYxOLqStc+lLpkCLH4+LbUFFl50FbfwzH1C1Sb9mN0MrcKt6V5LxXlB3QHI4v+q6AQSJrMm0sys5QMBhwXT7sFh6EpuXJHwGzcQqWMcwyGdhz6UH13o51adm0NKUObPkfjlUXGw+oUP9QMc4OCikoJoo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 09:58:45AM +0100, Suzuki K Poulose wrote:
> On 02/06/2026 23:41, Ackerley Tng wrote:
> > Suzuki K Poulose <suzuki.poulose@arm.com> writes:
> > 
> > > 
> > > [...snip...]
> > > 
> > > > > @@ -914,7 +916,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct
> > > > > kvm_memory_slot *slot,
> > > > >            folio_mark_uptodate(folio);
> > > > >        }
> > > > > -    r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> > > > > +    if (kvm_gmem_is_private_mem(inode, index))
> > > > 
> > > > Don't we need to make sure the entire folio is private ? Not just the
> > > > page at the index ?
> > > >       if (kvm_gmem_range_is_private(, index, folio_nr_pages(folio)) ?
> > 
> > I was thinking to fix this when I do huge pages, for now guest_memfd is
> > always just PAGE_SIZE, so just looking up index is fine.
> > 
> > Is that okay?
> 
> Thats fine, but would be good to enforce that here, so that we don't miss
> out when we add support for multi page folios.

We sort of already enforce that in kvm_gmem_get_folio():

        /*
         * External interfaces like kvm_gmem_get_pfn() support dealing
         * with hugepages to a degree, but internally, guest_memfd currently
         * assumes that all folios are order-0 and handling would need
         * to be updated for anything otherwise (e.g. page-clearing
         * operations).
         */
        WARN_ON_ONCE(!IS_ERR(folio) && folio_order(folio));

which was done as part of:

  commit 6538b6221cc2feda415ca1946e66a5ef02dc6a0a
  Author: Michael Roth <michael.roth@amd.com>
  Date:   Thu Jan 8 15:46:18 2026 -0600
  
      KVM: guest_memfd: Remove partial hugepage handling from kvm_gmem_populate()

and that should trigger before you even reach the prepare path, so I think
that's covered.

In general, there some previous discussion where we decided we would stop wasting
time guessing at what we'll need to do for hugepages and instead just strip out
the partial support. Sean wanted the folio order kept at part of the internal API
since we know MMU will need that one way or another, but elsewhere within
guest_memfd we are okay to assume 4K. If we *know* certain points that will need
to change then a comment mentioning it isn't a bad idea, but even those comments
have tended to be wrong so far about exactly what changes are supposed to happen.

I'm not sure where the original discussion happened but there's some aftermath
discussion here[1] that I think summarizes current [non-]plans around
prepare+hugepages.

[1] https://lore.kernel.org/kvm/20250711163440.kwjebnzd7zeb4bxt@amd.com/

> 
> > 
> > > 
> > > Or rather, we should go through the individual pages and apply the
> > > prepare for ones that are private ?
> > > 
> > > Suzuki
> > > 
> > 
> > IIRC the plan was to make kvm_gmem_prepare_folio() idempotent, as in, if
> > a page is already private, just skip. Currently sev_gmem_prepare() does
> > a pr_debug(), which I guess is technically still idempotent.
> > 
> > I'm thinking that the information tha needs tracking to make
> > .gmem_prepare() idempotent should be tracked by arch code.
> > 
> > Does this work for ARM CCA?
> 
> We don't hook into the prepare yet, but have plans to do that. We should
> be able to handle the pages that are already private. (For CCA context,
> RMI_GRANULE_DELEGATE_RANGE can skip over already REALM pages). So this
> should be fine.
> 
> My point is, in a given folio, there may be pages that are shared.
> Like you said, this could be dealt with when we support hugepages.

Sounds good, that's also what SNP will do once hugepages come along.

-Mike

> 
> Suzuki
> 
> 
> > 
> > > > 
> > > > [...snip...]
> > > > 
> 

