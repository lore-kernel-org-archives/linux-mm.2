Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F096CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 10:17:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A192F6B0088; Mon, 12 Oct 2026 06:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CA766B0095; Mon, 12 Oct 2026 06:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DFFD6B009D; Mon, 12 Oct 2026 06:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B9CA6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 06:17:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E8EC1140AA7
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:17:42 +0000 (UTC)
X-FDA: 85313572764.30.4854712
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 048A240002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:17:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=boUbEq7Q;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791800261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6W9w6FX63BCRNL5Y5+uTi7NjbH9MTl+NIN066JxPdjM=;
	b=pLoTxQxh8MiOi5ewlknRBfBQ4VFuzWUYoVaZHU/B7bH6yPstcXdFg3zkR1KzuhRF16ZoWJ
	3KwC4uEfwSz46+pOWaTggKisJmeueJXcbMcHjhBdlXqEHUHfgzj9wYZug3/zdZSOc4EXkt
	Tdu8P6J+KSfGW7DFovZsf77R9o664R4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791800261;
	b=uWKuFxg/5q1N/pGmU1EhKVY/AT5FiLvqLaljWcBxyTqap957KfdQE+6L4hs2tr4U397Hjy
	XD4ULsmlj56pcBEK60N3qqXVArKLF5ElZsaxd7UTTMfIpsrKnXhUTOHs1VsgLZCQnMZ7Jh
	kYTgFTnWb7zB0nDX8+nPjMY5ycRIjvo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=boUbEq7Q;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 90D51600E2;
	Mon, 12 Oct 2026 10:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31D61F0089B;
	Mon, 12 Oct 2026 10:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800260;
	bh=6W9w6FX63BCRNL5Y5+uTi7NjbH9MTl+NIN066JxPdjM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=boUbEq7QOkVayeZfV5djEa96a53ltXgA5Gs1RkcU/5Esvv4rZ+tT4ZLkwaSg+Olme
	 IHJvM2BbrwxBdLd52wt/QcFMqlrTRnBPv3hPGbsA6yPQ8oyF3dxacn7kgdWIgO2tpO
	 BK+8/qI4695zI5FCbwoeLJb3kE0o/NfshFONNz4j1LZrEHjTPM41qVFHeiKI1Dl8bF
	 54wXh5md4VEX0iGTFcXt6lwuqHjgRKyKjxv+NANIRvSthmS+Xe7I09U8kHdPIFi+h4
	 uZBGJ+ttbbK9PAK5HfWkZT+aDIXLVs1KEwXzXiP5AiFeOCj3H7ccsMXnDXybffFbpf
	 tMhCOTQeTUF6g==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 06FE7198003A;
	Mon, 12 Oct 2026 06:17:35 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 12 Oct 2026 06:17:38 -0400
X-ME-Sender: <xms:v7PMatf_AQlmyfcCnYGtsT8jhwo4YI7LI0b6fFcb7FoQw_GcDN4LkA>
    <xme:v7PMatk-W9HXB6o8X3sF3BmBp2ozWmWsyX21nujvlA3O04hjx6eIh2tXHTcvx1s77
    kp5vv-pQIO5t3SrJf3deKmxLMFdSBFjIzPg7BaZecCb5AQk4s8Rc8Ha>
X-ME-Received: <xmr:v7PMavy57zUWBm3JlOJpaqljUxpAic-HNXoW3BDmyUB7CFmsy6tC8xn0LsQ>
X-ME-Proxy-Cause: dmFkZTFtEePNEwvbObMFMgRHgPi1bvtoSd5qbrO694Kd+ogzCGFJMi0UGAD/xTvnHA50RE
    JCM/aLjoQB6DzJtDHwghLRXFYdBkvVdisA5BKYNM51m7QOeq/Kv2boQh/coCxEOLtiw8Io
    z3hAUsc1EkJsbOBWpNkKoT2mH3TL+rRQN3Jd7rwwgMesNQAsnBXWR75AuZ89wlgd1pnbKq
    uZxx3ckpzY/HsaWhu4ZNhfvqUzr/kYBIwAn462JE4fNBxYqHAOWaxSA+cD2dyHnjPtvtx8
    T5vucOnKnvh5HpjQD6xc21M7w/4HzHey4lTSRpPxrJn6fsxetQs6a2bKgHgm0ZgQoSZBWZ
    PxyHQ6YmVw30IQBY07qLhJH9r4FyHz6QXj/UOZq/YJHs9l+F/8lWNBt1W2dNie825IsZ2s
    axHRX0B07aM4zLNhwIOM0LVjTNPQr7jY3qhZFEcCe6Hn0VFxWTNJfYaMwyIvpbmKFu72NS
    IxuefQNcRYhgSaProoMZpaBjj3HGGqb2h/eRi+pY2+JkebFi7MMRN5PiK6PoBIA5fxh/Kg
    I6s/xPssIUddqdP9drO7UP2Y9GJOELwEQrXKwVVrAj3HQbx0XCIx7AiX8CStCc+hffmOLA
    rpq1XFKxuvTkBBHb+ytkWreawLUndqwHAr8udpIY6AGNK/yrEsibS6ildKqQ
X-ME-Proxy: <xmx:v7PMaqFDO-D2O46EQrLF2VBylvKOPRY-GbsoNPM5wkdqJ2B3U5KiKQ>
    <xmx:v7PMasF63e87WHczEMM4h8hFe0oTqkOmYztVxDH3VerISTWXVoe1Yw>
    <xmx:v7PMatDZR9O7FDT6A35YiP8MOIAEzKLlUhkMTdKhW85Ybh4onoRc1A>
    <xmx:v7PMar8zp_Q4SBTIMtDI67x3lhTN6r_SPWd0NOJIoJayIISwp0FDvg>
    <xmx:v7PMavfklJSyUMscVdZovkqpOlEaaxkfuJ5sz8dIIEk7zjCBEELyOfLS>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 12 Oct 2026 06:17:34 -0400 (EDT)
Date: Mon, 12 Oct 2026 11:17:34 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v3] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Message-ID: <asyzhoDeI3U4T9wZ@thinkstation>
References: <20261009125503.126202-1-kas@kernel.org>
 <20261010154923.998e04e42093ffe6c7c205ee@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010154923.998e04e42093ffe6c7c205ee@linux-foundation.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 048A240002
X-Rspam-User: 
X-Stat-Signature: rr15ckfap3ajk3kcyime7nziudqy5rf7
X-HE-Tag: 1791800260-770888
X-HE-Meta: U2FsdGVkX19RW/Z5JUUvBFtCNXmksD5ZKtRkvT5HED8PnW6FZP3rXNQhkaQuIOD/8iCM5rOQSMRpZ2OOY16BhxRjTvNVxOCqPpjXfvlwjpixDmZHnvl4Brw7aH7YmmZP6ROHjQgr9P0xlEpETcsPNjh4X62/xxRkI5qaPUimRL0f0vX5M8yxOoXS2f3/cZkXbfQOkex+ILEsdnrc3QZ1reZ2v1CTi7MoNr1PpyuXtzP0ljChYhMGmXkfpCb6zK1LFVmvLU4U4qrX1HF2PsYtSGNRZnqaqeFts4ukRijvkqtPRmpV9N7OptDI7p8M6C6zdh8G0aWUsuinTco/+hp9VuvVo9Fn+Or3JI2yPhe6TgNZLwiQ9iYfhiK3YicJHlxMD5LbTdD3MO7bp0RK3vmkf/pagfVZ+qrNo23YHbtD6uPc8HIcPfbRgWrtnOp/jwvJ5CBQ96/AX5o5QeQJ/2pukFOMyOnt69/zgNBiOxr+djb4gzVa7ObaRtshDXet0nM5XS3ZcVvMnlSPHnZQTH0TpWVc7NBnwlsMSd9aFEEBplYVxtxyrHRRFq1g8+QIfcMWbHdrWnsiQBQUpEVzl5uwuRYw+juvKPGYEPstd5GErNRRqrx8gKS2gNDvbHtF6uxQlzFrRFX7tRExOZXxhfqc07JIhbBTPGvrMurb3Sk8vKOjtVsdc8IN0y9dEUi7E+G7K8jm7cZ4RkjOcs60gGbq0Y0TJoyTrCTihUFqDCHiowLjlih7pMSj3QTxH1A7Ags/Wv/F7Ssr4ESwMcejZ5WtIFVownZIwV7Va17vE7y+daEftIYNbQgHnByIHUbbQajqoVjzagcNTAEJhyhnZ/m1kKiXynXZZo0v8SuzmHrDwOpqHcJ+7qny6deu5SpvlMGcG09A22GiDPByNzksOn13RyptnxSzQmOuo27X4cyFml4lT+RhDm6WAAhaMrsQua3+mqNbJtj/Zh+gef8/QoT
 IhwaSpM4
 DxCtoKqToR+xJeN5hox4LDttNRmuPzQkbQ3mvyIMAJuA65EdPLvMI7NJpWxyensXCHdYZ809giduoLa4fiYjvtwmSMCpYwDSa6IKSeH9GY4DDiflw+iQAhOks20Rlf9ZFn9SnnvKCUYchCFnwOvb+SMhtfQQlFLMIywV5JfH8+b3sE2lhryZqtcsVckXg/UpnFS2i6XsnsixjI7jtJ3OsAJ/4ZKCtqhiAtD54k46aigh1cq54TYAR+rZZR3CwRF1UUOjVTEgSJLjJGlglRCce0VPvwDG2/R6hFG968J2Bw8vy7gLVGPfl2RMWLZKkYCAJDWXdvQDuiiFr2g8ORR1df9RpI2/DHTp07GSfX4HrH1ZXxqiE4tPIawZDux5EhUq7vOO/20/lGW484kUkv2/11bfWyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 10, 2026 at 03:49:23PM -0700, Andrew Morton wrote:
> On Fri,  9 Oct 2026 13:55:02 +0100 "Kiryl Shutsemau (Meta)" <kas@kernel.org> wrote:
> 
> > Since commit 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim
> > storm in defrag_mode"), direct reclaim and compaction for non-movable
> > requests under defrag_mode run at pageblock_order, to produce the whole
> > blocks that ALLOC_NOFRAGMENT needs. The retry decisions that follow
> > still use the request order. An order-0 request can therefore retry
> > indefinitely without ever reaching the ALLOC_NOFRAGMENT fallback:
> > 
> > ...
> > 
> > When a promoted request takes the fallback, reset the retry counters,
> > so that the fallback attempt gets a full retry budget before the OOM
> > killer is considered. A request whose reclaim was not promoted spent
> > its budget on the request itself and keeps its counters, as Usama Arif
> > pointed out.
> 
> Thanks, I updated mm-unstable to this version.
> 
> > v3:
> >  - reset the retry counters at the fallback only for requests whose
> >    reclaim was promoted; a movable request already spent its budget on
> >    itself (Usama Arif)
> 
> hannes's concerns/questions at
> https://lore.kernel.org/20261006081050.GA234057@cmpxchg.org weren't
> fully addressed?  I'll add a note and await followup.

Hm. I believe they were addressed. v2 changes are based on Harry's and
Johannes feedback.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

