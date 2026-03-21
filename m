Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEDF91099B3C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 03:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71DCD6B00AD; Fri, 20 Mar 2026 23:21:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F55C6B00AE; Fri, 20 Mar 2026 23:21:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 632336B00AF; Fri, 20 Mar 2026 23:21:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 54BC56B00AD
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 23:21:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A72FBB91E4
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 03:21:15 +0000 (UTC)
X-FDA: 84568619310.06.38A76D3
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf25.hostedemail.com (Postfix) with ESMTP id D9D08A0002
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 03:21:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wnTSmKSk;
	spf=pass (imf25.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774063274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9GGpzAI+tXredIwGhfLL7ax5e2lwF3lCJ5jRuRq0pjM=;
	b=lWeSEsVRVVtBxZQF0o7rJ+TYHXcTL+bbPmMqW+LyBlWq37ZZcMNC8Bs6fgyeAQKyqVWceg
	I8eKYehAMhi6ro1miv/AZJc8eEDO/pkiEh3WXssq3aiUnzrvOVKhGorTpGkNI/z/EtjBLy
	XzEtjoHaOiAxE2siGrWDuBbQmQHIio4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774063274; a=rsa-sha256;
	cv=none;
	b=nCn7Z8Gz/yQJAUes1lBIh4qNV7mzNl5W4VRaPpTnf/K0wLvrrdGxqEeinTj20FpLj+fi8Q
	UO7ORp3+dPIM6mtctAFr+go2wjejZU37g/Par2D9Dj4ccReKXjPBQgsd1eqlKCrLJnpRjG
	znVCkyMyISP3JD/+J3cK7blzRPmYAqE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wnTSmKSk;
	spf=pass (imf25.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774063271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9GGpzAI+tXredIwGhfLL7ax5e2lwF3lCJ5jRuRq0pjM=;
	b=wnTSmKSk/2HYSuqvl4+ZbksIr7DumBfiHRJswxh0jH8xbzmLHhxUvH7thAFhFmOmfoHkRD
	0u2bgUVws3avdrrJSEaamdhXaPu9AbLfNABUuTOm2E9TrIg335jmvGQBvxfsXN69O0yQqj
	50S2qEtU/45HKCKE+XRBVW0SfvZIFEY=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,  David Hildenbrand
 <david@kernel.org>,  Zi Yan <ziy@nvidia.com>,  Baolin Wang
 <baolin.wang@linux.alibaba.com>,  "Liam R . Howlett"
 <Liam.Howlett@oracle.com>,  Nico Pache <npache@redhat.com>,  Ryan Roberts
 <ryan.roberts@arm.com>,  Dev Jain <dev.jain@arm.com>,  Barry Song
 <baohua@kernel.org>,  Lance Yang <lance.yang@linux.dev>,  Vlastimil Babka
 <vbabka@kernel.org>,  Mike Rapoport <rppt@kernel.org>,  Suren Baghdasaryan
 <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] mm/huge_memory: refactor zap_huge_pmd()
In-Reply-To: <20260319200917.ce345a369d035050b6329ac5@linux-foundation.org>
	(Andrew Morton's message of "Thu, 19 Mar 2026 20:09:17 -0700")
References: <cover.1773924928.git.ljs@kernel.org>
	<20260319200917.ce345a369d035050b6329ac5@linux-foundation.org>
Date: Fri, 20 Mar 2026 20:21:04 -0700
Message-ID: <87tsu9kgv3.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: g4bafswjzapa7mii7rakqntb6fmmbcnq
X-Rspam-User: 
X-Rspamd-Queue-Id: D9D08A0002
X-Rspamd-Server: rspam12
X-HE-Tag: 1774063273-209633
X-HE-Meta: U2FsdGVkX19qkdVNLnkgDEJK7jjtEGKb3oW6afEoB6dn5Ko2geVBbip3tL40eZe6Vsdrn5NXmTiBc7xM7pApS0Weq5+1YnmzymWSvNyDrnBih7N/lOO/Gdzw9vn21npOlabjSDbdmHw5AtUTlrTKOlO2SbN1rp82fOvy6y6YEwmYE+goxDRzpJOSQphp7j2mScNXIq8pI2XylyP0+qggQn/IS0Q9OoJ8sy/FYpZ2zkldN3wGifuOIRcffADEB+820y37/3D9M48FtPYUChm9w/6YLQh4f6DGJV+aLkYo54jpZH/m8FJokPCUxwG4+sCnYQfnPeYFmywlkZVxwCrDb64xL9+B2HNZvKMUXp4FckyQeD+/OrTN88EZx/9nVVItCTaSKB2+S4mMBsf0qFdtSh/blSBMSCgeXloI65GHwIOJ4KHgIwnXZHn3pcRGJh8bE3vsoMUV78qdibo5hD8TK4zu54KAqjsvw7dZ4uYTrxu62eSMUoI1ZxNCEGT54JUVjXmd0714IQ/p0IhsFMm71VaVqMkycPxFQLtDwlF/9FwM0TGkSZJuZ3anzrURFxS6PlyXZZX8TykSMZkiBh0H/XImq8+rb52Pfl6plUXMWnNg1Z9uyE1dzFKA+vM24ooQeV88ow1lcPtaQ2xEbG2VAZhdVF13kkCKSf3aVe0Q6KKv18aoQB3KMlYXG6j7Nnlkt7AT0rXNl97IWEhgA/Izo5+AIkoo/VxNsDJWw0GGPZqpy4Un587QXS+MyRf9FG4KYCMNXMzLsCv6cSLzOUp2uuNMl4DEL9wBA8qd8LXxGMYLQ/9YkuzZTwE59mNufCLN9SFyfvI3We5pmTEN5PDjN3+xky/XlFnLTGBNFnIRlX55U5gpeqkKAYBVRKbvesuG051w/mDmr25fYWS6g0m8hu5OPNB5QWoV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 19 Mar 2026 13:00:06 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
>> The zap_huge_pmd() function is overly complicated, clean it up and also add
>> an assert in the case that we encounter a buggy PMD entry that doesn't
>> match expectations.
>> 
>> This is motivated by a bug discovered [0] where the PMD entry was none of:
>> 
>> * A non-DAX, PFN or mixed map.
>> * The huge zero folio
>> * A present PMD entry
>> * A softleaf entry
>> 
>> In zap_huge_pmd(), but due to the bug we manged to reach this code.
>> 
>> It is useful to explicitly call this out rather than have an arbitrary NULL
>> pointer dereference happen, which also improves understanding of what's
>> going on.
>> 
>> [0]:https://lore.kernel.org/all/6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local/
>
> AI review has questions, which I assume you've seen
> 	https://sashiko.dev/#/patchset/cover.1773924928.git.ljs%40kernel.org
>
>
>
> This isn't going well from a workflow POV.  I merge stuff (this was v2)
> then half a day later a bunch of potential issues are identified.
>
> If these reviews are useful (they seem to be, enough) then I guess I'll
> need to further increase the lag between seeing-it and merging-it.  But
> if there's a 2-day lag before I get onto a series and I'm the first to
> look at Sashiko then that won't help.
>
> So it needs to be something like
>
> 	- series is posted
> 	- 24 hours pass
> 	- submitter takes a look at the AI review, maybe prepares a new
> 	  series.
> 	- 24 hours pass
> 	- rinse, repeat
> 	- it gets merged, hopefully with some Reviewed-by"s.
>
> Not unreasonable, but it requires that submitter be made aware of
> Sashiko's comments.  At present that's via me being tiresome.
>
>
> Anyway, early days.  I'm thinking that an emailed reply-to-all from
> Sashiko will help.  Much hinges on how useful submitters find these
> questions to be - something which I'm paying close attention to...

For bpf Alexei suggested to always send the review to the author and
cc the bpf mailing list, but ignore maintainers and other mailing lists
like lkml to minimize the traffic. It sounds like a good trade off to me.

If there are concerns about polluting the mm mailing list,  maybe
something like a new list like "mm-new" / "mm-early" might work?
Idk what's the best thing here to do, just throwing some ideas.

Likely next week I'll be able to send reviews over the email
and I can send them to whoever we think it's appropriate.

Thanks!

