Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 107DB606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 16:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KnBAu4iR
Received: by kanga.kvack.org (Postfix)
	id 11F846B00EF; Sun, 22 Nov 2026 11:12:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F76B6B05B0; Sun, 22 Nov 2026 11:12:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00CDB6B05B1; Sun, 22 Nov 2026 11:11:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C539A6B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 11:11:59 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D8A61C40F3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:11:59 +0000 (UTC)
X-FDA: 85463246358.08.177B6BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6C138120009
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:11:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KnBAu4iR;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795363917;
	b=j/yHTkxZ8GP2Dthcso1xcEr6+VeZsBzWsD99Pw0Y+fble/QiYULvr6yJ7d75IPDCGkVPc5
	SKSdcDTkPPHr4IKyIVNIeUWUBK3P/ah6bJ38J47PmfsjSEwhLIElTwEZ50ctLzxOr/Tskl
	Xo4Efvi/HnLBRU8waokW4cayNLA/rTk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795363917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AaKLdB8fGd3h34AkJnQe7bE0gQxgGuDWGUSIKJnw9zA=;
	b=ZgBipMxHwurcCFgFN9XR2osaPGJ6AlO6char2FLMDLTlDhN5MGDTLN8lRhg6FimPD/s0yw
	kQToD3xvaaqc3QQt+K0/0gTzRZl0vVtUHCS6XdVX3KAKn1Oss5YpZHZi8R+Rt6x2BqxPJR
	fy+YW7p1oD28EopJC+LlLrPMOoptXzY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KnBAu4iR;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E0C3960D68;
	Sun, 22 Nov 2026 16:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB071F000C4;
	Sun, 22 Nov 2026 16:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795363916;
	bh=AaKLdB8fGd3h34AkJnQe7bE0gQxgGuDWGUSIKJnw9zA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KnBAu4iRe2reIfBsQsi6Ou73YS3Jx5sd2bxybzz4vbV2JPL+sRgC2mlV/ZlEKFiMD
	 OS8cymV3zK6RsjJh9nX78+mPVCNexP7Na9akoElJcbgdjQw+n70MEf/Uj6c8zUcP6F
	 L+j5kchnzCIV3aJZ1/PE4AlFOAT97/qkmmc8cpfwAbL4RXti3DiSqOOI0KxeXtnUlP
	 f6OfGGZLLy2ED4gvSHBYmUDqTbZA//hgTlIKIyyue58zTWmS5PXs0A/lWks5L1BJU6
	 a3PyIjunw6utHqJYSVcT43kxk1a6r1cePEkgwvuSJSb3GcnrfzM0rN1USWKq60+4jj
	 qBDNHNjcQR7BA==
Message-ID: <4a017c79-db13-4fe7-8161-36400596fd6c@kernel.org>
Date: Sun, 22 Nov 2026 17:11:48 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/rmap: fix migration entries being treated as
 partial unmaps
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Kiryl Shutsemau <kas@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Zi Yan <ziy@nvidia.com>,
 SJ Park <sj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, Sashiko <sashiko-bot@kernel.org>, azpijr@gmail.com
References: <20261109220958.2071687-1-joannelkoong@gmail.com>
 <07a8ffc3-1f71-4e41-aa83-424e267ee48f@kernel.org>
 <CAJnrk1aMwrEHdv9v=1cC54QpxzRGpRMbiu07KGfyEhzQNP4XFg@mail.gmail.com>
 <a127857b-d1f6-409d-8c14-3622ea553ae7@kernel.org>
 <CAJnrk1YWf=rJc2uB-sCwxSVFa8KperRn30bJ3m_1Q-026P68BQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJnrk1YWf=rJc2uB-sCwxSVFa8KperRn30bJ3m_1Q-026P68BQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 6C138120009
X-Stat-Signature: 46ho3zbwk1y44j7modpsso4kz1bjcd8q
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795363917-645466
X-HE-Meta: U2FsdGVkX1+pDVNWADYn7oWsQTIFG5ipQF3YYY723JHYnHx53VH6jMUSGOncHluyzTO1YoWy7HBSaS/NOVl7oGseA1GtEu1Y3QZvi0ZjKhimnSZsmk0ScSaE11ts7B1sWT90tOGFVZPia/cqiDbGztr5vP9hzbB/SNMWZXzJ2DFM1ZfruFp7u/ID8rDXjvZxYNZihjjvcZjWK7Qk0X6Yg58OmXjhsWLrwL4b1dggCnL9iUJUAhG87VGHjb4au/VpVklFED3WrjWdsX0no//LEOVkDE9D5NwkOPv+WPIDdKs7KHX/Xb2YnM7zipRkh7FSBZCnEQ/SrUtyUnort96cRrbrgOAX+JLMyQZe1uXY7CUwSGPkqcAbIoSUT87eiUKviX2DDDBNUxhVBZ+eY0O/AV//PUQOUrpwqWEAVSM2fubetzU3fyZ5F6659FRHORR1aQd1jvDizo+dy9PA3bTuan6vpn+vCIzjS+ciIWb6iuaFQbVEmAyeERLekqJwXJ698gkLTbuqCRBFUihFUdAS4JxHTvS24Q2tsnWRDXB6EtswbpLwOuU0VXyS4jGpKo2NgtOdWCDl0bBC2J0NgljYvhGL7iM4UpFHlPOZdlcSzPPVPUU8vm3JJisdXo6qDNg6A5iyDXjpFtcIraM0QEUlr1koijVZM17Qbf2lM8YjZy/mGk1kBcl7xjKJs2ZBrG9l2ELhIm3jpY63Gx5aCSvFZ5W1XJg1zH79tZ07RRUvhpr8i5e/UhkJYU2ksPx+rKRpdJwRk5vCqgXuZ0nqejRPyajmSbQrzqJ4qrXm7l3+HTda7cg6u+9pQKHk8dHmVpAxkwsarCJE9T7peYmeE/6DQiqWuPOfbKIB6rx2RxN1LG17KpNAW+yAX8axNiPl8SdpGt1HU2HpZ4zu8/yCJpsXXdAhQ8osizQVPoBNxsKyMK7WLhRlwLawzzN16jZCOLs3zGdJBpyPN/vNtbXgUay
 vhxrlXLO
 zNSG43k8rbMxL01HqHF16lr/HuAQOrsUC/cGJskPaawkUgdJeDQ4CSxqVKeFgcjm3jpQYszoxyXMuvQwGclej4X09fawgVkrdJ6/sb5XeTCJt9ArK1Al+FR4WYJ0uze2Z0TlZvEvkHDQFwYSVMoXdQxVrKePj5TW74SMZzbRPlEcdtVHigw8NoiLwsPhtqOj07vaRB7ZlAvYb3tgfL2i0QelTiUrOMjj9l1dhsg4p/FNr0ZYh2fdndzIflxKhCWE4Vh0hJGDJLcszsef3Wfegt7/7cY1FtnJVNiMvNnzRsD4eWl5Vnjx5qlrOo3l10q1wwI9syrcxrd/IA+8aVqoiKTb+1ph68ijZJmCxzFFtJowNlvjIdULPymcN3SxyUovUJVDTBmwxuQ58sQA7UzkMwVQSdiEEkr1mAMsQdtV86xzG7puMMWOVzruBIR8FpHKzMMV96dJkbxjPhyCK2ArxeTVJIUQ1vgEhsEJH9q+uqAjwb1dSkq9vYwFrEMGOE5My9Sy2M0IrCli00LCYZ3VGF+qmAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/14/26 00:51, Joanne Koong wrote:
> On Fri, Nov 13, 2026 at 11:23 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 11/13/26 00:28, Joanne Koong wrote:
>>> On Tue, Nov 10, 2026 at 3:49 AM David Hildenbrand (Arm)
>>> <david@kernel.org> wrote:
>>>
>>> As I understand it, there's no simple way to check if a folio is
>>> partially mapped or not under CONFIG_NO_PAGE_MAPCOUNT without doing a
>>> rmap walk.
>>
>> Yes. With CONFIG_PAGE_MAPCOUNT you can (still) read the information from the
>> folio, but the grand plan is to phase that out and remove it.
>>
>> I just keep getting distracted :)
>>
>>> Would it make sense to do something simpler here instead
>>> where we just check the folio's partially mapped flag and cache that
>>> before we replace the PTEs with migration entries, and then for those
>>> edge cases that the batching solution doesn't cover, just restore that
>>> flag back to its original state?
>>
>> As a last resort if we cannot get something else working (and we really care).
>> It is rather hacky.
>>
>>>
>>> I think this would add coverage for the migration and reclaim paths,
>>> instead of just the deferred split shrinker, but would miss the race
>>> where someone tries to do a partial unmap while the folio has the
>>> migration PTEs, but I think this is already a race that exists in the
>>> batching case. imo it seems acceptable though given that the race is
>>> pretty rare and doesn't have any adverse effects except delaying
>>> freeing the unmapped pages until the whole folio gets unmapped.
>>>
>>> Do you think something like this makes sense, or would you prefer
>>> having the check in the deferred split handler?
>>
>> The question is, do we really care once we have the PTE batching in place?
>>
>> We would still split for if we cannot batch (multiple VMAs, PTE differences that
>> we have to respect). Do we have any idea how much that matters in practice?
>>
>> (I raised once that, just because a folio is fully mapped doesn't really telly
>> you anything. It could be mapped into various processes partially, or scattered
>> in a single process.)
>>
> 
> Sounds good! I'll put this on hold until it's proven to actually be
> needed after Shivank's series.

Thinking again, just saying "we're unmapping for migration, so just don't mess
with partial mapped state" through a new rmap flag that we pass does sound
reasonable.

But ideally this flag would have an abstracted meaning (e.g., this is temporary
system-triggered unmap due to migration/split/swapout/whatever) and not some
thing concrete like "defer split".

Yes, we'll not handle when someone actually triggers partial unmapping at the
same time by doing MADV_DONTNEED etc. But I guess we shouldn't worry about that
for now.

Doing the folio PTE batching still makes sense.

-- 
Cheers,

David

