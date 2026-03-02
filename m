Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54FD4EB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD6926B00C6; Mon,  2 Mar 2026 15:43:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA3F76B00D8; Mon,  2 Mar 2026 15:43:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A44736B00DE; Mon,  2 Mar 2026 15:43:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 956A86B00C6
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:43:58 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5FB271A0323
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:43:58 +0000 (UTC)
X-FDA: 84502299756.25.F57A894
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9CBD540005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:43:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Dhc0/IGx";
	spf=pass (imf11.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1mGE++3Tr9ln+GkJzmBrp1azoK5kfrzwm5r3vxpos+4=;
	b=ve8DFxlyLEwJe+hv/3S96cRSeD8e1LdLnbcPnX/6ZjHY3iY3oXXx97XmEhoA//GzMNkHWd
	Urd5sjnwUkIJDc/sfYrcc2TgOKCbhtIf0WpZcgL2PpUa2+j+aGrSHWNlQx2ik9PmrwBzop
	UmYFHWYNIzG1fF0NlBPl5+dr1zjPdvA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484236; a=rsa-sha256;
	cv=none;
	b=Kwk79hjz8LO82PofL5TGtwSp6xMyLlG7ViaFDVXQlj3sCCwDnHKDU79ID4pDhSVJCeeMQO
	9gACshWl9ZRzhbdblNx3/i/I12luWBRUOnyguLMmmo9ADw70DvDkj6DbmBvQWFds/xAqRd
	d1ac7QXPcYjRfFQ9AXxT4e5nT6/NgqI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Dhc0/IGx";
	spf=pass (imf11.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A29A844343;
	Mon,  2 Mar 2026 20:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AE0C19423;
	Mon,  2 Mar 2026 20:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484235;
	bh=UOAEYynzD6EMQO6Y3DFiwCQHZhBo1KFizd/HOCrLZgw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Dhc0/IGxPCWnAO0jbCZROqeyev75wTetSuhR6IVoinPu4E1gWULuPW4d5RiCaQGEq
	 AFbJS55ArLRvwhpdmdATFnAdV0GUJHkRI3c8w1lWlz3ULpT5gMFFEEoZv5zxdEh+a7
	 kWoTA8Mk05bOqAWXdm3f3WCB6WTdqX7BD86y6lIXQKLSwMy3JakIrO9m47wKxJP4JF
	 KPqpqKefVELZWgjK5sG4D+uYNah9CKSQNKZQKj2pY81fYHyBvUMEVBQSlmrCirpWP2
	 8HzfNIdRTpBmtfbpFzPS9EKOpiBjNqjl/Nju19PccEHTVt4QgowIaIMeaHdzeWBE0+
	 /SqM2z5f7dvRQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:03 -0500
Subject: [PATCH v2 079/110] ecryptfs: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-79-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2351; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=UOAEYynzD6EMQO6Y3DFiwCQHZhBo1KFizd/HOCrLZgw=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIEOuphnEavDEIC3+G9bP/yGebCzlr8YPYv6
 f7CLhYHSnWJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyBAAKCRAADmhBGVaC
 FTOOEACXi4R2sd3xPPG8cv+3X/RfWdB69ekqMDYPyJQsUVp6n/yLGDiQtqcTUVfgmrBB+6AJfRc
 YvpZ4LYwGC/BOekpbEQMk/XhiiLvGO5X9Uu8z3giqLLoQN/4f5oLT0F0Evqf1T87s33bKV4IXQG
 dl3gDdHNA/IK3VCypwTH4d6HIR/jmnIvEMwDOuwSPc9rezoO12Mn07KPTb/5r2ZOCP9cqiOgeFP
 8LLRk4PwVfkg1MC+BirRPJ/TVcYIIj3OgrHimnANR+BqG9u9avtjVDTTZ4eJfRBUlLTRGqMpACK
 FTA/g/fmcCr3LujF1e6yqKdEBaEIpi8N6ShH8dbh08vCuRiriFQd6Ty4jS/Cwn8i8BXIs60W4tf
 zy6N4OdstOOea6o5cLIKf0LjXynUSwR1YOv/LtkqsRa0gFXvPo+Iw9mLx2mSzEkYvxRzfhClFhf
 KfEoeOggJflUZdvIuYRnc5RuqCu9Ce0iDQmEfrmAUD2Xe7sZa4kfmQPVUJbG4vB12lyTueZHPmw
 1ZxUfjFGzwwk2epkGp2/HFuwDeYbYbVDNz3AqQ+6IUDkwr773Dt1lAhomV2+/xE2euDce/ytt1g
 OxRCuhXWvvLoDd92q7M5PNh/vGHe5FtHtwx/XaxI9w/OBs0+Izqtj1WHqE/4lL8IDUevPGhzYf+
 ekbd6QBV6PaqQWQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Stat-Signature: gzeeki3f5akmx89bphoepdy7fsoisqhe
X-Rspamd-Queue-Id: 9CBD540005
X-Rspamd-Server: rspam03
X-HE-Tag: 1772484236-574438
X-HE-Meta: U2FsdGVkX18ZpvqnUMLQcqthNlRRklfLbG8Ucq1It6kvR0nW9mMMKxzSuEuAGIKaIyQzALYCMwiQxxyu9W/m3EtLuOgHG3vgHOVnSoMt6ftVbtmN+67w9VtgVruDipcHrjdYAFevrj8MQT9abxQ4zicu04X8L8RrIlyXoQmbOV1cacMxz5ZCupotlbsM+AEb6h4idIxiOL/zRbeQ+9F0dPmyBKn8lHkQdlBFk+zNigESETOwrzENVgm+uOMxhczoQis2hXRg5j1E5ci5eKgQ4ORmzbh+Fb2tVpSCwdJC3Hg1UnSLW5ywqSHfp4WC9BM5oYT+V5CyBbJbPRuHKsMM3HhoJgC4olRgjzAuTYun5srdU730F0TInSux1jrcqChnfRCPVAvH7Omr9nEgmHqgfrlDLyL45gxOKXPSWzy1sdFBksGX1jQQ0ekGWoMgbsEvDhs4XtAnUwXpZNVrj791LgNhXzgTIBe3oH/CmA6nWlvJXMyrihz0B5Sbn1y3or2LJnaNu49F7JXkvNgVAupPzOo8DDW0JIbAE8tK6hwl5wXCcJS4uO/yyK2eBI9Py2fg2EtB96+h0EtzuAsnHW9pPHzjqQWjYSiNCA7Zq6bqJsfZynb3Cz/YWKdOPxq/XqIfM/M5SFX8/tPdMaqZJhOV765bi3t2r6iNgW7IWBqDuvH9EgkRHjwSeRDSx5uLS3GbFWYB/gg7q6mtwFMciesZMYKDKHxB3bbr7GVW0+DXIsfuF2l4qFNItqb5CO18yin/pC0MLOVkorfG8UfSITGFbDQGqK5LoqBZQrgZk2+8DcIBaRgKLzdLqqzQKacGNWBo4Jgjy36lm8+CY/1YUkPjNEaEQQmyq/d/gB7kj22K0GlxMntHEml+P+6KatjRbDfVFrBwlX3vnxE8oh72mAkEi0wamMbQdQxzbDc+AyfdVDwcQp+3lZRt5Wcxu199gOa9drVeLDvQgsu3mdGrMXV
 NZB4GqD8
 NzCFdPl3lEcUEDbMvAjgU6dkVvu5fAmRmLO7wiYuKK4JXGmPiSDjk8c//WntvuT14TfeAZ0vZFQoyxgo1OlO1On9g3gpLcVa59c780HxyJZFqqJ6VxnAGRicl0TuEYfHw1K6wP+y+OhZMTHzT+2TZQ2BpxZA/xvcrbOBsRY5ICbqV34J/UVYc+ZY5Z9R5RWDAQCUOQSr69PmBTheiwL7E2gaWYV6+q18kvkXPch4vSa/s9gSSHoVbhGItyUQuKlX1lhf6T8+fjkm7sIDQvYXdg1Kz8pV1llQVkzBE9zLIJsENBP1JLc5H1oGW5+ZTnY2M0TbZ7bMDbJQlPvM/C6ki2UIFj58fFAk/dZn0/zWqh92Gw54CHFAkNoxcp6c0sC+gTtdkkz0DocKflfwpGWiG+RPcysjRq7DI5YjqO6JyiWtGuuEI9lJ1lYQ2uSMX1055+tCbGHPp2nlol7Njb2m5WfFU58DGYgreuQIyVp73955qu7IZQ3mPj18xQ/nri1L485X7SadA5vMTh4WuEoG+l7irz4lnjDO1TlOm6QHGByywYHLoWJguuvFg7ykn/8E9WbMxciJjCLL7eqlPMEEz1GEo02c5U4hwJZRe0hsKcLmVrW2Bm1mf0/jQ3p8RyI6qoe5SqOSPxsT+ZKjriQ5qALgAa0SwSaqMysJpnid1n8zdNIoVqMjKg3FexZ4r/J4cNlLgtucQA31b2scb85JA8P+gex/lUlmyeZR81Kvul+MvhDw0H2Q0XQNhGpWscyLvyUfDO8vFj475/mu/CgxReb4BJoiS2of/nwdnqmMWL2xOWqXg0UL98GGUnKxw4xfS2R1tipwKkQt85CqD3Vp40StXpZZGR2+1eHR7ANM4vll4KNb7DnYDFHdLWuBAXUlI67ximx3/x6qXqkF4yLrpPpV9IknBoIQ9BFAswHaruETcyaXPZeoJUCISqrH51ESyHurjLGDqQIfQPPtG0BDjvKnY82QN
 hPQ89Mjs
 b/WQXQ3IRfhhfYcuB+4lCdnOvqTCPxr02LsB6Fd6UjDBmiTqLhefLd/edpSFizro9zf5yvJ5azi98jK+FzqRPIhglmI1/uKh8z3KT09YmXyNnP7AeqWwBcb9PueDWEak70rJB0yWcvBfd6ns2Bps/bJd0vWSyw+Yac5Hae9m/4E+d9mWNofu+wkMshSoiWs8PqYBR8ieDPUrxEE4OjOkvzk2fRpuCxGINMYRA79QMyWNs9bQ+Z1nbWf1zQHul6B10p2Ra3ui8LwJh50fAj5JUZ093egxQrmFKYdj9T8fgHJ0yNgBJcmA55qU44FvgM3FM/wnAT7zraNzsLNYK0kWVFL3weSk2diYqCtddVRapS0XiemoNr32QkVnlCkZZgePxknjit5Bk2uzCZBwD7i9g5pyITjHIw3HRDQzjf6d47B+iUwO7LR9jExrm6YYDhwfPN8aiWagbTH6KMmOUKTJyIVH99U1k7MSuTG/5JNl01GLlc3NMtmSYHdY9wiJHY56nbEezyyjmK1e1RAuN8eyr5j1lyYJnbVBi2lgxgOtckM4/EPjWOsbQWL2VOqJOvhCf3XmSi7XLLtt8OVAqNOZtFrPgIkLGSRdcraqOPoBmMUtqEPS/n+fU9gswVlCRefkby0M4HgimrvObJzovXbuZgCrODkrgs3l7d/esY5Wmf67zRSm8WQtf3YGM/oX9Y3HZMDmHlPireNgXLv9h3t0Fr6zA5E+WtDpLRy+dblHfYG0CyeCXtVVs9EgdHCG76YgVf9zpaAaKEcC1MRJAMjZh9ndM/8YjOXve22bTmeYV3UY0B5FBdYjZ9/9+Xk7Bbw2ilCPkjWoPNFIFGTvLsjNpep9iBwGgDZRD647DYShyujo754AdajHpgMfIPzq+o9moEGCoC3KSwwhU+wbIXSE1d22mmUl38uiKinz15Dm++1ljEeKvFJhkOtpMaZQ3kMHKJiyPrxzkvDTk9cikhfvCFERHgEYy
 JW1x0XWK
 75wdRl2oKO1BcVwrTw+kj9IoKoqE1DeipOpphzLGvO7HezsvcRuMm6uv6LoUbj+GtYYhtGQi0xPsGszZYP0cMjYNTK73BO7WpWu+GfQc2hR4RczeZ2oV3G24DQJf4E+IlzmdtqM/ZvCqArsAcM0TXhKIB2Q+IbmnXdsGpwunWp0xVqExpBS4VXGPClyF9rxjSx6aFL591W0lt2LI9cfeeQf3O2eu9wAtp/RUUHzhsuhVg6JfkkL/MR/iGQ02v9Jjj7q7gduncqR2uPZ4CpfwFyhNgx4/p/VI2qX8zzymyyaemwtcbJByVPOt10YfBaBaMne6kV0Qjh76n1yph6MKdY6FjeAK7fEwCSQGoz2cV/wC5PACecwru21RNAp37ucdGSjtyHNXpWvCU0A/rW1ghrUo9LyhlPyE23GQscxyRKTVV0pUQbBthJYTV82BeImbF7SaChVWTEWxGQ2lmeEKucp+HaSOoeYkY1oNb7OaaYzN9QsunrgHf0dHCLqeBxvUYwLsxJ9RHdT0j2IJTjgyDp3I3Ts3b7hswg5WbNnV6+21lonxnr2CK3iLRhKV+oCan1+t3MsKkibwNFWasD1Zl1iZ5+xwm9INeVwWf+wL1b+bnHVgxp5IMMErq86KDwxwx2Ui5gItuo1SybfbU2RTWXU+VljcdWTATGf2J5A9YR/+0YKgeLvhDUDXoWd2fCQKsHYLEv6Fom9nnpkz84suKcuevTZfZQdvtcwdB8bIwPQkD9/XG2nf3mAOn3dAEJH348LKBqEYt1NI8iqM0X5P7grpYqjdoVUkmX6uHtfQcuCdAQ5t4DpBd0lFrRPdCD1go/hN4IaQzaN0DkKZgihXhOuQWvpTmtSwK1ERv8+fPk0w42zmzL627JgHhRMQc7dOTwUF44YuA0HD5hzAkUT6rWvqeQBNj1MIhT7tHdQfELRRxyrR8I2O82Gj76jJdDoePK5fBN2ZVu2jZPAk0fSB0fKPdy89Z
 tpQBP5Xg
 psR1cZN6wpvNfqK6RK6n7n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in ecryptfs with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ecryptfs/crypto.c | 6 +++---
 fs/ecryptfs/file.c   | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 015b2e4ee11cba5b734d1f8fcd851accfa8f0481..f25c9a49e251a591695a143f64d1a81c5211ec18 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1313,7 +1313,7 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry)
 		rc = ecryptfs_read_xattr_region(page_virt, ecryptfs_inode);
 		if (rc) {
 			printk(KERN_DEBUG "Valid eCryptfs headers not found in "
-			       "file header region or xattr region, inode %" PRIino "u\n",
+			       "file header region or xattr region, inode %llu\n",
 				ecryptfs_inode->i_ino);
 			rc = -EINVAL;
 			goto out;
@@ -1323,7 +1323,7 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry)
 						ECRYPTFS_DONT_VALIDATE_HEADER_SIZE);
 		if (rc) {
 			printk(KERN_DEBUG "Valid eCryptfs headers not found in "
-			       "file xattr region either, inode %" PRIino "u\n",
+			       "file xattr region either, inode %llu\n",
 				ecryptfs_inode->i_ino);
 			rc = -EINVAL;
 		}
@@ -1335,7 +1335,7 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry)
 			       "crypto metadata only in the extended attribute "
 			       "region, but eCryptfs was mounted without "
 			       "xattr support enabled. eCryptfs will not treat "
-			       "this like an encrypted file, inode %" PRIino "u\n",
+			       "this like an encrypted file, inode %llu\n",
 				ecryptfs_inode->i_ino);
 			rc = -EINVAL;
 		}
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 9eff00cfbc46c5fbd599252dcc4434fceafb7223..49b0fbe0428a2d202434ce4b5fd7d82d2a63cf58 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -253,7 +253,7 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 	if (rc)
 		goto out_put;
 	ecryptfs_printk(KERN_DEBUG, "inode w/ addr = [0x%p], i_ino = "
-			"[0x%.16" PRIino "x] size: [0x%.16llx]\n", inode, inode->i_ino,
+			"[0x%.16llx] size: [0x%.16llx]\n", inode, inode->i_ino,
 			(unsigned long long)i_size_read(inode));
 	goto out;
 out_put:

-- 
2.53.0


