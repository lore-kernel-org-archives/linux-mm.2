Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE9ADFD8FF4
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 18:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4152A6B00B9; Thu, 26 Feb 2026 13:23:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D4F06B018C; Thu, 26 Feb 2026 13:23:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C13C6B018E; Thu, 26 Feb 2026 13:23:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 130E26B00B9
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:23:58 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 90B5D8B44A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:23:57 +0000 (UTC)
X-FDA: 84487431714.03.181B046
Received: from flow-b1-smtp.messagingengine.com (flow-b1-smtp.messagingengine.com [202.12.124.136])
	by imf30.hostedemail.com (Postfix) with ESMTP id 95D358001B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:21:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=tyhicks.com header.s=fm3 header.b=mY7eiJft;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Wbr6CQoQ;
	spf=pass (imf30.hostedemail.com: domain of code@tyhicks.com designates 202.12.124.136 as permitted sender) smtp.mailfrom=code@tyhicks.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772130235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sb7TIp4SU4BPQBIvJrSXRMea2RP/1RRExQbDg2XxtlI=;
	b=kVoMEjXPk3gD5vSYR/0qttlAtBCV9ck38teZbcwGajSBC4VAzi5u7hLiLJQL4LTmQ6pm0W
	xruohcj8+biE8xI3foxO+aTpU428IQXroIdp/gYgIP98SaiLnHXTG3NIegQCZcz4ljCC9q
	krUDeWnGhmHF6mA9MLLXjCq6a3+Fhb4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=tyhicks.com header.s=fm3 header.b=mY7eiJft;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Wbr6CQoQ;
	spf=pass (imf30.hostedemail.com: domain of code@tyhicks.com designates 202.12.124.136 as permitted sender) smtp.mailfrom=code@tyhicks.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772130235; a=rsa-sha256;
	cv=none;
	b=OlgkZ1eceR0lNU2axSaz7ID3SGFSGtIMrijbguEHmZBxCY+abBf1Y8bL2OwishQzQr6DMc
	TsOkJD8f2aLCuJycPWwJaa2JhxvtdFsYsfAVnjF685Uw1pvz4EDSnoRltzZ3mSCOXbcJKv
	vttjJjUxldY4Xt8A2Gv8Ci/3Ff0tDc4=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 743B91300D33;
	Thu, 26 Feb 2026 13:21:48 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 26 Feb 2026 13:21:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tyhicks.com; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1772130108; x=1772137308; bh=Sb7TIp4SU4
	BPQBIvJrSXRMea2RP/1RRExQbDg2XxtlI=; b=mY7eiJfttavlrkoyTDwNdr3mxW
	Yya+Iw3UKA4pbqGLZDUfmlhGyawYCSUPSi+nDDwafb7FT9h6EPhkxS7vBUT895gL
	CnDmfTUJfgc1oaVWjG3Y1iau6+oI+/JO27lXnzxzEYRhz4YfNoox8740SEVZ++4s
	BBTZTkPZOp6HQ9AJfG5KwlTBpXiDSLAB3cve5cgBUIaFbLdz5uyQXSTiIahSPotH
	m1N2lXzy8Iihxh74XQQXYRnr/Dwi8vB0M0bhR+h5i6uX0KteqwydeufZ3dU4SftV
	SzNqqk6Em9aj+vgVUl6JrqNPESwI3T+GdW42gdEHfAduc4Ok2Dp3hiDxwYFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1772130108; x=1772137308; bh=Sb7TIp4SU4BPQBIvJrSXRMea2RP/1RRExQb
	Dg2XxtlI=; b=Wbr6CQoQTXhnL6un9p2QFSFiL0/WjAPgN3Hqu5CGgGnwO4FxUJa
	OmvY30abalkecNj7B20MZ1bpuJh+TEmGBZXYxqyJBkz3A4BfqsOu+C7rioY1Oizq
	Zd2fddNNaIjiw0VbTKEdT9In9NdBg15SPjbI57hQH+5YxYbOH79Eol9nG56xFPk1
	eiKeasIRabf/jG3UfgdumG0CyMN461bE3X6VsQJiOYaNYLPiKx2aS2bwVBQ9AEPA
	IAaqkD2V3JIkfoU0YEHqQLNSdvaJg641+JWTYSnTaSpqnNns0x7Gw5Y6xRmo3qP/
	n4w0XGk8yMxS7HR7c9eOuMmrQsuoDk98T6Q==
X-ME-Sender: <xms:N4-gaUgmHgN8QUT5uqZyoAILKIllC9CSpHs_aa5ApMJdy4TRUZaqng>
    <xme:N4-gaavxRR5FxKAhShwOptBTutlMZMQyOs7VM80awROwu53qi0gUMWnPhMfDsNHbW
    wOQnAjHtKRdhR389hAuinaNTgyNuKGoXkHHRO-W1GYDHnN4n7xWmWg>
X-ME-Received: <xmr:N4-gadynJhJmTysctuxAEb_rcwrEQCCAUTRr_O7lniLd8LGwb0bZ3JQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeeijeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepvfihlhgvrhcu
    jfhitghkshcuoegtohguvgesthihhhhitghkshdrtghomheqnecuggftrfgrthhtvghrnh
    epvdehvddttdfhfefhtdfgleehfeeggfdujeeuveekudevkedvgeejtddtfefgleeinecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheptghouggvse
    hthihhihgtkhhsrdgtohhmpdhnsggprhgtphhtthhopedugeehpdhmohguvgepshhmthhp
    ohhuthdprhgtphhtthhopehjlhgrhihtohhnsehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpdhrtghpthhtohepsghr
    rghunhgvrheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhgrtghksehsuhhsvgdrtg
    iipdhrtghpthhtoheprhhoshhtvgguthesghhoohgumhhishdrohhrghdprhgtphhtthho
    pehmhhhirhgrmhgrtheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepmhgrthhhihgvuh
    druggvshhnohihvghrshesvghffhhitghiohhsrdgtohhmpdhrtghpthhtohepuggrnhdr
    jhdrfihilhhlihgrmhhssehinhhtvghlrdgtohhmpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrgh
X-ME-Proxy: <xmx:N4-gaUiDHufb7QDBXtv8zwbIb83B1pheshVwg5ywjfQJEiEhKoV6BA>
    <xmx:N4-gaTYOst36ecB1dZaU-vU3382-pFYnRZALOnlpLPnbipXYkF9QHQ>
    <xmx:N4-gaRZQeIr-umcwUpLlYQH9oqvsne-oBW6cY0EOLVeaTmU3aOAHdA>
    <xmx:N4-gaXWU9S8BXIqIGWB3xu1aNy8XbCWoZVjyGjttFvAIRGT1xRapxw>
    <xmx:PI-gaZ752oPELps33je3r6u6yggqAG8mNBxGDV8jZFYtOdWW7-_mYAVV>
Feedback-ID: i78e14604:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 Feb 2026 13:21:33 -0500 (EST)
Date: Thu, 26 Feb 2026 12:21:22 -0600
From: Tyler Hicks <code@tyhicks.com>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,	Paulo Alcantara <pc@manguebit.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,	Dai Ngo <Dai.Ngo@oracle.com>,
 Tom Talpey <tom@talpey.com>,	Steve French <sfrench@samba.org>,
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
	David Sterba <dsterba@suse.com>,	Marc Dionne <marc.dionne@auristor.com>,
 Ian Kent <raven@themaw.net>,	Luis de Bethencourt <luisbg@kernel.org>,
	Salah Triki <salah.triki@gmail.com>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>,	Alex Markuze <amarkuze@redhat.com>,
	Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
	Nicolas Pitre <nico@fluxnic.net>,	Amir Goldstein <amir73il@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yangtao Li <frank.li@vivo.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	David Woodhouse <dwmw2@infradead.org>,
	Richard Weinberger <richard@nod.at>,	Dave Kleikamp <shaggy@kernel.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>,	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	John Johansen <john.johansen@canonical.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,	Mimi Zohar <zohar@linux.ibm.com>,
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
	Kuniyuki Iwashima <kuniyu@google.com>,	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	"Darrick J. Wong" <djwong@kernel.org>,	Martin Schiller <ms@dev.tdt.de>,
 linux-fsdevel@vger.kernel.org,	linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org,	nvdimm@lists.linux.dev,
 fsverity@lists.linux.dev,	linux-mm@kvack.org, netfs@lists.linux.dev,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org,
	v9fs@lists.linux.dev, linux-afs@lists.infradead.org,
	autofs@vger.kernel.org, ceph-devel@vger.kernel.org,
	codalist@coda.cs.cmu.edu, ecryptfs@vger.kernel.org,
	linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net,
	ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
	apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	netdev@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-hams@vger.kernel.org, linux-x25@vger.kernel.org
Subject: Re: [PATCH 28/61] ecryptfs: update format strings for u64 i_ino
Message-ID: <aaCO9CdY1AP8SM2K@yaupon>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
 <20260226-iino-u64-v1-28-ccceff366db9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226-iino-u64-v1-28-ccceff366db9@kernel.org>
X-Rspam-User: 
X-Stat-Signature: d9nkaru79j33m33nga1bekfnogpf4moq
X-Rspamd-Queue-Id: 95D358001B
X-Rspamd-Server: rspam10
X-HE-Tag: 1772130115-756899
X-HE-Meta: U2FsdGVkX1/TDE7qJiJ6ILYB4VlvCjAeAN0765fZSVIxrJSd+fk0/3ksLi58SYTb3dLUphSy3JHts2DtDrfd7GqFTlk5cKVKHEbsxRo6/7H2NOX8Zj3Lo0GyHv5KBFoJdDMHPXQkxWYTTTXFXg0Nmr6K4Zr0LafSdr+sq2eznknYGL9PAUIQAbIzMSfsRyEp8XyCNQD7GoRO90iV2mRLQC2glLDh9LK2u7hZEAdQ1wxRGRqHULVAeP8pSVhGLSh2AEt0/uYoWLLGnfec0KNlNgNKC3nJKTvqdponcPO3zNcj2kFE5PtSrBsKqaL+QdHi0oKMWL9VhDJV/rV8lso31/F23YdzN0CxhJD8NKC8z4sQY5st3BYisXZaqj+PKd4vejeyKGNUqcD37+tUZ5eoYmjbc9UGlM2RB90dgofNIbve6YjO4oai0Uz8sGtUC5QpcT2lTmEnQaSiT5qc4+BP6orfyarq78S7XH2T0CvTdiNCSL3GOjzfpZ9wwFENuVKLYTuAZ+YKG6MfEr2T2zKtO3SYvzklyuPiLgwgLtZwnlebf2ztj26PIkqNg6PIIDWNeN3+U0FlGL8Bzx9tYLE5YmsbKd9YqT3OAa5ebDn2Zk8OA7+E52omxzneYSrSnuppgPFz2AQ1X7VEbi7ItDq4qLavy6MVkA/YlXmaFN47HKyZn6QQXWYhWtnA94hbqtEWdYCAFjlJhnPgfYchwuQT4l29tftpNdoKT/3r49NLR4hlZhStkpdIqTJHhYNxg+roZX38mc0JSmASiofJLSuo3MbKzXiuHshBP6SNhKW9Yv+3pjOGC1a0dBRczuBHwpG4kPFvfIm99ynO2Peb1VjdWCMZ57TR5RI50gy/ZgZurkkeXLJ8yBuyJrcvxegFW4Q8DXwNK7h2TGexQ8EUG5Swk8qiOWzzcjtfZcdMmwqhKkcsn0GQOD1SJHhlR2ORsREr7jzmURMHVGS1dBUmseD
 vRO+wLB4
 YoBAEbtFPGNPPrlGziJRIiR4wbXWt8tzfdvFpmo4jK2oCHPksymjmMbsogtCohqWCxIx0fNY4ZFLXviQgBUBcYJc9jP8g200mxNbIjbrVL/3PFlgRnpqTNji8sqHquPFwDzC/MOHdqsopXwl8SEgGDtNcCezYcT067MNp+FQYWItgN0atbmKGfQoXZyBN0QYKr/hiU+2Qy1hhjQq0Q41JyInv0QOFOu9Z8m/muF8t4AbMpRLcB9vNPuwXYfu99LQHJMXJeEbEv5PwhmvrUNweYkloBiTV1Y5WWXCOrLVL0zUVRL4C5VsfWbY1j+ZCkRkfel/KPEl/FNuE7sgwwjp+p2JdwHzN1DajAjzuOOjdRcx6M10QLhhy+809bGy+Z2ZbSXHZVgrNzHM5Wgox7/bKegQogaW3+3ZSR3QqkeXjtaGXAUM+imWT7NaAaGbz48wGehYDcWAe8Lg3Zi/2WxCv7XT2X4ELLRoxA0op8kIXxhvNDyYzIB735bMeeH9Tpf/bi3gCDE1WFhFBzFHZqAkIWoWM+4A2aKfMi57Dm/D/oPztCwcOO7Tv6BaRp/y+sbFPmtZ902SLAMLPT6OKQtbjsIzU9GPqw7PZkRm2a+PiG7IZTZ1iWOFoN5c0R/ID9Z3ZVD5qYhbLbR9LSKdJa1h84D5AyI6UxS6AFDkykugYImpPyFR0ZmQXAhJyaK96Y7E90mjxLn3d2qqs81kCk2/shJCffgnJpoTFfgJCC7cCvkW8Zd/bXxBNiiPEKyNR+2tao2xvt8BQxAku5hC4CkvNj8Tofla8CkCfGER9LOgtlDrLDmLabmnOsN0u2Ij44+UQJCkNAq4e/1SLNmZt1Bzq2Hk5bs6uTSGGLq3+JtRt+rfx7mcW+noIff+/uxjdSU2P0QcUPbq+RNegKkaRakSaUnrjXgJMPyJCZYxPROP/vHrOdUFzCnPnBuXTP61rHhZD87MtWG4eSe8+2UoN8fJQ+pp5rtYs
 vePsNSvQ
 coNpgcoIkOrpQr+TEiWFQ2WfYqlIYvCs1Q8pjlrCdK6fHjtGG9Hx5bR31/bAwZttx0YU4erGY4aFE0ALMeBAl7E0Qt1etmzkGZ+rZ46N2cFQhNSxmgdSU7dn/uAo6y/82A7tw2JDJcxWD2iqVPETZOQnE9z4FjLdylPksGSo0jQ3hao1CltNfQUYJ5zfhQLcoJrqetLN05Io6wAbGEqNfr6FUy18akfKcS27yXHPwctXMm4mjpPKCvlsacQBbsLhi7RZ4PQbTtOz3+3xiOblra1YsvMo8O+8z+pDT8FdY75t8mqvZ62lAZZZEd/EEHEdBlRK6eqP8/0w1JnzHX5hBE0fnpZgaLtKQ1UNa8zlILZPIyoZgqeRGGO+04CQE3ZawhniJCTgNmC8wmXiGDHdfFf/cdBDfJfOscZ+zby4GdGi+BLvrhCnRt0ZpWCGCnG4kV+NumgttQRrE67AB4dO49NX4oxE6dR0IXsgUs1p+2dImcCXJchgBl1T6AqL2kjbjNs0qAazD89Gxdetgd+Chaj/iVqOe6kPDzU1ypE2YrY9kpFdYgE1iFR4HgFdKXQgNm7CWGaT4teo1cTsfOm3jshQDRHXWgDWpATiJ/dR51mCDr2yFl02Kfpt1DqifiW+De9uDIvANOePF5WT+QKq1gw/yqYcQzhpvJedUJe55XsGEulUCh2tu+dvB7gR1yUu/gnX5Oasw6BQpnzZlom6VWv3SqeTlQPGE92VcJVirdHnttFYeTK3IsUEz5Tq23xV34Z3H7Jd0pYa8KuX5clADfx0Hu383UdZ0NzZ+2FdGu7hfpfms9IsIxVKt0qNb05vpGpQnLlthsDFBq93EUpyquopqjkwrkL/B5lY0vZJi92GST4YpuM2w60si3p1waxvGnLKgV7WP5+z1O9LjMRouSpdMxRrrNDYEkIghvSvvl7zJcFcFVRHENRYIQFzTL/PleAFz3zbAJESPTCXh8hZrTzCBzUSs
 Xj4oRyXa
 IrrUTw8/BSjwha87+IBlHXNHJXgu9a2B9Qp8rUaUh/V5eVmXKxfDH5f8hK9kkQi9UFRzrKsCODr1a3N5TJXPsScftal26ZyZOXGQZcoMPwOsM9Wlo44NR4Fx1tRIhgVmFwIiXhvQ4P/8xr5QYfZH3WeqLDhwbdW2KBaE2aG6ODK5lEY93Tuib9s+qcPKWprvfgyF+2T+gD/Io1yt8G0mqRENR9lvqc/9SsUAEqWdNhULkohQVJUGhmbASxAq+QbCa+KoD2ncM6c+3fQ3epcP7zZVKQmKFlcPyXN0BelFhMxXGKk5Bq1A1n4gLObaptGgCjsqyDfAAfRDA19IgNlN8j7GB1jTW9+sj3tCUWBhd0rwu+cDoZQqa9BpcNS2iTiXxYWdoA202wE3TvKKW0QIIbCHHhxyI7AMo8ji8nBumKhIG/6DtdSqkPyAZdlMKrSQASkhrq85SJbeFHHXSzwqhHc+6GUcZVUXMmNcpbixsc33u20dv9dm6DzHM6PAnHV1KyXYqA5FCUAxhMuE0f5H7qRxpzkXdiOl4aeP0hgG4Yv1N8Qg330I6KK42wjmEwmT2rvzNWXsGBKuXQTn0XYqYJ2eMCImAvZuDfxVcH9niILTovcbLd+F5EMNbaanLZb465WMQ+AuORpPrTwV900hPmcVAFcVqaL6htacFco1rXIZCTAXFv5d6K60EDRO9muKCahA6iK0s8cyC9H+SGjrU1z1jBfMHVPnIm8Jc2wl7DQAr6JMoeR2+wjwrztMZuzNZ3veNH5xuR/h2nQZoqKz8T1Ww5yyYSBjiUCdmP+K/4BNd225NfL++6r6hsCSbefXQ2GOr7imIY9fKz3dsh22W3CzJ0OP0rfR4WaDWO/VN6x0+OTuc22POyHa2gTt5/fxCxQofPyW6p1bWTFMzqx3i0cRD+MRuGcNeMGXlS02NojNieqYvPv2frDoF2dPcq4KZq4FEIEh8skkWRStfO7Lm4bsfE/jE
 t7l/MAnr
 S+BaDzrDxR/8/Dpl4bjoG1wWfowrur9bdtgoeLVmdWbVSp9BIYeamFczwivqcJ8K6lQScKe4kvwcO9B1BdlLH5vVBAi10IWfgbPg0uIQMcz4U4uTpsyrmXYvhtxWFZgM0I0IuxSdI5CVY3xQsxQW3mzlmYUKJDGcM8LZLLV9n+PR9C0Cmvr6371sn2ZJgkCr01yFeLnG0B7Q8W/XUMbdND0mCI1UVAQF/9TwKWhe9XcQx7gvvaVHDA9BZyIsmvaQ+rijQCQfLb34dt/Z84pUgAgE8GhnJ4VOlts7LhCZxZYYyBILssTDPDZQ8AOxnIjioo0C8O/559noQg+1XdP0GrjISrcN17slHucCQVatKqVHMUKahVI0KZfwia5UzuSVCRCXhPgxg925pJLOVw8CN7RoMycZgSZ4K5piWZA8h/mQUCzhoSr+gC3fZQ+9Clbad0eeSoOeAJ/V8cb9+X4N0ohqSPkSqgVgFptlUVBnd26uKSgy1y4GlG6DXOh6EKpZ8lY6f30h95YWL27xrqTDxs9TvtKLogvOW8+USCbQAInmeor/zRiyhNaz7pHZzejqY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-26 10:55:30, Jeff Layton wrote:
> Update format strings and local variable types in ecryptfs for the
> i_ino type change from unsigned long to u64.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Acked-by: Tyler Hicks <code@tyhicks.com>

Tyler

> ---
>  fs/ecryptfs/crypto.c | 6 +++---
>  fs/ecryptfs/file.c   | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
> index 3b59346d68c594fcd7e27bae87849d3e19eff56e..f25c9a49e251a591695a143f64d1a81c5211ec18 100644
> --- a/fs/ecryptfs/crypto.c
> +++ b/fs/ecryptfs/crypto.c
> @@ -1313,7 +1313,7 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry)
>  		rc = ecryptfs_read_xattr_region(page_virt, ecryptfs_inode);
>  		if (rc) {
>  			printk(KERN_DEBUG "Valid eCryptfs headers not found in "
> -			       "file header region or xattr region, inode %lu\n",
> +			       "file header region or xattr region, inode %llu\n",
>  				ecryptfs_inode->i_ino);
>  			rc = -EINVAL;
>  			goto out;
> @@ -1323,7 +1323,7 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry)
>  						ECRYPTFS_DONT_VALIDATE_HEADER_SIZE);
>  		if (rc) {
>  			printk(KERN_DEBUG "Valid eCryptfs headers not found in "
> -			       "file xattr region either, inode %lu\n",
> +			       "file xattr region either, inode %llu\n",
>  				ecryptfs_inode->i_ino);
>  			rc = -EINVAL;
>  		}
> @@ -1335,7 +1335,7 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry)
>  			       "crypto metadata only in the extended attribute "
>  			       "region, but eCryptfs was mounted without "
>  			       "xattr support enabled. eCryptfs will not treat "
> -			       "this like an encrypted file, inode %lu\n",
> +			       "this like an encrypted file, inode %llu\n",
>  				ecryptfs_inode->i_ino);
>  			rc = -EINVAL;
>  		}
> diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
> index 7929411837cf5b2e98e1d4288791d2e07c44a4eb..49b0fbe0428a2d202434ce4b5fd7d82d2a63cf58 100644
> --- a/fs/ecryptfs/file.c
> +++ b/fs/ecryptfs/file.c
> @@ -253,7 +253,7 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
>  	if (rc)
>  		goto out_put;
>  	ecryptfs_printk(KERN_DEBUG, "inode w/ addr = [0x%p], i_ino = "
> -			"[0x%.16lx] size: [0x%.16llx]\n", inode, inode->i_ino,
> +			"[0x%.16llx] size: [0x%.16llx]\n", inode, inode->i_ino,
>  			(unsigned long long)i_size_read(inode));
>  	goto out;
>  out_put:
> 
> -- 
> 2.53.0
> 

