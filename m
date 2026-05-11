Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ABECCD37B2
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 02:06:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99C146B0088; Sun, 10 May 2026 22:06:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 973286B008A; Sun, 10 May 2026 22:06:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B5A36B008C; Sun, 10 May 2026 22:06:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 79B8A6B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 22:06:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B671A0517
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:06:53 +0000 (UTC)
X-FDA: 84753500706.17.C6243EF
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	by imf10.hostedemail.com (Postfix) with ESMTP id 214B2C000C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:06:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QV8TpqII;
	spf=pass (imf10.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.214.196 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778465211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YUvosZ09yddchp9wYhlE3KGFQdvsqe92JMeqa7iwdSA=;
	b=Gj0/DfDrPn5XQnFq0tHRzXYfmz3BzTUblaCp4GIhF8829JCyJRnzOU9Wx8tf1cvvtB+PoP
	s5V8KrjeohelDf97bGoR00x84Up2iWRhDN3/b6fC9d4ekdNSDdk/GJIfvQnM069o/u+WJg
	qEzzkcubU28j4alddCqB0OfdkAGZC6Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QV8TpqII;
	spf=pass (imf10.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.214.196 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778465211; a=rsa-sha256;
	cv=none;
	b=Jq0bIYDCFOVGoAC1Zm56RAr+wcOIBr7X9/mmmCecTQ0B7yqQGf0q5Z8+aLqSzsKZdlHZIw
	eKcK6AAWwpTaBy9HniId9Z0ZiDEhbL3iUAIA1Sm5fnsvyFByvDMRisSd/YDzxlpoOVzoq+
	WTVnhh/NVh6ccNLSPWwWmzOEVo/r/Dg=
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-2b458ca2296so24244745ad.0
        for <linux-mm@kvack.org>; Sun, 10 May 2026 19:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778465210; x=1779070010; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YUvosZ09yddchp9wYhlE3KGFQdvsqe92JMeqa7iwdSA=;
        b=QV8TpqIIY5T3Akx2o71fXVMatIoz8nUJGUcf1UedPx9LoEOYEbqYWJA4ziAeQ5l/8a
         yDprkSqcvDEmJJZO4TuJTXu43mA3C87CJh2qr6mcU2kvxIdQ+RjJQTmp8/sRcqfPI+q+
         xpymgIwqtmGwAvbtA6/36LsEP6RzsZE/Fti2sm3bGnEcOjIPqekXy+/1RQk7xvYXl4pu
         TkKVXxrp3N1cOXU225uJPY5sHyOwb9LM4bpZx9oqbQt44qx/G2NB86j00X8FQE46cqmf
         f4XKl7UKORmWcytuELsOISPL2m/lx3tAzSwEXJUtijTvCyAQ7tfpS91RASwM0jtKGusc
         xGuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778465210; x=1779070010;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YUvosZ09yddchp9wYhlE3KGFQdvsqe92JMeqa7iwdSA=;
        b=VrYX3aWCuWqx8vYlA+ugMmk3w7JvzioLtH6JGX5/E52nCUmkQlWeffD3lDBy/JsCWQ
         qewo18T+d73vQnZpr+/cEUcBb5jeUcVK9CGBcVQcLK21tFJgsct8CgJKIJnRyUmoIQla
         YYRuP+NSNpgKn2Qu9FqEExfEq7lU8OuqvI3p7uZGszEP8y5tVWpMO7Gs5vuF8oo3FX+Q
         7lRwpOzuRU8pDctSKRwb2P5kKdVVBDBwDf8G8vqfcNCHQgL3+TGD5VNmfSMwB7E5lOU6
         XQdnd3u1GciVzCyaP31hydRXrJPxUfSM/fWH1nnt75itRuyfzPf0tjb4RQR4WfyghJYG
         lUyQ==
X-Forwarded-Encrypted: i=1; AFNElJ91e5gw9dpFEkNAZqOvTPUxLg46zgg/3ZdXI7IZWSmg4bCM9uAcEDqSQcAPgi42ImcRy4b04J3lcQ==@kvack.org
X-Gm-Message-State: AOJu0YyFT/hfi2EdSJBL6qz6YO6UcBrBkADVE2wV6ilnuV+kbxNZNkTV
	gH9sQ/eenmlNPyid+I4PR7f+ERVMH13C6dqxii6aYmLwc8korrHMRFeh
X-Gm-Gg: Acq92OHIedZUYC+xfQNjaetOxfjCCTZEOBP66mnC9cMsdv5HYx9p1NGCVjsmlRIfNVc
	i9qUl+CyWEJjSRyCeBXRo/GpkXvOdPKlgECx9zUu8I3f5FARc01dj08N/RGra/m7Q9tm/cN7sdl
	Gh//BuU0xIqpu7IKCTL8ZW9exRYkbEAlcFXpgTuirOwC/WeqmsfIyoFkch39XKxbrDo7DgWZeGk
	XGZ66oqC/Bs2R0edN2fBOGVpO5zHcZq6kZnYyHgnv4J+3WWJiK4EtiMZWZESCU/8mAZhhHuS292
	KjXlZLtP+3vLBUUlliDThWgpEac54+Y7eUuKl9IFKac19b7Jv+gfBfkNf7qCmDXGM9uitAkoLKX
	DuRZUHTYk55A1Yb8KVdEQgLzgnwl9IQuKtILYSNdkE1z2MElJwkrLNa7YDbMvVWkRJslquDkW1C
	AUs92590D6BB1Q/Ga4HkideXe0ADJBDPU=
X-Received: by 2002:a17:902:70ca:b0:2bc:dd58:3dc5 with SMTP id d9443c01a7336-2bcdd584272mr3255495ad.7.1778465209728;
        Sun, 10 May 2026 19:06:49 -0700 (PDT)
Received: from [10.125.112.20] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e35ba2sm89530205ad.50.2026.05.10.19.06.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 May 2026 19:06:49 -0700 (PDT)
Message-ID: <8aa6374e-7bfe-47a4-be8e-8a4ea1cc58fe@gmail.com>
Date: Mon, 11 May 2026 10:06:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm/khugepaged: fix sub-PMD MADV_COLLAPSE range
 handling
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 shuah@kernel.org, zokeefe@google.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260507070558.3064142-1-chenwandun@lixiang.com>
 <20260509094732.83643-1-lance.yang@linux.dev>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <20260509094732.83643-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 214B2C000C
X-Rspamd-Server: rspam06
X-Stat-Signature: g71smto6tyb3acoujp3bmsk5pdyw1ori
X-HE-Tag: 1778465210-943664
X-HE-Meta: U2FsdGVkX1+D4mcg7j4NuA+yH5jOfhSFOPi+okuiYW3Vwj4xd6vkvefqIkYVNLYdSnMoQDIJqDrsnNVPZhNRlYYK7qGeUVjNV6gymCRnSwmxghKDn2zS92h+3aIEGaAP09qK2CStLJjRxi4pBhc8UsozZNbvyVY9kvvEz3HUOtoIhVR8HAxhHXj7d5pugP9QIgP6+n5kipOwnwxPviuQ4RlJvOddeEduvGRyYkT85qG2k2mBkI5FPH7voaXjdETKO2S+iPgPcigEumfRTzd/CfROyPU0raawIEF5VajuvxjuWiGLObOuwzmim5FvF0MngWZgLyrQPzs/FqWMzBzsxgqz7WSpmASPVYXp/Wnud1GqYlBL3tPLIgiwXvYbudGH76nPIVE3gZpm3fl0RxcdNaaN0N+HmSezm4oYfgDMGfWgnhK/g6/i/iEZY/dLv1Pjx9FWpq2Dv8yvlnbTdFAA2u99Xh4j3MRf6iHy2lUbMAlsCxb0Wme5ICHgulglVQoPMxi5lQooMmbF8oSTXBNDjo60jzgqlXX7O4vtYTHg9QHYlPMjzTj3jfc1fFsqYXx5Mle+u2uaWAdZ1h2wxxDOBeLps0iv6KftyHSmfXIhj2Zn1Y7vHEDgzU4lq8HKmQ+uWNMMSJLAcxOyelelUQjAgVGqt1DfEPiG4CgfdUB1ok78zdhGL0Z3yoGoV/Q58SiG5UIGeyfF7ueh8x94WXKKX9JbIyRNgjCuz4TzoUwT9KggyuE4C7yPl0372r+JUrUpkRfSshv/EI1uL64p65xeOr35erP/VsBjVUFK4sgR9ysfoXaFBXT2qxx6fT7I3pfrghHl59vdH5CBwWq0yWkaCLO1Y3gp7nUD9TK6WKWqbYaopM0jRF4ANLz7kZLgS8JVkvFC6htReOodaQ1gV/JGVKp6STze52nhdO3k+YbedOSvllRMwvfl7rBYzdDqCsyXzJ3KyQ+ZiXdNj8w75uF
 99vvXztH
 IownIsy+RrGjtWu9OX6LkpuM++G0G2ONPoCx9esrrhwGNUuHRq2chN57qxq82jOvO0jgn4ZViz1xWmUZ3uIwuBe4rpCEAPaS/081o+vGvX6pF1NN/3XhpdYxAYJpuP3NmiU8IKWoPG0pLkjrTCMc0QrnatWbISVvxy9YUabOtauiYOk+JTBhJ4U8chceDFRqDWc3zosBVrbEqZfUulQF9yHFdH5Sl/NQuUoN50HNF98FAqGz7XuCrkvaXduly/RNHNuIaPAf9uZrTYNhZMOZJLJWSQS+BWWbnQT+dSv2WxVjoJvHp2BxCwujab9iQipm54CiUENLqG2G/0VW3Z5fKytqKA5SsyW/IkH7b7TAe/fO7egbBUzHgP4+mlLyna6SLAyvePb6yw/5AoXQaOY+IfBvbo6jASuwbP+H+J+Fl8E/6yFmv93r7ESIbAbim46CPT6BbdYligoEPuNbydvjBarFmJWENn3wEz4ppCzIB5DrCUnqRDo2f2M8tV5XETAtyRilhgvYUydT9O9mgHuuxi2vtJt6f4qUhldspwKGHjT2VHhfVbrCGEPlYZ5xTzuJcDqfg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/9/26 17:47, Lance Yang wrote:
> Hi,
>
> scripts/get_maintainer.pl is your friend :)
> Please use it to Cc the relevant maintainers and reviewers next time.
Many thanks for your kind reminder :)
I will do it next time.

Best regards,
Wandun
>
> Cheers, Lance
>
> On Thu, May 07, 2026 at 03:05:56PM +0800, Chen Wandun wrote:
>> madvise_collapse() computes a THP-aligned window from the caller's range:
>>
>>   hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK  /* round up  */
>>   hend   =  end   &  HPAGE_PMD_MASK                    /* round down */
>>
>> When the caller's range is smaller than one PMD (2 MiB) and/or not
>> PMD-aligned, hstart can end up greater than hend.  In that case the
>> collapsing loop is correctly skipped, but the return value was computed
>> as ((hend - hstart) >> HPAGE_PMD_SHIFT): with hstart > hend the
>> subtraction wraps unsigned, producing a huge value, the comparison
>> "thps != 0" fires, and -EINVAL is returned instead of 0.
>>
>> A concrete example:
>>
>>   /* both cover less than one THP; both should return 0 */
>>   madvise(aligned, PAGE_SIZE, MADV_COLLAPSE);             /* OK, returns 0 */
>>   madvise(aligned + PAGE_SIZE, PAGE_SIZE, MADV_COLLAPSE); /* returns -EINVAL */
>>
>> The fix moves the hstart/hend calculation before kmalloc_obj() and
>> returns 0 early when hstart >= hend.  This also avoids the kmalloc,
>> mmgrab(), and lru_add_drain_all() calls for ranges that trivially
>> contain no PMD window.  The same effect could be achieved by only
>> guarding the final return expression, but early-return keeps the
>> no-op path free of the allocator and drain overhead.
>>
>> Patch 1 fixes the kernel bug.
>> Patch 2 adds a selftest with two cases covering the hstart == hend
>> (aligned, was already correct) and hstart > hend (unaligned, was
>> broken) scenarios.
>>
>> Chen Wandun (2):
>>   mm/khugepaged: fix spurious -EINVAL from sub-PMD MADV_COLLAPSE range
>>   selftests/mm: add MADV_COLLAPSE sub-PMD range tests
>>
>> mm/khugepaged.c                               |   9 +-
>> tools/testing/selftests/mm/.gitignore         |   1 +
>> tools/testing/selftests/mm/Makefile           |   2 +
>> .../selftests/mm/ksft_madv_collapse.sh        |   4 +
>> .../selftests/mm/madv_collapse_range.c        | 141 ++++++++++++++++++
>> tools/testing/selftests/mm/run_vmtests.sh     |   5 +
>> 6 files changed, 159 insertions(+), 3 deletions(-)
>> create mode 100755 tools/testing/selftests/mm/ksft_madv_collapse.sh
>> create mode 100644 tools/testing/selftests/mm/madv_collapse_range.c
>>
>> -- 
>> 2.43.0
>>
>>


