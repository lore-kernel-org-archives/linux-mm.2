Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF5CDC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:53:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DBAA6B0096; Fri, 18 Sep 2026 16:53:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B35F6B0099; Fri, 18 Sep 2026 16:53:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A1476B009B; Fri, 18 Sep 2026 16:53:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 321786B0096
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:53:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F07E1407B9
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:53:57 +0000 (UTC)
X-FDA: 85228084914.01.D20CA3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 928A618000B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:53:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kn6cunyI;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789764835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xubuskVOjl35A2T8LbXWyaJic0HJ1gjUagG1E7uyg5k=;
	b=k3TRcYIHmRlzGoTZfFHUupogCkVBhditHN/320FvZ6+nNG7FmbP2m48bb3fUYNgriogh2W
	KiVH8xUgyibXPfT0SiwbxY1D63bu1gV2vjgOIZ5hfGip7u4/awD4G2fiwTrQqufKP/Iynj
	N5z51KtocewwdO6vUAlecdXUETyNG9Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kn6cunyI;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789764835;
	b=AYuWkLoMiVUyLpmF4A1qhg5DMrG41wVigwiVHi0Mjn9HvUN3JXcYUKeelG5O1LdkTygXhI
	hIsfR795BbjbHNCYznZctUBdFRGaZJ648QTId35bwy+Ko00SPr3PWiutkHX3Ex0vyEioBL
	XVSpW3ZzUUVmwIy2n55WCoZhaPHgZFA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C6F740F1C;
	Fri, 18 Sep 2026 20:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BD21F000FF;
	Fri, 18 Sep 2026 20:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789764834;
	bh=xubuskVOjl35A2T8LbXWyaJic0HJ1gjUagG1E7uyg5k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Kn6cunyIes7b/fgeRfTD/r8Fz5Dt/p48ZFG59t5T2b5RHLeaNgCTrqw7SoEvlPOI5
	 OvuHjFp9mBWp2eSxzlYCzHbBrSV8vl/DXuPzPJZsbYv0Xuqx3JThxg5gE7p21r47NM
	 re8B0ycP+LBJEhifDZxmaPWvMaTdbkP9L8TH7qLJTIaTctBBzxc/RuD/7RF6jFkHb8
	 KWnVoWNdO0FqVgOZmWwuAtlvnO4A/sZK0V15/LeRJeHFJOPaq8+/KJ7WwXC3Fux/3b
	 Sy/yzfOLjEbN8O91kS4uuktMUrONkl0khiUu0A6+wRjAt+8vW3dCgUQdRS96CC41GY
	 RUB7RSuRPKQLg==
Message-ID: <475ff6df-c8ef-4681-be83-2fbd7a68c417@kernel.org>
Date: Fri, 18 Sep 2026 22:53:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/17] mm/huge_memory: move the racy refcount check
 into unmap_folio()
To: kasong@tencent.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, "Kiryl Shutsemau (Meta)"
 <kas@kernel.org>, Shivam Kalra <shivamkalra98@zohomail.in>,
 Kairui Song <ryncsn@gmail.com>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
 <20260915-swap-thp-cleanup-v5-10-39878b37dfb0@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260915-swap-thp-cleanup-v5-10-39878b37dfb0@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 7ctyuuuja4z6qed3swwbirkh7xxru98n
X-Rspamd-Queue-Id: 928A618000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1789764835-273836
X-HE-Meta: U2FsdGVkX18riVITvJpubzCBO9zAo72W55B9ztS5HN0DoqhuFx/AlpFMpRQFBV3bQT5l3nfmtYSrWn6Qk1cP+McwagdXRiuvwCrid2RMrz75aiYChysKf2OrE/gg61Yuho5wRmGBlWYKzF4y4oF9sC7gT30gcFTPMxWzdSJvBAYgQw+e2WDuJzNnkjq3v5jcHWZcFgA2pUMHAUpOUGBgU4Hb6xH+SmWfr04SB6rEXTYLTiTupTl8JIXxUnJ2mY6//e8lG4AGhEwu2FtcjP3DrcMm57A5ufMVsGJ7Ck1NsQYb2Y2kp+WYUvu/uj/Aki5z0D6IMWlGh0tU+mKY/0BS3TLUdhGveYTY1xYpiwg+npvE5vwFf75hqh1jrMfg4AMwt/R0wJ5chUNXGVJR4uAP31DRkrJ1YggHXmFOqL4hW+OH3xiJZ++NPxpCHqs1RmVH4qQl9y5S9S/Yj1MIR3PJGDicYdWCsFjOPX5eyfG1qY3X3wTvWco5X/lOpHHy22Mtxj10dBFwjkzvmk69TukXf0mJVDaUhPc+W3Kt4hHjRyK/vsnEwfv0sdgWEwXjzUxcRzGPfBt0ZnzuWgN1O8BKVhAzdZEwETMIcyUIMw1mxJFuvvvQb44/PN8BC+jskMQ8P7TP1xjo/hDr18AddpP23OMHjusYSlLXfSYIwTf2jJ3lJC3cuoOKO3Z/PvN9U8RLxDEE/LDVTPT4034F7PPg/JYZTsIjemm+rY5rl1VfqF4vbFq1Nc6sGVSpKkB+s0X0aYKJoboSwW12EpuMJVFR6U6Pc2GnT0P/I3xQEqOpTg9BuJIFCMOtAyqb4BwHd7LRY+UHSUVoK7VTW8Kje+Ho2t5RyfFAvPdgDV8ZbjCzbRbsoQTQbT21r5zBaWe8YkixPu5jNO+on8ubH7Isd9oj3BDH19Mg/h2TDYVOtBfx+mF6xkfLz0kut94njSqGmbaS8HupJsfmQHdTlkmOO/6
 e8GvOfY0
 LLIhm9j3e9Musi1CEPCpuJVuSbolKjDTopt+vD+tBlHHonQFaLn1DZ1MTNpqI87NToTakq1+4rhsQ7/xHA6IX3Hox3GdVeppa5TwVG5tHug73wDZ0yPkwcBEXEmI3CcFFDwpynwr2Zw1HIIRuUD6Gkql13+PZrSIj1IajmgtijpGQ4VCKrGp2j6CqDCgVOL3OkeL71+p0L6V3kzMlg9WxnZ88qNO1QKT9DgBHF+IrEGqU7YnEQcqhlPvbM+jAqxuJb1GlSq+qJZ7pzD8Zw20kW63v4WlR83KVSkTNiycfsPNLbPvkZz9GG74k3YHLTaXpy5qAtHALQc6CnFTSGX+ZM9fC7ciBSOUTQk2HOiVBRu9EvNQWKFRrbYYBDFsJibmPXnKB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 19:14, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The check only exists to avoid the expensive PMD-splitting unmap of a
> folio that cannot be split anyway.  Move it from __folio_split() into

and folio_split_unmapped()

> unmap_folio(), right before the PMD split, so both the anon and file
> split helpers get the early check without repeating it.
> 
> unmap_folio() now returns -EAGAIN if the check fails and the split
> helpers propagate the error.  folio_split_unmapped() drops its own
> copy of the check: it works on already unmapped folios and the
> definitive folio_ref_freeze() in __folio_freeze_split_anon() still
> catches unexpected references.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 29 +++++++++++++----------------
>  1 file changed, 13 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 77bf68c9b9af..859aefda7356 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3539,13 +3539,17 @@ void vma_adjust_trans_huge(struct vm_area_struct *vma,
>  		split_huge_pmd_if_needed(next, end);
>  }
>  
> -static void unmap_folio(struct folio *folio)
> +static int unmap_folio(struct folio *folio)

The semantics are special: a return value of 0 does not mean that unmapping
succeeded. It might have still failed, but remap_anon_folio() must be called
afterwards (for anon folios). Might be worth a quick comment.

In general, LGTM.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

