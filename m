Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20F6BEC1449
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 13:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C5976B01AB; Tue,  3 Mar 2026 08:38:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5721A6B01AE; Tue,  3 Mar 2026 08:38:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4208C6B01B1; Tue,  3 Mar 2026 08:38:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FE036B01AB
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:38:08 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EBFD7C08DF
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 13:38:07 +0000 (UTC)
X-FDA: 84504855414.18.88DF970
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id 893A21C0008
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 13:38:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=C+NAzkUg;
	spf=none (imf21.hostedemail.com: domain of BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772545086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tk3uESbdvJBK0ZQDjaLs3gOQpD471/ds7fVyav3aEqM=;
	b=rIdhqx7SdRshG6dwAB6Cn+Hw54wJ9hDJ0hFaOY0dahTEO4sCltACZBldbtfDP8c7Ue0Qns
	jyAofz+vXaxFbg3CSF4udGHJoilG7KxqYDguV2zezP6eoJUd/vZrj6c8Jwfv/jJBZsxnaj
	R82AFDUM1FibQP/is4syF8WLLemWFP4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=C+NAzkUg;
	spf=none (imf21.hostedemail.com: domain of BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772545086; a=rsa-sha256;
	cv=none;
	b=vlgbdMEINPTqQ6aegKKkDCbREJdbsgJ18tRC9xjz6ZY73jMBqFZJLUsA0ABPr4efeOHjZv
	i4UebWznBoCgEEwNANAku2u0Yvv79igFC6MkgqnzsQ75N9sJw23EewIkV/2LeCPqke1T3i
	pwCz7KoZUJWYlzNnghfN1G7/NRsn6Xk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Tk3uESbdvJBK0ZQDjaLs3gOQpD471/ds7fVyav3aEqM=; b=C+NAzkUgUxjxJBynLnQ11RqjfR
	zbYsG/zy2ofectzScTg6NHncmcu0JStQWd88qwniMwEHPUDMrzeu5AbPFjRTOGOusjBgApX2iupEQ
	4TSFZW7l8R1upfRlXqKLi4RgyAdnukQQvbYPR1dAqrxxpUxnOkbsrwTNYlBbOrqkyVi4QvfAA8Hbw
	HJt/UXrH+SdGFi54kJW0+OTTU2dVCgOBYq2an1JkF/fBKXqVFdbNMcBaFcL7O/j1sFF7d0sWaEROA
	h3pRPEd5DrrHSXCFjh0Qfque8DSpJNMUn053UKYZ0bE9iWOzQNS+w/08ekbSH5pMrlzHr3N0R0CUZ
	4DO7FRhQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxPvS-0000000FEic-3CMP;
	Tue, 03 Mar 2026 13:36:38 +0000
Date: Tue, 3 Mar 2026 05:36:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Theodore Tso <tytso@mit.edu>, Jeff Layton <jlayton@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Steve French <sfrench@samba.org>,
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
	David Sterba <dsterba@suse.com>,
	Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>,
	Luis de Bethencourt <luisbg@kernel.org>,
	Salah Triki <salah.triki@gmail.com>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
	Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yangtao Li <frank.li@vivo.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	David Woodhouse <dwmw2@infradead.org>,
	Richard Weinberger <richard@nod.at>,
	Dave Kleikamp <shaggy@kernel.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	John Johansen <john.johansen@canonical.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Martin Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>,
	Joerg Reuter <jreuter@yaina.de>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	David Ahern <dsahern@kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Remi Denis-Courmont <courmisch@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org,
	v9fs@lists.linux.dev, linux-afs@lists.infradead.org,
	autofs@vger.kernel.org, ceph-devel@vger.kernel.org,
	codalist@telemann.coda.cs.cmu.edu, ecryptfs@vger.kernel.org,
	linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net,
	ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
	apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	netdev@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-hams@vger.kernel.org, linux-x25@vger.kernel.org,
	audit@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-can@vger.kernel.org, linux-sctp@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH v2 001/110] vfs: introduce kino_t typedef and PRIino
 format macro
Message-ID: <aabj5o1x4T-bRmro@infradead.org>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-1-e5388800dae0@kernel.org>
 <20260303012556.GA6520@macsyma-wired.lan>
 <20260303042546.GF13868@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303042546.GF13868@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: m7edd9ba6nwhzhw18ejwsqk76km68ja1
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 893A21C0008
X-HE-Tag: 1772545085-386636
X-HE-Meta: U2FsdGVkX1/x7aKePl2zyCJrnpI/J+zElfjLl6IrF82eW9YbP+uPdaqL1E2ctKySEP3udNPJ9rMQtLgULl3FU0yNLu41D7OV7TBNde/7zkn1FHeCbO868ptHoe4kmFTMN9CcPI7q6EeTIAvRQcZk46CdfIxXViFS+uOpjaaLT/8eFEr/FbnFxMIUm06JeHsf2Rn/NMQtUtCnX1/Z69ClRQrz/Udwr4swmisVnooPKtRN8DM6js12dH1ad6VE4cWNmtD3eBcpRPlbEcO2z+DGReT9zDaGVS2S3TApFjXHjW/sco3plgfNS+Q6p084+s/4BoAZ8FlEmfRT7c0ri9Z37KguJNkdwEFG7V+f1R0KlBe3Fv8tWVR9i++8YoLhUJG7vYpXAG8qLjk9H9h+zuw2i2mHqB7j/0CkkodJs1EZmkOvuoEEtFYDbHBPX0/LKVZyvpHiIp/Ug16QlqlmSEgsNo3IxZDQuxzY+IXRtN8N0ql9AMUmWLMp71k6rWrO7GmZrUXRQg/QFTytvfkPbwAjg9UC+nMP2L5KwcUY0UokNeMA1cBZm1x2keQSEUxDotE1xzZSIIEbeCs/UCOPFVk7rt/FowbC9BQU4qY9jeHXZ0+YhkmthdfbdS+nrIypYvFp61qtvxzcLgL6dJHqUH24OavaAbUfKaHtSKVp3uMvg675UEQxQkX9bxLwYYgIsJr/BqLKu8sMk7rY10xz4cxBP6cQ/J7HAarLLb2kKfQqMt4YWFkF8fsFUAzV2AOGmsHpJYIiOMng4h33tgDt8BMjpNXsMoOXQsbP+ctf5NysPRXE/KZuP3EF6F+jFlTmLIeG6IzPWHzreZuwrKnU+Pdov4oLu/4OqarekyYzczI7OoLyqJJk970XCiQfAn+ICj74GzRTZ+JD4mw0tIbbX3tKThO9UTI7T5/64TwGqLUYusW/n5E4yWfbdAMD+VEUgEVINzY8FxnttDwOsPnIwgu
 z8jG8Fl1
 7pEM8PRzIJhvw67EbnjcbyCbJG825iN7A0gcUlFu+/yftZy1CVedIazKdXyzroy58grE/5vjsNcLqx236lyZuU6k0gsHx3OXUGpqQ1CRKkSklfRz9nK7eaChImoiykMGuPDHkP/8px1JhyKZMExseszo1vUvGMu7/7FO96ZDSMnELYZ/zah4rItyU7BrcH09jp2363JlwWWX2wWG/qK3Ghj+J6qCrPDTjJJXIeeBzxtTo4FoH4/jMeY6b4gC87LIAu+NixRKyrsQKEvv+XgZH4z/4SZWtY6hOsHaRgY+51UDi0oI+jpJDWD5XpuBuCvFA6vw307NuRuX0Z/wKud57gC690ImNYAz7HBUt5qRUjZSQ0R1MtWu51o+40mdrYQ2uuQiWK3/gMSgRoXc76sEMuv+H+44S/Vlhzv9IUHnoWbN2yvJnEwincamNvsT1S4k3FllBO5Rc9wTxXU0gSG3+1YqbR8OdWh0s17rAW5/elz49ruOvbJcecKA952YhLipD6PS50Jor1f1LUjCV/757aipikw3OSPMtQ3lrUZJkTlP11l7NSZoQiSnSwBES8CCozKeSLIuBa4AukfdmdEP6HSlOgPQdmCzA7INKutEdCM04WJPmh63oP9y+BYdVx3GJIEiZAMBSTHZmR6U/b2L4pMrbHFy/z+K+4iFDrl4GX6sODZbfmB3pcmyzT6b2tdafZ+dgzaG4s42unsSd88yr7ufHPxxBhjkneysBn+s7N0oIf+fINHQdE1W0NVa6fg64mBggqSFtIeaJEVvmoTeQ1ff0PsXNvM8uIB3DPS0waCxKz1wd6h14XFmsyC1c3pYiLfa0p73WN0rChXAfh2VPOuhBStnyneG57N9pntPX1MkUhI2BEqP4ZneFKOcF9AqpXRE9u1mQqixfi9ci644rVGfYcR2oQOUbGmLAF/tDqmCQKVdgG1nyBmH6ffbL2JYNQkX6ViIMO31jvzkTopr5TRchSB/k
 DjKuODba
 0jmXmj1wcbMBFlSwX09QM0wtj62vzDukEJK0bCP33JnDaqC8HPsuA+Mj50spbqwWkZ2yF/z4wY3GQ1wje6GNKlHGZQWQ/xxvGWfryyP/5r/eZ+c4l3xv4TNVa7or3+hqZU5A49daZktDmels/MdfensmyUFhlYZm0D+lUGtFuAdbMD/hMKyp4VmrCVrLIG9XrSOq0qXocgYy9gvoscDZVA/g7v+i/fbpA6Yd6PMPvrha/AAsSaBPLdWEL7/69w4ErcDGdL2q0z95Gfz9ixR6wQKHWlKyQB5x3qT2EvxaWl4iTAM0TIujaTzoGQXn7bo07pKehKqsOih15/8iulCRMCvuCx4iAxgilhV0CmfnjDF4ndiLvBPo5jnoOjB1zwNlm+lGlD0OHjhGdyoowvJmXZPC0gZ4MIhzmAJQyqBO4f9l/SwtZsBfJoniULOdL+k0INOAgqpKJbXOZFUILn8MjG10rDJ+leW/GBm87oQcwaFuNOYbwWF4dvCt8P/zZ7AHEQid/Y+fAF7RQL9VLeZFcSEY3JB4aNC3m9ratPVaZxF5EB8r1HX78pJStj2amq/Vfi/5ewTo3gUe/uqjnozCy8UcK72qXpQCFwTa/WhOg5QNmuuxXlkPWxzos3SY46azbHIYnauJyRMHqYeUdoDJlQZ903nXrLA12XXt6FscoMuSxsAJKgfOzdnnp2MMVj3huPoVlFTba/3r4NUZzgVZ2pANyBpLzqqejZUjCPUguB0LtAHiL4N8Y9GS7sjEdb+izuOlJu80NRo2/ALSykqMBMjT4dXCy//jYnt5YM3XDIB4LgN6fPgaY7Q2DRGSYVveek/vpOVx9xS4O71ltGZAov/izLgGA/+UPE/e4Iur1f0SfE0VU91t0TdBdnMhF95MGwHY7NipSKIqAIiUDlC8ZRBuJ8rnR+s8vX8CZFv7g9GOGn7XBB7VAhYgEIz9MFDT/L/UO0lhOU3sSxFknopZHJRVvidTQ
 NY41lzak
 ceZQix5Sl0YK3EBU11HKeQduoG1b0iJg/5Rlb0XdlM6RxQkb8a4r+Du4+7OKeimb/JBxntX9I7gMlYOSFjnmPGC4uS8G/cplcoSbDjkNX5TrMdRm/dnleCsXcpm2dK3/yax0wQKUq4C9zmq7QWX9GDy0ovDSZy38GU1P9SX7aIzZi9JGG06uPqI3lI3u+xjpr95fMJdq9StdI2eL8v3bfDIKR00/gHzpOOc0ASBghObhc3Nl6BEDdYhrNDi6im3wdF3DlaM2aEzAAydtDq5PmvLR25cEop+vTTR9spF2qXiZTebVrQxORxjuBFhbkhZEsFxNXDznomEX+x2T+fI0r1Otl7kN1qYeh/Q8YeI/iOykCzc4y/IpHF/Qxc+OLXpYivyGJjalWomIhU6wMkW8A0Gaoxkapxlg946dARCFBfCLLVvO9VCJnqfhs6P3aHexd7/rnxZ/jn9840H7WZELstc334e07gdDi1UlVjjneEzweTQWr02lKD6d9GXLes6G9AxmlyhJef7Gko0cEzb7oVCdP/hrZepDP2YtHhuWLjws9EputT4HyBbWxQJqA3n5r1ESOlBADt6akk+jjw9tQd/NAe5AsifwaaT++BSIHKOIHmkqa+3b83PsiSIWACCK0LaGet6s/F99iDjaInvD7m3m50akRdWWWwmQin3HiUTw4I+SV6PUM9AH2gUzPLPTdt6a7ob/Kg9qoUufSvp2A1rRoAryXXI9bx/NCi8IDy+xZJnKa4bsXlChsAuL9BZU88daNwyAGJPyz8TerK68mbM6yvSzzA1Hd6EOV1JTwMQnpKcAkhNQdhsoVzWsJDT2CeYFPUW4TtKVS0dcxfupBB6wB+xivoIya8yI5Ja7zr/woSAcSMn5hQ5zeNfeFnfgExvWcAuwskERi/s+BCmsY/u+qnIKLDw2kCUu+nflKFmGogInPytZ+GB7mMb7Pp0N56u76pYkJnqKyybUl2DGEXa8YhLii
 LsQ/2TmV
 NMN3AOWl/8suwC1o+LC4AMOhwWwdbnEZ+IlaMwdpSmopeY46Mlg5KZUmL4+BFUakWafLQLUNC/FUQ1AEt0604UCmDPPDkhikjHlsloyGBt3izE+7mPO3KfXZ5QNfg6QoGCdZL7zw5c4gKimBbWTWonoa5fyBLLJ0v0ud1XFLEmgziEdRK4dJrC0IiayNNpp9SgESCFrXBlB+AKDBu9E/rID79vFxYuOrGXvTGYAevPaPScHuSKTvO6xF8da0Qpkmy4LdX8pO666j2HUKutTVtQybaOzseRI8UXMf+D0ocHggrX8QE2kLs2cBbU0WD0Hz0RSAg56wC6w6xcNwxf3XkB7rzYWYC99oRRtE8Yn6sgqN2n+Q1MYGsHDqNWdKYl193ooDwbB0/uqWDlg4692EdrHQZjRD6q2ID9ZxrM9yL9nSfaoMJVsoxCvFcjmQJohtW6qhiIqg8ZHTnwxy8MXJ3lzaZt5o4ulGTqxFe+rmRdvMmQUr3zaA0uThTMDDE98iLErOv3b4S9nXkaAThzRn+VH0IcWpgcQ2AqVO5A6GiMOaoup1FqpEL1tSJHw37zstV3EntX2MG1FqyrZ/zpjX7EXbQ2DK3G9SoNNRUmVstB28hfGCUHwOYFqldJBFBu9F/rKGyQ+0pFew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 08:25:46PM -0800, Darrick J. Wong wrote:
> > That being said, the userspace PRIu64, et. al macros are complete
> > format specifiers, not just a length modifier.  And I think this
> > results in less ugly format specifiers in our kernel code.
> 
> Yeah, I don't like "ino=%" PRIino "u, lolz\n" either.  I'd rather have
> the whole format in the PRIino definition -- it /is/ unsigned long
> after all.

Just drop the bloody macro and the pointless micro-splitting of the
change.  After this the inode is always 64-bit and we can just use
normal ll specifiers without messing things up.


