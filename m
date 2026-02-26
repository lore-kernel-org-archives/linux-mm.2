Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7530FD8FCE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:04:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 561066B0122; Thu, 26 Feb 2026 11:04:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52B3C6B0123; Thu, 26 Feb 2026 11:04:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40D976B0124; Thu, 26 Feb 2026 11:04:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2AE786B0122
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:04:42 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DBE26C0220
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:04:41 +0000 (UTC)
X-FDA: 84487080762.22.CEC9444
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 181B3140020
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:04:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ME/XYMrD";
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lJ02/y4gZs0zdHYgnvIMhyk8aCHmXoHwnqi8QaUbMgo=;
	b=Gmf8efR/+qYm5jyDDlkMwUHo1QblTu+eWPaQVIfSjUO9vWPhxr1pqdiMAtQP8Jbep0FInU
	4lAbe3u7pH8cpj2dpkT7KG2hMuw17KWcBW0hTLH7sOjaieb6WIhpqHRmO9SFeNfsg0wQs6
	DdRS1N65qCKm3AESKvP9heDq3I0Fpfg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121880; a=rsa-sha256;
	cv=none;
	b=53QLY8cK9UEwNMXIi96USfXfdBwUSdcbg759+GJ5iPT+wAGCYc1axtsHEr2QmhCHenaVCL
	tyYjPq16Nu32hs4+85ofW9eRPPzo4/h9lCILSK+m2yPp0O6htxIGdaBQqriPglLXoPsbd0
	8QRtNRfmtrJZOYr43QECAcE53yV0hNE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ME/XYMrD";
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 60A6A6183D;
	Thu, 26 Feb 2026 16:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25D0C2BC9E;
	Thu, 26 Feb 2026 16:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121879;
	bh=/R13WlmCiqf+otA9FtjIvnhA88neDdZ1z3bo46wgKlk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ME/XYMrD0mbvHzirdHMfJIsfdtmPFxCfe6GE465X1RJF3PBm2jj4PJNJPYeT1iDOG
	 LbsRm0hPLRDwtyDoOgB+Voef7jG8Y2KK22baj2rjclEI6wj5ibMesgE2ai+NJ/UR7X
	 6+QUTAooFfBgGcyast5Z94iyXho7rgdTdHdAwiZsKDxD+igqWK/cnx7ELcaU3fYIRy
	 ng9wFCImfGsr/rZxhue+trQ/GIHKbB3bcg6whxFxw1Y2QglSKv4ojDEr74/nb1FFQ1
	 tYyPsAGjzIDRWCtNI5FfKR1Aw/GoyUNOpP4KvVJnARaeqTNjVtrA4JR7sRW9jnU9kC
	 8v15Pgqa22BtA==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:42 -0500
Subject: [PATCH 40/61] nsfs: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-40-ccceff366db9@kernel.org>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
In-Reply-To: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
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
 Shyam Prasad N <sprasad@microsoft.com>, 
 Bharath SM <bharathsm@microsoft.com>, 
 Alexander Aring <alex.aring@gmail.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, 
 Eric Van Hensbergen <ericvh@kernel.org>, 
 Latchesar Ionkov <lucho@ionkov.net>, 
 Dominique Martinet <asmadeus@codewreck.org>, 
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
 Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Mike Marshall <hubcap@omnibond.com>, 
 Martin Brandenburg <martin@omnibond.com>, 
 Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>, 
 Zhihao Cheng <chengzhihao1@huawei.com>, Damien Le Moal <dlemoal@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
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
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
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
 Martin Schiller <ms@dev.tdt.de>
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
 linux-x25@vger.kernel.org, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1097; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=/R13WlmCiqf+otA9FtjIvnhA88neDdZ1z3bo46wgKlk=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0O+wdqUvmhdzWRUaf/uRFQdKMMnnQ4hzPLX
 9J0lNA/txOJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtDgAKCRAADmhBGVaC
 FReqD/wINOu58ZOathcZxcR1CK7TMnX0vxSOJoULS3X1jMBCONSGbKTI4Mwm0CSAxlQ98Ny4Nnn
 rtBtuGY3VRIjCSjO47+h7GQ1YV0V6Hc+rMhcOISbfMFy81P+loguWdTSkab9YblDvqIBIo8D6MI
 aeO7eQcn3P3Amz+zf+MJyA4wHMa6kUeyvW9ZKGd0CGk4Nbpc2hWw8vyhzqBOW/Zowk/OAe9T9OD
 fi+nNVJoTHG5Noq62obje8GhGhhYR/s5tI7dhXDVjhEpPGT/sFn5ElbkZwU7xptq2KT4yauQ7/Z
 DicbI1P6DJ50SqUjzuGz935+4TaETa7GtJyOMH5p6f5NVnl9iAPRms08XEOh7yI92eChFW7TmWw
 UWmDE4w7QRmZyyfOTgl2q06EuSTKCXIEbyGz5L/24Gim9RqCoV48oqVEnIg/sAFpPzo5xi5BIXf
 V1O08+55HNciUF+beE4JnOTS0c0eA+gQG4KJKrK/vP28C/zZn1ASyS4G2vPv+b85tystcOOUs2y
 g3wQEGVlU4mGAe1eRf3tPrndsga/Y72dzsCKqLqF9DyeTNT7ZSXa6UQ06Ih334PtgWGBjQP6S2p
 ZL32WssPTyas96P4SaYWACeakyldlGnUtNJrwKQoqVchA+l5uktGdxteZLiNkIHXVwmcaZaU/Ql
 kKqNMyGtdnhOPGg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: 181B3140020
X-Stat-Signature: fws4zu7rm8579w9y8f5kzspe763qeu7c
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772121879-927521
X-HE-Meta: U2FsdGVkX18xcRJqBp+haCCdUDb42YtQuNWQbYrYM5tBUfiZ6RCyVDuImNhSwA4P+T54Q2AIdWmFTfOSikJYrVps7oTgvMZGMct3nVNod2KRvKgh8hqpxitmZF/kVkzetzx6YqeFkCmqTNxHfLAGSSdevUlHApV1ALLdN7S9RBcfVWiQOmdyly2cU+FzxbZrv2RLyBkZF0IbOXcJIFsaC6coSjgr8lIu8GFjnE5yYZ/Hn5pTX6uJjxOUmHCaRKYKwhUWFXoXvTdrn36IlcauNqTjn9p720FgVrR7BUlVNsvVAHFVgvICzoohz31V+MKUrhH9kUprAKzNywayPBFfjQI3jTq8AqFrIfjGZRnsnic6Rf3Dr6Gn7vgQ6i0NGntjtbpjp8pV2Vk91rGQbE+kmpSB3553OV9ki35/qPoe4a6IBj+LgmDwn6X5tn3qZYLgWIiG5hxs3ArBzyhjugSmSOGgVPki+rc8fAYKcTyUjevwsv0qhXFRLvbiU81coqa5qXU4yAQwtjcVdkBX0Z6TmfZ8brUm/QczkblsMcSemLThyzrNPsgyhKH8BHBjKnsP63EF3vw6DDl8Cac3DwmXJnOBHWR863LUsX76OTxnhFDpNk7YQsSz2Grjr9RaD8jiOjsPwfQh5MLu9b4H4d696LG5KtJETNpgnXMIy9SxQO3P1dZJqeuwh+CnV5vj0gWSAvJBL7GJtiLzYQcWWaKw21NgH7IsyWi/tvxPkhCSLJMlh3Vo/5gJBAwCQQA65O8AZc/UjuPiOn/4GWDtnPEvDC5vNXp/I79mqpnaoKMnUzyWTWnIv2Rdqs7K8fN/OxDD+JaPd7CqKV1Bmjq6fl+TAr2ym7X+v650poIeHqXt9GetUJOh5FkPZZ5FRTBaYTXfTo4qRvUgzIwAo99F7u+wTkKf8UNw5eWCSDea2xhewWv/tzUpper4snThg9G/PmZcz2m1lRpgcy9p+D4+tCp
 U/jAzOfR
 vG1gPPWBMlmhIpmflfU30EZZkcslJqelLOdEftAe8rjgffYhYq5mIDPUQ5COPNzSVXnPQe7djXqEWgYQ7CXvndvW3DRqkmN2KsuWzHI4OH6KPLNfnQDQLcCweYyPjZOj/O2oFKnwSwQJPBpWl09HZ/v3F6FHM4QX6H4JCzPy3UIhOqgcf+d5lVTCIWPNMpMDezFgWNnQPjleE417D+9Hh0xq0ftyhYFRf/WvzAxDHAYGpA2dvZTQzeE/uUc5BP7dqYlhOklmXD8yAjorFX/G2afZS437BOl8l0l/lhegK99QF/1BajZnyHr1Gcs+PQKqGYgN6nOx/132qFaTBiI85gCMnQmoOleoMptz0v+2cjBpiJHkSsuvuVTBSb0euwELhEqlRHgWt2bWag3urEzsVqrq2/Aos1bL5shUiRfbtcxUeffgRPsrqPO2s2GLJARa8pfBPulaTgh35Y4Aw/T4ZpVHtRC/QiirPdifoH9MBYooXt07W9nkCrWT5NqN2oOjERqCwGsJ8s4+TrzSx2mVPMEXu//Ht2gEe3d2hZmzSiEt3/CRokO+BOMqGkfoVN9ChasatjRPZ2oUMcrBE88ty5FRoZWAzq3j8iUJqGR/GXtYNTCPSxfx3SlwlJZae98j7DxulqhnkIbATlVapZib78/WZpWxzDj3KO7KY2rUN+2AEvf2YiQsRyirnfA2LK00ybnx3b+bmtNV4l5YLsQXSAuCGFJqG2PqUXSpLUbO4bXOdUg0DOAndKMZaqLxaePyY4/IYS/s6o620L4CaFU+eMWPjWLw/MCWSBNTD+2XYUjzrAuNlgxgKJ3uOlEp5Ib8PReojn+kqkS+saTOlCCfrB0STEgubJC90U5ZGBV7yj4vO6s64IbR6WPsFZ3Jh+Qlel2qdtiA9knaAFyTlKj8ffUQsFOA0nwJ4drb1mEWahpi1uuyHaGT67sqSts78rjaWo2nD4FkVOHX9sEtaNdn3CNTnf7sZ
 3EuQ96dr
 Q486nOHZfOdkXqM/7yENizeFl5AeAXTGLP2CGZ2Uzq5YDiiio/kekcl1UNjAF+esMO1d4kxxQ+GnP8cJJUzpxrx4U9grWhFxUHyg+QMTu1tqNxOS/pMJf3tHuyTopuAqI+kJBoLU3G6mQR/Pqai3KfIktCDFQbArF2wV2nCl1cAI0BZ0XoXGvmAdlj/TTZ/folvJYjW+CRCsHsiTTzB8qr/uU6oTWGi7axUVs/DhECPuMlYRVYXZg1EAfQG9JK/OptoMew9kzCGP7YGCPmOvpzdlTibt0seUETZYYvPvlsOKtmMQyZtYhYSjmFq1VHcjoR/hnO/7Oeul00gQJhZzq+ZRRf4RJEAU+J1sKYqiV3r8c4WfPpBfgNTUPgrpsqQbR3xJOsoE8Mnar8PTEEOjgkfYF93llIHC6fcsRRdKOJujmTReEV8Dl1BKCcR+zi/HaBvSN8l7CZBDESrL3WMGlkEzI1q5kl68VVKnjtjbj+mXdgN9hmMe8W/t4Geovvo4LMWhHxtukH6EqkXYm0CThWqHOBgzQpdtUR6s5+as4cPVGpjGEjYCdRT5xpDa2OgxIbAgw7dcDmbon3WK3aK87EdrRxXgHB7JNjRxOcjJC4L3kn6o5mli2eRNHVMfqLFk3sTu5jX2ciCpwKiucFiwLWSiaGD2/TCHpZhWasNZ4nL/QwUZF8Wp3W2V/KRZDiLSThW4eeSOWiP6AeYWpU7G0TTemedbSG8RERqC3XePQaOghybZlbMC0XeMktCuPCmd6mZ97OETdzws26NCaZaCqVsZS8uJ+j56ygf5V8Gv8S3K6xPQTN4UanQxxEJRh2uB1+PXYHWGsUFYxzqJDZsoAae9kVTAQg1HmWWqJkTcoqvB0U+DVh5H0wIRj+8LXAQfPprK84tWZQBgN8dvyEDbxPBMRKaPaVPLbX8tIBLpNKx+oUtUHyJxPYlP2YknQTKyL5B+wGuQ1wf+w825rL4RXY+tha/1J
 uUXg2Olw
 C8+bRLLm0sqiUl6w1Z9zmMEJPpJ4ZI6xIDZCJj3MDV3wDI+6k1rIB0C2rZY1y1J1lht9DzO7uUmSvSsAD/KGvYqHTukqyUNoN+tnDngBU7ZSKHxybiu53RaGiOtnROqPOIsW4EyqgNLx4qQl+fM6ttqDIad6noJhG63b8ZIr4ypdvM2w8thbZgGb3xJ/kPok+LNPsulhI5pDyZU2Ou/E79Ac68HicWUjAwHdelPEcxuHOy+RgzVjxe0Z7LVHkHbXIeMCmbcWJFUpvBdA54zYiduCwaTUxvutFyPpMIk9oecj2MqllflcOeheDykXwYXAuC/iX7ORxvaDbf9iH0cr3RDasJjts1vr0J8IsdQ2o0XGqSNTbBH85WGsiye1h2AgO+afRb+kVqnY/JRcxyReou+GtVPFAHZfPzpwalj4gU0WGIz8nk1Oo5mp7MHxliXsl3+NMH8+hh9n4jydNg+oUv5OvB9r03tJ0ypJBH1/sk3OIZr80UobuiRyJK3MnivRa4X0cPZfFOmE0QWxZt8IrkvE+Q5H3+L7RztIIkDt3TNrsiny57KvqOB5Xku7W6NkNUMVyPB3evwY4G1osrMdS+N2luazTIdDjw+UdxLqa7SMu3ldw6af08EeJ9VWXW/Tfkzvgv68KgeUsYv6rvOc4Fqt9VEJRd/zHfDXfOU+lCbJj8ERFSVB97To4REgQ06RjYzEmBAm8Fu16oFKu63Sfw4QaamXYCh8gl3hJbYKQ8/su4oL6nB6iNvoRCWeISBVaXiHKfCM5rYNoxAmjlUjHBbF9TQjHeai3ebUmV9ltSIMp104z8be7ezAoOCtruR8Bd2CIo/WjQFPXBSyLcdwIFl7HpRzXrgiFz3o/Docqye3+vpZnIB4qUctuOO0O4rhxSNNFDCLvDy6qq0yR2pR4HQ4GLWBlyYS/WlnvYGKgVyqHgu+a257z8CfqDkUUCmCh4GhapgC0++x0mo9d0YEk2WxofBCW
 refx4NKW
 q8H9zyrYuxGAIJzyaPbJGfWjHuwsQS/8NdZ3JUrEN7QqVZiWpvNESvaJ4aPN7m0lAq7kRXsFX967IKa3D9EpJlwIX2PQ667Lz++O1CRVCbNBlQHENApZhBcGzCY1LV1tVjRpt75pRKQoFQ/hXVgy3dBNZbV2xGs1d5NYIXlJD+z3HWh2UAdQTu3rPPq89FQ5UdK3a/+ibn5ht2Pb5yjWZvTxWIajHNpQRBX6kTM8Tyce8f4KmgtE7KFuZEfoW8FI/VqjsyHeIZsUIPsQPKDs2Dl3inhhFLMSjHuiTi55fw+9o8U3NMyl87GVQFtyfoFnHCPMN1BhCAsjYaKQeRoHklDAy2kOM63Acu3MxdpGZpjj3sShSJJoSxsl/f65RNlczcPtflzlxBjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in nsfs for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/nsfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index db91de2086456bb9fe0547be7dbbd2de87c97ca7..eac326b85314ac8080248347154d599c953969c7 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -46,7 +46,7 @@ static char *ns_dname(struct dentry *dentry, char *buffer, int buflen)
 	struct ns_common *ns = inode->i_private;
 	const struct proc_ns_operations *ns_ops = ns->ops;
 
-	return dynamic_dname(buffer, buflen, "%s:[%lu]",
+	return dynamic_dname(buffer, buflen, "%s:[%llu]",
 		ns_ops->name, inode->i_ino);
 }
 
@@ -394,7 +394,7 @@ static int nsfs_show_path(struct seq_file *seq, struct dentry *dentry)
 	const struct ns_common *ns = inode->i_private;
 	const struct proc_ns_operations *ns_ops = ns->ops;
 
-	seq_printf(seq, "%s:[%lu]", ns_ops->name, inode->i_ino);
+	seq_printf(seq, "%s:[%llu]", ns_ops->name, inode->i_ino);
 	return 0;
 }
 

-- 
2.53.0


