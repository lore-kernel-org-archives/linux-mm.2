Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 370CEEF8FF8
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:34:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C8D66B009D; Wed,  4 Mar 2026 10:34:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 993D46B009E; Wed,  4 Mar 2026 10:34:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83E4C6B009F; Wed,  4 Mar 2026 10:34:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 71E326B009D
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:34:43 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A3541C53F
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:34:43 +0000 (UTC)
X-FDA: 84508778046.29.08B5A88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 83B3240010
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:34:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="mc46mw/B";
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772638481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hNExWO5p+86UiuTtWE8uYsmY89NdRKCx85BcTgCOIFc=;
	b=Buo6L0bcR+wn7A5Vf16OdfqLXrbEf8e1bGzXuWLJ4QPmFrbzvAcYNBOZ3NRQZ0pjJDgfNf
	kQwYKuiEYZJAzalxUcNpw7aumBNlA42UPf1/leexww/eQIldEk02JWEnG2H33YHi7QIPSd
	BnPoelc2BeGYWNxSQ8wKDtp3qam47/w=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="mc46mw/B";
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772638481; a=rsa-sha256;
	cv=none;
	b=a+mpbeaPpdiGsnpxVS3hLy59VkcJCkuVdpm4LspGy2v7QOkCkycD8ku/91DXYDnx4cxjGK
	wuPosGKmxMQ3AH+3IiZI16ZHMj3wHRSvYqhoBpT8BHog+nZEbcuSiZecIP4FlDIayiZRTC
	b62X7IBBiwqjTeqEV1JOffDm2DIxqAQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E86E961118;
	Wed,  4 Mar 2026 15:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B36EC2BCB9;
	Wed,  4 Mar 2026 15:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772638480;
	bh=gH1WXaX89lbCa6LoLK51lVOTaxfcobnfP6+M1HuLkEE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=mc46mw/B1jY+pQp8R0Rj+usepAe1eI9mDsy+9qt1QZF9gBQdGVzgBqhKHDkzyJsp4
	 vdAtvZOzlpUfC/IKv6uirJtq+T+RHk7uxblWDiwt8oB6irxOvau6lTOB8kovME+Y1j
	 SGNsxCfq5U/2sl4h+Rxyh9lZfqO6qLf0UZYOWqZVbOC3fSS9NZkcHPL9yr7SXTYv34
	 QoWUW45Rj2A1nPr1bFWk3JApK6dAHyrli4qgX797CQYrmqL3EAW7ZmkPD/Bsg5RzH7
	 Br+2826TQVrL/PJgameHZgozwjRL7zAbvGTMKPx63Sai28t8pJy7kVsFFInWpZ1Ciw
	 BdJs6NLNCgfzg==
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 04 Mar 2026 10:32:36 -0500
Subject: [PATCH v3 06/12] ext2: widen trace event i_ino fields to u64
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260304-iino-u64-v3-6-2257ad83d372@kernel.org>
References: <20260304-iino-u64-v3-0-2257ad83d372@kernel.org>
In-Reply-To: <20260304-iino-u64-v3-0-2257ad83d372@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Steven Rostedt <rostedt@goodmis.org>, 
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1754; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=gH1WXaX89lbCa6LoLK51lVOTaxfcobnfP6+M1HuLkEE=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpqFCoU42QY7BFmYavQKhvSkNYQt1wEjITKT64C
 vKB17ftoaeJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaahQqAAKCRAADmhBGVaC
 FUPAEACTHjEAS9zyh033TfOK19JlWfr2235vgLgjJ5IoSdSezHfCrBB4xIdLYMguCJGg4c5oB+U
 dWXegN72pS8i22ysFFfeZzdnglQ2trkZ5JoZZGMg7905hYV4W3JzSwdraU6uDUEEBJST/1SwH/y
 NZd4KvEZ23wirDvPD3eD++pmXDJpRH4Hje5+lVTIWkFO5f8MX9VknyXx23QQ1RMWktVxrPlwvYS
 uoCZtuMRnvoSTz1Urcg5ENrHv8o3mY0o6HhMoN9DwEU6oVxheH/wG+AAwBwngMxgtw+isUaAfaq
 H0wBDztT+6KXA4a/QsAItc81hr7N2NuNMkEDtPuhvDMWoKhoTJmVRaPzWt20gZqzxJ/ypDiNScv
 b6t0liqFv7yho/63zBjTpQWx4tzpiu9Urw4O8omJxJw8tbr5dAzARhThNjvFMmEP13ktfdd9OwJ
 Ci+35m63KwuFZ143EY7aiTkF1QIXcz4qrX7K7IS9ErJu8dKXRlyFX8tYcInAk5cJkCkwOcuL/n8
 XibyFbd94h778radvAyhptGYKr9BqaJ2VNyqmYNeU3XN5qbkMtjJzRq2kaBmbaqWoFEd5f1UpMf
 thoXSS5Sa0iSYG1BmF9evBWMlSp9W7mV/zFFzduc/Nc9/j4Tg+HBSe/Gh8nNjK14te032BQ5XRj
 xJe3TwL1RMFqxsg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: 83B3240010
X-Stat-Signature: hnusxiuref6cpks3p8313639c19qsjj8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772638481-397614
X-HE-Meta: U2FsdGVkX1+j0zJl2q0LBFjwU8HOnvw6Hf3wCrl2p9JYvxP0XotPD0AjLuwtVCm3NmrsdWwk3NH/tmiwa8i18zVtufkcqrFuVhhseWDTbL44AaQtzfWAzLh++53kh8cIliUDX6ovEFyEr3wPKw9qMCWlneiNTqCCs0APCyuLuHUA4aM1XTcJZEBsbBHQOFNkWimykdBq8vspMgNeU3ZmySnWkd5pV870gCR6h/FdeOjXreVfykvvmX5hRqce4p9FKow9/3nu8FjVhGqiRDgpQHzJLbqrumVJMAAhLQDedvjn5RuHW43uLg65nUbirtzwcAry++d1Nu6sf0thzizo1TP0e2+iPZhzrXu0pCjIBJ65talKq3oZ0f4fsrGIOZ4b2FxOcRztuDLIlW5LkEXuYvex3Lp3ARxzdI+mGG0b4DmsBb/P/nYRahHlYSHLuGKPsPByVJruDHxyOE0yDD0iYcm+8RYi2q5+SB/B5uHBz1Aipm7xTKTRJpqOHBeZcAsZjyFUImPlk60WVq/QjKRa1E+GDuKzhMaGSLwFOa1MzJqQJ+4AzzjtR2SATXyYNtxdsqu5A2sF4GgO23F8Efj2BGzeOXgg8+lTA7csy1jtyc/9kh9gOsBTxXxXgG7kazq8XbTuEHk9DMCmo2btSGTNyQvle3f/FuFCQZgqyBp5fPhXgC1zSd2BqPoZJJjhVT8YkuEoRQ7l4nthSiTWxEkUKIrhMHbbOb34I5gRX3Xc6//AI7c60Akw4sy8XTaD79fsFRNpruVN8ycBbi9msIKaCfqtTwSVQ4Gdt80ElT4N7QM7lK7+EfkRzmTjFxH7YXJqqt3Eh/Lxg+6VT9hWFq+P5ZkKFzl/9cW5USOq/RiK+mJCEwB1643onfLN+cbY4E1wSWO49BqdzYdCjDOfLgWeyqOeGQ+KGml6A1UjacnteOQ897wgIKYyy9MTrZg2eP5//cmbbJyo1oEVay0GN8e
 uOzOyV5Z
 ZF8oKrq0VOFJawFYv6sLY5eFYojo8X8y0hD7J+eIkojfRfnfZtskDkhwXRn2e0Frk+Gfu9BoIbnFwXfeIKtOFBLNcBvSlPmI0U0XiRXZL/+LF2ZiyDlOXInVLET53Pq/tDG3DncE/rah+5XX1xTmLhkNEFLaQgf7hrhadTSulKljUK5G6FyEpbrIxtcGy7Zgy0JVWgufR2AhRB7cdy3wspG+b4r6kjJiCB8jWMj/EvdPBM1bskwmArvG8LnlnQRGfFauslOMFsN/njPURfn1VNGU7eefURtyI1a6w5K7RKahWfLLu3U4yO3DEHXDMQsFmuf5BlFh7Ca5zsMXlCwqDG36ARGLxnopuaSrUw+2teYRstzgiFVrNT7XQV0jUFdzxW0m9ecr3hCCmLosaZ6e6zvu/RGe38KcAm7sxQ9OjwRa1+32BgQ8lu6AULrVv9ushZbtFbYfbFuy/xNCPafiXs4iOzzCwFN39xJBfi6HU3fwy8tn9tvdd2OM2CUPyKhZ41c/mNkO7meiUgAv+NFFbajQSU6tFbaVy2DwCS0JzEwt603EcOnF4RwTMjeyQmGUq/x42MOQF1XUUmxsSUZMWTWzeK+LAB6VaDZM87ozvA0hWDq9eKVjywh+lzPzRyyWWEqHfl/64ZM2EdwkWr6z7mM3ztnc0B+ZvYLYpr8QMrD1i5nzFdW1zmFNN6hKPSHuxrIchoNej/dOwnrly28PeZp27Sm1EtIm+yqjkSFobLOahmPouBejiSPtLBABWJuW6EB/RvTDSXDXI8x7w4VVGRp8z1+IhYf1htMVrfHxtvxe0ZxcRe2DKZEvc4V+5eCvN35A1ekiYv+tFzkGB+eSXWTcruHzpufkA4/+Nczg13N/CpqP55CWZj2yBeI1ie5uSiA9G1wRpq83v9O7jcOtbYYao/I+RnqeoixCgwY+TqyiOImRBZjJvRnsMIwLY1laNrwVlTyxAEzAGDiQ+scisu+Q5xmYI
 OJH6BVe9
 Mf8bOCVL2fDTa6zcG4lvPPaA/+V62P85Mt+WFsXTofaPTeQL2NhUrVgJkkCzXf9xmyINpPQ+e0q19IoA5oNi0yJSuqKNCsGowA/Du18oDAureYAq/aDSF9rM8D7gW+Q5A9a/obl8lkfHbZPl/iGyociA99q7Bgsyie4iYg4qgC+eJEzlfD0/UzzQ4H1Mva2j14RahHca+WaAzK8hxEOHkLX40FnJRUwPB8eCfg8hhd3t1YE7H9wkh3GL8DMZLPpLxkCI9n1EM27yCpJrvBQ8IVN/gzNbCgw1eEc1YBgAtISZ9GQRI649smOO9tEyr8CxX6guaBFkS94JzxUYelGd655ylIoBz5+4nyO5KEm3n4y1o+h5xWFFcdxB64hu1ZDfm+kW7+O0xj8+1RIbVJDcViIJMkJld36eYB9JPelGSSGIjLM0Y9JhkcQSnmgJZ0+fCp60IaVJ0ZYbcsc4CKO+4y1c7McHVoWaLyyMsenjJ2pyPxLMnseZXHhrNNsSa8mm0xxGIBTCFPhPU9I84QQryf4I7U4xJxrjQ3c3eVMTd7lo2PPyhaKZzoN88ZthlIHr/AKWjAl0rh/m4Eh97zVIkuJh2T8U2mwi/bIWLoxxhFU+8DXVxmPUqcxUlvIoxA6RA+6XeQpdOXmEKt1Q0HWanilPWs+PdZIWFYg5aQ8xNCvzpoDxEU63QBe4+wjwwh0R2Iz2xUtbHgOCjsw4HdkcTHxkUu2eKEYQZ4MTAzRfGmJxpOmr/Xcs5IFK1YiciqzNjVlPCpAQG6CTP35nzyMPqjqsJjhrDbwU39W2rKgY/LhMXQKexztnX8yyFxjmA4Icx4957l2hRPMa50Mb0Go2w3nSHQG/UV3CxJhosdPKDQpYe3KKQirnLBzpZ/zeH0FuHf3w1mXCl/I8oCR1jAfiGaU43Cn7163Iq8IjenRi82kPJnV27X65osqcEq6YtuColP29Gbclvrc9lE+rOq3h/Pni7F8+S
 q8VETAXH
 +tljoTskDmLH4mh4Sf5cqDn5QtBOqx3i+ofIj4ncy8vmYtLUAj/Ot10x/yjDzi6zGQDprU2/EhgEe6SGOhVFIlRvGCIOU1OfNXS6i5MWWBcdccSgWRRB+BuYK9mjQ9sXM9SLmETLhVMDm/eq7VEWCyDYpeFTjCmbkO79C0DwCO1sLev6MPoM823cLTdRrQRztZvpYWM6Wb9QhNgF3Q6yY0dgr9lwUDKL786x80rrRrdzJcg2NuCS+gtyZjOKmO8r4QBr2SFDdXmT3M9sKoulDbZJPrBZ1xuXaY4huXxUeq3G2SI6oFJ+5GnOQsKKpqpRP0GLQi7v7lVSkFmXWEE8ikCCpMuYfp3mfklBhGnNY96cbtN9HGYBeI5W+mo/cx9jblrLuwprWb56xFai9ObNjTEQbw2kalp5AzlPYDseCjV77OtaT4icT+oxUapbA+3erHZWB6E86uIRFsWGF7VKxMMcOJHMTVqPNf8sTJZTRubzE0679j0zIrpeOMlNEfaVCmk9IDLH/xvA9mCPVYxhRBbgFLvPhCP8OCxMI6+pEB8bhxoRVjG0NgNbEbdIQq4trJtIUoEfCCgkNciXZobmPdvxAHKdUjioV4A+yGXijKhOkU9Q1o4sr384H7Q2xwg6PABz89McmCMhCqZjeX5dvyyscu4GQoQuMV4lo0MBfKI+cgbehrKTrVinhBXhbfZIvH87kzscXlHtRocjUwqeYvDMP1Pb97V+To8kyQietibvlXFRDWJD9caYmu6Gh5fWb5cgfp8KjMe1d5s4z6rUDNuS4s7H2km71nqz5S0RUyyA/pbWUvZYB369xvAcfd5BRMScz27eEGC+AjbzqBI5kF2rIRWXTRybs5X5eaODimWCnLGxFPms8RShPbia3iTQAkmuW1DX0OUcgwIBKPGd4+ViOTC+M8bvnfVZ46lh57DNfPkoOMsDMYdH4Zja+tJuuNBfDjqEKam+bJPq5pz40UF1nGDyp
 lw8rOInT
 ApZ4H2sdeFLx8imoNx+IUleE0hgXCgHqYZRX3uQV0g71G/qAFE/LiSKOG2pvgo6SzTh9bFMDgxqDr5SsKILkM7Cm4629UrMPu+ctPccuTCWJ6bZGzdmg2hhIYX7uxtxtbAOWaN2S00atDyGHZs7mWnRfZR3ZzUHFDWMPz1IQhRn9A6xg5AKkpa+bEo7NxrPWsBvrYYJLrS28nmRkra4EgKYmW6bwJbX/65Wnq2srF+p/iWFlPRMbSHAmAumVXiM6cX6IyQ7OMPLr3X09E87jRy/3KSitQCDHAjhcklg5oHFtpJrKJPTaN+OXX5aE9kyAoeoFETnRCkrjbEkoHWXKd+GkRgY6KzyXQ4D3fMclIm4cPSrAFmpahzBq4kPdajly/DEXomGqaivaHdivV/vsM+MB99lU4EF4I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update ext2 trace event definitions to use u64 instead of
ino_t/unsigned long for inode number fields.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ext2/trace.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/trace.h b/fs/ext2/trace.h
index 7d230e13576e78713846248eeb21fa0770130540..0922c0e6aab8531c9f5646d86758e6e3595754db 100644
--- a/fs/ext2/trace.h
+++ b/fs/ext2/trace.h
@@ -13,7 +13,7 @@ DECLARE_EVENT_CLASS(ext2_dio_class,
 	TP_ARGS(iocb, iter, ret),
 	TP_STRUCT__entry(
 		__field(dev_t,	dev)
-		__field(ino_t,	ino)
+		__field(u64,	ino)
 		__field(loff_t, isize)
 		__field(loff_t, pos)
 		__field(size_t,	count)
@@ -31,7 +31,7 @@ DECLARE_EVENT_CLASS(ext2_dio_class,
 		__entry->aio = !is_sync_kiocb(iocb);
 		__entry->ret = ret;
 	),
-	TP_printk("dev %d:%d ino 0x%lx isize 0x%llx pos 0x%llx len %zu flags %s aio %d ret %zd",
+	TP_printk("dev %d:%d ino 0x%llx isize 0x%llx pos 0x%llx len %zu flags %s aio %d ret %zd",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->isize,
@@ -57,7 +57,7 @@ TRACE_EVENT(ext2_dio_write_endio,
 	TP_ARGS(iocb, size, ret),
 	TP_STRUCT__entry(
 		__field(dev_t,	dev)
-		__field(ino_t,	ino)
+		__field(u64,	ino)
 		__field(loff_t, isize)
 		__field(loff_t, pos)
 		__field(ssize_t, size)
@@ -75,7 +75,7 @@ TRACE_EVENT(ext2_dio_write_endio,
 		__entry->aio = !is_sync_kiocb(iocb);
 		__entry->ret = ret;
 	),
-	TP_printk("dev %d:%d ino 0x%lx isize 0x%llx pos 0x%llx len %zd flags %s aio %d ret %d",
+	TP_printk("dev %d:%d ino 0x%llx isize 0x%llx pos 0x%llx len %zd flags %s aio %d ret %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->isize,

-- 
2.53.0


