Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 571F4EB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:43:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B80576B0121; Mon,  2 Mar 2026 15:43:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53F46B0123; Mon,  2 Mar 2026 15:43:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0BE36B0124; Mon,  2 Mar 2026 15:43:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 900D66B0121
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:43:15 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 69CB01C316
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:43:15 +0000 (UTC)
X-FDA: 84502297950.13.3FF85E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 88AD9A000D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:43:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a8erYOQo;
	spf=pass (imf25.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3CZJN/juuSpRXxjgwZVStDU5PIpM4J/lcUsjN8h26s=;
	b=7CCapdDaZd7q5a1XLp4+b3GG3mk2OBXr23LqO7qRnYT5hq5ky+hdnk98BMQEM3DRwE50Gu
	q/PCWXK2li9g2qQoE4MVBx4yHmYRVXvQc+xfGFzwqyJzD8EDffS4XGoX14l39jRkfTe6gb
	HuPfNchReReIGl0sKqcFBcIx6uCsSZ8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a8erYOQo;
	spf=pass (imf25.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484193; a=rsa-sha256;
	cv=none;
	b=mTZITaWSS2QNW8srl8y6gtEsrnBGAZz+bb7M3IbOR/sxP0ude/PndaFR4B0yQMwZaims6p
	1CKej/bog+/4ullgHo9jb1NAXydB0qW8ZUXKphNXgALgdIZQOlIl43Gkss3FA55EoAFdI9
	IyiegY1Mfw0q/3MWeudHdZbA2FRo8WA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A1D22441D1;
	Mon,  2 Mar 2026 20:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E43EC19425;
	Mon,  2 Mar 2026 20:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484192;
	bh=FCaNd3pHlGf86M70GmPN/2h+0/BSndhawfzqYvem1rw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=a8erYOQoCeZ4W4SsKPy6/MjVlXR7g69i4wbgWBsm4HI5CR/90JTSi3KGCpH64F2cq
	 5KYYQ8lChrVsy4lZ1JRloEwtGxpF43U70cVxjwumOtq+7DXaDBRvr4C1CxSbn4AX26
	 +gVeG0c3n3ZLtNb9i3VJiV8bBy1zKas6/u57Kcj+BjqfRnLLuxm/w0Ilats1EctoS5
	 mO5yXafS6AX2PWuTvlJBBQ9vVkekTrE6uxK5cqmpcEnqCkiuink+of/l0tqRdUZ75u
	 sne00ytw34bZb06iCSujnQvm2M6EHmxg3n+razSMYdNY5R3AMIN+RA3Teg2DEZPfE/
	 Ki0AiqBAN+RDQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:00 -0500
Subject: [PATCH v2 076/110] ceph: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-76-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1325; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=FCaNd3pHlGf86M70GmPN/2h+0/BSndhawfzqYvem1rw=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfID+1/UHZA4NPHPLnw/+H+1taDd3t+Ga5qZd
 qZRYbF9vRuJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyAwAKCRAADmhBGVaC
 FWh4D/wJ+yIb2cpCiPiJ8w1tdyHCbSXHupm6zq31jic18FwvKTcyujLdAcMJbbJiY3gw6BuOzw2
 Cg8L9GAH2nYnXa2JqZ4OztG6Od2Udffiv0UHbZyU+xx6VyV1Upr0hQWKwCMchPy3vjczDBqaIII
 C5vQc6cueJrt59r6TLCm2ehoYphk+juAj0U93SMafU4M4v08zpTagoXR5ybYfdGTV7c33q4U8GI
 bMcSmZ7R13/DzvXCxjDko049T8rsEzgVNhwB0n9Ox73Ng+/rcHGMLRWiUR1nWhmIrlyBnxcdyhY
 XKW8z6gW8zCLrKTSNrL+yRmVeCdpLjzZ/RMfTvmBJle5co30tXFChyLfNRBe7/Zw9S6sk4MIDe1
 5ISjP94k54Zh3/pC5eYsLzkivQb4t/ho3QTTP5L1lEsOXc4gDvAiHnF8S561Xz26NIRUoTUw56T
 Rwnxti+HromqTX968WDtdOxhp/oqUL2zfij0+p04SwmQF85SHwrOTGAkZwqmtJ2eDYwqB+nvcJ/
 ssLak2UCmta+IiPJr8fq8hAvaa7TtWXxQ4StKOBxj5wwQY9QVqvC3ldqD/zNHKC/bq4Q0zBB63G
 AkkloOzcAGI1uwVBcnfQYsLv+yhDtfrnEV610eBHY8K0AQM4pP+3IX7g7piHYEb2VarMVnS16R8
 jYHNDYgzKNO0NbQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 88AD9A000D
X-Stat-Signature: d1utkha1esjuqusaw8xkw8zj8jsqmwkg
X-Rspam-User: 
X-HE-Tag: 1772484193-576981
X-HE-Meta: U2FsdGVkX192pk1lsuaxON3aYFIanHTnaurCHLXongaRh/Uu3DUlQkhziRkYGrQY1YjWPtWhJm8R9YCmDElCFgTaakOgS88wxzN5edgVQI0mbM2mJv4nA+ttqMyvfYuOmqqElnUW4LJ1xRYeFNOZOQ/IWMTczmi0TPQdoNbOlaJJT37gqqo52/hsUen5EDVbv+vUJN5Y8ab4WtXBMZkwnuSpm8zs4FWguC+GZup5CzENZU8pMKP4lPbtosF7nAjJ1gRO+cenPDAZV5e/V2X8XIclbtbnmTqohLnDFo7zsFkbs6g8VB4FtZvTzoZDXnq2dI414py6F2XatrXe5tZuQ1cXntantN2tcbG9f/SkwbkMXFhiJYUX5eLZB1xiq9eT9VRJCDZbOrH0PsUPCOkulkbiJ0x9OS0STsrXgPZWII46N2a6/KvZoIvDz7Yibtw1+WX2/tVJFpNp8fFxRc5hz7O4dWYQ1z9t/EJjjO9hs9NSM7iKMkEKxAGnGyVWsIWf1dbFg8GOnMdE1TKuu8Vtiq30WrpIt7zBKB2vcpztOo3EsPkXYszEMAazyAeBTwQAqHNoynmheJyZCQkQw+RhSVjznQD3r4nnn+cJUMCMM4yz3uDYXe9WlA8WB52Ab4eaIT0BEqRyNmmtph+PRj8KU8CKnglXyuEm+GZs0SqY89fmo+kD1QifQw9Lkp14XCgsJMqF0Ab+L3D32pNqKMV2Lfgb9zq7/JnBIZZ40La3p3Mn+RoHurilmQIL5z9YoarAeHawaIX9Yx2qvBIF/4aMx/OcA9NJ3Iuuh1OejlrDqKMgVIuGPmqkU2HJOBtElE89cslA83yAVtYj1f3dWQAhxIEnoc2ZagKnUpXuf1ciodrOtgGHXMMbOyBP0JT7hjWKO2j3vNu7SGL+rxUE8JJqLp3hXH0ghO6c47mlyGIso+2FL2UZsKKEBgqcm1OQfJsmpWFFtESdw9clitlN4gB
 4o2tD18N
 18DVnbBF2luEBZnSSQKCBI69gwzPR+w+h7gtcB2Fqv/YrkHYwr9oa3T9gfeCjy03iDiHSFrD0QYtqvvSbVF61lYCgJSBszwEdQIouSi/qIAOObjpnAHzxvezsWhhKJHArWE/GQdjIRMET2WoEWatzWQzp6fPetaPL1EHILP7fv0IjNW7TogHKjvzf/CtzDtJ8pIm4tcOJYy91IDw+7JF9TOSYh7JvPyH44R2pSrndrhuG8mwtBOK/IASs+IdSg4k/LxidwXc7I//pVRtAW21KFx4bPvmxndKtTJoOFO19gcAm2qCcprlYXWNbveuTatQaKTZ8cwmUl5NjmUA7TSxwHaFpekvSlS1KhJ/edpY9WlhRAqDBD5c2Y7JDEwUTKKm5fOVIfXQpRjbshkum+MJK2vD9PxwSR0CeLzdBjaQIcfRFftZbiG+Kp1jabAZ2jlDSujVKKubeOoDvlVeR9C1bO9NQ86NdBLEomBYY5SY4Tu3eqkMMfRvNCs75JcruqZ7tENw++x7PshoM7KTcQIKW+A1EAwgBywNBCEe6RAgcJ7PKZ4uMEd0WG2LIF+qhZgB4+94ZU7M5TdvCxb55EL5b+sSK7VY7GJe14ROWGMcxvW6pOfvCRqILPNtg0z2ryXA/vZn1zB1CUeRInV5NlLZ2WS2/kLrbqFP2JORQ1dqi+XncQU7Q8wGaL8Xso1PYSsaS7nHlevwmgVXx2rS971cpOUcOlFyOZTi1TSw3Y3qQGuCuPxJYSSsaRyLgEKM8UwVbycxpV2LUfg+2WK2zURsFbf9zBmzlcWSbXgJfqhIb5uVIIJjXTw71y08dZQJhbTWqDt9/nW7VrqbUIMSr8L9noOlPp9+jx8SElAxuziNUOjVNMk8+PgjwSlJ9CAhektdMe4+KXkfmdNzJtMzON/VLYX1tHzeDpIpMn5Q5uf9kUtlHpkAzYO6a78IuXJdzU0kd9iD3G5gbUPUA7o5jzVfXNOrEV1Lv
 VCo+O/eI
 S/cwsm7P/t4DndLEzmMMrvPXskXHPpXPnPrFQD7/d5Z3LS0/1BjbWtVP6VSdLkN32IfgqVH4sX9dBVa2xuh5PYfrZ+qyXaO8JtKnfM1a7KhFc+dlvRrc55p9iGkpxHESZ6kBfewKpQkumeBG4yYrTyevOASKmwvkhMyzbEgawVjkOhgckSJcuF8RTWO37KVTWWdy3ZMm+21o5eQMdzGwVX03Iay4z7gd6FACDA6FZMQXqvHjYfsXMBvD6smzqopm/xI1MFxIDCnG8iT9fHTr7UfzgGfwMgkCKGwWsdD3SJNrNbcnXZ6LyFEnWHOGRjHCW/2ZGS0Tey/325TRlpNx6fO3j/xvwuOYaqyhCVOkPsVWY7QPFfCliZTpZlf5rc86ZzgbT0sPsOIXN7skJL17Y+Q0zU0yS76F1lEWzbyv4GmS19ELTds3LNaqvKeq9jktLZpJhPER77saXug0ztgqAnYWoB9eR8ZuWQgKW815aSLSem496P46A89Um5dwfod06rGrC3JFG0TfXkYPCq9N+WGMbaHIv9r/AnDe3Tpfq7aSfR9TJmmLmeE29+2G6ACYjoSO04VOk4O5S2vYUYwloXms6Ok+BueZcyG/5BVwjSaB2IouxeSoCN62rcdS018PEIpTalNVndS0KzeGL0ceMgQeik2zXU7U1gK81iOmWxGqjky71yIPoL84E8MsCXwsV9JoC1ImA7P7KBTnC6JfWsrW+t4Xz3eT3hoie32P3hxMT3VsYXiH6qkln+nm/ui+G4EgpubrNKycDN8O3Hk01uZNqLyhIKTzEY+Nh1FxVd6HvaYI1MzHmil+gMHQvFd+XLm5N7xFtdcETzZnkNcFhtvISGigJb1BuFVYR9hMQLT8YdprQYENS9i1JzaKNtBjUGLBhzrQTzrSV5DhYIv/YrMThRiiLI4IdBQncwOMWrN6n9ssFo4AhhU6snjnpSxguC7MnLrRSlk5heeh4bUOWmuiTzPS2
 IyEYLHVW
 MvAp9DMuYIkHVhBQLdbz0PuubTMhLRKFr4whcZ4vbK02FSN8Zn28sVDhSXq+lIzunoCqGwIC2DAJ7ZsC9H3ASzNNsu5o8NbQs5oR8zij0dc+/IxM1a13TPUgXZSeNM8ApzZz1fT9GukVepbOG8nVOt28skJfwCnUa1InlN8yiG2CsaUGCQwUPnUWkcXAUeC75HJ0arJNasbCumsiWwB2cVFTJYNn/s48ypDp2Fo9zy3rLxAa4znHEe0W/ItqMsfAOmVmIni7qEkd3tRajYh2My/CO4WFSOP84Zwe/xrMYtEs+mXIW2p45i9DFPUqeRkOrl8lISTkMF2oo5B0E3TqH8DPJtHYVaD5Hg1cw5eYARdAScaFCNYAE77bEtKAHkEVkdAFBCXr/+AIXbHFRba2JsIWxoCL9AkCRV6Rzq34oYt3T7bjGhSeXwNjXDWvtxbbBOiEKNsGOU6LLvQfC7MnedKb/vLi6DCAfQYeKkbn1QC0seNFEsNJoOKe+YDAzuRXkPzO7ZZ+fv2bOOHVzCijouzHCmZBMMVDFpdG2hVrWAwyVPQFK/iO+660uvQYBUBOwrpvknZDkTzfPSen1yqse++K6mUBy+fMvEI1X7Z3VRFuC9qa6+IKq6tf5o79oOtLOqimIE1Qwl4INw1XCfB055JDTwbeIbBjHvVeb7EybIgzeWmEJTTsTvlILkI+DMqHqxmWpM+mj43ABwQ6btKebhjy1hcwfhVLJhHnSofmWpbrqYdSz4X+ii/BTO0eVgfGQJMETuarn7h775yoalBHRYWxqsuGpfxG1oPHHwVZ3sTeOSkMPZTOFaDBbzlpZw7WzBU/GlHyzbnGSaks50c2eDwJbpl1qbCWq8s6KT2SGgYEyiDNfwjDMGkNAYFKxhk33CNaaLFa64xfLSKfkYtG54UlQW6f5GW0XtTLYUBldnMt7PqjkVlEP+OFMtFoegKeX3D7PTSF70jyMulwFjMIVX/RNVUpA
 JDnXRSG1
 jkW1U2nkTrMc+hl7xXMGUIQnebgDsdUYq7GhhImITKu27bL6f7rRk6aISagfXa0+pmIuoc86VFDfI2rQI4TbbTypfZaWYX+GsZcpYFpKmIXot/fxEPoSX0vzndlcDzO8TGVrVMcLOFRMs9jOyjxZmeJVc+M5Kpru+UaijAa9ZKsYPS2lcFP9XcYK2WmDRiRUn9+ca23rLl6Jb4cYN1TtQ1oSP6mQPOpRDuVTOqPiDQNfOtrX4S8XjyqEFy/h8/mOqAF++TecDJJOAKE0naF9KVYAJhNRcleut6LGuMXfTC+2LSx+1nGDc5CucnUPBH5pbGOZ0o6/Zi7k7Ygz35RjrRLstpw1NiBu4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in ceph with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 718c194ba5d8ce22c6a5d1dd687ec3761263e7e1..64d2407592772ed61fb95b62401db194112f48a8 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -272,7 +272,7 @@ int ceph_encode_encrypted_dname(struct inode *parent, char *buf, int elen)
 	/* To understand the 240 limit, see CEPH_NOHASH_NAME_MAX comments */
 	WARN_ON(elen > 240);
 	if (dir != parent) // leading _ is already there; append _<inum>
-		elen += 1 + sprintf(p + elen, "_%" PRIino "u", dir->i_ino);
+		elen += 1 + sprintf(p + elen, "_%llu", dir->i_ino);
 
 out:
 	kfree(cryptbuf);
@@ -377,7 +377,7 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 	if (!ret && (dir != fname->dir)) {
 		char tmp_buf[BASE64_CHARS(NAME_MAX)];
 
-		name_len = snprintf(tmp_buf, sizeof(tmp_buf), "_%.*s_%" PRIino "u",
+		name_len = snprintf(tmp_buf, sizeof(tmp_buf), "_%.*s_%llu",
 				    oname->len, oname->name, dir->i_ino);
 		memcpy(oname->name, tmp_buf, name_len);
 		oname->len = name_len;

-- 
2.53.0


