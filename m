Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93F31EB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:49:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 098B16B00BE; Mon,  2 Mar 2026 15:49:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 069A76B00D0; Mon,  2 Mar 2026 15:49:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E39F76B00DD; Mon,  2 Mar 2026 15:49:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D2D9C6B00BE
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:49:16 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7FD1BB8112
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:49:16 +0000 (UTC)
X-FDA: 84502313112.12.4148029
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id E6DA080009
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:49:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IorKuZlv;
	spf=pass (imf30.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DghIzVqbqugfjWxzK12XQfGtqk9IhJ8wjFTgevCYcHQ=;
	b=2F2KgwUPtUi2UYB8cJw/jx805po5q2L8fG045lbgUUIAg/4SvsHJYbdNnJmfVFKTnAkeSw
	c/AlbgH68qQvehx1/8o+cdniFfltQe76EdMkVndRrBWWKx+CcVxesFlW/bX4dt1U4LLzJx
	bJV1/AHaUkTgKF4Yl2yVvF393hGZhpc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484554; a=rsa-sha256;
	cv=none;
	b=JxBpELxSBBoR8mi4rT5oxc1WiThEMDjvL0RZcTpjNue8pQLcrRZXxJXw1ax5jKlYYCxGoi
	hWaldYwSoTB3tLqVV7SRZZV2cWWPY1kGGpgMFYCs/CkrpJp+UHoZJeOPG1dmzboVvpddEL
	XqgB+MS4/8iIS3g86GlBuaWzYa2fAXM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IorKuZlv;
	spf=pass (imf30.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 28B1261338;
	Mon,  2 Mar 2026 20:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B31C2BC9E;
	Mon,  2 Mar 2026 20:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484553;
	bh=6cZwsfpbObzNeQK7uzLXLbgL+hWNwgK2OM7xy5ID8J4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=IorKuZlvL6dslhQZhuCOB77oSou3b9HVCdnk+hCgyzh8s5PaZDXHXQRR8e/ueaj3v
	 Of2NatafLlcq93I3N3tj+b+ji3Cw90UnmElVxNb7flMZt0afB/JdPeJYxL+ZfTA5Ed
	 r0Z9ma/eWygxi1n/JRHTwMwmayCZetTxj3iG3May/82azlyawA58n4CaW9UKfbezRV
	 txPWvxHfqldCnxmeykB5RfT0sF6KyZj6k8QVjuAXYISpgl9wdenOoGH8O6mP0feaF3
	 y7dED4qd+cENaLutYTklGDqxvIvPzTVhN8sNmXnBBosIiQA1FoeB9I757q97DjpyFL
	 yYxh3gef8x7+Q==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:25 -0500
Subject: [PATCH v2 101/110] fscrypt: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-101-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3214; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=6cZwsfpbObzNeQK7uzLXLbgL+hWNwgK2OM7xy5ID8J4=;
 b=kA0DAAoBAA5oQRlWghUByyZiAGml8gujQ93Hzj5fXRpB1CYY3q3nHyAjWcLgnlNTz75TUF9PE
 YkCMwQAAQoAHRYhBEvA17JEcbKhhOr10wAOaEEZVoIVBQJppfILAAoJEAAOaEEZVoIVG/gP/1mz
 Z/aWsv6cLzW611kkwDhqAudZlM+C3BBx64Q0uc7G30XNc2yp0PWvuAMk61d9m6VCuoomh90jTr0
 NK6FFf3SL8jrC60bf3SoyBPUViDMMoKszBoRfVX2ASjXOLZJZzjeC5m0/glF5Wizs5+1UolOGYw
 wWYdsC+EeM6Qi6hHsqIONu2XYW2hepv6cwmVCFOPJAVcawQftNR+bvtC6wDTytEvgHKXjUTqhAS
 dpKjQ7vXFs+wZRVKSlavUg+b4iTYJhnZwifA44iJCd7edSq0hT6yK0/u91lhJaLGeadKtdIHHPj
 fHWpOhEWlg9lA4rhKrDRBHd1PZyjmhCxhcEfGIDdLnH7iesATUg9e2/6Eh9yJLEv1F8L+2RhdUQ
 ustpIjeJuUKJxHNOLj5kPcqOYapqJb+IsiP5qBGKMgNxAHDebqn357vmChru0JtK0EAe/xn0jai
 BCD5MX12d8DF4il2j5RTcpQX5sqs38yjrTATcTpDS98mNtHwOt9kMg0Whs5spp3DoqdpOb6kEqY
 Ee50OlpWXEY0cz+TyNIGDLRTvcizbTME7y0X9K9VolAB1L3Zttt8gL73zMs0WJi+TlQk35WSX8w
 0g4Q7ostGDkCw5+XEqNWcIAanuZS6o5ssN4Bnpn/NIw6AWt87L3RuH4HvJoG7EDPCPQdKfUSflG
 5+vLL
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E6DA080009
X-Stat-Signature: h63iinqb13hykn39zt3n4k7r3o38z6pz
X-Rspam-User: 
X-HE-Tag: 1772484554-32464
X-HE-Meta: U2FsdGVkX1/tso8YcoK+fgYYJTdLZHyt1U56DRun1l1GUU4aXTdelfjyqjoLFylQ9L9w5/6ChrBPajo1AO4R0chCD2aQtQ2cvM0+tFig869+HysVoR8CEhLGgEzpAFdGL070aHVmCaRFeg+PTqQonl6YRBmwqNVe4I6/+zSANyiknquC8cb9NJz/PYD2lWIn+dTkpEPzsP5yLBYuA+f0VmuIionnd/C0FmeHJJTN7sKBYwe9P+DlNnjwasUPll2zhAVKfNnkk3qrl8GaFHpvPa2xUM3iui5EyuRlfq99HMpBHzPTTYNxCmOD9zvjjz93wZJAL6dvT+RuyhWKC8AhOhP0dkL8HcXV2LdAQFxlgBvOYqLCZ7qPoLvfSi2utGxPxmp4FvQ91QbgrBjcsO6RZr5Onh/9JSJKaap27MO0QFM4I+cdBWZGfWIQZO+GJ7KJWtic6oVel7Oh/J7RlOoShJ3BQxkU2se6Gr/KXrOu8+XyHuTq8Oc0BCLheKM/ZqkcMVA7JAj7NkeSj67ykL+YhT63mGw6QSRroHWVEsjfQx+TgJ3TqITg/C/S0j92o1gV9aCfy3m8kXUxh0ulq3j/zF2mCBkM0hiZx53ZTpeltBDkmiwdHcWMKgfj4eEGpFDeiO9beQSHaW5imvXDX6o2/zq4CJyCRgt+D48jdoFt2HARl/yBwPr1Qs2siwP2AWzmrVjWsrRzO8qSyphoHZhEfhcZGIZQcjFA2Vona5AoXZmJz060ZmYSNBD8A+e6gadk/hT2BLrTvmcmQMPZVn5V0WaZVKHA2BKaOlUgSqapOsLQ9GugUnmHAyp9N7y2FHdDNrV6uHrU7dSi73rPbC6pkw1kd9hZ6oXxQFAxDUmW4RbCj8mASw0tec9v5cHOLE+BNexb9UOgI58t6DkyMyc1OERqYZJdzzx3nQ+6FivchTq2z4drd4DjOnAPnKE56W+NQgg/rDm2qpgpn9EmbG0
 yHtgkJTj
 OQIc7p0G1rxMOZbW6WfXSd03PamerXgQOomhmmUyBYLTUGSiVnCNv6/X7rHBcrQwukEep5VH18gw8mV1SKM2iYhEv28mw3315Kte7sVBF3LKkXuOe0FatkSA/hjpEKgD0/qoQ/Bjqf5ULFzQFfmFxo8u8J17ja2P7fIKYBVua3LauHD4v6IfYqTwJRBnKOxXqePZ81JNU+ZP0NWiWGj2Q41Na1psZiMEkP26JPJ6YYdT3iMLTejXOt2CML7FZbTNh90mUZM5mpaBshxJdkU3Jtw3yvxfc3uPqbDHgcx12UlzBk9mEl8mZGP8tYbzM5aIXMuPI9fKhvpPgY9s441SCm5x60Uo6XuovL4MvjbQL24GsHndA7luQPs1qKnAsAiEmDdjHhNd/RUdsOPi41b4WkJR1s/TDsaV2zrzFP2cj0SCoZ2Ild6PGibK8v67RKCDQZisWEvxRuKxzpeIhj9+CAD5fcxiXLu7/H+gT55EB/vWSVTiXsqs8K21FyFDg1OYJHD0BUS/Y35eIhQqvPvokavaeZtG5zO6PtrX84I2jI7jP4bRiMQZVsRHf0rqxiW9ANTqJ5SZFBls9I6+wEi14PZbQomkKTwGU6nYtppdB4/Bfu7U5pqp+IxuAzptCtNIvw9RHvtExjM5TBv/JZJYzGf15TD2Q6buaQ3G3ZWGVza8QaBWLrLuMvS6F5cJS41KLxdI7jT33m4ZQEGw+btKRVIPDUdAw6OKNTbG1/tHpAQYDTB20ZwNknMT3MHDIQdYgTbtsFXSp9pVBYjOOHgEFOh+JHTA4KynVGwJcEtToAKRsjKptlT3pe28LbUupC+eS/OYsKwaFgFkSxa9ku5vDS2HJGkZQAUXgSMu0vsf6g7G5BCD6cTrDJEDXWuUnaxaifSyh++lsFcS2HsfDtNlweu2rc5YHx7Z3VTEKPrhi+mj4blr1HZiYF6k6LWKA8NB1BhOu8mLIn32iU1QHVOHUTDvM1jEW
 cQxhBDMo
 qPGtds5R+7mBcyO1inlH8duN6QDh0nL7C2uKyAT9RBkcXS7t/t/Zt30PvqDXK4/i6j7PUk7FI65Ygy3Zh2/V0+doR8XTHAQgd/E8lWqbrX8CA/Bh6jB2pA9sljiPSwbGKNC3N7Tux/v8+XQfkMPFo8XrUno2KzKm5/naRMY3rwIRm0Gviy3vArim2ckdpbzChMpTSx9ji04RB7XxzX+Niuw2vAp4YVwrDOFqPhn+S4novjWhX8q60ep9HRtQqyI6GTGc9DZtxPeO+9rqMGDFvBUG6Opq/va3Z6F8qDMG1WEXbC0TaU97hFSaYAH90cDnENWS3cANUP9bzkIbMDS/DGSB7SpPTAPdWj+cPnOM6jEMs4H2m61RTkZacYxxRLrjiPZ2GjC2tysthDOgcH9BYCS+/SxILinEtVsvNj7qWlRJf4V6+kPRdxJ5lqK71MHi1tto4qRt4mTzgqwilfOQOoc+7Hrh8iyN0Jjak1cmp98hcEf2zBmsoxpKOZdDy84soJLm8RaN7j3NpwhBfjYkHPsya6mLA6uAp57L3t0HppxeQBTG2geG1lhqTIRN/fl9xQafCZXJbcnHulAZBphSa5SfDiseRzsvoTDwxNV4J2RJTxj57dntI7HTAPJbt/7EYwQDeFD+qyDbqh2eBiA+37cRkhI1FYEWSN6PFe+TaTeyvfdo0cOTT8/weOs/xMICD5wScNc747mZNjx7a/PYyZDblnogaDIZzwG1bxol76R7n/lWyO7vp+6VFXeGblt5pOJectNXfb+Ced9FP1FDvpXTgrbdI/GzYg6txTVVPB6DUO9BpfcR17g+B4d9/+hDocMr1hFfgGTeORucr3mMYU/zGeKTNIDQJM31VcoYdpI7h8Z1lCOR7sCrZwpqsBXq+TuzfMkWyLNg3qV8zMeinrdKqN5bl+qI+qHV3/7WiSLtFP+hjXQ1bkd+C374SX3PXKBa9eNx2NSjLAM1dkXxAlnNip/xY
 teVubl6d
 mGcJBb0GKFL0PDx4V275qiYIbeYtbJWDREedU05jqezIgRlJdJIAhJYM9GWWZiD/L+pt21HrMYXQ4wuXG0BhJNOXwVt0gzeUtBpt2WQI/k+Z1mcQf2b/h0px3rC94YoGcM9cN1NnmTAGRZ3R5BtDEWo1z10KzMJ/4cDlh6jIfKAGkAi0QnA7dq/f465TKNqq3sJw1V2YWH8T9Yi2OitL+GemR9YNVbpC6+pbnzLxTHkClAtkwVF0FpP77kirIbFN43Wm74C6sJK1GA2BQnRLti2xtvj4MJoX6qiiB41+oiNerh2IV4ir4ylygT58+SRJ1ctKFkgIrlldmNniNChngMIEjPVBQy08AdV2P0yTp3GMDehyLqPVUAXq/wMZ8uRMsrnnyTMgXNDBTpWCpVs3V9Jrz28MNGzXM5yJVpIomemefe2DhxpmLk2Oj41b7Sj1jREFTHRJfVHRJxlcsuNuYjRtq9KtuEB6k7dBlkDocWdZ7nWgrfI6jDungGaNHwBDWQoNzOZwiUyt94Ic9nMMZOBk9HtJIejKGKWM7I8ue8UQ/I4flgWnwHFcN+kYt42MewDzo4/KXlijzM57pvD7PtplRg8+VKVNzHFiwjyB0wyfkl8Q64TIx4bcOQaM/YOke+SI9oezaQEJkGaxYGA+BHxXOpojOK46EBzaYJfxUtDM0QafZdvYtyScTkWJbVq0Bn8SHvP+PTaKgAhi2OHMRrUc6h2XuXtAmifA35P2cREEKM5cFJRYxg8ibckl1RdCgpyuSnkQEnkyRfWYQHWqES4uZtwURoIWReqdgyldKUJAdOO1unXrq8sFeZIIMULjS8DkucJV+lmQnqd7TB7kVmOGg80I0vA2XYi2wnpQ+KOTZ8GZ1hTbxYNObYhyQXnuy4O+V4V9WfAAThr+62cWAfjaUK2BN0tcw2dm84nkbwxJxOo9leYiWLhPMq5hR9mQj/g+0n2aS/8IvFqpvRvKA9gIPiETc
 hmLJ6JRv
 Ix8E6tuhYVmj8haLNdCDY9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in fscrypt with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/crypto/crypto.c   | 2 +-
 fs/crypto/hooks.c    | 2 +-
 fs/crypto/keyring.c  | 4 ++--
 fs/crypto/keysetup.c | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 4fc2990642fd3ee385a9919183cbb0f1c5ba6a58..570a2231c945a6c649cf8dc3b457f0b55657e0c3 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -365,7 +365,7 @@ void fscrypt_msg(const struct inode *inode, const char *level,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 	if (inode && inode->i_ino)
-		printk("%sfscrypt (%s, inode %" PRIino "u): %pV\n",
+		printk("%sfscrypt (%s, inode %llu): %pV\n",
 		       level, inode->i_sb->s_id, inode->i_ino, &vaf);
 	else if (inode)
 		printk("%sfscrypt (%s): %pV\n", level, inode->i_sb->s_id, &vaf);
diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index f41809f1f1ed0b1ed78b85a4a987ec9e6cbcfa9d..a7a8a3f581a0460537f5ff955bc8b5d30573a033 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -62,7 +62,7 @@ int fscrypt_file_open(struct inode *inode, struct file *filp)
 	dentry_parent = dget_parent(dentry);
 	if (!fscrypt_has_permitted_context(d_inode(dentry_parent), inode)) {
 		fscrypt_warn(inode,
-			     "Inconsistent encryption context (parent directory: %" PRIino "u)",
+			     "Inconsistent encryption context (parent directory: %llu)",
 			     d_inode(dentry_parent)->i_ino);
 		err = -EPERM;
 	}
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index c0a2568a88cf6318877dec0f5379c5c8511c00f8..be8e6e8011f2131f2908da746a37d33fd5295122 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -970,7 +970,7 @@ static int check_for_busy_inodes(struct super_block *sb,
 	struct list_head *pos;
 	size_t busy_count = 0;
 	char ino_str[50] = "";
-	kino_t ino;
+	u64 ino;
 
 	spin_lock(&mk->mk_decrypted_inodes_lock);
 
@@ -994,7 +994,7 @@ static int check_for_busy_inodes(struct super_block *sb,
 
 	/* If the inode is currently being created, ino may still be 0. */
 	if (ino)
-		snprintf(ino_str, sizeof(ino_str), ", including ino %" PRIino "u", ino);
+		snprintf(ino_str, sizeof(ino_str), ", including ino %llu", ino);
 
 	fscrypt_warn(NULL,
 		     "%s: %zu inode(s) still busy after removing key with %s %*phN%s",
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index b30630f2c6a4e341c72af0db6aa173f59f742fa1..df58ca4a5e3cb1df94e2f08e3f3b093c33368993 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -91,7 +91,7 @@ select_encryption_mode(const union fscrypt_policy *policy,
 	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))
 		return &fscrypt_modes[fscrypt_policy_fnames_mode(policy)];
 
-	WARN_ONCE(1, "fscrypt: filesystem tried to load encryption info for inode %" PRIino "u, which is not encryptable (file type %d)\n",
+	WARN_ONCE(1, "fscrypt: filesystem tried to load encryption info for inode %llu, which is not encryptable (file type %d)\n",
 		  inode->i_ino, (inode->i_mode & S_IFMT));
 	return ERR_PTR(-EINVAL);
 }

-- 
2.53.0


