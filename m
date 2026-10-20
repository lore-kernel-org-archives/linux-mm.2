Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DDA4606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 17:27:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700266B053B; Tue, 20 Oct 2026 13:27:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68A266B053C; Tue, 20 Oct 2026 13:27:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5529B6B053D; Tue, 20 Oct 2026 13:27:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 254356B053B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:27:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 98DD11C3399
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:27:56 +0000 (UTC)
X-FDA: 85343687352.30.E5EE44D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id B7E1C40004
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:27:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792517274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yU04/QpgFe3hGyqIUoTM6z5+gKHxPwBv/6QVAeU2r6Y=;
	b=CRfFaMbvsxiB3eu6qifFgtJFrPLyJwcc9tUt57N6GCOZiHtqNf3uMuiwXHwcdp9ft9qQUh
	l0Ez97Sj6leMlVbO90hYcg/wrg4DMf/YCptVFvC0jMIFh4Y6uD8iLtensZRKv40nLl/ebw
	C1dvWGxIzHVMExOhnQ/Li+oyX6d0gIQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792517274;
	b=A27WAaetpP4vUU79/mG4U6zuWp02hpIS/yFXkTk1+Dg12bZfBiQ4Js/ABIR2dIN8ke9eFa
	zxFKS8YU25NcVIaBHIVd9inNa7Y+Y44iHAo3zhrl0Cz1A4oimikx+xf9327tBwEmkPpog/
	r1CNBEKjYfB/GqAi/dmztniwnHg+F0A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4290D60DD0;
	Tue, 20 Oct 2026 17:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4749C1F000C9;
	Tue, 20 Oct 2026 17:27:51 +0000 (UTC)
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.ams.internal (Postfix) with ESMTP id DE3A0198003A;
	Tue, 20 Oct 2026 13:27:18 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Tue, 20 Oct 2026 13:27:26 -0400
X-ME-Sender: <xms:dqTXajhhAkytqTNlgANjRk-o93Rtlpoi-Ezo2eNr-yvrypWxigvkoA>
    <xme:dqTXap3VaCSp2pOEbBYe1ZkKPW8sbSwgHzYOcqxs-uQ4aDw1JhDGZ2W6MMl0KiX5F
    n6cbzk1SsrVVgNEt_agSPV4sFIcUGKYnktw3qqF8zk_vl6240UCdrI6>
X-ME-Received: <xmr:dqTXamw4BWbJQ3vzYTcY1e0ey3jevieyfoMrSuzq0XSJ26cqwC1_BnfN5_k>
X-ME-Proxy-Cause: dmFkZTGzP+F9vGPOZyaAazPtUwGQnMUL7fv9cbbx9r1tOaZQdDv97soC3NeH5tlEJqA6MA
    8AB1mvW+ert6FpnONSEWAGkFPR+x/6nRW2wqDxG/x8xhzSPhANNTFTZd8rW1kL2SaYnlii
    9CI3mhrsxtoq1xY4vpBJF2vYlEEH0XnB8T5gYNVsrEhr2hHVW9SAl6G+hpF9cS/72KRnf7
    fX8wTM61liLZyYgaGEdx2EdbDIPJx0z5cvtRj60sqAXPKKMWkjnpExa4OE7h4TrxEplFja
    gINIRlbgECBRkQGX0Y+PF8v3BMTWO8ODfE4TdaqEy7j/P6a++XwxGK7gWEuEvV58vHXkWg
    WOptSd0fB6Ww8rvbb1gSU7DkB+If5hEwJrAAF94suydCEtNuR68UWN7C18EE9EBmf7vpTF
    DVZwc4RymnasVGbQFGCY0HDcvIk8ASkm8W4hyO2amxhWiWEg/ItJJoQ22r4YQs+iaV0nrf
    YxI5i3jEm7+V4W88aFGO3OjJf9X0g0VikjKzXcF/VABnLpgxgh2c55aD7z1uLzqqhrE0Un
    L7UjVXQhOuSZh6QuXmTr5pRCs28i6LGHt1HXz8ISWHDlSYVzyrNKfw/r3zNUG58zDm+fPw
    MpWHZg0Pmo8unfVtRtd10UaJA3WTyjHukRe0nCFdaaJMNHrjLQz2ivfer5jA
X-ME-Proxy: <xmx:dqTXarMZAHnl-2VfPFpCVLhSbIyQ8eiCVvp8RDdJTT7SdGmmdBNKrg>
    <xmx:dqTXasuSLTcjkFNVxoGGymoNkeMRJ4TmCNlACvbvralnp8AeSs0OXw>
    <xmx:dqTXahw8P6Ddpi2XRDE8N8zFmRAaAflhBcRy-Fefac_t226a92ea5w>
    <xmx:dqTXat5joCdsDY05-ygPYgGmt6bbzdoYQlnK8jCHFK_SS14gocQfoA>
    <xmx:dqTXasUj_G7FDmOs-kp4WRZ1iUv4_A1bbyHE3n5OYDJmSq9S0lNvc__p>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 20 Oct 2026 13:27:17 -0400 (EDT)
Date: Tue, 20 Oct 2026 18:27:16 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Miklos Szeredi <miklos@szeredi.hu>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	"Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	"Paul E . McKenney" <paulmck@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	Luis Chamberlain <mcgrof@kernel.org>, Ilya Gladyshev <ilya.gladyshev@linux.dev>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, kernel-team@meta.com
Subject: Re: [RFC PATCH 00/18] mm: read the page cache without folio
 references
Message-ID: <atejY_iL7U29bV4Q@thinkstation>
References: <20261019154913.1765974-1-kas@kernel.org>
 <atZurH8mp-yW3Upg@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atZurH8mp-yW3Upg@thinkstation>
X-Rspamd-Queue-Id: B7E1C40004
X-Stat-Signature: 3thifbboo5soujpbaijji4a1aw1iehmr
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792517274-706423
X-HE-Meta: U2FsdGVkX19FSWUwW5IinvFBQQ3Ds8nl232I5Q/udwcIs1m42tkC+FtiRke5RFoUqJvib/hf5M7DnMUmS/WFF9Nj9AYOntUD3DIVkSct8b7hAI6MXj/i0BHqCRp0TVkspiLBMWn397Way6qDV/eoAbqS6dseESzQVCkrFu4apiMi3g8ndu28yF6lLKV5U2nV7nrt47CK8y+RasiaN8T3iX9P/HpnmzAiU5JN69f9yTnM1+GDBkQ35Hmyhh+xAzDRGop9i9ABrYziV+yOh+1Yu3Xe0lK4f85rf9lrzCRWeuYAVLvi5nrxmhTXpUqH4UO/EARtOJo92GcKIcI2Q68IARqpLXKOcf8UQ9/uHsZiY55/ruFdknOcQsM/qTEm5jkLC0f87EgHrrqIqixzsrSZlJpFG+B7oprZwO67NQYhCZCKP3MkwVB/sSFGwXoXSrkm6Hz7tb8/ZHMmrxOdTgIZX4248N1G5ZQD3/Gx0wS39OWgGbSaldzG0cbV78LCJz2LqmQuLX1Tl5KahGuwamZut857sMZD0sR31WZWi3voa65WSI/X4TTFP+DFpkyUb9fYamsVCd++Eo/XKDuVrCVME+y5NjWPCoAa+5yzXvTeGLFibZqEcbqHZAuZn+UoCcrVB0DzGeHfw/xGfJhuFbIlGtb+zHj33oWazvdLFjA2lDSzByzEVs7B/cOxhPAfHEs9AdrUkI7UPrVie21eeux8LB+0co07qjwX53igN0dhyqEw8hOyTU6wW9mFk2LUAbFLQch1DnJf5BnOkPYHLLNGl+sUE1YBcyd5WHekyuJfUCfnthnj+s6dX/EIdDqt+2rJ/HO6id30EM0blS1ojdkPXG8iCl9i3gx3/bWnVbc7SpH00egKZfk+JkRaJp2oGJVAMdNZfQvEiwasKQpvOPBcIAmt79XU8048TjHzu1YNNGwHrNMUOYbEn909lRS6srSpvC487lGoF2i8018hTYV
 sD1m8l4S
 N07NxgP2k6M4CYiDlRg1a4OmhuEBYBK4CzWuL7PSRKKSE4knVAMIFYlWzkbOznsPpsfG30AT3Yw5IZZPIR8iXhe4OryNHaLcMho07pVBLU04TGeyzXi4cz8DnB8MneC1ASGp5rcyilPuJq2ceNv+yQjY1aNxSrrxay68VFd5i18AUHv2jvJYhVSv+QmCQHippmW0Q8Ag/8N2IUQePlz1zmSDWR//RlhZh7xzjmhht65wd9xBxkdwZ+GyA2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 10:20:52PM +0100, Harry Yoo wrote:
> On Mon, Oct 19, 2026 at 04:48:53PM +0100, Kiryl Shutsemau (Meta) wrote:
> > Small reads of one file from many CPUs all take and drop a reference on
> > the same folio, and its refcount bounces between the CPUs.  This series
> > lets filemap_read() and shmem copy from the page cache without taking a
> > reference.  It is Linus' RFC [1], reworked: a folio that such a reader
> > may copy from is freed only after an RCU grace period.
> >
> > Only the folios that reads keep coming back to get the flag,
> > PG_rcu_free: those that folio_mark_accessed() finds as accessed as the
> > LRU records.  Streaming reads and data that never gets hot are not
> > deferred, so the memory held back stays small and most frees are not
> > touched.
> 
> By applying this to hot folios only, small reads would benefit only when
> they contend on the refcount. That further narrows down the scope of
> workload that would benefit from this. Random or sequential small reads
> still perform the atomics on the refcount.

They do, but an atomic on a cache line the CPU already owns is cheap.
The cost is the line bouncing between CPUs, and that takes many reads of
the same folio, which is what the hot marking looks for.

Single thread, 16-byte pread() of one page, mitigations=off: base does
7.4-7.7M reads/s, the series 7.7-8.0M.  Dropping the reference saves a
few percent when nothing contends.  With 64 threads on the same page,
base falls to 17M reads/s in total and the series does 220M.

> Maybe we should try to either 1) find a better heuristic to mark
> which folios should have PG_rcu_free to make it beneficial for wider
> range of workloads or 2) identify workload that heavly contends on the
> refcount of a small set of folios...

Marking more is not free either.

A flagged folio goes back to the page allocator only after a grace
period, so what reclaim and compaction free is not usable right away,
and they have to work harder to keep up.

I am all for finding a better heuristic. But it is hard balance.

I will get back with data from real workloads.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

