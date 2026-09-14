Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E58AC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:27:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DAEA6B0092; Mon, 14 Sep 2026 11:27:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68B7C6B0099; Mon, 14 Sep 2026 11:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57C796B009B; Mon, 14 Sep 2026 11:27:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2816B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:27:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD7831C0DAF
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:27:05 +0000 (UTC)
X-FDA: 85212746010.12.A77EB36
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id BAFF2A000C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:27:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rSJMfoVs;
	spf=pass (imf25.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789399623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mcn1aLlH7H+x4GqfxFrf2tZYu3mAVZpDuMSayy1t56g=;
	b=QpxLa5709wNNLaTS6mAYCrrDqEeP14CUHPL+KP4Fbx5u9zmN1iAEVjHjTMMQxKsVHdmkBw
	rEeDMJaSiy56cmuAlCLeqWPmner+s3FwBSpK/0OEIe+t6Iagbl37iCURTZwu4Z5Fh1GRzx
	pNnU/nZJauaeDFYbK3rekv2uvxdvVlY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789399623;
	b=D036FioapSO1oPC9QA4Zvw1iC03yuPqoyslbhgU+aeS8E+MYcUXFGs8HX86Cb1tJ3cloD4
	nxCvBT8PO71cpNn/vWDB23tU8EFwXkeh8j4WDTmX5KAIMexX6Y7k7MqEkyoeZma94E1vV+
	z0303HzYY7fi8p04+A9T0Cpy4QMXOKs=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rSJMfoVs;
	spf=pass (imf25.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-90e7c71f86eso27127836d6.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:27:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789399623; cv=none;
        d=google.com; s=arc-20260327;
        b=f2W8uzWn4H7zltGwhs94CWl32wR6NyAkskfsc5y8qfbr2MPRs6HIRwl24JVWJVUVac
         F92MlfzxJjm9U6v3M1AGvNXI3w+F8nTpLSQYhsosPLrirKqtexQgEivjs4i4tb68SMZk
         7TV2XF3I2kDxXXF9OugkFUGK5lLmYxHjIFK/N1DYeUMjgrwuHOZzS6UMwh3+8vxiLey8
         46jx4ARRKGjnvPO7pEkzJRjl/96vgbD04mu1MEX4y7PZcarSceDEoZc6cJacMhZNohr9
         hVThf8lBmgUe6ZiP34fLRv0Z9hzv+iLvHzJHTZu89s0FF3k2JsqE6jAymD1BHmDRvmRI
         LyQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=Mcn1aLlH7H+x4GqfxFrf2tZYu3mAVZpDuMSayy1t56g=;
        fh=ieUYQVywv0i3L/fBlXe3FBKQEz4q9TXlkdZKNGjIt1o=;
        b=SLRihRH/iQ58UXvHvbZ7atutvf17S3n1/c38/x1hQw5EtcJ694BHQPYn3U/0zl/olM
         wx1K3YdHO850F5iRTVaxYQtlRRlk8zJTTUnrgg5VEvY0Qvx8P5ybNo9JrNhYJ4j+sAWh
         6zKFFzhl6BAVn7vmIowiQZ0KnAkTGy21qeUyak+KKizyjF6z6OQceKY4iJgXa0JXduzp
         52QzezpDIaLCb/z+3NYUxKuad2Sb0MkMY7hKRHv7qhnT3ue6caDZGYa61RT2KQwwO3jG
         vvUH1ARFDCqJp+BXNn91CbdDvOtoeA8uNl/5BF//U5h9HMmV75r8EJFosAYyNTox6QLP
         jjow==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789399623; x=1790004423; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Mcn1aLlH7H+x4GqfxFrf2tZYu3mAVZpDuMSayy1t56g=;
        b=rSJMfoVsZVoUlcPnjGGPX1JkVi1vqBKHu0kVlmWMGOCJBdrIi/7HoWQULJgJrpqvUT
         uCoVuTVCth3hgTP05Mzhecm3MtHJltDwWKEWfaFpKTqnqDZZpD4tvF8jMQ7Sz1USwtzC
         Ku/CajyKi7CnX+07GrzgjdtlgMih9PkmxKlglzEuQ0Cp9fRUilsr2qe/vFrUGS4rzeHg
         Kigd9OEk4VHuBAcrKPER0gamsyhM7KG9hEMhmgqiIVZATRAO8lcJ5wMQY3Rfr9ANdxvR
         +Pn/jrcp6otWXfc52vBLSuMkJajtYsEPUZX58koEMHjE9yTBOUKe6/DEW/jv5b/CNIzH
         tYJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789399623; x=1790004423;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mcn1aLlH7H+x4GqfxFrf2tZYu3mAVZpDuMSayy1t56g=;
        b=nQ3UpzhGCOKwxhQ/PqU+O7qNZzic0Ejjkl5BpdQOqR9a+BGCoLDPQcAZMQ1dD3Ceeh
         8ZRp5xnBCzu8P8G0I6xVh5IPyYDuwszIHxaacQIOO+f3r2xOavak6XuHkhgVOIYxyIaR
         aZBQXT492+t8bJYx/HlhHlwGYMMJ/j3TE2daQT1OSOqZxqMdDagh+d7BzVMnuZFH/nfa
         XJDb8+hk8c6EgIXlxe50GIDfutWEUrp7RIyem5Kbc7FWS7dCTIFIGc9JBGCuBKC/53nG
         P2yJCyxPxpWLSfX40q+mV34Otqy5RYE3aCCbvoHkNarzYqXKPutC3p3lyfKizyaQFFVL
         mWeA==
X-Forwarded-Encrypted: i=1; AKwUvBy9NO5QgMxleXs6pf+K4jAaL3muTYD4DlhD/vsrb8cwj92vMOYX9JvzlaeRMY4G2siwR49XX/X4Aw==@kvack.org
X-Gm-Message-State: AFuF++muWWHeLp3+DYDse3argc/peKRJagU8j0qWpXr27j8kIC+6zSk7
	901k30ppGZ86uZf3RGi0WwnDuxtqC9NZ0TMbHWWWqDWTOSFNAeCJhxcxv3fhsRaRisWYMzaRJnq
	smdNjsc8sXlpnByOw7HgxUEjaXfD/+TRJY5Ue3o+D
X-Gm-Gg: AYBFou2GEDZEW8DU58PBpdINCX+xb6JbNGnM9btIDqsVWegDaZpdRIvZA4R+SPGYUHv
	vf8qhT5qKOZ8IlnJcWMI+7dSNP9Za3CNasil6qt9eYsrAW0+/F04INXB+ToOYqzYwUc7wMCI5JQ
	FVVP/6+YtFRfSYtqLZ12Inq9LGQShDn6DuJgLRFVe3USD7qrtSuwmFHgpVYWhs1GpEM5grDFVvA
	mg+VxY4ByfyE0iQj9hOvQous69r5jgSKFCocc6pKjigIbXHGYx6pYrQ8+6nZsDdu5Y8wMLvQbra
	75tIe8lFTir1hEAxAHJrwv1yRa5YQJ90lbueL5tzptBHg8a77TJakbqgIBxIlZb78Gu7hF5WCwe
	hl7Y+XygMCw==
X-Received: by 2002:a05:6214:451a:b0:90e:9665:71b9 with SMTP id
 6a1803df08f44-9122e65b41emr46757376d6.27.1789399617103; Mon, 14 Sep 2026
 08:26:57 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 14 Sep 2026 08:26:56 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 14 Sep 2026 08:26:56 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260910195800.3459455-1-joshua.hahnjy@gmail.com>
References: <20260910195800.3459455-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Date: Mon, 14 Sep 2026 08:26:56 -0700
X-Gm-Features: AcwNN1WXsa-zr5yhxjh8RtbW6G0xYf0DGleOaP88Iype7y1bZYBjUUrEH2Yb5dI
Message-ID: <CAEvNRgHbzY30n1hz2vv7BiBMMhci+NEv_ubP1LjQNmBuu6Kjgw@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] mm: hugetlb: Fix subpool usage leak on allocation failure
To: Joshua Hahn <joshua.hahnjy@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Shi <alexs@kernel.org>, David Hildenbrand <david@kernel.org>, Dongliang Mu <dzm91@hust.edu.cn>, 
	Hongxiang Lou <louhongxiang@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Wupeng Ma <mawupeng1@huawei.com>, 
	Yanteng Si <si.yanteng@linux.dev>, fvdl@google.com, jthoughton@google.com, 
	rientjes@google.com, vannapurve@google.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org, 
	Zhao Li <enderaoelyther@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: tx87zxa9bgt6wzg8hhpfjdp8xpytsiiy
X-Rspam-User: 
X-Rspamd-Queue-Id: BAFF2A000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1789399623-197671
X-HE-Meta: U2FsdGVkX18X1VTuh6DP6rmZPc/rYExC+xckoJRsFUzB4NRn8hmBGg97TbSIh2oj3TLwSdOX/A74pVoNZTI+K79lOUeWmwahno6f5KToZf6pH5uq63/jW7FeZwF1kPYbPiajeKuiknfshrMNL5/YGtrI5bQK0HbtvXyQfT4zn59UB2CtphRwXQLXgBAXBStYdNx4x7xY+uWnXzfXHP07InFJcvdFrnlR8D7jDOOZunTUN+Mtzo1C/2wXp9PnvYUyEEDM9rUKoUgv5+HrtPvB+oAQJezLHFmWfUsesOR55bh+23LfvLm2TjoRgbnVNTK51vjvfj2UXIAcmHjU3EyUYM7NIOm/jpGgOaQ+Aq0mEyHwuT0wj96aUIgvy4z3IIyKiREW6VyUShFrriL9OtVfJRlq8L0q/a/MYWtJzWhd2YWSINcKnEnRgUM6BmoRmaH3BUr1dBciJKFdNv7tmCNb2wKQX+BJeLV9kJid83uvw+t+p2Quq25j7a7kUScOl0RIgrryEm7TFS5erDD/9YT1/uq9TWJBugzC0sWxEAAJRbZtR5Vn/tapLvbCReAOW2Z56KVlINSFwDSbE0uA2463T5Vw5aVhxcf90R5ybLpp1lLd6t9hd0cTkxAMEYlyFyLilGjDr8NxEGPwiGisuSeTtvZFXrUkBxz+Tp0FdWdM3eQSQMNHZl9JzYMvgXLPZF5pyPu8hmGjXSMiK9E3ZYNk3tecpxk4/RO4YNYugNG40wC9pu0Jk9P/fIO43o6nx0ka6GYy54eeyzq7BYNMwBrgBmAlDxP8R9xC+esMALn4fVwqpI4iWxogcEBcpRIELL6qdGFupUKlVKPwH77Rgc8vHMQ4EFqREyvIBdAbEF1qX4fuqOsUMT2QxLQ7AjgDHBhoSVragYXiuHZ7U6KVHNX0xOnR1kxmUatT0jejiy6zeJHSy7Z9xTJrixIR1o97p0uut1EseCylEUjyh+h4nvr
 GDUrM2cg
 qz0KlDPyHfIl97z143mk3d5TX44ynxli7AXivaFbe/qh0Inm2zueXrEZ1tMHb56WYd6L3nFggyFEJKwGuonTMBOqDqxjFf7JjUuT4LTF1m4lmhp3qbaJAvjJ+3b2TDBrOdf5dCZVSEaOQCXQUDNkiqF/PcOKwxXFP3sTLL1VwGgXwh1AVbekJhkcC1jSviJyi3W3ehrecAiUWVZC7iA3Jbogp40rHchnUapTp5dAERqmn5vnVdK1hNfUlTHBoW3pbP+0voaSP3Q7P8PRhDd531SSa6c61JDEo3HhyIIzH6OW2qifXCQUvGo9aa7x90sr0Lp9NbHLwHWCgFooLsx5I2yQAwHYHwRiwDF66IfjxyYIUUqS/e0X6zL/xXOFSbIhUBA3NE0xxCa7PiRCcsIaW1kh2ZEz7g+m/CBSw1iNsNTp1AJq5Ym5c7n2B6uLDwPta0Ba+vG6CSx6DP5Vk2TYU0l4OiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Joshua Hahn <joshua.hahnjy@gmail.com> writes:

> */
> On Wed, 9 Sep 2026 15:54:59 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> On Wed, 09 Sep 2026 14:49:28 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:
>>
>> > From: Ackerley Tng <ackerleytng@google.com>
>> >
>> > When folio allocation fails early (e.g. buddy allocation failure or
>> > cgroup charging failure) and a reservation was not used (meaning an
>> > unreserved global page was needed), the subpool page acquired during the
>> > allocation attempt must still be returned.
>> >
>> > Currently, the subpool cleanup error path only returns the page to the
>> > subpool if a reservation was used. If no reservation was used, it skips
>> > releasing the page back to the subpool, permanently leaking the subpool's
>> > used pages counter.
>> >
>> > With subpools now always tracking used pages, always release the page
>> > back to the subpool whenever a subpool page was acquired.
>> >
>> > Opportunistically rename the local variables tracking global reservations
>> > needed and global reservations returned. This clarifies the accounting:
>> > a value of zero for needed global reservations indicates an existing
>> > reservation satisfies the allocation, while a non-zero value indicates
>> > new global pages are required.
>> >
>> > Adjust global reservations using the difference between reservations
>> > needed and reservations returned to properly handle races where concurrent
>> > threads interact with the same subpool.
>>
>> This one conflicts with "mm/hugetlb: fix max-only subpool accounting on
>> alloc_hugetlb_folio failure".
>> https://lore.kernel.org/20260428113037.88766-2-enderaoelyther@gmail.com.
>>
>>
>> > @@ -3074,13 +3074,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>> >  	return folio;
>> >
>> >  out_subpool_put:
>> > -	/*
>> > -	 * put page to subpool iff the quota of subpool's rsv_hpages is used
>> > -	 * during hugepage_subpool_get_pages.
>> > -	 */
>> > -	if (map_chg && !gbl_chg) {
>> > -		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
>> > -		hugetlb_acct_memory(h, -gbl_reserve);
>> > +	if (map_chg) {
>> > +		long gbl_resv_put = hugepage_subpool_put_pages(spool, 1);
>> > +
>> > +		hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put);
>> >  	}
>> >
>> >  out_end_reservation:
>>
>> Here.
>>
>> I presently have Zhao Li's patch staged in mm.git's
>> mm-hotfixes-unstable branch, awaiting review.
>>
>> What to do?

My vote is to drop [2] from Zhao and switch over to this series.

>
> Hi Andrew, I hope you are having a good day!
>
> Yeah, I also noticed this too [1]. There are actually 4 proposed
> solutions for this in the mailing list which is a good indication that
> something is wrong here : -) But unfortunately it seems like there was
> no resolution the last time I pointed this out : -(
>
> I CC-ed all the authors previously on that chain but wasn't able to
> get a response, maybe we'll give it another shot here?
>
> Ackerley, Zhao, David, Song, hopefully we can align here.
>

[2] from Zhao could be one of the components to get -stable out of
trouble as Andrew requested at [3], but I think small changes on -stable
leave lots of gaps.

[2] does not address these issues with alloc_hugetlb_folio():

Firstly, there's a condition in the fix checking that min_hpages is not
requested and max_hpages is requested. That looks like if min_hpages
were requested, used_hpages wouldn't be restored even if it was being
tracked.

I could be wrong about the above, and we could also iterate on [2] to
cover the edge cases, but I think [2] would then just become bigger and
harder to understand.

Beyond that, [2] relies on local variables in alloc_hugetlb_folio() to
determine whether to update subpool tracking (a global state), so if
there's any kind of race between threads doing subpool get/put, any
local variable state would be updating the global subpool state wrongly.

> Personally I'm partial to Ackerley's approach here since I think the
> get/put semantics that he proposes is the easiest to understand for me.
>

I think it's hard to use smaller changes to fix the global state
changes, I'd prefer not digging to find all the edge cases in favor of a
cleaner fix.

I'm not super familiar with upstream backports to stable, but I'd rather
backport an understandable fix than more open-coding.

(Understandable is subjective, of course, I'm biased towards the fix
here.)

> It would be great if we could sort this out since I think it's been
> a while since we've had all of these proposals in flight.
>
> Thank you everyone!
> Joshua
>
> [1] https://lore.kernel.org/all/20260713144557.3845941-1-joshua.hahnjy@gmail.com/
[2] https://lore.kernel.org/20260428113037.88766-2-enderaoelyther@gmail.com
[3] https://lore.kernel.org/all/20260909155003.e6c2f4fe3c0bbee3b34578fd@linux-foundation.org/

