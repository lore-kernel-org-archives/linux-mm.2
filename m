Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AC97606A882
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tq0/us+y
Received: by kanga.kvack.org (Postfix)
	id 6269B6B05BD; Thu, 12 Nov 2026 07:27:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FEF56B05D2; Thu, 12 Nov 2026 07:27:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C6F86B05D3; Thu, 12 Nov 2026 07:27:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20CDD6B05BD
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:27:02 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A35B680557
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:27:01 +0000 (UTC)
X-FDA: 85426391442.26.CF35DEE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 88A6C16000C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:26:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Tq0/us+y";
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794486419;
	b=7rU+wf3yMGcjW5bQ/2HV/8m7ensDyePJmJIr1H6LD3msfPV7rnpLpiGBSrC68PDsrnrt1w
	9k2D1WGpdAMJZNvNkj7RT6ZBSCR3X+iRYLyMqhlVkbl64r0G1zg+/5w6OLylCr5a9bjRlv
	/yUumrax0UWUuOi//XYBVCPSN8/2fTw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Tq0/us+y";
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794486419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cJhPJ9QxlCMYKnJHbj5QGEB8cls6tku/kkim/ICGTdM=;
	b=2AQs6SZzLozO8KA2EXroHzXjKd1GOq3RHyFDkEXMMbRYD+2W+3N5fRwmy1Vr3Ai9EpFL1G
	l8UsIECPqj+VcHD3vGTADgPRxCdXlelOyelfJR3kb6fUgHTfn0BrRNLa9pcCAuOoQ/x22Z
	dSRt3Ql9grO8pjjpYHe1hXcy1Si7pjg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F5C66119F;
	Thu, 12 Nov 2026 12:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99D71F00A06;
	Thu, 12 Nov 2026 12:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794486418;
	bh=cJhPJ9QxlCMYKnJHbj5QGEB8cls6tku/kkim/ICGTdM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Tq0/us+yqcz41TSZOMSg2vgYoaWxCVWJlD+3NmMzSq8H8pbZ4vtDYL0idvaenJzQL
	 CGr2ZJjC2vX9q0EDuPNKzEFCOn98/bEVDdZ8zTOtAV4BbVFT1aYihWbkIGya3witCl
	 GcC9OvG1UYORD9lPPCVjKrhdlE/aYJpSSmF6PbNEm5hI38kWYd/SZXRtUSPhLDxxii
	 ljAN8LHFg89pMPlzt8adJhPngUgQA0mkPSuZy89haj1MlQUAY19JMTcjcYWi+WG6NB
	 EPAOvuxDDbDifUSD+hFdzCnT3qqdYLNSJPHz8gFfh/0xsLfhdpYkLDspribaaNjatP
	 3lj2SoubEKmyQ==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 091A4198003A;
	Thu, 12 Nov 2026 07:26:47 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 12 Nov 2026 07:26:55 -0500
X-ME-Sender: <xms:h7D1ammO0rKMCciio5QD56XBjmBAkxCiBo5C3j2sA3mRlG9XgaOMNA>
    <xme:h7D1anoZ0ho_z4Tyt6M2DpHMwTxVgfT0VtSfMENH9XF7BgkXNFIzypBlgVjlkKGUK
    giR6uayFz1TRV2QL20a8ToDSeOz-hvHkqcORz2wzD-8xVLsG1Ef3Mpl>
X-ME-Received: <xmr:h7D1aoWrixkc6hliMPT2GEmykw8XA4EBFs0DDJJP40AuzYSECxKlUiyfjGk>
X-ME-Proxy-Cause: dmFkZTFE5a305T5AvmRmPUwWLwOgcXGbZ3P1c12I/woA7+e8YrvsknZPdP8WZpfw246QMq
    OTRU3+6Lvu/IAHI1shixRO9xTgIeSA8hf3hHWj1aHcL/j21Z+Cf7LwC7MrmMwSloB+cGlY
    8kKb05M4kGFDS1NVc/2QFUdwZf0agaAkZqqCeJPWZUdDGCkfPa4iUGV+eITEfuDdPT9o8c
    zuxGx92elDCuS1bPus21iDiuOU4YvAibcPgzCNQOyJQ/lEFzr5NvdEPzh2TVRuq/OiRhha
    LitCVwW41aas+CwKg1ef6W8ju0frrYJPvhBk22yQcZ85VaCK5ToTFTj/G/h+SS7rvZSYNs
    2tZgICNFvMNjuLr2msd8kRuJmvkyM8cVV0Un7d6TH1S0wdcha4qugi1ngQSBZnjer2FIWa
    RwDcf8iUE3rGrOAADB7ESLBIzoFFMvbO/IyaQI+aJj/QKdOFgdJLEJ4+bn6QfDurcsBoP8
    YXDsFP8TNMsTqBSp0zlcVGiZCmGbTUXRT/aXQGB63xlQ4lpsKVN74izURY7qcRFHYFEBzH
    GXyW5yVDNrbEe3Dm2H+wwXNNL+stMUneebE6H5Y3yvPGbPDOJgRzpTe0h81zjrz+1B+Var
    x3C9grCqv/+LAGkUoVBDVu+ES6xk96eannkxPCTUtgDrZZVTvmos/Kjhz3AQ
X-ME-Proxy: <xmx:h7D1aliRs30a-qe-0fFG6wq2VW7atkq33GvtUcb2ejmKJ2NcQNy3_w>
    <xmx:h7D1agzCMdeNLM5uFldG051iOpjuZXde5PO6R9gH-BmCwJ8ERFsvxg>
    <xmx:h7D1asnAZ3Lt0b-U9GrTBQfCPqlvIzSr0gDd0FypANxxBebpccaiTA>
    <xmx:h7D1aodPkF9xSqKMRo_jTT3u4AYmed8jknd9OktHFPsV7K6q1RtJ5g>
    <xmx:h7D1arpQqZt55lDjcqN6QqIqOLUYWBmnduE9xi0TZ2xLeyiEF9aTgjU4>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Nov 2026 07:26:46 -0500 (EST)
Date: Thu, 12 Nov 2026 12:26:45 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>, 
	Hugh Dickins <hughd@google.com>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Harry Yoo <harry@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
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
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, kernel-team@meta.com
Subject: Re: [RFC PATCH v2 01/18] mm: free PG_rcu_free folios only after an
 RCU grace period
Message-ID: <avWv-0LafPyo90ln@thinkstation>
References: <20261104130118.2507513-1-kas@kernel.org>
 <20261104130118.2507513-2-kas@kernel.org>
 <ecad7b3c-7244-425a-9413-04d49f221057@kernel.org>
 <au2lsbDkyWt-To0C@thinkstation>
 <aa2a1e32-9b1d-4545-b2e0-03d213593023@kernel.org>
 <CAHk-=whnH5qLJH3Wd3bOxv--Ei6674Jo4iifGD_MqzyJg2Jm4g@mail.gmail.com>
 <8504e28f-faeb-41e3-842e-0cb74d1a25ad@kernel.org>
 <CAHk-=wihE=ioLKrwzz=WQSJg6HhB-syu4hqZ2QFwgnwYmmLEgg@mail.gmail.com>
 <f39a0ec3-be81-43f0-91e8-145ec139b1bc@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f39a0ec3-be81-43f0-91e8-145ec139b1bc@kernel.org>
X-Stat-Signature: pdzogfxzw16kq6d3b1yum6eb7kfwt1jz
X-Rspamd-Queue-Id: 88A6C16000C
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794486419-77482
X-HE-Meta: U2FsdGVkX18kt2cvEtBrBP1M37hwjcnpy0QqUe+vrpym4Ve2zBh9jL70LsHk6kVyMuHh3n+fyhQaSG+dDtfsrIBfNdufzjfxLUyXrXj1PJ9rESTPLIgieWeTrkVdsIrgb48ohBTQo4L3qOKCqNJ3wwn2ftLO3vtsNNpev0eF/u41SwpKmHfqa70CkFS8suUdOh9ceO8y7g8R9FZ6WcUAXV1RLn1rZyOD5BT676AZrd8+SM9b8f9+igpW1cK3QdFN2XqsU4CsX1HBKPDTJJmvIX8XpVmqP7F8hgUGWUPCpIXDH0A2rpzuCG5DPYWwa+UAPNSgMnBSZLpLtUAvZ4bswq8PE9vIAUnq3eF8GPv85xMfb+w4ER2G+L+i2h8DmNB/HPcQkb1wZyKlwT0sm8WsijsFmV/UfulbKJrQneHv/0wXqM+Yj67CcCVZb5qUw6EDSrUqh+B3jAUA/AhRZRKaRsqrN5qbhQ6jrgKS5D1CVMuIRgYYicr2X+Nc2gWP9rbCcsLxwT8H6nZm7/CjddHOHuhIexzshgtyJz/iqhzplYzuCRmO9Zk1KaYhycu5Ip6uWi9bHKabFffGIfG0EIuzAFX4DQ5rHi8dac7Kt8k4i1ZfyfLEg4Oah0Ulqsosb2J0pTqdTOoQMw+Wvk6X0Fh/sdhiLforWJK9MMM3B+S/dUo6QIm33HsCaym2XdkVy48XE7D0leq9lTEhSUP9oOiK1ToYyj7Yp3NMLw7eEkygcscUMmFzUeviuNHTNBGU9PRmgHW6mfH+9HPGTMfPP0HYvj55R3H77y9NS/6xfASJDTG8u9MwJQ5gDt7kupzdHlEYzehp5VJGrbl+5vM1uVU55VPJphYlYyAWIcrSoQjiiFtfV26JBMYmnbvxfLsHFYQkaOn1QaxM3CNj+4e+plaOAhmTpqM3aXKQVNWvAqU2w6rnr9k/e42jnHDkevGZvUsXNCRtuA1wCEbzZROnrGQ
 /wIBvJGy
 Cj+ouP6Z63/o80ImsI9obuvATSDGn+3iheACxg3oP3xj1PTyUfbF+Q3TdNNe+uYxPHzBK0R0e9P+ItZfytTXOaTAxQaDghzAelZiXDOgcg/bO7b3Z2fMIbHLghErIbqy9HOoIt95kR3f0TADBPpTwBk575mLYQRjex6VofN5cWS9iWpmUmykaRdGpcZNVkaNd3CxJdihHJgnezAm+kMRaUspFfNLiVs56rLq3zEi1pa2sOteDf3rKiMwZ/XgpgFw98mwEnC0GAx56ojNV1uV02dANP2222InQIiAqylamgyO5ZIAFSXhbYarDAcYojmhw4jP5sc8raQgh4qlJWXKkdpOpW9K9RFf8sDM+sYNu05ZY3+Yvb0F6vanv+D/uS5DInuqzBkC409YKA21qi+YP6WHOgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 11:03:38AM +0100, David Hildenbrand (Arm) wrote:
> So I might be completely off, but what I imagine is that the memdescs will get
> RCU-freed (these are not pages), and once they are then getting freed, they will
> probably take the physical page with them.
> 
> And freeing memdescs through RCU will likely be memdesc specific.
> 
> I really don't know, Willy might know more about these plans.

Right: once the folio is allocated separately, the lockless read
dereferences it too, so it has to wait for the grace period along with
its pages.  The per-CPU batching and the waits in the allocator later
in the series do not depend on where the check sits.

Until then the folio is the struct page, and __free_pages_prepare() is
the one place every page cache folio passes, so v3 keeps the check
there.  That function already takes page_folio() for the mlock and anon
checks, so making page_folio() fail for non-folios has to handle it
anyway.

Willy, is there a plan for how a folio memdesc gets freed after a grace
period?

The rest of v3 for this patch: CONFIG_FOLIO_RCU_FREE with help text for
what it adds, and FOLIO_SPLIT_FLAGS as a #define in a preparatory patch,
on top of Zi's PG_waiters fix.

I will not post v3 for a while: mm has enough traffic right now.
Unless you say I should.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

