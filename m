Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24518CD6E75
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 01:09:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 782516B0092; Thu,  4 Jun 2026 21:09:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7337D6B0093; Thu,  4 Jun 2026 21:09:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66FB56B0095; Thu,  4 Jun 2026 21:09:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 559676B0092
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 21:09:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0E8B163A1E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 01:09:54 +0000 (UTC)
X-FDA: 84844077108.27.FFD2BD0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 52C781A0004
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 01:09:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aMAgH+Bh;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780621793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ehBAQB/RsO81o3Ma8kEkus27EmlKUL5ZUfOMvorCwK0=;
	b=0lpfoULr7weR6QQmWY/BRe9rTwQDH3v7FyvMo9VC2BbdIl0LYDvr7SGEFKT1U20HIuKA+Q
	Uk5GwSrgzU1InSaCQVpvkR+kRoJm5uTYlLm6yXOnQAm8PGcCPOKnqAlJgegTS/YMFYkgMH
	eWqHiSCTG+Rpy1ytj/oNegRisaKURfg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780621793;
	b=yYp+l++vj0v5gG+tEdnv552Ae2vUbuk6zf1HnuXg2Ww7xbASw8ez63X1H6jNoqBlM6moyl
	2OkVbKJX5LGynqLnItybxD2zKUEerNPaHT2abhuSU9pSZD5LlSecFTfPfnijAexM4bYteb
	b1+9EBBPJZOSgcM53KRuuKUxvGD4xyA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aMAgH+Bh;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 72C704098F;
	Fri,  5 Jun 2026 01:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA32F1F00893;
	Fri,  5 Jun 2026 01:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780621792;
	bh=ehBAQB/RsO81o3Ma8kEkus27EmlKUL5ZUfOMvorCwK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aMAgH+BhEsSGaCBYIVG0k4dRchvDozpj0/FIxqNz7AuPpYa3/7EMkJ7hltbnj7KrQ
	 xSy5IWO9qIiNg7rHODI68gv2NW2vZ9Ukkf2y8H2EHqJn9QyyEMcSCdX6dSmZI9RbJM
	 9HCQ/HL7Yb4LYXz0LkNphSp/2UqSVUJMLpxwtvHfl0pC5dG5GgBjy86n4RSplDYCJa
	 KLc/0d6sMf/e/6YMdNKD0biEFheRplzVK6DBvL6UnOP8NlH4h4XClouPXct75IEm5V
	 ztSEB0li5CoGbLnEISo293OOLUuCiD4bLmvePEaKgQPGKJNnbKDm6bChTbAtdHg6FH
	 usnaoq2j9BAHQ==
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
Subject: Re: [RFC PATCH v3 4/4] Documentation/admin-guide/mm/damon: add DAMON-based Hugepage Management
Date: Thu,  4 Jun 2026 18:09:42 -0700
Message-ID: <20260605010943.83146-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260604150338.501128-5-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 52C781A0004
X-Stat-Signature: eeufgf5y38tmtxkt3fubjujeq9e16xbh
X-HE-Tag: 1780621793-477055
X-HE-Meta: U2FsdGVkX19XE/8Ps2IknqHlzsc9CsDa0dc9KazvBx3XgHbvpbMq80mZSGxXyJHjOGdBSt+eWz8g/7WeJR11UgB9ziOXg7EvrvdvrPQNRpMbxTxDrTerWH4mypbidHWTk+rRs8d7PAOtZqu25kJRSyiMHPeHxnus94nD/GyZId4h0udfBNTnmt/+EhAx5vJtO71jiuF/3koX9MUGtIDJCA2BGQu/J6ERuiyQcyrdCyTA5xYBS0KWV7mIVHCue4ksdxy+B4ZmMikKE3+kQ+l9hXZtTWHZN7pc6tdldmhPxSjVNWlUPdZhsP49sjdOQD5xRoKk7GU4w5hcAUE0Ee+KfLlQYjF5XTBej534EQT5y8+WBBKyE3om4hMEmQARE6349NBofCmTKtCBi/q6/cIOVCMZp73uj6A99GsWahU9CvG19BAjJzvQPagEY1OEmBvY53nAy1iwtMAxWFE2jSTOX8aVxVCA+8Gj1Nmzqq5fwpJccoJtSSTt1mQvvuuaiU/C7VcydH+Izt/BMnsk+RjWZ05/WY4WrGV9qmqp3l2mXcKA617yUQDrFWz4zFVx2b9H3deNqjiM9kYnUhM31V8USdzWCjZvT45SIFZsgVp8Qeie2jaKi1qzos2V62H8o1Clhfval2kFvA8oi31crzQXM/68X4Yb2BZaadv6UbuL8ywXtasLcIRl0yM+5kIKqTbObQRgL7JVxBZk0xhQRw56IkMmymHi/eZCuU/qZbxll9evz6WKonI5R58h+xe003SEkMTMUS0z/HgMFefsZuocHokJoJbDCNfSUn8SUwxXRP6sR8ECM6ONIcOSuS4dh5eMyrzZrkWcFhECKUNMXbGytFWisRl9J98bNs8iU904vKXu6/eD94W/69/qzJfHO+9pTw+vaLYieUrVlb5fEN4U6NAcksKy4QkECPG2dc66+byMxbIhdhP9A9NhoTwI1JxLEpw1IqKDyQu9unwpYYN
 EBhKiH47
 5BxhgfQLCTEq6P2HQKLkd8DLoiLB4iMlcHEBVvqrnesMswTNMZdnAdhLkwE0fEJsiMa3eFXfJ7Q9+Gvgz0nB6I8fFoFCqu7lpkk3CNLEQ/IW13l35HE7dTKG0EnX2gonu6xeW6DbBpUK+De8DHaD2R3JqPa35yxb+QY+EzvLQkOA9bw5UukGbJ3nnRtckSAJK2sfr9jO7S7oHrvK8MWjjQ4maNOVIzPwzcLID6dfWmpKbq6457jF27SXuaSlv2ndy035qWUVWr3uijO6wKFdk6x2VJaljExmprD6YU2FvewVziJ4nqdLfCXNf4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Jun 2026 15:03:37 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Add documentation for the DAMON-based Hugepage Management
> (SAMPLE_DAMON_HUGEPAGE) feature, which automatically manages
> huge pages by identifying hot memory regions and collapsing
> them back to regular pages. The documentation covers the
> module's features, operation, and all available module
> parameters.

For sample modules, I'd like the code to be simple enough to be able to
understand it without a dedicated documentation.  Apparntly this documentation
is made since you were following the pattern of non-sample modules like
reclaim.c and lru_sort.c.  Could you please make the sample module simpler and
drop this patch?


Thanks,
SJ

[...]

