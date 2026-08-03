Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF9EC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C3046B00BD; Mon,  3 Aug 2026 08:59:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3738F6B00BE; Mon,  3 Aug 2026 08:59:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28AF56B00BF; Mon,  3 Aug 2026 08:59:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E606F6B00BD
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:59:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4AC8C80681
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:21:10 +0000 (UTC)
X-FDA: 85059867900.24.E5C07B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 68B4D2000F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:21:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GRcM7qCe;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785759668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O6rPJX/xVGWVF9zsA8o8w81JCtpZXuhJSo94UA5ONX4=;
	b=VF1pm02mMMFUesoWNxZM6wBdloGpedHQVlk/sg5LAqsOPH0+4DcM8r+kgXg/dHIkKNXdnk
	4PPBn13LapYY9qNTZ0n3+9Ks4lVnMez8Kwo9g8efHCBAfzsT+y6Z5TCx6FldbUMLlL8jO/
	vfH22w1+IBhkInna4IhbzHXF2XeCvWE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GRcM7qCe;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785759668;
	b=H0ZLs+HOHid88erj/r/bvM/ElGTk1+IEkxRESFwBhK2A3+lLd+4jUX/YOj+qQowD6fB/Oa
	A8yk1jrTZCU9Yk7SImQKea8HGgkRYEypUZlnOmL40fDgCR4CMOhd3KM+74OMs8jyDFf27g
	BOBXe9nZ1vQVBXe4aFBNxBXLfCyzDwI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B19443BDC;
	Mon,  3 Aug 2026 12:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FC71F000E9;
	Mon,  3 Aug 2026 12:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785759667;
	bh=O6rPJX/xVGWVF9zsA8o8w81JCtpZXuhJSo94UA5ONX4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GRcM7qCeH/lYtr1JcWg218lJRY0s/6HSzlMFse+6Uc0F5VIOhuGhAiEwVozRBUkQV
	 ZzD9Zu9sUzJUq38Mi06sXf9FXGnnVVyzDShtPrPu0i8kSbXhc2+i0gzMr8KPgueVtg
	 mm/5wvEUU7PsIPf/Vj9Gu1tblzhNESa0JOYV8ULUZQlRxYJcYXGishnLQhPIRhmGkc
	 8fZXhloC8MQXTFFJTAmpwKUo6UX4hXFuwbUcYsNVI0NinzW26ulwJSBXEXxikH/A9G
	 BzLKZA5Gt9hS9GOmVaQ9B0BE0CJJC1Tz11Z7Xc1i0f4O+NDIZwWGyW4y5b0NXXnkyJ
	 xwS6MOel+uffQ==
Message-ID: <944bfc30-68e4-4ccb-8b00-f0f86d27cb56@kernel.org>
Date: Mon, 3 Aug 2026 14:21:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] make unused huge shrinker memcg aware
To: Qi Zheng <qi.zheng@linux.dev>, hughd@google.com,
 baolin.wang@linux.alibaba.com, usama.arif@linux.dev, brauner@kernel.org,
 akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1785746588.git.zhengqi.arch@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cover.1785746588.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 68B4D2000F
X-Rspam-User: 
X-Stat-Signature: fk3xjfja5u14f9z3aix5zu3ids7qo7i4
X-Rspamd-Server: rspam04
X-HE-Tag: 1785759668-252829
X-HE-Meta: U2FsdGVkX19t+ShR182vIssDjontM8FbOSY0Ip7ycXhVafuUyzvWsdXdiUcpqaf9uCKwvNu+0DH+Xq5Ted/FePKTZVMqEzGVGmt1WxJ5KqUfHHdt5113F52X74TvoNMuDGauFAGOegvbk8zXFd79tRotv3Tou8+TLRAOvYlxflrHIcT1rIhzCesEepSU7r2aGEnUpHUgQvGn2qMO9EDE4FR1i4KQIDekMOXey8qqKKjbJtTqXhX4zy/Rkg7o9j8WHXlkaxmvVqg9gBF5E/txa3lBQ06fpjOZ99rZXIGJeZ4DD9x6f4Yg+2hxvSkuizaJjJ3VoGPqEYMdRzXAAtgzhmoVlCATF4XuTnzZxERso34+KU0ozNL8Fw7TKzhO4KQSfsnuDr2A2UP5fxR6WpohNmJL1htLB4FynaRQUWfhvqc7CLHr5FVkkCT7h9AZ5UtwdDayzvTzaRbEW3J5IpJkRJ2ExiLfWhY3x8iudzMxicskb9sOavbl0tuSJ/OHBDnwLZY2yJHzI4BULXR5Ne2aC6iBp+snctQPS9/PFuXmJ44UKp33gHZmgHBF2n98DUMHntHycZCVKlrJcMc5W5epy6jmcq6+k2FsblTxSukz6qt7tV2HB8TOLMYjlp9ONttZfEXmTo6iN4PqjVE4OVEoK6nHckW5jMV4eDi3alA43zKaRE0KlWWCVWIrMs4qM+YFWdDgb0KKQ47V2VXd0AVFtnPQpoK5VNyA4etkrkUzemEKhxtYcLHPcNhO5/XBnG4f09NHwxuijMqh6IRxZzPywoqVPqWd6gInLaxR73icm92tHUMjfDfQCOEbEMaH6yK+SnIUbM/YgzxtRH3hUTvvdR9loyQ3jVgU30rkyVWtMBBfNN9ondCfVfczcCgT05suLuKoJq5qd0GxZq3o8saodA2tFXfROmP7XxsdRwtoOeXLSWY7C1/0GZTKS4g7Dv46Uk23TQt9Lf1mPKT0ZgH
 R8MCh/yM
 TMyLJB0jbjKpw/xuqQQ/eJiRJ2uGD7ogbe9y0iXTnG39saeokiCbnxBTTiNtJjMWoY+hUsJKHoiTvJkVZaCKLB7vZsp+IpuWnEzoXZFx0xiaUVJlZqQlNyttiN33q4vjEoEljfhuphfIwMTCL5vxBwxoTWBwiASYqanpLGcWEYRtlN6sbJ6Ag9L8TO1UOd1EzwlV0+jc0pfsrpdYxI1SFeaTeRfGBsnP11lDTued1TVOmwykXPUMPb+llb8SEsie8WyHz70Tp/P5hQzQ4U13MTXiSyvijXo1+N3u0PZ0RJuLwBy7bZK8xnWjY3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/26 10:46, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>

I'm missing description and motivation here.

This is only about shrinking huge pages that span end of shmem files.

Is this really a problem? And if so, why?

-- 
Cheers,

David

