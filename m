Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FC20EB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:28:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 884976B00A9; Mon,  2 Mar 2026 15:28:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82B5F6B00AB; Mon,  2 Mar 2026 15:28:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 703D16B00AC; Mon,  2 Mar 2026 15:28:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 58AA76B00A9
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:28:10 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 29D27140310
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:28:10 +0000 (UTC)
X-FDA: 84502259940.10.5B9BA0F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 757DF8000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:28:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qacI2mHY;
	spf=pass (imf30.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nthU2X2S8ucsNQNI1phwtVnPY8hdr2oqnAbCaxEthnE=;
	b=450NgUVbACuunb5pyDIyToyvLlgI4oJbfVD1wSq9QbLr8DJPuGrl2F4GJfDZJkkJfriatf
	6e5yxUYv80XcM2dlmo/xBvuByyhnjJ4i9GIWxg7zeZwQJvzTDYwrdALjcU/Uw1k70A/sRJ
	HF40UAQ5EL8DdrkMaf5xQ2i+U9tnioE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qacI2mHY;
	spf=pass (imf30.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483288; a=rsa-sha256;
	cv=none;
	b=6NLLUqUJ+vnReb/YH0K5CH3QHYQy8jp15nwNws2Kngw6FNmAwEJfR8GgzbM3IqjSsu5TY6
	brVoiHbNTYTq9/A0595Btr0dww7WuxtoAMqdtfckJ/AvRg7dehrkf4uyuJ37HMdscU3LAa
	Jqu7vWINfaUDaAhouH1crq7N0vbqLLg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D2DD86013C;
	Mon,  2 Mar 2026 20:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD42C19425;
	Mon,  2 Mar 2026 20:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483287;
	bh=1ivESi7OxYMAVoEUneLRmG4iZ+3lem17D5YDwFd2su4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=qacI2mHYOWhdrqERQd+Otx6N+q+X1OOGn+EwKATQdVjMN1diiif/VEBc7q/vu7SNx
	 Dh9eqRvl7o9ps9FAzqtuLCUPaCfRbcEwZV8JfI8TnYqD5HHV4PIJ0W8i/KNlCR4cNG
	 T6R78TMDKrj2ir4GlKURJo1gK+WU1BzKR05rLmivRey5OahoHbNrrYuvcSKo9Ymzsh
	 K+Yeql0LeKhntftA7AY56wCiMOYQ/jzYTPAdnLBGI/+qvUdH8YaaARcXDtqBmfiQUT
	 lB0UxAtQ9jbphFQ/OkXpTHx7azoKW+t+f2O+gV5uDqkItqaFeVxzk/d+2Oc275mF1C
	 5+Dse9wkztsVA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:23:57 -0500
Subject: [PATCH v2 013/110] locks: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-13-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1759; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=1ivESi7OxYMAVoEUneLRmG4iZ+3lem17D5YDwFd2su4=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfHyS0FdhrZYEU4R3h5I4O4CjVxowV5X+2BwL
 fyWGe6UxOWJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx8gAKCRAADmhBGVaC
 FbDhEACS/+k5beSLIB49AO1LucZKn6unZyW+FWBqW0V3kTE4HZ1xhQ5WhYx6NSrb76dDqiFudwD
 +j9+krlU79fUTPsJzF/r0O+83Hm62pPpNXzsii9XlSfL+rtJX/Bo5nmOJUqn2Kz1pZtLbbt+Kgv
 xHvvBLGX2QLK7qytBDicAI7dzgq1BlSdNjqIDUcnwf5tt3z4c9i/qaPQjEc4IYWHi1WP0mgMqYc
 TTHnu8RcGhKs2M0dIeCZTT58wTGvL0anGnmhE1fhRbqoAP8cGjlFOjz9J3jNnNOFJDqk9mGeIFy
 8s7rLfkcy5xTSSfPcLCy8ZMQ2RAzJnhTBzjC7B3i6qLPZoxIU7kgeWdsfXzN5iObNz1MaTb7J5M
 jEyiuSgVVVYtxnAMWW7wtqVjrb6844OziSVigT0MUV7fivHiVSGO54eeVWbP5lX4CNag/y7GEwO
 zl+o6G64hjSDUnviLuvGhB37l6I+Y54GDbugfgOMd+1Y2ToBwTBDTlX5HTA32bPmlPW6YEe4GgJ
 ShijJPtTgPXPq/EkgSct0D9fpNqma9uiRhiM5490x+qkuTkfch2OdZ8n6K3oImWcyXJFPf5hiq+
 zakfFyuziCYzCLJrH2i4F3feY7KE56q+60ZnxyWrD+sIPn81mSSMnqALQrqQgBJ68Oo8Ch8txde
 hcx5uXX89U7AuGA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Queue-Id: 757DF8000A
X-Rspamd-Server: rspam08
X-Stat-Signature: gq5ifj1be6cbmtrpig5yfo69wmnbm6kp
X-HE-Tag: 1772483288-627499
X-HE-Meta: U2FsdGVkX1/VnD/f4NlauSSzgWs2E5bP43yA/vpcKDJ0DqB/xvJyl2dwUcyVFik7t2YJ4btlwv+i106JiAvq2WsKnXu5bR7f9Dcgg8DB62PPPI0d3YSK5zrqFlzXFLA4JuVGxGsK6HdtDlGlC46BtP9KKr4ktSoVbw3VWXDY8tL0PCqsh32Zwz3lWiJGUscVesRl38Sz3jDUfcdGavB8LMkf/rRSIm6zl6oGSpkKQdw56+Z+ExuQ8RX2fwq+fziFzan0ZHC8AziXCXK7zKe3AjQKPJuJ6CCEyznjGnOxu5raL2VNTKQQXq4OH+TD9GFroqwXn8pL/2FfG6MmU+iDyKQlZnzp21idBSCdtHtxNlsoQ4VSaLeq+KXgIp6APHp+xYtrF0UtqYdrEaPxh75K1xGWa6DIfk4c8yay9cYwen19a0qIy/d1CoDRONekPA5kZOjVH2Heqy7yime96gXyfNazyDApZQ3z+AlNhKlb87Lg6XejOODfXbRU0iVzc3lqeuWe0bxb/8EfZwxufvIvT++F2vs2FCXReczzllpxZdYHaICkj0L0R+0K/bFY+oStNdltNYULxqNxUwyQCtdhTmFAypzb15VZo4t0gOkmtJeaWWC1QJSOXAlHUwhoKouH/T4Gt6miDS39Qd3DGZ96SpaVAGlcGXujzs5SaiCRXg4eaVNnZPIs98Js2FkpEZjPxJe8xycUubtj7/EBQ/plZM4aT/B6Ti+SLP42Vmfx1M0co7Wn0mvBChNZpslsaBHTBM0ykZT94col1cPWUc7zBqtsnNzNhMA7ELa5mEdhrhoJ2QcH5Ula17oxhf5N0JA414wkt1BGSEezRTmM6GGGQT5vEOnV5d+e9WxPKFBA7HVpQbgxFAgvA7Vhf8z8TJUV5k/AXvxlZyFTxoGzgcmhSlPaQ7i2z9H6OaXLDmRBHY2N4YUhm/xCYMMwVoXwmNhotF0G8dcrawMtZViLn/E
 iOZSs3ER
 GyuGaeiLoB2G8p6VN+yvEGjUvbM2Ex0KnjSZvSZl0J5JyU5EgShIf5UmI9UfNMgYZ7w8rUWxex5PsyBC8G0EEcuMHNX4DPVzTZLky2JY/BlLm5Bj+CaPxxsLEwyDbfO5w/JvLyivKsbEVkUibAZZzAmPnxKtG2vQ56Ug2Wh5KgLVtuNzMdAMY1qT5HMc/VK+JFQMPHlJQZwapKaOQNg17Z80TgIseWMK9PgkCs1xEbWQhuZVTTFgj59iYA9OIrl0ikrorzRcQJoIi7IHe8Qfm2AB/TAVhjZQPjQscjvRG/0Cgp3ff6Rrr03qfJEiTDDDuSFHR/ET6F06LgnixS/pWyIoPD5Gh+hLfEG6bBHYw7eOKfhSSR856DTlelZmSXvxe3AFm1hiJQxrQzRMM+20DztIbF06zoBkYr0zxrTJeZf7vNIG2j0hKuLaZlDRTXi3xvPS/cWvTbb4ThV4js3H4geVj6gn2pjH3jUh/kVl2jD/2U9GxplNBsqhZfYW9x8ktVmu9qS3Yr32BTKjDGN6HKqhTExzCdJ0H48OOCzj8L/jQ36N6JmvxlxjRTmQOhIihgxc2TY6ops08bxjWeJEViNxcvbh3uFU/wpXHxk8e9jQKWwuLmZhBIX9FRnRF37QKYRlofIh30msYHQFsm29A4tjF+0aIOHI51SF8sH6IqNYqJYeoLvS2Sb+ttSTzqONFG/wOvHbHer5fpdrXO1HCIlseKsH5fntHbBnZh9VOeJ+HVhNAhbIOkdqjnto2cOwmY/F69KxsV/IBYdpP/dO2uayJXwPVlvJk/sDiGAkYkM8a/WW8dAv7kz1RK2eudQhAZspP48/6QAuKnmyMtPiO2fNNPZsSySE8GFa3XjIfyalH7/FLVy8sP7YE/ORgUEF7ffZOFGf5KEZtSkoeQMWW16Cq4YYNKLBG8qAR5+8T/0uQZELbTuPp8j1+qMRLQ1igTVmzuTOE0a5+AZ2ZKmd84M9jIblc
 5gbljYye
 I/3Xk+1NABY4LQiq17pmUAIYN6dZl7yW5yx64W6Bnae41rxBA4PIrz41VvuBUG/pjgFgBLxSnW1bewu5pgWITg4km06+e/408H0jRWGegNYIgt4T69gfkCwbPQGJebpHUnrFhxqO08HX2AOjBeLIHBT3upeRI8th76CU+JE4Wxe01OTSrv5PezRNpuPe8KMuK4ZAaXrtUcEsoWy5hBrKXLWz/0cm9pH/ccfHAr+9daem2WK5+kKFFSUnJtg5RDC7zoGTnzejmBhVaI5eiIyms9ir7E//qOgx4iwHHSx5F/PEB3E0d954PtjTaGhj32PZ+Gcey97JOK7Zqf8Y9ggjIog3hpkoMyG95PfKIn2O5hs+3I5+VpTdgCEtetROI1chEnL+M1AHnHy5b40zOks2BP7uG/PblwW+P0MJl6iN2BEl+J18uGJpKPmuUdvCjV8wbtc4AmuA2AiA7EcDjWPdCwl/1mAOLm93rufyZ0KXt37oUv5gCiCmudw23jRtWDTkwH7c/k9Eelqnjmp/93DnnzDemOlkZ17ATA5oAwqemx80pXm7Bm5CqZPWzpvXthYvhNRsmLItfbzfq8VFhRmnvti9r+TZHXv8n7mOnoBG5r6WbC+ilQeCLh20ivYvZ230d+L/LOr+2ZFjTCRWDPmyGkdqgpIZKov8K6my5JUE9xpayAm89Aw62AeVelVH/DZJdz+JR6EE2cR87v9j2sPIXDfnRSSEP7Wfd+zY00pZpWav7jqPE3lgZxssBXqxGA8u1Em0wEn4sY56RzYag5hV1WMsJWnU0U2lIHanDL4QRACUZXCXZqog2lVZ3BoSRcz1gODsr0sN5AfNFGTINuSel19rMfsKhFhfuZp21cpb8rvvt8cwc5hoc6vTYfgwhQujOd5zNjdMu6MU5VJ56gM0d2xJ2S+fxdEHJPKnKv6BWj9uXBFrq/RsvsF2LmZmVJoQIraUgJ8fId2njCV289VVSCzQWGOkH
 tBj8UKBq
 cMv6wL4kRnMqDgtne+9SnKspG/S/tVpG8A6ILPND+pHDBT/O14/cU2WOYQiru7L5tcGQ5JOvvcltgx+4wDbx0lsG8whu8ImZfQtqpfjqZXLoOraDBk67gHV2EzCRw0OcFmtbBLQJdxaqJ0scGz8uTpC5BnQ7MKxfyHw6g68o4farMQ5kFZC/tTvWqdjE+4PNvWxoAfDnWg0cLeuc0nL/Ghw5GpdmiLFSiLKfgzjgHurwnc20XZWqHNrwNG1/8/FFJGNJodU8fU3DYgfd7hmhNrWlOQq4vlf0EkAG7pQlMhYaILX2Vc+4Fa/6nOK+ohEvyT7g8zoWesBDfO6LjSE5vYFbfUnst5WtzHf+9IOB1F1Wf4rQSan4FPg/Zn5+EdcmfETALkv3o8FHC/TmPBIO4amZGaeKMLGTc5IqNQ66GZxXXizGwJFuh13xNXDXB9UZ1rfONBnyMzEzSE2aGJzcoxkizJlwt4L1ZmjCZHmAeaNUNyJ51i/fE9/V1+i2nr3YzE1BBGfDZ0R8bavTPX2mK0AbQx/TbKCY/EjBmFDxKIo1+JaMgs5ChMBqqa8Nf+QgYxwOTdR8EVYZiTEP+LorMHfrU+O7jx2PACaaKSou5p3uQ49AMLyrXxMEZ/1N4sGoq8HNXC+5X5iLOq2kLyS8qC6iiKJ+YUnIH//iKS/BcxLA5zS4I0oqWgqZlsUZi5phvU2bwLlAmy9IsRY+nn7Sqb7mQ6AIK4DDRgqEk9923omqX0tJ4OYqmntuhHrEe0hXaYw4vM25x/O2rcIa0RMyO6z8ydhez8yVrpqZmuxzU4BarhUzhLMn9Z56wk4zpeywrvapd26cpi+VLA0jjBm2zsUjYXTJAZ+191uDLUM4RhdXEMi6XD1suqMbJaI+r+w0Q/ykZRoJ9mvYDtEnj726CFfYHk9VUGXbupzSGt62HwdOvRNTwFKNjdP6hjwUbVpEf+6vmGfi7O0rvvVr0mJmMtPFUj1M4
 hJgwiV9U
 K5UHfAh5ylVPXy/ExPpMyf1xdKsfPusGCTyL3ZlxnRqFUh1miwpkOd6T5of0m7LuTgwNTXCOXniqMuRk6K63SuLn18k0+cj6MfJa5tY9VdP63+fxgJhjGZot/2DBb8kHBhb/4+RAtElUQZms6nubFwwAn0m/v89MawDX/Gu2ny0GJk0xSySsd23xibk9eDpqdgssAB9EUyHxksuFHnm2NZa3kcuZwfdhv08AmD2Za08cNJsbTBTZEZv3xJY89GC2IKxOTnpI1WMdu/RS1XmML+RIlPtA1eKoDNOhjBH7LPryvjW2l8z2KeyPr9F07qN23B9BJHTV16OAGxkvRQsCIdoDwX7ZE0QWd8+k3imLUithC8rHNLMe8WSY/tSwBgeJ0QaDSShVykbBJ55hS/uMDLO7cKrXMmtD0j5HONJZyWusGE4FnYfcuZNrPs9PwNI7k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert locks i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/locks.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index d13ec930b7bb03905df50bdce30b84749edab8d0..9c5aa23f09b6e061dc94c81cd802bb65dd0053c1 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -234,7 +234,7 @@ locks_check_ctx_lists(struct inode *inode)
 	if (unlikely(!list_empty(&ctx->flc_flock) ||
 		     !list_empty(&ctx->flc_posix) ||
 		     !list_empty(&ctx->flc_lease))) {
-		pr_warn("Leaked locks on dev=0x%x:0x%x ino=0x%lx:\n",
+		pr_warn("Leaked locks on dev=0x%x:0x%x ino=0x%" PRIino "x:\n",
 			MAJOR(inode->i_sb->s_dev), MINOR(inode->i_sb->s_dev),
 			inode->i_ino);
 		locks_dump_ctx_list(&ctx->flc_flock, "FLOCK");
@@ -251,7 +251,7 @@ locks_check_ctx_file_list(struct file *filp, struct list_head *list, char *list_
 
 	list_for_each_entry(flc, list, flc_list)
 		if (flc->flc_file == filp)
-			pr_warn("Leaked %s lock on dev=0x%x:0x%x ino=0x%lx "
+			pr_warn("Leaked %s lock on dev=0x%x:0x%x ino=0x%" PRIino "x "
 				" fl_owner=%p fl_flags=0x%x fl_type=0x%x fl_pid=%u\n",
 				list_type, MAJOR(inode->i_sb->s_dev),
 				MINOR(inode->i_sb->s_dev), inode->i_ino,
@@ -2896,7 +2896,7 @@ static void lock_get_status(struct seq_file *f, struct file_lock_core *flc,
 			     (type == F_RDLCK) ? "READ" : "UNLCK");
 	if (inode) {
 		/* userspace relies on this representation of dev_t */
-		seq_printf(f, "%d %02x:%02x:%lu ", pid,
+		seq_printf(f, "%d %02x:%02x:%" PRIino "u ", pid,
 				MAJOR(inode->i_sb->s_dev),
 				MINOR(inode->i_sb->s_dev), inode->i_ino);
 	} else {

-- 
2.53.0


