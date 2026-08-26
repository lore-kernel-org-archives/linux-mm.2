Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D18A8C61DBE
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 21:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE7DA6B0088; Wed, 26 Aug 2026 17:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C993E6B008C; Wed, 26 Aug 2026 17:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89E86B0096; Wed, 26 Aug 2026 17:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F67F6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 17:58:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 13F671C024C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:58:15 +0000 (UTC)
X-FDA: 85144784550.12.A0C2E87
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id DB5434000A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:58:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TD8Z5bif;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787781493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W48obZE6+PHj9qZ1VUibazAltzOy+cKkoC0weBFuEaA=;
	b=DZ371ddxva3peAfuOpCbAMKSzKEAG0c4E7Z6XxXDHPwGJat1MoLk1qWwSAgF/xW6dmqbcz
	pMjUZ8JJ+HRrJJ3mYmCbpilLnRdDuw8QO0ZiwQ0fPqb7Uo4AH0b4T/1gnT4SsvLduGseJ3
	NW1iSaapRrDA3CvgCsY7mqPn7I/G1mc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TD8Z5bif;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787781493;
	b=aZOJcjQdmtstReJrwdbXFmWWrc4vzXAVpimGQjEP5lSJmeezq8pmAKLAksBlmyqWvT4nfF
	oe6ECR6BeXgveS6lzd0JE445pp2Ui+20hoJ2w+XfpEhNpc9hMairLbbsseIgw9MTPbJIiB
	06jn75CMaRdNJAmzrqG7YeL5BylY93k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D8AC43ECD
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008AB1F00ADB
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787781492;
	bh=W48obZE6+PHj9qZ1VUibazAltzOy+cKkoC0weBFuEaA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TD8Z5bifPIXitj05rARbt7HWazn6f32cyF/TyWMKB/CBMV8rUWbzqZx/U44Ug3CEz
	 TSlbq9yxOIO/UNHno7SSBsZ/OFLwhCeCkaaThYHbQMuMybpRbDzjQx5vezVVPIzpIx
	 mw70vkNBMoAekWUkSLg18IIWVZ3pAstOKlF+LgGRMCvbEJmjnPTk4CbZGFZ0fdTvxM
	 LpwuT9XxQsz3BXLj8XxrhxGxfPIIbnInyAEO3afuPpbcrRdOE9T0WgQq6VBWDKyDOp
	 oc86pURq8/yobPY9awjaOUtKx40YC1xXFzdCOxPKFcnIThKGhbvBm/gLOU3j25MOU2
	 tQ2LGZTbxP2xA==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92edb12cdf2so99839885a.3
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 14:58:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrQAV1NNuZIGdCoCj5zSp9gUdtladnDIaQNoQY0jUOsY0t65ZOXDbeECL5d7Ul5/7TWB63MZH6alA==@kvack.org
X-Gm-Message-State: AFuF++nB7B4dO1wavjsIeXaTXq+xvMv8cg6v8CxpNLMcgWf5kI37Ia7R
	noobV/pLIbljvJC+trvsRVGRL0dlfBUbNi4R6nVTGO27wPi0nAER2UX8xd+/suWKkYbOgFNDBJb
	b4orJ5RhMiXipNsVTB1E7/+Ba6WylCJ0=
X-Received: by 2002:a05:620a:4553:b0:939:200:32be with SMTP id
 af79cd13be357-93902004728mr135515285a.41.1787781491298; Wed, 26 Aug 2026
 14:58:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260826075133.751049-1-zhaoyang.huang@unisoc.com>
In-Reply-To: <20260826075133.751049-1-zhaoyang.huang@unisoc.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 27 Aug 2026 05:58:00 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x0Q3D9A_-aR9mdNLw53O9Os5SihhyaqFnSTtN-3v9Gow@mail.gmail.com>
X-Gm-Features: AcwNN1V8L5hw_vaE7IeQCKYBKYaXTeVpzFEpk6tsaOy4dEE_rMgI20fIJoaVXd0
Message-ID: <CAGsJ_4x0Q3D9A_-aR9mdNLw53O9Os5SihhyaqFnSTtN-3v9Gow@mail.gmail.com>
Subject: Re: [PATCH] mm: workingset: judge cross-memcg refaults by generation age
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Zhaoyang Huang <huangzhaoyang@gmail.com>, 
	steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dirh4w9kgmqtjpcxnrj1xq1iiejbe3ob
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DB5434000A
X-Rspam-User: 
X-HE-Tag: 1787781492-808976
X-HE-Meta: U2FsdGVkX1/XheWgKm9WVFT3td3m6GDz6tZT897Dhhk9Y5fhgy1RxRtU0OgUeuzF5NAcaAE8m+gKQWreJ8GxAZaPNEXaaZiAZfhnB+uDuTyQ9L7uB8Fm+lPDswItA6rtY1i4K1ePygAVL/ZPKj39rAAI3REcWwnIFzx4gsbJwm/yCZ0FLosUDr6NfJbe4LqJWk5Ftu8YArmi0YAquh6vVFB/gkZWcigggaFk/tB3+BcjHgPIkU++F/Au3AWdFN1E32afhP3INNbw0VgnEjwKf+RpV8Kv09CqKlI+FqMjkJQ1TaqMIIQxAx6rZm4IeBmmBFTWQubHAC2nFO6YqdyMAKfemxGtNbM+J1U7z6B9Pm5Wa6rT2xUEER2p8ZNMyHf5t8ppt8WHduOdzQp/dvSusuP++dRdx/zeOlWNWB+YvshjHicGN/5+DWiUEh7Bf737gEsMGgp0luhlwCU8rB6CBBEJBxc8ro8wprCFABYFdEs98rGR3NjG31k14y/jnNGrU87Dy5BeF7DnVHS2/VXm+X32KwdZwBZwk/lTVHq5aCEdrksN+i5dZevXqW515p4QvgEl9tTvhKQuvzdMLq4aaEsSWojXBw2mZvVTpV7oszqnl1IWgZH7fbeRoRzPCzGOiwejHJS8ZCFQMBGHhmipsraW/yvVGTGjKrC+2Z/OBHa2OE2wPMBtePowwjmDD6884k7goj2pvu44cP4mZqC4jrRspL1Nuumkq5UAP9kAR0+iQr31Y6F2/mne4CgJqGXB1+ToLGCygs7MxOcXMEMuraQoAH+1kD/j8Nsayuuf3J0neqxi2WpV26JV/olyKL9Y1ZLaCseICGxMS6HtZGvsCj25IpdkD2E+0Hydlu9mC4WW+nEX8nsKAr8RTBir2v3qk+VYP8z7uUhmupMZOBaewfqSiLVN4+pN7BFX9Aia/kUwaz7yd2JXSKUZywjjhvJb68SUrSDLmW5ZurCl9+b
 53QRSVPt
 9avF74NcKYJr4XxvDD051kq2+l5sW9x/SyizYjygiPBDfX/PW3NZvhDCFO8EtMGk0POyHIoShYUGFWOq/HB4kdLtp5hhvp1GjyFZClQ5tUbGEQixMxbbz0GlzEj2SgBjX5l2i08UDi2JQ8s7hBdBqVV9Uml84DJONd+HLx7Olgb/U9RwYHeFOx7shEopx59pdN4YmHqtE4XRqfkalfyIzTnR4PnHYEqe07ESHReLYUL5R77J3oiOb6rzeOfAosEK+wRAMV+neJr+Fz6BQhlaxsI5d1+JwQ7BqG9KAHlLxP9QDpJvlwxg2EytN8N9Km2kgMaVy7e65v8aSmldoLhxB6FN685KBMQKNZpoI+w7iC/ac0uv0aXVEAFw0Fd2qPtFHbgpnT9MxymLRChXb7z6gr8WSrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 3:52=E2=80=AFPM zhaoyang.huang
<zhaoyang.huang@unisoc.com> wrote:
>
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>
> Unexpected anon folio scan rate is observed in a per-pid topology
> memcgv2's hierarchy even with swappiness=3D150, which is believed as
> the concequences of belowing rule which discarded all feedback for
> the destination cgroup: no WORKINGSET_REFAULT accounting, no
> activation hint, and no tier or workingset restoration. Shared
> mappings faulted back into another memcg could not signal recent
> usefulness to MGLRU in that cgroup, weakening thrashing detection
> and protection for cross-cgroup file cache and folios that moved
> between memcgs.
>
>         if (lruvec !=3D folio_lruvec(folio))
>                 goto unlock;
>
> The failure mode is structural: min_seq and max_seq are per-lruvec
> generation counters with independent sequences, so their numeric
> gap is meaningless across lruvecs.
>
> Store a truncated eviction timestamp (jiffies) in the shadow token
> next to min_seq, reserving at least 16 bits for min_seq so the
> same-lruvec sequence test does not wrap at the shorter LRU_GEN_WIDTH
> interval. Same-lruvec refaults keep the existing sequence-based
> recency check.
>
> For cross-lruvec refaults, compare elapsed time since eviction with
> the age of the middle generation in the destination lruvec's
> MAX_NR_GENS window. Refaults inside that window are treated as
> recent and workingset feedback is attributed to the destination
> lruvec.
>
> This restores refault-driven reclaim hints for shared cache without
> comparing unrelated generation numbers, while leaving the common
> same-lruvec path unchanged.
>
> With this commit, we can observe the anon scan rate raises under same
> enviroment.

Hi Zhaoyang,

I feel really bad reading these AI-generated changelogs. Could we explain
it in more human terms?

* What is the current problem?
* What is the performance impact?
* What is our approach?
* How does the approach improve performance?

My gut feeling is that you are making workingset refault aware of
cross-lruvec refaults. But I still don't really understand the actual
performance impact or how to reproduce the problem you reported.

What is the user scenario? What kinds of folios can end up on a
different lruvec after being evicted?

Yet you don't provide any performance data, such as anon/file refaults,
sys/user time, or other relevant metrics.

>
> Co-authored-by: Cursor <cursoragent@cursor.com>

Do we really allow AI to be listed as a co-author?

Best Regards
Barry

