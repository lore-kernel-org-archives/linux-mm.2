Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6448CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 16:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 198298E0017; Fri,  7 Nov 2025 11:12:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 148A28E0002; Fri,  7 Nov 2025 11:12:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F04278E0017; Fri,  7 Nov 2025 11:12:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D80088E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 11:12:40 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF7A44BAEF
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:12:40 +0000 (UTC)
X-FDA: 84084304080.28.25ECD8D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 050771C0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:12:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=T7shKmoH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="nS9dw6s/";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762531957; a=rsa-sha256;
	cv=pass;
	b=oXAnvmNyP4bWwW4sVja2u4Zy2ee8WQ2Q1IxMiavrR3OwGKQ77zd9NisgdH4tkieXN2m/Mw
	/foFZ0AzUv7OPpq7AD8huawnn8DTKne5oGeHGubi0KOlAiQwP+w3Xxjx2hjgYnzcQGpJ3v
	DYeo2NMZR/VKVvEA7uAgG+VJ4kXL1o8=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=T7shKmoH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="nS9dw6s/";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762531957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TiThFlgpwzhYzfBsOz7Xl26wkj8+dtvL575kCq/00uc=;
	b=vV3eCr8BSsjy6AvID3Bps4nPLZfsbqb41HUktSiEKpNyqUaZqJc1qtegFm0VHj+U55jj2F
	7UTfyWyIKmDOBgCN00/osZrr8T5FOJmLcBAgORwtYGKmzIIlHdFFDFBvdsC2wcFqU9DRFX
	zUyt0I6esvaVU5bs5XC3ixygehTVOvA=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A7FLOBC009569;
	Fri, 7 Nov 2025 16:12:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=TiThFlgpwzhYzfBsOz7Xl26wkj8+dtvL575kCq/00uc=; b=
	T7shKmoH94DgzGjfkXvn4LrlIjhtR53cIqSYfsE1XmOEzIX/sbAFk7gZBD4WQTYF
	eWGznYHEviDJhEev4ZZpPT3ZDHWSr6GX0xV1CGDIQbXnK5toaNzJzsxdwTUGWBka
	BoxAe/VGHYUisaO5GGJ6LTpQlTOJJUh4FM5oqvcCPANTcCc3cmRcex4mPneSnmB+
	VepAzq3Mml9ou/x9Ca/n0hL7S6JpIThbUYBrd3lPAXPrAPUJUJVEU/+Cuhk+Uf1Y
	Gc8B6F/Cr8fF2ymVOb+xbChVTMvWXRS3p0dI+mztoDgdOZyeRJZO7X3xG3NNb4CA
	EL6deCrR9y9K1MkiFrZFjA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a9jgk8709-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 16:12:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A7FKe5M035995;
	Fri, 7 Nov 2025 16:12:22 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010056.outbound.protection.outlook.com [52.101.61.56])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nqt10a-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 16:12:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZlspuTgM7qsQCUcuGFFtu76RG8i+yvu9o34zf086EeNyTvCAkgj87em4mSiq3HSedMFR0LTQZoy751xahsn2gYn5ztxzz8QNlww3fnaZ2HO9m6hIopGhuY3cW9Lxq3XrycRWzPBnDrERS8Q+HVxvzrjm4kY/TtKWx3CSGMY7i0B5CtsNSmVLKkhtZgXZX/vqu5Ni8vS80CHtcdksGaeIEXH570Eq+NdQeYOpApyK1Decds9EiKYn2/457c8ADPHRXYxq7pzLv/eg9qlyKAoNjHV+sC3LB6X+NyGR59WfhRsz3FITsbRrr3qsYWlhfRt0uQjovaxJWit5vwmP69QARg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TiThFlgpwzhYzfBsOz7Xl26wkj8+dtvL575kCq/00uc=;
 b=QsI4cTDXcTHGOAUXVYRbz4IDrRSYsd3CsIFwY35yPSMqnE9FKZSHkO8zp8Ydsi5ycO/EqA5QaKfisbfJt102htRW5W+EH9sNmSh3vst050JZXiMuQzQx7Rezru4IdJWu/3JFBfpuzxw4bjjM5Hh7JZzRghwugFMgBUXfJ2UhCqWqrrks0kMw4SNGCkmiJjYtETcuoXxLgVd1YUCB7sIv5nnX6P3w0vspjGdSMlcZTSjiahzydyjXtvCznOglK87s4I3ehZJcK29q5kEvQ3sSfM9rr/YMTmyJ5scbw4QSsF/a+0vU5ohY8nbIZ9Nc8krTrNEj7swH3AeACYDikS2UgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TiThFlgpwzhYzfBsOz7Xl26wkj8+dtvL575kCq/00uc=;
 b=nS9dw6s/5cDpQtof6C6ZKkCYntvHcc/jPs7LRuPIYKpMD6+O5PObUlmWj4mvWVCFfb2H3b66pUufd3vAQq5GTuPqilic30PEYHqaJP2KprGK6DRizsYmhKmWswg8hv6q7PenamK6n16e9iHRTkHgqlRmOpUBH8hKoZ2V+6XQGD0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA0PR10MB6913.namprd10.prod.outlook.com (2603:10b6:208:433::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 7 Nov
 2025 16:12:14 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 16:12:14 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
Subject: [PATCH v3 7/8] tools/testing/selftests/mm: add MADV_COLLAPSE test case
Date: Fri,  7 Nov 2025 16:11:52 +0000
Message-ID: <41d851aea2975ab54ddaafa3a132e2fd6f8c5582.1762531708.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1762531708.git.lorenzo.stoakes@oracle.com>
References: <cover.1762531708.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0502.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA0PR10MB6913:EE_
X-MS-Office365-Filtering-Correlation-Id: db0f5b33-d71e-493b-2328-08de1e1869fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tBFEfFq8S37EU904/L6yP1fixKlg9d813LvCqRFhTpdXH7xoL4d05D7C5Pgp?=
 =?us-ascii?Q?MeYynFVZtyI7V4agCD63+Hoa4PNN4PnbH7Am8LTAwSuBeyyNbCwPIeFQ5t6g?=
 =?us-ascii?Q?Ms0lpmGFEdt7FdhKumPbzGwLtmE1yM5kyFmQ9QAkggxl7NBDKBwbByvMN9VE?=
 =?us-ascii?Q?3Z2VBDU321F+UlUYC1IGLzQFdMVQeHDmJBhkLB4W57KXwh2oZ/hGz5SvbHir?=
 =?us-ascii?Q?herZ+Y3dV4wwdG63TCZ/Wl47sKSoA/8DJ8kVBqLrfn3fxpT6vIrd8fZUiGoq?=
 =?us-ascii?Q?qAtuJRmj0ODqxa20jBvh24VS71P2UpKvFBKGj/5ZuAcyd5YGM1JKxu54Zasx?=
 =?us-ascii?Q?niX4qgyJwHF7lxNKhCtqGzUBa4bTN1zADjcP9mBGUlHm1jTgTcqWsdwAKvoI?=
 =?us-ascii?Q?mJqkV16WgzolHnzqg3wq8SGspjZwyYH230t9e/YA/rRuYB9fTL2Rxz69YqW8?=
 =?us-ascii?Q?U5wUFJJAZtbpcLNKZ9HhDyq9k/ttL1vkd9H/qoyaQkCgo9yLbEoQ/5GlS07g?=
 =?us-ascii?Q?qClZhqoiJ4FqdkNpImo8k63opCEyOqVoE9v1+31laCjR0ZVRhbeXBkOgoiuB?=
 =?us-ascii?Q?jvzpCYT752Z/iLh3jiD2wJyi2EgIMwVmv4vBgU6o4Zngs8MRaVaAhBJ/f09s?=
 =?us-ascii?Q?lve2O9/LlPo08oPUajfH+sCYipl0TINeyXc5Fiuz1GepcjkQb/K615lrxdeI?=
 =?us-ascii?Q?+zNUwwYQSfDBaHb8A/sQnwzo8fderihZsKYQsWD/LHudoyLcdWXgOIRxXlxx?=
 =?us-ascii?Q?vxb6i0B2CXszEdGHhsBCxGOKhvdNoXFSZIzYScoGCuYvYCP7R8nEoyw8zs0+?=
 =?us-ascii?Q?yjrJH3hdJhqMd5SLZCiRcVTyhSE4k9U+PNYd1qUVjdvAei4Z+Gsrz8PCy89R?=
 =?us-ascii?Q?CiwiLmYNdctKatS70DHgdUcO/ZBgMY00fgjHoHEkVkw7vG/ApVx54cYhaiuk?=
 =?us-ascii?Q?25LTiLbkAxHG855nUIhNDmS9XayBfP4X5oFxj+KKHHtRd4xASkrTukzjJtSr?=
 =?us-ascii?Q?7dAiTNHk82xALCgNnE0QvCFnx0750mZ9cDv0xojGVUbLEqYppqDx1viq684Q?=
 =?us-ascii?Q?MzNzlqikr0WQs723NpmLC5Den/VRzi8XQMNu5gUmWapV1Y4LzOMGX8MLuRmM?=
 =?us-ascii?Q?2jZMHWS3UWKApKmmdb9225tUyXadFo/9m9scUpm6Z1lC2dMhuHpg2P9P/SIz?=
 =?us-ascii?Q?/5nPQT/OXVW675tsTGD1QLqAriCbiIlz3kiYAOZv2DuoFmjGEzPSchtJv1MB?=
 =?us-ascii?Q?9nc6CmlRkikJoHDUerOeb5em9zyaR2n8t82JiT0h0pLlSpenNFpllZNPJVy4?=
 =?us-ascii?Q?k6+3wSZwbkQZPH3mNhR5GQai2XAYt+0bmO5qJcPg1mr3Asgn+kSUkAyJeUHq?=
 =?us-ascii?Q?sgwg20rE9ybg0ixZKz94ZZo4II2FqExlkfEsShV7vCaa7fRwHdd0ETzu31nA?=
 =?us-ascii?Q?eKqerOzlWkNkKlI1jBSiweXGo7OIoewC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jHaLJu7PlnDg1jfjxQ4udy3vpjwrZoqSQ1xKNFRySIgLs+BeMqqdhgv/iGV7?=
 =?us-ascii?Q?cQ4VkaC4t79VMI+KKdNVK7/0boxhqUKflNB6k91uBWRsOmFjenSdBJ36bZhr?=
 =?us-ascii?Q?PuTFo1MTD/EM0/8tNg855VpBLu4rrmwTxtmpaLhcFNu5OiVopY9COcNYGq0U?=
 =?us-ascii?Q?ei9HGuryxA/FQG8YmVENDRwg0ikzIJ9OgYnH7FQm+/JXyunNPMT9BAaEVAyC?=
 =?us-ascii?Q?r3MxUQUZMHa7blyTwo4GGc+BGB1dEQzkdzTGYMMtMPppoaop0U+LONCC0W6c?=
 =?us-ascii?Q?PeAvoL7AOYamzJMLvXMKg1PyaV4AEFvBL3CV2ny2kK/PrSK2sRZ6VnmoFWVr?=
 =?us-ascii?Q?GA6689IGsTzMmv8HoJ3auXFbCjcKsNvLhfSbB/R/U581T1XFf+rXHvPRLSWu?=
 =?us-ascii?Q?VjoeB1BSsp4up2E6tfOPHDoLDpThR2USfOYPTSvglgCHXXUtbe5dk3CWlg0O?=
 =?us-ascii?Q?e/ysuS5bQNx7vXemeGEaNc5X1OEgq5CeWu1P9Zow0AEnGRMIOovApu3rfSjD?=
 =?us-ascii?Q?qz9b4Ju6ntA3jD1EL1YWyfBUaJ5g3JnkW/8E8cPZ3v9GtD8tc9OvUmCLoNQy?=
 =?us-ascii?Q?6JCYyoJdnQHyHDiAn7VYye4cQIKiDHdCWPO7WilbNd7Ew7qS+GfYz8ixDFjj?=
 =?us-ascii?Q?n92wd0DJJ4MGsqi472OxbWSdjcnwjjxYloCA3eYy3DPLBi+bciJ6tfkrsCeP?=
 =?us-ascii?Q?jnA6pMBa5ci8Gv12qZKwBR7zKrYItHjO7HcEK0a24AuddQbc2NIGEo+B36gC?=
 =?us-ascii?Q?od+1+k/oCj4uoIQnUKb+q+HbtX7ywCU5hGJq0OmhxMKB4WdYUBreW31+VM+O?=
 =?us-ascii?Q?fKQBjMIhzs3iDe5TTRJklcRZEtTTZXWIADn1CrPxTvlI9JZbNgO9ByFupwzt?=
 =?us-ascii?Q?4SPFW1QKoB2Rtr0BUOkPJZhc+9nTrYDFeU0dtuRKEYHrjwBV+iu9/kz51PoM?=
 =?us-ascii?Q?l3PKcCfpoOzFxyFSe7UVKMkzcobS03nuv0YfP3UIu+2sqVwBa3ju+L9WBkhy?=
 =?us-ascii?Q?eLaaitnsbP/Q528noMoIPcLIs5uTJGmNHAQbELwVzUO/b540Ngoiv208qI1v?=
 =?us-ascii?Q?0DxNfgNBDTs6g2a+TAoBTapwqfuLOuceX9/LcPd1kSNuttTYv5YWWn1d677d?=
 =?us-ascii?Q?Foq2DtTa0RAcy1D3x4UF7dJrjiPJsdhaIAt6Wp8cZuooi7u6cvZSX5Kn8ZF/?=
 =?us-ascii?Q?6+MibRfWuYPsGHbGc2hPSwU2xmcUmBrZjJHHk8uFzpuOofM1FJF4n73B1het?=
 =?us-ascii?Q?W8jOoJkapOVkE/uPAcieNlhVFBbrIfXnC5UrPRDfEgSBWFD34Rw/znLtuhkM?=
 =?us-ascii?Q?OJa37Tph5BMn08m82atP+ARx1uYSGznHncisSnEc/PoeLFoXJ8KF55arErtE?=
 =?us-ascii?Q?RddwKB258fmKmuPyVy9fIvrCmeeXyxWRngbjB9sAs46sn38oR9KnJb3da2nh?=
 =?us-ascii?Q?fY7KhKq4a3B8oXuaFtejfwx4GsI8qqpkteV8t7w5wqIHhL7Win3aGYG7lxyf?=
 =?us-ascii?Q?5XIMAp1IMkcj2Q0dFEuGvDN/sxHJ+91LiZ82BgUV/DJrrVKzNuCOooa1oiZw?=
 =?us-ascii?Q?ocPUImdbuQccJGnULEjx3dutbJNC1mdYKVf+XiiRHNDgA7o5FpiqQWA1we4/?=
 =?us-ascii?Q?HQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WfU52qdnrwQ9tTY5MHCEd89U/UwlD7VpY3xCuQziAe/ldruLYGwLA7HYGpINfPt3PKkSZyKfTJ8ixVVuCy+KGX6K8VwOa4I+SADhpft0I0MpE6Vr6JvQS2n7JfgY6xLSFZ7Nyx7nXXW+dOEpuntFfKtddFAna75c/gPgCiWbq4xDxergqmnAAeYeBIGd43+6EHqnmAyqRHNepHdkFV+M0bXeWhHjb2zIOteQ1VBBoy0t3LjxFeop02bfjM5libTJRZtsczQktHLe/rbny3M4cJ+dze+XQQkwJmo9uVV8Kbcfk4m1/yLVkH0dBHQDgMBeqxKPC+YS7Aj8YnOwyDL+VLprTxlMnYFRJ3BJECYBN3tBLPH9ageeMV0SNjOwjSlgp/o/jR3IXpAT6zJNpgprJ4NfKdaWzTEU3W/UlvPjMeo5ppVVBPFmrJY4R7oqe0ea5e8eVi/nJ9t0PqVoq8qxUblOzRvwdoKVUtb5Grq4FVeVDan2jTQAXhIC0ibGIzkX/eREBhNAi52vFIoFpkKe7zpNObWOLUu5sMJQFKfPSXjWNS8xg0oPCFQcKx90mKILNZ6tKqk0htiiQBI/PTrEF5ugRuIqsKsXk5JIanF81J8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db0f5b33-d71e-493b-2328-08de1e1869fe
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 16:12:14.2163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xxl4j6ShKyjwy4KVBHFZgziOr1OljKa2eGSSJDwow0U8lYwZLdlXndJV9LguQrv5urHCNWuwmZ16IQl5/zw/qSOB95pjikemnsQ78XCbVxQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6913
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-07_04,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511070133
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA3MDExOCBTYWx0ZWRfX1Uq1LgSkecaY
 h+zEytTuIzWxZqFDYr9oVGx1+BzUKzxXqYVEvq/iazbVCVsEdZbboTjq7DT1+O6v5/CA0q0/cZs
 0skEwVVdnf005+Wu4sY/m53bJIe8L6dM2HzAV6w0R7Jc4GXdXR+J/gcaFZjXSQmn8eYckzxEytf
 eY+JLdah1l9nikh6odx5M/tWszFEoFcJDm0ckH20Ozaz3b0VdHL56IfF3pGl1+iA+A/rEf0pPbZ
 9kI2Nw930Nb+sV5s0Xqdj+vSyIa/F/OF9nr4jp95Vt/U4KTqTk7qrBDpAVP24VpuPCIXyM/pMdn
 Us+xdxVUoDmZvO1AIQHwycanMAQuQVEj69lroUmZgCtb7eTTyQXnTZK1KgY028Qi+4lP17pCB+P
 c6BcudoFI/PID7gR0ofIqJLOBz1qFb63JeXKFBAiI0gWvtEH1OM=
X-Proofpoint-GUID: wUGUGP8tRBL-5-ckJnuNqjmI6oGJhT8V
X-Proofpoint-ORIG-GUID: wUGUGP8tRBL-5-ckJnuNqjmI6oGJhT8V
X-Authority-Analysis: v=2.4 cv=Utpu9uwB c=1 sm=1 tr=0 ts=690e1a67 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=2NB0c6lsidA269GFv2cA:9 cc=ntf awl=host:12101
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 050771C0006
X-Stat-Signature: p9uytjnuq9gisq8guhmsqkm4wu9x1r9c
X-HE-Tag: 1762531956-97589
X-HE-Meta: U2FsdGVkX1/QdZBXNPGV/Cu45nOKfBk4/mpSGH2QT3Ve0wJmSkFTnNhKnDeKJE1UIBjBL1jYgov7OezhSXKoi5XtzWHZWNHmIH6wOmXYD+9ELyvGJuLAOHCXn1QorLd4gK3yE0A9cAoY/mxCY0tQio7CJOCzjKsc/Nqy0783RNmCrr8Etqp5YM8fnIefI0oDcyr64n/RdXAPgJMfmS+hAKqG2TFIYSeI4QrnDzQBCo72EfnPKE5DyrDYOYZXCPcnT8Hc28P9RpnjEFlXOa/C7CEA+ARzpKElpsBgiJs43Hc2kCcgz/3hv16R4MBLv4St7uE3jdhqfH2VmhJHQ4K7GQiHrkJRJFswjevou2KlsmyteRvx6OQMTBweQoyH3+oOYUxxo82KRCAAwWuQJtELe5dEGWCevHCnlGLRF69+32bNbwURr+WqhebDSlOWHl7VxQar2sXsMlLHAIT5H1FJZcCtXrzyWz2X76t1VtVLYU1HVBfQFWexaEQRNjBJK9pQKrnT12i/yXkJ7GgsBxzcHPWpoDXm2TLU/TuZiN37F+tPSypqKVvoR5cw0lXJNtalK6GSX35GFO+YdQCfKOsm2pYJ0WSkZ9+k5XDWdocPBl8MAlb0lVXUTUGS2C1bBsJ50iVem4yF3iPhhPdP7JOnKUwG34exY+NDuklPBLt5jMOEIWIfGP0rclYZ5ucDH5Y0Y73JOY8VSVosrNjP7CQWMTVRQpoUHD6Y8iLshzG0eVJZiAt99pCqHNVA4llVLh0P9kK9biKvfHrewNwCeqQ+wCVukAa+30Dm3+wLE9nkbtNXb9m4lc0IzAxp4SPG0fsrXJAmf8+cfkCpdFGCFjFgeKLMp6pQDXSMUO3g1W8NJ3XCEleLA7sLTa7TJr5H0mY/Tn7wffowtzJoIdSKgXhHLiVGm/rTCEk0St/1lPWDIlK40D+4fX/zi2Bq2D3VWruHZHBWCmuoyRda0HK1yva
 iEQPKrfy
 aeBVYv4DLBetIB7jl3rzzDK5TQVPaWk3gPjLR3bDpUc6mg0ceDlZDIR5PxeQsZhGh6GWYQn7R7YaSTGNxCJBftalaGG5ii9Q725bVWr57SjPevW35R0hCIB1Bx1FDZr8Cw7M9xY3Fyi1VXB53SeupL9narzGxd3PA/Sp3RfnyMSYl7B0ZVy59z1xm9FeE91iF+4na/rLQSFJhwsEBubMm1l+5r/gArf+ZE4SNWClNhIk4F2YtXYTauDaJEUrg5XMjCofbn5TupT7NWbR3mdJYktCHezvdXeCzcJEmxN+zMfNNJ4RAjTNiNc9SNnYq+LGeBIX3hoX7o5fTfHbp3qJ8AhJu3RK20dZ/+Y01VVxsQvgvc+UtTjnBQ6Cjg1XlU6O8dFrHM5l4G7bWbJW76LnpD5FFRut4p8sLcYVB38bwhYrCc97V0AE5tCJYxj8lM8i3HXFisS3ujovj5TduLdo34mv4BxGIOeKEMFWDvBoISc4esV9aAK7uqBqvtOlRuOFXPUrW/kBkkXIXYmc4NuhNtfK35hw1h5tlrzt5lz2FxNmLowVc/eb1ERjIwA5AXQC38jZOQtbcM9YV1CjM9iz5DIPC3RGJoL4k5FcoZAneqQCSP53gAdrtl8Uu0d82vR6F/k+KWPeL43NGZ/5n5lV+lDXfVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To ensure the retract_page_tables() logic functions correctly with the
introduction of VM_MAYBE_GUARD, add a test to assert that madvise collapse
fails when guard regions are established in the collapsed range in all
cases.

Unfortunately we cannot differentiate between
e.g. CONFIG_READ_ONLY_THP_FOR_FS not being set vs. a file-backed VMA having
collapse correctly disallowed, so in each instance we will get an assert
pass here.

We add an additional check to see whether guard regions are preserved
across collapse in case of a bug causing the collapse to succeed, which
will give us more data to debug with should this occur in future.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 tools/testing/selftests/mm/guard-regions.c | 65 ++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index 8dd81c0a4a5a..c549bcd6160b 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -2138,4 +2138,69 @@ TEST_F(guard_regions, pagemap_scan)
 	ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
 }
 
+TEST_F(guard_regions, collapse)
+{
+	const unsigned long page_size = self->page_size;
+	const unsigned long size = 2 * HPAGE_SIZE;
+	const unsigned long num_pages = size / page_size;
+	char *ptr;
+	int i;
+
+	/* Need file to be correct size for tests for non-anon. */
+	if (variant->backing != ANON_BACKED)
+		ASSERT_EQ(ftruncate(self->fd, size), 0);
+
+	/*
+	 * We must close and re-open local-file backed as read-only for
+	 * CONFIG_READ_ONLY_THP_FOR_FS to work.
+	 */
+	if (variant->backing == LOCAL_FILE_BACKED) {
+		ASSERT_EQ(close(self->fd), 0);
+
+		self->fd = open(self->path, O_RDONLY);
+		ASSERT_GE(self->fd, 0);
+	}
+
+	ptr = mmap_(self, variant, NULL, size, PROT_READ, 0, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	/* Prevent being faulted-in as huge. */
+	ASSERT_EQ(madvise(ptr, size, MADV_NOHUGEPAGE), 0);
+	/* Fault in. */
+	ASSERT_EQ(madvise(ptr, size, MADV_POPULATE_READ), 0);
+
+	/* Install guard regions in ever other page. */
+	for (i = 0; i < num_pages; i += 2) {
+		char *ptr_page = &ptr[i * page_size];
+
+		ASSERT_EQ(madvise(ptr_page, page_size, MADV_GUARD_INSTALL), 0);
+		/* Accesses should now fail. */
+		ASSERT_FALSE(try_read_buf(ptr_page));
+	}
+
+	/* Allow huge page throughout region. */
+	ASSERT_EQ(madvise(ptr, size, MADV_HUGEPAGE), 0);
+
+	/*
+	 * Now collapse the entire region. This should fail in all cases.
+	 *
+	 * The madvise() call will also fail if CONFIG_READ_ONLY_THP_FOR_FS is
+	 * not set for the local file case, but we can't differentiate whether
+	 * this occurred or if the collapse was rightly rejected.
+	 */
+	EXPECT_NE(madvise(ptr, size, MADV_COLLAPSE), 0);
+
+	/*
+	 * If we introduce a bug that causes the collapse to succeed, gather
+	 * data on whether guard regions are at least preserved. The test will
+	 * fail at this point in any case.
+	 */
+	for (i = 0; i < num_pages; i += 2) {
+		char *ptr_page = &ptr[i * page_size];
+
+		/* Accesses should still fail. */
+		ASSERT_FALSE(try_read_buf(ptr_page));
+	}
+}
+
 TEST_HARNESS_MAIN
-- 
2.51.0


