Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF2EECD6E64
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 15:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A22E6B0005; Tue,  2 Jun 2026 11:20:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0533B6B0088; Tue,  2 Jun 2026 11:20:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED2E56B008C; Tue,  2 Jun 2026 11:20:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DDB076B0005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:20:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B79F409A2
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:20:28 +0000 (UTC)
X-FDA: 84835334136.10.8D7EC58
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8576C2000F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:20:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ir9K3+11;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780413626;
	b=cuUKUwDOmf5hG0KgK0XexRVFnSh0p/T3jZIrRnud2EJn8mvVFVt8/odP5/KV1ldsrm9vtR
	TIXcBykKJtyk58g9mTHsyCvdHr7lGGshgAWABTzGeBZINk470xBGBmOYQdssVogwTuAe1u
	Hx37/WtsQqZql+eMhhPQI8LSPkFoNmw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ir9K3+11;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780413626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ioWIH2vIGho0+8O2jaAg9vyx3qwy9l2LVl4YVTBtgfM=;
	b=SknELtR48J2DuhOmhppl1vwNXR2GSkvD8fbnCA2TL/aFa+Jecg4GlPXIKDq/l45eF20ykW
	KBXoYTsBHzOWArQfH2WDMN9XTOIJKnqUgr8775mDp9f25YWKa4ryTfSULxuFmHqsf2LLzD
	Jc7qrCXUvfOZ9F4EWyqNuezYGIbdjg0=
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-69d7aa0ac14so6920963eaf.3
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 08:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780413625; x=1781018425; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ioWIH2vIGho0+8O2jaAg9vyx3qwy9l2LVl4YVTBtgfM=;
        b=Ir9K3+11Fq3VSCJlN0fAqxf/YEjyeqnqa5YyrmpE1m0L6fIf7sQeXSLLwRUbniTyx6
         jRJAxs9/8S8j60Ug8tQzHwcH1CdGREsctfcz9Bgc3WkgHRgXkZOBASV4nOzV3Lvlx5CC
         Ibtlblb3TNPPGfuMlcnG7NJDUK1cZJwkDFaCiXNd6nm4jDeTrUS5Y3k+qo85fn/oL0jn
         LIybd/sz6VuEc1Q63yonhtubIZDp30c/q38mfNBCecf+LaFMkEUZkBtdrqeiLnDKNKGl
         yB3kyA7TmK/cj/ydqCq+RSIA4MV8tINw8KF0ItXM03STFX06wFHIXhQzZcu5U7qnKQIh
         nIoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780413625; x=1781018425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ioWIH2vIGho0+8O2jaAg9vyx3qwy9l2LVl4YVTBtgfM=;
        b=O5W0aRkQvv1GJVufzH/sFds+foUFGsQXA4WAqWkOLU6baaukdnUxQBr3TbZWsOrUMH
         OpPo3FJVaBD/1zY9XzeJbs/QR0/9bgfU+teRTqtbSRnAW+tLpoWxL1qW6L9zQQHrD1sm
         IsojRnpy3rKHcKhYr7o5CWX0ZTNk3xO/W8WA+n3UAA7E+v1ywWz5ds3L5sJLzX8hUqme
         Ku9HLQgwcRzex8SOlh1mxDjT6Ekojb7vCp5zXklAwocT4XSblQJnVVni6lcqhwFpVqL+
         r8RB7O0UqPvFL80GKFrPltFqGuZiWfWRZK6sz4U20Yfm10T0/tpWTcB6WwspFxD/8+wQ
         wzBA==
X-Forwarded-Encrypted: i=1; AFNElJ/U4dzDbcbZiVXcookw/Qa+nrmxXSUoGCsIdLbWUy6l1SzYGhGpUVce6r0KbrG/6Xz03nbcwbD6gA==@kvack.org
X-Gm-Message-State: AOJu0YzqSGb0ySuEw1RxCvGa1lTxCiUxY/Mi4/ZYcauZVRL0xjlKDUzS
	B/kVkfeA4EVGGbY00gPSUEKFWtfpqOLMB3PNCPx2aFKaXCc3j0ARk9iw
X-Gm-Gg: Acq92OHbViilw6xkfyvkwOMD9q6Bejr1PPCRQNUozrimGFx8EbaEC6CBX2P1VwZw8Qw
	FgnuR04FWdtV/mFMQzRxTXU2woHq4xNqNow3CRaJlUod17UdYrW6dgye4EWcmk4cQlxBcNFcfyw
	RR2yN8+DHRKQixpoHY+T+zFnjXtmnhx9x/uWc5uHEhIFE2NBcMTXy0EDn7tTyNK9xWP5DP6Ru/h
	bOkQVY2Rs7ziH5nYRLd3imbsGEGS0wLAd7DP76kPvJ6TPTqNQ5TGMGtiKIAf1lzRqDzwfeGVWnV
	VkLzdedNXWP72l0IUH+aDGC3mzhUL86HvFZus6kDnEqvWNrjpaTboMc2n/5s/53PcSX1N+oiOQ7
	qNhHX6sApimaq1C54Vg4Vxk62vmDsewEZi0YZm0xgmVEb5ZpvDS+1jZ2H8qGA5MH5z60INKwWPM
	BqWbWsElhkhDieW1DXKDnM8TAtOT2l//LBBQz/qyIAkwu5kt0C8k+bfroL58qfcq9r
X-Received: by 2002:a05:6820:1886:b0:69d:8d74:d7ed with SMTP id 006d021491bc7-69e46ac571bmr19177eaf.26.1780413625357;
        Tue, 02 Jun 2026 08:20:25 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:73::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69e46267666sm95902eaf.7.2026.06.02.08.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 08:20:24 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Charles Haithcock <chaithco@redhat.com>
Cc: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Respect mempolicy when calculating surplus huge pages.
Date: Tue,  2 Jun 2026 08:20:21 -0700
Message-ID: <20260602152022.2673803-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260527224848.1753560-1-chaithco@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8576C2000F
X-Rspam-User: 
X-Stat-Signature: rzcz7uids5p6pgj9wii18wme5ryrkch6
X-HE-Tag: 1780413626-437541
X-HE-Meta: U2FsdGVkX1+hZzfdd0SRotpl61KexUnYaubuL6mGU2XTPXNIawKrymNxE62Rh9Vp4rqyn2FzCSp6AWEGM/kfijxiyl5fr+kwxH3to/ovegje7EIsU9wfck4pxP9zAx9EBk9EJi9Tm5fzEkX0Li8JLUrXNxz9UhLYshUup4jG3Nt8/EAnOoQ/D1yt9UH8fjVmcDF0Zf1GgtPCSTWtRuJo6/9JuBi9ghIy/6GUm9MZOYeUD9s0aqhncaGaPLCTmQdZEQrqalCPzxYZ/3DMb7WK5EsQnJ6RTz4lFc56pnjtChjF5vGc+4dgQnGipt+cGQHghOx0JWhxr1afEHM24pFl36zo87s8H4jAwTdyOJFvGTlqSvnAXS5gpO/FTZ0CSrYf2032ntxVwnDkgDEwA8CaTbh4fY8gYFO9Vih6tgfjqd9Ak1fXUjs02k/tqzpUkdci0WlxFvkjgK3VvjDw/RRiR38LfRHpfIfM7G6CI6T5RrfCWuNUUDnUlf5mtbozxcNe+45VnnJ/1iUH5NJrLxiiDb9M0NoCeNVO2/uTWQw5MCCIFT+5yKdSkDXT2ckWrOzQbBSRzvKMUXs2tQP1csapRwPVAxnB8IkFMahAC5mkvqEVM7tejccErIGHPzYbvv2o75x4xXNlebhU4hMsq4lIQEy6/v8WlHZsFW+lZOm2OogtPU5U+HKh0xTV6MJweK1HFwRNmHlQwwQZ5W/FKsuriQg0lkZo0jQhDg0c2NjrccrcJo68lWImyc12hEyyp2umLw6mHjWJo74Ogb75TjcUaXVgf08JwolHEi5SrB8gjwLIVg647n3O1b5vk+dYAzbUD6Zji7heRAZZhymodb/ecv/FAK55dIF+vFf9na39OcgzogQPjcQC/QzKkKgMghyEa0aURa9g7k6sAUWIfVkfznit0Yzl+MyLDn3OnEsYM5Qcbm/jPBwcYMR0vAWd+vVe1VfI/mtVQjRhfdR+T9Q
 ui/Kndf8
 MJJmK5PRNiRcLHrJ5eZWWMUrBxoHqRJdaHwYMASsrvC7O1f/VqST/PY2BdFguch0thv1YRdxELxwVEDd4TqSZktinZkAjwDME1Ss5mc+DGZnhEU4loPTdgpR/Y1hwH7tCNOZ8h7l4REgiyQ7SCQaS/Qkgy5kLGJxSZJW1HSnowqUxcH0vEaxvt8BFg4OOwVk7fo1V/XjU9fosZy03LWzFlZ7I0ZCmbXeP8Y+5ZmmWuLPWDczjvQKUbxhDzOxTXkF6b72lXDSJCBNYJu7qlD8LMiIcQDw4yRP/e/A27yNpLG5Eav2/OLQDIQlg19YIc0yVpvp4XtE1O/codfhVfPbwzyR76fNACCJVt+jEg/HiTpMXrLtb4+OM/pBpMcNA0yWYCqOU1rfZ/anoNcMXG29uiL9OocfG/Dh0TVJAyc3Nq7S6KcVqWrAN6Vz62OF1XMAId39mazNSAUDfdxL3++pt0bwdo7YwwKVEPThBbI4AMqe7qFfmRfuARqnLHNK06G6VWOFKNwyKpQvkjf+OE/VMzhLxfkSbpp/OBFCA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 May 2026 16:48:46 -0600 Charles Haithcock <chaithco@redhat.com> wrote:

> Presently, when calculating how many huge pages are needed when
> reserving surplus huge pages, the global count of free huge pages
> are used. When reserving with a mempolicy, the global count of free huge
> pages is used even if some/all of those free huge pages are on numa
> nodes outside of the mempolicy. Fix it so free huge pages only on nodes
> within the mempolicy are considered.

Hello Charles, thank you for the patch!

I just wanted to add that it seems like this is a known issue. From the
comment in hugetlb_acct_memory (the only caller of gather_surplus_pages)
we have the following comment block:

        /*
         * When cpuset is configured, it breaks the strict hugetlb page
         * reservation as the accounting is done on a global variable. Such
         * reservation is completely rubbish in the presence of cpuset because
         * the reservation is not checked against page availability for the
         * current cpuset. Application can still potentially OOM'ed by kernel
         * with lack of free htlb page in cpuset that the task is in.
         * Attempt to enforce strict accounting with cpuset is almost
         * impossible (or too ugly) because cpuset is too fluid that
         * task or memory node can be dynamically moved between cpusets.
         *
         * The change of semantics for shared hugetlb mapping with cpuset is
         * undesirable. However, in order to preserve some of the semantics,
         * we fall back to check against current free page availability as
         * a best attempt and hopefully to minimize the impact of changing
         * semantics that cpuset has.
         *
         * Apart from cpuset, we also have memory policy mechanism that
         * also determines from which node the kernel will allocate memory
         * in a NUMA system. So similar to cpuset, we also should consider
         * the memory policy of the current task. Similar to the description
         * above.

So it would appear that getting an exact number of pages to allocate,
and ensure that there are no changes with the reservation or which nodes
those reservations actually go to is a lot more difficult. But I think
we can do a bit better.

FWIW, I think over-allocating is actually not fatal (although overallocating
by a lot is obviously not desirable) since we free all the unused hugetlb
pages at the end of gather_surplus_pages. I wonder if an approach like this
could work:

@@ -2260,7 +2277,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
                alloc_nodemask = cpuset_current_mems_allowed;

        lockdep_assert_held(&hugetlb_lock);
-       needed = (h->resv_huge_pages + delta) - h->free_huge_pages;
+       needed = max(delta - allowed_mems_nr(h),
+                    (h->resv_huge_pages + delta) - h->free_huge_pages);
        if (needed <= 0) {
                h->resv_huge_pages += delta;
                return 0;
@@ -2294,8 +2312,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
         * because either resv_huge_pages or free_huge_pages may have changed.
         */
        spin_lock_irq(&hugetlb_lock);
-       needed = (h->resv_huge_pages + delta) -
-                       (h->free_huge_pages + allocated);
+       needed = max((h->resv_huge_pages + delta) - h->free_huge_pages,
+                    delta - allowed_mems_nr(h)) - allocated;
        if (needed > 0) {
                if (alloc_ok)
                        goto retry;

So we compare the mempolicy-perspective "needed" and compare it to the
global "needed" and take whatever. Since we are taking a max it should
only ever make it more likely to actually succeed with the mempolicy-bound
hugetlb page usage, even though we still can't make guarantees since
a free page on our node may be taken by a different reservation later.

Let me know what you think. Thanks again!
Joshua

