Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F25BCC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 16:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBFCC6B008A; Tue,  8 Sep 2026 12:56:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C495E6B008C; Tue,  8 Sep 2026 12:56:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE94E6B0092; Tue,  8 Sep 2026 12:56:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D1E86B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:56:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 12341140671
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:56:57 +0000 (UTC)
X-FDA: 85191199674.08.D952395
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 453194000A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:56:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oaCiuBJH;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788886615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7HFhd4KDSfD7wKAluuKwUfaCYQwrDIt/d+mkB/YfLSk=;
	b=tbZYc+gdfx2WlvDF8sl4DQE2ppTba7ApVpe0ugvv/doKfXqeQ1tEtwBc+t5Ho2LYGJ1nGn
	kVXwNVPzfwaHLx5EVa2UzgbfFLMm0iZ4mzJot1u9lwv7Hb0AGLvFhU02c5NaadrNWG3DNV
	DGbmI29p5RNBvnKL7GSHhN+2iAH7Q+w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788886615;
	b=R8RWU2GkgO1HeJKtDr8G/+TjkJ94Np7qpt/b7jB/IUVSNxvZhylXYFmPpTmn/E9kHy3GS6
	oRya52uEMfeq/BtD2jMP6HayoLi3FSgj4dAE+IHzS1BOZ26mt1jlD1C+7hpSvT8KMu62L+
	z/oUufvL8s2zRbDrnPFSCP4+UTJEQW4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oaCiuBJH;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 58A4843CE3;
	Tue,  8 Sep 2026 16:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E39A1F00A3D;
	Tue,  8 Sep 2026 16:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788886614;
	bh=7HFhd4KDSfD7wKAluuKwUfaCYQwrDIt/d+mkB/YfLSk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oaCiuBJHcKgdnJXHuF42Gzn0lhaqMVP/UkFfIBAUqBxb807yLavtvcGoPz6cRuN6G
	 Gz9iTzi01MNzkULWuYzsM222rtvW8VlUZsqcufeVph6urpPk1fq7jq+DD1dw4nk/7o
	 z5o9hGwvA0pLqg0VTxIpay5TpKTE2KrpHOap8FxcJCTa/boF8eOrk3WXzh2hSkhBvd
	 mwvUhIhsgTgjsSXbJWaZcRSbTgrCrB/nPCczcKQokivuwdrYgXoEJj6JidRCMzOuNE
	 C0XjaiTLaVLDiOD6roe2m8oNg3/4w7dtuyMQ2SjWxQoBAZRvpcNzsLJOKeXMuzgb3U
	 N+I5lEnfyJ+xQ==
Message-ID: <9395aac2-af01-42cf-92ea-4e3d5e7eec6d@kernel.org>
Date: Tue, 8 Sep 2026 18:56:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/14] mm/page-flags: check page/folio->private instead
 of PG_private
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Jan Kara <jack@suse.cz>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, linux-fsdevel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-9-6ae22f9d9272@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907-remove-pg_private-v3-9-6ae22f9d9272@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1duzs94weugnejfwfz9nj6stkqtd7cyg
X-Rspam-User: 
X-Rspamd-Queue-Id: 453194000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1788886615-52188
X-HE-Meta: U2FsdGVkX19+kYYqn/PpnQ1I0h9WIOPwMZc8tJBwCJ3+0rcnUnmSAL0q0GXNwMJf4mS8iPekOhJAVlyyjJ2WzGaKZ7zieo7l3sKXYt7J/s2Rc8bdtColUVEK0i0G7AIe0yI/yeoI98iQLfaR1i+mmsWwMDYYAApZyvwQATnmZd6FTRBW2CwQDamogmII65DAk3pjD8PVET/S7MyQASQKK4K6aOP4iVcJBWWvuYEdMz3DJLBtP+wfhYXX1ySKakMP54zb7YThKjcKJwT0wfhDDzLr6m0+szGvtVvEzBKIN8qOSSYNv0o5rGFgMIE6zPQINHcE83k5Y/4uAK8dIe6ssEtgflhnQx+nCcHwyXxbVtVKQ+r6Aibw4gA5j6Q9UFgnkSaYQscLLcmBM03kng92GqcCKdJRymJV48mYwmDczBNPDMl80LtUd79rD2lISrHXWYDGuUmuLED2OftVnORSzEg08MzWadBI/OHl9Obkp1utGlKP7gIKhzmxdOiSQtAErEvuUvAbw52M6ysvSYH1AHQoMuBisYQjSESlUplWcJp1McIOJ3zqR2KyUikN7Rq8lq98ULohC+wmZ/6VAJvNCTFxsy4QDLSRwyKV/Q2YBe1nqTe+ky9/xtAKln82D+H800mqezjRrRU9RlfWooQ6uIP5ZB8lt4lCt4AiTwSvWAeUvm7Rfa2dRSn1uwgvNPgkEvzWqp8D9K3VkLqTbuIWYHnx7eyEkZS54V4nrFoyCHMR63aVPm239XWLntsptdUS3nZxxNkvLp6Qn9rixVGK4GOSLPrAZU0ULLVBZUwRIFpOBOKqjrpB438olAYJ8vnaiKILTXSHER+zAsmjjVGmg/0WOL30NCvp1ef2/kzii/ZgxZf2gqUtL//CkZ1FwAjS8MY63+lMjmiaLXbBuCX/MO2Vrdq4V+JMirI/oBfhlLH+ACI28q4iU9+ZTUePA3/D/eX5bglx/EskgunQot+
 xhZxnqEY
 fMo1PyxSdscms4+txxhS62W39AXN8VWzBieTcw+Atr1Lt/KLeRhVBP7g7mEitNwGORLCImvdy3nd/R9PTTfyxj7mykRiEHK5nkqwkKby3pjM4sfkGMcuuJsQmmbIhefCZ8EHKO+vUSqoQOzi11VKTasxhfdtY8uWWarNTzkDR7XLWN0fOIBSrgaGZ0KIetUjBfg5bCX6vkqYfFSkeRShv0HQAdRLp+aT62nt6Twvs9PpJ7ABPolONn/kkjHcjBUAGbHkqXGjoJ9aRIvOEor/Ym6t3vnZ08LdQFTML4q5ci0h2kQdQtky/qonmn9NuGf0bTaxGY5v43NNaMP9lF6atYtYLOP3uoSelRoJVQyc99t0oCbU+36ChXYiIOJmsBWUU8UK7sEgnnGq8UQSdUGR+3XO0RsvnJhThPH3HY9Lc0FlhySOlufKXqJN3EpSpvBs/bx4fT3LFvWMWj/73rgC2aEOiJQ45oq0+RlQ2nblUTlna63iExYyXkxVCtl8xrcpmhCjKDVrfrTG8bxME5rA2uybRvsVenaZFPSFhvLordAShDghIXUK3EOyNeQO2uoYge8lYhYJ0IdFL8tXz0coNj9G5tToqw/ik2G0og+O5WjAMmNJF/tyoIApTFuj2XpdkbqXS3GbXV9RqU5Oh9haNERwoPbDKHw9XetP0ixKatG0tUeaeA1Yy6I95mDNO5oQp9u30xj2oHiZlaa0rY7OpO9nmmgVlS8Kh8r4SNh2J3ooDK1RIbT2fkvxfxRcm0w7G9FjNPJH+DEbyOi3vUK0HG5kyWDgCZORSjHnV19hEIaWBxCVcuc6VwPRtscsRBfUykKTZE+SuwH55J5Nu+8JBJ0TUCPjROAkqRpgCkiUzenOytEXPiG9p40gMzbo7/UoyZt8fSIQxJ0Dze54n4wd5DDbGid0/O7B50reiB0qnEwxiNHO6+Iwb+ysSqRg+X3U4TuhM0JkhGdkvobf2/nJCKzaT68mK
 cHlwS69n
 8jCg2A/kuQw0bq1+ktwc9CgA+o9FZbRs+gFDvp7ADNmHi0gGPcl6V/mAgTJ224NClnmM1Tx/d42gjSBAGt4HvvsQ4rFtYYaHWTzutQ8bRc2VB35oyISK3zCveZLcnawEw5Ut/kROcsZooGtPrrwMGwBEYBqBnEHv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 04:56, Zi Yan wrote:
> After the changes of the prior commits, page/folio->private != NULL is now
> equivalent to checking PG_private.
> 
> Stop checking PG_private on pages and folios and use page/folio->private
> instead, except swapcache and hugetlb folios, because the former uses a
> field (swp_entry_t swap) overlapping with ->private and the latter sets its
> flags in ->private. Exclude swapcache and hugetlb when the code is meant to
> check PG_private only. PG_swapcache and folio->swap.val cannot be set/clear
> as a whole, so excluding swapcache with folio_test_swapcache() is not
> reliable. Instead, use folio_test_swapbacked(), since PG_swapbacked is
> stable when a folio is added to/removed from swapcache.
> 
> folio_expected_ref_count() can be called without folio lock, so annotate
> folio_test_private() with data_race() to avoid triggering race condition
> checks. While at it, annotate folio->mapping too. Add data_race()
> annotation for other lockless callers too.
> 
> folio_set/clear_private() and Set/ClearPagePrivate() become no-ops.
> PG_private is no longer checked at page free time.
> 
> Remove KPF_PRIVATE since PG_private is no longer used.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Andrew Morton <akpm@linux-foundation.org>
> To: David Hildenbrand <david@kernel.org>
> To: Steven Rostedt <rostedt@goodmis.org>
> To: Masami Hiramatsu <mhiramat@kernel.org>
> To: Lorenzo Stoakes <ljs@kernel.org>
> To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> To: Jan Kara <jack@suse.cz>
> To: Johannes Weiner <hannes@cmpxchg.org>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Nico Pache <nico.pache@linux.dev>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Usama Arif <usama.arif@linux.dev>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Qi Zheng <qi.zheng@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Yuanchu Xie <yuanchu@google.com>
> Cc: Wei Xu <weixugc@google.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-trace-kernel@vger.kernel.org
> ---

[...]

>  		/* !PageAnon && !swapper_space */
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 40d3f1b48a74c..9348ebf9de882 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -978,7 +978,8 @@ static void folio_check_dirty_writeback(struct folio *folio,
>  	*writeback = folio_test_writeback(folio);
>  
>  	/* Verify dirty/writeback state if the filesystem supports it */
> -	if (!folio_test_private(folio))
> +	if (!(folio_test_private(folio) && !folio_test_swapbacked(folio) &&
> +	      !folio_test_hugetlb(folio)))

Now that I read that check ... a fourth time? a fifth? I stopped counting :)

Should we have a (in light of folio_attach_private()):

static inline bool folio_has_attached_private(const struct folio *folio)
{
	/* Careful, we might get called on unlocked folios. */
	if (!data_race(folio->private))
		return false;
	/* On some folios ->private is used for different purposes. */
	return !folio_test_swapbacked(folio) && !folio_test_hugetlb(folio);
}

Of course, adding some nice documentation what having attached private means?

-- 
Cheers,

David

