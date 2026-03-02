Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D66A9EB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:27:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46FBA6B00A7; Mon,  2 Mar 2026 15:27:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 440996B00A9; Mon,  2 Mar 2026 15:27:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EE9A6B00AA; Mon,  2 Mar 2026 15:27:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1BAEE6B00A7
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:27:56 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E2EA41C313
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:27:55 +0000 (UTC)
X-FDA: 84502259310.28.2290722
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2D0C480003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:27:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fKcWRljk;
	spf=pass (imf02.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NF1Hp7cCjlpfnqnu9ff+Op7/pG6zZ1lPZJTDhP8oieQ=;
	b=pyQAEr8wvLsM14c32Xjb/0lZFrYGwEZNwt0i40vt8ftx+9hA9qIFcnEMwejqoEPLnCDcwo
	2QR3nJiV8Qa2HnKkiuZ0dsJhA6CaGFX8Xw1GUWG1/91MsWOqYxw4IlvRwtfqbjWc0hvRK/
	5VAQ3XBy0bLEoFVjURWPlcYm9kv0+Ho=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fKcWRljk;
	spf=pass (imf02.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483274; a=rsa-sha256;
	cv=none;
	b=5pxYgmdVpLDAvKhFTZzZBrU4V2VqoD6F8/Z+f14NWYIAZ/5OdufqLT7QgRMzgaKCbrKx/I
	U+4oQBknoWkLGNB+oZVPQI+FeUUXCRVEilrxfJ+EvnFE6gW2JzLGJ66M0uBcV2LXCBlg7j
	9ViQ+KI8LTnyBsVEkaO2mssVq4nZafU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 452F243AE6;
	Mon,  2 Mar 2026 20:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC6BC2BCB6;
	Mon,  2 Mar 2026 20:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483273;
	bh=nciTTDQZK5qL3LQUCUCqIfcKo6ZHsmG0S/2Wz1vkROU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fKcWRljkyhMMZ3o199G7gg005clJYunnzB1iU9CZy8suR9Alt4Fp/YmNJgWwziFIL
	 XzB1Y/wziCsMMUW6GFHvAtNpfbWNrPOdzvRRa2OuXPjlQu2g4Zv5bXzVhnK06KwWNl
	 KKaQ6raK6f4pfxIrCYYqz+30cr1BdbxPh6IE3chZdzaXtxXxSscfIE5515NT6Wvi3I
	 PN2ZFMFeIYs4Mp9nXp6zaUXXIVdZ2v8mI94J9wTJbxdLlwq10bbFI8bddDYEvNsa+b
	 HlcOdAcyVO+cdIHOy00NQtU/ZS5WT9oJQvXrOk1jVweeSJpTUNnjY6N76k09M+LWkx
	 lBMDt0baT98bg==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:23:56 -0500
Subject: [PATCH v2 012/110] nfsd: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-12-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3318; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=nciTTDQZK5qL3LQUCUCqIfcKo6ZHsmG0S/2Wz1vkROU=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfHy3iEDWlbvoHl989GkXqWG5TvmCd867TP2y
 WqatYkLrY+JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx8gAKCRAADmhBGVaC
 FVbVEADAsWmGMRTMR35XMoh+WB/EpKPAdnqyUxMzTxYr+ydkirRcnOxigphvl447C9K2I+s/djB
 G913QXK/8KM7sI90vMXGcwv09RasMmupJlyAQ58Sqyk8FOktvffY8AMjJUAAmQBb/lJ2Xa7goYY
 MM1iYebddqHF563/QzS4sYMTNEvGY5/uyP0t+7XBvk/YhmlvcKg3Nd7AyWhbke/D1Gh/NXU3UTn
 ZFl8lkGlpQN6+P+kM+7riEvZkcVXVJCVgjNXh2pDlDcdCCjve8LLHR2mag/kehPzZP5cSFLC42l
 KZNZ7xkE39Xb8+WUnCf8LDTF2427hxu2kQhIeyFs58FiU+PjtkrgZo6eM6Ml/ZAYoTYqDkjDRRg
 tLaqlAAsIE5wwLKLL+3XrZjH4kh6xVjJH5abuHNT1A3i4Z8FaIOhgpsWbfk479xTdXlCs2bc4cw
 LMAPoL32oMU6WgbqFBW0vqYUUdhSwJfqcohfkttig3Ouay8lvsZtcxl7rtyGFtPXLHRXWrJAIvy
 6KZF3ChI0I8zdoBll2VDlcB5bFDwspGq0zjEpv/fLlt93xFpilUl9qHwAz8WENXoK7t7dWqIIOl
 ZO+RIVg7MsVjLQ9fYFd0z/XQMQjENm3UeaSSkDmRD28bXOrfCP3hzSceHRKWKQ/OhnBIPlIAgD8
 FxliLLn7VHmr43w==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D0C480003
X-Rspamd-Server: rspam08
X-Stat-Signature: c5emgr6tdfiasib1qdpigx96kzd5ic71
X-HE-Tag: 1772483273-554623
X-HE-Meta: U2FsdGVkX19PTMtN81mWCK6PQ70mVd5/MW2UbTyntPjB8drepEAr+2ZnxKt9gvrqu0rLDfdKic0H8cjEReMPuPhJfsdWhsHbJPlx2xQD4dk9OYvE1WEwANB2gKROPz8RI6ZlxGfwzMnM05urWqWwQI/OyRwL6mnHSeP/lP57pw26+CVgVoyS6aBSeKe+PxwQRFyjVydIqJkADwUuSpjQ6wKY64/6j3SqB60WiFVJLs2GJMm6PgGKq1gK7VNYibyKm3pq5nteD713nEJmX3xYAjyCCQKk+c4C57oQI0RzMJJEqFeznD8Tr8Gx8Imx8sOIe+uTozfpBPgENKYd3WUUA+VZLz0SKYNschc94ehItkfLGpR8771AsDp9jZrooOEyaAiG1xMZ866aQGWTsETJzWhkwjICTDH1abfjedKvraBtZIejSgTuAoHObsIooZbYPBmLu5Ty8JKr7jbUJLxRwLU1VopiFma3jXVi18PaOm5V1rgTG453rmI5ygQi0IEfAHUo9GFpEtUvwG+vJMZchwP9a5oHQOdbs3UVOhwZjSkqXzd1khAtX3XDR8e1E75VTjQwa/kiTZBwjxzykdRLcD3GAo3viM1CrviA3e6sU/ZaTEKlrdoIhEZdhZRsTq0k7zNVGIuDE6bv7baxVEmajO8PaZn3Q0oFmpaiwFibG2DJQ305zmFmoo3MxswYl8mix4kxVvikknvfrPRx5+bHU8LvztiBGctJ2EgZxbiOXDKhTlyRF7MBYBfJyxh4nFozGmrSFV621wXL4ewqf66h9ti+qxryjMOj1jcRBrNP3Z1tw1PZuQ5ameVCQ4TRKYjEBCLbT7knr6cLn863yNjsRZbO2CkVLQnpYliJP/bav5ttWP0dHmGYsqvZl1zo+8qZO17oo7fYqGAG1k+p4eY2FRx63R1zSHA9tYPS7HDm5dSKJHxEoOWOPioiGlN+dwoTtnXDWze5pmJn/xCkrn2
 zLMzepg1
 qR6MPKMtuscM39hbTdtvcxQy0R0Gq+COxD0b2qMkJiB/kv/SDIiTslvQzVuvY9xAx0/P3Illoq33c7nLT+UcuRINi2dbmQ8QCLTpzHalNg772bcezxWcduBOTEBbwJZ8A0NUn6VfLUx0oR1T0YPrJXLIDgXUwaH+TSvaRMwJG0opS51U7DdUHHIcLw163LnVVHs5p2Cx4it7fTW4g1XQe+gvxlrTtLa6kcPrWzYxGhqEJig2KazXOoFsbwZVK3P6zRjDybpCz7wBGso9ux2ZhSBZ80zey/EGXFCEwuMcya5aZnwGzZfxvXwf0Av5eJKZNKzUCMXFbTpjOdjjcjDHVi/aqwqhHCKRtK7l/myNEEINhazbAi2VrLxU6znFDDyRhNI0KZROOSFUmBEShaakt2GaSDG98pYWgTLA2qIi46suUVVfbTRp1zLZ7eWO2F8ZjpAtTtOUbHNzvJTCL66xuQToPwMFVehanjZxDQGOfBU/B7eJDJM6+fZx6borhkSuFOdo2nLDdMwCtNkZWbNr1SjWe2BOuwX7jGplQ03xN1laTcWODsEon+qxuvE0gQDp+gp6sLprG12Fi7pUB5FHZHREEPOSuDzoeb4/qDETztNoGlZywL3faLmChQI2YAGyEu0tjEnrrjtNH+XCQ0J2UUq0xig/r0rnGM6Wl6k9rzJzM8M/LFAvdSSgjns6pgzCL2KdeNLERPiUlg/gDrGcw3/qPM2iglgh+2bXdlRViO68aa25Nz9CFaGMJtiEkNIwJbAx6SacYgAI5ld+5tEr1Smlp9r+bfTUO72XlSoAyG2YycbByFVdR0U80H1oalt6fuQmJidei0RNViRZjAnSPiJurajRbpB4ssD8NrjoOl4TcdVYj4h+bbmuiVs5/a7WXKlORrhKlLYfU7fqzOUfFT569zchO12TTgS5B68peoP4DQDPOx12J53okRGhCj4vOdwOwtWI2wvrIj5ttROGA2tXqcHpN
 BoSATaTe
 jeTQnPXwJ3rg6Y62pKqOCEQM63f9W6G3KkMS0yUM4ubze9VzB5I/hS7esJo8y/6Noj2B6du+m4JAzVfVEt9md5Ympi/ZmdxSt8n92Fgt1Y0B+s+P5pTgKPE14rYobKZgyBKqHSBGQrm5U6K5Ws7KcjLatc0GK/IqA5o7aIPa7ln9H+jI8mU0+3MzR3wiRwTeIX1aWrgFTykFSg1DLxStde/NbBlD0U2iYHzzNJ6K0dgwlxcQgpJd46wBv9i01wXKfxrVJ+v2DGYN8wIoh4flgiSwq5KcQ93GzmLxA1lvKFp2DJplzI1A+7DiPe/CYUT/utLNyDPji1goYGj40ZT9sQ19oErNZhZ8sMLrMYg9kK5+L2En/Qk4VSONIy5lPXSctz1kmRpMMx0OyIbjqSW81lbI6qEfU5ARXJX/NKDUEOuKGr41KZTHwNqeSY0mV1tEUBskkEc7hMESrjI/8Bq63fHV3J6S4Rc/hP+kgwCxi2oyi3qZBXEYHyWOmcVpQ/UCEzz+HIxO9ImH1EIfEzi1MKuzCWLjs8ozHhaQku3fOSWVYK266TiGaNFaxS5jxQPQ9P6xwkZmt3QF9Z4tZdq+YObm+Wny7mD9wBdliVMHWu9pJqS5VVrPTzhdPmt5tdXWUsjoAdIUWkjpngE4wDsIbRHp45BjVkVZ3rLB92u8hH5dZMwdILldlBWQWzE+tEDdwAGkHyhYgemdP2uastTGN/7vIa+djR23QiWpgRq1LtuX5gABlETBHgQScZWMhxFBSDwiWUOYJ6XEEU4SopcWLtmeIa0ZnY9GWjHzCYYCYeZgtwW/H7DiBVVfYGwGj6bbvHkN1N0W69BVGQ/N4gk6hllIbz9IyGe1pFTB31hasilVUibsnkIM9ulrBKbwf5PEUoGhwW0SjUSkLoW8ReHKmvX1vnBbNI+NK5AQXZNZMb2+gPdsPNHdAQGCIuNijXuBQVoBAW6ehzF+i+Ku8TcR1P+GCpzLl
 ZWnl1y1l
 WunapfyjQAPvfZDJLOnCR2dU/XChv3aQ3BAAK9PTeoUUqIjRngvbngEeGRy46oOzYU6En9U11I1VVGp5GDPDfjV6k0aeUKSWPpl4CaaMMTci06edywE9LmUWdSWmww6zQT2IdGHmIz9eA/gXxNdwOPCJ/mWr3bOh9Evz244UvOEXwJ+HzM3pjl8kBwbh1belPnHcB1HE4d4HzuNwjTHs4Gem7bst8SVMJX0T3OsnwBtdVsKVzCAryyIklqUGXIhCWhdQvDDtdQhCiJ/yc9WYOgZ3DYUoXcilmqRdMkFSF3FjV4G2Ejt208a+2SoT743YxaDUOfEmA8JJZBLfdQmvZVB1UxaIw8pRow3PyedOPbXoYMfTO9aKfZbAdfUWNlU6q5Nwd+Or5iwqNbkJs5IG9tw0FoLIA0WUscQxc48K6gHy/ndgMsbrr0kjGbWos6UTqisTnZI93GzzcZCOQJszGhb71RVGjTfkudfWkiMnxIsv7l4fVaum+LF/ZkpsW28Uv0fygUHCZSDuV2WD4ytZNqQ9Fnfv3aafAovH5TQgoBKsPiKc5PMaNbp236F52YC/CQMFE5KEjeI0GyOPzAygvHL5G8SV9C8vpRUerKkimGnaQOUh7hatnkJhPEUB4fU6zKicj44zho2I274sr3jcHJ28ChAwp0vn3Xgh4S0jkFY0B3p/oqH/ca9uHL7j6L9fb4gb6dkEQIWcR+DI/5yNtx4DNScEwW7u4ZXr/HtUHHn7L+rtZp7eCOhHswJ61yYJb/GBSVfYNCQ4W8EK/OJiYd6knNz2g8Omnng1leyXFwMCSoOqf4CLVNYyeGkwaS52gfOVM1rkWfIlI4eBWyqpltqzyLEZXdYJm2ek1UBjURForKv9mx33qdFUmgIRf94MOpwcxiSCYjecYy5xfp5SX1Qp5shOsOQVGQZ2/6lmy5kMLML4YMdmC9u9UbCiyJvf0GUjB9Y+XwE8VhxOgPPLLNuTJI2LN
 PYOzwai8
 090iWx+ygZLhposulrmQenhRxUcTq0JjmRn/MNG9a1ARjJXDmI38hYIWle8MHuuYH56EjDx0NDpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert nfsd i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Also correct signed format specifiers to unsigned, since inode
numbers are unsigned values.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/nfsd/export.c    | 2 +-
 fs/nfsd/nfs4state.c | 4 ++--
 fs/nfsd/nfsfh.c     | 4 ++--
 fs/nfsd/vfs.c       | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index 8fdbba7cad96443d92cc7fdeea6158c4cc681be1..5dfdd836bbb63d6af17204c8df7ecf3f450998c2 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -1039,7 +1039,7 @@ exp_rootfh(struct net *net, struct auth_domain *clp, char *name,
 	}
 	inode = d_inode(path.dentry);
 
-	dprintk("nfsd: exp_rootfh(%s [%p] %s:%s/%ld)\n",
+	dprintk("nfsd: exp_rootfh(%s [%p] %s:%s/%" PRIino "u)\n",
 		 name, path.dentry, clp->name,
 		 inode->i_sb->s_id, inode->i_ino);
 	exp = exp_parent(cd, clp, &path);
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 6b9c399b89dfb71a52b9c97f0efe9a1dea0558a6..d9d548225afb764326b2bb211919e24c87f15a00 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1253,7 +1253,7 @@ static void nfsd4_finalize_deleg_timestamps(struct nfs4_delegation *dp, struct f
 	if (ret) {
 		struct inode *inode = file_inode(f);
 
-		pr_notice_ratelimited("nfsd: Unable to update timestamps on inode %02x:%02x:%lu: %d\n",
+		pr_notice_ratelimited("nfsd: Unable to update timestamps on inode %02x:%02x:%" PRIino "u: %d\n",
 					MAJOR(inode->i_sb->s_dev),
 					MINOR(inode->i_sb->s_dev),
 					inode->i_ino, ret);
@@ -2888,7 +2888,7 @@ static void nfs4_show_superblock(struct seq_file *s, struct nfsd_file *f)
 {
 	struct inode *inode = file_inode(f->nf_file);
 
-	seq_printf(s, "superblock: \"%02x:%02x:%ld\"",
+	seq_printf(s, "superblock: \"%02x:%02x:%" PRIino "u\"",
 					MAJOR(inode->i_sb->s_dev),
 					 MINOR(inode->i_sb->s_dev),
 					 inode->i_ino);
diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index ed85dd43da18e6d4c4667ff14dc035f2eacff1d6..22df07be0650d9260a30e12c1371ccc4f89234db 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -601,9 +601,9 @@ fh_compose(struct svc_fh *fhp, struct svc_export *exp, struct dentry *dentry,
 	struct inode * inode = d_inode(dentry);
 	dev_t ex_dev = exp_sb(exp)->s_dev;
 
-	dprintk("nfsd: fh_compose(exp %02x:%02x/%ld %pd2, ino=%ld)\n",
+	dprintk("nfsd: fh_compose(exp %02x:%02x/%" PRIino "u %pd2, ino=%" PRIino "u)\n",
 		MAJOR(ex_dev), MINOR(ex_dev),
-		(long) d_inode(exp->ex_path.dentry)->i_ino,
+		d_inode(exp->ex_path.dentry)->i_ino,
 		dentry,
 		(inode ? inode->i_ino : 0));
 
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index c884c3f34afb044ee5cacc962a04a97de2f7fd88..4c2095c83503e7fddc7e1ec528f55e36b6a326a4 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1163,7 +1163,7 @@ nfsd_direct_read(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	} else if (unlikely(host_err == -EINVAL)) {
 		struct inode *inode = d_inode(fhp->fh_dentry);
 
-		pr_info_ratelimited("nfsd: Direct I/O alignment failure on %s/%ld\n",
+		pr_info_ratelimited("nfsd: Direct I/O alignment failure on %s/%" PRIino "u\n",
 				    inode->i_sb->s_id, inode->i_ino);
 		host_err = -ESERVERFAULT;
 	}

-- 
2.53.0


