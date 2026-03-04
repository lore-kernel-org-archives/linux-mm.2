Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AB5AEF8FF9
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 808166B009E; Wed,  4 Mar 2026 10:34:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A81D6B00A0; Wed,  4 Mar 2026 10:34:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68B806B00A1; Wed,  4 Mar 2026 10:34:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5495D6B009E
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:34:58 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 16A4C14060C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:34:58 +0000 (UTC)
X-FDA: 84508778676.04.9D80015
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5A21340008
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:34:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tXE2Q9Ks;
	spf=pass (imf17.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772638496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gVnUWQH7a1Gbi0lCyRvtnpPZOKtAbwU3ELoWFyvRbS0=;
	b=HEJaDOYG0X4iJQN1++vCYtuvnok4ccwkje7mpxiV4QwhUWXLcTYdCYqi/7bBpa8NEd+DCq
	M9K/jGuLJRJ8N1NZ16BU4zmmFLoUWRQ+PQ3p2YrrVgQEvnQHCOJNoySQMCeFqpajfBDPG3
	ClvNGJTb0PbDOEDNtVkNSdKe/MyBoDo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tXE2Q9Ks;
	spf=pass (imf17.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772638496; a=rsa-sha256;
	cv=none;
	b=7zFNdKA0KCw5hRPOxqdJemhEFdU2xF9oy5hgaMGWiXoFgzv1UcfSYoIRBN8sBqBBalG/hO
	8xZvzDjkpf96gke/wR7XULwlZlLsQQOBLMIZf1GNepfOqeg/Qbjsr3WVdMwmtLmpdKn7yK
	WEGoS28B8jHt67inGKmz59Gul6scZYA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8FB056132D;
	Wed,  4 Mar 2026 15:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8107C4CEF7;
	Wed,  4 Mar 2026 15:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772638495;
	bh=pfzMsOYRRPF1Omutl9Wzsj/v4OymtZsNcWF1In5v5f8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=tXE2Q9Ks2tkr375jZM52XmqFW0dn4JFmjuPn8LXDtk5D7XMH59EhbjF03E9DE4r2E
	 gESzdIumn/zSP8x3m8O5EOhWEJ1PjI8sROJeijvBUq+G602kHEKVZxOS5WlJZNiWEf
	 ysRfjxi9BHPmqmS9dLRKqgMNSjXWATww45sgbmyGGDO8n7XbN/jhFWZE+M0aWj3bvM
	 s5t4TYxrzdFbuX+ueygZDOGwv3Mi1ZD4j1+PCFY+du7X0OBhU96G127FDCcjySRWvC
	 WIc0YnB4HSCQEjbjImNyUaBw57icPjynkldyyExeBFZO1uf4X3S3rY5+5Y1qsIUtqm
	 i6g8FzsZHvZJw==
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 04 Mar 2026 10:32:37 -0500
Subject: [PATCH v3 07/12] hugetlbfs: widen trace event i_ino fields to u64
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260304-iino-u64-v3-7-2257ad83d372@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4105; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=pfzMsOYRRPF1Omutl9Wzsj/v4OymtZsNcWF1In5v5f8=;
 b=kA0DAAoBAA5oQRlWghUByyZiAGmoUKih/b5XA4c12kwIo+94gsSuVqUY2ifrVzx7MIWmY4czq
 4kCMwQAAQoAHRYhBEvA17JEcbKhhOr10wAOaEEZVoIVBQJpqFCoAAoJEAAOaEEZVoIVtqwQAI2c
 nH8OLzbicVfCcwgT7n9P6M7t4O0jSoWkDpkOnW5uYzqadeBA7vXo3g4BVSTLUJTJGhMeMweBvMu
 wH6JnBGvFz9DQEnzycO/ts0dx7ctK6deENDyfiOw9xFtL88u95GyKJjrYCaI/R03odStLCgqKrO
 QydS/H+pDQ2986UiMfvZTX4iAM5ryA/1uRe0l1r4DntVr8/+P+ybXJfTPyzlci6ZMeeghkP03xr
 oePUF31usdtfeIwplbBoulNZBxyw0y2oYwmJd5rsjUWZbJ8DbdA+l2uGiEtnmvVQn4dkIblbHe3
 V8aAH1URKwwhIL6G4fTGY0i1UBhoccOS6X+a+JjlUIcGlPfleEuFusJaHzOcZNFG3Gdw6QRGpoi
 1W2N4QxdTqf6p3nwR4YELtFb2nWku6JRQUDiaHFELUkJSvwulAEBKgsPG8/Ddz6j2WoG/hazUY8
 mq6O4ZWbELtD1YqMi1nHbULvdEFBnRs1ZsAPHj09vlo5lMcbOienETuTNJEt3UAmNRLrgL5Qae9
 BlADi29P9GjnWuXLT9mW6acwjHJcr9rQ77jl4t9e+pHXoDxfMf6RSgmbvxBkOkQRdcHa84Mfm6w
 Z427ySavl0tSQY8pC+9+ItSH4jPhpAqZXVEizDM6HQ6n1p6bYqMJRtxG85bUM9qJgduPP0ft2Fk
 oPpfe
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A21340008
X-Rspamd-Server: rspam08
X-Stat-Signature: 84t74ot4bundynxg5x138ujs9i3nijfd
X-HE-Tag: 1772638496-87322
X-HE-Meta: U2FsdGVkX1+Na6HjTL2LsvIRQDAyisrnnptAPceJ4xQYXFBQpfQP2wnzJ08vMRTXjMlCcuWE2M+SfRhcLLu/5GMwHckE8zbgea6bEkrH6Ep1/lX7rghJHYvJp1Rqo6tkdhaXgL6qLsGi9iTawv4TFGPXDI1gHLrCYMos1nuUtR6MzNPweJtcviskUqnY1GbC+GUOXVv326DaOp5dL3/1iSdSKN7dKZJmkTWEqhOlra6LYO+B3PP3niCIL9SE4zUyBkHVdqq05MPSehK4q8b9teeuc9YUIWAPu+v/W6aIxks6/YXzKVM8pHZcqK9Ia5AvWTjhlm2bbvQbwBpkKAeKqRgdk9TQ8AphsdHR1VUSHf7RiKGpFkX4uFkZ1d3+HE3Q3fVgXUiVtdHQ3G5jNdeCqT3aU3dI8HISzAXm1YohTpBvVcqjDhAPGNT+wWxBiJ4D5GHUvWEa2noexHOCCZPFEKqtzN21s34mqfgIKQX1JVjRx/pqMcpWQuD/6R6RrMYjE5vlB718IVXFtuK00Gvrt9qiswbPtg+bw/3QhaFj+whVEy7VHYFMnuC+9WHARlM53fvm5x2/toLZnxogdVjNLzR1yzbFUpYcFayIi4JPFWku1h4V1Wo5jcpZWL1eUlN+NkwcMmh11L8etYSWtyCO2F6ahbJNjKJWwOnxHh21tvyvajoMNtfS/8vUEaiDeKw10YeYu9Oo+0CwMTAtQm2vcj5g+arW8zAGQ3DeCv8pQalKFB1k3kxG8pT/WcL1E4+IKEMrUidR3MAUBeiJZ3STy9re9/nKrD8YxvXnfqI0RUx94P+Xqb4dGk8lC0Yjg3pzatZiFwravhFIYMNO+HLGBVebKomCflunShUuZm4SQ2mb0JAlBJ+XgHZjYl2C2JwS12Eln27NYiwDeRbeeGLFFYSznETR69SybtEX3uMDTb/VZCGLKg43S5tv8JOHKjy0NNT4GfpK3qM80ecDHM6
 NP69Sq7q
 CIwFf1EqPCu/LVLjhF1IKwEa1odPF74LzjwFCvF3oy+zbWeZUhaSbOMmkmSjVvu/KSQQVWpGy5W5naSJQM56VHMhv3c0Ig3VocdekOxlr8pqa3NZXUaeOnsBVNAARDpD/ZhEJ53XnqBg8P9fCL5z6lUo+ixOnH+k1R1S5holV5lvsSUqpeYSoHiZ3i6rl4yDM5GwJD4ijt7fNm5aIdtNSnWbH/8dgClGWY0inGqUy+2sEHr1/s/be2kwauwSMC0tmp4P9One1G3A7CV7nr2dXy9SpXgy5fqqAC1N1yxx9C2ahLeXBpT4re02JlHk5XD+GaUiCn5qSlPLDPs17xjivO5qpM6NHCyD8934s8lwqV5E2AqO5gtxvbt6oF2iSWXFD9uAPspv8Y5xbPfZ5D54nbswbAMIg/Q2S+hcyYTnMcm4ToWiRoKRR7Mv0f7/qriU/4dUcvcYCNOkf0cd5GhZUbNt39kzRMJ64BrU8PXwyU8CVxoQKPRnQmsuIidXVIYiOQ2OZ/kajSRzhqKXFDUJwG7GkoMbbDhizMhCbaTVtHZrS7FLR5GNvIBCoC91+X3gZXZ0zDJuH1h59arHYpaU+KJXX/DuM3fJ97d2lf0lHArG96C5ItZBGD9jaoFZhNapnIvcH7GbCPGz15z9WQiGncefMponK3z5RdmRDQL7yJlMV/bxweP6NJRVlJBuhdTHK9U2DYIKrF568oxW65RtrMD4EqP6TkGYJ/wVSrt1klKylVjTPlCLwkIMSTm/EVl5CNvk0k3lgHzgJlg+l4amUdzbSaKEnAdSQ3H8hnBLgj9g7HXrrZSj+9Q7vPUauLunKVUTruwrY3e8+/pciJ6bdxaXzNtDtHhh43I4FURqqghCpX5y7zmlsdJdbsIq5nYNF3VMVnu6+l66unPrl6IJSKAmsH0qSKGZnEHMtHXGYYU6gSg8/A8L5FIL8wnIrP3ZfkhobOX5wf9IFdLQlePBkDIUGnVG4
 VngDm6Wk
 ioKlaTQmastvse8w44t+YZVBryb596nhLrGy1JpGkUMp+3Rc4ks0I+w/rGZVC6RRNwzr8mHtROdpPMRjVrxECJMg6/wjV3OZT2qWDgdA46l9thtoxfZ6TSrhCjNY4MaL4AEdcsdhw352VAYaqa8jpS3FOs+KpVRQexXtiNUAFggcScdkUceEiXsqJpbN16AoBWZ6U7EYhi5kfk6buQ4NE7EwYElsn0c1PUcLHkFTrkdLkynu9AepZHGpyobZBi4ecrGl/1Dv9rSZg0AtYT2TR7eX/BVgR7ZG36vGiq9VusYLjymp5zsXdDwZV3EJJXBGS8Bq1nOXYvNMfP2ApQFLL7hCzK2PRamRibWF71QSZyqrvYSWSmqFxJTsP+QBHM20snvAisdWITic5YOY0FucP69PlbiuWXv6spRABEYqYKrZ306ZFTTzJGWlLau2gYOX9dU0D4ugUhLb9daQ+o/NFnT2YCa4fRTjUl1NyVAL5cB6o3/yLHbQvqGuzO/le39PekwI3Wk5zb+s79xK+f1/JnIHjohEJEEhcpQVf3IWWcHSs6j4u0hgiTfSDV/oi6BCL3Ioe5eW9tOsTuo6pU1M9RoMRopl+mEVaTRpiiqOGu3ewUgnQ7BvBVw8RoZvDzDY9fqDlIOqxeo06xoCgD287W0FvYCE/Loz2Qp05cnI7uqFPU19ADv0I5opcidtPEfAtx74GDEIKP9RE6CKXri4GN5gwl1xNr0KGHbnnm9xESr4YxBE+5xTXt1oxgUNtqv9V2r5oXCfag6+yfFXSG3QHTXCXAsEWFTpRO57wQm4iYhyFqEyrKc9nZ12XHnc2w4k/HbGr2L2liuRuui5+GKQ0DEA8428oW49FylmDo0wOXwDgrco5/CsOqR85q2/WFqiQ66m2QXfoZmUWtk1C8QgojBV1R0lc809K+O9bP5NicT0bEKy1FzidBor7zt5txD2Q39iW5DzUc1GseFc9dgrQlr4PcvCG
 NplrCT7j
 Djboge6DCjreeYCRWPE0Jlu/52oQaQanUBpv+2IWGvEGX9JvxZ8+BVTk3BDVSMzKVzlViPUoE7DgJVBSI7Tg7oPhNUOjeVrSSy9o0spwVBuvvqBpuoNmLExaCqpsLdBu0zapPPkwRYl2czJsze1zykLe+29wJqtqd911MdW3nPUT1+9V3bKAtH1uhpdToZF5+H0bUqU5RTgkE3TUJFBs6vlROn0wCTyql8m+3x7I2iYveorFIemOg5Nz9CygqUmKA9nU5gppli0Uz79UcY3dnAOpirooAxUBUiLeyGcRm1eQb6LSbVnLAAcsfwM29QJgAnAcT0E3OZ0SJUUnSLUmzmIipXm4bhmZtm5vwY6VmnZff+/ZzJBMvXshSSN6r+LZepn3dhfl2GvEC0H7fQP34fAedEzBIbW9tIVVuf4po2aWfYbMuBK3vxrN+OuNujQSJHoXwuxAGGE5LwTAclFfJbRwxpvBa9I/OespxkaxfJHPgSDQm0rb8ujI0NF2iH4KFBkWINmN8ZFTJ/oQUY/ja61KVSU7tdhpWRVe9Hb3FYA+1d7qtnb9aYu729Hz1UrKiU7LZS9q3Xicc2h4q0zmYFeOs0hVUDJTtaJ/EL5FBwhgxRQfwc3p42vBiHQ+howSgjdwz0BgPhCuIVcaUromYkZcVBAcwNwybZ8obdnwtX63F//6omV6Ai58GgRlXNTGXnqp+817m1wYgou0v8tJr/JoqKYb+ODPaykaTk4fzikrd7zoxsmegL/LEKUV/Fr/+o16H1xnwywlSuQlUYcUZe7062vfT7VXzZ9e814RTneHwSzLAZ4w1434jUiKU8pcQWB3G5rHjnllRXH4qpNoTVJRV8LLpuJ61btUXmWDyBy/gPAlPiA6bW0I1IXhw1vcXVYzxxYngKqIU4w4Ha9XSlghAYAZ8uDr8sOpld+r4ep/UOvLgCd09g1GwyOhj/0oeeE2DmxyhBma4TppC3G0gBuYsFKs3
 Zhr2BBTN
 2ELwrSye/fiBZtIkzLp374G3rLgL+GMODLQedCYJhdQ6ZfEdHY+duxDCIqAmVJ+cTdbm1O/EK/STzBx1zLcjSK82Vkpya3q554oWIkb068pcW7V7/DH00c3m3IKC0zv2q2hM8HX157IDZIn0m8wIzL3xjMd6hHaYwdIcy4Y8cWR3CYHModtK8RTKtbAEAbtwd4/L9QYIYvujQu72uv9o1C1DeE/Oxb9v6VZl781fLIFpuEG99tU6Atw97/qREByKmlPh6NiOkHb+jpLHRgqmHviuHX8BPAIKrdpo9nr7llk6rm4t5WGGkd5ByQYM3qhx3VC8n8DNsNJDtB69B0VctuGjC2FWJIIoD9t2BBxpoPYiCNyYdy19gvh0OvEBzoDhJD4QTZ5HG1hJybMEsbFMyTmScenyPVEPI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update hugetlbfs trace event definitions to use u64 instead of
ino_t/unsigned long for inode number fields.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/trace/events/hugetlbfs.h | 42 ++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/trace/events/hugetlbfs.h b/include/trace/events/hugetlbfs.h
index 59605dfaeeb43d9e7657e338fdbe740e8486a286..8ba72c1d4f4d8ba616906be5b5c4b487972fec00 100644
--- a/include/trace/events/hugetlbfs.h
+++ b/include/trace/events/hugetlbfs.h
@@ -14,9 +14,9 @@ TRACE_EVENT(hugetlbfs_alloc_inode,
 	TP_ARGS(inode, dir, mode),
 
 	TP_STRUCT__entry(
+		__field(u64,		ino)
+		__field(u64,		dir)
 		__field(dev_t,		dev)
-		__field(ino_t,		ino)
-		__field(ino_t,		dir)
 		__field(__u16,		mode)
 	),
 
@@ -27,10 +27,10 @@ TRACE_EVENT(hugetlbfs_alloc_inode,
 		__entry->mode		= mode;
 	),
 
-	TP_printk("dev %d,%d ino %lu dir %lu mode 0%o",
+	TP_printk("dev %d,%d ino %llu dir %llu mode 0%o",
 		MAJOR(__entry->dev), MINOR(__entry->dev),
-		(unsigned long) __entry->ino,
-		(unsigned long) __entry->dir, __entry->mode)
+		__entry->ino,
+		__entry->dir, __entry->mode)
 );
 
 DECLARE_EVENT_CLASS(hugetlbfs__inode,
@@ -40,13 +40,13 @@ DECLARE_EVENT_CLASS(hugetlbfs__inode,
 	TP_ARGS(inode),
 
 	TP_STRUCT__entry(
-		__field(dev_t,		dev)
-		__field(ino_t,		ino)
-		__field(__u16,		mode)
+		__field(u64,		ino)
 		__field(loff_t,		size)
+		__field(blkcnt_t,	blocks)
+		__field(dev_t,		dev)
 		__field(unsigned int,	nlink)
 		__field(unsigned int,	seals)
-		__field(blkcnt_t,	blocks)
+		__field(__u16,		mode)
 	),
 
 	TP_fast_assign(
@@ -59,8 +59,8 @@ DECLARE_EVENT_CLASS(hugetlbfs__inode,
 		__entry->blocks		= inode->i_blocks;
 	),
 
-	TP_printk("dev %d,%d ino %lu mode 0%o size %lld nlink %u seals %u blocks %llu",
-		MAJOR(__entry->dev), MINOR(__entry->dev), (unsigned long) __entry->ino,
+	TP_printk("dev %d,%d ino %llu mode 0%o size %lld nlink %u seals %u blocks %llu",
+		MAJOR(__entry->dev), MINOR(__entry->dev), __entry->ino,
 		__entry->mode, __entry->size, __entry->nlink, __entry->seals,
 		(unsigned long long)__entry->blocks)
 );
@@ -87,14 +87,14 @@ TRACE_EVENT(hugetlbfs_setattr,
 	TP_ARGS(inode, dentry, attr),
 
 	TP_STRUCT__entry(
+		__field(u64,		ino)
+		__field(loff_t,		old_size)
+		__field(loff_t,		ia_size)
 		__field(dev_t,		dev)
-		__field(ino_t,		ino)
 		__field(unsigned int,	d_len)
 		__string(d_name,	dentry->d_name.name)
 		__field(unsigned int,	ia_valid)
 		__field(unsigned int,	ia_mode)
-		__field(loff_t,		old_size)
-		__field(loff_t,		ia_size)
 	),
 
 	TP_fast_assign(
@@ -108,8 +108,8 @@ TRACE_EVENT(hugetlbfs_setattr,
 		__entry->ia_size	= attr->ia_size;
 	),
 
-	TP_printk("dev %d,%d ino %lu name %.*s valid %#x mode 0%o old_size %lld size %lld",
-		MAJOR(__entry->dev), MINOR(__entry->dev), (unsigned long)__entry->ino,
+	TP_printk("dev %d,%d ino %llu name %.*s valid %#x mode 0%o old_size %lld size %lld",
+		MAJOR(__entry->dev), MINOR(__entry->dev), __entry->ino,
 		__entry->d_len, __get_str(d_name), __entry->ia_valid, __entry->ia_mode,
 		__entry->old_size, __entry->ia_size)
 );
@@ -122,12 +122,12 @@ TRACE_EVENT(hugetlbfs_fallocate,
 	TP_ARGS(inode, mode, offset, len, ret),
 
 	TP_STRUCT__entry(
-		__field(dev_t,		dev)
-		__field(ino_t,		ino)
-		__field(int,		mode)
+		__field(u64,		ino)
 		__field(loff_t,		offset)
 		__field(loff_t,		len)
 		__field(loff_t,		size)
+		__field(dev_t,		dev)
+		__field(int,		mode)
 		__field(int,		ret)
 	),
 
@@ -141,9 +141,9 @@ TRACE_EVENT(hugetlbfs_fallocate,
 		__entry->ret		= ret;
 	),
 
-	TP_printk("dev %d,%d ino %lu mode 0%o offset %lld len %lld size %lld ret %d",
+	TP_printk("dev %d,%d ino %llu mode 0%o offset %lld len %lld size %lld ret %d",
 		MAJOR(__entry->dev), MINOR(__entry->dev),
-		(unsigned long)__entry->ino, __entry->mode,
+		__entry->ino, __entry->mode,
 		(unsigned long long)__entry->offset,
 		(unsigned long long)__entry->len,
 		(unsigned long long)__entry->size,

-- 
2.53.0


