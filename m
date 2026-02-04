Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F18B5E8B39F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 06:50:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77D16B0005; Wed,  4 Feb 2026 01:50:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E24446B0089; Wed,  4 Feb 2026 01:50:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D22C06B008A; Wed,  4 Feb 2026 01:50:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BD7956B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 01:50:40 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F2ADFBABBA
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:50:39 +0000 (UTC)
X-FDA: 84405850998.20.59E32A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7C078140003
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:50:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hq9zvd9f;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770187838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OjqDTyldBnHj8zXH7Ia2dO8KZLmg+HKhBrlN6K3aOQI=;
	b=J4Ufnu4qIeGzSCynRI4wwRkajgIu1kKOlln6hKyHSt59/Io4fyW9NgghvHiRTbQ1tPPwmZ
	NbL8Z/6lEYpb9ftUpp+RRDW8EcRKe9RIWJ5DIWLIS8Uh4XJoONgDlc1alcvWhTJlBJM1fx
	fLGki2Ait/khZZhpZD6gHA+fVErP/x0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hq9zvd9f;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770187838; a=rsa-sha256;
	cv=none;
	b=NnpywzfmR9y0OOzLxuBSqZ0dZG3HnOqqKAL0L9qrHGvToRfPyln/wXN/ukbWFdhFGdec6G
	Ch9myif6mz4HSnDuGCcoWJ0B4SfRRYRjyLUKGGrEDZM8yr1WL+Rq+ku9i0NSOl4tmpJGjv
	Ef8cHduv5QN74SBs+p5LVwoz2zSxnXk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A7B3444AB;
	Wed,  4 Feb 2026 06:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F187C4CEF7;
	Wed,  4 Feb 2026 06:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770187837;
	bh=Ynp8H61OEOLyw86ddq0GbQsnIzog6c42WYAG7qHdqxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hq9zvd9f2q5zGqcvW/W4lh7x7Dh6/q62QFjUw1Bi7kXPS6XxKX9Kyxkdd2sAyPGCY
	 36Py/Et+VJo3Ry7K6IwUGOug7qGUnkdjYmX4h2CclxHCcaZFTh0Lds5hs+fzS+aGfb
	 Oi0vnap8tFz210HpediDQuBPuKmQrCXyKsM58phLEhNR8CGMhx8vafAjiRTDxhu49x
	 GC7zBDoDWv6v6QlylYtVlc0gaIMWUgq1bHlWsMYEDaMSR/mQlKath+p+T3v4+sFCrO
	 fuVSoUL0g+46uBc1nm5tHbgniXH9Grb6Dm2vFOOFbRbTACv9OLeX9BHkZGQ8FDB5Mi
	 zCWKV9cYQfywA==
From: SeongJae Park <sj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Subject: Re: mm.git review status (mm-stable)
Date: Tue,  3 Feb 2026 22:50:28 -0800
Message-ID: <20260204065029.16046-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aYIdEKHZ9mss9ZJb@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7C078140003
X-Stat-Signature: zwi3u6mxxbnoms1dynzydtxoqa1zc858
X-Rspam-User: 
X-HE-Tag: 1770187838-29644
X-HE-Meta: U2FsdGVkX1/wZ3uqI5xtdaBUnL+p9EtyAfq0q0h7ag60t00NgnnIm7ehe/YkSI9W78W+BkkyiqMaMjq3eJT5hnysYyHbwNoLhjhscn/WcOSPGqD88KRFqtQJc3UZjc0vIWofpNMfQ0xnHvqSTrlZDhl2/YWXvKAdmpSxCLWRjcCBfXU8fAx+AVQkdfAKmdfT5rCiZvPXCTh96xBcshPmdMETHtUnFAtdwe+PE0vOn9j8Vqi4g37qxtUssNMrCfw5TJX2ZtBXAHkRRAOFEV+mEUt5Bn4n84QhVA/zf3STJT3GQWhL2y1AQAvXM8psnT8TLbmQpHOwQbzmooskpKvHnTFHf1ABeAjWFYr0u3KQZk432gP12wE6bDVcfYMjVtq0coSZSQsaroc2qwqM9Awa6rmu4oO/gGf0ZdMo+Qv7oTsuoSQteg088J3KcTb8L2VVpgDVGhtQJv5IZSYwSc1Pdvwkp1N9wIDtrCgawgJPJgGMGEZp397EGA1BQLOyvM4Tr72TGqQFPR6WVvUDV0zdj3alpYCFtBt0X2VNgLzHTw18McbjLhR6Hp83blzSw12GGD5MCayXvmagx1J0Tf1wDfPUR5T2q6PaXkqNE5Ve3+svv25DKZ/nJcDHGgF69M2z9HCXkQgbUpzyrO8MmJLxX6hRyMlvK0hniHuJ8msHD6f/P8xxurA18VyvsF43omjVCQ5hWhWsL3+YM03E+bHoY9w1EcPDet1Hel0n03F5qGM6/h+RZ5PfudpsZbhFvxEG+2805ppxq0FuCsAX+NsVhlrxQ5kWA+Q5HJyU11Gk7bRogBb3yGDQoEBVE7PFNvhnhC3E33EJePFpiAq0rdeHQU0kiVDPtgVz3TOn3EPnyWIfakWrsEhgajLXmTfk1XEGXtqkuS7FOlEgkGM3YqtV/RPJyz/u2K4ZC7mjq+dLQCWK6rTar+1Igw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 3 Feb 2026 08:18:18 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> On Mon, Feb 02, 2026 at 06:45:52PM -0800, Andrew Morton wrote:
> > 
> > I wrote a thing, thought it might be of some interest.
> > 
> > 
> > mm.git review status for linus..mm-stable
> > 
> > Everything:
> > 
> > Total patches:       320
> > Reviews/patch:       1.40
> > Reviewed rate:       74%

Thank you for sharing this, Andrew :)  This high level view is helpful.

> > 
> > Excluding DAMON:
> > 
> > Total patches:       259
> > Reviews/patch:       1.65
> > Reviewed rate:       84%

And the above part made me wonder if there could be people who want to get the
view for only DAMON patches.  I was actually wondering that recently, and
therefore was writing a tool [1] that can provide that kind of information,
occasionally in the last weekend.  The tool is still in a early stage, so it
would be buggy and may be changed a lot in near future.  Nonetheless, it can
provide the review status in multiple categories [2] including if it is not
reviewed but written by a maintainer, and for specific subsystems.  So if you
want to know more detailed review status of patches for DAMON or other
subsystems in mm tree, you could use it.  E.g.,

    $ ../lazybox/linux_hack/mm_tree_summary.py --subsystem "DAMON" --review_score_to_print_commits 11
    baseline: v6.19-rc6-36-g6c790212c588f

    # DAMON
    mm-hotfixes-stable: 0 commits
    mm-hotfixes-unstable: 0 commits
    mm-stable: 62 commits
      - review score 3: 12 commits
      - review score 8: 42 commits
      - review score 9: 7 commits
      - review score 11: 1 commits
        - 95296536eb19 ("memcg: rename mem_cgroup_ino() to mem_cgroup_id()")
    mm-unstable: 1 commits
      - review score 3: 1 commits
    mm-new: 1 commits
      - review score 3: 1 commits
    mm-nonmm-stable: 0 commits
    mm-nonmm-unstable: 0 commits

> > 
> > Excluding DAMON and zram:
> > 
> > Total patches:       245
> > Reviews/patch:       1.74
> > Reviewed rate:       88%
> > 
> 
> Thanks Andrew for sharing this. It seems like DAMON and zram maintainers
> need to convince more folks to be reviewers for their sub-system :P

I just hope my code makes more reviewers than my words and chocolate cakes ;)

[1] https://github.com/sjp38/lazybox/blob/master/linux_hack/mm_tree_summary.py
[2] https://github.com/sjp38/lazybox/blob/master/linux_hack/mm_tree_summary.py#L64


Thanks,
SJ

[...]

