Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF2E1CCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 23:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8533A6B0088; Wed, 29 Apr 2026 19:51:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DC5D6B008A; Wed, 29 Apr 2026 19:51:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67C7A6B008C; Wed, 29 Apr 2026 19:51:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4DB566B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 19:51:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BCD5612021E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:51:44 +0000 (UTC)
X-FDA: 84713243328.12.5965F2D
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010024.outbound.protection.outlook.com [52.101.85.24])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6132E4000D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:51:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ZmDttkTy;
	spf=pass (imf17.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.85.24 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777506701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pzgml3/CIhemoYumDHOZSu6Wta3BAaZKnkuahnN2rT4=;
	b=2FAGj+B6CCyldXRofix89BVpXYcj0rpPIQaNDV5z/uBcF3izlWsRlXG8esr50hOROTtxhT
	I0u5dokZvIlzWp1S4A3nYj+mZ2h41dqCixs2L9vPQZ0FbVehqZiw5UO+f+JYJ7gbxyBDP7
	oGmtjgpqmVbQ1UdlZMpQEODEDaOKdeU=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ZmDttkTy;
	spf=pass (imf17.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.85.24 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777506701; a=rsa-sha256;
	cv=pass;
	b=Ae5vc9ChiDUsWdezES/x5PJtiVwqbak3fmrXftvOIg9Khje56WtZmZd4jptShyNOWHO4Ml
	phRUTqLPEZU4aPus3Z2XrjPSkDSKhQ9zWRF6FkvJP3zwJ39bFVIwmMZOUIMgtq4zSUG4r4
	Dbc3GBdYvO7EDTP7WuvBlF2buG7tkbE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R/ASMFYR4sN7D7GWnglIW/VxnwAX5qZ1/Ev/3Q5lKGEXHh5v19pBq4tSyfNMjU00wY4zH0Kn/dOydpf3hlD7JqE4iMtvQGbYK0n0SeBKCXweGPCigyrIKzKIZvYodfB9vMVXqpXPfqvJxe4+mv9YVILqrFaUDM3RQIInRx+IQO8QpDBcEhyttN02eVg2H8Ax7Mslu2BcDsr1nRmuF41birIQ4qbDMoq9nMLV6117Un+vSyb+LJch2U9YwOc8flV9VgTseke00kf28XXswGUQgKsYz9U5bSWdwsCLlBQrKm95KWFFgnu40KV13hFlZ2LeUEscQok3EGA2jJs6J9hRRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pzgml3/CIhemoYumDHOZSu6Wta3BAaZKnkuahnN2rT4=;
 b=ds7J3D2CJcu82RQQN5fRsEWYBrVM4waiZWWLZvLm5jjz27kUYlkYC1rL5XiwsVRZEceLXO8Mz+g6UGm+9i42MFaMiVAiNCLjRmJBODRRMeCYJKCVQ632SDVFWSJhuwWT+b41jByq+XGHHuw2b/U8CI+HIYawGe90QOraZkCXUx/yPCIqdqPP3gR14pJMsQCNL0EpwsOgoNkXw8YHDnaYGLu+PB+25Tz073tqK7FgihMmqlpSCprMmJ8mVZpJJHlXG2xtpqqRs7fMTD9RcoZYDrk5d/YR6toVE7zGiv2BE2y0UoVubdF4bvabPN4Irx8ndJ2bTETjZMdxNOKLtapGfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzgml3/CIhemoYumDHOZSu6Wta3BAaZKnkuahnN2rT4=;
 b=ZmDttkTymoeVV4N9fJxL6lOuZjoDx2qZH1P6ofYXq8LBEfGYuIPl1IGYArnuayiHjr9tjFCHoaooG30lTok3ROeFdq61EQBdyD4SqbdujpwgKaObWTvGSJbKErEBSGRJNMjuyw6DRs0Vh59rHhr6iqez8bIPxDEBNqYW93h11UU=
Received: from PH5P222CA0010.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:34b::11)
 by CH1PPFD8936FA16.namprd12.prod.outlook.com (2603:10b6:61f:fc00::624) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.21; Wed, 29 Apr
 2026 23:51:29 +0000
Received: from SN1PEPF0002BA50.namprd03.prod.outlook.com
 (2603:10b6:510:34b:cafe::69) by PH5P222CA0010.outlook.office365.com
 (2603:10b6:510:34b::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.30 via Frontend Transport; Wed,
 29 Apr 2026 23:51:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002BA50.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.18 via Frontend Transport; Wed, 29 Apr 2026 23:51:28 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 29 Apr
 2026 18:51:28 -0500
Date: Wed, 29 Apr 2026 18:51:13 -0500
From: Michael Roth <michael.roth@amd.com>
To: <ackerleytng@google.com>
CC: <aik@amd.com>, <andrew.jones@linux.dev>, <binbin.wu@linux.intel.com>,
	<brauner@kernel.org>, <chao.p.peng@linux.intel.com>, <david@kernel.org>,
	<ira.weiny@intel.com>, <jmattson@google.com>, <jthoughton@google.com>,
	<oupton@kernel.org>, <pankaj.gupta@amd.com>, <qperret@google.com>,
	<rick.p.edgecombe@intel.com>, <rientjes@google.com>, <shivankg@amd.com>,
	<steven.price@arm.com>, <tabba@google.com>, <willy@infradead.org>,
	<wyihan@google.com>, <yan.y.zhao@intel.com>, <forkloop@google.com>,
	<pratyush@kernel.org>, <suzuki.poulose@arm.com>, <aneesh.kumar@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt
	<rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, "Mathieu
 Desnoyers" <mathieu.desnoyers@efficios.com>, Jonathan Corbet
	<corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan
	<shuah@kernel.org>, "Vishal Annapurve" <vannapurve@google.com>, Andrew Morton
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
Subject: Re: [PATCH RFC v5 00/53] guest_memfd: In-place conversion support
Message-ID: <x7n77snnvvukofo3slopl74c5tmlb2t2un5qy5fq6eb3d2xt7e@6a6tixg5mdfc>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA50:EE_|CH1PPFD8936FA16:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c3368c2-8902-4747-d925-08dea64a3b89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|7416014|376014|13003099007|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	MfGB1iyYxvTCPsQwl/eTQ4rWfpfuJqrslpGQi++WsYb8idqKkYrZgWAo1uluLWmBuwtL13rbRRfrntjRh2aT/px1g+j7TQS2vutkBlfW+YgJPdlYqAedGdclV9U+P4izYod//2lz2fjKNL5mlI+6J1LIfYzX4rdNV6+Mr7sLJ6Srtr/0uLdbYHivlDKsM54PGGDNTZQlipug0dEusZsh2MzIARNwagkxjFqiIFqVa+gnUP9WyBp7RmpO6ExgHT06ozQO+ie6H7CvXatz0D/wOeXYtbbH9dQOTaTTpI6L07rPccNl/SSJp4Ms3sny0o2PoivrDbWQqdOrT0c61b9ZKBdFWsiaFAcSDha+xcS+qpXXzSkQIy/q+exjl9K7dDeZOULnRsg8ftLWOKpjn84CLvS3TZLyyBPSlpDD9PUX9jC4x8bCJn7tTCYVORInmXjUqCFEUuEq79Y+/2mA/RbDsTvueqy0r9Bv7DydijrPnajswd02v4mmiaoxqgqT46Kdu2COa465kmmGd2B9p/y2dSwx7pmVP8dQqLcZ2x1FNLfzs5tAzKzqgYm+b18UZAcngiZxy69iqyDnTMdY0YRtmJ2kEz7h5nMa38QoY8dP3q1z4YGl3FICmgZO/N2baJ/kkduASn49uZLTdXsxHmpPjvuIPdw0LdUIgh532QWu/BleNaeVzv1jANNXEzee/0LgNSZIdZXsivbzA+xI1fw4gGGBUml7brCGd8qF/lec9AY=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(7416014)(376014)(13003099007)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	l9+7gjfyQDK4+iYTnufPFwaQrRf4/9X0oyBU3rycw7EfK0LiTWwvGqnaCyNte26lj9fkORqdCWchCY81Awx3Rl97E67k7QEcg6fAZ0iIMy+dZLzQnfkkhVuWJpI06oVj2nzkdfza8JNUv6R6wIHVqetJMaz0d2nNINLUFYlWMvlqcYLI8MaAcf+hWLlS1MkEftW3uO1Fq9jomiEjMpBwbpqFuZzYbjBiOOrASLBjO0ZGMqFa2LN9gLKZUNEUXzI9P5v8Kcxa8cD3i3Y/cKgm7bpVzcGO3AfwvNelXxADKeoDgN56DRJ5iBwQYEoALqcTwC5S32/0TZhmVIiC7GfrekxcIGXXAMGF3ld3OVt220aFmGzM6HcqnH+FCmzFCGWaEUiN2Vtg6gsrvEfpwajY1/CdzK/4xok/aG+2YX4Nd7q2fVTgI17iEsOSobeAFmtN
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 23:51:28.9208
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c3368c2-8902-4747-d925-08dea64a3b89
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA50.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPFD8936FA16
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6132E4000D
X-Rspam-User: 
X-Stat-Signature: 54rgwyx8ym9jmstqcxn4p91kzpj95hdk
X-HE-Tag: 1777506701-675891
X-HE-Meta: U2FsdGVkX1/TJYDjDIHb0H28H3GWD60fUK6inrS0PardX7tzEXG1p2INNtSpfYUS+1zcXdXX03gjcHTNEd9VMNkMv/d4zrB5WraUudlybIuFUHkECSQInscr9jGPmUqvtsnn5FHm8Yqtepw67C1eq79ueLFNN3aqUklHhBNddvJgIu2WjGbokNqEkQzXAlUzswA0LAOSbq1pLGJHlTdPmnJYXKl923iV8ZIf3mp468SkvU7NwbdL+VChttAAKR4gxrGbTf6U9dCoqeeSqoKHNbRSgv13mf9H9yZNvdg41+Yz/9wOggWCxfxBGmmkgmeSENFO2MfkMwFdm2+pyGizbjsb0UF+iz6d8K1fZ3FZyH2k0WIxfgAzW4KSpJ677RdVw4mtCuG+4sB6nczH3HqpI4iOXc25Yn+gYacePN1lfMnUG2ecRpBnbNEqbSwuUHOI6c0NUZfw0O3rWwvQsIwLLLxs6fbnYMMA/Pl7ybYb++v5a5lg77dGa3m6p1Bs+Xi5FIhzDETHbUPnPVcNhV1lMAsNHpGRmSI5E8LyQGs/Bh3WwweB1cn0CuCZs3HDVcRyP/9JkAL0JuWs3p6jJ4Q5kLDYBHt+N8P9EVjGDIX5YWpBgd0I8eZ4vhM0YE735Rswtf6NxqTLPsw0Yt1qQoMb5gJ7V66oBRFuhiBoF+v0BVM28jaZQzCvZsAbS5H9qssFbt7pNKJNwkMH56RE4646083NJf3WlzGOg+18pmj+KCqvuUM5Xv8xIwDTUezFerB+yp4q4qPuBHrXEBQ7nn1DF/HccU/jK3E3SySCoML0eISrfPX9MTQ+szWQ0eKK8G/FweE/hmN1m1YKct8ipbX05P6+JFQiTSSENmyqFh76NJNQKYmc4HPSHvpyB2JcC+S0peX7K/y5dO6cWYEeD/hjjNvlwr0q3B6TtzePocAmXfWp+U18pwEUpSWgdrjy17GyEXf3IyHCnoqYl8Bi3Mt
 /S+u70xX
 WfDVnc0XqKJSoYR4rej0k9WW2Ht8Os09qiJIqiSne0o8+9fvhpcarAEcpTg9ZknQRvNGbrHp4spv5pyzCvGZonLxlLm7sUIQNp+5n/yVp7uYjE1RJZApp5/HltEvwpcstg/R96AYiVapDZNJEpAPonW9I0uIrTTAWXgxakeBSNDQbIXO6oOSL/FUvgADjlvsDh+halC8y6k1DLc4cIEkxCz0TdxqDRZURSmDlKQhJ5unrH5SUb4lr470+1O6yQUAsVKQkH8GR2kLOxNrtgE2XEQF204ZLkf3tsLP5X/VVms9/Ksis3mjKJnnogmFiBflwXT0VAHNt9WnbyFn3vs2naMgOAML/c62GgaoLWjOP3dmOQDexsXVTiacgdsKtndPwG+m598q9wlf44zfcr1vOx47YUHC9gfU8rFxVBRYYjKMSKnR9GAA1RWSQiJHNVystyYrl7b1xF4mKqfXFOQBtG90cXmw43AOitK7BKul44aGis6qFUyqhs0EJPFit2a/ul1UIaJS9uIk4e/tT7rMjD/blHEAIsWqrQC87T1yvwWjDhDyK7wDPDsLdSC4EqYNyqUy+2g+1AjOA5uDtP6aHsQDjfBDP4icmM2z6dJEkKGagjlfOPzpYkUF623GiLouAX9VJa1/aLY5c4WuP12FYWZfIYpMxpXYe3g/waKpD0VF/qADmHOCwhiRECnRoWWPmgRTlxOUctWYCY0/OyZGYmM1W2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 04:24:55PM -0700, Ackerley Tng via B4 Relay wrote:
> [Some people who received this message don't often get email from devnull+ackerleytng.google.com@kernel.org. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> This is RFC v5 of guest_memfd in-place conversion support.
> 
> Up till now, guest_memfd supports the entire inode worth of memory being
> used as all-shared, or all-private. CoCo VMs may request guest memory to be
> converted between private and shared states, and the only way to support
> that currently would be to have the userspace VMM provide two sources of
> backing memory from completely different areas of physical memory.
> 
> pKVM has a use case for in-place sharing: the guest and host may be
> cooperating on given data, and pKVM doesn't protect data through
> encryption, so copying that given data between different areas of physical
> memory as part of conversions would be unnecessary work.
> 
> This series also serves as a foundation for guest_memfd huge page
> support. Now, guest_memfd only supports PAGE_SIZE pages, so if two sources
> of backing memory are used, the userspace VMM could maintain a steady total
> memory utilized by punching out the pages that are not used. When huge
> pages are available in guest_memfd, even if the backing memory source
> supports hole punching within a huge page, punching out pages to maintain
> the total memory utilized by a VM would be introducing lots of
> fragmentation.
> 
> In-place conversion avoids fragmentation by allowing the same physical
> memory to be used for both shared and private memory, with guest_memfd
> tracks the shared/private status of all the pages at a per-page
> granularity.
> 
> The central principle, which guest_memfd continues to uphold, is that any
> guest-private page will not be mappable to host userspace. All pages will
> be mmap()-able in host userspace, but accesses to guest-private pages (as
> tracked by guest_memfd) will result in a SIGBUS.
> 
> This series introduces a guest_memfd ioctl (not kvm, vm or vcpu, but
> guest_memfd ioctl) that allows userspace to set memory
> attributes (shared/private) directly through the guest_memfd. This is the
> appropriate interface because shared/private-ness is a property of memory
> and hence the request should be sent directly to the memory provider -
> guest_memfd.
> 
> Tested with both CONFIG_KVM_VM_MEMORY_ATTRIBUTES enabled and disabled:
> 
> + tools/testing/selftests/kvm/guest_memfd_test.c
> + tools/testing/selftests/kvm/pre_fault_memory_test.c
> + tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> + tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> + tools/testing/selftests/kvm/x86/private_mem_conversions_test.sh
> + tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
> 
> Updates for this revision:
> 
> + For TDX and SNP, PRESERVE supported only before VM is finalized only for
>   to_private conversions.
>     + This allows PRESERVE to be used as part of the VM memory
>       loading/encryption flow
>     + Only support PRESERVE for to_private conversions (to_shared on
>       populated memory on TDX would cause zeroing)
>     + Relaxed constraints for SNP and TDX to allow NULL to be passed as
>       source address.
> + Dropped KVM_CAP_MEMORY_ATTRIBUTES2. KVM_CAP_MEMORY_ATTRIBUTES reports
>   attributes supported by the KVM_SET_MEMORY_ATTRIBUTES VM ioctl, and
>   KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES reports attributes supported bt the
>   KVM_SET_MEMORY_ATTRIBUTES2 guest_memfd ioctl.
>     + KVM_SET_MEMORY_ATTRIBUTES2 is not supported by the VM ioctl
> + Resolve locking issue when kvm_gmem_get_attribute() is called from
>   kvm_mmu_zap_collapsible_spte() by bugging the VM. guest_memfd memslots
>   don't support dirty tracking, so the locking issue is not on an
>   accessible code path.
> + Moved guest_memfd_conversions_test.c to only be compiled and tested for
>   x86, since it depends so heavily on KVM_X86_SW_PROTECTED_VM's as a
>   testing vehicle
> 
> TODOs
> 
> + Perhaps further clarify PRESERVE flag: [8]

I made a super-long-winded reply to that thread, but to summarize:

PRESERVE flag has different enumeration/behavior/enforcement for pre-launch
vs. post-launch, and similar considerations might come into play for
other flags, so to make it easier to enumerate what flags are available
for pre-launch/post-launch, maybe we could have 2 capabilities instead
of 1:

  KVM_CAP_MEMORY_ATTRIBUTES2_PRE_LAUNCH_FLAGS
  KVM_CAP_MEMORY_ATTRIBUTES2_FLAGS

where SNP/TDX would only advertise PRESERVE for PRE_LAUNCH, and pKVM I
guess would enumerate it for both (or maybe just POST_LAUNCH?)

That lets us keep the flags definitions more straightforward but still
allows userspace to easily enumerate what exactly should be available at
pre vs. post launch time, and give us some flexibility to detail
variations in behavior between the 2 phases without documenting
edge-cases in terms of VM types.

> + Resolve issue where guest_memfd_conversions_test, which uses the
>   kselftest framework, doesn't perform teardown on assertion
>   failure. Please see proposal at [9]
> + Test with TDX selftests. We're in the process of rebasing TDX selftests
>   on this series and will post updates when that's tested.
> 
> I would like feedback on:
> 
> + Content modes: 0 (MODE_UNSPECIFIED), ZERO, and PRESERVE. Is that all
>   good, or does anyone think there is a use case for something else?
> + Should the content modes apply even if no attribute changes are required?
>     + See notes added in "KVM: guest_memfd: Apply content modes while
>       setting memory attributes"

Looking at the example you have there:

  + Note: These content modes apply to the entire requested range, not
  + just the parts of the range that underwent conversion. For example, if
  + this was the initial state:
  + 
  +   * [0x0000, 0x1000): shared
  +   * [0x1000, 0x2000): private
  +   * [0x2000, 0x3000): shared
  + and range [0x0000, 0x3000) was set to shared, the content mode would
  + apply to all memory in [0x0000, 0x3000), not just the range that
  + underwent conversion [0x1000, 0x2000).

Userspace would be aware of whether the range contains pages that were
already set to private, so if it really wants to set the just the
[0x1000, 0x2000) range to shared with appropriate content mode, it is
fully able to do so by just issuing the ioctl for that specific range.
If it attempts to issue it for the entire range, it only seems like it
would defy normal expectations and cause confusion to skip ranges, and
I'm not sure it gains us anything useful in exchange for that potential
confusion.

>     + Possibly related: should setting attributes be allowed if some
>       sub-range requested already has the requested attribute?

As it is now, userspace has that capability (to use finer-grained ranges
if it doesn't want to re-issue unecessary/unwanted conversions), similar
to above. And KVM internally will just issue kvm_arch_gmem_prepare()
calls so that architecture-specific handling can deal with this case
(e.g. SNP's sev_gmem_prepare() already checks if the corresponding
attribute is set in the RMP table and just skips it otherwise). So I
don't think we really gain anything but added complexity if we try to
make gmem more selective about it.

-Mike

> + Structure of how various content modes are checked for support or
>   applied? I used overridable weak functions for architectures that haven't
>   defined support, and defined overrides for x86 to show how I think it would
>   work. For CoCo platforms, I only implemented TDX for illustration purposes
>   and might need help with the other platforms. Should I have used
>   kvm_x86_ops? I tried and found myself defining lots of boilerplate.
> + The use of private_mem_conversions_test.sh to run different options in
>   private_mem_conversions_test. If this makes sense, I'll adjust the
>   Makefile to have private_mem_conversions_test tested only via the script.
> 
> This series is based on kvm/next, and here's the tree for your convenience:
> 
> https://github.com/googleprodkernel/linux-cc/commits/guest_memfd-inplace-conversion-v5
> 
> Older series:
> 
> + RFCv4 is at [7]
> + RFCv3 is at [6]
> + RFCv2 is at [5]
> + RFCv1 is at [4]
> + Previous versions of this feature, part of other series, are available at
>   [1][2][3].
> 
> [1] https://lore.kernel.org/all/bd163de3118b626d1005aa88e71ef2fb72f0be0f.1726009989.git.ackerleytng@google.com/
> [2] https://lore.kernel.org/all/20250117163001.2326672-6-tabba@google.com/
> [3] https://lore.kernel.org/all/b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com/
> [4] https://lore.kernel.org/all/cover.1760731772.git.ackerleytng@google.com/T/
> [5] https://lore.kernel.org/all/cover.1770071243.git.ackerleytng@google.com/T/
> [6] https://lore.kernel.org/r/20260313-gmem-inplace-conversion-v3-0-5fc12a70ec89@google.com/T/
> [7] https://lore.kernel.org/all/20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com/T/
> [8] https://lore.kernel.org/all/CAEvNRgGbMhkX310CkFY_M5x-zod=BDTiuznrZ0XvFPUK7weL1A@mail.gmail.com/
> [9] https://lore.kernel.org/all/20260414-selftest-global-metadata-v1-0-fd223922bc57@google.com/T/
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
> Ackerley Tng (34):
>       KVM: x86/mmu: Bug the VM if gmem attributes are queried to determine max mapping level
>       KVM: guest_memfd: Update kvm_gmem_populate() to use gmem attributes
>       KVM: guest_memfd: Only prepare folios for private pages
>       KVM: Move kvm_supported_mem_attributes() to kvm_host.h
>       KVM: guest_memfd: Add basic support for KVM_SET_MEMORY_ATTRIBUTES2
>       KVM: guest_memfd: Ensure pages are not in use before conversion
>       KVM: guest_memfd: Call arch invalidate hooks on conversion
>       KVM: guest_memfd: Return early if range already has requested attributes
>       KVM: guest_memfd: Advertise KVM_SET_MEMORY_ATTRIBUTES2 ioctl
>       KVM: guest_memfd: Handle lru_add fbatch refcounts during conversion safety check
>       KVM: guest_memfd: Use actual size for invalidation in kvm_gmem_release()
>       KVM: guest_memfd: Determine invalidation filter from memory attributes
>       KVM: guest_memfd: Introduce default handlers for content modes
>       KVM: guest_memfd: Apply content modes while setting memory attributes
>       KVM: x86: Support SW_PROTECTED_VM in applying content modes
>       KVM: TDX: Make source page optional for KVM_TDX_INIT_MEM_REGION
>       KVM: x86: Support SNP and TDX applying content modes
>       KVM: x86: Bug CoCo VM on page fault before finalizing
>       KVM: Add CAP to enumerate supported SET_MEMORY_ATTRIBUTES2 flags
>       KVM: selftests: Test basic single-page conversion flow
>       KVM: selftests: Test conversion flow when INIT_SHARED
>       KVM: selftests: Test conversion precision in guest_memfd
>       KVM: selftests: Test conversion before allocation
>       KVM: selftests: Convert with allocated folios in different layouts
>       KVM: selftests: Test that truncation does not change shared/private status
>       KVM: selftests: Test conversion with elevated page refcount
>       KVM: selftests: Test that conversion to private does not support ZERO
>       KVM: selftests: Support checking that data not equal expected
>       KVM: selftests: Test that not specifying a conversion flag scrambles memory contents
>       KVM: selftests: Reset shared memory after hole-punching
>       KVM: selftests: Provide function to look up guest_memfd details from gpa
>       KVM: selftests: Make TEST_EXPECT_SIGBUS thread-safe
>       KVM: selftests: Update private_mem_conversions_test to mmap() guest_memfd
>       KVM: selftests: Add script to exercise private_mem_conversions_test
> 
> Michael Roth (1):
>       KVM: SEV: Make 'uaddr' parameter optional for KVM_SEV_SNP_LAUNCH_UPDATE
> 
> Sean Christopherson (18):
>       KVM: guest_memfd: Introduce per-gmem attributes, use to guard user mappings
>       KVM: Rename KVM_GENERIC_MEMORY_ATTRIBUTES to KVM_VM_MEMORY_ATTRIBUTES
>       KVM: Enumerate support for PRIVATE memory iff kvm_arch_has_private_mem is defined
>       KVM: Stub in ability to disable per-VM memory attribute tracking
>       KVM: guest_memfd: Wire up kvm_get_memory_attributes() to per-gmem attributes
>       KVM: Move KVM_VM_MEMORY_ATTRIBUTES config definition to x86
>       KVM: Let userspace disable per-VM mem attributes, enable per-gmem attributes
>       KVM: guest_memfd: Enable INIT_SHARED on guest_memfd for x86 Coco VMs
>       KVM: selftests: Create gmem fd before "regular" fd when adding memslot
>       KVM: selftests: Rename guest_memfd{,_offset} to gmem_{fd,offset}
>       KVM: selftests: Add support for mmap() on guest_memfd in core library
>       KVM: selftests: Add selftests global for guest memory attributes capability
>       KVM: selftests: Add helpers for calling ioctls on guest_memfd
>       KVM: selftests: Test that shared/private status is consistent across processes
>       KVM: selftests: Provide common function to set memory attributes
>       KVM: selftests: Check fd/flags provided to mmap() when setting up memslot
>       KVM: selftests: Update pre-fault test to work with per-guest_memfd attributes
>       KVM: selftests: Update private memory exits test to work with per-gmem attributes
> 
>  Documentation/virt/kvm/api.rst                     | 139 ++++-
>  .../virt/kvm/x86/amd-memory-encryption.rst         |  19 +-
>  Documentation/virt/kvm/x86/intel-tdx.rst           |   4 +
>  arch/x86/include/asm/kvm_host.h                    |   2 +-
>  arch/x86/kvm/Kconfig                               |  15 +-
>  arch/x86/kvm/mmu/mmu.c                             |  20 +-
>  arch/x86/kvm/svm/sev.c                             |  18 +-
>  arch/x86/kvm/vmx/tdx.c                             |   8 +-
>  arch/x86/kvm/x86.c                                 | 145 ++++-
>  include/linux/kvm_host.h                           |  74 ++-
>  include/trace/events/kvm.h                         |   4 +-
>  include/uapi/linux/kvm.h                           |  21 +
>  mm/swap.c                                          |   2 +
>  tools/testing/selftests/kvm/Makefile.kvm           |   5 +
>  tools/testing/selftests/kvm/include/kvm_util.h     | 141 ++++-
>  tools/testing/selftests/kvm/include/test_util.h    |  34 +-
>  .../selftests/kvm/kvm_has_gmem_attributes.c        |  17 +
>  tools/testing/selftests/kvm/lib/kvm_util.c         | 130 +++--
>  tools/testing/selftests/kvm/lib/test_util.c        |   7 -
>  tools/testing/selftests/kvm/lib/x86/sev.c          |   2 +-
>  .../testing/selftests/kvm/pre_fault_memory_test.c  |   4 +-
>  .../kvm/x86/guest_memfd_conversions_test.c         | 552 +++++++++++++++++++
>  .../kvm/x86/private_mem_conversions_test.c         |  55 +-
>  .../kvm/x86/private_mem_conversions_test.sh        | 128 +++++
>  .../selftests/kvm/x86/private_mem_kvm_exits_test.c |  38 +-
>  virt/kvm/Kconfig                                   |   3 +-
>  virt/kvm/guest_memfd.c                             | 591 ++++++++++++++++++++-
>  virt/kvm/kvm_main.c                                |  87 ++-
>  28 files changed, 2075 insertions(+), 190 deletions(-)
> ---
> base-commit: 39f1c201b93f4ff71631bac72cff6eb155f976a4
> change-id: 20260225-gmem-inplace-conversion-bd0dbd39753a
> 
> Best regards,
> --
> Ackerley Tng <ackerleytng@google.com>
> 
> 

