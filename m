Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FCC3EB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:29:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6A266B00B5; Mon,  2 Mar 2026 15:29:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D09FD6B00B6; Mon,  2 Mar 2026 15:29:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEC686B00B7; Mon,  2 Mar 2026 15:29:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ADE136B00B5
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:29:36 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6FE401C14E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:29:36 +0000 (UTC)
X-FDA: 84502263552.02.5C53E61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id A10691C0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:29:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=APIWiey4;
	spf=pass (imf21.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vvq9DofwNGS37Ccn2Gk/7RrJF1Z3iyhp4tZgsXGNqHE=;
	b=CwK3+SLOQ54JFLMnVjOQcwlCK5XRCAIJZBpXLf53JEoAQk23xe0jaxNflvnFlL1bfc+GJP
	zPondAdrU3AIKjVUNwNCMVP+MT0AubP4FVy84VLouJtlWEO5rb3mCJUx0CeZahRBG2Wxq3
	izbk93ydGBtAnTFemBdeyWikSLo9zR8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=APIWiey4;
	spf=pass (imf21.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483374; a=rsa-sha256;
	cv=none;
	b=oSr8Rq7j6k3RYw7OagBYuJG8euRQ7UAe7si85Y1Y5EWMP8xR5erw+ZhuZ0XZTvRquT8XMq
	z2T5cA9PvnxrhJHH/Hj5ly7YilIrJwIKL8XwhV5J7OL//V8KZmegyUbGYT4H8B9pZ2DRB1
	ABltkVdP9mCXJvK2X+37WPhCzejoeLk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 067906014B;
	Mon,  2 Mar 2026 20:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96829C2BCAF;
	Mon,  2 Mar 2026 20:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483373;
	bh=2RJcyjz9ZeepO9vr+z/SvIbxdF+oLrZ3JyX/sNvQFOI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=APIWiey4U3dasR0GqDP5lzqiatNJ/0sd/9IPXYTGa0AnIUb8in7RwdYg1yIwqrCgS
	 NJHoiVaZ2uxVHpOgfc3xAPCiTirraHQ3NBF+Akq+CRSUOPxxeoKo5SVV9V5Qbl29kz
	 /LlOzqmjkRJ+JvjOVpfruNcuGD0FqGDrfn8XNzgWcU+MXhbs53ffYLQOcm8TEnvUgq
	 sRITLz9UEm/xqmGgU4l9z4ugevXhqrsZ9q9P94UpvlH9NWtv4MGDCTa65OzNlOGCVK
	 /MqAoToFOmYHHjPwpuQ02igo30+X2doISjUzfLNJVgd0QpQZ4MMG8RzW9qWlDY8TN4
	 ajUXKzdEw4vQA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:03 -0500
Subject: [PATCH v2 019/110] autofs: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-19-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=928; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=2RJcyjz9ZeepO9vr+z/SvIbxdF+oLrZ3JyX/sNvQFOI=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH0lfPeH+lXXMPPhgtyZwPlwVBd02yrBNJF1
 cfR3ubKSfOJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx9AAKCRAADmhBGVaC
 Fd52D/9S3JOF2DmRqLy2J/Rw1CSYpFxiI0GSgzdt4oasCoIaNzZcFYo6MA7ZjyhM3CbBv30Ppcv
 H3I8pTide5u371BYpAw3g313farXvCypcfrGQUxkOrKbCgrWUMPf1KXzvC6vnCs8uyagsVRaStl
 zLiKg5VXiWj2JvGBYQEAUjFLo4G7ihjSTjiW4yeFr/kdTd1seolERoXYneFY2hgFdA4iwpZoLPp
 fGuc/QRrMc7R3VD9jLgORDGR1KIHUd5gDkKhkOlw0cnKEC+SSD1e6XH8l/oAwhszaxL7W5pT8+C
 eI0A3imTsJRmCaVypsIF7cSR/vKcMbZ3xU1ZllXMRHWdeY5kie7Q3NrE0SA2vauj/gXcZ/iMBXK
 nQKGjEzRnhOH31rcaDiCpcKhSMZJwNqukRxD1wDm094BEgLg2NUC6cWh2BQgovQGu9RzCt0C9ra
 R++dBBKpb361aYp+N6ye4/P4iqz2oQhI2QgN8TkkwUXkPGMrkLxCRSpzXgCzZrbLY2uZDu3kNz7
 vRQZrpvv8ILesrYhEFDbyODHPv3ZKZlSrfC0eGPdN3Do1q1ZYtBlQeoyYexj2BkVRaopCfLwVU3
 9uCmXoYZIN4T+60axuvwlKrOpNjzaO1pHROb3wTknmqqrLWdW82bVM/wBKoqWubTnT+F1QfbNsy
 eEHguUfBX8+zoeQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: A10691C0005
X-Stat-Signature: nai1hq85ramxjz5jdb3ipfb75d6bd9c7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772483374-491033
X-HE-Meta: U2FsdGVkX1+iMG9bJsIsKmrTIXDNTymQJTnWluiS7UeXGXnsKhShCNx4vtwqFuCAkUUC7QPGSgNyeHI/AjUVuoy3KJ4QCfqKIDqDcu5FXx8+VL8cS4NX8Z+RmT63uV7SH2Ccl5JO8QzNgZ7ZVhZnHuwmm7hw8bk3hQO5YEIBVS/oLGAhxx5jtIL/v9TpaO+sSFMpeBi2lxwyUREg/Ju9sPIMO/LDel1d6G8gTIsq+i/lmsbSI/C1MQXJJ+JViVj5QuyjZpgu6k9KynhmCjRIuUgM03MmaUTSVdPPbrhDzpGciZ+OXPbhR/Fv+hKuPI8NUZYTSadfV0nat/FUBxYYDiDQm7W//rKjkFF0ZaopFfh2fshi8yHaNPvhrgBA5cPsXcmDypxtgm89hAucW68RRK+moR+tlewLUQXFS/zUlfqIunf7znxe3Nf9Jo33LVw/cj//J0dMjKz8SR+e/WTBoRpqLw4ZwJPPwH04eGheZ//4jhDl1V8e8cARc62z6ZbPNHiHG+EJJXU2efxVHnGz8EP/FniA7A32pMqWSek1kgKBOzNaJ518MDDSA3fq04/h01qjjJ9MSo/wxNpe9Ue5FiuITdCw5P/zptEh6rvybK4ZJK2J4HH4yQQ3yVxXZPkivbz72ELd4fKhO7SR+VNMi+HnaC4cmCOD1SWRWmX5X8wqPxjFTGzshXzT8+i4YbVs/J/Jar68aOqbjVwmjjD0qZroMUbT24/rc4e9oVaMv8rutRPb7O6g7GJV28k3N7U/UedAqicfA4kOtREmWgoGeq4mlNTfYv1YmCVPvC85ehIqUKhcQDe1r8/fLEU1tbpxPlB78rGNW99BouvAuKcwkpvRKci3/1JeC271fojGf+UyIBPsnSztE5P6wsOeIUxx/NmtALgYMT6jQr11nx0DNaOSBKNCH+GhaSspyT7AV2qkLlMHOWlFwCregwi8D2emaeoOpjisVJHyTglYyhB
 Zj2+8yRn
 4SB6BZvh3yW5pNUoaZI5cAzZs88WA77k6JJE7BvYFTBY/+DQ7vkOlGzom8cX8xzZAmyz78rg+ClnEcOP3tBaZkR/X9wXq8WYgR20rxvTOSnSPZziOyQW7GfdajYXk1DvhG+RwL8pTAwq8RRjvDWgLjm6ckpRccUU6rkctLuW8CoxKymYrj7baNegk+odh+uqD+lYwQhtQNDNI4VJdqshmWj4HzfrZ+p3XgkY6O4Qcpx1Gk6N36y/lvqzOiqJ/RQrnUdtxy5enHwT8WTI2Fov4JP34hngsvdLN5c3QvpvYsqzOEodVnvO3ZQWens4+wxQtPa6nCXPfWZzE9sTSdHUTxPbqbZrCwuw6ihq5g/lz39KISKWetCogF1j0oU4SSep9EU4oih2IszeO+05fRYjDkEddeL0agUuHnUa8Cd1BqTlqPoATpdX02+TO3SnsC9cQwHjxVoPI7acjDZ/GrrCQmjuWk/QpYrGFTdH5CngYN2tOSJtxAZW8WD2canMHJxLAa9xXsocVUTeLQHZykMLGtna3yhPlR86L0Dq9JTUZGTblOBdNSnlBb1YtgRQb9yhfemy4r5MRRP8gc+wN5NEMZs730BpbAFvmOgEOw1Uor9zaLUrYG2UOMaTsdrxkIPvS4VwRcbnoPwPvy5spI2LIW5MrCmoiDbt36GM0G3riEo7k/R0FD197xAYcCzDvhvs6DhhrUYSPxQmjXK3bBXfGxu1CB+LPWpwc4lOdGI3CMnlRefxMNeNuoXMO0pQwAAJLjV4lANmUt6UX750FmX+Tz5VRhv14jEiGn4EmHSurjnFd62oVi5sH8QRyWwT20274RTMojGdkpgaPAjJ3S8wBUZr4bH1hMmmWO6ylup9sQn988LrQnzSJVW/WymS4YOz+LI4Ce0Mu/FcOO2zo3o44wKq0aI88jQy8r3iQoY+NiEAnJNY0YjTrBF8JiBiiVwH1k15vDuqmgBDdT1uh/XXg5wsBDIbg
 WSTaOJG1
 Yd9zwJtFxXntlczUfB1t6BGTswZVHAPcL1VkOoCryWBD2sjcoRgeqTNXRKMW3igLGpyKx2v7XcZFlEFT0XrFMS5DJFe6dBLqHT0Bak9uMzRx8l7HijOTLHzxS4YFHBqVlswwezMJugUAh3wZTF3FJbDdFysWctPmnsjUf/B3Z+aX1hM3GFVHmx4VzXo4cl4v4+9bqglKXyTKkJwwjj5trUPkHrCiUv7syKhT5AeaEfcFRIRHksRXayTPw+xsbk11sfZtsq0WmRzwwW9LzheinpvftKbAdlDqoP6cLO/EkAO6wI77o8wu32UhhGC9oa2UThaYLcPOGUMYRcAQ0IjMfRyKmjS5ozBS7NcfUMxzoNyIjiVjLfpv3D/Taw93wtik4o0XcX8TGyzes1eowgSBFxR9o+Zu64eZvg/VkT6Bs/xLmBhYhbVmwxvg8IAkk7KkayijJLuv0biYRiOTf0R+VAT9tlgmKToZlqed7GgCmaM80FpvOpY2KZBXB6lSCtLftrsOiOOAY8JO/+WEvF/AyfHQD4ALQ8y2yYCYcW7fl6ZRIc2WnkzoTkFa6SzO3BC1mxZyir3+/7FleimS3+oOOi5DdPrqcsFMMlSuMgukHIS+WL5WEBJrb3aV4+kIu3eVET6KQlAsiAAnarLM7lhLr5AgsrveXOwSzvbB4pdyJ7YaPnngHj60k5/8ztEI6mH0UIqMwNaWSRmwIr/X89VqUW0kqr7B+ApwK+ahHxB3FXm93EbKbudu990RPyrFHhluNAM/6T2bn9eleD8vmsO94z5AtAP5b1np08/sUvDYIYF5VKXBXvy4mWCwAEwNwi9amZO3bhqQotkwh0VPYDOSY/BBU/2e2EzzE4B2ce4J8GMldKd9ZhzBB+7Mv07NbuHyNSq444oXzJQuXQpyqct1IlkosnMNmaf+1yYfMvV8PUExB6PPl7pTa20wBGx0yPXtffpWzjoeu1xldQA4FNNwotu8jI7Rs
 AV9DmyVV
 1lMEUctQ7ZMvVFaaPG45/xu5S+wHtylvs64Jl1cXu04uM8wEZ1lJQseXnzwSuRN7h9zq8/06VbNCvcCw0lm2ZKufnArTSpStwTdnc7qiBQ2aGDP7OmJZ3AEpc8SdsYLLYojbQoEJbkOJTJ6h1RY1nSQ7Ab+Q8EQBZzPmdyFnXMdkO04OrVPJ9buJC2ijO2eMzmD2Lo5/wGl5uNNO/aVMSTIo30wVyGCS+YQ+QpC0teWDrw55QeTH4ZzoeAR9HTm6P9pgt2eGn9aoh3daO8oJ+KzzlHEScMRnpjDv08jPMP+I7DUxekkAPKP3PyI4LgCGNS7k2mo3nRr9cY0HwwKefPXGd66FZyTlnNAgXldhWtIjeosn+IANqA0iitkDDiPwbHSWo6/XDYGbk07sDwj1ThW58p+er9FlF/5u5RjHFFrsMnT6lFYAYJLgtd/7gIzOaa5jdu+6ToW5EZnVerHA5UOvteWNm1dOjP/Ajj7VJ6bOLpKP3eZYY5dz0/qWWzgnTzFDSCCtIpkg7IaHW9G3XpcfuTfyjyoGF24yhBhWaXKquw9aWhNyfcjNUcvZKAMkSAl5etT+tDJ17cxZWElqgpRJdW/GcZ8zX0KDmicN7oH+lvqYn5KcX0DxA4tMQYu9rX+0Z8G6l5Z+ORcRQThVUanfBjl06kCpQMaq7StosVJgUwjlF2dDDEXGRcmzvANTDRqhxnxVYss21MY0CSEwwm/1XDenaCk59vtG7yHqWU1O1oOLGRQTeQ3jSgzV2UFOdJcARq16I6rwdrf1B21y/9yEvvmEigPMQF8SGXNOVau4pohPkQz1wvlTx2CQXybr9wZba64UvHuj7KxJyx0fi5/EOMtCkPxBaFsgHIaAO5FkdjczRMpfoj6SmYUES5vur6Uk5b21GlSOQZypF7yyTW7LiOlXFYr82mlchtJAw5vRqJFWRRr0LoeEAygNCbXA7t2faeVDpeeqK5bt28Fh6Khh4LlBY
 /zDvMZSl
 rd/BFoTD9ZQJ4ZT50DDeQgBrj1heNW2v5rGaPCmZj+3BTsuc87F0T9Xto2PN9WLmYXqtQgrzYhUNZOFK95WzAyRHpcKsPZ3C5uN2h6AybOzInJimZS4JjOMkwIdVqJ3XGJPvHViLRBLpLRIn2jJnAr2RGHV9O+0GikHZRLBtmP1fruQYsL0XuWRcv26Wpmwfaj2OmF5csgmdaoYLEKOa9PBQ1ZVTDsGDSgQQ+t5h4lxqepZMxBJn/xhu2/VXcysNauJnNN+duCBc25DiZmXI/qBYiqM28gzIYmEda9wUoqCtiLQ9wVvp05q4IXgXXMp9cKtatVwi//66VaMSwapipMoOlvTrlpyWbz0t4Aq2d2rA3BLmon4wy6yT/AqvCu/aCCDL1m6EWvRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert autofs i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Also correct signed format specifiers to unsigned, since inode
numbers are unsigned values.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/autofs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/autofs/inode.c b/fs/autofs/inode.c
index c53dc551053ba53fa7c85ca57eb877fff74a4ed1..ef3444d57f6ee15767f744a5ecda020c247095d7 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -92,7 +92,7 @@ static int autofs_show_options(struct seq_file *m, struct dentry *root)
 		seq_puts(m, ",ignore");
 #ifdef CONFIG_CHECKPOINT_RESTORE
 	if (sbi->pipe)
-		seq_printf(m, ",pipe_ino=%ld", file_inode(sbi->pipe)->i_ino);
+		seq_printf(m, ",pipe_ino=%" PRIino "u", file_inode(sbi->pipe)->i_ino);
 	else
 		seq_puts(m, ",pipe_ino=-1");
 #endif

-- 
2.53.0


