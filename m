Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B7B7606A329
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 02:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=V5EY1ZP8
Received: by kanga.kvack.org (Postfix)
	id 37C346B00EF; Sun,  1 Nov 2026 21:40:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32CF16B05B1; Sun,  1 Nov 2026 21:40:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2434D6B05B2; Sun,  1 Nov 2026 21:40:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E766A6B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 21:40:41 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7004E40C2C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:40:41 +0000 (UTC)
X-FDA: 85388625882.27.815E2A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 85F0840003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:40:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=V5EY1ZP8;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793587239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9MZi1hD6WqJcKS3km0Z8C+kRXVD/0KRLDA2g4HTFty0=;
	b=OkW52wRsb4V3G+n697Ej3ZfUOK6JZCRGT+tyTEdUvndHBNMhpVwfZ5Opbxqs6QH2u+uZ4y
	R9cAeSJT3hvX8+c2UUDDPKLZyp8Z8zn4/958OunSodd2wD1E+3OUbLJNq/jju21EOMUTru
	+N3OJYP1lJkqZedsCcM84Zu67JBZYyE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793587239;
	b=dRQ3YdhxB8xuUZhl1sv8GFXwRZ5Ab+Yc9bbO6kw3h4IYgOKPDgc3Un8ax/JAtuvmSGcE/q
	liFZu9z2+JX2d0MYyT58g3DTnrqOvNWVlNwAqyAzhx8syS4KP+IKBs7d2bahHIvfSGzoBT
	P16JjX67XmQo1u6aMfONPSOSDCUtigE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=V5EY1ZP8;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6140443D3D;
	Mon,  2 Nov 2026 02:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D451F00A16;
	Mon,  2 Nov 2026 02:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793587238;
	bh=9MZi1hD6WqJcKS3km0Z8C+kRXVD/0KRLDA2g4HTFty0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=V5EY1ZP8wlTtErpAj4wIIH2pjK5+yBnubEbEeMgLYjUfOKwx8kblJ7Z2Z4o3TYYt1
	 9/AoT4bhgHjfeNuDZ4H1MEqk88MkqBy+TuLNOwKAyLd9GbB3LJbgLfJ/gjsRZDqjc9
	 ah4YNs8AOkLHGA5usNB2fmwsr41n1qzW6/p2a00w=
Date: Sun, 1 Nov 2026 18:40:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: joasantonio108@gmail.com, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@kernel.org>, linux-mm@kvack.org, Hongbo Li
 <lihongbo22@huawei.com>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+91e1fc35f51774c479b2@syzkaller.appspotmail.com,
 stable@vger.kernel.org
Subject: Re: [PATCH v3] hugetlbfs: move hugetlbfs_free_inode tracepoint to
 ->destroy_inode()
Message-Id: <20261101184037.5398ecf4c8348462a70b3968@linux-foundation.org>
In-Reply-To: <6FC96012-76AA-483B-BDA4-8E1C1ABB5FFE@linux.dev>
References: <20261101-b4-hugetlbfs-trace-v3-1-051b716f490f@gmail.com>
	<6FC96012-76AA-483B-BDA4-8E1C1ABB5FFE@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 85F0840003
X-Stat-Signature: ju1bd3dyrumw49yai5y56j3zm8cjs3xj
X-Rspam-User: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793587239-457350
X-HE-Meta: U2FsdGVkX19rzHscBIfNs27/xF9qXRxPqx2FjAiIFf8exk7PLyl7372p9Fjr3E2zTK4ZMFXq6JZ1DX7uk0mHQPUGV9hG4dXdRaj88g7i8luJSfkdwZBHgRd3mn+mlHs9MdR5sXIc7T/Yn44YlFygkMSiprjCc9ecp1VZ+yYSA4z5K2JkeBDBbw0oRVLs6sV0bkhDyUEaCtXRIFDXVtkmC50yH9Z08AdakWUiOsSla08isrYjI6bSmQ9b/0CcOxNp1pCu6kF+nKlNp8/iKpLEGUoBXnzlHLyDZ3W/9xpX2ch/GBxKG5iKWcQ1xPhlxgKG/Upr2EGcLPJwj8Fqxzhk/+vi+MXyYZGaoveELT0yZrga9sAsiZE3kYnKEJ/NCmNvz+Q1CBDKhu+2MjTq70dI12hVRJhsCTeOT29MlvYFqWP6zIXmxO68DGYDiLJ+bEFG6rdEFfGVoOhpNQpnXOcDV+sfCers03yCl89ml9r0wjMML2oLZzoN4dH7uGhTWQpUOR53iPJlWLz6x/6ntgNnJ6AAVA+Jj4veUspNEaMEEh2RuDM2WtAUsE0i5hUWrwvgE4+m6EoWcbZ0G6tVXHgmDGP4oa7u5puG8U/aYrrYwyV0gnhdP2kcNEjNzocCzGm5+M0u6ub9H1xgokpPHsM/agczHMy42KyhTyGxVMbdLfOhO+4VLzrlmZspMgrhVktjijUOUmuUswfD25XhDgz5aLAn8pgfe1M91O0MXwkqi2CTKXbcAFjWyF/qNyugz7ksuG5mf0jITdNx0eXp0VQ/zCvyb/Px4i14JKe6hfdw4vRwt/qkFlBgVkgLWU7iBRqYVwYV8ULtDXW4ns5nLCI0Pr5FAETPsL64aqS3wcQIhW53bTA0YMVv3G8UUzdCtbdInAipH4PWHqXHFwWVlHjmTAmIj93c5TwQ5UwFO/hJEHlZaNrpnRHpaJ9ToIz0SlgJxMPSa93lbIw8TcyxHHS
 RZYzu8lT
 BtP/vd+nMYMxrUH3KogGyAR2S1O38QGmPxz3vcL5OzG+nZ7lXcmKAqVj6D/vGxGI+0zGSD+VLpTcEoMppfTgnLrpB41/1F/UtJuMZts2zITb3ROvWWJIukq17r3vLC4Vcl/gDXmaG5axKWrTaV9g6lESKf9eyMAdfz6xK801epfTJ5U08Ibhwz90qVgqkeUOvGVHsPQzjQ3mfSrNNbfNHDdpAJVXnwmJ6k2WoFEF/uDNFcbmtNzm4mCPlI679UvTRUAnsQJeQFkG/rL2Lkp65PXHN1zajOmSBT2tCpVfR85kdlZ6Zo1ZoY8a0XHqrQnApEUTceaiNmTLbZVVggnTiZJXLL46IiAB/FKjTF+Y4G/08/ENY35dGf055D/WZxR/BKwbfOKaAF9RDEIMR5bEKkzSOu3BAFhF2EeG4dvCtmBulpiuDsByPeI86vsac3QMNPEZsWwcHgvvkakA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2 Nov 2026 10:24:38 +0800 Muchun Song <muchun.song@linux.dev> wrote:

> > static void hugetlbfs_destroy_inode(struct inode *inode)
> > {
> > +	/*
> > +	 * Not in ->free_inode(): that runs from an RCU callback, when the
> > +	 * superblock the event reads may already be freed.
> > +	 */
> 
> Since the trace point name has already been changed, the comment here
> doesn't seem to serve much purpose anymore, as there isn't any ambiguity.
> 
> With the comment removed:
> 
> Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.  I've added a note-to-self to track this, but I've left the
patch in-place as your observation doesn't invalidate ongoing testing.

I always do this!  But this doesn't appear to to be widely known :(. 
My fault, really.

My notes-to-self are mastered in
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/pc/devel-series,
so the overly-curious can always look up status in there.

If a patch has a note, I won't progress it until that note has been
cleared away.  This often involves sending annoying private emails to
people, or fixing stuff myself.


