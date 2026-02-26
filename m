Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8708BFD9E0A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 19:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E99756B0197; Thu, 26 Feb 2026 14:49:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E47046B0198; Thu, 26 Feb 2026 14:49:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9FA16B019A; Thu, 26 Feb 2026 14:49:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B16A86B0197
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:49:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4025AC1281
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:49:33 +0000 (UTC)
X-FDA: 84487647426.23.B8B094F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id A42D5C0008
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:49:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fGVM3f4I;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Oy682hd5;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of chuck.lever@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=chuck.lever@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772135369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oBC2hHKkmFQcxzSwn4/aFZcgBel5pry1r3QHBWM313U=;
	b=uoMM9JPPdFPSymDu4bfBoGZXDBs+xgxgKoCmGUHOufqylMzUkWHCvXIR1NaPSqK8EnaKkg
	gAxFf0JnJXWYYwZQzIDKvhXVfreLl++52OZj0/7X0YOqp663cL+ABmDcxeIJMtTwJfL8Ol
	PSbxZSpc1av8NyJdlDkHk+8ivuOiIc8=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fGVM3f4I;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Oy682hd5;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of chuck.lever@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=chuck.lever@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772135369; a=rsa-sha256;
	cv=pass;
	b=K+/NHf9B7xY8SoBc4Iw0xU/bVypq9qSod4AD3+pEwpwWI1s2phU5gK3abPSd86f2fE2j0S
	CBZr6EplcgdTjt64eSCEA6+LTRnDDsEDhjhbcDhOktCSoPSZiiTLoHAIr9i7sfmIcnEanB
	Cr1qXckKeyV0TkeTuI4OBDvFs4nezcQ=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61QDNAr8669799;
	Thu, 26 Feb 2026 19:48:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=oBC2hHKkmFQcxzSwn4/aFZcgBel5pry1r3QHBWM313U=; b=
	fGVM3f4IEk2qkHPwkvtGxAJT2OZzed2MrVDpc4OeXf6ITiu/cUyha9YwESWHtnZP
	bZyR8War430V8h4VQB5Q72xs1DsxeftuHUWhAOdPJ1yu03eo8suvikn6i+zA2NKd
	ikxwPReDM823pj3lbVeQCQnKZmjBjQ1Lbj5K4ecaEkcrtu2D6XPAXca/pUz6guDP
	uaT6VVIFFSvrfkpn7HXs7NaYBnBy2CHwDn2taszM24r/XYCx642qxKCIrAgVaV11
	jX4+2EYLfNXzn7qM4ikYAu9HmpuLJoIAs5TqpH+QwkW6/4azSvSPOlH1RHg/X15l
	VZZqGWDGYHBDL3tvwPzZNA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3m811fc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 19:48:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61QIV95d027931;
	Thu, 26 Feb 2026 19:48:53 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011063.outbound.protection.outlook.com [52.101.62.63])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35hxxtd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 19:48:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C8gBIDUxIkvWt4YcpMe5Hjt+9MNBenWmxLiaWSnIaN619PSVHId/TqtjKmBQyUamm8JfbxZTzL1cYZBAiRU1/y/egS+htyjBCeNfwnkssZ8k75MQL8DvC78ZRYXCI1lia5ACh27UZbEKYQUhOkpLrJDAzKa6e1Bzn+gYnK4RW0uI8F396KD3RKAqLaeNH+8kqXneG6Vg5JDZIofmSumfGzF4Bmv6kjMLgUF6f9boUVe8AlExdjvFs6YHepH8V9CjTqRtcOTU10JQpbstiqi0ZCsBfHDOOLuJIhaiWYuXihuGjDy/d4zKznmFhKPqNSk5YC0ZJQtbAOWVvjzBhUq1dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oBC2hHKkmFQcxzSwn4/aFZcgBel5pry1r3QHBWM313U=;
 b=eFdW/YXWaRraQwdnnY7gdIXypqjz7Vf2dZiS9m0GaXlsOBHodspz18k4X1wvLftvAddRiq+/kKhQZOCrj3jbpKPHAOG+8mK7TDqPL6zLpdYV2G6Wz2Nhr6VGcG1BRQjZp0jnZOIg0swFxSMLArqpkbw0iGoMxILNDHLPy3d6B/r70Pxa9NLjgYB7roF4/Eidvq2+RegfmCrAUDBjLeYTyYqKUVeK/JQIFD3f+7W53vXW5tUxBI6WVOPkEetsrCBTCWsOWZ4pHIR/I5jfH7nOhEdih75V1qoGgxzWwnkQSUJ5qw4td36jOW8xBSGzxT5+QqFL2VJRr/RuuaYqNj5UYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oBC2hHKkmFQcxzSwn4/aFZcgBel5pry1r3QHBWM313U=;
 b=Oy682hd5bljcoALU3Y+SlOWa8lBZEeLU0mgjleu9LmnE0yxY7kHLDGTbop/N7/hPg1KHbeAAykfqXxrf9tfU5owTCOM+lqC4EGrD7Zru5HBFemzOqfc4fDhm9QepOaIHRlIgoPNVy9idg6ImbvcMUxrirM9+4yg3x2auHBq6GRA=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DM3PPF3D2127785.namprd10.prod.outlook.com (2603:10b6:f:fc00::c20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Thu, 26 Feb
 2026 19:48:38 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::4083:91ab:47a4:f244]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::4083:91ab:47a4:f244%4]) with mapi id 15.20.9654.007; Thu, 26 Feb 2026
 19:48:38 +0000
Message-ID: <8b0bb056-9504-4835-8063-7ddeba328721@oracle.com>
Date: Thu, 26 Feb 2026 14:48:28 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/61] nfsd: update format strings for u64 i_ino
To: Jeff Layton <jlayton@kernel.org>,
        Alexander Viro
 <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox
 <willy@infradead.org>,
        Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Paulo Alcantara <pc@manguebit.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
        NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>,
        Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
        Steve French <sfrench@samba.org>,
        Ronnie Sahlberg
 <ronniesahlberg@gmail.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Bharath SM <bharathsm@microsoft.com>,
        Alexander Aring
 <alex.aring@gmail.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Eric Van Hensbergen <ericvh@kernel.org>,
        Latchesar Ionkov
 <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        David Sterba <dsterba@suse.com>,
        Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Salah Triki <salah.triki@gmail.com>,
        "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Yangtao Li <frank.li@vivo.com>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mike Marshall
 <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>,
        Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        John Johansen <john.johansen@canonical.com>,
        Paul Moore
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
        Sumit Semwal <sumit.semwal@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller"
 <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        James Clark
 <james.clark@linaro.org>,
        "Darrick J. Wong" <djwong@kernel.org>, Martin Schiller <ms@dev.tdt.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
        fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org,
        v9fs@lists.linux.dev, linux-afs@lists.infradead.org,
        autofs@vger.kernel.org, ceph-devel@vger.kernel.org,
        codalist@coda.cs.cmu.edu, ecryptfs@vger.kernel.org,
        linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net,
        ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
        devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
        apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        netdev@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-hams@vger.kernel.org, linux-x25@vger.kernel.org
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
 <20260226-iino-u64-v1-12-ccceff366db9@kernel.org>
From: Chuck Lever <chuck.lever@oracle.com>
Content-Language: en-US
In-Reply-To: <20260226-iino-u64-v1-12-ccceff366db9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0120.namprd03.prod.outlook.com
 (2603:10b6:610:cd::35) To BN0PR10MB5128.namprd10.prod.outlook.com
 (2603:10b6:408:117::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5128:EE_|DM3PPF3D2127785:EE_
X-MS-Office365-Filtering-Correlation-Id: 3789d7d1-f5f3-4f38-4055-08de7570092b
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|7416014|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
 Hg+j6gD3vB4WWeEonaK+n0iwIcKdTMWuTeka27JXzZXV4RfY3IF3M5wpcLvfxnx2rCN+2pQpfT1AOxeN3To05r+cqbKsnBm2uCXFAhVdO7mZ8vdNE1rr6QXhGR6gHFzpkpLESyCQpl8fp0OQ+16HLvUh+SbCvRzABSJbeIkfVwJk0l80LmQHjUhQ532Lqj5aO9l+0gN+0QsPs3MwZgGDPwjWMq2vGzeKnerBhqqQKVX3nRx7o4/mR7AXopE/0SM0HHkUm+xLqyziwVkl+Lz82gFf4Btpvar/5W8JG264cDDJS8WnCv4XS/I+2Icw19hIHGj7ivDftBbTH0wmFMTE3lz80EPHEG515bAIl8lE1bOzwyNEjG+Q3xK7az1MWBzAoSLDUSldonHbLb044TgnKsm1LRjah+zrOUmYYR7jBPuP9JAElUHUNUThpBVwPW4RV1RqhQMQTTNOJAwRpFPUtm4/pM8Sbw96J4sf4WZMTou3WNMcOPoYh01720n6BR/UUALT3e2FcDQ4Mqbg6WY/Jc+FJl80XhKZZ8Bn6dHCzkp0aPwl6E5BtFYJCX8/3dKf+rMg55dyKPIIq5naqs99SEkXOHPZ3HeuPm8KSEtzIHSJ/INs7dWIrzyOG85M32cXkCLPwsBizx46JqU+VHmEXwUz1NDAPo/OrStP5WKmR3Wy1WPq57C60KgOs00DMknN7xW7zmKrHPtLO10VKb9T0wDBOHzYOhRH5NeYMPxThRbgD0hY1X+PuzvW1FO38AswEd7uqHDJH6DrfZvsmwsF3Q==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZEJHaXk0K0RjVWFINDRxY1M4MFVCeVc1dnNScEhGZzVvV0tmYkswQkRwT1RE?=
 =?utf-8?B?alFxdW5XNzhaVFcxMmJRd1gwNWQzbXJXdFJWTkhtRWRrR0Vob3dOdC9kQnpu?=
 =?utf-8?B?b2dwUzFZck5wOGpsZjlBUVdNYStMaitOcDRYSVZPM0JOdU9yNTdPNSt6SHQ3?=
 =?utf-8?B?SVFZdlNxdHc1Rmk1YTVOYStyS0o1MGNhOFA1aGNraEVpTGZ5QTJqYzVoR0Z3?=
 =?utf-8?B?eW9KSEl6czFwMUU5RDY3R3ZEZjlBNVMxa0xMeXB0cnBMTXJjTVJhRk94UVNo?=
 =?utf-8?B?WStvaUNGS05Xd3ppSTVJcUhmZFBFdXB4MkxaZXZaL05scktFc21qTzBwWTBT?=
 =?utf-8?B?a05kWUprM0pRNVp0TWUxajNVa3dWL1F0QXYzVVQwSHVJemtjZk9IVUFndmND?=
 =?utf-8?B?UUJCSkgrMFpVZGRSUmRlaUV2SGNxM3dncGk4em1RdDRxWjlKL1pIRHFKZ0Q4?=
 =?utf-8?B?U0ZJeUREdE1zM0hhbC9LUDJ1MmN2T09ra0J1YUd2emlSSGlybS91cHJ4TUR1?=
 =?utf-8?B?SnAwV0VQVndVdkJKMmRFT2ZRbVMrcktmS0UwK2dod0tVbjF4MWNJQVNvYU42?=
 =?utf-8?B?VTdoYW5mdWE3d3JkaHJRT2JGQ3R3Q0w2SkVPRW5UN0RnamM1WGtXeGVZalJI?=
 =?utf-8?B?bDNUSTVSSHpyME4ySVh2VDFISzVDL1dudHFkQnY2MTZ0bGlUYVBkMTZHQ3Q5?=
 =?utf-8?B?cmRmMVEwT0lOcDVhL2VDYktwYnhKdHRNZ3p5RkRkNVh3eGFUd0FsUS9ScWZL?=
 =?utf-8?B?NldheXhJVTBLWVdRUFRaQ2JITUw0SlZmbXVQS2o3UTNxZjBvM0ZGTU1rMXFv?=
 =?utf-8?B?S0hsek45bUNvdVJFVUFYd3dEc3JtRGVFZ2Q3TXQ2TVpSa291OWtBNlRBbldS?=
 =?utf-8?B?NC9YUE04b21EZHV5UHp2WWVhSllTbDIwUHYzdWgrY2RYS1hrVEpndmtPYTNS?=
 =?utf-8?B?RjUrYXhzeXBidWd2WklLNXJ1MXJXdTgxZVYwbDd5ZDNQc3RERExRVlhHd2pC?=
 =?utf-8?B?WFR5VXV1YldLdGZUV3NwS2FpTy9wYXAzK3oxUHJqcThSS2lUTHl0N3J1RW1q?=
 =?utf-8?B?RW03SzNOaEZkYUFLRnUxdE1WTDRPRkFJVlpsTklpcWxJbGFZMmlzMENML1R3?=
 =?utf-8?B?N2VZcGdQaEtOaUJTVHRJNWRoUzdjd012WnNRQzY2SnJHQTZCSG54WDkwaEMy?=
 =?utf-8?B?V3EvOXFVdWFnYnU0czFjZnoyV0NzRTFKZmxHQ2Nlb0ViU1lJL2FOZXgwc3Zi?=
 =?utf-8?B?cDVNa3A3WWd1cGlVcXlFUE9NMGJNelhwbHZDWi9haEJIMEc1OU1pblpmSDdN?=
 =?utf-8?B?a2Qwc0F0ZkZSOFI1QUdvRFJucnVPVFpXU09KUnZtTHdXVlN2M0IwWnVjQjla?=
 =?utf-8?B?cDZWR0VJbkRCS29kaFhmMnNZcGdvK3pIRWpjK3didHlJNm5lMGZSTjJsZWFM?=
 =?utf-8?B?SEVvZVN4cHhlR21RUzVpTG03K2wwRVptUHQzdDR5Z3ZQdEhPRjRXNmppZ3Y5?=
 =?utf-8?B?OE95bEJMajRUSlJmNVBWdWc2dDJBZ0ZVOCtPM1p5YVN0RmU1OVR4aTQ4b3Mz?=
 =?utf-8?B?NjZOSjhXM1pvWUNEcE9LOW9SSlA3eEx0eE5GbTdSKzEwbEhWbW04VWorOFlF?=
 =?utf-8?B?UmxiOS9UMmFwMGJiTnh3RmtZWlJ3aHRrWWxYdkRodnN3emo5dXNHdVJFUFFT?=
 =?utf-8?B?NjFsVnRqZTRLc0x0RTZtSXhwSnY4QzF4SEhJbnVkQW5ScSsxZzJuT0wwbW9q?=
 =?utf-8?B?MjZudnV2dG9BSFhHMzJKeUhrTm1hZ2dHQ2Z4WUcwRExCOVVPWlNydnJ6N3A1?=
 =?utf-8?B?UmxENXA2N1BlL2RkbjlkRXQ2ZkxoTVNaZ3VUYVRrVWhIRDVqVTFkT0YyUyth?=
 =?utf-8?B?L0wzRkJqdk1wZ3lUeEFRRkI0dEF5VTZaSDFnbFJoa3MySEdsV1pSdno4RVJl?=
 =?utf-8?B?Y1NJUWhSNVh2OFNaQWpqdWdwT2xPQ1htTVJGNkQ3UWF2S0RUbUpmUCtzVEIw?=
 =?utf-8?B?NTRNbUlmc0FIWEJaUVJUWHlhY3dMMFE5bnlGWVNkOUp5YlJzcUYvMFV0ZVB4?=
 =?utf-8?B?SFBkVEZZUjRNYk51UGpNeHA4cmFaRnV6UWdCRSs2eUR1THBwMDFOZGozVXBr?=
 =?utf-8?B?OUZpS3NVLzh6V0tqWGRNdldSeGM5cVF6c2M2NFE2UjVDRVJVY0p3N09aYk5Q?=
 =?utf-8?B?M1dCYzlQSUszRVk1OG9GNC9VRWNEV2tKa3ZOMXhEdHlIWjdDcEdzNEVRS0JR?=
 =?utf-8?B?Q001SGREUVdXZXFnL0VvOGpUOVBPRlEzOHhMaVdQZjJkYUt6bTh0ZXpOdHY0?=
 =?utf-8?B?Szk3TVozZmVjYktnMzdUWUFPdHJyRTBBWDdJbE1MWGtmSmlqWWdaQT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	y48lDFGgfLNkYP38AweaPOcL3ElHRBGNwoUYpIHzLt9OK0R+6zBjM+u3AZv71eVcivr7jxyHGVMQ8ze7yNTCQfEZ4A0wcKOtD1z2aTRC8mLkSR3MPByaHAUwyo4AKOkCJGEzF7ImK6F+yWhPw37gCQIM48JqFQoJZ0l49fLGaQO59TUMz9D/VhKmyFxJ+43ISWLiQiuhBQ6sj5s1jo5IHN8OliRXblb8Rl1LEEcKzcNvTQ0P6icUcLtZQ7fguVC4fVtUdcb6A4itXZ8VTHYR9qLSnTijxlvTYm3hr6uiZuugKImfNbzO9ROrfkjODyk7CO/vpCm/hw3b0RZRB7zXVGaoskvNTP/zcaw/1iQ1tClXFSBhzc0jlwLvgZZLbSzVyynDPSBpEbgieCU7IH1NfGLRyB0yumxwmyK15qKaZ6Fzijd0n9Nz57PubAut1A1b5wR++AW0oHOpBodM+9qjBrp/Lix9b2fsu9wAOmo59gyt6q7oLXVleAp4I4eAYInW5lMhiuY2dF4KL9DqVHTRtKiYwXSoshWpaXdx41uJ1TXqU6vyrflouhQ6TOP3GVJKEdHCHNsSOSHyJQdworB3mmq8DITVAGOYmAa9e4Zgw1w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3789d7d1-f5f3-4f38-4055-08de7570092b
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 19:48:38.6126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4oM0RLA5RsX6GKN1udkOcWkSQnRKZZkmyOj3tRErr361HcicgtNAArJ2Bs4n2AjEynhldC5PnsGo8pfVQHaNXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF3D2127785
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-26_02,2026-02-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602260181
X-Authority-Analysis: v=2.4 cv=O5U0fR9W c=1 sm=1 tr=0 ts=69a0a3a6 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=ffxj3DESZ4ORkukIaKkA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12262
X-Proofpoint-GUID: xw-2KZT-s4cdkmTA04370w2Hcb4LsrPl
X-Proofpoint-ORIG-GUID: xw-2KZT-s4cdkmTA04370w2Hcb4LsrPl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDE4MSBTYWx0ZWRfX2XaxRqhzdAgk
 yVo3xN4oySD9kzbHYc20LdIO9Ha+WOGZ356Hb1hMSAKSbgALVS0kohD5bkkVX2bUhbUvcloUpk3
 VIrlx+cFMXfcdyp+YNJy7fChVfCYG4jtdWym36qak/OZcN9zzMr+a0JgmsUfQT5i3EPBxtfmuEw
 7CPHjbktSRQGSAZFLYRRiz7mkyVCjX8K4OHDw0mdDmWeDODNWsBWI9jd4ZIJQ7bkw18TpPgkbKp
 YzLzRTUS6NSLHWp+xz5cJSp2hF26649odkDyo4QgdAjLbU/7LenyKEImiIXGb0kE/rTYCvjXmYx
 wc4jkjEZmC8Ev500mf3j0IKkmnA2Ovq5hoK7jE+In0ShOYrjCB6ueXDbgXDPh+AE87BtD+UQefy
 ellCerUxKTCJvGxCPgzcy8fK3RpVFuKAoqmT/6F0nWnbLQW5vv1zGadCWfjBV2JogEWWE1VlzdV
 cGvpl6773ZkKbJQlWXMBsmv5Aggfws+M/WaBgofA=
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A42D5C0008
X-Stat-Signature: n6a57gzirjou9b51b61wxajak61g8pcg
X-HE-Tag: 1772135369-642834
X-HE-Meta: U2FsdGVkX19oMFZ93T5hy0tc8PY+bs/P2V8O3khhwMcVmAQ6PHscrf/h210U52m/pWajIwq+DisLaSmuig9xIr1EzdVraRdCjFe8sIWO6NqAFhCKxCL8N2Ax7jGUGGScWG4lYeQWidQo4ckiUggW94IfDjN8z/49gT2JKNcetIa5yYHjA1ndTeArAIWnneQMAz+4Hi41r7y/6t6dCAw7NQTt/jPWsdxvLg9qmgGcICitAfcoSS2sEEgLCjk/gTS7WMm+82BMkihqZHrIl4AdKLZxqUR6fh6i/ZllB6CWHwSdfZt07A/yrR/mzWGryVPKl02ymrLYvHANs46etFw4cNSZaciuKn1ohGtcjPBNNNwDkPivf2QGNvRXYo1hfunYiemTO4TcPryTi0YeKO+htTR/yJJmEKMxQIrjrnaMQWTshLVtGRGzdsVNf12wDoMK55ChKiw7Pi2L9w/Bm/4YRz2QYaxyd4ibMxjvg12FJxLR9ykXbhUO0FvFeRDtD9UvqJq6JHzm+FhDkLMR3ESPSiCGAgGuzkgrv8isxUHneBBdwrBIHZWPQUY9/qF2T7aOUgy5D3/OnNNCrUo5t5r/8GS7R89wE6tQeWt7RnEz9WYs0zwhQIEvJ2FBXL6GwhwhnWFqPQyEh0fKfrReK+Rw8jpasB+/zZ3vhYl+TH7BXg5SZbBD655/EmBDYs2YJwxvy2IiT5g259bBASjzzpQtvtSPjgEyCtpX7T5X4ob8eqsmCpInLGUdiUl50zkNQRavcQJ/yzFYc+/p9HkCaqmA7CvGq8E2sPrH5FZ6kzFY2D5MnXu8h9R1TygVnHfW3HfrfXZ0BrPhRO4ene/RlF7mD0TVFK9c9I/AcJvRPsf75f9HWpXpocwH+Gyi6iJOiZPO1Y3rNHycnavAkc/tpuGIJK3x2KLoTK7V3I33P9WmHcN5UVfxrT5ftpw/Iq4MZZ12J5GBNLIEZzxDvnWevVm
 8N3PE3FD
 YBKq6JAvq/35+7o/mbEaFlnRikl6QAErNEwT399MSyUvVvNV1AEbbmIKYJ0ooxZWHYeiDA/boGMGAv51k/QzqwfO+miv/wZyZgtC1wGjQZlPM/YNDY+7jqD4mKzY8yLEpuwVLjrTSHhbxurQOUaZqifmWzEZzOzudqthLHpwyDhp8MwyZ7dxjwC6UfDXey62bgifkFmhuukBUSMwcj0OLfLSikln2jrGYShGpSbuq9p3ZKu1UjSMcrxEosd3/GuMjYccPluv2XZrUrxG1lxDb/pkP7r3UutsP3sLANb3cvsgCKu181T7Jfaobivt2POu/mGgNEcDuU8Drwv304O6e7/voWsdPQqagHfeakJqDnbQT18HvE5gQcXs7IfSSGS8wEe4oDEaJXJv34RiTrPHnBZUwl7wv76Xo7jrmRszM3susi615/KugNQf/UGZT6bnD4XsrnyJiJoo0fQMyG0QRGnpM40iuBQz2ac+z3tJnSYtvfGjaFSyjuu6i27qmLqS6K5Y9IOlNLyPRvjw+0PRKj1p8+sYpv0W9+BceFDW8Ss5lvGRGfaGCWPJvRdl7dRdfvxjbOqBVRu5DAoV5XoPSHq0f33ziEjPMEOtupEnEmsVStol/ZXGp4LkXyMty2och4/quuTJDi84VDIzWWU7KgzxWoWeEeoupmj6ZeVSSYnKQmlPWDQnLvH0N6PIZN0Lih9KMcpWN8ElvFIoVBxd3rndmVr3FvN0Vty8Myqt12ookYajhmFWxDiv/piCVeMnfpA8Yyhp4LMRrYfBDcoR8yFXDVjFQ9qAhz9GkUS+hbBu8duYROv8sJVE6xxmJJ3xvsnXkhIfHltc8Xi9Qc3mUUPhXpWOYtvgqtHgwt4rY0qHuny29OHpEO6MTskMiYA8ALMC1vEZ5bP7PG2gh9sooa4OxLzPRC1QsBTiYUDcXbtaxkzbV+sSCWOCJFu+qYBXUbs0FjT9T9SzzEHurz0kK4YQZLzFI
 ljZHUj00
 bo7IvRGgfK08sfIJyeoVSoSI2a9pchEMBnK1ksLpEcibPJJO92PYeM8eBlOiUCvzLKAxZwGyXp8qvTDyo1uOHJn9dDmZhGdxX7QAIydx2YHvzs813IOM+zuJzfF3nHqxrGwsfF3zugIMI19qKK6gLnzDeLKGkEbl3UyI0xob9ZAiOGfjKBq0uqE49ZScv/ps3Tgp+35XbqKh6vvtUtKitPIAHyl/GGFbhUqLPmCEni8gnj10DTyJhEmdZ2pWuu7OnDfQISmMxhLzJvB/nWBhYmUJ5zwB2giE5JumEJ58xloiN8a5hyE4AaMT3GIb7n1PKmr7/69eB7Zi6Ja9Fsiic9pnUxOpb5te6S4SELA2L0xJAx/Q/OEB64tECyuNrIpozwmCVqFFkDIWT3DLTM0sUBsaWvtUDZ9kBtTB2K+EAlXjN6GVngghHfWjbhBpzi53w9JVKnW8SCS6SYMB+vLCsgwe+7kRE/fk3mcroyIJsYCv8hwwSfk+yj0BvzJmDbP91sfQk8OGaqVbMs+lfMj4kJIM8p+nTgPVNIAXXomnW6FR3hPR3iqPpNA3A4NkgTGvBwbPydsRLZ9mst3MkHH2RHqTuNuwjVmZLtthM5BNZ4Jv7dRA64Y6iE97M5191KwpdxUqSDRq/l+Lu/bmnOZ1HYPJk5SkZSdFHsfgZrfQP8agbCwCTNlt5LCRTkkJL7MNqOzRuC/3O/wzjrkdZKw1uu0aZ7m3BpXzc2NJoK+LeSr79BDQ0ZMFHaSzr48X7z6f5ksz60Jq6mmJjzsYYvTw+y/JBifbB5AOn6dMhHSFSnT5Y62prYygr/Ocvx4JUMSaXu5zCYhXUbLr3BzyuOUgg+9OL3pmd+Z332kTb/Nt2KsuPTx5FXP/7PODkyBAo6UHifq1yeJsms7han5Wl3Id16a+8Ub8WFwWmpw5Ed0yey9B52j+hj6cmQ1rh7oTHOpLKWzqHNzjtGA2YXPa9yqLgft36gJiM
 Y3VGSE0l
 Jm0Hk6CQa2UV+59Whz7EMUCxyx7hO+WUfhAudI3pXu6IjtWTpWiMkRUqdJWJgrKIiEIG7muNuTKsF/hYPbjYpVh73ju4ydlDGpY2VhRykZg8TVAucom49nYE4tDifFEP4EBRxZMzSIiHGK5m15LBMUU+zflJzL9ig/LPEuHwbYhOmRNQ3v0Ko3xFZo10crpn4x2eP2Gq/cKkbNoCunRE27sJ5uNu7rGOjusVZYMWOWMCr32cGgcJYODFYLwZGjspDxcWBkFZZjKak4Cxn2Ny+6m/kgyAo7+f8JxR+z5jopW/eEsvTv5LsSZQVPeGqfuU7thzSfk+w7woNP518Sz2Yql2K1YyfKnNoGBkeJmFC0TfdAZYN9bBw/ApNiTmzWtOZzhqb9cScIlZs15K7RrNBc0u8fMNVQfn+ZjGNp4ibPHxD8Ss+/72FZWkY/Fh+n1p+ypjHlLQVdlK9HhnTEIJfD4DpIc15CEIZSr57Yayzwemgva5bw6Z4zGIg0Py36mqhb7xKkomsv6L1anK+DpuqUtAF/NLDhl2GdmNGddmYhDIj62o3A2lh7+dzm/xCiajKNlS6zYejGMvt2L2zryOxJLBIgjUijeKG+kSbZQzJrFKM3BwV3u5dRrIVMOjOHczh3JfPKJIp1oIEhx1H1hRs/1p40+QFjBAEupphe2NowrUoU1OhdAqPtvAo4tMC48XcjiRHkPbshSGSJmwAcUPwkLy+00Gcdb86Yj9xRlDk8Jf+d9+tBokMmHE2Uu81qwlPuzXEknPjwHXp/+RERReAj6BArH2khODmtEiK+3sxt5Z2s7caDOvnfTpkhAyFDDK0oaR+ym7hhkyB/ZpYjPUCcOEg/dJ1q1jYv9Qx8I7/m5iDa0exA6U/F7/oHRCHyu4Pl9BThgePIeGKq3GYUfeC6o5PjdJeSUc7LQPIKQ4pjfnKuR1WSQeOhPcQlnll1OgzLjMB/y9Rq/IlUeCNujXwl7VvTzRd
 lifb+Aj2
 WldiX70nJrIBjGkdwnMQBQpxX8FKcy4E2TOJR1MfXBpm3kkQq6YVOHG5+xChz3fJpXFrwuLZiNzcLEPH0JQJXR5vRGoJ/BGBuXfGFnLljnFYY4q8blKKWK6SBB5tIotHMNToYD2Lsx3tbKDCPDIAAwr4GU0fJHSxCKgiBfce6Ke2mveWftQBQEPKtDULdpjEtsqJhC1ze9SivIm00LenhHDg/CT5uQ9J2mT7UUcy6BrtwUSAwqTnKaRbhIsY5gjTDS0UMmIH+zf0R+RyQTrBF3Mwv6XVMlry/lP7TrthP08eueP/27LmbIvydUAzDUg7SEHe8NRdRKq4L4XDyJucgdkslO6EdJK/xjPu7uoFXsVMk6n5Iv0bhofoQsVUAREU7jqxbLnzXy8FWoNzjllzQOqKkGPHQQzMSWmm6TttBfKHfw01vJibLklFWNAgF/0Zp/mbzBYRqzD2wCbPE2P6SLlEPMy/HzMlOEHRq+rUvwnsYasbH/1warNSSSa9Nabo1nib4vE3mmm3pouIHZMn81tWSC9LC2lp7QSAPBLHI2MCGjvM51IQSRQXLIzvAOYSG20q2oTJv6f9NywnHPEyQ5/7kaM9te8ljldaZBFH8j0pl19FxqF/U+o2Tm7XKwy6NntqoxQ1hybonS5D+pMoCo560c4fDVMxBjzitmkCq+y4t0VD2ag5NxbuEUyNeLAB6hA/+0I3pm48SIUDqNOxwLH/0HgdoIcdg4yDnh0Xzjr8kIi5REv0T4/J+ESclMlxF+CqDna/Ht1TGVKo7s6LU5r3FhIB+BaOc/LP9xdcU2+y3BVsFcBWDdUXadH5J61SRwCRhV/hj6/rnDGUlXsQgv+FvSNnlje8U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 10:55 AM, Jeff Layton wrote:
> Update format strings from %ld/%lu to %lld/%llu for i_ino, which is
> now a u64.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/nfsd/export.c    | 2 +-
>  fs/nfsd/nfs4state.c | 4 ++--
>  fs/nfsd/nfsfh.c     | 4 ++--
>  fs/nfsd/vfs.c       | 2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
> index 8fdbba7cad96443d92cc7fdeea6158c4cc681be1..334b63eb966e71e6af6adde61aa1123f01b4390b 100644
> --- a/fs/nfsd/export.c
> +++ b/fs/nfsd/export.c
> @@ -1039,7 +1039,7 @@ exp_rootfh(struct net *net, struct auth_domain *clp, char *name,
>  	}
>  	inode = d_inode(path.dentry);
>  
> -	dprintk("nfsd: exp_rootfh(%s [%p] %s:%s/%ld)\n",
> +	dprintk("nfsd: exp_rootfh(%s [%p] %s:%s/%lld)\n",
>  		 name, path.dentry, clp->name,
>  		 inode->i_sb->s_id, inode->i_ino);
>  	exp = exp_parent(cd, clp, &path);
> diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
> index 6b9c399b89dfb71a52b9c97f0efe9a1dea0558a6..a569d89ac9123d66bb47e7d74c7c98610de21da2 100644
> --- a/fs/nfsd/nfs4state.c
> +++ b/fs/nfsd/nfs4state.c
> @@ -1253,7 +1253,7 @@ static void nfsd4_finalize_deleg_timestamps(struct nfs4_delegation *dp, struct f
>  	if (ret) {
>  		struct inode *inode = file_inode(f);
>  
> -		pr_notice_ratelimited("nfsd: Unable to update timestamps on inode %02x:%02x:%lu: %d\n",
> +		pr_notice_ratelimited("nfsd: Unable to update timestamps on inode %02x:%02x:%llu: %d\n",
>  					MAJOR(inode->i_sb->s_dev),
>  					MINOR(inode->i_sb->s_dev),
>  					inode->i_ino, ret);
> @@ -2888,7 +2888,7 @@ static void nfs4_show_superblock(struct seq_file *s, struct nfsd_file *f)
>  {
>  	struct inode *inode = file_inode(f->nf_file);
>  
> -	seq_printf(s, "superblock: \"%02x:%02x:%ld\"",
> +	seq_printf(s, "superblock: \"%02x:%02x:%llu\"",
>  					MAJOR(inode->i_sb->s_dev),
>  					 MINOR(inode->i_sb->s_dev),
>  					 inode->i_ino);
> diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
> index ed85dd43da18e6d4c4667ff14dc035f2eacff1d6..cfd143b41eb1fb53868f378d668905c1c7d5f868 100644
> --- a/fs/nfsd/nfsfh.c
> +++ b/fs/nfsd/nfsfh.c
> @@ -601,9 +601,9 @@ fh_compose(struct svc_fh *fhp, struct svc_export *exp, struct dentry *dentry,
>  	struct inode * inode = d_inode(dentry);
>  	dev_t ex_dev = exp_sb(exp)->s_dev;
>  
> -	dprintk("nfsd: fh_compose(exp %02x:%02x/%ld %pd2, ino=%ld)\n",
> +	dprintk("nfsd: fh_compose(exp %02x:%02x/%lld %pd2, ino=%lld)\n",
>  		MAJOR(ex_dev), MINOR(ex_dev),
> -		(long) d_inode(exp->ex_path.dentry)->i_ino,
> +		(long long) d_inode(exp->ex_path.dentry)->i_ino,
>  		dentry,
>  		(inode ? inode->i_ino : 0));
>  
> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index c884c3f34afb044ee5cacc962a04a97de2f7fd88..dde09f3734c2844a3fe0b6d18d596276a19aa2d1 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -1163,7 +1163,7 @@ nfsd_direct_read(struct svc_rqst *rqstp, struct svc_fh *fhp,
>  	} else if (unlikely(host_err == -EINVAL)) {
>  		struct inode *inode = d_inode(fhp->fh_dentry);
>  
> -		pr_info_ratelimited("nfsd: Direct I/O alignment failure on %s/%ld\n",
> +		pr_info_ratelimited("nfsd: Direct I/O alignment failure on %s/%lld\n",
>  				    inode->i_sb->s_id, inode->i_ino);
>  		host_err = -ESERVERFAULT;
>  	}
> 

Suggestion: Let's use the %llu format specifier consistently for
inode->i_ino, which is unsigned.

Reviewed-by: Chuck Lever <chuck.lever@oracle.com>


-- 
Chuck Lever

