Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23B58EC1421
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EA736B0177; Tue,  3 Mar 2026 06:54:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791996B0179; Tue,  3 Mar 2026 06:54:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63F136B017A; Tue,  3 Mar 2026 06:54:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5248C6B0177
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:54:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0BC511A0167
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:54:29 +0000 (UTC)
X-FDA: 84504594258.08.9F59BF2
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7E303140008
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:54:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=crudebyte.com header.s=kylie header.b="b45/xuqs";
	spf=pass (imf26.hostedemail.com: domain of linux_oss@crudebyte.com designates 5.189.157.229 as permitted sender) smtp.mailfrom=linux_oss@crudebyte.com;
	dmarc=pass (policy=quarantine) header.from=crudebyte.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772538867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sEoIOy08sNDPM7R5rm77ylqbd67+xSmbEywB7fDE1l0=;
	b=2isSv2tFRVOVse+XzNww84HP+zJ1Dz0AThpc6Id8XNZ46pGQ4D7nxl3fETKU0aQyRHpbFb
	+W7QCPyGbgfvLkWwbVw/d6GsMTBbVjObW2IJD2PytBbS//7TQwU1WmJzY/rap/DrbJPADT
	sMGPpS3ZBQ+u4rlhb7nwLOfQ60AmGFc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=crudebyte.com header.s=kylie header.b="b45/xuqs";
	spf=pass (imf26.hostedemail.com: domain of linux_oss@crudebyte.com designates 5.189.157.229 as permitted sender) smtp.mailfrom=linux_oss@crudebyte.com;
	dmarc=pass (policy=quarantine) header.from=crudebyte.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772538867; a=rsa-sha256;
	cv=none;
	b=bLuMaJ5UXxh6BTgFH61l4DJ56ZYhRTzXeI7pC9uH76WFnT8j6xx/CisjX3mLr7umQG3gfC
	bjHmbYZP82gxLoyHbTuTAimL/v+NB5i+tJp81AsmTHiRS7DUBBdWo7gDr6Mg9N61hPXihJ
	mZHwwc8cpKgA2lmZna+YLhVp59EPDVo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=sEoIOy08sNDPM7R5rm77ylqbd67+xSmbEywB7fDE1l0=; b=b45/xuqsDe3UOPQGaSOC3QVfXK
	OUdoPRzyNDl+yB4fHKVaFWk8VF87HMtM4PYj4R2Fj4RpvcBDUY2ZRib9drn+oqZiRxQCtGar4RuAz
	RYpsEbooDPugVAlnLrqpLhL+RChtlDNEybUZnd2yTo6Y9uqRr+1WKo0xl+84dQj8eWwrm7umz7n0w
	S0EXkqOXa2C/JE8ObWOt92H0I3bqxVdgJ9TfYidSDZtw7bmGYFyYek8qwJZQAKn3MZmmf/FUVClZB
	QWCtVuugHhF8BNOyUJFLJSfWPIXAHjH3TLcWIb8OST54dg+7vIizA1SPKkby0pw/QTg0kPbnj4Wj9
	VeB+nqiUcTgosudQMsEBFy4QC+CVa0DVQMYM3UhAhXRVcGAw2OrwsIYL9SNJioU6URY8vyDA6TwfM
	CFYsOZ3h1lK3cnDA5o2cflFeZC32omihqCAVM51Ge0wTTskASCR9w0ENeA5eVA/akwkz+TZ5d3AsE
	7f82uN5RuzZACblKcmQqEKYQjiNJSERv0YAwUBb/EiPVB4IwaXQdg3R2xm5FyvBpIz+8+5sqHHPrp
	714s96tE/7YqJbu0kX52r+TMH8FczKREFdRsqPG+YK+I8GIlGaziiB8fLP6RTgOHSdf3lUuYeXzdb
	ttbE75RJ/SInwkaKpg3BOdQZ8WJQK3Z8q+sKFDgvs=;
From: Christian Schoenebeck <linux_oss@crudebyte.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
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
 Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>,
 Alexander Aring <alex.aring@gmail.com>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>,
 Dominique Martinet <asmadeus@codewreck.org>, David Sterba <dsterba@suse.com>,
 Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>,
 Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>,
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
 Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall <hubcap@omnibond.com>,
 Martin Brandenburg <martin@omnibond.com>, Miklos Szeredi <miklos@szeredi.hu>,
 Anders Larsen <al@alarsen.net>, Zhihao Cheng <chengzhihao1@huawei.com>,
 Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <jth@kernel.org>,
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
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
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
 Xin Long <lucien.xin@gmail.com>, Magnus Karlsson <magnus.karlsson@intel.com>,
 Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>, Jeff Layton <jlayton@kernel.org>
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
Subject: Re: [PATCH v2 016/110] 9p: use PRIino format for i_ino
Date: Tue, 03 Mar 2026 12:52:39 +0100
Message-ID: <12847641.O9o76ZdvQC@weasel>
In-Reply-To: <20260302-iino-u64-v2-16-e5388800dae0@kernel.org>
References:
 <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-16-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 7E303140008
X-Stat-Signature: rctfz8mwwnrwm3rwsdwpji1nd7sd9wdu
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772538867-877986
X-HE-Meta: U2FsdGVkX19FzHbHP/pqgnmzARka39+t429kqhw3EcIpCBzw8AJawrpZxqqyPjhEnXPkSTWI+Rc0lv0RgRv625tR3twZAaW+Ms/wQiIT8KUBSZUIRonldZ5uqalVk289kvDtJg7MqF0TLqMXWSaxPl9F9oBecW1gVewcB/GsHlkRFma/ALSgYs74w/2z76sUvwVvLR9O6inQDTuyDfjhvRKT0P3mLrCI1YME41aObTb47gb40Z1UpnGdxw+WT5JR3RVPVxNeLk3UeR0ZAoUFTSQH7JVnZMqHq1mnpu1/RHUkuQsC67tvjBXArO30AP79i+/mpzUGn8Slg3NOI4dcFOKGMaBZ9Xvum7D9hBvPwh37v3tWUkHvNW8hJjBghMRWIpJ+Wv2O4N/DnYyxyVxOLqF3utYcCzThmFRQbJNrGY+PYUbBPqbs9vqnyP4PdEDqTc+1QYMH4epI50EpVAfjcnlg/QGY2yMaRNBQrqhUaqDe/BiZ3noeC/T3rNWWetjByjy/LQSCaMwv3NvdHJDEcnVJBAJ55Hir5SoQN/hmNz/+4jcKLca0Wz2Qpz0Yc8hgpsZzQrzlQmeBb2116ooqjGribU+P1Le4k7KvDlESb2CA0D0SO8/hA/8bTEf8Yg+1v++AGSTUrYJvoYAWg6+ga0fGRKyzdrFGp4lkkdDxRVghP4WptTcOdONFK6i2X0dgW0gvwSZdW5ipnLtuq+AIvgzGRaoIybRE7/B5JnNy6/3XCqICt7+0DlH1V5DY20sD3G3uE+k+4yOOpRnyS6OEDEdMO6M9cpZ2ZhtKGmwanptj/a5eCnoLzJd+Q6GbjUaKsgUwVd/htnDRXYS4zF/EFvLLhNElWQsS/pJc5GItkaKI1TCZ/cNNxvUqdQq2kVPPpnsgr7g8EkPbtYwuTN3Kil3Xe12iB68BtP4/Qx2q2DGFg7+a4m9p2+stdST3F43DGJ+diuRim1Qk2rQAqLy
 YMaa3pZZ
 Un06AstIj4AMTVRF5gJEJQKGxDSMilG4zLxLaajntaA9+xYaUNU7kDfDjjPuwEVU6RMBFwYdSle0HXyXxSnaGhvGICH27NDU8FQ/waUabxD1GDM/OSoychzsIOOQhzzofXSYgoT2W8mEQoekMm2gth9/ZiuEVjB5m6VIy8m6JEAixSMpphGXIiKA2uI/E8IziGzWeK22BU6clnD5pWziUw2l1u3sBf9sDU8VoYHXzn1aHqCTWq7oTqsjaDSfqy491nA9UwLKqejHZLAL0QIpCxw9AiQ1TULJWk5nymoz45UI8d4b+TLO18YG/9ZxssvQqXPdLTLpsWcGsnxaQ03gBs3RLlZv6ZAi7DNQaJVQobCCefkevm8nbtYHzV3M/BMoNWsMG2DuY3YRH96zNb+fXJYe1yRB77S00/arQZJGFESXBtdFew7VOBkza5JPLKfzEmm27CJZZuJS8bkv4t+r4FhhihwDx+q6k7ZioioS2QvsykUASSlNFgOo5hQJfytidZEaiaSOj1gFuWgMoM3AhJ1ZwsSbCTQxp2+HZPOJkwMOh626bufqjPC1W6A+6CUA71UNzyxdjSZU/MspT2Gn5IQOS0kS1ciwXXQbU66haEnOFsE+awYEufu3wu4NT2emC9GbYZjB9sZtMjPaEC7UeyPvFzqrq4Uo/aTFc97+c0CjP1fQE9IslqQymhnmOe7a7tjJ8AG+e1VeFTPyHcvyTO6GHmDpu+ecWWn75pJ0OeJg0LYYdW7ZOvTelzv4PUV38aiXJrq+WX9i8iEpEverTIa24RY24HAAxEsHjw/WbieXamG4rOpDeMQi1gKhu+aB1XhgucszsvduWbliP+UMDpX9MWk7saelexKSkbFaKec1hn229FCLYw7/QT9G6DJBhofb5V6Iw2CyFfyzKD/8iUfEyZMlDTuBJK1k+q/Jb1ciXkiBxhNMx8ZLnTpZGSV8xiL10qOKqOQmD/2Hmg597WlnsNL4d
 hhmnI7Ht
 CtT9Yz3GAwaKjbUEQa5l4uf5ov3LS9KsMAVU1XbcOg25lnFEN/yDRlCXPX2BGxa/mMWX+z2OQ5ffaorBvanfQ+LBf2okxSCTGrQ1DRg4MDh78Pztd4MipJvDjCsDl0TxV8r18CoQvxr2aGJKaKiogvzneySNS45lKFy2KEcEvpXwOp0A0R4xk7KILi3JNKTXr06qHk643EXNX/nGwioxmDcftzAcv9csBQtUD3EmTCAYJxTgLrbML7GhmFgab2oQT7r6QB7UXtMjXdIAf/cEIT7GzKAjL4RatvMWpO4GXg0tAOOOn1Z+NxhE6dXtmbb0Xy+gyHlcykTsDE1F7jtcQBX7Ulan2BZFJPgaalwCo3vwGph92QaXuPXMWqCkr61D4/kvT8qMbaV/UsD3NTv+KOSbziJah3tQDSNYzJPgT4NgAEPtD4wZiM7zctAtFvFwnHh5+ZXUiPvKRkereUTrN32jNEgd7+9xZbNDXjvwNeFnkPbxlhQldeYGjXGokZqnNaHLNHFdv40j8jjhYLA3PLyfzpRdXlTai+dLcAyMaPqp3Q/j8exBkiQN/51xhSb+ZV24QKoPnGzl1rfb+3O8dObU4wYkC6TS9qHoF1cmrkSzNvYhBxolRn+B6ChcVeuRLOQtcrLdblqontwEykLpDLlRaJNSsGCXhf865g7jTPd6l/Gcg1y0b69HIgd8sWo8DT9G+oGa+ZF4zbO/NX948UQRP2+qH15k7JlpFvKYralAsSdn5DuLVtHnyEBilphYWs8dmd8sFeAcr0wm1dOE0MbrT/OjmBSwASozJ6CuctdA/ZXngNLAILD5kvvy0xfnIyEhW47Ga4Bl8nCsGw6/Hf8oOK+Uh2PhoQjNt2Va0N8rZU0A9j5pQgA3zoT0pkK4sLppf2tzljC2Jpkcph8/JJWcxYXnNgAhVdqoTgVs9yl1QHTGlkOWBs/+oxPX/VgNxD6L+iwcvFZouLNldSY5sT5joBggr
 tgIaK/gr
 eI2giwkcfkh0FlpYK7kloRdfNkTJSXeLeguy6B9TdqXySuPFF122LVW4FdksL3sNUl7jluvmWLMesrfD9a1+M/GMZCEAjO4BtT8R6RQLR4WINZ8F8NALVzANSPmr4ReIoqvZIKO0BDFq7t+WKDRCuesWz6hwfH0bTt9mA/XV4v4E6ZTZQ/quUqydlef7Hdg+Hfz2oub9rmMLwh3c4LuiZUvnW74tkXadGJS88cZgrEfKtwAV/+O5S/9fshQ4KDIwhaKCwSe307UqNhTfUJ9CvP/dsXTf/ptkNtKYn3D91ZRW7TFPHSfjGLpdGYnNdtdQMWIZsGtgQDOLLiVNA51kDnW+9WWVd/uW5z2SXaUcq7VGGAxX9RGD8apeEU+EZFFAMYwCD2m/z8rIYISGcLRNEUdDTL4t7a/P/G0CPGhWzEqfsuMhHYU+NBlZJTq3wS48Vcmy8Ardid+68KLl4IDCm6R1B5ENTI1knUYgip0ngMEzxj3szGrQuAXmiLh2xWWtAVGSKkbFkOzooKHzQNN5DX2I+TP38hB32kL30UqokT+M23R7nnhHF0ouZASoYmdeQVVhNO+xgF2QvYC7Alak8fQH2M1IHBDB/8CQnyTtqQSJnSifAyzfwsLK/HsdgATT3ZEX1E2b6mxiOLOg6kPQetqmBpo47cjkUOC86t16rcqG5vGN2SEYxm8dlAyjfNNmbHEbjQYwKIspSRQQBxKO1XtbHsilqmaOliv7LOu6YWeQP2gsxjeJUZGF40G2J7SBQZMWI6lMP5gVnKfDSAs6PqdKP/CuBGWIWiNGRedXMVYg8TPfowb95+egBqxyCKbNGeI/hLhILVnCPfqkSTUzeBrQY8bIYlz7Gka0EY+VeyOXNwvA5phkw7gw3LrqwhHM4JBsctfFzqBrZu+6W/sO7X8OFSzx50ynF+zBVEsYmHLclJ2IugFX8ByKMj2UIqkL3dQ5DBLx4zCT4g3vMVwHjnZMswEcx
 GOU7hVFF
 puTrEF2OhyuzbbqWnRu11goGe6151+cdlchxHElOWIsJ7+emT2iQ7yvznTkwYGe5V8JkosyVI+PEbNiFJcUkDQGGn++SHOIN0Je6qlLzpMsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Monday, 2 March 2026 21:24:00 CET Jeff Layton wrote:
> Convert 9p i_ino format strings to use the PRIino format
> macro in preparation for the widening of i_ino via kino_t.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/9p/vfs_addr.c       | 4 ++--
>  fs/9p/vfs_inode.c      | 6 +++---
>  fs/9p/vfs_inode_dotl.c | 6 +++---
>  3 files changed, 8 insertions(+), 8 deletions(-)

Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>




