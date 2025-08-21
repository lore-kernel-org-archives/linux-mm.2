Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A0F0CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 17:33:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B108D6B00BD; Thu, 21 Aug 2025 13:33:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC0F26B00C0; Thu, 21 Aug 2025 13:33:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FE096B00C1; Thu, 21 Aug 2025 13:33:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9077C6B00BD
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:33:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 47B541DD790
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:33:25 +0000 (UTC)
X-FDA: 83801461170.07.8BE696E
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf21.hostedemail.com (Postfix) with ESMTP id B02191C0006
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:33:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zl1831ma;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755797603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=INu4lGcbiq4WuKEJ0QvCcafVF56MqxWRJ84eIfBltVQ=;
	b=Dl0yIXoGrM7LQoty9ehSPjLYj7ptoH+wZJ3BOGWKVPRH6SrnPd14dh0i1z2gR3khjCih7i
	tv2MaNupjF+sOob7SJa8sb05c7niBHKNfv5+BQtrS02johZ3ymnBsmP+SyATlBn+vVMLlH
	My5cTqZqH7CBy4ys4egX9PZXuNYWziE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zl1831ma;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755797603; a=rsa-sha256;
	cv=none;
	b=QJ8canpDxtxGjgQRYe0w6wBuGEQ9UeFAAnJaSune8i4usfdvZ/q66h2b/pX8vcxT276+Ae
	H0oHMVBNJrdRC0FjJKVYAl7eG75H7tEMtDM4kUj3VCUDnDoIWSbPNyMihW//zQ3kq2zcQS
	H/g0iIsddSmq3gsGFx/lmZFj5QPRhmg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id CCF065C5E5B;
	Thu, 21 Aug 2025 17:33:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3E0C4AF0B;
	Thu, 21 Aug 2025 17:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755797602;
	bh=qIgwyDLs7gXuHaRh+NCslEDZeervdmckUOO3x2JXbFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zl1831majxb7E4/n3F4VP0brhAGKevHYa8BJcRbodNOLWrVwuH3GQIpfLsEuHBCVT
	 QEHUC/RNpCmHK0ckETrFIWxler9iTsDxYSxtLtugrYs4y/2wRmwRJfOTA2kRqpxI/1
	 u44ZKfbvmqkFYJNaOmFoOtJs37x+DjFn/XgN6QTgC/cHVwEt0t2OSacaiUNdkConRV
	 4q2WnQ7659nxfLTd0U58Kf5r13oQxaE2fZOXG2tdyJA0j+ZfjfASeH5rpZKM5ZOX/x
	 XuPIz+65Xl1abjTNSyoST5b4x+h5R9T+PpyVvS+RLASPOdENxe1/Qfa7zyjQREO4Qw
	 8Km5sXbhcJj9w==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH 11/11] mm/damon: add damon_ctx->min_region
Date: Thu, 21 Aug 2025 10:33:20 -0700
Message-Id: <20250821173320.82616-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250821105159.2503894-12-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B02191C0006
X-Rspam-User: 
X-Stat-Signature: peu7hm76q35czx9usq4c5nyzj3u6a9au
X-Rspamd-Server: rspam09
X-HE-Tag: 1755797603-756986
X-HE-Meta: U2FsdGVkX18lu8prHel/SnrkAlLPm4jqkFMOocQZxEIP6qm90NEsgwpXUWKDVMGAEN8VVOIcLubreQa25B2r0NY7ss0KHPPuslP7cNDUqPs3BW9kgyDidxAbo0G2DiUoS9F70u8WYC/+TS8Id0as393Itm5PtHW7NmWxw7vqHfF2JKAIkwT76XkG8eDxAynEXjJvLbmUfaCkxpEUR1mBBEaBxcP4DizKBtNSQTA8bBtLfGCPJHzfYUteo143Z5hPJPOEWgTngWZBL4nxElS3X5ffzz4Bq1ArVabVnrbPFpvIoUkRnhqZ2IS63qtGktB2/XjHX4LhB9et3B/oO6N9WRMc2M5B0WG/PcU9JVOhUCbSHE+f3FF3UsfrgzFefhxwipLkxvuZkpooAyaB/2P9oOwcsi/SDkQBiWMlXGtYvtL/5xBALdz5AohC6Kuz5btFIrvL+hbkkKmavDY30igpSKGxXcQCVPOy3Wi7HrB1SQs6r0300DOYk3IEFGGKE18AKvM5MUMUWclpS1whKOu1y9ey19OAtmkB5SqybtKa6LLsJlWecqu+KIOEmcTPsrEL+RMJOT4EQgRpIKUAIEtew0F9U+yBAgapPhtMc6VvqSrkl4WgwpAd1X5Ua0z1DCbrHHotw5IXOe8o+ZV+OmV/fYZIpwOctwOB/x4tLC6+uaSmeixdwZ1LaLIKU+p02htcTNduF7LDQoZ4cHaYcugLuw3/tfmP2IPfJqeUOP7tp+fhVkA9VhFtLr+7YNL5cUO+fsKj449KArr70tcFOvut5Hfef4AWPC811GaaHLmPm3/naMWP49H6w34261ROEcV95pbIipWJjFLOoSc62PXyWDapfzxXGw/GYhD1jAJtClq56LSaDgx3JvmfcU/gI/hll3EQMw1L45SyRebtTAMx1jRqgaaEN9ncgXGM1b28jeu61Mht4DmAXhVER7s0PcTLJe3aHxgNBk4/1dpnYgY
 cDl0UFYA
 0j5gFfGixxszAnaBtGzzXGDvOep6Tx73ORPZ9Q2k7CBmd5o0SelAG4Qh4AUKHdPQjTbjky4TEAIQ4ku3pXbrqbtCRotSGPpHFKfBwrNDuCTYaxtmkH+pNpnRD/MDU53n+nPMltyzoT/syzpThqp6L4U3EQlnTQzIThKu/gDrCv0ObV5TYYM79omhKeosX85b3S4+lLOiKDX/yuLsWza7m8hSvejqQqGKAbtqpI36/dvEO1gp3izcozABtbDlYspCbnJWyvGlanOcLfoIYVfpggh1BlaOXzm98j/BxDMFuY6GSg6E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 18:51:59 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> Adopting addr_unit would make DAMON_MINREGION 'addr_unit * 4096'
> bytes and cause data alignment issues[1].
> 
> Add damon_ctx->min_region to change DAMON_MIN_REGION from a global

s/min_region/min_sz_region/ ?

> macro value to per-context variable.
> 
> [1] https://lore.kernel.org/all/527714dd-0e33-43ab-bbbd-d89670ba79e7@huawei.com
> 
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
> ---
>  include/linux/damon.h        |  4 ++-
>  mm/damon/core.c              | 67 ++++++++++++++++++++----------------
>  mm/damon/sysfs.c             |  8 +++--
>  mm/damon/tests/core-kunit.h  | 21 ++++++-----
>  mm/damon/tests/vaddr-kunit.h |  2 +-
>  mm/damon/vaddr.c             |  2 +-
>  6 files changed, 61 insertions(+), 43 deletions(-)
[...]
> @@ -1248,6 +1253,7 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
>  	}
>  	dst->ops = src->ops;
>  	dst->addr_unit = src->addr_unit;
> +	dst->min_sz_region = max(DAMON_MIN_REGION / src->addr_unit, 1);

Can't we set this as src->min_sz_region?

I asked a same question[1] to the previous version but seems it was missed.

[...]

Other parts look good to me.

[1] https://lore.kernel.org/20250820215612.86678-1-sj@kernel.org


Thanks,
SJ

