Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6766EB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:39:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 559C26B00FF; Mon,  2 Mar 2026 15:39:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52E6E6B0101; Mon,  2 Mar 2026 15:39:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F8E66B0102; Mon,  2 Mar 2026 15:39:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E1906B00FF
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:39:26 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE0131402A9
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:39:25 +0000 (UTC)
X-FDA: 84502288290.19.FB8BA4D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 216EA18000E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:39:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tWGaH2eI;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jhPUTG3R1Fvo2d2ysd7WUhjCBxIL/fOXQmjd3T4Sbzg=;
	b=kB1kNNAa9HpS6e05OK3wruCQBlaBZLipjIIwSSLFv5noDChtr9U91G8K4TkAp3h3iyRZV8
	TRsDdJHaYEgZLhD0ennzFHv6rhNoUDVqNkffZwO7FpxYSnGYbL4UQ8vrWWf3mz/+hCRQ4a
	IjTb+rrmrcWBOg1MXRy3eYc9jxNxxKo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483964; a=rsa-sha256;
	cv=none;
	b=Vp/L+zFuQMZedEIx+xuC1F/5TWYgNTP+J/NNcuKP6+qWW2qaLKukYmtVOwk9ENTEaCz3or
	lOBgZjgTdZ1DYSctRrbqwPk91CwtZJjXvwXcAnQsQ1x1nBjTkeK4bzRL4y5IZXrCjFAl/6
	EeqIVH+nk67xBl5G4vBxSHeD7GypG+M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tWGaH2eI;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E2CA43A76;
	Mon,  2 Mar 2026 20:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1720FC2BC9E;
	Mon,  2 Mar 2026 20:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483963;
	bh=m5qXv8LzTjrrHawpXG4FjY1bAed0fpNbFRdYn+t2iRc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=tWGaH2eIcCtGq0rj5uXX9kFap7NkcKiDhEc10PxrY8ua/QCr9LbkB3Sb8J6gOA5Dq
	 dO87Cz7Vne8kcK5oUGLznzZ6+roGhrkPGv6EMOeBwhlJXNCXfzB1dIe+jt05hLfts5
	 h56xMnhkZ/tt3ulE6x9GDMS/D+zAOKhV6LMo2SXyD1pO+aCyJRZWsU991uJKSoZuYa
	 zzw+Vm4VqQAipdWITuMMIITaAYNjGaEd3YWaHeRsvi5qHCFOumortMStpiruRHJTib
	 V+DAun1eGMXdM+R62dFYPRbH3sIjSUUi9NTfRFIFhbL8xUM1O9+S9o9Jpv2xJ7OsAm
	 blcxJcmsMD34g==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:44 -0500
Subject: [PATCH v2 060/110] vfs: change kino_t from unsigned long to u64
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-60-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1545; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=m5qXv8LzTjrrHawpXG4FjY1bAed0fpNbFRdYn+t2iRc=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH/CelvtxYkmubgwQL93hbaaeF/Lcipca1TD
 nmG1ZIz+3WJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx/wAKCRAADmhBGVaC
 FcekD/40SfgYN98/I/iKb83ETfOTpXWW+m/XTvqQjbiYJ0yb9cGecrukv9U+LuSoCRp2F8qjaEG
 KwSKcoNeD3bLi8YRSx0Jo55zpvV+0GEF5pYMsLyuz2mgss7nYEHu7KNvJeInMOxwowpPdPqRNu7
 Ppq1dp/1AM3AymC/FXqtq2Tv8HTmfQeqCuOp/6YYnMJFIJhWoBAfvpsQTSWM9HY1SuWEDoQbE5N
 2LEftI8/pUeKAX167/iekCZsEzvYlRky3lNIuB0wQIW1djQpCAugeGhsaFp9AZWL3zSj87xiuO9
 UNszqAcxPs1LyIDZmw2MRd9bSJ3IQhQpaI+4Dukg4Nd17YjfU1riCW2fCSYtV8+JCExOFPFNCxZ
 fHlcLe24YBWqG/j0FJfWiYPh0puc/2EhgeruwgUAW3dNz41A7H5gyNzLLTk/G1j0lt1DHq91uHg
 TbL0yQHkqQ2yZgnf9niLxrsdMDgb4kc9TeNtWlwf12yQAsLX2pvxob+xrImW9RxTi+fTWwlIxqF
 e2aTVNNTvEQe/FfANNViNtWa2//y7pcFg2ozKI7hHopJ7lhDIrFuzmUePxlgKpPeyxWO9eZGLCb
 9/qek6yqPKgzxPKPxMFaxLl8qKdTUtBKAWaADTleXG3rC4d+u1Wt4aN50RoaFgA/UKqBF1BWrAW
 881Y6dqAC+vEbnA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 216EA18000E
X-Stat-Signature: uw1smmcpzwz1gdghgzp34bejmjj4prhi
X-HE-Tag: 1772483963-501280
X-HE-Meta: U2FsdGVkX19QgE9CPOIeVpqOOXOBZ1q/MQIMniKtHKkiBfoG+LbVt1ru5Pnizp6dOejMDXA9PGCzu/oqWHXlB9H+4aYMb4zC9YawmLzcTJmgjWwGUSO0Qgk2hgSxf1O7MztZVb+DSh9PPfeSH6xJ3a98kpEzQ0vORJL6QH87cs+Xxnd/zmqSLWOh8X2PA1r45+AUOaJk4P1QjasT51d3aOP6SpjZxjnnCOh6f2hsES8EeQsBs/ykWr9quBg102j+LW4nrB76yUz6cvlvV71dFI/Z9eNLI6JIL/EpV/SNsbt3rrZdecTHRF+NkSCQnr7ReC1/AyUsZH1L6E/Pn3p3hv8YLAoNaJyFrob9/nUOxoFig3932e8Pk45JWtH5yImER1MCKlexZTpSmJsKZG4+3tpOQiRag96rW5yySAnVLRnnGl2wQePo3MeyL44W2ZxrtI/Rimr6g/dx9M9AF+GJGdNqvdRLutPoHD8dgLLfRWQvTVWa9pfbw2c6JhR6xROqdVr6aDDVAf0O6uImJ2IVWtaiHfdwjfibHbDYLNb/IexpMrsd4umhxyqtwoMRGm/wn5GvL0BTy9HO0e9UCQgL521wmRa1SXYPrSm9DAOLnwpSp8Wp3NzKD2qeQG4kV69XWgNcRGdiwNytaRx66erMvZHoCGvTpDwoi1Bthsb0sX4AM1qHRcPOTMLSKg5uRLD3vscT0FWIfcF5/3hwO03Ul2QuOOc9iKKTXYuV063uKDh1TUsVJqLK4vP8ZlY1FOLuTxif9vv5oVF3tq3K0/9M6NYh0of1xG03GE5O6YW+CGlFCNsgnSdKLnNmU1OzSSi04vdlcbsk9oMs+Uzsd9WVZGGnMjWu4nYhE7ApDNg+sYeG4ZHAUAkHk5wjNR8ZCL+M0mQdGnZ4PBP1eGJk4aGfQxexOcptxnjSf81OIGY9GwtZVKoMvP5vAGgVGuQTsq3trl/v8nV54qc9LG+vCc9
 sverVqkU
 VKr98L9hQAnsmRGhLYGTFEkV7mhA/62npXmExA3TMKV0qwwsnLpjKdeTSAOIbZhuHPlWSdc/82+bjgi8v1gKUQ5u9v4+F+Zrob8Hd4BdK7hg25ynEtCT//CkEg4HeyYWa8YWPXioHpdIwZT1OlkLSrC+Ngd/Mb5QDPK3iXJkr9+OMpSE1Qbt6y1sl80Cjok2KixKn9w6jVK8Ko6Mx1/L8SGEo7L2/DbWIDOzlTu5w57eHSPkiLjmcA9+zAELP2YeBpTu0W8CHIF3GR9X73PlR58XygmarVIvIguFfbenyu6RRJ3mULTI86GwwCwhL8G3Pu9Ab17evPsabWU/lJ5TaBwbwLK9zq5mXC5hGTiAQrGy1hFiMWNZEuM3CQUFBsQ86yBp1sRg64sBR6296rj5VTlMjpGMfY1PHLkVrL1IV+ZARpScaQjFjxULj5p8lWj/DERshTjsi9f+zcKEIP2LUbKBmScoa/ajZ6+p4W48JC/QsmJ5OrXpQLFFejNaSjh0AzWnBWAGW0d6YeXQs5tPyKHmTt4QjEnjpLAbm8iiyCSJwPLOmcud/UiZMOMM46lExLw4ZGmiWJLGrUn/7citgiyoN8sCUWQlRlTqMbua0ZaPkOpXOaHwoMHoEIqlN/HszE7gx75bwVgH+EoHpVihVXPkgdQ7qv3lR2Vh4R/XZyDPK5UzVtminCvxSM8ozrhPkQY79FdTb2buQvazpSd4OVlO+uIRBPwP4+WBdCs6VtqWPmC6nfI049uG5hNakQr7Xx3YwrEml9lHEBQNLZJRmOTUFbUoLngR7BX/fZFyBGigR3lcR5pxa9YVvh11FYECVQn3ENxRMI8WwkTnSWXX+NVC6nuJOVahv+ox6+eMsr7x+iH+iVT0jBHcN4eYC86QtlANlNSDPm8hyYcfu64wu7H0ZlGAvJhINJIbTekGwd0odw7yjXADeK2edmGsjGTwqHyhAO3PRXPfqxngGy1BNioaS1Okw
 laTJM7FL
 Be+5EmfhOjZ+2keINTj+0h0bdrhtazPkGMD50obg4zMM8zagdTiVEjMu5gQ51jpUFoy9s0TkAspnIxjP7bwW31ZU1nQUhk2yRlFBBAvHuqz3Mof+4TflJ2ucKbxRlcOOkcdaS+VYNezR7+A7tc34mIIq6jQxn3Ygidgf+qZhxDTJs364X2isAEAn8YQhXyCOW+k7WFOju+HrCpi2VsJ1PhRDOMKvDfGZ727aFfgRru1dELINPplpihsM0iMwuwGCfm4l8KQmfum6pmAqJHWMXKJydetCWn+gbku6MNxKrYLRQ/EaO2w9qMODtLa+gmWZEirqsEBJVJML4nj0OsKSZJfHiceGLOpgOKxmw9p+nHwyNy/JGhdFE1eMEv8u57aY6xmUcrOgP3wZE4fwQLIM8Yextz6LjueK33nnfd2cxxTgZSxhKS7x/1sFmphSsX6npBF0UXjw6EN9VF6ELe5cHKibIo0TuGFHAc11893EGhv8ncMxFzdiLsnHxMPEonKOX/8t2gwIYIH0VtezteFf8Whn1jpEGZ/psEj9yjWAJ+o2V/yceNI8dvZBmVS54rIEiq0NEFXbDtRYBBL3pAx7bPMS9fQLRyBNoDeNJqzqYDcQpKm9GnCmxkiZoWUAG6B8As8XjKVtKkqmDPMLuOt8TaguWE6FntPALAPdbrhIj5Wr4dkK3FD4lzYCaZNV8kE1tSyladaSG+L7Z16r1YHdaLDgigQLSr7Os6DMVH0yhfZV9LL0Wni9FKW0Eg8bLwrJvsi3N11mQlu/11PgZHahPQigs+U3jd+HeChTyFlBQ61woQQepC4EnaCfLxWvpXcimvXbbFQ0xIpGiwh+hKaD76Lu1GRHNl13ogKtKJ8q12FVClSs04D7FDY722IlhKoQJcCNgvXOPJxW5jJzusItXVLjIK4+IzQoKX4Knfb38qI02OqJC/FRpurKqwmRpu1quKzQTAy0dTofCBMGhDWa44EuyXcxx
 wfP4n7WF
 ZL14jGSzUMDEUwtOzckD3UAOuMSmYfAPwCh0ER1gSv3RhKc/hAjZscALm8P6Z0Z2Y4gldxoZsR+bCxyYjrwM8BTiDEQghaIq25JTeiXj+NO6YDe+Ovd7EeVodjvQHAKuh6it55s0eFRj+8m7Uxvi/RtpRf6fw4ncHp4EbenHxgAVlV3fjAt03o5K+ZxrloDykPvTaJDlO226S65Z3A1Rl1wK8oP3gFZ+XVl1hOKpSBWEZQ7EHTYkINPHAtSPOAlP6m+/6qiYVmgcThgYbNvLmr5pE+xadVHGhjkrVc6RX6Aqt2YZBBLs6iOjKHWGr3wcDAdnceabKfzbuF+DLP2Wxz3LXHtfvZiYhf6jJWHjYTtabWP8NLkOQth5m1Gp8N92oF6OGKDD5vqbSGwSMKf9xVJJUftBOvy+tpTRfQaQm+zHdFNDjks36BNGvx3JoP+Fp2dnWhYlSebxGbrgv9QYOdHI/DoW137GeE5HcoakhJGgzmVU9vMXm7ZpxnHX08TC/7EGjve76puxTtqJ3qbBJDQqn1BUwwf2YyMEZM0GidyVukDXxb2Jof27Ug4Gk75by4lm5ILndaTK5rzoC21a1vnoEtFxSQCiKYTA2Fncv9KsGSBUTQEqV4Sykr0LM5CM/5rSbKodRCNvO3VujgyO6q0Mt3G+LVoh8ga1393vmDnNl4y4Fk3Azf5HsiBD29bbWLGbzJ5HZTpWGbvhzktOHFxSYdXInCNRgkOWSJqzvdyZ1erezQvCfz+vKjgt7tMCEv1FPSumGJcOlchj5MeeiRTDFrp4VBVK6D3/lSO9ssPP0QV2QQTLlDZcs2crJjwq0Pm1UUK3Wn+PISZ5g1V8d4wvVwzOgnv4AUbFDhsDk2He84YerFwBPFm6luMkeJMMrRZgOJq2IzSl58B5r1thTqvCOLP1GIbX51p8RffN3LrapAh37iGAKzX+rTBfIDcS+dSWMjp03OSdtFZoOkml7+nPV5JTc
 9ISu41Iy
 CIMpPyvBF0++QPMXYIAuTDEf1HmgW6cVo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change kino_t from unsigned long to u64, and update PRIino from "l"
to "ll" accordingly. This is the actual type widening of i_ino.

All format strings have already been converted to use PRIino, so this
change compiles warning-free on both 32-bit and 64-bit architectures.

On 64-bit architectures, unsigned long is already 64 bits, so this is
effectively a type alias change with no runtime impact. On 32-bit
architectures, this widens i_ino from 32 to 64 bits, allowing
filesystems like NFS, CIFS, XFS, Ceph, and FUSE to store their native
64-bit inode numbers without folding/hashing.

The VFS already handles 64-bit inode numbers in kstat.ino (u64) and
statx.stx_ino (__u64). The existing overflow checks in cp_new_stat(),
cp_old_stat(), and cp_compat_stat() handle narrowing to 32-bit st_ino
with -EOVERFLOW, so userspace ABI is preserved.

struct inode will grow by 4 bytes on 32-bit architectures.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/fs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index d0c4789838b5852111583a3e4cced88999496e68..4193817e02e8bf94f29514ca43379af21f37ac61 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -758,8 +758,8 @@ struct inode_state_flags {
 	enum inode_state_flags_enum __state;
 };
 
-typedef unsigned long	kino_t;
-#define PRIino		"l"
+typedef u64		kino_t;
+#define PRIino		"ll"
 
 /*
  * Keep mostly read-only and often accessed (especially for

-- 
2.53.0


