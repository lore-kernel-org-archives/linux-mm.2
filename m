Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3039EB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 279AF6B0093; Mon,  2 Mar 2026 15:30:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 244D56B00C0; Mon,  2 Mar 2026 15:30:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E71B6B0093; Mon,  2 Mar 2026 15:30:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EFF136B0093
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:30:48 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B92401402DB
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:30:48 +0000 (UTC)
X-FDA: 84502266576.29.5B5C2F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 118A6140010
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:30:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FekABZ2j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9j0aFGij5NisaW+jAbPNbXOu7RZ2Kry+8A+sRorCLCM=;
	b=xlUxGzwCaCYpOmda0CFNqchzo5o7TpQIb80n7m/xWvTAwq2a8drjILMMLqnbqW6grPbmO1
	D/HxNJLQq67AK2QGLhIBBNliYIQ6fR7/7skbZaXFZB2CS1EaWJ4fI6UjKWn7gCc8JObcVu
	0S0SSdGcxVqkpgi/apqEvuEx5Kl7fZA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FekABZ2j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483447; a=rsa-sha256;
	cv=none;
	b=K2bZwCmirmaD2z20946qWO9cwlqnNHk0ERHkcz2Vln05QavghgrFDGvvtsVNTvkjBASSS+
	Xs8Rxij1UcAqO3jZhJcPMZsgJ5TDqRt/RNOXlDvROT1q2uVJl/e8h3XRtLDGwdHVcfTJUO
	/X9ba9K9Jdk2+4sVeDycbh7iv6lX4lo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 62E4860128;
	Mon,  2 Mar 2026 20:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94FDC19423;
	Mon,  2 Mar 2026 20:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483446;
	bh=f/fwVVJUhkGYbPGB+Meav4MEfogu90OScL5Qckf7yg4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=FekABZ2j/7c/jYvntkWo0mlCTNNHALh4A3PX8BU7nHj+M/PM97wVWXFm5EtSgfXdT
	 iWS2Mg3rdFxX/hBo+NysTDs3o8v3Fd0je59H5mhjdID5gzr/OyJb7wt2C1DcmguYAV
	 DFa4WoT5Ip8848eB/EIrfX6NsrclAtTL0TwlwUwis7zksfFEoAxNIpqqVDqAdq8WKV
	 EKUvIgQfUEqZLoRu3SZopLRBHCi8VhRnkM+6aEJelI5FJqBvHlpT+nEvy+l4NElwRo
	 OEs0ukpKA7aqEJbX7P+8qtK6q/X8XgZM0lLyT5EbMhKeYhv89xawRNDO23FRXnB207
	 FbDIrbbXuf0uQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:08 -0500
Subject: [PATCH v2 024/110] coda: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-24-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1417; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=f/fwVVJUhkGYbPGB+Meav4MEfogu90OScL5Qckf7yg4=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH1JNZnTt1N00WLD2F0McaKJ2wk2UepiITW/
 FBPA7YXDc+JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx9QAKCRAADmhBGVaC
 Fb1GEACzdtDY8MwU++1kXjTBb/K0JgEVOC5FXPix/VzvhakzfWPQGJVdRNL7eO0X9izqtJYmhfp
 TfDcsPYjeLRHcdqAXlkG86NfHOlqwd21oz0KHP3yCO+FyPKEgu6tRNhWHpIeSPuNq0uZaGdGSDA
 guHrRhfJbI5VOW+R27lhpgHW/2dYIYMou/eWxnT4AwUU4WEH+8nM5sTdj81IRcxXmIZy695LRLi
 OMpeFla5+UU4q67up5UA+tr7fyFPoL5+g8oUXTwul8O0l+hjRJXJ8anJGbLMLay4dPPeE5+y6pj
 UpUwwFuxK4Y7P9VjwrejtIY+A33GIL1FOtZFBpoxAWCpuOmw+X90Ts0v/+/uSltfmDjenowseXJ
 5jNw9USFO8q1C7v+exQpc7MQmNbSRSWGLuOlM+7j3FBekwCoiwIj2L42r6ZD11179o0in0oKGtK
 DDTVz6ROH3APwFZHIdgURyG7KjpvAjppBEEOr1MrzfoVqmacctrHdmpcHRzdTS7FjLQ168KNKVq
 t1ZjWz/l2gf43SlQ7anJmAwT7fT8lydwHpoWcMGr1Fq9vqXbQrvoklK04JTe0MNSNvbbRel5vIl
 R2zDVaDm7uPrvFCCYVDfMBIocl3QM5t844cP3FjjesQF0BcFCoHIeANVPIzxaR47TydoLhnScPj
 Zj+3m3JN/rSDqGA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 118A6140010
X-Stat-Signature: hf54sfk15q7esgb3zsny3a7m79i6fes4
X-Rspam-User: 
X-HE-Tag: 1772483446-553318
X-HE-Meta: U2FsdGVkX1+IYo2BpNnn46B9Sl94T8dSqClhaNiZ5QW9/C4lFuceplZzjs5RijwWZj1YMWkAEwcfWp2CmBaMW52IYRZahz8WD39bR7CMFQVD5MaqNd874/LDbvJ0Awr96Mf4km1omPKYx0rza4TNH55vxcQV42jTu34c1PeFMQMAktw9bHtXnyschZbZTKbMz/gMWjK7Skq9NQrUaMo6zumkOR0fnmOLH4niPTfSwlIfOZxX75ug70mwWazVQ+xc7N1V5SitqlwR3QNIX/MZE9NKykcAH5pV7P+bLUSK6O21hxDR2dVIrM4ilAW/jHX3w3faTkJmpQS924UjrYDvZ1qJK17nuIz09+MkKWvS0Z5IolzClpbAL67ytzWcNB7/nEr47FLCpFcgztWOR66wpjVh1E425zpkp0pqm4JWxHrADuva2pIG8852kvusxJtknaoI6otcBzrB31Ax/7JwGrMSYJf5JUIY5IRf2ku8Y4WiKB2CVpFg+C9Zcp5KK6AwCLt07XvW9aju7vKCzshLf6U4IZmWz2M3z1BBypcDKUKQLjIWv5k0594wfJFvekpBVkYZEuhUpURV81v7TnL0ltEgxiNBZtCQsnRWgMAH0H+3iVwkmcfH+nUS+Uu7Bp3WlHBH+SsvoktRMIVSyLfTZTzhFR6zsJnbYtA7GPGONLtB5OWjtpIhbnzC0SLzBsLY3YWBQddZ17GdfTl+p/QmgS77Vynh7CGJQ20lSv0ILY3WNAF8ypSgIUjx2YVLVz3GyTdo1hrHk+nqeCXWGTnaEnZTzRkbntvTK0W34ccIE1KkLT354rkzPBPih/wCW0KUZlhNLf4pqnCZE9YoKLcWqVRNirCRMiJYClt2R2I+oXOWD64AQ/O8ceoJTLaey5pao2abaQgxf3aSx/0LSfZnsxEKE2YrgKmExAv9oWvwGFvQ2BsxwmLAFQCB+Rj7BHRep05BtC5jH8E5JeUzO4E
 RdxzeVm4
 WjM8SrFP8S4p2Gkz2SYxiNASTHWrOZw1kN9sO4jaruAfJaBSI8tKqgnhmvMM45giho74zEYPP8QE+B24DdS8sXzDuvpj6AXVNX28QEC0ozXevpntY5OLACtXLe9LtzHOsgKjEorRtGsymC8NZve6i1tdn5zWMOyqwOnaoP5eo20RMmAShm4ksmgO/Z9D9XlsSIQHMxTprgWFSX1APBEjtSBvHEcwkRGiW3L5/i6c4uPgzdUquFuaWZRq+ufnmfh+g4nwHCOs/M0nBNlf/AKY03oP4LlQEYxUOK41WMGPAkLwz8GUH7HnMu5AVoFgmoCsy3Zvb9YVxpyEoH3eydmxD2rG5KozT2CgH4iInPuNeyzjl7QnvYrTlVVNLdNk8bNszALJZPgJwfpORy/mCFm6c78tg9TpQZCQ7twwz0pkQE+IfjlYEe36BBEwkmqwqbZP6eRK1m1Lf5QRMr9JcW3KRN5skFpU6wf1cI0DG9YD8ky70SCTNx+8F92Orzq1rlgxzGLphgbOYYr9dnVOv4+It2EHOO8fRsGUneh7fBWwYDQc8jeWNCfpQVIip5r0hJ5Dl22X1/atLd4Ry2QdxVp2Kn1T8OKj+E5GZlkn3FFk98qTxQElc/b5yzWZ7DIDbv7cOcWd0CgN9RCnbA7zWovoIAXhW9f9LH3Tl0nZgrfvyZwW3LkF8G4cy+jru6myWCWsAfN0btJA+t3Vt9aZQVUdHhXMdGpmhCQxw4XYVLFGEIiE46wZyXQ/2nQxow+/i/OT3QyDRfa4gyGqHh4CTam7NgPPK7ABfnDIsUk1o3nIMdTpL9mNBfgHcruAzVKN5mvf6/RfNRvbEusgUBdxs5HT4ZWUDDbCzmofeBXq8Qp33M8oZQMBYZyL/310RucnhlKDKcva2EHdgwfwyeVhTKXxA+prTvSFTDIDo+5Wws8qTTzfd5jkllmFkY5ZDbU9LKC/VfsBJoRgpyZQb/L+/wiRFkzWfSChc
 Z9/1QG4q
 TNX6/PU9NFebBos2vmrapGK4Pa2G52I0VABsGgzT3EZR2HjXVkRJK1nj/qyyL2AP3TLXBHzMz6CqiJLUlJUZ78C8efQWPTaQKJ9B0Lafp5f+9f06vavQwcpYYfKXhjUdnZATyD4QI6iSkVxw3weF5XRYHcDJkvEuFIy5UIJ8m01uK2WIHc1nvCsY9g1z425Z7rXubIAqDRrKDa906NXC8daas9VV4Cj04LViZnYzu/+qYfn8M6nbOz0OIwB2CNDFjq3W3YVwxzhr5ab68eM+fk69Xbw6KTfPKuMHq1FiHzOO4IN9F7H8IP+k+8xv/qKu1SUO9C9Prc5mwl20SSSywl1h2hHhkhTY+f5D5Czf7eU4IrPrXpCFqiFjBs+7l4i35vXcnrgc+zbBp7wXuIaUkrmIfZTffTMgyPQNyUyfKVuZNwd13zjsXt/sOLomcZbTGrMRF21O6tjLstQ8LL+UPMh08Z0GuKqHziF7lMiER89b9mv+6CDyYCoR9C03jtkjq1gRZDUJychvya0gCh47mx/84BD151nJXpWgpG7WYhQk7QwkFOfnpw3Ldsrsqb/44DIfNIVuV13ZAqetNCOBHC86nD9DHEowqpD42GVtPQJ/jq+/mTCg0/2+TMRzZ/29QaNjB2lusyD6xW+e2kvN+2dnrqEIczVTNCgydAaoODBzFg0EBzRs/Jn5nSj294hNlLru+zVcZl/MQoHBeNg8Bm5bnOBf0k7vK1+giwhiuF/DPrjw7Z3xkSL7O0y/HvgX9y3fr7VQzvQdTXE18LVzfE4o3oY9Sr76jrX4mbgIqUOQrJBCattAnih3LYqNRplLXs1SWkhzELtfsrYkKUKlku+Sgn2KJ8tfXC53V6SCariZIsqB1SdA1YnyRSlk3ZOTGVvdZN6/sguZoYJYuvnW8NuCdNqU7s7vKejVT88v8+pAt+a7a9Q532vrkXI+d07+9phuF5a9w5j76hSjK+T+H6VofjqeL
 1Hk72cmP
 cQwYWxZcvKnesPWwu3L1uiobGsPneKIwVZLPL1RRQsfn1en8yjmtxeKqGPb4xSUmDv0/HEOqV3GL7+IwDwb1ugJ2xiEtanVbjesjoOrEiNv0hCtE23r3SdUZNsA77Bcp9WuFw54rdtjueYOkGDLmj4fJa30j5uGE2n4RhVvZRdexEw6teXn+l670R+Ut/RiQr47YuILpvLCt21PSvyFmc03onR6BhESW297oV7M2DT3FPkzqPQ/wY9pZij0ANxUqoYBFoHzEUb4ELfCiVyLspxxDMyajGoQX7LB6fE/H3lsN2vM19fq+9dTw88tDp0I7M/0I9LxJzABeHhzAZCJcz9qWUQM5mYvqK/sEgMZBG7LLeMa5UPU98/RCQSEEkXHndw1npLKGe1UL7FSQzgfUXX5tbZCMDihyKsjrBzA1KRqZzl77wh1JyXZ87n0XWOCweNUNfM4MtyuWA8LlLhu8F7gudQt2iWvPhxNswwuOw2Srik5TEZBuYjRMJ+ALED42uga1a9C4/OoR/l9+qXglu6iFYn0NO0M2H/YBX9cEzs9tt7ss7hqYE+HUm5BopaBxYQTv2s6KQr/gVaImZ/DgeVYyDjrIiJqOTbFb/DWbCEIz5ggW0+1Oylgag9R8Iw7wRp8irDHKo1FEsHTI/xuHi0eYmj24w6mVs/rpZluISisd44GxutySVxFw+iySw009rnJnus9MrLOqvqIKClde3Pw1pt4pSU927wVtquoWjnvlsDZYVFddrs7yqMv3PIGinFcv6MuXSN5fwXwM2s2syS9MA1Mv+hH5jq3jb4PeNsftd8qtT9ycxdAxPg6RzEQhRfL0I72FDKwZbatKKu0jmBsDHqV/U8XBRkdH8IwLse7+krR8PQA2TnChmBsxCfVwnigoVnbs7pj0+B06K3F2Tt2BXHAFzkNMcJKh5Q0RxGHiFS7jOX3LrPRazInEQxRULYrl91JZgPQGaEQPxrXVkJPjSEmWU
 M6nIeORA
 wnkwom0TBV2gLt4fUFayRQsp7T2qLZpx3hIQJR2Xl6grCzbj6Ts4FmWPESK4u3T8qvpj9LyGYgGolkUNiIF1stXJuPbugRy/npBYEnS3lJ7VAr3SgKhyxFqYvSRV5Zeug1qqRbKrDqbJdckuFDML8A98s8JUNVEIF2blEdbyMqt4gSeKPdY9CfG7QY+/IHPbWe5mm2dvPWemETnoBsjvl2qI72m8ClA10l6+JHv9RxnPL6XO3cKzgcinOD9Db5lZztwGwog3QIbr+WGPYvHuEtftRKGUHhiwPmYSsIbjX85FGfA1XfOayahSr98WKGJDEklgBgPlbPahrsVUY6poZ2jVpE58B1GZtdvtE+/6OtOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert coda i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Also correct signed format specifiers to unsigned, since inode
numbers are unsigned values.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/coda/dir.c   | 2 +-
 fs/coda/inode.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index c64b8cd81568d3a7c0055f139d4b12cfa37399de..b9e1674a8493e5578a04e4f8165ba30dc3b225b4 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -533,7 +533,7 @@ int coda_revalidate_inode(struct inode *inode)
 		coda_vattr_to_iattr(inode, &attr);
 
 		if ((old_mode & S_IFMT) != (inode->i_mode & S_IFMT)) {
-			pr_warn("inode %ld, fid %s changed type!\n",
+			pr_warn("inode %" PRIino "u, fid %s changed type!\n",
 				inode->i_ino, coda_f2s(&(cii->c_fid)));
 		}
 
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index ad1654f3adf8a6f4d9322d507264472f1703ffd4..964b9558cdb2e622eb9903974a10a6c5e561886e 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -257,7 +257,7 @@ static int coda_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto error;
 	} 
 
-	pr_info("%s: rootinode is %ld dev %s\n",
+	pr_info("%s: rootinode is %" PRIino "u dev %s\n",
 		__func__, root->i_ino, root->i_sb->s_id);
 	sb->s_root = d_make_root(root);
 	if (!sb->s_root) {

-- 
2.53.0


