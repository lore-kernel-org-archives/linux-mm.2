Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA473F43849
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 15:33:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 516A26B009B; Wed, 15 Apr 2026 11:33:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EDF66B009D; Wed, 15 Apr 2026 11:33:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42B756B009E; Wed, 15 Apr 2026 11:33:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 30E0C6B009B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:33:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F1AF256AA2
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:33:33 +0000 (UTC)
X-FDA: 84661184706.27.413A03A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3D5718000C
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:33:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lWpW2QMV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776267212; a=rsa-sha256;
	cv=none;
	b=bTBqkc5Baf5tmBqgAM5d19W2reoByv2hUPQBr7t3Zkd+qRlBf0+rmfpU01eMFl80cXouwX
	3q8cGEYTHhvx8Z1SqnwCU3xFrXwvhkT13I3vvTF4n+7yyBp1THrIpNocjh8mWNynF7QIK9
	pFeqzCPiWjIF4v+qlmJ3eHRBHsrm42g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lWpW2QMV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776267212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DfA8inAQseMT4uOWWqZi2g7Qr+Xr3vfYUDoUVm2pbUE=;
	b=lShEYdlRyR+rg1Dr0996hcToZQlJI3rRwWbpsU8cY36tV6WJvW3U/Q0Q8sRkpTx8vPGS0b
	Y3nADdo34Pkdl1sOpPZtjltV6XkArgACwWXzUrJGWQl2gnPt8vsm7sRHp62JVNXF/KbZbB
	ieBol/u4jRZ61x66t5njKskGrEI8ttU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BFB443DC0;
	Wed, 15 Apr 2026 15:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62409C2BCB0;
	Wed, 15 Apr 2026 15:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776267210;
	bh=5iSJ21jt8A096762lSSEqHKiQbTko+T/1gWDL+VsJhc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lWpW2QMVnqrPqV52iCbIE0Q5vJ/VssW6B5qHHpFi1J0Ob/OGEBk7XSqFURNnZJrPB
	 TKzYsbSWfAMTdt7zrCmOsKbmVJAZ4bUbUsDvhmT38f7mGpIlJMgdcvkm8nzQI1D8HI
	 QzJE9/fWgqZt+F9CTU6b6yDM0ErRHVKcZPy9kabfj6m8pPEvFWyJa5jDus0jatkTjk
	 3Dkz7F/oKgLUsmhK1ELqfk615zaqXUpMUznfvGRXM4t4myneHhoShcQqpU5qs2MY3z
	 82S1UefZgZL0yjtULPOo13GSGXaixrSwAUd4hAiNyMTL1LP2YtsIWI80A6aTzk9Gg+
	 urbFuAQO419ag==
Date: Wed, 15 Apr 2026 18:33:24 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dmatlack@google.com,
	pratyush@kernel.org, skhawaja@google.com
Subject: Re: [PATCH v4 08/11] liveupdate: Remove liveupdate_test_unregister()
Message-ID: <ad-vxPZG_d8KsxDC@kernel.org>
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
 <20260413185127.128180-9-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413185127.128180-9-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam10
X-Stat-Signature: 36agfc6kc9oxb79wfsfyxmn3eowrg7bm
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D5718000C
X-HE-Tag: 1776267212-314250
X-HE-Meta: U2FsdGVkX18B0AlCvHxhj/zf6AfjkzdPv8KStvu5OutXVAlKqwLmo0COmV/o8EFzoEk5w7I0qXKgC9G36HCDvXrTDQYcRAGmiEcz0ZijPQ/GBz7NsbnnXsMaggHZXO23g3uYG35cZzIi5pr2mQAr8KsJvGYcQ0VSQON62Wl+8rAt2cB6GrYsv7wE+G9CPBSS/Oh9kUhR6PqfTGUZIgVyE30mLFUK0UtE9StIKbgly2Ss9pyXerpTFrBVhkZKVmyXHKi3cwgF2g8Udgb5MTV39aEVNrA7ernQB0ffpVv4+58pBGw8JRDo/U2DQqfmvgQnJKLQ1QJSzEEJo3otNKTBYhdkADiumi7TNL+4j5e4T3NKR+dY3dGCwXsf/85Ynmk8r6aKz4OuWAP6HMzIAchqsleiGRr79JGFsSq1QBmgHachngTa7YsX0bdlucymsTWSZ+MQNKORtjH2N5ivm8+bvsauqvbeVxVgoq4/WsRhR27cUhZy6ezcOA21efgxhj/xGgu8Uw8+kc/Yp5OwJ9tgq7QqLHz8/p401ekkWYbq+kqRl/9kBz04FHMN1i7XY+ioB/IPRb8eyVDotOsSXhd7dRyorpPSOuVisE7pw5XY3sfkaYhlQY0vYTtRRegO7cu5Lm4xPnS0/rRQndmnuvQPpdgBJEDzSeMB1AQ7ae0VKvlQ8xHZBdqy9Eg8OoqQRHJG/xZ4xVAWKxD/qqoxl0AE2anEST7zPeObjqf7O+OKNnbBToShWeDuJGHneAdac59Yb3/z29gzhG3IBZGRaPpvFXvxE8+IN/IN1vE8WfOm/N0SgiHvbcPUi1UP8I7dNRXG3jnCsEIdq9ajFqzBOSHicbwrre0+cvI9dU2jr9WECnBK4vPAvJKeLY88T/iYcD4WVEgOzjb/Qw9lH3/xVPKXVsxg0cPZMCoPF2sQ+HdRxjY47nNHjlL0mfYfrw4/2R5BXf4EIZoEQlvQ1XMyaqB
 gCRuaPRh
 AV0IdZ7kEbVfmEiyLvG95QQHZFCTx/2BUL+KSrCzDYKHcmSrfDdWbB4i820zM7inadKfMhVNgs4oPCXoxGb65QliTZHK4QlpFNWNPLT2rKRoMVP4oOlygKUtDTNm+Rxsz35L/vq3NWITaexkmOTRocq2H43yrfieZKuHrj2/dgwxK/lBBVaw7tRVrqYAqzOb0nBUeZ6J2FvhwOPAB0BXFiPhWhvcRf99dAMdBD2eX6A5Bu4YQt2UGDTv5huyn6juVNu3vUqqbVwb4L7X5d/3Wiv8mBkwRXvE3PVIbHYHEZNlo6LF2CyHU7I2J11CBtxT6TfBYQzWHGdFJm7ZMANoohyDw0lzQ5NMtaImqWf/F9y3IVSDHGqp3hzGRJtZ0yWe2r+UY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 06:51:24PM +0000, Pasha Tatashin wrote:
> Now that file handler unregistration automatically unregisters all
> associated file handlers (FLBs), the liveupdate_test_unregister()
> function is no longer needed. Remove it along with its usages
> and declarations.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/liveupdate/luo_file.c     |  2 --
>  kernel/liveupdate/luo_internal.h |  2 --
>  lib/tests/liveupdate.c           | 18 ------------------
>  3 files changed, 22 deletions(-)

-- 
Sincerely yours,
Mike.

