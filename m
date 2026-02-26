Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6D80FD8FCE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 15:59:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42B986B00EB; Thu, 26 Feb 2026 10:59:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CB566B00ED; Thu, 26 Feb 2026 10:59:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A0796B00EE; Thu, 26 Feb 2026 10:59:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 11C6F6B00EB
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:59:04 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A2FFD14026C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:59:03 +0000 (UTC)
X-FDA: 84487066566.24.AC9278B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D564BA0013
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:59:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LDYCUhyk;
	spf=pass (imf15.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tYvMnqYYGJrgx3nCuVQdb2rOZ0tIhWDeI0hsrrzbkW0=;
	b=xy0ALZnAKf3w0/gveTN3kSYtqGe62rvNH07t2uSs2bJO+CUwMsbU/MJxknc7NkOL0oK19v
	g7xmgLNyHmao3bIkUpUAjQWYVW8899xNdoEXZjUY9oSf3MMrr74Z35Jn7rD2jZnqitYx01
	T6ZirDFbjsJAh3vO00AtYOl6b6+qjoM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LDYCUhyk;
	spf=pass (imf15.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121542; a=rsa-sha256;
	cv=none;
	b=otnGaKVq9m6Lxg/AXw5vY2LS2uGV6uQtJqkbOB+RRgbKA4XC2CbnOJBk6sJGl6WmeX40wc
	XUlAaIwKTbb0QLlPxEbpc8bMlAUPlXSzb7e+Nd+AxtZDkMtKBb27GHE1B9EjueC3NmwpDN
	ithoHoyj4hXPgCSMahRd0OX1k1pn2Bg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 065AD44589;
	Thu, 26 Feb 2026 15:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7611EC2BCB1;
	Thu, 26 Feb 2026 15:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121540;
	bh=L7XUWaooTPJJGvd9q6jSAUTNKJML0XZHotIv5n8H4j4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LDYCUhykrUdWv3Pvas2rdur0i6GL1s/gViKIjWTYOQk415nXtcRy1qub/d8XbSUUM
	 D+/aIzVlWqyiVLePUBCzKm79lnQ1Xr/wPlu8hJz+p30Ci3TFMeSOk2X8J6c0Q6CD4P
	 wqxpbdVNoiUFgiqF3pP6i9tkGZpZiFsHB2ZNh7AULTRNWpNsa6ywW5AUy1dN2Kcfe/
	 Vx5kFsXJbZRj/SIYHdOcyOOJCt2ZrUoavPeoIuA6h1ix26kDvpcIxPd9hWIadzGtzi
	 je2BpQkmmncKfavwQ3rkUY8N8k7blVwDs4zRekpa7E2wuHdmSCgnhha8D4eMzH/c5i
	 ELYCW2P9Sj9NQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:15 -0500
Subject: [PATCH 13/61] smb: store full 64-bit uniqueid in i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-13-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2164; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=L7XUWaooTPJJGvd9q6jSAUTNKJML0XZHotIv5n8H4j4=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0HunOlD0IWmS5NY8qKmprauVZ/+4AaY/kFb
 2frMDh17OOJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtBwAKCRAADmhBGVaC
 FWspD/9kh7G8p9Lzfl68UqO9nfBVJdbhEa18mWKyCpykfsHfHVCWcZlNY8T54jBx2zYSKQAm200
 1Z0WRIhfDjcGIOJIuO1X9JkMJk74ESENbCRK1QIf+n2vy9a5+cGUx1mEKpvq0E5TqwAXHAOoFC6
 3NSHGd431TY35kp8fNX9Pv8z2qXr/BrZtf64mNkWZ+/pgmbU4lwAMmANpFvRPRnZqDD4h55PgKa
 lRo93MwRT/GFVpdhyvySZu0ylZqlFqaKbT+XlbjplF26+5RjXAyunICxi6rDIPXVGD+aibZ7EPn
 dM3dAr+QTk+c4IRV6A1q2wP27vVBRHznWmq5Z7eCnNBGaaIG8v+XzuAkLBejSZi7qst5JE4qtvd
 CC2R1LYEW6s5Jgvz/eOxoK3G4Fr/Lbqcn2BVBH5846qvSmHY/tv+80Svxawf31ts+zo8j3TcCyA
 3Bb3UAA6oh6ycWf79FO6g6bY5UQpB1HNGB0wUIW7DiG2qplnSGUTlZQuhos0ulGYVhDfOziO0by
 eGvFmxwnDmQm47WJ3l6yO+WZ865DhG4wuBmhoMjmQ/e8qkfYmrpArIHr2WNzFK9Hl+9tCXAz3oN
 +BFn6v+B/UueV6kf5rFpJzAJiyu3TKMJH4KK2uGs1vnYofltFVpo96fk1iXzdofYRCPQa9M4uut
 SbvrPRHyi0Vl/Dw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D564BA0013
X-Stat-Signature: se9q9y6ankzwb99xdmjn84r5nhd8g8gd
X-HE-Tag: 1772121541-874031
X-HE-Meta: U2FsdGVkX1/T+HF31Tj5tAqZpO5NgmBnRkRDkC4N0PrBtnauGIid99OeMEQ3baoFk1xzkWx18n6iFfXGJ+ftsxOyDOzmikRH6QB6CO9vcCfo3Yb1nBX7bN2ZA8sJ3Y7rRSHsV6qyk89tcypUTP7UMNdk8XlG+oeSdmVFGpdVCGNmrn08o6sGvx3ijgcHsKFdWQOTt54rXleMpUOhXoCz82wet3lTPuqL2yiJ5/Hi4sP/6L8lnRqI4sz6U7l19eISSbV/KSLJp/0NFAz76qtzS1ppa4Nc5weqY5Pob8FazJ0MwDB0EiFTQDycYpTE6+QtAVj6GqiUhBJ3YjSrl8kEL7nFprC4ECP07mT8BYgRzV8fSIGiVyXUnjmCw2t/vzepAJkkfJ2I2hnaPggGHZr/8m8EFLH1oh47zV8k+v8eY4HkUYR9PMamLc6NIYkphI8MKgoXzSgd/S5HmbjJ0rp5tNG9ygxOgblXXKF2y1y5pKAptY1j2iendSxdbWa+AvSkUBFfBdCHkA0WegL4JdJJ0PUR8gQ7JayoZYNZQGjopUTJaKpRZ9ZGM4ciqkYXwCgypWmjdlB9AAT21eRR6LtO0sBGOCZjkCIau7bF3D1mtdUEv5SMn46MJaNtVMzVl9Fk0GhYBd/0DXEII2oOosdW7VfPObjIrFoRIiIxEzG/3/Fki3D3ENg5DM6Upmei9RRejB9SL2vQ05O+iQMR0DfhhqYbDOoNVpsheGZJEhQVTTvktOxJxLYULNwIEvB8kkXmzeQbCRauLY9Y7thuAQRkfBtcsPwe5ROJ8wG/RNlvXr8uqJUCy+J8nt13CmXZ3deooZ4E04nvvPFoKSObS1BRTauYGg07s4zz1J6u9tDJZ1JCFWzSROrIOtXCHKL3DzMzlZtRwZkJJVvvyHOUXY5h1XmVv0V1kbMusUSLCqXdcTipuqbLK463r5uNLQOu4ZoJOwvZvYypy4QfEfxKb0J
 AQoOksZx
 N0CuLwAo+LYwRtcIxWSyOybgs9NoBlqRaMcbh7BvdbldzdMw8b9EhIus/ASjNYJtkdtgid/OmVPwSSoxEs5otKMJZImxRxVwE2SeIMD/yha2agpeNPm1cu5nAwyrxz1DfPPyNaUbBm5igjIDnb1JsDJDO4aeFcW5VGwy2QQl6TZYGeDTx/3ASRpj1cESryJcSIBd32pZRIKWXGcG4bUT0AbhpmsLW8Or6DvEkPrll8eyuEWQdxXqKWN2aq5TOZkW1XGCrT6Mi1Kk2eVHrlI5BSKrCpJwxKoDndQdS0Ni3QwvRRf+HOJyAayeFXq5cMwNC+TANpMfQl5ircvDR2Pd3+Sj9aKGiBA/xfQdx0JDqjlH++3bb8FvUmNjdd4QnxzP1IikLWnxIu10AVK44mIJpOMpSNCJ/DfEqacAvUms+FdLxLSaYD4K/yBlcRFpJkeduhzdMHMzVwT/a6SMJwLObv3OjNCLPqG2vKNMllQ0rUm307kC56pLkqO/9Hc0H/98n0MOhBwLS4FrDL8q786JYtvbgYJQ/BqBRa98x9RCFTbYSG5gpabDJCZXY6J1e0ii5mun/eEm3Sjm+5m3i3tmuQyt7DTSIjROTDAvILrRaHrCIR3Um0iT+sdTshoQK7giKUFPUy9J9Lp37UIQD3PpRbUF4tIQ7BIdErbGBYP7z1U1ABcE/5PDevuCkzL+rwrF6aWF41Bw7af675v+1mT1+cghYdDX6mMe7rVNOZX0Eizx/uQgCdvpeeOpPjeqDi3aWqLnr1PaDDzvshzINKUjD3aXjCUT12DI50n9d1EB4FetkkXpIVSzTqD/FwCNIrorPXFHS3ERJ76oYvDjjnwZcjDHl3YGjzCzgtvtQ/IEzpteaamGOYZswlT5TJBKgeKVdVdPRGL5t47gMs6WHzFabtV7EbRGxzuDo2t6M0kvvQtjYcUA/yHbDQ6agY25ZYl+isjgZFEePZpXUprum9fN8GGAg1lCe
 VKv6mtJP
 zhi6iPBr9AiH7xh6fGDMWDGm+w4kuH/f7AynXYCmP17q9ho8nryQuiVaDIWwy/03O8S5oZ9qJPrGTnUI0FxDl3N9gBMTOK+vAAvgH+BWvhmb1Uwc5jb3CtSde06cbT8ODNhZVBOV9xCi76ph9YZN4IsYeSHIbNfp+nsDxD3ewfELtrWx6TG7bV0t893eMG8dJ09pRj0ND7c9gHpCTvNYFbeBQ8xmXQmTeXUP4MLr/uhvvjlStkin2LQiYXmHMcZrxznJAsmotkRix7hcHuiPT3BykqbOFHPQmScVZn0aa7T250TsSVQTIPGhAo8Bo+jttQij6p+btiHRUH7YN0av2CgS2Dif0qqtyxXLPEKKc2OBddrnD67jKtUPn1gZJbfJVc2gr8N4uxsGaOAOUOY//5tCBlet5YT8KLDzCjG550xFS33WDZm0a6KMrdEC2nvvg3aQJdOFy4oNlXcZ9REM/tvXGheP0J9wPO2b8OL70hjyRdbnb2gt+JshQMlDrg4NktSE7cUjwk6+5FvhPZ05GMrdGwyIzkCy2qReypn2DuRc0nofrY8w6fC3bDwAYE8snjpXLzDoZLHj23lrgv4hHGo6tpghiYO7Faxai6KCydeZI9seEx7/pA+25BvXrF7NeHE3eD14zetiOkBF1kWCav0o6a1S6ul95V6L1LRML18NU5Fb+SIJ13gFTH9UMK0fyjFz1gZnrZD1dUCv4YTxrm2LJKtmvwgbz145C1pL447o5bG32VbQ/Yaq+CH1TorgMxdvTz5+xmdrQ3ZXazviquS+m1PdXHIyZR6WSXtfoRimft2b1OlpJqZF1E6cHWJz6TWloqgYxXRNiGMpFMmeAuuPNngpF/Ei9udhGU14NRKTt7b4xSMJy4w6rmCgKeoZNrp0fhrcwBFJJ66OlbpYr5OTv1MYHw9iI5l7qttanhdOFQIOyfrHX4xYpucqtL/nckBV8sHvBIMcvFIAPiNdQWl1jHLcA
 40asCXC7
 1rEXDgBEr/YVt3TGyaHNWP8aQzFgHScBng2UOghBCPdSWL5z+P7NroeP/u6HC4jDnBFAVBupTd3px+TGti11gNDYmgVyGwOWv2Fu/X//w8V4FgtSugP9QErv5J/ZvBMB5jnpFqDrz4LLNm0eLRuQI9x+JAsWP4MCkeQgqQYb4WnUNfs0Hac7DO1u2Z+5TtmmwOWDRtzU5xffh8g8z524kbXF74ZP0jytBP6JL9lLPJ/29p/7++vNMvyu/pO7w0kXJMXQyLBTPSu84LQeNdQA3LH0U2rsYG9vlTfXIkE31ELE951rjSzUIDnCHu/5neM5NHdqLVI9ONlBUnvTzfxZcv1Ft/uLiA7vmODL9l1DHFsKlPbhJLdxCOV2AKcXiuFXNie3cbEHB1sRkV10fbpvEedKb1GAHhMbPYmww6bvz2TGn4Z0j3/4dcD0czQQNUbJuLmTzxvIabkcJGGWrMzRGyKVR17HN+JUU42kj3Al8H2JPwg0nnV6DKmHDn5RqkjBr9B98/mQsU7hlorLQrkQuWEWS8hrjEGge3Zm/skeVOdKbU3s58HMdBEeCE1+hH7HwWbJp4Icu+LOldOB3G+yNsiFM91LvQOVfGsgW4ssL1ckfvBYyiQ7qlomcRcCmVgMwucI4ICbyL2yYk8L9MLmTVNdKn54jrmSh0KOFXciQ7Uyxhxxz+Ma7FWC/O669lCyXv3cekjeZGqMEo5RSLIqTJCL/K8b2Trp3n4csZtAId2nYR/I36GsSi88u9Zlx7knMrTt73qJ3CsnqEbYi06U1w1IUswTePqOqAiQQ0lUCqxgojTrk9QCH7R5Ipy22+OklvgDALFosmcvxVc89fbVM1tAT2BPCiB/nnImXwa0BW7NApPNHSnl3p6RbMt7ck7vUiPz7DSrLL9pCz4cmFDEqpDZ1mAN/cQKSwSW7NftApiMubzAzF6q8Ct96lveygKinPOuthytOcjTg02rAg/qD8hwBbiuq
 Q9N7DkY3
 CLx1Ig2kkyoDn53Re6XK7oNpqLapS2o6c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With i_ino now u64, CIFS/SMB can store the full 64-bit uniqueid in
i_ino without the XOR-folding hack previously needed on 32-bit
architectures.

- Simplify cifs_uniqueid_to_ino_t() to return u64 directly
- Update hash variable type in cifs_get_inode_info()
- Update format strings from %lu to %llu

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/smb/client/cifsfs.h | 12 +++---------
 fs/smb/client/inode.c  |  4 ++--
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index e320d39b01f5eca8033cc516f6f1a2f07276676c..4a1f18022c711a7ff5b141d08ec6cac8483a6b6a 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -14,18 +14,12 @@
 #define ROOT_I 2
 
 /*
- * ino_t is 32-bits on 32-bit arch. We have to squash the 64-bit value down
- * so that it will fit. We use hash_64 to convert the value to 31 bits, and
- * then add 1, to ensure that we don't end up with a 0 as the value.
+ * With i_ino being u64, we can store the full 64-bit uniqueid directly.
  */
-static inline ino_t
+static inline u64
 cifs_uniqueid_to_ino_t(u64 fileid)
 {
-	if ((sizeof(ino_t)) < (sizeof(u64)))
-		return (ino_t)hash_64(fileid, (sizeof(ino_t) * 8) - 1) + 1;
-
-	return (ino_t)fileid;
-
+	return fileid;
 }
 
 static inline void cifs_set_time(struct dentry *dentry, unsigned long time)
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index d4d3cfeb6c90ee6dc71fcd9a8de31a1785cbb9ef..102e7615b658726551e9b01ba25065d1f0c505ac 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1611,13 +1611,13 @@ inode_has_hashed_dentries(struct inode *inode)
 struct inode *
 cifs_iget(struct super_block *sb, struct cifs_fattr *fattr)
 {
-	unsigned long hash;
+	u64 hash;
 	struct inode *inode;
 
 retry_iget5_locked:
 	cifs_dbg(FYI, "looking for uniqueid=%llu\n", fattr->cf_uniqueid);
 
-	/* hash down to 32-bits on 32-bit arch */
+	/* With u64 i_ino, we can use the full uniqueid */
 	hash = cifs_uniqueid_to_ino_t(fattr->cf_uniqueid);
 
 	inode = iget5_locked(sb, hash, cifs_find_inode, cifs_init_inode, fattr);

-- 
2.53.0


