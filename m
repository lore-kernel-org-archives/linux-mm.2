Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 461BFEF8FF8
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:35:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAEE26B00A6; Wed,  4 Mar 2026 10:35:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A62E16B00A8; Wed,  4 Mar 2026 10:35:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F0216B00A9; Wed,  4 Mar 2026 10:35:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B6566B00A6
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:35:42 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 484791A05F4
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:35:42 +0000 (UTC)
X-FDA: 84508780524.14.4F49EEA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7AF1C80009
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:35:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qHsmhUdT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772638540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r7PYcH5PEgTJj4j0t5wztO2/pndKvS2wi4agqPzOXHc=;
	b=WWzi9NIxOzIRLH5txHLdr6NLGzzm0O+ZlrSidObo6X1JV2u5e1NOV+cvOIRJIyDyFVr+P9
	aJK7hP8uTM/RCun0Pn0s853eL5ZEIknCsyql32/zG52ERqpUkIfe2/pWwlMAl7QGDi2PnE
	w0HO8RyTNQyk2ny/renbdSfwajLPgRE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qHsmhUdT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772638540; a=rsa-sha256;
	cv=none;
	b=toH5L0HIlsMvjpdGEKHkZQkXMY0sh/r//esa8Qo+sqD285PYPeh/3pLRUhmcp9VWi8K0Nl
	yx71D2aGmFY46dUVwvrNMJATvE7Nr7891PtD+OKqWbU+ib2qPuEiWRA9Bssl3FBrPD234+
	69oD3+DJtv25/RPaEQkbLQvBjdUjUBQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 98B6C61336;
	Wed,  4 Mar 2026 15:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA608C2BCB9;
	Wed,  4 Mar 2026 15:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772638539;
	bh=mpnoRGuSw4SxSNPrcDcSDKeNXRSk3u7CSRiG/C+Xaqk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=qHsmhUdTZEg0otM6XnSRS7XUYwA7DkiF4flLtn6zGmgl7LOE8x+wgKqPLQdCje94E
	 cs3Ow50P8lDeAaWzL3YhxMhuHtJReTgJNlk8vYUzIA1OM9LUIbRkhXWwQhZnHjvjSx
	 CJ4WTm9BXAJTGIPIfkfg1BL+SGRWiANnpoQp94ThtAdUpWTsiUWS/MbYCmrKutFniq
	 /m+wVNRwajSaEhhPd1di94QHPTrK7X6TJdrE4MYOZrUaZHEEGMDJ72ks3Ryt4zFFbr
	 kUiG8MlUylZTdTx5rpuxUMWRb6cd9DjAZL+nvLuwaZ47BoeeMiQXddBrsoCJlEQV6W
	 u5L2tZxqtQP2A==
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 04 Mar 2026 10:32:40 -0500
Subject: [PATCH v3 10/12] f2fs: widen trace event i_ino fields to u64
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260304-iino-u64-v3-10-2257ad83d372@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=26661; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=mpnoRGuSw4SxSNPrcDcSDKeNXRSk3u7CSRiG/C+Xaqk=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpqFCp3R7f0z3n5ksDE5hFJUJdGye36joy3Yf4I
 KsSBI7cCZCJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaahQqQAKCRAADmhBGVaC
 FS7CEADE2L+1fzD5iAXvQj9olGvcYBNB6aC1mGMz+YB8M2+4tmF1FglWesSDd4QNYRqzXiUlcSe
 fTFH0i+R4VhuSRY5aG4ezDeg+gUZaGVA5ZAclT9c2g31vH8OVlnca2oK3mfa6f1qEYVvRFHeix2
 s9bXUI/CRFw2b7miopS5AYxwaQ9H3enGRFsT/f8hOfjaPl6emE67Q9+xl/f4xsw36RNjqmpbpIT
 TpjZH4fT7Q7ZzkmvVUyHOBTt71sRlCjiNVVQuYk206qWgx7egP2xEhxDrUp96ktO5KJzgXbIWly
 ujGMdeUV1WvcK7UpBcnN0VHfVS6BNAx7U2BeRpPXH2KH/Eq9cnwxutQBA9LuZKUkyHS3j9n9bM/
 rY/0Q8EX8teTfCSLSyAWxpHXAcMZ0iNjQ0s5IRaXCD0gFD/rMwDzmU/bcj0UiFWkyzI82IdguGg
 b4mYyV0tNSRl0bhZKgHxTeCTrjnxeVtgzIUpoK89Bp6T7APZX/MYXje1CApSkFZ2ShHSnU7PHC+
 5G+9g00DAjFk7wgnjR4ATvKxmHBcyKxM6YQyZtSGVYVlJE0hRjPGr97ozjuruU2mpbpA1+dX9dD
 1lSbYabLwNFEiTB13s30ShzVkg56FwhsnD+IeQMPHQ8BfBDlVE6/jmOJSQQegefiuQjTuxgTC61
 Ri9HVxwcSBqZaFw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7AF1C80009
X-Stat-Signature: ymnpyiggfhjchjbbtimjjh9zqkip3scr
X-Rspam-User: 
X-HE-Tag: 1772638540-253459
X-HE-Meta: U2FsdGVkX180HyOpkELN4IE19dYuUhos17MxTvABi2hAO+rCeCJVRm+j/vh8lG3AWpWAa6V0J5nws/SU4F4jNYNGZ5Yx7GRoCUzPRAJjWZ1WzwqzMANjZ+0fSLgy41mDxTqhGHP9ztTxqiEqQkODwX4c0p/HZzMsVwsw2Jpgj/kI3otbG3/LCIIhsaEv/khWDQ2SLPZFYkY4DAy6MYFW9nBH90Gi4YJghn/iHFWhfuT4xm3eAHFWFT5zM2YV+WJSv4z1cJa2Ga58fRb/n8FGoPmViHWcx0yc2+WiGMr7Xx9pRV9XKPyOkeOvNuBeRcmwxCJke71BuFRjQoPN3L5ceeTpu3YfURqwerH2qsite20VAm0CSphKwgb+Altb+GzqSwHcu+L8RnIFIN8pDnlyZlbyHfZ988HWckLZLwi6VoiucrWSFLMcddGLGJ6VlRroi0cQRbyYDLOzQLO5TFxubo2iFHWDVISzbR36gbhl4WRuTWIpMvhT/XYQFsoeSVBgqtHTjDYoJ+DKFjdKqD+P58V6Wzz8VSs1CcMsOcD/tBluU0JT0Palb1XSkkW2gAsSwHbX1tBHDaZDGox2akJatuh779QKqvlJyHqObmQ4TcHzM26NJHji7X9VN1xPmwxPeU0s0Zrve3H7JKMfFFky4A7QCEBaCX0SYwwZUmfKCeztSkZBJFNu4rLr6tglsr9/YPaLp7P/54jcWX9axzYARc+ecBGqQVABEOYUp8UENQGOhuSGdRcYqBaN3/Wpn60WCJ47bKrD3vXxYhiM4FWmVlT5gW8IUELfPYO2EdfBbOSqAcNcmzY38PnVtZB3/yrrHj4gN8Y1ecSJcG4SypqddjoXovC2xk1UB2UtqJpcV4STLMYM7BE2n/8fWbVTNgBMmlcVHqzbsUKESMVQUkhk4zsAH5TcmkOddJc+Sf9r/tm8Tqvt2EpIGe0yNFfKwZqU5yXXTlwZzxYj7NIDmUh
 3V81ZQ1M
 VPxLpeDg8fhA6Jve10bZo87gckKHYnjalUbjgZghnbfCQqXk38EP52wGpW2Rjrrm5xuZuJfYWuVE+9zKs2Tei1v29vrd210fO9NiNslEgZTCpaTElxvOgVVxBF7DYTTEqPHjti8iPm2r3OCVhXM9sRK+sj6cGxvt0uu6wjkM396NAQIlNl6yAxZ87zsJl9L+pJgYgqwI4MaMt3Xk7bfXuKhho2BMKlyHqzB98klwDv3aJZriSSDUT1+pBj97uEoQNNHt4IEkNYI5Jo43oNBm/8djOzk+IGOLRvic/u49WYif5bNnE44MrwvXNJROQzzwnNt0OpCvuDAMQZsRiwKstbMG5999Po7YkyLxM9sNVafviPeSLCB5/WePE81x7miTwJDnqHuSCFKy9xkPEOUiZNkWAvuPty1vM9A8DmQMCnSxDZJCl9UnLC3OxpP7IIDm4aw/vR2uEdTUT77D+6l0EzsnpYJ8ywNaBvHcp7KVZgC8Qrnp55a7ABag6ytQ1fJm/7Y8XHn5eAifg8mhsrGoGXwIIax2IJVbmL67ProEUvAjLMh4hQg6jm4iynS1ABnG3y+ndYP+kiSRtgkPM9jdjuhwriPcAJPLTSU62q8BjcWPozMTffAon+vgYeiVG2APfsI9ACaDFRc7f0yb2eLXRKPAQn/B7Y23iWtPkayH4IhUVfHZCIWyJR5c/3CcUZFzMZw6XSAaXphRVpDgHXgdTSrVc8UE58k1iu4ghGYNvZLyMsEG0VPUddt46b2CbID6LIfrPW2cDSNd+zooEow3EWJM4AiKD+C8zWqg4JFcS8YDNNH/nFNRMCpn96++RNWOrmeXzMK2mFJdIH6JEhBMBm+StRCZe3Ixhl3ccM6GxDKDO9X5d9UkY+HEVGGn837QmBtU1nARNmFqEQsfyLg4f6ihdqyrmtcMR9UqlHo1Z8F7Sxlt7BZ4xhlN9a6Yc24MXXmeo0pHlorkfs8RKzi1YVw4ZykqI
 Dsf3YFrT
 CWPHXEiaTGej4sxSWsQvI0pG7cl2Amx4ovfvWj5/SII/9cceRLIPhM6alooYuKws6eT7eVVUWXkhEuSgSWxU27pcyZGL9X5S1GJIo6Hipdt/Gkp7/+WDASTpvc9WGYjVJQP8AG/N++NG+CQ6sxg/LujWf2fKDwfj22/kAjciNjA0P2lJ6ddeKfzaUbp0ppg1Zg9YFqF2KqbOIVoLc+XixEJ08qPyez82GKxuc/QOm3+ZF6uKrCGmSc8kARb4VDBzA8BCrUbRwaU1O5aZSJBDQ1p95G9f5CiKtSEJQN8S7bPSxxoWtu+jqpMOPDv7JYu0S14+4JnFGWd0eTpgxd27Yo1DXXsL/sASGR2dTzGm2jZdLPln2FXTCuEoRryzx523zwFGit0rW8CSR5vin60zveU7z2iKW5mu2Rego+XxpnzJllJqRVpjFbdgUR2Qa0xO4FB6GlDZ6yoD/7uxcTcmtB/KQC0DEbKtZPhbyw1UzYowQL68yMgnPCkpiCPSR+ZCdBJeuRKQ8IbtyaVUIhq5+T5rlV/G1sOvrUN7ZoV6daQpUnLbgUuYEKoxwTaC5tnEgpKj+Pd2eyQhfh7OezsK6+GCQZKnlOoQBVjXB/J/5Tkrwm6BTFKDzK9U8Z29Q3qhIRDYlI4ThWXTvqj331obbgGl0mWCYkLVzc0iiJMJ1Dd1ZXNd/RjF/UEk0OdyQ16V52qhuMIG4ONgFBjrQyvEAiKCoYaBXb+lHk3umXr6JeZbXZlFkWuEcus+tQFU3SsROKrXcgE70ySJL/ExhS3QucbFrlRjCKiYpwO/vq88hF/f711/4MErYuPKVkY+rzGnQ/R0JOnHJlQcTolkblrCr6JC9K+7/Pyd1SzonYcN2ZSxVq0U5HuDVAFEGISJ85gOWPCNNzCHSUOaLbXoYNatNx/02vTYFPoHs54dSGDS3x4YAT2sIVEWzdgj3fvv271HodrdVpagdrMGFQJDjtvN1uMGlrRom
 VRXcUuax
 AdYes14igeR3CGexNtrUk/LnKvaGwvKyAPPqccGdRcwoJORxgA7RhMp9y2n3ej3/Fj4WRPGmyRdTIlRP5GzOtOwdMZGHT4YLaB5KSvVU2SgYEqI6fOy8E4j80zqUIWNs0rgtE3PphzD6vvoi4tH7WnkOeSWxYtHM0iVCvlALuHk2fhnBZ+MvXLCp6IF3G/MD5PT84wIwmDHbATLsIM7Xj4me0cJ6SU3aArz1Fxb3FjNb5t7zeXDe1vHgo0mG2Slsfc6+P/hHeMebO/h+8l8Fg1LEYOc4Dnn7BpYre1Hmt2+Z/iQa3LckzfvduTQY7lKAZU3+rxngCJE/1Ece4/T7dXzDSgJgZMRf5WWwmo/e+nqAv7iODHrfIAIrxgx0Db3HRKnz7DAI0NNpKO0I6fNLqh5XukgsjosWuinwH/gGNmVo70dg41CIDpNXSpJBwH/Atxa7Irz4Qo3jGtulbfM8p+f0F5u+KO1brrpEOss9bM0DRSc/H/ArvQG8KMKzVKC0qHvcSYNzjewRJldXBebiNWPmm7/zUic0F5zlVY8V8DqF6+gQ1R64LuNvDxAWR+JljI4cMbDlHsLOaaLWKN+femRlW/7j+T1WCHURC8uIgwEoNJEg4Au//IFWs4nSQEo0TKVb8kkSbxASWO4b6YYpJ6R6C73lT5w58ztiN/WI0mYzjW8YGgj5ImSDpPnnoTqrTPO0dkdOnRlYc/oDBLtpPjaf1N4CF68pxtwh/V7KPFXrCQyHSMNcRqfdZf9Wl8svu5mnlXgGDCB5BgQlCyNKz8n3uQCmK8FhDNoD0tCv0B4iV/BsColm4v5nx9KmyGGelHdrPAgf339G8Kf6xRpOHKoIevEReo99bH9+IuSVTexUEbaaas4783ykJyUbiwybK/sFycnqFzl/Bw9iYfhg0TzE2P2BlUCS/MPXTtneF12b5k1ajm0xWmlWdKLhcXfGrocvoEAq3+ea6mplXVFePFyb9V1qd
 ZwImYeSw
 1rL2kw32rGFuz9oITK32dBnoMjY81mLyM3e97tOkU+R+8uU/3LNFTdaR/mDMsDQm1BUasE5s4IjdCPexRmEw/g/k4AyMLKTbXLxEABQCPA0y4Rtkn5UYk8SQN1B5AtZxwKz0QuW4eMejo9GOoy0ZfA9xaL28YtvIyy18wfTiU4RGDJAZY6zjKNiFaPgPHf86OYI9eyLiXpYurJiWXu4Stv681oO/lHdhfw8AaqD0y/yTSqjRHlzhfe7zzJfx1QUrKqAy5FUsdPITU/bVXh0O94vMLD4zYPWzZlwnfeyxKFm86T550i9dEnBBG1xae/E4aYjVhS4V6nApa5dtAOu54pco/1kxe9QBQ7cHFfeB84H27EE4dqfW8+j6xVUAdet/HBQg8s0LnO5XbBCvSygpNdnkiYBKR0xMM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In trace events, change __field(ino_t, ...) to __field(u64, ...)
and update TP_printk format strings to %llu/%llx to match the
widened field type.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/trace/events/f2fs.h | 242 ++++++++++++++++++++++----------------------
 1 file changed, 121 insertions(+), 121 deletions(-)

diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 9364e677556207ac041353a9eb2d5c2ee49b9dff..05a46908acd946cf7c016d99923403c04448c697 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -9,7 +9,7 @@
 #include <uapi/linux/f2fs.h>
 
 #define show_dev(dev)		MAJOR(dev), MINOR(dev)
-#define show_dev_ino(entry)	show_dev(entry->dev), (unsigned long)entry->ino
+#define show_dev_ino(entry)	show_dev(entry->dev), (unsigned long long)entry->ino
 
 TRACE_DEFINE_ENUM(NODE);
 TRACE_DEFINE_ENUM(DATA);
@@ -206,13 +206,13 @@ DECLARE_EVENT_CLASS(f2fs__inode,
 	TP_ARGS(inode),
 
 	TP_STRUCT__entry(
+		__field(u64,	ino)
+		__field(u64,	pino)
+		__field(loff_t,	size)
+		__field(blkcnt_t, blocks)
 		__field(dev_t,	dev)
-		__field(ino_t,	ino)
-		__field(ino_t,	pino)
 		__field(umode_t, mode)
-		__field(loff_t,	size)
 		__field(unsigned int, nlink)
-		__field(blkcnt_t, blocks)
 		__field(__u8,	advise)
 	),
 
@@ -227,10 +227,10 @@ DECLARE_EVENT_CLASS(f2fs__inode,
 		__entry->advise	= F2FS_I(inode)->i_advise;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, pino = %lu, i_mode = 0x%hx, "
+	TP_printk("dev = (%d,%d), ino = %llu, pino = %llu, i_mode = 0x%hx, "
 		"i_size = %lld, i_nlink = %u, i_blocks = %llu, i_advise = 0x%x",
 		show_dev_ino(__entry),
-		(unsigned long)__entry->pino,
+		__entry->pino,
 		__entry->mode,
 		__entry->size,
 		(unsigned int)__entry->nlink,
@@ -245,8 +245,8 @@ DECLARE_EVENT_CLASS(f2fs__inode_exit,
 	TP_ARGS(inode, ret),
 
 	TP_STRUCT__entry(
+		__field(u64,	ino)
 		__field(dev_t,	dev)
-		__field(ino_t,	ino)
 		__field(umode_t, mode)
 		__field(int,	ret)
 	),
@@ -258,7 +258,7 @@ DECLARE_EVENT_CLASS(f2fs__inode_exit,
 		__entry->ret	= ret;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, type: %s, mode = 0%o, ret = %d",
+	TP_printk("dev = (%d,%d), ino = %llu, type: %s, mode = 0%o, ret = %d",
 		show_dev_ino(__entry),
 		show_inode_type(__entry->mode & S_IFMT),
 		__entry->mode & S_ALL_PERM,
@@ -279,8 +279,8 @@ TRACE_EVENT(f2fs_sync_file_exit,
 	TP_ARGS(inode, cp_reason, datasync, ret),
 
 	TP_STRUCT__entry(
+		__field(u64,	ino)
 		__field(dev_t,	dev)
-		__field(ino_t,	ino)
 		__field(int,	cp_reason)
 		__field(int,	datasync)
 		__field(int,	ret)
@@ -294,7 +294,7 @@ TRACE_EVENT(f2fs_sync_file_exit,
 		__entry->ret		= ret;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, cp_reason: %s, "
+	TP_printk("dev = (%d,%d), ino = %llu, cp_reason: %s, "
 		"datasync = %d, ret = %d",
 		show_dev_ino(__entry),
 		show_fsync_cpreason(__entry->cp_reason),
@@ -361,10 +361,10 @@ TRACE_EVENT(f2fs_unlink_enter,
 	TP_ARGS(dir, dentry),
 
 	TP_STRUCT__entry(
-		__field(dev_t,	dev)
-		__field(ino_t,	ino)
+		__field(u64,	ino)
 		__field(loff_t,	size)
 		__field(blkcnt_t, blocks)
+		__field(dev_t,	dev)
 		__string(name,  dentry->d_name.name)
 	),
 
@@ -376,7 +376,7 @@ TRACE_EVENT(f2fs_unlink_enter,
 		__assign_str(name);
 	),
 
-	TP_printk("dev = (%d,%d), dir ino = %lu, i_size = %lld, "
+	TP_printk("dev = (%d,%d), dir ino = %llu, i_size = %lld, "
 		"i_blocks = %llu, name = %s",
 		show_dev_ino(__entry),
 		__entry->size,
@@ -412,8 +412,8 @@ TRACE_EVENT(f2fs_truncate_data_blocks_range,
 	TP_ARGS(inode, nid,  ofs, free),
 
 	TP_STRUCT__entry(
+		__field(u64,	ino)
 		__field(dev_t,	dev)
-		__field(ino_t,	ino)
 		__field(nid_t,	nid)
 		__field(unsigned int,	ofs)
 		__field(int,	free)
@@ -427,7 +427,7 @@ TRACE_EVENT(f2fs_truncate_data_blocks_range,
 		__entry->free	= free;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, nid = %u, offset = %u, freed = %d",
+	TP_printk("dev = (%d,%d), ino = %llu, nid = %u, offset = %u, freed = %d",
 		show_dev_ino(__entry),
 		(unsigned int)__entry->nid,
 		__entry->ofs,
@@ -441,11 +441,11 @@ DECLARE_EVENT_CLASS(f2fs__truncate_op,
 	TP_ARGS(inode, from),
 
 	TP_STRUCT__entry(
-		__field(dev_t,	dev)
-		__field(ino_t,	ino)
+		__field(u64,	ino)
 		__field(loff_t,	size)
 		__field(blkcnt_t, blocks)
 		__field(u64,	from)
+		__field(dev_t,	dev)
 	),
 
 	TP_fast_assign(
@@ -456,7 +456,7 @@ DECLARE_EVENT_CLASS(f2fs__truncate_op,
 		__entry->from	= from;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, i_size = %lld, i_blocks = %llu, "
+	TP_printk("dev = (%d,%d), ino = %llu, i_size = %lld, i_blocks = %llu, "
 		"start file offset = %llu",
 		show_dev_ino(__entry),
 		__entry->size,
@@ -499,8 +499,8 @@ DECLARE_EVENT_CLASS(f2fs__truncate_node,
 	TP_ARGS(inode, nid, blk_addr),
 
 	TP_STRUCT__entry(
+		__field(u64,	ino)
 		__field(dev_t,	dev)
-		__field(ino_t,	ino)
 		__field(nid_t,	nid)
 		__field(block_t,	blk_addr)
 	),
@@ -512,7 +512,7 @@ DECLARE_EVENT_CLASS(f2fs__truncate_node,
 		__entry->blk_addr	= blk_addr;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, nid = %u, block_address = 0x%llx",
+	TP_printk("dev = (%d,%d), ino = %llu, nid = %u, block_address = 0x%llx",
 		show_dev_ino(__entry),
 		(unsigned int)__entry->nid,
 		(unsigned long long)__entry->blk_addr)
@@ -546,8 +546,8 @@ TRACE_EVENT(f2fs_truncate_partial_nodes,
 	TP_ARGS(inode, nid, depth, err),
 
 	TP_STRUCT__entry(
+		__field(u64,	ino)
 		__field(dev_t,	dev)
-		__field(ino_t,	ino)
 		__array(nid_t,	nid, 3)
 		__field(int,	depth)
 		__field(int,	err)
@@ -563,7 +563,7 @@ TRACE_EVENT(f2fs_truncate_partial_nodes,
 		__entry->err	= err;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, "
+	TP_printk("dev = (%d,%d), ino = %llu, "
 		"nid[0] = %u, nid[1] = %u, nid[2] = %u, depth = %d, err = %d",
 		show_dev_ino(__entry),
 		(unsigned int)__entry->nid[0],
@@ -581,11 +581,11 @@ TRACE_EVENT(f2fs_file_write_iter,
 	TP_ARGS(inode, offset, length, ret),
 
 	TP_STRUCT__entry(
-		__field(dev_t,	dev)
-		__field(ino_t,	ino)
+		__field(u64,	ino)
 		__field(loff_t, offset)
 		__field(size_t, length)
 		__field(ssize_t, ret)
+		__field(dev_t,	dev)
 	),
 
 	TP_fast_assign(
@@ -596,7 +596,7 @@ TRACE_EVENT(f2fs_file_write_iter,
 		__entry->ret	= ret;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, "
+	TP_printk("dev = (%d,%d), ino = %llu, "
 		"offset = %lld, length = %zu, written(err) = %zd",
 		show_dev_ino(__entry),
 		__entry->offset,
@@ -611,11 +611,11 @@ TRACE_EVENT(f2fs_fadvise,
 	TP_ARGS(inode, offset, len, advice),
 
 	TP_STRUCT__entry(
-		__field(dev_t,	dev)
-		__field(ino_t,	ino)
+		__field(u64,	ino)
 		__field(loff_t, size)
 		__field(loff_t,	offset)
 		__field(loff_t,	len)
+		__field(dev_t,	dev)
 		__field(int,	advice)
 	),
 
@@ -628,7 +628,7 @@ TRACE_EVENT(f2fs_fadvise,
 		__entry->advice	= advice;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, i_size = %lld offset:%llu, len:%llu, advise:%d",
+	TP_printk("dev = (%d,%d), ino = %llu, i_size = %lld offset:%llu, len:%llu, advise:%d",
 		show_dev_ino(__entry),
 		(unsigned long long)__entry->size,
 		__entry->offset,
@@ -643,8 +643,8 @@ TRACE_EVENT(f2fs_map_blocks,
 	TP_ARGS(inode, map, flag, ret),
 
 	TP_STRUCT__entry(
+		__field(u64,	ino)
 		__field(dev_t,	dev)
-		__field(ino_t,	ino)
 		__field(block_t,	m_lblk)
 		__field(block_t,	m_pblk)
 		__field(unsigned int,	m_len)
@@ -670,7 +670,7 @@ TRACE_EVENT(f2fs_map_blocks,
 		__entry->ret		= ret;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, file offset = %llu, "
+	TP_printk("dev = (%d,%d), ino = %llu, file offset = %llu, "
 		"start blkaddr = 0x%llx, len = 0x%llx, flags = %u, "
 		"seg_type = %d, may_create = %d, multidevice = %d, "
 		"flag = %d, err = %d",
@@ -885,8 +885,8 @@ TRACE_EVENT(f2fs_lookup_start,
 	TP_ARGS(dir, dentry, flags),
 
 	TP_STRUCT__entry(
+		__field(u64,	ino)
 		__field(dev_t,	dev)
-		__field(ino_t,	ino)
 		__string(name,	dentry->d_name.name)
 		__field(unsigned int, flags)
 	),
@@ -898,7 +898,7 @@ TRACE_EVENT(f2fs_lookup_start,
 		__entry->flags	= flags;
 	),
 
-	TP_printk("dev = (%d,%d), pino = %lu, name:%s, flags:%u",
+	TP_printk("dev = (%d,%d), pino = %llu, name:%s, flags:%u",
 		show_dev_ino(__entry),
 		__get_str(name),
 		__entry->flags)
@@ -912,8 +912,8 @@ TRACE_EVENT(f2fs_lookup_end,
 	TP_ARGS(dir, dentry, ino, err),
 
 	TP_STRUCT__entry(
+		__field(u64,	ino)
 		__field(dev_t,	dev)
-		__field(ino_t,	ino)
 		__string(name,	dentry->d_name.name)
 		__field(nid_t,	cino)
 		__field(int,	err)
@@ -927,7 +927,7 @@ TRACE_EVENT(f2fs_lookup_end,
 		__entry->err	= err;
 	),
 
-	TP_printk("dev = (%d,%d), pino = %lu, name:%s, ino:%u, err:%d",
+	TP_printk("dev = (%d,%d), pino = %llu, name:%s, ino:%u, err:%d",
 		show_dev_ino(__entry),
 		__get_str(name),
 		__entry->cino,
@@ -943,10 +943,10 @@ TRACE_EVENT(f2fs_rename_start,
 	TP_ARGS(old_dir, old_dentry, new_dir, new_dentry, flags),
 
 	TP_STRUCT__entry(
+		__field(u64,		ino)
+		__field(u64,		new_pino)
 		__field(dev_t,		dev)
-		__field(ino_t,		ino)
 		__string(old_name,	old_dentry->d_name.name)
-		__field(ino_t,		new_pino)
 		__string(new_name,	new_dentry->d_name.name)
 		__field(unsigned int,	flags)
 	),
@@ -960,8 +960,8 @@ TRACE_EVENT(f2fs_rename_start,
 		__entry->flags		= flags;
 	),
 
-	TP_printk("dev = (%d,%d), old_dir = %lu, old_name: %s, "
-		"new_dir = %lu, new_name: %s, flags = %u",
+	TP_printk("dev = (%d,%d), old_dir = %llu, old_name: %s, "
+		"new_dir = %llu, new_name: %s, flags = %u",
 		show_dev_ino(__entry),
 		__get_str(old_name),
 		__entry->new_pino,
@@ -977,8 +977,8 @@ TRACE_EVENT(f2fs_rename_end,
 	TP_ARGS(old_dentry, new_dentry, flags, ret),
 
 	TP_STRUCT__entry(
+		__field(u64,		ino)
 		__field(dev_t,		dev)
-		__field(ino_t,		ino)
 		__string(old_name,	old_dentry->d_name.name)
 		__string(new_name,	new_dentry->d_name.name)
 		__field(unsigned int,	flags)
@@ -994,7 +994,7 @@ TRACE_EVENT(f2fs_rename_end,
 		__entry->ret		= ret;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, old_name: %s, "
+	TP_printk("dev = (%d,%d), ino = %llu, old_name: %s, "
 		"new_name: %s, flags = %u, ret = %d",
 		show_dev_ino(__entry),
 		__get_str(old_name),
@@ -1010,10 +1010,10 @@ TRACE_EVENT(f2fs_readdir,
 	TP_ARGS(dir, start_pos, end_pos, err),
 
 	TP_STRUCT__entry(
-		__field(dev_t,	dev)
-		__field(ino_t,	ino)
+		__field(u64,	ino)
 		__field(loff_t,	start)
 		__field(loff_t,	end)
+		__field(dev_t,	dev)
 		__field(int,	err)
 	),
 
@@ -1025,7 +1025,7 @@ TRACE_EVENT(f2fs_readdir,
 		__entry->err	= err;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, start_pos:%llu, end_pos:%llu, err:%d",
+	TP_printk("dev = (%d,%d), ino = %llu, start_pos:%llu, end_pos:%llu, err:%d",
 		show_dev_ino(__entry),
 		__entry->start,
 		__entry->end,
@@ -1040,13 +1040,13 @@ TRACE_EVENT(f2fs_fallocate,
 	TP_ARGS(inode, mode, offset, len, ret),
 
 	TP_STRUCT__entry(
-		__field(dev_t,	dev)
-		__field(ino_t,	ino)
-		__field(int,	mode)
+		__field(u64,	ino)
 		__field(loff_t,	offset)
 		__field(loff_t,	len)
 		__field(loff_t, size)
 		__field(blkcnt_t, blocks)
+		__field(dev_t,	dev)
+		__field(int,	mode)
 		__field(int,	ret)
 	),
 
@@ -1061,7 +1061,7 @@ TRACE_EVENT(f2fs_fallocate,
 		__entry->ret	= ret;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, mode = %x, offset = %lld, "
+	TP_printk("dev = (%d,%d), ino = %llu, mode = %x, offset = %lld, "
 		"len = %lld,  i_size = %lld, i_blocks = %llu, ret = %d",
 		show_dev_ino(__entry),
 		__entry->mode,
@@ -1079,12 +1079,12 @@ TRACE_EVENT(f2fs_direct_IO_enter,
 	TP_ARGS(inode, iocb, len, rw),
 
 	TP_STRUCT__entry(
-		__field(dev_t,	dev)
-		__field(ino_t,	ino)
+		__field(u64,	ino)
 		__field(loff_t,	ki_pos)
+		__field(unsigned long,	len)
+		__field(dev_t,	dev)
 		__field(int,	ki_flags)
 		__field(u16,	ki_ioprio)
-		__field(unsigned long,	len)
 		__field(int,	rw)
 	),
 
@@ -1098,7 +1098,7 @@ TRACE_EVENT(f2fs_direct_IO_enter,
 		__entry->rw		= rw;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu pos = %lld len = %lu ki_flags = %x ki_ioprio = %x rw = %d",
+	TP_printk("dev = (%d,%d), ino = %llu pos = %lld len = %lu ki_flags = %x ki_ioprio = %x rw = %d",
 		show_dev_ino(__entry),
 		__entry->ki_pos,
 		__entry->len,
@@ -1115,10 +1115,10 @@ TRACE_EVENT(f2fs_direct_IO_exit,
 	TP_ARGS(inode, offset, len, rw, ret),
 
 	TP_STRUCT__entry(
-		__field(dev_t,	dev)
-		__field(ino_t,	ino)
+		__field(u64,	ino)
 		__field(loff_t,	pos)
 		__field(unsigned long,	len)
+		__field(dev_t,	dev)
 		__field(int,	rw)
 		__field(int,	ret)
 	),
@@ -1132,7 +1132,7 @@ TRACE_EVENT(f2fs_direct_IO_exit,
 		__entry->ret	= ret;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu pos = %lld len = %lu "
+	TP_printk("dev = (%d,%d), ino = %llu pos = %lld len = %lu "
 		"rw = %d ret = %d",
 		show_dev_ino(__entry),
 		__entry->pos,
@@ -1176,9 +1176,9 @@ DECLARE_EVENT_CLASS(f2fs__submit_folio_bio,
 	TP_ARGS(folio, fio),
 
 	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(ino_t, ino)
+		__field(u64, ino)
 		__field(pgoff_t, index)
+		__field(dev_t, dev)
 		__field(block_t, old_blkaddr)
 		__field(block_t, new_blkaddr)
 		__field(enum req_op, op)
@@ -1199,7 +1199,7 @@ DECLARE_EVENT_CLASS(f2fs__submit_folio_bio,
 		__entry->type		= fio->type;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, folio_index = 0x%lx, "
+	TP_printk("dev = (%d,%d), ino = %llu, folio_index = 0x%lx, "
 		"oldaddr = 0x%llx, newaddr = 0x%llx, rw = %s(%s), type = %s_%s",
 		show_dev_ino(__entry),
 		(unsigned long)__entry->index,
@@ -1306,9 +1306,9 @@ TRACE_EVENT(f2fs_write_begin,
 	TP_ARGS(inode, pos, len),
 
 	TP_STRUCT__entry(
-		__field(dev_t,	dev)
-		__field(ino_t,	ino)
+		__field(u64,	ino)
 		__field(loff_t,	pos)
+		__field(dev_t,	dev)
 		__field(unsigned int, len)
 	),
 
@@ -1319,7 +1319,7 @@ TRACE_EVENT(f2fs_write_begin,
 		__entry->len	= len;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, pos = %llu, len = %u",
+	TP_printk("dev = (%d,%d), ino = %llu, pos = %llu, len = %u",
 		show_dev_ino(__entry),
 		(unsigned long long)__entry->pos,
 		__entry->len)
@@ -1333,9 +1333,9 @@ TRACE_EVENT(f2fs_write_end,
 	TP_ARGS(inode, pos, len, copied),
 
 	TP_STRUCT__entry(
-		__field(dev_t,	dev)
-		__field(ino_t,	ino)
+		__field(u64,	ino)
 		__field(loff_t,	pos)
+		__field(dev_t,	dev)
 		__field(unsigned int, len)
 		__field(unsigned int, copied)
 	),
@@ -1348,7 +1348,7 @@ TRACE_EVENT(f2fs_write_end,
 		__entry->copied	= copied;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, pos = %llu, len = %u, copied = %u",
+	TP_printk("dev = (%d,%d), ino = %llu, pos = %llu, len = %u, copied = %u",
 		show_dev_ino(__entry),
 		(unsigned long long)__entry->pos,
 		__entry->len,
@@ -1362,12 +1362,12 @@ DECLARE_EVENT_CLASS(f2fs__folio,
 	TP_ARGS(folio, type),
 
 	TP_STRUCT__entry(
+		__field(u64,	ino)
+		__field(pgoff_t, index)
+		__field(pgoff_t, nrpages)
 		__field(dev_t,	dev)
-		__field(ino_t,	ino)
 		__field(int, type)
 		__field(int, dir)
-		__field(pgoff_t, index)
-		__field(pgoff_t, nrpages)
 		__field(int, dirty)
 		__field(int, uptodate)
 	),
@@ -1383,7 +1383,7 @@ DECLARE_EVENT_CLASS(f2fs__folio,
 		__entry->uptodate = folio_test_uptodate(folio);
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, %s, %s, index = %lu, nr_pages = %lu, "
+	TP_printk("dev = (%d,%d), ino = %llu, %s, %s, index = %lu, nr_pages = %lu, "
 		"dirty = %d, uptodate = %d",
 		show_dev_ino(__entry),
 		show_block_type(__entry->type),
@@ -1437,10 +1437,10 @@ TRACE_EVENT(f2fs_replace_atomic_write_block,
 	TP_ARGS(inode, cow_inode, index, old_addr, new_addr, recovery),
 
 	TP_STRUCT__entry(
-		__field(dev_t,	dev)
-		__field(ino_t,	ino)
-		__field(ino_t,	cow_ino)
+		__field(u64,	ino)
+		__field(u64,	cow_ino)
 		__field(pgoff_t, index)
+		__field(dev_t,	dev)
 		__field(block_t, old_addr)
 		__field(block_t, new_addr)
 		__field(bool, recovery)
@@ -1456,7 +1456,7 @@ TRACE_EVENT(f2fs_replace_atomic_write_block,
 		__entry->recovery	= recovery;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, cow_ino = %lu, index = %lu, "
+	TP_printk("dev = (%d,%d), ino = %llu, cow_ino = %llu, index = %lu, "
 			"old_addr = 0x%llx, new_addr = 0x%llx, recovery = %d",
 		show_dev_ino(__entry),
 		__entry->cow_ino,
@@ -1474,10 +1474,10 @@ DECLARE_EVENT_CLASS(f2fs_mmap,
 	TP_ARGS(inode, index, flags, ret),
 
 	TP_STRUCT__entry(
-		__field(dev_t,	dev)
-		__field(ino_t,	ino)
+		__field(u64,	ino)
 		__field(pgoff_t, index)
 		__field(vm_flags_t, flags)
+		__field(dev_t,	dev)
 		__field(vm_fault_t, ret)
 	),
 
@@ -1489,7 +1489,7 @@ DECLARE_EVENT_CLASS(f2fs_mmap,
 		__entry->ret	= ret;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, index = %lu, flags: %s, ret: %s",
+	TP_printk("dev = (%d,%d), ino = %llu, index = %lu, flags: %s, ret: %s",
 		show_dev_ino(__entry),
 		(unsigned long)__entry->index,
 		__print_flags(__entry->flags, "|", FAULT_FLAG_TRACE),
@@ -1519,15 +1519,15 @@ TRACE_EVENT(f2fs_writepages,
 	TP_ARGS(inode, wbc, type),
 
 	TP_STRUCT__entry(
-		__field(dev_t,	dev)
-		__field(ino_t,	ino)
-		__field(int,	type)
-		__field(int,	dir)
-		__field(long,	nr_to_write)
-		__field(long,	pages_skipped)
+		__field(u64,	ino)
 		__field(loff_t,	range_start)
 		__field(loff_t,	range_end)
+		__field(long,	nr_to_write)
+		__field(long,	pages_skipped)
 		__field(pgoff_t, writeback_index)
+		__field(dev_t,	dev)
+		__field(int,	type)
+		__field(int,	dir)
 		__field(int,	sync_mode)
 		__field(char,	for_kupdate)
 		__field(char,	for_background)
@@ -1554,7 +1554,7 @@ TRACE_EVENT(f2fs_writepages,
 		__entry->for_sync	= wbc->for_sync;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, %s, %s, nr_to_write %ld, "
+	TP_printk("dev = (%d,%d), ino = %llu, %s, %s, nr_to_write %ld, "
 		"skipped %ld, start %lld, end %lld, wb_idx %lu, sync_mode %d, "
 		"kupdate %u background %u tagged %u cyclic %u sync %u",
 		show_dev_ino(__entry),
@@ -1580,9 +1580,9 @@ TRACE_EVENT(f2fs_readpages,
 	TP_ARGS(inode, start, nrpage),
 
 	TP_STRUCT__entry(
-		__field(dev_t,	dev)
-		__field(ino_t,	ino)
+		__field(u64,	ino)
 		__field(pgoff_t,	start)
+		__field(dev_t,	dev)
 		__field(unsigned int,	nrpage)
 	),
 
@@ -1593,7 +1593,7 @@ TRACE_EVENT(f2fs_readpages,
 		__entry->nrpage	= nrpage;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, start = %lu nrpage = %u",
+	TP_printk("dev = (%d,%d), ino = %llu, start = %lu nrpage = %u",
 		show_dev_ino(__entry),
 		(unsigned long)__entry->start,
 		__entry->nrpage)
@@ -1738,8 +1738,8 @@ TRACE_EVENT(f2fs_lookup_extent_tree_start,
 	TP_ARGS(inode, pgofs, type),
 
 	TP_STRUCT__entry(
+		__field(u64,	ino)
 		__field(dev_t,	dev)
-		__field(ino_t,	ino)
 		__field(unsigned int, pgofs)
 		__field(enum extent_type, type)
 	),
@@ -1751,7 +1751,7 @@ TRACE_EVENT(f2fs_lookup_extent_tree_start,
 		__entry->type = type;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, pgofs = %u, type = %s",
+	TP_printk("dev = (%d,%d), ino = %llu, pgofs = %u, type = %s",
 		show_dev_ino(__entry),
 		__entry->pgofs,
 		show_extent_type(__entry->type))
@@ -1767,8 +1767,8 @@ TRACE_EVENT_CONDITION(f2fs_lookup_read_extent_tree_end,
 	TP_CONDITION(ei),
 
 	TP_STRUCT__entry(
+		__field(u64,	ino)
 		__field(dev_t,	dev)
-		__field(ino_t,	ino)
 		__field(unsigned int, pgofs)
 		__field(unsigned int, fofs)
 		__field(unsigned int, len)
@@ -1784,7 +1784,7 @@ TRACE_EVENT_CONDITION(f2fs_lookup_read_extent_tree_end,
 		__entry->blk = ei->blk;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, pgofs = %u, "
+	TP_printk("dev = (%d,%d), ino = %llu, pgofs = %u, "
 		"read_ext_info(fofs: %u, len: %u, blk: %u)",
 		show_dev_ino(__entry),
 		__entry->pgofs,
@@ -1803,13 +1803,13 @@ TRACE_EVENT_CONDITION(f2fs_lookup_age_extent_tree_end,
 	TP_CONDITION(ei),
 
 	TP_STRUCT__entry(
+		__field(u64,	ino)
+		__field(unsigned long long, age)
+		__field(unsigned long long, blocks)
 		__field(dev_t,	dev)
-		__field(ino_t,	ino)
 		__field(unsigned int, pgofs)
 		__field(unsigned int, fofs)
 		__field(unsigned int, len)
-		__field(unsigned long long, age)
-		__field(unsigned long long, blocks)
 	),
 
 	TP_fast_assign(
@@ -1822,7 +1822,7 @@ TRACE_EVENT_CONDITION(f2fs_lookup_age_extent_tree_end,
 		__entry->blocks = ei->last_blocks;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, pgofs = %u, "
+	TP_printk("dev = (%d,%d), ino = %llu, pgofs = %u, "
 		"age_ext_info(fofs: %u, len: %u, age: %llu, blocks: %llu)",
 		show_dev_ino(__entry),
 		__entry->pgofs,
@@ -1841,8 +1841,8 @@ TRACE_EVENT(f2fs_update_read_extent_tree_range,
 	TP_ARGS(inode, pgofs, len, blkaddr, c_len),
 
 	TP_STRUCT__entry(
+		__field(u64,	ino)
 		__field(dev_t,	dev)
-		__field(ino_t,	ino)
 		__field(unsigned int, pgofs)
 		__field(u32, blk)
 		__field(unsigned int, len)
@@ -1858,7 +1858,7 @@ TRACE_EVENT(f2fs_update_read_extent_tree_range,
 		__entry->c_len = c_len;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, pgofs = %u, "
+	TP_printk("dev = (%d,%d), ino = %llu, pgofs = %u, "
 				"len = %u, blkaddr = %u, c_len = %u",
 		show_dev_ino(__entry),
 		__entry->pgofs,
@@ -1876,12 +1876,12 @@ TRACE_EVENT(f2fs_update_age_extent_tree_range,
 	TP_ARGS(inode, pgofs, len, age, last_blks),
 
 	TP_STRUCT__entry(
+		__field(u64,	ino)
+		__field(unsigned long long, age)
+		__field(unsigned long long, blocks)
 		__field(dev_t,	dev)
-		__field(ino_t,	ino)
 		__field(unsigned int, pgofs)
 		__field(unsigned int, len)
-		__field(unsigned long long, age)
-		__field(unsigned long long, blocks)
 	),
 
 	TP_fast_assign(
@@ -1893,7 +1893,7 @@ TRACE_EVENT(f2fs_update_age_extent_tree_range,
 		__entry->blocks = last_blks;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, pgofs = %u, "
+	TP_printk("dev = (%d,%d), ino = %llu, pgofs = %u, "
 				"len = %u, age = %llu, blocks = %llu",
 		show_dev_ino(__entry),
 		__entry->pgofs,
@@ -1938,8 +1938,8 @@ TRACE_EVENT(f2fs_destroy_extent_tree,
 	TP_ARGS(inode, node_cnt, type),
 
 	TP_STRUCT__entry(
+		__field(u64,	ino)
 		__field(dev_t,	dev)
-		__field(ino_t,	ino)
 		__field(unsigned int, node_cnt)
 		__field(enum extent_type, type)
 	),
@@ -1951,7 +1951,7 @@ TRACE_EVENT(f2fs_destroy_extent_tree,
 		__entry->type = type;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, destroyed: node_cnt = %u, type = %s",
+	TP_printk("dev = (%d,%d), ino = %llu, destroyed: node_cnt = %u, type = %s",
 		show_dev_ino(__entry),
 		__entry->node_cnt,
 		show_extent_type(__entry->type))
@@ -2027,9 +2027,9 @@ DECLARE_EVENT_CLASS(f2fs_zip_start,
 	TP_ARGS(inode, cluster_idx, cluster_size, algtype),
 
 	TP_STRUCT__entry(
-		__field(dev_t,	dev)
-		__field(ino_t,	ino)
+		__field(u64,	ino)
 		__field(pgoff_t, idx)
+		__field(dev_t,	dev)
 		__field(unsigned int, size)
 		__field(unsigned int, algtype)
 	),
@@ -2042,7 +2042,7 @@ DECLARE_EVENT_CLASS(f2fs_zip_start,
 		__entry->algtype = algtype;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, cluster_idx:%lu, "
+	TP_printk("dev = (%d,%d), ino = %llu, cluster_idx:%lu, "
 		"cluster_size = %u, algorithm = %s",
 		show_dev_ino(__entry),
 		__entry->idx,
@@ -2058,9 +2058,9 @@ DECLARE_EVENT_CLASS(f2fs_zip_end,
 	TP_ARGS(inode, cluster_idx, compressed_size, ret),
 
 	TP_STRUCT__entry(
-		__field(dev_t,	dev)
-		__field(ino_t,	ino)
+		__field(u64,	ino)
 		__field(pgoff_t, idx)
+		__field(dev_t,	dev)
 		__field(unsigned int, size)
 		__field(unsigned int, ret)
 	),
@@ -2073,7 +2073,7 @@ DECLARE_EVENT_CLASS(f2fs_zip_end,
 		__entry->ret = ret;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, cluster_idx:%lu, "
+	TP_printk("dev = (%d,%d), ino = %llu, cluster_idx:%lu, "
 		"compressed_size = %u, ret = %d",
 		show_dev_ino(__entry),
 		__entry->idx,
@@ -2311,10 +2311,10 @@ TRACE_EVENT(f2fs_bmap,
 	TP_ARGS(inode, lblock, pblock),
 
 	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(ino_t, ino)
+		__field(u64, ino)
 		__field(sector_t, lblock)
 		__field(sector_t, pblock)
+		__field(dev_t, dev)
 	),
 
 	TP_fast_assign(
@@ -2324,7 +2324,7 @@ TRACE_EVENT(f2fs_bmap,
 		__entry->pblock		= pblock;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, lblock:%lld, pblock:%lld",
+	TP_printk("dev = (%d,%d), ino = %llu, lblock:%lld, pblock:%lld",
 		show_dev_ino(__entry),
 		(unsigned long long)__entry->lblock,
 		(unsigned long long)__entry->pblock)
@@ -2338,11 +2338,11 @@ TRACE_EVENT(f2fs_fiemap,
 	TP_ARGS(inode, lblock, pblock, len, flags, ret),
 
 	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(ino_t, ino)
+		__field(u64, ino)
 		__field(sector_t, lblock)
 		__field(sector_t, pblock)
 		__field(unsigned long long, len)
+		__field(dev_t, dev)
 		__field(unsigned int, flags)
 		__field(int, ret)
 	),
@@ -2357,7 +2357,7 @@ TRACE_EVENT(f2fs_fiemap,
 		__entry->ret		= ret;
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, lblock:%lld, pblock:%lld, "
+	TP_printk("dev = (%d,%d), ino = %llu, lblock:%lld, pblock:%lld, "
 		"len:%llu, flags:%u, ret:%d",
 		show_dev_ino(__entry),
 		(unsigned long long)__entry->lblock,
@@ -2375,13 +2375,13 @@ DECLARE_EVENT_CLASS(f2fs__rw_start,
 	TP_ARGS(inode, offset, bytes, pid, pathname, command),
 
 	TP_STRUCT__entry(
-		__string(pathbuf, pathname)
+		__field(u64, ino)
 		__field(loff_t, offset)
-		__field(int, bytes)
 		__field(loff_t, i_size)
+		__string(pathbuf, pathname)
 		__string(cmdline, command)
 		__field(pid_t, pid)
-		__field(ino_t, ino)
+		__field(int, bytes)
 	),
 
 	TP_fast_assign(
@@ -2402,10 +2402,10 @@ DECLARE_EVENT_CLASS(f2fs__rw_start,
 	),
 
 	TP_printk("entry_name %s, offset %llu, bytes %d, cmdline %s,"
-		" pid %d, i_size %llu, ino %lu",
+		" pid %d, i_size %llu, ino %llu",
 		__get_str(pathbuf), __entry->offset, __entry->bytes,
 		__get_str(cmdline), __entry->pid, __entry->i_size,
-		(unsigned long) __entry->ino)
+		__entry->ino)
 );
 
 DECLARE_EVENT_CLASS(f2fs__rw_end,
@@ -2415,7 +2415,7 @@ DECLARE_EVENT_CLASS(f2fs__rw_end,
 	TP_ARGS(inode, offset, bytes),
 
 	TP_STRUCT__entry(
-		__field(ino_t,	ino)
+		__field(u64,	ino)
 		__field(loff_t,	offset)
 		__field(int,	bytes)
 	),
@@ -2426,8 +2426,8 @@ DECLARE_EVENT_CLASS(f2fs__rw_end,
 		__entry->bytes		= bytes;
 	),
 
-	TP_printk("ino %lu, offset %llu, bytes %d",
-		(unsigned long) __entry->ino,
+	TP_printk("ino %llu, offset %llu, bytes %d",
+		__entry->ino,
 		__entry->offset, __entry->bytes)
 );
 

-- 
2.53.0


