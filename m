Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EB72E94627
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 01:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 783C96B009E; Mon,  9 Feb 2026 20:50:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 731DA6B009F; Mon,  9 Feb 2026 20:50:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BEA46B00A0; Mon,  9 Feb 2026 20:50:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 498256B009E
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 20:50:39 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE75514010A
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 01:50:38 +0000 (UTC)
X-FDA: 84426867756.30.9406420
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8055A140006
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 01:50:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gHRhFiZ1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MdKJwgV1;
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770688235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zHbwLwToGjlRHKCv4+8F65sx0rY2+neltVxKQfYoLK4=;
	b=ohCZfFcClI0ju6+eoa7XVZqAhl28UJWOAZY/4VdtyIuq87AzHnI+Iep/z+sG6yb/YYNviR
	ny34RX6mnLaZNu7W8q2uhFGfvmPE+WsqMafSVPwTEipxIbuKeopo3SvSiFabPmFvng2qVA
	bOljLjUGQUtp46yhiAqUfgln+7LaZhw=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gHRhFiZ1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MdKJwgV1;
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770688235; a=rsa-sha256;
	cv=pass;
	b=pmr1UjwyGd6B0CuCdA+ZiLS9p66cz+ooHHOvavii/DQQz3zkHI4Q7g9keUkNtYxVTCJTQs
	3aQ2G/8trVtI72oOTMdT8VU+mrcYcKCAp5boYODR70KDIxeye54hdyTe/8SrAxuRWXWEIJ
	TAVTmKbK/7B7mG9qpKz3I0tKFX3f1aA=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 619NOf5Y2768768;
	Tue, 10 Feb 2026 01:50:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=zHbwLwToGjlRHKCv4+
	8F65sx0rY2+neltVxKQfYoLK4=; b=gHRhFiZ1LjP0CI1VXsw88gYWNQaA5VPLe+
	+bt8g85CTHV0eIpCofqKLOGqOr6pfJn1VwV5zwOybsSiV9fyYYOmTK7hGmi1lmp6
	HxxUjdoK5x5RyuRzKJNhwu3sOCsK9LQ6XTuBRsaYLDFRf4Z0M8O/oeVzcI77siK1
	lO0t+7qaX7BpzSvqckgcD5IT2OjdQZ/FdH9mNppCAXI3NiwW4AtFAKPoZgaHAfcs
	tTs5USGNNDzCrQmcurNvsbSj/ZmI2XHJGh/dPL4yFdd4prQShUwCDTfvIM0Fqeq8
	o/tueRb4oMkepeEHPu2dPPPlLXGgBW0dsv/gprYNiQRDXGbSRVrw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c7s7rr3yb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 01:50:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 619NdZh4031135;
	Tue, 10 Feb 2026 01:50:27 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010050.outbound.protection.outlook.com [52.101.61.50])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c5uumbd9s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 01:50:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n9mPpilCm1nao0+ZCTaicYBp0qsWnZdHQLgQRghIKgKCVKhp4w1n3an4lrEh3qjjlPt7Dm9a2rS3qlX4+nKjoMPSYG4U+B+Azw16dmJLDzpmAZyfbo0Ek0Y4rl6ylWkAa1vV0x5Ueuet17gsX431Mhwm0fvF4Jq4aJVomRQCEJqEklo6mwi9GeQYTogmnJ6rtan1pjgjlOL0t7da2myYS9sLCH2JrHQ5Ia+z8rEOyZMUO7prTTW4hqpsxSdx9j1tAnk04TQaOytB8iYaS7bPGUXzY9p5fiNXVk0fn3eRhdx2oQA7jhT0xCWfO1pVL/crgskLRhT2Ka7vMlvBYV6GuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zHbwLwToGjlRHKCv4+8F65sx0rY2+neltVxKQfYoLK4=;
 b=Kg3xBFKsL7M+16f67hRQ5WtUKWX/+lRn6HSHWj5hMvEbXLp5g14V2MvnPu+AXxbDzt4Ah5rhPb9tuNo85FJ6PBuF4yWnQq/kEkkUR9vxJHRfGN3AkOxt500KsKgitLTYQUURM4YsC7+a4bs063pNGyfrijHqy4fbZlSozBs5toQAoetOCHqonzoxwFLvT1QyAT9Hi7gOse8QwCZ/CU2Yzi/IS1B4j4QFeETby3b4LQi3AiTHEFcgCyYpsAfXNfaSP9lSmn37Rz0C8y4O41nZEo2aOqMdW5/4hVF78PkdBgdW/bbFduLYlAR9KCvGH7QQ3O3DrpcRn2dP2WVUSjpZCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zHbwLwToGjlRHKCv4+8F65sx0rY2+neltVxKQfYoLK4=;
 b=MdKJwgV1onDmX6Xj4C4KgSrFg3QDeNWpCr+6FRotoji8CQZrlJY9x2s1bR2xN6r4L9OH5GXNyPzAoVLa//GohLfAyk5Z+/GfvRa1XU4qsGApXfpO2nOTuS2UkTtJAmbukbncg4/EwMCab2MkDi/jHkeRuilUN3TsUhNAfOm4zZc=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by LV8PR10MB7728.namprd10.prod.outlook.com (2603:10b6:408:1e7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 01:50:24 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 01:50:24 +0000
Date: Tue, 10 Feb 2026 10:50:18 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/slab: allow freeing kmalloc_nolock()'d objects
 using kfree[_rcu]()
Message-ID: <aYqO2n5LiZi9yISo@hyeyoo>
References: <20260209121013.50475-1-harry.yoo@oracle.com>
 <20260209121013.50475-2-harry.yoo@oracle.com>
 <aYooqPNGEf3On-W_@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYooqPNGEf3On-W_@arm.com>
X-ClientProxiedBy: SL2P216CA0137.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|LV8PR10MB7728:EE_
X-MS-Office365-Filtering-Correlation-Id: 47786a7f-c586-4d82-a841-08de6846c212
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?w+Czw4XbOScNKq2D9doHfbyrauim9Og1jOoo2TZD4h2L7CjiCYguSWmxXs4w?=
 =?us-ascii?Q?PVVssy+bJTV7kzQrPaY2bIWuFzKdhiJAXbxvuus070BYDAJidAnkFYlR0y+C?=
 =?us-ascii?Q?3eVnPvrRVckvZfFyQHFbtgFz/z9fS3RRpfTPMXucn9FADp+i/jnzrBzPaH0p?=
 =?us-ascii?Q?GkPQlYB9ICqSpbpXTq/p8tsbHdBD4w0dPtLVhkuFkMViTfWYc/Iroubs4O2S?=
 =?us-ascii?Q?S2VYXiwUBfxa/0jAdX5mlgP3nmDAQVD1NywI9F4UMJph9I2oTN0BOQ9izaZ1?=
 =?us-ascii?Q?ifP2ofMlCYa5ntpkHSwVccO3LXRvdKmhmnOO4Qu+DD+xGpZfdyNpeuburkn9?=
 =?us-ascii?Q?rzoE5wo0i4vEK6FzJLrtWBUAoxOlYe0gf9rgyn3mOikuMhQXQllCIJxenlOg?=
 =?us-ascii?Q?104HFVGURRC+AtCe1xTCsnVp17nftvbMAN+Hz2J9ZjJCQrlQ5KQOmiujmzh0?=
 =?us-ascii?Q?gV62iy+ck7JNvvqzb6d9ePNs3iJ+GhAXteq1uCTOVm/QEUeeIVODqu8POHKG?=
 =?us-ascii?Q?plkk+dJILceFs/ejckg0dLNLD+H09R+EsgCN9RWKnlIawnNQjnLWyFonw2u/?=
 =?us-ascii?Q?SPHEeQpf1DZyGS+V5o05YWFek78ahC/YuQmteL4J0IwRsspiFDQxZXtZNwOf?=
 =?us-ascii?Q?a9fi62l1ncsMB5clJl1NNkUqb16jicjvJOc4A1Mk/QNUZ8sjVwkJ1bcJNGHy?=
 =?us-ascii?Q?CuFVDWhOkp8+uWOSyuCrytWUEfFnSX8/gp85/znWPkFObTDUWQZqvsr/YzWb?=
 =?us-ascii?Q?5i+GbGkI3jzAb3IhrG9ACoA9JFaDM2PaqvUJW7AG2BJ9Ctc9pHJcr3OH4Nn8?=
 =?us-ascii?Q?qW7LGhwZlHsH3HR7q1cAosAdL1mfgN3khcVQ7xYQHGMs2m8SxzfAzt616+Q4?=
 =?us-ascii?Q?0cyMjsgKHj1j68+mFMGY+fDTicC46mwFwB2h0ysDqvyuu3jl0t6Acd6ks0WS?=
 =?us-ascii?Q?Rs7UWPHaD6ssLh7CuTKdBIKbRkKTxy3r55z0IXScvxpGvuqBsauvrnuJg5Nz?=
 =?us-ascii?Q?14CHmSVD1D4oPsruZ7My8IgHx2GZZcOv81E/0ehjtEKOzj3YtLQJkiF3rOC2?=
 =?us-ascii?Q?WHcN0iObVZq/I5vvIx1fh1gHluXdD7zt1gkkolKnhq/aZd4o9WlN+xvneHzl?=
 =?us-ascii?Q?vNW9Ukxg02Gc1jb7K3XKs2Z8IozFXxMx6qDC69NhpOquoT2zrANFBuOO2mSk?=
 =?us-ascii?Q?LRH8XyWA1VuwX1t0Z0xWTpIdT1vlay+r4IClR/JdagMoB4D6KN1XyfQc3XPt?=
 =?us-ascii?Q?XM1nTKeVizSIWev7pRrW3h65eLsogTXL9vyPF78my4WUiujVgoPwxEtO3SA0?=
 =?us-ascii?Q?AG3dTAUJtW1e+IN5uMH/YR33pi39HQkzYLW1mczUfp/6+j0L3wcNd5h70Ra3?=
 =?us-ascii?Q?bj2qDFdWKW7s7wCtW04P2++RcDBUJXzFZZPuPQpfL+E/IQRjN+6eVi9rPVqt?=
 =?us-ascii?Q?vzD0FNxjMw40WLE9l1AU0GlPVVPYz2Bk1VQwZSurcKnS15cjUT6/HTTE52Fv?=
 =?us-ascii?Q?junE7Y1hVOQ8hn3R8N3UbTbedDEAOOcR+T/gvhZNLbafFKux/kz0gS7YNBFK?=
 =?us-ascii?Q?rxsAv/HRuqjKhrwcuiI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S/vE/OqPXIjw/D8foYojORDHC+rDlC/JdwQvLEizx1Yzz0zkdoV+eCQdNHsF?=
 =?us-ascii?Q?ESfVy4+RJ5MlL4sm6a2ybKWFuSpVQwSOHHi/24L70D7uBaAjS8/o7sOQlilO?=
 =?us-ascii?Q?7aHuKcXf2wXDRF2CAfZwy+NxW2+dI19WJSk6SxZ+Ec0GBQt04+KcaNVpY2qe?=
 =?us-ascii?Q?mDtM/MKcheauMG0MWw48ibaZsC6M9Y9GpKw/iINkvx6VT2mYdmoN9fTTAPeY?=
 =?us-ascii?Q?zzD8vhZReBi9l4O8tJem8ljMendjDGIo2GWYEWerjCzd76luNcLCG4JcuJ8j?=
 =?us-ascii?Q?T0PSjC1VzqACjTA3dD3jVXBxYNiABsGkn7MWtQPqfsV2JW9wqQTcHqXlQj92?=
 =?us-ascii?Q?aBc3YaXBX0KsQsqpXg9AxAJd8r1iCmUFLaaAn5LsV9bLHGp3/7dW4ruHlWqs?=
 =?us-ascii?Q?lfeQ7r7C76pO60cE9iRNKFIyBG8RW5PtcZjljbMSldt9URobNlN9ZfB7Ye8/?=
 =?us-ascii?Q?vHh4QvXDsuCVoqGcfuvxj2vvkLpVgr161Iy7YHd5bgAdxQ1f4qOXszN0oDWg?=
 =?us-ascii?Q?uE+q4/kGAMctK0p8tICgGqUHe/HBQV3PLOMZ5Fl9+YRv1qrEVs6Zo73kNCL6?=
 =?us-ascii?Q?efWicZE//OxJOv9CDeCvb6tvsDUQSXf7PdL7+/asHw7GEqs2kbkhHuhyThcp?=
 =?us-ascii?Q?9o9KCprfHs4Bgbr/9b9zJ5HGBLoLpnlLtx9kG0+NZXfgL9EB9p1RagP5Vd25?=
 =?us-ascii?Q?vQsSsb7knq+Nq/YowsBf/uJaLl2Ck2sCV4qYfH6jIkhpiRtAj9f+mOT8+kG3?=
 =?us-ascii?Q?6lhWeAMr0CnxkHEoPka4iykevyMUd+qhdEfWV7cAgeXE4f/n7SYxKCBhuELi?=
 =?us-ascii?Q?lVUDonydAw9pq5JRLNcRfxbWvMY721HgwsnRvQKoAQMbMTJhH+zvgpQ75xiW?=
 =?us-ascii?Q?WASXFTuoUZIZm0424Vt5vYmZchJSjUWlCQjmmFaM6DA8pQgKfw9ax9NjlzYQ?=
 =?us-ascii?Q?UYC3Z0EzYgpvJgiDsbbKLnDP1FteXHR6rx6gtnQT16WSGVF4KcrCkk4OZ+c1?=
 =?us-ascii?Q?djfiKoZU9HtKNu+OECAMCIgrdHa50e9iQOSqPjVCgisISwJVQ/oII++pOqHe?=
 =?us-ascii?Q?qELy2C/GJXrU2X1tGJQclhYX5R0V67312xzLsxoKaZUlR5mg+vj+rMgPZLb7?=
 =?us-ascii?Q?7k/KasxDPGr9DTpBt+ZB/L3corMnKY30xAmOioHXXhTgpOrq17SZtyIv5jeF?=
 =?us-ascii?Q?c3l7uhpYSIPZVmjporS+912jkyD6Cic0bwDTNjbCFXUasnaAW51e39tjIGnG?=
 =?us-ascii?Q?CzdQ187gNUmyH9Ygz9iz1Tvwvmvf3n2ciGHIuAQgZB8yovv31Q4Anw/x5h8g?=
 =?us-ascii?Q?WL1qx0K8capqUDWNt0erTHblGvJNidtqJM8qQV0h0UlVgtlVcGdl+XGPkMwn?=
 =?us-ascii?Q?cmaGN47spLRdp+iGO1WxoIWW43XcaK40sA34s6EMA0Qx9jUuMvDFed4Bz0lZ?=
 =?us-ascii?Q?sq9NG4xWmLS5BtH/QvOMnaGKxhxEo7JunDlHPWdUqjBAZ4E3pmueQbXth+xL?=
 =?us-ascii?Q?TbSRXFn1BZzuillV1gJjiuuzSnjYWeAgobC+VX5/SIQ6yWc+wVwuvAw0owGB?=
 =?us-ascii?Q?98VHPKoxYj2i2ZpYjH5xMM7NjBTlkEotfxIp8dNKE4XDQwGuypvI+rsqOcxd?=
 =?us-ascii?Q?a/E4M306pTD+NMXgakA5W6RKiWglC7Ou+10Md/auJRp0X8Bp3ncIH8NqJ+l+?=
 =?us-ascii?Q?cRfO8qIrsTzDL/pvMa0RwidEFYXk+zIGqYDHAxO1j4V2KfxE5aPoaYihFxD0?=
 =?us-ascii?Q?hzroHGHs4w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3+amdwh7hXymypG0jiODqF0zZSuJN7+LQmqHWeMRO3VcAyOqXSVNsZryQo1anyoePD7Gc9BJOUcfCcgGuDH4cogW/TUoilcywhCzehYNAix6nCq+GPOkwxndf6jYhU/XsX/HZCBB5p7EzZwIJj0XxA70XpHXGYDPJQh7VoMdh+oyxe1EA+mV7xcrQE6+RJAb2wHh/J4jQ6JQeKV3Lf0a1DvJDeDfb6TW8j+dKeETmAMjcYDNLfVc3kRbXaUQW/Jkq50IDPFCq6GD+RuYZQ/HT4BWOp+7sZ8yjUDp7ePn4/D4fqA9oCFGX5eqWcNCFmv6pUOFod8wBwu3BxsmyGpuUhbIcKWfMRiDU9iewLt7BhnybX7pH9e2LmHBrwxWDFGLR3H2Me0ASMXoKLb0D9OiGrSCeZyYY3wX+TfyTa/n7JGnMJZh5H09vfDPlH6qd1bWOym4gsfuQmyT8HEpXO4BKhFDzDtphins8QckYvFgrQKpKrdntkWLQR+kLjrMOj4bBKkI+qlmZpSucGZiegZ3BlaSgdJ+gdj1PrrZsLKbVlcW8NNSwrVdwvYZpr3c0N/JQnERHe02nVqbQ+kgy5QMuolJCNkRXAYTbn7rFB37r8A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47786a7f-c586-4d82-a841-08de6846c212
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 01:50:24.7720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pNFpuVUZ2fMxTtexgs0kMFrFf0Rj/VjMADgExpGYQBeWNzuOOTKjSqsTmtWpBmpwOY09vsFm1DNxlfEUKKdARw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7728
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-09_01,2026-02-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602100013
X-Authority-Analysis: v=2.4 cv=PZbyRyhd c=1 sm=1 tr=0 ts=698a8ee4 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=7CQSdrXTAAAA:8 a=nPuW0iPf_DojmMeqW84A:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:13697
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDAxNCBTYWx0ZWRfX39pj70y6jxGL
 LXO2ZpLnZ/mz9tVjucfKcsHJ1J5iwWfjkcCddtvDs2AcV6gfjzghEzsA32qD2KkIHP+HAKKb9Oc
 DDYt6l6xO5/OlRebyrx+QmJRjPxC3erUMVBkFeb/Xrf2gqFXICvdw+ZqKRSRZXkXHe1qWlVi4Jc
 F2ws7cROZkqxdtAA0shvPnCSiXV6sYf6VtXbl18VOodTX+co/g57oW97n1t7QFnkcAfuTNqn61n
 ujDK7teGYoM2ycguGPXkCZokndJ54HPPC6xeEMZdnUzC+qUdDtoESOsEPc2G1Ij7ebQjdmERGMn
 mxdR31t1vADICdA21sBxerQXK3n0HLAQfYHmaC6grrVVdfmCtuoBewGhxdG5mGUZIL0aEhkRstf
 VxT24V2Np4wiCDeM2IzJ35Qv3mimALkoEW345K5jdkPIRGneCKS8RR12bkCEXJejk1Y/+QYHoTw
 DbGgSijGhoN1VTg8ejIATZgqxdVbXCCJGvqmnFXw=
X-Proofpoint-ORIG-GUID: ImehkmpQUSMDF7vnpOTKW_QgVHm4MNJ5
X-Proofpoint-GUID: ImehkmpQUSMDF7vnpOTKW_QgVHm4MNJ5
X-Rspamd-Server: rspam11
X-Stat-Signature: ymh9z9jkiudurzgcgo4xeeoti9z4iy78
X-Rspam-User: 
X-Rspamd-Queue-Id: 8055A140006
X-HE-Tag: 1770688235-610305
X-HE-Meta: U2FsdGVkX18cllS7vN6ogYmbNZxz7OqDmjaIndiCnIgp7nxXvlcKaygXOhro7mk4KKwGw38uOQ9DAU6ddvDEd5kbgduN72oLGUifLi81lmpMp71TdLy/Rs5tZs1V1PbmAPZQqZHmsdUSzpUPRfbppYzWVhHSHaGMIj4s+MqRcJd7BpRHu1RHqIAznMDmMtVnvasn201waWxx2J1lnMzoTztLdO1CQuHY8npXBPgIijThi6LKim6IcRXGRXryM8+s/x6Gyxy83nw+MQ7IzBKWE6IJGXd/tX6LgWTXWlbM2ZzvKTa+JPw1rqIIeAzrul77RAP0Y6x3dQy1RaLEPuZIN0i4YjUnoIZ/Resm7Jy597Pasd4FzBvlI8ZjBtuu28m9P7ZqN0/oX2Lml8/y1e+mi3+g6iYK9lzKNQPDCL8t7H8czVJtFY562DLSpImnxi0/YvziHdX4MkS5nkfeEOMECgcA9r0OlWVTh+MzunjpOrsMgdtkmiaQkk9/1dfR9Mkxbd5KjgwvEu1O1x5axzaJhA6DFtIxw93LISjaLuXyMMu9cyyCLEhzf5qpTVB9riA6MhB6gogvxqxcCdt8fEmWGwNQthX38dMqMsljHKoCdamuPOdrzNoRmXA7T4YOo1K9lni/Le+8cijzoOqTw6rJKKLItiOyPpM/aD1MrVe5BbqdXCgt261dkZmA9A6sbjwsvw+TbVbGU/qxVt5hxgKM22G2BcA0aOvptVAWD+w/rI+1WD7t0iWRMlye36QnhZTiJGZVhwuDC/nPPI6dTuZgqSB61CsdDAhqzau/IIVpk2ht5R/YKNsu0ATmLQSv4+TwP+pCzt7CKtL4p7Ey/bd+XL+K7VJyWf+IGKo64AFj8FanKhTz4GjImcVUtvvzJiiCOOf0icwRV0Coa8+YhbjMM28TSABDdYlTrRVYfrnUKLkOjdq0d0dJtAwvD98XSJufPgBCspkDQA9/G9BxYUz
 c/qFNWXZ
 57i7qvbbo/KAQPAxxXYphblYCF/S4MPf/HSvH1b38BxC79Mojetc2ojPQYuZ93pXI7lH3wzlN+pmQuFfbXrNfdcMD+ipTjWpi0LDXlTYiAo7KMjiGD8vvQRdxDvWnOGJTaYf+OQv0qrCA0Si9GbmRGy7V4wO3mFq4MSI09kvJivg//zq91PAw4/5PD2WbrDd3raGVwZzgu0bwe7lr/mHJ69L187RCxx3irbD+9lgKL6aLK4KzJNUUST3KwMPV9/E32bJwPM6xRE3fpsfi0Y8enelPluqvwKpzXpO3H7ryO9vQ6PHmXa/Tu76ecgVaN5uFA8Ea1bWqcqjKC6t4iJPub6Sr1VQ7wtS5iWTo9PJqxCOCH6SdBx0fScxdNNN5pT5/CzB4wVF0LCkWZFarelBesd2JiFrMlXjQqBjfhB7tG5wPWCdoFBJ+BXJxmAJ/GdkaELGY8CMas18MTmaHNm5PWix6ffg74BJIO9CZUDjsasBaoB9Pfl+coBKMDscP2SqJJ7kSbGBWWAPCQ0EgC+7qRgKlLtR2CwAtNpUZOOeeXai1c/T/JQxnk8PCVJAsiq5zZi85VDGVjay2a7OE+exQLWEGcU3IRB1J/Xg+tGAssORBbEGPx1U3p21bRPHpt5+Beo7pmprG0m6rBTsPHpVeSAeVs9G0QrTtlbCCwWgBK8HIssHjyzePZYbiRG6/MpZJjwGPyv9TNna6QtEWQTbUQ5ezK/Yq3Xmojuimp8BCTWsa15lc0ZS6xaTsc+BTUSAhW56tdD8RXXZAOgDk+ZMnStU8t9DxozvYh4npM1TOM2lsG8oGtKaZUdP3GQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 09, 2026 at 06:34:16PM +0000, Catalin Marinas wrote:
> On Mon, Feb 09, 2026 at 09:10:12PM +0900, Harry Yoo wrote:
> > Slab objects that are allocated with kmalloc_nolock() must be freed
> > using kfree_nolock() because only a subset of alloc hooks are called,
> > since kmalloc_nolock() can't spin on a lock during allocation.
> > 
> > This imposes a limitation: such objects cannot be freed with kfree_rcu(),
> > forcing users to work around this limitation by calling call_rcu()
> > with a callback that frees the object using kfree_nolock().
> > 
> > Remove this limitation by teaching kmemleak to gracefully ignore cases
> > when kmemleak_free() or kmemleak_ignore() (called by kvfree_call_rcu())
> > is called without a prior kmemleak_alloc().
> > 
> > Unlike kmemleak, kfence already handles this case, because,
> > due to its design, only a subset of allocations are served from kfence.
> > 
> > With this change, kfree() and kfree_rcu() can be used to free objects
> > that are allocated using kmalloc_nolock().
> > 
> > Suggested-by: Alexei Starovoitov <ast@kernel.org>
> > Acked-by: Alexei Starovoitov <ast@kernel.org>
> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> 
> It looks fine to me. The alternative would have been to track objects
> allocated by kmalloc_nolock() but that's not (easily) possible without
> taking more locks in kmemleak.

Haha, yeah... I wasn't brave enough to have fun with changing the locking
in kmemleak :)

> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks a lot for quick review, Catalin!

-- 
Cheers,
Harry / Hyeonggon

