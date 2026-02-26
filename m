Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 454C8FD8FE0
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 17:14:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6D646B0185; Thu, 26 Feb 2026 12:14:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0E336B0186; Thu, 26 Feb 2026 12:14:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919F46B0187; Thu, 26 Feb 2026 12:14:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 789186B0185
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:14:54 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 450E1B857E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:14:54 +0000 (UTC)
X-FDA: 84487257708.02.E3F7814
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id E77B01C0004
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:14:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772126092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f1xGOfZqrgDNOu3pvsQmwV38AYrHNXAFa37RH8Af4g8=;
	b=ZHwvsrgqDOxbsi8Omc8032PXDVbzphksXH+OyVLoiLB2Mvb64ftAxHfkl4xcB7LtlRyWX4
	ZiGABxGIV/fiAkxUmk6evw9yHv03x+cvvNqeq2TmF/SzBhZSdp5Hp5Qh/eg9kZ1ISyG/6M
	qWGIcpO4bkpgaGltJ1OlXDE1f0Xyr9A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772126092; a=rsa-sha256;
	cv=none;
	b=pu37hti5f2OBK0aoRNl6MvoQwMkJ3062TXgsNHOOzMelMRnc+7kv2b0WM26Svg1TF4LUXF
	OD6YntLX6zYRIYBKR/HWVIN9t62hqSBmtWVC7k071/WZVoc263Dk3znHA7RNLzAp3LSqK/
	AdOn2ohYmfHGTHSKtETDhqbSuQVcrZc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9CE9A1FAA8;
	Thu, 26 Feb 2026 17:14:50 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 784C13EA6A;
	Thu, 26 Feb 2026 17:14:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EVZNHYp/oGkQSwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Feb 2026 17:14:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 01DECA0A27; Thu, 26 Feb 2026 18:14:45 +0100 (CET)
Date: Thu, 26 Feb 2026 18:14:45 +0100
From: Jan Kara <jack@suse.cz>
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
	"Darrick J. Wong" <djwong@kernel.org>, Martin Schiller <ms@dev.tdt.de>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-nilfs@vger.kernel.org, v9fs@lists.linux.dev, linux-afs@lists.infradead.org, 
	autofs@vger.kernel.org, ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu, 
	ecryptfs@vger.kernel.org, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org, linux-hams@vger.kernel.org, 
	linux-x25@vger.kernel.org
Subject: Re: [PATCH 01/61] vfs: widen inode hash/lookup functions to u64
Message-ID: <hbvcdh2qnimdnbqnayykrcja6et2oyofe5h3s7n4imwbcaqht5@xq576inhcje4>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
 <20260226-iino-u64-v1-1-ccceff366db9@kernel.org>
 <cmxf6pu3xuwvbhg3alu725hd4b3dheowoumd6drolde7pypwor@eplss6764uuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cmxf6pu3xuwvbhg3alu725hd4b3dheowoumd6drolde7pypwor@eplss6764uuf>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E77B01C0004
X-Stat-Signature: 73b7451tunhjefnobd9ght7eipy98cfi
X-HE-Tag: 1772126091-406108
X-HE-Meta: U2FsdGVkX19SoqwmzRDZOyvL5DLLUMB8Y3xmt+HUTvSwKcZiJbkfKZyUwZd2F0VfJ2P15hk3ULnm+eu+LOXjRZQu4yv5Pt0Ixb8E9m7lVTsW7Ub5i3HnZ9bCdXYEhW+WjsHMLBxYy/ZDNwcILgZS9RoIaqBXHLxGEKvbs2Fgi5sk2SjbwuvgGCP+CdgTkdA6NobTL3lU2995/W3JOkGhPUYLK9T+dXQcz9CJJyIN7kg+ahoPfRS31tb3qgowXhptqwqIB8iARzKIWK8pFzLmcbAQGF9xmmaV6RY3heWsxZEobj4uUVse0rVot+a0/oXTFiIr5JtkVboaoL11vUb1D9SZBL+MJXffG8opc/6RNsapG/VRdzAKDNkiwdcyHdAvAqjQvu7RfqvIp6FWkmHPcIIEcff8yjsoq6Jb7J9wOBRF0iSiVHbQ2vH1C8uTEq+8sna47TxBB/pZ689/5smtqcU4ezdOJzUbNxP+nNSWEeOGYLAHzmmy58ehtA9BKEQmWvwqd/cG6bEckOizzHwVXOwZeyE9e70+9+pkpr0ZejNwpHKKdyAMqhVLL6XgIHtVrlPD2xfrGePsdznhxSnEiCLlaNi0Qm8ZeYEstc2uiCB0M2RoDtKyoB7w/qAFQRmWXj84Llci5hGIFdlN1bxm8k2IpgIabLb+uwKncWt96mMvVIAjdi67CmcmEScwkrPxrdRnoSwgRRx8eibOJSF+p2Qotyg5IHfxUYr5VnRC/pb47wRhJbH7Wy92xIcH03lQAQp6ba+cRjz6KiRhSSsMk3RUEGZ6WcDjXK3rNGcyZ7YzVta+qRbsE9gH2SRXR2aCfQgswHs90W2qRsuL6pIJEMPtCBvuv0HqpyCAnmmZiEVKapRnd1zAvqLiEBVNctbRPnBR3Bi1xntQtfFCvrUFZeS6/7YsfHYjz3q2UQ/m5JyvB45ceE8V14bSVaRbW22Ay6Bu7keJwWsnCIxwTeD
 Igo9qjxj
 NoAs5ObNBKu7u1clNglix4vbyhV47IiQ2jGHf4zrbYMzGcB0MeMtWGnXOpOkjhwboh/dbwgys771XHVC7IlnIDClYWAdd/iTe/DKJ3IL5ux0MjLzdasbR/puHmPmqv9fo9oIgn2sHLvjnOG6t7axT5dBvyILwpe2UDh34MS8bf71DbT7I+1Q9xKka9AgGbGJpSJLANq6CtD3Md4yLb4a081m/7oYrfz5081Fi9CPgWuFgrD9YIowQdVciTkWSQKGG6uuPLbnoXAnnEh8dA3UM0kIcduEHHGUP0AwzsT/45FmaiObyeS3//Ei7mmfqXTIxUfJMeeuByhH2MVOHUYf0S8h0GMlmJviKykeysR5n2BVLFOgb9YaD3+eY30yNr+QxbCFFg1xA4gpMIXfMEhNtjuzUwI5V5zVHKYHS67u2Y8Xuh59zzHd5Uz+frKmny/mI26kDbyvKm3XEXH3A7OZ34MCA13K9iWAeyy87rkX3Axwnv4Gk+rQqbJH97unGyNCRU702NBFWGdxKWBwYFy0K5DH/ZxYaMsD8nYpVBEg7cU0QznR0VVDU6kQctGaJE9eioh7Ge171u8baAN4KnCZhtSPuYuHfwTTGUZNLvmBpmmpXxdPNnpuGEBh1Trrwu9jecSrwDQ1uYuh1gf3QJ0dH76mlstScjtOodeD/zl423Jx9ITUD9rpjpghzBp+/Uf/blRqtUAxJiOdO7h20vzAvRjyU7HD20ppMcteLbBtknv89y+DIdUWKF5IBTL0Gm+9L/f6qw5j0gdyg40DmgTRvYb9XuMYEEpJ63axSjwrrEP/WgU8brvfYFpoR8Va556q5N1IuJFXM7qcGBuZVdE2DEycSvu/sVgUn22QVAbX4spyyIZsGKUrGXa0iDQPNpL2lC6pjXC0JTY5wcaBSm7ldab2kmefy3dzCdSLBMOCmyzis6mnfGq+elssnExOzLwGerdWbqTScKnEn0rxki+LnAk6F5CKg
 qB1GUllO
 MYUP3zD1fJOaB+zwcq/JAem0ciF9jQDIeHemRaKh3j4zqf237SruHe12mOFxLznAaF/BOEekEAaNIjconYaWgSOG9W+h3QtcSocUGbAFX+jSBTWRgzqv53/b3nFr9dVQyAYtkML6+vGif4bTpny0yS3yQyUIhm5JDSE3R1pRkkSS5KQcPzZPcsiNz0hF6sUY0ap4TcZbAKAxmORi/355CCClTGUD15s7e8baCZD/qV79ZBUqyi6RPFSp9BCbPk/yNhfsen9Pi4Nw9dSg/3qZtY86cqoxyJTamJYYZ08F6ydYUe7s0CAdeMXtn+7PqrT9HugiE/f0aCL2slh5XtyZf9GhiZdLgBVu7vwLJKJnyy2VrTkKTOszXIt5XI4yqzzErhUUzpGyB9n0LZNV64IXdCMzoS+jVdITFDfIGEG+OOWX41dTUrD1vsxM93LNNRJEQ2R547/v+mP0T+hJkNJ5dQpJ6FOqC0gHmo8mh91CxSfKcXoUaAum8npJniAYSSdjqQdwHNoXD00kytekxOpHOw8iuxnqJKhB54vlrQ9vHQTL0OmmsD99Mf7ySaI85F4cGt7uI6FYdLop0l21vZaTUR+5ioqxhVFsnmrlGlt+ngz3kHIPxynKtStjzu3BlP738i8X8H4alf9p8swOe+Rcfh5MEMKkJy6uxXJbKjl+EpSFamoX3oa1mchrMZEjnLnwqAhpwiFBw00NzV8Y6CbOTY0LBaa/CgMG2mBOcxxkEi0A7xkBxvZByGcYk1Tw04ztdeyE7EIGim/EOZce2nc2iakOjNCs5bYnjO2JBWuOhrtoIoHkwEOkA7pBO+Ka90yc5mWw/+1oNw45PX0jxF0/6MIHN1xGkCQF4KVe/9zEaxTUrZwL4yfeEpJtiHeNQCl4nU+ko1O1+lGNTROzEHINFvDvrQQORDDybAJTu3MdTYQGjhQZE7q0FP2zfYBh13TVF/ODW140tEzXplA/hF4tgMyOFZMjz
 E6nNAlTj
 m9V1/+L4dvnKGOMweyTtiW0sLYA6WLs3BAqDWmtx5XHIuY/OA/D6h3cNpRHhhFlDui7OegW63yL8jm7ksEc0RNI3IuKBrP2OOsz6IjNw6gBrbhuIXs6DdETNY8bGhyfSiXPsg5Bcjij15jLWc9dSoH1ZuvBJxgXEYGbhp39RCGnnWo2txDSTB8ITsCiR1ECjl4Tx8ZTl4zZKvtVUp+lRyUpzQO1Y1wusUNVNF77LfR/IMgs/MsMgr69ZZAxpg+yZkzjmN5asCPrVikgPIbujD08uYFyZ6tMWptq7e9LQZZIhlzOQeEOdXzVvdgXjRGD2M1tltynQT/A2FaTBIZ/9dlpF85XAy1K/5rc8sTINCcODBgp6XlqVCaDagk32HzAgdtPbjW6RF0hKplHW703moiMg8AubMt8qYX/A4WcoODKk1RNY9s2HjNFpYYwMQhQtFvKbqZVFgwxhVry2MKbkV57m+wrbKbRSEVDnZksi1KEDdddsHvebsgcc3jt4WPAlGINhDsOTYnYGVUxXUAIx6wdl+KpEGPLvowbIoqnGDVpElvFrDLxKqz7/9IEzbIAA6VgN/3QDc8CX8gWqfMtBTar8L66pEV2Xw6VIibnx4IHSt/8/MoSYaDtNEXxdTLSkOQ/0QT0cR+93gQJDK92MhN03UcQxNRB1AiIpHbYTfnNe7LL/6spnPRX2pPHke4ol85dll0GH3shGDux8yvA+LUITJJmDDsM4zrHoGoq+DEAcamnhCV6EK31LYK/bKu2V3uMWKkpVZ+UfitpvKs8+v6wFI/mMWDC+awuixtbtZUbwuC22fRhEdZfA8J9iV5q4S5gvIqLNsmMS1iVr1JiMjBMfSkRlxjVu62qrRtsdQB3Lm923pOTku6DNJNSi+Hh3hPzgWJL/Uqim+Q/kLG0j45An6vrImmbs/MDfAxDfangVwnrROH6YOXlWdJNBnhSJYKyUCNICLOxhklGFiYu4bV1QYUgea
 GoU70l8w
 ieID8KMuy/7O/kV0TgKlXjhfsbFBxn7a77IhP3KmBOO2q5+xLyeE8tNqSS1keeZQRYwy4IVP7RbXu+2gF+O63bmclqLKPYTqv3Y0qlH6R/1dcKZi/E2/flR2emyDDpLbMQNMHa/+m8YhOCNktPD+d18jf7jXk9z8Xos0ZwMZ5hXqd4ypqvg6i6+FQxepmyDkA/ue8rn/HTg29iNYLEhxqX4W0Qitp2mIMEyM5rox+lkrIaX5y9A0VhvxVl1tXrc5c1jEy30LOG19sSbTU09OaUwBoQck03ylvSjM92sqeV+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 26-02-26 18:00:36, Jan Kara wrote:
> On Thu 26-02-26 10:55:03, Jeff Layton wrote:
> > Change the inode hash/lookup VFS API functions to accept u64 parameters
> > instead of unsigned long for inode numbers and hash values. This is
> > preparation for widening i_ino itself to u64, which will allow
> > filesystems to store full 64-bit inode numbers on 32-bit architectures.
> > 
> > Since unsigned long implicitly widens to u64 on all architectures, this
> > change is backward-compatible with all existing callers.
> > 
> > Functions updated:
> >   - hash(), find_inode_fast(), find_inode_by_ino_rcu(), test_inode_iunique()
> >   - __insert_inode_hash(), iget_locked(), iget5_locked(), iget5_locked_rcu()
> >   - ilookup(), ilookup5(), ilookup5_nowait()
> >   - find_inode_nowait(), find_inode_rcu()
> >   - inode_insert5(), insert_inode_locked4()
> >   - insert_inode_locked() (local variable)
> >   - dump_mapping() (local variable and format string)
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> 
> Looks good. Feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thinking some more about this (and also seeing the discussion about patch
2) - maybe instead of using explicit u64 we should typedef kino_t as u64
and use that?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

