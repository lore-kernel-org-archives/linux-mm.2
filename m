Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C45C606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 19:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CX/Mok6m
Received: by kanga.kvack.org (Postfix)
	id B33046B05B0; Wed, 18 Nov 2026 14:21:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE3946B05B1; Wed, 18 Nov 2026 14:21:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A20876B05B2; Wed, 18 Nov 2026 14:21:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 803E96B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:21:13 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 132AE140867
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:21:13 +0000 (UTC)
X-FDA: 85449208026.04.53305FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 786F74000F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:21:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CX/Mok6m";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795029671;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BJx+U7zia+nE9EeEvwYhNLjJLv5dhCpyIAGJ6raVPUk=;
	b=SBrJkliMmNmNKsd7H7gW8qiFP1Q4uDA5pOSH9+vW5W/ShhE78CDkIY74QIRN4QpdkVuxZ1
	YqLJNKC/HsE30IQouaSAdmNw3UKPAboJNIoUlaq/P2BM23e5vCLMEllN/bmou/VZpxi7oV
	IlAoy4kWphUDlIG2/56TtTcZ4erTLp4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CX/Mok6m";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795029671;
	b=KzuIulxqueH+coyfBx3ooIZ+JEe6aIjPVoCTSGcdXyRHnYQ3neKdUg/L2nIrhRTMx2jYb9
	hg0l8B+tDCaWliBNiin1m9603/vgbyCbsNF6TqL474ZqFes0HcgXZonGBd/MS8WeTBh60C
	l+OUiwf2rqjrez3/vZyGoASFufyAeZE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E1F02638DE;
	Wed, 18 Nov 2026 19:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFCD1F000C4;
	Wed, 18 Nov 2026 19:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795029670;
	bh=BJx+U7zia+nE9EeEvwYhNLjJLv5dhCpyIAGJ6raVPUk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CX/Mok6mXw3S4iCP7f7/eBP2B/NiOkfCwjoQWNU/Yyx2VwwinY4vpt19gOWxz+Gid
	 ggTxwdGggM25dIjqf4SGOaG5uTSM0KX+fLNom0SOeJhmUGvyC54EYjv4LO9zVnVK5o
	 6jz+PHFx2prehfs9fwnoCTRoACrglv4yrcIXyQ98gzLGQGB0Htdz4dJjzy13j8VjC+
	 KT/HNpSAP5lusoEoaV6M2g3EC5a5h3bMirgFNwicvAToqRon4dImGB9oKd7M7miThY
	 Gd36+oeMjPpIg4IfsOT+yl4OVaB/O+DJWMtqQCZ5OG9Q0NDPaGUtYY1drGsyO/5wB0
	 agxnpAbBY1rbA==
Message-ID: <sashiko-outbox-221844@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/userfaultfd: check exclusivity of the page being
 moved
Reply-To: sashiko-reviews@lists.linux.dev
To: nakixii <nakixii@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Mike Rapoport" <rppt@kernel.org>, "Peter Xu" <peterx@redhat.com>, "David
 Hildenbrand" <david@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Lokesh
 Gidra" <lokeshgidra@google.com>, "Kairui Song" <kasong@tencent.com>, linux-mm@kvack.org
In-Reply-To: <20261117191853.1314834-1-nakixii@gmail.com>
References: <20261117191853.1314834-1-nakixii@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 19:21:09 +0000
X-Rspamd-Queue-Id: 786F74000F
X-Stat-Signature: wkpd4qqo7zehqhd6k8f95tgesbrdbzu9
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795029671-726335
X-HE-Meta: U2FsdGVkX1/GGQubXfTH1WGJn8o4H6gjcSidkB6m4qWbv7NOwVYOlClz4KLHzLQL7lR7eT8nb4YzOGUOlAQ/W8KZ6uFmIEsiBSd/6b+BkVZAD0wOeATDW5YTKfF8F6Twd/HxJwZCzq1W96ZGjHJdgUXQ6+MNK1quT5qo63GjMEJ+P44hDVfnp5/9WRSrUdJsRu8YPWqRuzigWbduxuMi9sUVOj5DKw1PX9my39ycvJCnFT7JNaWAs0AWp2AHvzXxlDo46DaCO9tbj8hNSst1RBTINGMWLwLKEizJjJfsMWORee9GNT77LLZ66DHVgk5qJc/8/7MeEkKK8IUeWwnNF0BHTJMlysaEV/+254dcGQGxHZCSB37e23SIdFd6aCS1lX4SHMtZqtZ+RyF7+Xy3zmc61ALOklmymUWZR2bDYt20JmsfnnPuo4k/jrhHNh8VtZTeVODBO6u/eZLe2TUEAD779EEv15tg9mL7S4+btMrxUtC0vZQBe/JFJ41Cl30VKvNga24n4d1q/KVJuar84e65v320A+2Lr8IfyCUbk45z2Thhk18cmzCvEoyVJ9zVXrkaTStHnNfKTe/PvrvQ1GLIMwBPdB7M2ex7rVJp0DbZRhSjqq5jZXjhlUpWlx7tCh30ttIDIrzD1orhWCkZPBC/ZG5TOfYLiYNQyHVQsEviJDFLhBQy/HZmGR5kaG7z1pXb3ERwO9WWWeCqb/OlYMgN/7iQaCTY7DpWhAlfKjJHi5AmZpvmG+HOimNZduwSYKQeoYMzc1j29Bi4y+PE/E+dNiZeTYHR5IC2mSL4OFF6aQXryuV/inplCNJ58egBLebGcDs0516tLf4cTeTS5jylc92msjZYAhAnryPLjz7SrSN+Femt6GPah4QQZswUMEix+YUGQ1bCvB4ursx44m3QV7h7RxfdludmZ2Gu9F0uhCAlzNKTr5KUQFoSG39rN9sy1ZC4j3GSRgAIDsa
 lDrIk34H
 KI26dHNljwrILdNTg7ao0o9zn1JAkNHmtnnMOyQEjdciSyL/SZPop5qVhbTGpV/f1JyEuty/prHtZedZ4KJ/IS9BmiHywA/HHwsPkM8MSYX3upF/+yyDEtdFWnISkMZ/Rzyg8DxXEJpKkfNPlTQ1FQ1R5UVDcsrOArftJg0ZaICgIduiwnGdhwNP+cPXyyJFaRay6ilfvhK4Q7uud9rk++jYb0oCG1oUEdKoaBItx3gphop3Ftk8jnhQZKYtUsuFNeMN+2TlgI4ZPztl8J+Op7OfJ7OckWtxmK993AuvIczex03kiOXQG9T5sq53h6rY1mPs6M/FvRKpwnuw7PMRu/Na1TFWfrb9w9ELZX4c6TxAHqf+OoVJwpsAScDeOPxCJn8HYtf1AVqiwF4aExJTR410yvb6Rbocg6CIJoeUWR6qQJsW4EXscCtt4cg3QobW7ibiRXtSydSK/8LWd6Aq4piEyODhTvL1Ku3jhqmweleykolEnKRmj478yRQNMNxMb5dRRSmwulk3NKN1bsbqwEdNvNI0o4TrJCvHrsuioOk4dhPBWLOIYMsKFVl5dnH5bPdDUUX53EH470BCoShllLUV1w/LtP46AaA94iMDiXfzD5oY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm/userfaultfd: Signed-off-by trailer uses handle instead of
  real name
--

commit 888d38f960fc9868b79456db2818f9a7357f85a5
Author: nakixii <nakixii@gmail.com>

> mm/userfaultfd: check exclusivity of the page being moved
>
> move_pages_ptes() gets the folio of a present source PTE and then checks
> PageAnonExclusive() on the first page of that folio.  PG_anon_exclusive
> is per page, so for a PTE-mapped large folio this can give the wrong
> answer for the page that is actually being moved.
>
> This happens after fork().  fork() clears the flag on every page of the
> folio.  Once the child exits, a write fault in the parent can reuse the
> large folio, and do_wp_page() sets the flag again only on the faulting
> page.  Reclaim can leave the same state behind when try_to_unmap()
> replaces the earlier pages with swap entries and then fails on a later
> one.
>
> Moving that page with UFFDIO_MOVE then fails with -EBUSY, even though
> the folio could be split and the page moved.  Callers that fall back to
> UFFDIO_COPY on -EBUSY end up copying instead.
>
> Check the flag on the page mapped by the source PTE and get the folio
> from that page.  Locking, refcounting and the split-and-retry path stay
> the same.  The batched path only handles small folios and the PMD path
> already checks the page the PMD maps, so they don't need this.
>
> Tested in an x86_64 KVM guest on mm-unstable with only 64K anonymous
> mTHP enabled: map a 64K-aligned region backed by one large folio, fork,
> let the child exit, write to the sixth page and move it.  Without this
> patch all 20 moves failed with -EBUSY.  With it all 20 worked and the
> data was correct.  Moving the first page right after fork() still fails
> with -EBUSY, as it should.  The move tests in uffd-unit-tests pass with
> and without the patch (the two swap tests were skipped, there is no
> swap in the guest).  I didn't reproduce the reclaim case and didn't
> test arm64.
>
> I found this with Claude Code while debugging an out-of-tree swap
> backend, and it wrote the first version of the fix.  This version, the
> changelog and the reproducer were also done with AI help.  I've reviewed
> all of it.
>
> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Link: https://lore.kernel.org/all/20261116110122.309748-1-nakixii@gmail.c=
om/
> Signed-off-by: nakixii <nakixii@gmail.com>

[Severity: High]
Per Documentation/process/submitting-patches.rst, the Author header and
Signed-off-by trailer must use a real name rather than a handle or
username ("nakixii") to satisfy the Developer's Certificate of Origin.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117191853.1314=
834-1-nakixii@gmail.com?part=3D1

