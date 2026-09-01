Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11143C61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 02:11:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24F586B0088; Mon, 31 Aug 2026 22:11:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 205EE6B008A; Mon, 31 Aug 2026 22:11:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13CC16B008C; Mon, 31 Aug 2026 22:11:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E29E56B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:11:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 608918020B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:11:30 +0000 (UTC)
X-FDA: 85163566740.02.6BB49FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id AC72340005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:11:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Xitnv9nV;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788228688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/NslkO98xS3KFNCbusFgiupbdzSsexpBcgAmyvPBir4=;
	b=EtvGy1hM2j61/blgxlWGpc1+7VUeS5U3kNxpTFFemB9SyTNv8si0y0j2/J5BSExmGLTz6b
	EqgHAqbLdM4cceNI4J0fuc5F7wiKjrcLlDJr+/hEP4X0dMe1sHtDHxK9dmO/MpruglltS6
	AUTZ7Hzp8t/mwEJE0bzi4h7WIVy3VoA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Xitnv9nV;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788228688;
	b=LqQ4iBSCoBA0c9z8iWnD+5x8VyUzE+o6/mp3O9gbm5mnhvUBcJTkgUsEtGZUENSHmkP5Na
	SBpHWIVKNJE7fbH3gBDERi1HU8tfd7KWu4sABmuN3jsWZopk0r+kO8t+LDumCnlTG95NZR
	lCArzSoIqZin6/TIUyK+pMxQzs/c8uE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 276E3601DE;
	Tue,  1 Sep 2026 02:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3325D1F000E9;
	Tue,  1 Sep 2026 02:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788228687;
	bh=/NslkO98xS3KFNCbusFgiupbdzSsexpBcgAmyvPBir4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Xitnv9nVAb7cLa7yB+vxqTcyFGeNeXm1J0wHfMigyUjeDeuyfGOCBxDFDrHJJ2w8M
	 7k0BZr05c2knXOqnJGm+gmlOwQJjUYn0GeCgmBQAIOrJNryGED9BM8XWpCuFFnuQ+d
	 jn4koTWL3ngHERQ/9HCVohH1479IZwj38dMo4veM=
Date: Mon, 31 Aug 2026 19:11:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: bingfangguo@tencent.com
Cc: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Youngjun Park
 <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Johannes
 Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal
 Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Bingfang Guo
 <bfguo@icloud.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memcg: clear folio memcg after changing per memcg
 stats
Message-Id: <20260831191126.6ced4642c6cc92ca96cf0803@linux-foundation.org>
In-Reply-To: <20260831-memcg-swapcache-stats-fix-v1-1-1c0819ebdb86@tencent.com>
References: <20260831-memcg-swapcache-stats-fix-v1-1-1c0819ebdb86@tencent.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AC72340005
X-Stat-Signature: na6z1opaksagsr98i83iehdkh5iq95yw
X-Rspam-User: 
X-HE-Tag: 1788228688-551616
X-HE-Meta: U2FsdGVkX1+Ggl1sUWwI6ei+JBh1Y1pho2V9xEQfe7K7npm29tjKO02upJZ6PoXI6jMQnRQLqlNxvlg7abAZU9h0XkuFvMR2ty0hoNuJ8uKKCN0kxQV2EacESl/ZzdwbgXELswcAGP5xSbsSwwnPDk5zHdy45rXQ7M7axpEU4mO2hEt+UxG11RwQrIlRmE7/BxIPZ2ichzlaXJEc79AH1riJtGIRy+S+lbELaXm4ysXFZIKkl0dDpEHpQZPP5zE+BsMpFrmSsg3Z/QsojuU9k1Bj7iCVifvxIoeGEkHYufF/o5c2LrkRg0cJcncVp8kqRZJvYJOBZejoufeQR3dJXr3k4hpQ/IreOmJ5j+oFrGvWvT8tzFvGoan3IO4sn1UeGYGhfgILxmE3CyezWhpKEQaDPFMA1zfBDdhcBsN4y6gJyI7c84sHLzKaXOm/mJNtuDnnihmfrdFJg7YtQM2t5J8GxKP+zfytZ7Mv/4Eq2E1JVYoiloDxiTcezbrMGs0TCeYJ5yP0WixCjKK3Y4oPGGz8iclq+DW083DycDdmjtWE6jbDO3Lc3RMvVN/hOfbBMIFwk7ucLioEj95t8pLMDab02VQ5Xec+hEnViMQOgtUzKn1BbYrxRpdDItyUML6zYQU7JEXfPlENUCgWdP7GicZ3b8+QSN1uVihZiApp6qadzNTbxbp4lKUFA7Wl/zdQFScTn1pEi7HLdQ55vR1gDIje15O2ZspKfTERjhUXkWreXgJQQxFZP36kNNAME3Y3d3BynJSMuBkcSoO5dS9K94t4xsCx4LIEWjIGUOiubsfHL/W9rnjYb4EPfwmEZlptsKdV167zONxQmU3LWbAIVw6pDDenIhoj2K5TCKWNvacwVOVJ3z0Y2Sc7PsRZynvpQbZBA9NbA+hSK8JmKnIA1fqK+vI1MtLS+ZPRsu6/MGl05aE4vnNC1qb9tZT/xUM0VfTxxUdgw/MrXSrdGa0
 sgoP6+DM
 bOBSKkXRWbNsMBVwz/ZasjMxAtmKkuKeit7MP5F2q8bGz4zP9PXKC8cAGwDzLCIzBjAQlvz9cIMNR2J1jNeNbfmfz783bVJEqokiLYXDJl0jKnm5Y5y6nglnOMdkXbR3wmEJy1l7UpjcfBQQuoLz7FmnxSxqS6m7foVsF0ylq/jd7+SgtzYR6NSBqO0/hVbSnM2QaINmrYh2kRzBPnwCX+dLpZC2Pz/o3pJchTiOCzmZ7tvdpoiMEEgjGekwNPxMAjNAcXf4/iv3cBQEaAQVlhA6e0qR2c2I1IbWNKq/pOnGH2fgWeZHLRxaZcpV6KeYrirx4wto6qbOQsLwMrwao5brq3Wg1lCdlqQq3A5iAtN2aA6jilKlQe+LzQrns0N9E7VDoooBJ+bmhE6jrNgDVveSlk5LkNli2oOpECBn85mdXjC9Hf5qsKZm0hKveSHU6x+XSJwPR6XEnuXnMh4zEpwk8IXwpus1j1pD2HDQKl13e7KZzqttdyk6Rwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 11:32:43 +0800 Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org> wrote:

> From: Bingfang Guo <bingfangguo@tencent.com>
> 
> __memcg1_swapout() transfers the memsw charge of a folio to its swap
> entry and clears folio->memcg_data as part of that.  In the vmscan
> swapout path it runs before __swap_cache_del_folio(), which then
> decrements the swapcache stats through lruvec_stat_mod_folio().  Since
> folio->memcg_data has already been cleared, folio_memcg() returns NULL
> and the NR_SWAPCACHE decrement only updates the node-level counter
> instead of the memcg's lruvec, leaking the per-memcg swapcache count.
> 
> Move the __memcg1_swapout() call into __swap_cache_del_folio(), after
> the NR_FILE_PAGES and NR_SWAPCACHE updates but before
> __swap_cache_do_del_folio() removes the folio from the swap cache.  This
> keeps the stats attributed to the folio's memcg while still recording
> the swap cgroup with a valid folio->swap.  Add a swapout parameter so
> the plain swap_cache_del_folio() path is left unchanged.

As always, the most important thing to tell us when fixing a bug is
"what are the userspace-visible runtime effects of this bug".  Please
update your prompts to always tell us this, in the first paragraph.

Clearly the immediate effect is messed up is messed up stats
(memory.stat?).  But what are the subsequent runtime effects of this?

> Fixes: b197d41462c20 ("mm/memcg, swap: store cgroup id in cluster table directly")

Quite recent.

> The problem is reproducible using the following script and program:

OK, thanks.  I agree with putting this info below the "---".  It's
probably too detailed for the changelog - curious people can find it by
following the Link:

Anyway.  Sashiko points out that a CONFIG_SWAP=n stub wasn't updated
(this happens often):

	https://sashiko.dev/#/patchset/20260831-memcg-swapcache-stats-fix-v1-1-1c0819ebdb86@tencent.com

so I'll take no action at this time.  Please do update the changelog to
include the runtime impact and I'd like reviewers to suggest whether we
should backport.


