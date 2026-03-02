Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41ADFEB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:47:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A74E46B0140; Mon,  2 Mar 2026 15:47:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A28816B0143; Mon,  2 Mar 2026 15:47:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9150F6B0140; Mon,  2 Mar 2026 15:47:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E5556B0140
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:47:19 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5053E14030B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:47:19 +0000 (UTC)
X-FDA: 84502308198.23.A345550
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 69DE04000F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:47:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ww8PRAHZ;
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B7AXbwPTgLHCGjtX1T8dYmVJK7C/TztnV7sCqTavkMM=;
	b=AghvmofxotbygvTPXZ2W25Ct8FE9v6N7FJV54QCBCqwlk9jI486eLEYI45Amg7TGcvw1Nd
	J1WBgJWef5RFFrWgUiuj3aYrtyJrQ9NocguEq7D5zUBieALKO8TE2MxAmTOeHw0K0HNE1d
	sBRFPDhipUNSjnpbmC0dhEaF374a8HI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ww8PRAHZ;
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484437; a=rsa-sha256;
	cv=none;
	b=vUE13H06TIY1UKaiUYTf8uguBTMCUAIcyMJgKQT9Yu0IUM00WCpbnRAa24xbBg6+B/sJzP
	4knUaUVeZeruqHaspCR3E0hOBLZqbWv0qnsg+jK+zAt1h7CY2JEULccfY41duYqSwqCYwx
	qhg5Tos4iD2GWtnJniEdaHL2zlUEfsk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8788F412EC;
	Mon,  2 Mar 2026 20:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3B6C19423;
	Mon,  2 Mar 2026 20:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484436;
	bh=RBfm8moA3CkQn0FwfqqAPZHc84BX8JzG2ZwdR1qdFsA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Ww8PRAHZGVoyc5aznf7Vmb1RlQqe2QC6RLPARRzy3XSFRmuvkPpi6VaUFGtphfeUO
	 CKLP6ryS7WVtuXts1jsQt5qAAyd0skesKShwsOBGM0jHY+KL8lIWTJmoYyDyrMvw+C
	 5iB3CC11UMEau5Ed8pFgCyZlcjI3JcHnud4lSo8lKg54Ar1XxpTcvC/Sl5hBSVTzB/
	 W0/WzDcsCp1qwYXAupIwTYrNRLvJw7s944jNfPYdiyGnzPMrKroNGqDglB7qBV4Ft9
	 rKnFPbVUCzEayBJJ0DiSz348RXDYumtWXA8ukvnoLteTSCFuAqPfc7UpcP9jljdjut
	 Nw6QoDA8lW5Fw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:17 -0500
Subject: [PATCH v2 093/110] orangefs: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-93-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=818; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=RBfm8moA3CkQn0FwfqqAPZHc84BX8JzG2ZwdR1qdFsA=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIICLS6xYO0GerXkvON8TeCQvci2rcZnQP3v
 d9lspoHnc6JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyCAAKCRAADmhBGVaC
 FVulEACziSiBKlR+zOh4fLCSaUnlxhlP5Co/j48WwP2zAbzDX+V2ZSGOH2ZGleeh1FrxBnlij5N
 L+aKvR468U5ysEnS94v3NHoGtDMWWjRnzb+u9VK0mfd9JnNJR635yFFl7AcL7ONr6TpxJTgIN1F
 N+DXQ7Hx5aKkzhjsJRJYXF8KKsXlSZAcxeG4W7FnVWE/+Sy/SZYeJYsnVD3bK9OZhZ7QUJI8xqM
 psWuoaYpF0i8417ACwnxAky/dwvVL6gvk0SD6pBKor44I+adZLkih8t0vEA6R8r7pwZC0Kw3Dw1
 XLbkEdsoKLR68Hq+HjPmVXW9rGs9M3aC7mPREDnRFiBjHau8a1ffl48B/9FcxfqqgX63D/tFERD
 jtD0DhzI3m2HiIpSxE0b0qcMqCxBhDVaQaW0HJ4mhrs8N+GBpTTymIcebrjybuYBkHRFBha0yab
 1VYEnIfcZdnBF9KeXFrMXK6JaiEUR/ssvzP2BOVscVVc5JSDfflE1Y7d84w5OlWFL9Je/Ftcdbj
 rYgLxRb84Hq5/Z/umLdbXXLYwuOV8Ty2GEA6rVamCTLqhaXCIyf+XGeZDOEzPflDG2mzI0myDKd
 TnKJJfVoM7pMhZ/qbe6WDJmtjZ3qI7PzepIIeCDtwiIiAOdPR/uoU/36BFHmyzRqClhgp1yFgGq
 5JWMfLLYOHRNI4w==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Queue-Id: 69DE04000F
X-Rspamd-Server: rspam08
X-Stat-Signature: yxrryi737z3qiqagtbo3mnez16tfg58a
X-HE-Tag: 1772484437-475681
X-HE-Meta: U2FsdGVkX19VD7PyAMWAcR4rzbjr1yT/HQz7x+V/fEm7gUgARbR17skJKcd3j4QJd8uyGXwFlE0iw/YEHHlXisYC2CNMjjzf1KBSvg37eWF1tjgjKtYL/r42344kJoP0k4dXiDFmgCslav2/lavuwg7nIoIfDuvO7G77AhiqhT5+AuT8Z9uNr/jnRe3e80U5zJI3cwBKs7MXulSY/lUt7qsOPPRvV2DfdB/N6vWucj5O5qIdWMqful9FmHBPifrIxqoxJiyEnFIq5qY6HiY8+QGPn+9CJGvP7aCZeoZqiySgaEpP+xyLCiMHEhnrhZ2Ly+e7MlVG30orTIELeTmkijhNNZKAGcdmvvdCUvTIZ/dIzuaJ8oZXHpxXy4oKx2hhy9FDhK1zWBD9Ii08hbcX9tw/DzaGfVrEc1PRY6D+Sj/x5T94AOq/tLblYlqJz04kldOIE3WGEJRig2SBT50SInHzLmuY3cSpJydEcyoCb1FW3yTtTLLC5g/e/+hGLJiUg06a7HbEkc6K411YUNSyKVdOQ+W54gK7jcIifJbS+OiTb9CLFetv7nE0D3MoIR4X9KgDYr8zHmrfWbbcb/nLCmxMh6fMhEIhl3aTFl8tEP4DuK5L0aUxxRNYLjQKTvOwGfFuwIqvOqPYUNUekQIFdRRqNJB/RfUEtNCX5Nmq+BkDWBq9+zoVhsciOKggQWiyJlImkzsrdLWc7S5Vf1tDjYWEaPYfwAUojqC0EKuD3kbeg+Mkhkd/6zg7PNNqvU5QKFra4aFpx3JcKyb5a6Yx/aUyyd8Iaf0OwxbbtqrZ5oHu6PyHAFJoknJQ7x4KOXfyH05QOqSe5GO14wsc4Hsxc9lZHbq+kr/kP9KWTo9IOEzLM6jobzrXvaI9qXwNMIgd8iSXcFrfmd0oT0knIEpIzpnbMtM4HtS1xLEFZUGJlDRHMYDOo69is7fZlrf7naIIhGfH8kNdhqLSYn1Ytl9
 YhbLIIHm
 QEwaXYjE7IJvq5ahfL+R03hCF7ibopPFunMZgyppqI7TZl9y9yHPUjsl/nO++eblOa9iEO66VsgGhwqt4XsWv4J34S1wliU5IzOLyEkeiq5U3UiRVZKQA+uSR/gKyFDfNseG9dVTEHNxPLML0VfLudM+Bti717GtFGi30SVl9FG+HKVXKnhxuuUyNhEFpBf7FK1WzZVFzQANm8XZYVnhaJCzTQAOcHJprOSftnJr+Sg/6ztrMMLG3A/ULx0lOJf6PD0YkLFQ+p4Mg0MMXYmmRiGgUoH1nfpoLR5XN9tPwwLJnQgqVkKU3kvHgofUHe/XGf6egyaRECvYPtuzJEBSVgkWNfr+S8lkAJxVN1DoKiuZFcflTqJki8SJVwhR7MkU7D0DkVEsKrZ8Oyk+2N4XXSQ3Up9ZLIiyiTHQpvXmtIkrkuht/WBWXV+taMq853d2Bizr6bIubyz9HjfkGUY57lmzfuoMW1JB1/sywKzLBtPP9vfmyzQ/XLwPipBz/PVo5R73fUPcXIuL8s3hLEx80ppVlrqySL2SGawLpl3nA2DhfNApxNsHAPD5cL/ZEZeEMfYEG6kytdN09U3jsSny/I35x7ARpOakeNdA97lvWSrSSPY2GR0aKQVl/yBt5rajJ65aimo4fcncRMwYcAgAYpV5cWudxyLLwolRKbX2gJpy2V8dbPDQXVANY/xmB2d8cNdEmwdRyspDTJSMWFkwkhaxmbIt98B4bmE0Ics8LAQidS5BWI9QY9unJicyrxKRnOFMYDe5rUwl1vK2zXQhLil5FnLyab24Ixa0IFm0XUDRbKLVGS8X6SvBHQs8c+eLYDZySzkdredF22udJSyIVs8rNPIjb4xqOSZXvSTwSQ1LwZMytD7a5SFcaeVQ4geb4ndu0bl2Wrdcb91Azt2maR+PizWgZpqIk4aCXZhNL5HiOSS6DwmArZAjSh0yQlqKqBNPVZEvW3xj6RmSwTYZbfVD5BW6Y
 kWIVoHLa
 bfE53T78HEhgfgxxh6d1o+JJMVB40PFl2r8EaMDMkdUrpQHtkiKaWHv+1LL26ar8WG3D6JhvUtcHxbBCv7uNR2w35X8evccRRdWeeLLD9XRMl0VeTaKAV9XtXDhbIBQ9mWWtjQ9FmQJkV1q+oRHRY9Jl+ZYK+mk5VXfE36Uz6GFieILc+Cu3rwhLYuWit3I4KDxGpiShqR5vUA+X/Qvr0km5L2thfCuIgaVP9Ca/C78v0lnWpRXqsx0Z1pKEJu94zQ52RM7ft6sQFfI7p03LZkqzX6k5gQR2cXXdcEQPIGpI45Of1LOGV8js5dwCGsTY8EF9xAZg8u2GZsc7RdhZuGHl/q+QkkDjE2NuK9jF10buY5kStnleOhc5DKzTg+V9hmT0vfd4v7kQZ0ooyEgr0R7/YjA3izM5smHu3LxPZjRsszsXrUlyxIMtWSgjKXMFBa+1gSlQj5A86/ak+1RD9R+wpbPracfiqouAq6O2zMmx2KZKdLQANpal0X6l+HisteUnxQZdd312KvevHpGSBqF6eEEHeUn7aU6K0VwJnquASQ361iQTUAL587F9kl2wqvaejZPW0JUTZ84vMpYp0h6kHu7dwcsdmN+9s1F9QbUPElAxqn+uQ/7RcMoDH/+QSrTzMU6kgtbJa+Fhhkka8du0fZlgZJB6iNZZyjovwvmOsfBNtj82SvA01mRCgGAbPIwBW41iALuJlvJZ+Y/j0EgC2CF5L4+Z0COTd+/v21bwW//Hlv/vKoiM5Ypk/pLMeMIGAzlkbyERfbJNCSH4B1wcbHNBoKa8GRL1RMxoSH6LuzUy9n6TVHRA/EKiWp7+OcLr2xUnUglqlAfy2IpKGWbkm2fzRRDA601nlJiIluPcolRzWec0pNT8JB4buhdcRSkqgj32yx0hZg3JUxa9yiZVhkGgY2SkGtHoxVk5p5lZg6dJa6HPnqPNMPq5eep4J9Ro1JQNjrisym0yNltMXUpSs6+by
 c17NzHlt
 DTTVCmIPW4xc1geTfnjlSZ9IMALJkmoFu0e+ivdqzmdTa6zBISwWLq7pdpfqSVqhM1h950V6jgZwGLJH+0IKB8dURNESZBqyohJ2uiuMbGSx+oLMHTuaCMJN2AN3xY1Bmrjbsg5yVsrwtjLGiV/XYq311nNMDiNqv9ZroNHqK7D/BpmsRdUWCnBZkL1nQtxOpnqHvtNPzJqjoETdY0VxEAQQ06EvAV6tZBv/89TcdLLymGydmOYeIw5WlSDyq8hJf+mTFkfmsykfpLP1aduijPZ7UvKxzn4Um0at94TE4SXOFdGlEapqUeeccYSO29zX1navQE/xtuefJvdvsF7g9VnFo+felSpScbMqJewaBEvb2xRwH3f1GaBVUhron7+Hsyt6feDIBHFBUfbGNNrKZxLKl9ovcHjQV8fJ++1NSnI5732npsneSuMCFiycdWvIrEB9hNgrmvCnxeFkF2Fq0mfJZpL9R6UYF4Fd1DVUrTzbh5/1z6oENsgauim8twxNDfY7JUnbh9BWeffR1uEpERl+Ca9bGNZYHYbk1KQu7Xo1JjGkvrsPoPHprUQxxz1cnpHCxPGTNZGkRZki/6LOMrX5s+rakJLJxalJfCYW2lw6Hv6MmQh6JO4ZWPfvwanvUNwCU4EEgLQMNwTYhlXsi+V0GrFNcFh+il12A0c2F18IeM3UCHz+w9230THBrTnqzNNnyiXvEZL42/7eVw0Rb4rXRRTsVgYtWXl5m80g+B6hOasubjJqZpQiM2T3HPDhpu2qTezvigN66QD4/BYOZpnC3F36StQ4OCfM6tEgG0Nr3fVsKiJTudJLv98UDaSM6T9QJKMgJn1Ch6q28zqtQp0c0G/NcMKSD8VMeGVAggcV0iAenlw9rl4M+h3MhGCTwq2zrNCNpxSATjFYNLDwnZJLTT1UEEnjCiD5NTsT9wAkRD0r5ZJ69QUNCJVpzM+U+0novfCs1eaDQKWF/ZE4r6hxrRgEn
 woGeJMcR
 DR4DJJsE3KZnQe2VyGSq7x1wVUk/rcprpGEx9/EwRyaendNEFUr0MW9kQrT3BjcqI9cXPV2GxY0g0FVoKtd47f0me9vEBpUIZdQ//DXEqTXGJrdqUdzZYywSTppDPwYAyA4WUcsV31tT42Sr0XBV/uBiD71y9IwAaZIm58CiomtbQg3FmqTdIEhCsEDhS7DLaWzkdzG0PbqP7p641SqgPsEpGwaIG4uquLET4KEBu7y0Qd4bTb1kBzXQNWwWIfo24SJdZu9h9WARWGV6j1yzYtpWXWqijsJ/8JhgcK48zDFH3+zr3lsQqMyg3HcXQ3o3BV1T3/0ibtRVWe9QklMRPvV7MdkxNXCAA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in orangefs with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/orangefs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
index fc0b20bd1d37043461bd2768e9155a763d3469fe..9e8a2a9e5229861a4976d67483a0f6452048f86b 100644
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -1062,7 +1062,7 @@ struct inode *orangefs_iget(struct super_block *sb,
 	unlock_new_inode(inode);
 
 	gossip_debug(GOSSIP_INODE_DEBUG,
-		     "iget handle %pU, fsid %d hash %ld i_ino %" PRIino "u\n",
+		     "iget handle %pU, fsid %d hash %ld i_ino %llu\n",
 		     &ref->khandle,
 		     ref->fs_id,
 		     hash,

-- 
2.53.0


