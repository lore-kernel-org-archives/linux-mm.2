Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F079FEFB7F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:01:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A9616B00A2; Fri, 27 Feb 2026 14:01:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66A136B00A7; Fri, 27 Feb 2026 14:01:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5258E6B00AB; Fri, 27 Feb 2026 14:01:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A38A6B00A2
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:01:46 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B2C6013BCA2
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:01:45 +0000 (UTC)
X-FDA: 84491155770.11.B14CC98
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022094.outbound.protection.outlook.com [40.107.193.94])
	by imf07.hostedemail.com (Postfix) with ESMTP id D33714001D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:01:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=RE5ahWBW;
	spf=pass (imf07.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.94 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772218903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dk29SJfpJGFgRzCY4PLuyyiHP3wfz8v8GzH3ejR7jAg=;
	b=3k57MIp/tkALkJkg6JsyOIhlejVf+Mo0h92wAXWo2o2Vne3Pm9u2iwbzzaB+BiaKwPhyzF
	05qOGCsJ2rFaqatCP3s3Xjf+G8u3EfFlswo7E40Z5FydOQSrqml8KYbCq70Ow03Qs+H29T
	DwCBsCeFU77xaP7qOhok9L3OnGVOhFg=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=RE5ahWBW;
	spf=pass (imf07.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.94 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772218903; a=rsa-sha256;
	cv=pass;
	b=vW1UQHnlGVTsI9WI7XKvZ1vhFUzYKhK6Ox8AxR8JkQRg+Ia+y89jheQPcVu544zdo9oca4
	A/JAwGTyNIn25weyGwRdSJtu9cW34JubcEhOAgU0BD2gdKVhruW4hknfcp+KqLV+XOCYoO
	vR5G+YUS+cHvIPQE+ph1riPdDPlhQgU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YyWwHYXaVOptQRjpaDCuF4hX/enC3EN1ccyldunU2wcevIBwMn9BnOGxGD2tx6mNv2iDEfk53Wkb+mXDN6Wy1RRTfBXh05wOgeNkmYt3e+eOWyUhal8NMrjmlic+zvb9MjpNgRN6zV2ix8G3mGzzkKp9UIE3S8+g5ZOTeIUlnwdhSnjTZh0OpOo+HF45xYcoJ08qgzDL8K8x07DVajgNSAUGcGl83azMyTH2jMTbtcPaeWpW9LFyU/rFSzWixvxi0sdePJRrTFKDEPGkrJybWd9BQEUJdMXTYcQupc6NcTNKlhsb8aFscFJ4g7suzdjyHzXvi1epNRTS46558UCwpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dk29SJfpJGFgRzCY4PLuyyiHP3wfz8v8GzH3ejR7jAg=;
 b=T/5vtpzi65/kGBQeFBOb1FizZ5xT99Epgu0mbyUUbqjynBQknAe1BiYJ1tIT0APElGf/6Qz2Tlu05gkDD3WHqUBMFfW7OmX1V4rMzQKSvykSY9dlQ2Nw23aR8bDSpLJje0huzK4J4iMVlvk7P6Jdoi1SiUFCCIkOThQwG1FVGs21u9DCLttv7j5sXbuklzS+wsIGTD4ZcEVIWbnj9bJ3DfMoAvP6+E3o5uVfIJS4OTPVUDbVdMn8zu2k9zQwBIMf1rDn4/rVRVCej+upBRGxFTuruchoLY5AU2+RKBKGnseXTaqMhhD8d4WK9OHld9/TFl3BcRLeqsQaKMEgdaxIWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dk29SJfpJGFgRzCY4PLuyyiHP3wfz8v8GzH3ejR7jAg=;
 b=RE5ahWBWyrGgAr1sG7157mWsSYBEmmBEnr7QZWJmeZoxo07+7Wmsur2peObaGSX2ionx0Os9kpbDaookJJtmUDDy2fzm+/kNnTT+f/sqpNrUWdNEZXJJL9Jsymke28jJ4T9AFgOo6v0bW94a5FL3D8qALq2+Fcpk3s/nsUZ1ndql+tEcOrOGxuMwjm2bjbybwp3NiS18loGQQr1D0Ntikr/JBB20P1mLVqoNIMR5dT+ABqPDsYrLSmVDcvhuazN9ruHa078fP/fMaK368bO3o+4pGmy6eQ9x0nmNOEiqdjoJieszjoSJbQmXQRuZ8tzAAurF5kCVbC+/0AjVZ7gpbg==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YQ1PR01MB11446.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:c1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Fri, 27 Feb
 2026 19:01:37 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%3]) with mapi id 15.20.9654.015; Fri, 27 Feb 2026
 19:01:36 +0000
Message-ID: <b808e186-3eeb-46ed-9826-b0ae6cdcdb8b@efficios.com>
Date: Fri, 27 Feb 2026 14:01:25 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/61] vfs: change inode->i_ino from unsigned long to u64
To: Jeff Layton <jlayton@kernel.org>, Matthew Wilcox <willy@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
 Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, David Howells <dhowells@redhat.com>,
 Paulo Alcantara <pc@manguebit.org>, Andreas Dilger
 <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
 Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,
 Tom Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Bharath SM
 <bharathsm@microsoft.com>, Alexander Aring <alex.aring@gmail.com>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>,
 David Sterba <dsterba@suse.com>, Marc Dionne <marc.dionne@auristor.com>,
 Ian Kent <raven@themaw.net>, Luis de Bethencourt <luisbg@kernel.org>,
 Salah Triki <salah.triki@gmail.com>,
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
 Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
 Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>,
 Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@infradead.org>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Yangtao Li <frank.li@vivo.com>,
 Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
 David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>,
 Dave Kleikamp <shaggy@kernel.org>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall
 <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>,
 Zhihao Cheng <chengzhihao1@huawei.com>, Damien Le Moal <dlemoal@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>,
 John Johansen <john.johansen@canonical.com>, Paul Moore
 <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>,
 Roberto Sassu <roberto.sassu@huawei.com>,
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>,
 Casey Schaufler <casey@schaufler-ca.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Sumit Semwal <sumit.semwal@linaro.org>, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S. Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, "Darrick J. Wong" <djwong@kernel.org>,
 Martin Schiller <ms@dev.tdt.de>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, fsverity@lists.linux.dev, linux-mm@kvack.org,
 netfs@lists.linux.dev, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-nilfs@vger.kernel.org, v9fs@lists.linux.dev,
 linux-afs@lists.infradead.org, autofs@vger.kernel.org,
 ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu,
 ecryptfs@vger.kernel.org, linux-mtd@lists.infradead.org,
 jfs-discussion@lists.sourceforge.net, ntfs3@lists.linux.dev,
 ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org,
 linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 selinux@vger.kernel.org, amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-hams@vger.kernel.org,
 linux-x25@vger.kernel.org
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
 <aaB5lgKd8FOIizPg@casper.infradead.org>
 <4a462d40899698586c110add96ce3fab6ddac30b.camel@kernel.org>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <4a462d40899698586c110add96ce3fab6ddac30b.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4PR01CA0096.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ff::13) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YQ1PR01MB11446:EE_
X-MS-Office365-Filtering-Correlation-Id: d47bfdf5-e3c5-40d3-8017-08de7632a081
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	EY5Md8YGJJIuzUva9Rf1G3srlPfJ5z4HLDU6C28LTRbhf3S6k+BFTAgq/Uj3DeAKWxjHXSRUJ3gWvR9+H8pmPkJM+6uucug3fgz6+OSzVebBsXgFLIEdolRXYlAJa/tfXD0GDY6CPY00XUEby3BNWa3oEYAvKV6x1O+HT39G3mfrOeFNbIsisjN6kW1FDRI37V9NxrGtMS6ym/l5L0OuMDlQdeofrJksRx2JGYHieHYV6tstWrSpduIm4wJU55wk8eG4Y5gLGYkTeVVTXI7fxkW/Qm4+BO/o+eSAdyo5f6HXZtAUxCYqHFwWqcH83Ds7ek0iedsiYntL1PyL/q7ogdDfnHRANarXn8RwmRXSub0BC7XfsSN4xJWSa98OHzdiLHIJJucQFYYm2dM2KoPVPf+02lUhjUllo9S0nu+tKlgr1cykR3yatmYz4Tc6+N5SsWXdY+4ZKhIDmaGzvL+lJ4o8l3T7sPuHxKexmgIIDCDUr4ncdJSKp4T7v386CeuGWnbZRN9Ni9Razm7gj1TN9n7YulxgaC9Y70JJNwFaP+NxaPz9NezUrvwST3ExKfGEshqKR3Gk0WoJQncvCrdNFJrc7bTXhFCxkM043XpimNHjrcJwuHBVOhHY6vH3pbNFYF//dn6hsV3mxzb47wcvsDRk4++7MFAj7Fi7EO7E8SEnWmxVEgxU/J1UgxKQtJQr
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dTNML0R3RmJSb2FhSmRmUlF1aC9FelFaU2ppWFBTN3ZUOTQrRFpoLytyM05q?=
 =?utf-8?B?T242Vlg5MUpZMnZpYVVjMGFsU0Z1SVhrWStxKzJwRVFyWlpYT3VEYzk2RGN4?=
 =?utf-8?B?eUMrSDlaeHJNRUNLb1pBbzFxbitUNVUwOHIvc3UyQzFpWk5KYlBveDdSTFBU?=
 =?utf-8?B?Y21YMnc0eHl2Wi8xZXNZYnR1VDc5UG9WU0I5YnBYd295ZHBBM3BzQTk4M202?=
 =?utf-8?B?cnk2QjRCM2oyWmpmK24wMjFIWUp1TTNCeW9EbmFuL3U4bUNQbTVEZ0tVYlk4?=
 =?utf-8?B?Q0hEZUNmK3dGMEsvamdQTmdXekpnN2xyMGw0azNIcDI2ditWQml5dkJzZDhl?=
 =?utf-8?B?emQ3cW1jY3ZFS1dQNThwdTJ6bExURk1pd0FjQ1FrSzdIdjhTeG85K2JkdWhK?=
 =?utf-8?B?bFFDUXFNVVdibG1PY0hCNVZQVVZDaVBRUSszZ210TzhEdWg2b0NLOUZObGZs?=
 =?utf-8?B?aEo1d0p4NG1aaDB0YTRVSG03VFpXL05UZ0VQWWU4NUpSblNNQUw4OXdsZUhZ?=
 =?utf-8?B?Szl5elZnZDBTdWxtUnFmQW9GUkFyTnNsS0xUR3o5cGw3ekwyZU5NSFVUN2pE?=
 =?utf-8?B?aGdLaEVaclcxQUpVam1TaC9BRXRBOElzRDJvK3hhTithSTByeWVvNSs2SVk0?=
 =?utf-8?B?UVdkcTJ4Uzdrb1dtSFFZMHV6aUVBb25wRnVYMTRiNHQzQzZVVS91Y0MvcnZH?=
 =?utf-8?B?Um05L2tTZlBaUXdTVkZJUW52UmtaV3ZweGZyZ3lwTGNuZmF4d2U5cEp1aHBT?=
 =?utf-8?B?QzY0OU5nazBSN3JNdGpiMEtYU3MyYmZ6TEg3R0c5WHdCMXhGVkdyYkFGMlUz?=
 =?utf-8?B?OGVCRXNwN1R4ZTJyRjVwZ1JxR1V1clJSeVNtdFhIM295d2tUaGVLZTdIc05o?=
 =?utf-8?B?aVd1TTVPR1FnTWtuS1EwbkI5Q0RmTHgxZDJzU1NwdFVHcTY2TG1OamM5a09D?=
 =?utf-8?B?RWJtSDlPbEpXVm1wRmxTUVFRT0lFMk1FNm1acjBxajFrQjRXVVFuTUh3dHZu?=
 =?utf-8?B?d1N3NDBKOFBWYUtkbHdSbWEvTjQ4TFVtV1VjWitQa2xWelU2VmZtMkluVngx?=
 =?utf-8?B?R0tZRGoxQzJ4SjljMHE3UTBQY1JCM2ZaSWNlRHB2TEo1OHFBRWg4ajdVdFJ0?=
 =?utf-8?B?UUJudzZEMHJXM1RaWFJsTnpXdis0YU50MWhMdDFXQ2JWbmQzMC9sY3JmSnVT?=
 =?utf-8?B?MUwrRDRLcU93NEpXMFBESUE5T2ttMzB4QjhTTHF1UFVWa01IWEJaSDV2UWRH?=
 =?utf-8?B?MGtFaEloTlpZRkY1di9Jb1Z1Y2cxWHhEbnRyNGtMdURrVkFBQ2FDV01sS1lY?=
 =?utf-8?B?TEF2YUsrTXJ1eVNPVlBBYmczc3VrK3o2ZDJ0aFpqSlZMOHJMck9Hb2hsMWVE?=
 =?utf-8?B?RGxBWnNUQ1M0SlQxZWJqNVBLRTFVeXJYYmw4QlR5RzNqRGxHTFB2a21xU2Fj?=
 =?utf-8?B?RzQrakhPTXlGcVVUSGZSL0U5Nm1DUDlUVTQ0dDRIcStxaU9kbnVRcUxUb2Fp?=
 =?utf-8?B?S0dDRHI5K1BrU3FoOGRkQUJ5ZG1uNEhiandXbjlsNzVDSlQ1TVk3WVo3YnBW?=
 =?utf-8?B?UzJ0bStQV1NsQnVjSXJscURubG95M1VGYmVlRDB5V2dXVVh6Y0ZUZUVrd0hz?=
 =?utf-8?B?QUN4cGwxdTUwdjl5R3lDRUNSaHlibzdCVzlQMXp3MEQzVE5jbjJmSmNONkRm?=
 =?utf-8?B?cjJ4QmZxSHhrWUxBRThYYjIyNWpwejl2SUN5QVp2dGIxTzZ5dW1TZzBBOXhj?=
 =?utf-8?B?NW5PMGtqZ24weUs0QTJjdFNrLzJrd1VETFNlUHlGY2ZwQ0ZzZW5wVWhaVFkw?=
 =?utf-8?B?d2p1S3Y2dnNKYlF0SXNab2tOTy91OUNaYnlIZWVUVjBvME9iU1FIc3ZuYmJT?=
 =?utf-8?B?NDF2Z2EyZkpnUVd2T09OYld1cjAzQmNjTHFIaHl4MkIwL1FhMGx1b1liUm5F?=
 =?utf-8?B?VStJcFVQbVB6ais2UjlCZ2tnSVZsd3RKWjhlUU8va1RDcGF4cDA3Wjd5a25U?=
 =?utf-8?B?c3hhcUpvY0t0bXZBbVdvQm51ckRpTVcyUk14T3NBdnRUNHowVzNPNHlhdmJO?=
 =?utf-8?B?SEZYL3NTM1ZyZGlzYVUzR1BkNmtOVkhoNzNQTU1VbDd4MGZVWlFwTGtOK1pw?=
 =?utf-8?B?NWtrL3NNcVVnUGVCQldkcGl1Sm1mSTFLMTdkWFdkRkZBS3g3QTAyK0Qydit3?=
 =?utf-8?B?MVpTWWFLSHRXRDZoUXBqNC9aK1hZTm5JMk4rbEVNR0ljZ3N0cm50TmNyb1NU?=
 =?utf-8?B?N3g5SCswVUUvcnhobzdVYllrQlhqR2JvUjJBTzRTQzN6NlExSkp3cjM4RjNC?=
 =?utf-8?B?Zk9zQWY5anI1ZkVqR1M2b1F0dE9POEpLay9jakFKR3UwZlVCVlh2UHNiKzZR?=
 =?utf-8?Q?lCpXuAN1+w3tLwc4=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d47bfdf5-e3c5-40d3-8017-08de7632a081
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 19:01:35.6014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4N2/gZXBOwu3d4VpitFMRZidRWQIRoSaCdC/f2/Xt4bR8UjH6GueZon/NbacX7XPHqlUxfYPoxzUF4l4veiYQEGXWzrhYaUYiwshNafmDIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQ1PR01MB11446
X-Rspamd-Queue-Id: D33714001D
X-Stat-Signature: t6dbmeefzztucbz5gud1inqg8frtz64y
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772218902-896075
X-HE-Meta: U2FsdGVkX1+Dip4Aa/XaLpU+SRY/ClXczhqGno1paSnNy11yWwqJNh8e1OcUyHTb2HbuW0IIl599yJbRtPA+RMzl4Gf3UXxmndCAWcvEval3/eV/8yEF5glEI6+w/DUxPNHSqsEgM1MXBRqHTc9t8FCA09vvwqMOx4x3ODN4f/wqeVYkEaZSQLqYFdA+/T1JEXCZCLp/Pgsd/1DQ09zfc4Tlin7+A2+ta9icyac9tFiaZku0IOS50lpZOnvf+bCGpYueNhOjWFVw0rSN7nTLIoLG6P38r1JjYLxhlB7FB95Vn+dUL/pbJif7vLz3TdZ5+fTWM+ogcF6aKG0hcKet9oo39CYUSu+V8WD5Es+2M/NxM054U8H7E/wymYjQQYlH2Dh5fyRzFDPeRIHX6vMYrcQwRsepaw3vIzEW7mHP/rEKSFMzWHPLv15Vr9PnH1O78m3DiojodegiL6fVFNcQD79lgfWAdN2T3546DV58SP/dcZJYYgRZ86898E6kam7xSZKRJ0uNdLKaW2HEsQhxx8Zu3is6GsDaqVJG/C3IvU7XNvDENq07w6EMwpU/ktPgUyc1Vf7HLXhKcWkk39xxI5A+2/hFuwra35PXQTL95Fq/vWeO7YMaG9n4PHlT+FdVn3wwhndFTKzqDFhw6XLaPWYtjeIwe0+VcNxSar6HUu703VQi3019Iv93uGbsKUtenJAakOI5NVMuMSWxidwgzMzkO9B9HITImS9Y97Pq2iUeoC1yDxU4eUk66nuVLy9dtlJX1TzvfEADScAWNz8g+wuvGwTp39sLZ8BeA7ZhWW+HUcc/BNK0tUqWzEP2t0vaq42uh0OVRgs5DwoDYhCbJtzf/CpoMGn94tvSpeMRwXeZN3g2saZuY25AIGYZY+3selsM6p+DCAuNEC0BPBXdQ/HZlKSdMPW65z2UAG4Raz4bfsBB0ZQNhEqI/xxfwY/7x9DXXlAGwqLZ9xQuhUD
 9Z/TiU0K
 m+lDlA5/koY9Dh+GgXjsYlb8W7D1WkLWK/wjq3zIaOt14hmlxghvUHt5xqyOe+yE0+mRppvPTzb2BCuBx0WKKbQVVZzJQJQVmtFRRMm+toihGhxI7kP+bDJ+OVh1gUfrv6a8FZtQlXkAa2HyqnSvKsrsHFXo78TqREYxXU8SqCsK8VAmpMnHFxapyy9lQnKT6AzlBjWN3K76/ohiKKcjFUgYEwEGrrFhSNKdJTeENtNMe2gWF/kXdjBFM6kAkrtr482+kH4QdE5b5Bvi7h9u+XhAPqvjwJb9s8CRrO820e9dLZpODbsW2jWPTVhGY5wIPYqIaPzbahjMz6EiPtGuSVWvX8ZFfpcI5mY3CzztbIvukhj2/lyWSRoWhZxubOddC5Nqwbfku1Ek3P7GEYZaeExrMGSSuERlZAreO5MQa8mk18reX7HpPNfqK3R+StTVjKSgQmZFWcJDmWLnQdy/DpQsaKnAGIkjZNVv96WxdDFdEod1FPiD1fveSBmPdCyPWKjS+B7K04fAHR47n65YmtY8C/CVVUSk298SS6VH7wdYWb6MXPsi5huQ2fQJTWj50qn6Qzqoet3dhQ6MHpK4jryRi8rodrGG5oPegmgfJ6ivJoA1JIecvG6GClJ0zzWQ7Qd+Q00NDvXlndp9M0eRRoKvF4oU0fTZQAExnySCmpmLfjWKy2q1b+F5a6X4i84yJ3aJcIGCXAgVBnmXshRaP4YYld/BBD78uUQTWl8JtGmjb9biYy/MtG1vANMYdv2t1pUOjSPY6q0hBkNmG7YBdIa5PM28nCZ9jXnv2uu8uOmhMuS54Mu77kaVdq/QvJHvOQrUbHYxIYQPrCxVGbtz/9yJU9z5Spx2L3nhHZbVXqfX5OAPq/ztgUzz0rKaEHvCFYNeynlhAnx9PWkTfGv0VWssahcI4oDPKclNhPFaR16X3emSFKH4XeinHdl2kcAqNvo3YARfWA1sFFSziiHIAb+9An6Ha
 kE376Da1
 Q/aS175RbtKt6//3L4DiR5l5MerMovqV7WeKyI9g3jV2s5gD6Pph7CrbOkjRe9YQ5W6gJsWYeHoTEfgHkdBghb0noci3Ui8GtB2ydrHY8fX6FKwAQUosN6M85HPsNmRot1hhDFu737yDjhijB01g+1Lj139XZEYR1TiALeQDeoiynxkCBQpMdxigUzGTIghIBlIDhXSfqXbeRFndLecojufXIjXhjR43aGMFAdfClWvrRkCcpZi4qPF0K8Zu1z1PvRBCAe8TFMi447hj97FzDiQFacXqL37WazxmjrkSeojz53tG9pdlHd+e+VtHcvh0JkjLh7hliSqY/u/NPVUjHbvzKMldnmVfYnI0IjZ1pvsnnoVDa8b8yaDSYLCTwiC4MTHN/87ICXs0GOXmvhK7sqPK86ZD9q/oi91RIJ0DgBMDCdfGOE0sskkgm+w74TgmbCCH68kFbJYn0IYi4e1GPdtEkJsM0eFac6CVOOuhUIZQlr2v3RDWp2apPzwvKa411wG9rN7Vf/gsJ0yORuwtDJs4wirvzAEEWFSZtuGIv4n4TQmFCEH1NFlkLDvPteeARbbPw9qTBT8xc5h5e03PXaRmiGKwiQxJkbFl07k7KmiZQUD4ijW32BrAlVCeJHSUWsTU5t1q0QXbWn5DVV3p8UI+nJFAgh6efUI0UduS1c90jI9auu0CQs0xINX8/dg8efuy/lkN9uSigwUEKbe6O6Mj1JeF7Gk+wkXvzEG/UIaCl4XGqgq3g7zyms8BUyI76vJYulCWsMbXtcHnHOW0OPUl6qx9SkTUtKO7mnLlvQbOHdc0ChIxaTrszYC2cPWB0xrRYnhTcOx3iyUjEAxR9AREnf1OJbxOL87u4D6oOtNJVOzcyblEZ3zkEW4gC2RfNq2Yx5T5TzhyxFfgdFFeC4hiL6AYsFLy8wnwlmQQUj7Ww36H18DEnIZeBdrtn6Ypim2CdkN/Wy0c9w0H122is/zfvm35l
 5AbCA5uW
 pATiOpndpxtXoWfmZhM/ryyqrPMayDR25NkledMoMBCuDzxNHQDmndhK5cB0vCrITmPnRdQEcJV39EOGxKOYOwIm9Uo4zcTEYd9j0I6t0IQWZNIDjqQFnzTIJvP1+8BXu1tLsycWioZ0HO4axbCwGCgl484ktTDyXWOUiAwr3cx1K1GcjANcQv4zH9SyxGrItulayei8Ag0Xd1o0emxbBkbky4ystQnGfH5BfjK1NgzzTaAifYIj/5S1jWeoU7wGnHMzPqR+1RTd+vbRDx09X2TBbl0DevI5Ra4j4TYov6ciJo3nbQgDkjhnfDfLOfTLBeWD6U27F8Z6G3BCuYGGJ4MhQX6PvHVHbmrXZZuid2mmf5dBP4LGpvxd/DPuBIGoHNq7O98uY3LtqslJDCssNxzOl0IeRUMBSvH0mnHYKngdbgobUJSXt+DO/m7OGNdo7S9D6v8P8ouWXqHkdFHmD46hok/k+nMRr4JZkApIM8fp5R633VacFx0XH5XmGme+XwfLjOTiW+hCYVjaOuXsq/DG0qTCoNJAuwuc0JDxAmxhJFaqGLsD9UNktGvWzeXAfcVcH4UqdlSeypspFGMtkfbJYHMEeF2X7qIXVLPuR1gNGk+LiVElnjjafd077VIeZjhYixK74AMCTHlQ9SCCQk4k5gmDfQG8GovCiFe6FLVSU5NrGA9cq0Mql7nEBCBROw1HO2d2WBCZtw6122aY/WyJDHA1js0m1So3mnSBmw657PUsBVaZ9pNd76OnxlBLIz7xkQZXRKnH9IiWtSGqYnSAYPoqmyEBItkaKdpcylN6kGjAi+ikutixGzcsnG2uroFY8CpS54aciJTSVdb1PxE7ux8HDmK0cKOx3D5Z/4ujUEuGRYzGQiLmEg7TQZ2FgPBbtUxAlObqn6Ydlu5qq30xGmpnYZVd1YMHnNpVKAq6KoPukZ21w6/FWfn9jJxR5sbSz0jvevWNTE4Et5ANbtcVhXwhg
 lC67694w
 FjqM+lwpH9p17HfjuKcES2y3NEMJJagtM49XmSKH0OJlghSUPOMqqNcS7dBkdqKJ07604tnJcqIzB4pmwpK+3G3D9OXXqBIFkiM2siOgIyt05WvcMKofJVZ0gXDEOuwK6KucTldnJAlyudAp/QkAXf/OczUAhofb4yJ1tAoBswvCXMFA2qDk+X+NZnXfRqbVEi5uba3v41iCxp6icKWrXBSSw7BG/3Oe7mCraxEhBejmY/4Fq6Bjxp+/GP/3242G/WNQlD5u9a/G+YuWU8RlbjJvAhrI1Mk7Jbv8GIeCGOy6rxw+0GhiZMg6ejctacnZ7ajkxo8U6/F8kPnJp88VZbxveQYQ0eDJyA82pRKle1389fk6U39eZOry3xNH9BhcZeCsV8gAtTHBWFEEhGsJTcZZxk06Q9NJ2iykM2T7xNpURAca8fFe8+XqpzPjwJ388v6ksnozUe4cZIIXgxNyZJv3mBUw9cHXB/XQZ7fUsuPG1xeOlLHInQRtrkKbWUvpCBdrDgar/ndxlIVq6o924zbYrQ4pqLVuapLcojiHe31pivzLykdabyw7fsFSwEMX2CSWwEJZ8QrDiHuti4+m6gc78vkWUWbIf2q5RNkUlsRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-27 12:19, Jeff Layton wrote:
> On Thu, 2026-02-26 at 16:49 +0000, Matthew Wilcox wrote:
>> On Thu, Feb 26, 2026 at 10:55:02AM -0500, Jeff Layton wrote:
>>> The bulk of the changes are to format strings and tracepoints, since the
>>> kernel itself doesn't care that much about the i_ino field. The first
>>> patch changes some vfs function arguments, so check that one out
>>> carefully.
>>
>> Why are the format strings all done as separate patches?  Don't we get
>> bisection hazards by splitting it apart this way?
> 
> Circling back to this...
> 
> I have a v2 series (~107 patches) that I'm testing now that does this
> more bisectably with the typedef and macro scaffolding that Mathieu
> suggested. I'll probably send it early next week.
> 
> I had done it this way originally since I figured it was best to break
> this up by subsystem. Should I continue with this series as a set of
> patches broken up this way, or is it preferable to combine the pile of
> format changes into fewer patches?

Here is the approach I would recommend to maximize signal over noise
for the follow up email thread discussions:

Now that your series is bisectable, you could post a [RFC PATCH v2]
series with the following:

- Patch 00 introduces the series, points to your git branch implementing
   the whole series,
- The first few patches introduce the new type (kino_t) and macro to
   do the format string transition. Initially kino_t would typedef to
   unsigned long (no changes).
- Followed by patches implementing the type + format string changes for
   a few key subsystems.
- The final patch would change kino_t and the format string macro to
   64-bit integers.

Once everyone agree on those core changes, you could proceed to post
patches that change additional subsystems in a subsequent round.

One more comment: have you tried using Coccinelle to do this kind of
semantic code change ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

