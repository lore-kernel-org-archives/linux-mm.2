Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C602FEC1436
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 12:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEF0E6B0140; Tue,  3 Mar 2026 07:14:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9C2C6B01A2; Tue,  3 Mar 2026 07:14:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 946356B01A4; Tue,  3 Mar 2026 07:14:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 82CAF6B0140
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:14:34 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 30101138EEC
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 12:14:34 +0000 (UTC)
X-FDA: 84504644868.30.B429E29
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
	by imf14.hostedemail.com (Postfix) with ESMTP id 535F4100002
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 12:14:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=crudebyte.com header.s=kylie header.b=HqDnIkLb;
	spf=pass (imf14.hostedemail.com: domain of linux_oss@crudebyte.com designates 5.189.157.229 as permitted sender) smtp.mailfrom=linux_oss@crudebyte.com;
	dmarc=pass (policy=quarantine) header.from=crudebyte.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772540072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6morsqL1rf2svzHpl7Mgcq7P7Za1rjxSr9X2GzDxJdQ=;
	b=8qw5aDwGFAGptjRohTswJp1LqDFPMkpndJg+cfgVOpdqgeuAKBpZEosA70mArNBz4oMQ1G
	55wzcINapMccC7PaNZNKK7hhXwgAfoRPHjyEGyDcr6VClZFkkkumt/YLjCDOA5+D9De8pL
	ZChUR24CjxPLeRqoQxkoeMEco54LVR4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772540072; a=rsa-sha256;
	cv=none;
	b=4LJ656OzBl2abdakjKWNw4+qqu2hiTvXMpv9OBqrhvM3fJC2DPGvYNMBePsaN9NJlKIKte
	t9KxSAOQ4RBVtIw/u0qylL2Aa/aTlyJ0AwZWVMoQoQ3eOKg6TKW6DLBVw3DZLzgcvS1TR5
	z1Vt9tSXO9LBgUo4EVRn9IiJ2DVGl3M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=crudebyte.com header.s=kylie header.b=HqDnIkLb;
	spf=pass (imf14.hostedemail.com: domain of linux_oss@crudebyte.com designates 5.189.157.229 as permitted sender) smtp.mailfrom=linux_oss@crudebyte.com;
	dmarc=pass (policy=quarantine) header.from=crudebyte.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=6morsqL1rf2svzHpl7Mgcq7P7Za1rjxSr9X2GzDxJdQ=; b=HqDnIkLb9g/Hsc8NjMh6Jj9WuM
	MzJbEDxoSbJB6oNviZ4lhLElZSwdxUq+F82IhdhMr3/l3EIr7ekENzTfWw1alK0l7gFMBknTTbllK
	rQiTpC5jrJRp5O9Y1BXau586rPz904ODCjVtDrL/S+fcUwcyE3KQHYPQE7yHCQgEDc8jdW2FFMvnt
	8BFo41dQEnn19Baat6muvD8WHIuTeXI5DV3hJWIvjJJnnIbJ9NBNkEHuffv8Z0iXv2/2WH2/hxxuH
	bQk7qyA82VKBDS4IWm4WLmrZDk/8F2VTqK9lWDvGIID23xeCtmOUbbOU5nkyVR/RcS3L+8d3GznDt
	Co3UvqraJhe1cjvRT3F0oMQn4owK/B7J/FhwdoT/TARifEt06mcA+ESiihNW/SIasrPSJHOjZxjau
	19CUACfNAgbx8938xysaW9hCoTK95R7R5EP2KKkB7w4xq+Xr5QZHTBanCME4DOR0egc7lmc8Iwow+
	6QdiLyA9W5tnh0qszmpT1je2sF3FDWXPdKIW8B5OWRyh6mmktdJOqx2KnWKFBZUmJIRSr0SYCgoEj
	OXekGpcPmr2OGrtA46WUBXf4g/mM8I/cnPWeWBCwtWVWaywFhrbuiZs4N+cAgdTRI0a7P2lT1kapU
	+AuwoWhfJXGO+AHTpCpSIxdbyzli+byB6v/wTaiSQ=;
From: Christian Schoenebeck <linux_oss@crudebyte.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Matthew Wilcox <willy@infradead.org>, Eric Biggers <ebiggers@kernel.org>,
 "Theodore Y. Ts'o" <tytso@mit.edu>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
 Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,
 Tom Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>,
 Alexander Aring <alex.aring@gmail.com>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>,
 Dominique Martinet <asmadeus@codewreck.org>, David Sterba <dsterba@suse.com>,
 Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>,
 Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>,
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
 Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall <hubcap@omnibond.com>,
 Martin Brandenburg <martin@omnibond.com>, Miklos Szeredi <miklos@szeredi.hu>,
 Anders Larsen <al@alarsen.net>, Zhihao Cheng <chengzhihao1@huawei.com>,
 Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <jth@kernel.org>,
 John Johansen <john.johansen@canonical.com>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>,
 Roberto Sassu <roberto.sassu@huawei.com>,
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>,
 Casey Schaufler <casey@schaufler-ca.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Sumit Semwal <sumit.semwal@linaro.org>, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 James Clark <james.clark@linaro.org>, "Darrick J. Wong" <djwong@kernel.org>,
 Martin Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>,
 Joerg Reuter <jreuter@yaina.de>, Marcel Holtmann <marcel@holtmann.org>,
 Johan Hedberg <johan.hedberg@gmail.com>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 Oliver Hartkopp <socketcan@hartkopp.net>,
 Marc Kleine-Budde <mkl@pengutronix.de>, David Ahern <dsahern@kernel.org>,
 Neal Cardwell <ncardwell@google.com>,
 Steffen Klassert <steffen.klassert@secunet.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Remi Denis-Courmont <courmisch@gmail.com>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Xin Long <lucien.xin@gmail.com>, Magnus Karlsson <magnus.karlsson@intel.com>,
 Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>, Jeff Layton <jlayton@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev,
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org,
 v9fs@lists.linux.dev, linux-afs@lists.infradead.org, autofs@vger.kernel.org,
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
 linux-x25@vger.kernel.org, audit@vger.kernel.org,
 linux-bluetooth@vger.kernel.org, linux-can@vger.kernel.org,
 linux-sctp@vger.kernel.org, bpf@vger.kernel.org,
 Jeff Layton <jlayton@kernel.org>
Subject:
 Re: [PATCH v2 069/110] 9p: replace PRIino with %llu/%llx format strings
Date: Tue, 03 Mar 2026 13:12:51 +0100
Message-ID: <13960165.uLZWGnKmhe@weasel>
In-Reply-To: <20260302-iino-u64-v2-69-e5388800dae0@kernel.org>
References:
 <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-69-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: uaxoubok6y76yct7iairjwcxwfh37w5r
X-Rspam-User: 
X-Rspamd-Queue-Id: 535F4100002
X-Rspamd-Server: rspam12
X-HE-Tag: 1772540072-182273
X-HE-Meta: U2FsdGVkX19IqgsohoK1Be4U5zjCmK3y2Q1H1JtbbYYMI72YuWYKYRKYfQWnaDvzaVE9gpLxAk1bHCkDxZvJaaX05VMxNJv2Tx4TxGENG6eM5qX88OzvyDxxNjLoPN7UMwnn7G6Ft8aLT/Vbua6EW8zYiaTAAP0xeJLGFXjYGFZ2IFFch2XkEckLFPZDJIxmN88ZqHrto+SyA1Pmv58SztJDJeyC50rJQkSWhnA6nUgiVKDIzpElxL9AxNnITPFc3fPV8AUM7kKEqIJt37z1XwvCyChvX0cLf/a5nVBbSSCnqjehyAn6xmZCSrxEIN7jSiilu202uDaY/trzY1V21Rtx1ZWbJhAdc2BvvmIKsVugQyyGAa4STO5zDcqD1RCIKkGS0GVbBE7gt9O3aop2bN273aKV+2pgeDVo18f1V2xfMCpF4iEsOvIn5/AWppuIVV+d2n3GHe/CafjIVg1j2muLpunMlgMpWHYr1YqOu6i0n3j3zq3Cf8EqFkXNca1l+LcQ5eH8dkmp+4fo/zZgoXvBPzI7amuoI54/allb6thXspMfs/SbTvUZfHyX4WqKcH3BXL6opxj/RDF8nrGcAW4epdP6Df6/WW0MGN/K4DJQObSpwvkXNolhYmxqxN2m6mFaLDKw+t62R59pFZKTg9uWMjLwm+KUZ03f+o/2Cdyq5lHt1r2ZJzaUQftvwVkQUdCdkeFipcfIIUtMlBMVYwBeiaok0G/5+kwL1GKCuEN5+Nd+D4CWn5F1kb9VQA4Si0kcdriSiA0be5GQJt9MwBMaPiKPCp+dO+28IPiKB/hJ2LtWw6YC5yQWnvYYYeYx7OR+MFgxqxwUjbRjJ5Ifz89iIbmQyIkND6smrXsNMsiBmJXDMHL7x+ATGf6zuwjoB0ycEX75Ormzu+GCA/OWHBzpxUhew4vSuZdE7Ot4LV5+B2V6HDWThV3kPnDuPJ5YtHvVly8t8WxVSa6oswu
 7zDOzqC0
 1cW8htL/NT3AGGlJS5pY9V53FOmwdfS9hFfIcLE3xQgEJTKoJl6DpuzpR0wuluRIHyoeTFmCzFW8W/0XCHJjqPvW6dgx0JDxktvc9+RvIZnMT98bIHVDzGJTzE8mcwj9Vu8cxuI5OfM4HD3Hw4nLQ+WrGOnimuozerUhM6UjWhVF5iTATs6zcLYPaVsQ1QCL3gB5cK5dDjx0oaMaX/SpOWtZMr0LivoqMaP57HMzt0HLFa++Bd5DgeEr93hZ6R3HfHM0i6Z4rbC8rdzMGdLDFQZ3Stl/t72MJWENbBer16yDFT9mwl2wYseMlhyHslDTicWQZOitBDaF4UEfXftzB2pN+AfHJ3O5ppzOvehaXMN9ZouxDsgnCr9B0E7jjYb5jyPRZ8iRCq7xBEhFZZzZLmd5MH29bQM7KPu/L4Ze183gZfDXd+XqesMjBuu+VejIpefoek3LkmEUapm/UwUURiJa+TLtL6ZE670WplQS3+8WDrwVsXr26DAQp/+VKhgXs1oRaXjNeOtMQJu2AVQ4BvIKBGrPrKgXuio144zGjwZf3pzOLOhh4Wfx8GndrumOj8XCv51TG4wCVInfmbi89bhDyCLV4u+5YufBQSiMBZPojl5BtPn8tKitO23Vd2jfeQi1kK8qyzMjeUE+GSeHbddSsiTDfiMMhnmVczBTyC52e2jn4yhuox9TzC3wKtGv+6+9RgUPf/DOXN5YQEKLa3c1uOOUxVnQQqShP0m63LPp+RRi93dUgofKXwJ/g//f3gBgFCTPkAFoSPmYWiZ+6sk/rryqTqW1ARSAaGFJV70A5I/QvOnIk7spndpXApwyviTup2k2wbeaqzfLuoKIS2VgQsPpcbDN71rMi0EyzKYDY092fVi28GQfJ3ckQAEvcmPtpwM+X4C7Ah+qTEU4uPFAHgJu6slTaEjFod/XlghBS40DsYMOAepqqqoA9Os9MHp7wjnOsld5Y9D9pb9HB3+RXiTSZ
 T8rU0wjC
 O3sPNHS0DLvDodN6zILvN1BGxFGNBqE+agwbAsSCU/J6jmQh4RwK0b2mVErdDSaEG/2YKVyOyXVvG27m3SDUbOxKaCpX2RN24RC631TR2QtxlsQT1hoW57V0kd8uLPFGPqlZX+8+0wgwt9/YxQn9NR7Moqhls45j1ow89aqhe+h1C+VWa0Ikwud7X1jLWd5vBuC+jF4ixQueiGf1LIAcqGVZvdq9rr578o8xmKLGFfr2LDbvRe+FDHrRffKh0mZJjEZ0zRhIB04tH8F83uYGY7DsEWBo4xzj3rhuqsBZXm5K3dmIgmxlubA+603Z7awZrbTXywUqmua1L27WPQxMTE5o2OXmJmISwxjXCL18vDtoBifs66Obw4+n4yCAdmgxL/JiQ3P2exLJuzgtjFJC4oFZIELi138mHfJ/8lEp/Pko63ZwoI5kvrXIESqRDzKD6rylAYdSf9jIELBVjk2Yr5ppkm7yY2S+Aa65DAsiJISvIAemIKctT+dTUg4JSaIId1pn602PN5OK2sasXn2BKB2kJEgHmi7wogmKMdfolnRbiS+fKXCznJK367Hh/MumJovbQSBprvvKWDjpThoYmrsIhrut6PUcunyyJfNZXqS1m/LwW7AtNB2JTWe+zvphz6s3CY5ZEX/n8dJiFABAGJTkkT+QfxOJ3rd8+6IlrRHvea4CmnkuqwZbK9Hjl1+0H6miemmwINAxzIM09XHsnEcC02nx0NP+pAv1wZAaJCNowd/AMNKfPKfKLPc3BuKAhh4P5E3cgC7Ph3xtoezBqVPfsCBUfCEE/2FVoJimIawCRAWi+jo3tmXthVc4XGX4SFto5UIzNNPaOvwEX0Jccu05id5OoRWzW5F1WXqRm1frwUoGpPfa7VAxLrg5lKjEXLNKQ+NBCVJ6YrOFvYonf8KUoAwm0tvSwSK3EFdOIaJgK9BVOMrtXNd7BrREaFDanyDhbXpbmfNt0DutBWrJGM/wvlNCC
 2l/UDO7B
 5PFIK6TAFOAZ2G9ZLBcP04v3bH3wryN7wJ84kXcEnFBWTJtTsiPINgPf4PhoQwDhL1UDK7zOC9asREb7NjB34G4q+qniskAq3jnjz7XfP69onVtC03M6DUfl4UB6H7s9pBohTkmSHdkmdDnR8haV3tlF4kTZX8w9YnGhDe6dKR/bodNcTmQl6ytRCJ8/b77gpQ9dwZKQs+hGvhNnf9/dldo1DPfAgjpHEW0Pkn5Lldc47axbVWRRVynEaWNlJhMVn6YIGNXhKYxVNkQXmJOL4MOCHonS9aEfgLPthqk7Ui6gelGEhiT3gLJZlrplsoBgl7w/DqES+rN8LVVhhZLDHU6DxLlVRhnMzyNy8Fxlm4B0uFGLosUzlv/tW7uDQptUQL5qi59r+zEQY+SESX8NSMXrw5zL2NrCp9699d91X/f1h76ZpC49KBSzTOLvBzZ0B9gdYWRUUjqDpesVHVoNlrsPtecNvLiSgsWTemOHlqMLNeNa4Mva3XSBILj4qy67pPbQRiUpgTpxBGx2RJULYCccfjOzuNmx72x/vnDXV84vctBno/wk1gIvPzNVTTWzAvQ1rAGkv4gDnVXoqoZgH+dCrkPXjLDw7EAYPEsMmkruxte1u7tKNBJnA5HgxGr/NQgu01l26h1Gj7X44NTgZjF81PD5kcWr/I9KlBpzrxZphHIhV8D7ZlaYe7VIT4jlxe0Pyj8l0uQLtvApVBiLqenhIjKJbRsFLBvEaQexCYipo6yhJ2N9J3jUXhbaLAJMyilyng0bE41DPMyjRRV/wV0osNDRzEyDGmoYXPXZ+r7SWHssMTYhQ4M69efBYTiOsw3jnTLUTS0IVJY6RsX6FPj9GT4ijDxk5Y56JThr97/G1bg6sZJP7tzBgP1IusLmkdd09l6WbouexNz7G/KeEYXvzTco5mF+mY3qnXXkuWcZCJrAaHs/jKkgYoqbSItqux/E7pzm8rR51OQWy/04cVuvH366K
 YXghCLmh
 jm5YYY3A0p+vEyJd+dhg9mLu9XbPHLqFGx9QC9w1M2/A8h3BMxuhgZoiHbYqwmwXmVVm/KpLCNA+Pc1Rx+86XvvUWAs/Edl4CmHF+1mY2v/mp6jh8FQPvnAoN68IEeQF8vETYIeKO51f93o+jFU4T1JtvWGdc8o1hz/0x3PwFMvI80xGBVM1VPBUPVP/32vCHPVJJ9ANVjGVgXcUGBj++Vnj24CfeRPy/aWIxl2kvSZq4MSkHXFc6glajQ+7tw6uTp5h1z33/TtHOcvWaVJ1ScVaS4FAStysThC8Y3GO+6ucKrwCXH53MLVG35WUmG6xlQMvsnb6JpJEeYid8JiH27m/ymO6xG4n+2Rx6+8rJXjrMDSwv8poAI1lWo0Ip6cD7A3fUWfbu7kp8la00AwQbZREESRYMVij0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Monday, 2 March 2026 21:24:53 CET Jeff Layton wrote:
> Now that i_ino is u64 and the PRIino format macro has been removed,
> replace all uses in 9p with the concrete format strings.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/9p/vfs_addr.c       | 4 ++--
>  fs/9p/vfs_inode.c      | 6 +++---
>  fs/9p/vfs_inode_dotl.c | 6 +++---
>  3 files changed, 8 insertions(+), 8 deletions(-)

9p uses the following macro to convert the 9p network protocol's QID path from
u64 (all platforms) to ino_t. The 32-bit path of this macro should be dropped
after this change, as it would unnecessarily truncate the value to 32-bit now
[fs/9p/v9fs_vfs.h]:

#if (BITS_PER_LONG == 32)
#define QID2INO(q) ((ino_t) (((q)->path+2) ^ (((q)->path) >> 32)))
#else
#define QID2INO(q) ((ino_t) ((q)->path+2))
#endif

You are not breaking anything, if you happen to send a v3, that would be nice
to be dropped, otherwise we'll handle that on our end later on:

Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>

I wonder whether that exceeded Claude's context size, or if that's in line
with the prompt specified by you.

/Christian



