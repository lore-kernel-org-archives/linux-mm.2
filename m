Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D313D1099B56
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 00:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447086B00D5; Fri, 20 Mar 2026 20:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F7D76B00D7; Fri, 20 Mar 2026 20:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 335486B00D8; Fri, 20 Mar 2026 20:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 21DBE6B00D5
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:56:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2C9013AE82
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 00:56:33 +0000 (UTC)
X-FDA: 84568254666.06.03539B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4EC974000D
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 00:56:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="t/WQDoj+";
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774054592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ydc+81H7FJhTYOuGDai5lUyD52n39weC7jQMzQBLXJg=;
	b=A9z4BrQq3WRCnKYHOBUQUZ6q+O7TMD84chfKHAx1WorD6FSFJ7FQF7byx+oNwy5i7InS31
	tJGJ31BjHN0nyHtI7Mr2gW22DW9vWMWbWaZjUyl0U8Y91fgkmBiPeBet0cFA1lWX21okSA
	E1dM7E33d1O4vvRn6L4ha+bwqxEjjGY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="t/WQDoj+";
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774054592; a=rsa-sha256;
	cv=none;
	b=niWn2VS4AfmgjPFwmsfRJTA0vKk9kcfWMJFmdmVXYccCeTi2ziKwBizDPx0c/s2kq6mrPg
	pmhxU5GXr31TUycRpWNTF/GHuvgZx/W3A3PfCpWIeY0V2gMdsqB1aSVg001KkrsRr9ZQMM
	smOVZb3PFmYCiXoIOhVrPCywdzIgvjY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AA25660126;
	Sat, 21 Mar 2026 00:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39195C4CEF7;
	Sat, 21 Mar 2026 00:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774054591;
	bh=X5LAPF88+rblE8Ugn+wC0BXFx9Vjd5ZwEootGLaNZDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/WQDoj+g2goXyVhP60iGs5t0CgWyN7V18mpDPFP6D5P2HlOh8dkKjK1BEzDFiVJ/
	 75NDU9mFh/kOZWiAqvcTTZAQmwT88dvsTmLhl+9vNhUH5PCacQEztEMfCHqUakGkN/
	 Bmbgp04vjr/yxrQjf1FsuEmJqSn0AmEFLsQKXr80QmIvTxhRsCOIsA26tzVLNy6hAE
	 OJZjVx8sK6/0nFvDzjdGnOrs1BCVrXHyWdM4jdOyTmtarK3tzrKG7FariCB6PYB0Fc
	 6g3GASyo1Gvl7aBeZYajLcYE2RTqG+I7bhdZejqGa/fBXX6y/e5UQQcTR2+7KtoZw3
	 ustmc459kTnyg==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm/damon/sysfs: check contexts->nr before accessing contexts_arr[0]
Date: Fri, 20 Mar 2026 17:56:20 -0700
Message-ID: <20260321005622.81193-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260320163559.178101-2-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4EC974000D
X-Stat-Signature: 37spuxy7eb3uwq8pp9pybo4k4p746zfe
X-Rspam-User: 
X-HE-Tag: 1774054592-114425
X-HE-Meta: U2FsdGVkX1+7CRE/UuSwFud3rcJbTIt7z+884JNp5PtgP6W6z3Gr8MdFcq2kold5hTjYIKD7FWd9groWzm840VBRbK5j7lWrmcZ2zB/2vN3kDPLSbBBCd7TiDk9P+kyRf4YRBp7Ce3RuEfldPXbN6puBHUKyZw+GZtKcUUa3iI9/KsQpqom/hZlvs6PL/yQxOpheJhyE2TrSBwnfM00hji9NPE38JFHrHI6aEeWc+0MQTKA7GlOXfQp3WCGIthF4fFq+rc9KTMnifhng5tIG+CAZ0tVOX7dXuDLyep+ryA6DPZZdjKbENW9n6jcYZHVHYTgUZX9ElVgnWzJuW78PLgQpW2Wo4w1rArnh/xbMglz2zxVyBDGjILudUF6Lf+wy+NlZ+4/X6cGzsoStRs2zx8ApkNE7hoU5ZlLuuo7jMqXVPSmKMYw9Khbq/d4on9qbUvJWqeDCaW6UyLZ7EEmKnr2FRtv81QjVhHIDkEgjL7ev0WthBMyLgozsYJsbtI5NfSNWbw4AD63hqoWdK6kDcokL9k/NALcqj7EIqG29Lnor8m3uH6B2MSe4tsC8VnxkoiHXJRshtbx4w7ta4jGKfmj0NsmhTyhufI0LFvsVHTRcvJFm8NVQ769bgTRfjT2PyIasi9fDV29TpqB/rZ4/1Pim0EeoKrADL6q3O4QS3nq4N6Ol4G1Q8IqHrCrKpiNVeW6n7tXMklEz+Mofo/Nav+NM18SsajueCzEq394bA6Pz6zt1zUNKW+W3W1hcr6VbgSr3pBSy1kis940bWffrKI6IG5oPj6NI28AfxLN7jpQDLmvNHnQmxBABytoEoidw8X5JjZxJf9VxwWyEJon5z1AoDLWb0uq3uJLa0HqWPLTsavwp5tG2WT0JavM1Q6jgPD1w2Pp5qYY5OIu7FPaM/IySRoAHFaK8PeUZE0TUiLwu/ojh6wlLX34t8Ib6uK/LMZICoHy9SktGMXwc1Sb
 dPUydvWa
 ULeps5tJJeMXvMifdfI4DRIlzOrfEDoNhZb4Tqp982Gj/hdtStaVDucXASvtHCEKRblnV6WJaLjgMcTzPlS+ZjHyTrf5cd9gYHTy4LfrXwGLfPTb4QUldtpHE4RDIyiICjhTcAaQspj+iX3aGZQLcGN/YyhVm7HZoMxAb8FYN3QM2rVKtF9feeq/B8lbz4RGFvoT0CsNkBK/27rub6B0DbEP9FjzS5Maa17cuvao76e5aJqW3WlUi/gO1c2Jg0gswdtp/2yJxnFlT0fFxYPX1W9bM7rBWUI9KFVgb5/Okz+WhID9ze3dLCoq958wB34DjDKnqMnoPbgm7AqZH5WYepZ4Rvn9iQXddqm/dbeEOIl3tDsI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, 20 Mar 2026 16:35:58 +0000 Josh Law <objecting@objecting.org> wrote:

> Multiple sysfs command paths dereference contexts_arr[0] without first
> verifying that nr_contexts >= 1.

Nit.  There is no 'nr_contexts' in the code.  Let's use kdamond->contexts->nr
or contexts->nr instead.

> A user can set nr_contexts to 0 via
> sysfs while DAMON is running, causing NULL pointer dereferences.

It would be nice to explain how users can reproducer the issue.  Could you
please add below to this part of the commit message?

'''
The issue can be triggered by privileged users like below.

First, start DAMON and make contexts directory empty (kdamond->contexts->nr ==
0).

    # damo start
    # cd /sys/kernel/mm/damon/admin/kdamonds/0
    # echo 0 > contexts/nr_contexts

Then, any of below commands will cause the NULL pointer dereference.

    # echo update_schemes_stats > state
    # echo update_schemes_tried_regions > state
    # echo update_schemes_tried_bytes > state
    # echo update_schemes_effective_quotas > state
    # echo update_tuned_intervals > state
'''

>
> Guard all commands (except OFF) at the entry point of
> damon_sysfs_handle_cmd().
>
> Fixes: 0ac32b8affb5 ("mm/damon/sysfs: support DAMOS stats")
> Cc: <stable@vger.kernel.org>  # 5.18.x
> Signed-off-by: Josh Law <objecting@objecting.org>
> Reviewed-by: SeongJae Park <sj@kernel.org>

I suggested [1] this patch.  But I didn't give you 'Revied-by:' tag.  So the
above Reviewed-by: is not valid.

And this patch looks good to me, so please take my valid Reviewed-by: tag.

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---

From the next time, please add patch version changelog [2] here.

I added this patch into my tree after resolving the trivial things I mentioned
above.  I will post it as v3 tomorrow, unless Andrew add this to mm.git after
resolving the trivial things as I mentioned.

[1] https://lore.kernel.org/20260320155115.101025-1-sj@kernel.org
[2] https://docs.kernel.org/process/submitting-patches.html#commentary


Thanks,
SJ

[...]

