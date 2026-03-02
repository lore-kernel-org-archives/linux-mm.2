Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BED8EB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F7DB6B0110; Mon,  2 Mar 2026 15:41:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A6B46B0111; Mon,  2 Mar 2026 15:41:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 759466B0112; Mon,  2 Mar 2026 15:41:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 601586B0110
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:41:35 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 07CC914029B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:41:35 +0000 (UTC)
X-FDA: 84502293750.27.B0A0706
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4EE7C180004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:41:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KG7Mj5pQ;
	spf=pass (imf24.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z4IeV0gJD0BYTgf1oQ8MZsxO0wH0GBtBt1YuxCm41Jg=;
	b=QsLsbAYDyPlvy4/714dNtg4aH1MmtyC6YUirRFZ6pGpk0aBUUjyIZJ+YJ+NUQmoOW9TjdC
	jECIepchObZu40xJrI4Y6nm5lhy/9Hr02b+K0qYYz9wgkcL9d+2wxqcNLDaLyYUttK8zen
	FEkiE6pvRWEaj2Wjru3PtADblUNI91s=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KG7Mj5pQ;
	spf=pass (imf24.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484093; a=rsa-sha256;
	cv=none;
	b=hH9qDzPgGa5T5dcyANzNVBLxdnWQhh7DDvOVarhCF1qzofgukYajHpbcsniruV8D0a5R2S
	giok4VkLMNbYjddo3z4I+RQErVWBA6hJKcs2kemv5M6VxeGMKipwzUpn8Z3fDHRR6tHrVB
	d46hYdRkclDyg/sMzJwmRU6qCUHF3Go=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D81060128;
	Mon,  2 Mar 2026 20:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A40BC19425;
	Mon,  2 Mar 2026 20:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484092;
	bh=z+GoXLxi9bLI354RrSKEEChGrCAoldiE2cGdeVIr/zg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=KG7Mj5pQw2C9P5boHntE0Ghr4TxhKwYJ6LSbBh9N/soeBMeuRNOiWU0wIySPbvkBQ
	 2it0/WYiOK9B0OYFYMqKhnK5RXdPUm5n7x43Rdte3as/5XyfLVnahhAnS7Xu6aKrZT
	 4hKezLXc71x+3b0LHl0lfdwuIN/lNoMY53fj+nF8XqpHadkMQwLewmbcgt0X0mZeBJ
	 UjxPF1QFPSDBGe2r9ovenCfoJjvv+Df+c9pFt/fOQ0VlyyC2GN3pXnt/RUG633Cyp3
	 OjzSFX3mH5wL6RhvSEgvlCKKf0RbtJ284iXcxQScso27VxJLQ4d9lGP/TrwYmrsyZZ
	 wem4sXKZMmzZw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:53 -0500
Subject: [PATCH v2 069/110] 9p: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-69-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3846; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=z+GoXLxi9bLI354RrSKEEChGrCAoldiE2cGdeVIr/zg=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIBlRioLxetKmbe/+123D2axdZMP7yB1p5AP
 ZIwIMFWYBKJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyAQAKCRAADmhBGVaC
 FUQ6EAClP2DTcxhoC0jLOwHAMWTN2Bu1WeWsZp+kIjvAmvXgTjXTlST7dTUKrgqeJXcZmI47Hb7
 QoZFAK6/+WsQmjE3V1zEd8dvPwukz8eoan+h8TJE0/4lYSbQgbcsunSbPqtVOUNmBRfnklBF0pg
 JYYxPNAYNkNIcIRut76MiM9XlvEpZ3Rr5SopWqYV94xe3nz56AIheTXBdIu9K2gQU3wBJrPhjfF
 2gx8oQAUUlaJS4fzKIvRJxJ3h5QKmY6lHTJ8rOcYE6k6kojUezVcQuvj2JJ3RmfMleGLYeYtwu4
 P460bajwaIQKQ94ZfscMnu49KRuV5cpybNFBObKOwoedpxajH175lEuk9dZMEqzzPboTXQDVcgo
 9CwmBJuUdDs2tg44a78wXyopgLHtBNiDIOAUVdf43BhooUigMVnFyQaE3xSZCk6JIhwgV9wCYx7
 kEWqVPbvbIBKgvU22URbypE76XP1UcK1nGdraGeVkSNrohPO0YGPOKHNjRGdg3yEG9npp02Tgkp
 ohKkfwv+CNOYbH49WOghlrhGfCuYK+PTywMmczTX88MhpFD2wr0fiRtWDGhKBFE2o8eHxFtz4B4
 I13e/2vkayBZiAUHUK8aGamLFdzKfStgZfP8ppeA3w3G+dPmen4J1tYgrpRwthvxLw/pgZpqryc
 EGi0Af3D/fYukcQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Queue-Id: 4EE7C180004
X-Rspamd-Server: rspam08
X-Stat-Signature: p98dxxr8mfw75tgekxrkuabiccrtik68
X-HE-Tag: 1772484093-250529
X-HE-Meta: U2FsdGVkX1/82cVw9Ajj2jLVDYtFUE/p0I9ORV3dXznKm9binpN5XeQj3K3FTxJN3MmEM8nN4DClZychGqMddvB28UGP4YziJlRmN3+OqTdlb5BnxdecZTXBD3jNy659/Xa/reDYCHcmx4gB3hgfSgdaHU85XRYQx14z+lqGpK4R1jDRr96rcEYrSjjMUYXFK/Ss8mEC1tqyA1wqvH9LsZidsyYUGWVFFpNHuWlKt0EzvN2pCJloYQFaEVEAS81PvBtzJgg2Mw+wfGulwxJqCT4cOHymS9yTqLX0sqbk3I0Hf29cFH/Gk8ynjg1MbotQLaa5oSQha4/bT8W/6QbubOK3A5PJoqfSAmDGbk90QobUNPGMUGo9bDg7cXt+cWeIypUcXU2TR8Ks2OfoAE2vFEgbT6eQGxgy6YTX5ynB202LXPys7yokrewzQwZkLvIYCMT8+HgdwtGozGcCU58EpelJyNpFQ8qy2/jF80S+mdPDFIsfmlNe/d496LsKhi58l6TF/UwCKhnW8fBXk8eeuIeH7/Nl07IOYV92cYYs8mhLiob3sVv/LQsKZKfnR6SJj2ttE9f0e8G2Frcxkj75SaGLz7KKssXi2uSZq+fubj5jIpVOD6avSVwFlETSS3epUecYSXpVk58lSr9bclAkA3QRJJn7yzGZ2rxiRhEw+NpFEL+EhB9Jbo8xi0iK8SSvvcgJfectrzZnyX9sxZpynz7t4bjn0Fg6cDSSo9Ign50DfPtH63vNe6xtouOy+L4KocfMBOEo0CPIZKWhqLzz21AGi9SzDt/oV+A1H6JtAGc1nb85+o8TPQbZ1Wx1s3S8QcjDmR31ZuEFuFqfDc+bgIX2Go/W59gUy3W14YLyOk8lCNBIzuEbaFsME8oMvCmJGN4fGG9MLeQd8ImCKBP7m92JVEwXx1G4FPaGqXmQ0xxNq8+YesSfJccpsRdVVv697K3+s85Bqe8Xrs9bxlo
 884DB0Ni
 SjTKbwL5yvKKFiTDJS648amujQ7V3RSfi5mEBszgIlohKJCOm6MvorcccRON399rESH7qMjyv7B8w+lFC1An/cO8yQyM6UBVYZJNZSK5OtulclwkGcmUEQbgMobjK2jLGf0CGwXhC9Y26FYZhcIcCfWpbTStmioGF64zeCLl8C6/RW4jOen4eQGECuQw+lxAS+UWUq7yZCLgDY5l1rq5gxIn8vLcoRk2pniXepK/KRBmvkXab6a6hBJUKDBDshXI1zukFor9NEuGVezjnwS9mFM08JwB56P7gkKnWo121xgN7bzJIlkx31CNx7yDJBoU3U0H1wH/NcXnumYjqoVINEtgBZlZnFcKGsowMWV20qRa5FqAYaeQtgc0uobyD7h0H/AFp2GWDHgHCMAQ3PpvDJCkTAZCAHWbe9g7BFVLzan4pxvzYYHIVwm4A68lEmSTqtydgimKtCXNrQ40fi6SWp5SSud4tFaPlmRQdEyVWNzuZkSVmcGo89bz2Wmx0jNzNTehtM8FzrIWGSuSAa13D8rpFo7OhaRAh9wwc7oyAGdl0e3+dRXj7IjzV2KKiqHO2FYZ3YE3evaYSIDHdbNybbnPG4Hiv/UFFRTx4k/PiaQncRBghZ613cnXs8OIvf7gpppDt+J6MG0kRASc3X6c+X/FjHHO6VVEpfFdwFy53xpIwfAbU+OMpRBy9d7WlJ49hbMvjdVJS376NtBCoy8bt7e/S6DId4rr2MQpmmiw14d6N8ukaZg/bRSIVv6Wc4JcIatJcEG7jQrGhF+uKR7cKZnlI6obVagltzsiGZqwm1HkdPXVTB41DyAV2uQ3a8T1JXIgs630H0ux2O9OWSO8Vi6hV7AkxqDibjtOismbljmuhhWuauBk63l/RwZlau3hF+lFQp4YkeDD9MFPcNRjmxImctTfUvLbAyk5Y0Pss4Y1fSvA6nOYrilsW3EIn0m05PzmCNhuJbdM37Mm2Uv+pOi7rBPLd
 FwecbQBw
 mf19kjOngeXmT85VbYuW93Xij8SuSitb9IQXOpChVhWyLz9Cqavomerh69kAp9cDsidb8xNIkH52gcLfqhArjcUHCQsGAD7ZpDcz23ZAJbb5zpCdPJ0/5VgVJH4RGGVqdHl/YrkpjYqIJwSjYAZ0A3cc7whPeujJhKnHsQzIKGc5Lte1WUXVvryFwv6din1qvf9aJCmLhiR+4IV5Z8Q82Hqf+1VCfhbckXjXULcL2FGJxHW81L8rW6ssvSCigIyV1baxxEDYxgpu1Y7wyom6TGVxvrqHfRsQTDqiA1QigTVNpHAdE0UytMVzxQvxa5r/zd5dg4v9tmOKd2sraWb3bwqmaXZHfEk2izHuDMTPJWqRFCj5jWqTllK0cmS2/mC/pXcr0AeXqyJ6JpmMu+yIMVzj5Wo668Y0BWayk6pLxGp2jZYL9Jq+R4ccCXL5hZOUx3ksrxpMzLNFnNMi9LfFB6VI9b14XIAS22d8kQHqNCBKIQ8NnT0P1tLrfUS9j8xZNj6xwwGsci9UQkFnSgtnQgOhq5SoXEuxXGdX9KPOOZJMro3eEi65UzqTRFypTzLl+FIwsUYffVhfeF4BoamwXBJ8tQgaFU2m5mgxWdntmVmQWxvrlaZQof0wqWMEM/stPcT/Lnbxya06gpfb3lhKUXtg/+ekw0u9wykuwv1Y8ydqW0FqvJVn18LOAjc7qgkevPDZ6wWH8pO23aEu1uURLdWhkOxn4sIl70o5Yy0flW071BQjfH49djlcUDlMMYNm/IR/aXsu9eHk6sbhKTMuY4cFF8iaKSdcC445/pP4ekNU33mKwfTXS0xl5/ds2iazj3UBvY+2T8PxQr+MNnzNqFJLUQL5CPmqIqkcwW1+3SpJrrOhQwNJPhz58TyAfu/vvEMMyz/d6WxWnLapW94fEqkuchwkKTPOz3scjkP9dlTqviHLqSw8diEEwlgmKsK9PYFdLr1zyesdChIALVrLMeaQuzVRb
 9kYYY/zq
 gu+4A8nnjOM5i7zS1+Rv/0SozwKr2+K9Bt1BmyUXLuI4DAYd+X2c+n1u8pIJTon4DYs/+qb6/85GZgAOfeKK+kDaBcuBDp7PCf6w4NV5I3nSEmVRQfvStsnXtUNqcx/ZLdEoGfm0u+JQ8G6MYTyJAuqLaPOqEGWAo8L+PL/cOpwv9QRlskNQi3KG4aTt+gfZtYeoOgNcFno3smXcdjpHE3Fj9FbFCty/3/1x3wuyuyjuqCvI/rQ7+cFsbVS0VrIfr2gP/HyN7QTOr+Nwdiq5agA67xuFkKzoDzsiHPGBxcYvtEwTZf65GNmr3Jkwg3WmIghnottreRwylGhHN7ZXu7osNuHiTzXteC0QVHHdNdcFrFtVxw7ck5qd2oFFxfM3q5TrxCH57HkHaMbOSIGknUln8koCZ/Ezm1tFGP1bdtNuzvwcsZn5cl3yQzUv6EHnR71P7EZt+fgDP0OHrDjdlckrChx51aLUABa/IB5MaktE7fJf9WwG2873oUGdTfKh8Ak2KZs+7GqCKmtPJ9eYAXDVVu+WEhMmTpmlQhbRLaj5iz+nhpXMrMhPQuYJE8wwilAno8c4wCM0F0yQ+P1lEFd2Ql+o6ixvPBJ8cS4VC93URQsLJh6iBZsuLltyi2pGrYC8sFmQnVXa+ncBgsABMUl4YH8OX0KaChVqt/RJ7ITNb2DxNIH7R14BXzJIghplyQ2VTr8gvRaTAP4IWxoZrTtIsmE7+u1JTkkWIAGHm9oZw8cKdx+PnI8+Tx0/Df6RDPplMFLDnCv+RtKdprmp0/MCoja6hgTwQvoE1Jpkx67CDMDCCQKkD2RR3iPdcZxourw+wW7BD3KF4bKiZ67PY0giJcH5QPZf03TujRaDrBGgSzUifmQg3TvAMlyaUPnYJ5xkUjpUWO3iT8gaSq743otiOsyrsyMAE93vLhWOfRliY4RZ4TIWBl1CxwP/Rwrr3o2eWYa97JXB7HRJp8/wnBHp/2Tbd
 ZE2rxgoy
 R1LjTui4m3mWEDHjEtJn7dTtFeu1n92bydSYDASt+Tq7j+DiG1r+r+YRDQL2eFozP8etogSU7ollJgD5rjyhY90cj+TRkzrAcpMmLDWwwwyJQvhLomg/m+ZT3jLKPFCUxK01F83ty5b346nv/J/rvUuZTWCqceLmS5ULQi8LaQbq4W8LQt+qTBeH+LBJe4OHGWriu6ykmoqXTWfEkGWjvWU2G3N9Hhj+GHU3pDv6VHpD4HY77N8Iz5ycBMzatm7erIlzZopjjVm1oAEhMRacNvZSa1D8X6JGOY8iS6/i8vllCh7j7xgaXOTZ8UKDvkN6odeY/RLP7CK5UJ+sJ7Qwf9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in 9p with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/9p/vfs_addr.c       | 4 ++--
 fs/9p/vfs_inode.c      | 6 +++---
 fs/9p/vfs_inode_dotl.c | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 59c1d3f3c45300f5c796a2a441842a1a781e7291..c21d33830f5f021904f490ab6185db5fd40f736d 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -36,7 +36,7 @@ static void v9fs_begin_writeback(struct netfs_io_request *wreq)
 
 	fid = v9fs_fid_find_inode(wreq->inode, true, INVALID_UID, true);
 	if (!fid) {
-		WARN_ONCE(1, "folio expected an open fid inode->i_ino=%" PRIino "x\n",
+		WARN_ONCE(1, "folio expected an open fid inode->i_ino=%llx\n",
 			  wreq->inode->i_ino);
 		return;
 	}
@@ -133,7 +133,7 @@ static int v9fs_init_request(struct netfs_io_request *rreq, struct file *file)
 	return 0;
 
 no_fid:
-	WARN_ONCE(1, "folio expected an open fid inode->i_ino=%" PRIino "x\n",
+	WARN_ONCE(1, "folio expected an open fid inode->i_ino=%llx\n",
 		  rreq->inode->i_ino);
 	return -EINVAL;
 }
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index c3eee0d7a70dfe07ba09ce36458228fb00c5855f..d1508b1fe10929d8d847af313f7661d693167d96 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1245,7 +1245,7 @@ static int
 v9fs_vfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 		 struct dentry *dentry, const char *symname)
 {
-	p9_debug(P9_DEBUG_VFS, " %" PRIino "u,%pd,%s\n",
+	p9_debug(P9_DEBUG_VFS, " %llu,%pd,%s\n",
 		 dir->i_ino, dentry, symname);
 
 	return v9fs_vfs_mkspecial(dir, dentry, P9_DMSYMLINK, symname);
@@ -1269,7 +1269,7 @@ v9fs_vfs_link(struct dentry *old_dentry, struct inode *dir,
 	char name[1 + U32_MAX_DIGITS + 2]; /* sign + number + \n + \0 */
 	struct p9_fid *oldfid;
 
-	p9_debug(P9_DEBUG_VFS, " %" PRIino "u,%pd,%pd\n",
+	p9_debug(P9_DEBUG_VFS, " %llu,%pd,%pd\n",
 		 dir->i_ino, dentry, old_dentry);
 
 	oldfid = v9fs_fid_clone(old_dentry);
@@ -1305,7 +1305,7 @@ v9fs_vfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	char name[2 + U32_MAX_DIGITS + 1 + U32_MAX_DIGITS + 1];
 	u32 perm;
 
-	p9_debug(P9_DEBUG_VFS, " %" PRIino "u,%pd mode: %x MAJOR: %u MINOR: %u\n",
+	p9_debug(P9_DEBUG_VFS, " %llu,%pd mode: %x MAJOR: %u MINOR: %u\n",
 		 dir->i_ino, dentry, mode,
 		 MAJOR(rdev), MINOR(rdev));
 
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 18a3792afb4fedcc870a6090ad364a7ed3c5e9a6..71796a89bcf4745363b59af1047ecfd7e3f4d956 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -691,7 +691,7 @@ v9fs_vfs_symlink_dotl(struct mnt_idmap *idmap, struct inode *dir,
 	struct p9_fid *fid = NULL;
 
 	name = dentry->d_name.name;
-	p9_debug(P9_DEBUG_VFS, "%" PRIino "u,%s,%s\n", dir->i_ino, name, symname);
+	p9_debug(P9_DEBUG_VFS, "%llu,%s,%s\n", dir->i_ino, name, symname);
 
 	dfid = v9fs_parent_fid(dentry);
 	if (IS_ERR(dfid)) {
@@ -734,7 +734,7 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct inode *dir,
 	struct p9_fid *dfid, *oldfid;
 	struct v9fs_session_info *v9ses;
 
-	p9_debug(P9_DEBUG_VFS, "dir ino: %" PRIino "u, old_name: %pd, new_name: %pd\n",
+	p9_debug(P9_DEBUG_VFS, "dir ino: %llu, old_name: %pd, new_name: %pd\n",
 		 dir->i_ino, old_dentry, dentry);
 
 	v9ses = v9fs_inode2v9ses(dir);
@@ -798,7 +798,7 @@ v9fs_vfs_mknod_dotl(struct mnt_idmap *idmap, struct inode *dir,
 	struct p9_qid qid;
 	struct posix_acl *dacl = NULL, *pacl = NULL;
 
-	p9_debug(P9_DEBUG_VFS, " %" PRIino "u,%pd mode: %x MAJOR: %u MINOR: %u\n",
+	p9_debug(P9_DEBUG_VFS, " %llu,%pd mode: %x MAJOR: %u MINOR: %u\n",
 		 dir->i_ino, dentry, omode,
 		 MAJOR(rdev), MINOR(rdev));
 

-- 
2.53.0


