Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BB1FCC6B30
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 02:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1CFC6B0088; Wed, 14 Oct 2026 22:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCE1E6B008A; Wed, 14 Oct 2026 22:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBD8A6B008C; Wed, 14 Oct 2026 22:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD4986B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 22:53:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 34FD9C08E0
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:53:48 +0000 (UTC)
X-FDA: 85323340536.13.4B1FF21
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7B9AD160005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:53:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FyGbRDa1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of skunkolee@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=skunkolee@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792032826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gZigGVShNXb8M9xxdtd/aausWvbyL1B/6pZf5rZeo2w=;
	b=HZiVygg0rW47lfpo1Gr/GwS5f7sJWGKG4w6OTr2sytYMYTtkquthE2gVTG79c41jbC6RJ5
	wgrZ7l676VaFjdkwhnF3U29Hmwp6iVELG1EyLsk/W9Oth/BnzQNHC2wDb2nVlLkraMFoU8
	dxgqdeIOlT527RBtcMMVWGITyQKRx38=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FyGbRDa1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of skunkolee@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=skunkolee@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792032826;
	b=U4JBDHuepgJM+Eovsw87c6M8Gvn0I2aJal8vC99pXeI/pE+zLKKyWPXe60BfCuZyqc6cJP
	lkhJoPd4RTz+b4/lx2EWnpEIuwl8qptx7Z2R1PyOt59MwTPzQMJz5fmafQlqXu5pEnseR1
	0YS7Ct1HnTiD50zkp7Zt7zDiPnnUBdc=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-89e82ee5669so46255b3a.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792032825; x=1792637625; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gZigGVShNXb8M9xxdtd/aausWvbyL1B/6pZf5rZeo2w=;
        b=FyGbRDa1KFC8lYJmjwv7OtN3KnB7ojy5k3fRIdF5QkLnU0vrej/mb8f/oLk/piTNY+
         KQEUvLZ4UfY+4COIyg1tx8zSi3t1yEsSS6c+S+ZGxyH2yDI35SK3ffWnwWhFfeSCO0o7
         yUXXBu1FwqZ0oDzq5YhdUKpYH6F8A8k4SFymsUBn6yIWhEUM3drAkU4XzgorCRWcipbN
         4NuPWQvRtiJ7WHmR53FxeeAlci04QPpUe92e7e8SAaIYv41fQg3vzysr2knlIMr/yZ2J
         k70P2B2Gi/XeoOgQsWwhLF4wL6Hxg+6pa7GnSyBiIvkOFLPSnvC6MfZSJhJ8Ly6ZGDFr
         HZkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792032825; x=1792637625;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gZigGVShNXb8M9xxdtd/aausWvbyL1B/6pZf5rZeo2w=;
        b=aiPq2lwZGNrs5ugTk7FWcS2opFugTv1ThD/IWNaYyptgKUaQgWkz1EmZFAdKf//Fs+
         aoBzcNV7brsayGssdoflqcnza00rwLH0HSybizO0ORjAQ9C5Bk/8p1ttHxX2NPoIRkbb
         HWu1akx2SYA5U9JnBsDLu6O8wsbRavxHJBbSSR8uE1pBQi1jab/7jr9/lLKralH8dYzN
         ODyJXaugH1kD98AU9SBSZCUPc5uUvovYZEYpUg+sj0fag6ZnWxrLMccOWAPXcCh8DU4+
         CJUGPwK0hwpxr/jIBKRfomeyJ8r3DWN+v2Tnf88dIruF5fhRcl2AkG9XwYrojfkFfwBH
         lvEg==
X-Forwarded-Encrypted: i=1; AKwUvByRCfQQ2WzJBR2vQdFJeYgXqUDeX+4bwMAQ2iGMp7Y0e0CsKZ4tJ5VUbFSABmgA4ssLF0HxgDivGw==@kvack.org
X-Gm-Message-State: AFq9FYInnGW84DyVcAiRqsg1DXZ9WGPDYtyxaE+jX+Sugk5wHc/ILZGr
	stjRn+nX0awu2vyzf8J/809U5762hw08eB0BwumlHx/qQ1caBioBtOjD
X-Gm-Gg: AYBFou34YdUcnAxRI0hytV29HZxE3P+/dRI345Oz/bFUCCnceQmcHxW7slW4vcdEg0L
	Ywt/6B5XXpi3NFcOe3Fsg81PWZx+fbT5OBI5xSZqAlz5iXuioMfGBRgiE0IrnzkK8B6mHbEHGv/
	UvBzzIJ4jjfPsHac2oati0vM8iK9IdJTbNuGV3nm/1GvOuxC7fKpNwVfgzN3Budy5FvVQbLqbvB
	pd+Glbx7S4Ck8iiaeTTTbudAMjxtvJjoh4tjUeLAFvFGLZUZIY3eC6tGbhLjagwqx1Z1Db63FPs
	MiozJR4ELmGaKSTohuu7n2d+zOIVQhp29HAHPT/FVYkGHpGlHi9DrvEtGD2V9kIFYF4xBvWu+xw
	SsRsh7MT9GCzw4TOqmLAE64jZ5zH5OL3rBsdot62CuYgOpNE3cPcc8dOp9obnxlhvOHfF0agUGW
	dxM4pdN2B2igXAmj3Xv2TPYUVjFGihUmmm1gQMvzQrH9QQefF/6NlMJcF1Vx1k7EZ4fo//UR/bX
	tgtD52eN7TwLcefpaeclGC+EyoNNs0HCpTVdFditoFtanZ0hg25wvy40bRtKt8=
X-Received: by 2002:a05:6a00:148b:b0:886:5f48:3fca with SMTP id d2e1a72fcca58-897c76e308bmr15340019b3a.37.1792032825083;
        Wed, 14 Oct 2026 19:53:45 -0700 (PDT)
Received: from bloom.localdomain ([2604:3d09:178e:e100::a891])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89d802d10besm1706735b3a.28.2026.10.14.19.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 19:53:44 -0700 (PDT)
From: Ivy Lopez <skunkolee@gmail.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	fvdl@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ivy Lopez <skunkolee@gmail.com>
Subject: [PATCH v2 0/2] mm/cma: fix range selection in cma_declare_contiguous_multi()
Date: Wed, 14 Oct 2026 20:53:39 -0600
Message-ID: <cover.1792032699.git.skunkolee@gmail.com>
X-Mailer: git-send-email 2.56.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e4s6xz584njw99fuwegkygher8bstap9
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B9AD160005
X-Rspamd-Server: rspam08
X-HE-Tag: 1792032826-737402
X-HE-Meta: U2FsdGVkX1/n37/qf08rOQu+Mo2F7Skjtl9Cq/omPazYq7+t7b0UOxKM9R9R7KlJ6bjJ7FJCvVZAL4Si1pA6v37XzACly8nMNmcPzafNHMCK1833S1sbgwUom0ELNVaMmmNIs4XsjzSrc/WK7D4llrIvp4UfGjIbKdoDMcHR+gJ5j/eqAUuClpUsHrsn5YCQQmVW/MkWs3XeDSoIGSljllD88WckLX8ivpu/om/FQCGV2pIwUfiRrIo9tGe5SvcQ2plrSCWT70bLtxPNbtDsoVLO0Cfs0tvVruS/NLCayfJz7fD+leeOisy8Sg5D6R0KlKuq87shPQB2pz6H+Y0deNSuGNCbC2F290gMJTZ0/gcbsJn17QnaLxbb0WDKvzuTHXdXtb+jda4KxW3cxIAbc/tTew1yrAWbtLYtLvP91BQWwXnEbod+T9LKo6XIaKeT/MF1UIlSavs1eyQ8epg5RU1hSfEKhuYbWIIdoTGNVLg/XT/FJrW++UkJQndvdxhJB/ZoMWMs2CMn9FyJqZnoITU2QgE7xr8PNPySTke0UStUMbFqk7p+I4YxABr7h4ikRK4Tm+n3DF7snp5keY3tI21JcKj6d3c74HyKFIsXqnMA8p8sCQvjwd4Ys7G4r4IWu4B+KBHlkstVzxksP2LM5n9dIrt5juG0L4B5WUgU173K4+sppx/gJoHt5KhGnVgIKllp9ntKRv6xnc4jXhHyJx6o6B0FPKOE0uOrMCQG6CxtqIoFTc8SxtPgjCrDnA//BaM1nmr6TUH7rhjGksXUT+KDp0uMaP4vaCpvSuCmNTOn8pFG33jSyslbNTUTKTr2Vwf9nfXowqsJ4lsa3wfFzuKFRdA3njZ9v2yonSnbx28T/vp48N5nvSKi1XNjnZ0Ry65MifszmYsSX1SJVNlP5J6Et7N6QfumhXL14l/uY55sX6kuvhHiEI89YwdL2WIVxw1LdA2n09GAFnIpFQF
 CBBwGtp2
 aXGU5QQpf7n/fN0jExE5iNu3mdgoYnMlieWcICiWzAsVfUprFPlmUBwP984BfhCLUsD+5Pbfu+PG+p8rV/Kiv9fmG7LeuqAGpSYmYt5X7ncp9rz0LH7q3Rmo57qx4Q0iuwhafaI2GOJ+UCAObHEfa/6erRIUZcQRtJAw9HRS3W9vAsUEhyTR99oyRZXBRQ5C2VAIEwIk5R+FlwsG7J49O9bOXr6mgHJqhn9b9SaRlNNKF+zGvGPKYEWm5lb21wUFL7w5G+6FJLCbUQHtdl+kE7ZouVD7N4/Fy14uI2RtIgkowdajB6iOIBpUBxhvbt7B9YTvAJeC7GRhEcGwKjhQRpD0qBlrgba4h3Ue2TGXQ4RQmRYEqXtAn05GT8TYvcrZwmWBeF5ebd60JGoA1VDdNEekhlDaF7WCKqMufDfkCxYUWpwdrvsW7J0hxQiKDEuwxgA3Fwx3HuJGXeTOBHhprQ+c8YFs4azd4qAHy9wZQZ4DqITmJZ59GEqmh3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These two patches fix two independent bugs in the multi-range selection
of cma_declare_contiguous_multi(), found by code inspection with the
help of an LLM (both patches carry Assisted-by: LLM).

Patch 1 fixes list_insert_sorted(), which does not actually sort: it
stops at the wrong entry and, when no entry matches, inserts before the
last entry instead of appending. The caller assumes the list tail is the
smallest recorded range and that the list is walked largest first.

Patch 2 fixes sizesum counting the size of ranges that were skipped
because the list was full, so the sizesum < total_size check can pass
when the recorded ranges cannot cover the request, and the function
returns 0 having reserved less than asked for.

Each patch fixes a distinct failure and neither depends on the other.
No kernel-level reproducer was produced and nothing was tested beyond
compiling; the examples in the commit messages come from a userspace
copy of the helper and the selection loop, written from the source.

Changes in v2:
- resend as a series with a cover letter, as requested by Lorenzo
- commit messages now state how the bugs were found and that they were
  not tested on hardware or in a booted kernel
- add Assisted-by: LLM
- patch 1: correct the sentence about the first inserted range staying
  at the tail (only until it is evicted)
- rebased on the current akpm/mm-new
- no code changes

v1: https://lore.kernel.org/all/20261011003059.169430-1-skunkolee@gmail.com/

Ivy Lopez (2):
  mm/cma: fix list_insert_sorted() ordering
  mm/cma: do not count skipped ranges in cma_declare_contiguous_multi()

 mm/cma.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

-- 
2.56.0


