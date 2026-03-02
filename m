Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61023EB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6CBE6B00E3; Mon,  2 Mar 2026 15:38:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C21416B00E6; Mon,  2 Mar 2026 15:38:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF8E46B00F7; Mon,  2 Mar 2026 15:38:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A00676B00E3
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:38:28 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 75F1B13A3E4
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:38:28 +0000 (UTC)
X-FDA: 84502285896.03.082BCD1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id B29C7180010
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:38:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XuSlDM4w;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UuAjQHMAxG26mxwb+YjHseWRgBRFhd1Vm6MgjZ7O0KA=;
	b=HwRVeZaKRHVIh8gzNSRusY5YHMg3Q4WUBzMt84fvZ+Vaa/7LGJBiU2SL83PGGObaRDt7ds
	H4OhZRxNkoc4FHR115nLncy97vsJ8IEFSnOfXHB0T8Z8Q5qhy/VUu+JdNX1axPgW1GCVmn
	Y3KHHroLd/dTJTuwHFGTzkuOmMy2Jgs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XuSlDM4w;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483906; a=rsa-sha256;
	cv=none;
	b=g8A5CjGb9cx3YrmW3oU1fxPtlSllnn/1+ml4qU08YyTFyUabg3B7UwRkN4BTFPG9sJEmgZ
	A5eCc1TZo72FEE+GNOB3JYUesd9Tk+cofT+sp5j3cV/SAk6/HajbUQJFLR9O5SPV2ExL2v
	lkZE5DdDMHm57C0Pwliy3aNBIuAlR90=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D4466013F;
	Mon,  2 Mar 2026 20:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA41C19423;
	Mon,  2 Mar 2026 20:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483905;
	bh=KNPTuBj6JODO+UF3sDdvTtrB3bvqvQCLfGB8wqrZcAY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=XuSlDM4wnU6cCPWdfuQZzSfcOelvABCzcEfM4ltWJtLByYlM/VIi3u3EaI5qzsKOT
	 4jrMfpB6c0ng91tIt3cPdC3iLZ53e873UGXYhat7jDAN6GLHavNRzlaqJF1gwzm2GN
	 FQ/YiWekPqxQZX+yPaaOtbjUSrFW8AH1xpabdAVbKUOUV6DDviSjRujv26q9zV1Cn8
	 dCr23XYgJQi1XIIqArL6faVhwzfAPni67NNWXsiTcqAUbx3Xit7MK+wf6cA4nUNumh
	 tJC70xaUqYDALBwWMnqCM3orLjKibsBBhPMYvB0vueqT1AwvT3vnLlzLK/yMc6eR9A
	 vWejBDQ5F32AA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:40 -0500
Subject: [PATCH v2 056/110] fsverity: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-56-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=820; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=KNPTuBj6JODO+UF3sDdvTtrB3bvqvQCLfGB8wqrZcAY=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH+Gi5aMv1hqlu7WIpcniOaGSe4LY3o19SOE
 gzV5OhOq76JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx/gAKCRAADmhBGVaC
 FeKGEADStbHNuE8fe2Clpi4JmXKZc//qA9cmXQXztEHJVGe533GHokIOnjmdvSvJjvyXs+kKuA+
 ZuRJFOK02dmFOOjFCMw7nWz9HzRwL933c+U570XCbYSygaDvQfXThR6hk7tZ00Ay4dkOocJALoB
 c6zWW+OLA9ZeVBEApwnV2taISeIN+eiVINwtrUe1Av5i3Mesi1It/0AUOYqOMaXc+QemaoCJ68G
 kMDfEA58hENR1B/9DArlzNyZ1lWTfAMgv42hqIyZNrCUjS9TQhrEkJTU+LXELV6rB2vSai2Tioj
 ZDp7SR/v2Jyi3NdGWbZQbULd5Hy7j8SkimdodHT0NprVYVG9JuMH5Us5W5DpNvzcOxzYFYeUqTa
 JKvLR3O5IXiIqNRXfGV/MJIAPtewN827vUYcsMM2iZZuionSzwS3TN8pqekevc5E8XkPnp2vMjA
 y31e+0KXzxHoXgXvlXBiEyrdRw7FldZUw0KFabsht7k1pRYM9eLUogbfTJkWJ+wlKGdtpqps19t
 upjs3+aQoNZQu7LmYct2y8b56/1d5nyr6rhXs4fKGHyWlQFi9rGRYaN+SzlFtgYuYkZXIdrJWaJ
 JltXmqf6WJ/xuxd1GCg8/D7IOX8zpb4mpUB37ETNBLGFeA+fXCiV+MlMI+hhqO/aZpLh1T9QqlV
 7mzbtG0PlwC9oEw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B29C7180010
X-Stat-Signature: wgbo38ozz3mwdgx8jgcosmx3rdjm6zdc
X-Rspam-User: 
X-HE-Tag: 1772483906-367011
X-HE-Meta: U2FsdGVkX1995gmza46UIHtlN6QrTydhRdXM6Pnmulxy44dop2N06Bc25dnbiZ+Nb1ev0l7CHdMD7oeoNUpP8albueR1qn0cbZs70H6EWuOYDKp7mp9qE5NCpP7X3balGZnGBJgDz1Yy1HX65IzUKcDHBMGn9MkN+T09a23tTbCxavEpd8B5fw4ylE3iY7CWYsMOoLbLTg4VbtEu1C//0WYTVyCT6hmqeXZgYvrYrCmztz7IwQ0c0ysOrwjZwrJy4UolytNPHaZvZ/15oZ2WcauM8nQ9N4EjPODBLgSujtbwMOd+2xT5BmXlTyceDGKtwle/qGmPHkCHSkM+uygGhTDTSLDNXTRzKgmrl66mH0rNlCNgt1tkZIlBZy42K6tHyz34icaIREDJogRsqvgUzP3NpMxGkqm1/Df/sLo/XA04YyFyOvYtOGGCqZ5L8UrIaF+FAh4l6PLQ3sQUzXiHy9UwcePE3xpVf8S1qa3PVUvZVcY7WPJcQ9G2hv7RbAHELQFKIO+iKn/XfJLYLBRREa/kVJ2omKNDWfnaE5P52f39AZUbIgO+7KABXhMwlq5Yf1+8ZbkFEEqJ1pVjrYoF5D5x+cq31j8k3WuFlbS7nLx0ukFQarZvKJTUl14bLbROipno3ht9XyxOCbdtF7NEX7VwxrjtWrl8rFKKUYWVtV6qS3hfywjqc1pWCzA9zxgxzcdhGVjnf75MiHd0FziPyfHrbKKqNTJBDu8bBDsDGjrsPUhJ+SsE04j3Lcyefv6gEmMnT1Xu97R4LpqnZ/tL9Xjv1ecChbfogyoIk9oJdtx3UgQSYbL1vtfB71DbKLcggnHMbn641l5SafVqoPr4x+ZYGg+tZFZ0klP7uOahHQlriu0b2zyQDpAVmvpUYslHiQz430GLPXjgB7FgHqwGF4uroaMRa3kOEoS/CRSOaaWJYJihTGm95VHpoASfhVPzX+AQDti6vsaqkm1ykuk
 2Aft1mhO
 XPEabgZFqLXX2sefCZ1C35L40Bf8FdX3OnNEa10Nk7vy/rvE3Fo+dCPosi0W7FDkgXWNr+TzSKQU0azmsz3h34j/Z/Emf6QfDZKyXh3mLW9eijhaxmfoQPn1qgyW46CB+WoKQ6QCZrcvO712fVC135owTZ91MAt939igB/RViEYM/ttTUwKwVTIb0AhjIBptfQW5jH3catDZaN6shGWwF8RHNUV8UzEqWPnnMnNbI3D82sB7t1IOrIG/5sHhnrz9ISJgOQaWK8aeIIr3TBpHEu1Atm+mbYXEfnFMrKLehpfOS5OTS5VotYBqZcwEQy56cYFKclyH6+f5sg9mGYokMinVErVcnYmYkqzfe+AL2ToUEQ/r+H345Th64FDqIQElhl0KuwKxOwJIA25nzey7JFYeHv3nh7xpBIV65lzPmtH01ovc5XZ78KJFK76NhgE3VbL1dKdamc+mwVbAgqm9EhuB4oB70Jt1ogEd4wy8Sfmyu2aELFgdJ30n9A0wrYOQGIxwqlHKYZm3z6F2PfQWS5z7SmvZtBB5516v/ERXgZNl+eSQ+0nF1zwBaSzBF4nvvhUDI/LGrKLc6KeELLKwqLRdqumLCqT5JIEyEkyrsSae9blbbRIar1PyKxt0MRB7sAL/jku8TvrnnuuK8qDPjvFrKj0+vi67oKeA7FTdfoi/9OpEC7souK9u709Bgn/rHCVb6BHcuBrqdCOcWLnlyY8rw/o75ZBNouIEjWLwZppudeBq1tiwxmbiZ1GO7yWdEiuWRzvtwW+xz3IJIz3LLSJdYHZOM0Msj9qzV0Ykgsqfvn0QSxsB+sXWf1/LiqT6VX+xljTTmrtKMSTHHW11//r2CLXnJgEe6VVa6vcgXql0EFZS+o7TpePBfywKlhAgi5iG+JJQg+et3G0KEV0oDX43xqN6NrI4r44icJrp5qqlFGUFZ2dnkMPEe+IpX+7DM9wlLacPPQgao7e8ygXsY8Iez4iuM
 uQuP66Vi
 dL54wbl1Gox6O+yOTdIsa74Q+ohKQ2cvR1lAdzcwSai6n/I7byXUppmWjHWscGtLWNeoo8zGXhSkiQehw69zSM28+Hb4/6rn8rhSJ9MJL0pAeBBNYx8Z9EpEF3/EoKjekdj5WBsfTsUAYRBKxRnkffe/Qwf6AQaNHdbQDZNPHfcntmJ/D+gmzB2Iqv9Jo1PVYyynmpLCwyg2ZJDwU/Wa13FIAbEV3KRLGMCripC8O3ELUB0QOzilFKWVWBnIUVmzoRMXzJfERdIg5gTy4dYCHEz0D1DpbJhUckgAtVV1klyIxW7slJMT5eEzwTvXLNBmvUeyG6w5gT/jJ0pdL4V8FjfqklR/TFYJvPgsufyog9IKtWWn4A8M9pMxy8ADJnsHkePcLqqFz/T6wSbgv8mjqWjvmq7oAgehTWmo7ONlB5vdAwspK0Tt6JADlMRcJhZZjacoP6gXMNu6F8b/T3YzeXoDPq5afKbIxlWCJBTxZiQsIhVTxPxDWUvLf44opeROlSvBIskECFPu7YDgisqY6BJ7yPuneRGJ8cPz0EYRiyKYYag7GK5O/au+80+xUTrPY5AXts9yrzhvyZNKPwDaC/W6Gl0XGB1XUxgbncAX7YXnupVxQ017zmBo+G+dRJwWPaOlFwihj0OoPOuohXcatDR0sYyJIYZTlH+VJ3dPcZvRN/5eKLaic4mQmvQqFIIKQ7icNH7o6D6DrXCBENKDh+J2wtPT/XyDyCoQPZeretgjtWCupoeqnxmfhmsDHi+fCIa4IiqnCnP5Q/PQcsBc8MsZTnbWtiUM/AvPiUUz+nCuU6B/4iCWCy0fheDHuIATSzp/9/0/Pc3aFwjRlVAbU8iUwK/pslSVdLYcq02x/3l5rPJxO2SNgtPiR628WiYAAibg3tz8PO2Y/nMiW0qplqMtaZs9y3YB8DeogV0u3Qr5fD/KeqUgu1ik2FfGhhjRodAZU3In4+XRtBwnEARdLEP5uul+7
 dYQWZNCs
 SVo74Ff9XW2ZqbouojBmsYzMMTE20dYngCitU2QOOF3eF6BFhSaXezyZjbRLcmTlU4RV3iD+DpH/L7y4RqDi8jA3nRifB7ezwrL33iPsF654DfP4uYEkpGkWe8M1ftfZEg0Z9VVUVVh0RzcA1c0kc5UWoOj8Tg8gR8pcnSbUbTkT+nhOFMOqnI5Yb4I5+Y/jMErvtOzTlJgxL5tkd10aXAopskUwJ3ANFNfCzG7CrzR678dcLKR6WWd97rAr4XI+Rz14Jy0oHvPo2vLtIznNyVyYKUpmvumqIJ7fpl3l5VWtrq+MCHJKqgs1vw4+9lEc7b9jCZ5xURIh1hFrRUuKC+a0L0vUkLOyI2ryP+E/UyEyKMhVCAJ68t7ELNxh+K9M9J0aYaId9Ox8jmMEcL8WtANPP2i8Wv2OMohawIW21D9EHGHr0CwJyA8aY/67sScaAMjXp/TQ7BYmXZ2sqddZxxlQIZg/MS9E2SK1Vqt4KJpaaameiKuOwUTJGRvAuOj24RGtnyXuRVtEWmD+vok8k4pMgGQzbt3Gl4uWPtfeHkzbsudm4650bk4eD3O3lEN5A+ahYubfxsySpPb4JMNlyBK4rvTAK+4s2Uy7536ZTEQmQq0gklhn6r6+dIvA13aA8bEiKkrWe2yIPqFIJHxwrZfrZFAyK/6Y5fJ8cfQQlf6sNTEOrfvRLRjxdAMJk3chtbfOpr3RHGsA6sEATIFqrYHlkZHzUgkTw0ftgiqYRc8KQPdAR4QoIENgzdc/Cr67nx5UgWQ3oNWTvDGoSskXXWYFAmVwttC4c1Cl90tbiPrGD9ve9zZVP90B9bx8t5H7SizUqCoKJYXkH2VYmyrno4ubHVugLLq7o7XxOvi/O9NAprKiDOd/M4fiLfXxhoUr4Bf/B5CxSEu/QfF2aEDxIhy1Y+vuBapyGmIe3R6VxnDVxSz+3hMjsGMK6TCp4+0Ek/ikB56L7YZrKJN9e5kkAMBAZ6Cgn
 kWQjT2QF
 +40Kt7z+bqV7a7GaZSNyaSaIQQXjvHEzuJ7nTzLEJ7Y9VooVajtqcc6iWhRQuivWWGN3VbsjkMFPp0hkqYcjqX1G+HzOllBji+Y5BT6LUaMQS0+R9HRg8RZ0D+O/i0KEex26VSCWxNebFicGNt/iC3+ykrPikZX8fWdXac5AmINApbfUBIQXGowT0jHmCaWeaJ/kX21alhpdQu1Kg/hwR1YQqozYwzylgKrSPaUcFzuDGMo8kBk8+1MA1QPnHfsuPOjh8zmQfvH0gaTxOEEoI8refqTVYFnj54y7OFLp8A3h3paQPVhEPfFYEz55IbgCq/YbZNXSYZ68jmzrNihjHCIoJU9OZJckwtLZm89Ny5PCEbvfiJU8+OH+kZ3/4f3jCbg8ISABDasg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert fsverity i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/verity/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/verity/init.c b/fs/verity/init.c
index d6520660858386d3b7d69b20a459dc27d8017a5f..5f6a7b4f0a34aedebfcaffc2be53e00b23976217 100644
--- a/fs/verity/init.c
+++ b/fs/verity/init.c
@@ -50,7 +50,7 @@ void fsverity_msg(const struct inode *inode, const char *level,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 	if (inode)
-		printk("%sfs-verity (%s, inode %lu): %pV\n",
+		printk("%sfs-verity (%s, inode %" PRIino "u): %pV\n",
 		       level, inode->i_sb->s_id, inode->i_ino, &vaf);
 	else
 		printk("%sfs-verity: %pV\n", level, &vaf);

-- 
2.53.0


