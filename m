Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1260CCAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 06:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 394CD8E0008; Tue, 16 Sep 2025 02:42:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345788E0001; Tue, 16 Sep 2025 02:42:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 234378E0008; Tue, 16 Sep 2025 02:42:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0E9AE8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:42:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B0D225B93A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 06:42:22 +0000 (UTC)
X-FDA: 83894169324.16.C24E7D0
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id 14E2820013
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 06:42:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=e8VQRxCK;
	spf=pass (imf13.hostedemail.com: domain of hughd@google.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758004941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DjkprOvz/RkqKX+dHlOFxhwsjERP8ama3QUFKbBY1II=;
	b=W+uys+hEmUMTtqNiG2SwKx9flykujYqUv0ehlK8g6gAA6sJHKhtEj0TwQhW86+4WdUYuZI
	+4f8hlot8ZYwRC34dzb2HfsCOh+MAm8mgyk4yuFCxGlz78yfVRY72SArwj2gf8rf4qXcK2
	pt/CnMwm6uW5fEfUD9f/Wizlq4sDUfY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=e8VQRxCK;
	spf=pass (imf13.hostedemail.com: domain of hughd@google.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758004941; a=rsa-sha256;
	cv=none;
	b=YK/B2umKtFNXGCamgu1bXo8FyH6a1aZnk5c0ymGPIPC3rvhMifz/8NPy7dZ5wiIKHrkrPA
	nFqIf5g1aQUHgoZk8c9qNDGA79ITowsqhoLi5fTxOQuR37ejHvNO7JYFr6Hbc92cj2UzOj
	DO1kbsGqkVhVYmX4I4LI5SAKN6oL6QY=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-72e565bf2f0so39094657b3.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758004940; x=1758609740; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DjkprOvz/RkqKX+dHlOFxhwsjERP8ama3QUFKbBY1II=;
        b=e8VQRxCKR2PGcZMDAa1v8g4ShLCcFjt7D52g9cW/v/V64UQQvU2cTF7PeFE0fpOz0v
         gC6Zn8ZaplGuMHtthMm/JqN/zqctdXlQNsan7rc9rT5lZp0YSlVqQbgut0wsy22Y6JaG
         Pn994qwOVBYKAsvvS/kDIvkibQ69iKv+TomcgI5H/oOCgYqaO9Bk25cGGbsMq3LtsNy2
         pDjbWEck2RHI57QwKV+WI7n7HwTkcYnjYAf6SETvFdclMzyxAdbBA8wtRdPqVD0ZmY6O
         uuuu7RrDYDjx7suLGm4cws3PHYJbU10N2y+XnSHXP/D6rTCCtreuZx7RwFRWl7kCLfrd
         M6rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758004940; x=1758609740;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DjkprOvz/RkqKX+dHlOFxhwsjERP8ama3QUFKbBY1II=;
        b=sa9zUJ9ajM8JWejf1CKx81YVsybm4DIUqcX6Dszlw2+LDsTqGB8fwwt/mbrJ+Ds638
         PSsRIskXLCaXPN7ZGqwhunCYpGETIIdJqc6CRvJBKb+2dB7xONjRKcjukOed1z1Kvo61
         lR7gkvezSViWstELx9W/xS5PMtvbqT7wMdsKqonpTD1Wf0Z/kO34RNWmnxlmFnCxxOQT
         MO/Bpm8VN9v+j53bEU8nbxuWyJw9L5iPJCIytSa0BEC5egVwx3qTQmqEZFjZUSFuxbr/
         CiMraHOZkIQvV90RL+sst1HU4W5n6CNLL5NkeyoRtRYgtC5Qcc5YPASGX3On2qrnLBEb
         czpQ==
X-Forwarded-Encrypted: i=1; AJvYcCWu0BLRMjWdiuEviZM5Ts3K9k+LVc3LqNrCvTI0hcTf2aKAulV2okPzGHJVVQB5bKHqZIFDCDdjUg==@kvack.org
X-Gm-Message-State: AOJu0Yx2Dvssux0U8lDzjvyv5zOAM4k6whzq0xeLF7CaesDjspYwcknz
	6CNArxRLj0nrwt04mqQ/Sr9l4Cup27zDUbQ3gdK/D2rBkTXf3t9SeM1cNTvYkFdZpg==
X-Gm-Gg: ASbGnctMGavolTzhjHyT9jmCXjKU5m1xk0jV8Q64dzM7KwFLBzU4wXtXR1AatxJks+U
	BhicAdNG2o6O90Cld1ddg+U8GDEo7xZIebYxc7s+ZJmovbpetaEG+Sw0rVd+TZPS7UOKKsIEKND
	rzEBeaC6YWgG2VttBm2ayGxt3dDUkusX5iXHqbxBqvjSBAc4GhP79U+wLm+zX6qsBLUIrAYtrYP
	r2qRo7e7M0DCjDqjl6M9Y8YUY+wnZErgcQR6AgE1wpY/CheOHZTGoYbOIf2bHtluRP0H1CrAm5D
	iFQmIz5R7NS8ITi3sr+SLnBQtXtVyKJea6/rJFTG8AnKYGkU9zD9EiP3v/f+EJeN7BTLFNBfp4r
	MfesROCzK9j7fzAMB06Q16hBRl1AEGcxAO4aXHWQll1Hep9zmCEmu6nOdNe9BfsPtVqJt1MlB7L
	L/D75o9VgGjLFBbCyFa5bpQm/I3Kxz78AXiHs=
X-Google-Smtp-Source: AGHT+IFa5Yc7kB+jDP4gPjlSUbmKLcKObhsiMC1oLC1zyc2+6uKV6Yk1QPHdZljy/C43ynHyygPPGA==
X-Received: by 2002:a05:690c:6288:b0:724:2cad:8df6 with SMTP id 00721157ae682-73062ca5277mr142928827b3.16.1758004939742;
        Mon, 15 Sep 2025 23:42:19 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-72f769302acsm38528677b3.29.2025.09.15.23.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 23:42:18 -0700 (PDT)
Date: Mon, 15 Sep 2025 23:42:08 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Lance Yang <lance.yang@linux.dev>
cc: Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org, 
    david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
    baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
    ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
    ioworker0@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH mm-new 1/3] mm/khugepaged: skip unsuitable VMAs earlier
 in khugepaged_scan_mm_slot()
In-Reply-To: <a0ec4014-384b-4c04-bf0b-777c989eabcb@linux.dev>
Message-ID: <70da1948-b0f2-f54b-e0eb-ff901e007ccc@google.com>
References: <20250914143547.27687-1-lance.yang@linux.dev> <20250914143547.27687-2-lance.yang@linux.dev> <bc86d5f7-5b23-14fb-0365-b47f5a6f13c9@google.com> <a0ec4014-384b-4c04-bf0b-777c989eabcb@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 14E2820013
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: akd9iat5ehuouf5b9rhdjithokt3eebu
X-HE-Tag: 1758004940-672424
X-HE-Meta: U2FsdGVkX18gnaUw4dEciFnXtANF9h4JmTB1dFkd20g1m667Nul+jJVf1AYnq/EZeNTvLs0Udn4bY4mcvJ4AO4+1DBnuWkFQ62e+K0EaQxxe6w2jeemKCVmV2FePH/xL1bzUdXcOZ11INtM2NgGiwzrW+sGavXp1wNJ4bFZjQ6G4TZ0/fazE1D969AA2xPNunXPmHAMUr2vT1MwvIXihlAyBUIq8U2hAIvR7Ed87PPHdvO1wRrGjlkRdRXvzJyi3UrQ5gLRYUIAdxtyv1PjcJfDeJdNwCpJKIo444bTypy2KaK/5T0u11ifxww6xQbdq7LBmWGhASUv2UnQML15OhqP6YR7IV55OOYy+sBFNc3PKegApVMRHJ4E2M8haQnQ89nHAXigGqicK19+rL9S7YOVptYJzCik5abuhtkhrE/CdE4TbMRmwffefSYZtFWh1Vs3EFMl/u16AXubCubowOFvr936szmOh84qeAb6SkZVQlNatwCLYG9JXvMjO5BiAZdI/VOVQqr3fio5Y3BiQegRThBXn4mS0Yq/2uKIrr0z5tygbU7Lx7MUFMVE5atPiyUgBEcWc4XKqYJdwm+WwjRTbSndCjfo6IlSJpGiRJ0PJMStuFzLp6AQ7p+SdoarSGyPz21cqZSfTYAuUtEGTaGyT0kvUE9kTE9m8JZDvPp4fo0SJbilo+saKhh4A28lBuUakZpBOzyAiB9kioY/gdD9X6FTa8PF6tT0xy2QOIlSgvT4vuWf/UU+3BqI6JyghKr0Z8uVx0XYzitWwexuIV/tGBpX8dtM8GEuWMFH6nqch3YzZaVFCkN0dCA9zrMGby2SWY13oZohVsp+1i6RSPNOK73ptzoyxNiBSPNyX3jmUVVd7bWHjU8/YN/6NsyPHUU8n0eILHUPkfH8KwM8o5GO6/BzSUuAB7/hHlBT7vOAU7IkcB5/xbCG/O//y6ZyqNwGnyU2hJU3dxdAa2Nr
 87i9ST4h
 beq2I8d/tFCSYPJ/lomXMEowgV8jRcn1q6q4q0SEzYvb+vKzIwzJCnwcLNoWrq/0aVwkd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Sep 2025, Lance Yang wrote:

> Hi Hugh,
> 
> Thanks for taking a look and for raising this important point!
> 
> On 2025/9/16 13:32, Hugh Dickins wrote:
> > On Sun, 14 Sep 2025, Lance Yang wrote:
> > 
> >> From: Lance Yang <lance.yang@linux.dev>
> >>
> >> Let's skip unsuitable VMAs early in the khugepaged scan; specifically,
> >> mlocked VMAs should not be touched.
> > 
> > Why?  That's a change in behaviour, isn't it?
> > 
> > I'm aware that hugepage collapse on an mlocked VMA can insert a fault
> > latency, not universally welcome; but I've not seen discussion, let
> > alone agreement, that current behaviour should be changed.
> > Somewhere in yet-to-be-read mail?  Please give us a link.
> > 
> > Hugh
> 
> You're right, this is indeed a change in behaviour. But it's specifically
> for khugepaged.
> 
> Users of mlock() expect low and predictable latency. THP collapse is a
> heavy operation that introduces exactly the kind of unpredictable delays
> they want to avoid. It has to unmap PTEs, copy data from the small folios
> to a new THP, and then remap the THP back to the PMD ;)
> 
> IMO, that change is acceptable because THP is generally transparent to
> users, and khugepaged does not guarantee when THP collapse or split will
> happen.

I disagree.  Many of those who have khugepaged enabled would prefer
it to give them hugepages, even or especially on mlocked areas.

If you make that change, it must be guarded by a sysfs or sysctl tuning.

Perhaps it could share the sysctl_compact_unevictable_allowed tuning
(I'm not sure whether that's a good or bad idea: opinions will differ).

Hugh

> 
> Well, we don't have a discussion on that, just something I noticed.
> 
> Thanks,
> Lance

