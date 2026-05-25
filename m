Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8CEBCD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 19:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00CC36B0005; Mon, 25 May 2026 15:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26946B0088; Mon, 25 May 2026 15:58:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E63FF6B008A; Mon, 25 May 2026 15:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D77656B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:58:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5FF701401CC
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:58:22 +0000 (UTC)
X-FDA: 84807004044.03.FB42E67
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id AC22F4000A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:58:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Ph2Sqyzn;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779739100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tgC05AokklZHaxZmH6nORVbJqhnri+KDDLnZgIzW0sE=;
	b=2Rg3ljo8f8Le39n9vCPQ56/VLGAL393cdwdHBvCGULBULTLgc2JZtzzgsZAoC3Xn4Z0r9p
	1Otd/BKQDLVaIh+8Qu8gSUspjiWRc/hJV3kjeYQtY9rwu3SBZCcD9ILWI6u1FfQdITKK3O
	i6S7MoU/gDdR0NfracZojv2Z3AT4ank=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Ph2Sqyzn;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779739100; a=rsa-sha256;
	cv=none;
	b=58taRjhTfevPwT1PfmDCUKbIk9ReGYDhBdaaZzQ1dlhj6dXiuce+33Pa/37Syqfa843OY1
	W7YUQBH1SZxiIz5qLjOuHZSoUYe5lbxYQdVgHcdvVPFHDuEg0cT6z8NlRBX34enT5m7DBU
	Rqm9+lfn+sMX9ileAlvF0Fkw0qSPmI0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 08C8E60008;
	Mon, 25 May 2026 19:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A34D1F000E9;
	Mon, 25 May 2026 19:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779739099;
	bh=tgC05AokklZHaxZmH6nORVbJqhnri+KDDLnZgIzW0sE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Ph2Sqyznmt5+Z7ASW1tkQe35tKX+kdrfUVY2EteD3IXV9t8n/J4q/mXU+47Wc8dB/
	 hi9D8hM/xC02oUnqabSw3p/gJTKUF+EWDoyF9C0RK6k5C8kkEBtG07zoJY+HnWuUVq
	 pjlwm6RW/dARuWUOEEYWuPatHTk2JHvl7b8vO+Jw=
Date: Mon, 25 May 2026 12:58:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 0/4] mm/page_owner: add per-fd filter infrastructure
 for print_mode and NUMA filtering
Message-Id: <20260525125819.1857f215bc56b26a0727bedc@linux-foundation.org>
In-Reply-To: <20260525081652.2210206-1-zhen.ni@easystack.cn>
References: <20260525081652.2210206-1-zhen.ni@easystack.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4th88icnjcyjrgacqwk64n6bxh53gnw8
X-Rspamd-Queue-Id: AC22F4000A
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779739100-220728
X-HE-Meta: U2FsdGVkX19farZOkYl83Q1+RUgHJDcPWse0RY2NOraFIzAfh2BvzAfHBgVVugJA10bTVyADVYrc1Yo2OgoHFMXGoYRYHHQgy+T3nyOgG4+7pa83ZlWVryzqBYJTEROGLq59zVfK6Ly/m4Ila3BpA2kKUVAcCE7l+HHynSsNMRvQYLtfL5x2ZMkPPEmmqHcMC4uK7EZ67MEOaifiXIA7cfbcUjzUcjHzVTcDZMi91sRnHEgpMbyjQcjsp/L8dlDerrhH2XtjkDlYsChplbpxl+TypIaUJ9AzRvNtqkJG65744e9J240ChKsiMlzLgtfiCrYKm3j3wGYPN+bSzPEXyTeoL3AjNt6m2jhqLhuPWLnxCXKpdm5srXjJsn3pfO+7n/Si8SOiMz81K8xdtTZO2KLXBbSdOjRG8w+B+MshuFO/imNZsnpy5iEq6e3eHH5tEO6P2pCcXT8cxL50PiUyyDj1PNGjnbbwoRpggg8vaVHz9GZ0d42+/DSdhPDKK9jP+LuF1PspCT4888BLA2cGWpSeQPr6r4Q708mMlLxfoLQ82FaFLPTpNEERvIgiT5K/vTrXaog+95KZ/OcjpXQfu6grh9zvqq6XPHr7EBHeJAnThhY72pgu99GHn+T3W9ujBxweHC0hY6wOXWET6jyeVNS/C+XYiKrytNgDizCoDNTAraewMc/2o8cqVq71PoJeuctz5NbJJAMFQ9gdP/n8t8MChyMJyXZSZJ6Gx/w5U8hILpjT6ZDLcCJMtVPV1aUqlp8/vXocsRTbNBotbga52HGsuANaKG9Y6my7e6f8rXJ2xxpBm2AAXUq9K+NZopN4+mk5HFjudbMYthICakViATPkCWjKj6EhGW1qWltSoWlPU/9KaS8+3/PzV50drKpSy6ecMhbwlaNk7oSeRqI4CZZItE+FzhlvCLBA0v8c+e4uHFInxiiQ3vyjEM1Xh3K6e4F5UhuFDNvuITUCOhs
 j9HQ8H6a
 29nO4HrrIBwM3hkW/8puIPjfz72BY1PC5KaEZYw2OS6a2oIy/AJLwms8fDe1QJ+6YNJeLtfddgHISPzNe/g6GLS2g8oUgFah9Wb9hsRKvSW2N+RAw5F6+o+23IQbzG0nFB5GluRsZ6dbZe3xV7+rXC3dnJv0yA7ljUKKaCnp1gGpjwTFBdpP28dAUjLdV2kOccpb2fZJWBgpJRQkXuH3HB3J80kzY9CTA9s6ajUyHzCcuRWke2jZIxDX1mAjJiNjxitWzVDqaIic6WxB/8uZpiKSMvtNxU/nbCgD9kK+SKAxFikMegFYM6Y9vyUZp9a1KO1IYVQDrSzEPEiJ+nujEE+q2ixLYQQ565KD7w3usOADpdjs3I3cxdHivLDYzQzRUBtsJU0KgaVFibiLAlZWqQaFaUW5Q2hcVechdPoqzgdleCtsZPVSBL3Cg2kl9xZdJXSKRdOt6CGkh9KxpnSkw16ij1X5HOBM5hD97sIOO3SiuLE0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 16:16:48 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:

> This patch series introduces per-file-descriptor filtering capabilities to the
> page_owner feature.

Thanks again.  AI review has found a bunch of new things to get worried
about:
	https://sashiko.dev/#/patchset/20260525081652.2210206-1-zhen.ni@easystack.cn

