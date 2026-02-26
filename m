Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3D05FD8FCE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 15:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EFCD6B00E9; Thu, 26 Feb 2026 10:58:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B6C06B00EB; Thu, 26 Feb 2026 10:58:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 464C26B00EC; Thu, 26 Feb 2026 10:58:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2D53D6B00E9
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:58:52 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E0425B7EC5
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:58:51 +0000 (UTC)
X-FDA: 84487066062.30.D1C9F11
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2AE9C80002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:58:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X8gbu+8h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121529; a=rsa-sha256;
	cv=none;
	b=QvjZ6TPT3oowczWlU4dK8ekJVUxXiFR4NSAuF/mlGiszn2Il86fVyLcICZC2KhvYtcOSFY
	1C+DG7RnV6V6Z0uFkwsJoqK28ztt+mgg0qrK4a29eiDfC890lVHgysxsewTgUAHNMw5mBl
	wt9BTscRcM5WwpqV4h3zD1E3Q8UjacM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X8gbu+8h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ftQ/Li6hBeRNd22e5HzhWjZzC8hW8j1iV5cE8QaKVY0=;
	b=g19vi+FSvpql24AIvLXI+M65krr1Cz2qqsY93HvqBcZVhZS5reE/B1sT8Ejg5rlFgbuFgu
	JT6Rv4fiH1+kQZDs7PCJBvV+h+95lzNNrHtKMkMFLEgIRIuALoepCwkwjbHzZ4MxVO8bwd
	pjwfC+VFUJiK8m31BEfDcfG4Wk0g0iE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 88DC36013C;
	Thu, 26 Feb 2026 15:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079EFC2BCB2;
	Thu, 26 Feb 2026 15:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121528;
	bh=LhaFa78gxfrhAkvUGOb7wByUuSw4XO1wqjqmi2Bt73w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=X8gbu+8hqujtbKGPCk1kPp9AdxgQQkyTYj9wJK4pj1AfA95WhjTKyFeU7i6QaQx8b
	 9Ff3kMpD1HN5KfULOr+hQsKWxQmHLkAeP2AwYvDEMOGrubBkhhmBzel+V+p2akshV1
	 lMz3PJMZnZ3E6m7Cnekjggj9x6kL/psFgxA0zBreX3Ap1EYofbu7Ejxxv0CvjQvEwo
	 pv0FRN5+u7frv/KT2CA/l2hCSPNpzsLDbVm5/wlga5nePBBel9/Lzzjqp5aAxJnnb9
	 r9dOcdTC67BuqOWlM2nS1BVbe/ZwHV9tHVtRL0tm2G1CHH8o8qUYytQdyn4RDGT86n
	 icn3ZCUgQkpwg==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:14 -0500
Subject: [PATCH 12/61] nfsd: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-12-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3147; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=LhaFa78gxfrhAkvUGOb7wByUuSw4XO1wqjqmi2Bt73w=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0HXohJrTDl3u7/VSJPdaDuhMnlyPMlaLAj3
 YUIRWFp4d2JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtBwAKCRAADmhBGVaC
 FVSAD/45IqX6+xuwmnva5iqZm4UD0KnQsGRgRCvM4rewzSVs0kNhmwVYfo4M76X3WuZ3BmOnejp
 B8bCkH+cbUqTeSJlVrlu+gobSIGqkVTdEbP3RY7gDlsdRrdKrlX0KdFgKAuQ/F+c/kJHYJ8mdls
 XMWNXEkLSm4Oai/DNU0JWUGlbxQr8yLKjQr6tLqu2eSVNruMbH7P7rjKnFS1S/IUJ5Bt5R+dg+N
 MPcfRmX5vBEywbG8UbmpmrBSycvmIOu1E0xJ39xzHzAcGh+B6A+pJpll3EZJ8oMQjM71t99TuvX
 iSplgvSyk0Zftf/+KWp39q/iYqxtmn/QWSo3g750DjcneR3akuimY3L4StuTSmCDwHlE17nZllM
 vBwGoFwCrCpeFop2J9W+Vc4DojDlUAoL9Qjupq0+QAzWsowxM8g8TwUY/pqNEpG85H7dUOO3O+9
 BFKKL/vgVc/VQBGGG8NQnp+kxJGJmlzGlThmm25qVW95D7ViecdZFgRRlfXZ4VsoG1jUUTz+GM9
 VA2pkfO37UG6fnUG9Tlm4eE/MjOnYU81htNYZ175MzZhO14jPlYNj54a/SJDiSJUwO8lGHolcSC
 e2nIDBpzR86KF3pOF6P51Xv7IgnvEE/GNwB7C3YM70SH33V3PIgvJuvCmshoAcD2q53Ode6yQet
 YES9kPT7R903z7g==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: db7bpg8qjytgypm9yro186iuaiztrcyw
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2AE9C80002
X-HE-Tag: 1772121528-456199
X-HE-Meta: U2FsdGVkX18ZAU8qUgnVpA0dC8XhtC6h3vRRH9Muzb2e22S5ApRQC72sS0PS3Jvdh7ieKvjGVdcYZS14I5GarUdGzk0WhuA5MGz6VCZtZ2MqUZT006FIF8eqSvem2f+d0MOaKidB1BxH/cEHtSEwk6sy6E1KdYOXDs7Lrhdt/NB6L7t9+y53HM6BNDtQtx9ecxX7++/KftdJ4PTYOlEz0A3C4lFD9WZjnUTtRqKK0HdqStrIoZxK0HSFpnU+MlViPSaGjBgt/gqQnzL112/SDHwZXWOyuOnKKLqx6TD3/xvriZ4KJ4PmUoyJsvAo63a3A6s0ersAwOKQgkhJfKKS89M3Bd5G8XHABqa/U0cisN0SCpoMjRBOPdrZ7h484WjH/55nnUPCHvJB72u681r7tmd/r8kQuTdSyACnT2hUavKyEDRFQBczfBoDgBLIGw+RiVm5BnLPuK4hKw9x33xk2wfTqJV+/Mm2Y/nhcLrlNHdjYILcChW6Xx/AabZmPAIlKwyki9snm7MHmvGDdmCHStgr7xf6LJQosgXS8VnLJlrEsbXkVo8m3RR+tY12mIBLRP7rzwH/rEhrV1ZPWHt1MhOHrZijA/udyg5movuWqoghozM3j8mNQB52Vex7I0I1BM6Qj8LXY2A6lWuIIUJwdvOw/sMGLYqG4i7m8wZnggllLsKyNBpRXRkRntxkGJ/esA2bkTHb3dzsPeYk8wTdNKDxVaM6mZyISk5IvgYBHxr7brirJYwfuPjHxVNYwsERm8pcJRVZxAhtXYVISStVjwnouOLe8jYaKv9CTVF8feHQ10wSrpCLVzcvHjQ+xxXEVWVcYT/4SDhxjxaJMuqXGmALt+yuhv+qRzHKZ5lHp0VmN9+sxae/tDxmmO1OTHY/hFXQMLeYrSObdTDcf4OU/Zp3xJH+QuT8uPBbNtJKV9Pcga1mM6YAUgbFS/ioYyXTYfDkBe3c4KOnGEYe9g4
 A1R0sqgO
 cskxgPuUujnfTr7D5zsE/JZxxMsZvpV8amY4KHTkrJaiw/qK1KxB4gNGS+WU3jdwRxJcNwIbO/XYm38oYG6dElInXhCIvUZQLfoldi1JanibAddWAHkumhL9/eUhccsAWnJYaNnXBZR9w8Ikp2HK0Mia1I4E1sngVHndpPDjzVPrf2iH4dBUOP4DBvlLN0D8dlp4nFg/c2eUkPgv1Sx7pzVQL+UBRx0qrDRk3KIaUMMnUFm/SbmqYNXcwCg0WaViWR7euJIw0+k61WEnD0ZYzaSJUsrTVDUaHXRhTbaF83BwBtco4SL6gnm6PKY3fiV5MehoLfe4QNiuGtfKY1eCeoA11VOW9qpgD3u/7CTNH09ikVKR/YuSC/tyVXDq0PzSv++GeCljbiyKdM+/RHSPlNxwODC9PbjKFjMJp3X5SBT8uVq9Wu2M7gQedPfCWcb6RiaPyKjeoWArc/5LJxWsIhp+GJ299O6EETxFAjInO39aRQ6o39HL7mfsIinOJDyeA5yRdjb31J0jMzmE98vUVPJETpZBlthm9TQ0FKJrThhnHHCWPYeh9AaFVuJgcSun63j90yg0E5yOp7jEHfTfMD6dCUyRUi+6Stx8bzCaXOxpxysPuJoCiqHBat2j+fbv5Kr/V5MHlhwv0b9ra15qbVk67Ws430rR6Xjl5qPW2qTwQvQRk83LFPAU/g5JzDQtlvxUgWj4/sNk+5qigtBTUcXc4k7qjSFEVWeUQMN4rKFKdE7fFisAjNGXELVqgS/favodlmRvv8ETAuz+7dTaDErAOuXio/h8ZGHJtzHIrbhkWKA/V1uBXQm5/YzcPneWoJAYFsmELjmF7nWjW4ZeT3SYxeMamrE5T7TRUpQGOTCvBz24bRX5jo6zxFJ6OfgCeUNA7oOHI2r24yECJdlvCnywlq6JZPLHxRXYdJWNs80FSTAYYGNWC65nG7eXLamwEFwUsFoYNbq2weGHmSq5/aqlhzVST
 qHr9/86S
 ezBk8WfbsX+EQc+OUwi2v5wzMrR1NVBGVbsRQgLBDHZ+Pa4o9wmkMxuWZfhXBe54gGRRt07eEp0DAZByrx+CCo+i+mcMDPWMOMOO1tYVNgZuhs76G89nuJxCZXnorDM2bxUknebJvZPrVi27IAq6KeJoySL33ju+w0PCd01ScY8qRHL1VC/CaRG4TWMYPbGBXdFO7aQFk/Sfuvf31w68Rw4dcv9dq47JvG+pdIcAh9zLNAlRH34UjCZIL/jASbKR7XE2gRGAzhVTt75MMKtnI4zBCN0ldr1SQzwbbrGI0TenYF2sM/8vKbvDTcP3dXZMHns1pDx8TSJkGPeXDOOj2z5AMjZ1PEJnMRgGmlPARWEjwe7z8vMuk7LXBwwjb8AzLdWTUH587gjZ2XJDPjYpULslSs8mdC7TpE/q+/FApVNtzibs2606nnb9ux4/ODCHecwxVlGYeP8fVuP9S3b/7OfDUqntNomM9kh9/U8tzSts0VczRrqnElodjk0Eny15QVDi7CEnWQFyzBNLmLO5ekT/s07Z4OYSjBPMrPjdiX4ELqEsmVp76itbzdNa8O262/wirXxlvzN1yL6oYdWU7Dt9TwyNeZasMOdcvcBrimEEXxbB0IducVm463uXTMSBWS778z4DI07yZRXrsegiktWUKtUbcTu/U4zzNCrJqJzj7EXxdSNN/R9kc95EK8o2fGksMs1NFMzOutLNDGBYbqSG4vwAij6otUWlSkTM+BChUYTsY3s0Ncfw3chYYXx0UTI9VzK3iTnEbqulCFFsKI93PsDOeQob1Mm03uK0tqHBFobjCmO3Zj8t+tKB9YOKmsQz2WftB855tSiuYSpgV/z6bnKzpNVWhpeHhHgZ4ag2F9bJaVpCNpa8Xqj9MCzxQBROVnlrRiHULLX/Y+dj498q+5s3z4B93G2QVFqGfu6nx7RV8JTlQ5NyZzXB1p3NH6Oz0W+VQMrp9lChANo9qX++F2RG/
 N8auwLwR
 Lmme4dqBX6neIGDB+patPRUS9MuRLfQ+VYcpCdhfQRjEXKNLWUXhsBZtV6X3OxcwJXD6BUPb12iK9m0YXhfxZsUtgcHEgAjV1Wj8/by5+bcaS3lTmLFoey2nOEGyhFa4DYByYwmahnc6xPc/KVkYFLwf/TqiZl/dHZMXRw6Fw/TsLw7EdRwklO2ygtEAsHywUGCjG97pAAnOwHn8jdA8SjF5MaorGkf3kqRU5yUiFcpNv/ftDd2PSi87YqPncID7iqiMfrtbE0l9wTfDyN6C0CES6g9qgVWRworSjfq+FdRGK5p2tsQdpatxFqH4OLWplP8ZWSkQGp0NtPx9oSOyJxCQgq9jozcr3GwSzN6iA7unhyDYvPj3jpZ/Ogu34N/aif9ZgB0Qm8SgsSsfpJNb+dtHDVFhA11+DyPBx/p2Qxh6E6wv4lvIgixBCjFLQ/lNc1iol0mr5mPSzb4Rvygi+1fLXA3IsuAGXEO+SRqOrSci4lLosIbbhYF1BYIOlDoVtrrF8NoeuX1TB9+SathkgGeGsDe1Aggp06YZ+BDyYEn6BIO+4P1vMuV+FJjB4dtfD2uJRi5M0Z7L0ePwapQhY28BAmqN8VcnfbJtAir1W0n01b7ZJ0zKcU/kRPMI2AAO+7bD9whKS0mbwU2cOMQUJAZfX3H3hCG7s6b6fsyrjXY+051zIjSbNUdamZ9EaaSSfoN1gNe3Cv1qE2rm1/uPZ9Y1WJ99WuI8gsrmtSHOCnSlUkQzw0s1L1eZSUTXLn0pkERQUpbiP+8hOUQdxYKX4JizcDiLE9BND/PPrK/ap+DgaB6+Hcve+qK085q+Z2UKoeLN5cYRM0Xn8MU1x8rnWh09TaWbq9tP5NnvAVjId46fk0/En0Qyqrt83pxBD4AOojhw1qqMrrtSAnEZtMwagYwqiB42ZG4+fOrQ/URZNkIYXE7NB/bAl9jtOAwdEAGe/Lu4W8tfO9evu2URVgm7QwUncf7Xp
 urkip34l
 XNdF1hGT37wNZkmBUSmUXCYBQV1ZIDgTPw34Yp3l8cX/D3k5RJ4LR99dbGExnjGPz2N7I1L76KbTWSincKb9pB0uB8asusj6/XoVBUeZRrb2xVsLThZIMRCol99s0haji8E51SMFFMLVkaiTpyKbs3M1j5qu2Ys7b/A74+wOh1wwSu289CE1bf4dWfXUuiYLbaj0HFP6iznu72vOQ22jE+r3x9hr+Hfkp4/rfNPSiDsCwdjlGYeDJ427ksk3QzHyfa8KsSWE+tKzf/vbyF23XbhlfIuOQgxOoakxW9n4EtFKcn/TYZkUUqJcoXxe5jM+Yltq158DDAHvZj97CxED/9Q3tfp5wEjoivI5MssQT2QbLGvsV6By4nb+rjM55/q7l3Hppt9By+cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings from %ld/%lu to %lld/%llu for i_ino, which is
now a u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/nfsd/export.c    | 2 +-
 fs/nfsd/nfs4state.c | 4 ++--
 fs/nfsd/nfsfh.c     | 4 ++--
 fs/nfsd/vfs.c       | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index 8fdbba7cad96443d92cc7fdeea6158c4cc681be1..334b63eb966e71e6af6adde61aa1123f01b4390b 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -1039,7 +1039,7 @@ exp_rootfh(struct net *net, struct auth_domain *clp, char *name,
 	}
 	inode = d_inode(path.dentry);
 
-	dprintk("nfsd: exp_rootfh(%s [%p] %s:%s/%ld)\n",
+	dprintk("nfsd: exp_rootfh(%s [%p] %s:%s/%lld)\n",
 		 name, path.dentry, clp->name,
 		 inode->i_sb->s_id, inode->i_ino);
 	exp = exp_parent(cd, clp, &path);
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 6b9c399b89dfb71a52b9c97f0efe9a1dea0558a6..a569d89ac9123d66bb47e7d74c7c98610de21da2 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1253,7 +1253,7 @@ static void nfsd4_finalize_deleg_timestamps(struct nfs4_delegation *dp, struct f
 	if (ret) {
 		struct inode *inode = file_inode(f);
 
-		pr_notice_ratelimited("nfsd: Unable to update timestamps on inode %02x:%02x:%lu: %d\n",
+		pr_notice_ratelimited("nfsd: Unable to update timestamps on inode %02x:%02x:%llu: %d\n",
 					MAJOR(inode->i_sb->s_dev),
 					MINOR(inode->i_sb->s_dev),
 					inode->i_ino, ret);
@@ -2888,7 +2888,7 @@ static void nfs4_show_superblock(struct seq_file *s, struct nfsd_file *f)
 {
 	struct inode *inode = file_inode(f->nf_file);
 
-	seq_printf(s, "superblock: \"%02x:%02x:%ld\"",
+	seq_printf(s, "superblock: \"%02x:%02x:%llu\"",
 					MAJOR(inode->i_sb->s_dev),
 					 MINOR(inode->i_sb->s_dev),
 					 inode->i_ino);
diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index ed85dd43da18e6d4c4667ff14dc035f2eacff1d6..cfd143b41eb1fb53868f378d668905c1c7d5f868 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -601,9 +601,9 @@ fh_compose(struct svc_fh *fhp, struct svc_export *exp, struct dentry *dentry,
 	struct inode * inode = d_inode(dentry);
 	dev_t ex_dev = exp_sb(exp)->s_dev;
 
-	dprintk("nfsd: fh_compose(exp %02x:%02x/%ld %pd2, ino=%ld)\n",
+	dprintk("nfsd: fh_compose(exp %02x:%02x/%lld %pd2, ino=%lld)\n",
 		MAJOR(ex_dev), MINOR(ex_dev),
-		(long) d_inode(exp->ex_path.dentry)->i_ino,
+		(long long) d_inode(exp->ex_path.dentry)->i_ino,
 		dentry,
 		(inode ? inode->i_ino : 0));
 
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index c884c3f34afb044ee5cacc962a04a97de2f7fd88..dde09f3734c2844a3fe0b6d18d596276a19aa2d1 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1163,7 +1163,7 @@ nfsd_direct_read(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	} else if (unlikely(host_err == -EINVAL)) {
 		struct inode *inode = d_inode(fhp->fh_dentry);
 
-		pr_info_ratelimited("nfsd: Direct I/O alignment failure on %s/%ld\n",
+		pr_info_ratelimited("nfsd: Direct I/O alignment failure on %s/%lld\n",
 				    inode->i_sb->s_id, inode->i_ino);
 		host_err = -ESERVERFAULT;
 	}

-- 
2.53.0


