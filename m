Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68F65EDEBFC
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 01:08:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 772B76B0088; Tue,  3 Mar 2026 20:08:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71FF96B0089; Tue,  3 Mar 2026 20:08:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601E56B008A; Tue,  3 Mar 2026 20:08:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4922E6B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:08:34 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D64DA1A0369
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:08:33 +0000 (UTC)
X-FDA: 84506595306.11.946C40A
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id CAF42100011
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:08:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LgAF1pNq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772586512;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=90j8x42X7s075F4Kb7j/ju7Nz6t7T+bBhLBoYSSvU/w=;
	b=PM5mMEkmm/e9ElsO1/nbfzbXmN46f2uGuq3ucg0S/fuR0qU9h+YE2EiKl5oiL4mijatj5M
	lWNI9MQ1G2bGZmjT3oIC9gAVuxuTKpFi/g2ljchfF7onZQ/lwFvpM7mdOIpdhfzkSh5eS+
	0C2ZL7P/AezLsZohGfnIC9Wiab8lKWE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LgAF1pNq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772586512; a=rsa-sha256;
	cv=none;
	b=2de9GwxIqKAWDc0pAR0dDzo5l5sqkuJCBKDitgTWgoafuU0Kv+7hZ7yYMA/QKqlzgQJ296
	6iPFVVacGzy7Aw2juw4iUGJkcBaVueblR4M1QEJke0N8+yGjiEdC7TByMdLsLxdNYUkNxZ
	6cfobWlJzo1+AEeoOWzlJFVJR0SzcNc=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-65be78011c8so8623927a12.3
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 17:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772586510; x=1773191310; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=90j8x42X7s075F4Kb7j/ju7Nz6t7T+bBhLBoYSSvU/w=;
        b=LgAF1pNqrogRgWne3yC10fJpR9hDnrBuxkkeNU6vc8BUNyk73IJ9jwDEoY3A8aJ6lJ
         FH+w2hs3MGtFTND0kwGVcgOXqMIm8+RkMMYqXVjyfNiQVRPfMcFJ3lv6o6AG34oP7xU1
         OInsCOoS1iKQ5MrdcwS7UDLPvZRdt9WYBretIOSAj8Y0oZbEFTSU/iB22dmQ1n0G/Znc
         hB0u5UFZLoObIMQxryZIF+UBaZ0E1iVNaI/Gs9NIagbhQYWXKH91cQSkOYPrwLjllKBL
         5sTG0+8Zzbe9LIqts0pMiOdaQI9JEk3CY7taEMxKs8HgmKMiAyWQD+J8V6kalgPGXukQ
         9L+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772586510; x=1773191310;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=90j8x42X7s075F4Kb7j/ju7Nz6t7T+bBhLBoYSSvU/w=;
        b=lWIfNWVa0936/RuST4T4quf8NQ2yedTfELTc2/MAYATW0sp6QM3OwZrASQ8tZ52s9L
         Uc9zMfjq7q3Nhbm6c//wBjE26s+Nd68OJFOE+2V3BRy6yjkG3SW2H+Q65AwwFUnPTE6/
         hHEdiUgUrKyKLLA4QeqPEI5cPKVkj7vPHefIba+tpW+isnDSB7Ix6r0cyh9YsGAA6xX0
         hkjDMob9sKxo+hOtXKS9xfAW1EHE3Fov2YUXsU82i5IcMYydfT3G4RRY93HWsgM3kjE1
         jY1u2PC7VHzQlvyMUqU7If4ZotxOhyEBo+aMuWYUbV+zNHkuKcL+IrsVZPZEQKq9BEQI
         sMVw==
X-Forwarded-Encrypted: i=1; AJvYcCVdnzkj/lFglSdbdSRu1P4C4u6Ep5CN5CnKuatJkyrT70o9R4kc1uXGTaA7hyJI+qCm1LvXiuCBsQ==@kvack.org
X-Gm-Message-State: AOJu0YwWHYDRwjBELJFTdcTC4R2+lohce0r/vPybVoj/EY1f/Jkvjroq
	8jESIh2aERa/f5KPN5u/jBeYsSd7h9haHPVdahTGb7dWiYMe3sIl6NPb
X-Gm-Gg: ATEYQzxhZa15aJLS7QzFrvEEvyq0jmlqyzZklQ/WGhkPcb0ev/dCrkyntUTqax600IO
	50whANA2aYuNr+TkMPpOMmP9AvZv5cllOQySW5kkuuWpr4AuNYljXKawPDupKP67J1tYKgH2yRc
	8e+trZ7Me/W525Rh6Hqwzq7/Q2xytDF4mzM2zWtm4GDrhfNuYqfOdxRwuz4jUEtzMuEdnPBAiei
	N+hpogqMFzmVo3WQAv94tHQBq5VcUZFEzoARlNdtrS6UfAtZfTRefGH+KRxyuFT2h5hBpyhKQFl
	JpLTr+u91IgT1fdQvbDzAL2Z22tSuAwZJE03m0K0It2uqwGWAGAPZKdzf9Tg18+Rr2GfsI5Sr4u
	TOFjvLmS3BE8LrPIiNu1o8Z5kh60O9ddH2YOlvZ2lWmIt5N3imkZ2L4bUm/Edq3Nb826+dfsofe
	OGyudjGRSeL3Im5AAmZqMLyw==
X-Received: by 2002:a05:6402:2354:b0:659:38ea:c4e3 with SMTP id 4fb4d7f45d1cf-660f00cf1damr80946a12.25.1772586509688;
        Tue, 03 Mar 2026 17:08:29 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-660e793b7d4sm168504a12.7.2026.03.03.17.08.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 03 Mar 2026 17:08:29 -0800 (PST)
Date: Wed, 4 Mar 2026 01:08:28 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, riel@surriel.com, Liam.Howlett@oracle.com,
	vbabka@suse.cz, harry.yoo@oracle.com, jannh@google.com,
	gavinguo@igalia.com, baolin.wang@linux.alibaba.com, ziy@nvidia.com,
	linux-mm@kvack.org, Lance Yang <lance.yang@linux.dev>,
	stable@vger.kernel.org
Subject: Re: [Patch v3] mm/huge_memory: fix early failure try_to_migrate()
 when split huge pmd for shared thp
Message-ID: <20260304010828.ulp5i3v2drwhzytc@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260205033113.30724-1-richard.weiyang@gmail.com>
 <fbd6c31f-7f35-4986-86e3-76bf8963433d@lucifer.local>
 <20260210032304.j4k5izweewouabqb@master>
 <20260213132027.wm75sh6trz7n24kd@master>
 <c820d6a1-4283-46a5-a639-04f6849e4e73@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c820d6a1-4283-46a5-a639-04f6849e4e73@lucifer.local>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CAF42100011
X-Stat-Signature: rna4x9fuqirzinkz9r3b9hj8tmqrrqzs
X-Rspam-User: 
X-HE-Tag: 1772586511-418593
X-HE-Meta: U2FsdGVkX1+QIlegaXaRNyVpJFWzoU6KEmQziFDV85k06d4PePPLqPkfEjSvy4iAQM3oZZ8AHIDKVTmG/ezAGT3OA2PXnarcYYAo36QWVSJfxLL3rJ2hXNO6vcJMI0Hk9T80Hx0Rkq//prkA+4RwsdJbS0yMEU95dZJPl764FsMOaIkEfYk1//3lHadVNdHF6yntKiT7TvxAoNeAFfh2Kmis1d2WNLVdA1ueVbtzOPIWXfIGIy515eB+GDmRfgc33cNSbpC1VmpfWDH0ONJd7mpna5PjHKkgupnvYONM8z6IYf/jtt6AwGE3XAgqjZkHIUoUMuzbBsUiCqjCzZKb8FczC6rHkJAqt8Z5bIZFVM/pIR+rb3QicRIDyLr5iUMI+wQo6lX+fJgBODSwUxTObjm2T2khHYPvMlLoTsj1QveHs+TeGChi4lQpD9YqzQ+5V0t4/8shsx81/NNTmtEAzx7xXVoOaiKbCy5Mu00nGc0AKdW0IZxroIu5Nk0EVRU2u5yaPC64wxaWb7wnQbMMT07WQodY6Ha6qfPeyIzA2SSoGbMZ9OPT1av85zKU3u540hkvA33Qw7YXEGvJAhqdhd2KmY+p50WzQIzW/5RSC3/W5GxM4nN8sdRGwqnol6tARMUyg8NmSdFdYe4izsZ7g9G8R94zGZBUPx0FfpDkHzEJ+cVjzVV5OUKY24kuS1JQ6kSI1GGLtPlBohxrerGmAQ5KBp9WKczZNbJwhf9lagZP7s7aIq4WEN7GX0V+QO4t3S1dz3+wtxulO/DREt7D4xCAJjU+igv77As7+ZyrTj4q5HrqnaUkofi5gGzfsaqIP6w/TnnpyVtGcCgylFfmGUmEQ3qBLipUtnYK8QFOUVb4qk8Yo0BwawmmDre8NtX9mvaXPvMCvaUK/grGTX+s2VqF/k+2R40+pLPo1OK+PjIx2GLe1kbzifQnx2ilMNDU/7K7LnxWWy6MxuDfsvF
 +XcLUa0p
 MWjAdfXzZP003CZpVwh6eQ2xjEG6Bzw9D1ncJZRlREzdifrQ6uZ9R2fvF7NJDnw01eWEKvhGgzQlueLl57FUlmRMbvX0Or6xqURJkABej2V+rSszvzeZ62ANGZZiyAz54RZ+K4JhCM8rTbg++4YhScPgsZtGMslY5+rh+AzSmEMNeERwt3kMJ44APYYgP3nW5fCFouSu+5e/CZRQhQ9B3YtHCsBEWJn22nT62e/Tde53IXdcX7K9rhL1XDD3GSpZsjirXEXNJsL0KOg2xjmLFPbwao52RVh0YZz3YKkO3cSNA3m7v+wWLRE8We37BYYisiaDIVssuIAZ0QhTu01gclDFHSk/DEVI6btGCWvA8M/eGGfU2t9Gli8QvQe3gi82JfqHdcFzuWxvKIt1Ej/a5EdwLIunaA+RN00Ibs8eNv5qgmOrhuBIdJYf2rjIeAWVjbHUA47g6/+ZR2Y4VnPZTRB4coU2PryZ55keG4CZT1fB6OYcH29CymHit2E3++F/QsUgJC8HsdKCM//Ti7/dqlWUp4PRgR4aUhrghuicwUIhWOFCQgX5Ci+xdIqRpauO6loEjH/PETmnipL15iaWlSQSJknWc3tLtl9Wt7D7nOU6vAxEC8UqRzPZmkcR03HaYoLct+LSUAcvMvy7Q7YxZ08hlNi1yJlZy96UWhJy275bGKZxE5JTn6waDzyDBl12F2i0xQLmUfl2EF6RZ/8CTDQxM51Htvz7mzE593lFO/rrzYu6kNQs66XcSJ3N8SxQrVagCmZaZIOHg1STBpzGFIOK0FeXle7rKL81gZ/5wt7n0Q9SK9p251WluWn2pLkJwV07JCw/aRMZ7xTh2N4SUyyDQXG/7QF8AmZHH1xeSewmEC+jwmdgHOeZr70frEKL6k8nstp0zMNJxRUFqgS4Obo0DV/wY4XPV5OcQe7KAwSg9vfKPsQNVpO6nxQLnDqhyjqh/1xEoGWHqJ+S1jcPPSitE66tK
 IOCCZCHu
 MITutLM+XeY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 10:12:35AM +0000, Lorenzo Stoakes wrote:
>On Fri, Feb 13, 2026 at 01:20:27PM +0000, Wei Yang wrote:
>> On Tue, Feb 10, 2026 at 03:23:04AM +0000, Wei Yang wrote:
>> >On Mon, Feb 09, 2026 at 05:08:16PM +0000, Lorenzo Stoakes wrote:
>> >>On Thu, Feb 05, 2026 at 03:31:13AM +0000, Wei Yang wrote:
>> >>> Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
>> >>> split_huge_pmd_locked()") return false unconditionally after
>> >>> split_huge_pmd_locked() which may fail early during try_to_migrate() for
>> >>> shared thp. This will lead to unexpected folio split failure.
>> >>
>> >>I think this could be put more clearly. 'When splitting a PMD THP migration
>> >>entry in try_to_migrate_one() in a rmap walk invoked by try_to_migrate() when
>> >
>> >split_huge_pmd_locked() could split a PMD THP migration entry, but here we
>> >expect a PMD THP normal entry.
>> >
>> >>TTU_SPLIT_HUGE_PMD is specified.' or something like that.
>> >>
>> >>>
>> >>> One way to reproduce:
>> >>>
>> >>>     Create an anonymous thp range and fork 512 children, so we have a
>> >>>     thp shared mapped in 513 processes. Then trigger folio split with
>> >>>     /sys/kernel/debug/split_huge_pages debugfs to split the thp folio to
>> >>>     order 0.
>> >>
>> >>I think you should explain the issue before the repro. This is just confusing
>> >>things. Mention the repro _afterwards_.
>> >>
>> >
>> >OK, will move afterwards.
>> >
>> >>>
>> >>> Without the above commit, we can successfully split to order 0.
>> >>> With the above commit, the folio is still a large folio.
>> >>>
>> >>> The reason is the above commit return false after split pmd
>> >>
>> >>This sentence doesn't really make sense. Returns false where? And under what
>> >>circumstances?
>> >>
>> >>I'm having to look through 60fbb14396d5 to understand this which isn't a good
>> >>sign.
>> >>
>> >>'This patch adjusted try_to_migrate_one() to, when a PMD-mapped THP migration
>> >
>> >I am afraid the original intention of commit 60fbb14396d5 is not just for
>> >migration entry.
>> >
>> >>entry is found, and TTU_SPLIT_HUGE_PMD is specified (for example, via
>> >>unmap_folio()), exit the walk and return false unconditionally'.
>> >>
>> >>> unconditionally in the first process and break try_to_migrate().
>> >>>
>> >>> On memory pressure or failure, we would try to reclaim unused memory or
>> >>> limit bad memory after folio split. If failed to split it, we will leave
>> >>
>> >>Limit bad memory? What does that mean? Also should be If '_we_' or '_it_' or
>> >>something like that.
>> >>
>> >
>> >What I want to mean is in memory_failure() we use try_to_split_thp_page() and
>> >the PG_has_hwpoisoned bit is only set in the after-split folio contains
>> >@split_at.
>
>I mean is this the case you're asserting in your repro or is it the only one in
>which the issue can arise?
>
>You should make this clear with reference to the actual functions where this
>happens in the commit msg.
>
>> >
>> >>> some more memory unusable than expected.
>> >>
>> >>'We will leave some more memory unusable than expected' is super unclear.
>> >>
>> >>You mean we will fail to migrate THP entries at the PTE level?
>> >>
>> >
>> >No.
>> >
>> >Hmm... I would like to clarify before continue.
>> >
>> >This fix is not to fix migration case. This is to fix folio split for a shared
>> >mapped PMD THP. Current folio split leverage migration entry during split
>> >anonymous folio. So the action here is not to migrate it.
>> >
>> >I am a little lost here.
>> >
>> >>Can we say this instead please?
>> >>
>>
>> Hi, Lorenzo
>>
>> I am not sure understand you correctly. If not, please let me know.
>>
>> >>>
>> >>> The tricky thing in above reproduce method is current debugfs interface
>> >>> leverage function split_huge_pages_pid(), which will iterate the whole
>> >>> pmd range and do folio split on each base page address. This means it
>> >>> will try 512 times, and each time split one pmd from pmd mapped to pte
>> >>> mapped thp. If there are less than 512 shared mapped process,
>> >>> the folio is still split successfully at last. But in real world, we
>> >>> usually try it for once.
>> >>
>> >>This whole sentence could be dropped I think I don't think it adds anything.
>> >>
>> >>And you're really confusing the issue by dwelling on this I think.
>> >>
>>
>> It is intended to explain why the reproduce method should fork 512 child. In
>> case it is not helpful, I will drop it.
>
>Yeah it's not too helpful I don't think. You could say 'forking many children'
>or something.
>
>>
>> >>You need to restart the walk in this case in order for the PTEs to be correctly
>> >>handled right?
>> >>
>> >>Can you explain why we can't just essentially revert 60fbb14396d5? Or at least
>> >>the bit that did this change?
>>
>> Commit 60fbb14396d5 removed some duplicated check covered by
>> page_vma_mapped_walk(), so just reverting it may not good?
>>
>> You mean a sentence like above is preferred in commit msg?
>
>I mean you need to explain why you're not just reverting it, saying why in
>the commit msg would be helpful yes, thanks!
>
>>
>> >>
>> >>Also is unmap_folio() the only caller with TTU_SPLIT_HUGE_PMD as the comment
>> >>that was deleted by 60fbb14396d5 implied? Or are there others? If it is, please
>> >>mention the commit msg.
>> >>
>>
>> Currently there are two core users of TTU_SPLIT_HUGE_PMD:
>>
>>   * try_to_unmap_one()
>>   * try_to_migrate_one()
>>
>> And another two indirect user by calling try_to_unmap():
>>
>>   * try_folio_split_or_unmap()
>>   * shrink_folio_list()
>>
>> try_to_unmap_one() doesn't fail early, so only try_to_migrate_one() is
>> affected.
>>
>> So you prefer some description like above to be added in commit msg?
>
>Yes please! Thanks.
>
>>
>> >>
>> >>>
>> >>> This patch fixes this by restart page_vma_mapped_walk() after
>> >>> split_huge_pmd_locked(). We cannot simply return "true" to fix the
>> >>> problem, as that would affect another case:
>> >>
>> >>I mean how would it fix the problem to incorrectly have it return true when the
>> >>walk had not in fact completed?
>> >>
>> >>I'm not sure why you're dwelling on this idea in the commit msg?
>> >>
>> >>> split_huge_pmd_locked()->folio_try_share_anon_rmap_pmd() can failed and
>> >>> leave the folio mapped through PTEs; we would return "true" from
>> >>> try_to_migrate_one() in that case as well. While that is mostly
>> >>> harmless, we could end up walking the rmap, wasting some cycles.
>> >>
>> >>I mean I think we can just drop this whole paragraph no?
>> >>
>>
>> I had an original explanation in [1], which is not clear.
>> Then David proposed this version in [2], which looks good to me. So I took it
>> in v3.
>>
>> If this is not necessary, I am ok to drop it.
>
>Hmm :P well I don't want to contradict David, his suggestions are usually
>excellent, but I think that paragraph needs rework at the very least. It's
>useful to mention functions explicitly, I think something like:
>
>'when invoking folio_try_share_anon_rmap_pmd() from split_huge_pmd_locked(), the
>latter can fail and leave a large folio mapped using PTEs, in which case we
>ought to return true from try_to_migrate_one(). This might result in unnecesary
>walking of the rmap but is relatively harmless'
>
>Might work better?
>

Hi, Lorenzo

Thanks for your reply.  Since there are several suggestions scattered in
several mails, I would like to consolidate all of them here.

Below is the updated version of commit msg with change marked. If I miss or
misunderstand your point, please let me know.


Subject: [PATCH] mm/huge_memory: fix early failure try_to_migrate() when split
 huge pmd for shared THP

Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and          <--- simplify a little and 
split_huge_pmd_locked()") return false unconditionally after                        put reasoning in next paragraph
split_huge_pmd_locked(). This may fail try_to_migrate() early when
TTU_SPLIT_HUGE_PMD is specified.

The reason is the above commit adjusted try_to_migrate_one() to, when a        <--- specify the function affected
PMD-mapped THP entry is found, and TTU_SPLIT_HUGE_PMD is specified (for             try explain reason clearly
example, via unmap_folio()), return false unconditionally. This breaks the
rmap walk and fail try_to_migrate() early, if this PMD-mapped THP is mapped in
multiple processes.

The user sensible impact of this bug could be:                                 <--- more detail on the user sensible impact

  * On memory pressure, shrink_folio_list() may split partially mapped folio
    with split_folio_to_list(). Then free unmapped pages without IO. If
    failed, it may not be reclaimed.
  * On memory failure, memory_failure() would call try_to_split_thp_page()
    to split folio contains the bad page. If succeed, the PG_has_hwpoisoned
    bit is only set in the after-split folio contains @split_at. By doing
    so, we limit bad memory. If failed to split, the whole folios is not
    usable.

One way to reproduce:                                                          <--- move repo after reasoning
                                                                                    remove explanation on tricky number
                                                                         
    Create an anonymous THP range and fork 512 children, so we have a
    THP shared mapped in 513 processes. Then trigger folio split with
    /sys/kernel/debug/split_huge_pages debugfs to split the THP folio to
    order 0.

Without the above commit, we can successfully split to order 0.
With the above commit, the folio is still a large folio.

And currently there are two core users of TTU_SPLIT_HUGE_PMD:                  <--- only try_to_migrate_one() affected

  * try_to_unmap_one()
  * try_to_migrate_one()

try_to_unmap_one() would restart the rmap walk, so only try_to_migrate_one()
is affected.

We can't simply revert commit 60fbb14396d5 ("mm/huge_memory: adjust            <--- why not just revert it
try_to_migrate_one() and split_huge_pmd_locked()"), since it removed some
duplicated check covered by page_vma_mapped_walk().

This patch fixes this by restart page_vma_mapped_walk() after
split_huge_pmd_locked(). Since we cannot simply return "true" to fix the
problem, as that would affect another case:

    When invoking folio_try_share_anon_rmap_pmd() from                         <--- rephrase the explanation
    split_huge_pmd_locked(), the latter can fail and leave a large folio            on not return "true"
    mapped through PTEs, in which case we ought to return true from
    try_to_migrate_one(). This might result in unnecessary walking of the rmap
    but is relatively harmless.

Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Gavin Guo <gavinguo@igalia.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Cc: Gavin Guo <gavinguo@igalia.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: <stable@vger.kernel.org>

---
v4:
  * only commit msg adjustment
    - rephrase the reason analysis
    - move reproduce method afterward
    - more explanation on user sensible effect of the bug, especially expand
      what "Limit bad page" means
    - remove the explanation on whey it need to fork 512 child for reproduce
    - explain why simply revert commit 60fbb14396d5 is not taken
    - mention TTU_SPLIT_HUGE_PMD users and confirm not affect others
    - rephrase the reason why can't simply return true
v3:
  * gather RB
  * adjust the commit log and comment per David
  * add userspace-visible runtime effect in change log
v2:
  * restart page_vma_mapped_walk() after split_huge_pmd_locked()
---
 mm/rmap.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index beb423f3e8ec..e609dd5b382f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2444,11 +2444,17 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			__maybe_unused pmd_t pmdval;
 
 			if (flags & TTU_SPLIT_HUGE_PMD) {
+				/*
+				 * split_huge_pmd_locked() might leave the
+				 * folio mapped through PTEs. Retry the walk
+				 * so we can detect this scenario and properly
+				 * abort the walk.
+				 */
 				split_huge_pmd_locked(vma, pvmw.address,
 						      pvmw.pmd, true);
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+				flags &= ~TTU_SPLIT_HUGE_PMD;
+				page_vma_mapped_walk_restart(&pvmw);
+				continue;
 			}
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 			pmdval = pmdp_get(pvmw.pmd);
-- 
2.34.1


-- 
Wei Yang
Help you, Help me

