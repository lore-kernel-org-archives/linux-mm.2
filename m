Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9776D609DE
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 20:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D7366B0088; Tue, 16 Dec 2025 15:24:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AE876B0089; Tue, 16 Dec 2025 15:24:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D8376B008A; Tue, 16 Dec 2025 15:24:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C44D6B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:24:46 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC165140823
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 20:24:45 +0000 (UTC)
X-FDA: 84226462530.25.886EF55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0DA4E20014
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 20:24:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rzS9hdJi;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765916684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/shiGYBgB5wRrJtDGis1q2AmUxAWl5pP/VmlEkvp8w=;
	b=OZ/M3q38/ynR3NuX5AjSLm/23QvXc4ET1x4sLcFIukg7C2U8E476jEOAnOA1HixqovBP3r
	7QRnx2tYXB9V2ifR4rp2rmGzjiHOokN6mI/krrRck0j2atoMo3oOnA7FCvqEJSWZO/BdGL
	SuDS6hSVtz9JWqCeEoZ8RspIWdaNwqU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rzS9hdJi;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765916684; a=rsa-sha256;
	cv=none;
	b=BUKRz7mQS+S7lLTbSuN5WUPK97qcaLRBrZHjJN8Spu19LcP/zLpyIpeKVaMD7ZdPSHIqWS
	KFrmYHakMlA8gYR8jHzMcMmgYgB1L9JjWyYw/qV2WrLKhMteOkv8c0XSotGgPBy6O1qdgn
	RPvBg2BXpzQYiYEpEL8hTe4UygiPbOs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DE89C41A22;
	Tue, 16 Dec 2025 20:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DEEC4CEF1;
	Tue, 16 Dec 2025 20:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765916682;
	bh=ycv7no2r0HogxUiULI/OFg8qd8I2bXxi6V1PqZaAaKk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rzS9hdJiYKkF5jy6MSgIR8HlM3FIDA5F6SVzhIqgOpqDJ6MZkA57rhcPmGQxPC08Z
	 wmS5ly+0puFtohUYi0O+DrA6bWEPmE9JRp+lkOig5st+Xb6XFSDkLn2DD4Lmzv+DMR
	 9zvxeeh2FL+1w1BiI/eD9LhObmcLQgRqTga0xW7U=
Date: Tue, 16 Dec 2025 12:24:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, david@kernel.org,
 mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com
Subject: Re: [PATCH 1/2] mm: memory-tiers, numa_emu: enable to create memory
 tiers using fake numa nodes
Message-Id: <20251216122441.2810043bbc51621315e3862c@linux-foundation.org>
In-Reply-To: <20251208094028.214949-2-akinobu.mita@gmail.com>
References: <20251208094028.214949-1-akinobu.mita@gmail.com>
	<20251208094028.214949-2-akinobu.mita@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0DA4E20014
X-Stat-Signature: zff9b37ef1rwoto4xx61s4fbmu9rh6s8
X-Rspam-User: 
X-HE-Tag: 1765916683-531765
X-HE-Meta: U2FsdGVkX19SdIsS2kuP1IhWFf79pF39VnjjwpK41l70rTaecy6tH5N5KlGHvLJgWsC6NRTj0AtmUzO9K2H/1po+fO7BhvRCrZs4Yp2UMqkuicURY6s7gn8KvE/xaTnVQu2KKW/IaJ1zL+b5RkVtHu/RfZ6hGOq9OQXBitt/2hLFH/7p2SsuyNO/ohYd5dKw25O5gMdzn8HHk4A7f1XYBxcgMJdNgFgZuyAmjUrPdbLAgSEDDZ7QvteTu65H8tUK8XHbmqYLgd9vjCNtGcTfBiBtm263+0UcytbzPMISHZukrGJ8FQHfMqdeXOIdtTi+daIAzX0rlM+k34LRDzpQCCD2qhvQrv3OgliiiUj4qmogTplhB+xGVjYD2NlPXMSHphW8NCgaGulK/0rqVx89QW3v4RGou0gdgIpQSv/DJTfPAwEfgMOoORAHoJ5cpGdVDkecKZWn7W13Jsz2WNbxFIsU6deTsioEV7bvniUfnJhomwJcrH/QJRscPSQjSdHhgcHOpmyeKZIex7Vh1ySooUdbi15U83m6pEQjV4X3kEBRqgmBR36GCi/EXjmLCGYrAf34LrK3nvDdXxzbKzAwh0BOtzMo6/3/8kyoREuCOvzpcWZDHsHIKcdXB2cSztO3MP+iAbgZP5N+XpCdh6q7mYIj/i5w4R0Fw9gJXtAU6QgrHN6xgCLQ5TIvX3EtN2IiSsOd9xYO86ArHdBGuobo7sCWnQ4Z+cUMdKzPPwKEnqu9rIFmCbYcfh5JTRRp72Vkd+7kP//v3cFGs2etNy9lN7ci4kGTDm/1ISvK7KPfJoLBgKB2r5f4M5z/U3CL8b9Mejpy8LoljpZug1SU6g0sSva+uxXFlCA3sRybASwoAtVQtfk98qKt9hzoZWgTkirfO+sdo5RYmC6r6aoEYC1gd5PXD5Hk+gGcwx5UL1tlfVpxz62OHu+C2lqlodphSr+Ndip60XwfHicItKQbkDT
 aR2xTyxr
 Q++z7isPNRiuZczihLRzoZ9BpC9+L+EdqTlMu/JO8sNjHYBLu+9iij74397CRsAV3QAYNi7DxLWPEZO8tQaJRHOUBU6rLUfrO8ASGQQ9Arvj0QKATYYVAhY7JhVNmtCpBYnwz9YzBnnu04HFHWa5U9mjnkbLzXpz/NiEYZmQtRgOD58bnnGO7JYDNaIp2+h9WGtODqK7MX34QnNLU1gfuC8h2N3yTDMeCcVv0I0Nvtr2/g438g/SwDfkUY+n7J/c7h4SnUyQmgf76wsypu5JGZIQEjhdDXmYzAIC7JDO4K0YxkW3HwUbzD/Ah8pdBNxoqUDxfdHf21tWMWhp353/xVyxwf8JvQ0vq/8DVsxvrrJR27p4tMG1BV5ZC6P/+3Sy1X0A+tnxVtDRlJ2M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  8 Dec 2025 18:40:27 +0900 Akinobu Mita <akinobu.mita@gmail.com> wrote:

> This makes it possible to create memory tiers using fake numa nodes
> generated by numa emulation.
> 
> The new "numa_emulation.adistance" kernel parameter allows you to set the
> abstract distance for each NUMA node.
> 
> For example, if the system is booted with the parameters
> "numa=fake=2 numa_emulation.adistance=576,704", it will configure memory
> tiers with node0 having the default DRAM adistance value and node1 having
> a lower adistance value.

Confusing.  I'd have thought that this commandline would gave node0 a
distance of 576 and node1 a distance of 704?  But the text talks about
some third "default" distance, of unknown value.

Can we please clear all this up?

Also, we have little documentation for this stuff. 
fake-numa-for-cpusets.rst and kernel-parameters.txt.  Can you please
find somewhere appropriate to document this new user-facing feature? 
Maybe a new Documentation file?


