Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7779606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 13:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=fx24iiid
Received: by kanga.kvack.org (Postfix)
	id CC0A56B05B2; Fri, 30 Oct 2026 09:08:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6A436B05B3; Fri, 30 Oct 2026 09:08:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B80756B05B4; Fri, 30 Oct 2026 09:08:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 886D06B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:08:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2FE69A06EA
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:08:17 +0000 (UTC)
X-FDA: 85379321034.07.3F5A569
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id EF823C000E
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:08:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=fx24iiid;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf28.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793365695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tbKkDfSrsNI3XHQAy/Crl7KwhoEpqjXNtSdtk80lCW8=;
	b=jhXFvRzdn51hD3z+7OJuSPhsx+/jhHg8qQFtx1D5O9nKCJAsQJW4ZtSRdFOHmL0toL9odl
	3cFsDk1TGIOozsrDohSlG0RC4NS+dc6aA7TMDARQ9ym5lIrQ+e5O3LW5nBqPSWYnMLAVkl
	oAMA3XQGjpp2b0WZ8vH/wJtjSGNIWk0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=fx24iiid;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf28.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793365695;
	b=Qy7P+9JhRvpQxcipHHgoxW8E+ZFO4F12lit6SYffNke/keTMN2UK7QA8v5kXuFyjM+gtMI
	fcr2WPOB0YT33Snw2j5PWdB3Oxj/1lQh3EnqrJg8JlgoEKvd1NoLIH7z9QSDOrUsy3J7xi
	Z1YpOIjjy22dZaL9zg+6ZV3SI4JRyvQ=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-8b10ac6ab7bso5791467b3.1
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793365694; x=1793970494; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tbKkDfSrsNI3XHQAy/Crl7KwhoEpqjXNtSdtk80lCW8=;
        b=fx24iiidwBVAIEiUGT1yheX7/kVU3fexlipTcT+ilcqsE43J2A3kZtEZqcRAaVV8Wx
         F5ugqmYBSB3ieAzatO8Dw8u6hRJAwFhz5iuyixDLHu4CounN/QkXsqBLkcWrW0fCCsq6
         6qHOZl05G0MXqCoUp9ftmJwYp0M9OgzTbCPljdRARiKngyiHu7msEwIxRkUPm25fA80U
         hoj9F2jBBdRjcB0AMqICXNCgfGN+yJq12shdXAV95Tqw4gKzLOqUYM90Dq7qKh/ZpkGL
         iSN3dFJhdll6XnAeBJg6KgqNHfOVsDDeAIBNL1l8H1Pka0UTo6MUEKzYozQ1SUUNSGl/
         I7oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793365694; x=1793970494;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=tbKkDfSrsNI3XHQAy/Crl7KwhoEpqjXNtSdtk80lCW8=;
        b=zpcygrYGe368lbbWlAI87s04Dyhvm0Dj7phz7qrLJ8QrJnXmM1xq07vbR8QXEDUSlr
         dnZZUZUw5b22VfxxsJg/3PyDSNkBrdLhbfMmZNF2pHqoL5TDUD0OtJ4mc86XCgtCS64n
         3bbeXyr0ayB+QjgE6n9mDRv970W2DdjHPh3k1cPvWxir8KSbwKIHaMVvuTGNJM3scj6H
         cZRa/Ka6U3tySzsT7wUEj35TJkAKUkg/BYR78yYbiIW9jzzXknehfSoy6k0SvWqbvE1J
         YQsCEJzEXNkLxK1ebTDnfISnrqj4Egg27XAgYO3Fbv1p5C/zraQ/hm5Lk1vGfEvNedHN
         u1fw==
X-Forwarded-Encrypted: i=1; AKwUvBw6ECCEv7BFRZMiL0vCEg0WUSBtjgzNYRW55gJuawRrsTauuDBsLUOY+DsklccMvduPGdlab0/R7Q==@kvack.org
X-Gm-Message-State: AFq9FYIVa34rN0ybylSGuJfc2HXvUdHtOFcgCCmY2xqIIQvoc5a/xBxX
	TN3OA84hpDDphgTW+HFiyT3htIHTdPAfeTRfBCPvHGty6+LmG//4yA1+WcY34735jnw=
X-Gm-Gg: AYBFou12+jW754hWnynQrkLJDhJqOQD6XEmj+sVoW/G2x9jV3b4ApMqEseU/AyyWHuU
	g+YhbutLrom4GwQ4qZNOat+PwSu3S+w8UYcSZK/oqNCFW9XiczNykssSzd0rejV3CPLL3HtlEWS
	8hqimd2dYkAFtuSCGrBWSWsLOIE7FQXRGkvXW9Etk9qQV83ANgNmgh8cyRl4AxtFtuV7Njvayzp
	CulAp4ME0OVwBnolX3PHr2J9sV9lQ0rL3ZVqs+FXNkkUrQaDg7F8vIum5Szyb0mAr1lNdepmkby
	29bf9s3gNdk10aBn/r61LtixHYSLAkLVP8T6HkLD8IrAy1e+GocLjTRBNOnWzs5DaD8eVjXzxmh
	aFGXbh5cF80wAu20Xi1nNYtTYIWoxIEAvBSZO8fJd7EIuZFtRUeVZ/2SmT1QX0e6nR/goRVcEDr
	VE7jBHHgrV2XgWvovmmZKbVHtOHDALxVJSydEjsrioq7YZC8cQTjpGjHoRaQrHcHox764LZn/ix
	IT2EehcF+weEIKRVtSL29zmwikQ7TYZMG9kqhCpWgZUTJlF9cPyq41R6XC8eamK4NJM+QmkZFRY
	LLd7jdcNGK/rpDirICSukYF+VYq9GVRN1VwiDaROynxGMVnFoQ==
X-Received: by 2002:a05:690c:9e:b0:8b0:9e38:f407 with SMTP id 00721157ae682-8b2b672f790mr14821957b3.32.1793365693838;
        Fri, 30 Oct 2026 06:08:13 -0700 (PDT)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b7198c65sm7731727b3.36.2026.10.30.06.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:08:12 -0700 (PDT)
Date: Fri, 30 Oct 2026 09:08:04 -0400
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
Message-ID: <auSWtJzFQ7KdElKL@cmpxchg.org>
References: <20261030-swap-fixes-v1-0-73f73a59f2fc@tencent.com>
 <20261030-swap-fixes-v1-2-73f73a59f2fc@tencent.com>
 <auOz00OGB_8dgniC@cmpxchg.org>
 <CAMgjq7BYgXLheXDyc=p2mNgxdP3+92v2WHGiXiweDrsiYQ0u2g@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7BYgXLheXDyc=p2mNgxdP3+92v2WHGiXiweDrsiYQ0u2g@mail.gmail.com>
X-Rspamd-Queue-Id: EF823C000E
X-Stat-Signature: rq8xy763iktdx9ezwi5mfbx48h353c1r
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793365694-835321
X-HE-Meta: U2FsdGVkX1/ad4W/cJuTn/leNMjr/IRLpmFUQS0Kvlg+wSdQhyX1VaCu6kM0IHjdekZVZVQ83rYDGTxBzHN/+aBk+Q9s9cLAOc7URqFYWaJCljmQzx7lcOtwbZoxSIM3Ti/AeWnwmPqnpVUJjbZQ6rBqyAuhbOL2BFSIhk7ZYMOToR/ujvOLNJMnR8TfkTX5eT84JM3cyuYm5ATUzqrT5uB763DLgSb+hGHZILLW3cdjQQvsZux9e1LxVRsXE19rYXsbBC169BiUpOK1Mql7UiFz1Bp6mv0qWFOwLZfZlQIrKiC4yxWhBLqSoTs3BFLd3x+sViD3fviV/a623Cb2wqyoT9J0CbjX0zKGgo/lmV5CWWrQ8mudIq5/1o8hwZ7VVGfJ+tTJ/AyVJycb6Q68NU9Qa7A2B2SOIRq8uPp3e2cM5kRxz3d1C24RTvUlynzt+VMRJKyWW7f0aXj5WfokdWqeCNfp+a3T8lhOjzAwMtSEPiNpPCyvYNhDR0fi+mfT8ZxJ5bwWvnvxR6b+OWo6Vwm0Mtvmu4oXn/xeSNkjnlgmJZeXS3acxmQPEt87d2vtAum7KY0i4f+mFDgDZHoixA3ojtaMdcwoQ87U/02RAVU3KPAmziCnIzdIHfl/mSFddNIGbvB0QK7MCKKfMF3QHeJYiAorneuFY35oJlt8+i7p9OOvLRb8NJwU97DLaIOAZ16ir1HMYJMSH81+XdtAq8G42mwytV6bV265VGAI1/pBYRqq2kU1Y8MxHUy8ZOWjKF+2VHprQYcDftGAtZCO67ww2WEhM3OuXPlReN9+tb5/T52EIWepTh9Ua6A+DDmWj1tfDHBTlH2hcMBDgZCEwzot7yUtQx5MTGJkn5aN5wrkNOBg/0vw83lsW3gX5d8EZxn08m9/6d3pGt88ZZyTm86xuyKEie7r5gUs0sw0SvX+Tpj/umIgIIw7g5ytrBIhGTOKJWv83ODQs0Y/HRT
 S3FeZ/I3
 9agmnzuiNuhVE69lKOPalA4Pi71e6M/oXIyW80hOHbggpTRtFKHu4tCTFcBEiGivX7KEJdFGWCCkOnj9zbRveYLQWcPVNNLf2Q5fzxhwCCZaGgkK3MApMSHHxo5e8cZA6cX5SNlq00sncEAWEbxVW2gSWD5Xhvmtm7R3qYsKX27ay375m+EUFRhzD6vk0I1XWZM36eUg3bcDjs9mAcyXPn+HMpKIlw8Puhm9pOTNPsjf1S8CfxnSk/vA+n5aZ7fnqoIZUONmkH1vdkX1CJrrsbv0CiTHxbzeZeKqUDjwD9G16GNzxJL48SR2e/j2tGDuKrdSJdF5WNANnnDVonG2o9mjRk5c65pLR5j9yf88q7TZVrx9GgrsePVBAok2Nh3XklMR2Ha498cf5D48QGopa8GLAyhaVoiXoN5GX/WSonYvmlJqcLompgF+fdv1TdjaVx+zuzHlTi95VRpwKB6fmPRqLwmmE0CuanXvrv83t9gOyBwmR51zBQPASVQYhBH+izQWwYWE5mlnTBqr01H5JQS0ztJhNP6sWy1XoIT7g/tyZFFuPvh8YQuHB8cL/GodMIw4r40llnPT0aRpMvrwwnaYjjXjihsY8cYR4Azb5/PU9e7i1Css1ybo3mODi3NFmr4/05kuavVVhUPgyvYWM04P0nu1P7k7hTt+m/Wes8pbx/vUQCXv6pHZkfGn5FD8iiagA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 07:16:51PM +0800, Kairui Song wrote:
> On Fri, Oct 30, 2026 at 5:00 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Fri, Oct 30, 2026 at 02:31:42AM +0800, Kairui Song via B4 Relay wrote:
> > > From: Josef Bacik <josef@toxicpanda.com>
> > >
> > > Swap-ins from SWP_SYNCHRONOUS_IO devices such as zram are no longer
> > > counted in PSI memory pressure or in the swapin and thrashing delays of
> > > delay accounting.  Refaults of the workingset from zram, the main input
> > > to userspace OOM handlers like lmkd and systemd-oomd on zram systems,
> > > become invisible in /proc/pressure/memory.
> > >
> > > swap_read_folio() opens the accounting window with
> > > psi_memstall_enter() and delayacct_swapin_start() and, per its comment,
> > > means to count the submission time.  For synchronous devices the
> > > submission is the entire read: swap_bdev_submit_read() does
> > > submit_bio_wait() and completes the folio.  Since reads are batched in
> > > a swap_iocb, swap_read_folio() only queues the folio with
> > > swap_add_folio(), and the bio is submitted later by swap_read_submit()
> > > in the caller, e.g. swapin_sync(), after the window has been closed.
> > > By then the folio is uptodate and unlocked, so the fault does not wait
> > > on the folio lock either and the read time is not counted anywhere.
> > >
> > > Found by code inspection; not reproduced.
> > >
> > > Fix by submitting synchronous reads from within swap_read_folio(), as
> > > was done before the batching, rather than from the caller.  This gives
> > > up batching of readahead for synchronous devices, which do their I/O
> > > inline anyway, in exchange for keeping the accounting simple and in one
> > > place.
> > >
> > > Fixes: dda8fb68b590 ("mm/swap: also use struct swap_iocb for block I/O")
> > > Assisted-by: LLM
> > > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> >
> > Hm, this isn't a complete fix to the problem described. IO throttling
> > happens at submission time, so there can be significant delays on
> > async devices too that are no longer tracked since the culprit change.
> 
> Yeah you are right! Thanks for the heads up, not only a sync isssue
> indeed, async devices are affected too :(, throttled swap fault also
> went unaccounted.
> 
> > How about keeping the accounting window open across the batch? Opens
> > on first read, closes on submission. A batch with at least one
> > workingset folio is "contaminated" and the whole sequence and
> > submission becomes a stall. Would need to pull the !can_merge flush
> > out of the batch-add function to get the accounting window right but
> > that seems reasonable.
> 
> Won't this cause an amplified PSI reading if only one folio in a batch
> is workingset? Maybe not a big issue though.

Hm, I think the only option to avoid this would be to split the batch
and flush more frequently, which I'm not sure is worth it. The batch
size is only 32 folios...

diff --git a/mm/page_io.c b/mm/page_io.c
index 22e5ac1d298f..806cfe633a95 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -207,6 +207,8 @@ static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
 
 	if (ctx->sis != sis)
 		return false;
+	if (rw == READ && ctx->workingset != folio_test_workingset(folio))
+		return false;
 	return sis->ops->can_merge(folio, prev_folio, prev_folio_size, rw);
 }
 

