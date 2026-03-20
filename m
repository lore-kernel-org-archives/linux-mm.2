Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B913A1093172
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 04:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3DB56B0095; Fri, 20 Mar 2026 00:18:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7026B009D; Fri, 20 Mar 2026 00:18:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 941D26B009F; Fri, 20 Mar 2026 00:18:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7805F6B0095
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 00:18:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B54D45B6C9
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 04:18:26 +0000 (UTC)
X-FDA: 84565134612.14.717D33E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id F3BCDA0016
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 04:18:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Z+Fr6GVg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="nXN/HizT";
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773980303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ev/wua+LzhlQSqngSzFWCdSifRVrYLXvl07du3mZ2uk=;
	b=RBR7O8JJg0YlNp0I90tFalskd6WbvLINytGury12TJGazOXNvsxXsmAiPUqokkQZBqn+3s
	s7i0ElwksI2uyhIwK6dqrgHRc/MiZ17eSX+QULYHVoVUnmd+qe4cfQNq0Z5ZPQuiCC7fPw
	6Y1BlijmwU5fz7ti+fnCpTX1ocr2VKo=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Z+Fr6GVg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="nXN/HizT";
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773980303; a=rsa-sha256;
	cv=pass;
	b=mKCrgPW6qSPne7UbFbLzEHQ55XyDiqNDbAhmwBHT9Uzjb7OS69ERe3ju0rRllDfhxjv2BZ
	bNmLyltEU/zjBkaLApARe9cPYEjYWFyAcGeK3/hpT9h26ubIQZBmWKRVsuBRh+59oRGPiY
	YKKktCaGvn3yXh3Pit766H7I71Dvmnw=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62JFudkk1949233;
	Fri, 20 Mar 2026 04:18:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Ev/wua+LzhlQSqngSz
	FWCdSifRVrYLXvl07du3mZ2uk=; b=Z+Fr6GVg3NcuiAzHbguHnQa7GdjZQZukJ6
	8U2vA3+6XZQBNQv9NFSjUQmtlP74jW/7N5la42l6iMGHXB4bOFF93cSUdrJmbg8R
	QPwMEeiQOlnyIleOlXbtLUO9rkrv1gsLD/7mZlnMFZ7KEtbTLyTgakaTASwS1Xhk
	sw0K1ob8/tcl1x4vmNY18l1M74BwiBFnvxqubEOL02EYRUDfzN2ErOVMbF8wa01X
	JLLS2rfxmAXG6+WnIztPyBfrDfetmQfUtwqG3zDJHkfnjYprTb8+lMO/qMBE0ipl
	65LQrYXAGDYGEFbGeVero+g/mETc4l1Wq4qpQ+L4ytxxf55aWtSA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvyj68y3j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 04:18:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62K3YKV8021316;
	Fri, 20 Mar 2026 04:18:09 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011013.outbound.protection.outlook.com [40.93.194.13])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4s3f0c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 04:18:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dHje9+3f0rkbvu+A3MbAeyEfu9RlbZFPJh1DFUb+/vqDuvrhDmbTlzyJAdI+xPLgUooSuIbjAoD7bJqLXEjvgTXHQYVMR60Awi8kq84h8eHGMiTmYmkZDS1tlq11cfeacFV4PAVmiQQ0borftUcDNRDwK8fmcqGxbHnbii72TBpKbmUsAf6EqTnWV0bzsfpVorI1r0OPjtb1R8pi2KnXtq+amsRsBKVgPG/xSTCScF+1QMqit8ArtWAg1j8r30oXgmhZUYtvtYjLFaaa0AzkItTpsqFi+aamr9Xk711T+/7OhetKNSXxSIqHog+NPdDRIygbvyZZq2ih3iVCfElfEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ev/wua+LzhlQSqngSzFWCdSifRVrYLXvl07du3mZ2uk=;
 b=vclRxZKvFWZnk/DIxMmJQJjk4Qnt5VfLVI3wSFQDqZE1wloOfm13BLXuji0rBIQNtlS4Sy6dkHHCvRYu+DKiGSdHBre5rE1oSWR9drBJZsud2oHEx4/Rr6eIQUnQuSexo2eb8EnTELV8kquBHv2/PKj7TpbqsO0ZgUn0yE2z0tlv8CaHHZKNKz1Dir66YRtd/CPkQ591TCz26S901LkFgtkJ2oiN/8FJrqAIwq17nqjO1MU6YgFiuEE8xcrkGWPqDm4jlRMpDXLDHLDQeD9UGfmtYJzZs0R9KrQrgqRljZ12EGQ8zOGn5gPckhYjmhNQVSnWSfcbLasNq3igvRYbEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ev/wua+LzhlQSqngSzFWCdSifRVrYLXvl07du3mZ2uk=;
 b=nXN/HizTifGT2vh1QN56S6MlkzqxIHgHqki+Pk6O2RHHx2MACu6L1E9mlW5hM3apCS9f0UF6AmUqNZuYG/xIC9xRlCWRzeU9oVuDS54+z0XcRWSChNommunsPimjP3xFsPMtvAlOSq/hYmXJ5AuzN666CF2DwM/jYJBPSyuvdMk=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by LV0PR10MB997589.namprd10.prod.outlook.com (2603:10b6:408:340::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Fri, 20 Mar
 2026 04:18:01 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9723.019; Fri, 20 Mar 2026
 04:18:00 +0000
Date: Fri, 20 Mar 2026 13:17:52 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
        Michal Clapinski <mclapinski@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, linux-mm@kvack.org,
        linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NULL pointer dereference when booting ppc64_guest_defconfig in
 QEMU on -next
Message-ID: <abzKcGiRSR_E8lLN@hyeyoo>
References: <20260319233745.GA769346@ax162>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319233745.GA769346@ax162>
X-ClientProxiedBy: SE2P216CA0090.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c2::13) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|LV0PR10MB997589:EE_
X-MS-Office365-Filtering-Correlation-Id: 3112ffd4-241f-4f48-4005-08de8637ac49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	oQm177Ghcx3UIMjJIfAx2Z8wjkunM3A0xKckaV5/YpiBcqhvL08YPYnAmy6AY/Byrmyo58LBiN0B/6Bt8BDWGuacQsn9E+Q6dvlWDK3I+n3mCXu3dW7+YKbQ3js98JRfxzW0vr4exE7V9O/r3DBdNGa7bsUwXeqHgol5J8a3VDSh8kgwcNqDAxzmkaHK56YACscRB3Dee1KgSokJRR2TviwxrB1A9rekG1vE5TTWns1ka7IccJav46LrU71S7ly18ZCs2mPGR7SOCYfFqvEnAbdzUQpeEKhDriV9A+NcCkYiJPff8q+Rx5Me+WfHMTPEjaoNKgdVsnzaLSccsxrQsHuULgr74JeF9a9bKRIuG5xP+BPOG4XQK/855iNRBZKtEMOdGVB0rF58DZF3nFgXObwMrJ9INReAnh69FA2mwz4BaKKPVuK6aO4FmkR8XT11drCS3YWOsr3fC3z9PiYYeZWpes6MtkyA670Pj8e9DUNwE4ZK0kX4LMb1ZDHUhSQ77YtW+WpZgNbpGKHqPZSi5SYtW4q5inuKh53+tN6gFhyc3Wd0TTU485CsYQkCkW1bqdc7jdEZK79+xQBqTUxul/Ibl3KV/4ahcLALYl3brTXfh3bk03KYbYKFF5MjFXdkPLsLxu3d9iwngTZdEB3UzHJkgw1JE8DooC5E2lI8epe6/RyQwh/QBIIGaRbYfP8h39EzvuXcJkV2gFLEY6hmrg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZTQBISy3Cyoojj+yOSsO59deo1c0gxBnVf8phgEHd5LRir1lGXLHEiUr600P?=
 =?us-ascii?Q?tvso5XCMUIfO3PuBImfoa+nHZ9/mx5sFJh3PwwIHKIs6HXpYvgN8lMjFH/Wd?=
 =?us-ascii?Q?I+f0Ez+9JMLEfqutczdKsU5Metq3GYjp16wmW9DHyzeEjE8FRinwrYrwURmo?=
 =?us-ascii?Q?dDXdm64FiNrlz8y72kcwUYWRvr6oLnKl/3iYQ4+uDnCajYIItdU4foguuENq?=
 =?us-ascii?Q?N4x8xr3bUJSRkYBhE7iFj1MQP1OUbvSBPrLcEePaxd6vM3FsYvdDeBiPGuWi?=
 =?us-ascii?Q?YN4rM1z9tUZrWuMHpIUT03d5oiJ1Ep5qZzuRQWMR4rhFClDN/NW6zBiC6zC3?=
 =?us-ascii?Q?9Rmc2gM6oV4OMV53PEkOGlkmQr1/UMCbDa/+2hM7w+r+rYYuAZ9rBlAHGdK8?=
 =?us-ascii?Q?Jn0+mbp5WHtTPQho8QnJPUOd9Jfsxvl9boDmMQDqrMXVBPDIpQ5mjyZ9UF4+?=
 =?us-ascii?Q?PmyNcICUdJ+itAcUG/UYSlDn4oxP9Fho6ZaEAmOXEPv6vNed5IrUnC34tSzu?=
 =?us-ascii?Q?uD74xDBOTPaBUkk5WSYG0hYFB6YQYd3//Z5DorOXEWiFhfrMuZD6lRHftuBw?=
 =?us-ascii?Q?ZTJnlSyNvI1aLjlPrxVgTz4JyiuHh6AueQ2k6wfMX9YqZ0ljNbhPQNbCLV+r?=
 =?us-ascii?Q?l1EDEnCsNpu4fmiuMttNiDEP1VDxLgqSz/5ui0kquSRcvbHQOUFXe4HMqYqC?=
 =?us-ascii?Q?U6cAX86YnsGL2/V3bfi59aK9HFLFGytOX8j9pu1qzpiYFRKY38jwtltMhWiR?=
 =?us-ascii?Q?KHDRx92xvmbO6Iw0zELGpfVXZucfgCcKPk6o/fybhw0jYaFufeW5mcqwCUu5?=
 =?us-ascii?Q?mvUEY5MJHPzeuM+nA+CFA5l2cg3EJVbObY/sCkgpgasppmwpVsCe28M/Ypcd?=
 =?us-ascii?Q?135VCgPEZA5fSOPhcsf2q39cM9iJCxMa3ejZfokz3Kz9s7+r8INvJNYoSKGk?=
 =?us-ascii?Q?q5tzdo/2rZkzHRqChbpPFoMithyjjgrNIh81RLcMf4Tx5S9H87stuLlUvTsq?=
 =?us-ascii?Q?mLyk2q90szCCZOLan3eN8Lkp3ecHNi2F+Vy212ZwYX6dv1pfXsiIaYundNKP?=
 =?us-ascii?Q?chYkHlRnRTnZ2pPCz6YN2uEU4M0ATY9A8vRmMuIs6/w1HLA+LVag1seGANHM?=
 =?us-ascii?Q?FehhANLI5RF6MNeObugVB06JuaHzsGhbhwOH2nW8bu5cQ1iTgTbw6rULo3FM?=
 =?us-ascii?Q?xm8CdzMoLfnbaMAuhxlBWLmGnvm/6RuKIwhaFAbMtIG8rupXXb6y6qETQrpM?=
 =?us-ascii?Q?O8Tff31ybS1Udxk+shpeMhtDNoPrHnM2qTHnm3OylkF9/+yw5X1KsFdnN0cS?=
 =?us-ascii?Q?LtUC6n9A0V6PvJ15vJABhVjvxa+LTKFKaUhj1yrQ1e7dpYlD/ra2sTlG2Gr6?=
 =?us-ascii?Q?HmM7nJ0cYB974+/fYQ3Ta+g6szll2p3XeWLgtY7RhjDrz43dvxDMtuY2AYQM?=
 =?us-ascii?Q?zmjbehJMZns6gPYzSjqAXGldRffo/JVZfbmOmj8gZL/UF+mOlrqE0kZUHRpS?=
 =?us-ascii?Q?4dr7iSaaQZA6MWrt5u2jTMBi0qV2BUfuzzQU/fmcI2sDdwzrAKV1XRDk399L?=
 =?us-ascii?Q?1qOM2SUHS19RIohGBQAIIHendk3AwhtAWj1W1E9Go3/s83Xk2ayuC463WNpU?=
 =?us-ascii?Q?qFCKllzFv8TnOZksSP9inaKOHfoT/aL28COi5mT3cPc+voabCRrrw8ZRbx8d?=
 =?us-ascii?Q?Ykxu8oDo1Epx0zO4q7+oSOV4KfsHXZSTUq3OgFLXm/Supvk9BneFEL9vvjfj?=
 =?us-ascii?Q?5ayT69xITw=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	vpkMannflp18tw8IY+j5qYtR5Hz5ECPLEL3QYcmDv+1B/Hvo3A07DvbWmi99nBdV4Fc62Qkz3v9yulvi0kkjltmP6dbCxdDmpjn7joR+pc8ZxA6R17MCuL9Gvvj4MQgHK0N+OMsmBFC0a/8MCaAtaCYHN6ao69IAlwAbb1J44mlJd8OGPTGWLhp20blJH1VNuZS/mWwVVG+uLPWFHBRSaxbNDdfT+zN8uf13SK1sjDnKJL8KdfQBVB0Nqs4uhlAZMp55mCIomXQV4FHzpsRTn09fimVIsT2NRmkK2vIxD2LK3vhLZK+9iNuatph2drTAxmrpzKIhrhPv9gY9mvfCPg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qTcnJiHuCJIjkzL+OEVgq2R0dCPIhV9hk4psPgK6el6x3KLvI3iX4BcBS+HzAQkzRKhyuTsk0+vZD5m8e7ktMwxh36f6tldNPGR3vSYtt+ipAIDDLUd/BNlj9oWTVA92RRqBro5XEzRrTQhsgDnULV9SPvOUSsoXjIAjN731ow2QwIa5RYf6hP9OJkPBfhS6Kmz/5HV9SyVrq4zLVqkcM7fFxZUpHzhLesrUExNaUGXZU+3G1g5OK0LNXkUk9BXambglOW7gal3+BDGV/AUi84N/YcppY+sRn2+lpR1QFq5KWZ7VGoOBHloh3JEDzSITjjrK8Rccx5fRNtZ7bRAtwQtMIY0fM4tFJ6HTuy8FTskvgudc6laRR+3SHcjxFuzlPXA2EysRZwEax3CalSrrJPbXy2BUmsGDhgk2oAWQJpeRLnA8tkE8+whucS9Wgf1AXg/S8ZVeTwnZulGnhPAG1GN2Lx5qX8GQwZRBETTezohjXGv/4E45yYoekgeLvFtYF3XmgX+41R+hm8wA336I957AB87NI3s2ZmIqiRkvShPzz/VHirtB2H9WMfN42i0l7Sfso1zC0/mDJI9KUSK/YNxIco+LjYhCx8NJ4f/kWXw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3112ffd4-241f-4f48-4005-08de8637ac49
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 04:18:00.7033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7WHp+NWhra+Oi9K9iInXTw+dROAIFgO+P1URh20fo32+XPi0+d6DcwwrBvwVqdd7pKNmNxQkyq9bE5LfeYHVeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR10MB997589
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-19_04,2026-03-19_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603200029
X-Authority-Analysis: v=2.4 cv=LKFrgZW9 c=1 sm=1 tr=0 ts=69bcca82 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=NEAV23lmAAAA:8
 a=n2IuXNhsAAAA:20 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8 a=1XWaLZrsAAAA:8
 a=zoLjviWoxn1DttZXG8IA:9 a=CjuIK1q_8ugA:10 a=jhqOcbufqs7Y1TYCrUUU:22
 a=bA3UWDv6hWIuX7UZL3qL:22 cc=ntf awl=host:13824
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIwMDAyOSBTYWx0ZWRfX83Yzx3CRhnnz
 5EmQ0E1pxJY227b0txVys6gjRentjwjhNYE7YZljoXhaYzB70yNpMHWGY3oEeOdlFWIGbKYil2d
 hEg+lLEeDTJk9kGjoLO1iLoq2NKQ+u5COsXyJYQRdfkuk1HZ97tcEkIpazOFSDyPQcXcWi+0SAP
 HOpuoqlgX/KWDS6TkBxp6dVr7bIE63g/lodv8a0JLcZFJlMR/+VNBDi6oT5TDKq5553H2ZcPV8R
 xilpVY7tiSb51T5FBtKjhJkCLPxAL+hH0iOGxeYvyECUrPJLUtZROhszIkbEZSj/PvZ4mX71Ujy
 V4SGYqwjhkpjqKEJSnmxfaRJgyJEy6CkGdWSZ8DA4VQ+Izw4LDz0/gAV5ROpiJWawymdwLg/MRx
 X9PTcX53us+jLdmOu3sjRwrYQG/1utb0BS6n6nqJy6EaM8YTdKFdjWQX5xyW8SAvCHCKMp94XaT
 CylxeYQXY9A6apLOWYBebmyAaUhwIZGggd34854c=
X-Proofpoint-GUID: 1VzKXTp56GNicb429eHnxMXXfxoJbXKi
X-Proofpoint-ORIG-GUID: 1VzKXTp56GNicb429eHnxMXXfxoJbXKi
X-Rspam-User: 
X-Rspamd-Queue-Id: F3BCDA0016
X-Rspamd-Server: rspam08
X-Stat-Signature: roafix3d7tjd7tof75fwbusznunxhyqy
X-HE-Tag: 1773980302-935925
X-HE-Meta: U2FsdGVkX1/uBgOqL++x+/NRaNux6yeFcdttZb8457necBEf/Jlyiu0wOhNl0dKuN+5yYWpkDoc7bNnSHF/5ARaD2gSoCUQk7UkDn4VD7bAO4M4NyZ4rme04GODq3sbOpOhRkejxTahkKLZDVtYHm+SN9RHtFBlauJIOx0yF+i2PQ95UrC4hR1Q4aWkTSnNqzycLDURO6RFSKXVityOLPDQ0Ylmx8OoqgNpWHQ3pjOfr+BknTKX6CxeF0C4Ht4XolSo4sycnXbcedH7QFRj0KlEnA9sWA2VhtmXl5fpdgNCM96h4HNPZfmcW7alNk4X6t1osVtTEAhABAaMuvgW5B3qgzREr/YIwkAcsaFCWNK6Lsm4cRx8cFiwHRoQliTI7C186CXsHwzhT3NywfAQ9KCJdur3tTIGwUeqcAak6isopqYnMxSZkqq4+XedvCB+6MCnQvLNEaB+FWrTzMDxWobXzySw1jAJXQXq/PpVQ2y1j4MHh3ta6OQ8eYLaYSw7mmDbW8gpr2YitLG4xdw12wzAXBjw0+wZFFTsdsUhv3ZgY5KYWDpdDnM22kQ2DC64+RUQ9mFJnbn79UT0rZlJ4AwkxKA3iswbQTVEcUwyJSlGXZpaC0cJiLmcgMThddivm2P8inJfzJFkJfl+8uHGMfNEgbUnSngHTKYh0qT+tsQuagMZor0YdZxNjwTBYrIvF486GnhbHe0FIlKfo9i7Sw+dTS78o7VEsXw2cgBsg77V90MEb8PWyi11f8BJ1KO+OA3WHLWiEn90EzVW07bRhuWtdpT0q7H3vPIa5AyPkk7Bv8fpclpB8B57JDgK0SJI343oUDvySw/zMa14+Mzg81DlsYHCF0+sGEgmNUq9NTmt7Gek8hZvLE101NV6kLTVPbbWrc15Fb2MV4XsQoKdHGZji5xk04f8Xgq+NgvneKStMr0ayeuF9+AxMn+Hu6g/DhpbiMFOd2XGkPiynn2a
 QC49dCPj
 sPWwNO3yG0O27jpEEAWHRjjKSE3G3/MUztciaAqUDc88dWxZkJ85bWp52u5xMa4XSNPDL9/j379hF7a65NnjvZbx8AwgPMxjl9+OroPdxHJeNBj7aezOpJFlKGCZL8DVo8mlkmvDr2vZpStEL6hKDmh6Wew2wkcjxCFJFNuM+JcHGRgTx6yJXqjxSDBrp/JVchZjxX1wrIOv1oWXlGf5Ib/zOkjTG1lWf+jGsnXggr1BCOwT4gRgaNKXsQKpty5d+oCzqivz0AIHmaJfPS+WmmNX2Omor3OpmuKMr/VO/+dYCSa1ETjBLDYVZpuHftv1zGMAwWtL29g3WNL+aZCiiX/btpidyAA+5qkdled7M0zSk7IoTZYWaEOeQYLjbIlZzZqwO49IwTYBhzed+Q0rxMPjuzXSHRhpIU1HiU/I0ihLEgf5uB+/ras9cL19gYx91iZ6a1Co2Cm1G1PXos4nKhWuaFNrHoqp63Rt+oA514J6EkH66mPKZgZFPyJC0cAAcxpic3L4WlfcWvWxjNmSmQe+Ieg1oTQB8xnVwGP+23gsZrM5EzFGEMBgq+lAA3Quq3sTi9B0cSgzVS1CX6Qtz4PQ6IM4Cb7rxlrbfc+uQBDh88D4EpW5ZaNKkBMWDtF4h1wCB5RgytSEpvgBwX24fFLPMqH2ibPXtgFlLHMc6OPWJfU3hmeKLzGDtE/69+Ud7cofpKFEsyuYE0d2v53ahAEm1vrX56WIsK+CuGi4x72lrOcbIKCbhKvRk33E4Ka9TWOHO1JdKpI3XNIlz2EdmW24/y2PsnrgdMGXrclCEhXItEBh6Fzgqduxjd6f/5r8SxFQZiHaMU7DY6Crm0MyZCzBlIUzUU+lp1wT79BQ5FNYvDS3bNnixi4+96r2R+xSDtHT4SzF2k0laEH4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 04:37:45PM -0700, Nathan Chancellor wrote:
> Hi all,
> 
> I am not really sure whose bug this is, as it only appears when three
> seemingly independent patch series are applied together, so I have added
> the patch authors and their committers (along with the tracing
> maintainers) to this thread. Feel free to expand or reduce that list as
> necessary.
> 
> Our continuous integration has noticed a crash when booting
> ppc64_guest_defconfig in QEMU on the past few -next versions.
> 
>   https://github.com/ClangBuiltLinux/continuous-integration2/actions/runs/23311154492/job/67811527112
> 
> This does not appear to be clang related, as it can be reproduced with
> GCC 15.2.0 as well. Through multiple bisects, I was able to land on
> applying:
> 
>   mm: improve RSS counter approximation accuracy for proc interfaces [1]
>   vdso/datastore: Allocate data pages dynamically [2]
>   kho: fix deferred init of kho scratch [3]
> 
> and their dependent changes on top of 7.0-rc4 is enough to reproduce
> this (at least on two of my machines with the same commands). I have
> attached the diff from the result of the following 'git apply' commands
> below, done in a linux-next checkout.
> 
>   $ git checkout v7.0-rc4
>   HEAD is now at f338e7738378 Linux 7.0-rc4
> 
>   # [1]
>   $ git diff 60ddf3eed4999bae440d1cf9e5868ccb3f308b64^..087dd6d2cc12c82945ab859194c32e8e977daae3 | git apply -3v
>   ...
> 
>   # [2]
>   # Fix trivial conflict in init/main.c around headers
>   $ git diff dc432ab7130bb39f5a351281a02d4bc61e85a14a^..05988dba11791ccbb458254484826b32f17f4ad2 | git apply -3v
>   ...
> 
>   # [3]
>   # Fix conflict in kernel/liveupdate/kexec_handover.c due to lack of kho_mem_retrieve(), just add pfn_is_kho_scratch()
>   $ git show 4a78467ffb537463486968232daef1e8a2f105e3 | git apply -3v
>   ...
> 
>   $ make -skj"$(nproc)" ARCH=powerpc CROSS_COMPILE=powerpc64-linux- mrproper ppc64_guest_defconfig vmlinux
> 
>   $ curl -LSs https://github.com/ClangBuiltLinux/boot-utils/releases/download/20241120-044434/ppc64-rootfs.cpio.zst | zstd -d >rootfs.cpio
> 
>   $ qemu-system-ppc64 \
>       -display none \
>       -nodefaults \
>       -cpu power8 \
>       -machine pseries \
>       -vga none \
>       -kernel vmlinux \
>       -initrd rootfs.cpio \
>       -m 1G \
>       -serial mon:stdio

Thanks, such a detailed steps to reproduce!
Interestingly, the combination of my compiler (GCC 13.3.0) and
QEMU (8.2.2) don't trigger this bug.

>   [    0.000000][    T0] Linux version 7.0.0-rc4-dirty (nathan@framework-amd-ryzen-maxplus-395) (powerpc64-linux-gcc (GCC) 15.2.0, GNU ld (GNU Binutils) 2.45) #1 SMP PREEMPT Thu Mar 19 15:45:53 MST 2026
>   ...
>   [    0.216764][    T1] vgaarb: loaded
>   [    0.217590][    T1] clocksource: Switched to clocksource timebase
>   [    0.221007][   T12] BUG: Kernel NULL pointer dereference at 0x00000010
>   [    0.221049][   T12] Faulting instruction address: 0xc00000000044947c
>   [    0.221237][   T12] Oops: Kernel access of bad area, sig: 11 [#1]
>   [    0.221276][   T12] BE PAGE_SIZE=64K MMU=Hash  SMP NR_CPUS=2048 NUMA pSeries
>   [    0.221359][   T12] Modules linked in:
>   [    0.221556][   T12] CPU: 0 UID: 0 PID: 12 Comm: kworker/u4:0 Not tainted 7.0.0-rc4-dirty #1 PREEMPTLAZY
>   [    0.221631][   T12] Hardware name: IBM pSeries (emulated by qemu) POWER8 (architected) 0x4d0200 0xf000004 of:SLOF,HEAD pSeries
>   [    0.221765][   T12] Workqueue: trace_init_wq tracer_init_tracefs_work_func
>   [    0.222065][   T12] NIP:  c00000000044947c LR: c00000000041a584 CTR: c00000000053aa90
>   [    0.222084][   T12] REGS: c000000003bc7960 TRAP: 0380   Not tainted  (7.0.0-rc4-dirty)
>   [    0.222111][   T12] MSR:  8000000000009032 <SF,EE,ME,IR,DR,RI>  CR: 44000204  XER: 00000000
>   [    0.222287][   T12] CFAR: c000000000449420 IRQMASK: 0
>   [    0.222287][   T12] GPR00: c00000000041a584 c000000003bc7c00 c000000001c08100 c000000002892f20
>   [    0.222287][   T12] GPR04: c0000000019cfa68 c0000000019cfa60 0000000000000001 0000000000000064
>   [    0.222287][   T12] GPR08: 0000000000000002 0000000000000000 c000000003bba000 0000000000000010
>   [    0.222287][   T12] GPR12: c00000000053aa90 c000000002c50000 c000000001ab25f8 c000000001626690
>   [    0.222287][   T12] GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
>   [    0.222287][   T12] GPR20: c000000001624868 c000000001ab2708 c0000000019cfa08 c000000001a00d18
>   [    0.222287][   T12] GPR24: c0000000019cfa18 fffffffffffffef7 c000000003051205 c0000000019cfa68
>   [    0.222287][   T12] GPR28: 0000000000000000 c0000000019cfa60 c000000002894e90 0000000000000000
>   [    0.222526][   T12] NIP [c00000000044947c] __find_event_file+0x9c/0x110
>   [    0.222572][   T12] LR [c00000000041a584] init_tracer_tracefs+0x274/0xcc0
>   [    0.222643][   T12] Call Trace:
>   [    0.222690][   T12] [c000000003bc7c00] [c000000000b943b0] tracefs_create_file+0x1a0/0x2b0 (unreliable)
>   [    0.222766][   T12] [c000000003bc7c50] [c00000000041a584] init_tracer_tracefs+0x274/0xcc0
>   [    0.222791][   T12] [c000000003bc7dc0] [c000000002046f1c] tracer_init_tracefs_work_func+0x50/0x320
>   [    0.222809][   T12] [c000000003bc7e50] [c000000000276958] process_one_work+0x1b8/0x530
>   [    0.222828][   T12] [c000000003bc7f10] [c00000000027778c] worker_thread+0x1dc/0x3d0
>   [    0.222883][   T12] [c000000003bc7f90] [c000000000284c44] kthread+0x194/0x1b0
>   [    0.222900][   T12] [c000000003bc7fe0] [c00000000000cf30] start_kernel_thread+0x14/0x18
>   [    0.222961][   T12] Code: 7c691b78 7f63db78 2c090000 40820018 e89c0000 49107f21 60000000 2c030000 41820048 ebff0000 7c3ff040 41820038 <e93f0010> 7fa3eb78 81490058 e8890018
>   [    0.223190][   T12] ---[ end trace 0000000000000000 ]---
>   ...
>
> Interestingly, turning on CONFIG_KASAN appears to hide this, maybe
> pointing to some sort of memory corruption (or something timing
> related)? If there is any other information I can provide, I am more
> than happy to do so.

I don't have much idea on how things end up causing
NULL-pointer-deref... but let's point out suspicious things.

> [1]: https://lore.kernel.org/20260227153730.1556542-4-mathieu.desnoyers@efficios.com/

@Mathieu: In patch 1/3 description,
> Changes since v7:
> - Explicitly initialize the subsystem from start_kernel() right
>   after mm_core_init() so it is up and running before the creation of
>   the first mm at boot.

But how does this work when someone calls mm_cpumask() on init_mm early?
Looks like it will behave incorrectly because get_rss_stat_items_size()
returns zero?

While it doesn't crash on my environment, it triggers a two warnings
(with -smp 2 option added). IIUC the cpu bit should have been set in
setup_arch(), but at the wrong location. After the
percpu_counter_tree_subsystem_init() function is called, the bit doesn't
appear to be set.

[    1.392787][    T1] ------------[ cut here ]------------
[    1.392935][    T1] WARNING: arch/powerpc/mm/mmu_context.c:106 at switch_mm_irqs_off+0x190/0x1c0, CPU#0: swapper/0/1
[    1.393187][    T1] Modules linked in:
[    1.393458][    T1] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 7.0.0-rc4-next-20260319 #1 PREEMPTLAZY
[    1.393600][    T1] Hardware name: IBM pSeries (emulated by qemu) POWER8 (architected) 0x4d0200 0xf000004 of:SLOF,HEAD pSeries
[    1.393711][    T1] NIP:  c00000000014e390 LR: c00000000014e30c CTR: 0000000000000000
[    1.393752][    T1] REGS: c000000003def7b0 TRAP: 0700   Not tainted  (7.0.0-rc4-next-20260319)
[    1.393807][    T1] MSR:  8000000002021032 <SF,VEC,ME,IR,DR,RI>  CR: 2800284a  XER: 00000000
[    1.393944][    T1] CFAR: c00000000014e328 IRQMASK: 3
[    1.393944][    T1] GPR00: c00000000014e36c c000000003defa50 c000000001bb8100 c0000000028d8c80
[    1.393944][    T1] GPR04: c000000004ddc04a 000000000000000a 0000000022222222 2222222222222222
[    1.393944][    T1] GPR08: 2222222222222222 0000000000000000 0000000000000001 0000000000008000
[    1.393944][    T1] GPR12: c000000000521e80 c000000002c70000 c00000000000fff0 0000000000000000
[    1.393944][    T1] GPR16: 0000000000000000 c00000000606c600 c000000003623ac0 0000000000000000
[    1.393944][    T1] GPR20: c000000004c66300 c00000000606fc00 0000000000000001 0000000000000001
[    1.393944][    T1] GPR24: c000000006069c00 c00000000272c500 0000000000000000 0000000000000000
[    1.393944][    T1] GPR28: c000000003d68200 0000000000000000 c0000000028d8a80 c00000000272bd00
[    1.394355][    T1] NIP [c00000000014e390] switch_mm_irqs_off+0x190/0x1c0
[    1.394395][    T1] LR [c00000000014e30c] switch_mm_irqs_off+0x10c/0x1c0
[    1.394519][    T1] Call Trace:
[    1.394584][    T1] [c000000003defa50] [c00000000014e36c] switch_mm_irqs_off+0x16c/0x1c0 (unreliable)
[    1.394676][    T1] [c000000003defab0] [c0000000006edbf0] begin_new_exec+0x534/0xf60
[    1.394732][    T1] [c000000003defb20] [c000000000795538] load_elf_binary+0x494/0x1d1c
[    1.394765][    T1] [c000000003defc70] [c0000000006eb910] bprm_execve+0x380/0x720
[    1.394796][    T1] [c000000003defd00] [c0000000006ed5a8] kernel_execve+0x12c/0x1bc
[    1.394831][    T1] [c000000003defd50] [c00000000000eda8] run_init_process+0xf8/0x160
[    1.394864][    T1] [c000000003defde0] [c0000000000100b4] kernel_init+0xcc/0x268
[    1.394899][    T1] [c000000003defe50] [c00000000000cf14] ret_from_kernel_user_thread+0x14/0x1c
[    1.394946][    T1] ---- interrupt: 0 at 0x0
[    1.395205][    T1] Code: 7fe4fb78 7f83e378 48009171 60000000 4bffff98 60000000 60000000 60000000 0fe00000 4bffff00 60000000 60000000 <0fe00000> 4bffff98 60000000 60000000
[    1.395420][    T1] ---[ end trace 0000000000000000 ]---
[    1.526024][   T67] mount (67) used greatest stack depth: 28432 bytes left
[    1.605803][   T69] mount (69) used greatest stack depth: 27872 bytes left
[    1.667853][   T71] mkdir (71) used greatest stack depth: 27248 bytes left
Saving 256 bits of creditable seed for next boot
[    1.926636][   T80] ------------[ cut here ]------------
[    1.926719][   T80] WARNING: arch/powerpc/mm/mmu_context.c:51 at switch_mm_irqs_off+0x180/0x1c0, CPU#0: S01seedrng/80
[    1.926782][   T80] Modules linked in:
[    1.926910][   T80] CPU: 0 UID: 0 PID: 80 Comm: S01seedrng Tainted: G        W           7.0.0-rc4-next-20260319 #1 PREEMPTLAZY
[    1.926990][   T80] Tainted: [W]=WARN
[    1.927025][   T80] Hardware name: IBM pSeries (emulated by qemu) POWER8 (architected) 0x4d0200 0xf000004 of:SLOF,HEAD pSeries
[    1.927091][   T80] NIP:  c00000000014e380 LR: c00000000014e24c CTR: c000000000232894
[    1.927131][   T80] REGS: c000000004d5f800 TRAP: 0700   Tainted: G        W            (7.0.0-rc4-next-20260319)
[    1.927179][   T80] MSR:  8000000000029032 <SF,EE,ME,IR,DR,RI>  CR: 28002828  XER: 20000000
[    1.927253][   T80] CFAR: c00000000014e280 IRQMASK: 1
[    1.927253][   T80] GPR00: c0000000002328ec c000000004d5faa0 c000000001bb8100 0000000000000080
[    1.927253][   T80] GPR04: c0000000028d8280 c000000004509c00 0000000000000002 c00000000272c700
[    1.927253][   T80] GPR08: fffffffffffffffe c0000000028d8280 0000000000000000 0000000048002828
[    1.927253][   T80] GPR12: c000000000232894 c000000002c70000 0000000000000000 0000000000000002
[    1.927253][   T80] GPR16: 0000000000000000 000001002f0a2958 000001002f0a2950 ffffffffffffffff
[    1.927253][   T80] GPR20: 0000000000000000 0000000000000000 c000000002ab1400 c00000000272c700
[    1.927253][   T80] GPR24: 0000000000000000 c0000000028d8a80 0000000000000000 0000000000000000
[    1.927253][   T80] GPR28: c000000004509c00 0000000000000000 c00000000272bd00 c0000000028d8280
[    1.927629][   T80] NIP [c00000000014e380] switch_mm_irqs_off+0x180/0x1c0
[    1.927678][   T80] LR [c00000000014e24c] switch_mm_irqs_off+0x4c/0x1c0
[    1.927715][   T80] Call Trace:
[    1.927737][   T80] [c000000004d5faa0] [c000000004d5faf0] 0xc000000004d5faf0 (unreliable)
[    1.927804][   T80] [c000000004d5fb00] [c0000000002328ec] do_shoot_lazy_tlb+0x58/0x84
[    1.927853][   T80] [c000000004d5fb30] [c000000000388304] smp_call_function_many_cond+0x6a0/0x8d8
[    1.927902][   T80] [c000000004d5fc20] [c000000000388624] on_each_cpu_cond_mask+0x40/0x7c
[    1.927943][   T80] [c000000004d5fc50] [c000000000232ad4] __mmdrop+0x88/0x2ec
[    1.927986][   T80] [c000000004d5fce0] [c000000000242104] do_exit+0x350/0xde4
[    1.928028][   T80] [c000000004d5fdb0] [c000000000242de0] do_group_exit+0x48/0xbc
[    1.928072][   T80] [c000000004d5fdf0] [c000000000242e74] pid_child_should_wake+0x0/0x84
[    1.928128][   T80] [c000000004d5fe10] [c000000000030218] system_call_exception+0x148/0x3c0
[    1.928176][   T80] [c000000004d5fe50] [c00000000000c6d4] system_call_common+0xf4/0x258
[    1.928217][   T80] ---- interrupt: c00 at 0x7fff8ade507c
[    1.928253][   T80] NIP:  00007fff8ade507c LR: 00007fff8ade5034 CTR: 0000000000000000
[    1.928291][   T80] REGS: c000000004d5fe80 TRAP: 0c00   Tainted: G        W            (7.0.0-rc4-next-20260319)
[    1.928333][   T80] MSR:  800000000280f032 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI>  CR: 24002824  XER: 00000000
[    1.928413][   T80] IRQMASK: 0
[    1.928413][   T80] GPR00: 00000000000000ea 00007fffe75beb50 00007fff8aed7300 0000000000000000
[    1.928413][   T80] GPR04: 0000000000000000 00007fffe75beda0 00007fffe75bedb0 0000000000000000
[    1.928413][   T80] GPR08: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[    1.928413][   T80] GPR12: 0000000000000000 00007fff8afaae00 00007fffca692568 0000000133cf0440
[    1.928413][   T80] GPR16: 0000000000000000 000001002f0a2958 000001002f0a2950 ffffffffffffffff
[    1.928413][   T80] GPR20: 0000000000000000 0000000000000000 00007fffe75bf838 00007fff8afa0000
[    1.928413][   T80] GPR24: 0000000126911328 0000000000000001 00007fff8af9dc00 00007fffe75bf818
[    1.928413][   T80] GPR28: 0000000000000003 fffffffffffff000 0000000000000000 00007fff8afa3e10
[    1.928765][   T80] NIP [00007fff8ade507c] 0x7fff8ade507c
[    1.928795][   T80] LR [00007fff8ade5034] 0x7fff8ade5034
[    1.928835][   T80] ---- interrupt: c00
[    1.928924][   T80] Code: 7c0803a6 4e800020 60000000 60000000 7fe4fb78 7f83e378 48009171 60000000 4bffff98 60000000 60000000 60000000 <0fe00000> 4bffff00 60000000 60000000
[    1.929054][   T80] ---[ end trace 0000000000000000 ]---

> [2]: https://lore.kernel.org/20260304-vdso-sparc64-generic-2-v6-3-d8eb3b0e1410@linutronix.de/

> [3]: https://lore.kernel.org/20260311125539.4123672-2-mclapinski@google.com/

@Michal: Something my AI buddy pointed out... (that I think is valid):

> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index df34797691bd..7363b5b0d22a 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2078,9 +2082,11 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
>  			unsigned long mo_pfn = ALIGN(spfn + 1, MAX_ORDER_NR_PAGES);
>  			unsigned long chunk_end = min(mo_pfn, epfn);
>  
> -			nr_pages += deferred_init_pages(zone, spfn, chunk_end);

Previously, deferred_init_pages() returned nr of pages to add, which is
(end_pfn (= chunk_end) - spfn).

> -			deferred_free_pages(spfn, chunk_end - spfn);
> +			// KHO scratch is MAX_ORDER_NR_PAGES aligned.
> +			if (!pfn_is_kho_scratch(spfn))
> +				deferred_init_pages(zone, spfn, chunk_end);

But since the function is not always called with the change,
the calculation is moved to...

> +			deferred_free_pages(spfn, chunk_end - spfn);
>  			spfn = chunk_end;
>  
>  			if (can_resched)
> @@ -2088,6 +2094,7 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
>  			else
>  				touch_nmi_watchdog();
>  		}
> +		nr_pages += epfn - spfn;

Here.

But this is incorrect, because here we have:
> static unsigned long __init
> deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
>                            struct zone *zone, bool can_resched)
> {
>         int nid = zone_to_nid(zone);
>         unsigned long nr_pages = 0;
>         phys_addr_t start, end;
>         u64 i = 0;
> 
>         for_each_free_mem_range(i, nid, 0, &start, &end, NULL) {
>                 unsigned long spfn = PFN_UP(start);
>                 unsigned long epfn = PFN_DOWN(end);
> 
>                 if (spfn >= end_pfn)
>                         break;
> 
>                 spfn = max(spfn, start_pfn);
>                 epfn = min(epfn, end_pfn);
> 
>                 while (spfn < epfn) {

The loop condition is (spfn < epfn), and by the time the loop terminates...

>                         unsigned long mo_pfn = ALIGN(spfn + 1, MAX_ORDER_NR_PAGES);
>                         unsigned long chunk_end = min(mo_pfn, epfn);
> 
>                         // KHO scratch is MAX_ORDER_NR_PAGES aligned.
>                         if (!pfn_is_kho_scratch(spfn))
>                                 deferred_init_pages(zone, spfn, chunk_end);
> 
>                         deferred_free_pages(spfn, chunk_end - spfn);
>                         spfn = chunk_end;
> 
>                         if (can_resched)
>                                 cond_resched();
>                         else
>                                 touch_nmi_watchdog();
>                 }
>                 nr_pages += epfn - spfn;

epfn - spfn <= 0.

So the number of pages returned by deferred_init_memmap_chunk() becomes
incorrect.

The equivalent translation of what's there before would be doing
`nr_pages += chunk_end - spfn;` within the loop.

-- 
Cheers,
Harry / Hyeonggon

