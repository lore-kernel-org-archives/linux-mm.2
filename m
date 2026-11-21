Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59C99606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 12:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=FKE8Hbqr
Received: by kanga.kvack.org (Postfix)
	id 6D4E06B05B2; Sat, 21 Nov 2026 07:59:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 687D16B05B3; Sat, 21 Nov 2026 07:59:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59DD66B05B4; Sat, 21 Nov 2026 07:59:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 32B0F6B05B2
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 07:59:46 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2EDCA0478
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 12:59:45 +0000 (UTC)
X-FDA: 85459133130.07.89349F7
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf22.hostedemail.com (Postfix) with ESMTP id C3A0DC0009
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 12:59:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FKE8Hbqr;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795265984;
	b=kZSjYVC+yrPm6B9V2ZksFlXq17R+awjvORFrJk64Ms5QXpOxUfWSVEbvIT8FE6zeVV2gP9
	rwnVyNepWicQGG/U5GQkOQsv9RulvS4q4+WOHkG77VGMxae46vr3T9JVP2kxr19lEbKBkT
	qjXR2bF7JHiT2sZqmbP9bwWMFjOUQC4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795265984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0rq1ItTuRnDpDVQFC1R3KiJZ46dFQkVrOX5zDg+dEg=;
	b=iPuQY5yhvo8F1ZFFwzG/z3khP4DvoSSz/cOsy2MnDa7BR4XvXWKyi9yo8tTlX4GKgNoz7b
	geRALVWt7S8oL8wGVJzAU0OherMMQyJB5sIK5KRRZUs9yd4OXOUk9/Ijn1DTaMll5bXa4N
	DGATscJEaD8dQzjIhf2im/LNTNl29jU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FKE8Hbqr;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-55b8cd4e2abso21260841cf.1
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 04:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795265983; x=1795870783; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=l0rq1ItTuRnDpDVQFC1R3KiJZ46dFQkVrOX5zDg+dEg=;
        b=FKE8HbqrUYgmKNShSuc+ymlCNWk/iemqnovV59cRNjneU9bNbhOZdAasEyO1Nempq6
         jKsvNOwWfr6UHWODHQXt+yZgQGbI0kBLFugVcYytCHkePB1NPmCDSnkH6yvhio4CtO0r
         IXPOTRV+/HH5TzI8zLoJJHQ6TYrSZ5BdeIUeZw/F+0LACU+9upfbuePmTGsDcMglfMHo
         ZdIki7wuVyeKX9xTAL1rBKJH0yd3ILW1ObkipG9KPGlRKKhlMZX36SD//UH/utGR9dws
         ww25L1Qk0RyMQq303qA6QgXFwU3YTI+Ie9qpNfYhM/5BqDf0vwF38lFl1Z7fKyB2ekUf
         goIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795265983; x=1795870783;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l0rq1ItTuRnDpDVQFC1R3KiJZ46dFQkVrOX5zDg+dEg=;
        b=ry7A2BxITE4MqjvbazDMVcJ/RZBKipaYpJPTnuRegcOo3MuL0hTe9mxCSRUmh8t8Uz
         qLDsL7OlwKI/k7RNm31yC0VGRbx+T6G6pMAGAtpYQkdka02blkVQnEONm9z1lFmEYi7i
         JzCMObt0DaQb5Lk4vul5UllZV+bCIG1AHnMgNM+2zt1rS3G0HylSQ24gSPGknNag/yTV
         jHeV1MvM/mMGdnB5uXLIbPzLXex4TLv9SrYb/Ke9zPp9TlQZSdDq/10pooXDLwTd4mtL
         h5yQm5WUgYskhyYhNRCkxuy4DJlutt7OsPZTZhVw1K5NElqOoBirQNONhUGOTZakyiSx
         7r5A==
X-Forwarded-Encrypted: i=1; AL+hErEQsqxXg+3lwdhnzIsxu//P9+CrSqjMzDTw/BZTZTupSNiIgFTCAMVOxfuClW3eZ1QW5KcZbLDzlg==@kvack.org
X-Gm-Message-State: APuU4Z9AdCNOPppBebtOg4odkWUzQ1DDmYnW1Oe0ed6BL8rnq3wpW+Ie
	NxclMwORju9zK8Nxjpx7sbBiEa8M6OKNLWjxtnWOO5epFk816VpvmydsoB50lEx5tB4=
X-Gm-Gg: AZFdTZc9ZlcsCQcqffvr5dXl6l413yyXPDPinimZCWDQARjotnF/Xoife/CCc14/XUP
	vTuWeURDrv+c9NySLhOKDavNVXDH7F/loH+MvvH/K2OybBCJ49p9N7gh6omvCq/r0ftIymQm+bZ
	nCW4o3v9LPRqjgTrMWsldDsWNjvpHTFVV5dZWycfvbpi+Z7pjWHzTxNPTKviPn5CE6gzaJcVgFQ
	gYYq+6rIo+ZbSpqGltLvjFW0dOky+nN+LgFmccbeKY+mclFhUbv+ZfB2t1gN0mCfsukw8FZZ9V5
	efF7h/QL8CBpyNJHDiumpbAGdyHV+dzZVowq3RJYwrHRBibM7MqHvRTVTvQUF3OvI435tn1D43q
	CRaekH3BZ2a9BOggxvn0KgbxjvzR+dncYeIvuXSSZC3tXcQS5c1v9rUJjIBti7im5j3iNPn+oWm
	XcPUDix7FYL+OrUhCfGDh0iG/xUJU0St3wZKi4vp+P1aPrXKjCNn50MGrEMZbSzSveSCoarN3ZQ
	xWZr78NmmC32AazG0sXwudUAvekRdYc0gNliONKqEc07IES7ctNKGrWyAsn/IHI23JuOsGA5cbQ
	DKoe6A602IYsC3zjoPOIFCY79w9qRh73bSXG9gPj3HHoli2Dh4iZxw41rHk5KGcLH2DYIZRbcSo
	Lx7I7+I8=
X-Received: by 2002:a05:622a:5791:b0:535:1f73:8d9e with SMTP id d75a77b69052e-55d76a6e8e3mr104266351cf.17.1795265982936;
        Sat, 21 Nov 2026 04:59:42 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d78852bafsm49113591cf.20.2026.11.21.04.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 04:59:42 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/1] mm/shmem: don't use the memcg of an uncharged
 folio
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Chris Mason <mason@kernel.org>
Cc: hughd@google.com, david@kernel.org, baolin.wang@linux.alibaba.com, 
 akpm@linux-foundation.org, qi.zheng@linux.dev, qinyuntan@linux.alibaba.com, 
 shakeel.butt@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261120195057.50031-2-mason@kernel.org>
References: <20261120195057.50031-1-mason@kernel.org>
 <20261120195057.50031-2-mason@kernel.org>
Date: Sat, 21 Nov 2026 07:59:41 -0500
Message-Id: <179526598180.412063.14973682472309530978.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: kbo4cnfuysbrkqnzdu5nbqg5ho4m5sjz
X-Rspam-User:
X-Rspamd-Queue-Id: C3A0DC0009
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795265983-510441
X-HE-Meta: U2FsdGVkX1/jT2XqFqWmwnKP1RQA5T27MHWtM1nyauNjetJ8H2ys2CTrnI0K4L7z1foBcVNdiIkQ7xu+1qCrSAJaU5kB5RW+JW9Uiy+XXXVCv3mYuEpba23cKfyUAHFydI5DTF22OboFllSkwybbrTtcASW3o2c7oebI6PPmlZNCQB8BMjIeqdAp+MzZpZ2frgKqT6Yvxdq6JWo1yPjZbgagEoTR5vikSCD0fyvjLE5nI3aJd5tNaM4Qw9L7gIbT+x8q8ZJh25sY6PPKXHqzEf5YyNjyjiSUKKvXpRy6OUua6v2VuP+zLEZpKHoP8nJrfD1fCkJdcQb4iLvnjv8LjX7BPCX2hHWwBCumDIMKU8M+7dfHbCbYzf/PKwQ2WE6wvJD3wgSWTMy3i3zJIuGEzUm8A+7CIzvJxtYBHJX36ib7PvvaDAr5Ihqllz7BS8Clt0hayCspiCLNVAQPeBBZMg0mRXcm+JvqLabiQDQHV8WwP4y24M+PdifSnpbHQwCG4P5+7sHH8ft+1iABQG1V42gOwsdV8dTA4zNs4jS7/ph29Y9sDrcL3ybawTkuevaCfNPgB07OhO/tP26AyvsDQ4Vi7qTojPnIyjOgmoyi0RmU4TOjUeo2Y6k2VcDxUVGsX5v9qNCxkTL3GxE/hkSA1lh5uS6bnSnZI2fkLd+68uyvN9nA3fszFCIDHaU0SQsxSNwIfGWNMuaOV3WJnGSS62GMNOqVNueOJagvcsASlT4Q0oXmCrdbVDzubOSwUjeyjuHZSDGxx2Td4F+Os//ROYvqzDLuPgJX4impQEN2k9EVILDBp3DjLbTGb/FvFVJh1Aho2871Kxx76i8nz6c2QiYBVS+FAlqgxIQ5ArGqVdzF514hH9CpAj6C2H+aHDhJzx6WauL9rgLxZblrqSTIejmzZhZLOA6+V2+8Div2DnTCiYpgNL3Zf2WZqY9FJhiIiKeqxhad5LXFIfvvxzv
 OumrpuWy
 DfpRYeHclpoE10LVIm2ooUWtPqJ9uOC9a7avoHjr3NJV9kI27rxcOSuh3W0R/i8+gt+SDR0c3Fn652TedwxKSx7ZZqgi7BS96vB2VlIzBr95Aizk7zsP5OjiVlAdbUtT7jhyph2RrhMfCDkv/MUYxNGCTIt9AtCZDrmkI6pSYJkQHIyV9Yro7YFN3ziTmWF/yYQQtodcQsf4szVOlSd9O2Qqx4p0nRF6eic13RKHAd6q/4kkCJLV9BxBB1Q8pBHpXN1xj/nzoAAvKk+wA0eKqAGjQH6UkQiJchYB52BVmgzzuEodVaMHqvGsmZN110CzVXt0jmvgCeg0FQryZaK9axQqMQzviY7nHgrHwUWF1RflxjNDEDnJ2eZZmddGjnFaaCd0c30QFx1QmCJgo1aqHBrYrONBC+vSwJHjT8pmBt8Kv2VlWH7hkl0EzdThfZhojx3TUXuH+0DYDPhCNrMrZJy58tJmgS0Ui2gw4+yK5oSSxqR/R3lfAciLcQkyB4JYUvCJ6FXC3PIcl928=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-20 14:50 -0500, Chris Mason wrote:
> The shrinker for unused huge tmpfs folios can dereference a NULL memcg
> if it races with the migration of the folio at the end of a file.
> 
> folio_memcg_list_lru_alloc() assumes that folio_memcg() is never NULL.
> But it is NULL until the folio is charged, and a migration target can be
> in the page cache before charging.
> 
> shmem_unused_huge_shrink() looks the folio up without the folio lock,
> so we can race with migration:
> 
>     __migrate_folio()               shmem_unused_huge_shrink()
>     =================               ==========================
>     __folio_migrate_mapping()
>       xas_store(newfolio)
>                                     filemap_get_entry()
>                                       returns newfolio
>                                     folio_trylock() fails
>                                     shmem_unused_huge_requeue()
>                                       folio_memcg_list_lru_alloc()
>                                         folio_memcg() is NULL
>                                         memcg->kmemcg_id
>     folio_migrate_flags()
>       mem_cgroup_migrate()
>         commit_charge(newfolio)
> 
> Fix it by keeping the original objcg around while the inode is isolated.
> 
> Fixes: 743e7d025d2f ("mm: shmem: make unused huge shrinker memcg aware")
> Suggested-by: Qi Zheng <qi.zheng@linux.dev>
> Signed-off-by: Chris Mason <mason@kernel.org>

Reproduced and validated the fix. Changes look ok.

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


