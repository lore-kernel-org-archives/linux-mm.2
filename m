Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D003C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:06:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 325BD6B009B; Wed, 15 Jul 2026 14:05:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6AE6B009D; Wed, 15 Jul 2026 14:05:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 150706B009E; Wed, 15 Jul 2026 14:05:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C8F3B6B009B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:05:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5953DC0251
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:05:58 +0000 (UTC)
X-FDA: 84991789596.14.0556EB1
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11020141.outbound.protection.outlook.com [52.101.201.141])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6F45220002
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:05:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=puozKiFb;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.201.141 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784138755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MTolXszXgyPGDtHoex5RWZvPvZ7X5m8x7jJcaafR+kY=;
	b=XnqArHz11NRGF9IRp41uy+b4WWKu5LE5Rx4G0Ze956923mJaxtNfy1H0SRVyYVc3D/X5gW
	4+WbqmGL4lvpfB14pbfT9mC9JX1oVSP+wM/IScHtpggxnFgcF0l0vf4zBgjgw/IN9LV2Wy
	u3aP+bBCupTZV/IkcL+hs1LsNu/v7z4=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=puozKiFb;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.201.141 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784138755;
	b=DvpG3enljUMqFRb8G9XJ9im7KGPiwYLKrA3NbF2AF5iwbgDL3nZ63ngQreONUmmc5f5qR7
	708l+mNbj0vlbMGT4itZocdzRY4OQg6niK+Rz4PBvRGy/7MW3dCcsXJuZMVayjkHICfkRH
	eo+CigZggsatWfXLSggb3UMs6cxngRg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MhYqR0yPbAD8rZAeH48y+ZYzBM2hNcI/5uE83jaKLKZt0aqTG1+Y9vLYhC8FFAJ4yGWhXUJlN7YVxbBVExJZmwgPKfgrc10YzmEk2zqS/+pt1UAtYM4uqy6Laccwae72XfdzVnWHxiTdNc4KjJqV9uzWTeHxnmCF2VEov2OAYtHRCr0sC9gHXwwaFzPzgjxslGWYIF9YVLOzO5MMHtmSbrKdZAv23jFhi86ZsP0qXKYPf0TPdZ9QLtMTgepC8gWFMUhQ+oN56DcA65Pelxw3lLvd+QXguX+Ya/ToLCI1m409Ziy6S8OMyQJu9cCQErq/9SOQpd2sK50qiQoLn9amkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MTolXszXgyPGDtHoex5RWZvPvZ7X5m8x7jJcaafR+kY=;
 b=uhWztGDAy3dBGGY93w80TUOs5CoRgiQ3ithroMKRQPtzWAloXtb7d4jWyiez2UUy/0gS/nn8szIsCZ9GohKoGVn/1+IBNYM7LHKmMyvw2vIisdFncgb24yQ8MHK63ViKAHZtH68hUH1yFXdQIWOikyTosEp78A1wAF4thAPkuKcDTtiAJZQmZGThRvr4TRymRze0GXnDykrjokkjT5/jLzYujI3/CNf9V6hDpVMl7Fms0njRgTxd+XeJ5kwDA+//BScCk3YtdQHEd1lmWDJ7u9IXaMxFMkSwkYazAPH+okCaZN/m7d/+KSvD/8/HXzI8jdI/tH/uJO+4XMR+F26E7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTolXszXgyPGDtHoex5RWZvPvZ7X5m8x7jJcaafR+kY=;
 b=puozKiFb7LxcGa41a3ve5ia590Tt7CAfcepkP7rEa/Ck7NJtsCK4aRCj8cmqeptsHTmEQphVvyGC+drAbThYiJNTJN7E5UEPpXUPSPyjFyYX3ezLC1P/d85AV1L4TErnSDgjooT7Ss6F0OGmwDFfCS18yhTGW4EWoLCaBcxKGcw=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 LV2PR01MB7767.prod.exchangelabs.com (2603:10b6:408:170::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.10; Wed, 15 Jul 2026 18:05:37 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%3]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 18:05:37 +0000
From: Yang Shi <yang@os.amperecomputing.com>
To: cl@gentwo.org,
	dennis@kernel.org,
	tj@kernel.org,
	urezki@gmail.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	david@kernel.org,
	akpm@linux-foundation.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com
Cc: yang@os.amperecomputing.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 04/16] vmalloc: pass in pgd pointer for vmap{__vunmap}_range_noflush()
Date: Wed, 15 Jul 2026 11:04:06 -0700
Message-ID: <20260715180455.515692-5-yang@os.amperecomputing.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260715180455.515692-1-yang@os.amperecomputing.com>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CYZPR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:930:89::18) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|LV2PR01MB7767:EE_
X-MS-Office365-Filtering-Correlation-Id: a5df8d04-8851-4821-a928-08dee29bac2e
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|11063799006|56012099006|10067099003|22082099003|55112099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	JblgDHPCoQSET05ei9G377R+lh9TkpSIHhsqdro78esh86hVSilm1V306wq5MzOBMZ8CiPV2uk3nvB+FFBTkuxOIoKc1oyi3nOYozDeN7ybjbnx9sIqzyQnKj8ECWF0HcLtCxx4qxVUjhWp8IwdYiReA6OIlzJSafb1DtrZQvTcjNX54KCvZwOWcWQmLpiYcbukz5O4xJ7w01leYyl9heMs5cwia7PkSUOsXsJ8ic1jNJvHpaIYhN7omgG49v3dvMHWNmacz/gB4lC6PiKcsRynkI7gwqPDnhA1jnkJPCckyrzhT7vMNpVsaGMO8JZxg4AtkmGOS4WVkR0yznfOSu3yrFlazpwoENMyFa4MvngKLNDWs0lHeXlc4VapWzlTbBvdcA9zqlTzPP1yufHx40Z/y/YEiL8etbXhLPEB1eRouzYTbXq/6+tbQQZ2x3Y9+muiFdlwqpuAEnQ0blc1veaEahkICqy60oLF/4QQDaRVTe38q2muUcHiclc9Y66wF0zfyCZfti1dZA+zE0o3r4GbEVMYrXzfDIpTnWZxOOPLFhbgeTgIuoCiqUZk9penGfDU/8ctXWYi8zpEpMCfzMtvYvL0o+JkhKzf6KWpvI2vzp61M9t7f8mwhGSSSJathver20nnDCo5FFmGhRNtLFcVw0QUCHkSLF8SoZG4cWXKMiYYXA/EB2Fru95doXCAdsYciS7vWQj7HOS16t+bNhg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(11063799006)(56012099006)(10067099003)(22082099003)(55112099003)(18002099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xt2VrK+3YsctMYqVULRbvp3lGmuCUeGvnFHya3h6mH7zpv2tZ3VS2WaL5+1r?=
 =?us-ascii?Q?HZll+anz54SuxO74uq8xTJqMcesFuB467zJPIrm+FWVNh9o4hJ/fBU3nWvVW?=
 =?us-ascii?Q?eOwPd2sISYKuXTjtn2J7Jxn6208EwnjJ46/XeJtrCva8HsLq4rj5MLAnxo68?=
 =?us-ascii?Q?HwzDGtzFZWwHcAwTdFp5GbWV4GG93pODddrW8jm9YIqcLaQgEWU/wOU/ZgR1?=
 =?us-ascii?Q?xjlar90PhT+MniJTwETQYJu4yjv1jQ40um4GLzzXX4zSJVcagiS+3duocmMo?=
 =?us-ascii?Q?Aaq/A2Iya3wXvruLfGEfLi8m8ZVJ3HtdwhVcdPrbY++3fOPVIN8toXypfO1A?=
 =?us-ascii?Q?A1CGZIdEfbe/lwNrEWHOmC+GNCBpYoisookqxsTDqRfHx7WM6zjwG1E0zYH9?=
 =?us-ascii?Q?C/Thr1ugrhPJMQW3HpwvU4NFWChTzYH/a+obUjmZ4Nq3PJ8OkjHUvJZaGpk3?=
 =?us-ascii?Q?himWoKc014g6qBDN870/86TTdOllpauJ3TW+spROTm2z1qh0mxWeooyMThSu?=
 =?us-ascii?Q?/8R/tjSHh+fNMvk2qAzXsxQDbYvyl1PrUviDSSIhUZXPAVGM0h+JgdsWMIjK?=
 =?us-ascii?Q?HMCdpHQx1mf1i37wbAco39ch+38xJX/1jpFXonDjLY4ngbHjIwlEJJMpxncr?=
 =?us-ascii?Q?1aMRMhVlTCYd1K0y1mLo04WDQRc9tYpabhrBr5NbYy/mZ+p1qxUyvb2jvl+f?=
 =?us-ascii?Q?jB4CiRppYoWodn2a/1P4vgNwiEFd+1HXyPoVzHywq5zryGXbxptdUogyvhPD?=
 =?us-ascii?Q?/EVrjHs2uQC5Wvx8l2NMUZluMoa0CyNPPtAX5kStBeMSKl0A3ogqabFHLE10?=
 =?us-ascii?Q?FQgtsfXM0jIgBg9SChoVx+kRiMBcoAHP+6gJj5K8UR8Lb/MqJJFMf/30FvZg?=
 =?us-ascii?Q?vp78hgMBPila/DO+J7xWoqdeElf/qEjgP0wZIIXqdmmxp/3Pb0i772lOXjud?=
 =?us-ascii?Q?Z/0zmSY4JxFOXxfRo3UoPEwy8BA5iEU3nFtfrEe9tqdyK9ewlIy9VowtGjan?=
 =?us-ascii?Q?5arQaF79BF+FLYPP8ME9smk7DnyhQVCQ4ABp82jKRWwhD9HsA/e/PZxlpcp3?=
 =?us-ascii?Q?oUR5JbEEX//2AjAzgWtVl/xlNJWHBf16BtiexYJusk77KgLLlg/7gWdvXiMg?=
 =?us-ascii?Q?QJ8/7P93feo38b6I+Zygt6iCgEIEZ6Tl8a2ADzxrq/BpXj1kbkES3vf6f74O?=
 =?us-ascii?Q?NAYi3WkgZ9iYpph7XDww98yMOxfxWnbMal3HMum5gCaAfI2jnf2yc5AVWNjd?=
 =?us-ascii?Q?DQ6t6asDg4RlTkIGUHhvMxHvGM61aKnKFPXCfVbdXwN6bB1gpqmkXy4KlENS?=
 =?us-ascii?Q?89QsizwUIZyBflBmdLbnhtxLqpGXr6wlUdEIfQCSVrUA0NN6Omlup52FVqQU?=
 =?us-ascii?Q?ZvNIPjc/VXOYhAsbIoZ84ep4nWdSYQNqxxERese/rbJWJowtxoRZmeAEnbzh?=
 =?us-ascii?Q?WiHIhn9Qqv1+9M+m+HhG2XNlCQNY0xdmfk/5bdaXY5YOM8pPNUtZaLugPDpZ?=
 =?us-ascii?Q?tqjz5vDqCrFsRQ6ho4yV+F0Ws6lJQ76mSw1Sz/mlghdsnJuaEper7lt9o6dA?=
 =?us-ascii?Q?/yfb46F1S0vvNXxjXNwP4cjiIUfFrTtj/hBnoGVHOXVLlrPEyRDl/SN5pSCT?=
 =?us-ascii?Q?U2b8eOyNtPkqbVdsRwqkC/mx/SNINXcMQ9gLs5Im1Q9U363ViBE5h8Uh11Aj?=
 =?us-ascii?Q?cQ/pVCvZBMrACfsF5mb3X6pNu4O5ooM6elJtpVdqaoKLS/qbzSeam0Ft3qhP?=
 =?us-ascii?Q?aORmXQsGBgXDR6xCIRH/g7JI8eHF2o8=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5df8d04-8851-4821-a928-08dee29bac2e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 18:05:37.1516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8lgFsbSqtLBC4+IUnGaYQvIAFHsI3gVf8/WOgO3VqczV5+cKDLXm88GlMD0vYZ5b+pXZe2qHgOqbJ6cZXCdfuqXa1VIOmgpkvsqZjN02RUY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7767
X-Rspamd-Queue-Id: 6F45220002
X-Stat-Signature: 8ad3din95pf4fog41g7s8u4w99drotad
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784138755-872407
X-HE-Meta: U2FsdGVkX1/WCDGQBg16OxCZDTlGYMZuPs80LufVVzNVCMRrIMXKcCZTm8oCJSH8RVh5NaTPU/7Vprz3HOV8vRFPs0Tr45HvW8L8qxdKA0IzPoT3dalvppJcEj4MjmrIFf/6rronoxFOLLYlTKo2qHswemb9a1Zpcj+MBW1+UyOP4lE7MHx0JL+TzEmuzzxU51znp94xLy+Gnqbd2kIaUKUsDsYCO/Pp3vfy8r0gjinQJjfY3hWzRGejHQzpHFJjizfGqGgicCgTcUE32nF2Xbqrf4hASw6IqG3mW3QxFWYrxLCher8EALF8Kwv9E98Z6CCsjQ9Z9nVBkU/OQb+DG3EDRwTrzqntYt9whQdfi+TQC9GgmcwKHWxymRnwFNtelsQtmGh9MWAZzL6B2sk0pdmpv3+Yt60nx/FCEc5jThZwkSMhphtZ6wrE+FjhxWj2gw/2wPJRzVoXnjpjcHanNB+3tMo0iqkR+GvTmsVll233xaMzDL8vW13k026MRtiUS1Tqj73PkMLk3KJRqbCtjUVw3RMChGB1afODgJ9amNShlH7NeEeEayeY/AulwDM5P040HyBxdHOrrVDYAxGAwo+/arfRT2heNnK/8Ah7rxMSgN/+DDhOfVxu6ws8SSlsmhysU5PtVUjsHKeIB+EQoTfMXVAEyxy7PQ7PeKUzIN805WVcbysZ7XBRFBQbQzHmrPV5tFxpQb5xbVWsEyM1rqGdXWmC2bbOemufaI7blzDoHKGa1Br3fACfnDIL2uer5+F1XN+xxx7LVJq7t2/t6wmH1CRpCRj5e4ILsgGu3RZQZh3TpOHXrPmNT9zDDKll9oVJpKpqqYuPzxGAAr2cWh45I6svsp/BPeouX4rZ+QXOSS4UkACKf6cpufFy0mTtg+kbZxw/OoapVaRK5jnYcw9SjfjQkuwvA/wJpGtoI6Q/ac5BU2p/Vd7srHoQGckMGFjm8pzfYcpMesKS06u
 yYkHafjV
 KMEeTc09ojoubLGngMhhmsUSF1SZywcJjpWy20CQ2pAPhuv349xTDp9KThB93R2rwHxh6JF/z3peLtp5tGaejW71jvwj5kNYt47pq5fpAGXzXDkJ6/sCxSQLTH7JCT+/IeRjfHhx7KPIPefT91mqZiXYPasaU68ggLNbL6tr9hPSJgbOPqZg4lRCCEKoOB4ZfUbwCZy9KVFSucDUIUdFPR3eoPucxjZp/ZXa+3HTEXCTfqZZlm6gkgcP81lZj9OL3D4olwB8AJCE0GQLTXKEBi1156MSQ6poatRuJ3yy2cIc1LgWyAgUrQqz/3+ACtdClQZoIy3cAah+kOk4Bgol/lkwfYIBi8x9mXvdIcKmlWO6K641NuXT9lyKqDPEA8HRhixj4TKGNakEj0enExZ4Y1T20neB0XR+mYLMpQDt7hKUuLWyE3Af+Gn0csjQyrRI7EvHGzEww2kpDZJ5saXS8hXm3i8JZFgjutsb0Gs+RQ2yCGE367r5lb7K0oXTMthSlup1xxHO9RbA/5qtvzONwzq27ae2Vvq3Cyj2I0UwYPn0NSt1qiD/nuttREg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmap{__vunmap}_range_noflush() assume manipulate init_mm pgd.  The
following patch will map percpu local mapping into percpu page table by
calling them, so the assumption will no longer stand.  Make them take
pgd pointer as an parameter.

Also make vmap_range_noflush() non static, it will be called outside
vmalloc in the following patch.

There is no functional change.

Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 mm/internal.h    |  5 ++++-
 mm/kmsan/hooks.c | 14 +++++++-------
 mm/vmalloc.c     | 25 +++++++++++++------------
 3 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a2..9d9f08cb26a1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1552,10 +1552,13 @@ void clear_vm_uninitialized_flag(struct vm_struct *vm);
 int __must_check __vmap_pages_range_noflush(unsigned long addr,
 			       unsigned long end, pgprot_t prot,
 			       struct page **pages, unsigned int page_shift);
+int __must_check vmap_range_noflush(pgd_t *pgdir, unsigned long addr,
+			unsigned long end, phys_addr_t phys_addr,
+			pgprot_t prot, unsigned int max_page_shift);
 
 void vunmap_range_noflush(unsigned long start, unsigned long end);
 
-void __vunmap_range_noflush(unsigned long start, unsigned long end);
+void __vunmap_range_noflush(pgd_t *pgdir, unsigned long start, unsigned long end);
 
 static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
 {
diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
index 8f22d1f22981..e2a0faf344b9 100644
--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
@@ -135,8 +135,8 @@ static unsigned long vmalloc_origin(unsigned long addr)
 
 void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end)
 {
-	__vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end));
-	__vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end));
+	__vunmap_range_noflush(init_mm.pgd, vmalloc_shadow(start), vmalloc_shadow(end));
+	__vunmap_range_noflush(init_mm.pgd, vmalloc_origin(start), vmalloc_origin(end));
 	flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
 	flush_cache_vmap(vmalloc_origin(start), vmalloc_origin(end));
 }
@@ -181,7 +181,7 @@ int kmsan_ioremap_page_range(unsigned long start, unsigned long end,
 			vmalloc_origin(start + off + PAGE_SIZE), prot, &origin,
 			PAGE_SHIFT);
 		if (mapped) {
-			__vunmap_range_noflush(
+			__vunmap_range_noflush(init_mm.pgd,
 				vmalloc_shadow(start + off),
 				vmalloc_shadow(start + off + PAGE_SIZE));
 			err = mapped;
@@ -203,10 +203,10 @@ int kmsan_ioremap_page_range(unsigned long start, unsigned long end,
 			__free_pages(shadow, 1);
 		if (origin)
 			__free_pages(origin, 1);
-		__vunmap_range_noflush(
+		__vunmap_range_noflush(init_mm.pgd,
 			vmalloc_shadow(start),
 			vmalloc_shadow(start + clean * PAGE_SIZE));
-		__vunmap_range_noflush(
+		__vunmap_range_noflush(init_mm.pgd,
 			vmalloc_origin(start),
 			vmalloc_origin(start + clean * PAGE_SIZE));
 	}
@@ -233,8 +233,8 @@ void kmsan_iounmap_page_range(unsigned long start, unsigned long end)
 	     i++, v_shadow += PAGE_SIZE, v_origin += PAGE_SIZE) {
 		shadow = kmsan_vmalloc_to_page_or_null((void *)v_shadow);
 		origin = kmsan_vmalloc_to_page_or_null((void *)v_origin);
-		__vunmap_range_noflush(v_shadow, vmalloc_shadow(end));
-		__vunmap_range_noflush(v_origin, vmalloc_origin(end));
+		__vunmap_range_noflush(init_mm.pgd, v_shadow, vmalloc_shadow(end));
+		__vunmap_range_noflush(init_mm.pgd, v_origin, vmalloc_origin(end));
 		if (shadow)
 			__free_pages(shadow, 1);
 		if (origin)
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 1afca3568b9b..17c26e9796b2 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -295,9 +295,9 @@ static int vmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
 	return err;
 }
 
-static int vmap_range_noflush(unsigned long addr, unsigned long end,
-			phys_addr_t phys_addr, pgprot_t prot,
-			unsigned int max_page_shift)
+int vmap_range_noflush(pgd_t *pgdir, unsigned long addr, unsigned long end,
+		       phys_addr_t phys_addr, pgprot_t prot,
+		       unsigned int max_page_shift)
 {
 	pgd_t *pgd;
 	unsigned long start;
@@ -314,7 +314,7 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
 	BUG_ON(addr >= end);
 
 	start = addr;
-	pgd = pgd_offset_k(addr);
+	pgd = pgd_offset_pgd(pgdir, addr);
 	do {
 		next = pgd_addr_end(addr, end);
 		err = vmap_p4d_range(pgd, addr, next, phys_addr, prot,
@@ -334,8 +334,8 @@ int vmap_page_range(unsigned long addr, unsigned long end,
 {
 	int err;
 
-	err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
-				 ioremap_max_page_shift);
+	err = vmap_range_noflush(init_mm.pgd, addr, end, phys_addr,
+				 pgprot_nx(prot), ioremap_max_page_shift);
 	flush_cache_vmap(addr, end);
 	if (!err)
 		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
@@ -478,7 +478,7 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
  *
  * This is an internal function only. Do not use outside mm/.
  */
-void __vunmap_range_noflush(unsigned long start, unsigned long end)
+void __vunmap_range_noflush(pgd_t *pgdir, unsigned long start, unsigned long end)
 {
 	unsigned long next;
 	pgd_t *pgd;
@@ -486,7 +486,7 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
 	pgtbl_mod_mask mask = 0;
 
 	BUG_ON(addr >= end);
-	pgd = pgd_offset_k(addr);
+	pgd = pgd_offset_pgd(pgdir, addr);
 	do {
 		next = pgd_addr_end(addr, end);
 		if (pgd_bad(*pgd))
@@ -503,7 +503,7 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
 void vunmap_range_noflush(unsigned long start, unsigned long end)
 {
 	kmsan_vunmap_range_noflush(start, end);
-	__vunmap_range_noflush(start, end);
+	__vunmap_range_noflush(init_mm.pgd, start, end);
 }
 
 /**
@@ -670,9 +670,10 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
 		int err;
 
-		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
-					page_to_phys(pages[i]), prot,
-					page_shift);
+		err = vmap_range_noflush(init_mm.pgd, addr,
+					 addr + (1UL << page_shift),
+					 page_to_phys(pages[i]), prot,
+					 page_shift);
 		if (err)
 			return err;
 
-- 
2.47.0


