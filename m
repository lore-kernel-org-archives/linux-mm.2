Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DFD5109316E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 02:42:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1102E6B0142; Thu, 19 Mar 2026 22:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E7FA6B0425; Thu, 19 Mar 2026 22:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 024D16B0429; Thu, 19 Mar 2026 22:42:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD4286B0142
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:42:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 85D79160833
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:42:34 +0000 (UTC)
X-FDA: 84564893028.27.D24B571
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id EDD6640007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:42:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gq9Vbett;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773974553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=at9OUDG6usi7k8dyPDbFKJBZ58cH6EHF1grDKA84zXU=;
	b=uj/jLYMe1rIj2BoYUKUi+1/7ZaZbRUVComTPFIEtRpS1iuawmzkAWNib6c4t0YTs/vNgWi
	4IdIe/O0/Pgk0dXWfXdhHrRN2Omfv/nw9Idd3w3gIQt+LShqY0QXkKU1qWcFOUxChKbFLc
	uIzKhQhOUGpqEkAZwv2uTkC9CyF26vg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773974553; a=rsa-sha256;
	cv=none;
	b=M/TzSFCN8r1Xu+7jVajSn9CVGQayLVTISHzOEADU6Uh2K/WxMd14me4IIBVDz2etAvNE2w
	qNGfcxVNQ8u/tqCMonmx9qcqt1xo9cc0FWbfyGDd/bmqjONAKPty3IKd+JYgwWJENzmV+a
	mgPVC5d+KUkhWEErFFl1oO/rpXyHpuk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gq9Vbett;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1407140272;
	Fri, 20 Mar 2026 02:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7E9C19424;
	Fri, 20 Mar 2026 02:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773974551;
	bh=TPIt0aBis5cE3gzpZl873T22Zi6MPYtEfWcqQG62h/Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gq9VbettmW669rLbKhI6xVzxAXrqyhqG8+pPvC3SVi6fErJoOx4XECHd/ombAZSf+
	 w38Tm7avGJ7B+waRV1PB/tmEn07Imr9l1cZ1WNg82515XZYnon8tMUi2/X4F3oLI2f
	 I6xlfrCF76XfagoIaNAyKBKJSuhCqJeQOppP58SQ=
Date: Thu, 19 Mar 2026 19:42:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
 <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>, David Hildenbrand <david@kernel.org>, Dev Jain
 <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>, jhladky@redhat.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] mm/mprotect: micro-optimization work
Message-Id: <20260319194230.bc660ec7c99b5d0e9ac9e902@linux-foundation.org>
In-Reply-To: <20260319183108.1105090-1-pfalcato@suse.de>
References: <20260319183108.1105090-1-pfalcato@suse.de>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9rpt8bta14qewro4sbp4imifgjxgtbiz
X-Rspam-User: 
X-Rspamd-Queue-Id: EDD6640007
X-Rspamd-Server: rspam12
X-HE-Tag: 1773974552-843997
X-HE-Meta: U2FsdGVkX1/CAfckR/pkv0t7U7CIiXWC4j2Bv35fW9w1iQK2XXOvRst4J+51zD6S/cVvk0aOgEKQ0JHRerxgqO21QlO3zKMgkXB0z0JdUXUCV5XcW6eO1gM/Yomlqd9HhxUURtMO4GKkavyFNbz+ZFyPUkGQdUKGAA0G5zv8OkkBhvHCMlRgIGx7vEFfpApX9pL/C9qSk/7KqAeatW/EOvCt8NBGfEy/5x+eLVSDXeWSdps9BVF7iiORbS0NN2o431dEO+tiLnpvs3TdNrV+48acLtpdFbAG32tjrOvJ25scpG5FmbbiLNQJry33+M3MPl/AETrGIyWym70Z8UPogUZGepKVKMZ7XD8K7SNRlmBvgKhSWB/9ed8v5WB2W4rdGoRXkIm8LZ2JyF/pob4ZyQ36FOqcAFwwJXqyDCCoo47u9i9VguLlYyN1BJeFgo0uNc/Mln0tsmNpS7+hgRGVVTPBbAKX70LXTF3miSny85g/98MUUyqjAhI16dqglfUr8PTMrKpKxXDABPpGpDLd1nmRPjk3WPyCQPOWvLJ+vp52ocmwFLrknkcMFTtxKUC3crl+1nc8lKJFPFkwvKp3fjVkH6xoEAmb8/ZmdWHjodDPd0hOTMFBs2xM4gaBNG5FqlWUuLaA3cgIrvsEnH+byO8VzMSQ/5UGPPGWha51NUNzuH/8uewdyV6zO8iIU9zZAuaPsnrdTFteB1QTClYzUpAYzGA87QeIEFuWXTL1X8ZG3R+J5vbJeacYA5+GIwqJyvUqcaPghhT7v932EbLjxJLovhFpOfnQYCIXCo1e4fSS2XS16R9H/gcgo4KqArGW1NHyZjZd4hNMn/rWGwXjW1s5HlE/pbLwQqqI7DVCN1cUJ03Z46WQsgqo+gWFtdG8BacGJE/DFcw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 18:31:04 +0000 Pedro Falcato <pfalcato@suse.de> wrote:

> After a long session of performance-cat herding, here's the first version
> I am relatively ok with.
> 
> Micro-optimize the change_protection functionality and the
> change_pte_range() routine. This set of functions works in an incredibly
> tight loop, and even small inefficiencies are incredibly evident when spun
> hundreds, thousands or hundreds of thousands of times.

AI review has questions:
	https://sashiko.dev/#/patchset/20260319183108.1105090-1-pfalcato%40suse.de

