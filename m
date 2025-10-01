Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF53BCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 08:48:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 572098E0016; Wed,  1 Oct 2025 04:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 549078E0002; Wed,  1 Oct 2025 04:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45F2F8E0016; Wed,  1 Oct 2025 04:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30E218E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:48:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA69F13BF48
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 08:48:42 +0000 (UTC)
X-FDA: 83948919684.05.8DEBFA3
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id C3AD31C0004
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 08:48:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mDL3V3+I;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759308520;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uTeTOhUXimu0a1RRXlH1q1gbdDyPs1WSrzYXDw4KHUM=;
	b=pwH5hIYXq8u5vsDFEwcgkFCGTcrw5o9NeP53/tErhzSfJjs04KKODSxeWadpBeusKk6bIi
	l0pjWNjRs4sm0x7y+47bC7LcFLkQqUw8LRd9ti2SjmhUpfR6aLjuPRjoooT2jvNzdeTJFl
	3wyMDvdEg/Q8hWICHP0IP/OOhGg/v+Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759308520; a=rsa-sha256;
	cv=none;
	b=YYLesrTlBEYO6kgEupJ1DncARPmRBnPI5+Y6gSy6RWttRdo+MQLhuivrd4OYeMcRvazrJ9
	5UaOaNpRLn7nCdPLxnx5gYjjzJImOPgjot3Yxeis/3TCTUcifdV5mJmUE0wmz5wBO7F7zI
	DQKhnS6jCa6c00WWGAQAYEiWu0b7DGg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mDL3V3+I;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-634b774f135so9640056a12.2
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 01:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759308519; x=1759913319; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uTeTOhUXimu0a1RRXlH1q1gbdDyPs1WSrzYXDw4KHUM=;
        b=mDL3V3+ITR/iaikKCzqvvbirewQe7gGRo+T48Rc8ncxsETyyUQ8TZbzOpcwLIi8MbH
         uiOkaeDyIabp3eRCA8xoXf/eZ/skjXfWv6h0MNxnm00R7uXYnCwCQA25YcL9a+szX6OD
         aFJ7HslWhYLGjPl+HOE7e2pL4dRtn9hws6FsOOJVte2Ny7WicnU9+Q9+RNhx72gMjG0P
         2JH0webvpx02hISjFAa1Fz1Mf6hNqD6ytPaUPnerle4fdQ4kdjjgg1uYE5XHIXlHnpai
         ILxL4VO9XPzKd0Q5+UB/0X1k7aS1UoskPXBwAr3XLXIVYBEF4AmD9su5IH2ZizYU/4iQ
         uEoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759308519; x=1759913319;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uTeTOhUXimu0a1RRXlH1q1gbdDyPs1WSrzYXDw4KHUM=;
        b=lxV4kxfP8VkQM5UY4fR6AFbTnQE9NeVWfEReMZ3tUFAixA4aJFTH6K5zR1ChcmtAiP
         szO30P+V2YuW4SNWKz3t3hfiUp9LGwGh4wEmaSPYG8PYUThGpsBxSetllc28N0INMYgU
         ABl60N4ZRD2jVGRaTyazSfRwlMA2PqdWFZiOQTcKnI+rKmVCJOGghQPASpTan1ScEOrw
         yDGxplK3HWenAA7yjRwo9FjV/0mTvUyAY/zBfHcmZhNNc/0kkUW08RoDglnIdAZ5AnYm
         NhvXG9RNfQ0mfqJt4mlqzmi2Bs6gIVLxNh+mrbW4MiSkibzdOgfx9EheFKC5B+S6ren9
         uREQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZCB3RdvxDaQHFQ38CdMqibAKfLBZr+Za/UzZT49CfBToV9wYEyMUUhoJLKSiZwzoCjo0Ff2vjeQ==@kvack.org
X-Gm-Message-State: AOJu0YzxcaeRrA+ZR5iH1lTK4QiR+BNJiq3dhDFtKpJtROGMcZmwaNm6
	zZeYhmwhJ2kKMIrnYrN/aEqpyFlAT8voycyycV6v1X+/02GweKl40wQJ
X-Gm-Gg: ASbGncviVv/gUqmLXMAGODCdXDHZ3AiJIJgDno9aVXvFDVAZVt0sL14hAjJzMEzkKo6
	ufG4s+zhwE3wInyNA50YsHioGVn9xeRu8mg7Zz6wNUHtrJuW1XCuUuT65wKksd3/87AcWy96cbr
	OTmVgYfgCcnmSUyCKbUq8EK1/kllW5Q/N7MH4ES9yDlpnNmlUFF8OVkldwx1JfkwacicmWUO6fx
	2CVd5c6X5Y9BJ4YE6ScwdJpmpNv7gPWu59EbeJUea43e7UYBT27NqgRuhQ9pSC/deqtUPVUQKOn
	nqgJsLRo+gg8arQqSdFJmkHawAJYCtf0fqIVOGWJyo/RNWsBK7GHgidyrigm/wZSLIF28b1gvtQ
	3zuCgQU4xwWBfJuPHR1xoej/gMotlxGuVu7yGH3mRSeQ2JLraFA==
X-Google-Smtp-Source: AGHT+IGqyLOAIa+AGf+kVKjODNQoFfnfhk56yTP2yafpHZUgckKz6onIsA1OcF/svlSMSnmIUlzTrA==
X-Received: by 2002:a05:6402:2552:b0:633:b513:c5be with SMTP id 4fb4d7f45d1cf-63678bbe667mr3089204a12.14.1759308518962;
        Wed, 01 Oct 2025 01:48:38 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-634a3b052e0sm11335260a12.47.2025.10.01.01.48.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 Oct 2025 01:48:38 -0700 (PDT)
Date: Wed, 1 Oct 2025 08:48:38 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, linux-mm@kvack.org, kirill@shutemov.name,
	raghavendra.kt@amd.com
Subject: Re: [Patch mm-stable-fixup 0/2] mm_slot: fix the usage of
 mm_slot_entry()
Message-ID: <20251001084838.zi7tce5uoducvvfo@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251001010651.10543-1-richard.weiyang@gmail.com>
 <f1218a6d-b1ec-460f-afbe-3f88f3cc44ea@redhat.com>
 <20251001083919.nuxs7jtv2rgyz4ud@master>
 <7b1a7ee2-5e61-407e-babb-c2b7a264f596@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b1a7ee2-5e61-407e-babb-c2b7a264f596@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: sqatxjuwegn1mbnbjaptujqgyes4ocho
X-Rspamd-Queue-Id: C3AD31C0004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759308520-838453
X-HE-Meta: U2FsdGVkX1+LECrNrrYgkEdBVMdI2xjGdI1mvfzjoVTgnhU7hSd/OVXMtrnL98oD0DTW6OWxco+oo48vYYgJn4jduTx3oO7vZRfqH2N5uu0OBRHk9M2wtxnFdhsq309F7g0Xfai8zY1fFAxO9z8J5pbj26+xn4orERBVc4RH8U/C22wkn8PuhbTkihu6SZcWBSreAAz0uiBsg26mfh0SjHPACVBBcUQ1nS3HFGC+If/CK6wUGzNvI9NC/vOvNqT7MD7KGVIclgrYG1fs1+eOjgM0HU26Pg6AWhGhwgqvjNM+tvyQs+qJabz5absFlkYVtK4TzR2Q5OhWdn+sNb8Q1WcBHyxS/F/jvZ5T63ghjOu5FIxmkf9j8E+5p+Yh5Gd0t7vdBTVrDUjB4XafXgLNnaeyEiyvF8Lp4mDk5eODjmFYaKtwpIxWQ8XhFCYI2/3hRBLoAat6/xHwZzchEAh9TbQjnz5wGlyMbV6Ty52AQKbJ7I6SIPLTxWHp/FRKymo+jlUKsUZelhDzQ5k9dQWahlcu8s2Gs+89tTikEFZsycVijfv82djRszVixDC5c6tKuauJ1+9SyTOFoXbnC96EGliuuS6zi4+La2WH/cGRMUfSxtkIOGxh/PcyVAhXXsWVDIVRVffE9uaryVdk7HmuqGos30hfHBLzfjrLiYBsb08jT7iAp89QKiaFvoiQFmv3Gy7/5QSJDppWkIhu2gH/JGdlwQNjq1TWZOCN+9WA5lrJdTvNmvtrL3mM1Y02QA5KlTpG41hKe7eiKkuIpDa1mdajeLri4rvr0v37WFKVAP7KFfF2q05PAZVW874q/pbMBewDG0xq3uwAwsS+hT6lL7rm5u1iQz9x7zwSac2V0wKyJu7mbmjPlziJ7bLyDFMFzspfOzYx/ysA5U0JFXCHuOJluhRt6urCC0pxaYYsou93THjW62rPXac6OHblAhyAYRZnFUeGkpQsA5EBDnq
 vtevgsBr
 gGkK7OpTyy8Fo6nngZ8TRUfIb66viK+QPJvB+bET7miaw/1FGtbPVdoFFqrN/b46JkJ1TmOcPkxy+tLwNwBQPLaYWgVQDexgvHG4xo0RTeERjW+ZeaVOlxRldFMhDp/SPe3ep9Vl5EI6B53cpVVZUzDtXKFmXW+m2RTs978xizrC/1kyGGEdSP2RfwgbyoMp0BqdQIESCDB2FahL99M0tyqgO2PExajpMz33XGkfroKihSke/dZfECIPJo5J3yFLJrIb/F97ffM+i3B+phov5XRbOJqgXUmVlE/3BMRFd0YxFTtoDJeNmsEsiSSBrWybSfBrPHsqoulmdfiSbKvWZeNdr17CwwNUOmHMkyXVvI3Fk/fAdExpCbghViZHVSYGqmrk48LmWNNGkEA5rImb+FIlWS8lxNa7xfgPgez/U5wBav8W2rn/QT75MpIfK94eK9ki0vRSd1nG1vXv34EsEaRWXH4GHJwRmnGSySMVIo+z75QZ4Wz8yKaFrpct7TOQmzuP+VNWXtjQp+y/kGScdZSLF8jzksp2HoH4HKzD9aXG5DaoUHLN7CDygc+er/oaJWuyXpfGyrzcVPR3TqB/pqb2AZhOXuFcGnQan044pF0D0ikYTeUMS/jXqXFI1NkiaswcY0+DskT2xnHKZNRdkJTTKho7G0bNCjUAevGXatnusPsCA9wt2yJTLbwB06bEaBwblvPrT55cmo9sulzY750TwYJzVETk/UlOkeVrp03FYiSjSFW8m938xhTjNRNDTdnAdIvtcBYnI2fiYNBp8WiSXig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 01, 2025 at 10:45:53AM +0200, David Hildenbrand wrote:
>On 01.10.25 10:39, Wei Yang wrote:
>> On Wed, Oct 01, 2025 at 10:34:52AM +0200, David Hildenbrand wrote:
>> > On 01.10.25 03:06, Wei Yang wrote:
>> > > This is the fixup based on mm-stable.
>> > > 
>> > > The base commit:
>> > > 
>> > >      mm: swap: check for stable address space before operating on the VMA
>> > > 
>> > > The reviewed version is at [1].
>> > 
>> > I'm confused: why "fixup"?
>> > 
>> > Usually fixups are applied on top of other patches (to be squashed in).
>> > 
>> 
>> Andrew mention he has merged v2 into mm-stable and ask for a fixup.
>
>Ah, now I understand, some part is already in mm-stable.
>
>In that case the patch descriptions+subjects have to be updated to clarify
>that these are only cleanups on top of the existing commits.
>
>Then, also mention the merged commit in mm-stable.
>

Ok, got it.

Let me update it.

>E.g., for Patch #1
>
>"
>mm/ksm: cleanup mm_slot_entry() invocation
>
>We got some late review commits during review of commit XXX ("XXX"). Let's
>reduce the indentation level and make the code easier to follow by
>using gotos to a new label.
>
>Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>"
>
>E.g., for Patch #2
>
>"
>mm/khugepaged: use KMEM_CACHE()
>
>We got some late review commits during review of commit XXX ("XXX"). No need
>to keep the old cache name "khugepaged_mm_slot", let's simply
>use KMEM_CACHE().
>
>Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>"
>

Thanks for these detailed description.


-- 
Wei Yang
Help you, Help me

