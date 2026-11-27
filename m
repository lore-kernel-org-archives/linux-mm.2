Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B19C9606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 07:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=j88KYikn
Received: by kanga.kvack.org (Postfix)
	id 7CB1F6B05B1; Fri, 27 Nov 2026 02:46:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A3016B05B4; Fri, 27 Nov 2026 02:46:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B9426B05B5; Fri, 27 Nov 2026 02:46:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 39DC26B05B1
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:46:08 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D6AAA021A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:46:07 +0000 (UTC)
X-FDA: 85480115574.19.DF287D8
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9880FA0012
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:46:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=j88KYikn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of abarnas@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=abarnas@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795765565;
	b=3qVfaMsBx3wM3xXMQXmLPo1aqr8BqrT7rEYT52Zsq4APofKYXd9GoN619+vC7a3chmiMZu
	M9+aEMWNOfHF8Oa3P+titUYVzh1fOv/txeC2Iogq1rkqEsIiMzlOJ6Gm8Civo2psOKHxL6
	2XofhPlTWeZgkGdjkQaeEOrz9zpXljY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795765565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kE/eguf/QJRyrFge017AwYGh9sg5CwoSTKIxiAunsZ8=;
	b=g/qzKszPpRkTfTfUj/ZxOPrOSYEuZps0KtnIh+dBUik7GCIxsQXgjt6BiTlfuis/H4OVn5
	V1MMQAws06kU8G63qZxOkA/MdG4iTXHQlv3dQlqJWJS0UEPyFGIfaNYlK06sfPU4yygH6W
	PpsY6PfPUXX83+hZ11FyQxekuL5mlS4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=j88KYikn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of abarnas@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=abarnas@google.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so78546935e9.2
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 23:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795765564; x=1796370364; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kE/eguf/QJRyrFge017AwYGh9sg5CwoSTKIxiAunsZ8=;
        b=j88KYiknGZZcMjEfZRS/lVwXjJegnouSx0ZqaS6pcMiSu7rWzqZoYz5V7u28GRrwcC
         bIM6KPFU4okhtukVQvh6atf0i4+cubgry9swDzRthEV8FQUZOOHJ1e4Abp+sCmKhIWeC
         S+Vyqktav7y2NSSnOPBpcjWBLzqylMQnkbgO4dvJKqEyPU8K7QFa02N9M6GfQwbCTlWF
         zeJFJdHK2/t7LX2zgLDQ7/DHpk8/0WNu46/6k7YBhrDJq0w31jVlQfov9XeDDHchxUiZ
         FxrmWhDrCmhJu/eIFUp/0XoBIjBO/vZl8Sbk0DQR0CdkP4A/dxNWl29dt4ngiDRXOJFz
         NP1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795765564; x=1796370364;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kE/eguf/QJRyrFge017AwYGh9sg5CwoSTKIxiAunsZ8=;
        b=DKuJwKDvexaj9OFX2M9aY/Mvt40FqEWLQKz38a6jc1x2lekazfuU1vxupopuyKIPpi
         RuuNDs3vdiQs0ieBEXSxin8+RlKg8wJZsBbiT8UXyRwxr5ElpbbOt0XFbJ9oM31DQzQl
         jv9/nZZG0eAFcq8tQpbUlw9BIwzJrLTDKn2dCNprR8Syix2gHWrSz3kVXgmpARxJjb9D
         u66NLNxPwg4+YhFNTXH/MOwLyxGDxH+6Evs8oas6PL2O6xtLVlqJq4bsOTUV3PE9PjjK
         K8R8s7meo9X0jRtcqFEbEYs9bVDyQB/jeps0uK7BPkDkKzvROfSsLG6M1Fm3zycTfm2p
         /atg==
X-Forwarded-Encrypted: i=1; AL+hErFh2aaEZ5hR0PIp/LCNVAcSY97XcZYbInqCIV8I/0YW37dlaB3XSpBfDPJgWyPvOrAnGhh5mQ1O1w==@kvack.org
X-Gm-Message-State: APuU4Z8ob3a5AJQIpbsHrkugs8kXvM7ZAwXwN2M8Hcn8aplWNAXOfC7h
	ZaAUVSzWP7oPbR5ZzVqHHl6vPRgZcyUmItf8TqM1a2oZ6PK7O6YMAhMQ/3B6exDkhg==
X-Gm-Gg: AZFdTZdLYT6hle0ZgA8nd0B+VZvyUJRb5Epw9phPT2OjTXRnJdIjg08lkxOmseAneiQ
	4TQ0hR9Qq+XyJhhoG3FMokFK0B+s5Mpg6iCWQX//AlPt/CdADiUGezvOWzfAfske9BS9HY5id4E
	aD/EXdr7l+DiekI3XwO2kWKtYzczPc45YrfLJ6TxtxUZ+2jyTO/oVqZKOAshq5bqrxKYOQUyAa/
	vSg3RHmRxhjSHM10B3Mjzf7vwi3MyWsa93cyBIHEtI/44dmZM5Yeu4NSlAyWTLn2+WkRwRRk1PE
	3u0Oblm9KMqRo21l6Vc6kAZuxgfawHcR2aA704u4CZNrh8rElDPYGcUO7zqdNGmd6/saIJYSpQy
	I0awpRYRwqwBAHrAxGtUhOgCab//ARU3EvOtD8HUXDBupt0R8XFIpMejvS1nV0RppCooWwdZxjQ
	p5UJMpV20EXpJkYzppZZ3SagHPFhX7AfAVT0MBoJyFngq1vom5rMCo2dDnMIjg15+y1NBLBPkxK
	pJ7Bz85MSGkPSfvxUUnn/T2/kMkBKNnufbbqTsRHyKiHYm5Ch7ClluGuDGPqbqzaSPnaCDtw6wr
	cjjTthf5W3xbuKlZbH61Wrfr1qlTqN5PixWHqV55UlATjaxfXUSNStYXCKHg
X-Received: by 2002:a05:600c:310f:b0:4b5:d95c:2378 with SMTP id 5b1f17b1804b1-4bb8881f9b7mr504941065e9.34.1795765563326;
        Thu, 26 Nov 2026 23:46:03 -0800 (PST)
Received: from google.com (30.0.77.34.bc.googleusercontent.com. [34.77.0.30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb85399d52sm643712045e9.6.2026.11.26.23.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 23:46:02 -0800 (PST)
Date: Fri, 27 Nov 2026 07:45:59 +0000
From: Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Brendan Jackman <jackmanb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [RFC PATCH 6/6] arm64: mm: support PMD page coalescing in the
 linear map
Message-ID: <awk1N98I7daqXHPC@google.com>
References: <20260611130144.1385343-1-abarnas@google.com>
 <20260611130144.1385343-7-abarnas@google.com>
 <799181c3-a1a1-4de7-bc6a-576d3282efb0@arm.com>
 <akuieSDlbYdHnkCV@google.com>
 <aku8zidRtXPe_Rle@kernel.org>
 <awQLqYbrrgwUycxP@google.com>
 <awgbKPpwipkwkXPY@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <awgbKPpwipkwkXPY@kernel.org>
X-Rspam-User:
X-Stat-Signature: utr5cgy7tegjmrbogfd3sbe6x6u6rgej
X-Rspamd-Queue-Id: 9880FA0012
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795765565-570382
X-HE-Meta: U2FsdGVkX18bw3foEKqUtKH7chSxC6WpMW6Vd5rPHrLrC6BI2Yixdgy3axSaPWMKfEhRfMpjHtJkxGNJm9+mYQ6lxsDngtuXmCJj0C7uHWCJv2FgrmJr5MpwHVbmIkMCyI07W8zfjNGrNuQv3EuI60XVU9N3jJmwIc+pSDXKiSGoYRpS06qzm/umg0t0Xat24mieCBCZbO9ATG1xnIpXp356INlfdpxXOtixJuj2j8KUUSvqiMiRhDCpe4AJA2SKCYpxrHLa6FRQpYH0hpAjKFu01vHqYO38KzWoefRQ9fDWXkFDC5esBWn9Y4l2TdmDrrKSt+rad83ZPMlAx9qKtp9HHjm/tK42S0MnsTg4qVPMP8a9EZW1WlxZsYqpUovFgKVlD6f+i/lyLs2b12xSCmH0dP5NsJUmMlkeebp6ckHUPFPasw70cmxZTj6lBNXSGyhlXn+/rEySXT5K/hSzRYnrPF37/UBXabtWsXQguWgXRSnjqDX0rAA8+31KE620uGR3128ki6bR3iOuYhI/4q93zXE9sxkmtq0pgK/UHLuqCZsoGPP1Z+/e/EbkRdGclDjddlg0zcDfG2rIT1obSxoXlPsiCHBzr2/aUrUl92Ajn4Y4FG8uLfQ+pWEDAlMUql5f4WEWMTOyo1zCU8RAIlvO3F96iI5RLXl7GT+QgmMRUZ3xmokY/hVol3046jHFT9022Mop/tctSAGj0HNWjPlXMERgVgjATU6IqHPHAzhV9PavXRpRBaZZn8bfYwqZbIr0h4f5+NQKhliWWxLZJZy6/EeyeW9f9WISerLZexg/FT+duBJqasDwhAslaFHC9++b/WfKfse60RyFaRzdiOdaJCv0oROHDOSqiL5n1WWG+rAilmVaESQB9NsTaXcxJNq3M8iSciSs5tFJ7MdBNIJdOileiHCkk9YThoEUOT73Qj8FGZxHPBSniJJN2YK14pY+JkzfCcWRE4+y1+Z
 MEwLqhGL
 biAtkkZ9GEDGFJ8v4i7J9ZRkpXsih84E9GXKrG3OgqWtbx4fMdlfH8Klyfq4kbHyhJkNgJFURfV6AJmjhk6YkGcPbW4CwwP9tMP01tb3t74+kq8Oc8nmtyBMkRX6JkXVCBbtxLhf5o9XTH7UJwgOHW9Kx3Yr5M9h+SIzNDDggpHNxRrABJ+TbLH7w/c+uCMPT9MXxv/xcf5DMwzjGQA+C5x24hAktGtGiC99AwihokvQ9tiuEZyF3Kd25XuqaJ8sPfk1oJcwYlENCpk+1xvv5i3ezMycBdwzVPq0iafcHuY+qugi0l8mNZTn2nXWRWHgOlRIbaTwTfTSnY288G9YP7lV2Mb+nMewfOlCdd9ONTXvGFFy1hvj638Eg/JbF/KShJhRjVOw4fGL4WrYlXmx8/razozORXORm7auHSxmd1pxoZ142qVKZeHtBzO4VGc9Yjr24huJvh2ohxgn2loVoF1xEHigfwdrlMTx+sushZCGIsSLQjg59Xi0Gx16Tauz6FebgT/AEM6cim9kcECV/V7mWG1drttPnTFqV2eAQ5c6eFYC7yCfD1GDtJSYaA5pqMDs5RlFWti01VEgnluRjO1ugkuZNXgeJtMHPnHakr6K/s/L7HGi/LclKh5eKsJhHx2zcM+jIrD14NGMDEk74zWl9AQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 01:42:32PM +0200, Mike Rapoport wrote:
>Hi Adrian,
>
>On Mon, Nov 23, 2026 at 09:47:21AM +0000, Adrian Barnaś wrote:
>> On Mon, Jul 06, 2026 at 05:33:50PM +0300, Mike Rapoport wrote:
>> > >                                                                             I
>> > > see that x86 has a lock that wraps entire process of updating attributes
>> > > (including spliting and collapsing pages):
>> > > ```
>> > > spin_lock(&cpa_lock);
>> > > ret = __change_page_attr(cpa, primary);
>> > > spin_unlock(&cpa_lock);                                            ```
>> > > As I understand it makes it safe already.
>> > > However, on ARM64 there is a split lock (which works fine for spliting) but
>> > > for collapsing at least on my implementation it is not sufficient as
>> > > Ryan pointed out.
>> >
>> > I think the lock should be at set_memory level so that set_memory callers
>> > shouldn't care about the differences in arch implementations.
>
>For callers to stop caring about the differences in arch implementation we
>need this:
>
>https://lore.kernel.org/linux-mm/20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org/
>
>> I have recently got back to the topic, and I have one thing to clarify.
>>
>> Currently the collapsing mechanism that is backing execmem cache, following
>> execmem_restore_rox() description
>>
>> ```
>>   * Restores read-only-execute permissions on a range [@ptr, @ptr + @size)
>>   * after it was temporarily remapped as writable. Relies on architecture
>>   * implementation of set_memory_rox() to restore mapping using large pages.
>>
>> ```
>> is driven entirely by the architecture code. It has drawbacks, that could be
>> addresed by passing some of the responsibility to memory owner,
>> execmem rox cache in this case.
>>
>> Arch code at no point is aware if the piece of memory it makes RW/RO, is
>> ment to be collapsed. Every permission change can cause entire block
>> to be collapsable so we need to try collapse on every run. We can probably
>> make RCU-like mechanism to batch those events but still there is a lot
>> of pointless runs just to find out we can't collapse or collapse of memory
>> block that already have split operation waiting for lock release.
>>
>> I was wondering if it would be acceptable to create a try_collapse operation
>> in set_memory api that would tell the arch code "I will probably not touch
>> this anymore for a while, you can collapse if you want". And call it after
>> predifined delay from last execmem_cache_restore_rox call.
>
>What do you mean by "last execmem_restore_rox"?
>How execmem would now that an execmem_restore_rox() is the last one?
>

That was a bit of a shorthand on my part. What I actually meant was
scheduling a delayed work and select a reasonable delay that will 
oportunisticaly trigger after batch module load.

>> From execmem side it can be based on the same delayed work mechanism that
>> execmem_cache_free is using.
>>
>> I have a PoC locally but it is mostly vibecoded and I have already
>> discovered some bugs in it. But conceptualy it worked. After a batch load
>> of modules it collapsed all execmem cache blocks in both direct map and
>> vmalloc in a single run.
>>
>> Before I craft a proper patch set I want to ask if it is in any way
>> acceptable approach?
>
>I believe we could drive the collapse from the callers rather than from the
>architecture code.
>
>Other options could be to make the collapses wait until there is no other
>set_memory operations in flight or run a kthread that would collapse
>everything it could.
>
>But before optimizing collapse I think we should close the technical debt
>of having 7 different page table walkers implementing set_memory APIs.
>
>-- 
>Sincerely yours,
>Mike.

Thanks,
Adrian.

