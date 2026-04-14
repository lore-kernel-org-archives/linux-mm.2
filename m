Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08859F9D0FB
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 23:38:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F105D6B0088; Tue, 14 Apr 2026 19:38:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9A306B0089; Tue, 14 Apr 2026 19:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3B1A6B0092; Tue, 14 Apr 2026 19:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE4346B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 19:38:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 697941A02CD
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:38:39 +0000 (UTC)
X-FDA: 84658778358.24.7037EBA
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012030.outbound.protection.outlook.com [52.101.43.30])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3D673C0003
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:38:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=kxl0BsN0;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.43.30 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776209916; a=rsa-sha256;
	cv=pass;
	b=cNoLmpVz8rjXQFU3eyfJlKlXArGjp0febKShGv+U1NRik0VyZhSfvrvjaIvzMJ50OfFkvM
	4wVynqlIxVNaycIeBePSGe2SYduGlHP//9qnIiyozKe8DovBHrf2HnvjYMAg3rSwzWY93e
	UtX+7R7ggffiC0IOhzooW+m9W06/zNo=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=kxl0BsN0;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.43.30 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776209916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uQZV6DXglvF+U23BzePtiGc0FKpBMuAPNbSOWy2UM74=;
	b=YqyZtQFK521zNYMyNvS5TU5oN1AxFoeB994oic2fUQOHGAZQ81SOgjQ9wDyfXcVWzQre0/
	k/8X+pDC3mW+5GIH4dCglPHImRprMIjoWrgSsBcDJhPuU9WbSC3uvbG/98IT2+axUHHIr5
	U2z1qw6KijGTZDV9HclK06cLrkEftfc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AfY+AS2Q2Nue+D6Li89mh5eRfH2MpTj6BtFgwoaSzfY5TE8f1xwQ1/7PlVQJqJy7az54ZdC/bCCLTh5j2IykGn+BtuL2XmlHrZ81wFW/3SVMHsfsXieSQZ9KFJxt61Ay1FyfMf+vsYBN2MbzgoHiASIZiCasWDDhuquKtNp1k+ivz7iSKh0UjOsENgUWjmGMYno8uNYbTyJ3N1sjeHsZ+Wfi2ahNXjfNPXYsRykSDlxThW0vx2G3hb9yu/1b+bauVeSSMKWI3kElZfqV58kpHqMmu718I5U/2wEnlfZKn88bchUrsoF1VgOP5oEtMkqd4CW/iiOHmEEvi8zEWwIVZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uQZV6DXglvF+U23BzePtiGc0FKpBMuAPNbSOWy2UM74=;
 b=a+9RiFdmrImikg+XJDUsyLTZc2EHf8cGdaKO0EzGxm/RDNdQFuE9+8gyW23UVsD7c58F0KddAVI2m2whuY8NBbWbElwVS3s3Unj35x4iEhuPaYC0iu/hf9p0nesTzwihld6Sh0BGXy9Dj6DE7cgREMzun80gWwMNuzJlsUG3vC1k/MGKEd0QgaOFVQaehHy5/HwWjNzdUodp3BtXGvhlTteyVe8vEZaPl4y/+4oiKNz7CJPW0R7HjhUVTNfBzQZ1JqAp7UCk19d4dQpUWAHXp5AftKpN6K5QuvIyvysKjyNkmg3Px9/zPzjtKUHII2hmSyr/9omM4New05oXg2uw+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQZV6DXglvF+U23BzePtiGc0FKpBMuAPNbSOWy2UM74=;
 b=kxl0BsN0LPYzov225g2HuHphtIZ8OjkpPBwOKtGOWXurxRKgfTNE7qgm58iaipglQiEMMi0wedwHOpBn6lJTf6X0hAYBR1md7goZOuKjclGrWMrV3040qYe/rI8o91JIF1QSuiPgaLgGMfEovFauoLfVzQeXwcSOxW7LBpNU2lk=
Received: from PH7P221CA0076.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:328::32)
 by DS7PR12MB6167.namprd12.prod.outlook.com (2603:10b6:8:98::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Tue, 14 Apr
 2026 23:38:27 +0000
Received: from CY4PEPF0000EDD3.namprd03.prod.outlook.com
 (2603:10b6:510:328:cafe::31) by PH7P221CA0076.outlook.office365.com
 (2603:10b6:510:328::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.49 via Frontend Transport; Tue,
 14 Apr 2026 23:38:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EDD3.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Tue, 14 Apr 2026 23:38:27 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 14 Apr
 2026 18:37:25 -0500
Date: Tue, 14 Apr 2026 18:37:00 -0500
From: Michael Roth <michael.roth@amd.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <aik@amd.com>, <andrew.jones@linux.dev>, <binbin.wu@linux.intel.com>,
	<brauner@kernel.org>, <chao.p.peng@linux.intel.com>, <david@kernel.org>,
	<ira.weiny@intel.com>, <jmattson@google.com>, <jroedel@suse.de>,
	<jthoughton@google.com>, <oupton@kernel.org>, <pankaj.gupta@amd.com>,
	<qperret@google.com>, <rick.p.edgecombe@intel.com>, <rientjes@google.com>,
	<shivankg@amd.com>, <steven.price@arm.com>, <tabba@google.com>,
	<willy@infradead.org>, <wyihan@google.com>, <yan.y.zhao@intel.com>,
	<forkloop@google.com>, <pratyush@kernel.org>, <suzuki.poulose@arm.com>,
	<aneesh.kumar@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Sean
 Christopherson" <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
	<mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song
	<baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
	<yuanchu@google.com>, Wei Xu <weixugc@google.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>
Subject: Re: [PATCH RFC v4 10/44] KVM: guest_memfd: Add support for
 KVM_SET_MEMORY_ATTRIBUTES2
Message-ID: <eiiecl7jvywvqb4drq7cchmcabcrdka25wxr77uavxqineeedm@rfcnhdz6xoxf>
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
 <20260326-gmem-inplace-conversion-v4-10-e202fe950ffd@google.com>
 <2r4mmfiuisw26qymahnbh2oxqkkrywqev477kc4rlkcyx7tels@c7ple7kdgpo3>
 <CAEvNRgFkusZeKxGctUpTTbYjdi7nZL1ZZar-gT7XRUOCZ2xtpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEvNRgFkusZeKxGctUpTTbYjdi7nZL1ZZar-gT7XRUOCZ2xtpw@mail.gmail.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD3:EE_|DS7PR12MB6167:EE_
X-MS-Office365-Filtering-Correlation-Id: cd1c4a6f-9fa0-4503-5b46-08de9a7eed4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700016|18002099003|56012099003|22082099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	PbBhOMyNNmD5llc6UmW++rxqCagqLoVd9lhHyyhsLCKCLED7oe0NmHrqzbyBxrTnuRyHGfiYFx40k06a3WL0CRr/zBQ36Ea5g2CsC/fe+nV+Qz7rzGEk7uBOR57akzzy1kGCwZryK6077qi83U1Wfpjhp/M1kStIh5tu+5OLLkTyuIrC7C2rbieDtViFbJ580SzFAvT9VfJxecxpZFEQo5alDYJARb3D//kfhIF0IeeRc2ezyxgbF8hC9VrxIW7J3fiPcbcZIXpWypdyqqk26reEQEJW8+Sk4w6DgCQ3X6D8Y8EJzclwu/OlDnfDH8QWwGAz4tbZrgdtUZ5zcrcYtfpANb+wskKzH7iBGqQFqpKF3gwLo8yenFMJaZcCRVcUn5AnfV9QIYQUdKXoEuS2KrwgFo7EP5y7zjL8eMrnaUbLWxlPwb6TUgpMV/HNWFbnFkjvrZchRJ4PPSeQ/CiQCO8fYEaH6V0yGzA8H/3jaJaDg9XK3UJujd6t0lncrYWBuh7UHFm5EWzWom0S2ob7DtDrS+E6a28eUz6v1//aO9WYAzGqOCws/w9aTrzZkPOb0jUtJrzHbP6ULeB8SNQhr7IgBH1uve2AlqhyoGMvBGRviz1x/IxXdQj/NOJUvYZIksyBkKJv7NhVZV/ZiSRb20KQMpmah8yt/DYhvR3dlUl68/NW+m89JhAUJY1J1qmgX9RLKFpPiJFoN6jEuK3rwaM8tgKZSDkyKCch1CD5cGVNMgl6Xvub6K5F2NI7nlQn39TjQrDsPJRNf+6Qzd1NHEZugMg0GWqoD59wLivnHrA=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700016)(18002099003)(56012099003)(22082099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	d9hGQy/bRYA2R7+0jF4qfJY6DLe7JA3LpOTCg/lzsMSZK9U3EBnTLnbkFB/hQGMFYtdTobJNHRSas9Q151SGzyZ1x+Eu8rss7hXk3M/OjWAGQzEVMvp0EXpBbnWOaxm2x9/RDzsEulBKh06befZZz7p98qGjiw87KtQ2dtxLbvEGFXuKIaJ8fKDTEzi8j0AkJ75Mv05GdSOnYHVHF6rxcFcNGEFr1sGa3+1dgolIolt4qWFqLx+RW4HKxLh+NOn39B2Ht2tkQaKRKQaBuameb3XDptCIQHePoqVcPv2OIun5b0Goh0QhCKDpWUJmhymMRv120YAEAjZGeo262ap+AtPT8UpO0fbPn51qxB8E6Qh8GbyBoo94rlCS9nLZ3ZSiCOnMGtKfWUVaZlw75I1hQ9PzA2FFOvGiz7J4lIXDXLTs4SGMRjq0hpz6dHFi4d/G
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 23:38:27.0133
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd1c4a6f-9fa0-4503-5b46-08de9a7eed4d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6167
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3D673C0003
X-Stat-Signature: rb6mmt7tukeo63i5fho7qkc8nc6a11qh
X-HE-Tag: 1776209916-756785
X-HE-Meta: U2FsdGVkX19KRkSw9+8s3ehVonHCtXu/VxUPqCkIxU0XuxYpqwp3akw6tWjAPujnpeD56PoZqtLyQT9dDtvBMHGP5/4i1aZkEGHI+63WNsuUAFAEC+hfgUoa3vPfPr5h3lEBNPBx9NDbTvpvVclIj0kPLHqrp31sXKlMPmsdBwLV7vK3TBeptfYs/cwdvlCyE7m6TP3lGOy/DJzgvjn/3tdS4POvt+wwYYARruOzIBLUG0eDsJfIC31/2R/3QGRtH/gv2X8SAgrR4SZjGd3DPw34IuDkyPfrYm5BEy3qmN0EcU3RcBZUj/gqHYjJ6NS3YVtXVYMQ6VPB1RzDbhWJ3lDNSRJKBY/7Lc3hLC/r+FedSaBHP5zpuN4ceZtC5GDMOWiGV8JNWsgmo1sqB3nU8gcamavKyhPc+gt6K9l1BDIuoJ3gm8+2EEPHrsnXiXK8kTJiv1SHmVA8kE7kPQ3zGYR2Tc8X6fwxhNKsu0gWxXVzzqJiaN2Ij537V6xwcHB4jgX5DIWPKR0jQkOR1NHQIm+XHjnkvzHo2e06d1SJpKv+maTJt2W5eZi4yTrFS7hAi5Ooyt8MEZKFaNJtLrJzqi5LzanCKDdqaevDIHs2vSJk9/RjWcPn0qKwx1l+PumVf2fUpzAhWy6ZIhu2ouemBv4bawZwMGE4rUwMykdzVEpyfSPTd9QP8zUNhr28+64RFvtbEw6Zl1EhImo170BLJqjUWCSuYdHD95NS0fn7SlEH+DYYqRiH8shPGTJ1AUeOC4ihxMeuQBR+n9RL4YLfOiDvZ/yFwbQ7tYk5lHUh3wNUgJ+byoSYXGVwkE9+r4R/2QGyFdxqtXiyHz2R/CdHx8Ip5x8MBYRgSNx+ST7zmg2Vxz5nKU26PUMIVn4Zf13A5HQbcX9rO5O/x0csjO0A4NH73JVP29193PSmobAHKE5vo2DPfrF4o5JpveKP+Pqj2ent8rtSMneL2K8BT6/
 1NykFs8P
 j9L+bEAAKctXmhLBdyRlFKkRsqFbq5BurkC/JBfqmJOnsO3qlK7jR/RxMGBzOjGPuHfhuMeS1KenvG35QF1G4FXVJ6byjgGvkJF5/2JVcErdPnHqgOGc7P4NmeDFndRZRN6aAqadY4+twqHtflDm8m2CqTjLmnMrqDI6Le6NFGqhZrm7AU0uM0qMPyppNepRpEbaaR3GrBQ3tLMr0zXL1hfaDw/216deiGWkJIIOVFnesi16NwgZr09NgCrPuA9Hfus5BgO83SvAO4ob/e4gPl+IxYtyNowQKU79F9RRAjMHMfK1kYM8vaxllqaE4FM4Ejk06BYRYTczzR1Q4y+p2TFpV5Mnv6tri9oxdm2MWYyfZLFdeh2DBeaHgqyaAe0bDEuTR3MPRB68VXNWUZ43R455fxjUp/4CciiDxZo6tsBPlOM0lPO0QFySXeWOhKHafPFoAnjediNihZc9SYsbDS5IEfqBi9Z/nQMR1o/KAYEfQ5idKNArzCE8PTdWa5/g07ulxC2KLOFOl7Gr9NCQfazYm695L4e5U0q6Gb6d6U7e6Z+jOba7Yf3BUzEghCdoR+sv90URmecHFRYUPXOY1JQgSEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 03:38:12PM -0700, Ackerley Tng wrote:
> Michael Roth <michael.roth@amd.com> writes:
> 
> >
> > [...snip...]
> >
> >>  static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
> >>  {
> >> @@ -2635,6 +2625,8 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
> >>  		return -EINVAL;
> >>  	if (!PAGE_ALIGNED(attrs->address) || !PAGE_ALIGNED(attrs->size))
> >>  		return -EINVAL;
> >> +	if (attrs->error_offset)
> >> +		return -EINVAL;
> >>  	for (i = 0; i < ARRAY_SIZE(attrs->reserved); i++) {
> >>  		if (attrs->reserved[i])
> >>  			return -EINVAL;
> >> @@ -4983,6 +4975,11 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
> >>  		return 1;
> >>  	case KVM_CAP_GUEST_MEMFD_FLAGS:
> >>  		return kvm_gmem_get_supported_flags(kvm);
> >> +	case KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES:
> >> +		if (vm_memory_attributes)
> >> +			return 0;
> >> +
> >> +		return kvm_supported_mem_attributes(kvm);
> >
> > Based on the discussion from the PUCK call this morning,
> 
> Thanks for copying the discussion here, I'll start attending PUCK to
> catch those discussions too :)
> 
> > it sounds like it
> > would be a good idea to limit kvm_supported_mem_attributes() to only
> > reporting KVM_MEMORY_ATTRIBUTE_PRIVATE if the underlying CoCo
> > implementation has all the necessary enablement to support in-place
> > conversion via guest_memfd. In the case of SNP, there is a
> > documentation/parameter check in snp_launch_update() that needs to be
> > relaxed in order for userspace to be able to pass in a NULL 'src'
> > parameter (since, for in-place conversion, it would be initialized in place
> > as shared memory prior to the call, since by the time kvm_gmem_poulate()
> > it will have been set to private and therefore cannot be faulted in via
> > GUP (and if it could, we'd be unecessarily copying the src back on top
> > of itself since src/dst are the same).
> 
> Could this be a separate thing? If I'm understanding you correctly, it's
> not strictly a requirement for snp_launch_update() to first support a
> NULL 'src' parameter before this series lands.

I think we are already sync'd up on this during PUCK, but for the benefit
of others: Sean pointed out that if we don't then we'll need to add yet
another capability so userspace can determine when it can actually do
in-place conversion for SNP.

Right now, this series effectively advertises in place conversion at the
point where KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES reports
'KVM_MEMORY_ATTRIBUTE_PRIVATE', so I slightly reworked the series to
include the snp_launch_update() change prior to that point in time in
the series. Thanks to prereqs and changes/requirements you've already
pulled in, it's just one additional patch now:

 KVM: SEV: Make 'uaddr' parameter optional for KVM_SEV_SNP_LAUNCH_UPDATE 

I also did some minor updates (prefixed with a "[squash]" tag) to advertise
the KVM_SET_MEMORY_ATTRIBUTES2_PRESERVED flag so it can be used by
userspace for SNP/TDX in the kvm_gmem_populate() path as agreed upon
during PUCK.

The branch is here, with the patches moved to where I think they
should remain (or be squashed in for the [squash] ones):

  https://github.com/AMDESE/linux/commits/guest_memfd-inplace-conversion-v4-snp2/

I've also updated the QEMU patches to use the agreed-upon API flow and
pushed them here:

  https://github.com/AMDESE/qemu/commits/snp-inplace-for-v4-wip2/

To start an SNP guest with in-place conversion:

  qemu-system-x86 \
  -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
  -object sev-snp-guest,id=sev0,...,convert-in-place=true \
  -object memory-backend-memfd,id=ram1,size=16G,share=true,reserve=false

To start an normal non-CoCo guest backed by guest_memfd with shared memory:

  qemu-system-x86 \
  -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
  -object memory-backend-memfd,id=ram1,size=16G,share=true,reserve=false

Thanks,

Mike

