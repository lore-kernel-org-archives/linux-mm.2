Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3DD9606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 15:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=SS5lJWA7
Received: by kanga.kvack.org (Postfix)
	id E43086B0987; Thu, 22 Oct 2026 11:52:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD3A66B0989; Thu, 22 Oct 2026 11:52:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94606B098A; Thu, 22 Oct 2026 11:52:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 994666B0987
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:52:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 163FF40193
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:52:00 +0000 (UTC)
X-FDA: 85350703200.10.E118D8D
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by imf07.hostedemail.com (Postfix) with ESMTP id 50AF040008
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:51:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SS5lJWA7;
	spf=pass (imf07.hostedemail.com: domain of 3HDHaagsKCEUz1zllukyhuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--suseendranb.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3HDHaagsKCEUz1zllukyhuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--suseendranb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792684318;
	b=w8P/Jw0icK+yRTaz3trZDtAY/fquHkQdMsuBLhl9Dkzoa4lzYG3r7wYALjn6DTtXydvTaJ
	bf3az7bsgH7LQrcuddyx710uSQAIY/tijS/0eNcoyUglRfPYG04+JpSI6VBa0MJj8udWZ6
	9kiPvRhFw8ukusP1Ca5KMl1vnnQhb10=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SS5lJWA7;
	spf=pass (imf07.hostedemail.com: domain of 3HDHaagsKCEUz1zllukyhuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--suseendranb.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3HDHaagsKCEUz1zllukyhuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--suseendranb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792684318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JAYxwJeGd7Vqjt15irwA6c0ELx0VJ3FSuBJg/5kMUGI=;
	b=Z9S/EU75Y2q94ydG8ubcSRrc1awFuHFhDuiVYq3P4IoYLANd22wrIW6Yn+DWU8rPmS0CL/
	3sps3NwxWoWoo9yGv7UgRN93H6n4DejFarzGq64N5DL5ro2d190KgYsrPPdGN2bvpJSCqs
	G8PKCCbMRNamPwxKy+0uYKJovH91NGU=
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8a06da65d92so24157b3a.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792684317; x=1793289117; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JAYxwJeGd7Vqjt15irwA6c0ELx0VJ3FSuBJg/5kMUGI=;
        b=SS5lJWA7VseLP+k0E2RoGcfDZfUQkUJyT+rf8UO8q3baKhZB5lso4y2OiATsXIPmOM
         zLXhIxAD42Chi3SSKRyuisPkJMd3blOxMIkFwDu5lHRq7c5+D3nAhvPCdhrA3fRPkKpZ
         64Q6MdLkEDnrWEwMHvdbxay8qRA3JsnDAZWdR82nborNLyZfvCpJcSFCOkD9hGwyPcgr
         48Dv9TG3YEYLAGztPyQsQ9l8XTb8Q2v4eVTQxwIa22RHZRdDoO3Z19K/xN78V2/YznVo
         ynJBfkRe8Jndrc7i9W0T04jZ6B649oc4iYvAzYHvuh5nkV18nSpID2KmXnv238aBqV8Y
         Jwkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792684317; x=1793289117;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JAYxwJeGd7Vqjt15irwA6c0ELx0VJ3FSuBJg/5kMUGI=;
        b=ygMsKLDL+9pmS3SQ/KyMSOYf3wHNnhYjUk0qaIxdLT1xn0aSsbaWTjifAmu7a+CIJb
         5k/VLe7SB+7mPPhHydR6XkO8mo16sC28UrODEUqZC1ZVQzr/4zyYWdKcU1wlYTGKgWC4
         I2m/rYnzFjd0YJW5Ip0QKgZt5JfPbeLKoiDiHo6gCM6WSbXHAHedQHIUDttGZVlFwLAb
         yWcTjLwN5daVFOt2GQHwaKC0sN6coQVJD7Z3jnNNhQ0GjJYIXbGuyB1gTOW20x8s1NzC
         OvQn4rPefMeMyBiNxXKeIjg7FYKOlvTZFYF8gtI+s6qkndI3Y/ZqwXjrpchfhaY7fqSP
         xbkQ==
X-Forwarded-Encrypted: i=1; AKwUvBz6/J3iYwHcs5WhTBEfjW1w21xz+E1cSgEBQhD0NjNZlpYSjptWWQlBvaSBZX2MdnHuT2TBOLgjSg==@kvack.org
X-Gm-Message-State: AFq9FYLZJwyiup/H5kJC4MAJ576/U/NyVMrnukdpuBN+eKP9JqwGQfei
	6rAxD/x6DfPcufiPtniWIoh+AuOTt6Za5j6PfXV2bAUH5/RRIlJboqdYpOkpIko/CCg2gl8a0er
	Qn5bkl8GTAOVuKfu9MfS21ocULg==
X-Received: from pfay28.prod.google.com ([2002:a05:6a00:181c:b0:885:756d:3709])
 (user=suseendranb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1905:b0:8a0:1dab:fd50 with SMTP id d2e1a72fcca58-8a089e1f4dfmr4253077b3a.20.1792684316760;
 Thu, 22 Oct 2026 08:51:56 -0700 (PDT)
Date: Thu, 22 Oct 2026 15:51:44 +0000
In-Reply-To: <CAO9r8zNtuN=_BTV53oHqaTqE0Bo2qiDSrgTBzEZo5oyOnWyeYA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261021205626.3286270-1-suseendranb@google.com>
 <20261021205626.3286270-3-suseendranb@google.com> <CAO9r8zNtuN=_BTV53oHqaTqE0Bo2qiDSrgTBzEZo5oyOnWyeYA@mail.gmail.com>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <20261022155144.4177200-1-suseendranb@google.com>
Subject: Re: [PATCH 2/2] mm/zswap: classify compression dst overflow as poor compression
From: Suseendran Bhaskaran <suseendranb@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Suseendran Bhaskaran <suseendranb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Nick Terrell <terrelln@fb.com>, 
	David Sterba <dsterba@suse.com>, SJ Park <sj@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, 
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>, linux-crypto@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 50AF040008
X-Stat-Signature: d98ksqdkuzek9hhegn6189gnaai4gkn4
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792684318-325539
X-HE-Meta: U2FsdGVkX19DLBQIE5qPFwe41x6AN6vJtgnYr5qtniVHt4ZEuC/PSAcs6etj4j3psupBajt5raDc2ZEy3sLNP2+GGikE2wE7YRBWZStKqlzGI81h56K6NnEPVI8SDwfJ/SuoHrkO/d0a7LimAQASVf7UUQm6PwESKDvx0D1D8v+swFxAmMDij5DpIjhrhQbeTmJ4D0agvVmG7tJHWVPo/myv54vIehvtgV3A4WAsL8y8vJEq32UCkVacJmHBgaoLrDqHmUhEpfg5rRHoYtE9i8PZb/VYg9bD8WTboOCqccoww7d1eS+UBxLHn4BKPZDEcZb978KYOX7zqOVX351SRy2vcqOTD3k27D2Oh2F+0ag/bYlBWIeKxH0xWilR2CPnCGYncMh3NWNcdk44JC82e4cbyDXjbM5q81tnIS83Nf3GZdvPrEK9ZqKef8HU77m1gKHKPVvtCT/f7zl1JfnNysgbLhC1VaXX3is5j1ODO+pz9kMTjKh2nxKovmg1wqJJ159SEM7yS/INCGvjEzWl1Y2VJJwPklb1CDA1Q1TmU0mu1EflT8QdCDomR8TTMlFDbjFQqh+wovTngZecusAlpOMdGyOweujFKVijbLIc0AI9akuNar29BvuaAr35ZEZJwXnNOEaAz4lxWzP2Fc4DpgOfN/4idYyw5Goxw5tSpP5Qo7zHviP4lp/ZGTzsCLl6M/m0QwGC8HNSnR+0cRd7ieLCjlbnODgw3ktR+gFZUO6Q6QsDKPJNeY6E9ZdP51x3BgqAx4JlkX12htxQ9SAd5uIc0JLHD9ATdvuTsnNrbCDKCNSIAUky37+rZMbDujmDGYEdVEKbUhdyvo5i8kgc6dsxOXLcIJAlgVo/Geu++VDtTIusH0m6nrX9aJ8xsoEKBy3sSv2SvV9MMnjeNFfsDqMH6hdicfvOgRwoVS5BMb5rc55jzQuB6FMXh3Rv/U+7oyZnWaWGm2a6Tjv03mU
 OCKy3OmS
 9o7ja/Yaevuf38lftHFyvW4HiZ+zMibB6gHCjP2L7WNDLsSn/0KDg2erMCVO+1otlBAnDi5yv//xR9QFxzvWqEViHbkGmCAFSRGhncHPgGXxVaoZzkNBimtBEABEo/MXsx2FLqzgmuj+y3YUmMI8TQ8oxGF7CoftRvEsIm9SXHH244e7Agg0wq8AJn7/lW2BKP35si4BhfB5iOyD+YtVvnMDXTa0QLlqbLlXRSYhQkF0Q9cJir9Do1fLcg3kquTlQ7hfggE0M2EetwDx7q10sfUMT/a1BgV2Twfco4W/UW9cyLOyEITMehHI5cKY7iEUt29vtNoQgQj4cpFF2QZ4UjAxz4gwXmVG45XZ3hjZ6DbIrCXFu9+xFN3ukYYhA1gj8AcKJi8rsO+dvGouH3643eACUmD2wFxEOwX3ULpk76cC2WMxXVbex2ym+Z+/HB7OO16XWCmYCCBTDsKzZN1sbUX2LOOStF0ZeEOlnYKKwkpxq8q1/DVmMG5udbrU/dB6FFSBwq1HZfJOZIV7zSTY2icMx6s4bpOha4Fg4bzGhBKpV+uzNlIUN63VOeRANaCYeNx9Rm+R/d/oIwSpweFHj7BJexCacSdMCxu1CpKumoaERQzbP1fj4THr4ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 02:47:46PM -0700, Yosry Ahmed wrote:
> On Wed, Oct 21, 2026 at 1:57 PM Suseendran Bhaskaran
> <suseendranb@google.com> wrote:
> >
> > 1. When zswap writeback is disabled (e.g. memory.zswap.writeback = 0),
> >    zswap_compress() sets 'comp_ret = comp_ret ? comp_ret : -EINVAL' and
> >    jumps to unlock. Whether the compressor fails on destination overflow
> >    with -EINVAL or succeeds with dlen == PAGE_SIZE, comp_ret becomes
> >    -EINVAL. Consequently, incompressible pages are misaccounted in
> >    debugfs under reject_compress_fail instead of reject_compress_poor
> >    (leaving reject_compress_poor stuck at 0 and triggering false
> >    compressor failure alerts on normal incompressible workloads).
>
> Hmm IIUC this is completely fixed by patch 1, so it doesn't belong here, right?

You are right, thank you for pointing this out. For the destination
buffer overflow case, Patch 1 alone fixes it since comp_ret is already
-ENOSPC and 'comp_ret ? comp_ret : -EINVAL' preserves it. The only case
not covered by Patch 1 when writeback is disabled is when compression
succeeds (!comp_ret) with dlen >= PAGE_SIZE, where 'comp_ret ? comp_ret :
-EINVAL' sets comp_ret to -EINVAL instead of -ENOSPC.

> > 2. When zswap writeback is enabled, any non-zero comp_ret (such as
> >    -EINVAL from an invalid compressor context, -ENOMEM, or a hardware
> >    accelerator error) is treated identically to an incompressible page:
> >    comp_ret is cleared to 0 and the raw page is stored uncompressed in
> >    zsmalloc. This silently masks genuine compressor failures
> >    (reject_compress_fail is never incremented) and miscounts pages that
> >    encountered a compressor error under stored_incompressible_pages.
>
> Storing pages in zswap when compression fails to avoid LRU inversion
> was intentional in commit dca4437a5861 ("mm/zswap: store <PAGE_SIZE
> compression failed page as-is"). Unless we think this needs to be
> changed, I think all we really need to do is make sure we account
> debugfs correctly for -ENOSPC vs other error codes? Or am I missing
> something?

Thank you for the context. Keeping the writeback-enabled behavior from
commit dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page
as-is") as-is makes sense.

With that unchanged, existing zswap_compress() already accounts -ENOSPC
vs other error codes when writeback is disabled, except for the
!comp_ret && dlen >= PAGE_SIZE case mentioned above:

-			comp_ret = comp_ret ? comp_ret : -EINVAL;
+			comp_ret = comp_ret ? comp_ret :
+				   (dlen >= PAGE_SIZE ? -ENOSPC : -EINVAL);

Would you prefer that I narrow Patch 2 to just that change in v2, or drop
Patch 2 and only send Patch 1?

