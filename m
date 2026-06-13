Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A1BACD98D8
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 18:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DC4E6B0005; Sat, 13 Jun 2026 14:33:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08DCF6B008A; Sat, 13 Jun 2026 14:33:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE5DA6B008C; Sat, 13 Jun 2026 14:33:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DDE746B0005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 14:33:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6B9BAC19F6
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 18:33:07 +0000 (UTC)
X-FDA: 84875736414.18.F044CAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id C13E64000D
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 18:33:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WWH5j2Ie;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781375585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mp30tNqRfK4Zo9AUlCqB1todNLWmHa6GmIIRAZsl2kA=;
	b=765qWANcRAy+DYttQjjMKUXqk76tgJa6saLavEBjEFRhnDTxoi0YDj6M5bUoVPepZD+349
	pXK2FpX/q2i6t/gCsmxk0+wm1nyoX1jR0uqbl9QNcEPcuI/VPsokIn8aZGy6eE7ztiVi3f
	EBJZbHFX22XYrZE8sGO2reRv/fip3Bw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WWH5j2Ie;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781375585;
	b=5skd1sDLXPJDjRIzJorKqLu7TsUyV7ZqmvVPSJ+fmjHdp7muboLthoJ4EZuatrk8GOOG7X
	Yptkm9MRLmNUQ2lGtFUR9OQ3rKKYytU5ccSf08g1qKcr3WtdNCdkoVWyQB5EqzbHt28W9Y
	UTVF2kVK7vBVwTitFoejVvxc8U/XBKw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9FCCC4336D;
	Sat, 13 Jun 2026 18:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE021F000E9;
	Sat, 13 Jun 2026 18:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781375584;
	bh=mp30tNqRfK4Zo9AUlCqB1todNLWmHa6GmIIRAZsl2kA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WWH5j2IeOfr7qkLo+wELTxTqWnL9XBQV/ZrhkUpio9pYgrHeVMOXgu/2lhTzU6jYN
	 gZ9VIR0CklvtNogLK7+5eEZjkSPV132GIc+/gDP6J60EgfWtGBrCPwuOXrXfSiohm1
	 pvx1148fro5ST4PnJe7JjPl19lTYUEzqmWilRDEy54nVg6Y26huMM6HH6K5Ck0I9Ki
	 dNUbEyEVW155apszFZ5nOVerqJ9cwozTC+C0T2GPbr8dHBv/Knqf4/SdIsy9hjojSf
	 sm5pyyxho878EZYEL8pdRr7GPRVuofDdOs2+UjaqzZ2iQXE2rJr0sMoBjB+oLev3xP
	 A1EVBArekuPxg==
Date: Sat, 13 Jun 2026 11:33:03 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, linux-hardening@vger.kernel.org, linux-mm@kvack.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Hao Li
 <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes
 <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, Simon
 Horman <horms@kernel.org>, Jason Xing <kerneljasonxing@gmail.com>, Kuniyuki
 Iwashima <kuniyu@google.com>, Kees Cook <kees@kernel.org>
Subject: Re: [PATCH net-next v2 0/2] net: isolate SKB data area allocations
Message-ID: <20260613113303.7562bc59@kernel.org>
In-Reply-To: <20260611124642.345400-1-pfalcato@suse.de>
References: <20260611124642.345400-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C13E64000D
X-Stat-Signature: hz9der5a7e5j9pu3goqtfau69emey4yj
X-Rspam-User: 
X-HE-Tag: 1781375585-630600
X-HE-Meta: U2FsdGVkX1821qe8vw2fDTwWbCrzIw1XWTLLCKzHnC1w3Pd7mg0fWNlIiv8SLZluvnmrGiOPJ43JqLGYeLosaj9tTVOMITiGiMpwokp4Ij6xOLz97HCHJeGLVxkyLmYb67KUEQuzQ5bqd1gCCLCkH2oIJXRGm+ysV08py51GUgcrIJvwEzx1YhHjekJGJHqyQL8a72wIC6Q+k7m/pBACKRmZgELQjbt3NcAwqytMBcJNHR+8Qi/hUdG3xC+GSbRddKpioTTui3wJViCYp9zlcObAOmALKv9IfMpjid+3MREDTvbs7VqG5aKKUCyBlfg4eniyR5FgwNtyZ1CVLkIR6hk6ZIMj8bkI0ljc2E3+TyERmWDQg4d8PhOHSV2e90aoCRYhLFvmA7AYwc4h7sguVhIdWMYT4DV3KLzG/A5LBSWsPIZQtcmOoUgThWusUlcKAFdTGbAY3q4YkV3DQc5+BrP1X7DbHKFatYfdvT/0JlaOvAjsIQhEZtfgIc1KA5xyEBLX8auvhiNogQ33s8ABbOLguEz3yI9VIf3votl+8yYd4gzZx8T8B/YWPre6d6wS1+1PKvC/g9ngpklqm/6N1dtD4KEA/H3WRxWzCRUZoxDDh8LyHYnWyaDwk1xUZV0F7AiXTVK0UYnrj0yaGMu57YLTXhdnIWjVsqjwKoNV9mrOJVtl0GuOlb2NRZ8XIFXgZeOg+pGG1+jkVLe8r8xLquJi01COYGB+4/GcfvawMzRQPfRlpZqqCvB5TyRgUnq5Y7YlNDcQoj6GQ1OXbK65QCxY73I1lmdO5mRIN3fR8Vw9hJwjNz/vv56ioqGBIstAX6J8Llq2p71UgHyTluC01nglqgd0GgaS8iADiVQn7l3pn7skmc9uNZb0TE2FXotCl25UwGQ9HTbjf6YvPtBEfhir810ZaYMouFg0mG6/bY0zYgeO1jwMcnGQmHFTUbRqu8ZV/FVbZfSv+CluanO
 h3QZUYKJ
 C7MFeXOixmcq1xf6OGRaiM+IanTy/ORu2HeIBVJk+GWKiGCAimfyiF4ssQxaG9wJ2E2eTu4KCJRMfUJkPsvwnjAiHRPCa4BCUkiFDWBB4Ao3YY/jVvk0rcG2RsZ4IHXZewfyQTPGB8uuTQt8nhqfglKKggLxjN5+QFmW4CVI+VNeqRXW9QAmuwhUhceLzSii772nvila3mobj3bFzYVraOfdcRcyOOJe9PnU+zD5MQe+UdXGthbY/8uVd2nbPpd2ZDUlS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Jun 2026 13:46:40 +0100 Pedro Falcato wrote:
> Subject: [PATCH net-next v2 0/2] net: isolate SKB data area allocations

This doesn't apply to net-next, does patch 2 not apply to mm?
If neither tree can take both - maybe MM can take the first patch by
itself and we will queue patch 2 after the changes propagate during 
the merge window?

