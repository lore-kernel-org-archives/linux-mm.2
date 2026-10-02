Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85980CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 18:11:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 439F36B0088; Fri,  2 Oct 2026 14:11:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EA8F6B008A; Fri,  2 Oct 2026 14:11:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301756B008C; Fri,  2 Oct 2026 14:11:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0EE2F6B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:11:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B4D3C0843
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:11:44 +0000 (UTC)
X-FDA: 85278479328.11.AE54823
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id DD0964000E
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:11:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EA0fQUr/";
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790964702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CP0MsROgLgfuaL5H6Y5umaXQ51VIpkOCJtpOwL5TQtI=;
	b=Zkarmh5fImqtEmlrtlDHVc063EyRyo0ibaf0WaGdcahTOI1CxlNyre0YWzM8brNL0SvJlr
	g+mPUjUKXimwSUgrmJPWwaSNA3c41Joe4VLQWet1YPvZhMtHAmKKqVFv2ee1Ml+oBUjl42
	EIwZzsucKDhgNFX3yWsIdsExVByInNo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EA0fQUr/";
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790964702;
	b=S3oATICr/ytBKRDgvvdrQCaULi1ZYHRrTu1YqZVzZDIrvi8ZjCf0sHLQXQB6XLrJWUwf7P
	31NZyOHSW6LmUckt8sM8O0yuN7ncg66x895ONyOkaDeXnh+a6ExqgRCZTxmueqHovk1qOo
	WW8PmzRrVvQ7bkVp63Cu9vebXJbdkLI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A325D60A52;
	Fri,  2 Oct 2026 18:11:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADA71F000FF;
	Fri,  2 Oct 2026 18:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790964701;
	bh=CP0MsROgLgfuaL5H6Y5umaXQ51VIpkOCJtpOwL5TQtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EA0fQUr/fj5O7sfp2orAz+pVzZcRx1HqK8p61QAJwe/iIs4PATGeitrNzt1SFHiEh
	 BRMbUhG6d2dpPJR0HQxtNOUsCkORVI9hlYONcmzIcPAsfQUogywTIQ+qYAyRWKNBMf
	 uspDaeKEIR4ouZ+UdqGOAS+LVfJZ9BsdjDS+OBBE5HbVJ6lX/2e1+Zfdb9QSq9Z+zd
	 ryMHLs5zGY4u6VSXdw+gAHe2Qc3l1BvD248FjU1cd081Qw0jZTwANgFvn+M+BJNnaK
	 W0ejJ/u2Rvn/y2MYgOUwvLsv75J7oW7F1Pyn9ucEeAY8DTQKAhiKhWdKJ6Rj0J3TFa
	 VRG15XLDgJ63w==
From: SJ Park <sj@kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org
Subject: Re: [PATCH] mm/damon: use damon_get_monitor_folio() for hugetlb entries
Date: Fri,  2 Oct 2026 11:11:35 -0700
Message-ID: <20261002181136.46472-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261002140727.701709-1-gourry@gourry.net>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DD0964000E
X-Rspam-User: 
X-Stat-Signature: qbbqewcrh5c9cfc8e9n6zkhwbjbwdrix
X-HE-Tag: 1790964702-831242
X-HE-Meta: U2FsdGVkX1+FNdesSWpjhZvMFu2J3xT6FYk2/gxqFs0ncBf+Y94975g1WH6uPHmBPOuPr9QSap1gWwOhfmMI7o5JfJn1b+quonI06hYbozXgXFYeBK+9izSC2E209Mb88agrgl0/OJ+xZaiAt74Xmr404jDOCF3QTeQErjkyaBqKnbywS0Cxyh+aa9tShf8Lo0ShSYyV+a5ywpPN8C0OtklOK5cwXVxKVJCrivStENjETPy8esdHx42Mc9Px8xatIuRvicgFxyqKTPlAxGbdLRDYCBUh0p+VqQOpByaxGneeUlqRZETolusCc3CjSquPtw1u5GaezyjPvQioPdpwy5Jx9x8TaN/wmrvJAPKsIyKpeRYMSK4U2NbUEgc7Q7uQPEvp0u4ug/XtMA/aDWfjwaAYkwDXSr7R/ELWugeBggWHYQ2LGN7kQyhTCz6tCuahLzyp/Atfp7q7TW+s6ZaqBjy9F4IPfHNULqYdhT79nfIwO4RPsp+i2Ij17e18h8iXZYp8Ptc0pQWGdstDQ9Dr3hfT7U5SDnvYny9wIaBpd8zukoyU93kfItPgD4jy3fW5752spkqYQoFi4CjOEz9Vt6agaOzcp15Bc/icuEvPJ1b3k89v/xJ+HyMOaEPXz/21mSVkTwjp9vguMUgelXY/UtTAbDsU2TaU1wKh4Jlhs1GWqKmEkyJRiqli7EiHezQiFIEdhTIDn1ACBvYeyULkNvg/mbZ4njycJ72qN5WTNdo8fp/jErpzW79EpoWO/2qq7dLRZuLDZthzTyudvJRUDOU70/ti2ZiBHOm3b5nSut+9RHgtMUsM5/QDmPIcVe9Df4ccYvCU/1nos33bhZyZku1oVoRU9jSrUpUjpqtJQwc4gCQ6dRF7Mmjpw4BWi2TJOiHDPPmIhaCToB8VQOHaAdQwCwM7DOubV9FQxhgf4x+AzMGplV2bwcmunCIJphDAxPrEuDO9rant5yz4rCl
 TyWZ7F85
 XIr2kCzHhcfS46+Y/Iqn9ruhQxQtD+4zSrT4BpxsTuDtGrCi6vrGzfEwt0gPX/ox478uQUEZxmepD7RyTD9SkoM4df7ZvJJ+KT1gzberG52XI5a4CifzEQxazBQoFMvm4YLvRJ00OGwaeLT1uXWa2taYCHJI4YAOIarmY6em6ELSiiYsMTg5CLdQBpd9D3P+76BgNvNXygo3mlebbR53vUj/Ch3jZ16UNFOBsnIEdp5b4m+eZVDg7Gg/gF+9EUUvKIga5widHeU5w3fiqo8tG3Jx5o6obGoZMVrUAqk1E1/z0HfARekMZn57he1h8A1uVdvBimZsuCWoXt87RW42s6NoRVNiFfSIwy+OEHcbmicE6+b8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Gregory,

On Fri,  2 Oct 2026 10:07:27 -0400 "Gregory Price (Meta)" <gourry@gourry.net> wrote:

> From: Gregory Price <gourry@gourry.net>
> 
> Hugetlb folio acquisition is open-coded in three places:
>   - damon_hugetlb_mkold()
>   - damon_young_hugetlb_entry()
>   - damon_va_probe_hugetlb_entry()
> 
> DAMON already has damon_get_monitor_folio(), which paddr uses to
> get monitored LRU and hugetlb folios and to filter them through
> damon_folio_acceptable().  These paths bypass that check.
> 
> Use that helper in these paths too, so that DAMON acquires hugetlb
> folios and applies its acceptance policy in one place.
> 
> No functional change intended. All callers reach these paths with a
> present hugetlb PTE under the page table lock, so the folio is always
> a mapped hugetlb folio and the helper always returns it.

Thank you for this patch, looks good to me!

> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

Reviewed-by: SJ Park <sj@kernel.org>


This patch is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
ping me or Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

