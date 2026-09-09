Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDC2EC79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 11:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96AE76B008A; Wed,  9 Sep 2026 07:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942CB6B008C; Wed,  9 Sep 2026 07:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 859026B0092; Wed,  9 Sep 2026 07:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5736F6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:47:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A3D9F1A01BF
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:47:37 +0000 (UTC)
X-FDA: 85194048954.17.9166EC7
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8DEF3A0005
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:47:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bFVT+I9y;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf15.hostedemail.com: domain of petr.pavlu@suse.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788954455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TIfeIpZ4OJ7Fe6X5EWfuqkVso3+rNzjQrB57cPZXMxU=;
	b=Y0Hpm2tvRKeWcAqeHYAzSrVC3lnAgopAVpPbqQdTpYPqZ3no+AgOK0rzAwTeHmo3R7sptU
	zE7rLrYQcxO5ZF+VIduwnVsV6m+nEheJH+SMYVab9QKjJ++I9cAkFn3sF+/QPNTSYx7/UX
	RSUkL/reYnaFGjkHSZLocDKCny8xRlw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788954455;
	b=rsl++MHp5hio2zWa28pM1RLQHxdhOPRrrm5nrCGctbKCR/u4rc86E+o66AO0qXynfDmyvu
	ftvaWtasQ+80XOIOoUY3iV3J0Cmsh5wpTWMiVvo735kp3Axsqn3HMPoas1R3oR61P1ldaM
	wa4f+lL0gNESo7TPtJJC2D78JIH3gRk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bFVT+I9y;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf15.hostedemail.com: domain of petr.pavlu@suse.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49d1fb0cf5eso934525e9.3
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 04:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788954454; x=1789559254; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TIfeIpZ4OJ7Fe6X5EWfuqkVso3+rNzjQrB57cPZXMxU=;
        b=bFVT+I9y49Srk3ZUgGxx+yGX1HCjHlOkfvIWJckqmC4y3Xx2RGdo/YhH98+6FYnPVc
         0AH1fIGc0F8rC2vmxYJZpLfOQh3cXhCe/gNCGzFIv6jmpMzbjHXUpBPpQG0eMM/bkymX
         BfVT9d90s77LNN24ZI8p48jDaDbyXYoi9w2FjvwwFn/6wMyKgPb0+kAq0fJhnAUavA1S
         tbMN4vmg/HY+GKZT0f5hI9Qub30RAHKugq/E0UMRERKgI5TsmmHg1YpojQByKE/gw1T+
         tYp1QuqLaxo0mPGE5kYBRXJv0buF40faO0Qw/+raSywVx9/UrDZ4+fS1JdasRemBRkUB
         uX+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788954454; x=1789559254;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TIfeIpZ4OJ7Fe6X5EWfuqkVso3+rNzjQrB57cPZXMxU=;
        b=ezYli7bgCscyKg6KIDAMk0nEzM+UwBTQVB/JaYXpiSp5yjdwrqlhKAyVJXPZK3bKCm
         K6cKF7lowx220CBjj2Nz3zCufiGf59U+H1YKyCkZSsgGS0MbTCrXetDhjBNEvUniSjDI
         paeJBfBouA5rV2g9O/SZfTRIpCEdaYPou5qtJIneG6vT8M2vo2notUIosod3Nj29GZRS
         +G60wuZd0PLt0+5+ewfs0w4a1e1yAr0Yb+Au68adVzoMs8c03gKNgvodQd/SAm13qhTp
         42XCZRdtSAIlqZbfoFPgeabnRc16iiMiG8wgBrHOextfy3a4B8++mIosnrCt8di+1g32
         apQA==
X-Forwarded-Encrypted: i=1; AKwUvBxHrD8FI16f3msPuYvjF69aYpKmul8TT+SqAy/VDaPnpRnolD8q3eNPfE4MN94DAkf8AVFZi1f/1A==@kvack.org
X-Gm-Message-State: AFuF++l3pWdoZNZprDgrWMTGqkqpNYeBMQX7APZ5OsHWo9dcpbS00iJW
	gxkNWKTTiuaj9uxtq/UJhhou4bnsojDEZDJjnsCmRNLJ2/3V8LE+U++ypPpWzB5o9MI=
X-Gm-Gg: AYBFou02QCXkXnmQnF7YcpsER/sxRjRNSDLPy2fGvnUZcnhEQGrwTQDtJaL0CTqzM49
	37yexCMMfRBiQVE4rGKvJd8TyU0PFaOZhn4ZE3qCxR1mtr+rQSkAy9bwSBHT9D/JmjzB00z0eTP
	Y8t1ZyPzyqSWwonsREhmLMDhhrL4lw/lHEVfTNva4lBladcq9Rrj5Ivcm0ME91ljKuZS5ANGuxF
	UJ+B84ut5sKuGNwVpPUS/QSUg404vflwtbsi51SzQ6eBtWNcUCv29NpZM2jJofIwYBxa9oa0ZuM
	2b2CdBaavWaKvYFDxbDgpJ9PHQD9k2FlHt2opYhVuwvIMmiVWOkFStZhq8u0QwxOX6xyMYngObR
	ATt7SYIUOalxVEbyEt0lU1XJMV0/0aluBrwOmi0El0iVwbGb0NzOYN5n4uTGC1dXQTfNsda+6mM
	PPUY+qIF04LY2QE/ZM5JCkHR8C6eptKuA1HRgGYVW30SB63/iCWuE6QJ1cNBW9BgTC7uFS/fSjO
	tNurJolBXsaTMcOQ0GUzLt7jTFrwmgZhdw=
X-Received: by 2002:a05:600c:5307:b0:49c:f617:7cf with SMTP id 5b1f17b1804b1-49d25871d73mr12852825e9.0.1788954454028;
        Wed, 09 Sep 2026 04:47:34 -0700 (PDT)
Received: from ?IPV6:2a07:de40:8100:0:89a9:fd0e:583d:4a53? ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cf7740d44sm1017732865e9.15.2026.09.09.04.47.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 04:47:33 -0700 (PDT)
Message-ID: <eef32841-26f1-4ea3-9915-67a60ec2752c@suse.com>
Date: Wed, 9 Sep 2026 13:47:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 4/4] module: allocate codetag sections before the
 regular module layout
To: Hao Ge <hao.ge@linux.dev>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Daniel Gomez <da.gomez@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-modules@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20260908092412.115953-1-hao.ge@linux.dev>
 <20260908092412.115953-5-hao.ge@linux.dev>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260908092412.115953-5-hao.ge@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8DEF3A0005
X-Stat-Signature: j57acnb355nqnpbwcatytydw3gzytdha
X-HE-Tag: 1788954455-831075
X-HE-Meta: U2FsdGVkX18FjGFkOEVWQhMDBg7gVOHDCrZiQfg5XuPKJs8qxC1MiQg40+jxgsM/I4uEgM6dZBX74ab5mhyDM7KhA6MAp8XSZm+ES02L/SpNoytR+g3xIMlqnDTEILYn4OHVWYzH365d1I0sU4oNE03Wllxelfm9Ncn2IBo4uaEpeUZxOX41umrmcvhMdGtRvgzuKRM/Oz5Mg/C466BHJF1O+SLGx4bwwALoohvaJOG/aps+SQkzFDtfH+xwJRALsKdxq7FiJFCHRgn5Xsz3OzzDAXfcJH+WdA4cDPRPieEWl2fLVcqIXdpUuoNebXL3TYqUC/+rg5qQVq6u95JOZiFQAH9orK+nT8z/zB9ExkE+F7ZBXh/b14HjMS5R79tyKE/dRsk2ecEzFBQ/ZTjqPOnD56gBji8FMuVPVKXhM+We1gxLSaDHW/fYdVMPUwYSp73/HfsO5ON6GhsyOc58PwXHWC9qk02J9MmdOtGB5sVBCoisqbHWwdFwbz8sG9jzKOsYcgvPihzlS+OVZrtO4QbgBjIq8ty+JoMvoDbTCs0znQKh9gv3dgunMgdf6R8lubN3ueLnTONRfkVl/wsxEZHElD+qOmKX4UDaJ9FG9ZhfHxPIhpA575oKyvGlE1WlezcS8BeSLpicTw9KVYSGxkgn0SjyM83pQNJ6vhoG51ckzeXwBZZO1vPart6HfVo+iUWJXj6yATVdGpaJuXMQ3InsIS3uOXMToUyj4e/UD4F0Fi4qwvj33bLlilCoJveyb0+Cn16mbHSnO3wOHrfWD4hAZ3dcfNWZxicBd7xr7L04V6yioMxyGd+Xl9xkGKY2Xs9yXp5qzG53IFZpqSWKEnqFS+C3A4Z3XYjjYLQ39KVGChbIedGIr2qSllpz0BDcjul7MbkwtlbfHaq8EKDK5tAlSDoH5xRHSWOn1LbsXtCcj7P9ZiTyPQYTj5iwtJCyky9NsWzKw5aV9xjerZ+
 PBZHqxbq
 Y7ciO+ImadRF4+74f+JUvHHcwuZBp+KByu64mQxn65ay2EZR+kqCqIZMvYx/aYSAGFNPu+qhC8PGq/fa4eImCkxOA504RAeZX6vvFfOdpZCth9Etd0bfIV/P8Dqfzbu5C5wa1/3irnUWU9eu+0zWlnYzkMwkIrWwdXfJxPd14/KWvzTPg4HHS3kqpMugZ19XmOJYXbQGgxH8zm/PM+v6b3Qypk6OGEe3BHH2j9BpkKO4nLgw5VzWteAYdwjdrspKxwsRMS9cQ8vb928bYDaogxAk6Do4tgIKGoa5fivagYl1mmZNgtx+SGufiHpWejLeqEZN4pgc4IETb+Xen5BwFWSKSxNMH5EefilJMnpUxOG/LNVD2yOk4NydE+8M5gt8Xm4eZevGALyWe0UGAKRGNTv2ZMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 11:24 AM, Hao Ge wrote:
> Whether a codetag section goes to the codetag region is decided by
> layout_sections() and asked again in move_module(). A concurrent
> load can shut profiling down in between, and move_module() then
> copies the section to offset 0 of its regular destination,
> overwriting whatever is there.
> 
> Decide and allocate in one pass, before the layout. Allocation
> errors fail the load. On a tag area overflow profiling is already
> disabled, so -EAGAIN makes the section fall back to regular module
> data and the module still loads. The reservation is released and
> module_tags.size rolled back, so a concurrent load which already
> passed needs_section_mem() does not skip vm_module_tags_populate()
> 
> An SHT_NOBITS codetag section is zeroed explicitly, the tag area
> pages are not zeroed on allocation.
> 
> When profiling was toggled off the overflow check did not run, a
> module could load with more tags than the page flags can address,
> and re-enabling profiling then silently corrupted /proc/allocinfo.
> The check no longer depends on mem_alloc_profiling_enabled().
> 
> Based on a patch by Petr Pavlu [1].
> 
> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://lore.kernel.org/all/499bb60c-c6e3-43a3-bd92-95a0567ece5e@suse.com/ [1]
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Ge <hao.ge@linux.dev>

This looks ok to me from the module loader's perspective.

Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>

-- 
Thanks,
Petr

