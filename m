Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F26C1CFA46B
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 03:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A68B6B002A; Thu, 20 Nov 2025 22:00:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 055FB6B0062; Thu, 20 Nov 2025 22:00:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E38CB6B007B; Thu, 20 Nov 2025 22:00:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBC966B002A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 22:00:08 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA5B1139D85
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 03:00:05 +0000 (UTC)
X-FDA: 84133109970.17.7DBE21E
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazolkn19013083.outbound.protection.outlook.com [52.103.33.83])
	by imf11.hostedemail.com (Postfix) with ESMTP id 05FE540009
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 03:00:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=HOTMAIL.DE header.s=selector1 header.b=obgFIDab;
	dmarc=pass (policy=none) header.from=hotmail.de;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of bernd.edlinger@hotmail.de designates 52.103.33.83 as permitted sender) smtp.mailfrom=bernd.edlinger@hotmail.de
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763694003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z20JZRB6FxIGQcGkjDNyffGckoJ+9Ld4B/+XRHhAt+g=;
	b=su1geNAugNJP+REbQ8FWtnJPZyKwZMt69eOJIQN93AijhVp01na+b+fTFzdrwQYPiH59ya
	2CdQQbSHKOoJ8XwI7W7d7AiyrCitRg2N7Bs34M19MWJDuiJ+pSpVp9qlBcUzydVRyFLlmp
	xW+EgwEGKVyYuKNg+3+x2q2u7d2Ct98=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763694003; a=rsa-sha256;
	cv=pass;
	b=HmHlAUoWGLQ8dWL3Y4YNKPq0s7zM/w/JSEMdOuUVInm0e5WqYVu943KJhya1uYTXP2nX8X
	vRYFHUmRky2w2n39ojSPaDVcvYneidN/H45FtCyCsUuAOlPocy9r8WsE7LLByoBucZNRpP
	WgSxXH5PiU3MHIhhmEENXozVbUEekvM=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=HOTMAIL.DE header.s=selector1 header.b=obgFIDab;
	dmarc=pass (policy=none) header.from=hotmail.de;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of bernd.edlinger@hotmail.de designates 52.103.33.83 as permitted sender) smtp.mailfrom=bernd.edlinger@hotmail.de
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RA35waWuj2uucsFjjUS/repkX/5ClrcwMzOBaH7v+iega0AzLrextLldoqATcssmnpnjaxYk1oG8/6qU6MAI8ads6qp+AVqdF4FQA3/GIP9rycgKZcaFMbkfzf9NpszWC473efN1MW/ewCEJq4a5KJZ4JnSkvEabb9HBkad2TKykYWHIiPY8R1NkW2h/IFU9SRZ0Sk5AQoXtMxoxg5r3KixlKsrzm3rHSQ4XlaZhvUMatjxJcMStpTTDZWkmhvO3wyRtdMuVJbu2ehTtSkUblPXXkgyKAsWbaoRy4TaHlmI+9OnQjlfqGX306IvS4XX/TSG1B3Ju0/xwL1nMG/8GJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z20JZRB6FxIGQcGkjDNyffGckoJ+9Ld4B/+XRHhAt+g=;
 b=pUFcnEkImh3lRgLu7+d38rHNx7P6SP4dI61UJ7C9OVyFa8ohNg23I+oH09+Lez88QS4tnSden/GJAXtWTiusgjlvpAtdLW1yJ+JxHeydegR3T5LtJ9YJcy3eMItVHs/i1CeewgZejdInDF1oHqhS49W2IRH0WewdwrS0eL0+aVHvi5ig12fOhMDuyHVexdPcakTyga8Pee0lJQRmqbhvOeHUrTLtL/J1mCitGPpbgkNwLfwLOlc1KUNiUCQmbiWbWOYitcdLK7TwJTAbXJM/ySmRnPeoEYYmtR0SUKiwwUQ230UfnYMnW71e0VaQ9nwslvNIP8J6YXCez1LhC9w0Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.DE;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z20JZRB6FxIGQcGkjDNyffGckoJ+9Ld4B/+XRHhAt+g=;
 b=obgFIDabT4fVBvwJKvZNO19LN6u1GMR5xNHt39bymWvWmBF1T9NCAarYxlmIaLuUWLevb1vPCxmke9ykEuM3N8ydk0mkgKahDdOMUEj7NeLQCH8+v+pw5uJQbkvI0yzS979e9deiY3Lc0dSdFrfLOmwTMZhCJnZ2ttSRz/8JL6zlnW7/Faa7yuWxeBmL7vcW5b5H8PNVJmuasNabXw9yck55yVc9WSEtgNsgYZcum/5xzV7qbWBWECEBDObijX6UPH63S7q2L0/635klXT7Ft26NK2EZcndm3G0Olpy819MCvRy4fzQ6+XJsMv6olPuE1L00WcP0HPLuwe9JX6362g==
Received: from GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:158:401::8d4) by FR8P195MB3355.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:d10:1b4::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Fri, 21 Nov
 2025 02:59:59 +0000
Received: from GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM
 ([fe80::dde:411d:b5f2:49]) by GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM
 ([fe80::dde:411d:b5f2:49%8]) with mapi id 15.20.9320.018; Fri, 21 Nov 2025
 02:59:59 +0000
Message-ID:
 <GV2PPF74270EBEEAD4CACA124C05BE1CE45E4D5A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
Date: Fri, 21 Nov 2025 03:59:56 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH] exec: Move cred computation under exec_update_lock
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
 Kees Cook <kees@kernel.org>, Andy Lutomirski <luto@amacapital.net>,
 Will Drewry <wad@chromium.org>, Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>,
 Serge Hallyn <serge@hallyn.com>, James Morris
 <jamorris@linux.microsoft.com>, Randy Dunlap <rdunlap@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Yafang Shao <laoar.shao@gmail.com>,
 Helge Deller <deller@gmx.de>, Adrian Reber <areber@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>,
 Alexei Starovoitov <ast@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, tiozhang <tiozhang@didiglobal.com>,
 Luis Chamberlain <mcgrof@kernel.org>,
 "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Frederic Weisbecker <frederic@kernel.org>, YueHaibing
 <yuehaibing@huawei.com>, Paul Moore <paul@paul-moore.com>,
 Aleksa Sarai <cyphar@cyphar.com>, Stefan Roesch <shr@devkernel.io>,
 Chao Yu <chao@kernel.org>, xu xin <xu.xin16@zte.com.cn>,
 Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@redhat.com>, Dave Chinner <dchinner@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Elena Reshetova <elena.reshetova@intel.com>,
 David Windsor <dwindsor@gmail.com>, Mateusz Guzik <mjguzik@gmail.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 "Joel Fernandes (Google)" <joel@joelfernandes.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Hans Liljestrand <ishkamiel@gmail.com>,
 Penglei Jiang <superman.xpt@gmail.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Adrian Ratiu <adrian.ratiu@collabora.com>, Ingo Molnar <mingo@kernel.org>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 Cyrill Gorcunov <gorcunov@gmail.com>, Eric Dumazet <edumazet@google.com>
References: <AM8PR10MB470801D01A0CF24BC32C25E7E40E9@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <AM8PR10MB470875B22B4C08BEAEC3F77FE4169@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <AS8P193MB1285DF698D7524EDE22ABFA1E4A1A@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB12851AC1F862B97FCE9B3F4FE4AAA@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285FF445694F149B70B21D0E46C2@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285937F9831CECAF2A9EEE2E4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEEDE0B9742310DE91E9A7E431A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEE807D016A79FE7A2F463E4D6A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <87tsyozqdu.fsf@email.froward.int.ebiederm.org>
 <87wm3ky5n9.fsf@email.froward.int.ebiederm.org>
 <87h5uoxw06.fsf_-_@email.froward.int.ebiederm.org>
 <87a50gxo0i.fsf@email.froward.int.ebiederm.org>
Content-Language: en-US
From: Bernd Edlinger <bernd.edlinger@hotmail.de>
In-Reply-To: <87a50gxo0i.fsf@email.froward.int.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0394.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cf::12) To GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:158:401::8d4)
X-Microsoft-Original-Message-ID:
 <826efc8d-bce2-4fb4-bb01-09ab2a802223@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PPF74270EBEE:EE_|FR8P195MB3355:EE_
X-MS-Office365-Filtering-Correlation-Id: 844212ca-42b1-46ee-3b11-08de28aa0eba
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|51005399006|6090799003|5072599009|15080799012|461199028|23021999003|12121999013|41001999006|8060799015|19110799012|21061999006|440099028|3412199025|40105399003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UjBMd2lsOWJLV1RWa3NlMXJMQjhrMU90VUpRK0tSUFpUZHQwekVzdEpaWkZW?=
 =?utf-8?B?ZU9sU09hZGVyeVFNUk53eXFnWEd6cGZ5L3A1TkZyWDZldHpvNnd5clNoVmdp?=
 =?utf-8?B?TmxMMllvaU1raVNjekJmcW9vL3U1RXVDQWxJNkhUOUNZRG54NjEyU3ZSWm80?=
 =?utf-8?B?M25xM3c3MDdtdWdXUHE4c1NFaXhycEVMZERCVXZhM0RaOGlHV3h3cGYyZW1p?=
 =?utf-8?B?S3psbWZ4Qk9EZHFtUkFWZFNOQ0tnNFkraGYwczZ1WlZ0Und6RmgzWjVFWGg3?=
 =?utf-8?B?V2VJdE5qZTZzRUxqbFh4RzNmd0JvRUliMU9uRkk3RnA1d0d0YXk5R2xlM093?=
 =?utf-8?B?RnhOTWxvODcreXhLN3diMU1FRHJ2VzJJOXBVQmVmaTJoaDgrOVNkUzVHOVlV?=
 =?utf-8?B?MEJvakl6UElVQlRDS1JBZStvbVdrbDMzN0tmMjFtYmhoNFJycFpyU2ZFdVNr?=
 =?utf-8?B?OFdpR3BtOFIzbHZrdi83TGJLdGtCbWszODE1RXlvT3lsbzNFQ0ZTSkdQencw?=
 =?utf-8?B?WldCY1p3Q3NydCtQem9PeUZxOXJFL1FZc3NsOCtBQUJiU3lqdXAreFk5eHJX?=
 =?utf-8?B?ZFlkVVhHV0wzdFBrYnpwNUQ2c2E2QVVzazdFTzQ3NlJtZTNnVGxEelNNbEl2?=
 =?utf-8?B?K2p1ckF3bk5XWXozSnljRUdBdjdRUWg5Skh2blZGK3pYVTVidmk4UGV1ekcx?=
 =?utf-8?B?VFJZNTcvNHdGckNBMS84MnptbHA3d3dielp5UnNRUlpKcStsSDIxOXNWQXQ0?=
 =?utf-8?B?d3V3RjN1KzcwUG5RQjNaZXdPOWFRZlJGTDBlYk4wMzR5a29kMG1jVGQzUUwx?=
 =?utf-8?B?djEzOFNrenI2bWVpQzVaYlRPREd0WGZxbWhjMVFzT0RKQVFaQ3paUjNDZVp0?=
 =?utf-8?B?cFhJU0VLLzc5ZmNtajR3RmNFSExRK0VNSFNIYjdNMnNDbTlFZ1h3TTZveFpu?=
 =?utf-8?B?MDZuVDdCc1YvcUVBd0IwWFNZeGtXaGhKZkFqbHdOM1pESUZWTnNLRU5Lc1Rv?=
 =?utf-8?B?U09kYmRraVdkWHdpL3N3bml0WVRrbEh1TXhVVVdlN0ZLQWhvYzQ2TWUybllL?=
 =?utf-8?B?dFdXTVJWd2xiK2tjOWdxZE1LNC80YTQ1N3Y4aDRkSFhnL0NqS0xiZXA0N2NI?=
 =?utf-8?B?WDZ2NmJSTm9wUVcraFdEMWNvbHdiYU5TU0FteUpmditnOGUvcHg5TWdSemJE?=
 =?utf-8?B?Wk5Cb3JHbE45RjFrTThnYVJsd3NWaEZXNGY3UHQzbVRlZmdKY2J6ZnFjMTk4?=
 =?utf-8?B?M21BN1AzaXVEWnhxUTd6bXZnNi9hQ2JsbW84S3NmRzdpUVM3Kyt4YWxaYm1Z?=
 =?utf-8?B?anJReGNhSVlZS2dzNFNyYXpVYjRIK2dDeDE0RGFmNzBuTWZka1duM0cwYnAz?=
 =?utf-8?B?N1RnVkJpNEJHU2llU2w0M3FFdlRHOGMvQU1ER3lOWHdjQk4zTUwycCtCTTRz?=
 =?utf-8?B?YkJNT3p2NTU4MGRTRjg5d3RkTm10ekhqWXJuaE05djAzcE9zZlJMQnpSM0xi?=
 =?utf-8?B?MFh1cG1jVHRvMlppUDloOEZTZzVUZTNGTERUNGxzeXY5VFJsZUVsZHZRVlJw?=
 =?utf-8?B?NUhkTnhNdklWRUNic2hOZTJkbTJrcmtBaTdDNFZ6SkFjUHF2VGMzR3JnRTJY?=
 =?utf-8?B?T1pqNnFGcm1HTzNXQ29QQ3BHZE94cWVDWC8rSTBxSThQNzF1NE9NNUtrcjdD?=
 =?utf-8?B?a0VIQUd2R0xkV2ZFeWVjaGFlUWlDZmdaM09Hczl6YmUvTjJIdVFkaHErc1o1?=
 =?utf-8?Q?vAQPSH2RjqD+GABDYiKAdTH1pf3PDtWNMb4t9RY?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K3hqUVZFWnBPSkZQa0p2MGNpalZFLytIcnFBK0pyajE4Y3M2QUUwZ1lHQTh6?=
 =?utf-8?B?VkRmWXF0dEg1dUJHNUVKMDc2a1k0SGx2dWo3Qzl6dUVTMjRTeWlMRklWQ2ht?=
 =?utf-8?B?K3I1b0dseG5iQkZuVGl0ZUVhM0x3dFRqV0lKbW4rbFI3OTBkTzJvWTV5K1Z0?=
 =?utf-8?B?U1lOWTErTFRpRjN0RU1mKzVnNW4xY05YSFVRT3JvTnB6S3FHL2Q5bm5BSkt3?=
 =?utf-8?B?OWdxeVN3ZDU4QXFzMFdKSTdkTFRwaFpJNm5JaE5YQ1E2NmRaNHNRSDN4bnBl?=
 =?utf-8?B?OFhUSCt4ZElobHJRU3djN3RBN2p3ek9DYU1ZblhVVEhISklHVGVVcWVRTXlG?=
 =?utf-8?B?MDFkaklxMWF6R3A1dnl4Ymw4RzA4M0lhSHBYR201bTdRS21OL1o1NEN4SEo5?=
 =?utf-8?B?aEhodkVnMDVTcVRKd2ZCemdtWm5xbjVGb2FzbGNqNERtUnBqTnlrdUJUQWdj?=
 =?utf-8?B?VEhxeWx2ZTAxNTlKVW54elBUUGtJRVlXdE1xdm9xMUpYSWxXRFpQYU1jeU0r?=
 =?utf-8?B?YnN6R0U5aHVvaHlGdzJ0V1JVczFNalhBYXhsMnFpcTBxdSt6WmNUME5pVXF1?=
 =?utf-8?B?eDMwUk5kU0s5NUdwZ3AxUkdOamRZc05KS0txUFc0d2FqRUcxV2RRYjU0QUFB?=
 =?utf-8?B?ajVPUHpjQURQYjlpcFlMbUdPRjhiRVE1SXg1Qm5sSEVjeU92aHhidWlORUxp?=
 =?utf-8?B?djZMTTFUTTJWd2VEVHY1NGJtSFVpMlJZT1ZpNThDdXVyWWRXM25GM1NNQ1A0?=
 =?utf-8?B?bkRDVGdQMlFWbjVaUVV3c2ExckhJL1h5WmtnNHhZT1JDa1djdkRwaHBGY0ZH?=
 =?utf-8?B?NTBaR215UVg1Vm1UUGtnNDA2OVpId3lUUXV1amVld2FKUm8vN3pydmU5NkZr?=
 =?utf-8?B?SFFEenlTeDQycTZ4RXdQMExkcEZOejA1dE9BMkRjamtSRTkrMExjQTlwN1RV?=
 =?utf-8?B?UHQ0dGkxTWo4OGFSaW1mQjhLUUMvZHNyNUFmRzhEdm5NS0R0OVRLSjUrOUo1?=
 =?utf-8?B?U21WTmJDeUZEeXJBOUl4Q2ZEZFpzT1M4Q1BQUmY0R3dyWEwzcXdKc002bm1M?=
 =?utf-8?B?VkhHOVlVOG8vdTdhaGRpU0o3ak8vdytLM2N3Qy9raDhnTkhqTlF2a0lWUkVt?=
 =?utf-8?B?Z1hiUjYrWGNjUGFBT1JNclJFMVM2aXJWKzNXc2UycUV4TjdjZmJXYzNYTmNG?=
 =?utf-8?B?enBmZ1BCVmJJT2ozdWlKWVVLYjZSeVFaNXU3WUhra3hxNGhIRzFrOWJHandY?=
 =?utf-8?B?ckFmaHplNHpnVnh6UHJQK21XZ1ArTHFwaGRvWVZpQ3RZamIwRTZmRWZYcy9I?=
 =?utf-8?B?ZjJIQW1iRTd3RUtZNWdac1MvVUZNcTFJMzFCM3ZDMStTYVZsTllwbCswSjRx?=
 =?utf-8?B?ajZsejloZlRTMlRrYjlkMTlWSXVEM3JFVVlXMDB5NmNGSk4wSmZ3Mkw4TUlZ?=
 =?utf-8?B?OEdOcVV5aURPOS9zSk5xZ204K001SFoyU0Y1M3pyaENlOW85Um1PQWNsbFZ1?=
 =?utf-8?B?MHNieERvYjRaUHdzWGpKYjNBdVo4dUdZOFJNNXRBTzRXalNVS1BYVFZqYXp1?=
 =?utf-8?B?ZU1xNnFFZHNjSyt1QzJPNzRrd21hQ2tWQVJFMW9mRXljbXo0WkVlMWxvMTEv?=
 =?utf-8?B?TWhkc2Z2RVRncXJVbWszL0tEb1h0WkJ2UjNWTDM0OHRtOVpia2xKc2l5Z1Rr?=
 =?utf-8?B?VTBYeVg3RWRSdit2bnhqODY4c2dYS1pNL3UxM0xsQVJPaXRDTHV2UFVoNWty?=
 =?utf-8?Q?bS52P2dFX7V02IsxpPv6S5L/FuJ4QMnWe2WpBmp?=
X-OriginatorOrg: sct-15-20-8534-20-msonline-outlook-87dd8.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 844212ca-42b1-46ee-3b11-08de28aa0eba
X-MS-Exchange-CrossTenant-AuthSource: GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 02:59:59.4348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR8P195MB3355
X-Stat-Signature: tiujo7q6h9r4mnc6jyxoaoigpn9j6kmy
X-Rspam-User: 
X-Rspamd-Queue-Id: 05FE540009
X-Rspamd-Server: rspam10
X-HE-Tag: 1763694002-655722
X-HE-Meta: U2FsdGVkX19lJcZFIb/cOH4opXpD23rf1/wZ0HbTAcvlYrC/9EmkQqrXYJXPXb2cJijacd+PPIpRb42nzXYNa9qiLwxKjSBWJbbDocaU0DEbttO4ynkWyXVAe3LXggo91V0dx+uz2qOrkMTVvQ12Bdk4p2WGZ/GNZJSwJWZfWgJxIuVZvSzxxuTFfIK+pM32VT46OyYQJLc0ZD8l/Jov54jKv28wXL1HNrUoABJJAKE4fFmYJS6xcUrWqGssqZ5mTbuVFe7hSjfc/ggpbXJHW3zS4vCysg8AeMpHWkRd3SrrjwOnPS8nQyACTyjDpJnOqxqDNjqVwTAPxeCIXxc60ggdFvJKZm64iMqYFHP5iHlkiWXq+5ICAbYR2Q7tXg30YpS/q0WztUP5BfL69If86nfu87ziYxjIA3iHKwA/RxfKVGs2T4x7QvjHK9hrkElBZi0doUHWXd+V+joXUczScDQVRdbmc7+CfkiKo7/sgsEA9Y+svgNnjhk/InRs/fm/NTOxYD/tMAjJvmOLT5BtFwkarP5/OSJosQ0xf8GKQn0jE8pPOi50DJhQzQSKXJ/2sXxBIv6LIQTbhU9ZiEWdmUkdmXemF2JAvH8rMpNUfBerhmxHO4PDU0A4uJm/JIc1u2Us4D2fmPncn8sJQZUuzq1MVSidJsjSpNMj5BWV/eXiisqvRMaknvCKjeQER3ELTNgCqqEygt8nzVXBbrDNRlNsVZno4LgW8+nL1D88xQS3YiECYK+0YVDEXeEws5QuzyxynUM7zYY2w9fx4uj9zhSpoHrjCfkN4uWVwo+KjRwegGi0fDoMyvT69XFLahgqGO6afxdK/FsfgG6YdDFpU4CPZLTkIjW4sOk7LzPlmacTxt5tKpqUhx7Yr6EX9kyd/twfiCGuRjMAvHKlc8jnd1HV75JFizVucRjWU/Cr4NWfTdYmfhDa75mS1WWOPubTUjP+0UHHbv/Zpld6F7B
 sVllf1GS
 GzLgvEhm03WUvfuO83icti8T7Annsa2tNe1ffIv84HAutDb/xzuIqhq0S+/Aco7vNhWRHqj2FU4wAP6L7CE+ECXSa3OU6mstE90WyXLpw+Lcg90Ru6Nu/jznOa6SOAB5D3tcxDqLCggZPgiFKWxR0JKkRBiluxFwkVl1M5RQ3VY0KeZIYgPOz6U4TIzl6w7JbDBSEsuj8pcsagzihjm5G7rK+82fNYwIUiudEtCRmHPchKGe4yMfjRvZ+ZiYgVlWYB5HbXtGeGwjyDy4OUJghSRx3O+cvGvN9mQPrUTfCNelW/h+jiGN60+UIiusZG8rc3EpwcNIzlCz4LDsLiRGLyEgBbqy/X0FfqOoNTf+Oa3qsADr31rlXf7l1sDgufdhbmG+4XVsuUeKXcPw/sYgN3OAHIhxwclOYmz44WV2E73zoeS+qfVuAX8NQV4t0t/pzEviBmutuxxFk/6QhI7CWplgFFpNKCW0s73pObXv32maSk7FcuHQenNTn82SUyR8AdDTrDXMTMKYz4F+i1qnLcxUzd2smTT8fI2E0ueZGku0EsGIhcs16Q5etQE9rp9npmRLX6VoXkwfdBZQ5/PWcrRWjjr55jXFFsYzGCRg3ne0DNEXWiBbS02jlJGuLUh7siacfUpAG1kj2oHdmKY9talnA07hJMrSAoJVcJxLCl9Q7m22vsG8lvGIsCutPu59QVrASBMvG3SuNpBbtqlBYaUCyrEVoReBPviQ+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Eric,

thanks for you valuable input on the topic.

On 11/21/25 00:50, Eric W. Biederman wrote:
> "Eric W. Biederman" <ebiederm@xmission.com> writes:
> 
>> Instead of computing the new cred before we pass the point of no
>> return compute the new cred just before we use it.
>>
>> This allows the removal of fs_struct->in_exec and cred_guard_mutex.
>>
>> I am not certain why we wanted to compute the cred for the new
>> executable so early.  Perhaps I missed something but I did not see any
>> common errors being signaled.   So I don't think we loose anything by
>> computing the new cred later.
> 
> I should add that the permission checks happen in open_exec,
> everything that follows credential wise is just about representing in
> struct cred the credentials the new executable will have.
> 
> So I am really at a loss why we have had this complicated way of
> computing of computed the credentials all of these years full of
> time of check to time of use problems.
> 

Well, I think I see a problem with your patch:

When the security engine gets the LSM_UNSAFE_PTRACE flag, it might
e.g. return -EPERM in bprm_creds_for_exec in the apparmor, selinux
or the smack security engines at least.  Previously that callback
was called before the point of no return, and the return code should
be returned as a return code the the caller of execve.  But if we move
that check after the point of no return, the caller will get killed
due to the failed security check.

Or did I miss something?


Thanks
Bernd.

> Eric


