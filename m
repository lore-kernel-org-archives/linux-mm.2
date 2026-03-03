Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A70FEC0489
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:05:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700BE6B00B9; Tue,  3 Mar 2026 05:05:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5B66B00BB; Tue,  3 Mar 2026 05:05:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AA996B00BC; Tue,  3 Mar 2026 05:05:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4811A6B00B9
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:05:09 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ECC591A0412
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:05:08 +0000 (UTC)
X-FDA: 84504318696.17.7814FE1
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	by imf15.hostedemail.com (Postfix) with ESMTP id E652CA000D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:05:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of mkl@pengutronix.de designates 185.203.201.7 as permitted sender) smtp.mailfrom=mkl@pengutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772532307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yRx6xPOePAvBbAzff8LfCyVok2uTKGPe/FxLK3VY8Mo=;
	b=4xiPrcLoteTeODPK9uBaOXYOR5wvTpoXR8Bi08SUQbe23FcKgpMwnSSzvc6yiTRoWeuxzL
	RQ33bZET40ayJQRAXMaEJiwXBrKLgM1qrhxsuLMtuP3ZbcDCldkcPki/6VigCR2OAGOLqA
	nIgNC5qEfG4CgfvdkYAHyXVoTqZQVro=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of mkl@pengutronix.de designates 185.203.201.7 as permitted sender) smtp.mailfrom=mkl@pengutronix.de;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772532307; a=rsa-sha256;
	cv=none;
	b=8lObsHbE14NT7DaR0nYRyQ4yZW+ZPhpU51jwaxKO+lFLI7wL728u6FQyUGG1CAkHEqKJYZ
	lPl1GXpC2BrazH/Tcwhy8DF7yQuDkyCW0Omb0z8IUO7DU4Axg6xDNguELVpmiibWJ0Q4v4
	Y4ehLkxJvp2vGhrICn5r0f8CXc4hTjc=
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1vxMbX-0007dn-3h; Tue, 03 Mar 2026 11:03:51 +0100
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <mkl@pengutronix.de>)
	id 1vxMbP-003Wd8-0B;
	Tue, 03 Mar 2026 11:03:44 +0100
Received: from pengutronix.de (p4ffb2dc6.dip0.t-ipconnect.de [79.251.45.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id 23B2F4F64B1;
	Tue, 03 Mar 2026 10:03:43 +0000 (UTC)
Date: Tue, 3 Mar 2026 11:03:42 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, David Howells <dhowells@redhat.com>, 
	Paulo Alcantara <pc@manguebit.org>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jan Kara <jack@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Steve French <sfrench@samba.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Alexander Aring <alex.aring@gmail.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Eric Van Hensbergen <ericvh@kernel.org>, 
	Latchesar Ionkov <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>, 
	Christian Schoenebeck <linux_oss@crudebyte.com>, David Sterba <dsterba@suse.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, 
	Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>, 
	Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@infradead.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Yangtao Li <frank.li@vivo.com>, 
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, David Woodhouse <dwmw2@infradead.org>, 
	Richard Weinberger <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Anders Larsen <al@alarsen.net>, Zhihao Cheng <chengzhihao1@huawei.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, John Johansen <john.johansen@canonical.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Casey Schaufler <casey@schaufler-ca.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Simon Horman <horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Martin Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>, 
	Joerg Reuter <jreuter@yaina.de>, Marcel Holtmann <marcel@holtmann.org>, 
	Johan Hedberg <johan.hedberg@gmail.com>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
	Oliver Hartkopp <socketcan@hartkopp.net>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Steffen Klassert <steffen.klassert@secunet.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Remi Denis-Courmont <courmisch@gmail.com>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, 
	Magnus Karlsson <magnus.karlsson@intel.com>, Maciej Fijalkowski <maciej.fijalkowski@intel.com>, 
	Stanislav Fomichev <sdf@fomichev.me>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev, fsverity@lists.linux.dev, 
	linux-mm@kvack.org, netfs@lists.linux.dev, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org, v9fs@lists.linux.dev, 
	linux-afs@lists.infradead.org, autofs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	codalist@coda.cs.cmu.edu, ecryptfs@vger.kernel.org, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org, linux-hams@vger.kernel.org, 
	linux-x25@vger.kernel.org, audit@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
	linux-can@vger.kernel.org, linux-sctp@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2 004/110] net: change sock.sk_ino and sock_i_ino() to
 u64
Message-ID: <20260303-tall-fictional-tench-7c5f66-mkl@pengutronix.de>
X-AI: stop_reason: "refusal"
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-4-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="w7xntzjnabubqe7a"
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-4-e5388800dae0@kernel.org>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-mm@kvack.org
X-Rspam-User: 
X-Rspamd-Queue-Id: E652CA000D
X-Rspamd-Server: rspam08
X-Stat-Signature: h1ycmn3gajxpuwpbi4c5nwh66zxy1gen
X-HE-Tag: 1772532306-188549
X-HE-Meta: U2FsdGVkX1/bGd7PWGez/i3XW43r51GQcbsa847zqKyl/C1W4FxTkRjbRQYCQWJi4mxKHeVa2ZL4+fx/cTP8OJ1Z8COqSK+6Gl6RUdMWX1d57aINYJjRuLD9c29GQLhMuvlv3xY5NZBtRkGKlVnL4Gt5/qgOaJKFMkEK04f/ct3k5Bmx++AT8YWQMk0u+W99fqrsValFy+l+HdVVhuwbAZY6rLWZVlsizrocJlxF0x7HlMSpcuzkWqNpW4KJ4sJF2RcIbqUysb+iVdkvsNcF8spEdLIZgtJVfCT58l6y7AW6tHAYiE5YCfrcmoVtHnIXotwsJ/PVkw8pww90+J4by1d4JBxdOisPWNd17KBykItGh7wuCUaMBdvlgm6+17NiM2hqkvz9cNdpy1mThcXFHAt0pcbIRzdIvg0eCDiGeWnRuJprr8CZMzFsxfRVm8By8baiEHS3NMS2p64QWOZu1pQoQOjnHhKs5EDfuUjHl2kTD0+Pg1B5ai/vxlTLkwpoFqN05qVFocfGp5rk0/lw7zFePGQDSsU//ZssX9vcLb6DwuYCERzmVDXhW5wlgGJgUs8t8xWx+1cNXCvu2aph64UCbM68+xha8vDCPcBGqFGoh6MKeEoTHHiL80LItPaOROm7o28mfh5naK0g/Tg6hg1Irg4kXbSyDaYuKiNtFOqs8Y+aj4z8g13hlejGJYRqw42T3d7ktr0OwQvKGF70T+eStLjnMcvxU1IWuGWlxTHKIaCQTQLN85OLkLnYjV40oFmRkHE0opMDyFHV7TdMDkbIT0Trc6XrkBzsrG+BICcuLKUywWFIYM/hKP+MJcGTO49lyXQJN/LqhR7ZSBMUtDqKXET8QfuExE04qYseAI9lktelWyXqpAdXmzbCZxq4JBpIZX5CWWaVFOWPTLRHVfbklcN3NPmz8sn0YB1pMhEbJa3h65HxCR/vHSa1HqwT/YqhhEONAjRdb1pGmb8
 jm23PIAw
 3ShcY7b3bjuo/GLld3Y7oWGkwE9mknJnFVgOy0tsJukpmYtfd1M6MFounw0/PUoqP830bftNopK8Al8ylifxAtdPQ2puOsHEtd66X9QCZPa2I9T/dJcrpbXSRT/gkUYseoGjm6Zs8uSOcydT1M752lmmEeKWHzowRJcLFwJjTJQ+q1lKTiEyCep6l2RBKOM9qNKVLcOnds5yZjN/VfOfHcc9pITXZ2Bi1lg2NRsf5ucTwZ2Nenz05VKhbj2uyvLioVOHchKN6UYaziqx37tFJ9fsnZSe6v1ZoQ/Qof38Xft7tC1p95/Xf2FnLPRx6t6H5GWxsAfKKijyL5WiPdsn9+n9kNkkwUwViP24LmBYRWBtOpCHwnP5KAesjOsE8AdAeL5THpWAXH13YLZ8u0tSUD+eQw9GoU15uA82mC8BJn/bNMMVzfbbxvd72+aAOO8ZzdqzPMuODXa2GKPzW7lxlVIP6f+Kd5JtOJYpgH9IjEFGXjiJr3ubT+2BEZ5eeIzNQkKoZJ23ewghUmsARs2mw63dIb0sYu+FdP1c8lMIfR2aFdQZb47E6T8Eqj+SBylbAWTrUGg7LfefsGm7WUQFXIIPAwoEE/l+LFmP0M4whZRzI+1LsTwJ9zUpq5ayxNzC8YoP3MFfGFxV2GCDCncxiOUvIXyNdOMYsmN2X9QkwwBya3bA2Uy54Ob4kADmJ4ck8AoCp5xjhIuPqeSisVKZ1gA7CpPmgduGG72ltZXVUuHiVECeymRKFJhh6QeS4e2fDsStJS96iFhreqYcpecSUI7EEv+G3bSt6joHgwehyKiKG3UEX8tCzfdq8wHeNcDH8FTNeV9iqhcFUS+D82EF6mwO3jvfLazbAeJZYICsviZQDdKKDDz0PE7YjCqwqM0MiHkyGwHw4yLm/QWpbEIMv4YZ7dm4opXrhzWNjmuOUe1Ex/4bmQgnbl6UKbImhMCkghi89BCDJ7wyky/uMrBBUCh8cwZrj
 v4mC1D28
 LKWSFZCW5AnMwZfxPDDlTAE+CrIFpfMcMBKn0t7PPu9xV+9PdDeuYSyLF+kxOL5SJsPAQIf3DezWYJhOlEBg3PlvIkrKlesmA/PjcSC4dO/6o5VGiD9MROuF8fRi8BSnMMmzNDg2Um/CVN1Hs6wu+E3NFUABcDXPKgDCdeNnvUdBIHojhi0pF5BvXQj72bIELCi69w66qUQr67WIpcUKURlvMcwQSNrmJl4zzrZBtopqR5f4+9LDo9/JjIxcgfumOzxJfotJT/WzgmQNIQ+CCSfEl9bb5cwNJwuXzZ6jI8EYZpLM15m1f6asPv8bLXLTVmBF3WdxN5f/REqLGi9cfNJOGntQInn+3dTqpuNJx+iSWoOGBpvOKKI9NFDEh0IxFOuEJMJuOMdioB/xL//WgbsQYkvCZGD5gcS5GQKqYg9xRx/FqjrwbhQ45dH5/mKTMGB70dG5ohNZWtuf5Hs7e788Q1+SjCcTQHfQN3NNTJs3GMcfUls3IJkvJnNcd2DofgC0utmUMHzi5pTO9Bvf8ak41mDLCWc2/pN8qogTMRDl0ymNu4SDFOIcRo+7VXHEJTJ/vVXOd9+ufYgkE6//oRX5ZSkvJ9B8caf/8ItV6MdYgisRCbt+jfyM3qipRXQ6NqXdmyQZdu1gFr18kKAgfs6Sg4Qwp4WxV73OsvPxZCjxHtHZ3Si4C5rkQK7qXAURqLraZ1GJcd4srCpeCYpW9LV8RmPZb9/uIHlfFT1MlFhvWtScET/oUoMto5hWTe+3sR/r7nAKkXrJZQwC+08ktHyGeLzLirOHXi2vps32TfUwcmVWffVUAH9fg19Izkuj4lrMK9eiZBrnhY3MxJIBqhZ3NqbqmbuUs0OLRTARPSRYY8sFcQEAdV9G0BKxNkVMlX9DDeJtTUfuYg3kzK1mT8YTkBtFjDqLrrjY4IDaKJC6160o4oZlK7RdMrmQ5me3zMl7iblWtuyrthP3NCn0vlFOotLuQ
 r+7GTNsA
 KCtUUZRv8hjGaXwXPVMmzHA99qQgnpOJOFoxCduQLGS+HysuN44ldVkEOvQbHG7Cty1ZZLv5tBjTPUVAOntF+jjIkP+VdWAS23N0rmCYmXjaF7F43cCaB/g6ujUgTgmBu9Nho/89bP+27VfKvkQ7/4UxFo2YJ+FtN4sbCSN/Wx9VLh9bcB/LRr0D95QIsDv4gNJRY0tf6ErOck7N8ezH/RjOgei7AKCuqJaNGumG2/cW/YARi0w6gmdIxd4fh1eWmvF5N+u5G+GjF1LN0v0v5WO2AACm+AcpKDI6zsdV18C+YCRoWQ0bsMSoMCq/T2LwGrq3K7aO8cBjDTOs33N/xVbcjY8HzF7iK4N01NZXgI8E0FT4Bjyq2bhrHKR5VjiCQPbmmwHn0SYwc4OKQTJq6f36+nmrYXfUfU2mqujmZ7WSEHbHr756aaMxhP3B13CpbPV7Xj7Cvzgy96QhRkKXL6u55KGaCBYc1n+zUhMCqVXK85W0vOZ7B4+n4C6OcDC2uUqiA0cUx5TMOx3s3fFrBoudj/VdRwecytot5F7A+mRMz6f1pJpL+ORlJQLLV7LEkhUqukbNThZr2+F6fEeyakAIN+1s4IEGatrdWTs4jhImyVRm9QPMPb/OH+qFM/UQyNqkcqQSeDHpHZt4J6fK4YV5kDiflJbpUpQcDaZy5fbvDIVJkDy7zpwPJp3/yjLfF9mA5DCg0RI08EaMqtRh5hcTcfu3VNm6aTttGLtwh5xBXnRL+R09Q5JV7U+WuN74RoajeFVvo8PIqV58jnY2AlCaXC8o6VQjOIh4c2PYouFwzfdibvXNMFStheuZ1dfQ1FTf71VOhv8eU3/agzyUDrd/WDtC0KrXOqzNO9ZYNHnt2HD2rCMYHDe9cuGqe7//5nqlcb+JUtQkIGNMBLsaUdG7klKoBcXxcT+3UnQ7eaDGMc9CoQNe9UqTxTHNxD8j78mPUwgcLOU6uxxf4u15v9rSqFXva
 d4mPlV95
 zOh04JJvUaPy2zG/ogva/pBIHOpkE4w9G1Eh8Jo5lOisDbgNI13UNBVE0bmf4wQ6i3Cq7skcISso3ao6aFOeeUl2TdK+HZBtNX+ulnKobfyGsHTpmRGbJyEl0G/TG+eiPnQGeHvQ71uUSHXWKCrIl99fmlQpHPmKTQhMvHRlu9BarbBhIHxoEd+OFh4RF2zb/t9EVxvB9yuqHk6cOATbGj3kdbWi9KpaCBki51DQDRFaNhgCdziMqx+wE24ZTapE1riiygZlKyh8KGhO1OigZScwe0OZzuLVuRmHpYPh23Z2zZ3+F6Gk+BfhCScXeTJrq5nUoaYPsfCddO6X4a7nxO2GQqawCPbgl7BuYLxC3s1cxED7CtJn1rNbTB6L1lohFLXLeXzvvCFFvYoWz1Ks522zAf0RKchxRaJIMoRCPgjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--w7xntzjnabubqe7a
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 004/110] net: change sock.sk_ino and sock_i_ino() to
 u64
MIME-Version: 1.0

On 02.03.2026 15:23:48, Jeff Layton wrote:
> inode->i_ino is being converted to a u64. sock.sk_ino (which caches the
> inode number) must also be widened to avoid truncation on 32-bit
> architectures where unsigned long is only 32 bits.
>
> Change sk_ino from unsigned long to u64, and update the return type
> of sock_i_ino() to match. Fix all format strings that print the
> result of sock_i_ino() (%lu -> %llu), and widen the intermediate
> variables and function parameters in the diag modules that were
> using int to hold the inode number.
>
> Note that the UAPI socket diag structures (inet_diag_msg.idiag_inode,
> unix_diag_msg.udiag_ino, etc.) are all __u32 and cannot be changed
> without breaking the ABI. The assignments to those fields will
> silently truncate, which is the existing behavior.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  net/can/bcm.c                | 2 +-

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de> # for net/can

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--w7xntzjnabubqe7a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSl+MghEFFAdY3pYJLMOmT6rpmt0gUCaaax+QAKCRDMOmT6rpmt
0hl7AQCzPgPTWe6ol8KwtKBDfHnqkx4Ku1cIiwlQY4Hnx5jz1wD5ASVd5abGOb50
lF4hQNIazRvyjJwKRF+va5JwX/SN2go=
=y8vr
-----END PGP SIGNATURE-----

--w7xntzjnabubqe7a--

