Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DD6BCA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 16:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45A618E0023; Sat, 16 Aug 2025 12:02:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 432068E000A; Sat, 16 Aug 2025 12:02:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FAAE8E0023; Sat, 16 Aug 2025 12:02:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 155B68E000A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 12:02:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F3408356B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 16:02:57 +0000 (UTC)
X-FDA: 83783089194.02.3E3AD4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id BE57D4000A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 16:02:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pwMC0D2/";
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755360175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rFJEROw5iYhS4rseuKElZqF9FSRV7gYQF4Yx8wDDkK8=;
	b=ceY3xkDac3oyG3ytaOv4dDszgJkfEGMYXDLaw46USNlddNq/ON4l3UD10/xpnWUXB6FGGo
	JWG7YEsTqGyl2u3cxzUKodp88Ssc7W2wu6/QO4OKXWWs8l1DljxckCyhXRiiRHgFWipUHl
	i4g9yPfTfTi8XDbZpQ6d1koYG+jiziE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pwMC0D2/";
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755360175; a=rsa-sha256;
	cv=none;
	b=T14wWhSkBRFWfj1AqRFtwIwjOYehv1TWsdF8Dumjx+QFmIz7nff8NGwTVuZhhLPstTiYNh
	N+tXdWnAT5UlDzsdBrzWSqP5sG51OAh4ljgqYU/Em0FlZES7vLGRLEShZMj7ytHEBEq1C0
	EkuM4pmxFlivYW/J4q3JWUY9umCUOPc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 47EEC43829;
	Sat, 16 Aug 2025 16:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AE9C4CEEF;
	Sat, 16 Aug 2025 16:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755360174;
	bh=ktZjid3+BpzR8rOMcJIPTq3guGfZitnWVvcU1eZzbFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwMC0D2/2yQnF9vzZbqBk8XQjcx825f6bAT18NQKmIEjhUvEAJKC8YGaR7wsLrnYT
	 kKGigUhIwO6ZiJwCiiLsRZsFwJn8yDBG5OHKBCKxZlDvI7d+0KwoNw8GPJTXk2S7mF
	 HawKjKG17hQEtoeNgbvDbDQMVnmKoKOqv0gci8+LtqULDjIickRY4vrrcJZxcHj/8v
	 lv02uAMwrHy6V/eWYjPYN8OZzFBQQKC+S5x3awpNZGpbfKsWl9304Xf9dV53UxPRWM
	 BXyoGTqFT6RVIe65iTcB8VwDGN/6VKa0HGt4+a0Ps/CXtrI8mQCFE1aRPZg8yTLT8O
	 hn60Eq0gmRMCw==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	stablee@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: fix damos_commit_filter not changing allow
Date: Sat, 16 Aug 2025 09:02:51 -0700
Message-Id: <20250816160251.63436-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CABFDxMG2Mr+zO6i7a2_J5S5j7+4etiQYFur=0a+U3oNOS8TMMA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BE57D4000A
X-Stat-Signature: 7skop7xzaaa161gopiyi1593p815yy1t
X-Rspam-User: 
X-HE-Tag: 1755360175-17587
X-HE-Meta: U2FsdGVkX1+/6QEtq/S1zJzw1Y3FOUlJv5NZoveFdlLl7c2bZe5RK4Mxj4rPFpOlgGGBgMA3palHkPvxrDzwWMw5ZTEZVHyDa5fM4cYLx07U8NdaxRQbewbGKnRtZy42qxgLWCZ3nKmLxUdvAAml/lvdGvTzNOJFrp8urPfyemQZT4jJrN2Iv4cnPDtJWBV0q425Emb9CVgjy7hPqJsTVLA2QNGfs/Aux9o0W3cd5suxTlQxKDVpkF4u6uQ4sLhDQwHbRZatsB9mtpMoVB0HvHw8LhXFeIDHjMLLNrrKbP1DGtQHaO64GowJ/2NF8ZRt8+Pz2YRS9Tx5h4oi0acOO5NmuRMk60wsJCQHLDWe87jrntlDftvl0YbH7OdH9i/XAqEjDHgVJmfXOeGMmYrNq/DG4CvRtdWPDcXarb0QUwvNN2rbobT91sTwJ1uNJKpq2LsHOY8ADfaa4SpwFvy/rdoOPCuVeRvOPVzeWkPzggD1XNpfYbUTUyHOcTMTFBGhnx7NGvEwlM/1Q8FV25hHfteF+kmVMlKYUxaQzILEKtFo3RW7u4+DQeMkseP/DGpuy34AhHLORh9bOHo4PTHkaHRgHr+/RpT5cKfzFJ1223+RU+WzQNm0RujV/bFGHW/TShES56mr1LiwM3b0T41xGpQEF374NxBztUjUPQdqo19kNSLb7TmCWKrADShGWr8NItSsSsIw9J5RQ621PSMJOsMK4qqo9Tl3QU1BZv1hGr8gniyfda/KOK514Zy/tlSi/TMWrbhG1PVHgly23Xz7g4BtztSAc2/S6Dik8x14YwlpDxcQs0AZ7pBkUIvKniye0yQz9XVjH+h1BgGu4TlkCkZGCCt6fA1sNfKQoBgTqrJwIN1WWzpEUKb7xeK1QKd1uU47mRO92hkuD+hToumu9skqok1gR3lbOBX8P1gGGUkIGuoQuS6UFWWEGqe5oCGNktZK4XJoD8MipAsGCH2
 QEh208Bt
 LG0Pp6BvlHphYnkxj1DhcIvzDFdY7D1U7EWHgq07TrE3zPaBrPwzUpcqgjVDpaqncoyC60rWYL+CMDpUIAIHQCnevOztltoKS7aAv3WYYg5m3PnK15f4droR9D7QEeoPsljb/LMG9SDW030Lk7aX2tKKGOvNBGH7aa3bEH/WGdmNq6Uwvo1r/JD+seT3yfz1dzLeOjO/bn0IHQ3AhBsQydVDLNwxWE3B58G1akdNba6VZp5w+MY2JBpRpQzIlQ1QOC9wFgImP8yqLUxcweFqEmphuWy0CFYO5enLK2lZtXBLMUZ/99YJCbJsBUjhHs3MxjaGfbCPTzyyB8zo9cdqRbX36/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 16 Aug 2025 10:18:13 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Hi SeongJae
> 
> On Sat, Aug 16, 2025 at 2:25 AM SeongJae Park <sj@kernel.org> wrote:
> >
> > On Fri, 15 Aug 2025 18:40:59 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> >
> > > Current damos_commit_filter() not persist allow value of filter. As a
> > > result, changing allow value of filter and commit doesn't change
> > > allow value.
> > >
> > > Add the missing allow value update, so commit filter now persist changing
> > > allow value well.
> >
> > Thank you for finding and fixing this!
> >
> > >
> > > Fixes: 9cb3d0b9dfce ("mm/damon/core: implement DAMON context commit function")
> >
> > At the time of the commit, damos_filter->allow didn't exist.  I think below is
> > more correct.
> >
> > Fixes: fe6d7fdd6249 ("mm/damon/core: add damos_filter->allow field")
> 
> I found a wrong commit, I'll fix them.
> 
> > Also,
> >
> > Cc: stablee@vger.kernel.org # 6.14.x
> 
> I'll also add them.
> 
> > > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > > ---
> > > While fixing kselftest, I found another bug and succeeded in
> > > reproducing. I think this patch is similar with previeous patch [1].
> > > Also instead of sending patch with test, should we check which is better:
> > > a seperate patch or patchset?
> >
> > Separate patches are better for me.
> >
> > I'm not sure how you will make the test, but I'd usggest making the test as a
> > kunit test.
> > Please refer to mm/damon/tets/core-kunit.h file.
> 
> I made kselftest with drgn, but I think that kunit could be a solution as well.

Thank you :)  I prefer kunit here, since the test should be for the specific
core function that can easily be tested using kunit.  Writing it as a drgn
based selftest seems too much to me.

> Honestly, I haven't used kunit test before, so i need to look into of
> that. Please just wait a little bit.

No worry, take your time and fun :)

FYI, you can run DAMON kunit test as below:

    $ ./tools/testing/kunit/kunit.py run --kunitconfig ./mm/damon/tests

And the document is available at
https://docs.kernel.org/dev-tools/kunit/index.html


Thanks,
SJ

[...]

