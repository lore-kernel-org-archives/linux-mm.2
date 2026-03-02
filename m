Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5389FEB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:42:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2986B0119; Mon,  2 Mar 2026 15:42:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B653B6B011B; Mon,  2 Mar 2026 15:42:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DF5E6B011C; Mon,  2 Mar 2026 15:42:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8902A6B0119
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:42:32 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3CF5FC1851
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:42:32 +0000 (UTC)
X-FDA: 84502296144.17.951948F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 86C0C4000E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:42:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="a/jE3ee6";
	spf=pass (imf04.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RmCRsYEZZAnyX6zud58mmn6xaqiNN86TYcfTiEVlx8I=;
	b=RReT3TVFlCiZYyOZYOQB8UU7of/S1hcA03MO7iblQ9zph2p8yHpjXxdlqAgB/UMPp8UTLZ
	sMYssiIMaaxAlTtwToohLWpBWDLQP9EYri3fjkYjOevALa5z53m6r0DikKcRYGjVD1e+8B
	NQNMjldwl+RcOdnaKz6uWYr8ndfJq/I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="a/jE3ee6";
	spf=pass (imf04.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484150; a=rsa-sha256;
	cv=none;
	b=NB/6jRo32NuSfilgitIZFzwG3OZxW3yDmqMiGLPKYkFcmlvhOQc+tmSgsBWp+LSQKe4Cm3
	V1chh0Q8/75y171vlbfFDrhTDiVhPhXDwBk1feVl+EouKt1odoaH14wOPgXd1Km6OOMSAm
	5Mfw2vvnmL/NW6WMm43uZkPYgLPTIH8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CE0C96013C;
	Mon,  2 Mar 2026 20:42:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B88CC19425;
	Mon,  2 Mar 2026 20:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484149;
	bh=YwcnJPXAAscKHpgEUGItsgnX0yRJGV/n6SkEskf1J7U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=a/jE3ee6RkkoAR7s9l6a1ENMXzAkQH3rzlJKvh65bROG350op/0J6iplw4D1sc4+d
	 oclKZeRf/gF9p3h+0Ecg7zQDc8pfY94Psk3F75OQyXtohzK22vgDimG9zV25t+77Fa
	 4QFCTa1FhaSK7w4t7ExfQXlnKNZGeowT7C2QYGwPkKFQGZoxe9cB8Gu4co9y2fRdPz
	 OdbDV3ayUG5lGiEuhTBPpj9O3buZIBpVUm47FTOYZAtxvGOYKsASwsEhe8WTNzaPvZ
	 x0nFFGGJCvI8tGIu9/jGqJSU8XQ3ahul/FvMkZP/YJggSxaUgXDpMkcHIaqtdgE5aW
	 pqqiTw2LzquqQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:57 -0500
Subject: [PATCH v2 073/110] befs: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-73-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3816; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=YwcnJPXAAscKHpgEUGItsgnX0yRJGV/n6SkEskf1J7U=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIDQ79pU7FI0fHRZsQJj5jJC8eGbR6XylCUt
 iOfUtPsDk+JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyAwAKCRAADmhBGVaC
 FVTDEACODHYOCUH/LdAmO41y4Vp/cQpSV4BkS6bppIiXGVitrXjSRpOaFdxtiz9gxx54BpWWKdR
 Al+s6e/U0ikWt8dDXfF720St9a3sq9NhnC9kk7RLKYiTYzCiysHFoxvJ2Sq5/9Xdq8+4Dl+7cDi
 UItfZbfovn1p1DaU8yxRY0gG3AGBr8YVljmhwc1jWQwATwMdZO3Ccq67ucawTLfSk0UMP1InPTP
 38hAu0GT+lCiUGUC9PsWGrtiAWoigdRD0KiYA924ehRyaAvljF2ZYXUNw39S3TdLVBao0+0UCBl
 Uo1KrUYQ+S/pg5fZSTMSe8/N4d/0KilhB6RZ+12IiUhp5JUGqEENQGik6peVTS7xUZ2UsV7AHBb
 6fJQ0zIyydryLLsSJo+wFm2AHn/S6718RwT0xJfq3gngJQmsMm3R+fJMQ0UpXOx9jRecSQlVA4x
 4hN3zUrRZzrRSy3r/AHaMthM+sn6ALA0ftLLaHTXxVTa83nswRChaRiI4QAM02yLFh30DSm3OPA
 9lbE1Mf3tJAAmVI3W5tKTn/GqACo8SiCb5TSnWQokqFjxwQawyM4Zm894Pt8md3nZwvM+IW2DMW
 GdSy9hz3NvToRFldLJ2SWMeHuOK6wRLgIVFi28TrErot3lvkCo7CGu38/w/PyKvVGa90brNOBGI
 9atXB2D5v/wb2CA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 86C0C4000E
X-Stat-Signature: h9ikt1bdbz9yq8w7k4e7ifbnpew3hrqh
X-Rspam-User: 
X-HE-Tag: 1772484150-743756
X-HE-Meta: U2FsdGVkX1/nmh0kUmeec4w6i6RzvIb/eTQ1aFkZ1lnJXRb+SaI0kyJaK6Cf3A9XO6v+A4c09reAzKUJifY+gHNDdI0xauJHH/9JUkEnbTDh81hkk0MADwEvDqHKScYIHwrWc2S/IFPbobYsy71rTEsYkopmYz6P63E4djvd9GnDYTnE5rBMg2BkbIRgoUoNj+qZNGqGZT24TMBE0DcW92V8bKKlSLTNDnm79t+IJCXxVG/0/4WlIvVhjszBVLHDxZ1G1M2KxqIcP7OBlh0xMq9acXLR2mrQFR3p3pIyM7mbr4btg5acJpksBTV6jTo5j8sf9JhVGrHZEGlucoPPyOex6IybPfvvkfUYSoFEEC2R7sVn/Sdj/4RVIqDPx/GHNyxbt49N2ipB9nWMvrzMf08GgejkRVMg2yrkiLGE/6gpOPxjK2MOMeI/AVGmxN6hGPxcez2/iSnniUOHqBABJ46NA/83quMVpQzoHU4M5z3Pv2Ls1VEeo+LQCLS4a0jpFApdtE2YfMBrN2ZASHyT6IejXYDsUm6KLAnIMPF4goN+t6uU783vMK1410Kxf0cj6H26u8wC705m1wV2KNC8XAbvjAhnvffTyRdPfr3xjQqZih0AWyoys/d7pVoj8yPjp62WfpRMJaOdaLCly1o3uLSxgekupLaTZz3654VsvJvME8poUtwZNCa+2M8QDKjRdJIVPRfgc2+Nwv8ByKl/xLv3MCMlKqlEFjPN+iYFUt/e5WowO9sg5REtLn80aB1VVVrfzY1WSQtr1b+U21Or8ZPyobASUxEmkY7rQwwL22Tg2MK9Bd+1UUk8iDMh8vzwSh2s+/qJs2SX3PgfKgmBsMT9x17VrDzZOGsBud0TU8kkEBiCn/6vBchC0KI5OdxyaOhfhrPXiEngz9cHJzLCPEtVqPMU5voF0EIogCwMcuEhClliTx6nxSJ3WTa1XTA7/Cd8WfIgaJGL2FydMtP
 xGDRGTsp
 boac3IqJR1vQ8XI7YKGAyX9MjugAdEU1ICTFLDci8S7wZ/tZNSKGjLCDkiyiQ3eFPMLbHv+o0QTitTdaz9J6TTagu+/6kt7wsIcRmAc+tUv543W3bUhCOL/6rqV7Hv56SAXOvaP91IWb8FBETA623wVaIy+9kOTlwhVACOiQoVZV6UuYJeDJA5Fa3HE9qq2C6pTLZCx+1CFWni1MmZVYumxTqpmVj/2EPoi4Jgs2lV83MgGJmjcF9Kc3ovncuRAneY1SkGYwtPUq26qJjK2tNBTbRK0aElTXCYDCzFHq84sjoXNBKDsytX/GPv+bZjInGq3w3RJCDv4r8KPQLsfP3MtoHhWHO9u1a/GO4pnFVYdq2mbsgaHy/E8DqPBL84NTKc831WMC84BF+jHpX4UUD+zJhpUF+nA0icj0zA7IngOR8qYHT/w5M0/xd0YqiOEJhea8eRkjAsVezWGfWPa42wYTwwQ1y1uA5oFY6HbLtLvTp1zdrgayCR7d9CR6Cbxnb+TExRAZsXXwao39lOLvBmKtPu8TImt5jx/T0IthAgteh4gu2tjUOFTGznRykyCwt1zg4qwFyifXYivsUKzpU1qeenOAF/75S6DkWDFO7M8tL++Ed7Cm1cMjGnfmSDUzFFyiULUsTDEoPIlFyE//mnEaMjsrKRxRvgHoTPZE/sV78UxaZBJx0W3DXvXVgVaOFqOBY314SI2zcpcAnfvyeUSTaDNfC/wdNSpJ9yFf9sE/PzYrOSW52sixriGSeYueP8CPxFrxQqpd+kYNqud1GGyvyjWwHw5Jlfa4K0QFrwWRhPrEkKFhi1CufyG0He7qluNOVrV6baT7RApdjzTR7CyMaNPh2Mu54uslYgnGSpR68/qXZ4fa8nz5HThhFEBPMh32Fk5udMEB/4hd3xyK95sZwVbAl9u80KCcphzkh3YKjECCAsdg0xo1wW7UZjpdynx9ZndBfiCGZHtmz4n+J8Wlk0ezL
 pBWp0GLJ
 G8asQ4/OEblCvZPaNiFWvPE/w/OBZF4CL0YQ+Nrhv3EeVqLdXHumc90sZEIE+i92BGFWx6IqvHP0aXMZJXK4zftz4bGD3JwZRwMpC0g7LYks3uD54PjaV+gPt4pIkvs6eT0Z/tT6a1INnQh/CnxE+KZQQU0H102M5MhZpshX7ytCl5uXcrpE5Px3yLFK+PBobrNVfYK4X4HWC7L2UNtaLwIX8P9aFZCHn4FMu9mLJTB8RekbJdmlMueodXHNNY3vTsKUYj/GO2aDoF4QI/QdE3amJAE3VMnJiMOEBhAQnHiGYeCzwRg85aQsOC6LG0oD4cQ68Gmgo6Bz12qFJL0f1aNHXVe0SH+vs5utm3PupbmNS4GtA7T64jkZ4WUMbKdkdPKXenZa4awnEFBvGTyLdLwlZYUzOM/zHYxeLUMy3ardRMcP149v03x7sTTb4HAhFekrlwatz5i7naPD6T/NXMb6zQwAHgFhiiQ8P2bv47ouThhVhPGI7tG63KBiRjKiXamSGCjxxmtcYu7UqKgLmFiDBCvLwv7sdwfT81ZMYTJm4MX7sCeg/UApccQN6diPRhqzyNeultkdJontoh5/LLFLnAerprd2N0EEKU2jLeYcayDucbTfBJp+/BPY+CHdxeMZ9zdshaWEwSajg9p5RW0XhtX+zgV5HHIQBpJi5ln8oBM0SwOnP3CSdvk/74wqoLF9bbWtNO3gwupeXIrn7ekadJIeZNuJ7VNyp3h7fly4y1ATPtAQ2VOqfMtGu0UWWQoTECD2xbcoQ+ESTlhRoJc76/aCTkFk+r0HRY91ZpMBNVr2Dh4EVXq7euSs+xHHGESrud3QYDHyWucifHHCgDIT+MjAlCicUU5qUqJNHq/H2tIlhCknUlmrOxB6R94pyeGhBWr1wBvt3tI+x3WgM+MQzlkPn/6AcIQ34n69k40UbpPYeO3UsDb5/J+N+j3TlH3+7Zi5rkg38MDSrakUmrgPW10vx
 V5j4e13L
 T0x5NVsZMpDuk+Sm4+5ZtS05h8HM1s+MHr0i1XtEtgEg0IU6TtyCmA1sbQbpCrvPaB1k6oC0QwZ6Yuk1gHiD2NYtqd9q1WI7L7MHavDYVB4AkTNHtK4nyRYRurmoy1dFk7Mu2AkwgNLhk1njCcWhkS+Rea9U5l+epVKSD/Ua03dx8OH9YriqsSyNq1QWnGsuSjZKpLWp9S4alCmHN8TGi5ugYrDUbHvEtYN8YgqnkSmU14TYFwOroc+Ungig5Ov+Egu5fxWYlqJGAlgNJCO5tu8oNtvDTo0/hszFA1STQCmqBYWyx+Q+024r88/+rEpCCRZFMjuN11F6Ua+EM02AjnFTfjJgcR/uQtvExjsu2bejteTxXJAGyHwF4BHhrx6etA0f+QropdGb9KlajZP5FQEb86TSDNe47nMJkbca3f9HprwQx0eIjKmCPV4fzdO/hm2HW/x9T4VFVGwyQbClieIV7SDCLKVBVPx4yQQ+yn7ZlBKZsk9Sbnva94pKcyu74bhD7iLVnRFgqAL3MwdgMBjPqJV3KOYnZa7p631DmTqWWLyIc5DMkoMl7iYi1ZIz7XHCrzIbC7BBcp65YtPJ5UeQuDDcopgAXYkLynz0spCrgGxxyb0cdumLChCB2oedWcfR8wzQoKah0Tf6Xdm8b0zqM5F1bdYZHIPUee+fFWjwnUvkNVu6Z+wMRZ6PeuZAhRpG1yizvVu15sHxS8qCcnxZI4Lw6po4bCIgkTaF4N2cphvI9go27uiE3YfFJum1LwJwL8OaSq9Xtb/uN68JRa4OKB5slwtkRpGiNpwUyM/NZoqM6VcrA89sdRyd4ZelVTBaYrSX5uBj7Sw8Wb4Y2qgDoTKkZQZmVCAmzcN0u0pGCda/QOR486/FY0zrdQ9A8bvAKZPADQaSDMlPj28/NSJWXhAUmvYDxALA+ttMNORmRsYWemzUrytAqXYfSLdwt1T11Gh8O1FIB93pOLLxSWxoYD82x
 h9MnILDb
 KhZTjPgeHWdH4q05GMl7YkrXdvjbgk7qfsAwpFw+Qqm5hUS1WSg6pSzG83fBQxEr8cLmsEVphEwCyk/shx3wA5vIrCYxRtXUISH8xvEUJ5FzgMFPFUaOwyllMeMRwu2wnuhVtvQK9ryTOyC+xcwPSm0qIiZyFA84Gp0/de2j5jJhE56jjsEykEWyr9cpebDZ7rW9Zv80U4Q5mX8mbAdfji8Q9oBG1XzTgiMSTPxcI5D2s7JjV4e/01EaGPF6wtV0yRYu9EqC1tNZAn4JztE+N1OTH2ti+AQKQEO6DJWx0DeLuj+p6XzvR/VaY7tRgI46895uRD0YGEoZKxT/18Nc+O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in befs with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/befs/linuxvfs.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index c36216e23eb3678645cbdece913cc260fd10f4f8..c12caae9a96799b0a57e6cb5010de756f8b86346 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -140,11 +140,11 @@ befs_get_block(struct inode *inode, sector_t block,
 	int res;
 	ulong disk_off;
 
-	befs_debug(sb, "---> befs_get_block() for inode %" PRIino "u, block %ld",
+	befs_debug(sb, "---> befs_get_block() for inode %llu, block %ld",
 		   inode->i_ino, (long)block);
 	if (create) {
 		befs_error(sb, "befs_get_block() was asked to write to "
-			   "block %ld in inode %" PRIino "u", (long)block,
+			   "block %ld in inode %llu", (long)block,
 			   inode->i_ino);
 		return -EPERM;
 	}
@@ -152,7 +152,7 @@ befs_get_block(struct inode *inode, sector_t block,
 	res = befs_fblock2brun(sb, ds, block, &run);
 	if (res != BEFS_OK) {
 		befs_error(sb,
-			   "<--- %s for inode %" PRIino "u, block %ld ERROR",
+			   "<--- %s for inode %llu, block %ld ERROR",
 			   __func__, inode->i_ino,
 			   (long)block);
 		return -EFBIG;
@@ -162,7 +162,7 @@ befs_get_block(struct inode *inode, sector_t block,
 
 	map_bh(bh_result, inode->i_sb, disk_off);
 
-	befs_debug(sb, "<--- %s for inode %" PRIino "u, block %ld, disk address %lu",
+	befs_debug(sb, "<--- %s for inode %llu, block %ld, disk address %lu",
 		  __func__, inode->i_ino, (long)block,
 		  (unsigned long)disk_off);
 
@@ -181,7 +181,7 @@ befs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 	char *utfname;
 	const char *name = dentry->d_name.name;
 
-	befs_debug(sb, "---> %s name %pd inode %" PRIino "u", __func__,
+	befs_debug(sb, "---> %s name %pd inode %llu", __func__,
 		   dentry, dir->i_ino);
 
 	/* Convert to UTF-8 */
@@ -224,7 +224,7 @@ befs_readdir(struct file *file, struct dir_context *ctx)
 	size_t keysize;
 	char keybuf[BEFS_NAME_LEN + 1];
 
-	befs_debug(sb, "---> %s name %pD, inode %" PRIino "u, ctx->pos %lld",
+	befs_debug(sb, "---> %s name %pD, inode %llu, ctx->pos %lld",
 		  __func__, file, inode->i_ino, ctx->pos);
 
 	while (1) {
@@ -233,7 +233,7 @@ befs_readdir(struct file *file, struct dir_context *ctx)
 
 		if (result == BEFS_ERR) {
 			befs_debug(sb, "<--- %s ERROR", __func__);
-			befs_error(sb, "IO error reading %pD (inode %" PRIino "u)",
+			befs_error(sb, "IO error reading %pD (inode %llu)",
 				   file, inode->i_ino);
 			return -EIO;
 
@@ -324,7 +324,7 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 	bh = sb_bread(sb, inode->i_ino);
 	if (!bh) {
 		befs_error(sb, "unable to read inode block - "
-			   "inode = %" PRIino "u", inode->i_ino);
+			   "inode = %llu", inode->i_ino);
 		goto unacquire_none;
 	}
 
@@ -333,7 +333,7 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 	befs_dump_inode(sb, raw_inode);
 
 	if (befs_check_inode(sb, raw_inode, inode->i_ino) != BEFS_OK) {
-		befs_error(sb, "Bad inode: %" PRIino "u", inode->i_ino);
+		befs_error(sb, "Bad inode: %llu", inode->i_ino);
 		goto unacquire_bh;
 	}
 
@@ -407,7 +407,7 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 			inode->i_op = &simple_symlink_inode_operations;
 		}
 	} else {
-		befs_error(sb, "Inode %" PRIino "u is not a regular file, "
+		befs_error(sb, "Inode %llu is not a regular file, "
 			   "directory or symlink. THAT IS WRONG! BeFS has no "
 			   "on disk special files", inode->i_ino);
 		goto unacquire_bh;

-- 
2.53.0


