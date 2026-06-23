Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E15F8CDB47C
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 09:40:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2C96B008A; Tue, 23 Jun 2026 05:40:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7B5A6B008C; Tue, 23 Jun 2026 05:40:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A91916B0092; Tue, 23 Jun 2026 05:40:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8511D6B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:40:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 123091C5854
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:40:22 +0000 (UTC)
X-FDA: 84910681884.30.1133D1A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5F62520002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:40:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TAJxScz8;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782207620;
	b=sfMB7AXtD1mbmHQCSPuPqHZm4bGtSDe3nx5eKWIXG9qW4xUJGNOdxaYilmcKWHHt27q0zk
	qrvVqmLq2R/cblVz1Ppy/knoVniKxp8tkPjijXARQNXZjUvQmefwGYNsDIxVK02Bpd9ORi
	7iWg7afPHQkyTorpskX+zUDbrPW3G6M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782207620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oqPSlwE/GnTAhDYuFLm1uNzWqGhqHwtOsXDDbJf6dDk=;
	b=XybwRkZI646P+16op1Z3ZaAAPENhzI66QsK6Fm2gGWzAYwoLN7VyH34QewvmiTRWji+vP4
	JTlYEsSr8LDnhFS6j3/4V4ZrscHygNkk/u4q2+gm7W96UDsOh/NxChT0+w8pMr/OB12RnQ
	JCGaF8/vSP4//KhEYe1+mNAH5hQwXqU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TAJxScz8;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 846F6444D1;
	Tue, 23 Jun 2026 09:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC7E1F00A3A;
	Tue, 23 Jun 2026 09:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782207619;
	bh=oqPSlwE/GnTAhDYuFLm1uNzWqGhqHwtOsXDDbJf6dDk=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=TAJxScz8EZL6p6hHbdM7gpkpcSCZAhp6wy0FJkKZJ0JUVqHzTjbbgNrB/W+GJo8Eu
	 kewe6TF6w0yX+jEf1dzquEKJUccuqMuBbfFIpg0CD86WPlnIAb8Qx+VuaBf2kSyxhC
	 yTqmHv+O4l13ADleH9FAu2YyDMhGxDRTlLM4gAVTcZNecX9VnitiLqEcpvR6b8o+K+
	 6W+gnhW/MJRDrjsZOWUTtqu4nHIMnBVWgMeUzS3sDYYNwtCdYNkuTbR+Tzbiu8Fg1M
	 iJO3+7idK/BvBKud48YJfIMIbvJJbStarVkiGiF9wqDv6ESeazAZDx/cJc02HW/CfR
	 h4gM2Jw6eevSQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 2/2] luo: Update serialized data to use KHOSER_PTR
From: Mike Rapoport <rppt@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, 
 Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
 linux-mm@kvack.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260622225736.2961438-3-tarunsahu@google.com>
References: <20260622225736.2961438-1-tarunsahu@google.com>
 <20260622225736.2961438-3-tarunsahu@google.com>
Date: Tue, 23 Jun 2026 12:40:11 +0300
Message-Id: <178220761164.162773.6384380547612711985.b4-review@b4>
X-Mailer: b4 0.15.2
X-Stat-Signature: rc6ggnr1bxjk3fts68ikm5kt1sxszqr5
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F62520002
X-Rspamd-Server: rspam02
X-HE-Tag: 1782207620-937229
X-HE-Meta: U2FsdGVkX1/ciHvmhHD3W5wFRjfuTFp3xYcGl9cYXDTR2Q1ybOupKMMj3dEsOSz2MctNpmdD5HDz9Gz+RyTESKobFeyu1cDQsJGdHNjEjujGZyoq6jsHUh1bdoZSH6xJ7CgRBVyGfwSCab3vMeMvFjKY2tq81SsHkjD/087cf1NmWTvyHktmY0f/8YFFIH8AXyW1DFNpHjer4ghwaIA+FNad7JGGzYkV2wXHypyLYB+Sv2xlKzF7pCeaU2UO8BXtpm2iaLqdDimErSKLQX2D4m+Vda2UKnd4XLYosA5xyXQKrCbpFAkhMcIwnyXkKSGyxRPkhnYWyE1KWyt0bBPK3DP1HTrDWbAHP+N2Su4H5poq/uK3DjJzVLp+uveKJnWK7bdmC61LR9EBDGpTyf5mgO7SpSm71ThN7sVF7y0Sx3AyY2o46y0vlLYdB5OsSJkcJ5jJ4rBDdMwa0OfsDc4hg/9eeL72TXXg7lhsiKw+Uf4CtynI0V1UMwKKHMZnwJGBFHaArB18kg5KxjLltRe5Ek84E1ttip9iQBZwEabX/OsXzVX2dcbV8cFNevbr1uM1p0N6QnUGe8sLJBszw73HULwDfgje3u0af70G3hKQoEUn/G5Lf/2V0gImTG8oLaSDlTCU5hRDY4gxg4NxEh66dx/L9H74aYJhKhDpS8xcfxL5UYhchX6BtIyhmN2ZI/ZzgzJlMwACiu3ZUYXL6Pxj7XxF4z6fmEm4lZ8tHGCP1acnyjcg8B5TiCN7I//qWa+dhqlo+rXpcd70/KbvTUvg2P3fv4pqOf44zn5sYZ+g3N6vY0ZdlQIXxQoSAeDilIoCO7rapuUUPALASvWqCqHkyz9E4r+SDYj5r51njLt3du+SQ4Q2WA9w4BFxlynerVmtRpZQzqPBlbQ+Sd8hnAyLtXK1KPR2F72J2C+yRa57zQ4uuoTQi00p8dpe61IWxbFlsCexuvcY95LL9pNM6JG
 VdEIqk55
 y8ajTRsO3gDLIwilH3RPD31AZX/GtNoJVFfcV+yudmloXWP62HNeuXhBdGyd5OTCgCyp+dtTfB0OJa5Z1ncLGgSLORUDQ3iBCNn2YiLI0doEADIBL/dfB48mMJaGwj9l6jVncJ7gb0rm1dPWsZiHR9/Xv/LdUag1ILrZAg8UJ8+tkdXYgusDFbGBfo1VQqDEwE55B64D+kyxHBbfAN3oBbBe6q/h5YlkVscJvW51gJ+HkhwDEhKkgiHz8WmMbqRbgqMp0fl/HkeGiJ/cDkbhyPnYYLB0tLI45QUpqYdiK0zFd04kmbtfeM0yDYE+B7dM4jNmhalCuTUbPZu3NvAnHfPKfVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Jun 2026 22:57:36 +0000, Tarun Sahu <tarunsahu@google.com> wrote:
> Convert raw serialized_data to KHO serializeable pointer (KHOSER_PTR).
> This series also takes care of resolving the bug with memfd of using
> phys_to_virt before checking the args->serialized_data value.

For easier backporting the memfd fix should be a standalone commit that
comes first in the series.

Other than that

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


