Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FCDDCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:13:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906476B0088; Mon, 11 May 2026 04:13:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DDEC6B008A; Mon, 11 May 2026 04:13:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3C66B008C; Mon, 11 May 2026 04:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7E16B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:13:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 11AD81C0569
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:13:24 +0000 (UTC)
X-FDA: 84754424328.12.CCBE158
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5E4E780008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:13:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EZJihxwO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778487202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P2omvhu6l4/dW0qXcis83zYp9Dewksdbvgx8/as9q6g=;
	b=FBMAgIujwFPQSSQwMdszCwgvMd4GEVhl6c3msn/9prDS8N09r/yvnA4FrpQqBIhlIZ/0lk
	hw6Omy0FKCpq6mKqzMH9TRtpgpM9mm55uH7sxoF3m1jByxJYFyud7fdh3ZNC+hxYx9Eyr/
	CThC59kI5xCKY0eX3CvKHcYQnLsbaGI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778487202; a=rsa-sha256;
	cv=none;
	b=w9F8ZVgz2Tcx4hR26Yb2Bbzpcx1iRsqZFs6En3iAv8vVS4o7oK0gcKqYowaCGrkgiWUYtw
	uGcVIJicooHUieycHGXeWVQ3ATWSALvGcYFdHasZaf//hIPOPdwBnWCRRXeVUPRTn9FnX+
	mKd9Qs2QiQjAIdV15mMf6aKwTpCZyDo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EZJihxwO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BCAFA600C3;
	Mon, 11 May 2026 08:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019CFC2BCB0;
	Mon, 11 May 2026 08:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778487201;
	bh=t4L0ozuEGJMJPzRYPUeK7nfkUd9Xf55sDSkad6aH9GA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EZJihxwOpVWFeeznrgLeQqSQeTk7yq8IelzVwu+39gwCLwmKIMbWCLVS8g72Cy6qg
	 0V4XSfEnj7oPw551RgFyyULnCllILRZxqw/cVQMhhe2ALmi6Mv8v5c7SVG72tFbaLO
	 LILkb++w8XSq97YrJyZtfTnHPkHr0wRwDDVoAmtzEjO9GS62IeS18+LKzZ+EPQNdM0
	 TMbLsjNJJGgs4B8DJDa29+rPlPjfR+xLXwHsJgr61/+JHTez2hBD0BBn24esaxx9ht
	 ENKQLjrEgDlCADpUa7uNzqyvd0xZC1YRnVqUiR213BDbrrdPECYPwg67jaa9NmHurY
	 HhKmo+HqJzQHQ==
Message-ID: <95b8224d-3ed4-4fe3-9954-d5ba0aa373f8@kernel.org>
Date: Mon, 11 May 2026 10:13:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 8/9] mm/rmap: Add batched version of
 folio_try_share_anon_rmap_pte
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260506094504.2588857-9-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260506094504.2588857-9-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5E4E780008
X-Stat-Signature: b4eem33gct68x1atsrrxmaami9uyx9u7
X-Rspam-User: 
X-HE-Tag: 1778487202-137198
X-HE-Meta: U2FsdGVkX1/AAbbc0wuYVSNYePaLbQBc3CGYb0Qk5bQv5TWU9RkTAMjwiVg8niq5OlWCNRSDbXuuT4acEY+2wEd86azHuWkFGD8EQa5ywKMjeNVSw7Vplt84fVkppHV59zdBUGXar2/WEcTAYi6N3X6m5yvvw5OkXoKALiezoJB3+B7/4o/I9i+6BmDefKCAkYGELP4AosvUqFhUv3wEHI/d73LwTG6mFhVdVO/xhrN7ZOjMhfwTUoqEoSEq9Wn43Gxp+0zAfn5lqrTXWY/U8flXCPR3LdHsOJc+csnj2nZF3JukSuAIgQxg6Fsa59mTAgvkpA7Al/xrmCFfiq1KaepHIZLKDSeqw5h5BEiGA6OORtstSW+QIAcL+YE3C0kT1et8EjDD6Cpu/NZwCVi/OuSxvoiOe3rE38L/OnqjDVg9jbYm/76ljyRfaElYB67yZFTz9Nt9er8psugxaDx7x6RtQ+UutFxtEkDoC9RjEC/odD7BhwMzP0sOxG6S9gkD93adMd58KPycjdyLp/TAFvtyAEh5nprXEeO27aJ+4caYICopW7KcWgV86aS6EbzcpJ52saKIfqbWBsBPc9n+iG816AAcZy0mupzMQAb+kckztIe/8ndD2BPX9FnKz8kSHMN+eXPGDK1nt1ZF75X9PrYJDcjAF8nwIAugTRuKeTFL6pjV9LE0mgeD3Dc6kadv1379bEFKqwrvH2Q3oZpw3j/85OoJEk8BJVVX5rjSRQXllMFhFIDNqzj79Jgn5zGRbBgRNdrKl8IZ5QiUZI24q86VcpFdc78XenQaYRa7FNsjSE/IEIEHoN/KTPmIyTNNSZv+7lBqIKGDcsvzp0em8rE69hZ64krbWV2vhsaOXLJiIIVrWwtnV68CsqEg/ewrA0OV8FHKI/Us9hKIgD1eJooe3XBUK41wlaVCW18F1LmmYKq8eZt2xdI0dVdk/VP485vmBQqp+xNnG/tmhwA
 8fLc2Zfi
 YGDeVXKY+VITzFrDC+fOZT/WfLUVAYGOBdHTwyOhqtO3cvIEH8vDzkCyQrk9b8/IpvG7yj8uJgGHCodPyESbc+dhmqPwjG4AJTjWROi7w5QpjBUMqvqNbNQqs9KmC1X4KC8HEtnRsS6lneXURR4ZIlNluDXGTmCcln1PTzc91U6Fd6tyv2ZRz8bOvqKiue4ds0z4HWiaFGk0Oc9yjK9Zjagc+pl1MRL3YcYu+/0PKakej8JCp+5JHY9QN5RQByoFd17oDD/dor/aO1TMGVOYakDdSTPEcPjPwhnGmDWuDBF0a3VYuYnwkpD0DJPLMYsUYFjGucQiYlZjIgoyfK3qvTVawS5BydZ3YIurlCOBT7I9WKjPelH1KBTRfHhfqWPjwa0sR5kzt19T1CqE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/6/26 11:45, Dev Jain wrote:
> To enable batched unmapping of anonymous folios, we need to handle the
> sharing of exclusive pages. Hence, a batched version of
> folio_try_share_anon_rmap_pte is required.
> 
> Currently, the sole purpose of nr_pages in __folio_try_share_anon_rmap is
> to do some rmap sanity checks. Add helpers to clear the PageAnonExclusive
> bit on a batch of nr_pages. Note that __folio_try_share_anon_rmap can
> receive nr_pages == HPAGE_PMD_NR from the PMD path, but currently we only
> clear the bit on the head page. Retain this behaviour by setting
> nr_pages = 1 in case the caller is folio_try_share_anon_rmap_pmd.
> 
> While at it, convert nr_pages to unsigned long to future-proof from
> overflow in case P4D-huge mappings etc get supported down the road.
> I haven't made such a change in each function receiving nr_pages in
> try_to_unmap_one - perhaps this can be done incrementally.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  include/linux/mm.h   | 11 +++++++++++
>  include/linux/rmap.h | 27 ++++++++++++++++++++-------
>  2 files changed, 31 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 31e27ff6a35fa..0b77329cf57a4 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -243,6 +243,17 @@ static inline unsigned long folio_page_idx(const struct folio *folio,
>  	return page - &folio->page;
>  }
>  
> +static __always_inline void folio_clear_pages_anon_exclusive(struct page *page,
> +		unsigned long nr_pages)
> +{
> +	for (;;) {
> +		ClearPageAnonExclusive(page);
> +		if (--nr_pages == 0)
> +			break;
> +		++page;
> +	}
> +}

Something called folio that doesn't consume a folio is odd. I'd prefer we don't add this.

Is there a chance to simply change __folio_try_share_anon_rmap, so we get a single loop
inline?

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 8dc0871e5f00..5a1c874b2112 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -708,16 +708,13 @@ static inline int folio_try_dup_anon_rmap_pmd(struct folio *folio,
 static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
                struct page *page, int nr_pages, enum pgtable_level level)
 {
+       /* device private folios cannot get pinned via GUP. */
+       const bool pinnable = !folio_is_device_private(folio);
+
        VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
        VM_WARN_ON_FOLIO(!PageAnonExclusive(page), folio);
        __folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
-       /* device private folios cannot get pinned via GUP. */
-       if (unlikely(folio_is_device_private(folio))) {
-               ClearPageAnonExclusive(page);
-               return 0;
-       }
-
        /*
         * We have to make sure that when we clear PageAnonExclusive, that
         * the page is not pinned and that concurrent GUP-fast won't succeed in
@@ -760,19 +757,21 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
         * so we use explicit ones here.
         */
 
-       /* Paired with the memory barrier in try_grab_folio(). */
-       if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
-               smp_mb();
+       if (pinnable) {
+               /* Paired with the memory barrier in try_grab_folio(). */
+               if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
+                       smp_mb();
 
-       if (unlikely(folio_maybe_dma_pinned(folio)))
-               return -EBUSY;
+               if (unlikely(folio_maybe_dma_pinned(folio)))
+                       return -EBUSY;
+       }
        ClearPageAnonExclusive(page);
 
        /*
         * This is conceptually a smp_wmb() paired with the smp_rmb() in
         * gup_must_unshare().
         */
-       if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
+       if (pinnable && IS_ENABLED(CONFIG_HAVE_GUP_FAST))
                smp_mb__after_atomic();
        return 0;


-- 
Cheers,

David

