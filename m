Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04B24CCD195
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 09:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 321918E000F; Wed, 22 Oct 2025 05:38:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D2728E0002; Wed, 22 Oct 2025 05:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C1048E000F; Wed, 22 Oct 2025 05:38:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06C1A8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 05:38:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 978C416077A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:38:08 +0000 (UTC)
X-FDA: 84025249056.08.E774422
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf10.hostedemail.com (Postfix) with ESMTP id C9BFAC0010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:38:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mmkwmhbo;
	spf=pass (imf10.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761125886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HJdPu+39G4lB6AuXLRBW7mSkqYwO4pjl1bYy6jRlyTM=;
	b=sQzvOMpFr+kszTzipTvERN9LrYT8x2k7uNDdKkBadZKjKrw81M+FE70+VMi2bVtzCnj4G0
	hM+nBVXZVrqU90XgtVKv7+V5RU9bA0kxBmT+3S6hXDLvsxhtgu/tjW/qblDiPwoNflIfS2
	fNUncD0VcTi/JpPmzA1NwEjUeWaoq9g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mmkwmhbo;
	spf=pass (imf10.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761125886; a=rsa-sha256;
	cv=none;
	b=uYsSbJeMrp5j50OiuMidB4/UGUpUkCyl5mI7GXkLbDw7LThhElQSU3ykV2lQM9wf+j3mu1
	hMorvxTdcBBF62qbjAhomepIQ+GYVRO7bcUkmpXSvu0UJSspTDiGCEOpQDXHFj2KAFkSRO
	YE/DPR9BAdVQ1ZG6Gp+tTGABEGOLUTE=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4e8a9b35356so9862791cf.1
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 02:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761125886; x=1761730686; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HJdPu+39G4lB6AuXLRBW7mSkqYwO4pjl1bYy6jRlyTM=;
        b=MmkwmhboysJ5nKV2fwdf6Zy7L2QY/i93HTKfi1PDIBNYP8s1Di1lEV5whpmEv5Y7Ga
         lOqcaIwqGqTgEZdAFbc6o6QFBYFyoxZla5ONhwF8V7Ml6gnXmpM+yuBVuFQNAfqADGWm
         WwUY0A9hM23y+Rhx2s04dVCMxAs1BFEiRAhfjASHSfDaWrZllujMBOBlZAK21b+uGm97
         Lt7Au3KZP06SKto9Roed5RYHgidxAHEf6Z1/oEp+8SmBAJGair9MR0gXyLGVYyW7EYZg
         M4146XaxGoMSkRRMAeW7EwClACsHzRFUAdclbibsqIIpXlr8DxcLFl0Go+8it5noUjSw
         TMBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761125886; x=1761730686;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HJdPu+39G4lB6AuXLRBW7mSkqYwO4pjl1bYy6jRlyTM=;
        b=LT+1vwrHv1Q1UiU2T2+PUJ2TTl/Ur+NxrUTMCLGp1aifOXwHrFmOH7Z+rNpVaYBslF
         jkjmMYkH9IC/ZHfwFfPcwC3nBdpNAUDNe+2zMJWRpzHWY8dKkDaSgM94gLg8cCZw9Xne
         1A7Hd4z/TnY82eZuP2X+OGsMXHJ0Vlmrkv7l2kBU2ZePmCspioOBpqaPmQXGQVclacqZ
         OyD7zi1T6C8VZol5ax6cU3JNUuW00CZUANeiBxXPoCQilJk1NAlo0aH7PDlThn+kZ2Gm
         kCsuMb6MYle/Uw0dK4iDzjwNKLh8eNC2Fvw3EqD2cqeL8u5hqDhwmMGZFuaEA+hwezwO
         6oPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNVUx8hgADSYHkOt6YCxKjL+6BzKpHn8mkEd2qZPeiKaATao8bOsDK09jCcUUUJ01ls4GjpE86tg==@kvack.org
X-Gm-Message-State: AOJu0Ywe+39pCCCDdUt6gBNzheFHdFJoWHsP3EZ27LHUTVsDhXPAG/wl
	HP6nBAQhl1rrRCnmPdjRaeT9u2SR/MIRC9PpIFIQQDmq7lRaV6rD77ruMcZT0gTN+/8xGaV1kXb
	vvd3Iut8FMKZ6qassKl7FRxT4i/KMFL4=
X-Gm-Gg: ASbGncvQtcMi+VxjKAsgsHeJrZ8+WqY2UH8qetxZ+kiDBfkk/dFXh0DzyzP+T8Yd2Nv
	Xshp6oL/cafTOEeXo6ZvBfyn4clCvjF1RRk8TK2xHAQdd7Epc7dub+dzWphwzD5Fn18w3CUVITh
	v5oqLz79BKqMUAQxMWiAJtYzCQ7O3KgrPVtO9cw2jgKQJL2i+0WkglRDLnZZcRXOzCuGK9+Se5I
	Be4jPQY6Xg9yboLQbpX9qAF8NWnl8iW5ufSo928EvmuOeYrai2SCU4OQUfTlEqxnBYkvvkFjwdQ
	fE4tIVsPDrgTZQznPBr7jgWm998=
X-Google-Smtp-Source: AGHT+IG7gcxDomeEPXSQvywf68coWtEHDrJFLjeKkKBNT49t32BEMq0zgoHm8kjhpWZ3V5AxfkOg+1IItd2+7snHvHM=
X-Received: by 2002:ac8:588d:0:b0:4e8:a2e8:3473 with SMTP id
 d75a77b69052e-4e8a2e8360amr228927981cf.13.1761125885712; Wed, 22 Oct 2025
 02:38:05 -0700 (PDT)
MIME-Version: 1.0
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
 <20251013092038.6963-3-ying.huang@linux.alibaba.com> <CAGsJ_4xaA8QRjP9H=n1hQfEfGop7vOd5Y=J+KQzuOyfa8GK-kQ@mail.gmail.com>
 <87a51jfl44.fsf@DESKTOP-5N7EMDA> <CAGsJ_4zPH0fwBOLQwh1y6jG3tCXHLGRCTyVVSCWb+NfLCEMV0Q@mail.gmail.com>
 <871pmv9unr.fsf@DESKTOP-5N7EMDA> <CAGsJ_4zW6ogVdi=t9JCuvGD9N21mA_ORXRCakw4Av68d9n+DDw@mail.gmail.com>
 <875xc78es0.fsf@DESKTOP-5N7EMDA>
In-Reply-To: <875xc78es0.fsf@DESKTOP-5N7EMDA>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 22 Oct 2025 22:37:54 +1300
X-Gm-Features: AS18NWA2mUCn-m7yzg54mG9Xj4DEjFUtxQVduHJ8uk8kWT6HeuKAOvMULXrelik
Message-ID: <CAGsJ_4zKGS-Xd-58ufXGoyRfaZWd8wTgv0b6ibHJ2aS14mQqtw@mail.gmail.com>
Subject: Re: [PATCH -v2 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Yang Shi <yang@os.amperecomputing.com>, "Christoph Lameter (Ampere)" <cl@gentwo.org>, Dev Jain <dev.jain@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Yicong Yang <yangyicong@hisilicon.com>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Yin Fengwei <fengwei_yin@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 6hag8piqeh8gmfpfw6sof7pdmftg14tq
X-Rspamd-Queue-Id: C9BFAC0010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761125886-737387
X-HE-Meta: U2FsdGVkX180je1xxW0ck+2IfoRYPAicowr0yO+ZPkmflf12Ki1LqnA/rnFpb9n5WieRHjPu+LyJztHfmL8TifKU3kLnbAREYSx1XMJx4igpWDFC9/8V0L6+khk3/wAwycjcs8DHAVySYuwzqO/nd87/KdskiumzlhGyy3Va6I7EY5/ylf+BSwH91ZeajGrUMNWGassJzGBUhUtdabJLt1JxtwHZiAeWQwRoShnn1XeO+F7Oy+3Imv5zCLCj9Y9Y/seEHrJf+b7U6r+wzdwT/1TcfksBkh1+THi1eAUD4jP/bJ7wYm9bM76kDDE2uhql0ZMtaZ/y783M3tW3x/SJsseGIqBk6iaViQdnA5TPX/Fdh6i2IXqNEQFxn7TaxKN2U5xujNn0TiLTiFhhysSwYuJO021eMyZA9FqJSlavM7Yvfo0ZTGKURnQoSFZAF3ztk8CleMROaFt9IMLTL10qGPKC+4rP7UgvIXnYHg5EaxoDfwPcG00vjz1XyqA6nXeJlWDT1QJjXo+2Zv1Bp2g9HLElV6z0DogFOFVEqg+qPKW8RHrThz6x+NYF/XcSg6CsNBcJ+Vq5gX1WJa+8PBEDER8YRAWVxre6jQlfJQJ8HPjk9PO5VWQyexBMwNnDvkjRfWPQrB1cgcEXlieusHgCz8eGDSHA7BveeSsIOHZCrseZrgD3xFpBzQaC0MAX+jQ//Q7q3ckXPn5a/Ndx6+AULjR+HkNdy1k40dqAMqbYDNfuJAsfr6rSTV0aB6qB9SAO21HT6/n6l0kUFndDOqcEO6k/9ouddx9JVUn6xIo75U1XAXx+n1CDRk/ZUF2lDJ/4GFDwamtGP/7pFUdhh9P1mHllLe7GTUPDjq6drFFhHTf8YzV1S9qrEhinBUTlQ05VoY99HEOTeeZvoHwmgGgRaGTkSH4OaQfW/H2pTtInkx8gGkZB/2/a2rZ+ZnschYnjGLBNM9Ny2TV4SvC4aTn
 4EPAG33r
 3Bv1HqCbvxUIWDuB41w4fz53IhKYWcRvlOKonYUx8APdSdc880O5c/70wsXcGYWWXLU1b1rXGvSxNLpd/Kw+Po9bXPa3OE3X+flvx0ya0WF1kpvl4d+QnpQ1MuMwVoqrQENzTfM0BCG90+rhsL+5wnA7u9/JwAVdvm7EpjFCYOCXiJ+Vo0fwj1jKfMXZ+ZNdxwW7xZk7fczKvFHyOEJs9GyCNN3vsuV2FWm4TqxiRs2rzcUw3gazJQWrwIOeZzKOhxj9aLaRtafdzOuKNiH/DjC0CeIEpC6Eo/B6buMdJahf9ynvkxK28BIn37rxlfPSPQr/BU0Td9OZqxF4tld8QGM2in8d6SS/7wHafUdCcjbHvNt8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>
> With PTL, this becomes
>
> CPU0:                           CPU1:
>
> page fault                      page fault
> lock PTL
> write PTE
> do local tlbi
> unlock PTL
>                                 lock PTL        <- pte visible to CPU 1
>                                 read PTE        <- new PTE
>                                 do local tlbi   <- new PTE
>                                 unlock PTL

I agree. Yet the ish barrier can still avoid the page faults during CPU0's PTL.

CPU0:                                                                  CPU1:

lock PTL

write pte;
Issue ish barrier
do local tlbi;


    No page fault occurs if tlb misses


unlock PTL


Otherwise, it could be:


CPU0:                                                                  CPU1:

lock PTL

write pte;
Issue nsh barrier
do local tlbi;


    page fault occurs if tlb misses


unlock PTL


Not quite sure if adding an ish right after the PTE modification has any
noticeable performance impact on the test? I assume the most expensive part
is still the tlbi broadcast dsb, not the PTE memory sync barrier?

Thanks
Barry

