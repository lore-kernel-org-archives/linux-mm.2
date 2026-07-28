Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4C6BC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 16:48:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 699B06B008A; Tue, 28 Jul 2026 12:48:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64AFD6B008C; Tue, 28 Jul 2026 12:48:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 561206B0093; Tue, 28 Jul 2026 12:48:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 30BAB6B008A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:48:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B2E61120425
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:48:51 +0000 (UTC)
X-FDA: 85038769662.16.DAAFCBF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1A16480004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:48:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OU/w7xJd";
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785257330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pVL+sXQnyVqR4TfVrY7tpfQSsCbrXDrigHvOgIdAaTA=;
	b=Ocs7h1CwYH2hQjvzfjyZKu/ATAYTU3SqYXlrEqNDlYFr1v+WuNVG/mLmYsIeE5Bw0VM7NG
	TOItOfs9JjU+9d4sxnWQJpZVA7zhg6D49j1hBma/cm9hFKyeh8kZK7RuF/Wc2bcSxZBsFn
	VKQhHTrnixFC7yFwvX0HYl8resXxkLQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OU/w7xJd";
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785257330;
	b=kG8npi7Tla1N41QhPTJCeLoNRAGhZu3qqJjcE/0junl2ltH+pnRmqw9LaShFUkTFwGWPME
	+5kD0XQs/+Yh2pdx5FH3hhpXngcYdjkJ60AJizV2FpehhEYUinIo8kK5WbFtcRdf5ncT2C
	XnZpz9IZvTn0Uu/nqHJRXg7nw26nfwo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DBF99413BE;
	Tue, 28 Jul 2026 16:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC8B1F000E9;
	Tue, 28 Jul 2026 16:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785257328;
	bh=pVL+sXQnyVqR4TfVrY7tpfQSsCbrXDrigHvOgIdAaTA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=OU/w7xJdlxyJSNUc0FqMdjjkG+oNvQi42NfaA5le51Kuoey4LT3p9PflQzQwrXptd
	 oSOlQp2nlkSn9EKnVYCPs5HkKIbKvwaLAfDQUYg2bvSlfAzJEce67gOXjLGKH3zaVj
	 K/V2br3ZtCRI/N5UE6xkd1b1T303H492jrOJ8CW0z8Vio4AVtqp5KXC88ezubfO1hF
	 jEkAFCI2Ni6F5Ju/UbFYJCYsmOQrhE+Xh9eulgd+SwB45UDhbiQTQInFeG+jlOx7zC
	 ag23g8quAGKt3xHRse50kt74RjzTceTkfgvxGKJbL7oKG4bN8p9Srs+wZnCUZ/OLij
	 ffunIVRFbZY9Q==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v7 0/9] mm: optimize zone-device memmap initialization
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de, 
 balbirs@nvidia.com, bp@alien8.de, dave.hansen@linux.intel.com, 
 david@kernel.org, kees@kernel.org, mingo@redhat.com, rppt@kernel.org, 
 tglx@kernel.org, muchun.song@linux.dev, linux-arch@vger.kernel.org, 
 linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, x86@kernel.org
In-Reply-To: <20260720120259.1545-2-lizhe.67@bytedance.com>
References: <20260720120259.1545-1-lizhe.67@bytedance.com>
 <20260720120259.1545-2-lizhe.67@bytedance.com>
Date: Tue, 28 Jul 2026 19:48:40 +0300
Message-Id: <178525732062.1556190.314794914123127147.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Rspamd-Queue-Id: 1A16480004
X-Rspam-User: 
X-Stat-Signature: z668edb583abqwatcpt3h7ned3bz5jgo
X-Rspamd-Server: rspam04
X-HE-Tag: 1785257329-910925
X-HE-Meta: U2FsdGVkX18D+QNapGSqA2i/omx7YUQ01qGpqRKPj936v1M/gXGqhl9eI/f6YCikbnRYfWZUlrX0umSHDNzZvqrag/Bb3d3VbJkwheOvSLpONWpqv+WAJ1itdMvYuo5y6jrG8YrdeZifrnAXixRf0oFT1sbbTj3mLizLZpla2LpxB5lhfcKLTaQMjydzpHaegpkn8mBRIX6rfQd8hQqF6xpb7wQr0UF4gRmE/NuLm0kbTiTfRDCQdE+RyztoT3rSTOHVKhS2ovSJzU09NrXtJvec3KwcAT172NyHfq/KISoFqEiQZd/iACMwZW0spfK7YGOGccKoVti0iNF/Da9ZLu9RkKoi+xVUxbGTogyd80VGZ0/n99nsZf2tUbEQUpIr3TTDaPHgJJFX8vBD4yzrxxKFMUctWGpnJfXT0eMkSCEYW5jL2pe4r/QZ0/IeuzJlPLTWfe9JJaUjWTDUlC5P5cdb5/O5W+RfwW30PHsomUpK4FOCzt1+m5xsAUjtfY8N+gKLZT8lg4Xx0ikr0MSf3MVj1suRoMN6UN8E02p78wFPcbexT7DxP7+f1ZphepDFzEJa+wEmSJk1zmwoZ0dAusr0Tkrfz2eDICLW122hxoNKYnPQ/dFjDf2hzK9RIla4bgIVDXWv2g7l+KXF5pzCfe35eXXaBkZN4xMImkABbrU1AmKcHm2UyOivaTDxjVJR/mI/ZV1tGWQiE0EarS9Y0/R6ydXKyapK35Vmrbnyr7jQVYF5Ghzfq+Y1F0jO3Yt8FLcYdWxbN7QgmmQyYQw28yExoxhci77bYuJCtlr6qs01VyKtgHoffjfqdtzHR8mL41R/XyjgIYxzQtzfMjAhtD08v6cJJqVHlDmHPg2Ps69UtkwY1zZEqLLLSTPJHs+ATjiCGlU6SrGzjGC27tgjGxE/y4EbU96v2nwKU8EXdRdG4XAc9o6IwDU5VhzE5+l8qbQx4UD7K/iRWcLSivC
 Zvt18cFG
 c5tKYioXIP8+ou/yGaL+IsAnLv+zp51/xCIsT54dAVKKma2g9ZcdbnL/+fDNjRXVES+d4B6I3r9+pWpdRQBJ6WYTU6LtpDlNT9d8WBinmR+z6N4ZNm+6rQuelanHhNHNbrgb2xUzKB26aXH4n9yWg2vZZVFXu4PKxU+mYC5riS3esZMl49nm6NVfX/YQUCq81lKxjxrFVloI0OmM5UVf4gviXGKQp+T7CyNqU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> The numbers below measure the time spent in memmap_init_zone_device()
> during driver bind/rebind. They are not measurements of the full
> nd_pmem or dax_pmem bind/rebind operation.
> 
> Tested in a VM with a 100 GB fsdax namespace device configured with
> map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
> server.

Since the first pathes touch the generic part of the memory map
initialization, it would be nice to make sure they don't regress other
architectures.

-- 
Sincerely yours,
Mike.


