Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4770FFCC9B1
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 05:29:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3B346B008C; Wed, 11 Mar 2026 01:29:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E66926B0089; Wed, 11 Mar 2026 01:29:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D40906B0089; Wed, 11 Mar 2026 01:29:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9472B6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:29:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1B1ACBA2DC
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:29:34 +0000 (UTC)
X-FDA: 84532654668.01.04BAB69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 82E2040002
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:29:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="s1ECR/9t";
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773206972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qFfkGvxOM+glpXUt4KPc7xGyZCkRoDSC4aCKdWFKgS4=;
	b=Ps9GUuE8x8hs/SRu9NLibsw/sHJDk7yyPikJzQ5Cf7cHdgcdVS7OVp2zdq2JxkGnMklnXC
	6Er+hSyteDdi0isbSVfvzTc8Is9YbWb7qw6utA/tsxaB8rpWsK3k10FxxhvOVNtLLMXINE
	mmV2vCZmyzUulBKktqQ7BsIiHPOBZ0I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773206972; a=rsa-sha256;
	cv=none;
	b=HVtuooOIJQVSqU6dA1kuQ8+QwnXB3wVcjD8ZOVMmnfU3sDqVkyOZyt9GSK1aOnZ213OE4W
	vEgHJ77OdI/5YSJ763oI+hqujV7qAyVj2ip9y0KiUl/h9E7azDQkPVcNyt1Gn7gsQa+/lk
	YS/4teM3sX9JwRyjDFbLRuN6c4gCc94=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="s1ECR/9t";
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D32E41972;
	Wed, 11 Mar 2026 05:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF7CC4CEF7;
	Wed, 11 Mar 2026 05:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773206971;
	bh=MsnD34og9TPgOPIjlBEppgUcQgWLwRdH7Kj1yj820Oc=;
	h=From:To:Cc:Subject:Date:From;
	b=s1ECR/9t3rMYltdpRky5k4tc5oi0AN31gSxiMHV1z5ZEZ26Xx2H0XdUiOunVwNmPu
	 sNxYd8F4VK4ukwHspGVYDQ2cf5gZ+3026sLj9xy5Dvgh8YIg+XSoPZ0BSCGWxZ8VCd
	 Mr92YciAtrqdr3Wuizf469sMc+u7//DVnRf4emCHMSdmlt9m6RD/u9W0owd5HBUfYg
	 FXN7y62KbjqnoY8/pJhbP1lmGzgcspQXN+M0JNVhM2NcbCJJMBCj4jr4qj2Hji+Htu
	 4TlH4JmPy8GD+nVtKBvPralqe1WeI/UFIR2/YzFjBV4n9soJlSpAP5gam+3x7T2O7T
	 XwVOuw/DaGNNA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/5] mm/damon: support addr_unit on default monitoring targets for modules
Date: Tue, 10 Mar 2026 22:29:21 -0700
Message-ID: <20260311052927.93921-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 82E2040002
X-Stat-Signature: w34j754ufyk99tjrsfd3rz8r9ffr54gz
X-HE-Tag: 1773206972-764833
X-HE-Meta: U2FsdGVkX1/35HUyqZ+HHa5Vmx1P/7HjnKq8HA8q+VZoQXiuJ7iVilHVxSV8JK1qCA/sw7EgJ9iWvLMm2trrBIJPD6pILKROQEbyGs5u4z1eoOas3PYd12dbIHa4N7HvK/OaZWKqrnxX40O5qgVI8TpvrQu13yAhX8VNYgloSinthy1lU8fmAeEQIdTqQ6KwjIb9ycev23ywRrOE/CB/JFsGRrIUFT/o7SvJD2n8WS3TzyTdwZsy1BY7FSuc9zjbdOJlhnJHRhABMV3hzf36jjarIfut6gZi/BOm/k4b924tvOgB+WqF2B+6WIPDPcHPhfxifVtAanapi44MRhfWy6zdNzhq49gWHQjzEsBwYvMhqR8YQGBRzg98MPWIm69V72ex7byY2ukdyOkFH7eC217hdJNm0mRvR1KDpaI043aFEU/OgfA2xVnPtchKYfI34kGMBpPNSEtPWlx66NlGp0i6oYLw0idk44iddaDGtMHDEJbdMayP89aSV6F+Dyw5Sb0wRW6MWQlgmTL5k6qpXzIwE3Wy/VgSg4o3Z6o1BoxVaLLZ7vzSmnP/DvdZf80bm1UtTPU4+WMzSsv10HkNGE3+k07qK6tsQmBcpYxi10EuyVmozsXlG+eLz8OMZnrPLH6dNiRGGBoIwxx3oHzYArZDVF18DVXMTozxEC8X6Omw1bzv/hAMVLQ6z1hW8+xxO+wCeLvIWY32KOlIiSTHMBywW8Y75DfEsZUuHg3jLqZv3Nm1K9prGE9KwEgDr2s6ThoQN4APmLqZ1Avts/OrOWsaEFYY3yIoHviI/KO4idZfLY9te5PPQ0Jx19t7OI4RzSJaoRhWeZ0+a6PINWKEVym3zOVtuIFWHqKv1+9FCJumpyZ0BiXfZ+Biqwshl765UFkyXUXvW8/8etJFfr11sujEGZUPJVF8EcQ0FKKsMBceCRoit0jZoV9LhyNMaJk0hlT/N9a4Ja5uwzJtcMH
 OtMXLHRS
 x6OjCCeeoMtHMipxw7QFJnr0iy1zrizJgf26NaeMIm41uBMgQvPfXd3bYRxixKDbFWBEXUrxpZAjmeQ2LuTFCzCQX9WWjHvmBF30+V1lPqcf2NPzexb8OzpXHFUlMMv+zX6+pPykV6inhEzLNHm3T/C8wWJri8vJ7Ay2CjbvuVu1mpntCpOl569zS+MACrC2J5IHsabBEhWg/6XiXQ6XqOCYkVUqakPWjs9uxqtEDtaw79istBruLtWQd7yDzUNqtPROGCOv+48G9y1SjOUmQmzRMPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_RECLAIM and DAMON_LRU_SORT support 'addr_unit' parameters only
when the monitoring target address range is explicitly set.  This was
intentional for making the initial 'addr_unit' support change small.
Now 'addr_unit' support is being quite stabilized.  Having the corner
case of the support is only making the code inconsistent with implicit
rules.  The inconsistency makes it easy to confuse [1] readers.  After
all, there is no real reason to keep 'addr_unit' support incomplete.
Add the support for the case to improve the readability and more
completely support 'addr_unit'.

This series is constructed with five patches.  The first one (patch 1)
fixes a small bug that mistakenly assigns inclusive end address to open
end address, which was found from this work.  The second and third ones
(patches 2 and 3) extend the default monitoring target setting functions
in the core layer one by one, to support the 'addr_unit' while making no
visible changes.  The final two patches (patches 4 and 5) update
DAMON_RECLAIM and DAMON_LRU_SORT to support 'addr_unit' for the default
monitoring target address ranges, by passing the user input to the core
functions.

[1] https://lore.kernel.org/20260131015643.79158-1-sj@kernel.org

Changes from RFC
(https://lore.kernel.org/20260305053918.83786-1-sj@kernel.org)
- Rebase to latest mm-new.
- Wordsmith commit messages.

SeongJae Park (5):
  mm/damon/core: fix wrong end address assignment on walk_system_ram()
  mm/damon/core: support addr_unit on damon_find_biggest_system_ram()
  mm/damon/core: receive addr_unit on
    damon_set_region_biggest_system_ram_default()
  mm/damon/reclaim: respect addr_unit on default monitoring region setup
  mm/damon/lru_sort: respect addr_unit on default monitoring region
    setup

 include/linux/damon.h |  1 +
 mm/damon/core.c       | 36 +++++++++++++++++++++++++-----------
 mm/damon/lru_sort.c   |  7 +------
 mm/damon/reclaim.c    |  7 +------
 mm/damon/stat.c       |  2 +-
 5 files changed, 29 insertions(+), 24 deletions(-)


base-commit: 31ae3f4d2741372ab511aeefc5e6898d12971fcd
-- 
2.47.3

