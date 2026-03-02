Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8087EB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DC9A6B0089; Mon,  2 Mar 2026 15:25:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B1BD6B008A; Mon,  2 Mar 2026 15:25:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35CE96B0092; Mon,  2 Mar 2026 15:25:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 20AB96B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:25:47 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D573916030B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:25:46 +0000 (UTC)
X-FDA: 84502253892.08.F17BE7E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D56011A0011
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:25:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r7BFRfZy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8akQWP1V1OAEkYFs1JWuxLuZhCM+3djkMbldX1PG7Yo=;
	b=vwKWx8K4tAOuwoj/STZAqzkdDDFCdh7c6NYiBKz3KN/5NrKMCziLgO2lONuMa9QceLeLFh
	CkLOB8OUX0soOOhxfdaTW42FXnHHU7TUXM4VpBZR5AfseTsfbjALaMQnoargen5NzBnWiO
	UbYJPZkY+2iJ6XVaIC84dSReBkyk4oQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r7BFRfZy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483145; a=rsa-sha256;
	cv=none;
	b=zFYxHQRXEFALTPjw5fpHYP83wSsTVxsDrMPPNro2yA+XQXc8hthZ1eded1GF2mlYWqZ5kk
	IjpGYq4h2oZqmbeYc6DUIy5i3WoESzUK/Owim5RQVpZFQc47V++B3s3RHOKnodDEzaRWjx
	QiSbF4dHnTrMvR9r1IMsNrkf9DgnDDI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F2C4542AC5;
	Mon,  2 Mar 2026 20:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B490EC2BCC4;
	Mon,  2 Mar 2026 20:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483143;
	bh=1QnrHxnBcXfO2uSVzU2vj/PkHMu/3m9r2gHHNQDxEW4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=r7BFRfZyRe9aj6jmw/n8KuWCzGH8zgO5mUlf7g6pyX8b1KNAIQ0Pqz6o4pyAFypRr
	 oT5YEYKwRvzi3Q9qPwDqHUKXvjJvSN4b0FUeUXAno91hQj7sL7QlntE/b3FydK1fFS
	 PYmZdvTCv3eWnNZ0nmCfunqZKoLuZSg7eWn2H3qbkJZaziMBI1BN5hmL3xmrhq51hW
	 hMgf9bjA1CIbL8zYwSscLjtE+V29LTeBSAZoPsT95AnGA+kU9SY/aMJawiwuOxACnL
	 LDkCX9mzv7vUui9cHmwlcutr1dSYoAzoFzQIDkCNrDJgIvKkFcVOWUJhLVhsIy3JZo
	 oshKp85bElhvA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:23:47 -0500
Subject: [PATCH v2 003/110] audit: widen ino fields to u64
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-3-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6157; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=1QnrHxnBcXfO2uSVzU2vj/PkHMu/3m9r2gHHNQDxEW4=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfHw8RCQYUtuyf0oxb41H9gT//L3ivMfz3AzN
 o8PjWqWq3+JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx8AAKCRAADmhBGVaC
 FbkxD/91B/Xiija72btQSyx1g+eqGEjGVA+A68lG8l2V7F9fsWTmUXuUYGtAplWHKYa2A2/uPRw
 gFr1ruDZBin9emBmoDC9kk0uafOvmlmWNswRzgp0pB18gu72O+HkD1o6riCzw36LIoIxoOyNo22
 Nw/s0eIT6LIanSuwvgaTDTpPjQYxYKsIbV5+OHqJv0q0KeiWKf35apujN9PFHhh5V+8FKs2jW/Z
 WzbOPmZatbzrA4/Msl/Jpsm9RdIOgr3fyrGHVPyRVTBoKK3g/QGi103aqZF8Yd5taiJ469FJlNV
 DvVjBQPb43q4KEGwG4/UBYMmnmj9cJ7qGkE2oK6cE2QtwLaOjw4XOmSw6sIAiZaliig7WdiXRFr
 ek5AllnlFH7M+mD4naNe45WCx9CfNS1dLw5ma7to5V+PshGk0CVp239RO28hVsaqLJMyzBCYU/9
 9WcvlZ1DFl9AjFHsBJexpyhL7V12EhYi+NDL0cpH7T9PSTrw4qjHwyHNyCmfI1ziHPIxu6aSuZG
 th2Rx3TQEv3FBYTeZiJVBqyXQX9QkPV9MEshGki8OAqXRr+5KSKc2evtrBg9caZvyk/q9p5TuCx
 7J1C15awBoHhICU07xV70r9hs37GYE2pbDQM6KZ74KAgtfV6RhShhjAvXo80HXcQiSHpybRRxQz
 exiCfDqO/+9ZmeA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D56011A0011
X-Stat-Signature: ewhj53gjz4nkqbzpop4zci9yb5rgps5o
X-Rspam-User: 
X-HE-Tag: 1772483144-660956
X-HE-Meta: U2FsdGVkX1+O1FkDf31bR7P1z5zpbksDRzbTQhFPbNJHkZZ/W3+VZpVHKRenDgv416FvLqcMLk3u99DZDBhVisrPLCpcOPwA54qhGYTLIN6I8f1mdDX4hU3ajTtr1kjVSxJOK+kbR/M4S+rBYFYnQG9b6s131c9AmluJK/TvZ1yGaohmtTCCoRbhKbwY5m6/WFAGBLwSV40qsTHBih5GSyY8SZaMhoHhjO+GtZ6+Ha0Ar7ihEarEld/YlO8MUn2P/Zj8zJN0gyP9pbIoAMG5UfeD+wNmDlTWmS6EsjzANgPIkN0ETpqSVmZBBR6P1zUn9OC1lAZUViQ6vFwfrB2+DRy1LIohHbKcos6n85nYvrQW0zn9RbiyNK1Pwx4H4t+TJVx1ql0fFK88sqxIYMorKKZto8clZhE9AVjpvZLfVuAfEV3/V9uaDyvCS2qB+srhRmpjWBpmLWFDf0bJ32tXsw3i1RDKkXj1wL2A7L/vB8Hjc144ztLaNZBAtxgCjErKY5gGkcKRHox46VOQ8nDrqTkDD8vkcerbklpp/hih9E18AJdU1MNEUfKJoR3UJcjk40+ym10H18ULFLK+0Mm9JQhJ/SJ0Zh8sKXTLAyfbXCwUgaltRWi6CoNNDwpd9zhroupzEQ6xP6EEDXg1Kd/QmpUHvs9dYeZLNkJ1y0SQ+J1oPZmgkyrGuXzyS9xrZomnfCZRhPHax63b1aayI5XJUKovdMpDZdu6md2ZRNKPIhMURHIonaoCBHt2bQF9cOh2hH/x75X1m6BEED0w8MfDWLWkJVqQrJu9IygSDFu9Hy/ydsrScMEIhj62SBJ5SmQJEoPfM2MnSvLZzq+/ESsn6BGhrr2Rh3vj3PKe1VDEKVLJPRew16FHZPW05ZLpOd3xu1Yq+p2C/RE0aj0Q6SS4rTEx/wOJdid65BW8r9XNlhwtNW4kGOgLKoD1c2bqjZCmgbUHPbexUbUOwByVWnk
 TEFJWsQK
 nb83TsAJylY+26YZS+nKYTcqWTNgGSsvVTFSfa9VGiNPZrih+Sa5quVY1ON+cT9U8mTWfqQz9a3VmUXgy1HTQtMgpZivApvF36dE36cN1V09T59oqVcoXr5ZVW72q5f7cIICdQ0YydxXgloyRLsEKZQ/izE0UPnd3Bwa7vJnelWxHpQqB9rrH/sV19UKTT4Il9uKr6mwjaEN9PUPq1BPbdVh05H//5vjA3O3bgBpqfVzthIAP3HfukO07iemD/jnWWHMQFcu8DxJZVIXQK1x6EbIeD8G/nFeneUViTOtN6kI8VK9BydYy4cDRkoetC8fwhINvtSHTJlD9/imUMpwhsCS7opkyDPD9AayhVU5IV/k3+ipx1LzT26nlrQj8Iav/7BWbJhNLnHt/m03EH89IaPwTnJm2bvwwiYExJmfDODkB5A69WpPQexPDnnIxqmOg650E2ZtWnaZfTPGZIgAHKa22RDeNa6C2DhZ/T2CiwDvNltHcL03FL1NuwQYayMktSR04C7cBoYPUduZ6DkiKtElv0PTs3sPv5z1DC1inzfHUJCsRLUhMTtthNm71zQDj9U/vDbgzXjkW7Nc8AZZ9qQisG0tpWns3zIqN1Q+Zpn59ucMe3Yu78ZN/iXWYikP+oPhFPL4VDazTzpH/i1Oh0WuvAz8DIQia6uAAMWA2+8afnCYNtsxwWUlqFrA7F0qbkXrts1b9W73+8uDCWrEkBwf0bU2a8Ic6oNJ99uO4du6RqGOtkIaMhrGQxdyFeL90nuQgUaLzU3FmS7f2hjNww5cRgU48I9saCYFS/wT+c98NK8FsKezO9SEyAKp6y1wVUsniKBDI91j9vcMgYq+lgGLtQJxkOYNoCp8J1M2Dj0cidy3sNHrS4W33S8PXBHJ/Ls7KgEm56diJ67FAW8NLDHza9vHbyD+skQTUmJBb0vh5P8nCKdjkkK1ywMxZkUKkH7j9wVEpTEysI2cdkJsDnnmM3Atm
 BXGUWfIv
 n+tcdUG60bJqqVRdnVKk3+MEf+MOkWoy1kQYrQeNwxHDsVK9ppjF4pkSE6uOcpZOAt8KGlNSS2NKgKAk8qhacewM5kxfSGoZmkGOHbkdH65OaTThSBNP0yLkbr5tVk67+Q5FNV3svycfiB3NU9o5lvOObopFLx0L7UuJ5b+7eUYbnpLojXAG74FjuSFMv/gD/pmyHbTt+61aWHjc0aeuZR+uxfnsIPrCSOJmuwt/YAEB6YVcqcND1zzDWyvHzL7y+kt1ktEOSrAVrcCMNF/As74WJPHTi5pmFVRDRtQGMA1+eR03jdKekneFLsUrRN4k7YOBbtcZopPaKY/PY2xGJqfNBRNGzx8y1BquS+v7s1n8s5BgB9u2CEOvDxqpIIa0AsOhJObRxKDpKdxDoTQRw/fQB7lW0Av1gSDHmxJS6gu88wOyNOjvy6neDTI+K7kmCprJmh3uWTQ4qowPio6OBOG6gkKue7H0XBMU6TmSap6rn6CiqZSILBHeKYkVLE/8WH/xba3MNnIvOioGp0ubcAkw/wg8nMbbbNtZNjGqwb3PQPNVe5g6yw8ZvlRzMhnRY+xu1PoB5DwuJj9HhmXPdkjc9+W3TVS/AK5r44S0L484mK9bvU9AErL1VRL2yuQCa0VOaF5iYxFYrx+YN7hahO4ZbNKBjm4nr/+vOc0h5n4u3fxXAVURjH30aHVplJ4cFpgX2msKqwjAh0PbvP2PHgJzoPY70sWOGNTBRDr6JQrhe9Kaf3gkrSRc1xdHvVw3ifqFYCK3pr7DzdND7urWfOJNo5PdVCiQaAP2S2oNpCsJGDjY2jiYJ+xOf8rFhKkGVS9vaI0k9fureJV4AuUldGu/ii95RNdAHdIVeBH+ZqgimTZxWO7xkU9V/NFD+3BbZfIubyoHSP7RDQ697eUXakuo0vla+s2v2PYTejjbwj4z5/kWccIbj7KkHSc7YcScS5qgFeS+MIJmXmJpz4vWRfTQiEiU9
 BrerAoee
 NgkSzfdtbxSqC92gBKKhFUXe9MqKhfY9KmCkUTmjidc5Htwz2rltv4mGyPiIIU2TaNT54GKVP+WxF86IdeN19yN3V+xwIKZcR8Zuq1dUMZQmaQ6tKO7F2ZufMm2BtaVM0rrvdZK7juSytj8htie8j/leptwvrrtoAUGH131SrKNInlOlMo/IgQRSdIxxGop/LTrP6oq6bbhx+0Ap9taNsIK4YGU54Bh0ojkE7N3WXSFRmyjHM0yv2GjfA53XESJUeh5EtKYi8Vt0mR4LYR/HVBOcDXez9euCc0J0ZGaxuway2pUJbk3w9lDd1N4c2qRjDFXptjmpQB+UvtI06i+DEbnHsa6Ytb/geqMzR/ieg3IFYATLU5xiWtiXX1ClQ6/ssJhK9rnCkCbkopU1FAvRh2MrEKPeQwggEdE0MUw+wygamcnTgvPa1N3bOgjAkr1kEV4CF5VEjotXSvXb6ec1Y7BOn4Je7o2VmYqeENmK8bOCG3HEuUWhI0YAxBLgkuOnGeY4HToudOSdLhP+2qnluVTxcO5lvZQNFcArk8omXTMn3OB5/00iuVIiY2oYTWru8XXjQjtc/WwddGiAOVCVT+dr4rE585tkF1FXGWAZ+6oZgfhUYvUO8cUM2RmIWiYoDiCP+J3PdOp88Q0o8LoCmAXsZb/QcYNM5hQmHh9ab6yCWyuGxEXYJE7hphcHZ/Ug0MSJs1XqfRpUJBPYM6Ym2czmVp/DKdqbVP+P6CSaoOe2wprhCFHmGU8NeA0pJ1c6ZpP2kAJ6/bshPfd4grpOONzexqm/Ir+mzEhMGaIguMg5theB7uV8gYcb0bnwXxGIohQ3bzZK4M6yD79IAHFul8Ou87frh1lQzMNrFarg6eOUTOVOj+aU/vidltKJvdOwWWKMVZPx0GuTdAN4g1+rSw3DISKa1pmZtM3N1VJZlJXz5oQSqvmbEn9OCJf9lMQaRWSxicuds8yRjbm6Z5LHJ6nHff5Uc
 4LYHkDRk
 BrQHCJpxny8iBFft0ES+RlRvHW2A9P7hMkNyqX6ju38+MQbXj99HtQ/Qgj7bq2a1Gn3gSH2FltRatOwVFAgsX8A/p25b4kwDezQ3bK/A26WN2WNJlh1OkavSShl6abaraDkjXRVirPjmoNpHB1WjdJ+wokW6AS5dhrCNa9BjlFsvbIAocZvbGdqf4IvXLoyJXbuqBZ4lCcYDjmQPWMnSzBaBrvtrcrkDNCtKoWAyI4lrXJf40t7L0hfY3XKhaSrjZDeTqY2nnrshFw45zX58NlQmoIMx1Gdj7laC3vC0TtBWH1O7IQLO5mq5nSUER/Q/CuPuX7bAsY3WFf1bYvNxkcEaWf1+hGT40=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

inode->i_ino is being widened from unsigned long to u64. The audit
subsystem uses unsigned long ino in struct fields, function parameters,
and local variables that store inode numbers from arbitrary filesystems.
On 32-bit platforms this truncates inode numbers that exceed 32 bits,
which will cause incorrect audit log entries and broken watch/mark
comparisons.

Widen all audit ino fields, parameters, and locals to u64, and update
the inode format string from %lu to %llu to match.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/audit.h   | 2 +-
 kernel/audit.h          | 9 ++++-----
 kernel/audit_fsnotify.c | 4 ++--
 kernel/audit_watch.c    | 8 ++++----
 kernel/auditsc.c        | 2 +-
 5 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index b642b5faca654c8465b6839c32b633426e1d3d9a..b915aaa7ed7399a6e453b1bb9bacbda686028638 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -15,7 +15,7 @@
 #include <uapi/linux/audit.h>
 #include <uapi/linux/fanotify.h>
 
-#define AUDIT_INO_UNSET ((unsigned long)-1)
+#define AUDIT_INO_UNSET ((u64)-1)
 #define AUDIT_DEV_UNSET ((dev_t)-1)
 
 struct audit_sig_info {
diff --git a/kernel/audit.h b/kernel/audit.h
index 7c401729e21bbcb062e2d5f3059d4496ed83529b..a41b5a727eda66ef8b211b9598e86f945c6c1235 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -76,7 +76,7 @@ struct audit_names {
 	int			name_len;	/* number of chars to log */
 	bool			hidden;		/* don't log this record */
 
-	unsigned long		ino;
+	u64			ino;
 	dev_t			dev;
 	umode_t			mode;
 	kuid_t			uid;
@@ -277,16 +277,15 @@ extern int audit_to_watch(struct audit_krule *krule, char *path, int len,
 extern int audit_add_watch(struct audit_krule *krule, struct list_head **list);
 extern void audit_remove_watch_rule(struct audit_krule *krule);
 extern char *audit_watch_path(struct audit_watch *watch);
-extern int audit_watch_compare(struct audit_watch *watch, unsigned long ino,
-			       dev_t dev);
+extern int audit_watch_compare(struct audit_watch *watch, u64 ino, dev_t dev);
 
 extern struct audit_fsnotify_mark *audit_alloc_mark(struct audit_krule *krule,
 						    char *pathname, int len);
 extern char *audit_mark_path(struct audit_fsnotify_mark *mark);
 extern void audit_remove_mark(struct audit_fsnotify_mark *audit_mark);
 extern void audit_remove_mark_rule(struct audit_krule *krule);
-extern int audit_mark_compare(struct audit_fsnotify_mark *mark,
-			      unsigned long ino, dev_t dev);
+extern int audit_mark_compare(struct audit_fsnotify_mark *mark, u64 ino,
+			      dev_t dev);
 extern int audit_dupe_exe(struct audit_krule *new, struct audit_krule *old);
 extern int audit_exe_compare(struct task_struct *tsk,
 			     struct audit_fsnotify_mark *mark);
diff --git a/kernel/audit_fsnotify.c b/kernel/audit_fsnotify.c
index a4401f6510608119fd928944c36103326475e3b2..711454f9f7242847f78e7eeed92db7a66be265e6 100644
--- a/kernel/audit_fsnotify.c
+++ b/kernel/audit_fsnotify.c
@@ -25,7 +25,7 @@
  */
 struct audit_fsnotify_mark {
 	dev_t dev;		/* associated superblock device */
-	unsigned long ino;	/* associated inode number */
+	u64 ino;		/* associated inode number */
 	char *path;		/* insertion path */
 	struct fsnotify_mark mark; /* fsnotify mark on the inode */
 	struct audit_krule *rule;
@@ -57,7 +57,7 @@ char *audit_mark_path(struct audit_fsnotify_mark *mark)
 	return mark->path;
 }
 
-int audit_mark_compare(struct audit_fsnotify_mark *mark, unsigned long ino, dev_t dev)
+int audit_mark_compare(struct audit_fsnotify_mark *mark, u64 ino, dev_t dev)
 {
 	if (mark->ino == AUDIT_INO_UNSET)
 		return 0;
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index 096faac2435ce2b3741fb1f623ea7fab65ae7a07..b0694fcfd4080d6be587ae20d9c91450c33480b1 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -37,7 +37,7 @@ struct audit_watch {
 	refcount_t		count;	/* reference count */
 	dev_t			dev;	/* associated superblock device */
 	char			*path;	/* insertion path */
-	unsigned long		ino;	/* associated inode number */
+	u64			ino;	/* associated inode number */
 	struct audit_parent	*parent; /* associated parent */
 	struct list_head	wlist;	/* entry in parent->watches list */
 	struct list_head	rules;	/* anchor for krule->rlist */
@@ -125,7 +125,7 @@ char *audit_watch_path(struct audit_watch *watch)
 	return watch->path;
 }
 
-int audit_watch_compare(struct audit_watch *watch, unsigned long ino, dev_t dev)
+int audit_watch_compare(struct audit_watch *watch, u64 ino, dev_t dev)
 {
 	return (watch->ino != AUDIT_INO_UNSET) &&
 		(watch->ino == ino) &&
@@ -244,7 +244,7 @@ static void audit_watch_log_rule_change(struct audit_krule *r, struct audit_watc
 /* Update inode info in audit rules based on filesystem event. */
 static void audit_update_watch(struct audit_parent *parent,
 			       const struct qstr *dname, dev_t dev,
-			       unsigned long ino, unsigned invalidating)
+			       u64 ino, unsigned invalidating)
 {
 	struct audit_watch *owatch, *nwatch, *nextw;
 	struct audit_krule *r, *nextr;
@@ -527,7 +527,7 @@ int audit_dupe_exe(struct audit_krule *new, struct audit_krule *old)
 int audit_exe_compare(struct task_struct *tsk, struct audit_fsnotify_mark *mark)
 {
 	struct file *exe_file;
-	unsigned long ino;
+	u64 ino;
 	dev_t dev;
 
 	/* only do exe filtering if we are recording @current events/records */
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index f6af6a8f68c4f6d14d9a899934138df2036e1f9a..61e4ca47b15e57e33b61c1465eb1988eb4271c3d 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1534,7 +1534,7 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 		audit_log_format(ab, " name=(null)");
 
 	if (n->ino != AUDIT_INO_UNSET)
-		audit_log_format(ab, " inode=%lu dev=%02x:%02x mode=%#ho ouid=%u ogid=%u rdev=%02x:%02x",
+		audit_log_format(ab, " inode=%llu dev=%02x:%02x mode=%#ho ouid=%u ogid=%u rdev=%02x:%02x",
 				 n->ino,
 				 MAJOR(n->dev),
 				 MINOR(n->dev),

-- 
2.53.0


