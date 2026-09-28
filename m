Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2564CC98328
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 05:19:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7F6F6B0088; Mon, 28 Sep 2026 01:19:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D09826B008A; Mon, 28 Sep 2026 01:19:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAAA46B008C; Mon, 28 Sep 2026 01:19:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C1EB6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:19:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74E0D140B23
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:19:12 +0000 (UTC)
X-FDA: 85262017344.24.9400B89
Received: from mail-qv2-f43.google.com (mail-qv2-f43.google.com [74.125.230.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 798D4120006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:19:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FfAxSg79;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.171 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790572750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uhC9VdyJZAhlbxrqH3B0Xp+V5ADIoAIUT4+FDcJgkb0=;
	b=TORBmQIG4GYHS2psenCQ8KHrryLlL6XG3huIt4NBIazi0YNf6fKnn8QQinnbGa87eJNhIq
	tl4fFn9mnPu6VzNGrPU+AfVn8OfshEwfixbQqxeyyOmjnR2XSKFLcBzkdNN7/OQghnAiND
	vuJTpB2di1iGvASWadUjxEhZ1QVDmPk=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FfAxSg79;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.171 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790572750;
	b=JuJopomyasV9zrCE1KVuRdBSHfOVmlb+6I6HSu0AlhGet9M38P8hoXgVXh6yfaiRXfxKSO
	MowGUvmUFaQSqAPjgzLnVngtyuMu4W4vkvQlLVLc+QmNfUz386T1NZcFIcmHGBglR70jg3
	k+5TXPvoxT/pW8hTH9S2JxWHawWHImE=
Received: by mail-qv2-f43.google.com with SMTP id 6a1803df08f44-91439d36903so10749316d6.3
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 22:19:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790572749; cv=none;
        d=google.com; s=arc-20260327;
        b=Vg351gg3/kVX6Dr2QSI06FFMq4xlFlLkwmJyKyz017FXc/8YtfeJ4QXAoKNofH2cjV
         jpuz8uooDQylfb8ofjJXxpAXu0gIzZhDf2ILfo6uo9vYH9E9h2XwEM2pPJnuE0DjarHd
         VjeVsXgbiu2mqtlVonG32d1VJMsl9nf6eTM6d/ZS2y7iaHagUdsSotj/CSNbe6CFCnm/
         wrAlr/idMwElvwIXAIT2y+HQ++3E4AK9MRFKUw7b+9F6X3sDTVP1vwzPxh9ROrJqDdRd
         oBPXHquSH7DaRU+ZqCj8PtlkFfcVVgTYeTQWhdXtqQIcEfWWinfuCjd+VA50rUhoZM4X
         2f6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=uhC9VdyJZAhlbxrqH3B0Xp+V5ADIoAIUT4+FDcJgkb0=;
        fh=YRdmMGBO9i2P26QJJxryZxzb71Vmnv/e9/09gZCx1y8=;
        b=F/87y6ccVK4bhQufVap6+vl1kIPQDvTf5zmHjUFi5ergsPs3EAryPP21vhEimuB7zj
         i/UYQ9I27kmubRZncPPuMUaXI6GVnTqbY3hlKMenHlqYxKtRW37WahhfSIy7C5ErjCXi
         X0yX/i/7PFH6FL2t+O/6+SqcAFsn4bCKim76OtCejarXvDVGGfj97pqALJ9StPdgQi/0
         MOXv5Nz09qYYrhkYwF5T0ADAFXQm7jwOQ5Wz+4DMMO/NCnCjISS0sqvY7fscsjSeDzLB
         bcWDMMUDccuwqeH+v82j0Ft5GurncAIkuZeLb2agvMy1ynesJZrmQ8utpMJewvA9E5Mx
         xMLA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790572749; x=1791177549; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uhC9VdyJZAhlbxrqH3B0Xp+V5ADIoAIUT4+FDcJgkb0=;
        b=FfAxSg79jImJNyfXQe+P8R0OerJWcUrCfnVH1GkhsBB98bvdn6ezeDOgEb+kkEMBbN
         vDkyEBFnWn349yPCgOVm2eiOkaRShDKWNov70ZFAlJC/Vqm3oPQ8LbVF/Ss2OZIyvsBC
         YiRFdp5/XJksn/LB30gCuksQ1NDXOkepKoEuAra5G1VVERVxptg3jRUGYkevTBBtUG4y
         d+9IA4HORcjgL4DNYd0G+JNgY0DaUileu31x6JkFrIKG3VNzb9Kk0kfER8vBwr+00cOn
         rDulbMXrnABIQIFvnNLCuMavvMM1Jbuc5Ncnh/kaLPVAtWFzDHvf0Cfd6VUtDoPZyXhh
         xDQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790572749; x=1791177549;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uhC9VdyJZAhlbxrqH3B0Xp+V5ADIoAIUT4+FDcJgkb0=;
        b=ULfa1afyP66H1maxr73clNsIea9lW1d5ByWF7Jl/GRLlH1Fry75+TVMI6tC81UkX9i
         ilwy9QEGYIW22hFs5phSoMc+We5AAQxQ9qwmr3cNuKB5//YXVqmfR5AG2KfYCGj4IHnp
         ucTFqQd2OPbFS7DlzCPf3axH9F7hn6QrbBvMZTTbOX0sbseklSvcawDazhQHERYm9Kg6
         xB1JUzVb2A8+bKvbyaqbs2qYHWnEEyBzYaAaeIGsXyjOMAbUvCf0UzdA65GolwxkdDcL
         s9RqLZt5tqoOVdMLwvl30/XaERVH4ynH4YOI/EFyHqOep+Tvjivn7rmD6gMOB28B7/5o
         7cWQ==
X-Forwarded-Encrypted: i=1; AKwUvBxq3vE5oYac0c8uT9UAe5KtjjvQ8EWH/QfCBYOixq67f92heFtn7bPOcsiYkQXJm9CRb8N9ZRGPvA==@kvack.org
X-Gm-Message-State: AFq9FYKwOGIhFjdxU+HS9WlzLI8Qv1pbFNKd57PziWAAoQCCtQNwOXT/
	0uGkbucMjnp16MSTF/E3kS/NRwW38DYnTIGVXTz/TbDnaeaISQgVO65wzcFQ50OFQd0i+O32jUa
	ViHM/N8+jyPF+1Y2TV7oFURIrjapQ648MwB4JyJ+8
X-Gm-Gg: AYBFou2zRdY1KOqBV0rKn5FJsW1T4MKZAeaiwFeOvSatl5mQSotpsE1xYAIS+v4ycmJ
	06IO0xhEzU2znDHGOkz/MswjwhEF7S37usibxehiSTOUgzQpUpi9CwbBU+Z+xH95mtEIDKQAidn
	HFHpKq8GstnzmjP7Ir7UExt6iqG/VryQqWzDEN9ffZj0Nj/8ylO/abwtq48ng6OZ9+WnmYjIOoU
	Va44uvvujRamLsAsf9M2FkA9sM6AmdylpFfyJKzmFMLmFZYoZBhG+OW2lDb4QkBEcB0xJiWOctv
	QvuCU+RkKHtGks3l5CxNkVll14Wk3KuvFjhJA/7wTMFbogHc6eO9sghb7ovoBfy1d4ZLYEQAvlf
	LERO4UzHNUQ==
X-Received: by 2002:a05:6214:2f89:b0:912:4680:c96f with SMTP id
 6a1803df08f44-9142f6c3868mr213059746d6.3.1790572748944; Sun, 27 Sep 2026
 22:19:08 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 27 Sep 2026 22:19:08 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 27 Sep 2026 22:19:08 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260927170426.2467-1-kmehltretter@gmail.com>
References: <20260916-hugetlb-subpool-always-track-used-v3-0-38aae9b5ccdd@google.com>
 <20260916-hugetlb-subpool-always-track-used-v3-3-38aae9b5ccdd@google.com> <20260927170426.2467-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Date: Sun, 27 Sep 2026 22:19:08 -0700
X-Gm-Features: AclHuK90KfcXyQWpd0DwfKVy3z309tVx_VOzduTxOGd0bveF-6OiNV1sFaSOIFs
Message-ID: <CAEvNRgHQLifmcD1NO6cd7EVcCiQb6gJgNUo4HkFhZAvzuwMq0w@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] mm: hugetlb: Fix subpool usage leak on allocation failure
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Zhao Li <enderaoelyther@gmail.com>, Jinmeng Zhou <zhoujinmeng@bytedance.com>, 
	Alex Shi <alexs@kernel.org>, David Hildenbrand <david@kernel.org>, Dongliang Mu <dzm91@hust.edu.cn>, 
	Hongxiang Lou <louhongxiang@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Michal Hocko <mhocko@kernel.org>, Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Wupeng Ma <mawupeng1@huawei.com>, 
	Yanteng Si <si.yanteng@linux.dev>, Naoya Horiguchi <nao.horiguchi@gmail.com>, fvdl@google.com, 
	jthoughton@google.com, rientjes@google.com, vannapurve@google.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 798D4120006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: u8h7spksofbhgxebpcwyy1szbmy7u3kn
X-HE-Tag: 1790572750-808385
X-HE-Meta: U2FsdGVkX18zXr4jObqU/LUOrfDX6mG0tFGS6v9dP4oyW75ayujfpSP9AExL1KnpzzOKewiBEDKBeaRVFaNj/MFi51UkQP0HqpePT67FE49jECkcZ7OXzTITkLlKzEsRP8EmP6NqrfEF+CchgYkuFuvTPOSYKJDUkS07YqU+qYQ1oEnUXK7P0/kCPX8QMbfQG80teFzjOi5CjJ0Byf753A2VLMns6eJYH3jJnhq9bedljnfrAtvRqeGObH5O++zJK2IglBT10VR4S+4YANfc2ze2N8cigYg6ThZ1nn4A39q0i6VGKvZu1lQk1VaIV6tHAIrHCmmQtPDCYQNenbAZYLXLfSrcvcgjrYJ8dM/RjW3yFZRaCh14M24XDAKAN96rQkXwFGAcj5C5MR093THKMnLrTNv0aE0L9MoqgmjunXvt5JQDcmOW/SN15pNuhtKQMsVU0KKJnjM1fMBweSg1HhJWU7PKKPYhztan3cVJaD7Nj97qLer6slenjLW+6eB7SJrSCusI4nnGqPOksPvnmiRlusTiLcNS20Die2zNiXDBelwRu/YsCUrGpl6a7djR2tQeGPDOmjlH+LZLqrCEdi++eYSzRJ/L9GRQsbLjppPjQX4qmsgoI7Zlg3Vk8LLimTGJMrh1V1FCDhUCyIvJRwnq2V10db+h7vt6zF1Fw5FteUkDcumao9IUiL4bdnwG380Y3NgKjStVDAFAlBWmDymbcEPCz/2/+LuLnk7vp9L2XXEANQqoLrEeqgmyjkoqMIXMiDR3/CKDLHAhpG4HWCHyA0MQZA6dqvGhzGGFxMP3tMLETmwaXxDND/izjdl0xPU6K3ABjXz98QIwlo4XxREUKeFQWJaTOVSCxTjf/TVOUTTS8hpr2J5QLC60heRTKjyrRVdJag6p7EOubcAfT//dJoRq8Pd4rTIDHfh7VdT46FBnfpaeaCVDlzuYCulbsoto4MGiF6ydMfm+ceB
 mAq+yXC+
 l0uYj+ttHsQJQ9g03HKTLNPXnVwhR+k7cWxPosbFRbGdwEfhZk6f08RJhIzaBKfIet5Ksl+8Sh9mRbl57SkrOAvzCGY08wEss9LUueQcRySMbKZkNuqvZPAMIClX+4ZqcP0Tz58zwKM2frF0wvcffhWrhqAfXn7V/WgEw5ribVt6iNdM6vzjw2Rw7PL+cMM0c1oHEomaDpdkCklRQHESGrbwaIsGCE8KiY4Og3qEMeqTQS4/XTyzP88juWQEDfBlrN5fOANkARyDChY8wk6XMDCVgVOauukzUcEd/yB9SeKM1NZm14BaNO5rWa7+1w4hsyLMHAdkQitDS+3tzkP5mo1PiW+tCoxExLpq5nOUVtOnW0m4LLf16Zu8vaRLD5B6lsYAbkemYbCxt+/A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Karl Mehltretter <kmehltretter@gmail.com> writes:

> On Wed, 16 Sep 2026 16:39:03 -0700, Ackerley Tng wrote:
>>  out_subpool_put:
>> +	if (map_chg) {
>> +		long gbl_resv_put = hugepage_subpool_put_pages(spool, 1);
>> +
>> +		hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put);
>>  	}
>
> I reproduced the same fallible-positive-adjustment problem in this
> calculation.
>
> The complete subpool put is locally correct, but it can expose capacity
> which another operation consumes before this call tries to restore the
> corresponding global reservation. A positive hugetlb_acct_memory() can
> then fail with -ENOMEM, and its return value is ignored.
>
> I tested the exact patch prefixes on v7.3-rc3 in x86-64 QEMU with 2 MiB
> huge pages, at both one and four vCPUs. A default-off test hook enforced
> this ordering:
>
> 1. A shared MAP_NORESERVE fault acquires one page from a four-page
>    minimum subpool while the global pool has no spare capacity.
> 2. Folio allocation fails.
> 3. Before rollback, an existing reservation is released and a competing
>    reservation consumes that newly available capacity.
> 4. The subpool put restores the local minimum state, but its required +1
>    global correction fails with -ENOMEM.
>
> Both CPU counts produced the same result:
>
>   Source state  Cleanup result  After file removal / after unmount
>   ------------  --------------  ---------------------------------
>   v7.3-rc3      old cleanup     4 / 0
>   patches 1-2   old local leak  3 / 3
>   patches 1-3   +1, -ENOMEM     3 / ULONG_MAX
>   patches 1-4   +1, -ENOMEM     3 / ULONG_MAX
>
> The expected values are 4 after file removal and 0 after unmount. Patch 3
> removes the local usage leak, but the failed positive correction replaces
> it with globally unbacked subpool reservations and the unmount underflow.
> Patch 4 does not cover this earlier allocation-failure path.
>
> As in the reservation case, the base remains balanced in this controlled
> interleaving. Patch 1 makes the path observable on the minimum-only mount,
> and patch 3 changes the local leak into globally unbacked reservations.
>
> As for 2/4, I think the subpool get must remain provisional until the
> allocation commits or aborts.
>
> A LLM agent helped me with the tests.
>
> Thanks,
> Karl

This is confusing me. Perhaps I've been reading too much LLM output from
myself and from Karl :)


== We have a path forward on top of Zhao and Jinmeng's patches

I tried to integrate Zhao [1] and Jinmeng's [2] patches into a v4 of
this series, and I have path forward for my fixes on top of Zhao and
Jinmeng's patches.

== The path forward requires some small changes to [1/4] of this series

With Zhao and Jinmeng's patches, the necessary subpool tracking is
basically done outside of hugepage_subpool_put_pages() in 2 places
(alloc_hugetlb_folio() and hugetlb_reserve_pages()).

The logic is that patch [1/4] of this series always tracks used_hpages
in the subpool, so I can update those 2 places that Zhao and Jinmeng
updated in alloc_hugetlb_folio() and hugetlb_reserve_pages() to also
always update used_hpages.

I can update those 2 places if we end up going with always tracking
used_hpages in the subpool, which I still believe is a good cleanup.

== But I found more race-related issues

I thought [2/4] and [3/4] of this series would fix all the race-related
issues, but my LLM produced a reproducer that revealed even more
race-related bugs which I don't fully understand.

== Questions for Karl

(Independent of the "Path forward for 7.3/7.4")

1. Does squashing patch [4/4] of this series into [2/4] [3/4] resolve
   any of what you found?
2. Does patch [1/4] introduce new issues, or does it just not fully fix
   all the issues? At this point I think we have so many bugs, it's more
   about fixing bugs progressively (not regressing) than finding a
   complete fix.
3. Would it be ok if you integrate your findings across your two replies
   on [2/4] and [3/4]? They're similar yet slightly different so it's
   kind of confusing. If you have reproducers, it would help to share
   them! :)

== Path forward for 7.3/7.4

Andrew, I think we should merge Zhao and Jinmeng's patches. They
separately fix different issues, not completely, but is good enough of
an improvement given this bigger-than-expected mess.

I want to continue iterating on this series but I'm a little busy over
the next few weeks (LPC) and I don't want to hold things up.

I believe the relative order between those 2 doesn't matter, but I
tested this order: Zhao then Jinmeng. I'll reply to those patches with
Tested-by tags.


Thank you everyone!

