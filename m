Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 639A4C79FA1
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 03:11:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E6866B008A; Tue,  8 Sep 2026 23:11:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 470C56B008C; Tue,  8 Sep 2026 23:11:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35F266B0092; Tue,  8 Sep 2026 23:11:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0DC8E6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 23:11:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7927E140810
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 03:11:43 +0000 (UTC)
X-FDA: 85192748886.28.43C033A
Received: from mta1.migadu.com (out-58.mta1.migadu.com [95.215.58.58])
	by imf13.hostedemail.com (Postfix) with ESMTP id BB31320003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 03:11:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="DsBF3/YL";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.58 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="DsBF3/YL";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.58 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788923501;
	b=lWNipZ3MYhNvWHfOlxDXHdOGCS6BJnDGB7FYSlrtM0Od/SRBHoktNy2qmXm0J3wpQSjrfL
	rQEhRx/XpSaAiEjXJHMp2IunHSj/49Kia3jsIkJU9VZJSvJEZdqs8/zKh568uZTyj2YI9x
	Ah14D3Vme+7nL8lbStFz2Y3EUdyvmnA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788923501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ysVGVBCV8TAeaH+TrG0tbZQp2AZkNa4ckYY8TcN+4N0=;
	b=OdJIJ7eMqrFEPqEKWJZ1GHduKlGqdX17CfaAoVmLlPJm69khTx5Q6ub9qLHw4xlFxC9Hld
	+dB8c6gqGUwGvjyiyfmwxexr+nCfkiYuOoUBfpgxr391lh5jfwTYNesV8KogZFpQdFjC7f
	KCERuKYTEzx751ToIj8iZ963NPEyZCo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=f2j1DxoU0lmQ/fI0keOTiQxFdQCddTWeKdh1RnG9jVs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788923496; v=1; x=1789528296;
 b=DsBF3/YLqCSlUXnHTz3KHa8Laa7Xz1N/pgRB7PE8d4SKKlLthWbLI3FWJUHsHD+oAOG5hoy6
 BBqR+yqXUOaxjP5O94XNcUcfXDZL1TpY/Fs3gJBucU0Fl7HjDZLL9rdpRiL3JZHBGPrg0nnvTA1
 LoSF1rYQxo8K1hP1VSXY+Gw0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id aba1175d2e6d8a11;
	Wed, 09 Sep 2026 03:11:36 +0000
X-Mizu-Trace-ID: aba1175d2e6d8a11
X-Migadu-Flow: FLOW_OUT
Date: Wed, 9 Sep 2026 11:11:33 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
	david@kernel.org, mhocko@kernel.org, ljs@kernel.org,
	ridong.chen@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-new v2] mm: mglru: clear the reference counter for
 rejected folios
Message-ID: <aqDOZe7oM5_3p0lK@fedora>
References: <9214e36bf738fcfba86acc8cea85dff4010f66b0.1788918714.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9214e36bf738fcfba86acc8cea85dff4010f66b0.1788918714.git.baolin.wang@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: BB31320003
X-Stat-Signature: pjs7qrzrkm1iuauoiju3assyr7cbx84w
X-Rspamd-Server: rspam01
X-HE-Tag: 1788923499-218274
X-HE-Meta: U2FsdGVkX18DRJEVWzMRZpRZ2CxlwZE9MZbwSFaHgncC/yqC5edA+5ofRaK83W9oaWfIxY1JqLD8XunIqlHSsuRwF1krCkv8LnO7yOdpx1ru/CUTOdbZaGjUwzauyf9/nqF+JqkmiphWWANOWhAZzwZruq8jY977M06yOhVUI0RbIfnF6B11kFtur6Y3FOdnFUkFfwp2d5R6EkylmDyXhTTgUF7pgh4AbHt9Vhpkg3LEH8bLu1wGvom2/OUBI0B3H29rx1IrE7uKJTVXcw+3QpR4XwH3bFdpqZ4u8cmPAICrh9pAwW0e/fzTqiCSvBR3MkPvrc2BG/0eWEdXQHSQrfweNp/BbpGsug3qZCjEhBOxu7TFtCTLpMWXJw3xMt+EZTvXMNIpTIvfVBTd29YtKg7wP/l/dqWWIfJJlu+JMZ8AdDlXW4QfJ3FOPDjhfHChwEr/RPDVfUdZ5u1Ck5MCIIfiIY2t/JoUknwLfyjpaCKvHIJLfRpF3z8aQcujvoXnQca9Ck6Oh3+rJNK9IbraJUYmlrrXKhFh6WFxcsZkdYiiqXdKra51rWP3/rhVRXX0g0TlWoFvt7kEJtDNZGJhf8PUL20uCizcjLNNzvi4iJy69a2fCtivvYgQBQVaRbqQnFey7Rl6A1PilDuMI7IkHWn0oUpp52mdhyTn8ABXV86hMqfDSZPDCi8DvJLjGpaLAFm29N07maagbfZ8D25ZaL1OAVBt6PqxdZwGKvtFPY51YEV4TXTYHcZalxd4iFNe5zPmVayhfCNEOUNbvKgfMpo3TmsEpbG16OBtx1ICoKIi0u5j3h3/p8iXd/DEGPvpDz7PB5UwKYDl/IRIqT9yRmPTTTwuc2yV3eKxskLXTgDTRWBBIxH55Z3/m74iB5oi0eBOWeZxFTwbPzbcTS7fWFGRetWLO7D2wrwUjDI7qSmsenamvqDb9sFx2KtOT2vjVcttHf8r7QFx3v3R8YE
 bVxunbNh
 MMJrFk/ijwZoIew4R5SIGA3ijCrXQz/lKu7H05v8xBU97xNvBGICp9bhcygSO/AhaeaL+T3OtdBFrgurZ72cc5bnvigUE8FDXZWvYQ8nyANGyBnq/vEAYTVdT1il++p3f0Lep7ycHhaCkJKqfWDI8RH/ATaYG2iCKqxn/PU4hFRVeW8KJtPqnT0VK1k5/N6p7exsQ97qiGzfgTHHx5sGUcywSlPbII/NDIO4ExHJrrpmqpbhK2x0UaCIAdtFaDEOq4DvUKyJS+Hydks4Qx40SytDQRlAoeEQ0U6Fa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/09/26 at 09:57am, Baolin Wang wrote:
> As per the comment on LRU_REFS_FLAGS, when accessed folios are promoted to
> a new generation, LRU_REFS_FLAGS should be cleared so that the reference
> counter can start over.
> 
> For folios rejected by shrink_folio_list(), we clear LRU_REFS_FLAGS and
> set the PG_active flag when lru_gen_folio_seq() would place them in the
> oldest generation. That's fine.
> 
> But for rejected folios where lru_gen_folio_seq() returns a generation
> other than the oldest one (which can be treated as a promotion), we do
> not clear LRU_REFS_FLAGS. This can violate the promotion mechanism. And
> this means the rejected folio enters the new generation with stale, inflated
> tier bits, which can inflate reference counts and distort eviction
> statistics for these rejected folios.
> 
> Fix this by clearing LRU_REFS_FLAGS for rejected folios. Of course, I need
> to evaluate the impact of the changes, which mainly falls into 3 cases:
> 1. When lru_gen_folio_seq() returns the oldest generation for rejected folios,
> there are no logic changes, and they will be put back into the 2nd youngest
> generation.
> 2. For rejected folios with PG_active set by shrink_folio_list(), we only
> clear the LRU_REFS_FLAGS and do not change the generation.
> 3. For rejected folios with PG_referenced set, the original code would put
> them back into the 2nd oldest generation. After this patch, we will put them
> back into the 2nd youngest generation.
> 
> I think case 3 is also reasonable, before commmit 6cbdd9726fb5 ("mm/mglru:
> use folio_mark_accessed to replace folio_set_active"), a rejected referenced
> folio was also put back to the 2nd youngest gen. Meanwhile, I didn't see
> any noticeable performance impact on my 32-core Arm machine when running
> 'make -j32' to build the kernel inside a 3G-limited memcg with either zram
> or NVMe swap.

According to our discussion in v1 thread, the patch log clearly states
the justification, and the code change looks good to me. Thanks for the
effort.

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
> Changes from v1:
>  - Update the commit message.
>  - Clear LRU_REFS_FLAGS earlier.
> ---
>  mm/vmscan.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 40d3f1b48a74..1557679aadb1 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5020,11 +5020,12 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  			continue;
>  		}
>  
> +		/* See the comments on LRU_REFS_FLAGS */
> +		folio_set_lru_refs(folio, 0);
> +
>  		/* don't add rejected folios to the oldest generation */
> -		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]) {
> -			folio_set_lru_refs(folio, 0);
> +		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
>  			folio_set_active(folio);
> -		}
>  	}
>  
>  	move_folios_to_lru(&list);
> -- 
> 2.47.3
> 

