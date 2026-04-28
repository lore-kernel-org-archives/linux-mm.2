Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBE8EFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 15:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 294936B0088; Tue, 28 Apr 2026 11:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 245686B008A; Tue, 28 Apr 2026 11:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 134206B008C; Tue, 28 Apr 2026 11:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F22726B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:24:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 87D421A038C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:24:38 +0000 (UTC)
X-FDA: 84708336636.29.189316C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id E2E3A160016
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:24:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tSMNQjLt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777389876; a=rsa-sha256;
	cv=none;
	b=3twA4HDO8vmKjK5XQdlmtZKN4THvAQaFeRPh603ZSnaXBCtShVggT57eSSbV+w+HBgrpc3
	pvPAsfOD9mwyCWUelPNqW6NtB2tgcKwPwc/I3Kj+GuqvAcDZTyLnLxir+IhYX5JXPkkFc3
	EzIzKk3IrUh9i6T1MeTBSHs4cmDcIBs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tSMNQjLt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777389876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ur0f6rhQapoDhRFLJDKJGSp9J6jyR7RfEgzkBcGhNog=;
	b=jlpZPZ4oLj1XFZHjCwiYcGKKuoVeT0W7v/jCG9XTSTS3kqp7qEO8ehxdhOBIJSTX3spTFQ
	eSvGc7W1gvwd7My/8pWcA8BlMY74MW3AJY8Np1D7ArxhHsSIJiYtAScC6Sh363x4DESGiK
	ype61iUgggp72EwNlNOeQfpEquMxnlo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ECBD060008;
	Tue, 28 Apr 2026 15:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4ABCC2BCAF;
	Tue, 28 Apr 2026 15:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777389875;
	bh=fr/tHmzNTkk/OXH8pUHVXJSnE5ydLpCRkC0pcGdssWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSMNQjLtSoXFNyCgm2wvc8eGNOP4NeBV9NZcV/XrVIib6Z9f8/tfJffjfvB8sKFYd
	 STyJPHytDTqo1Bt/xjBXWzeAZji45aqvCmQn5M56VtflBesWmRin5y6bnruoqXyoEy
	 JJ1k8sMu0B56WF7UhBV6Z01OcL1blMBFkEskJFuf1d0T4cTRwmbrp9/TPb51BrDLy3
	 tsyH2PsD6PmXnuEGfX5L1Wg08A9dgX55HtjWkyynMyrURPWbUvvLi7/V0MeEdwgL/P
	 TdBR581p0YYiVJFnF7NPa85gd59pXY9iy+HtLNi4WRNn8ZvU57TxmoeDYzVIsXTcgI
	 q5k9YALgCwVWA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 00/11] mm/damon: introduce DAMOS failed region quota charge ratio
Date: Tue, 28 Apr 2026 08:24:24 -0700
Message-ID: <20260428152424.125760-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428074837.5fb02e0210ebabf160506a80@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z4b77uaa5y5s1psonony9rsfaao5euo9
X-Rspam-User: 
X-Rspamd-Queue-Id: E2E3A160016
X-Rspamd-Server: rspam07
X-HE-Tag: 1777389876-316974
X-HE-Meta: U2FsdGVkX1+s99sAXtjJmc/R1MgpAAsR/3ZYsOQr5Hq3Gepg3RSATVxDjfwxDOdhjDHoDmepzF/N6xOFO8Ud7wGFr9MVQuVWIwrCaPgZZ7EM6Yy3cZvmA/qesVZcMjUVLrfjf0QArjol+FkXbZ8Bhn8C58CnsaanR9isDE/Tt6v02jovN9DSCw7W54WPuAfx1Wh1FJdMbyErfOJv00lwtwz+fsVGw9DCmNsj7pxOq5v+y+PEOnL4JHsTOm7UyDbonuD/xnyMjxBXavxf4zBtOBL232EW82XXjxYaGQwyfUF2cv+TZxueM3QFrQMUhfUrcR/WI/YswXTfaQ756QSbVkwXBFLJ73MnHwUL7/XKCcYvNSmuUJYRkVfgfj37VEr9jtxdHJ9TEjS8PTKM+A+5hRP3+Qw5+3tk0RqI/LrD6C7D60hOl/rjwKW4U599lYF5mcABjqDfrLGVheWxP78vCJ+XiSjfP9TPrnUMAUWHFD6PIWqp6uw+XVcjWUxCjchdj3k3uNcodxi49WK1G204u3y09f5caw6qBy2o6iYavYEo6uJOlD4wRHwvkOTckiDSCnVwwXhKoAnDVz/fyhAICCIwnIhPnMEZzfu71L93Llc1V62NSm8UafcZQ2P7ZQlfM4M6S4lKhNJGSjfDzR/rUbfPAl2ZiyYhhErm+WTed+hu5wnSHWhGi3EepI3Yf6Ypek6z0NZY//w2uHdkft6p4cSLwc+e+jIJ/lWTbPEjEVwlsWTP/hp8+s4HC7Dzwu8BdyEwkBSVTyWOppzwzOY9B8wKx3Bc5jxHZwgBnTgc5388WIVV4JYMIQYZVQLn5idtv1ErUJ82Nxc6LLNirHDOA+KsU16vF6lLqPHApwPIp354LU4ygBBUDSHrbyxH7rakx71rNWvo3qWampcXl2OgLB/1pShJYyVUJ1+pl3Bal0VhZ/hsUeYjDmKkP2Bn/R73OEqstpD+hj1ucIY50uZ
 UOMgLSbk
 wHQe8FtzZQUm+5Dm/WmQZ6egBYKGWSvi4z9XjpSCZfb8egRsAMTd1b6D+XG7gUXMl1wljN4butksm0ABtoOnqXObAy77/hkoxevCwj7OoVex8USkBxEGe6YnG4C1ZV8cyjxx3vt7x/NfVGeDkKbX0/Wxv9WIjK/eD1OLzvVOW3Giv2KgLeHknVi3O3kKTz1AuGjjBcC492HHNrGTtPkNYJ/X42u75KfNjoAilgTxqfPiRQuuISlaHx7eS5t3868BkRGoxFodeEIpGHAF6AkHt6qZSZlXhUyIps+D3WR0LnlhceO6KpphLUB79CNivzMPmr/p82WQnlUU/IPbMOe+1AntQZl9kGbblbxtU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Andrew,

On Tue, 28 Apr 2026 07:48:37 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 27 Apr 2026 18:33:49 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > TL; DR: Let users set different DAMOS quota charge ratios for DAMOS
> > action failed regions, for deterministic and consistent DAMOS action
> > progress.
> 
> Add, thanks.
> 
> As mentioned provately, Sashiko claims to have found things which it
> didn't see in the RFC.
> 
> 	https://sashiko.dev/#/patchset/20260428013402.115171-1-sj@kernel.org

TL; DR: I find no blocker for this patch series from the Sashiko reviews.

Now sashiko replies its reviews for DAMON patches to authors and
damon@lists.linux.dev.  So I replied [1,2,3] my review of the reviews to those
on damon@lists.linux.dev mailing list.  As I mentioned on the TL;DR, I find no
blocker for this series.

And I think you didn't see those because those are sent to only authors and
damon@lists.linux.dev.

I nowadays reply-all to original recipients only if Sashiko found a blocker.  I
will also add short notice for non-RFC patches if Sashiko found zero issue.
Let me know if you want a different approach.

If it helps, maybe I can also ask Sashiko to send the DAMON patch review mails
to you together.  Let me know if you want that.

[1] https://lore.kernel.org/20260428032324.115663-1-sj@kernel.org
[2] https://lore.kernel.org/20260428033833.115866-1-sj@kernel.org
[3] https://lore.kernel.org/20260428034139.115984-1-sj@kernel.org


Thanks,
SJ

