Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CC34CD98CC
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 00:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4924A6B0005; Thu, 11 Jun 2026 20:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 469A86B0088; Thu, 11 Jun 2026 20:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A6A76B008C; Thu, 11 Jun 2026 20:32:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F7B26B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:32:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CA201C30BA
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:32:05 +0000 (UTC)
X-FDA: 84869383410.26.43C9A49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 40F80A0006
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:32:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DxXlPK1w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781224324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i3ENLsWlXbr9jUyZwD29G+H9s7CK7T6F8TR/DsF/P3Q=;
	b=z7I9emr8cR/u/nk8Q+gh288UcAeU7AHgW+rbjJv8fGq4FH/088T3TOJ82Q4RmSwpGbJxHX
	0zKIu8G8CF770YnmJ35WcVeBnteq66xdliqTAY8oO97pHV45CQXD7WRnfryRvTlF2SiPZB
	DhkE3/L2yweglDOrFAnUEIFT+DhB1xM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DxXlPK1w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781224324;
	b=S7cfx50g3Ochx0OHVfaq5BRQAW0nAEQfDPyXAfShdYf6/4M+Ful/tiAgLVuEmr/Ner34Kj
	tlzZQJt+NUcA+T3VhAzituDEpwjFrqlPmQ7mIZ7x4p6/xh1hVEdLvd3GaZXApj/SgUcS/X
	+PUnF0HCbS7PvTb8KY6YTTgqKo6YirY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BE2BD600AF;
	Fri, 12 Jun 2026 00:32:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F27F1F000E9;
	Fri, 12 Jun 2026 00:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781224323;
	bh=i3ENLsWlXbr9jUyZwD29G+H9s7CK7T6F8TR/DsF/P3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DxXlPK1wNOHGBUDY3DKKYEUyWq4lifVDsdwRvsb0G/4xpsJgMw4y7xihUZRD1gqDd
	 IAdBeQrGa32bLkB8YfGLCd2/aC2vrY+kjU3Ec0IxKy9qTThCP31XR/hpaQNr+bV4F5
	 89g3KCd8C0R4E1LZ8xx9M9oJ+GyioTUyHFJ9aP6TnUMqghArxbgcQI4kT04wV9wPSK
	 o/cJqOkPykpCV4uZPI43UejsV4O+LU9fIskbdiCi53AQoutxkxYLNqWkHcBrFUTxoC
	 f94ItBnyhUKwKXnJhBwAew4Mt1pkD285szi+9LPJJbVrEXKqs3xVammG0DNrfm5Muk
	 iclZjYDvwirsQ==
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
Subject: Re: [RFC PATCH v4 3/4] mm/damon/sysfs: support hugepage_mem_bp quota goal metric
Date: Thu, 11 Jun 2026 17:31:55 -0700
Message-ID: <20260612003156.83465-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260611150244.3454699-4-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 7sfgikk7tbamxbbga8bwybwqhejgnoer
X-Rspamd-Queue-Id: 40F80A0006
X-HE-Tag: 1781224324-107868
X-HE-Meta: U2FsdGVkX18ip1GN/XDPTT0DBSq4FegXiFCwtrg9h/ZSCYe+hdEjaG5LrSAF6Z0Zl5aVfYl+QBhp4iEToKOhnFn3hKezBu8VyLiQhcaLMKspoCr2rYTs2J0tPrFhpdC3g/xDs+bOpwCP3QDhp9rYu54tsj+iZaalxgIlQBOkJEs8Fu2joLFmXdPhZP590TzIQobhPv2c8SiB/IJc69sbzgS/wZPPBDJVk6HN+Mw+Y07O46zXS7+l7D/1iBCjdA24/1MalLEVghkXYR+ieAvK7Xk9cdYkqYpwdxeswbqQuJUwegdJR7EVbZowAeioIMhZL9Lgz07vgSi4MuTzmmlNTbkfLDZAuW7tPfk1VzNEtpqOELvJo2UD2+OEvl+GjlW2ENwzlqFhk6RwuBRJPoZUNf6KjZV+ktxr8GSrWQsNOlw8WSAl0AjGcD2e7S+KLhV2EVPUY9x8yricMbrK0SuCz8h9zzYSia5/d2OazR1dEkapKbwFjY/nDEmBMqEUcYMPs0vL6NirdSmWIuFdZVqa2JkNZJV4sx7dMpWtEUouhqQZT9oUud8fDhPhXOhPfgUpGKVMW7BgKUKS6rOan87nwDrZz4FvtaOmm1iGgF8lAw4x3Ue5lI2NehV23B7tLqZ7scNnRXK0L1S9b4flcbFBWmtax2JGaIkuisykCgq4jNqEpfL+KgfpKyc2suuN0kojvJgKmtrGyHAbzEeh+jC0yRf7EGwjwK7Xvg5icXbRkqgjaHf7WwlxprRWJdOXejOj4pJAs1yMDfgFbq3G8/pj4QwDNLeqiE7otGVUoFsKdWDPVM3tbDukAD1v6ZFbX1343cxg/249LK3KmtspRYD0AwjpI3QMddlgjuPcjdW52FB3N0pakWetvYipKPYAhaW1Ki3Z8lbo9xi+eZX3OSlH/i1fcGBOPQquNp3gfiru7oIXtAEbGkKBNjeFsAOX1IVgqISPy4wpRnLzatgNyRS
 pgKlWGFX
 9v1Mp7j0sl+fYx2yJIiZfbyf+ivAoZY49T/2SodnCtEMQsdlydt0vYXgFlHdrG8Mc4qJeoh+uBKpv2JAag5aXhR4Fi5nI5emyz8iK3mkL673TRM8wyle0SFnwVXwNspmtydq7oVbH4UmIPdbQt3nA5Jb9D0ZUzj0bqTpHHa1MnOjg2ZFFalTztPxTkQjHvDlko+W6/1epWvvs+8jqZahXcD+kn6aSu3s8jzgASoZt/veJK6/PADXAclV/vVTKLz9uI+YZCZ97HYDDfWv0idc5/NVnlCK6ljigmOv6smlfYs8x5kaBejag8AHLyjyN3c/W4BZiRbuZnJoOSebLFIvs32wL0Q5r9UyL31Xg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Jun 2026 15:02:43 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Add the "hugepage_mem_bp" to the sysfs-schemes interface.  Also handle
> DAMOS_QUOTA_HUGEPAGE_MEM_BP when constructing quota goals.
> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> ---
>  mm/damon/sysfs-schemes.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> index 329cfd0bbe9f..dc46ec128083 100644
> --- a/mm/damon/sysfs-schemes.c
> +++ b/mm/damon/sysfs-schemes.c
> @@ -1267,6 +1267,10 @@ struct damos_sysfs_qgoal_metric_name damos_sysfs_qgoal_metric_names[] = {
>  		.metric = DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
>  		.name = "node_eligible_mem_bp",
>  	},
> +	{
> +		.metric = DAMOS_QUOTA_HUGEPAGE_MEM_BP,
> +		.name = "hugepage_mem_bp",
> +	},
>  };
>  
>  static ssize_t target_metric_show(struct kobject *kobj,
> @@ -2877,6 +2881,9 @@ static int damos_sysfs_add_quota_score(
>  		case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
>  			goal->nid = sysfs_goal->nid;
>  			break;
> +		case DAMOS_QUOTA_HUGEPAGE_MEM_BP:
> +			goal->current_value = sysfs_goal->current_value;
> +			break;

We do this for only DAMOS_QUOTA_USER_INPUT, because that needs to receive the
user input.  For other metrics that DAMOS self-find the values, this is not
needed.  Same for HUGEPAGE_MEM_BP.  So I don't think this change is needed.

Please let me know if I'm missing something.


Thanks,
SJ

[...]

