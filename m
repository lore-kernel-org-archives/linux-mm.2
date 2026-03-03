Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97B73EC1431
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06D536B014A; Tue,  3 Mar 2026 06:42:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F32816B014B; Tue,  3 Mar 2026 06:42:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8C916B014C; Tue,  3 Mar 2026 06:42:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C0D4D6B014A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:42:12 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 69C0113665C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:42:12 +0000 (UTC)
X-FDA: 84504563304.16.B41F833
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id B9ECD1C0015
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:42:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y2OMrGoA;
	spf=pass (imf18.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772538130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nRx/0ux9alyHMvfrQ9FkhE3uG0cv/lfK+mFF1KAP2II=;
	b=pqzhpQytEhQrE97wS+76wojtJ76DoexWIB7IxZUBYFkv2Gtc4MCs1PgifxjTfCQe1FhEcj
	3Wqcsz/vViQJZcJ0QWN0kpSDyof0va+Olavqb+DPKMJeqYE9CxJdk315P1SvlCzwcL03dK
	C/I3+uI+RVvqfq8lYpPZYlreDi9joFw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772538130; a=rsa-sha256;
	cv=none;
	b=VzN6ar4oPKheo/ZG2ESdET7pNHTX6oK1CiEnRWwbYqEZJ53SIn5kDUJkwW1VjQl6kh5XY5
	icyyNk6kOtoHDcooEHPMAD+4k99whj4ubEU5QqBHin45BZCm0wFThsRJPwEktEKkf4rOVH
	vKZ8zOllwzyo7LzSFgRNUuTvCKXf0Ac=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y2OMrGoA;
	spf=pass (imf18.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 887F16013F;
	Tue,  3 Mar 2026 11:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F732C2BC9E;
	Tue,  3 Mar 2026 11:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772538129;
	bh=3g8wya1NSO/cAGYrlJWOY/tBvbnElrj2OT6s+HdRca0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=Y2OMrGoAYXyhBIZLmCU9xP/ANC4LE7odOyfggFTwlpHW2a02GVf2qaYiZflTjWtV/
	 I8znxkvCz6IWh5nXF/rgw9YfAYTVyjcarRulecbyRH3N+zneK+ffF1UH1yXEzl51vf
	 XZ54zBF22cl5uktNYsiwxWPxbzYgY1E+U5QiaZm1WdUHLfWOA5aZgRIOMftpOdLMN1
	 KaoLsvRpZYfZ1yUzLe56J4BgyyDjhmF4Q14GlC8OLKY09GND7rasmTWMAOCmwRWXRC
	 Yd8gu0Chr47o9W4VqzN/YTU2a1n9gkGS31e6Od8P13UwPQ6Qrv7W6P/UjkCyeO3XSq
	 Rpx9o8nQ4vf5w==
Message-ID: <bcc1509aeef23909ac91707d9663b477e5bbc1f5.camel@kernel.org>
Subject: Re: [PATCH v2 007/110] ext4: use PRIino format for i_ino
From: Jeff Layton <jlayton@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner	
 <brauner@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Masami
 Hiramatsu	 <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>,  Dan Williams <dan.j.williams@intel.com>,
 Matthew Wilcox <willy@infradead.org>, Eric Biggers	 <ebiggers@kernel.org>,
 "Theodore Y. Ts'o" <tytso@mit.edu>, Muchun Song	 <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand	 <david@kernel.org>,
 David Howells <dhowells@redhat.com>, Paulo Alcantara	 <pc@manguebit.org>,
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
 <adrian.hunter@intel.com>,  James Clark <james.clark@linaro.org>, "Darrick
 J. Wong" <djwong@kernel.org>, Martin Schiller <ms@dev.tdt.de>,  Eric Paris
 <eparis@redhat.com>, Joerg Reuter <jreuter@yaina.de>, Marcel Holtmann
 <marcel@holtmann.org>,  Johan Hedberg <johan.hedberg@gmail.com>, Luiz
 Augusto von Dentz <luiz.dentz@gmail.com>, Oliver Hartkopp	
 <socketcan@hartkopp.net>, Marc Kleine-Budde <mkl@pengutronix.de>, David
 Ahern	 <dsahern@kernel.org>, Neal Cardwell <ncardwell@google.com>, Steffen
 Klassert	 <steffen.klassert@secunet.com>, Herbert Xu
 <herbert@gondor.apana.org.au>,  Remi Denis-Courmont	 <courmisch@gmail.com>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,  Xin Long
 <lucien.xin@gmail.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Maciej
 Fijalkowski	 <maciej.fijalkowski@intel.com>, Stanislav Fomichev
 <sdf@fomichev.me>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
 <daniel@iogearbox.net>, Jesper Dangaard Brouer	 <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, 	linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, 	linux-trace-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, 	fsverity@lists.linux.dev, linux-mm@kvack.org,
 netfs@lists.linux.dev, 	linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, 	linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org, 	samba-technical@lists.samba.org,
 linux-nilfs@vger.kernel.org, 	v9fs@lists.linux.dev,
 linux-afs@lists.infradead.org, autofs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu,
 ecryptfs@vger.kernel.org, 	linux-mtd@lists.infradead.org,
 jfs-discussion@lists.sourceforge.net, 	ntfs3@lists.linux.dev,
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
Date: Tue, 03 Mar 2026 06:41:52 -0500
In-Reply-To: <eb56qw5rblcnlqupj5lftynq2vts2idha54xpegrfgx45znfuz@mdjzriuawmfn>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
	 <20260302-iino-u64-v2-7-e5388800dae0@kernel.org>
	 <eb56qw5rblcnlqupj5lftynq2vts2idha54xpegrfgx45znfuz@mdjzriuawmfn>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Rspam-User: 
X-Stat-Signature: 41oyge9jqxmq79g6injasuhwrdhjj6ae
X-Rspamd-Queue-Id: B9ECD1C0015
X-Rspamd-Server: rspam03
X-HE-Tag: 1772538130-737193
X-HE-Meta: U2FsdGVkX19GSIMAqL1WCGjaIrVjyAhWq+esdqZo9NZn+bJ0HRjqpE8YmbFV6ep7uD4Mv6cWxIi2+PNgc8PzJEu/VtAgXMMKiu913T1rEyYbGppWUF3fWRfYVRbQKilDXyoqZq3azrVQx1bkRGFIGI44ZlAXvPbpVsfk0C7gN2C13PICDsAX1R6vlJhLQ0qrfniX9eFY/6trRM8Tb5Pse0W64lQ9rungP5DaEv9mN4Vaitr1udT3oBdoHTuUsyA4mfeq27gXd4gtothrL4X83M1qhONailoTsQR7+lwXfqy7FR5YH/pPQRoYkaJ8NDu4SVJsan25dZn2g374azf/KoSi+pwnauLlobCCzRxFx0qv8jL4Pyk98FYxTIgvJG/RU3l79WVsVKjFqXKqn3TolNZOUDhcp8yua/XwhLp/PlOVDzRPTVuHQQIrWHC0cMSRTSGOx+Oj9CzcQxdQaNPTbuJLKCdL7ethwHSZBxJUO6ZxQpklfS9d5kdGEqy//i/iYxYoEfAyHHr+U3oFfr0bdUd/ZIM3yFXK6JEp/wD8pD3o2YW5HaRCyeaEH4BkMMFevGZMzz3eA1D0H4VAqYWAVvt/CW9JBxt0NIJfh2n92TR9ri6Wpx1DahOy4l5KNH8VW7isNp5lcuqB6RhFIOuzQsFD4/O2Ei5vLCpJwJKBdFZhjm167iBe579YGdSIBK3k0AXpnMUbRD4U1D2xWLE9BFeqhK932x88UFkevN5xdN6z4HOCGa9UwWACLCvY8irzflxSvqaB7N++Wulam7cdOh3M4+/Dnbr2xVxRoIwB6cXs0CMw84ihi9rO0iVqSLtc+EsA6EWWontI58TVC3IVE1vCiwAmWYS0U7o+Tty7Jl8dEFtYqTRdYBOwt1T9zjkivtZT2Xf3vLsSBL4Btw0+hRXBQQEqdHV5lSgp5rf29G8QSgEzWaCMLd6BzXcmpXYLATzJxCraBUDP34ELrP4
 PquSGjWr
 NYcxdhMBDUqtXwIAWRMhv+2lnnlKmjaEdjOPWdNrk993Iafb7wqulN7E+licPa/ZHDEQeHCixtLkKE33Tx7Jct/Pt8pPgGlH54sCH38J6l24yL18p44hL62feLM5G0CX/3CIPkyj9dTyhCyvCPL9Mbh8Q9i/IxYR7Lp1lch/fkUWcmEEWwn7iAqeRCj08onI+SZe0V7CIbrXvhHTER1EBdEj9xecyJynONAm+OWPl3fvGXQFN44kveH4vS/nSAv/zQPZh7kFGUnfDoto5uAyt2WCDlWb1OIgVAYlQ+4bojIjDbfqhaYqrf1bo3LnM+AHTQb25ghzt4Rm/rztmc4zJEOhNe9EqqPukNflLh3Z63w0V7nUT5qoxtOL35enB0PCRiJ9pHsppiKP9gHZxxVoZTKFqggmg8MoaYP3hA6lZsCp6jXV+Uzount+Xj5VkWkFdDSh9RdfeYyvKr6vZxYiry+zTWlGecp5n50QLhj0CVfcPF4KWRwMSUuaYowxvkVVYz7dqzxOyHPcCrpYVHC2d88bS3AXtfmxjHXfmOtWJX+ceCdRCsg2MieI3KJBgnGK6P5xIwmQDFtMM9nDDfyPjUIODR65n5i1rDVuyAGf4/eyaiNUo2zZW5jnaEzCIlo1S5/9VANCXeSKu+WDwt5W4xQ7Gj37Hm757+nwNlTMF2fbr/h5qXzIHJLLJbbHBYRsY0Dou3F4ZTv46kXiv4KdSORcwnpaGDKYjEr+KqanRSHYpp4OW1BbZveKLYjzOlZEuaCnud+v9tIHG1CvRTb3D9zwSHo+S1MU6QxHs2TpGPEASVEWDRFH3VWnJg9XMTNCv8mnkpdudcKscMHgAopHzCSUDpd0qpF0aI+EHUodWWcrmpaOOrD0J8rmxf4q48x0hUHP1yUd61RpTEP3nCnHbVgl9wtKxL91FpNxQo0QTjMk5uA74J3A2UxHo4WMLVihg4t9jIA32jdYMu6r45uZwCFh6+WJf
 nrrCuTfx
 q/fHanJAC8vBXTtfsh/utPoZlKXzHX7FP+2YCYsuB2mimeCg6cUy4iA+qCW1+eqFm7j/oC9r7bruCsvhie4M/XtTcdL1ubPC/+95kO/WNAQR6Wt0Tl3WSVaTu346njbASWdnZlOH15KvBHWl0LbtzdlXQCzUlO0aMjbWOHW1mTdyopVWSHmHaTKFaBXfzOK40kvKLi3Wdp4+yCZRS11Gluq9jzqud+c/nAh1qyU90kdh0WpNTf3Tk8SWP9mZmLLUfLt9rilrRCszVKsxAWsrAHGLdtneq5kLCdKIPVCJx92Z0GTsmBDGvBYNntO69LJPHQ4i025tDk0S27u2yGW0XBq6feU2s2wPRxYxFUWF6v7vMLJ/BLL7igeK8kFhxwHFLwg0zqhH3B+qwWFCsSUUwIMLILyBDZiNTVDmCGk6ZPwcHOb43Na4n8FHMDpNUT4ZX29UfeeJ/R38MT4vGl7f1oQYU/J16C7TjI+un4nREzJ7J7fOIQ8uNGZBcyVNxsykTDpNYe8cTK4O3OH7mBMHi6puj4Flto/3dOk11q64Su/uC20uj0otQxWrHDr++FF1wnL0PTaER3p1EENeKvvnoO4Tgv2Cgx/wld3X5i6rcck2atj4nJP/JtguVdrhnC2E0Sf2i9pz2AtdLVokLS0eBcGCzxhbzZvmKn/nk1s4wjUKzxWl/fyDB4Q1oPKkFYT6Po+mX0XKHa1mSbaxB17cL5aWuILyZWxqlbGiFHifI0yKsC6Fu8xValpeeo7xqF0K8PL5OfsO+bznoK4xq1k6LlLcb9dea9XH61CRDX+cQzzRZfv+Tt+YjfKFus05fE5AoqmSGLeJby6k25pxIDttyi736SNGF/nWPralY8kxtPt6f9Vwvw85ZiTamOYWOckaWDR73mjgW7oLW9Dqgti2GlfeBXoke8Jc6v1TfB25wJmU5u0pPLg4CSiSaCu72rFVa1J0Vvp2puDedrkNvkYzyusnncvcJ
 Btgc9nji
 BptUGGm++L0Aok0dZK2sJUNKkIYwXMGOK1Ct/G/esLvIinNR06gWhcVHFdtmAryHpPfAy8CBHH8x8WMvAGKSum8lq9OXjPaFLPV0N219C1R92YphADgK2oTIYoo/5ATSIarc5FsHw7CZZIOiGeJMI/oapIFG9wMexAMIHhmLBTYWnWsj/917PjPjFDv2qsgGt8nVHM9IufoxMJZ4vtG/JL5jUzoXNoCeHWPttp4JQOGa4Y7Rqf7DqlIsWe1xkoMmt85uoftYpijfXZ08noY/4mbR9wME0mSeoWXLY+cXD5+1Y8xkhSGfyRDuE0VTVO3aAka6bEkC3OpJEfXTIOhVKA27x5IyP+1naJZeNW97bKwqPcVIL1B/uG+JFCHpPaxUXh8zGNPlSD8CuQY/FRdQE8/gdEirW7wMG6BCDam5lwWm5EcXb0A6sLNT2q3PDiiHU2n0NeMVYegset2tfzrYAwE8l1eaQ0vpUV0pUA7OSbvC+7LafEPDfmKAWyuryfX0sYFcSqqb/7S8WzSFYuEGY8iKNUs39vJelIAac5pNYX8UB7ihnDlTZo2vTLsRlGCvVD+Ab7j5LfWtfejTzudAwWY/poJfiHU+iBBucA1fJuyhVFLQwHD07uMaMyQhB5eIy6ztJXXI/WOJ0rF2OEUXk5NsZQtAurqCLgJt5uLZ9e5NXWzZZYIMuxmjWDg3lwSHgrztcj+5339snRQ9wyUTwpVI9XWSbNj4kxaJM3ddyVXxNUS35HHOsfyPoOGS2aij/Ka2wsXI0w+oyPqhMEfh4PksbkkcAGKDHlnVaAOMeSVrUSe9PSaZBVqXVXbXLPv0zjzi+R4JPcQqqpfSDONs5+SHIji+92heZ34tUEvXTLtUJf5XyoZB/gpjjy5Y2Q3jQL1lpG/LKbSif8SutL+ksfKw8Nh1Gj0+BPYO5C0soL3oBqXN/tc/DGLqRTzif3Cnc9hjnwu7GEIqRDfCaamcTVqPHRfVr
 2eGh993C
 tNKuAG8CBgyd5LUfpSd0/1NbJirXr7YhkAhP+cV6QYsD0I7k/8umb3BsL0gc+uy7jBFbuDxADcKiQBMFXekV2HkG9j5BGdkDCo/BtB37HOvuwCeaL405rFjKCSd2ejDsth3My8PvBIFzOHKG5Aj3ej2lUG/6KiTLF3QpPvuoBq0w794BaMx3zmZUYZ2Dlevr8wafRFW1+p/d+ind/1A8VfkLIC2yTUqOqvVswrHFPNOfIfIapkr6RZfkkkKueSV4cXUFKAGAS0Lz0K+WLV4UCitMt+bCTKsd8ZB4O051Q3ZOj7iRQXWH6v/qNmplQ1MC6ZSLa0cFgNlZsILniX6e7oL/RGjqfnh47LZd/NpYr1PFpn17qFjTaK8Rh2SA7I/G2GjtfNAUVy6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-03-03 at 12:20 +0100, Jan Kara wrote:
> On Mon 02-03-26 15:23:51, Jeff Layton wrote:
> > Convert ext4 i_ino format strings to use the PRIino format
> > macro in preparation for the widening of i_ino via kino_t.
> >=20
> > In trace events, change __field(ino_t, ...) to __field(u64, ...)
> > and update TP_printk format strings to %llu/%llx to match the
> > widened field type.
> >=20
> > Update local variables and function parameters that hold i_ino
> > values from unsigned long to kino_t.
> >=20
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
>=20
> Two small comments. Otherwise feel free to add:
>=20
> Reviewed-by: Jan Kara <jack@suse.cz>
>=20
> > diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> > index 96ab95167bd6e10ba86e61a60cb0be9fbafe157f..43103816b80ef4901858bcd=
789acb0ffb2612317 100644
> > --- a/fs/ext4/migrate.c
> > +++ b/fs/ext4/migrate.c
> > @@ -455,7 +455,7 @@ int ext4_ext_migrate(struct inode *inode)
> >  	 * log, so disable fast commits for this transaction.
> >  	 */
> >  	ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_MIGRATE, handle);
> > -	goal =3D (((inode->i_ino - 1) / EXT4_INODES_PER_GROUP(inode->i_sb)) *
> > +	goal =3D (div_u64(inode->i_ino - 1, EXT4_INODES_PER_GROUP(inode->i_sb=
)) *
>=20
> Ext4 doesn't support more than 2^32 inodes (due to on-disk format). Thus
> i_ino is always guaranteed to be a number that fits in 32-bits. Thus I'd
> here just type i_ino to (unsigned int) and be done with it like you've do=
ne
> it at other places.
>=20
> ...
>=20

Thanks. Fixed both places. I ended up casting the above to a u32 since
this patchset has given me a stronger affinity for explicit-width
types.

> > @@ -1823,7 +1823,7 @@ TRACE_EVENT(ext4_journal_start_inode,
> >  	TP_ARGS(inode, blocks, rsv_blocks, revoke_creds, type, IP),
> > =20
> >  	TP_STRUCT__entry(
> > -		__field(	unsigned long,	ino		)
> > +		__field(	u64,		ino		)
> >  		__field(	dev_t,		dev		)
> >  		__field(	unsigned long,	ip		)
> >  		__field(	int,		blocks		)
> > @@ -1843,9 +1843,10 @@ TRACE_EVENT(ext4_journal_start_inode,
> >  	),
> > =20
> >  	TP_printk("dev %d,%d blocks %d, rsv_blocks %d, revoke_creds %d,"
> > -		  " type %d, ino %lu, caller %pS", MAJOR(__entry->dev),
> > +		  " type %d, ino %llu, caller %pS", MAJOR(__entry->dev),
> >  		  MINOR(__entry->dev), __entry->blocks, __entry->rsv_blocks,
> > -		  __entry->revoke_creds, __entry->type, __entry->ino,
> > +		  __entry->revoke_creds, __entry->type,
> > +		  (unsigned long long) __entry->ino,
>=20
> Not point in the type cast?
>=20
> 								Honza

--=20
Jeff Layton <jlayton@kernel.org>

