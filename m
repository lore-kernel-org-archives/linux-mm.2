Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C14AEF8FF4
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 918D46B00A3; Wed,  4 Mar 2026 10:50:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E4426B00A5; Wed,  4 Mar 2026 10:50:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71C5F6B00A9; Wed,  4 Mar 2026 10:50:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 58AD26B00A3
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:50:19 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0789D1604B6
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:50:19 +0000 (UTC)
X-FDA: 84508817358.21.0EFD532
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5FF6E1C000C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:50:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NAnOPca3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jVPl0HUD;
	spf=pass (imf20.hostedemail.com: domain of chuck.lever@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=chuck.lever@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772639415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=swkCXGn/Jk8t+uFSWdyh0hQf49l4xwQt4XB3k7A/LUM=;
	b=u4EYQwLYjhFIj5KGinPskRCV+9W/2C0BynqXPrLUiFuQJnPixsU+cciWI4dU0mWjoVGG2o
	BHybbJ7mwWMtraXXebY31mVmtdyZDpgbWMtqpiGZC2YhTgYvvtvQBsLm/M+9VuekHXtYhR
	NE+I5vm6uJCwrCAuopUbbrP3VcJ3sI4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772639415; a=rsa-sha256;
	cv=pass;
	b=RumtpIiiJfvfHjvb06DYP3UBVXMzKP5DUc2BWcPHEIfT7Q+9qQ71btXTXioWZFGdWsK3CY
	4z+33OtPOHykEtFxQAZmd/lA3wTSqJ8AzP9zXY+fLYBpGQwzjY7eVkkd+22Okwk4VGEst4
	kfZpb2pqMexEcSeE85IwTG7iJiisvZM=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NAnOPca3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jVPl0HUD;
	spf=pass (imf20.hostedemail.com: domain of chuck.lever@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=chuck.lever@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 624FmGOK2847875;
	Wed, 4 Mar 2026 15:49:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=swkCXGn/Jk8t+uFSWdyh0hQf49l4xwQt4XB3k7A/LUM=; b=
	NAnOPca3z3jlwdH3gzr004g20Q+6rAFAzD8+3DacydvpcWPpveqKdCC49tgr4v6a
	Gv90rn0aA7HzAfyp/OLhhew//CRKrQTwjg65Eerc8Q66Dc4t3E/44ZCNSMWtaaK2
	0txqQYdUwGraHmfYUV80yewE0umUItA6e9j0BZeLQQcSNtfXoxGwmZegrjJ3CRiw
	8H/94mFoVPnQulC53txoBIR8T/wzUNWVwL/kXtXly5tRs3DdO6rH5BbPVEBgw/qI
	WwgGvQaon7x2unlrXrgfzssT760E9kcgy2m6VckDPbXPt6GqmM3wyV39ZJVm9wq4
	BxMTREjLlyxdgCYGitcK1Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cpqpyg07k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 15:49:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 624F0HG3001441;
	Wed, 4 Mar 2026 15:49:30 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012031.outbound.protection.outlook.com [40.107.209.31])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptg8us4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 15:49:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iKdTWsJJI9c8GQ1079+TtUBc3BSkfiyVCEPXMvnCSmFE781yF38mypu5zz5z6Y49SD8825lXfWftY0uQ/JWOZGdVJRR2pKRF3e/U9uXJZZRFZApRZEzGQM4FWl8EP7nmLWw12IA9Zb29ZRd3RE8PlJ9V8clP/dTQ/V8PAp5zsakL/QLG/+0DIwaZDuNWcvXoDO+gBbNqEF1bgZqhUYfJRG3OGCCw/Hl+8w7eHjOAP4RbS73k3I5TZ3+IYY2Vd7C4l0QfiChsf1xo7zpTVSNiuY8Ksz3dblL3YYjRdWurfFjEgML26xab71CjcSA2JC9i5QUr6euYBkEj6W4Dmf2Y+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=swkCXGn/Jk8t+uFSWdyh0hQf49l4xwQt4XB3k7A/LUM=;
 b=Z2rZamP1Bw+YnNAeSlvCbRvl44MyBBpJH0w4piGtT2g/0YWSa+DSZNZYe1xQBHRlcvWtTBV4VHmDEk8ckgVg7jRETrWmi13XoQUW7hLpiSwuunsqHHIQ1ChJ4ns1Y101dOXQlzxfdkQZNd+OKKFN/hgXKS2BCIflZPtRGij/az7VuaAd1xnShMDAXrFhD7lEu3ceuA9NNX3lKY6/nviN/efXJJVm7FwSmDsu0B2l9tJjnKQU1QQt6BbaD4HUDjpYqvXJgQPdN/kGS4WiLfmWNOjMqWFL2shCCSOQA2hjf0MyakHZ5SqCsAcKyc7s10Hz/CSBqdVK9oWKTK9z+nihLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=swkCXGn/Jk8t+uFSWdyh0hQf49l4xwQt4XB3k7A/LUM=;
 b=jVPl0HUDO2hQgxfF/rENVMrZZfvyNg2DVNKFjqSaX6Wo2DverLjcYJlFhMbguU68Kv2q00kR0d97ev0BI3DhMYaSlBMTC4iGut2gERuXmazOpv3+E/KUpiZwxG/Gqn4Owlwx15ibp7VeYz6cWCM6JGY2NYAfymfgtZ+zygaa+2Y=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by IA3PR10MB8163.namprd10.prod.outlook.com (2603:10b6:208:515::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Wed, 4 Mar
 2026 15:49:20 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::4083:91ab:47a4:f244]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::4083:91ab:47a4:f244%4]) with mapi id 15.20.9678.016; Wed, 4 Mar 2026
 15:49:19 +0000
Message-ID: <1902b6ed-b5f8-4ab6-9bc6-5c9b0209f5d6@oracle.com>
Date: Wed, 4 Mar 2026 10:49:09 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/12] treewide: change inode->i_ino from unsigned long
 to u64
To: Jeff Layton <jlayton@kernel.org>,
        Alexander Viro
 <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Dan Williams <dan.j.williams@intel.com>,
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
        "Darrick J. Wong" <djwong@kernel.org>, Martin Schiller <ms@dev.tdt.de>,
        Eric Paris <eparis@redhat.com>, Joerg Reuter <jreuter@yaina.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        David Ahern <dsahern@kernel.org>, Neal Cardwell <ncardwell@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Remi Denis-Courmont <courmisch@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Magnus Karlsson
 <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
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
        linux-hams@vger.kernel.org, linux-x25@vger.kernel.org,
        audit@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-can@vger.kernel.org, linux-sctp@vger.kernel.org,
        bpf@vger.kernel.org
References: <20260304-iino-u64-v3-0-2257ad83d372@kernel.org>
 <20260304-iino-u64-v3-12-2257ad83d372@kernel.org>
From: Chuck Lever <chuck.lever@oracle.com>
Content-Language: en-US
In-Reply-To: <20260304-iino-u64-v3-12-2257ad83d372@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P221CA0046.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::19) To BN0PR10MB5128.namprd10.prod.outlook.com
 (2603:10b6:408:117::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5128:EE_|IA3PR10MB8163:EE_
X-MS-Office365-Filtering-Correlation-Id: 394326e6-cd7d-4d40-f960-08de7a05992a
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
 FMHCtgEEKmhk3kH82k96CrqKQGBJMk84fhGsPaKeTnDi7PMHT7U+aQOl48P1szReT4TGp27WXt5gncnjVSTioI8gRIyGG31TaYIVFgI7YQzxjfYANHEcdRHdvf0jV0CFWyqj7zGd5ZurfwuGy9LAhbcJJ0aACJochSS/m71bdEKlUd93UV0e8nb0aCiGlQVBZ81kqxUjtUHZbhAaICCcUmXZGh7gafGWNbuswCiW9pJv4kG3BdcH/NM5zufFfAxZAhPEH++uAgnJ1ImG4T5vGzuaS4+f+TF+/+GLxr83vMsgDgJgmxBCW4J3sfZty92jW24YaxJ11HzxLvz/WZTUt87U17r0aVtwb3nqmmxHLPsp+NNXDTNvfqRHoMfIiy4lawq8TYJSpDuKk9C/cdl5oG1EPhFKmpIB9Cu0pR82NkSmRJHPz55oGpz8zoMptofOwlcdtv3ZFMfJ9VIb50IXjSmU7/Ep7/2grk3iiqHWptCexx1uWey1g/8eEX93s7Z+brme+s2D5ubfjyo4Ga2qzebVe6yg8giAxOpYV03JqpJ1hrjuqFw8uagO/6xRD5RmJAfBVHohulZwvStMbMOIZoVMCBLgnyozAA/IW2Ta/EE5shtkfObs2W9YEmDoyXA4FWQYQOvmkgMiresMyDJfMnkG/H3DzpMwKokSNetVsDCzQFIr5IzRhkEvI4MnaLxZD4cDxpTXndqz7hw3zyGQptxrn+U6mzn4GOuJBo7QDzCbDpgor6nJQh8kOTHbq4h7LEazPDMaqL91zJoWe8ZPVA==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?enlCb0xRdmpIUHB4dzFtbUxvSVJCQjhCeW5qUUNHUzdlSmhNTU1tTnpKNjV0?=
 =?utf-8?B?T1VRemFRK0tPY3hXdVVGYkJjZzg0ZGovSUg0aFlHeVA5a0lFZ2VnVkN1M2ox?=
 =?utf-8?B?QVV3ZnZYanlqRzZVM2ZkeEd1Yzk4LzlGOTJGbHovalM5VEhrM1F5a3lQTXJF?=
 =?utf-8?B?WmZKQVJySVFlcWFhbjhiNjlBZEJ5aHdINW5CbkNzRWtqMXA2d2t5dUxKcXNm?=
 =?utf-8?B?eHpwYmRzc3hlSkw4Mk5UR0Z4dTVkM2thdERtUG82YTFrWjdqdzhTSjhCRnBJ?=
 =?utf-8?B?SEhWZnFWRk5ncTZlVGk4RXFjOWxyTjhLQ3V1UnZkU2lZWC9pSDhaMHhsTXMr?=
 =?utf-8?B?dnFvM3UxOUpTbk9DY2VoaHpsTEVVVTlIcVA3Skd6MFhXMHFBRFEyNjB3cE9C?=
 =?utf-8?B?YlNYS3hZZEptVVB2ZUxnNy9mbDFwRnFpemVkWnA1SnhxN2F1RHkyWFBIQlpw?=
 =?utf-8?B?ZHBXZTdGZDRvU3c5NERzUVlUZ3g2ZkhDZVlWZldCWm90eXNmREM0OXptNkww?=
 =?utf-8?B?YVFLYlhFWTI3dmxhMWtneEtSN1VtM01ZTTFEekg2ZmZlcXFVbkc0TWlwUG5l?=
 =?utf-8?B?K0xTMUtMLzB5WVY0MFFyQTViL01haVZWR0RZajVmYzVLaXcybVRLT2FoUkRB?=
 =?utf-8?B?emRYOGJQd3pqSVlBanZ2Y2tLT0k1UXhGM1ZldkxreGVyR1ovMEJIY1dZVWs4?=
 =?utf-8?B?SUxzQWdBQ0I1eVl2Mlh5ZkNZRmZDVi9heDU3bjE4dEtWSXdJTlpsNnZmQTNT?=
 =?utf-8?B?RDVtc2Q4TzBMK3Q4b2dDQ2J6OW9IRFQ4MTF6WDJUaldQNG01TmltWnZXTTJh?=
 =?utf-8?B?eGVVbVpuNytLYjN0ZlRzR2Q5VzJRVTRya2dQSlgwdkFpK0NGVGxYVXRRVWxu?=
 =?utf-8?B?ZkxTMnMyRVNQbVFHN3NSaU54WmxnM3dLbDFTYWFYOVpqV0RZaDNEQlY3YzVh?=
 =?utf-8?B?TWQwTjltaDA5K2JQQkpvNFJ6UUlDa2NJdTdsQWhpMklEdnNYNHlhdGNkRFBC?=
 =?utf-8?B?N1V6VDJTRTZTZGhPWVNMTnhCTHJieWVwcmxVQUdJMkJBOHRxeFdHRldXSXlk?=
 =?utf-8?B?L1ZzY1hZK0pmL1cyRjNsTHNXeE44Qmc1RHZXcDZYL1BiTXFYWWRCUjNUMlZF?=
 =?utf-8?B?a2xQaHZOalJRQWZWVDJRQ3ZEN1B4WkpqLytMSDRvQ3R2TlJCTFVHbndsOGtl?=
 =?utf-8?B?RlBQRDM4UGFkaGkrdENBMkFna0liZUlKNVh4RzVxaEtDRWUvVXJUT1NCaElj?=
 =?utf-8?B?ZzcyTEFCS3B1VW9vMzMvSW53blZHVEJsRS9jWFdwQ2R6bFFKWm5OdngwQVUx?=
 =?utf-8?B?cUpnM3N3L3prR2RyL1doWnRKNTBrVTV4c3lTQXNhRVBRV3V3VktSeGhhUmkx?=
 =?utf-8?B?cjhQWVl1dkFmei9MbjFiL09rUCtERkl0ZVFpT1NlT0Vmd2VTTTVxRjI0dlZO?=
 =?utf-8?B?QW4zRDlBTDBsbzNVa1lxYkFoMng4cEVYTi9hbWdSQnVQdGtkZGhxOStVdlM5?=
 =?utf-8?B?cnJrMmI2M2l1V0ZDeUxEOGtuMGd3WG9MQ2RObFg5bnZYUUd1Um1Ca2ZxSVNS?=
 =?utf-8?B?TWJwVHN6Sit0UzJ4SkI3Si9KZEx2S2ZBbENyNlBWREhNbTNDdnNBUGhqZ2p6?=
 =?utf-8?B?MGRGdnZiZDBaOGtiNXhwTk12eDdYN2pPZFo5MXFSZmxUN3RnWGlvZkdtcTJs?=
 =?utf-8?B?cnZWTUVIOXZrVkFzNjJnYmxibU5UL0h6T2FqZlRtek5TSTU2cS9RM3ZCZTNC?=
 =?utf-8?B?RW96aWd2NGVqbFJJUUgwZzkxeWt0NzVKWXBpMmRWc1pKQndQY0hiVXhtVUpY?=
 =?utf-8?B?QXI2VGlJTHh5TTB5cFZPR2x6WGdNcEU4bXlhQU9LVW9TMmpYNlgvOGJhamtY?=
 =?utf-8?B?b3V2R2ZkVVQ1cEF5L21kMmxIQno1R1lURm1jUWhsR0NQKzhwd1NEZGJHS3M4?=
 =?utf-8?B?U21RWlFsTmtzQmJNckhwc1lnMUVpTFVCUGtIODdTbmxsa0Z2Y3h6THhKVVpQ?=
 =?utf-8?B?MG1sRDBacllvSXVIREFiVWJ3eDRsNGg4MjZhakdzVHZJT1pPRmpUVmZmUWpm?=
 =?utf-8?B?c3hZNzdPQXllK3h2cWZ4ZGRrRmNaN0JkNTY2Z2VRUnhkNGJQc0FxbmFpZzdX?=
 =?utf-8?B?MlRjZENaYkwrVTB2ZlBSUnBLblZ4ekpaZ0c4azRGM1lCdHFESW5YbThYRmdQ?=
 =?utf-8?B?eEdXSXc1WEhXSzN4L3JObFFPa1RpYjFHSERRSlZqZzB3S2IwWkZyTE5va3Zk?=
 =?utf-8?B?VThwNkJKKyt3SlYvZnNDQytieUdUeVkzNVYzaEVqYXNoVzNHT3Eza2Z5Skx3?=
 =?utf-8?B?WGdFTks3eGJOQmIwcjBCdmlBd1VzNk9LQUhDbm5MeFhLdzVlelFidz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	amE25Z/JEosBrjw5HbWRSYVtSOv36upcObNC2CgQZcqe+aoItqMwk6NNfr1AbX79m3Yw5MbhVJxlhQtxAR8CTigPZIF3P3yiVgU5OgPV/jyy1Y6NKq9SSLwUtM3x+Tp91SGp5o1A60WvmHJHeZ/le7lgDMD1FmZYXHtq8nFX9TEFRpYP2bneNZAXeTEWbxXUuqAtvwUivp4lbyCpUGM7TsJsDSSErhOsfRnor8nGPSdsS4u/Lt62HW01wtaK4s7ihq6JfpRA3bWhYlTx+2nNFkZwgSD6qcyUpMwopzvRJAlODNWRYYEO5i7K6d4Z1IYABk8VIFZXac8ZkOMPTZaQtH0ECU83fGGE2wHCFaZyI/hOqe4xg2JfVQhK3a3KmLNtZEwLSJU40V0XYpImdQWlNfkdYG4PZQbTwWU6Sl7Mrx+YQX3quqoxlHv44D4OCRUZ7oyzLSXAMRWz8SERkWCUrc6N4BUcrqI3wNsY+2Q0Bm9nO6KSxuqMGF8nMOP0l+dg9lTuI8Z4qGPAdAS3daRZA9n3BVN26gNl8boYT9zeSAtD477tWKmYy1mLzulJLbt0fJjrtJ7ARrLJGFLq+RouQ6qVYjQ/CVvv8lVx4yTf1gM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 394326e6-cd7d-4d40-f960-08de7a05992a
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 15:49:19.7840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qw3qGGPBIhyv/0x8gJ9wxKXhJVVLOovx6V7iJZ7XG48BUCeDbxB5bmw00Yix8epU0TVp+eT3osGd3GdcbM4qNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8163
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_07,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603040128
X-Proofpoint-ORIG-GUID: jp0x4ejQe2fXcnZgwuK_YVSxXxefBLUN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDEyOCBTYWx0ZWRfX5vrkasD5uN5j
 EWOThN6o9/jG2fvdpGpMAoFKBTsnFnxggaCSH8+z3e7pucGjBX98jj9o0YJi/kqPFU9xOXIcU01
 kcsCzs5E4c7nfDqSOQJs4CwNU0ooKjMNXj6O+MXiCaHGkX99fl9P5kfjY+3e0b7Dkd8VoTxFbWT
 aQbbCrqUPY/p7BQT7sU6ZMv0o7M7lNtCbTG1P0lO8CoRnYqKfXwUAAg6HD4TU7QxInbenAuplAd
 nSVmDDUeLimMNVooHmLRmUyF1h33Up3JJXjBCbu2DciKDaU8opie8gVelJoOSj1/zNABf3WncNt
 xp/NvQ+BAXPp2jxy8vfBZgJF7z9FIvZ6KtcKY70pCSBPWDxexq+XL9nzFPzWwuDEM1MSTpLS5DP
 wjZBFo3/OB+s7NSK7Oph4Uikk1mqCfE/avG3oQ35b2C97f0KpLs3R9a7uVj6HvGpwLLZmzB9GND
 7WqXNi1nx2sqXNCn3HkqA8gBOEafOrnLXvEod2g4=
X-Proofpoint-GUID: jp0x4ejQe2fXcnZgwuK_YVSxXxefBLUN
X-Authority-Analysis: v=2.4 cv=Xb+EDY55 c=1 sm=1 tr=0 ts=69a8548a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=dsmUnGJxNMzG7wMPBDQA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13812
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5FF6E1C000C
X-Stat-Signature: t65ccd91ikmhcthwam7ijk5j3nhz493q
X-HE-Tag: 1772639415-722921
X-HE-Meta: U2FsdGVkX1/f/w5khoQ97PJ1xBdObkodsZLBGMIwZcMMm7RZ+cT7tXtQXKx8cgj08bNQViwCCxPUkKRrsORKYBu4d9oNAZMrCrLnpmAKW0p2zY4wZb5OA4Ic+JVhgUJcSPY4gabBt6LToNg4IoYZVkVLXocHYkLPCB7hLoc+L9xbHnq1qubHebTTxOKi5YB719Lp+n+UZu0wRYQkkxFJYnwbUqBly4gRlaQbN33l3r81R4ix7dN4N7E3c2CkaVo/eGHEN+4DE8n6yLZ411kdmNEqIC1nByORTLPEQS/LtidW0clqfn2yir8eqDgRQwPJ1J0jKCvI8KwrWAQZ8BbUwLY6hJgxsChIj6tHTY2atuMynadO9BxprE3UFi/HaohqeKRzLip2iuViyDJqeNBZ/gDRK83ry+vyuW1juVzRDYnN9Z8AsNcBeO4wQky6/mkn/vKQ1ricr56Lg9jil28kHRZUmXdlS/nf6U0WahmODxUb/wIu1uh14W3Q3xDG7YCC8pkhZdAp+P9zUS/fl9krFlznO7kz6YuuACuWb7/WWvcxo78/6OfDSbkuQp0h2QbdiyjDag2+D3s5gT/LZjC1Jy6fDOrfNmjCjcn22o3x1rGZw9EPf7/0aROkYMADQnOfP4zowRUr467gAm/Nli9NckXNFKfs0eKCZkAgoI9zjT5v1J6TY1um8lX+cqHIu3sExtwMEypZuFU1MtgxgRPavDfbri+LtzikjqiNiltQAkoTL36YdJnOJqK/T6XGOWKFAPaUgzZPlwp2t4Ir+KE7f0d6U6y5aYGbkSqcMPKb7/ZpXwkDDeYBBhjoMDFINywO87ButO4qrb1vWJxRWs/8OUmDq/2AwRdVAI3zQX/5uFK8xSWAJ7Ono01bOvpV+yx+dui7n6lpbonWxdiRg3mQOP1KwFfa4wRJPWZRtXMVCbW7jF3lowJDAcJ6Q86F6DIaIA6cRj9wsqAgw925o7m
 JWekJtqb
 ApqpxcpAOhyAtD/RfqUFcfLseizwjHjBTmmdJoMYAHRlVGYnI/VMYxxCHW6Y6sVBQQZGaiCLQljuKKECrFE/lyL/iIQFM6q3IyS/eeLbb3IHxrU8EZk9ne2YvYbaiYcBf6mxXFY4aYeKOUFFYZpUgTp83f1VsPE6tK6tCkHJZd32yL0tVvGBehxjkp9CFfdHRQnjDgsKCXFUXCdjsqr+DEi1NUp0ISXXlJWZ0Ycd5ZFm+HrGEjnlzVAmav/XAe7NXdxoS7h5Z4Gn11Vl4vBkm4kZBc6xjO/6UA6dzd3vped8nwQnOivCZaWHul4V9V7IMqZFAvaTpPPH/iYPKlmXToPYR8FaE0e+9NqIDBe78iHsxfpLnS/ARry1t1QLWM2W+eCMXK8C6AoKvZrU/otQh72BjgoAU3GUpo8RouN8Nnc0+/dTwz1qFYdz8zRUip0NRwASnzIGrgw9XD58RqjIQqFPWlfFtbKGZOf7EO5xoCxwzGgLTcOgXcx74CrmQfsfKiAHRox+T0nFoG5HEqA4TNbYexOrZQpvKTojlf49yluF5FenrlnExImC3GV16RC9Y6fOKDtOuV6CR/prERTLs3UKsRalGxjDJus1Nh40UTJMTqg0U8yZloNZwoZ5CCzRcQXaN2BMuDlT5fuiZOwl2T1/A+zUE1xcD9zVEtfO47WG/HUUS5ZDLqry7CzC2WyF1JzFD3QP5W+LeHAm/1o9Y+PsE+7ZZeAhBqQRDIE+0YZpty1Fr4ZgIqgyg8Mra2JqYVokaUQPxvULoEun4N8BclK6l4JYE0chd5HbQIyJtsU/XZW3wKfPzb1TAASfRANC2v5TnhB1uD/hxhPzJcc2NchJ0RE3UDrWESKoedbjezPTGj5SYAqqBMyHQ6sH3hy/6MJNxEBUc835X/oRzc+ChTwZrIdIgK/BfxycAQQy6S9aDR2WAO6Gih8X8aMppndTRC8oeM4r/dFhZhm+6hvedj1OykdrI
 kuLibwq3
 xY1R+wADuoj8JUHOfbmFe0gEpve7GX2frtC6t68GW46DVvvrwS8gjdXF4S2h9ILosCBfOuxqjCczqCBmD3njqZXzI9wyyUixcDiGLaQH2AJD6JDWkZdIJIXaXreDhh9eQ3htSbQNggts+DNOK9EQBESPgmYvc2qeb7txmJEisRQWc2FpfEc3fqBhy4XezdWMo1ueb8AJxisoeTkBIPIOi2pSPYqBdaLhygPx8qMpfpaIl/b14laF5KhN9VP3AvmZgEUEGDInI8s2TfE4Yi94kJYinj0L/pF2VqbjesludBK+5aNV5uLM9NdWJUMIucO74B1KZfV/0vtlg1KeDWwiHH1kdIyEVNOBCI3nfi5yqiGfT0p+aG0of+52zsbVmXH1qmacqcELrDXUkLWuhVPSvxxUMk/pmZlrif7gzPohVhffzfBbIbzibNvpK+REKlq/arfjTZU8B+rHPoArfFFVSepI40fIx9qjIDLEXpwrcFXqEFv/GHwJO1HWG/cf68en5HPudmR0jHDlnt80rBFwT1TYhOY3whoTpFO3aqkpLkgSOkY1CRZxL/T1wTxuLqvs/h1/jmihxZmNljSCR0mzgecAsicnHoCJXt81xy3Q+w4vCUF+Ghz9yXs83cqJDln9LS+kMTf5T4YYUy8l+QBlohKC0FztGkf+EzlchEPmH6tgvx8Q/6/+g10VEBZ2LjUl1bJhAywBk/IouBc8IC3s2YDcvNR97ef4IvokmPjUP+Cc2juzXvVZIB6CY231Im0KKf7Zei5wQ21yCcdmUJuu2YWVz/ilA1xYFnysGVaCRsDhGqdqyQ7+SvFOAWWP0yuT3p4pju0fC7kijQbpBceJQNi+WYf35iapx96DsmCrTfnRbSLkSb2dVRvGM9luVaKR3Qzzlxofg6cxm/3MZt8hLw4Y+YfJ4yY3g1WjYbwB0pX3EUAr5dpCHzsjTuNuu4q4rLRzuBNqapBn+hRBkqJva+jObofy6
 CC+rlyVn
 +11vbYR6MQR3xzGw8UmiN3wIaLRqi9b5Oby4pfwtdb81bXz/uFmfBn6loj4a8xWJR6hjxneo1SGzXOK/8G84hLjWenCGbMkWbo7rEfnzVxY+OdMTbdaQBqx2XEW+dCsTBybwp9y9i6cSHT1oP33UsYLxskGam+egJlc2sda5CABsZ7bFvkB5Qx59zZaheIoGKMuEgFndP13aKNAcSEP1jaDbkm6Ltgbila/P3uPrLDdg8HlcknIegST4825lVnCm1BnXKEsbsKrT989yhu91O6HgyPDYWPDORwMCVedfbmQ67GsZ241YVFWD+ukzvvBpIrqCTt6BHgh0ErCpp8s3o6hhYV6ZFvTRfUawfG0IEyQMjbTy7kcwg3xkfK49BIHf0wLr2i9wDAHo0PrHskv2gKEMpX4Q7Cipf6tv4hJfO4ZF3ckvTuE6zbfKTZODTveWv0ZEyxS8hRPWzU9ekNDTxA2ah8r5wNi/F+zlcr9zHtNa+Wavio+TIx7/kCG1rSx9mEe8cpZp20ypqU6l+9T1MDEO1BzGlRAg4O1I+QnimDP7OtMrPxNSWLNTnjHnIkH7PCZMVRuj2RgDI+BFSnR/2zUwvoWsErjhUbjtuffgj8iQoH6d5F97WCV90tG+eTszMDuU1r/tP7QDmekBvPUlT69XSIHRiANwp1TJ/C2hLvtQKNGCYEgREY1lX0PhNgLijcW9KmPp/m6JHPvuU+m8NzyMCHySeG5Ve+RuhKSGtni4HDSsb2TFQ48Pdik6L5Z0elC1RGMIo3RbS4vOSQ+l08xwav3SzSQvZxuVaMefuHu8xiOFHszNsilwlDAPNL8m+jHmRGtp4sI+Ywei0HWicg4IGpGE/RQESDR49KwPMbtCgsie8N05OaNFBboaoqtfG4vVbNA4IajDJrUgjPuSTk9Cp/ZUFRjmQKuk3JdNUik/cqR4qBCTfcZmwAVVCYnQPnAMhOLBjK+jK7knsZGX2rpQjGMIt
 3bhSc+67
 7mYOLCftuOAorYFeCgTeLQ8PEoUZlkm5EK5HIOUWsCvqLUR21MVqsZXMx9FQEjsu/GO9ZkhHDv5aIRMAoRfTuVJh9BGQZU1JjBIr+z7v/dL7BErH/zug6UMNaipFpeUUr4sSO8Hxz7HnySC+v8Li9UJFziHVoeJAgG0nIwpWt9jPoxLUbgTfcsk+5/Hc9TImpTa7yUONNxNgtKILq+MmV2FLftUXUvUxZxU4go1sm2zLMCQ9T95nsAqWoSgBAF313cAf+s7gRaILpNzTeiXfqH3QSxC73RTua2fjs76odv9sts2k1rV2hs+P2U5fSvjytGY4P2jHdJWBSi9cHT+1UnMzINiWo1tixfW1ac8fZisib9uk+kagrmt/LteZsN1ky56c5r2vll1OfQlday1mW0TjJPjHwZyjJRrfDVOrbbo03wQIyqcb5dvUFZ4qpxg6ByosHb9Q2h3gk9e7WARy7w/NnSXst9QHh1pEST8KBqhpq+ntLVCFJw8Y3qar15BrOxPZccApyPcI5RxEKA1qRo+4s8lzNh+av8h00keVvDbjoCwsfum5ERZsPy8jfvDh8HvsbYpTAkEE/D4ADsMDmf8gQLO/V1N25S+0AsE0rw0KMRTNdhQ7t6Xf50pNXusNpdbUZGkobgafXChaoIyLOM8tFRhthDTI1Zrrf7KswOXDe4KLiV7gLAN49aXjUKMyITDsz5P7knBMWOEqAxza6k2XZeaiMCYMAjm5UCn2eHWq1BR/F5P90c0fYE4vPoFEV/1vW4eOJe9mziIwa0hT7v0nz9B+2NH+jzMtbMXvXq6bbxaUqkMVc64A7YP7j9GuW1WKMX1JWXBjnlsvcKOiOF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/4/26 10:32 AM, Jeff Layton wrote:
> On 32-bit architectures, unsigned long is only 32 bits wide, which
> causes 64-bit inode numbers to be silently truncated. Several
> filesystems (NFS, XFS, BTRFS, etc.) can generate inode numbers that
> exceed 32 bits, and this truncation can lead to inode number collisions
> and other subtle bugs on 32-bit systems.
> 
> Change the type of inode->i_ino from unsigned long to u64 to ensure that
> inode numbers are always represented as 64-bit values regardless of
> architecture. Update all format specifiers treewide from %lu/%lx to
> %llu/%llx to match the new type, along with corresponding local variable
> types.
> 
> This is the bulk treewide conversion. Earlier patches in this series
> handled trace events separately to allow trace field reordering for
> better struct packing on 32-bit.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  drivers/dma-buf/dma-buf.c                  |  2 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_object.c |  4 +--
>  fs/9p/vfs_addr.c                           |  4 +--
>  fs/9p/vfs_inode.c                          |  6 ++--
>  fs/9p/vfs_inode_dotl.c                     |  6 ++--
>  fs/affs/amigaffs.c                         | 10 +++----
>  fs/affs/bitmap.c                           |  2 +-
>  fs/affs/dir.c                              |  2 +-
>  fs/affs/file.c                             | 20 ++++++-------
>  fs/affs/inode.c                            | 12 ++++----
>  fs/affs/namei.c                            | 14 ++++-----
>  fs/affs/symlink.c                          |  2 +-
>  fs/afs/dir.c                               | 10 +++----
>  fs/afs/dir_search.c                        |  2 +-
>  fs/afs/dynroot.c                           |  2 +-
>  fs/afs/inode.c                             |  2 +-
>  fs/autofs/inode.c                          |  2 +-
>  fs/befs/linuxvfs.c                         | 28 ++++++++---------
>  fs/bfs/dir.c                               |  4 +--
>  fs/cachefiles/io.c                         |  6 ++--
>  fs/cachefiles/namei.c                      | 12 ++++----
>  fs/cachefiles/xattr.c                      |  2 +-
>  fs/ceph/crypto.c                           |  4 +--
>  fs/coda/dir.c                              |  2 +-
>  fs/coda/inode.c                            |  2 +-
>  fs/cramfs/inode.c                          |  2 +-
>  fs/crypto/crypto.c                         |  2 +-
>  fs/crypto/hooks.c                          |  2 +-
>  fs/crypto/keyring.c                        |  4 +--
>  fs/crypto/keysetup.c                       |  2 +-
>  fs/dcache.c                                |  4 +--
>  fs/ecryptfs/crypto.c                       |  6 ++--
>  fs/ecryptfs/file.c                         |  2 +-
>  fs/efs/inode.c                             |  6 ++--
>  fs/eventpoll.c                             |  2 +-
>  fs/exportfs/expfs.c                        |  4 +--
>  fs/ext2/dir.c                              | 10 +++----
>  fs/ext2/ialloc.c                           |  9 +++---
>  fs/ext2/inode.c                            |  2 +-
>  fs/ext2/xattr.c                            | 14 ++++-----
>  fs/ext4/dir.c                              |  2 +-
>  fs/ext4/ext4.h                             |  4 +--
>  fs/ext4/extents.c                          |  8 ++---
>  fs/ext4/extents_status.c                   | 28 ++++++++---------
>  fs/ext4/fast_commit.c                      |  8 ++---
>  fs/ext4/ialloc.c                           | 10 +++----
>  fs/ext4/indirect.c                         |  2 +-
>  fs/ext4/inline.c                           | 14 ++++-----
>  fs/ext4/inode.c                            | 22 +++++++-------
>  fs/ext4/ioctl.c                            |  4 +--
>  fs/ext4/mballoc.c                          |  6 ++--
>  fs/ext4/migrate.c                          |  2 +-
>  fs/ext4/move_extent.c                      | 20 ++++++-------
>  fs/ext4/namei.c                            | 10 +++----
>  fs/ext4/orphan.c                           | 16 +++++-----
>  fs/ext4/page-io.c                          | 10 +++----
>  fs/ext4/super.c                            | 22 +++++++-------
>  fs/ext4/xattr.c                            | 10 +++----
>  fs/f2fs/compress.c                         |  4 +--
>  fs/f2fs/dir.c                              |  2 +-
>  fs/f2fs/extent_cache.c                     |  8 ++---
>  fs/f2fs/f2fs.h                             |  6 ++--
>  fs/f2fs/file.c                             | 12 ++++----
>  fs/f2fs/gc.c                               |  2 +-
>  fs/f2fs/inline.c                           |  4 +--
>  fs/f2fs/inode.c                            | 48 +++++++++++++++---------------
>  fs/f2fs/namei.c                            |  8 ++---
>  fs/f2fs/node.c                             | 10 +++----
>  fs/f2fs/recovery.c                         | 10 +++----
>  fs/f2fs/xattr.c                            | 10 +++----
>  fs/freevxfs/vxfs_bmap.c                    |  4 +--
>  fs/fserror.c                               |  2 +-
>  fs/hfs/catalog.c                           |  2 +-
>  fs/hfs/extent.c                            |  4 +--
>  fs/hfs/inode.c                             |  4 +--
>  fs/hfsplus/attributes.c                    | 10 +++----
>  fs/hfsplus/catalog.c                       |  2 +-
>  fs/hfsplus/dir.c                           |  6 ++--
>  fs/hfsplus/extents.c                       |  6 ++--
>  fs/hfsplus/inode.c                         |  8 ++---
>  fs/hfsplus/super.c                         |  6 ++--
>  fs/hfsplus/xattr.c                         | 10 +++----
>  fs/hpfs/dir.c                              |  4 +--
>  fs/hpfs/dnode.c                            |  4 +--
>  fs/hpfs/ea.c                               |  4 +--
>  fs/hpfs/inode.c                            |  4 +--
>  fs/inode.c                                 | 13 ++++----
>  fs/iomap/ioend.c                           |  2 +-
>  fs/isofs/compress.c                        |  2 +-
>  fs/isofs/dir.c                             |  2 +-
>  fs/isofs/inode.c                           |  6 ++--
>  fs/isofs/namei.c                           |  2 +-
>  fs/jbd2/journal.c                          |  4 +--
>  fs/jbd2/transaction.c                      |  2 +-
>  fs/jffs2/dir.c                             |  4 +--
>  fs/jffs2/file.c                            |  4 +--
>  fs/jffs2/fs.c                              | 18 +++++------
>  fs/jfs/inode.c                             |  2 +-
>  fs/jfs/jfs_imap.c                          |  2 +-
>  fs/jfs/jfs_metapage.c                      |  2 +-
>  fs/lockd/svclock.c                         |  8 ++---
>  fs/lockd/svcsubs.c                         |  2 +-
>  fs/locks.c                                 |  6 ++--
>  fs/minix/inode.c                           | 10 +++----
>  fs/nfs/dir.c                               | 20 ++++++-------
>  fs/nfs/file.c                              |  8 ++---
>  fs/nfs/filelayout/filelayout.c             |  8 ++---
>  fs/nfs/flexfilelayout/flexfilelayout.c     |  8 ++---
>  fs/nfs/inode.c                             |  6 ++--
>  fs/nfs/nfs4proc.c                          |  4 +--
>  fs/nfs/pnfs.c                              | 12 ++++----
>  fs/nfsd/export.c                           |  2 +-
>  fs/nfsd/nfs4state.c                        |  4 +--
>  fs/nfsd/nfsfh.c                            |  4 +--
>  fs/nfsd/vfs.c                              |  2 +-
>  fs/nilfs2/alloc.c                          | 10 +++----
>  fs/nilfs2/bmap.c                           |  2 +-
>  fs/nilfs2/btnode.c                         |  2 +-
>  fs/nilfs2/btree.c                          | 12 ++++----
>  fs/nilfs2/dir.c                            | 12 ++++----
>  fs/nilfs2/direct.c                         |  4 +--
>  fs/nilfs2/gcinode.c                        |  2 +-
>  fs/nilfs2/inode.c                          |  8 ++---
>  fs/nilfs2/mdt.c                            |  2 +-
>  fs/nilfs2/namei.c                          |  2 +-
>  fs/nilfs2/segment.c                        |  2 +-
>  fs/notify/fdinfo.c                         |  4 +--
>  fs/nsfs.c                                  |  4 +--
>  fs/ntfs3/super.c                           |  2 +-
>  fs/ocfs2/alloc.c                           |  2 +-
>  fs/ocfs2/aops.c                            |  4 +--
>  fs/ocfs2/dir.c                             |  8 ++---
>  fs/ocfs2/dlmfs/dlmfs.c                     | 10 +++----
>  fs/ocfs2/extent_map.c                      | 12 ++++----
>  fs/ocfs2/inode.c                           |  2 +-
>  fs/ocfs2/quota_local.c                     |  2 +-
>  fs/ocfs2/refcounttree.c                    | 10 +++----
>  fs/ocfs2/xattr.c                           |  4 +--
>  fs/orangefs/inode.c                        |  2 +-
>  fs/overlayfs/export.c                      |  2 +-
>  fs/overlayfs/namei.c                       |  4 +--
>  fs/overlayfs/util.c                        |  2 +-
>  fs/pipe.c                                  |  2 +-
>  fs/proc/fd.c                               |  2 +-
>  fs/proc/task_mmu.c                         |  4 +--
>  fs/qnx4/inode.c                            |  4 +--
>  fs/qnx6/inode.c                            |  2 +-
>  fs/ubifs/debug.c                           |  8 ++---
>  fs/ubifs/dir.c                             | 28 ++++++++---------
>  fs/ubifs/file.c                            | 28 ++++++++---------
>  fs/ubifs/journal.c                         |  6 ++--
>  fs/ubifs/super.c                           | 16 +++++-----
>  fs/ubifs/tnc.c                             |  4 +--
>  fs/ubifs/xattr.c                           | 14 ++++-----
>  fs/udf/directory.c                         | 18 +++++------
>  fs/udf/file.c                              |  2 +-
>  fs/udf/inode.c                             | 12 ++++----
>  fs/udf/namei.c                             |  8 ++---
>  fs/udf/super.c                             |  2 +-
>  fs/ufs/balloc.c                            |  6 ++--
>  fs/ufs/dir.c                               | 10 +++----
>  fs/ufs/ialloc.c                            |  6 ++--
>  fs/ufs/inode.c                             | 18 +++++------
>  fs/ufs/ufs_fs.h                            |  6 ++--
>  fs/ufs/util.c                              |  2 +-
>  fs/verity/init.c                           |  2 +-
>  fs/zonefs/super.c                          |  8 ++---
>  include/linux/fs.h                         |  2 +-
>  kernel/events/uprobes.c                    |  4 +--
>  net/netrom/af_netrom.c                     |  4 +--
>  net/rose/af_rose.c                         |  4 +--
>  net/socket.c                               |  2 +-
>  net/x25/x25_proc.c                         |  4 +--
>  security/apparmor/apparmorfs.c             |  4 +--
>  security/integrity/integrity_audit.c       |  2 +-
>  security/ipe/audit.c                       |  2 +-
>  security/lsm_audit.c                       | 10 +++----
>  security/selinux/hooks.c                   | 10 +++----
>  security/smack/smack_lsm.c                 | 12 ++++----
>  179 files changed, 607 insertions(+), 607 deletions(-)

> diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
> index 8fdbba7cad96443d92cc7fdeea6158c4cc681be1..d2259d948cc33e1c192531d34679123b826cf4dc 100644
> --- a/fs/nfsd/export.c
> +++ b/fs/nfsd/export.c
> @@ -1039,7 +1039,7 @@ exp_rootfh(struct net *net, struct auth_domain *clp, char *name,
>  	}
>  	inode = d_inode(path.dentry);
>  
> -	dprintk("nfsd: exp_rootfh(%s [%p] %s:%s/%ld)\n",
> +	dprintk("nfsd: exp_rootfh(%s [%p] %s:%s/%llu)\n",
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
> index ed85dd43da18e6d4c4667ff14dc035f2eacff1d6..ee72c9565e4fe85356674b22b4505d3d531dbe40 100644
> --- a/fs/nfsd/nfsfh.c
> +++ b/fs/nfsd/nfsfh.c
> @@ -601,9 +601,9 @@ fh_compose(struct svc_fh *fhp, struct svc_export *exp, struct dentry *dentry,
>  	struct inode * inode = d_inode(dentry);
>  	dev_t ex_dev = exp_sb(exp)->s_dev;
>  
> -	dprintk("nfsd: fh_compose(exp %02x:%02x/%ld %pd2, ino=%ld)\n",
> +	dprintk("nfsd: fh_compose(exp %02x:%02x/%llu %pd2, ino=%llu)\n",
>  		MAJOR(ex_dev), MINOR(ex_dev),
> -		(long) d_inode(exp->ex_path.dentry)->i_ino,
> +		d_inode(exp->ex_path.dentry)->i_ino,
>  		dentry,
>  		(inode ? inode->i_ino : 0));
>  
> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index c884c3f34afb044ee5cacc962a04a97de2f7fd88..eafdf7b7890fdee55ddf802d040363f33a7be628 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -1163,7 +1163,7 @@ nfsd_direct_read(struct svc_rqst *rqstp, struct svc_fh *fhp,
>  	} else if (unlikely(host_err == -EINVAL)) {
>  		struct inode *inode = d_inode(fhp->fh_dentry);
>  
> -		pr_info_ratelimited("nfsd: Direct I/O alignment failure on %s/%ld\n",
> +		pr_info_ratelimited("nfsd: Direct I/O alignment failure on %s/%llu\n",
>  				    inode->i_sb->s_id, inode->i_ino);
>  		host_err = -ESERVERFAULT;
>  	}
For the NFSD hunks:

Reviewed-by: Chuck Lever <chuck.lever@oracle.com>


-- 
Chuck Lever

