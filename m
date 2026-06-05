Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADCF7CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1F6C6B0005; Fri,  5 Jun 2026 11:24:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECF876B0088; Fri,  5 Jun 2026 11:24:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D98346B0092; Fri,  5 Jun 2026 11:24:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C89E16B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:24:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6CAFC1201B0
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:24:34 +0000 (UTC)
X-FDA: 84846230868.15.6CFDB1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B91EC1C0003
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:24:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ET0Bp7Ru;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780673072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6WIUceB1Gg5EbBPbpbAwJwRlud1MXZ0zZgoj+tHpN2M=;
	b=3hWT0VozWk+RvrqEpeoH6TWTLuA6wk6us3pkLRV4S2q1APwr2DLEYyOb4DAPQzz3viMY6/
	gi3msFRuAN429V2CgNYKDHNcincSxDwr9eeKfq9/FmbspnrUrBXX+ZdFoc9Nv7V4jWiISw
	vSsY0ucXYDk4mY1UFv8FEdz1MfLxlHc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ET0Bp7Ru;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780673072;
	b=HLK/W9E7xZW52vGkfxka1Uzyedko/zSs73CjczPq65ce6TjO8nLH20OI+eC4jsqW73wCxr
	eYmOPyQZADGOYc5ZGpyoEqlNumtp608vKevu7fVVHYsuPFmIWJ15usF3BrMcAV/UZZ4/tX
	aQFsvHnD0V9WbWOCYl5TMhw2gWqFrLI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 26716601DD;
	Fri,  5 Jun 2026 15:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1181F00893;
	Fri,  5 Jun 2026 15:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780673071;
	bh=6WIUceB1Gg5EbBPbpbAwJwRlud1MXZ0zZgoj+tHpN2M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ET0Bp7Ru2saXALBTvHenKSAjFDnDIxNDdQs7PC/vuBGe1HLnsGqSVovoyIN5qYuYx
	 p4YOKF5F7h7gMsQHM5MMyszrYjhrZFFrlMnbUmiuYVVw3HFuf//uVwIc3NOD73V7Ms
	 fPQxzmvSDicDIH6GK7zK2wGyIIbN3gD8tCDXA/qBK73DRHXGfYZmJANd657sf6+nfh
	 NHrYZU7v1CeNqV1HQjkzg9cErBCexFaYn3AOaS+8Ke/f5HnwGJxULHWaN+hVCxRgqu
	 pQEkpDdOwXJ+lVk78vkFlOMFFyIulJPk8yNeEG3cRX/4Sb/d1T+ikvbFrytSc+FJ/Y
	 7RBl5wl5qNpSA==
Message-ID: <2ca2c36d-318a-4668-bce9-3a0387135904@kernel.org>
Date: Fri, 5 Jun 2026 17:24:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
To: SeongJae Park <sj@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Nico Pache <npache@redhat.com>,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 liam@infradead.org, mhocko@suse.com, rppt@kernel.org, vbabka@suse.cz,
 willy@infradead.org
References: <20260603014841.90322-1-sj@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260603014841.90322-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B91EC1C0003
X-Stat-Signature: 7d385b8x66rk9947qwjd4fburxf9oydb
X-Rspam-User: 
X-HE-Tag: 1780673072-428708
X-HE-Meta: U2FsdGVkX1/dZD24IpaaBP/BEt//FG43MNw/xzrRNjiB3OLrXAbW2fbaDJ0dn5gPSeJnrHaDk7wte15inIslz3rxd9nIm86At7atanIeASR420w1xTemMZB7bRphZLLM3Pi9sB7++iz5OqxQr9VgkFaw0unVk+jSxNRaf7lhncyKa6WCmhArD0ouTBTTYVsPEHtybJKjLykS+vXKkmomgKf6ZaPMqnlKD9L0tObVgLoWmHV9m5ZTagyPlIraTixVKNIZxxaK4KJMBSASfJXDk7HgsX5X1hhTkGdY4SD+Z1noXM/JobtyDNPTUe+5cjZ7yXS+Y5ojIXBghGYAObfOs/oNdtE3Gr9ngQlbVIIs5+KakkEXhc5opknTnj6YdDOCxQGL+WOIYAJdQ24b2+Rr+kwWmycGom18Vlo5l6VBTu+bibgLY8GQpFP/1P6cSbXRoJHXTy8VaqoxdQCHPuzw+8sxs2vLM7cHjtLgE2OpNqHYej/vd0w+M1izkUvTjauiHjaBoRsRr3SfcljgTTnfL7OKMmaHDXTPMI3sOVzHDYM1olDb6BppdyQVqD7O6brQN1hssqIbbFv5LvBK2Xz6bYRyjPN2gZI45PKWX8WPyNy9WbdKNusGoe4zg3PN2n78wjFMseQ0jFOHxaX/Hy+La4I17zvyX+5QiuC/mpNfaV3juXKnwUe18MXVlqlJPk/2VfAWC+JmMIjFch9gHYE0K82xGfopJl6f3PA85v48vYZ02wqP4vK16MHoEZ8JKh0YlgAJIzFL0Ttt3nFPMz7blBPPtkdn1sI5bA+VbHi8dec2oc1Clln53oBkhTF63sbVu3VVKWqG/Wr1Bf4ehyHaU73x4rhSco4qLcObSZ8rM4UYSheWD2ypDfa05va9WlOzknAbQZSCwGgj+AbcgjDPAB18C5OPFGng4rG3vdY1b798FIwXhgZdODbQdgMfG2PT1EmdLAoTCQ1Ftbf1eox
 HUfeBknp
 TfgSQLwGcsIfI+8KU+8OJFPVIaTtoQdwmmfwogKTUiiczAXAVRlqpWyzD6EXWE8/P2G58RjSf0ly+lAIIxoJNGyI7sbcYI95BKQPvhtfdg22cL9xOmTtBup4YmdXN7q640Skbyid80KDk+3fFBzXeMm/fLcALBLg4pUzjCiQCplNsM6Ad7SudidR1mwvbjS5bGqz2XUVACX7eWKkio76HibQFs5tB9gcnCheR6x6RHD0X/Ux2OZ6uAycSsxMErNOODHtHh+9ITtCVKU+Fn/xewDEoAeRCkdUzNbl7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/3/26 03:48, SeongJae Park wrote:
> On Tue, 2 Jun 2026 15:16:27 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> On 6/2/26 15:08, Vlastimil Babka (SUSE) wrote:
>>>
>>> Well, as longs as there are no conflicts, it probably doesn't.
>>
>> Yes.
>>
>>>
>>>
>>> Note slab-next itself might be a collection of topic branches and it might
>>> be more flexible to create another topic branch (based on rc1) and merge it,
>>> than apply stuff on top of a product of merging.
>>
>> Right, and I assume that the maintainer would then either try to fix it up
>> himself, or ask the submitter to base against a specific branch. (e.g., against
>> another topic branch etc).
> 
> So I understand we agree we will allow peoplee to base their patches on
> whatever makes sense.  I like this flexibility.  The slight difference I show
> is that David suggests to use mm-next as the default baseline, and later rebase
> on subcomponent tree if needed.  Meanwhile, some subcomponent maintainers think
> the opposite direction make sense.  Submitter use the appropriate subcomponent
> maintainer-suggested tree as the default, and the submaintainers handle merge
> conflicts of their for-mm-next branch.

I assume, in practice, that people will do what they want either way (base on
Linus tree, linux-next etc), and it will be our job to see if it cleanly
applies, or ask for a proper resend.

I guess, as a first step, we'll document something similar to what TIP documents
in that regard.

> 
> I think both could work, and we will learn from trying.
> 
> But from a subcomponent maintainer's persepctive, I was thnking our process
> will be more like the second approach.  And I still slightly feeling that will
> be simpler for at least a subcomponent maintainer.  Why I feel so is like
> below.
> 
> In the first approach, as Vlastimil and David described already, there are
> chances of conflicts at picking mm-next based submitter's patch on subcomponent
> tree.  How frequenct and complex the conflicts will be is questionable.  But it
> feels like I will have to deal it with submitters.  E.g., asking rebase to
> submitters, like David mentioned.  I think some of submitters might not very
> familiar with git and the mm process, so I feel it might be not very simple
> always.
> 
> In the second appraoch, I expect less chances of conflicts when picking
> submitter patches on subcomponent trees.  The subcomponent maintainer will
> still get conflicts with mm-next and have to fix it.  But in this case, the
> subcomponent maintainer will be able to do that nearly alone.  Or, they will
> work with the mm-next maintainer and/or other subcomponent maintainers.  I
> pretty suree the other maintainers will be familiar with git and the process.
> So I expect less headaches.  Also, this kind of conflict resolving between
> subcomponent maintainer and mm-next trees is samely required for the first
> approach, anyway.

I'm sure we'll figure out how bad one approach or the other is as we move
forward, we can always adjust that. Conflicts will haunt us :)

But I assume, independent of what we document, we will always have people that
submit to arbitrary trees, and it will be out job to make sense of it (or ask to
resend).

Documentation is good, as long as people read it ...

> 
> mm-next maintainer's perspective might see many different things, though.  I
> will be more than glad to be learn what I'm missing and get enlightened.
> 
> Anyway I think both approaches may work, and we can learn from others and
> trying on our own.  I will be happy to help when there is something that I can
> help. :)

That's the right spirit! :)

We'll discuss this topic in more detail as we move forward!

-- 
Cheers,

David

