Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25966CA0FF7
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 08:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 574E06B002A; Fri, 29 Aug 2025 04:15:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FE816B002D; Fri, 29 Aug 2025 04:15:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ED2A6B002E; Fri, 29 Aug 2025 04:15:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 22FFE6B002A
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 04:15:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DED4B13A19E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:15:32 +0000 (UTC)
X-FDA: 83829085704.10.6A4B3D5
Received: from mail-lf1-f73.google.com (mail-lf1-f73.google.com [209.85.167.73])
	by imf19.hostedemail.com (Postfix) with ESMTP id 31F5B1A0009
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:15:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="1AO/If/Q";
	spf=pass (imf19.hostedemail.com: domain of 30l-xaAgKCKMMDFNPDQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jackmanb.bounces.google.com designates 209.85.167.73 as permitted sender) smtp.mailfrom=30l-xaAgKCKMMDFNPDQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756455331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mfOnoSdMFEY12A5kAdJIINWz+0z/4T/piULOnnacnTU=;
	b=18OUkFKRoSuuW/XBh9CW/nM8RwawZTQRoHcFWg4Vj8Ot/UTkbnWoVLlOtPkg3p1QVxUD5z
	MbkkldWP+vWT/b87sVwOB+fK9HVZ0fPWRLU3lVKBGMiOspKJIcq8A0ERuLnZoySmeDNGCY
	o4ktdESmNm6ly7rAtkLLh0XOhF53go4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="1AO/If/Q";
	spf=pass (imf19.hostedemail.com: domain of 30l-xaAgKCKMMDFNPDQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jackmanb.bounces.google.com designates 209.85.167.73 as permitted sender) smtp.mailfrom=30l-xaAgKCKMMDFNPDQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756455331; a=rsa-sha256;
	cv=none;
	b=Uz/gzvMeQj48gGb39Ij3+hwXctKGbPW6zHhRLIubk+tsF1l7VEv/6eaohOzAmHB657th39
	W3G9a3YQg2Oem496qHGDkAQ8G5F9qjADL9UfbhqekjZkIkX9VLWUJj2X+lccJvUzp3yUqK
	FOP3f0cUeMXjddai3dHO1XUlwKNyHDo=
Received: by mail-lf1-f73.google.com with SMTP id 2adb3069b0e04-55f6bdc1771so62455e87.3
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 01:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756455329; x=1757060129; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mfOnoSdMFEY12A5kAdJIINWz+0z/4T/piULOnnacnTU=;
        b=1AO/If/Q1FDfrEuX3OBPb+/rQNX66gxUYVNHKluj7EskM40TxklVvdmCVzeV2N8EoL
         nirah3XaQ8ZQ8TrOFoo29eoL4Di/BH+Td9RnRDqUS2pVjgPOr8iryyM7OjSwd2AcIY1J
         ACZefRWzm6lgfh1G2t8nWcrfomKzihaHUTZXBP3uj8Rnih3SsO1w+pUU616WBTyOt0Aj
         j6+k9IRKnsjwaWZwkJeEdPMSoHswlYAQFUdZVXP/k38ToYfseuxTTjyOPfgKPMFYIT9m
         xO0VxYPyF/4CDGj+Q4RgvENTzeDpSl503L8n47q5FJixI9iYlOhIBa3PV00F9HAxiUsK
         7W6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756455329; x=1757060129;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mfOnoSdMFEY12A5kAdJIINWz+0z/4T/piULOnnacnTU=;
        b=vxpSubPe/GCEvZAb4b5EjbbBs/uhxEJQDD9EJ4A1ZpxeFGNEYmGlAJa6L+TFjKxJyy
         tjCKTNaCl2PBIQ9o+JtGdRKPssnEjYQTXYXzTlmmtRMNiZsryAUaxXo4P0Vwfi0Jo1Dp
         zHyGHa1jguyU0Fc1otd//2IkAmOYG4/Nt0SGTTWXt5myVFyidYMVhlKxiogRniFUphHZ
         UQkjF9sYE5Fj8vvhbFnm/Q0X1Qsrw4Dx0OiOcRgaRJizxDwxEqQz2oIiErMKigG0ktXJ
         P6i2nc6xLf1VbEd6B56jH+77dVfJ92WmOLReWkUC0VCoWnPyspiIeR2M85OrC0d9zHCE
         Z6Sg==
X-Forwarded-Encrypted: i=1; AJvYcCVmBO4xothzM6w7SAvwJYrNxVc3FbXYfmNaj9yhwuCUdWDBb3aCGTKlOCO7RIrafx0nop7tttja4w==@kvack.org
X-Gm-Message-State: AOJu0Yys5sjjUejwnNQXs6XKdfsgCuUXwO1vTb7koqUzytUJcnKaPu8O
	iyVNhnj4fYTathjmHUKgqXKPc7aIJ9laRd5v+GDbtuDkY21udZBEP/Jbd5BoNozpZ1BWMJdIayA
	dzEwbLd7RDsu9sg==
X-Google-Smtp-Source: AGHT+IFJ+ze82M8nDeFw85CqWHL6EDCvm/pvyvGMy6Ixf0Ev+KdhEZ+X2YsmGSD4LRNTVXGN7ctJ/yclVGX+Ag==
X-Received: from wrs1.prod.google.com ([2002:a05:6000:641:b0:3cb:ea8b:ea9f])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2c01:b0:3b3:9c75:acc6 with SMTP id ffacd0b85a97d-3c5de34badbmr20447829f8f.59.1756454866646;
 Fri, 29 Aug 2025 01:07:46 -0700 (PDT)
Date: Fri, 29 Aug 2025 08:07:46 +0000
In-Reply-To: <20250828155412.2b1b2095125428af24896af5@linux-foundation.org>
Mime-Version: 1.0
References: <20250817065211.855-1-ujwal.kundur@gmail.com> <DCE2EJ3KWX3K.1Y198FHBV8UG7@google.com>
 <kd6uteyd4vzlnbdwzjydwd7hoqyxewc5fx24z5sq7svmtoa3oo@n57xyeu3vtyy> <20250828155412.2b1b2095125428af24896af5@linux-foundation.org>
X-Mailer: aerc 0.20.1
Message-ID: <DCERAA0PTPE2.1Y0KLQS6IO5O9@google.com>
Subject: Re: [PATCH v7 1/1] selftests/mm/uffd: Refactor non-composite global
 vars into struct
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Ujwal Kundur <ujwal.kundur@gmail.com>, <peterx@redhat.com>, <david@redhat.com>, 
	<lorenzo.stoakes@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>, 
	<surenb@google.com>, <mhocko@suse.com>, <shuah@kernel.org>, 
	<linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 31F5B1A0009
X-Stat-Signature: jjaefuo4jpihyytguqmxmb7u91rtoesg
X-Rspam-User: 
X-HE-Tag: 1756455330-401469
X-HE-Meta: U2FsdGVkX18+tQhkH256wecn9751xFmOiVDWzrn8CDZo5lTHV6NtE7M4zi3yh5xQxeBU4T7JcNmQkmrUZL3VJXVfdVVyqy1ZbniVZxjseocQJiwZ8XysUQW4Z5PGWJHnRxunywOqde1PeXOq+2FV5v0DRFygPX2RpFf5ICrkfIEzaT/Mjlf+Z8NlmGUOGJMbDE3r38E2V6KvoJ7FxD2J3FeM9wLjFH66mtolJMfv4KOoHPpr2XOS8MmjB+j/cGUFQtKKLbhRGxr1oZgA6I5gzCIepVlhclZ9W9T9Idc5DBZaWFN2SlX46BBTIboSVV/9zpQqnIOStJ4MoUPbg0wU1Ubm7ye7pe6b0G0EjJEF5GoT88uLNUUSwACT1/fyRqjTpiU4j/m00dK4Vvl4GIeFIVWagJaKSr+PhGW0MfCPR9nIQ5orPlQsVDJUGbWWea9ZQTvone/CciU2dlRHeQAahHEbU24rHhj6QF60IT0OyiYrZI0V6nVvbSE/Fvk1QmIVggUJFG+j0JGS63hyBZ4hSRch7W1HZFF4kHToxV9vhHxhdiGdN6jkgLoA9z9lfLhF9usCZ8oarDab6crMgTkk9MtX0EsqllFvb4kvY9lJdiBycx1tlB9cp+GyZMCCgOYVlw9+qttqRl7v6TJGZqlpowUZkQnqOt5uRCkIS5/0lvgqDP5lM90dNuTr0zBLkFdRzrdZkoLkmhMpVsZUnLxx61b8UnB+TUp3HRt5Q4lYRKbL7DLgBns6CEC12sN1finGQ+1A2QXj3anZpiIakXe1Djqb5dNuEct0jTJsJ20iFz5A34t5HeGetqmixwD1htqWGY8reGvRTxpeBdAEYh0xZeCbY0Uyk0zTRh6uFbLkarpEGUy15cU3s6lUkbdc+WOJjLtBTbVcY1J+WlSvhA1LjNj5v3ZyJlUvNoK7xRnFzFiN65ZgaDQpCEPfV7qw9jr00xIC8c5GkcxE/WfqCdB
 Nc3j3XCz
 qv2R/Qs6V6t0p79O/NU/Te6+k+Sv4vt3FG9xR4K2GxXxbpFKNeNaGrLkxoF7sUzm6czUAmIW1NUyBm0zMWiwvApSJp8RkzD0Im84m0VLLqDsSJJpZqyLOQZZnoyj1+2EN0SeOOB2wsF2qTi+j7BGUI4E40d/q7dquEAsNkOtvK7RFoHImWook/wKc6knJdBHHnZfL1hxZ7nb/8Fu0SMu5FfS7joUJuhSHDjCR/QLDXzkOC1x6PZear1bzy4MChgJz7pvwrsAvwlsMkU7eZlzNhqZ7faDwNQixH1zOOQTai1eymo4qnyBj51QKippzneGecNUm6ksrlyJQ2uk6XzRxikT3g90zlMPgYUVNK/cwKWNXyqLO5eT9kHVmYHHJvftKdXYCVE7vTSTahbuX5BnF11Oc5GNRvF7xFQhaQ+DhiA0wb/cinjcwPJzsVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 28, 2025 at 10:54 PM UTC, Andrew Morton wrote:
> On Thu, 28 Aug 2025 14:49:37 -0400 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:
>
>> * Brendan Jackman <jackmanb@google.com> [250828 08:37]:
>> > On Sun Aug 17, 2025 at 6:52 AM UTC, Ujwal Kundur wrote:
>> > > -static void noop_alias_mapping(__u64 __unused *start, size_t __unused len,
>> > > -			       unsigned long __unused offset)
>> > > +static void noop_alias_mapping(uffd_global_test_opts_t *gopts, __u64 __unused *start,
>> > > +			       size_t __unused len, unsigned long __unused offset)
>> > 
>> > After a rebase this is now falling afoul of the -Wunused-parameter added
>> > here:
>> > 
>> > https://lore.kernel.org/all/20250731160132.1795351-5-usama.anjum@collabora.com/T/#m0449dc0d6a5ac3b1f71f7182c13b6829e1b444cf
>> > 
>> > I really don't think we want that flag, I'll comment on that thread, but
>> > just as an FYI here too.
>> 
>> I was under the impression that it was decided to drop that flag,
>> otherwise I would have also spoken up about it.
>
> err, yes, I thought I'd dropped that.
>
> No -Wunused-parameter, please.
>
> The v2 series needs work and a v3 series is expected so I'll drop the
> v2 series "selftests/mm: Add compiler flags and fix found warnings".

Ah yep I said I'd reply to the other thread but upon re-reading it I
realised you were already against -Wunused-parameter, thanks for
dropping it.

