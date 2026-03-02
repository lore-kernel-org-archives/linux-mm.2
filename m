Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E983EB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:41:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3B926B0111; Mon,  2 Mar 2026 15:41:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB4F46B0113; Mon,  2 Mar 2026 15:41:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37F46B0114; Mon,  2 Mar 2026 15:41:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ABDF36B0111
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:41:49 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7046F584CE
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:41:49 +0000 (UTC)
X-FDA: 84502294338.24.7876427
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B6E6E140008
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:41:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="X/phi7gi";
	spf=pass (imf23.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=87ihwadu12RwMh1f+CD9Cci7xtbgwi60tE+T+BS0JHo=;
	b=WsXU0wCU0XiItW2c7385jtEKierrc7105o/nzpoE1HsL4YzbhCVUCRfSUiADbVuzYHgPy9
	LqZrWQeIqZMjGcv+UQpFIHnyt9eOFAh+mTpW0cD4F7ue//d1dlcS1ZmDScj4D0dabFtQeg
	aLpJ+6cXFNSu1e2YaaiMtpS+LODBtQc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="X/phi7gi";
	spf=pass (imf23.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484107; a=rsa-sha256;
	cv=none;
	b=unP2wKnS5Kmqfm/y8e3tILvOa3DZHwLEDCGI/9fmcsyhUTZRrJ2WXmAzkwZ0Cz1XfDeIPc
	PJGh9tg7s7CkZWUrnj9+o/DvNJwy/G5ACal9G2Rf616qoBbc2uETm5P/afIPOlzuoxJN14
	ccunE7ZpAx7rDGUDDJfol1/P/v0x4hg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F46241909;
	Mon,  2 Mar 2026 20:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E3CC2BCB5;
	Mon,  2 Mar 2026 20:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484106;
	bh=vNkzHuGLAk6SRSLBijwmtGmdFlDfgPU49VRuVG8BzJA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=X/phi7giFaiaj1D5rEFCicJuPbTWAsn004MqbAjC0lc7T3FifsJTWN6txiKvvhPxR
	 oIB8oR1w/cMe51tLB8DbblN3yOgcW4zdAnbjf5yO4FCsvs5RMrq0qTihvN2IseYp40
	 +QunU7MlsngzRdOyWxLaFxrJVOED606+Nr+pIr+mZKTzfVojHse/GuifEIFhh1hUKn
	 A/5CxguwtMB2GqqnCaIVPuZ8bqQZmmsgab86o88A3MEM2rlxJQEPPclKHNjtulT8qj
	 i+E9qCaozbnzrTSAInWiG5fTyZXUKm2QpPYfZqjb9hAn7PUwtwMGxcOGcBAslnC8+p
	 f0evqvl1eIhKw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:54 -0500
Subject: [PATCH v2 070/110] affs: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-70-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=12112; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=vNkzHuGLAk6SRSLBijwmtGmdFlDfgPU49VRuVG8BzJA=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfICX1Jxnt0SgWXJk6o0J3qu6igz5r+jH8R/L
 pnDRJJlhteJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyAgAKCRAADmhBGVaC
 FdM5EADXgpT6XXk4/t6U1lGf/D91W3n6UCz5rUXRXJvxglEv4H2rIa4+9wcmkUfftfPhsOiPXhQ
 CYcCa+mL1tE5ShaNZijMFX1p78taK83nEzxe6bP4j/iJPiXBwfpvKwS6Sq2rcTFfwmJ3FXKrEhO
 PH3duzRbwNBvAmHPMj8EAWexWj4ASOMuUZdK6jXjYyFrSN+a/MCBai+8yYabyGOo4cMepM6wdTx
 JSiYjJiq8M+YN8GvqxmDiAk4FpyHJqEMGx3ruCWks3LuPHakheWi+qndFj6c6G77jUJrue/C5mf
 FhvsCWRlJEIKH8jTgtdyJWt5mDRuiKuh3iO+HflCjHlw/jb+Q18gipr/Yv3WFHyPG1gKBjpP46D
 BKFnIxHLsDlD52tUH2S4iXa76L0j+hgk0NS8GFFLhO9ifPYZsgit8R8oaTvovtbqj3VbmgmDppb
 oCREEYsP4ZMu1wNvM+Fu5CSRlP+WiY/LEMZNosat/fGxfjzsXjlH185lU9hDmsU1bZvVL1Ca8ie
 3hvK7wfHF26GolLrq33oXZY3n57DEqySFiyzBGAmTSZ/zkZX3BQmsi5AM4NmcGxgsq8UAV5Ukgy
 3tz8EmMCwtxdmMYYQtPxpbT0meSfhd1XAEBMSFsN9evDOiLTQ/KjA17PT3PzqoRTn+rMke7e3Yt
 njvdWX9LkqIDaUg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: B6E6E140008
X-Rspamd-Server: rspam07
X-Stat-Signature: estwitike496m4iakd36apmdzbjqwua5
X-Rspam-User: 
X-HE-Tag: 1772484107-30166
X-HE-Meta: U2FsdGVkX19844fPDyHbthCh90gnzs6ji1FPYiPJiNb/FhEpjZrg3atsxMXCJ5bT8zGF5ci698mcnsCeur2edIG+QIZVCyBZ8oQclkPdkAUsNBfEShrePoRzAwO5rRPPxsqi0iSRBAPCcqbETRJiv41fIh7Ps/5i7Xy7dDgr6TaCvenbpaeXTDTfBWGx/g1DMRIjC/nAu3mDxHlFZBNqcsRkxzI0yL/uYi7URnszhhMe9lCrmISWMmdLRRD00NUBC0/0eg2vO+kY3EQ1qDKwLXbZmJdc04OLWntSe/Pjy/gmnVXsYuT3Lu+E0lJpD1475HoCndfTsmPFk2op4Wg3v3UbTicNt967ELAfHHgRhlcsr2dLNrfBhvj5SBu08+FI3nl5hgd838cSqViGaY5nRfvZ0M/KjoHj21N+/XWkjw9It2Ln6RdEwyi6zbgLWa+hjwOtUUe1GEBzu+CW1NVkzZNf6ZAc7IDiAvbXtobvN4xNtNCjWCgLm028hGmEu3c04FxnlUGVQC8hEozgHXiZF8znIDu8sXNSZ93hADdr5FHGWSb6d75x9wuReimG7dyBM16eBhOLHdzNU61gSakx31A4saJeVeaYnVaD+zXrqUZrVfhRWO8h3d6RlDbKC9uX3WBsB5DuhwTz6ahymUdAX8Z+X2QNAMMCwruiPtomfRDKYd+O60GLFmtJM1Q13YTXCml+iZpUSFLLfRAGazFbgcVRZvOARmWMfNCA8XfT2sKjWBg9G9/FJA79PoVAeyQhtBYk7r1kt3DUlOSaDuc5Ki6T0fGruNvWfisDAcuTkOqHZy/AwNMPqB6tk1A4t/0yvNII2ZtFb27AIGc7DPGGCwjf4KumrOglq779HwudVqH5eUKoPls0wNpmDR0Yq0Z1VR2UZID1rKBih5d3GCcArLkSUWQhgTVsNpTg85fC5SGeA4KO4oG/Ql1VnJiagRtQBSr0KH/X6qnASyVr8eP
 KgfHjFA6
 hAblZQjGMEFBS7mxnXKwtiXkV4q+TxieO9D4v8xyhjWeY4BVr1NZkEASxDzetf+o0T1tyfaUau0g3vI/wkfRlxHL5POPWr4wtIFoR578hkS6e7Fzb/EhPvYq0x/fz37wXxsC8eeixsr+76JAcC2/7xE2dykb51V3/uJDf55LDI75Ebj5kb1wLYdMShXqJj2j97vDnUoq4nf0zGQPNuyLUc99waeJKZRGZIeuz6gCDwdRie8R7Vk24g99N71WjDJUt9ko8iHWAcvj4rUXrQGBGCK6Fh4zuGS5qA6rcuFrkVixl2/0Bxik5mCToEDVs2u6e97j1MUydN0fU9xT4m069XaXCagzmt2tIPULeZHuXbz7PaVRhAsAuBveNLqq8B26wm1EPhouRPe8js+tjSjyGkpb4kHnUGhBrLBdwO5II39kpy2XuFtlc52Q/SD4/glYyrIHYhsIzGDFvNA7dYJakHwFU81nn1oqHnWXb6Jv210L8ock4fUDgnE+eUEmmnaXt4r88oQnkdnKPYpWbWPKCrlqo2RTi+gKASSQtOD0aaCXhNjcr/XVeZLFzLIZM3uy0YC8OmJMXjBofI3dYT2XxGzLtml6RsSiKFxJLeb+wz3NXW3WXPGullE84OtolHlC7OTwJBV1ZXCY0C49VDHjkBuEcohD1zqtoiiTGz0rnxLRtBeTT+MxM2JXYp5zYMuJHFZZ/232AqW+DBd8t7yVBImiXO7ZeGCQjKqapA4sRD0o/kZb1y4WPr6cn9leaoRxfVQO+ubd1RRKsnRbrFnqhblE17L9HKmp+eNjogr91vxKA8X8GVUG9mejaXu6fUiVqIINfk1KUrBLy92oIShxQsvp2dEHc7th0+89aOY1mW4NZBMSS0Nb7HW2Si7VMpM117y5gcba6gVBdG8NFkUtYC3EOoEc9C1M63JJ++5iiAZOV3Sp9coP3nJD20Um0/otxXO1mBSYKgvyLDVee2Ujc7qw3Ta4c
 CnUogYEt
 f+QbbU2EgY41ij4IdcAyUbepOOq51qc6c9q6FcbCi9VYu+Zcy2+Dn9mCPtkvShQp/5Za7yad/zPfAjNtWAhQPwUGN6X2g6Gshd6ZVe58wbw340wmZNWcykImanisyjw1L5Vf4G9V1gj9HINk998oOgv4LK1+0qPHAkseMzn+rzltrW3dCi1K3HjfF5wnzhVAwXBnHl6S22TGhvocv1/5yTZhh6dFrMtLk89cDTqNgSpc8L7opsI/Yz61G6RoiAbZ1toOoYtdTFG7ohuuOX+4eg0Dw8Nqs0MVjCOblUxESd7xEZwUW9os//ukurVj4FsIs/BJ+T9AGsvPJJaBlqswOiXBo/Y1sWFBaAW7gdlihTmpgr5ascCCIUV+uLEZeQLo11MFm0R5hSRauhKwDkRMiNtUTQG0zNUJ87z+vYMYUooizqKAtJQiRD9xTaeEtDC4kUB6ob0ci4SPAmq+ufpEkgs9v5LHEvlJ97X70HF/tJnRz3JAi56F+oRCW4PLqj/h0A8tXuYM4ZPsWGNG9X8Oi4cMc9T7fleAkAjJw/zUcOvddSr4CY1fj5ZtLO402oiCDPJYYN5Dq3j1JalBa3JG1i23tsGb6Q9S9lixzCwhhwbrOFj8tLk3W2dxQZ9s/Bq3HxCjAMrqMn4zT/B1KSDlNunYXC9a387y2TjWiGecxiXPKwwu2CcOfqvyNx7UCKLXnDerdooD8qoNbghVOJr3rBih94wpwrYS5m1jCfjfGIVMg44ztKSsY/Pc0XhuKl/jW6nPzBHRYU7Bem5CnA7hDR4Ne2q4viCJm2MgLmYbarML0GJM3SOqpFPXKUOrEmDbeciF2Sur1tLhTlWrLNfiFESQWOnAmouRjIbZLNarJSX4GIiMWsKZj0A7qSu1JxeqMIinbbe+Xi7rQLT2RKPjhvtsq32qeaBKULG0ALtgSr12YLOuzCoOs0V+KzM25kiukP9GdR312bm/ddBZf0dxQUQ+xqatI
 AEK61XoE
 bu/LKP7dCMaPe2oP7HD39TWI9FqgVbX3rMVRY7AmSmjSbl2GXUN2fTP+AhRMSY/uvJdgSbGCNpQEm37fNhgzoi7UrDaD/Jy0vUPm9pszZGByGD1WOWZsE8iv1OW3yk/lbvu+CUyEKkI9rUwG/wGNUwolQDd9YXrpiTCKybieSO3akaszR0XhHWVkpkTj2HMGsVArvkihR3W4yNrEdNtSLHZRIUbdwb44RyVMwjBuJ1FSvUJn4yinzXNiAReNH4TKr3GZRatM2Kj2umGkzcYcW2gPsjKTYydOLVFrLSegfCEwjuFzO+7e4drvg5gBlKka8x0d2Id68vt75PpNTG/PYhiHCzaBzRo82fPxOD5XGIrZs4qTWoUnSxoRGEGRGpVQu89wYd3dNbeEhmEkmSzzZt3Tqyz9fkS8V97v4ZwqCYT74HJti+Z+uHJivmzep8sevZocYI+2sBJgFNHotIr+5E8SqL8dhy7Q+H1AYd8RqAlX2HF3FXTG60Ln5FHs5DwXFZnIzCRWR+Kr9v2GT4+eYmGt1xX2zHlsKD5aSGscKllciRP5FjQ0tiLlEFM+3MJnFq8+3vJh3cqvzaRimKlM+hh2+itrIJHxcqnfg0ZXLS4HmvJZqpfZ2GhgLnG10hTJqi2FXsG+ClmyVurYiaKF1PXdLtM+CNVsuguV+S/QV58dTrGVC4f1jXAhZQn264wvwrhL8B1WV6cckyPzvTBakVgQBApahHUdCVhMzAVBE7Q4vp4nM6gHfh8MmLYA2ynCpf98lesXgdTYOoWwF0horpHOIEjCnBmbWEn3BVFUKkzxvnS4vnr6BENW1V01uMpSMoepkH8dRjft6ZeFafqZAFq18DvdVABSN1Qzn3Xg8g2ZmpxtbrdQbt1WAAlTEqJauE99VHb5Gs1ttvs2Q5XmxjbvNnAglpGOBLaGpkrrhHyngrYTifTJfCyLfoblxLn+yxbVnS37Hu8N6gZM/VvpeM8kG6AR1
 X5iXpbMg
 3M8KyVAJc8wTB+qFTRS11N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in affs with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/affs/amigaffs.c |  8 ++++----
 fs/affs/bitmap.c   |  2 +-
 fs/affs/dir.c      |  2 +-
 fs/affs/file.c     | 20 ++++++++++----------
 fs/affs/inode.c    | 12 ++++++------
 fs/affs/namei.c    | 14 +++++++-------
 fs/affs/symlink.c  |  2 +-
 7 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index 0e1939cf27bba0c10d2b657b94f3cd5dbee1a61c..b401aacaa06744130eb191daf334bdf979fdc0a6 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -33,7 +33,7 @@ affs_insert_hash(struct inode *dir, struct buffer_head *bh)
 	ino = bh->b_blocknr;
 	offset = affs_hash_name(sb, AFFS_TAIL(sb, bh)->name + 1, AFFS_TAIL(sb, bh)->name[0]);
 
-	pr_debug("%s(dir=%" PRIino "u, ino=%d)\n", __func__, dir->i_ino, ino);
+	pr_debug("%s(dir=%llu, ino=%d)\n", __func__, dir->i_ino, ino);
 
 	dir_bh = affs_bread(sb, dir->i_ino);
 	if (!dir_bh)
@@ -83,7 +83,7 @@ affs_remove_hash(struct inode *dir, struct buffer_head *rem_bh)
 	sb = dir->i_sb;
 	rem_ino = rem_bh->b_blocknr;
 	offset = affs_hash_name(sb, AFFS_TAIL(sb, rem_bh)->name+1, AFFS_TAIL(sb, rem_bh)->name[0]);
-	pr_debug("%s(dir=%" PRIino "u, ino=%d, hashval=%d)\n", __func__, dir->i_ino,
+	pr_debug("%s(dir=%llu, ino=%d, hashval=%d)\n", __func__, dir->i_ino,
 		 rem_ino, offset);
 
 	bh = affs_bread(sb, dir->i_ino);
@@ -147,7 +147,7 @@ affs_remove_link(struct dentry *dentry)
 	u32 link_ino, ino;
 	int retval;
 
-	pr_debug("%s(key=%" PRIino "u)\n", __func__, inode->i_ino);
+	pr_debug("%s(key=%llu)\n", __func__, inode->i_ino);
 	retval = -EIO;
 	bh = affs_bread(sb, inode->i_ino);
 	if (!bh)
@@ -279,7 +279,7 @@ affs_remove_header(struct dentry *dentry)
 	if (!inode)
 		goto done;
 
-	pr_debug("%s(key=%" PRIino "u)\n", __func__, inode->i_ino);
+	pr_debug("%s(key=%llu)\n", __func__, inode->i_ino);
 	retval = -EIO;
 	bh = affs_bread(sb, (u32)(long)dentry->d_fsdata);
 	if (!bh)
diff --git a/fs/affs/bitmap.c b/fs/affs/bitmap.c
index 904cd5bc5a4bd5719017bf1820a053557c35d67c..40bc4ce6af4ac9d8dba81809e22516a58f0aaf15 100644
--- a/fs/affs/bitmap.c
+++ b/fs/affs/bitmap.c
@@ -125,7 +125,7 @@ affs_alloc_block(struct inode *inode, u32 goal)
 	sb = inode->i_sb;
 	sbi = AFFS_SB(sb);
 
-	pr_debug("balloc(inode=%" PRIino "u,goal=%u): ", inode->i_ino, goal);
+	pr_debug("balloc(inode=%llu,goal=%u): ", inode->i_ino, goal);
 
 	if (AFFS_I(inode)->i_pa_cnt) {
 		pr_debug("%d\n", AFFS_I(inode)->i_lastalloc+1);
diff --git a/fs/affs/dir.c b/fs/affs/dir.c
index 127741d9cac940a45a832bf78b36296dec77cd40..11e2bac2e391896a32109335530a6af5543a0abe 100644
--- a/fs/affs/dir.c
+++ b/fs/affs/dir.c
@@ -90,7 +90,7 @@ affs_readdir(struct file *file, struct dir_context *ctx)
 	u32			 ino;
 	int			 error = 0;
 
-	pr_debug("%s(ino=%" PRIino "u,f_pos=%llx)\n", __func__, inode->i_ino, ctx->pos);
+	pr_debug("%s(ino=%llu,f_pos=%llx)\n", __func__, inode->i_ino, ctx->pos);
 
 	if (ctx->pos < 2) {
 		data->ino = 0;
diff --git a/fs/affs/file.c b/fs/affs/file.c
index e2129cc3411f1cc6cf8bf29fe6740e619554e420..a51dee9d7d7ec3724c642725812415bd33c76273 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -24,7 +24,7 @@ static struct buffer_head *affs_get_extblock_slow(struct inode *inode, u32 ext);
 static int
 affs_file_open(struct inode *inode, struct file *filp)
 {
-	pr_debug("open(%" PRIino "u,%d)\n",
+	pr_debug("open(%llu,%d)\n",
 		 inode->i_ino, atomic_read(&AFFS_I(inode)->i_opencnt));
 	atomic_inc(&AFFS_I(inode)->i_opencnt);
 	return 0;
@@ -33,7 +33,7 @@ affs_file_open(struct inode *inode, struct file *filp)
 static int
 affs_file_release(struct inode *inode, struct file *filp)
 {
-	pr_debug("release(%" PRIino "u, %d)\n",
+	pr_debug("release(%llu, %d)\n",
 		 inode->i_ino, atomic_read(&AFFS_I(inode)->i_opencnt));
 
 	if (atomic_dec_and_test(&AFFS_I(inode)->i_opencnt)) {
@@ -301,7 +301,7 @@ affs_get_block(struct inode *inode, sector_t block, struct buffer_head *bh_resul
 	struct buffer_head	*ext_bh;
 	u32			 ext;
 
-	pr_debug("%s(%" PRIino "u, %llu)\n", __func__, inode->i_ino,
+	pr_debug("%s(%llu, %llu)\n", __func__, inode->i_ino,
 		 (unsigned long long)block);
 
 	BUG_ON(block > (sector_t)0x7fffffffUL);
@@ -534,7 +534,7 @@ static int affs_do_read_folio_ofs(struct folio *folio, size_t to, int create)
 	size_t bidx, boff, bsize;
 	u32 tmp;
 
-	pr_debug("%s(%" PRIino "u, %ld, 0, %zu)\n", __func__, inode->i_ino,
+	pr_debug("%s(%llu, %ld, 0, %zu)\n", __func__, inode->i_ino,
 		 folio->index, to);
 	BUG_ON(to > folio_size(folio));
 	bsize = AFFS_SB(sb)->s_data_blksize;
@@ -566,7 +566,7 @@ affs_extent_file_ofs(struct inode *inode, u32 newsize)
 	u32 size, bsize;
 	u32 tmp;
 
-	pr_debug("%s(%" PRIino "u, %d)\n", __func__, inode->i_ino, newsize);
+	pr_debug("%s(%llu, %d)\n", __func__, inode->i_ino, newsize);
 	bsize = AFFS_SB(sb)->s_data_blksize;
 	bh = NULL;
 	size = AFFS_I(inode)->mmu_private;
@@ -634,7 +634,7 @@ static int affs_read_folio_ofs(struct file *file, struct folio *folio)
 	size_t to;
 	int err;
 
-	pr_debug("%s(%" PRIino "u, %ld)\n", __func__, inode->i_ino, folio->index);
+	pr_debug("%s(%llu, %ld)\n", __func__, inode->i_ino, folio->index);
 	to = folio_size(folio);
 	if (folio_pos(folio) + to > inode->i_size) {
 		to = inode->i_size - folio_pos(folio);
@@ -658,7 +658,7 @@ static int affs_write_begin_ofs(const struct kiocb *iocb,
 	pgoff_t index;
 	int err = 0;
 
-	pr_debug("%s(%" PRIino "u, %llu, %llu)\n", __func__, inode->i_ino, pos,
+	pr_debug("%s(%llu, %llu, %llu)\n", __func__, inode->i_ino, pos,
 		 pos + len);
 	if (pos > AFFS_I(inode)->mmu_private) {
 		/* XXX: this probably leaves a too-big i_size in case of
@@ -710,7 +710,7 @@ static int affs_write_end_ofs(const struct kiocb *iocb,
 	 * due to write_begin.
 	 */
 
-	pr_debug("%s(%" PRIino "u, %llu, %llu)\n", __func__, inode->i_ino, pos,
+	pr_debug("%s(%llu, %llu, %llu)\n", __func__, inode->i_ino, pos,
 		 pos + len);
 	bsize = AFFS_SB(sb)->s_data_blksize;
 	data = folio_address(folio);
@@ -854,7 +854,7 @@ affs_free_prealloc(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 
-	pr_debug("free_prealloc(ino=%" PRIino "u)\n", inode->i_ino);
+	pr_debug("free_prealloc(ino=%llu)\n", inode->i_ino);
 
 	while (AFFS_I(inode)->i_pa_cnt) {
 		AFFS_I(inode)->i_pa_cnt--;
@@ -874,7 +874,7 @@ affs_truncate(struct inode *inode)
 	struct buffer_head *ext_bh;
 	int i;
 
-	pr_debug("truncate(inode=%" PRIino "u, oldsize=%llu, newsize=%llu)\n",
+	pr_debug("truncate(inode=%llu, oldsize=%llu, newsize=%llu)\n",
 		 inode->i_ino, AFFS_I(inode)->mmu_private, inode->i_size);
 
 	last_blk = 0;
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 14f6a6352662ba9514a64ea0893e848e79abed63..561fc0185e89c47947c83bd1a56cdc8be46f8d0e 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -32,7 +32,7 @@ struct inode *affs_iget(struct super_block *sb, unsigned long ino)
 	if (!(inode_state_read_once(inode) & I_NEW))
 		return inode;
 
-	pr_debug("affs_iget(%" PRIino "u)\n", inode->i_ino);
+	pr_debug("affs_iget(%llu)\n", inode->i_ino);
 
 	block = inode->i_ino;
 	bh = affs_bread(sb, block);
@@ -171,14 +171,14 @@ affs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	uid_t			 uid;
 	gid_t			 gid;
 
-	pr_debug("write_inode(%" PRIino "u)\n", inode->i_ino);
+	pr_debug("write_inode(%llu)\n", inode->i_ino);
 
 	if (!inode->i_nlink)
 		// possibly free block
 		return 0;
 	bh = affs_bread(sb, inode->i_ino);
 	if (!bh) {
-		affs_error(sb, "write_inode", "Cannot read block %" PRIino "u", inode->i_ino);
+		affs_error(sb, "write_inode", "Cannot read block %llu", inode->i_ino);
 		return -EIO;
 	}
 	tail = AFFS_TAIL(sb, bh);
@@ -219,7 +219,7 @@ affs_notify_change(struct mnt_idmap *idmap, struct dentry *dentry,
 	struct inode *inode = d_inode(dentry);
 	int error;
 
-	pr_debug("notify_change(%" PRIino "u,0x%x)\n", inode->i_ino, attr->ia_valid);
+	pr_debug("notify_change(%llu,0x%x)\n", inode->i_ino, attr->ia_valid);
 
 	error = setattr_prepare(&nop_mnt_idmap, dentry, attr);
 	if (error)
@@ -260,7 +260,7 @@ void
 affs_evict_inode(struct inode *inode)
 {
 	unsigned long cache_page;
-	pr_debug("evict_inode(ino=%" PRIino "u, nlink=%u)\n",
+	pr_debug("evict_inode(ino=%llu, nlink=%u)\n",
 		 inode->i_ino, inode->i_nlink);
 	truncate_inode_pages_final(&inode->i_data);
 
@@ -353,7 +353,7 @@ affs_add_entry(struct inode *dir, struct inode *inode, struct dentry *dentry, s3
 	u32 block = 0;
 	int retval;
 
-	pr_debug("%s(dir=%" PRIino "u, inode=%" PRIino "u, \"%pd\", type=%d)\n", __func__,
+	pr_debug("%s(dir=%llu, inode=%llu, \"%pd\", type=%d)\n", __func__,
 		 dir->i_ino, inode->i_ino, dentry, type);
 
 	retval = -EIO;
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index 725a005a0aec9d4727b6bf561333b236844ae7ec..8705321926007f559bac1af42fbadca8da67afcc 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -235,7 +235,7 @@ affs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 int
 affs_unlink(struct inode *dir, struct dentry *dentry)
 {
-	pr_debug("%s(dir=%" PRIino "u, %" PRIino "u \"%pd\")\n", __func__, dir->i_ino,
+	pr_debug("%s(dir=%llu, %llu \"%pd\")\n", __func__, dir->i_ino,
 		 d_inode(dentry)->i_ino, dentry);
 
 	return affs_remove_header(dentry);
@@ -249,7 +249,7 @@ affs_create(struct mnt_idmap *idmap, struct inode *dir,
 	struct inode	*inode;
 	int		 error;
 
-	pr_debug("%s(%" PRIino "u,\"%pd\",0%ho)\n",
+	pr_debug("%s(%llu,\"%pd\",0%ho)\n",
 		 __func__, dir->i_ino, dentry, mode);
 
 	inode = affs_new_inode(dir);
@@ -280,7 +280,7 @@ affs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	struct inode		*inode;
 	int			 error;
 
-	pr_debug("%s(%" PRIino "u,\"%pd\",0%ho)\n",
+	pr_debug("%s(%llu,\"%pd\",0%ho)\n",
 		 __func__, dir->i_ino, dentry, mode);
 
 	inode = affs_new_inode(dir);
@@ -306,7 +306,7 @@ affs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 int
 affs_rmdir(struct inode *dir, struct dentry *dentry)
 {
-	pr_debug("%s(dir=%" PRIino "u, %" PRIino "u \"%pd\")\n", __func__, dir->i_ino,
+	pr_debug("%s(dir=%llu, %llu \"%pd\")\n", __func__, dir->i_ino,
 		 d_inode(dentry)->i_ino, dentry);
 
 	return affs_remove_header(dentry);
@@ -323,7 +323,7 @@ affs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	int			 i, maxlen, error;
 	char			 c, lc;
 
-	pr_debug("%s(%" PRIino "u,\"%pd\" -> \"%s\")\n",
+	pr_debug("%s(%llu,\"%pd\" -> \"%s\")\n",
 		 __func__, dir->i_ino, dentry, symname);
 
 	maxlen = AFFS_SB(sb)->s_hashsize * sizeof(u32) - 1;
@@ -395,7 +395,7 @@ affs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = d_inode(old_dentry);
 
-	pr_debug("%s(%" PRIino "u, %" PRIino "u, \"%pd\")\n", __func__, inode->i_ino, dir->i_ino,
+	pr_debug("%s(%llu, %llu, \"%pd\")\n", __func__, inode->i_ino, dir->i_ino,
 		 dentry);
 
 	return affs_add_entry(dir, inode, dentry, ST_LINKFILE);
@@ -511,7 +511,7 @@ int affs_rename2(struct mnt_idmap *idmap, struct inode *old_dir,
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
 		return -EINVAL;
 
-	pr_debug("%s(old=%" PRIino "u,\"%pd\" to new=%" PRIino "u,\"%pd\")\n", __func__,
+	pr_debug("%s(old=%llu,\"%pd\" to new=%llu,\"%pd\")\n", __func__,
 		 old_dir->i_ino, old_dentry, new_dir->i_ino, new_dentry);
 
 	if (flags & RENAME_EXCHANGE)
diff --git a/fs/affs/symlink.c b/fs/affs/symlink.c
index 05ec904089fb8287545ccc8128ba4057175576cf..de31ed2e71dfcb71b770a98c9b43a248de8d7041 100644
--- a/fs/affs/symlink.c
+++ b/fs/affs/symlink.c
@@ -21,7 +21,7 @@ static int affs_symlink_read_folio(struct file *file, struct folio *folio)
 	char			 c;
 	char			 lc;
 
-	pr_debug("get_link(ino=%" PRIino "u)\n", inode->i_ino);
+	pr_debug("get_link(ino=%llu)\n", inode->i_ino);
 
 	bh = affs_bread(inode->i_sb, inode->i_ino);
 	if (!bh)

-- 
2.53.0


