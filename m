Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31CC61090247
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC7426B051B; Thu, 19 Mar 2026 11:58:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D785E6B051C; Thu, 19 Mar 2026 11:58:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB57B6B051D; Thu, 19 Mar 2026 11:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B52236B051B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:58:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 687FB140444
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:58:00 +0000 (UTC)
X-FDA: 84563268720.25.EF66094
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7C44D2000C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:57:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=Br9+Q7sX;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	spf=pass (imf13.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773935878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JI++XvrAXyvmflCj+6eweqyivjRiS4U41ATQdQdKzgI=;
	b=uyFouuU61eykKrGPDyzoxPO5wfkoOsNgy9lsA44m92rl7vhSKKb2gmUXuok6HT9ERLIJvb
	Atdmd8aBpKR0XL1GYviGDWwEW/b7bFJFci/8GMVKRmZDxbz3bYSD6SPzR/JYRb5cM03BGz
	LczYt50WYT2OXjdGjcnyuUCZR2YWgBI=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=Br9+Q7sX;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	spf=pass (imf13.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773935878; a=rsa-sha256;
	cv=pass;
	b=1owtphb8vGOt10/G7rC5WXMrJPU0b39Htx7YY4xBMzsV6+9xYn4adltDdCvT1gsTHVNYi/
	6Yb/7+4uEeoajh9HdWafkawyNfuU0miwCBrZFzObIfFFdQJByLepXO3kCyP2SK8DyLMMwq
	CcYSTujuBNIVbMxRygCcBt2IRQis4wU=
ARC-Seal: i=1; a=rsa-sha256; t=1773935866; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=SPq2y71aDBZ5J/5FLM1uM+5uQdrLEHyPaM1jBJha8oL0BwSgwDlGzIcmmLeqbcPnfJZM/LSfsmc3g7vyviFpaMDHJ3NrXiBtqquP4MN24Y7q9ZR69aVLTJASBrSIsmaoO7Y+73xhXUxiKvPnEvEoFzf4kUNggWhQ2eqyQuzwfHI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1773935866; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=JI++XvrAXyvmflCj+6eweqyivjRiS4U41ATQdQdKzgI=; 
	b=Gk78sraDQakrwnl5LOsxeGy92KI/l3/eIHjUFyDeKeF8kykGow2H3hNSkGZvD9aHe7aZ6wBEDBXjFcwXc3J4WoknCr3QfLZ44Yf1AMupd6BlO080y3M5OPiFkQqE1TdwEbWXXyGvyzwADMQ4vPTplcf7Efmwas2LaBf2wPRBJK8=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773935866;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=JI++XvrAXyvmflCj+6eweqyivjRiS4U41ATQdQdKzgI=;
	b=Br9+Q7sXl646f/z/NKxlgLNHZ9m6jMcQPRBQ+sWSU9bjYuCO15iA0h7ganMuf+HM
	G3yA7uYmC/6PFk9C84+VKrNX72rQeacadUA9svCeqj9/Uuf12CqZA2VwUGktpi4LaSW
	JIlUBYD0MtLBbp54Gisjg6twKLZBT/SOr3xUOcKQ=
Received: by mx.zoho.eu with SMTPS id 1773935864062723.0335759457625;
	Thu, 19 Mar 2026 16:57:44 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH 0/4] mm/damon/sysfs: fix resource leak and NULL pointer dereferences
Date: Thu, 19 Mar 2026 15:57:38 +0000
Message-Id: <20260319155742.186627-1-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7C44D2000C
X-Stat-Signature: 1mqriyk7dsb453wkhhj9dmduuio7edqk
X-Rspam-User: 
X-HE-Tag: 1773935878-46907
X-HE-Meta: U2FsdGVkX1/4P/G5BF0SMJjJSJ10Y2Aww64PntW+kcFlI5U7KYzWc+P/LutTpaWDqLcmaP/C5yGa4NAB/IVMcJ9inybNARajnY+8b6IoHlTNVW9oUrURxERByFhfvHSZpZsRofKkGiwDkCpUttDtiZ79W02SeGmyypvHm8WThZ8FI3CVDtrmW7YEs/43pMRGvGdNPpoykblEzcIqN4QV9fMwGo3SKu1QBKfsyhsfuW4MuYJ0dqGVfU0S/1FDo6fJWlLVKV2FOSSy4MxE4rK4sI0PEXL7RozAg/L4bv/6EIdadN6CmOCA6giQYt2BufInDKRCfFrcD17k5I3WO2lUcGaC7Pp5uW+aQCDgfZXNPu4ctS1OSzvwB0uQCWDo6bYxwA4rlt0zCX+J2TI+IEQj1kgadKH+aCvHI5olGJ/QVg5XOFR/Bc7OhQl87y00Xv7Vx1ds02reIykooK+HagDYrvcC77HGZbA6a7sceQlYAo4vbvzJSEdnPZ+6MqZIPQcQO7OC9r83OgKUKuNjYmMCIvFehTCVuhXQxOv6ElI108zHODHJBbKRCOFrhwDzFK64IcV1hYxKJv7XK9xWMePbS/H+usxKXlKdzIpnahkYnf8kJR4e2oU98/5nPcjLvkXBZERvH5eEFVeil+GkFfdxfKqXHbEQK+XVE2Z8pvd8Tysb2Jm3oAV16IKYxp46jK6CREj1o/HtNkT1pZPEfxbmMumvVM6t0V+6pQE3+uMR4QCyEFLjRJdAHGX6zW3EjSBmiHheBFr1EVKzCfrFdMFCbbtI2/2TGJSa1sSB0zjmozvL16Qv2cvtumAp3GnxxEfd7wU+MZnMk5uHLeLjBUrRDNLFlcYXagiV0yOnEDEQ1T46RsoRS8RemwYbpOiRAs33q2qJDvVqAY1CpjZYYtXSK8tjeJ0QY3+kaUwvoTg7bc8E09G1jROEXU08sIJTrRriUg+Pi/3JI09ovw6aTby
 gAN7zulZ
 RNFuLiZN2QBVWbEcRrGJUC644p673RuLt1WXXzTWcYWlVx0XLiZcaVKVF75l66VnY4ioJBMud73SyRoBXphfHcJmHGh9WaE40bkNJdIXBc72Z7tyD0XVyIG0HHltHpY8IfQuWGP0wuAVhOht4haXx8nhdiWJUnvZt0NsTrtv94Ik1YtpUui+xhYX1JXk+jKn5/i1OxiZCm4YFtanB72ywTkLU2plHmHLhHjttw6Fp2XExV/phhVlnLJyUbr35tk/cYughLEj5eKmIFxBkNoXbiajqZ6+o7HtP5bvj0+0YHOQAVVhjhPnwxKf7xbVqpluUh7w1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes a memory leak and three NULL pointer dereferences in
the DAMON sysfs interface, all in mm/damon/sysfs.c.

Patch 1 fixes a damon_ctx leak in damon_sysfs_commit_input() when
damon_sysfs_new_test_ctx() fails after param_ctx was already built.

Patches 2-4 fix missing contexts->nr checks before dereferencing
contexts_arr[0]. A user can trigger these by setting nr_contexts to 0
via sysfs and then issuing commands that assume a context exists:

  - Patch 2: CLEAR_SCHEMES_TRIED_REGIONS handler in damon_sysfs_handle_cmd()
  - Patch 3: damon_sysfs_update_schemes_tried_regions(), reached via
    UPDATE_SCHEMES_TRIED_BYTES and UPDATE_SCHEMES_TRIED_REGIONS
  - Patch 4: damon_sysfs_repeat_call_fn(), reachable when nr_contexts is
    set to 0 while DAMON is running

Josh Law (4):
  mm/damon/sysfs: fix param_ctx leak on damon_sysfs_new_test_ctx()
    failure
  mm/damon/sysfs: check contexts->nr before clear_schemes_tried_regions
  mm/damon/sysfs: check contexts->nr in update_schemes_tried_regions
  mm/damon/sysfs: check contexts->nr in repeat_call_fn

 mm/damon/sysfs.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

-- 
2.34.1


