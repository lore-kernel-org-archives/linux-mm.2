Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA487EB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 139216B0154; Mon,  2 Mar 2026 15:50:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10A696B0156; Mon,  2 Mar 2026 15:50:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F03F86B0158; Mon,  2 Mar 2026 15:49:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DEC056B0154
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:49:59 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC17C1B749F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:49:59 +0000 (UTC)
X-FDA: 84502314918.15.663569E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id CA817180002
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:49:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AP6bQvtX;
	spf=pass (imf24.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tTFuw+wp4QNFtYtrnqCU7ZG8sDwMvgGdEh61J47+s4Q=;
	b=fjB6IW6FOHIrjJNk71eWfK5Ni7vEwvEl8tAyyWQfH9X+8olYvpWwyfmzmy0+C0QIZ/Xgu7
	Sffc9Itc7jnhO57o7U9rVAwQQ923S9Zo8fIFJ+wv5EskmiSzoDTq3pm+AGBrCaC8pmLyXc
	ipTLFXABNh4670cXkCAnUsaswzW4UCE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AP6bQvtX;
	spf=pass (imf24.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484598; a=rsa-sha256;
	cv=none;
	b=rpzB99XYpPfIG5WOUVt11FkVFr1AYotSn7Rrmdhqw246JbGpioY1T48ardAk7RfpbdwGZs
	LNbsBPMsUPQGuqVH/GXbQMUEaftL2XYUXXlVHpXkpPW0qrjJqdUdgSHaRLjl2D5DASE0J+
	K3TiHs51E5ro/Wo9L+2Qd7IAcpb6Wpc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E2B4B434BC;
	Mon,  2 Mar 2026 20:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF473C19425;
	Mon,  2 Mar 2026 20:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484596;
	bh=CN3Vb1L8i0VZsrYdPILKyhnj2bRK1H4I1nJGsMGG62A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=AP6bQvtXhfBToO9oB0VDONr8q982yEUUVD5JZPDLskRPfkWRwE6jAhwMZTKtDmgt0
	 I24miIwTJyX4oztUqhwwge482KsAyO8Vnp94cMh4efEg3IOI/164vXWkBx6nookw9C
	 cyVbCCiuC9ip2HnbczJcKCvkBovkOzPHjeiRz2AiF01nHJI5d6FB0F7HinabUvnLKp
	 n/U6ulULi8fqpZEhmMScKl2+/o53uF41EnQj+eWT4uODXSFOaKBwfddx/AMB/beMLu
	 DFxaMcSe+w1X+nFQXM8OX2PXIbFTqwmzdkipPDMvQ9Ejvet+Gj0AZQGQ9Foq3Rk1Ww
	 KnHkx4wP7H7Lg==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:28 -0500
Subject: [PATCH v2 104/110] fsnotify: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-104-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1496; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=CN3Vb1L8i0VZsrYdPILKyhnj2bRK1H4I1nJGsMGG62A=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIMzBlvAhZJgMzJqzX4izA79Kto6h+aiUDxX
 0pd599iWAOJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyDAAKCRAADmhBGVaC
 FSBHD/9Xm/whp2eS/s3EENxptUqi9eR5Vgz+4j1Q1kCDfooLE8OdGNoSt8DpER/caqkUMDPJgdH
 7bOD5B270x+2bB7erEXmLstrLF/M+zRLg/oRr7wf/COY6k3I3Gq/abj1pLjvTDiNWo2R24qNuJP
 7jxiJj1q2s4thT9Er8VuuEybQJ9Uc/pJy2x70yKdiEDA/UvLRe2fGLXCdpj6FIMoGrpE2CueAoV
 UeFxHRj1oVMXWJ8fo4ewAATMFb8ndMidCVYhoSS3td6cDB7wCl2CBIUxkgYIfrvwG2Hz2b38Yxd
 KE2Fsf0a6JthS2C+iSarSTUro22kcq3ODAx6EaReSo5eL/dEc6w78pbB8ayg6ALuKpcGaZ5HdaJ
 UC9GuEGUE4OLoXZbMhtZ5njorh5XtyXu+Kh72nlAeQK+89hiI0Ozua+workiO8TMm5NGRfZFdV+
 kjJY7e2/CWmETkRpZUy9Bmp1R0tts8MqPfEHgsf6NdOiR+Oin+KPhXHgFQrRkad8dgQ3hhFNpLI
 UtqMp7u6IShGbaNuR4m6QPRuKrq+Ooap4YGKdv+jOgLNcjodGHN0f1HCtnmxKP7KbfYsMFFA/Tx
 p5RTB6ZKnDsdQONeE2mAyhCpUPlfFWrJTXdJZLTa91bKsamIQGPm2L/cu/rYvoilF1yQqHNNFtb
 /3ZqyY5gjroxFHQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: dgixf5nt6tm66p5mnuduun5rpjsjg9ym
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: CA817180002
X-HE-Tag: 1772484597-609771
X-HE-Meta: U2FsdGVkX1/jU9B2PDKKnRKp33bCuyBL16CRQD1AQWgIF2XSLxBg7RfKeCVmGzjTKfI//o6RZrbPLso44cIr6PLt8jkJM+YEgOhBVNkn1MT4UqjQQM6A1vyqPXjWoTExa9qy3OVthOAd+iStcmuricwkjMmW8LWXdPctKOFalhok6Bj7AEFOKuLDP9XK3j+fSQgWcyH1xXZA4Nt6zqAjD2xKzXChGS5dJsGiPFBPm1gZE/jQ4sRekFDBOlj+RI6BxInGxs7clcM0P+y8sFIQHTO4yL2VmhYqXdIRTJE4/RpmrRZo809IM0dBv1k5uuz/DSjOhz2oenFKvpCk/SDnp5EqbVBauG4tvxtMhZStI9MH3p//6McPsKHZJ2/mhAh148wb3piAQdX22Haqs6Gam8sHYVeAlDhHGROCglTY92ZvN9L6OC9fGUevPugc0FimNCwufA6GxTslcD/9Bmz3tFPm/WzqKoRiHNPGGAZY/uoT9Rv8pDdojpv9/uqXrpzHYc/TJ8/q4/cKMFlwfEwxI7p4L1WWjM991b/JjvZI/WjK7F8KsJLbaqpHnX84C9kYBc0NXNdEY7oS+nByfVK5P/zF7dpDRxYlWJjeFpZINodwEPmdkI63up4U2Y/ZE8d0LJMvrZ/KOPXIHV7+WlLIVLw/eN+x8azM22RVoWBPIRRe3p36LPP9pybjX4wvA4EKM1UBafs4PK5oXcbZOHNhX4507z4t1egi6m3qDECi1KTCM1CNlKE942iUz5lcPQCR3BdyxL2pBELWR4DHzc09JFUufeSibEs1TF58nNlzrqhwuw3MunbRjy48G5NgrX3JZF1kfs3d+qFzgvVkQE8CT2DkjfNQC//V2msOTQLV9olN9Udk/V2uLOfMcUayZSgzThVyBGa5/9/nGrDh5gD0nAAWPY6xaebUp3fO8Rc3yzWePlLTl7UY7FJfG01OgwT+9wJ6kfPg8U1cGzU2MvE
 6P272mvZ
 AmuGwsKsbCoclLSFA/2xvbqfBMmFkyROUJfJkPZUru+c6PStLVuyQA8qAZm7J/fSKtM4Jl2weeaB8aCex3nXJsmnVfW4FnVFzd5245qQsRoZBsWRyft1Do3+f+3aXtHIZxA+mOvJ3TzUao0osc44Z9HP4pB2piAfDGLb4FYnTkvybJBw0hrd/JIAnQuguv7eleq9oMqUgY9LREh/JoCc+amuS9CXc+ycV74FRDmpvilMQCLtc3XmW0nLsuBgxyepc0J8WXzz82JrCIZinMhntkvX/TFratBupdl6POKet/EwKbRJrKpJlafC3e25X70ewz1dE3KXm5nkCRDY/+lDU4oXl8gF8ghHnNGzPEGa1HvRyFZ1xiwpQgn8kgwTRVDM4dVdNGc4IArBKwz1ZaZqfDDVi7Kn5IhJexTSxyuYaHpvTEusCradCtoeXbjAHqrbh73bkhSY5VImxzgYnlFcJtkD6VrfwLP5JT8xGFonel5ZuOKPniEoqvKdiE334PnSeOhbODdHtIEV8zuQIlTzb9p6hMh1p30gRwkC/JMs+Jk67bXXuWzPZ20BkxBh2sm7pVeCEMMtW7lalERj2mISvybvbqt9qOblF58fhUNFS/sBJ82zwBjM1fdBExxvq7zCKP7RZKHWvkCC/1fD7Ez9UtDgmU5uOl94GstPF82n7wn7w+Ljqm7Z9kO0E8U8iNFuiGwh86a81229n2KfYhmdJlrhrqSyRB+3ZvsHI8AvYdkPPCATeRtL5kiSa1VdxxMZMNd+N6JEqNCzV6vZYdTx2/jlCTcnjxop2ILkl/13sXmOL1raCN9Cb5Otc5t0ZRaLZv68cjGJHUmMJSA8dipgBvaJEwlAN92HjUWnNRjtoPTYM5LntI3GI26R4MC/EjU6qTr41wCBT6I5AWyKblrATxE/mmTbi8MDnZ581yedyIwnki+vH+H0Aby+idgZS0ziQuwdd4cJC1nkQXBPBk2ImnwXaWxqr
 ZnCToOyi
 Bds/9GRh403hrcFvwkbl7+NrdmctsA1QdaRV1UHq/mnDJgVzG7QpCY9orHF5jZsBQcPjGmdyUNZDMi+WAYNMLR6lB0lGqhaiFsulaa3jBPiS/LYEYMOEfsD1RW7N2VJAet4fflTuiCDoz+iKLJ7zz7uiYQ+shF0ovK/wZU4IbNrjMfzfD6ICGQs61mTyOtgpOq5R8zQHhdoTOxwqoexxxbSJtn4v2Kw9+qg8d0viMxEjiWHG6XgPHGQT8MLb2pB3ahv3Pwj5KXEoae4vb1VEf0Y2/yXKqxKh09iM7ltcl0cHurq6kQ0JLG8GBOdb2/eDGDPGWYRmGZ2LYtQ9jELpx/9z2WS4wJ6+npTHkJIlV9eQvJaua+l9nuORbECW7nbn8/EKE2MRPxQ1gAKOdo76LZmAy+gyCb938iTQxv7miDrc2LWSghg92/arICqpHxnVLa2OVsIo1VyX+pmnDUnwILwn8QU++I8cDeDhlP+gfOLwHdpYlf56q7mz7Hasxq++QNUJ8oGMo4GaO9OUcQrJ18sJJhEvWqBaXo5097fT2fFy/XsS6nxSpNRQ4xP83W6Y/Bx7VNNEI2d8nOKTCkidAU9OWO7pLeIZI1HdvwsgwnyHUYEmMxeT53CaMthbDupHka1m1kVXxrS0hV/xqeYgStnJevsM1mfz9GriQvLywMBSf65avfH8y1dbHULQYelq7PGW/Hu0yRwc8zZnjY2/98tvIpaSpWbnP8ajlaLz1nHUjqrUcp3sVEydR2xug+MJnogcJ2U0EGUncHzWC5nfcwTG0+BK5S240ks30krJ+2SD1J0K23VZJTld3IcpTQn3mHP7Ucccn+GYPYlHoOlHZe8djtPmSKgl0PIMQ/QDNrPiN6VPwU+f+Q3Kn0Y5jYRpzg4DmmKYMvdk5xXIGwuyhkEGOsJTctjOoexks8ZU3S921IzTEtLu1mpY7NvRKm/4NRA/QewGWbgRV6HFwGCC44uppQwpN
 degzKhGX
 9cNyEU4rtuCbX93VrKLIdxyZDL/+46RIjD142l/EbozFoZ6gmE6RhMCI/FLkz0BzUhjndq529QAsW3pwVRwJsLiEghykWbrjLGGshm1KG3/JtBOsa8KlrH4oI4hGx/TfgC7twCaQhTmdODBgbD441c6v8KpWnQREIQk7tF421WJHfIqDLNAYdZ1s69qnGr91mN9WJZh3ke3wiG52X5X11AjT5O4cewVHKdNoZ3o8bsT848rSqlQ0aDYVkUpJG6RGA4Y7HF6mewgNEq72TN65sigZIYTxMj/TK0TUOoune2zviUmuv5zRQ8ys7G2Emhs36tHVFsetLxkULGIGrGMMTX3+bNnrQUy2FCKKmV3ypHzxbvXbueBIeXXnexoCriLqEIJ39n/1DUtYVqrYATIawn0OT3WsA1IpJTLIPaJF4oehhczHZYlDtNGcbzX7e6s4mVdsSvMzR/1QDY9C838sKFp4AoL+cWV9HMx9HZliTQ/f7WCzNw+bujEuGsaT0iNt6uYWSKTvpWt6jsPnyMFbpu1c3mdYCjdUlDNvWmHr8XH35wh96fEnZtyphrsTGcLrN7yV1zUFISfv7gm4LhAVojw4oSwUs1LECl/1z8BK0KwQsCtbo4XvP9ZJBVHVNzzv9VY6O92blkG41bYzv2DJsZMC4hxxAulE5bk7JGXVdtp7q+GR4KGfFD1CaKPZHH2FLve/l7sdX6YLYRiixpajm+IX79elzXIoArie/aTd2VDWuYwhG0ZeDfwo3uWts7ROg03KDS5qRP389gYAjjobZ5SwprHyACw4cjqNerZwU+mP+gsXUtgJLAnsMGEirGZv4bimBI+9G5gWn0npzvyG6UN9Hv2Mz55+9XTfHMulPEQNHDhrJacbXlz40iITDRT3fKmUiGCW4aAmquU7hpkIiYvDk4MAHOivKAaHjpGCpl9jHjIi7+ThL2p6IbEicVqtyIP25s3xsST0zNlmyDDTBSwhO3xIL
 S8bYURMw
 sqlIVLu1ThuHoyFUGsyg1e0DzLkjfeTuxU6jVWBHA/J52wW8DhOVqF/A+bNQUU6NxlxETEq/x46HxKXahM8a3e2aEvcn3o57ISrQPvZd/v7F88cCxwf3i2sS9c+Rwdq2hJz88IrhproUzrB5vHHm5qjr8NBrXwaS5xVB2Nf9q5RHN7dt1yigm+rfGwprFWxawpjQvF3hubD1eafzwdIW05AOIxEgRm+uFY9HffD5mIfO3RuX9u2JjGGkawjgkSRZWV7vh7ypA2OTVKvQ3oVndOgA16XF1qlLmfDWIiJUtKa4xj8hTklSq9KRYCNJGzhEgrkEjyBYZrmQ7FEc/HQpodTgbWJNTSKNY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in fsnotify with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/notify/fdinfo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fdinfo.c b/fs/notify/fdinfo.c
index 586eaa7f65a4a61b892fb9c39e6a0d81e025b790..0f731eddeb8be74113361f45aa4fca2943395e9d 100644
--- a/fs/notify/fdinfo.c
+++ b/fs/notify/fdinfo.c
@@ -84,7 +84,7 @@ static void inotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
 	inode_mark = container_of(mark, struct inotify_inode_mark, fsn_mark);
 	inode = igrab(fsnotify_conn_inode(mark->connector));
 	if (inode) {
-		seq_printf(m, "inotify wd:%x ino:%" PRIino "x sdev:%x mask:%x ignored_mask:0 ",
+		seq_printf(m, "inotify wd:%x ino:%llx sdev:%x mask:%x ignored_mask:0 ",
 			   inode_mark->wd, inode->i_ino, inode->i_sb->s_dev,
 			   inotify_mark_user_mask(mark));
 		show_mark_fhandle(m, inode);
@@ -111,7 +111,7 @@ static void fanotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
 		inode = igrab(fsnotify_conn_inode(mark->connector));
 		if (!inode)
 			return;
-		seq_printf(m, "fanotify ino:%" PRIino "x sdev:%x mflags:%x mask:%x ignored_mask:%x ",
+		seq_printf(m, "fanotify ino:%llx sdev:%x mflags:%x mask:%x ignored_mask:%x ",
 			   inode->i_ino, inode->i_sb->s_dev,
 			   mflags, mark->mask, mark->ignore_mask);
 		show_mark_fhandle(m, inode);

-- 
2.53.0


