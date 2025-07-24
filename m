Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED8EC87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 21:15:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003186B032F; Thu, 24 Jul 2025 17:15:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1D056B0330; Thu, 24 Jul 2025 17:15:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5AEE6B0331; Thu, 24 Jul 2025 17:15:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D63016B032F
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 17:15:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 86B2E16053C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:15:29 +0000 (UTC)
X-FDA: 83700414378.15.4E8B22D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id EEB7E180002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:15:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YOlNhqH/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753391727; a=rsa-sha256;
	cv=none;
	b=tu/7rawNvMxJBFqa8YbydtulzOQ1lw0begs8Mfa4Tk580yuPMkJW8rwSBgWt6j8IsOQ8pu
	4gPCP+dFUkSurwBCF9iwK99iGN4EBrBd8bK9Tl7cVugPuvunL3yV3VxMrNe5hqpzuX/ghy
	UwwJc5G+nFbCQZd8Qm4GljCv1Y3nWfU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YOlNhqH/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753391727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQPjyuKut5PwcDa5ZFaaJZlkKgbUcQ9aCHpKSh4s3Z8=;
	b=kXAzaZyh7z1dIUPjXuTYsWs7ZVNXDq/0s+v15KBsydS8/2nM48yTOsG6clIVRO5hzojuOZ
	Cn8gc/aWXjQ7wMnRvo2Ng9KrNPOpYVcb6QDZPMGrhEsGQlPg9gLmdlB49AM/EN+ARQWhpH
	CKzEGEbpz1/r3jTV9N3PTGmet2s+31g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1AA9860008;
	Thu, 24 Jul 2025 21:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5204C4CEED;
	Thu, 24 Jul 2025 21:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753391726;
	bh=S+iAs0K4q++C82w4BZwJHhfcP6bn1PDc/SNomW8AIYc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YOlNhqH/A4HTEzvFS6+BFtKkC0c+zXQ9Hrkfp3nUoNRrwmWVUgBL08T/AOZFsZMz0
	 oxm4vhRqbg+yxGaEu/4Dtl4ZqJJdyTLrv1TKDEboxTTsItx7l9QyhjchBLoF84knG3
	 +KrMBEU2zr/gB0v50gsy1vm+3KufIWqLgXYp5VeFwe2W6R5OV2HPBEflJ7JIDMUAOT
	 LzBTYT7beJC3i094SQi9TEHTtRtgOhT7EHjCtSrvkQISJxNNUTf9KMU77b7kuRLi86
	 0hyYK9kb/qinzcPEIr7y4MSCdvOLWNMNuBmKn4OARL5RrKFHfdM17857FR76Cipo55
	 3u4KJ/Lk9ZxFg==
Date: Thu, 24 Jul 2025 14:15:26 -0700
From: Kees Cook <kees@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jeff Xu <jeffxu@chromium.org>
Subject: Re: [PATCH v3 2/5] mm/mseal: update madvise() logic
Message-ID: <202507241352.22634450C9@keescook>
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com>
 <ec480dc1fd4ce04bb11c0acac6c6da78dc6f4156.1752687069.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec480dc1fd4ce04bb11c0acac6c6da78dc6f4156.1752687069.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EEB7E180002
X-Stat-Signature: 39zd6qypnkysfcg7rifqyhgxuz44fyex
X-Rspam-User: 
X-HE-Tag: 1753391727-963675
X-HE-Meta: U2FsdGVkX1/1H9HhkXGGVelAXSUhJDn/qXVEhDDQqqILdrQHiX6wYtiamQpbxCdiTuqXTGd/SuZ0CxajdOAEDhOYdwykSnl5cUenoXxwcXMtFiKSDrdD80Gh+Kvk3cB26aCxYINJqERW3pBfQBlhOeiE6UI5I7sY4iNf3RqvLF/WCJ01Q78jiDNq55Nejo3ItWKHx9NmcWovwsSJsEj8rAxj/7kvDTq/EvhPBNEN5kcOuzqbBnrTq1T31bQaEYMyB6O4XDpjU5zpiy67W0Jxa0xo/+Lf6M8gE8+Xh6/Dki//8aMyF0h9XzCsLSQtQzUaQdJHb9Fwp0zQYodEEUlwW9OD/I8seqaeTagdVBn0S2qdSeR/F1bjKW+9u1Dip29/LPsNyYdlnAwGRljsFHsL4u7XJrOtj33yTtHl1jVAu+jPCHIMZmTTSQvjKTRPueOw93KFUzIIJoypLTGXi22S6l/yA0qSkp7HS2dMv8G4bATACpv86rf4+jJijkpbl0Re78l+p1bkTlRBTiIg16wMmiQL3prqMktjgX/dOmdhyBXviozsvHI3jfLhMFbAPlaE0ND5XNZB/wmOWlASSA4q4kO+QVs93YGre0WNqHftUlfUmVZ8T2aIlqC0K7zEpxpjDqyRZX24MjTZCnkpBf/4zuWiG6FKXSb7mXzZFwFF1uZqYxd3wCgR4fNp2l1iA04mYy4tv2Fx44JhNz4Vsig6C/weFmBgsYw9ZHbOLXV8UgI8y0tIYfVTUIC+mJojsWUuWjZrGFBY8NN/YvyxH46ie6E6naI7seByAYTpyzVdmZCqjJotPogT4FUQLADERb0jp4M9dowH9Z+d0EPumOqVecMycsEFBsFrVNeHpkBtwzTk55PbYiiriUs9nJPwGJ6A2ZMb+BnJN4hsC2tTQDRPyAndj11KahQcQMAjzednlaFZ18ywJ33Lz1df1Bn36Kt9/7LuTh/EBWhBkNQlXhh
 0ENgEsgm
 yzgNF0Bt6luAzCDqoO8Zm4Gn6m4fqmBapJShFCdtqtmFcgNNCimJaJU+3hXHb6fKTLCX5C+Kr5H3vtZC4VLfF9+JKDR7UJNhKfpXlzq7iYwIbuuYkXz2oMSVWh2rsYt0+gEN3n3cegNuKm0muXcSi4e7c0+RHhg5D3/X2nSHCC8RaGDmiJoBAWI5XtfR8ZsRcxFFF4rbKeE/bfbOUl94IPNlJLEajpWo69D9pg2DcztalczCzbtNxi7Yi69K92HRQWTc9yR0CrSGOQUkRvOLH0MSN/654mqqMHba7BiemH+XYgVI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 16, 2025 at 06:38:03PM +0100, Lorenzo Stoakes wrote:
> We make a change to the logic here to correct a mistake - we must disallow
> discard of read-only MAP_PRIVATE file-backed mappings, which previously we
> were not.
> The justification for this change is to account for the case where:
> 
> 1. A MAP_PRIVATE R/W file-backed mapping is established.
> 2. The mapping is written to, which backs it with anonymous memory.
> 3. The mapping is mprotect()'d read-only.
> 4. The mapping is mseal()'d.
> 
> If we were to now allow discard of this data, it would mean mseal() would
> not prevent the unrecoverable discarding of data and it was thus violate
> the semantics of sealed VMAs.

I want to make sure I'm understanding this right:

Was the old behavior to allow discard? (If so, that seems like it wasn't
doing what Linus asked for[1], but it's not clear to me if that was
the behavior Chrome wanted.) The test doesn't appear to validate which
contents end up being visible after the discard, only whether or not
madvise() succeeds.

As an aside, why should discard work in this case even without step 4?
Wouldn't setting "read-only" imply you don't want the memory to change
out from under you? I guess I'm not clear on the semantics: how do memory
protection bits map to madvise actions like this?

-Kees

[1] https://lore.kernel.org/lkml/CAHk-=wiVhHmnXviy1xqStLRozC4ziSugTk=1JOc8ORWd2_0h7g@mail.gmail.com/

-- 
Kees Cook

