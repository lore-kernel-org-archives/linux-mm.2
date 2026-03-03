Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F46CEC144C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 14:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD8896B00C1; Tue,  3 Mar 2026 09:20:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B853C6B00D0; Tue,  3 Mar 2026 09:20:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12156B0109; Tue,  3 Mar 2026 09:20:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CE8C6B00C1
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:20:02 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 455CE1A0154
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:20:02 +0000 (UTC)
X-FDA: 84504961044.07.2DF366B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 56B9FC0012
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:20:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BvO/c2NM";
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772547600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hXjyUQLXsKHG/cIKRj/0Z8MUeNfCLkmxoflfkUoVV7E=;
	b=0h70wCC8Ip3ruZNXVV62V16hzBeigX0Zop1BQl8T6V56KM2I2M9ixH/n7AJF/dzw0ROGLx
	7A1MHxWuwu7srvpKhaUC2Aso0nXL1wjtdIdlHLujXRr12P475X8AdeOD8xf2tyI71aGkVf
	3prQiguj8Gw5DB6J7GH/P45Cnfd3N2Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BvO/c2NM";
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772547600; a=rsa-sha256;
	cv=none;
	b=nIsKERGXL0NEJkt3sGGYFiEoI8CpZVaPXO3zOEKJsuKrxCcuqxU4HYtkp2rfvtR2QHvXJx
	2T4dwOfhJii6x2ZsaF8b5cEXzR6n4xoV1GuTh5hfNueGqBOsP5HbF0nebFw/8eHjc5TUc3
	N5+QIjK/7Cnx0a0DeTb239My4NIMBNQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 019B3442AA;
	Tue,  3 Mar 2026 14:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657B8C116C6;
	Tue,  3 Mar 2026 14:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772547598;
	bh=r4+DRcQ99XTa57GDm6UbVCDzMLKoJoJJpUK9XBCHN4w=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=BvO/c2NMlj5cF4IFnh2cwEEwHPC+uRykDlbqHaFUHLuMKe+aON6CN2r16iQvqLhWB
	 906pehNXfsGl1JmRRPrlIBHHRDcOAQNW0aOQGWct1LMs7SQN2HmJcc55RPuHY/rGjh
	 EwpKCRaWtprBt9vQH1BmpE0VeViY92GN33Ndr3/7S+Lc6FcxOGEcvjksWWyqHcFE5v
	 4VEoCLdST94/msh8cq0/EDIUvEs1WZw35JRiUu0s9v5VOwxof3mAF+ySjWpb/B1ui3
	 TR43X87Xb8SjxGuP3BryHgDt856XgQ6qQkw9cIQzHSaP7W6/WXAN0k97k2OxpEqGyj
	 cjcDBpZpSimXQ==
Message-ID: <1310fc5c09cce52ec00344b936275fe584c88dea.camel@kernel.org>
Subject: Re: [PATCH v2 001/110] vfs: introduce kino_t typedef and PRIino
 format macro
From: Jeff Layton <jlayton@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Theodore Tso <tytso@mit.edu>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>,  Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers	 <mathieu.desnoyers@efficios.com>, Dan Williams
 <dan.j.williams@intel.com>,  Matthew Wilcox <willy@infradead.org>, Eric
 Biggers <ebiggers@kernel.org>, Muchun Song <muchun.song@linux.dev>,  Oscar
 Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, David
 Howells <dhowells@redhat.com>,  Paulo Alcantara	 <pc@manguebit.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara	 <jack@suse.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,  Trond
 Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck
 Lever <chuck.lever@oracle.com>,  NeilBrown <neil@brown.name>, Olga
 Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,  Tom
 Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>, Ronnie Sahlberg
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
 Tyler Hicks <code@tyhicks.com>, Amir Goldstein <amir73il@gmail.com>, John
 Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Yangtao Li
 <frank.li@vivo.com>, Mikulas Patocka	 <mikulas@artax.karlin.mff.cuni.cz>,
 David Woodhouse <dwmw2@infradead.org>,  Richard Weinberger	
 <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>, Konstantin Komarov	
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
Date: Tue, 03 Mar 2026 09:19:42 -0500
In-Reply-To: <aabpPQxCTweoTp8Z@infradead.org>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
	 <20260302-iino-u64-v2-1-e5388800dae0@kernel.org>
	 <20260303012556.GA6520@macsyma-wired.lan>
	 <20260303042546.GF13868@frogsfrogsfrogs>
	 <33228005140684201de2ca0c157441d3b6a06413.camel@kernel.org>
	 <aabkBadGzo7IZpSU@infradead.org>
	 <19e4e79a59dcfc4c61c8cf263af345d0d7026fc8.camel@kernel.org>
	 <aabpPQxCTweoTp8Z@infradead.org>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 56B9FC0012
X-Rspamd-Server: rspam08
X-Stat-Signature: zqkniih1rkh9ktnw6he86jzxfs4pcxfw
X-HE-Tag: 1772547600-461004
X-HE-Meta: U2FsdGVkX1+wu2rQSqnfjUF1YKda9BJip5z+eow7VvTV0UTKzoTilwnVo4UYfIZu8/10930gLh7mfJySisgBgU+dkR5HIJqY6tn3jPSlpfi6RiNEWNX9u3MFKhQJYNLkvbWV2s6blM1BBnV4Avb1fTsyVn887Q9WFu+UetBJS4I5W6BP7tNJI/V6jZt6huk8SziGaTVcSlBz+qmVIRqA9yHcqirbBiuPS1om9mMGDq5iCfWlfj2shYHmYNFUOuceH1WRm35Jj7YeCikYhBugJMGmYG/sqj46tAc8BlhNdBndHUE5MjWtnZ79SERaqaJl50Tufjuth/dUBo9H/MPkce11LA4MMvoxevKYNP0j29F7bO05LEn1ehEn/Sd276EoobW/Meo8XvviQKVACYDtWG6eGQHxULEqpOwLy1NCpbCc+KpxlbWNwmN5sBo7Lx1ygFwZr79kan76rGB3NpR8JTmCqX8Cs3AWGQao/D5U+fGr5EQ4EaZgHTJm19xmyybWcrFTtCvF5pXmqspafg2hJhgGl2yv7KxQ3cRpjbLBWPzzyGtp4Ay/JnZHmkD6D9P6TfjXu7wMOuraAg0yR1ZPH7mFfI+N49sWNxl+rxotf4SRIuB0TbeIw/NsEgXEGUq1YeXtWUo7fOMXmTAP2aqhxxRco6YzQ+MAGu7Ztlv96qFXM4CmdOtsFTnAcQH8U44z+WdqTqwiMWMXqDLGiL7PtMSL80qcmijjUcq7E7BdDMIhgRfQeJJujZ9RzXCEBVdymphwUAqFRxGHV69cqqwIJwbO9Q+8HMrYkUeZga8fSF4tFTib0rIEJB0DcaXUekKFJlfyxk+x3FPpCX6wb3CYV+OOeZJc/2I4vdMRYhRfs3bH5kjERc8pX/ayCXgsef//wAGs85ROq309XHjf+1ajiPE4gKgz6JMoOhvLuwEHZLvFwj8yx1jmJeK3ZwrGaaBiROjW8gTzcuyvy6bIa/k
 jmWL01TF
 uC9O+fbtyceA6/9dSxqk9VgUmawQrrJ+dSHUxhvvl2HObqFqn2M+TkqpHIGazhHPoXmvyBMHO9AlkMGWl5OWzjz0o9eVmLAkyFK2fYrP3kKTHDdAj5DIGBRd8Lk+aCFGdsTBWg9ru8iYd5UUdbYhT3CRDyOc12rBSEJWcvMIAY2/9bnuAXwwfafFi4dscQR1syDc5d+ZTcKrf2sFWviee67Hipmm8Nc0gD7dxpj6YHodmhdz1djBGtgYsKd+tClmrCmoHt2QaRMAKu6C8d9RDqmMtzBQvmK7S7iOjAtzhrYfiiDzv5F6okyO/9WYPOL8rkrGFdJXA/VqclEbiZ/kOJS9Qu/yIHjwp1n2nOMxyq3d5lSpV940QBQHDSPLHAl5AJkLSMWIRw0VYk4/S1uMu2RYDt414wzWOrvxcoMnpkAk5BCeyeGymGFHZp4GZ//+B9CVzRmOXol6ixMjf6Br1VdbCzb9Todm2/Rfuho6nYIVS/XBZXPOmjput6K/2dgbZ3II9jXsfABjQvaTGS7q7n9L4Rc4f1XcM1QGbOg0ZWVJAQ0d+4vzukCfYsXOcImI976+hV/pccX4hkiCOoWkt5JcQEIt52hGxSbIIDZKIRyOZHdpTh64FmVYQtTjkkhwmwbsB4sDh8RN0/NreqrfbWAvY5/K40Hw1JrXx/WPz/CzHXaqtVVBpmx64YX4wWRLexVodyw8nPPGqOit55xqOzlarv+SVeQA0Ge5exHjleLZ/CY1ggrZsJPACth84JGWCHQCbH7KkqhC8w70rkUsRFc/Az+UHJ2C6fh5TrK8cESQMX3y7qiC/dHdq+zKsFP8Egsz1t/nMAm1erM3gPkjJ+Y/hM9FHGzRUsGc/AQKR7WoxRTQPHrtsSwAzfu3hn7w+vkW+Q4e038ZbXRpWDUsUNf0qcti7bCYpS78D4Yf7Yyuhex2hHwcvAl4sMDGMiKfwSo08Q4FqFdQ+cbk3j7NzA/iGFAGJ
 +nC5AHRt
 mljnmhjXt0BhZczq51dUYxuhgFdNJXXDT1j52+kk25QR4iOkG1dukDs8U/hCBpq0UG9lZ+pUUwBy3m+Uu9Aks3LymuR9Ud+oYVZbcNuAGqyOB5HjYFTWfS1HKhS9RkIrvs1WTbd0Z3OlXyVs6b3N/15R3rz0p4UHm6ydVa/zbeFKZBxyCv6VTrPM5s+63gw0f9TyXXAKCsAae6UnyN0yJPoEibAxRKa7KqE8wEcFXfPFxN5BVYE7rbhP6QII6O+6paI1DNPYKzLUW6DcA3zxbhOfkX2nZA0qk1EjlXveV5xnCwEnDzH2uCeGxfZZhlLQ1xaqY10E1zSMZWPSIrP5NjKE0AdcCTb3Wy3qH621pL/S7OojBuGY5KsSKrFDPDp/DILx2NCKTJZFa8JSEwxa6VFLyBtUdY3LorrHqSWAnCo8jZCbezEMQq+mBAZss82EPyOhr3MdO+MoYgSkp5XVUDwGQuPEopa8f3AbAMO7SNhan883YVhy0ONk/v95UuG/5bm/qlWTBGgSGoTUJ6OQz0QxgYCOrjyfVzDRPmG+uecgW+p3774EHS3U9lqhd0n/cI5tTcPdnwdi07Ge5KykQEL3UaOXOIjtSRv+6o8YKeO3kZSb6JbY0iuBC1wZoazUYssO2oU05qoPCRk4w8zKRyOayxCdbOlcPaFMqnNx26J21a6QiQFAwQHuoaG+z5VL6FHKJyqQdVYdbSDjo5yolcfYSveb77h7JDgP4RxXVAeYC/5qdKCWXrcx5xcL77NS3HT03adKv4C7lTQawOtstL5qqlNJrdLEIT9+8WohdNSVCTp7TP2fKiBaR5E9YjyAqD7D8NfihSir7EoAj67bscrZIhcmr7d+uyHsv/+PTBfonKqv4FvRmLgefvcbFbnAS6fkNpwIs2jlXTJXZgcpcebiH+8Y5KKKdc/woNwE43s5wE7CnAa5rsT/xkLem457RCKhBYg5SA4eASBSQapwoTp2sLucK
 sPGDcDTQ
 /bSROHJNSKmVMsVWDvw7o11TqC82fTqkwq6DOy+itKi7NDNY/7XaXwGyi2bFBtaU2/nqmzSnqwoJr2l4PxN4xE6XNeUTe/4dfBYV1pkXcC0A7ojxAWF4DrEqSVsS9tzh3NqhH78DmRfiTn/o/AEF8z1CCZjeWr1FztLDMmBvXcZIUvL6Kj9fBF7kfzQ0eDh4lfHu2+5G6EqLpNTPtf610G8vLAPa7dt69K6ffnjUHoYydaI6BZ4yWF0T3u/f7Apwx74Y5BXF55khiY5suy8+JzRvtWf7BVEdSsSVMeBy3eh+g0wGjBWhQFU7ZqmygVKqgM9cRlaMW3jFKt7AmnlW0ClXc8+dPOGMgbwb+ESzR7AprIclISwZAcsXQivkme6yru/j8FteRN+7HeZSQKX2RQI/ydj8elDbZoL4LyNOMmDmdAGsFT9HiQJv378aZN1OJ+LcUDuCW7PLhfg/eGUHnGVnUZWDa3Q3Ilfuop6ZQiU4bX+dvkQnCL5ZatHvafbZv6Oc6sWwKqGE4ntxuDUz2XOPrS0mBkb0sCTTEJRhWQbF2mBKuLb6TNn0pKMH8y1YNhM4wlLqfyV7tKqYXj/qrDbOkPCd7hBZloPc6evzQ0KS+K/hCM3JKDaUZpz6pTiVFl/OIyBNt9c385Zp2OnU08nKbsBUfnuhipDQzgsvW/JXjFEciZTCUD+VLpbhBDnKhF3L6r1GU5cTVyyPxOr9y4/TEhtfncAlbq0q3H2s/jk1DCQDvM6wea29eLbHB8wn0CscjFul/X1GWnLFml1XdKJKSuZbTZFB6andVzmqu5lUdRk1XSClWvqtyXd5c1URt9pYuAly+AHMt1bW5ZbDilvwa3jZw+SSuI6PN1LKMBF0T5URQsy9CYYs02k6+51VJ43rIjmQFPTisqv1pBxLAHSYznDiYdwCm71KCRYyOQ1+Mby/ZTiU1ngC7zzqmRvDIM3tP/zAbSlQDAMoYnQihMnYn0cMJ
 Ew77sWEi
 gJNSelZI5LFYUxS7WQ8GqhnK+CDuj1CQ06vwyAmTZBPEn1GBgU6DrQD9ugC7F/imZtbCr05AMhUWnU8ivmxTZSOjAg9UFbt0drrQ3cD94QjxHpHvjNtraAMEnitKfGl91eGgRyGWcDTnU4tiY8c3EQgvVZ4tAGIeqVMmJVvPdY0/BPlTtQ1OHtG0sOIah7vrdlGdeol7/Y5UCHY2lTCpTrYxaEB3e6aAQVftEERw1sOB7QLOOdDHVlCjZxgNXoD7lSx09fGRoHFKwd4iHp+v0REYp1HLfCkYUfC/bdHuEhpiZFor657cKNfIDUu3epWM+CLKadvmStnGWkoG6BB9HqY4bVl4zI6k0dUb3nnQkBV+PunQFznwrO0HiLKQpnYxofpQDM0aaw/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-03-03 at 05:59 -0800, Christoph Hellwig wrote:
> On Tue, Mar 03, 2026 at 08:43:15AM -0500, Jeff Layton wrote:
> > On Tue, 2026-03-03 at 05:37 -0800, Christoph Hellwig wrote:
> > > On Tue, Mar 03, 2026 at 05:53:39AM -0500, Jeff Layton wrote:
> > > > Like I said to Ted, this is just temporary scaffolding for the chan=
ge.
> > > > The PRIino macro is removed in the end. Given that, perhaps you can
> > > > overlook the bikeshed's color in this instance?
> > >=20
> > > So why add it in the first place? =20
> >=20
> > Bisectability. The first version I did of this would have broken the
> > ability to bisect properly across these changes. I don't love the
> > "churn" here either, but this should be cleanly bisectable.
>=20
> What do you need to bisect in format string changes?  Splitting
> every variable type change outside of the main i_ino out - sure.
> But bisecting that "change to u64 in ext4" really broke ext4 and
> not "change to u64" is not very useful.  Commits should do one
> well defined thing.  Adding a weird transition layer for a format
> thing that just gets dropped is not one well defined thing.

In the middle stages of the series, you will get warnings or errors on
32-bit hosts when i_ino's type doesn't match what the format string
expects.

There are really only three options here:

1/ Do (almost) all of the changes in one giant patch

2/ Accept that the build may break during the interim stages

3/ This series: using a typedef and macro to work around the breakage
until the type can be changed, at the expense of some extra churn in
the codebase

3 seems like the lesser evil.
--
Jeff Layton <jlayton@kernel.org>

