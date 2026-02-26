Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35199FD8FCA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:03:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 938146B0113; Thu, 26 Feb 2026 11:03:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E7DA6B0115; Thu, 26 Feb 2026 11:03:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78F4D6B0116; Thu, 26 Feb 2026 11:03:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 62F176B0113
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:03:15 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 342D2C185A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:03:15 +0000 (UTC)
X-FDA: 84487077150.04.3E9FC11
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id E9E6CA0016
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:03:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bjbqTTEf;
	spf=pass (imf15.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6oZyd/zqUvDlO+OT3tp8m/K24P8WBAcn9JqtGiR4neg=;
	b=8YiL8PHXG48L+iMAA/Bleyx8GCOTudsj7wRsfKjYvEFDyVDFk5dnV0uKctaO94gOOtZ8oL
	pGAq2zQ4rm5lxHVY+x20QVzXLh1dTrMI+X8Pug+gqKphC952Y4XTAzKdm2WkJqeAwgcIqH
	MMTifN/nPV9uUS+T4W2iJu+ZaQmOSfA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bjbqTTEf;
	spf=pass (imf15.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121793; a=rsa-sha256;
	cv=none;
	b=f29qxkvRUA39jRTcs0m/zLp5TZiOSgmxKWNfs/BCz9lhGNsINgWPBTlaPzinY2s0Hvp9Ab
	qqTGnRaBRtlYsmBrzdg7O3iixWbDAyX9H2accrp1LWAZwOidVRoXLxQFfJlF0kU4LiJRjy
	H6strGFSy+f60qUS/nQyaPqVnJDLMr0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ED32D41A6E;
	Thu, 26 Feb 2026 16:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74DDFC2BC86;
	Thu, 26 Feb 2026 16:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121791;
	bh=NGx4WBuvb7UxRDR5K5vtqURJKxg1s4vdFYT9NBXWD+E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=bjbqTTEfgFCciW+pdY9jvd/ZBct5Xn1Y3jsQ/QCvuak53iTb3gN9NMGEt9JYmAC5K
	 2gey/5yXXEv1F2UO6fbrVjDUDhKEYSQB32Wn83O0i+AnLXI8bf/xopLcfL2kVa1Qb1
	 3mnLTnvobCDqwvXf4oonZRXIA27cpPljBwtm+abPc3P954M9nEjRkH2n/Fe2Gl6vQo
	 NoObbcQExR2Z55aX+TcPa8M4OxlZrussUNmWKHe7zwT+XpRfPu8tc9bf2bi6+5VLF+
	 dFMDxcmfLamxdIY77fjvV2DKEbM3OtnzRxd/vMav/g+/frF3RbgoaBRjCBj2HdoIX4
	 gAmCLA6K4Ndyw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:35 -0500
Subject: [PATCH 33/61] hfs: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-33-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2579; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=NGx4WBuvb7UxRDR5K5vtqURJKxg1s4vdFYT9NBXWD+E=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0MY/DdKewvQ2rFIeIHd0q+Dx1hGBZftncr3
 92vr6MSygWJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtDAAKCRAADmhBGVaC
 FX62EACTVLZMxNMZQzbBYZ51BdzXqHLO4sNY3eh+XMkEQLySUOuHonh9U7dOXnOabD7vWiyxdXc
 ub0E4/9CYPBXlErEh/9txFTu8no6Sbmq+25F9zwJ/6mx20/vqUcSbJvngTMsyQZM0opu5z8UMyS
 /bqBdw1aRXneTlV0V4jz8ogjiVDIQHHfeicvj0X0zjtB8e6Fm4m3Rybu7zFsopwRnp8MSb82GTv
 nxu/Vimmr+FNNMDJbN+uwIxBHgP3gUS34OwTM90A9UdenQQfH6+Gx+H/nK4YxF8JcwqiO/kZtyc
 wRwVkU1bK72b6NspvwRi8Y8Z0eNHP08cDI+eK4Qqfwuyh2tznjbmAtkjgIl1fVN3PeTJKunC4dY
 R66zmIMWoDrGwBrsE8wxMlV2lbKEMZmtokt6tzTm9Yh4DIevrdxMGTtVw45Sce9kxexpZkoafW8
 dwM3bAD9KrganjMZelYRPWYdcM2tL6XuImPhwWhLqz+KlMIMUWUay8qHKhPtJu94mYpRlLzXTMG
 0jIOtNFJzmPjoQGGw/vSMtM8WlOwbo7DAasYBrE7DPgUM1eJquEm9xRqEvi8z5LzvBZ2qrQeqqF
 /8JFgmBAd9UdpBRMJT9JHn6P77wNQu22G21WC4NMoPQDs9+sCu+XaA94CS0foj7UsifmFNG00oD
 6S5Iz0EAXyIllog==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: 96z5xbihkyi1po4eixxqztf4dzi8rdmf
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: E9E6CA0016
X-HE-Tag: 1772121792-845309
X-HE-Meta: U2FsdGVkX1/aOz95krFJG4fi3w6X6TAfw5CXg/nOB+88gnQZVksgZxdyDEsw4VcOZNDG86cynICoZt7xgsiFqA7LmZzYoOLoWGaSCjpzbpyFyMGnTRy4JL49GtI66I58aww3t7IhbFJyATKh8LOnu/g4OpIlZHVyrz+PY6Utc66M4dQPrnt8sbqW1Hu+ppIyzfj6Pqqqd3QtOx6UBEU51/KVcMeLgjsFTa0KoYouLqwVFUXhNlKUEFiJ1E9rriCZE4sZVLuaU/N2OeIJdiTGqwurlsknICvey7wk2KPqst66htjlXE0+DKZCUDGVXa1dUH6XmnjHXfibfSyJ7fBYsyKhM14YJIpJ52DkXQ+TSRayfFI3Eeveb2Y5dlDWqqt7wjABgf6ckAUt7/m2Wq6cg412Q6t1CpO8HjkzzsGfi8+hqKNg8Q2PqJODfBmO1YsfLZbIPbzEtgTxkXdbh5QWblrlyVru0/MWQ/K2hcWusCaYhpTNIjSgeCtfEsvBpkCEskhctHApAdg1jruOA88Vcv/+9QPc+wT234zPcx7F4eN/BBWjdtk636W+8LYosgcFwPfsreuaJgwuIXu088c+e7Gn8HHA9n9Wx9flFt8HlngbY3vHqJqQfd7exFL1fL0sNMlz6HKGQvTVJRWT14VZjJD8iLNfc56HZKXPIzdIX27f8/oeO7Vy7syjLmKB+DeKK2sbyB55T97YYwFQk7qd6aKLK2wsCXagtqrcLvte/qrtcJmIvlLJNmOZsPW1m1eXn3uQ6yKvCJEpsBE5QwDT1OWZ1VvEA5jGK1hiUQiW6nOehzR01QzbRF748ogXhQe29q+bvkGsTh4q7rzlJ7PBdXpCdQhxdeDBdhL3KtyqKqBrjhKj0tzrE09sZ6On/PBqCXWO0q8YTSvQvbxvTqSxOGP//ZxwR4wRl1FC0xYUGvW8/Ga70J4QATf/W0TaWgmW3bKrSUGHyljnAIc8pbv
 /rDJaf+g
 l9s2rcIScQeOxOLmir5LT66uLbBscYgr4UI2xHSctGTD/qvB7Qi8QJYQHnGIu44UjPtuvkQwxG4FznPQv3CXYYo3oab09WH0xBVWI1PTyEt18Kwrpcu547Cdj/autL7VZn3Jjj7sMbjgQleTSfjJYpVLwe6NpdSFxclSs5NHbI1OT6Fj2uSs3z9tCIW9qMpfkSdxpvrK897+YzcS8zAC3IwNYPPoo9X4BfEUO0nrNPUxDkKhPHoUeasCh7bnBZ/z2zaYO26QIOCvNlYsOjUNyk9ke98yILtJOx+DtAkkCMRoeAB0DvIPShd9j7q9fzUJiLHw8JNWyjiDWp/5EORoWsUxeDSWkuw9hSjN4fSHSueMy6EqBP7NbcKxDHoPq4XFAOSaMx8QH3Mu0aVkhPqpAZyZi9AwN3FR7Vi45lbaXaSdfZFnQ18rChqYadKPg/C9dXT2FIICMfpAY2P0QTDoBPwVjBSOyHBWRFnDYmmLahxgKdZXpyP8qXO5MgNgDtgH6ARRoGscbefolOVe2MEDfHJZEFBaPJvUNF3r7f+usNZNbAfaP34J6UAS5dVw+eVIFtRnG4vrTpFYnhf7nkmDsMTJ0zgvnJHLkh27oKo9k4JdKiNa0lZLEPVXT5mj1CBx3NoCYriJD/2EpXL0UbXwdK+vY+7GuqHxEIkKtgsX/2eHPTmz9wi7S3iZGFDDQ7tI0lpKNaENb6VEHSQmgHrumuTDL6lsJoOPKqGo70TKragxqFHJU9l3IKAtU8paEZKW/F4SAWwQJwHKnhN704Z2y+2BY3TSiyKHIIWs+V5IHa++OfqHrFN4I5QfI+PK9gslYMvLeoHvn5RFwnQ6fA0ellR+H7lSl8Ns/sv1PNEuejkicgJAizfC1/l2TY5Mm/kysftQCKZecjJkUP/QBhMJV+Vr6+/JskEHlrzxXZxB8kUkB2frm0GK/hWrsciCjSIWR0joxWfQ6yQQkFcwX/yOwsVoVnBFV
 Wcz1s2t7
 fuBuRYw3ENAKevuVwuAkQPJXtnuHzru/VyKGI+mCqh9n7TlhRMwrlUVXXVYp8RG4a6DcRVKeGH1ysaucxJdEvMLNB6b6HPWYZW/HJm14zhXiQQFhQOwxl/JtJwJRZIrGD9mQf/qmdXD/Gu4YNZ7t5R6dV+Q+EkitlKexIcZzwAsmLNG/UQ7b+PnGR78FAkLZN0CZd7YIND11U42twpLwpM5FnSD+mXameoFGdwcSVV1OACZ5vzGMoJiJTebpzyuOdEOB032SMLjjb7LQA2Www74f+ZE/QOwuSk7Pb8truUJVGFlFMrRLOmFhFJm27kOmwBSnUs8eCn++e7MGJ+OQHM1ujn7nOs9YjHJdXDgReTgevuuuih4GaerjNCWYreXX/ctLDxB8dcvOqsoo3irCTPY0BgNByTaHL1ESqjQAFpwJ7pHZzol+Zp+sujRYy+hst1INf5uHsWcjZKXWYlW60pmyT4/sxMns8SMk/QS3ZyYSl7BMsgwgKlq4FoTc2FVLl6G4IZLilelrQhloZqk83/eolxeq29NqjIUoSZjUqCqzwml4YjPSfxb5rg/avFti/M4wC+89VHBWTPH21OTKPIavhHo6RUPBcLZsp8x2YMDx4FvdzEn93Xw+h2NZGSgvplCaql/6TnHqtQHgZwzXh/jMmgmeCun3Dl7/Vg1F3VhvIFsQS2fJE9vW5N74TEkqFCe+QXlP91Az7PcWztgF5yIcfzNVnY724fAtUjQtS9+C7Vk6N/X6Uv5ovYAAJSnaAmDYHSals8XWKwM4cZfoewFpr10T6t1OQQ24g+JcZG/LZXkUGjvtZE0sJkdmRygr033o8OAtqqd2CVfK+fUvZYIdQhp01JTaqAvcji8vZforBz6E/1xQh238ZXkptB+xKfJSJSOaXjDEzV3VJicfPGgvWSvgHKwpMePyXjGJ80waJm29Ta2CJI12IpHhszCPZZCDlc8IG5SyJDdCuCNQvNPK4d32T
 /4/B8pKp
 y1UI96rrz00R9GdSHQLu+SY17pxpIG1hujHyQxzswA66ErvGklyLahlPMLUsZIDfoTp5N4VQM4NY16kwpiebuXjnmJX/djUWdYmiv/5LbvMKMFHtynXOXrJr3ndIicF/7iBDUD7PH+6rRsNMzttiwevpFT8MD5mKM1ykMPfeI33rE/hIAA86dGnuz68lEAhCBEsBs1fCUAdzua6R/qH/ONu46ilXl5zPDlZYMcT+ZlVgZ8S2xKCLY2WVhSJdnnOzyqRhnKdvi9YXpZWnH5Q3MPIM0kKHUe1+uQcXbFC5sueTEarGZKNkpWetfTPXZtze5tYiC4WpXqrlvuN4CaMuc1SYo9KyDee2cDOmneEq1b5Ws4mJZA7ec85ycH2NpCaqRsEjMovu+Hl1VkXfgnM5SErNV5O7g/LnxOStXiu+gZgfxWV6yUv4/1FNR+2puIM+6BbI39mLsLESRQrux7EHnW9ixZe5SE8TxwTlCBChOyqd/LUUUdgwVpydzm2r9VUif520mBGm5S7/UmCnMwQZ5KA7eGKlyq59Mi/pVsrKg+vLGtc5eedOKN9FYRyYz3HvQQ7QgJI53SsPJ494p3E3Tym6DTmWJYUiOXYgKAZ+JbHSuPmxGNiUQLRP6cWoRT+rr4z/S8HybYg7PvOBNCP+BJBYTu3zozhZyUgXivsrRoQJzTQDG+9CODN5MyidfLHIJYDx5flQdTZuo/hsohbPiGx2JbqzIlNXN3Bf33BLNkKcRoBDpW6EZ4MloZZFWIXxeEwFj68JK1hHodcpGRDXhSV4JOh58LvxTYYu3KVbYjDvXg1qDZ629DB5kg/CDlIVYebDYKKFRG/1mVRmY0l/0d0SHmBsngtRyC9+w1e+3pYo/NWxiZ7Q4aXXe3cVyOekIP/yJWND1k2+nSLE/ZPqLCcx3tI8qt+p6PQaKzQjEWluN9rOLph1Pr/tydIKld10ZjpFy1uoYzwfjDFC8LVrwxsM8wTHd
 IEMDvTfT
 /qCWH8W3Cej76L3MgQ3s3aLosfB7+kmKLZyBCaH8XF4Im7z1dhf/SCUaE/jTOLTSw7JWxF3fEGvCkirRzd0sMW5Mi0rLuuBHVurj7EYOz6NDhrliKScc1xaXt99eYVvR77PlnID3c/N+jvDwDNFIzR5NyqETF4kk9o3oFoZim1CyYSJ1xyQREKnq4YlXJcOqdxym569N06MK9w/l2f5TlYmcOs5xn4YHwoRcwwBUc87JBRHUghM3zbGqO9ukVDXSVTCQVV1nuqjDmZ0D3VZua5qH4Kj9/DN84apOITAu6kc8Rto91wCkCZn/7DOPBHgUfNdS4EkOunCAc7uxsEBQmLqYmMcg5lih7X37OpcHU0PC4JFucC3sY132k7uUjsYWp4dDtk4XR9VWsQtMW84BvXJ++QwIHcUtokXEsK9siuaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in hfs for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/hfs/catalog.c | 2 +-
 fs/hfs/extent.c  | 4 ++--
 fs/hfs/inode.c   | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/hfs/catalog.c b/fs/hfs/catalog.c
index b80ba40e38776123759df4b85c7f65daa19c6436..7f5339ee57c15aae2d5d00474133a985be3af6ca 100644
--- a/fs/hfs/catalog.c
+++ b/fs/hfs/catalog.c
@@ -417,7 +417,7 @@ int hfs_cat_move(u32 cnid, struct inode *src_dir, const struct qstr *src_name,
 	int entry_size, type;
 	int err;
 
-	hfs_dbg("cnid %u - (ino %lu, name %s) - (ino %lu, name %s)\n",
+	hfs_dbg("cnid %u - (ino %llu, name %s) - (ino %llu, name %s)\n",
 		cnid, src_dir->i_ino, src_name->name,
 		dst_dir->i_ino, dst_name->name);
 	sb = src_dir->i_sb;
diff --git a/fs/hfs/extent.c b/fs/hfs/extent.c
index a097908b269d0ad1575847dd01d6d4a4538262bf..f066a99a863bc739948aac921bc906874c6009b2 100644
--- a/fs/hfs/extent.c
+++ b/fs/hfs/extent.c
@@ -411,7 +411,7 @@ int hfs_extend_file(struct inode *inode)
 		goto out;
 	}
 
-	hfs_dbg("ino %lu, start %u, len %u\n", inode->i_ino, start, len);
+	hfs_dbg("ino %llu, start %u, len %u\n", inode->i_ino, start, len);
 	if (HFS_I(inode)->alloc_blocks == HFS_I(inode)->first_blocks) {
 		if (!HFS_I(inode)->first_blocks) {
 			hfs_dbg("first_extent: start %u, len %u\n",
@@ -482,7 +482,7 @@ void hfs_file_truncate(struct inode *inode)
 	u32 size;
 	int res;
 
-	hfs_dbg("ino %lu, phys_size %llu -> i_size %llu\n",
+	hfs_dbg("ino %llu, phys_size %llu -> i_size %llu\n",
 		inode->i_ino, (long long)HFS_I(inode)->phys_size,
 		inode->i_size);
 	if (inode->i_size > HFS_I(inode)->phys_size) {
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 878535db64d679995cd1f5c215f56c5258c3c720..95f0333a608b0fb57239cf5eec7d9489a25efb3a 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -270,7 +270,7 @@ void hfs_delete_inode(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 
-	hfs_dbg("ino %lu\n", inode->i_ino);
+	hfs_dbg("ino %llu\n", inode->i_ino);
 	if (S_ISDIR(inode->i_mode)) {
 		atomic64_dec(&HFS_SB(sb)->folder_count);
 		if (HFS_I(inode)->cat_key.ParID == cpu_to_be32(HFS_ROOT_CNID))
@@ -455,7 +455,7 @@ int hfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	hfs_cat_rec rec;
 	int res;
 
-	hfs_dbg("ino %lu\n", inode->i_ino);
+	hfs_dbg("ino %llu\n", inode->i_ino);
 	res = hfs_ext_write_extent(inode);
 	if (res)
 		return res;

-- 
2.53.0


