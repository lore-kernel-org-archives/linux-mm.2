Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A024E606A323
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 15:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lN0NhBYF
Received: by kanga.kvack.org (Postfix)
	id 25DC96B05B1; Thu, 12 Nov 2026 10:00:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C0176B05B3; Thu, 12 Nov 2026 10:00:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AF846B05B4; Thu, 12 Nov 2026 10:00:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C60256B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:00:01 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CC8016059D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:00:01 +0000 (UTC)
X-FDA: 85426777002.10.BB930E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 45B2F1C0002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:59:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lN0NhBYF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794495599;
	b=xs81+AOtZfjuafHcPjcnKKF3eC47OUNSnZFIjnWiJXUybPUorN9kjm9InX6gu14RgsCISk
	61fC8FCJLpN6+MxaAcWH8bmZltQyNPpFQ3wFcj+n3NWt66QN1V2IquE+Uf9O/hIz+eGDRE
	B8IxatijSFnup0/R1b1+j3G42JzjlZg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794495599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=92f73/9CRUvx1XycGVQ0WiOmwZv9qXnh6P99S8eFYaw=;
	b=cnqlzpNxMLkQgQ/tQzHt1LV6drChhM4X6VvQiZP0WcjhbcLd7buyxBfIC4m9SnKbbJU1FL
	Ryh6F5t8C2busD5seVyfNOYr+L48V+BWRa/hD2eykwTK6bdquuAwTFSpaSJ7/hR0f9yMP2
	ZxLa3+ZSPVobauRHDZ3QduA8wRb/DMw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lN0NhBYF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B1D1060E90;
	Thu, 12 Nov 2026 14:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2AF41F00A06;
	Thu, 12 Nov 2026 14:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794495598;
	bh=92f73/9CRUvx1XycGVQ0WiOmwZv9qXnh6P99S8eFYaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lN0NhBYF6MSKjwH4qYrBxBtqWs0Srd63fM+L/w2MB8LbaCOatU+NrC7u46gDPBkeg
	 pnlQhsC0EhtKTFXG2APIyZ8Rx9dSVCz+PudoDUDo2d3D0EZV5nk1C0umAptzosneHe
	 +tMYIslnzpPAUpz3+myupN1WYH5W/mm2+W8nzBy4tyTyYbaziFBJFr3VIpgb1IitdX
	 hASwn853Zb6lDdRl11B6IQGOcajCwcxixVDlsa2Zn6FMDj1+/dNr6KbduVQ1gsPxke
	 zudTNMlTNCdNmWO9R6vGZot73PY0mVnrbobchYXKN5/kcwppN2tmE+t1EiT64Gb5C+
	 zToVuovfuptdA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 6E27C198003A;
	Thu, 12 Nov 2026 09:59:47 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 12 Nov 2026 09:59:54 -0500
X-ME-Sender: <xms:YtT1an4cxLHamg5sYIcUVoA0XrEkaAEGbO6Ar5TZXRLLHdST1ac3hw>
    <xme:YtT1aoL6UqLIiqvXjyDEvc1EkEq8-L3J1rBlN8paZ18P2DDsllZQGtA-3z4XcwXep
    wspR9RrWKz9zfJGNooamnjEKjy7G4ng2Y9KY_KLDFWt4KvgsHvGmQ>
X-ME-Received: <xmr:YtT1auuYmqeLlOqp9qgg-q4x4paBIcUo1VV2zHMrTGvVlv4cOMbqGLCGI7s>
X-ME-Proxy-Cause: dmFkZTFFtf/isF8asN8syO9R8D7ImZyw9S7EENZhVbdmJZv7Bj/fwggTGDjuxjfSxGmHz9
    SfzDwNAGDgi5AT/uPeOC8SB5U2EOL8l1kHKnEd4mgcL3Y0LUEnmx1xI+31otE1VjQpc08O
    FE5QBUYl1ongapLPYt0Fyv6XJ5nPUh0jZOR3rZXkzxWk25xwnsuP92sP5+bzwUJrFWnK5a
    vyUeFTvyf9WPujspMEYtJYg4pzMCdGbEWNmGUUkEVezxbNQyIVxy17II162e3fpBiYxt/p
    aSyjFkkjDsIlLoMD2f90shIQsscdG37PL4qpVypIvNMnV9nUF80ntJOfAasqedfc/atFtc
    VphcJ14tpA1Bfd9IBgIorTFzlAeQWy+5cRtH1MrIQkPOigKp2ziYFQOtNHZumpNwe5nWEy
    zx77jPFCTMhuc4rng8RA0LX2ED6xHo7kuPmu9eVqppgr82LYaJk5mbMu9pthsb7OZ3eA/q
    Wv1RrAPmaa617bdA7Dmayy19Md2uvj7iVZSS6l60n9kDnzN+FYOj4DJuPSiAAVz+O0zHRT
    FWf/IdLf6ih9P36lTu9IcQfCUTdCR0UG8vpq+tqDLGSWFRuTflDT4+KVVIhpo3U5kZI71J
    0SJ8SrW1kAKhJlZD1+5tj1z1rUWRxHsq2I2DE9bEqKs8XGjMB+5Uxfyl0nQQ
X-ME-Proxy: <xmx:YtT1alz6SDp3LuNY3ZUeZk0KVT4aOTM3ZWDhVtbiqqxnwkFuuxvKOQ>
    <xmx:YtT1apWEhU8LI9rRlHDUgds2yXnk1DtbwdXaMlJZUbzFmujZUimcbw>
    <xmx:YtT1agc3nLYmgY9ypCkK8kPPjwZHbPaEEGj-E-MWdfFSKBUYKw3cVg>
    <xmx:YtT1ag4WUAc0Nbno7wpewdcw-F7dQW3zajg5kIhM_qS4mpYbDFIQwQ>
    <xmx:YtT1ak3ahUq9KmPoSl3PHStBCmLcEAsi9l3NOy1sOQv17Lp7MvqOp0gc>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Nov 2026 09:59:46 -0500 (EST)
Date: Thu, 12 Nov 2026 14:59:45 +0000
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
Subject: Re: [RFC PATCH v2 09/18] mm/memory-failure: handle folios with
 PG_rcu_free
Message-ID: <avXURJ6gUjDC6861@thinkstation>
References: <20261104130118.2507513-1-kas@kernel.org>
 <20261104130118.2507513-10-kas@kernel.org>
 <sashiko-outbox-199102@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-199102@kernel.org>
X-Rspamd-Queue-Id: 45B2F1C0002
X-Rspamd-Server: rspam12
X-Stat-Signature: 9duw1p35f4ezbwz4wy3wegwdoj9kja1w
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794495599-141620
X-HE-Meta: U2FsdGVkX19hPneVqaftjeXHix9fuey3SbaPIRi1NhYFH6mLa/Yfzvp5WLqhTDAraPHYJ2xLa3QOQaPI0iizD7whI2lIiezOYHhgfQr/Q+NrcwqTe7epWtO/5MiynWpgbg1qno3zZ9fuSyrnxhpfvSFcYlBE6aEhCiS3dgGtYNwPjq5SIvrByWi4FLSxQISj67hA+nikdLaPzxLG2Wie0pQ1oxwJBFWwVc0Kv1rR7AArVgOc0c30xdlED8Tdb+c73KU9EiBJ9kb+3uZn60KcSD0QGd346qb6oihUPWr9H31zDD1TvtJStdTOBYtaIzcW8d5pUwKflCBPdpuhan+6+ttIZs6G2Btu81gNdwtrkODH8qb+nFglGJE4Y4nqorpmrr0NY1ICfDlhnycCue7qGUQbq1m81ODCCCbyPfkegOyUxPqdX7wL5G8yLcNUehWj6gGwNfb+oKisyMDIXt7Dgsf18DcMBXUmRFURK31sJufmQvUoRSVKFvrnBK0Tsh1xlKmGvpDu04qvoUa0kcGiJB4lViK8QveAr8aAx5ngF/b7ZsNwLWqr8V46i30wdKI4v0fNhulamm+reLhjElK07xQY6hO8zrA3ek5lPAg7j+xktwXJFjuUQjLJJ+ofzTyVVHWNKA12xzz5uP+6gKBhRV2zyK2uJUSXuywFvCUlEVAjUN6XimUZ/sslEKsokGt25ccGC8NR1YvE/Hhgc73sDnYpoz2lOvSrc4z4Iv+jIplZ9JY47QKfUBDcqeW6/VjdTCK6VE3e5nsE5ptGIsjh9wTgqZQDMc4c/wjP7b/JEK+AuBTIfx4eeKOdiVL5S4bIgF/Gf+fxlGHY/d61TP3eLIN6gCxl/ZFR/39187Mtq3FPJOIdzRFijHWQlFZP/8iJe66o8NszbxXjtgDmC4kFfyrD1RRexxycHyDsD9xZRfmy5QZ9c3pR8z4/a0X/uXDL1BTPPlGcEJeqYmSHhR/
 JRNzWyZy
 gzneVXkeQPD4BQtpgrNGkVZpbYOxVWEsVqHpt2hgNVfZasH+0jdQ9FeLbfmIjrZNjNORzUpFeYLglWPwrBWk4YVTqjeBIpmteCtW9MV3SdR5rSb94T3WHFQNYiW3Kg/ERGuct0d7/b343LFWsmMZ5zhQgf6ylk+qa0ZfZIY2gpFD0sx6Wvd+2r5FsPtXrL139DsEF0ptkhoFE8/n40FFiuAIELaclxomIO6BtA/J9ybGbbqFfqsiuVbVa9E9fDqieQ7R8O40E1oqw0q+NUREHEJ+EE8e1s13d5wYNGy3FF3Ulmed99raO/LSWFmMnaBvoUq1r3KrBdUawn4gXvmqNy7WO+im6DCEcyplhhJdk2G6qkbNN3z10GabHJ/IUPXYOdda5yrFb53B/VRAckAptEL4KeYJgNmu37bD9LCHPhOkKnXo53Q2wFlI//xnXcnGFc6Z3ECE3CgmxKqzd8+40VvE3FgZqpSqEx2ZsY9vdf9g2BbrPLibDPAY18KIJNjXNwwuqzgbTIqC+O5wYiwvZo6HGNQuK7bJg3S3OSKZJSWYsU/CJYCvZYpZAvF4YaCK+bjAQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 01:03:41PM +0000, sashiko-bot@kernel.org wrote:
> - [High] mm/memory-failure: unsafe RCU wait in memory_failure() already-poisoned path

In v3 PG_rcu_free stays set until the grace period ends, so the first
case does not happen.  v3 waits there unconditionally anyway: the path
already sleeps, and the test looked at a folio it held no reference to.
The second case is real for shmem; v3 checks PageHWPoison() on each
page in the lockless copy.

> - [High] mm/memory-failure: mf_free_rcu_pages() skips sync while rcu_free_pages() runs

The window between the last put and the deferral is the put_page() race
memory_failure() has without this series.  For the counter, v3 drains
without checking it: the drain waits for the works in flight and starts
no grace period when nothing waits.  The per-cpu half does not happen:
get_hwpoison_page() drains the per-cpu lists before get_any_page().

> - [Medium] mm/memory-failure: order-0 PG_rcu_free page dropped after setting PG_hwpoison

By design: the free drops a poisoned order-0 page, as it does when the
last put races with memory_failure() without this series.  The page is
never reused.
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

