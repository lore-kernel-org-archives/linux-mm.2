Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCD3AEB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D5566B00E9; Mon,  2 Mar 2026 15:36:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 288C76B00EB; Mon,  2 Mar 2026 15:36:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 174896B00EC; Mon,  2 Mar 2026 15:36:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 049CA6B00E9
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:36:34 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE5F38B302
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:36:33 +0000 (UTC)
X-FDA: 84502281066.14.1BE6F16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id DD4E62000E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:36:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VcuXMaHs;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VS6mIOSRO6GQfrj2kmwMhYVurJXG+ztpz3o80Q0mzBw=;
	b=b7f5cQClXSCsxO0pJrufqcqFRmmWEtkvuXTqPlwPYmum4wuUevRaJsx70M0diJmp0hRv79
	tOtU40zoAl2rPd+QHHx6WNJNe+7hFoWHy6STvd4LB3eksCfzYGrhKmwAFNvaDxhlJ5n68C
	4u5bQKZH9vM/KJzJnGs2KpHbjCQOC7I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VcuXMaHs;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483791; a=rsa-sha256;
	cv=none;
	b=KKRquey/LJhH1y/aHH5atso6jcf2RLNZOxIU6SH+qKBegBE3XJ28rYcUWiy+dVYa35gHPI
	GdOCl5gInsvNU2rKhvrNI7LiKeJ306wm7AdnYTGP4Np4Krm32ErKYWLjlZacdWZ+q+fsZ0
	eV13OLqIRDuwyXqqCUJRtl52yLsUxr0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 261C660131;
	Mon,  2 Mar 2026 20:36:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5FFC2BCB6;
	Mon,  2 Mar 2026 20:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483790;
	bh=00hKJMzy7sYsJ1YOgVeBFYPPejllxH5501TXoBKb/EY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=VcuXMaHsGS9MQntJPTqxheMObwYrAi/GVvR0kw0bb/rCsvu6SF2MbdYULNGyOBpy0
	 6PYiBA7Dxg1U36OO3QSjQbye493vKTwjlHgigKka0weIHZRFsC5dBQQVb4KM4jNnTP
	 Pav6Zd+50z8Wy81wYbGnFQSJNfMMYefXd5K3Y2hJvCosc5/LyepzEoP3RuEM6eBi6/
	 RVB8ocbSiI7qaCAoslikDQAyfQx82c55I7UGP/CecGpw2C/OoQEcE9IUBU1Tw4YGhR
	 zr5cyanaLugirG6BskpQueqyx7DUZ4Hn/I0dTXFqczVeJNr2n9fmjZiyjUltmDi7jQ
	 2ZVLl8YTyQx1A==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:32 -0500
Subject: [PATCH v2 048/110] zonefs: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-48-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2120; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=00hKJMzy7sYsJ1YOgVeBFYPPejllxH5501TXoBKb/EY=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH7iSn+nuF18SKJ09GIwF9lGV/gMpEGjStoo
 kWpC+VrAweJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx+wAKCRAADmhBGVaC
 FQKfEACjSsXZzurjjILEHuG/C9EMcKoheBtyMn3dLskrkohM0UNiLSxTRscuhVF0milzCYzi70q
 +XcKZGuXxwxDywRGEG3XvlOT2IsU41kuLrxC+nR03F0Ytrcd2bu31e0LxBkhPB/NPEt9Wh0B8N0
 qKlYEozS78Q68F2dzE7iptWmo9nLasG1tqcOBRF2iSojpqAP29araSZ+MdLz8+8srEDm6ctBh7i
 1O311qKQ273EFMyFJJnwdK5KHlAWrWgHSaZHqrz3euJY/L9H9gI7RIp+LdYbZYdbFusMczmSNkR
 H43zejV4Nit3o12JjHngeAokR6DaZE+z80+H08g3ywlkAvc6utfnWgAMAVI+Xt9r/XUMMHqoSW2
 coXN7a3OximEiDRt/X14GZWsoAXwxmKd5jlJR3KIbgjKxUmEM6l3BsLb7HJrEdzLWoPZbTXYdjo
 rYerC6H+lK3as4r/S/tOwQAh0+WYr1RZPijWhJ8eeDY/8RHMA8Jlzyv+1Ux9IxcAss3fBjOHZsF
 Tyfnnelnlrhd/WQ4XtwG2BlvCN8OJEVrimfkMKt9JvKNZpgyQlVDssyNFHdLA0Q5IfqgLyPVJyR
 a2G5c1d2iEMjyjKYQZZVDvbBGob4mbC6yHIPRuyzWt0MG/i/bqAJfKUHFkPiFvD87vCSurytSc8
 xs7jIbOmcaHiuhQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: DD4E62000E
X-Rspamd-Server: rspam07
X-Stat-Signature: oyzduy7ezc1hk85urmmcx5tpswt5xckb
X-Rspam-User: 
X-HE-Tag: 1772483791-861818
X-HE-Meta: U2FsdGVkX1/d9j3Pgl8KfbyDjRk/Vw/ijNXsjM3ECzVCzYJBts/SrTjnlC0Jyj0aqm62tSicgAIPtvLvYG1pQTtqXzCBaDc1FdVIDcBCGvsEJ2vsaEENuhnWhbpaGPtCBuCdkaUx+jJaHytPDh8y+3Kj/vP5xwKI+gPtTobePNVW64IqdtI8d7jnnjn6q3hH/jnlbRT1fwjE+SDu4vSIdS9mjwfPfNnX2E2uS8xkEfFS3hhw4l1YH+uu0dr2vzsTD1Oh1wjkoTs46QfuEz6h4nl/ZQD8IkFNfpzx+6o0+Gk4FWo9jDJcHoRh6nfci908Uy8UBiyM4XhvBXrIURNJPZ44snyVPcq2PltsIATNho59LRcanoBn3DPPqgeCYLmvKOjK4wm//pqpWsUx4x4oG/SzyKE5UGb6LNQrH3VDHFMj6LJm0oy+a0wRaxWnQwZYa+6AsdnST5/ZCpKwBExjcVynJrxt0f6dk2AhYjyIbB9f6jUSKdRG3LVH3GVAn6/FNy8t65oOB2UTu6MWP4flm0peCUddJglXEl0+BcKCHxiuusWXsu5kLMmWiRYwd6KMmEKtuQRppKQM20tOgnB+Pwbl6o9bCPfw3pXZnncU1LoKEFdvBFsuWQHXa9EI2m6woI9g3LawM9ykIUeDqN0coxphCtumI91kDiBAO0+UHAURUF+h7ika/AgR69o50/gnuIMsE66QZiHBZow6Fj5dr8Ij4e2vkf+VhIi2SAnghYSjKNf/O9YhyuG5bgMesAW5PKDzQcUG/V/r9QsSG5Ph/YMl99S3JqWl9u8ZHzjW2nzr1nIX3ybfbK9xJ1z5u8bSgRhiSmFhwjNsdbVXy3jbqjbZih9f2QQK6pUTlvMXJ5PjqVIxxOVCMHdR8MuzAtHlzN6sjCTMmH0Uo0wzv8X7wGuULT8G+y5A/loRDTn8nxrfVJTFIuWlcte9+Y2NBlyFsOxj6VPcJ21vgW77sKn
 krtu7peH
 1ONLCcgEGbI3QWqte+5ye6Fnw5CupU0ovZe3Vdxl0vAvvKncM5kEn+6FUA72pHgswxjsjc7xvPqJxfgretOiGjMfz4VoZJoveh4JHTVUTtayCpHTZbYmRRtngCZhhp1xKPFb9YVdN7Yvh0vJDnmsNvZt3cg3yXSJZdzF+U92aOvwRLusaztIdJmCjpxEo3n7jPzkn3cdxbK+ruPJJwcN/U9vhjNkqVbVw8shsllws9Ecf+h6X+pPPpA15j0NAANxZ9apMX2mHNhPHa9gY42qhG04r/9qUpZe02ekjDASUOB5v1oVCckkluwPZJvK0DelobDqleRupluoW9o/9G003Dnm5ryAB0vPjqLkeMIqJYpYg0LVdgYfb62sJ0Ji5JEcWnyaHI4/OQcCoqYACNVvqFtylLPCYRBuiL9xFu4HJGdt4eK9CQmN6Nf4IVOgVd7U91Kc86HjYz9XZGFE7J9DWWgw/zWyOghxcm0h8NmgOQGQa3fiQ+cRYNPNCaxjNUHqE1gg1FT4LIBp/1gPFqlLmZAbzVQl8FiiIPoZmhS/Qb/dFFH2xg1q1EKLoH0zoSaFB8QQz70FABHwCFWaMEsECoRKPFT659ySKWi5Ek+T8u/3w/CVT2tBZCTf8jFQS/nq1SA58edQMl6FsiYyV067yEFr6nDprn6d+mveA1lh0yCWhPTF0JWSOHVpJi8+F6IRfOor9Gw03im1KcGbJ4k6vaXku7vvI1+fL/3gK9Ofdr0O8/YTR1VlUVZfr8vIsqrfWuizi/TTSWgtm/OXDXgskjaykSRjEj3mgh29vmJ235PqEwfnnoci3IlXsxf0q7mCiuhipYaicBbQd67i4s6d0NxgBqJj5WwmTJda092BQNqTsZmDqB5qmWWIaBZPHnDLo66bLMigoMW4ckD47yHBPxrx5JCAg9wbqOH+oAYCH5vBHjmUSDlRa+D0pe2vaCqYqfu7fq/Afnx6EUrtigPQ8UqSdMQgp
 676T8hUt
 pSkQFcYFssom3kBIh3EbFuvZ5diiKxyricB98muFbtAr8QUjicGPkpRYCYAAajCQPAC+/wKJAjsgtxK/jBsbxKi8dMdYH5v4DyQ0DKwk7s8Y593x+xNByQAoWCaTlvLIYFmNKWXsekict2xUUQyAGFMP0f3uL0phSaWpSFTGQsOesSIy1Dok3VlB76fwTUb3IkzkgUmX2ESji6rsUDpvMVvEblTWChaFEmjjD7VnoPN/UI5/VFpwqLquNeS7bCRDOk92v938MyvGI5VcOCHcfElblqKEuqkE6MgmbhY5n4SMVRRYCeKlbHS8CCAtuu+17OTPnpVdmHIqBBMcKjxWZP6ReWbpWai8z4iCdDv7T6+73I1Y0+qCOzj3DyK8YfcKwfj6/7cP/YsBZmiYlzIGWB7Hx1cnq8OUSMOpNItyUoxr+LsTvUHOZxk9pgHD4kyc2lK70D4tgFJhgl60v3a40x+Cvb/zgVWBYZDvHMhR5SsaCUuIvPQsJDyaR+ZBv/s6TAdiDTRwntqFzAqv4z5AmyLom252aKR7nNjOYZbWlVgxxauqd+MPjj9eRRfFX+37LB2mlTkdwYcQQabnidW953GajSezWjwY/0biKXR2R9SoLDTYKicIsxOw+eLsNkAO5SmLnz2yDtU72dCJg9OYwsTTGKTcebxmptplwuY0G1zjaPK8FQDmYiscebuxg7YT2nASE+4aq145MWQO2VeDcwoKIU3JokUCEx7HIUGJwUeEJP5h4XwOeJD2rrbAidBsiHKETGwAHvfMFeLJ8IRhDACmSm8B8uXHwBS9B0QdinHqto0Lud1UKunfFll8LKOznJFfEcBLjqRCJg/vubRZfA9njGezil2qmUpTs5qkCv37wOWm7YexwJV4uJf147wg6g717jUopRyl1L06CwyccgtwgiCCAHBhzialec5oKJ4OfWFZcaE54uaX3hs/Sk80ijBPLfW6E3sV2JXXSR4KLMUT/KTVN
 vTH/clI8
 h7bPG1OqW+BOYmH0Glo8y8fnQjUUjURrAX8lQ97l1OcWHskVrQf6PBGfIap3rg7q8zKUBsMzPrEkiA+SESdqLAILl/q5EE9WZc571Gql+tSGhIc4gaoKO7QyiNMkFHxEUfiELMGcFRvFSXaE8y9bUoCnRLYKYqTogfiQV+zABOa15WyAgbYw7m/NoDNeGHRZ2U/N7KpXuSgmLUYikZ5I1+TQGh5p836gfQKjH2hZeLzqWr6GVTf9tN8w7v096OAnh2ITxucjBHz+/DJKBhGG+Uf44lFnvRtbyg3k/PRr2xE7jA0USWAXZ5nXiYoXs5/DfhlPg3fAAZrtgDnvRKzJY97d8SYhfXiE/qKH8SMQLY1+Aw8pjVBGNBsWoT9xDmQC8JrJ9hCCWVntB1sQDj/zyS8lAlloGL1ZEuNjCle3UFHBMQTXjB/vqz4XwMkx2R1wB2Ebs4wISA2Ri+aawMthFJTgDcLu7Z9Udrj14mqAgw830uEp2S3crASOMGRvHKXZXAMN1yHIHnJp9wxEk7HlwgZ8yu+viMo8s/ysQyk+tGBK4J4/sZc8CVcPLww20/+Bget53pncu7bhF5klixxk4sFu2yUwoplEIgJ0JyXjErk1TnFkr9s0nEg1Xxl13Jijx5rcVIJGCgaMfhDIKe2BiZFNjs0RkK7DagSbfiYqqcqcIfcv3NKtKeE0SNEQ3An1M7a9OSMVGmSMNUS/cRPuko7HGHKH9tmXU1IJRwOa9pwXFEA/ZP8IXuEHdw/iO/GHWKnhIOY5xru4s5V+rCxpO4IOm31zKldyiWMO7++Ql+vzyuBWdWbnY/U7X7hbcPIWyoG1rGZtXLcLfseJGPzY6CLGPGzduwuxLhHI/CpmcFZsi3dvYAoswaLu/GpMz5cglFP+cXFB1Chown2dPrQQxSi/AKS4N/J7z0umeJhyDUFoXZiDdgZH5fNwpPhrS1J6XCmf5KdgUNnaJdZvxz/gY1uK04jVs
 yKU92Ung
 KUl6COA92BpgoRfqBvq2JiQ3gU8jlYrsYtITKjzd1f99GwmchYt8BmAXwZojsChpOLyVTWOgePBF8PZ2RCexxGqwBJ2gnCVbtGAADQxQSRBfqgG/iHiL1dyB3o/PY9Cc6D+I1n3RVwa9ZBz8aEg0AqrjB6W3kYfO7jUhvDGHh6CG8ugpmmaJw/AyWrVfpXqu5Ywrd63S3wVa3LyXxJPjHDcfD2Ajg1UM0o2dFjk8fkCJf7oEuc9/Zf/ORolSvXefNjw84GCWJgvgTBhmGrAZqdFzdKhdXPsjik7iEA1Cy+v5dB7OHUAxKaDWoUEVdUEZ0YsXGLhOEukawLuwFPdgVM+J3m53jT6o1jWvG1zXv0haUsdvurl0Nh9cb+vl/7u7MPiy1PjGiOrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert zonefs i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/zonefs/super.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index e83b2ec5e49f81674bfbb5e1fd2c65add32cda1c..cf084c7905d4d43c0638187a55f3c9af71364f3d 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -297,7 +297,7 @@ static void zonefs_handle_io_error(struct inode *inode, struct blk_zone *zone,
 	 */
 	if (isize != data_size)
 		zonefs_warn(sb,
-			    "inode %lu: invalid size %lld (should be %lld)\n",
+			    "inode %" PRIino "u: invalid size %lld (should be %lld)\n",
 			    inode->i_ino, isize, data_size);
 
 	/*
@@ -308,7 +308,7 @@ static void zonefs_handle_io_error(struct inode *inode, struct blk_zone *zone,
 	 */
 	if ((z->z_flags & ZONEFS_ZONE_OFFLINE) ||
 	    (sbi->s_mount_opts & ZONEFS_MNTOPT_ERRORS_ZOL)) {
-		zonefs_warn(sb, "inode %lu: read/write access disabled\n",
+		zonefs_warn(sb, "inode %" PRIino "u: read/write access disabled\n",
 			    inode->i_ino);
 		if (!(z->z_flags & ZONEFS_ZONE_OFFLINE))
 			z->z_flags |= ZONEFS_ZONE_OFFLINE;
@@ -316,7 +316,7 @@ static void zonefs_handle_io_error(struct inode *inode, struct blk_zone *zone,
 		data_size = 0;
 	} else if ((z->z_flags & ZONEFS_ZONE_READONLY) ||
 		   (sbi->s_mount_opts & ZONEFS_MNTOPT_ERRORS_ZRO)) {
-		zonefs_warn(sb, "inode %lu: write access disabled\n",
+		zonefs_warn(sb, "inode %" PRIino "u: write access disabled\n",
 			    inode->i_ino);
 		if (!(z->z_flags & ZONEFS_ZONE_READONLY))
 			z->z_flags |= ZONEFS_ZONE_READONLY;
@@ -402,7 +402,7 @@ void __zonefs_io_error(struct inode *inode, bool write)
 	memalloc_noio_restore(noio_flag);
 
 	if (ret != 1) {
-		zonefs_err(sb, "Get inode %lu zone information failed %d\n",
+		zonefs_err(sb, "Get inode %" PRIino "u zone information failed %d\n",
 			   inode->i_ino, ret);
 		zonefs_warn(sb, "remounting filesystem read-only\n");
 		sb->s_flags |= SB_RDONLY;

-- 
2.53.0


