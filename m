Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 391521099B56
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 00:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E2DC6B00D4; Fri, 20 Mar 2026 20:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 493A36B00D5; Fri, 20 Mar 2026 20:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D0636B00D6; Fri, 20 Mar 2026 20:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2FB026B00D4
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:56:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EDBD61B80B5
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 00:56:07 +0000 (UTC)
X-FDA: 84568253574.03.E85FEED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3A1C220005
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 00:56:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RkIh9jNM;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774054566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VyB9fSppTh0v620Eo5UGjpFkrJtqzUbdNaYvIZHRIIE=;
	b=FKIAuWzDLFc/MiyJCRMEOM1SaVEn7H8Li4x69w4EPgJtUKAPWNV/bySml/V51/SGebHQsD
	UpPi/gznRXrN99KZIDk78dl4BNWKCAwg/dghJkkn+7fZKd8e0kZraXEeMGRPU8r0KC7QDf
	lBvYz+r7i+2Y9mw/RXUo9CQT3U0IKvE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RkIh9jNM;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774054566; a=rsa-sha256;
	cv=none;
	b=ZswzSa3p460tn+Cn/jKnLQVV7GuJHeWEHnThXdn9pI+mLGsRdSCR1Od2ex8x0LRWvNl6x5
	NikqYe31KLiBBYlwjycO2RwXU8qUM2PDGcP5TjQwQvVfL5I0Ka0ZZhLBUx0oS08BXW+FuV
	CXoLEvlgQDhGj15c4a2sj5JMfPbaPJU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 53F9641A7F;
	Sat, 21 Mar 2026 00:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08735C4CEF7;
	Sat, 21 Mar 2026 00:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774054565;
	bh=0D3OTJrPWzODN5QWUFPsyWLRAxDzzOn8mYGwKppQME4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RkIh9jNMiAvcbN33NpKoDi56RcVYsRXjQG/Ly1q8S3pHiaXEGQxOFSqoh0+d1GdKD
	 UHrA1YDqUJABPT8hof8l0MC4jWV5HDykfaVhcZT0KfaRGtEVYhLuviyOJOEqsWkq1h
	 0TuLyXFjrEVc/1XbB5nqDVtT1KV4Ulxdw1irqGLnThOLiCIIq5tqprTAW0fzzjGA6+
	 YlTiig/kGz4rxORLizt5DXihS+mLXcmZzEDZZUozFOGla7UZWZH/gIHZ//Gsf6bmKo
	 HBH7OxOLmLcYbwTwfpgjOw/9Y6rS3A/1X+DCL8Su2uWzQDqdAkkx8bZmDhbJkKw6p+
	 LkgQcfNpl4/vQ==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm/damon/sysfs: fix param_ctx leak on damon_sysfs_new_test_ctx() failure
Date: Fri, 20 Mar 2026 17:56:02 -0700
Message-ID: <20260321005603.81086-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260320163559.178101-1-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3A1C220005
X-Stat-Signature: mcqxi9tanzq5ukiwhwrhed3bhambark3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774054566-195777
X-HE-Meta: U2FsdGVkX190N9i1SRwyCVt9qWyi4Bp0aoRDinyKifti/m29Rv4djdOjm21QS6lm76xHU+32xkgx5nBzQw17cs1vxVDUjNsKY85IHTd2jH+Nyc8Ez8FO6V2Gdv7pRMJQsF0C3d3N9SozVqE1dD5yG5CYDoXjI8uY6OF4NEZWlE3VqobzeZKeZDB2JGlHeN3mkTmeLoEIeYat6CxhwE9apLC/FajlFyyyoIVeY7Mo72OfmbaiRAw5cGt5BKcVUoQBZaewB9b5Rkj4uNsxLCdyRXjijFwtD6T+V/lwK2M53seGHYcDPkgBYOIjEn08U1gTEZbKTX6LXuGqXHopXDKUo+a0UgENfdJNtOv2uMG2E8xjb//lsgwPv/lLxxf0AuVFZ5Jk7VH/1CHZ2j1KAUXrItQBagxJdR0cX2RFdS+sDF7zb+S2mqPU1myb/DePhpCODNurxxMsl8aHrsdsZyXkJYN3bBlEyrlmXsUe5mBNYU7kcftSrtn2paMgfTWt7JshPIUXdx50cR9uIMj2wJv4/7S1D5RTw1NW3rJjI3HTAVOFZh88KOI7bKFHvU6DOh5a7koaY59Qc+RE0wRMffyGbOeTlbOlaCm6JPaaX5K5qQ4kYGjw25hTHdJR4Gul4gMoo2KETfcypKxVU8sPqwLfPy7s04upsLxRFHQxqg9gpepXVZ5nRKvFIAgKpqR5wsBflOkjIXeUkmZWMxcno0jwnFgNECcNUasP+O8ngEVEFXZZtRdtnoeczFH8fPkf2jIcmM/uq5W+Cd8nfC0a0x9R9hunD/BE1BrYAtYm9zGO0mmlM3m7ZxKOnHFyJcWpkF3TEpMD6n4LzlKcvf9lnbKzNU6kdf+LJQyQcncbURzptucIaFwpwrfTiHEqSzvpGgAa7HHSzdX5RhYFs4lvnAn6osIhWv5tmds2yVWrF2NLvkYEnkaVSbgvEIontGf+dph/TI2+0x6zdrRG8zmlx8K
 Nh8FSCdx
 FVG+LrffBkmRpY8obdKMvi6XjCUupn4qJ9CH6CEO187BxOJMcMwDx2jk1EzRyPbOKFbbnWZzICwViSXd7N84+6zsQGAj7/+9kEazbqGuAp4zWhaSQ5DOj4TnLhwb1QhUmUt6igUrUXfQNW6mVnZB7Yic9spZX2Vj/fAX97D8wUdQuzmvexCRDTUtboWzqNhQAmlDhFLUahU4lRQRBb6a6UklmMmiJ1MwwYwQStM1sA5Az2OvRcadfa+LrqqHJuSha1P/kkc9fXV3rGMoZLvqIERC6reFC+DD1x56KgZx1qTompHi0D/NROF0j62CasjObYUbjFsfR+ODcmeB7nGMpHjY5BM2QcWaW/cXe4e3YCxoZr1ApW3ZQjuulZimOqYD2Wc0baDn0VUYzlDw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 16:35:57 +0000 Josh Law <objecting@objecting.org> wrote:

> When damon_sysfs_new_test_ctx() fails in damon_sysfs_commit_input(),
> param_ctx is leaked because the early return skips the cleanup at the
> out label. Destroy param_ctx before returning.
> 
> Fixes: f0c5118ebb0e ("mm/damon/sysfs: catch commit test ctx alloc failure")
> Cc: <stable@vger.kernel.org> # 6.18.x
> Signed-off-by: Josh Law <objecting@objecting.org>
> Reviewed-by: SeongJae Park <sj@kernel.org>
> ---

From next time, please add patch changelog here.

[...]
Sashiko is adding comments [1] similar to those for the previous version of
this patch.  I replied [2] on the thread.  In short, it is good finding but
orthogonal to this patch, and I will work on it.

[1] https://sashiko.dev/#/patchset/20260320163559.178101-1-objecting@objecting.org
[2] https://lore.kernel.org/20260320020056.835-1-sj@kernel.org


Thanks,
SJ

