Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FFAC606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 00:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bAv6N4Jl
Received: by kanga.kvack.org (Postfix)
	id 24B686B0A91; Thu, 22 Oct 2026 20:20:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FC3D6B0A92; Thu, 22 Oct 2026 20:20:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EB7B6B0A93; Thu, 22 Oct 2026 20:20:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF4E96B0A91
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 20:20:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 610861201FD
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 00:20:29 +0000 (UTC)
X-FDA: 85351984578.13.AAC63FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id B2267180003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 00:20:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bAv6N4Jl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792714827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Mka4FJTWospogWieZvcESfWOWskKq6CXHFagjEX/04=;
	b=RPB4rHMX8H79+zIQeU9ZEPp4qSv7As/g6h0kAX9fqYi2XWQw4s/9GWSDZgEQrwMNtNVNRe
	CD+vDsdwFgn32p22T3w/AqTc1A60ZA0sygx+DMBslABJIS4/GnJcoVKYTmGqnsl6BRH8lK
	mxanTglWeDz0s4+IQNAbIIQFLpvY1Hc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bAv6N4Jl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792714827;
	b=Q6tawC9Qv8fYBJ6yAZlE2j9fim9GbqTy1NCw2Z8+yL2/cHwf9YGqXl7enS4rcn2ax2uAiz
	q9CE4YbVA6L8BGbueDIkh0ti5gkBfVbjPkfVD/6jJc6l7NM5qmLg9RPXsERuPt073JR/2+
	mH+sl5EacFo4xhTlZ/JtEQeE29i3Lig=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B0FD414AE;
	Fri, 23 Oct 2026 00:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6521F01825;
	Fri, 23 Oct 2026 00:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792714826;
	bh=2Mka4FJTWospogWieZvcESfWOWskKq6CXHFagjEX/04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bAv6N4Jls47eUd+FtgHxBHbbtejWHerLskLx7/lOaw2DPB3dm4hyKaLLHl/ILiOMB
	 k8sUkkbwQyxWOaKalKneL2hPpcsx5nW6TqUjebP4TdaJ07z5iO3UIWbHFgc/byVPOb
	 CpqhudB+SWrvc4ryM0nDgcBTO1eVypQJ0Q6zakeSbI9OY4dzW7hCnhehys7PQlBnoV
	 99lBqYevUHVghak2+8QZQsQ9s+KIU2sKPPsjVucJzBdKG4o14vfZGnmej9MhALx8al
	 tNRWi/eZNv4efnx83cCGasmpO2eixfnQv03QfFlDJVOeCD8cpt7ExUxZtO/LEhq811
	 vFmbLKMOe78oQ==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shubhang Kaushik <sh@gentwo.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Fernand Sieber <sieberf@amazon.com>,
	Leonard Foerster <foersleo@amazon.de>,
	SeongJae Park <sjpark@amazon.de>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: Re: [PATCH] mm/damon: align MMU notifier range when clearing PMD young bit
Date: Thu, 22 Oct 2026 17:20:17 -0700
Message-ID: <20261023002018.102560-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To:  <179267916870.2.5637290691657871645.damon-pmd-align-draft@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B2267180003
X-Stat-Signature: s8zqber93p9owjqk35e8ek4asabsi3gm
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792714827-554857
X-HE-Meta: U2FsdGVkX1+iS6yvFXlFgiwDUpNLxSdcsAVg9i4+KPRKEnLEJhTkCVEufKopmPq35bgeMpvc6/Tg0QWY5EaF8igJKVKhjdlJsqwOJYdfLyiJWtN3JiLuR4uuHrbY3yoR/N46/qoUExgNbdAyuZ8a3W1wwNMfq8jgtbBzSSyYyGOoAoG3n/DW7+ea6wAePzVM7UN7u1fEcWQUQsLBHgHWYCvCiR8ijaA+MKwX0ln9B2LHj4Ckc6dNqKycQnwFe2qaVn1/4H6AmYVrdFwaYVU2pPC0dLaVAMjXjPlT3MVfae1fSqDjFZ4rqoL0whhFeKpPWE0vGrHo9STJ1w9/8QA37tKJ2P2FbGem2pY9HuOkvQtwEjK5H7ZxKKCFiRQmIsXnRh7F++lpFTZ1xz0PLwnwP7y7oAV1Z2ObSy1CSb0+Lf3Bn/8OhYxX8rrgSuHilpTE8F+NolJ7NKC53dsx3qaIlRS/4ztUzKxxeCbLfxsTFrg70Sh1YnJVk3y7FukEpb4Cb9bAlPuOE7B/oSDiYVeCJ0vzy28UsR+EFu0YIRB3w8Dom3qvozTf8irqdphuDTpJ0ZVQMCrhYN6FoGJ/rKfJMwRvyvhtNYpf+XF9uUKFO12Y2T0pOOB3xbrjp2dRuarmjRQEnVA2rzHicSIqGKkXcIzbxapTCPYuoEWxzzqCyunMvcb/Fc8Cgp2gCJd1A0nW9dk1wVp5FATjJtvqk0YaUFX0vspE0TMPxAQu76dc/E4xNW6yvwlWJzWL0R/ASGQ3XQA0kBAheFvzABQqyMMb4IflZ07yeP1ggSc54jeyFgDf9qhVSJeo3qyI5H3vHWZgBZgFVXO685uY9P2Z00DhRDJdEZMQwqoWcR84CPrdeOTlrYk+u4j/vkw2iZlZpRQn3IFyg6JDUmN8jwT8QnXw/744PrKA95c+EaaNoV9lxH7PtSOTHVFpS+YMcApLsEJwkwkHG0Oqh0lBjC+5k90
 orJuV4i/
 v+1AqhKA3NT3K6JA/Z4VIH+2ArrNhu7hWamG0k3ujjAugnBWKNjR5zkErhTZoWRi090t1sZ5QQw9e6qbuTWrfVwIDVD51dOlP3lFaoNQtcfjEd3EmLcmSGjjNJAMbfyMw0PfFlaj5yOtlTtXWRGN1wkHSwy/vrDGGuwj7VKCp7qNjCXHNMM2LOnuTY1QNhZ1UjWu/updJvNtFAsGDqvc1dTYJkgSfNvUyWKneKuLLH+4whqfXTOkSe3V6XhVqNZlgQW44C+ckm49SSiNQIvaplGaxBLJj/2oFEYIHws22tIDISU2SHos0M8XEH/dTnlzzu93s268jgfPmBUJ/RGFLkamnWkdluB0pTRcZQEr48jWAL3KNcc/Ua1b+ZFr1WAr/0i+CDhTovRm8CebDSL36P87NkynhMnjDz1+uYsKsOoTzFoQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Aveline,


'hkml patch check' [1] says you forgot Cc-ing below people who are recommended
by get_maintainer.pl.  I Cc-ed them.  Please Cc all recipients who
get_maitnainer.pl is recommending, from the next time.  'hkml patch format' [2]
could also help you doing so.

- Fernand Sieber <sieberf@amazon.com>
- Leonard Foerster <foersleo@amazon.de>
- SeongJae Park <sjpark@amazon.de>
- Shakeel Butt <shakeel.butt@linux.dev>

On Thu, 22 Oct 2026 22:26:08 +0800 Aveline Noir <jm5905938@gmail.com> wrote:

> damon_pmdp_mkold() clears the young bit of a PMD but notifies
> [addr, addr + HPAGE_PMD_SIZE), where addr can be an unaligned sampling
> address. This can miss part of the sampled huge page and age secondary
> mappings in the next one.
> 
> Align addr to HPAGE_PMD_MASK so both operations cover the same huge page.

Looks good to me.  Thank you for fixing.

> 
> Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")

This is an improvement of monitoring accuracy that DAMON provide only best
effort.  So not Cc-ing stable@ makes sense to me.

> Link: https://lore.kernel.org/r/20261021-damon-align-pte-young-notifier-v1-1-d0365ac45b66@gentwo.org/

The is a link to Shubhang's pte_mkold() patch.  When you add Link: to your
patch, please add a context on the commit message, from the next time.

I assume you added this link because you mentioned you will send this patch on
the thread, with your nice review of the patch.  However, I think this patch
explains its context very well, and therefore this link is not needed.

> Signed-off-by: Aveline Noir <jm5905938@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>

I applied this patch to damon/next [3] tree after dropping the Link: tag.  We
are now in the middle of the merge window.  It may be better to give mm.git
maintainer (Andrew Morton) time to work on pull request, rather than adding
more changes that are not really urgent.  I understand this series is not
really urgent.  Hence, Andrew might not add this patch until next -rc1 release.
In the case, I will request adding this to mm.git after next -rc1 release.  Let
me know if you think this is really urgent or the Link: tag should be kept.  If
not, no action from your side is needed for now.

> ---
> Tested both aligned and unaligned addresses on 2 MiB THPs in an x86-64 KVM
> guest with a recording MMU notifier; all ranges matched the sampled PMD.

Thank you for doing the test and sharing the results.  Were you also able to
confirm the expected wrong behavior (missing part of the sampled huge page and
age secondary mapping), too?

[1] https://github.com/sjp38/hackermail/blob/master/USAGE.md#checking-patches
[2] https://github.com/sjp38/hackermail/blob/master/USAGE.md#formatting-patches
[3] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

