Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E84E4EB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:33:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C72B6B00CF; Mon,  2 Mar 2026 15:33:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 588466B00D1; Mon,  2 Mar 2026 15:33:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 460C26B00D2; Mon,  2 Mar 2026 15:33:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 302D36B00CF
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:33:27 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EECA81B72A9
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:33:26 +0000 (UTC)
X-FDA: 84502273212.11.5A336CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 27DCD18000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:33:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JVvxQESY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gr2QsOoMI2tmGylCdr+0+mxHP1isZFFWDpB+QlZANhI=;
	b=NVGDk1oVcHAvQFYBcbyOKm6pJFlojXoh89dJGvzmY/rYgtdJCDXv2mn4XHkcBCazHGDV32
	Rhs3qD/mdPrSy/JwCHp6SNywc2Gd7/igPIqiTJ1bILQODb8TJz7HDCUJJSTm37NiuuShnL
	nWVzTOZATjEJw2W21wHyUkBLRifJRJA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483605; a=rsa-sha256;
	cv=none;
	b=4VZvwUp9G/hqGRjqy4ptMzGbwSKnN88YoY5WHtTfYVaoKMKCg676hm3gEc9T8DPHvKHEvp
	Svq4xUBy0oe/sfpwGv0KOL1t9r1SPFuNfKzSEZqBNDyVYuqrqalIbSuKKjdR9dTBwLWfUP
	Eu3yJjjSyINEB0mt7tpDEsJuhb1nSXk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JVvxQESY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6050461339;
	Mon,  2 Mar 2026 20:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4515C2BCB6;
	Mon,  2 Mar 2026 20:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483604;
	bh=3cpzbGbQEzKafMiD6v2N6bmpx/gRo7GJc+27jmhiBys=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=JVvxQESYpxJBdfZomyES0XCtCpX7ZCHOWKMXayTO97zGfiea9tGzB7E1SfEcpd/5j
	 hdS92Xa3wMRZCD8qkOCJ/ekdK0rHNrdoazH+Eogeb2w+ADdVIC7T4gQJYG9ZYSoe1s
	 1BeztKoNpjVvnQC3hTPFPXl3zs3dpZ+Gahqs76FlSadeeY/QgLn9J+MCrljVTwQTKC
	 OQo/fF0649GDk3apMPfQVaRnxYDbuC4nRv2o4vlaHJ2EfqBmL0upkAs2YFC9ACCo+Q
	 M/C0whK0AY+1aOhKBnv0XqHkjPKBCLGcfY1ZEI+fSmK5oTHB6KBUV1lR8SosfG+8d3
	 FptDXdiy+0zvw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:19 -0500
Subject: [PATCH v2 035/110] jffs2: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-35-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5094; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=3cpzbGbQEzKafMiD6v2N6bmpx/gRo7GJc+27jmhiBys=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH4vc/to6NPUF/bhODqd4IsjBc3EIzSXN5XZ
 Lc/vLEIM8+JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx+AAKCRAADmhBGVaC
 FShrEADGuK3MCIHKFEZdrtuOjywucyTBY5Vs9Ysoiqc07jaEC/laqTog+glXOjPrpFjyHxmdz2w
 QmtFeWoNhIH6FdqAZROh79iui+tqSDK6+xoaN6hS8h5QxEzqh/GI36aTZKM8dK1FSPIgAr8pCbC
 mva7IV5BcRq8J6fGH+Zb7Z1XMDg/1bEa9RKWxmq3GlZSR6MnaVkxNg4RzFlZ28q3RQftLVie471
 ehsTkC7cRa1ZVcMKxrNgedkS45jRnVDPGvaHZkZUd3KW8qP19RHBwOJYInZ3Rt6OWZgfZs6fAiU
 edTpaEYXPV7GgflD64Q7OuHfvwtvMlVdUc19Sy8lbaQf2AgjtlG/kKwVAPXhwiE86swmM7huMgD
 kTwG70xBJ3wo4OFqJttmdeeE6BysSNgY5j8fhKDFcen/LHM2EU9fPhGOxY7kjDBcKooZEFRcfPr
 dQpZllqyGJsui2nriUiD7irJKH+1rWRdZDKtSBMclQ4YJGBUzXS1FdneYSaKVx5y/fSbo2N47Bj
 JiukNVppEDoYZoVCwIhcZhbMLeXXHtHu3f7vCngIpf+/cCwIv/Fy81JA46+rUzYkHlPOrm3Kx70
 lFUvziawlfWLHt6dI8OKzyTZVLphS72FYZ7tG5vMd16VeR4J2ugs25MemcvWT7WS7+UpL0YiY6o
 NXf+cxFxDyj6BlA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 27DCD18000A
X-Stat-Signature: c8s4r7ws4x7d6cmg5cqo84xi7mbadz45
X-Rspam-User: 
X-HE-Tag: 1772483605-368704
X-HE-Meta: U2FsdGVkX1+qkxXe/7RRO1mael4hWWWV9OiNAk6rqMJeYFQ5NBYGI+yfdzSN1y09CvMnrFL1RhZZjK19WYtVo0NF756Lv2m3/RZixmMYjgAqtUi5MCufxZ8ojJnU5V5hDsb0oavzpBR1P1wURD4mD600JBDEfOgUeJaqbq597aalgjCpJXeP08FPYNPhYZNuVxjLqr6smvFoTg+mh9I2mbWSOq9cjUgnS1/7yc+ApVBdIMKIR5sxE/3j058+Xp/ZC0C0+uwBCavP+kKe/U2BrB0PAl76GvbT9uXUQdJTUTPdxbooYQI663JvKaa93VD2uIWtGKO+oXVAF/KStrJ24/6WKBf4BEysAEx27G5OMqEnztNAUNSEiebsuIIfGD5pr9ncxE4vU76iOp7uFhiKCQBunrSaTyDh9VtrjvqUhaVSAsTxS//Bz9BQTruosvAQz/7N1UN1d7Eezm36SVoaloE8WI4cSQCFYJlIFyHxXuaIwJ+htGPR7qaOdfC9a5qRcAGc8e00AckRrWD6ltwcnxjPQEXNp1KORBWlSxss5PmSTrvyhsjd9Mxk0VNv/RHt+fhBjo9qfKZ+Vhaugty8LeetyPC5Mg8BFg0XvMIt2P045QLtVMBygCuoxqMaXXESe7v61HXsVzeL/0UyjlW6EWDG/3wNfo83SDBkHfnPNsZ6b1FqkN1y+St6FhHRBPBBZhNw5flRhtb8M/VGbedszecf9lbJQpsfJsmj4uYlJn3311Y75w0UrEz56wXfCy80CwB3KXjMaBT4BtfRUsbYDI4taYQ+QWV/SitvzZdFrhVlh0ymPolm936CvsC24EyJDT1eTJfOqS3TN/HlaFHhhrmOAxXTHZAGelmRzMzkZ9eG9KSSrFBTyGHV0P+feG731RDjpRgV+601UHd4QubYqzfEd8DzHR2GnlpPow4nkLE3M2x6Igtt8Pt6363NygMPFu9ShTiOEr4qP3P3ZXS
 99k2eXxN
 DaGYN+mDnztaKcqMO7/uBFxJcYGUcmsmpZHl2ebe/VfG2JTRhSXZuZOJi3Ifah0ro5t0qJJ3hVOFKDL0G0yYJBZjbBlQ6yMAIRJJY9JM6CFaT2Z0e0X4rOkp3kUnzl+vInCXAJeM/H4mpthLJkmAw9H6Ycw4A1gPIR5EmhEnnl9v0VrGu+ZJOI1V7f3vbuWZa/aNTsAsZm4FL6ZbecsnS9h9rdCrZl+c1GYzj4RvNdUW9Ku/4G9qcxwBUtKZK575SRLLfLqYxzM+jkd8ifv8RiLU2P+uS0S1voHFgNV0a15Lrv+x5aOYc6l7Zoi/+Q40EQkd02d6nZOy7rB9AxXabwHY966NGM4Y5ewV5khECJ5zlRD7GUWLqUql6aPQwht4rEdj+XcdBhPEw/FAdfhHagN2GDY3RqQbqCorYQUxQjkGQc4ZUw0xkHLMDrwcBd98KfQwjqK1ubfD4RrpWbruQdBzUMAlaavVJ8CkGC+GO0MXJz16jcFD7OnmNOAOVqfR76hWdCCJInmB/qlAJF8rn4n2P52h7/yn/1t8RZ9VbPljAYIEWhQsCeEsS0vi2V4WkorO/ux/Tsm9iUBPmglHFYk71Ql29rjMO6MPsIkToWYlsAAKchXfR5w0sUUYLlArdceSxDoFCFghVjpHzt0oOQt0skb4/B8G6bkZ/VOlhenhtDE5tbawa0MDg0gx2wtCMiExZ1GgCbWKCGmTgEjgfOihhT1p/uQKX7IwWKO/ns5qWs5GeMekXOMK4qlZHeGB6ycLPUg2bWotek99XuMBk5ldOVM0xGvogcaXytZ15mCDf3klNs6XVxNF4T/nrl3Q8QHWh5Iq2Jo1CcfFaUlwT9RPTjp+5VQ0bTaz73LtWX/QDGwQDWRZKHt4daRdfzA2YM4LSAQ48bScF/NdfDstTUNOSWXjik5zv1x3KEcqnk9Nbpp65zCvgcsN+AbIGv+UuYwG2uM+GSncLDBETAdO9XMgADRMh
 2egD1EEw
 nc6E4fW2pGCFqHL/u3QpJIrUZRvJC5F3NR6FZSuwttWoMHE/EmcrroJnP9LeQueY2i+hw6ieAFhVys4dr2LAGmPm/CJAXpC3IXoLh6RrT/7KiwrnBvNhvG3BnwoT4TeJ/pF0vzMizXmnSccx4lLh2pvsmiRp31+6KyCUPSiRwUk5O+rl66lnci+2so/9oNeF47Ty6/QHt6F0+mWU+e2oxWD2y6NrPDd7o+AT+4Xm22yqhTO/istT0OJCxKM0ooZbZEW8lTvojaFU8JwiTgzIMFAbN1SHjWbwBsdwbuMEhkC1wgAB0Ak4f2uflnqH/3QmqJLpVGrQf6JROZipm9LqHEpE04L4jZhll6afrt8fmarfYJPl1q9aSyOXFy4ONQ461jjykn91G4kZPojK5A55zHyZOU4RB3cyVv3pl2CMPU1l6BqM+BVMQsAnLe5z7B/pf3dyewnKws496qISAWQZGwcnyarHvMrE8wOzXoLcs8uL30/Ilb4dWwlt8+YMFSNU3PR/Bto1erpQsmfcIAy91GN6K+gQ/B+k1b+usjyfq5crCHYK2Om6XSxEKiVd5snSzoSZLY0iOvMrHJW6ZChKAeRh+RJeHp/7FDPdq6gZfoJt0yxVw1ks1Lg89oU6Dr+3DjcHdlMXnhIK3gMF/GGQjQMqyEGy2UB1UFbrxLcC9Xzvr/PnYMulO3E7BHnHXhH+u5tRjPdJ18Guo2b9B83jBQLb5moh2p/u42jaBd6i1qTzyfRnz4kdlafUyreqmsInqV0YEo+iSVsaeTwrypW5MU+RXxw72+IpVorMepMCCiEvM1oBwdvobjF0oom6mw0ray2smFOv0r6B+luATCrE7dHdMaQAg8nWKdrWfh756mkwJOOQrUd74Y6ingIoKysBHuSO7t/Po+0L5p5Q7H+X9snDZ2PQlTErvMHsNgy7NiXn4G8zdvDwndmhvATcM+9PeNs0jtPVZ27I2xhYnAKE931XoeVDy
 KSrA7hj0
 3s8lE/iGVayhCkwSDTB67mapeNI717ZjjmnXYBUlrBdXkLyVwsNsBq8k2N34Xm4Dl85mfetZhtFc4p8dl9Hx/uFzfd2N0GanMHuDehaXfUFk7Ni0a2c5wsfJDfXAeDPN+AStmdozBU78ltOEKRpgjcrb/qAXq9DQyKu9MPacxMKZuRc+GAsOgSiAR9ZPEne2YpfEfHCe/icp14VQItIonfQLQ/K7JBo5jjZMdMO1F/zu63dJWTpRnYJzEzxW0mto55L7SkMUDY/Bjyx8hjNGX/37r/Rjv9WZPeFbCO6fuD8cs1CEnST/xw6E/xbey2fzMqCLIXOE1E4e2gVDYHbS7TzBg4j+hPvmGwdK/C9QjuHVTyoWZHim73wz5AUM+5ahoTGsTU8D0AA4hkMdzSjfNCkWrHCqRY/1PutA4X0ADT9bFLxvtyalemDvA+zDEldHeeo9qYCnpFMg1pqa+xtr7ihFWzze+K9o63VtM9lzA40vDsCUMX1pXCF4bL3bF1pdicFQUfk3mzJuHRVV8uucknNuqPuapnm3MIbvMuEDGffilhnzIz3sUzpfzG7OrpJTRDTUuB1cwaV/LqIsGtFuvQddJwHIeC2orcvkGHoy52Y7UyhnmZre9EC0n1J4Q9/VQTlFcBYpkN0Hpzteb5WBUqPjY9t2tLqm4aVcgvajfzNzL1UvHgjAF0fRb6xvjzi8CxEcoWGNMsjHoBlJSkZzMOO8RDDPdnGoaSdG8OEkWcbDJILEFdJ/8QukKDNxM3wJ/GJmFApMQqUcx03VO1hmpUPakpigt5q67sDDNEOTwwWOUpIPY8Cppiu0URu3NY/YEjwVc8DYqULNVcc1PBURnv3pZ3GsrVy/M66RaGi11pOE+KCweoPhBQa12RKynf/0cHVGQvvj86EflXIUFFcFuQ23eUj9bXOTBDy12TYjuoR5395ZqIE6IC5a/KgOWiNK2No9mJq3k9eWWcUeewEcCEgJrU8DZ
 tXlKWyJt
 0O91MeUi0fP8PrsZaOPEg1PYR5kvvoVESWp6ZQnQeCbb62LNA3ybw+b9EjC+Nd5y3+rkVlkQ9YP/M64BeNwCgcGEj2emcTzvgCk0NX6NwaPyaZYGQucZ4fHU/y2t+f29DeuBjcuS+q64g+KqT2SB0/1nX6hsMA5ELl8IJu6+/h99UHjM2Th72KtyPx3dZN6PSBPnyF5sjiQnZ16DR3JrFTFyRo7V/4nE+p7O8HD4ocYlZSd8cYw3NgTpaOGWH4L8AmDR8hY6ayqhAvela6tbRLWWp5JBlqaptLO5Ay7zo3hLKiDbYF9mlNReV0XBtQ0Z9UR6esEkfe/pOzQG6UQLjPQfqB5Mg/I2K9TpomOD1qSrfyxA419dIIeoM3V5Zaj+xcC7lbBye5pA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert jffs2 i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Also correct signed format specifiers to unsigned, since inode
numbers are unsigned values.

Remove now-unnecessary (unsigned long) casts on i_ino.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/jffs2/dir.c  |  4 ++--
 fs/jffs2/file.c |  4 ++--
 fs/jffs2/fs.c   | 18 +++++++++---------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 2b38ce1fd8e8d8d59e80f6ffb9ea2935f8cb27e4..6ef2641b39b3c66924eb4641f5c0024ae11ff255 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -129,7 +129,7 @@ static int jffs2_readdir(struct file *file, struct dir_context *ctx)
 	struct jffs2_full_dirent *fd;
 	unsigned long curofs = 1;
 
-	jffs2_dbg(1, "jffs2_readdir() for dir_i #%lu\n", inode->i_ino);
+	jffs2_dbg(1, "jffs2_readdir() for dir_i #%" PRIino "u\n", inode->i_ino);
 
 	if (!dir_emit_dots(file, ctx))
 		return 0;
@@ -211,7 +211,7 @@ static int jffs2_create(struct mnt_idmap *idmap, struct inode *dir_i,
 
 	jffs2_free_raw_inode(ri);
 
-	jffs2_dbg(1, "%s(): Created ino #%lu with mode %o, nlink %d(%d). nrpages %ld\n",
+	jffs2_dbg(1, "%s(): Created ino #%" PRIino "u with mode %o, nlink %d(%d). nrpages %ld\n",
 		  __func__, inode->i_ino, inode->i_mode, inode->i_nlink,
 		  f->inocache->pino_nlink, inode->i_mapping->nrpages);
 
diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index 5e1ef4bc009b6e5b4818a7467639fc328c137c12..f6b9d76d9dbc32f582069aeef0b73cf3c6ff842e 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -88,7 +88,7 @@ static int jffs2_do_readpage_nolock(struct inode *inode, struct folio *folio)
 	unsigned char *kaddr;
 	int ret;
 
-	jffs2_dbg(2, "%s(): ino #%lu, page at offset 0x%lx\n",
+	jffs2_dbg(2, "%s(): ino #%" PRIino "u, page at offset 0x%lx\n",
 		  __func__, inode->i_ino, folio->index << PAGE_SHIFT);
 
 	BUG_ON(!folio_test_locked(folio));
@@ -259,7 +259,7 @@ static int jffs2_write_end(const struct kiocb *iocb,
 	uint32_t writtenlen = 0;
 	void *buf;
 
-	jffs2_dbg(1, "%s(): ino #%lu, page at 0x%llx, range %d-%d, flags %lx\n",
+	jffs2_dbg(1, "%s(): ino #%" PRIino "u, page at 0x%llx, range %d-%d, flags %lx\n",
 		  __func__, inode->i_ino, folio_pos(folio),
 		  start, end, folio->flags.f);
 
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index c3ce2c868f7a33476d5cde4f1af7c7ed9c6c6c41..4ad37a42c03d8357f3ef99596b725bea3db1932b 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -43,7 +43,7 @@ int jffs2_do_setattr (struct inode *inode, struct iattr *iattr)
 	int ret;
 	int alloc_type = ALLOC_NORMAL;
 
-	jffs2_dbg(1, "%s(): ino #%lu\n", __func__, inode->i_ino);
+	jffs2_dbg(1, "%s(): ino #%" PRIino "u\n", __func__, inode->i_ino);
 
 	/* Special cases - we don't want more than one data node
 	   for these types on the medium at any time. So setattr
@@ -243,7 +243,7 @@ void jffs2_evict_inode (struct inode *inode)
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(inode->i_sb);
 	struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
 
-	jffs2_dbg(1, "%s(): ino #%lu mode %o\n",
+	jffs2_dbg(1, "%s(): ino #%" PRIino "u mode %o\n",
 		  __func__, inode->i_ino, inode->i_mode);
 	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
@@ -334,8 +334,8 @@ struct inode *jffs2_iget(struct super_block *sb, unsigned long ino)
 		ret = jffs2_read_dnode(c, f, f->metadata, (char *)&jdev, 0, f->metadata->size);
 		if (ret < 0) {
 			/* Eep */
-			pr_notice("Read device numbers for inode %lu failed\n",
-				  (unsigned long)inode->i_ino);
+			pr_notice("Read device numbers for inode %" PRIino "u failed\n",
+				  inode->i_ino);
 			goto error;
 		}
 		if (f->metadata->size == sizeof(jdev.old_id))
@@ -351,8 +351,8 @@ struct inode *jffs2_iget(struct super_block *sb, unsigned long ino)
 		break;
 
 	default:
-		pr_warn("%s(): Bogus i_mode %o for ino %lu\n",
-			__func__, inode->i_mode, (unsigned long)inode->i_ino);
+		pr_warn("%s(): Bogus i_mode %o for ino %" PRIino "u\n",
+			__func__, inode->i_mode, inode->i_ino);
 	}
 
 	mutex_unlock(&f->sem);
@@ -374,12 +374,12 @@ void jffs2_dirty_inode(struct inode *inode, int flags)
 	struct iattr iattr;
 
 	if (!(inode_state_read_once(inode) & I_DIRTY_DATASYNC)) {
-		jffs2_dbg(2, "%s(): not calling setattr() for ino #%lu\n",
+		jffs2_dbg(2, "%s(): not calling setattr() for ino #%" PRIino "u\n",
 			  __func__, inode->i_ino);
 		return;
 	}
 
-	jffs2_dbg(1, "%s(): calling setattr() for ino #%lu\n",
+	jffs2_dbg(1, "%s(): calling setattr() for ino #%" PRIino "u\n",
 		  __func__, inode->i_ino);
 
 	iattr.ia_valid = ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_MTIME|ATTR_CTIME;
@@ -428,7 +428,7 @@ struct inode *jffs2_new_inode (struct inode *dir_i, umode_t mode, struct jffs2_r
 	struct jffs2_inode_info *f;
 	int ret;
 
-	jffs2_dbg(1, "%s(): dir_i %ld, mode 0x%x\n",
+	jffs2_dbg(1, "%s(): dir_i %" PRIino "u, mode 0x%x\n",
 		  __func__, dir_i->i_ino, mode);
 
 	c = JFFS2_SB_INFO(sb);

-- 
2.53.0


