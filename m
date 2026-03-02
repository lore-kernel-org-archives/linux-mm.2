Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FD91EB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:42:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C4C86B0117; Mon,  2 Mar 2026 15:42:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87BFA6B0119; Mon,  2 Mar 2026 15:42:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71D266B011A; Mon,  2 Mar 2026 15:42:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8AB6B0117
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:42:18 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 335A6C1851
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:42:18 +0000 (UTC)
X-FDA: 84502295556.17.31D18D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6A997A0013
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:42:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wl3ZbsRo;
	spf=pass (imf25.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bebzL13HRFEkINuOWG80QoMF43gGmt1DpQOC6Pr8kRI=;
	b=KSLkkBHczxcB8VfKEDG3eddWrlGsizQbha5R7/ADmdpXdoe9X8j7K4GmgRNg292b1iPyvQ
	/o5ZtVrpzY4GSt2iPLWDiGc8+vzUBbmhzUnzfFUuzRM2No0n/FRxZ1PF3AzboqXJg+nWqd
	BwfRVnitoocXH5/RxkAfPp5vQAu0h9E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wl3ZbsRo;
	spf=pass (imf25.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484136; a=rsa-sha256;
	cv=none;
	b=G5qd6CcuPpGy1xvehScd5Z5an1/CbTvJu1wjqTWyr5KuZjW6NuEmeksSCAP4tzurOoFPFD
	DNG8kQQvJPviVDhFWi6NT+1YBygicQuukn1N3i3I8QpfLvbBBZhuuUo57L4ByiW+jK5L1k
	FS6HyGLy8VjnvHMvCX2zCC6uxTKmM0M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DB1C6014B;
	Mon,  2 Mar 2026 20:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16308C2BCB5;
	Mon,  2 Mar 2026 20:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484135;
	bh=IP0YnTMmc9wTva3If3PO5tp5gSAQtRQKE7/wVmuSLLQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Wl3ZbsRoM5ck011FqVwHfbEfS01iBSt7CO7RtdGO2+yf/iDB2k9mXVzwvuvKP/RbD
	 65Za+ri9YFWQ5n+Nlk1Wk074vKzdzOCFYNCzlkd21sNnsb9tWMCKP5xWyPi0akAEoX
	 o8vGIzAlgR3myF5DydGb01m6Bts6T5I1OmvPM+sB/HUWFmb5Au6VHF6sfXzcJ7lu55
	 /ORzjazWm2jO7eZ62N58RLj1sfGSe56gMsLUSkLeg5Nm0KWw61Ko7QZfKeY1fUiKPZ
	 m4mgbOnkPSJQIq4/Po68uALqmPh6s9gjo2eifqr8K+IJf3LM9tiwQ6YK3mHRZMPdwA
	 A9FBcg8AxIJ4g==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:56 -0500
Subject: [PATCH v2 072/110] autofs: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-72-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=842; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=IP0YnTMmc9wTva3If3PO5tp5gSAQtRQKE7/wVmuSLLQ=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfICNF/UZGT1Q3WO+utk0heRN7L1CmCvfRQAt
 Ye2Y505rTaJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyAgAKCRAADmhBGVaC
 FVRFD/4z4mQKsRgosXPgDFBMNhvKIbWjzUs5k/gAI5tx8dkoA5mKp/zvjH3Dt2E4vhNtVCyeD+f
 R4PBRwI/UFSnuWBQrVkXONs3F8uICDg3NSYei4nj027qe1ZLsVO/E4tOQAy6rnQEWJWDUq6rsxR
 97XAGNxBs3rOnV4iROyGI+PgGB8NlrxvVf9ONpkI6xznfQF8iOIbNrUAqeWBjJTpPPqufbD08p7
 vsxtNlCWUSHeITywpYQGDGFw+Epe0wA95dAVoDgL9RxabwElp1P/LXrlMWfj+wTeuK1gV9lcNub
 Rd7uaF8S3/rPiJCFX2goqPu3aribuI+jJjx8MZonjphgqEi487jUtl77GLFrfpLYqyrNx/yMR5S
 OKsZNFhkkQSJRs0NZ+gKOrCOiWQl5wbATtkHug0yAOgtiZwkKrg0Ck990Q0Ci4Rlu/f7miB6RJ7
 QJoO5FfKdgefLuOoNUzsWsasFdU99HjRlujO7yy6reAUVyphx6tQeBjjDObagO8eGWNjFXlykwz
 MpugOnr1x6JFiDryK9TRsIUxDqdv0mFR33J1Z2F8quwVrL3ipqMVzoGJ/k7Beg/mRFBRgcppyja
 1py86RJKbv3x0AAAj0bS4JhXpmA9r/X9IWiGP/+q38ddzXhYcT/qsiUTzA3T5f2RrCL8WK3hU9h
 vM+412QReJseiwQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6A997A0013
X-Stat-Signature: 5aynhydoprra1pj8wdahakr5yzgty8rh
X-Rspam-User: 
X-HE-Tag: 1772484136-444421
X-HE-Meta: U2FsdGVkX19ykS+g84Tj1+a+Dm6dGB580uckDJteXwky30dq6CaGcGB2KiD+jpSnx5ag03Bw4/hhE7tVH5k3cPtYvO8VcJYF6pPMZUM368uV0Vqc/RWqNAPlbNlmuBL+5z0Cg+4kfyBEfx/f/zxh0Opdif0cvum48VymEZ3cU1ecHaw6j+eN94KH2mfAHXR+tAn5Y5UPnHRuU2AlTZt8u/vs2E9ctj5WPpzFXMUe+D6rLlN4sUU63wjdz1mkXd1QhbKPbGYssqJc8CgDeO3mkVAAiJrrFzhqNifWgCN4miHjYGlpp1R7kSyeQ/wcIH5CiOPJmFj/anHhOkODI1Mka9oVqkg+N4giKsiMv29nRv5x/0UChZONYGzPTIzpzVpD/cK19eRFNDpuvyI4Ak9eHfRQQvfp43Lb1Zbn4jBiky45mt9cM/1qtiElPAgbwM6WTSuGj2qmmdbjww1U8+o810tMVEEmf74neloNIPWJvX2WWTdNZy1lyNKU0qxPeMd3PUEd9VU2jmCthRRJoM88a6P4oOWyyxE3eQXQV+7ESYzRNRJi/K5fqQHWJINYOHgHCqZ3LoM0rSvHydDdofPBz3TuoXjgfU7zlmByS5Gfn0sfGswTGjLpoE4r6Ma6C6wpAEfRDR3kvr/bIdsUYHGgLLKiuzlQRBfz9hA4pYQjRX4uvV3t3+vRuylXsVLh0k5U1eEzPMI9C79A3GUoHvgEiaqwApat6N/P5Y9PqorDQ3ynow9wfMjDYFXQ/lONhcVAcE9zcyjlzfSL7jUnOP8s6IZ3oDkjN63GTsL2tXoy+TY5MMkhDQlqFTCe/IJ5waqvrd/w4zzqw8Be9TqwEMyttO7w4cPnClj8FGPUssDpwtR2VACvYEQIeMltOkLR21Q08+YXEi+DjJAyZ55ZEX0IXaykS/lnlVHiKblNgA5QbINb+5E+vFNloP8x0I6GDmJcnQDI/H4d2qtKCV2wZrg
 PoalOdZQ
 kyMUr9KhHn5+u40wqozjgXKJ8j458blTSSJFoftvQowDZ5Tde3+VV3AAdAGmFsAkADgzi7rG3JLyiilXT4RVX1/lUBfpgFtLKZvbdXjORzjhxQ/dG5hmPZv5hUf/7poQ4CTELU5GNKc5SkuQ24s0zxlyaq7TQ+vQp3NZuyp42j1zId0coWA2n+nNxIMgyXZfcRwUZMF8xGhf2OmUj0wIc7T4wJ6t/TpgGQ9BFAmfJwkKuSZCiCBRLcR/O8w8lY+lOaknSzb4MrWl5XUa4Sam2+6VHCRNtDBYRB4C1zueWY9tFbv9MuYRIjHRcK2VMmIVHJ/9mvaaoQMD6UBYz3rk8uOz8OWSl7IYB8XnygMIppt0Cj6b6DCMVKYa7AdvuEwRBz2LjuqGiTLW16V+W04H3erOLAOBDVij7CFp1gBv+UXB/Yy5KUwE50fS5/2Lllf1CQCzYT4nAQ79X2I/jnN3UUjjTwX3wjXz00Qi5WPShcxV0a7F9GjXgNu6WdOVcdPkjuRYqxdqYk8e5JUEm5QNgI0J68WbbLVbQwvi9TEqZxWLovYy4/DiQsLWIAbaIHHUmJyIYGfm5XK8+gNoM5IDf2FZvTi0ZJeY2h0LQXlYEXYhX+kJ//aw2wM/TUsm0R6UvX9EYB841ZBYYVGlFckoEEalgP4Q8LbY+D4zuZtZK4zinasWeE/7O6y27PEIM0cKkH7Z6MutS/MJaCvHrgzMjaAe3zXEWfLhRzKWoB90DvYNYZACjbqA9jPSZDNUidMuvOagj+TN+w8rtvmGQd8YrwSULB0bZiskBvhBkQpZf1B7GXvhPuVuR2z9Eg7SXojmwggsLZLvBA7m/P2Su63u0o0MD+XGky+x0MO55Fkgcck5uN3ltJD1j58qh3vydI2UzgZyuTaxahMmTWUaw2jPrl5gwqoaSFMsrs+XF3ymXyEyXaxQh9LNi7ghFqUZ0n4Y1qucp0egAcXA3NjQT7FGHK4DZnQED
 VnXLKakz
 pBK591TWySnC3abVkX2fhRrJv94245NNX4bLSWgaFUrSNz8wLamYY1lL75e5jFR6HP5Yp82z0Dew6ip+rBu0Pa09iNce+kYMmRVX/lzSP7Pf+DuP6CoQ866HdNO6Zx5ixkXZ1wSgXnnAjAHzJPnDIhvV8dLgt6Fy1Ub7ccXUT+DF4ZO7REFt1fABZBIEwRbatwRBDyhga/DiRXk6jNV29v/v3/DO/1TTa9KKWWlos+RD6f/YJfHezfffSopxsSywIpcvJGmOBKDWbCWKZ/JVtNbT9u4pHmWPNKVtZEWq0UKJl7fE7YLr9I2jXotn9LCrwXKbsPmiSP6RlX55MInNg+pT7BvOyS3BfuT/eDcXbQUu/C8XDYq0MEkoA8RYJ+ab6hWRDfRkTeo03t0IOgtl/oFgfTYS9WpWWcoB9s9k2P6OTlUttZzZr1OoQzwDODshKUrka62onYvyrV7pgP1sqkX4udAflFQ05IHpoGdL/M4DGZsMVVUfeEO0FQNeKKodmPzr4iL2kFslUy4TLQF5LGpc+4Xh9EkD1l+Krtm7FK44W4zWev3diDJnP5kUEylVikdoY3CerQL3tWlNVR72NCObGTmtU4hADVUItHBi3JcUduXhtMMRDzpBcgOTqHjqkWAcTtJKm+52BuAvhecABwcR7ZL6/3CTlEqt8n45Engmtef5glbXWO26BflinKXdPq9R+B9DLeAhANNKCvXupzhwNKrSIDQBSl3Wn8TQ5BAvLPi3nLQGmuAO6fDFxllCDFiAA3s/EYsSBspPc5MVZ2+fpr4ix0eYDrhcURXX2i68AxPhOVm4Pc8KvS71bSoQNzv9xC7tXTeREBCSdK62W6/opbdMOyeIYjKbVPCv5TfMef+LoyRfEGMxU2zxxDC1kqFd3qs/ivX4b2vYyBIo7fvtD16OIrxqIgLg3zYkZDsn4MrVh1whqDtiEe9dIVg6iuZWUK9mVDPNP0mMPLQn1ZKXV0TOj
 LGAF6rkg
 w92lNsRoN61L4vU0oTIawLv76i1nNKYxE3qe3m0zXCufwrdLXa50Kqbl8nT0GYj1GVGFXfzzywED1XnQ32SMJn+LgyjM5rZYVd2gadO0w+m4L/yLsBR62eVfqzeWIwVZQXaQ8/YCyvJhdNi66J2I+AkCYBA8ezzHa2xfClLGwVqsCOIvAuEhshq14kaHsN23rRhsd8wUCdJ6xobiUablst8l+r4S+XauKC6ybX2JH0SDXdemx/O0cfWZG9U1365Q2otq8l1Irv5GGLMIM4+fHHKDZI2cwhmhWPuN70FD6Y0IMYlEzeMnqJk0KRADqGO0krvecPoDIr0xRknXodtLJL6qA6v9X9OA+vk58xxyX+TyhX9RUj7wfankQbIOh5OR3iIKTyesLSKUXGdUXTMRHpgff0mtv4QqxNs04ihc25AbxCJFsl5iqfzJ5rMEGZNOu1bCFBUAzbZFaC/EyGbGM17k4eKB9sgi2g8XlsuSyTDNr5wTqD7JVTPM9yeUB+ODoLQ5ha3bT65z37LH/q1ic8oe7jzISBDaj0W5erFi/7iIuP/87ewDWqzo8PG1pGthijKbS982teOHNvI9C25knFlaSxKM/51/LNUg5JwCyo5D6w53ktbeEgH+XXflioflcwiZLqM112g9NoQ2JWIGURUx7MCv8wIPA6mkIeMmFJM9w+B4mnKUR66qwtOK/W+yGRP0yZSDH0S6QZ4NihVhhc9FlwoAezS1biiuaMtwGcQ+G+EfwkOfwkx3CJKJ3dcHvgSMaU02YeHE7OlNaWl3bIzXkFrOQKcnsnYsAZNglM+eLiliUWdZvM8Rw6Poh0rfqWUTeBmgVnaidqSprtMoIm9zTprVSktfvQKGPAiQjgdiwwM2xpFvfm/lUe/rEas+waIKtEwcalBILPB3BmBlHas97r8KOIME/TMCe1KhYmKc4lsWmdK4obfxDulvhngFyBZUOVG73icGS9lrVvtp1hdC59gd5
 ATKA5UqG
 9EXSheNGDzCXAaf7SRhgp+Xe0Qu/sWF2aXOKFk1TZL7aJi0DWUOC7S2NPY61oAdNtJlo4cq4OwKcS4n6U5wnKutcETnITgcEit1fZa+4d0ix/bDfVoCD0mI0dvpiX2gXd97Sfb9ik3PHWFIKKsNjMhA+bC7fd09G4rmBOOXoqegzKFjs5Y+9BV5CkUO+aBl41AmGvuLIMv+8JeL/hFDS5lxnDv5HUnx2iimavIpI5GhJNagsp3pMbJGlLTGWbFjfgzqbojLYj/w4B26iwfkzk3cGe7ZRYiey1W5c3OiNmIzdH0ooExcWefZ5zbB8IBN+Bz6QPYot6+yr0f/m0a2mY4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in autofs with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/autofs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/autofs/inode.c b/fs/autofs/inode.c
index ef3444d57f6ee15767f744a5ecda020c247095d7..c1e210cec436928b80ac21af4713598bbfe04b11 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -92,7 +92,7 @@ static int autofs_show_options(struct seq_file *m, struct dentry *root)
 		seq_puts(m, ",ignore");
 #ifdef CONFIG_CHECKPOINT_RESTORE
 	if (sbi->pipe)
-		seq_printf(m, ",pipe_ino=%" PRIino "u", file_inode(sbi->pipe)->i_ino);
+		seq_printf(m, ",pipe_ino=%llu", file_inode(sbi->pipe)->i_ino);
 	else
 		seq_puts(m, ",pipe_ino=-1");
 #endif

-- 
2.53.0


