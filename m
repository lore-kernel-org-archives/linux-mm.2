Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B8E010854B4
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 00:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7EB16B0088; Sat, 14 Mar 2026 20:23:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D29176B0089; Sat, 14 Mar 2026 20:23:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0E526B008A; Sat, 14 Mar 2026 20:23:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF0F86B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 20:23:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B94B413BE92
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 00:23:26 +0000 (UTC)
X-FDA: 84546398412.24.DEB8ABF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 161D740006
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 00:23:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=00G8LLBD;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773534205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m3kGGDEemPf3ibI8uDEh5/pf5xHIr29JIT9TVSlyHaw=;
	b=4BzSRU7yLQkoOIzUbpV/ABmbfX4cnh6n105rgUIfUd0HMwPExJ8aPwqxqmkzYF4GQrSW/8
	1vJw4u4/tBOFWj2q8XgE3SHU9QekvJyDNf2wZ+a+f+pzInoQ4sJaLThXbOpBKa6GLphkw1
	Q39PIT1resunJzAd+dkub3YnzuHN2Uk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773534205; a=rsa-sha256;
	cv=none;
	b=vXj9I7+mYfnVDGVQNeP3kz7NdLUnLiMSrIbxYL0rtAGCq6MIVu/cYT7xrwGT7vQBMbsdQP
	HTbotePT859Zwyf0bIQA9MmNZTAi7cRKTSCH9AerduigMePgEgJWPCedkqq36F6slpQLo7
	+C6Xc6SsoNY+KLja3TXrEGzPcaFd8Hg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=00G8LLBD;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E654417B0;
	Sun, 15 Mar 2026 00:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993F8C116C6;
	Sun, 15 Mar 2026 00:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773534203;
	bh=h0sAMG+StH3IKnGuGSyIhM12sVYTUh2nJijKIIgMlDw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=00G8LLBDByge+9fnmNBx+Qqz6ilOPRNsD2R1H2Nw2RoFQrUsPLn/raG2j+v1saPrT
	 XlcZyHn2PRx8OM/hmJUQQc6nw+jeIbvu2OLyzWB+aOI7ZSiQxCLllQNg1+sXVUECmB
	 bVlgkTdjvyDwBp4xaD58YxCUQK2AnPopZhINDpDw=
Date: Sat, 14 Mar 2026 17:23:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, npache@redhat.com, david@kernel.org,
 ziy@nvidia.com, willy@infradead.org, linux-mm@kvack.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, hannes@cmpxchg.org,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 richard.weiyang@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm: migrate: requeue destination folio on deferred
 split queue
Message-Id: <20260314172321.3ca062bb70e51fefa633a6fe@linux-foundation.org>
In-Reply-To: <20260315000555.76876-1-sj@kernel.org>
References: <20260314154042.327ba957b1a8c10f64ae0169@linux-foundation.org>
	<20260315000555.76876-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 161D740006
X-Stat-Signature: 5ia8tu5nsyrrhwrjwsjhxqgsc3dfpi9t
X-Rspam-User: 
X-HE-Tag: 1773534204-891508
X-HE-Meta: U2FsdGVkX1/KH7WzNXxpNHkQXJGz6Qcgaaafj/37pulaz/4rSDdAdlBAyyshLtDiwC2icI95guTs/hJWFB6BIYHtUoK2YSH4lGNd15aqQncn8KdDU5T0wBat6nw/mQw8PImOPosou5ALDNNsYY75n53kBQY8le93b+dDXoKTsGOcRIx39MJ7amiOvIoOj0RkdRBgVfw3Eikg/gopR4vKvk8YUY0RLJe389s/p3DDbUJLNLwDL07OpoYLvqwO7vNpACwDPfNAJHVi5Ce3nqG+LxOqlNUewEWft2+y3Cj1N/EKSMnH76W9aPw9rLKsi5S6M4XgYIDKY0KGVASLXdh+/MpYfRsqv5XhPQ+yrGEe/r8gwICJWE9/dE7jU8HTaLj+Ysn0RKzN4S563zYinTZmBW3MIqZlYGOBE1IF7gjSGnvNWgDAxVohivmLmRHdLA3tYeD/7wsCYcLGhXMJS58SRuC6Ok+FfMH8AdP45oLI2rSwKy3RvXd3qZpNyq2N7UZxEbQcWXxM8T1DVVJgbrQH0E9lBCSSuAKcfa08sJMKikE9jCQ/X8fgo50sOue/nBD59J88P8GulLE/MLizvxi5t68kvLZ/XTMVov74pEmPxXF5mS3zNX7Gpl1w572CcDqxTX6aV0H/DOUKTHA8w1BegHuypjahKAwDmqghWW+Fv+hBKQ342ugH+8HcbCpgZRpuzP4Zgu1J+TdZgUK/YeJQwHGIGWxmGfQ8YFrogN4QJRuJ2J/zV1IJdGcyN9H6Dj+wVZx+DzaL3djMQpSHjMh4svN+Lzi7TMBQsuDMuKafmtrkaZLrGiUc5myV65YiMmK04xtXxnzKdDSw6l4N6IulEKWP0/8yvnUrdxnwolBW+Kuwy2glL4Ksqa5almhD2m8tUjyEVToqIS9RcNrNGoYsUSZ4wG+jCGrOrJ7pdYrRFnmWAOQoGjEWqluLJ9EkKAVQtXvPO8J0YsIH1+AT2zC
 eVQeUKpP
 AUNm8L3IkXTuQJd82ZTZjan72E7CVWTGARESi2gyumkiJVGphQhE7RbYx/w/9aRN3ZSdZN3cAaPOx0yRn0kky6pRLdAtYSdR8VbsBcC1sZErbH3iSDoCr92+MiyT/xJWnwwm97bOKMD9Cw7PPLMIUr6tgYukbHfMQEWZwwtLtV6I6dviIwS8ztsJ/f1cRKdlwT2+/2hfwNC/uW9Abrkzyt92RoKBEGcWJaJ8ctIO+qFqRjt3zNe3CFdPrnrVkTgis0f2awDnlfohXktXMc2JrYw1LZIn5Iz8nL9Q374zavsLl7HKDeR/r9/n4hiAYUFjLl3WccZKJycM3ho7F3H26pwaWvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 14 Mar 2026 17:05:54 -0700 SeongJae Park <sj@kernel.org> wrote:

>  Because THPs are
> removed from the deferred_list, THP shinker cannot split the underutilized THPs
> in time.  As a result, users will show less free memory than before.

That'll do, thanks ;)

Pasted, added cc:stable.  It's been there since 6.12 so I don't see a
need to rush this in, so I won't move this into mm-hotfixes - it'll go
into mainline for 7.1-rc1 after which -stable should pick it up.


