Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02072CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 00:49:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E0678E000B; Mon, 29 Sep 2025 20:49:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B8168E0002; Mon, 29 Sep 2025 20:49:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F4938E000B; Mon, 29 Sep 2025 20:49:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3FA7D8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:49:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BDA6113B3B7
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 00:49:12 +0000 (UTC)
X-FDA: 83944082544.14.285E221
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0CF8720010
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 00:49:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QhK76q+a;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759193351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9P8i0lPxwdWcH06Qu/q8Q7cHVskIwe2qq5Z3Y/6PcLs=;
	b=2p6c3mwwIHMj+a/jB6GBU734BLcAm164HCTqRYFcriTJtAEaYFk2LV88IJAKZX7/A+6Dmy
	E4O3MpwxGQyP3hvuJ31Qblz7c8w3Z6IdtlT2UP4IKy3bLE6nBmPZTf4Y1AyPqUgsFhX3AF
	qIwmruXsS9jRwsODDss1mfEwMzWaQMY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QhK76q+a;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759193351; a=rsa-sha256;
	cv=none;
	b=VgEHCr87h1PRWFsF3WDpe023/81MKsjbXPEwHVXyF1Ut/070b3hhrJHaz/vW+JAyC13JHg
	2XXfGaLc5L0ZC/4yldfypn+wfAGg1V3IoLu35A1RRz4z3lE/opVy4tLjQnYByOlONP5lXa
	qKrshc8YjJg6WVdeuwUA/A5YQRwtgkc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A7A60433CB;
	Tue, 30 Sep 2025 00:49:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6388CC4CEF4;
	Tue, 30 Sep 2025 00:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759193349;
	bh=Dmx25bmLQf6ATWT8g8tetZDOFF0vBbRp6vW8hTDcyvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhK76q+aJngACoGRYQpbuwf9uBLxE7n+FfDFAI6Bz7CRfp9ohr/mdN6MzNy4Y+cbF
	 PJP3xHR20cu+BzyuUy7Gl3Qq82r3fg7EjaQpikJUEUz5+5xCPugK97xs6t9FDM0xyY
	 Hd+vzUifNrzATwg4X9wlRNkTkZm/oMoYzEk7KqYkK9Y6hICU0FW4U7iL6UfuxGRsHK
	 wdZSrpIjBc+gy+9jQDWi0BHwdvjG4pGW4CoT5SkisCEv+htE+KSj5g3N+hDZapdrKc
	 /pSALxpvqkak+zEX88oxB+WXrJ9oaDh9IV3eztg7ZJzgtaHheTeX3az3YS6ksRPxUh
	 ZV/EXsYxjXcrw==
From: SeongJae Park <sj@kernel.org>
To: Xinyu Zheng <zhengxinyu6@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zouyipeng@huawei.com,
	Hugh Dickins <hughd@google.com>
Subject: Re: [BUG REPORT] mm/damon: softlockup when kdamond walk page with cpu hotplug
Date: Mon, 29 Sep 2025 17:49:07 -0700
Message-Id: <20250930004907.55388-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <eaee73bd-21cc-4da2-86a8-fe6a9576ab51@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0CF8720010
X-Stat-Signature: tnnah655u7iirbpntuhhybce5tujnq1m
X-HE-Tag: 1759193350-398143
X-HE-Meta: U2FsdGVkX18YhXExzzxAH6p6ptvYIKe/djjMbHFO2GobR42DBDlSCqQxEgk/8pkPYL4ILr/npKaaeqAJYgDm3q1aYxeu3uKuuVhFZOcUfmftRCSmMFqypPOajSLClZQoQtGRzRwM7mr2Fe6YkQz3IzTzW17CQuP3GwBHdlqlycoQ4zQ4KKL8djp8GoekaXZOUEZvaBBbEH9+x2Bp2cfeBCdUEKrNV2p+J6gRPzMCko4aJyUw1HpyNZpP8X7i7zw5FVfDX2omASt67wJS/BLCLvTL2fvEkB00DczJQm6Gx7TLYDAU0M5sRvduNqzYoezyaw+PNLk2b6F317VA48b0t9WeaKbCdlPQekGYArlQ0mK1Pu13Azj0UKPaIAGzS8KRcz6cck+wsLkQoXPutequs1A1MNSZuC1mGCDpR9tgaYvaUVLc+ZiGe7of8Etwhj7kc26XHj8F/od+4vj/uaFzzVwi7Nfy4y1LP//7/ZVpFt2TNB2YvXrxpMoLUKrnW95G4nnMb7K6ntI58r/qJ2pcnyHPByn3HloZQ/SymDsrVyxAiWdwrAe3q/1thGShj/zlv0jCHEZD14+zXic8Zk7r9EtAUqt6J89fHYWo7A9c12PiDkGmbHdo+NtsioncYWAx/f+LNBVqF02iVTLw7IjpmnFJ89ekXs/nC6fjJ9qxHL4uXMnENMNkXq2H2uw0rBi66u9O2DoYqOTbxtj2ZS/c71rXC8zQqQf2gXyWKr78dRSJeQoOQ/mrkUeeCNYkkP9FhkUrvHi4Ilky6yMUxDmwa3aOPTlEyoAia1uZRUiZM1lvxriQe2oTz359WcSPZ59MBVrlimSupxXwHhJExsZ/4BiZFv06yqP427LcbxL4wXFXpLnEQmYpvkvWchfWEo/kpNJ1ISEraBJNDVG+/pmvZOdvlxt20eBc0AkLEaQSIX9QVuP9dRqRw1f7baYxnZ7FV9VR7l2RfZtMk33Yxbd
 rXZ7gtqc
 Wv5uzzt5YlkZFY6J95VDANNUR+rkJHv3O6kaefHLhtwrR3/oYLhwcbqBfNfhWdFrRK/g50aBwdZe2d028D/5SPS5pv4zj0lZa8FS2mn7azqw4SfnRWc1ZvAdqTahWateiLoUyFegT+dQ/+Hezlg2sEUp0BhpafwPHdxauM4LcwHcv4pLGpi7IUD8PGH8/F8UMBLbvdOX7xjV90uPXcGCoh5aIwB4UE9RWsCLMEBmUp8AwuO6FOQKkVSty19L1r6XHxLGEUi0brtYGxYpvPOuZ3cOmqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Sep 2025 19:11:13 +0800 Xinyu Zheng <zhengxinyu6@huawei.com> wrote:

> 
> 
> On 9/20/2025 6:42 PM, SeongJae Park wrote:
> > On Fri, 19 Sep 2025 20:56:56 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:
> > 
> >> On Thu, 18 Sep 2025, SeongJae Park wrote:
> >>
> >>> Hello,
> >>>
> >>> On Thu, 18 Sep 2025 03:00:29 +0000 Xinyu Zheng <zhengxinyu6@huawei.com> wrote:
> >>>
> >>>> A softlockup issue was found with stress test:
[...]
> > Xinyu, could you please test if the below attached patch fixes your issue and
> > let us know the result?
> > 
> > If Xinyu confirms the validity of the fix and no one objects to the above plan,
> > I will post the fix as a formal one with a better commit message.
> > 
> 
> Hi, SJ. The below attached patch is works!
> 
> These days, I reproduced the same softlockup scenario for three times. 
> It can be reproduced around an hour when I increase the memory pressure.
> Then I patched the below fix, and ran the same testcase whole day, 
> softlock didn't trigger again.
> 
> Sorry for the long wait. Thanks again for your solution and explanation!

Sorry for late response, and thank you for confirming that the fix works.  I
just posted it as a formal patch:
https://lore.kernel.org/20250930004410.55228-1-sj@kernel.org


Thanks,
SJ

[...]

