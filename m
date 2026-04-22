Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C66AEFA1FD7
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 16:45:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 820D06B008A; Wed, 22 Apr 2026 12:45:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D0E06B008C; Wed, 22 Apr 2026 12:45:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 671AE6B0092; Wed, 22 Apr 2026 12:45:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 513636B008A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 12:45:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F07C38AEB2
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 16:45:34 +0000 (UTC)
X-FDA: 84686767788.08.C6011AD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7BBC62000E
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 16:45:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Fj7NZByP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xmrc0EtF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776876331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iGffhCpWV6pE9k2sfamAp0oZAk+Mnr4jwnSFXd24X/A=;
	b=7mWrZvn6O/mI/7v5wt40bda0fNrtu7oYGYj9eUHCh5QY2D5HF4kMTRYebG4qp/lmtlCbWg
	aWmbSdkn4b9CnB78Gs2F+AzgWZhXR63cFigguWkwaE+lw096MmP7qRXmIY83eJwX9G7FcQ
	27ffjg+fWQvhLoNLWM955rPlEv5DTt8=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Fj7NZByP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xmrc0EtF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776876331; a=rsa-sha256;
	cv=pass;
	b=VpRmLeRWZ/XP19Ba5KgbciNZ5bkNJyGsoDvx+5ObIvLo1pg7b/1TFgtKHEMCCL+R6r1yhu
	vJHuaH0H7DT6HZUVqIdhuqquc1h/BcC/r42uAJ0zk/dUowkfQskk5oWA6xus82Nch0apcp
	zxDcJPOUZsyT6qvd9H4LVHQGy3Ti4uU=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63MBmOsc2558566;
	Wed, 22 Apr 2026 16:44:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=iGffhCpWV6pE9k2sfamAp0oZAk+Mnr4jwnSFXd24X/A=; b=
	Fj7NZByP4V9uKTeT/f8VCHKWRKH1rpCti6crerqTiyyuv0FfeQH3Pxq1RY+mTtqK
	8PcU3j2IIpUCi47YhOnARSnEmxl8iBI8sPkSclnR8hJxg4VzXz5Pbo+xdwzPeG1D
	FsmzZj2PhbdyUdtj9Yazm1/yGjFSjPSU1EV8e6A2/fG6jBvkLafei/slnLNV2Vuq
	2Kx802WK0wztjNSt1XdzjYrtpsFlZhesotV1+ehX/KY0IphuJv7+qVNgCw283q2V
	J1/j5WL+S3BxkP6wyOZN+SPfn2zKinJfykFbE/ICXTBB4CbjlR4lLxtGx41HAnBG
	rE791JpucsATPqftVMAKXw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dpha59j05-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 16:44:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63MGfKmu030255;
	Wed, 22 Apr 2026 16:44:49 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010047.outbound.protection.outlook.com [52.101.56.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dpjjqfvdr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 16:44:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rPi2D5rvfiJupWp8eKH/VL0kmFJYiJiM+o3z+bVhpl0xzYIOSDni1XlYllF5uddpGh1ADlhuztGkPVQ3SghWRVs0Z/WS4R8OsAr7Q0vV0rjW81fYfcNLF1VWZ1wOajQJwBdQ73eHVK9+HBd/Vys1gk3UPdGi0o4fEQpQgNN8lsLxjdnD5lJxzCgzHk9ucgh8wWZDKqI349hVblpkOueWEAxVbnJWVk3lnvMMTKkuUucnu8k/cYiUTLVqBA0ZrNA1Js4HI0qIvYpiq49VoDXY9+qrzcaPbnDme5SDEJ8ufTCfxOLh53yvLD3VtteOFoG2g1rF9mek5LdWwXxlV1MoHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iGffhCpWV6pE9k2sfamAp0oZAk+Mnr4jwnSFXd24X/A=;
 b=gZs0tVS7HDDHfUQA7eIY+6sW1x4ozi4mvtoHS/avB+LbV595ZnY/7qY+wmiHTa4hm8unW3t0sjcIyhPtfdLjO2w1lfpel8RiMhPkY/vye2cHy4ovC9UoQdqw0mwGbh95VzIS+Rf6/HCAbBt7ZWQy3Iip1+OOjOB7NK/Ik5ZB3fZIMud7LkuRdzbfXwr4TwRX97QQS1PZYeh7xpSRj705T1PRT1G2BhFHj7APPaLBlbpK5RTX465pjJOdCx1xeaav698Zvy2dbW37byT0LHp2+LsOSbUO6AHIsuY5pTQcZ7n0T9yqFaPBA/n5/hOGpXfNx0egc3w5C6T/fsmC/vwcmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iGffhCpWV6pE9k2sfamAp0oZAk+Mnr4jwnSFXd24X/A=;
 b=xmrc0EtF4PN1iaSjkShmNRgsPBJSREI7AQ/epJTcvnEsphrdbXDPL0SUGTloRJRtjV/EffMLhXI5V/wfpjUO5TVxaLi4kERzD9uKDeQu1vwO4H2GQV3lEWWgVhZ+3RoA4rw0D0LwvAqzvhmL8Wc2hnObxr3T6biVY2LYH1mKLSE=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 DSVPR10MB997821.namprd10.prod.outlook.com (2603:10b6:8:383::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Wed, 22 Apr
 2026 16:44:46 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%3]) with mapi id 15.20.9846.019; Wed, 22 Apr 2026
 16:44:45 +0000
Message-ID: <a36c592b-0456-4551-9a53-f513233cc129@oracle.com>
Date: Wed, 22 Apr 2026 09:44:40 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] hugetlb: open-code hugetlb folio lookup index
 conversion
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
        osalvador@suse.de, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
        vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        corbet@lwn.net, skhan@linuxfoundation.org, hughd@google.com,
        baolin.wang@linux.alibaba.com, peterx@redhat.com, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260409234158.837786-1-jane.chu@oracle.com>
 <20260409234158.837786-2-jane.chu@oracle.com>
 <aeZwAz6PcdlqSnJ2@casper.infradead.org>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <aeZwAz6PcdlqSnJ2@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0004.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::17) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|DSVPR10MB997821:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ddac1fb-a279-4aeb-741c-08dea08e75cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	WIk5A3tsuiuxaigd4MxnC0sbz/8cJLyBNXS1qJby3byVoh3lIBmzmXuirV8OpGmgbQaDUyGu/Ba472telthX0Ly3J8DFFRBLN4e4ZNuwpmHjkIurcNwx2wyqr39JXbod/a+kGB+SUb6QtpwX79zWRotsm4Z2K7UIlxWhqSC6MpTbOq3jkAvmglsQEm1o2kIs7m1sGiN4h2TeXO9zYux2knO3Y7osPjgDbk2wWAuM+aVHot2Md77BrQH3rmw62VcFYh9qkCo3Tx2fDAS2vqF5de7vjFhVSpxMA+hMwxvX3G5mMjSRzyYehVXHZZBFzdiEunxhqR4ilKEUzcVwd6SuTa4JBUHpl4ePbPtNmAGExRHV8pZIAjy5FWEw2IcOnC3z/5w0E6gcfQfa/rwU2BZ85HbwfyP0sRaMUh/VjmYExJEBtF2JChrRB+S4jMWtMDUFp/z0lLhYI9BmoY7jLe5sz4QJ/9p8HTI7RYZ3otq/PfzAYUcYZLo7/0fwCVKt9bq2xIz7dCw/gKA93MoLN6pKlTbfBfZ7nURTtEYH4ktypKZx0QG2Gc1tNPWAP8y4xPp3/44U/eDUFiWN6UgYms3r8rKsDVy5b+U8BBa6S2MIJr832E5J2uT1zg1TnYl5HRRsZtZ3V8lHBojaek+82y410Amx0RaCRT/On+LQFdMzsrlRXd4gC/+8+dbSUkJ0OgXPwPUzp3MhhvU8ZpWqMuoMrzqFak6fIGvl7zSzLINyrKQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YkhSQWptOHE5VWN5Z0ZHZ25jaHpjRWlldllRR01EMmFtY0tZOStOZlVRdVBY?=
 =?utf-8?B?cWVoME5lWkZQMFV5UExzRGdiMlJSL0t2WE9HNm01aEozcFlLNWhNcmdNU09Z?=
 =?utf-8?B?OFpXUlpERXVGTTd4Z2pQSENTeGtqREtJeEhUVllzc2ozQUVIOS9QK0RMOFVr?=
 =?utf-8?B?bVlSQm4wV1RCUEc4VEJmdThxLys2QS92ZVpHQllqd1Nlb1R5cGxQMHJHeHVJ?=
 =?utf-8?B?SUxtQm5ETUVLdTVOelBKcW1Qc0o3TUs0YndFaW5MT2dzYnpueFl5NjZwVzBI?=
 =?utf-8?B?TUt5akFrY2VLcnIxcDVucFhaZE5KNmo2bENpOUZKTGQ0ZkQ5ZUJsRzFkQVlZ?=
 =?utf-8?B?cVZLMDNlYTFhNXVsR3RqMW42Qy9zendtU2FTbFMvazFjbEpaWVM1THZSTE40?=
 =?utf-8?B?cmc1UUlxL1ZlMnNrcVVFV1JEL29paXdWaWJqVmI2dGQweDNpUmlMby9Jc09H?=
 =?utf-8?B?OGR3dWRlUDVOTHRQdmVINjB1Ym1RVFJHUUJkZ29hNUxuZTlSTGNJaFZsVXI2?=
 =?utf-8?B?UmtIQTNmdmdyY2tWWS95d2JjY2dvSm8zY0RQM0VyUHdWdytLNUN4Q1dWcmZH?=
 =?utf-8?B?ZFRwS01qVnQwc0tWSTY4MGp5eit5SWZJSzlIbXlRVnNOTW5MeVQ4TG14R1U4?=
 =?utf-8?B?Y0swdTlLMEJIUXJ6amgzbGtWcXArMEovblFzaXNrQkRnWW9CclVYWmQxQ0Fs?=
 =?utf-8?B?QXZrZmY5cUd3MkNIQjRRTVBwMFI1c095aURlY05NRGJzcU8vT1ZOd2lnaTVo?=
 =?utf-8?B?dlU0UWs0UHNTcGY2N3QyaTA1WFlNbk1mQTJmRU9odmVnVTI5eWxPNkJoKyts?=
 =?utf-8?B?cFMxRmt4aXhGUzc0ZnIzekJ0UUQ1eVZuRlNPU0lhTUVGdmROZnNxd1lvSjcw?=
 =?utf-8?B?bjFqU0VjcVk2OGtKK0FjOE1nVUZEbXBiZTBnQTdFc2hOclFDei9pT2hIQktw?=
 =?utf-8?B?YXRPYkZGd1ZyTTRBak5vak5HRTJJZjRJeE8yK1NxcEJPU2h1ZDNDS0d3cTFn?=
 =?utf-8?B?S3U1ZHRGalNUdGxVMlN4dS9wOEw1WlVFZXdTZForVVJ0VXREeVFuRjl3SndS?=
 =?utf-8?B?RDhZUmt2RWs3SUIvVitvQ3lTSVg1dVBnajRJQmZCQUFmNFltWG9xOEdxN2l4?=
 =?utf-8?B?dDBtV2ptanlnTmNUMzFvWlhiNU9OdVZQM1hsMjk1Tk1ubEZGbjZQVVN4bE42?=
 =?utf-8?B?KzY2WTBrd0tFRnJwSFVpaFpoSWJtaHlza0JNOFV5eEZRODFpaFBPakwxazFp?=
 =?utf-8?B?UzIwL1ROeXBuWERVQWh6Ynl5bVg4S2RPc1FKYjJtcWVhL0JCZ0pIcVczQkhs?=
 =?utf-8?B?MXNIOVJpUnNOUkdPYkorUFhXSmpsWXl2MXZ1bVlhSllJRE11cmFyQWJWZU9L?=
 =?utf-8?B?dlhpV2I1NzJVZm51U2o3eGtkUmZQcHRxMlBBNGdHNjhOVUhiSzAvOEpYR3dO?=
 =?utf-8?B?VTNaMnY4dmpaQ1pRb21RUGllRUIzOFllVTgvekUvQi9BQzlsUG9UOHcyZU5V?=
 =?utf-8?B?TURRRG04b2Vxcm9xUk04ZkZpQXRwMWlWWkdsRFFQWjBTZ3dER1hMMndMMlNw?=
 =?utf-8?B?TE5uODl3cHFOVWt2bzZxRWNSQnV6aU1xM3RFRWRFVmxudit6eTdZV3dYOHo0?=
 =?utf-8?B?U0kxWm5JdE1kT2pJVXpwdmN1ODJRTUtqREtjNVpJeUZGWS9VS2hpQmZ3ZmVV?=
 =?utf-8?B?TCtHUXdNUW9KclFIMGlWSWo0OVp0WDhtWXZLbktaT1BZekV1UXF6RnVXdFdt?=
 =?utf-8?B?bUNERS8vNGIycXRIMjcrbG9ZUE5Yb0VySFprSnYvMGsvT3llODVSWVp1czRj?=
 =?utf-8?B?MHorNnpuU3RPWmwzNnpjMlJCMFNOS3loVVlYNVJEWXFNUm5qSTJLak8zMjFN?=
 =?utf-8?B?VTVXbGJGL1ZoaVoxNHNXOEZuZkxiMlg5UjNmNkpGNlJXYktUb2xkNzJVNGdO?=
 =?utf-8?B?YStoYWphS0JqSzlvUXJrUjY5aDM5WXFjMVp3NG4rMUFxdXJWQmZZaE1Cemx1?=
 =?utf-8?B?SDNpdE1seTRtK3lyU2N1ZUJCT3l5TTk4N1krN3pXZGY1czdFTngwb09mcVZq?=
 =?utf-8?B?RGFGWTA5cVdhVTN2TkJLOTF4bldKbGFvVnRlSnUrM01ha1hlcjJ1SDZ3c3FP?=
 =?utf-8?B?QlRWNzRoVUxQcHZoVWFuRHBubUtsTngxMGhjSjVpeGIvdFh6UG9GMlFIQkdL?=
 =?utf-8?B?NzU5eWJpMXBuN2tPVU1mYU56RWFTWXBGK1A0aVgrYWZqeUFBUkk3TGpReGUz?=
 =?utf-8?B?ODlObDZhTUxQbWs0Um80eWRtclJlQXpwV1dxeUVwdlNjZXc5U09Bbi85YXpL?=
 =?utf-8?B?a1hiZXVvR0tGazUxNW5NdDY4dFN3azJEUGxZYWRocGQxS1ZwaGpUUT09?=
X-Exchange-RoutingPolicyChecked:
	Ce0K5FsBAWA+3tuaZlOyupf+FXVPZ+FhoSNYrTpsVvt2+eg0z13KqvrTsX7G7CvN4l/bW7vSFaw5D3qkgNoAoWtBKzfPx4x+T85TMfC8IDS9SAqktOdk8K8TxPXImzHmk4KlXJ/YT3hqHuWMDNkoYvdzWd0DU+S5Q3hG5ktj2sU9fFuRHQgxNwJFNHCRXbr8czmvgwM7lARRKbKZEXhSd5L6vVrycHkWHk9NVm4WnGeAmUDJGhKWHrDt7o6JPRgKb9QRM284W5qxO8Fa5Rh2yOlT+pSMz5lQfZl/DDfXXk+Vm+1/oHREhz2umKmP0gz4fJsZSddvDMS9u3+GFegsSQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1uslenc3UCgvcmq8lhKpbQkx/oa8FlG9rDYv/kfcxm20NUrtrSlsUOsw+1qdw6GmkJifhNMHYmJlc3/RMOt2h1e2Z7kTC/rnQIlvpG27/kTuA6qEPFOTyo+c89H//YJBQpakVvXcIsuqyY8ROVpnHBmLEwBQer4gudgp0JrNlRpYunDi9kSp+BFofV8nv0of8HN3JXUIm5xvYPHwRey33XF6/tYBkTs/1ChW71DBWMHoq1jrwXZEPRi+0RpebdoAKSYt2F7po4f4Ypuuu0tPIXG3SeJFA5Dhl9+RU2xj/aIs6Zb1yahvlPeIl2oOHVsAs2bDIQVv5T6UbYaEOGFw2sxt+jyW9JYx/AC5mWMiz8EyVc3nqM4MygDckEjE0rABiinurCKANbNpRsKDvgujFaorLLV1kJcp5FLFvJ6DO/SEGnIMhHGRD4yEvgZQeE96YsZrkq26/4/q80SpR1lceUJemixbL8zicQ/p9YubAGwyYSiJl5mbdIufGJaFPCKwY4rqGpXo+YunhWoK35KmKjN4z/tMRbp+PIGAx7cymZA/C+pcUGoJ9pWSMgmIr3SW6WYI83QLbuRuIXBDXmHL7Fq4twl7waer0ys5/iZHnNo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ddac1fb-a279-4aeb-741c-08dea08e75cb
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 16:44:45.8162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 17yvjleydCjMrfjjYSwgQwiC13RTQl65IS1fakRLTinDEt6NLklSnoyIU6bV/2nrwhsmgcaKV0nwg++mURox3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR10MB997821
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-22_01,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 spamscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604220162
X-Proofpoint-GUID: Cq8yCHWSVe1EviWC87sKPmkY5OsGN4HD
X-Authority-Analysis: v=2.4 cv=QM5YgALL c=1 sm=1 tr=0 ts=69e8fb02 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=96wP7kw-SJ_3bd_VmpIA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12291
X-Proofpoint-ORIG-GUID: Cq8yCHWSVe1EviWC87sKPmkY5OsGN4HD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDE2MiBTYWx0ZWRfX3dxs3oZWKaC4
 iDN+Gms05wVooC/P4f9M2c+dJcF9XKynrTHlfb1RDOg1Lk+vURWIjcEiGhfGT3DFuOuhUkaGqfi
 EAm7QL7VDegTanlKu06GcS3vSDOkD2embscVNqvf8RNQShQsd6A1aruuVlSKE/g0U+zLSRBPW2d
 /4+QGXteSNWO5cQTBsyyEZaerIm4xYIlpNkQYpJRFip2crEaOb/jyFGnTwGeVMqBtQiPYhc1X0A
 GjB6d8MNeoIwzLw44ap4pKEHMqov3PTY/hXmVVOD+Fp69An6t83Vx32Qpf1sLu9GLeMfrmBl3/g
 Tyk8/wlPbG/Z3GRTPxE6nJvNwmiIGRCidjnr0CO0B5+QpKM+sc7l0DvaPEqeedRSQ0rEIIyNALR
 Z4s3GfjQFvYEx9Iq00oCKOVBVB/YJUY9wZr+R0I79ryuHi6Fk+zm/S3wCQs8DqWaOZ9T/vvXrpf
 gFol3NPrvYSOpyIHetNIHx3oixnF93mDWPPGbvjI=
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7BBC62000E
X-Stat-Signature: ms31wubdfcq8cd88xfnz6hc6uddkh6ix
X-HE-Tag: 1776876331-779636
X-HE-Meta: U2FsdGVkX1/PrITRrUxjNl+oTYiIUEu+WbcOV6NSW0eQD3p6dAwIFYSrR4QhplOwsRKWQO2iZT6OK1ZPTdUXJIiSkQHFmGwVGDnPJ1F1LIjX07nHa7v/oGjfmefuer2EaM/B+T+1/2y5j8CW38Qz5U9mBcoDTW9sfus1Kp3EomvPWPW371aEjdh182+MhBf55oIwwlGvTVcBifZsXcnLvBZ7p6jzt17cj6Qhrf4IZ1yrwcQAWPq/Z9GgDo6iNuF9Nj073yoPg9DqL9ha1NDzSUHeCEBTnzczZDQ3veQQDkaI7uv03hrs4bZIdKfEs2gX+E398CtZTNqHtHSXhHn1jcZYl+MQSYlu4klBa+88ZFpIZr7KRmlHeOKHL0wI7D4AGhlyu57E+XeL5hFuMbuvQriLyU/pappG+UuEA0E1mXytI6KgNplarDUkPFYT/YiKX5hhEmPHe1jauIen7xmSiViswxGb5Q2MDGSo/8Bx3Yi74gDrFIdxFfQpqkvzMFYHKVQCLDz/McL73sw4g0P9y0rgwnp2gre1v5ke2yGOZQm8IJ9dJ+qef/+5tXLeu6NCizPi16PtJzTS4cUsTmXtC34fwa1ffvCcbJZj+StHUsB5mOSHM05AV96zCoWyDIZzYcCnQqYsKZc1LveVVAfgkp3CLtAXagwvBIz8DIySVwehRyCNTTmn0zp32RPWOyGjyCLlCXZiXb9G85mfOpd7ocWFk5DRviotrTfjXw/vWmwNIOk9MHCpBW05hBdHYtp4gbIB4jr7fpv+hSMhVtRl28p5rM0/YVlPjwHY33iXZGGJWvhGx6HztdcPjYzcBD4dCtDJMSDGCocIesI/4ZAnqMnTj2Lg03MtCDmmrNtLnrs98Nu9k7xIKAADbLEs4UirTXWusTLI8QlA3sS5Qkv1tQxXPPmbSoJHfCuz7GNPBTpkf5qawGEfghG0SsoF1xAHfkZT70XBniX8RuJ/rDo
 Weyqw2pq
 OixxNnB/DTMHAXEnrg/Zx1regh/iPd5HCS9eeYk2uzc7xb4LKez5tCla21XvcdMT/0uWdwkdH+n0dQckckZuDjGz3JmvCWOoebaN+fd0t4jgYGMV94PtSkq17ue32uGDo5/JnwPL0gLWM8irsrm80ex90uA+Vf97cGtqF2pdlz1a7nA/GL3I9QyxfVafFe6zDsLYiJqynErXyVwh/ViLx6TDA3X0wQagCANSMy/36YUB6LHoKpcQWXKhzdWQmlbxEWqFjKkUnvsZiEAHhBg2iYaiES0GpHaNDYccKgyNBvc9M3nZBHgjG+GgyKVE3BTFsf6up/A4HO4K5MS+rWfyRFJYTgJ6t89be9wEOTdsQRbKEg9lCIGk256MBlpDq4kfnZThGzkrb7h8ALe5sToC1c5Sj+cUWg6F/+i/+jG102J2SreabJE7QNXTXtn9Tx8Quq9giHmTBHTL2fd9KWsy/rCz6yrelaXpkBb4O9uTGQ0o1BbDaPPGjmZGfaNmD9Hcu0HahNbFIf8wJ+boB+DWpObucCQ7r1VKgtxUzGHZcThW1siiywMEENVIKKxaouZ/TkAVBqeGKDWKuyA7WRAcebz6SOjGCOeuZMfCMq1qDvZOXsB4k8952dEBqRb2VFtr+dT23KBPNRVNqEhhrsD7+0LPSZTQDGUkN5UtS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/20/2026 11:27 AM, Matthew Wilcox wrote:
> On Thu, Apr 09, 2026 at 05:41:52PM -0600, Jane Chu wrote:
>> This patch removes `filemap_lock_hugetlb_folio()` and open-codes
>> the index conversion at each call site, making it explicit when
>> hugetlb code is translating a hugepage index into the base-page index
>> expected by `filemap_lock_folio()`
> 
> I think this is too large a piece to break off in a single patch.
> The first thing I did was look at hugetlbfs_read_iter() and wonder
> why we're not able to use generic_file_read_iter() here?  It used
> to be necessary because we used to index the page cache in units
> of hsize, but now we don't, it seems to me that we could use
> generic_file_read_iter() instead.
> 
> Now, what hugetlbfs_read_iter() does have is support for hwpoison
> handling.  I suspect this is something we want in
> generic_file_read_iter(), it's just nobody's done it yet.
> 
> So perhaps that's patch 1 -- add hwpoison support to
> generic_file_read_iter().  Then patch 2 removes hugetlbfs_read_iter() in
> favour of using generic_file_read_iter().
> 
> Patch 3 is purely this:
> (and you can put my Reviewed-by on it).
> 
>> @@ -652,10 +652,10 @@ static void hugetlbfs_zero_partial_page(struct hstate *h,
>>   					loff_t start,
>>   					loff_t end)
>>   {
>> -	pgoff_t idx = start >> huge_page_shift(h);
>> +	pgoff_t index = start >> PAGE_SHIFT;
>>   	struct folio *folio;
>>   
>> -	folio = filemap_lock_hugetlb_folio(h, mapping, idx);
>> +	folio = filemap_lock_folio(mapping, index);
>>   	if (IS_ERR(folio))
>>   		return;
>>   
> 
> Now for patch 4 ...
> 
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index a786034ac95c..38b39eaf46cc 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -5724,7 +5724,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
>>   	 * before we get page_table_lock.
>>   	 */
>>   	new_folio = false;
>> -	folio = filemap_lock_hugetlb_folio(h, mapping, vmf->pgoff);
>> +	folio = filemap_lock_folio(mapping, vmf->pgoff << huge_page_order(h));
>>   	if (IS_ERR(folio)) {
>>   		size = i_size_read(mapping->host) >> huge_page_shift(h);
>>   		if (vmf->pgoff >= size)
> 
> This points to a horrible problem.  Everywhere else in the VM has
> vmf->pgoff in PAGE_SIZE units, and of course hugetlb works in units of
> hpagesize.  So this is an entirely different piece of work where we
> convert vmf->pgoff to be in units of PAGE_SIZE.  That'll be fun!
> 
>> @@ -6208,7 +6208,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
>>   
>>   	if (is_continue) {
>>   		ret = -EFAULT;
>> -		folio = filemap_lock_hugetlb_folio(h, mapping, idx);
>> +		folio = filemap_lock_folio(mapping, idx << huge_page_order(h));
>>   		if (IS_ERR(folio))
>>   			goto out;
>>   		folio_in_pagecache = true;
> 
> This is a much smaller (more contained) problem.  At least idx is local
> to this function, so you can calculate it using linear_page_index()
> and modify the whole function.
> 
> Finally, you can delete filemap_lock_hugetlb_folio():

Thanks Matthew, these are great suggestions and I am looking into them.
Main concern is potential performance impact, will find out.

Thanks a lot!
-jane

> 
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index 9c098a02a09e..c64c6e5e50f5 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -829,12 +829,6 @@ static inline unsigned int blocks_per_huge_page(struct hstate *h)
>>   	return huge_page_size(h) / 512;
>>   }
>>   
>> -static inline struct folio *filemap_lock_hugetlb_folio(struct hstate *h,
>> -				struct address_space *mapping, pgoff_t idx)
>> -{
>> -	return filemap_lock_folio(mapping, idx << huge_page_order(h));
>> -}
>> -
>>   #include <asm/hugetlb.h>
>>   
>>   #ifndef is_hugepage_only_range
>> @@ -1106,12 +1100,6 @@ static inline struct hugepage_subpool *hugetlb_folio_subpool(struct folio *folio
>>   	return NULL;
>>   }
>>   
>> -static inline struct folio *filemap_lock_hugetlb_folio(struct hstate *h,
>> -				struct address_space *mapping, pgoff_t idx)
>> -{
>> -	return NULL;
>> -}
>> -
>>   static inline int isolate_or_dissolve_huge_folio(struct folio *folio,
>>   						struct list_head *list)
>>   {


