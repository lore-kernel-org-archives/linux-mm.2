Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A14BFFD7F95
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 11:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BCE46B0005; Fri, 27 Feb 2026 06:56:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 040516B0088; Fri, 27 Feb 2026 06:56:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD87E6B0093; Fri, 27 Feb 2026 06:56:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C11876B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:56:12 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 503FB13B591
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:56:12 +0000 (UTC)
X-FDA: 84490083384.15.6E0AD72
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4F6B540005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:56:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=wdc.com header.s=dkim.wdc.com header.b="ChI/j5rI";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.s=selector2-sharedspace-onmicrosoft-com header.b=GH8Eijfu;
	spf=pass (imf01.hostedemail.com: domain of "prvs=511e685e4=Johannes.Thumshirn@wdc.com" designates 68.232.141.245 as permitted sender) smtp.mailfrom="prvs=511e685e4=Johannes.Thumshirn@wdc.com";
	dmarc=pass (policy=quarantine) header.from=wdc.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772193368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
	b=A/664gsoDu1HDyEEZIys5FD8dZT79LCMN8t783xKu5K85T3z2dZqAg0UdbyEWPdfnl272z
	YfhxXUdkSJvhjelZWF/4mBIT4anNKlEg63ihFbUMJ4neaHwvrryU70kBOHcKuSwgzgmZDC
	OKs/JxUEKj6Cr1QyBNxXRYmZwSh4VSc=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=wdc.com header.s=dkim.wdc.com header.b="ChI/j5rI";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.s=selector2-sharedspace-onmicrosoft-com header.b=GH8Eijfu;
	spf=pass (imf01.hostedemail.com: domain of "prvs=511e685e4=Johannes.Thumshirn@wdc.com" designates 68.232.141.245 as permitted sender) smtp.mailfrom="prvs=511e685e4=Johannes.Thumshirn@wdc.com";
	dmarc=pass (policy=quarantine) header.from=wdc.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772193368; a=rsa-sha256;
	cv=pass;
	b=v1DYGBhoDr3MsH5UNsFP4bAofa5l9VT7NLhYXuWDh/CVkVooNvXkigiDwDjhdbl48WC7j0
	NwMC8itiB6Y0vZfNB8pzMHz7cwfOyJQv1sYj83IiNgg+yr+mZ1rhoQcTeqGMYWNcYlqhA+
	htzRtkHyohsSCxE9qAHU59BjTqkePgE=
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772193368; x=1803729368;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
  b=ChI/j5rICB+ka1jQg2J8pLWy6FsOHCigXahtv+/xv7h2jRrP3MxC/7Qv
   OxjbN/mmkonlbSC79S6LIpbyUWpJ9jBK+qFtCrExxGfX1AL2ZtaIi/yLh
   mX2YE/Szu5Wtky8N/1NzX9eXFKhIBeaQ+pRCKyFTHOaNIEztGawKUHhac
   sE9YJgWM4eyTbB35M4wPRcbbwG5SEQTjcGYUprgsl37XPWjyk9mUf6SQa
   ixL2A7XxjjB0oMgzd7zFjzJoojxN8cr6yrVN2c6zzi/bLFjBn25YbAsr+
   CoyUzs5e1wvlCDTrqnQL+PVpukLGEosFB+5eI1446A2uQmDaZsenPBqGH
   w==;
X-CSE-ConnectionGUID: CeynFEfXQyy4D20d5rO42g==
X-CSE-MsgGUID: UVWj+PIHTVqx+QVX6Yq93Q==
X-IronPort-AV: E=Sophos;i="6.21,314,1763395200"; 
   d="scan'208";a="141588070"
Received: from mail-centralusazon11010033.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([52.101.61.33])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Feb 2026 19:55:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hSujrcv8UkoMPULsgkLclhILgfgtZeCeGnKR4YUAVoELXAVzOJRFmlaHoPHMtl2ZO13TgtPoD8b+nctlcoRdnlJcSd3X14iCg6kHv4Gfpc+Zc1OBWcEmnPblM01fbUi41RM+l8x+SGpOH4a3FI4wRS2yVrm0ChfadD7wOXJrYAqXooP0a+FPSzw3a5gQeXrM09bAIHdgH44gG2aDcNIFN4QtiqSpKckv0SMOqGe724USaHhnO6rcxi8BPe1NtQYpMsBuLQQfSB5qxZrppk/GsjMehVOSb7AtoRH5mkjdILrjgQhefd75ycJ38lSzmvNXH1Mo7b4RhB2BUtO+vgTn3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
 b=UVhlP7ijOFESc3naNQGA7p6AIIdwmf8nghKPCw0YhWayetZRn9mj6KAMJuiORqfNQFQTtVVqNldlUByLe/n0MdPHbdZuPymXs2AMvwKFu5wz4n3D0bDbhxt0wEObZ67M6oRV5/ZXX8HJ4dA6EHOmygzQkA8r089GfC8urm+v5W5gkPNyDNMZc9/jmNFqZp+wqty0GQq8GTxgMvh54un4C5b+o5QsxMuNVpIevVIIZ9wkEJXtSqZm2PAdSsxcvCkO8Q09sFD9xNHVuvdgiHRgsJsVnrFutZSvkfHz6KJHCFwRBqsaYGyi6gkyCv+74xH3M+Ed12u98/JooFNWtZMviQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
 b=GH8Eijfut9oGfft/4NWXnLxibLbDR+kvMfvuA9HBQvaFxeV0Ul8+u+ERvWAL/nIOi3e3SMUTE98PdQFVPIYtqGSqoIzycJ1zxZHl0MnJVkNVQvPhIu1kqwpwpP1Xy1WGIV35jYhM+oTC8HYT/ZvmQV4dt0wfpnmr5ab4vdhOWoI=
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by MN2PR04MB7088.namprd04.prod.outlook.com (2603:10b6:208:1e1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Fri, 27 Feb
 2026 11:55:52 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3%3]) with mapi id 15.20.9654.007; Fri, 27 Feb 2026
 11:55:52 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Jeff Layton <jlayton@kernel.org>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
	<jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
	<mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox
	<willy@infradead.org>, Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o"
	<tytso@mit.edu>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
	<osalvador@suse.de>, David Hildenbrand <david@kernel.org>, David Howells
	<dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>, Andreas Dilger
	<adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Jaegeuk Kim
	<jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Trond Myklebust
	<trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck Lever
	<chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, Olga Kornievskaia
	<okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey
	<tom@talpey.com>, Steve French <sfrench@samba.org>, Ronnie Sahlberg
	<ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Bharath
 SM <bharathsm@microsoft.com>, Alexander Aring <alex.aring@gmail.com>, Ryusuke
 Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>,
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck
	<linux_oss@crudebyte.com>, David Sterba <dsterba@suse.com>, Marc Dionne
	<marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>, Luis de Bethencourt
	<luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, "Tigran A.
 Aivazian" <aivazian.tigran@gmail.com>, Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>, Jan Harkes <jaharkes@cs.cmu.edu>,
	"coda@cs.cmu.edu" <coda@cs.cmu.edu>, Nicolas Pitre <nico@fluxnic.net>, Tyler
 Hicks <code@tyhicks.com>, Amir Goldstein <amir73il@gmail.com>,
	"hch@infradead.org" <hch@infradead.org>, John Paul Adrian Glaubitz
	<glaubitz@physik.fu-berlin.de>, Yangtao Li <frank.li@vivo.com>, Mikulas
 Patocka <mikulas@artax.karlin.mff.cuni.cz>, David Woodhouse
	<dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Dave Kleikamp
	<shaggy@kernel.org>, Konstantin Komarov
	<almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg
	<martin@omnibond.com>, Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen
	<al@alarsen.net>, Zhihao Cheng <chengzhihao1@huawei.com>, Damien Le Moal
	<dlemoal@kernel.org>, Naohiro Aota <Naohiro.Aota@wdc.com>, Johannes Thumshirn
	<jth@kernel.org>, John Johansen <john.johansen@canonical.com>, Paul Moore
	<paul@paul-moore.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn"
	<serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, Roberto Sassu
	<roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Eric
 Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, Stephen
 Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek
	<omosnace@redhat.com>, Casey Schaufler <casey@schaufler-ca.com>, Alex Deucher
	<alexander.deucher@amd.com>, =?utf-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?=
	<christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, Simona Vetter
	<simona@ffwll.ch>, Sumit Semwal <sumit.semwal@linaro.org>, Eric Dumazet
	<edumazet@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni
	<pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, "David S. Miller"
	<davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Simon Horman
	<horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra
	<peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de
 Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, Alexander Shishkin
	<alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Ian
 Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, James
 Clark <james.clark@linaro.org>, "Darrick J. Wong" <djwong@kernel.org>, Martin
 Schiller <ms@dev.tdt.de>
CC: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "fsverity@lists.linux.dev"
	<fsverity@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"netfs@lists.linux.dev" <netfs@lists.linux.dev>, "linux-ext4@vger.kernel.org"
	<linux-ext4@vger.kernel.org>, "linux-f2fs-devel@lists.sourceforge.net"
	<linux-f2fs-devel@lists.sourceforge.net>, "linux-nfs@vger.kernel.org"
	<linux-nfs@vger.kernel.org>, "linux-cifs@vger.kernel.org"
	<linux-cifs@vger.kernel.org>, "samba-technical@lists.samba.org"
	<samba-technical@lists.samba.org>, "linux-nilfs@vger.kernel.org"
	<linux-nilfs@vger.kernel.org>, "v9fs@lists.linux.dev" <v9fs@lists.linux.dev>,
	"linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
	"autofs@vger.kernel.org" <autofs@vger.kernel.org>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
	"codalist@coda.cs.cmu.edu" <codalist@coda.cs.cmu.edu>,
	"ecryptfs@vger.kernel.org" <ecryptfs@vger.kernel.org>,
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
	"jfs-discussion@lists.sourceforge.net"
	<jfs-discussion@lists.sourceforge.net>, "ntfs3@lists.linux.dev"
	<ntfs3@lists.linux.dev>, "ocfs2-devel@lists.linux.dev"
	<ocfs2-devel@lists.linux.dev>, "devel@lists.orangefs.org"
	<devel@lists.orangefs.org>, "linux-unionfs@vger.kernel.org"
	<linux-unionfs@vger.kernel.org>, "apparmor@lists.ubuntu.com"
	<apparmor@lists.ubuntu.com>, "linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>, "linux-integrity@vger.kernel.org"
	<linux-integrity@vger.kernel.org>, "selinux@vger.kernel.org"
	<selinux@vger.kernel.org>, "amd-gfx@lists.freedesktop.org"
	<amd-gfx@lists.freedesktop.org>, "dri-devel@lists.freedesktop.org"
	<dri-devel@lists.freedesktop.org>, "linux-media@vger.kernel.org"
	<linux-media@vger.kernel.org>, "linaro-mm-sig@lists.linaro.org"
	<linaro-mm-sig@lists.linaro.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-perf-users@vger.kernel.org"
	<linux-perf-users@vger.kernel.org>, "linux-fscrypt@vger.kernel.org"
	<linux-fscrypt@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-hams@vger.kernel.org"
	<linux-hams@vger.kernel.org>, "linux-x25@vger.kernel.org"
	<linux-x25@vger.kernel.org>
Subject: Re: [PATCH 50/61] zonefs: update format strings for u64 i_ino
Thread-Topic: [PATCH 50/61] zonefs: update format strings for u64 i_ino
Thread-Index: AQHcp0MLQHR0nz4ahkS+p8n0/a9587WWcYOA
Date: Fri, 27 Feb 2026 11:55:52 +0000
Message-ID: <0ee5930b-40ef-4bbe-8c3f-e2712742d22a@wdc.com>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
 <20260226-iino-u64-v1-50-ccceff366db9@kernel.org>
In-Reply-To: <20260226-iino-u64-v1-50-ccceff366db9@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR04MB8984:EE_|MN2PR04MB7088:EE_
x-ms-office365-filtering-correlation-id: 394e6759-8bb7-4159-879e-08de75f7283b
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|19092799006|38070700021|921020;
x-microsoft-antispam-message-info:
 fIWwFZPCWTqHHaGFWzL8H0uzGhvcIlRHz17hOKjf+/ESwyAsmb8tJwJWUJy/9QRDOjaVm+VQo9CRHjf85ItJqFIUOp6AgWyE8bITCC1GxsLC0CK0cSOwU+NWWN2RbjpjpxD8o+F/o5W/PLygeOyIIngMa/mA0NDs10YGwI84r2fyLTTY4ZZ/uCMcBpIo6qVyYcHq07pj5EcHQiy7JvGQFpvNgebQ+b2EMzZrtWHAodR0WjZSlyLePAitL26mrJuEP6/CxH7N3SVte687HudYqCLpfxRUuiHPp3RBNcRGAfYWmt5fepb2oCmGpXdE82DTNbuUtgmmjXurRdCqWSZqS1yPCyNrdFvX5IGjXxLzuiV22OUrUlLiaSkn6ytwIKwNmApJCACa72uqehsnHhjZq65Pfb+o0g8Nq551dBy7nc1e4jNpsn0SC3cFQkHj6+MsYQq8nmtsERvR6cu9wvyVqc2xEVTvDIlr/u3Qn6pCCIRXOaO51LvPNI+/xxRyLUfsO5ZDAiet6qmxDf82gKPg0RwZcUfRJHWVS8nBjj43Ej85zGr1LZ9DsL1k0/cy9Pp65YXHQkLbRTxh2AQ/dhpJJqCu6beAkdMDu054fgUfRj30cQ/TPOTB86dHkPoPR6g5A+8Or6A3YZoUxY2ER0L1B44iVHJu9X5krKakaBfL9OsCo5+WF+7OtZbivRtsMuRE4h7IHe/wJOpvfiq1/HbEXOIki3t0AhXSznyY+1YOCgwxzrg56Ui2cou1A2fBJNSu60jXtbBF63vvqMMqT95J37OyI25tpC5rh3bjRXVSiwoLXAr2XLqvhZtepIH/mrKZ
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(19092799006)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YlgweENhb0VoZUVpbEpTc0ZwMWNHRHZlNW5LVzZ0bW9EMkJ1Q2ZEK0QzVnpI?=
 =?utf-8?B?UG5pUkxoN2JjWndnZFg3UWlaTWppVVhWVTVSZjFnZDI3S05ENkYvSG1iSFdT?=
 =?utf-8?B?ekJUZmErd05oODBsUkI2VmI5N1h6RkQrTldBbVc1Tm1jcFpmcEZoSWRsNnJt?=
 =?utf-8?B?RGpZNlZ3NUlpdWQ3SC9XemxTYlVubjJzRkZUdFlaVzJIbkFzajduZTJkdGJJ?=
 =?utf-8?B?cjZQYm1qQW9jd0VsVloyWXJZVDhWY3lHZWJlVDkveUFxaG9MS2FNdjZzWllR?=
 =?utf-8?B?QXFDMmFuQ2QwODNNWmlRdnRKWDhtd2dMU1JVK3JIeTQ3aFFDYUU3Y1NoQ0k5?=
 =?utf-8?B?Y0loeExtc2JhRkpjZjVHMm9VTWNhdGJRb1ZkY0lHZjVMQXY4OURYSGdhV3hZ?=
 =?utf-8?B?MDMyM3BDZUJNbmMvblRMRU5XMmF3dlNBNytXT2JoVzRVWGFPVUcwMk1XbjBX?=
 =?utf-8?B?RXM2MW85aXIxNnNpaGdKaEFLcTZvRXFBVFgxL2ltZVNHUWpzM0ptSkNIdlBX?=
 =?utf-8?B?T1ljTklCQVlOd25NcVdQVktxQXR3RDVBWThUK2NXcnlvQzN1MFlxRGRXOCtD?=
 =?utf-8?B?MGNUbitVQytEL3hMN052bDNQSjFKRDhEeVFHSXdhT1VMRUFpNlhKSmVDa2p2?=
 =?utf-8?B?Q0haSThqMVBtaEVuWDVHRFY3b2l6NlNyNzhSRWRENndYd0JXdTJCWFlBclhl?=
 =?utf-8?B?S2UzTHN1b2Z1OExYZnp2RHRBcFZEbklpTTNlcTRlMGRpbEdYN2EvNjM0VnRp?=
 =?utf-8?B?d0dwMStxaHBieVN0Y2R4dkRUS2FZbkhaNWh6WmZyQUhEUHhMMW5rc0YvRmVT?=
 =?utf-8?B?Ky9ra1p1N0hVT3JMcmtIUzFGUUYwbmNobGJKVkdUbjlERjQ2REtNN2ZvVU81?=
 =?utf-8?B?dk5UdFkvREwyQVc5aHhRWGxkUEFpb081a2IxTUFqWU5qbk5Da1h1UjhhV1lZ?=
 =?utf-8?B?OTRZVThrVjlEMTRBTmxBTGhLVVZVSU9TYUh3MEdlWEVtbnc1L3M5MmxLYjZa?=
 =?utf-8?B?Zml3ai96WjVEOWgycUlpWnJOMnFmcFdCazFXaVVZOGxtNmRUbFM2UjluWkhi?=
 =?utf-8?B?Zkx6N2VuR0NUbUxJSjdIWEtycTdqcktieG12akFwY0cvRFZyekwwemhLYlRO?=
 =?utf-8?B?bEFOMytsSFlSM2l0VGxEbitrM0grekF3MHZ2U043YmZTeU1DR1hhMTRzS0lR?=
 =?utf-8?B?TEdiL2g0MWZZb0xUbmpCVVZzTVVHSVN4MDhxWUNjVFZMZFV5RmNWTjIyY1ZM?=
 =?utf-8?B?NnNBeXhMaFNCMVRqbGtvVzRjNTJLVElCODYrZ0NHSXUxdlQzUkgwMUdMekYx?=
 =?utf-8?B?N3FVaHh4S3pUMUd3N3JuSks2YjhyV01RUU1mTmIyenN6SGpOeC9weHNKRWhj?=
 =?utf-8?B?czhXY3dmZlUvRnpzRjN4T0hmRzNLa2pXbElUaUpyaWJvaHNsZ0dQMVpTdjJM?=
 =?utf-8?B?M0plUndWU2pZNnN4MDVQVGRqWmhvWndydUFzb1V2NjkveFM0T3diSGUyZzFo?=
 =?utf-8?B?cmtpVHlGc3hRa0J6N251NE1ZYThJT05kTEluR0laZnZsemM0c3JjbFd3TWFG?=
 =?utf-8?B?bk9tazI0YnVGREFHdVJYRkZGWjlKSGY4R1UvbVIzSEVnSldCOVQxMy9LOFRt?=
 =?utf-8?B?R0J2ZHZ2UkxadHhMcUdDRlZ3N1hETnNFKzJTRklncUE5MkFVenpQN1JhZW9C?=
 =?utf-8?B?TlNORjNYM0ZPZG1WUkN5R0pYVUpBdFFmSFg4bE51Zms5Q1JJcG56ODN0NWtq?=
 =?utf-8?B?VFZDUTlPRXNYR3BnZHZ3c0FzZzBDc1ZVK0p4L25hS2l3eVFPYWJHZzdRS1VY?=
 =?utf-8?B?aUhaMXE4VzhQeUpjK0sxTGtRaXBXbis0VWlGWmRhOWNrYXM3c0ZFUXF5d09P?=
 =?utf-8?B?RVpCR2ExSysrT2pHemxQNHc1cFh2QTNCWVF4ejZWL1R3SlAxUEkzdGlJTEdV?=
 =?utf-8?B?WmVwNEFOWTE2cVB4cTZFWmR3NUJldHUyb1JpUHQzS0lWUWUwVFdwNlBxQm5l?=
 =?utf-8?B?SllKWXhoL3NsSjdnQzRlNkhSTUpTS3JsbXFwOWt1dlZpWHlQSTBHckF1NjFO?=
 =?utf-8?B?Rm93TWRPZjFDQmR1OTVtcHRqMUNLOC9DeXZGSllDRFJ3aE1zNHFGZzdRV1pU?=
 =?utf-8?B?c2ZHa1dKalk2dEFyT0F2UmFMZlNPUDV5YlJiMjJRUjRERE96NnppbUJBeEs2?=
 =?utf-8?B?djR1bFA5bFBLdVFpRHpLdWVsdFhja2FRMEp1QlJRT1lPV2VHTzdaZ2RMYmY3?=
 =?utf-8?B?Z051MUJGZGF4bTBTVEJ5NHRMdVFnR1Z2SFo5bzJZanJXV3Q4bkNXNHRDUWc3?=
 =?utf-8?B?ZGFxbFZ2ZGxDZUEyaFZPb1ZCRVRMOUNCUXN1UnJhT2xWNStkTDRSVUxjNjdM?=
 =?utf-8?Q?CdDb+/b7Y2SGqaik=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB85C4B88629F04386FB2CF892A90C2E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rrrOEe27GGw/szGLs/fX4JfTy+2165qf0QWSidXW2fdqK6XD4BF3XoDvNcJrGuK1AX/hCaGARyFkNuMUCScHMb/NZuRTJ+xbZEnw/wm7F4DgSXia72bL1hxuG8iFbkeFAwmYdvwl71od9xJaipKYoKgjcqfXyNmBAXNyC/2oObTe+Ehg4KcazPwbMOqF88bzAFAKaJ1qk0FDcSfSlbukwetIfjzP+V30NoAlet5fuzhs3OxgSEBYFg3YFGsCdz0gkh9dZW4i9/LOzs+HFxsdUsFafEX+uCHnd15nSK7cGZXfY379c7uNZZtbEqIqgt7F7AV9zzBhr3rwPPuvn3E56E7yqUSP8dOAgDvCf23BTVqyhbSxEjJsxvg9O67AlfkJhBY+VBff4PR8QiNxapklA4NIp8U+5/oKj4U8RF/WD+QWF/gkN7FE6nKqOrjVK/q0daJeb/Ro5WbsP2DOa2OCTSKdn3KO9YtByZHvTnT5W220JQ7+z47QkaP1m2XNErbPKJIt1yCXRvY5tLbld8UBWy7mPV+k/6mqZua+HIVXZETkoTHXC9s0w0mr0C2uHMxHgrdLjgZ8sh3aEhCwhYywTG1uAcu77sinHXF2V3T6SDh7w5jzDuDPLDXV62Fq+Ual
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 394e6759-8bb7-4159-879e-08de75f7283b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2026 11:55:52.5114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KYQlQ0PF9XtiYohUxrmDxATY+NWUukb7FUUKvorL7lfe1ItIj5xwQSppqHZNV7I0KMqEwDaV1HKH9qcxAiGVOCH5Hfrh5Z4ZFdBx0E30Tm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7088
X-Stat-Signature: mwh6f5zp1cdubqjw5ko9q7swxfhzr18p
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F6B540005
X-Rspamd-Server: rspam04
X-HE-Tag: 1772193368-801266
X-HE-Meta: U2FsdGVkX1/E8FQg+DsKIu5UHFRjIcOzk5dVKBuVrIegNq5f5JEQNRpTJ5z+eW1DEUO1rjNlA8i2H0Nmtqh7VwkLiG9WBE2LeF7oLv6Mf1OLITNVncfitX2VSAc1+9Qtf9v4dNOjISScRZmzruLWqThpwSV/gyUp7+Lg27OuEQeDouTBLty8IdfrG8VEscJN5C/vEi2+c4AX+/lSBmfvNiyilhJGPGjuKhOOuZsEIebbA6AoBOkNZfWgsT7Zk2t8xagu1SaIR13PIF2kHbIvZyhJGqx+N9k3jMNyfPgND3Qp6mM5iCmDr3yKxypP74q9EDdgC3Q7+EJiy9w8+ef5z/+Sf9UEyXpRcyerfHpeHBS7ACNmGymdCIMrSbmBtX4+boaUrIOwsLyW7g3lvsCG+LkXYZ+HQeCCpqHJNaSYmYDkLKY/PEDRjNYgppkJPIK3L4K+r9a/OiWtUtR5epv4yX4RPtZWn2rmTMmJPKwOkda4khKXVIxZ3Z9/WHaVVkuh5COlwN1Ui4BYWVq8jjMrXErLuLHuIc19302zAfUfpj9ZfOpOfQnUmowzz6/lz1Nrg10N81Y9a2z0N1beetM1LQXK19CgJJ+DK4CYj0C018Pa7tQMXIf/0K0axpBD2F4kSPULSxaavoYWRRamw/HmTLtGYZtpy1017JjOysTqJEC2LWnmNurIAAFBgwC1RYnVzkD44KJ2+wjYGYzG/fPLrL7JW4ICq/Ekc6f5DblO/PII804r4atEMQuGseivuxJrSgYW8VRCNcB/pmE5Y+AUBrOvSKlPVwm6fqhpNgKrNyhL9FGQMp6ZLLaDpxhxZVPol5cTb9lvTdq4yFsLbASsgZQpywy0bqC+zBW+INFK95/zCdwhmCjX1oJ2RUN1kqoobB4GuZ4/Jkpqy9iVr1gdhEzBDtICOwIziy/PuueluCDbdbRNPDf5BaPvGj5bNW+5XcmKFM6AD1Dv5lqMWVE
 jFRGrjvv
 OM3ecVpy7ZsuqmZVD14ITNsSXr7yqPKBLH9Xd8mNyRiz4OpJak7/1VPBN84u7LyS3cra961N5JXkQecbvplxIvDNmmRw5M0SnGd8Cl3P8IuKE5mcGyKYkCnVvTxNvtiNj2YPXrjxft4xZNF4pIpItpI0xjcs08cebDJEffzl5an6FliuQEOA8XFsEvSLygk1Aq1dLsf7DT1zJmquXl9ke4gvmVCJfjTjFiHFNcQ1QKK25I3Hn7smiZLURaY+eGMefSjCm2Xq2m5lSesNhx3zmJap095tXfcg11IiAqMHi3dYMoxSBvyvs0D0FXaBhkg1CKA79HRJaU/kRqfAiOylI2e1FMkHWWIjS7DMV8H9z5hq9FnvosNqomwIMM4YIGtxGzA+ngArM9pRTBwh1Ipcox8op2/9N/hRGc0H8BWikQ22Ai1YNo9I6Q0rQ7/rnj2hxKGzcEYnowM0t8CxyadIJKsgqIOCb1XmNXyEs1xa8XaTvZbtwkkADimiXZUYtY/MPptN/Lg6qPbahc6eNpTj2/F6KWr3bp6GLaKjR32Bi/ZK1y6mH+sMwuBe4VQ/RSZaqxMoUC8BVYdt4Psg7OwsSum/F1MLUAWdKGULzgsDV+3au30c54HhpJsin/WNk8vrfvc4hiNDLs3Oy0wivpz8WBNeO8m/f5EMP4nrU1U5BYvDCwraOMjfjNLGBcI5wPsI78mg6x4G94G48K0i9axROgZnnrp8diSvwiCe1FXFsXq210RBdQ1GRpRwpQtyeFbxXWd1caDx5sRqpaxhbUB59b3b+mAWMWHhpPQb8KVj6g4jsd+nxqegDS2LL/PE169Sk1xinQOQ3kXGOcP0e5Nl58g3UdRHmAKxt6TUY2SMB3hmxLvvbAKTkcpqJmp8VTmiH3UDfO26veNa611U7NCnSWNJl9GlSXd6ZvIewyGTkcgmJn2M7TWkOwydsSq7cs4sDqUcT63ricCYsepfTpefXPbvRYuEG
 jUmjHA63
 91lGQKkHZd0Bmoh1hXZfUnv40lgGD7IQTGjig57GIYBcE5aixnXjwLkhN83eoDvJ8Q7pfKO/v9zhmDYLZNDTBALrIxhXSgS6RiQDxztMPkZZeMHxUI6Sd85HcdzzImzFOvkrdR+CDQ6kXY+/JWwDVIC47/iYmqce+Ju49k8ysVwkETaOdWEAY0Lr5WRaS4+WBVxSCdWaH8fk1vPo4rjjVmDzMXmirrwl5dfzblsrhGJHm633gvpikkxOjn35nctujxaUWgK9u6iZdcMT/Sia5Xlu4hIbAmF9fW1C0ZKqBapNPgcSaGv4w+/ANaXycR/EEp3hJREUBshn0y8n+7O2SrS5pmG+tNKLo7YXTK/GCkoW0ClZUE/EHG3lTXEToHsNYN6U6qvZ5Dc8M4Zu/Qq54dp9vubGt/zHDtcB6s8sba3c5w3ovbsXUmB761WjC/hlgGV00X/srTfQHMwxx4sJw97RD3L0hHia7oU6TyaR7lGDvm4cLMiNfEVmZi1XL2GpPsC23n4PCmtmu+km0wkQJ1dWLtCcumJsWswibUDu8VBqXFENKRe0Anf8SXktqmlQr2xZz9Pv5G6SNZ5ohqfiMhlJmxc9HsQsN3EOyngDnLJ7PdNjYGauiAz4run7xDBm0OTKoF56qQNObDF2jkfSSXVit+yArXQyvufD/hR7RCo2a7aFeVNDB+3eUyJ25ncNppcLl0w+tOr61KCFssut+hVJh4b9rJV+sr7wE+jwrD/eZ5bZdfxozdVsMRM5ovJMPClZsx+y0VMLF9BmxPrK4RWloehO+u9mMGbA3lN1o6HwUIja4bCyNd7u/YNXbqPq6gTiIcZJ6mOzctjCbPW6tBOc8bxkgeWGNjs6t2Ex6izQP73CxwfTJxxpMlTDrr3DOM/CX3qZ1GhjX/q7sm6J/Fk6zzIEtZN0ZoKgNrtg9VoMMHoEO8IQpCxHOvqiuzjLc1jAZZ/92fpBNLHjyRlNImvpM41l/
 +k+hppiI
 Nz3gi2ioj69kr5Mi+PkOxPnYO6hcQswO1odxvrZgWbTn6rRHxo0qimPv1Fh6iRruCLAzotYG7DAjeTL0QJw94FFWtB6ghcped44myrPq+I+HhgApqo+Vpghkn953PjWkClMbPkhSfsrXRx3isLZJMWpBDoCo5tT0aahxGtQn/nzekg4TQJpTohpxGkeEUJhNTY67gMNI0+bualsoBx2i1Q0DUoU4mgfETO8MMRTSS2fKKI6wtSignehyjB0ZvwCFMDueXqrrNjkrQ8FSrgbvbIwcOjrWypMgmtUKuLV40omTPhiDo7bSv5BzdR+xgQApjPR5Bj/6vpWpxJy7VPLWTN0Gck7qknI667PNhcOcvgNEoA5md9DOQEesZRMH1ESDf08783OAjooCWmUEPtinPU5Kp0tB41V2pj8zfb+q4MlHlYiLugR1cxTHyiB8GbLeu32L27gRrE5uRV4ku2066wm6f2nqxNcS8RoiCG2kYLUMj/jWEo8D08x1k+STjjyRtRY9YpRSZ/sjyJEdN+ZUo3CTtH4AJ27lBKdvXqP6A8XKtAbIHd+svS+v5+TqS6PHIHS4QoJQkD09NRjdXJN7mmt6YO6wGl4AYhIzINVEP6e0QVfEwDrc9kDToqjYw4TXsYYzzR0PvkKQvuNpYsWwL+xWs51DT3cZTXU5LVhnD10qfsMp1LSbMy4Ts3GmXqeyCeDsG0gCurvotNT1wkuEkNZg42pk9muWJcBYLWj0VLYH3sOrckqu14TIxBAM3qchGr5gW+2ZSRUHPPpigmMQ5CRW2FIJmODY7x4dbH4jscrQ0byFqP2l5Aw9aHlBGtPrzlEOIsaKw9sfonnSHR87zNsqgpXysy/A8xZDmvtneqKpAf77uCZX5sJWW1TlCq/RgvHFPtJdadVZSum/17YdbJwc5otJC56BqCwPBuNUpRZBmOJX7orN+HJ3HzXLeH/q/o8eUGJkt757O1M5QVh2+tuVUqg2q
 YsWSq0JQ
 LRgc83f6cD4Y38bnzBXPLS9UG4yVC3E2NP6rNw987CrNE2CGt/RJNzQ3j2tH4bB2NX+9FjNd9/CqZvgeRp0gLVDhLOLV2d4saDnqwYI+qU6wRkUP5Js8S6zFQZmI77AM1AKOm6QkVWj0d+yf4w0ht2NA8JJ0oSwNfXt5JhW114wA2/x4EtReI/HyYmM59o9O2rg4HkQFjzwqINpDObu8pxwUGvff/ZVXbyS5gZQ4Twgkhrlz6NzLI5u/eO8bKzBo6rWGBhhGXnVGIvf7hRO8ua8NYJVSnpQdYhhgmB0i3yztLEhl39Z+A190kG5oimrE+VCBphAPLElxsSqMY343Mxv7vL51+0XRnZqcWpR44i2m+P7MaGrP0n3l0Y53ZTAUD53y5xnxMSJLS1HO9Mu71ZJ9j/YPgksik6w3q14Vo3Iqoq6G4xGRff0bEqwFTPIc+GszXVC/rDnM7TI5Dbj7Oe7gyVX4u7s7rn1PLTsO5mf0hd6UPn7h/rE2wBvoopSBSOTu734/+D2rlYK7jfFhgGKOINWvxp3ky1+mNjsStwmCbFrUg9W/zsMlZlvWol28NPxeTrPdZG7vyeYwEwhXXU6fYA8Zv2bZd3/bMhO049GReKwGR0bIruRPd6JzdE+sOHjqnzBUWPhnbc0TWdz5GmHtAQmq0hLF7G8D+/5H/OpkxyaHhl+MikBgSIrsUMKdPEkT0wWmynT8v4I0T/63+QAYXugNdKQNcCfCrcNljEc08tsKg1nMKyccTOGnaDNros0HdMVGileBCH3oew8z9V08ofTPZPYhp4jNH/uCD8YuGvOmF66xBYBlG0VFQGkV+5uVcgvALZCSGP+4xyn7B4SEQ3iW2xcF4cjeh16Jno8bHnsbsvgYV+hKt+DjmxnJ1N+RiuJtZ5VXx+bh23gAtDmxRFYowsibGovbIuC2HcSKQvbXYu35pj6Kci0yqbXA3okmqsKtun/SHZyfTTWynVrkvp6S2
 ixRmnU8x
 jMBJEGKJ2MFlhN+Ngs501Pbhpzwmr61cyMNquwSHWCRdxiPodGxtSndLumsAH1/fn9PCJIl7HjLcna+TGOJ67lIqKl+l/aXxnh9yMzwOEj+TiDEIB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TG9va3MgZ29vZCwNCg0KUmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMu
dGh1bXNoaXJuQHdkYy5jb20+DQoNCg==

