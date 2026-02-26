Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8B26FD8FF5
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 19:08:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF2506B0144; Thu, 26 Feb 2026 14:08:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D75F26B0148; Thu, 26 Feb 2026 14:08:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C83846B0145; Thu, 26 Feb 2026 14:08:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B65856B0207
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:08:09 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 547DB1B5CA1
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:08:09 +0000 (UTC)
X-FDA: 84487543098.30.32F86D2
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4CE18160011
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:08:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xcdCIWPN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772132887; a=rsa-sha256;
	cv=none;
	b=GBC/JSpKq1ZYEATFw8XJA0YK3nCz0i/nvRK4uicZ9qSa5tH1eCHovY0V1thh40b4Oqw8iU
	Y+EiMBhUb8g4LWlRJ1Go0Do8CtyWG54NFMMoN/wQHqLLAjfh5Z79fMsioPxLIYCcJ9WlAv
	cIJjQwIa9kp87aDOAeRY6luuvXVX2Q4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xcdCIWPN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772132887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qnz04KoSeLYWXnrsOC3JNgCNE8W9yeAASjRrer+Hk78=;
	b=oKOw6O/NSLLogKBOXArME+RT7bmkm8v4awkhAFtCF1ln6An7fg80PKzc0UsHlwrTORr9OZ
	u+IXm/lVbno60LJVPWYmLGzVAmAcX8aR4JCFu9agxfrzx4sU8285iqdDpA9abEaTEzSXQ8
	qLyeDp4K285cUhxfJ+/qlYjB90pstZ8=
Date: Thu, 26 Feb 2026 11:07:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772132884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Qnz04KoSeLYWXnrsOC3JNgCNE8W9yeAASjRrer+Hk78=;
	b=xcdCIWPNB2YdRrnVuyylqSjUcwyXHjxniab/BF//SgB52TDmBLqxS5u6NpYGv6dxTyUZ6H
	2X1k/zbLJx+UdJWHwr2tYqx2+ZxmRY0jNduR7EBdi0Pno3q/Kg7PwpEKLuEsl/sD8OuUke
	2x2VKs+e+YmwAFVRCNKiF2HsHvZfxKs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Oscar Salvador <osalvador@suse.de>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, kernel-team@meta.com, 
	Benjamin Cheatham <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v3 3/5] mm: convert compaction to zone lock wrappers
Message-ID: <aaCZ6Kmi71liz7K5@linux.dev>
References: <cover.1772129168.git.d@ilvokhin.com>
 <01729baf359e4c6612aead53f1fcb644f782d1de.1772129168.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01729baf359e4c6612aead53f1fcb644f782d1de.1772129168.git.d@ilvokhin.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4CE18160011
X-Stat-Signature: 8ejh1brpiq6o5g3yyg5nsk7c9395qj8j
X-Rspam-User: 
X-HE-Tag: 1772132887-977826
X-HE-Meta: U2FsdGVkX1+fa+7x9PHZkZbVln3484u40QdLkBxzp1YDvoM3noFR1KYE/8Td2PbehBL6NDt0JK+RpPDeZex1imZYltcv3S8JfRn4mqKxsqvBw8FAngD27ikxP+d6xlSzerPdXiGMLDFz294ocHb4OD0ESJRaCx6T2wQiuD5hrtaLbasy+2K1HcwBYJqbz/+dBwBCUZJQwMfMff4v4sDOPhNRUzAHrqrv6UXlKh39E9m0NJrtxCeEeGre4gLXZ9GAYFPc0LD867oOEECrMvS1vWzoRWcgM45J+HOrdhAWqiSUGjjmF4O8adfAA6IeZ7pniSJdEOVCgxDx88D+5rrlp2ZC/nHmJAkiedMQKJ3kn4F7ot+jrSLmetSmYTOpIOZ8AL4dJJUbYMRs2N+9ywDye0kPTqXSXsI0+fRf7bS0Tv6nfP6QAcC4BmG70HPSpii4olNz8qvv+TXNTC5oXUjZqTq1ToPtb3179oLDKGkoM9kLSI8lH/HaAMXB+mzQITo1UT+z0mWb6uTCRdsMto3Xa3LAje6A010LdJ1DbzM08RbkFBwa/sYS1BulzInlFAM0ABlBk1Y3y7jnK9A+wpDMWYN5O90F2SXzGbkBHTXitezyN3u66xkKDnmqTcC3zYHe4cSrQ+/h4V4SclJ7eXI8IttncgvFjFvm44CmxdrI4I+N0ImU7j6CdojCQYP2b9KpmspEGRM+oSHUW0nYggmGEwTjO6v3kriYTOqF227jKQz9Tsi2fLF/Igebc+zljVoAGS0rqSHK0OkgfUJEyGB5Cjxnr80lOF1BSxuXKgQZfaDRaP1B8B3YIjuwvWTcimnJo7++76ziQbzly3x5H1CrhQyzj1rgBa+GRS2o3BRxrYitNMiWZhOOc7fgeLeFNQaEY+ocYAh5PJr0Y03tQHTBavQJ84NIYh16Tqr9F1bjGobKHQjsLekWc5IoVUD/Z+KRnDyVu0ukuSY4tgqOvgc
 xXyIcMBB
 7vLvxClhNJQ0TeeYKteGm+mnq+wQkWyTKRuP2NUmlqD2NJ67/dpjaqeFu+fhMAgN//VJLtScyzFExY7H5BTDyqLYlMDtRko871Yj1pUhZroUXiaDiNIsr0St9sBhq3crFO4ozfjuwNOdE0uH3TdT4vzJSbK1RZaMJ88wK5MuIz4PS7wcVbkWhBC2u+yN7Yz1myErXywq5fgN2Dj78FclCHR/MeADqq0bg8Q2zCxUa6TOQAuffKNLu+ZDrtJPGd8g0FhpbzUc0gA74WAc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 06:26:20PM +0000, Dmitry Ilvokhin wrote:
> Compaction uses compact_lock_irqsave(), which currently operates
> on a raw spinlock_t pointer so it can be used for both zone->lock
> and lruvec->lru_lock. Since zone lock operations are now wrapped,
> compact_lock_irqsave() can no longer directly operate on a
> spinlock_t when the lock belongs to a zone.
> 
> Split the helper into compact_zone_lock_irqsave() and
> compact_lruvec_lock_irqsave(), duplicating the small amount of
> shared logic. As there are only two call sites and both statically
> know the lock type, this avoids introducing additional abstraction
> or runtime dispatch in the compaction path.
> 
> No functional change intended.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


