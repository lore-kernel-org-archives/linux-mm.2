Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1616CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 06:14:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0361C8E00EA; Tue,  4 Nov 2025 01:14:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00CEB8E00E7; Tue,  4 Nov 2025 01:14:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E16408E00EA; Tue,  4 Nov 2025 01:14:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB55F8E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 01:14:07 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42BEDC03B4
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 06:14:07 +0000 (UTC)
X-FDA: 84071909334.22.90396F0
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id C1AB0140007
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 06:14:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=f4kTYDP9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yzzUGTZJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762236844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZeK70s/tOhb5OuVBLe2AY0n85SfPTx8/K1tFOR8ZuVc=;
	b=NOJoNTqbveoLCq8kHUTfbFM4R3O+rQPAbbk4InmSvuQB1BcyRETuivSv5T1tuDVBnTkRvz
	7+wZ+T333s2XqzXyzT2kPeHPWJa4xxWyGgKxuSvaJTcoE6pcvH4GDfCNEjcDuxp2CxF0dJ
	2gQtXdz/jk1Phst64hVdpW7eQJiZo14=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762236844; a=rsa-sha256;
	cv=pass;
	b=ni4V8RwKMvXyBznXT5yOyhslGcV6ZIiOr0/gPxKhBzbh/okQn9U5ciCY4/fqeQFiMcA65S
	nwDPUHYlR6JOYk0Qw6h6ZZeixMWUVs/QR5TuCU8jbzldAy9WXI0vyyR1Gr5Qu6R0l6pido
	rDwBnDNt8e8ZZBTNz53jmndoxBQ7i0w=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=f4kTYDP9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yzzUGTZJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A469krM000347;
	Tue, 4 Nov 2025 06:13:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ZeK70s/tOhb5OuVBLe
	2AY0n85SfPTx8/K1tFOR8ZuVc=; b=f4kTYDP9cQ5bw5ahP2MEq2wDQQ6wM0HegV
	9XtxbGZDBlmkcyv7gKC0LfM86EeE5fw2wFYKsQJp7+qEvPdyvX3/m5rhCgpx5hXh
	9tb8oyspCc2AJngXj7gX3yw7GSTuNPULx2ZwqXDFEDjA/STqKncZ1+ZABIysrGKB
	LamYIkW6UYE0uapFzOkps/t3QsAtVRwjgNkk+1m5QWQ5RT2UsVDFUBoGGY20/HBk
	GTpF1RhaorNw+5LbMeVZYYT+Ure6kDYtv3DDtpWkNkIMuCGbNCXnn2vedj7ecozr
	fhkluzSVW9PmLasF7LWQiNby58nxG81mRFZ0cdV4WZogw4HMPGLg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a7byjg0e5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Nov 2025 06:13:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A44hnuo007361;
	Tue, 4 Nov 2025 06:13:52 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013044.outbound.protection.outlook.com [40.93.196.44])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ncp34v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Nov 2025 06:13:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kZhbJPhkZWekDufWqaxyVuKWW6AZHLAI7zU7sIZhemUK2mLTXChnsBgY3u01LmiqqYmGhinRys/JeyV3vYnPxaJZx2garxwIlcKRJLBo4j5zPKELcPuFl5O+R6gPkmtydmvnh9diUenNLyJX9TTrnhizrWhGHaqr/Z+dkxsfN1JB5j5e/y1jujAQWvXM0LyXAF9Tl+38YjcmjkzICwCLBqj3zulIijGQpgN8WPuwpGgMCcMBVBftCyKvx1c6SKj1urouQwR2XAnk5Vc8HlIF9QtKkFryTQTSwo5UGDc1nYZn8ObfvUWLGI3fgO09NESAra14rvpPNCaC2TIvkGkjaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZeK70s/tOhb5OuVBLe2AY0n85SfPTx8/K1tFOR8ZuVc=;
 b=PQ9uz5lycOYN/I3t9YrsUWGCbhcCw5wNyrbv8Cxwm40a0B6OuDbUZCkmjRDxAGD9Y5nh4XnVqgUaOZgqeakZ9hSwbHrEPa4Mqr6ThrvLY2LKp+wAZEgnl8VkqSe84sZeomJ7UHQHPJUUfMUWNd+y3UobHiSc4KH9kQbk4nelCI0ifwcRb3Za0qA04uijrDL06Oylljxfbj6vUBQCsgFjasCOsCcbiiR2llE4k+f9KOwKPWzaIDX6qKmqVBjLNewnBK9U51eYeWpg+zQBIkzVvPTAdfQu4nejW6ZNU/DoB8jU3z52YIwjp9hROyX2HIS3QXWISBCH6MxIh714aiddyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZeK70s/tOhb5OuVBLe2AY0n85SfPTx8/K1tFOR8ZuVc=;
 b=yzzUGTZJyvXIuHQPrKOFRxnWr8vDk6jfuzECDWnDwCy6XcG8EPfHFqgGH/vNa5rfUYygfh1ORdfijVlZRLoP8nAlX0N5CvNoNKRuDfkPTHezGb+WoAOP71wveHh2lh2jVMiIx3/sdqg7BxHTMjPiUVhfm5hzxdJxzEDQshsIJaA=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH8PR10MB6598.namprd10.prod.outlook.com (2603:10b6:510:225::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Tue, 4 Nov
 2025 06:13:48 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9253.018; Tue, 4 Nov 2025
 06:13:48 +0000
Date: Tue, 4 Nov 2025 06:13:43 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, oe-kbuild-all@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 13/16] mm: remove non_swap_entry() and use leaf entry
 helpers instead
Message-ID: <d5e122ca-d90b-4307-9d53-dc8b101499bc@lucifer.local>
References: <b4925aeaf6b7e8255b1cf1585476b718862b8104.1762171281.git.lorenzo.stoakes@oracle.com>
 <202511041345.8K1Nt70Q-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202511041345.8K1Nt70Q-lkp@intel.com>
X-ClientProxiedBy: LO3P123CA0001.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::6) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH8PR10MB6598:EE_
X-MS-Office365-Filtering-Correlation-Id: 3943cb44-5e4b-4cd3-7248-08de1b69517f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QVAk0alpoZZTIxNHcGYQMGxk5pu3LQTbR9wqGrpKdinjR73ezyKGRK2IZAxd?=
 =?us-ascii?Q?KyAw/eZoWHQ5tkGnz8QKcCwgVYJ4z7h4lJi3wKZz59Qv+BOsh8vhazx3pm6a?=
 =?us-ascii?Q?GjHQhlPE5/1do51WKmM7fsHCmOIFRPiEGPZZTCXnHgymw5nYnojftpQWpGg5?=
 =?us-ascii?Q?+OhaRll9L1O6mazvrHm1jEk83uyW42gnkOqf+imgNvvw9xmrvvG9ATaJV30F?=
 =?us-ascii?Q?K9ns/1ggE/4azOjsCpZkB6B7kXX8Sq4cmZ9Qv8B+i7tuoLeb/TTeLbmyATo+?=
 =?us-ascii?Q?/TD0Vhe2b0Bc4+48LAoPP8ugXr3nylUJGjVYxPhsqBXTSlKk35/9+zJnvNuy?=
 =?us-ascii?Q?mWbabszDr5harClPQcdm5vMLJ8rj4EWN1tQ0ujMc3ssOwuRNM0KlSzlucepw?=
 =?us-ascii?Q?qzPjJ4FdWLfQnhBNRAe7k5/UyTcAtKaDEuW+57raYH7yp9KtkRwYDqaJhWQE?=
 =?us-ascii?Q?iwKIbH85Yr65USXi5mhTAVYF+ge/F2u4iKdMkXfjPnIAbPOJhQIhN79lWgwe?=
 =?us-ascii?Q?9yv3VQAlZhk8wZGpuNZk06BesobwoSXX3vAjTVt5CrzUuZ2whJiH9nR5Cznt?=
 =?us-ascii?Q?DQWJlYznCPAceu521uM+u+DruyKpiih7PzsliKPyG0p+cY+DoHugOlN7ka4K?=
 =?us-ascii?Q?F0uGlsk7Kfz4cvrhuPV0Ybo8eLYXNmiY2+sZJLoPC+ODBQv75vuyPHrYtCoT?=
 =?us-ascii?Q?dJmEjLgRhYYjsc27huu61qC+VD83sBNf6670rz2ALImWPc0/5qJuF8O1IE+w?=
 =?us-ascii?Q?3Osm8/cjrcRIJtZ6P97EnF49toQYk9g0uhSLcBJoUKjaYSQnozGyR6SYhnbR?=
 =?us-ascii?Q?piKJka0wydbOHboKUVm2B5rrhC4btsN5/uiJv3LnJ5jM3NGhDbHPQuUQ+mn4?=
 =?us-ascii?Q?dZBJuaziHfIr3DD+YcbKMYuvmVM8bNzp+spFFLhGnMzP6RULLfoUO0uwI5DJ?=
 =?us-ascii?Q?ijJSysbKu6FG2Op7ttIUQ9ecwDXPEw8Dg+k9OQMcec52w+YOPyh+ylVBz+EU?=
 =?us-ascii?Q?ItdOLTKIH6Lr9i3lD9cDc1bE019porOixRQsTkpFsTLksBqR5QVRtqF6y14i?=
 =?us-ascii?Q?qQ3ey9+xYBj1GgQUuTBkQ7bb6a0WcK3RS8C1wnp3kciFQIzeghag2PTJhAeU?=
 =?us-ascii?Q?u3+rz7RvohwULEalLcNB5i5rLW870YBDVpiLNOX40IssiFoPvp6Zaave1sEY?=
 =?us-ascii?Q?M4n44fqMu0A5e8+l9CDk+TU0/eejZ9N6Vvjzzgz3TLQbqo9DyLSa3v++Egb0?=
 =?us-ascii?Q?81k6ooftouvuR6BRYsmHI761O5ITJKW/9BG1eF0/ATtwWiPm8LN51PA/DGaQ?=
 =?us-ascii?Q?H4vNW2+35ZxtwvZ5UEqNTSFz+buJfUTyU65dOibDU1w/qo5PVSc8QREXjw9w?=
 =?us-ascii?Q?GMEZLDpLX6tJLIzp6a0GamFM8vGD94Ipj0uOvMPiDPniSaA2N9eXn8nkGBQo?=
 =?us-ascii?Q?nHWIDwZeIgGFeDpJWaV7FEUfzOxc5yvvRK+dRwsDg3lHNfqFtYDSyw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RdshoLoZAGDnwVt+IEjnlBFt88hahQncRakLc9Kc8WSj78sCndeGuuyQmnMg?=
 =?us-ascii?Q?0BhOiURvGqV4d95dISAVYG53Zfx0+fslLsKRH8gy/xOR35JVnsg+uG4vLfn1?=
 =?us-ascii?Q?JlUAUMRozajfHBWje5d9WVRZMvJEsq2ionR6ugEHcFZhRKMg0EtGNULIPzQy?=
 =?us-ascii?Q?ikgIhaUzG1AT5JsBFb/8hbJTyD12AH+PWr4FscGgk+Pe28MlIoRlmCtX/jlC?=
 =?us-ascii?Q?A9t3lk/E+vYs1dPU44DDzaFTFjoHC8899BYXeSFU6C5FVnzqsAdqHQqGeIAe?=
 =?us-ascii?Q?qfcpGJ7VAlS8A5K/BIGTVtA0YFkZRVbnT4g1GWL1asDdtnfBa1Y0PDeEpdJ3?=
 =?us-ascii?Q?JkJUR47X3KBwUOWRl8RhZMEzjjseRLRaZLLsp5cXdaIVyuUXX7yTG47wtYFg?=
 =?us-ascii?Q?OPefIyMXoWah2zhMuxYqQZ7hB45NEJqMCLztwnwtoA8M2CVLW0WNvQPfu9En?=
 =?us-ascii?Q?IR5kMVXUolPfSjr8/nUszo/wS2b4KsXMZEfV7qaKFavszTCGdHRlX5e6VDnn?=
 =?us-ascii?Q?z64lrpT7sjngmLqF+dpnjRDEonnPPat3yUf2XkcXkQTZlM64XGvMacZB6gmp?=
 =?us-ascii?Q?g0ifDXmyYKlRtqkIlsJmii/N1CLhI/4HgL4RnEx/NqgQcaGz7RDZIsazj47j?=
 =?us-ascii?Q?1vX7umLpP1VxALIyf3lHTX0G7I5FjCUp0U7kDWEMKbS6JA61BjPwBzqIx5fp?=
 =?us-ascii?Q?SUGlg8Dr+JwTnrvLKsk4NGLy30kD/AExJdBsA6qoO3yCZ6GZBy7fV4SGjgdY?=
 =?us-ascii?Q?pNYEakF74drhdQn3AmaeAO2Cplk0wxst19mv/OqOgM04XruOQVAuRKc3ILV4?=
 =?us-ascii?Q?fZZU/e+M47dMstdALPIHZOiSpMRKUhm/f7Z+nQJWFXEsl7dOr20DR8ibfrdX?=
 =?us-ascii?Q?dh05Da0hg3yP44ayfshVcQwdFfVQK6ddynduTdIlg0H2dRt9PxdXUSsx6zMf?=
 =?us-ascii?Q?whJafhl+ma9oDTgDJ9htufe0NRWFUkci9mNw8yjIxIRoe7JH4oqHnrO47JMi?=
 =?us-ascii?Q?RR45ju9t4auXriRfICP/sdYWrAbO1FLlqbD/QjaWVlzXQfwxEn+UqSYi5ttt?=
 =?us-ascii?Q?2yPH4DD/Jl3Z7uGK/zQN9dOjlL8hl+x9J5vLNFfTkxT6POzWhK/ExwYnHZJN?=
 =?us-ascii?Q?yvPoSsV2BNgjJs+6ZDbUi3a7moRTqCblbtgUrtqMNnz/eUKcM/Oy9ZEryJ9Z?=
 =?us-ascii?Q?nJjK0699ZN4LbvaVACjiYweT3WFlVT22qQNk25zcde7aPMxyczQkqb+Dugnt?=
 =?us-ascii?Q?XDr+TkNuBdA6oUmoOwJCYQbGFfXc8RrUGrGBOLpEBQDpQyEp8mH113wDPY7+?=
 =?us-ascii?Q?NH3c1HGFgJwGF34LmHIK5W0jTNnP3ibCe+EgeH+7Lfh4ICtknaxYZ4u7KeJm?=
 =?us-ascii?Q?f0956/qGYnpmpT8ZjCpa5oHTog/TSM7xoT4CIfPLoF/XbwXnZPVUtINiZj02?=
 =?us-ascii?Q?y1rFfoXH+6I5QM5qoaOqnr+rjlz8kov2g4N+b7fsPAbBiwCPgVqLyMFLUUV0?=
 =?us-ascii?Q?bBaYOW+YmxrsdBF0Hf8TY26ZHdq6qkSHvEO2yIvPzOHSpOX2QfgwQI51QYr1?=
 =?us-ascii?Q?FTLqyWDwFN4pX7J/T89QSB61fQ6N1svx4teKPBHaJ5eEIoK0pHVPn3AMAehR?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Nk0bjHrgG51LpDMw4mlHMLbDJ0XjeqKzHjxVpsABy3hfDUm1+G/QnrUJjIaA4swtHhri+rkJzjP8+i+nRipBAS0bZ/hkHIS5WL2PjJ7nusUPijaro7HENtDVe9/VbLf0gh2Ku8CiXeJl36/XRBOb4usw1dXQl7E0kmPBV4939nLUZkpxdSl09JlwifCNZZhS5DG0CObXnaWRjTShiVe7Xu1lZqzzJWh0UfzuHzzgm56cS2I4e8ZBPd1sdl/iX0YDA8/4Ho34/IOLj1yMoTcxlE8aHnErAehdyjBgGXWa/agpvxkwm4yNijMk18EEhEyQgIQoe230AJjBLzfowVH35DrWj7YxHehXlDY45Lu21NlJdpSTfMKCVBBOfUMFptGLI+cFG98YGYZxf1fqyJcGqvaBYmUyi8yV9E4XXHVJmKyVszOtvXCCT+iYfN8I7tzonHgSU6JyFK18BDc+BmUz6Ole/Z7Ph2aUavH1Yq5aCc+CEaunNjG8Du040rxT9WFjud+5GL57MykXAOaWhRLRiB5nsRVHzpZ1k2ceRy9W5JnhawiuT83yFhywbdhLnU6VG7Sn+l8ERX7WDuc/yCR6lt+d7TVhdSYGMkRO2DbZNgM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3943cb44-5e4b-4cd3-7248-08de1b69517f
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2025 06:13:48.6854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UDt/xYBy1rLoJ9AowuZNZY42WeS/09ko75mT/KFWdEfyESYLwobp3OLyH9RND0pN+1A8rJjRcYt3SufMstt5NpLYBZZX5tPT8n6eWVYiOZg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6598
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_06,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511040049
X-Authority-Analysis: v=2.4 cv=FIAWBuos c=1 sm=1 tr=0 ts=690999a1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=i3X5FwGiAAAA:8
 a=QyXUC8HyAAAA:8 a=I9TJKNqSxyxf3YJhUcQA:9 a=CjuIK1q_8ugA:10
 a=mmqRlSCDY2ywfjPLJ4af:22 cc=ntf awl=host:12123
X-Proofpoint-GUID: 6P1QQzqqcKkdwR0B4v7gM0GVoUYoyuFD
X-Proofpoint-ORIG-GUID: 6P1QQzqqcKkdwR0B4v7gM0GVoUYoyuFD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA0MDA0OCBTYWx0ZWRfX9qMRUMqQF/8v
 LByvBlecfdP6vWWdTtN4f+gG1B4HwKsmWfXKHXiZ8RTaGdedXUGC4kpVJoQrIYR4dzbUARuqZvl
 bZ6V7fIKR13Xa0BWqhWpM80aSmvdtwzEWzyTwnHz7SvqVaI3kZHNaWUmEk7N5Hq0bEPn0FmXrq7
 YtoSqtHAvMKZK+efXOIFp5vIWiIw25ljY52GbzlaiHNPN4e6V0u+I1J4BRJ3S1ekDfx5mOAvwii
 7ngHmHGZGUFf8JtG702iRacXvIuRt7sSLbkZSIAO7qK3nLG09IbJDKV5QjyFF6zxjWmsLPeHOJd
 XPnrDbHum3Qqx3yfpiUUklXfCWgIuvEeCrURSuIjjkIw838IqRUsTtc+W5NVt7WWlMZCj731qyR
 TX+MZ4e4tUv2IvAnlhFpIojgyo1s+iVrfHzmg29XwY79oFemk2g=
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C1AB0140007
X-Stat-Signature: s57t3zrq4owt47unjsith6zibea7nyrz
X-Rspam-User: 
X-HE-Tag: 1762236843-197995
X-HE-Meta: U2FsdGVkX1+XHYV0D4579ng+Ry0kyHRj7hIymvdOhyo1d//3MHp72Lgq6f5aGvRHDBQB7B+zoULmVcEzNYz/0WgRCXtb/yWlW97+DW3m4IC6Kd8n/wZikz5oeHv3sCRlIrJyL3IvWxOSjrsClxf0Wrw0zQQYRmWW4U7OjTkOvhwIgspfAxowqScGetpi8oAU2jhc1Ar3MqacY+9cUL/6vgPuQwXKYkw89ucOM0gafAkA43l+RDpI+XHYL9oNI+w4YYhKQIMo69nI2TWTqg2qh1uyOXSw8SXrcYnF49Fa9aoFxLytacIZ5AXb6NQ/tXIr8QMpm7HYcluhsubsIQuY5hA+xeJs3rqldHJr2nYEJHpVcZLXhsK4BmoSfluvOWqQo+nL7dRLlyFrBbY3ic5MOvb5uMNU/pZTQdMufmG9ZndBXTgdPxKEpHpjBaPdUcLK4ejnZ+q5xTMOtOYSPcyJY/hdIXkXTNjtkwp4W1yqUqdkP1rZwj6KLBbDj5bTJ7KDH/izFYpWeeoZDfhN6VFy/esKzKTfaEdNpDJdOf12WWBkPd1gH5slSMkKmbi6J0mq/0RiMz94e8R+mQdpm18nkPT6PalfRUz00QbtZ0xjzIOv0CyJ6O6W0gJQpRMn5DcFLGTnOR8nbgYzf3V1EILLIBHyBR+FSVz3Pwx5Y/1z+x6lzEm8x3NMtoCQPOmPcKvjsP5CZjFV6c01VRHpLsyFGbcx8ghD1gC7+ASGGFDqsAl3rgSvw0lG/BwyY/E/x6ByaFwzNzA+VdKJePnXyEWrZqEayZ7U5uEaOMLYlpS34aEY3at56khpga4JWRkmmKLOKxfnBBKOV0wlgz/cq85BJ0N9Ze0sz3Hep24vUwNvIqVAroFY8M4Q72fTLo3LN8jTDRrhrT1a+0zu5Hic75ij7OU+Yk/uCuwvHHWEVX0Lu9lZe+NygECcRXviHRmnyY47oBgp+NQ3a7cPrT3fQbO
 k1lqi/O0
 NTblqB77ljb5On28BqVVTZ8ZmOBpohxlZz9yGp5/rejPAKeBhQEMk+cJMOmc6P+RJ9pa8Xl0wYzo0t6agGlbjMe30/G5no+rkvUvsff+PVEx1PhYviErISK8++BdVD/bC+P6qBe3f+UFpf/yak4TukXdJq7n219/0d9aNJDoUa9i8aup2u5Jco+9zz3E2Z5KWEUgsFqLTenszwSQXVDuDNh5wOJckOLyH52HcLkQATH/2b8+SEG5kYHsAifRgAgNbvHzIXpuSbr59daHdxgYlFxbFP6mQDGLrERJizg/BjdNu9Ogelw5ESqlmRKggzqY4CGNM5TRzVW51uuE8aWa6sVb02/h6pj1djivzNXiodl7J+JkeQ9snxEDnKAUlMkREUtYHQNgqbpqQCSfeK0BLY6g87wx/mKjK+IagpQew57VEj0PRewsSXzlsFnk8nWYt/Kq5eEBpRh70UgmAag/6tb269Cy5t8YdXjB2wO4RTJGFCbHyXNhbYhNDA2WcOfQNAM0LnjIP6jrykUbT04MhB8F31nLM6WxXfr+LJx9ZNgrN04WSNJCoBWhSLEVfJjUpR8jNQhjUVQgO7C0m3q9outrstgZ6KLJw3NpgtHBzxJnwl3K9fxfUAxL+K3sJ+JRmEktT2e/K9uzOcV4M5Au3RbqlIRTy3YKusi7dV0+QpEcpdw313HcdjDRkcOrdWWPjrnaR2OHa9cfVviKKWO+NtYTBNrR074ZscnMH/fW9Bcsq4ua/qFQQ16etOJ0pk69ldthrmwiG72imWm7/v3kO9t3J9nfSbytjNe3P5Cz16M6l64FuX1db9LpRNQzB/hLJpQ4+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 04, 2025 at 02:02:13PM +0800, kernel test robot wrote:
> Hi Lorenzo,
>
> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on akpm-mm/mm-everything]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Stoakes/mm-correctly-handle-UFFD-PTE-markers/20251103-204118
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/b4925aeaf6b7e8255b1cf1585476b718862b8104.1762171281.git.lorenzo.stoakes%40oracle.com
> patch subject: [PATCH 13/16] mm: remove non_swap_entry() and use leaf entry helpers instead
> config: s390-randconfig-r112-20251104 (https://download.01.org/0day-ci/archive/20251104/202511041345.8K1Nt70Q-lkp@intel.com/config)
> compiler: s390-linux-gcc (GCC) 12.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251104/202511041345.8K1Nt70Q-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511041345.8K1Nt70Q-lkp@intel.com/
>
> sparse warnings: (new ones prefixed by >>)
> >> arch/s390/mm/pgtable.c:693:47: sparse: sparse: incorrect type in argument 1 (different modifiers) @@     expected struct folio *folio @@     got struct folio const *folio @@

OK over-zealous use of const here, will send fixpatch.

