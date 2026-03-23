Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA100EC01CB
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 11:24:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 184EF6B0088; Mon, 23 Mar 2026 07:24:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15BC56B0089; Mon, 23 Mar 2026 07:24:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 072056B008A; Mon, 23 Mar 2026 07:24:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ECBF36B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:24:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF1CC1E6DC
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:24:19 +0000 (UTC)
X-FDA: 84577094238.24.9EE1F7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id E01F9140005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:24:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T+aPkEBj;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774265058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NECZ2P7SdKPszkEek1PE0am6Z3TP5lApfOM7SE/W6qw=;
	b=b1a49fuctGK8nHt+ePiWy4thWqk4EE9rUSoBFZWNd9NCLPfBS0LZkPX8UcCN/FueWRG7sY
	DMhaAe3IoXZWOzx5NPZKWUeBOo+WSN5rr11wrLWqMms8Qj2ClJUCYJsEp7um8y30aD66SM
	smbWmGPJpoCyeNWK8tS2r3ujWb5SkP8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T+aPkEBj;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774265058; a=rsa-sha256;
	cv=none;
	b=WNsRpzitKssPC918sdwaOQlG5qlbIt5y0MJZSD2RgWxkkhjPEQK30XJVLIsPIYcGW9FT/H
	Dg2+ASThoNMXI/Ud15avbSb/zAXQ5Wqrg/L8ri+xcLgpPuQb0zlsJ5G62EME1gAczv9ZMl
	sFdtHfmpPthmFkPy20FMliI2XZP4qzs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A31944152;
	Mon, 23 Mar 2026 11:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB24EC4CEF7;
	Mon, 23 Mar 2026 11:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774265056;
	bh=oFBHXXWVzv17Tgccp/4YieceNQhMVYka1/CfYvjL7yU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=T+aPkEBjxIZThinxLrL/aWs62Wa+YtLWJ2mh8MDv3WuAHLYsdgLgy3x9hQHx5ZulW
	 zItOkn1pBA4856jhC7XQhvxePauJ6PPAWrf/NmfgvBGVuSlChABsQwcUz0OxCdTep9
	 Ho1yn8vMW/ZSBoKM5lb72zGf8BxPvveCJZ9OoRdsUYxdNyjPSxCsuX/Snm9sm3NflY
	 Iof3AVSbqK6B7WuVqercbQbFT0cAgotArdkxMnybhPWAKd5hBkZZ/Z4W4fmRl+n3YS
	 hMUFNfLlhZgXudXnwtXY8GBiFxuJUYW1AfQejKlyoBql8Omq8nCilO85PRwesbjHB4
	 YlvsPbC/hei0w==
Message-ID: <548f7e8c-6b06-40e9-82e5-e3718d19431f@kernel.org>
Date: Mon, 23 Mar 2026 12:24:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/9] mm/huge_memory: refactor zap_huge_pmd()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1773924928.git.ljs@kernel.org>
 <20260319200917.ce345a369d035050b6329ac5@linux-foundation.org>
 <87tsu9kgv3.fsf@linux.dev>
 <20260320203311.715ed75bcd84c18d24894324@linux-foundation.org>
 <20260321171530.8b3e8207f89d5a7384b9f01f@linux-foundation.org>
 <877br4k3ya.fsf@linux.dev>
 <3d6cca25-75ff-434a-b210-114451f8dbaf@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3d6cca25-75ff-434a-b210-114451f8dbaf@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z3phs73jwsb7ke864kggh76krg8t74me
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: E01F9140005
X-HE-Tag: 1774265057-761235
X-HE-Meta: U2FsdGVkX18RMExDeWlQ+JXeFOB+SvUCVN5t6LoAr8WzKDk6oowgjMUN05PtXMvq2jLUmMoDh3GRCsNjd5PH3rxb5PcIwP6uckuTkhVUG/zXB4F6Qe8BBID0/Gwa6vwKDt4udhb49Sg4DdP60yPyjJ0ntcMScl2ObnRDS8652XLx9ZIXXPdode9RGV86+rUOL6riKEZzNa5ns0TPkVMoyr4q2iBrs+iEaAOhlLTkEpC1jFvY1x6XGwl3hxKVr0Ab2LfKSn4koXd26feVcuNopUDMl5oj/CRgASf3N8QlIRGrookUtl/FS9LzEKyOrjc4mx+01dqJ6YKvtXNTQVIy/ytIgGlmx/F2y5AuDivinzi71XDX8BK429Sn+T7kPO7GKFZbwGd9+C0Em0Rs9dd1YU6YJGZpAh6d2B8Drp81RZdFrKD7wL7IzVyEK6HvbOAH8vLyiqrg0TTp62uSTa+lGFP5Vjc1bPNyPQHApxC5R4GYtocY1cTtRvdA8LZjNmfllDui77eBOaWexVgDZqJiRiIRusBl9O2ltokYBd2T6xNb5gwanXDCrLtNPR/GU5Xkjdt6U4Clt9XxKv8wyDbxi7653+cgDIvud3M6hpr7dKiBisCbWFFDtRMIiYwpuwu/P4uh5pqHjHGEv+A8ThDhfkqVJEQkpJB6AhJQNov+YbBbTX9cLQxlPaLVSypKnhS+jmXllF/bAKVxxEIXETRnr6q1OYegdsMptrpoJc8BLKaTx4fiWihn8O+HtJom8Yn8PsBUWNjIf8NulgK+mhzDvL+Ot/rwTp//MPGawb0c78cYZnO/3fprCxSb56UD1CJMrcI1sBNKL4jQci2g6jLW0/FQNGwErJ/Y6BPUmIsNnvTRLDgoBve2wXBSj4ANCPdOdTlkCzKxItnAxykYreE6BLUdJ4p2DfjW208/DGfNo2YT+PcJ2kHL6pom7PLcxDnMVvn+Or4bcSSfzeESy2S
 YNHCNqia
 5ypOE/C7cifKW2ypTQyajsuunNLLfw4F8URBWNR9yeTdRO3fUdLNJL0yAxtLXrwNyE2oyGwFxkEns2ua5T933va9bQmmQ/R0W5MnMoSZb2sjQQZ/p3S25AM8qMy5gkSTm3KpcprS2rinYIAKcE48Bn3PDfwcDBqTRp4tDKWsbx+7DwLiYzgNd3uZ6uCZ+U0u7kHKxK2aXkJXF7qzdJGtyUPkfTEM+OVqw+JCrzgYPJI8IBrFuRENu/RZ49kHUHy1oFnZ5sQGQ0b2e86bEX8Jlcji+V6yaF2WxUYvJP7hOWQFV1EuShKntpxlbZt6O6NNBdnfClIkreklSkHRTjeUWyROxqieeBMHTKvGZpfgIil3H0z+UMOqUFKTrMC2hd9gpp25aE3Mo1jrh8hIdB2rbEQJTeV+bTtsGlUX++jYAtNEhxAGG2tNFmzCDX372m2zNCAy9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/23/26 12:19, Lorenzo Stoakes (Oracle) wrote:
> On Sat, Mar 21, 2026 at 07:12:13PM -0700, Roman Gushchin wrote:
>> Andrew Morton <akpm@linux-foundation.org> writes:
>>
>>>
>>>
>>> ?
>>
>> It's displayed in the Baseline section for every patchset.
>>
>> For mm patchsets if the base commit is not specified it's mm-new then
>> mm-unstable then mm-stable then linux-next/HEAD and then linus/HEAD
>> (and now I think that it should not only show HEAD, but the actual sha).
>>
>> I don't have yet support for "previous version is applied, let's revert
>> it and try the new one" case. Something to add later.
>>
>>> The way things are going at present, I'm just not going to apply a
>>> series which Sashiko "failed to apply".  And that's cool, I'll just
>>> wait for a version which Sashiko was able to apply.  And then not
>>> apply unless all Sashiko questions are resolved or convincingly refuted.
>>>
>>> Question please: if Sashiko finds an "issue" in v3 and then v4 comes
>>> out with changelog words which justifies the questionable alteration, can
>>> Sashiko parse that changelog justification and think "OK, never mind"?
>>
>> Yes, I'm planning to add it. Sashiko will have an access to previous
>> versions of the patchset and the whole discussion thread and take it
>> into the account.
> 
> Hmm this question presupposes that we should have to respond somehow to
> Sashiko feedback, but with ~50% signal vs. noise (my experience so far)
> that's just not sensible, and a painful addition to already overstrained
> workload.
> 
> For instance
> https://sashiko.dev/#/patchset/cover.1774029655.git.ljs%40kernel.org is
> full of pretty useless stuff, including a silly hallucination
> (VM_WARN_ON_ONCE() cannot be used as a conditional, it's defined as
> (void)WARN_ON_ONCE() when CONFIG_DEBUG_VM is enabled).
> 
> I don't want to have to explain why exactly I'm ignoring certain things
> each time.
> 
> Until the noise vs. signal is better, I really don't want Sashiko to block
> anything or necessitate responses, which is why I'm very reticent to see it
> send emails other than privately directly to the author perhaps.

100% agreed. It's a pain to dig through the AI output to find something
useful. Fortunately there is some useful stuff in there every now and then.

I've seen the AI either raises wrong stuff or just brings up stuff that
is completely unrelated to the actual code changes, which is quite the
time sink and TBH annoying.

Particularly annoying if review on a new revision suddenly includes new
slop.

I wish we could tune Sashiko to focus on serious regressions, and only
report them if it is extremely sure that there is something real in there.

-- 
Cheers,

David

