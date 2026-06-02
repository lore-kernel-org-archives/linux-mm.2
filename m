Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88681CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 12:50:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFF256B00AC; Tue,  2 Jun 2026 08:50:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E882B6B03B0; Tue,  2 Jun 2026 08:50:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D29216B03B3; Tue,  2 Jun 2026 08:50:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD8E96B00AC
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:50:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 887111A0899
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:50:22 +0000 (UTC)
X-FDA: 84834955884.29.5F9C7DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9EF25A0006
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:50:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MvTyKwVT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780404620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZnN2cB0eHRn81UTnQ4Np+H7blIwIT0kEeAcnod2F1qg=;
	b=ZdtJVNrwJxkxji+9+Nxj4Ndus7ttLViSMSewUFi0bs459daf0g/bMLfW/PXcKJOooXBdc/
	O8f8yJBxSAvzquTN8p/wesacjt6U5qC2b3/Ofbo31aaksVILULuKiGsbPmXHftFur3xlFj
	7sPsSSW0YwWU7LYnAfcz7/2en9FysA8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MvTyKwVT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780404620;
	b=AJU8FfGT/wk3qHSGoWTd2NJI9xY8QdeWuhX9kVEpMl2RVxoAZQ9IXWe8WwldRfcVt2YkeO
	HmdxJKvoNDorRoAeCBnrVXnN1YeQ+RLeHdUXc/Kw4NHNTK0fJlkH8nahqvqQS/O0zZicrZ
	67kh0ZXi9lPn5sUA66tATqUe2l6Nxc8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9274E41731;
	Tue,  2 Jun 2026 12:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C701F00893;
	Tue,  2 Jun 2026 12:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780404619;
	bh=ZnN2cB0eHRn81UTnQ4Np+H7blIwIT0kEeAcnod2F1qg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MvTyKwVTzmqplXWDe/K0s7Vq5jYIxP4nqvUrRwm5er2dCYM8ZOu/yPvOpBJq07o1P
	 M7Rh8MRFnfByBNTihb6pz/nvkZNn4sCx1u1K2h9UzonoM/hD5QBkFxBo0fqkz/7iWp
	 0iwGP8+aIot1KLk90d2xJLq4GXo7aDjVKjFSS4zpDpT5rMgTmoPROZP/TAh8uDXw3m
	 rXMGy0hGpePkHzcqpCOHVAKvKx3S37oIW3YRJR+yLpDenWTONmK8eLjmBjfEBnTOs2
	 dOTq9DdioBXuxGcCHuielsLKEHqSvjJsQS07QhbaQeZba0KI4gCZnVE3N9r0h6aOpy
	 9POkdHcV/6rgQ==
Message-ID: <47fd307f-267d-49b1-9b62-24a577e48143@kernel.org>
Date: Tue, 2 Jun 2026 14:49:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Nico Pache <npache@redhat.com>, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, liam@infradead.org,
 mhocko@suse.com, rppt@kernel.org, vbabka@suse.cz, willy@infradead.org
References: <bd622950-62cf-4b57-b3ac-89635f28fa4f@kernel.org>
 <CAA1CXcD373fFfo9YPWRj8mJ_rsnzyCrpn1uk3=k7kU=QuaLOgg@mail.gmail.com>
 <a9f43ab4-e47d-4907-9620-32287e3e9b84@kernel.org> <ahVX1iq_-95vd0PN@lucifer>
 <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org>
 <b45f9b55-5143-4387-aa98-e077390d542a@kernel.org> <ah2ndruO3RQGtePP@lucifer>
 <506fed6b-8954-40fa-8b5e-c8bd8c0d004b@kernel.org> <ah2uDhs3a0bFcRNG@lucifer>
 <ca37b7ce-76b0-4825-b238-b504dd499d3d@kernel.org> <ah7GctQYf8EqZjIa@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ah7GctQYf8EqZjIa@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9EF25A0006
X-Stat-Signature: ficb5zqezr95z11ab5h1mkfp4apmy1ec
X-Rspam-User: 
X-HE-Tag: 1780404620-531963
X-HE-Meta: U2FsdGVkX18edOI9xGKOTScZwoywd98I+lr1qq/tXsEHIREXHBWFpYg5dxj6EgIjIQHRedOQuWyVIBHCLG6PDcur1Z2Wz6SUKrJ/w470MKGiDB87n2MAHn7x/B7h6GxdFxC7fz9xswsDIcUEZ+Pj9/30/YIQ7eTSnnHMgX8dIvI11MEdUhbDx/NSkesx3GWS7+1ml18gYBxB+upgTAa2ZP5fPkO6VQjbN34zl+ILfhvnByD5sjErOaNWjyorcJfZOax3yOiv/6tTZxlqwuCPnkkypi2qd9tH3fw3qnrtDZ6/Uby4wO+QGzd0jD4JIr7XoQTsVbcBDXFR3j2hjtRdpUlLZIK/YrHBFXMQrLIGVsBqDh5bkKzQvawFi0QrAuwD3/bQUo5vz1JScqX+5VEg4g9Tv9WQrdhbiG/PmU+y2Q9rlgnV/lUhhwVz42kUcQILduYoKOIn3Rkt43UF8ar5+6ScL0qKcAXDlHxNuqvrQb35Jmkimf8F1H0WPY7QqvX+fmS1meYqJIOSi99s/yTRW6TrqnpX92MAeEyq49tYCD0Fu5eUy57J5TRql4ovdLu7BehUVG4fOPFVQN0R9md2/JPsyXVnNnvexZAh9mSxbTuqbzaLf3xA4TIn7GH1v3j45Rjs16EVIeeG24UOo9fwBCrcUNAqbWL1I/+0c6hEVXB0sX22wOdV9BRVRpxmLM2k/a6iAtERTxkqCcfjSFIhwudTd2X3rMAXPgH7sNfg++uej9SWe/CvrsoVn+pvRAwRZb8ypiGbPq4Nx7mGS5oIObeDxJ9YTSLkUwaIK1Mx9ubKaQdt0ChdrnOBE6yE1dvIvnb9QMdjVO0WWP84AIKvbHtSvTajc0iwVwECEuSUsNsZ4WTmMCcmyxJrRGSFIWzgwjGSCvVlbqdcoTbMul+dkQGSHRgPyNouzXZ2zaLXnlqHjpkVBv1qBfyAyBojp7iAJzvQKE22ruQJZOBTI+J
 HD1FAg9L
 VeJAV5LnGV+QdJCEc54U2JCwnUS8YZnVrXJE8rNer7xkugvXxw/xi2kO+txxxHFEK1LzT2JZrVjTpuk1BZRXXSEjnPJcWK+JOqRrRzPX2BvzakHC4lKt05H2tvckbb/g/VngSGjDtp/uTKVAPHQGglbryvqVRxXBeEJBUP693T131MddC0KQhpbZPb21l63f66PLICRvRMcvzwsVuRlMxjjcICjN15h7iAJnD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 14:40, Lorenzo Stoakes wrote:
> On Tue, Jun 02, 2026 at 01:20:07PM +0200, David Hildenbrand (Arm) wrote:
>> On 6/1/26 18:16, Lorenzo Stoakes wrote:
>>>
>>> Err what? The 'random' tree is the MAINTAINERS entry you are targeting, it's
>>> based on the mm-next stable branch and only diverges in the work that's been
>>> done specific to the subtree, what's crazy exactly?
>>
>> We'll still have plenty of patch sets that touch files cross trees.
> 
> I'm not sure how keeping things in the same tree fixes anything though?

I think there is a misunderstanding. I am more thinking in terms of what the TIP
tree does, where you can send patches against the integration branch, or against
sub-branches that are maintained by sub-maintainers.

Terminology starts getting tricky.

> 
> You are just changing the _timing_ of when the conflicts happen at the cost
> of making things way more difficult to manage IMO.
> 
> I mean the reductio ad absurdum argument is why isn't all of linux in a
> single git tree? :)
> 
> If what you're saying is true it should be without issue? But I think there
> would be pretty huge issues...
> 
> And the disadvantage is now we have a bunch of sub-maintainers with write
> access to the key mm tree who could make mistakes and break things,
> hundreds of topic branches all bundled together, no separation between
> anything, and no sense of where anything's at.
> 
> If you're saying submaintainers manage topic branches (this cycle the ONE
> tree would have ~400 topic branches right? More if we included versions?)
> and then independently merge those into the mm-stable tree I think that's
> going to be a disaster in terms of timing/conflicts/etc.
> 
> And you're asking for conflict between submaintainers I think - what if one
> person merges his thing that then causes conflict for another etc. etc.
> 
> With separate trees then decisions can be made by the mm core people as to
> how to integrate, rather than people unilaterally doing whatever.
> 
> And if you're saying submaintainers won't do that, then essentially you're
> saying no submaintainer tree management at all :) which I think is a a bad
> idea for a subsystem as busy as mm.
> 
> I think mm is too large now to have everything under one person or a few
> people.
> 
> Separate trees implies division of labour, and then the integration tree
> can be more of a pure integration tree.

Just to clarify: I don't think everybody should have access to everything. I'm
currently trying to figure out which options we have.

TIP has everything in one tree (with sched/ x86/ ... name space sub-branches).

> 
>>
>> I don't see the problem of sending stuff against the integration tree from where
>> it can just be cleanly picked up by sub-maintainers (after all, that's where all
>> the subtrees were integrated against)? Or what exactly is the problem with that?
> 
> But what does 'picked up' mean? See above re: concerns.
> 
>>
>> This is likely something we'll have to play with to understand what is workable
>> and what not.
> 
> Actually, I think we have to decide early - because if you want
> submaintainers to test out this sub-tree or sub-branch? Or whatever thing
> it's very different asking them to:
> 
> - Create a new tree and do X, Y and Z to sync up with mm-next
> 
> Vs.:
> 
> - Have full write access to mm-next and create branches X, Y and Z and
>   merge things
> 

Right, let me figure what's actually possible so we can discuss if the
sub-branch model even makes sense.

>>
>>>
>>> I mean, is there any meaning to separate 'trees' at all if we just have one tree
>>> with topic branches in?
>>>
>>> Or are we going to have several parallel stable branches in one tree, and a
>>> bunch of maintainers with write access stepping on each other's toes?
>>
>> All valid question to which we don't have an answer yet. :)
> 
> :) I mean learning from how others do it is definitely key here.
> 
> Maybe we need to grill Brauner?

Yes, already reached out :)


-- 
Cheers,

David

