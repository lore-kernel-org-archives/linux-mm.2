Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 524D2FD8FD0
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 15:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE3C86B00F1; Thu, 26 Feb 2026 10:59:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A96FE6B00F3; Thu, 26 Feb 2026 10:59:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9833B6B00F4; Thu, 26 Feb 2026 10:59:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80ABB6B00F1
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:59:41 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 350468AF65
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:59:41 +0000 (UTC)
X-FDA: 84487068162.01.E4ECDDE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4FBD81C000A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:59:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IX2sqEs0;
	spf=pass (imf18.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jL6Js5c8rUUfcGa01Q5Y8z0DGpVh/qcezUje0iP07qU=;
	b=AEvzGAziGFsfdzkLNkJiubTLDnKtqbSquSQB7iRZwq9pIOEays/wDgvGoDR8boNL+lRFnK
	e4dgnSwoMMg+NYfJkDCxq+OmeP7eUntEvIQ4wEGiRXRIvP1sU1N1yDZlWE4XnBMBCAYjEn
	5UNjAea2xYJoyBYr6pi/clRRepxQHic=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IX2sqEs0;
	spf=pass (imf18.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121579; a=rsa-sha256;
	cv=none;
	b=EjgI/8yrU+u4RZUlCWYPJmk/5uY9iJ/+ipWLPb5n62XIiW+fH7D3MpmCMMY8/hlFXVq72r
	qP1lr+9QoMiI/VYmzdlUSOasEBNyq5F2Drpku7y74e8F1PCsjuKY0OoFyu5Vs2BsElUfjw
	Z3kHBE8vRQeX6wCj2RfI6j5Si8KluD4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 74FCF43E85;
	Thu, 26 Feb 2026 15:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBD8C116C6;
	Thu, 26 Feb 2026 15:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121578;
	bh=ThZbEdE3fPtaNvZtxaKlshpGf4FAsWPlvcoxqlVwDyM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=IX2sqEs0O6na6HJTocJskWpMYuHFfQV8vUqhJnqj2Y8zBnHbLKufy+/Xl0cocKdwI
	 SZTOTJbwYkTz/dDjSF6zX+KhvivpLyajtGTkOfuUg5wnarmiCkmBgFFIXG8PBYfmt7
	 Esbx22XwmFb6InsAawDLtovAny0MJIPFwK8QE53pIcbO1XmaSkreEphNK+o2r6ML0U
	 E3m38IUPPc8olwFy10dVyHFSslFtH3sv6/vtlA0AED3tFl2ElsIxtzkKBV55HK3A6y
	 r1wT6n+54mF7+J0PaPg8SgdUY+cy8drwiBiMO6Q9htgUeiNhuaNJsFHKFGh3yCdgyv
	 U7ij5otTQQpFw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:18 -0500
Subject: [PATCH 16/61] proc: update /proc/PID/maps for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-16-ccceff366db9@kernel.org>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
In-Reply-To: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
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
 Martin Schiller <ms@dev.tdt.de>
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
 linux-x25@vger.kernel.org, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1805; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=ThZbEdE3fPtaNvZtxaKlshpGf4FAsWPlvcoxqlVwDyM=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0ITSPuDdR9Gj/ig3ZtcRQGCHeH8mI0/2qy7
 PsZ/MjzRK6JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtCAAKCRAADmhBGVaC
 FQN4D/9u3DKuuUXkp5KUC0TUDHURuhUhUrh0shsxfkBNauCalAPfBUCQWocWndKNnQFHUWA/f9D
 5mhKW+CC/8BKE/xHqDiDMKidjthZUU7Bl/tpVDRmJrL4PIdyLKj3OvGX7xoKH8qNJEWQQvB4olD
 MhhLcHPdrpX1fJVLou4zxDF4zNZSkNu00eO6FMKJ+Uctq7lroPKIIEk91a3VIZhj2V9SzT8oI0G
 jk+sfvrI82HE7l7D1K1H9uf410MjvGRpblEFJgoswRQYwZz3W/lCu3ygduWQgEV7itgi9kp3Jyj
 so/2UCNbZgyw3hqlvGjsSizBOu1/Q4yayK/Jt20hokTkODtyEimtoYYJlRlhzhGVq6xOHHuCPSb
 DjvttQUcBGanGFWUy8Z+Gm3rgL+XF0b6xYfFtkH0bb2S2wJZ3zaV/jTNnKQ+CjQAxfxxAA1d2ua
 oUz07JrDPpX/EpaOj7sBBKzlGKjFAZJ/1CFUwgmfZKZSfsQTflrNdRrxGjBTUd4KOngF2P59Gac
 CYXeC4wcb7YvcOfV5xatXfobRbLZUp03OPafdufx8Z2dBFKzUfbjaSUzaErMMhgvw4+IUdZYUDN
 xWotZg5Lp9u+Am1S1/LbrioVly7Hos50RzfPL7qHTpEMYeGDWQhVltAuhRUZ0zKdgs3Ho2bkJMd
 AV49qtfyuI36HyQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 4FBD81C000A
X-Stat-Signature: h4khdh6f4mtuzg15jyco5kznhxr7pics
X-HE-Tag: 1772121579-70276
X-HE-Meta: U2FsdGVkX18Ij34zsNTGqKPIv3Ej1nYj0iP7CAne3FVjs4pvLNOUT/558J89nB8bv01gxqXgICZkcOc45avxhJo3u61vKtaQOvdbHa8kbL0hjHhAKL9P+MqzXR2/uaGyxnmF9Bgg77GHXssQxn41ztAqsO3ecmsPCQE9By9rtE1XioCy0jPqE8TXjn/rYSExYTznQVX6nnv7Hy5uxOn+BKp+1fiV2uwTjIJ9+zyOj/rm2BKVT+Z5WJfcErXHdz994pY7JuI3n6zqqZYHlf+Jx7uayZG07APL2AstXyjtaxzary+OyHTUbZSkrt2G+1D0a0EksX03kNBEXr9JiNhocpoAnlpG1XBItuh4Ozxi1esag8dgt1MPEjZwuziaz7bsirv6eF6dV460jPi8k6pJlF4hQBEj/VSIWeyFPQIye4GqGY4TvrjjF9xeMUuIu5evrEHWi4NmIn6lC1DZn+0q+3Cc9CVWhTKT2d8lc4nQUaRIf3SbYJ/iWRY9W2lFVG2AvLGN2StSU1z9V4d166BHSgV1UkfTrsqsktiEO3sHt5mg/M7aXq/p8Pw79Ha+XpmrUn9XStEH4k07wm/WM36lXJ1gs2eqHQwwFhA6ERyBsPLNESJctLCBmCKPug/1rTpWFplynCQyvgNpBpmm8/YAhCLdBbmHiFm/zvmhU8QWT3bJ7xyMMj/Sou7ubsrM9AvguDY1+p3EFyLhg+EzQqZhiea7efvegRyWhPmHwhmtLGaZnJM8fVT5XKKP4JSt8mErtE/ffUu8c3a4igy+QvMAab9YVaf+OcuJScJOdfxlvzLQ0XTi1aPe42T8P1KiHZ8YBxDl5dUjEGpSqqyRSle/kIuuFMtY+uP7zvf+5+GgxvxZ5eNgrWRMuhcPrbxEdFOZtGnJ6yKPy/Nvj3uyikWk1aeFDDt3B2XQzvhyjsmcDhVBunNwAyorEX/4YH52Bvmu5gQFMkveNJgNE2HWKLB
 +quTDpKW
 1u7hp9tyi/8Hg3rURYCA9Vr2pAtU3IYb6qNhIiXOdawpxGy6tcIVhsTZxDQ3nr4yh+BGsdmj3wMeJAw3xl0DOE+dGd6hpF5fowOJyUkaAQQwyt36enTXX5M4y5OERiJSApKAnMahPz1dNyiBFUOWN45GsG80IdnMzKdmwRgx8edeNM7S70B8GRSuzg6fwbpibeDkuT2GArCf9LwYchxI6cyr9uuVihuYVsVcukf6Nw3qhoflaBv1M9gqGL1JyGk4UZPsSZW8Uw3Mwb192m+czRZM65KJ36ywebuo/tx4wHO2VhHRqpSQYK/Dwbd3YMvmpw/ttnr4TqlONaJAVc//UQLgxm3yIOST8bngenrx/PucdAtk9nWCvtVrq2FVowMXQ/q/1WQzoYHyoqT67LbZpSDHyM77XdELwBzZyAyx33D7UpPcigewtUq9nFQAIlK41keofw3t/+NoFJ1XeJU5xL31MDxT++s1CtbedBsdfCMaDuO5bRvFNe2cp8CDnkLY0ViAo9VxZrMlgSaW9KFm70uyaP4FuZe1Btwnrn2A5WZNr0n2iCUqbQfgiOm4GT/4a27T3czSbjGIL3+GjgwmoNG8yYeVtdjZ+NQIIRQ5I2gpJXX1UAPODL90rPQvuhb2BBOefbwKQEQ6M9zORXQf1JXVb9dk+NLytFfVQa3WQpZUcuS3BzgkwuIITo8nQj/I3aN3mLL0aqz1mbLthlVVLKDdwWdG90nxYdTjmD1VKi45G2LtcPCUt1rYc2D27o1Hgm3znkgJ1qDjMWndvZIj6odCMrKz/bC5LSe7Wy9GT2NVnf6aF/jBjPRkzRKthrkpP9woX+eAxJ+i+LnMswNHEn6yezSH8syiSb0Y0k/mKfYXv+TDIKzN/69xjEj1qRYItPS4geLU5tmL234J8dISWVMrz7UuGcpsBvpdZf8GzMBPvGka/Kiw0WVAphtVKmoGOnaQrwi+WAJBmNRTVYC3mnDzg2MvM
 976tJbCz
 Cx8ps+anQx5aBni9EUuLqkrxo9KHFSidF7RoxpM00xiCosKACG/v7V26q6gFKfqdoFdW04s767SnXUKjRbg4ehPt1897dVfcUqg5cUOtwnQcrny0t32usfi3Qb5AKq387nNwfuTPyXDOF5ZguKkbUrkj76oI2xQ0POwaYd6uSq0VCbpMSOnme5LEwWWGytRtEI4wIdTRzcrgR7by9/xgHO/uQQBKefIk/LbUzthbaMufKgvdR5CSbaqec9y7FudygYU40VU7xXP+HS/TjE/yTbgL20xUOMKPfIHCnlWD4unV3W0DvzkaH0m1Iy2MIvJ2dh5oBPLEKikAzmBwl9v9GmuUifyAJLPxwIHAlSY+j8n6JGwSLuPvupln9SR2EI+svFUSt78gr1WJbuKdupxcAwYIAsDnXbU1lesTBsO2QQCABU+XSKJU8P46uWcN7ahCpgmEK47riVMvop5Rohv1mOh9kKi7IMDBVgm3bQSLAU4L0Vj7S2sPc9ZjoNtqjzyYQWEjAhqFxm0DVuStx7tkbfrKeP4+wi5QvIV7qAh2C3u0k1QjrrtvJXlAN+Fme8bU/OwMmYRLE5H7LQ7eOvOUUC6AP3sDrd2otwTqW0oye1Qqy7YYe4EogHWiKCoL8BHH3SctkoQDOS+nIWhsrzj4SBb0EFQwXVF60pI6ofxTchiuctFY1hIq4/wCai9/VHt4AyXzlc1F8YgjUSt5qddKlrlvnfvP4pPqWxm7YJZAWJpCCg7AXVdolOzjJxqYGdMSnSDFgQ8+XaYB/HvsefysanPG9N2r7kjULdUFYxBg1RBzZi3AtfzMAz/YfWYuQbKHKW6wlUG8GXHl86b0vb3Idsk/i1P5x3kqCRcsdo3j5012GZEzQNKRIgxkMp0joqcfYbzb5ZLL5rJTte2XTgnEHgE0seSag/ENOkqDQUHHHcWGQCfv5gVJc6MR3MWhk2d243IYCWv0oeuGiQTKjAEB9SBaLbJfz
 n8WrcpJd
 9Ws0fFtPRn0F7wJSR1Rj/PxN4eWxbeVNkHAIVRF1Z2zqmmAFGribjtOgdd8P2kb8rePH04ms2ZhabPq1zme1zcI+rmVXOqiQ9LV2LMWmMndMP9EqP74aj4feDdbZBZ6LYiqlSHFPyf6I9RyUXkHCSJDCNS+FxzC6rC36EEgXcmbOOlNNc71wnNlrQwniStTbMUG+zobSJglBYGpnyaQQSfDe1GW/caodl9gCC7HrohFU2nD4g8xvQxXDvYe9ruj71VE5SWSTuyEbxkNOr7CwVysG7KBZZXE10lrlaisQQijuWJgnwwYF7XQ54piRGAnmpnI/RkQMHYJsbrl3FFgbhqcTBeQ2zNxTZ3z2G/SVCoWdTalM/dYmgtPVLV+ovDKpheVsTo/IziG/ygxGiAljYORTrne/LzHvSzv/Tj4wDdjGvAdyrR67rj0y3ZEg4eT4mb3ehJkn5s/2n0p/NhFPEgTilCpU/EheVdOYIgwh4McRFgsVSe7DqaSZjV7jbGvrayPikDsLdtWi8BvS8n/TxCdsHh0NKuFuiuDzhKR4KckF/sQu1AHN+Lv68apv/T65hpQ7saJFEZPgyvJqj0pVrEveKVOGJva+1e44EZW5DBR59lkbY3aBpddjOFsVlSMjWK/tAPPbsO0AG+kKkRW/+zafLbOfKbi/cuqhV0JLaWYbO8rNKc1IN2LN6OKGtgnEnyqQ6ODgE5T0oa8IVVHLpD6NJLUS7dDC93SVpiESNT8temxmDiIpour1tqpZlvQ7zmvBJWI5KBzOh6pJEHcqvGts6zbJUoHJnkcKFTz+84veZr9GIKpOS4vSd3ALz+TnVbYsxH4FjVsLU54nR9QSSdmKWo/Or7DM8jo1uiUXrVtESutxVlSKHMuc7HMXj3+enmZR028/C6YerX4qmAWGqI5VQus2/fWSULnOkw/ZkOfeYD1XfveQpvQbD6+tfto2zWPJ0SFwkwm3lWyEnxs+OWWYog4fk
 eczIF4+X
 EuthBa7janK1HgJqFTB0oyVy5QKwMumgKBrCEj1zEsM21tk6jAyb0S60V19kp2dAD3HOVfDS1mQAepUTwUHaejxgarQXKSJD2c6sOL0YpsRU69nnj8vTdgtOD5gKWKb6mJMej9T1ha5hi7vkAQrbjhaLOqHqhnoGG0x3Bu3ftEnVHQNSZDzvUrpc5CYdeWX1KaiulzFL+DT2t1FygYjjCvjjHfr+rvpdi0e6zEkgRe6J388rRqSuoVX8MJ5skGN4ol1n1qVhUQ3J030c9X06YenbiXuvxEihyVgpuAd2SapdrePCQtcXi54nSDVXhxsIxjfK9YZKyJOeahx628Zpqj65mWAaVYsmnQPr4b3yUVAiXONeG2GCN7HNMAPbMhr3sxRWAz+T8tLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the local ino variable type from unsigned long to u64, and change
the format string from %lu to %llu when printing it. The variable is
assigned from inode->i_ino which is now u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/proc/fd.c       | 2 +-
 fs/proc/task_mmu.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index 9eeccff49b2abf57d766ce17fe47070c379ed2c8..aae1a83e884686471758703634f0d3479e77c9a7 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -54,7 +54,7 @@ static int seq_show(struct seq_file *m, void *v)
 	if (ret)
 		return ret;
 
-	seq_printf(m, "pos:\t%lli\nflags:\t0%o\nmnt_id:\t%i\nino:\t%lu\n",
+	seq_printf(m, "pos:\t%lli\nflags:\t0%o\nmnt_id:\t%i\nino:\t%llu\n",
 		   (long long)file->f_pos, f_flags,
 		   real_mount(file->f_path.mnt)->mnt_id,
 		   file_inode(file)->i_ino);
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e091931d7ca19d71f31699913d177eec0821ca7b..751b9ba160fbf15499555875871d727644b0df44 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -442,7 +442,7 @@ static void get_vma_name(struct vm_area_struct *vma,
 static void show_vma_header_prefix(struct seq_file *m,
 				   unsigned long start, unsigned long end,
 				   vm_flags_t flags, unsigned long long pgoff,
-				   dev_t dev, unsigned long ino)
+				   dev_t dev, u64 ino)
 {
 	seq_setwidth(m, 25 + sizeof(void *) * 6 - 1);
 	seq_put_hex_ll(m, NULL, start, 8);
@@ -465,7 +465,7 @@ show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 	const struct path *path;
 	const char *name_fmt, *name;
 	vm_flags_t flags = vma->vm_flags;
-	unsigned long ino = 0;
+	u64 ino = 0;
 	unsigned long long pgoff = 0;
 	unsigned long start, end;
 	dev_t dev = 0;

-- 
2.53.0


