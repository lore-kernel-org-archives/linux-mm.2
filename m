Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8597EB363C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 22:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5BC46B0135; Mon,  2 Mar 2026 17:24:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D09536B0137; Mon,  2 Mar 2026 17:24:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0A7F6B0138; Mon,  2 Mar 2026 17:24:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9B2646B0135
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:24:57 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 554B913A8A6
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 22:24:57 +0000 (UTC)
X-FDA: 84502554234.09.74B6838
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf29.hostedemail.com (Postfix) with ESMTP id A884E120006
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 22:24:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ewGud6kx;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf29.hostedemail.com: domain of Slava.Dubeyko@ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=Slava.Dubeyko@ibm.com;
	dmarc=pass (policy=reject) header.from=ibm.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772490294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0dcDC+O7W0aDklkK2cKVSi+A0+5Z+JWwv4GBK6THQA=;
	b=uldhz0pfbhJHMLNAKdeUXE3YZr0mHI4PC8rZW/dUtDC6eSooZrSxWujicLBLH9DMQbYXfm
	p2NPrKs+uYP2sT0GYa8VlEAxYLvWc5D1VEnsqExn2WmwLdPyLwTBSOrG4AjOHRLGQH6mJY
	pHhpDE5HxnX4YQD90w/kZn1OdMCFcOk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772490294; a=rsa-sha256;
	cv=fail;
	b=A3KKzUzltjpHiclj2bOGSUGXgae3Ivus5OMlvGQ4nYwE5PM+mbts4qqzoprE07weJbzWL9
	beRfY7PWyMSOXJfg3Nbl45kinsg184DM0qIyahOwTwA4vfkiRIHAPOEwRcVv7ZTvto6mwS
	SPOlp3XGagXiYfsoVnVIWfJDA77mXh0=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ewGud6kx;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf29.hostedemail.com: domain of Slava.Dubeyko@ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=Slava.Dubeyko@ibm.com;
	dmarc=pass (policy=reject) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622FP1gm2104794;
	Mon, 2 Mar 2026 22:24:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=l0dcDC+O7W0aDklkK2cKVSi+A0+5Z+JWwv4GBK6THQA=; b=ewGud6kx
	0aArwU38lEu1ddfv0FNTb3PfvSNJVdNKkIp/x0uLTqQjJrHWSmUfw0hcl3baTqjp
	AWAfXs+7iPA55faatm1OGR8RlPyrSRGprjmYu7NoqktBwMqVfARgM2v40Nj40gJ7
	KSnx47ak7C0SccKgfjMGWuAar9TU4sjVpylE6bFtnHoTHqAGR4rcq2oajCCJBqQs
	erF5BNeWjSjBceeLt9dys0wATXqs5Cu1ET2GgQfCG0OV1c2jCaIQUSlG9ZNCz14D
	9+3eWDbPqSdbe+KVF24W00GUQ16MusdB6D/gzkpHZ5LIRKZe4q+HF6qca1XinkpE
	HQCp40u9JQJ9wA==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011053.outbound.protection.outlook.com [52.101.52.53])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cksjd8prg-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 22:24:48 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T1CDRonlGTPJIPiIz3yA/iGJ0jITt7cOCIW4EgR3QhW7Yp7pNWpcWBRqJQMntR3ulxW7kGRxA7L9lqqQcmGhxdKvoaRk2eRUVVZRU6JYN8wJ/TlcFf/6/lOBMvZBg7cLpCgxufi1AKnQpbHnLoiY2gY/PwkuAn9LoCpp32Jo5ToD1MVYDN/ZPmanjGOIhXRkVz+lmKMsE7mI8lzKh5lFhPkRkdMKPFG02PmuezCRKmetBDEWP7D9Qf8sBa1GPbNX9VPN7Ggl3v4DQn7SmZfHYfMrJgYcrUYx3+5v7QxuOXuuueo6JAH+LRqqg4ajbU27pwRVFL/y79puheAfUXvcQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l0dcDC+O7W0aDklkK2cKVSi+A0+5Z+JWwv4GBK6THQA=;
 b=vZR88VwgS2HhAp2V8HTyweVQ039gzhWhv6iEoGH3rzY7Qkc1Eu3gV8TKJ+axUUzJL0XgaQ/xDFLfxgNb2VL9ciY5rQlaYIf1enJiICTnXwQR83ww8uXzGQ5fhVCDVQOzw5MglnFXZ70apG9UuT4vab2hMTKqeE1z4UpMpdbXn2euKmAdxvJ0jk37pdpdXqkUcdT2aRUWZ9I4u/wR1ulg59Y+Fxuc8FFVezlnFEfj+Ae76LuWKBwdJrmlkg03jK1/CkztGnzPABiPuRhDAkNAENwiLBPMfQrcf1NCUSXvT2iB/ul+MC8VZ90A0aInmLeCan7r+ST5bqlO74b776t1Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SJ0PR15MB4423.namprd15.prod.outlook.com (2603:10b6:a03:374::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.18; Mon, 2 Mar
 2026 22:24:36 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%7]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 22:24:36 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "jreuter@yaina.de" <jreuter@yaina.de>,
        "Dai.Ngo@oracle.com" <Dai.Ngo@oracle.com>,
        Ondrej Mosnacek
	<omosnace@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dlemoal@kernel.org" <dlemoal@kernel.org>,
        "trondmy@kernel.org"
	<trondmy@kernel.org>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "almaz.alexandrovich@paragon-software.com"
	<almaz.alexandrovich@paragon-software.com>,
        "miklos@szeredi.hu"
	<miklos@szeredi.hu>,
        "john.johansen@canonical.com"
	<john.johansen@canonical.com>,
        "stephen.smalley.work@gmail.com"
	<stephen.smalley.work@gmail.com>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>,
        Olga
 Kornievskaia <okorniev@redhat.com>,
        "amir73il@gmail.com"
	<amir73il@gmail.com>,
        "tom@talpey.com" <tom@talpey.com>,
        "joseph.qi@linux.alibaba.com" <joseph.qi@linux.alibaba.com>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "asmadeus@codewreck.org"
	<asmadeus@codewreck.org>,
        "alexander.shishkin@linux.intel.com"
	<alexander.shishkin@linux.intel.com>,
        "mark@fasheh.com" <mark@fasheh.com>,
        "linux_oss@crudebyte.com" <linux_oss@crudebyte.com>,
        "alexander.deucher@amd.com" <alexander.deucher@amd.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "willy@infradead.org"
	<willy@infradead.org>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "lucien.xin@gmail.com" <lucien.xin@gmail.com>,
        "bharathsm@microsoft.com"
	<bharathsm@microsoft.com>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "sumit.semwal@linaro.org" <sumit.semwal@linaro.org>,
        Eric Paris
	<eparis@redhat.com>,
        "djwong@kernel.org" <djwong@kernel.org>,
        "simona@ffwll.ch" <simona@ffwll.ch>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "james.clark@linaro.org"
	<james.clark@linaro.org>,
        "john.fastabend@gmail.com"
	<john.fastabend@gmail.com>,
        "dsterba@suse.com" <dsterba@suse.com>,
        "kuniyu@google.com" <kuniyu@google.com>,
        "hch@infradead.org"
	<hch@infradead.org>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "dwmw2@infradead.org"
	<dwmw2@infradead.org>,
        "ncardwell@google.com" <ncardwell@google.com>,
        "sprasad@microsoft.com" <sprasad@microsoft.com>,
        "marcelo.leitner@gmail.com"
	<marcelo.leitner@gmail.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "jack@suse.com" <jack@suse.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "frank.li@vivo.com"
	<frank.li@vivo.com>,
        "alex.aring@gmail.com" <alex.aring@gmail.com>,
        "luisbg@kernel.org" <luisbg@kernel.org>,
        "ms@dev.tdt.de" <ms@dev.tdt.de>, "jth@kernel.org" <jth@kernel.org>,
        "jlbec@evilplan.org" <jlbec@evilplan.org>,
        "aivazian.tigran@gmail.com" <aivazian.tigran@gmail.com>,
        "anna@kernel.org"
	<anna@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "willemb@google.com" <willemb@google.com>,
        "eric.snowberg@oracle.com" <eric.snowberg@oracle.com>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "acme@kernel.org"
	<acme@kernel.org>,
        "ronniesahlberg@gmail.com" <ronniesahlberg@gmail.com>,
        "jaharkes@cs.cmu.edu" <jaharkes@cs.cmu.edu>,
        David Howells
	<dhowells@redhat.com>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "courmisch@gmail.com" <courmisch@gmail.com>,
        "martin@omnibond.com"
	<martin@omnibond.com>,
        "christian.koenig@amd.com" <christian.koenig@amd.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "adilger.kernel@dilger.ca"
	<adilger.kernel@dilger.ca>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "brauner@kernel.org" <brauner@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "glaubitz@physik.fu-berlin.de" <glaubitz@physik.fu-berlin.de>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "airlied@gmail.com"
	<airlied@gmail.com>,
        "coda@cs.cmu.edu" <coda@cs.cmu.edu>,
        "casey@schaufler-ca.com" <casey@schaufler-ca.com>,
        "raven@themaw.net"
	<raven@themaw.net>,
        "horms@kernel.org" <horms@kernel.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "kuba@kernel.org"
	<kuba@kernel.org>,
        "muchun.song@linux.dev" <muchun.song@linux.dev>,
        "chao@kernel.org" <chao@kernel.org>,
        "mathieu.desnoyers@efficios.com"
	<mathieu.desnoyers@efficios.com>,
        "hubcap@omnibond.com"
	<hubcap@omnibond.com>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "sdf@fomichev.me" <sdf@fomichev.me>,
        "roberto.sassu@huawei.com"
	<roberto.sassu@huawei.com>,
        Alex Markuze <amarkuze@redhat.com>,
        "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,
        "mikulas@artax.karlin.mff.cuni.cz" <mikulas@artax.karlin.mff.cuni.cz>,
        "ericvh@kernel.org" <ericvh@kernel.org>,
        "salah.triki@gmail.com"
	<salah.triki@gmail.com>,
        "osalvador@suse.de" <osalvador@suse.de>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        "sfrench@samba.org"
	<sfrench@samba.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "wufan@kernel.org" <wufan@kernel.org>,
        "al@alarsen.net" <al@alarsen.net>,
        "pc@manguebit.org" <pc@manguebit.org>,
        "ast@kernel.org" <ast@kernel.org>, "oleg@redhat.com" <oleg@redhat.com>,
        "slava@dubeyko.com" <slava@dubeyko.com>,
        "konishi.ryusuke@gmail.com" <konishi.ryusuke@gmail.com>,
        "lucho@ionkov.net"
	<lucho@ionkov.net>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "shaggy@kernel.org" <shaggy@kernel.org>,
        "richard@nod.at" <richard@nod.at>,
        "marc.dionne@auristor.com" <marc.dionne@auristor.com>,
        "neil@brown.name"
	<neil@brown.name>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "david@kernel.org"
	<david@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "jack@suse.cz"
	<jack@suse.cz>, "code@tyhicks.com" <code@tyhicks.com>,
        "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>,
        "naohiro.aota@wdc.com" <naohiro.aota@wdc.com>,
        "zohar@linux.ibm.com"
	<zohar@linux.ibm.com>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "irogers@google.com" <irogers@google.com>
CC: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "ecryptfs@vger.kernel.org" <ecryptfs@vger.kernel.org>,
        "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>,
        "apparmor@lists.ubuntu.com" <apparmor@lists.ubuntu.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "autofs@vger.kernel.org" <autofs@vger.kernel.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "fsverity@lists.linux.dev" <fsverity@lists.linux.dev>,
        "ntfs3@lists.linux.dev" <ntfs3@lists.linux.dev>,
        "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
        "audit@vger.kernel.org" <audit@vger.kernel.org>,
        "selinux@vger.kernel.org"
	<selinux@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org"
	<linaro-mm-sig@lists.linaro.org>,
        "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>,
        "v9fs@lists.linux.dev"
	<v9fs@lists.linux.dev>,
        "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>,
        "linux-x25@vger.kernel.org"
	<linux-x25@vger.kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net"
	<linux-f2fs-devel@lists.sourceforge.net>,
        "linux-bluetooth@vger.kernel.org"
	<linux-bluetooth@vger.kernel.org>,
        "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "jfs-discussion@lists.sourceforge.net"
	<jfs-discussion@lists.sourceforge.net>,
        "linux-mtd@lists.infradead.org"
	<linux-mtd@lists.infradead.org>,
        "devel@lists.orangefs.org"
	<devel@lists.orangefs.org>,
        "linux-afs@lists.infradead.org"
	<linux-afs@lists.infradead.org>,
        "linux-fscrypt@vger.kernel.org"
	<linux-fscrypt@vger.kernel.org>,
        "linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
        "linux-cifs@vger.kernel.org"
	<linux-cifs@vger.kernel.org>,
        "linux-hams@vger.kernel.org"
	<linux-hams@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "codalist@coda.cs.cmu.edu" <codalist@coda.cs.cmu.edu>,
        "linux-mm@kvack.org"
	<linux-mm@kvack.org>,
        "netfs@lists.linux.dev" <netfs@lists.linux.dev>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Thread-Topic: [EXTERNAL] [PATCH v2 023/110] ceph: use PRIino format for i_ino
Thread-Index: AQHcqoXKM4Zi3kyuqUK+uAhoRZrmrLWb0aUA
Date: Mon, 2 Mar 2026 22:24:35 +0000
Message-ID: <da18663467d93a61e99cd4dfeadca88d25df739b.camel@ibm.com>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
	 <20260302-iino-u64-v2-23-e5388800dae0@kernel.org>
In-Reply-To: <20260302-iino-u64-v2-23-e5388800dae0@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SJ0PR15MB4423:EE_
x-ms-office365-filtering-correlation-id: 28eda2af-4d03-402d-f7e4-08de78aa7c59
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|7416014|38070700021|921020;
x-microsoft-antispam-message-info:
 MKmYxQnBkoDWsH9ac9qJ4KWzrYFzARTQvLQUqhVW/TOnH1N2seZ2NCni3Kp9pJvkfcU9YagaiYK850PBRrArS1QpF0Gadeo/DxEq0J3Mufs5cFBOzKQ2qboBImlYOVWvJCSm1CbLs0TEQxpijVRaIhPPD3FxDBbJFMLCFA8+saVLMKzDjQkbSNoBvH1xd7Ne8XOY7xOVxiTHBWUVUcwpgDn0TUaZa89W2HTZGMcfNd0lRp6m5Wn9g4aNVjmEPYoMmwTfAJM/aUfuWtvLKVLAuwbSY3E3XUb0LEKOFGxxAJI2t6H/5sm3G4CeRoBfxdl2RmW4Db634dgROLQz5UpCfIDF5muEv25+h1QzwhuTj+y1H4U5KVFjBPHz3G1Bqf0uBa6HOXkX3RBFf7ox9tToScqgWnHMhWX9EY1Tkn912mrc1ytmWq6x5H7shbUUW+xqUM3eB7/iTwI/DmQv3x+ssweEIZr3Orhrdld0oPb+0uMaCjvvlTYMwFewYxnDklOAy1A1vBH0iqnb4DkRehNEMmkZST5bMdrDNW/YgYdXp9n9FTDlKbDSXNBLdnRI19czAkkMDotJIarOecYAYxDKxWFFDG8X6gONvpe3ZEMMWD7rA0DRMhbFihviIRdaCkL9s/T2rIgYdc6oUTSCTK1JTTgKWZbcivSVyIaHVpu2LP+4Q/uoWlbV8Lkotlq5i33XmSA7M5d6Z1W0AKwz42uK42yPEmBDat4CB8K5BoAEwg+7JeWKAE6WadpaTnX/ntxVAg+kWbdVLQK6nCR9H43Q7AOqKZRYlpHRewyS51HhbuiET499oQ/eL/NowB/e0iD2
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(7416014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Zm1CT25ySGt5YWxyekNRVCt5R0txQXpzUmpiZS9ITkYrN1RSOEk5VUhncUhN?=
 =?utf-8?B?YTRJUWlsZmt4RTBMR0N5TzQvaTZNazVMUDNPY3JXL0RiWS9Bb2dNbGlFcC9B?=
 =?utf-8?B?cC96OUQrTUFjOWhmR0hObFNxUGdBTnZwbzVYRkdJZWNoaG9iNnFGNkRYdmh5?=
 =?utf-8?B?NFF2dUxyYjNZVXVpZjJTTjVrL0N1MmpZN2FZTk4zcnAzUzhQUlk5ZExYK1do?=
 =?utf-8?B?WXp5R3R5Q3RSWFNQWVBpcUNEK01rZWppWVJRTXVuVGF5VzdXclhtK2tKU2JQ?=
 =?utf-8?B?bUZnMGkycUE5cjloOUhpdTAvWjh4bVJFdnFsSlhLQ2Q1c0VkOW16SjhycnpD?=
 =?utf-8?B?RWZzQ1ltYWhTUk9YY2tzemh4U0w5YkxZZUtNNk82em9MWEp6MVpRMy8xK05t?=
 =?utf-8?B?YlFrbUppbUd5YlhsK0VUV29hMVJQRkdNbkY0OC9ydWo2aEtkY2paY3dFNzda?=
 =?utf-8?B?a3BMaTU1VmNxK1lJVFJ4SDV6eW5rZDVJU1QwRzB6dHQzSkFqbkF0cEROZFFo?=
 =?utf-8?B?YlI3QXdVMXc1Z1ZFUmNkT0pmaHF3Yk5rTHoxb1o4Sm8rMEl4UFpCMVorbU84?=
 =?utf-8?B?NkFJYk5GYlV4bzNmZEhsZE53OTJkMWYrNnhLbGFDYTNZS2V3OEZUbWlwU0FY?=
 =?utf-8?B?bitlZ1dYaE1kV21DWVdrRkJNUVFIZmtQcXJFcjIrSDRaSXcwZXczbVE3a1hJ?=
 =?utf-8?B?OU9Lb0hqc2FacWFvUzRGRjk5ODJtOFZKWGtETGRma2NNQ2QvVnVLL0svbit5?=
 =?utf-8?B?SW04QzRvVWFFaURybDlDVWwzSlBsZSs3Y3BIbmE3WjFUc1ZwMlVRdm5SODRY?=
 =?utf-8?B?b21ERTVzM1lyVEZzQW9RSStyNjllR0VBZS9jemNqRk1VOExvVlFmQktMLzA1?=
 =?utf-8?B?VU9YUGN5R1lvR0VNL1VxWlZLM3grcVhXWHRsNUVnblB6VWZpNjFrWmpaaVRi?=
 =?utf-8?B?MlN4K0FqZW9rNlM2bW16TkVVdDZKNHA4ZkNyQUZVZUpNc3c5T0dXaTdKZWZ4?=
 =?utf-8?B?MWEvL2Q5cEZhMW9FYUlPaWVzMmlEckRScnlId3Zocm5qMXY1bXpBeHVESGR4?=
 =?utf-8?B?N21tTXp2bEJwWEkwdFVLRUhEekdrOXR5T3gyZGRkQWNGaU1kTmluN05iaG5p?=
 =?utf-8?B?MkRCK2tDT1JYeDNqaFhOckd5elV6TnZCd0h2QVNUaVg5SENIcVI2dzMvaWdq?=
 =?utf-8?B?Q0VMbkRaUWJUTWhxNzYyMmkwZmlYLzZiUFdMdCtjT2V4RktNdDg2ZktscTY2?=
 =?utf-8?B?OUxWNnlRclFoaWpLb0N5S2RrNG1WR2M3WlIzRHpiMlN4SStMa3dTVDY1TWxT?=
 =?utf-8?B?K3FQUnQyVEJyWTY3cys4aHNIZFdmYlJqRWViSTBWektnZGN5aE1oN2dMVlN0?=
 =?utf-8?B?d3BRaHhqYnMvRVJBWU83cEFuenRCWjhzZDlDbWZ6ajZhbmUvVjBmUWtJWDJ2?=
 =?utf-8?B?THBvdERYbUxVTVMwbVR0VHR3SkowZ29Ia0xOdHRxTzRsTm90eWM3M2NRa24y?=
 =?utf-8?B?MHlEcUxDTDFnL1RUclVMR0FQN1pmMTNjczUvYldyREV0UWlvL0FiVUhqdFFl?=
 =?utf-8?B?ay8vd09LNFl4VGd6TVdHUXN3dldZSFNNc1NYNk0xOEx0ZVRES1FPUTlFZGwy?=
 =?utf-8?B?bnhETkNFUFplL1VHWDdWT1dPU1pYZEpQZ2NiZGt2WDN5L1VHT2lFZkNDc1My?=
 =?utf-8?B?NUtoWmNXWEpLeU84VkdkVVJIMXE1UkwxT0g3SkpXdG9wK3VweFhZQ05yRTdI?=
 =?utf-8?B?ZnRVK01JakhrT0tHZEg0d2hIS2lWbG82azhPNUJ0K1VHaG9pKzF1cmdsMXJM?=
 =?utf-8?B?T2RMcXRqVzJPRnhUbUJDUHA4UjRRQTJnWk9ud0dFcXRFdUQydis2d0hxdWNZ?=
 =?utf-8?B?UGIzSjI3ZDI5angvMmdhK3Y5ZG0xUENYbm9BQlF0RHlmcXBpTUJXNHdwN2Zv?=
 =?utf-8?B?VHExZDZDSld3eGZDTHVBWW9UTlErMGgwZWNSQXJONE9iTDZSa2F0bHFMU2ls?=
 =?utf-8?B?TmlJeE5kK3lqYkdTWC9TREc0dTFXaDJ3ejZCVlpmdGQwS3kvbDl3Q2dPQUV6?=
 =?utf-8?B?Tkd1RWgyU1Y2ZTJqcEd1UWtDZjV6ODRTMzY5SDhiVXpGMzlDdGtWTGlKNTJT?=
 =?utf-8?B?OG52aDFkTUVkS0pHa01ZUXpQNjYyNFlId2RybXp4UVJRaW0zSkFjRytJd3hl?=
 =?utf-8?B?OFFodFNBMlIzdWxYajZ1V0V2Z2haTUxBemJLWVlqQnlDUytpcWZtRDlmdHBD?=
 =?utf-8?B?ZjhySXNKVVVvWHlmaFRIRUptTHQ4THpQSjkwNXFQUGx0RmVUNkk2bkN2V2kv?=
 =?utf-8?B?QkxhQy9ZcGtjeHBoWWVoUWhaVVl5bjJWYnJ5eXpLOWlGTkFRV25ycFNWY3Fk?=
 =?utf-8?Q?/vRuxHvx6GTIaaSFBVZKVJygB7ZnW2+3AqFFm?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <11372946878A2A48B4EADE11ED050B63@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28eda2af-4d03-402d-f7e4-08de78aa7c59
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2026 22:24:35.8976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qtcwvbh0BCd4YX5vIFR6um9LwUmyDlAt3ml/bIW1nWwu6/FHq7rKz5lBez9AnjDWaRGeT+bn4krqG3w/KfIuSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4423
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=M9BA6iws c=1 sm=1 tr=0 ts=69a60e31 cx=c_pps
 a=H9d2Io+6O/etw3jU54J+0Q==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=zr94bLkQGwJZMLBWZqwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: PFWSAsnw0brlXo9EnpYfqsEcTE9Rpahr
X-Proofpoint-GUID: BiQSWPEWufxgDqkR8Ie9RStlAR2IAwUE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDE2NCBTYWx0ZWRfXzeNSYIxFouRI
 iCJZJ6d4LU7s6ixWPqhKMK3FLnjZcXXOYlZb9NpKKjEWeFQ61W1q1h6OUh622kFoEeo/6ReJh+i
 r6TabuSA4sMPRoYDA+Sydf/Jzc7aiQ3ei23ohABu8228FtN3VtMynWB++gCOyUVF03KEG6EKwNY
 oI0jrGLmvwWW9YoZU189ievBzOo9TqcXX8a1xTV66mh4F5mOaJabejZ+HYzG6+gcm2R8HPx4Akl
 /BA+d4guT4ulkae58tCq3fHXF3M6D9SrIbhR+DGqS+79Yjw6wLezIxoO51p53rTkNlirJ5bjH6y
 bqqQDEQrm31YkOZkj4RF0Cs3GTMuZvZ0a13PkVMKtcsi4OuxUmQXSwA8igMAqpzgcU8MQyYEzul
 JaX9pqGwaSNDXOHEvfHmtichL6KmKfLRJRVL6Om81laCf91R+dwsFVjCBy9KnLLikHDnBkyzJ80
 sO3V7fMzLSzNsnOlEpQ==
Subject: Re:  [PATCH v2 023/110] ceph: use PRIino format for i_ino
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 priorityscore=1501 spamscore=0 adultscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020164
X-Rspam-User: 
X-Stat-Signature: hw6ffwj7rh6tjpuxgchuhtpy1gnddfyz
X-Rspamd-Queue-Id: A884E120006
X-Rspamd-Server: rspam03
X-HE-Tag: 1772490293-597521
X-HE-Meta: U2FsdGVkX1+i165fchBcWvdRXgDCWT+VVEpcFu2BIZodKbhYPzvdPr2QWStrlgGgaYsKDBMrZ3aiODGk7bi54L8BXS5TvrBwUCMo/57Qx1yu+qfiKe64qpa/AGeA2FegqmqES2piMSyKF6E1XxPtXV1UWksQAGjiv+CQP+pceikGAQkVuDwZLOhOf0FyqItfqo+28YLcC2GTjZG1dRnH4JVJZiAzOBD+u0fEIhwaO9oA1qgVnGczishnG7zVZYTQWffnGFrPkSO1zW9vBxEASttfxlshZ+EV8CfqS8EhripRaV1vTjcgSC3WX4Y94K33RCEbp8BSN4W+YfiA6dVS4isehWV3EcuCD/4I/Q+9waWZqq1ZIxKctPA4xi3KX3wlvsnPVWZMY94+21ITr/wmocC+zk6r2EsArXt/chULF1Oj1Eewq7uayED/VwRCcRuQkO5sSI/89ouFdHZEbeC3XtOxrMfnMK/AulYgwxG76AmFZ1RIo26Qee4k5DQKWt9W7fFKoINuWzl29D616/lZx6S6XFl1xtYOz/0madNqGDEBVYIw+yMIXd6YHULHzfIu/I0mbmRDj04V4fmTa2y/W7WEzUaVYklYkRpu/mrDjugGdneuPDmdk8PlYzBFqao0keLTs1pUXiE6CI4NCi7pbKezweybtXni27reO8ksaVgmJXGfKuL4Xbp0IFnuB5fm07Lppw227a+5gCODOW6YR/qwe4kL4/iUuDZk45EQBZgukvmht3L7v/r4sTDMUYGW7WdTuwExI+KZADz4wLPa6ZY5cUJjytlcMJk7jzcZpIBabRPEn1F6qUykCPqL5YN3Q44WAOrq9djkiYadUIj4AXpyeAb7oKvI0vomwUvoeGRNYKSa8V0JLgXK1fr2ZSmlm0WVpBvF5dZwnsC3LQndt+4MjihH9boSNkVCZStAr5VZVUM1Y7IR/tNpzaDKJZwP1zTJ874VZJ5vQQVWk5q
 GaRWsDBZ
 FhWMBGTtZZy4uIZRBxPpugIqXkfJ5WPYX8ZXSg3KgireRM5xjot5kra4XYM7ijdhooeA3HZ69hnmcCEkRicviV5NkqtJIgGzCCYLocqf1VMrSU7C41rNESWUangOBQTP85XlpgvUCbrx1b3QfmxcKwUYA5WpDNf1kLAWxJoK2hehnpMgMa2/doDXdhgMwkY976qYHykLIrfILa7TjHCqaoxTI2h2o3ieMMZn28pbx6LV35aW2+8GHqaclZV7YDHEvIyDQD+NqyP1Z+m1TjlfkGw2gIlf/QpAp331rSnDVgtlykklZPbqFTX+bxOD4JrkRVgAbKkiA0OVIZq6/L2QxNck4SdDo7+kjMosbeTNb12fTHX94GaB5YVW2pC7NOHTap6dEAum+rZbA9jsXLbtDxIE5Y4O43bx34ukWv4GhGmDEAD8Mc9zDq28mmP5kjf4wsi2SpkXu/XJFScWw1kCLUJ6+WYYpNKatVtMoVdLDB+H1JogqlTDfilcDDCd3dDThV2Ln1FhNLcbzP/+P7tlFSGWvk1gvYsLaSBAUpzDU9YWQx9K9ck1trKcIaUgqy29FhLkILmYEAd7TfPtTopXpDAfLjznmhC4ivR76e8DYDzFz9NyQOsLj++W7o1gLnxsVYSiDtdBoCTUdI3wS/vKecPw7V5kj7wX5akLqi8NxrZ7w2T9o2SXKgSFAJMqu0Jt+3UDEKXbShZNbF3yl3Tlh04zU5/g0tW4TqRqPa8v5ldwszv7acPOomKyFFaAPu41MBEmHTKrnvokzFRosG0dOTJOJwLYtlQECBYoZmuXc8pDqzfPhXYmOhY0MdcgvVFboDy8e+W/Jjc+siFJDvLVQ3BOdez6icR6Zk3nsIGIpVoa2oG0jSNdDwyOySPNwNv61PkXpQFf77yOb0qiFdrMGId3nWJv0N34PfPswxhcVX4stQCisJtx+AcGP3ApHiPrfcqI0YX1wTpHY5smqaPwcVlQtrfuC
 6OBDocNL
 8VdCG1CUyvhH+3Rx9wtqf4cdILZu1IkWjoOjP+rEPFNV1aZYWIETLGxnbpnP3Ki3bgdbl4SC9ewxvrqfgtgbmRXMMnO9sBkl2uPsDOBU6EwoQPt+4I+jnj0p3yu4h0vV9jmEwaOJc7YJNDXX9IUTggv4N0nwQpbRdwohctTzjl5t3zlGvpwNM9IGgEU03smO1YOYrVT/3l+5bNGOQd2NBfUnXZJzbCLzh+sGibgLJwfQJrGjeCwqbIYPOn55NyzllnhmHsdryP9NZaExvBHUFn8P/EJpG+ZDCUq8qSN00UP3x+r1AmYxkoQFcLNBPFdbnU38ACcqZKwu86NIUbTuH9t5a0rIHCsbfZwyHVFu1vPVQx64jrywENal76Ww8ejI2dKEjpnbQNStPiGFgJNjoxfvPHKPEPl+4tcjoxi1bWv8vILKh+8pPYDqK0SqAnV7A+qLcsKfdK19JU2tbw8afarOCdwL9Gu51zXmoQ/p+/cGH4mQaoV/jS5fqjEQUKOjUVcWYkTjesRQLWoJVFkN3K0+WsbyPaUp6zzgXsxB9pP5rkM+xij0NW3WMQ74VcCCDHCw4gZU/s8blM64vKxANhW7k8kKOY4hIgEup96KMw8R95l0pBnLTrQ9YvD3m4DKVNxjCvLTTUSaLW5GRTnoxi6DsI8VZtbLJG1QoPTmgdKBq9OqYYxsX3+kEJdDZzZN5aCQFly5PtzGsBQ6UCufPxAr1CWIFTj2023csBtT76GLqBb0PKwl5K6zup1bq9YGDZFyzhYNUoHtDnUYjPeBcR5eQlu9vJj3ROVYXzHn6jJ1DL5Me6wdvaC9xiPNYh4+U1Kx2up7IfUjJ/PRRsgL3Y+fJJNmVtUvCQ1Ik7jlJxkXu+z9oVfUgGnlFowzDAq1LbQBIZKyxIiSpufM+0i3VaoNVrhzrj4SaDJkgvGde/ax0bzepVQRPh5KwfkVi+GQxk0b5amgU2F/7yefO/9sbGdM0Li5s
 CFc84EK4
 NQi2nsMao6MRmMGt9TMvrda4Zg52NnN1CFAKVmGko+vc94f/bc/ymj8SZV2FNzRlONGDq5gPsUBz73mePIDhVXdAX1CCP4Skvg9XNlmdsgNLERiooniMfXvrN7qw1MwlkZLB6FOoXtC/fHKUw5zzj3ngfV6WY0jzCluGtd5zez3AfA8279gAwePnu3wElN3dVF74x+NU52SmgtD1r5XmPq8nCprrK7UuX5AymtnanypONzASRVBqUH2BZ0/qXjh+wNigMsxXcJPQfpjLiNnTtInvPNioaYWYJ3eF4vb/IXXMiZVrknxBwHXKsNMPSf87plwh2Csg/W6fLMfiLVj8pOMS9Vbj56D7H8ubsBTGFCCrXc9AUnXYQvb/N+MTB4r/tvgKxrlNpQqT4bECGcTGhFhJdns//teFFVDwh7WvhGyO9VOtfH1bhVoKQSAGEoJg42m6mLaSIBS9WhMUvrDckwoWy7Sihma34gK3hlq0q6bqwBsWzuGhAkrnuAcCyLDbWx903q+xNbOB/oNh1nmqOJ0EveVoxT7PHHYelCrlC5yqSi173CoclkUTiy3/yK2Hi7jveD9baLn8xrOsI9u8muIqEJ0gMBj/z3hiEOra91YvZnWVcUY4H3ALv/hkIDO7BLx4MCerjtZGNjpn8MLww5tZfks6iD5a4ipquZqqsnHsGzcbEXqwWnqZjdQww/dfR1D6qvubGzyFlcsbm1iN0CSJZzpRVrjA30UGZ4hAS/jV3a+z6JyvlANpO0737XmGrHB+03L27m+XnGBnprzNFi8Q08kJRxNisrEEK4NZUMmzSexy4ZpyjHicJA42lmKKWNOVpR4ofSWmWLjqM9TGY4ZUabtODuTz81V7nwDg7JfH0YNlS/YlzC98pNW9NvUxDzQd+2TiGsTl04exNLs5PbZquiV0HA8jRsSEt55H9R1jTR+wypmJ8XEzWjFiFWogMmHvNNtYX8My8Q/DMqXLCWickVgug
 PMDuaDvY
 LYDwXuX3j1iTrTvuZ4vs44/SHn9ZXOiZaiEpFI9Ck5OQ9Td55nSEPH2uBpnzSZRpxKH4KKS/QCx7uIA9s6IwnvytKi1DtdSzL0kCs7nghKGLEYT4411u+fPK8uKBhJQXcX12XcjkGXMbuLfdoDPCeRAha0AYRs7wZZPWjxBBsodjX43SvPLK82OflQMwUVzcs/HY4MFKIqvP62cKhW/klJowF72kqebNI8lswnXDg+yjK1oUZBTiS4I0jkePsfx4mIveOl/YnIpWC+C72dNja73p+JHcq5Bq4bHQze0GtRKLTH+quwXLyCmSg4o8ju4uDCxmXjV9R8vOzPyguwuNTXQW4eXN1WTlBUAfdI4JiomFfX1q60fULkoK1EDCJhuZtkHKyUBUl9BOJLvWHPfGGyosm+7jOmdEf1wp/WRepq9zpndIFfvFm70hcYO3+7FrtSHeGgdp30JLtyykB1XDgsM2j6+Uz/9wC20O0pV1uqQdurr0QrYPjyVfVTH0gti5YjTMRDQj4rdrzm9S/3saqD/Z0PylhQeLvkRdaaaqruUqkwSARcLcNJCkUrrEwd2LyS9TBLJpvaa1xmZWVVs6KJFU5isSyT6l5bUBg0mw7lUTiWH88c9VnXkXRYiNd/tWKSEHafN4B28l7r8q8b504ZH+PEBNSubLKMHTfx5nyLuoytDpFUVtMVmUIP0KPT04OakSMV6OV4TMgtlu+jsyvL/nJr+j7m5g5PgxX5y83oIRU0YAaW/1zmsrMU0xy/UE6djjzUCt3oz7mbqPtViW25gs70H1fEG8zdOYaof2+OK4QRxhqRrmOLcJCTY1GBjS8QM+5vt7Aprw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gTW9uLCAyMDI2LTAzLTAyIGF0IDE1OjI0IC0wNTAwLCBKZWZmIExheXRvbiB3cm90ZToNCj4g
Q29udmVydCBjZXBoIGlfaW5vIGZvcm1hdCBzdHJpbmdzIHRvIHVzZSB0aGUgUFJJaW5vIGZvcm1h
dA0KPiBtYWNybyBpbiBwcmVwYXJhdGlvbiBmb3IgdGhlIHdpZGVuaW5nIG9mIGlfaW5vIHZpYSBr
aW5vX3QuDQo+IA0KPiBBbHNvIGNvcnJlY3Qgc2lnbmVkIGZvcm1hdCBzcGVjaWZpZXJzIHRvIHVu
c2lnbmVkLCBzaW5jZSBpbm9kZQ0KPiBudW1iZXJzIGFyZSB1bnNpZ25lZCB2YWx1ZXMuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBKZWZmIExheXRvbiA8amxheXRvbkBrZXJuZWwub3JnPg0KPiAtLS0N
Cj4gIGZzL2NlcGgvY3J5cHRvLmMgfCA0ICsrLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMvY2VwaC9jcnlw
dG8uYyBiL2ZzL2NlcGgvY3J5cHRvLmMNCj4gaW5kZXggZjNkZTQzY2NiNDcwZGRiZDc5NDU0MjZk
NzlmOTAyNGFlNjE1YzEyNy4uNzE4YzE5NGJhNWQ4Y2UyMmM2YTVkMWRkNjg3ZWMzNzYxMjYzZTdl
MSAxMDA2NDQNCj4gLS0tIGEvZnMvY2VwaC9jcnlwdG8uYw0KPiArKysgYi9mcy9jZXBoL2NyeXB0
by5jDQo+IEBAIC0yNzIsNyArMjcyLDcgQEAgaW50IGNlcGhfZW5jb2RlX2VuY3J5cHRlZF9kbmFt
ZShzdHJ1Y3QgaW5vZGUgKnBhcmVudCwgY2hhciAqYnVmLCBpbnQgZWxlbikNCj4gIAkvKiBUbyB1
bmRlcnN0YW5kIHRoZSAyNDAgbGltaXQsIHNlZSBDRVBIX05PSEFTSF9OQU1FX01BWCBjb21tZW50
cyAqLw0KPiAgCVdBUk5fT04oZWxlbiA+IDI0MCk7DQo+ICAJaWYgKGRpciAhPSBwYXJlbnQpIC8v
IGxlYWRpbmcgXyBpcyBhbHJlYWR5IHRoZXJlOyBhcHBlbmQgXzxpbnVtPg0KPiAtCQllbGVuICs9
IDEgKyBzcHJpbnRmKHAgKyBlbGVuLCAiXyVsZCIsIGRpci0+aV9pbm8pOw0KPiArCQllbGVuICs9
IDEgKyBzcHJpbnRmKHAgKyBlbGVuLCAiXyUiIFBSSWlubyAidSIsIGRpci0+aV9pbm8pOw0KPiAg
DQo+ICBvdXQ6DQo+ICAJa2ZyZWUoY3J5cHRidWYpOw0KPiBAQCAtMzc3LDcgKzM3Nyw3IEBAIGlu
dCBjZXBoX2ZuYW1lX3RvX3Vzcihjb25zdCBzdHJ1Y3QgY2VwaF9mbmFtZSAqZm5hbWUsIHN0cnVj
dCBmc2NyeXB0X3N0ciAqdG5hbWUsDQo+ICAJaWYgKCFyZXQgJiYgKGRpciAhPSBmbmFtZS0+ZGly
KSkgew0KPiAgCQljaGFyIHRtcF9idWZbQkFTRTY0X0NIQVJTKE5BTUVfTUFYKV07DQo+ICANCj4g
LQkJbmFtZV9sZW4gPSBzbnByaW50Zih0bXBfYnVmLCBzaXplb2YodG1wX2J1ZiksICJfJS4qc18l
bGQiLA0KPiArCQluYW1lX2xlbiA9IHNucHJpbnRmKHRtcF9idWYsIHNpemVvZih0bXBfYnVmKSwg
Il8lLipzXyUiIFBSSWlubyAidSIsDQo+ICAJCQkJICAgIG9uYW1lLT5sZW4sIG9uYW1lLT5uYW1l
LCBkaXItPmlfaW5vKTsNCj4gIAkJbWVtY3B5KG9uYW1lLT5uYW1lLCB0bXBfYnVmLCBuYW1lX2xl
bik7DQo+ICAJCW9uYW1lLT5sZW4gPSBuYW1lX2xlbjsNCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3
ZWQtYnk6IFZpYWNoZXNsYXYgRHViZXlrbyA8U2xhdmEuRHViZXlrb0BpYm0uY29tPg0KDQpUaGFu
a3MsDQpTbGF2YS4NCg==

