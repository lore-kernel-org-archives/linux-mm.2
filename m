Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E654EB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 107E56B00ED; Mon,  2 Mar 2026 15:37:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CF666B00EF; Mon,  2 Mar 2026 15:37:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBFED6B00F0; Mon,  2 Mar 2026 15:37:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9A2D6B00ED
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:37:02 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 79A401A02F1
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:37:02 +0000 (UTC)
X-FDA: 84502282284.04.DE0221F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9157518000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:37:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B9vuT9Sd;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z26biHBCtHWjhOtU+0NeOIb9tFIvKeu20ipjOVdHSV4=;
	b=C59wtT2lBGZsa0EcK7jLpVT/jbJ2VrdYA3d0z2TByj6I5Sp0Uw1VM+VIMkU9dNnE4mPFdL
	ON4jJ5mT3yImd4MflU/BcQ01kX0I98LC2Lq1NW389FfGrq3uPH/LJ5ZiInsES1MA9wTDS5
	p/rZ1TyabB+Z5bSCHrNx9vECKuRVeXs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B9vuT9Sd;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483820; a=rsa-sha256;
	cv=none;
	b=b1N4bV3S2sZjFJNdzkFkLA2ERuuhBU0ZpXbabk7Fj6eGvWUQUuVtiba7wdjs2XM+BeWFP+
	Nw42W7xH5TPpKi0dBToyunrPBda+iBhPK2kAmwzdFWLMakJRPRL/CltDjxQmfbCxrV8i8E
	wtvocWnos8rD0nxbxjvUZ0J8dd/V3IU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A747543F3F;
	Mon,  2 Mar 2026 20:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A117C2BC9E;
	Mon,  2 Mar 2026 20:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483819;
	bh=0ZE73lCrVEdpMXz91AbIXmMh1XqQRzyOg6foj3qrPFg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=B9vuT9SdMGIoze9C+yqVn924bJJ+P/cFYMS6dixpaI5Btyb/sfbUJp8vwEjCPXFiF
	 Wmk8b6d4Axkj6LczBx/A/OoW3u1aHAnxcHJdbIsYggfPkj2YKpPbtaS/8r+efGtClW
	 8H/hAkIZkrIY/5sQQSYKCjNVm/qeQgD0wGVvUEc+1ikXnv04zuqRFju31Hcb99Acf+
	 RoVPQXBDoiqz1kshO4InItYtqH6ICN97dgbrf7T/OCW418hsz06O0t989B2uXdGYcy
	 yESxdVOw7NdL0gBdMXC+eip8AmrHMKjU0yfEuICWHSK657x0Psg3TqwaupkEb+oNTt
	 DPGNx3BwIGc+w==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:34 -0500
Subject: [PATCH v2 050/110] drm/amdgpu: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-50-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1231; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=0ZE73lCrVEdpMXz91AbIXmMh1XqQRzyOg6foj3qrPFg=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH8bWEVwsBbOa/3fhQXi5WtIWQ3JhiCAoIem
 86pCTSDgfGJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx/AAKCRAADmhBGVaC
 Fd7JEAC4rhc+en5RK1++F7YzWXknLhX6D5LT7nLIWMuNPlNshWUqaUZgLyrGqrRxvONjVg6lljX
 w/XxprnxonbekUKFhURqX5POoQg7A7fly0I63bfHa582/Z44VdFqR8dJfc4rlKNLrKXgHXm/GHa
 eREHxVCd/KoQ6okzPx42ZNo1EgiajVbz9rRzAb9FnLUemaXHJn8FR0GZNpHUC/ZCtKNBrQdQHBz
 DBRqngy6qSL5zK5nJf3uIVMhdc2wfh65Bqv/L+kBuRiAXZzBdSFa8d+L6GjuG4HHvvHAu5aT9ln
 kBTohpygzBp+Lfi3Pbkigv75oeLO0BqvpkCe7/WOjwzbGGM1u70iFGcx+aJLcT8dOyGBsd18/fW
 5qTXdZ5DqeKbeLczod/TumsCebxfh2wOI0Fp4O07ncbj7dG6RRUswbkWgvMa9O7hGtrebzvJa/e
 I6MIfMCMBRO32PFvsFjGfdF12IS1OqtD6boc7kn8yOhn1M67Oy24tV2rqoM6wADl8VSG/dcj72s
 DV2GMyXe8bmMXE/zXxXwNMqRHMdlJUqnyrXY+cuNlsdhc5WP3hRRyqrchkhS1Kjk35fOczwuL2Z
 F4zLOqTUP0EwBDdlSP1mhpuR6DxSpllNHXjKclV91I2uBWHZjKbczXkJHACIGsmkn9Wn8lc1opU
 MWMpr+08JwGFnlQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: 9157518000A
X-Stat-Signature: o4i9tr4i1579zu6qjau3kfcsf8nmp98s
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772483820-964605
X-HE-Meta: U2FsdGVkX1/CV1czzyUqngV9zRBfPDkOAqhWSzGwuTOun2a+GqdkDw7FIrSZMBJchWLsLNr96YWdv97lVGaSZRzOHWtKZ8vmRqIbyFyFRDbbY89hfg7xfn9or5ltNsxfrPreOXprFAzHFXB4h2uX3q7xcgKMFiP5ezKMsZodXhW2188qvCmbtDGdOKjL2khp5MZ4tJJn/f+jpJACTCt5xylTcJzSTrZLYJnPLTXBThnnsuQBoCkthRi4eLmpClsxxbOY+5zLu7ye706U7dnBCqMbsq7zZ4/oDZOAJMFf711z0Yx7LUKZ/VPX7auMf9t7giuwyrBHAw062ed10UnDDTcB9IT9HJYbSbNH/HmNqZYPd2W/k2fEp6/ZnxLcyIm2OI68oESL65gaWAzZkb1JkzcoOP66Ktfy+UbRnhZvzogrK3h8UjH/BqFfPKHgWgwr7XCC083LsgJQrgfgXR7s7gX/eo6unZQNINSMKyXchO2YWoqFOyF8qLDIHOmU0x2Ek2TIJxIJ2R/Xk1Us0rop+S/tp7/cNuoRHI4eINubKm4QtNuecyER/TTjRqbPd0k2cziPPpD7pLesVwo1jerh8DfwU6l1SwFiw38lepHOgGgtJTW2RZQZnevb9OxDs509tDF7/aTMXv3zQi0bvyLKestQIcn1Ynf1YNzUXsZ9ZMW0Dr7WtZQez4wvsPD9WBgwdAQ7Hz8qDBdjsts5YnZfyFp6eVNh9BNPHokSuFbkAFlW4VErzLq9puHgU5oiOFjfXBG9RqxM0xVBlU8obwVRFiN+odhFqT74fvGXQmp7+BENlZSRZE8Yc4OLWXxaeF0BqP6x9yNwz55pY32HVu0h/6TbHNfaiY+8gSmSOzKaqGSi+UjYziYxwTktmxDZm2xHBWOulbhG8YGKByo1Wxb6rPtZIKXcSsv9BWBfNv2F1uVXiGS3e9rHejMQ5dIoJMKpQZOkE6bckkwISj8pPA2
 JRakO5+9
 ZsjokZskrihOe7qda/pKvcR6ZWGYsJ2zczmR5OMykAiSQjO/kCIMKqCpzHHCrRt8fJ4eO0ukbs+HYT+fVzMC1LlEidwu8XE8FPyFZPZoauZ+XeJ2DttoEjWOg6ghXR4T35TeygkQEZljAiRQ/1jcG8q0i6rx7h+cwrZd0ojyGds//MYTFlAIm+A3ZJ4fuznQtnyh8ddZMQRqi4dCQYeGt+O9Yu7rI3+49bLDKCsozOpqC4ZXM0TIpE7/UT3FezfA+HwXlDSjeZAGEsSVJb0E1fSGNlx7Sdoer3c44VO+/WuLuT2GY7+sb//QI3EPNuLix+s1ieyYMBQ9gSUbczjPKXc7SE7K6xOYymraQnw9t7YlXHCG2FUTWTKwNKhnYabRMGCCBUvbVeBDw/BifdmfI5+8NEgXjimDWEcBWErmp/GV/BaH6nO8FaQQr695DMt3g2OeW9cuB6ljwOGpXCbm600JCQ4h8/o0Tv9QGYK6OQA8kBhs230wI5dADpwNGjylwoiRLZHRNafOueedkG/vbAznRXixV9xpcGFiwrj+EjBIho/XDqitfa71hBHvbnh5c6NoQkYhrQf81O43uSKnQk0yNgQaWTodluSq+gF3XWQ4aCAFQaj2kyW/TUNePcUXmzIvn17krjkk9VCqsf/w6CspaJJcAFc6rTbkVpdium4tAjdZgJFE3BmhWZI4rPBSliYrJjg4sPaXMbHfP6ObY7r7lULu5oWu2vwGCsGqaNdzOL57vZcazzpWAWnqh5hKtkZCMQh4f+bjp+GgT5+cOpVWAL7hX05FOUUwHYBbizDtDESMkkSlj8TlsdRdTWRIG6J5IrJLJbOpMsOFhilv2mFij7Omnks6dZH/3lsHRExnMFvhpapi9UhfIg1YRPaAl9xmQcKCHoW5D0TK8dk4qFXxX+AQdsH1B8RuMzO5JGEccz+ZVPIHO6AU1cmLTVZG4L927WkaJSXHlnd9n6pC4W9+VVR/f
 j2I5L0vt
 f54jFV07VdyFCaXS1ktDtcVrTdAjrE86Rneruw1CdAvn1Oej9/E/zoNuYDxD9NuQddqpLQcZCucPJctfyNdKbGeypL4yFmbv331GXdzB2i46v5CNd4YH/MKzoLWcLARfK2ESh2YNVhb3KDOMVnep6r+LK03aojYsBn5C9Yd+kprSImNd/UE0E8Jp6f+SNwVvOHyIXnufkDnnYrsPCKDW7k4qwJto7593hnz9ArJNW3+w42uhVjzalUf5YwMS3e/7by3grib3yjXrY6VQm2fecwUGlE3TVqVcYxpkEQETdrfuPIjhTrj0Oru6RUpKWaRvKvxr6rM9SrV1GnowTd2yx0LpgV/vDm+RxR4DKqIB/a7dr/skE4zkXBZchtif9UclnKZfkJZ/ZCfu+BSJhs5+JVW9Jg7Y5gpxtwbqbQfWmVbePT1J1Mv45fIq6lTZO8WPM95ihSyquY/GkiCKnxir2icptS+d6DLrykVpg0FKI+tMyUBdK0zBAs8HS8m0HMeA5cU974b8nN7ZIzqyX8SFf+JsOAy+BuukWhMw5sLsYNNNQj182jVvGj2DYGl837B2qBDNd79JafjfGba/ANEC6E5v3L5rb8+wkGS5wUnuVwavpSr7gtLftqME2CR8EYBQZspe3b2vW+YzQUUcW/Mr/hxYVe8UkZwB/BmH4Vf5Ln7zaYTEpAkMT4xj0RD8wAEYXm2Av71VeSblWudAXoyhJand/dFVfNcsYN6eq31VMPLEKoeTGF0NDrdzFhySTqqrAsp0hksYBKLyNJE8BPOuInxA8C8R8yIQsFq9e+Cx+S1QZVtnfF1JXCl7VMZdWW3NUG8gveSbLo8y3d7uCZVyyPIk4YAH736+ORAE87VI9wSiAjVA4IEq9fDWjBs1REJR8XhsHDuiwhAVhpTnj0C+uJFoUIjyPPP5692sw1h/U7krWEwNQG0xTAic+4rO1UDk/GQHqSNzQSbjQlbeYNBm57FEqCEdP
 3o5FdCvz
 wcZ+vlQBF7gIvA/0svSKWxWV5jRkAM7hPthi3ILIhCIjmhgo+mBLNIXFu4JSQgO9YP87kvhasB9Y5y4+vfY6J/JtPTUG6kTqTd8GJeMCEzqf5F7LOdp5iV2xNeZM87F8t6R+CcKVcwepUIdubVFmiQuWmTTtbVDD9AfTy7q1H3Wpqf4TVbakc+34W3enyY2cRD4g+Tp4CEP6zqMdWU5vi8p81nh7/koeCHGdJyPcUP2fXsUESp34Wsgj8zlS0QNIqKN0zlzrrzSkPveQgeOXY/EDQ7x8FWdwXy0yBvlP/R73lGeVYghfE3R1rKgfVJ5qyCMQgXVk5da+m/NoE4kMiDz3AFrCe23GxMWP+l85cseDcKWV/4H4EQu/KBZwUBkHWV6wrkZo/TfTa6cANSE7sT4yg7rkQL5kqHQktNw35qur3r7g1qJrjtXbIWUqtmVrFBB0i/rR1lPjcnQdcc8bPFo18cFHhmbFW2GHf2ifOz+G6GZZGQ+oewSFQGC7wq6iV5AEDG+759q0SxwzKStkBqn/HbOgfc/rFO0F9X5Lwo5XqHGEr2Rgt0JgL6cwBhPbdk9pmXVaiP4JFjreDk0fbhYbJbK10/eRg8Q4g/7b2AQ2GwH+/GVuSbVP4nzalATOudEFk9dnu4r7yiqmpIQQeSJ6g0aRMvhU3VX2qgcA6MMg2PqtcqhiNpdV4BXkvRQBGoZsdkfllNKbjgCRM/mk7a/f6YhuLi6Vve/MfDifADMMqXVyYeDJhWv6BFc+xhkz/+QMSAUfHViXePtO9A70+I39Wk8xNUOh/Coy45uepk9toW4hkKopJUpcz/rgMECX0utgKhXSwqPi3WdfTga/GlcrpvSBEPrKak5O8YecJZRat5BoPsmKUYYeLMGlgiigDrHbVCMyivtW1Tfif6LY1EIE5p665vR2bddzpo8x9k1UfEpSuxyqL0kvMhcLmSamU1wjKnDVzYt07MdqXjIG24kOGhfK4
 XThtA33y
 gCXR+qPcP3F7sYzbbZ8JIndWgVwCu+lOMxTRUuiEbnXkXSLKin+nrZ2nUOU83T2noXm8T3RWHBXcnnS7MzzYQtExyVJk7aKIjy2nZRVkQRVCE4FIQzs/8JaNhj7XhsMg2VajYUlr/dQL4RrWBVVMc3LLUPQFi7jYTTo/hg1OlC40oMvD2mVF5it1vJqpm59v95rqA4SQuTlOniadkM8uVorjM6+84A7VwrDnsoExYR9ZvDFMERYW6GJkJR45p516UX8h0pt3e12AYCkQ8jsoGp+G60xliQ1YkbFtOb0MsPOK7TLeEjvRzvvQmrowVY+hnQW7OjPXWqUCiYDXQk2z21X+XVIB8jXk3hbPPAPekJvS24kW6rqOoIKYRP+ehpXWSgFk1kjfsGMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert drm/amdgpu i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index 1fb95640069667bf731df05990b57c6e0a0d2c16..d62f7cd1bdd3643803a99c3cbe35fa5b19217eeb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -1676,9 +1676,9 @@ u64 amdgpu_bo_print_info(int id, struct amdgpu_bo *bo, struct seq_file *m)
 	attachment = READ_ONCE(bo->tbo.base.import_attach);
 
 	if (attachment)
-		seq_printf(m, " imported from ino:%lu", file_inode(dma_buf->file)->i_ino);
+		seq_printf(m, " imported from ino:%" PRIino "u", file_inode(dma_buf->file)->i_ino);
 	else if (dma_buf)
-		seq_printf(m, " exported as ino:%lu", file_inode(dma_buf->file)->i_ino);
+		seq_printf(m, " exported as ino:%" PRIino "u", file_inode(dma_buf->file)->i_ino);
 
 	amdgpu_bo_print_flag(m, bo, CPU_ACCESS_REQUIRED);
 	amdgpu_bo_print_flag(m, bo, NO_CPU_ACCESS);

-- 
2.53.0


