Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3882AEF8FF8
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A216F6B008C; Wed,  4 Mar 2026 10:33:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CF5B6B0092; Wed,  4 Mar 2026 10:33:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87C056B0096; Wed,  4 Mar 2026 10:33:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 756156B008C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:33:30 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F0C559410
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:33:30 +0000 (UTC)
X-FDA: 84508774980.14.CDFCC0C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3FA7240016
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:33:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bChptJ5T;
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772638408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5l4DA/1Y/CM21MHyINQQ4xZJdr7JTnzwHEj7uiglqbc=;
	b=OhoFyGy2gJ2Y0AMSl3Xo6mqKS2Q+nCJNPeLEeiG01DNaYEdE+My/hNBHlQxSkDVWX8pvHN
	s2/+8cs5NqOxVh/gXIZcZz6Fd2NdREg8boXCFL8NrF+8quSrSackSnDc83lMHcIIRPXrzS
	WypxgA+XefoQVJkkFjFvmLOjNThsvlM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772638408; a=rsa-sha256;
	cv=none;
	b=O+2YLPRMKvOK0SCGWFLq9pzs9GEp65h/jUaU2mlb5VM6Zq8rOHPaVww0H84W7hbBAiN/2f
	+Iw1ScIjfx3Y2MxhSW2tEFSxjEHoKoLV004twbiatsj+vXlysRRyKRYSeW6vlRgNmSwI7Q
	r1iXReK5yRl1oZCTmU3OmoAqsdh2CBA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bChptJ5T;
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E9CD4427F;
	Wed,  4 Mar 2026 15:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C009AC19423;
	Wed,  4 Mar 2026 15:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772638407;
	bh=5cP83dKvqPjVsj1XPnIyUXMyl29bPUyTZbFPkJY+hYA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=bChptJ5TJzLEN1XfmQ7DZM46vuOu+oMXoZpPjhyPc3DOQsK6Anrzo1DvrJfxKa8g6
	 T8ZxpFwq8TPMgaGqmZlTDxg/mGyAeW2gNEhv9raQTJk1So+85RdbTmP3srwaIrUgkY
	 7nnE9eMoKmvoGwFZALIpm1UD2SBIyN+ViJkLRYPH1XCWp9ScI+8wuyTGHaFjriYqSz
	 dPcawWLJtNXmxcgB5MLz+VLRToUxsaIv4mTRg4y+yqjxWt/9PxUytmusigPJ/6hpY8
	 ++x+JjdMWX9ujFyI58Gwj+ifYm2UXv0ieMtF9F0YEKVJaZy8JmvrwJjGl8RfXA8rMi
	 GYeukqw9VVF7g==
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 04 Mar 2026 10:32:31 -0500
Subject: [PATCH v3 01/12] vfs: widen inode hash/lookup functions to u64
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260304-iino-u64-v3-1-2257ad83d372@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=10591; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=5cP83dKvqPjVsj1XPnIyUXMyl29bPUyTZbFPkJY+hYA=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpqFCmmQpujh448XNFM6BLqUSXhX6OopSNb2vZQ
 YuT/+5KSTiJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaahQpgAKCRAADmhBGVaC
 FabnD/4/xiP6rMz15b4n1SAp1B3YU/tfdq/NzXrOqhtxlHMkMl+XM8wIA4aIk9JOYAg896eD/Fy
 +WEN1lOcfd2TZD7vLlzGp2ml8bg/c47mXjrailQCw57Rtg+1iLHTCzPvCrRLEv7tMnVmZGSNUQt
 gXXuX4g7ABl1s+Rz5EDehLR75HThVUn/RVkHycVFw2OeuG7lNkghSfnVhGWrK22o4/30C3md+eh
 r8Y5hmLT7kDTthNo9t1BidFUHy4va8kKZReNiFeD984T2JT8aJdqDwczA+VKzt38SEP0In9d6/h
 ESHbggCh1x9Q5vNaYxlswea13/mgjpLWFPsf3ye1ys0w83/tE9A10G8HRgGEJyiT8cqfOnmz0cW
 DcY7aHOuldgAAT2nwIMKDyUvYyp7RIIY1r0atfMubBaT0r7pdaRUghPP0hddnqvHsAnpcI/gTOY
 DC4kZGycm+cqQHmeftuedmmTY3ph2H8N3nwdiPuCqMxTGDQEZ7RXlJ7De8YF0LWELZMfQV8ErYd
 YzFowiaXrWgeMMEYTLXpmh7XV3mOi0HZF58L8r8uighvnGQPtPho03bVLJEkk0zMdCmT17g/M6a
 m/BIxsDn02CGLaAh5pC+VoSVhoN3OdF6N8p5QZ/+CeVE5Q7L7NN6Y+tj/6KT70Do8/drp3ASace
 2sxFmo+H7Ut8k6g==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3FA7240016
X-Stat-Signature: edutdt5fymzj74bkt135u59ug6dtwrtm
X-Rspam-User: 
X-HE-Tag: 1772638408-290542
X-HE-Meta: U2FsdGVkX18+47nTW4N7bEknL85Q39GCpHAvqmdX2M2fhNcZmrQWD1cRg/zhAT/3LOJ6dDmiWTQqRUTBzCAUYTrxiQg25AbAZxith5vEaDJmxTEh/EGEBYaY67bqzFwARCsT9D3BL/TTqYRzuiItNJjwDHD3rh/Mh4pK60gcpOi9J9XhOEapSuJH5LosWY0r0lRS9rqifnhFtCH4PtcksG8rdPy3SsAw4IBnJ5aZ2pzAVp1RiQX1lpIri+DV4FA12f/QiagJR2uqvlWqaH6cfcjRsYLuLqltYeh7BqWTTtSJdwznVoy8iPUqU0icXIAlfRXrHNmbgM6UIhWrUiwiGyxPpOOgOLbi/F4f/YRSDhaYHVH9cqN229h9euW8mbmJ1re+AO/FXzVB3htjiBL9VBlobluozRPOwPHylcgnbtzh+l6Zb4Hb415bS/ps3+GvV7ZGZAFutg8XDVBHPtLSXQmSQt4IRdhTMpsjYsuE8pvs7wjeR4AnyRyy/6vxNTW0fc2j9MiQWiFwz5l8RYJSrbwHJqJmjyNA0DCMhypw3i1K2pm3LVbOyJvBR6X/MCA84PCkHGKysGZqCnM9rXgBtBZi1Cz9O/nafF8f1UBoON5zx7wRMA8A4qNkoiZkyMgwGji5rgtJ2VfRCWv2Bq0/fZgxdLdx+tN/aFb7VQopgaukj4lcWVWVpzXOkmgK/EdGkTqmF6mpNAinSlAxh5qdQ6BXbi/8tGWiLER3LsayqZETAL3cj3tEjINEo7yLRbxnZcYHoMl7ZLNDZdHJVXwQ8BGYuUKLavHL9oxDTe7USDST54PnhgqDrB5m0bWy1BYpltImChYOgg99Jx/Zczmt1yGwSllrkY8ODwrNT2+woT2IRkLBf2H90t3cVJubbZpqhkXkGLt2DDjiyZBgXh+hppAE8UyhshyuNzeSBZ94a44yqRs3Hf3JVEbWYW8r3j0lUJ6SenEN50jmvWiuZsa
 K+f7Ov27
 5B+Bp5QOFMhuXzhsvo/7GBvBsrBL7oLG6jT4APVHIJaYtyWecyqwpPI/cqnX9y3REiogSpE+xBQBa3mlQPZKDEVAz2SlWaPm/UxmNMRFPdIyESAQeHcW9Jls0cB3Ygxm1Co6Mnc1MINj+S9AZXGgMkdy0cdWi2AJXPQUyvi1t72eJkXAK9b4So/C0od9DRes5N7iHFJEzkeSY5Gz/uuqFI9s/LRo6P3fDvrEqtyN/e/giTNBeFvr7z2GSyCW4yvW9nZJMYg9rnAgv2bDBjnpclVlDnDHmMnx/L/QsN3MpY9YnHPOsQrPR+lEE4KdFveLOhHcUAQZz4NcXhYTHT+FysYtMaJXETkZcRQsmkQ0Bk7dcdEYi7EdqlOO9kyxwxzsmwDD/FzVVqJnIDEZYMxl75QmekavDlxuAaKiM4SeUdRm/MQwRELcgHc6s1MWiBrZm41EtCDwRBX/bKNM6TOI5j8HP8tXUl9vJjXOySOT4hF+mvZfiNDfS0Cs7H3EOJQNdMnOcTaq9aj/rPwSlbX3DIqbYSBcUt1pIS8Jd1d3ZGJL0QYIXHEoF27KwAWlDnV2mNQyauaCmR6lQgVnt23CnwMNTqF2+KOtOkPY5IU/guA9mpX54BuHYwrbTkjUjeHiPHhMQ/CXe5eRU6bMr+89ZascbrNg7CBweguni5v9wJNojF0eoCZvEMjMuoq5Z3vXiFWB4LsL80EtHOtraV7WxRdqaN71AgylbUsVLUVhsprGf9v1Yr9DQLitRtcNf+Gk5a9RiCSuBgzmhkjatuzPn2sgksOaiJ7DZP5vJyyW0/B3yet6UB/8GZfL6nQEomGg2COlSogmm+MAjqsaTnjn+90KWMB7JbVpfVcv7Rri3ii6aD+n9GlNbiWcbpbopnugkwlP/vG5gJVdyDcJqfvRAJP36dA5BEcgGtKerhQ3uBuonhKpv2cL/b7lXVj+QL1+wmHoVpUr1WmoPQu25LXOKCCIqT2IY
 eV6OEAMa
 TTbqgDoEdQW3eLDyJVNWK8an/yOSKNLyFh3+REZybNmbGAwVNsYAjdwBXsd3wvYPhX9znds0cGNtMpgR1Tb3e6LOJQOZ5cYhf8V4Aw07UuxZYGVMhmI7Y784rUgs5jMMkv4lU0gQumxCg46DtakDjUdbC3zsU6SBF0BQKWT0cO7x8J8SQcwX61lXUn+MtK31NAyI9wcI1/SCWnVRRTqGc1NMSMjrytVQVbRbXavW8hwZwWlb5M0JizB+m9UMS/mNtj3CT/FtswVjjDPwlw7/I2qYKHZcE5gO8m57JFGVfNlhXDJq+N/c6FjgrJDsjmP1KX86f9M0O6CPlYr+23KJ33Ti62LfDtIzKX0ADaQcHhHxxR+YPZ08AyDfgobtFsDQ/BfM43897VvDcww4LSyMx56Kb8RfL/U0ECPzik8E3DwescRkB6XP8XnpUcDksnxEhRsEUPF11u4J++snqHIoW4yFRLciopqVkI0zb8nLVp/3vwgKbICFtbcL1Vv2lSCF5AsDl5toQe84w7+9bHPQSeWOCJNNxr/YNa6Sq/rtJ3BcyCNl+/OzUppzTN3HdC/MMrArcqKqqY71YzIUBBe3dNMjaumTttaJiDTjQJHaHGWRN8RedRJo6s7AlItOIOznT8VehEiAtESCS1l21Fz5GMpI4kWaKjjOO22alNgjLplkwBzSX4gE1yR1sAMiEy5HyE+yx+RIx2A+OqzZXUnzgDfeNzy8n+h941BPZak4TWwkBeMRqg5so1z26PH4S7Jftfqw91nXUTDlADpyYI7oSt69lHuFFQNevK9vWoy5RTRGz8dhwiCkLP3f0AlbdpevqK8OQfxUw9w3S6P7bXZUgO4UDHLdFPUSPNldwGAnUMHbgo1XxyEr7LaltwwTvYiwR6Vv4sSCmMR548+OnQBzqOT16SQomj5ucUxW8czqTPJoUZvHTT7NEpUeiXHL9v5mBRKRkBw+g+uEh+5wYfvmnbfwrgjkv
 q7aRHojd
 OsXFqtpRiwt9IRmEBVZ85d0Qfw3q4zclKE6tGNC2lKr/jCMImWaFL/kPx1piV0qcdqU+OX+hQeH/dU9b1sKEvHNmwAc0zb9sq9AMq8QnyWcgeuMoE+QjKkLCDYoXxWQAoTGg+910RiilSOXqXhOPa5IrN6bseYiTUucTaBv65b1imKGXm3x0Clr3ng+481UcEY6Ty0g2Cwp9wjadgAMlcxDDE1IUyOVGrJX6ZxeXtrf5iJLi/FjjT0R9axa/qBCc189/TMSHBb8EomWVGdKWdbb80jbpWtA6lebclxN9Ulllb8LTvx22VFxKGR/v4u+ZXGP+dWcem7bCUAXQ0Vl0RHQsIzgFshZPqeQuk0/8yS9/+qodBl+UY4Fl4LupHqhmjolfbnYL471xs+mVidcNgxNsTCCopExVu5FM7IBO04f0UtvkwdKNqhJWFSw/OQ5QabosTFm5Z4mz+TM8aMvHB6gPZbTCD+QAAfzaSwXw3FRSKqF3wDaALyrcMAxPZ8HnpmrXuHcnH27PjbMucuIunFz311GYy9VxIxjHsesqcamUHPwdwUsW41MIJ3AXx74QGD8a/kJ0odiz4zEnwO1Pv0shRbJqXbX21fZ+U8zwsT5kOXdiiA2W+PdySBcjNhdIFNOJM1RD5dC3V6uzyvoFhQBnJdwmUwpgvhyW2m8uzxJ28vJiFCW9MaKq0B6/PjAvSrVevikU9ru7kdpU78O5KkUYX0CujOA5RzJ679iU8KJuNmrIB1wl+sh+lGTRNW28iLvjI2y/ebQSFuKoWt0pU0SjS8gejIq9Qb0N2tU5EPEs7ljs2BhEYtRiU6fFTiuPGelPLiXMLTaIwNiK5daxk0oSerTTEv+X+bw1OkmushLC2l8ZdqRK30XmkZSm/cCbCahpHZgmdNjuMrSeZ8r/q+Br27bM7M9zzVA0/VDeFLlwBwiX/7SsW6cW/cYZljTw2n7lOgtze7JwwfoXn8aCbm+OcKDET
 cuQMt0U5
 +Ucoo5RnRjytWjN36RUeh+yrHcsKSBknX2p5I3/T+tVRTI20g6mEM+oM6Ac0lBsQ3MKHlqLtkKPhxxbzg3a77caC1Map9c+Sy7jrT4mrw1H0H5kBVY8AtcGK0PAqJc+h5dnnkoi0y3a8ztbv8PzGj15R81AAh2kjPQXGaRwazYV7Lmq0KF/Em7a44Pkqoheu2lszh+tmivFzx1X8rnsoT+v1IwC9jEEvfBzftauDhBKl09lZysnckbqyOZgCnY4t7D2sngFlj2oDViHzNIgLBNZM5MMn9VWA/Y/D+eAZiADLY5lh0Npa2wFN/jqbqjMIznOIUybIYlWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change the inode hash/lookup VFS API functions to accept u64 parameters
instead of unsigned long for inode numbers and hash values. This is
preparation for widening i_ino itself to u64, which will allow
filesystems to store full 64-bit inode numbers on 32-bit architectures.

Since unsigned long implicitly widens to u64 on all architectures, this
change is backward-compatible with all existing callers.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/f2fs/node.c     |  2 +-
 fs/inode.c         | 36 ++++++++++++++++++------------------
 include/linux/fs.h | 26 +++++++++++++-------------
 3 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 2030e943ab9b3d5e2deb20efe9a44cf5093a61fb..d8d02870cfd1c22cf1951201361519de534b6bf7 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1997,7 +1997,7 @@ int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
 	return ret;
 }
 
-static int f2fs_match_ino(struct inode *inode, unsigned long ino, void *data)
+static int f2fs_match_ino(struct inode *inode, u64 ino, void *data)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	bool clean;
diff --git a/fs/inode.c b/fs/inode.c
index cc12b68e021b2c97cc88a46ddc736334ecb8edfa..62df5dda05894297dde05e541e4c8550bd866fef 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -672,7 +672,7 @@ static inline void inode_sb_list_del(struct inode *inode)
 	}
 }
 
-static unsigned long hash(struct super_block *sb, unsigned long hashval)
+static unsigned long hash(struct super_block *sb, u64 hashval)
 {
 	unsigned long tmp;
 
@@ -685,12 +685,12 @@ static unsigned long hash(struct super_block *sb, unsigned long hashval)
 /**
  *	__insert_inode_hash - hash an inode
  *	@inode: unhashed inode
- *	@hashval: unsigned long value used to locate this object in the
+ *	@hashval: u64 value used to locate this object in the
  *		inode_hashtable.
  *
  *	Add an inode to the inode hash for this superblock.
  */
-void __insert_inode_hash(struct inode *inode, unsigned long hashval)
+void __insert_inode_hash(struct inode *inode, u64 hashval)
 {
 	struct hlist_head *b = inode_hashtable + hash(inode->i_sb, hashval);
 
@@ -1087,7 +1087,7 @@ static struct inode *find_inode(struct super_block *sb,
  * iget_locked for details.
  */
 static struct inode *find_inode_fast(struct super_block *sb,
-				struct hlist_head *head, unsigned long ino,
+				struct hlist_head *head, u64 ino,
 				bool hash_locked, bool *isnew)
 {
 	struct inode *inode = NULL;
@@ -1301,7 +1301,7 @@ EXPORT_SYMBOL(unlock_two_nondirectories);
  * Note that both @test and @set are called with the inode_hash_lock held, so
  * they can't sleep.
  */
-struct inode *inode_insert5(struct inode *inode, unsigned long hashval,
+struct inode *inode_insert5(struct inode *inode, u64 hashval,
 			    int (*test)(struct inode *, void *),
 			    int (*set)(struct inode *, void *), void *data)
 {
@@ -1378,7 +1378,7 @@ EXPORT_SYMBOL(inode_insert5);
  * Note that both @test and @set are called with the inode_hash_lock held, so
  * they can't sleep.
  */
-struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
+struct inode *iget5_locked(struct super_block *sb, u64 hashval,
 		int (*test)(struct inode *, void *),
 		int (*set)(struct inode *, void *), void *data)
 {
@@ -1408,7 +1408,7 @@ EXPORT_SYMBOL(iget5_locked);
  * This is equivalent to iget5_locked, except the @test callback must
  * tolerate the inode not being stable, including being mid-teardown.
  */
-struct inode *iget5_locked_rcu(struct super_block *sb, unsigned long hashval,
+struct inode *iget5_locked_rcu(struct super_block *sb, u64 hashval,
 		int (*test)(struct inode *, void *),
 		int (*set)(struct inode *, void *), void *data)
 {
@@ -1455,7 +1455,7 @@ EXPORT_SYMBOL_GPL(iget5_locked_rcu);
  * hashed, and with the I_NEW flag set.  The file system gets to fill it in
  * before unlocking it via unlock_new_inode().
  */
-struct inode *iget_locked(struct super_block *sb, unsigned long ino)
+struct inode *iget_locked(struct super_block *sb, u64 ino)
 {
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
@@ -1527,7 +1527,7 @@ EXPORT_SYMBOL(iget_locked);
  *
  * Returns 1 if the inode number is unique, 0 if it is not.
  */
-static int test_inode_iunique(struct super_block *sb, unsigned long ino)
+static int test_inode_iunique(struct super_block *sb, u64 ino)
 {
 	struct hlist_head *b = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
@@ -1616,7 +1616,7 @@ EXPORT_SYMBOL(igrab);
  *
  * Note2: @test is called with the inode_hash_lock held, so can't sleep.
  */
-struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
+struct inode *ilookup5_nowait(struct super_block *sb, u64 hashval,
 		int (*test)(struct inode *, void *), void *data, bool *isnew)
 {
 	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
@@ -1647,7 +1647,7 @@ EXPORT_SYMBOL(ilookup5_nowait);
  *
  * Note: @test is called with the inode_hash_lock held, so can't sleep.
  */
-struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
+struct inode *ilookup5(struct super_block *sb, u64 hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
 	struct inode *inode;
@@ -1677,7 +1677,7 @@ EXPORT_SYMBOL(ilookup5);
  * Search for the inode @ino in the inode cache, and if the inode is in the
  * cache, the inode is returned with an incremented reference count.
  */
-struct inode *ilookup(struct super_block *sb, unsigned long ino)
+struct inode *ilookup(struct super_block *sb, u64 ino)
 {
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
@@ -1726,8 +1726,8 @@ EXPORT_SYMBOL(ilookup);
  * very carefully implemented.
  */
 struct inode *find_inode_nowait(struct super_block *sb,
-				unsigned long hashval,
-				int (*match)(struct inode *, unsigned long,
+				u64 hashval,
+				int (*match)(struct inode *, u64,
 					     void *),
 				void *data)
 {
@@ -1773,7 +1773,7 @@ EXPORT_SYMBOL(find_inode_nowait);
  *
  * The caller must hold the RCU read lock.
  */
-struct inode *find_inode_rcu(struct super_block *sb, unsigned long hashval,
+struct inode *find_inode_rcu(struct super_block *sb, u64 hashval,
 			     int (*test)(struct inode *, void *), void *data)
 {
 	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
@@ -1812,7 +1812,7 @@ EXPORT_SYMBOL(find_inode_rcu);
  * The caller must hold the RCU read lock.
  */
 struct inode *find_inode_by_ino_rcu(struct super_block *sb,
-				    unsigned long ino)
+				    u64 ino)
 {
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
@@ -1833,7 +1833,7 @@ EXPORT_SYMBOL(find_inode_by_ino_rcu);
 int insert_inode_locked(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
-	ino_t ino = inode->i_ino;
+	u64 ino = inode->i_ino;
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
 	bool isnew;
 
@@ -1884,7 +1884,7 @@ int insert_inode_locked(struct inode *inode)
 }
 EXPORT_SYMBOL(insert_inode_locked);
 
-int insert_inode_locked4(struct inode *inode, unsigned long hashval,
+int insert_inode_locked4(struct inode *inode, u64 hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
 	struct inode *old;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8b3dd145b25ec12b00ac1df17a952d9116b88047..dfa1f475b1c480c503ab6f00e891aa9b051607fa 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2935,32 +2935,32 @@ static inline int inode_generic_drop(struct inode *inode)
 extern void d_mark_dontcache(struct inode *inode);
 
 extern struct inode *ilookup5_nowait(struct super_block *sb,
-		unsigned long hashval, int (*test)(struct inode *, void *),
+		u64 hashval, int (*test)(struct inode *, void *),
 		void *data, bool *isnew);
-extern struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
+extern struct inode *ilookup5(struct super_block *sb, u64 hashval,
 		int (*test)(struct inode *, void *), void *data);
-extern struct inode *ilookup(struct super_block *sb, unsigned long ino);
+extern struct inode *ilookup(struct super_block *sb, u64 ino);
 
-extern struct inode *inode_insert5(struct inode *inode, unsigned long hashval,
+extern struct inode *inode_insert5(struct inode *inode, u64 hashval,
 		int (*test)(struct inode *, void *),
 		int (*set)(struct inode *, void *),
 		void *data);
-struct inode *iget5_locked(struct super_block *, unsigned long,
+struct inode *iget5_locked(struct super_block *, u64,
 			   int (*test)(struct inode *, void *),
 			   int (*set)(struct inode *, void *), void *);
-struct inode *iget5_locked_rcu(struct super_block *, unsigned long,
+struct inode *iget5_locked_rcu(struct super_block *, u64,
 			       int (*test)(struct inode *, void *),
 			       int (*set)(struct inode *, void *), void *);
-extern struct inode * iget_locked(struct super_block *, unsigned long);
+extern struct inode *iget_locked(struct super_block *, u64);
 extern struct inode *find_inode_nowait(struct super_block *,
-				       unsigned long,
+				       u64,
 				       int (*match)(struct inode *,
-						    unsigned long, void *),
+						    u64, void *),
 				       void *data);
-extern struct inode *find_inode_rcu(struct super_block *, unsigned long,
+extern struct inode *find_inode_rcu(struct super_block *, u64,
 				    int (*)(struct inode *, void *), void *);
-extern struct inode *find_inode_by_ino_rcu(struct super_block *, unsigned long);
-extern int insert_inode_locked4(struct inode *, unsigned long, int (*test)(struct inode *, void *), void *);
+extern struct inode *find_inode_by_ino_rcu(struct super_block *, u64);
+extern int insert_inode_locked4(struct inode *, u64, int (*test)(struct inode *, void *), void *);
 extern int insert_inode_locked(struct inode *);
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern void lockdep_annotate_inode_mutex_key(struct inode *inode);
@@ -3015,7 +3015,7 @@ int setattr_should_drop_sgid(struct mnt_idmap *idmap,
  */
 #define alloc_inode_sb(_sb, _cache, _gfp) kmem_cache_alloc_lru(_cache, &_sb->s_inode_lru, _gfp)
 
-extern void __insert_inode_hash(struct inode *, unsigned long hashval);
+extern void __insert_inode_hash(struct inode *, u64 hashval);
 static inline void insert_inode_hash(struct inode *inode)
 {
 	__insert_inode_hash(inode, inode->i_ino);

-- 
2.53.0


