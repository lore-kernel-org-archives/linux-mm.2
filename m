Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02FAA606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KlsD5/fD
Received: by kanga.kvack.org (Postfix)
	id 2146B6B05B5; Thu, 12 Nov 2026 07:53:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C5066B05B6; Thu, 12 Nov 2026 07:53:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B40E6B05B7; Thu, 12 Nov 2026 07:53:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA84A6B05B5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:53:55 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6F51EA0590
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:53:55 +0000 (UTC)
X-FDA: 85426459230.09.D37DC19
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 69D4140004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:53:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KlsD5/fD";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794488033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ZrUjxQ1X/We7wtRHupxrDAx8TTm7+SwxqIT1sIDYs8=;
	b=ZHchiIB94uuXwahPAQwNsMXb3CE8eARm3ppwwAOjknSao8/6F7lVsOvRMipJdctZGDw8KX
	dxx0R3cyZL+CyvNhLh8RvwVTaE9kDTc3EGVtLfXh9RCxjvwP8qyKsfpO/vtrbj1HbebBPm
	phUOCiM6lUneVQ9mnPRW8MOZ457K88U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KlsD5/fD";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794488033;
	b=43iyD8nG5Dad0L4CadM66eC2qiJRlyjaeHzzwWpHYeRwoMOK2lrcwsMDus6tzcFlIlTq6n
	712KpplblaA0xUF2o+JuOhWd6HVbzs6CKmqqepaIEXJB36exEWnt/oX3rvb9w5MjNpTW+X
	X4YuEOkJY2voaPZHMroc/PaB2FkR/mw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CBCA404FD;
	Thu, 12 Nov 2026 12:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282D71F00A05;
	Thu, 12 Nov 2026 12:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794488032;
	bh=5ZrUjxQ1X/We7wtRHupxrDAx8TTm7+SwxqIT1sIDYs8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KlsD5/fDIsqfPCfdiKHytK35h7uvYxYrUze6fdg/0xfS5GdIy3Qdzwoiqxsy6TQxk
	 PvSsHrdDooxG757ynturfT5Jp1GjoYPdtswhj5LJWDhkWNIJyzyTFWIdMG87sY5HbE
	 M4m0dLpdvTw7srV/Tj4KVPWwO3EAu8GLt0g38v0RjbNi/pzaQWmIkk57ti0M0ZRCX/
	 TJLMaw0UQDju14m48deW5o8bwmTU5r8cfHd+WTc6V9CxgzEqzEzAJCWscmUIcN4+TF
	 Li9oK0AJPGWj5sj9x84090j2rjFGMTn6PWIglFkoUaGPiFAcLxKgnhEOXmEu3KNsQo
	 PQsO02yU03ADg==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 5EEB51980047;
	Thu, 12 Nov 2026 07:53:41 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 12 Nov 2026 07:53:48 -0500
X-ME-Sender: <xms:1Lb1avbqYJ96LVa9G8j8KGDf6QPd8ThRC_rCA8Kwibzl1QJFLZE85g>
    <xme:1Lb1ap_mwaYWryEov-o_6hfF_RYnwb4_q81yG3axwY2TJCnk1ON-kRtNwY7E63Hoo
    Bp2Iui6JukMiOK9Pch-yNvVnk26NHqTV7CGCheWsFZzKKCtA0ThPw56>
X-ME-Received: <xmr:1Lb1ao-wZ-pDSr7UYUr1o5q-LriP5K8KoWoFL1Bfzt8jbYDA3nNg76TwH_k>
X-ME-Proxy-Cause: dmFkZTGpc2ngwwYoKY78wwM9oTdiUFMdbNknNo/bzCD9ox6CwBy3Bae6ac3Pn2KNSG69io
    DjjSRQA+ArMHIJlqqToeBv2DuKjHaexSBKpjRpEneCf/9m7ijFudy4tMLdJCDVAS88IZxT
    ljujfxRBPh/0Qww/nQXmrETum1Cv87lC/wq6AdyCL5zA21NYdJmNBPjvIaFGQYxP35tRSJ
    twxmmrXTtBDACJ+v/NMff8Ez7le0JwbqH0qPmrmF0AY2K5IAL9jbb5ji+sFi+IZvYTKKpx
    zx98PLZAbI70f9z8nSTz/ir5t8tP8METbjMjfP3rgKtV/F4AeqoyEA12VrelbA92HmNwOZ
    CN4WcOOMGdlBMYv+tIShCcVMbXgLI9FUUOcLxCfkG+VYluTwDKMLamFXmV6TVl4u1Qhbco
    +jMi2PoHmBpKwD7Jg5LQa9R3aT4xxrRvXo9PDh4HSvq/QKEJneRRCCN78AXBKQuQysNSMe
    uxj6c+RTR4+wEuvLnXrbXNAk7rxkIi8ORKAq4MDa5dfN5RsAUdLvr10rxV6IDFsWcyJPb7
    VfsIuBEsJ0Yljqod7sr1P9kFBYHd+sl+NzWhPsaMMTek1s5yD5hX0US8QTepnvYqzX3IWz
    ob3uAdU9lh/SDU/vM7t2Ngo2ShIZ0DHmL+ghORCbgdu3QNhRGsC5YdMsyFQg
X-ME-Proxy: <xmx:1Lb1anTK9w0SORBsrIHD59_zPH5qQSLYxXO5V6-EBHGKi9QCNPTNcQ>
    <xmx:1Lb1arEnxAIYkN5wbK3s5QBA-Vllj9jy5zLl0qwAcyCwSYPUMKTvsw>
    <xmx:1Lb1asYvDtdgz37mQGWjQOAjMXf7ffZSS22pO1qw5MXJfDAyH0rSIw>
    <xmx:1Lb1auQgx4SSpt8NmB8AZZe6ZV5XL-P0HWnOnjyEQKdoAnWn1hbFww>
    <xmx:1Lb1aic3bpvJ1B6a2XMTHFufFqpCG4HjwMk7D90AUjH1BVN7gqdmfiPE>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Nov 2026 07:53:40 -0500 (EST)
Date: Thu, 12 Nov 2026 12:53:39 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Harry Yoo <harry@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	Luis Chamberlain <mcgrof@kernel.org>, Ilya Gladyshev <ilya.gladyshev@linux.dev>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [RFC PATCH v2 06/18] mm: free the pages waiting for a grace
 period before OOM
Message-ID: <avW2llfFWagr5Cmi@thinkstation>
References: <20261104130118.2507513-1-kas@kernel.org>
 <20261104130118.2507513-7-kas@kernel.org>
 <sashiko-outbox-199099@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-199099@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 69D4140004
X-Stat-Signature: 74rjc6r16weduaudwzrq89woms6ugk4b
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794488033-261634
X-HE-Meta: U2FsdGVkX1+aRkSMZJGfMgwjqZCRN3pjNMQaXrirmbebuN0Z4nfjy+MzTDfcQgAv1TOY3XTyNRm7Do03PX4B7w6eACAf4okBsGifhkiV62KOtJsLJFuhNDnApqDCpM62MzFbDXdsr9Lcn9cpi+TJkWaZfOV+AX/sWNZJLtCVfphpQ130VQpmYIraq81iam9ugcECkmlYFQgZd6VzZfu+g+XJtXQeHTsXWdkEpwDOOCG6q30vq64HFwEDD67GKhKNwJa09VuBdUnrSlaPGND/KcrRVcIq+URj0Cft1kAe2NjB2ilGpKfJTZ4su0Aa9dZB1LTpCynp7Mz1yE+LfCRzr/KE/xAhFOFylMTLxhn1XLOuZwlwy+DBBa3dYXzJVvH1NFyDVZTOFY9FgpUOUUkeGGZBOGvgJ5rCFuDmfwMrc8SL/u5S7TWHa7YMjrT1WRVP+jSMKK2XVU0iNS4+DJNLJRYN2Ph68qzsV90WS1YmhqqmVvrkqNEuWUXWA7Pzrw6aD6j9e3WU8ITvZw6WRMlUALZN9wgATbPAp0GaybXvkKmD/67eCDERHrx5wEcEEVH3bzY/Zh27Sz0cEyvvH5gtQUvhQYlBBHnjUfApvkjLuZdZBmqB5j9UBfyuPc5R16VTRTqYWiedpHTObIssNB+p5pB98yWWAjlAbQXy5lfbKeLRyo0tVgtx1zDPJESqrQypV31I1EYSw2JusbalU9+nLOCfJichMyfSlfaBtl0RhspXx9qeZ0qJRGc8GfC9gJdFkSnoxDTMHHDjoiBSyHCBDonrumSXA/X0VR/V9sSKPRqgGm8L/8EqAJvU0IfuE8VLUOGRtkC5jqKIn9kpjWtVCigI13dPLMtLDO5RudxB8t8zLd/0kWg2lj9sbq1hsGvP+DPVYoQ9MVqSLOgMuD0swNDqj8olKQAh/j5Ys/YayIcSvqRo4iRCN71aMDMJ1a6nPYdy4g87ZG02K/znG/T
 AOdvrL8b
 UfDKky2wyYRFRMuPo4KGz5H23UXrkPGIJdqa9Pfev3IPKo2tfSmvfz4TSvQrU3e5pODWzRIgU8slkXPn9hq6py3rIYVPZmrpqcMg5XcKvhAxuQ5MVgpLQ7O8EqUfc+1BCE6psrm91nimPDmAZN7ufokhBIEGJMICHfwDnYTAQxS+uXijw3aPdZy91SNpBLB9vgWjqUQPEPU3ZeFXy4XIUlhoPVJEWAGjAa7TX5+bnF1K7rF0Ft0HBVKvvR4JeqclWoGqmPPXYe6Ey3kWSssTgRFBD4s75cT/vV4zztnHK8hI4vEBH7K3074UgbqW91iSQBxxVyWb7DG03rL00C996IdgfJea3wr20z/HRXkWOoJm1zPOaVghKhB4jkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 01:03:34PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] mm: order-0 check in rcu_free_wait() starves high-order compaction
> - [High] mm: rcu_free_drain() misses rcu_free_workfn() and PCP-freed pages
> - [Medium] mm: rcu_free_wait() counts unreclaimable pages after retry limit

All three are valid.

In v3 the drain moves out of should_reclaim_retry().  It runs after the
compaction retries, before defrag_mode drops ALLOC_NOFRAGMENT and before
the OOM killer.  Reclaim has given up by then, so reclaimable pages are
no longer counted.  An allocation drains at most MAX_RECLAIM_RETRIES
times.

The drain also waits for rcu_free_workfn() and drains the per-cpu lists
the works free to.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

