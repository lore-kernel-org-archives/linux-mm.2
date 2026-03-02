Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83233EB3634
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:46:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9C246B00A6; Mon,  2 Mar 2026 15:46:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5C4D6B00AA; Mon,  2 Mar 2026 15:46:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF3726B00AC; Mon,  2 Mar 2026 15:46:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BF84A6B00A6
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:46:50 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7FCC21402CD
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:46:50 +0000 (UTC)
X-FDA: 84502306980.23.1ACEE55
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id B81C040004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:46:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ao8cWXeU;
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=224gAxWg0DZZ9RcdgtiPF5PSIYOmfXJn1BNm6BQm4iY=;
	b=WBGKDdNkssFzjG2szjCaCBTcnstmlxMLrTaTXNDSAesU/mOtbD9IZunbdeHYk4m/7CMwQ2
	D8S9PJlLYiA/YihGURk6NR+ECCclTLPF8kGEhvfPiC8TuABuQZYxM76YkyxPgKwZ7MphCg
	awLojQuGkKju+UAjt+vNhHL0exuWnmc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484408; a=rsa-sha256;
	cv=none;
	b=PT3xxx10yZkaxmexC7Jz4hFhEbR7Ae15yEab/dBHUTsqVfJB5RoD8g6rSeRwTJ8H2hZUu5
	26ADH4rCHeBzH+l+zteLTduCOE5ZBFdz7IGza6Am+4RG6BzLNze8R5/1QzkaVkb1byeC+J
	MBRQXDgtUhdJJCkxnZXza5K/FJiybiM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ao8cWXeU;
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D0DD60141;
	Mon,  2 Mar 2026 20:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E7EC19425;
	Mon,  2 Mar 2026 20:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484407;
	bh=vp0zPvf4xGJU8rljdJEp2XVsjnBl+O9vg1b2GqgCbLI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ao8cWXeU3C09G1xH+QkDsKkvNhRkpOLVBv2yk1GUM0JbIv9pTPlWFzDh7wDwobU1k
	 03B6hNEGKWBIA9+zJxX9wJQaf+qJ502R//MztKoI+4NBvQSKR+/48T0vL/HEGlXC2y
	 Ek2YoHcq8/NY90GlJ540fUYxSaFiPukIOkbJViutTH2V03vTM2J9f+bh40+1O6T+fV
	 EkNeJIN1dsmt9P1whwPuNQNrlHNy4rYanqZ9NqkUJ1t8zA8Nj7Kp4eryWYAgk6sb2I
	 ubIqZzyyjnsCmuyFfWgQ+8dcJQenHyIJWSWa0vDgNqWVLmMs26mIxU1ixsvQMbAFaz
	 MmXG8DWwBeTLg==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:15 -0500
Subject: [PATCH v2 091/110] ntfs3: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-91-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=843; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=vp0zPvf4xGJU8rljdJEp2XVsjnBl+O9vg1b2GqgCbLI=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIIVMHHvceWBREHvqQurM0kfFdE+gebjZBd8
 i3g3r8xANmJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyCAAKCRAADmhBGVaC
 FSwjD/9ZAfgzGHA/XuhcN3+Qn8iU6M8mbeFn9K8HG25WwxL8Ryj339D63XriZCJla5mdb3xriHO
 Wa0WTzXWUDojsc9FLecu8CXqxsHFeXUQfoyb4WBlA2ldn+OJY04Zf/IRPUHFTLPOY+GiCSbwtn3
 a1TRzXxhX1AVr2vMwg0YabnT20XQEB/otx84bAx8iYGahuGrFrY2g30Gmcy7fk3nIkrIMgy3AKR
 hyc+lnGS8RZe4HEAk+ZQw9eN22V8zAKop8PreX7joAs+7cZU1DzXQ+qSzv6cGL0YZNDLjYp+jfS
 cJeUWbBZWQyrpOC+DPTGLZrFtQR4Auf1UOHvwVHApkOR4Zmsl6Z3U+3n2cYxuJNpi98KyNh26lY
 9LklbWv4bGi1sfDkh8ldg/s/EZtokLrpkdBckpc6i8dlQsrtCJOCUX2Ym3CY2dEzplKb8Bu1kDB
 F7BjebEKlchHqvOgrXZHpOI0BK5Y3fDdsN8oVzJ1+rf/XKwWVa+lk2Rf0wxK/CvfyvzcbmRT7h2
 ZV1fliYg7z2IZuHQBjCivcz8DS+tb2zLzxVZdFWx/NpQS4o83zrHzBHvS8n2bcKg50j32dGeKPQ
 mB71C2Rq4OjKabEB9z3Zqd2hYmJ6dzdSo5Ak52R0k32hWu1uFdZWFm8GxCab580XDPU7gaCsVPk
 Dfu+nE8rkBBvgVQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B81C040004
X-Stat-Signature: yeqtt8zut4h7grsqk3s4en9fi1kku33j
X-Rspam-User: 
X-HE-Tag: 1772484408-101666
X-HE-Meta: U2FsdGVkX1/EIV241PzVOdoQmAfp2GXfXsRiDiLeLRzhUkCGopQA3y/P4c/oJmMq3QmTArTM3lk4J6vsD0B/2UAqutqu/Hmg32bUohaK/FhHkQ43do/oOEFAGeAuBNjYjcsqBLLF6keT884eeo4FjRJg9F5610+9WToKCm9Ff3cHvNh2WEkflCsdJGSrs61zgxDCNaqW6PoDXaKpZsUumoj3ucP32bzKUtNW993oiWn3GOT7ZQSc+TouzF86kJTVbUqlzLj2LjZgPzZud7tQdAgH6zh636jmTwaNyLs8k8V3GgZRymb0xqNrH82//KZtIdfrE8vDnHiwqAdEqdSmP55N05RUAhIhzV3jC7mMnVj/LYgV6T/EGw00ntCigZuw3bZV9Jxo+Iqph2SKE55oYrpcb+Z2UqPNbtufN0QNmuBHTaOObbX1EMjv79OGR5meeKY1CJTDlLvxXrhqhJARG2KFlZGEwoBqzjIotV+zPcGkhqoJfMkJLJmqqu++KbHjXokOZ8wLh6dgJ6ABYHET5HITSEjXndyD7BQe7K9sNOuiP0sP9emJia3ldzQJthGgzE99LgwFfv31XkWq8jVS1P6ioImZh217x1cWgNhNDmBWjeURpURbJ7qlBTzNddU54Y3D6wkHkchSwxquxs1unlbEqiSwUZaVIfNhMRsdXwlsmw7thBs9sA6LakRy1PydS4xA7I8zRgDoIVBHWPwOJjITi8Qw3UsXgO1U9nPecU343yVWSDfTxwB5F9J3xAaP00LFoAC0ADgNxEEWMoZUVGqnILZl9GmNxFe371AVhKSKibPGY7bt+HmbrHECv00Op7FKfzRSrzTxT9CYog4k5i64f2nSskNpr0phqXMUWgkupkKgMwLYVDwjQ5eAspk7gg9wItk7VfKqKp0pZec9Mv+p9/lEr/LQ5D2555gwsb2AlR1QujqmLeubBwpC455NR3ZlHqiv3yTdZgn1O4/
 z5bFbqY4
 h4EK5tIedsbMHhS0PdhjM+bBSvBwjqUXmfq+h57NY11S7W4o2iyOl0Ewkr3nY92Su06EThsSS5XZD1GoPrrmIOXSkhs1YBypAAkbrfH00BMHOmD+q+eZIxDt3RMQhLh41oSgIWfhvkoOSreUAYbNM5ot1vmNZpylIVmU/EDRrMRL+c3hHSkXUiDDYNBxeFemcu2Eaj5QPOZQl0cCW8VPNTGXlHo765O0A0sKJ7SN0KekMGyoZxLgJfT07Oh845jSfBTrDjhqj8OCo1f87BR2SFeHdGM8dv6mEPWlN0aedtVnjq7G3wKJEpHqsT33E0Q4l1pyoyAL8RGmqt1YSLHf5MaS51cWXAUR8J/5tRlhiKpBF2Wag7W0bFbfRlTOdKC2P9j2j8/fqCw3UHRki6UAyEbSizY9o3EkpoUkLzXZrcEUhcqnjVqc7NVz9CNse/Ek41uiw3LQdDwnPsJ0oBgmP22SgCnJqQZ1zT6Gomh+OlpICnYk6epnXsyjEmHoa3c5uwSYoaNx0Qp/LxKMspFmmaDOkQld7kT1sE5rcm6LfB6kpLWrZMF6S9LKJCUKqvNSZ31O5tBpvhhYV9mOGPxesn6eaRV37Y4nFCCRUZ6PCZzH1xjTfbLqIHGYl640blK0LfrxtXa8GsefIPnciHh3wieUtWv7g5RHyz5gghF09EIyLyRhjsIFxgZVU0R4G52Q5cjXWpfUA20qTtpKHHJk3cF4pPTYyooEcRlSGgzKOPEXHzlcseqYowBMPWZEj1nsA8nKkBwbqyWOJ701xak2huQsuYHQE6gQI8X0qFoaB5TwCnH9dxQRxKfhvZB2cX9K0ouRntnaEwmyNCEz0Xd7995iZHUyj4gvD6ZFDH1t2d11GNyIF5Jk5weBBu+oyXx+Q+OYgi8pujc1fyIjTp/KjFZ4qTSvP/Wx3j5fwNxxQpqmXxi5A/jnBen8g7dilyY3WP3DMWiWvwpffIVtjB4x6hyeln5B5
 MVph4xTi
 6bt1/m//eSEPidfRT8wEjXYQUSi+wEAKOPWgtDo0b4zmeph4q0kpRrbiq3jANHJulgfGlBTECctqAKPzFGeVGYQ2Dt74XNkYvrMQKxZWpFiPuC4OolyzS+NyNSePxHRpiFHJD7/RSTmVrJq85sVoFWpBqxeyiSVnvkFIxHZaQneJAtWMTNwdBLdkeD0OLSifUfM3VPLA7focA+sSfgES6xFDdeT9zo4zEasZI9l8J7IeSsGhrI6e3/MgETcXnAw+aScmFoqZEiiKAojMSBLWXbZ8YOpOGTYWz+Bl0/3Iz8B4X8rl/FvE7Rt/20fDyIYGmHPZvNfvK7W6WcV4xXywD0sH0IeLN+NMDWZJ/oCw3ZrSLczPwmVBTzKY5ldUspCFfpTszgpsWU5cm1msLxpqvK+4jd14S3ttXNeoKSqb9TUtDCE5QXpDXea6JrDfNLRODMsb4WaAwGoK+9T0rD1EuXPji4+1vAswUr1sHTF4jbh8fQI6rUjzTt64eKUql82XYfGATIezqmpEWywZA6ccq9D/Z2H4rEMID9rDwbRU095pjpPCW+GhQjqnVd7YzQ7toKOcGStgmw0vkDkbyfGbdj7t58+tDitHaRgCaKN6cAmyTeSjyaQI2wMm7XQW+T8WpEOvQZm85c7Ur3p4oa8DuxS6cXuP22EAKuCJDlKNdg2DZjt1B8Dc7EyXwK+vei+tpac9rDnaWfunc6t+VYjzG6+NkyMbt3irnYZApiFT6SzaFRhXeBmCI2rrjGaJKPtAvgoSjZ34yex+bcwJpD3Ayn64on/7ESauBF1/MZ0T1tCvijGksYvKT6AgPrSOK4bOUScA9bAOO0n3Hh6h6YDhXV8ytNoegYyAPTq/wQ5eusrfHmbFbjHEkm3VbUBXcBT5QugZzOgNTZPh5BrWqzftcf2ABXdogsuA6vDm7wsxe1FNSI6I2PydNTU8lUCRITxEmzmz0lFP5q/Ps1oNJ15xPsq7klHR5
 0Jk0g+TI
 YUAPOtZC3wPTby/DIimsVymGfA9G3ZIiWqz5OF0GKHVhfS91m7jDVJJeRA3nGelyOrzs8rKgJ7JCOPGtbLBVqcavQ2cu8A6tw/X1GFL9qcAky7ULfVJaLQMrAPcmnf7CDUrpCkvN+SJmfuy0SUj8GQbSHwl87/Ibk+yASaz26fcZrBkfuXlGcJQiqpvR3B3fZuo6fsJvV0HHfHat3VF0KCCoHJjYXJorBuDefAXuOElJO0w8wjrNhnJXanlP3K0KKwtGuOEOj0/mRG2b3IE4P+ZFXMgOi+Xw8PB+3HbEZgRITh0NpSi6HBDHQ9RwHmymm+VUsXYlCFagnOqLfC0NwqPByfu6qKe6B4GfLZu2Y+efO8vwbgz59fkIC+IfAxl28MYFWKb1na14TJjkmyr79dyeZOmo0NNDcE9BHYljBtqhsEI5MlEGAawA2dW5tS97Pr4WMTmE5SqVtjHRKxF7WaBwxXKUxQWy5Mt4anJ+vAXV6IwPTvRP/Cgn8iGHWxZnDYTK6FGJF5jJCpssbuM5Yef2i+ZWC54yDn2N7HRtO8qbOZup9tdGTeJVyH5hHOUPwcTDTGyzgoAj9mDCyswlehGel38CjuUku4O191uq/stRx6lxz1jdma+h0nkLx8rNyFO8+D+1xs9Nq8H0PbkLDb2kEISAe2LRaONfLgtgAaZCeTT/iptvrgL75pUA+phwjV3JYVKNWQ139aPO3n5PAR4+dpYqSrd8GzYt24Go9kB7HkwvoLh7jpA/KKcQk6PzlZoXttkVP+ORYNfkVrkonpPouZ8vTAayP9dYdRycWo2AcYhLnIyR8XUUdM4wv/Zk8f34pOJHzbE2s0ZteGgtUyFbE2EV7aLAMe93ncs6XKCOn9M8DyjhxmNwTwLRS790q1VIT25yedYoSr31N9r7M/ckU+3rMTJ6awelz+Pxt1QQQWKYwcvXWV7vQLf7Lc3nOr9s5YRtxZU4X+H3znHasJY7rh6ZM
 iv9OYlyH
 4Bw3aiipzAIInAzpMOP4vOuU26yXPqzcp9+RYjuc/hMORH9GDIRafFSVQgv9YeICiDlGiexwlEQwyM27oj8YWPRPa6ghkJQNDafLTdZj0sYJSgyMqG8/Lgq4b1OqqdbLwvkahJjnQW/vW7InogEup+hTKD6O3H3UCRxzyYSoyposn6jkJpx0Y54MIFSVZ35nqUEPN/PUXOoqvH7pO0uewqH4moi2sypJMe/YZExDeKXtio1IDhtzhn1lAAk9K5loBFOzP5uTgklmtjNW652wr5Nibc0ZmWEN/SmlyjBIKuzbv1IRtvZ9y5TVFQT1lK8i2o+ankTTJmE+X5TJnp4qxhSthtUepHmZk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in ntfs3 with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ntfs3/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index f32227750d6f569286fd973a5ca745a655a470de..51aa008e126a8af18c39dd825a17c12df859329d 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -153,7 +153,7 @@ void ntfs_inode_printk(struct inode *inode, const char *fmt, ...)
 	vaf.fmt = printk_skip_level(fmt);
 	vaf.va = &args;
 
-	printk("%c%cntfs3(%s): ino=%" PRIino "x,%s %pV\n", KERN_SOH_ASCII, level,
+	printk("%c%cntfs3(%s): ino=%llx,%s %pV\n", KERN_SOH_ASCII, level,
 	       sb->s_id, inode->i_ino, name ? name : "", &vaf);
 
 	va_end(args);

-- 
2.53.0


