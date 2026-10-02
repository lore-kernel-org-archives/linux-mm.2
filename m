Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92BC8CA5FE5
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 21:12:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07E916B0088; Fri,  2 Oct 2026 17:12:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02F666B008A; Fri,  2 Oct 2026 17:12:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87046B008C; Fri,  2 Oct 2026 17:12:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C60376B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 17:12:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69C4BA0851
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:12:27 +0000 (UTC)
X-FDA: 85278934734.21.A769460
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9C020A0006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:12:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SiGtHpkH;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790975545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KfOsj4PG9vn7kCp0tnEzIbTFJwFY5C5SxFBi3uA9k6M=;
	b=CWs5md6nnx9epUvYEkcXH2eW3AYW76YlIGdVIdNZgfrZYmNqja4FzDDeIbsmZHkZtXJFSF
	v/vXOOO7pp3I8eXxJZTMCiOSpUwo1pkabsLFa38QjVc9B3k2zODRKon26QsgXv2oY+lT5a
	ja8/qraRY01V2BlnluLahu4IKWhm+gI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790975545;
	b=IeAT3iA6AXFIe3OJFolqPcpsTdlqS2HSPeCpHML8LqJTKF0ftQYkIPRuJVJWGmJLMhWjui
	qS21Xeoluv9Ebf6M7b6M2uxxbha4zenb8mQq5INEyN8qW7fAi8dTIqTIF72888s1oU5IwL
	vDP/77YyKXA3WfbZI9RPbQb9lH5T13s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SiGtHpkH;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01B9240664;
	Fri,  2 Oct 2026 21:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE2D1F000FF;
	Fri,  2 Oct 2026 21:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790975543;
	bh=KfOsj4PG9vn7kCp0tnEzIbTFJwFY5C5SxFBi3uA9k6M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=SiGtHpkH+22ld52BOAx4ticTi7fKCwsjNbskfeIqfkGPOqjZy1shyKWKd2PEMJkaI
	 ds6Cuu7bkYzhKxC97BFKp+ufrESAyd8aoU+b6DGkt0/zRLVjOZ7y+2Cnj1WOjOLJY0
	 1m/N2Z3e5tTKDk0Ag4jtpUQxp0/0r0hZ7k7gB4+M=
Date: Fri, 2 Oct 2026 14:12:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dima Koziuk <dmytrokoziuk68@gmail.com>
Cc: glider@google.com, elver@google.com, dvyukov@google.com,
 urezki@gmail.com, kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm: kmsan: fix iounmap metadata teardown
Message-Id: <20261002141223.1ab39d5cd2d65b02dce8ab85@linux-foundation.org>
In-Reply-To: <20261002200508.546-1-dmytrokoziuk68@gmail.com>
References: <20261002200508.546-1-dmytrokoziuk68@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9C020A0006
X-Stat-Signature: uba9puq316ymsqqipagdse3tpsdeoyu6
X-Rspam-User: 
X-HE-Tag: 1790975545-41244
X-HE-Meta: U2FsdGVkX183RxHMcnQrKodBzi71MtoqZzx9492MBFWjjlzk5BTvPyYeb2M4Ennt5d5A0n6r+kTXiv2Ru6emIsUuz61B+L2MptElFS5TV/ARRHVcmDo+sC/im6Z2Qu+pShM1cmfbrtnSHOVlQp7Tu/xg3ZqC68n9njOUJ3gBNtuWdbb2Ktwm16qUc5nthJEhwzkQlV5bR6m568J6LWBsyxK5Dv+QWmVyda5yxmeq2e9FQepEqSmiLTBKgA5AZTmLS5/pqbvWe8K6f8UOodq4etppo2Wo6VBgtAyfWqaneyMrn7aznBqL2VJCPOTEIB+51ecpmkVjUlO5mtS7bhOXi5lGPoULDhegMQcXhHYNIwMn3S5PT5g6kDGf+DcKjn43GmaivGqP2CTTRdV3Ueifi7yl6kto4Y/NES8Xxg6xl6x4+Zn5HC1tqe0d+07M92+TGOAD+KpR4XuLzr4XlH3ShSjhl4wcItmPWyGaSXlUAUop7nr1V5frkLBNa28SSR3rBbzhfeINxpvtGc1KiX4m+3LMcVGKSa9Me5rin5n4QoDssTf+w+reNbHjQscYTxFNWnGtfjrCDX67tIiEhQePYu2LtXFbl4di/5YrqqTyemiqQzKXm/YdyYomzzqmPa/CPfN+m82cHUceKuNRmXvsG66GGu5lNXpYLjxYRkrGrMfGOqCgaNiDpENfcSZ8Db57hRVInjbJ4BvWE3g5H/BPoyq7A3FeSph9y19UaIwQsPxyPu+KgbB/FY7Wg4/4gT2u563t0Ig3JiFCM5N1+dFQ3fZ+ff8r8YTd5ZtzoN7nebbo8tJPzYw0FhxVx6PYiLvkQxAT6RlXpFJKGyWpsO9eO2dYnd+kjg8e41cEJsCIEYx+g4sDdsXHE+nvbNHs7eoTXX53dfvwgJtz/NYlL4G1LUIruE0O84GwZsg+Q35x5HNhcUxzKm1PyKIOJJLhPhZYIXKMqZWNGMunlU95AGj
 qyLJasH7
 p5AF6Z+axs8dP2DCtA8lfqP+9LVIVmHdMxTLhf5pzkoixENr9CpNGADF2E1rZSz7UuAopLjn886V7YDE4YAs007CBbeYz3ClNoOeOnoc0eyOWudW//xvckpkAOX9IS6+ihMjjAKSddQiN753T69vJ8X+bl0aOaXkF+R/aBVZqBwm+22Mg5BuGHfthiRmtnQ4s4o9NY7Sb+XhfYTNwHQjlBFp4Up32jC+wF+I1VWlKHMrps6OMXrou51FuRLMPHBH1rkkBs/hps2hDrZYiEOSzpHCzug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  2 Oct 2026 23:05:07 +0300 Dima Koziuk <dmytrokoziuk68@gmail.com> wrote:

> kmsan_vmalloc_to_page_or_null() rejects addresses outside the regular
> vmalloc and module ranges, including the shadow and origin addresses
> passed by its callers. As a result, iounmap does not free the metadata
> backing pages. Also, the first iteration of the teardown loop
> unmaps the entire metadata range, preventing subsequent iterations from
> finding their pages even if the address lookup is fixed.
> 
> Factor the page-table walk out of vmalloc_to_page() into
> __vmalloc_to_page(), keeping the address check in the public wrapper.
> Use the unchecked helper in kmsan_vmalloc_to_page_or_null() and check
> for NULL before converting the returned page to a PFN. Mark
> __vmalloc_to_page() as __always_inline to avoid an additional function
> call in vmalloc_to_page().
> 
> Move metadata teardown into kmsan_iounmap_pages(). Free the backing
> blocks while their mappings are still available, then unmap each
> metadata range once and flush its TLB entries.

Thanks, I'll queue these for test and further review.

Could people please offer opinions on whether we should backport
one/both into -stable kernels?


