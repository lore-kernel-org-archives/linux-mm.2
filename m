Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA8C2CD6E56
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 03:31:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 093FF6B008C; Mon,  1 Jun 2026 23:31:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06B746B0098; Mon,  1 Jun 2026 23:31:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC3E96B009B; Mon,  1 Jun 2026 23:31:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D70CA6B008C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:31:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F5311C1FA7
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:31:31 +0000 (UTC)
X-FDA: 84833547582.28.1BD901B
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf11.hostedemail.com (Postfix) with ESMTP id 942D340009
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:31:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=rUbsWu8t;
	spf=pass (imf11.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780371089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eKjT6Zg4boSSOeRK+U8oV+FxAjxZtDyhnFgmKfmpDas=;
	b=5GXm/U7JAXR7eXUw3RUQnQOomAecyQfiAlLwXIxuQ3KKevRAfBgRpJVmvaHUg7S5V3Vktq
	6zCVDawthsTF1xMy1vutFqKanZccAy+PqZUMCDgYZO/gcu68mXU4sqLSd5CklzuhTMpvAF
	S5/qbZfcG+npQKl8VHzXcl1ch1kSd/E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=rUbsWu8t;
	spf=pass (imf11.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780371089;
	b=CEcEY77N8zYW6y4Re6s6v+6eVg/4r0ubEKhDh7zcLzNqwfvRYPeuv6qjwxrCIktemtWs1K
	wnRElxqDSaHgZwjYStq+i95WEXw4RtSGgxi0Ov+FzHT5tWzN0k3LEa0675qvIqKbkmT9tt
	SZrCPf1NKFMdkeBadwKJZnJ65i5TgGM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=eKjT6Zg4boSSOeRK+U8oV+FxAjxZtDyhnFgmKfmpDas=;
	b=rUbsWu8t2d2azz8Ev4bysq6LLCcJ/SHmOo0GFrdvlUOILVf2ZXLEW8XEljU1G4WVXJ3vLafjF
	YX68s2tIiko1MsBkDrbA7z1MYsikporFc7syk5ZlzwtT7H9hvc1crRbFfWDTmaDWX245QZQ/0B+
	PCcJvZW5kHYoz43eLR/pMXQ=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4gTx4H0Gt7zcb0N;
	Tue,  2 Jun 2026 11:23:27 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 1D0274056A;
	Tue,  2 Jun 2026 11:31:24 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Jun 2026 11:31:23 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Jun 2026 11:31:22 +0800
Subject: Re: [PATCH v8 3/6] mm/memory-failure: report MF_MSG_KERNEL for
 unrecoverable kernel pages
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <kernel-team@meta.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, Jonathan Corbet <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>
References: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
 <20260527-ecc_panic-v8-3-9ea0cfa16bb0@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <642852e1-933a-a6f6-b6e8-2ef3339bcd58@huawei.com>
Date: Tue, 2 Jun 2026 11:31:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260527-ecc_panic-v8-3-9ea0cfa16bb0@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 942D340009
X-Stat-Signature: jjtd8cytom4dzpa35an1mqn9bkgk9fru
X-Rspam-User: 
X-HE-Tag: 1780371088-539355
X-HE-Meta: U2FsdGVkX18Ohj/aK4eSEzXrkox5cG31AhVPNoPlUGIgjiUPyFOft/P4n/7AgHg5J1FC7O78T53vOPA0ajBUgD+QZLB8mLukNVuFgg2e4l1JnzD7vazED+K3QZvdu4X6ZPsZ99cpym2HJNNQn8hstN/RZQuOmOJar+T6WyzXN8hqV4idzmrUbHCA+dISkXrqeIVN9Wlij93A12bVyLyg1h6uiD32DO9d/sy1rRomleBWeP9B3IOk/4YlUsYqjTZieCbaVbPj4QX/h/ioxVb4vG8J2XZlDDNOiceEJaFUrW38h2dqI/XwaYoRY/Ewq3j3WgVJbHHW1+AEXS65QrwCfHXfuTz/5/n+E/hQfIUU7ymAYwB4IYbKV4m1lJ4sAmY0vTuTfvbouPSpDBXNK/VLWoCx4XG7VxBdIg53gog5fCH8Z286LGsKzKN8WSncGYOW8g7tr9ELzIjRQiXBs1BLxCauUM/wGT5QIIjTSYnspqABn/z4yBVFbOPgy1tPvYVtqd1avh6XL95rP7t8jxulzz0vOiLiWe1RNG8eT6wtFyC0vcK6BHZGev1NuemfFcvEn0MEfKdcFBRao3A3amRT7q3PhCFR6izKwcP46s3CFnF7SPXP60G1JE4Yq5Rs+dIWleM8iRLfn1Zr1Ua28Z7RrrLqHVSlbXFYVEXOEVJVdCMjOJTCLZkw9ZcGPY1W/GdMVrzLJCHCr0T6l2xEfLuDf0cHUiHftxFlV+n7BsYSUD1uMzT3hHX2eqXf6c+4MKp7+eULzjc9UIReKVWCFuZDcjDyZK9WlNylfqW2x/jeY59s5rtlK+KP1TFVdPdevU8L4JVgM+kCjt5SPLhd2LuBJZ06dtAUi/7jhKN6ObBVlluyrqq13v/KEV/z5U2GTKSfNddYdhJXQkz8nIWATdEkP1OrWf7TXMkggvpe+TyYz3r766v7bZPbd7otFS0z+7AKTHNcFNi90IbUQotwsD6
 0xJ1ZdD5
 aSlzJo+ox28+uzDvInnUNMoeMIfa9SDy2ZuuWrs3Mao9meS2Rg8lt0gy6qX1EGzBQl2sXt10bASM+9/dwFBu9UY7LYAV93jR6CUV6n+Kx6iMgk1jLRLL/tb3Xad05t3tq21iuAuGhStpjp3noHWZOr5cCtIGuypChouM7jEQDggmUBpzXXR5f0CaALlZ2YjnNFh/ZUZ97EQ3kMBEiPhb1bNNE8BAF2r+cdGwiAetg4R8o1VcuVZII+A8frCWkA1xaK2Puv4JRs81Po/IjsN+JkWOWx/R2R/jFXS+sSAEMKkD64H5FaxeHO/b9v1E9Fbif7qfW+2cp8W6gjlphuXrkcOveXsTqK0M/akOTmG1vUfOHq5IzIDuWotZWMjLg8GhIpWS+TOcZMJEICUap1xE3GUcJ8RGOSAWffRyL8CL9lGsQU/wN61UPQhwBGwQmci4kTYW5aLHTm1BuelWMINSW+HFVMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/5/27 22:06, Breno Leitao wrote:
> The previous patch teaches get_any_page() to return -ENOTRECOVERABLE
> for stable unhandlable kernel pages (PG_reserved, slab, page tables,
> large-kmalloc).  memory_failure() still folds every negative return
> into MF_MSG_GET_HWPOISON, so callers that want to react to the
> unrecoverable cases (a panic option, smarter logging) cannot tell
> them apart from transient page-allocator races.
> 
> Turn the post-call branch into a switch over the get_hwpoison_page()
> return code: map -ENOTRECOVERABLE to MF_MSG_KERNEL and any other
> negative return to MF_MSG_GET_HWPOISON.  case 0 keeps the existing
> free-buddy / kernel-high-order handling and case 1 falls through to
> the rest of memory_failure() unchanged.
> 
> The MF_MSG_KERNEL label and tracepoint string are kept as
> "reserved kernel page" to avoid breaking userspace tools that match
> on those literals; the enum value still adequately tags the failure
> even though it now also covers slab, page tables and large-kmalloc
> pages.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

