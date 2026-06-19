Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 396ECCD98F6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 21:59:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF4946B0088; Fri, 19 Jun 2026 17:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC706B008A; Fri, 19 Jun 2026 17:59:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B093E6B008C; Fri, 19 Jun 2026 17:59:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 814946B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 17:59:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC5BE1C509B
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 21:59:25 +0000 (UTC)
X-FDA: 84898029090.21.7F83005
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 44D9220006
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 21:59:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mh6D9kHz;
	spf=pass (imf13.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781906364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YE9FsAEawOx/IbPBCnSCpqjzjQQ6cvPqBHsq0OtQzPU=;
	b=LQI5Ywwtz4EoZpm2a2Tj41uFlywP7yYzmdrmF1SSV0+5eLYRMjXuTo8o5VgwY8TNwpMp48
	afh4JTIYWCdz6pm/vTlQ31E5eo4T/Q4DOQRiw7lFfMyIHjAiu7ERMG2Yg+tApOMXZQfT8a
	JzFk4KNKfPP/Fbp0cbeV5WUTjLklLJU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mh6D9kHz;
	spf=pass (imf13.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781906364;
	b=vM7SPpdt1C/9Wi+D/ewVSqjcAOrTSmNXxmzWTuWZYAZdoRsRhoQbpP/d3rGm1/5aEuSbL8
	LEeW2Zskgb0op5/vujRwHSG8zJ6IE93N0E+MTa6uX9J0gNGjnzZ6oPe79ScSNdgCQK5R94
	7S4LOdmK14ABESvi9an8dJFm8Ldk53E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A3F140716;
	Fri, 19 Jun 2026 21:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EE91F000E9;
	Fri, 19 Jun 2026 21:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781906362;
	bh=YE9FsAEawOx/IbPBCnSCpqjzjQQ6cvPqBHsq0OtQzPU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=mh6D9kHzxJY0pa3LOENHD/3hzGrhGHyUo/Btagm7V30EUC1odfn+g7EPyOqel0Pa2
	 6KVvTR2tqr+Ir1pg9Gxz9+Q0q+6WuSawLH7UcOFW521X9PX2K8aUm2IqPqWVQoM61h
	 JNwqXTIQdfx8e/QRZluAQJ71M5uKSF7VetigNM9VyViDfvSbnkcJ5mMFHiWscMUtle
	 TWZF0GsS5DSpoC5ufaRDMCM6e4/ZdSmvJpCkg28UQmzafIo1kKBmHTNabrqnMnDpvh
	 PtqirfSKgFhVIykW8zogS1GjXfT38UR/tNztYwt6X77YCdsMp0oe1NCkTl6t1F9F+U
	 aP3F3GpJodxZw==
From: Thomas Gleixner <tglx@kernel.org>
To: Zach O'Keefe <zokeefe@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 David Stevens <stevensd@google.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>,
 Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave
 Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Andy Lutomirski
 <luto@kernel.org>, Xin Li <xin@zytor.com>, Peter Zijlstra
 <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>, Kees
 Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
In-Reply-To: <CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com>
References: <20260424191456.2679717-1-stevensd@google.com>
 <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com>
 <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
 <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
 <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com> <87pl1md7h0.ffs@fw13>
 <CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com>
Date: Fri, 19 Jun 2026 23:59:19 +0200
Message-ID: <87qzm2b39k.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 44D9220006
X-Stat-Signature: hygh1fy6d99nsns35u4j734789qu5sui
X-Rspam-User: 
X-HE-Tag: 1781906364-836033
X-HE-Meta: U2FsdGVkX1/y81Ot688Tnvw62pnsYPA6XWLFtTErtvR9qQMnTkBVCBVe1XU9chQBmn23UcseoMLo2cZz5/dRXJ9ksGZjuas7DYe/kRSOrsSiM8NNs4/naucArAWgGxSMGl6AGYV/rZi4lPBLZ2LiOYVT33whi/3FypsJvKJjmnBovh/ewp/b0ddqWGi8wn3Ifz7sO8AzUzOnDieponBM5bDGrgne++gJTT0ncUOBN+yaPzJhURLMVc5PfOLNmduvXD/H4C59+1oSAbAmXSKEAC4HyDEYru2Z4PEX4aFNvAa4Rbvtvx8gwGH4RZkBvmZPXFFb+yzsQTty9ND4lc7aV7VD7LBKnDnjVn9S1SzJ/oZpbtK98AXcLqWaj4aVeGcSpKLJUWMFaAEvALias9O2Qffq+oN92OzWyEgze6nZBi3g8k+5l6mYMqLbiJ5SPm+pGfI8gpvNHRalirvnrSr4yGKC24yRr6B5FVCUJPzsF9QXVE6De9XKqyJ9QTuMswPecwDwY7u0Az+/RbcGbOklHPKEFySwnwW4FIDFuhND8pK/rsnbXf6vZOPa/AvDHXTsEJh8Hgmroc6EgyxpvutrhZnDOWmpUda56D7TN8/tuGgX1x3ukfnKaS4G+LcJgDE2+025VosNG4pbwvAugeOT66bhp9dGR0woK1J5+Gb45E5jwEfa5ulqv9+5GnjLBTq73WFlDJCNRd53QpoeCbO8aTsJNQ5wWmXLJK8wjCupsLc6+y5+2n5Z2601tL7VvXcoKFY6rCE8HWpdTJQMPVgH3iAuGFGONUPAUP1eWUcUXwsCYCGsAEZ+LSauMBVjeKWCGbMPuRjk4Ooqhz+EaKRDAWjlywvswIg2g/znoZermIMXSJysvZ8l8FOISrw8+vC2MqMdqiJ4613zKI3oFmbpK2ox7XH5kdGX6woLFwdIlA+sCNHazAyj3f2pW/4YfMvdlr3i/b1GqnGxyruDMbo
 MT6K7PUL
 foNV3UWeFMSc6snHvgfaCRNQBMzRfkXEQb5QuzkulzJzuU8YYc/uzUvKqK/yb0WTnJYc9ffX61sVBa0SQAWQCb3mNjXupXkhT4yX0QU4o/XZPCHN5scSuuNk7Frm5hQPymJCzRe22dnLSMi0tn5h6MCnUM6pLNJIwhBqZA902cacmIX+NHZgJeHHkj5f6SLddotYUvM9A6QWokHMbBwzcbKRRuzqqKYk3RG5LnlDd4bkWLxsSYOVi7acuJjY9e4cJfjKj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Zach!

On Fri, Jun 19 2026 at 12:20, Zach O'Keefe wrote:
> While it seems common opinion that the IST-based solution is fragile,
> what of FRED? It seems like this is exactly the kind of support needed
> to avoid some of the aforementioned sw "mess" in various x86 exception
> handling paths. I agree that it's less-than-ideal that we are forced
> to downgrade exception levels in the common #PF case, but is that an
> unsurmountable problem? Pardon my ignorance.

The #PF path is considered perfomance critical. But how much the
downgrade matters needs actual numbers to analyze under various workload
scenarios.

I've not seen numbers to that effect anywhere. The only numbers provided
are marketing material about the memory savings on a freshly booted idle
machine. There are _zero_ numbers about the actual real world savings,
but claims about the PETABYTE savings possible.

Seriously?

> Lastly, I just want to clarify what folks have meant by "extraordinary
> claims" or "evidence".  Aside from the above discussion on FRED
> exception handling, the "only" other part of this is the allocation.

Clearly anything which is explained with "shouldn't happen" and
"unlikely". At cloud scale nothing is unlikely anymore. That's simply the
reality of statistical math.

As I pointed out before the same applies to the unexplained
upgrade/downgrade game with external interrupts. Such issues cannot be
papered over without understanding the root cause as from decades long
experience they come inevitably back some time down the road. Cloud
scale even guarantees that.

> Are people concerned about memory unavailability, deadlocking-type
> issues, or something else? We have considerable design freedom here to
> avoid certain classes of unreliability, but=E2=80=94barring any clever
> tricks=E2=80=94I don't know if the allocation can be guaranteed to succee=
d in
> all conceivable circumstances. I want to ensure that reality does not
> present a hard blocker.

First of all the failure scenario has to be clearly defined.

Right now, if I'm reading the patches correctly this simply can end up
killing the wrong tasks/processes just because an OOM situation results
in a depletion of the per CPU cache and the very wrong task which runs
into the deep call stack situation ends up in the creek without a paddle.

Given that you even fail to abort a CPU bringup when the allocation of
the per CPU stack page cache fails, makes it pretty clear that there has
been spent exactly zero thoughts about this problem.

Why the heck does this cache refill call have to be unconditionally in
__schedule() where preemption is disabled and therefore GFP_ATOMIC
is mandatory? I know "Works for me" (most of the time).

And just because I was looking at the patch in question I found this
other insanity:

> +	/*
> +	 * Most likely we faulted in the page right next to the last mapped
> +	 * page in the stack, however, it is possible (but very unlikely) that
> +	 * the faulted page is actually skips some pages in the stack. Make sure
> +	 * we do not create  more than one holes in the stack, and map every
> +	 * page between the current fault  address and the last page that is
> +	 * mapped in the stack.
> +	 */

Can anyone with a sane mind and the most minimal understanding of the
kernel's inner working explain to me how the kernel can skip "some
pages" on the stack?

If the kernel skips a whole page or more then there is a serious bug
somewhere. I might be missing something, but again the "very unlikely"
wording which handwaves about it is just disgustingly useless.

I disagree with Dave on the RFC status of this series. It's not even
close to RFC, it's at PoC status.

Thanks,

        tglx








