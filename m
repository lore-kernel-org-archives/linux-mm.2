Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4747C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C51906B0095; Mon, 31 Aug 2026 05:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C02486B0096; Mon, 31 Aug 2026 05:15:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF0F66B0098; Mon, 31 Aug 2026 05:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8415D6B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:15:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1C427A3FAB
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:15:25 +0000 (UTC)
X-FDA: 85161006210.17.49DE377
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	by imf21.hostedemail.com (Postfix) with ESMTP id 28ADE1C0008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:15:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=krU9Kp1O;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=JaIZ4ZlZ;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788167723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=47zEvEEejfI6CkwDkb4HrVK98gd8CjGifPChtTFi0Gc=;
	b=lTCoskBEtS+yj7M2nFvAzDLC+EbKvpK36TjL6UBbZ521UyV9dwLBMN2pRPj1n72SncD4hl
	34lV9EnfqJ+Pdtl+88TQrCvhR+J73UC69VriKy8oD9kvVvRAg/PoPFTywSfkO940CREnOB
	P1b6e20E30PYpECiw97lpxKPZvLI8Xs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788167723;
	b=QpCRp56oyWHKeBsjpRldnyhn6lj6KrBJPjI2KndQVnGz/XmMjTl6hXwaa4c4d4eTmIZ6w3
	9CO8SjX4gIapBAJwGPqYYINfTxYKA5lNm5fIEcvfIdq0I46ugE2z/Nk06lQ53uV20UeiqP
	YRtI5s5Gw24gAr9t9/twuO29EGgV8xA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=krU9Kp1O;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=JaIZ4ZlZ;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id DD1BB1D0013B;
	Mon, 31 Aug 2026 05:15:21 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 31 Aug 2026 05:15:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm2; t=1788167721; x=1788254121; bh=47zEvEEejf
	I6CkwDkb4HrVK98gd8CjGifPChtTFi0Gc=; b=krU9Kp1O+XsnhKnj0uMYAUDAYe
	ltUdOTaKpjwOJ7fFyk5l5SMo1pjfBkCyi22HxeKU1Or9YlH/7g7oy1Qu07EcuJj7
	gORts7nPSRq+lSihx89uGbL4HICzRTSeNzFWB3H8j8Q+je++jCJFkobDjrHiBFKl
	Cbw0xGeAhj6rMSre+RuonffG2ZoVYZhQYj3VvTYSuhJoj1MEHcvQwRnTFtnngUnR
	KqdDu2lvlUkvPleWk9UVePpRJJIwiurTt8hhMCSTL2vHd93j020QqtxU3a0L9GSa
	QxXZ5QUUExgQDanpkhOHLEgwb81U8/ZvCTo3oNs2yIH8L4yX4MECzpDJ5iwg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1788167721; x=1788254121; bh=47zEvEEejfI6CkwDkb4HrVK98gd8CjGifPC
	htTFi0Gc=; b=JaIZ4ZlZFRs+iz25xK6i3plYlwDb3wqwsIzWHXvhVYqcOojnA91
	QvqzMK8Uod47E+5uogwLLKnB36XDXpf/hmgDqg5TnWTtpavk2yYqs9R3mNc+oxpj
	BwC1PeHpJ5hdTA9R0nsAjAqGTtbxxcvrsVUipGhDCNz9PHak4/KHjpThECBiRZNU
	UXwxhTETI5JfeP0RkXyawFcNxP6ZCjc4KEiFtS5y6PxVcpyf1rGznFOB0IWiFbOM
	9rOcZClLczXCkm29web6+phzG6xlOPz3wIl/g0296hcBW8ISiamQcCDlUYDL/caX
	rIeaUQbGmmblUqwS19K/3z+BP8LHmmeckEA==
X-ME-Sender: <xms:KEaVapcqqqgiIScTP24N-Ya8c4Z_7C9bdi173kqE7IM1bwk-hAbz-A>
    <xme:KEaVaoljBkp7TDfm3VD4L18_NFl-2tbpgBNr_E3MnF9Swmja6pU3Sg1m36YlytIhA
    LTpFXig0oEe78e-iDW8nmK_b_Zu6nkMujq5ZMAVmAueKw-TfWMiGTs>
X-ME-Received: <xmr:KEaVarw2KG6CEfgXwmSichqEldttFxwlsjnOkddyIKzNsWY0eBayuM-65GQ>
X-ME-Proxy-Cause: dmFkZTEwmsnyprdy3iKVf9do7GG1Tdq7gTCVLlgh1ALuAyDZgoqCdetVYe8dJK8LfV9tmC
    35+Lf3uNDBO1aC3hEH1D74pFyjreTzNcjNjpnhAomht74lz/5Jmp+sWsHBmINhaoLDVNzG
    FkPRyHyy5kKBTXtsYzgrLIEBPT0ZOAIJJ+hjlad67SJPTUfA+NRg8f3BKJDvJTIhCCoXzx
    ikWrduxrsS7ksf2kwrCrofZ27omH8pbRDSAi9/wue8aNOruQrHXZtZ+4bpqByQLuxMlOnf
    yeILebFCMGA/wqWr01K7xeT5XaFs/srEFo4F4t76Gjja3jiO/mmZUBWIL4GStDCddjvknj
    eJe8qOqrogQocLvrEmVOSqCGzyMomKDShLZ2eVje73Gb5henYbQXX6ni4k38mf+APtYGf4
    f3Mv2UsM4asTuO5m/dPQidZK5iLUx7wszGKHaouh5R1UhErsx9n1DiLj7NiGitxNBVOms+
    2DNpVuCW3QBkaRiqN6ch6ZIi0ngPxJoM62zypzNv0OkoqRuzU1+1fcLGwbVkUkx0w+RltP
    lVUcoc9QahwzDwgvSeVisuijRMHHJUo5LVVW3LtPoaMp66Wi042BdDWxMs9ijPDz8VQ3L8
    Nv+t39WrWU2IAcIhqsMD1MC5rCK78619xxF71XH9vnQndBzR73w1yOJZiW+A
X-ME-Proxy: <xmx:KEaVarPskolEGc05gBNhclGSdc5G3QxPu25DQxdwuLrTnfwPPQpkvA>
    <xmx:KEaVasij4RjkF4QL9KuJN61uoAu5_2zMBqLoURhsOOCybz6JKhAzRA>
    <xmx:KEaVar_Je9KZ4Lte8KgLJDram6xWSpo5pdXkSC9uLcU9sfTavGhSUQ>
    <xmx:KEaVapLS-SUNcBxMcgpF0s_9iNAqhMHaTZkmNWvxlVSfjYojVFtqpA>
    <xmx:KUaVavha6gglV9F2Lldre_ahD5eEYlq-1QOFe2ySkWQF2V112UYwZa9l>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Aug 2026 05:15:19 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hannes@cmpxchg.org,
	usama.arif@linux.dev
Cc: lance.yang@linux.dev,
	ziy@nvidia.com,
	kasong@tencent.com,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	liam@infradead.org,
	nico.pache@linux.dev,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	balbirs@nvidia.com,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] Fix deferred_split_isolate() and drop the split workaround
Date: Mon, 31 Aug 2026 10:15:12 +0100
Message-ID: <20260831091514.1879786-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 28ADE1C0008
X-Stat-Signature: sj35n3zfdoajmpu1bh1q61ao8c444owe
X-Rspam-User: 
X-HE-Tag: 1788167722-429589
X-HE-Meta: U2FsdGVkX18p2ncO9MqTdTBonAWROpbFw38LBhu18xQPILb5RJkJI7TiNRpxTav91+g70/Fa8svzJDuPOoUtrlSMp6yzUAFAnjtLEfWD2k+V1K1F8l1SIwM0OpU/HRA0wF83lKY+KLQk4QK7bCbQozfhFS3qrluZ2U6JcmA3VOrD2t/Rewkp53ofZgP5DO2dbDVqq+jM6JeFonKKYATuHI5OBYf5S27es+gWjAqfMeJ5sw8YN+ZE7Kg1CUKO8IA8u7Rm+nKzrrEhwg3HaFKVD3C7pWwX6Zh1VeF6g6WRToHKnHVctmAvpwOFu8WoJwI9Ypcb9pxuQuvH3/TOKyz8JC4+HQvFUq2NgqvKo18irKbBrWMN2QE5dA86nAe6ipGnNy5TeReJxG0bagB9J1coxMvYxEziDXv3nPA8We6JuUHJBpT7wRtVtVxORvZ3kgFoN5ZKhZkW12BDFDMd0J+15Mw7NX9XgzQRYl7x1NUEytjaTRhIbBXY5a+gpkxlpDwf0OpIWXjd2Ta1feu4ATGI9Y2gq3kQNrUrTyRt7tpUpUnve5kChgGuzodYcd4hpQCqmSuIXdz/HMnrXDKXRngK0iBMwGJG44xuFyNLJ6l9tZXmZJLPR/vP+IWzkh1aPvgTNU/Dc5pF9TbZrL7ij6Y9OF9mk7gUU9R9yPOjxFsHZMrzwJbcTEftGL9DnA27Uez+Qvz6kJedv8kYa4BsfGNc/5Q82OPATecR1+mwaKerQh7xiM/tHEtVBI40a7xdw//uVyp6FyP0/1khRJPMnbu6sap/txJ6RdsY7z02EiWsxlUS5ZNA8A6FUlmDBed7ZEaE//oUzBGb27zrbowxAqmb7Yr6VDBvY0uNb4vUbu20YvtoN53n693/tjn5SjBOQFiDfRozLuPa7PDZrlo/mQpYZ8Ttwd8w0uNPpeSkBJK0iolCdNkKwJ60m5D8zLpue4OGh6cyUpDbx6FE1ouoGe8
 pBptRzs4
 MpTFauxMdxScR6mspzqUQh5NhN4tChMMO8tGBxbRqmxgj2sgWa6nWFl+rw5W+ckJBcF6NYmcCo3ijjLixJCnAlDd5PuqmYQQraSiHuw1pu+PF4a1Z62rEd2S0klaJeGvNDyKMQIwJ1CXB/bciJT+Uiqv/OED6wzLDsTZOyezuWRT/5lMs4ntbn8RJ+gdEBASds9nvfEn2otGqm7vCXSWy7DBNtG4++EtPwmEVqR4VnmOm9PE+ZFvZAzNN/9esox0wcRA+Zw18rO1gJ8tp1JyK84i2uJZCMulkNNDwwNCakXf3c78QF4Mp8EjsBd0bjDdmI2kvSm8qZ/M+T773+OTkhlrgJUjHBhmhEPPOAC3vSCQUUQ16MqLNot1zUnHIHKbMah56DE6Mt8f88EgOI0JbWSwQHvt7Qp4sV9UyUXynQ3rXNVbI9V+nLB2UhFejXFQOiQdtIloYeusMenZNZSR1eOk5+BmPCJhbh83fwqa7mbBOe8m5m0GI78D5pQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

deferred_split_isolate() probes each queued folio with folio_try_get().
folio_try_get() failure is treated as a lost race with folio_put().

It leads to wrong results when !folio_try_get() was not caused by
folio_put(): for a frozen folio, PG_partially_mapped gets wrongfully
cleared and the folio dropped from the queue.

It came up in the review of my collapse RFC series:

  https://lore.kernel.org/all/20260824131224.73344-1-lance.yang@linux.dev/

The bug is inert in upstream code:

  - __folio_split() works around it;
  - __folio_migrate_mapping() freezes a folio it is about to replace;
  - reclaim freezes only what try_to_unmap() already unmapped.

No stable@ needed. But my collapse rework steps on it, so it is worth
fixing.

The branch the first patch removes also hid an inert, pre-existing bug in
the zone device path:

  https://lore.kernel.org/all/20260827163838.1813081-1-usama.arif@linux.dev/

The first patch fixes deferred_split_isolate().

The second patch removes the workaround for this deferred_split_isolate()
behaviour from __folio_freeze_and_split_unmapped().

Tested in a VM: split_huge_page_test, folio_split_race_test and cow pass.

Also ran a test that leaves 16 partially mapped THPs on the deferred
split queue and drives thp-deferred_split through debugfs, checking
nr_anon_partially_mapped.

v1: https://lore.kernel.org/all/20260826162101.1314941-1-kirill@shutemov.name/

Changes since v1:
  - Spell out in the first patch who clears PG_partially_mapped and the
    stat once the shrinker stops doing it (David Hildenbrand).
  - Add Fixes: and Closes: tags (David Hildenbrand, Zi Yan).
  - Drop the three __folio_freeze_and_split_unmapped() cleanups: Kairui
    Song's swap THP cleanup series already carries the same changes.
  - Collect review tags.

Kiryl Shutsemau (Meta) (2):
  mm/huge_memory: do not touch frozen folios in deferred_split_isolate()
  mm/huge_memory: dequeue the deferred split after the split freeze

 mm/huge_memory.c | 63 +++++++++++++-----------------------------------
 1 file changed, 17 insertions(+), 46 deletions(-)


base-commit: 33f61b12d297562321533c048e034b1fb21c1cf3
-- 
2.54.0


