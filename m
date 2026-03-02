Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D48BEB3634
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:50:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93A066B0159; Mon,  2 Mar 2026 15:50:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 900A26B015B; Mon,  2 Mar 2026 15:50:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C26F6B015C; Mon,  2 Mar 2026 15:50:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 67D356B0159
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:50:28 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 30CBE586A4
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:50:28 +0000 (UTC)
X-FDA: 84502316136.14.B914E52
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 73D088000D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:50:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dUluxAGL;
	spf=pass (imf02.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMoSJdgdENlETIvEUtfq7nApMbU8o6sDMpY0Y0wWbn4=;
	b=sB1m+XSEesuNf6XZyT3k3qfYSzz6QtVZLeBP+khPHJT3KMWuXVqtRFtI1PMXopgsrPWvaQ
	6xFWs7HezkClu+AW/YTgDpdrvIycNyZtZrYqrv0RInIod6N9n97eFJEk83nB+GIXYoOY+T
	t9TkJimYZ6+JyHGDKAJrPuYdvuRvalc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dUluxAGL;
	spf=pass (imf02.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484626; a=rsa-sha256;
	cv=none;
	b=GGDQd+ElG3smVoR+1K37FStQ1dck9hlf8X8LeTGN/1p1cRA5MbLctnTiW3S8dXwO5iZ1Ou
	wDIZJ5FWI5iJqTOeLoKapcjlbUEewNop1GN+U9TOT3MYDST7FKipYd4QSZlFwdKI2tRTOL
	f+AuNQyVKazCJIzr7/cbHb78ei5JgEg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AE0A26183D;
	Mon,  2 Mar 2026 20:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFC1C2BCAF;
	Mon,  2 Mar 2026 20:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484625;
	bh=uNYFxtg5Iv5MXUsRjSnqZGWzI+LksrISC7QvWEDcE88=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=dUluxAGL9dbpHV0Un3l78iD2YJVbMrQu1Bd02WAf7Z4BPvMflxqtAVZpbEzaq6i1Y
	 WuUqDTCPchi4N+ooyqer66e4url/wraC+5KhJdG0UPsOr5PEn1NqTwnidWuSdRD/sT
	 Z6EtOJh6y5/KBCbHADqSwAP+FwBnT+EC+5niBxaZAZInGEGGUZpE3P7E0Dpo970iZI
	 cvNPiWtZ4VbDdM4Jwr+YTreyWRrF06Nw5T/nzxV9YtUj6jZP3b8YNwwRsJyB2ZfVwB
	 ISrbSIaAOOY5322QCpIywNnN/Q/FGKDqkJJf3EUTq/1XU9lYa75SMvlKMBB3wuYXZu
	 KF64/hQAst3LQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:30 -0500
Subject: [PATCH v2 106/110] drm/amdgpu: replace PRIino with %llu/%llx
 format strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-106-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1242; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=uNYFxtg5Iv5MXUsRjSnqZGWzI+LksrISC7QvWEDcE88=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIMt5x4iQABLZluIVrTQbU0nR9vsQFBc6H8e
 MaC1UngLK6JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyDAAKCRAADmhBGVaC
 FRSWEADRmDAkhNpK6+h7nauxslYyedT5jkgsddgrricfItWlqYChN5XEbiXdUOC4dm00LJ3n7Nm
 VsWfAVmXtEEMi1+OpAFZvptU/z1Uhp9fYwk0i0r4u9ryoW6/Hh2Q+i04MpCrkJsEBlVnFZEF1Ri
 z2Yi6MhJXl8YpsG98d2VAXOVJ7cfOynOaqYULzaleFqzV/irdYjVAZ1bSb2hpsbDiJgwtxXnemR
 2vmYccDKKghYcmpjZHg9r2aADiTOyck38QbcEC2urm/h+1jvFG0W9jPua7cXa2x3Z/pJZiX+mlN
 NC2f7hcaxhvWDuPOvxL5+/VdL7xIL8L3Px4gHh6Ffr1QWvth403RYl1iUY30L7AHGxs72TnqJN8
 CLghrL0HEqob/Q2qg4+542aTMFH7sqfBoP8+vK2E7w+ZS5bm19LLfKuGuwhzUpCua5AS9L73+60
 VCBvv8iCUYZfwgoQHkqxe7w3Qkz3Ictbi61tv0JW6jg0DvAiU1dNNFn67R1WJuLRFR65OSXw0g+
 VpqQwvPKpMNahMcL7sma6piTYysuNd8Z5tbgGm0RMauZ/TdZMXfcn54KRTENJ2KU+CuzXuHHdH0
 Pc1W3xausB9ERPDY1WKRZXPjZ1W4zh9wces/wn5ONEa8DBA7snqsUlleWjtkb0xDTICuyOdXk5R
 KkYgGAqOFGM8+Qw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 73D088000D
X-Stat-Signature: 6ky1xbqtnecwixy5ct1e1gxsmzr7z7j8
X-Rspam-User: 
X-HE-Tag: 1772484626-202966
X-HE-Meta: U2FsdGVkX18V6dCjmej5QKn1XzmxI2USi/Bum1MsECTSwENL8c/2GOCwayNXcBqnhZTglPrQWAVgBoAdkySCJI9ercVhDZlVnoGIvwoBZhmMuHOoXHldSNXbHWCjH8Qj0uCRLgyyRK/kgLaTWhxb64PtGz936ifISexOnbwYsk5KdWFMD+yuCaapuCqLYxNPci6+7AoA7tKp0rOufO6YtPy/gNofzpPv6rH7q7tzHfRuUK+tPMZf5/0vOLd8DDs/onBv5KhfMfPLC8sVDo0hgse05xMF5qI7xLx4bbQnctGh+W8wZplLuYOl7XgyO1FwB1eZuGZ2TKnthTN4czbLiOvIdc6J+qaypD9suOfxgCtx1lGZfXUcEdz9cJOvWTXDr4ZQe/iA62bHUnA92AWlJM6uW5dzZvVrZvXgapWQwXju+oH9zd5h/WWBPT3c/Im4j0qfJF4J2TWruC9XgN7wwvz40+1D9n+w2wLvEatsXJ5aRc/ZKlzI/SCLY/otDWYmYJRynls4hHDgcNN963b0rlWVDkGMbYRYnsIjzAxhhHE1hhIwQlX5w0XletfDttA5FxNU/fIuF2g7irp4fSV7J9w36xnOHoJifp5f9ewtXiX930wIUpxfhnOcnxJwf3+bkLNeu6q6ZIRrWjwea4sbhWk8LdNbS5XbCeUKY2If8+tnVOojuvJQ5qX4R4qnNIh+L3MCWmOr+M+Q68eP6cK7UCYehegQuOW+T9+muDscMx2JHdJJa/bmstHqTLmipaVRXUZqL+uOPa/WZ2JsNOBRkKQ93BUfRfvWLHOQD2gSP4I1CotdCRUJTI62ncg/klm5PGo7Tmc0oWOV4Y4QMqO/5tbVBPIQSQSEU3ZxosFoi0iqZKqpa0sP7vD1ScvFuF2+t1dDDjaZ71xei2HXgCcJ//IlkRrLfAPBMCM6cgtdIMM1/42QM2fux3RimU84bfHBPcrSzjJN8hdTk4m1R89
 WtHE2fbt
 Xu+pXA1rOCFlqus8gKYto02fI7d3dM4CiGXU4T/uEhyjKOg6myr6ymuYMFz0goJDqeI38UEodc+BtJ7zfFAbDFZlUe5ZsdjCe+UC+25AZGWKpE0ncAxiydBPiTtJIyxeZdbqkQeZInLG1FM9gSjOlMSQzl4jm6FHWBoR6tTMVUAyFwSO5mh3DBjgoAlcVDMpqLC63O4sm9DhXS0I0t2B9x+jPhkcdo4798LEsza0r7SK51W6lFk9JNf5xg5NK8Ha7qqnAc7mDYpPTCUqLnMYhFJwNIHsoHxlYV58QZCQmkAvg4XV0hOGAy8N1+cbfxCw/hhyQMejG2VHOeqzN5G/4rIPlastWByo56ls41nawG/c1AChASNsH69byD//x866DAEOr19J2ggHzJHhWjxbYeDtlRhKjNfuc5GdXNzfr0i0Nbn2VrcvFfZj3Ab98khhIIUaE5Yzje2+omwrlsxKLEi79b/5H0mv3i8XfefMO5l4m5aXisMFeiGqNQaQBQLFTTnLBORyASWjbTE+ZUp6ls24X2oMNz2dmZQiYmCVPMiybgMVSwP7OIsPdVwiGFulvOfGwj4lHoVdQhm2TpVTKWgRJskFSgd4kWH/i/1iEVAohAqzX/o03YntLrX2qGRcECxz8FlxMoFw1kHZb66jZqkqpSwapPgr+9aF4epqQqShAgZ0rIBdFfzWbmmMbTbEqG2RlBq3/5D2nXCuFEFn6n1rRP0LOuR9k+L2UB5W4tL5Pcapb2pgUaJIlpIn56BvyVREey36FjJxkFYL+PJID3NeLUmgicSQGIY/ObQS39LXG1LzF5//0y81gpHPtgTiS+/Y0yen15J4j9FkKp68FBzm2EyldPFSxNxWuANr1CNUlI/KV8vqiteHz48ZBOk8oEQHwLVt2+yC2DNa/3pEuUIBZdKmvqt8z96jqI6bJvuPq3BDsSECvUnYPHVMuaErlMGKkKh8p5cbXUSneTj01iYzZT8lg
 BHBJo2av
 UT6bWfMv7+QOva/Wx+iKAcO3lRjF6Zm6O9ArgbtJgjlSfEdIScpvhASvXimki4hdPlB2WJE27uZja0Fzpa7CmXidS/397SzKp4ouzX7lutFtFrsX7vK2c6nintuMp6IWLmODPXhSiWCF1kBwfG8Yo1fqX+v1apw1LK1RxJBg+OQ/ocTB142bWXqbLUgBjQGXab7KCO6IHrsb4KOhzw001z+s85WHComEZ6dw/BqtB8QhAgU42d120CKpAORb37dXu4C1JUSo9rj4nskW/GDL0NLQWbiz8/iERvUgC5DpHl2zL52fRO+cbxgVZuRTEpi0FRwk94mscJpi6A0rQAoRvKBV+bLht5ZQ8K3e9SEjDjsa+CFLljkzNNVnw3ri8iVYWTggSrKw7MF3H5AOFh86ZfF3e1TDEbsJX148bEfXtK3M6LgYUmjhcJgD+sVON/39195fKUzX+A8VGTdDyd9SNRTCSNhAMpteekNwuoiD0TUhsu3ahJvncBERWCq4zfbQmUX/l75+1j3rckjkL7lIHvFZbkZ7NBWvAEyArxjt15L9MmrOaS6tF+aTwTDyiuXRJQHDhU+RQN+QkMbGdmJ1FrG9RWqfJseDUWNvo1zte8kF0izxK7wgzddtwzjj70/WnDBejOrH9VeRD4hbIdqkiZRt9P6jEu57ulRejo6p1dvf+pT9oiS9O1H/GwTwIURquZEcfe7uqKMbZZXJEf6aPmiaYfg0N43JZfw+ZQ2Suv3zSSSuFDGXLOK6EqGHU/BWf97kAHLbFNtB7bjKSuo531KSJTfYrEvposRW3e1lP8ev71UwwWIB1rJFwtXiTnr9aEdajLnFJ5HArRazOLY6FY+nkp+qrYOcq2TLnyzY42Wyh1DLadarlAsu7y9y9QdDafeS7UgRQfH708oq+pzLLz5UKBq8ZLmXNFy34OdXkfvWraxJvoa39oUr1Er2xmC4P3xx70ksTLEjt0xEV4RbQ2XaWpUkH
 S3FBWDgB
 PVmWVXXAMRuRl8XxO7+DYvsKQHHgtpqqXscFusIjx0OTIPb76prbatapjEHLroA6z5MXnHUqHBk5OVwJLYZRPIEZ0HJB6jihf+Nn9NaCX3ex+2X9TYBHd17gXwPHbxfTAQkMuvQ6zGdqMvbD/kLQcGOtrRRk7tvBPGvda68zni6BylOThr/CUJoGHWjR27jkGKhVd8vAEvWfxG9VtFgJ0PJfIrseT20wiuc2Cjy5XKMgmSZUAASikDun4rPCaW8oUM8z7L+jJJbQEQwm1HpO834luSaokbNJztygWBk7td5y0V8gp+CL1AQKWzaIVxZgSmdlftoq9P+dCuv509cKZSNrMm034KfGewiOTW2xdzLbKMiYaSU4wrm/Pd2qf2TFBBnNUaKUqlEcw698h+3vNge7vzb3MP32NtFilNs0WLeXiYypDjJt6Jy4CngiKX/6TkvR/t+0T0QYcQgHiqBz7nesi1culILmiRkKvoXXq2SMzoNRv9jNgVkXxAYdKXVOOSmobgKo7BQpOUHiHDZPV31u34isNoZDf3eLh6/SLpPtV/FV0/aD4ChCrQPMuXQ0KfenmdLtw8YhZU1e/BoMj14R/ghxoyYixDlVKN3RlH40hp2XFSxIi+9Ov4xgeetZOi/ycuYdy70mcWbD/q1gWNK+AE1HserXnh4BCEa0pIkV7ZRkbfP/Ucgac5Nu385QZpulmnaVPMQcjMgj41mj1W7h3MtJAc9V2ixoRIkufb+LnP/BK82/kmfatdOESejbuw6RIAC252H5IJc07iiq6uHLdNyDsV8nynO264c8ikItNIxF37S8+m7uvOjEzgBl2BrF2FRkJDpgIAzxLcZPECNiDnv7YaU4iB5d3nsDBTvbAIdtaFu+WxOjJhvmVI/xAxWDHOd0RNNh4m/uzb4dHz8SEZnnlStay4ScCS+4T31LgVspdWxNM9PY2NKWsly/RH6GbXBBrP6+dRP0NMUqshTiwTpxK
 YRt1bW3y
 cQ+XzsOJhVpyMN+GXfeXqykcIGFrQ97wOUdq/5vcb4yd3b0XxryC0zr3WmQP39+igRwlIrhh/rkw6K5jCW9tw8dFrjN2z+OIt68SmPgX1FMxZFl21jEHQldqXz3IAjnYYljWGOBgZl+wu0F+UFrsk3JQcmITjYi00QAMjVNuqUSvnG5Vd5ng2852c+GilKFVxi8g5/AWn1QLNmsjPsjtDwPAxJ8Xjgpe4Ps2m/DMuzCtklJIwvJ7Lfe458kSvBQVBeRe2NhPPYkSlmhAmERBTjaF2/y0Bi8WafRVq0pu8qntziRJrNALsgYhWZ+DC2m7r+lFV+9eGmbeTESw4FImWalgQsoOBt/Vs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in drm/amdgpu with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index d62f7cd1bdd3643803a99c3cbe35fa5b19217eeb..aaa8cdc122c49ebf0b5b6c55edb3a1db2a4fd710 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -1676,9 +1676,9 @@ u64 amdgpu_bo_print_info(int id, struct amdgpu_bo *bo, struct seq_file *m)
 	attachment = READ_ONCE(bo->tbo.base.import_attach);
 
 	if (attachment)
-		seq_printf(m, " imported from ino:%" PRIino "u", file_inode(dma_buf->file)->i_ino);
+		seq_printf(m, " imported from ino:%llu", file_inode(dma_buf->file)->i_ino);
 	else if (dma_buf)
-		seq_printf(m, " exported as ino:%" PRIino "u", file_inode(dma_buf->file)->i_ino);
+		seq_printf(m, " exported as ino:%llu", file_inode(dma_buf->file)->i_ino);
 
 	amdgpu_bo_print_flag(m, bo, CPU_ACCESS_REQUIRED);
 	amdgpu_bo_print_flag(m, bo, NO_CPU_ACCESS);

-- 
2.53.0


