Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06E88606A33B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 19:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=JlQCUqsC
Received: by kanga.kvack.org (Postfix)
	id 0C6726B00EF; Mon,  2 Nov 2026 14:10:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 077926B05B1; Mon,  2 Nov 2026 14:10:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA8306B05C4; Mon,  2 Nov 2026 14:10:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BEF436B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:10:09 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 131B4120226
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:10:09 +0000 (UTC)
X-FDA: 85391119338.09.AFBEF3D
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id E622680004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:10:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=JlQCUqsC;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.48 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793646607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0OsLVE28qnFLFA/pfT2TsRBwEfIb/3blusAAAo9RVPc=;
	b=eXcbUPZ30p3BYu3H2iySQI//1ovTM4PD2AKefcLg2Ch3Eybd2iYZ3XPB77x6nw6ccekFn3
	15P3SDKJv7iskfxzS2HuWWUK1RtOsGDOvx2f+d7CWgpt6UwvPR9NYDmxuq7AjvH8BNxXJx
	9p1qvSMOBtc2xKEB2B13gPrdeHgo42Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793646607;
	b=Kggxg7eGCqgKPRDFacMfZ5flRBRDxZnsRW12XrHnm9gpdz9QVVcMbRpxg2wfLvoEydNZqV
	H0Ul0/yJ+za/2fWdMeFqmzkzYq2Z9HALPZmQls2U7fOSJyjXjmFDg1P1nA7ewxqXR2yYQ8
	O+kpkyZrer4o07A/iRnSj7ZT0GFXK/Q=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=JlQCUqsC;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.48 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-6798eb0d190so2340624d50.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 11:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793646606; x=1794251406; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0OsLVE28qnFLFA/pfT2TsRBwEfIb/3blusAAAo9RVPc=;
        b=JlQCUqsCan8ug5FhfS6gfF6gjwqXrh/nA2RftG4O2u1Z7bc5OnWFGCuzgTE6WurbFw
         chAJj55S24Z/plMxav1mTMDQbv5gx5mFMag1xqrIRTh9xgUw0A9SqovuwtO1xRKi4Rj/
         96l45qQNOzgeh6EvfZmuo0xf1NQ571U12pfw6J6+RjygAxuRpBicU1g0RxJCWGe5Rm5s
         faXP2yGtIUquvKURtpDtIcw2GE3DPKn74ZWtPjciFy0O1YrH6hnphX8sIBPPPO+jwCYP
         Oqu9Dl3itI/r9mtgONPXKaEq5vM7E9q74dB/Msau1RoziWdxz6CczOEUGtqdo9BRe5yf
         Co7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793646606; x=1794251406;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0OsLVE28qnFLFA/pfT2TsRBwEfIb/3blusAAAo9RVPc=;
        b=ugm78PFL1yQkQ+4IT8R1ngeDcS+POWBfjJLo89w58tou29zZu6SWZ0GPmWtz8IBzLa
         dPWOMNkjscSv7RVxXs7aL8dNCQSQosZ7fAJOrO65IPXnTcl46gvuJ0e014zbTlL8eMun
         Ah6wv+dZNZ4EJEHKfqrVjeXam9UIuMFMtOXN0KZ6sqS8tseKRC595RqxJMf6MCQdxZ65
         v7aTsPE2as0rxRAloUuviiW5ID3PU5ZCWWToAAKZbWGmVBvqo0yzPvtECG7F9DsRa7s9
         DKVbWY2lsfRbXyS3w6KpYlqEybYXW0zZxOtNVbPKZUEavxg3wGVo4H96+BS4AyaxgBoY
         kxkQ==
X-Forwarded-Encrypted: i=1; AKwUvBxN0sU0r7e0nEd97LKruIAM4NAuiLrdFceS8As7jlOD4HEqOeZOkEsFjjNsvcoUFl3kzao2W7q3CQ==@kvack.org
X-Gm-Message-State: APuU4Z/aGgLhJf5t7thgUGt/nZ8JRNL3Foe1pa8VoCSoYkFVy7SjrZfR
	77iyf9FwEcCwYZEmxffvIwVteXqhSkW6/d2kKSMc4A1//flHbHJ1mUCLhIi/3PBeiq8=
X-Gm-Gg: AYBFou3R2X0VetG9HAANw3thk+xvGBidC1nrnLzL5UxZo8ywYKOcFx9ol2OoMSq3LEo
	HpyuVwuEByeYDKjVDDA1K2woD/7WHfJtERqY4LbOyTtQn7gUN+bb2cliCxQz18ib0WZUsJLdWbd
	t9Dz8Psu1KJFfwAQDII40Dbax6947OxaGlh+bimrAoZvdZrUBpfa7hr0fyMu4zQ8gQ67AinDDY8
	sg19L8leTUQIZMR/UIQaOBiWOvA+VpkTMsFhGN653GApnUmg/WvGp1eM1cxDJBfdaex3rbFw9Y8
	/3BZp6jXQ6GEDpCxsRpfffqcL/VG4KPqBGsxsUkNn/ue1nJkycUt4Stt0dSPXm/4xouW64agXOO
	jVkAECJ+2GeNiWz7Kk2CrlwjGKIMBCpgWDfDqgikKktCv7J6/gXYDxSaHrVNAaQJDjtBwvkYRqz
	Qnt4VBVa0UL4vsvutGUNWc8wtpUHawidyM7nPyUYyHe1ozLb7Y1+fC3PQaXp6sAsqTPnP4495Xq
	WLMUiHppJ71utR2+TKlybo/ZHxMtC1mrWfUkRij4ZWCHyeS/NO5m2wvVKHkHTRVobk3RvL1z9qA
	WTtn9fPh96BObVb9a3Ge7TjkV7RESV4mfSJGYkCviH/HBmum
X-Received: by 2002:a05:690e:e88:b0:674:7fa:6a3b with SMTP id 956f58d0204a3-67ba4c82d0dmr7698101d50.5.1793646605944;
        Mon, 02 Nov 2026 11:10:05 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67baf27263csm5641093d50.4.2026.11.02.11.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 11:10:04 -0800 (PST)
Date: Mon, 2 Nov 2026 14:10:03 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>,
	linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Chuanhua Han <hanchuanhua@oppo.com>,
	Mani Tofigh <mt4022@columbia.edu>, linux-kernel@vger.kernel.org,
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 2/3] mm/swap: account synchronous swap reads as memory
 stall
Message-ID: <aujgC6qPrTqewPPP@cmpxchg.org>
References: <20261030-swap-fixes-v1-0-73f73a59f2fc@tencent.com>
 <20261030-swap-fixes-v1-2-73f73a59f2fc@tencent.com>
 <auOz00OGB_8dgniC@cmpxchg.org>
 <CAMgjq7BYgXLheXDyc=p2mNgxdP3+92v2WHGiXiweDrsiYQ0u2g@mail.gmail.com>
 <auSWtJzFQ7KdElKL@cmpxchg.org>
 <CAMgjq7AJ0uajpVM+Kva5=_EXtmaawYR8TJQ6RdhrP7+NUZDx=w@mail.gmail.com>
 <aujA7X0IPvtRTmFG@cmpxchg.org>
 <CAMgjq7DZYKXGw1McsDT345HS4BNqa46xte_dTJia6EMv2Dy6jg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7DZYKXGw1McsDT345HS4BNqa46xte_dTJia6EMv2Dy6jg@mail.gmail.com>
X-Stat-Signature: knr9zwb56xsfhkruw9dd59wukh4xiizb
X-Rspamd-Queue-Id: E622680004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793646606-739185
X-HE-Meta: U2FsdGVkX19r4rCc+esQKU32DcUXVr0j2IdqUZCI+nrolG5LOjvdgI0llPZ541rrKUGJmSm+R04SJE1rQuM0Ln0K0GuWfSz1Sw+ZAt94yawYXKj1w1DSCp5TidVZaTeLoO1g4So25PX0R+2ly1km9RIB0RTeTx4ghK12nAlefWfNVwqMtxYETC2krMUpClo/Ro56pc3NxXMdKG8LnOMAAGwQABrez7yAFuA35x3EPs0JfK0hkXsXZdQL7rJ/wEE2ETs9zNS2WpUoopi7+HJX0KQZy2DdjH5mrHLkZKj17r1/Y4ZVqpOQ08tbrGgZMDgwOkdS4xFP/JPBDAcv6U7kZzeo21ywXP/WaxFb9bQBUBmMVcrFmfxbU7inrEgUOkYiDRvCfRnyNk7u9SHwye9LV6aGC3CNW/gxDNpJS9JmV8j9jWK9L8HLatQdkO3GrCDi30pGRIV2vwU5HkxAx4SD6mi52yKBNOgHAmHRWM2JcqnH2pGJRL6mXGw0S6i7TxIPYLQIcq+sm7vNmUJMtIJxUYMWKasfnGDYdYma8nWvm395+wT4w7VH7x3WHakAPYu84BzC9r+Hjc8R1wiUjvGdZASmzOBUSzSJT8cgRECDdlM8uCsDJ/Gf2nsbQGMsPQ2vb6/yavuo4k+xwSF00/L4lOpWuszLe+VaRbkASfBqpoeGbyMLcisXimA4pk5KQCs53jz2IJsm5Nqg727wd8Vfjm5rNYQY7XmkD4KWyILeBQeJoUAymervYqlV2Vi1SQSQkoSEBHbzBWQKmbZE78U4uLzYyTmA7b8Wv+jIX/rwjQnr5BfKClxdneFxG2SerOfM0aWjqFkWMIaFbBzPHUw8QgSPNJQs/Ty6d0BC/wm74A9XR+/yKOPDZP28sY/WJ/B11AxxnTSnO70ePaTDBvTRK6EIro0VhoLZq5wj3JQKFR8q96nKAHQbG5i47sSG0wceuC/zuRUEAjauJ5fbQhB
 KNIaqUp1
 l1QcRAl3CyE7RLaxUMq92SFHlyNWSrpoPDF8PzsGgj2TpAiiurqCbrfq3IuaPzV37ORCDAC28hEyWRZcZ0YchZcQxoQl6WnvgxnyfmktMiX2esdgWK9FWmluDE87nCgUlQ6pMNR8emMgz7/X53qKRKr5cZMhsY7bzd2vcwnBLSjJ7GqADjDPDhPwVfQsMD+u4z6jrHFINYrigMytXX/2CLalpl6JfUN1gvhHC4L7dKCFIwcwPyYvpTTDpfeQKyDYJIfH7jYthso1+NMkt8V/SDB//KM5NmKoU5u0McB4FxEUt2fcrPII4T3u9qvZtvYPcuk8SZ26FWEgUirM/CBmw3/zb7Glagbj6vnZI82EHHVC1nHCOL2fS4YaUbV69OU77B1bmsR2pLvY/m9I/74+m6EUJHx9FoJhxmF5l7Yl2NMoNvzfqehpRktcfoAM4vacsLbwN+x1gA3TXs2hRN20Gn/di12v2ER9sZkSJRBSYk0pUMh4z/vDGtwpqWX4oR/zPdjrQ/N7ZS3KZbq4IdoHUg5c9Po/jIr/gXI6mFWJNzC2eulsqgNHmZ7FRpH762OF/sP5qdh2NWpKKXxQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 01:26:35AM +0800, Kairui Song wrote:
> On Tue, Nov 3, 2026 at 12:57 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Sat, Oct 31, 2026 at 04:00:22AM +0800, Kairui Song wrote:
> > > On Fri, Oct 30, 2026 at 9:08 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > >
> > > > Hm, I think the only option to avoid this would be to split the batch
> > > > and flush more frequently, which I'm not sure is worth it. The batch
> > > > size is only 32 folios...
> > > >
> > > > diff --git a/mm/page_io.c b/mm/page_io.c
> > > > index 22e5ac1d298f..806cfe633a95 100644
> > > > --- a/mm/page_io.c
> > > > +++ b/mm/page_io.c
> > > > @@ -207,6 +207,8 @@ static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
> > > >
> > > >         if (ctx->sis != sis)
> > > >                 return false;
> > > > +       if (rw == READ && ctx->workingset != folio_test_workingset(folio))
> > > > +               return false;
> > > >         return sis->ops->can_merge(folio, prev_folio, prev_folio_size, rw);
> > > >  }
> > >
> > > We are in a dilemma with this change: if it fires frequently it breaks
> > > batching but improves PSI accuracy.  If it doesn't fire frequently, it
> > > has no negative effect on batching and performance, and it isn't helping
> > > with PSI accuracy either :/
> > >
> > > But after a second thought, maybe we can live with it by having both this
> > > posted patch merged as it is and appending your suggested fix: the two
> > > kinds of devices end up differently.
> > >
> > > For sync devices the batch is now always one folio, so there is nothing
> > > fancy, everything is accurate.  Readahead batching for them only happens
> > > on the MADV and swapoff walks, so the cost is limited.
> > >
> > > For async, the window covers submission.  That cost grows only mildly
> > > with the folios in the bio, block layer and dispatch work, unlike a
> > > synchronous read.  And the previous per folio accounting was not
> > > exact either: in a single threaded task, the throttle or cost of
> > > a non-workingset readahead folio pays is also holding up the workingset
> > > folio's refault, since the task cannot start the next submission until
> > > that one returns.  Same story for delayacct.
> >
> > That sounds reasonable to me. Zero benefit to batching on these
> > devices, so no point in taking the fuzz factor that comes with it.
> >
> > > And we are missing the completion wait either way: if a fault finds the
> > > folio in the swap cache with its read still in flight, it blocks in
> > > folio_lock_or_retry() in do_swap_page(), which no window covers.
> >
> > It's there, if you drill down to folio_wait_bit_common():
> >
> >         if (bit_nr == PG_locked &&
> >             !folio_test_uptodate(folio) && folio_test_workingset(folio)) {
> >                 delayacct_thrashing_start(&in_thrashing);
> >                 psi_memstall_enter(&pflags);
> >                 thrashing = true;
> >         }
> 
> Thanks for the info! Good to know.
> 
> > > So perhaps we can live with it for now by having your suggested fix
> > > on top of this posted patch? Some comments could be helpful here and
> > > maybe some further improvement is needed.
> >
> > Yes, I think that plan works.
> >
> > Want me to send a proper patch with changelog on top of Josef's?
> 
> I've tested the following code on top of V1, and it worked well; it
> seems there is no need to move some functions or am I missing anything?

I did that to keep the write side in the same sequence, and remove the
then fully redundant submission in swap_add_folio(). Seems a bit
easier on readers that way.

> How about I keep your authorship and just send V2 including this ? :)
> Any other suggestions are welcomed!

Works for me, thanks!

