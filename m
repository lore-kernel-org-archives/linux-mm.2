Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFB60EB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 658156B0144; Mon,  2 Mar 2026 15:47:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 601A36B0146; Mon,  2 Mar 2026 15:47:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D09F6B0147; Mon,  2 Mar 2026 15:47:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 36BA96B0144
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:47:48 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 095908AF66
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:47:48 +0000 (UTC)
X-FDA: 84502309416.03.A1B1582
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 24838140013
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:47:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mKF118Eb;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTrF/gcP4a8NRAtNnRiPMhucgInwn7vNM2ZqmvOhTXU=;
	b=ummPdqusLGGm19xFXj4QsgE1DRRsA0VOT1cwjF9oVDOnazec1+s6zN5tvfSJ7SUizfh2h6
	ImjQpIQV1rj3x34nrdv6tp4GRbGCejd2UZ4IntmXtT5anHzLyYgKSzaLEZhanAPIQYYsd6
	wetFZbbeX9Rv0PS34GW7YtC5T5d32/I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484466; a=rsa-sha256;
	cv=none;
	b=oio1slPGa3AonA6eCCIL1LhfQ1bH4K8e31jnuZJf8w8IkJ6QbcwkWGFg30aDKoFk5GV98B
	4+BqFbU14E07lGgOV080HQ62qeg6MPK+eyiRdLgPyxhIbQIs8q8x174Ji5s1CokZp/5nV9
	3XnYWv7GOfazc0i5dB91cHEZAJktu0s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mKF118Eb;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3436643FFA;
	Mon,  2 Mar 2026 20:47:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D5CC19425;
	Mon,  2 Mar 2026 20:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484465;
	bh=NxjvYMp7mxab9bptASYUwAt9ZY5sMtCtrMkINyf4Lcg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=mKF118EbNTK1Q1JUm9zwYzLqmUqwW6hCPa6VhG06QJSh9gQRRQlhj48rBLELE2moS
	 ar+wMJ0VUkk9bJ3zmdqav5lqol2OWllhoiXWdAhQiADxgu1TM32Uk3nkqrPSU1EBtC
	 cOFO6OSQqnZrWXlWrX29lqXNAQDHdTGIkcRToSyBMgCrTEpUxTgYkfZBg/tJpvkClT
	 4AUWKg+1Uj+xABZgUfW/xSDHNL8jydoULCCCXXJ6C4Ck1CZw+OWSCPQ5sjr2jCOUsU
	 M22kG90SsDj2mIOwFRJCm9veSRej5OGv2Oqv0cm7PIOSvtGTv42ooCNsZ2RAPqSJmV
	 YOhPUJxpdP5vA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:19 -0500
Subject: [PATCH v2 095/110] qnx4: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-95-e5388800dae0@kernel.org>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
In-Reply-To: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
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
 Xin Long <lucien.xin@gmail.com>, 
 Magnus Karlsson <magnus.karlsson@intel.com>, 
 Maciej Fijalkowski <maciej.fijalkowski@intel.com>, 
 Stanislav Fomichev <sdf@fomichev.me>, Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, 
 Jesper Dangaard Brouer <hawk@kernel.org>, 
 John Fastabend <john.fastabend@gmail.com>
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
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1224; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=NxjvYMp7mxab9bptASYUwAt9ZY5sMtCtrMkINyf4Lcg=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIJgP6owvPx6m4AecvkwS2n3SHqtsEhINcBU
 pHfVmz8frGJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyCQAKCRAADmhBGVaC
 FQGCEACfHvP6/q3GLuGZ3TS9t0/lSTulN0XS7r9+2/P3SZbBO22xao3gkyH9Kg0UHItz/okfvjd
 CBSNAlu0vC2UpEVaFkN0vJAy563Q5AEsg5zHOhDs/mCzlCxfWySyO3bIe7yoq/tTH7GqrUOPEKX
 ym072YWOMvHXuEFrJizTgOu0JwtiP9/CLIJuGbiokKXmELraTmmoIH/3hguaJSRDlUuKcWMuqOh
 V6lbAYhrp2Ww/+Z6oNOaADOIwcMvZeX0FbcwZc9cIUj3LojkSThWvRALJUImWCPjHmYHkzok6tV
 NQGX4vI+03B/kJa04kExDMCqhK/zaUfCJSbwbt8sm91xiIbijmBBqSSQ9Oph1yQG7fJIveQR3m6
 90vBLCxRjJIgD264u5wvR7VjZNdbEFZ1EzOPcQ2hP4mD/vT4jStUT6ZO+7KChUgKoGDbSXLXlVK
 YWtnAbs8gYWIZx++mqPFpNIQOq+2lH+0oGmU67E8s8GQn1tHV9kP3iwPiNiaBOzmWKYtiGrpueD
 e4xJZO2lhWqKQOOlU/Sewzw35+YTV3Qc0WqKBnLK+xNdb8CgMs8GTfxIeLxHXP8w4jxh7IpIy09
 ut6Y+AwYf0NWJq+dmqoYtGmDVp+LWbbU5O8xS+ngUV1Jn8NcXzZrnpn8L7PJQxM07xG1j7iqFML
 BGuz/QSgMhcfFng==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 24838140013
X-Stat-Signature: t9w86azgizkfea8k8ix4zqgo6b4i3cf5
X-HE-Tag: 1772484465-697366
X-HE-Meta: U2FsdGVkX1+5BeJZw+V/ITEQRnB81pGsESoqkD9sA8U5+V4FfQ46+C5PIbS4IZWTuUd2tphnGPaSyQ/cYDY+hOSt3AWEWmiwhMl/Dh/Dqb019RibfIFnb/OfL4FHsy7f0Xaaq2WCixnm0x9Z7IdmaFzNEVj+ZmErdFXi+nImpQe+4fqGvo/PvvicJKMpDh7LEmY0ZpyEc/kZg5AQNaNDqbI3CJ1wuGzbwcs0kwS2n3/G7tqHHHpEcRDOWZkDlciHAuE064iLNOs5DtN1wGajwfFDr6DwQ1npLK9UhDGtIUPSQvCSlNG5pQp9ewMK7ZfEY1xnM/eZ+K2Mh2CH0DFWgYeZZ3wjfyeQw49VDM2rRXRfhqt+YaJIZyrFLyjQPzXLki7jEQSXHLaLcnfSTwG0nyNdCerkzKmgftkIgkcmO8s2r2/JrQRmY4KCyCx4SIg3lzDIxc1auU1bUD3nlx2dtglo1/m0n3InMeTxmQPHlSWY9b/usLYjpoto+ixEsmEgUS23Ce01h6Ph7/HlRTdVCeFUiQR+CbF3IW2rv6tWX/1nhSIyA82umX5cpjikGTb8AvR+2xgKlx1bWqXfgVz0GzarBZG1VcKKNY3/kpwXfgSqORGd9iGeEff3yjgEo9Jfg3fk0syRFkvDCRdSw4jbvYpFR3W5emwF/2I2kD2jpxgzn0Yf316r//lH9T71toH4VuSqY5bNQlM5TykTe3V85Qn7a7PUDQq8iMFhWn0xo8BLArnEEx572eY5BkHZYMM22SkLuuLZRXVK2uzbVsiqR53WBj/NNgFR7CPMQawuGeIu8IwYmWLFl8ANzLpk3KMiJwxsNl4Yrz5V4JpE3MtvtBYsTZ43b4Us9BpaLfxW9ex49m9ts9SKOdYwbb8BE9vcAHOPZwKjPa3bnMSfGECcmgG38qoPZhi1SAA8/PZDG5xCVjbttHdvK0nr2nj7zK+1ye7ieAM14szVrpfUY0/
 HVVltdyu
 xHJbAKmm9gkA9IgL7TNGyHljLz3TpHnRJRmtG3ySTL2qPZMLxm/erfj2W+V1isc4a5C2QSqiR0jVRc70CbMV+q4P5cBnexI8CEzFxmbvQdKtisyVDGhss7g8RykOVmlZ7Jo2YOxeYcK4una6NZufh/uneV3kEGsiw6EPZ7OM62pbp3tc+BJZT5r2zMha4BjQhrN0LxC1sep50OKepzsnGCCCcSdTI2PqUEGzJLe9mMUDKBo7fbeIm4ZwJjxfGCXYZdF8zeDK4aPw+r5UKTUQMypYbsRGRc/GsrCI5R056R1VdEBTUrN26DQurI4IrDDU3GE6r46AYlUkMPJNvf8F6UyPZtXWshhIQeUG1qrqYV05wP2jnyCZLM+YuZz3wSeYRzdaVtjJo4JQFCtm8OX76buO8gyMCcyAWU08GGn4razBxmb90ucD4Kw/RhSjnMMCvQcYQXklzEKIVkH1IEjL82Ob2h6VV3OW7ZcriegI4d1BlfJyTcJwIoabg7K9gODLno7Ow5QWyppUiiYQ4dJfS9BmIY0Pa0a6qZAYJzrJaZVY4plqT8Vqi9EDBJoHzVDFgpJ31VOufcYAnlyPjTPAek0bQMlw69ljn4Xf6fSEhbSwGaE5jzw2kJ9SLQF5UUkxX67WmF5oDo1uJXgaQhB+fa1ehtL+nZn8/J+MJVU2jNAUFX8GnwOZuSiuG3o9kTpL2/o2rSbZG/tqnpAzptGjgSW1H9MXLMQ2yQevKMDyk1LFmsBYAc+yLS56Gqi6pg3hQi6IR13HUUdFMKmkSDWA/dLZVoAm9gM244MfCVAyA9/bEbAhrky7J7ztG0k2cRUkImZGUNGclVgkJdugqyCNAkPcyA8Kw4Ns1gI0M1SzGavwAEuYx0SvN1IQjFJULJ8uXpFsORZsLz1BaFj8i4XbbN/f/37ZVt+HFwDyRn+vv6UFv5m4COW3+hMgxTJLn6mnAt9Fsy8jhNpmPUZPYnYslXpmOgeF7
 7aUBKMcG
 SozfB+U5P1dLUq7iOMP4xJcJZ32OUzwNwm8QsAJPMOzF5LLA0Y6nbYqF11nGoOoqcVhXAiq+88yhz/h7UaHlr405650A168M4UfUT47vS6EvXYgcVk5j6UJOE0gWjser60tR9yie0nB67gkgDxoMl/ttBcRnE0P34TI0C3Kj+p5dJ70YLINdWW5y9UUKEa6gidEwLw9rk0j4+662pBDUh/aMsxQ6LBknkKMq8Ym6XQ1vrd3rKKiAshbF+rstwqvk8lazgttTJ8aN06ETHuxOCMglvo1fM06zmkzhhmI62hEsKW+Mc/ifOre7Rwge+Lvnd9e/utDUqN8Yj2M76ek+YNUhvmxlZeao2wM37m+/cWgVmZVkx3hjL7E2exV/0ceWQRABNvFuzl9NbSoLzTV+aIGcdcT4ezNBKBUhDhRqSAk1RZNROtQWxNAa42UF/EKaArWQzGRLEnQZCGJypNosf0TmhlVDVAerS4Xg6RcpbbyLoVRWgAbvfP+2jrz5IQsWC4Nxl0oBim4wobfFlsrA3ubddQ3vGXuAOZkXe413uLmxGOtD7KV0ZqMDVWV5fuejr2Fe9a13SfKr53y5HMVD4Hqe0GP03j1vW/Rdem3jBjrPzYVQRelIhR1LiT92ZvqwY+IbD9XStyEmCSkJpa9vTuw6oP0D9kE8UBeEYeDpy+H5LHPZodx1NeqVqV/1OucdmDYcjAh9lFBQg01bRbK08c7G5nz23ctqDEYg9CAuwkd5JsZGoBraacuE0OMbT8TlL7hJ7zFcdSPkOY0tMfKBxjGhSduwcwvgr86kr9VpYhXrv+PLTx0rDGknXP02cntZooUq/uGLIxhau865H1nWxVEo0H+GatHASk9CJvcGabFD5qll43W+Sq2pdVlyoKrSDRmouQ+TSGZSlcAKqolb4Niqaupo4EMsnpqpYjoonNKWvhOHOfgW1uPO3zfzaWr1MB5PeAiU7AEikjEIAFNtd5SwHN3G2
 A7B2qEmH
 f4bflRtgTrSxH5aMh1ghWTqMxXxG5ToNarxLpeobF+SE22Zw1vfH+q90c4+vC00/S6dV9yDuJsIySuW99eY2+gMoA9O9icG1G8wFsgduzEMroxE6pEx9v9S6YmJRFkQ6h1TxEHH8ex1joa+ubX4c+zCwS+lmf0M7dKAv2NZglqS03qFVAk6xEcc9kcEIr8oAfJ4Rl1m8BxSA4Py96HVnsktISPhS5jRWQi4TPgZ+o7bG3h2dDqlrwoWsqgWqcYcYFA7dXsrelqg2mbflXBbFnt0UfEtBflz4gPr4tkIJ6113dyIVrnCD03StLJ8JMPAcy4e1dCRLt+Z7zFr9EdMg3BgPBklGa2AcxhXht67sBHgXVsq8BOMjv3WOsnEIHlUrAgxgtOv/NiQwhMoZgcsvXvL+1lgAb4uUyKZnNR6swtfPwjtAE8/nCJdWgDKwVga3Kfyfga1fYCyqooTbvPZ4xIeUZGtkuAe/388ZwsedQq1afbiSLq/TKOmNwm4eyhXwDdKMCTxtCpadmVZzyvRIAKZxmpiiqcPBERn/mM8oIyp1ElSlwJiOrZautupBzIS0mlsr81qjSU8byP/eTNt/si+sf5xulrM7K7tjEp1YTY37t2qNLYH7y07zrX/IOaBFx1aE/xH8fs0q6pzJRl7W/OfTgJVAGlsWoZm7yffcgd6pGliR3HpOulTukJQ5Rhw+GPq4mq7y9G1MULX9dbj2W5PeekG2EvsT9B5J7gqlyUuZzPwXXJPL6V4K8S+9czTa/DVKxOrLnIwLt6xFnMx9DX2U5UbnHe6DwCW8pc70IFVNndegHHUX3q+4lmVYccqK/6sycQ8F88UHVqEI7YiNIii6FTWtg12Izt8MJWrWHvwNNPQ/ymi9fAJA3GPpqgWdBnDFYknj+hMQYzWoAxnvBVZ1v1wM5PigSjXdQiDMEcBjH7A78hr2IEYw4nviS8/Z/Wk+1Q9lmvcvn01OGbUSaGtgElQiw
 K79L2HaX
 q6hKB2nk9IFISkpmWDngatIGz8gX+YYeFk4Ag+XAPuGCn92IGY+CdzocAQ9lUCrugH9V46KFr4c2ShiQy8zcxcigihx5Rg6vqbmyTl43TmcnQDR5N7UQuWewagSfinRDhnhYKmS6yc4LEGM06siti1QjIOo4FrJ+IceqpybEB8sgeOwUKx6rgYCWUkgDmN7tb8zyHD0CMeAl7vLk5IDPcQiEfl5Ltl6ojpDIcOp2ezRiET+myl1gxByHaGXNhMgf7jHRRZEFeaVSfRTFasMouAlo2o32xEYwv0PQvxDgg0IscdfClyg5wOfI3AB3xT5HmzQXhxGHkRSrcBzVgvXpVtTc8zkcjpzoU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in qnx4 with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/qnx4/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index 1226de01f2d3c1d79fc054f2b882fdca2d9d78ff..4deb0eeadbdef3a580d57fbe4e8518da0f550cb7 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -62,7 +62,7 @@ static int qnx4_get_block( struct inode *inode, sector_t iblock, struct buffer_h
 {
 	unsigned long phys;
 
-	QNX4DEBUG((KERN_INFO "qnx4: qnx4_get_block inode=[%" PRIino "u] iblock=[%ld]\n", inode->i_ino, iblock));
+	QNX4DEBUG((KERN_INFO "qnx4: qnx4_get_block inode=[%llu] iblock=[%ld]\n", inode->i_ino, iblock));
 
 	phys = qnx4_block_map( inode, iblock );
 	if ( phys ) {
@@ -128,7 +128,7 @@ unsigned long qnx4_block_map( struct inode *inode, long iblock )
 			brelse( bh );
 	}
 
-	QNX4DEBUG((KERN_INFO "qnx4: mapping block %ld of inode %" PRIino "u = %ld\n", iblock, inode->i_ino, block));
+	QNX4DEBUG((KERN_INFO "qnx4: mapping block %ld of inode %llu = %ld\n", iblock, inode->i_ino, block));
 	return block;
 }
 

-- 
2.53.0


