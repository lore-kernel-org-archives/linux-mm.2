Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90CEAC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:58:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98E476B0167; Mon, 13 Jul 2026 12:58:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 917F26B0169; Mon, 13 Jul 2026 12:58:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 854F66B016A; Mon, 13 Jul 2026 12:58:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 625CF6B0167
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:58:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95A10C1032
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:31:37 +0000 (UTC)
X-FDA: 84983991834.22.2892F71
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6832D14000C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:31:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YhPqNrZl;
	spf=pass (imf26.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783953095;
	b=ECtjwa/5HuMaohk4IzI8xOxIufhzCs6BWhESQWIJD0ND+edMR+Gob3IGEAlcRtNqTjY7CE
	ZsAkdpI9sI2Svta2sUv2SDX7zqL2iI2pXjSLZSESkMH9lUaZ4254dLeMK9wUvPtWxvrqUH
	5HPtbvmfsDub5d71FTb1uw6cRF7W32I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YhPqNrZl;
	spf=pass (imf26.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783953095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RP3LyPOyZnOu+5+FjIIqGVMA/Bpeem6vrUwBKnHaTKI=;
	b=q8tyNJrCboXTLre3aimmDYXNilVWbKKnq9PI7rvil3Esc5WOnVF59diP67vJeqSh8rW28t
	NaGvbpTUjwtXlykpNWzw6aCP1vMg95/FvLPvNFcOK5SGaKRJqDiq3UHc6d93eUUzfnJOeQ
	9uG392Fl1xx0NF2UFPqT4rV6W6USRqk=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783953092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RP3LyPOyZnOu+5+FjIIqGVMA/Bpeem6vrUwBKnHaTKI=;
	b=YhPqNrZlHQ8ejQJEsKy22q7L2GwC8ZsKq8sODTlaMyBeXGHMdDNE3YCyn027NpCm9FGZKb
	GH4lpKEvmboLM/8AbLfjpjKd/DdrCA8T9cOaPAVIXi/jfL1ehkYFeaV3dNVJG67SVAs8NC
	uHVXw1fkorik/3Y+InQR45DobcQBcmo=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 13 Jul 2026 14:31:29 +0000
Message-Id: <DJXILB94G82L.37YBL62YO9XBK@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Brendan Jackman"
 <jackmanb@google.com>
Cc: "Vlastimil Babka" <vbabka@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Sebastian Andrzej
 Siewior" <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, "Harry Yoo" <harry@kernel.org>, "Alexei
 Starovoitov" <ast@kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>,
 <sashiko-bot@kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm/page_alloc: don't spin_trylock() in NMI on UP
References: <20260710-spin-trylock-followup-v1-0-affb5fe5ed00@google.com>
 <20260710-spin-trylock-followup-v1-1-affb5fe5ed00@google.com>
 <20260710170311.e22bfd21c658e8357ceddeec@linux-foundation.org>
In-Reply-To: <20260710170311.e22bfd21c658e8357ceddeec@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6832D14000C
X-Stat-Signature: r6ybkh6x4j3wk14g61zrri9o3bpym9tg
X-HE-Tag: 1783953095-456484
X-HE-Meta: U2FsdGVkX1+A8mmjdKCYVtuaoTRegKkNDOzs7CMJzxl2pbyS1yW5psOzK18p2p/o0eUKvc44ZY0xjNUsbxSdqasbPSCUHyy2EqVImdc9B+rq4aYXXcfw+0frUTxV3h5kdp2pfLgUvl3TPztG/502b7+wbJ2r0C3D4eTR2OwhRl1dYlZaCLq94hXFfokLYV3Hv0esHyf5PF3lnngoLi28GAbVcNK3rcjK5R7XGirBtIxPh6Owb68qDo7AehatAcMr9JCsA1/FVYhZGWFgA4DWPAOVjfFTFpkuKYEk492dSIwdmjZsUBhFgZG3vP+hoL2B+lGGBtpl7sxbUozQNjVxA8IydQPhIPhv/5UZwoOdsQlwX3wCQdQuL1RAK0zGr+5put3Sj2+chKQjK7KvLinT6GyTe5X+qF+rI5i6BHwHGDjFGUWueRcqgUz8icAtUkVC4Gvq3PuLy65AWhsZhiVEIs0Nteq66R+9lwJjB6dbAoxuY1NjCVsXIWGs2NQbcBkNF6Eq9FG+bisHUsFsgdV0sjY2Fl2op1KbysbL+WNpfkvoou/RI8Pwz3SxEn/E3bxhys5dGZ1xIWExwOKC+gDBh80NhkbJ6vBrWnfV1GaC7PO8h4tobczrV8xxCo3sYnmwWlMU6auTveIFdNSOskHioCkhZ/64C5X3aLbdN7CY1m0wrsb3bem7HWb5TOdYm8SW+Boit30n+hgixGvd71LtJUY/Ii2IWcyTMXO+Mru9fuw6cF0CL5diOz3rUehvgdZVQDEgzBPLXW/eq+kWiAQX+Hu9N8NLkjSWZFygPAUe/Qu7/AEFZ5AMq9pD7AlF/a/7QWLba9gZAOj0+QuOSGrk5wkRR+P/Y4Qm1CvhRPVDAq2p8vwcJJCBx9L1+68Q775DOC0x5IgAtWeBE7KHnq3CYCTcLosMlwZZuEwSHMyDstVtw9P5tKsf8vnnU1H/4RgDtsemw6A65o+s0WFk3hn
 ofmQE4zT
 YoG6ntKqKaUU2v0xWtNvDv7PVpwpfzBFaON3mxOxa4V2ARNXhibhPRnNXGSIJAsGxHLeKYLVGZB3w7UUXTsPfHKyx+egohBgjNNAMGCZ30l9ftWlrBpxL23aaZWeDY/lKiCbFHZpTqWrz0EM7Om/Boj8k1IM7SItbOwZtsEFfjq5KLDU4GsEsG/mPYCdn3VuHhpGVZH7S+76K9rL6yHwySIor4+YGyZvbA9+9PdJ7rvEibF6twEDwDaOuJ44hAES9oahzmux08pG9FGdNwzCnHH3X63QNxDcTXc9et09yESOQ2GR2Y0oh0X0QP9aRnmD8TXSPDNSIz/qs3NyBpqDsFpxadFjlEr8560zseWchlnl00/iYq3KfMeejCMEKVD8wST8AcDQYOkUhJ0o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Jul 11, 2026 at 12:03 AM UTC, Andrew Morton wrote:
> On Fri, 10 Jul 2026 10:42:20 +0000 Brendan Jackman <jackmanb@google.com> =
wrote:
>
>> As noted in can_spin_trylock(), using this is unsafe in this context.
>> commit 620b46ed6ae17 ("mm/page_alloc: return NULL early from
>> alloc_frozen_pages_nolock() in NMI on UP") fixed this on the alloc side
>> but missed the free side.
>>=20
>> Reported-by: sashiko-bot@kernel.org
>> Link: https://sashiko.dev/#/patchset/20260703-alloc-trylock-v5-0-c87b714=
e19d3@google.com
>> Cc: stable@vger.kernel.org
>> Fixes: d7242af86434 ("mm: Introduce alloc_frozen_pages_nolock()")
>
> Is this correct?  I'm not seeing anything in that commit which could
> have caused this?

Oh yeah I guess it should be:

Fixes: 8c57b687e8331 ("mm, bpf: Introduce free_pages_nolock()")

This is confusing coz we have:

A: commit d7242af86434 ("mm: Introduce alloc_frozen_pages_nolock()")
B: commit 8c57b687e8331 ("mm, bpf: Introduce free_pages_nolock()")
...
X: commit 620b46ed6ae17 ("mm/page_alloc: return NULL early from alloc_froze=
n_pages_nolock() in NMI on UP")=20

X is marked as Fixing A, but it was an incomplete fix. I just copy
pasted the Fixes tag. But actually I'm now changing the free path that
was only introduced in B.=20

>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -2979,8 +2979,7 @@ static void __free_frozen_pages(struct page *page,=
 unsigned int order,
>>  		migratetype =3D MIGRATE_MOVABLE;
>>  	}
>> =20
>> -	if (unlikely((fpi_flags & FPI_TRYLOCK) && IS_ENABLED(CONFIG_PREEMPT_RT=
)
>> -		     && (in_nmi() || in_hardirq()))) {
>> +	if (unlikely((fpi_flags & FPI_TRYLOCK) && !can_spin_trylock())) {
>>  		add_page_to_zone_llist(zone, page, order);
>>  		return;
>>  	}
>
> It would be nice to include a description of the userspace impact.  I'm
> suspecting that's "none known", but some speculation on what might
> happen to someone is appropriate.

Ack. I think if you trigger this bug by accident it will probably crash
your machine in extremely confusing ways. If you can trigger it
deliberately from unpriv (depends on the rest of the host setup, e.g.
what tracing is being used) you can probably use it to get root/ring0.
Can mention this in the commit message.

> Also, please let's not combine a cc:stable bugfix with a minor macro
> renaming.  They're very different things and will take quite different
> paths into mainline and -stable kernels.

Ack. I assume by "combine" you mean put them in the same series - let
me know if I misunderstood that. Will separate them for v2.

> Also, Sashiko might have found yet more pre-existing issues:
> 	https://sashiko.dev/#/patchset/20260710-spin-trylock-followup-v1-0-affb5=
fe5ed00@google.com

There are 2 cases here:

1: !pcp_allowed_order() -> This is forbidden by alloc_order_allowed(),
   quite a bad miss from Sashiko IMO. Usually I expect AI to do better
   at spotting this kind of thing, makes me wonder if I'm the dumb one
   here.

2. pageblock is isolated -> Yeah this looks broken to me.=20

