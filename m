Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E208E8FDB1
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 12:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B57996B0088; Mon, 29 Dec 2025 07:34:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADBB66B0089; Mon, 29 Dec 2025 07:34:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D9FD6B008A; Mon, 29 Dec 2025 07:34:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8F0606B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 07:34:41 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 356B85F0E6
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 12:34:41 +0000 (UTC)
X-FDA: 84272452362.09.891E4EB
Received: from sg-1-104.ptr.blmpb.com (sg-1-104.ptr.blmpb.com [118.26.132.104])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9E60B140008
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 12:34:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=oaGtEelx;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.104 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767011679; a=rsa-sha256;
	cv=none;
	b=AuUb/Oxi3jmSoRmS7d42Xjpx8IO/lP5WY0xCRqPi74VTZ+LlF4HR0GQPb+iQ70PvY/Wo/N
	D01yZHJuiPPZj2Yx2vw68qZTyKeKx0BxxWuqXej2zqmej8bYGCpZ9PlstkvM8G3b941kAC
	g+/zSE8O6QjO/ZLN428l3Ov4Uj4nWM4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=oaGtEelx;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.104 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767011679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGCjPv294ftgpzkPBae93iouuOvwdl6RovdFpV1TG8w=;
	b=oa2/e9quyhhroZZLVm5XF7HWMd0aHie8O1/q3O8EPfPISHBUAHv7SyX5OMT+BdECPVgJCY
	sHT2HdYD6ZE2y8lDIPw52I5qMxPN6iybyvzYCN3xyxtV4otJA8IiDi6dUbct4fDw8IAYjC
	yC9P++3naZGrY7giLZJPyy4OPfKo/Rc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1767011667; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=UGCjPv294ftgpzkPBae93iouuOvwdl6RovdFpV1TG8w=;
 b=oaGtEelxI+g/ne++wCICpTQk5vcRIrpb7osSO3pjZWMZC5hAxxqU82kNqDQ/S/QIpCAUdk
 K+ka+kZSj57thx1JwMEFe6wmbu2228/Eh8119OXje8UKM2mMDDfWouCyACX4pQLtOpzGR9
 hoouWasGz5Qu0RnVNZXee4KDBgOm6ifHlsaCxOtDfo+Pn1och6RIV6RgrnY9hcCorgqz9V
 sM2EQHtq8RvDVSIiSR6EG+P5LDyrTpbFTyRw7nGAUWR26IFNC+fRygFEM4rtw2hh5b1U1K
 +d/aCWEeIy28bU8ukE8SD+SrK6kY4heULxFFoztJ53dk9kJtIOWEyE1EgjJgqQ==
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/8] Introduce a huge-page pre-zeroing mechanism
Date: Mon, 29 Dec 2025 20:34:07 +0800
X-Mailer: git-send-email 2.45.2
Cc: <ankur.a.arora@oracle.com>, <david@kernel.org>, <fvdl@google.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <muchun.song@linux.dev>, <osalvador@suse.de>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+269527551+cd7664+kvack.org+lizhe.67@bytedance.com>
References: <20251228134454.89617c004a6625556f7ca9f3@linux-foundation.org>
Message-Id: <20251229123407.7669-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <20251228134454.89617c004a6625556f7ca9f3@linux-foundation.org>
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9E60B140008
X-Stat-Signature: 6ujaej8zk65q89nh5drb6tqtrzsgwg49
X-Rspam-User: 
X-HE-Tag: 1767011678-802937
X-HE-Meta: U2FsdGVkX189tKsj2qOGdLUbfJdIFPeKVjNimHR/YHgyL1Jnld8GUhmg1f0UYyq9uWc1X1zIow4tx78F49F8VKE5HI3Bb5BDFUeU2PCOErK436t59dgBDxMDZ+6QRQ0+L/V1fsIpt55M+jJgvk20J44G4DlIC6Dudcj3ArXMR/fNWdeZGDyRbdSwsr/8hh4L71LMnpjrd2oUoAa21BvfUtVqgEcG3mUKF76zspMcg+DsIx8EzBpLW9nSKcmnHZTcUyHjaKzxHU5f9YIOqAocKPsv3mg+jraXdXY/SYRAc4q/3ccE66WQ1p/ICXynsfwiq0EmNE5+kp9I2yI6hnd3pKQifq740UQM9dOVBdF4uA4cYUBA1Xpqm8Dmc8p60cQnSpVGLgPES8SXpDkWPXaI72PfApOEmX+krq0xJf9E3vME9ppy57stHewQSLKM16Xr38VqmJwhJX0QvsFXjDYyqA2ieD8uPS70SrCovy6FPh4+ZvytJ8Ts4hJOmV0gcGZiG32C/Cs8Mfaq4mxr4i7pCuAf8NcE7t7fieKLvHxp0oQAtBKMwaZVo1q1Gz3VpVxY/NK9r4LuOY6GhY/ZPr3b+r/2tOa17paG6dhINL1+YbAxwKOGyijE9kZWoACn6NDFCi1qoAlD13rQE+VjSXhLq41j3bQwqJ5Ce1nnlQS0gJHV9QXJ0OoyUc6Il93zeN6V/4UMxbTvH0QcqzBSwxvn9Eu4ffHlDITGavR6gJe56PGChvLBhJsebHjDajeXegJNXQyssEgmrKvXZuT5Vc8Ym4c3Fjo7pkXVq6dXV8QyYuIRFLlXSFChadE+t/NkSlXmEllxA1YNsGh9q23hj1ES4InNVkRF/pEY/CjCRx/UwsqpRQnDVulAXqiWKtaYpOUtGE8f8RfxDlurvTzNUL1ckULpyU36RLH4yPOnk7SDTTiZ0VejPRxd0OGdMyiwVF/oI4NihlWgvR/9g1gSBHy
 cX1Vcjki
 3UlQJV9PMDoOldfMIDzouS8bSp6KqKYmFchWXZ8gvOaIYsc+uM9i3h0nNkv8kHpTNAcoo+lxr1M+KnHRNpLl6c9c4vLEH2mc0Neo3D7hPOoNWYO2ZGirx3HffE3jzEnb3cQudQVxgDRB/FqTPvqwpQjaAlzfSwoXbzolWOQW6Ao8cRsB6aQk0hvFzRalwqvO8JYlZfx+hiEUsrxCkNGBK9e9uln7sAJQoEp3c811gyEgYhSCs3vNyRQzFZrF/xnxSFJ3wxEBtWVsxmThlmoy+kJ+u2adf4ESpX0znqCQyeMiOo1fJGEgZLMjJJA0P0lULuF2HYXXfWodnW5BwiSfitzMqnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 28 Dec 2025 13:44:54 -0800, akpm@linux-foundation.org wrote:

> > Fresh hugetlb pages are zeroed out when they are faulted in,
> > just like with all other page types. This can take up a good
> > amount of time for larger page sizes (e.g. around 40
> > milliseconds for a 1G page on a recent AMD-based system).
> > 
> > This normally isn't a problem, since hugetlb pages are typically
> > mapped by the application for a long time, and the initial
> > delay when touching them isn't much of an issue.
> > 
> > However, there are some use cases where a large number of hugetlb
> > pages are touched when an application (such as a VM backed by these
> > pages) starts. For 256 1G pages and 40ms per page, this would take
> > 10 seconds, a noticeable delay.
> 
> Ankur's contiguous page clearing work
> (https://lkml.kernel.org/r/20251215204922.475324-1-ankur.a.arora@oracle.com)
> will hopefully result in significant changes to the timing observations
> in your changelogs?

I conducted the experiment on my Skylake machine; below are the 64-GiB
huge-page fault latencies measured with 1-GiB page size.

Without Ankur's optimization:

	Total time: 15.989429 seconds
	Avg time per 1GB page: 0.249835 seconds

With Ankur's optimization:

	Total time: 12.931696 seconds
	Avg time per 1GB page: 0.202058 seconds

For comparison, when the same 64 GiB of memory was pre-zeroed in
advance by the pre-zeroing mechanism, the test completed in negligible
time.

I will incorporate these findings into the V2 description.

Thanks,
Zhe

