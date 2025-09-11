Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70679CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 22:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66FDB6B0006; Thu, 11 Sep 2025 18:58:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 620E76B0007; Thu, 11 Sep 2025 18:58:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5364F8E0001; Thu, 11 Sep 2025 18:58:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D56A6B0006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 18:58:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C4E3713B5C8
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:58:50 +0000 (UTC)
X-FDA: 83878486020.16.AE27234
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id D737210000E
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:58:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jGUnMNWf;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757631529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O+kkQ1dLhorRJCNFbvL1k5Va4YKpeSOB/jnNX2FSU18=;
	b=q/40L+NVzLEpV9YaBxksyIMtaUAhWCI+IE9s7LHYNydvzv5GOCM2S91DdVS9puC3d/99Tg
	ON0JGL579iU9eNG/FrCR+Kk7dNQT5hzYjz9WivggNlssMMFychNRrse9Vuq6hy8siY+d4j
	+ue9/FaH+oDzSHyXyKJLCC15b87ZrBQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757631529; a=rsa-sha256;
	cv=none;
	b=A/mLUIzeA6WSOCA0rFtomr/tJf27PuaRqMEsuq0zWOq6t2U2OM9T/+JDhAhx4yD5BXrhTT
	F8ujoVbvMAWGM7lKFii+Tr/lyGBZycnDsF54fP6V2dAiV/vpwXtS/ZBxUNjY3NouU0S2IS
	PUeJlwBRmi7w6yTTosdyYm02r8zjpa0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jGUnMNWf;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 11 Sep 2025 15:58:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757631526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O+kkQ1dLhorRJCNFbvL1k5Va4YKpeSOB/jnNX2FSU18=;
	b=jGUnMNWf16oWd8l8xX+J6UzoPwWzG330vsSlLM11/Xm3WDURfCDpE+jPvoZxPDwGEVZgkk
	cV6HYqsqshA2hlbs93LQGlswyLoQ5a4An1Allfd0fnwTJDUVqgUtClFxsKTpwau6VlCXK+
	onap0hIjmGlgaQViSGYiMWP5ALRpLqM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	usamaarif642@gmail.com, 00107082@163.com, pasha.tatashin@soleen.com, 
	souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] alloc_tag: avoid warnings when freeing non-compound
 "tail" pages
Message-ID: <h3njg4vlzeq3nkeoxx47zlq56hzyueq2g5kaoititfrmjizqe3@4yvoyckuszxk>
References: <20250909233409.1013367-1-surenb@google.com>
 <20250909233409.1013367-4-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909233409.1013367-4-surenb@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D737210000E
X-Stat-Signature: 1g3oucfmjfdmooxu4qubz4x3oebtznm3
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757631528-33544
X-HE-Meta: U2FsdGVkX190baNVBdMKm/ze+zl+7ir8pL06GypzasqTtupHi7tR2vrQcCgdcO40BuM2e7s40XwDIYRaJpzs43P8QlJzAxlho73KkKGmnAhdbEffIyFaxUD5Bs4hvqetqYKRA4Lw6JpcIfLPtIoVENE3tCGKMCl52kRGUPvi2cnCDRBa0zek+j8W9xkVHCjkFqh6cSRcJzUhpzvsEaZzl3NU/LlN6HNQDisxTL8zI3bjUMNxGXdwD0Q+vCz7reP7aFIO83xoejOOYaGPze6gUctYF31XHScf+FlMSNPzsuFIZKw7y7a6FQP0t5a2eNNClXFA/AO0cdTf0+Dk6VftoOmHBla37p6fSpkJvr9K80U6smuK0PS5LTsYihq+vNzFec6c6N+AWVRAQDLJ618PrbnIsKjU6qacKhJ5GVLfnSTgbeYse2QkMC9izKRDOJUZuJmkqgZlkVb32hnazgjOSssT4/me3wBjrLrPVerybRaYqZbw9Um9q5s1bPyZOylYqeWo1QnoP/USMeXVxhezRCku0vj51bBr7R0DpHQyESfqu8U0gwZazAje7ZP9xqzr2FGvauDJY0a5GAfTCU8xV46N25PcVoo+AMdgTcp3iMdOICvABad0uyiFBIFy4hI5pqwLAHUf4WXwg340L5mw4AlLEGXbw8fQG2J0rE0dwPJTKOOYRKZqhBLJNBZ5B7s3VGhG0Rduej5D0564HCWE8aIdmCK0PDq7TUJ6FvAw48LwC9qptszKuwkKCjRwzkBecHiYduHIvIocZhEOTosA3dr9TzTZoiGeM389/aPNmQm48yaxxxriEoG8lk9KIQi1HwK8TqXbQyhJg3rmiYHIn6t17oQhXE97KHgATq+hM4wfz1XKdIv34no1o+nGUR2c202JI4QNCgsec+Jqg60vQ88UT3NG5HAfwFfyxxHCFPPSz2CyQND/LhOjEGxXjoFLYrqWQ7QpoD9Vg2hsyN6
 ruVe/Rq6
 tF49q4/EOxsFSiRrfJ6Bf8su1xZscNvteOCOzo+bsMItneixULuQfb6fo/aHUz9ZZf+2krplbMHwP04+8YrTlc0TUgbXpa4mzJaMB6Tq1/tr2PECH3hfH0k1mRGQ5cWc0wTwATwMB+eVspqfyCnSwKdOOrWKUatyr8txSv6zUuRbVYwf+nlWQyLpinPIuV/TX8wd3MKQtNV9Pvv1AxAA4dvC5unj+xPcAwulDOElzBDt09NC2vS48zxCYHVfl63GDPg8PoYhuySoJrO4EWKyWxMg3BjOn7NTpcqgsizYuwVmpucDqj/pEmA9FyQWt7gEYrT9T3L8ZYFoYflw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 04:34:09PM -0700, Suren Baghdasaryan wrote:
> When freeing "tail" pages of a non-compount high-order page, we properly
> subtract the allocation tag counters, however later when these pages are
> released, alloc_tag_sub() will issue warnings because tags for these pages
> are NULL.
> This issue was originally anticipated by Vlastimil in his review [1] and
> then recently reported by David.
> Prevent warnings by marking the tags empty.
> 
> [1] https://lore.kernel.org/all/6db0f0c8-81cb-4d04-9560-ba73d63db4b8@suse.cz/
> 
> Suggested-by: David Wang <00107082@163.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

