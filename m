Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C8ADC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 03:33:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C898B6B00A7; Mon, 29 Jun 2026 23:33:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3A2D6B00A8; Mon, 29 Jun 2026 23:33:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B50396B00A9; Mon, 29 Jun 2026 23:33:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 849F76B00A7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:33:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D14D0A0365
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:33:29 +0000 (UTC)
X-FDA: 84935158938.20.D7D2509
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id C02D180003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:33:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="zi/AJ0AW";
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782790407;
	b=QhunweG1/5/h4sT1ep1An50oK0ojZVTGzZcapcuKBpq4pmzpFVxNZjpYJ0C7t24c3GlSgU
	cwURtIi3/Lo2fOOMQnYK/u+Zow4UY2g7Hc+t8dI4DorU/H+lH6RIFPSPMyloC2E+KHifxK
	qmB5wb6aeeAuh9+FvvodD7QsOnywc3o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782790407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Ci8PvJxUEXJD/vTo5guO6KBvc3lMdIG3mY5xBsHIs8=;
	b=AAM+eqTHt4Cf4GuMQCyKkd1l4fWWkTY36lzcldZqk0hDuwIbFs3rQU6gprYssuVLJJ6HiN
	wlRZswkLW4QT/7plmnMppHaiVDmw0Cn48+ulISy1Z4+EIRAil5jbiTvP/W8/DbvSiWjkWc
	HXWMi27b20dyvxC1CvgyKj5zobTjICQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="zi/AJ0AW";
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 350CE60008;
	Tue, 30 Jun 2026 03:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50381F000E9;
	Tue, 30 Jun 2026 03:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782790406;
	bh=0Ci8PvJxUEXJD/vTo5guO6KBvc3lMdIG3mY5xBsHIs8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=zi/AJ0AWlCR2rnSE/ztL1W34PTx+fCXehlxp7pe2aGQZqbLbQZFFsoRr60uHaTqSS
	 Mipx8cV6fhaXDEc8zi8BAXRkCfvC7868PofqkzwxlNNHxm6bnm0fAc/bkkd4XomIR9
	 gEYXZTynSaUBTRhjkIMR3L9Ia36/myrJCjF1qebE=
Date: Mon, 29 Jun 2026 20:33:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: vishal.moola@gmail.com, ye.liu@linux.dev, zhen.ni@easystack.cn,
 ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/mm/page_owner_sort: report get_comm failures at
 source
Message-Id: <20260629203326.fbd5714e7ec8cbf0a22e7148@linux-foundation.org>
In-Reply-To: <20260629062546.141659-1-chenyichong@uniontech.com>
References: <20260629014316.130307-1-chenyichong@uniontech.com>
	<20260629062546.141659-1-chenyichong@uniontech.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C02D180003
X-Stat-Signature: s6z7sm1ish7whsudr5bdg6rtsf48r79w
X-HE-Tag: 1782790407-429043
X-HE-Meta: U2FsdGVkX18A9ZNyXH2amCLqjp9js5LmguMTMLaXaskF3zzu5MB3pqk7dys45PBUszdSr9KnIIXduOtHAaUarwKqQOZdFqWqp0QjlUQOPIXZoYS4I04IvAKFmLryN0u4mTUkg+PLRh/l4Wm99YvYP4wLxxznoxpgwQ3bQNvBKZtUTkUIAZQLUV+Nu65UxmUcWkODjyCRk1MrSfWOwiDRo5UYIT7+qgyv3yRlvI69ZCNNBj0g2D3tIp2/EogE/+GZz3irpnasm78n00z6ULhBHTqh/gqex1pJM65M5CbRAQ9WKB2MNcve30wEn9IBKKedatVnpKcJj9bMfNzW314L8AppW/CrQivECCkVJNYJ54r1YoqQLiwngSVa5mR3PO0DEzSqjwSVXSyWzldRwN76HrhDxoTW9mBEJ+aHACocqDGH0EwaJvF1EsmGEoh1IDI/FMr32o2svlQ5Vuj1qjVedmZoK6AKl9uhikXrG7T3wDVH3Ow6ysh0uAnfwXSV/St8Uw+3IvSN15Pb1UQqGzhxVHnj2/BG2G21DzVeekOMdsjpjC5Ea0vVsLLs1ccyYwNyKnP08Ynp8btgYLVqWNGphZaHVqdW2gXE4IVyf7PCePnvG6PlRQwCR1ESRr5r04YPZS1MjNb2ZREa+hHKe57s8VkpYS/ZWnFO97tqI4Q82LLBKeUQsgTH1LiCDE51IwmQliEcSv36rqH7yebnHu3ZURkGPvojQzIWGZLdtHeC862EjqWM9H2cAVrSYZenO5YsktaOY8e7Y/u7cFa8DldMXPGts/twSLcIkOVC5nR+V1ThjvrtU+5zbllLhPJ59jMsC4siOZ2EyiETTZhXowUzcE5CH3QyRunEDhQdMJy91DpmNodDixsWBGKduyn3v/Ag9tXiwzsMws6FoI6LoIqdUprVpHB5hB745McumG1kqtdiSzV4cL/Aav8igg1gh5AzL7ypwO1xIpNGmhqp7mQ
 7IZqx7Fm
 tjUm7GOIhwv6xX39T6Wx6qvGux5ijgIrUmZj9eKsPzkS16KxR+TzTHelD57KC8GhxWMvCgH7ZW8ynbGFxiCXAeuhnrrTITTjq6NuJMmgf/dcPQpMU1SycaXXUHFzwM21i64urcYOIz4X+zVjIzVbYB6JtjN9rpUh40yozTr7U0zPrvsWBN7fymZwM8h2Xepz9Hk25Pu+U7zfNCwyQhFNyq9v3FOx+2+Z63rg4wE+BkEGnzrFTa2kD0nEhZK/9EoEVN7+Yq+4/f80k7GDvs+9lSVOcsmnsnu9v5eIrtXqQiXdpc30O9UskQufDMIDwI1rSwkxSHbk+f3mVR574CJbpTwED9RK7cigL9k5ZuuEMPH+x4DIGIGqqKWb7nrlb4ZXya1oSJ2kVGm251UGkimENhz9BtRqpgVeIjgkHkKw1UEh+z4rZIAy+QEpjxqS9ogheeDFI8WBMuzbhXDrO3oJ4TXHOuEPpgSanu5oHqSZc0Pn6HBE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 14:25:46 +0800 Yichong Chen <chenyichong@uniontech.com> wrote:

> get_comm() clears errno and checks it immediately, without any
> operation that can set errno in between. The check can never be
> true.
> 
> Print the concrete get_comm() failure reason where it is detected,
> and let callers handle a NULL return without guessing the error
> cause.

Thanks.

AI review has an observation:
	https://sashiko.dev/#/patchset/20260629062546.141659-1-chenyichong@uniontech.com

