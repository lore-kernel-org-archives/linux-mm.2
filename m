Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09DEDEB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E7AE6B00B6; Mon,  2 Mar 2026 15:29:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A8C66B00B8; Mon,  2 Mar 2026 15:29:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55DB06B00B9; Mon,  2 Mar 2026 15:29:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F9DB6B00B6
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:29:51 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F325E1C2CB
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:29:50 +0000 (UTC)
X-FDA: 84502264140.26.4C534F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 126FE1C0003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:29:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dby9Dgm3;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w86rpYCfQXYS5iQ5+EAm9nqiVuGJ0fulGCu4Po/LuWA=;
	b=LQphQTAwBXOpEJk9Aod6zmcM8YuHBwgRErSKuwkx4aiXW5qbxfHnmFQZgSSCSajRu8hBtn
	+593GBq0i+57GrjXc9qdSCyQC5qkOXMhVfrNIJ9SQVJsKXCehyEcPz2KN7s4WygMo8PKsA
	jW0/zgAsfBBmh5u+X6AA8/4R9R8Ne6M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483389; a=rsa-sha256;
	cv=none;
	b=P/P1X/fbk234/WL2Mv1i5Gz89Cijnlv9GrELyJb50EDct9Qom9qJMdvc0Wer2TzSdOXSrp
	Hbym2osOVjPplmslhgUVbNX/77Nw+8vPYmDb8ciVSEs+bkr96AnP455auYhWIDtQJ2++C/
	1/znhwUF0I8de+XQhsbDyE5HsnK2k6M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dby9Dgm3;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3289C423DD;
	Mon,  2 Mar 2026 20:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E821AC19425;
	Mon,  2 Mar 2026 20:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483388;
	bh=8R+tpWiGjDe+xDyyVkNhWfDz6BdmeMn5aKOhywEIznc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Dby9Dgm3UOiYE49pHDnOJpgExxCLknWI9d0RI9gSsNHqQwFObqzGeFCIMSEtmDUS+
	 X2nRCtvwGXVvTDmxHK1H6I3a1BUqDkotAQqMJsjjNB05hl1SIw/r5Gpg6/et2t7obo
	 jRGaBZN7RlOv1Q7YS7jJUH30hY25+MHsJquwZTgNkCa5wM1XYFSrzcY+E/iPMVaCah
	 QiGaZVoR7T3S4iM140lDhJactcYjR9unuKhxOgdFoViO7+gAW72a3STL7BlM6R0eX+
	 g51E/Nf3gUXmy1kOw3vCgFkVwHvALqdv8t9GOOAN48HkRzW6zbjCfMHfuIW0OriqI6
	 bVXjKFws2zXZw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:04 -0500
Subject: [PATCH v2 020/110] befs: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-20-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4100; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=8R+tpWiGjDe+xDyyVkNhWfDz6BdmeMn5aKOhywEIznc=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH0g7s70j/Qt0Y0J0IJTO3BfuEQNEZbYximY
 oVEul2DEEWJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx9AAKCRAADmhBGVaC
 FXmqD/4yA0oAZPPpmK3woMEmcPi2HCHFa+yCwsUZPxOKFLM6uIgzefxZhY+NFia1GQ3ssvcKHV1
 ZXnpRrRhNspdFH9/SYnnDjETDl1UPhXAwRqH5gpryFeqqY1YzRqG9a7sHMJS3NYj0DppfRZPujp
 AP5VKBo2vE+JBFqD9o7cjAz0nlyUIPSELaE4LX/14Cxpe8x3ZZg4nJZaNq3I1fStXFU4BODBd0o
 YkRQy3fs7ZD9oXRgPu8sXoZMXaNk2doKNzD+tg/SGNftYnlvSNfMcf+nnvey4+zBC/BNwf2ZiVO
 F4QQXPIBWOenSD2B/QAmHVGXBuqHJwesN4ewidmwqu9eBSVkVYaRCc4zfepQB6D9NjA4FeKDDN3
 7QRQ5vgx51GaOCR0UcT2usuJfwK9mEUCi/zzu1C5cuXoPgRFwLjiBy/6+QMhfSZwgCqE+y1Tx3y
 dfxw2kE3bM78dQHVg9fOj1lKq07nPTtW4eBLgrRtLBJdAjil+uTiYpuBFFnZ9MeQwolmTJr4M+n
 KvlA5nvejLX8tsV3bbImOKE9R6fbdLVvdJeavm0bdX6qOQ3anZReCi3ZEkhVEs2Pq4M3+54/sY1
 es6rg4KWDnDBFGYEIoxkBkAuqPhMh097ch4uqA98YWQEaJjZnFaNnDbjT4fUuRgh+p4EDvkXscy
 8G4BAXHGFp/r4sw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 126FE1C0003
X-Stat-Signature: har46ufi34c9qhfxz4nps1wbsd3ktx8m
X-HE-Tag: 1772483388-505531
X-HE-Meta: U2FsdGVkX19OyRSXIl8I6zleKeyQt5B7x5ybWe2FlhUVUjTwWT6atm9Tc/IbhkZAJADgEyNCv2CC76L+shVrdKgdUipQ1f4W9i4nLmjvo7ZYjmrr7dDYF+DAF4PH1sq9UdhbY/ZwFEqGVKbyrLULsY/QHfBoYOOHp/tM/C2eInZO5PCu6bgBe3NkkeHq62EXLtsv053YGhMD3qlNYTLnPMnE9S56KJttoJEaR5EX93XJCEtitsHTydeVEwpNnWAu6Icq+/PMKj52P5aQhn0HiUCjwa0nH69S13p1EmGbe9nsFyfOd7QQ6T53m8g4HPWNg+wOD9mW07YRNtz/l+IIBoHqFP27K+QuZgevOZK+llJ+FuvTYzS1yKHtOJ1ZP7/Wd1ZtRUpSYCDdcbHWOnyVXv+BKNW5b74XghgqFX7NSL7LlKORJPCKktJ2T9dN+oIkS1etMyk4zH9MkDd8n2XXDyVUIH1jvlf6EBnucZDMCutfG6nj7v2XGAyIv2Zj7ppLX5rV7idf+CvXsUGYTXWunPBspeBfxnzZPy1LDZU6zlvmAAQZDfA2gJuVOkAto8yfb/fa9ya+WU18JsnLu/xThx68/IIZ138vouyf3nxwOudcsFuhTJ1r0CT5B1EP3VQm4P//gbmXR/x121mwaK6XOA+L4lmo8m2u/BgtPhnGOYWS4vhBtBAvo3UE/ClcrdD4KxDGhguX6woEiRNspzexmGDK9GJ9L75dAFQHYTgx5ZH2gjvIaEorPGCPllPLYtdFj82unAtv46bk1nxoaMyKhmH9OrzGTMiylD7jMFGneBaM+g5/tzra9aqOqKN3g0DemjoAAh17Rm1Q9bQpFSXQl1yAOLASdBEggnWPGXvV1JRBNt58wy/FNn0FF4ZfXmYaMq7916SpX9OlVu1Apy/Cxkr0oVXK717BvajekOCohMxanQaEH9TsqAkAFzECuES19BxZ2VBD6pxaEWbSr74
 f87tB9vd
 EXQb6Op6gTfJ0ftU++fycYFA06Y4e1JKyfX+9hN2XvaMT7/aL3LxzqKlaPV6YEljsICK1pCPeVNkYyJLi4TXDf42NLWCHlVxtQeFSIwf+49kcFjTA1QkFB7ax3WiRNjp2cNXhdILhLVNjUxzQHcbf4pnOsduYbNuwuUvX716lxfY12zC5I4KN/OiG6vILxCybMVxQauyb6WLmtBgyhkmpvkAc6+tn5wj4azZRG0jGm4Bn1Z7eFkilrJx9VnfrWEzg5nSQDwsaX1tYP8slh+XnG2H97glNzRH3cE06MxxaPKPWnUsVxO+wkcL1cHHicM/bWjHFQHnR0pKApTc3D2hodkw3GY3nXfTxBh81MkJ+GWK1bNMNZUxe3yes56qpTA40dFATr3o5Sa0WjbkZgMKw6/pNQomlxwfJyQ+3j5k9NFuxFD12OUZhFyGderWLrYc7ocjEuXZOhlAOb9gPxUhLM5giaak89A739BzQn2pZZUIJT+FCqw6BouBPq56BLxyb83WC1espl6TNRhI1six234+AS4O/dGBgdBHV1N/ynuTa7eHMipGs9prVacmW/3Y6SbEmnztvA4BFM3h40Xm1CuWjLXGjnWY5vlGgHBRRbj1xUvhcE/tFGCdaSTVyOf/Mmm3cPSvGCWRQqYMjPu99+NnSDbhiH1QxFF3q6J7hxLMsK1yOFtcT8IjhtRwYA4sMJ1t+gGh7xNwWJZRS9O45l/mJEXTK7ikUtgRnBlZS66ZJcq1azZ5ACywi8x/IqckAlWr0v5apZwUsESskst17qckAIDoB1uJu/4pKO/lAwyVWkPCjM9Xr22D0YkodcgD1/vn3UgCAR0ODJJEZm6aIHkyGTxmaUGSQGVfJeAbjAIOxxy8XyeCR1TIH+TdXPyWo4kljUpXjgwEJwF0uXTQCEyqNAFEBlwRg/ZnO2bbAjWlQMzKFNu1Q6Hdpbrtf5QE4MPMi/hcYkQDHh6mZCeLrcx2UQfgC
 OyLEJGjn
 WBA5ofAu/MoOgN3TY7LE/u1PGWbDZ5b6ClzLA5DMhNOdXznDy3veo15Hf0Ch7QNK83/smP1XSs6I3MHJ8l82I6P81lsVfpR5rwNjzOVcPwrFeveqT35ZS6AtSwUhZ9tqtx75jEWzGheBfcwpV+H5f26bIsATyoU3S6B1zpranEzF7QSUxGbL2vDT4y7khufMPIYrOC1rcQ5WIAlxfNTX91WR3HXRU3Yvl3JUgreswAwoRYku3gBbbLMTuwdi3hhVK6HfvfrUltA1CjQTCXDgkeakt6LycgGF+yuWVkfNMcPURsMHuvqpEJPZbOKR7EgS2XqIx8qNsdPdy1CiT4xMDbsTw3NyQfi76qEkTU6KEArEX+EH3GHpdDd/7183viK5Vgcxpm/WcCDXKFTmTOoD39XGi+vjSWO86kDtaua5xMWW8I7hAmZw/cOwKcHarrCNTGWAiVyXT/RidoSRtDVSGeu5XBbvto6/0FUhExTUNfoAu479vpXzxJqeuhkQpUymQ8eKgTymq1UjcBIrc8kJ3MrMBLtu6Zs3ReX+IyMYKrMqMF7vbpUK+kXjbfUcI7/WcORLEzZApsv0o2TZ/zbH8wiNrjqxz9P90jmFq7ISVLqRmpIJt4Gi8njbyiRiainF2KT7bV+RwixhdNGV3FxVs/Jeg5KdO1c9EJtGQwq263hM+A31sQyPoElQ+oThcv6y/Tr/TiAGi6xE1rIemJ7Z1c8eAEJI/Q2v7i9HIuLjzwT8muJCQuiPrsPYZ2px0gLqgWEEdLkmKE/Rh47RIxBNLx7mXt6tIjKSC5ghK1QRYfSgZdzSfO7P4LEsnQ0vSyrhyMyqZYpnS6mk9ab8XELZFw9JT4txn1ecIw7W9nL+gbY1eECY3hgVSgjNsTcNgkcDluT6LkbeEv2IiL+Z1sW6qlKBYS37XDKB4IlWu80pv1eRM+eCKzhyOy2ufhQrPSv2XCPgEbgKJbXB4Wfu9p2ZdisWGHAK1
 xnqwabzT
 85HTewATpnd0mxOyH2kTKCEZWrxXdOizr0sFwcrmqp6kOCVv2WzxaDYr4MoEVWfibnF8MTUisK5DBzJS/CWCSmZTNJcG1aXcy4QlZHWtHreyGp7nGVryzwDCiEaGijiLqHbNVXDh3mP+5LdGk9sJBqllnzjb9aJxNZbxgNUQAI7925uOH/OEkjHd8LvfXBesN3mBsJlLJMxA8fcyiAzp+EUqf761Y6OHwp2xv0ZXpvp97CtZP5nEqMgT8MzeS7s+ZuMbnMW8Gts7PTrEoFldcdsZEkixzzRG9SXFIm5GRQiRqgPXliBxW7fTcl2bgkK1rWX0+iIZ3BRlOFuxyv8jHBAK2pnx43/GZe/dkWepbdRK3B6hqtC6EDGuvKvIG9j0MIA2IHTUneZb+AtCwHBSvM5ubGklxh3M/MsBWvDikQSkUD83CD/OtNmYQ+ZmsH4n1Q1iKDTohxF3jCK7iewX9nQqejAQMV5EQM5o2a4+6aGzgSK3WoYuEftXUaVJeplY1d56w2IwXcONyO4KgHw0jyi44AUHkO3nICdqT/FyEzhnWxnj1/72ifKx1dIlJeXQBoHdV8pluPPNidBRvaxe1cmvOzDC/Yf+WGsg72q7gHRamo4/opa0zcrhISpSmQd5aKk/mSKHLdTp9DIU+zehU7WA0qqkHNuoYMsebfUBF4Iv1/cyBjaOr86fAlTOH47122b8vS+hvkNuvGI/A+/9+HPIF3mXhcbTO3tLbwPXD98Aa0xPm1uI7ygAUPGk1tLpQLRv0eAs/zBI7wFo/RKwwJTNHNsI99wWL03g6uES2mNrYZL0U/xq4vUIp/fafjlcP/jrnYh9DaQe33QafkGqBBKQXYRqUT9ADRIxopNd33zsMnAZdW+9IqUkWXYqDhvBB1tQ0TXYzvMz8Ey+pAdexBfBnWkrvb4wbJRNN7BLdsUrnIcTrno6aVAmEvPjw6ef+aZNVyA/ULJfNU6ynQdUMPLBEbmYr
 cdGwBi0S
 q6BE1sz34EG5PIe6fkWJddpE2/AtfpR+nViRO9leJuHQ4hRb1ETmbsTnjXgHM6gwp6Xai6IdxqNO8Fp89w5v/MDOy7GNA/QPvh6ZDqUEqlsQ++SsFrdZpE/knRsr14SimVIU5kEGHenDviocYCWmFaxW1BfGBEfRH1qVThrhB7GzcAaknLZOPfh6iKKYPvc8upOYUWJebTQ+zQRqEdVCFryqCHXirl+TK/h7XD0vO3uKeZ1IGnsiljnjFcW27OoSNQ+hIa3ay5LWLYTtIgKt5Jwrxhz8inR6R6SyPtO6E8bSZDBBitpxDM5C4rGXMaBvyybybqlFXIJKM51UBri4/yiLbVnxjiTFqbfpQsteuwiLo8pw/KZX6sIO0lBqAw2eErLnd2zzcDNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert befs i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Also correct signed format specifiers to unsigned, since inode
numbers are unsigned values.

Remove now-unnecessary (unsigned long) casts on i_ino.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/befs/linuxvfs.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index cecbc92f959aa5098313050b515c9af38662c8e6..c36216e23eb3678645cbdece913cc260fd10f4f8 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -140,20 +140,20 @@ befs_get_block(struct inode *inode, sector_t block,
 	int res;
 	ulong disk_off;
 
-	befs_debug(sb, "---> befs_get_block() for inode %lu, block %ld",
-		   (unsigned long)inode->i_ino, (long)block);
+	befs_debug(sb, "---> befs_get_block() for inode %" PRIino "u, block %ld",
+		   inode->i_ino, (long)block);
 	if (create) {
 		befs_error(sb, "befs_get_block() was asked to write to "
-			   "block %ld in inode %lu", (long)block,
-			   (unsigned long)inode->i_ino);
+			   "block %ld in inode %" PRIino "u", (long)block,
+			   inode->i_ino);
 		return -EPERM;
 	}
 
 	res = befs_fblock2brun(sb, ds, block, &run);
 	if (res != BEFS_OK) {
 		befs_error(sb,
-			   "<--- %s for inode %lu, block %ld ERROR",
-			   __func__, (unsigned long)inode->i_ino,
+			   "<--- %s for inode %" PRIino "u, block %ld ERROR",
+			   __func__, inode->i_ino,
 			   (long)block);
 		return -EFBIG;
 	}
@@ -162,8 +162,8 @@ befs_get_block(struct inode *inode, sector_t block,
 
 	map_bh(bh_result, inode->i_sb, disk_off);
 
-	befs_debug(sb, "<--- %s for inode %lu, block %ld, disk address %lu",
-		  __func__, (unsigned long)inode->i_ino, (long)block,
+	befs_debug(sb, "<--- %s for inode %" PRIino "u, block %ld, disk address %lu",
+		  __func__, inode->i_ino, (long)block,
 		  (unsigned long)disk_off);
 
 	return 0;
@@ -181,7 +181,7 @@ befs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 	char *utfname;
 	const char *name = dentry->d_name.name;
 
-	befs_debug(sb, "---> %s name %pd inode %ld", __func__,
+	befs_debug(sb, "---> %s name %pd inode %" PRIino "u", __func__,
 		   dentry, dir->i_ino);
 
 	/* Convert to UTF-8 */
@@ -224,7 +224,7 @@ befs_readdir(struct file *file, struct dir_context *ctx)
 	size_t keysize;
 	char keybuf[BEFS_NAME_LEN + 1];
 
-	befs_debug(sb, "---> %s name %pD, inode %ld, ctx->pos %lld",
+	befs_debug(sb, "---> %s name %pD, inode %" PRIino "u, ctx->pos %lld",
 		  __func__, file, inode->i_ino, ctx->pos);
 
 	while (1) {
@@ -233,7 +233,7 @@ befs_readdir(struct file *file, struct dir_context *ctx)
 
 		if (result == BEFS_ERR) {
 			befs_debug(sb, "<--- %s ERROR", __func__);
-			befs_error(sb, "IO error reading %pD (inode %lu)",
+			befs_error(sb, "IO error reading %pD (inode %" PRIino "u)",
 				   file, inode->i_ino);
 			return -EIO;
 
@@ -324,7 +324,7 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 	bh = sb_bread(sb, inode->i_ino);
 	if (!bh) {
 		befs_error(sb, "unable to read inode block - "
-			   "inode = %lu", inode->i_ino);
+			   "inode = %" PRIino "u", inode->i_ino);
 		goto unacquire_none;
 	}
 
@@ -333,7 +333,7 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 	befs_dump_inode(sb, raw_inode);
 
 	if (befs_check_inode(sb, raw_inode, inode->i_ino) != BEFS_OK) {
-		befs_error(sb, "Bad inode: %lu", inode->i_ino);
+		befs_error(sb, "Bad inode: %" PRIino "u", inode->i_ino);
 		goto unacquire_bh;
 	}
 
@@ -407,7 +407,7 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 			inode->i_op = &simple_symlink_inode_operations;
 		}
 	} else {
-		befs_error(sb, "Inode %lu is not a regular file, "
+		befs_error(sb, "Inode %" PRIino "u is not a regular file, "
 			   "directory or symlink. THAT IS WRONG! BeFS has no "
 			   "on disk special files", inode->i_ino);
 		goto unacquire_bh;

-- 
2.53.0


