Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FDE3CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 07:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 756AD6B0099; Wed, 13 May 2026 03:56:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72D626B009B; Wed, 13 May 2026 03:56:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66B566B009D; Wed, 13 May 2026 03:56:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 593E36B0099
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:56:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 111B3120793
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:56:03 +0000 (UTC)
X-FDA: 84761638206.09.11126EF
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf14.hostedemail.com (Postfix) with ESMTP id 13A16100011
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:56:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F0ZBXCwo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778658961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6kOZGQ1xoZ8vpT8iaAghYqq5Prs+nmANrISH6fWxdtY=;
	b=BOckC6zl2hvsKqVgKrVyOS9pisnMpf/zMhWVBPjyqZnjbQeWJqY1TodsXWoW5gmvZqGXId
	XBhoiZRHBhb+fligg/A+OqY5euB6ahAnagK52NIuisXc1haL+4THEtDL6ceNeSIrrUfBvN
	TbmfQ6Toi3eqMgzVdKlPoWLmP5Y6sF4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778658961; a=rsa-sha256;
	cv=none;
	b=EtZMrWCxsCyKDGpaGLPjcM4u9zQ/ClG5iOxY5g0nW9PoYsk3Qbhel5lHGo3faL8FDlU6Y9
	t3MrZP6+Dnhob1V63MX6HcNH5DjPY1WwTtbFIFSLWMMW4+g/B+RYmANmPk0yvgmfDKNeGR
	k+jmpZsgPUeNYSWw5jAX/pYFeXxXPbM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F0ZBXCwo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778658958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6kOZGQ1xoZ8vpT8iaAghYqq5Prs+nmANrISH6fWxdtY=;
	b=F0ZBXCwo/F2fhhnHyY6jUCQ9/b8i3hSb5gHLDalUOuEZ8AIaloagO5byuv0a2qe8a17mv5
	RbzjIn8bnpHlAFbTEKBJgNOmCoQK5eJIEmP8F7D+TE8XmiftncZMG16F+OF4YNLHDfvblV
	rSw4GFf/rFXaj0+HZRNnQhyXw7KzaY4=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v2] mm/shrinker: simplify shrinker_memcg_alloc() using
 guard()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260513075214.2655710-1-18810879172@163.com>
Date: Wed, 13 May 2026 15:55:08 +0800
Cc: akpm@linux-foundation.org,
 david@fromorbit.com,
 qi.zheng@linux.dev,
 roman.gushchin@linux.dev,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 wangxuewen <wangxuewen@kylinos.cn>
Content-Transfer-Encoding: 7bit
Message-Id: <A8DEDC6F-B895-4BAF-9883-5A2318C5CD0B@linux.dev>
References: <20260513075214.2655710-1-18810879172@163.com>
To: wangxuewen <18810879172@163.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 13A16100011
X-Stat-Signature: ytd3ixnh56rpbg8k8jof6xh46t96oiwi
X-Rspam-User: 
X-HE-Tag: 1778658960-741643
X-HE-Meta: U2FsdGVkX1/UazrVecxQ8rwgq+BM2Zwr6sTLmd+2XWhlpno64Ys45mUW/JWega7yGMtvu961ZJLxNIXdyomcFCy5XTayRaeyzHNZS7PqwWKnOPAiyjA7Mo/wwD3uOAAz4FUj6PS+nSS8EtsxFw7+RrYGhlw8j7Yy/dtysN10DHf4cqWHNuP285SnxMIcgNZiU9EYFJ6KcVLZ1MZYw/GUHHEkwOpwWjSx6HRWFGfVVw/Lv5HUlvpwMS89xkX0qf5sefzZ06lxj9QidS1Y8Npr1FflytcLg2TSxZ7tsyHM2AdEFZ4QIEhGrU3/P7ssJ54PADgGqeeWjj6A5uAb6uGD+Q+b+Rv/zv1sGdtjcNVLJmBW2qUwFXYQE7w9DMFM0Iqf+w4TOKF8qe7YiWcknbBoULRsf054mSt+mHRCFGao/y4Q/O4tuicxUTe4eWL3N9H2J7vDd4GVLXo3JKWPf6ViTahMaUx22UgTcP2XCyci14rrse/OmTBroExzHMg0fcw6zqDQOOYcto8wqzGLPU2exsr7aRzIIdi4SS/YKibhxjscZD25OQigjvlCFhSt3Ay7OpVNOhqH+U2KrdHrKCAdFg+b05baSpkwm8eUuAv4qAgJcwDzz56yjR0AvpTsQ8sXa4edIyQ4+s03obGHI95aJMioFH3XwbEZmJvVB0Qdc/Hu+I3j/MatMXr4WvCm4soJmNE05Ot34fPf0Oi1+8D8p9Gfpon1shYnv4/bAnQq+GYJdRbIbYFi64FgbVeU0469dpg++cmM5jflIKNZ6kkVXpYNmCW/Ib+B4oTaXdLGVReYnXLMkuGmJbl/XoIMKb8/ym8Ak9bWnEZftgpSj+EgL5qV64BCFDeKU2b4Zj6ECjhYmOrV4nQUjakZ6yfUo5rA9vsIcqmWRCKYOQkBwXSKiTEWrxthfMf1V5/uenvdXmKK+ay7xpYG+tRYEFppBhmr57qXBm9Wgun1RvV1yDf
 MRnhG6UF
 R2kbLqLGXnlRWrKiuuCU9NJxzdlbVNVqRWKhaDuH31zcLpr7ZItczqVMrEsM6mhU3LOlCXkRU0k+ixfengWM87ZtD+/3lkADt7SkIAtFmtAa9MPPEO+OqN/YQrq8rTxJ2Ip3suH2rBUYoOjG6lANCX3/hncAkflzAR547ObLOQbjSnLyxSTalTKSKtgDBXkv5peNfOthQx4+iQaurafTBDgsAcOxsf9AuHY8cPjI9n9bCf4e3BJwuY3pgPC/b+D3FWib7dLR7qFIub9ZSahkb6D1h7r4vQBY/DoTefKcdAcHlZR1l2yrSmuzARL6n4wlM3Cm66hYug2jtx+w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 13, 2026, at 15:52, wangxuewen <18810879172@163.com> wrote:
> 
> Use guard(mutex) to automatically handle shrinker_mutex locking and
> unlocking in shrinker_memcg_alloc(). This removes the explicit
> mutex_unlock() call, the goto-based error path, and the redundant
> ret variable, resulting in cleaner and more concise code.
> 
> v2:
> - Drop unused 'ret' variable to avoid compiler warning (Muchun Song).

Changelog should not be placed here.

> 
> Signed-off-by: wangxuewen <wangxuewen@kylinos.cn>
> ---

The right place.

> mm/shrinker.c | 13 +++++--------
> 1 file changed, 5 insertions(+), 8 deletions(-)

The change looks good to me.

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

