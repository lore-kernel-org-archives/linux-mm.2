Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3C28EB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A6276B0163; Mon,  2 Mar 2026 15:51:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 259A66B0165; Mon,  2 Mar 2026 15:51:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 104256B0166; Mon,  2 Mar 2026 15:51:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ED1DA6B0163
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:51:25 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AEFF1C186E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:51:25 +0000 (UTC)
X-FDA: 84502318530.21.5018CF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id E37EDC0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:51:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T7M2jA0E;
	spf=pass (imf22.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9JquwjMd7atCc+mVCKtunlkwPlGoSrLg7WB1xfco2yI=;
	b=lVHOCT0Zkn9zYVRjgvlCzmEzYH8xxWsGTrh3WJJFvYApPit8nqF7gABS1vfITg0se8DLuh
	g320CPG84v6ZxG889bfggfZtaKsNSFZUnea2Jxij7da4Nw0qM2sgHqdV8mZ0OBISXsCvu+
	4POb1rT/VGAfGLyIR+qDntTJAWsVa98=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484683; a=rsa-sha256;
	cv=none;
	b=SFJFdiKNU6UVCe7uN6DDGN7dN6tPhsydUeP3Yql+Z8V1y7Lrq6R82gArqd85JcvhBNyXu1
	RgQI+qkpjmRmTxz6xC65tD+/LdlMznHEHCb4nOZlqoeOMoyif8W+dBbGBgcqyy5cIIjMUk
	sK+IJpW+l/KABbhY7PoYTcduzoO3DQg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T7M2jA0E;
	spf=pass (imf22.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2836160180;
	Mon,  2 Mar 2026 20:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC98CC2BCAF;
	Mon,  2 Mar 2026 20:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484682;
	bh=/sz7TWb/8/hX0LciA1x/Z08Sx95qZ79eor/fKNv831c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=T7M2jA0E+nOiFu6g0V2eB4Fpg250FkkborXQ68QoO89fQRYaKtke1mCmqo5Vuf7+r
	 wiGdNgQVLprPk5IB7mkheRRMyC+FRKyQz6ka9nPwO+kJgHBHZ43Md2Dkd9VD0/Of83
	 ZUNAObaZI0EzCRK+rvOI+NopDu28S8zgq5QgcDyiMewHIqmRZf306wVK3dRX1tBBlm
	 VErLvddEWB8MSYgMw/Tz8REN4YQ1FxmYNeki4O77thoNIvmMcSZ/Thb9ssZkIaaIfz
	 KZV2FrOeEqwnH4Do1nBzSwg2vKuYdXhsUVCS3pZV7L6ke8IgQelYklF9NzLOeqoxtq
	 8b/TRYKwQNuoQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:34 -0500
Subject: [PATCH v2 110/110] vfs: remove kino_t typedef and PRIino format
 macro
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-110-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7864; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=/sz7TWb/8/hX0LciA1x/Z08Sx95qZ79eor/fKNv831c=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIOWw4VpZ1f0esD0l2eblcdOGEvFuzW5qecf
 cTPMYYfwB+JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyDgAKCRAADmhBGVaC
 FSiGEADKoZsC6JwFSXz5Q8tPMZ6t8//Y5SGA/vaBUiD5D0C+kZUFc/J5USU5TJAKaXk0BTDmAT/
 2kbSCQNocpoPv3+wT1fnN67/FnoxtqnhKqtCXlvPPR9RqXVCoIxxjy81hmMGvj5OueJeojBhBrE
 EPeNMIFty+gCEGi2dWknNkaFTtNxVknqICbKKlus5egvNmB/P/wcCwA75eyzT9Cqf8HgCQ2UWH6
 E+1UZg/P3Utcs5RWUN4LdyqwfM+nEl51pMv3R4lNJeMv6VLFYo0VBxIBSMwMwLYGA8ONx6GabD8
 h7hmuJLNcF4apD7rmibApIK+IR8kjVt7xg3Z1R/kF7WyEW+ipWCA+d5pPv4ATJrviTJ5swUDr+e
 0fR52ir06HftVbBViJXC+/+JeBB5ygEQwwixuJf+EHIPh8Nw+eAOeSMTJT6/5J9boBSM4t53R2U
 1uE4EroXow0SM75te/gScXwcjFowrQz/+gRU3pxfj31chpErmp6yk2ql36oF4XCRuFtyNVG3v2y
 fwmpsbHx68WQUTJbKUJrw9HuC4vvVoFx2K26sNk8Mvnxfxb/Menyn7MMrfXHs4wZ/DdlCIHP9J6
 K4FPkJfGrBW5QSCsdyluxgAY1+ed66E9Oz4M67wxOod8vTaTchUlxDXS5wJQNAd38COtoq/jHe9
 EYgFPWN/4XZNcUQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E37EDC0005
X-Stat-Signature: j5i378s1nbecdkuepj975w1kj8etet11
X-Rspam-User: 
X-HE-Tag: 1772484683-8059
X-HE-Meta: U2FsdGVkX1+s+T+VIpwBEmuyrXoQzQpz3fDvAJDlEtfrujTXlsvghq/+9w2aA3wCOXFgp5wVuFkAjFh3gzAwW1ltwWLD3JrM4X9lnJ/HAZME9bVkGn3vepbuVl1dNLydInyW79M/LNwoQexRFWsPwUkdQNigsQFOTzzmLFBP3nMFygZDm601Kb8jE0114+cLKR7eCetPJFi+2STe5V/T9532EX5+ROpe8cvGv7tKHk2UPuEe/NR4uhE1MYo3JllR4PS1JKcXZj9eqMZWvwmzdjdrmMaqtAGFpWcoU1AflMo/tzMQ0EC/EtXf67GDwiZnqwGMSgYKyEndBX+TQ9cDf53YrDv71NjDF0v4IT6NqyDZBNyuuLitfFImTcjo8Sv34RM74Uq5FNAAo+cOxQVuyn0N2KovIykJGPhxy7AAs0sAmLR1lOlm7Q4MjVhBOwSWWz8s9KIbBl7s0IeHPiFAoc0GiPXMW9zol2CZtTMBVwfT0JJg3DQJDAg1RuSwGj9UZ6VmolAa0tQNsC2/ooi8ChXthNeW1JHOIcDxpaMMLQeEc2z7YahTJo8jApDgF5Q6MQb6gJE/MXF8ynczZUiMq7bxpJtSwTbsu88KBI1ajQiE8Cf/Us5vvtR3IIQHbO0fjKMABmPUanrJRGc4A8sg1nyBs0w/ILHAJ9N3DVfpZVhru+QNkTJrcDL+mNw1ZtwjpKfaeHEYCIOT0ZQECH+yL/MZIJ/hMnyvR/5GGE1JmHvzlqSgs6ChBgZYuktQWbDcSGkcDpU07WkvMD3fFc3bs621CPYCjOw714cmL2zBsHPLoireeY1DW8JbAJ3RjCdHp03H0iRG4iuk39lVCSOpOx6sJs3En5UW/atFbHX1kO0RNaS9/DiBH79udRuhiV5DFNU7KZp+2gnbWUirr3GCafH5sX4gU2nxkVT6BJ84J7kRA024NF/Hc4/H/B3tfWWPJR8QpWARn9prOEhyQJd
 uatS5B4H
 mInHb1aF1WnF8Qce29h0qNcSw86/uNqEg77NMNJQdDij4efNKq+y2I4oyF3q2KcS4i7OD7wykeJpbfoZLzphOCihLAhfPLuYAdyzSP53t+jWOHJ04ItUQMm1Jm6IyVFqXm8BvBEfBFnQnHUVtJgfCqQ7lF/uxdtuZHy//Wmu+Oj3zXzeEjn6jiZfUczWF7090qw+rK7rgNY3EP9iyaY3kQA9WWzW/hBY+USriUgsGEudY9jC5RNpLWa5xYGdo4zWaLGpHy8+aypkNB9a0G+V8kebMY6d4j2mBNjbr17xkAl6I7PUnooMyrCfgcp8tQr6qgvjRNrvPi3eCiLwwhECj0Jx0j5b8iCuM9lSWJlMpwrt99og9Aom91iDx4tSyprIxsNQXGQEcqscjP1UHxJLHV6zPy53fqVLE7IqbDV+Ndnsa0SQMCifIqh01aFSC6oZmtgosno1NwrSNVrVU5C9xJLocNoV4cG+PiKPyowSxOdA3IRHR+GXjiXc9tWSq0DBkm8kXD6eGXO0XTRQme5ODeAxJsBdD+XK0dB57LZt2zQvn3/V5tCc5lqrPMUB9Ijl0FjCT7eHqJ/fG4PcFHfBqG8tjN6BuNgwE4yKHCRBdBPVSwGxeFb+vrHF2+Eri81W3u2cu721F72AcXUlz0FHsOyf0YFF3m0qjJnZUNsCcbT7N80rZzYj2Tw2IZM+7+gadcGZQhgNvbnenkzuZ6uXABZx34Q4Q/IjSZGRZYkTpHzIgc64uf/BGv0mmA7d6JwBB2qN146Mc77y1dnE+sgguK0p3zVqg/ztfvpO8sVhz9wxDY81wbVHxOJDfdJX0e4h880+Q9kNkoiQtr9jdQxg5NTiMN5eH3Tmmkz0opk6mOcZAtsNRh1M3Ff2scX5BddM8YCgIu4TG0l4l7yFnRIaOkPXJcoSQLmkMBj+rWRivpUjMvRVoI6kfPap+ZBz2cclmfSTknxleluydW0C6a1KiVgt5GQCV
 bqGnpEDM
 p56mRWcYmjRk6WdSjMWHA8oAoAN31pulTYHAWkiewSpLdcsVyLMcOwlcLTqYr+YiMV22GM+CGAV127SvdkIwenlVztt0ufhtgD5KIPjpVa7xg3g/IzS8eIxbehpO37nHTE9RqSaI0d7Pit5NwC3q+n/TwEHXhKuV9FrN7H5UaGOj++4uvBcPmmLCWJfQRJYCBjV9OAfsMkImys5Tqpr5NAzASoE2mBJsNN2tT6pRpw6cKLYhybNHWikcRKB3VGWST6CgAMeQoGqn7tsGw/Y8qa9iclCYSB2uvzaW8fLuGfgh5lvTflEwvNh5juFfTdn5dOj/P/nDgILNsjAl2PNVrjmRJgOpK0n9coougj628RQtsXzza3XweFDHvxOwotyy8sjee/k33VU0nikQgaF9n7kCcXTJPLyiLk3/NpIKevKzgsbqFNTuaZvbnYuDkM7OueFXF1JRsdCZ70t4EvZa2uGZN91W3vEpNaiB3+MUZPhL2Inq/Ae3IuNF7DuaZlTfFGftT/mbgoUkLMTBOJc9TtENDbsbyv+pt+8o8QqpQqPxhvBCQmFDQX3QFjYXkLs06ysE4iQCVgTTRQ9gBHIsi67B0ap9YYt19+5kw/rZYUyUeOOXHnCKcmPtKxS1McfwnUN2RiN3KC1TI9Vdjr4v5LOjBSsqnZti+hOLeAKjhR7z6DVX2xxRf+uyeQfQgmD9PnKPJ9julV+I+f0j2pIAZL7BQahLbxqqwVHo6izt+B+up36gm4ELNKZm5dl0HI18zjaqRHO58mcBxD9qUKLQURU9FCKtAN6YHmYPxakASZwzO4zwBq9m3f3K0sbAV1nbuEdSpDUDyFb8lVYei50Gdp7ilYEm8djxTNr1CLmb2A9YsQyJkMsoztVq3UE2rN/2O5NxL4lptj0nMI38NAXem/FRqA9G/EdmaS5W6iWM+yHKGCKzEk/68xn0Iue3KeX8gZRNEtkUk+ELIaz+5sXcgqcr1O8kn
 HzfNT2Ai
 M/xZzx9+p5lfkfLQW/PVm+tncIJHHsuLVgGWZXIUMbSbCtxLB8UrDHXHUEDSAKd8gpLZyLjXvuuBl3HnAF5NtplEDfVXQbh9fC+ZcuiS26zYBd2U848p0SEsUirR9rhFEpCYih2ODnQvKXCGvHo9RZeBy2gXrVu4Bi6hRlXfppXNiW7k1qejeOGYf0IXagqJ3V6VpdkoTDsW9NJcon1dho3Ad6IedYTWAj55vrHxDUlWQ3kpEqrNF+VFjI/sLCGcRUH1YxIOEJFz46rDK2g5W8177TI5Sd3oQhfkFxadgZ+nFplfUrvH942HTbgzlCK6d1Cqh35IxYRj4zRWKLXdyUtZMMz0ArcS0Zf9HEw0pXvosimPZ5p7lgK/SAC8D/ySLtWSI5SyVzoggEi1kLtqIVSD8WD0ILdnO8cTly5+zcf4bT8R5ND3mqYCWycRADZoTJRa7YJGfFSceSrl81JbxM+mJYzu46t1KTV+gZAEnyYe1QXZhy9feCZCoIlHsTkAl9CLUkvAgtI39YqLaCVmEJJTVwOfx5/9aoEY54KfezA875zpDam8bIvisyYZngZfz+gMzFWbierC+n1EzVEt0VuVjsOhHSOvUeb2xNsnb0CbbjP3dGyDEeLEc2sRwmGLynryHE/LNVgorzgS3Yr44HcZmMWVI5HehWgRCDestbiCYuFaOkArNxM/6rLbJp+EzK21RJz1Jh6tLdLlGEwvJDxOMGeZxQr7FjC2QmM8OI07JNKBdJx1wE0qyfg9SiNRxrVbo6FI3howor80QJpdZtGepyBEbYmOlXEuAQ79t7fz7eZ3DYWHz31CjBWVGRv4Mv0kvuL+IBvf8+ZT3xSowu2aSRNRNNCmnKDGz94lCwXPGnu//8n4IMISJRw4C/iElUVwflvuS7eoGbVPpiK3q/hxTKbRNsAH1p2LHX9IeoMSobxXha4ZOmo4qSKfIldlGc8c1yDrRNpLyysaW5up2TVgb1JxA
 73/T+Rr8
 YuAzXCHH9f6AvWxGfd3XRPHge+kppG0wForTFkKwcZR7hC7bLDxN76F3+Gd7nnFEOILDaN3cwTqV1g2543Sb9O3vY7QquDdx3CzLMFdrPLFhHTVeJ7GS96AQsJR8RQ1AwCiy4Z6ih17qkhmvKqlZT2Bfuo+DK367vfm4zaliVRs+bynaiV/0k/KEUxx8Sh6p56auuVKU5a0/fzUpLqabaNATOeH0y5x7GgryAHqREQVtKRahkmpJiRlCh2solFUhE9FEGx8A23X7sj34dd3K8poFoN6m5hyhikg0sxAAdJlxO4vZjUzFwp9yDxrmQXtq0h0zjO6tVPhvrQ4KxBPJgc/+DSlxM/uoOjGHWkTSr+7//yj3ymvuRcey2SSQrycP11RM8zyeBwCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino has been widened to u64, replace the kino_t typedef with
u64 and the PRIino format macro with the concrete format strings.

Replace the remaining PRIino uses throughout the tree, and remove the
typedef and #define from include/linux/fs.h. Change the i_ino field in
struct inode from kino_t to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/dcache.c        |  4 ++--
 fs/eventpoll.c     |  2 +-
 fs/fserror.c       |  2 +-
 fs/inode.c         | 10 +++++-----
 fs/locks.c         |  6 +++---
 fs/nsfs.c          |  4 ++--
 fs/pipe.c          |  2 +-
 include/linux/fs.h |  5 +----
 8 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 13fb3e89cba7442c9bed74c41ca18be5e43e28c9..9ceab142896f6631017067890fd1079240448e13 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1637,11 +1637,11 @@ static enum d_walk_ret umount_check(void *_data, struct dentry *dentry)
 	if (dentry == _data && dentry->d_lockref.count == 1)
 		return D_WALK_CONTINUE;
 
-	WARN(1, "BUG: Dentry %p{i=%" PRIino "x,n=%pd} "
+	WARN(1, "BUG: Dentry %p{i=%llx,n=%pd} "
 			" still in use (%d) [unmount of %s %s]\n",
 		       dentry,
 		       dentry->d_inode ?
-		       dentry->d_inode->i_ino : (kino_t)0,
+		       dentry->d_inode->i_ino : (u64)0,
 		       dentry,
 		       dentry->d_lockref.count,
 		       dentry->d_sb->s_type->name,
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 90fd92425492221d13bd0cf067d47579bb407a01..4ccd4d2e31adf571f939d2e777123e40302e565f 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1080,7 +1080,7 @@ static void ep_show_fdinfo(struct seq_file *m, struct file *f)
 		struct inode *inode = file_inode(epi->ffd.file);
 
 		seq_printf(m, "tfd: %8d events: %8x data: %16llx "
-			   " pos:%lli ino:%" PRIino "x sdev:%x\n",
+			   " pos:%lli ino:%llx sdev:%x\n",
 			   epi->ffd.fd, epi->event.events,
 			   (long long)epi->event.data,
 			   (long long)epi->ffd.file->f_pos,
diff --git a/fs/fserror.c b/fs/fserror.c
index b685b329b5956a639c41b25c42cfff16e6e5ab6e..1e4d11fd9562fd158a23b64ca60e9b7e01719cb8 100644
--- a/fs/fserror.c
+++ b/fs/fserror.c
@@ -176,7 +176,7 @@ void fserror_report(struct super_block *sb, struct inode *inode,
 lost:
 	if (inode)
 		pr_err_ratelimited(
- "%s: lost file I/O error report for ino %" PRIino "u type %u pos 0x%llx len 0x%llx error %d",
+ "%s: lost file I/O error report for ino %llu type %u pos 0x%llx len 0x%llx error %d",
 		       sb->s_id, inode->i_ino, type, pos, len, error);
 	else
 		pr_err_ratelimited(
diff --git a/fs/inode.c b/fs/inode.c
index 24ab9fa10baf7c885244f23bfccd731efe4a14cc..5ad169d51728c260aeaabb810e59eb3ec1d1ce52 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -726,7 +726,7 @@ void dump_mapping(const struct address_space *mapping)
 	struct dentry *dentry_ptr;
 	struct dentry dentry;
 	char fname[64] = {};
-	kino_t ino;
+	u64 ino;
 
 	/*
 	 * If mapping is an invalid pointer, we don't want to crash
@@ -750,14 +750,14 @@ void dump_mapping(const struct address_space *mapping)
 	}
 
 	if (!dentry_first) {
-		pr_warn("aops:%ps ino:%" PRIino "x\n", a_ops, ino);
+		pr_warn("aops:%ps ino:%llx\n", a_ops, ino);
 		return;
 	}
 
 	dentry_ptr = container_of(dentry_first, struct dentry, d_u.d_alias);
 	if (get_kernel_nofault(dentry, dentry_ptr) ||
 	    !dentry.d_parent || !dentry.d_name.name) {
-		pr_warn("aops:%ps ino:%" PRIino "x invalid dentry:%px\n",
+		pr_warn("aops:%ps ino:%llx invalid dentry:%px\n",
 				a_ops, ino, dentry_ptr);
 		return;
 	}
@@ -768,7 +768,7 @@ void dump_mapping(const struct address_space *mapping)
 	 * Even if strncpy_from_kernel_nofault() succeeded,
 	 * the fname could be unreliable
 	 */
-	pr_warn("aops:%ps ino:%" PRIino "x dentry name(?):\"%s\"\n",
+	pr_warn("aops:%ps ino:%llx dentry name(?):\"%s\"\n",
 		a_ops, ino, fname);
 }
 
@@ -2641,7 +2641,7 @@ void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)
 		/* leave it no_open_fops */
 		break;
 	default:
-		pr_debug("init_special_inode: bogus i_mode (%o) for inode %s:%" PRIino "u\n",
+		pr_debug("init_special_inode: bogus i_mode (%o) for inode %s:%llu\n",
 			 mode, inode->i_sb->s_id, inode->i_ino);
 		break;
 	}
diff --git a/fs/locks.c b/fs/locks.c
index 9c5aa23f09b6e061dc94c81cd802bb65dd0053c1..d8b066fb42108971f6b3c7449dbc9b5f8df16b13 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -234,7 +234,7 @@ locks_check_ctx_lists(struct inode *inode)
 	if (unlikely(!list_empty(&ctx->flc_flock) ||
 		     !list_empty(&ctx->flc_posix) ||
 		     !list_empty(&ctx->flc_lease))) {
-		pr_warn("Leaked locks on dev=0x%x:0x%x ino=0x%" PRIino "x:\n",
+		pr_warn("Leaked locks on dev=0x%x:0x%x ino=0x%llx:\n",
 			MAJOR(inode->i_sb->s_dev), MINOR(inode->i_sb->s_dev),
 			inode->i_ino);
 		locks_dump_ctx_list(&ctx->flc_flock, "FLOCK");
@@ -251,7 +251,7 @@ locks_check_ctx_file_list(struct file *filp, struct list_head *list, char *list_
 
 	list_for_each_entry(flc, list, flc_list)
 		if (flc->flc_file == filp)
-			pr_warn("Leaked %s lock on dev=0x%x:0x%x ino=0x%" PRIino "x "
+			pr_warn("Leaked %s lock on dev=0x%x:0x%x ino=0x%llx "
 				" fl_owner=%p fl_flags=0x%x fl_type=0x%x fl_pid=%u\n",
 				list_type, MAJOR(inode->i_sb->s_dev),
 				MINOR(inode->i_sb->s_dev), inode->i_ino,
@@ -2896,7 +2896,7 @@ static void lock_get_status(struct seq_file *f, struct file_lock_core *flc,
 			     (type == F_RDLCK) ? "READ" : "UNLCK");
 	if (inode) {
 		/* userspace relies on this representation of dev_t */
-		seq_printf(f, "%d %02x:%02x:%" PRIino "u ", pid,
+		seq_printf(f, "%d %02x:%02x:%llu ", pid,
 				MAJOR(inode->i_sb->s_dev),
 				MINOR(inode->i_sb->s_dev), inode->i_ino);
 	} else {
diff --git a/fs/nsfs.c b/fs/nsfs.c
index 0e099ee2121f8831645c3a25d759793ef2ff9ce6..eac326b85314ac8080248347154d599c953969c7 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -46,7 +46,7 @@ static char *ns_dname(struct dentry *dentry, char *buffer, int buflen)
 	struct ns_common *ns = inode->i_private;
 	const struct proc_ns_operations *ns_ops = ns->ops;
 
-	return dynamic_dname(buffer, buflen, "%s:[%" PRIino "u]",
+	return dynamic_dname(buffer, buflen, "%s:[%llu]",
 		ns_ops->name, inode->i_ino);
 }
 
@@ -394,7 +394,7 @@ static int nsfs_show_path(struct seq_file *seq, struct dentry *dentry)
 	const struct ns_common *ns = inode->i_private;
 	const struct proc_ns_operations *ns_ops = ns->ops;
 
-	seq_printf(seq, "%s:[%" PRIino "u]", ns_ops->name, inode->i_ino);
+	seq_printf(seq, "%s:[%llu]", ns_ops->name, inode->i_ino);
 	return 0;
 }
 
diff --git a/fs/pipe.c b/fs/pipe.c
index 311928e8713989747605fd79f653e36d27ce8c0e..9841648c9cf3e8e569cf6ba5c792624fe92396f5 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -873,7 +873,7 @@ static struct vfsmount *pipe_mnt __ro_after_init;
  */
 static char *pipefs_dname(struct dentry *dentry, char *buffer, int buflen)
 {
-	return dynamic_dname(buffer, buflen, "pipe:[%" PRIino "u]",
+	return dynamic_dname(buffer, buflen, "pipe:[%llu]",
 				d_inode(dentry)->i_ino);
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4193817e02e8bf94f29514ca43379af21f37ac61..097443bf12e289c347651e5f3da5b67eb6b53121 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -758,9 +758,6 @@ struct inode_state_flags {
 	enum inode_state_flags_enum __state;
 };
 
-typedef u64		kino_t;
-#define PRIino		"ll"
-
 /*
  * Keep mostly read-only and often accessed (especially for
  * the RCU path lookup and 'stat' data) fields at the beginning
@@ -786,7 +783,7 @@ struct inode {
 #endif
 
 	/* Stat data, not accessed from path walking */
-	kino_t			i_ino;
+	u64			i_ino;
 	/*
 	 * Filesystems may only read i_nlink directly.  They shall use the
 	 * following functions for modification:

-- 
2.53.0


