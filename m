Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB9B4EB3635
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:48:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BE836B014A; Mon,  2 Mar 2026 15:48:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4683D6B014C; Mon,  2 Mar 2026 15:48:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315EB6B014D; Mon,  2 Mar 2026 15:48:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E07D6B014A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:48:31 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DDE31B80C9
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:48:30 +0000 (UTC)
X-FDA: 84502311180.21.803F062
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2701918000F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:48:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XI76oZ+h;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/s0qcKtkPyNNexNMeU3/9KEOVKSpPmDLwGzwSP5y9Cg=;
	b=FNRoo8z7Z8dvt8eIRxyyi+Z87YXnvX538TemXYjiFmyGxbSP2WVlwaO9OSUdaQPfzr7itP
	5UUBAjaEvrueIYaD4YW1Juy+wiPpwbfgkn5iZ2drJFXbj4CdPx9b96hsf3/S8ra2+kIMNi
	PM2Sh53ah+C5f8EQTu6n5Rxk3nPwsuQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XI76oZ+h;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484509; a=rsa-sha256;
	cv=none;
	b=GNWJQAsdvReySYMdfEquTqbr/uxe5fCziLs1UMmb40vZPobV9OuwlKRbp8gky2s3v38Wdc
	WeoAVpXPV7bDT2VRos39xu7wd82fwVcNgIThqFoOqtvvbtujNlhMPznugUCM0/AdbVcRwH
	LyAoyTX/vKKrzSDjos5VmA9yUl4zMu8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5553061339;
	Mon,  2 Mar 2026 20:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE446C2BCB6;
	Mon,  2 Mar 2026 20:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484508;
	bh=1EJjHbG93FSjDeVuMtsafteGGE98yBTaCfnvBYFEQq8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=XI76oZ+h5xF3w7QVbOqso7b5tHF8kPu/QbazDfUNrBnF47NKKXkiiXNGQy1aAV3hb
	 xSK75SC+X1nl7ZJGquRPkcbqgP3Bw9n2dLWq6bKl/z+BNsKh/p7yTgMK89uXYn4nhH
	 aoe5C9WUXQfvw4qVHCBd++yOFxb/+F5pnSzSTP0Mx0vqPXIGp+ro/XVZVIzeXyzq/G
	 5xLCVO7l7kKikZOv7Q0iyckDW2xmL7nWKTdxohDRFFpJhzWwzGe3mRmsKzoG4/wKEq
	 P/ejMiT7DW65nCO6HOBBRcU48QJgpO/KPXD3O4PkogPNyMfm3zF61cqhfI92yIsOv/
	 s1t0q+qtDQLgw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:22 -0500
Subject: [PATCH v2 098/110] udf: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-98-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9498; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=1EJjHbG93FSjDeVuMtsafteGGE98yBTaCfnvBYFEQq8=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIKSMQ3yX9CjAYQGZfiTyoaVu5Yy1AajInAk
 1pTdvUiJvWJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyCgAKCRAADmhBGVaC
 FXV0D/9333Ohxa6heYn2cRvQwO6TWNzz7GT9iAbWB6LsKbLiddG1fpr+Yet8e4boKA5FI8ER1X9
 yeMN9IIetzlO6DeWcawCiRa82kjwS87XIVykw4R//Esc5JVEH07e9ETgD0GmRZAuN0MOzGsw4sJ
 v7VosoXItrNo73SoCmYrbeYz+0T7dHfUZn7AmgHNzRfts7Jvu427jYOLas3+O6XiueCJ6QNmB7k
 vbgFxWrOrMniCM9U3PTAp4TeYv3Pluod7KSd0jBh4oAsme243OEZbNcN0zlF7T3DGPORUxc7Nyx
 OJZDmbSLTK0H9aNFFbVAPp7d+vMrdqTmSVSRHr5EhtwyFx/WEu2DspFnBeSrISOc6We9MioM51z
 Sbm9W0h8amUrhwZ3AVJEPzIIEpsNsDGftPTk/Wmps25zq+u4/BvAM0NfQL5Izp4jyO1f4acreGd
 nkoRiNlqt3bAbM61M+cRPRNoHk98W3ibZInUIOZwA5B8jR0uC5rSTeFipru/6747gOLEhhMrC7r
 B4VvJSv/naEQPOPDseSyE+cjKvBViFRMyT76nmvTHzIazA7oN/ybLO353x4hcGT0Uuqabe+DFc6
 CBYXLQIq37bJjJW2s1LPpMPRwaMSVHB7/C6o3/9CBxVJfoa3GputtmBlQr83d7PWptlHuBhabd8
 3iDTCeuE2cVcKNw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Queue-Id: 2701918000F
X-Rspamd-Server: rspam08
X-Stat-Signature: 9fm9yq5zgkug1xummryt4t6dmn3iss5a
X-HE-Tag: 1772484509-589368
X-HE-Meta: U2FsdGVkX18ZqvWDTuTtMcoDNeYZWZ+T8a9GnL8y7tnvX0Q5jj0BXTUUsZBmjeZ+fHAHOVF5m+4Yr9TNRD79sdFB5pBOm5c06QJhwxV4M+nsyjC3rbzrqg3Mh272h5dwXdCRX0JxvFn5OEqw3w+VzA4Nc7ad8iFP5+Pj88j++0iKYjtJwSnRMFpdBW/RqEgc5O8vWuKrmxtuYJpEfd2nEWm26NHCE4Fg5Vc5dEP8XYJVPH+RxHo8HQ9V9glASKga8vgJQ4jOw6Veh0dwhXISueT5vpCHQ2QHVJh12x79guBTOmFsVg04lQd22+OA/xLtUO+Bp3xctQ1xsCfTZpJloz/muFyGQHCDPm7t/jAOnz4fXx34CUhguDP7QygxX4FyEjMeqUZMc4MM9Hg394QydLEtTNkMoJbhLmGr4ClRNc/gE+aHX0N8QQA3mRsHjJ1joO+pPzbXRwBQbQiBQ4dVdpWncAO/GSWIcBW9nf57APk4VpbYJjAt+aZykJoDB0gOgCFDDmgDyqmobkNjSEXbinyNH9JufL1obH3XeljviXCJH9eqGJD+c8hQGdn9k/gCOQtBvdpBh8kqc9je+VGRNamiR1fHPxdPNEpS6Va4LWxc4Z2Sy4vicLd6PdDxhq73ydmj+mGigvkg1NWuMY6TGP2RBZ43r81cXyK8h9Ok6XoCatliE3kcVItgryjgIzLpH81owvbvTC9UuHLns3XZTb7wnIsVRTtT5dI8U0GrlPDJqI7cm99nssXN2fD8cySl0/1+6Vk0W75/TVAdZwOx6wk9ibVvx82Xr9yX68N0Ujh1F7ozQK1POQFI3t7bt6E7KYLdZPCQ7q4g18MukYCZJRKI0k42DJW9isnK3kYac6ffkOckE91KO8rb/TWSWWwlOCSTaC0xF1z9iGYcwA/BlTzgji3cMMmdJXKkJAuUfv0DRUe4J4oPA1T7Py1ABOh7Hf8iJRguIK9Cz04KhU3
 iwSqN71w
 VrJPLqaC9H4DmUuo5tzA2clH/pTE/U+7J6D2ovE0kxl8X2o25GoyN1pns6J/JWnf/JyksJdPfbe+uA0gm8VvadzYsqLzlupsg6zoygsmaQirWX54QLeWnehPsdqkFQFYWBaYMzm/TI24bbZ9TRYizHebjiXHUqO63+6vYkErGQ6eqc2NnAW9oQa0odj62MSbH/6RK+0hZbjxsZXn3gQT4PXfpJJP3ve+fQ4bP2Es5Q3BPU/CrtegonuspOBxPgd+UOgH43iQMiQD6NQNt9S+UTF4nrPgjVxzPziimK7o+UUB0kvID/khsvWLB6ghsxJ4Jkx7vY8ipPv3uZRb5gUo/g98HYjZhJCv+dto9t4UkwA1YKgVXQMvodSC6iSOcU62TpkP7yL7taE8aZAEdGP9y/uJUJ3GjbR/tf6Li3aGuS2PwnljCKIPjhVTge+SEXaYdv+2lY3XGmqGyXYyyd3Y1fwfPPgTAqZH/I8AdJEQcoMTEQWBa5M69A1mzdNjDxKNnNDqjazLCFwMx0uNGLvStvPDMUcDKRT/Ei2TPoden4sgzu/t07Nk2d2o07aqMmhgZ5y4gwbksD+6leX8Tn/gHszSHfH7ctaQnr9M+JEXb6YdAwtu/mwGxhx5ppy7iwVbaBxrk0/7VGAUM5ic9f3jsdC07EfJRGWoVckm62t57MMi3ifutvB/dgUW2a3a7vJHIGxQcBuR+EROTL1K43UZggoAUwq1oNHg6927/NyIQOAKuaerB4IHcnLoY20I41nfkI1wiyPsLlNnz0V7V/OZtw6CouHjA8SAfFGOQXSzkYewSqjYgrjoNBQDSLeGgo6yMaSygKiPbEFTamzW9HKUcF3GSWTLCijeq6RZdakCHGwMFBw6Z5aNUW6QT7bPkNKyQDeE9hrf5tGHcyiKJlVhwYL8HdpzKeJoQaRGRW+4+RJ3Sg6UDDnDrIFPgpoSp8H6Y0WhYiuF9QU8OtV8eNQks0dWzhJUG
 jqACyp/M
 7v7bDLy3aWuWv7qGg/7AqG0harHG0CZwri+KHcSfbNM1BjXoT1BOb+IOvVIC6tF7cnA31KyLa/ceJOFqW/T+3RuiUnpHIjywNk/dLEnjY9JoXXQZJ1IARzYUF0iOXT3pll0KJgH5YyiRs7OjFV0lfj2i1CA1BXDdujmSFcqv6i85iiLnBm4Axdi/9EGj8aoJ3/SU/lqhD/QzvHJFQSa81b9OfktxcpUj4M99xOVDlVF3TMrhna9lP9a9j47FbFvznfEFMUUGGr2TU6Qi1Ce2Vy7FLEJKQXv5197sU5z3pN0XAJSEDWZnVB+1AuGT49/kIMjxL58RYNuZfhCDX28in86uaeMUEzgwY93xxOY98LYg9Cb+WdY+mj/c8SvwZluAESrOxK5mj6aXgpL6BGskZYD1IefTxWofcLg4+GFcLoGI1tO9PT/R8i1tBPiwgMaeykubM74TBBMa/m+NldPGe5xlKgsY50WiOBmBaqYWsegZJZIN9EP894wFK9ILGyor8LuF5DLaKAeDYicQB3gWGb6MWh4vwSlo3rTqYWp2ypAo1rE2GcvIEvtibjof5ZtQ26UZvSWAS+sbSpzBffQQV3gQR//or4ON7piR8K6e0EaV2+eKogzaAjakNuuWGf4mgkbFb+/9dAl57Is09w9vsgaqo6To7GnJBQ5FQPc1L/Ax8DQ8jIbZtDUJ8QLbZEVAkX/SqNlWCpAxtKhc/JuMDkemmDhon+xCGjNLRDXz85G5blIv+tITv2D0Y9BSepirZp8T4XLLXdFP7RRtchnWkc0DEo0GpV1cR6gm7e0BMZIj/SiVbTvLP2rp4Fdv7vn5N3NudRe4+x+K0IQ9ek/Tg1fAcnhYa5YYrih5hH9fMJaJs/2mnglDNMyZfe/fuPy1iSrxGzyVYVzSk732vU9ExVB2LYbAW+oPgoYdNQUqsjVt1fQpK8576/1nkMT4aHIII23vJXxn3WChSTOE8PzdgeCwdw5zs
 BcmXo5W0
 raF9q/mBWbmInwBBLlvhauePmgDm4I1qcdySV9Y5lXfWomCS1lIGa8CK1OXA3LpXIDpK0oPVuJjZJWRHdDfMjZbb8THNVFfwSU34sLpNcy/9ladHuXdjYL/AW+hyxkCmIdMI6PtMpbSquNCpk2xWAMr6NJ6/bLuCt+XmjegkpSlYjdJmiX3b+UwslE3XRgtq3kZMdDUb0n5F9LLgUXRbhrkJWaOAoIP2lCSPdXtwJuV4d6XsYwiGH0dfCpVIxJ9uz9Mr7DIv9Par8eweHkOMa0rBlLCkYLNi5KRfp427rZHfUIMAJZtkThKaogfEhHhPRQccrbB4X+Glrht9HD3TiocVm5R9awsvujJ9My1ufMs5t/Eex7cpcsQ+P6FVeMk5HpyDWo1eOxjQew/cmxg1EYkEwdx7U64OtqYeGCnfqu1J8Coju8zy8a5GJNmJ244wifoxVlbGZEErnpTSnAYtTD9UpXbBYr1B8OOJ+A6Us9WwtkGx4C4JFUVpnkvBzshyO4eC606cndIGAM8EafFNrfjGASLk145wpC2S7h23+BHNhkFhQ/pTgTPCiPeoZuW6YxMHK9rXayH+p/EWTi47vD1xoXNqogOlpdVBZoQV7VeNaBvF2rkl6Y6Jo2oKMg0TmK6bof+NQ3a3giTB5yQGY0Bdf1F4hTAton0R4stBkeb2lkSig5ZU0oX6+YzW/ys/dONIOR7wUPbYSti9zZpm+ulS69xCc0F7z2yN4SygApyv/o/fcd9u2TZlXFSSDQuQrSON3uOSCxXMXOvGZtmshG5hjX+I1yGpbxXMmdB9e4negPOM8YvInFB722dj/Ik+twOmxGILS0mQUWwSCP3PYfbQXj5Fa3X2wZ8mFNv26Apd8zNgkZWt83TPwnrER3Rhhl5IWztQP/Ar18++1tJ34srCB2aL3Hev0dtkGf00v6plcCUK/73MNzuQkNLGeT3gN5HNB8Kowb1gR7JKAHuHp2FLvFUFL
 6EEIA86O
 qWvNZIx1JfH8cpvnstt3GR2x3/DQEJoyCLWvbk6VZcVI6PScT4Fsl4LHzAnHuOgF3IvTwWGrp5fX6viBubfFVmYAHj6QDmNxWzVyvpMlAHlAWkNQJwPCSPUaCz58bga8QbfA9tU8UIEwum57mekZBI2rc1Dgf9xObI2tCo85Fc0fxwZioKRoc1lO75JceYqWaECPWmbvOFoc3W9lHtYBGSfDEyFMxhktOQl3tTmPy4gYUyA0morn12e4SjKuo7FbwCwKs5CH+4ainjFGO+Lw3KJAROPJ1UPNVGDXVXrN1SUxLmRk3u9VQs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in udf with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/udf/directory.c | 18 +++++++++---------
 fs/udf/file.c      |  2 +-
 fs/udf/inode.c     | 12 ++++++------
 fs/udf/namei.c     |  8 ++++----
 fs/udf/super.c     |  2 +-
 5 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/udf/directory.c b/fs/udf/directory.c
index c825e11c017f652500a3dfc83905679ef86ec570..f5c81e13eacb17f931d2df564ec4f2a6e9a5d7ab 100644
--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -22,7 +22,7 @@ static int udf_verify_fi(struct udf_fileident_iter *iter)
 
 	if (iter->fi.descTag.tagIdent != cpu_to_le16(TAG_IDENT_FID)) {
 		udf_err(iter->dir->i_sb,
-			"directory (ino %" PRIino "u) has entry at pos %llu with incorrect tag %x\n",
+			"directory (ino %llu) has entry at pos %llu with incorrect tag %x\n",
 			iter->dir->i_ino, (unsigned long long)iter->pos,
 			le16_to_cpu(iter->fi.descTag.tagIdent));
 		return -EFSCORRUPTED;
@@ -30,7 +30,7 @@ static int udf_verify_fi(struct udf_fileident_iter *iter)
 	len = udf_dir_entry_len(&iter->fi);
 	if (le16_to_cpu(iter->fi.lengthOfImpUse) & 3) {
 		udf_err(iter->dir->i_sb,
-			"directory (ino %" PRIino "u) has entry at pos %llu with unaligned length of impUse field\n",
+			"directory (ino %llu) has entry at pos %llu with unaligned length of impUse field\n",
 			iter->dir->i_ino, (unsigned long long)iter->pos);
 		return -EFSCORRUPTED;
 	}
@@ -41,20 +41,20 @@ static int udf_verify_fi(struct udf_fileident_iter *iter)
 	 */
 	if (len > 1 << iter->dir->i_blkbits) {
 		udf_err(iter->dir->i_sb,
-			"directory (ino %" PRIino "u) has too big (%u) entry at pos %llu\n",
+			"directory (ino %llu) has too big (%u) entry at pos %llu\n",
 			iter->dir->i_ino, len, (unsigned long long)iter->pos);
 		return -EFSCORRUPTED;
 	}
 	if (iter->pos + len > iter->dir->i_size) {
 		udf_err(iter->dir->i_sb,
-			"directory (ino %" PRIino "u) has entry past directory size at pos %llu\n",
+			"directory (ino %llu) has entry past directory size at pos %llu\n",
 			iter->dir->i_ino, (unsigned long long)iter->pos);
 		return -EFSCORRUPTED;
 	}
 	if (udf_dir_entry_len(&iter->fi) !=
 	    sizeof(struct tag) + le16_to_cpu(iter->fi.descTag.descCRCLength)) {
 		udf_err(iter->dir->i_sb,
-			"directory (ino %" PRIino "u) has entry where CRC length (%u) does not match entry length (%u)\n",
+			"directory (ino %llu) has entry where CRC length (%u) does not match entry length (%u)\n",
 			iter->dir->i_ino,
 			(unsigned)le16_to_cpu(iter->fi.descTag.descCRCLength),
 			(unsigned)(udf_dir_entry_len(&iter->fi) -
@@ -78,7 +78,7 @@ static int udf_copy_fi(struct udf_fileident_iter *iter)
 	}
 	if (iter->dir->i_size < iter->pos + sizeof(struct fileIdentDesc)) {
 		udf_err(iter->dir->i_sb,
-			"directory (ino %" PRIino "u) has entry straddling EOF\n",
+			"directory (ino %llu) has entry straddling EOF\n",
 			iter->dir->i_ino);
 		return -EFSCORRUPTED;
 	}
@@ -184,7 +184,7 @@ static int udf_fiiter_advance_blk(struct udf_fileident_iter *iter)
 			return 0;
 		}
 		udf_err(iter->dir->i_sb,
-			"extent after position %llu not allocated in directory (ino %" PRIino "u)\n",
+			"extent after position %llu not allocated in directory (ino %llu)\n",
 			(unsigned long long)iter->pos, iter->dir->i_ino);
 		return -EFSCORRUPTED;
 	}
@@ -272,7 +272,7 @@ int udf_fiiter_init(struct udf_fileident_iter *iter, struct inode *dir,
 		if (pos == dir->i_size)
 			return 0;
 		udf_err(dir->i_sb,
-			"position %llu not allocated in directory (ino %" PRIino "u)\n",
+			"position %llu not allocated in directory (ino %llu)\n",
 			(unsigned long long)pos, dir->i_ino);
 		err = -EFSCORRUPTED;
 		goto out;
@@ -483,7 +483,7 @@ int udf_fiiter_append_blk(struct udf_fileident_iter *iter)
 		   &iter->loffset, &etype);
 	if (err <= 0 || etype != (EXT_RECORDED_ALLOCATED >> 30)) {
 		udf_err(iter->dir->i_sb,
-			"block %llu not allocated in directory (ino %" PRIino "u)\n",
+			"block %llu not allocated in directory (ino %llu)\n",
 			(unsigned long long)block, iter->dir->i_ino);
 		return -EFSCORRUPTED;
 	}
diff --git a/fs/udf/file.c b/fs/udf/file.c
index ab8093b87dc8f21ce8af6a72621e2868fb4b9a82..b043fe10e5d605b62988512bbda65bd357fb649a 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -133,7 +133,7 @@ long udf_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	int result;
 
 	if (file_permission(filp, MAY_READ) != 0) {
-		udf_debug("no permission to access inode %" PRIino "u\n", inode->i_ino);
+		udf_debug("no permission to access inode %llu\n", inode->i_ino);
 		return -EPERM;
 	}
 
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index ecc22aded0d287ccdfb34b42a0d82e392054f585..902f81729bd886a534c9da644771c7c04c067cbf 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -147,7 +147,7 @@ void udf_evict_inode(struct inode *inode)
 		if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB &&
 		    inode->i_size != iinfo->i_lenExtents) {
 			udf_warn(inode->i_sb,
-				 "Inode %" PRIino "u (mode %o) has inode size %llu different from extent length %llu. Filesystem need not be standards compliant.\n",
+				 "Inode %llu (mode %o) has inode size %llu different from extent length %llu. Filesystem need not be standards compliant.\n",
 				 inode->i_ino, inode->i_mode,
 				 (unsigned long long)inode->i_size,
 				 (unsigned long long)iinfo->i_lenExtents);
@@ -1386,13 +1386,13 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 	 */
 	bh = udf_read_ptagged(inode->i_sb, iloc, 0, &ident);
 	if (!bh) {
-		udf_err(inode->i_sb, "(ino %" PRIino "u) failed !bh\n", inode->i_ino);
+		udf_err(inode->i_sb, "(ino %llu) failed !bh\n", inode->i_ino);
 		return -EIO;
 	}
 
 	if (ident != TAG_IDENT_FE && ident != TAG_IDENT_EFE &&
 	    ident != TAG_IDENT_USE) {
-		udf_err(inode->i_sb, "(ino %" PRIino "u) failed ident=%u\n",
+		udf_err(inode->i_sb, "(ino %llu) failed ident=%u\n",
 			inode->i_ino, ident);
 		goto out;
 	}
@@ -1641,7 +1641,7 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 		udf_debug("METADATA BITMAP FILE-----\n");
 		break;
 	default:
-		udf_err(inode->i_sb, "(ino %" PRIino "u) failed unknown file type=%u\n",
+		udf_err(inode->i_sb, "(ino %llu) failed unknown file type=%u\n",
 			inode->i_ino, fe->icbTag.fileType);
 		goto out;
 	}
@@ -1942,7 +1942,7 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 	if (do_sync) {
 		sync_dirty_buffer(bh);
 		if (buffer_write_io_error(bh)) {
-			udf_warn(inode->i_sb, "IO error syncing udf inode [%08" PRIino "x]\n",
+			udf_warn(inode->i_sb, "IO error syncing udf inode [%08llx]\n",
 				 inode->i_ino);
 			err = -EIO;
 		}
@@ -2224,7 +2224,7 @@ int udf_next_aext(struct inode *inode, struct extent_position *epos,
 
 		if (++indirections > UDF_MAX_INDIR_EXTS) {
 			udf_err(inode->i_sb,
-				"too many indirect extents in inode %" PRIino "u\n",
+				"too many indirect extents in inode %llu\n",
 				inode->i_ino);
 			return -EFSCORRUPTED;
 		}
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 32209549a31f451a486918e673a41497bef42e89..ccafcaa9680982decaabc180833b67ace5c92973 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -550,7 +550,7 @@ static int udf_unlink(struct inode *dir, struct dentry *dentry)
 		goto end_unlink;
 
 	if (!inode->i_nlink) {
-		udf_debug("Deleting nonexistent file (%" PRIino "u), %u\n",
+		udf_debug("Deleting nonexistent file (%llu), %u\n",
 			  inode->i_ino, inode->i_nlink);
 		set_nlink(inode, 1);
 	}
@@ -809,7 +809,7 @@ static int udf_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 					       &diriter);
 		if (retval == -ENOENT) {
 			udf_err(old_inode->i_sb,
-				"directory (ino %" PRIino "u) has no '..' entry\n",
+				"directory (ino %llu) has no '..' entry\n",
 				old_inode->i_ino);
 			retval = -EFSCORRUPTED;
 		}
@@ -821,7 +821,7 @@ static int udf_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 				old_dir->i_ino) {
 			retval = -EFSCORRUPTED;
 			udf_err(old_inode->i_sb,
-				"directory (ino %" PRIino "u) has parent entry pointing to another inode (%" PRIino "u != %u)\n",
+				"directory (ino %llu) has parent entry pointing to another inode (%llu != %u)\n",
 				old_inode->i_ino, old_dir->i_ino,
 				udf_get_lb_pblock(old_inode->i_sb, &tloc, 0));
 			goto out_oiter;
@@ -869,7 +869,7 @@ static int udf_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	retval = udf_fiiter_find_entry(old_dir, &old_dentry->d_name, &oiter);
 	if (retval) {
 		udf_err(old_dir->i_sb,
-			"failed to find renamed entry again in directory (ino %" PRIino "u)\n",
+			"failed to find renamed entry again in directory (ino %llu)\n",
 			old_dir->i_ino);
 	} else {
 		udf_fiiter_delete_entry(&oiter);
diff --git a/fs/udf/super.c b/fs/udf/super.c
index c6e372d573885742745d3ff4b3b017facf228a32..3a2d66c7e856383cc5c8a605180a9582396ba805 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1166,7 +1166,7 @@ static int udf_fill_partdesc_info(struct super_block *sb,
 		}
 		map->s_uspace.s_table = inode;
 		map->s_partition_flags |= UDF_PART_FLAG_UNALLOC_TABLE;
-		udf_debug("unallocSpaceTable (part %d) @ %" PRIino "u\n",
+		udf_debug("unallocSpaceTable (part %d) @ %llu\n",
 			  p_index, map->s_uspace.s_table->i_ino);
 	}
 

-- 
2.53.0


