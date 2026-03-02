Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA326EB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:46:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4141B6B00A0; Mon,  2 Mar 2026 15:46:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D2C96B00A6; Mon,  2 Mar 2026 15:46:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26BE06B00AA; Mon,  2 Mar 2026 15:46:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B0996B00A0
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:46:36 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E2B81160328
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:46:35 +0000 (UTC)
X-FDA: 84502306350.25.4EE33E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 348D540010
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:46:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ClazEEob;
	spf=pass (imf04.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4x8Ajv+557L1GX0Efh1pGl/bCZw/7YI5SnocHg7l4MM=;
	b=2fwnGTyd2Fw7ae31811Z/WFDmhWb+FrQSx3zSUytbufbOtdbj7wrmk/EVq4Do+ycUqCzP6
	5nEGofqpJjXxiDXcilSlgIBSFA/eDxaPyRlm6Iy1pks6pnV98MQKwBTKeqecRxSbLcLalr
	fHC2JAiMeWUatMP52UYjQLFN0yVhCpk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ClazEEob;
	spf=pass (imf04.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484394; a=rsa-sha256;
	cv=none;
	b=zqF7CGQzv8TWsl7fiwwuN0jli6wkWGXnCTuYq3uRYjbghpF5OzVFaWxxMV50S8h+Fe2VGg
	967E5B7Jyo41s2YhUu6UMdgY2tg74x1rSoMLsAeOWiLWnZi5THg15qn1imKfmZFAUTDgrU
	HrpwOv+Qpkzagb/Dk206yXtW9MvK3bs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A720F60127;
	Mon,  2 Mar 2026 20:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB20C19423;
	Mon,  2 Mar 2026 20:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484393;
	bh=pNyc/GMO6ov372VncJrjkwuufp4u2AdNw50PlPHSxFI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ClazEEobUze8svAWXQKJkjXIHd9psmPfuoY2+5Gdn2uCiW5u/+gqZI9cL6nR5Jaha
	 xWkEp933aEve3u1I9tRXCBSCX7X6Rn1p+zjg7K9FcV6iZnpv3XaCGcL3MOiIUYHGcw
	 lbJZcVau4YO7NXSfixiJrLiuyz5O3D/o6r9kfUsd/mvvfgo7OTJ9VTBzjzQdYNa8s2
	 fxnINjMGit30HNhY7XrjNiTGRy5bC+ZOYJr2/wdOeFYu9bxPgvK7+aBvL/El48DzWL
	 l7kV0dsx5qct2gflgUQ9N7+UHoUjSEsnQGU8KpcYOpocYclnt+4dpTuGDVvFotruK0
	 LxVaO4ZP9T7dQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:14 -0500
Subject: [PATCH v2 090/110] minix: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-90-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2386; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=pNyc/GMO6ov372VncJrjkwuufp4u2AdNw50PlPHSxFI=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIIfaujhjMLqAn1ppJL9LQQ5PrWgczSPGGCx
 ALMZxMQc82JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyCAAKCRAADmhBGVaC
 FbZTEACM3CL7hm+JRd+2fosamM2aW7VAlbzyjEFyJq6zk08OOdJkR2La4m7wUSfF0yX5t0HYnXl
 W+OtF5PPZmJVhsdgGX0YChExon1Jz4DcSRkVRlUvoENaed4tdKvD4fJvwN1JhjXkldlRKPxFVBV
 AFtTnPISVBNXhLkw541aR70iUfrLYjBeg+/Q9a1KyfpUcEt31WShsjE75aSweu7035wqdnhgOu2
 YY04gPPgRHLfDOORnG1Wq/S+y7HBNxB9CGYJADUlBvAH3JwnWLG6e/09L0LxzHwpCIwCM47B8a4
 mBvMs3FEgIljH80PN+IeKRAS3gqGN9WMzXI+NAgFV8BPUeXc4eOc+iq8pMx0gMgKjvSLW63PgmQ
 FeO/LW6LWldDcH9RsCOLnvcxEua4O4fOSd3sRq+5D0E1SMZQGEFi1BVtnyTnpnFDY/r0cBxaSlY
 j9NqyLwOo90mMdzog5q7s5Hf74PzjtJgQBvBd0MvpfPEBQQ0JSBEX6c2b9GQNtuLWXWNDJ36ign
 N8BefPDRqtqZDlgyVZQjFDS76p6laor3HeFzNS1MTt38TYDD7KRYxVPrHuxMVgQ6wG7lS8Smgi9
 sR+FMuF2Y6LZUvS2QzaADXdJ68Fkz1sSry904JnBW1rQ/W4dkYE7xV3OH+xqIWjALwQsFZyPz4h
 AV0xdrKEro9Ko9w==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Queue-Id: 348D540010
X-Rspamd-Server: rspam08
X-Stat-Signature: imb4kb8czhyayxxgy7j6u1nze4dubzma
X-HE-Tag: 1772484394-725864
X-HE-Meta: U2FsdGVkX1/TNKsvzlQodBwjXEJMNhc0zgtE7gw5gSAMCqnUUuykBoq3SnZi9ymZcBej0EE6AILbYFJv/kNJS5vcCKXoetJJSuNbg1X7VEuExmqTCSkGLKRjT8mjlsr82ksEkkv/FbiNVsTLbGHSNXJlby8J9aWZ97UKo7+qUTTqmOY/WF/5uSuPTD+OgmHHv6H4/t+WKdb5EgxZt7e3S358CipX3QTuX6Uck0RLgA5ahx9SvWCC8LJu2X+MqRHw4wJqbhaacrTfTP3DnhmfY+GZfJm8jaAuH9yaylzbvb4PYoOUMt2FJ52N+s+kIHSewbay9MyqhYTN3djF806hs8NnoWX/Qp2ofM6WrCwa+KwojkGDVK3tVHyVwzmDjDtdkCJncleQmbYX9CmXiJIiXrcJ/qok5xWvz5xahP6kjtgpY8T4h8dpdFFa2GHc0rC0GLOJCciqFrC/Sp/AZ8WaU3/lEwxaKHlt11JTufQrWQ9awyDwmQhOfeWmShwDw1vj1glhnMIN7JJTd83KTcfrFZ8ugHYm8O4bluJsyPJ+78alWjpoPmibeQfJsuY731hyOQr+Yn0BazZoTrAaC/p9aspt2j54OHWbjguUwmtKGUSTTqHDKv+AVIL9gOdYPQvwe/Dkdv8s5fYdVHiOr8XKF8tAAc8lRM7z7yiy33/DEZTjV6JokJXASSS+iNYKtbU7TnrQRJZenFKaKw2YyT/wl0alc203QIAEsMbuZXutve+e14cam1kltfSaCW6EOgd4ZMqNMomgnYIvd4bEKS1+HF6Mu3yck9KVkE0/mY/QnRnL6HO2Vw8ElQp9rlJhZOjQc0WI/9VhQonEcBaFf9l2X/ybjsAyqc9mXc9yNGewYR0BVbfhvMK+gbtoKiaJnPhiw4N9cKvOJRl7FDrgv+0RxwhgolyNcQPNbfIJHnpSejRM+eX5poF+f6O9yPmZaTUfCsXuh/D6A/coE5saTm7
 VHFN/t0x
 KtSHquTgaA9Bg7FIXkc8EWI+1CrYVrkLZ9bL7zkEGWFAJx10xx/LJwwCHKmhlon3EpSkkCsFsF7omUglPER9+G+9U2Cgm42qhYoJiRfA4VXLxnYkh1J1Ci94Py5SC4mgrafB8hkE0VdeZ+PwQwEJlg8N0H177W8Hibhl37vCSMmu+LVzcE56OsORZALHJBFQnsPWkMHpf9a7VLdGTtO+TGXgtSM7eSdKEurZLUurUmG9IixpE1Ng/kns+MHW7AlwlR7LlbwMNaZqjaCg3adDp95iQy7Pu6+dRhoFbeaJX+wQSlc/6+c9raWI0IzDrenNH5M/7mKWm21Rq8CmoC6gDiMhg7X/HEJ1JwJC4ZoZGWaT8x6/QJlU8hOP5pJPip6t2quQaaW26phOUcyAYKETNWm4roDYYwp7exzuOK5WqSsRw+T8Y19d/EZQtPkFz2l0S3pyfo7RdHjcPieE21wDTvd7vzU9RpFT8p3b1MUSPBoqCE/ffIwEfMwDhgwxmp0ewfa8WanKQCDEb46S3PXsJhHtkPy1jX5n5UbSuITaXlVjikPRtvLpNwI42IR60NbHjyA7DGeDfR59auBrTVrKEBA5XPoKOaP57KCxvFzLTVozo1mNM4orEoRnY49/H6t/6nTSw4nQ0sc7FagW73NXF0PUbdVIhbuFWtRTdNTlxmrM3rM5nApsBMnRnYVWwCCR/MVl/EiUf2ufZ/Q7ez1VjTDYFdUABGDK0glTjhPHOJ/ipJll7D+VflClj9I/5+MH3bnAWfRqg4844EfOsBowpja+3cdUHsI/X/HUha0xGAM4hdXhOVIjfAXhFl7ORJMrY+Mj1swieH7YZMdpGGxNQDI7qH/xAIm7g0v8ZuuIu2CFN/wylJSInMxq+0V+Ohxe8gCqZuvXcPn10aQJcI7eSizSy+8eL6PzYCcurJLXtBuqZ12P46DXGg96lwFt5yTYL6qYN3QOUY9sZ7970rVfcpXZmY4PI
 1SpOZSJZ
 12mPJWq1iYo5u0wzYEmcKz1k55TKciqPFNviBRa/GcuNLx43ojptJULxhi5rOEggRuHQhp25esSGm97itoJYSIBnIos6cACTCJyRYwMoBTu0row7kzw0ctkdGNuiZECaPNibE9JOrcd/iL9Dz9uTEVfr4p7J0o+fIe/bPzV7WgMfdB5aCz5ZhQ6hn/FezVFsBzDRZ5d9dzqsmn0p+dhWVUReO7Te4R1TofVBRzFIuDRPx8lws9RJtvm2Qtm148XZQM7vXOvWdCbxrEl8GYdb/o31WErF0/694IbJ5bocrPDjMPma/98/LjRoCqLzUlLNeYqBHZDAyqB9MU8OJbA2xui8xA9S1CpctjO0Q9YK3hKbPBnC9Ha112wb6x59npRemtZ8xa69o3b2kW7Dc1aCFwYzJP0yz4zGj3KSLoL+kaVSdBJJDJNIzzzsRyCiWLjyMQlMBnwVBasKhanFlf1/XstFT6xoS/cDqVe8Qx6T3oczFyXJ4aONSa4yrSCDN4vGGxCUKa7QOQykLFl6FGj131/mC1IuAxfoauMqFwiK7bqvpoAQpfFDJJwRZASZSj6CqB/vc90/o9ZUOqnyCPQ9ObhviAXnhlEJaAQ3KabPlz/VXYlJpyPsnlEsZwWDLOuGT4a6MDM5t/gASt4PeM0zEOMorrFhWDh7NPfnWfvzzM1bxTQCs8WiT7TeHlSrFVGRoRAa/4NY1n79yEp9478IYhT4mscuNTklNoVv+UjixF2dV2nhY1ekoNFVrU/MvynO3E7HTLGvumu+QbzxfuFSfOlgezRtckaAtnwGhtifNhBVdyp/OGIqGPp/qnewDFoR+3eM7wQlmZliJynf84kBFaLF98kwGCRGf/OM4ntpLRWfyq/AY75WPGOi036MQuoaS2RgTfOZyzz5+S+MmL8PXHmEWp8ypNABQWvkmOnbDqFbLMyLSFUFWPWpieZHyy12rA9NJYURUuxQt/evQWMxIG8wkTgQD
 8q2z4KRN
 n4e/W3sZhdlhq4iv2gHydPYe6ySA7mF+aQIUp7VBualU1rRwKeobQvmkG2VJwjNo36VdOf9GVfjUGeKjwZhm4wMA3Xtl7RKI+TEGEmgj6eqoGYP0VxtNRdhbr5j2ti2hhbi+YbYUdfnIu3/fH9BFIbAc0vvX2HjqvdJ6/1+wmYKTbLqODGwO9TVQJIWPf4/iOOxmAMOu+pJNJIePugWO/vFFESW3ARVPJkmQAjj3GxfB9QMQ3wwgD1dwZIdkDrtiEGNAZloRAG5+kA1mRKwp68R+qrB2dyWFRiY0E60UyoybqyUD43e1z99Eim3Opq8kunVH//bY3lE5I+4ArUkJ9YqRl6BlDuas/+Pdoq+GD1bAgfMMxKLeQHJgBqwFPCoseJDI/RqQdywzGsEdo+3s7Z20eaO93Gh4CO4RaH5KyIjmfR7TzfLJm2BKcZesYDG1NGJGe0DrphXNPeWMu6WTgrKcZVYy+vYH1ih/WVpZ5aVIcOL3nzm4oBADKnH2AzTOm7OB3pLmAp9Z8YMuVYsRntZlekp2SshD8h5/k67mi2ybnFBhdEVItfHuWT/OG71kWarSnf08drQbUKzizc8DkAO6BhgW3PTqqexlBcaUHAHLk2QjZEiKCzRo3bqzQU0zJpERS5DcA1eP3en+BhOb/+AR7MPFetI3+BTTMVWMEnEperydW3jsC65agYXDadW0I36AXOKn+wwKrbYTid4aIt+T1dT1tRCPdQlOw1GN1Prw+8OZL3WMOqyU+gyfqn4uqh3E7P1HRCTpyK9zUHPk/vm6GaF1k37xmJiKqVVDLyH8KDaEONAVjZqDf35hga0YIepiEyVagCZycDP7E0pF36ojV9qU3WhdXWaki209GMF6fV3uEhzlokCd1daHbJb4TsYNp8qVXBmGnvu6ND6NCTkSMFwLuGzJWKEUHh7VHMNFjnnsZKuGYFxkZwcch2YMuQctMyDGnvkQBVvMsVc1a+fOoVV0j
 CQkJb82r
 ya0uufpxF1Gphcpus/JCyovrNQLb/zdErwfm/oMV+Pxf/H/TOkmD40HqBVjktBbsRuKlxjbtiXTlep3aeJYIJ5PV2fwl3y8d8WiZM5CEfZWURZtgznmEu2856XhIUp08rEpFqT7p2lsJb596z24uMGB0NIf49U050GHyX0i+RZb4Jmgfd9OLUm9Pr7NBMOj0oDsQbkI8/G8vZU/BXgQF5LdK08FNdrCkXFXr4aXn7OJlaz3zFfc2jYB3ifQO5VYPi6awAzh/Ce3jZiBYgNiTJ4n+1qsG9UZ330xuytBPUEKb/P3HKfL5Vcskl5TCP5mU6hu+/GcnC3qiCbGZyhcNZ/Bi4NHxT0/jEOIZj6jkLGBsPXzp9xJFOh8Id3EZjMtgQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in minix with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/minix/inode.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index d92059227d273564c86f100dea3366be4509090b..838b072b6cf0b54c955320916ac996e72f994a14 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -36,7 +36,7 @@ void __minix_error_inode(struct inode *inode, const char *function,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 	printk(KERN_CRIT "minix-fs error (device %s): %s:%d: "
-	       "inode #%" PRIino "u: comm %s: %pV\n",
+	       "inode #%llu: comm %s: %pV\n",
 	       inode->i_sb->s_id, function, line, inode->i_ino,
 	       current->comm, &vaf);
 	va_end(args);
@@ -520,7 +520,7 @@ void minix_set_inode(struct inode *inode, dev_t rdev)
 		   S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
 		init_special_inode(inode, inode->i_mode, rdev);
 	} else {
-		printk(KERN_DEBUG "MINIX-fs: Invalid file type 0%04o for inode %" PRIino "u.\n",
+		printk(KERN_DEBUG "MINIX-fs: Invalid file type 0%04o for inode %llu.\n",
 		       inode->i_mode, inode->i_ino);
 		make_bad_inode(inode);
 	}
@@ -542,7 +542,7 @@ static struct inode *V1_minix_iget(struct inode *inode)
 		return ERR_PTR(-EIO);
 	}
 	if (raw_inode->i_nlinks == 0) {
-		printk("MINIX-fs: deleted inode referenced: %" PRIino "u\n",
+		printk("MINIX-fs: deleted inode referenced: %llu\n",
 		       inode->i_ino);
 		brelse(bh);
 		iget_failed(inode);
@@ -580,7 +580,7 @@ static struct inode *V2_minix_iget(struct inode *inode)
 		return ERR_PTR(-EIO);
 	}
 	if (raw_inode->i_nlinks == 0) {
-		printk("MINIX-fs: deleted inode referenced: %" PRIino "u\n",
+		printk("MINIX-fs: deleted inode referenced: %llu\n",
 		       inode->i_ino);
 		brelse(bh);
 		iget_failed(inode);
@@ -692,7 +692,7 @@ static int minix_write_inode(struct inode *inode, struct writeback_control *wbc)
 	if (wbc->sync_mode == WB_SYNC_ALL && buffer_dirty(bh)) {
 		sync_dirty_buffer(bh);
 		if (buffer_req(bh) && !buffer_uptodate(bh)) {
-			printk("IO error syncing minix inode [%s:%08" PRIino "x]\n",
+			printk("IO error syncing minix inode [%s:%08llx]\n",
 				inode->i_sb->s_id, inode->i_ino);
 			err = -EIO;
 		}

-- 
2.53.0


