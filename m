Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A063ECCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 02:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB6EE8E0003; Wed,  8 Oct 2025 22:32:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8EC58E0002; Wed,  8 Oct 2025 22:32:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCBB78E0003; Wed,  8 Oct 2025 22:32:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBBA28E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 22:32:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7079B160943
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 02:32:27 +0000 (UTC)
X-FDA: 83977001934.12.6920BE0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id AE79014000F
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 02:32:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ObfaIH+t;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759977145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=me+xgUYiPoNs4Y8f7cgQi9gpB/DOKMVgl8RRqzxMFdo=;
	b=k4q2OyddH6U4B3VwXF8DzY+Efw7QbJnJVzY/TSQOHWRIeaFCz1oT2DosKHD4HGcgsvXaLX
	nGMAr7wI3yH9oaMMD5Vtzk55VOXjzJ3T6FIkIQiYDdksjrsSl8sQXMX5qW9RifbOKL4dTI
	kL5tFxjNOBpZ/VbvGqZnV6Fr8xLJZaY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ObfaIH+t;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759977145; a=rsa-sha256;
	cv=none;
	b=KJ0FBjNh5AlNPeSbC1pCVZeAzsuRT4HmSMSXxhnz+/0Fh+64mYMHUXOkCDiEAB4v+5pM/J
	MyR7CAuUQ9xa9k0zW52bIL+9FpdYOOQYTTXwicfPfzM35OHuJ7N3iCdaeFpQM2I2o+qfJz
	xKBssU/HpQj/xoEW6vAXZFSYeZBCfiE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BCB9B62158;
	Thu,  9 Oct 2025 02:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DCEC4CEE7;
	Thu,  9 Oct 2025 02:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759977144;
	bh=aANUMzra9J3BotN1T1buLbHq3slzrJ2oZxv61EPpeoQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ObfaIH+txn/i4w0eUr3hbUPklaxbCmSwjEVRn+6Aq5Bxyd/+REQ3ZA15m3bEeIdKa
	 XrXESA/rhCbSKSDChWkZ3NqpJ9lotRfe+kHClC3klKTTUrXJZv3GoK+P4OZEVpRB76
	 DU0gAKxwezMq6Oo2XeSq8iaradXWQ0tngo+lfLUs=
Date: Wed, 8 Oct 2025 19:32:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mauricio Faria de Oliveira <mfo@igalia.com>
Cc: Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@suse.cz>, Oscar
 Salvador <osalvador@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-dev@igalia.com
Subject: Re: [PATCH v2 0/5] mm/page_owner: add debugfs files 'show_handles'
 and 'show_stacks_handles'
Message-Id: <20251008193223.f0e7c243bef94b7db22070fb@linux-foundation.org>
In-Reply-To: <20251001175611.575861-1-mfo@igalia.com>
References: <20251001175611.575861-1-mfo@igalia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AE79014000F
X-Stat-Signature: 6epebnwkeoze3quchngrbqk3meips4tq
X-Rspam-User: 
X-HE-Tag: 1759977145-991213
X-HE-Meta: U2FsdGVkX1/aDH5PhNwqe2v2Bn2rQbOtxHn3hWayylsJ2gofTpLH409nOfgKBB6WQxulKTvoDC+Hmvkv7A/xeB+QHZiGxkP8hQJZUlJWIS1M+8l5IxbWJfy6y9Q8x5ia3oW82q0eraMISnJNca/qkTeGuzU/yML0Mgf2JDbnSI0j/DrloYySzc0ngEBihhCzt0tl68mKNFaIVKQgwFZ2Awso756HS6Wsd83hEndQuqZ/1iksjpeeFT4jEx/eVGZdf3DZ2Hz3bwteFTTlMty57QZspN47eD+oqhSjVIMvz1tSN3CEypYVIQq7zOevnTiiOTl/HtIscR3nzhIQGnOzILxi5CXG39TTW7WPDfTU+bFgpwWdwy/85gT86LWDB8vUV9D1i4uE3q94oAa7cbPZTMhfXgQywthzPoVhhAHU/ANDs35t68QcJIKK5U3vwBg1QriLjeCVPZ4VrbO5oNoji6UIZOdCio77KnvaWvAMMZcVWvJbXuthTdF10QM1DQISQDexGCNegmckU278YWSejkpyXjuV1ARoDcR7xdlwqCWZO5lrATZz/gi9+TOW09O0Zyriu0Iog+pcfQmXp1BEJkiSbFA53VZGu6ftr3bGqyK29wlJg3ONhMi/fg1z9uqjMjhapHRos8sWtBm06v0/R9yZD6MTtoa9PCTBCQL0+KzwoUo43/IKM4SpEGFeiQfOFBpasDglBl/YAb+/ZZAQBJjPuT4Eyisj0KnhfuDy2+yMpaygTL1i36fK//hR+so37txBlO5DQTsc0GRxxvVVxW0fE2ddjVrbzHBeHvGZXSJ9hGczxFovEDDu6p3eQiD+5bj2s8U7UjBu4ZGN+gV0me0UyvbhyyhQEvFo96ETel5BAy6MzRd9IMAHZXIfnV2R8nCQXiva5frHToIKTGWsOsjOBuAzXJn2AjIgDOUWi5pWDr1ky4FSlqL/ahY8D6jFnK6WYu/r1JoA5CatcjT
 cfe1hIdo
 XUT92omCRixhKwtALVhv3bkQiehIGLRRZS+urJi1kB7dJedUF2rou7Ryp52G+W3Tc4KV7wVv8Hu5kkCxPhtnHUw4Q9G+itdCM6F5+k9eXhmL3mr1b/Y9Py+dB5v45B2KumUyibEdxRXQHmqWn0ehKrfiKYaphKCish8pYHMoHLoczid6+slgyX/PrqnDc69M3KLb7S9SpLOe0OT+bQSViazhk4UTGpGYC6UPRl6u2l00gyR6DN8jqzXXcPvidLkub5OfVbOkVtiHVL2WxVmp8uHecKw1s9ldsK95yZOXT89yyO/DkiNWMiflUroZV9Q+ZpQCLeNUyvOOXIAESOfcIZ6j/5ivRCz63IAL+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  1 Oct 2025 14:56:06 -0300 Mauricio Faria de Oliveira <mfo@igalia.com> wrote:

> Fortunately, the kernel can provide a unique identifier for stack traces
> in page_owner, which is the handle number in stackdepot. This eliminates
> the need for creating keys (hashing) in userspace during post-processing.

Looks nice, thanks.

I'm surprised that our in-tree userspace tooling for page_owner seems
rather weak.  Nobody has touched tools/mm/page_owner_sort.c in two
years.

