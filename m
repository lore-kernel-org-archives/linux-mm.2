Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D38FEC1429
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:54:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7C776B0151; Tue,  3 Mar 2026 05:53:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53DF6B0152; Tue,  3 Mar 2026 05:53:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D3F86B015E; Tue,  3 Mar 2026 05:53:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 78A9C6B0151
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:53:59 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2581F8B847
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:53:59 +0000 (UTC)
X-FDA: 84504441798.30.7B21BBC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 49AC24000B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:53:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hu4p2+8Z;
	spf=pass (imf04.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772535237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iiLQqE/gGoUhUB5FeK4ie7aVui9WPlvjPYhGWBUkR3M=;
	b=olq3ZpuhxHTW3tj0wWCuxFJnPkx26tyHHagIaReyW0ayzKroNp6D0dmMKJzApZDJMyqu6+
	f2mzLSdRkb7FQvewpv+vyK0c+xOuvXDjzYL9xDBGy8pKPP08RyqTVSVkhKZUQnHx+VdMad
	7QvwXDn/Dn8v2IFS+ZvcUJxE+Oumr6o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hu4p2+8Z;
	spf=pass (imf04.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772535237; a=rsa-sha256;
	cv=none;
	b=gXabcP2ImM25BlFffPX9RoWFYFGw2mkn6+uOtBQK1AEih2cvDSsmIjwyVNrYKyvGahXjSd
	QVcuf/8jGQvF0NOR8YC4wM2sbkeHDbxSiDAZCxZVcfjp35tSjKq8YHxjphQFk/QdoRJwJr
	QYRVJBpml/OFkZlNugvSvb/t9FTH1rE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 448DB43C5F;
	Tue,  3 Mar 2026 10:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1144FC116C6;
	Tue,  3 Mar 2026 10:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772535236;
	bh=p0kDOuUJp/6naEK1aTty8mE71Stjpf1QrLyVZVxDOA4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=hu4p2+8ZvYZ2X7dr2Us7EaNOBBbABtx9XOvwdTWcuO5KthFigdlgY144/h9J6IGz8
	 netz+U6Ku25iGs9UZXioxgbANgLrB+qEW0Wmd+TOu/q30RX4W3EuQYBx0VTeLZaiGb
	 Vqm2xUv9Uja0SiQ8QtXFHgfhKRSqJWcM3qFgu0C6CC2hDwcc/9xzbvhf2162gW5xB9
	 aWYwY4cO1lv9ftduSfik9ao2JxQA2RDxcHulEbJpmNjLgkTqUvOliNthS+oPycJZyR
	 yMswS8wlIsEtazmn2Y7jqSdfyA1z43RD0Is3CDQwMxIeWhhsCPdkmIOZlt+j9upVUX
	 zoCgXIiYdEMAw==
Message-ID: <33228005140684201de2ca0c157441d3b6a06413.camel@kernel.org>
Subject: Re: [PATCH v2 001/110] vfs: introduce kino_t typedef and PRIino
 format macro
From: Jeff Layton <jlayton@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>, Theodore Tso <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner	
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Steven Rostedt	
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Dan Williams
 <dan.j.williams@intel.com>, Matthew Wilcox	 <willy@infradead.org>, Eric
 Biggers <ebiggers@kernel.org>, Muchun Song	 <muchun.song@linux.dev>, Oscar
 Salvador <osalvador@suse.de>, David Hildenbrand	 <david@kernel.org>, David
 Howells <dhowells@redhat.com>, Paulo Alcantara	 <pc@manguebit.org>, Andreas
 Dilger <adilger.kernel@dilger.ca>, Jan Kara	 <jack@suse.com>, Jaegeuk Kim
 <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,  Trond Myklebust
 <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck Lever
 <chuck.lever@oracle.com>,  NeilBrown <neil@brown.name>, Olga Kornievskaia
 <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,  Tom Talpey
 <tom@talpey.com>, Steve French <sfrench@samba.org>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>,  Shyam Prasad N <sprasad@microsoft.com>,
 Bharath SM <bharathsm@microsoft.com>, Alexander Aring	
 <alex.aring@gmail.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko	 <slava@dubeyko.com>, Eric Van Hensbergen
 <ericvh@kernel.org>, Latchesar Ionkov	 <lucho@ionkov.net>, Dominique
 Martinet <asmadeus@codewreck.org>, Christian Schoenebeck
 <linux_oss@crudebyte.com>, David Sterba <dsterba@suse.com>, Marc Dionne	
 <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>, Luis de
 Bethencourt	 <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>,
 "Tigran A. Aivazian"	 <aivazian.tigran@gmail.com>, Ilya Dryomov
 <idryomov@gmail.com>, Alex Markuze	 <amarkuze@redhat.com>, Jan Harkes
 <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,  Nicolas Pitre <nico@fluxnic.net>,
 Tyler Hicks <code@tyhicks.com>, Amir Goldstein <amir73il@gmail.com>, 
 Christoph Hellwig	 <hch@infradead.org>, John Paul Adrian Glaubitz
 <glaubitz@physik.fu-berlin.de>,  Yangtao Li <frank.li@vivo.com>, Mikulas
 Patocka <mikulas@artax.karlin.mff.cuni.cz>, David Woodhouse	
 <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Dave Kleikamp	
 <shaggy@kernel.org>, Konstantin Komarov	
 <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Mike Marshall	 <hubcap@omnibond.com>, Martin Brandenburg
 <martin@omnibond.com>, Miklos Szeredi	 <miklos@szeredi.hu>, Anders Larsen
 <al@alarsen.net>, Zhihao Cheng	 <chengzhihao1@huawei.com>, Damien Le Moal
 <dlemoal@kernel.org>, Naohiro Aota	 <naohiro.aota@wdc.com>, Johannes
 Thumshirn <jth@kernel.org>, John Johansen	 <john.johansen@canonical.com>,
 Paul Moore <paul@paul-moore.com>, James Morris	 <jmorris@namei.org>, "Serge
 E. Hallyn" <serge@hallyn.com>, Mimi Zohar	 <zohar@linux.ibm.com>, Roberto
 Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin
 <dmitry.kasatkin@gmail.com>, Eric Snowberg <eric.snowberg@oracle.com>, Fan
 Wu	 <wufan@kernel.org>, Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, Casey Schaufler
 <casey@schaufler-ca.com>, Alex Deucher	 <alexander.deucher@amd.com>,
 Christian =?ISO-8859-1?Q?K=F6nig?=	 <christian.koenig@amd.com>, David
 Airlie <airlied@gmail.com>, Simona Vetter	 <simona@ffwll.ch>, Sumit Semwal
 <sumit.semwal@linaro.org>, Eric Dumazet	 <edumazet@google.com>, Kuniyuki
 Iwashima <kuniyu@google.com>, Paolo Abeni	 <pabeni@redhat.com>, Willem de
 Bruijn <willemb@google.com>, "David S. Miller"	 <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Simon Horman	 <horms@kernel.org>, Oleg
 Nesterov <oleg@redhat.com>, Peter Zijlstra	 <peterz@infradead.org>, Ingo
 Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland	 <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,  Jiri Olsa
 <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, Adrian Hunter
 <adrian.hunter@intel.com>,  James Clark <james.clark@linaro.org>, Martin
 Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>,  Joerg Reuter
 <jreuter@yaina.de>, Marcel Holtmann <marcel@holtmann.org>, Johan Hedberg	
 <johan.hedberg@gmail.com>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
 Oliver Hartkopp <socketcan@hartkopp.net>, Marc Kleine-Budde
 <mkl@pengutronix.de>, David Ahern <dsahern@kernel.org>,  Neal Cardwell
 <ncardwell@google.com>, Steffen Klassert <steffen.klassert@secunet.com>,
 Herbert Xu	 <herbert@gondor.apana.org.au>, Remi Denis-Courmont
 <courmisch@gmail.com>,  Marcelo Ricardo Leitner
 <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, Magnus
 Karlsson <magnus.karlsson@intel.com>,  Maciej Fijalkowski
 <maciej.fijalkowski@intel.com>, Stanislav Fomichev <sdf@fomichev.me>,
 Alexei Starovoitov	 <ast@kernel.org>, Daniel Borkmann
 <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, 	linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, 	linux-trace-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, 	fsverity@lists.linux.dev, linux-mm@kvack.org,
 netfs@lists.linux.dev, 	linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, 	linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org, 	samba-technical@lists.samba.org,
 linux-nilfs@vger.kernel.org, 	v9fs@lists.linux.dev,
 linux-afs@lists.infradead.org, autofs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, codalist@telemann.coda.cs.cmu.edu, 
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
 linux-x25@vger.kernel.org, 	audit@vger.kernel.org,
 linux-bluetooth@vger.kernel.org, 	linux-can@vger.kernel.org,
 linux-sctp@vger.kernel.org, bpf@vger.kernel.org
Date: Tue, 03 Mar 2026 05:53:39 -0500
In-Reply-To: <20260303042546.GF13868@frogsfrogsfrogs>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
	 <20260302-iino-u64-v2-1-e5388800dae0@kernel.org>
	 <20260303012556.GA6520@macsyma-wired.lan>
	 <20260303042546.GF13868@frogsfrogsfrogs>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 49AC24000B
X-Rspamd-Server: rspam08
X-Stat-Signature: mjsk5ib4zkysopa8jqpaekieog1k18y8
X-HE-Tag: 1772535237-840769
X-HE-Meta: U2FsdGVkX198iuUSnPToHC/vI3AEmq1Xvtu7Pi2I+iELsmUWM2RRNKlQd/oDEbHrJ5UX9AnDz8CQMnaTvWOMMuMzHvXLqSm/eY3zgk3k3FMlaCzJpluQpbOk5JWUU09Aj5w+RWffkT65krokNIqJhh7/FMpQD8XJ6L9peeucciJQv8Hv0Os4A+KpnXQsX1PJXuEzXFMW7nr2XlqAHxyJW1oYLR23OCr14tdfpVDLZzawx04fBzUTmjCl41scEYuocmavGCrdmWldda5v2r2Wa36gEHEFkcfwjXhkJ170FvFN4E6mY3UmCPWmPqLo79rnK02EYHPK0OjRUJ7D3ixN2DzwdYKziCX4Ouh+0bHk8kXi04aw8bHcIQYbhH0zi/EFBBiPGP+OCj52rZwV/I0+s44dsIadZId9N5kZuOj1IlFNxiLYaQDCQ+FdysANeVlb64VzRsZGEPTEAuRf1ktIm5j8jWr+8lb7IpMNQjGXCpU8pBNZBTFMVG2wF2RD5KaXXpe03DIveeqR57uJWiHtAQkOuhfSYKUY3ho52V4++xt1loCk4L6ZNn5YFeaxLH6XctpEo3C6q+mMleqKporlVekw6wCVZohUUExPHQ4UkkHpL08fvGUD73WZKMfBpGCUvEsvvJy4UsIpsNmx1Qm7dxcdoI3cdVofkg3JeLaDd+/bN05Uo1A23d2Nl2fj7u/megTCNT/4tPolIOoAiOx+xI6QAUggqdWpZpTc+kFBtuc0rGWGKR4bJ2cPjxogEjzPEB+z46YOOaSxMtwzM11ujL2hNDf2cUtnxcsfNRZtgW1ViHwuILfWAECTZ4PkE8yzwak+YaQRsThjmqNf8I54AgUsgFOhmWNo8RWmCl6MdFFy2HVl3iQtLb9kk3OsV7XUScTmWHqx8NkNEQNRwN0YAlb/c+oqjtsNYd2ACIpye4lzoOn4woIFaeYy990UROwkvY3IEwq3cs1NAKAGeFl
 5eSF9rMc
 b0h5O/xMKDf8O0/P9q7mYuHX5LIfg/e+sMusYayzYw6k4M0FPEOagZ3oIJeGsek8OOmtu/xuaK9qNHU0Sd/8zUFT3VliB1WprHW6vAKdG/nFzXZT4NLh7JsxKCpTF68ibEdBhEDFg1+uSqwWdGhmoypuwM/VPS2g4dOEGygrJ8pipACQGu3M8jUbp2ktenEsEjWNFDIbsWWmPbqd6hGTHsiCBCbinQjxYC5DKErDbFEwMMHnjpc8i40UWQuBTPYjRyS+9mBPDiis7B2SDqj0qrMnHPlFB+SRfxQQdRnncylHQ35bOOUFD8HHyaYVkg/9wiPHHfCtSn2v/LuS8J4LUj9RQmVP9Poix8YEQQ32Ypihf7NZs5biBI/+75m2F8AbH5P1KhG5b7pC8k2oM1T9YotL0htl8q73bL//eppvmdvHj+NVNNpVKHfZfW0zbZssKLIDxHgzEwGwE+RovV94TeqkOCBDLJ1ffLlxWjBNtPOszImrn0vjs2nRNNXUOoS9ao5T1kzy3s6RpFsfqqpls9XJ2dfCh/BdLFb6/kjYb4VKjs3xOEUlMDBzQhd/WT08ktRgCex7zQwtwM91q4TyHQRJZDm9T5+1h/JPNGkSd0LAnqsSEpSQAqdpzGF+q98OR31WnV9eaHwku+rXNH2Rs4x4jBLHvgNg0Il47+Dl+Syljyf3cs1NjbCF/vZhYnIGdLatL54W9F2npBkNUuda0KwQiBS7H/GlLPeWhtUkTQDXOjqouZAeaZ3ceIwTT5GchSyN6mfxBlu73pNP8GPvJCBczrzakpqVSiaVA4Ke1TZndDez+5xw6p/JWoqp7Z+jiKwo+yBmj0sw+UQp0gL/l8BxViPiYbvOhgLW+/hTSYTe6mVL/J6yKYSeCNPTRhUNV0XgVKmJbCRrhkulImrlfQyib5kuvwB0RdzD6JCArAtB+JZ6V71HsfCzpSYFXwILOijddwz1JEEab9/27Eb0ebxdmD6M1
 1toWHX+z
 Z46wqJBcYXtZdnyzGvtXyWSbUm/aKXv5sxaIjUKuRWqbrj8na3hVQDWI2n7sDLewb5ILwTmOgSsUDSIiTRcPme+vy0PPacLqDYaweKTrldtRwGkPfN07dQ3vundwq6+wUr+tlm0vFHc4fGqtPA3JUZA9oHqpHdjYOCxz6h7ynMbrueSenlG4uCKHiRVuKnUcchfb1Mgglocw8fH4El8g02QS2NiwIjp/GDafMCxqK6olbfrDm3pdIE/99VwvkhJ9aPTDSUq91TWH0K9A6MxeDft58gME2sW06w5IHU9rQPmReqGwO9UXv81RjeX97+41V3zQfcswqjEXMeTegziy6gphU5F/8VAVwrF1gF1Z34mMUCF289vOqS0ii9AnYmofLLWUzn97lqDeM66AOA6g8aVmLZZssg7el3HK9sy575U9xwLiTq3yhQHhuFRdu5XpQzn68IAlUAu46OULWSxUpiLzjPNRQu4bRhLpIuQ2Z3C/MfPHihG4ESXbwkqZoDGeckY4Nqe6ZRvRSuXjCaQbDT1l7ay5sLKkLfH3Vpg66Tg6XyxZW0Ca7TBIK66LLsAw5uCvmOYoSYqzbgWpMZgmwa8m7H0D+YspoiT2w9XVlcnE3AG6lqkKAHYW9mxTWh7psIOxuxEGhB1bkLhpzyn7GQp4JZSIpAnd8ZH+xTjNOJCX54XW20XU/sqe30buxVoBcr7vNRZybjADDkFbo/aVTz79+mA1QY/NWATiMKEcIlaxfDkFVza4RJjmoSsBcSiZRM3l0J2nBvYz4uM2duWhVAMtv9Ofm0rTawi6425NnJmiVomUCGdsa8rDjjmzmhKNtwLIfElcx+V6hd3gk6UHgxwFeFdZ3jng0TBOGJXsCw+loeMJrRIO6OmYqDeZjVQ0gJfWJUc7yi9E/d1fBDD5q4rbKhFuz4LNenDREaKWu/hVTnMybIhAUaUh+65o3B+QCR3hsd43vRO1mqP4S4WYQw6+Rs105
 vS0E9BIC
 oPvK2C+lO+p8AyGWEAQ+HpnSqwbmvJc89FPyEAAeBUPtGskQiUurwoLf1WPQUEb24TJu9TXm7fk5xoOubcjCyfWM21pYCOt1YtSXP6KMDoZgmdUILU9TCyOC9mbcmGWogFX0Kd9aW585281YA9EMN5NEdFvop0/egPUsQLrHskUN30baxIYY+svaxWYVZA8XXsjpo8BgFnK3J2xFPqBUE8/KSsjKcXSvHvYkQRQvb8uQSKhwjRNi74oem/NbYo035erSXLcOCqfEMAbolqoy/WRqrmrO3amBwTliqI4q9qT1xDMg2dcCwDqygGI0Qu0JdtHIrVRcerBisiUuxrmRYOLIwJoq/GsB6X8JM7ZgsGCu1BJaacWNumTR+ILwRQNm24ysoHAirqdIBLUFVuDFs2BHfh9kymyNV8oRJAW9Shw7BPYgE9LP6Ct0aql4gpLj9cjwdDE9ME0VrTtvg2k/aYLdyKPgm0PxX5qsOXreEhN3cfHi64SuAuqE0HKfefkKpqdLOJILoxwnAECesNmq653RY/G6/vMPbmJBpA08fJXz6nvw42eXJv8D0JUaoZIZR0WR3nbSeRxuXz/0mysktU2Vt80nV8RGtDFgKgTRP/TVHXgq5HRGPuLA+H63n7TS9vwoRotOQjsac9+KEK7vu9pptIfGOIpAttnucnDvhWTcr6Oluv6K6sGjF+Iskynw20xoCTchCZg5b8/OjHB4H9zeNyomjxgUb3bsQZaP0VamwidFfYCKUh/byI50qHdK4kxEcLSwqvXqzEXu7f21s70ItbRox3BvUeFORJrlETJnXLGvPzLFvboDCX22SSBR+5BFhk36Nv6TbPeQxZXsVbWR0P/wpzgpaoL49taM1mNcCBJXmHck/evWCnVwjGNtmeW+jtVkKUtLN2rlCam6dRuuGuxMjkQ8WQqvhi+ltfZbmH3SYw2u5WoeRL9MeabG3VN1bfQJrr/zyMh3kUGI1ivnS1Lq3
 HMGUQU+n
 im/DDAMYQPKYzoxCU0LjOGjV828ZByTWPavTD1Al8MGJfpehCLAfPeYhcQRzRa4mWMIjzyov1S+BazzoZwI80TfLhMQQ7lljrXVhGj8U4vBxsTNfpklD32/eWG6rHn6dci46JaHoEiNGJer1bwoUQBR3QoEclx3QAsmDGFdNTSC0/JMppVEwwP0AYqHcau0klCYRJe6/eVFmVzwv0UeiEI2gMt4h2yJ7EYooAhGSOYGdwmxZZfCqZDFQo7Zhl428vv4MCe/KpbmaMnGHXo9BkEI3lpb9urMDgaSH6+iTZk58Fg1x/2Y1HHYTjWsd3UYzx7Wh8Jc3BeJVyy19Z/m0AZt6aQ/BFQjwUqBEFaSGVHcuteybVlms9sM/N2Tqzn36DqVxwM0LOScw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-03-02 at 20:25 -0800, Darrick J. Wong wrote:
> On Mon, Mar 02, 2026 at 08:25:56PM -0500, Theodore Tso wrote:
> > On Mon, Mar 02, 2026 at 03:23:45PM -0500, Jeff Layton wrote:
> > > The PRIino macro is a length modifier, not a complete format specifie=
r.
> > > It is used as: "%" PRIino "u" for decimal, "%" PRIino "x" for hex, et=
c.
> > > This follows the pattern used by userspace PRIu64/PRIx64 macros.
> >=20
> > For the record, I really hate the inttypes.h format specifiers, but I
> > agree that we should forward the example of the C99 spec, for better
> > or for worse.
> >=20
> > That being said, the userspace PRIu64, et. al macros are complete
> > format specifiers, not just a length modifier.  And I think this
> > results in less ugly format specifiers in our kernel code.
>=20
> Yeah, I don't like "ino=3D%" PRIino "u, lolz\n" either.  I'd rather have
> the whole format in the PRIino definition -- it /is/ unsigned long
> after all.
>=20

Like I said to Ted, this is just temporary scaffolding for the change.
The PRIino macro is removed in the end. Given that, perhaps you can
overlook the bikeshed's color in this instance?
--=20
Jeff Layton <jlayton@kernel.org>

