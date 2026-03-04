Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD670EFCE4C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 21:41:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 043E36B0005; Wed,  4 Mar 2026 16:41:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F34116B0088; Wed,  4 Mar 2026 16:41:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E15736B0089; Wed,  4 Mar 2026 16:41:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CEF166B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:41:51 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6A36E1A01DE
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 21:41:51 +0000 (UTC)
X-FDA: 84509703222.28.B2C5331
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 964E640008
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 21:41:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WOy+ahU5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772660509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TLTH+Ki/JacgTwtIUmmUFQbLVRipNqt8GAWnhOqX5uU=;
	b=YXqtE5dYJTUr87fr9Kspg9ntW+zWhUTkHGQklO51ZHiwgfOp0pLmRcLLOtoS9VkHquYc56
	soBKZkKaMM4cISKU1ODlchVKSv8vKuS0i//hSbRR7aU+2FI6xX7cz0GQgKfi8mJBzM1W3z
	45MnafAkykzR8c0ww6BsBWAmZZ7pptw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772660509; a=rsa-sha256;
	cv=none;
	b=3ai1AfOE5ydj6uGTcm8bP2Jmmj9K6UBvXudh6tvjt3wjG15JWQSuLdwymJ6dyeczNyoJ3t
	smp4e3zfc7qZ0i6jtrvhEGOBkh4nTTXI0Wn/L5f/vZNlKedrybXNouNQd+S1vt8QzZ+T9f
	ff9OEpluFJWJ9gpt3lGHFHKrxkIN1xw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WOy+ahU5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D16CC432D4;
	Wed,  4 Mar 2026 21:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDDDC4CEF7;
	Wed,  4 Mar 2026 21:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772660507;
	bh=PV67OS/91fsa6EbIf+u5pJQmbMnqcMaw7mOqQaMZtc4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WOy+ahU5UARQ0yTbDyVVAn1fSlv8RpYZwjPT+Gigf4F6vtlQM47BUEAaHpPl28jTi
	 zijTiFmnsokrQhTEwusFFZyPjXjLpzptmexKVrqiO7zalnrs6jCk/4Dtvo7p2Wi1b1
	 deFntjfjHaMPD1GtY9aIYLocTQHgNd9upu9na/Ju2G9Ir6nNYqwGJRWtco86cB0/5r
	 uO2UQtHfq4CG7HDfigIocItuDJOTEaZae9H5bHTqKAx9IDkUJuakGJN2s0X8q9pydZ
	 YUjxavtU51Dm29ViV1Ch1zVWrQIQ2z11hjkuPtHX/LzHUzaMqMA8RcsW3Ko5J8lxOB
	 JCi7YwgNkSxnQ==
Message-ID: <d5ef252a-02db-42d1-8ffa-1769189ae60a@kernel.org>
Date: Thu, 5 Mar 2026 06:41:21 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/12] treewide: change inode->i_ino from unsigned long
 to u64
To: Jeff Layton <jlayton@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Dan Williams <dan.j.williams@intel.com>, Eric Biggers <ebiggers@kernel.org>,
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
 Shyam Prasad N <sprasad@microsoft.com>, Bharath SM
 <bharathsm@microsoft.com>, Alexander Aring <alex.aring@gmail.com>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>,
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
 Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall
 <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>,
 Zhihao Cheng <chengzhihao1@huawei.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <jth@kernel.org>,
 John Johansen <john.johansen@canonical.com>, Paul Moore
 <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>,
 Roberto Sassu <roberto.sassu@huawei.com>,
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>,
 Casey Schaufler <casey@schaufler-ca.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Sumit Semwal <sumit.semwal@linaro.org>, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S. Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, "Darrick J. Wong" <djwong@kernel.org>,
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
 Xin Long <lucien.xin@gmail.com>, Magnus Karlsson
 <magnus.karlsson@intel.com>,
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
 linux-sctp@vger.kernel.org, bpf@vger.kernel.org
References: <20260304-iino-u64-v3-0-2257ad83d372@kernel.org>
 <20260304-iino-u64-v3-12-2257ad83d372@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260304-iino-u64-v3-12-2257ad83d372@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 964E640008
X-Stat-Signature: phpk9bez8guouoc8drbufr55wum9kohw
X-Rspam-User: 
X-HE-Tag: 1772660509-297323
X-HE-Meta: U2FsdGVkX1/+a6DqA+SMDighf4PhTollhAJ0gkN5gpyas+knPKy+V61KCZFzj5d+4QXse07olbP5NHLtsIF7+jBy/+KmdCzAXyy1+msyF5KYrZMTbzVGh2vEG3foDByESEbVqLB/clqGrKhJ++ZDWjraiXJOZ2K+ka2uYtWX/8sgpLykVFm+W4z+qG3CCFlhGrwHMPk5TL6P+od590KwqMunTR4CNPW8E3kmQgAv1DzlyTZitXoiHobohdWEPheGMF/2nyvOm0I5L7lh6Vf5sKCx6dB3wXV/m3+w51jb95AQOgYutNzXHubiogu7vDi20eI4sJuDydcxgQeQXzJCkQiOkVlNlyEpsPIwphg4ZE/2+937FggNllDM5/27sfwefz/YSeJYTC9VHOpi62142gpOVy3U4yKC1tRhDXUg3L8iA8UfDl8JUZLBQ12PSvfYDQLU/zXKQDHfwgWCBTmlGTUhaF/cVO1V7zjczzguuKTOaUmaOjQV+Dsr+RCdLu+639JMBQFJjZXYnu57mXiDo0g7yD/vAJSwUJFIheEIeL7Bx8Dl1R/YrQ6Ie+GLQZkx0cWJd9KWqFF0cBoszl4b0J7sWWMpvjQHhZpxln+9LuL7wQgt/s+unjEhi1Ux3VRSRuvnwFEFRHagSZxBwpqHDM/2TbwdAHzt+Aq+MlAWa+TK58ABz9c+mCFkim89LaMAwq3aOFNa5YBHWYcFXpQ8YqF0r9Wg4lNJYoRGcRZ71oSpSSh5lmMd7RhWaMqmTt2R6jXpLCLSnvWVxjcT+Z/FfU9/VUylJP9hd5o+yCyMgW5FRRcTI0D6DozYdJglk+5+j3g+vGasoMatFPqMqXEsfwHiovBTdigoYo5couKug2hzVn/a+mhdXL65NL/mckj0JXDg3SutSLZqcb+9Eh5F8A5V3oXKhLwr1Qh7ohpASuB16s9vnZz1TRJh89qM4+kbsbpJ3JevI26I/kqbp3v
 DdHg0/NQ
 D5BdQre9XLdiUCQZfNe3Wn+Dw8mN//thS7MifbFJ+1HsF6z37hAx8VIcITiImQjvRAbJNZ0xqs11ghbSAYNSgGWRhXf8bkZm7ptnFeRoLcqIY9UdPM0kWskS4Vt24VrJSb3pXM6WtSTXR2bk8obheQgoZtm16vXwOklLmttvv1xTHQv9rTScoGDiiCTZPh4qWve8wg7Sk2Aa1FlNmUEK77WQ0+xquVKblA31AWsZVYyr4iIz6ta+WpIe7prgMPdY4i3tOgmTWkAxqJ1PQdPKtTWJV8/pwO1M3+w5m+OoUKvNv9mKQIIIcACd+uFppGfffz6ZY4FXRdoMneE2pQ9U17K3vxtzAvRDndKAbD4MSABFkKJJe8KfNaAR2MdHPZZu8jrzjmHTe0UQeWPeCYFyAv0IuvjSiEFE+b7d6+9SfSFgEtyeFhy8NepnljgsThEYb4//GPNtrwakYRm/v6orCK9s9VaQFUp8zjsGdyW1i5OJ9hprRw+F2BaHXaZ57Nt+LgbMJ5lP5Q370YaZoxmElmEGLP7JjJ2jHC+YGRiE/sjuQ+rDbrfA41a8Oc9BB/df6um10vZxu8N6i226WlIIMpInPAF1w+eYPMsOzCqyoCa1+UGJmxTQ0oeCBwA9DnBA+I9x0J9oXLhdPUbCaPAySkyF2E6C93z2TRUBfPkXxdgiiI0tEgLlAIAsk9yrzE2UpnuWfwsi+IBT78FHqIgnQrVxg4rljKVJY39POuEKxm7pmouDYPYq0oISW/V1E8Wx++eD9KJRtsaEc5fHqL7NXN45LCp+rytimYd0uUXymAyehKpn6QmisYyCj50dQzp/VEurRD9gX9NkZj9cmHf+TEYRGjzV8MEYZbO0kSoDpdYHTgTXGs1ue1MdEPOuUs/vad/oLIEre0otPsi25H5rYZmhmEjCj5iLVSxboXjiF6iWxwxifBBRxKgwKaTWw6ozN2eTbgaqtaddy9QkSNKhfaEJVwucV
 zLqoe+Kp
 +0++/rrbJ5uR/WCRWqZK+Y/EeUOoz/Q00yZv0devL8BmNQ7kgGAEboIqBTLfFQksaVSG9uAmnivvU0B4tndfO/A6H4+ZmNiF42LPkW/r52rY4cJkClLBa/0qJLNf4GqQAmmWBPeTBIpuL2Gm1T/cd0I+BnEBJAZxJmifjywT36fnCxMRhCigJF7DDkr2MOhHw99H8puuEfPMy103QIff9k8bi8z1jnEWj12WeTmCVfKhWDRbpqBzbhbieXxQQOYGY034q37NAKmht6faqgsoVdBSyO7tPSFo5uBClChL0zuEKzhC4y+Uf/dTj4oVb2YrgFCLk7gTzVmcQs+wHaFyqzK5enJ0KEaNLAT1+e4mmESeFsPFXodXxnRemTh6lWM9siN8C1ebXJJXpb6PmxfLnnEjcDR8qD5AyxNx3QI+HSAc1wddC2+KfSW11YcClPeT7kA7Q2iqKjffDCtZoYwYRxFRcwhQhhApUcxVtrkymD48h6rff4OppKqaczv1D1cKZe5eG4PD5klsUXY/HhgA5YbCRB0oHhGN6v8xXOGmKy52IOC1YDbI36KWXbZTGDlbkrvYTnCvk63TVJb4S39Dy3SXmMoRvTAnQYN4STmV8Y/gu0VjjPh6LQyjBi1VtJph+ijbLnZFpVyYEUNYcOSUfiOeVW6Fmx0B5xowriND8+8BCcvLZSNrkVoWYofGNMcdo79cB/XnBlTXaECyzMHi2TJ89ylcF90Gj6DpWK2yVHjC8a/SkTMmMIzxgd6tpgKEPGef0xjhBxtue3N/rnK3BcCNCxdmzOR+jaxOn/8Srrc0jb7RtIBXaclCR4Odd1Kp9PVg6aUsZAzIxFL8pMhJl40WLSdAIc2MPk3lsof8SWZAjQ2m+W5CPP68Aq8errpCsywOe6f97fN94/73asLwTFNMG+k9f5DasksldfxXAJU1k5vdaClnrZJQ7vpmR2lK1gRMKQ469zTLxY7lOAkc6kJV5p0ea
 HbSemXVV
 jGGZMTnNcYYYos9RF5Vr7DoVyjrr2P3UtUpBZLF1v4OfHbFDW24JVLsDeQRflbhwsk5bUOpUr/Z7eUy3c1ExvebDuR/U/EOZevDNDJno/ZPuIjMRbaCdZHKNRkxuqerAwt1SouTpMm9G0UX/XHSwo32ftMp+j94FrJDp7DyKJk1aLg9WdFwFweY4rCc8twZi23FBYVg9hhMvGBj1E478CVowKNVXVFuCU+iSBKqZdqE+/NGE7DmpHWjG11MhkGJeViEvwnn7OZ3NiR6/44k5hdHzlAQAeKC1tasUgNL6VAh3Dhg0vnn/NPWgiBs14/ZSDhNR0UEzDc4cDTNGYNS7fJeEz4efaSUdPIG8iosAwBo5AQhmGVN7dUAi7jNR3JFOq2420nfGnh+xMqdOt3kCeIbeVXxYANBAM/LAjQX/5M2TaZpoxC/w7WQsI+xccVYWBA4C+YTfSkkeYduu/R+t9ltMrd9Y2md2Nx7Gp5+DprNf/0jvC4ZB7tKqaFGc3SH7aQJiJQ7+HRlE02a/ZvvOJypztpAyK33bb3RNb8KlD5zY3uQzPcnZ9QWjWXNhZJPnzOC9mGkxVau1nx5fcMyePzXkxpdxepx3G0aLzimS+Md8mQZ/HHrNj4D8oakiX8T0sHmTm/4s22nPVpBceC6g8WgS8Z5VeiNvhtIBKvG3uDtFVSPTr8HboTwajIIBCIILoqqm/7ZTDFPaBz0+DDu9fFBMWDnm4kzTMuLzB6drSc5zx4Lz+9oljNVZE2r8rg0Ztdi9yw/6v8HvpyM5u+cp1TcvU/9KXUpOoIWbFqbdkcSejd6jxFWm4k09eTnlCbSwEPv+EV2+wbfhpSnzVBmRmc82lnZMAsPl4P5dEbj5a7ZZIQKPvO+beQNhpZl0s4WwWECgYNmBrozutmjM+sDkWkRYEfcWponFTgNR/hC0/OU5wtX+CvFrPSSTDYeQ50et/D0nxE2IUfvyqJ2wj3oP9r4+UdCnV
 EFisKONi
 6PdxOeRmbxy7tp8Zi/b+srB/hGiQ8UYRKPlYwGwAcp4RKFoUDXU2XURh3kWnmhofgoFCZU9wTG9oQtGgM0c5kjV+5ZHTdObfVrjfkFqWZ1ldbYLF3qPoyGa0Aj+aLVITvo63teO8G9UUBjznPQCDRXsSXMOH2yAeERZhcO1IofsFstvCA0/sobepkqvBOk5ndH51lv4w39EF9drlStIlMER0jbHRtcwlWDEZZWSPX4wwAEEpNzRPz/63MsA2UmckqtaITbicAqfGfV2LVEfM4EvwtFbGG/wo62924ahghQg2C9eOxEA+WUr8eR1TvxUUYFCxOVa6L1Ie5yaCgOVsrJnLRP9cPcDOnGpl8KD8UcdI7qyn9+RRXDEyBXCbEKNAG4qCG5trQ7UL7PtZ7vcoq7T8SPSlIVTY6A/adA8ad1wvKFu2dkfRu1So0EdE2SjdZ4rvvmNMa40Oy0vi/yoxSZ9585RJx4GGF99g/RgKs7Sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/5/26 00:32, Jeff Layton wrote:
> On 32-bit architectures, unsigned long is only 32 bits wide, which
> causes 64-bit inode numbers to be silently truncated. Several
> filesystems (NFS, XFS, BTRFS, etc.) can generate inode numbers that
> exceed 32 bits, and this truncation can lead to inode number collisions
> and other subtle bugs on 32-bit systems.
> 
> Change the type of inode->i_ino from unsigned long to u64 to ensure that
> inode numbers are always represented as 64-bit values regardless of
> architecture. Update all format specifiers treewide from %lu/%lx to
> %llu/%llx to match the new type, along with corresponding local variable
> types.
> 
> This is the bulk treewide conversion. Earlier patches in this series
> handled trace events separately to allow trace field reordering for
> better struct packing on 32-bit.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

For the zonefs bits:

Acked-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

