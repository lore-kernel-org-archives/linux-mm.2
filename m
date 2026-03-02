Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CE26EB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8236D6B0098; Mon,  2 Mar 2026 15:26:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E0CD6B0099; Mon,  2 Mar 2026 15:26:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664986B009B; Mon,  2 Mar 2026 15:26:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5416E6B0098
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:26:30 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E650D564A8
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:26:29 +0000 (UTC)
X-FDA: 84502255698.10.3292C8A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 07A0B4000D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:26:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gZESrDHF;
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F2EFXBW9cw+4Gcm7rvALn3mSmsNRosffOGrAbthhfm0=;
	b=nwI1mcZs4ASsezAwbgMnuPC8eXsBx17p/b1eCovK886+60YhvP02IGsUwY1pmai/bW92mH
	bnjw5Ib+pPVXBKqzBIZh8k0/QxVEZ0V0uXMydYByYN7E7XzSO2jTEXFgYzNbDPGMGOi5uY
	MVOQ4tMziduhlc7qX4/10JM5FpcRrQI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483188; a=rsa-sha256;
	cv=none;
	b=Fk9dp3GcnLUPvlTTJvF1nru8W5xcaZ0YhMTalrgqsRF46mHOAXNJoiZgJ8ksjPNu7HeXco
	bVoRcVdT9r+EFlQk9y5PNqJlugoYiHXzvm67a1muOnaQUlqD/G3fAeuQc2+x7M3vng4oqT
	38V38Ve4vlpG1J83pCEhB1wtjMaXqBE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gZESrDHF;
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2559B406CD;
	Mon,  2 Mar 2026 20:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16CCC2BCB8;
	Mon,  2 Mar 2026 20:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483187;
	bh=eoNvK5Yl7SeIQgq9YrEwF9MuEybDgaw/cGTOe/274yY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=gZESrDHFBopSybBDaCrr/gadYhHmmqGteyjtsyw9Pv1m1XE6MLR/cdhwN0RnwNFCX
	 QPrCN5JSpeWOwodlWI4OQoNjzrc5vHUaGjO2R8dzz/MOqJGKpmclBoUCuwxHU3vGCL
	 +70+lpClDBk9cuezXISD0YdDWnhmpbXqHaFyn5wOKnrl1NqphXwc9iKmGSfeqobEi1
	 l6maOnpOdK1oOk8r8/lcVzrZtBYJX61HKxrTgPal3sbXhizaPR33lnmh/tdmaWhaLj
	 hEnaPacjOr2dqigfZtNesqwNm+Yl1BP/O5LbH0tfBVx/U5/dXCsco+Za3w/B6J8LkS
	 mtYyh35Kv+06A==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:23:50 -0500
Subject: [PATCH v2 006/110] trace: reorder TP_STRUCT__entry fields for
 better packing on 32-bit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-6-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=13682; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=eoNvK5Yl7SeIQgq9YrEwF9MuEybDgaw/cGTOe/274yY=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfHwneWwRCtH37qDPSjc8Wo97edXJDLDHXsih
 RCid9s596mJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx8AAKCRAADmhBGVaC
 FeXoD/40MQDB8ZGY3bAmS4aZn5ULoTZ7fhEUkxxa3aguvcw00rG2zuF/QNLGsDtg4gEE1YIGOg7
 xDxs5j4PXMy+C+Snbg5wk+/G/TXdL98RBqUJeZAsaVfQ+C+vVeuowoIxyY5WtgZmXVdQjwQrRbZ
 Tnz0m6PdPeWy/iwJGXMpG26DhkYKaKpFaC/D8alFD7tZqrIQhBeL3/HJTevsTAJJUQr19ohUjFY
 vhqACbzEwStOkD7DyJHw+1pYJTP2uT3IzOgAgiROmYyrGW8F8TwjIjrRp66I1Ov0fnjPSPzkJst
 9+yium6UMI+Oup1WDiyc9FXahpKE1uX3b5kyPOlnUeO7oirOc7www3Cyp6L+tNhMfUB5aT4F7VK
 +CMvIKE2OX+IaN/pMOKc48PLUb3GwfVRMjz/Marq/QE2hMuuNWlWVuO7eI0MVk3MtXxeUC0/Puk
 w7sX4hWrKYPEO6rr/KdhRp5biPoU7ezh520WhVEWmCjAQ5jHs7aibCAk+q/TUjXMp5Nuvq8ON1E
 1MigX6VhzzLKer3JNYYOGpndOkW5GlfF3gp/35EeeOa72WEkbs0B+VRblNznDCUD7KDC51pQUci
 m14ODDyp/XhBlXNdVLeMolvVzZBv5q2BWwD+8uhjnUY/clrz9z7+e4IgpcRcVK21zO959Q9AD7q
 idB+xSxglbMDOWw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 07A0B4000D
X-Stat-Signature: gdz6938tacf9y616qsy1aic8hg893agz
X-HE-Tag: 1772483187-419621
X-HE-Meta: U2FsdGVkX1+1FgX32lBNoY1/LGnT7cDHHuW912+k2ZWohFS3mt/C4QEzDfTIr6QFyB74N4yalckJfZUL0a21T/2FWK3/h5reMvs4ETLMv2NnraXEJIoLhIxmBgn4srfsdsCNupn2ADGR7p2LvpXzS6cHIUcbKL7fn3lCz3PqVwA7rHBP9QWbXCnuAdBmPvDZPo0LA82387/2uwO63MIN+HXgqv4KxUJwkEPlVulQiKytzy/Lo13U8CIis60eH7NHHw4eQwjbJboChfub5owPVdQFRAgFyJl6zO/1X8KlvpMx6SvoXpCwgolpaH/adDTvw83QSdw00AmVhB6p7rt52JNTA4Ur+EG4nUH4/YPdTnf7CWN23V4smnWvBvEOIFHfXgmhTlPc8PreI2mlZekepPMki5Ktp4W5oGIduvnsSYZkHtUwGB4unxiuHSN0EKjMdDJLcTQiTGRc/D4LRKTzgz0EGEW+tF2VbHag2d19VG62d3xqnUl/JN9Ks/Qddb3ZXsQ4T5wZnQbmLolx6IyzhLBH5JT6klPnuHM8rGWyYyZaiRr5NdERV/J2aiJ//TIKyeTEhq9kmkMYLk/MAgVsUFmt6CNkuP6R0gf4E8KS4m3b+1XiWzeRIiqaCIapihsq4iizMcR9aRqJdnSObSFa7gQIFTR3JkTEhOZn8jYB5yTIElRI1DozTUnFuGI+pbAq992dOfyt/AVwplESoU4DTupWQSXcRndptLSukQIvfIm3Z2MaPw80Eszs+bVBU4mBnm0N30PS6svJNPJDyC7N8AH2TmUYroHJ5XX7HY1n6BXxP5zofjilJuifDudhB6jpccpybHBomNKosfyXrkbV3Gbn8Mg++Frp/Oqjq+gdJmLGdYU4/O0oJ6ULR8GTAD/AiqbJHgD8GKTS1iyqrdpbWKcimG8ueu1Gy1CHCBlEC6j2w7TEKfPdteYbcTESE1mN7GavT/wMzmFAQLyxHfD
 0Jx3CtmY
 28OylQpJMQhWpPAdbgtp4G40tLyPA1pEICHizxDyDPbOo7Xt8aYNu2zGapszvMe4L/LyQgo1mxJHfhxFx9Q9mt2zj5QUbZPADAbiV4BpUiRJ6yROGNSbbSI4nCwBa0IZe158DVDXgt90bhWByDwG2Ph1B8thZRiSD2/HmLDBqMIklp60dvbKUwZw56O6+fXf3SpfR5FJ2Co6ks8CoqrKBGsgauBIApG/LA8hXF1v8sYXAgBaCHNcTSWJobQyYIZWbGmPrMN227MwodN/EGnb8qQQnDEirWLyp+gJCYQBNDIuxWH5JL2ZwuyVVuPrQHXo9GNLi6FhS3z4Wc0X1eO6sa4YUYWn2cB5BIF20NedaZ0iwygCkr3dP9sPiVfUDhhqQhCTLHQRwkH5IOWnfucl3JnJWDCuYAWINagyeV0oopuDFU9NHeGsZufpLY7iQW7YPlIuyHKnnC9weh8l5hlNB6B7KU+d44ohHFXBcQdgzLlVWslAeeNL6H6wVPkmYn1BDSqSxUztIrmc5bGwviuoYjVcCBGsCS7ljCkwTUGSj0b3nzYGGYeVQP8ECG285+jGHIvifRnHowJ696Wpsf11ougVJxdwqx+ZQWfUcWOaj6cp+c0IYZgxxk4+IkgX9NluHi+HJyF5MN/NNtJXl73iS6os1mePJGKTTewlte/TyEvSRSlR72x35o2oHKWWmhw413q5X22sOS4rVcBosF7iAQ/NCMlHBh0V75bzuCWdGCI/ryDFDNdwFluBww6XuDbRIpplIQqvF8HPZX3urQFwmhfyhgZ6Jw0vJe1E2DqH1Eg4OsF+84TU1HG6/bR7MsSRRKB2d67wH1FmrZLlFD2InyYNEegAD/8+eaMQKoRdWFZQOMRTkWIo9WLYPtaHsvEU6+x2uh/xIVhJnBQXaqIuoM9PgtO86LaKgrXFC0pVjOScSh1PFtfzcr5LHTPHRWegECsoUxM5wQOz2MSsxiqaFCCkT0kfW
 tHIFPXQK
 9XHJxvDM7Ag7QIgB1ia6Ml4b6qr9dn3U9Mv/OVw7+bYBqkjjqQ03+36Xsh8xdAfoMKcIbjbF/jdc/Khlt9SP9ltIhbnmrZMiBQ4OnrPXnq35xBWJw/iu30EbQ+Al7XBe52t9SIdnIDzr5oNvycHO7/J5QcWYwZ1iSiXpe7A60DUZvdraSnHFb+2nq7/tMf2mAsg4B5EZa0E4tQuC2VsKC9BZrzMKQg+yDb055RMKxOOJg6sXFyLW+hRVYnkFShP2tVaBYh7Mcai8knrUIFUGjfIx466alwH9t3XqrlIN4+8Sknz16K26bUUMhTIb7PBG7LCncwgFp4xkTiss2bTNxmJU9mxUHUl8NbUAbYNVHJYDaTADv6NCyaEu3CF27rcw1+lZSXuV+b7VDenYtxae3QHVJCNCL1HYBtyvtNCBB70DSRjHN4gyVXgJP9x0ofHP8W87b+UxjgHISACUa8cRfHN7LWivnaRbOy5qC8rWrKVNgELLTXG8hr4mQQ0XGMSCg7UZbhgvxgxZ0z4+r5mrOLnK1W3K5Zx/J7osc6b4OV1wRIB2vcKx9u1stNB+FwauBJ5Q4XfxT8g8UZX9xP/wpEjwQNmuQh6xWFz95aDpRy3Z1NPaSBuDjRXBPbiSSqH0IHnm6bjiFXOSI4v0gvwPSOQYapZAXlQcn+2aNN1lMOx27n2shbcFZvqr1OJwrnDHSXJLzlMoxDzBij76o1G4mJJWyhWhl+pNoe08NlI9dExjTUg398jnlpQwr4UIl44Pn0tKAstcqgNHQdwcRHXGXa4gWjjcM/mKMZkeQIoCMNq9+6R+OgI1WJd+cn63XUHhXx+Rz2GC6dI/sMLtx6muJBwRV1oPLGGQbgPhE+36g3O2Hz5fbYBOBLecGJCoCFiATDIdz5aXPOmojg8Dr6EnHUdF4vMYh0BBYS+18bfPu9iENo++5v2as2uwtl4aGyE3ROdEzcnAEgmsVhVhpLh5XyXBxKfVs
 fx64z8Ak
 v1EO6HnOQEhLoyZGerBXwEcIv8l9TUM4JQXzG9dO7EcK6hoo10ckJGEJch0IHY3GhEOLuzlRJs9a3aqzPSNHbcQL/5m3fny5iDsUlz7UVo9ZA1hu7Q99W9VhSBRS0auPMzUJeuJuds7LTmSoUZeVh/URlqthX+5yhhigV7EDbgbRVBuNl5Zl1Zp/tL8LBWGMQjQTdmWvft6jYQZuGnQhQY5Pn+xVqS/Rgy2kAcLGwCADGizgnNRoFiTs1FX4yA9COyf4tZR9zfpZ53Aop2/n/Ormdp5hiLmDlUgSjv/DEYKeUeFWS4EBaQNv1I9IuxKHJ+28ICtsBpcYU4e+iHEkO661gPMxPoKriOMeU5fc4hQjBv7028xviKt4aQQJECgca4x8r6ckojdIo52euehhyjzBBcw0v9LQ866aYJon6hiPk0IBhW+eWHzMHTO2f9IqAp8i5/cNv5XSEUn+pi3PeY8Otnp50p+SqTibC2vcSzTBPagsLdzbe1lG7DYl/w22Iy+3o/7msZiGwtLjrhFCwUQHvKI+GW2PVEzP0I6EVdKlu/Rz6ufPXCuQaoB4EMSZQUZYL5GAGEd3mqZSJyWxuI3kh2s5v1mjDgAw0y80ckD0vyWvgHWDEO3jUmfFyLzb5LPzTKjz1x7iJZiaBofdIDzx/q9YimeFki57Cq8YaVenumDv8PK5kdDfm7qL3VOutcfBj7LGYttioOVRho38XLEFXEQUMZwRoJNDDS7tYmKelpgdVcMtHdlVkma7sI+FeDfrS7VolgWmVIfD1a8VzXW2j5u9DSUzzR37JmEz4E7b0uLz+wqLfrdTR9gvJUSaPwh4zFh2eDslUG72lCKnU4Z2BHM3sDdv5Hb280lQ5KJYBBS3hsTiLD8CEvApjrP1e9vsw/72rsPlfNYbvXvjUu8T+3Fei5t19dRjo6r+OFTCALnitTKpYy72Db5I0n/cRP8/uOTYqsomoYuhwkSIcah7L74wh
 Bcsn33kM
 qdIRgIMj4E9oMDdK0PypOB/MjRdvIys5N3AiI6V9F2cLdYnsff9hyWFFGnmmQpy8kvu6MRJhmuQlU9g2Jp5Lb9RT6x17724r3sqDPZIp2xKIIxsNf+G4TzXXHAteJ/H32W98NmGtOijNb4Ovi7Nre7RWgRrL8x6if3FfpjgIOJEw66OmKE+pNsaXuZ0+f5JXzh9yg+Aa8Ta7MlMH1GhIMYjv71D5+Kvy2d9fUORS7fD6hV8WGUpIeGNvDz6Eo5dDFrvlA5r8SZs8m/SPj478K54RJzRnzhxpbVlBy9d2EXUAYA3LhKn7r7IBwV5ZmZHYSreCHkz91NwRfOeHHto1Ah0DEZPxSxxYULRlPa8r1euWB3KKs/A3kn2W+AaZaHuMV0jlN1NbOV2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The recent conversion of ino_t/unsigned long inode number fields to u64
in VFS-layer trace events can leave alignment holes on 32-bit platforms
(particularly ARM, where u64 has 8-byte alignment). Reorder the
TP_STRUCT__entry fields so that 64-bit integer fields (u64, loff_t,
time64_t) come first, followed by pointers and unsigned longs, then
integer-sized and smaller fields.

This eliminates padding holes on 32-bit without worsening packing on
64-bit. Only the field declaration order in TP_STRUCT__entry is changed;
TP_fast_assign and TP_printk reference fields by name and are unaffected.

Files affected: cachefiles.h, filelock.h, filemap.h, hugetlbfs.h,
readahead.h, timestamp.h, writeback.h.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/trace/events/cachefiles.h | 10 +++++-----
 include/trace/events/filelock.h   | 22 +++++++++++-----------
 include/trace/events/filemap.h    |  4 ++--
 include/trace/events/hugetlbfs.h  | 18 +++++++++---------
 include/trace/events/readahead.h  |  6 +++---
 include/trace/events/timestamp.h  |  6 +++---
 include/trace/events/writeback.h  | 32 ++++++++++++++++----------------
 7 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/include/trace/events/cachefiles.h b/include/trace/events/cachefiles.h
index f967027711ee823f224abc1b8ab03f63da06ae6f..6e3b1424eea4dc9e414dd9d1439339132d516339 100644
--- a/include/trace/events/cachefiles.h
+++ b/include/trace/events/cachefiles.h
@@ -249,10 +249,10 @@ TRACE_EVENT(cachefiles_lookup,
 	    TP_ARGS(obj, dir, de),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		obj)
-		    __field(short,			error)
 		    __field(u64,			dino)
 		    __field(u64,			ino)
+		    __field(unsigned int,		obj)
+		    __field(short,			error)
 			     ),
 
 	    TP_fast_assign(
@@ -578,8 +578,8 @@ TRACE_EVENT(cachefiles_mark_active,
 
 	    /* Note that obj may be NULL */
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		obj)
 		    __field(u64,			inode)
+		    __field(unsigned int,		obj)
 			     ),
 
 	    TP_fast_assign(
@@ -599,8 +599,8 @@ TRACE_EVENT(cachefiles_mark_failed,
 
 	    /* Note that obj may be NULL */
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		obj)
 		    __field(u64,			inode)
+		    __field(unsigned int,		obj)
 			     ),
 
 	    TP_fast_assign(
@@ -620,8 +620,8 @@ TRACE_EVENT(cachefiles_mark_inactive,
 
 	    /* Note that obj may be NULL */
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		obj)
 		    __field(u64,			inode)
+		    __field(unsigned int,		obj)
 			     ),
 
 	    TP_fast_assign(
diff --git a/include/trace/events/filelock.h b/include/trace/events/filelock.h
index 41bc752616b25d6cd7955203e2c604029d0b440c..1167748862449ef6ff04c40b568ea8c3bbb08207 100644
--- a/include/trace/events/filelock.h
+++ b/include/trace/events/filelock.h
@@ -43,9 +43,9 @@ TRACE_EVENT(locks_get_lock_context,
 
 	TP_STRUCT__entry(
 		__field(u64, i_ino)
+		__field(struct file_lock_context *, ctx)
 		__field(dev_t, s_dev)
 		__field(unsigned char, type)
-		__field(struct file_lock_context *, ctx)
 	),
 
 	TP_fast_assign(
@@ -66,16 +66,16 @@ DECLARE_EVENT_CLASS(filelock_lock,
 	TP_ARGS(inode, fl, ret),
 
 	TP_STRUCT__entry(
-		__field(struct file_lock *, fl)
 		__field(u64, i_ino)
-		__field(dev_t, s_dev)
+		__field(loff_t, fl_start)
+		__field(loff_t, fl_end)
+		__field(struct file_lock *, fl)
 		__field(struct file_lock_core *, blocker)
 		__field(fl_owner_t, owner)
+		__field(dev_t, s_dev)
 		__field(unsigned int, pid)
 		__field(unsigned int, flags)
 		__field(unsigned char, type)
-		__field(loff_t, fl_start)
-		__field(loff_t, fl_end)
 		__field(int, ret)
 	),
 
@@ -123,15 +123,15 @@ DECLARE_EVENT_CLASS(filelock_lease,
 	TP_ARGS(inode, fl),
 
 	TP_STRUCT__entry(
-		__field(struct file_lease *, fl)
 		__field(u64, i_ino)
-		__field(dev_t, s_dev)
+		__field(struct file_lease *, fl)
 		__field(struct file_lock_core *, blocker)
 		__field(fl_owner_t, owner)
-		__field(unsigned int, flags)
-		__field(unsigned char, type)
 		__field(unsigned long, break_time)
 		__field(unsigned long, downgrade_time)
+		__field(dev_t, s_dev)
+		__field(unsigned int, flags)
+		__field(unsigned char, type)
 	),
 
 	TP_fast_assign(
@@ -176,11 +176,11 @@ TRACE_EVENT(generic_add_lease,
 
 	TP_STRUCT__entry(
 		__field(u64, i_ino)
+		__field(fl_owner_t, owner)
+		__field(dev_t, s_dev)
 		__field(int, wcount)
 		__field(int, rcount)
 		__field(int, icount)
-		__field(dev_t, s_dev)
-		__field(fl_owner_t, owner)
 		__field(unsigned int, flags)
 		__field(unsigned char, type)
 	),
diff --git a/include/trace/events/filemap.h b/include/trace/events/filemap.h
index 153491e57cce6df73e30ddee60a52ed7d8923c24..4dcf8e9e2e0d8bde7c9df9856c059d2cdebff59f 100644
--- a/include/trace/events/filemap.h
+++ b/include/trace/events/filemap.h
@@ -20,8 +20,8 @@ DECLARE_EVENT_CLASS(mm_filemap_op_page_cache,
 	TP_ARGS(folio),
 
 	TP_STRUCT__entry(
-		__field(unsigned long, pfn)
 		__field(u64, i_ino)
+		__field(unsigned long, pfn)
 		__field(unsigned long, index)
 		__field(dev_t, s_dev)
 		__field(unsigned char, order)
@@ -171,8 +171,8 @@ TRACE_EVENT(file_check_and_advance_wb_err,
 		TP_ARGS(file, old),
 
 		TP_STRUCT__entry(
-			__field(struct file *, file)
 			__field(u64, i_ino)
+			__field(struct file *, file)
 			__field(dev_t, s_dev)
 			__field(errseq_t, old)
 			__field(errseq_t, new)
diff --git a/include/trace/events/hugetlbfs.h b/include/trace/events/hugetlbfs.h
index d4fefa571b829f92729c7e175df9ad5ed701131a..8ba72c1d4f4d8ba616906be5b5c4b487972fec00 100644
--- a/include/trace/events/hugetlbfs.h
+++ b/include/trace/events/hugetlbfs.h
@@ -14,9 +14,9 @@ TRACE_EVENT(hugetlbfs_alloc_inode,
 	TP_ARGS(inode, dir, mode),
 
 	TP_STRUCT__entry(
-		__field(dev_t,		dev)
 		__field(u64,		ino)
 		__field(u64,		dir)
+		__field(dev_t,		dev)
 		__field(__u16,		mode)
 	),
 
@@ -40,13 +40,13 @@ DECLARE_EVENT_CLASS(hugetlbfs__inode,
 	TP_ARGS(inode),
 
 	TP_STRUCT__entry(
-		__field(dev_t,		dev)
 		__field(u64,		ino)
-		__field(__u16,		mode)
 		__field(loff_t,		size)
+		__field(blkcnt_t,	blocks)
+		__field(dev_t,		dev)
 		__field(unsigned int,	nlink)
 		__field(unsigned int,	seals)
-		__field(blkcnt_t,	blocks)
+		__field(__u16,		mode)
 	),
 
 	TP_fast_assign(
@@ -87,14 +87,14 @@ TRACE_EVENT(hugetlbfs_setattr,
 	TP_ARGS(inode, dentry, attr),
 
 	TP_STRUCT__entry(
-		__field(dev_t,		dev)
 		__field(u64,		ino)
+		__field(loff_t,		old_size)
+		__field(loff_t,		ia_size)
+		__field(dev_t,		dev)
 		__field(unsigned int,	d_len)
 		__string(d_name,	dentry->d_name.name)
 		__field(unsigned int,	ia_valid)
 		__field(unsigned int,	ia_mode)
-		__field(loff_t,		old_size)
-		__field(loff_t,		ia_size)
 	),
 
 	TP_fast_assign(
@@ -122,12 +122,12 @@ TRACE_EVENT(hugetlbfs_fallocate,
 	TP_ARGS(inode, mode, offset, len, ret),
 
 	TP_STRUCT__entry(
-		__field(dev_t,		dev)
 		__field(u64,		ino)
-		__field(int,		mode)
 		__field(loff_t,		offset)
 		__field(loff_t,		len)
 		__field(loff_t,		size)
+		__field(dev_t,		dev)
+		__field(int,		mode)
 		__field(int,		ret)
 	),
 
diff --git a/include/trace/events/readahead.h b/include/trace/events/readahead.h
index 928b2c67654735cc004d27beeee2066196e60a70..087f171e2b02d30f09179d5ed6c27a7e0224370b 100644
--- a/include/trace/events/readahead.h
+++ b/include/trace/events/readahead.h
@@ -81,15 +81,15 @@ DECLARE_EVENT_CLASS(page_cache_ra_op,
 
 	TP_STRUCT__entry(
 		__field(u64, i_ino)
-		__field(dev_t, s_dev)
+		__field(loff_t, prev_pos)
 		__field(pgoff_t, index)
+		__field(unsigned long, req_count)
+		__field(dev_t, s_dev)
 		__field(unsigned int, order)
 		__field(unsigned int, size)
 		__field(unsigned int, async_size)
 		__field(unsigned int, ra_pages)
 		__field(unsigned int, mmap_miss)
-		__field(loff_t, prev_pos)
-		__field(unsigned long, req_count)
 	),
 
 	TP_fast_assign(
diff --git a/include/trace/events/timestamp.h b/include/trace/events/timestamp.h
index 315ea8d57796617661768da24591d53095ac7649..d6503612dddf9c6a2f785fad549fa04adddb06fe 100644
--- a/include/trace/events/timestamp.h
+++ b/include/trace/events/timestamp.h
@@ -18,9 +18,9 @@ DECLARE_EVENT_CLASS(ctime,
 	TP_ARGS(inode, ctime),
 
 	TP_STRUCT__entry(
-		__field(dev_t,		dev)
 		__field(u64,		ino)
 		__field(time64_t,	ctime_s)
+		__field(dev_t,		dev)
 		__field(u32,		ctime_ns)
 		__field(u32,		gen)
 	),
@@ -58,8 +58,8 @@ TRACE_EVENT(ctime_ns_xchg,
 	TP_ARGS(inode, old, new, cur),
 
 	TP_STRUCT__entry(
-		__field(dev_t,		dev)
 		__field(u64,		ino)
+		__field(dev_t,		dev)
 		__field(u32,		gen)
 		__field(u32,		old)
 		__field(u32,		new)
@@ -93,10 +93,10 @@ TRACE_EVENT(fill_mg_cmtime,
 	TP_ARGS(inode, ctime, mtime),
 
 	TP_STRUCT__entry(
-		__field(dev_t,		dev)
 		__field(u64,		ino)
 		__field(time64_t,	ctime_s)
 		__field(time64_t,	mtime_s)
+		__field(dev_t,		dev)
 		__field(u32,		ctime_ns)
 		__field(u32,		mtime_ns)
 		__field(u32,		gen)
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index ad269142f3f9a288d87e5252f08e8a17fd06e8d5..e5cd2b80fd29dba9177b8ea7c37d63e50e9f60e2 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -280,9 +280,9 @@ TRACE_EVENT(track_foreign_dirty,
 		__array(char,		name, 32)
 		__field(u64,		bdi_id)
 		__field(u64,		ino)
-		__field(unsigned int,	memcg_id)
 		__field(u64,		cgroup_ino)
 		__field(u64,		page_cgroup_ino)
+		__field(unsigned int,	memcg_id)
 	),
 
 	TP_fast_assign(
@@ -346,8 +346,8 @@ DECLARE_EVENT_CLASS(writeback_write_inode_template,
 	TP_STRUCT__entry (
 		__array(char, name, 32)
 		__field(u64, ino)
-		__field(int, sync_mode)
 		__field(u64, cgroup_ino)
+		__field(int, sync_mode)
 	),
 
 	TP_fast_assign(
@@ -385,6 +385,7 @@ DECLARE_EVENT_CLASS(writeback_work_class,
 	TP_ARGS(wb, work),
 	TP_STRUCT__entry(
 		__array(char, name, 32)
+		__field(u64, cgroup_ino)
 		__field(long, nr_pages)
 		__field(dev_t, sb_dev)
 		__field(int, sync_mode)
@@ -392,7 +393,6 @@ DECLARE_EVENT_CLASS(writeback_work_class,
 		__field(int, range_cyclic)
 		__field(int, for_background)
 		__field(int, reason)
-		__field(u64, cgroup_ino)
 	),
 	TP_fast_assign(
 		strscpy_pad(__entry->name, bdi_dev_name(wb->bdi), 32);
@@ -482,15 +482,15 @@ DECLARE_EVENT_CLASS(wbc_class,
 	TP_ARGS(wbc, bdi),
 	TP_STRUCT__entry(
 		__array(char, name, 32)
+		__field(u64, cgroup_ino)
 		__field(long, nr_to_write)
 		__field(long, pages_skipped)
+		__field(long, range_start)
+		__field(long, range_end)
 		__field(int, sync_mode)
 		__field(int, for_kupdate)
 		__field(int, for_background)
 		__field(int, range_cyclic)
-		__field(long, range_start)
-		__field(long, range_end)
-		__field(u64, cgroup_ino)
 	),
 
 	TP_fast_assign(
@@ -535,11 +535,11 @@ TRACE_EVENT(writeback_queue_io,
 	TP_ARGS(wb, work, dirtied_before, moved),
 	TP_STRUCT__entry(
 		__array(char,		name, 32)
+		__field(u64,		cgroup_ino)
 		__field(unsigned long,	older)
 		__field(long,		age)
 		__field(int,		moved)
 		__field(int,		reason)
-		__field(u64,		cgroup_ino)
 	),
 	TP_fast_assign(
 		strscpy_pad(__entry->name, bdi_dev_name(wb->bdi), 32);
@@ -614,13 +614,13 @@ TRACE_EVENT(bdi_dirty_ratelimit,
 
 	TP_STRUCT__entry(
 		__array(char,		bdi, 32)
+		__field(u64,		cgroup_ino)
 		__field(unsigned long,	write_bw)
 		__field(unsigned long,	avg_write_bw)
 		__field(unsigned long,	dirty_rate)
 		__field(unsigned long,	dirty_ratelimit)
 		__field(unsigned long,	task_ratelimit)
 		__field(unsigned long,	balanced_dirty_ratelimit)
-		__field(u64,		cgroup_ino)
 	),
 
 	TP_fast_assign(
@@ -667,6 +667,7 @@ TRACE_EVENT(balance_dirty_pages,
 
 	TP_STRUCT__entry(
 		__array(	 char,	bdi, 32)
+		__field(u64,		cgroup_ino)
 		__field(unsigned long,	limit)
 		__field(unsigned long,	setpoint)
 		__field(unsigned long,	dirty)
@@ -674,13 +675,12 @@ TRACE_EVENT(balance_dirty_pages,
 		__field(unsigned long,	wb_dirty)
 		__field(unsigned long,	dirty_ratelimit)
 		__field(unsigned long,	task_ratelimit)
-		__field(unsigned int,	dirtied)
-		__field(unsigned int,	dirtied_pause)
 		__field(unsigned long,	paused)
 		__field(	 long,	pause)
 		__field(unsigned long,	period)
 		__field(	 long,	think)
-		__field(u64,		cgroup_ino)
+		__field(unsigned int,	dirtied)
+		__field(unsigned int,	dirtied_pause)
 	),
 
 	TP_fast_assign(
@@ -738,9 +738,9 @@ TRACE_EVENT(writeback_sb_inodes_requeue,
 	TP_STRUCT__entry(
 		__array(char, name, 32)
 		__field(u64, ino)
+		__field(u64, cgroup_ino)
 		__field(unsigned long, state)
 		__field(unsigned long, dirtied_when)
-		__field(u64, cgroup_ino)
 	),
 
 	TP_fast_assign(
@@ -774,12 +774,12 @@ DECLARE_EVENT_CLASS(writeback_single_inode_template,
 	TP_STRUCT__entry(
 		__array(char, name, 32)
 		__field(u64, ino)
+		__field(u64, cgroup_ino)
 		__field(unsigned long, state)
 		__field(unsigned long, dirtied_when)
 		__field(unsigned long, writeback_index)
-		__field(long, nr_to_write)
 		__field(unsigned long, wrote)
-		__field(u64, cgroup_ino)
+		__field(long, nr_to_write)
 	),
 
 	TP_fast_assign(
@@ -828,11 +828,11 @@ DECLARE_EVENT_CLASS(writeback_inode_template,
 	TP_ARGS(inode),
 
 	TP_STRUCT__entry(
-		__field(	dev_t,	dev			)
 		__field(	u64,	ino			)
 		__field(unsigned long,	state			)
-		__field(	__u16, mode			)
 		__field(unsigned long, dirtied_when		)
+		__field(	dev_t,	dev			)
+		__field(	__u16, mode			)
 	),
 
 	TP_fast_assign(

-- 
2.53.0


