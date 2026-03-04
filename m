Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 210AEEF8FF8
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 859596B0093; Wed,  4 Mar 2026 10:34:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 822C96B0098; Wed,  4 Mar 2026 10:34:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3D16B0099; Wed,  4 Mar 2026 10:34:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54F166B0093
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:34:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F416F13B506
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:34:28 +0000 (UTC)
X-FDA: 84508777458.08.8A9EE43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 15B55A0009
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:34:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jFK2PcIe;
	spf=pass (imf15.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772638467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rlcm1Ck9JnINzPL8BWKWZYnbW8UUCCqVy2lM4Vz0tdc=;
	b=bxd87C9qpp84cmdJ04I346/ZqApUsTNoQN3xxTWqjGTpPhdn98nMfR//arifp+t79oVSZ1
	E4GAOiVUTw30I+Pikdb7bVew08jUXtN8RbNOMTMYCq1lWl19fZyf6sVctKXKc7ijPLKvIN
	1EAG6hOa74ScivY0CwOydT6ujm13Eh8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jFK2PcIe;
	spf=pass (imf15.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772638467; a=rsa-sha256;
	cv=none;
	b=ypGsN7JFxhdGnd2ID6Ab2UmUB5g5C+P2GBuyiPtL43uv52jaRH578g+2Ae4+qUqDWYMa0R
	cDp6caV0fo+jCGhV1DOCg5y5LqsEK/FPn+s3rdzPkx0xsWYb9QUZHq1ZECAZvZDDYz+HOE
	XNtX1B8fPgveJi6OTMrPPGoI3p3ljXA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2247E43D3D;
	Wed,  4 Mar 2026 15:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A489C4CEF7;
	Wed,  4 Mar 2026 15:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772638466;
	bh=E8lUv5ZV2tqm8DGQreXuazegXs/r+kDs1hpPJsZQq40=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=jFK2PcIetv8IU3o5qyCGZS8yfnEmKyxt05WjYIOxfomVoagmee2rH4HxfQD9wSM3R
	 XDE47kliJh8fJ1GmIPCIf38EzINurHOm24dnur01wBv0CCr1MWzm3/UodlkvfTl+Yd
	 JLMs271d68CxBnznBOsuLhuPOJwK9CijGynxxvMr1DzYo8xT5nP7xaQ2iLOo4WiuUG
	 GEyM1CYIXrez1FqWZdIBGAw55waYwPTzAZuTjz6fFeNpFv2z57PKbJiWA5N664Iul3
	 470sy//ovrFOSVbXWzgcyyueQFN/gRyPXwy3QnmUm0TS05tzEJt1sV/d2jk6nebaeT
	 jGXW/jOg/+gkA==
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 04 Mar 2026 10:32:35 -0500
Subject: [PATCH v3 05/12] cachefiles: widen trace event i_ino fields to u64
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260304-iino-u64-v3-5-2257ad83d372@kernel.org>
References: <20260304-iino-u64-v3-0-2257ad83d372@kernel.org>
In-Reply-To: <20260304-iino-u64-v3-0-2257ad83d372@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Dan Williams <dan.j.williams@intel.com>, Eric Biggers <ebiggers@kernel.org>, 
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2680; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=E8lUv5ZV2tqm8DGQreXuazegXs/r+kDs1hpPJsZQq40=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpqFCnboYZuamhSjxxOsGNVe4KX4qKQ8jKhPQAS
 et+MGnh3xKJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaahQpwAKCRAADmhBGVaC
 FRS2EACPETzruvNWJd9CA77sY2+/NqsP8aQJDqjrVWDpD5gBPLEZMyv3hyr/iNfrnRD1YKrR1ve
 4Bp6qUnc70Gv3PJekeMaKteUwnvKLrYaFXHRfvMW2vQxG5a+VN/ZfQqOwIFb3IxqbdLtOpKMxZZ
 /nnZ6Id/RD1dBISUcfqJTDZQwqvLPraPCMVjfhS5Z15yRDQTXFk0l2cyZa3kOeSxpU0Qt/Loa9e
 fm21nW5KV0Z9vgm0xbit0/5OpEvQBfYL5yZOHWrsoUEPkXCJ3wu7N1wj1S44XYAoq5AeWVxS3xz
 l7eoPz5B0Qp9t6jNKdY7aLDlC09gqABVVTWzUWlZUbEIWbovOTLNAUsKOccgpleXonxEw92EPbL
 m2OfW8fnr646fipgkmuQ69xHnJ5wuhHORGrYgEZLI8A7qqUclHy9LW3JS97sBkHmyw9GhpV55y7
 F5PviCDiQQW6zNjygQG9Izn8+BIBcU6M1XHl1CDUYf6IIYD4lNI3ufLroIBzwn35/AqoUL8y40k
 khU0NCP3PKt0SD7h7daLvk8VNw0uV5si6Yr52CxWSyuNFYKUidRb1nAZ0fK4IbbrqSOYCWDg1vp
 rT2AhnlH6FhofgKbRzcTMifS2MvB0zCxCHXSQnAz9y00Dt1w9OHgXTnfFmfC5KheLo20gBiPwab
 2AYYSsJVCX8y4jQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: qdwbka9bz9cz656sz4p6hn4cudskd9m6
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 15B55A0009
X-HE-Tag: 1772638466-153443
X-HE-Meta: U2FsdGVkX19DnP6YX272TkBoCSv6Oh88Jdekc/jZNJrAP85GLZQTJn6uZmVJL8213v0a6gI2PboFlztGnHD9yfe+9AS3uj3Py2Ofz93hC12wxHtuLQ4ndz35hsJ/n9CBAq5kSZrNBayBcvdHTptyOb1r+xvmsE47AHyqvFnFimI3pxxIf7NZodNGTGcRCw/jZlvV4lDU0FOFxnU1dcqHALyrgc8uX+Qz/2QL7lp90+iW/IdioziLt41amHkrPOynzv8P/DB2upejwACIYgFXQFNXzS5vW8FXLP6U3GuNcSboPEwW8fezZ4FAC5rCLUEooTT839RZnQnLCUcmnQ+DIEo4Qh4G6QtzrLtSq1XHX+3j52bh4OT2dAKiS24eBO1UvttJB2lP3wZZYME2gcZh3PtirEQL7s0RNRBLQJ5IHaR6jUXBFL7+YC8h2WwIzpQF8kt8zhiDgProJZ0hdM6s1CM6iG32KM5+UkZw0lxhka2Te8l3r0kpwZpUrS2M9l1jFhB7SGx7SDakN291gru5kIuh1BL/UnCMPiVyAEMEp1myVvxJW+KxmVAVZyxu52kXeU1wIznSPTxyt1FsKof/OaPv18aH+LGp+eFp+/woJ97RMgD8AcFzUCGLBtkbONaLfdU1L5Am6rGnh0KfB0ljvOWuRrNGPXrJvBQm706HawosMzvwMpBggSfEA3pDGAHqoeK/Gnxa1YV6XG/HfEYjQkpSZYrdwK2k9HkHlnNGW72KoCMXWZqpk5XVxWfb4JFAutAdN2bCiTsUM6lNoTenlNYJs22LET4Z4zZ0Fxm7qp26/ZieMWHB1FfFHfHsenrbK6P+5ymifO1S3ZyISESxIWZYv8MmmOfRWjFQdNY5tSoMcQfRPl/ZiFLJDE40ZeamHQ7wpMJK06HYpD/TlUTHbrXCrof1WuwP2ViIzzWIN0/XaxFq0ahxeRuOfc/OzY+UZ/dSPNuljMjkZPeWxHA
 2R4lcrcs
 tzlB9MBukJD+kaZGJR65tmyaUpSLZx1uyVvvl8Sj5zbT8TNrbloy33eL4E31EHoNTpdyyhsYmX4AOmY+E8eLA1vz4jc9F+kfCM94yBmY9UPqulleTzvXz2gi8A3EetmNW+IbTKY9TLx/J+xG/g912LwcUpanoR3EVPH6A8YOBN8gZQXyg0+yojYUy/O3jcGZuYhROxE9qVGIoMmIAB5P9yHx9P18kuOjaG+8QHOePAy6yhBLhLbfhYMibbADXC0VgslYbl39S8cxjmrRLCLeyp1hHIJDJWHYY7xi1zI4++7ffHAaiRYQQaKRUiR/muuUo6h526yEclEkn1Jdu2pcAapFPEvr9QfEXXNkV8Dty688CxpUTTT75yCzxW3/AClUy26iWE/z0/fdHe4oaeYUsaLylyHNWeDxZr+d3vawu1eiv/xWXoChRSnfuUv2gNzHtrBmGNVfBYpCxyDyNCKDdLPdAHu+suFf0n3mQQbViDyhboyalI0yrG9xO+jlwakZWrx1VMno9h7upi4sRyOuCNQYmzhwzFYndZDiXKv1doJD6HCAvnGe1TpqGZfbeVefYvh+/QPZHwQabvO6huETI5n9n1ZKMU3rMoXzUnodBU8ATDs0u0i5KXnBuz6tp1CXitw4s243K94eoUZbPWDjwc8TMty+r+tzOAoGMPLo4C2xhLuN1YD71duvzBgEYP5B2K3YyakhEqJD14D56ytooxVlWerqgjOLAJu9hBirkHRzkXb/uKiyzyA0+EsZ+DBo3hvtAhoike+9nq7Gc0/9L42N7mHgz2VdIGzianzZvX9et4DqTQx1MDqI88fxGNqKQ8riFFd0W4dpSoWaA+Rnuv3ZNDu+MyVa1HEq7eX7yFxrhjmesBxNuSi1zDz608hQ4MWC1x8Ta3xGqI14+2v6d9Ti9EoyKLqXiGafgQ1ebc2/XsE6rXWuhcy3NMt5TkJzD1MyPbO1IN0l3P1DttgugcOmD2MNL
 h9BCky1E
 zwd0BSsx/SOba98MbtRjOKdjPa24Ga47n9r+dL9NlbpABZjWWXgjd3ZcpKkzAfCOPdov5j6Pi7tSF1eMBSqgqNGAl+alqu4zbZTp3lkpB+2+T3C7E6Zb3ACiZGwzO8PADnHdDWlqCoZpIbXWlytU3V2q8rsrh5FHfrQboR8VWPEbU7+jwqq4A8f8OCu1oDekVy91U1uTMvAcz1W9CxueUMwBfGcO9+ZI2aqU6MwryPvY2UASpaSMRJBTaQxz73WLsFWCXxKMnlOUKv5bgfajrOtWMzKTVSAW0UNTHuY1viIJk/hDLZRk8CVnvBPq+AjhgYhySc1ZKEAxt5LRDD2Gv53DuVdubkpuI6iTOnm1MUNXySjTNgRlV8mUiKI5JDZMoEHOWjUgA3b3dlPnb8rAZE6jfVI8I8BOOMMtOLPxLEy3WUyIFXkE6ET8NNxMYkf4P4lgtPs1IQI5kqv2crNlN5aKYgxJSwgx2qSoZ4e7zldATGFIH5CVNIYim/0w4sX11DLimR+nSqyWF85jBcm9bEt/7W8O9rGYPMSmQYAT6AH7qULQ8ZeDfFp6s3+N7JRy7VU3Jp6cC5lYobn6qJC8BZgeDbRswNrCpkRNwJhM+cC6bSMC5hGskD7QIUqgoDxYGqbtMlyIJoX67z0BklujN/EjOTigBkBvPXrhPdD/22oKhdRSo09MH0ZelUhHYQxJIjTuDonNdbIMIbhCHheURS+LQW/K1IrBxGPAXydvfCI5h4b1Q/HXRhO7X7YBuDw5cC+LE5IxsVJlj1RdJXcI1Nnm6UbWOs30rZkrNe6MinB6RWn74lLz3RH+sU9/8djLpr+laKAqrUEXYHNaA93vhV9xvBMo3IP3IFWjeS5P23EOzal55N0Q6/WYW49Hxew1NShvOBJOdl6JK0C5n7HCEeQsLQ8CvDQwcRX/DRvQsyT0wFm1RoJbfTDrwFLjmV4/8PEZqjNvGEXDud+6a/0iOn/CARbw4
 1aIK5S3C
 lTwf/0uh/buXKBIQ3IPcnOhxkgtIqH+t5Bmr1+WQYDigRvEj+6B8XBdcx/YHwf1w2uR7FZzAEJz0KOnFeZRJCkSHxvspFNkKWeKbSkCI59NvMW6Afm9LZpe4OBLWbiOJ+LG+R/xSwlx7VR8U8O5gnTbO0jWbr6kpsZFv9R+eORiVrUXRGScwic9ttLu7B8YBtvusmk0y33YEK8fxkvy5Atah+/FXJ4NzViRgqNyrFz7x2cLG4BknvfEYl/da8CtTlC3nbEDHKDdLv4KW7PnZUVGHJqMqPT4Y+6pT1mtPLdmbsU7on73usrE8PniUU/01YISxbRwUz2B06nhwkIbDfTUMnpK7qccJLXfrBJoBVNxIFrMnvVw4xsgqqHpQCjRq+xrLpV9pa+3msSiMi3Lg09vFHTzmjoQv5iRJJ0SO75lh5U/arKETdfO2HJsgmaEnvzxE8AvpiHW7WzFnW0VjjqKPGybw8f9aH5OXxDR1c4sL/Gmswsl2DuoGGzpeHNSFvAGy2BR77t+RrLFju1+5L+VYcof0aYNFucAYxhNRu97ipK4tK9B55fVhfWsMp4cwnXEuA4vwXdW7idgkgJ7gu99XKTdQKqVFFX7B/E8DsJ5eh60RDxVTeg5o47gmiH3hWgLJnJmTrK8MtcYPAwBLkdYAFBC+xf2zC0O97tOQVN6DkOb4uvmOENY0CR6ujmfrc/RRpMUatciBIEvVhkLJCYZ9W5NqbMpqY96ae9WOxiy2WUB6LYHxE+WAFySUsEfGevLukiyyZ+/xIU1c3ZDtS3jqovCWIt84wxYtGEsL0L4Q5hMsb29vAiE9QRK4Jlt5oaGGk/+ktZd0i2AKjniD8gtK7lo4IAowNCGevtSX8PMw6bm0L3HwTa1wbTw1vBs9RouWR7HCJl6Jtts+qPM6phXacxP1qH6j7lrEsJy689j6V+/uJpGFzWg6YFZUm541917ijJ1ShhP/ebExS7s9WxbPSJFDi
 +sqONgO/
 N5pI1RHSDS62gRIpHd0hAhaIckP+L8PPq5rLgQpNfg/OZA5UFiEGB09YRhs4aLiBEWzsopZ4SFxVW2/cx9I5pGAv4SDOPswS6Bn4MaLyYurkq3DPERIvxYMta8An+bYaDoDxT44W3PkRfq3HAwy/l8gUN2XQ5lT8AnrRC7XeVR1x/Z07z9dnrwlCZRNFt/qShTU0AN3tVuR1HW7NT/wvz8HRDm0oXHC2GAMIg1bQaqGNaoiK1wF8Y6FzTJVAahbFpPxWcNWnXUr42xQRillfKkK19klQptMpmVajreI6QMWfcGAqxx4/Wj1NRC4Q5fQhvKv4sw6NWfR4IMvqTmVZUC/lMC/UhEY3pL0LYFV6YoGlWV/NqDv/PY/gLpssnWTeW+X8BXR/k8NcNjOj/QEjmwwgU693/oWXU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update cachefiles trace event definitions to use u64 instead of
ino_t/unsigned long for inode number fields.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/trace/events/cachefiles.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/trace/events/cachefiles.h b/include/trace/events/cachefiles.h
index a743b2a35ea7001447b3e05d41539cb88013bc7f..6e3b1424eea4dc9e414dd9d1439339132d516339 100644
--- a/include/trace/events/cachefiles.h
+++ b/include/trace/events/cachefiles.h
@@ -249,10 +249,10 @@ TRACE_EVENT(cachefiles_lookup,
 	    TP_ARGS(obj, dir, de),
 
 	    TP_STRUCT__entry(
+		    __field(u64,			dino)
+		    __field(u64,			ino)
 		    __field(unsigned int,		obj)
 		    __field(short,			error)
-		    __field(unsigned long,		dino)
-		    __field(unsigned long,		ino)
 			     ),
 
 	    TP_fast_assign(
@@ -263,7 +263,7 @@ TRACE_EVENT(cachefiles_lookup,
 		    __entry->error	= IS_ERR(de) ? PTR_ERR(de) : 0;
 			   ),
 
-	    TP_printk("o=%08x dB=%lx B=%lx e=%d",
+	    TP_printk("o=%08x dB=%llx B=%llx e=%d",
 		      __entry->obj, __entry->dino, __entry->ino, __entry->error)
 	    );
 
@@ -578,8 +578,8 @@ TRACE_EVENT(cachefiles_mark_active,
 
 	    /* Note that obj may be NULL */
 	    TP_STRUCT__entry(
+		    __field(u64,			inode)
 		    __field(unsigned int,		obj)
-		    __field(ino_t,			inode)
 			     ),
 
 	    TP_fast_assign(
@@ -587,7 +587,7 @@ TRACE_EVENT(cachefiles_mark_active,
 		    __entry->inode	= inode->i_ino;
 			   ),
 
-	    TP_printk("o=%08x B=%lx",
+	    TP_printk("o=%08x B=%llx",
 		      __entry->obj, __entry->inode)
 	    );
 
@@ -599,8 +599,8 @@ TRACE_EVENT(cachefiles_mark_failed,
 
 	    /* Note that obj may be NULL */
 	    TP_STRUCT__entry(
+		    __field(u64,			inode)
 		    __field(unsigned int,		obj)
-		    __field(ino_t,			inode)
 			     ),
 
 	    TP_fast_assign(
@@ -608,7 +608,7 @@ TRACE_EVENT(cachefiles_mark_failed,
 		    __entry->inode	= inode->i_ino;
 			   ),
 
-	    TP_printk("o=%08x B=%lx",
+	    TP_printk("o=%08x B=%llx",
 		      __entry->obj, __entry->inode)
 	    );
 
@@ -620,8 +620,8 @@ TRACE_EVENT(cachefiles_mark_inactive,
 
 	    /* Note that obj may be NULL */
 	    TP_STRUCT__entry(
+		    __field(u64,			inode)
 		    __field(unsigned int,		obj)
-		    __field(ino_t,			inode)
 			     ),
 
 	    TP_fast_assign(
@@ -629,7 +629,7 @@ TRACE_EVENT(cachefiles_mark_inactive,
 		    __entry->inode	= inode->i_ino;
 			   ),
 
-	    TP_printk("o=%08x B=%lx",
+	    TP_printk("o=%08x B=%llx",
 		      __entry->obj, __entry->inode)
 	    );
 

-- 
2.53.0


