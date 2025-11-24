Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D662CFD356
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 20:39:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D5A26B0093; Mon, 24 Nov 2025 15:39:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AD466B0095; Mon, 24 Nov 2025 15:39:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C30A6B009D; Mon, 24 Nov 2025 15:39:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 691B46B0093
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:39:04 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A4D30130A6A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:39:01 +0000 (UTC)
X-FDA: 84146664882.10.ED733BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id F1CD310000E
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:38:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=evZkZ5Us;
	spf=pass (imf14.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764016740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xF2KQDlHr/Ur1xWmQRwefTmJhLRhuQUIbwSk3r7yzZE=;
	b=lJ6197i32xwcji+pAjVs43I46fB3vnGTOVxDYri8CIdDfn0krnXVjvft+hG8U/c6pqy1hR
	qrHweUDbe6ymHsCwoUrN/HQ6kxg/Pzv2CK/KFAhFyOkqsfKETamnK4Ik3xRqogKodO8xb8
	wb5gbZ7RP2lBPTtkSsA8hTFlHdH5NiM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=evZkZ5Us;
	spf=pass (imf14.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764016740; a=rsa-sha256;
	cv=none;
	b=zE6rcGWxZqrhcU02ljB3jriKP0P+bFIDxDkc0Q1kpDF+5yqYpDYSGOPdFITA9SgVM+7oKk
	B7HSCwHRsMes8Kf8PQhgVjnPxv60806GysLF/Z2gMtKb/CoLzjjgpn/9JFOaFPiLM6XLtk
	C/8ZWFjk9i7SUP2h3KLawnEjuhkVwcw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BC2A14016B;
	Mon, 24 Nov 2025 20:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8EBC4CEF1;
	Mon, 24 Nov 2025 20:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764016738;
	bh=JLdIJ7QZP3U00BhhJOkbi1WT14KAskMlSFeurQ7aMlg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=evZkZ5UskrSLOHY1/mNMNWBXcNJsOx/pv8d25Cq5RbPbYFU+mewNWmC4bIco+jJ4w
	 yzzy0LoaIeOAP3NdBCrb6CiIFZRtSQu3gkC8dlLBksOtGyoPGpLel4GpJBhQjoZMM5
	 kmwhK7dZueujrAMnNGDV2VKcaEdYEWJ5MfLT1CQhbfL+0QUM2dRF4jur40/ZFOp9sO
	 dLpkAp8Vkk5OnKyuaIbMjwlXDEo1yDdarWroTIOTqsFrFXaQBpicKQLLWJm04gHgR2
	 gHUC3FJqEIWa74F6D+HX775twAOiLFzrPXDfaWPtbpUvggCxxszPeBXAFANkjviinZ
	 5f5828/aSw2VQ==
Date: Mon, 24 Nov 2025 12:38:57 -0800
From: Kees Cook <kees@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Marco Elver <elver@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	linux-doc@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v5 2/4] slab: Introduce kmalloc_obj() and family
Message-ID: <202511241119.C547DEF80@keescook>
References: <20251122014258.do.018-kees@kernel.org>
 <20251122014304.3417954-2-kees@kernel.org>
 <CAHk-=wiNnECns4B3qxRsCykkHwzovT+3wG738fUhq5E+3Lxxbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiNnECns4B3qxRsCykkHwzovT+3wG738fUhq5E+3Lxxbg@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F1CD310000E
X-Stat-Signature: kwu37ku71346zare3hdgpudi8wrs1ewz
X-Rspam-User: 
X-HE-Tag: 1764016739-267442
X-HE-Meta: U2FsdGVkX18t468DiawJCLhkxleZnorLqiRu/SkFfjEt9gondEaOeLCZMY9773bo0WmvLRZinlkuZpibeeRKtq2FeKvYgwiuQkW6BEPXvh9BmDhi4CcDNNuRP0e8yNlorWZAmQBuOoS2kF9EkMZDlCTEG2GvmjgWhGrenJkwy+vevD5ij310N+tjQdZ6frP4Z0P6Ov93mk2UklTOQDlpOEfYX53SZ793YxZn/zDdhVu+P3FIXb3qmcfzXmh7bgRi/7Is791SjCqPQpmAeeTnaC6Ozz82HDWTcMNxca4bL9aQSraN6vu6XgRrpC8nAW2Wscc6wQ2NjXO4pUN6bnBcPCc9B/MAxm2ZJ9QmBXb5GTyJHSfhL7nsq6tGFw185aBHJSop8szjj0UXhnQORemBCIE6RnsM8BLVwfqo0frR6ikzzvHz+do7uQkkvFscAbH9Syu3ERVYMaAH/7m6fQjFkg+uQ51ZIUdr3Zwgtc1dFZzVhQaI1iljkBvPxZTlUpG9/itM1DMR13klTX2lo4UhMsqUe/Ggnj+3jHnHx8z09ZIti9RPqW9SN8BdKuoU4QeWascrHIqQ5tistLdvebS96kvNAE7SQGyeD5txlgaWwB5l5KJdqYPcFdn/9WG9/UdKEp81yqmTlHY1cfG+qST3yWfY0BFyHMA/pL3YzhnrGpqEHVWMbnnUhP8xSU8IBbDtZdCkkls/EZtxiivz/1OtOXYVD7tQw1ovbYqjsm/Agv18R23gRDuf/env8RMk9AWQ40W7AWzfvy7PuhxgqEzM1r8fTQYx9d/CQGynEl8Ob/tcdsRvwWzTlmzrzA5q9DG5fpz21CIIH2UARxad0ndK7jjcQ7PAL16S56yXdnwpFGvgJugg/Hpe1vGOnAI3WhFEo21DylX9CSZAnT09/zpDCUED0LGkD+Ef92HnvByrhDfEe8F0A6+0ae8arda2Zky8/3MpeTP8ttv+cj4Rdm4
 X0tc4m/a
 tFhABZ6DhoCi4THbaLeXklofM2eDDcdYO1123aU+sO4XuDPTwkBYCvWa8sHZEyUz+2hmzjwOQJTQIOzHboQ+DBrkt4PNQAcHCisstqos7ZRUWFrpZhllpdRyLU8/xhthpLICTDTAIgJhELCqL+CpoAnWY6YEpnicQ+kMHJjhIlsjqbS2AuShMPI/Vhx8nKY4jktuMEoGHR849JyTlO6osSoQs6mO7kV8Lb9l5zVDzZ0xpjxPhdRQ/FzE2vkUWoFP9q1uX2LveM2zkbgXsivMHgyjZF26h8bYbhyWmUtplVzzNoUwns2FChSxj1xAyUeBJ8EqdQD4E9rlY3ngusRnGU6lOcwiZiV0Obd4NZ1+UinzBDRQcxvVeh1ahj8FpwDVyQxG29iQP72lRCYUo90zFtc3pcDD6q6QDvNqGQA3onjY7bRzY/Zr9y9xAU0ni70e/6G5U
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I extracted -- from your kind and loving feedback :) -- a number of
specific concerns you seem to have about this proposal:

- You don't like the additional ..._sz set of helpers.
- Alignment isn't taken into account.
- You found the ...set_flex_counter() usage unreadable.

To me, it seems like the primary issue with this patch is that it
probably needs to be at least 2 patches if not more, where we can
iterate on each aspect.

The area of _agreement_, I think, is that type-based allocation is
a good idea. You even recently used it as an example in an unrelated
thread[1] discussing variable declarations in the middle of functions,
and used (a form of) this API proposal, which I whole-heartedly agree
with. i.e. that once we have type-based allocators, we can do things like:

  __auto_type var = alloc_obj(struct whatever, gfp);

So, taking each issue in turn...

On Sat, Nov 22, 2025 at 11:53:33AM -0800, Linus Torvalds wrote:
> In particular, I intensely dislike that horrendous 'SIZE' parameter to
> those helper macros
> [...]
> The argument for that horror is also just silly:
>
> On Fri, 21 Nov 2025 at 17:43, Kees Cook <kees@kernel.org> wrote:
> >
> > These each return the newly allocated pointer to the type (which may be
> > NULL on failure). For cases where the total size of the allocation is
> > needed, the kmalloc_obj_sz(), kmalloc_objs_sz(), and kmalloc_flex_sz()
> > family of macros can be used. For example:
> >
> >         size = struct_size(ptr, flex_member, count);
> >         ptr = kmalloc(size, gfp);
> >
> > becomes:
> >
> >         ptr = kmalloc_flex_sz(*ptr, flex_member, count, gfp, &size);
> 
> That thing is ACTIVELY WORSE than the code it replaces.
> 
> One of them makes sense and is legible toi a normal human.
> 
> The other does not.
> 
> The alleged advantage is apparently that you can do it on one line,
> but when that one line is just horrible garbage, that is not an
> advantyage at all.
> 
> And the impact of that crazy SIZE on the macro expansions makes the
> whole thing entirely illegible.
> 
> I will not merge anything this broken.
> 
> The whole "limit to pre-defined size" argument is also just crazy,
> because now the SIZE parameter suddenly gets a second meaning. EVEN
> WORSE.

(Size calculation)

The benefit is not that it is done in one line, but rather than the size
calculations (which there is no exception handling for) gets built into
the allocation so that wrapping and truncations get communicated back
to the caller in the only way we have available: returning NULL from
the allocation.

I'm not sure what you mean by "limit to pre-defined size". There's no
such design in those helpers, except from the perspective of "detect
and refuse to truncate overflows into too-small storage". Is that what
you meant?

The persistent problem we have over and over in Linux is the lack of
feedback from overflowed arithmetic. This is being worked on[2] at the
same time, but I'm trying to find a way that we can get at "normal"
error handling, since just exploding if an overflow happens isn't a very
friendly way to deal with such conditions, but C doesn't give us much to
work with. If it's _part_ of the allocation, though, we have a natural
way to say "but you can't store 1024 into a u8".

For code like:

	u8 size;
	...
	size = struct_size(ptr, flex_member, count);
	ptr = kmalloc(size, gfp);

While struct_size() is designed to deal with overflows beyond SIZE_MAX,
it can't do anything about truncation of its return value since it has
no visibility into the lvalue type. So this code pattern happily
truncates, allocates too little memory, and then usually does stuff like
runs a for-loop based on "count" instead of "size" and walks right off
the end of the heap allocation, clobbering whatever follows it.

If we have a clean way to build the size into the allocation, then we
can report back a NULL allocation when something goes wrong with the
calculation or the storage of the calculation.

Now, an alternative could be to keep the allocation and the size reporting
separate with some kind of __must_check "give me the size of this thing"
function, but I don't really like this because it feels much less
ergonomic to me:

	u8 size;
	...
	__auto_type ptr = kmalloc_flex(struct whatever, counter, count, gfp);
	if (flex_size(ptr, counter, &size)) {
		kfree(ptr);
		return -EINVAL;
	}

> [...]
> Because once you give that "alloc_obj()" an actual type, it should
> take the alignment of the type into account too.

(Alignment)

Sure, but that's the whole point of trying to switch to type-based
allocation: so that we CAN get at the alignment. That would be a "next
step" approach in my mind, since we could bucketize allocations by type
(or alignment), instead of by size. But that's more of a follow-on, in
my opinion. I'd like to get some agreement on the exposed interface for
this API first, and then move to enhancing the internals to take
advantage of the new information.

> I also think this part:
> 
> +       typeof(VAR) *__obj_ptr = NULL;                                  \
> +       if (!WARN_ON_ONCE(!__can_set_flex_counter(__obj_ptr->FAM, __count)) && \
> 
> absolutely needs to die.  You just set __obj_ptr to NULL, and then you
> use __obj_ptr->FAM. Now, it so happens that __can_set_flex_counter()
> only cares about the *type*, but dammit, this kind of code sequence is
> simply not acceptable, and it needs to make that *explicit* by using
> sane syntax like perhaps just spelling that out, using VAR, not that
> NULL value.
> 
> IOW. making it use something like "typeof(VAR.FAM)" might work. Not
> that crazy garbage.

(set_flex_counter)

I get your objection. We have other places where we do "((TYPE *)NULL)->member"
explicitly to get at types, but I see what you mean that is feels very
wrong to see the "->" after setting something to NULL in that it's
separated from the NULL-ness.

One of the reasons for using __obj_ptr was because "VAR" may be a type
and not a variable, so "VAR.FAM" isn't possible. Doing it the following
way seemed uglier to me than using __obj_ptr->FAM:

	if (!WARN_ON_ONCE(!__can_set_flex_counter(((typeof(VAR) *)NULL)->FAM, __count)) &&

since we literally already have "((typeof(VAR) *)NULL)" with __obj_ptr.

But perhaps much of this could be collapsed into the
__can_set_flex_counter() helper instead.

What do you think?

-Kees

[1] https://lore.kernel.org/all/CAHk-=wiCOTW5UftUrAnvJkr6769D29tF7Of79gUjdQHS_TkF5A@mail.gmail.com/
[2] https://github.com/llvm/llvm-project/pull/148914

-- 
Kees Cook

