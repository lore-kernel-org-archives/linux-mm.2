Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6560AEB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:47:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8E2F6B0143; Mon,  2 Mar 2026 15:47:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C41AB6B0144; Mon,  2 Mar 2026 15:47:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFD3C6B0145; Mon,  2 Mar 2026 15:47:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9EF086B0143
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:47:33 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6B9681A02CC
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:47:33 +0000 (UTC)
X-FDA: 84502308786.18.A776E08
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C9950C000F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:47:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l537t4QA;
	spf=pass (imf28.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IzVpjA5QHBmrEicfKcrCxgQ+qKrnQ4JXGLmoebkfl+w=;
	b=y0l2qfwDGsJ4sHU8WOc/7YiW4bD/g8FVUo+KsiPjFBBuocOte/350z28+eHeVfpdy6gyyc
	8mXXRFL5tPoah+nN28jAq68ajQQcY/79NmuuWlahcEHZOScoiw/Xlv5TbCFEK5MDx9zgzG
	7vP14hQqP+uS4jnT6xUcpz+MSGZPdWI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l537t4QA;
	spf=pass (imf28.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484451; a=rsa-sha256;
	cv=none;
	b=PRcA5FsIBuEAky4Tk00c7UgKJ/KvQh7QzoXASarjSG+61xcBnzxNrWsLOuFAErXg4Ihl57
	qj70ABCLs3EpfETro2b9ATiXBc3vgiQtaEDfjWB6n97qIAfOf8l6h1WYnQU5C3QB/NJMA2
	aQQPd9vgGmiADCS7mDSJy+reFlvTntA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 13D046111B;
	Mon,  2 Mar 2026 20:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13CAC2BCB3;
	Mon,  2 Mar 2026 20:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484450;
	bh=0FUq3oBHlZbVkcm2IzUt/QSOlhrOWkdnXhWG19OJKNo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=l537t4QAmQuqxHKR5dYe85JUCbHQIh2XEpZ24tx5tQc7Z1RDfwhGxK4FMZXcbvQnq
	 aQ4HM6bLCa/Un9i6wnelpzLWo4dY9m9wOv+CcKQdftNx0/nHie8sNyjfkeMNDxiKEe
	 +a/+PNHGixc1Hi7FnmNMfbMhLA2uZ0Zv04KJE3LT7uivia9qGOIsQUMJEPLYJob5Zk
	 pp6q3elNvMPS9ffgrI8phMvsrlYR1hyXe248YcSkVzjPbGsmjWJ04UEAxhv+RXeQmt
	 rWaurG0VS/6V2pcG/kY8pyLSOgULGMj/BMa0aYE9sV6q8hKqVXU1KovTqqUPf/PYhu
	 iQU6/Gfpkj8vA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:18 -0500
Subject: [PATCH v2 094/110] overlayfs: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-94-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2628; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=0FUq3oBHlZbVkcm2IzUt/QSOlhrOWkdnXhWG19OJKNo=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIJASn3pwzi/JkVT9cf7ITV/RmgrfApAFtpI
 LpkxUcunG2JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyCQAKCRAADmhBGVaC
 FVQHEACatKPlTEQQlB+7HsoaPyVQKa2XKb+wwdq2O/9NWcgaSaCS9gV8r7nX+4Mny3M6JTWcL24
 MPUocZoNadpP40XaT8KG/rh880/xyk3+lQT6GCIL6TL8x2is8hEMcgJB9HBpsmNLt0B4Fs9Pagx
 tfqdViW5TXmnyKIGgmFGl7/4+6Imh+2U+B+wgmzG7qibX1oT4TwJlbu/DOTO7nqqAx3oVrT/iK7
 BYKLIqYRY7OAlOOtwcf7lEtRzB9C76dJ3ZKmQIQ7TBo50rBHh5Tq6IUws7Ne3l32Id0PsycHhdo
 qCfnIqq0ImzKIci2MTphv9mXJzoRjzP93IzaORtagDQ2JLxQrFQ+P33x6id8lDbW0eqnCefuhYs
 PZ07FVi5+JlPYv/3XVl00hOOn90/1zy1dUo1cJi7fn6JU893QmR8YqN91J+GOd6jeTEZ8A8qeop
 J9c5m5+g5mQuc9WstGLo6GeYk7lQJWgW3azzbIBl5ZAsNxjv+f219wJ7bTkGZtnZE7srR2wUpYn
 boaXmlmryyuYUZyFfwkO/OsoO6NHb+tBQJde46hU0iPlWEysiUyCcBQe4qMUIXBiD9RbN+N1V3s
 MdLbZGH1eC6ibbTDrr3FZIXKyyBM+ol7OtycvZ9OWGkq84QSWiki7fglVwFXD3XIv7iKnvACt3b
 SsswaxS3dqCGQzw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: yxyzmsqs77m9ixipyfj6us6itf445nnx
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: C9950C000F
X-HE-Tag: 1772484451-846683
X-HE-Meta: U2FsdGVkX19UBnEupyCXxW/Jb6Cdeva1FTOSFfuVJ6eX/s6XRjhPA+rkmzs2f/KGAtztNMkLdFbcgqRPTtQeNW0mUV6KMjT+uaf64lQHoPR+OOBVddwxRn3xhzqfBFz57O6krwzc1UGKfzvs+d1V6wx5PvC5IJcy4swNcDXzM5yYUWogOW+Hyz4deEAp6VgWHedO9t7jonYOYSc2AsuAcCFstv5FwjPxC5l+7MdQdV3VB7iqCVH8Y647XnlisdcnUc8EYy6qZSXTYsfYZ5JQNxS76Nn/tfp4KcqmmRJF0sZswfCfcWp81qjDAgK5/ZpUJHo7mFLA8RPetje0vhEZk6a8hfVjXKrdYJss5SSz6V45s8IcaQiIlJ/pMfmfgR2kfK8zk5T0/0fbti9vELVkb7NnNXOW669QOfShXkjO2PrDviQK8jAb0HUzHs0BJ7vBjQXJ3lUvIwAulhj9PoPIdqJhthuAostSvp4u0jiZCwSB7ucc/tYuSIbbQ+MzzRuJ6yPbcLaMS9Zj9Dv28bU6fDpnztXUwjLdky4IrGNENZETIz5sbdayTPGJ3+sTEimU2U3Ej7zH/X6UyN2cDpUhTNwKYkAaI7pZmJwuPIQ+sFuDVyBOibqU8DUniUHprZm/68QSt9wLUyOOKyeXwJSmhrU1knIScgOz5vMqUWjGI+NBwwIopSro2jUHam//Y+z21Hhf5r5GhyQpvlL3S08pK3uw9oTWGAnca9FVA08tJuwOMe5HXNo76e2e2zNLUtaSph6N7/dhJl4jwcnHN0bJ89HIkh4U3rmKN4hKSj2WW94jp/HX61Nn2oLGnFumJnKHULC1Kcxz14TEFoldjQl6CUB3gtTUud4IGPjM0EM5ilBRCrhxuW4/ziT1mfonlfsh894sfw2l9eZeJQiValmssHT+e+wvPn9BbHKZX6oMTPtU+QYApMQkuqyPq+rpEWwYY63Bjc1xBX+/aFo/lhX
 azxfSNjR
 oFyBLwyOhR69Pb5NEpli6EzGlX/nC9zpoUHaR/YyekwlUu+H/kVYPVyk4V3Nitk3FLxF/rI7xzup5fwwRNhT4TojZGafHuBmzB8msIjyXJdAR78MQ9g3ruW9rpSAv8TIFLEY7xYW6l7+3aZrOUbgyqwavG8jrLoqGuNEGE0U2elIXdzVyXJeNPAymqc1G4MTMmB9+S2+GcDi7Tc2Nk8UhRhO1MnbsrXjKpEIqK63oENCrDtYM0OheCGOM2tDd6mtjxv9iM89MSYwCg+vuFLlfl+4tUWh0u3qXZ7/kyoGVMD2WsbruK2wFiAVSFigaLjvrQ+uFUDO+oJ7ybXa+oESaemPeDQWDdXi34Zniz81NXnxF5bxNq5NsBzIjxOKR/TEdGt0ppkm60Ea/XOKO7vK8av+rPGVgDLpmDx5Cw7b6/JoFrF7ffPlCwcyYe4uXI5IZDgpaedF8PnOjyHFuG8HNjzgRIUFL6SfWSfGxLuqHK6NXVDSzDI8RXVFonOtUPTb28jAZsQN6bVvspyOgUmo5Mgpcr0BnYhRrXbttcn5mbknbBKuqkku5OHLsf6QB/g3l8OyeOvNIurVNxJUJEp1c3QJiGljdCjvhSbR2PNB/y3w+U+xSZdsRoFaFhZ3TKonk9HP2NH4h6g1JElQmwX3ijRloSU1eUoEQdHYVhG1C6VkoEcU9LeBxFqACr5AuIQGereRCoe2XCK5SrLC+vH/gEtJIFgeC476UpR9TGrhuvlPW13YrAz03IMEU6Nflb7TVSCowu1YWif5aaXKIoZtgU1GKk8olgI5wfAF1pLeHIHqnJ2VdU+HnAwhrO/h3dLp6Fw/GX4eCzbkCHRLpMdpoFGD0YmfaGJYDZrphv6AjKRUL0oiAlGYQSLW8EnFar4GCheQ3thJpGZQSCRP/DU0A/qcEufNBIXiVJ4AEzr4zhaeKblziFdgs4KRJNgpEnuoABOazfXGLJU8foJNLz0hN2+X1QKJe
 d9xY0FJe
 Y1l6DgqMebq4uec0oUKcrxok1PkP6JD0dbvO2+yPFSSueAPyg/3spL2UvaAG1/OdcVa5GHITEKXvhVSV9ylPSyC3fX4htqhUO0z8QLbeZeKHbR7ODfZE2QAJEs4bw+iB8AxfXJyuSAsdY2XjJ/K1sWy4sUyOVO5Ot8hSr+NGyyN7Xn6jswG0/cUiUaTRsCVvI5DZz8hFFIUJNJMz7kSDzcU/0LVkdxZdLs+J61/j2gPOiMfjxdrPlaJ7zVGukn0oytJ2imWGXDt/ogvKJd9CIRBlPLJHLnQ4k5JqpBBr2DNzmvcD8u/UkFRaSniQlu+CnAVwDmxFF/6gqDuStUWUixlXdqT65m4zTF/Z9QBm1GCKYmVJoLV33V3brldfaKme2+QTWOSxYqId6mFO2dlSfXKdtdB5hlKD0qPHeuKVZNvnlVQq+xAq64CkuUcanBYznqelf+EJRBi6X7Bv8ObGBshlPOvj8fbDLc02W36UeDkMJHx/jXoQMseZzymmIH2FBcFloZSc6Yw1ji9zktu4sW6kt+GYTCO6/kGmKgSChnNQ+c93wW6ehTF5/ya6jJArZy/BGnYuBEFMK9bUC7FlV9pNwMxf5ZfFSJhD3XuGxJ3jxbYu6px3gNHMzW//guwZcxfVCCkUelRAZh1o2FCjM/8De19VUI0gyE2ta0m/ShpbtOvpk1WWD6ebrKL6/KWTxCjxH8/3CJftp9MTYT7QUrRS+6HGgqyKhG/0iiy8zHmOtri93mWeuMIXnIxU9UevcjFs/rtWEMmvVz5bLXhYM6ewfsj4v4KGZqDc1w+/qGhrCx+3zoL3xLmTi86KaodaTNf7zqekV7/R+ZpW9OVUd33BakcPnbEzGnGhhgg6ynwWmOsOrlCtdumO7J0cZgxAHOgMPIGnkeIVPQN/TTxJdv/hivnav07dWXv1Gm9t3h5YHjukd6mjuGguAsoetG7FjTU2v7nW3yY61nhQOh9I8NgLHDUzr
 m8+CIcB7
 kNUpLVP93rC5D5ydaE8HH2H+OQS4ogJjspfH2xazI2P2qxP6ls0DbV4HGSBHU3BPOZlZlLAmYisUOg38uOw5UBre49Gf5OTPevdii3Xx4sqvsKem6Lh/x0SYSbGImbb3cz6TENoXNT12kSIjYH37MANkxEmZyUrUu3MszmBYReX0ZW9TLDZo6d+KCbsLU/h/JrdCWAGjpbJrVoGeADUj/W13Jrc+NyzAh5B6RHT7dC0wo9WrlZCrU4G8Jtb/E53FwIa/nFpxoVjAcKAPCJi4nB+3Rkumv8dzaXME20uQb3fgBdTxcYuOcN2+aRifERRsi/rzo2K9sKMXuTszTSV9F7F8Yk5AXmwuWgS+PgmmqG+Ga6pmxv9DECyHJI/iEhIPKkibvw1qU3PujQU4I4TxjDXM1745ohdJ6cqmUIR+rgU8BhLm+a8hgUcTqaWiVuambUUIsF4Mg9NOg4PODl43pVIZfk5wARvNisLSrsaFwIJ9QgD2guPFfgT7Egz7z9u6QHuRdMN/hJ9SVUJg/iMsT5aeXlT7ccWVypCczri7tR5Ml7gkWm1vM+w2/8ZBygdRYou4pB+9GbbguaDClbK9r6MjuLKCQa1ILv55/W+kP4uc5EDjYJSk7fWd0DIZVhmfj1CqibE32+co3W4G0pUKn1mESxOUomDscJPBwqoBsWWIVtjyv4kIlOhoysXqRucIXcur+zTM5dXnkYSmaTJlZUv797FOparI7hexPiJPOhHkntuyxHV5uNlZaFJFqmBDpJGnZznTY7CPzxC6WTZr6aQBmvbh5JfXrzfSyOz5aDVJPjKYwlzS699gCMUsT0Evgfb91fIDpaQhtAOJ6blXGq3LKESGokDt6qVQ+fH/Rq5fU8kh61TAldz9M3LZ90ekwFuA3r/v4ET4k0OJq3I01ltJiy/I01I66RbbIgtuUOafOY0uGLsCBm29ZM1JgOA4GyvY7I0+knfnoOsVYFIMbuKrkbsmu
 xlZN9LPj
 DdpY9YPFvUO2zZKrl/7SJe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in overlayfs with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/overlayfs/export.c | 2 +-
 fs/overlayfs/namei.c  | 4 ++--
 fs/overlayfs/util.c   | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index a17d55db8ebfab7e47f122eade22b96505392b05..0a35d1a20f13fbab5bbee5f271d41f52334a9a6a 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -262,7 +262,7 @@ static int ovl_dentry_to_fid(struct ovl_fs *ofs, struct inode *inode,
 	return err;
 
 fail:
-	pr_warn_ratelimited("failed to encode file handle (ino=%" PRIino "u, err=%i)\n",
+	pr_warn_ratelimited("failed to encode file handle (ino=%llu, err=%i)\n",
 			    inode->i_ino, err);
 	goto out;
 }
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 6cab72d7f70611a83bba433c769323a8954a61d4..ca899fdfaafd21f4bb31807e73883b4978116732 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -591,7 +591,7 @@ int ovl_verify_origin_xattr(struct ovl_fs *ofs, struct dentry *dentry,
 
 fail:
 	inode = d_inode(real);
-	pr_warn_ratelimited("failed to verify %s (%pd2, ino=%" PRIino "u, err=%i)\n",
+	pr_warn_ratelimited("failed to verify %s (%pd2, ino=%llu, err=%i)\n",
 			    is_upper ? "upper" : "origin", real,
 			    inode ? inode->i_ino : 0, err);
 	goto out;
@@ -831,7 +831,7 @@ struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
 			index = NULL;
 			goto out;
 		}
-		pr_warn_ratelimited("failed inode index lookup (ino=%" PRIino "u, key=%.*s, err=%i);\n"
+		pr_warn_ratelimited("failed inode index lookup (ino=%llu, key=%.*s, err=%i);\n"
 				    "overlayfs: mount with '-o index=off' to disable inodes index.\n",
 				    d_inode(origin)->i_ino, name.len, name.name,
 				    err);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 536504e9803e6457fb7d248036263da446569051..2edad9a146486bda5edf47dc60e1645d49af6539 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1092,7 +1092,7 @@ static void ovl_cleanup_index(struct dentry *dentry)
 	got_write = true;
 	inode = d_inode(upperdentry);
 	if (!S_ISDIR(inode->i_mode) && inode->i_nlink != 1) {
-		pr_warn_ratelimited("cleanup linked index (%pd2, ino=%" PRIino "u, nlink=%u)\n",
+		pr_warn_ratelimited("cleanup linked index (%pd2, ino=%llu, nlink=%u)\n",
 				    upperdentry, inode->i_ino, inode->i_nlink);
 		/*
 		 * We either have a bug with persistent union nlink or a lower

-- 
2.53.0


