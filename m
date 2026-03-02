Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12F02EB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A3906B00D2; Mon,  2 Mar 2026 15:40:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76DF76B00E3; Mon,  2 Mar 2026 15:40:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FB936B010B; Mon,  2 Mar 2026 15:40:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D3356B00D2
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:40:52 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1A2AB16032E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:40:52 +0000 (UTC)
X-FDA: 84502291944.16.E149E81
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 33DC2C0003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:40:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m+cQsJz3;
	spf=pass (imf22.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dT6fK/x+4Bt6qo6SA5ClpthLnGEOvYOzDfjZSeEA748=;
	b=dfq5P7aFBWXbKeU2kJ9QZ0PVmSd4TFNozg6JB3K+pTLVuLkUciW8VcZwa3EKaVARnLd2da
	LjA+IYUdG9Ewq5L47fVQF2/ZAeNnEvHS90fHa5t5UUeQhioblA/ba9kl1FuvbAkT9KH2el
	yFsbmqtgw1MoBH9GtEY/+7hCZrkNaOE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484050; a=rsa-sha256;
	cv=none;
	b=luWqDpEqcQ8lBo/p/ouqenjqy6/CcbHoUzQzWZ1RY3v7FzBnRTgCHMRXBLEkhuoa4Fs9NY
	eUPq+tAm7MggLi35fMW+Xz4aIQklPfOE4GEEDDCc8Dcq1d5KS8Wb3ZwRFVl+nmaX4DvCtt
	9YR0DA43vQ5KIuc9z+q46rhBZQoCaLA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m+cQsJz3;
	spf=pass (imf22.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B159415F6;
	Mon,  2 Mar 2026 20:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD2DC2BCB3;
	Mon,  2 Mar 2026 20:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484049;
	bh=HyR4sniz95teBoJHWgP/H2+rStT6qfCUCVZPgmMuwcs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=m+cQsJz3LSlySQ/LkV8g0UkbIMSqSvNRtu7xio/tlhYMu/YSnzafEF+V8yjx+SjoM
	 yl0M/ozfu9C0JcgOkGK/507Jp7sC4ljOg6kEdREcBn4IkMyNyOJ4T84BND1Zg7v78x
	 ecHvzizX37InYHwAZdg/VtThEzoQyj1CdG+IztwgFiQ6MfW/1qLXGYYw+CWVbCT3b0
	 nGPk0wgOJFoUd918Owmtl8+//s429jEFvcNcVLX+GX0/YsE9Z2aPE0UNuexhzbxM4P
	 gBngfBKui4FXJQDOZXLnIHPqvzn5fUbR/gxU02itW5JApfugQvpKnJGfTWDqkVmMnz
	 /I5TauxXOf9mQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:50 -0500
Subject: [PATCH v2 066/110] nfsd: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-66-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3151; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=HyR4sniz95teBoJHWgP/H2+rStT6qfCUCVZPgmMuwcs=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIA0Fa1714anVwENAiRmnB+U/0TA0CuNSmGy
 S5/qF96pyOJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyAAAKCRAADmhBGVaC
 FW3MEADU+whCFtqkgurCGlaONnct++YahRLhSTluVahbwEwdjbrbG7/7TsgiZPqagHMLlQ75BmW
 ylyzoMJID0RQLRuriVYXFqgM1bsGBWwWUE5vQeLlq/U6V9hQ14AflkyIYQCaxrhsZ/BRchuJOVe
 YGfTn8zZLGQyhgcOMKgJPctCMtYNJI0dDTP+TdxEAXO4FVzGpuq4ISjGB4rVspIzqwJZ9vTDDeH
 RaPDWEy47VzON4mSIyPGs2bMeKXmNuzabCV42blfkozkCYDmWnCoil2ws40UOZyww0F2inVxIm1
 biCcqKW/4hLNP+Jg6A+FMqTdqxNXscogSoAZzVZ8SHrisiZqvfqY0cwdhGKoIb3oPmZzfohHl7I
 bEk6mxpcNHe0P05heIjqcvKOXsnJUP+v4/D62nRiOfEtOJny85qobmr26MZxCVFiq6a3Ct1b5mN
 y1XG538Y1/cHD9aEh7GND7hy1awXpMnPjoVqIjeMXMSRKNn/0LY7Be9TT21yUHp+08h0uxyOnik
 1idly8EzgBBEw1zwwIybPJxNgbwUjqF9nlUaZ1p4VRHFedCPKrra1FIbZuRVqhQU4P8fHZ0BwK8
 mTiKztWgspKLCYLbVwNJ96kS6/jElrgR3RBA/IxZyawPb5WdB+8xtUZZoi/8ynJDTOwOB4MOfoN
 M20Iy7wAit/xe/A==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 33DC2C0003
X-Stat-Signature: ng94ems5kmhpfs5xwdinztfyxteuhmrt
X-HE-Tag: 1772484049-292106
X-HE-Meta: U2FsdGVkX19Mhgd8byyvS6kbDwi7mibiXQ6JEsSIxzUdSpJSIZmh1mCYXb/HjIkDlmo/vCEDdNb7283r4UsiNzht8eEEXmjoeUqK/HvF/DhpB8yJA98UV6fxaXZ90itw4sxDK5+mw2t777j213K1qbseWF27qDcFwe3ARpunZHyQzvzJ6jaaRA9uJFK85UlUAXSjScMqyAIsQvE0YPfM5hQlEPj0OqeYTn4hWQ0+9+6Jk4TUWHsV9IvRvLxOZFAkacwEekK5Q8XQ+CUdSGsV76sKJH9YnaqPfWtdO2AkmD5o2aRhUC7ve3oG1P1t6f3tc2oO1tkhv6Gah5M6I8Lf2lwV0qCViJZCzcQIizotxL9eBmg0bHkamTjQ+jSjibakzJXPLu1iZ6sb5+12IYineJ1u3K/udkITqD6JJ/LfkLU2ueXlevPxbdUhWDQKOj06EBPj4WD7+NF2eCLSgta1ud43/ruqcbMqeM+4CjeVBUDt0Eab4+lyF6WasYukWVIl+oCphRwZDFCNN+zF4vXcikvX47vpmiDhuRZphlKSyQ6Hr0fIJSkgpMHogEFhtkE89MBnhKys6weeDZgplGs3xjJjh09gBdjsneZyhDQUdCJGEgkwPTiQNV9mLvDGSb+aD4Ae3nkLcI0JnpT94pPMXtjXr8guzhEIcgM1A5Hhm37bxD7kWRL6T7acEPYzFwiCgfhEeG3z/OKxGVKH4orvJ13K3fdaQ5faDsyeGcxPwd/1oPLPgeFXe1dJCAdrFQvMdqVqmrXk6PBdv17+3Ohhkykx/VOMbvYrclDmjX8X4XlW0kR9XNDRaHt3f/TcbvbtJS1zlskMfjVQicJNmozzKRTFQ42dzBzOGIwz319tMqv+krAYhEppfUuOo9QmOCZOc04s35P7b7QNlPvBDKxVcekRmknEVmRiLKn0sYjC2om9rzkC6Zf0I7sVZid90M2cyg1J4/5jDYXNlklAwXY
 zOdh+NY4
 CsyESfCq4dViGgpMPHP5ENKNrcu82vg0rd7ovk8rVA3E+1mwgsRxVWz0DQOe+mtWqIsEOUA262kANkekc58EfGC1bT6GCJSR5nTOyauNTu0MHmHmVFXDEJx+nOqOHm2+cfMzp1SyqQ5dyV8OOjMGKaqxdziftaUWr+pC2kkFLzJy9l4C4t3Nu8pG9RN8j8uL9YNrhgaSIg54gC25kmjXXFKdGJSY+SEkRal7fNhTURSN4z+HZTrqI1PahvbVrk6ZQf3KOYdBaCfbGT6K4HaEUYptnk9SGRMxUpoDT3i477tXLZyH5HLl8XJh9bLQvyUCQVV0IcaLaeLsheiYTPLA6fsToutcEfYyuYzGt+kx39pDhbcpRX23bMFO9jbii91E601a6EUrBZZpjkYp5rmzZkqfTcLcQ2qw379CBzSRMvaS+i8y84PRQTAvrTq1ITPjSRHu26J3t7PsBwcaLYl2ynBFxPqTdjzjbZCWfCf0sz5HhUqZjSyPDJfOG7409JLb3NAexTRt2X3IGZngi/OB9SEpI3gIq6sxnfHzIQvVWGzTK7DWnZjXc4kVXAF11WSnnSww/ezWAAqXJmWmwz+Gi98OjncGdOmLuyJjLI8zOm+z5SA1al+LVF0kS+5H70BcG3XPcTjM3pwChshyAA+5i61qxCuwsctRIm8cGMI+8TlGLaNY9/k0oX+rWOB67IZi5nlWJkRHpBnJ7AdC/WLDz8VEJm07sQh1eaZrkHfUlTos+2AYhOZwkykBc8gQfhlWUXqBvgDSTZFKRXA3XuCi97D2wuZhUTBsTN2FlAzGLZcwzaC5itpgj8SuCNNUBZm/5dTXiWqGqnEquFgvKd8/oYRrcaeaNQdrKJ01CmtMydP9zELH8VQXQKC4M5lIYNjq94Gy8lUT3UN9s4pGM8mrYnI7KdmsOihJm7ApOeYI2lSpceLtCMxno0JjoJ+SxeyFAk4YBM9DDWMnP1WMadlAtStxnWgyQ
 Z3/p+2k8
 zC6jEK4X0/1gHjF/JNmENhvBYE0fxgDsCNoMvCOINBsNeHyEsLsT8bzx75VSoyNgcQmM7M26qmI2hICbjkNGDfqbr+yd4bykflukIbfVV8pCBq/JkILOxZzNvZTXrAc4lPH+Q4qizQdotOvuxrTzmfh/5EiRRK3DlaehAjiQtpBkKp1Fl7PRWOMmH4lxBeY0qsOg0fgQiVX+yewA4sbQzkA2lc9yEHNWXjG9roIZWFMtUbmGH0GVlhUI3ieRtmXeOBm9Jk29UttPd3tv2fVUE4nf+ZyQsM5KTVhcRnP/usLkCq/uigefc/jenApkIaRjMIxpcAq2OiB1+OT7YnB+DUf0Wnp/5Xs/Uxc8iY7Vq/TEyN3cJwS+TmezfXIsit3oYoAuvB28G8O9V0icQjqVZhmg84OjPwkTnQF8ZhHK5jNcFoLtPttNeyJTvzwqUy97VdVM80vVFfemqYodzNIB8/3++VYMQnbaHnmsUah9fkVyjaHlkUIYU5Fp1uuQM0H0O6MbpBs6B4Ecm1pkp8f8EEhMwK9xqojekBW5TFFvTXIel3WoDfnijl7Rq63vgnbcRrXb94lev128IdI5wdcH+acUyiSGzfBVxLqxrq5ksCNliVCQFixcwzXxyTjK/iu5h8TtOoo6o93x69H2bopY6mw59bmjEqG2S32mtoRuJks+NXaSV/Bnwt3XFThOSUN6sw8BSG3w8+emqqNxn5MPw6gPYHFbjmQtc/H/ALnYtPV37pP3qMFV5uX4nIDSm0XdHVCOTrIQpKTuCFk256ONB1zt0hXzlF2udvv325SNGoO/htjC5V6mHHhe/Z6rxsrSw4O1T9qjqYEi58a/qpX15VfDoFUJDkPjYnQFZ3LrO0tCK7ksgCbH5zeBQEYV//4OMitSLTjN1Zc1A2S3mFMWm0IIFPtqyeSQgPUKGAIfj6KBvvRw/7HqhjgeSceHMcDET2OIIa+32epnt7/4I3uK6WpiZTfAy
 xQ83Z60G
 Bue3quk+6rXiat/nfhYpAuoG6XCRCu6JjhPFF3BRRCIhXLCwzz4I0te0CVOxjTHHlYGfysgz1pLXRem+KA5IB7Q/7NiOrvjuPZvf/dmbQRdeU1FK0wKQ23vpE9nOaVnUctCFhlsj/gajVfJVOt3xWfzXUEhZVklCXEpaSa+Cn0AlHQXRHx4mK6ssZ23eyg549p8VZnDAYTuvXylnJJYTr6OtXGycwy64J1SChjajf6WIuZrGL+6IjkGZs1GjWKmW+ppkTRHtb/GnWKOHd2rD6lAxr4k8yPbHYKtuxPx353/xlQuq8/LONRMDmd+G2PcFeLMvWunz8DHS03xeGnvwTN1KhrWP5sEW22hd7zH/JvLnbG+wsSbeaMXHyFQeJSNoLFHXwXOMSKUn5jE0e9zXMklI6WTk4S3QHBDrKdrxqe4vRaaz2VSO9Wkk5FRHwpXNV2Ihlad5HG/7/i8ZoNi7o//ggFR5JNaEcyAhSE3MS0MEmc/HDphKQTHcXHkRD9d4hRqPXQ+vF7bPZi+8g9JWUhTxTA8+y0105VD95q1sYgqQfCDQjgSr6vcFHtuZjOnS+Hk+i6w0dtoBAVygOpW/Mya5xO7Rbltzbd3FSZxf/XmectB+kbTKs2gCV68K87oZrY9t6lzG77lBPiMxjBnLyBkbPWNFqKSqujUiNANSmPjCcAR5fpFgKLZFRXRscgG5xFoNSPSfBAWDyOtHJaXNxJgV7pUR68fkOxj9fHr0+GehtqRaUC3ICSaUwsjNszeBKV0A670SL/jpJdWjn91EGTVm+c6L1bzBaq7ErRv6st3mcNYoT+TtRfSWcgLVStwoICOI3cqB+SzQ3ZMNUuH0bQJvj7Qx49k2rBZBKqxd8H69Ml/QxENI/bKIG0In/VkaFNVTo6YVbjFAs83BNU/TgpOdaa9PB2YD3S0+JaTBBYmmsaAY2MydnI5zDQ60N6Kjs+eZKiscwX99GpAkFkJY7z6hR5MQU
 N5twciX5
 J5Xi1SS1rm/Hx5MKSr7KFF18G+SphuBJ0Cf2OSIbgPcgbthOm4fAI1R7ConTs28J29mT8KGP3XI7ETOqWQsXWn6HTQbq4daSBsMPp/sEQYfMHGRnJD6EQ5Vl3YfIw2zJPtBbr66G2XYzwiPTfZhao4q7Zwnrjq2kDqVazS+YNp4XlTxSUav7Ick+dDzE070ROnxuZfIt7lUw1lTjANObgDyuaMIcoIKG/nGC+nB1KaWEuXwisR/jqA0Ic4ijr35qTAl/60JxKN7TNiExp7/vIcvnVyJcq9v/bfROrZseS4Ddqs++FHKOM0hYs1F/vGk1hja46W96E06WzbPDU7lXWMS934CCAz/Uc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in nfsd with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/nfsd/export.c    | 2 +-
 fs/nfsd/nfs4state.c | 4 ++--
 fs/nfsd/nfsfh.c     | 2 +-
 fs/nfsd/vfs.c       | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index 5dfdd836bbb63d6af17204c8df7ecf3f450998c2..d2259d948cc33e1c192531d34679123b826cf4dc 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -1039,7 +1039,7 @@ exp_rootfh(struct net *net, struct auth_domain *clp, char *name,
 	}
 	inode = d_inode(path.dentry);
 
-	dprintk("nfsd: exp_rootfh(%s [%p] %s:%s/%" PRIino "u)\n",
+	dprintk("nfsd: exp_rootfh(%s [%p] %s:%s/%llu)\n",
 		 name, path.dentry, clp->name,
 		 inode->i_sb->s_id, inode->i_ino);
 	exp = exp_parent(cd, clp, &path);
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index d9d548225afb764326b2bb211919e24c87f15a00..a569d89ac9123d66bb47e7d74c7c98610de21da2 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1253,7 +1253,7 @@ static void nfsd4_finalize_deleg_timestamps(struct nfs4_delegation *dp, struct f
 	if (ret) {
 		struct inode *inode = file_inode(f);
 
-		pr_notice_ratelimited("nfsd: Unable to update timestamps on inode %02x:%02x:%" PRIino "u: %d\n",
+		pr_notice_ratelimited("nfsd: Unable to update timestamps on inode %02x:%02x:%llu: %d\n",
 					MAJOR(inode->i_sb->s_dev),
 					MINOR(inode->i_sb->s_dev),
 					inode->i_ino, ret);
@@ -2888,7 +2888,7 @@ static void nfs4_show_superblock(struct seq_file *s, struct nfsd_file *f)
 {
 	struct inode *inode = file_inode(f->nf_file);
 
-	seq_printf(s, "superblock: \"%02x:%02x:%" PRIino "u\"",
+	seq_printf(s, "superblock: \"%02x:%02x:%llu\"",
 					MAJOR(inode->i_sb->s_dev),
 					 MINOR(inode->i_sb->s_dev),
 					 inode->i_ino);
diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index 22df07be0650d9260a30e12c1371ccc4f89234db..ee72c9565e4fe85356674b22b4505d3d531dbe40 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -601,7 +601,7 @@ fh_compose(struct svc_fh *fhp, struct svc_export *exp, struct dentry *dentry,
 	struct inode * inode = d_inode(dentry);
 	dev_t ex_dev = exp_sb(exp)->s_dev;
 
-	dprintk("nfsd: fh_compose(exp %02x:%02x/%" PRIino "u %pd2, ino=%" PRIino "u)\n",
+	dprintk("nfsd: fh_compose(exp %02x:%02x/%llu %pd2, ino=%llu)\n",
 		MAJOR(ex_dev), MINOR(ex_dev),
 		d_inode(exp->ex_path.dentry)->i_ino,
 		dentry,
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 4c2095c83503e7fddc7e1ec528f55e36b6a326a4..eafdf7b7890fdee55ddf802d040363f33a7be628 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1163,7 +1163,7 @@ nfsd_direct_read(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	} else if (unlikely(host_err == -EINVAL)) {
 		struct inode *inode = d_inode(fhp->fh_dentry);
 
-		pr_info_ratelimited("nfsd: Direct I/O alignment failure on %s/%" PRIino "u\n",
+		pr_info_ratelimited("nfsd: Direct I/O alignment failure on %s/%llu\n",
 				    inode->i_sb->s_id, inode->i_ino);
 		host_err = -ESERVERFAULT;
 	}

-- 
2.53.0


