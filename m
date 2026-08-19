Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68336C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 03:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A93A6B009B; Tue, 18 Aug 2026 23:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15A4F6B009D; Tue, 18 Aug 2026 23:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0704F6B009E; Tue, 18 Aug 2026 23:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEC196B009B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 23:17:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C0104040A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:17:09 +0000 (UTC)
X-FDA: 85116557778.04.32D8FED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 761D240005
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:17:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=W3HBMWD0;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787109427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJlpKyqUKzat34dlX1t84ExmqJi5Z0mvjSOZBisUEqc=;
	b=HGYgOrgc7TGB4ZATOeohozPAGLFWUswO9iAIpXLPAZ/mEJXVtpEcxsrjuTV2OeKuiGV0IZ
	s/wjhZeXqiuTdj0/Q9/yJq9ATYdUJj49w1VS3GNTig7HM1AUIad7lM4kbNuHg4YlebrD0W
	2jTIXHkvWAMvRUfE6O8teM+VSj6vLf8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=W3HBMWD0;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787109427;
	b=qrKxymnumXDzO6MqzJxoIuy/iCY6A5zeAZiUs9crTahV78fXSpnax1DCpMa7+rWcrMYLPX
	pvfxchZWEgo8hSQAbZMu6zrG9VkdB/6NTdMPp74ZpV3GlYLEtb9M1wUg22wMJNHImnksAU
	kTbTkiFcH7JfseAdYzlwPjC1vxB8NJ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 27E3C436CB;
	Wed, 19 Aug 2026 03:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4261F000E9;
	Wed, 19 Aug 2026 03:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787109426;
	bh=aJlpKyqUKzat34dlX1t84ExmqJi5Z0mvjSOZBisUEqc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=W3HBMWD0Q9VSIhbqG4DPn2GUiZMNe6rN9/BjyNlsenWV4WggdD/iMUOhpD5LhcznH
	 2QCR4dnt6UY+HVYpvNHV7tAM1Isg5qOfqkGVgsxx2Y88IEbfnM7SUO9z51v8djVNIN
	 2ndvAEzrSqZUzveXa3T43akZ2qc0A0KgGMukBWyE=
Date: Tue, 18 Aug 2026 20:17:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Ye Liu <liuye@kylinos.cn>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan
 Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] tools/mm/page_owner_sort: fix --sort, add module
 filter, improve usage
Message-Id: <20260818201704.26f48cb26420ad8ec00fd226@linux-foundation.org>
In-Reply-To: <20260819021611.2910835-1-ye.liu@linux.dev>
References: <20260819021611.2910835-1-ye.liu@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 761D240005
X-Stat-Signature: ihqewoa7m5ujjgwa3fmycehp4fb61g9q
X-Rspam-User: 
X-HE-Tag: 1787109427-525337
X-HE-Meta: U2FsdGVkX19KL6tAqYDUdjl2R3IB5bFWjea7kVZhFwPfFlSw3QlZAwlsCCXtOS273cmWQb+eaMgWXq28lEpdr/HCDXIny//ciRoHUEfxv4Yxb9hRcTRepDtKUiGgMSRYahSUGltzJCghKjhaabRsZt5D0OiTyPZg/NX8ZHTnSGmX6GXd6oCbpL1rCKgMnFWWUfHDzQoB3Ol2l5oPVYauC5h5tH3B3lYuPj9kYUZdvRXlr7iLcJKyBavAmz6/hc5pLUnTbRVeheiJplSV+q/L5KcHEHKJpQ3nxdXeSr54AiNQ7wY1HBU/5Zv353a93fRbxxv+ji5Okt9lVy3pcLHxUcIWly5U2e6OWPxkLWJoPjcbGpWxVTS3hNCWF6WUOYrest76HisAYIvCLf6DT9GzmwtyF9/CwPN8mkinVD1OMK9KbHPojEbpT6GLnJIQ1zLRkv3aqfIpM0YUsU+6TCk39brZJGTmfdk2o7M2n0rBdc1K4JZLdUNq4VuuIRXSfO8S106SSK2KI4vXrNFH9JJTuN/rCisM7LlcQouGMxtaagKnm/DzLwdC1YrlxDjxkm21O2x8C9jttKb7p3Mn1voWQ422VDHEFMvlK9OjCjRwIngcyRZYX8BeCrswj2P3YY7n/Usrcorfxq/6kvlDBwwpugiQxaIQJr3DUkiOVhSMqSbooxOXmL3Y1SeSwJKInrXALh43NmG7YoNX+lDVzmT8oC6bdvzIplX8+VKxp0DNzLpBWf9uDcD+0G4v6VKPnWhThKf8eZ/bgBZXsbxOHX7KRtgwCpR4NBBVmZ3B7Ih3GTIQHLqo5M9+t8Qx87HUfB4kakHbkkeV7Jde4jMVR8HEo4u5XqKCBp620x5mPRYpGIAZh0nw4SIBvs+5xZTsXqSD2LrCwo73ooV0rsSBlr7km4sNhw1Dovnq730NvRaZ6hYlc68u1/HGJZOPKIm3ORLLSeMQEhrrJVdwz5pBU1y
 V+kP8xgy
 o8GaTmqkH5HhNESkrJEV2U5rlBUdyFIzuGUj4G6dSDgsKWgiZ2vkJANLJIkYjX8YJk7keN8IWd+0UtdkpRD8dBUPY7C1tmQLbatvjL6bvlGqN/SYTHbflw6yrsoBMYJs/TxRx0PJJMZvvteeACMEOiOS0MOMsLXyoIhLvrPl3syPE/VrMBI1Q+CIUzS1fX2o891b/u355lkg1xtr1XhdFZJ5kFU9/iYgs1odeU0wmCCvohPq/zUzlEju/HJrJNX5414fgIicNlUgVx8wZIPdRPjjGpMJdPOKzuZVMY3cotzSww3Ke/PubfxT01wge+am2ysrCMXczvnJ0qJZWsxsNKdMf0NubkKCZM5frGvDD+up8FpE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 19 Aug 2026 10:16:08 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> This series improves the page_owner_sort tool with a bug fix, a new
> module-name feature, and better usage text.

Cool, thanks.  I remain mystified about the recent flurry of work on
page_owner.  But I'm glad that people are obviously finding it useful!

I'll stash your series away for consideration after 7.3-rc1.

Sashiko claims to have found something rather obscure, but it's
probably worth cleaning that up:

	https://sashiko.dev/#/patchset/20260819021611.2910835-1-ye.liu@linux.dev

