Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 196D6CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 21:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E80836B0005; Fri, 12 Jun 2026 17:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E31446B008A; Fri, 12 Jun 2026 17:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D205B6B008C; Fri, 12 Jun 2026 17:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDC356B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:26:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 68FDE1C2F17
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 21:26:51 +0000 (UTC)
X-FDA: 84872545422.01.3AE295A
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id 96296A000E
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 21:26:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ssbXOJ/a";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of hughd@google.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781299609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QoqQNxNPBqMismqzNgaeaEvZMlSF3o7CK1/OdEQIGC0=;
	b=N32MJxMQ26rLuciVzks4eAoPR2oCgNfQGaEQBkB20oxjnSvxh+j5j6ojY2ikr85SuDw64U
	thoArcQipHtD8GSbQ1oyNkKniKgJhE8M+dQ3r5+N18TfU8npp+T1YA6XQOrXF3uRhQq9lG
	rrsabk39v84X6sgrzdjT1X0k8HJtyZc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ssbXOJ/a";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of hughd@google.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781299609;
	b=rv0tCE583+YbyW4mG7bxhq38RyXQV2YE8Z5R4MtKB+BPAob98IkBhniaxmQXYVFjyxZl+r
	aGHliC2HTbbm0Bbhukp5LMvmTCatcSuWq7GK+4ew5SPjq6+8YKurv3wtsQLrTHjVLgNQk9
	AGb2d6wc1pSOx2b+aPdKD1eEJ4T+Gx8=
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-7f015f87fddso16476737b3.0
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781299608; x=1781904408; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QoqQNxNPBqMismqzNgaeaEvZMlSF3o7CK1/OdEQIGC0=;
        b=ssbXOJ/ap+exESQxmIUx4ymq3v1aWy855fggY7ZDz8hrx7E3XEKpU1UOTq8XP8w/rF
         c2AVRlvAgi3tvQX2AIM21n6656GFItOL90/8xS4yp84J314OEYH4juOaGL7eDe7Q+9AT
         sgXuJYG2P89CZC7qyfYlhI+I79tPqgBfr+RW2n8uk3BJPHsBqUDKZde23WQaCloI/22q
         mIe+J7Bs/ojl8170tSfjmIMi6tz+VzwmZe6XBKk9u97na8KTFOT+zeDZREK3qSkBH66j
         a38YrBjAyayh4F1dFOEpVIaiZWoDezKIhm9YiOWiSYXxYrQukveCHe/M5xZqygqb9gLQ
         UYfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781299608; x=1781904408;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QoqQNxNPBqMismqzNgaeaEvZMlSF3o7CK1/OdEQIGC0=;
        b=iTHr5GnVj9hFY5XHv92QUetJqQYUtJXqovpnfILLICtRntfiwKi/D1B4CSFy3LECgT
         YKjCT4l9ZnKFr4rCa2J4dx8vZY0lc1+2jHXGtaQ4vZlqX1RuY9/GwhU9YbZAHZ1pRaWy
         0af7/SqiB4NiRhBuwICeMhF6I5AKPoOfYDaV8noJRLckBke0PdaT6h8EfXYlYAnDzeuX
         wcr42pn+yhhKDOgm5am/AX9pjl7Q4aOV2UA3KwndxPNjCFovNbKXcbhjH6m4zXpSf10x
         S1vwas0vstNqefK0kNj02eFYqnb0QfAnPTeGxCi80rHCfkY7RC4SIfmHmmz9gsGgeLLQ
         h46w==
X-Forwarded-Encrypted: i=1; AFNElJ9505jerLNifuPy+Da7PsFsJwglA/ElQDdQCIdFv+ogzMZhubpPROMFzGRQFTiTZHmI26wC4LmKqw==@kvack.org
X-Gm-Message-State: AOJu0YzN58dD2abd3riS6hebwkFrSkeA4BtkU6ylDgbnp407aC+RuFlN
	rWeE7afOYKuGJcyUuBwy1ijA6/Nq9tMaWxfpYWUnj/dL/So9008oVTdlc7sSBGpfcw==
X-Gm-Gg: Acq92OFiM2/L3vanJRWC8yNmQhIMvILocrCZuxoP8y9OusBgAQQ5QVo1upcgrw83Ibd
	5H6WGgy9UfFbdO4zHfbXf/JQqg0Au8eNaXew2ZnH0oq78Nm7VrGoA4/MT4zhg4jZtJGy2d35kg8
	Q2VBkdrEZe8n7/eBvBhk8tT+rMnIXpKIMThYwym1GiiSem1kTxNhZJywN/IGLpvzA0x1chjdoIn
	5/Aa7bSjNR92mio8dIH5cObUIjPUcD0Vvw+6ukxWrcwhQwRhY/FhWlAATHuyd7pEBBadpxJ//29
	ii5NE0S0fTdcQyZ3cxj06rhxa7+MhcsGyBKIrI/fl98Z7pknTpa6EQjwBvJ9KAdE/lYLzDe0vPU
	58n9M2SRPpyZY801zxWoNwltNCygWxKKe+lz7gDgLPwvbI6X++Pj60dxL7+5DgtZTSGeDiqNZ2+
	k779n0TRF2U3+nTgT3goC8V8nolNNI6rqm+Tl6auQENonyey8e9W1vPr9Xi/rE5bzotxxR044QB
	RDePGwUyw==
X-Received: by 2002:a05:690c:3a0:b0:7db:d527:b8c5 with SMTP id 00721157ae682-7f797da207amr45590297b3.16.1781299608152;
        Fri, 12 Jun 2026 14:26:48 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7f76e8991dcsm15341147b3.17.2026.06.12.14.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 14:26:47 -0700 (PDT)
Date: Fri, 12 Jun 2026 14:26:34 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
cc: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org, 
    Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
    Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
    Sergey Senozhatsky <senozhatsky@chromium.org>, 
    Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
    Jonathan Corbet <corbet@lwn.net>, 
    Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
    linux-doc@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>
Subject: Re: [RFC V2 3/3] mm: Replace pgtable entry prints with new format
In-Reply-To: <fc57bb9a-4564-489e-8da4-65068b5283ae@kernel.org>
Message-ID: <4a416383-62f5-1716-8e04-a2ee1f89a864@google.com>
References: <20260610043545.3725735-1-anshuman.khandual@arm.com> <20260610043545.3725735-4-anshuman.khandual@arm.com> <fc57bb9a-4564-489e-8da4-65068b5283ae@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: m96ppjza1nzi5hh657846kjiqydzh6x9
X-Rspamd-Queue-Id: 96296A000E
X-HE-Tag: 1781299609-51942
X-HE-Meta: U2FsdGVkX18YdoFNmNBel5t7ineBsZg7bkmwWFejswFtsevoh1l+6bsv0tTEfnP5JpESZuCcwxg0Z5LzTO5Z+zDNsw+uJFQRl9euEwlZSYI4LlveG1C5VuVwbU4OI+86xY4VGUyfDjyk/d6OW5wi3+0XYD7Eqgo1MI10qRVivhptN9SBU2n8zv/69noJMPeowr573u7lAkk+L+qM5Eo7loJBI6Bemr+aHCWWpgWYa+m6wmIPHVKJHlrBaoDseNvxKwTVBkXPRwINDW6f7OxwGJzNnCso/JKobnDnSPHGDXW9ze84Jaezlh79b5GCTjR+SSFKHQUzKzHxLk8WHx4ClmCTnNKov26nWWAore9vDhAJdCC5/NqjUyHPPJsb+bJXMH+tgSGqu+kZVFhscKqoG7rGIoKOSy5/Dr0Ps7LKHes79SRBh+XEIKCsO2I9+C4MMUqhgDtkHIcxtd3V38CZtYM/C77xpCy+FTA43OdzuwFc6gadWXnv1QQwVGowRxXUq0ZpQvoonUgziDBaKS+qJfHnXzSGCFXj5l10mQpIH3APjMDQBFBQJdsBErsVWHadUV3ZzMsshH6UiaolQ5qi+Du+QW7CL/IdW+FZWNVdaPSU4NNVHPthaFDe4K+KJ9c2emAohcHODJJXED3mPwkPPjCuIrvmauZxPCugHP+D5XVDgRSYTRFppo1diCyWVuBkupVMavq4uf7ej5DnsOVDWuo5gd/0voYizM6h6pxuS3+G/ZvhGvN+MimMaLUO4v6GNVtKUldTm2flwK14E3rzH4GNYcJE5+0poYx+72pVVnMsDHaAmN53QJcf2xoWgQn0xLIymnGtCx3rfsh00GnW9YiiQnFQ7EqjziFnMc9TNjulZHJDTVzLa9bNNPH11d0nDV10nyqxGVsd30l4SAEw5BhY6gGgVNre5jyZ7vct8aZTZdNr+d9Sai+SaZCgjQ2QX0r8f12yax6T7gUaCWN
 m9YY+bKs
 ylfs3JU6whjmtgvOXDtGdtvLjjAefcqo0ayak/u+fOqc9bO7L7TRVH7S8HYfzRFFd/56j7zwlCFcGncJ84dQnlToLf8Wsxe1Ad/P6LbroKHgC6BuTS5EwbGxTPBHZ1eAAzm6hWT4wgzKZmMZglcuQBjHuzGbs+2nmSFbCDeAon2mQvXNeW6YwLDQnNXM0TKiNBcZas8fnCLF5h0AQC7CYDmVP0pARqHqkoZ/QC4x0W56o+WOFXuo2O+WR2PKG1csYP9FL8TYILPU2AUKUMWQAeXBBJKVWBWuVaxx+Vm/nZ9IY5J10aEAZMYE6eNuSFgq5AIb38tjhuHBwDhUp6QZkA85U6ulLqyGywOuZILfwlIE76V8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Jun 2026, David Hildenbrand (Arm) wrote:
...
> 
> After some off-list discussion, I wonder if we can make our life easier.
> 
> I think, even with your patch, there is still the case:
> 
> pr_alert("BUG: Bad page map in process %s  %s:%08llx", current->comm,
> 	 pgtable_level_to_str(level), entry);
> 
> Where we cast all entries to an "unsigned long" in the callers. We'd have to rework all
> that for 128bit entries either way (passing them in some struct instead).
> 
> I really just extended what we used to do here in print_bad_pte() before commit ec63a44011d.
> 
> Maybe we should just drop the "print the involved page table entries" thing?
> 
> I mean, we do have the actual page, and we do have the address in the address space, which
> we all print.
> 
> Not sure if the actual page table entries are that relevant?

The page table entry is BUGgily Bad: we want to see what it looks like
(sometimes, a sequence of bad page map entries may even show up as ASCII).

Hugh

