Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84BFACDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 13:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BA136B0093; Wed, 24 Jun 2026 09:58:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 698EC6B0095; Wed, 24 Jun 2026 09:58:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A8996B0095; Wed, 24 Jun 2026 09:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3073A6B0092
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:58:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B0DCB1C5B95
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:57:59 +0000 (UTC)
X-FDA: 84914959878.23.9B71B56
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id C4BFD1C000C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:57:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XzAAhLM1;
	spf=pass (imf20.hostedemail.com: domain of abarnas@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=abarnas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782309477;
	b=yQP/sl0cthSrQNtTwPRzMKVhf2GH+Lf/yHf3VJsVZdPik6tfQD3+euoElIHbaP7sEna2Pp
	qCCkBbaLMDXDgKtyA6thz3PuWmcFzZJLlF4/lLOHQwbbu6Madv6GzOu4+07PzTEXU15y2C
	lIwz6BamGSG1bBQANfFUl85ymSehWIo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782309477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g2TLBBiPkk4ZVf9j7DhrwDHbQrDRv8rhbPrYITQ3CF0=;
	b=pLMHkiBYK0pYKr5ig7vzjTK9RotpIbGRBPGFwYr/9gPKSVr3sqDE9Q90HoY1UrPjyp3dZg
	WnHE69OV8RBbn4TfALpKnrx0qu/He9GsyD7OgnnTrvLjHg1theo78NVRyKmnMy6rF+bB2S
	7gFQ8S/4IFY3rlDVORFPAhAGNV6bsGU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XzAAhLM1;
	spf=pass (imf20.hostedemail.com: domain of abarnas@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=abarnas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490c0c92cffso7946915e9.2
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782309476; x=1782914276; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=g2TLBBiPkk4ZVf9j7DhrwDHbQrDRv8rhbPrYITQ3CF0=;
        b=XzAAhLM1Eyq0+9jUPPAgL3dSVV9odNtOKCMMsQO+iSXimscqtHMehyrm67LWyFlfNy
         38Of+yVVIdaDmnt8OWhU4ETo3soiEBiGittU1ignyZa8LLMiuQLgUPIWNJJUB380u5t2
         q2lAdkQcdl3OreDcgp/kapQpzs+E3xq5cgluEut41sX0AnxenRKZNwW59XNrsDh5O29+
         B4/CcXxWjW4EQCYnp6JDki1nQnE6GyHEdA7QEKVYlF6N1EJrHeEjhu29OBtq9mp6+Wpm
         DnTW3vfCu4le5v7bcPy59iMIhPHG53JItnlgI7TimtGMq1PzNHOR5vb5DFT7J1ypr8NI
         8jcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782309476; x=1782914276;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g2TLBBiPkk4ZVf9j7DhrwDHbQrDRv8rhbPrYITQ3CF0=;
        b=aBUNcqlMJdToDSu9OPuJF3lzto33UIgkk6DrhHugp7bNrnTHGjgLL23rEHivtSxRlU
         mhPQYz7r8JwyQARy12lAalF/R7gG+qIKiA3/MJyJmFCwDGb9IVLwhS4idxBU6mwDc5aY
         vsZ/FHgkopHE0YW2D+OXeHViITWE6rZACUn9c/Y7MAZSqC+1LBnyBxf6gGRtgAjQy1Ul
         /aKBpKObfoHWrPWpSbD4NWeqKi1h20luswKRp03epBK+N4pp0LFUMXJairk8iSy9A+eU
         8hB+rhHoSgAy3EQbOUByxKaw+lUtnzYm1oAI5T61g9tss4VS1IEejQtPzYAws1rijoy0
         vPEQ==
X-Forwarded-Encrypted: i=1; AFNElJ9pHuj2cqY4xfnt9ETls5ssAFXZ7/rhNjlcM+LqJSgu9vIfrNG0sMkYSd47PcoxPVvxCh0ilU7aBQ==@kvack.org
X-Gm-Message-State: AOJu0YyO0NxghrtjbWaxgWtr68NlwhMiYegfhvOFx6cOZtUjnvo8tAvc
	kQdiMz8Eu4VRY70qqkdkCYuO1vJ7NYTbb3ExPzP+pElbn+O3r33V92Ithn5TbBFfSYH1KavJez4
	PQUT/Yg==
X-Gm-Gg: AfdE7cmnOIs7dx/IM7PXS+qD5OgnSOCa+4iX6PV+PH+lz1CiUljvQmCTui2BR7wtOhl
	6kQC7xWJhV2vSwdmdxf0R0c6Qn+rQXt3ai4wYiR5JYeXs4UcC0uWsqxH7vgUWtKmCbTBw1e9G73
	NGyC532BgM8eYIIMNOz4oJWbyEljjbvza8Stuae8Ert9XeNLZYQk+Eo+cJtLBHOPH+me2MHdhWd
	6aTKie3CxGFMvyykjqZnCSN0a09qoU791kcENngRlLVQha5RwXTdCWY/ONbrPSz1IEGtAOHEB1h
	VMdEHkdTRxSHK9d4trQ3CV33kUXjh9B5BzTRcNsQHDH9Fwt2PcN8Jtibozp/Y0A6sK/zsvvLGpE
	Y9ZDehNKH7yhXQrPZIOuVtBB9QQtv6/ccGp64XZAM25iH7459s0wrvUw5tPCRFu6OL+8HsLWtAf
	WnRp6YKVw8pi0Q6JfLZlLgbEZwqNNMZN9h2/3mvJt4Q+Kf1J0=
X-Received: by 2002:a05:600c:548e:b0:490:bd66:db49 with SMTP id 5b1f17b1804b1-4926084b8admr46495585e9.12.1782309475577;
        Wed, 24 Jun 2026 06:57:55 -0700 (PDT)
Received: from google.com (97.113.76.34.bc.googleusercontent.com. [34.76.113.97])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c226a6f13sm6686339f8f.26.2026.06.24.06.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 06:57:54 -0700 (PDT)
Date: Wed, 24 Jun 2026 13:57:51 +0000
From: Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Brendan Jackman <jackmanb@google.com>, owner-linux-mm@kvack.org
Subject: Re: [RFC PATCH 3/6] arm64: mm: fix restoring linear map permissions
 on execmem cache clean
Message-ID: <ajviX8umJQiZ5S7z@google.com>
References: <20260611130144.1385343-1-abarnas@google.com>
 <20260611130144.1385343-4-abarnas@google.com>
 <DJ69RCVRBO0Y.3JCYSW50IC4RC@linux.dev>
 <aiuyoy8Kmr9yU4GM@kernel.org>
 <ajK6w3YTFpVaUl3v@google.com>
 <ajLqGZ7sfKsQaSf4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ajLqGZ7sfKsQaSf4@kernel.org>
X-Stat-Signature: wd8eha8d1qoyq55aw5c3cd8kyeefhphe
X-Rspamd-Queue-Id: C4BFD1C000C
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782309477-305808
X-HE-Meta: U2FsdGVkX19RSGIGBLM8QqHg4n6QGeW92Nf531Hb5+rT7Yz+FTIp0I8C3oUtEODYoX1H/yIGS3txTmw2pXZCb9poyL6qCixPBkV+kdWey3BXi15zjzVefGUeMVGbnwIubmGRSIWBQFcR/6cegi0IXx0pFUASPIe7KVJJYolyottXt9q8hyflTfUwPBlgHWd72Y4tPm/c9RfGsoRhxzI9OWuJ0r8V2zR1NUUEH4NPfP4ISRDP6yqDU5kzAKCpcIyixBcTKFb4Wc9+6QhXI7Nr0J0uFh5brmuswb3jjmvCUEqFRVIgL0DqbSkZC0VLEpPdTIeVFY+Y/BjON4I04+l5qqE3akuLu2DXUB3iKueRD3T3/NCa0LJdU6A/r6iezCd7J+MJ9QXtQSTYHSesZiDeVab/Pwmnmlw3lL7cUE8Kz/qn9cXuX6ct9XPbdrPSxnLSwi9WT/tMDoiZwYCdi4DHlUKohSTtyr5zCyT/sqhjucIN0lBS6A0L4ZVmxvbTHpmrxGyetNpw1NzmuWyvQfDC5sNvQEu7L/j+XHY+srkngFfQY3UJwvtBm1ODY8xOFRbMH3lBnJ3RIqTsS33ROdhSFU7/rbh1ngmaKaY1jqSJnrqte8fy0BlX/zujfZFcYUzxCvAni49vgaY4Ufiv8EomVwpddRZaKRA+4Pg93PbuXKLooJ9IDJiEy2nz/8AL4jbi1drdK0gl2qHu50TGEEDCSUwdbJ2kJ/f0OTZCIXZ+Gs3IbIC3iiGiLzH95nXTieXSWwcjQZyMemg1rrEJHzSIPjREpLSKkEevXaJNS0vib8htyBZuEJNsXoG2MoDRhh2dJGIznBEaquEiusnEIemhmQLk/cEPH1tnOoCBbauO3zkSqZJoRj2pRFurc6VxgAiKJ4aY3bC0RVOWpfk5qoX3zmtMkowipYSMb9tR4kx9izfn7PUmdykcbjdr4M4wv/J3pPL4Sy+Os53/TF5kEVw
 azEoQle2
 2TV/+EhqY8zbzwjgZ5/GC8fqOkoQX7D4YNInkOdjiPgAaSgBiLq4isqYXSrJICXurovRmN4ngDlYy+Ae51PTb98KeW8OBINOg+5xSkPVbPtSx74lVW2TdviZTKW7T15Ou1d7Xi+0Ok0smaJT8YrIG7wI2ILCE8HxIxf7lkUwJwbEOsP9siRss627D5TETngk7vx9q3Fn5uvPQAWJluSkzyVCxPHFf9dvYiLUTC+ZPhO5QbNvM2LZG8rSgGnUL1yzm7VGoH+yeDrMSg0gNPvKx+a12adfdLXroytcccb8KEsfIJmbr+WxaejNdJJYJCopwJpu6n9anu9Ydb25RWn678pVHQaQ49OMHrMbqMk77JZjHVd6t+ShaYm3PQdsmx+4B5p/GEoJBovBWoZBm6jiyRuhHUgQebZ4YIZOplgoq7P2rvj98+1eYqiQ/B7u1qIPhFu7HZytWzhFhujV+Pwn2ju/PshdSG+Xv1qdf3oQ6+JkRN0L1IeN87HkcmUEVhNoKSH1UeUJizatkqtCEna8EfvEfCKmFRCKpWRArLydpfVhaSTs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 09:40:25PM +0300, Mike Rapoport wrote:
>Hi Adrian,
>
>On Wed, Jun 17, 2026 at 03:18:27PM +0000, Adrian Barnaś wrote:
>> On Fri, Jun 12, 2026 at 10:17:55AM +0300, Mike Rapoport wrote:
>> > >
>> > > Hm, maybe desirable for execmem but that doesn't really mean the x86
>> > > behaviour is correct. Maybe it makes more sense to change the x86
>> > > to align with the arm64 behaviour here?
>> > >
>> > > BTW we should probably document this API a little bit, I never thought
>> > > abut what "valid" actually means until now. I had thought of it as "I
>> > > can access this memory" but that's an unclear concept and now I realise
>> > > "valid" is a technical concept in Arm that's confusing. And it's extra
>> > > confusing if the kernel API uses "valid" to mean a _different_ thing.
>> >
>> > I've got confused too and that's how set_direct_map_valid() got into x86
>> > with a different semantics than on arm64.
>> >
>> > What execmem really needs is set_direct_map_default() variant that gets
>> > nr_pages.
>> >
>> > AFAIR, set_direct_map_default() has a single 'page' parameter because it
>> > was added to reset permissions for the direct map alias for vmalloc()'ed
>> > pages before there was VMALLOC_HUGE and each page had to be reset
>> > independently anyway.
>> >
>> > Maybe it's time to add nr_pages to set_direct_map_valid().
>>
>> I was also quite confused by this initially. I spent some time debugging
>> until I realized why unloading all the modules was causing the kernel to
>> crash.
>>
>> The reason I took this approach was that I wanted to send out a working
>> prototype for arm64 that wouldn't interfere with the existing, working
>> implementation on x86.
>>
>> Following your suggestion, I can put together a preparatory patch series to
>> refactor the set_direct_map_* APIs to accept a nr_pages parameter. This
>
>There was a patch Nikita sent a while ago that does something similar:
>
>https://lore.kernel.org/all/20260410151746.61150-2-kalyazin@amazon.com
>
>I believe you can start from there.
>

I will pick the 01 patch from there to my series.

>> refactoring would also allow us to drop the redundant set_area_direct_map
>
>We can't drop set_area_direct_map() because vmalloc pages might be not
>physically contiguous.
>

Agree.

>> helper. I could then rebase the rox_cache series on top of that.
>>
>> Does this sound like a good path forward?
>>
>> Thanks,
>> Adrian
>
>-- 
>Sincerely yours,
>Mike.

Thanks,
Adrian

