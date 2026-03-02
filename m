Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D9CEEB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:40:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3FB76B0107; Mon,  2 Mar 2026 15:40:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0B306B0109; Mon,  2 Mar 2026 15:40:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACC546B010A; Mon,  2 Mar 2026 15:40:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9BCB16B0107
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:40:23 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 686341C2FE
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:40:23 +0000 (UTC)
X-FDA: 84502290726.05.C00AF69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 841051C0012
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:40:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SpeNrNds;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CRmI3B+amSuuTrvqRuO1bzuBh04fGOwm9KAVrnDtzu0=;
	b=uynhQhAIBllH0yT9xmKjqlJkeV1C7BFzf3Dqft/VtWErHBnn4Ug3x3rSHYZ3r3QUc5t1AG
	mx7VpApMKJeQ1+hLwEopShiQ+ZATJUgTcMSYgo6T7eueUQOiwDhl/dzVAM10JmF6XPVcCB
	FNcE5UhYhCFfZfQWVRSXZOUapeIiAMI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484021; a=rsa-sha256;
	cv=none;
	b=x8INKypRH7kjAAohqpXcObrIrj7BJo/yfrrvo1zf+3QI0IS0whmKnpLOpkAq0X3m/i6ejw
	LnQdpfM13fZNj5kMW8QWkaxGZt8KCRIGJHiQ1U0dK9TDNTYkg9e8Jqd6Lv4h+Lr+ZwAYUg
	2tCX/tsHNDVZY3XnQk3z6pa/A0bX5eo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SpeNrNds;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 976F141A4B;
	Mon,  2 Mar 2026 20:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6095AC19423;
	Mon,  2 Mar 2026 20:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484020;
	bh=OF7uSlUo6C4FfGcZ/A/G2ejJXiIFafXdHzMLPEkSHxw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=SpeNrNdsWmclv+sNLroIWVAK2THmien+wfYWh+QS4w18kIc3IKJD0ZgwlQKglcIfM
	 iNgfMLYWPMYpIhn6uaHUsIDFZ5GDjud0bfH2K+gBBip5kamPtRSWXaclntYbwMtKCG
	 UcgmDgh9J61lpoDFLl9qC7fXnpjJczkjp1hznDeVj3LUaa8adqR4wTHPVXr4RgKFAI
	 W5Ke+6C/JPVQPferAYmluBkd45YRK7YkvcpcPNFLMdpVkiagwGYcpg6X2e6tp1hj+B
	 Lm+PGhhtosj3xSybl+9TvyCmWExeedc6Bd4Kw0LckXNc1diwNacboNH24PznkpF7nG
	 YlQaVTsAe6iKA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:48 -0500
Subject: [PATCH v2 064/110] lockd: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-64-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2478; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=OF7uSlUo6C4FfGcZ/A/G2ejJXiIFafXdHzMLPEkSHxw=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIAbn7eJQi8G8YpuSI449d9QIYS+V4UNgoQk
 ZRiRrv1kZWJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyAAAKCRAADmhBGVaC
 FUWYD/wMLf58W6HxUg0MUydpCPTRvW75D9+kn6Ow79eNh8L1eRRfYift/vG3IruJ+wniCtAGH1y
 +Z5uZliy4AGEeCxwr1Qc+nfkdzNVysEq+BIaqhBSmC89Twwc/53lNZ2ZbnNetZKa/6I4zLE0HmD
 k2D+AoBEPPXjQ4BNy/UOHfA1EueNsMPdgb6c9vaaoKgwnFs1FWt87Qu7Hx9pmrr1Vn5Ieqt9mbt
 nswtXh7uRraIFLWlz6ZdrmGdK4xYdUJ+WVn20ePxzT++rb6Q3CrRPsarm/rIMo0Z3CcU776M5PO
 8zL73LVv56Z5QFXcbfMavIKWymGKj2zosjRYWKuhioL1+cD/afym4fh2AVMJtUk4fGeeielmjW0
 ZoAoz0dnn23eefPrxL0Op11k84ZlOlm/m6AAA5CZv7/hHFfm1Qr3tczELFc2/za8NCmfyrvGkd5
 VbrI+tmEEtrztSZh1le4rEeEJvNxaDVOnQpPV/Ttu0twm2Nkmk6zZMwgxE/CwIjLS0KuZE1PAY5
 zLeVdO7pSfTOGBSTUwsihXfMjiDeCJ8Kqz/b1I1mgo/krqdQYCcWVASRr7hDWXLJXwWzmaLcqD6
 6PGxG00rMcLsLohfS9cD8pk1ANYeh72a83sUhTfVNP0BavgoJ5btN5phrexyfelGe4OmYYk0w2e
 X+7/B9mCJIywoiw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 841051C0012
X-Stat-Signature: tc7b6cj5c53g5tb8a1q9m3omod9gscjt
X-Rspam-User: 
X-HE-Tag: 1772484021-390141
X-HE-Meta: U2FsdGVkX1/+84gvhBRWF/KorweIcw6obHAc6GGul7MTThyGbEem8iqMpQ3TQHvp6KZ+gzVMeUWHBaGFP794gZy/9ANR4Mpsn8GV3Q14Q0VqJpgWt4CWMOpw9t7pKUJMfCam4smv4ryxaZMs9yTX+BWdO83Ol1adD6GJ+cEqW4PAVrdZxJONmtsaEc/p/VsBXOoVzfi9icFLrQQcjvtpi9i2dwz3RYiEJUB/YVDA8nKYBKHEltnQaN8iNfHw7wfp0QXNVwnu+jXgudx+Ckh1WjVPgbTlKOExXEJwGKGkDhfW5TQlxJvDOcJZV2iLUz2TvHv9YXwSGsis1h4P2uYLf3pKrwJeyufqfequs2+TnX1qZ0sM0SuTTAa2eri78Nbecb+HBPLYiD0qNHdknJdJGicKuBm/wvDXbVbCw6WldXXUQYSpm94uqzu4CMMOiwyVb+K32CSCmhMIJ0J6lF+o8X3Z07pUYsukNzRU9CfnSxr+ArfkoRP05fG9yqUf7aHkm7qEcwBYQsdTej0ysXIG0ocMI5VE8ZYMWYqx9K1NcQWfYuWkg/0vB+DrGdt89q5ISLDuognFuCH3JFFdaGPsvsAv/cAxVvhCQGiHT+xUszb8t2jmrllpXwYnV/9ZSNjKmzn4yaj0SL7I2Cu5aUB+V3mHAdDGrvRyXRLfPXudQNcw0MjAwmIYq8yqwmhYBuRjNXwnafGovd8AvVFH1J5tbIr/FhxUN7Fo1QTlIOWrN+rQBBreTUtTCebcEsUG3ET2LTHQbf+EFVvt69wMLmc8z0ODw8+qlcKiG4MaCzXfgHsMI1WKSzHQaLhKRXuBI3U57xwDg8UyXQ+QIxqDXwViu3ucnIlGtXAre5w9941B88SuDUflVckyf5ZFsz7mWRdRbD2dOG9R8/yKQmc8jw3X1xH2OQ+puEIGQhAh9T3uOhIW4GrvqBnywCY5fvnedHXGsy8ayUBvW7Py7hv90zz
 zBWmsxs2
 9V3blCDi57xfBsGCrNgUWBaXioL0G4TCC5UWf7WnMZ/sA6JJo0bn8XfdFxhUNAUAC//hhbCKn+pB9o0arSSR/Djrhpc5DY3mYEp296J/F/Zs7E2FLBoILq6cVD+5gJa1DL+HV86hg7MSHu883S38uhUG416lU2joPcW6DIi0kg570zjqQEwMdD3rym9WGCeeqv2xzJu7vmBGX8dVUDP/o6SeezDxfdBtHqNnwBBGGiQtn5Ms+lKdAIrBaOYR54Sk3HhPacfh5enuPGwpJjSt5pBinl6PbUMV8VUTIF7825D7q/ucCPyPtEjYo3dOHqW6T9Duo3Jh+VakXxNzyIwUXb6hirIkmq+v+vc7RAFyuQOpSEOjDExP4J+4t2W4oa40UD2O/B/iL0xVAqMYI4Z18eHO5Vik+Ps03kJH5+alKyBpbPRLCQ+Iv+/SMH62VI5cw3HBj7fkOY/X3VDiyR/mNFrVgH36KECGit1hOCaBw8cVxAwGfeT/bE7jgu3dZ1RjTkYUCZWCk/4iDa25CkRd3RK3sHeg8J3hWOFVkQN87ezNe7XJr2y+PHSxtzQCzRs02SWeDkihNMNuCRjtc2Q7nNaxfAHKjnf/bN4pWZehNMnM7gxPyRC8kTWNoI1g79uzvqkRvuhmIoLzESaypjv/VSyafz7DaCXfKuLHPsOzMDj6TeHyD4Xu1tFiaSK+4rQSGzdEYdvgN0ZF/wV8QllKGevfaTsI6QZtno3eB12m+g12yVBcVIY/jqXjbVjsNzERx+uII3hKzSgymE2q9HoGfT8Tbl9MAmxFPZabWrINu5KsyD0pF7+SyHT5sbdu0SKg8kVZPPbhZJMafCsAh5t8tnw9Evh3tjztPSaQSvr9n0EP1UyDXzftdtmI4HK7Ujeq7mvIka5p5oaIQHp3/Heeqi7i9oMKSE9eZ3RO/beEqJLYkQDWMn8O3tyYoB/8iT30hKO3M2m9T9DY6kEdBgtP9OMmab9ae
 FzafdphQ
 fn+CdlTLIVB9YIwA9f7JAGVukmImn2aJziYESFTpD3uEFPHLDdLk19zDqX0t+4LJnZmVIuqOo8g4R9EHqHmDJxP01nZmcJtjukuGbjAU6Hdc7gGQioW9fVMosPlxe1K5FXxU3m6Uc1fTN7hDzssGcG24bLpR5dNTwzbgR7UYRivw3rbHdRUJKaplaiWw+37Qon/XAn80NOD8y5swplExXRD4Ee3QV7Ahqx3TrBtEZHPRUEKQOyAp63x/GTZsBwLuAnvlRyd9w+eRG+1F0FO/h9tMR32qyjwz9NHH0B2QDhZSPd1u1Lfh/VD8n03x01rSyJtRAIoJ7UmnzN8Tx/BN5rXsc9Rw9bJRXSEMUBLFIg0fiZpSqNohF7Tx5//AAcpLbmmzFE+B7lRz5GVN7gv3BLa5NKF90HTwtiqvYJdDdO/32df7/3fxSZH28pLNgDW3QC2PWyNDS/3l+BAalRQsu7MWsSUTB9pcncoDytP91J/ElFtUxRSg4ovDjkOJ6p/ksPdnMEj+haO7R5HgsuYPcPa3jdKpSswkCb0Azw8H5zMpq3E8Ez1IW+/shrwUiSbjdiG7sNebn4MFR+cwVXYfDR5ecwGLJWZYOSzO4BtZPaomWr2oz66anRT49tA6ha9J1I/n8mVrZJOX83dXRXyXNusTaQQhqUQMpaCeEIZJX9u2g7kZS9UFp/lpELTopXTG+5vWS+5Bw9toYpAQ4qi/Oowg/a2+553Jo9+gM5H9qU2yYF7b7dzf0wvHnKLzlgI7fPpFRx4jLgCPF397WybkpTF1xIWUAu0DX3bnQGR/dw3kluO/E0DivGF1q9B3z7GPU9l+DKMNErjULDaU5VUAjciq/V/5ULK3Oddjg/gstbTKXbugekSUMqjcGOoEnD1Rw6TODrp5L2yp9IwJ4qMcyYp5jn57nII1hA0LKcm7YZZ22zWdWVw4FSyuVhaj5mzNOWQ3F7b+s9Uwt2Ft9Opkod5mt3Vlx
 hNUcvyvp
 b3Wa1Th6y9YvpFfnEWdXcjvDQv9gavx5nG4EXgnmy0RIMKbot4ctuLzyFo/zh8GnsbI4w9cI4DuZez1qIQ8rQmD8CsM6KJVbKt5uKolwpGiXP7bUBkbBdwroUw6ZlZ9yRylAWfkWOpUe+zQZXQ9xndi0TIxTM5V8IlEaxGJmNPy34Uk4556AAiZQzoSGPpkONx7NYa4riq/VvufKy2c8+GkvihnZsmAbFgBRxjRVtNSmxQ2nRasDmgLG8jVncKDgFgTCfrL3T/a6F2/BmHZPlGPfQm0WhGo9bri84Ewlqa9MDD2MsRX3Y5esY6bSiccE1N5B4GAUMrK3TsCbv0jZBdDjjXKEf/Ylam/0ksR6GZaCm+o8A44UL4yLZO+Ty4Amt5PFnd9SHyR6taR0Gf/WI4KEcVvfXQBcSwSD15nuYDxxj2kTlfiSRWW5p9H7u93nMaM1lOOQE8hZXQdHoHsGFTbslA5Jkdby+8dRXFIws+z4UTSHpV6IXNeBktZd6odPBvjOJORWBtIcoPPVnc0MDp4GB0QUCmrtthOkAkP77NJf+WEy3RQIEHKZ8tf8RS6/vxmV/7lTrSpNzP3ZKgtMvbm+ARShinqo1vVl19132/K5typecf6iwSVpHAclPmgBTrUyAJLdi5iy5x899rN7N1+6gu9Rpq1AKIFjdEOuIiNgxiPLjE2wotpObhW1U2iEQtrZkAWS5LjMt8OijFDrLuyNhSxs9sBOSm/7Hz8HH+nrOR2A0FtkYuFV+Y8vWUBV0Sd5suad8m7BQj2lEuvHe1+RpEZSFtj6y1CKzJKNi8Q6c44Glh/Kyp4D8YZFohaBEMH9dTuS0e/+Ph00Vxq4qouPojufPgVx7lppIcVT5RJv+Lmch1Ojl8ZkAxiJgLFASNAXqu8L5mS2/1Tuwjd5H+HeoJMQ/RaTkVSR7QwOJHgbYF3vzLTa7P8rbI4U8RGYQw1Sss7nIhObjWvR5T+uy1Nvp2Dvq
 fTFIar1j
 UoGi6cpO2qP3ZAZ8O4QPqBh3LxY0hfJ8GVmPCpnhr/COZJTubkN6uCBvMW1cY6SxMD0AGvd8ouQcWOJ3um10Vm43MoHz3xn+vcAIwMs72GqLd4qhYU9rht63skEMrQZTpr8Tpy+BzTAbkUt2UrA/ksJrcv5d9D2av+kxgofoJ5SA98/Dd7HtITQHlygb48DjJNjwuL+KBP+xSG2G7Ql5NP07U2I+ucdq7lSwrKVnfnq+EDZdEs7HWl+FDZ5978Pp8VyU0rEAALOQ7yuIAd84B49VfHqJ6acPBoMd+jr9/vt0gziJKZhAmYj8fPP6+nXoIwldSUTXEWP5McQ4QJ0FS4/bHDxE3LjPw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in lockd with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/lockd/svclock.c | 8 ++++----
 fs/lockd/svcsubs.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index 2ee2c3d6e442e701dab29dafc23da8209306b84f..0b6be8b8aeb1edf85cbb1063763a230e70c64e18 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -487,7 +487,7 @@ nlmsvc_lock(struct svc_rqst *rqstp, struct nlm_file *file,
 	int			async_block = 0;
 	__be32			ret;
 
-	dprintk("lockd: nlmsvc_lock(%s/%" PRIino "u, ty=%d, pi=%d, %Ld-%Ld, bl=%d)\n",
+	dprintk("lockd: nlmsvc_lock(%s/%llu, ty=%d, pi=%d, %Ld-%Ld, bl=%d)\n",
 				inode->i_sb->s_id, inode->i_ino,
 				lock->fl.c.flc_type,
 				lock->fl.c.flc_pid,
@@ -617,7 +617,7 @@ nlmsvc_testlock(struct svc_rqst *rqstp, struct nlm_file *file,
 	int			mode;
 	__be32			ret;
 
-	dprintk("lockd: nlmsvc_testlock(%s/%" PRIino "u, ty=%d, %Ld-%Ld)\n",
+	dprintk("lockd: nlmsvc_testlock(%s/%llu, ty=%d, %Ld-%Ld)\n",
 				nlmsvc_file_inode(file)->i_sb->s_id,
 				nlmsvc_file_inode(file)->i_ino,
 				lock->fl.c.flc_type,
@@ -676,7 +676,7 @@ nlmsvc_unlock(struct net *net, struct nlm_file *file, struct nlm_lock *lock)
 {
 	int	error = 0;
 
-	dprintk("lockd: nlmsvc_unlock(%s/%" PRIino "u, pi=%d, %Ld-%Ld)\n",
+	dprintk("lockd: nlmsvc_unlock(%s/%llu, pi=%d, %Ld-%Ld)\n",
 				nlmsvc_file_inode(file)->i_sb->s_id,
 				nlmsvc_file_inode(file)->i_ino,
 				lock->fl.c.flc_pid,
@@ -716,7 +716,7 @@ nlmsvc_cancel_blocked(struct net *net, struct nlm_file *file, struct nlm_lock *l
 	int status = 0;
 	int mode;
 
-	dprintk("lockd: nlmsvc_cancel(%s/%" PRIino "u, pi=%d, %Ld-%Ld)\n",
+	dprintk("lockd: nlmsvc_cancel(%s/%llu, pi=%d, %Ld-%Ld)\n",
 				nlmsvc_file_inode(file)->i_sb->s_id,
 				nlmsvc_file_inode(file)->i_ino,
 				lock->fl.c.flc_pid,
diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index 5e7b2a7967bd23365dae2817a0e11c50e4be7c83..79f3dd2fd3666d835161a54a6b3d2b69e7741dd5 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -47,7 +47,7 @@ static inline void nlm_debug_print_file(char *msg, struct nlm_file *file)
 {
 	struct inode *inode = nlmsvc_file_inode(file);
 
-	dprintk("lockd: %s %s/%" PRIino "u\n",
+	dprintk("lockd: %s %s/%llu\n",
 		msg, inode->i_sb->s_id, inode->i_ino);
 }
 #else

-- 
2.53.0


