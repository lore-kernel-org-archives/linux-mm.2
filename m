Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A812EB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C37D56B015F; Mon,  2 Mar 2026 15:50:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C08DC6B0161; Mon,  2 Mar 2026 15:50:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA3106B0162; Mon,  2 Mar 2026 15:50:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 907446B015F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:50:57 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5249C5866F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:50:57 +0000 (UTC)
X-FDA: 84502317354.23.0E22179
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5D2AA180005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:50:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BlhHvKKT;
	spf=pass (imf24.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oZQ9XAHx/F2VszjMx85FEq4hqw/fYyqjFHQmkuoxLA4=;
	b=doBxTRST0wkVtr0IzNFdMsqzg//A1ZImDVzI4llVHZqT1cM5mlvlYWZ/wQSPOwq3AUM1bA
	ar+DI7kYKiXJebQkrSJi9CdfN/ledqhpWqzfhJCFTmyUqtF1PPw7etIWs8JtCY+oAIxWPV
	2vJ38rm4GcEDJdzoAAJQIVLflbsAwZw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484655; a=rsa-sha256;
	cv=none;
	b=HcbqtkfFGgyqYQ0pLfJdrWLMGX8LHqUPRU41jkaI8tZA6I2iNmbCWYnqvKa9+KwjaNvI6M
	QvdbF9M3PuHnji+hNq6x+XT2MDtsDsiTGcjZOqaIRroUI5ujGvi4fetYTnCeX6ecRUthSR
	t6Yk+WOwRWX0w15kZFBHzaxA9lNUEfs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BlhHvKKT;
	spf=pass (imf24.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EABD43420;
	Mon,  2 Mar 2026 20:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9472C19423;
	Mon,  2 Mar 2026 20:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484654;
	bh=SOp+TCAcWU14458z3P41zNtvFPXPqaHO+NSpuphSXmM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=BlhHvKKTmWKpaArbleegV5D9iJfKYgVc1Ag47K4vh8l2WoEQlvDiAlOUfcaJiQn/x
	 YZ3TuaBaBZnmqWy9RtI1BkKL1lEKUCJdHC0Jq8uG1D+nkUz6Jj1K/33+45e34BN3J9
	 yUucRO1TIYykVefYInk7HFWAWl76gBNRtdx8Hntts5XT4UsJguXUvyC7L1Yn97iv1T
	 HRcYNcjwTZgoYaeslYn+t0Odrqr+M1Rif0mf7iMTGSFfoS8huQ7Ov58Ie2ST3LE1go
	 rGLMlwptMGRcZ2QSWzb9hHf/ifr1aTEnvMlEw//BUapFxZg1c39ac5sw2tM03WufHB
	 7FGJhZyXxKmOQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:32 -0500
Subject: [PATCH v2 108/110] net: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-108-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3949; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=SOp+TCAcWU14458z3P41zNtvFPXPqaHO+NSpuphSXmM=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfINZYzNfeJDnJtOkwVRDDqcdOF2gbZgzuawW
 9KnU8Cb872JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyDQAKCRAADmhBGVaC
 FcVuD/4ov2ji5P/0u6Xb1ykGEi1x61GVKHAiEyWib4jd6kuFqf7MBofKQLzuo1rnuVMhzC8MToY
 yEoggMc/8oKmlkow+isZ09hMjFe8ZgEg8zDnveJr+6LwHJsRpql+3Tkbe2+kZFkw4NoCnYwWZ2A
 spOAfqWUnrvmY4DKi3Vh5kXNPyaZZ+TCmUwkXp67HXlUjsfeS1cmmKZjDhztgGZOFGztAJOWh4I
 dVO2swrQECYjgjOihU88nPC/Dbn36RMUGyFG8+Wo83Cik9bPad7QXuKU7GC/eZhVzE8tnQEWlw9
 l4fJSQ9JxyRY8ibNTh7HvNV16L7wEd2O3I+j2KQYi6X7DLP9h5cW4cUUTJAlDqXjCCjhBhJdhw5
 PzhhZJtEIQnfOvk3HdK9Rqo8fMwr4kzuZXQl181o2z7i0cO2QBVHH/jNBA4Kr5hLJ/w7svk4ENK
 i02Hwr+lKuW+vL/hUBGAqudE8Co4DKeuEiMDXr7FlaZbTMCzCSmsRiFHRVsotNlpoCfbpnbo4Ip
 L7ohcSl0hYp73IxD9R2zligMiLrmCSfLhnF+E6QpXyn/UuKhcGuT73PGjP393ZDY+IzmArJEqJt
 enEUod8mlFX0tWTudzv5mwipUqiHK419dXzKPUAZEgf3h1OFa6vXLStc1bPtOqN/O2CBfpZtjGP
 oydDqDXPpkmYCXw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Stat-Signature: gd1w6uhtiosm1n74dqe8kj75drbi37pn
X-Rspamd-Queue-Id: 5D2AA180005
X-Rspamd-Server: rspam03
X-HE-Tag: 1772484655-8503
X-HE-Meta: U2FsdGVkX1+yc2JQYDU+ai4kJAzo9dYvLuMGvxKaA2qsUaGvSKwXiMgwDp2wSJkHKeWU1GGQDliBavneLh4rAcCVRMfD1HT0SIpN+ie3ee74i9ijyNKLI5iEdlCt+SNa3vFSO8n90HGa0F8JqCrUp5vK7qFZL0QWZ8nxpwLsekKIq815dclXUq94/J7oSuqqgpfBkIzRzxhLFb5qzOtdFh96IscIJTByDoaWbnyG9oenoXJUZuZmB6g4oI8V0blV/dFqK4QKOCpfzHm1ml6iV8JQKl2LD4C9rVFWzmc+KtGkQ8DwuYfSFwCl52mrkNFU9KwGSwuoGkl5Avd6thBkBvSMiwHcKYvwubfK4AUhLgumtSczyG4f00PIigmHbrSYwgBWg0rZ6TCzm03JyAuKMHTTFlKGseQANx2uKw6AwQPrkzUkfvZujWRspt/AV8KIx4xz27fOt4zxYfSu1+QHgefENv+jaUpa+B+BC4xTsK0y/X7V2RgCdMa+57c4NZR19IISfSUbIvkfpnHCzhCDu4ChZBxuJLUPk/T3YziYv73VsmZoy0KSc89CsKCCs3Rxn2QWArIPSpVTz54Lm0WApI+r6eMsMuCWzZy54R8y8MZOkXLfTrAvbIAd2d1TTzP3xa1hvjK0UfZBdiyR3YES4uUwhcmo4NA8E7Mf6AFVK089rTPqRw0uNONUvocceon8Qv/OSqXvf7atjkE47jvEo6ivknu1EAtUgSQnPZdstnb34elU94R6PQSTHEmHtccrF+E5ityTpUpt+z5gAKaEnA3mDgnCs3Z5FLddC+8LKGx7L3+CmfiFI8tSJXGIR1SCl7xTH7hPITULnzP/QvyVXHO1PlnHI0l8BmXbODJLfIIsKCYIne8o/bVnGQPrrVSozuDEaTFmaXTAIp0TkB1G/uHBCJiDKI70jcrG1CHc7AmQ+hyaESj+cSfFAouUiKHT0JSGDCTV896loeny9tl
 Y8vtDgmS
 VPnavSuDkdIesy/we/aQedV+6b7nkqvbtioELXetdW/KO8sdLkD0IR0HzC7FLCRDubmzxRyYD2G9IbM7nGmJ1JdEbDI7NLniviUGM24cQ9smzEDeCtpqNtm5R08/98hWKuzxf+j2MKLU1H+DlWvkhaH2+N3X7YlxkIZeAly05XImhrXt+kAM5vdLjOJ5zNxAV2m6jwU+WxZuhP7zlm9p+vz68yACCv8JgiOTGjLcO3WIB+SBQ9cKt7lJFHZoD91lkQ4nLI/9Psb7eBXew/rMx8Z4M4Mt1PpOx6TZ1tywjv9lIJgqRWd37xHO1QjyJXYw3xsukbsEACRsHfDl5RdMXuQ0ZOoQTOA+3LORkGgsF2XfYODL00YmNHXghPSAHOUgAwsnc1G0ZBUKtLJjju/KWqEIPoRrU/tLiZIG7iMff4xnCg/TJwtvWbaKZWyLJZ1TaAlp3mIvjJRbVou70BoJ4KjFxjGLW2/i1r5faA8hzT8Md9DEqTXgxs6UKir+KnE9ZYlaBJGFRjgr0XTBwbTklcUT1aJzcfmSDfoiignYqG42BwV8am2QVS46FSgAD9G/aqvxt2RkiUirBafUC50v6/9+sbHeLQkCXDFhtHrIimh8OjJxyL9c9bY5cvVlfQDoezDxeZvu9xvxlDUae+gX0A4SKe50ImilVsxvQuIcSywLeo6z7ZBrTHakzr2LpJJLJrpoelFzmwLaAOWCoxV7ywCbWUZP7B75OQFhDoWeHJrHFkQl4sPtl6OeQSXzAraiGgfPc3GUWDfYSxDu0T8RSLcEWqQ5K24TcA86DJyCZiw69qXbuTK4KJPCrqGDqqVi/QKF5HsmFDNIlluXyXU34eDzV/7tcVBcIyqrwDZleBu7JO7HrzmSndRioAjLs8iU/Ye5uAAOM9ueOqFuTSO3cPpC9UYO05tPfwBkcJKYm6AvJK6RyXQhpTaPTmgX2/XpXvCf/CEs55z82/1FycD/JBLy1eg08
 0GzFog05
 iWAVM1ZbkMVHYCFTmelcqwfBdClHRzpDu7LMW+js35yIDU7hO97oZlvNTH0QKYxz73MlzG48P/zJ8NH1ZWM9qdX16iQpg5TxcV+Jip+C4JMy2ZXL8sY6BnWk9+fzJG6RtkcENa5wHNL/C208j99Xtrj9Boy2AstWyobAKm+0ruxCk45WZOUtTkYJwFhc/1ibmki/IRMQnv5aTmI6THF35hyUXIuIqYhELpAv0NPaVA6SbanyGTqoz4M0k6MGcngOMWz36wlyEnqYeOAGa63TzUXj8Xu6WH1f8v1w68IE6PMbobiI1+ZRrSwbzBHM5zHgYbGX7PaES3txmU0JCivrwJgyjWgkOrrEL2Cb9tCMADs2MvtE6nZZbhFLwUhmTKE8F6nP87d7UdRYCfFEaURG3G2tEoN+DOSwdBK2IWmcCufzENr2aP5cnIxMtKYQ3y5qprqP6Og+JESyJ49ynDFn/EgPeKU+r5XOUaF1A/g5EM393paiGN6EvX+XAgUbK3IeRwsTT1YOwdURu3zUmk3+10QUbQYUhvpiTySe3XVGaczh4gzNENZyuWtCQqMcjXSSlU1ooJvoXG0sZEkYZmnWIzFk7dHY7CoEq3mo30+G3VGuTZGtvpvd7GomF9EKFu7pE2kDe8q6yqziQ8h9/Do8bH9P0epsiKf5TMHd5FrG9XW5KhiGFMTNr0zAXqeWrO/Ta3GxoIBmeIH1JVbYxJ/G4+h+15zjJujl93zVyK5JrbLvE4M4GlfrgtLDSq9F+qdnkHZM8pcNlHEs4mzn4B9TK10qY+cby2j8dPV4ucnv8yzqwhVYaDyPtWg8p499GK3+stcBOGjskKAQ/XvG+O010SZkWliDXde8okFGAA9y0uU3EVtno3SwbBaCxAOz39ydSNqxnRA5uxnUHf74+Qysv+pf9dwPrFl37QSvd9tL5KZIlYUI4yDjK5OEQQ85Sf0A1Sq5U6o9jEssa/llHz7JvVWW1WHkC
 Bx+myLJj
 cwIzLBKJ+0Iu5UDzF4x/Zl+9Rde2EKuXBwMaoo0fQPBLmMJ0SKCSoyIZIqFQ+fp3p2Sm/9PzLQRv8S4GFiwMEaupjdSD2kqKz+NNE0lNgo27XywSsmkMgjAfxU/6GpE/tiLNlI68GEwSJdgVSyg67jxnZ1W39iH2iHpwrKiCkTwJJrCJnKmuZrkNThjeVst+hY4AR/igZJVLu4cA6G/dIeD26NKDWX6aITIhGdUleBQcrwU0CsyOtkd261/bRUIZnstn9Hg71tKxkBIIlM7dLX/70vkJTelzXIdk+fsZJkBEFkLS5Hftn8Hr/0Yf+av9jSRhoU7VriD+a6mN09iwM9FkSHv12hzyx9aZ2semSnv/vmNTOHpqT4ClWO2PAKPvsl86dah3fZKZb8dxEsGA65AN1dZ1zVJzLmr2kRC9drDJ02biK8Kky9C44/YXo3TJj4nwgvv5+k1FglG8Ki7k0RfGlWMWn0PHNofpYS7svTCeQvICsxfIg+BcvNTDnrNv4XpAHqBgOjq584RQyPbCKwfojHPn3xwE1cHBYWe81e3oNLSLZYzSE2GV6b2YqLX0yQw93P/R1oopqEc5DxyzKNZuV2Upfil6ep2JTcbh3yQS/Sg1bh/teUonW8a4JNQXjVDYRjXjk+yYF2H7nayBdbSgMJJ6iHLOuwxXUGo9x5Zkswf7n/wLoeGS9+Bk8TqO/geLppb4vjaVn323AG4W9Lti1A55guvPbnAaQ9BHl65GT35wu1LhNoioWykU6KEcqTgtUay7Tnz1hH+gBceBtbb5xzX/ueR3SqXZt0cfFQEfvq0lJp1oEUXE+VjgSCceAoCcmM41XFbq80zQyToPh+iqjezSzG0z2CQ8cPHMTuks9tSYCp+yIi0CnqwNst3P+ztH54u+Iu6/vA4ZVHvStBunWHYFrPsIlmv2+gcy7FVk9qY8q36UoHB1gp0Dvizy9qEvlWQiniBw4V/3goBkMI89jQpVm
 gKQB2Q0I
 ATYtjdb9/FOcVT0sNZbriDdZ4Pu0yjxZFED9fPApYnNTJbaAXSo0612u4BWrVvEyb98yoDPDmR0yPtMrSNKqz/oqpSPsSXKalGHTJWg+2IhHQDwdUKQ1xonGz0HNLFNX3vqp4HTzlPpXD9RbwV8c+OZaRMcJWjW/8f5fiRGecZ+o22TPcXQw10HiEumaKx0RitBDSaG5iE6+HpQQtb4MnIlrZ9VhmLepVJEE/SEG9c4iUXjEBEJRHOX1rkM0OfA8wr5+vDKDE05hhTLnCl2T9VHqIsHm6Dgt7Yt2TpgnTY0BIgOY4xuk77drUuXOxFltcMmrnvlSxvBh8tVP2rnLQgO4/CZzXkQ2I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in net with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 net/netrom/af_netrom.c | 4 ++--
 net/rose/af_rose.c     | 4 ++--
 net/socket.c           | 2 +-
 net/x25/x25_proc.c     | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 883c8aa90235d746a688c5f38b812c20faa7c770..5fc54836dfa859379957bbfd299881e7d2f9ce89 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1305,7 +1305,7 @@ static int nr_info_show(struct seq_file *seq, void *v)
 		seq_printf(seq, "%-9s ", ax2asc(buf, &nr->user_addr));
 		seq_printf(seq, "%-9s ", ax2asc(buf, &nr->dest_addr));
 		seq_printf(seq,
-"%-9s %-3s  %02X/%02X %02X/%02X %2d %3d %3d %3d %3lu/%03lu %2lu/%02lu %3lu/%03lu %3lu/%03lu %2d/%02d %3d %5d %5d %" PRIino "u\n",
+"%-9s %-3s  %02X/%02X %02X/%02X %2d %3d %3d %3d %3lu/%03lu %2lu/%02lu %3lu/%03lu %3lu/%03lu %2d/%02d %3d %5d %5d %llu\n",
 			ax2asc(buf, &nr->source_addr),
 			devname,
 			nr->my_index,
@@ -1329,7 +1329,7 @@ static int nr_info_show(struct seq_file *seq, void *v)
 			nr->window,
 			sk_wmem_alloc_get(s),
 			sk_rmem_alloc_get(s),
-			s->sk_socket ? SOCK_INODE(s->sk_socket)->i_ino : (kino_t)0);
+			s->sk_socket ? SOCK_INODE(s->sk_socket)->i_ino : (u64)0);
 
 		bh_unlock_sock(s);
 	}
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index ceef3e801030d4782b3d05374b6ef48a9d544b14..53557176b41ea76fd44a0554568dedac7b3c91a5 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1479,7 +1479,7 @@ static int rose_info_show(struct seq_file *seq, void *v)
 			callsign = ax2asc(buf, &rose->source_call);
 
 		seq_printf(seq,
-			   "%-10s %-9s %-5s %3.3X %05d  %d  %d  %d  %d %3lu %3lu %3lu %3lu %3lu %3lu/%03lu %5d %5d %" PRIino "u\n",
+			   "%-10s %-9s %-5s %3.3X %05d  %d  %d  %d  %d %3lu %3lu %3lu %3lu %3lu %3lu/%03lu %5d %5d %llu\n",
 			rose2asc(rsbuf, &rose->source_addr),
 			callsign,
 			devname,
@@ -1498,7 +1498,7 @@ static int rose_info_show(struct seq_file *seq, void *v)
 			rose->idle / (60 * HZ),
 			sk_wmem_alloc_get(s),
 			sk_rmem_alloc_get(s),
-			s->sk_socket ? SOCK_INODE(s->sk_socket)->i_ino : (kino_t)0);
+			s->sk_socket ? SOCK_INODE(s->sk_socket)->i_ino : (u64)0);
 	}
 
 	return 0;
diff --git a/net/socket.c b/net/socket.c
index 24b89b8e39405972dd602f3373ae53d56a4c625d..89ad750ea536a0fffddd640ff0a47810be1cf16d 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -399,7 +399,7 @@ static const struct super_operations sockfs_ops = {
  */
 static char *sockfs_dname(struct dentry *dentry, char *buffer, int buflen)
 {
-	return dynamic_dname(buffer, buflen, "socket:[%" PRIino "u]",
+	return dynamic_dname(buffer, buflen, "socket:[%llu]",
 				d_inode(dentry)->i_ino);
 }
 
diff --git a/net/x25/x25_proc.c b/net/x25/x25_proc.c
index 196e1850e925e4034b2ac71df151b9b953fb2570..7e0dbff8f538f2682665b78e89ce87d56326655c 100644
--- a/net/x25/x25_proc.c
+++ b/net/x25/x25_proc.c
@@ -96,7 +96,7 @@ static int x25_seq_socket_show(struct seq_file *seq, void *v)
 		devname = x25->neighbour->dev->name;
 
 	seq_printf(seq, "%-10s %-10s %-5s %3.3X  %d  %d  %d  %d %3lu %3lu "
-			"%3lu %3lu %3lu %5d %5d %" PRIino "u\n",
+			"%3lu %3lu %3lu %5d %5d %llu\n",
 		   !x25->dest_addr.x25_addr[0] ? "*" : x25->dest_addr.x25_addr,
 		   !x25->source_addr.x25_addr[0] ? "*" : x25->source_addr.x25_addr,
 		   devname, x25->lci & 0x0FFF, x25->state, x25->vs, x25->vr,
@@ -104,7 +104,7 @@ static int x25_seq_socket_show(struct seq_file *seq, void *v)
 		   x25->t21 / HZ, x25->t22 / HZ, x25->t23 / HZ,
 		   sk_wmem_alloc_get(s),
 		   sk_rmem_alloc_get(s),
-		   s->sk_socket ? SOCK_INODE(s->sk_socket)->i_ino : (kino_t)0);
+		   s->sk_socket ? SOCK_INODE(s->sk_socket)->i_ino : (u64)0);
 out:
 	return 0;
 }

-- 
2.53.0


