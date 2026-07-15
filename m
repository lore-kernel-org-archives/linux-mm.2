Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 440FCC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 03:33:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C70B36B00AA; Tue, 14 Jul 2026 23:33:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C45486B00AC; Tue, 14 Jul 2026 23:33:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5BCC6B00AE; Tue, 14 Jul 2026 23:33:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A0D56B00AA
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:33:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13C62A05C3
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:33:32 +0000 (UTC)
X-FDA: 84989591064.20.4455F5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 739B4C0002
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:33:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oeIXtBkE;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784086410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EyyAlf2/bvw8+peozXRWIsuWIdLEd+I4yooKGgPuwrY=;
	b=zMEPurFyz4d4NUFLW+SPSDJazGNIVmxDYQlnECaKpT+Qum+S2KYU8fU/k3LLn7jW9eNGGD
	KGw2cfSRNY5VWaN4qsEl8H8yKWlOjnIQSTQ8dJy1uov1lVy7YLeNU0/I882OQ8q2JtUw/Z
	LcoVLM/m/YFIRkYkGmjCBtSedQvfxhI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oeIXtBkE;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784086410;
	b=4B76Ivz1zm43ix5f/ApwWCqD9RfGukB7Lx+l/ThO4UfncarLIQd0gbwfINuN4Gn88NC5fz
	O/qMMZlp70p9Vg4ArNCqumL4eTTpbDiK2mJnFPnfOk/eWuIXFMJyLPhetSpzTiDuXht0xt
	nnN7AV/6W/5iT4V/2pM+8VxYbtLnSiM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 62B1340A11;
	Wed, 15 Jul 2026 03:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E4C1F000E9;
	Wed, 15 Jul 2026 03:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784086409;
	bh=EyyAlf2/bvw8+peozXRWIsuWIdLEd+I4yooKGgPuwrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oeIXtBkE3A5Lq2mlir6pP/PdAqoOEAqfMo/wK0x4C107XHmtPGKlJfJvbPlDeAVht
	 uGvfAw2E8GxgcDo9kqBuuX9oYCaCXgRRImmxDlO8dFYQB86C0Uf9wYVS1NOgSowfF5
	 m5nLi5oOg+2vAjRUz/8y4wsB0zRcoK0VPpcfjGidXzZHhgw8X48oCZRJ1NngtIJoJh
	 tp7RvK5lLTtHDgueVMw0pcGve4dP1ZcaBW6wOUiBBSCWSuTDSpLVGQtqVP9M0Q1OhL
	 h9A4K+yzPxth537CM9GHWQ32wlZpx/JlSrtTSkzYwjViyAjYssik1I3v2jzGaiRcNh
	 1dcGOPXXqx9xg==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Fernand Sieber <sieberf@amazon.com>,
	Leonard Foerster <foersleo@amazon.de>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	SeongJae Park <sjpark@amazon.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v1.1 0/6] mm/damon: unurgent fixes for infinite loop, NULL de-ref and races
Date: Tue, 14 Jul 2026 20:33:25 -0700
Message-ID: <20260715033325.109466-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260715031002.108504-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: of7dydxzx3jypkmomki9whzzf5nxd4ys
X-Rspamd-Queue-Id: 739B4C0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784086410-63331
X-HE-Meta: U2FsdGVkX18SyePIIz9VBCiG+qrEpQHyePRuA1ZvI1+5w9FoVkj3FnVUAFmtxOfkcmfnyDwjOwJVhtPFntKFJAjWufQQLd5aUju0XUSQn9xpKkilKO+q5T6mHtau4sRttlt2sSESXdsKdD2oRKyh49V+NpLNhOFP45b0wnAUE1GApfpUozA2XYn9G4OtkY366hgKkeTQmk3h29iHG4qDZfKT2oBkiUk4FO4WgU+anQFdviuTUysKI2lQ6XCiZROwz10OnnkWM+tLW7H+Oljv1iRykiDQKJQg1MeBdhWNfATgJQ1vB/zXuixkRq8o1cuZb04LJsq8K+Cz7zGX2BTJCY+zmg2e3dJr3jx9b/Zdocz8O/4iow4s17/xpCQ8UpH33trDmxidUa8TayC5fkKORrb2i+zOBdOaskoHSKAoGxrBSJI6N6LnVxuLQ8QCAe7S+BezLJTG5Rj1riA597qvJHNgiWIT1AWFmv9iBz+Ajg9XKEg54chwxFwCm5bUFk3veKkmHbb4gqmZOavyAEWuJZBmmXyMqSHXUlyfowNCeJrhZC5Gf8IiTnFeXf842/wlQw1r+CO+Enhwn0L8j+mWxfRFkfX++1cAxKZRrJOs5xffRauzszVpWtfyEQmuc0A7yWcpTCNg5XJWSV9RpfZmNubvwz5EV9iVEtPQCdbeLQ0vzKBEMmSwPwbCHR1b2hwy3RdEHAtGvXgZxEY9nxfD9iGvBGQ51QOvw9cnDdiGLUdlsLj+CKfWM0oVh+w5GTsE5RkbO+EMxDZz0jN0/tLB4b5F91DEvKAW9tFX6eQHLWoasc6rHiTj/w8FntX/i0Jo49PVQRxfPt7BICGcf4VcP6nXrBVJUpUKkkrfUkZy/ApDmE+AXv6fZT4bXxitbnH7svH0y/PQueEHZwpnczEmK6wcpBVUzdyCpTXvLpeu8KWMnWLIZZn+esLqZH+9AxcnRdw31rNjNlzxP3PP2wq
 /bqiBXe8
 uSXQEufaqnhv107uhc8R86I9CulXHVeSakRIBvYzKpxCIx21Gyi/mT68R/F3LmwbjpeJ9Y0Kv86xrgtYPTXrruF0YCFdv82n3zoz1KfrxLBXf219Ya3cV1r9zqFVKWog6gJWsnNwTrNGWIMReaX6IBQNZKXrhZtKUpBoT3tdaxGTzZDRAKIkRWeAWP6n+1p/q7emXJ/pU/Z7e3VKnTedmNy91ljcuho2xTVCEUpcoKS/EVEA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 20:09:55 -0700 SJ Park <sj@kernel.org> wrote:

> Sashiko found a few issues in DAMON that could cause infinite loop, NULL
> dereference and monitoring results degradation.  The first two sounds
> scary but the infinite loop happens only under unreasonable user setup.
> The NULL dereference is only in a unit test.  Monitoring results
> degradation is trivial since it is only best-effort, and those happens
> from only unlikely races.  Still those are bugs that better to fix if
> possible. Fix those.

Sashiko found no blocker for this series.  Sashiko sent findings to damon@
mailing list [1], and I replied to all the comments.  Please read those for
details.

[1] https://lore.kernel.org/damon/


Thanks,
SJ

[...]

