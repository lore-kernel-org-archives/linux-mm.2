Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93941CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 21:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94C808E007F; Mon,  3 Nov 2025 16:27:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FDAA8E0058; Mon,  3 Nov 2025 16:27:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EC878E007F; Mon,  3 Nov 2025 16:27:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 67A968E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:27:17 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19F08B8525
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 21:27:17 +0000 (UTC)
X-FDA: 84070581714.22.D694FAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2DAC5C0003
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 21:27:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n4mAHwXy;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762205235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sDecfeSPnqm3Gf8WfGmuwGEEYgyH3cdww1wIlvdstfs=;
	b=nlbCHXXZGmpAp/NuX/InK7pe1Z6zZI2hN1AM3tSGYSwQwqLjgYYUtjwiyHHY4Zjm6Y14P/
	3HBttUY35xCxSFp6kR/BBi38Gt2RZBOEOpdkEZo30DlBNcyj8wEfuf/gNeR/Ldp6N8kpVn
	1IvOjTxc452VzApBgWwusVqyWz78bW0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n4mAHwXy;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762205235; a=rsa-sha256;
	cv=none;
	b=W4zR1K/H2k8zcPvI0OObNeRVoJAUFn7GYnhsBiCOaPHpwLFopYmpZxw5gd/fnzY1DGZWf5
	cElh7kPZ7VP+xwE9ShQdQRVnGsSP9dachxM0Cs5ApzGpm9HUTh9UMdBCX9R40R2b0foAY8
	Ez1lxTCFMXGN0A0GkXonOcIfZWZU4Po=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 204D2441D8;
	Mon,  3 Nov 2025 21:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3F6C4CEE7;
	Mon,  3 Nov 2025 21:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762205232;
	bh=S7Z8WJ5WTkSvBw81ctnlvtqz7tyAEpm983KK1QEg2MQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=n4mAHwXyBjCgWr25/B/eWd+gHhGg2+tHEEsUgZzb7y0uw+YR9MTeo+ZiQAnWAtV+9
	 R09FgYoxdweGF7GCS4r+D/wO5QV+VNv7GuQnPeXOiVo+AvRURFu8C+QyuDr8OFxLcH
	 Togwg+t7g0M97Kn8EdAHjgCpCJBuY/JZIsOw7yHk+r0QvTdTTmaspjT065ET4qbhsK
	 ASuoYWoxMfuq450K9h+256k0DO/XiGFdrOoY1zpwGYw6zCNkmItVM5UNJyyS3njypB
	 2k8o3NOTMZlrcVG9xRLWcRNrhgwaXHNKEJlFrfvpPHQRzurP6aVzRf8RGqiOtAzWHw
	 5k45S5DJ1J19A==
Message-ID: <5f128cbf-7210-42d9-aca1-0a5ed20928c2@kernel.org>
Date: Mon, 3 Nov 2025 22:27:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
To: Peter Xu <peterx@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin <kalyazin@amazon.com>,
 Vlastimil Babka <vbabka@suse.cz>, Axel Rasmussen <axelrasmussen@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 James Houghton <jthoughton@google.com>, Hugh Dickins <hughd@google.com>,
 Michal Hocko <mhocko@suse.com>, Ujwal Kundur <ujwal.kundur@gmail.com>,
 Oscar Salvador <osalvador@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Andrea Arcangeli <aarcange@redhat.com>, conduct@kernel.org
References: <78424672-065c-47fc-ba76-c5a866dcdc98@redhat.com>
 <aPZDVuscFsYSlQjI@x1.local>
 <dtepn7obw5syd47uhyxavytodp7ws2pzr2yuchda32wcwn4bj4@wazn24gijumu>
 <aPe0oWR9-Oj58Asz@x1.local>
 <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
 <aQO3Zko6Qrk7O96u@x1.local> <aQPCwFZqNd_ZlZ0S@x1.local>
 <d0b037a6-11b9-483b-aa67-b2a8984e56e0@lucifer.local>
 <aQPU-tyo_w68cnKK@x1.local> <7768bbb5-f060-45f7-b584-95bd73c47146@kernel.org>
 <aQkUwbx7Z4q1qcSB@x1.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aQkUwbx7Z4q1qcSB@x1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2DAC5C0003
X-Stat-Signature: 6hb743nmz1uj5k7hzue7arnj6e4w3fif
X-Rspam-User: 
X-HE-Tag: 1762205234-935168
X-HE-Meta: U2FsdGVkX18fQ30aKzrs1s1GIzLm666eoT5knXA1sOxUuG9q0z3ckP4NzqZaKdFGo/6UzWPxRr/BhAE7JeQ4mBLX7p3giTVw6/WMaRQE911xQaERAzKY0m2hc8xjsl2A0duqYmdTf+CcuYz6OFwawJ6VOYgL/3StgjBnbev3FuFuE+HVvLLrZ3aGGYa1AWHAZsDv8iIFAERLzQsOV6HjSVHcbpx3nkkvvikLXqcpw5fKp/5qPup45r1fUDqXDlr4Z9I6z5J+wOUA5JlgvW4XVlUOiATtb9N0eQ7wY4CU2jIreekfF5Ja7OK7FWyjPahwuxQo7AbSqmfcRPmMBfmJrJKuD9dVaepXxg2lmTOxgvCjCYDjtn7uwoEpr+E0zskvS0t4CHIcTA7UfuLdrbK1VHhOpNo7BZ07S17V75PlOVwiMfMNoytgGSGNzrXmeC5TjL+vDYeYZTplRC0K4pUYYLtNrz6TxCOb5hxcawH2FGE3V8sHQ5aoKInMkWzilunvCxlPCQHEBlBSVWAt5cbh7cwg2J2EKTKugahnJltiGhBlfHbqVtC4GD9Cp4Gh3/5cxn/UAUGuallCfixUw11m9xLZ4TMB3lKUNPO/wWqHJrS8CqhczxlZGN2CVFVdlTXa1WIjIcsSWgs+n7NXcZMTbjvMiHaDPEGXkufWepvtqun3jQx3S6rgktgkzZyFif5rEiDITaxq85r4DJ/7/u1Cban8FRPlJA5uf2STaSRkYoz1W3JJsMdDVczXFmAsKPHwmI+H1i+OmU77yONqf8LjeQongTAQ/H5RPsx+tc2aoOu6NfQqfhSQ0RX2C6XAzgczIV+N37+RcuWoRWfAlQF6BKxQ9Ed5o3+/i1kqhdMYU7ZhwnkC9MYcTyhdDNmXYqcoxKt6+3qEkU+iS4vhhzVhu+3cIybOdcfCARcHOtKdrAV7o6Ig7MZrfnkGtPGbwuYdIFw+UOtj2onvoJlNDhX
 LDpwU1GL
 t08yR3fNr7EqvcxmHtH/yD9H84ESusA2Ke4fv7EBxeab2wZgWsmA1iET/YiY97uuyo25V0mQHKXSFQK5XyWgQc+J2XhN6zLA6LyxhLTq7a94CvHfWQ/FybSXYPHsrzSjjnrIVJDG/ZAU4ucgHhgw5awYADyQb7T9ELoEvY40AkVou3NAT2tJjCJQT6N6zhoPT3RXao6A7eEHPSuXsHp3WOncVcVcMoYO120yRGLbjIdKPS1oHxmNDJ9OC9aYOw0AxB8yBC1nGYhaPYwP+X53U+SHaQ3PldDG8//0beMNDmuAXASxe3eEUoBi6zMBKylE0KtEPDnJh/SOrSqw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.11.25 21:46, Peter Xu wrote:
> On Mon, Nov 03, 2025 at 09:01:02PM +0100, David Hildenbrand (Red Hat) wrote:
>>>> I have an extremely heavy workload at the moment anyway, but honestly
>>>> interactions like this have seriously put me off being involved in this review
>>>> personally.
>>>>
>>>> Do we really want this to be how review in mm or the kernel is?
>>>>
>>>> Is that really the culture we want to have here?
>>>
>>> Gosh.. Seriously?
>>>
>>> I'm ok if this needs to be audited.  I have all the previous discussions in
>>> the cover letter as links.
>>
>> I'm late to the party (or whatever this here is called. ah right, drama),
>> and I haven't yet dug through all the emails and certainly not through all
>> the of involved code changes.
>>
>> Peter, I was a bit surprised by your messages here indeed, not what I
>> expected.
>>
>> The "Your code allows to operate on pmd* in a module??? That's too risky and
>> mm can explode!  Isn't it?" definitely was absolutely unnecessary ... or
>> telling Liam that "he want almost mad".
> 
> It was a joke!
> 
> uffd_copy() API was NACKed because of this.  Now the new proposal
> introduced it.  I made a joke saying Liam allows that to happen in his
> branch, but forbid mine.
> 
> I thought it was super clear to identify.

Text is a very bad medium for that, especially given the previous 
discussions that were rather heated.

So it's good that you clarify that -- I am not sure how many people got 
that it was a joke TBH.

I understood the reference to previous discussions but to me it sounded 
rather dismissive in the context of this discussion.

> 
>>
>> Again, not what I would have expected from you, and I would assume that you
>> had a bad day and would at least apologize now that some time passed.
> 
> Sorry, no.  I won't apologize for that.  I was not fair treated, and now I
> think it's fair I at least make a joke.

Peter, if you would tell me that I am going mad I would not be able to 
understand that as a joke -- unless maybe if you add plenty of :) . :)

> 
> David, you're leaving, and I'm totally dissappointed that at this point of
> time, you ask me to apologize instead.

I'll be right here, working for the community as I always do. So please 
read my message as if nothing in that regard happened.

I don't want you to feel bad here, I want us to find a solution without 
more of this drama.

Because that's what we have here, unfortunately :(

> 
> I thought it was obvious a joke, because I never thought having pmd* in a
> function in a module is not OK.

Unfortunately it was not clear.

> 
> I always thought it was fine, Linux is not a micro kernel.  It's just fine.
> It is what happening in Linux right now.  It is so obvious.  In case it was
> not clear, I hope I make it clear now.  If I'm going to formally NACK
> Liam's series, I won't use this as one of the real reasons.  I just hide it
> in some of others that are real reasons.  However if to be fair, when this
> reason is removed, this series should also remove the "highlight" that it
> removed shmem.h header, because my v1 also did that when with uffd_copy().
> 
>>
>> I understand that you were upset by the previous feedback on the earlier
>> series.
>>
>> There were some heated arguments in the last discussions, but most of them
>> were based on misunderstandings. I would have thought that once they were
>> resolved that we could continue focusing on discussing the technical details
>> again.
>>
>>  From what I can see you asked for actual code and when Liam came back with
>> some code that looks like *a lot of work* to me.
> 
> It's Liam who stood out strongly pushing back what he at least used to be
> not familiar with.  This was, IMHO, rude.  It's ok to keep silent on some
> patchset that one isn't familiar.  It's ok to ask questions.  It's not ok
> to strongly push back without being extremely familiar with the code.

/me am I a rude person? :( ;)

The previous discussions on this were not ideal, because there were 
misunderstandings, yes. Liam has a lot of background on VMA handling, so 
I think getting is input is actually pretty valuable.

> 
> He might be more familiar now, I wish he is. But it's Liam's decision to
> work on the code.

Right, Liam took the time to actually implement what he envisionsed. I 
assume it was a great learning experience for him.

Shame that this drama here seems to make him want to stop using that 
experience in the future.

> 
> We're adults, we do what we should do, not what we asked to do.  If we do
> what we asked to do, we should have our reasons.
> 
> My ask was trying to make Liam see that what he proposed is over
> engineering the whole thing.  I was pretty sure of that, he wasn't.  I
> explained to him multiple times on why it was an overkill, he doesn't
> agree. It's fine for him to disagree, it's Liam's right.  Then it's also
> fine for me to ask him code it up to notice himself, if I can't persuade
> him.  That's the only way for him to persuade me instead.

Well, he noticed that we can apparently cleanup userfaultfd quite 
heavily. :)

And maybe that's the main problem here: Liam talks about general uffd 
cleanups while you are focused on supporting guest_memfd minor mode "as 
simple as possible" (as you write below).

I acked your series for a reason: I think it is good enough to implement 
that (as simple as possible), but I also have the feeling that we can do 
much better in general.

> 
> I sincerely wished that works out.  As I said, then I'll properly review
> it, and then we build whatever we need on top.  I'm totally fine.  However
> it didn't go like that, the API is exactly what I pictured.  I prefer my
> proposal.  That's what I did: showing the difference when there're two
> proposals, and ask for a second opinion.
> 
> It's not fair to put that on top of me to blame.  He's trying to justify
> he's correct.  It has nothing to do with me.  He can stop pushing back
> anytime.  He can keep proposing what he works on.  It's his decision, not
> mine.

I would prefer if we can come to a conclusion instead of having people 
stop pushing back and walking away.

I assume positive intend here from both sides.

> 
>>
>> He really seems to care (which I highly appreciate) and went the extra mile
>> to show us how the uffd code could evolve.
>>
>> We've all (well okay, some of us) been crying for some proper userfaultfd
>> cleanups for years.
>>
>> So is there a way we can move forward with this without thinking in binary?
>> Is there some middle-ground to be had? Can some reworks come on top of your
>> series? Can so reworks be integrated in this series?
>>
>> I agree that what Liam proposes here is on the larger side, and probably
>> does a lot of things in a single rework. That doesn't mean that we couldn't
>> move into that direction in smaller steps.
>>
>> (I really don't think we should be thinking in terms of a CoC war like: show
>> them what I did and I will show them what they did. We are all working on
>> the same bigger goal here after all ...)
> 
> We've got some second opinion from Mike, please read it first.

I read it, and I will have to look into some more details. But what I 
could read from Mikes reply is that there could be a discussion 
continuing where we would find a middle ground.

Well, if I can motivate Liam to keep working on userfaultfd at all.

  David,
> you're co-maintaining mm with Andrew.  I think it's fair indeed you provide
> how things should go together with Andrew.  It's fair you and Andrew
> whoever would like to make a decision on how to move forward.  I'm fine on
> whatever decision you want to make.

Unfortuantely (or fortunately?) I am not officially maintaining 
userfaultfd. And Andrew is not involved enough I am afraid to make a 
decision.

Of course, I *could* make a decision, but that would likely involve that 
we continue the discussion without this drama. But do people want that?

-- 
Cheers

David

