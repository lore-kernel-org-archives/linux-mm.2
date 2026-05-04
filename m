Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9D2ACD3423
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 08:07:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DEF86B0005; Mon,  4 May 2026 04:07:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08F716B008A; Mon,  4 May 2026 04:07:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE7836B008C; Mon,  4 May 2026 04:07:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF97D6B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:07:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7F88C40456
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:07:42 +0000 (UTC)
X-FDA: 84729008364.23.F53A40C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B408AC000C
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:07:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="n/EqXrls";
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777882060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ynhiaApgl9U1jsZhU+opaqgN0ctQ7akKT2oK2FBIxcU=;
	b=0VrlgM7poRJ48P8IncX4jQl6jg1LFk+rfjuCuBU2QvghkUJUM83U/R2AbBqZZnZaZzlYU5
	R9T3F3a376gdx8ZCSIcfXc26sd0352yVoQGMnbcOiV3ZZlFtmhYgDrjpSrbELc8YzYUhn8
	iGJ7GpkViGxc8/JK8t7Fpc+IB0u9YxY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="n/EqXrls";
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777882060; a=rsa-sha256;
	cv=none;
	b=xaK4IxiCqGYYUGY5Uj4FJigPT2fSFGQ0o3dzF6bvkF+RrN2RNb8/IipZZtoPXOZ9d6BI72
	Fc3EmUSAezcefgkoRW0zFnTCWoEr2qjvEcKUaYYrTaBYYVbxtVLMf9Fe7qy7FOqwDe5cT2
	r/+/CCIYfpp4l2KVzTU71TzbdDpOSy8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BA12243E96;
	Mon,  4 May 2026 08:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD58C2BCB8;
	Mon,  4 May 2026 08:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777882059;
	bh=Q1RLdcnfIfl32p3/930osbW/cb2vQXkaq39DADLSUgQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=n/EqXrlshOqWVETubhn4PlzNUbkwOYB1zINBE0bwPQ+3dVjj8bcIJLNrO2dQsHgWh
	 1fQMB58vp3B+EA8NJe5DSL2z7HNmgSNWgAPvwzCHjmDrk2W+te40qZvcvd2NhATvLO
	 wiz+KQVwnVFMEX6vXtSmdTDpirZTx9eAJHwrFYeGao3p1t9nML8XdIv711xrX4uCSA
	 IAa0dQ7yl7Se3wDmHSx4Y41FiGPJUHgCOMuaufokGdWty/k9zwMBxYGxDBWV4PF/3N
	 S+7DDo8I3Yr9vtsTga3G8LCXvDdR2dU3zo39iw9XFvtu5yAJ/uIEmCvZ3K79rxdDl1
	 mp3+OkIamYmWQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Carlier <devnexen@gmail.com>
Cc: akpm@linux-foundation.org,  pratyush@kernel.org,
  pasha.tatashin@soleen.com,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/memfd_luo: document preservation of file seals
In-Reply-To: <20260423125648.152113-2-devnexen@gmail.com> (David Carlier's
	message of "Thu, 23 Apr 2026 13:56:48 +0100")
References: <20260423125648.152113-1-devnexen@gmail.com>
	<20260423125648.152113-2-devnexen@gmail.com>
Date: Mon, 04 May 2026 10:07:37 +0200
Message-ID: <2vxzh5on38dy.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B408AC000C
X-Stat-Signature: eqkc7zzhakdxowt8h15e1bmcyipgp36k
X-HE-Tag: 1777882060-171313
X-HE-Meta: U2FsdGVkX1+PjRuXR9iS/y7m4R5KIIyvQmhjGZcmSQmCPzhTpm0/6lqToZSgl5kjedkRUKjky1XKkmrrCL4qb1QlkvLSxO1bvwOGuo/zFfVxlRk41bQqg7jsrTywuHFqwYX3LWOkdsOrLYHkrpHhbQqfh9WW1WojcbkOzpuooUdnFKX2aj9HRv7iCIlR1tJdDrRNpNsFqAecuVj28LvA17qSReAYHK6HV4HJQrBU3iEgaVsC4QWbLImM2B3rRmVAuYqZMvl6dETXs5rYQFYjBrjNBKpggKJSVgp/4EsoFsAFxgJatTHVZOcivELHk7MKu7NZ9Fa/bd7y2P9gu8KYoSroqCFaAcCh6B7bBb20cQzxig1tkBhT4GEutGTR4z3hAGeoKTC/6ZNOYJffXkDB7bleA3ihaWJuJqbZwRVzHmATxPf7fUs08lHxJm/Ap025yb1cLWJ60t2WsswrVMpkE03Vnmsf6W/nOgRf8L2Hj40zsDSRoWjGgYnMws1I1dDt0Z0z3TuiFMwTE4BNGt8QrZW4NyBakHeUF65DlqzMZ4lx7KrHg6MUlrqojax49B5vAQAAxklJsrtNoFTipmAGbdMXkkutnRNaFDXCb0sKY4VU0tQNmXvvM//kB34D2nBhKRmBAM+0w/CyKd5q04ipO1K05gpXiNLMtuwzagKCWd9iKwChQFRyXzmv449pnhv1va6Mws+EEykX1oPFRrOIB1Cf/z1FpPkLgNFlgEMFysGv9jJqIXUw34rh9vonrTK+mZhz0tP9acugqufQSiulmnO+k2hNItRCXkQAuStw1z+YerRlqHwAf5ZCxWESlDXsV6/Lj8AOOTNotAC6QMZPd8B035FZ+VKMRHWefrf6RU2ifircpMHNtzstJG/SVSUA8f7h4C/PnhEGfy33pbOH0aNH2HmKekylqrd2EZif5JO8JZPDVtDEnxtHgabZ/P8EXb+XAXdPZFQyNvZiIUf
 D1QsKJ7j
 c3jNCby6spm8KE9b8lInqg1dnJHGW8IqkJYGP06lL6iRQjuZL45FNCbqPEYVo6z3BhAiMJzYuZ0LzzpCEtcxd4SJ987uc0gO0ZXElx6vVO8rqXDY5rHraowVF8Jn5Mu5SCGUN1t2Y5fy/0XqxjyivBIlqYh5+jAK0S+n5cfTjM7Qi6ykWHQK4gRNy4Qz3xzpjiy1HZ9ttwRfEX7oyCmjBUSnmIViq7JR+jqHqlfQ3QsE+6ZsdyD6WHOAf30NDyk+Yvf/AYBCpDlBIQb4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23 2026, David Carlier wrote:

> Commit 8a552d68a86e ("mm: memfd_luo: preserve file seals") started
> preserving file seals across live update and restoring them via
> memfd_add_seals() on retrieve, but the DOC header was not updated and
> still listed seals under "Non-Preserved Properties" as being unsealed
> on restore.
>
> Move the Seals entry to the "Preserved Properties" section and describe
> the actual behavior, including the MEMFD_LUO_ALL_SEALS restriction that
> both preserve and retrieve enforce.
>
> Fixes: 8a552d68a86e ("mm: memfd_luo: preserve file seals")
> Signed-off-by: David Carlier <devnexen@gmail.com>

Thanks for the fix!

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

