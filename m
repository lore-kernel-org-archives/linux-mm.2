Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 190F91094489
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 20:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9ED36B0099; Sat, 21 Mar 2026 16:04:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4F806B00DB; Sat, 21 Mar 2026 16:04:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3E876B00DD; Sat, 21 Mar 2026 16:04:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADDB26B0099
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 16:04:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12066C2034
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:04:34 +0000 (UTC)
X-FDA: 84571147668.03.87E9DEA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8B5222000A
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:04:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ql64Gy3n;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774123472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m1v4eb3/sKiatYCTeGIfEDK8lDZ5jAxx44X2YZ/Gcl0=;
	b=yb99bEJruT1S+36y60KGnJwVhBvfWyzic/NpQCnEYtsoEQZh45IJtt/FwAhfDv70TIt9mh
	CDhuyXx2yE2j7t6YnmPfxofkTVEjjMhUdDKXDynRDqaveOXSCImZ1aWyxYLVsgZkw+3rwl
	6GqJpaYwXLsjSh6cSmGI01zvTIOsauQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ql64Gy3n;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774123472; a=rsa-sha256;
	cv=none;
	b=FRZHTMee4XsayWosaxahjGWmKLnFNnfFd8SCVwEJ4PbHrKxXDAccL/XlHcsMpKljrEzbpe
	2CKpXNNA/1ty09LvhSpjw2Nj2ZKIofDCxJka5SQsYJP8ESA4EA2MbjzqXrIFx36g7WAcF2
	HNZcqqyJ5X4D5nANriecwSpOoEugJ0c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 596FE41A6C;
	Sat, 21 Mar 2026 20:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084AFC19421;
	Sat, 21 Mar 2026 20:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774123471;
	bh=fr4AW+FIvrg9qZ2BWoFT8YfqJnfX24S5Bi94dTj4oAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ql64Gy3nJI5rno891UT38jj+j5m6B1xazDxJIHtl1KbyKMYmU0J8Lds4xFCuCLfPb
	 yEUCFvE8Zv6pei+l0xdJcWWf/9xaxkiHA5zda5YRi8kbj+VjzPVeF2zD+AI1Og93K1
	 /1z30ioGxDRhqfqPEFDo4rPMJFSzybt8VdO80I7AKcOpE6twadRjmlnQBjXfamcgjg
	 Zahp08RiaxlkY6jywrwILGvh+if/lnYNkvivkkxtdTZE+/ZwURzhX2h/eIUa+fRKkG
	 oFNAFqRaIGOEz3AujWDXLV4yMwiUlbLeSNNemWXQ2S7ohefAWPHXkpoq05cnf5ZTkW
	 HwCJ1B5k3jfnQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review status) [PATCH v3 0/3] mm/damon/sysfs: fix memory leak and NULL dereference issues
Date: Sat, 21 Mar 2026 13:04:21 -0700
Message-ID: <20260321200422.95288-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321175427.86000-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k51n3ih4q1i7oumi3hiigicwburcwpt4
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B5222000A
X-HE-Tag: 1774123472-597720
X-HE-Meta: U2FsdGVkX19Twp3q4HEGIegUCLWrylMzF2DE1xqYUBKTMwvfxk8ilraJM0FlE98g/eh6CBj8tES835h3avyhOYtN3/sdpMAuTNCxk1QL2c1mXNVJ5nLe8TEXPoeXNz2ZWf5Uwsy0B2rfpoHF+XTkO1TDKd4YLDPbOqC60hOnUOIPPrXPXzGCF0oQs1KpIdslNix+JY84s4kpDL6+Ejg4uBypdzw7hnR/PvBDjZMRaz/h5yOUs49csX0iHUxhFmLdS1bYqLFca2xS5wsrARPNPwwX4tSWiivg/kFfSqGVmFuimzNAHuPm/r6y0+iQRZKH06qtyIdPfCZR0PRzs/M20/vfBfKiIZ5zFCllMQ/e7zoF0ABP+h10Vwos3Th/ty6vbpyFJHtyyCz2KEVUkgE48SZ5//JFmHcGRaPvWr9aipuiwSDv8UMVd48TNIQA1g9MAdznqZSKx/OUztVB1CY8nKcOkI9ZXR6x1kokGu8binhiUA6zjNZ2XXcZtzjck+7VUK+nVr41U9MFZItcvYYV2rz/DM83PIlkoiKrSlbYXsyCeiYRhy+HS+qJtMszqhL1d4ZxEt05GCMXnQXq5YWvIlVwkiZEM4s82znh8MSpHwkx/7IupqeqVHBqcGhH2czo5+CdspCHWF1KO8ze7vnxY/CA/BZGzQlgDueSDfHKtxP9kPjISPkoztcl1mU2zIPOWSFj1dQ46yIuRQa/MukHIJrN0NRSqoVKMr0TKJF9uYoFjfcaAqbmmWrvsCKdsmahlvLA/jg9JjAI5CSgMmRZM5FVh9O8C2Ctayzu11QKfggdG3lpExnKSNKdUXkDxEBGI8/kJJoyUnNegQHQQX0UEz5xcuTK/rYJkeV2CeHR2ZCWXlrKi/jU7pYBgYcc11nEe4aIRZ+17p/J7y4d9VYYgd0H6jHKDZe/WYcXopdVMntDdvcbKr+Xvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko.dev review status for this thread.

# review url: https://sashiko.dev/#/patchset/20260321175427.86000-1-sj@kernel.org

- [PATCH v3 1/3] mm/damon/sysfs: fix param_ctx leak on damon_sysfs_new_test_ctx() failure
  - status: Reviewed
  - review: No issues found.
- [PATCH v3 2/3] mm/damon/sysfs: check contexts->nr before accessing contexts_arr[0]
  - status: Reviewed
  - review: No issues found.
- [PATCH v3 3/3] mm/damon/sysfs: check contexts->nr in repeat_call_fn
  - status: Reviewed

# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --thread_status --for_forwarding \
#             20260321175427.86000-1-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail


Thanks,
SJ

