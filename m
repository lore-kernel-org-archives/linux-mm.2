Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EEACFE5202
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 11:27:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89BED6B008A; Fri, 24 Apr 2026 07:27:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 873B56B008C; Fri, 24 Apr 2026 07:27:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B0126B0092; Fri, 24 Apr 2026 07:27:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65F736B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:27:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F33EF1406FF
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:27:04 +0000 (UTC)
X-FDA: 84693222768.28.522541F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 36DC340002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:27:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iW3IFFyi;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777030023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TFxoWf1vT5ApiE3+2sKcKWok7ZEObi1muiqlNDqlHk0=;
	b=8Wc76F11UMVyxpTkULVzTg2hMfB6wIq16Uppao6Ob/40Y96cYAHHfT4JRSzykYV8Re+Gg5
	NBRBHYxHOJoeEKTbm8k98ZT7nwRHhq2YP8F889r1Iji4cxfqWDHc8UkzbAV1tNSzkIweJQ
	/kNYe1V5DUBvmM5z213/YMCcvAYVYzg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iW3IFFyi;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777030023; a=rsa-sha256;
	cv=none;
	b=GH1K8j83IsvAj6uyld4T3nKG5DLNIvDAgF0jUrnkc2F+KFNWNY3PNp5FMVP5gB6gGI4346
	1SfRyyeGUGhehatbn8+ckPEJfCm3OfQ+NiH7vpUnK+oEcsagrN8wp+T23YJkhx9KJFCZCp
	0PN5wt4GY2wifAeCAnE5YBxkrgc+6ao=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CB90843D89;
	Fri, 24 Apr 2026 11:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A029C19425;
	Fri, 24 Apr 2026 11:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777030021;
	bh=ro7l7a/oV92PlZESqZku/HcvLMrxSewPIVOwvxoiQWM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=iW3IFFyin0WIRDL0MZ2ELrXHMknIOhxoz+rUpu41WSFqy69MExjGY2Ys3sEWtSKAy
	 oGfZmtJgHxkB3meHRen0tmgXvuJ3KA93D62wtL8hMzYY19BN4Dm1CejnMvuNv4zEd2
	 J7/sA67lHkl149Vw+41FKbfct7apWjOwocNIOmJs=
Date: Fri, 24 Apr 2026 04:27:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] mm/page_owner: add filter infrastructure for
 print_mode and NUMA filtering
Message-Id: <20260424042700.74f60915e0f29337d23d9f93@linux-foundation.org>
In-Reply-To: <20260419155540.376847-1-zhen.ni@easystack.cn>
References: <20260419155540.376847-1-zhen.ni@easystack.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 36DC340002
X-Stat-Signature: 1gqsx46mjxhwj66mhdww1m8rimdgj53f
X-Rspam-User: 
X-HE-Tag: 1777030022-229507
X-HE-Meta: U2FsdGVkX18Ga0SPg3ITdFMxvrr++c1Lf3l+Ipdq/tnSoeoPcRHjix9mAgqxTF2kAXMVJM8SDmiqn8Wy5zeoj8OqJINKCYdUDu/f2h+xaJKJOlrCBICKnm7U83YfUIMbk/lAq9h92FiH1U1ihbz7NTTboWwmsbCPEXNtihoQJvhVK0ehdWFo4vN3f21JcX/ctrLTiQrpw0+peY2s7qMzBpSHc8CA34XHNggxMRFFp02ySJ1lTvg/Sn1Uo1MqtGP4GCSP1qU9X85YdY12/bHhKNj4/D+GO9EG75a3vvQuotzSHsS6K7GJkzZmSn/22rD2KpvSsISNoO5i/7vpMiGzhvwpONyze2yDuW/AICCa3VADKRYI1iYHsJJWRrDLBjRSp/Af33xTzntPfb0renVTgAYVA5uYh8aDueazOr2BbF3+WonAksc4QwGyMyQFAcjFxHMHU2bT4OO/YrHhhMzzWV4Ang/bra5ZtfvfJl2QwcRogcvn4vZ7TYKGvTzi8796NQ8NT4C6vQu3unulJwDieVv9AUAy76x9EeL7SKDb6l3nuX6aIzWfD7fAAZg5pe5AV0ZjePmunEsbdYZljBLUvG/76Ft9am5EAHrzR6hrfg9M5OY1mElS6ub1aZUk3h8+wK8+LP0UPiNm124feQYhFJjoiMvFYl/is15M/quMe12XGQODx7c+jYB7uiTzwLI6SQdDtMODBkg1k5eBlTkkT7pwA1u4eDC3jNqfEemFCLu8spce9Ybv9rwYj8ubt6aF6KSuBr0V8GIQO2ul0liznPMMCujytUUu9LrypJQVFJvdg6nXG8zcTWZJylSlit3OVOwpPR3BKoajMMTrwbx8gTyKvZqO2ZULg5WFl/rt7thsZY7qLoxoCS1LGxr/Kb5cleCXuyjWUuFPYj1SK2T9o2HJJj+pPcJRQXpcuOJgcoTw3CgAhrpExvRV+HyJ9sgT9xvPe0uHB5DvvXD7Fgx
 XHHh3OLN
 QaeUTSf1QkCTXTSUqEedm390juqhxvRZXZcfadx32GHN7anFGMyXPZm19XDOB6k0QoD4/gqMegYj07bduAGlgtG+ujTp8eOyEju/dPCGCZdAmNPsULS6ViEgBM4RL06223BInMuvzIY8DfvBVgr1DoGgucoOGqsYwWtjqemtq23PMkOuzi53werXjKuZbIfXeMmkmVm9WB/IdHeQoc4W8GYLFGiQMSaoLDCR8CVmVLX3UWWJuhu5u+q2SI7fMunevZGAByL6hiXnI9G/h+lliJaa8zcWHh3ybo2iGiQJ/1ly5JMc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 19 Apr 2026 23:55:37 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:

> This patch series introduces filtering capabilities to the page_owner
> feature to address storage and performance challenges in production
> environments.

Nice patchset, thanks.  I'm glad to hear that page_owner is being
useful in such environments.

I'll add this to mm.git for some testing and review.  Meanwhile...

>  mm/page_owner.c | 124 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 122 insertions(+), 2 deletions(-)

Could you please add appropriate updates to
Documentation/mm/page_owner.rst?

