Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3644CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:13:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 260808E000E; Fri,  5 Sep 2025 15:13:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20FE98E0001; Fri,  5 Sep 2025 15:13:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FF958E000E; Fri,  5 Sep 2025 15:13:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F058E8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:13:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9F03F1A0208
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:13:34 +0000 (UTC)
X-FDA: 83856145548.05.3578826
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7F6EF14000C
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:13:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757099612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b1MnDfvzkRjUKqLvn44SR8WojgXCXrb2im/5uhar/UE=;
	b=f0HO8sCH7+SgAcYwfBXybgNB+729BanQZIoLOe0ON81Sx2imM0N8i78Gc736nx4cWinrAW
	QByQZXeBgeGZ0CnGxUmnDninA0cbsn3pQPuZKvrGbMTKX6f6v0BdAbZpmAOWzPT7+zIqP5
	ZTUGXWYPtKlwLd1h1kuoME3qtznNUU8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757099612; a=rsa-sha256;
	cv=none;
	b=BQYa0gq4vb/yY2LXnYoGu5kO5Jjsky7iGKB+4SlHro3an2kYLrLHDVXaXRD4Zcjyqz8blK
	nVikc0lek8OETRKhF/WThR2NT1IuTa1MuOs9WgtOnx/Vv5N9YQbnMHxVdXG+YfxDF8PLZz
	rjocwuluMRrXKZvVeQfdG7YOmZUnAO4=
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4cJQx530RBz9sS7;
	Fri,  5 Sep 2025 21:13:29 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q8FPsSrEXf2k; Fri,  5 Sep 2025 21:13:29 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4cJQx51qPmz9sRy;
	Fri,  5 Sep 2025 21:13:29 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 1C7B98B77A;
	Fri,  5 Sep 2025 21:13:29 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id 570O8DO0c8e4; Fri,  5 Sep 2025 21:13:29 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 6312E8B773;
	Fri,  5 Sep 2025 21:13:28 +0200 (CEST)
Message-ID: <c0bd173c-c84f-41d5-8532-2afb8eca9313@csgroup.eu>
Date: Fri, 5 Sep 2025 21:13:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/12] mm/kasan: make kasan=on|off work for all three
 modes
To: Andrey Konovalov <andreyknvl@gmail.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Baoquan He <bhe@redhat.com>, snovitoll@gmail.com, glider@google.com,
 dvyukov@google.com, elver@google.com, linux-mm@kvack.org,
 vincenzo.frascino@arm.com, akpm@linux-foundation.org,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, sj@kernel.org, lorenzo.stoakes@oracle.com
References: <20250820053459.164825-1-bhe@redhat.com>
 <CA+fCnZdfv+D7sfRtWgbbFAmWExggzC2by8sDaK7hXfTS7viY8w@mail.gmail.com>
 <aLlJtTeNMdtZAA9B@MiWiFi-R3L-srv>
 <CA+fCnZf2fGTQ6PpoKxDqkOtwcdwyPYx2cFwQw+3xAjOVxjoh6w@mail.gmail.com>
 <75a2eb31-3636-44d4-b2c9-3a24646499a4@gmail.com>
 <CA+fCnZdWxWD99t9yhmB90VPefi3Gohn8Peo6=cxrvw8Zdz+3qQ@mail.gmail.com>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <CA+fCnZdWxWD99t9yhmB90VPefi3Gohn8Peo6=cxrvw8Zdz+3qQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7F6EF14000C
X-Rspam-User: 
X-Stat-Signature: york68b367eek37gp5kb6epe6b95ibo8
X-Rspamd-Server: rspam09
X-HE-Tag: 1757099612-274599
X-HE-Meta: U2FsdGVkX18EvKqV1UXG2YNR0bbbVMipyw8/EOW18BZve9+3pLEWULcwlI91MKKd5823GuvlziGirfN+YLzKX5frXib9nY5hfd+s/3gdA/DIqD2etZzD4ZGBNoeSWQQM3ZxcFKyUFriJPFbLkGFosf91gJMoEGVXERCGf9EQHmktHv3Y1ZZV8s9BTaZxvz/QMEpDOoSckKmMeCTpb1ngmnHhDh+u+0XTuY0VqLrXQesO9NFVjpE2Mnb8uKNQG77RW6aDynwj1hQJOuVLeJ5hunQLLjTaCrFDAX69nqJqT9flUbPGQOwlDE+eeVtEqF9I9GYuFsnGNuaw2UgUJSz09nDBQsJUBM7ng3g7Z5nB+IlTS2MyM+d2tVnF+JE1o9XHUt1P6kAAb5OtGu+KKLBecE0S/j07lvyyyDCyyFmaMWCI9MXyxAkFnTNpngjQqugfQ4zCXh+GVrl6MH/7gv6RHyQMFkSsg17TQWtWdBQJbQmVWXF+Mj/KlWHH8QTBa9Or01x1fRACLtyFZSoUdaALAy6LmhLBB5FRDrc/GCgZo9iwr8qRn3fwvzBRV4tjT5DEEWmv2EWU/0XdXozXrbQuWOjZz198iRopMO4JF5cDjCY/AJ6e+lOpXlH72fDfE3P+neFso/+yb6SfJmGrDfNwfN1vGMk0PISU6r2s5ybamQ7nI5W/okVjPp8JFWu++WhIpBajqCCt/PZsdR9VoMQJ7mTQN6uo/e4a4C5cV7i656mqEjuBkqBgV4SxcsnfM1cSY5e41hMnWXyDbAHJnZIXAaf7+ZE6DV5KT7cYdV8kfiUHGcXW4V0Xz5YMKnX0OHklrWCvIT9ts90IF062roxp+Nf9Isb8KPXMBu8SifZI964+veB+84sqDtnncNH0IAlBqC/5GrBPfRgljb5mjlsRwPvxWMWtvjaahRE1Rj1QCAlgDZfcqvtlrYWsG8z+HlSkV+rFXOX1kGD1q1TCKyK
 RTZYE/7T
 RR0sER9dgEI948VDfdOQiniQ7fbcUgSVjJU3xBSTJM9YGdwR8YzD5baphhlt07pD7nKMHCnGa048ow1zzMHD2A4AoAVPqkb47RV7bzHLjrzp3WBhF/qWsj1y9HpWzPbEjJtU5CLuAKgfDUwP54YxAjqz7g3OFLgKfybY+LRGH+f+wtGi3xQiU2UlhgrPjwJ76lbleEC+/R7WMWuCRM0S8cY1hhFGDNvy40fGsurICILwQOTePSp+Ic2Pk2Es9zx1jwDhvbwGaKOH4Ge5Gb8OEwXJHSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 05/09/2025 à 20:08, Andrey Konovalov a écrit :
> On Fri, Sep 5, 2025 at 7:12 PM Andrey Ryabinin <ryabinin.a.a@gmail.com> wrote:
>>
>>> But have you tried running kasan=off + CONFIG_KASAN_STACK=y +
>>> CONFIG_VMAP_STACK=y (+ CONFIG_KASAN_VMALLOC=y)? I would expect this
>>> should causes crashes, as the early shadow is mapped as read-only and
>>> the inline stack instrumentation will try writing into it (or do the
>>> writes into the early shadow somehow get ignored?..).
>>>
>>
>> It's not read-only, otherwise we would crash very early before full shadow
>> setup and won't be able to boot at all. So writes still happen, and shadow
>> checked, but reports are disabled.
> 
> Hm, I thought it worked like that, but then what threw me off just now
> was seeing that zero_pte_populate()->pte_wrprotect() (on arm64) resets
> the PTE_WRITE bit and sets the PTE_RDONLY bit. So I thought the
> kasan_early_shadow_page is marked as read-only and then the
> instrumentation is disabled for all early code that might write into
> the page before the proper shadow is set up. Or am I reading this
> bit-setting code wrong?

But that zero_pte_populate() is called by kasan_init() when everything 
is ready.

kasan_init()->kasan_init_shadow()->kasan_populate_early_shadow()->zero_p4d_populate()->zero_pud_populate()->zero_pmd_populate()->zero_pte_populate()

Here we are talking about the shadow set at startup kasan_early_init(), 
aren't we ?

Christophe

