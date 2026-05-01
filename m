Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE2D7CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 17:15:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D2226B0005; Fri,  1 May 2026 13:15:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A9506B008A; Fri,  1 May 2026 13:15:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E6756B008C; Fri,  1 May 2026 13:15:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0037C6B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:15:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 955BC1C0035
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:15:53 +0000 (UTC)
X-FDA: 84719503386.16.C0B714D
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id DBF181C0012
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:15:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=gqO6BQJ9;
	spf=none (imf21.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777655752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lmaggGKXjL+hs9vD7vyc+xo8l4bXJig4rJbrMoWWQLU=;
	b=yXnWJ7eA6HIkHkD7xNjvM6SHNozRYZEWA6ZU3X3i3FLXqD7mCvViO6GRd3xXrSqCNRdv7g
	+vINLGRdG/hbeAwS+9vPqJGcDz4xHTWb1uaLGYaCXh12N5oEu32sBQsL400udzvTHACsaQ
	Yjemzgpdt0vEuCiXD+AAJS2m1Oi8beo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=gqO6BQJ9;
	spf=none (imf21.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777655752; a=rsa-sha256;
	cv=none;
	b=JXeNgLMzf5JkdO3L1Yc16Z7AYqZrQ2La7jA1/V05lQk1qczmlT+zQ/mX/JcC/LwOozUotx
	FviPnf1Tg7Y2D/qDyVq/HfEP2Vl4j8uOirrSf5XVFu4doPbjU0zG7jT/SQXFLW9flc44KP
	DffOgnC0Doe7UWhmrm1YAFYwUaw+UYw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lmaggGKXjL+hs9vD7vyc+xo8l4bXJig4rJbrMoWWQLU=; b=gqO6BQJ9uH6K1zXtg5ggnRVHvu
	oiIcgkEcsxv/g4xDbCbSN4qwY3e/FBYUF4i0kAmaYisTW5GM9X0ubuwhLN1Ff8W/I2pr3Uf+ADGgH
	EpXZ9aG/WQXvDtORp7mVmvLL38EHjp3tIDtmZukdkNe7s9yiLl19WjAzhXABprcPVAIaKHptvaSjq
	svSin3Oh4H2Ph2++hbuIM8dOo9yVQ4+glNejcwDs/ZxzvPAoaduomrP7L0apMEsuzpfj2Tnc0me7q
	nmjr3HdAThIJGFw3x4dPmqsuocwe+SEFe4nptQVm+XkX/iifH8pMrADqdfDXhxtNUgpuA/+icz5pK
	wnJIOIsw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wIrSm-008jKB-2S;
	Fri, 01 May 2026 17:15:41 +0000
Date: Fri, 1 May 2026 10:15:35 -0700
From: Breno Leitao <leitao@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 0/2] mm/kmemleak: dedupe verbose scan output
Message-ID: <afTfg_FOcj3J2kgv@gmail.com>
References: <20260424-kmemleak_dedup-v2-0-8bea649b2a92@debian.org>
 <20260424103016.4ad3219ae815e45de62cfaf7@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424103016.4ad3219ae815e45de62cfaf7@linux-foundation.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DBF181C0012
X-Rspam-User: 
X-Stat-Signature: trp1hgekkeajpgdeikhrqrb4xpyura9z
X-HE-Tag: 1777655751-898824
X-HE-Meta: U2FsdGVkX18JjajN6WO5S1MZ0QbIYwO3KDhM8npred/akVeY7OzzpS/bCMVQ4GegUhb0xZtPpt9Dgs7Qu4DXpTbXaPYXwreBMYFiumMHQn5bOoJOEtSi8nzQldZw0+/xXE2SuA31ddjhCkXqrVMUHi9XFqDqjOim05msvmzq9P+SNZBVo2ScFMCkVCIYKp1oadhOrvG507MDdk70vd98r0i0msuU3yOhnPf8sfXbL5/fX9iTJw+agmp21iRA2lq8XIUflGehsL6hNbDE79xwUifKF4E+qK80MUp+at0JF51u4wDuO4Fcui27TwCrh1wDc7RKQyJ9iWqHUwLB85wa5JR8tPnL8jrAnYFBhnFcgCVKvsBDUrqGieJluhWOMk2iNNDKEyxn88RzBOPgR7YPL8oiW1SdrdIMBD572zY71Lx/Fr0EzQGkSSf/boBVofFKmrEvisX5NWlgGeS14qfzR8KveNdBAFDZ9kKaBRu2aUxpNoXZ17/Gr/Y0FaKUl24kbeKjN46IFJIHD6rLiRAA6dKVnWy+vpFtn1SLBw68WiIuA9K8m83lHZnWdkKXxfHksQ9ijkzMacfQ5ZZOSTTZnBZSUs4rSz8ITHniu0uESgFfc7Pi43pMfh1Z4Yo9RnWTLSOiNHLlPuLc3abETK9oSrY0ej1eMyWLsVtclsok2zkWdM9nsb75SzmTFFPee7lt4v2Hn7sdpYwIqxxqnLjbApgBAeYjXy300Re5BDvE0GOnPt40iidm8AFIb+9hm9o8bxdzDSKTrcE8133YDRDFPafuuiqQ8hBkPPn6DUhEMzU2G4dk6HrJBWiZpEt9lDk/7bQ6fucb27etI9xpE996ooNkf6kN5LtOvFWLkeDY5mufu4HE3x28u3u5cN+YX5H8E9SBckyjTvho/9M3mgmIEuhTfGdW8Ma4ANzByAUy1D4fguWjUSSQd2O9cObAiZ6uee4LqKPXYGpJhNJQ28u
 l/LH9Z0r
 w3nyYcBnRZ3P++8/7u0VqjtoGsvGfAMHguF18l+sKkjEIUIvvnJe6FX+XsIEkqqIp43qHoJFg4/8NkuxqlUJBy9cYkM7g0Dh1hxZSVIZuck6Yb6/uTqOsg+wfNCMFKzqLtVFwKNWXF0othKxNjr1enu6ikpeBfD32vS/Ix6LMooZCJ7x23XDLsEJX6boqN1FYhS4B3h2+NuCh1tt/Sc+VCRf3A8AE19J5+slB/wDFch1R2kpZHLzXokUglnj8OnijskKA1taqmBByizVanvyHX/aBq3TxnEH07dLj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 10:30:16AM -0700, Andrew Morton wrote:
> On Fri, 24 Apr 2026 08:03:35 -0700 Breno Leitao <leitao@debian.org> wrote:
>
> AI review likes the kernel patch but worries about the selftest:
> 	https://sashiko.dev/#/patchset/20260424-kmemleak_dedup-v2-0-8bea649b2a92@debian.org

Ack! I will address then and respin, thanks for raising it.
--breno

