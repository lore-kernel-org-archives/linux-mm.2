Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8099D10F92E0
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 16:44:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E71096B0095; Tue, 31 Mar 2026 12:44:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E48826B0096; Tue, 31 Mar 2026 12:44:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5E5B6B0098; Tue, 31 Mar 2026 12:44:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C458D6B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:44:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B2ED1B6E98
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:44:35 +0000 (UTC)
X-FDA: 84606931710.09.2834B71
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id A9DF240009
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:44:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XQIfmewb;
	spf=pass (imf12.hostedemail.com: domain of rientjes@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774975473; a=rsa-sha256;
	cv=none;
	b=4WE/irwnLcciZJXuqpqTtmG5qWHGQdU7YGrv+UogDmpnkOTpjzcoMKZrukc7NshH2RpuEC
	UKYTNnnPQGn/0u2OQpZBp/OKYZh/8Vn85AbPjtsDXgkgBHUNkpPOvLEU8DreEZNP+m6CvR
	scnfx7A7zsrl78wG5HJjFRtRqWNdo+w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774975473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P9H7DtjUvqhXDyY5pBkhMdsDwbb7SsdQitFkTuKYIC0=;
	b=17i/4cpoBawNyWBbEeh1uTpm9sTc+PqTymLsARtdKjtyE7enV0xoeZbq2NZ4B02US6vQHD
	r6XGYxWD9rMapeZ/1NSprgweF7bpErFJOXjy2hZBzsVaI2xnPnrl2s9yBJG+tkvEgizwa2
	1s+We1fh1OckKCBRMjq6PP7Xs+B8+nI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XQIfmewb;
	spf=pass (imf12.hostedemail.com: domain of rientjes@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2b243198058so94665ad.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774975472; x=1775580272; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P9H7DtjUvqhXDyY5pBkhMdsDwbb7SsdQitFkTuKYIC0=;
        b=XQIfmewb2tFK8rmvtQNEL3jEWZo6E34QSoQ0WnKw6syFINyAHzu5QGc3fUP28J7+hF
         YMzKAxwYOGl/WCHzHEK5AJpvBygz91Q9bRX7yaHM2GTeLHiVeqhIAg1ohpeSSfXPkmd/
         FD0zB3JhR1wrglqrAkCoxw/Bnft/ZG42/6N+TFlk5Ll+TRFKxaVWtUbQBTP/OmiR2iIg
         K7RiwOJ2dm0uN/B48ue0ugbu2cghbZbdbO+OeIBLpqRHKLOKLbUlRUH9TpYM/T0yBCJr
         yF4GGqxswNr2uo1LuXgX/HR1r78vUVjMz0EswRIQfgvqL03iLTQkuotVOmx5yIsJK4D0
         hVBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774975472; x=1775580272;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P9H7DtjUvqhXDyY5pBkhMdsDwbb7SsdQitFkTuKYIC0=;
        b=kPTRnItlU6jt4KgxuVEm//mVo+ICb1oMDBcl/Z8hwfpJx24F6Zl+a0OyPYD3RlxVHo
         DSWoLQusg+22Z5mbvYwdPBXRyJeWV+S5Hf3nwqOlJvoKgDuS1Gb1Bh/rWDpX9MN0BmMn
         iG/zvj4ZvPL+ZWdprJ/irTZ+5ZfwF37HQIAUKemiMYbVbnNnO97t7gqYUm3Es2P5VaCc
         Z1n+yGhgwAFdX43x0fpf3tzAo/AmDk2A2CONT+jumQzK2DlmNXfZ1rFbhKcY1FpLWusT
         fXYe3iFmpXLpotxJa5ba0e5CBAfHO/gooib4B7Eif6IYH+6RjBbCyA4IWXa4uwqMoh1E
         sOpg==
X-Forwarded-Encrypted: i=1; AJvYcCVAPuItVn5PYZaIGRIEic6OwP75+5scZ2wDwUY/hFbgBpMIwF8AehoqswMmtza8nFGVCrJA308y4Q==@kvack.org
X-Gm-Message-State: AOJu0YyflhsrStGF5lTtH5mlyI3L/E9BlXfpQjoF8DkS6Sfojt3zoOgy
	v2DfuS0s4nWByr5ny2Nfykp/abq1kGnpJRJ2zC8w3I28RPKTyYNsHn1ANbZgZk8x9w==
X-Gm-Gg: ATEYQzxwDhsBUqMV+l1I68GHm210Uq83+pRsi6zeTQkSSxpObOAkGEz4tS11o54/ADz
	RTwbyKE8YFm1EgoeY76ZA0oD3fSUihaalTAIwUsHpjTt7uApjyyXQUha4eR5I2zU8iXhw4r3kj/
	RWGx+WuGrml27N1CDB3/+yLJiBY3K+Yue9J3dKfBDqt0dw/472ibcv/ZFyOsivSY7XLIr/wXeO3
	ZDZ1MvlqjEaE3D2VTvU7/T59beavyHF44VBwWuaa6eUlC8Xmibpqux+PLELPieHwJZH15rNwZFd
	hGeHzdYUPthNVN2a8svuql4p2geeH6aESvSYjZB0ZwzwEZUDJ3w6ksGNDAvuFKopWMyQK/1luD0
	+5P8E3dQx0kJVQ3SnmH1OGpvNbXlVIxzFNS6i/CxHrp+90ZY+j89bbkTATtXaFGlXiBSBxOQUTP
	lzQZAB2TRKnRD+2sIt+UMSreIe/M6xIGhKptecimxxiI5k/eMLWDRcVL7QQMN8VT96/J6v+DeU1
	TBlEHTjwCtK1LQK6rM6YNQ91oIn6duGePn3Y15L6Gq0GaBMGVdp2w==
X-Received: by 2002:a17:902:ebc6:b0:2a7:87c2:fcde with SMTP id d9443c01a7336-2b268f14089mr297505ad.15.1774975471796;
        Tue, 31 Mar 2026 09:44:31 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:7c3f:a173:3e15:575a] ([2a00:79e0:2eb0:8:7c3f:a173:3e15:575a])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76917bacc2sm9459387a12.26.2026.03.31.09.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 09:44:31 -0700 (PDT)
Date: Tue, 31 Mar 2026 09:44:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
    Brendan Jackman <jackmanb@google.com>, 
    Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
    Petr Mladek <pmladek@suse.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [patch v3] mm, page_alloc: reintroduce page allocation stall
 warning
In-Reply-To: <69cb3957.5d0a0220.93499.af4cSMTPIN_ADDED_BROKEN@mx.google.com>
Message-ID: <a65dc09d-f181-adc8-59d5-838b6a2b7c9e@google.com>
References: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com> <231154f8-a3c3-229a-31a7-f91ab8ec1773@google.com> <58a10940-e44c-a120-dd6e-ee9f480c4946@google.com> <371c86c8-1d47-bd70-b74c-769842718b1f@google.com>
 <69cb3957.5d0a0220.93499.af4cSMTPIN_ADDED_BROKEN@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A9DF240009
X-Stat-Signature: tuaot43stii3bgs7dqce9m6hrjq7hasf
X-HE-Tag: 1774975473-680375
X-HE-Meta: U2FsdGVkX19m48wxDiVbKk+LxLshBU/CFH7mej42GM6csfqcqEQd3YKYixhS13r1bhTKxcWd7quEbR/d0Q1neNt0IfVloZ9RghkmMBmK9uYQVqlL0Deo9CF+aTwIjIXO6Qnt23vZe2X6z4tXkVOpmnSzOjQGa+VtWxqU32oLQ/vUBqsP7RWapCRZiHhrkbYrd936wWx9W0hAgKvtaxuzN15gm6K+NrOGAMr4RmcSXTEE6QKRt8EJiDzUCxyxCBCK6zOwKlamn856QCZlDgIk0t06V9tJvIkBzoebFdqyZ0Al+RWkSTSvYYnAnk8vLxtDHVDI1egP5qaYE40MTkziWyCn21LkpaJM5xgCLpnLV3vqyq+xBitXMARKb/uh6bKwHm+iBa0A5k25xu+srUcIe7zi9yS/i5KUahs4yraRUwL/F+8FevQbEeUAWHCORUYlJi4dRIacrwsORabpF7w5ALwXeRu7KDVmhbvJ8qN42m2RjtQULgT/iJf2wXZ9DGh5UXJkAxmOVV0M/2HKZKOSWJDtn6ROZa26HfqfFXW4TwXWwW5xhHYAEYuDfNAbHDB0ZbxxTFA4llU8VF8KiGzE1JcCFPETZOUsTZm8BBYCNxtI5HCYw3dNhVI7Zr4TIVnrdxBywFfamP02/70FwVPHauXLiLQAth8bMqDrknaforMC8Iyigk+2LuZ+xblhdrf+DpvKVd46aREfZyy30dsMs0ULQhwTTQjL6C4SfIGjw/h+rDSS/V6EiWsEItPFFneDSNy0jSZg7d0s6bkgujuSWK7XsaGorog0SXZFEt8R2EuMfylVCuttkJb22uPm79ujaqLf8SoeNNKG8VnGzFsccQzDVw1p630Y0rZyZLlp2R2c5h4qWi8FMTKl/iyhB5l6MlFRdYpKky4lVfJBjjGt0HhBxBtub8yi9I6/v+QtPjVMOCeWmaXPnRRn6bZ479K+vUQNcG4EJgs3a/Gxs+5
 lAymWHjo
 Z80Ei76FkvTtPnqX0Z1q45FBM6sptfxGrlhX/iFefiiNNcUiPcY/BiBVn6QSek4CZkkwtM8Jg/L6GT2uYSjJmuijH27pm9aZOHpAt2cQAg1CjTYBZNlWaaDC26yx9PGmX1cgkoE/f+XkGU6v1bzMlx22FgfFrNrqzrzg9OF6Ba2eeAM0/MRu1U4w2o6dtBYlt3AqzbynlEtRr5tnfK1gQoOmgi1x/XclLI6tcBWU+ZzACeHzqp4o/PIy6pD7mJ85PbpcQ3zfuaKltqGFhn53l21wmLdKtSQU1x9t94X4O3nMa1i2VRFs9f728RzPO5OY+ig/GZtPD9T5xmtLPWalLmcTCmxYZYbfACsF8W52bs+MrShO6e3k5WsHPte5yg1avJl9VRTh19g/ouBDtRlqby/ia47prnXtQbtlWRZ8KpkYvag8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026, Shakeel Butt wrote:

> > Previously, we had warnings when a single page allocation took longer
> > than reasonably expected.  This was introduced in commit 63f53dea0c98
> > ("mm: warn about allocations which stall for too long").
> > 
> > The warning was subsequently reverted in commit 400e22499dd9 ("mm: don't
> > warn about allocations which stall for too long") because it was possible
> > to generate memory pressure that would effectively stall further progress
> > through printk execution.
> > 
> > Page allocation stalls in excess of 10 seconds are always useful to debug
> > because they can result in severe userspace unresponsiveness.  Adding
> > this artifact can be used to correlate with userspace going out to lunch
> > and to understand the state of memory at the time.
> > 
> > There should be a reasonable expectation that this warning will never
> > trigger given it is very passive, it will only be emitted when a page
> > allocation takes longer than 10 seconds.  If it does trigger, this
> > reveals an issue that should be fixed: a single page allocation should
> > never loop for more than 10 seconds without oom killing to make memory
> > available.
> > 
> > Unlike the original implementation, this implementation only reports
> > stalls once for the system every 10 seconds.  Otherwise, many concurrent
> > reclaimers could spam the kernel log unnecessarily.  Stalls are only
> > reported when calling into direct reclaim.
> > 
> > Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > Signed-off-by: David Rientjes <rientjes@google.com>
> 
> Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> I am hoping that the reason you are reintroducing these warnings is
> because you already are seeing such cases in your production
> environment. Do you have anything interesting to share?
> 

We don't have this patch in our production environment (yet).  We've 
been stress testing allocations for page faults with lots of concurrent 
skb allocations that can keep us persistently below the per-zone min 
watermarks and hope that this patch will shed some light on some 
unresponsiveness issues that we've encountered if/when it happens.

