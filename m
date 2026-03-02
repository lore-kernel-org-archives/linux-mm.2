Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F844EB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:28:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 125B06B0089; Mon,  2 Mar 2026 15:28:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CC4F6B0093; Mon,  2 Mar 2026 15:28:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBC966B00AB; Mon,  2 Mar 2026 15:28:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D909B6B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:28:24 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A53A913A782
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:28:24 +0000 (UTC)
X-FDA: 84502260528.07.0627272
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id CEFC74000D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:28:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=adORPXSh;
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xU6+a/1Mwo7LQ8ULf3RySNQwmtd4DNo7YSkrODv4R6k=;
	b=cYKJsPuy8Ol7w7rqAvsj37E80yplwhlETevx71SQeFL23iNjsfgjPWDbkr6JTEwOwAXa0o
	ICcrxwINkDt3IgjzGAa6XiEASOn8iTkcDb+yREIuq343O/5XUJ5qi999JSpS3wq1uSH2A8
	qAM1RfRH3z/bZSX1GcLcsXsFm9C92Kk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=adORPXSh;
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483303; a=rsa-sha256;
	cv=none;
	b=OACIyCOC1CKk0NHmb3hOQYlaMNTppWHhLcBAcDe7E6INkNexE9TZ8+T5Win3ia2mg/LoOq
	eWXJrV94HElW16fnEkG3JOcxF1IUKVu+KXGFxlpDoch+ZzkhtmfYf8uJ+DsSyARenlGDgG
	nrtjxnJrsqICH3F196bnTb1THT75MQw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EE6EF441DA;
	Mon,  2 Mar 2026 20:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6EF5C2BCB6;
	Mon,  2 Mar 2026 20:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483301;
	bh=ILNBX20XMm1WGYeu4fSbxc7i4uyu2mHUuuBgFEHaTLQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=adORPXShDJaWeQRCvSdSr3L2lXo65cAtKpYBCDaRHoy0MKNKUvrF7aMymnslSSs4B
	 AMdjhjFRvGdybr+uMutunCNdot7V1s1CHUjy6TEuq079//WixBAim/+w7whDBK17Ql
	 sd2diEDzU8ZI+CvgWovO3j6esT6DeAP5TRyjb1iQdmS1xVBNOR15bGyfPt63Xj6X6a
	 UEZVKUYin8jropztKyWus6l9QY2MA6uXm0QunpThKHKrDotZZJ4pcvPlDw2DJnQI6R
	 2TeAOGs/0VwH5i/Xm+KY62RmHm3kRHZwqDCzK04Ymq6OabPDu+qR14tIW4YzVWfMYm
	 NiqS4oO3UXgFw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:23:58 -0500
Subject: [PATCH v2 014/110] proc: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-14-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1853; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=ILNBX20XMm1WGYeu4fSbxc7i4uyu2mHUuuBgFEHaTLQ=;
 b=kA0DAAoBAA5oQRlWghUByyZiAGml8fKhukipLxqLUFvO9iuDYAGOPry/2sA4SjKuNUK0omXcO
 okCMwQAAQoAHRYhBEvA17JEcbKhhOr10wAOaEEZVoIVBQJppfHyAAoJEAAOaEEZVoIVtoUP/R3e
 In/Btns6OtO77+sWMs3v1xqzUdt4DAPFPDwvgQ3x5gDTR9PmppRzZM33aV68PBKlwHXKMZxO7/V
 KmLhAIL0EMOzoOx4oVwoRmV2F5Gw5mMpRhTZOO5FsZv2WCle07tsqIXifbmkx8OgPQIB5wjlD/E
 YqqdFbIvbMnLqiPJnZdk6DC4DPRnZhVj+EDM04AaWnAImg6uwnAgAfaf0OSVnULRQjRb0bdjWad
 7NOEkQH8pvNfiEF1ehH541oh1JzxjmRvzWJ4GzZXf+/hKptYyo1D5K6y/XzD4K31TehEcGgJGOn
 OJ3GBq4ovtNAlkjVawu/nHiS7VZy7DCdknM+nF32EXE1mn6R2JDGBi+hmCMlifzP1wU3lh4GLQC
 TfX70d8OPw+pAqWzvpZd5cxUJtZab6jpqaJnsurPw8kYnRAEHIvW7Ga6f7h3M4AdZAj+x3KiIam
 jA0RNbEbbRPl0M+91ZxAGncuHOdwHPCHt1zNtpRUGfVmgViUEjMcGQieyUpLcG/PoQ0Ljbn7miz
 aUqsyJCUqTyMcSvv5TBk068RoRkuiXb9wSbX/gcQ0EaqxmWyrD2jHcJPCFL6fm7i8IKDq4mcKAh
 avWiCOvFCb6F9ihaU6qIM2bsHjOee0SVqqRiazHpodnilhViUZ7MJ/zirvzO3KxKkWZ6aQGy9CT
 2wGqM
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CEFC74000D
X-Stat-Signature: j1kimcfg88sya6nuf3p9remp9ca6ahpc
X-Rspam-User: 
X-HE-Tag: 1772483302-262751
X-HE-Meta: U2FsdGVkX1/DDekykRTQf/x1vrFeOLRP/xVgQWWPPyx2Xvx0RM81qcJi0kolh8HlgPoa7nmx5cIKKY0LsgA9sQIw1eBtrl2cubigVLrkC0KqO+Xk7d4nXyfsP2zj2eA/kqt33oPNylDQO9an5sLvY4yxAi0yzjcQcSG+37wW997mPLlNXrjv72jKRZcDYYQdQs7DTPZalYR1zcXx56MH5rnz3wu8WzOzR4C3xgl2VGIfEhVDIX73jZTBDQgkeh1cwF07xeDtRQvz1JG75rn0iG/xafaT0YktMmDYtJlxZeNNl1idJaUVRCKFEvwjzx25/J6D7KTT+6An4kom78k3X6G3r15rpdUYwegfQfrtGDjgtpQUnT0Q7QuducAISQHnXv2IWp4fp0234Zrv1g+cCUKwzXwWx1EViETPrm0mCLk4UXkIg2reWY7WB5ML05c2IID6CXDVOybNiYU69HlcZeFwUwA4oXGrsTrKkCBHtFtLYwOvjN2qIJJZYRjuJ3h/4LanArzt39eBhToYNGWZRXFz1ZXeKbtp8E4VPoBlU0OWmeFxcivqwfnLmkM8rGYh43thIqBaoyUQ7H8e7w2khSY1NPsQGShwcNUnfFmgBjx48gsEx3TKd9ERIXj1lJMmsxYc8CfhPtCk49cTOa8tulQChWnJavdIxqcKBfM+wqeYR7j2iy4kkEPztNMyBsbP7LYVBEL2VwdDtKekQ9SYKeRrlZleU4uGEzy0PaIY/haaKxN/cATQSdGKPlBWUi3u5trm4ta88TcWY9DbQxwZFpHHCIqGCNr6AQtosNed8+Vc9T+9tWE04gtycI0LIX9s+WGHtB3rD6YG49syVk36f6IyQ9u/cN1GvrruofA0xCofMolib+oQ58kq+VH6Uf7feLjRS8URdH84fMoyqTPzz/6RQkSDigGpvCU56nqY+r2VYgng9r1j/9EQuapLX0chIRlaxwZAqrl2zzXREDT
 /ynvrVEs
 Qs+W6SsuHFrZVeP7d0zm0bsszEo1avevtxPhDa+f5LHXW78pMx750G54kq17qUkeSMPtaOjJw+oyA6hOoiV7FLPLdlNNq5tdR8fZSeQEBlOw3d7LUuZI+HW6QZmYzuHTN9/zUNQHicZ9qddu3J1A5OvlNN9Snb3r0ufOzWOPUA1pRuvE9DC3SQoUSdf/8m9yzAKO+Xjl6j3gRhH+DdSH0UFORLSJ0QkRSax6zt15hLvE4xxmuGf7gH/X4gj6jrcxz/z7ph6fPdwun97b+MJ+5Lo391t7/KP8zGTWWgcfgExyll0lgVNh14AH8iVPPhMWD6AtBkD4h6o2XK2RcJm7MjSc1TnCYH2ibUDlpdFXaS4/pQrkTB/EJhL05L3UzPS9go8yhlMH5OqekNue0IZ+hhKYWMWxCJnXizVdn4iEhzkCfgNS8wzHUU2bVy5WAOVYPeVf1Xft0mFePLLIopL4/SdUP2YIpFPDc3LH/pq2AmVgLbD2d7SeKSL4W2PYsFRaru4ECN50mi7lIjDevb3bz6KuAFJQDf47vO4/EopJWBvbpxp5sVvDvxPM983d14lC1iJKM/7m7necRtUF5KYYSBjl+HqbMwtjWUAM1j3QoOk//4ITmpCRY0fVazL1jT06GaALNKI/XA9hPs/YtLoAkDDl/L0pWbp5FTk0y/aWC/qObpE274iTKuKl+AAkqxW9ulq1n6/5I60NhGZl4B43tiAjs5zPH7lh0WpI2nUYRdLm3LqKUztku/84XXjni2p2VbhFOitarmcs8uKrdMmQ9E/RhlVx7qul8y9BgkTcKkT9pt6wHA0WNHwNFMoq2b6elV182y3vBKwKPf8kaJ1jL+e1LEOImJKZo94p/yoIX61Bq1OXydFkJ8I7PnUPRnbRc0qvqY64hiejJXwjCFV+uhlBi9X3C8378MBVD0FrDKzMAOFyEe5/WIoqUmeM4ODgsT1NIx6JOz4GnyPTnBU8mY5Bcs4ev
 0I8AynH0
 uVP30gDfxHhBriwhrPDktrS/1QEFCjPJpcwxgnIsp9pUskIT9Fs82ou9rQ/SayXBRQsVIJMMUX1CVseGMb4ulGhHhOR2YGF03DiDktZE+LlQ2VKV45FE1XOrptSuQWzPir8pY/fs4VwU1evPxekdoTDamVFUwdyk/8J1+I95oMBBoXu7W9hVlP2y0KK+Sbzqek/Z3PmUshrKkUemVFu2wcpHE2T7TzwY48f7jmnKAVuRycpzol97RwntXjRAY9Dd64UkquV1iJ2n4LMSTdDhJlXAciB2zECUW7ZebzpWcCwGpUVNR6IQFTNgZU0v+0CSeQyVYtgSUdoUDj9ZMQmSOUlalDOMXVx1zZxK8BvAnf6F7n2qqmLGk4dWz4ylaEVd04WWQSbIW960GuvPQv06AuJSOPJr23qYYCXqrlWBxEPBailb/f661UMxsNuoTalQqPr8BC2QODOnzwyERA2QV9q3YLTntrqZoxmiMr+ZgmEvN51jqHCbe+07EvVZYop0TZVh/hm4xUfTFKee/v7LKV0lCEAoWlUKbQsqihQQZ7FhstTJW68Vb0DO4Z3K9pDOEERVu2wzQdKA7jUMroDi5ZEHtPQ1h0J3b6k7TgBR0y/6YDuyp0hqVtgvU09dmXQiV+2gGQlj2KkSnSitNFekG0yEMQy3BPxWqM6Y+FBRuQAwyzaNtwO4sWUP0F92XHVZnyyXd2c97b5YHTOrL+3Qup7HSGsWwJcujcXEvDL+O+sjQgum3Hbwb5eKjMLLbcQeqYycbUGRFqbl149hu4XT8tie0FJ6reKp03mgddJSH5nr2IrBNj7Uq/A8DA/ke36Ls/GGoXWNhGkfu4d0kehSCzehcuQEuSnhywgndSmcJecW13r9p4hVbdIki5voAorMsrN9PSnRz3CpPfUFHX7kb4/ArvTKHuEhpLzw9+lB/9krZsxSvta1yyFHm0Otc9Pg1UPBZord1wUVGtxm7c4ipUnWY2GTn
 YL7qGsy2
 zvY+3QEXbx0UWD/eRe4kgK/rpTx2LoPwq0feBh+ghby7jDa62LRPcCIbSoVSHUHdD/OJLpJV3t5VB+VKR8FiVkkJtZZStdSUW39RzZjfJ+fatNWQXaYXxYIs2QibDE6USmKq1UFGRL1U8xA4Nt5Pp/d6D1mEtVAF6KfYIw9GQNnBwQLsIe4KaiVOBfIvMHeQcSTIcrhk70T723TTCMeu53du7VNWAqhujSaTQfaGmFDPHHkiV+oVcLozqOBgFOWzNa0bThJGiL+9xFrCo0EDo+GMPqmtbzcBXZlWBwNHDDF+J+2NUhGl8mwC1tAivibuAuR/f3FS5dPvomYIm3u3YjMivnwt8nO+VsC2NZk2wxZs++32TEvkJzWTpwkP42V2CO8IToq5gCPPmItwZrcS9KLGlc8258N8ZQaCH5YzYQdRXl7t5CW/1tVOMQrjwYVe0FTW/7Xx57t1Bp+c6KUo3CWjdlEyQKOMu7D58eSFogzwxL1vKIzeNykglY8VlNqkygRRRh0fw+WkafXQMb2oOxQgkhGgiT6NH7gjN5hk14uJj3CLJ3bR+CUT0E+DOv3jVAQgJsZtAhgazUpA4WbK3DkcjJWax3FS1BZScloscWdd4lEuSe/klg8w2SkilN+mII2lewKZHt/c82fjwnG3AvZZ/0D9gDDAfKstziBkOa2oZjHFbDd48O9/Dzc6nD+mj+OBWVL4bVspR9rQ5gRIY9ErpGi7T7hRxVR2jvSjHD5mk96yUupxa4loN3QJN30aGeMb68X9lzZ+t9JEKdVODyedh6zHt96vAjQmAnxGA6RGsSW3lO23t1JwOFtM9ikzNNhG4Lko3s6em0/BxiBVHWI62W4I3Gwylwfia8ylrGby0Mj726xQVqLvk7uSBYEGV9Wcs2lvepEnnQPXVnu6v22yS1Snmn4uKbzM79sNPFlOEedOY1cLYdbzjVZBptRoN8d5nKflpR/is4sjaCKMcPCdhhMaS
 d5Dgvbm4
 /tb0YkPWflwz1rDeOC3tWflGnfPtJDXqw0jjNruOZRrcrhgbnY4rYZ5lQ1WzJ+8GntE0SrAHYgAuojQSdua89qZK86Qbf98dAD/OiIxvdsd5S6Y9dIkkauchWEWKbnvu5mpsSYXY9ZXKWjJEHqgV3iNchRXGqhk0a9BhAeXepNPv+UglKpmA/MMYOdA7oqekF3P5bmye6j7QML23KE9T//LwzCLDHCoClIWfbFp3EDRCN1YlS+zXCrVMCSmu6Vj64/yiJJgRjSc5eNzoISdnASlsVo67OXYDB9y41gBeQMiXS3TgYFdEleGA8tH6CBeAk5iRYKB2XshLYHTRFHB/qHmf2f4vfCg1Ca28lGIf7pEqzQ9Wg6tv/NLuOYwCIbvGQifDk6uacuRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert proc i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Update local variables and function parameters that hold i_ino
values from unsigned long to kino_t.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/proc/fd.c       | 2 +-
 fs/proc/task_mmu.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index 9eeccff49b2abf57d766ce17fe47070c379ed2c8..936d0258d688be5fdc384ee5c4dfbb8fa0d19dff 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -54,7 +54,7 @@ static int seq_show(struct seq_file *m, void *v)
 	if (ret)
 		return ret;
 
-	seq_printf(m, "pos:\t%lli\nflags:\t0%o\nmnt_id:\t%i\nino:\t%lu\n",
+	seq_printf(m, "pos:\t%lli\nflags:\t0%o\nmnt_id:\t%i\nino:\t%" PRIino "u\n",
 		   (long long)file->f_pos, f_flags,
 		   real_mount(file->f_path.mnt)->mnt_id,
 		   file_inode(file)->i_ino);
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e091931d7ca19d71f31699913d177eec0821ca7b..702b0f0433f91077cd0d0af4a07e9d67d9fa9a45 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -442,7 +442,7 @@ static void get_vma_name(struct vm_area_struct *vma,
 static void show_vma_header_prefix(struct seq_file *m,
 				   unsigned long start, unsigned long end,
 				   vm_flags_t flags, unsigned long long pgoff,
-				   dev_t dev, unsigned long ino)
+				   dev_t dev, kino_t ino)
 {
 	seq_setwidth(m, 25 + sizeof(void *) * 6 - 1);
 	seq_put_hex_ll(m, NULL, start, 8);
@@ -465,7 +465,7 @@ show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 	const struct path *path;
 	const char *name_fmt, *name;
 	vm_flags_t flags = vma->vm_flags;
-	unsigned long ino = 0;
+	kino_t ino = 0;
 	unsigned long long pgoff = 0;
 	unsigned long start, end;
 	dev_t dev = 0;

-- 
2.53.0


