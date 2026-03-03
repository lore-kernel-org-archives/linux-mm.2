Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6FA6EB3648
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 01:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C72A86B00D5; Mon,  2 Mar 2026 20:27:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C20246B00D6; Mon,  2 Mar 2026 20:27:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACA7B6B00D8; Mon,  2 Mar 2026 20:27:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 97BC76B00D5
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:27:31 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B69F1604C5
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:27:31 +0000 (UTC)
X-FDA: 84503014302.13.9641E96
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6B86814000C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:27:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=Ev6ld9VE;
	spf=pass (imf09.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772501249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/4PzqDjQa596+Pxv5nyCAFN8lvFTxej9AhTZolOU+To=;
	b=NmmfWFEovopBbETL34+7l43XVeAYzSbjJfhaMQmyNtc+INRrOP0QCAg0jf0YI7C/goSS0s
	QpKH2+Qb/B8dKIhrWImICVEwqgRjmsOytdTHmPurIQEnJrPg/pQQfpqB1E+EgyeYugdMp+
	6Ti7FeEBpCp3EmPNIG9tqr3diayGswM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=Ev6ld9VE;
	spf=pass (imf09.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772501249; a=rsa-sha256;
	cv=none;
	b=Vg9lQgletD9lHLOXAm3gQwVD6fBnEBDJu9pSlK9EIz8p6JmdYqbd7zeeUTAZBQR8wsxXf1
	jY+ADlarzDwwxgoZXF/X2y6ghBTiM877zJfs1Cn9/Gf50jLtpo6mOjMeJZ2O2FJEdExHIk
	MFrjeiY/B5xl0UBnRbpXg9YiP5OIlRk=
Received: from macsyma.thunk.org (pool-173-48-102-84.bstnma.fios.verizon.net [173.48.102.84])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6231PuHh026611
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 2 Mar 2026 20:25:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1772501165; bh=/4PzqDjQa596+Pxv5nyCAFN8lvFTxej9AhTZolOU+To=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=Ev6ld9VELfSTilMsdvuAuUcsoGxAWkhkYbGJgxub8uYi6JxNzIKpWtMLYSH65Q11a
	 LTgb4BMMz6Ut329yS0fdzL3wx8BHwrzl2QmBbUi2AkAdU/lHnsfaIHc/p6xNdd+Wna
	 Kr3z8miEjeR4glowkQniiW1V7ISWUhY5fmWVfihMm5VxA6SkKeku6+zbP1T9VwFBKQ
	 /5tsaXToc7QUEPpds9mL/NiU4uDpJ5GlCTl+veDU984lE468Lsiu54ib1lO8WnZhtt
	 A57VlXyYuMZkd5JTeNCMIbfzi9Fgy5IJlNHQH8JAeRIzB3rUV81721ZRGH+7y7rqyi
	 u4HI27iqLCxeA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 33A7D5AC5A1E; Mon,  2 Mar 2026 20:25:56 -0500 (EST)
Date: Mon, 2 Mar 2026 20:25:56 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Paulo Alcantara <pc@manguebit.org>,
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
        David Sterba <dsterba@suse.com>,
        Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Salah Triki <salah.triki@gmail.com>,
        "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Yangtao Li <frank.li@vivo.com>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>,
        Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
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
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        James Clark <james.clark@linaro.org>,
        "Darrick J. Wong" <djwong@kernel.org>, Martin Schiller <ms@dev.tdt.de>,
        Eric Paris <eparis@redhat.com>, Joerg Reuter <jreuter@yaina.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        David Ahern <dsahern@kernel.org>, Neal Cardwell <ncardwell@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Remi Denis-Courmont <courmisch@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
        fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org,
        v9fs@lists.linux.dev, linux-afs@lists.infradead.org,
        autofs@vger.kernel.org, ceph-devel@vger.kernel.org,
        codalist@telemann.coda.cs.cmu.edu, ecryptfs@vger.kernel.org,
        linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net,
        ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
        devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
        apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        netdev@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-hams@vger.kernel.org, linux-x25@vger.kernel.org,
        audit@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-can@vger.kernel.org, linux-sctp@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v2 001/110] vfs: introduce kino_t typedef and PRIino
 format macro
Message-ID: <20260303012556.GA6520@macsyma-wired.lan>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-1-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-1-e5388800dae0@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 6B86814000C
X-Rspamd-Server: rspam08
X-Stat-Signature: 3asm6cz61nqoc41ggoeujnbf4teecuyk
X-HE-Tag: 1772501249-582498
X-HE-Meta: U2FsdGVkX1/4X8Srb+q+AOw5rGsLHwQlDEWWSv0SEyD6wdXIGndljKz/kGNBFNTwTj3i4kNgJmrz5mrBCSiPXfT+WDAiYidk3hKskoqF0OIOrDXqYtG5acjTmyYgVG8SoFDx/kSD7oLQYTFX1WXWUb7FwBBlZ/EsleiSGIbLTpdMsuw8PFwzrZJnsIJvbflPzrvQj0bo4wbGX567luMp5z6o7ahNlv6wTL/sn0XphrgG2jP0yVwsxgdM2IXGLltI/mY7WHW+o1nr8Sp91QMVPGmOmkVWnNZJXJKOuqlR+bN7smfpms8YMzh9s9MhedTDnS10+oJysASbE1ZE1Fr+ontRgytQzjvqLrXpapTU3m3Y2+Xlcmtx9fkagQYlI6BZZnXD7hpANX7QDIOgpKrYoY99SmC4U207ZGbN/HmMWJT3dpmKLYQC5uZoYulsQof6pgveVaPT+KF4yMUjVtKHp5JodmaB984x0/oP+fzF0ug6sYKPowfL1+U1hXkj46v3iBtiXDiXX52LP//eNphJv3+ylZn1lt2LB+F2qs4C+sIB1fBvqUrZ0xF5j7C5nmH9fiOTyTX1VqhYyYf4L2I/+3YcPSpgBGde6xFs6Abnzv2RqjF0o1etYGuspPj1jjTA1vJNfaY2FCdfuqv31geT76Gb+DnouQqFNSOD80YKW9uY7RHdB6JpG9HHV439M2uhx4fKzF3hZJxGRBeHPX7t29FjbGHof9C7orUXvaY2P5XMKcuVN7bbN42ab4C19C7Zp1I/WpYrNAJeB0zJWGox+E1SltMmCiQJJEJoeAzt4xmOPp9O7bsQfkpGT72qdR4+hggVqMB+I0zpzFOUWKccWwX8vwPjTW3B6LT8kGlnrm6I9giG2moDzZQMelzx5yO6T79Fa276SyZq6xAZ/OvGCOaH1U1LaOsMUenukYu7t2O6+8qtaloj4uT/wLRSnlMw7+QKYPGpUzqf+uJpVJK
 TECVf3py
 JhosgGPJkUOn7DuAzbNDTxlH4uHPG1grlEtEZSNR6RbKuGlHnNF2xLcuKG+9mP/Am4/vjEuSOSTPCbDC0ZfyT0VAWbMpZITNstimg2HpIc9ABpia6j6MJVHVtTQC6iNJcoPJf5Vb2FBGGMbd+7MVjXbJoqCUOhCQBQ1bU9wcfej56hU7Qcq5HfzNvN3Vl40DoJJbRoN4KKdv5wLgz21FceZaMP1L9FrNzHKPqYoqBpa6WA9ohTotpTrCC43k6e9Ui6YmOkra5qLsClRRAhgK7sjl3W65CUlu7HYO5+KmEIwxMAC0TxbBXy1wp2HqFaVVU4aedL/ljhFdQ84TRPCB22zA68wXSVsdd2vPsA1kglYgWcA3Q5+KFeePQOPTHZTHsyUrGQAod8jAD8qVxzaqIyZPq21jhrHl7vdB1yuZYjfo9w/AtyIBWAGHJ2wYkqy4t2GzeDJ78+AnX7SE7jYg0bnANTrtXd7GKfq/jfeOyKjXU9ljD7uyJ50QF1fvMNGEfF4YdAvVJjscXH0j6MYk2SM7EPAEupqV0dWgVMfvp/HeEML0wEKUlGy+6dU3FiHEI+5OFo0pgpSpIDf5X2X24j56KOaB4QI/qJqNV4Ig850cX5l//Hn+kh9j+e/+nfx0dGA7dn1ylnP5Me4Z85S5PZdi0Olohhqu3vJZ81x6o/BuCPyK8RskCLobcJlPUNOJRdc++FiLMy/pltD+dfqgPLwK3gVJNDoPXdn7rvJQ9BdTe8R0nKm9ZycD/ySZTlpX6McXDJk6SLbiR/VVUt04oXth7ho3OanYeDhDUqoc2pDFvIssV/NS9xGNygBWeozXMAU8kM/nehphA0lUfJ2JC2oC3j4sqWnPgYDpXdWvb4s8iUknZbHsKz6QDLdaQqToQZD1caPhqW7scenu8yFuiK4hdtmHKDx1gAate6R3IPF18tXPDf9hSwdRqly4M6El12fiJOnraxfwUD2fPOavxxIWHHna/
 gxMvN1Fs
 vDpf+ya4Wxsh2SUv6wxb3yuVknpsVLVSzihgWPsdTmWsJgmkiyAeEzYEZ459mXapmQLjB0F9WzfFz1NIww+8DH7CXcvy99G96m91kaJEnTwIRYgLarXLE4RiL3mRIFBlPOpbQ5loRMoOk9+shoLFDXBbd87RrhOi4bU+CtkoZ3/rVtu6kFb9Fxbh8tG3+hTklspFaMQoGAyM8SwxtRAm9Ru3GA3FQhDWLQFMwI2qhbw5p+VPlUhgH8vFUZ4Z+qo+4kxXY9Lp6D7bzmZqxwh3Ap3JEr1UDLGDuRXYCxOte588WP/QcFIwP8cIxFif5C/gAidtoCbSCxtX66LgI44S46UL5VWKvWPkjdveV80xpesJz4r7dyc2w6FDUEZsNcCsajZoObnlPxhTW/DQZFei1SGQtnC/3GSC3I0aPV3rJrwUEf3og1A2TsD3mTQn8FU+h4Ul/xY9chgZUC6TXzXo1i4SG2SqQrEkRdRwnPEpawr7ONkPfhlFB02AqZUNi9oke13O7MXJiX3JsK2LVj7Gqgm7zH7yWJ14Kn5ZM1M0cgotKNXvhb87xeAbI8eAK+p4aIh4jfhy7/zVqapzC6Is6K7rp+KIAWQHqUiUfNet/dsWxx6w3cpaTarpQ2zG2YJWnjyLg1YRIOD71ZyvcfDicmqt8yi2AXCcVorCG2b2aFDlKDXBWVE9qJGhJhPMWv3Y4DPsD3AZSgpL51dQuQ02bhzC9YDMaU3fCur8ld+hNSO2gN+1AzRa+Syigh9NWKNCMpeyI2BW7jBHAZ8/VoBe9ItuqjxFMxyV67QyOLpKLLPsXOLujzhrn2GLRG67l/RLcbxFJYoV2jII8wxFFoTABExYVbLGWUkIZHEgRtRkxK/j7XVeb7Z7c3qOESvQ9+yCJ+65y7RsxTNZht5+VY+eqWxAJhySf8HyXjqoaN3sCnv6bxmHF+PMFWEBVF2a9EsdTSbGkVleqDCia/Fif6iBfhuPeMcLI
 ws0h+5mn
 v7P73xX/HEp8TrdR7+gmBkC2PIAZ/gnoGJ94iab2qcRk2KhDHfmLDdPonWjutaRvVqQTxu2n4DQF5MiNCyMb/I3C+7u4KFLZjp0kKLD3llLRCIcjWNzdi7dQeBkolLHKXrw/GtybOMfw9Ifl81SKsFxgmhCBowNS3U2+GO2HsXOJeSFq6aKoQFo1nMcya7GjR+9gAWBQxOCmf32ozm/J8RyPvnkW1Omn1bklDjq3gg4gk2p7mTm6axRlpyJlWDhT/sj+x1/4KZOTFQEMhpxV2v06CbF+dxJ8DYVpjGb2EcWtwqbCafthcpKsIRVJ6JHJdnidL28RRCikJqec0sgTOcuxYBaCQazQR2DGBBHUQnrrnzis09HLVxPQkQ30ye9sJAjnJPKu0R3YrCSzdSisEKRi1VD1yq8bKLHFxGw8fk6mPlNhigbo+dmIfv4ry6lO8ONG9slNBruNWC8Oe5Q97BA/x5xcBBGvH6PjruoOZXvymZLXpHrDWFM3UJMkCKtqW2W9KtjQNwsDZK3+zs/FqE87G8Z9Zpsmt/TqYKrcs0pfFcwlantou5rB6R1ccpCnXFmyBMlGfBJINq6APLW1ojrVJuhlEQPwF/aXGjKprvWJKcBqvZfchaDKzAM6Z1l4+DjVV/tl6TkhoaiZj52530xSOOdM55N0/QVU/ERirQwNHfZINJp8WXXJ9M9H0+Vf4XqwwgeAue0/c4Ife2VPkQ0gSLIPZwk4L4A6JHUkFZ8TQ6MNVBx78E4lYcOsf9F0gsorXFfoRf5wGGfbhj8CuPHfK4/qEZhGuogIZc2APY7vjlMZoP7OlokBgZuSneVxGxCfbSW2EntRWA7becNe/uaeVsCIC6QrcTMC4tbclcDfCtTPKui+ag4LsRC6qH3F+m5gcajm4PdnIHgq74enQtRDLIcUmghXP20yMJaZ8+fcE2mHFdN8UqJ7JuJIYr/vKI2FDOBhiaruow74POgTvGeYABrBp
 4gO/zZWR
 gVomLOYR7YSdT7OZe6eEZDztujHf6BP4fx7phmmKMFKLdE8MJAV6AA989KYU+RdJO67mE/8qlHKK3SHR8f8KJlQAx/+dd8B1r/T5W8EhH+qPAdG2bsfdQTRmsv0Oo9MdfHZBnHqpoil18hzilrIXd408/Fa+zjAVZkQOdCB+Os5cVrnJXG7/fhZvpNtFFQ7z9U66KCqeIgwZC2LnYqXf4fwy7+VBG8EILlYCivJCIAv6pHc+31ZEw77GDd9jVOf9sQ8sNPLS48aXKD8Aa6km7qNYaHqO0SArzfeTVJvTGk8fBUPbT5XGl4HM/DjHQNr7qJTI4gdu1F/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 03:23:45PM -0500, Jeff Layton wrote:
> The PRIino macro is a length modifier, not a complete format specifier.
> It is used as: "%" PRIino "u" for decimal, "%" PRIino "x" for hex, etc.
> This follows the pattern used by userspace PRIu64/PRIx64 macros.

For the record, I really hate the inttypes.h format specifiers, but I
agree that we should forward the example of the C99 spec, for better
or for worse.

That being said, the userspace PRIu64, et. al macros are complete
format specifiers, not just a length modifier.  And I think this
results in less ugly format specifiers in our kernel code.

---- cut here ---
#!/bin/sh
cat <<EOF > /tmp/blah.c
#include <inttypes.h>
#include <stdio.h>

int main(int arg, char **argv)
{
        printf("PRIu64 is %s\n", PRIu64);
        printf("PRId64 is %s\n", PRId64);
        printf("PRIx64 is %s\n", PRIx64);
        return 0;
}
EOF

clang -m32 -o /tmp/blah /tmp/blah.c
/tmp/blah
---- cut here ---

% /tmp/blah.sh
PRIu64 is llu
PRId64 is lld
PRIx64 is llx

Thanks!

						- Ted

