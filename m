Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 653C0CD98CF
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 00:22:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 550BE6B008C; Fri, 12 Jun 2026 20:22:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5017A6B0092; Fri, 12 Jun 2026 20:22:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4175B6B0093; Fri, 12 Jun 2026 20:22:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E07E6B008C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 20:22:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D6405164EE3
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 00:22:18 +0000 (UTC)
X-FDA: 84872987556.01.2CA352D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3ED78140003
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 00:22:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q220K7Iy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781310137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rgplnA+llGUVWp3gFIQNrGhQpQLdVeMIm1AEKwpWjRs=;
	b=dtc4gPmJj/dPtJCY6hNCJi3QXOmeU2JzJsPIkQT4wPcLTIGslnhA1crVXeg8Mzdu5+Hj/o
	7T9sOjkpNK3NU5G4BIMPC21IbajCVmSy+NWkasy9TYAV/OWBEykQ0RkmkPJeF3eUVknp1z
	TTyc8Rk3pgR4d4PQoFFH5A0Ish2zoJQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q220K7Iy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781310137;
	b=RWIzZwI73Nu5xXozTMnl0k9eeFCMcEOqDIW4ZdY6z9Bopt/NRq935lIy0k9V8UoSAjjDG9
	JtkmV8LD3EMalfG0ryY39QHrkJc1Z28WFbpeczg3fEnDFnBLozreuLH7SxeASzjKe87/HC
	B8k0+Q9ZyhzC0p9nEsZDiHf5QnYpqv4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2751B409AB;
	Sat, 13 Jun 2026 00:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC041F000E9;
	Sat, 13 Jun 2026 00:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781310136;
	bh=rgplnA+llGUVWp3gFIQNrGhQpQLdVeMIm1AEKwpWjRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q220K7Iy8wFQmyUhyBCCdv/fayfubm5a7CIE4/5PObfAA/WU1e1xOqUDx0VwaaAg6
	 jpxHAdlDo4giFRoHthXnNq2b+OoYgI68fbp6mUUG9TK+oftRf+FuJIxD4h7lVZVqMO
	 D+FSYd5pBWk+JOPgWSrdP01rFmtSKXfFKxACcb4gErSzZ8/ZQ3a7DIvKtcC8UBUN0u
	 u1C7Q7RwBNjRfuxTW55JMd34rEUL1AUXS7NQo2wDrwF1r9qSoN5vbANI8KC2Ejw1BB
	 JHYkkT2xYLoUwNEhjC2Q9E4i6QI9rjLfFSzn3+ufoDWVrdIg32Xk4rXO4zj4+81TT6
	 ITaAnvn/CywYw==
From: SeongJae Park <sj@kernel.org>
To: lirongqing <lirongqing@baidu.com>
Cc: SeongJae Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [PATCH v3] mm/mempool: Untangle CONFIG_SLUB_DEBUG_ON abuse and switch to static key
Date: Fri, 12 Jun 2026 17:22:06 -0700
Message-ID: <20260613002207.1198-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260604110318.2089-1-lirongqing@baidu.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3ED78140003
X-Stat-Signature: xqxym9wx78sas1xpdokrfgrqfs19oexb
X-Rspam-User: 
X-HE-Tag: 1781310137-676643
X-HE-Meta: U2FsdGVkX1/YbUqv6ukIYksUC0wRd74mX2kG8Geg08nLwT6MqXSLfAauFZH4R5ltLE3nG6jPF3vb2ep1Oo5jKD/CKEPJ8ShZAJW9ehhmhtmDOGjMyDagZRMcORgftmR8M5gdtgmatFL/d/jdUKN99cFrpMQA19BNn9/VKbBdKyBkBgnTDYedctP8zhWMC/Nd8AjzfArnTOU1Wjm6P/p0R/8UExiF3Br/eFrh18Nor1ejW4XGyD7bF88QI317/mfg6lJQEkNc2VuHbYhxlbSgjhjWJO0q81OaaC/3TOWYCmtPQvXEkfl/oEqyo44YlwhT25PMqz+UBOwCV5kZWlrzQRfXy+OqbGSBUi4jqfA6inYgXDW4d+c4ieztUYIFoDGhpodwixL8VbmG2//DSimgBzSoMwsGpDL2Q5LIsMWQL1UXSWZwqjxOwrHN4rNtdKVUb9g6qRPw7OCZ1bqFqqfe6QWOWrzYDrZFTAwyM92byhedSfzTIkp7xfO9gaT03Mia6trHCOBR0narGDa9iEx+rPuEpUZEuNTLwCRkL8+3qLrK7FoNxwnuRlTBd9p9b21f7VYWg42IKcbuMah0J/Sj8JVZAj7m5nDWPUQD6O7ELOSIkGtHGSwzSUZS6BqL55tGuPe2gnMmOcLeFf6EbrlvrHdTGq0ncpZ0epVAs6+sSSQHMeOaInuA54CwyySTtmF720n38sfMAFU99/b9LBawHgMH0MeeXp71SihB4bu+NeNiULPMv6LSezZqds70fIgkigKpVOxyAPje+krD6S2lj26NXwUNB4fmpf3QIIdXvjgg3hQO7tXFnSxU+1ZVGsjy/FGcQGBN0xXZluTWDLk2vXHn6n0aCR/Bx7wT4wv07CaIXiFvQ2sg+qHiT+eT61/XqmHl9nB4c10PSxGB7VR75FkDfJBNSkBCbfGXv/pqhlCI6nMaGSYanN+CUTCZQNT5QoDqZf9CymuT6oxO9JC
 qi7MJvGN
 PheJDIyeDXiy0iYrEeE4tQlcKcyRZtnCyXaHPfALA8caRQex+sBh5Y+aaSUjWhqnVI9BodKg0RjScdi3PZpOUGVUUcmWa9/dbw5kDuwaIsMTEOgMMFdmFF2BzXk2dRwbrlF7uUgUUYW7JbnohPBHIQdeXFePXhdS1yqKVIXZmyoggKWcGSHcyFh1zH/276m1TYtHbT2zJFgVcLQFiwrJBtL8+MTXlOmAjz1/5lrmPRoAxQjDJ7boI/dPNKA6RYB9rJTbVKliIB2wvIaTmFRWYTnU2SZyy5JUP2BBbIx9JrGlrpWbsNsnIq7LDNJvvVXOeEE9edrL8Mc/c1i/a7L9PsFiVCKsgtkLXrI/+/8dsSJoZAnryZLqAv5kGB3xw9FqAXGAp2dwUd9VY/DZeEQuzIapt+Qrz1lsIteH5GYtjmqL1UQSQpRdckuNew/m697bM+Ngrsca7FKvwZxQHto+uVu9OaY/VM+nGCm5jG9vBxlskcAlWBi/FxoArnI6cEpLeaP1G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Jun 2026 19:03:18 +0800 lirongqing <lirongqing@baidu.com> wrote:

> From: Li RongQing <lirongqing@baidu.com>
> 
> The mempool subsystem historically wrapped its debugging logic inside an
> merely defines compile-time defaults for SLUB and caused two flaws:
> 
> 1. On production kernels where CONFIG_SLUB_DEBUG=y but
>    CONFIG_SLUB_DEBUG_ON=n, mempool debugging was completely compiled out
>    at compile time.
> 2. On kernels with CONFIG_SLUB_DEBUG_ON=y, mempool debugging stayed active
>    even if a user explicitly disabled slub debugging at boot time.
> 
> Clean up this mess by removing the #ifdef and switching to a runtime static
> key (mempool_debug_enabled), allowing mempool debugging to be toggled
> cleanly via its own boot parameter.

Makes sense to me.

> 
> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Harry Yoo <harry@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Hao Li <hao.li@linux.dev>
> Cc: Christoph Lameter <cl@gentwo.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Usama Arif <usama.arif@linux.dev>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

