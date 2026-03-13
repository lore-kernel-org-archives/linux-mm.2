Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A2AC106703D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB63E6B0089; Thu, 12 Mar 2026 20:28:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A609C6B008A; Thu, 12 Mar 2026 20:28:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9593F6B008C; Thu, 12 Mar 2026 20:28:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 845C36B0089
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:28:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E20113AEA8
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:28:01 +0000 (UTC)
X-FDA: 84539152362.07.76B3C0E
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012027.outbound.protection.outlook.com [52.101.48.27])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7364B180003
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:27:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=OyII1wRC;
	spf=pass (imf24.hostedemail.com: domain of apopple@nvidia.com designates 52.101.48.27 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773361678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1uSBYG2ORSSNeLXTuksK26krtwR5EFuD2CwpOJP+Qsw=;
	b=P1bWDFCsa10a/3tuBzaZ6z+Gi3ecHDWFyBLam3piVZManQj6ZwNKZP5hjSAbDfbYdHDmWK
	+g8RdX4QbzWqUTMhudO2Pzou7vpeE3v8N1z9GtBA50gK3f/HR87Ic/Lxj0TsHrvUl5q2G9
	WGfkqs2tqka53Db5iZLNqKgDrQurqw8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=OyII1wRC;
	spf=pass (imf24.hostedemail.com: domain of apopple@nvidia.com designates 52.101.48.27 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773361678; a=rsa-sha256;
	cv=fail;
	b=anuL5I3iyl96zwGjvrhBqxb1ZxexWD1H3O/4XiX2DadwNva6DQms5o/24AS8MzM+kNzAxO
	Gt+Kazen2G8JaksQANVSy3+qz/VLvnC01AbK+Ot7PgqXmAfXFY6fmL8od5K0+vvKwgOjr6
	ROPa3FTblCjSJKDPiWafW/l0HI7RGKY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NwGXk4h/dScvT5cFUsUOetoMt2i5h9GxFJ3ekUkMK0diaT6xftnhsNcn8oVnVnpAyr1J9X9HGfjcGvufvpjhEwJB5aZxNZwqb0viXFIN7lWlKD7Rz21usUoXbOu+ZkjJoV5UQI4YykiXDAEg+JkKLP1Xh4KekEx24wx4b/BUaFjKM2G6JjyFWXE9SGxLEO9GBrG09APNON03r1rkJZMl6zX4pOGUa7yHyzGY9VPDIpr/YumJWbDoHQCCwwhlIE7LBlHFab7x6tYnUR+Y5aYY+ATHBe0WhYcUtK5BALrtNZNV+0vLscrM4qQki56KDrYEtoarbtEG61iHJ+tZuyew+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bz7i9LRO+CxbSCyPvXqMei+o1NGigyAQHMTaN4MBXF4=;
 b=nJFGqu6k6DBKmVGRKbII5c9Qk8s19Q7lIFNqMiZVFD6+4DDQeD+ZjdUZAqbpvlo4Kkz8hzUOkwHH47IfwPzh52S6Urqhv2grX1CniUJImO6mdsTKpEkNsPj/7xW1islNv/BddqCg7xwFo95eCr8XOzCxhhj1CqViXbDxEOrABdSVmGBWAYZz+aeOArL/2/C/6s3MGbP1Qi/CrHuPmlIf0dUGHk/kPxBJPTYYKt3hcbd3TGnCFy2Ercb25113MqUpzkC6ipniiPBh92n4eTOLsCDSaLmj0Vr5LepNPQ8wZ4ZsAsZVAUHeDVq0hXxdHhepEHyEy6SAC0MVV5wgz815Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bz7i9LRO+CxbSCyPvXqMei+o1NGigyAQHMTaN4MBXF4=;
 b=OyII1wRCwfql7ULsGe3Ed6+TFGZJEcD7oei+BgD9PmyFXYB/i3Ejv9+MKgBigmOVoGUPMXISSScN2VKD1XRKdL+mcPVZcQmt5slS1GGyt12Jc+vLoBdZe2i3NQDc4o1WxjuO4HbzrveGV9Jsnm/u+TXSJP+3AneKwnfnNfgVNP4PKA4WWTewAVjxkjEuaX0LUC+ZXdocep0W2SdfDvMu+S1lsnRHFN03a+ITtT7xmaRtxUyFI/9NMV5QXt4X44DqAHp3cUOq2JoNklDYR1CO3Bh67Znno1Ly1vrYEJGK9mluMzxKvKOOXabWdyOUNju593HJR6NOQv2JlyXLuHKOiQ==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 DS4PR12MB9658.namprd12.prod.outlook.com (2603:10b6:8:280::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.6; Fri, 13 Mar 2026 00:27:51 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9723.006; Fri, 13 Mar 2026
 00:27:50 +0000
Date: Fri, 13 Mar 2026 11:27:45 +1100
From: Alistair Popple <apopple@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: mpenttil@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>
Subject: Re: [PATCH v5 0/6] Migrate on fault for device pages
Message-ID: <abNZdtC74SHAy9TQ@nvdebian.thelocal>
References: <20260211081301.2940672-1-mpenttil@redhat.com>
 <76c5576a-65d2-4dde-a969-ef6577855864@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <76c5576a-65d2-4dde-a969-ef6577855864@kernel.org>
X-ClientProxiedBy: SY5P282CA0095.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:204::17) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|DS4PR12MB9658:EE_
X-MS-Office365-Filtering-Correlation-Id: e2d2ac66-3939-446e-5b0f-08de80975bfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|56012099003|22082099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	wN0A8i1hh0jYSUz8d5O8xTofWgrJmAGx0c1pVf7VnBSZ131eGNKVWAnIbjAb0LsGK4lwy+N4f9kCRVdQw/Au3e+qxCpEGMU3OtSEvCacidUl2XXCbVIe3w+ylQfCBPudMQAhTLBPA4PZjC+NHqqqaw/CMQIxUtHhKs/YtJdw0yLHfEeWpDDmf2qhqxzM2XxNTe/LQEa8M/CEhZxT779uDVWMxrnRTIas0qiD25SeIfKs2X44qsjb7YmLPpxPBzzRd6+Ahr9xzbVQfl+d71C8tUdR/r+oX4jbklMmOtf1jVtWjHcohkbCLWwPwGhe+uoCG0YGngmeGWylJO3pLj0wCcN46lQgUwwhaEwUzjCYZqUHVFEk4FctPx90OWRFTnqkSuBOJRbf1/AGPjVQP2XzA8Ss+T9+LnIugFfoKelTxzsa8hLXWU2ATPGZsvwWNgMpZkkzM9L/S22gSGcMgMWtfQeKYTfWpHx2IjtG/iw5kVE96t9SdephkviEigtguCavKE5gRC2ofLUvEcycp5HVHFD4ma8nBABLY17s24M784Zxf8S+jbkF9rGOhDxe44xMUoO8XHWqiZhM2Zgu2w0TdKOYGCHPmAmfCpfb2prAiAOYdcT09tLlFgrHI8YRA2+B1kdcsVGGl5FFL29gdgBtxi21eHSGuEflgIMkRRNz1qh1bM2MlAabefO6aihiK+nXjTor8BfY5QqF+F7zv7mux/kN7Gygjiw1y3DuyOGXrLWE5bsoZK8IgDg7fwAP3Wxa
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(56012099003)(22082099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?3W3cliUMhwqG8nv3uEVVzeD7CFZSXyLIsf622DS1n9FqPuTqYyzWaQ4cO2?=
 =?iso-8859-1?Q?vfmqrHNgbxYPQzkpTi3TOqBTmaWUMs10jiAHmNnN1BoAhaa6pn0f92Dke6?=
 =?iso-8859-1?Q?5edSL0/nc4dPjQWg5XBd0N8vZIkYP4TmtBrApT79k+MqUkdJ/sVZY1eQSZ?=
 =?iso-8859-1?Q?38fhqfeww01LfkUr9UvOL5eTdYRSTPyOn7BlSopxzj/1UDCOltAxowGi5I?=
 =?iso-8859-1?Q?Bd26/hmKccNrKuDdxpiiwg8FxKc/NVnnWNoP2sjREbdQSMUUs8nq9RellU?=
 =?iso-8859-1?Q?sizEhsAuQFcroKLVIVEeGXyw7pvPO007pH5wbrB1TLTfFT5jmoD/u/BqWg?=
 =?iso-8859-1?Q?O3P8qUtw7oCZD+423d/q+A0t0Ehn4ki0zRiaYHSjr6KcKG959At95jd9MN?=
 =?iso-8859-1?Q?WZhzpEv8sBWQmBnmQLC5wWSRsut2DkOLgdUdOYGY3ln2rpAqMWSq6xXufA?=
 =?iso-8859-1?Q?Lugen7e//7Yb5b5OafywIwEwpJ8iNkLehetWwdR5w5rlwbCe4in2tyk0tX?=
 =?iso-8859-1?Q?BqQ0Ait4sbKM/5Bipaxs52aCAEfzPbzkcf5g00ekeVA/ytHuuvLAgNT8BZ?=
 =?iso-8859-1?Q?Xz8QB4tyocQ0ciW/pSOCaUwvM+XC1X2Lqy8t8qsQGbp5/EdPqa60vbqMhr?=
 =?iso-8859-1?Q?6ZLoABUhHo4YsQPUEYSgAvyXOxLw6C3vgUPCcE+YAIGR069dP08qNWpgDp?=
 =?iso-8859-1?Q?N14dlOniQoJ5DgJupe+JZxX7WqgRtTNxq19Bu59ggASr/5hp2T/bj4VuNI?=
 =?iso-8859-1?Q?Zfmeov2sDUxhas3A2Pb8qvsAbz5i4FE8Fnzti7xFeKnQjTFjZPUkK1iEE5?=
 =?iso-8859-1?Q?7KbYm7rAungUVDz/C2vZhWNh9hXdBwZ/0brqcmyARc++ZZthUTLABZ2AKL?=
 =?iso-8859-1?Q?uTmkEMALUJnxO3UyuKgQxblM+AMo+p/e6Kua+cJEmIumox0DOV86TpxWdJ?=
 =?iso-8859-1?Q?anCDt/XppsK377rCBkZ3EvHSYUaOQCPFER/cCvUkteB3NpiQ0x4zF4l5tM?=
 =?iso-8859-1?Q?iT4JbPTXrUXyvpKlZzUxKZD8lFo/5blfis6eAqyC52cIimk84LHXPDA0Ov?=
 =?iso-8859-1?Q?mVN8NOhZvjY/MZKs12a6wuIFREZVHNfeStt/qRt1lqitDAsZDkmZjJPQ6o?=
 =?iso-8859-1?Q?JLzg01ryCBD+rI0vXj6M2ZKf97y24mKxz36GfB3NBTHnhuTLXIlSmhID5B?=
 =?iso-8859-1?Q?Hm9J+RMntp2JL6I+C5yS69J+pBYD8NJFHDCMHLN55GWSTAf5dbzOqyn5DY?=
 =?iso-8859-1?Q?NDK/gOfHfvUAmxyvOv/vbAGwyRSBk17aJId/rTkxwa2IMiN80nTAiaDcKF?=
 =?iso-8859-1?Q?1yrdALFEBLma1TLo7F3JdC/8NnDS0/iRXO49O+9GtLiPYq8uCho7eKefP+?=
 =?iso-8859-1?Q?vIDZw+ARg9y+h0xq+ibbAdxRLuTIQZTX90CHhEECMD7wJqnvhfzmn1Rn6J?=
 =?iso-8859-1?Q?TaTk/IwLnc9IQd1dMGGKtWFDOnqz7O/seOZyZTgLR0i/iydChzK4a30WPN?=
 =?iso-8859-1?Q?7H4Z0GaRjas9z9+RmBhbvNNo2zfEXEtkYGt/CMUGMWPqkC/JNPq+j1gRxE?=
 =?iso-8859-1?Q?+4F4WcySpHmvleD3FW85xgCJehCapPbLDyHu1dt+wOW4ReEvMl5ccZs4u5?=
 =?iso-8859-1?Q?8/4/FAeQe15y8uBNi5gfS1IxsQR6ec1952T5pRx/+6mMpOsK9pr/8QWWjB?=
 =?iso-8859-1?Q?qHN/oMzaK+irBQTo5/2IMrHoP2QglLrzoLt9nNRR1U4pYtRS3RR2B053FV?=
 =?iso-8859-1?Q?tvvG0EtpssTMlSpPNctoAA4QT1K0miNldM9TLjPXjrz/0L24XTRQLPhRfr?=
 =?iso-8859-1?Q?Lsch8brOHw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2d2ac66-3939-446e-5b0f-08de80975bfa
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 00:27:50.8261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pnL2LGOreoBpaqPinT143NmoBFfcAFFR0YpdFymlNqhLMpiuRRw1d3xrgfBuVBrXTLN4I6zr8ZInSseURhJFfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9658
X-Rspamd-Queue-Id: 7364B180003
X-Stat-Signature: s57a84zq7rb9jbtoj9f55mhqaw3asuiu
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773361678-526849
X-HE-Meta: U2FsdGVkX1/Dtbg0UzavX/T/DvcP615DGk1dREKskT+c8xhkqfjiSevNwahbkMWi+xiHmQ6hB5xUmvifP1zSK8dDQtD8uRoyjoLJkUvSZuy55ZX4DBnJFhOCyZvxpIqAQ/QtYdH72XJkTuZmA4J5T7vv7G3kQRirAQsR1MZwlRY3zSaTujfJioSf48pgTuEkP5FeJMWeh0qdhQBA9Yc8j62h3L/pN3RzsYQLLv3bEQqvHKxuiJYAGuaCxXVnIhxlKt9fkiJSNA0suqoQ1RY2Bkca8LuRT3FcBHLKXtcaCLG9LAfPVORXTYerr8xEOgwPthnOI6Sjln9nkq5X4kWpWMDraothBG5eHpBYUIkmfnsvn9K1RTNTEf8iSH60FRhLLHsH8b/rB0M8LDY2mbUYl/5kO0BoPvfA8PKKCXr+EXINHjm62JJTb2wIOjFdxVSW1JIWpKxyvfoTePo4XxR6j6tjSefWb1bYUZSxkjVEFtIXDcrKyxfUbp1JJa+GygXB12p/L0L8UUd3vTFRcVWsQeRzf5vR+cYoMpT9acq6hdW5OGp9I4/2yWcFMvXe2cpnj/vyy5G/OD86VKcFk7rXkc8GsOil6VLWNOfNOpifaeS00Ox3d5cxS1s9cfqbv43bCl6YYLExOyrXcZoyoMFvdCivS1cuRSCPoEW+yWKhewZE+YEZkfe8cWaCbf493SoQmVMhRgdmfAnixwqNsnRgDvoenU2YxqbGl9jyhbFAJQ4MC9zoSZozu5psOT5UqrtDfPwdOTCrJ/vNcSUuCgaqpltnColbYHzXeBF22vG6vzPuedncIFKp6ilmNGFVTPrRBgW6Jl5ggOlzxSyndCeWZfKwYwx3tCitEsI87WTVqnXFYJlxGdlUZweEub8p2RE//bztTJM9S7j0hyI6lCkjjwDHMfRg9+BMAtPbP1VRjyOa1+mvUFsBlWBM77Qm8p1PESqVcqlGzHktEMptaeE
 WWfOmJHv
 pAE/mgoTFiLiooVQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-13 at 06:58 +1100, "David Hildenbrand (Arm)" <david@kernel.org> wrote...
> On 2/11/26 09:12, mpenttil@redhat.com wrote:
> > From: Mika Penttilä <mpenttil@redhat.com>
> > 
> > Currently, the way device page faulting and migration works
> > is not optimal, if you want to do both fault handling and
> > migration at once.
> > 
> > Being able to migrate not present pages (or pages mapped with incorrect
> > permissions, eg. COW) to the GPU requires doing either of the
> > following sequences:
> > 
> > 1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
> > 2. migrate_vma_*() - migrate the pages
> > 
> > Or:
> > 
> > 1. migrate_vma_*() - migrate present pages
> > 2. If non-present pages detected by migrate_vma_*():
> >    a) call hmm_range_fault() to fault pages in
> >    b) call migrate_vma_*() again to migrate now present pages
> > 
> > The problem with the first sequence is that you always have to do two
> > page walks even when most of the time the pages are present or zero page
> > mappings so the common case takes a performance hit.
> > 
> > The second sequence is better for the common case, but far worse if
> > pages aren't present because now you have to walk the page tables three
> > times (once to find the page is not present, once so hmm_range_fault()
> > can find a non-present page to fault in and once again to setup the
> > migration). It is also tricky to code correctly. One page table walk
> > could costs over 1000 cpu cycles on X86-64, which is a significant hit.
> > 
> > We should be able to walk the page table once, faulting
> > pages in as required and replacing them with migration entries if
> > requested.
> > 
> > Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
> > which tells to prepare for migration also during fault handling.
> > Also, for the migrate_vma_setup() call paths, a flag, MIGRATE_VMA_FAULT,
> > is added to tell to add fault handling to migrate.
> > 
> > One extra benefit of migrating with hmm_range_fault() path
> > is the migrate_vma.vma gets populated, so no need to
> > retrieve that separataly.
> > 
> > Tested in X86-64 VM with HMM test device, passing the selftests.
> > For performance, the migrate throughput tests from the selftests
> > show similar numbers (within error margin) as unmodified kernel.
> > Tested also rebased on the
> > "Remove device private pages from physical address space" series:
> > https://lore.kernel.org/linux-mm/20260130111050.53670-1-jniethe@nvidia.com/
> > plus a small patch to adjust with no problems.
> 
> Stumbling over this in my backlog, so far we have to RB tags.
> 
> I'm going to take a look at the core MM bits (soon I hope), but it would
> be great if other people could review the HMM bits and provide proper tags.

Yes, sorry I've been meaning to review this for a while but have been backlogged
for a while. I should be able to get to it early next week though.

> -- 
> Cheers,
> 
> David

