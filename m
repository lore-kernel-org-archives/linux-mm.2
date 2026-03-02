Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D5EAEB3634
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:43:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E42F36B0123; Mon,  2 Mar 2026 15:43:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E19F56B0125; Mon,  2 Mar 2026 15:43:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCECA6B0126; Mon,  2 Mar 2026 15:43:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BB7516B0123
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:43:29 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 920DA58646
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:43:29 +0000 (UTC)
X-FDA: 84502298538.28.8D80258
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D9827C0009
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:43:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hoeN8F+8;
	spf=pass (imf28.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8qq67JG2u6he3RRlvux3Y0dggM3WCt5HHBxAU1mUQMM=;
	b=6IP8EY8RWoqVVKUAhJtv0O2T+78LEyak7j/N25B7eDIt4322u7IUio3MPUYBEuXLtgMRT1
	MrcPFgjN5kcmKBeh7O5Nz09V+TNaGFKdC1N6hMqEI4EY3F7jKs46MItryQca7/3WzPa1d0
	F3dmzt0JDSe1VTtCqsNqRoZN3bavnZ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484207; a=rsa-sha256;
	cv=none;
	b=qRyLEkEyRX0XmhthP7Rk26Jbzs+akEjASI74MfmeUlv6ICllSJloM/0QhOIDR9Hr++ifHe
	m59lp1RJoTVNX6n28/XPvsijbdL0zj5EYJhdiS+bHWlab2RTwv373BEJCWBamvNdd8fULR
	MsCmPeU/dvCDhDlaU0AWTCB1TlP0BKo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hoeN8F+8;
	spf=pass (imf28.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 27C9C6057A;
	Mon,  2 Mar 2026 20:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA83EC19423;
	Mon,  2 Mar 2026 20:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484206;
	bh=E9x8941cFYkkPM2coZD9zVcuOCPVEOS5pYhXjktUHSA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=hoeN8F+8pRAf9JkOzIWMAJSY2FfOz94jU6CTs2zxgOl+xJ+3k4KxdRRofktbXTlU0
	 avE3DLhw50Abvgdpwzxt+awb+9BEwbmKyeQbwOLT6tTqXlzUQpjF8hN4ufqepo5e+f
	 mu7vASnsMFrT1AQKRponbKIzj0L+sEnW9qCRA6Q7IAOlvv2k5xwAskBXpn/bZ8+CHB
	 akmOePFfZ2CT6q7QoKUseCW7pJ7zERTkCgNlmCsD3Yi1NBa66e2L+p9v56CvWQsHCl
	 6ykdjVPOAdA3CCLLfNbfOHeO3T9UKmaQlupm0+DyrjRbBFsPNJAbZQMOy6Nf6x627L
	 YZiO2yv0x2hPQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:01 -0500
Subject: [PATCH v2 077/110] coda: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-77-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1332; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=E9x8941cFYkkPM2coZD9zVcuOCPVEOS5pYhXjktUHSA=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIEZTf/vVG7rCO0GISKr6bG7qFPwsWNvSGfV
 DgwQ0GqVpyJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyBAAKCRAADmhBGVaC
 FdeOD/9mavLRdZWi8JF/UCUT1BO815ovqktK7rbeu7A+SO2b5LLvmF5UNzRhOJKYv4PsZtgkgLM
 rCCNKWh0LNeWQznAQaDBGyWCl4AerRgy5sx7jprpxqx5r/y7RPZ6c+8bAe4Vs/n/j3mo467qMuU
 s6BryzSaD6RfZD26fgc7HOXXCbNUXC17wJMceT1X7E1v1OyTtApy0g6FxxGsAAibJRIL3gkvOHK
 c5zSJPCmgdUtsZaSbfChmIQgWzIrfRkPWxNpyjP70nQVHA/4fW1DbhBVwxRMCOe8LEJje52DBnX
 Q3mN09c3n1HvihvADRlCnvywgT2rUzTt07w9VDdxF6dszrqxwjFqdfgDZ0JW3Stt56v6MdWJoTw
 H/RuiKgOfHSL8XRINJa30qogYsNX98ulLVumE+pMKHc5UNcDoRiTArL++T3OdeAKgCkVBKqQ6v2
 ZuZk3/5VtLWLkkUZnxzvL3oTm+jv4VMXt9SO/LqmvelzRb1PNYzKTKV+aXy8yKYaLGxzoFMmA+5
 1BbnjKJdBV304PSdQraws32OjEW0c/3rHJF6rpAMbT91NGUTWHpDjQadCJf0ndC06cqgfYNB6rg
 3KMHPYL6QhoTgjv69gV10Khk8Sln3xsWGcAztnWpXXo2gPeqmufqwjtQA7xd8Gf3tIImjdfYrGM
 HDsAhv3R6h4VJBg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D9827C0009
X-Stat-Signature: 6sjjj9ynpegafgnrfe7c4e3xpwgzuuq8
X-Rspam-User: 
X-HE-Tag: 1772484207-727958
X-HE-Meta: U2FsdGVkX1+U/3hMguWQKkHjYnFESFKrL6ACoxDJBLbAky/k8MUl4aH0sr02ROXAmlwm3gpTtMNBJmt/x326bvtC7rWz8238eM8XoZd39nOAnnq/02Tt7JwbBcRjaIkl99h6FwtE/yn50ramifwrbSBIoxRIMWBsc+MAO/sXPRFawQf2hq3s+HK0BQBYXhnEb3If7IAR6ZJRBJa9loN4OEDQ2Sw3tBowVI/01JevuUVYlsXZeiA7mjELftDjaqgfS51IbVRbYaAbXLNsl28yUgeUDX0zccWLCM2QtcclwFEr5aHB7w60D2jv/yfUT6wzux9L0p7yumJfw+HHzV2AOuSt11hBu+3ruhmzuOWd8lVyDk2Rg0PKSnHctAtskCkETHm+WdOUc00sYF8uiMPZy1MMsOIUL6yc03hA+j+n0X4TwHtSRQ5ljOFA5NfwUyipEKOORy0SyS+3YksiZDmEd2ZAN0SAdI9ARlXmEZZclVarGhGg459Nwy8tYBD2j+Y7nzEPoTZR5K3d1kdik8x4V9n98Uag04FOtzgjQnlEAgGF+0sNrhGvmKgvUKfNmUMlx4gBh/QtXd9oX0AL5XKKFOlrHTUf0H1d8QNzM+EwIm5J9+gBdMSk+yOe0/+KqORfBLv346wrQ1R3MdbCCnY7Yu6WtE0awXzmfROTHWl2FWKQ60FucGBFU3zUV/ASOjT3j/oLNdCnzwB0I/m/uOhf9oB6gc/fmQ2VZphdWC8gkZjqYzr8YzGmEynKuFYrJH5vKwslTr6fjf7v9NjuEXc9+/DBFIgRbgsbIgZWme8mwWA3jO9+hGreLLFVbU8G88mvsSPPxX3wr/kPJ1kiwWe4wRys3hiPOz3Fxn14KMUWTLalyede0MXC5f/GKV6N/sD0HlyvY7r0tSf9xfewGxGal3ZhpAqqPQB7XpoxDgwFOmmPU7xxXu4nYjt8BX2LwZ9Hrmmen4Zz4ajgIDN/rab
 teSQKIxB
 Uk15XwONkPaqPOm4kndaqkI2lYvN4V39waTB4tOxRxOsZipWyZZaBHX5R2P1MZe/+nXGUBKQvCIHBJC3RRQEcdnak51D6mr499AeYjpyAqGd1UapTuu59yPyiwzMjJDDMwOSuEQ8Q3kjJHbpQSFzcPrqEAV5NDcqvFsSzmv2UxpOfRsuVjxTJq+fomIyy2zDG+UmbaQD5dfe1QRAoEIms/5e3A+BmV+8/SDEIjgSFRKqAxBLDrzEDRbe8+lwU9IDyjSSuvbQ/TISnk4+kw9Uh62ZqT6DsJvWafxQiNxB2/PgB5wjNmEKrAJbX+jQvNm/ZJSYjZhcBgsxVrofPA3AikRjCWEB/eQT7BeBsYa+/Hr1uVIGM2mh3WdyyYLwyBkT9TYfP0/8HiFVii/O3cf9khFPd/kxu8YLEP2fjzZqCp0N6vj2KTCOSjRXQFv5/barSMvXfesGw1NTYLTPZNtZLvg+uk0Fj0/YyLBm9PPtKYip7VU0I9rlygYLutIGpnWeLLhJZMps/v75ARyyPyDZ1tEGAluKUcE6GxBaECdQe9kA98YMNYca8oBAx6OqulwJXL09echRPBGdP6okdDW+pTEj0rUf5u6IE5RHf+B4tQoAxvBSzby6iA1SxikEeM+bNVN/xfwy0Mvhqroxlxa2S/UnQqcS/eCyVDp3h0sCyiR8wEGgFPxDutk+Jkd5RLgLJhIxju8eOW5Z+8Hul8uDck4amVQnuKVcHVoBGnlhypGpv+K5pwoGX2Qg5rNsegpFsWwMomI3IdDTtlZzdjDD7SULa3a4AU0WjONZdYYwOWu3FL9W4z6v0aMoOFFz4HaobNTaJC2XnTl6600sRhfyJN95xSA3lfl7fHfrj1Zws5eb5NsLA8YG6gfl9KTbhT/f0eMfn/PHxTUpCHWutxciEcXaWHSrmM8P2R2y9aJEquPg2CO1s71qpysNhX6DU5BygCrC+LAlfPaHJfiHGrzE9MQ1q9z1v
 ROKZkNCv
 L9KXEeXwwyBnwFiwltr8yak7XeKHWGPMPAswPyt3hPNUMv9LSx5idF7ODuX7LAOnKsU1ei0xhEryijvxnFKW/r8IePN6EbnPU4wwMtmwl+NaATEcQ51OEJyVbUDzmL0IcXcmAhbDvhGvTeQ2Y3Ls2kpnzzda75fwGLsbBDCLKrYK67/JzojRa86yZXmGyJ2Qz1SLicMniWlhQcDFamzg4MQbxWm3xAW/LNn+ZmHO4JI0rbCuckPjCz657JehToP45yniIIBFssWvtbsHE8UVkBz4pZSUkhTcWS7G3z047j/ag0xqFpI9i5uxBqh61Q/trljJbxbz0984MDUrhJ2i4a5FUz7xsZcWRH8ta52MuphueHYkjiHc/hWd+e4bTBZS9J9Vjyvh1F0f+YKr88K/ZSMOFeqvka1gcv7CyXo6WeFY/swb+h23y9SBHLWHWtYjDsLi3RsorJZCDqTjBLGnO2HdA+SGK8HwYXlptoWvIJTk2T+Eh/woZ8H57q9v9GTGSLdvkHBN4J+LB7ns+CocC2CyWcpfzvQO/vlNH964nAh1C85/R8FPn5ROGTHQ290gLlreBiCic84Qin7pFC/Ds8iCQ498uVw9HTMKFq0IQR4sK4rNZOBK+bxATK05ZuDP08aeFIaSyrBzrNhDev3qhlWBsfy2TGrOEHkpSbLc2EllpGLZQVVyRbwN8jL/anjZbF/YDSQXfwV5M94x3C70lDCspB/Ru8EgqBSnsLKN+NHTgAXVZmTlv25BIyx63EtVylRoBvmBVunWrrAvxJ37ySObQxZxCOgsahjhaxcXeJqaW5CtGSVvii2lo0PmV4kHMz3G+xEQVQpOdIMdS7HJl/7Uq6o8NXJW4bO3d4Qe+iat58qQlfWOg3HwY4Y/mIXqySDbHVBVTnOaJkMgm6JT0BWPV0iVcHqJ8zTvSan2EnUq9Qj8Rbp/O9htf37YB1zByDQvcZDIq2JqHGubNBBL9a3mZq/mA
 vmphyzXr
 44DNk8U3S3WOK+cAJVGkyddHwAZThn6ahAEb8E/DxJbiblNd0BgBZeRdziEEFHyp2Qa7mbz5SOaFtjpGQag7ozpVXx0jvEvkhKrSbdECMt94E+SDUUkWnmdwlnjKJrsS9ALr6tlMooxrYglFmeNXA+5IORGnzcyIoPOhGB4PTf/jCCi65kxTQ5qoEMKMIKbaH/Gl4rx1wdyUks2cTAHFfOwXj/zJMUKphiqLtMqNz+bJrso1rH54Tx/Rc7ny7i2RdLG5dcWmJg3uJzjSQvThePijzAFZRYfUgBu9OosIwarHgbdQ6JVcP4AWPToXGXnELlIzNxiby74ZGQ2CN65z1QqqJ0RtW5p1OJ27SUWIqTgjAKXlfCnR0X/uTL+JB5r2VaIffDtosaThdQQCjVs1XoNEDKcs0Uq4lDTAh+a+OIx1hV2I7alwgzxWudCBJWkMVKuATkkbou7hEvoSsWY4OW5zWTyoOXj6czUg8dZGcwtjVmCiLgdiUjLx7Mdsn5uOF5/Kvg5LAhHudKFKKofdlG9QoWqiHC5kC3Sbahs5z/2UqSrFEqwWzzgdBf2Mxe3DCAU9B/znp7P7rzI3zc/HCMkfgWifv4wTF07AiPQNVw1+7ggb9bm9M8wb8XibbRdb8YWT/U18mqjAFwK/aunbA0X/m00KWWb7/8CDrsSimQ1gcfUFE2H/cXsxMB4CEPsoL9gjk4iywDoaxaPIsahjnO44PmLSOmAGMdYTX2s3aVcPvSWvcDHDmZdvSqt16TR8RRmK7kcnKw5HDkNflLhPJ+9gyoojnDe7ovDMvbPTbErzH8TnpEa26mmyrrPfHf31HB4SOwAfnEY9QsnApW4BSc2ErPZ6K0yYxQdZNddJtaR4nLiVo9h25C8g6PfnumyASxdI1KSq0z66m2/CMtohmBtygdhx9ofHqyLWusVpPy3STZmGrnWMGjCBBX8x5VwRUT399w9lZK6TkEzNoMCGn8qkSgdUg
 egMuQmT5
 4nZJeqbSIHHg4nLeNI1o2sC3TG5/8GkgY3u5QagC8oEj9q0uZMH95rx7iflbeTWVrLZ1ofM19PEtLs78379/YnU1CLz8kGxxgObxL4tMkfKX4EXRxY4uBLrOSP9Fu+MuvDMpEl6xBZ6P8QgTT+LG9Fjlxi1K29B3am6MPkpB6zeVTYMft4DZSnrOJANiublWE4AzQDJzLVL2CizE3E2rJQYbsJNDJr3k9+wcLArGYVoIKDuIRq0tFNP/rfoQ7M/+JwUFmBBmrbQE+lNtxEahQBH4caleRYkZExlD3odcHKkZtvoLtZo2Q7AEi7vhwJHt4kp31mssNZ4A8CINtI7xfySUaPD76TXOI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in coda with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/coda/dir.c   | 2 +-
 fs/coda/inode.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index b9e1674a8493e5578a04e4f8165ba30dc3b225b4..d6b9fc3cc1ca9d581a26de48971db60abcb26af4 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -533,7 +533,7 @@ int coda_revalidate_inode(struct inode *inode)
 		coda_vattr_to_iattr(inode, &attr);
 
 		if ((old_mode & S_IFMT) != (inode->i_mode & S_IFMT)) {
-			pr_warn("inode %" PRIino "u, fid %s changed type!\n",
+			pr_warn("inode %llu, fid %s changed type!\n",
 				inode->i_ino, coda_f2s(&(cii->c_fid)));
 		}
 
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index 964b9558cdb2e622eb9903974a10a6c5e561886e..40b43866e6a5496682453b227972e89e539960ff 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -257,7 +257,7 @@ static int coda_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto error;
 	} 
 
-	pr_info("%s: rootinode is %" PRIino "u dev %s\n",
+	pr_info("%s: rootinode is %llu dev %s\n",
 		__func__, root->i_ino, root->i_sb->s_id);
 	sb->s_root = d_make_root(root);
 	if (!sb->s_root) {

-- 
2.53.0


