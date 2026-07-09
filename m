Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BA72C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2A696B0005; Thu,  9 Jul 2026 18:15:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDE316B0088; Thu,  9 Jul 2026 18:15:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA32E6B008A; Thu,  9 Jul 2026 18:15:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 98C2A6B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:15:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 69CCF1402BE
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:15:55 +0000 (UTC)
X-FDA: 84970646670.18.34CF9F0
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6F06140009
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:15:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=c42vZu8j;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783635353;
	b=tWGGaROwhKN2WVaCWg0k36Zs9lrlyccAtxq4Lv8r87l9Nu1QRl7VhoUVYN5H0uBWbiocu+
	gFnJdB6Iw8Um3YeQKUrhGk20nv383HTOVd24n2qm2tWSoyrwNP/nGKVg11qLjyZG8VN+UP
	PatyMrckgwImd27uz+z3eoZeZHOxxtw=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=c42vZu8j;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783635353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mEwVlE35yinwK/CaZ7UcUKT4GdRsANBC6/sIz3zUbfo=;
	b=PJjv35XsFx797TLbf3pcLFjjXwx4MmF8eo/VY0n01o6tqGiZCYeZBu/jNnIO9mucEI2ew9
	1jDREx1tMJ52v21k1PQwj5NMDZ1cZrnNlApD0jQEguTYtZqMILWU8McZK4xneWPOXKdwOX
	1GkMc+x7FOxk+MKwXI3qPqsOuR0RTD0=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c9cf07d2df6so213537a12.2
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 15:15:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783635352; cv=none;
        d=google.com; s=arc-20260327;
        b=Vaw/YlYFT4+VGqKtp2fVMhVgh03FcX44YV39pyaVFZsOF4FfGjI2dO+gW7nWj/t6pk
         VHncRkbtBu/Lld9ANM9DmkzfYXb0JMLJFPzwHWRmdiWz6IMJGE+FYANgM8VNJJYx6osj
         buam734Cv3aq6jaS/3KAN30CppjWTWEvxZzc/cYi0Kmiaqp983637LnGMnCAlCn7Xv2Y
         CgNdKtOqC1NBgOMXdmhgRy+UkuW7XrfEGygfMwWber2fbj5aILXARn3WRYLNUuLPMMq9
         DrmFWxx1nfg60rouYlxqXb8J0cQl+UMWnDPAnH0dwlky/YqoZtno3hAPkV/JxUfjLdXC
         OnBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=mEwVlE35yinwK/CaZ7UcUKT4GdRsANBC6/sIz3zUbfo=;
        fh=nzfDC55mYK9/sYhsnXXhlt+kr+/9rEvYWddxbgc3qd8=;
        b=NhI+F7tmYNGJlF/fUaD5eEML6KAt70E4aN0rtDMDLtv6Bu0Fq2pKZhJzXbcoZIkfAZ
         4sZVD5Kf28IWct1m7fZhFxos9+++DOAi+1u7Cv96swW1bFNROZja5XQM/vPzfCVIlG15
         /XR5nSOUkw0xRTp3svf8fTLVsbqCbFlaaqTeGMQap60QM3CloBkKmxZhvKMYS3O0U83M
         aAqPT2qy1Pt31fuX1rHKIFGEhVjZJtxEBkoAgKASm5rtzM/WmqPlR5S8q5+/s68Y715t
         OaMakd7OTbL4GUN71nrB8f43y2mbM3e+KsF9x8q3iJHPAF4hGA0/+xz+kvQ41ROxBaqg
         YUIA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783635352; x=1784240152; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mEwVlE35yinwK/CaZ7UcUKT4GdRsANBC6/sIz3zUbfo=;
        b=c42vZu8j1vECgwSZ5Xu1njX2a41BfV7nABasvFRRjUIJ+YUg9i5K7VF+Jx0cF3/eXJ
         6f4qg9YChSKsAX2/HQSBEL/J69ceRUvTq78ezl4DLRU5IMCpK4SyvWi0+j6r1RtMqP/E
         J2Q9xGXN/aH0jmu93mXbOrFMS+uJoKZx4gSmFTR/tOd4P0bbkT9t+Idn6/3IyQmu7Nic
         fQ6aEP+kNLS+6C1R2Ac+rcQKxFxxhG+56PWFLgA17WU8E+30cQn+GOqYlZsLOCbxItam
         j9rcwdb8sw5zGHrM0CkKTrnmlSwfHYF26krsDdmntu0lxQFe2PzJlhc5ThSKNABhf6vY
         1EXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783635352; x=1784240152;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mEwVlE35yinwK/CaZ7UcUKT4GdRsANBC6/sIz3zUbfo=;
        b=Mgq///bC62Luq8of5k4m0O4k3lOzvzCif59k0r3/k6NMGdwH/yTYNaT04ZuGdKG4/5
         b2AI3+pyMgGiE+yKfjnHCT5Z0+nbhCpRfTxJBeq0lUVKtei9CvArNk0kJnL160VfxSUR
         HjoOONp7VlsTJ1Fw4EpYZAcRvoK5aHjL6FXUdNzziWCMZ3yzWGvnqaFumY6uKOXlT2eR
         yr/lKRpLKt+bJdwP+N+bCIUA0ENDRf4CJLcE89WDdqjoxIk4JZgxOBsD0xqwBXVPsekO
         Tb6tyE8BiBysiamxoT5DF1nIuR7CSLurUMEtKCP+lvVafBso1y2vl5k20xfQil/ojlgQ
         BfHw==
X-Forwarded-Encrypted: i=1; AHgh+Ro1hue13TjDdAbKISg4RKHq2gKktr0anUEp+1fprs+5/QUnA7BZSfUEBU1WixZXL8WLMOGsKpJwiw==@kvack.org
X-Gm-Message-State: AOJu0YwqUPc9DO24pWUBAV+zGheTWyEmR3NQhTjw/BHAc6//UygGb020
	REUHAIlhpVvTJmpiTnMQeKowV6uKwePVmFuOslaETKeO5SnbATCqnxtWl6jrm21NZb5Lt9+JS/q
	t4E4wUV8f9CMvup1Wt7ssVLak96PK+97w/K1kUuuq
X-Gm-Gg: AfdE7ckcTnK4Avw8ZswSfwBX3nV1rQcQ6qtP4sqrFVoeUQ9QbJAufkXVln5zs/7EK22
	b8q6h0R0YO5RthXSOmUK0lJ9dwkcT0FAbQmNjEw8qYaREsofsGxLPG3NV4yHrvkx2jwIDuIwnmS
	/qU4R9Hz1YL1nXHBqikvL16HKWCD44X90FxrBRg5POEUO/pYvJhxEFIq3T4FOg6nQev2itH2bXO
	ZoCaWKrKzzopxmVSideuJwrYxukohbXbIEXpL2QDUOJFjujirlRBQLnDsxyKoBjSqHYLlLURXoI
	VGfq9xDIodizMRtncuD5pNStCo8VwTHNhuurESNGUPyWIC3UnBSGJ89SqDeEr5rC/iLAyw==
X-Received: by 2002:a05:6a21:3086:b0:3bf:b705:4b9d with SMTP id
 adf61e73a8af0-3c0bceca396mr10973890637.28.1783635351656; Thu, 09 Jul 2026
 15:15:51 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 9 Jul 2026 15:15:50 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 9 Jul 2026 15:15:50 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CAEvNRgH9WSF64eKardR9M9VeRiN85UkS=Zsje9H8mqjQQychmw@mail.gmail.com>
References: <20260709153409.2091070-1-joshua.hahnjy@gmail.com> <CAEvNRgH9WSF64eKardR9M9VeRiN85UkS=Zsje9H8mqjQQychmw@mail.gmail.com>
MIME-Version: 1.0
Date: Thu, 9 Jul 2026 15:15:50 -0700
X-Gm-Features: AVVi8CdvfF-IT3gKBuhe9TeVC3ZAyxvU-Wq7nKHZoFIvtZtPczQqgh73rAYctlA
Message-ID: <CAEvNRgGN0HSJ2iLSDD2haSKOxifa-uhkO9Hwossh0+Q_d9fzOw@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] mm: hugetlb: Fix subpool usage leak on allocation failure
To: Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
	Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
	jthoughton@google.com, vannapurve@google.com, erdemaktas@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	David Carlier <devnexen@gmail.com>, Zhao Li <enderaoelyther@gmail.com>, lance.yang@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6F06140009
X-Rspam-User: 
X-Stat-Signature: 3ynqx4qbjd4rtzj57acpebgyuzztj3s9
X-Rspamd-Server: rspam03
X-HE-Tag: 1783635353-661674
X-HE-Meta: U2FsdGVkX1+DyLdnDVxjNB6AQAXGpqplzNgHc7axxCes2ohVYfQoud2WBfOiclSRR0N0JLPIrsvuISp4oRIc1sy6npgVTLsVgglJFOXe7Mp/K6g1xGQwnsIdwV6TXLfkIrCuqDBeJfc3WdRDonzkY07CJbDg8HZOCgxGT3+wQoy/+QAx+kdNZZMUcPljbisREd73rFL718tzcX3PG56h01lgnrdaGBhV/uSPDolMNxabg8CaNYxTLSHKxOqN+WQEL4FzMkPiaj/SufKxxOrwexTX4L4eqMBFjwoPRkMYtLBu1R8D1t/kXlpEWcBUx31xOL4eNOIWsA6z3MjmdfmpuMVFDhw1aGkl5zlrgZf/TPbhmdrJgWONpTLq8jVCiphRtSYhlkhwdZL0zcV2z6zDvQG5rGwf6AShkMUsudEvBPx2huTAdlLEw46uwAGcrDGsZYG6hN5dpjFfOyV2qHmdoLULkfALJ0pOvlYvEOtFXS1oiPy38GLCz6uXp5vZA4GDE115UAm7IlVs4mlED+8io5nk0KV19BzLJH4MdXSSn1d4pw8sldl1WEF9uA4DLlUG67mDhJq3laxiYthAr4fVytpArID6jzthiCiDkUleM94yLGSLhOO4mdS4O0OXysBy7s/9kYwuF+KyscjgHeJuUa130EJpFkYCMavPTmglP/sL70W3t0cSZ/GbA8csJ2moE67agYD3UMXoxxQkQzNY5PONzM0djJlRNxDsO+GQSwjvr+LQczuFx7gEjZ3ksslgY0ERXrqlicjvzNpFV4a32VMNUiPdORBSjxH0prsi5mJqaduUuyNAyRt2Fgul3wOmgzfgvE75tFihCoq1OnGgfKsoNShFjL9giEDKoH48hSNWpKqY2ZRX3kWuh5SqCyluGjQDOqvCFh7JAfUIWzqcxqHESBBwsw3EbbGX1uv0Q/25DCRtCzhLUOIEcNE9chcdMVds8fa3+YnsQKR9o7U
 cDuSczhR
 AJ/T5pGoP6uxI51zkrQO+hfeIMZBCpdO472Ct6mcJUd7YTujQFSmYfJR4Q8+k/axTlVISYMAHY8JfQnGTEK6S+OkMufHNB6x+wkbeUyjqdvFVZYl1tJwmBzjeV8Koolm6XgTkOMIDrQr2JIvUbvN8ql8yHpXkxAF6hwWK9WyFEbjiCxpobrxDsYZqxEv8RWL3ccTlDEAqQx02PLps2tCz0tTsmGOxU6Y3pJcwWxLGbZG8RPM2gT7ycg/Idzq5OBLWIo+v6d1Qn6Sbp732+Xkd5hZuyhfkPiNb8w5gnw1S0ptxknHqp7JXZV6XooENA4RMVPulMrxjgMJu5Fl48bzXbBzfeRAdkcXntMgfA14BgL0XAOwkiTMJlvENnYNhvU/0IN5W3qg7GJFI8tuh9X9VYT0WIsM/rNzW3qgRodG5JuHYWZMdqZWJ65j7U+YZuBzIp/aF0qeheQnWJp3pvr3cPc2TyEwymGMds6EXHgNUa35oJnvqJE0+glPewnU4xkbuYs/4D+8V2SMie9jrKL+tIEyvxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
>
>> Hi Ackerley,
>>
>> Thank you for this series. I really wanted to work on hugeTLB accounting
>> fixes but never got the time to get to it. I'm very grateful that you
>> are taking a look!!
>>
>>> From: Ackerley Tng <ackerleytng@google.com>
>>>
>>> When alloc_hugetlb_folio() fails early (e.g. buddy allocation failure or
>>> hugetlb cgroup charging failure) and gbl_chg == 1 (meaning a reservation
>>> was not used, but a global page was allocated instead), the subpool page
>>> acquired via hugepage_subpool_get_pages() must still be returned.
>>>
>>> Currently, the error path out_subpool_put: only calls
>>> hugepage_subpool_put_pages() if !gbl_chg is true. If gbl_chg is 1, it
>>> skips it, permanently leaking the subpool's used_hpages counter.
>>>
>>> With the earlier patch to always track used_hpages in the subpool, always
>>> call hugepage_subpool_put_pages() if map_chg is true to consistently
>>> restore the page to the subpool. Only call hugetlb_acct_memory() to adjust
>>> global reservations if gbl_chg == 0 since gbl_chg == 0 indicates a
>>> subpool (and global) reservation was used.
>>
>> So I think that I've seen that this part of the accounting specifically
>> is a bit suspicious. There have been two attempts in the past to fix
>> this area [1] [2]. I think functionally they are quite similar to this
>> fix, they just open-code the contents of the put_pages function inside
>> the condition. I've Cc-ed the authors of those two patches in case
>> they wanted to chime in.
>>
>
> Thanks for connecting us! I didn't realize this was already being worked
> on. Also adding Lance, who commented at [3].
>
>> I reference these fixes because I think they handle the minimum
>> subpage case a bit differently. To be honest, I recall reading those
>> fixes a while back and getting a bit confused on what exactly happens
>> when the page is absorbed to fulfill the minimum size...
>>
>> It does seem like Sashiko also notes this as a possible concern.
>> WDYT? Does your reproducer for this issue also work when a minimum
>> size is set (let's say, to 1?)
>>
>
> Let me look into this more!
>

I was looking at Sashiko's comment [4] and Sashiko is right that there
could be a race. Specifically, at the time of
hugepage_subpool_get_page(), I might be using a reservation, hence
returning 1 (thread A), but at the time of hugepage_subpool_put_page(),
some other thread (B) might already have restored a reservation to the
subpool.

With used_hpages tracking within the subpool, we can rely on the return value of
hugepage_subpool_put_page():

+ Return 1: Reservation should be returned elsewhere (pool has enough pages to
  satisfy minimum, or doesn't track minimums)
+ Return 0: Reservation does not need to be returned elsewhere

But calling hugepage_subpool_put_pages(1) doesn't say anything about whether the
1 (in this case, 1 doesn't always represent a page, since specifically on the
error cases, the page wasn't allocated) consumed a reservation or not.

+ gbl_chg == 0 means a reservation was used, and
+ gbl_chg == 1 means a reservation *should be used*, but
+ gbl_chg == 1 does not necessarily mean a reservation should be used, since
  h->resv_huge_pages may not have been decremented yet. (See goto
  out_subpool_put and goto out_uncharge_cgroup_reservation in
  alloc_hugetlb_folio())

So, we need to track if h->resv_huge_pages-- happened (with some local variable
like reservation_consumed)

| reservation_consumed | hugepage_subpool_put_pages() return value |
h->resv_huge_pages++ |
|----------------------|-------------------------------------------|----------------------|
| 1                    | 1                                         |
Yes                  |
| 1                    | 0                                         |
No                   |
| 0                    | 1                                         |
No                   |
| 0                    | 0                                         |
No                   |

TLDR: replace !gbl_chg with reservation_consumed?

    <<== reservation_consumed = true

	if (!gbl_chg) {
		folio_set_hugetlb_restore_reserve(folio);
		h->resv_huge_pages--;
        <<== reservation_consumed = true
	}

	if (map_chg) {
		long gbl_reserve = hugepage_subpool_put_pages(spool, 1);

		if (!gbl_chg)  <<== this should be reservation_consumed
			hugetlb_acct_memory(h, -gbl_reserve);
	}

I believe this depends on always tracking used_hpages in subpools, in order to
know for sure, just based on a number (with no page information), if the page is
supposed to use a reservation.


Perhaps related: does it make sense to flipping the reservation tracking
to instead track an "available" page count? This is basically the
mathematical opposite of rsvd_huge_pages, as in,

  available_pages = free_huge_pages - resv_huge_pages

This way, there's no need to synchronize the number of reserved pages in
both the subpool and global hstate.

It's quite confusing now, that reserved_pages-- can be either "used a
reservation" or "unreserve". If we track the opposite, available_pages--
will definitely mean the page's availability is removed from the global
hstate and transferred to the subpool, and allocating page doesn't
involve updating both the subpool and hstate.

One downside I can think of is that creating hugepages (surplus, or
promote/demote, or hotplug, or runtime echo 1 > nr_hugepages) would need
to update the global hstate's available_pages count, but I imagine that
would be less frequent than allocating huge pages?

>>
>> [...snip...]
>>
>>
>> [1] https://lore.kernel.org/linux-mm/20260428113037.88766-2-enderaoelyther@gmail.com/
>> [2] https://lore.kernel.org/linux-mm/20260515202902.461539-1-devnexen@gmail.com/
> [3] https://lore.kernel.org/linux-mm/20260428113059.79001-1-lance.yang@linux.dev/
[4] https://sashiko.dev/#/patchset/20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b%40google.com?part=2,

