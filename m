Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74CE3CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 15:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FFE36B008C; Wed, 17 Jun 2026 11:56:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D7796B0092; Wed, 17 Jun 2026 11:56:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217D16B0093; Wed, 17 Jun 2026 11:56:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E875C6B008C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:56:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8337C166476
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:56:30 +0000 (UTC)
X-FDA: 84889856940.16.AF9AC81
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6834F4000C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:56:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="T1J/WI1K";
	spf=pass (imf04.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781711788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MAW/jHNB+s73bmq2RK9pw8vdXIwRnuLexugbKU7MQww=;
	b=BjXwoaGG0MrrPf+HaAFYhHLEDfQjqYQ1F3TnFfpENM7e3PeRgcdv1zGwb+qnaSVvySlVf1
	3khvWeS/HhOa0SuP0Rui5OCov+bRhlsUE0whY9fk4512iTeRaDQovY9GJZlNjghLX9GzUX
	o41mzaSMzZyTlG7teEpVYJsF9wTM64w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781711788;
	b=uztrPdQfoqqKlZXGNeSRpbhBtH4/89w0CQEWGY8PqUwNzFSL2GH0/H3yG3uGAYqDZjJoLg
	4BmR5i0oxuwbsyHX9ScruU3zGFl7UtaEz2dYw8Zx0MwaSl+C6C1Si0fRlkBnQNtuDFAOK+
	LIxxwPtqh6PASZL0suz6FTJtwNwhXHo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="T1J/WI1K";
	spf=pass (imf04.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781711786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MAW/jHNB+s73bmq2RK9pw8vdXIwRnuLexugbKU7MQww=;
	b=T1J/WI1Kel1qpBrOpKglPcwis+2PhWxb5gyj0zwbqYuS/7xBSLBcS8KAxN1wGf+rFBSIbU
	6ZXYlnf+6irMQjApOiGijrQ6tgNGaLSYeKt27oRQ+UX24d1clXwr3q8vTORfDZ7wT0msJp
	YdQC8SYqQrXLKEyeHZKZWKPfs7IRYtk=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 17 Jun 2026 15:56:21 +0000
Message-Id: <DJBG44TUTGYT.YIR4GG0EZ7CS@linux.dev>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
 <rppt@kernel.org>, "Sumit Garg" <sumit.garg@oss.qualcomm.com>,
 <derkling@google.com>, <reijiw@google.com>, "Will Deacon"
 <will@kernel.org>, <rientjes@google.com>, "Kalyazin, Nikita"
 <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, "Itazuri, Takahiro"
 <itazur@amazon.co.uk>, "Andy Lutomirski" <luto@kernel.org>, "David Kaplan"
 <david.kaplan@amd.com>, "Thomas Gleixner" <tglx@kernel.org>, "Yosry Ahmed"
 <yosry@kernel.org>
Subject: Re: [PATCH v2 20/22] mm/page_alloc: implement
 __GFP_UNMAPPED|__GFP_ZERO allocations
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>, "Brendan Jackman"
 <jackmanb@google.com>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Wei Xu"
 <weixugc@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan"
 <ziy@nvidia.com>, "Lorenzo Stoakes" <ljs@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-20-28bf1bd54f41@google.com>
 <fe191e75-29b3-49c1-8c54-55d41b3e786d@amd.com>
In-Reply-To: <fe191e75-29b3-49c1-8c54-55d41b3e786d@amd.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6834F4000C
X-Stat-Signature: rtghpuftxaqxq7qg8ys6tcnhurddd3i5
X-HE-Tag: 1781711788-553091
X-HE-Meta: U2FsdGVkX19YRwcdZuOmlQ5pAMorwd6ycBt23Q1SYU+dGoy21taQnH70ck6EYaFxQfOwuB1urVWF+gDXEmQXW04isvoW09t0ANGH25PjEsalJCKREXkRz3RkjmLKpgbOnh3tgg9eaG4ApuFZNAvp12mbP5P/NmdCeeAx25+DjZ48opFfSl2GKBObddQIeqaYSL1wAI8az2S/cnCyniWVnNuHs2Z90FfXeRQ0C7GAvgw4maXuM+rPdfcHIE/6kTkwf0ITUVzdHYvRZ1PciFmPoUm9md9cXb2omqLsVb/Sr5KGMrDB7gRVCZKpIo6/uaWZ6Fd5R9pcKklc3JLjNr4MyRseui6RZl/J+470ooFgmfVtF7MBcI/3Nj42xgETmTEle0i2g7R2kL5QqHw5WnlFxD4vxOD9H+WUURJjMXqCGkdh5hlaITnbSy4Sc+Jid4+fNoI11Dh24QkR9+RmbEKbCFM717acljZ0Kv+bBHSywzgvAg/VdvRmX80yeY8d5Tzu81NTMqwWHlzeD7SJmAxkxlz5Lt2uhh4m3hjgqF823BMZzG1defizS19BmhtIKspTwQ9biJGuLB7lHf9OIXS1UmtX3rwFc6iW3ch+rx3AoPFJq8l8jnsVgAFkhy7O9erNWGPuUA1lJsguEm5f/qboKtgrgIPQ7XgyiQzI6WhcRtZn+nmuw+Rlx+NegfZyA4ay80dhB8zNugDnWyBAaJE1+6RYgCHZmwPn0kghTF8zCTHw2eIdwlwEiKuKF3QTnHYihbOoYo82LyQ6rEoWGImWWe9578rnOpI5DrSTyPmnofrhu+qn0VjDjkyAz7JvHX0cLy8xzNwB/EGgXWldzQd+69Ki3XOAwwCIJfBKg5tg1c/gAzMPcouWLIbioRevAcpLJYY+SbgJiEa0LNWzWeT56A8309iMdzPYIeryf9fjg8ftC83L0xypMe8FvnHPvhwm6EZxcrMS7W2z86EjWwr
 LNH5HBRx
 Ce3wi+F/BZ64b72H/rNEsyejQ/1XbmwRy3mbm7FqtpYB55cixzf/mHEXWfUjzstJIoCukHCX4hWuvARAYb/nN2trzfCSEWfB9faMslvvteGnrrrBX6Zt3wz8VTbcIRArXc+nTf1QFskygCOBm+2GoTnYu6pOuXUECETP+A9uPf68aF0+hxfSI3/l2bjOjtLpQWJic5Yv6+nj/n8u4XPk9cbtlGmf9l+rVyZARjW5RAzLnGXtWbr9ysXPyvvcW+p8GqEuI3TayKhxIVseBS2blmRIWnz6zd+NcvNwu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pankaj,

Thanks for taking a look!

On Wed Jun 17, 2026 at 11:32 AM UTC, Pankaj Gupta wrote:
...
>> +static inline void clear_page_mermap(struct page *page, unsigned int nu=
mpages)
>> +{
>> +	void *mermap;
>> +
>> +	BUILD_BUG_ON(IS_ENABLED(CONFIG_HIGHMEM));
>> +
>
> I was thinking =E2=80=94 would the fast path read better if we moved=20
> migrate_disable()/migrate_enable() up a level, into clear_page_mermap()=
=20
> itself? i.e
>
> migrate_disable() -> here
>
>> +	/* Fast path: single mapping (may fail under preemption). */
>> +	mermap =3D mermap_get(page, numpages << PAGE_SHIFT, PAGE_KERNEL_NOGLOB=
AL);
>> +	if (mermap) {
>> +		void *buf =3D kasan_reset_tag(mermap_addr(mermap));
>> +
>> +		for (int i =3D 0; i < numpages; i++)
>> +			clear_page(buf + (i << PAGE_SHIFT));
>> +		mermap_put(mermap);
>
> migrate_enable() -> here
>
> Right now we split the migrate_disable/enable() a layer below across=20
> mermap_get() and mermap_put().
>
> Would it make sense to embed that in the clear_page_mermap() API itself=
=20
> =E2=80=94 mirroring how we already disable IRQs at this level for the=20
> mermap_get_reserved()?
>

Hm, I guess the symmetry would make sense. The reason it's this way is
because the mermap_{get,put}() API mirrors kmap_[un]local_page() etc
which do the migrate_disable() internally while there is no precedence
(AFAIK) for an API that automatically {dis,en}ables IRQs. That might
also be a side-effect of the fact that local_irq_save() requires a local
variable while migrate_disble() stores its state globally. Similarly,
there is no equivalent of lockdep_assert_preemption_disabled().

> Thanks,
>
> Pankaj
>
>> +		return;
>> +	}
>> +
>> +	/* Slow path, map each page individually (always succeeds). */
>> +	for (int i =3D 0; i < numpages; i++) {
>> +		unsigned long flags;
>> +
>> +		local_irq_save(flags);
>> +		mermap =3D mermap_get_reserved(page + i, PAGE_KERNEL_NOGLOBAL);
>> +		clear_page(kasan_reset_tag(mermap_addr(mermap)));
>> +		mermap_put(mermap);
>> +		local_irq_restore(flags);

BTW, writing the above just made me realise: we don't need to disable
IRQs here, only preemption.

In a WIP version I did have mermap_get_reserved() requiring irqsave, so
that you could theoretically use it from an IRQ. But actually I don't
think that makes any sense since it depends on state in current->mm.


