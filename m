Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4540EB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D5336B00C5; Mon,  2 Mar 2026 15:31:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 389426B00C7; Mon,  2 Mar 2026 15:31:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2752F6B00C8; Mon,  2 Mar 2026 15:31:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 152846B00C5
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:31:47 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C3D301B73D1
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:31:46 +0000 (UTC)
X-FDA: 84502269012.29.359D21D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id C36D3C000B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:31:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fd7yo1LT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BvuAncs7tau/EOIqJH1mLM6xVgRdKb0K4znIsXF8x44=;
	b=fl87iHAebHREJkCNzkJPqnHhNuGgRxLbggKXN/CVNvDQayPusyHlGN2do+ILWKoeHmEFaJ
	WixFAgkKd/obImtBMx9GnVDI5fWgZHvYpGCMdsE4alnm7smPXhxojy6yFenQ79a0RAUUPq
	Yo/ir20Os7vmR9/0rIW66k42qhxgw4Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fd7yo1LT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483505; a=rsa-sha256;
	cv=none;
	b=y+2FNeGNiWUz21ocfQJSw36vegSD6OO0SLR3bYe//MIDWhVn2uHRuxJOAfkIsESb1Ip4aq
	ehOp9mtaTKPNdO2iWB3n2SyNdAhoGIsgqqUoR21/PMfpLqbnS68t6KA0BiYOYtTgeDKGY/
	9HDdFanIdBduDvj7d6ep2U3/2LgCwgA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A54E94374D;
	Mon,  2 Mar 2026 20:31:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6B1C2BCB7;
	Mon,  2 Mar 2026 20:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483503;
	bh=wekE/Bi2k/fqUlznYUS1Zt4JWtkXEPagUOCDt+B28VU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fd7yo1LTsMfOUN7EliqmB0yPYFBe7ZY8CFHO+5sVxI+rR+SMGZ8i1zoS/7zhVzL3S
	 q3I2jO5N7k7lnSO7aYU05WXZeoLfD6/C1SX7kDCUmTwrr+Th6ttIn57Re8bUAxquvX
	 qYWpl6ANuuIwHP+5iv6/3N+trDqGSgBiKS7+qgok5Ww5LWLT0v7fvuqwbg4l6NAhV0
	 xO5HrOIYXfNvrWAHRVLMlL0LY8kYYKvFm86FrgXq1WdYYCptASnxKNTCVTpDAeMWMB
	 kT5po7Hs2kA49XgOQDHp/jnCybTJ8yYwvyzlBIOmrRlmiS/+Z6s9cg1NgiiFvG9R8U
	 Hk1cy33siwgpA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:12 -0500
Subject: [PATCH v2 028/110] exportfs: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-28-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1095; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=wekE/Bi2k/fqUlznYUS1Zt4JWtkXEPagUOCDt+B28VU=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH2d5YG8596BxmRDbKrF+v3TG4vyuAwgzGll
 VnVdTt/phyJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx9gAKCRAADmhBGVaC
 Ff4NEACRx2Wp6JBmXJbj2Besnbvhwf0ofGiK4tR7JJ9Hzm8NmMBqV6ee+WgKVot34tdz3LEjpYM
 YV8jRMgMOpsZA8WKvFLe3i3a/foaGvci6hu3dy7P8/g6zn+6R+ZafQrMz1RR35i8CoXSjVzGxA1
 Kkrl6U+QjESR43kMcTUZ58UbemFNZonCwK1yj87OeRtTejDJplVB/r4iu14lp0hbBpZ9nk5+mVT
 yfa14S5EHvFV5aS6+Swnh5ITEjbLb6rCGbt8bqp6EqDUmAe0jGptay6O+SD8951aEQfela8YgNK
 jyAkcpZ+BOZ2fVTeDT0o2Dl5jlsoy0XzFCsqt9UlEEjSlJaM0RbeELbgxEeAYoHTUW8PA6QgAdS
 +7pr2Efbh/JV2g82ILs6PYAzbJwqfwH5ZRJ/WI4yTnxIPEYZ91b2UfWU/jc9vWllMfYi7pOG3Q0
 AvUVh9XiC1Jr4CJbKFrzLoGm1xZBh55neN/RAK2k0WpjtPOg7e0ixOFjRfkCMrFj5gLbsO/EMIA
 Qzu9ihj9DDMLB3GjiZphNYo/4LVjvh5c11IMz5S93U5WVIxPajqAZPOTaS8hW7qG2hMHt90ht/T
 +dJ2s7TSjVSJoSCtDjsZL+djDPVkOPAkObKX8clDYgkUZb1y2qn6EbA+V7QyJqIFqBDF2VGIS5F
 zjgJOqo4ZpdMtVQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C36D3C000B
X-Stat-Signature: nnk4xhpbkg77qerpezy6sg8gziqpmunk
X-Rspam-User: 
X-HE-Tag: 1772483504-913949
X-HE-Meta: U2FsdGVkX1+TrEs1VI+zARX7szFLiXWHX7nH7CGMF4h0v/oM7Sg4KPJhfCGXB6l9M4XjLWb23dnfSKd07uv23kUBFz3GDQxg71dqqgiGjmWT0q9mmrvPkWOKzHPv4K+La1KsTejPkYudjQGKPVqc+O0SNBbGRwYG8iAxAbIH2Cp21jh0th8XpmeCa9RgSNTkREXR0MxDnkX9ov1Vzb35ZymYKLMQhDbT+uKGfuLuz8pL5vAIkByq9OGgDw0fh+9FZRiBgpDxkALV8YOVpvyAozhTrGVjOz4QSENNtHPcqd0aaXrNQ59VS5mPfVRhbH3U8kr5jrjTKm7icYl3pM4dCzqCZttevctdGAajkcJW9Z6lbiqGnpVFpHgW8npBWGudNPcCzy+X3V2tCcasrviAOeOV17T6KFQKVhyDutHfakPgL4wRFiinEosWdFPEFzwB4a023zYYASrrnYTgY5ibxWtRv9lstEcqRzVv+yd6mMNpTNfzBmRrnttfq2Ylugrqa/T8Awdxm4c0tJrPInZjgkXuCMqWYv7IyJRlcWOHG6F3gkWY+Lo9PUm089c1whu8ZH7/0H7OrG86uClftfml7Fkpo5bkp5IJbQJn2fwHf8tZinGIXzNqZQJcjeHAO+cefwXTEZwTf9mQ9n9iJiW3XKf+z9FJ6vdGL+7Zuwa3yT8JbSz6rBy53DqZTA+nrFoGQXFA+McFdzRltB3LTKR9c1fWj1JNJ9Nut61oinTathGuFdqsGzvJidAKiAO3La3nQtwSm6xXymPLF834OJAP0jq2lr4HOIjJDVXVUUPanvVQ3i2lUUgKhVPbea0FJjckI55BhktSK4Btg+G/Jk7/2sYNBs4x1+i+Q/a+g5iiN6iljw3T22pLrdL0TtRCXKjyf1qjYzNTC0KBJpNURnScbRjajRoX/wiemDzgglPMgseBoeWNIiXGkHhohrP5V8pqfRUKhkXmmVbgxePsQG0
 WAqHMB7O
 PULgSniuZErKbbnL6U4Dy6TpAGIulqf6dgy3PlLaljrjL6qmygxVJHg3oxhkrZfEFO4wD+tXw+n0DMSMhMa0yWjkoAwt2DZK0DmThIJ9hrvbH+aWwfh2NT0Bv3+YgN9GfQHqfDpKYfN1aBVnClyPCLwdlhj8yTc8hn6qrUcjfgWqMnNDKkO9wLxJewbqf2zLkk62T5GzfzPuImk1t7zq5cnL1EMTrRPYB/Th/fVNvp7OliG6ybLpKjGjBb9sVW8Fm16vpYFQRYu5rzRWMahsxq97y1VFr6Xr+nISF/Tnnd8jCh+O/1BpwHyc0jaRc6mHRXdRtoFu3FjwuJAdH0clBNnjtz5PMnijdgnMzvLWWOqZMFh5HJo495ueW/N6Ii8CJYqvGSrq6/eHfyOCg5NzqrFYNVzc1FFNLWaVMgGGjLkOr6gLTACzzaWx2tPbz1mbOv0S4Xp8W0ovImwYwgUqdOnS2b+BRPvB5ngTMUdwh6ozH+Qbl1lDflt8wZ/SB1UuVayO8f0tYO+EcM7aukzYXef4fOxtMDmfdaRDOo4hwS43uy+WWV1QwRkLmiKRTmjDclVRaAIO+UaPndSkPlPcOwRw7fVZK3qY7lzWiOQiRJe0qi8VEkNTDgUx+U2+9BWZrlEMgudrWH+vI9aTJ2e92IweUZjwfN0PDtiplHcTfMvGjYH2x3qmUsxX7LXR+NRUGXa/YvrrFpQSt9ziGY8SAXGWbkmPcXM7yRQEyIG5PbTG0OqOsBxaOwko2hjoszifljZthIYaYzSoduPQ2/e5tqhdCJdNJlLJq44Ml5h8DZHFOySbsBEiVKwOk6Ain2KVnBn2P2nGXbBgFZZ9Uj1KtE6Jwihg473RdjP5FglU/VfEog+Jd6B+hIJTHIZOKat9nq0qp7QRNownzD2R9V0ePe0X/a9Ky+xcoDYpg+iN2KSk+dEN9VMAV6S++OMU72w3xAXsx70R+cu9AGhwheXGDgnexHg1c
 9Ssx7SwK
 leN4O4xqPjqk3os0iiMjqkHX4ESO9dmeJGsKyygsS87L18Gm3qkptb8D3Z6UZtF5wLM7QLXhW6/Dl8Vcfiq7ATe4rV/338nB35py8BLrAqY0GN9rbR18+EyGWmAq24R8HoC1z5BgLPX75Ad9qsAwlLUkxhO/nkgCjOk4wbBJ/7UX5GD+soKI80Vk5D/DnTwjmXmUBiXbUohCXOQmAFoJPlcQSUNm1YomU3B0gInhXLmJ4V+1eoC7tlCA31o2myy3Hg20NJuiFydk6KCCua5MhPXd5DTz6suls+Dqk/1BnBrIFG543sU16d1M8VVV6JRkTQB1VYsra1L6c0egKROPsTg9hr8n9rz0IRP9rof0gLTyNI19m3/5UempzKu1fk42QexW0olxW3+ozLp++74L1Emqa6lbR4vq7m2EsPaAdBVkO2Yexh8WqDTbuAEecUUd9QDjdPF/+zv4BGQXEwYT6hA/H07xKlMaO76Inmki63U2aI127blX1Y5BLpd02lNJ5XfD1SueSeZ+NLHkH3qow5b+BqPdmaBAWj6R+uzpUCuPUCUslEwzoAYY92iFSYTJ+9ZrhKwG0Q/y3KSGedgei6h24OqPaLTqR2T0ODWfAqLkzCjP1uVUM6fuV4Ws01v72Qlm8FYBG0FRGimoYf1/rDmsJUDeElCixM+whgVEF+cjE9R2bu8ZQLXJ7ZDQGOZY5h740SgYCB6bvFf4eNSI5sMZce1RqQnNSH1FNRry+YtCg+YzsfYmr6CV6tFOm7Cwuuxo6js57fukgzeE9GLzMwBjuOdUNqWsViM4T1n8NHzWPm9Mlp5+Zaw+4OCaMXhNgWg6pRaXUlV5/pCuBBZnJkG58UvVqQ0cKJZ3CmuB783QGK7bPZ2NSVS3wOmlx7uJ8SzZAbpC6AgVj1SYfIjdzTDRJNh7kDaQnGX9Bo+fSvJWRyuxKbIQDYZdLMCad/7gmq/wqEVQjQxVJYuLvJj0nP8IPvukm
 AnIsz506
 /8UzNAAzpiBdMgrd+lWnNjUJ36dv5ikho4oqOW18tG+Xe2OAefg+i0XD0WVf37AEcEUmwBfHwaBZcAavDoL2h7uOwxZU/KkXII/VInqUkE11//idwNPfeC4e3IoqVM7npN6/4mq/BsxLu/wBqvwVhtt715h95AEJAzNX0FhZNM1XF+Wr4nQJpJzkAoV20wLlMY+ygQbmDdhO/m4R2jJFW1uuqgyk0NrOi7B39EPNpoxN6ypAT0zGETRiqQZgE6ddFYK28KfmpiyOSTfAfbYwzvHL7T/5N7r/wdEUd74oHWPJ/kM2pycBP9Fef61OJ/m1QxLbj1j5ySNq1PZ27u7A2vx4p3cNsHQCkB1mw801HOtitJ1yODJ5QvKrbqm8QkSDGV6h/X6WEgaTDVZxZZwYFHr9LRS1vHYPCarGPxkDxfUfaFER4URDVdG0RvfVnnb51Br54QFZzzl1IaknoUEU3M/WQg3ZLSvVVBVnG/i76AQ5C6F6xhOMmQ1EFN2JXUHU6XHG2rRnhtKLi9BQJBXTHM+IBBaMFkPIMbk7ffuGdQ1iZdu/EA+ufo9EjXDuFUPHRa6sHRSTJsGTWCTz1BmUF8JH6b5uDSn16Nb738zeOONXkl4KlpnQwBsxSj0mZRpGZ6OdL5XYmJgvaflPj8eDSvXj130T/+dcO6bKnyWEGpl+8LZCpfq4HWAegjw/zGZNOyhJ7cyzhJ13dyz/hHPBNSLIEQfcsm6D0qC9nb0hmU8Xs7ZrFp8LFUSrJ5d4kc430OfYasMjohDGCaGO5Bxl2dEpEzBuBr9nTGKV7lXsbprE1tb9k9LHuO6NfQpyDOiM+qD5MnWe4r0reqviwjZG45/gzZL8JCzKiwNQ4sknQIkkpti3YfdZXt8Jo3PwyvG2dHSIqFPd+TXYw3JJiTW1aKiHCr2Kn02SrgMEGeCYgNiDBUedUTLlIp9/04TwPWxRNDMLaClbyTqjW+pDOvu92Pz9y6R7t
 n/jSPBe3
 5C8GRjJqu91TRg4NcpxuSPSDHiJa6FY7VzY+U/iu9aaiY6Fcb0DPmFRXQM+ssvVW/A9EPwYcsUKdQI2a1+hsINWtS7n1NyrqBhYJ2leRuFumz/KMKhwHt39h8Lq6RIwhiLZbCPwYnxRlj+CcZnFRpnrJbeicXCYw412qEPYcxwgVZw43o+jPR1TDcSjX458xVsTGH4SOMPshvYMhGCtfGG0dKUvqWn5vNEnROK2i+eRYyl9geXqpNgwmdSMnjeZc073rdHzya8thRuxfWioErglPAjfl/icB5e4pEKDT7oZH0wA7yGqXg3UX4nil17U3LDX7HQ/UoNNMc0+GqoaGMkfYGBNt+q0Zes4MnlQVfD8ki2U3IhSt9AIX0uQAJtW6wblJtbPoyerQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert exportfs i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/exportfs/expfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index 6c9be60a3e48dc5e984a826029375550d1494835..b9ec3be466a06c9ea90cac62979887c3fe1af5a1 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -130,12 +130,12 @@ static struct dentry *reconnect_one(struct vfsmount *mnt,
 		parent = mnt->mnt_sb->s_export_op->get_parent(dentry);
 
 	if (IS_ERR(parent)) {
-		dprintk("get_parent of %lu failed, err %ld\n",
+		dprintk("get_parent of %" PRIino "u failed, err %ld\n",
 			dentry->d_inode->i_ino, PTR_ERR(parent));
 		return parent;
 	}
 
-	dprintk("%s: find name of %lu in %lu\n", __func__,
+	dprintk("%s: find name of %" PRIino "u in %" PRIino "u\n", __func__,
 		dentry->d_inode->i_ino, parent->d_inode->i_ino);
 	err = exportfs_get_name(mnt, parent, nbuf, dentry);
 	if (err == -ENOENT)

-- 
2.53.0


