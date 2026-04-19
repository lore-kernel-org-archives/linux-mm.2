Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ED0CEA7188
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 08:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D69D6B02FF; Sun, 19 Apr 2026 04:35:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 987B36B0300; Sun, 19 Apr 2026 04:35:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876316B0301; Sun, 19 Apr 2026 04:35:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 70F3B6B02FF
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 04:35:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13CFD14070E
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 08:35:55 +0000 (UTC)
X-FDA: 84674647470.27.BFC0C9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 52E674000E
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 08:35:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SvlMf0GQ;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776587753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3O7gUZVckbvN66uMqVDa6rqw/MphHBnQEMjgNK/arG4=;
	b=8Yl38NDCAJEDTZaEUmq8WfYaTJ70Sx4IfaY89uThNFHPXdDp6QJ8i7I1kWq5DEQdYOrrsF
	ITur7jfCqvFFpmHoePJEs48RwU3s3fJ3ZcwCIyMnHShzpKUBdYSPrPmuxMwpmqOxIq04gA
	omdaY7VS+RwngkgzcwnKgSLsm8/Vq8E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776587753; a=rsa-sha256;
	cv=none;
	b=bTEL99rTz6IrWTDJYwdzm/1+U5sB2HKKdbRCGsdwDCt7TnN0X7miprJn0D3S/RIxh4LwHA
	bRiQ9Dexf7iY2ls+YyVH2RwNlRST5A4bgUw3p5BL4FSbn42MIzAUHjKH2XalN1p7RP0cIN
	14AeL5AxpC8no7BLSaBktjPNIn0Pcew=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SvlMf0GQ;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DB5960055;
	Sun, 19 Apr 2026 08:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47DCC2BCAF;
	Sun, 19 Apr 2026 08:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776587752;
	bh=y597qofYZdSX714IE89e9Oo2LtyecIQOslkgREpFM+Y=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=SvlMf0GQBMk9U13reL2kVKRkLRuZslq2FUTFwBCyGYz/UlxCOgkz4TT2ymfsht95+
	 hjHLeki7r/Q+wFPRRug3Ij6o44LRnDxF6S2dPK1mB0KVCYzjzUUvt9hhEgMdtBxHte
	 zsyjjmzBFenTqXqXz+XsRlmIBZ1x6jFKf3l6yOiQLIf0JCCj5+yu2U5L7Vwr4C1atz
	 Xo78iefJMxoqvJX/I6OUyqnuLfQWgtSVRM84X9eQQusoFOcRDIqLGvfZh35Yv0yUlD
	 02T6ZkGa9QQUe0hoDaU3hHr0iEP64a3UJUWDUubkNMClAS5Q+zohVgrJB454bhpRFe
	 9Ak2U9ejiOQ6g==
Message-ID: <c113f667-f897-42cc-a0e5-b8a0bbd91be3@kernel.org>
Date: Sun, 19 Apr 2026 10:35:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH] docs: Add overview and SLUB allocator sections to slab
 documentation
To: Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Nick Huang <sef1548@gmail.com>, Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <skhan@linuxfoundation.org>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260418000635.17499-1-sef1548@gmail.com>
 <aeNGbNyPxJssnkbO@lucifer> <aeOuCH8ydw_yzdXZ@casper.infradead.org>
Content-Language: en-US
In-Reply-To: <aeOuCH8ydw_yzdXZ@casper.infradead.org>
Autocrypt: addr=david@kernel.org; keydata=
 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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fbshbyqi6ocyhmbajp3esfdt5bdissy7
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 52E674000E
X-Rspam-User: 
X-HE-Tag: 1776587753-394855
X-HE-Meta: U2FsdGVkX1+7mTXBPzKkFEd73RuIeQjeIskm36hD33/W/5hps/sZXXTfgkx6MzDdY3eqIjEHnGGC29380oHZoVJ0bsXGh1mPNj9gmAgSUJgT+/V9BYPzo754I9atgSZvvOwjXjy5+Av2wsoZa4NiwnU7KTaAY6EG+lmoUsGiSLI7qBBALPjH3WL3GmvIerZvbdFTQJ5RC3j9hzBat5Jh/ZSK8pZtliBesRWeJfSvCRSc8Ksu0k4ORFp1OK107+qEUj90CizyW/TAoJisTI0kmJ/ae0/zZvYweM2YngqdWbAeEK5O4tw6ci6wjlp94k/YQ8UiKbFS9Uw0QpQY2D9GdOSu8zEVRDcyJ0IfGGJEi5tfsiC+806pITag2sxcAuogVIzIAD5ShzLVXMjTu9VYS/VEPfktr2+Qv/FHqmEByCMe2pnaqCTAFNEOA7TVmHfcQ2KN/3jKFFnrfXsL3HODPw2co5mpw6v5A+ZZsu7GalydO+U0TwMJHW8ElqR0htnEij38ZauWofyBpsvjgxnA4i4Z4t7tF2z4ENQMMlidnLqhiaHSUqDCDaKXX8d18bzUCXZdRUugh30fXoKF1V2czvDrR519+QhZxLwvxZ9dHgTwDiM7uR7bOLVfwARWEN0PIhs/EsqJW+LOaD8YuwewshpjZEupOa5HglQtV2QrioL+j0qR9JAoCHEYI5JHvZad1dI0yKOlHpbpcKzSPLhFP4iTxJXdM0GwWIoz3DX3+R/OSHf6sC59uRwlGKIX4qkhtUP3sOeRH5pTyRV+1ZI4orXQu61WwtMcSf+jlQUveDEGOaVWMM0qXQbsCE2zBrroy2roO8Vpk3ENSq+W6J7WRNpNTbNpJ7RattRD47EilZJVhdaCnK8kW0vggUmVPOMzkOpEZcEOGYHBxK6IxzMJPhBwGmouaPOjjIG9GThISLQ9nCLiQMrG2DGwtuX6GhIyp82NN/vUWmhFwS2lwpz
 zH4AHx2r
 bCr0n0/e+/cb3547xrBcBjmHgEv1DE15T9jpBu8f+a0P9Fe/eVPislG39v1k4EMhzKIcGvRiUA3+0eH5MCUiLDseO4LX0IFcF7pHJDHQjn7J0nWaX+P975ZlNVwDVt2V7dRU0glAhXyuNUnTwQXPra1HsBYkBxMMe+1ujArRb7XJsNjG1FsSDwTtbCGnlC30PgPEJBacOVWO/s1SpGXwlqGTUtFnjyvKGa4Y+2FuBAnxE0c23LXipkGnmPkgQP6YuUE4H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/18/26 18:15, Matthew Wilcox wrote:
> On Sat, Apr 18, 2026 at 10:07:22AM +0100, Lorenzo Stoakes wrote:
>> On Sat, Apr 18, 2026 at 12:06:19AM +0000, Nick Huang wrote:
>>> - Add "Overview" section explaining the slab allocator's role and purpose
>>> - Document the three main slab allocator implementations (SLAB, SLUB, SLOB)
>>
>> The fact you're insanely wrong about the current state of slab only makes this
>> worse.
> 
> This is actually a new low.  We've always had to contend with people
> putting up outdated or just wrong information on web pages, and there's
> little we can do about it.  Witness all the outdated information about
> THP that's based on code that's been deleted for over a decade.
> 
> But now we've got AI trained on all this wrong/ out of date information,
> and, er, "enthusiasts" who are trying to change the correct information
> in the kernel to match what the deluded AI "thinks" should be true.
> 
> Let that sink in.
> 

I think we should make it very clear that we don't want doc updates from someone
that is not a renowned expert in that area or wants to become an expert in that
area (and already discussed working on the docs with maintainers/experts).

Otherwise we'll have this same discussion over and over again.

diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
index 7aa2a88869083..8c5721001c8bb 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -7,6 +7,11 @@ of Linux.  If you are looking for advice on simply allocating
memory,
  see the :ref:`memory_allocation`.  For controlling and tuning guides,
  see the :doc:`admin guide <../admin-guide/mm/index>`.

+A lot of documentation in this guide is still incomplete. If you are not
+a renowned expert in the specific area, but you want to contribute bigger
+chunks of documentation, talk to the respective MM experts first. LLM
+generated slop from non-experts will be rejected without further comments.
+
  .. toctree::
     :maxdepth: 1



LLMs are just the tip of the iceberg. It will all be developmend-by review with
inexperienced contributors. And we are only willing to put in the effort to
teach contributors if the contributors are not actually worth our time: i.e.,
LLM kiddies that will actually stick around and help the subsystem in the long run.


The whole doc update stuff is similar to people just grepping for TODOs in the
kernel and then using an LLM to produce code they have no idea about.

It's the evolution of typo fixes: review load without any benefit.

-- 
Cheers,

David


