Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A26C108B8F3
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 11:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D291B6B0005; Fri, 20 Mar 2026 07:01:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD94C6B0088; Fri, 20 Mar 2026 07:01:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA0E86B0089; Fri, 20 Mar 2026 07:01:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A3B0A6B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:01:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 55C5FC0616
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:01:17 +0000 (UTC)
X-FDA: 84566149794.07.E0EB9D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6F4D414000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:01:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lE/mSVNK";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774004475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0x1tyFF5Az6qN3wlb31sWwK80vemEWqq0rzmSR7aglM=;
	b=YeT7jsEX2kg1Qx8RiueQTDbJVcVHUvUfyAOJoLvqackhGsHbLP15KCcKVvVm1YUJMs4X+K
	kEoc7C0yftizls5Twe3c0Urjr6HcD/cEJTNPv83KGiE9SleIkle1m6x01xl2URkyjQHx7N
	EVMnfv9dKyYzTW7AtbcvEomH0eoqYVY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774004475; a=rsa-sha256;
	cv=none;
	b=W63+jzWvvoXFCBJmJp9/DsV+CsyvG79otuoMu9v2y8exl1OYxQo+dTLj7f4wLHHpogYs5u
	t4bTRUb/U75CpZeQNhTpiwO+nmYeZd0RRKdLF07ZAB+14ZO09A2WDr1yRceAsH7nqEJei+
	UdnzDsi/r+JJwK1k8qLHQLUAjPt9rCw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lE/mSVNK";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 56A52439C9;
	Fri, 20 Mar 2026 11:01:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819B2C4CEF7;
	Fri, 20 Mar 2026 11:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774004474;
	bh=6JmOhT233vIGaIeHS7G5lAbsyL7NY57J6nlVsUY0YVw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lE/mSVNKJmdm5EIlAcV/Sn1c6/zMyvcDENutoj84MaBiVoD8eRAUH8CktP3qWLS+0
	 dXpRz41fo4ckWptlnP7AwQvP9dlO7PrNnujQENs/uniZU3gvE5fRhiOnsL7915O+7D
	 8nMkxoXRChVA6un9C5L//g/rAzKvr+LCG7xzEZW5bGho1slNd1X2GxAC4dIrxasBhL
	 VSpRCL/aXDmjE2T383zgn52bRVaD1Z4YIjQxpdPfW0mFPAxNjr+jjJ1ZrCnCmG5nEi
	 9PBjXPgJxiPR9OH9cxAhyK7LTQS5qi55JSb/OmSAR/vGL++JMEDOI0zDXFK95ekzwU
	 33F1rM/YSz2mQ==
Message-ID: <9b0aaa19-b839-4ebb-a312-097b869154c1@kernel.org>
Date: Fri, 20 Mar 2026 12:01:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm/mprotect: un-inline folio_pte_batch_flags()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>,
 jhladky@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-4-pfalcato@suse.de>
 <2da1181c-165d-49cd-94cb-5ccbd3bb93b3@lucifer.local>
 <69382383-5f08-408f-8c13-d674e82c4dfd@kernel.org>
 <fcc2665f-014b-490f-8451-ca907730e60c@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <fcc2665f-014b-490f-8451-ca907730e60c@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6F4D414000E
X-Stat-Signature: c81q9grzahx6rz1zbwzxq54zh9z3q4eg
X-HE-Tag: 1774004475-234717
X-HE-Meta: U2FsdGVkX18akJOHpsDMAFwhAip2RiS5hx+xz60y4uGhB/GjpCj1Q4Gq2sM3MTK2qVO8PSFAHVktZH9NcYJxfHyMEUVbDjkQjmJFd1b8aWQSMjmd+sWNdXoggRrbERHiVXtYT9h1qVcHvhIj0yl6sFVKmWfKgk/0hsRYUyXAxM906wCm5v8MPn0EpyYFnBxoF6AJdLtvpLgkt8RC7Wc7LbWr6qBSjXkwkyclx1xaDyy8onwMv4EEmnsbPQMoI9Q1Fv6XsnZdxbquNVZaheBAaQYjlm4lwVQZ/+c4urnjg2VgZN5tqvYUtoiAPkaqBXp68Whcbge0UIC+Ng78obEKZexND8Werun8dsGx/vFVpZj68K766dTvegWscDKe/f46mduJIkanQHlbRi3pbvg+mrXO9bwn5uSx0IwUAZ53ps0UrESqJLO+D1Yi1InBHmYItKT/xeynAxNiHzz4H6uK1plZjGE4hY+uoE84u4LNytdU8z1sBN56VRbv2MdOe426TjwXexeigHBK+H0fr8acj+wdxYUVTevlpsYI6tUpoC0ICMeABny7ftZZqSjmJEnQaubhhvUCWsFNAbtGGWtn80A9izw+O7BL7MjyDNrr/45j6Td7bhnZlPocQEynwsC6J4tKHTKOo7XULbTtIxJyrQwCt6T4lfm6TMjc30rOUxkL6SomFEus7/CZ2IT90rtzfIIO8HA1hVAJbkx8ORrTROANf5PbQaAKOaL9HYxhvEF7GffZjqP3VcMRVrL0Sz6VaB7HnOmHW2TUBPkja8W87N1Msxcs732+Wb2bvzhBYdU+x9LTGPA+HT1vBab4i/YYTbZuZJ75qzs5556j+j3WKLONzA9nvevjWp4LvlswTKjvgvV/FfKi6h1klrmLXsH97gGVmMuW+4zZHk7W84cfLl4SJZueDCuL20ROyri9gRNHC12JvX4qk/gmbtlOwbUI/hGM33MG1uUCAck+FjQ
 +ddj3iGi
 0aIt1vdqFpTg2+M5Qh0sLRETgnupoWYdk3wCAIGbulLw//W3HQZc2/VqIFGef3QbeFI0Oj1/0CDtrO8nhRWr78Flucryi/V8DMJ1GxzJMCNOYf6fPy0IDQ+vVo6KJKJEjHurh1OABsjv8UFdiwuGlWBzifX9Pep5Inw+7W3nuFfoM9dFRM7NZ5AlrGsDmiiwa54+dR2YWqpMKx5QiMwb9WxKCjRcNbBcctjFIPnoom2yqbcP7T7kziqDl7uL7/gepIhRr0QhJ+5pRB9QFz/JFVMsOqLmCshUpt37d2NCYUDNj2cjy2/2DwR9Qww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 11:36, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 19, 2026 at 10:41:54PM +0100, David Hildenbrand (Arm) wrote:
>>
>>>
>>> This is all seems VERY delicate, and subject to somebody else coming along and
>>> breaking it/causing some of these noinline/__always_inline invocations to make
>>> things far worse.
>>>
>>> I also reserve the right to seriously rework this pile of crap software.
>>>
>>> I'd rather we try to find less fragile ways to optimise!
>>>
>>> Maybe there's some steps that are bigger wins than others?
>>
>> What we can do is, collect similar folio_pte_batch_*() variants and
>> centralize them in mm/utils.c.
> 
> I'm not sure that addresses any of the comments above?

Well, the point is that you still end up with an optimized variant
regarding flags, and you don't have to play games in this file with
"inline".

> 
> Putting logic specific to components of mm away from where those components
> are and into mm/util.c seems like a complete regression in terms of
> fragility and code separation.

My point is that in mm/rmap.c we have another caller that passes
FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY, that could use the same
optimized function.

For folio_pte_batch_flags() we primarily care about propagating the
flags such that __pte_batch_clear_ignored() will become as short and
small as possible.

How much that matters in practice? For fork() and unmap() it was
measurable. So I'd assume for mprotect() it would matter as well.

> 
> And for what reason would you want to do that? To force a noinline of an
> inline and people 'just have to know' that's why you randomly separated the
> two?

Again, I don't want the noinline. But providing a single optimized
instance for two users that care about the same flags makes perfect
sense to me.

> 
> Doesn't sound appealing overall.
> 
> I'd rather we find a way to implement the batching such that it doesn't
> exhibit bad inlining decisions in the first place.
> 
> I mean mprotect_folio_batch() having !folio, !folio_test_large() checks
> only there is already silly, we should have a _general_ function that does
> optimisations like that.
> 
> Isn't the issue rather than folio_pte_batch_flags() shouldn't be an inline
> function in internal.h but rather a function in mm/util.c?

No, we want specialized code for fork and zapping. That's the whole
purpose: optimize out the flag checks in the loop.

> 
>>
>> For
>>
>> 	nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte,
>> 					   max_nr_ptes, /* flags = */ 0)
>>
>> We might just be able to use folio_pte_batch()?
> 
> Yup.
> 
>>
>> For the other variant (soft-dirt+write) we'd have to create a helper like
>>
>> 	folio_pte_batch_sd_w() [better name suggestion welcome]
>>
>> That will reduce the code footprint overall I guess.
> 
> I mean yeah that's a terrible name so obviously it'd have to be something
> better.
> 
> But again, this seems pretty stupid, now we're writing a bunch of duplicate
> per-case code to force noinline because we made the central function inline
> no?
> 
> That's also super fragile, because an engineer might later decide that
> pattern is horrible and fix it, and we regress this.
> 
> But I mean overall, is the perf here really all that important? Are people
> really that dependent on mprotect() et al. performing brilliantly fast?

For basic primitives like mprotect/zap/fork I think yes. For other stuff
like rmap.c, maybe not.

> 
> Couldn't we do this with any mm interface and end up making efforts that
> degrade code quality, increase fragility for dubious benefit?

I don't see a big issue here like you do.

-- 
Cheers,

David

