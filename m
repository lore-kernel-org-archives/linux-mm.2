Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDF88FD88D3
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 01:02:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CA986B0096; Tue, 10 Mar 2026 21:02:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26AAC6B0098; Tue, 10 Mar 2026 21:02:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A2A06B0099; Tue, 10 Mar 2026 21:02:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 09B246B0096
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 21:02:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98FBBC1DE6
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:02:27 +0000 (UTC)
X-FDA: 84531981534.04.DB55EC5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 112B9C0006
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:02:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DDJ39niq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773190946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RvAbjVgOPJOfkhXnx16nm5VkIMplS6LXhC2/NWkncxw=;
	b=tPjbsF/bocg6cRiseZ4Ofaff4a8sq2QCpLCekPfI4tFMLcPAA2X3QRV+dnTS89vCgXeMMF
	0dlXe2Da76/hamZSV+58syhiDl/m22hlqbDAIXrvfoTj8l3ijSNlWggkKc7xyPDF7zNYWj
	ettpNzG/Y1omy/eLTYZ0sIK6hxkZmPs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773190946; a=rsa-sha256;
	cv=none;
	b=l0fmqhY1Mafz5Qs6nkjjLo2UAe+Acc8sMBAbl55y2mZAsjvVo83Eoi8Y9ORwrzd7zH5j44
	bwK1TG6CYxmcz8/1otO8N2nZVBs2YYBko3nf//moLEEZaxVg5giyh3rur0LjqQ7lEodq5p
	sZuvFa4LsdPm9bm/SeTj7yUz149Xm+w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DDJ39niq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7839C60054;
	Wed, 11 Mar 2026 01:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B8DC19423;
	Wed, 11 Mar 2026 01:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773190945;
	bh=we4i7ziZO6kLsqvcAHMYtzXyERLCpQSm8acjuSSDEvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDJ39niqZe2VuO/AOLrzUooRI8Kka+AUG+I1QqX+ccRej9XGpX1EbT70usNhhk0WH
	 3Hu1gO3Ih1pLLyIG5cjeuauIWOpNPoeNBimlhBzm5QQn83fZQ4LEjsJahWO3pg2IBG
	 d30nTWCiO7p4rjwOuPX9iWX3LM2+YsfD51tEFGridpXeu1HHs2AId1rxRc/7st1xtH
	 Ry6XiQ2Y6xcEi+GZAo3TlYGrvKP1Xx7rhkNulXHlZxZXAelXAkKYShnmXXZjcV5QWq
	 UENkuT2Noc7TmRmYMZ+/Y3TAjnZ32LzBvpgcmcA4px9sZ9QEMRYqpxH7t9TVwSz9dg
	 zKGepBss2dzGw==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/4] mm/damon: Support for synchrounous huge pages collapse
Date: Tue, 10 Mar 2026 18:02:21 -0700
Message-ID: <20260311010222.90548-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260310162420.4180562-3-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 112B9C0006
X-Stat-Signature: ydzw33amiprr5nfzpqrb85eced7cujob
X-Rspam-User: 
X-HE-Tag: 1773190945-614740
X-HE-Meta: U2FsdGVkX1+gv0AXb3B0mvL6xAW0PGtMIA5bZSDf5DSCi+LkWeqicmvcSVBqo9yiS/DSywGB0YLtLNUANeo2Wl34iyGgbhJDQNgKH7H7+0JJjLZqnrx77iOb6c8rEiibAJaepaJqEEf31yrUVlccJ9XuDVzL+mqjGDLJvsK+D9jIGwQJuCjbJA3q9vePXN4YX3L9BiCrJ8q+yPSWOi6L51jAdhaVnmFQrAyuSbYxESATTi5z3w9WrTC9zrTYOnI15bWP7Q9uNK9XsJsYLMcr3/x7+9yBh4iuh4+6SOGEWJBqm7ebM1kM7Etqem0Oei/nRiZ8rlqOvTcl9hrcX+w1EkfCXJnN/ihpR0RZuLzO2yI4PPGjMIHQc0++9/hDswx4mYTwEIMYZhQdZY+OH7/VciQpZYCRL/oN6aNTDkG2JbTE5yo7yJKQ1CvNRAoAirkXvrL4+utpDf1xP8D8LnYjpdVcv/ifPv9E1vCPO+NUXsbAgLXWf+KHokLaFYrqrj66lSoNXLGPi7HsrS70T/zgthuxmTag4+yOx9yarPmkCfi0YZf35IlFsuiOifrPymJvyJ4fi2uHl3GHuqM22Z/M4nHgOUac2OYwLhvdr39aWFP8yz9Bt99BEdZ+4Effyep/jViq6no/9MKkpLa/l5rKuCxjQGcg257sRpXvhkvw4o/AwlNohEhan6WTFDJ1DLMsjorxVI5xCGtVeUfCJKEd/EbsRRTAGwzeKa1XuxUlnHBE829jHO+FY5d3lfVP7WjzD2d9rfrE6YVgYh5OjDhJG0003HhsS02qu9goQF+RuwU5pfM2wqZEZBZQUWC3tzG3+lGveKaguFw0eWu6T09fxSrD8Z+eqBL9173KdfddNuTvyzky8pETtlfd0tk/HjlveWpIpPCuDzBecamMhwqCsXN//6W5o53Am1uMaQiTiYANywG7B2IsOMoQrhqYaq5WNDW4B9iJEr5WguSdihN
 /XCm76c+
 6WU5xtqKfWsez3w6zIOOcH8nokU3xknG0DmI3KRy+jHOWyYTdzSKhwok9Tl0ic57v37MRmnY36vEW9kZCwb0eVg2YZ4gqKzPOJhmX4z5+jagIY2mlXJv59ZDdG2SlmEZRkHk1pUHmeL6wFcFA4VG9g9GpPn5+fPgOVWyro6SnSI7i+lMvZIpioVtMBE/eHLJOn38XVlxBNNKwLOrWvUQxhzbGsg2kH70Icp5qSts4EgaQBaOMPigO37KHBmPoYfcAMfiyvCIqzFzVMbn5gmBWhXNyAfvtXluBjiePuiqsEImkMxmZZT7ebjzh/toGGoYMGBwQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 10 Mar 2026 16:24:18 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Please add more descriptions of the change, including the motivation.

I assume the motivation is similar to MADV_COLLAPSE that aims to make
synchronous and therefore faster huge page collapsing impacts copared to
MADV_HUGEPAGE?  It would be nice to make it clear here.  Also, if my assumption
is not wrong, adding a test results showing the benefit of DAMOS_COLLAPSE over
DAMOS_HUGEPAGE here would be nice.

> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
> ---
>  include/linux/damon.h | 1 +
>  mm/damon/vaddr.c      | 3 +++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index a4fea23da857..a9cf17b9e8fa 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -142,6 +142,7 @@ enum damos_action {
>  	DAMOS_LRU_DEPRIO,
>  	DAMOS_MIGRATE_HOT,
>  	DAMOS_MIGRATE_COLD,
> +	DAMOS_COLLAPSE,
>  	DAMOS_STAT,		/* Do nothing but only record the stat */
>  	NR_DAMOS_ACTIONS,
>  };
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index 729b7ffd3565..36791a9a1094 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -969,6 +969,9 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
>  	case DAMOS_NOHUGEPAGE:
>  		madv_action = MADV_NOHUGEPAGE;
>  		break;
> +	case DAMOS_COLLAPSE:
> +		madv_action = MADV_COLLAPSE;
> +		break;
>  	case DAMOS_MIGRATE_HOT:
>  	case DAMOS_MIGRATE_COLD:
>  		return damos_va_migrate(t, r, scheme, sz_filter_passed);
> -- 
> 2.43.0

The code looks good to me.


Thanks,
SJ

[...]

