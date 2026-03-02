Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF57BEB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:25:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EED946B0088; Mon,  2 Mar 2026 15:25:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E97836B0089; Mon,  2 Mar 2026 15:25:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4F3C6B008A; Mon,  2 Mar 2026 15:25:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C60686B0088
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:25:18 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7BA141C2B2
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:25:18 +0000 (UTC)
X-FDA: 84502252716.20.D95A726
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8CBC4140017
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:25:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WUgJCdF5;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NKpud0fcLxEocz0AVlVRGQLWJ9Tr3raVZEYtS2wBfBA=;
	b=OryStSV0F7e37FQ5PYdUp27adHNfHcWBzSqcvrrjnD+QKf+6//4KWkGa3Z1bHGI1ex8aYl
	sZDqcAkDhaLkrwk90IxpWhzpNMsBjbr3yM7IHk5xr6cfes0OZEJ2COtAXiTm5HiYtc2dyZ
	I8zzc1RZz12Y8dDROBbbQkS/aV8lR8s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WUgJCdF5;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483116; a=rsa-sha256;
	cv=none;
	b=69woVKBfLFpRDl0nUcSvGFIFJ40xd5M7R3zNT8q9NKmx7Z9EqNdYTXnVreMeHiV3OQuxVz
	GsuYtw/gnDQId4cGDE5gD939xiLkmUfmjiln8GPCwOH4fWIFKjlbdDE0SMyk7+JIPaWJBX
	NHGtIkcDv6UtbAASQEvuexGfrGVwGh0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B49F436EC;
	Mon,  2 Mar 2026 20:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043D8C2BC87;
	Mon,  2 Mar 2026 20:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483115;
	bh=a/GWSK0b9QXvtWMAeqXB3u+MddZFQoYzg2G9mjzwaQE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=WUgJCdF5t+Q1hK98cJHCI3yR4RRoaShPYoOuDVqA7bN0VVkGDmdd+xm+7ktLcUk01
	 EGdiF3IXRPe/50XIN/hcE50LLQL5RkjKg0n2DlG1WQL9loLiI5A5a/gZ9UIV4bsZTc
	 CmW8JtCoNZPuZPMgbWlhxWemup/Rm8sUzlLv5FQ+LBGmQz5a0Vrt4SK71foF1X9nWM
	 tEYcSb9RsFzTsrGm8Jcfaic19f8MaHL69up0/JoRawoxpouAHK7TmPnhvW74EAmIcJ
	 8MXLzhZlvizURsAInXf0jL+7Fn0tgIPFDwmr8aFk/Ljlg1e++4RbexATuMW3x9CnKj
	 2PBS37WBUhsTQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:23:45 -0500
Subject: [PATCH v2 001/110] vfs: introduce kino_t typedef and PRIino format
 macro
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-1-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1721; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=a/GWSK0b9QXvtWMAeqXB3u+MddZFQoYzg2G9mjzwaQE=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfHvSSPODOGv+IDeLjtFG7YpO1D5z3aKetMMJ
 fVghWz/+YeJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx7wAKCRAADmhBGVaC
 FbwmD/9p2V49BAW6bIXPo2PewhpDsNQPKpX1wZUIsvxqGpZ6OoPwCdTPl5JCdJpBZmDUV7xAAet
 GlbT9i4wB/NFkKQ4KrOGznjzpC7tpffCcO2sYntinXsiW8KC/5wjT+XwLP9beoYik1TS7LEA2D+
 vfj6urKts/Z2WhB8n+dPuEeFdMe26J7GcxDgZXJJaxtbQFIK2Kx9kxNE6YqgzGsCiCR6SUqooDa
 Z5h8Xj6w9sbvUV4NVm3Geb9YZn1s1u0TuJmIReIOZakp9qXk5bjhxeKsvbm9LcG1LZtvYnwny0I
 9HCRSTm5S904N17xb4gq9ptERLW/oJODRgpI84H15dAXxJQ0OMXmVMcldx6KF2V3cfXmEyJADQX
 HivLqyZD1/kytrFqvn32XWRqpdxCzgUFEEcKv2bUPnerzqbTT4N+3jZhRHyPowqPc14BLN5BZ8A
 0nvAFTFwK51nt5JY4VwpS253elwJVd8n8K5ZGEXB+K6KeLl08JL7UK59u7/W46KRFbFJfP7ggtE
 xR+Z1fmcG2iKvEAeQ+FN4loRB8iPdg6XUfBeTjfL/XUa3xEexjDxV7bZzoYVCZCSFttt0n84DwN
 dTfnY8nwZyuQDq6o+DlqztqDyUiCLpF4wd74VvQk92opgYHwEbXw0SmGlbxwF3ccsa/VT4qmkiD
 0g11lTFvRYNLbBQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: 8CBC4140017
X-Stat-Signature: c7xqpgahh5oo5o58uk61ea5tn8rpe41x
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772483116-9344
X-HE-Meta: U2FsdGVkX194TBwSBvfANkqwUO6XvEFx3PZaFMfpeUgNR7GQAeSVIgykPzdGBqDX8lPt8pRJF8Ns3g7DzoX9rA1BmwsX0hYt+8s0iC4iXKqxWkPmEPFaX6V8dyQULlPh7+uLCXY0G49FWv5z3Uc6qoDrrkQ3fKzhXgUsbH7h/GZBKmAEJvpPBVQJAPagwd0lLHIGBc08Uz+BFdhQzwsGQxWhC38xVY8e+bWGIV8+zhrdl9VKVyQW/Ai4k2E6RemKD4xhho/cTH5hpw3K7FeGGEUb/DN9WQA96FAde8CqQ33KGJtdZa6MrPy/0K2YzXR6n0+ek1u1b4Z6rKSZ96KNHcC1FLEEMNGfpWFP6kYVAest/No/usXgku83Ix9MpWvYmPAPzyceG4HLRv/lvZUl5QUiaQ5wPeMAOoEumoeGChLCcTaY1h72UGOBCLXXqN4LsFf2btTyNxoZFDuH7f8fFaj3gxgT5+9n11zTyfZZG9M73VahPQgIOgodPV4Xr0QdTtBuaB+oCmZvSuzYWHxLBIievsMSBdmj9AWlJcYNmpSWBkyX0Tgu4M3wlej/jvVq4AHlJQhSDelrpvu/t1jOWty5ddXYyFcy6j92HN/BCxbTLRyRTWETr5E7fb8ThvPqlOGCmEKoOZ75paXYsUQu3UjuXssUcKzz6Qt8K+A8/f0FqN2WGzmLOVFL5EVuEf+jjPe85T+yeyEdHAhIjLZRK/6wtMbWlUgkFccFofFzwaJjOOa3BFoPvHdienCFo6M13oByAl4f509RZ5wxcsEpjE6GM8xJLm2SzkFpFS3+upiBGxfYUNau6tJF/Y6/7R2STXObx9YBUg2P4ADzZa9aYddggto3yaUekFsdbD8EcwMIqSp6wiXEmjzApqolB6t2FyWKueJ5nl+lsUHF8a+eVjnYvw47BgVVJ8KIAR4braZZusyTwr0rhKkU09LF1KFwUJydvfDK1phgn+BBEOE
 Gt3+29/2
 lLICRyyvR9auPGgyXyb410tREUjX8LW3U9zVTqyG1IvPuw7tWBXaFO9fGFsto4o0Wo9GP+u/dzQEv6qwwMyuqLdESwEjgvfrpYXgLa4AJ0LuAOw5GIodwM/7+1EPN+YC8f3dxZVhQc5i0HdwhKGPpugCd8CuxAnZRDqm2QhpxoYO8yTUsBv4Jux/CJpO8W3ZNUc2czYJjBt/fNJqPaxsW358aHcQwFpaweGr3ww2ip4jaT+4a/0WiJo8McMb0queEO7v2F/n4eKQSYSJYktae5Hq8iVBhNH6c7AuTrYYHwVKOTk3QcY9dmDMv3C50e+/14IBVtbMceOXBqXstTu/DM+f9EorCjyjS6JM4al3OKeqI/BG8q8w9z2Jns+ICS6ezkCk6J6ukm45wz1XRX4U9vxqteGoUvpubC+GCYTuSEt8wdwa2hGFHctIjfcKikQSgtu35xQMQiJCTTYZ+N0J80PEhCokk/q4YdSWugJlYuYgum/pU+GwT+nXvmC0WNMjeILdA0Svdmw6cNq+96HHWvbdgQRU/mI7bvhvdMYR54H6g+wx9N4yjm73RkYU41rDmxq3k8528MIOjtXFpM/1gxBeU2BR14C4UBUO+aI+1BSe2ya31fNf4tNhmyqsfhkI0UYKwWtbeT9VU5eZxIWNj2o8iw9tXu9AWsUKLIKGN9kgcJHwpZXhtjTVA208PoOKALTIYvNHLRaY4izGXKCMXh1b9hY//xhOvVcxTtNe7H7A/T0/7moZ9/V965gQvleEA/PmLHnFaKjYbw6t/FR1aeqtO4bUBBi4x2z/ZlqH85wNdrsZYGN2pwLoyF40TRsYVcOdt5/ImwhdRrv7THA+p6Qt9iFQuIpTBMEgVsObNOTju/uSTsLefw82+0+y+N7JfEsYA1KRFIwEAoJlc+LyDmrKzkMtHmENjUT6yOmlSqNsEF4YKK+bfuDooGwg529B7VWl83PXPUU33ARiBXi3+8wFxQs0f
 Ihcj2Axw
 ifQ5hwl1ukmCOigzYIBDhOHh/BBq0RT6hWB6h4+JxT0DDAgn0IHG7OZt/fw9GnSSeir3uLN0C78aT2ocaD/XZRtR8iS3ez3rrM0YSVuRNpOTQcx02UuUX09rzTQteED9Hx9KFZmKaRWYKSm1hsVKmcRXjpTkm8rV4PO3qQKjSgyEC5+d4vWMj5h9YHOIhpIO6z9Ibj49aqGQrPYcD6SMQCyNixCDlo2JDCCM4syZwMW6/pwoNSvAZRQL+9B4ymNk+W+95T0zcKknAxwYTsNwY2VnWJ8Y5L3Xs7aCVfjB7klKlseg7SV2GrqQO+3r9lg5xNq7W3powzSsi3FAY7YZONgHPQ1Kn+DpLl8WiKerE7+tHSIMU2EB89AVMKojbKNWr/o2BrlLmshDiBml8VHOhXHkPNrtpFmqVClD8Rfxk8QJWAyjKa57qgaF7upG4nRnMP9BmggHfpq+wZhhmfo2h3TbgUnpKR+L8XsIRAA8jBrEncp2kbN8MQ48y/a9TPp61JtWppthdUmRS7HPKBW6enXPAuPQjFwzkBNajIHWe3vxxPiAasBxbLAXV/+1NnI32C7b1MzQQR+s6Bo8EtMukTVkOsZyH8STqcdto+amdQv7QVT1AmfQJQg8vqzMV+BpvSraWQIuEnAjs0nOrcLYx7IFhQwG2ONtbbhYPVz5E7d1gtVfLAgZgIfe8yPXlMuXV//gqY1GsFJnfmm7n9bpOI2ky4sfEEyUUSPbDGwmpcihfs/x0Vb6winAZmOFb8zEsWYom6qfgx3Lb52vDH7iPfx9rqWyKIf4CBUWJm2ENWEMZKXt1QdONT0gfYOaSgPZppdKJBZKm11/MsARcmoY5WQiFQgVnheW/120JrwPd/OAg3pTgFq3PcLvHwwxliF2Dfg7o6VULaxfi7/bwbujn9GKAwVGI8pYkxZbNq7j1JtXnRVna1UQkk/9D29Ipu92nhdUL5XkjPXL0RYo1DQcWhSl7hxhS
 LI/duqnH
 WbWpckzRpWo/GzOMKY/dFveD1bd2EjVsA5FY++3qLVx5NhTpd8V4F4VmyLOXWMkKSJf2Re/Vb4VCfysddQc9A+E1zPyEOaMcxM2dkK5qu57mnGI4q+knJ6oFt0llHQYiltH2gqP7jKjjaW19LOXwpwZgaxFBAx/dWYmyjDVcEIxcuvCHtcHBL0sJhgBje5EHYXvqeI8unrpK98SwxaBNtr1MKf+4spYkG5wVbyOCZH3g/OgfCFzjHCHgmld8Sif1O17Y2l8foCluvahukFRfwG5iKjWUpnPqCVbxS+SBkbtvvSQf00dGFQ6Hqu16aFODFHfixCu/qhzIewEfQylZlm9fRPc29lKDH2ktitPSAZcJuOXa/5gMWb/B/AyvVjlMQ8qErxdVAhqTqlXDufC5IFiQTEcNpndSK6cF0Wi9uPligZsGWVG079vXs78HY+l/EOeRyPfdpIBED4YAohykSYMrkDLqfuqRbkaM2n4HcWuPs5uXJtRifWUbcQ/SOMk2s6Ur3kPn/FIQE/qnJQEURbCb5Tpeei+Z40INjrt6p6TmKu992NvXlfA9ZTY2+rnyEolUm2OCqqf42xwH9BgwVDrZvRw9nbxxfMF2uiyfVHUV3iiDv1LsMNuHJtMNtcMykG7FIML4ZCmGaBxWlA4gto6Jh0LSbiqFcgEWVBvyt1Pmm9qy1HbDaJiUyGCeouW7FMI2FFS+UfAleoNEmjCbvz+DEHllB0+KtBjPrRtvspgrBvwxybAlWSBYFt294fO5jbDIel+Wfzn9ysIJsYAi9PpDjPfbCKQQ7cnlc+gUQDhnToQQwKC40gMIt906iYl30s2d4OhLAy/rEkZ47g9qB52/gaEqvEYid+SUKbY6rBnmVGtLv9sd8Fd1qCeKc3XlIIH949aPTjoBmWVSrOSKb7BxziU1qA0092znd0BJ64fykU8CUfFkhM/FykaJQLTCQPJ2V4IT5qOxD46uJ+upG2Z9L4Iw/
 yutFiYFW
 CeqPHX6fXVpXjlmpYiop9hM0687yNFr2G8UB4qPM1jNL35KrwmyTKmdlrM/A8qBQGSTFV5Iyogc5ybzksUnmMiPa97hNc+nrewU0F0p0AiD/IonVNU3op/kdxgfCYG6HYKYYAK09d0SHENFfuTKxyfgg3gPJOZG/LVH9RYWZ5mC1g+dh5sE23lP8zQQZKc+oijS44bS4x5onn771035AObGottGQmKu/yq5Ast8RPiQ4sSYRoXQvNUEPIPLH42huu2yUwTfsj7TfEMNX+jfzOsv3EuTa9Yr4nI0MvqWPrI+ZjylQ9HT6FNQhqdSsA4x24grl21tjpXcFHDdJAb95bTuwPkAGyKdC5+aHzdk3Zc/Y5yIz7xUVUkSSjSsAjvJjqD9UY4RKtFqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a kino_t typedef and PRIino format macro to enable a
bisect-clean transition of i_ino from unsigned long to u64.

kino_t is initially defined as unsigned long (matching the original
i_ino type), and PRIino is "l" (the format length modifier for
unsigned long). A later patch will change these to u64 and "ll"
respectively once all format strings have been updated to use PRIino.

The PRIino macro is a length modifier, not a complete format specifier.
It is used as: "%" PRIino "u" for decimal, "%" PRIino "x" for hex, etc.
This follows the pattern used by userspace PRIu64/PRIx64 macros.

Format strings using i_ino should be updated to use PRIino instead of
a hard-coded length modifier to ensure warning-free compilation on
both 32-bit and 64-bit architectures throughout the transition.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/fs.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8b3dd145b25ec12b00ac1df17a952d9116b88047..e38bc5ece1f360d679a8f30b8171292f7a65c218 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -758,6 +758,9 @@ struct inode_state_flags {
 	enum inode_state_flags_enum __state;
 };
 
+typedef unsigned long	kino_t;
+#define PRIino		"l"
+
 /*
  * Keep mostly read-only and often accessed (especially for
  * the RCU path lookup and 'stat' data) fields at the beginning
@@ -783,7 +786,7 @@ struct inode {
 #endif
 
 	/* Stat data, not accessed from path walking */
-	unsigned long		i_ino;
+	kino_t			i_ino;
 	/*
 	 * Filesystems may only read i_nlink directly.  They shall use the
 	 * following functions for modification:

-- 
2.53.0


