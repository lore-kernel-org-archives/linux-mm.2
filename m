Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B1D4CA5FE0
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 18:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9666B0088; Fri,  2 Oct 2026 14:45:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C16F6B008A; Fri,  2 Oct 2026 14:45:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DAD66B008C; Fri,  2 Oct 2026 14:45:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A9016B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:45:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B6DEF1604F8
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:45:50 +0000 (UTC)
X-FDA: 85278565260.06.F02A868
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1BE8BC000D
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:45:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j/B1UlzW";
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790966749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jdO8oFrHyfPHpTduxdn2W65ZwXyk2ZPDC9NIAqHTviU=;
	b=yG2uHn8kFNHnbbv25u1IiFD5+UQSr0oT4TRVDcMEy3PeaotC5aDOb9NGKqYC9NYqdznxJL
	VAxH3+uZOHsziWWf5cDJMo0Syw3jxqENQrWj3PufHb9RQEuQCPOOgRudoDr1p64JShiIGE
	wqFuFBNQlGZ1+fcFvVdHgP9hOiOD6IM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j/B1UlzW";
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790966749;
	b=b8AF8O3iYk7U+hjU1PHb92tRtBv3cM/1CJfuUoLQap0TTaEtVFbRMipn3LaOfyEph/7k0h
	596vcSxgGVynv8zIIVMNTyPZzl9o6Fa922h09vy4Q5U3FXFbMZqJG8AqEsFfaHbrbjg/DX
	3tgnUMfMrPE9ftqnLQjxgDp8A6s01Bg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 498794136A;
	Fri,  2 Oct 2026 18:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CAF1F000FF;
	Fri,  2 Oct 2026 18:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790966748;
	bh=jdO8oFrHyfPHpTduxdn2W65ZwXyk2ZPDC9NIAqHTviU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j/B1UlzWmMc05S9yhUR8u+Wl3HKdikuFa1aEGhfAMdGKyzvHHcG7Du8ai/Q7QKdIW
	 PSzx90YFamWOeRQ+O0/ClYaH9ISgd1AXHDPTH53hU6kpC7jtNLHOyDq2xs9YJYgBW9
	 PJYmI0gzsnwwd/8352kMpMq7Wwb/qpTiN5Il0oZMgqHD1gYC+jF+WFudV4eTGlnqEw
	 ue8120gafUNDfPRFJEKNArWNpeXBS+Nu0j3yUyBMuYtkqGAfwydtfDDIw22IvMseAZ
	 qDF6m5NL6bY3md5JsKuOnprimiYlugiX/RRXIzcN1T6Nvprtp8VnEJfq7yEmEeJvcw
	 oj7H7ocWKc04w==
From: SJ Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	"Jose A . Perez de Azpillaga" <azpijr@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v2 2/3] mm/memory: remove the mkwrite argument from __vm_insert_mixed()
Date: Fri,  2 Oct 2026 11:45:42 -0700
Message-ID: <20261002184542.41220-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261002160535.661399-3-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1BE8BC000D
X-Stat-Signature: 3z6natyco7xk7863f3zyf41fpprcbds9
X-HE-Tag: 1790966748-115717
X-HE-Meta: U2FsdGVkX1+AHUfqbD8MelsDTt7MwRs9X7waGIPtl1OF08jFLi8IcS27pZDrcelDKKgP8oN7GKFJk6Spayg3J13XFLZE0m9f3UP16kotKLnOM1UEZdWAUsEpJaYoug2yHdMaHmhSRWkk7qJNnYemJaACiDlh2lRASWMu7wM3y04nCXX/zdFCWLdt2Q94CrJ/WW+pcWMZCol8W/lpI1AKmzBsFj2ovTARxAMWk7LKn9i/XGYBAYjJxxg2RwNvNFT+kIIyVGzSn0aZ7hjzO+r/cpPlFxc2xpYiS/lLP7tq5KVffuj9B/DeSbIAYhcwwKD59hUQQWGR9+SMioCwv3B7eIaqcglxn9kKEU8x3EZ9BAH+MO7vb0W9wJBBzH6kb3VPwkgDXLCAiXmcwQiV2lc9EDcOO0e4pKfIAyWDvrVwrTYVJQ+wYOSp1O7d667sk+3Z8+TK4L28/djcW8M7XrHZJDsJe2dUAC1sawE9XR9ZtblPFcdgEg8JniJlGZeZhLVO4JEoqQzzJqyVtsREJ6A6UEHFzDXKs97RM8A61r/kGpjiC82lIaebRF3DXMnz2nZCyBUuEqgS8HOpoK6r3ZFcMIqBgNmNQRy1U4RJM1Gzs1TDCTNqF3WAk8BNtXqm2esjzJtH1B2SHMzyvtemrT5cz4b0JKEKdU/+G7qK5W6LRVLz+hvN48oTwzggp57LGmKhyGS5gW91ID17PYHXiej4/XRNyFIDA35oSMfrVFm4nX0tLXEmc6EsD9SgVWkyyHUcbEdlNcYD0VcIXwA2nV/7P8+N7idCxgoLTC5MJDpdf6toJpzBrzw+zC8P57nfFO0RrwRYjuez+g6ogPI6C5N35Mce1BaqaXL4b+Nv2mHUdS77As/Cronohq7UE2W4XyJltyaWUnqNDaOlD5FGedcv9sUiLmTKWifosjM4up6mQEYOH2tBbisBUHqemxeMI24TyW7DJP6qqh+eFO9OMgm
 Ig8ubvng
 wcgmZXQwF7lnqwYYgfAk5Wwpz2mas+bpXpU488I/6wPpt8Q76lvATNhqh3YD5dkGYH0jkn9cNiFug4zBTkX45z/wB1zFAtCbGS7Wtq/Sh8Uk7bOjM1MdFy0E0IhkBT/QA+Y5BDbmK7Zkast/PP9m82aKEvwneYpSA4vLbSrSy0j+nAALnTh9VvsAn5LQLuA2kt/2lsF3kaP0i17hlUQrOF2EBGzb4PvGwyC1cmz6ia+FxXVZUZfelw24d91xrSftMoHsqpEbPDyi8PMqMZpIsAbmHDk8ubnwBTXFA+nhGfCXPoo8Z/2ceHyE7bA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  3 Oct 2026 01:05:33 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> __vm_insert_mixed() is only called from vmf_insert_mixed() with
> mkwrite == false, so mkwrite is also always false in vm_mixed_ok()
> and insert_pfn().
> 
> So remove the argument and the unreachable code in insert_pfn().
> 
> No functional change.

Looks correct to me.

> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

