Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 991CF606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 14:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HnMpGD3e
Received: by kanga.kvack.org (Postfix)
	id 938E26B05B4; Thu,  5 Nov 2026 09:55:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E8916B05B5; Thu,  5 Nov 2026 09:55:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D8386B05B6; Thu,  5 Nov 2026 09:55:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E80DD6B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:55:26 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 725CF40A60
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:55:26 +0000 (UTC)
X-FDA: 85401363852.27.E64818C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7A710120009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:55:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HnMpGD3e;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793890524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nrSUhArM/zHEjchVrw9NyJq5VRSjmNtY2/0KcQpTHjQ=;
	b=lC2sYj5HXAAidAm9aVnxep2ISssGc5deiQemlBmwjjdTtj10Saegt0Vct/doF4AglXW68t
	tlspY7HQSidf1xxpuzbCn7Sbp5X/8ns+rX4vRVSfuW7MjTuZVnDSmeDHu8cJlBOmZJp2IQ
	RZavmXu3Q8KXK4EGFn6od6QTBRZZxTo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HnMpGD3e;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793890524;
	b=GuZ2EvolIiYIC21Y5j7fxYiA4b6DI+rCdiAjI2GXrjGhqWI0/tdNCWI85Qu0x2jb/MNfh0
	uW0QWW5XeUzKcxORdsGM5BmWnRUskO8LrmByYlVBM8/Zt+JRPTcvpvTx5AWs9mXm6WajSv
	NhUD6/y6NU4Odm1KAo4DlQfFaXe/gbE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9DCB4437A0;
	Thu,  5 Nov 2026 14:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D781F000C1;
	Thu,  5 Nov 2026 14:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793890523;
	bh=nrSUhArM/zHEjchVrw9NyJq5VRSjmNtY2/0KcQpTHjQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HnMpGD3enRBqaeLM0xOBVlGPC6ENy8qFZ/LxACoukGORjw+noHpWsUVwyyt3vKXEH
	 By0v72rigo8lVnWymIOfs1QOwKv50FFAIAKxyKJL17MfWiPJ/Vy35JK8Ql+YfjL0FB
	 Shg9UmeEPJMHdtI2ECL96FpIDq5r0/GDPdFdqFaSCnztQ9iQ3lkOtn8iY2Wd3JIT47
	 P/h/C2EK3IVX+2AEWzGbxi4NkIV4TVRz/zEY+bQit8tS39LnBhFHwQ2XW3GWonJTDs
	 rFfg66mdXs9uPiwJiexv+DKfyi6kHfQoAngU7MxqY8/lWUeV7xZVykWfFm0p22nuYI
	 2i6PlwsonzI3Q==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id EF5311980047;
	Thu,  5 Nov 2026 09:55:11 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Thu, 05 Nov 2026 09:55:19 -0500
X-ME-Sender: <xms:z5jsatHDs0jNWwmLwh1eHUQzs5ENE53hTkhR5YncedsWz6WN4SAU4A>
    <xme:z5jsarQxquV60pzGc1qwR66ozvTxn76QXXpZ1UCUQJCNDYR0LEzaq1GL3Nf2vFLUp
    SaSst8kp_FQ5FecIOtJUchklOadeTPlvOY54HDB4x_i9c07O-FVGbJZBQ>
X-ME-Received: <xmr:z5jsajixFkwCb1otqZx09UkN074IrZFBOKGXtb3saIoCTNKx9B1LRS9yeqM>
X-ME-Proxy-Cause: dmFkZTEfNv8KAoa9rNZKyCWbiBmL2n4Bk7MXZQMFpHT3IZCghURgydMkmL8v4sTbbWh2OF
    o7xxu2zDC7APT+fDNYq70qrN3HlCZ8JAIeVGogmdUAHgru+GtiC1OI8114Wu3Rk+xIjxxh
    cVsRuecuAGBuzau6soxBesvdI5sFcias6CB1X9p6F/vSuFPNFtDwf4qra3lHUbKPTkqDGO
    Y6rwt0KLp5W30A7QcwUEn/6koJCm0irKqEBq5nWqV+9FLrPejZigfr6eDzWWE5ydeQHXTY
    ffqQhUaRv2p1f6YTvdhmsalDlTQXPfgvekWlclWqq/6/5rek0k1/utIJ/reiUQWczHw9HO
    YRc2uvruhJNUSyM9Jnh/abZo9DaZ4YO/dkhnTu25kCEN7rKnZQM4/pxmgUBgZkmr0G0RIX
    RzitBrGcFgbWWmosvzONvgf8fSQvmyfiio8a8d1SHYX+LnMt6U+l/HcrCHkGherw1UqYze
    EK2r7hSXcoGoaNm09DFgsNz1kProsKnBQALlANmKd60rwQNrd0JH5doX8LtR9QFnLFGo7k
    Jke/VX4B/ZNV/d8AV0kg2YcfIy5bA8sONZAh2Ng8L9iXuTvrQvtuh1xW1x45BCkWBiYNf2
    5awshSKvvMDEj+81wsaHWQsdSlOzUEC74y/g8yhE8YC4nChbmdqe1XOfBt3w
X-ME-Proxy: <xmx:z5jsaoUeU4tGCAFg7BPREqNNQC5ETkzv5QV364lTKDEA8dejX3C30g>
    <xmx:z5jsapMgTuMdmmt4_iDbWJHZB_c6xMSRJwlrUGMQUj_x9SYjlsIAMA>
    <xmx:z5jsatYaXFzeoCbneowS0FNTZxRKMHCwI9CwYmBB6ERrvqLmNBVxqA>
    <xmx:z5jsajT4DjSW9tnGMYeVh0JMi1w9Ez918dF3gtLKD9CkX6rFIbu4mA>
    <xmx:z5jsaqOr-VgrFiM_ZBe50Pjq3oUd5Oi436kgCg5c0wLu3EcL7Qv9Jpkq>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Nov 2026 09:55:10 -0500 (EST)
Date: Thu, 5 Nov 2026 14:55:09 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
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
Subject: Re: [RFC PATCH v2 02/18] splice: don't steal page cache folios
Message-ID: <auyYdqQBxdnBuM0N@thinkstation>
References: <20261104130118.2507513-1-kas@kernel.org>
 <20261104130118.2507513-3-kas@kernel.org>
 <af2102a2-206d-4c5e-ba1d-1ef42b2b6338@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af2102a2-206d-4c5e-ba1d-1ef42b2b6338@kernel.org>
X-Stat-Signature: 3wmwemnx7ae3wirkeywk7qdnzw1je164
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7A710120009
X-HE-Tag: 1793890524-85054
X-HE-Meta: U2FsdGVkX1+xxWY8KyTspEFgCwNJT1P9BtyJGeN+fRQfJXi0pCc4MZ1qwJQJddn3//U5GJxVipDqrVuQNp9BgE+SaiWyOtHfgr4l4gibJo4VQ17SvblQT3ah67WgSA6UQdHQlnx8jweN9ssUgAIfZxeePo63lHKs/8mRSy+SCYWzoCqijMUVNPHKw7rDDYHEkZM/4QGdS9Bb5Y/7wt47m/Qu8RD9OdI/GiAGp/+Zf1+r5GuzfE0s8fuMfa+A7SgO9IJUWxcDqPwwdxt4YXkfOTUiBnVj+AYRu+UM4GojQB5PxKW39wn0sKs1Cx2owQxAczrVZIrBs/vDjQslZXRPsUZNZel81ZCURvMP7L+jKlm/0uFKQ8GzPwwqf7vo2YcyMK8wrTI+iB2FP57pR4GZd7n8LHX8eEzARqJyNIT07xyK1BgX1bRVOzj01PBf+VCvcQuMk8E6rZMSd4zD0VAdPSK6m35/kj19GYmJZ5bqtKuDJUPgPRKd2F7nqXOdSdyEnmdIoykgii3o0/gAJH40sOgjEy7M0R7CyTpVHuS5LHqVRPZ+YqdcLxAxEjHNnJ9K6wUh5N2DQ3fMR8jj43QcFFe09gPMpsm4eYNAORfJnSTRtdKyICqp4IlrE1IlNXfkycIoDE8XvhU23NjoG9vd4sMpqFzgEN136e5/c9Sz6tgZndM/PZ9dbBOThUgRgnRI0gg8UtOSg99Dak0+/Cwp/t2t9DaUYybt5lxUUqZ740s/jzyWJMxQX5/Pqh2mPvjYp2ln46tkgGKC4RYTXriuMRDBS4/4VHSAO80GdxcAGI5ibRIC/n8sDXkXCB6xSha+sKxQqqUkKNlQTJTqktq3yfWG0xZjcAo1pYYNmEzXF05OfXubAKnOf1p6NJu6Ps2zzk2MuIKQ+0+g8loBq/ZqXQMyvxdDl/pzog8J33KY9qZjiO8NNANfuJDLSQ2i2ntuc0z8j6PoUk22OQC1IxL
 1JcdTUw7
 N8okv85u1bhsALCr1NswI+KEFlH+hWe9GIoVpYEHO0aKcHzIU/fYD9toZ763gGRvDEPoWh+KN8wSm0+OKSIA7Rgpk+ZPDwWd/p4l9Sw9jGgLtJABDsl4K/LvJoRjQBv4HWaG5iRlK8sqx9MmuvnYPbXMFY6QssJ8obu/5dIkOReNdA/1CLl0dvCecQNsnBtYunIRkXjrd5rOH05AElT6JbVO0+HmoBmBkPB237TkERyNyjX7aXy1KhCb3lIUbT3VQQE69r5EaLv0TbWKqjVisaAz+kU5AoqNxRO5ZindxKFh0gq5ar+4Fwxlcas0LU4aPhZa9UqbENvnRz6aY2Uj1v7BJMbfID7a77vrOWfF2VStxM3ZqYOcoruTdJjL1JaXiDCY9EqE8S6qAjL403/wZkg6ARlB/JTdzjKUKQaIjpq7iDoGvkNsPkVMFEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 05:05:29PM +0100, David Hildenbrand (Arm) wrote:
> On 11/4/26 14:00, Kiryl Shutsemau (Meta) wrote:
> > From: Linus Torvalds <torvalds@linux-foundation.org>
> > 
> > PG_rcu_free holds back the reuse of a folio's memory until a grace
> > period after the folio is freed.  A stolen page cache pipe buffer is
> > reused without being freed: remove_mapping() takes the folio out of the
> > page cache and the caller keeps it.  fuse_try_move_folio() puts it into
> > a fuse file, where writes change it under a reader that found it before
> > the steal.
> > 
> > Drop ->try_steal from page_cache_pipe_buf_ops.  fuse_try_move_folio()
> > and virtio_console's pipe_to_sg() then copy, as they already do when
> > stealing fails.  SPLICE_F_MOVE from the page cache into a fuse file or
> > a virtio console now copies.
> > 
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > [kas: rewrote the changelog]
> > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > ---
> >  fs/splice.c | 51 ---------------------------------------------------
> 
> Removing code is always nice, even independent of the other changes :)
> 
> The description doesn't really describe the impact of this change. I assume a
> slowdown of certain workloads (does anybody really care?), and temporary
> increased memory consumption (as we keep the pagecache page).
> 
> No idea how often stealing actually succeeds ... a bit of history why it was
> added in the first place and why we no longer care now would be nice.

SPLICE_F_MOVE has not moved page cache folios between files since 2007.
See 485ddb4b9741 ("1/2 splice: dont steal").  The only users that still
steal from a pipe are fuse, when a server splices into /dev/fuse with
SPLICE_F_MOVE, and virtio_console's splice_write().  With this patch
both copy, and the source file keeps its folio cached.

Miklos, Bernd, Amit: do you know of users that depend on the move?  Would
the copy hurt them?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

