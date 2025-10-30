Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 858E9CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 14:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFDFB8E01D0; Thu, 30 Oct 2025 10:32:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87648E007D; Thu, 30 Oct 2025 10:32:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B01358E01D0; Thu, 30 Oct 2025 10:32:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 97EE38E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:32:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 493F785957
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:32:31 +0000 (UTC)
X-FDA: 84055021302.03.317D2EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id A91151A0019
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:32:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NBk6qmF8;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761834749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=38VUzJ9pNjTAIjNxt/NRKT6bXR+YEwGdbJ3AbPekZMA=;
	b=evbxHjTa2oYY3kPcc5ZAVc7RNKlSvvUGbldoa9D0yc5zy4Ob/CLS++/xYfZIQAU17Ik7zV
	OJ8Z55+Xup6g6yNzUYGqyW12u0efIFzsjegrq9mHPVO9hb/h3I9MRLklXOrtMmtyNhzhz/
	dfwm0ewhb0PE8AfZuvUdQSRRkgMzz+o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NBk6qmF8;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761834749; a=rsa-sha256;
	cv=none;
	b=2hwSf2yE5ghGxUKtu08IavDDfgC4OFyj/DFaDGagOMYqkO49pCtioqvAlZ7DWcatyC1abu
	y+sVcSwiA8ppnagqwxqo0SdzxJ1GoBH+d7yNDNdOXANiSOz57ngts7a11YfFbX2jCjvyZQ
	EAFV89/nXuUg1Doq2Y0JMlPb6XGoXXA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 16FC960356;
	Thu, 30 Oct 2025 14:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9619EC4CEF1;
	Thu, 30 Oct 2025 14:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761834748;
	bh=cjreltSEJSqHTk+3GCLPf/cZs/IRqnpfQiN9hHzpvDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBk6qmF8iZEJg+NsOK3eEgkgxOcDwOqRxoIuUt0GzXQu1/XQUkUgVlzrn0hLrfoVu
	 mckAZ9s+cFfGxaxbJ1bAAJBgmKiTbRmeuRSdB8wXTBAUc7cX3LdSykrs5VnIi/r+BM
	 FrQr7oyDZ4OyL/iK8+vVgQ7h4zfAy9wttqu7be95XZDNZUPamRs7WexCOn7/3+zH6h
	 ox/b2s3MgaIsSOspUPFFWxHiFrUadpWuVyNDQo8Zd4eGAQOg1f9KSmNmhWnRdk5Foz
	 VDuH2fAjZMm3ThAZuOBQh5SVbFprlYZMpWL6SUAtfQ35pBnkn6pkADff1QwuQV5imE
	 2uMirtlf9M7Rg==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH v2 2/2] mm/damon/sysfs: change next_update_jiffies to a global variable
Date: Thu, 30 Oct 2025 07:32:20 -0700
Message-ID: <20251030143221.46859-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251030020746.967174-3-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A91151A0019
X-Stat-Signature: uja5fgwk84bwbjmkwzzax77stc3kg1iz
X-Rspam-User: 
X-HE-Tag: 1761834749-216707
X-HE-Meta: U2FsdGVkX1+dZN2v54I3apNa9iHQGOxlvYvvw47HrSniEyr5ZXF3xVfuJXseR4/l/pLmSkWBY8Jq1UoRy818MzIaTo+smQcM/a88pCuUtrLBvVnnrBvfWZ6O9Ukac4Ze3QcB5MMED3lRvd0cXBSdOvYvTtvSAsCUAYXclVSo2Av3TPMveXvT3txyBkak4g3zw2fgS3snvLgwfkx8dxhytE/ry1UFfSjyYL/r7XOkKSBwuAKTGtLnqtSVZISdSb0IEuKpqEAmRr2cTea1/V/TeP0Snh385yidse3YxMvc3bIgKG/IeCQRgxYYUyPJUDtpOD5YK0LxJqUHkKbD5oT/G7QQVDzjlfyARz1OjZqcFqvvYMPY7DLjhM35uklpgw38HfFcsA+mgSBqhP9mqBFA1o2JnqDT05He5DTuCcLFjx5oKw6hcgGa/NPRkQc81eUMLwLVPFIxtQHJ/FnOFcIriEpZzU+ZQCFRbF9bj/8dDPKhKXqtQ3MS42b543kTSAiuqOEKSxO59uvkIXM8g7/UQt6Q0T+kwQW2uoHc6XQHkqgpRyAtt9UnH6+8dQLwBudPctbkwPY7ybwhkmLXv0lzItC6SgjGHu09Wg6LE3vQPeY1g73SuAClBHZIwoVm5A0Y6YaxtxtVST8+tO3k5b9GAaOe4dXUAJWRTdoJIdg6u4hpPkTMYP1oho+uRp5nXEe6MKPACKluqozS6nnPtCzsQRvfHxlUukUSg0TxC6Kk9xG6+TXQKl71pl8ykjuvY6nqaCkJVY+aq9wSBdypAEYCiL7O17AMKsaBZPHH0yYVHKleuN9vBTvLiEBZ0ks1sUB4v/7DmYkJBLQjPt9g/wuXPN2BbP39vxWUVV9ufxQ3VXB+uo9kovfMyy1bDk2lPKdiOm9cBbOeJiO2WBs7fDH1y0vbVCYObugHMb/Oos0dS/Jvtj9B8MUSJ3vq0aYncu0I6kntVVwwe1RoOriA9+2
 objjFjnM
 KlcoZl+aNvJn6aFConmEG/9Xjzc/7rvZ0yQAt/3RXuWroP3zZAvSSaccaaN3ofnDCXAde9G+k5/8KWd4TJaDftxgjfHyZDIPwUCLgRq7NXf3VTmQaWoe1U4Ry7+Xxvm0Rrw6Atlix4GAw244iEOA4f+bNOaS+bSoHVxbasXcQymOOX2XU8q6SgBmUKMRwQSUC/+394cWRELbtcWlS025c9O93oXCeUXLQy0nTB8DtaM39mHvh9d4SGRBl4G/WNXf2iNu8o5deT4kTOOHzbThUctHqlOzdNNCT+fnmmMp0Pa+6v1YxD/+oRyvzfG72ipu2bvtB/rwHbUdSQvC7uJXykPzbFSqVZ8nqtuR3ROB5N03vShM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Oct 2025 10:07:46 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> In DAMON’s damon_sysfs_repeat_call_fn(), time_before() is used to compare
> the current jiffies with next_update_jiffies to determine whether to
> update the sysfs files at this moment.
> 
> On 32-bit systems, the kernel initializes jiffies to "-5 minutes" to make
> jiffies wrap bugs appear earlier. However, this causes time_before() in
> damon_sysfs_repeat_call_fn() to unexpectedly return true during the first
> 5 minutes after boot on 32-bit systems (see [1] for more explanation,
> which fixes another jiffies-related issue before). As a result, DAMON
> does not update sysfs files during that period.
> 
> There is also an issue unrelated to the system’s word size[2]: if the
> user stops DAMON just after next_update_jiffies is updated and restarts
> it after 'refresh_ms' or a longer delay, next_update_jiffies will retain
> an older value, causing time_before() to return false and the update to
> happen earlier than expected.
> 
> Fix these issues by making next_update_jiffies a global variable and
> initializing it each time DAMON is started.
> 
> [1] https://lkml.kernel.org/r/20250822025057.1740854-1-ekffu200098@gmail.com
> [2] https://lore.kernel.org/all/20251029013038.66625-1-sj@kernel.org/

Thank you for finding and fixing these!

> 
> Fixes: d809a7c64ba8 ("mm/damon/sysfs: implement refresh_ms file internal work")
> Suggested-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

