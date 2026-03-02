Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F02CEB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:34:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73BED6B00D5; Mon,  2 Mar 2026 15:34:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 707026B00D7; Mon,  2 Mar 2026 15:34:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AB826B00D8; Mon,  2 Mar 2026 15:34:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4740F6B00D5
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:34:10 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F2AC1C2B1
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:34:10 +0000 (UTC)
X-FDA: 84502275060.02.79A6C7E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3B8F9100016
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:34:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=us9kuFVN;
	spf=pass (imf05.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tgjzzd4kTuzFOqBn1f3nTdxFL+yQj9PGo5rW8JgGIpA=;
	b=4ORbJvtFb/MaUSaeWoUcXTbNumoG2ZwAukLrIVzYxmw7efKTqAqySGY78VWktBQC/T8eNz
	QeOQ37Huyjg065JBGn7ZN143dHkG2u5YFv8VBe5ya+4G8hIQyC7r37lwQn0DKqaV1IbGIc
	OQ3NPikw66V/eHKGZonWTkeSEaLkTVs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=us9kuFVN;
	spf=pass (imf05.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483648; a=rsa-sha256;
	cv=none;
	b=FBVSmtxNk4uU/ejWR91MF+oNNpYomFzYm3LmA1GbWZzqXTtwE8tdf9OOmyY04Wx1b2pOUM
	a3s3oiDfwXfEsQ2pYP3ay56xIZ8bTjheZhczPStZNm8Qq2vZJ7fMPiCKEq9ecFtKCgvVDL
	GQRG8VNDmWSrEAKl3CO/vLwYxh+E1kU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E4E86132D;
	Mon,  2 Mar 2026 20:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE46C2BCB5;
	Mon,  2 Mar 2026 20:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483647;
	bh=O6E/wWymcmTFXnHRYlBNuOEnEuI3iSQ7UQxyw69+kG8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=us9kuFVN5+eJcWNCT1WvuDJBcdT4qSgZm5FciUUdFDPVCrpEdAtotU3qdHtNsEZ6G
	 fl67hg1lyDRhO2v+62bpFTS2fX6Q0GimDVN9ZxLUpCExms/R1PfW4BzRPaoGYFjPoM
	 JVzFrDbkMmYLKuVFQWwOg6rPr/tNLhNz67Wp1T3cERICx4UHd1h8JDplhVBL6xmirR
	 3BanCCeVRAD5haF1qLoNT1NvuAIvcs/+xUaBO7eNY7n0ywsCixWy7syP/vpLa2M6Ry
	 mVkDEGojwZpP+AVFWleuKqc8Y5IvMQ8i5pkK5Qfy4RxYodcEvAeWB8GB1lOX8L8ZAr
	 7sCX83iwYeaPA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:22 -0500
Subject: [PATCH v2 038/110] nsfs: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-38-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1123; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=O6E/wWymcmTFXnHRYlBNuOEnEuI3iSQ7UQxyw69+kG8=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH4nr1zAdiW5p2+lCqnezrC50G0DgPOGslhI
 SVgDwbzfQOJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx+AAKCRAADmhBGVaC
 FQ7qD/9Crc5dXcYjfDYsJq0pJ2tGKu0dX9jXy1EPC80+gepRKX95KNN8/+NDUKNZJ2X8nun84QH
 6CSV8mUcd36OvMzmw8CsOR23929nd8IU6sfDxv6IY6zF7iW/N/Q3lG9ZhxTP2VsC2MVnlg3ed4m
 gK97DBUZ1yLvx1MWYR5mNxUbaIdrFxlQufcHmLmQbnRK53W0PLahurhcvgndRQ1ARgjV8PPuKt6
 IqgUKKK54IiKTMAGPULJPF23H1eZJ5UHXRxsTqb0fD8ewbSM5HtaGAJ1PFLJR+lnfzc1mwR3ZA2
 WeK78R5S3k6/IifwNgBDKnno7pW8KBlUv5UmNgxKqGIhbm8umg6ZWPW1TWmn2eCwW/AuZT34LQ7
 cfpccxYJAjwdk0VRhRBJ50TtmVFhDS8v8qBaeqbQfHNUEe9a6sAsj90dAfDFBMvNdsUEXeoWJHM
 ZbfQbHc/28m9ydAf+AYHZkZiNXz3rlH/KwSUnkaOzozOshxNe65gvHTwoooRagSzjMWAN1nbyTT
 WSrnCapknoBfQW/lBNp10qtIs8c1ht8t+huigk6Jqw+qGpkFwO7bBk0mCm/p8jT1yKICL7bcZ8A
 5+NgyIDMEPDvMUUcnc81ZJ/1yv9UUcs9daePE760epq5urvrcj6qyAiIIDPEhfzs8WLJiw+RRL7
 nYRmX3jQMrIuTWw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B8F9100016
X-Rspamd-Server: rspam08
X-Stat-Signature: kkox3e4bknknzqptq4qekei4sycw94n7
X-HE-Tag: 1772483648-931786
X-HE-Meta: U2FsdGVkX18HjeWW7NWSR4m8+K80DlM2pc/eg/z36w5l3QBfF20Oideou4qf1/fwdSpoa5Hn3A05QI59Gsl0iV4Dckhv2RkhvLciLyUcRMatXaDjwVrFHd+QHfmk+9PdEn9HsNxdj5GIOFl7w0MbvaX/xBbl07ClaI2TBnnxf9w1hDya/NvsDOp01CApQcgCdZKSyLW1aYxgC3I8JIKR4OMHSm0V4FirSJv5sx2mn+1pUFmtjnLmL4aaSkrQT8fcFPcJs247H+VX0tabhu1ZCIDemHt+yUxiN0s2iT3kTdWF50uHb6qrfQll5YFUQYmbXeter+xROIpMyTtCla8bAlv507iyshNPzRDbOWBRXbnqCejvJ9gUBbRL1cPWlQHivLmndYBYJ//gL51VfIcJttrVhFIkFJ0NS/EQCnz5xqDdHkIzifx0CwoESGppf9RAvdAktFAfqIbBXc1zq0Ycb/heIDMtSGw8JB0zkRK70x1wuKFAJO/HNwx6sCX0mZBX2n45njVxUFoEv9M9QUCVxjw3SIn9VIEhyNDDekxaBjIcYsZ1UpTpVibMulR2fuArRyCqeTryqfqwaVmkjHpsjtSNl/yYj4M6jjQ9e4ubfaVKEPDzL1xY7DDdvBsrbpRqa1oHgjycWn/i3/tKzcusf7xzI5PfUvVRgf/iDB5VuTtEFy/Dv2LhxzZbwX88lLaJkiqBygA3NSGSn4G+wDeJd/hE1KCPYv+E7EhS9faH1bKXeh2Y47EHTwxqNWrCyYFfN4PkkgUMMJ7YoVqxWIPRDf3bgNt7Olc8t5SIEPG8hcURsdZBv7dQrFgwXTp4YlR0e6Ak7eV5LSKvRlavLkMNlR7JYyH51AaAdrUr07MGgEtYv7p1XDcv00N/zyXEI6mgLbAqyuiNYnhqLP/2KO9DwbW5bIFeeUBfQT2YTwL5lhVNOs/O8R1PWCudgMIVWEEW9JCehDjChzDTPPBVV2T
 cbZsCIAS
 slaSuYpXJnc6PcYQQwvoz110Lc27PDTVDyF7Bdm0sx5uRLiJ2GtNEBultLF5vo6RZEcZiKoPthG06PffM4cUlmtobkVdONRioCCvoeJEn22a3nMuLB8zzzFLNvM61rxJFFK0QvsTuLBOzmgTjNt97zJNWDqF3/cLQLDUc4MCIkL/sUssANQD3RAFs4W1RBaa/MObvHqzW09PxQ06BgBpw6NZlDRje/vO9TRhPu4kdzH1i1JjHU/n417B3O/zZ4Y9dljKUdxU1cZ8E9BC4f/fI7mZzfR9ornc52tqadzLH7crntjbbRrDrYwaKnFFUGO/pkRqyPRSgrsv4e1QJfC1k7mxPPSMJEfk7oyuElGr6COdyX4Oosw1nB7A/KgAaN+FE4X9ldTbAfAkcyad8sX4Xisr4wNn54oimIooVc2+HBxpUI8q6q+KnRM+BmBHeIToUd7vNVnllxPZYfVxJ3gq251Vf7dph5VVdeJdw+4gnSP0SJJkbJNaxfjA2N9nEZiftM9RMS1j3qFGEal+BLy9q4QBlVlc2RIcQQyWBPozb9O+ep/kak2ysQqDL2xO09q0qy9ChIf6sfGGjFQ+rwBmUuRL4B106dmRDxU4vq+i/65Hqmdmjr7h0/mp4eQ2TNPwy/jeEIM5nXqQNnvdWLgtlXBJxeRW5YqWmh4srawo4HcSwsTb9CikT1wGhxVbgnDe7aEQqtH3KViH1jY81vWeJgBzMR46P75c1geeGwUdXwPxO7FkRvyZTtZE93illRIfLBKJEsK0tk6DHwgdS0hZxi5bxuwbTE/AlXtP0+HIOtl1aiRA+LYeskpCIzvUYrwPo1zYAJjq59cdrNSK42fIUgO1zlRlErXcABR7SDgHi3pA81owYj9LGHgMgl7woA/1SyV1uMQH9vG4GMLcX6GhQW5nP0efQsP0ZRcGHf2JrwZDgWp+j/KpKR3ByjDwu5lFtSmr2Jtn/r9ARO58OkVgM3OKKOrka
 YiGFOy+t
 n9VuCpdtETTYUj0MNNXGHFHdPtTbGCCLA8xmPmGo3TqJltBLZna78YWUmbjde+4ULudgK8GDpdMBvUy2wTbG422NKfgh0jhoZvUX6K5cf/mWbJWjAxcmN1KT5gbJMxtICBydwfceE7mLG6p5Pt21DMiszVO52MdrLGDq4IFOG89BWmZl8DD1pLdIaJb/HKj+uSRVdjMFPsNaWxABxHBvf0nJ99XH6oBGjppDj7skjfKeFqb45gMAkKxLzoLoApSjrZ+JBT/FJ7Ez7kq2bJG6l0HmQbMw9aHDaYgDTbEiAGz8ipf6kB6ns2HKdmYJmVQrWhd2NB3MAF6V503deaLN+WiZ2a9TCI7u/Ic4tS4mMsj+0IjW1NTm93jZ7aVLHjm7woT3J8lCEL/uPr1nciyWhl4z3/xhYXWpX+tVE1/ULrLYO2Kj0a3+exwNwigcH9OnD73LjhQLG6LBxn+lM5GMYEsCTf05o/2XORgm4pDh+rhwS/gglJ6USecfAoBqiLb/7B0nHl5Bsy/lWcxFYbpiv3M0os4dx4lnVlIlLZg/Z/ZVf0hiIX2LSqvibiKElFojkJTsInp9Im0oYDnEHCesnowygxyJHG4zKsMomqp3+8wVcHwMTC9PVvenUzqsv/DSNJWjscS9wwv5SbrQtxDkJWqnm0mzLpo7AfXBeawkksE5GLzCv3bub5rd7YhdOUK8iSO2Q/nXohtVxSdXTSEPGSfaNLwurI6PZMbZw5h6hSajEPwcuQuYXYyJDS7LRdOi5c1kHfykx0TemYBM/ZwRbCEGG5QhXosXZkHsXonj6E8Q42itzsas1NBYS1ikbDV3GboMNMG/O+VczaXO3aEdU/iyyqUCnvSIpD3qNyz8c5aKBb3R363xfepSLYqnYjUfRWFEQek8TpAehjTpo23v9TQ/tHbxgyZw2l4tgvqZBYbn6uj8vncp8IXgyFLj2Juk5/98AlT0nT2/5Fls5GoQIFwG03byl
 7DTEhhHE
 xx+IdjyEsp19iTqdD3oFYbcFw/wGTIwv2jiGXrXFNsPkRJQj3Ad4gAL9oWLYrNoSzErAlswV1jyRkOhaxizInNzxb+X8Zeydh6AHcHIucG4GVzNRSJdH+LEJ6ntcMHAfM2QvkNgnHb1dRRpifMyOzes+30omQ8dzaGXh2T48Yymny76NHTFlLtKz5JBnHKRvK9pPZyTlTdjF9csa9v9dKV2r7NlZOaxq+t5h63TSByDWDsqUNKx25aK6/P2gKXvFIE0CevYiOJZVAgyunLhDs2F1TzS609P9lxUFS0vdNnJFjPQXJK8rdqH3WvDKbpBib6mVKeiJozFsDRHrnmNHIP5efgEkbeym0ni8j5wFlshpLSFpd9/cdnA4HaM4hyXOrRmUon7oZgJszVZhNiEBO7YIVbjBQA5y1EvOfDUVd5rfyQa9dat1BgAbDt2lmMsebW+olIWsYVypMb/MhbsIC7Te9mcjpnPIHkFNR4jCgr4dcK/DN10AlNcpjNTAyl8prRyS6oJwk1TF9JlmWT1TzV5gZrH1qdPU5wuwplG63R179N/+2CN/W8HX+X8Q65R4gFpUmsUtJtN6RMsGIg3B/+9WSixBjI7XHVM8K7NQcimWv8t/2DioRtUA9QDPx8ewxPzX+rfu71AF/5zUXZxRO9yS9FcdV0PMBPmZRU6zTq41oA2Ic1aGO9Dk6VQKmi9Cn0UdXzkzmw2+bMhu9tre2DoyrSP+BDRp+d+ctYR4toQ/r6YWAfcEDYczXW8QknVEUjp+W3kdzaJEGi685T4j/vx+8hzHW/+XzqS9tRnLWLx6XuhDOn+gS/G6krgfZDxjSaWQf6Yj93dggL33mSsoTMRBnW9YGNLAZNDjwI5nOjn2sWKEAX/O11THCo520Ewy2q6A9MnCTmPXcMnInN5342i16N8sGcMXP6PCvnc/LRBVKkDnyO/9ig+I7zVMGSpIHSASQeZEYIqq62izIIbPWMhN46KfO
 GcZI2quJ
 5gbtGuH1zAxE4RrvwMFVqcRo0//qakjmuL2awjoAELChnL9RT4CLFUK9+j421PqGKU2rQvFrNKlQ6DG8Ebk95cvz2kwYGABWXgEQOwU973l3vA2kf0DflpcG4nkVRHKydWL41iZHpofskMdg7zgv2Rfe9mMv0/jR8viLDlGQJIWFeDYGpWxdf2HE+9Db2kfGZcQ9/mD+iXwOpd7tryE6zhSigqsmXy8mxqwdhhQMK6GfaB6ZRZ1xGcehk0IVxpK5ChS74ZXHQspOijb6zu5zEmGADKnqKVS4VmRIzfATmpqcevXWRmKxHR/q91kxRPAdUK0y4hBpATqlkpQmSZr5lJBMa2ELkQt+7yfKG47HgwaRxAk/cXciNlWDXZ6J8sCs+sqZSAZgE3hQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert nsfs i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/nsfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index db91de2086456bb9fe0547be7dbbd2de87c97ca7..0e099ee2121f8831645c3a25d759793ef2ff9ce6 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -46,7 +46,7 @@ static char *ns_dname(struct dentry *dentry, char *buffer, int buflen)
 	struct ns_common *ns = inode->i_private;
 	const struct proc_ns_operations *ns_ops = ns->ops;
 
-	return dynamic_dname(buffer, buflen, "%s:[%lu]",
+	return dynamic_dname(buffer, buflen, "%s:[%" PRIino "u]",
 		ns_ops->name, inode->i_ino);
 }
 
@@ -394,7 +394,7 @@ static int nsfs_show_path(struct seq_file *seq, struct dentry *dentry)
 	const struct ns_common *ns = inode->i_private;
 	const struct proc_ns_operations *ns_ops = ns->ops;
 
-	seq_printf(seq, "%s:[%lu]", ns_ops->name, inode->i_ino);
+	seq_printf(seq, "%s:[%" PRIino "u]", ns_ops->name, inode->i_ino);
 	return 0;
 }
 

-- 
2.53.0


