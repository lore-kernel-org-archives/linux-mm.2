Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AD4CCD6E7B
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 00:09:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 892D96B0005; Fri,  5 Jun 2026 20:09:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 843B26B008A; Fri,  5 Jun 2026 20:09:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70AEE6B008C; Fri,  5 Jun 2026 20:09:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DFE36B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 20:09:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C7441C1151
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 00:09:03 +0000 (UTC)
X-FDA: 84847552566.15.534534F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id C6528180003
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 00:09:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nGjqCgVT;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780704541;
	b=ObcpPVnwQn3yCc8xjNNKVqvEiJPDNRD1FliDUh92x81860T0jzfo3lDozzhD3Cpimyws/6
	Zhxl7eZ+pYsbYtWTSaRSIq7qCuNy7xtLj+xKi8r7aMZbR5Jcm2mzygAr/YhSaGGdFDkx53
	yIT4rRwJF2MD5N+4fDTsfC5jdwq/l4U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nGjqCgVT;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780704541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+NniFBlcUfvN7QPaMYV7ZZNeczE8DDn65tLfNJE+7Q0=;
	b=48mu7o25EVg2JhunHDNyp9EebsMY8+tyIDqVPZHnNpO84LUz0vhJveyrFAfLsc09s3u/Mt
	7IL7sIJrzzCViL4/jGcOJR6v0RsA0G2L2y87yDmT765KK/cSO78n9F0aAa5gKrt4Lquusb
	+ffKZ2+trVna4OmNfSsT6EaHFceblSY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC43240C31;
	Sat,  6 Jun 2026 00:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690511F00893;
	Sat,  6 Jun 2026 00:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780704539;
	bh=+NniFBlcUfvN7QPaMYV7ZZNeczE8DDn65tLfNJE+7Q0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nGjqCgVTlJ1icg189+oXTqVABzd7Gze0yQ9M0Lrb0cGWI/zTEeoLhRPI0UWOdmVOU
	 WTS9j6UAEq/Kn9brHFQYghKu4cOxtBPovmtQzFOfgaory/ZwmEZEShAaiMYo4IfBkk
	 A/XYFkZ49BdMucFP0wSNAlVSEi16msChMHIUrgHU=
Date: Fri, 5 Jun 2026 17:08:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>, Kent Overstreet
 <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>, Shuah Khan
 <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Subject: Re: [PATCH v3 0/6] alloc_tag: introduce IOCTL-based filtering for
 MAP
Message-Id: <20260605170858.9ee9ca2181a041bb9a4c3098@linux-foundation.org>
In-Reply-To: <cover.1780701922.git.abhishekbapat@google.com>
References: <cover.1780701922.git.abhishekbapat@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C6528180003
X-Stat-Signature: hk8c4xjkq6rs5ibozaqq6mrrxpxc8wm1
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780704540-21829
X-HE-Meta: U2FsdGVkX1+SMlsXHM30IrJPaAdVUk4CoPVvpqtflYwIk5AIJnKbN50VT2zKv7wNrPBxzmJV8XUiE3qvIZoj8x0q8DPds0x108ZMoyq+dZtcy8Gp/WjWEziyEhjiJ3lu6oHRVvPDrUGfWk4T3n0WSJV2KKHPJ5ATb+2G30jBqdVOuYELOmmReTEi8A6mw3/pDt6eDMfaud/0vJoVq578AtVcom//9uKRB6TbU206ye4/iT9Qrkr8AaenNZTwtyMFyIQFhbw2Wz+fGG/fvgFcjczmcK8SbSA8da5jwziGkwF8/h+wrKi1r4G1L8FX8j2iZlC8LV8DTirYgyit6Rl+TmD0DA08XOvnhanKuu852rL3HjPRHHQ7r4ZE0i/3YGi8wZ1XP26f9OpdFo0/cYFTtkbdoPrhmIhx+kppF/F520uY80N9AlP0Bm7S6YaQ86ytE1BScLHlWdvJxEmERaC0g/n6fYXIxA5bDmf+6yYTm1fbFUoa6KVtoXzpxZl+XQ5BEYuCtrY/jmA+X9XPUzqVEmcACKVZl9Yv0XG4nXVXIbQNlxZ1MCQGAdu/vrN0GywFKTEF+9WeqSS1rvU7bV9IftIsjttcEgNSwk2YMmoDS8vUNKRWmRZ47K42j3hpS+IL8I0Ro/xlO8DeBFmCZ9IVflsVTkulk4A1AapI+3Bo/5e49YAIHvy9G2Ffk91xdVhvnC7zALzhLR4XYUXstujFCS67TkXSI//4OrKquPlU5O+FsuL0dEWlUApEBK//PBUQIz0DiIzYm5wk8/rxGbNdH9ePvmWUB6+So6qhzNR2ibjoDWkAu2aE+JAyZ9J7u3Mb0y4L2aYQhe1zhUyYBrT1zEUem2TwYNQq68u7D7CYGQBEpitsvj0dhnEn58joR99ipxsY73Ec9Ryt38CROFaz4ovdSjX196BFX85DUgKKYxp5p5nzF2P91X9rNsXJl2SwUUj2tj6Mb7Yg5zcDNMe
 NUp74Fw5
 64f/gkmffsiK6qehQrIAeaKt03neIfAn2lvMgOgegx6e+P+oIp/yI6f/gLCFmxnlPZwyQkNg2ZBpfrGrrlpj1JX//aqtucO7gQtHZZB9fdVZOImu8xcXy7bfodsEP5SII2JaqBlqSSl371Ear55/Q+i2Ppx0QMJGOmzeDGcMKtJU5k089R/hmRtrpKqIZPW48mMLj2zt/bPIMPy3v25RwuVciWqKrbWWsZ0KVyzRU+vlFVIwiwA9KS24+9z5u5sB4s9qNQpCzczlsX1NpDD0tSSJD0vj8d3vwJPCWKQCgkpYtVLwvBvv0QJCYTpu+bFQ6ioQtaaL3HGepHXlc8n7ooV0SaUub6TwRbZW37VGU1D/lBHHQFne4JHb9hyAtknBTAzu4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  5 Jun 2026 23:36:45 +0000 Abhishek Bapat <abhishekbapat@google.com> wrote:

> Currently, memory allocation profiling data is primarily exposed through
> /proc/allocinfo. While useful for manual inspection, this text-based
> interface poses challenges for production monitoring and large-scale
> analysis:
> 
> 1. Userspace must parse large amounts of text to extract specific
> fields.
> 2. To find specific tags, userspace must read the entire dataset,
> requiring many context switches and high data copying.
> 3. The kernel currently aggregates per-CPU counters for every allocation
> size, even those the user intends to filter out immediately.
> 
> This series introduces a new IOCTL-based binary interface for allocinfo
> that supports kernel-side filtering. By allowing the user to specify a
> filter mask, we significantly reduce the work performed in-kernel and
> the amount of data transferred to userspace.

Thanks.  AI review found several things - you'll want to address at
least the first few.

	https://sashiko.dev/#/patchset/cover.1780701922.git.abhishekbapat@google.com

