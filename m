Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54963EB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:27:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDB266B00A1; Mon,  2 Mar 2026 15:27:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8EF46B00A3; Mon,  2 Mar 2026 15:27:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A847B6B00A4; Mon,  2 Mar 2026 15:27:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 988196B00A1
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:27:27 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 663021B719F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:27:27 +0000 (UTC)
X-FDA: 84502258134.23.76211F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 879AA20002
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:27:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qfVHOdkd;
	spf=pass (imf03.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q/Kkvyw+C2gvE4ebhc/jfemnWJtQmHdv0CE0g/cZCGA=;
	b=qIlg/G2eLB1K7U0wJ1+lBYPz537cmHjoszurKcIZtEZEduXBa1fRsapckKPUYNb4PO6nOc
	GMqUCdfyg3xOfBusCGRDT5LDwDgyIJ+j37p39UkdkRLFtQyMt7j1e8D7iStLVrlXH65khL
	lZY0WjYvwo3bj82dCvHmNwfMJauu1T4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qfVHOdkd;
	spf=pass (imf03.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483245; a=rsa-sha256;
	cv=none;
	b=VTz8On2H/GXYn5CkluTeOW17rVjvZ9Qa04GLIF+2e662I6vWbZlm5LVPmAVhpoYuePAiPS
	KyicHmbMYpybEZi/3mPiHop763lLWDeYV7ViURAV+ei6v8wuSsElrtQ1IkOHiQdMYhaL03
	wmFlbbaTpn9kC+/YFP99GKrwsDvUP8k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 843C741951;
	Mon,  2 Mar 2026 20:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53151C19425;
	Mon,  2 Mar 2026 20:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483244;
	bh=5VB+NzTxyTTbdILrjVS0CXpowNihfbF7KKD2ZGuki60=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=qfVHOdkdt02CZl3KdunfN2VVSon3TWufr6tZYTCXdZ0hAm7kh4m0Q5yBErAai6J9Z
	 URfmsEUOqNqbdTHs16kR25ycpZz+prweGn8en/42ThckoVrq2k1JsCqa7GRxU3k/t4
	 79f2NED3SU9GeP7S8imZ7XOZxgUhSOgThefzv4gzy5IpRGUV6+dZBWkKvooE9YNn/m
	 AaKp1YNGkS4BYgbI4ER5pVJ17dyz87CaA8fSOIqh9a+SxkAwzayLdtj16xCarl2naP
	 KPVrSZ15CqavU8DoTC1nQMQaj6L2pFl4fNxOE+Y9XtPyk0Z7tXTQYTFPtJwiGz0ZmN
	 nUkUGLjw0woCg==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:23:54 -0500
Subject: [PATCH v2 010/110] lockd: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-10-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2560; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=5VB+NzTxyTTbdILrjVS0CXpowNihfbF7KKD2ZGuki60=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfHxRIp/wSp+XA/WsU2UWjaucC6lZTxvCM0fM
 48TEkF4WjWJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx8QAKCRAADmhBGVaC
 FU9tEACzae8Mk5amZ0VIj9ptrSq4/DkARwfOtgg0FBX48Yv+IIco33E1ItoDw1qU/+srG6Qf0cH
 BXm/HrKitguKwL3fUhDn0ABgyXc6+k5cEyyrwpdqkZxoRjqefrGGaHnmb3FQe5OdINNUIlOj8AL
 g+gXOVpRXyt5AYwOVaBkTxCU9xVIIjXPEU8hGDWuHpX8rNeBQi1BOGwVeNZ4Qjg9mHgoe/qH/xh
 4oBpMBPS+X2Jl0fzF+SD2RgsjHunuxqPKUzyahe10YYm1MCO0fwW9PFq4EhoUh5/Eqa1V+hCX1E
 i4mOPjFxj1KoGOocZcDav2L+VBPFYIHT4uVVni9z/CjdRqBhyoYn1Q1BCeB00WPkGy/H1K6vO6a
 zWDgOjPifip7WDVxoJrxR9LE5pxcVrqaZvKbI9eWWaDZA3mVr8/fZcxKiQdEhh1XX0sB6olH24u
 8twty75/dEezhiAtIKRFf9lDdDJn/9GnD4iFc4YoiuEKmioZWWs5SaFOeuIK6pzZjrzu5F4TH12
 Y8r+DCaxc9KMimUq1mpiEDStKjW/9zryKoAdyeTmv4JqsIz+V3QyImJJNBWy4iSNoMVFUFedjqv
 lrEpps4nQw71S49uyIOnYI5EiPzurtH1d2zrO+7g/k+IFA0vQu7fNstjjBEGC/4V0ll8PZcagLr
 nFaaUgNOQ51LaIQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: 3om6z5my84nccyh7mda1k98ake5mquwd
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 879AA20002
X-HE-Tag: 1772483245-26200
X-HE-Meta: U2FsdGVkX18aDHGVNY26V1F3gudzWg+U3S9E37nFpG4i6pAcWXMNKKEZDzJK+uermDlkbAZb9ZpX6FXtwG9pJwareAP8Ix3D/mY2ACO9s5QiUfdlhJcoLTuj2Ip1G3RLZmonn6VfuoTsMToSsEpV/9YWaWLBJEdAk65wEDagjwujFzkKz8/mwdeF7+flWA4gX+Vx+sAq7kyUwGGRYXRiHzle9a8rBji6+PvkKpfVFTXH1hbS/sW4gsSANA2EHxEauF1q9PeEXpqtZXQl6N5G/KPVZR9auaZtRW4g6y2f6iSzWVPqqlU206njjd5beZZyiWVRQgQY4tIqtwT9IWUWQYZkN2OroLtpiAilYlrcNrOKrLBjPgeiF0gc4P06oIyH8C36cSV4Y3tsWtGKBBmavwxdHG/qwf0AST0DbFT9uWX0+/5YTrNdYPGR2XZEmYan2kGSfuhqqpvFXSzw3LoSjdJ388hnSCtF9P9IGHnvfIRW938Qc/Yfb53HaaVZo/OVqSTqPsrAQtsHZhS07+oy3klr51lkmJ0+zL0TcxrQXjv9Ue1F+iOZ7Kq+P8x2xkra5ytiIrCB/Tx8fMaojnyA6ma6mL4OyqDhlKwhjgjfaLT/beNbI8BJnSofxUDrN8BUEO0EXXxSKuzrAUi2rDmwik5CBCJBCzJfUmo3i3G1KOR+H3gm+uqIxecq8lS6jh45X0VClFM4ajVelfJa4RoerLvP++xxsw5BLQsi/95euCq8uAsULsgOG9cqCA2zXJ09a8pQ2HTJycsUG96GV9fmI+WrSRRvjJN9s9rjxcDdYqjlJ2ZHjipjewxLbK9Vi+6PljIn8+S3i2u6QxGH8dAE55Jq7S0MMDVs0EZKg2b0B+mxnA0eJjSemoAqLmHrpL7WHs4MgA6qaDldSUJBudapJ4WuDj05eu1W0XEHe5A0OzZ+xAz6CwFMpqG3PZ/GZwyMLPDgxGpFvHufEyGOGPk
 Tt1WqWF+
 5TY5h2Aa83n9GfX1hYbXRodUg2TKnkyvxqyeN1x5lZvqYlV6j8/HI2T8w6kJqc91XK1JvGOzGHXm1hQ3VDx8Z6Ku53rhXjOe/EivhlazLN26KncaX44vatZ4ig8D5SiHlGTqFxCc7D4rDsX9ZCsqigAfS9rtsAJJzppdiZejGr6TWqsGxaJkZjr2JFSTUX1fEmAeKrxE6t9/w3Bd7FHdpjWJiqfA6R0XyCCGTvlkTFDLs/MMlTp3kxHF/yeoSOL1F1bxVrJEvbyxBX1xAGWMiE+d4dvymVU9XCmod7+dKCM2KZXITABf8ha0IppV0Jn6bwdSVGtj4KFtnD+5M5DG7eEgq8KiIGTIqGP3a8djZvABHFu9Ghtn3pZThCcara4H/NpEm3dOUHy6QiyFj6GqNyjP2A6yGxisNuX6+LdiAVk3/bqFQvGYqBSZbrvNdJr8G2yiwQl2aqXXkyb3ojjsSLKeP8TYlPEiYLkFhlKCFeufj29V9zzqTvSjno8/tf34F8lvAKv+fFdkauwUGDcEQkcc3XcVsbN/4FiUpd2iWPLv7m/7LW/24RMKhjExS3mH26TYkSPfOod5+XKui/EXCRU5ntgZOLoUs0Pk2jcaHeQ1V37ajG7owSZG7FgZxVZFw0DLs1krz3vjH/ab6RzbU/9oV8v1oWRFBsNvWkuPKmhE+fVY0tsyI4Et8JE6gzSO4KBQ196C5XqQkf9MYPx481CE5QDPsqbN5iR6fdTfXHAjEsSa4YTPi8316poN3MmrWmQKE7MJL/OODGA4qb6KG88tgG6K1qKTDteIRbjamzuFnZlSr0ToFo2we/vc8V4K4CMJZA/RcMq6yWXKZUBbYVAaN816w5L2UyVKPWDX2y6fO5EdjWHL+fSHHAnKVyh/xOiEA/B3Mn8SuBYnuuf6HwK9Fx3V+zHZwoxCvSa4tZiqCshK6lquFBtbNnEpjTkqYoyra+2T20tewsrB4o1rKGLlAOY3v
 wNcqO82Y
 f2V8/QvHo1KWgSk8PFMHF4Rm5tyzRlWF/8FYp8JUk16YMRXBAj9NfQVT9+Izfeuvo318fj0cqjxSXoJNOCIJI5NT6R+vBdtvyYyuca9feUsmLhMd65NfCFOpyL3Mhl0p2TRkXZt08GX1CU5DnUo0rxHpOjbR7FLeJGHBIhIEv6m1trN1q7QemBOTdsjRHrf18KBzFDpbaA1S4nrRm7tRcCWIgDyJje5+U9d3bllRiuDKu/xYLSDrpFhczEbBLNfkYsXz88OO/MWfeVV9V2FUvRv50oJ+k1QhUYSR/PPF2L5NpKxo2wgbKReoDKBKJI0peW0F9hrSEFJiEvJ8AivnQ1Ba9FzhWrPcnSZ8TFITyl/g4EstUNn2Au53mht/UNAdeJMJhI01MnblDpjkUqdMsNj1qLKbtKa19ma8x/gpN6BzqGASMFmSbBkFgDI+/NAfzUFUyi46Fal5IJP7V7qfXMUjTBgLFI31HARVjPlB7j7t69/hrrjn3+JnehEWfmiUYRoLt3YP+Z/zcY1Y5VJ0Eyq2T+UEa4MFbozqEeKwWJwQriRGiGWXnhwhZBWF6hVkUsOm6/S6KWoTBq55dV0oZcmRs6l+c5XylydGoqdqm8Fjl5oKxu/wkC4e+73aT+j2rzJxurTlplUmCLXGNWJCzOtONLjBjVNqULj/duNLQoPLqONDOtCJPfBIgy8rvqMvVRUIzHQfU7enT67cTUrtKQayULMFiyGJk8Cju1cQtLTCTIw4SpI4FvmW7XCgpNcRkmGjk4FkhxH5CKo9Za78WgpVZ91fRdtZmU88Fnsad4025lskTaOwPZd5n2wCHsda47EDsG2AbNjEg4FBff8vr2xGvuO/HGwO8ixVmRwt1yt5jNGmfWV1Xm/fnVqJy4AEKgTQ/KKkQlN/SgCJWxkQi98z+zCI9HLX22Rw3sKD9BIb17fsk+GQnCMuvaAv4RjIMqSdwsh3XDSsd4iPSY6LTixBCQa3x
 +say75Cf
 iRisOGJ0Zhvm7sFnA1dOK5iVOdN8YeC+rjcTEIgL3+i+a54R86HE6uKqIaRUUo2Jfmb4IduuyG1vvGTLnPm8Y3+9M7036976VG/wb0vYn7joGpc4rAR6Ja+srXjPuCyd2NxwESqdFs2hZ8R1ZQ2hMEjGwkSmif+0i47YvXiJCM7xQKAKOVinNQjrGUkgMWid/PyzuBx1EaGmft/PQU9KVWIfKkXIQgt56D6lTut07NOnI9sKCJMAwy7wC9wQbphKDom1mtRQlClicqPMDNm1l2c1S/ZUbUDNAS/0Aw0EAnO9Fa/Yl1kv5QsqeKF4nliCJ23M04wilphNxYH/dogaPu229zbmktNlV6vYT/VsbB87EBNHnE0Xquf5KC9uqxN8zzdQWjhCyzCl4mxCG05UW0YNxPOXOqCGWsNimkIheln6nV9dSt4nvXd8vShG+vsHgHfJV6XF+HN8M63cJct/HdCJ/OOIs75mWJhxm/g+YxtyifTjTV8i+OoNFxZ4fIbEB6cg/fzNuzHE84QgcUgR0uf4r8ZtoC+5Bv7HxG6yrnHZRuX0GtEF3FoPKDC27xAB8aUfJoY7n3S9NyLyvWDLE38igL6PguUPT9JS0lfCcgdDC+M7YRLjybRMuTsc8evuMzUF95reCJpeNysDZBlpo9PAKPWJHgik8XDADOdusBJVwU2/EXMNDRA2NLyvbXdrVFTiVXuCoullYQxEZqLSXMzqAuFnbDwKiX9Eyqf+NCRJWJSZe2yRzelO7759a9o4GASjO1OLXyD4UGpE7gguKsYDoZbHjTOiwFcrARA3sUB91OZTV+erlcUsSXgKXKFuGGVujRmTHasGVwIz/a90Ze3ahrMAdEsLMwQcxcIltEjuFYY6UcSHjlTzYg9Toy6EsnPcMX8EP5iSnj6+IYCjBLSifUsjpqmTRe7ueBD/lH+qvZ/5LUpTuG5TdoZWrukvjh5/BBdEWuxLLxGwD91XmBjLbA+2K
 LjcHMA3W
 AU5BzBK0Cm78jr9KR6yjXRaqvhucDBJTtT78Iyq7QDIB9T7SH82djiJIOJBZDwlMLBWFDXeiXBOBKK1p8UcrCpHHXFS+tARoPtwdpzO9x9ueEZCeMuh/HZoLuS+GGqEc78pOlTpg10gEtcMxBWiykGIuTzuRsyKE5NJHnCDhFsoChySuzD6TBz7CfddImiGY23bPygqY+U9oganRJVR7URYMRaDm713fOQe1FaQv/sukF4HeDCzAM7OAhUaMIQRWqSNVdojfTasP/VMnzgpKlfj397HR7x5jcPqAR/PRy6y8Je0OI8PMovb56cfp7v6Gpa3nHp3/J+cWMr2fFpWyaKTeXn/NMJsUOSVmAgWf1wCip4TXqYN6nSinWeGdSSYJNWE48Wp8vyNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert lockd i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Also correct signed format specifiers to unsigned, since inode
numbers are unsigned values.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/lockd/svclock.c | 8 ++++----
 fs/lockd/svcsubs.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index 255a847ca0b6b9f7ab5a99c3aaa6856044ac0535..2ee2c3d6e442e701dab29dafc23da8209306b84f 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -487,7 +487,7 @@ nlmsvc_lock(struct svc_rqst *rqstp, struct nlm_file *file,
 	int			async_block = 0;
 	__be32			ret;
 
-	dprintk("lockd: nlmsvc_lock(%s/%ld, ty=%d, pi=%d, %Ld-%Ld, bl=%d)\n",
+	dprintk("lockd: nlmsvc_lock(%s/%" PRIino "u, ty=%d, pi=%d, %Ld-%Ld, bl=%d)\n",
 				inode->i_sb->s_id, inode->i_ino,
 				lock->fl.c.flc_type,
 				lock->fl.c.flc_pid,
@@ -617,7 +617,7 @@ nlmsvc_testlock(struct svc_rqst *rqstp, struct nlm_file *file,
 	int			mode;
 	__be32			ret;
 
-	dprintk("lockd: nlmsvc_testlock(%s/%ld, ty=%d, %Ld-%Ld)\n",
+	dprintk("lockd: nlmsvc_testlock(%s/%" PRIino "u, ty=%d, %Ld-%Ld)\n",
 				nlmsvc_file_inode(file)->i_sb->s_id,
 				nlmsvc_file_inode(file)->i_ino,
 				lock->fl.c.flc_type,
@@ -676,7 +676,7 @@ nlmsvc_unlock(struct net *net, struct nlm_file *file, struct nlm_lock *lock)
 {
 	int	error = 0;
 
-	dprintk("lockd: nlmsvc_unlock(%s/%ld, pi=%d, %Ld-%Ld)\n",
+	dprintk("lockd: nlmsvc_unlock(%s/%" PRIino "u, pi=%d, %Ld-%Ld)\n",
 				nlmsvc_file_inode(file)->i_sb->s_id,
 				nlmsvc_file_inode(file)->i_ino,
 				lock->fl.c.flc_pid,
@@ -716,7 +716,7 @@ nlmsvc_cancel_blocked(struct net *net, struct nlm_file *file, struct nlm_lock *l
 	int status = 0;
 	int mode;
 
-	dprintk("lockd: nlmsvc_cancel(%s/%ld, pi=%d, %Ld-%Ld)\n",
+	dprintk("lockd: nlmsvc_cancel(%s/%" PRIino "u, pi=%d, %Ld-%Ld)\n",
 				nlmsvc_file_inode(file)->i_sb->s_id,
 				nlmsvc_file_inode(file)->i_ino,
 				lock->fl.c.flc_pid,
diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index dd0214dcb69503006181a1533c440fc04a329d73..5e7b2a7967bd23365dae2817a0e11c50e4be7c83 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -47,7 +47,7 @@ static inline void nlm_debug_print_file(char *msg, struct nlm_file *file)
 {
 	struct inode *inode = nlmsvc_file_inode(file);
 
-	dprintk("lockd: %s %s/%ld\n",
+	dprintk("lockd: %s %s/%" PRIino "u\n",
 		msg, inode->i_sb->s_id, inode->i_ino);
 }
 #else

-- 
2.53.0


