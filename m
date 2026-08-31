Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95595C61DE4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 02:28:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 621C86B0088; Sun, 30 Aug 2026 22:28:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F8EC6B0092; Sun, 30 Aug 2026 22:28:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C6426B0095; Sun, 30 Aug 2026 22:28:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27A8D6B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 22:28:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 455C61403AA
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:28:57 +0000 (UTC)
X-FDA: 85159981914.24.D9C3106
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4422E80003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:28:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JZA/L6l2";
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788143335;
	b=Y4aFfC7Tb5sN6RSpiSyCZq8s7U/x9bDyuTjPjKfCS7l1jchXFzMuOsrr+KOTvup0QoFJmU
	5v0SrBlDfIoAWm8IBNCYr1vpALtUC2xkUixx2W4MbHsc/2IsC53cvhGieAUI6FSPa0flVc
	Dv+AEHPzJoavpd6GuW5abPwSZyGSOAM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JZA/L6l2";
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788143335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YwqNfmhuWrZGj3kuSG9MxCjuM4AM56GhnZE26FcBYfc=;
	b=ldHYzNVvtBSrvs1fCICZF++E+Ar+WluV9kNTin1kJhEoGyoNmYrrwiqZZkUaflLD+fAOIM
	j8UPyozwT2yry1Vplls9cMLK218DfyBmUAyue/YO6keOD7gRsZK8fycbGAf0aQ4QD4voRe
	dM4Zac9iN+LPlsrsGPbFgq4ASExnsKI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B66543DFC;
	Mon, 31 Aug 2026 02:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C981F00A3D;
	Mon, 31 Aug 2026 02:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788143333;
	bh=YwqNfmhuWrZGj3kuSG9MxCjuM4AM56GhnZE26FcBYfc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JZA/L6l2dx8QC3w5n/yLK8cpOJabBWORuQR4vbqopQwuN6VXI4pZRAfs4n5KbHiFl
	 J8P1fRCHdch6tvgjHhqzOWtQdPei1DFyIIy5h6aEc9Vc0wuuaGQoK+Toeg5L5YKRpo
	 DAQsTsXBN9nBJvoDMqUVkY2mMw4/sY1J2gR2ariZi7LA4XkYAAAO2sw24U18yNTVFb
	 6E8nu/w2hvIYgY9+ZGn6QMQBWvGPhcr8fgmKG7e0bK+oMCt8JnebCJxK30tRwzNgAT
	 xKHpNXvy7ybM3Eh0fI4Q041VUSqpEXAuCnU9LqtH9W/BN62sGiRwA2Y4TdFlpP5lJj
	 n2Pb3eeYfcuZg==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 1507F1980050;
	Sun, 30 Aug 2026 22:28:43 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Sun, 30 Aug 2026 22:28:50 -0400
X-ME-Sender: <xms:2-aUam1Zghk7jsPTVkI4JM-RbrLDPOo6LaJH_47P0CgAHje4-hPbdQ>
    <xme:2-aUas1oIhQroj2LB2S-TBBc6Qs3Lp9H3K1WV3sKPcIXQrsSEuuXk3_hM_4Lsv4on
    amZeEAeyRxKj9vblePiRHYWuGsL5ajvuctLS8eTOV6klYcXY9Ws4Q>
X-ME-Received: <xmr:2-aUauq5ObrCNd3kePUb32QFERp0If9mquNAna5UBSRHkusqMRXCcpY2y5E>
X-ME-Proxy-Cause: dmFkZTGikeL7Ca+TmNEFzc0vH4jlwT722XVdXtOou1v3igBDEncFGj77NsHPEuBojySN8T
    oeVj2weYrB7KZMakVoVRJUPY80SNG0ySMJsIFhtHzgdy+bSF3uopPrr5hWqYy4PkJ6m2nf
    pwcb4EGSm5KTlkaImH9Awl16Ph6U0QciZ9hMWbDvOx2H146Eyvho7+8mPIuoEq5bRN6MKI
    E/ksYGeF6/W/xKluaF51v3+7WGq0uzd/3CmXvCDFovpLXjrV4gEXi+NAgkUpnMeEQCEbR5
    QJmxIsRD+d1gcCwwfNdaE9dK0hFulFNDH8T+zCSx13N3x2ouJ/jP8UviWjZD7C2DjDNoT4
    +ms3fM5gUKRSnswAQ/qeL0hAcDLz2QO5l0pHOFMin3wotE3xEj9F7/iAViZWIb2GTkyqar
    fzfGmIvro0IWJUMESur9u8YFA4GBxsqTesEeZyqhu2bXGSeKgT4D7JyolLaLb0fkai11af
    +KVIIGjaVpbKFdAcVQnDRnM+YVw8iKzJ8AF4qboZxMulCFJhyXtXofC2esia8N6FZmcjU+
    WWC2AHzrMP4DeAACwH6856+j/kCABE7HOW/s6TpLzSa1A+kkGxtlx22K8reu4dGQY/58MS
    tYgJU8M4/EBvfNAjl846FVOW+brqAmI1OnITyK44vYU7Q4KiPKWTRMvnuiOA
X-ME-Proxy: <xmx:2-aUanJ7XxmVtIIXxjCOEJNH8PBsOX_M9t5zX6dDW_BK3sdUuBsyDg>
    <xmx:2-aUageco-eD9TfWakNkdmaGQ_bc9SmHk56ZNonQAPGlcfedPq0lrg>
    <xmx:2-aUavnJxex1loLDFXFzofNmYj0_jPxOz1qLo7zbIFw8cS9pIpD_-g>
    <xmx:2-aUagYBeyhZz_7hzzu4DeoNo1Me1hYxJLsHK4ERA7b6Q7gddU7khw>
    <xmx:2-aUavLkZ3xi8RZQNC9Htrl4RqMZkkqmgPzS3Sw-YO2LHYfzKensXXQi>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 30 Aug 2026 22:28:42 -0400 (EDT)
Date: Mon, 31 Aug 2026 03:28:41 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 	Ackerley Tng <ackerleytng@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 	Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, 	Binbin Wu <binbin.wu@linux.intel.com>,
 Christian Brauner <brauner@kernel.org>, 	Christoph Hellwig <hch@lst.de>,
 Christoph Lameter <cl@gentwo.org>,
 	Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@kernel.org>, 	JP Kobryn <jp.kobryn@linux.dev>,
 Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
 	Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>,
 	Lance Yang <lance.yang@linux.dev>, Leonardo Bras <leobras.c@gmail.com>,
 	Lorenzo Stoakes <ljs@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
 	Matthew Wilcox <willy@infradead.org>,
 Mel Gorman <mgorman@techsingularity.net>,
 	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>,
 Minchan Kim <minchan@kernel.org>, 	Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 	Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>,
 Rik van Riel <riel@surriel.com>,
 	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 	Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 	Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>,
 Zach O'Keefe <zokeefe@google.com>, 	Zi Yan <ziy@nvidia.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 07/25] mm/fbatch: LRU_NEXT_ACTIVATE bit to optimize
 folio_activate()
Message-ID: <apThx6sWOQ-aZcN7@thinkstation>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
 <16b39f43-d91e-7b23-900e-90cec13837ff@google.com>
 <apAllneItXmyjRPo@thinkstation>
 <7b30ca86-dca6-83b7-a632-180e35ed2a0c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b30ca86-dca6-83b7-a632-180e35ed2a0c@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4422E80003
X-Stat-Signature: iap8chme3bde59sie3usx43w3f6wm1n4
X-HE-Tag: 1788143335-407733
X-HE-Meta: U2FsdGVkX1+hm2PMjYX+/c+rV2TuJ8yutUm2cA94tjYQZYwvB5x0azPr1o45oSL+N32f6h2TCV6p8IK2wvB2hU/eTVS6u00J/c7JTFfyRgRQ99pqI2v8nm4vE9/w3vaCtRFpr+XAvJ+BqkWqqiL/sZcXw+HgTqxk1mQn9wYslSrux2Y25z7gLYvUyxXvsecLdTa+yWGGPYgnK0jNOZGm/wZ58pbwU9hHhgPxpYgzntSX8b0lA+nNpY4pThB1NNtO06Uz2a7qiAYE2WGyAKDyR9OS4rH1AgBtqwROuN4IO1FJiTm6NjKyzt+ZXXlE8OTCcQX+WkM5i8sgqdlWgPappQsdyswgT4Xx/e5Jpf/RsvCV/WZ07Jv7xI61EqJsmZAOk47M3DpTutlxVRe4VUvYl6q3VNbut95gTtCKgBRiKAdPSyODitdTSWtkogfzAkyAkb7CU4w5VPmP1lRF4/ZU4hDVi0oMqDZmaCxwErv462J318ydo4JlmYfp6EIJR919PzdmY43zeoozg8RrJXfM7ShMeFWj7MKZLlf6ro9EBRf7JMHohAmQS+otXpkN960DxIdyEyfpTlun3E3l4Hw65gdUbP3M+4Ayus9n8PABwrjJqDDp/z6L8Ndet+vubKvFyteL4xMWPSh9DQW+rTFnaObAstaQLhwqtlxhkXwiUOVURMJwpt41AjLyuUGDIuik7kg7n1ENGunXNjn9CTdRFADIja2jq7DnKtZaWFnDvG/srBz2JBJjvhGRE0g2Egj6HZQlgI7DiKMTfuVhAfa/FO4288g1be9uKlppGBUs6bbbw1C0HC4bpEWPgfRePgknXz3ImOtAVmac5TT7uJjdAn+Pz7vIVKGlOZsAP+SI8R7UxdZSTyE3zQUx4psIK12xnHAru4GO4eRLxiLufPff81vuudXDQXWBRSHYll16w9gNeK/5/zpCVz/rv5njuhRS5Lym1YT+qokZtjIIAOM
 9Um2rBqQ
 8FJHOY+PKh3WajUrRaH+efDxkMhECTA5jPHWTAcaMYZCXAsXblBTB/Y/9jfHJWF/NozYfm+8UH19g9i5oXUfcIVJMspvFFGo2jUZR94CgkGb2QjOTtQcc4IGlMl5MRyymda08er1h+JEUHmLTIcXSmRWJ14mD/TGJX24C5bmXNtWqxRbysNuIyv2DOuhOsEc6maDpz18z2nmfo8HCvPSdLef2Tr0nczvi1+8+NcJf3rjefqckRxhgKVIwE0QFz3liiYvwFxmGAYNKMqN8yD7Mp2HVwBTL64OJs0CTuhKFIm/zMlxMLabzRnWgLSrCdyckPG1tfUEUAvDBl2R8WessrYK0gkvJnlwzujGr1qGnS4E3/dHnEX0eu3qF1p8qF0sNmQyiuEhS2AsK468il/ZVFL2ZJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 01:40:51AM -0700, Hugh Dickins wrote:
> Do you have a head for smp_mb__ barriers? I'm more anxious that
> I might be missing one or two of those.

I think the release side of PG_lru is missing.

You effectively turn PG_lru into a lock over folio->lru.next.

The acquire side works: test_and_clear_bit() has a return value, so it
is fully ordered.

But there's a problem with release. set_bit() is unordered. You
correctly placed a fence in __folio_add_lru(), but every other
folio_set_lru() is problematic.

For instance:

	CPU0 				CPU1
folio_batch_move_lru()		folio_batch_move_lru()
  lru_add_del_folio()
    lru.next = LIST_POISON1
  lruvec lock
    list_add()
  /* no barrier */
  set_bit(PG_lru)
				  folio_try_get() == true
				  folio_test_clear_lru() == true
				  lru_next == stale BATCHED ???
  lruvec unlock

If CPU1 sees a stale BATCHED, lru_add_del_folio() returns true without
doing the list_del() or the NR_LRU_BASE accounting, and CPU1 then goes
on to lruvec_add_folio() a folio that is already on a list.

I think we need to have a helper that would set PG_lru and enforce
release semantics.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

