Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF6C0EC0465
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 09:01:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B29196B00AA; Tue,  3 Mar 2026 04:01:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEA5B6B00AC; Tue,  3 Mar 2026 04:01:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F9676B00AD; Tue,  3 Mar 2026 04:01:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DD6C6B00AA
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:01:41 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5AEFF1C3EF
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:01:41 +0000 (UTC)
X-FDA: 84504158802.28.3B339F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 79225A0005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:01:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u2PKA6Op;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772528499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dp99y/RowSASEil7hX6aGMwy2AdtEggOJ6ufOdrT85g=;
	b=X8/qqv4m07d7kIEqUXz8ddAH624amvF3fJHlL1pjXkC1zySuut0yatXTwdYIYTBJaYekdy
	0l8H4mqvXI2khL8kWnKNiPdtA9YMLDV0n6ZoyQ+RBpUEk07aisrwErLeymGHvFpjPknJQA
	t68i8EQ0CsbXz1xYGuwpE4IVe27N0PE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772528499; a=rsa-sha256;
	cv=none;
	b=3mzq7CvmxBGaiwPhFAFTK2bN39QrLOseBAoPE+8avzQTH+yG+wJxZU3N7/lG3zNHK2UBXp
	bMAVkYPbyCfRo7APHURQrqbMnbTir7a44srxaDWuh0yM1JbNkKGIZNt2DmyrW6PlrEz2Km
	UYHn7RsJQjCTi/8lrfSO9e5057AnbJI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u2PKA6Op;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B75740549;
	Tue,  3 Mar 2026 09:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D258C2BC87;
	Tue,  3 Mar 2026 09:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772528498;
	bh=xIDhhFKu+QZGhGNatZGNHd+2DpHd3ohKIeS/HtirohI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=u2PKA6OpAxboIzAOfCcmy+G38IYeBYHiSzDBnTwnqDXel41RKhECx7XETmIzP9vt6
	 DZr9207euHyJHUzt5C6WbVacT2DDye1Alml7Gdn8K4KXbH/0IAwGCRYb98PFLCcZ4I
	 zM/iu91PB6qE4p8kj1P1+LuZVa4rHssBAe5a7bX5pL6NWMikW8KB51v4px0krgUmDD
	 ach1EGskWjUlfa/Yc4d2yEbay344J8v3Wmzfbj7VEyQ2Skh7XX3HBrXXZmh21o6JKY
	 +AhVc+0nzM2znyP+1aJeB6aPx6/vGVgoPGmtGUhfahoTlyXI6nbVUBvb+5jZhFDt82
	 jznVIHjdPOIBQ==
Message-ID: <94297332-45d8-4b8a-b368-ad66e128f273@kernel.org>
Date: Tue, 3 Mar 2026 10:01:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/vmscan: fix unintended mtc->nmask mutation in
 alloc_demote_folio()
To: Bing Jiao <bingjiao@google.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, hannes@cmpxchg.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@kernel.org, shakeel.butt@linux.dev,
 weixugc@google.com, yuanchu@google.com, zhengqi.arch@bytedance.com
References: <20260302070351.3465439-1-bingjiao@google.com>
 <20260303052519.109244-1-bingjiao@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260303052519.109244-1-bingjiao@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 79225A0005
X-Stat-Signature: c1d1mrnxoewhc4iigarapg8f5z5m6wt1
X-Rspam-User: 
X-HE-Tag: 1772528499-124651
X-HE-Meta: U2FsdGVkX1/qxml4AFS3RzgI0VVB5PTDAYM5Xk9sx8SBJWIKk8QnOIiHXhTaCXhO641fqFFoCrcS/6hU0bICeFlzvRhsAOCsTlk1tWLWkJBwWSjAvh0mVO1mNHfYkdOGod2wEm/L0UPeGPuZDA2vUZlOHfYkJ2uG3FuagYl9McVmVYIFozQVfzqQEgDiejDFo+XHiS49DknjtNPrxDVJouZA8TMgOKqmuX5ZdehxSf6KePIukayQj47fh2NEO9ROlGh8iPQ5OEX13sBnVXR6klZs5/eHKoCUX9gMeEDrhuKWUKvDn4lkVrgZs3A/oLrto7D3C0olvD8RlpLRjF+N0Nz9ZrwO6D/GN9EDy+3rySBurGz6SygOGHhCd4rdYZvhOa+TrAxbOD5RYTzV+6gjHWJ6AymfMqvJriPp2fDleSfqeY5wTJgmU5hJPrPeAUnNGqV3CJXLZoe1H3NcqR3On+cGs63bcPfm6st2t3ttt6nBWUQ9nzl0KBdb3JDjxVJEHboUTHB8aMGkaWsuVZ2g9ltUTRWDgS93SY7/Yu2S4Xbwg34yNSZhDHzNrBI/8IwdnptfI1eBEZBex4u1p8Zy5CI3Ph8AbGc2N+2QRRLCT3l39U4bzv6v0BJM8MshL4QfzqiK1WPyD38xVUZCl63YYl9rFfdK1Log+vzsdqYDi28UnrX8QA9xObe9Cyeyx64/biwzE5GiVLWUmrkbt3SeOATnI/1WY0NO9cHgGNM8prXPqR+53SEDbX0M1sGxtw9RPL6Xc7s8ADQUqNHCMjIuf6edPXpwle1ZTa2y+lKpmFrrLV53/IAUqCvEy6hqZsmlb8knUqVk4cl86ipcR8mfaCof5WyfreQ0QofhvAcVkSbVxKy+l4q0rWT2f+4r8j/UaNbSV9JUJGWTmtlZjOSu4p+rydg5h+9aT2JmQDo2G7e1mC0cf8YWwxaqO+j+RbkMNq/60fuWBoi/6EbWUjq
 a1/SALrw
 K1Kn8OJo33ffo9xYuDE6rcf4d/sMMEEa22JFTiF3nX4xPwolhR12zxFF1RF1PXI+EVCD8T5pVPEmFzgX5NPFwvn2lSK73IAXvqImWPX58zJkI6UXFic1H0fhGWnOVpwPxOm3YbkQ2douSWXEAQX7MpIOHaAIRdl91cDG6VQiv+lC+Xz0jEalQsitPqwksRjSprDEqqAR5Wff5zDy8c8eGphf2Eh3YISQZbdrlsf3/uqliycJgxQ7yOER164qwPbDj3lRB7uNvMIdJVgOlUC2ldY4bktzOnzrSp3ZjeDTuP0Ag89vpAPv+VNxOPC3Zo4TRVkfpWSJ6STdK8uLZpoW01Pp663LsZ1pq5FGwn4iDClBJGCsAuWRJWFG34GdXzpl+OEENBABMMXsOUy0HFh/VW+6SwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 06:25, Bing Jiao wrote:
> In alloc_demote_folio(), mtc->nmask is set to NULL for the first
> allocation. If that succeeds, it returns without restoring mtc->nmask
> to allowed_mask. For subsequent allocations from the migrate_pages()
> batch, mtc->nmask will be NULL. If the target node then becomes full,
> the fallback allocation will use nmask = NULL, allocating from any
> node allowed by the task cpuset, which for kswapd is all nodes.
> 
> To address this issue, use a local copy of the mtc structure with
> nmask = NULL for the first allocation attempt specifically, ensuring
> the original mtc remains unmodified.
> 
> Fixes: 320080272892 ("mm/demotion: demote pages according to allocation fallback order")
> Signed-off-by: Bing Jiao <bingjiao@google.com>
> ---
>  mm/vmscan.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

