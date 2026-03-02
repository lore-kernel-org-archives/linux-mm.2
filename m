Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A6B5EB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:48:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 772416B0146; Mon,  2 Mar 2026 15:48:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 746CB6B0148; Mon,  2 Mar 2026 15:48:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E7FB6B0149; Mon,  2 Mar 2026 15:48:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4CAE76B0146
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:48:02 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 241571A02EB
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:48:02 +0000 (UTC)
X-FDA: 84502310004.25.ECB9414
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4B63F80013
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:48:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nlzXdd2d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4I43so+eOz6MDgvt6KXeiiHjphmLaCw9w8PYzc+JLMk=;
	b=Kbwli2hMy2N0aK41Jj9a3pnSBFk86YbSwP8yzkmnginkEmmY/WY2GO5wbVsKn/5F6tWgpW
	VSLWd/41nzvEBFciTrMMPmri0ZrsRNr1DU4iiWafh8O3ffp/vAhEbmSfxaGtLrOLEzHrV/
	qYmEj+IlXo+wm2KyupPgbC50AxmjYUM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484480; a=rsa-sha256;
	cv=none;
	b=ML/SLZGrCGv0LQ1l8SJkqb8z3IsvkqvtFTzcy1oIjqjpcwpbKsJ3BcD1sJh2OPfPhk5i83
	kivhtJKdGEQdS1IkeUtao7mqGRZUvzxD9s0l+qUW6RVA3Yz4SGvI4v4NpzDvRBk8OdE/CE
	tOPhQCnkxWK022FV6uwpRaysGeCJXNY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nlzXdd2d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ABA346111A;
	Mon,  2 Mar 2026 20:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E051C2BC87;
	Mon,  2 Mar 2026 20:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484479;
	bh=aRx+vBv2M2iRm6msaGNPhasqatamVupEcEqra1pj50U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=nlzXdd2d2jmb6ZCZJlUjsUWRxHX5Ef4p0g3CYJDJ6NRTC9wfC8nnMXQz81G3kHFIf
	 bk3ktV1oHOpMcMQOnvKOeWGTvG6ZnQ/MocHukfvCturZOxU/Bi8OvGApPLNcUd/hK4
	 bhwDnT+CVtxrCw78WPAaFCT09qXHfgAYMWpTDutUEUGqFkMaNaLBVSyEo0cNPh7I3Q
	 h9fZyYNh4rrnUZV+4xi2MJGXnJEhnuj+XvYPzs61Ct4ZpVnyPq3IXEWJt7Ine4BMIk
	 /gTcT4ElgQ2QlP4iB+YuH6gEdPvIx61yjxxZ3x4tL+yQ5hudAkroDrPOeTNPOXK5Wv
	 EYBb/ZIP/1i/A==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:20 -0500
Subject: [PATCH v2 096/110] qnx6: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-96-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=785; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=aRx+vBv2M2iRm6msaGNPhasqatamVupEcEqra1pj50U=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIJiw1odsluet/XL7Mqa4kgajSxQPLdtlQBP
 Cnhi68Zt2uJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyCQAKCRAADmhBGVaC
 FabQEACmwH3xIV1kMlBE8jZgQl7+E4xyQ9Ct8W8zuWbIuWwDYMbjqugxPOEv67u11lXTH29X2dg
 T+teVLNpE9KEA+QSZStGPzfwjKkV2dmFsTfKy60GPnda3f/FkiCLwnnd5OPZ80Q+3AnEBxZHH6f
 wAWAjTFt9+1olQE+oiRr2tCPwDyirwOWOhhzxpvJoDphHy9s/VnilrBBjEMj6H2mLI7JbcMEroZ
 awVclVwRnT+oYmRgjWvjJf6E5h9jseIrrvPZz0RDJyl0oW9Bgd1rd0fJ/aaA8iaijQhkqrz53M2
 wfSxfIEH8oZCg2cxuxhf09hMyZoEB7LosomyOY/lHkHSRNeaXoKS/vu++fmfG4Zetr0mv2qRTP5
 X/CZConNXt4BZWWp5ZTPBSrRraBWY2RnP8jO0mp3Ju+6PBk2uvnbjniN7GNlDPpdLvINPUYoyX3
 tIl+GoSDldlirpwTmIkMxsPtzVi1aNgq5PflX3rr3L35rBTC/Ag2NHL82QBb0bpG5hUB/wEDzAf
 BQ/2pzx8lCQp1KW0rqYQ3+NZ9O5fVnj13wHOKy1FiOOK94ifA+A9WKPPTy/wVGIsarmfnH9D5Zl
 KYc8wQvQe0PIpa6fpTWJxlUHZ617zXMAkBSZldBDPIZrtfWQm65IggBJCjJnu6Y9BueSk6yfJlT
 fi7dwf/3MTPla3g==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4B63F80013
X-Stat-Signature: qpksxb4sg81pg78ga98cffsxyez98yfr
X-Rspam-User: 
X-HE-Tag: 1772484480-427130
X-HE-Meta: U2FsdGVkX19pqVy7oD1OSbPpge4mVThrucCnROxqo1CcW3MyGoSmvSlPE6usJNNg71ysDM/7zFOB82pB5kYiCG53hJsl6t6v6WvoH4KYT5v8kCibOw4jFomIQtL2wOuSNeXNK5jchO3zq8FBXFKhwSdkTzt2glNozr2OOZheJXhVAz+LJVXELu931hlQmGgU/sb0/r83B1IkARdz+nmtl0ySLSSktJj0Vch6BtEHLaGJJxABGWLuPOsqacA9gwc066ybX9QzaacEpvblqSctN1xVccOYE+V4aCzK+bYr090Mab/VympccFwrNomEOnGlf/CNZwHmp91RzQOs4+1ID/Jjem5ekmnhTFbIeBcEkcJOK+KTScx/izOneX15rtmAhv0LWgJNRLDO2qE3bV4YTgpsWwplqLmdJCtq7DgUSl9VZGZAVbQX5znMQqBgEaS1wKbCgct7LNSYg+JLYD5ae3SI/Izr7VPx0qmw9G4ayOqq0+3+u+KEu5QbNCYIOOMNhDiN5J7EpFGeG/4vtBREYyVgEMFwaUzFuepXP6GxKeIk7bNbinNz5C+JLY3X5zN9yDmTe6XXp4xph7Ckk68FyWOhmGT2oW747/pdb9HzX0yXkBbdOfq3C3GRUvG7ShhZqd5+5iM0FzOLxwP8nNkQeifBv4PIsIgqWK1BCf7+7M8+sPeeGr+aP6aY2Y8FoHuKi+hQzWWcwBDej7Sso4chBMD+SDwGP9kJmXen8FzjsZQ/aNCKVN6EsS9r9T/+LFNT3gtOkHEWKnjooJyYvM0PnaahLhCxR//pcuKR60izjUvxZohIQvI9Srdj6mgCHr4vpx5hrV0fwtWzAtpl1tU+RF/XA6Kmq7CPtvJM4yhX42AUYO8QdsVWVhmzBWYUlhFmiRrHcQIbMURM9j78ouQTNoxtUHQ91NBuF5uJ8X4AQ/kpanUD0fm2xOZVCePe+NGaW76q2T7FgiBMFPxwtY/
 WhEXG8EI
 kelqFV6INLifYC4qhp5sTuf6Sn+z75UQ6BraY1Ba2RiWpgCbXgLatn8zenMDSvKCY8/hwQk+L3M03I8OLxk5T7OEpdjBoBwRDBcQGxRkRP+kSUzxc4w4wn+XPN0EoA05vTvKrJwhKCl8eNO0YiJax6kQyWoTsXGWDkFSxe3XsDUOjDsESTC3bPZvBVbiQgx89DKnFB3WL7JpmdQtoadwPQKkEdgUJ9OI88YjYrEf+Z8PfwDu/JdXJe1fNx/EugguWZ7wb8MXD8lg9OUtRGWoncEns1KxcMqPIBvopHJodLyXP314S9OUBQZYeO6kyanHK0h22kP8CezBY7RksXxyZhQV1OQX1nHSdl9yD9VA65pV175LJQrGlMulrZ9iwJFwTT8GP78lNoNjnuONI7F/7rLJJKBG2z6NB/KCTshqXJNgRJYW8CjzuStd5zReOCAAKMiemR26Sx77LB70O8R3hVaTR/Tl3XV0VnUNa4Pm76KYMkYQcL/pQfqQ+mh9PhMDwg6n91nzHUcM8gIMkodgZd9PG9q6BDYf3GFVNnBDGoPOm6F62VkTYp5ab1kdMSiDdoFK2cA4HQxDofs2UDvXAO08enRwiiGbitT3MHFOYXxMYiSwI/Feb2zudncKitHfB4B/hd8O4e46qzhj+/6Lq7UIZC2rhxoq966ec4svMoX2mPhALcvSuoPfb86qw81WxwmDlTE/IsGC0vVwB9SptJSdXoeL9SOhxh3lCefSkGpHLXAGyCZm9LvY/ELNsToWmjcmXas/4DVfMcXbpHLyT+1GyA/DynBXyNJzZJn7f1kR30lg104XYebxXRypMhxdUV5ZxSJq0kwgb780TV5PaJ0gZbXXmQ2XHQIp2wZJ4fbmfJyeUDiJoYISVOSojU6gy7gOM8COByx6s7dpRq2Qyr540AmjP4xqVsUaCQD15N5gUcBQH6EIQDNR+spiRGoPkmbDSyVxXFck8updGNwuPiEh4eLAb
 ycfmxX8B
 3QQ5awWsJLaQj6wn1Z4mg9cHEOu4wE4Z66ui4A7twi6MTGz+zBej4IVtXttDVCkYEFrojma5YqRb3BE1jj/t+C71CrJmXV7TWG7dSUkZULkGiSAhQt/RyKFMDs20Uw9riGXI1QsjouRIRevzkwdGLxrKjCOAMDhkx2YuyitprsoOVVHfun6++9G9WCmR5nUnCQPbwOnlLLqFG4+AYvSU+Mh/06IW5Z2W6k/rfkPneCgmCvADSRzkvZ3i8SWpP2whuMMy0SaCz05nYykSCA5sGAjnb8bQ2bSe3O1wcT6O90dAuVvJMRHJDmiAgUpyjhG01xevR14t8VN3Y5ubFPRsbVAA+tG6R6wSBbZaHTDclZltPze6nIptQP4diy4KWJHJb9hk5t/tu52CRPcma4bJ9CV9Y5CZy+SoY4wWiYGIdMqvExmQDoLG20VmPQZhSQZXH30O0pWmP6R4yH4RrgVh8QBAPaBL5+gw3n4Wwb7CEUbjN79u+9b70Xx91+b7Zgwxr89dpp6vEk0YiVG+7Vb4wctfsO614qRg//urn1HCAKSTr6gppRfHRpMR7jdMkCcFqZzpiesq4l66Mm7s5Z57Q/sf0aUmHqomLLSd8LDelL5bCEjgy3rI9d4r+TW7cPIebZ7vPltmgIE+JUm4IMRYUiBTanMQlpaIEPCe5h5/lauUfhZ4pEP+FqeOXhaMV4Alo4gZ7ZZVvdzhhY5bFn6gv2WudFSsGkhO1lxbiucUbzdbCWM6nmW2I4hSUL0HFmfdFcib+h2xKDQxuwA1W8+y04vjQXhgxmv3I1QEvfQsx4wxKBVDPHPFyuMZeGvKyhXBD7miDAt0l4QJZ7oQcSHle4XMqeHjihc4A7fcr5eG+xJooEKUJC8I8gG1gJASybwj0s9vqb8LTuI1EobbnlEyAm+akj9c29PElSpXr+AIBgQWiO/CMbv//ubqFaNvrQPUhOBZkarVZy92DxhYqkto709D1LRx0
 VH0p2/mj
 Wbe1AGaOyP8mrNilRk1TIkp0U9sRkANgxo0tZl1SEpYuRAjoV93tvxBMNCHGpPNUx32Ra2rTl/aVfA3sCSkGf1iteJz1kMXTEjlwj3LYBSsrpKQwu5VQhzVWco6L6lNWMGRmmxsKdYQ/NKxWPrsKixXOEr7kPjR5vI36wgrCzcT+Vfi6/fg6MgQoshyEgSKPAYeLB1lC2odvRLpbFR2SlXiwspdA6kDqA8KPuk9EI8YKP3pR39bn/mXLQ8P968m7lo7yb9uZs4poxUuplpY37johdLxCw7GTMgVHKhQVh2fsqRrKp92i7rvxppVYA0hoiRS+kaopYOi9HYi6CLS4fXJyrngVYj8flWrJ+fa+rSXj0ZhNnA53Kc3bHQLpaT0ZuY/4hmTYBkZpDBgZ6yo5MGfUJPxl+QZ4PQbxacnTHhbxtb4sWO/3HS6a/XrT5m6MnWm+w6CoBhLRD+CSgMSkxFkjvemqHMUjxk9Zp+GfbJ/bzbdiqHWcLeNztrzg6cdIYOmHdsXO9rJHwrRC2pF6bsO3seIU5b5pVXMZsXMUTUDVmrXAy588JSNi+uN+atl2J1Z9AXDoCEcxQp0nxcvDziA9e0XuRnjFcAzVBezvl6N8JLF1d7hij6nufKZpSOlFl1hhnw0DoYCjXfGcT9LBLAQz8ZUiIegfWp5W8EBwSYG/cgMOrvnvFG9Trm37o/RlMlqFabq2TKh12YWmODJXq0tNu5nBr7tXbvTppeCUA0LWSZYxztuEGvzMU5FtFYWWFF7R/H12L8KjRmuQBzzON8YGd5TjVIlR32Kxn3yVfqozuRcAzRXWacSi7fpZrZ4F8eU3rc2FhG1P/4Ly3eLRK/fX2gcwC6UOEEBcntIGnLc5b16lVlL7WNmdq59wIKDURiDyOb+MR+WnTJ9QcQhje8LalT7UHcmsmudT3OHttLl5jLkOec+6aOb7ft/F20ske3AEMdPeeknL2Nwt7CeOLfgsiWATI
 ruT4rORW
 Vu9SYo3siYHL5UlAEWIoo0mRCVOhRYv4X26no+TzD/NSrDF3BNHEmFulazw+RsgzqfK6m7foCJIStn/z6lcPzhMJ/FVdWhqQrX3iz8v4sDENEEE7nKvd3I+QewVZVACeJ4XBqpV5bsjiHgjPqnKGuQgsmDAJH36Zhe0XX2KNnmJzrFOakX7xxaEfm/bdj6vKL2gjjcP8Yw+JUf+zcWFagd5+erog6nzdfOu1AcC4Y7XXGjV/VB1/bhjIxxX9ZbikbCFlsBhVWMwgJ2AyqjmCFOZWgjkhmw14+Xknkp9VE5Y4EWtYNud6cqRSCvIA//1EmyyKebvIZladclGvGqdniIF7Wr0PIbaDk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in qnx6 with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/qnx6/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/qnx6/inode.c b/fs/qnx6/inode.c
index 630ebaa8a1c554b4d83ae75e5940a512e847bf51..6de49333acadbf08a8ce20d86e566433bc911f7d 100644
--- a/fs/qnx6/inode.c
+++ b/fs/qnx6/inode.c
@@ -75,7 +75,7 @@ static int qnx6_get_block(struct inode *inode, sector_t iblock,
 {
 	unsigned phys;
 
-	pr_debug("qnx6_get_block inode=[%" PRIino "u] iblock=[%ld]\n",
+	pr_debug("qnx6_get_block inode=[%llu] iblock=[%ld]\n",
 		 inode->i_ino, (unsigned long)iblock);
 
 	phys = qnx6_block_map(inode, iblock);

-- 
2.53.0


