Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99539EF8FF7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:35:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 029F56B00A0; Wed,  4 Mar 2026 10:35:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F368E6B00A2; Wed,  4 Mar 2026 10:35:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE1676B00A3; Wed,  4 Mar 2026 10:35:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDFBB6B00A0
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:35:12 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A3D38C095
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:35:12 +0000 (UTC)
X-FDA: 84508779264.19.4B92018
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id BE378140012
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:35:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GLqXtRWR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772638510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ba0WjkbVl+u70nJy1pVaDIDtGgCQxi73wA0Sd0wSBhc=;
	b=BmeFTQFpXnNUB0X6D7+7NqtwQZrJHWfF/l8B4wmRt8fbNsU3azeiZp0dX7HRJLpfLghYRU
	oMi23Zn5k4FEhlDC7CH5KiQFsSTPqH09AQRWpHfoblQ/HeR4a5Wt9ug79nruhwmtcueqa5
	N+RlLJMcgRAf3GD/JMLgwiSCUkl6mH8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772638510; a=rsa-sha256;
	cv=none;
	b=zUB866Uaof/FxK+r2p6Lp8TLh2zlp93avrxOw5YR5u0cM/IbcNqEfIy7KC6ajzt7H64pO+
	uvUXPkkVLiWloxoWUO85UTBNBv7mRwQK87OJvXXQbCTatmu7utAn50nfQIe9RMOAb2Dwwl
	hKqRdk6jW1neoWbeEy+IrE2wZ6Nu6og=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GLqXtRWR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F42D6013C;
	Wed,  4 Mar 2026 15:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD8FC2BC87;
	Wed,  4 Mar 2026 15:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772638509;
	bh=7d5s8zYlgF/lxn2hSCCS8u0A6JkMvE6BfZrHhmcvv5o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=GLqXtRWRoNGJMHyWHLnOCXoLNoJzQHRY0AoEFBcmoW64rpUj7ZyZCM9KJ/B0DgxVD
	 17JeaFzCkGPtsvUioGWmvuvjxzTvJMvyTguwsoQp1FaVb1MDrPhUO5AFxuvqSGz5c5
	 QHbGiBoVjK26AW83s0nID9TgWfVPUUDfXG28sDAga2gA8/g9qWAExQ8umMkKSzMDPl
	 B6SGChdWm6qLXlzZcr8sbu7f/at+eCVg/ihmE6/JQuSgpde8xyfR91+lTqFLv/qypJ
	 BTVxAR0eysCb+ZW/m1tD2fOaD1AMOqY9HrXP2GfSEylCczJOTgSx+VwDI42FOofYat
	 gMae4pALY03zw==
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 04 Mar 2026 10:32:38 -0500
Subject: [PATCH v3 08/12] zonefs: widen trace event i_ino fields to u64
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260304-iino-u64-v3-8-2257ad83d372@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2889; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=7d5s8zYlgF/lxn2hSCCS8u0A6JkMvE6BfZrHhmcvv5o=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpqFCottPu4Q2RkcxpmSAyx9ymCIr5X9BEkN4+F
 0P0g0I3eSCJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaahQqAAKCRAADmhBGVaC
 FewYEADXed5E+znEwLtt1AWpw+ToLxRLATu62cx3IoQgoCJuiJjq76Cp6823onBDOze65FZSF+d
 AkG7fRU1gEZ/5nIIocoPB9UjM+vzFjXjkkb5YTkavZ3HQGbqqkjO9bCYO+dObg26lGea1Atp5EV
 2lszMCSj6/EPPuOqxuRnWhrnheM9mnCkVjL1wIS3SJkxeHK2vUe4jfSoZxLc1mBrJxLmbwzjN8y
 W+YWFyC29h3awuxhGKFipNUK+GTfhfeLjymfG/Pbw7egYbaVFh4ngD8s5jXaWsD0XRquSCiMl6N
 woeRRbNNPZAk6PSe9JRQIXWGYlZDXjQDPSHAuqw3vLzpVllfAHF/Za5tDLU2AMP31Q9w4OoJQuX
 Zpl0FDPSRnGmCOPqkq+yDVb7noBJizXqhgmIEOIEaFiey6L5r0gFw40LzK6lIujysO/Fe7vDeqi
 E8m2QvN/Ud197wFfqq6NupfCSaRFYIn5CVL/A5VfV5temGtwePGoRNBtBSHUVlCDWMAAoQpCao+
 Qeoy/PNxAI808YAgv9W4XlxBnrVuF2dZOfhmuqO6je9IZ5WKFHsHb6eZ8Jl++JaYTTxdhsf5ELp
 yRB4lZFxQy+YmE8jzG7vBq2z4+YmDmOqn38M5n/QE7MkXsrfx8+9arTsaLhEFf1q9CIeODA7rjQ
 JoJg9VvMd1uBfXQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BE378140012
X-Stat-Signature: bbr7rmdbc898ig1hrduiyhk1zbg5z1tr
X-Rspam-User: 
X-HE-Tag: 1772638510-827010
X-HE-Meta: U2FsdGVkX197mOH776w/le0hvvDmEyoHkH7HlWCCrpjBrDfqrQHFjPsncuEaZtoM1oDu1yTru/r3bW5gL5RgS+9VucojBWxvwf65Ki6vlkWLsJ1sRaSw8RriXMmTkPqH6sm7y8PPHRt8o0JkQFDXT39b3uQRzkfaAPflC6fTKEZQZg4c/Go49qZ4c2WKZEs9aCy3Mz0S2Wtf845amMUZ9rNewKUX/EjNbd9LyT2Y8mSf/kMyJpYNhwnOxErDuzYX2i98Dl20DNFYqWbB22Syp+OgLOp3YKDzBpvLi6PNe1m6rnFmt5dQNE9Eih+HvvcdmCUkkfaG2Uh8d6TCOyeDA8JftpL14DBCIojvYlBeLGqHJbe5AQwF4yrIggwPERw8hLMzuHI3D6pXZiEgfXpEldytVPTKpoBiPi4RbblP56oi3QbB2i2tsCXOfHQCqFFQv10hsw88Y+5oCiCLtfqA1Vr6ARrV1Ft6jnMf9K4irQWjEvm7Bc8xQSDMnnXqRv+CPR860usB/ljE6nN+kc0WfMhiwQmJ8ZtPAPNiWxU/K2TZ7gtjVLcaa7sz2vX4GBQNFE9wfi8ekdYQ1fX2KG8GaFZozDt+YamfMbmJD+YsgcAonTLjTnzSc0h9I5TFj3GhLyxLMWh1SSFEz1VVENeOdApL3hF0e4IG8GLiSzDe9s53PjNzbyD4X1wuSPt0dAkMD8PyUXeF2vw4ZkVovWQVTuiM1VDjH//NglJZaMkbzfaEqVS7WewX+kD3lhx2+7ynQahU/QETwHQucvTnzRXZhqNNRaZYaocQSJ3ENywaiQ+Cf9tX3FMMY0wqUkZwIaW4rh1Fg/9fouTKn++JtYH4bFTEouGJKkZ7EBzvlFhD1TH1jS4CuLcBn4KCYmGro1jAVRkIXDUPQfHMbdQhA0mLCbUFCwnh1lBiAOJg4KmJ8PamFgCNh5gljSskqhIREMcTxnnEtGv1956EKZ5DABW
 0KhXZ9bf
 gamEpWd57Wdifgu8/jtQCDR8iEpSRpPzJbYkaRvru6Plz8S25CeeuP1SB1a/PwC1Esrb2Nz5/vJtyvPmJD1jHWCRkWvDsBiv1vVwqBXPnNBZRxVzcBS8UW02wnzkavhV5JGve4Sb3rStUyBiZ5O1rx8sLRzqUM1F0G7WecptFeLuNx+vMZQyHM/6+LStCbyVkksLm84ZitqXBFMweK33FWz9+qPFIysAflk4hNAy+wpeuVwHEV/NogBmtqlvncmyL8udsR9+lKWEaLKZ4tLzukbcrPipevR6W8Pyz5qr9be+7rSUm6BG0Pbh4q/G/YzeTPbv+ze7Gvx4zCcB/6oLpHvVzMTRaxrs7UHTsAkboMTSnW/Y7iw+zjbGxebAuKLmNVfv0VWg/FdNKOSKDirx7AIk1sQPt3ig+QJotT9W3THl3VFtU0GOzyXJ2z+sPt7V/uSMhS9lefpxmWsafD7IENOZTtnv4GMAhHJG3o7pWqkh90K7VtQwBlR4lUSImUxDAWQ6kbVjE/pDZIOPN30UJ8oVgJOAZRlLVUPsMjWkuIRbojQAJrifSj9DcNlb62Kka6fouReSVBpyYnLJclrJ8ZQZeJ7Y8IycSSJOLXwfaK2TmLG66IsivWMw/8nG9czUORvZL47OLQ5sjd3XAKC2nLbjYodaD+vOAC6Zg1Rp+XpJ+e9/P4uIrt8C9kNBnXlq/SdHUyY1LgX32OWhGHJzLzWn90HvYmpngpLSJ9cC3wdAsvktF4j64kfTrPqtTZfarDX8HGqaK84hUkV0v1mzBmxrOyKy9pBihaInrFV1ox5y25gRyCxqQvwbl9Nsft6t4SDuIv9xk4hfQi80aVhvrqaZFLR+zTpfgs/V/CDMQnpQqA4qp5CYz6bXkLDTdpWED+8BMvyHyDpv3AQEM/zw4Ezh1WxrZ7zhC+aiHLzmlXUmPrHbw28oMLLJrae+K1ih5hCeQAOU5BNtwTGoENeNO1j4wpLdp
 mjJTXKex
 jyX/X7qiDaiIed5m80K3PwVJuxQHhuME5VyNLSjEGi5HbmGQdhHsF0BHHXYl+oddoTmOYl+nuSEClhzef/7mccE59H4G8DUq6Z1t386+SfjeWf436Ie/eHLuxGDsGuIG9uEBP17k2kbFWnzmbW5mmy3oaORba/oLIyjRu6iEHIClq6uHYzVPbe7NBOnTvVQUzRs0ok/4auZTscedFIrd34rz6dXHjV3cZ7XazSfoNfdiSoC9QUWL2E+uvPWci/MEEcp7RZZTJPsq5/32LhRr/UyzurlTnL42ljOs6cPXzN9NXx/BOGiLckbUtuVl78Gx4BDID4DEy/RCJ4kmMqid9ByQ8ILyV2aN3gQEY1olAW+iRSN3RXeWn095S0O5uq6ylcadVTVzBM/0fW7SIeN/VClLIyGiEDtb0MIJwMSQImmBuKZ7Lub7fdbysuODwX589EGv2xAqlIOUrDBpnU4GwlI7aekXn22ehJ32Dj8x4ppq+pAAtXeQ3e3Ox7tTDwXgPQq5UOpO3KM085Hy9vSuTDRdrKx2etVI6EgdTMoXKeSpje2vUJd37iIqy/IB5jSU36E7McdrMT1/zssFEghG1D+6dGT5sy/pHaWWQcnJLSy3Go8+cRiuRZ0kt/p6PuB+aLsE41SPRzeyitBwVEHuNG4Vjm4NoKQbwmwU98dzm3lcRKR3up/ZaguyiV+xcFik+nvN+aLhOa8pDZVkFtChNSb1gmpOczh0FbrdzykyYp1hQO6kWG0jaOAUgbYkkh0sGpVLmZwKh8sjZntpr0ps9sxAAuXh9b7Z8hF5UGC+dmFtmRxeSyvQMt3L7dVenRNo7mz23a8eiCRzQrm/YoL6muiNHE7PN3jqNzOukMRA5ADqncWf/i2eMKZBzSXHe7m2/F4UZoeWMtkUaR0RvcF4uTYXIS3pfb02lwvfQeVZwhJjttr6cL50bOuFxX5D1kUCJlM5MwZ268/kzDmJZgb8Vyxn85nEQ
 KbqJ71eW
 g/yietR9hx6PUPfyFdT/ONmi+3MIYxByAZ9T1XBe6RJ2GRUngrm3cYL6eAz30uewYDttdGfmkjDaemUkZtitK1wtNnfbZ2s8vEKmmUq0FgjKNjfxFupfB3JgQAQkLWjCyAs2U1X4D6B0UqkSgsIgCh5EwQnwg6gzBb6PZjEZGnyjjgHefst8y0NRe8KDiFmqwfYmz47hNBMYCZyHGJ9OpJuI829p6dOu15T0TciOGzfpy+fhoVO6/XbsHob6yG6q7Zo/gMWAmxZw9OdkZq+aXqoOHtX8aRHQLnha+AJkh8OBseVapU70tsuL9574F5Eep+riMmRT1uwLEYIDAxziZgsd0xXCuyAjcN9sNJz+8/Ja8+5v5lLMMQpUtqj+UXOTeuUvovWp/VlsFLgBX79+BXkOFB+Ow3RDBSHXKJjVl280m0A3SlnpNf0KppQkVmTeDMZqWCYa6XOoRiDxa1HbLh8QeaaMC82t3sF7xDYnCvhLFjUuYcW4CPFiXi1CJR3rSW/iFieJKRk8yqb/obecmRr7KA4hCMu3YtqBMd1KwoM/SKy/hKuMYaQT0xOvo6GSc8UP2VhokX1D1vj4IRk4+UMbosHBInS2zqRBGqwcdF/yoc9UUENlXhM/fTuP+Wh9lhloSvBMp9VomzH/8svHDdFbpYr4hwiifNoTOivxzVoinEnI8ys2bPzhVP22EWIYynlagz5G5OT8kyMD+tL/Wg5zUEAhpzVdTCdlupbusoV/nrwET0beW1/hQG++cSkYCdHjdKGMJX+9TaDm3u8UP/kiBrO3RKp4VM/ZkxWdbC1GdOICJjU26/H2IshQ5o482w4XNtcJujLKUgQ4+/iEomcOzISmxzdTPKl/KUVG1YSJFnWVrlHJSyhaksCA9GRUOHQGjjC8LZpxk5PHbGKn+5Ru/LWBVY85KtIptnTh3tj/5t3gj/zAOPVz+3FtV2TnavFBDSoxhhloQgeZIK15VO7Nb+1XR
 kb6MzKQu
 ht2fgpOWYzCAti0/XUJ+Zl79S24OVWDizhZrybAhL2NG5TLZpw3r/T8RbF9sLu1a+E0O+BnCsJwHedQXfeZtEoUkAIPh51e3eg4orOEesHeepPhIYcySbbg89fG5kLQvzoYpfmE5tWT1PcHpuCc9pL6fuH5TsyuuFlpua4UrMA58k2yfEDLkNS67iALLtJnug9Kydb472WVbyCpOGo1o64mcS6ktdtR4My9KEH2bw9Gm6rDWmDkD22cgExY4TIEhG8ZCVHR5BoZITUIdnovsmRBrBxE6uEDzYTrQ0Zd/2dgydFhcXb4PIQ/Buj8I/ppGaeya75yRk/3FLrQMnDy0trhWIeo2TupoKTFJhf5QUHTzg6XJphCApO5dRcr6GD2KdWEGCCg7txL8REedBhq+1fF+KgIBq8rts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update zonefs trace event definitions to use u64 instead of
ino_t/unsigned long for inode number fields.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/zonefs/trace.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/zonefs/trace.h b/fs/zonefs/trace.h
index 9969db3a9c7dc9e212ed04a7c256e02fbe73880e..7315a72ca2f6fb8ac34f7aaa9f7f24224bb5e801 100644
--- a/fs/zonefs/trace.h
+++ b/fs/zonefs/trace.h
@@ -25,7 +25,7 @@ TRACE_EVENT(zonefs_zone_mgmt,
 	    TP_ARGS(sb, z, op),
 	    TP_STRUCT__entry(
 			     __field(dev_t, dev)
-			     __field(ino_t, ino)
+			     __field(u64, ino)
 			     __field(enum req_op, op)
 			     __field(sector_t, sector)
 			     __field(sector_t, nr_sectors)
@@ -38,8 +38,8 @@ TRACE_EVENT(zonefs_zone_mgmt,
 			   __entry->sector = z->z_sector;
 			   __entry->nr_sectors = z->z_size >> SECTOR_SHIFT;
 	    ),
-	    TP_printk("bdev=(%d,%d), ino=%lu op=%s, sector=%llu, nr_sectors=%llu",
-		      show_dev(__entry->dev), (unsigned long)__entry->ino,
+	    TP_printk("bdev=(%d,%d), ino=%llu op=%s, sector=%llu, nr_sectors=%llu",
+		      show_dev(__entry->dev), __entry->ino,
 		      blk_op_str(__entry->op), __entry->sector,
 		      __entry->nr_sectors
 	    )
@@ -50,7 +50,7 @@ TRACE_EVENT(zonefs_file_dio_append,
 	    TP_ARGS(inode, size, ret),
 	    TP_STRUCT__entry(
 			     __field(dev_t, dev)
-			     __field(ino_t, ino)
+			     __field(u64, ino)
 			     __field(sector_t, sector)
 			     __field(ssize_t, size)
 			     __field(loff_t, wpoffset)
@@ -65,8 +65,8 @@ TRACE_EVENT(zonefs_file_dio_append,
 				zonefs_inode_zone(inode)->z_wpoffset;
 			   __entry->ret = ret;
 	    ),
-	    TP_printk("bdev=(%d, %d), ino=%lu, sector=%llu, size=%zu, wpoffset=%llu, ret=%zu",
-		      show_dev(__entry->dev), (unsigned long)__entry->ino,
+	    TP_printk("bdev=(%d, %d), ino=%llu, sector=%llu, size=%zu, wpoffset=%llu, ret=%zu",
+		      show_dev(__entry->dev), __entry->ino,
 		      __entry->sector, __entry->size, __entry->wpoffset,
 		      __entry->ret
 	    )
@@ -77,7 +77,7 @@ TRACE_EVENT(zonefs_iomap_begin,
 	    TP_ARGS(inode, iomap),
 	    TP_STRUCT__entry(
 			     __field(dev_t, dev)
-			     __field(ino_t, ino)
+			     __field(u64, ino)
 			     __field(u64, addr)
 			     __field(loff_t, offset)
 			     __field(u64, length)
@@ -89,8 +89,8 @@ TRACE_EVENT(zonefs_iomap_begin,
 			   __entry->offset = iomap->offset;
 			   __entry->length = iomap->length;
 	    ),
-	    TP_printk("bdev=(%d,%d), ino=%lu, addr=%llu, offset=%llu, length=%llu",
-		      show_dev(__entry->dev), (unsigned long)__entry->ino,
+	    TP_printk("bdev=(%d,%d), ino=%llu, addr=%llu, offset=%llu, length=%llu",
+		      show_dev(__entry->dev), __entry->ino,
 		      __entry->addr, __entry->offset, __entry->length
 	    )
 );

-- 
2.53.0


