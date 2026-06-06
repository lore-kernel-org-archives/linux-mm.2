Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B7A3CD8C88
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 01:19:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74DD76B0005; Fri,  5 Jun 2026 21:19:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7796B008A; Fri,  5 Jun 2026 21:19:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C68F6B008C; Fri,  5 Jun 2026 21:19:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 48E5C6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 21:19:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5D874120345
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 01:19:35 +0000 (UTC)
X-FDA: 84847730310.15.064D269
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 987361C0008
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 01:19:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eoDM6U1K;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780708773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UdZ+QI2WaNBX57biGXTDOGYvKJ+VsGHA0D7Nm4STxP8=;
	b=Du6DjwkNvJyAiTIqfpNbfxaX/yIVaaNwouwl8MKY/zBc4LbdegzHGuFUu0J2wS+hzUEqns
	iGa1QcSKY8LZzRP7MVd1UWucwCjEZt9PF2i7HISv6ONwxg8aOkzJuUytdxPMA/6EbH48yZ
	IoaV/2x5cDSeeKR1DWsSAIJLPM+oov0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eoDM6U1K;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780708773;
	b=YepGglKQFvIDnGpuoL1/CCbVVYnqZvdkmB93SvpXvb9J7oYm9iXQd2V+D1PHZt8slA1EDy
	pLGHUovTOwwo6vwAMHArGS2YW9/qSNWJZPM98xhSC2X4OapxIltotAv1iacN/FtEycfzDw
	hdzw+K7Q29zKO2j94s1PRR+xt0UfD/Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6FD6141962;
	Sat,  6 Jun 2026 01:19:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099D41F00893;
	Sat,  6 Jun 2026 01:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780708772;
	bh=UdZ+QI2WaNBX57biGXTDOGYvKJ+VsGHA0D7Nm4STxP8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=eoDM6U1KyPDBFqOmV2Pr+FAM4q2g2Yq/BLosXtZgfMLWNguvJGTsta4v7w8NKKwZB
	 XlC5uKCPXXx+HffHpFEvPWuGS+yZ2UOSxo5xoq4/EzjIW9WAIpNc2e0i7vMF9C9qjT
	 YTb5uRXbg3pJnoxOCK0t4Q8ESKLevuSWn6wFQy4w=
Date: Fri, 5 Jun 2026 18:19:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Minchan Kim
 <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Nhat
 Pham <nphamcs@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Barry Song
 <baohua@kernel.org>, Wenchao Hao <haowenchao@xiaomi.com>
Subject: Re: [PATCH v3 0/4] mm/zsmalloc: reduce lock contention in zs_free()
Message-Id: <20260605181931.d6fed8b62c8d91b27d151e71@linux-foundation.org>
In-Reply-To: <20260605084242.1549811-1-haowenchao22@gmail.com>
References: <20260605084242.1549811-1-haowenchao22@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 987361C0008
X-Rspam-User: 
X-Stat-Signature: zw5bh9hiy1u3uezsi7zcy5zf7w6grqni
X-Rspamd-Server: rspam09
X-HE-Tag: 1780708773-711478
X-HE-Meta: U2FsdGVkX1+YNv1PuEUMRUj3H8X8RPGJ8oQ67Nj7bRymwBpIK2KpGtLRZPnlNDXtviyGW5ZDjebFPJ1EFa877zYgpD2PHNUgZeuc6l3PzoCfDduogLjUMENrYAGobtxLArLV0aK/V6BgH7KzhPu7xacSLE/u7FjUV6wVLvPGiLoR0wcmiZDteY8wH2aGKwsyigBcDIJuKQo6UfqpX0wqWfbOqCEnGMX/jLNpRXmxk+gt7xAYTiAh/Hpu7x7wiItrtSAamczSM+aJGIIn0hCnTkRRJQFBlI8j+//ssnkJd+Ez6hLgsdp9lu+KQmallAuDf4hG3jS0+9KzCK3gkfc4BivpGiZJtWY24SUUpRrk6Kv2HUMigsh4LHSqCcPl2GOJkxk9rUGRM5voDwD2mvqMKU57yb8NOd1wlST//PmkBEDXc6QQPBrl7jxk1HfAbQ/8mY0gLNpsYVUpty1yVzD4HGyjWmVDmLc+ISZ3OwpYrTFRO2qCOenrOPQ7e1lzJddd6td8d9ns+oTxmN20AA9Bqs4I/wDHUooPeR2ElX5jh7N5Va7s7Qu84WD4Ox4jJ6ztVOHrF5SsZ/c46B08um7x9fIhNkohvS6SOl/AFXBceu2La38sydKU1lzvAL3naSyoPJyJG6QTHGHvU852abze4aXGo7Ty2mvWld3LjQlVoFG5nENzynQN9Ru2QUKnIGLYDJuCaM3UzCVgdjjZrMY9BnFNEV5IZyU2jUbyNeAXNHKCM7t8klkjoq62sNxvgurBr0nvhVcIH9QBXaWXiWgSshjWQUu0rgvKVRUMVlKkxQNo+FRv9tp2wyd9T8DXEg+jwi002cGHPca3sQjqGqy8/D7baH0LwRkf2eoj9+SI4rx7rxvMugsZBbgDT4IQJZQugi4VO8uR9LpVRaC3TXvlqhGl2YAVi7/uRYHUqE9VKT2GwjwXbbrEbHD+cXhbo+KEuxE9QFO8KCTW2CYqqyM
 tiz4BB4q
 Mib4ephVP1i+99/lVe0SmdWsxml3dF9bEgjMin03vMDN1BOO6hDZCaNOjId1rzHXAiEZa0q2NBhrX9ZZN4wmS2WGfE7RsN6lLxlCEvGJCfXWfZMCPAENSbJQ4VzIIYar4f/BNN64XZFIHfUuXG4pS143WgjheQ1+s9kmHYpvE1643jkQLxRRCR5+DxLsefJAec0OtkhA2UZxPesLNZkg0k6cAV90XeKUZ7Jqms84mMAdPB04Qjjpketj5Db7o+T0EdPZiUXXcCW0otdQq/CM9ImQ2r/LklxT0J6Bt87XE8QUyq67QvkGFSsWgnYSK7Suzp373HnU9Vm+ckj4GPl6YzHA5F/EbekWX2SSsHDcKy6MUYeUqYj/vzvlH1HllS0AClvdvi4QKlUDJcCkKqKM1tzqM1Uzjh3S78YVR+WfIzkZiU3M3U6XqCuH38NbuY+h950Obe1itlSJL/3A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  5 Jun 2026 16:42:38 +0800 Wenchao Hao <haowenchao22@gmail.com> wrote:

> This series reduces lock contention in zs_free(), which dominates the
> unmap path under memory pressure on Android (LMK kills) and on x86
> servers running zswap-heavy workloads.

Thanks.  It's late in the cycle so I'd prefer to merge this after 7.2-rc1, please.

AI review said a few things:
	https://sashiko.dev/#/patchset/20260605084242.1549811-1-haowenchao22@gmail.com

