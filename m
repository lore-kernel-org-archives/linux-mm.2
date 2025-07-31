Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA76C87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 15:24:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 626266B007B; Thu, 31 Jul 2025 11:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D7526B008C; Thu, 31 Jul 2025 11:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ECD86B0093; Thu, 31 Jul 2025 11:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE416B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:24:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 14D781A062C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:24:15 +0000 (UTC)
X-FDA: 83724930870.09.35770E4
Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	by imf10.hostedemail.com (Postfix) with ESMTP id 32725C0012
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:24:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b="arDw/OwB";
	dmarc=pass (policy=reject) header.from=acm.org;
	spf=pass (imf10.hostedemail.com: domain of bvanassche@acm.org designates 199.89.3.6 as permitted sender) smtp.mailfrom=bvanassche@acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753975453; a=rsa-sha256;
	cv=none;
	b=hx5ZnEjs/oCz1sPLkfyc4adZwJSBVL1HPFWkRuE9L9gqOXaXzgYSoJ6YZ816/NaqMN7bAl
	32Mx9Pt/plx3PO1vsd7OUi8syXmxgaJLEGjN+Kmw42AsR/g2wZqE11sq7zNUgRuIC3TcqJ
	lzUY2vdrCBgOFXZkz+YBq5SLpsMPLiU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b="arDw/OwB";
	dmarc=pass (policy=reject) header.from=acm.org;
	spf=pass (imf10.hostedemail.com: domain of bvanassche@acm.org designates 199.89.3.6 as permitted sender) smtp.mailfrom=bvanassche@acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753975453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o1yFhBXe6Df7icg5S4t03u8nAe3RsB2OOTx7cXSxsKw=;
	b=k0ZLeBcwvNe/3j9szxtutdwpIbBWMckaR+J/HkFutUnEEdeHQUagOsGxpYEN8ZGa+vPToq
	Sp70g/BRwgqHZvHxeNJEzXNL2ll+dzu9Tw5SOhbOB2yTHiEPBh5NeyCQpuxSijV8HMY7dL
	+jAbBnjk3EWMIGFey5jPt2aLsyVLh0s=
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4btCY82LMFzlgqxq;
	Thu, 31 Jul 2025 15:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1753975450; x=1756567451; bh=o1yFhBXe6Df7icg5S4t03u8n
	Ae3RsB2OOTx7cXSxsKw=; b=arDw/OwBjKPG/IlbBBa0POdIU3kjKUJACJumsbkW
	uEaLuCG1VslvRaxLE5sr5BKH9A46j2S2ns0VEVFAvNYadcgrJns76QOACzmy3hrd
	A6LLC93g6/sll7uCsuZWwFsfOf/WJjcRd5OfGRSw4vwnf5XFUR/nNn57ddzxDNiH
	H0iYrSHUG/wS7pRGT8tY3KeKCu0Z3UcQzacZXOd3IG5gTgub6KyRdK8Wyhga/83/
	82+YhrzyXLAcPrXU8TyYmGsjXwglxS82cPHW+RGzt4ip5nM0n057qz2eIWlrbwpo
	m8Y2b0jA8Pjt8qLlPo9zE56sR38RD9JxgJLo5W3NLbFbTQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Et7EXzwhqAaU; Thu, 31 Jul 2025 15:24:10 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4btCXy6YhNzlgqxh;
	Thu, 31 Jul 2025 15:24:02 +0000 (UTC)
Message-ID: <46a544bd-a3dd-4a6f-967c-74c3bbe8f18c@acm.org>
Date: Thu, 31 Jul 2025 08:24:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] zram: add async writeback infrastructure
To: Richard Chang <richardycc@google.com>, Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: bgeffon@google.com, liumartin@google.com, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-mm@kvack.org
References: <20250731064949.1690732-1-richardycc@google.com>
 <20250731064949.1690732-3-richardycc@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250731064949.1690732-3-richardycc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 32725C0012
X-Stat-Signature: o71iyog6u4k7ye1yff6oy75iz7rj7qod
X-Rspam-User: 
X-HE-Tag: 1753975453-917920
X-HE-Meta: U2FsdGVkX19kDARzMq0sNiUNMauJNpceXRoh9tBlUr9OyKO2aheo9t5fUHTgY2KisLwbsvwZ0AmKGwcnuCr2z8epKgzNz+AjSpEFY0zWxYLc+fV/37jNYF59ud6xL9ylXBXtLg3gKHJZB8dIJom69LXg5ISw5U2MvCXi9eqztqW4OvWskuor/1D9/z3g7t/uhg3fRNyWmDc+eg161YEDz7kC8MkBhZHYmhW9K/2U/w8YRx81jlgVTVSznIEwbWCbJiamdokm3saR4uhoIU523I0dNeO3qdAmGzrq+Av4aGdZPQa7vxz34NZ/QajTBpyHY2i+BBxy01lvngyBsf+9Iwz+zzPJOHLq/gAkf0loldXCHRynWaXcqOQJ/2+xYeuQvuWGoycRYUY40kqR3rmnOG9fXLyW+a1A419ea9KybXvj44kW0NcJT+NDtLJaZX46CRd9PfSfIFtP5v73M8FPoDor5+E6ISVxwO1qhO+n+52mgEnZqxOP8cTdUXTixb5G2jX24NxVt3Mn+1AOD800ELv6MgM6Hcdg04iC6nkBrbkYrw0u/m4QtNcT6v7oIWCkOJzID+/oCcC5j/tNZfLiOgAumaCvTMFyI8QB0BsJsHcCARSjbYTIN9wayrQYGvDC48mCyZ0K/KOp66jbD7Tg1GTC/3e/uGaaQV9EMsBOh2iyQc+/LrrsxHG0RNy/y1jKPlF0PNMTci6WvIjFjgHyvoWT3V0LdRDn6u8hQmHGjFFDr3XiEeEhX+gHfA1WlNeszfRhERQuxMl54+dY6R/0JOdxFQ1Yqfxeu+TwFvkeQ5uzqIUdRkV9C/WRxTxZXFnIFRYelwaMy4l70kdi9Gb5uvpoGi1dZlqPViEo0NxPN7TelERqImdZKK21KdoNvVlREsLuoto9K0g5PfZ2mpolYfQT1lZ0i+hxENbFEwxgf0tn3so7esNh2pVfK/z8AKBwWX6HUigZ6s9MNfQMl4V
 P3xWQT69
 ujfUZ8NR8UXagu+q/Izv3IuLu5HMQoHUm/YRLG3Q9lK6oZrBuNGr33YJPUH16MT9Qx8perY3EvrTWSPpHjol24pc3bAfFC/bsMc53MZ+IHJeRjs9E1A5k2Klo5NM8i467NAnbukdIKJuCWOjU7VnvvJZyLMB1xdJK93ETzXoj1WPMFF4tA2+6ZbgbHdD2T1m8yn8u7fy9vQ5ACXY3JooS+b6JuNnW1DBqshkYisshjS1IUFLXloDif8GFguanmnKqBdGE9b3soNZKeBoilLSGnAyevCgw0uwVMPBG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/25 11:49 PM, Richard Chang wrote:
> Introduce the necessary infrastructure for performing writeback
> operations asynchronously.
> It adds a dedicated kernel thread (`zram_wb_thread`), a request queue
> for managing pending writebacks, and helper functions to deal with
> the writeback requests.

Why a new kernel thread instead of a workqueue? More memory (e.g. for
a stack) is required when a new kernel thread is created compared to
using the workqueue mechanism.

Bart.

