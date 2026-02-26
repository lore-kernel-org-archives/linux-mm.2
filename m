Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51FD9FD8FCE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:08:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B06706B00D1; Thu, 26 Feb 2026 11:08:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9D616B0143; Thu, 26 Feb 2026 11:08:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9726B6B0145; Thu, 26 Feb 2026 11:08:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7F1AD6B00D1
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:08:01 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 30097B7A15
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:08:01 +0000 (UTC)
X-FDA: 84487089162.07.3C9C527
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7D6E040008
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:07:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P5Qat2ea;
	spf=pass (imf04.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772122079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/HFDDRFOTrlf1nPQBCWL4HAaSGnISpgl2kr2t4LoLgI=;
	b=JbS3D7r8U/lhxJENhFIslZoG+sP3B4e9GXG+PFsgkueISCB5tRvaoXd1aIXAoM1h1DLDNy
	kYrGtxtcrYv2kPaT3UqHbAdJDZy+8n2HMIXaLWupIhextBaH//ZFtBQB5GThGpr2+5YVl/
	Kkm1Jqux2H8du1NYP7xktMwA6K7dd/A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P5Qat2ea;
	spf=pass (imf04.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772122079; a=rsa-sha256;
	cv=none;
	b=pbvgVZrOlMJ0BZAw989Sdfj5+l9RWBPKVJu6uay+IuRtTRx1ZyASNi9a8uWZFWekUTtp0W
	ayzeWMaKArNHalsWnzRAgL1jcBkVWVmAazNEmmJ0VlDU0yBeeAreLqGsu7Tr+esRLJoxH2
	dtkPD6RWMxUahDShg+rFoclghXn0pPA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0885F60134;
	Thu, 26 Feb 2026 16:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8EBC2BCB3;
	Thu, 26 Feb 2026 16:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772122078;
	bh=fTlsE7xIWGKtPxu9A4dIX/2EfFegpqcLPW063s/2aCU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=P5Qat2eaWeMJWSNbtbPb7TpssYG2R9fYa73uH36IJRKkrjh/Bv+fUfpwN6cP9WDq9
	 UT4+i5Gplk4UtP6zP3QUJ95kSeNbpg1idRA3kc/O68WXwQ3VtlA/HFA6zMAAwobJ88
	 MhMK5aZ9YYDr+dTtfzliJkxCykXqTGOn2lyIJzveFELASHMhX8mb3bNd9QYi8cYmeV
	 avQAyurn9qwP+hebKlrqi6PAtiUo9AZqYQNfMY4powCPRWIebRYpLD43nSebNYj1Hw
	 BdzPaR1JP0OGe1R2ueyC7P/JMDMQsO2oQpV72QpsrDqjDNFAvatfTaCDrYaVhhTtk/
	 UJ2zcdhYUN0mw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:58 -0500
Subject: [PATCH 56/61] dma-buf: update format string for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-56-ccceff366db9@kernel.org>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
In-Reply-To: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
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
 Martin Schiller <ms@dev.tdt.de>
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
 linux-x25@vger.kernel.org, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=837; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=fTlsE7xIWGKtPxu9A4dIX/2EfFegpqcLPW063s/2aCU=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0SMsGdpHT/6AyJ46OU8MjGpSyFuqiOdnoRG
 f97y3cZtQ+JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtEgAKCRAADmhBGVaC
 FV5GD/0frD8N2TX7MN9ww3xhGZMnd4dWX9d+yK6vEV5xACRIttjaQ2/Ik8mZ3s6QPAhMBo9E2/Q
 t8hsDnDufvG0W+XVW1sHNUwxNxVSgFNW5CSyRnV8G6AmGYVP1RCNqp3xYFXm6XW+t9FEmmCil1Q
 cc4UDYvzQskcL3uWsEFbYgkBRZO7VHcmjJIzmGULLv7LHeYGjldonwahUsaUPOidLRuLMN5sDWS
 XNtG/abqnOGQXl+g4W2wGBgADJ4VNDp/mmZI+Taw2+hyoiE5Pwvj+PfTOuBoEZVt3blA6zTfmcg
 bU08yjsWyKFleE1X7lIrRCA+dPzSDfdtnJMQKfQSSTm2hLhz4HVku/YYqKILPPd3xwGOEtvB1ZY
 JDaHMmHUGAFoZ4zSz9yQi5PKTFkSpHKjS7ddZ9SPAAF5PEnBPpCv5BApbrq8+7kBbFH3Vmh+GIx
 W+G1+Nhr1IR0jIQY4q1x8bZUOtbtiAlU0zQwv+scQGLf891dde//IjznORtfE6g0QclGRHS3UJ6
 YTm1cYrCjF14aSUiT5QGghXtgzer6uOrdXyKjuGOFOc5Py4660JUMayozrKUTgjPdRLimGMNO1M
 eVe9CVDJIN5mKJzi2B0ZO8jK2PXzJE3gH129N/iSj10aWI8Ut4JNlXdM2kTn5CUKiWDOAW6PP9B
 5THgnVzAVl5CBVQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D6E040008
X-Rspamd-Server: rspam02
X-Stat-Signature: j4ifmxzk345r9n3twsk9dmfjr3zxb8qe
X-HE-Tag: 1772122079-959352
X-HE-Meta: U2FsdGVkX19uw0AKBp6ebP2yvUFWo6ab01Xo6X53WsWRhTeyJE57EOw7cKsNNUUcTgOlk/ayZay7D/18DprFBaF+2Be3kfwj9/HjTldYtxMBQcMo3eny2AYDAR/X4R6o8G9v+8XaeC2bsFKbEr4TWVVASraP1jFzx67UdAg1QGRB+7NMhz/9uFIki3Fuyf/ehlIM7yEXbDe2R3Ske7WtX8RoY/hvfa6XPiJBYTiIqlRsAy6XQPqLcSWFCDB1dM4tGGmq1uIZe1WMMj6nxdND1BHL5xjDuTaVBU7dEijAvmFij8n7ow+XHhFUPCzEeZ90RB0RK1QtdlExXkBeAW5TCF1CxlUIk0qrlv8IJp08PXQtnxqwFUvFZWAz42uIbUe2rtL11hCG9h/Qunh3Pjku6M88qeXuwMrGFYRHYnCC08UUF3kdzjVKg8ErX5jx5MBaPEykmMgCuS/iiTyojFxhuswQida7gP1+BQ00AeW7Un/0CtnbiT/mpHLujy4dUO7jgqOsEw4lvSUsXHRWS9MCbJvGmstkQ8jmSmWpQTNPravS9deok+DUjMKaxmOW3b5IkoIJAhiJUWJPWjbJaTVzDdQRpKPDbTWmn9Ys8y8Hybw9WOKsrEMsenEPiVkD+QKU9X93sz3GSirn2Tg/OlG3Gu+wna0vPferdbO+a2y1ViQZDINQpLQZQBe+Cgih1cuMjI5ws2xFdOM3lTqvPkafz3UB0T2LBe8Cu7Se+TABhd2XciY6j3lSdV2M71opYCcHPIAv1sa9YTBDSEwyXeZ9JtGZMVwEjSi5yFQj/9GkcfbenqFHVFFGwb3y57FO0Db68gEZv1vHmb3ZydTxH7fzdNmN07ONr2tF+Yv73UenGK8PWce60HjRtn47XytQHbnOIZsKiIyST2fhjKvPVbe/Pg5rKK5TuHwzRR+IYcV+SGEP5JUwhR2Lafz3aq0z+hegxjy1KZCyN4CCUZUkO+q
 bWd6Gdug
 yNUj6BXrS+wraIqnP4sBymmunO4O4uHmkMPg7E3RCbCS2/WB56OhmdjlqSJSSf+eFmJtfoSvVkswy38Ory+v8OKzmcyXluyJprIxO6PiLQFcv5RB4cEM2tlrV13nFnRt2D77SC+7f28qprel5eQ6oHXqob0yjnm4sk8LLYFj3fGenixFQBgAq9y3/r93BprP34DQNy4bH1ilZ/XdQQfYQnbszwjP70Q66WgEvFzKzJQzDMaZ4G6tNymHU8JjdwMzX5vdOUYhsCiUjxRPTN38xgEUHn170QWCPQrAGHhrJIAH/N8W3iZvlWyv+0LgJBDoZkysZct69HjnKnFX+j7lym6UCXMNW4ZsCOTMeh8wnQ4UiL9VOLR5izJGperGwWYXFzmuPUspGVPg0YtQMEjHwbqvkcQzyHKCTkOOGQknLdZ1Nt3t3bG+So1sr7SnqEkfISoUEJZndoaKTK63RE8wlWuQylBMDcz+xaTIuBErFe0hiqC8e70GvcJPWcPWQat19yACkv57irxtNgA8SesIFwYPmMdQyoxPr6c7e7gbat2pcr4dGV9MLsNGhAKld1pIhN6hR41kNUtWcoknGEUtkOBQS6gla3KhD2HLJVUZKtZjrdyii3ZIass/hSoCRlUFYgJxo83CuJkCw/DgWBhmu8UmJus+TCPWTPSqFb3AuG3AX3qTykSrj0TGJkgpNTpN6p3AmCbhNJejwV/M3wTi29rxlFiBhqqihRpxLMesC5+k0JV2ZbS+9K4C4kjPwXuUNlI6mmYtW/C3p74qM17A7hrwxYYIWezB1GMoPfigd7i92dcrjveKSqCAL0WtTckXaYKCn5Wp6n+M7sggdUEIwwXQuLJ3013tf3rslnbVHqZ5gVeVIuD7Cygxs4/opyYF2PJ5K5HZWbKmxMbjU8Cz5wXkRc+egfW37O4P96Lk7rpVfQ27gUe2/j51VWquDFu1XkX+liICsHKYfIL6RUqaTFj2AtShC
 7r8ef/iB
 498l6LT4LIwDWpiWK+3ufHJ9GTXTM3Xv1Guol5482aFxdz3jfBUlNoaAaI7XD20MpNLrrp45ElTDjSC48M8woP5DZeCMlt6/uqytY+CtCXl/sIzsX5mOhDRcRJCK/voSIeL+uW2HJVwlXce6h3K2MizXluqSMl4+63wOvDlwmoWg4UrbQ8wP9d0JMtg4vk0/DYanM2o9w8zTO/Y+2y8ATGjtNevftWTpSspCEOclRNsWa0TlD93ckepNZbMaAg4ujz7ijyjgA7wOxqkVp6Sc/fzcaO0qltLvxa3/RMcM8D4xZvDEMlktk63Ss5yZYUaqEo/uR4pK9a9SR4DxjQWYSV99SzKvDPjAjmNKFLf/LQVHe+CNJy/QKYf7vYN5HuxzZWxi0iPYZtNw7gSDJHjdODyBDDDZ9ThWl6SQwPiPkT6PHaJVqczXLTy4+G/RYvbLrAYa2Ow6HtB3q2pnB0mJZbLuqCOaywGxS2KqHTAkDH9BTHMisLSLS0l+kFG7FR+LVwOIs45maxioJ/Y2RP23C+xaSDz5L8TFMd975uvV61qVz387gwaPM+e/8vpI6yaEWZdUtYG/vk9LTCpKQFXztZYuuGsDXEZX78sYLGhEPLAJCLNXYXlFQ1Bv8/pfT+YAn5/nfKJinqZdtClEbn1JMg7oRfMx9q9GkC25PcOCDa5R166GoTOyyBR7BKXiyzShH6Gfmu/8GvzgszipbiLldRiXopmtmZhajjSNPefg2wgd9gvMKBT5cQKf73V/MXcmLNtUhKVyqX8DHkUZbPtkBxpyTIiY1DwWCjPs4QqYk/9D9kX7V5RFQb9jRCnWquYIgyDvLUvhyG0VcxCcdaGOo0QdUDQobxpQCooBgrqdXVfykYxtH7o9r5+r80CZLdbvzXRkkmYEgPXhAZFwzUM0ePIYuxMwDDxslNFsoKocTZ09sqpDEi9mUURimnOsopL05UoLlwvUTQKHysWDNUC1DOYfnXFlV
 H/1ZkHHu
 L3+ca2cuFzjpAGOajQ6KBlHZgmMwoLY5holw7Zo6Qkr1++gVlBHpoDEin33lDC3Q6tntQbEH6ST7sZFfWdFMi1dDlkkzMzeNCvYhOi8HksktrK26J5zs54DhaP6K/w3wNsYgOgpAoB2QzVO2SsrPExUrfVT56a8e3oTUvc3WvCcO94xbtmhuCDJNLHgRSAnpby1L9ROpZgjFtFtH2o4xiabtDBNy4YKA6SjSBWum2EImac6N2pkn2scE5nhxdIv/2V6GaQo9GW5l9vaf/D8Jmrbn58qv3SMyChQ2gFBMymaXK4SozxxBJmUCgGX65E7WzZ+rCwNgT0dEZvbHaFs4EyoZq3gINSb/RSkgcmbBa32n/Sc+U/mJUjjaZRhANcanFeNWOdpKHg6qmMgr1TIcixWQuPTaEI1HsxX2zIf978qMbPlSUtCZ//m9fivF9uONGVq0aS59iFj0UKfSIwcsXpLcsOvYCvV15pr6PY6qJEX+V3rc+xvXqYnnuo7ytkXddNFcJUk6L5ZlpXabWHliiA7IC+bo5y1HW/cWyLo9LVqTzs637ahPK8tl0dzIPBIpuRKwyrQzNKDBFuemekN/EXB/WrGsnskkVW6M5Ddb4nLBpv+SmQYcznZAk2+P30EwASu3bDs3uyXqMOWojo3+FTvWWTIWF2HEYI5/zpb601LbzL0u6c4CSSSbIyHtLbRCYdwDpvuGrKVWhd8+bWBoEro3ZvQQXev6JwT5RNtu4iX/GmdgC/Qg969tiUruIU2T9Ga/w0ITd9dRWiQ1DFS+Zx53Rq2sI939huLjq0LSEt3AVXfX9WCwaPIyqTF6KGstz//aXasbXrAvhPtosq2k2mk/iCQ6TayFbVbatljkGVYvYKp3WteGdsZKsKdv2FNcAi5sODdwSc7XXUEFJjl8hKCopRp0F5LuKTPHm7dQvos2xC+mL4v0gyJiFSV3e2YpTUvt5ZZ9XDnpxRUrdmCXi/1xX9RUZ
 WChgzryU
 OnS1IWg7ZAQ67Ks7rCdc7SVUGBHGSzNHRIG/1MSLZZovCwXBhEyOSbGEOneU89yelOw8RDY6kZ0/p3zoeBqtv15I55YbVXYFUKmHJFxBSbZvxfjBltP34hfW7KGMl9yXdRwIB4FJs2KNErQV/jVLz7EfIjCBuAtzg0xiCfYSPfwR7fUVI7e1gqMIP4FQdp8t3SbqUReIimJE+Lawyzo7U7Li83dZ5HOVzRRzOIjK2ynd+5Wxn0+fXm7Q+0Wi4UeIiaBXY3FS8qYZgSSDasSZ8SFix1pUV/DX21Q0Ov95dGADm6f+sQcriTIe6duzqf7k8cEZkQsd+wapRLevbE7kCfgZWUbYalcc//bGR8qoCAyrddF1iH192woLeHRgPMCP+2oElViWJKMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update %lu to %llu in debugfs seq_printf for printing i_ino, since
i_ino is now u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 drivers/dma-buf/dma-buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 11711874a325b954940fb289f09936de0152e683..8c16c8c425cc84cf379d7f790d054e140471c8ac 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1708,7 +1708,7 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
 
 
 		spin_lock(&buf_obj->name_lock);
-		seq_printf(s, "%08zu\t%08x\t%08x\t%08ld\t%s\t%08lu\t%s\n",
+		seq_printf(s, "%08zu\t%08x\t%08x\t%08ld\t%s\t%08llu\t%s\n",
 				buf_obj->size,
 				buf_obj->file->f_flags, buf_obj->file->f_mode,
 				file_count(buf_obj->file),

-- 
2.53.0


