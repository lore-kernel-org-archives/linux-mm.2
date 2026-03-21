Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFF6B1099B5E
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 02:16:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADB486B00AC; Fri, 20 Mar 2026 22:16:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8C006B00AD; Fri, 20 Mar 2026 22:16:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A1CB6B00AE; Fri, 20 Mar 2026 22:16:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 84C386B00AC
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:16:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1DBDE8B81D
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:16:38 +0000 (UTC)
X-FDA: 84568456476.07.C0A4178
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 58EF4C0004
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:16:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mxBE6pmU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774059396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oiBIMq9gYJFzdtwi8RvRcqQkdIk4KNbFnd7YVc9hjwg=;
	b=TVWO0RdRarcvuv/BMiXWkoqg080tHOSrCE4R30Fy3702ZNaGE92bupckmS7lIucy3tZuFt
	7JERwJFkx4ib2biCoBUXwAhxq43ahf6x1E0QMo8NmtGLxTyI9F0l4Z/QjFIUT6CM4iNN6x
	ukkQIFX7d8YEA4EdW3B2hMA3u/0DCPs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774059396; a=rsa-sha256;
	cv=none;
	b=6/AaDdb+ahb3Ka4nFktuZNGL1nLd/NTTXQorWCtWQUtNsw1ZeREpSiDi9+tMZ9uLWCurP2
	3ITxsIR6oo9vnpAWD8pXpkN0Iw/7GXfRVOuIOWtQl874+sVHvDshj0PkUZkSktZGWmZtei
	syrBl/78Q4LTdXfvf+EIv3NrqirzZp8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mxBE6pmU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4296A40993;
	Sat, 21 Mar 2026 02:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EAAC4CEF7;
	Sat, 21 Mar 2026 02:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774059395;
	bh=dSExaxgt6R5ldvLDLyR5uIt0k34SJYEnW9Izck2/aUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxBE6pmUjzBw8X/vSAoaJgCPYiZsiY77HLBcz2e5ZMAnr5PMmO14Kb26I8ltmiFXI
	 m/5vtkkMyHe40rMQil8dcWgyZd36DinyeXcQBOTLG0IIwaMlxnkjP+jl0c0augEF7p
	 vPa2navhz8nyfwi0F+tVv3SPzSdRwFJa4xNzfznc0AK7Biow3gcUWqB1Dyr/q6DrAA
	 I8aqDkvAh6qy0Tdddqj9vv++PSsjvSuwN6aEgG5hyTSNH+vE2jwUAWJ8qhli9cvpEr
	 UJQg5uluHHcN5qtwdb024EQYO0IZ9wFCEcLWqgGhBEAVGfujIPgd92mMySLKRETW96
	 1qOzRTkwV2rGg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 15 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/core: avoid use of half-online-committed context
Date: Fri, 20 Mar 2026 19:16:27 -0700
Message-ID: <20260321021628.78887-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319194849.64b0911e2a7a6d8b1c22005a@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 58EF4C0004
X-Stat-Signature: d8aomica3yfm1r641p3fzbfp3a3gitkr
X-Rspam-User: 
X-HE-Tag: 1774059396-45653
X-HE-Meta: U2FsdGVkX1/SlVZs27dYsMaB94IzWVQWay65nKc2VJoLiGGib+UTgznU4wTHMWBCqzKTlSgyVadw2G4qbBt8qNRQmgiJzDnirse79zntUVuwnPYnzEpocKztj53gummI16Gb6y1hT2ETEQ52LvbBzVhmQCPWrapgMT3HmegON435/EbuuZ8hNHXU4EKNYlsSGmDJ4aIjA0clVKCxv9FMjfMOnzhVtwKkUsSSUjkTlCEDZLjapbiuE5Qv17mGmRpnp5dZHYxi2zFnavqoetsAOsVgwhiz4DWE+9CMvhDxFS/HELZnJA2zVHSP6yJBgNMB3tDCwujDcpTVywWot2ZdYVScwbeneDT9be8jS/mOV6z7rhwOt/tiBk7azRQHjdTnan34/7bEbSe6VLzTRBhmYtE1zUL2IJGSqAK5rI/EKQvTgjX/wWnpX089TNnmlGRZjI+BytL1aheo7qmrElpPRSsi9XhxC8ikErbiXXUEAsXDPZASlZ2aeCcUOIvzTd5dDVaLPLMYu8d6CjiiCcepRhTJGQRzq/PSQWQE17RmWLN5WD7oOQPxHeiVEnkDzadCVMHvS/IgJ9EFX4ex9q3cJv8zmnJxcBEsBbcAhp/xM0p2GkjmBEzECtA7i6V8jO6InkpJh4xGlh/5LYWmhMSKxAVH5VH2wVxL2Nc9zhkBT6UlwI1NKfvFcJUZr7RypnUd0xhvIREvBBZcHuXZG91Ah1KTO7Gut5B0w0/RXUwd9l2C11fDikx+F/BCC/Kaa86o4c0i9Tnwpw0KfgpQ3TcqTk1NoDJ5TCotqeYbz/Dij1bggot14MHNm5DGgz6vm5kLFNhOxZAIGa05w7NMG3wV8hZdZ+yq7EQJXSmGrAxYiP06rmKvjxSyssGsu1DHcD59e32wDEMUQcUfzg5oAMwM4vI5chUCrsAl9NW23iSTIZ88doeI/SGYGHRqbGB8fGZmpokRaOPyanQApMX2HkA
 ONhPJgFM
 5X5j0C2DhDku0T5eeQMVwDdPaDqxQ8rGcR5hLAig/h1F2+HxVVYgjKjvp/BLx4Qw+rSoDcg2SEbAhnpfVdvPNR/1toCu0dnjLLuwM3F9dnmFO/H1clogaQSqWYI3JbNUICzLHoVOMDf5f0eGBt7W4TLY0pkVIOpMDx5U3Yf4oOAlmHlzSFAKy4SbSDxFNORk5tBOyVzWiZwe0voRJprFFbSMAfOc9pfbzcBWwUFPlQY5dwBCwber1NPTuJpj6OC6nJj8m5cahem/t19M/+lTssCvbVCRW6hci9uPG5lY3dvG8KgHyNWYB9HBPxR+KWNmzuBbA5EcMczjh1dy9NGrh1b/eisYNpt7o/3K2ByZ02S3Ltuy3DsmbRslOdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 19:48:49 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 19 Mar 2026 07:52:17 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > One major usage of damon_call() is online DAMON parameters update.  It
> > is done by calling damon_commit_ctx() inside the damon_call() callback
> > function.  damon_commit_ctx() can fail for two reasons: 1) invalid
> > parameters and 2) internal memory allocation failures.  In case of
> > failures, the damon_ctx that attempted to be updated (commit
> > destination) can be partially updated (or, corrupted from a
> > perspective), and therefore shouldn't be used anymore.  The function
> > only ensures the damon_ctx object can safely deallocated using
> > damon_destroy_ctx().
> > 
> > The API callers are, however, calling damon_commit_ctx() only after
> > asserting the parameters are valid, to avoid damon_commit_ctx() fails
> > due to invalid input parameters.  But it can still theoretically fail if
> > the internal memory allocation fails.  In the case, DAMON may run with
> > the partially updated damon_ctx.  This can result in unexpected
> > behaviors including even NULL pointer dereference in case of
> > damos_commit_dests() failure [1].  Such allocation failure is arguably
> > too small to fail, so the real world impact would be rare.  But, given
> > the bad consequence, this needs to be fixed.
> > 
> > Avoid such partially-committed (maybe-corrupted) damon_ctx use by saving
> > the damon_commit_ctx() failure on the damon_ctx object.  For this,
> > introduce damon_ctx->maybe_corrupted field.  damon_commit_ctx() sets it
> > when it is failed.  kdamond_call() checks if the field is set after each
> > damon_call_control->fn() is executed.  If it is set, ignore remaining
> > callback requests and return.  All kdamond_call() callers including
> > kdamond_fn() also check the maybe_corrupted field right after
> > kdamond_call() invocations.  If the field is set, break the
> > kdamond_fn() main loop so that DAMON sill doesn't use the context that
> > might be corrupted.
> 
> I guess you saw the AI review?
> 	https://sashiko.dev/#/patchset/20260319145218.86197-1-sj%40kernel.org

By the way, I am also doing monitoring of sashiko.dev for all DAMON patches.
It will be much easier once sashiko.dev's email feature is ready, since I
already onboarded DAMON for that.

Meanwhile, the monitoring using web browser is somewhat tedious for me, so I
just implemented an hkml feature, namely
'hkml patch sashiko_dev --thread_status'.  It receives a message id of a mail,
and prints the review status/result of all patches of the thread.

E.g.,

    $ hkml patch sashiko_dev --thread_status 20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com
    - [PATCH RFC v2 1/7] mm: memory_failure: Clarify the MF_DELAYED definition
      - Reviewed (Review completed successfully.)
    - [PATCH RFC v2 2/7] mm: memory_failure: Allow truncate_error_folio to return MF_DELAYED
      - Reviewed (Review completed successfully.)
    - [PATCH RFC v2 3/7] mm: shmem: Update shmem handler to the MF_DELAYED definition
      - Reviewed (Review completed successfully.)
    - [PATCH RFC v2 4/7] mm: memory_failure: Generalize extra_pins handling to all MF_DELAYED cases
      - Pending (None)
    - [PATCH RFC v2 4/7] mm: memory_failure: Generalize extra_pins handling to all MF_DELAYED cases
      - Reviewed (Review completed successfully.)
    - [PATCH RFC v2 5/7] mm: selftests: Add shmem memory failure test
      - Reviewed (Review completed successfully.)
    - [PATCH RFC v2 6/7] KVM: selftests: Add memory failure tests in guest_memfd_test
      - Reviewed (Review completed successfully.)
    - [PATCH RFC v2 7/7] KVM: selftests: Test guest_memfd behavior with respect to stage 2 page tables
      - Reviewed (Review completed successfully.)

I'm planning to implement another feature for formatting and sending the review
result and inline comments as emails, probably this weekend.


Thanks,
SJ

