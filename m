Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67F79FD8FCA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3AA06B0104; Thu, 26 Feb 2026 11:01:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF7936B0105; Thu, 26 Feb 2026 11:01:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8F4B6B0106; Thu, 26 Feb 2026 11:01:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9424C6B0104
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:01:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5BBF4C15FE
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:01:34 +0000 (UTC)
X-FDA: 84487072908.10.129C07F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 852EE12001F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:01:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BAz8BQ52;
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZHVUPVtMd5duBp5tkF0pwwpHBYGNNJMRhg4z7ilrOBw=;
	b=IQ7gkK7PkwZkyPu8lM3ET94RsaEG4gspQ4NdXUo6HaLYoMmVYiPge8jedkgBN4shw7pAk9
	Qhsuxyvyws2MhrUKC6aP1rSdpiZlOigUFiF03+lVFJ7Y00W4y29M/DzcAWkzBy1IdhOdYY
	OcVUkDWaYO0DsDIFniDm+Z8OZoKE9RQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BAz8BQ52;
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121692; a=rsa-sha256;
	cv=none;
	b=AHXSLXBMBRsStEUbqzcJG2k21vVhzIOybIzI6H3Grj1jI+8hrX/S90zQd/899+ivqHvBZE
	aDeC58eVekoAxv68Uc4fbf6V0vngDIhoTgv65HcW7sEmOuygu3ZDp5lCEBRS9N5R92bCnh
	gYuzSKeHtVjZ1CyTA+U+QEvkXfGvRE4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D87B661421;
	Thu, 26 Feb 2026 16:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5362EC19423;
	Thu, 26 Feb 2026 16:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121691;
	bh=6STFW9zzEEyw18JQAD1ltwRNCpZJhA9BXLfx6yM4ajE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=BAz8BQ528eKk6MadOHyevQx+qjL4wSDuyHJ87ThNPK/31CgqwA0vCscM33MiSFeUX
	 UkjyU2+pJs8CiD1ANW0EkPSn94NDfhCzaoz/wHYGvEzrGjIXtw6cGrHR9fUMKpOxwc
	 aHB99roC1dbDycq/l3AfKBSf6ZVpAE9VisEZoRWAnWVxc0cfvexcFOEf83sd5JX7BA
	 G62tfcuJa9RTisoUfOdbNsEM+UwHtomPnSDSEJzYqiM5p0VgIq5s3Chch2BAtdIwBJ
	 nlz4vOM6bWrPaflfIkDMsV85NZ7E4ngPFIcFmtwNuWUfhHrGf6FA4rFQnSdooF6puO
	 MX1o+qh9KowLw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:27 -0500
Subject: [PATCH 25/61] ceph: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-25-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1288; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=6STFW9zzEEyw18JQAD1ltwRNCpZJhA9BXLfx6yM4ajE=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0KC6VVADOiHRXYxr4+UxXwlyOI0WrSk39r8
 mtg6o3CGE6JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtCgAKCRAADmhBGVaC
 FWhcD/96J0LtP/SNwu6Aiyx9nYWaYBUlQ8MM2Sys+a9iz6XZV1X/Xdw6jIyXLk5xCQPRxmP7fIh
 krswUI7GBDbLj5FlKf0r2I+RyfKx/amG4chw75EvB0akEjH851AfuKMiBYDl4YMlWQCmWX7d/Tz
 YN73d+XlOzLOIxIiOdCs2GuO8kIvv6nvvgUM2zde2TPB3Qbz0GjQMG6lDwTMbrwP0RXod6mJ17W
 2f3J7fKr1w0QzlRaC3Wib+xWz+MhZcdjt83xDg5fpHmy+8qhqCYS/VJFx4bHMvFvtsbsHr/fDI7
 FKMWiBzcDUfywjyviXUCVTlnmAceADnIYvtlAGknGODLQppEdBHpM9pBjUy9oCq3G6EQq/NsiGt
 BLDa4hE0VL6n3cP1oS4GOC5DBIspUpFHOVyVVaeYY/D0jJclLog94O6JfiIPJtQXjCPCimBG4np
 zeGhchHHoeNwJS2ox8udxtNA/k6nNe3eUIbxV4nD9p2pIDtnTSv4cYIw0dTvtj9EqSetVjcZAn8
 wmae8v8+ggHlRCPT44+8JbmF9zckck49XmFkszctY/Hf8KeP4+d50OE+RuwyAOUmFTwP6JGgoLa
 lnB8Ki0PDsonP+9iqvPevGlYNndyClx4DgO2ptfO4kRUjALpmeLFrPuMY3V00l+rkYRH2DB8Eb3
 NI/h0Gz1yXbpXlw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: 9ajo8coqkt19h43f8yb77b356w18t1xc
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 852EE12001F
X-HE-Tag: 1772121692-718217
X-HE-Meta: U2FsdGVkX18CZCs92GY2l+/xKcBmaQoOLzolH3GE5pQqWnqS0P9xlRJrWGXoLFaykdGHvNLc9WTOpNsPxiwbQs7XR4dq5KQ1cOx7hSOu6JDWsXIRWcptc/zs2T+KjDGshJXTq+YEFsrju2PnMWVgZeP+iyy+jJslC7SSc2GAVlw+lVJR3Oj21WpgP1Mdj5LW32CFen903XSNEhIYpQP2VDLcmoi4BaGPLnfRW5FOLrkXIVcLIHysy7PKVLwKxGFGkMpoQNsPJQWf0mrnpewzUIVgNnZd4Md3jpzyQhv0Y7QjKlfhNM4znPPas6+nOm4bY8aRKnPjR77uoowxjEllnqY1StHwgjU2kMAo5lXQyrVyus1ozeRRAm5Ao9NlUMx3hUmyK32mhdqWqdhrXfhhFVsbC/4iTCoJo2lM7iWb7xRT2yB9tkvObiU4LO4BtthzoTaQzJinCmhzsUh6NASTN5gHFW8chd4V5EWT7g7OMDJd64ubXXwNjmybFnTPe138ddGfwL+7ruUIWErsNtMrql/6f4OKypYgkJjsdxxKmQniXwvEaI50tPs2xpQgZHVEg0i3acmENRAwTEgG+BaZiHKGJ5iBL+vxCleD2sxkkclLtYaHX9VfaQmO3qZabKqCH8aIQAE6gRbxj0JHMev/DCrw0G7suY432h/vgDRR/yePAFjU6RcRN5nkvZpRTOn46pJO0GoLsVZ7zNUka3Lj24q8/CqZikAI7XN6kn6XuQrNE8t+hmuPGPcxEJPuGKWHz9pHcy9dCMZ7AUtUc7XusaOdUL3v5c6QjHxOy7//4pQIkQ9zapCMh/OKDNSTbTXXTvqL18QUAMKDkyg+4xlwn329/hIMdcfjArxniEetgIWRm1cZL+Gr/gKoaXZBLEuqDxgxLWL46rCcJFR9kfBMGJ6oJTInTYRodZDdpvkBOj4fDiUgnya0teadmc2SkeUh55sLVeui9vjKx2IxPXP
 uDyXEeDy
 76iZqnG1HtpXTFaHj5M97eqTbC6AFQUEijLMROsaDca/UBE84OnP9pjlEcsC6BaMzYQlDH9Ecerkxo+6LMDNx+7i8X0yTHEbbzISdLE/Cfg2luC9TycKSSsTsGNnqQtK1Xhu6WqKgthu95+JsGsaj5B2PrwCEKXBzL1v0dSNkFf4SGzrXwi/OG0pIx0QS9kWCYrrRFuHCjwJ3jlyRKoemIXHE3J3r2TaTACXBqI+tnwNgky7/yVIJKQvy7HY6u48HuWuNuT/7oXRuazS98TM7Fc+4sK+dBHh0NH1HznMFRSKUbrVbyK0bC3yKQL3/aGcUWblXa/3lmQdQ80R3fho7U/IcvGHqNzFXdy9QnvtC6YqORo7qW74/Tq7bc2/+Tlr/FsA5fsUEY4c4lpvA2VeLkAiLEFh+Xw0r34ZxdkqzJtNytsY94ggpkKCMCcCpSHeu2dqYjfcDWPJd8eR9K5vTxvfO11bg4uyYaCV4vYwCiqB2sgyqIG+vbBsY4bwUa/GIsL4RjnpEUjsxTRarcgW/3x726bKKD67Jqhftg2HfEBE2AvMYXI7/tb0a0zeYczkqzkfja4nXPq22potfSogeomG10LcR7iF9QWRllUw3ZS+mRxbrxBqbeEmJ9SOuHg4ccSMRMjpQyoDo2lra6DGBDzD2uBACFOWDNcfXm/Z83X/Tlubiq8kCevwACPGOiGQKMu/dOqlNjHbtwTYUe5Za3YvmNzhgBaNdg6aIJdCtNNhmY9hxKvHPp4VZ8a8PM2213Nix11bX79Z5xqL/ZBKVER7bkbFV5iAdfF43ZMX6rySpJTAwIExkFh1GFzoq2i45l+keqhJOD8hZsQTkeyrdu0tkbjo+lWyEae3vmH+0U8dv+tzj5Z+hhuOQtiIdP0StYn01MqiHZ3WEI0+H2fTuq8AtpOtIwJnfiX+cDGJ8K/44/7bRSe/hpvv0/D661hSpBNNwwvI26CVefqLjlG+63j/NOvpY
 fMGa0C8/
 r6gPdGgWNfsv7COb/OTE0ggFj//9EWDFmuuSzrX6Mz9UgPVOhFAm46bN3EikvTPX7ml8SHqZkWn969bWXarj+Jwshai90WIYLYionX5k1aIsEgBtS3Lx20GbqXErCLGLLLgFTLh4gtv6hdJ9WjCbedKDlJ1HENoEr9OBHoBkLriPjZHgmO8cHMPfQXgTcduuhYE0jmaJUQvx47S1BQMHKE8QVnWmBmbfaCShlpHZRGfUGL6oryleEM+sS2TsAFlnCiJHD5X6Ok07+UthXqZlCpl3iccyhpP1S2RcZ8e54yYqqWamRFNwdEadq0P6RWKla+AtBBlIXe+Tl5N0QhKGYfGwyOg91hkC0hW7lsghlPKoti1iBlDaZTppZ/ybTtC0z5haF2VRSFlFtSklq7V6eBsH8BEvkUC+vwq3uJZ0HHBhgV2wBas4hIF1sS0rZ2ZizG145ZRPWqG9KaxCpOCxjlT+cmALxvkuNC/ea4n4ax4J7AabRZs15GP+ylmH+s14wFnBet7ZlEG+3ytvvVD6qhC1YoYL76F4cPMYwrgAUjR94KJvU+6i5R/prx0m2ANWKqFviyGMMYC8AdfUGGfmFfBeEsHRwYMmwhOXOWW/+zzywAv235+lyonnXU/BOl6g0gMg8Ob9fPQaWqPrVTLd+W7GNRXvJODQudvKzzNXIvuIj1WbBlgYuVjvZ8diSIzTiA3kZySfo/3Qo6vusWs79Ha4GRJEtP3EDdy2bzfon9jVOdGPOQKaAZCFN+854t7eNRr99ImKDRCm3eLD1hIKFchmAYlNw4jdc7XqmIC1U5f3AMdVv2cN73ZTmJSla65wYeWdFnOA90apnGi6VVbgmboLk3M0SI5OpeuVfz4LCpL7Py9RF2DKnNQZzTAgol3wZO+5Nf2A89mefPdXHONruT31DnWvB0FjZIrZNR87OP343flXHnJ9wCPZp+CmHQy4VqEsKpnhtZKyT4oO36k8kBmyh41ZK
 6RtGY4Tl
 2+foD7BGlimqk/L3tv84P/1x5ZE+D7ftygLH25tWiKL+wIAmXB61rAm6gQHJA1LXoaZEOPjtzsucb1KGNpbS8BceybwF8n9QTMCPhUYLe4717pM+vX0NuSuQr8K4KnP3nb61rU0wzR3SHAGtk75IqeGZMH2sZFHkmWT0hL/iPzTG1eF2C17juSkmDGvUNEpBR1AbwsM0+hBxexlQEk9pjUt2nsdoJZuHaIl/E8G9lWDyJXjji0Z0efy3xko4IsjH8e6BudZ2TVYeEOL9+6CfEiTluMwQz2l0lua8LhefTH9EE3HN3Qv0hw9rOxH3pk/4skIB1VKy/GFfkPG6XxbmrYyA556MnTSWP/dmOSuilgN04c8+ySb+Ew211eWviBUM2ISaOx/C5ISK9RLzPndNXbgttRMJWn35gvk7jf+iw6uGoGNX0AXF2+UhrPjahBq6OeV54RxtdzUpHBH03BZ33AfV57P28kddO2KoRrmL15nEa6kJFlEXJ8iqSAKELUGqZJoypB4S0MzM6dF7Xfz14Nq4Ozx8Y0ErS5NDCEIx4yn8aOsslkj4fCpvTQAN+45jfOZI7gKWmpKo20tknzsugWq/viYgxEcaPiFR+3ZFuKWHZTiJN/4Qkd88hQDbz1a/9XYOSdaL6S3K3uy8/qLrZG+yljx5tXCC4ZHbOCazBXoLuCp88bzFF5NbLQb8OpXVQtHYyF7gB5GoCuRdrVn5o+w/pAy4QkjtJJ6B64HzHnWoWsi2y9znvDBeAQnz9bSepdghPL4BKYgsVOcgJ+FrFwg3yzSgkamehfOs8PwuloCU+Fgc0fVO2aJBYGGcru2rniWafujCPz4eHAdRNsaSLMCS3yKUVuBS3S5w1+odj5uPwZFn5+B4Aip9uSLHQXZWjct4vIaNUv+K+TPCB40NGv+yZ1rM/laZ5peu8Uemjj3VP/SzsE6La9NrFqqgr7Knd1Ae1uX/xTI4yVzpfeanJrEVb9ON/
 /zjZn2qe
 Q1x4Xq7ovGZCk4nDnxhM4u3muPWxu+HGXrpDYJwt+uLBxb1BJX70H9iwy2ISeO+aesytBpje5beDhQIOqhDUMxK4quV2Z9nsdHP97v6+6qDoBKJykoFYWLKZiTzAFbwTgnbbxVSzkoaO0oRh2Q7/yBFR6kqb9RzHQOI0Psuw1R2AUhoM0ZMzObuW3qLsCHIodD1QJC0wAP4nhZx9VA6HW0hFjSsMkzWZwDl+4V6Obvg/KstMfZKiPCAHPrzmKhsTsVYJ2pDEX3QE9HY/r3og1OhG2N5dV4avP66+S9e+R14vjR5ZwxA17Oiu+vPkECRNSw+lJ7ZWMZgEoSeqR4tXa7oXPkIVxteYWBtriV4bhXAy0S6u6utYX5uqWWV9CLOe3Ozc2XoZvokQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in ceph for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index f3de43ccb470ddbd7945426d79f9024ae615c127..3c8a21a572d8230b558f20bb02721184cae35ee6 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -272,7 +272,7 @@ int ceph_encode_encrypted_dname(struct inode *parent, char *buf, int elen)
 	/* To understand the 240 limit, see CEPH_NOHASH_NAME_MAX comments */
 	WARN_ON(elen > 240);
 	if (dir != parent) // leading _ is already there; append _<inum>
-		elen += 1 + sprintf(p + elen, "_%ld", dir->i_ino);
+		elen += 1 + sprintf(p + elen, "_%lld", dir->i_ino);
 
 out:
 	kfree(cryptbuf);
@@ -377,7 +377,7 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 	if (!ret && (dir != fname->dir)) {
 		char tmp_buf[BASE64_CHARS(NAME_MAX)];
 
-		name_len = snprintf(tmp_buf, sizeof(tmp_buf), "_%.*s_%ld",
+		name_len = snprintf(tmp_buf, sizeof(tmp_buf), "_%.*s_%lld",
 				    oname->len, oname->name, dir->i_ino);
 		memcpy(oname->name, tmp_buf, name_len);
 		oname->len = name_len;

-- 
2.53.0


