Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3A64C4452F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 03:59:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0BF56B007B; Mon, 20 Jul 2026 23:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BC816B008A; Mon, 20 Jul 2026 23:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D26E6B008C; Mon, 20 Jul 2026 23:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 634386B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 23:59:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CCDBA1A0242
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 03:58:59 +0000 (UTC)
X-FDA: 85011427998.08.7F697A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4050D180003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 03:58:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hMVVeMNI;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784606338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oJ6Px6DXNbc3Qe0XDywPZIT4PeLkWoS5DeFP+oHDWtY=;
	b=0hU9OE2lyxU15QUFnE84jqimqz2Knu5ypqudFHn6Z9YULpFS5myKw3xYq2M1wmutZbR4LM
	sI2OU8zg5lHLkN5U3ganVH3UUkdKaexJTDSF1hQromXvl3l4HG8I0VpN0tUJ9qFTqmq/02
	jhWj8ZcaFYYEK/leQFTRTGhtbUpxe5U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784606338;
	b=6gsC9jXmUn9H207mWMB+MFtVmhcMXiZeHaUIV6PugSaLCanUnWpOwXCXekLcUO+F++oidV
	RQ6OKk7hUj5b9LxdMrhK44qmfMZmYC/QmEGbBq6wzsWVVYUlFpnZOHZ3MN0hA2DzlsrreK
	RryWnG2wg68rjKXLO1thPug0X+0fHUs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hMVVeMNI;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B594F60A61;
	Tue, 21 Jul 2026 03:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181501F000E9;
	Tue, 21 Jul 2026 03:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784606337;
	bh=oJ6Px6DXNbc3Qe0XDywPZIT4PeLkWoS5DeFP+oHDWtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hMVVeMNI/exwtUfEOKmbDpudKB06CfsJ6S12sc3a5dbqfCXBpqs3iqDSxS8Y5vZce
	 q362Xnnk251ZMY87mIzm7QX5GqOsehzFwpaoo7BuJUQa0D46f2jJWoCB4dQA972oZ5
	 EAPsg2A9bwsMe4jO5kzXr53pTvNAifLffGZVRAKR9V3WcqLYYu+028agb/wv9wy9jj
	 5SfskE1m3N5fYcM/VMk0HP84+8FqFzFu/UAxtT+08+0/xa2pXFfDMVs3uWKtLqfyeG
	 8t5J/lkL+a3fa1ElywSRvr1b/PAkxdQPCIP71g/I9TQsJqyOdbLJk+r/6blgTHDg+y
	 fh1l6mvCeMHXQ==
From: SJ Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SJ Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] mm/damon: Introduce a huge page collapsing mechanism using auto tuning
Date: Mon, 20 Jul 2026 20:58:47 -0700
Message-ID: <20260721035848.147455-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260720120140.881468-1-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4050D180003
X-Stat-Signature: ptm4ehepdo7foe7ijswoyw8qxi9s4cj9
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784606338-154369
X-HE-Meta: U2FsdGVkX1/DYEKRjee2YnHFyc3dP/RXCQnJrX4g8/U8p6zLFVdcU8j26jOP7zcLT+mFWu4a/mDi12UvLJyUFE/kXnfb9WaWd3LN2C4IYrP0U5Q+2REW5ke7ahA5wbqgKEKSYWgeXwBUGkrLkTBTeiiHiMqwJL+Tqt/rgk87pkKbokluIPm11CFIM3egQkZf1rIgegwVtLNtiO9ww3ZDXI2hHzcTJOBwsSJ5Noy1HMQ2nxXG672DLV2A7mKAr9+zRwv/D6zPXNsikJTRjcvUH6bVt/6MdgrEBr57Vv0pj7VrSND/kxzUhJZLi6fydEF20hArA+GVmtVVkvedJp4W7Vt0PcVPTpAtTULu/1WCG5J6ucYsDXVaYizcH+dGJKI5aar/vwcEuKSdL9rFIchy8M/iHqUpHrUSGiITI7Iv+IMEONS4KpDkCaaBzzMvNmKvtOHwX/QISxGyM2OIkHeOF/iWNeYfZz6Tw2SFZAf1Nwo93N5zD607doHta6DhqukKSTq45t3CvIYRHmRVPBxOTRpZdM+mJb0od84z5znQiFc0LOMMhx72SNaDQJoYV/i8JC2YlauTGOph20mED5yLG+5t7npuWDJ+PgzWRnLnJRmnb1zw589nGH4/6aeqU7cEPBP1/kkrHFmCEJktNn045xzhZr/hCgTGIc5JeTiGtdyoYDFLmjetMYg8yC0TfcyfMlCsl+5Rwv9R0Qe3RNJgLbPKZ2nw9bCUMAwRnKp6l5aeZzk6k3aURHEXx3dv2aOpjRulLuIXeyraLvVry38N3Rge7R06uta3MegYk/OVP15bzEhzx1AsNxIttKsewx3iCYD9Un0L8RAcsaOFS20SaFvRxTuHn8d4GEX5jY8x0n4MIWhwphApkPwKrflLXSGmWs0+dVuFbUWRBsfRrWQqKKXyWZMOjF3I4BMGoL4klg+V4Zr94RaGYo+r2SO+sGyUgcyIjJw+RmxyGDGIIP/
 nXCIGPX8
 2b7SdZnWwzZ3g5Gw8MGsKiHqrgbOxrhVLTi77NMSC21hTJw4IskRuHZ+EGQxIJiqOt+HsT5gff6zdVAvWZX7Pk2mbencqVtAxt+LyuK8j/UVliaSebRqSHSlUDBp2deVIAlsFa03uwMlzesZuzK3cfLnYyf/dEdbUbdWkTJ93xN4t/DqYU7PYKVDyRhk0eJK4BqdR/R9RePsUaau0eIdYDa2rpVMy1LTEnoNwv6UNSMRQNKmmYQ3mzPdIwfUhdUgqK37n4KAKmhl/D78kiTsjPEAQK0dk9JLnzBvDFSMEhomkcfbbq/A+cNJc1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Asier,

On Mon, 20 Jul 2026 12:01:37 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Overview
> ========
> This patch set introduces a new autotuning which allows to collapse
> hot regions into hugepages.

Thank you for making this series well done like this!

[...]
> Patches Sequence
> ================
> Patch 1 -> Introduce DAMOS_QUOTA_HUGEPAGE_MEM_BP and autotuning
> Patch 2 -> sysfs support for the new quota goal
> Patch 3 -> Document hugepage_mem_bp parameter

I'd prefer handling 'total' underflow and returning 10,000 instead of INT_MAX
from damos_hugepage_mem_bp() corner cases.  But definitely that is no blocker.
For the series,

Reviewed-by: SJ Park <sj@kernel.org>

This series is applied to damon/next [1] tree.  If this series is not added to
mm.git in short term (~3 days?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  In the case, I will update patch 1 to do what I mentioned as
preferred change if you don't mind.  So, no action from your side is needed for
now.  If it seems I also forgot doing that or you cannot wait for my action,
please feel free to directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

