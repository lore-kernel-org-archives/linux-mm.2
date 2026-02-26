Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37653FD9E01
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 19:37:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978856B015B; Thu, 26 Feb 2026 14:37:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 917E96B01A4; Thu, 26 Feb 2026 14:37:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71CCB6B01A5; Thu, 26 Feb 2026 14:37:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B59D6B015B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:37:24 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 26DD6B5A3F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:37:24 +0000 (UTC)
X-FDA: 84487616808.15.2F1CE92
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf18.hostedemail.com (Postfix) with ESMTP id 91E141C0004
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:37:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=U81oa8Dx;
	dmarc=pass (policy=reject) header.from=ibm.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf18.hostedemail.com: domain of Slava.Dubeyko@ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=Slava.Dubeyko@ibm.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772134640; a=rsa-sha256;
	cv=fail;
	b=i5UsS66i68NFihVVRSEjaeol9dVsePqzTKWb2M9sufwAxsZeqeYdbykjYOMi39Mj8VVqmX
	DgMQjhr8hpgvR66Le/73rOZZe5DTp0S7QdIbGE/byE5YFRpNP827bzbi2ZJwnYt9Nspda2
	o9XQxRkR4jxjJvrCKNWHevHC61RFNv8=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=U81oa8Dx;
	dmarc=pass (policy=reject) header.from=ibm.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf18.hostedemail.com: domain of Slava.Dubeyko@ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=Slava.Dubeyko@ibm.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772134640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EAcRJUjA6qFQ3Qprj+u9ydkV9nD17myYo+iArta8jf0=;
	b=VP5+k1tDEjq2ZDUYBa/cVrejma/iRmLLHbDKy11XCNdFOL9T5spY1wuxzo5D3sJ5hfocwq
	vZ77YcwTfsrOyXqCUYmQ5jJpI2OS7a68/kvM1IEgFyqxOeA1YUYGFTNykUTpjyM/I4+69/
	2s5mxiYzGmS5vAmTUcujlTSCNawTCY8=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61QIh2sI2347021;
	Thu, 26 Feb 2026 19:37:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=EAcRJUjA6qFQ3Qprj+u9ydkV9nD17myYo+iArta8jf0=; b=U81oa8Dx
	VJIYahgTlQ1qw5SGtBpnX4KPgnD/2Y+JxaDfR0UfMM3k0iVxoqDDTaoMuYWQNQqG
	Z0qmfg4uzUXv094Nlbo5gq3PkTN4hK4Eosu4xyXGv2CfViQx7ZlmMYGoHJ0AfHC9
	8mEvAxYHTTS5mBDHlM/H0Md46Dlmq4pHqKKJ0pVDfRCNTyh1E4s5/1wJFtDdsh3H
	5onUtygOGBfFtVGDLWEWK9MP5fFDRgW43cemoauSyoXwMPcVs48psw0g470ZOUjT
	eicMER9xhebqV00xLhXEo/8sOGpJ2xWYhv93/o2Qb5byVp/Sp0F5ECT2RilpPUBd
	3+5cHNvIMJPEWQ==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012010.outbound.protection.outlook.com [52.101.43.10])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ch858x2vp-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 19:37:16 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hXi5Fzt9BklonDHRH745U2Kp6t/tb9gcuMex6xhBDTrWzURc4UxQb+zIKT8z1diPnkzycQWwl2zCyjfJ8V/lQ+DHtb/hUECvHXd99QsiyWI/mWSUaz6BWoJyHCJ2m2lz02yr1WnIFGcMcwQISlvtn1677zL8A7rF6WEbLPUA2Pei9KeDkjJGOYfzYvzV3TSmNBBWuLWl9YpApayNMLs7VIoeEjTTA/fyYhnc8RgUy6SkUiQbpZWasdGj2HF4GIsrLzD5ZG0+Q0Fg2MQPwBLKexH0BOslTwLg+9QSUXo8JszR8Nmat/aks6ZE5p3josNvhR3haiT2gW74Tiswd7x17w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EAcRJUjA6qFQ3Qprj+u9ydkV9nD17myYo+iArta8jf0=;
 b=MlXssxLyAsZ3VmaxA9ev73BmW41KyrTkGmBy7Ozz2OUlwROfBN0aNM6gtfKH7Aar1o86eEvYyI2vkRLz9GF4IBYrk2PVPQFvpX1I2ytHXHu0s9EOELJ2puKRaFcLam4SOlTAT0lnxBIJ+5lPe90SyGLRQQxHmXKhKhBbys15DTE0eZiLBjDOPtIzpSXwasrKcnhdE6KqG2rTnlaA6TLzjh+Eh317uKWH+7zdwSExFQXIkCby7z0bRSUXzBJ9U4tl79BbfzYAa4Lg+ITtv2/NycIVKBXJ8gyk4lKp25evRU/nEHVFQ1/ix9hLbti2wScpWxPUkmhN4tHj6RH666j2jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by MW3PR15MB3979.namprd15.prod.outlook.com (2603:10b6:303:4b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 19:37:12 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%7]) with mapi id 15.20.9632.017; Thu, 26 Feb 2026
 19:37:12 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "david@kernel.org" <david@kernel.org>,
        "namhyung@kernel.org"
	<namhyung@kernel.org>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "anna@kernel.org"
	<anna@kernel.org>, "ms@dev.tdt.de" <ms@dev.tdt.de>,
        "alexander.shishkin@linux.intel.com" <alexander.shishkin@linux.intel.com>,
        "jack@suse.cz" <jack@suse.cz>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        "mark.rutland@arm.com"
	<mark.rutland@arm.com>,
        "casey@schaufler-ca.com" <casey@schaufler-ca.com>,
        "glaubitz@physik.fu-berlin.de" <glaubitz@physik.fu-berlin.de>,
        "miklos@szeredi.hu" <miklos@szeredi.hu>,
        "sumit.semwal@linaro.org"
	<sumit.semwal@linaro.org>,
        "john.johansen@canonical.com"
	<john.johansen@canonical.com>,
        "amir73il@gmail.com" <amir73il@gmail.com>,
        "slava@dubeyko.com" <slava@dubeyko.com>,
        "willy@infradead.org"
	<willy@infradead.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "asmadeus@codewreck.org" <asmadeus@codewreck.org>,
        "jth@kernel.org"
	<jth@kernel.org>,
        "shaggy@kernel.org" <shaggy@kernel.org>,
        "serge@hallyn.com"
	<serge@hallyn.com>,
        "jaharkes@cs.cmu.edu" <jaharkes@cs.cmu.edu>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "trondmy@kernel.org"
	<trondmy@kernel.org>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "ericvh@kernel.org" <ericvh@kernel.org>,
        "simona@ffwll.ch" <simona@ffwll.ch>,
        "willemb@google.com" <willemb@google.com>,
        "aivazian.tigran@gmail.com"
	<aivazian.tigran@gmail.com>,
        "hubcap@omnibond.com" <hubcap@omnibond.com>,
        "muchun.song@linux.dev" <muchun.song@linux.dev>,
        "sfrench@samba.org"
	<sfrench@samba.org>,
        "neil@brown.name" <neil@brown.name>,
        "jmorris@namei.org"
	<jmorris@namei.org>,
        "jlbec@evilplan.org" <jlbec@evilplan.org>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "ronniesahlberg@gmail.com"
	<ronniesahlberg@gmail.com>,
        "lucho@ionkov.net" <lucho@ionkov.net>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "raven@themaw.net"
	<raven@themaw.net>,
        Alex Markuze <amarkuze@redhat.com>,
        "mhiramat@kernel.org"
	<mhiramat@kernel.org>,
        "alexander.deucher@amd.com"
	<alexander.deucher@amd.com>,
        "mathieu.desnoyers@efficios.com"
	<mathieu.desnoyers@efficios.com>,
        "horms@kernel.org" <horms@kernel.org>,
        "tom@talpey.com" <tom@talpey.com>, "mark@fasheh.com" <mark@fasheh.com>,
        "mikulas@artax.karlin.mff.cuni.cz" <mikulas@artax.karlin.mff.cuni.cz>,
        "djwong@kernel.org" <djwong@kernel.org>,
        "edumazet@google.com"
	<edumazet@google.com>,
        Olga Kornievskaia <okorniev@redhat.com>,
        "bharathsm@microsoft.com" <bharathsm@microsoft.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "osalvador@suse.de"
	<osalvador@suse.de>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "christian.koenig@amd.com" <christian.koenig@amd.com>,
        "pc@manguebit.org"
	<pc@manguebit.org>,
        "martin@omnibond.com" <martin@omnibond.com>,
        "naohiro.aota@wdc.com" <naohiro.aota@wdc.com>,
        "frank.li@vivo.com"
	<frank.li@vivo.com>,
        "dsterba@suse.com" <dsterba@suse.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "code@tyhicks.com"
	<code@tyhicks.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "kuniyu@google.com" <kuniyu@google.com>,
        "nico@fluxnic.net" <nico@fluxnic.net>, "jack@suse.com" <jack@suse.com>,
        "dlemoal@kernel.org" <dlemoal@kernel.org>,
        "viro@zeniv.linux.org.uk"
	<viro@zeniv.linux.org.uk>,
        "stephen.smalley.work@gmail.com"
	<stephen.smalley.work@gmail.com>,
        "salah.triki@gmail.com"
	<salah.triki@gmail.com>,
        David Howells <dhowells@redhat.com>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "luisbg@kernel.org"
	<luisbg@kernel.org>,
        "irogers@google.com" <irogers@google.com>,
        "acme@kernel.org" <acme@kernel.org>, "richard@nod.at" <richard@nod.at>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "idryomov@gmail.com"
	<idryomov@gmail.com>,
        "joseph.qi@linux.alibaba.com"
	<joseph.qi@linux.alibaba.com>,
        "al@alarsen.net" <al@alarsen.net>,
        "james.clark@linaro.org" <james.clark@linaro.org>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        "roberto.sassu@huawei.com" <roberto.sassu@huawei.com>,
        "konishi.ryusuke@gmail.com" <konishi.ryusuke@gmail.com>,
        "sprasad@microsoft.com" <sprasad@microsoft.com>,
        "jaegeuk@kernel.org"
	<jaegeuk@kernel.org>,
        "linux_oss@crudebyte.com" <linux_oss@crudebyte.com>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "Dai.Ngo@oracle.com"
	<Dai.Ngo@oracle.com>,
        "eric.snowberg@oracle.com" <eric.snowberg@oracle.com>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "chao@kernel.org"
	<chao@kernel.org>,
        "wufan@kernel.org" <wufan@kernel.org>,
        "coda@cs.cmu.edu"
	<coda@cs.cmu.edu>, Ingo Molnar <mingo@redhat.com>,
        "alex.aring@gmail.com"
	<alex.aring@gmail.com>,
        "airlied@gmail.com" <airlied@gmail.com>,
        "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,
        Paolo Abeni
	<pabeni@redhat.com>,
        "marc.dionne@auristor.com" <marc.dionne@auristor.com>,
        "almaz.alexandrovich@paragon-software.com"
	<almaz.alexandrovich@paragon-software.com>,
        "davem@davemloft.net"
	<davem@davemloft.net>,
        "hch@infradead.org" <hch@infradead.org>
CC: "ecryptfs@vger.kernel.org" <ecryptfs@vger.kernel.org>,
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
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
        "v9fs@lists.linux.dev" <v9fs@lists.linux.dev>,
        "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>,
        "linux-x25@vger.kernel.org"
	<linux-x25@vger.kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net"
	<linux-f2fs-devel@lists.sourceforge.net>,
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
        "linux-nfs@vger.kernel.org"
	<linux-nfs@vger.kernel.org>,
        "codalist@coda.cs.cmu.edu"
	<codalist@coda.cs.cmu.edu>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netfs@lists.linux.dev" <netfs@lists.linux.dev>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Thread-Topic: [EXTERNAL] [PATCH 25/61] ceph: update format strings for u64
 i_ino
Thread-Index: AQHcpz/qP+5RsTPDR0u+eFzUdkpQnbWVYBsA
Date: Thu, 26 Feb 2026 19:37:12 +0000
Message-ID: <2dc7436752b669bc89d6dd93383c2d39984c46c5.camel@ibm.com>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
	 <20260226-iino-u64-v1-25-ccceff366db9@kernel.org>
In-Reply-To: <20260226-iino-u64-v1-25-ccceff366db9@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|MW3PR15MB3979:EE_
x-ms-office365-filtering-correlation-id: a5adee3c-c3f3-4ed9-2e8a-08de756e7071
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|10070799003|921020|38070700021;
x-microsoft-antispam-message-info:
 5fAop6Y+c0rBIIAM5zdAFzmRMfjmCzBGaVG/qQGQ6CjcvM886WFhhh76f+2dLvyUUXJhpxgKsGUckO8EKr6r16GCPPZU/m/yNeJt9zBBaz5uKsDgz0T3NeN8fXCavMt73c1cMsJiM8VaOhs4/m7lZU86aOuON1CHtOcJJrV11dQvmK6wkEzMTFAeFkecCPqaor0+1woQGNsEUexs0r5GUL7jg+qlIbgL7yrBNu9R5mULR8wsnVTa8P0V8vSILW6Sz9grUwkA/ieJuakRCHxy+vE9j7n4E1vpK2w4+j34+WOa3uDbT9ZUe2zJmXC+BvhMzchZ7MpZAr1f3DeyTCQRwiYOM1r25l1lryhZwkqZATx4nfvS3sFUrt+xDqW6j3RdyYbPLVHVR/zZGg6u8zOaZc6pKozMuYbkAuIl6JhYcfBGW7GyVofjaEdHPHf5Z381ElhJAfNc3/Eg1hLSqnQLFgOztGVWoK4MW2YbcPQLVxkL/a88b6ox+gwTrpD2lA5NmsyA6oIfP/Aeal7QZJV2eWgElQvWGqXLnJZvzpOlEVBfLgjIUGlx0EEYBQc584solqtSIZETwocFATv6cIBS34xI+Hpdm2ZI4W95hymoW9yBuipViqiAs6LOyoIoTQC+v3Csmya9JWFobwSYKoUBYOnARA0yDXyBGGrJ4efdDFs/Eh/Fheg8bcFMX8lI2OrDzokzS/G/xO8bWxrIavaWdnr+1Sm2WcqkLLK7JWSliX5Acs68D+F+c5qrsR+GCqq6nxtxy3bbUQWJEUDYsT8vVz9QH0d/RB6hoPIV6QIeaNkqtNy8Uf06PuOZ8ADGIpX2
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(10070799003)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cC9aQVZOZWtnc1h5REptT0hOZ1F3VitIeVFDOUtGdCtDcjJiZTkxVWZEeFBO?=
 =?utf-8?B?RVdFMUlUbzJIbzRDZ3QySERRZk1JbGtZYnowbUMvY2FxaWlBdldoVlFYMXpk?=
 =?utf-8?B?MzlOSGVFT3Y0R2U4em9Mc2J6eS8yTXZ4TWRWZTVTb0tGa0dwVzJobXRDVXdV?=
 =?utf-8?B?TXllNHp0Zjl1czRnbHFWc2tsSERtRzVYQVJ1aDE0Q2g5OUFDakZhYzlaVTlz?=
 =?utf-8?B?NjVDVEcwWmVaWjhsQXI1TWpWcmh2cE5ScEE4MmZGaVd1SFJuU2g2emlhMy9o?=
 =?utf-8?B?RFExNzZGdXdOOVpoZEJkdHM0YUs0ZWZKLytOaURKbGVhRTEySmZFdGhjUEJl?=
 =?utf-8?B?RnNQRG1qZTBFN1lkcHFTZ2wzcUp1SEg0TFQ4N0dxT2dXZzRWdGRiakRkbkV3?=
 =?utf-8?B?bGJIUEtDY05La05QNTA0K0YySFNTbDhpT3MrM3Jna0tnRXZHL1V1K0k0ZU55?=
 =?utf-8?B?RS9vd2RNbDlUNlhCMFovYXMzVC9JUm9Kc3EzSVUxNXRvK0RIdElsV3lISlFX?=
 =?utf-8?B?SW9Va1lNb2ZBNzNkS2R2bEZXUmlmMm9wdEVnQkc3TElRNXE5Ylh4UC9Sak5C?=
 =?utf-8?B?N3NiczN5emc5b3NuQ3IvbG5ndUx3MUVlcXg4cVZ4cWRpbmZ1cW9ibVIxN0hm?=
 =?utf-8?B?bGFiRVlCUVVzUHZYUWsyaEhRaHhDMC91V3JHZVlqcEJVb0lhRWlXNFR2RHpi?=
 =?utf-8?B?Vm9uaG1rVURXV0QxUDhIdHZ2d1psa3FrOWNHSFhZMXQxK1BwWHN5cGhVZy9X?=
 =?utf-8?B?Tnp4QTQ0dDlQS1ZYTG9UK3g5b1hwS2dMV3VYWWdNNGY0ajJxYnhBMm4vdnhl?=
 =?utf-8?B?UDN2a3pha2hKWVZDQ2E4MnRTMFRyMk9RR3g3dlNlN2FqNTJQOGY3Qi9sb1JQ?=
 =?utf-8?B?TVdyNlpWc2hSa0o2aStGZ3crc244R0hhY2JvSUhMSzhpajROREIxUm5na0pw?=
 =?utf-8?B?L29mT3NNcTlNL0dQOVM2ZE1RVmVESUgrRWNuUk1HOVJJT0tWNGpGUzJHT2tv?=
 =?utf-8?B?L09OMjFhTVZqY29hT09oUzhXNVYwWVpqdm1PZ3hEcUd3eForMVpqdTYxSm42?=
 =?utf-8?B?bVVQSUJoa1ozYnZTMzdwMzZ0TWcwTmMwdHI0UjMwU1hnd29NNHRwYlhRbXR4?=
 =?utf-8?B?TTNDaTJPbGVZemFyQWJNS2dVa2VSNDFzSnREbTZNcDNKQmN0NitYc3ZoZmpG?=
 =?utf-8?B?V0xoTnBnL3BjQ2t3SjdHZXJ6ZGFiQU9NQUVBRlQvZkdqTnJuT0o2VUdoNDg2?=
 =?utf-8?B?YUVDc3VqVjN6NS9Fc21TQXNSNFNkSjVNYm1WSXZxaXVhV05jSEJQV0lvVW0r?=
 =?utf-8?B?QUpsY2pmSmVyUTk1cXluc25QUjNkdlBWZGRiL2hzOVVjbmJTKzB4WS9zKzRi?=
 =?utf-8?B?cEpyNnFsaGNsYi9mNVdZVlJnVlBacDZsR2U3U3A2Q0hvU1FmWnBGcUI5ZDB3?=
 =?utf-8?B?anI3aDI1SzRNUGdSUkw4aHRNOHIxSlRmVnplcFN3K3ZGcm5Na1BpMmxsaXVl?=
 =?utf-8?B?U3NHcjJSWFUvRmNkcGUrOTVyV21DOS9sNjlESE9TY0FrQU00ZktrWGhmVFBh?=
 =?utf-8?B?RG80ZG9KNXEyT2JxdjZtSVBQdHEyc0lxRUU3YXhPTDBaVU9nNG12T3QrZ3pM?=
 =?utf-8?B?bkhxNlJhUm9lbHZMaVFUdmhsd0FkRi9ydzZJQ21VaHY3OFFheWNtano1Yys2?=
 =?utf-8?B?c1ZrRCtFNVhMT0Y2K1ZUOTRkY3RPRzlTejQ2YmlITnRBSzN5U2NsdlhiNjBB?=
 =?utf-8?B?SG5SWXNmYUZBUzhVUFdMSHVmUm0zKy9kOEcrM3Q0aStieXhEQ0FOUWxRczRV?=
 =?utf-8?B?OThycHF4d1ZnLzVjdTJqckFHNXZXUVVhK1k3eHZRYUtlV1hsWVZHRkhqaStL?=
 =?utf-8?B?VkU3Tjd0NUNVZUt2a3VNc1NQckhEWnYxaEh6T0NJQ0ZBUTFEeC9SOVFKbU0y?=
 =?utf-8?B?a1pSNnNMMDRMbFg3aWM3K2RoU1NZNElocUhxUXRGMnZxYjY3VW9waDNGeE9l?=
 =?utf-8?B?MUUzSmxicUp5Rm5LNnhGVlJxekV6RHpLVXlndDkxUXNRN3RUbEZha2ZwMHd0?=
 =?utf-8?B?M1BsM3dPTFdHdXRGQzhLdjdMS0VrMzBMUy9tNlc2Wm93ZzhkK0JJeDBJcG5n?=
 =?utf-8?B?L3NSSmY5ZEJ0RVVjOStLUXp1VkQ4RDdDVThPblVlTXA0eVVGY3VVQ0o1cVpm?=
 =?utf-8?B?SVgvbUNlRDlYZFpvZ3dmRnZ3Vm93WG5hODZZaERyTXBhRnFmRWhibHBKTEU1?=
 =?utf-8?B?MjZ3VU9vR1ExdFpYV3gybGtQWmkyUkpNL3FJU0lVQWxMVTRpUCtld3drajRH?=
 =?utf-8?B?dnFTeEpVQU8yYThkbzJMYlBERGJRbTJLVTRsUXlCVUcwZjFTaW5Sa2Nmd1ND?=
 =?utf-8?Q?Q/PNynifrdCZV+7AIWflqeYiP/1hBJ6+f7CkR?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9AADC9488CFA3047AEEB4B0F579550AD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5adee3c-c3f3-4ed9-2e8a-08de756e7071
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2026 19:37:12.5896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9KMX2W1ASDUFAixb3cwXeAo4woeyJLGEvs/YWKCYUMSHP/utu3m71iZmf0Yus9pG48RkVfQ0cHwonftiiqUksQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3979
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDE3NSBTYWx0ZWRfXwWDeEe6zew1W
 YEpIK0j3jdO55oVI9qeTD38bEU//DVyz4p043cMiRQcBE3h+BH9nz9XLY27c80cCrJVafpymeLu
 H9OEP+7tkpSfHAsPYeYyHkO92MCwALW1OqOWNmbaPuVtWuCmsm/boQF5/TdElEynQbpCXlAmQk5
 e5E+EH7mpbZgT1TToziEDxU5iYoHu5OdV11uM9ZYEAQ54zCinx9+uJ+beofJx0rbm0IRu4ShlP2
 kSsfx1T12m1c9ZjsHgFmqvoNZbfzfAlyIJGVO2jTcHbHl2eyctGsQpLBywTgPrXwj7EvK6jiDjc
 Lx5hc88JN/DO4uy+HasFamVxmUzo57nFFoHJFcAX0tADOAzfdoIwJgRCnQHlEAQaE8W5bGUUBFz
 ukSaDGMefdktKLfhtHIJOm63RfvNqbQ7IhX5CxhpOk60LGzuMD8876+4//+YLBttcsJZEsI1jgY
 xdBqMzmigHLxlEgtZSg==
X-Proofpoint-GUID: EGvDmIpAFepwg6tEAP_3Za_C34G24qcy
X-Authority-Analysis: v=2.4 cv=S4HUAYsP c=1 sm=1 tr=0 ts=69a0a0ec cx=c_pps
 a=a15oepxCFtbapkdjUscCyA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=zr94bLkQGwJZMLBWZqwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 9voucK_jFeHexuibvw3JeTspnur0tvyu
Subject: Re:  [PATCH 25/61] ceph: update format strings for u64 i_ino
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-26_02,2026-02-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1011 impostorscore=0 malwarescore=0 bulkscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602260175
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 91E141C0004
X-Stat-Signature: rybaupha9ou3qcp6a4cgfau3uthzdqbu
X-Rspam-User: 
X-HE-Tag: 1772134640-429607
X-HE-Meta: U2FsdGVkX18dsZ+4MmRnoUc0MbqKFwDOyw0u/NeH6k7LyX1/YbYrH5eAWmlJuTPo15F1Xtw6/A1OQopsbB2SCrrjFYZ6WP+8g6bHJrthV4usygop0npA1Zn/r28zte/nknUfWlnEqajvYlR3FcXKOh5+KuKOl8uZZHoMYwtMSNju6G2D0KczJ4V9pmPHAJMkhJKC1EhQ5TvstTBo5eCNAD0n96h45F909az6TN1tZDTAhNTTp2UI76FkoiA3fRSHxD+P6DKaPqD0Xh7uxPUw4383zhLpnkqcoYSQvdBTyZZfdG9mw4myyIXYtIMNwHobTuimIExvmOD+HpHuhksfR671TjFpxLCHIGDqQsR29JPv27fVxZwfw1vGmElfhCOpxY9R9xkcuH6n2o9hibH8D0y/ZvvsIzPRqvGPaiKeI6MSfr96Cc0ygq/hpXT/9eh5GINlXQksRE/oFsQKBmEcMZ6o6SpHMZyZReQSjJ/s6F3WN6Q7xYEitrAdZY0IocUA+P0+ZxMF0LR9mHYrj2cpO18z4tF3476UW6Xro0Ag3i5zKOfMq/x9mjsgB/bX0LMjQp6RxI2dU04IlCNyghCp0FB4uvtC+qZ+1NCSnJ7pvOH5qkDLY81sTe0BiBnyUbp+DyWI9zmWKqCmwpjIG5YffaeRWckQ7RX8Or+KaN9Jda5ALXOnAOtzXrYFYeTpYXNnSBUVQZ493/s2g8uYp9v8d4K4XPsJl3cf+ffOL1g7BIfyDkZ/fx2GBNI5Y0bi4/wmwnG1q12ZJFWRaNZ7Dte5jvVlmCJWTsjqdMKhSAEnrrjqOqUsTgt2txJ6NBhg0tIwYG+CV/ZL2cbared4eJfaocsxiKu/psNyWClR90c+XY9p34Fdh0zzvfj091mFn84CinGGKGv+sf+nOSGRB0f4jX3s0F8O7pU46dAgQm+8oNKADP3FUzqSVy1JEWeoOLa3eN/ZkxuSXOyWtE08cWt
 IKFNBLL+
 1ulS678UhvNsmg2glgQQg07Q3obyJ9IBVJHPO5DEaQufVnk5omWE0z5HR54Z+xNgMcAbnLCg/2DGm72dY7fpyUPbeRBBdw1J0RXxC+If0hpqwMpDT5FwJGKlsxikpP3k2+dNtgUIyYHhokGWGvOvYYuXuCB9E+9PiFM6wf6pFH580eYgazrk11GS8fo00sZvwd/DOkdtKKyBcik4CoidBXNWmc231uME4dd6aY/C2TSDrB4G3ywCFnb79g10ggQgyK/A5LMALjdOcx1Uv7C0SigZfdWOoMPg9CkMnz0o+FQ0Eb7419pdTIhpB/CY4wwKY0K9idyXD8MJOgPsej5mn6K1Kx5KfOgGMuPtJEhRZefk4p4/6rBmKvPVTAJy9grD5wgoZLN4/Of+DAPu86z12IpUhhB7a4MB25yIUV0P/fBBYKCDAmbMfqApkvgQ/NoB/nTyvmnlocfW65fKZGS4q77NfzFnm3EnU4orSo9yxDSuS9o2EqVm8nVTt0MP1wwC0THS911acCL+2aP9YLI6CSBZal7e+mYAuZPGENbqunRxCVrLT3Z143DSLnDESeSsgyXtR+vWuEl1jxkCtwjQqkWs/AC79mssMguBQnNJ7bU7L5uxKkfUURKnLscc1P71XZM9Ko/ql+wdddwG8icX51Exg/46sXEM5gwwbPvGcAc7nPBSljmOypMs0lXETb0/nNhesz1jwqkJ1S6s3TdbaJwMuFHb+dIrs7ohKgFb1TFmc4xM8MtKVzzSrazL/9mW3GcxX9S4/9xs0wM+OA0LE+JbiutMbUnb+C3TsrPGO+6/EG4Tg0fP5O1VOzBBwgemlanaOV7XjB1nXnWWhYy7PQQvlSmP+sgRz+WdzpDJtyG0DVVVqmKfA2kDjl+al9BB1OxNnIqvDYCQW9vjyQav2WHV5+9V4m1y0+qyzz6Tc8cXdcqPdOz1Z+lRJKHB5Lgh2Mw+KZQ2ITe2NL5yad9744KaSRZJs
 KXnBEBep
 HdqxsZpGhnL74ZMwI4PrBL48aX91ETWRJ4IjNbAd5gjhCkVmNSPVsZ/NRn7QnqI/Lafq2QtKs1yXrXmsNEwPzh75oPUwH9I0MiV06FYshVrjocaqwOHcAkxwEbSzXVqzp8JtvEc2byd7/FSDp5CeCattcVM5jfNZpsb5sGQA28yjbKfttmsonTxRiyt2hGQ83er2jxzekswmAEQ0dFI01rnjB+zs4ox4+3d7vvq8ryf7BkRFIxvas3XT6lPfJ/gUpkxBUOfCmQZj8d5JR+Br6Z4cDcGnBzK5tFj0cnYBzF+RwWlMnZcCr6NfDdsMScZLmCXAf24obZL9eRjVxankmN3//9X3nmI/EfctylG2yCLvMNbh/EmHZczruNtN5ALlZ8SOyBMXPxT75Pc66DMU5hx6cZiWB8uabVHrUcxZ8yUmqqt4c33a8LuSmw2WHWVmEt1fppsQxrmbdpSGqfccCRHepNu5A8HFGS1b9MyHdUMFNWF8DlFuQWeFjXQAaz9imYdvmyIPwsyASRUI444qcL5vVAwp15B/f3PRZGjDCq/q5IKFyYX+NbjQvi8StWPvRJhMSP1aP7nrK/MlRs0m8Np8cQgC0aSjkpuhSuxNdlgV9uMVAwroSt2xjTH6o5fxctRtsp9VPN1XItm8E3t+WREckhdJgSGwhuaSANbdG69JKGRRhDJCH+kZwRCTI7YLvVa8SghAwCVHjYL0jjqlPJBYoZnK5gNOK2tKwslT5NzdA5i42qAMIy5TOAVKbFj2L7WBbrXyTXhwtsx1rqTXJAvbFKLY57zzkl9rQM8Ap0MkSiy7oi57izNUSJKxYkUc6fOVW3oDZ2k5zrnfBpHlv7WfWQD5dN45NfQ+B9BhEoPZjXkbTl+UGFohJ/TUCsD1QLaK+vMvtARPtMBCCdwQ9QR3ZhIKboZ6cnbGINar3u+VhM+V9byI/B3hcF7f1BLT1dn14RcD+x2JtFd43TiRSRRnyGrfk
 rBBXPmgp
 A/4DnUZsjSC2ziGGHvnqeG73cjoTA6wCAKEoIQ+FJe/1+E80y5T0iFD/ZhyiPWQ/YZymgSg0rL/NQVUHML0AWxBr0q4Ywl+YcFxYWDChptqQq2je4KlhL1Vcp0pPCNCS14VJ79qQOGdfDvM+laXx/aHOiD+RQpnFKCxGW4S1lZ/TWz08nKQPw4eGn6lPH86lWkJKQRRJ8fTld3ToisReE2eUBQ2QLen8s+1OGNGjRkLZWmICk3+/1+MfIYaTySdo7JmccfPLS7W1x6/FCzMX7aafWHS3hFa8Fu/qX2agRRQ00S80w575kI8oUnlg8P6qxT+DfOFA4b1pS01T64Fi92FojW+EVfhg2Re8wK/RCl31jquf4x4OiNm2CTH7/qvM8Ye24O5VbnMuGLjvWqozQc1wAzHc2N2TnZr7kCZLaQldwf7Fa/Xt3ljNhFA44aRxI3F+/Ev2ujnh5aOgIfVgMoDYbDGNYQojphWRWJ6sr0Rfo/zhT8haJAr+x2p9nn99xYWM7+f/uqz43k5XdMWSUadlLrabhFZZrRR+LZxQJousXrQ3mJNDkB4w28ek4wMv2hbD3P2es6AoRbYYgg3stZym8vdykXTs29FaFY/N958HO/+r3AQLNHG8IM/FWYAPHugdhEvzJ2Hv4iitrdNAz5cYT3xuTYcZXA+/2+ps3NOqhCfPg7ajGoESwEbIcUBM8GtbD5z6zxWN04byUTMyFWb1U2NnwtjOz8SpxkvHgvAXglSs1M0oL2LSIPk5q2qjHxzbTIRhGelmrUSg4/6vxx6MQa0GTOpeS6n//gRu9InJMkdXgbB8FHTMXW20+O4HzuzX+LgI4ibGP734kDu5SMQ1K1i2wtrF4cy4A2EoXuoor7iIyZCyhjKhavFr3zpkfGFes9UDekIJY2jFbxhiPjDxhIKkll8IdpgifNnTKPDwX5ViyqMx5XDqD79tA++g7WCxiEzGH7yE5HYujIRDyiX+N8a0f
 tRdsRGur
 81/mHcjEFbe4fEJ56xM31tPhGzEikH1iU0ebwrktINb2xQvSHs8efJJ0RAU4r9Z57askaiudD9vtt1GmHPphcap29D/4/8WmAMphXmUEPWl4h/W1QXhznI8B9SyRN9+pMzqaa9KG6sYX55BjkNJwmhY7YwZ+CrPlgDtvLrx3jBnWvQ/d2nNN2mN30Ne8dX9z80DVHtDgCq8B1U2J2Fvri8a/3U0BlyCVVMevnIXEK0PcPUmnx2SJ+lXW8/Yr3VtC+24uEY5TIlcCNRttRSjMcZUOpJMg2asGXvYH6y/trfH5olxEZ1wWqUmDAtaIcrg2/R0yqDUGxoqXeZHrJscvBloSsdJeKZHVUY6yNLwRK7rYaa9sIjq95pQx9urenNYRVWwqw2F2WWFJ+1mBDXkuGsZlPtL+TrDg5ueX73+N02g32EXK/5Z22l2hQJROkzONpLiAD8m7+nOfFJW3qsUrYY5Eq+KFzWXXVvQQ3wane4YkRxwkhPILPvIvBlffBeesGd9AILTxDsyKKIA5WPNW3vVMITOpZmLl4+Dj1TC9MkD4odRHPJU5CIX82Xne9i14kdfSz6XEwGoQiY7k7SE/vT5oV8n2FnwdXvqXz9L77EVdzupmWzTV4O10cX13gx/Yk2oUTS7y9JbVgLj4Ve1363ApVGQq9yoYIG2zzF9F4hN4xxtUvJIIpw4qJDbGaUCGewKtiqCPZGlsKJd1bDvg+9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVGh1LCAyMDI2LTAyLTI2IGF0IDEwOjU1IC0wNTAwLCBKZWZmIExheXRvbiB3cm90ZToNCj4g
VXBkYXRlIGZvcm1hdCBzdHJpbmdzIGFuZCBsb2NhbCB2YXJpYWJsZSB0eXBlcyBpbiBjZXBoIGZv
ciB0aGUNCj4gaV9pbm8gdHlwZSBjaGFuZ2UgZnJvbSB1bnNpZ25lZCBsb25nIHRvIHU2NC4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IEplZmYgTGF5dG9uIDxqbGF5dG9uQGtlcm5lbC5vcmc+DQo+IC0t
LQ0KPiAgZnMvY2VwaC9jcnlwdG8uYyB8IDQgKystLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5z
ZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy9jZXBoL2Ny
eXB0by5jIGIvZnMvY2VwaC9jcnlwdG8uYw0KPiBpbmRleCBmM2RlNDNjY2I0NzBkZGJkNzk0NTQy
NmQ3OWY5MDI0YWU2MTVjMTI3Li4zYzhhMjFhNTcyZDgyMzBiNTU4ZjIwYmIwMjcyMTE4NGNhZTM1
ZWU2IDEwMDY0NA0KPiAtLS0gYS9mcy9jZXBoL2NyeXB0by5jDQo+ICsrKyBiL2ZzL2NlcGgvY3J5
cHRvLmMNCj4gQEAgLTI3Miw3ICsyNzIsNyBAQCBpbnQgY2VwaF9lbmNvZGVfZW5jcnlwdGVkX2Ru
YW1lKHN0cnVjdCBpbm9kZSAqcGFyZW50LCBjaGFyICpidWYsIGludCBlbGVuKQ0KPiAgCS8qIFRv
IHVuZGVyc3RhbmQgdGhlIDI0MCBsaW1pdCwgc2VlIENFUEhfTk9IQVNIX05BTUVfTUFYIGNvbW1l
bnRzICovDQo+ICAJV0FSTl9PTihlbGVuID4gMjQwKTsNCj4gIAlpZiAoZGlyICE9IHBhcmVudCkg
Ly8gbGVhZGluZyBfIGlzIGFscmVhZHkgdGhlcmU7IGFwcGVuZCBfPGludW0+DQo+IC0JCWVsZW4g
Kz0gMSArIHNwcmludGYocCArIGVsZW4sICJfJWxkIiwgZGlyLT5pX2lubyk7DQo+ICsJCWVsZW4g
Kz0gMSArIHNwcmludGYocCArIGVsZW4sICJfJWxsZCIsIGRpci0+aV9pbm8pOw0KPiAgDQo+ICBv
dXQ6DQo+ICAJa2ZyZWUoY3J5cHRidWYpOw0KPiBAQCAtMzc3LDcgKzM3Nyw3IEBAIGludCBjZXBo
X2ZuYW1lX3RvX3Vzcihjb25zdCBzdHJ1Y3QgY2VwaF9mbmFtZSAqZm5hbWUsIHN0cnVjdCBmc2Ny
eXB0X3N0ciAqdG5hbWUsDQo+ICAJaWYgKCFyZXQgJiYgKGRpciAhPSBmbmFtZS0+ZGlyKSkgew0K
PiAgCQljaGFyIHRtcF9idWZbQkFTRTY0X0NIQVJTKE5BTUVfTUFYKV07DQo+ICANCj4gLQkJbmFt
ZV9sZW4gPSBzbnByaW50Zih0bXBfYnVmLCBzaXplb2YodG1wX2J1ZiksICJfJS4qc18lbGQiLA0K
PiArCQluYW1lX2xlbiA9IHNucHJpbnRmKHRtcF9idWYsIHNpemVvZih0bXBfYnVmKSwgIl8lLipz
XyVsbGQiLA0KPiAgCQkJCSAgICBvbmFtZS0+bGVuLCBvbmFtZS0+bmFtZSwgZGlyLT5pX2lubyk7
DQo+ICAJCW1lbWNweShvbmFtZS0+bmFtZSwgdG1wX2J1ZiwgbmFtZV9sZW4pOw0KPiAgCQlvbmFt
ZS0+bGVuID0gbmFtZV9sZW47DQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBWaWFjaGVz
bGF2IER1YmV5a28gPFNsYXZhLkR1YmV5a29AaWJtLmNvbT4NCg0KVGhhbmtzLA0KU2xhdmEuDQo=

