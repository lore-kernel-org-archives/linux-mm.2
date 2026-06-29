Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8F6BC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:15:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEC4C6B0088; Mon, 29 Jun 2026 08:15:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B771D6B0095; Mon, 29 Jun 2026 08:15:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A17A26B00A8; Mon, 29 Jun 2026 08:15:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7726D6B0088
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:15:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 11FD51C3782
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:15:27 +0000 (UTC)
X-FDA: 84932845494.15.AD18507
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 511371C0004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:15:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K9dZyRX+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735325;
	b=XbzF+Mg3kWLGwXTzNO+5k87dr1wH4XXmC5Vzhz9+CHkGrnPz7G0cNvRTzZMIGhJ1ltybqR
	UHTdx5olHhgqeZApwxRpeBCRcHFNRYixEYzQ1CIVw3qXtuqgAGouL7RqxoVssOC+6yyMr4
	Qcf3OARoP03PWlhtGoizpSrAjRsBftk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ib3bsCrjJ/YTtTkut2lMHiWjoeu6mhtWtwT28YpERNk=;
	b=Put85eKuXsVCGRFzHPjNPVkGbrtwH0cVTd3/liq8tGusr0X6eTpKkPZek+ggbk7qPtizRz
	nnYwj+hNqiZmzeN68p7H/fG8iN0qoAVUQOKbvYfjGx562CgsZ5VGIQ76dW8isoa/Ud8Q5t
	ZPY/DyKovhyKOW6De+nCPVtcOB5Fccc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K9dZyRX+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9511D600AA;
	Mon, 29 Jun 2026 12:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAA71F000E9;
	Mon, 29 Jun 2026 12:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735324;
	bh=Ib3bsCrjJ/YTtTkut2lMHiWjoeu6mhtWtwT28YpERNk=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=K9dZyRX+d4FAViVDAE3qeR8uiytew7r/wwvdnbw2pLzk34UOwGxvC34eg3qFspG2O
	 NwZPGN/SV7RcTKIvcggcCjVtiSROmoQnPu4ZbOkBFTh9pqawRYjuiwvnDbkm8pMtU5
	 TrURwID5TBZSmBvqrggDjQblNwwO1m3IGfP7YPmusz+ySpaF0jVqic11yFaciPmVOw
	 rXo8mlio2lp+8OYh/oH+YInPXPUG3xDjb5cIfbsRaX4/bea5SUhGcIPK3DBfT2qqH0
	 XdDJkf67UjDlghNJzE9qy33nswqMlMN5NCiksRqFsZqqYsizdTo93fMIp+m8v0RGZF
	 5RS7KB77c+Zmg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm: do file ownership checks with the proper mount
 idmap
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Pedro Falcato <pfalcato@suse.de>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <s6mr3j7gew2cgerzrvqzenjctctrtnhvlynmcccxb24uszcauz@5iapd6wnbfxg>
References: <20260625153853.913949-1-pfalcato@suse.de>
 <s6mr3j7gew2cgerzrvqzenjctctrtnhvlynmcccxb24uszcauz@5iapd6wnbfxg>
Date: Mon, 29 Jun 2026 14:15:19 +0200
Message-Id: <20260629-sektor-gaben-gepokert-58db0a3528a3@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2047; i=brauner@kernel.org;
 h=from:subject:message-id; bh=T5WovzhCFKz4G/fb6TfdpHfesyp09NS4EQPhTFfMkUc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ5Jd7Y+irtou7+09lprx08z0UfPLfnp+Z0UXejY7x5B
 j3MVxJ6O0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbym4mRoUOgUez4ZoaN60N4
 24zvfXXlXOx5q3jt+X9Bzgar7yUn+TP8M4qJv2hy0aUs7NLkaVf8nEPYZ8g63L555Feby6kfSfs
 8WAE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 511371C0004
X-Rspam-User: 
X-Stat-Signature: 1oe1qj5nsamwbq88rofxu8unxawor51z
X-HE-Tag: 1782735325-405118
X-HE-Meta: U2FsdGVkX1+KwWhzKw+oxoeBsKX2sSCzHQgZ/ja06JeVRJzbU/dnMjAyMiEq9FB8Id/G7a7TZb/eS98S946kHCgH+O1dV6I/bnUKZYwzlBsY9C07hywmIPKlcmK4MRG24Vdj06vAVaC1AelzOjsbhFRjMbu5tQofMJWGacmZ2P3OZvVf7qyGh6lvzGctNpfRfRi9ezUDhiVqq0GmbNDcjvwVtBMjpg7E4acv+SEhJpnfizVgYrfJ8kKLCqP9p/QonuDrpb/jauyxGWmassI0xbNgNIitcQk9yFSc+8G3X0DK2XAtIPDbDZwTIq6zqL+0BXKMXwE/KmGtQgebAjpsnyOq22AKBxdutzqNSzLrcWzjDJ2iqcNkrGatNSuml+UFMk8vbCiMEQWYttud0Flo6ZmBoaZnJPex43ZOur6U5JcBTxzpgzDB4DXcjKNJMTE73nCTnNAxavFq6fVzdFnY5vRx1GfiFnMRM8umZ8bdfVF9Xj3PdCrz5XPGUhdKky92/ak7e6g3VN7vadvZmxzyo7qMj3fuSh9oeSVrfoWwG1Ong1soEvKrCx7fVEQr3JoUCASlE6LUBjcp/5GVVwlggz3aPytmsxAkv92PoOh3MJP2UoxSIqBvzQA0h6YWNxWra7hPO9Xq9Bh7Mb8k05iMJHWWrA1ARg7H5seqpWsj8nw4gAUqr/DdtRqACMsZvD5cXzLAICJhNYQiHq6/GORgVUsNxqeHKYcDeL8gmT+0yxsSBCUHdl+9Y/60ZZfOeqOEfJhgLMeC3+jYXJn6AR9QJhERRwKiQVnIaP5SPGeWLVhy+cpEFgZdpYsnVr/z720eONB3e8/0gAkViDVDuVFhGbkyBD6PBPy6euNlGpCTglGOiSpJPJhQTFym1CsCNhDTcx4Oq1QgdBJIoqUJzHY0rZgV/GEYlYSDd68qnBj2nIXjJiR1kMdUELnrTBM1mk6Yo5zmdFhlH8q1BwbROM5
 YKudItm5
 Yr1zUZpZKlxU0EqF9c+Lk9E5aa0ETHU2UUaF70ydnzrkSryWUodE2gRG8WfRIB8A5uMUoBX8G2/ImJBddhss362brSu7Ib7SGvrKPbVrW1ikSupaEtYYkU08Q5hMnkAb3IgDCbYXTk/QlXxFTgywj5N7Z3LO0NqioIh88hSnsXz8ARJtpu/GWh7qfViLlqHszXRq85w9e4E1Kvef0HAOEvESiRlFXS6dMw+1VYPA1b2OBDbAhwiddn65SNUKhEeai8K+iof0CZjVugVCE7i53l1RmCZVsRm0pqTTc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-26 16:19:18+02:00, Jan Kara wrote:
> On Thu 25-06-26 16:38:53, Pedro Falcato wrote:
> 
> > Ever since idmapped mounts were introduced, inode ownership checks
> > (for side-channel protection) in mincore() and madvise(MADV_PAGEOUT) were
> > done against the nop_mnt_idmap, which completely ignores the file's mount's
> > idmap. This results in odd edgecases like:
> > 
> > 1) mount/bind-mount with an idmap userA:userB:1
> > 2) userB runs an owner_or_capable() check on file that is owned by userA
> > on-disk/in-memory, but owned by userB after idmap translation
> > 3) owner_or_capable() mysteriously fails as the correct idmap wasn't supplied
> > 
> > In the case of mincore/madvise MADV_PAGEOUT, this is usually benign, because
> > file_permission(file, MAY_WRITE) will probably succeed, as it uses the proper
> > idmap internally, but it does not need to be the case on e.g a 0444 file
> > where even the owner itself doesn't have permissions to write to it.
> > 
> > Since this is clearly not trivial to get right, introduce a
> > file_owner_or_capable() that can carry the correct semantics, and switch
> > the various users in mm to it.
> > 
> > The issue was found by manual code inspection & an off-list discussion with
> > Jan Kara.
> > 
> > Fixes: 9caccd41541a ("fs: introduce MOUNT_ATTR_IDMAP")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> 
> This looks good to me. I'm a bit curious why Christian initially (in 2021)
> used init_user_ns here instead of the file namespace... Anyway feel free to
> add:

Back when this was added only the do_mincore() codepath existed and that
was intentionally left unconverted because it exposes the cache
residency status. So it was effectively a massive side-channel.

Both fd3b1bc3c86e ("mm/madvise: fix madvise_pageout for private file mappings")
and specifically cachestat() came way after all that.

I'm otherwise fine with the change.

Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>


