Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDA99607B456
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 16:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=sECKCBUK
Received: by kanga.kvack.org (Postfix)
	id 80C4D6B05B2; Mon,  2 Nov 2026 11:57:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 796526B05B3; Mon,  2 Nov 2026 11:57:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6372B6B05B4; Mon,  2 Nov 2026 11:57:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3391A6B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:57:27 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69C2BA0135
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:57:26 +0000 (UTC)
X-FDA: 85390784892.02.1297887
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4D8E31C000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:57:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=sECKCBUK;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793638644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Od7mWefqtV3mjxyxY9z/4vRU5fSlhS8dN/ywhpTdKVc=;
	b=3GFLoTulw/WWEKHU1EJX5gRKnDiUOOqoZ0eQd0bR9R5EPAk9MawJajE9B7qz9qlFm7ocCy
	cY7Jo4CKpsT7kKhzJyKBIjmjk/CD2r5Xmh4Gd5qlgz4hkH8fCPnAgr3Ky+7dwTXrM198er
	rzJ5wyti/+bJQEvEuqFVyfZrnrNQF6g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=sECKCBUK;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793638644;
	b=I9rBtFiER10e0/lErLcZiAN3K3gifjrhLeOAGO7NfziszNTA5x/uvVoTWPcbVSvtPrlpDI
	X3GMxayVxxk1Ri/FrD6uYBjx1+PF5orIlNHJ97CzdrBcUPdBUN3xmvIBkddDT8t0SyJgCf
	4aFfvbgDhvBvzBoRua5GvD4pPudHXp0=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-8aea7b7ca0cso27856677b3.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 08:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793638643; x=1794243443; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Od7mWefqtV3mjxyxY9z/4vRU5fSlhS8dN/ywhpTdKVc=;
        b=sECKCBUKiV6XECJVOZEzEyhnEzkb7ZFcB4PfcofU389u8C+YpnCKrBHsksuATQTtkD
         /Ncl8nlt5o9zPuhm3Ps40f6BYxhSZU2K4bNw+lkfNOCSSG5DK8k89Tpa1WX7WJHjJXBB
         AW5xN0M5ZhwyhR+WpIP4Y7QGiX3Ce5ZAgHAKsYNL1f+veefcXcERzpT1jKeRY3a2eT4j
         Tzu0XKQmt+1VIZwPzW5i2D++pU1fWpy+MJ67t+vLZtcHIqN7OIgOqdVNXjkNhYvkBpCH
         CNouGxszhFHbXkBJ2O5FIjqZLaLPQkS46HSFwj0K1FBW6dtDn2Vb7Z4MFkp43QhID/zj
         mRoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793638643; x=1794243443;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Od7mWefqtV3mjxyxY9z/4vRU5fSlhS8dN/ywhpTdKVc=;
        b=p5vq1KXHGmBbK73cMbvQYUX+x9JFOOaZTO81K89tCq0Lbs3b0KMft+CKTQbACLUL9F
         9SSfSEqiudiosH+S7tv6K8y9GqzJBxnFcx/LQ3NP+RHhDyMkqCdCoytov+V8ELplm7eU
         Z3DOYnbbsQXNemeWfkK7B3qkrc8Cf3x0LpHUV6mjPn6fCFBxhQcYiEf+Sbi0Je6zRLCo
         mGdm+Nf7BZyy4UmLOkNYdW/p5YVkUiejXGCNpmjGHNoyRwluG8VV4pzGmIfhXU0doFKL
         J6ZPXVUVJIYu6I5DjE8vLSwpWmltScuFaHcyImAFjuKVJXAMUgjuvw3DgDP5e9HoTAdO
         /5mA==
X-Forwarded-Encrypted: i=1; AKwUvBwZZytSA59SLgygPJvV8/bSlntbyBbN1KxnzMCKfCUbBfuFDZrNPM3L+D6wXGRHNYwtHBuBPCn6vQ==@kvack.org
X-Gm-Message-State: APuU4Z9NN1QHcTpbeqCWNHYs/y4yDxNCUkrMgfK0MhgJhosisyuSJjUR
	Q7Q+b5PIX0I9klkbqanEOzmkZc9ukHlXk5pdPfz92S1VZ0NMos1nOsWHbBoZ4sfBwk0=
X-Gm-Gg: AYBFou03MwlabzeHDsJvLd2rlLRPiCSwVaCdPlPO6SWAeRRFTSuiCg+tUXEMNdLbhew
	XbXQAr+X+B2EJbA9LOAonenQ6AYlAVLwbLEood5OaEXesEir5wYEO07BwcOvglRHrfdtbui6dQT
	fhjoJsQ/o6oWSV9sEvU5GCmb6oR1gHkVIuYApm6F0Nx/cPRNZxCD6MrW8fEPmpo93Orx+22TWsR
	TOZJiszA+OBAqvM642SWwvKAlganOanFWwqCjckGQj10K4snopQk+MRz9XT1+k4yEw043glW4L0
	OB15RRd6L0Hny5wU5MN7YFv/atE+NSapzH2fADEDv5JXl+w/U2VK4SV7RnPBcK2yEjzXTPEz6lv
	9NRiPq91oeS5rgH6BcjJwyfTsU/b4VVqYD3wmk6ywt92EzAu0kabdrgaUgTGmOvB1BhifjzC8Cq
	2kn9vVRQ6/71JQlFzn9Tge2ocafqlOkca2exnMTPIimEdq5HC4PgRDWusoZjNn/TP2BQYkss4/h
	fTswmoQCOTBXgI+0L486b5k8T6taWVq7+5OpHQIdrrPA9KO9p46u0CebeChqw3/5cZKsFwVIGR+
	xVPl+DeDAWLLVxt3WyTO/5jONdBEfW/O2rs5ppKLB+gfSVyG
X-Received: by 2002:a05:690c:397:b0:8b0:c673:993c with SMTP id 00721157ae682-8b2b66ce40fmr59394677b3.21.1793638643157;
        Mon, 02 Nov 2026 08:57:23 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b719b19bsm56552457b3.38.2026.11.02.08.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 08:57:21 -0800 (PST)
Date: Mon, 2 Nov 2026 11:57:17 -0500
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
Message-ID: <aujA7X0IPvtRTmFG@cmpxchg.org>
References: <20261030-swap-fixes-v1-0-73f73a59f2fc@tencent.com>
 <20261030-swap-fixes-v1-2-73f73a59f2fc@tencent.com>
 <auOz00OGB_8dgniC@cmpxchg.org>
 <CAMgjq7BYgXLheXDyc=p2mNgxdP3+92v2WHGiXiweDrsiYQ0u2g@mail.gmail.com>
 <auSWtJzFQ7KdElKL@cmpxchg.org>
 <CAMgjq7AJ0uajpVM+Kva5=_EXtmaawYR8TJQ6RdhrP7+NUZDx=w@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7AJ0uajpVM+Kva5=_EXtmaawYR8TJQ6RdhrP7+NUZDx=w@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4D8E31C000B
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: k1r691jygdkm9o8wzgxwuwpwwnu3qwiw
X-HE-Tag: 1793638644-262378
X-HE-Meta: U2FsdGVkX19Y9u9gZtHfREg9L2tqNqE/N4bt547SlRXiZrs1Eprmhdg0cZClJd2HS5CpfsROyOcNBfcFkAfmgPU0IA/lA1w3FGlNdWJaFx6An0umHDfjNc5jM2KuLqgJOcLyiYsmvPzEH81yr/8qUJWLd4mQX2OWRoKqzS5KBc1WkkXd2Hd05D04LFyhgK2IuxPvZtNXpeTnEo2YTTPEeqf4Ysg6FrOQrUHhTZUWaV/2aUJ3AT4rNRN+sw5RW9wmDqtChLJqEUa5dAWTe4quA2JVbsP2FAEXhhdeBxvdjQMm4iSo1ZjKVFREu8pWJdVQKNUvCGHAr6Bod96lU7OA4y2WvcRHA8oc6T3yQpietfcgZQq5D/T0Y4eUMOzAs131YclVpKDmZB80imSnKiPicLWHsHoyKeAAPTeKUuVNthKGLUQlfsxjMl/H7pUbApbXwTN4z0vURKeGcRD6it10x/9/GK/JjKhADKYFSSY/jjjdS9ukp3E7kTim0PC50KE+Ds41edN2Lh4ou7a8K//YbAWw0wYhSd4+6Cjmgq+HG/x8LxXenDX7CmZw4IkN2TJoafwaeURW0zzQ2VgiD+mGvO4PBayX0CXgOFjzwRVtyvI4HbjjYcSfzySpaSyTr9l0MxgAs1i6n5faUvylMv8BpRIAwfWQ3j+h1CW9rKPq5XREFr9tXrwpWwPT/OOzov9agaRCNsvDUi1fnjPyxsTkdODdn2FnjU9fmcCBjRqZiWWNuzv2wwlKvtQ81zySK0NKDkrAP584LmQSsSm89QMYTXKUa6gPTFmwUuZfUc5WoiaMerX9v+Gs8OCvthSDHqSWWTvxTAfw99U9nuaeuoeV4WoLmmLR3f0hNFMvgpPLxx2wWxAqD/gRA429aEZ0nnWftVSM8Odyvc68yU66ykHheABeRkY4X7cNaYPXzeZyki8vf7r92tUKrD57OmHjOyYdMkWPECkqw2eQAgrh5YW
 Vt15fvZ2
 sq4GHzhgeXX5VoFYQ77NDGibJUzDxXqY1L3VSsubK2dCsP+6ASWGt1v2V8p+rcAypziUT5KFJFVlNJ/X9KR4YzWeeVRbMz2v//A3f5EvXWaAlv64rMYfJ1r4RNEBYk/0A8biIUVv1gvrQ0fAO4iHpSb16Ar/iif8ufpEAW+i5V+iAw2H7rIs8cfSLtZzqVpq2rO6tvJREP2CD7eFL1ex0zS8uTOyPDm3uIN/yudHFRL2stRWzDy5v55W61cSLzqhyM3jHf9pNE1ZveINKSZ70uq2kjVoXvcgDu7lxur/phndDyCO/XjDUzx84Hvf5f6Jz9eC9nftuBzuOcHBebTz+XDMVVe3bdXkaTkmCN4ORisBijg8Y59y0FqLzsg3iRMPK/jOJzMUL8M8s6URHl9Xs0wrbRzxvEvL5AvVqMZEIR6FE2LjdCPsi6X/KaTRrG73ItF/XH5z4RnOaPJ7WxVFuxV1AQL076fOysabR3zIf233A2DPEsgLpJh0XrLAnocbWXLmUEsbNdX+2nilbL1qqVxHH1IbRRkIgaEAtZBXrAZ59JCjiv1LwNH1Dpwec39QPbFfyJskuZy3ELEWJjmClhEStulvQlTOgWhSnwHkpvZJ15aVtGzfiMPtFmHRXSpozuzJEzoJHdi+3oVTqMVZBh8cQy6x3G3dCMrLm3fHkQsruqJm7xz6xvxShpO0vD/pEwtq8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 04:00:22AM +0800, Kairui Song wrote:
> On Fri, Oct 30, 2026 at 9:08 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Fri, Oct 30, 2026 at 07:16:51PM +0800, Kairui Song wrote:
> > > On Fri, Oct 30, 2026 at 5:00 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > >
> > > > On Fri, Oct 30, 2026 at 02:31:42AM +0800, Kairui Song via B4 Relay wrote:
> > > > > From: Josef Bacik <josef@toxicpanda.com>
> > > > >
> > > > > Swap-ins from SWP_SYNCHRONOUS_IO devices such as zram are no longer
> > > > > counted in PSI memory pressure or in the swapin and thrashing delays of
> > > > > delay accounting.  Refaults of the workingset from zram, the main input
> > > > > to userspace OOM handlers like lmkd and systemd-oomd on zram systems,
> > > > > become invisible in /proc/pressure/memory.
> > > > >
> > > > > swap_read_folio() opens the accounting window with
> > > > > psi_memstall_enter() and delayacct_swapin_start() and, per its comment,
> > > > > means to count the submission time.  For synchronous devices the
> > > > > submission is the entire read: swap_bdev_submit_read() does
> > > > > submit_bio_wait() and completes the folio.  Since reads are batched in
> > > > > a swap_iocb, swap_read_folio() only queues the folio with
> > > > > swap_add_folio(), and the bio is submitted later by swap_read_submit()
> > > > > in the caller, e.g. swapin_sync(), after the window has been closed.
> > > > > By then the folio is uptodate and unlocked, so the fault does not wait
> > > > > on the folio lock either and the read time is not counted anywhere.
> > > > >
> > > > > Found by code inspection; not reproduced.
> > > > >
> > > > > Fix by submitting synchronous reads from within swap_read_folio(), as
> > > > > was done before the batching, rather than from the caller.  This gives
> > > > > up batching of readahead for synchronous devices, which do their I/O
> > > > > inline anyway, in exchange for keeping the accounting simple and in one
> > > > > place.
> > > > >
> > > > > Fixes: dda8fb68b590 ("mm/swap: also use struct swap_iocb for block I/O")
> > > > > Assisted-by: LLM
> > > > > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > > > > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> > > > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > >
> > > > Hm, this isn't a complete fix to the problem described. IO throttling
> > > > happens at submission time, so there can be significant delays on
> > > > async devices too that are no longer tracked since the culprit change.
> > >
> > > Yeah you are right! Thanks for the heads up, not only a sync isssue
> > > indeed, async devices are affected too :(, throttled swap fault also
> > > went unaccounted.
> > >
> > > > How about keeping the accounting window open across the batch? Opens
> > > > on first read, closes on submission. A batch with at least one
> > > > workingset folio is "contaminated" and the whole sequence and
> > > > submission becomes a stall. Would need to pull the !can_merge flush
> > > > out of the batch-add function to get the accounting window right but
> > > > that seems reasonable.
> > >
> > > Won't this cause an amplified PSI reading if only one folio in a batch
> > > is workingset? Maybe not a big issue though.
> >
> > Hm, I think the only option to avoid this would be to split the batch
> > and flush more frequently, which I'm not sure is worth it. The batch
> > size is only 32 folios...
> >
> > diff --git a/mm/page_io.c b/mm/page_io.c
> > index 22e5ac1d298f..806cfe633a95 100644
> > --- a/mm/page_io.c
> > +++ b/mm/page_io.c
> > @@ -207,6 +207,8 @@ static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
> >
> >         if (ctx->sis != sis)
> >                 return false;
> > +       if (rw == READ && ctx->workingset != folio_test_workingset(folio))
> > +               return false;
> >         return sis->ops->can_merge(folio, prev_folio, prev_folio_size, rw);
> >  }
> 
> We are in a dilemma with this change: if it fires frequently it breaks
> batching but improves PSI accuracy.  If it doesn't fire frequently, it
> has no negative effect on batching and performance, and it isn't helping
> with PSI accuracy either :/
> 
> But after a second thought, maybe we can live with it by having both this
> posted patch merged as it is and appending your suggested fix: the two
> kinds of devices end up differently.
> 
> For sync devices the batch is now always one folio, so there is nothing
> fancy, everything is accurate.  Readahead batching for them only happens
> on the MADV and swapoff walks, so the cost is limited.
> 
> For async, the window covers submission.  That cost grows only mildly
> with the folios in the bio, block layer and dispatch work, unlike a
> synchronous read.  And the previous per folio accounting was not
> exact either: in a single threaded task, the throttle or cost of
> a non-workingset readahead folio pays is also holding up the workingset
> folio's refault, since the task cannot start the next submission until
> that one returns.  Same story for delayacct.

That sounds reasonable to me. Zero benefit to batching on these
devices, so no point in taking the fuzz factor that comes with it.

> And we are missing the completion wait either way: if a fault finds the
> folio in the swap cache with its read still in flight, it blocks in
> folio_lock_or_retry() in do_swap_page(), which no window covers.

It's there, if you drill down to folio_wait_bit_common():

	if (bit_nr == PG_locked &&
	    !folio_test_uptodate(folio) && folio_test_workingset(folio)) {
		delayacct_thrashing_start(&in_thrashing);
		psi_memstall_enter(&pflags);
		thrashing = true;
	}

> So perhaps we can live with it for now by having your suggested fix
> on top of this posted patch? Some comments could be helpful here and
> maybe some further improvement is needed.

Yes, I think that plan works.

Want me to send a proper patch with changelog on top of Josef's?

