Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 480CAEB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:33:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A86FB6B00D1; Mon,  2 Mar 2026 15:33:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A47166B00D3; Mon,  2 Mar 2026 15:33:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91F5E6B00D4; Mon,  2 Mar 2026 15:33:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7F3566B00D1
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:33:41 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 594181B73E6
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:33:41 +0000 (UTC)
X-FDA: 84502273842.05.ABE480A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7D6041C0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:33:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=okCZ7zIR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tBL0ekDjbTpLdCyf+ORLhubscavQ0y/tvJqNO6XgKQk=;
	b=ewDjiqVdANypqRwpVqzH1pxaQQGYWNMh2W57rZGLqrAA1ZMs/Z+VWvOT1bjs83TyJ0I57t
	xxs72cXpm++oMN1LZ3WGDaZGLctXm784hUhhvg8XWiaVSsXirGiLOcAdYUnOmp4hhzXhKS
	fOxaczhxqxNEQiiA45NurDXgWlzNUW0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=okCZ7zIR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483619; a=rsa-sha256;
	cv=none;
	b=jVOdt5x043q3g2M/WLygosnFY4uJXlnRgxhBkeeCogCCz6/fsCb7nHR6bEiS0c1ft+Z5Up
	cVTgydBvKDCXjIJcUAydM2Dl9U8ccBbgBtd1y11A37EcnCFkEAgHRCr4xR6iP5yOUGEk1k
	AtCH/cjy+eibxceq2gUBMkDdA2wT33M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F198441C6;
	Mon,  2 Mar 2026 20:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46CE0C19425;
	Mon,  2 Mar 2026 20:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483618;
	bh=Dx6OCOLFpUWbkqaMn6d9+Y3vE0L4Ow2c4ymAgPNZfJQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=okCZ7zIRi2VMtVRStMgeE9/9/F9lJWYjHtNePHRMge9nw1VTUruhkij0Gf8cC6y6r
	 G4rHlM6H0C++oWBwkVBsR26eAC7ZtUWQpfs/Zi9QMT1AFXPNmHG2Gm8QFhBQzkygv8
	 lmQBzV5o6/8hPGE5LBDrRlSQzF1o5IXJaB9EEbedA7HJb4/5UQbRX9J/RyBtQ6DC5Z
	 sVLcD9NwQNM0fk8Xxv1YzHVgsdgon5Vky7hd7Vp2dBGl9oZEbWQOmprV8lnxaRkgee
	 jhq7TJllzSjtAXzgalV9glJpn3bLs4MyriK1nZevx7CjG3/ajpbk03d9PVegOAZ2+/
	 ZXKzBbQmchKSg==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:20 -0500
Subject: [PATCH v2 036/110] jfs: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-36-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2103; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=Dx6OCOLFpUWbkqaMn6d9+Y3vE0L4Ow2c4ymAgPNZfJQ=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH4APwcmWhVQ+KPcyAzVeyyvBsp+VPqE+YSu
 bhagS1iRN+JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx+AAKCRAADmhBGVaC
 FTq6D/9+cdQFr3gfoFPinPiwnzlCJclUXbIuNVks9phDOV85WJ69jJ2EbHivozsQQbmdRkyHNa5
 TUgP2yv/IYHgRmdB9IhlcUV98Tm7jptcbY/uZWxP0l30ZJa1N0pS6KO1ysFl9/csaxZS8wyfQch
 hVrRb8agzOS18ArGlThXodRMsAXLwNKpLgvZfKSmQSzvro1qSkuJnih9djx+aOXE4GZ9k+kUdU3
 q0dDdAzkpWfh/LtcjpcagvVugIy5FZwtRz5rMFIBysqseSP8aw2X6vW8BG4B2fkt0QBz8ATXZ7S
 6/7w4tIYZkrN+qjRLMfuPXxPJvpUcMI++/e3fzlxvd9NnTAX//kA+N5ccg53Xa7ME3OPS2B7g4e
 WOSUnDCxwy7hDgVqrQN+BlBB+NcznaOy+bBpVokCZbMMgWDmqMEJlS3+epKHzTk7MaMofPZMtfJ
 v1ox3PQfnN18j1i+Ni/rCRfCNXb5h4JH1MZ0AV95vYXgDcpqDDo2zQmqcw5+ep+SQmAy4oYIa6V
 G8jqb52oW+re9jXeDUY8/JNt5eWrrPhEHorOpHDRP8RQ7d4GKV8AI94hQNEoIjWOwpMjR7JS726
 a2NbcXxAScH8tht6DpzXOeb6MQmuSNUKsRayQfIHbg0kLqaMRg0DnV/iAtxslJFdRcl3+5FfU2Q
 6ahGnw59kAQbUPg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7D6041C0005
X-Stat-Signature: gbns14bmnai3ujwmxoma4cizk6h5ormw
X-Rspam-User: 
X-HE-Tag: 1772483619-81642
X-HE-Meta: U2FsdGVkX1/3SejiMMEmGesSlIPQWJxy48MEL1u2rNxoXxk7nN1vWb0VVvYyKTnuffNKbLMO5BN2jQL2tYr03iRufMZfYbG0gr/XkoUu+OkOU5BgRu37FUoTbEqORbGny3nbFkzvNSWsfbjhC44LsrLhBka8XJGeuIehHaHsU1UigyktOtq+tsPNjx8SZWMIxVYXqGZfP8wCiegMRFc/XpTI5a6ylla8sKHkZ/qqLra/TV30S7GFGJyYmGEENr0WdhTCCjGsaOWp1qacoh33RwOlJc6EZK+84VdIr2VttmpUEOOWCVz80YRepP4BrATuWxjSXIJUs/sxI/BFU1+McgSXTNnNsujSEeed0s9vs3jcqJRP8JwIJcAf9waePIMLGP+v8HoQSgQJJNHNKTInJdQl/P/3dbfejG+It8S8ik4pVbt9d77ttP4wET/wIufmW0+JMMuR4/ZJ35g4TfUnwoEqST609FyEwlcMCWJpXk8F3tPDrgvfPmV4tX7zfgq3hkn7g1khxRqqlgVe/MZrgsggn3lks0STJh/ufXN2irDrn67l9SaGwUZP16tTQn2Z4dyUbrhmV0D5s5o/cF0Ucb+f45vjrSxDtnFuW1Jl5rwnAsJjGqLeyB07+fUFJ6LIY9U6kz9e1ihrvhGg7b62cXLSVd6v0RzNp3beD0akK3pPPWLH8NvoYDrl8vkXipQjOG8rtI5ABwc4A4y1jZ9TeT8DA5Tp/+wrq0bjlyJWGI+wMZVTPERLgVj+QnuzlDThI8mQFW2cnX37lDeklS32zi00BUNMuI9ht1WV6zM+gxkAYwwTpZk80gWau9xHGRAEZ/spzjx4KeBjr+4WVGuHDu4dAYWTrJ0PeAbygvmiZ1nhRYJbqEemjTo+vaxyT+yXzBGizyus+5GuuKRKfsplkzjdl44BQ47MY18ewEhHO5Md1ZAQWdseVqPpestAvZp2Cpm1YoD1/5is1Q/ZmuJ
 vtt8tG0w
 ZEOH3El9Ob24lAPk0ivftATQuoulBzlVoHzWGEmm0pijLKt/jumYrsc4nViUNfTOWeXifwY9+lpp5f+cKfcIQoofvuAdVfkZ0QGu8f16YQuUPTEBInGsqyZCVUkkyHq41Kz/N8z9L5zLYtTeI0YONfA5zhsNPXo5ExTgHJCYYpJxK3vNPM58h1msRB+j9hUXjPeWd4oCwgXNJcXgBqVZGmrUL25+TNauugnXMJ7Yn6SPJ/ttoSh7eMID33rCS1rpBDoFZhzci9sX4faKfqq+AtN0qMiBVYHCKjrBv7lYfI+BbJNbXr/ZqT8XZ0MJTyJWN/XY3z9yZseo9TKkPWAoyTi0+NCO6JljJTqA+4LAeNZ5Zq+Gh+JcgZfRYkv+HbyeibBCgn9xheaRMPPlY9fNKgjXtwWRzaEMtM3QNJjaEncaBuBxFPu+LlGGHkFz23yeRHlsDVrivWd8mMGhieF3q499ivfbkiY+kQsZGfSpK5OavCee5nqRO++bShJ2Yr3LKlhrCDwV8Ei6eT0tEp82ODax34qaa++cdVx6WLhOA5QHNf8/GgMRq5sfHWoGUMSFXEjIIg1tzDk7psISyYyYh0huHhFNKz4E6FRjrviJ0MuiDy+R2js2wIgyiB6PFi8KuVET4nQ+UhhM5PGz4X84FR6BfyVQMVXS4sf5GLRdOP0a2KHGa18uN9ZUhpFRTyYYVOohtIXwPqMgzxBsxeQhHeRbKM276s0IfEN4gSozDny3Cx9Z6UjCGo0Ru0DcMktKsH02ROzwe7o2pAxwbTikoAKS8EFuVL5q72wlsG7SR5L6qbSSnXBQTlnGX0PaUuCzmeHVENHT6QbTHtYPxpSGNxRjunCVp8tTLVMtF9yudP0OZHq/45GL8Wlsc8zNiMMwuhghnzedE61cxp0iX0+FrP5RU8IWAgIlMmqEqkDf7XtSkMEYj1E0Z6dLV3TpWtse+PzCr6sYRrbWMnZZBAa/cA4SIMwbB
 KRahRoDO
 JTt/v1jmX8Xjvkgv9wLDc2B6dThyOZ191TLppad3GccnvvZe3SpUU2u65TkKoiItqeKYkbN+cvPNu8qEGUAVZdw0sWM8gRdAoJyVOv6cCjiedWoAK3VbdzD/XHniIAqKuY/Q5XsoX3Vk94ftyxRu7Eb+qi9gb49lyiK5BspZZ4c1wo7djD5bnGkU6PaX3SA1skdgBC8pdPUS9C3gRN90OPdsA30XldspMl0aFbbMsnWASmnuhCkvjv3me1izIdCvBkjQSsPJseVbt1juvN5yYGYih4yoPFTvAt0HUKEmjNVH+tko3ZiZTFZmWZhxxcFdx7ezQc7Y6BOhffWFs+n9cU5ro9zMOCtR93HaGpSex55W648Of20x5As2A2Qnxayrk1Rk5EHQrFIP360N4lUG3CIwQnjQU3fFcL/e9cFK6wg7IG/OuV2Gpq7Tpi2Q3OJ68iM+OtVTnweMbspLdPn52sDLMb0YTy0YTAXq1cxk9aT7h0eQCBNxVYMiRjoKzOyoFY3hpfzegtTsmEnoIDTsqCQliFEKHITGxvUGGmhINsnTurztacBl5ZhwWXx3ks1qb7IkGOD0Ts6/oyuc2s1yKRWL1fTVAN2lb8gv5Psve6293gyi4sTe+6fAZKkZEAfJDwGME9K7yR0r4rk1O1/cfEFimkPglWvOUZcCv5uBQDy9CSDw2IRYkPira/YPtvebbtRCXKgrwnBe7rTY+lRDlwqvd9hQpL1BqlO+tVZdZLp4sd1LHJQcuJnvIAlhZlIrHu7ORP/uOgH6sy6OUrw6qMwIza7ayJoQX0q99GAGXqT3NNHvp3LCHGGBHJnF9FZcglPWAhCXuJBcM0OsGYdw/oBChTYtddFh6J8nVUS+LNM/j6C3I0HUnbyTE+WLv2A8lWIHKw6IlUdPgpe3FU1pm9nE45THp55Vrz0ASsoMVs4iJSY1dJhaet4ICI2e7i0yY4//5cH0H8+DFxvxZP82r/MvfkV0h
 EPItl6Sv
 r8GMrAkKxOpKN0mkpfaedAgnYhB2hQETNfeJFLY/x+M6oMRnOIW6kaxbwPW4n/Jb3pPOqEfER6cDpxRztH6mU46ljwLSCNZVD7D5QSdr93Mp07Kz4A7urc7FIdrZGy3KFHMJi4ekFweYuFIqDdMrxnuMha+szDaB8FNY0VLUcarHMZxCztqJ26u/hn59eErpXUhpuUarHQyW8zvETCeg2qi0sJSvAiMa1WWXw36xOziY4zn7nJj7hEGSe3w6ajgw1jizl5a9ymEv+JtHr9e5uPPS5If1nCbfatgscpLWbw09yEHKcgDs/Ms6n0I1l09PyjtitchuEXalzhQWRAQAGPfhSw0iHUnYcTRJuOkchU4gSCkMtsCpTjzvT3Hz+uGzbUkFbW8qppOy3rEzdUWShTVgo0Z4OqcgyXjxu+MdA0Q3S+dX5yKP4T+Wa9LQL76aSNKCse1BGA+QA5RVeXb+lJMoS8m16UMUehAGO4JgNZb/CEQo0DX9hqRH7MoBwKn3VrTeulG7JVjshv9gQpQab4L1rU8UrYbu2xI0TTaZui2cb8RXD8znhilFtmNd3neQdxvoK0l6xMqfFMoIWz8reFvevfBZEXWRBvLWclKSsZuVAcFDdZqxqwKmVcTMhWuVFr+cuqwxyF8WPgDnNrXM4wc6UYcZHmi4GjdobWt0NOawzxwq/tzFrYic8quJ6n6YOK2jupvZaL0yyJ8dqMShXUJARzTim70gAX1iOBwLeYlOzA1HXhn1rCUyAuoUVUNdDtCIHEe92d6DDIZE+lpw3DoMFpp8w8bhAE7ziJGOO9AroGCbpDl0wM3uaGhoFPcbn5fLFwrxftPHhOl6aTqaCA+V3m2JKdn+He3ARYX/NFo9et7SQKLHxQ87rQn9qzWyplJHqwKjc2vGIAgt87KJ9aiGrNF3uyGqppdzpt3Z28ha1d6Y9PcphCRtn9aKYdsQsof0ZZeqYwJBF1C/HE95c0X949U8P
 7OkxJnoa
 +iuDxs5DaYBSroQYasWLGLavASYXlS5KMbp/DdHrdKeRJQLF9vc/xYf0BiUo2d1jD8EoD83RKpvErDfgoE9xuf1sBY9Jyi8WVzG/rHmDSrxIhnQXLuXsUWd8k6mUS4zU6fBR/S0sejZDOxt9kt1NOJyBkCY8KWbQSJytb775tisk+oKPSaIObknoKUEUPjAf3KFcSh1G3xbv0E6dyO7WaOkOAxrI0uWVNNxKr8wqNVdMu0YYcEPigb08NFBxxNmN96pHDE8s0yzqgB4sxSwBius0qHZ6OGwXOPqlhjkNoYRDO9KSKj6cIi8o/XKx8gMF8K/macbXL4Av1pr9e7RKzS1IS7LpeRLSE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert jfs i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Also correct signed format specifiers to unsigned, since inode
numbers are unsigned values.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/jfs/inode.c        | 2 +-
 fs/jfs/jfs_imap.c     | 2 +-
 fs/jfs/jfs_metapage.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 4709762713efc5f1c6199ccfd9ecefe933e13f67..7529043baaf30a6227e5d8edbefd9e37a8105d43 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -64,7 +64,7 @@ struct inode *jfs_iget(struct super_block *sb, unsigned long ino)
 		inode->i_op = &jfs_file_inode_operations;
 		init_special_inode(inode, inode->i_mode, inode->i_rdev);
 	} else {
-		printk(KERN_DEBUG "JFS: Invalid file type 0%04o for inode %lu.\n",
+		printk(KERN_DEBUG "JFS: Invalid file type 0%04o for inode %" PRIino "u.\n",
 		       inode->i_mode, inode->i_ino);
 		iget_failed(inode);
 		return ERR_PTR(-EIO);
diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
index 294a67327c735fb9cbe074078ed72e872862d710..c9ea54f06114ce210ab2d80ad80d0dfa6c55b250 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -302,7 +302,7 @@ int diRead(struct inode *ip)
 	unsigned long pageno;
 	int rel_inode;
 
-	jfs_info("diRead: ino = %ld", ip->i_ino);
+	jfs_info("diRead: ino = %" PRIino "u", ip->i_ino);
 
 	ipimap = sbi->ipimap;
 	JFS_IP(ip)->ipimap = ipimap;
diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
index 64c6eaa7f3f264ac7c6c71ad8dd0d59b63f15414..0a1efacaf4e2196197cfe44e5c51d89b15d39545 100644
--- a/fs/jfs/jfs_metapage.c
+++ b/fs/jfs/jfs_metapage.c
@@ -692,7 +692,7 @@ struct metapage *__get_metapage(struct inode *inode, unsigned long lblock,
 	unsigned long page_index;
 	unsigned long page_offset;
 
-	jfs_info("__get_metapage: ino = %ld, lblock = 0x%lx, abs=%d",
+	jfs_info("__get_metapage: ino = %" PRIino "u, lblock = 0x%lx, abs=%d",
 		 inode->i_ino, lblock, absolute);
 
 	l2bsize = inode->i_blkbits;

-- 
2.53.0


