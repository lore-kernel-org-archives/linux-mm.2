Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 188A5106ACFC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 23:38:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21E556B009F; Thu, 12 Mar 2026 19:38:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CC846B00A0; Thu, 12 Mar 2026 19:38:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CEB36B00A1; Thu, 12 Mar 2026 19:38:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F2B8B6B009F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:38:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8346916048F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:38:53 +0000 (UTC)
X-FDA: 84539028546.12.C2C28A1
Received: from relay.hostedemail.com (unirelay04 [10.200.18.67])
	by imf30.hostedemail.com (Postfix) with ESMTP id BA32B80013
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:38:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773358731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4/Q8pFxyBmtONaF+22Ch0U+54nC2LFmKyMcLHCniHfU=;
	b=1WCNZv2NtsANC7bBaeukcpRPkOWDuKIs9OPhb1CXSrcWhYAmUfgchTFlPykIPK+9cACA/U
	41xFAfwdIf3KtttC5eHM7woaYbdyHMbRpSSppL1oDuQS8O4rw4Oy1YgNmFdQSS6rUyVXlW
	IKFxxA6WxVaYxj2M8Yj++Rc9obY2okU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773358731; a=rsa-sha256;
	cv=none;
	b=0vfQxGemJTRSpT6UxirPZNdKnYO3k6PzDicKcVeo6DLtVhkGNgLfqHnCCZxu2jKXdvsVAe
	o6jvYSGDK6zlMUmkxoSoftuZLRVUVbf6uyAXLklZWUpoThVbW70O+Bolty+q4ZXN1fGcm5
	L2wB3DG+mvSmykerdZnMFOMFRDuXu90=
Received: from omf04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 75BA61A0463;
	Thu, 12 Mar 2026 23:38:47 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf04.hostedemail.com (Postfix) with ESMTPA id 437DE20024;
	Thu, 12 Mar 2026 23:38:32 +0000 (UTC)
Date: Thu, 12 Mar 2026 19:38:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: NeilBrown <neilb@ownmail.net>
Cc: NeilBrown <neil@brown.name>, Linus Torvalds
 <torvalds@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Jeff
 Layton <jlayton@kernel.org>, Trond Myklebust <trondmy@kernel.org>, Anna
 Schumaker <anna@kernel.org>, Carlos Maiolino <cem@kernel.org>, Miklos
 Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, Jan
 Harkes <jaharkes@cs.cmu.edu>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, David Howells <dhowells@redhat.com>, Marc
 Dionne <marc.dionne@auristor.com>, Steve French <sfrench@samba.org>, Namjae
 Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>,
 Yuezhang Mo <yuezhang.mo@sony.com>, Andreas Hindborg
 <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, "Theodore Ts'o"
 <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Masami
 Hiramatsu <mhiramat@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Alex
 Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>,
 Tyler Hicks <code@tyhicks.com>, Andreas Gruenbacher <agruenba@redhat.com>,
 Richard Weinberger <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, Johannes Berg
 <johannes@sipsolutions.net>, Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel
 <ardb@kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-unionfs@vger.kernel.org, coda@cs.cmu.edu, linux-mm@kvack.org,
 linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ceph-devel@vger.kernel.org,
 ecryptfs@vger.kernel.org, gfs2@lists.linux.dev,
 linux-um@lists.infradead.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH RFC 00/53] lift lookup out of exclive lock for dir ops
Message-ID: <20260312193847.28c32a2c@gandalf.local.home>
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX188/YrC5TApof6JUD5+VNztl2shXsvgY5o=
X-HE-Meta: U2FsdGVkX1+OxQ2+Isx7vF4UixzzITSWoLGanhQdmOUQzHc1ErHaC2HhfFr20UjnVfuApzdY0CnNI9X2EzaFzoxWkp+inh8h89+ue9tsCje/WXI2p8TViZKD1rgZ9aRmWPzAaOFt9AR3SlccruGvmKX1nd3X2qcHF/Qj4v2Ic2F2kBtdL+HvK1KWscULRrzA7ZXclvIVR+DpEPprYwt/KKB72qtNEyxLFZN/ZdoFOmgI0OmUW9WSqFmPDtGp6NNUkGL68vmGr0d1dJsWkcANTfDGT58FCBs3Q3TWI/CNur9ihaDpBPfKeDQH86AL8k3ONIIfeCwhZyBEr7FfTAOuyi2fOWNNYZopJrxvZi0zu3x2dKf/Woo8mIogKoo/MSw6
X-Rspamd-Queue-Id: BA32B80013
X-Rspamd-Server: rspam07
X-Stat-Signature: qbqxydr4m3ujjwdoyrh7ow1jb1hgeqj6
X-Rspam-User: 
X-HE-Tag-Orig: 1773358712-902307
X-HE-Tag: 1773358731-493676
X-HE-Meta: U2FsdGVkX19gEcaAoHOahvzynnGVvJxapD93aaquoaZYv5AbGeYemq5x+GA7/uin9g0G29ZXscMDdgr0XzMMupf3HIvJ1aLHdyicZYLQgF6Ma5vBCki8EtvAdxz3tYabzP6eH+nf+EShZb88roKRN4As+rcywsnr81TH+r3zLj+4MjlS/29C3XIt/lPEqAF2g4B1OtGmUByZ66OCayHNKN/nPFscM2AU6Q9Uro0LbIzbIi6zDDgrn12PrjH8QXpjh7K2b3oNWPI7vhdoph4LKknh/gRQ3cdIedXKnNZdcKl/OyoJIf8CVVVu7qP4t0Ky0XHO7haaH4DIxujQq8TiI5LJdABYZMwR5D/u9yMF8ugDWsPtaDTQI3DR1+gqgYFDCFfkZqpWMWK8cJCYUNEORgAzT9ZX+lmasiZpiffc9pTc/yCHiM71vH2PwosiAyeuJRQ57XiuoascPmc+SMJrTbvBIZBNJG6rbWkjU0oLLlf03Fx24qjDAB8ljRLrF/16CJdpEExSzt9Eyejwz44sJnGf2tX499uAXgoce6aOY8k/UKSq6GjXqBQb4NMlZE3Pw6nI2SJOEBpvhc1nKh2Z8B4SKfr4IrjJNPqfMfng0Ucracq6qw7aocOdOpUaaPvk6UuRY2QOPNNeStXLxVuZGxc9do6LFW6ov3NkdZZcJvoeCGoQl6/V8MvWGfyX2IHXglQuKkHPqjnF6y2PbP2rId2rL1RJEi73rhHnz0UYeniwN2/r5tMUQc9auzactDJ9aY7ZJcMAsN9qV9D02jJ0UPMpDH7zVURrEXO7Of9dT6lsOJeCMaUwdPgZE+04gwHRVlmQNDh43sPd7viJ+Pvt6Y67yv8h8zfgFnkCGCndaHaUbxZ4Y1/ZGKwa+P1bWSv15BfkRoO1aHbmBytIRiOYna+HVg8NJfBN3XErnkWFOYk8rIpPit+Axqga2VBJuS9bmLfxCk39/3V/kXVw8FY
 ipLtACYq
 NCElmK6q2w4w/WwB8Dd/O+4AIcLTGIsovZ0Tl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Mar 2026 08:11:47 +1100
NeilBrown <neilb@ownmail.net> wrote:

> *[PATCH 26/53] smb/client: don't unhashed and rehash to prevent new
> *[PATCH 27/53] smb/client: use d_splice_alias() in atomic_open
>  [PATCH 28/53] smb/client: Use d_alloc_noblock() in
> *[PATCH 29/53] exfat: simplify exfat_lookup()
> *[PATCH 30/53] configfs: remove d_add() calls before
>  [PATCH 31/53] configfs: stop using d_add().
> *[PATCH 32/53] ext4: move dcache modifying code out of __ext4_link()
> *[PATCH 33/53] ext4: use on-stack dentries in

>  [PATCH 34/53] tracefs: stop using d_add().

Hmm, another reason I hate being Cc'd on every patch of a patch bomb where
I only need to look at one (and maybe the first) patch.

For some reason, I'm missing several patches, and this is one of them :-p

-- Steve


>  [PATCH 35/53] cephfs: stop using d_add().
> *[PATCH 36/53] cephfs: remove d_alloc from CEPH_MDS_OP_LOOKUPNAME
>  [PATCH 37/53] cephfs: Use d_alloc_noblock() in
>  [PATCH 38/53] cephfs: Don't d_drop() before d_splice_alias()
>  [PATCH 39/53] ecryptfs: stop using d_add().
>  [PATCH 40/53] gfs2: stop using d_add().

