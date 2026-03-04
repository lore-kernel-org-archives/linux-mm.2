Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C23FEF8FF8
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 125286B0095; Wed,  4 Mar 2026 10:34:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D9C56B0096; Wed,  4 Mar 2026 10:34:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC5E36B0098; Wed,  4 Mar 2026 10:33:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D38176B0095
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:33:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 726925970C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:33:59 +0000 (UTC)
X-FDA: 84508776198.20.D48AD17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id A3A412000B
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:33:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pc+rklIw;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772638437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CmCR+aTC+ApLtLTrGnL2o4W1Y70BRUbXY+2WYvZ8DTU=;
	b=Ti2iMfY7sshX10lkZobxWJiQ5U2wmwgRvCrgUIoCGVBaC/F0U1d1iz2uDruW22bLlkQUIs
	jemZlxd1KGEJzMqu1NGeQWpA2bGQj2xkj4OE6xubU/o9008tj+eB51JiZEtA2clJEa/oIv
	iyAmJV1KVlM8CZ1ZftVk7ctpqL8t0wA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772638437; a=rsa-sha256;
	cv=none;
	b=i4EhPpI+AbhQUzqPHwbaZ5NywOzINQrNr+Z/H0Ufp2mpv4gI68a9jFRycCtgSVdYfjm79c
	WIGzATNaW8I1Uik04JBHi1qEY02CXMcNCRQe+v2emKoM8Ux5HaBaFpXhkL4FGU/Bs4f66r
	I+rVK7CmMwB4g4OlLgu/QsvtprXNNQ8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pc+rklIw;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DF36761331;
	Wed,  4 Mar 2026 15:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F12C4CEF7;
	Wed,  4 Mar 2026 15:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772638436;
	bh=kEgu+NRsIvJuO6axeYg1fU8tfgBbCZAh29JefkiHmoY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Pc+rklIwBOY54SdWrXhtUjcM7M7AZU+bdLhSTv1gUxEmIbg3/45301R+FRl6XEHix
	 wCp+UkLxAynzjLf8VtiKKeckW/d7q1gRFnOy1fx5S8bTNMChxNdoK8ohZknf8r0J5l
	 p0RSPwiOp16mGHWYr/oPZE06PyQcjT1Qckw27VoJroxO4R6ggzr40PAz2bEuECnt75
	 gxbj2RuOsu8yHWf62bkawC43GAc1V02QbFlxU6+nW/sdflyEXMPBPvHnxsl1ivRFF+
	 uq44dtS3UWr7x32pVoktsKtmKSen+odmqCgDvr2ca6sAeioDjycW3IsUP3VdxhPST2
	 tNYQAKrnvkriQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 04 Mar 2026 10:32:33 -0500
Subject: [PATCH v3 03/12] net: change sock.sk_ino and sock_i_ino() to u64
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260304-iino-u64-v3-3-2257ad83d372@kernel.org>
References: <20260304-iino-u64-v3-0-2257ad83d372@kernel.org>
In-Reply-To: <20260304-iino-u64-v3-0-2257ad83d372@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Dan Williams <dan.j.williams@intel.com>, Eric Biggers <ebiggers@kernel.org>, 
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=15151; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=kEgu+NRsIvJuO6axeYg1fU8tfgBbCZAh29JefkiHmoY=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpqFCnZ23t0HTRpNQES9NjX+UuD9Obj468mqK2i
 /Z4V3WfQSSJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaahQpwAKCRAADmhBGVaC
 FWoMD/wM5CAcCBfCegteeyIHIH7BrJYebMQMazET6b11Ft3OvSdM6qDJdNWJqIelP7KXsKEpzc2
 dRH6guGn7JLZZEo1hG93IAyqv1GmKcgdOS9S0Om9JJl+aOH/3xVRw+kfFTMXiOOHBw+z5GoAzdl
 TMbOmu2xtw20kRyZujNrVWGVqagr2vKRr5PVfOw9PcSRXoZgP9lXq66LlLZI5kNbScMox1WlaMV
 M8R39iigdvBQH6Qx8TdCqokUhHNOGsDSe4X/+DGWOK+IF0Bd8e/SbnYjWYpObd7qQvVcwLrTQI9
 9Cm+WpL+R6amYriATwAaTrTHm9QmcC2eZWJdiCEBH4IJ1BKgH/n2Vmr4n07ZPEoaitvL2XT2TPX
 Vxgf0erGmTi6mYa5FL0b/891ce3/UE1CVjQL1RVxNYfQPjnLyhjFOug7b+bD1yqmlTlyLtiUPxl
 m4/LfPZ5P68sNBJcMN+n8FacbaW1pEumpiHa3vtzVw9Aj25mpHlhsLmAV+ixpg8xeZgYLRYSkTy
 eQHrbSdp3AZphaN2UPWadoIE95UvCs5qYuF0NifDn3wMGQPZm+hcGW4Wx+FCLr54+sBKvs95xYk
 4RjGxEdDECWqZAZUnJHbiVACglxtMovAS6TsTK3aogPS0QeMntof6SM94A8BoQ4PUmLB2BXxOFR
 Ar+3MPW4sRbugqQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: rpisumx6edygs4hakwcom3ftdjh971xz
X-Rspam-User: 
X-Rspamd-Queue-Id: A3A412000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1772638437-491626
X-HE-Meta: U2FsdGVkX19hrqAZf+TrB2FgIxIiyZBrv3Sg5YQ5RLnVNtCAInYznHRnyg075ZDIiKjliJRjpVQJSKlIXjuofipu5LPV/nGYAfHyVXLOVIZKJ2Y0a5LnmBIwkNCFpZMBJHjiguWjNVQ0McBISrWJgDqnFqiEl6FY1P0v9o8vNtHehPJNz804xo+vgtBKOv05BvTrGkWVxcQppkJ3F4arGBVy+q9mRE581qrP8rGmA2Bevrx3jPAGK3zwcTwr3ZVQiac/lTWqVtexVRjaCx6NF1jues9hd+HMcYvMfIgPSyLZNpsYuHsGseT4caEG2GXomPnCJwKtIunVU8xWhw5pD9+H0wrgUXhpvBs14IqIOodbPoifvX+dg1V5MSdG4PhhoW03NvTlFMWz8Gwk4EQB24kgi9DVcq6/xloPIJnwDDjRR2cCRlDAnYhSEWlowJY73lv1h2GMP0ObVKWtxCvlMfqKMZyu5g492Q5Z0aLsM3fYf88cJgQnkKnwHiuHzCrxsrVilVsGmwVSo3YFIbQJXTWtgOn2Nv+bZ1mdEQcUPqd+wloUalLiHU49olQITEtl+3x1Ii0ctosXfEgr94MxZyhpKGAJ2PCg7I3W5wpX+mNBMkFjWz0SjJ5grAWWbMj23dq6MTgbZPWO0K6NOYIoMj1iqOoajziRzFIOW4cweb2IzwHghOL2/CEtQ0hDMGsIwt4Epa0PU7pZWp6Dd8nnHxrkyW0cczWPRwYycNTH0stOFrlG5f2Q7zJ01xKGjaJmth85axfwxC4HSoUARNpqQ4khV3iitnE8hNv+193JgwfmXpxfbSaFWbxDHDjoQUo7tj+M8kPZe7cY18RzPgNLhA7N3t7RgMtzJbtHnvm7Q23M4Q+4uivo+GrLjxhmslFu38+kLLiSJHmVshenC++mMaiOMybrYZyDu4t84QNcTXK9lWvYMS9+K5aorjNjCV8YSr/a9rzLVMfpx3tswsf
 ABsiVedf
 z7wUJAXNx/q8FsI1WgjnwG3/Zc7YfceeT5xpfr2dKv0LFxgk05japhIdSTaG20X98xJJf6HOLByQm5VoM5l8YRKBvr7w0rGZL29QKIrFyATvK1zaukWko/GrTksxmz7EQe2mq0Yb4+o0oFMWX9jvzAYwSXR27j+4U1l/r1UMfYSszFGvYQ6AxY8JwESbaNtOUBB/YJoKWDov91dYQ7ONK1VlBVhTuZAISeEiHa8weI5t3RTsWW1xre2/deEvJxFfRWa+NcoxOEjJf25+X14wGD57a0EK/w/KFXP4169BUQCnVKIqVvglCy+UMyzpq1jDtBJCeC9CH345aH4OOL9+tjs4qactmRIHpSB+SREnIDoCAW2KGt7i7SpGHrYnKB6JRcXfm+wSFKdMAR2EAXPnnTPd1ComBp/R2Pupb0IKKwpWNUmAW3WPy+TPs9dv4M2wTTAZtvkSITUtzzk0uavKpjq/k/IOgRwk4WJRlRJLHAxi+SGd2+MXZ9Ft9Li9BEyBeSlqhzsiK+h1+K9L8KMVwwVFaeY6142QKx/qhdz94SBqC4QjK9rJIreJG27lROHM0f6IojYjJWjKLcBwP7/A1wE6UagYnYndsDNZkLd2+xq8BnMD/K1JW+NEhN4j7xv4VkNcVlbL7IxdSr1q8pZPGgcP4iePkAelY5i10IufFb8Gt7ZbrDIk022GyZJVQqOLZJAClPKONn1lzDqsM2Ju+21p1Z0BN2Uv44CfaT/mSIPXnO0E8H4WcNR8LH1acGDQ/JU8eVckpgNZBnqy0txYDjgwOItR2HKsJ2iM6w70y2waM1lgNqBzUdhtu6Sqzpk8L0SGAYEh2Elt5+sCFnAZNRNvGP3UnEFM12nPRGnp4mq+cf7k4C/Xm32gCgECczaYEC+pn4WECFlvbx4bQjMSDBw1aAhS1s+oDYpEP5KLiZBo5uTIGEMUJUnP2ubfxKD2oKo9Z/Qe0xY4tRjxmYSuSK2pNGxs5
 H94fhRXp
 rnRQyGqviGSd5sm9sW2sdS5l2rMrcJksrpSMu+PwT1ii5u1rTYpIqCjnpiY2YrCXH6THslYCSKOV7h5VcIP2SsYnsy3K7zX9XSD6v6q3so9zB/FKLA4CC65RJ4JfdWMSLuYWI98+EFx9O9n6kXe6AEHlC02c3lTTe2auE7s+5WT9M+W7F/Ue0yNrP+xPjEsMmo5E9Lr/jt+Bp17ksRfPgDOkdtQR99lL9eL+0XN+s2kDAjAaFwrFjo9wC58kSDFGbSI2sswNqwWGgMmfpqHeAk4qmlvgv54qrwli3ddQ3ey0cIuTXoFBRp9JrIwyu/r3Ky9bwhgg3/sy6Ps8w3X78xDZL9iuKtY4xf24ZS7gTU6HGtIjEt/iFLrL6r02gobhNMBEdIa3VupGtfsxnSsugNRhqFtoRTE7Ka/kJVoSy/8Ku0F0NaFjoe9JZ+fkrDU9/p8lWz8Uy2lSiJfXLz80U4zRjcEhU06qYT0Isj6gyvbe0IEeW0iyx3YDzMozWudj/WWFD73jXN506YLZiUYCcuQSrgujPYGqdPqk3CXjfIZFz8Ie+v8kESitLjyywva0Hzwud814uso5/G8+dSg0mkUGDrGyL4fDyzayuPMyJSYbR/YvnthGgUS9/t0y2x5F10J5KZOJB6QKFYrAWPWN4aPtZsYYUupvqvrLVQQ5dVAs00oaFGTMsw+/+xI+Fnh2APDpgma41M1vVn0OKMQ06fL3VBowi7z8FebOi4YTwoM5KKLicuc+D0r3OOAfVnO2G8T24gh21lFHNBm1j9/47Wa5hcejvAqmKB+JeL0hDPSepWZlx/iSNIqWj3XphtbgFMNFYX/rukmEDqmsFB3P5EvhPkBWz1KIJWF0PSLQnZT4qg6P+7BFGiFCZWto4Ryx8iY1vKvCDuDsWCskAPJmyJpn7TqQymthq90yPr5wPkNwtZSMiktfM+O2vixyEBGTI7ypIgC9oc7u1fApcdJMXRoKh7HDV
 i+qQ4bVh
 3YZXkO2lEMuytgYc0UmQ4elUKKR85F9wSfBXY/w81Gh2n5mSjFDh1dysHEUiHLImqyuMUSVwl5uvPEQQqjuEi8uGUksya8xIwKBOms8qQvTDiQrjUN2NTH72G7J1b8/oRgP4S0Uc+B++eWotnuseWLeX7xDEYUTDvB7M4I5itkO3qEO9RztxR5IEUUIZmlYxjkw71tJaEnOgv14cuBAy33gUnaiahfoe2mlJlGWnu8yG/IWDsmDw/smnqX3uwjcCGhQPOIaOdSSMxHQZyOJrDEUtD/YAM+hgV4HslKQ99Wj6kzBwkK6W/W5WVkHUNu4O+kFns6Ptn8JJbvX25LKBJQPOI0Ki1csngoypLS7c8iFiMFxUX7EorTmqOC9/XPUkqN0hZ0u9In8QGGugYpNmQansQ2fQ3e2zY3wi643kC/YIVWqrHykh1vSPA9jITnhhimPU8W3MYimmH3RGYsJBdD9aE9W0Ny+QdNkdA03myqt6DHhygR8s+U+aEts8EPen4mcZXJpL+cHG1rE9L638ee2hai94TgUCBUpmsg2gv7ioQ6Kimqhouj2oAmvbuxdjG8+r5VU2X06jg1abpHKDoOW7mjGLJMM/DV2XJBte9V/rM6zALJlM4YzT2dkjD/Gijbl81YTJ/ahEj80D3jLyn/0YkixAVrdgnZzF49Vynv6USXVEbrwDTUduebu2b6RMohcqmxKLqPljOwNrEPdnZm0EdwHnaT07WU+XBUscrpzfvRyI9HIlaRDqr9ZZwjV0pcF0I6eHlVo6pere6qmUqY2e95K1hnRnB+MDjWySzQFAA91I5nb7AKVyRNEHoUrO4QTwc0QvxM6OM3BiRx9l2vSYj2ciEQF8o67zHtbW5wdAdFeVy3yXQopmStuxwxbLmE73E3BxDKIKH0xm0G5bd2jB46m3fi9Tk+UMLy/sBohwGklDbuBgpzlMx8GQQvLwX0hCRkQ26e1PZI4VZdEgEn7UlPv2U
 QNKD1dxb
 hn1679oewRbeaDTh6WvG9PUmdqlCaJ56LkxAOEBgxNnIRjXAooTbLoAs2tCj/MyPfQ/ajvnECREmo4czQrDkXibq7WmJeWY35XhRXLa4k0TzLaEe7f1X7+l37sI+CRjxiCa+bhOjldByNZPOJI5LJzm44Ys4WvenFGgTo1JDsGANQIigS2iJWXXyVL4/bD5AWYmdPPbxgHTlwmu4/kYFz086ZSN+T9i3D6DhTYXgtRk3JwFVXuNy1fI+mWJAAFZoYVrluHDWQwq8O7E6JNHUMpcXrCxRNYKBqqFC8aS9L92cAwNIu/JyVkjo9nIMfzU1DqEeZYUOdwYguOYvD0yLE5j5Fk87/dghQjbA2Qfg6pQAZcHo0lFVFlI846IGM88yTDoJm+YMd9jrCf1Tm0xHtdG3UcdX38ULc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

inode->i_ino is being converted to a u64. sock.sk_ino (which caches the
inode number) must also be widened to avoid truncation on 32-bit
architectures where unsigned long is only 32 bits.

Change sk_ino from unsigned long to u64, and update the return type
of sock_i_ino() to match. Fix all format strings that print the
result of sock_i_ino() (%lu -> %llu), and widen the intermediate
variables and function parameters in the diag modules that were
using int to hold the inode number.

Note that the UAPI socket diag structures (inet_diag_msg.idiag_inode,
unix_diag_msg.udiag_ino, etc.) are all __u32 and cannot be changed
without breaking the ABI. The assignments to those fields will
silently truncate, which is the existing behavior.

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de> # for net/can
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/net/sock.h           | 4 ++--
 net/ax25/af_ax25.c           | 2 +-
 net/bluetooth/af_bluetooth.c | 4 ++--
 net/can/bcm.c                | 2 +-
 net/ipv4/ping.c              | 2 +-
 net/ipv4/raw.c               | 2 +-
 net/ipv4/tcp_ipv4.c          | 2 +-
 net/ipv4/udp.c               | 2 +-
 net/ipv6/datagram.c          | 2 +-
 net/ipv6/tcp_ipv6.c          | 2 +-
 net/key/af_key.c             | 2 +-
 net/netlink/af_netlink.c     | 2 +-
 net/netlink/diag.c           | 2 +-
 net/packet/af_packet.c       | 2 +-
 net/packet/diag.c            | 2 +-
 net/phonet/socket.c          | 4 ++--
 net/sctp/proc.c              | 4 ++--
 net/unix/af_unix.c           | 2 +-
 net/unix/diag.c              | 6 +++---
 net/xdp/xsk_diag.c           | 2 +-
 20 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 6c9a83016e9551ed2e2a0d7edf32300b8a4327e7..cfae4fefb8f55d8be6ff5ef401f7b9c601f67cc3 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -537,7 +537,7 @@ struct sock {
 	rwlock_t		sk_callback_lock;
 	u32			sk_ack_backlog;
 	u32			sk_max_ack_backlog;
-	unsigned long		sk_ino;
+	u64			sk_ino;
 	spinlock_t		sk_peer_lock;
 	int			sk_bind_phc;
 	struct pid		*sk_peer_pid;
@@ -2140,7 +2140,7 @@ static inline void sock_graft(struct sock *sk, struct socket *parent)
 	write_unlock_bh(&sk->sk_callback_lock);
 }
 
-static inline unsigned long sock_i_ino(const struct sock *sk)
+static inline u64 sock_i_ino(const struct sock *sk)
 {
 	/* Paired with WRITE_ONCE() in sock_graft() and sock_orphan() */
 	return READ_ONCE(sk->sk_ino);
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index a76f4793aed27657dea22e9e28c1d3cd45087cb2..9d236e64f5f59abe2fd974ffd9d6ef1193db5b52 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1986,7 +1986,7 @@ static int ax25_info_show(struct seq_file *seq, void *v)
 		   ax25->paclen);
 
 	if (ax25->sk != NULL) {
-		seq_printf(seq, " %d %d %lu\n",
+		seq_printf(seq, " %d %d %llu\n",
 			   sk_wmem_alloc_get(ax25->sk),
 			   sk_rmem_alloc_get(ax25->sk),
 			   sock_i_ino(ax25->sk));
diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index 2b94e20772038f1d90228d214f57ab334ca01a50..33d053d634072fee79bb62c003980c203fb30111 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -817,14 +817,14 @@ static int bt_seq_show(struct seq_file *seq, void *v)
 		struct bt_sock *bt = bt_sk(sk);
 
 		seq_printf(seq,
-			   "%pK %-6d %-6u %-6u %-6u %-6lu %-6lu",
+			   "%pK %-6d %-6u %-6u %-6u %-6llu %-6llu",
 			   sk,
 			   refcount_read(&sk->sk_refcnt),
 			   sk_rmem_alloc_get(sk),
 			   sk_wmem_alloc_get(sk),
 			   from_kuid(seq_user_ns(seq), sk_uid(sk)),
 			   sock_i_ino(sk),
-			   bt->parent ? sock_i_ino(bt->parent) : 0LU);
+			   bt->parent ? sock_i_ino(bt->parent) : 0ULL);
 
 		if (l->custom_seq_show) {
 			seq_putc(seq, ' ');
diff --git a/net/can/bcm.c b/net/can/bcm.c
index b7324e9c955b7f03a8f032676bbd89aa8e06bded..30aac2f903d57421d2761153939200813b99e0e9 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1712,7 +1712,7 @@ static int bcm_connect(struct socket *sock, struct sockaddr_unsized *uaddr, int
 #if IS_ENABLED(CONFIG_PROC_FS)
 	if (net->can.bcmproc_dir) {
 		/* unique socket address as filename */
-		sprintf(bo->procname, "%lu", sock_i_ino(sk));
+		sprintf(bo->procname, "%llu", sock_i_ino(sk));
 		bo->bcm_proc_read = proc_create_net_single(bo->procname, 0644,
 						     net->can.bcmproc_dir,
 						     bcm_proc_show, sk);
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 71d5e17719debb14ca2400edcf5a2cc3153291c6..bc4b43e5230336521802403c5c74cfb5da8b05b1 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -1111,7 +1111,7 @@ static void ping_v4_format_sock(struct sock *sp, struct seq_file *f,
 	__u16 srcp = ntohs(inet->inet_sport);
 
 	seq_printf(f, "%5d: %08X:%04X %08X:%04X"
-		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %u",
+		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d %pK %u",
 		bucket, src, srcp, dest, destp, sp->sk_state,
 		sk_wmem_alloc_get(sp),
 		sk_rmem_alloc_get(sp),
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index e20c41206e29d5655f5378f08fb283f2ecbd2097..bcc99ced1ade135701e2df0e32da0da0af2fc487 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -1041,7 +1041,7 @@ static void raw_sock_seq_show(struct seq_file *seq, struct sock *sp, int i)
 	      srcp  = inet->inet_num;
 
 	seq_printf(seq, "%4d: %08X:%04X %08X:%04X"
-		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %u\n",
+		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d %pK %u\n",
 		i, src, srcp, dest, destp, sp->sk_state,
 		sk_wmem_alloc_get(sp),
 		sk_rmem_alloc_get(sp),
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index d53d39be291a5750af3ab2a160b35f0f8a28ff9d..f2ef41583fc195e153ed848afaf3391080696f02 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2889,7 +2889,7 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i)
 				      READ_ONCE(tp->copied_seq), 0);
 
 	seq_printf(f, "%4d: %08X:%04X %08X:%04X %02X %08X:%08X %02X:%08lX "
-			"%08X %5u %8d %lu %d %pK %lu %lu %u %u %d",
+			"%08X %5u %8d %llu %d %pK %lu %lu %u %u %d",
 		i, src, srcp, dest, destp, state,
 		READ_ONCE(tp->write_seq) - tp->snd_una,
 		rx_queue,
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 6c6b68a66dcd3b3d8f1747fead868c195e04a0a9..db58bf786c4a8c73b5d42851bb68bbb22a5e85ab 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -3428,7 +3428,7 @@ static void udp4_format_sock(struct sock *sp, struct seq_file *f,
 	__u16 srcp	  = ntohs(inet->inet_sport);
 
 	seq_printf(f, "%5d: %08X:%04X %08X:%04X"
-		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %u",
+		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d %pK %u",
 		bucket, src, srcp, dest, destp, sp->sk_state,
 		sk_wmem_alloc_get(sp),
 		udp_rqueue_get(sp),
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index c564b68a056268c7cbc81b5f29f60289ea9e09eb..611fddb90c79e94cc7dfcf85b343bcbf630c39d4 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -1055,7 +1055,7 @@ void __ip6_dgram_sock_seq_show(struct seq_file *seq, struct sock *sp,
 	src   = &sp->sk_v6_rcv_saddr;
 	seq_printf(seq,
 		   "%5d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "
-		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %u\n",
+		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d %pK %u\n",
 		   bucket,
 		   src->s6_addr32[0], src->s6_addr32[1],
 		   src->s6_addr32[2], src->s6_addr32[3], srcp,
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index e46a0efae01235ae7430ed268b92cb47309b8d28..379c0935f4030b9b3432e867c357883df3089f74 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2175,7 +2175,7 @@ static void get_tcp6_sock(struct seq_file *seq, struct sock *sp, int i)
 
 	seq_printf(seq,
 		   "%4d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "
-		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %lu %lu %u %u %d\n",
+		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d %pK %lu %lu %u %u %d\n",
 		   i,
 		   src->s6_addr32[0], src->s6_addr32[1],
 		   src->s6_addr32[2], src->s6_addr32[3], srcp,
diff --git a/net/key/af_key.c b/net/key/af_key.c
index 0756bac62f7c042851636badf0a5e961c4e673c1..522308ec934ed055bdce4fa672b4e6a8bb67edc7 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3783,7 +3783,7 @@ static int pfkey_seq_show(struct seq_file *f, void *v)
 	if (v == SEQ_START_TOKEN)
 		seq_printf(f ,"sk       RefCnt Rmem   Wmem   User   Inode\n");
 	else
-		seq_printf(f, "%pK %-6d %-6u %-6u %-6u %-6lu\n",
+		seq_printf(f, "%pK %-6d %-6u %-6u %-6u %-6llu\n",
 			       s,
 			       refcount_read(&s->sk_refcnt),
 			       sk_rmem_alloc_get(s),
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 4d609d5cf40653e04de60f2d28ee26b8bdcdc2ed..aba847902be5ace66e17abf0236a5eeebfee0739 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2700,7 +2700,7 @@ static int netlink_native_seq_show(struct seq_file *seq, void *v)
 		struct sock *s = v;
 		struct netlink_sock *nlk = nlk_sk(s);
 
-		seq_printf(seq, "%pK %-3d %-10u %08x %-8d %-8d %-5d %-8d %-8u %-8lu\n",
+		seq_printf(seq, "%pK %-3d %-10u %08x %-8d %-8d %-5d %-8d %-8u %-8llu\n",
 			   s,
 			   s->sk_protocol,
 			   nlk->portid,
diff --git a/net/netlink/diag.c b/net/netlink/diag.c
index 1dfc340736b832459388304003ff1f5e1e481d23..0b3e021bd0ed29edc094fad2c79c7c067edcdd50 100644
--- a/net/netlink/diag.c
+++ b/net/netlink/diag.c
@@ -43,7 +43,7 @@ static int sk_diag_put_flags(struct sock *sk, struct sk_buff *skb)
 
 static int sk_diag_fill(struct sock *sk, struct sk_buff *skb,
 			struct netlink_diag_req *req,
-			u32 portid, u32 seq, u32 flags, int sk_ino)
+			u32 portid, u32 seq, u32 flags, u64 sk_ino)
 {
 	struct nlmsghdr *nlh;
 	struct netlink_diag_msg *rep;
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 72d0935139f0f5feb00c051143fb47f45fd1f94d..f2af2e0a8530a982d7b95b91ac0388f67b16d46f 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4721,7 +4721,7 @@ static int packet_seq_show(struct seq_file *seq, void *v)
 		const struct packet_sock *po = pkt_sk(s);
 
 		seq_printf(seq,
-			   "%pK %-6d %-4d %04x   %-5d %1d %-6u %-6u %-6lu\n",
+			   "%pK %-6d %-4d %04x   %-5d %1d %-6u %-6u %-6llu\n",
 			   s,
 			   refcount_read(&s->sk_refcnt),
 			   s->sk_type,
diff --git a/net/packet/diag.c b/net/packet/diag.c
index c8f43e0c1925fab8ef6c39de3547dcd6f7389b81..cee773f46571ca51718544227f3425192bb77f24 100644
--- a/net/packet/diag.c
+++ b/net/packet/diag.c
@@ -130,7 +130,7 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb,
 			struct packet_diag_req *req,
 			bool may_report_filterinfo,
 			struct user_namespace *user_ns,
-			u32 portid, u32 seq, u32 flags, int sk_ino)
+			u32 portid, u32 seq, u32 flags, u64 sk_ino)
 {
 	struct nlmsghdr *nlh;
 	struct packet_diag_msg *rp;
diff --git a/net/phonet/socket.c b/net/phonet/socket.c
index 4423d483c630adc93af07e0c23a78800b696d4a4..c4af26357144ebb8016d001244c1fdaf925892fc 100644
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -579,7 +579,7 @@ static int pn_sock_seq_show(struct seq_file *seq, void *v)
 		struct sock *sk = v;
 		struct pn_sock *pn = pn_sk(sk);
 
-		seq_printf(seq, "%2d %04X:%04X:%02X %02X %08X:%08X %5d %lu "
+		seq_printf(seq, "%2d %04X:%04X:%02X %02X %08X:%08X %5d %llu "
 			"%d %pK %u",
 			sk->sk_protocol, pn->sobject, pn->dobject,
 			pn->resource, sk->sk_state,
@@ -754,7 +754,7 @@ static int pn_res_seq_show(struct seq_file *seq, void *v)
 		struct sock *sk = rcu_dereference_protected(*psk,
 					lockdep_is_held(&resource_mutex));
 
-		seq_printf(seq, "%02X %5u %lu",
+		seq_printf(seq, "%02X %5u %llu",
 			   (int) (psk - pnres.sk),
 			   from_kuid_munged(seq_user_ns(seq), sk_uid(sk)),
 			   sock_i_ino(sk));
diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index 1ed281f3c355d559d82e4fa2be10c191f787c85e..43433d7e2acd706ede7b59a51ab6441d1ee1dd12 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -174,7 +174,7 @@ static int sctp_eps_seq_show(struct seq_file *seq, void *v)
 		sk = ep->base.sk;
 		if (!net_eq(sock_net(sk), seq_file_net(seq)))
 			continue;
-		seq_printf(seq, "%8pK %8pK %-3d %-3d %-4d %-5d %5u %5lu ", ep, sk,
+		seq_printf(seq, "%8pK %8pK %-3d %-3d %-4d %-5d %5u %5llu ", ep, sk,
 			   sctp_sk(sk)->type, sk->sk_state, hash,
 			   ep->base.bind_addr.port,
 			   from_kuid_munged(seq_user_ns(seq), sk_uid(sk)),
@@ -261,7 +261,7 @@ static int sctp_assocs_seq_show(struct seq_file *seq, void *v)
 
 	seq_printf(seq,
 		   "%8pK %8pK %-3d %-3d %-2d %-4d "
-		   "%4d %8d %8d %7u %5lu %-5d %5d ",
+		   "%4d %8d %8d %7u %5llu %-5d %5d ",
 		   assoc, sk, sctp_sk(sk)->type, sk->sk_state,
 		   assoc->state, 0,
 		   assoc->assoc_id,
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 3756a93dc63aabc814f7edd31e8c0b6fafa02ce7..a6c5015f3f0a19a930da636ef37eb98b3c40663f 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3537,7 +3537,7 @@ static int unix_seq_show(struct seq_file *seq, void *v)
 		struct unix_sock *u = unix_sk(s);
 		unix_state_lock(s);
 
-		seq_printf(seq, "%pK: %08X %08X %08X %04X %02X %5lu",
+		seq_printf(seq, "%pK: %08X %08X %08X %04X %02X %5llu",
 			s,
 			refcount_read(&s->sk_refcnt),
 			0,
diff --git a/net/unix/diag.c b/net/unix/diag.c
index ca34730261510c2b34dc6661eadaa9d1651e59d2..410f6c8745b7a0e5287b9f7fbc0a71d15cffc850 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -45,7 +45,7 @@ static int sk_diag_dump_vfs(struct sock *sk, struct sk_buff *nlskb)
 static int sk_diag_dump_peer(struct sock *sk, struct sk_buff *nlskb)
 {
 	struct sock *peer;
-	int ino;
+	u64 ino;
 
 	peer = unix_peer_get(sk);
 	if (peer) {
@@ -112,7 +112,7 @@ static int sk_diag_dump_uid(struct sock *sk, struct sk_buff *nlskb,
 
 static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_req *req,
 			struct user_namespace *user_ns,
-			u32 portid, u32 seq, u32 flags, int sk_ino)
+			u32 portid, u32 seq, u32 flags, u64 sk_ino)
 {
 	struct nlmsghdr *nlh;
 	struct unix_diag_msg *rep;
@@ -186,7 +186,7 @@ static int unix_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 		num = 0;
 		spin_lock(&net->unx.table.locks[slot]);
 		sk_for_each(sk, &net->unx.table.buckets[slot]) {
-			int sk_ino;
+			u64 sk_ino;
 
 			if (num < s_num)
 				goto next;
diff --git a/net/xdp/xsk_diag.c b/net/xdp/xsk_diag.c
index 0e0bca031c0399901949982bf430ade6cde286d3..0170363eb542cc1874817f46fd3627857761ab77 100644
--- a/net/xdp/xsk_diag.c
+++ b/net/xdp/xsk_diag.c
@@ -92,7 +92,7 @@ static int xsk_diag_put_stats(const struct xdp_sock *xs, struct sk_buff *nlskb)
 static int xsk_diag_fill(struct sock *sk, struct sk_buff *nlskb,
 			 struct xdp_diag_req *req,
 			 struct user_namespace *user_ns,
-			 u32 portid, u32 seq, u32 flags, int sk_ino)
+			 u32 portid, u32 seq, u32 flags, u64 sk_ino)
 {
 	struct xdp_sock *xs = xdp_sk(sk);
 	struct xdp_diag_msg *msg;

-- 
2.53.0


