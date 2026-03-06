Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E555DF0182E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:03:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B5B26B008A; Fri,  6 Mar 2026 07:03:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 473276B0096; Fri,  6 Mar 2026 07:03:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A3616B0098; Fri,  6 Mar 2026 07:03:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 172346B008A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:03:37 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AA3C7594CA
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:03:36 +0000 (UTC)
X-FDA: 84515503632.04.F037716
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id C174A20019
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:03:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PCjBLVlD;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772798614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I9hDyhpfqmDA/HTBZfrVZFvhVZ92620TWtAahMEywM4=;
	b=jZBHA/Lr4qlyn45AxeXZfSAkNxnnAQS3vY5w6p1c47mauf5/X4X6WeKacHCMJXZC1buCUL
	Je4K9Y81DhQCRHeYCvw8fr+4mm0GDYCmetT4s3lLvrdv5f3jiJGO5lb94T7xDURU/0homU
	WIWz0OPlG4+NJ21eHlkWnGEjCDchedo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772798614; a=rsa-sha256;
	cv=none;
	b=jA1e2gkfgUc/oTv2Cgql7XatYZpV0/93eEbpXmNzN0EsRKF1rDAhVEQqTXmv1dZ/pAEI9W
	Jk5x3qsnwKuZPStrHGwlj5FlDZKaJm35Az0z9bYUzd7vwGWx2a/KH6v/FveV0FxwXWQG5J
	0iVq7/DDnXba/gCa/MeJ03ie92sqeyw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PCjBLVlD;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BBDE443996;
	Fri,  6 Mar 2026 12:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1420C2BCB7;
	Fri,  6 Mar 2026 12:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772798613;
	bh=CzoqwvSAeRfK44X4Sq+CvuqCGufXKFog8r6S8FJOxVw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=PCjBLVlDFqG1oBbiQd+HrQ8rEG3m21Qiku684yY84WX7GTtS+y22sDcetMx6fqlDG
	 LyaV2QWfjEjHKnaTBhb2ZyNX9SFxkrcFxd8xmBSw10TVnHnhS0zklAYvDZWfy1MhCv
	 EqAAKKPvBAf8/leoZU2xyvvUC2H2ff6epkVxlixuQAdN30RqgGAAANDm6+QgRlIONP
	 nSZFLHXIxiEEdhVxKiUpBs4MgDfHXlWKg6jpYf1CJ6BWin5R9K6G5kaUjvZWbwwqHc
	 /GlMSkLIs98hGrKPSpz99NUzB1chQOGo7EfaFgQI/brIj9+nBjb2M5ZbjJGNoDObHM
	 NMEjDVji5mrvw==
Message-ID: <c1845a4b8d35d367953ac6cbfcf91ac36958ba51.camel@kernel.org>
Subject: Re: [PATCH v3 01/12] vfs: widen inode hash/lookup functions to u64
From: Jeff Layton <jlayton@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner	
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Steven Rostedt	
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Dan Williams
 <dan.j.williams@intel.com>, Eric Biggers	 <ebiggers@kernel.org>, "Theodore
 Y. Ts'o" <tytso@mit.edu>, Muchun Song	 <muchun.song@linux.dev>, Oscar
 Salvador <osalvador@suse.de>, David Hildenbrand	 <david@kernel.org>, David
 Howells <dhowells@redhat.com>, Paulo Alcantara	 <pc@manguebit.org>, Andreas
 Dilger <adilger.kernel@dilger.ca>, Jan Kara	 <jack@suse.com>, Jaegeuk Kim
 <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,  Trond Myklebust
 <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck Lever
 <chuck.lever@oracle.com>,  NeilBrown <neil@brown.name>, Olga Kornievskaia
 <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,  Tom Talpey
 <tom@talpey.com>, Steve French <sfrench@samba.org>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>,  Shyam Prasad N <sprasad@microsoft.com>,
 Bharath SM <bharathsm@microsoft.com>, Alexander Aring	
 <alex.aring@gmail.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko	 <slava@dubeyko.com>, Eric Van Hensbergen
 <ericvh@kernel.org>, Latchesar Ionkov	 <lucho@ionkov.net>, Dominique
 Martinet <asmadeus@codewreck.org>, Christian Schoenebeck
 <linux_oss@crudebyte.com>, David Sterba <dsterba@suse.com>, Marc Dionne	
 <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>, Luis de
 Bethencourt	 <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>,
 "Tigran A. Aivazian"	 <aivazian.tigran@gmail.com>, Ilya Dryomov
 <idryomov@gmail.com>, Alex Markuze	 <amarkuze@redhat.com>, Jan Harkes
 <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,  Nicolas Pitre <nico@fluxnic.net>,
 Tyler Hicks <code@tyhicks.com>, Amir Goldstein <amir73il@gmail.com>, John
 Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Yangtao Li
 <frank.li@vivo.com>, Mikulas Patocka	 <mikulas@artax.karlin.mff.cuni.cz>,
 David Woodhouse <dwmw2@infradead.org>,  Richard Weinberger	
 <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>, Konstantin Komarov	
 <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Mike Marshall	 <hubcap@omnibond.com>, Martin Brandenburg
 <martin@omnibond.com>, Miklos Szeredi	 <miklos@szeredi.hu>, Anders Larsen
 <al@alarsen.net>, Zhihao Cheng	 <chengzhihao1@huawei.com>, Damien Le Moal
 <dlemoal@kernel.org>, Naohiro Aota	 <naohiro.aota@wdc.com>, Johannes
 Thumshirn <jth@kernel.org>, John Johansen	 <john.johansen@canonical.com>,
 Paul Moore <paul@paul-moore.com>, James Morris	 <jmorris@namei.org>, "Serge
 E. Hallyn" <serge@hallyn.com>, Mimi Zohar	 <zohar@linux.ibm.com>, Roberto
 Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin
 <dmitry.kasatkin@gmail.com>, Eric Snowberg <eric.snowberg@oracle.com>, Fan
 Wu	 <wufan@kernel.org>, Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, Casey Schaufler
 <casey@schaufler-ca.com>, Alex Deucher	 <alexander.deucher@amd.com>,
 Christian =?ISO-8859-1?Q?K=F6nig?=	 <christian.koenig@amd.com>, David
 Airlie <airlied@gmail.com>, Simona Vetter	 <simona@ffwll.ch>, Sumit Semwal
 <sumit.semwal@linaro.org>, Eric Dumazet	 <edumazet@google.com>, Kuniyuki
 Iwashima <kuniyu@google.com>, Paolo Abeni	 <pabeni@redhat.com>, Willem de
 Bruijn <willemb@google.com>, "David S. Miller"	 <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Simon Horman	 <horms@kernel.org>, Oleg
 Nesterov <oleg@redhat.com>, Peter Zijlstra	 <peterz@infradead.org>, Ingo
 Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland	 <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,  Jiri Olsa
 <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, Adrian Hunter
 <adrian.hunter@intel.com>,  James Clark <james.clark@linaro.org>, "Darrick
 J. Wong" <djwong@kernel.org>, Martin Schiller <ms@dev.tdt.de>,  Eric Paris
 <eparis@redhat.com>, Joerg Reuter <jreuter@yaina.de>, Marcel Holtmann
 <marcel@holtmann.org>,  Johan Hedberg <johan.hedberg@gmail.com>, Luiz
 Augusto von Dentz <luiz.dentz@gmail.com>, Oliver Hartkopp	
 <socketcan@hartkopp.net>, Marc Kleine-Budde <mkl@pengutronix.de>, David
 Ahern	 <dsahern@kernel.org>, Neal Cardwell <ncardwell@google.com>, Steffen
 Klassert	 <steffen.klassert@secunet.com>, Herbert Xu
 <herbert@gondor.apana.org.au>,  Remi Denis-Courmont	 <courmisch@gmail.com>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,  Xin Long
 <lucien.xin@gmail.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Maciej
 Fijalkowski	 <maciej.fijalkowski@intel.com>, Stanislav Fomichev
 <sdf@fomichev.me>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
 <daniel@iogearbox.net>, Jesper Dangaard Brouer	 <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, 	linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, 	linux-trace-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, 	fsverity@lists.linux.dev, linux-mm@kvack.org,
 netfs@lists.linux.dev, 	linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, 	linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org, 	samba-technical@lists.samba.org,
 linux-nilfs@vger.kernel.org, 	v9fs@lists.linux.dev,
 linux-afs@lists.infradead.org, autofs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu,
 ecryptfs@vger.kernel.org, 	linux-mtd@lists.infradead.org,
 jfs-discussion@lists.sourceforge.net, 	ntfs3@lists.linux.dev,
 ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, 
	linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, 
	selinux@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-hams@vger.kernel.org,
 linux-x25@vger.kernel.org, 	audit@vger.kernel.org,
 linux-bluetooth@vger.kernel.org, 	linux-can@vger.kernel.org,
 linux-sctp@vger.kernel.org, bpf@vger.kernel.org
Date: Fri, 06 Mar 2026 07:03:15 -0500
In-Reply-To: <aamSFgXhrORAJLBC@infradead.org>
References: <20260304-iino-u64-v3-0-2257ad83d372@kernel.org>
	 <20260304-iino-u64-v3-1-2257ad83d372@kernel.org>
	 <aamSFgXhrORAJLBC@infradead.org>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Rspam-User: 
X-Stat-Signature: jgr5f49w1rwmxrr6oe3ztxfk55dciizd
X-Rspamd-Queue-Id: C174A20019
X-Rspamd-Server: rspam03
X-HE-Tag: 1772798614-471106
X-HE-Meta: U2FsdGVkX1+6ARnAUwQODx6OfYGkE9QEhYP+TzJQlKDg+TG8mvba39OJvXHKsqcFu6tqVIaHmgZIRLdHoxYK3sfnLb6BvXxF97UssI4kGhEAVytsz5sDPDQG7M9UyCSyOIcYNwqG650weV2hMM+QhWV259e6OcQTI3NWF/Rir7+8G0rbGmcGuGc5HjGQovx4eeeYQY7MIkdYN/QYlBRA4js98uuG1mIDrygvDEgW6OMBsPtQKgRx1vgOZwPRkT94J6rfwLyyAIXXUDaPkOlgsIZxt9/ij2R/PKM2xW/EcgrARze0MAl6RqyLbyqDJHE4l2t7CAk0o+CbVPypOFvx/U/Sws3kYGLfaw7OyLfBBsS4tvZEkqWixUsIIGTaDnwqFvGsMnQCzC9PBa3GJZNA+tpr4SoVg1r4IFI/kqWlCkfsH0gnQFl1k5AQLJ/5EHBGIjPfsCx4XTLv07PNGd2sGQ9auB8SCP+Mp1LxVdBYQmGsqH28Wdup8Tl2Ut1FHPr658dqHxEZRxd+GKTEpAAOAohK54eR8nqIaSSCvhtAMwczEeyfurX77YUKttVQ0ACkExHsXckDwyo9NNoFGPW8kA/4pgSGuk+VWtOoSW6k1AoxbGoBCPNb1QkieAY9lFUkW6V0MyZFAVhFJWax/oIGFnfF2C8oZGZIxWhK33NaGEL29c92IVd4B0wei4M8+aGVeAEuCAKpldMMyJIT1sROEEgmDrHlZ2v7sWOYCcCKTIe3P/0q+KruvwCVyMWPI2+UOFl29fQJGmyK+KHTtxJsPZr6UNYI/M/cHX9vF1066zq8t+tuadl4ZOFhTlWLw14YjGK4gkoFhAYFfpPC66fPwigwU0xjd62n7iqZabbLfVYvDoNbIquFNLhNtdjE+5KOpWn8mc5QQU1qj6Qxnl/SK1cmUFJT0a5sE2CJFeNJLUtETFf9vpIko68WR4swvpf9+ErEdcGd5jthTM9b3gD
 Wg4gPNIV
 WR5AdtxN91jI3k0XzRBk2L89iDHp/pkRdZEHVOCSj/JdV6fQ11juu0yNAod9+1x2PNITCU0tUD8D57QvGEWUouW3Sg1NDffF1wHFvJbLd78rNl8CNKZobEiYWjaGL2TMZs/Z7/PrXrNjBJ9CCtghjMSh2Z8Rcl4bePbWd28xOSu31GK50pfQo/M90CqDhipH7Yv+fO5ceVQ1nnHVGvqtEW4td86VNZ9d7WzmZ2OlCn5QVctymaH54TxuygzJxuZyJBLeJsu4cf2AtBejlcDwO/49Q9I8UIm90ebPZ0e9lChculHufWsvA0Z0xrE1jUvbA01oQTSYjE7uLvNhj5MmMyVKfAlrBRNHMsIwrN9d41qXwlP++qNEwW8bkSd2uOc+kfoRjzwVyQyxKmeRN7W4TujBSJwNWMVE8vajUv3bIqYHCXu+iCEnmnol3v6goYWSNo0MaXn54vqQGUJEb0jmfKBcMsHuf3ZdqA0JpS6191fnSDGI32g8sRvzlXH6x9rTmIsl08B0jmV2qUcnkhIrJxTKwjiOV/WItSI9HEkpMhg78fGNVVcrSLBhtLcnJfmf4lDFoWXli9Rq5Ybf9sHZV50tgMp8+v3KL/X0+fg6IwRRc9QVdpm7OZtpZ2uon27ULX8AWmjPRgLBH/hJMvhSjzB0ax9r/+IxR75VjBH0rM+Z6ADge3Zshs+X7YdBHWaaI22LYfhEJZd/trxX2hj4TpR9hP+FQhkhdpq7y1ovQDHsZE7hWTsXlH3MnrYU0eDvYDGyjOje3CToxD+JFviD68iIeZGPhG9noleCgeipIeGs2fwXgARVG0NIEfKhBT77c/pui0KDaWZrubiP1UQMv1dBobBQ/NFdL+If+zkzY+y2Y2m6AG3rRkS+qx0J8uIZP4eOY+MrAd9WXlaXrcMmXhOE3roPZHBSffZoqsZK3cycjE9xFtvfX7+8Nj6+JKLu6uPjR6yupKJb7AAohoXai5FUUGQ19
 oRf9+ZDs
 VCzPTutaARyDM9WwT87awHY1FLKwUxF+zHs5IAJcwg/8bJ20frJtOjro2I3O4cbkhnjxUK67RijCg4wHqaLkLucn40dgIG4GS8p98Dq7Ikthc99MFF3CIZ3EZR+VrfzduV9wkv9q8EYea5Pv88hfB87GMybSRCKq2ZcJx1AnYT6JLOTH0D+t4Myvrkn3xTx0GK0zjiY3pKZwJWz+Gsltd4jW9wsSqNw7PA4DuRSMRvvAH1/O7kGir7YU7kPnx4Sd86IpMQPLt29gZFT569p1oTZWLAVlpnTTnG2buLJw8Y1S8XM0CIiQ2DyozhyDU2HUiNtLxCVTL+pmaR8KEWiqsL3URNH2bIuhv8FsKGZSh+I/QJEiOHGoFyQAQOaRO4dQrvE18WjjslsocIB8409QvOyRSAha1Sj32X1F5DSNWv3c577RhUYRS/nbeLvyGqeD2hp8xABOQBgtXKwAZwzXia9QUs5798jjzWcMlUzQ/y4SIquM7FVTAqaa5lMFRk+OlKmKZ1vkFX62wP44mtdQH1oQk0o0KHvkmHps++wkP6pJ9582BlmtH3otKTIjvjiKxc0fK/YxgnSRa9d+XMfWyJeEng4SSsYGFuTBtCMrRZVuRRWuwL96LNaXTKwCd4rOzPs0i/ftQooOdzmBQPbtQwVJFmNtARQN/AeWQdNQP7eYM960Ru+jIsFO1zCyp3UCR8jqToyP3Gsr8C6otTVZrNhOi5bHoqpFYVVycKGStGd9j/HbH2V4z4ydpbXvUNh+3p/7eqpjd6Tg8jcThqC2tWzpyUBFwTGzouO8c6Ua7L9dDBdxGpZeD6VeiNJqqZZYZvA6hreSLUEKjNIIDfXVI9XBqgQWV8KIU0W/mqbQYvtNGKQcPOJBIdHXhvX9Vs1tbiJxrnQW8eskFTE3ccygis53o1HGUrPypxVQnJ6YQ86JGX2KqteuszgInqJ3U9nVz6/iamc5+XqxhQmBAmpTNiMpiUnrL
 yRVDtZjw
 +5c4MxjtdekC/ncjLAQ1KWwcTQvGi3WkS+9bkuj3dIiB3UBdoUVmzieNbm6MdaBRGIsQokAbcCsmu399LRc3NZpmzFWVGmZaSJ/OOc2dggqL/tlMTGTBCGxgiRM5hYYV6jDlARQZSDECBriL8ezxBZgh2/8sB8QJowf8bL7kcU/ORy/En+PYyXUYy44/qrEMQ0ZyndGOiKhw82XtX5+j/ki7Ny765NmJnCqAHDAlsrzqOhPgVe7/iECueJIGEkims07TzxhdNLZKDXi7x1d/OEZ+T/gSohqARdfKmCP2kQNWZhiyW56KZLNRLWmRZLJe87b9JjuzBhR7PzXZiJay/hzwHNMxxNWJ2Y5NVM03fMvVnO+Cadyv3G8g6AqH6bpe5rg5aKUaMglQ1ykjTUdPCRIty4iugcAOIj2cukeEygHb4VeKWZDSVufkvKNSvJUmOQBALgcbYRPVX8AlEM3/Wz0ivLRYO4ebccleg6HvheTO9nL/oVezdf/lmvrCc2zhH7uLRY8CUWIzncnkoXKS7XDFnz5MEJIEyVL3CFHTB5YbeCr1NhoOQZaDQUtn6CgXocCdMM8A1wkl6kr1pMIpjTjGLSd/e7VZKXGnhYVxWBpWVKPRAQ1mNtF4H0MaxF7j2mbLPk+sU6XJuxur+HUNv1q/15In5VGxd90NhGR95oqzVRfcZHojxZsbjjHjwi+C0v3nSbF+ePK3U7KipPr4uO/1a7bkCqOhlrtBtLi1/4uKQOpX3dJ2lgr8iTY08VfYiKTBLOMXIWB7Jj7NCDgcCUe7a9qW1wO0wy1qzT9CTEez7PXneRoNxdDAWkZF3bWaA6fLQZZ3gvNJdzjxV6+L0eyrV3kSPA+lQhzr4OL7y6Tbh+Cd30P486nVnvS3wHJk6UGhRMBMPM78PkXZ9PgVfbv3AnS8aFqJBRoruKYYeuwsYD0CnydK5bMnRED+PuFXcEj8SeNfAKBw6UGkZqecApzftEb/f
 AhlyAAlL
 er79R1K+CHdiq8+V6zzzK2dh1a/nYykcmNaAiLRBOHM/Sc0YcePCBeyAQMM2EwN4ODLgsfLf+1DlgErnLQpZVyOla42WNsV0cecNglcjgQgXxiJ1QX+KnRAMAOxsKytNg8S/D5XjS0nDWUi54d5rJ2AK2iYS1I8aINeP9cilsUgWUq6igjRhC91WngiZQtteMFBfSRjay9cR0c3MAEVJB5AoRgCa7v7833tzjUswZr1XSSkJ+ixp/lsFwbcHfNfyZyC23HjoG/HB6/E4soUW4TtZySmDaXnVvl53gREZ4qpvGA1OCT3QZknCVP57jfh9HztLjaCVYkAvTtuTmoWEem9KJCLkJ+d4fhxOonlXy8Zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-03-05 at 06:24 -0800, Christoph Hellwig wrote:
> > =C2=A0extern struct inode *ilookup5_nowait(struct super_block *sb,
> > -		unsigned long hashval, int (*test)(struct inode *, void *),
> > +		u64 hashval, int (*test)(struct inode *, void *),
> > =C2=A0		void *data, bool *isnew);
> > -extern struct inode *ilookup5(struct super_block *sb, unsigned long ha=
shval,
> > +extern struct inode *ilookup5(struct super_block *sb, u64 hashval,
> > =C2=A0		int (*test)(struct inode *, void *), void *data);
>=20
> ...
>=20
> Can you please drop all these pointless externs while you're at it?
>=20

I was planning to do that, but then Christian merged it!

I'll do a patch on top of this that does this in the range of fs.h that
the patch touches. Christian can throw it on top of the series, and
that shouldn't be too bad for backports.

> Otherwise looks good:
>=20
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks for the review!
--=20
Jeff Layton <jlayton@kernel.org>

