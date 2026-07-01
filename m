Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C07DC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 05:33:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 541896B00A6; Wed,  1 Jul 2026 01:33:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F3F26B00A8; Wed,  1 Jul 2026 01:33:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E2746B00A9; Wed,  1 Jul 2026 01:33:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19F8D6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:33:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 99C551C66BC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:33:36 +0000 (UTC)
X-FDA: 84939090432.22.5979372
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id CF9BC20007
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:33:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AWvtcZHz;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782884015;
	b=x31WPqduraj01WWFnO/x0N5AO9tuBvBbcuE+6KeiWz5jr3cJsQ/1wnRQta7HhAeeDv6s0q
	dXMrsOaacl9ZoXNDftHawqMR5Axgs+xYr2xPrMoG8txcvZLp0JyfHymf/I5YvLLLEkAQy1
	ca6Nj5R5VbTOCWAa6J4xiJgAbmqDSPU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782884015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e8x0DVh72346v4T65zlhFNs55tqSgEr6iUQN+gRodPQ=;
	b=xBHQpRm/5xCMkHL1MeEU4AdG+IRwGs8CS5xjDxJNiNwqtWARvcG3Q9wJ2+X11mugBe3dLW
	6KIEm6s4D8/j+n6u6HGXQOpVRtwpPSdY/PKq/E8MschkF1SVNZg8xjEn3cJglDF2SnKi5V
	YW0g8/qZzARDJG2MRFuF+Ko0Kmpdp08=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AWvtcZHz;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 95F2940353;
	Wed,  1 Jul 2026 05:33:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E1E1F000E9;
	Wed,  1 Jul 2026 05:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782884013;
	bh=e8x0DVh72346v4T65zlhFNs55tqSgEr6iUQN+gRodPQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=AWvtcZHzIS2f1Cz8Ls7N77oIWgF5XOElmjHIPsbBdQ+CcyM6UdcSEgScBL2T3WKJt
	 7pdbEd4uS1oottAlHKYpp/Ncu2yOp401whXb0V9YucSMlbtqjfSJ8L0LZh7ln4rDuR
	 VYxjA2ytOJPJfb1yvIxjwv0lew/fcm3IkGp1kM6M=
Date: Tue, 30 Jun 2026 22:33:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vivian Wang <wangruikang@iscas.ac.cn>
Cc: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v4] riscv: mm: Avoid spurious fault after hotplugging
 vmemmap
Message-Id: <20260630223332.534218a41b2f574de327e4db@linux-foundation.org>
In-Reply-To: <cd8cd425-7615-49a2-b26e-81a9aff0af28@iscas.ac.cn>
References: <20260630-mark-after-vmemmap-populate-v4-1-febbc15da028@iscas.ac.cn>
	<20260630211100.5c8f09c607595fbb5bca0a74@linux-foundation.org>
	<cd8cd425-7615-49a2-b26e-81a9aff0af28@iscas.ac.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CF9BC20007
X-Stat-Signature: 9s4nio4qycttamw5e13mj7gxnmekcstg
X-HE-Tag: 1782884014-446027
X-HE-Meta: U2FsdGVkX18zEN0y5nXplbeo8R84CxWKq8z5q6DEjxI67jha/EoqmUT96RRdvBiucCT/QrTPsenvmjk6T/083P2JaCFfFqoCcvRpnXEFFqWJHaN/ERYdtPEEB+j+/UhCMHg2SpRRgZu19K2kBHyPll6xoLPt9mQzT1xmQ1+ixsSaTsEcoZJsP9zkX7QyDW/lVJdYPQViLCR5ShSivvXLcA7h1bhkhB5cAO2LURh7xw6t/0GvXkx3g7tIGXj/5HS77AW83+vDGR1wtQSJi42UZi68//MtyoByYNv6JdlwoGPPiZ03IehI8ufVNlkgllif+57HDuAuJCxAkXV1lDdNq+fJjDI7Lt/+iB21iCewn4YERv8P6O44+61kMcIokTHG2EncAgsxZWWVxaeHHsTw+T8MYcWAcWvtJGLEWV+ahKAQBvm45R9/VB1Suwxno7TRJkJ+RFBgXyoDsQH0195nkyP+vMgOsYmhmtxLzLLEl+7bMOF5w2lDUraxwOKKdUBgKWoad3rhoqnHkpMAsImanQsnVhPdyk4/vbDtj5570daP9OShy6v+6y2vgAx4dlSMIHMllGFz4ntpVSiDG+ofEB5ji79Hcf9RrCXcXsWvCsDcOTfIn5oqSaDpX3VOMtq37OJR0HPT6XmsONuMC0/tBz5EVIbs6rcSR0CEEUpoiAC1kGOMvZ2Rhs27LyCEc5AslrNX0BN11dwsNQpB4JR1Z3UVxVa3LRzcbkJwB/Efc9EDH7JWqfaLw/SqLMkIXUpUfhwNWxB4wOs4xn+9vM8NWkg6kdM8sKvoC2wJ9IyKgW+ik+NrnwIyp9YkOGkLcD7cFmdz+pnAyFrQ1e5jfsmsZOqqr4GF2DMHnKXN61OLA+jfQIB3+rGTbl/uSy4v6tQvEjzxyl7+APHLlTlnRhHVzc1psx8496c1D8dKRi8z2kO94mA7EsX5qLbO8opxmV8xsyKZnJLdfF+MaTw2FRq
 mP+9uBh2
 k1Lkc9afp0lzjkliabzH9kmEfNkCCZbAjY1Z1lrNjF2Hdw2KPgZemmz1YFWm3qwvSB9EuyJK0iWGZ/w3AkAyXNkhXEM6vf76RQg4X4yhbOzZWmS/yi1attjF1ZnRzGkDcsPeos2d8tqkb9jpVkg41IlM/siAvkDJ5rQ0QYsWdovUQrMICO47XTTm1BtD+QMsG4jY4qCY28XhDih4c6mZP+F9ePaMYJ2KsTov4PBtgJmpvP/NRU2Nn14hAHvFb3FkTT8i/uiBZeaupBJpq11ayLH2BgB1s2S817e20mMsoRhZ9M/VDbptG2DDrchfiI1bI1hDHt+lsjOsP/oGdvzDF2zDR2XD0VEJT2uBVkyTTOoO3N3w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 1 Jul 2026 13:01:15 +0800 Vivian Wang <wangruikang@iscas.ac.cn> wro=
te:

> On 7/1/26 12:11, Andrew Morton wrote:
> > [...]
> >
> > btw, AI review suggests that there's a missing barrier in there (a
> > pre-existing thing)
> >
> > 	https://sashiko.dev/#/patchset/20260630-mark-after-vmemmap-populate-v4=
-1-febbc15da028@iscas.ac.cn
>=20
> Interestingly, whatever thingy that is sending patches into AI review
> seems to completely strip the message below the "---",

Hey, what do you expect for $2,000,000,000,000?

> which made it miss:
>=20
>     Changes in v4:
>     - Rebase on v7.2-rc1, drop dependencies
>     - (No code changes otherwise)
>     - (A concurrency fix for mark_new_valid_map was sent independently)
>     =A0 https://lore.kernel.org/linux-riscv/20260629-riscv-mm-new-valid-m=
ap-ordering-v1-1-60d8c10c6292@iscas.ac.cn/
>       ^--- this

Cool, I grabbed that.  Same caveats: riscv maintainers, please?

> I've reported "being able to read below the cut" as a feature request to
> Sashiko: https://github.com/sashiko-dev/sashiko/issues/306

I'm not sure that Sashiko would grok (heh) this if it was above the
cut.


