Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F24A1C44520
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 00:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3CBD6B010C; Fri, 17 Jul 2026 20:36:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEBFD6B010D; Fri, 17 Jul 2026 20:36:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A28EE6B010E; Fri, 17 Jul 2026 20:36:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DB5C6B010C
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 20:36:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D1EE11401D9
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:36:42 +0000 (UTC)
X-FDA: 85000031844.03.F341F5D
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id F1187C0003
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:36:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ptxfGYhu;
	spf=pass (imf28.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784335001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Op9mpgY0d1zSc0ldTUhNOXDVKeO17oxSB/UFy9SPinU=;
	b=1k/3egPXG+NT+h5wJAVNoV6M0NqnF6DYznBLSbWk+gN5V4+8wwW95rIQHINFSmlvyXGmRq
	fNBKCn6NEXqKox1vcxJ5fUvOKhhllgIXGl9Ki0iwPs0xelKaDgbwGlvkfpUj7ORogJwMvY
	yWXicAoTAjSIAdB6wB1z3rDiTiw4h4k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ptxfGYhu;
	spf=pass (imf28.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784335001;
	b=kqZ38/fjuAU/6gvXIYCRXvrqycDiTHZzBJ6acTVVP9E7UIM6AX405Zex2zyddI4SWHtoZF
	NMvO0liRJnB+JXO3Rn9+m5L6Py2S9t5Lh3vmlL7wEv0usYwSA1zeSLbUFNrF0w0lI5XmwB
	Pb+RrS4F77WmCwK62fORrocWYh4hc2c=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ccdf36f63dso234715ad.0
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784335000; x=1784939800; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Op9mpgY0d1zSc0ldTUhNOXDVKeO17oxSB/UFy9SPinU=;
        b=ptxfGYhuCx7j7Ap+292mfdg6qar5YAQPj0tQSTpXgL0B0+tfIzI0+vM09eorT+NwYr
         CTJrFV1JZSbbiVdLcK0zX6xFDe6Cpu1HlVN8EKvY3JI//c7O6ucS4wKkUx8Mw05xQXAO
         CyvLsOm9iY+MewAKnQ3cBmVkJ4fV9ZvrPPyar5NBHh8f3AI1YLsAT50prVcGYmSn3yPm
         NdhNeB9Gm2lRPm9L8f3A+3yHQHPsxhxWp2S2UlAeh9rPvLsmr9qy59sfoKMmS/S2A8Kt
         A+YQGyR0f9Gs3KYvHXaoYDAzXv+hdOTUrVTwjc2b7Xc/H4eqkjFs+GRybtEK6SO+ty1A
         aZkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784335000; x=1784939800;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Op9mpgY0d1zSc0ldTUhNOXDVKeO17oxSB/UFy9SPinU=;
        b=jJA9JzXq6NkDsa5Kbx1RAaC0o7NhWHrqQkR2eFmtfEmxKRJIeysEGlyKZ5CGq+AKV5
         FUKqbaG++MBn7zbnLOzTeCpqHlYrB0eLpx55OyAZqjBtJnpvk8aw3VhS855vYg1EU9h7
         5CsREMh/SzVycxBUwKP2uV3OKN9CRn4SCuEI+DwGI7uxsZXmasStJakoRCTxj3eJCOTU
         3R7ITMXKZH2eV3kEQHLpogg9S3lkhBeIDEE9Q/wtVO9/3uf13T2vbjE952x/xZSf6Ze4
         C//c+3EYaB1wzq1nJWo84su0LFQYASDQtJ1ZW/1JrZ7NOj/FZkdj5G5hWODuljYBudKs
         KaBw==
X-Forwarded-Encrypted: i=1; AHgh+Rop7SPGGvg8uRby36bzJJUv0yHpl294ZuVIgtxUH/wL1R0LpSl9xFwdt5F+fcowulsJzA0CORqNiw==@kvack.org
X-Gm-Message-State: AOJu0YyW/CZksIBiBqwojGGOyg8IZcDQ/XdfJGVLk3vtVA/VOLEFExoa
	M29nfqzDjxiD+eEMaHuCUqNFpOCJxg1WFl6LSAAtUh1zx4Wizj/xi/lJmbV+I0IKPQ==
X-Gm-Gg: AfdE7cnVkuXj1kjf7g5NehphrJgupwJwOjwsTzLENM+v7emP/qeoN2czSnS8pheO4iW
	i26Fs9eqYKMNYwYnCFaPahVb8i6JKJ4RPN10RsGC0EZZk0Cm0uuHVtG6p3hRaIaAh58wPEH/OMd
	+SBAx8cGyr2NRiHriAI4o5Shy/90QORER08BXQQiDI7IAUH7XsatjNnMLL7aqYSfEPB5s1fXVXX
	eDL7jNWu2TWQxlHW+mjXgOdONfZuHXC1sK0HUyU3JNV/l0KJPKyWwc+Kqd9RnO9Ho5kkKxunYZP
	SS0+CnxqQEJHDfUXHyDSht9a1orVV6/+H5I/mjZgUwR9B2PujZvjvDnZXpaOmiLouBAS7TY6faU
	ozsRJLYLYocs+IKhe5bpWW2Iir07iXQ0v6G4fBHnLyoxZcNrLOUbxBq2njl8Mg0hD/zpMwyayKQ
	GL9sTc/9XRplZquNgZlm1RJATf+EKhtCJVP1Kqh1atfOMkPvbEmxywRj/jl+qnBev9mi4In6cg
X-Received: by 2002:a17:902:f295:b0:2c9:d89f:fd98 with SMTP id d9443c01a7336-2cf4a34a2f6mr629975ad.1.1784334999258;
        Fri, 17 Jul 2026 17:36:39 -0700 (PDT)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf344f61ffsm19120875ad.33.2026.07.17.17.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 17:36:38 -0700 (PDT)
Date: Sat, 18 Jul 2026 00:36:34 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	David Matlack <dmatlack@google.com>, tarunsahu@google.com, open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, "open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/1] liveupdate: luo_file: Add internal APIs for file
 preservation
Message-ID: <alrDpAMknlYN9jL9@google.com>
References: <20260613012521.835490-1-skhawaja@google.com>
 <20260613012521.835490-2-skhawaja@google.com>
 <2vxzwlvljyzs.fsf@kernel.org>
 <akIask9nPTEAhd76@plex>
 <2vxzse65k938.fsf@kernel.org>
 <2vxz7bnhjnpa.fsf@kernel.org>
 <akvT1yBvIbvft1H_@google.com>
 <2vxz4ihxil6m.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2vxz4ihxil6m.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F1187C0003
X-Stat-Signature: ru9d4ascyomk57kopauziakqsq3pt1d7
X-HE-Tag: 1784335000-435198
X-HE-Meta: U2FsdGVkX1+yPsabtMpsicrOFcFbfwiixWWvqyGqDG7j7AHFQRd1s5REjQY9nF27twiN2mUsQPxnaPhDW6lokVC8B0ZigvQm6LTccFVLR00XLfhU/p5iJ6Q/4N9lrNuDxaZSOCQ/O2h2oWeqSY+EqlRbc7JCkey+zkq5udQb4E+MLvpsuHxW0bWX+H3vqEhOdjXDlCoGa3jQF0cgXeoJJZtOmxArDjZl/Az1C9NIPQFcSy9qaCZsFPomGAIaXcWm8HmKZ7R5XbVKV2tKnXG+fKjJ58p1GQA+iX05BumkFOAKk4Fn2U5RDjdpxzxgbw4u6+gZNlNn2BpN6jAD6L/+uZjp6gGpN61k3Gr6+JR0Of49CDU2mnzSdCzGHMtqoRIrJd+XWNli+V9+Uhb7DWJi8m4qJDeYKW/n7WoGwLD12WZihdHhG7z5iX9HiLgABLhAir7m8CcWccjEEX58k3MJd8vwaNPznyTIvVUd21M/fJmf7ri1MhJVILDc0IadY/gTIumOirY8rAxzAWHRnA7Ro8b6rjhhwyCdbP8KVqpds+CqLg8WeJa8dRGyxPzG0UghwvWcbOjYTWmMA3RGrcWmg2XWD/4CS0oaJNUxBsQ7E+llrC2dHv/vFWgnG+xuUu/p6mmLQ6Lf27glrYnO6VQPgBzIXURBL6iDoTua38/7rOlhYmHlXKHZEEGkEFbFaK7GrCvFAaVe5WS4idqRC7qYgFL53Dih5pQ+S3jcRXv2iAeR/IRxa4W6q7TgQNi9dvma1H4wxrEhWGyEnxP9aLd2Q6wS/D0SZcsK9ASeOsOGCTdXWkmNbgY6m0oydBAZqLGtedHvXFeHWWD4Idvgp4bdbhyexKjhM/l0NqW4NZ04lteAZ/dfv/WheatQrkT6NJj4UC6cuNzHapMjPyXuiIdLx8hkuFeQ8T425B4Gy9XwUFJPl+32EzlbWhZ8HIWihr6F2juRvQdY4VF9mwfGMpS
 Q/sPbOSy
 Sex+rVC3oIMsBOhSBi7dAzh3jGRtzGT+/xxzZZV5ojzzMLM8js2tDwIGAPqqV2fTAy5xHygxLvEdgdZM6SMC8FdHky5L6zQmWyKxOSmpfd+apzhwPjdQ0/zSWtDYKcLt9oIXh1K391rBEdWFUmtQU2cG9CgUffqKry1g123BHfj21b+tA56Um68EVqnH1Bm/mPjOuc9yvfgV/R4wh/g/Fo23pSzq7woEeACg0ZRAZjNKonXQhsqx3hm/4Tiygt7VYba9dTv1YPEUhut8/INPX+EzivsuVEWQF9YWWBppP/Bs76h/W71YvSGhn5rz4nJezLTfdWB2oHlHjF0iASX81ouA8b3cPsg+wbWp+JkZJhkK8LafGuzJYpMzqga8r+nsnE162zVY8k+NOxgPv3kBYIN6wnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 07:24:17PM +0200, Pratyush Yadav wrote:
>On Mon, Jul 06 2026, Samiullah Khawaja wrote:
>
>> Hi,
>>
>> Sorry I was out of office, so couldn't contribute to this discussion
>> early.
>>
>> On Mon, Jun 29, 2026 at 06:50:09PM +0200, Pratyush Yadav wrote:
>>>On Mon, Jun 29 2026, Pratyush Yadav wrote:
>>>
>>>> On Mon, Jun 29 2026, Pasha Tatashin wrote:
>>>>
>>>>> On 06-26 13:57, Pratyush Yadav wrote:
>>>>>> Hi Sami,
>>>>>>
>>>>>

[snip]

>>>>> Actually, preservation can also be performed in an order-independent manner.
>>>>> While a handler can call liveupdate_get_token_outgoing() during .preserve(),
>>>>> it can also defer this query until the .freeze() callback. Because .freeze()
>>>>> is invoked after all files in the session have completed their .preserve() phase,
>>>>> all dependency tokens are guaranteed to be available, completely eliminating any
>>>>> topological ordering requirements during the initial preservation calls. It is
>>>>> up to individual file handler implementations to decide whether they wish to
>>>>> enforce ordering at .preserve() time or defer it to .freeze().

Quoting this text from pasha below.
>>>>
>>>> That is the worst of both worlds. I get your point that LUO doesn't want
>>>> to enforce dependency ordering. My arguments against that are somewhat
>>>> subjective so I can live with this.
>>
>> Pasha replied with some interesting points already, but I want to add
>> some clarification here.
>>
>> During preservation, enforcing order gives the following functionality:
>>
>> - The token of the dependency (can be retrieved during freeze as you
>>   suggested).
>> - The dependency is preserved and that means it has bound with the LUO
>>   session lifecycle. This guarantees that it is not going to go away
>>   until the session is closed.
>> - Once preserved, the dependency is in some kind of "immutable" state.
>>   This might not be required by all dependent FDs, but it is critical
>>   for some.
>>
>> These ordering requirements should be clearly documented by the
>> associated filehandler so the VMM knows how to do the preservation of a
>> specific FD properly. This is actually similar to the memfd seal rule
>> that iommufd preservation will enforce.
>>>>
>>>> But then you can't let file handlers enforce it as they wish. The
>>>> dependency ordering is uAPI because it directly affects how VMMs
>>>> preserve files. If the VMM has to keep track of dependencies for some
>>>> file types and doesn't have to do so for others, that is a terrible and
>>>> inconsistent API.
>>
>> But as you have already pointed out that the VFIO/IOMMUFD circular
>> dependency is resolved, I am okay with enforcing dependency ordering
>> during restore as well. However, establishing an ordered
>> preserve/restore mandate in LUO at this point will force all future file
>> handlers into complicated and buggy design choices if they have circular
>> dependency or different lifecycle requirements.
>
>Not really. You can always _relax_ the ordering requirements if a need
>does come up. Because all the programs following the ordering will still
>continue to work. The other way round won't work though.

Yes, this is a fair point.
>
>>>>
>>>> Ideally, LUO should handle the dependencies on its own. preserve() can
>>>> give LUO a list of files the preserved file depends on, and LUO makes
>>>> sure all the dependencies are present in the session at freeze. We would
>>
>> This again assumes the lifecycle of various FDs and that dependencies
>> can be resolved during freeze(). Some file handlers do want order of
>> preservation, and this scheme only guarantees preservation dependency
>> without order, introducing hacky dependency state management until
>> freeze().
>>>> also need a way of getting the dependent files back from LUO on
>>>> retrieve(). That would make sure the dependencies are properly enforced
>>>> both on freeze and finish, and the enforcement isn't left up to the file
>>>> handlers.
>>>>
>>>> Unfortunately all that sounds fairly complicated so I am not sure if we
>>>> want to do that just yet, although I would like to hear your thoughts on
>>>> this.
>>>
>>>We had discussion about this in the live update bi-weekly today. The
>>>conclusion we arrived at is to keep the current functionality. That is,
>>>we don't enforce preservation dependency.
>>>
>>>But that also means file handlers can't try to get their dependent file
>>>in their preserve() callback, since that would implicitly enforce
>>>ordering. They always _have_ to do it from their freeze() callback.
>>
>> This has problems at multiple levels:
>>
>> - This indirectly sets up a precedent in uAPI that the VMM is allowed to
>>   preserve the FDs in any order and the file handler will be able to
>>   handle this.
>> - This will be very tricky and will force filehandler to have
>>   complicated/hacky state management to handle dependency. Specifically
>>   I do need iommufd to be preserved before preserving the VFIO cdev that
>>   has an iommufd dependency. Not sure, but I think this will also be
>>   tricky when we start preservation of VFs and SRIOV PFs.
>>
>> I don't think LUO should enforce an arbitrary rule like this unless we
>> have a strong reasoning behind it.
>
>It looks like you, me, and Pasha are saying slightly different things.
>We all first need to take a step back and lay out our proposals clearly.
>I'll write my points down, and I'll try to reproduce what I understood
>from discussions with you and Pasha.

Thanks for laying down your points clearly. I'll reply to point 1 and 3
together as those are entangled I think.

>
>I think we should focus discussions around the below 3 high level topics,
>and we can figure out the implementation details later.
>
>1. Do dependent files need to be preserved before their main files?
>2. Do we apply the same rules to preserve() and retrieve()?
>3. Do the rules apply to all file handler or can file handlers choose
>   their rules?
>
>Here's my take for 1: Say A depends on B. I think it would be a good
>idea for LUO to enforce that B gets preserved before A. You already
>mentioned a few reasons for why. Similarly, LUO should also enforce that
>B gets restored before A. We can figure out where the actual enforcement
>happens, but that would be the principle of the LUO API.
>
>Pasha suggests the opposite. In my discussions, and this email thread,
>he doesn't want to enforce _any_ ordering. So you can preserve A and B
>at any time and you check at freeze() that everything is present. Now I

Just to correct/clarify, quoting Pasha from his earlier email in this
thread:

"It is up to individual file handler implementations to decide whether
they wish to enforce ordering at .preserve() time or defer it to
.freeze()."

Basically, a FH can choose to enforce ordering during preservation or
not enforce any ordering and check it during freeze(). I agree with
Pasha on this point, as it gives FHs the flexibility they need.

However, I see the value in maintaining consistency and simplicity for
the VMMs, we can enforce that dependencies are preserved in order as a
principle of the LUO API. I am ok with this. It might become tricky for
any future circular dependencies down the road, but we can relax this if
they come up, as you suggested above.

>see the value in this idea. It removes the need of tracking ordering
>from VMMs. But I think it is also somewhat dangerous, because what
>happens when freeze() fails? VMMs need to recover and restart the VMs or
>retry live update. I don't know if they would be able to do so. This
>path will likely be less tested.
>
>But still, I can live with that. At least for memfd, guest_memfd, etc.
>this shouldn't be very problematic. I am not sure about iommufd.
>
>So in conclusion, I would prefer to have ordering, but I can live with
>no ordering as well.

As elaborated in my previous email, I disagree with enforcing a
no-ordering policy.

>
>For 2, I think we should apply the same rules on both sides. Mainly for
>consistency. The VMMs should follow the right order for preservation and
>restoration. Now again, I am fine with both enforcing the ordering or
>not enforcing it, but I really think the rules should be consistent
>across both sides.
>
>From my reading, I think Pasha does as well, but from talking with you,
>IIUC you think retrieve is a fundamentally different operation and it
>should not enforce any ordering.
>
>I do see your point but I still think there is value in keeping things
>symmetric. Unfortunately this is fairly subjective, so I don't have much
>better arguments.

I agree with you on this. For consistency and simplicity, we can apply
the same rules on preserve/retrieve both.

>
>For 3, I _strongly_ think it should be a LUO wide policy. Leaving this
>up to file handlers will become messy over time because each would come
>up with its own rules and for VMMs there would be no consistency in how
>they should use LUO.
>
>I hope this helps focus our discussion to the major points. And again,
>we can figure out the implementation details as we go along, so I didn't
>reply to some of the points you raised in this email, to not distract
>too much.
>
>[...]
>
>-- 
>Regards,
>Pratyush Yadav

Also I think with the next revision of this series, if Pasha also agrees
with this, I will add documentation about FD dependency in general.

Thanks,
Sami

