Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61170F01832
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 13:29:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B87396B0089; Fri,  6 Mar 2026 08:29:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3E666B008A; Fri,  6 Mar 2026 08:29:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A13556B008C; Fri,  6 Mar 2026 08:29:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 90A576B0089
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:29:41 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62C2BC1D91
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:29:41 +0000 (UTC)
X-FDA: 84515720562.13.F784140
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id BAE0F100006
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:29:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hc2G5bkz;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772803779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XpTZDkunlFyxmfIXgOxQ2HnHXWHbgP4/cMnNycbJsh8=;
	b=edngBF6Mm2/uDElG4CwAv4VEQDGUtFh0IJ7ti15ls9JPLSWzaE4Y3r4S7bszSMBUfuGX9y
	Klgl3lRey05ys0OHYGQnCSupoehcIK5phCd7DmsstXTsv9e2Ob2o0SPAPsWevvFwwxIpQh
	PVOBSuJ9h52eRgx35t9SVMmjn7LhJE0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hc2G5bkz;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772803779; a=rsa-sha256;
	cv=none;
	b=jx+dr5qCl3X6iupwV5WFgQalnyaXMF7+ZQwfCGdCv5ILEwDHWUidAJsmCleU77Fug2B1fk
	th//WNxn9LW3yZOzFKX4sndhQc4lSjR9cyGo9vD3jYl/h/h8kB/QHWD8/g4Q2RQB+GyQSm
	fEmIuB91Rg4H8VIz/GwX6fKyCnXkTUs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 070F060133;
	Fri,  6 Mar 2026 13:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1A5C4CEF7;
	Fri,  6 Mar 2026 13:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772803778;
	bh=1ukMkvLDsKaYNY9i0ldkaZ4BWaGkqbXWQ5bDJd35Ruo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hc2G5bkzknQkHbaZAs4y3XyfPC7tq6CC483Y2FuPeJaJ/Ep5xih+Tc66Fpb+BwZ7W
	 Bez8ORwfCmhbe6g0HU6oZVMi4gDWQhsfbyaFq+cVejhoWgnukuID/RZMSHViAcCVrw
	 MjS/lDOASjuhPRZUMZ9AR3PHB2ay8/WfzKkLOdl1k1HLi42nbvUUTkPfv/+Yy3fjTm
	 K+K4W0dOPAbSzctZ86TetwW6UIj7CcluN5pzHcCZKjAogO4Aasoss2NuBYwUN+09zw
	 d8oApzr6/okXUUx7r5/Swj0z04/dBdcsRq0mcjW6ZaOab7H/RmnzywDdyIqKNlOri8
	 PH0xKh9i2soEQ==
Date: Fri, 6 Mar 2026 14:28:59 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Dan Williams <dan.j.williams@intel.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Alexander Aring <alex.aring@gmail.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	David Sterba <dsterba@suse.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Ian Kent <raven@themaw.net>, Luis de Bethencourt <luisbg@kernel.org>, 
	Salah Triki <salah.triki@gmail.com>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>, 
	Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, Nicolas Pitre <nico@fluxnic.net>, 
	Tyler Hicks <code@tyhicks.com>, Amir Goldstein <amir73il@gmail.com>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Yangtao Li <frank.li@vivo.com>, 
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, David Woodhouse <dwmw2@infradead.org>, 
	Richard Weinberger <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Anders Larsen <al@alarsen.net>, Zhihao Cheng <chengzhihao1@huawei.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, John Johansen <john.johansen@canonical.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Casey Schaufler <casey@schaufler-ca.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Simon Horman <horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Martin Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>, 
	Joerg Reuter <jreuter@yaina.de>, Marcel Holtmann <marcel@holtmann.org>, 
	Johan Hedberg <johan.hedberg@gmail.com>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
	Oliver Hartkopp <socketcan@hartkopp.net>, Marc Kleine-Budde <mkl@pengutronix.de>, 
	David Ahern <dsahern@kernel.org>, Neal Cardwell <ncardwell@google.com>, 
	Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Remi Denis-Courmont <courmisch@gmail.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Xin Long <lucien.xin@gmail.com>, Magnus Karlsson <magnus.karlsson@intel.com>, 
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Stanislav Fomichev <sdf@fomichev.me>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, fsverity@lists.linux.dev, linux-mm@kvack.org, 
	netfs@lists.linux.dev, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org, v9fs@lists.linux.dev, 
	linux-afs@lists.infradead.org, autofs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	codalist@coda.cs.cmu.edu, ecryptfs@vger.kernel.org, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org, linux-hams@vger.kernel.org, 
	linux-x25@vger.kernel.org, audit@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
	linux-can@vger.kernel.org, linux-sctp@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v3 01/12] vfs: widen inode hash/lookup functions to u64
Message-ID: <20260306-klauen-aufruf-3f79ec9cd4cb@brauner>
References: <20260304-iino-u64-v3-0-2257ad83d372@kernel.org>
 <20260304-iino-u64-v3-1-2257ad83d372@kernel.org>
 <aamSFgXhrORAJLBC@infradead.org>
 <c1845a4b8d35d367953ac6cbfcf91ac36958ba51.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c1845a4b8d35d367953ac6cbfcf91ac36958ba51.camel@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: BAE0F100006
X-Rspamd-Server: rspam08
X-Stat-Signature: bdtgji84db6m9rh5ogd5du84hi54auoa
X-HE-Tag: 1772803779-760356
X-HE-Meta: U2FsdGVkX1/1jLa2hK6z6TDqYvAJqe8wwMisDhIi3ouAVhb4iRNqqz2jsCIEUqiNNJ8j31Wx1TloDnnbkD7YFOAa/xbg2IxSExrRuAzqBJvVnQ1vJKKWuH4n3NMdfkwpQmXYsFBXxZ1yk5SNNma0bVqltPav6Ckn3Z9s0sIKuVXdx1aQqPLibJZslZ341rfLIUeU6tNknDovDNUHK7PQnqAiEubj+CFclF+UiUUb5bJRPa5KiZHb/dVx1tKLppyTm1w/W2O78dDXDSc49GSTfrDuPA8PWQmL/IhtyXhMILgXFk+DGgyHHKYHbBFxgVuqPoTyrPV7szKZSLou6QwOFobY3grDOdO/53ZSJRmhiNyjlfsrz7ISoyN/GIJTrpDBUHCKJ4n3xNUTICRFiux+iQU2gP5OKxz4kAnRi4nAKUMSrFMlqvU5qpYFNU5gjnY3+FvQe+FCCyoVyhigT/M+cfqF4y2mZp/1uknQ08hMMycMGjeQG0oQ564YcoFhLaQx4scVBuG/+ymNprogxJRk9I7uAwgjT618DGO5dUZw2ltINuRNV/gIwWQryk4kutqA+x1At1imTBXziMjmok7DSgXgKmnfGHQ9/OyV8EZbJiQo5CjGK8R07cF+LvZsFVseKX8G3zwTe7ri8rCP3IzxdIwmPS6iUtm91rF54ulfgoFdKWQyy5iX3CpF664Eg4+hpPUI4ocVR1t4a3EvGn+j49plcWMNSgW0XJXHTmtnhXNI5Bio6hrDw8l2OrCBribe70HrArxSk91CSrTBsJZa7+u7+5W9YsJ+C5Fgaj9zxf/7lmxfvx+cf65BN4KyeWlzx0+GwpXfHONpf1RRULzVUaVAl+woGzbNsJtsco/eTAt06hmqHxR9aYKLKRh8zCIzxQ3bo+xIyT6t3OrLKRqvLnllgPhqLIVrAkwRamm+EWpEuniRSk6hVvscwP8DWmJv5rgl0ojc3ozkBM3fMgk
 Zk8FI6M5
 HPhLlj6pa45bgyD/E58BGECdrbxMW+GIrw/MMGMcQskzyKvYvSeMy9DODsMy0bdY+eiXQIFY15cE2zzE9S9IxxGAkBmSq7IDhksdlUz28BFB0CLTGFNj4F048ewwP4kNV9DfaLzDXZIQFAVQA0Wh3/QBA7D7ZrkOY4IjEFluP56KvMLxgV94tw2CaCyUME7MRmfn54Zbjqd161ZX2RKQTAyZmhMGPshPJSTOSHSvGbLckGXgpQzTlMzOIp82XtHjlJ7d2FZM5/JcYRPbxIxkW3BWCqWoiTR97SQCqu1gWdOfLY6+AtybcJgiMl287tPyiC0iZZsoLoUCaR0RyQG3/lIfWrDKkzqGGxbYUMNg6id7Fy/XN0Io6JrdANC0PtgAqdoYBfJeAez4ssjDUTbogD0qeVEmCQmkrfkwLnV/9X/aZAjXdFZ5qo9Gy1JN5lopVz2DAoyk+ODBn49zLMPGfM/mLNsRR6CuN9bO8obOfbL3eewXHl0xUWdLJNQA+jFltmuN7AvU18T7jR1GnAI6/Og3RwW/mlp/bdQG2niStumaGPovjTlRhzDu5rXWqf4/AbxvrM/4tTBleg76CknV3dgWxMiqlmgH+JWpvVlFDnOs5AaODe5qL+S0qvfAiZwBZ/WWb4KNwNlpUcMXGGYZYqH7fGwnF4d3nTr/ZSRXwheRrDfpgUeKrtSRV8ZNrksv2WxXxaXC5b4lQzuYIAbhI9CLn+QE2dbzT/R0aGkgN5aXQUuYj9ilFhPPi3nKrIUbbI5lMQ2lZ2nvD/ZEgqN7d5tUaJSFNK8zuRh1tddrK/38beFJOmzWl59tf/d44z4sdRQI3ixfSmR7HJoA0EWV2f1xQOLV49apukjuLXPJwd2He9yBStWMUShG3CiOD5VEfnXUKoAMTYiAhXLXBFr3bVV9rc1uZ3dC0EP2aaXH4NSLF4GPtnbo5xyrYDhSCOVK0MfUlPPJbmYrU7e4bFvowwzFxaf27
 6fxsH4st
 Ps4DsUKp8DKO2j3c7uBQSwF0josniUHySEJUG0cvAUvGVdW+2EkTdr6/LR9wE2cErVH7rjld8MenNEc0kfTClpuuGNBuh3KQg4RPyCsoSBktANebvK2WCg4i5HxI0VUTTIrnBi4XqPK8HlG/iz+4kABxWPecmdjGdzMBYs9lz0iUoXiZAfZKpsbqR0RBR3BnfoHTyC4xuegCJRksh0rSKGTMHgEaBY4/gx0/3yx0m2HTQZG66C5IjxHeM9gOJeWJF12Ppv39Ngvs7FbGaEOPRZ2vsF0qW1zrshyDTR79ByHaMLzUdjoz/x7z+4OWpkso3Ie+SL7omob1xXZr91YjWobBjMEOHYVp3Iqe7TtzPtOChWZi9b0E17XCNH6wxkeAG8ChUGXxg5ndaJYbQoFHCxgAbxXyQ/kpBE6dtHVfuPcCHuM2trgWeT446CHvJoW7Ia14120iEkjGiiwT400EdcQBCmvKllPFAE+wgZUeIj5NFxktO27N9ar4y/EcdSPAmAP9KIDugScFBmfpvfi+97yNuSCUPFsRGUtbj4UgywKuoTXi16FklwNv5WMM/2HyMb1PQAsbPUeGf99jG656n3fyS/pIlHCGmDUMucRtKdfYV6X/PBWtWKlqoKYXMhv8MvoZHzo3Wa/66GYKQv0g9iHnw4qYgDerqt6mYcwYeSBv+sfoaC1vgTAwCx/XihlXDttac+pKX0qbKbv0Rf9PkMtvDQ+K1cc6RL0zUVihBtul6mH4uLcj/I2N5LeYJABknDH+b42YnWQuzAnRNGIc48VlrwjnHod6Qrj5Cgua0G4YuE2uQaPE81rvIRxE2TosKAE8zkgU5shi7Rih9UnFCm7LmbkJ/MCzdUnmeiviz7x55NNZq9WlVEA/INjc4RCQjzp5mgfAv+VvLWrywSENkN676sd53xYLq7XgBwADJJ/8E2bjJJgztexHdS7rc9ZzAojXT7tKzSwrsyRF/NwEyoARuTH+Z
 kLBIZKy0
 O5ZCL/+i/QH+FUPp78AguwPOxaposKMTIMeHXrYl9q5YqPRl+dz3ZKN3Nl1eU/S3X2MfEp8hCKpzv/3dIrw8Bs4cOKYooqrk1VemBsplCaygmwyBWRNaHeTzG+YFhRA0HT++4N0RDSypaeF8HoW/7ZM+EkybLUH8J0hEbjgJlz96Azf6jxvsLYqDqCAq35JHsJ5MEjcjmiVf32Rfsa9iSu9mHdV5v9l7m9EgDHo7TpTk2rPCJyobgzZCB5lAIUoLR9s06lNMjh6Ozdf736MrhIFImbZ8hWDEMoO8F7bWc5X2dSx/cJxA4jtsMht+k+L3pg7BDB6/N91knAKgD01tvlBsjfLpWMdqayDmuS6AzGbGK0E1q5g70CnX9nO6utJJzsJjV/vzn3BDY+TWMKzW2MD05cKJn4j0HTGlChvUOeIiqqtnOKeX3ZPVcZylNKUGFAHv4FOM2NsHEKeLAEkMcRHr9lx27qyqldOL4+BtESQs8snfBc8YPmc1dKL6eL1n3W1gBpJ2dV9ohiOwhEFrSj2nRPzIK7sPiCW1vMSlUQpb7ZoazCwTHhI9FWlBwmlUBvQcqPKc2/M5bzpRxwXI0Ya5/XAHEB2eML4x/PqqkWW4Ev1RIuq5JWUoYM8CC7fwnBKyqDAAMMJIBd+AwunO9BHq77Z04OkSzsiY7NFpaSDc44v0QOF42hGqqcebhQKOzXx2ULQALFCa+SNTrScLNN9/b25BiAqGUmzy+rtsv5AtAzVajGZPC4QgWCzlU0hsue+Gv4ujV1OK8fxdb3k3EYmLPdpA9sfOqZNURR4Ur5PGwMqU0ExP9WiLLN3/0EE6Y/j/MMOuYB6N1wn4C0Qy5yscrwS63MABYopmLcvsCghRKBP8giMh34HsislXNmgXuNuZjVfVKgCtiomkwmeFGlJbqWBAShyKNGw4BtuQ8kwBT3rJTf4/0EZxwQN+7qoBHydAnXZgc5cfzv5f1V2TLiEl72y1g
 pB/Kj/94
 08u2T8YkToPkyUEucOioixWt7r32bgIVUfi/wkB7O8nL3em6vki4lVADuCoZXhLpgk42kdtk9MSrFOG4XrnlBZOsTQ+4VjYq1ek/ioCIdMqvvrH9aKNjUdpYPBwNpi7PwN9456F92F9Uy4TfKO0zBr27xVfN0ZmT+OCtAjarlq4L0eeZvPD7Cp7dd29TNwlpBlHfpVouEfExFHItuTym/HelR/ZO0t74d79+Kb9fbby9NQ9OlQ+n3nDuOheJYer66TMcAXteEDwlwPMVlA/xdARqxwbihd8iIyKKiVfAXK8HRzHY8eQKJbW/vK6qZHxJ5iB6C5zrmxBbUZwcBT0XnNP9NwWpwE9k34wUxG9dq5LjA5OBlGYQ6EKi+fxZhI8qVE4kYUwJ5xSQrOjWLVAqBZkYpMebFI6LLs9VYgpFGlxPPPVmu7URdIK68bI0h01To=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 07:03:15AM -0500, Jeff Layton wrote:
> On Thu, 2026-03-05 at 06:24 -0800, Christoph Hellwig wrote:
> > >  extern struct inode *ilookup5_nowait(struct super_block *sb,
> > > -		unsigned long hashval, int (*test)(struct inode *, void *),
> > > +		u64 hashval, int (*test)(struct inode *, void *),
> > >  		void *data, bool *isnew);
> > > -extern struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
> > > +extern struct inode *ilookup5(struct super_block *sb, u64 hashval,
> > >  		int (*test)(struct inode *, void *), void *data);
> > 
> > ...
> > 
> > Can you please drop all these pointless externs while you're at it?
> > 
> 
> I was planning to do that, but then Christian merged it!
> 
> I'll do a patch on top of this that does this in the range of fs.h that
> the patch touches. Christian can throw it on top of the series, and
> that shouldn't be too bad for backports.

I can easily drop those so no need to resend for stuff like this as per
the usual protocol.

