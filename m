Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CA26C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 22:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 371446B008C; Mon, 20 Jul 2026 18:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 322BD6B0092; Mon, 20 Jul 2026 18:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 238366B0093; Mon, 20 Jul 2026 18:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EEA576B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:43:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 80D1C1A031E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:43:38 +0000 (UTC)
X-FDA: 85010633316.18.8894C90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C195FC0003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:43:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="b//Lp6Y1";
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784587416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cV3t5zNRL7kvOzMLt3MLzzwzFcpy7JemF0QTTW5TJ1U=;
	b=CI5YlFdEsk4pArAoaLbK3OrYgN8Ihr8lvacaKGbOjAQRzhNj+M/P7WGsRMawi0MO490D7B
	nYjsWKA34RMU1ef6Gq+LtrkKDnspTPPE2tvX9SiptbzKTUUa6KMycbdmQkq5xMv3yF4e0C
	2OuU2ezwsQYg9Z5MsxwkvDcsRHlqQRI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784587416;
	b=kWhU2BoPGnT0z7AlTysR+CzywTHnEiwqMtjclXAwAd2Ce6q2yGj1mv+PLvd015HiB8TmuF
	gs2Kk5HdtbzjcK2vzF3O3Qy8IMuo+EUJEs22vVc60pKU77/R6gAdLAW+N8JzPkpGG6KujL
	WxZxDHWZYm8TCvUrPVhBOAf1SNxl7fM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="b//Lp6Y1";
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 964E143AA6;
	Mon, 20 Jul 2026 22:43:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052381F000E9;
	Mon, 20 Jul 2026 22:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784587415;
	bh=cV3t5zNRL7kvOzMLt3MLzzwzFcpy7JemF0QTTW5TJ1U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=b//Lp6Y1qQq95x1/uaW18cJVPYVPCDOQz6cYK2G/bx2upGzZMLgieNpFC/FT8eYU4
	 9hZQSTwr29TmoktdLWXBZLcyop14PsjPoCIlFZzcJiiNpe7G+dTUGkLnD3363238nN
	 E03456OTNBVdZArHUpbgc7eLCS4uSS7cQo9Oikw8=
Date: Mon, 20 Jul 2026 15:43:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Li Zhe" <lizhe.67@bytedance.com>
Cc: <apopple@nvidia.com>, <arnd@arndb.de>, <balbirs@nvidia.com>,
 <bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>,
 <kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>,
 <tglx@kernel.org>, <muchun.song@linux.dev>, <linux-arch@vger.kernel.org>,
 <linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <x86@kernel.org>
Subject: Re: [PATCH v7 0/9] mm: optimize zone-device memmap initialization
Message-Id: <20260720154334.b619e7b436d2dc2481b233ea@linux-foundation.org>
In-Reply-To: <20260720120259.1545-1-lizhe.67@bytedance.com>
References: <20260720120259.1545-1-lizhe.67@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C195FC0003
X-Stat-Signature: mcdebcn7eo5czuk788dypbxgoi91xrfk
X-HE-Tag: 1784587416-716376
X-HE-Meta: U2FsdGVkX19JMG0pm/YkLJfU8Tb66c0dgTrQ6nD8CccoI+ux35SIO51jewvBDefRMZZV9uEjAniX/QetKxGUc7AtbUWKhFSinA9CXKxlBX6CXhXTnsd4d9iFwU8jfNoy4a3szsJfd3ZIcXRnu02ERMFGLBls/wJ28QpZbd/hIvZV/pz56c4HOmtSS9a9SGMsr15PJ3tEf/EuLEZAOfPjJZXEfdOmP2La6GkdkU+5KykDcnInCUhQsMQF27YmtLKZfM9ChIjwfZYErk6zUnmp+NPAjJbuBiPP2mDjGkFe0+dty89bZCaFbfjR7ly6kiSFOSjRhEQycwWtuad10bYWjlNG70PceU1vvLZjTMYyaB1XtkxTWQb6QzjOFauOkEi9m/Mlx6p7UPWW9Tz5NHnPn9b5E4L9CN+/dad26PXSYgNydjy6wOXNxzvuFqLgFIo/seXkZ879Mk32b+9wznOKG+KMHDEO8yqBAeJeEnUlwQ+dx6NSfybNZt6QNeFF1Noa7bPxsUkIge/97G0UaN5rfXc6BlO+u22TZqf+CQcASemIt2HkZm5iZsf3meChaE4AddbUoaeYY2n/XVZV7mS/W1ECT+0oi6DIIyUeZ4Rsdue8q/b1MFddhIIXjCfnFSuoGSE4I8J7B20sL6SeDp8IyEu14heQ5c+w0qF/mOSr1ftB9ETodtiADLR2UDpWPktHACn47f06nwLoKR/p6yDQcFVT+JXpaJyLKFjeODFXqbSKJ+nFjGT/ol/afPyC4ibxn8Tx2hIZ8WApUCpu0M8fUDvEZoAdA7OjgrEUZmiQt701QWDwWxuUH9r/lnnKvKSyvAZO089993BJ/uK+YbfYGmMc6XNJ2fQMWjkmeneGTWmV+u/dFtgIrRAVh4wS570Zn/me+If+MUO8KE+KacmVaqt0JwSqJDyWIDUaPfemYUT4m2yEi+5jKhlW/C76PbFwf2mQNN91YMoFdax0XQL
 TiyaHYa3
 7Mc5OpOMwK+wKg45IWey+B9ERAc5Oo1JPZqniYtvOKyB0niHGbiELiZVjY/jcG/1nMc5417yTWVurfpMqH7MYm3SsOZt8BRU9naVhjbDC9Ndo6RNNjM5WE7dHGNWDwhKW/KjLan+sSucNXtBpbvp/wrlLkiolOmetharOLVSzZJoKCGHOsDJCx42+Kh7xK6LslFRxEUI1v6suU6ayIUE1JE+hww34pYqY2/II+0Fgzqsh0t0X3KvcsFP7+BXzrKxawu6e6lNEoW0E8IJ8FQXXjOjHniALCz3iPAqL2yXUmyHNmMaykUDEHMnCg8poVwbPLmEQ+ZR/IOYsejdYbFheBiVKpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 20:02:49 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrote:

> memmap_init_zone_device() can take a noticeable amount of time when large
> pmem namespaces are bound or rebound, because it initializes nearly
> identical struct page descriptors one PFN at a time. This series reduces
> that ZONE_DEVICE memmap initialization overhead by reusing prepared
> struct page templates and, on x86, using memcpy_nontemporal() for the
> template copy path.

What Dave said - more details on the real-world userspace benefit would
be helpful, thanks.

AI review might have found some things, one "critical":
	https://sashiko.dev/#/patchset/20260720120259.1545-1-lizhe.67@bytedance.com

