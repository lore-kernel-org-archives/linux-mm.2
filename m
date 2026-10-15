Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 863BFCCA464
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 22:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89C146B0096; Thu, 15 Oct 2026 18:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 825B36B0098; Thu, 15 Oct 2026 18:45:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73D136B009B; Thu, 15 Oct 2026 18:45:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 21C496B0096
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:45:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72BE4C0158
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:45:23 +0000 (UTC)
X-FDA: 85326343326.19.2C4710E
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by imf23.hostedemail.com (Postfix) with ESMTP id B7B5B14000C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:45:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="N5BdJO/I";
	spf=pass (imf23.hostedemail.com: domain of 3f1fRagkKCNAFwDG9Ew3G2AA270.yA8749GJ-886Hwy6.AD2@flex--tarunsahu.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3f1fRagkKCNAFwDG9Ew3G2AA270.yA8749GJ-886Hwy6.AD2@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792104321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C8xIcAcbBHZy1mi8Rb1UegUyeiD956DGbti3HZCArR0=;
	b=z7/CD9ah6jDK+dWlMguiPISuk22adrDAz+KiMsPwRMv/updSZyGx9klOAEO50Cd+bvs6sB
	XKGf0w4w9E8qpFE9qTJPyDL3CQz0MWPLCUSaWzJ8AUK3zVsRms8WISl3g/9x5GwTdSAWKa
	5ZDgc7NREGhpsLqiQvziEE8iiSgkTuI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="N5BdJO/I";
	spf=pass (imf23.hostedemail.com: domain of 3f1fRagkKCNAFwDG9Ew3G2AA270.yA8749GJ-886Hwy6.AD2@flex--tarunsahu.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3f1fRagkKCNAFwDG9Ew3G2AA270.yA8749GJ-886Hwy6.AD2@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792104321;
	b=rqKySTlpDg3C42SH5E0A19xCKjftN+A5GTuUbiZswO+amsQwmr60XBnHzc7gD297vM5upW
	/mTOFzB5KP7x+Qcf1MeVg+KrGbmqgCDvzLMkmE2hkxYMQbhvD5lLOxGI54v+mdKAjPtb/e
	rOm1bClQ2+FDwiV6+Fu/3huvNmBfGtk=
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c2e77b7742dso760708266b.3
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792104320; x=1792709120; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C8xIcAcbBHZy1mi8Rb1UegUyeiD956DGbti3HZCArR0=;
        b=N5BdJO/IZQ+63NyoyPM5skA5QGgl7aeTHo0mYqJuLwkk6yYqIfTBnFSt1yfWG8fx2/
         TaDzbKVirdLvWt/LHxRNZkM3bqMhxvW5m4v8Mv2dz8RS1XSzG+l6QKfAWj79kgzrmFYQ
         IASV53Ru31BkYfsmBQxPcSe1pWiv+/rf15SCVxwuc0t6CgbvmLU/MjQCAOjfpKfoW91D
         JU0hUZESDX/Ys4diq3pcd+cqxKRuqS2VbiXGNPmb5pXWJByTgEUe1LWOd2AM45AnRW5M
         0cPIRY9M96DU0xx5npTPAduqpllEktR3ANf+2IC8f6DwYPzUPStlK9/zcl9LUsal0JUp
         0GTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792104320; x=1792709120;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C8xIcAcbBHZy1mi8Rb1UegUyeiD956DGbti3HZCArR0=;
        b=qVvaiUcgDPwIrUSSqXia599C7i7ZH4Csc1L3VOK+1eUytxq/YRHVPrIghON37jRgtX
         61FxYxFGe3lgbXH1j/N1CpzWRCFRyhlCePJxoi8dsM9pfWX4aQMayQPgLaN4drJ4qGWW
         zSFupw0mluNvdg3LrRywV2gIZ/BpeaeVerCB13PfWKTzUdIiDD3DmLd/kvf7FhGsC61b
         f/BFz7mdoLcNjVWXOz0gScX5n5CwCXNkC34gxrabX+lh4Pm8KZ6HtNrWUOiXFd167/Cg
         Nre1JTAdUmPB0XL3XJ02nfgzK3aPYs8zx3IAQuHWVa1PjCzOn0t8p0FnP7Pp60giWc+D
         66Og==
X-Forwarded-Encrypted: i=1; AKwUvBylJiVGZ6jLLh11gwQ5HWzmNlxArDyIqe4HyHgtU5pjcQK781jti4ooKuUY4i7SxViyuxBYZbtRmg==@kvack.org
X-Gm-Message-State: AFq9FYL+dLfbId+3wqprFSZ6d5vsHbriZz2S9xSEB+eotu6by0O5h3Fa
	gckMdI4uCARNwFdGIlB75qCz2Orgq8Em/FbyG1RQm0pYQHIEsGglDAo634pWwhFXXRyZQJ5XlZf
	mRZa+32rP/cPhREXu0w==
X-Received: from ejyb15.prod.google.com ([2002:a17:906:834f:b0:c39:4b00:1781])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:9801:b0:c25:504a:1e25 with SMTP id a640c23a62f3a-c31a9fcf521mr1847005866b.13.1792104319385;
 Thu, 15 Oct 2026 15:45:19 -0700 (PDT)
Date: Thu, 15 Oct 2026 22:45:18 +0000
In-Reply-To: <atB1uG8kLfmZyLIH@kernel.org>
Mime-Version: 1.0
References: <20261008190828.3221718-1-tarunsahu@google.com>
 <as4EcgiBH5jjww42@kernel.org> <9huzecdt633e.fsf@tarunix.c.googlers.com> <atB1uG8kLfmZyLIH@kernel.org>
Message-ID: <9huzo6cuinwh.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 1/2] memblock: drop for_each_memblock_type() and open
 code its users
From: tarunsahu@google.com
To: Mike Rapoport <rppt@kernel.org>
Cc: dmatlack@google.com, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B7B5B14000C
X-Rspam-User: 
X-Stat-Signature: 8d3wyjs5yeyodurgc4or4dmoo7nca64x
X-HE-Tag: 1792104321-496893
X-HE-Meta: U2FsdGVkX1+U3S6eTXr8NGhDvtzEHrCP0iA45Yarcqh117C9+ljol5S/3b7wMmPNTBAovPZ8jaJIJrDc1vtXCsT3wW7RXEjADvoDtMcmL0T6khqw5AE93YDbyDNg9XeROv0MBn+pHo/yHPt/iA9knQTOfoN37ubwlm1A7czsWUcbZ6yG8Lc0NS0l2CBbbQwavRDbS4skT3wDRernTBjGDUcgoSwTGqiRnTBkwVo16xa0UqmXrTX+FV5kASYRWsLZi43Y3am7V1yX2njDbxMAe/kiBp77BWZgKmwVs6WcAGZUG8Yquet7VRf0w0QZ1JtAnycHsRqZZfatkwSM2JtTg5jdks8xhHaVKVqcsBl/ErV8dz9BVoNsZ9j2Y5/a8SDnhXuv8EUJdt+wMWHFgK1PTTzrNkS2D3IKDXUFhvFBrEmWb+yilT0q1dcawczvojNigF/yQdyb5E0F6fVrUcV6UXkBH6z8LV3nmVM3Yl4Bcvw6pjeegbMXGvF/A8PfLcmQarGlUz+NcPyRFh9qg4UAPRF1K7xy9o4PqCwzlGf+XrhTBnh261LEc2F8fINhc6qq//rTASg/KYgLkCSOuOPAvqkKKCeiILzhdRaG28HOxWLBmUQv4IHiR++P6mAFZ4A0/8kMWnGmxt/rss2zSJfHdlRXdFaf6cmMiOFjyHl+SXVzAQYp1JTXGqysiJgRXSEav6OZ8UVpOc6lMLqNCumy33GewSww3x/6q1yZjGFoh8pHPsn5Hhc0SrI2xnwl26EbLBrQmkUyStHh939/VHNSxUBCexDRodJeYkn+IP+4F42XD21QeVoY2mTFUpXrQvVqMaQX8qkBwgPqTeKX8Peg+awS7Qj9boVlIC/xoRCrMb0IEGt4IdYrEn0tcgjN144OvsztvzRuCIykSNxzMgYu3o1JfYawCapVAzOHG6TthHB/ePnIqmOuz/JfdAf09Bz5ifMCMGByogvpSl4DE9q
 /RCGuQix
 i8+PYkHAbbfBTju6h/Hziw21Gq5VCjeR3thpk+4moYKgkhijTMNydbKnDzI+hqKECPHZTIw4kAKeVeIw89IrkEubHjeLPueLPrk4b+hiFCcTkS1U6pRQ00pDdhFIQZdxO1tFoXX6w5nyjd3wEl9i7RjfUyujFKnpqLNF/0X6Mm9YfRAS0nBz7JXxOPDkeYN7hOR6vvyQ7U5VK4yt91iMpD0flBpAmOPhxjSElqh3giqs4nQOB/iZxLUBY06k/ysmT0/GzFffEX+oiHT8asQL797j35HePMSqggFJAVaWh2WswQxNIoN2kYrgBitJ8u/wEc+QTqHDtPiw0B0sooFfoMZqYpi3cs04C5u6EIIMns2T4+fMugDY4VXjF12Z8kWYg6mN/cR6/ZMYujgQkqnayzbmcyCdC1mPyK66xYGZjjkCMsY3c896fwbP3lajmjjAKIp4gd1IwOmeNQEH4DTPS8d071v8mZc/s5+VKhbpM4mAZP22xZtKLwmVZHptl2cgeQWKc0h1aLxaxcO0BOD7N2uYPvs2NRn4KbgDcyJPmmPZiuNTui3zocENqCiSr6wRDR5EmeOy6fQbOtn8qMPqcUBeGnxx6w9+LsbIH300EEJYrS+xOwIUlxsRjVJoQx2/1aQObUohLc8mV4qaAUn8dalBbLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mike Rapoport <rppt@kernel.org> writes:

> On Tue, Oct 13, 2026 at 03:18:45PM +0000, tarunsahu@google.com wrote:
>> Mike Rapoport <rppt@kernel.org> writes:
>> 
>> > Hi Tarun,
>> >
>> > Please for the next time add the cover-letter when sending more than one
>> > patch.
>> 
>> Thanks Mike for piking up the patches.
>> 
>> Sure, I will take care of adding the cover-letter.
>> 
>> You had some nit change suggestion, Let me know if you want
>> me send v5 or it is alright.
>
> I fixed some of it when applying and some right now, no need for v5

Thanks Mike!

>  
>> ~Tarun
>> 
>> 
>> >
>> > On Thu, Oct 08, 2026 at 07:08:27PM +0000, Tarun Sahu wrote:
>> >> for_each_memblock_type() always starts the iteration at index 0 and its
>> >> body is a trivial 'for' loop, so it hides very little. It also gets in
>> >> the way of iterating from an arbitrary index, which the next patch
>> >> needs.
>> >> 
>> >> Remove the macro and open code its three users: memblock_add_range(),
>> >> memblock_isolate_range() and memblock_dump(). While at it, move the
>> >> region pointer into the loop body scope.
>> >> 
>> >> No functional change.
>> >> 
>> >> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
>> >> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>> >> ---
>> >>  mm/memblock.c | 17 ++++++-----------
>> >>  1 file changed, 6 insertions(+), 11 deletions(-)
>> >> 
>> >> diff --git a/mm/memblock.c b/mm/memblock.c
>> >> index f5aaa38cfa31..59dda7d085f3 100644
>> >> --- a/mm/memblock.c
>> >> +++ b/mm/memblock.c
>> >> @@ -155,11 +155,6 @@ struct memblock_type physmem = {
>> >>   */
>> >>  static __refdata struct memblock_type *memblock_memory = &memblock.memory;
>> >>  
>> >> -#define for_each_memblock_type(i, memblock_type, rgn)			\
>> >> -	for (i = 0, rgn = &memblock_type->regions[0];			\
>> >> -	     i < memblock_type->cnt;					\
>> >> -	     i++, rgn = &memblock_type->regions[i])
>> >> -
>> >>  #define memblock_dbg(fmt, ...)						\
>> >>  	do {								\
>> >>  		if (memblock_debug)					\
>> >> @@ -615,7 +610,6 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
>> >>  	phys_addr_t obase = base;
>> >>  	phys_addr_t end = base + memblock_cap_size(base, &size);
>> >>  	int idx, nr_new, start_rgn = -1, end_rgn;
>> >> -	struct memblock_region *rgn;
>> >>  
>> >>  	if (!size)
>> >>  		return 0;
>> >> @@ -651,7 +645,8 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
>> >>  	base = obase;
>> >>  	nr_new = 0;
>> >>  
>> >> -	for_each_memblock_type(idx, type, rgn) {
>> >> +	for (idx = 0; idx < type->cnt; idx++) {
>> >> +		struct memblock_region *rgn = &type->regions[idx];
>> >>  		phys_addr_t rbase = rgn->base;
>> >>  		phys_addr_t rend = rbase + rgn->size;
>> >>  
>> >> @@ -815,7 +810,6 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
>> >>  {
>> >>  	phys_addr_t end = base + memblock_cap_size(base, &size);
>> >>  	int idx;
>> >> -	struct memblock_region *rgn;
>> >>  
>> >>  	*start_rgn = *end_rgn = 0;
>> >>  
>> >> @@ -827,7 +821,8 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
>> >>  		if (memblock_double_array(type, base, size) < 0)
>> >>  			return -ENOMEM;
>> >>  
>> >> -	for_each_memblock_type(idx, type, rgn) {
>> >> +	for (idx = 0; idx < type->cnt; idx++) {
>> >> +		struct memblock_region *rgn = &type->regions[idx];
>> >>  		phys_addr_t rbase = rgn->base;
>> >>  		phys_addr_t rend = rbase + rgn->size;
>> >>  
>> >> @@ -2194,11 +2189,11 @@ static void __init_memblock memblock_dump(struct memblock_type *type)
>> >>  	phys_addr_t base, end, size;
>> >>  	enum memblock_flags flags;
>> >>  	int idx;
>> >> -	struct memblock_region *rgn;
>> >>  
>> >>  	pr_info(" %s.cnt  = 0x%lx\n", type->name, type->cnt);
>> >>  
>> >> -	for_each_memblock_type(idx, type, rgn) {
>> >> +	for (idx = 0; idx < type->cnt; idx++) {
>> >> +		struct memblock_region *rgn = &type->regions[idx];
>> >>  		char nid_buf[32] = "";
>> >>  
>> >>  		base = rgn->base;
>> >> -- 
>> >> 2.56.0.385.gd3acb90ef8-goog
>> >> 
>> >
>> > -- 
>> > Sincerely yours,
>> > Mike.
>
> -- 
> Sincerely yours,
> Mike.

