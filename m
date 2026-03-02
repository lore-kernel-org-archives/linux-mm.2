Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A65FEB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:39:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E031F6B0103; Mon,  2 Mar 2026 15:39:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAD326B0105; Mon,  2 Mar 2026 15:39:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C78C76B0106; Mon,  2 Mar 2026 15:39:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B34036B0103
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:39:54 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 86202B81A4
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:39:54 +0000 (UTC)
X-FDA: 84502289508.14.CC74582
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id D268B1C0003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:39:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q5bXqMSc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QO6X1Uu/Vo2xEuFcLUOJqdO8VWbe0HkWPSbdW5NcgsA=;
	b=lTIUw23k/vvI4sqXcMUDh94CMeqU2yaA2481WI26tvhHbo9MJl6L+mk37TWLm0Znl3NK1B
	9GBMmO7qgCoptUUXqTDz39X/Lw4B67paYWrMu3mzMm/xiElab4Q1SnCuAJHVYGMLCP/Ohe
	8IzzOjG8SmheN4brKX6Iq9g8UxzcCiE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483992; a=rsa-sha256;
	cv=none;
	b=TR3UjvqTAiFnl5o4bqQc3vumpJPKhvlWSkFs9xCIxCsX8uOxExhQnvJ/EYDjKAzJXBuC8Q
	qYGIogiDacMDqV8ge/tnzONoAiXfQnYBZ5tIj5RsOZkx8aBAAbjHmvK7W6Xhd8WkQqSDJm
	WJny8k4Ix/pqwRRFy9nbVPXPg1nnLL4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q5bXqMSc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1AAFA6013A;
	Mon,  2 Mar 2026 20:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF32FC19423;
	Mon,  2 Mar 2026 20:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483991;
	bh=QP1pHkPZoLpD9JaMwF5iOH10RN7x3Ujzz0cas9iNb9o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=q5bXqMSc6HyfjyQ+rKMD4tXKlYlU72CQmV2xfF3xqVPwIaGxl7JcjmwWHVoMmc0rK
	 CWAjhyTzKGHthuWmJymYztkTSvFuX7+BVY0Lp016Uhv8duDgAHpR2VnfSz9UWIP0yT
	 /2vDVQ5ucGaSJd6doP/EZEKRN/+1JVRf0qCGLdGxrFwhZWuIORw7Vzh45MvkXEGNt/
	 aWEl30w3MzyXT+IzkQwgEkb8qFYpHqWJSkBNH2rcmXESx9FsMgFwZrY4o9duO1em9F
	 v+1hjK+WqWDb4VU8EqD3OnTnovgCEsrygBIwZQn6R0v/TyN9hjhM1XVMxH4FPFG3Be
	 HQlzNn88eJppQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:46 -0500
Subject: [PATCH v2 062/110] jbd2: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-62-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1926; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=QP1pHkPZoLpD9JaMwF5iOH10RN7x3Ujzz0cas9iNb9o=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH/RvDEtosASDfOeZZpWoaG2cnuxJxTLGMB5
 hi9ySzAN9aJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx/wAKCRAADmhBGVaC
 Fe2DEACArQPddvA94Mxrryfvoz/dxNj68gxh2bOVsktdzw/FE6wVdDGb4fOkGyRw6XD9xPmfmbU
 3bb5T1jfhX98izCfL2GeJuLAl+LPNlDQM9WjGbCyTknP/hSEHvapoYinYT2XCQuH+xKqWayKsrS
 PvHiqJKoWj0RvQsM0U8hoBUcoPWzuYATZ3BBQvJIn/enc453xHUusrB1hIVBg6zLyj/zKQILlJU
 abDFdxUQUVFKSxNDmRVkgNkR8O24DXexGWAE2OLbhz5p2cMvUPWvM3x2Y7i8TffMbjzgg6fMQat
 efpNoHgJ/w+669/EoVggUbqAqTXKOdovVWVM2bZMGD9zj2Po2GogvWJnVM/nGp1nHIvqza44BSi
 xEK+bg7wrAiS9HVvXNnS/aiW52YUGBT9S1RbXlfUkj/U8MvrP5yAfbgMZZtDijmG8fNARRT2IKW
 QkBF/N73kwBazRwkz1Yy3ReqYTJ0GgoDprLih1+sMAE/VhMrR2CY6bTTL7LNS2nlEx4xXHWgeUI
 0eJMZ+Tz1+NfdGD72+BhVVp27P633oUqHfm5syu9K51i1rhf9TF1hcpWTTeGHpGIgMYoTiTXpP/
 XPDixroR6lm0/7ASy6R5kjAch1XVpWRA/e0gK2N5kbaZya7Lo/0NMEtULES9Zaz/PtR/nZg9FFk
 8w2D6U+4Gi4DKvg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D268B1C0003
X-Stat-Signature: rgumnb7n5d3u4n8kdrieskgehh17fn7t
X-Rspam-User: 
X-HE-Tag: 1772483992-905474
X-HE-Meta: U2FsdGVkX19xnY2VrB6WHz55AYILnvz2bh2rtPLbqW9qWl4w2bqdfQBg1ozn+1y10dltJ67aUGkdnaJapfytpRKbLBRBJSK9DWy/n6/5Dp90xwqbJIDmSnDteMLTAD4JMhWI+tUEpiggfqzZ2pVDZxgFhNd2aNiZl0CCpK7SNOLgxQXdDI1vn9bmKhqWfDtmsjFhLfyv9OheVXF16Fn57XAMBDKf86c62afDNAuSPvFxLug9rSKlzGbIMu0lpRJxWMM1ZuV35jIGu63CNkAIqCzpu2nyE2vf6h0uqG7eLWoM0EgX4SlpHhlRCR6PP+BUlOmW1PZKwo58y6Dbl+dIB/XkFApAKIKXapro0G5vzxlEU0IHncUhkcRdU8EHw+vY5A0uch+9YsJttlY3THAAz3RrzujU10A3D7FghnNapxCSby56RJy754CiVzyU/eI+KiJ+YuQy9r/lL6ZmDW8f/SFAQ4G1kccvvXskCYm5ahvPINArbHHjistytQ6IkmTojAm+X0cIAA4ECCqWOQPK7d9vX02uLrxTflx47g7mTSY0fVJmMEQxTYROB51TwRfTbivSuvZTbhaxwKUR1lP3lPViCwhdWM7igod6EAsYs5cmVUCYoqWnMXoeTdXrSmOG1kizevcDOP5j0H2QRFsicjOVk59QAoxmzN7F4NqlO1iSXMJIIPRUrltQm7Mc++2fwLBpAmWaeSXJ4gOuxqap4nfiCKeJrPhzhkENwhppz4oAR/6pXkDXOoa4uCN9U2jhteRUJzQTBs6QV9dGYKIuyKbr5rz5eGJxxSN03fKLwbHtgtSZZpyneANrWleQu9a7RPfLYrBIHITfDVqu4jBi5lktFNFdCJWEfPOEgFvLvgrhAHJjGsP/SH76EZaf9/jNuw4o+aCQsb5cx6BAj3AZGv3mKIX19pUkFDyYeUQtfnUpyT/K5AKgJg67dmqs1F9JU0Ze0Gnd78OQxcxtdwn
 BvP52Pif
 UUpRq/rwPllEhQ6HwKsMlO0RysZOVqXC0y0BaAzHNw425UR6J+bvmjezvHYeCtx0m61GiTdL2HDPpWf7s/8GhdGMxJP1jOPIpRU41gi3rD6WtCMEnmQZGMlBNTDzQ2L8ZJAxL9rpubOVOFXML3Nb83AqIW4mhi3KYWe6KyZWquajAi38tYoYwAWy17wevX2iCZhJNbtB1+pCUbQ5kejfymw0rHejBYeOw3/ZbvYOzyrl/cdInqW0etxnheE0ZNQwlyLfaB1MhrQEKSmLPEJ0qBPqOF9oymnRwlWy0BqNNNhGdGLfYRnaOc1hqsPHlGO3MZNN4KcEcQHoHNaQ18kmEjphJZ5jaejoRL147N8JEPmzpSH9gM+PQqq3SNzzELAL9FN+wvrWduxZS261nyvEP4J71yFVLN3PEqXV+dqvAXSjbwIbQnW+K8e4Q7xt9/k/WnExxicVkhLCxQrh6lnj3aFRd4KxhyszbgbuIBi/wF6bV2MGxLxLbqh0kyN0Hq+f95JQZc5TaR7swUqyNvJmRr1fLqzj7UxRfgxqRF8B18s7pArz7o0W1EUoVvEBm7XZqo1vqAaswod5YZDR04I1epeRlEBjRkCRGK+3jFDIRP4/9yhTntj/dDsu7rcIph4X62CzNRsb2o4mSe8zX7lyJFtmA0jr1wwAdYOoFRZUwl2ujjBBhIqfRRSO/ztRfInQzhb05K/0pD2z4KOx/cAcvyyrkbmu1bPaHRWBVxsPAi3ehx2/ZSrw9IX/pjOaMTy5IXZo2gAD0WE2Y5qUYoLDLqhrlaiixSDBLbJW9HAj4zqaX1wb0KHltd4yB2SqxD/7f05e1ODDv324BjwzlUsAelybByQIuudhS/u3zMWqQ9yC/McrFUzeANouBVBuGY3XEUS3uEvawInJCbv2PnED6Rz9SROzT1ZvjnFeRoKwk1JwRBaH9tNimCuLCHuguWkA/I/CNF4BaYWB8e9hQW0A9cGMzPQ2c
 nNib5Ir5
 J4dEtiATHSpIxhq4Sgs7qPRFsnlg6otXKWPbyGuXyflxukWQ0oNA0qi3gKlxuzwZCqWRVHLxD/2HgBRTCerUcqCLnw0K6UM+irg2sIb1JMYfYeNJo04fxjSm1zlBWBlO0xpDdxYoNX7+1hPmcCca1ZPE3EfG5bojBBG6sAdD4bZWF15nYyUijcBeki/H67SfEeHMHP2BvPE+VEO4J7+wrxNvYXSjLqF4d/9Es6+8W+hEXjM3kzLAFvJYZ6XlptSxbPhKjX+rAl7ai2PKwQQglBLKPKrXJ+S1rCNHNlNZ495zgLhK8Iv+0UZdklm/fskj861Q2h9mR6HYZnhvVRTJHK0aGVsPJTMrgWoUw7G+KAHqIo2cbUOZhwLGM439GQ6sL0w+L1KwGJs3hPkQ3HsVRSankBnCP+zhD/eh7XOyjLc+7Mro9xaVtLBT7laDyuDKoNlepODWS4bIqAmLHqoVZ4ZT7mxJmBWdkj4KaoAjikWzVsnYU3gzM0mR9TBJ8IrWEk+jUrlW9yQRMfxbZSELDLoBI2nhDNcqQk59kjyjfAND1qirpvR5So86+ZU2+gnfNjheXV6sG1vhmC/Idh+YoxBEMkOLE4jBTkP0ci69eVO5RuSRe4ywyB6nvmBbSlTfvANSLrkXAGE6Hhq3k4w6yPaKVb+/zuF3L1jUdqtviIcZ7VDB/2GN/GZkFmbPzDMI+Y9+iNBCphLZAhkeCdIY+YIM8oIIlysaLzpHYtz/74lNqSsfnS7gEfY36+DGjHmZxKF7NQ3/XoudqPYtqfKpPde3IIofZM1BQPhCTFQh5QyYl5gDrlf6p8V8JyVsx0xGzxXK3Q1SRAjnZiyt962tgYo2snEn3iS9yqSWg7C1uPSWQBSbc25cqnE9aNuEpiCO5PrBn73tEhVtjIiibvKJoz70GzfmWPRYFgNO/X9YqvmkxNyBVPBG3WCpLl0kbm3rYhACUlWzv5ReUpvh7nZ+BAXYdK7lm
 h0RquiCU
 oqJ4VXZx6krCbBc5ymwaXR4ZukwqXXsPWxqrxIihtsU/5j/pfzXMEaKVFv88kyvPXln3PaoBx+NbOe0MbI0w6FjCyM0kCUoeUT4K369jLc7+luQ+FFMnbQEm7Mdz9fREopSeZYjz0Ijw39j0lz8pACALmBQqUo8nFNgh9vQjHTlJx2SgLdtVUYcbBFSq3Tu0lzbYxYDh1+IujQRxc3EUeihqI47naHJzYRKKLwJDDbU0k+Aoh2MsBo+JXi5wuQEhC4CL1qUBvnXqIch68/ca+0VYvM8pge+UrlcA8uoPDgrz6Eb4u8yw9QEPYtdW9K882BXWF1/KKiNARz8ICPmliTYEkm9iDxEEa4SIomRkDuoGPHe/V+3OkxYxRy7lWsQENMV70jNRNRlgUzfopGS5A0BJ1ydBnx3h7pCzWxRMrQl7RBShUaarHbvvhwHwBETJ4MoPTU1blVTPxtX8Du1o2524VyS1e+UmZBCEZEmuCGdur7y0/T4qmQdug0eF4EHMWLmQ6dYT6G3FOBFpJOYLslwZ7m7Jbr/RcxKdT9TAJj7ceLjutp7otKSuYBoKecFRVYbYstOv19CSzUZ0TWSZBDRm99XUcPpJe8oUM8DQsCJmbWsDilVsWlndonqjNrM3QMEeO6Z38J7ZFmoLNRVJHd6zAzBJELo58ZXDBIsp8EWKicEYjygOYVH7jG4SGx2+qTAcZd/Ad1+9jQweMzcFV//pZdYNPzVymrjYboe12c5l8ppiP1zW9xQZ78ZS7U5ZABeznZi4AK/zaHvDkcyaEMN9GkheG59xIFLVietQ4SWV69O2+eaFHl9g+vhLNSR+m50jmJwwOPYjGCQcm4qWNCa3qNQS5U+0SuSm8YdlS/AfDXPL0tt/TIL1SSxdn5pLlS9cRwok0FkQiItqLx1p2PD2VF1bC3iz+KHENhL/3Pwc5zjCvgH5iSQntWYkGR3MvDzN/0RB8xiJLI7NlHGLMJ4Uu83Hl
 ZjhPyqJ/
 DCd8oDk6O0rSQd0ToPgi/Cm1AVsV6+3JxduiS5YxyY7klg86T9mlP0k6qvuRiSM5m7a8WWHaitG/Dvk5+ghMaFXlWK6SV5CiH8vP0tkAk0NUTZHpB86vdtdPeWCn9JukgmjOElU4YBGJGRtX6HuziAwh+XuHihq9C/TnK7pdN8KNdrAqHfR9v3tVPsZ3vhN6m/wqoDRSEDNFwLkwERRcRsiE0iAYvzxZ4fi8bSzJNbXLKtddAKpLWS3byfB4Vwg2TUSbsXitr1cyrbXVX160T9yfjz0rFhTze4Jqg5OYW10J5PyG1sEuPC6aHM+lvxBnI1IUYEUuaPlS44rx/hSdOn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in jbd2 with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/jbd2/journal.c     | 4 ++--
 fs/jbd2/transaction.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 9df937f0e15c71028038e1c0c12159421a2444b4..b60918ed8a9965efe42419e6de3f449be50f7ca0 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1677,7 +1677,7 @@ journal_t *jbd2_journal_init_inode(struct inode *inode)
 		return err ? ERR_PTR(err) : ERR_PTR(-EINVAL);
 	}
 
-	jbd2_debug(1, "JBD2: inode %s/%" PRIino "u, size %lld, bits %d, blksize %ld\n",
+	jbd2_debug(1, "JBD2: inode %s/%llu, size %lld, bits %d, blksize %ld\n",
 		  inode->i_sb->s_id, inode->i_ino, (long long) inode->i_size,
 		  inode->i_sb->s_blocksize_bits, inode->i_sb->s_blocksize);
 
@@ -1689,7 +1689,7 @@ journal_t *jbd2_journal_init_inode(struct inode *inode)
 
 	journal->j_inode = inode;
 	snprintf(journal->j_devname, sizeof(journal->j_devname),
-		 "%pg-%" PRIino "u", journal->j_dev, journal->j_inode->i_ino);
+		 "%pg-%llu", journal->j_dev, journal->j_inode->i_ino);
 	strreplace(journal->j_devname, '/', '!');
 	jbd2_stats_proc_init(journal);
 
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 2a03d4eafdee95e5caa8dbd0afe4e32ef4104378..a90f9092706cceea56c1100f7d40ccba0d50adba 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2651,7 +2651,7 @@ static int jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *jinode,
 		return -EROFS;
 	journal = transaction->t_journal;
 
-	jbd2_debug(4, "Adding inode %" PRIino "u, tid:%d\n", jinode->i_vfs_inode->i_ino,
+	jbd2_debug(4, "Adding inode %llu, tid:%d\n", jinode->i_vfs_inode->i_ino,
 			transaction->t_tid);
 
 	spin_lock(&journal->j_list_lock);

-- 
2.53.0


