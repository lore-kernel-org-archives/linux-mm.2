Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 826C1CD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDAB06B0092; Sat, 23 May 2026 13:20:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8B8A6B0095; Sat, 23 May 2026 13:20:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA1AC6B0096; Sat, 23 May 2026 13:20:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99E906B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:20:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4429893D36
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:20:25 +0000 (UTC)
X-FDA: 84799348410.27.01275B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id B3897C0005
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:20:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hdBc6A0b;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779556823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cn46e9sP8RWXe4pDnVCTwvbROxd5cIri5X6KIHPGG44=;
	b=K/wNfFOdbXb3OYvmqyiwomoplelveKxBOBRfNfDg+qcJSInJwRsX+vMsvifS3pQO0xuA6l
	vaV/cBHKuM1Qg+W9f9LgePM3S0YhzG++MTUcWIsRb3Qir4mAFgIiNv1edqQdIexL/i5Vzq
	WLDEmbPBw98qq+KbnM8vIoOLcf6QSDw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779556823; a=rsa-sha256;
	cv=none;
	b=NWnsACon3spFvfQSaXtDuWoOZng+VcnL/MLt0c5/6iztaEolnzZF5j3XdAYTGj+7epCzYI
	AesValYQ9x2a27APYsZN4nkkqje0Ndnv2Q2vQODMwwJXNBRQpbjQy0CJ7XF2NkInGQbhVo
	FXf7i9O8i9SlHUSVO15KdQAb5/1bTGw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hdBc6A0b;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D0DCE43617;
	Sat, 23 May 2026 17:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619471F000E9;
	Sat, 23 May 2026 17:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779556822;
	bh=Cn46e9sP8RWXe4pDnVCTwvbROxd5cIri5X6KIHPGG44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdBc6A0bU+zDa1mr+anokMrBFvEk195l5VZkRbZje3sKTSqurDhk+5tQ79ST7ZH1f
	 UKOcqGkKlYCjuqxLFhLqMLO59JYBDsIM17pGJYIerqxt/JsaUxlR/AEu3YTVfhidAK
	 j2ga5mx13np4Oqn9IkJ9EZyP4GeYN0DS5ioYp7lIUpnR59Qc919A9BK/kqGdnI6el4
	 3d9XDDDewkRaDxm1VIUUauW+B6m4hFTuLdci78OT9wJVkMKRnjgkgl2kY/dj9Py4cQ
	 8aUBHZf60mIWYKZsQM6P/VN0ny9DDMLoltDI5C06crZFnprHxPYbZYcNXFiOUJPIX5
	 3r0ard6rWw0XA==
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
Subject: Re: [RFC PATCH v2 1/4] mm/damon: Generalize ctx_target creation for damon_ops_id and add vaddr support
Date: Sat, 23 May 2026 10:20:13 -0700
Message-ID: <20260523172014.89053-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260522145518.158910-2-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 74rx9go6b9w98jpojdfyi1risshinpt4
X-Rspamd-Queue-Id: B3897C0005
X-Rspam-User: 
X-HE-Tag: 1779556823-420510
X-HE-Meta: U2FsdGVkX1/Qlq0YsBCS709DjcXIxc2nj0FWow2hrcurUvQeg7m9ke6q5zZrzITlV57JCYhAEe0LrUM2NK9MfVWV3/HurI5TRPWjhX15riNIMpTBk8gdNqhJ8mc7q5Q9oGRZSoTUUQsIR3+IpmOWHDPwSc86fc1QAP3ZBNLJRmj4+XVgv2sj7egBgIdJy28iTnSUbRn1GHgbK5qHOvpKZUYY/q2IPIRslMamMJgTsRi+zQe7zjMiRsQI5hFUfoMAxiJ/W88N4ftS9fhas5rjz+ecXoarpTqYNiEFWuvcXiUo/YYiTfrf8WU8Eayj4KTX17VpwY4ezJFIHmiQ7yHYUMRsB5Sg1Vb5pTaIMzy6EKIYhBOdf1LgiSTze7pAv7BgmvNB6vsQCLRNwGCuo46GRoTak6YxNa+HVzJ7Xc2Win0KKWWrU0syHp3Fva9b0j3meUolEItCdKbk5/t8kU6uJN/nrY2P+cJQeaMGjFYjrrLyRHKOjnH+YBQBujdNDa7Lo9EskfC6oz1qA8rMju/wMO90BC0TgvY/oWPJ0xyg8NV2cWlXLZvUXxu9IJs8IfTBNqn2FPpWIlIu2X7mL1Hv73PrqGHfgeuPl3E0wqFv87pSpcf2/V5iI8adBQbBr310VzHEoJODPpAIJ7m8OAUN3YhpgITqaM3EX/OoFP+N/K1/VAbGNY/YiR48ngHz3XroIEu4Pep/Dhnor/YexZ/IQR8PQZ1Gv4KMSG1hf3on5irOz07ZMgNV1smNPRYrmWQjVXU/ON3cNZeUeiyxsy6nMFghEsy3s3KA4U0ydgLOISsXBCPvw03O2N4XwkGdq/yIhfdjkUn9Rd23bu/POXbFuiapOOEKLwDel3P+J1wkca3mBkLEaInm3E+E2WgNeBUP+HFOxQpFk+00DiFHwD8WF10gwyZbnhU3lmqZ4HwnmD22B8LMgL1+3JbL02dZC743Xvcf+RAFAH1QnkbmYKT
 ClQ1qkBN
 XE5mbMy82Ld3UXlGiAZ49OosAAqZwB3/ifdGiZrCIZcIA7VwlHOGoqEZuiKkoEtwaIyWVIp4gPoSEeVobZAEjEI3qty/REd3jXwZ4oV1i+E556Eaisla96vRw87LLCW7VmNUX0aWpvx399xHrOR19tu8sUipHJ0LocIKWQrURpQgZ6eKs8dRDxBJw6cGb6kKQYF0zaQfe4r+h7YzycsYW90Dj4JyuBqaTPhNwGhi6MI3hlW0nZYUEFryZyru9Lvl4CO+uMhD24pHiWXDYWWUtjj97yabQhrK53wVehOLxHf5OpkPLdHtv2imCyMeKJ+fAszy1lE5BxSCvWIkqmHoiTyz4fdcIYIbWxpQp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 14:55:15 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> This patch adds a new function damon_modules_new_vaddr_ctx_target.
> Since ctx_target creation for vaddr and paddr is almost identical, the
> logic is extracted to a new function, damon_modules_new_ctx_target,
> and vaddr and paddr functions are left just as interfaces.
> 
> This change was suggested earlier1 and it is needed to allow
> developers to create DAMON modules that use DAMON_OPS_VADDR targets.

As I commented to the cover letter, let's put this just before really be used.


Thanks,
SJ

[...]

