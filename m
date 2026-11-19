Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 469D2606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 12:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=JZ8gWZ8k
Received: by kanga.kvack.org (Postfix)
	id 70CF86B060F; Thu, 19 Nov 2026 07:36:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BCC06B0629; Thu, 19 Nov 2026 07:36:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 584476B063E; Thu, 19 Nov 2026 07:36:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 285946B060F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:36:59 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B24E4120A98
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:36:58 +0000 (UTC)
X-FDA: 85451818116.01.F778338
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010023.outbound.protection.outlook.com [52.101.56.23])
	by imf13.hostedemail.com (Postfix) with ESMTP id C7C1620002
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:36:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=JZ8gWZ8k;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 52.101.56.23 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795091816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zTOX7fNQMIQV/FS/5aztvoNYi95Dx4FBvaRi9P53wnY=;
	b=sAguljOawLrVTRUFYv1dxPp70rYy+d33j5PnLAhI8cTyWa8U2kdKNMU6j+lcsWlEzGncsH
	vqCOycwLkEv959f82PjRjSSN5ZPLZ+LDnw5d/ZEzlV2utwCzLKuRvoXlP/brfBqozWZnEp
	5dZtvo6s5vwnptfdmXtuTp2P/yTbUXM=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=JZ8gWZ8k;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 52.101.56.23 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795091816;
	b=PW5dFWRSG5dNVYt4i99HvsVj5EW7g1j29D2y8I3oUa7uWx90BiyH+8HYkzjxQnqNoFgY1P
	LvJvTp7Vr/rb6JT/QFW1+zcUYNGS4jHd4sPSjh2lHYki37iM4CE8lqloWYOO315SgUu1qa
	2leNPA6w3fyNd1WV+JGSjLJGOvjPpTs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LauXrM1hugYkULyxG5cCE/xAFkNqmuQd4DxyRmWka6Fd1SFbYgR5QfsqOtRECtnhU1aK8SVIPAcxCjQtDaDAHfaudFLrGLi7Hz/u/C6G5JT5e/GeT3F+6bR8oLpidvweINwVMfZfvQ9C2njGNRxa8LSHdiv6cbeTqUOLtTigaUUyPSq9meD3n0qFwivZqxirdP+b+agYhNExKnpPDfmF97OQP19li5YCpZPu/Nd1PiXo2IDvvperPnNAVW0vl14HJdPJ+5mLTHk31p47Dz+kJg61f4fRrVreyAHJnYrWyz++Zr0IsHc82LMUJXTEUGRrgN+96rJqgZU4RdNpOmt8Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zTOX7fNQMIQV/FS/5aztvoNYi95Dx4FBvaRi9P53wnY=;
 b=GvE2w6eRV1g/LAViSqUgTtZDdXHHPq8cJfVsJaZ3EDIJAvTxDnuSZfgi+CRSZmxkGWzqGZeLCjZxQl1qMbuTYlxIn9Kik5g3axWciKMIYZMs9d7Fn7UTgCzdsrZABGcGTwA3uYD1VBVZNqyaNhS+FlAv4sW86sObrWDsweVP2977kObjo30zP/iSIxSvu3x4mFwZZ0Xm402wckODlqJEV49BGGiAtz7EAxWvBJkGX6NFCUphjJBZn9KErSDAjyT0eYprtt5Kg9oLpuJtPn8QuFmRS8lPVzfAwcE7L8XQDitG4zG2QI6oM/tvowkQEC2jGOXMZ+Xa/7XLPR6dYTInLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zTOX7fNQMIQV/FS/5aztvoNYi95Dx4FBvaRi9P53wnY=;
 b=JZ8gWZ8kObDOgsbc7rOJODD5WdAmHO1zZSid7MNI8vxrAUOwIdt/mTL/lbI7do38buJO5lgh7evwM7Rc1C5mXrJDnT5f9v9dYC41AlX4weuehLj1WrLwA3kzn8IfnVcaeGdEgIzWNjQFSdHe7OXgBid3dCvP5L5jLDtThfISeVM=
Received: from DS0PR12MB7771.namprd12.prod.outlook.com (2603:10b6:8:138::6) by
 PH0PR12MB8798.namprd12.prod.outlook.com (2603:10b6:510:28d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 12:36:50 +0000
Received: from DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c]) by DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c%4]) with mapi id 15.21.0615.013; Thu, 19 Nov 2026
 12:36:50 +0000
Message-ID: <4e8e1f1a-f68e-4fe6-87b1-6198603eee87@amd.com>
Date: Thu, 19 Nov 2026 13:36:45 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] mm/memory: remove unused
 vmf_insert_mixed_mkwrite()
To: David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 "Jose A . Perez de Azpillaga" <azpijr@gmail.com>,
 "Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
References: <20261002160535.661399-1-ekffu200098@gmail.com>
 <179501440852.7660.18348444744304711431.b4-ty@b4>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <179501440852.7660.18348444744304711431.b4-ty@b4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0090.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::8) To DS0PR12MB7771.namprd12.prod.outlook.com
 (2603:10b6:8:138::6)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7771:EE_|PH0PR12MB8798:EE_
X-MS-Office365-Filtering-Correlation-Id: cf7398bf-d39f-4b08-ac32-08df4639c860
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|23010399003|261022075727099003|10067099003|261021121427099003|56012099006|4143699003|11063799006|261026121527099003|261026140227099003|261028144727099003|261022105027099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	uMad/yuLJNPRMeFpl8Sy8B66Cmfe+sXRS3I9x3qKen5Mn7HqGtaPs4PoidT8g36MJH96iDKSXEj/PlN632TzHR/aZybHhmuhlM3wqJJoNvyYeqyzrrqU7GP/CFSpTcYCK3VuG64NGUilmg+HWCwzfQHUZgvBIIzvbfDoJIjRt0OW0mYTFx1mMoigX5RCo1kXK/6gtSZ/jNkW8le5J4EgspVa4wP+ChxYTWSIK7BgrDekmz24+R/Wj1TLtrsSO5J8GkDKC3tPOVv9fJ0r1lFcUrPDl+VLkz2NwDMafK/V3+qNiUaAYIekRvgKIhJsci/IWvmdunRN0qLIrTddh8rAWinIrZp52bCjNAm/W2yCNJzLhh3x3lxEOBkHOgPWJMPfve9dtgoPEpMkl21M8cTSjGFRrOQv9fcHau5Kc//7cmhMf9L0ncWLp1a9X7IB6zWKhnLkYox9hPnbsAgZPd29omeo6sxwYV6TxrIqT+fV7zs64XlBgOz3ZseQ6nsxyP1JCwTbQY4HbZHukkVBAY9kyxdl1ZLsqNwpWHHEK45j4PLVbA98FPl5jsVaEsJ6CGmq07tv7qQK1MdJ7YZDgrxRl8fVRTD3LRPiAWHwYRL/zJk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7771.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(23010399003)(261022075727099003)(10067099003)(261021121427099003)(56012099006)(4143699003)(11063799006)(261026121527099003)(261026140227099003)(261028144727099003)(261022105027099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TTJlb0s1K0ZkOExGMWpFc0RQTGpzNkgvMXBCQXBjQllYR1JPbWsvdTY2ckZV?=
 =?utf-8?B?YmQ5NGJWcWhkZ29IN3pqdHRhbmFhVXk4YmdCSG8ySWlxUVROcXNLUVFyQnlI?=
 =?utf-8?B?YW5BSEJGKzFBUjFwNFFHSWdMZ1lRWVJ5U1IrNDFUb2ttWEZsSk1PWXNpVkNk?=
 =?utf-8?B?b3hIRVFCaXE1Mkl1ZkVEV2doWktuR1ExdjBWNElESVp6bEZlbVlpRUR1SFhv?=
 =?utf-8?B?azN1eWZVOU8rUExvdUhMQ2RJZlVFb0xDbHdCdmxTd05uVExoMlYxVEpzY0FL?=
 =?utf-8?B?N0tERXFsMUpBWGhFRFh6aXlKTEV1SkUyVDRod3hEUEFWWGlieWpGV3pwWk5w?=
 =?utf-8?B?V1R6czdtQmRzNmhBUVp6WEJHMzlkMnY3aUxKMFp3Qk5MWFE3RDJvTU1DSHFB?=
 =?utf-8?B?OWtTbFVWYnM1WFJYdGlGTnhrNHRQeEJwV0VzMkdXT2ZBM2FmUkNZUTlPTGRx?=
 =?utf-8?B?dHhob3ZUay9zTGRxWW9lQkp0dXFyLzluMkI4bm1Jb2tDRFRzRUJjbFFoaUtS?=
 =?utf-8?B?S3JjQmhrY0JHdHJkeSsxajBVS1lSemMwWGR3dWRVKzRDU1pqc29LanB4NmRx?=
 =?utf-8?B?K1N3eVBjL1R3cXlCSEpMRmJYRGdVYkhaR1NMM3NCZVpTeXAyR0dkbVNQeU1i?=
 =?utf-8?B?WGdrdGhNSFFpeCtVci9Ta0U0NEtmRHR5QUVTRGtQdGJodE1RODE5TGtOMFJu?=
 =?utf-8?B?aXl3dGRXNkFlZWxDbWtFbERFc2d4VWFrYm81MlRRWGFLbXZqaXVXckUzVUIw?=
 =?utf-8?B?bXlGZXZCaHlrVEN4dlppNHQ2TGNyS1dhM0E1dTJQekFHQWY1MG5WODdHQXQ1?=
 =?utf-8?B?TUlhaGJzME1DekFaNEZJUUs5ZzVxc01CQzJoQWJJTXJZYlY2YjZhSjltejNu?=
 =?utf-8?B?Z1p1YzJIbFBUcWhrODJWTldCb2NodU90REc4V2xXZThWT3BkdGlDVjNvNHpD?=
 =?utf-8?B?MHNTKzhvUmdlc0t6bkR4V1laQmN6Z1plKzZ3Z1hyNlhOdzcrWXN0ZVpvYXpS?=
 =?utf-8?B?WVdqRi9UYUlsK0tUeCtNY2dMQVVmRndwVE9SRlltcFcrdy9SNlgzVlJYNkFx?=
 =?utf-8?B?ZmQwTCtPLzJRS2t0N1gvWHBCSDhTUEdLSWo5WklFUEwxKzNQSDlwTXlSOUVD?=
 =?utf-8?B?UTRmakh6RS9Ka3EzMXJ5UE1zRkg3ZnZ6ZlFqTGMxQ0RkYWxhelliSGZObEoy?=
 =?utf-8?B?djVSeXJWbGJpK0diZ0xNazVTdEQzZk1NRTk4YnUrd21tT2ZPTjBuejdXRHRo?=
 =?utf-8?B?ZGp1TkNPa1p4dm8zZEsrVFlvQVhpeE55K1pnR045S0tPTGdzQjdJWGlQdjFQ?=
 =?utf-8?B?UmtRdTRwWnZLeDNkdEpYV3BoODdSNDFjM0FpWDNTMzVJcDlpZG82NE9KUDdB?=
 =?utf-8?B?MTZDSzhwaVJzYWZyVHZrK2pscFV4eTY3QzVTMkVxSk1HNnIwVjgxczZpcktt?=
 =?utf-8?B?YkJkRStTN2JCNm5hRDZMZyt6YkNFb1A1MTNOMkZMWmdQUld3VEEyaTlVYmNQ?=
 =?utf-8?B?UTY1TlpmNFNXR1llQzUvK1lLeXl4TjFDVHJTcXpUQTJDL1JtMWk1NEQ2Zkl2?=
 =?utf-8?B?OEtDRVYwVHI0bXZhOWoyR1cwR1FvdmFmeXZUaFV4OHlWbWg3Q0pablRtZVlo?=
 =?utf-8?B?MVNjT2ZQdngxTzdzTEg2T0w2RVR0bGFhV1VXTmQ0TkFWQnNzQU45VHMxY0lq?=
 =?utf-8?B?N0FqdTlBQ1lBMjY1end6czYzRzR3TGZ2SThBWnZWNDk2ckhMQ21PL2xJYnNG?=
 =?utf-8?B?eitlcDd1cnNPdHUzS2NaRVdiWmRXdGpMRVQwd3dtTjRLQnRVOFR4RFhFWENI?=
 =?utf-8?B?YkhBOFhrUnJUcE5zZGh3cVRGekRuQ3B0U1hpbGtJK1ZVdE45LzFnZGt5bEJG?=
 =?utf-8?B?K2M5NmI0Z2Q0TXlZQ2dpYkc5c2RVUEFjS1BLb09acnhTSmtLRFBjY3cwUWhx?=
 =?utf-8?B?bVZYSWJuVmozRWhaUjNrM290bmNSdjNBQWdpTVNUNjBPeEtGOFhtcTRCZ2hX?=
 =?utf-8?B?K21sQTdyKzBzbi9GanF2LzRaZk81ai9yRVdNNCtEaXdrM0tJZGJnZFp5Sjd1?=
 =?utf-8?B?dE5nWWQraTFVT0R4STAyZytoSEhpYjNmeEl5c3d3QU5lS2FCdUdzbUd0SFgy?=
 =?utf-8?B?ZVpuZzFYSXpUVzNuK04xcnoxOHdwczdtRHY2WlBDYkZRbENTOVRYZC9QM2ZH?=
 =?utf-8?B?UVdKdzIzdnRMaVRWQXZXREVoSnQ5MjVPNmxLU0lQK3FJSVVlb2xheE0vVUJ0?=
 =?utf-8?B?bkp3OUoyVjM1UmdTNmYxampSZ3Z0VWU0TVZOcEVRS2NWQm9xUWxDbGZPbzdR?=
 =?utf-8?Q?UXs4lfbKlAeVVjMXqr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf7398bf-d39f-4b08-ac32-08df4639c860
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7771.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 12:36:50.1627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dPMBSC502QwWAR4Fx0sGlgAzx4KHT0DvxzgOUzefT86qD9uJaVDMTH8vpSo4fKga9TTWh3wd8ndxb5zjDdA+bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8798
X-Stat-Signature: asb3otc3xxc75mjj5xcqa7feqkjqm8en
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C7C1620002
X-HE-Tag: 1795091815-816376
X-HE-Meta: U2FsdGVkX1+L0suazYOjGvAJfqEjppVg20PCcYmDUWFuidpS7qTcDtzlYUmhQmeRBg4N5u+ocBKect78N0sjdx0i7JUn9ys2v0i9m9QD26ozMuovwMwzbBkay7rX2fP9OGyUZiUZBHQcqHEW0Um4WqK+wkvX0/+RNGf/lEH6hvIwkZBJ0d28QFQW2sQGJDzR9ozIeoodACOLm5b/2dAJ+w2lw3Gi/M/wxcUKBCDLwQw8YDj/aZ3YQxBNUPidSJcaxg4Fvb20QjySw+EV7zN5BWrD24+l6mS6WKTgxL6JfmSc2nlFAwzl6dbWQOCoaLNquTwRDdUOwt7ripSH/v4VZdqVup81O8Un1YekndS3BwwMvLAbbMuRszppebnzkZJzROiZljaB7AYmyUkHOksiaH4GkoNOoXT+cfn9DpF1s3h7kWRj6+RLTeSuExvnNVgYQvUm2mCOXtMIELsOdSdPUXzfCKdBXR733G42r4+12XhbDVtGqXlzUSSocNIA2gWb/yogMY8S67AigrpTrSVaoCAtgIvvQPCXaItAud1mUV5tQ2Y0HsPlp6g5c6CsXVnaUHfCYG1xet1zMyUfJIDzRUrv+7ty63RgHCq9NZ5KqlmDCnjRbaRtPSOyclOx9EckGy0QQaPr4fTvzmWGNAgUp18tgy9CgSPyHyKtDCgnaxr3747FlgDfhg0VQQGdbgF7wBBwAozQc/JntrdQWJHDrUpeVxunjCgoSu6ePneRvlBgB/Nh1H9TSay2ekF5PK0zU6OWZAdzy6IvrBV6zJ2UGSVOw29ghfGV9vBoCixpBSCGmZKUn0SpKaa47xwds/i/IQ5swC+65ezzXSG+rLA8qW0WP2wr+pd9tRmoEU/gopC6VJzeL7pC+gx3KpJwn/gl2Xn+RgQnJ0b7PPqW8p8WAZeEXfvvA/MAtn+N7PUbqkg4tMUqUeeBu9RkdF7bIJlG0iEXWAENkJtIZubzsc1
 vSoOh1sK
 jAltI+62F4fgu928W95GhiAxyMC577P4ycR61qwSOmEHV0eX77KZFkaXvc9+xD9msXyRE2Y+YORG0v4wOI+frJzJxdeQUZMNK9/XCArUpEUXU5rQAJ+vr5bMybTCv4jrDwaMhdYVVMc/xz4ec5o0ZzGqVsIO7copxcwhQHL2Mx6MJWxw/AnSlIgP09Cs7NOKHN3Nm0RTvlAazMpRqMUbgSsGeR+K4f4c8hlMSQ/Blv5lUKSJ+FaXfyFyNyS33Jj1D1aB6vilgC8x2jMAgqJcDT7r+/AXE1rOdHIjoVieXozYLOP6h1q6gQ5DmfgOODjOeshJtetZJmCJ0/+BO3ADcUimCPWj+nylBPhvX5RiubcrX9ea+B8cbMYF4sItH8VerD6nlUwu6LncwqcDFDJ9se7B4YD8+7LIB9jt3jmp5mj0UwNz00tb1OBl0pTCUGDbr0RrJg4ZYeW7ZOOaDHmyLV+kW43wxU+ZOJ++rvCgy8uyn+VBuDwSpRRVARduvPMCRmNM4zoRqiT4kFlxd7l8FOjdbpX8ZX4YVLBo8Izdh09iTRIz/FmgaJQF6Gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 11/18/2026 4:06 PM, David Hildenbrand wrote:
> On Sat, 03 Oct 2026 01:05:31 +0900, Sang-Heon Jeon wrote:
>> Since commit 38607c62b34b ("fs/dax: properly refcount fs dax pages"),
>> vmf_insert_mixed_mkwrite() has no callers. This series removes it and
>> the mkwrite handling that only it used.
>>
>> Patch 1 removes the function.
>>
>> Patch 2 removes the mkwrite argument, which is then always false. It
>> also removes the unreachable code in insert_pfn().
>>
>> [...]
> Applied, thanks!
>
> tree: mm/core.git
> branch: core-7.5.misc
>
> Applied patches will appear soon in mm-next, followed by linux-next.
>
> Please report any outstanding bugs that were missed during review, so we
> can either drop the patch series or decide how to fix it up.
>
> It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
> though the patches have already been applied. If possible, patch trailers
> will be updated.
>
> Note that commit hashes shown below are subject to change due to rebase,
> trailer updates or similar. Further, this is not a guarantee that the
> patches will go upstream. If in doubt, please check the listed branch.
>
> [1/3] mm/memory: remove unused vmf_insert_mixed_mkwrite()
>        https://git.kernel.org/mm/core/c/fedea7ae
> [2/3] mm/memory: remove the mkwrite argument from __vm_insert_mixed()
>        https://git.kernel.org/mm/core/c/a3405fa5
> [3/3] mm/memory: merge __vm_insert_mixed() into vmf_insert_mixed()
>        https://git.kernel.org/mm/core/c/ac2fd084

The patches are already applied.  But in case it still helps:

For the series:

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>




