Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4469FE9B250
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 10:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CE766B0088; Tue, 24 Feb 2026 05:38:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77C326B0089; Tue, 24 Feb 2026 05:38:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 633E26B008A; Tue, 24 Feb 2026 05:38:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 486FA6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:38:08 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ECE331604FE
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:38:07 +0000 (UTC)
X-FDA: 84479000214.20.1446A25
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021134.outbound.protection.outlook.com [52.101.70.134])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8C998C000C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:38:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=Im+rD9dA;
	spf=pass (imf10.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.70.134 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771929485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=43DjbiYj2NuaHikNngdHiT2Hgn4A/psYKLkYn5WUkT0=;
	b=aTqk9sunM5bsQN7UWT9iCAADtk/A77tTbv0UCFK/ptB4y7b+Wgpb94V89YutQpHLkOwf2T
	BSgWWcSml3I+3ntPmECzSb8thciewVEmU8dHnPakuMhxNWHbgFkTTcBm9URV76pFPecGLF
	bcO/Zb6IruqqcS+DEzyLEZ3N0wTNwm4=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=Im+rD9dA;
	spf=pass (imf10.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.70.134 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771929485; a=rsa-sha256;
	cv=pass;
	b=1YGO+5nBUbUADX4Lsva9t3Y/lASgqjGqPXQBqOKYsk/81PJMLTDrGN9zUyTgSNn0ve653h
	g4BO7MNhSdNHUSwMg5Xjdn9pV2OQsbxFDHEj51V063+EQP5pRlkN53fmN8sQb8/jV7E5RU
	9Rj/ep8ErjDSh8uJRuquf6yRaE/S4EM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bRYPPlSCoPLzZ55amJK8n7RECdpOkGL8WDta+hFLLbk363BH1cKzIdQ/pgl+2BQ+ejuF8glQ0/wkVZT+ndsxORx1xh76rgbptN22xTyoU0wetSzYJaeeL4PcEE8lyDq82wibvsu621VZykf4RVe8mOZtvPrtwjxozpgXoblXyiE+KM/4l/kfs7uLj7mNzB7lFXhFByuOw0nhC7PbiwPVs26YYxn7QBix+PNGO8ui34PZbtFtUb8tXQgA5U52ARIPuhQ/X8lO9vfpTln3HImtGKn9sayeDvwnJsNpfoavvHoh+SV3EhxsDahsBtvwzeCmLFv2+NhCvgtqm2Hu+MkNnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=43DjbiYj2NuaHikNngdHiT2Hgn4A/psYKLkYn5WUkT0=;
 b=e7ZFKbQrCJ7Ey0+nXBoFq3MQermGZ8U84xrc+BrRU76CrbetUq8jv36k/HT6A1NJ8A5XHJQnCX1CgDxGrq0yNw5+dHcM2fWfpsB3cfFLK1Oy1/LZiiRmHb0AOj3jSwenAWeM+1nznI2buVJT2ZrXCEfocvfQN295LPHj7KGvNiQYrQ2Aov1lBCvwLwoRk8YO8QZ7+T9fmZyLV/HYxLXEu6wvV5RkV8vBpjAPuNS66eQfU+6dTL3hx0GNJS8tW/3e6CMFT5L71EiHZUI1Sd8IiOj3xnntrv7ycqriwzxyScc/1iDos02BkDpql8apLFVE9vJ8O8a1NndQWAexmiad+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43DjbiYj2NuaHikNngdHiT2Hgn4A/psYKLkYn5WUkT0=;
 b=Im+rD9dAfkYxxYP8a/gCJ6IZerhwA6IzUiASOBA0E0Bj15I7P/Xz7MQ9ur6FFK6i7Wqw6PonzDLsBfNrxu/FjelEvj7/jI0f7EFtUmJDACr65EcVWl8Lgp7VKdUh6+RWddK5R/vFG2quANiD2JCozJ/aC9G83jysA2rpiw1nAATcrz7RapGJxWBxfWAci8YkIf7WfwpArPiOPlfc/bkmoWxRktpxsQzW4tpPA0eb0FfZ3fXGQXbZmrwBUQyWLVSJApXMptqGx5/rQFOy5ud+22XBfMo4hskKpTWC5MNYfLe7O5wjoKDX55wH9dYSIC7Ggl6ROgpwYLC/LI0CfrzP4w==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by VI1PR08MB10007.eurprd08.prod.outlook.com (2603:10a6:800:1cc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 10:37:55 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 10:37:55 +0000
Message-ID: <4de06792-d8ea-4f2e-848d-0dfccdb64253@virtuozzo.com>
Date: Tue, 24 Feb 2026 11:37:30 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] pid_namespace: allow opening pid_for_children
 before init was created
To: Andrei Vagin <avagin@google.com>
Cc: Christian Brauner <brauner@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Jan Kara <jack@suse.cz>,
 Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>,
 Kirill Tkhai <tkhai@ya.ru>, Alexander Mikhalitsyn <alexander@mihalicyn.com>,
 Adrian Reber <areber@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260223200254.4104651-1-ptikhomirov@virtuozzo.com>
 <20260223200254.4104651-2-ptikhomirov@virtuozzo.com>
 <CAEWA0a63QxMRqCwpCUqb5iKih31LY-2zX+--SkMGcP-Y19PqpQ@mail.gmail.com>
Content-Language: en-US
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
In-Reply-To: <CAEWA0a63QxMRqCwpCUqb5iKih31LY-2zX+--SkMGcP-Y19PqpQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0486.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7e::29) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|VI1PR08MB10007:EE_
X-MS-Office365-Filtering-Correlation-Id: ca31c4a4-22cc-47ab-3894-08de7390c538
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|10070799003|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cG9KR2UrL2xEMjIvZWJ3UEdWUDNzSUt0RERMWEVPNW5ncWYvNmoxRHR0RDhu?=
 =?utf-8?B?eENTbS8xd214MDlCRzB1dzRrZUZCamVSTkEvWE1uTVNjQm43anZ3R0lqaVRn?=
 =?utf-8?B?NVRmTnQ3M3VVVHcvNTQzWGhvY2pRTWZtQ1lHeTF6WFhIS0k4RTRHZlJ6QTZT?=
 =?utf-8?B?MXkycUQrem1YZzk4YnUwNTZCZnZVZlpaWjBaWjMrc2dXNCtPbHFaK01BOTFM?=
 =?utf-8?B?TmlTTXlzWnJhMzdBTVJKR2NUQ1lFQWZ0cER5QkJ3eGpGdHBTbkZubjQ2ZHRu?=
 =?utf-8?B?Q01CQnNuc2pSWDloYTVvNFdWK1dDbk93a2lDMU5Kd1RYQ295Z3Y4UUhTTGxE?=
 =?utf-8?B?TWM1YkNTM3psbXFrOXVvSGVoZlJjWW5tZzRBVzFrakUrVjRFd1J1MEhZWk8x?=
 =?utf-8?B?ZUxGZTdZaVpBQTN4aXB3OGNQNHZJVWw5WUF6Zy82S21sN3hUaGVyQzVJY3Ay?=
 =?utf-8?B?U09DUGtabVRNZ0ZJMUlKRWhMMU1ORzN2d2pNQ0VoMmtqdFVEV01xM3ZTQ1Ro?=
 =?utf-8?B?S3g4cHRYaHkwaVNzRTNFbnFIOWd2c1FKWkt5VWhNdElmVW94WUVLQUZWU2dE?=
 =?utf-8?B?UXNkK0ZxWHdWdzFDS2tFVW1GSEhBbnZLY2NoNzJsVEZvMk5YN0NVVXNTei9r?=
 =?utf-8?B?OG5pQjZBVVExUXlCK1VNcTVtNXZialZzRjdlWEhVVjR3WDBKeGZYOEkzcVlW?=
 =?utf-8?B?VVVyVjZFa2lSMkdWK3VQR1hCZEdsamROaEthZ1paazNQa0lIeEJ4L1RseGsx?=
 =?utf-8?B?dXdXbnN5ZGN0K3BCNHZMRGZhL2dOeVg1bEttZ2QvS2Vic1NiWnduK1VQOTZ6?=
 =?utf-8?B?SmV5MnpUaXVVYkRFbUUyK0V5akt4TG1TMDlqTFdmWnl4aUI2ZUJJdXMrai91?=
 =?utf-8?B?OG9vQ1pzTnc5VVY5eTVyaDNDbHI3YWtSd040cGVOeXdMQm1nVWYya3ZnQUpC?=
 =?utf-8?B?SWlKSlM4UDZhQjJ5Ymt2Wk4wMjVhaWIyZGJrWmRZclgyVitFYzNJOWpNc3R5?=
 =?utf-8?B?YS81UXFtS2V1QVg4dTVIc21hK0Q3dG54WjF0RGxpS1ZqZVBHOXowZG50ZDkv?=
 =?utf-8?B?ZTdaUW4rdXRYQ2IxcGNLc2VMRnhReW1YQVRKSHBjMExPVXV2UFdkcktmVDlW?=
 =?utf-8?B?U0ExdEkyREFOS2xCOFRZV3FueVlpdjhQcklxTERkbEhxZkd0VmZCUFFyZHJw?=
 =?utf-8?B?QWYrVGsveDdPNmUzVWlwVklpUTdFaXpLMlhDU1ZXK3Mzb2lQYytDQkRQL2M5?=
 =?utf-8?B?cU9kR29tKzU5bHhCelc0WTZENFRtK1pudmRhMTdIREllekQvTmkwZExJc2x0?=
 =?utf-8?B?d0p0ZHptcXptSFB5Y1A2aUQyN1ZmUVZZdnhzeU5wb1F0NDVVc25JZGxiUEYw?=
 =?utf-8?B?R0dIeDlXNTdKQlpyVW1mNDI2TWttUjRHSFhhb09BL2h1NHo5K1pDS2Jtd1A1?=
 =?utf-8?B?cUZEVW5xMG5HMnY3RW54WjNjYlhhbDFhOEg0RStIUzBVL0liSkF0OURua2JN?=
 =?utf-8?B?WVhJSTJiMVlVYjJ5QjZZZHU2SGxVTlQ4QVdXcTEyWG1jSXdkcE1GU2piZW4y?=
 =?utf-8?B?dlFMTVV2YTAyNHYxWGQ0MmFrN1Q5WnNpSXZ3d25uanRDdzBRSENqUFRyOTZU?=
 =?utf-8?B?aTIyQVNXd1JhV2JFZFNrcDBBZjFzWU5UZkdkaVd3YU4rMWxTeGxNZ2ZobHM0?=
 =?utf-8?B?Y0RyaU5PdUJ1Vk5YN3piWmF4Vm5EMUhZYnJXTHBqSGZIRzJjVVprOURMY0pF?=
 =?utf-8?B?eGRiRXplY3ZmVWhuQ25aVTNpRUl3N2ZkVGYyZVhRR1dLSWtzTEVlNFFKd0tR?=
 =?utf-8?B?M3BIdzRibERLSit2MFpNcXc3cm9NTmJjaStIYy9IeWhwNkR5QnN5b1IvQzVC?=
 =?utf-8?B?TjI4MUFWc3pJQU5Vakp1UWVvMzFVb0VXVERaamQzWWI2K3JGMXBiU1hLL296?=
 =?utf-8?B?NUNlWFhwbUJWWGhzWlFBdFB1NVFmRFFHVnM1UWV3VlV2UStUWG1QdlNxTjlG?=
 =?utf-8?B?VFdpNDlrYk9nZ3JmR2RBOU5lU2R1bkNqV2tPenhwVHJZMnlQN053VmhUUTZG?=
 =?utf-8?B?S1M3MThMVlM3bjhPazl0TUJaMXIxNVlhL01ua29reHpORkJNdXZ2MzVMbmwx?=
 =?utf-8?Q?JNC4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Uk93a0VLTHB3VklBZWY0K3I2MXQwMVEwMW1Fd1NqRzVSNUsvSkVmYkFJNGhE?=
 =?utf-8?B?OUp6eEF4TWQ0eElDRGZ1MFNvQTVlUFJSTTZmYjJEL3AwM1U5b2MrbU4yZ3pi?=
 =?utf-8?B?cW1mamw2WWZ0ZTd6R0l5TEY1YThRWWRqOS9CQ0xkT2FrYXZtdmFaMFIzdldZ?=
 =?utf-8?B?R1Z0N0FBZVhDMmtPRG9jelBKMFNENUozT2drb21GaGEveVVNeGs0ZTJ0amlr?=
 =?utf-8?B?a3dWVWt5M1N4dTdFZXM5OU5FdTRNUEowK0tUZEJvbnBVaWJ1VmNZYVNMNDBH?=
 =?utf-8?B?VFF1b0FzMk95N0cvTlBWQXRoV3VkVnBsN0dzYTAwbC9TWStSeVFxaWppTlFE?=
 =?utf-8?B?aytlbVhLeVpjaGhWS1hkdjdveDZMV1A4eUQ2WEFIN3d5R2pJWXByVS83akJw?=
 =?utf-8?B?ZXcxN2JlRC9tck15SytLbm1MditUTy9ZOUlCbjhZNlliOTdiMUFYTXNucjUz?=
 =?utf-8?B?eGd3aGZPazR3cTdkajVTSXQzeHFacGJzTFlBWjhKcWlSSWlhdmhLWTdoN2Ev?=
 =?utf-8?B?VGEySjhMdnVxaE9CeVhadlh1Tm4yYm1qQllINEIvNXZwZmRWNktUbS8rT2Nn?=
 =?utf-8?B?M1NOTXdERTZoQy9WY2crZW9DUVQ1Y2M5ZUJkZTZEemZZdzkxYVQrK0hicmtH?=
 =?utf-8?B?azZ3OG9MdGxrdVI4NEsvb05JZnFqZ2szcFNJL2x5clMrUElCYlF4MjFnRGQ4?=
 =?utf-8?B?dmkwNDFVZmd1eHgxWHhMNy8yb0RQZEtNVDRWVWhzdUlmSm1EblJMNzRWOUM5?=
 =?utf-8?B?K1pSNVN0QjZuTE5wV3FreGlWeVBEMlN0Q2RsNzZLbjRpV1VNMENzekIxUzlC?=
 =?utf-8?B?OGpaR1U0RGlJb1BNU3pGb29sUXlVVnp3bk9WOXNyZHlUOG91VW5ZWWVuK3Ra?=
 =?utf-8?B?QnJHcThVNndrdWlteTZkZ3VZNmZJWFp2VXBkd01IS2pQc0tGanpyczM0Zlp4?=
 =?utf-8?B?K1JpT3dsMVUwSklDVGxwQnRXT2hZMzdodU9TK25iTTJrVXh3N0RaK3E5bDBa?=
 =?utf-8?B?cDJVZGtMcldWS2g0Tmlia3R2dzFuSDd0YXpUQk9taExiZXhnT1BvejBXZzBy?=
 =?utf-8?B?ZXEzanUydVlFaU12UklyRWFsWW5ySHRnM1dIZUJDaVd0aldmYitsNVNkQXBs?=
 =?utf-8?B?aXEybEhMeTM3OGVvM0QvcjJCckVWWjljVkFDdGdiSFlpSk91bHBUYUVzdnhi?=
 =?utf-8?B?L3owNWdmcDkxU1ZvNS9GL3FEMHJJMFVhSlVWc2hMRzZORkUvci9xS2d2enk0?=
 =?utf-8?B?Nlp6clEwTWQxVk0ydUtVMThnY2xpb0sxZ0dCRXJnc2hNRTRtY3hhVzJ6cWxD?=
 =?utf-8?B?V0Rzbjh3dW8yeUxqcjFMMUEwa3hGQzNMclhpbDZaWjdVNklZM3lMV0FVcHpq?=
 =?utf-8?B?anVxcDgzTjhJM0hwSDRGVGVyR3lEQ1MrUS82TUZTTW1zTWVMZmFNcEdvamt4?=
 =?utf-8?B?eFIzNzVYeDZMVzJSblQza0Q2RnNqMDFWN3pRM2hlckd3U2l4bjEwMzJ1Wkpv?=
 =?utf-8?B?cUxWNkorUFVRMEZ2VWpjYjNKbGdjc1MvdVJnL1ppbS85NEFkNCthWnVTY21E?=
 =?utf-8?B?Nk5jeG9nbkJrY2FDemxvWlRGa1NscnIvV2pza0Ztc2pGSGNRSDRNTE1FNldR?=
 =?utf-8?B?Y1M3U0h1bHJRd1JZV1Z5NC9rNzZ0NkRJczFZS0FtNXlpaDNqaFpQQTB4QUNC?=
 =?utf-8?B?YjFPY2I1L0hnYXdnZWNQMXlSWGt1Tk9uZ21zcmg2bXA3U0NWREpSZlI3M3gr?=
 =?utf-8?B?K1lOdEo5RDJDOWltOXg4d2dtMTlORVA5bWZON1RJa2FPY1V3VVhMM0l5YTkr?=
 =?utf-8?B?U2NsZXF3K3NFWUVuLy9PTFNDS3NxUUlOVS9HZC9QZU8wK1dUdkxsNVZES0hH?=
 =?utf-8?B?L0sxVkV0Rm9mZ3lEc0JrMmU2QjUybUd2Y2pIQW9FeWNDOHpsSWphekN2TVlR?=
 =?utf-8?B?UUZ0QmRpMERJaTBtcnEzc1lMSUJkRzhwSDB5RlM0cXkrMWFCbHljcXlrSXFi?=
 =?utf-8?B?KzM0dGJhYW1JZHZVVTNsRzZwTU9FTllwM1pxK2x6MldXZ3RHOGg5Wm10TnJP?=
 =?utf-8?B?eDNjaXRyVElIazVFUnF0amRNTmxkZ3VOSk5vTklraThFenIzc1JnSVcyemY0?=
 =?utf-8?B?b2FJalZEQytmREhZZDVpazRzZFh5TU84MXRCdENPZW1VNEcvbUIrNndERTNz?=
 =?utf-8?B?RGE2bkVXTkg5d0FoODJKbEs1VHpwS3ViMEZJR3c4akVESC9JajFuaDJFeUph?=
 =?utf-8?B?cmp5SUVHclhjb1YveXF6OTBIVFl4WkMwc0doNk56QU5ScTc5aHc4alN1Sjd3?=
 =?utf-8?B?QVpObXdYWXhOeG9TS1RLY0h1cURBcm5jOC93ZElrcHdOdWtxWVBvTDY3N1lB?=
 =?utf-8?Q?8EwGlNQpPmvpAiaFLH+mbhqntjtQvV6u0A2G6b7u/Fl2W?=
X-MS-Exchange-AntiSpam-MessageData-1: stBc9JqybZjJ9B87AG4/YPVQEa6o5YL9nYU=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca31c4a4-22cc-47ab-3894-08de7390c538
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 10:37:55.6207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WPtCvISDmR/64NNfS327psDw3+TEo/Wa/NZpwZpRg1JGwsTObbM7+Ug112QeRmuDyr4kaghjTiUad+cH24nci/U0AZwTT7x6MoogsRUJvOo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8C998C000C
X-Stat-Signature: bp8yg1q6jyzs1prhe1pnii1asrxnf34e
X-HE-Tag: 1771929482-302993
X-HE-Meta: U2FsdGVkX19B0QTO/Q0AdLRh44Cpt2AWeiocv32DJZyNAK/drf2sHPxJTJLCUSqn4QAm0mR6GhYb6cD5k3vrj7IXmBOWbEJLujBbFx5bdF1h6ELjBSRF+qYVuVnR+nCGt/uTW4V2L6OIoGc1NgydwoIbVG5MVjp6c+EoswTJrdxW1iQfaQuDnES03e04Kf1R12rvLE2Wv35wKOtrGUZHFIj4l4sYWOLVxHVGpo0nCDkn9EL1Wp+q847Q1lQhi4s8Z+TPZRgGf+ZJn5UX6mpQNqpfF/PjO2TdTqx+7/y3MiLRZJmmZRjM7va5SHFOm9O2cpXhoIJFuhoSpGPM1rFSKs3rf3ludg+7rb3WbvdRs7nb0l2s8BruDcDBL7+DRzZ+ELjfETb6iEoTDNKI4my39Lqn8uWZaBoSvadBrimMoSgdq3huu53F2QOR433TiHgXS06hP78sYhSg7m1AxdgNY16grr91ksTTaOCzM6+JFNVuUY2rR8z1VXDJFEA082s9FJdb+VbaeoEKs1j84QX9lGVnuNj41ssH6oMMuaKrYjNRBAevYBLFNgmHJ0zuLokKEQYAKveKzGI8XejBem9GbLYDUNzqoeqToJ2VuwlkQQ4Majz5gksw4o3S8SS5+xS59/s7/FjADwXOPOlwKSt5ac/cAZngkAb51wZEujE2KpXhol24gV05N5UZ9LLEn4kEaIeartYGfbZLB/LlekfizO5hOoaH+5atWnlxFRIxs7uZsEZZfzkwmsOPo+TCIw2xBFzhDGII3Q14IC6I/uLhD3YzzPzUj3GEcm7PUJNBUmwr+0bHoC4eHc188GLpM96KWbNCBMZUtcmCfTxKZSZNgTLbpf7Y+XvFLgwRMHnRfCD1U2AnvNbXRbYA8oANvTE9YgdCPaljNv9XnidxeatgIy+uhBpeZ0OWDQ71ocbO41WPE2Mq4kghAB7DLBtUDPT4jq2wqI2taMkvnLuOkF0
 Tz0eZtSb
 1LTgQSkV3ojOK3MN0CgYilICAxlHr5Zf+jvRukPdu6R5rpSFwp1RPn3J/lcu6Nnb9lxbakcwUrkTWkmHejTqKeeSiupL0F8jttK+7XToR9uZZUwX2/VZ/nNsHg6N4mKGlqcG7CKOyYklTzhJPvUv13nWQ93adlV6UXPfvEtIyRDt64l3IyI3FPcTKJE0L/dWvhWaVcYr7viz+qeAX9KyomlEre29/G14ajaJ0SLoa2SWM2QBbp5WlsyhYaqYAL23tAiJ09VOXujiUUc5rsusT/ETlvuqLJL35bqjcdVE6bPr9ux1uv7Fd8uDYXOKa8FeulaofhPl09/OLBiIKaCtl44sLljJpmqhh3VVnfpSopdD/Qo6SfKcwk1pQZLzaVqntf4xcs3XyNoshyOqX0r4jAQh+Lge18aSWsYdgSybP2zUN5vAUmhjeahVRzobz5bIgHWTzTRTwF7IJU+2aHw8sobsDUQs8wzQ+7G1j/qLAnozvk7l8wwOdPJ/jPFXigqAyXGEOr7puXUoJx0CEfHFu6N+vw47tRymRLRQixgUwriycHzgpMpt9fNIyTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/24/26 08:02, Andrei Vagin wrote:
> On Mon, Feb 23, 2026 at 3:03 PM Pavel Tikhomirov
> <ptikhomirov@virtuozzo.com> wrote:
>>
>> This effectively gives us an ability to create the pid namespace init as
>> a child of the process (setns-ed to the pid namespace) different to the
>> process which created the pid namespace itself.
>>
>> Original problem:
>>
>> There is a cool set_tid feature in clone3() syscall, it allows you to
>> create process with desired pids on multiple pid namespace levels. Which
>> is useful to restore processes in CRIU for nested pid namespace case.
>>
>> In nested container case we can potentially see this kind of pid/user
>> namespace tree:
>>
>>                             Process
>>                           ┌─────────┐
>>     User NS0 ──▶ Pid NS0 ──▶ Pid p0 │
>>         │           │     │         │
>>         ▼           ▼     │         │
>>     User NS1 ──▶ Pid NS1 ──▶ Pid p1 │
>>         │           │     │         │
>>        ...         ...    │   ...   │
>>         │           │     │         │
>>         ▼           ▼     │         │
>>     User NSn ──▶ Pid NSn ──▶ Pid pn │
>>                           └─────────┘
>>
>> So to create the "Process" and set pids {p0, p1, ... pn} for it on all
>> pid namespace levels we can use clone3() syscall set_tid feature, BUT
>> the syscall does not allow you to set pid on pid namespace levels you
>> don't have permission to. So basically you have to be in "User NS0" when
>> creating the "Process" to actually be able to set pids on all levels.
>>
>> It is ok for almost any process, but with pid namespace init this does
>> not work, as currently we can only create pid namespace init and the pid
>> namespace itself simultaneously, so to make "Pid NSn" owned by "User
>> NSn" we have to be in the "User NSn".
>>
>> We can't possibly be in "User NS0" and "User NSn" at the same time,
>> hence the problem.
>>
>> Alternative solution:
>>
>> Yes, for the case of pid namespace init we can use old and gold
>> /proc/sys/kernel/ns_last_pid interface on the levels lower than n. But
>> it is much more complicated and introduces tons of extra code to do. It
>> would be nice to make clone3() set_tid interface also aplicable to this
>> corner case.
>>
>> Implementation:
>>
>> Now when anyone can setns to the pid namespace before the creation of
>> init, and thus multiple processes can fork children to the pid
>> namespace, we enforce that the first process created is always the init,
>> and only allow other processes after the init sets
>> pid_namespace->child_reaper.
>>
>> To avoid possible problems related to cpu/compiler optimizations around
>> ->child_reaper, let's use WRITE_ONCE (additional to task_list lock)
>> everywhere we write it and use READ_ONCE everywhere we read it without
>> explicit lock. Note: we already had READ_ONCE in nsfs_fh_to_dentry().
>>
>> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
>>
>> --
>> v2: Use *_ONCE for ->child_reaper accesses atomicity, and avoid taking
>> task_list lock for reading it. Rebase to master, and thus remove
>> now excess pidns_ready variable.
>>
>> Note: I didn't find anything in copy_process() around setting the
>> ->child_reaper which can influence the pid namespace, so it looks like
>> the pid namespace is fully setup at the point when init sets
>> ->child_reaper to receive more processes. Thus tasklist lock looks
>> excess in pidns_for_children_get()'s ->child_reaper check and it should
>> be safe not to have it in the corresponding checks in alloc_pid().
>> ---
>>  kernel/exit.c          | 2 +-
>>  kernel/fork.c          | 2 +-
>>  kernel/pid.c           | 5 +++--
>>  kernel/pid_namespace.c | 9 ---------
>>  4 files changed, 5 insertions(+), 13 deletions(-)
>>
>> diff --git a/kernel/exit.c b/kernel/exit.c
>> index 8a87021211ae..567fc3b7b0f9 100644
>> --- a/kernel/exit.c
>> +++ b/kernel/exit.c
>> @@ -608,7 +608,7 @@ static struct task_struct *find_child_reaper(struct task_struct *father,
>>
>>         reaper = find_alive_thread(father);
>>         if (reaper) {
>> -               pid_ns->child_reaper = reaper;
>> +               WRITE_ONCE(pid_ns->child_reaper, reaper);
>>                 return reaper;
>>         }
>>
>> diff --git a/kernel/fork.c b/kernel/fork.c
>> index e832da9d15a4..27d0cdbca67e 100644
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -2423,7 +2423,7 @@ __latent_entropy struct task_struct *copy_process(
>>                         init_task_pid(p, PIDTYPE_SID, task_session(current));
>>
>>                         if (is_child_reaper(pid)) {
>> -                               ns_of_pid(pid)->child_reaper = p;
>> +                               WRITE_ONCE(ns_of_pid(pid)->child_reaper, p);
>>                                 p->signal->flags |= SIGNAL_UNKILLABLE;
>>                         }
>>                         p->signal->shared_pending.signal = delayed.signal;
>> diff --git a/kernel/pid.c b/kernel/pid.c
>> index 3b96571d0fe6..e6116e131d8d 100644
>> --- a/kernel/pid.c
>> +++ b/kernel/pid.c
>> @@ -219,7 +219,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
>>                          * Also fail if a PID != 1 is requested and
>>                          * no PID 1 exists.
>>                          */
>> -                       if (tid != 1 && !tmp->child_reaper)
>> +                       if (tid != 1 && !READ_ONCE(tmp->child_reaper))
>>                                 goto out_abort;
>>                         retval = -EPERM;
>>                         if (!checkpoint_restore_ns_capable(tmp->user_ns))
>> @@ -247,8 +247,9 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
>>                          * alreay in use. Return EEXIST in that case.
>>                          */
>>                         if (nr == -ENOSPC)
>> -
>>                                 nr = -EEXIST;
>> +               } else if (!READ_ONCE(tmp->child_reaper) && idr_get_cursor(&tmp->idr) != 0) {
> 
> I think it is better to update pid_ns_ctl_handler to prevent setting
> ns_last_pid in a pidns
> without init. Otherwise, figuring out why fork returns EINVAL can be tricky.

Hm, I think pid_ns_ctl_handler(), as it uses current active pid namespace can 
only work if current is already fully (ns/pid) in the pid namespace, and thus
the init is also already there. So it's implicitly protected from change
before init creation.

This check here is more for the concurrent alloc_pid() case. When one process 
in alloc_pid() successfully allocated the pid and than, for instance, hit the
pidfs_add_pid() error and is going to free_pid(), but the pid 1 is remains yet
allocated from idr and the cursor is on 2 at the moment. At the same time the
concurrent process may get to alloc_pid(), and will see cursor on 2, it should 
not be able to create a process as this process will get pid 2 and will be 
created before init.

And in general (non concurrent case) it makes sense to only allow allocating 1,
for the first process.

> 
>> +                       nr = -EINVAL;
>>                 } else {
>>                         int pid_min = 1;
>>                         /*

-- 
Best regards, Pavel Tikhomirov
Senior Software Developer, Virtuozzo.


