Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C811DC5CFC1
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 02:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47AA46B0088; Tue, 11 Aug 2026 22:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42B8C6B008A; Tue, 11 Aug 2026 22:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31AB46B0092; Tue, 11 Aug 2026 22:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 116766B0088
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 22:57:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 908151402C1
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 02:57:06 +0000 (UTC)
X-FDA: 85091105652.02.E4A74B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 12AB41C0002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 02:57:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F6dTegZ5;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786503425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vJNyFEDiKFhs2ub4tOpr7dJKKD9MGTbXcSZgKL0IZ6E=;
	b=xGcqQfGEQjzjq0SIFo6XX1jbsXUwechHe2/DMk42fyUqH1n+bXTRqki4FdjGF1TJ/wGOZ6
	UOOrKVHslBkWconblOFXkOqEm7CBBABp7Flg+y71XihdTkpsEhAdlgU5/9qd3F9Vj+m4Vw
	6yRrfYJuZ8oaEEyHlWApjd47TXJIDWw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F6dTegZ5;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786503425;
	b=uDf4DraEJrIa1w+BzzV/gduVjisbVMK3W+t7cWAQOxFYBVl5x9WI43yMgEPG5WcSqOmZIo
	qSHzezdj0nrO7dQyG4+UxgMksaG+OmoEJ0YNLdyqb5D4w0Eaaa1Ohaxdg5ll3XShesGaKH
	vh1QHUT92pH/UjQxmwlq9EczhVfjD08=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D840600AE;
	Wed, 12 Aug 2026 02:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9152E1F000E9;
	Wed, 12 Aug 2026 02:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786503424;
	bh=vJNyFEDiKFhs2ub4tOpr7dJKKD9MGTbXcSZgKL0IZ6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6dTegZ5oInFJcXZFPtFebuiKHa5HOsxK0VWXnv423M8OB+tkxT+G4dFnCqcDtwMD
	 qIkF3l68w+MdjPaPuXdJq3vz1zeDyQMvbklnworS4FoEnQVj5qUQ5zAkNW+jllAHfE
	 Ct2iBfFdGt08QLyazC1mKwIMGmDwMXWQ6h2I+twai2ibDDmyR+/88oX8fEzcWIJxOQ
	 hKfKWRnQXqS9ZiXOIe+JG90y/wJ0jk9xQ1NAnZ+fGyUbEql3yWSrs4pzUYS4aFyxxq
	 0R5Z+PvJU6LBlgfQMHR14Q6/2Rq2SZxjA7+pSpniB4JXnN+2JJ1DdpQ8P4VT/VK8LJ
	 CpMP/YirfZDhA==
From: SJ Park <sj@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: replace custom bad page map ratelimiting logic
Date: Tue, 11 Aug 2026 19:56:55 -0700
Message-ID: <20260812025656.8687-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260811172156.356053-2-pfalcato@suse.de>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xe5jquej3z6djfbw1y5r7fpcwas7bzdf
X-Rspamd-Queue-Id: 12AB41C0002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786503424-248009
X-HE-Meta: U2FsdGVkX1+DWdEprBwy/4j8C+kyG/IBAFspyeDknIg30gyMjuUtvR2rJzmNTVGWBJa2smVcn/mJp+dntEHCLUJ02j9dRQyNq8aIJ/a5a1DyuUhV0Bf1Qxu5Evww8IwLXl1NUud7wd0uFoDj8hsZim1RJYWwIQSI5I5aoUj6HgjKoRKqZOE2R0wJINULl/nI0CZy3e8VpNn7TGcl277ylXXHQ9b3qUfGKpaXzqGDd3V0f/PSr21uMCzPa29MUtLLBx5tNoBnanpDbazdu/JRl9k1nnqnGBK61gzyvJ2U6q+xh6OOyZywUY37ZkTARPI2uYHqlNU9JgjwFXDQ/UKmpXD2UllHJY/BRiL1tzTZDf+51Vw3FDbMtS6coRI1O8eV9aEoHJK+pU+dIRB8KYeudStg5LVD4KNjAS9s7puExZurA5r/l6+KEhyzuqVPznE2aF3f8fxaE6+bmCVg5CdWo+Q1ce8xOOwdAa1wsqllL+XCpYIUtgCUrKKnwscbE3Wr/+DuNlZfbvMav2EHuhFebwLXXAQzL7vajbRk3Ei+Ng17C/ff0JuD4+kA0++9FBGP53Rnmr+0oGcAL7LDdyPcpVUVVJxF3Uf0/eVYO5+Y4jQcbmqKvwQ07TCzjCNLgfEZifFY6sPULTdYVycxHUuNaOSnBcK5Yi3GrWDj2CFBhmEKXLcF4a2q/92iwnQ64P8tLjBAkFLwF0CxTonCHVVgBmEFzfQI8Wi3I91wfqbA8n6fpOETlBeZj8//Fa8v8mAHtwlHTgUXwKL4UPV42tpiSePsx0nE5Sl9TJ9+pYfkjq4SL/1vrYy2wJw5LnadfoSGWeJdgaEiQjGa4QLikz90MtmRvMcVVGhSCDhZXqT2K7e3U6pjnSlpMo5fZIHzZIjcnePRIbWjbOZmBkVbiobO4QiEJAaDfdlAN1NoEFtwXThh9qpibCToYtz5W0mZ+MnIs8LPeQjYokBDpXiP3ev
 wTUJxyOp
 WzSgACV0eTTP14bd7J+/SF9ffBRvi5/y8kVVyYLSeX6FfdI+RVTyCef5f6xKJyMi72ONms3PvVsAy/9TjLlj8bZdl1UppZ30lzCnlj/rmaMw36L1T8tr8iTT90HfH9cacsLmWnuKIuU9WJrLEuKMd7z2hhv5qyE08B5O3jZD/txlhCxF53c01cdnOer2fRowwDKM3ey7Co27lmuTcOKD8ymF7Vqdb5DuXaEedKy2kSAEDC/c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 18:21:55 +0100 Pedro Falcato <pfalcato@suse.de> wrote:

> The current logic (allow up to $BURST prints per minute) can be entirely
> replaced by the generic version in lib/ratelimit.c, used around the kernel.
> 
> Do so. The only functional difference should be that the new logs will
> read something like:
> 
> KERN_WARNING "print_bad_page_map: %d callbacks suppressed\n", ...
> 
> But that should be fine enough.

Nice cleanup, thank you!  I also agree the change on the log message should be
fine.

> 
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

