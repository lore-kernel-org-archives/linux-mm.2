Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 234CAE67A63
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 04:25:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28D346B0005; Mon,  2 Mar 2026 23:25:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23B566B0088; Mon,  2 Mar 2026 23:25:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5B46B0089; Mon,  2 Mar 2026 23:25:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EEFD06B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 23:25:50 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B2CC1605B4
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:25:50 +0000 (UTC)
X-FDA: 84503463660.06.85C0498
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 99BCD180003
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:25:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VVZLSXMX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772511948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EYD+hTYlE85k0B0NWyNfG2ixst88h/xUOUA+vKpk9xg=;
	b=30qMdIEQQtigVcfem4n9++hHqjhl0SKqZcIhcJcGIof+uNokTqRo/qzCbZymqYn7BgVn8V
	wPw8V4Ko+bSrciKo0x39F3hmGt6hITWYhRiBVlGa0EScp0/FO6mgduF7moqzm53UHeG81n
	aKvutUDazOb735kfdKgdWrZB5inUrlc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VVZLSXMX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772511948; a=rsa-sha256;
	cv=none;
	b=D9znhksJ05S8BzPUDvg2dQk9EEjaCgH8PdBsKeUKjk43m2jCzVgmGm/Dyq1tG18bu9Jqzo
	w5MKrdG6fCwHbPcmCOAVqxPkxA8rbHcOjNR21vQYkZqw3y0TmtAilbvTtS7p5YuDZRBnvO
	kTPOio2vOe8vssVh5TfJbZwlrz+2J18=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7099041750;
	Tue,  3 Mar 2026 04:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1C2C116C6;
	Tue,  3 Mar 2026 04:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772511947;
	bh=YZ/dFxr/gaxWgfEt0nAZiUh8L3hzuSp8PgioG8bdfOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VVZLSXMX/ADYwgzUdgl96oTTyoWKtSsqBFyZjRHPhr3+Le570J67X1VARch7tnhrc
	 jLMxK9WyIuv5g2RTTf67P6eMJopf19ZEik5sLXK6jqbxU64ctIOV1XX4j6Kn+Q33Nu
	 yQYGo2cQykg/FleyBJM4gSOzSojW07vqpkIpYgN8n19BYunsJ2Ud2G/HmvpxbPcrq4
	 pzDmiTteXofRQDx0O66dq6F/dhJKF3yUgl8c6/qCtRRe/JhIVvnMyTg8YHSGrA3GHZ
	 /1eA+v+KmU3ne6r8EbcoV1FFXQPxOQNpH/iFU+LVJ9yxO/ol1CYuEdDyLwooDdAzOZ
	 srZwZE76Q+8tw==
Date: Mon, 2 Mar 2026 20:25:46 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Jeff Layton <jlayton@kernel.org>,
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
Message-ID: <20260303042546.GF13868@frogsfrogsfrogs>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-1-e5388800dae0@kernel.org>
 <20260303012556.GA6520@macsyma-wired.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303012556.GA6520@macsyma-wired.lan>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 99BCD180003
X-Stat-Signature: c5shw9oqwyn5dt5heowm7jwd9mea5yde
X-Rspam-User: 
X-HE-Tag: 1772511948-164972
X-HE-Meta: U2FsdGVkX18EBiMe+8gzgyV5GfkqGvsq7kPLgMUr9RDcg/2+6PGTjPyVYqK+BjXDph5vuKvRNpxSvz6oQSIXf7Wz/A9D41/mLiWclYWzYFfYzzJrSAVB9//8u4jd8xmvSQnXix3nzrfGH0sMGoQkYip0L9bep9X3ym+jHssAqMibz4Pn7Efs2Iepc3JRWf5fbAa+mwW5TvyqCIf3jO1W73BYdAC9b+J+T/DbAed/qEQPKj4Lx20Lman91ERvPpVeobF40DNBD5O6CUIGFWcN961tClv/qmZ3jul8LrSn9g5fdfFPwPFGuhJnqCAOuOQhl01Vx7hMQejLF4F+Kfad6xscRpmZ/Cb7Q8t1ZdkaXiQTdU7JooEy4zFszfJkCc1+8eHcAj8P3L7ZrsvQki9jXGNhmN96Iwb3wtEkEQmp+XiUH/tIGyljcnbwxEwljWOoVz4JnErHNtLZBBpylF9COz1JZCzRnD5fo3MCSCjshXq+hK6BiaWwu9pQsMaGGdKuXI9V9s/Tuf1k3FHsTC89dxxxKbevJmY7Kh+pLqEoRpXrdhE7WtISKn5MPkqMkHpXIqjmzHk/IFvOlTlw+MK7aPJkVEvd6pBBx6qichhcVNOLIxB569YiOFD6Ts7l92R+ujNlCQ/Iz4SB6JuW7u93A0HH0By7YGCYsApwcjvr3jReN0MS2n0oTitAqMYhVPP87ohM8o+lh1Ko6X4RGLr5QzX2NfhjLl9YTs0VFKwJ8DuFih6qi0etaLHJ+LS5Vdl5FafTtTNx7M5YjQ65PsECWUIkCQqA9ER3e/s54mGlVW8IqBVuDubcHheC6OM8m3vsMXKlonJl2acLC9+53LEexJKw4eRMsyIFnbPXBmOekRjrwbNPb0SbDmCmx3B9loWZve8dgs2YbenRcjxk0CHF2wuRdEA7Kij7BHZ0dIjBTCjFiPLMFeBaI9h1MLmLEBXBvPmVGFu0lMjHGZmSGQN
 T6bc9v5f
 4zkNREeR2kE7ZIgD0OwoOz5NeowBLf+3UjY23w3FmsKwtJZQ+xbfQFM7egwMnxy3kdxZ/4YrfASHyxSrUl2rH/HKODHksD8UjkAsMIYxljVw2RnNXdVyg19PIiTUTZF8z4UAdCJCWhzsSMPvgujJUhe3COYZ7pSLYTbCbSbbbS/inUYgYlATanfmUDToAVziYvWzPIg8ELe1vJJM523j943PfVWntlIBNN76C7UFdcHVu5bPOod4nkuOpLXr61fkqze1cqDZISHrIA280UeBOMxf0m4duKqPYjKsrZADQq4lPS/5zAt6b0QhB0SIZ15jg3BjxD8QuqsdWtNZC66LCm+63IW9BhiNlRyzV1OSyJpTdSpZYizlAi8nbvsva546Zdhe4K270BAbFff2K+coBJq3F1pHFRoIt71kB2K5CLBn0aEXiku8k1X6zQvtYMNwlvLOfAMKLoIfskT3DUZCx3Mag7Pc6XP7cCFLB3nGMmXUl5Rx7mhkuko+ijV+8ZO/WcE+JNzK1hRqMvSPx3CAt40G+xbqQxk483mgibH96wD16JWm8vFj4dTgdDB5R/xK4SBRWJKwzSiBWelMyp+7S1g20KbAE6R4msrFzVcwOtxHoVGVONhdC+2RByfzXjId79uFNe7ELFAJPY+DIsO1LZvcU/W/kCNo41P2lT5A43W4pImBtR9I4VJXqD+JgdioRY6dzvmqKbYDImm8tN7I1xo4IkCqjEnwLDQV5vJgvMyIMAAVJ9jIGt5cp6R8W7Orx3KBtPHujIVIBPn1QSdVuyFYilebsWq0opQhgBHY2V2wi2Nfl0+qX0DI+tqfpco/HeLSZbfGUZuhoG3W4WkEIsU+x5CYFK2Vz+BcSgdFet5GPvCG22I7CbVJINfWBI5XFyY34Ru/PhifnjziyKRjSpZ68ngeg5AY6T6vksOkwSUMlvpmaJ3iEZduE79Dugt7QF9xr8DUxdoPVsqrEFI7mh/DtCVQY
 FoI/ORil
 bNmdkLOTeoiJ+VHp7osJJ73O2GcbTzzSahBnybT08/0d/rJxr6pEFqrgdEQo3N3AFF4bIafhN9gHHhFQ6uzH23NUPnf5JNGd+yhP5agcaiT0j6Yio1CNh1wI98btHx+ogdspmxA0tEJWEKiM/tRppo/SpGMbgVMZE9jB8llv5BgPSUUuHqye7ArLAW8J6yZWUqwbfywp2F8lfKHtPAirY7aVLS0ml2GehnKAutl6TfmM7t3Jcday8HJEr8JFv2SjFeKQimi8M5zI3Uqr3qbxuU3RT2zoLW/Vq8ktJtzbmMWLD2a6ENGlXioR7ZZCVuL93jRf6vRk10IyqZ92rx0/PXqP/Z0N/tZJ3+1qc+7hgpjngKXLEOtG2dP6ecP0G7cHxF+VEUzDuIXFXK32pedxLY9SZMZCFE9zFFaWmp4S10L/0Fz55Nt/OHGtdGboNOJTQrbnioAt07xJ7dJRBCysuDwoeN+cOQMIninYmbWRdplhp6f2ufwoB3eDo/9WvKv8clHlay/XSyG5fYraamcfvJswkYthJCLM+zE1EyZ1c4+WB4yievcKKBgTKOSXucW1c/C/4LWxMWgSrMhA/6mtYc8h01iY8UPyLVR7quN6BacCRnH1mBuWyt0tVFNz97G+iCu20vlfrBIbV5lOJ1Se+3BkxwWBYTe+O3lefsTeLNI/6hB3EOIXcC12NpempOtVDpJuUiMYRhheAwOzHdSWACDSkNuk7MgbssQCAO6aRH0GcLab+QWjo5WplL5aeZndjKuHM7zKFwjaxQvUAB7yc8UiTLypJbqeFDUSX2e8tHfykH8siHsgMQgBlzqqrKBjdo2Icj1Mj3SLbJ8ImuB7rzPOgM9Rne7/emQuJKxk6UBql882HjnGbPNG6I3RIhYl+mLpV0tBIe9h4QlYu8u/gMUiBIRrlsacVjziu/Zm6iTAs7artX21pG4BtiWSf2wtltYOAgnlOcoVVsCjY6kt8xHVZllNN
 aZJbOuQl
 iFb/amuyOrJoPskkEJrxuZhY1MR+rQd1iSbgrldIYaUgj3jRSuwJGs69HZciAK0iLxxHc92dtR391JkT4B9B5AgItR8GGrdkYeJzjxGbZpY/Ej01Y1bWJlB7AqK7doBVLxS6CG7EvksvWVCVjPT5kspSJY725jrAQ2P6zI+a+kLvRBE5sPCb3JBpGYmMjtG+rOpVajnFDSC4bsQwTnlZ+N+K2DXbQZSEG8qZ319OPuMN61UAL5rIzRwQP1eKGdz9GYAHpkOB2G5iHkTUyRKHq+hgJmxbs05I1NA2cOGbIGiXEfCaWMGBYyL5cjBbIBn6xj8zp24eRb4zdZ7z90N7mMIyFebUt/0Y+uubgNrcSQ59uEAj80WUrgb0PtiaOswU7FET9oL7nOuWHGAD6wD9Y9lFhiCguyKe9/oURk6NLQcxurVmN3bt+P0bJBg0KyDea0cBm5EtCfCR1RFDgBe1SiLftUgQwGjfi5ZEVzOh0/IO4qCntcdM9biFqO75/RschoVkTIQyRoc//15ZDDmZ243+8fhdH3Y0jgAn7ma/RnA8OVxUZryYQvy3SjXqpzxkfbVOXGVUYJVofC9w3m/0my0oQJAIQvtasPQQ3/3/Bmv4brXHKx0I2+IT807mNLi2jfIKk04NKF0bomRXbEDGajE3p0YUhQbaJygW03X51NW3pyFopFmPvovfZffY/SqiDSbm9BMJAsQxjYK2QoHA4/pO7vSZqjEaVxSCYdacMGCzfRXHy9L5Rm3NGYoO1OL3oQr5XVlEut39W1h4Gv04jrPZQqgygoBneK6lIrFvFMC1CSe1CXtugO75KVrkGlqiBrBfbHBwdwwwqf47BJ1AqP0lLylsLocLITALerW/q/94CLMXNhEfFRnj6hsAaXsZXvlyQjpAU2rwKloSnUHJGJFA3+r/j00HntmjUaL/bFsTvP1PrC7z50wVRzUzj8kZSaBfC8M7fmzENm7LaCcElZMkCq/cn
 p3mxvS/4
 ewSnVB2MG6fK7lDmyFwwsKvkyvdUHkBPV6gY+Mig0clZeTZbsXcOv2FbYoMtzgoA31ajHeKtE5N3X/HLWwUFAh+rQzs72qx3wFSVcsoVRffphlNLF+sVLk35W48v0qOYSGPoIXEXQNuKXoYnPA3Xa+bhDS8MsHpsRmyBDAY0HrqEZ4200gUeo93HKFpbzzW3zM0tIAomddeUXFq3WJ+6pGWxh0azrq47ChCSjageseNmggXEmOKnmYoajuZP7zUf04u/8aS3Oo9MD9zJW2Q92Od1645PWPM8AP1apZNTnF86Yxelk/o2Kf7mdK1yspkZ3wlPx6PWDmC1/wfwDzUJ5caxzOjWuSSeAD3+johFIzayTtWF6z3yOD/LAwNlqF+dKvMB1m9AwLSOhXhMgc68+P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 08:25:56PM -0500, Theodore Tso wrote:
> On Mon, Mar 02, 2026 at 03:23:45PM -0500, Jeff Layton wrote:
> > The PRIino macro is a length modifier, not a complete format specifier.
> > It is used as: "%" PRIino "u" for decimal, "%" PRIino "x" for hex, etc.
> > This follows the pattern used by userspace PRIu64/PRIx64 macros.
> 
> For the record, I really hate the inttypes.h format specifiers, but I
> agree that we should forward the example of the C99 spec, for better
> or for worse.
> 
> That being said, the userspace PRIu64, et. al macros are complete
> format specifiers, not just a length modifier.  And I think this
> results in less ugly format specifiers in our kernel code.

Yeah, I don't like "ino=%" PRIino "u, lolz\n" either.  I'd rather have
the whole format in the PRIino definition -- it /is/ unsigned long
after all.

--D

> ---- cut here ---
> #!/bin/sh
> cat <<EOF > /tmp/blah.c
> #include <inttypes.h>
> #include <stdio.h>
> 
> int main(int arg, char **argv)
> {
>         printf("PRIu64 is %s\n", PRIu64);
>         printf("PRId64 is %s\n", PRId64);
>         printf("PRIx64 is %s\n", PRIx64);
>         return 0;
> }
> EOF
> 
> clang -m32 -o /tmp/blah /tmp/blah.c
> /tmp/blah
> ---- cut here ---
> 
> % /tmp/blah.sh
> PRIu64 is llu
> PRId64 is lld
> PRIx64 is llx
> 
> Thanks!
> 
> 						- Ted

