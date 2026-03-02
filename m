Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2141AEB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8658E6B00C3; Mon,  2 Mar 2026 15:31:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 819216B00C5; Mon,  2 Mar 2026 15:31:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704866B00C6; Mon,  2 Mar 2026 15:31:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 590E26B00C3
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:31:32 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 09B568B289
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:31:32 +0000 (UTC)
X-FDA: 84502268424.02.51A2EF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2B922120006
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:31:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mn1jDEeI;
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NW1F0zlk7ugJlQbWALTPX2PoRJ243c3oY77Ce5KOOzo=;
	b=7m6ljYK6bdonXCHo1e8a5WROI9dnYoV7jwGSq0Mqqs+9vD42AXO9BNq9/GEn5AOVOQ9nk0
	lthuB7okaSfIDMOYQYSWfjPBUHb1cIsbNqH2rqX4gIfDwP7ZjO/CDHasf4jQ3rJJmlZ7eQ
	rjwYdW4R3tqcLZh6DEsoo8HfugCSrIA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mn1jDEeI;
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483490; a=rsa-sha256;
	cv=none;
	b=D6nTG1/aP3FfAhXdAcucZiQAd1dFnthPU4vdijuNpfZ9b1/tZREJxqYZK3ht71KKA5kg4L
	s9Gl0mS112lj56azsfXYkLv4j8bYi9nHdjFWYJVnkg5B2KIZDcjcTYBWBAyatyA+MTyjxF
	lSQdH6QCi2TFmDwwBSivXanIv4v8xRU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 52D5E4165E;
	Mon,  2 Mar 2026 20:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A54C2BCB3;
	Mon,  2 Mar 2026 20:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483489;
	bh=EUtvhtP85AhwBvScrYqnCppGsNhvVgwIar2mU46rYXU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Mn1jDEeIHTNuH8npwJ6PAZMEY5mnygPSTBG2na8sq7yRuo3NkZggb4wUeRpbvnRpB
	 OkZY4VEEf4TdERI2nnBdDbCfdyXMwGs2FomhvBC6xygk2qGLXjXjj5k4URDOEViHrJ
	 5vWB73Clu4powjSrewHesTWAuzpk7k1tqRCTWZcTlwkfdHf6UffBReM2ugKG+iG1wc
	 0AUvUfpKIzMO7jxzftrwjQzFtEdGc7hJLgflIbyg49ZpR47fcypQD8i0YatnVbnSkC
	 GzWghdAE0Cg65NiYq1VOtsK01J9C7d5sAnZkafhZS8K749Z/cW0PshXIffzCpc6Rz6
	 cUxop/qZ+TYwg==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:11 -0500
Subject: [PATCH v2 027/110] efs: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-27-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1592; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=EUtvhtP85AhwBvScrYqnCppGsNhvVgwIar2mU46rYXU=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH2Wb+txQs3hUYjnTffsfzpJlLE1nFakCE6h
 FGp+U/n2/uJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx9gAKCRAADmhBGVaC
 FRQvEADQeW8jCH/RGruXnEY9hdq+SS533KeGGxnNJUZbN/kso8RPKVZtPoOVxAHIgXdD2iOlpvP
 gGyroUgmaHH/E+sI42ij0kNnaUn66OM1IViP6Qpl3Uw0Wjgx1VqiLu+OL6qXw4aKHREVYcNoGkg
 P5DdBdkJhU1SmHATBT6CccY4S4kG8s/BVT9Wnzk6e75j9vIhlkuJxuJe+mzKSV4iGprhIgDhA0e
 ZvVCc5wO5GN2EZKMqcwzhrcoOJiNqS/Nt7uz7/C6WREVEwuQjsjWsiCU+r7nLc57++5xAKCxBUL
 nZSHQVFXIXNFbrU7Pk7kD62JOjj/CBU/q4JrFEr0hYP+vLHTSqNll0HC6AEQdp5lGrtMLUTSUZs
 fyWsPziK0k/sb45uMjPIiG6RMzHEcuvgEnwNYpr9V+/AS0HXYaOUB1yMPZCqzrpzt625+1wH82m
 XeGgtH/X/jtfbUUtJwO6AwvrEsv6mMq4XWJlNteJTQAWU+xXKdg03LAOhonGMbYmDnTjWQSbGFE
 HMFiTkUY5wT7QqfZvbxO9nNKh+BF1X3rypPAN8CunLYNfW9CtO/fKzCbrLEPPh3+yXI0QMILGoY
 71lGdDmo/RqE9fZxU0hqghAJe2Um8QPCiu/jqbIXeZuAUIpyCl9hDpFREd9+3ljAYpqeTxU6jIP
 0qvVrWu34KEe/Ow==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: 2B922120006
X-Stat-Signature: qgg715jj4s6unrxzhtis1dezqf59k9e9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772483489-702115
X-HE-Meta: U2FsdGVkX1/rN5aQYFShsOiO9KismaMlVLNDN27XIn2Be955YponiJJb5htQjFJ9I7hYEGQoOojsK9WzHJk0I+0FolINJ7Xo56WziANT9HKYO9PK/k+6yPcdLiNlfY7fDJdKrR6n4hkF9cSHwJ6Xc4rB7qaLTpKBK2RF5C2U1QUVRoR7vMXkJDJ9YylHL1FDHyOzPdm99nJERjuOWxx/rLgvr8Ly+z8SmvfFGx11N3iMlPboVe2jRFUVglgVGO/0vikwYScH6wC1Futyb7cqbKb41G6Jdkde0oDqrI6IH/UAwbJnz9gMH5V8zZ+boJFd3bLvNxd/D5AuvJJiGMpLXfQUDFGmCQLkgGMhuIQ9E41yz4xiOUNN7OWWS2pdQS2in6qJ+iN9qoMhLEZO2FPi2yrzGMV867/9jlpFNo1gVTCtsCQauSX9c3xmRMAuL8Z32CP3u3EY4oiUD+A8Ac1ccau5dSOX6YgL0BNgvBAuZEUx6In4k+T05EwgdlOli3ESIaGIIMn0E/Cf1N89gQYgsuxxjOwyLTP4SYKy9/mIW/i7L+4DbTjbifiU23F3AAcA6dcy6grkfFCsQW/SMVFWQQQiu9dVkQE6IqcjOClp5yyszpLIuYZAjPREODiicgRKdlqHNlhnwyxrmum4W09REqTJ0Pe54MW+LL5QEY6FWkj+Pfm0OvzxMtDyOfeGnp2zNxNi+g2HUJe8XdbdvsTDMeVZGIOBM4Z9+DgM5UHUCt87Sc6+IlJ8NAUggqOtXuv360yLMuDZnm6ykDUGCc3DuX8wznFrBa8B7lfHc37SbbOysMsiUEruj1ECWLwLlnnhIMw2B2Bn6ZbyH0h+k4Yw9LInmEKiYMoQdYbJXcU/dyL+IQnjetQXFUqM7E489+hogz/dVGJUm/Y/OmCD8uycBXz4LgC26z8Vfgf4xZvd1S+qzRawuDTH/XHaxBazm3hulouMy6H4Hag9UVmQunx
 +/SjExW9
 ZKo2F3KqhsrzFROUI7aTnR7EQIJ7uTH0cRZWl5qOxKljzrmwrOrLv4oWCbM9oGKUsoU0KE+S08E+KOISfLg43J2Qr2TrRBa1lQZRQRAtDpTWP0CGquiaiTrc4FhvKp3F74AdnEr3gCLWCRTtkrwGT0McHKIYQ7R+LZ2iNPjWbeVoKXXXyz2qjsTuTJf3V0PvToW3GgNwP0rY4zeasCBaabwlTEQOlGHw6xxO1Pcw16aPZNt1AZTELkGuCJQdRpeMHRYDzHObZYGbdDOla8EoM8DanlRbGr/qdHI7ZeOKIfgoKJwMYI10RLoTPTHfRVL2KDxt96rtQPfwmAJhhJ1216j6he51OGhD4dxHnXC3o7eWn3hxPlTUYt7Kpp5yHrFWdcDLF9oKS2/ewfNKDlddScuRqplNttRTuBfMU+vaSi0KrT1o11PyUzix9uJnEEgzuiWh7jVeNhvQVVf0B5oKrRzV3bFiaLAjgwXMAnwkN6k5qa8V/FsZU3qPcMr7WxlOjV4KY3/VeKnRFlLvjNQ/2xbuq9NDq+WVlZ4dXsVFBUimE0iT91Ry0h/BgMC2nRwtu1eHgckwBFcpA0IHXtTOPMm7wxcZG1d8EBrxLdEdxwqVZY7bRZcWkSlzmqN56pm4Y6ijw4CkBhSENOT2dsGIrcstOKaTSKsOU2PmPZ1Jqeye2zVCahWY+kl49jEYRJeW3zbEPGQYKfWAUlpyE1qjVnHiVkh84OcR86pYUsVGQt5lprg2ieD+zCOw4HO5kaGmALakUZ+xIrpUj5YSRyUOmLpgVgLXKgCGPlnuxtVW0B8FuDybBbKOCCh+wbJDxL2zJnuc+eMMrzwqt/sbp+D+5XrsYIVCBWYJnGQEJz9y/opTot0HBYj9BATFGWPbw5x7IRp7eISEgocbM9pXqPT3ktdCK80boKg7v1Uq5OX0UxzslwfeCkeAMWjywyROluExGydN7K1xUM05a3Xld6nHm+s/VoPbB
 fWgj8W1B
 hHEJdpZhJ8iKPWxZJ1vn9W+7MbfbDmBZkwCOHlF8b4KE9Prdnfwcpq4R9bDDtek/AJho0rLZQjGckXKPWF4WFmZZZqACHd3ZpPCazm3GZzPHmQYYtzYtctjfP5668kX1CqhiV6kkol0y6FNR5CUM97OoE+i7DY4eojVt1/WzdopeyGdhHvj6RNb674qt1i/nHmP3lyLtTmT80t51SCq6sXPQBdjYNx3I5VUIpF+UUm7UBqc4auNL6kGbkXJCU8h1CgJqbicKHkVmu4eXzTgDlmZdptxAPGvGAMY9nrUEUWoGw+9HgwsPeDzkm+5m9bnIJwdyTQTsNPdH+eNEY7CeBjrzlurav4fEw21ciMf+xMNbwVmfYwvO4ZclO81sMfnwVxjzC30mEPbzl2grROTM88CJMv/t1zi22VbCGP4qqiVZXn01nas7bvPd/+N3+VsJd75k7gzQ2aHcbGebqxTec1tjgWyvQekXfBXvervmo3NdEr+eYegr0n4RhGe6KB1hPC0MRCAGnipwXkW/cC6ZO2p7sj1Ddy74eB07UimBrlOaJYlq0vG8xf/lYBqJa+NlAo0vI76Sx22BJ0WKyAJ7MA/8Dmy8DfTGMgsMzRa+g4Ks4DJNAEMOLwXvlQXdBsRbhe24p7itw6u6Zb7rrSm5T44HVro/Zn3KuzF7nkKhurnLoN39F4oLy6b97Fb6KEHiXtjAcoqI74eQwFq+NykbO9YLVaoa5K37/CO1iIFe2khgScO+H9/9uGN8bIRXH6kYHJaouJyNguGUQqypIQvzrV2efTnHxJpQw0SzC7vf/yuSENvrM5iPm2f4sZzkQ251iKqIoWZm0PLNADEiz7yNHLAuIjXP7Z+GhuP9L0Z4+jUIhHK1tb9feMEGN/RIcYSwWRUiP0K6GFljJf1n9qnRnKFHnF5ydpy2hK8/ag5iKOAcCGmNBAbpihxiqxPbJGSlL4L9BLxE2Wi1Gaf8p07IME79n1hS3
 ThNGY2cG
 Te4FdHGqJllodmxODDC75KVKH0MmnYxAmHgJa4PAapQlXW+AIk/QGdPUtelvYSOKtVArCL61gTFy1WK4eeXpmFw8+HwMvZgrujVgqx5wpNIqiWtf2tKSKroAB0733kAy6Sw/Fzpg7X28bUebBCoIyQnFebKgNuilnu2kGN3gj9ipDdMlze/jI9/lwuP+joMRoueJtyaTnnRk9nD9QS6ZYnyH+4/+Njnx5+0IuqkMHmXZ37hNiYREzpwVoBpfVoJG24IvZjfSi/z2rP3sLOQkGVd8EW77M2ZuQuf9jcOpA++eOfbJHgw9woc2KhbbbkFVJPMEsKjgvm801FlQHvULV7BgH9UoOY0ibo+rHITR3FLkHSMTOAq+TunmwRRYwckT8chx/cBsOClULvGUoy5WhX+T/fz2nnd7oYLq/IJqwze4VPkXFz2EhXPxhroy3+Tm0LryTKoA28VU52mNgIDWr8v5I5x8TZgwB9kMmOV3X1hoc0L4uLdTjVMDxoEuCn4/SvdN5YR1ojWJErO2Ebhrl4th6XST8jq9Wv4sLJmfoCL7UojpSL5HS0SHMbBEsHWkFxqBYZbS1PMaams5D90OuEHGg3qMmZkzc32Ye1trCRhfL9VlVSuvba43lDhxCPVrpxtxvBc1eVBm9TLmfYm0LJCxxIYoaT+D4/AiiZ3IpNwUEF8gDs2CrdJfNz3KC3bTp6ycuCoC/UMcCd8bzBvrrid+EqkbOjmDaDd6fnqCUckfamNguYGJm81wkVmiXGrPeJrYnOkGCz8+EvN5ZUfhmiyzOPljVWKGKOs3OAHb2ZOzh22ymMqhEGeI9vi+oX29ta+4f//NUnMWWS2WHnBIljxYGpVWBtDhylZ8i7RfJmFgpkmN1rQuMuIF/sX8e3pEyHJIhenNw/if34Wfl9Y5lQEGbZZUTlyKHZoXRg1HzZrWc4SOhQsE87yh45jmI5dzkKU6XquB8ZaqGEPegx9GfTmZPBnJE
 dJzAJ8ZV
 GE944MUevOtx5N6lV2DXOtMm8uI5N6gXmODlRRUJPnO0NNrZ3Ya/y5XU1/XsVJfN0zt5BXHivU8u+H0NiWo8GgUd1LCcjyErBIIpsmW3yRqN1wp0GmT/Yuu8CM88I0wReicr25ZvmSTF0qUxlBW4KKJXHG6DNoF2tMH47KEIMaRWFbMba85kDTZ8X4CcQcUx/MsAWWEAaE+c+Xihar4Le7DUb3mJ+xnkXAFIu0VxZxuxNFKw6fmR43gGv0tQFnkmaoNFJDP+WTiVXHskF1KwasckOcecBwM7ZZ+O5idvXp6QCp4ay3Z7YE1BFln/SQIEcGUyyTQbMi3plqa1hhLf1VG3/eCB5ivz/WX6PM6rBdQkhOa9Bdt9yDqrIJnC35x19g0UTihjKX5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert efs i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/efs/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/efs/inode.c b/fs/efs/inode.c
index 28407578f83ad5db1b8a7b082fa3e990b6b442ec..a21a03f7e5790aed95738b1a0c0f1edcc84848e8 100644
--- a/fs/efs/inode.c
+++ b/fs/efs/inode.c
@@ -132,7 +132,7 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
 	for(i = 0; i < EFS_DIRECTEXTENTS; i++) {
 		extent_copy(&(efs_inode->di_u.di_extents[i]), &(in->extents[i]));
 		if (i < in->numextents && in->extents[i].cooked.ex_magic != 0) {
-			pr_warn("extent %d has bad magic number in inode %lu\n",
+			pr_warn("extent %d has bad magic number in inode %" PRIino "u\n",
 				i, inode->i_ino);
 			brelse(bh);
 			goto read_inode_error;
@@ -140,7 +140,7 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
 	}
 
 	brelse(bh);
-	pr_debug("efs_iget(): inode %lu, extents %d, mode %o\n",
+	pr_debug("efs_iget(): inode %" PRIino "u, extents %d, mode %o\n",
 		 inode->i_ino, in->numextents, inode->i_mode);
 	switch (inode->i_mode & S_IFMT) {
 		case S_IFDIR: 
@@ -171,7 +171,7 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
 	return inode;
         
 read_inode_error:
-	pr_warn("failed to read inode %lu\n", inode->i_ino);
+	pr_warn("failed to read inode %" PRIino "u\n", inode->i_ino);
 	iget_failed(inode);
 	return ERR_PTR(-EIO);
 }

-- 
2.53.0


