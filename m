Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 292ECCA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 17:12:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75EEB8E0015; Thu, 21 Aug 2025 13:12:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7362B8E0001; Thu, 21 Aug 2025 13:12:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674A08E0015; Thu, 21 Aug 2025 13:12:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 59F528E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:12:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 13C60160255
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:12:15 +0000 (UTC)
X-FDA: 83801407830.07.7F394A7
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf04.hostedemail.com (Postfix) with ESMTP id 73CDD40011
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:12:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zo44FYrw;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755796333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y26EztlYK9uZBPFzGoOcoWKsYEWbS2mk/YG+RhYfvPQ=;
	b=7Q1GxmErFquoh5/+8fEiUBSvZcNEu7TnzCNEamSAL6Gwl//OnfHBAcVXeTMxa4MeOohw3F
	waZMidUFK4VkRltkPn7jaG3r9yd4t1i5dvR9dQ13IaCXjzXE1Mfj76r73aKvpPx5EHr74E
	nZMSvAbbJF+cCh7J36TIF+iimD8d++4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zo44FYrw;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755796333; a=rsa-sha256;
	cv=none;
	b=BQsgyBQhMkuAyGjfi4QLDX8EW/PkNXFMlBjozCIL6uEgB4yek8SB1Y0hNtER9yvGyrtTtK
	4gS6aY/wiwZqni4hx71hG4uV6XsWTuJWrKyT5xHaWDB8PK6O4qNlaQiSruXqge5o4W9jQL
	gglE6SWx5ob5o6C3BTj6CQP0MTfkj3I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id B3FE5A58524;
	Thu, 21 Aug 2025 17:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C962C4CEEB;
	Thu, 21 Aug 2025 17:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755796332;
	bh=776dOe4i9IFNCui5sdgxEUAWN2RM69Ea0yYml+XCeJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zo44FYrws7fSlzZa14Ed3KDfjBJU7o4Tg1IkCGu1DodBLHFqahZOYZMWXkuwE3ium
	 tP/Bdz4HaGhwgRK6TbqO67q1QczfxtbbaW4iwafNTcU7tQXf78FeEeabCYhQ/GJSSz
	 qAf4FqTKOGZaD/2SSS3Y3Jro1/LuLkEUEwF6TlKMKx6WbrrMrkf779255bCG8XRcIu
	 34LkU5DEQZDF+4HxKq01FmLA1cdNJWG2cLbUimeSnvIwqjugDk0hfVd7EBRb7Wq/lz
	 m5OjDMti9gCu6M7ct3pfMOIUdXTW55y1ab2sCVlqS8FlzRWoytrtCEWfemmn7dzgTx
	 V1fPpfcXILKMw==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH 02/11] mm/damon/paddr: support addr_unit for access monitoring
Date: Thu, 21 Aug 2025 10:12:10 -0700
Message-Id: <20250821171210.79600-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250821105159.2503894-3-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tuikcrs9j5do1gj7gpzzu1pahgohmjkm
X-Rspam-User: 
X-Rspamd-Queue-Id: 73CDD40011
X-Rspamd-Server: rspam05
X-HE-Tag: 1755796333-208190
X-HE-Meta: U2FsdGVkX1/p5+ubN+Z2iR/LuFrh6Wv4urZV38adcwrfLhFZ2x5e5Tk964gSx7FD8ajLNIyKkwXSJS0JYUQofo9fZ9GelL49klt5NRsyxqATxW2cztA68deesQLg9kOug6zSq+vTqGzryEJSb/0acCy60iP/vhLLAPBoltBmZVn4ArsXiR5C02y0OPGoJ60Eh52s6nFB5L19jZab0B0cWv13qgDsZlglhs1Rk26io6Cko2hin9pZOTvYpGCLUqFLxFzVRpxGqNOAK752Xi5RSsakq2+FEIjHh119874m/SCu+iUIergXAE9l9VBfk04aRULdW1LoHBM+CAUIPDiNZrET8eIB0fEyyfr8K8jMxLer0+9LvFBaFfSuFonD+PPr8D7JpF8k4OwnFk8tEAjNJF+fnSvaGTZ2R3655mvuICZkyWFzZoZej/clTWHJI37NP61EyHcbLP9l9J0Zr5J2HkTRKe3Gi0eNSsLdOF8g+fGwgl0mBlMf50/ot95/VohczTyH76UZ88s9+BL2KCpKQs1RoRYfSNsn2vnK70owIPWsykspgdLkvTE6M3baHexTyz8zNMryR9JbRbG3+9k5auVPAyRX/hYDr/LP4OQwrg5mgPkK+bvLcW9Rd9XX0oAoK6VtWNn0WqEZc4sRZlWNs+lgDoM+b9RhJWnOfCPDYKwFnDM/NvsPPLsE9k1u32n2YOMrkWH0ahYEpDKb/Fqaj1qKilgGJgqFHjOFtxzm/nir/1QuDAHI7i3GR8GgrTWjCou2GlsF3/aJFyak1tOkfh2tJpqOHxn4GVslXOq5HLBG+GI+FMiftJlycTetEHEdNKmkUjPSmh8iSA+Mm1KKk6aIK651m/31yVd/Wjik5Cyp/ToiTeLrdw9R1l67e/S8AhAiMJEVpujmFRNiZ3iMquAnWNxQohK7TgzICpI2xS+5qSdOXxhBSY/MEOzLM7XEvJ1IMAeyuLA2Z67LTfn
 c2Xlbrbk
 xIYtigix/t4WD8hQCbgjjQ2tIvEo6bAuRzmnTw0ftW5lzGdCXN+RNe6FHFVUAPpTBMo0uh4R1enq3JipJ2g1HMf+W0XP9HuivaPi0gieTaE/HF16fKZd7QlJKLVQHjIKK9quYg2TH4vY9X71M9cxX0ba5GmfBwkxnltV2Cn2Rb/UxpvOewD0Kh1bjRSkEJ4yUb4yB3NUM67jUdWqsRuef6Pbf4A2DcekgTB3PkN+Y/H+hXvZZNCrPsfiZt6cqh1ekpDoQHv2/4fQucbEDOIkA/Ih9N3gr4cqGIMfapR4FLdGsMkrGVuFNZAPNVV4wzvbhagIJhBTVIJlkGq9bo7ZpoK0t3hKmWOXY6/Xm6sYozdN0d5o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 18:51:50 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> From: SeongJae Park <sj@kernel.org>
> 
> Add support of addr_unit paramer for access monitoing operations of
> paddr.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

