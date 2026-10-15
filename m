Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25B33CC6B3A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 16:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BCC16B008A; Thu, 15 Oct 2026 12:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36D236B008C; Thu, 15 Oct 2026 12:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 283BC6B0095; Thu, 15 Oct 2026 12:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05E896B008A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:31:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E71EA5CAC
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:31:15 +0000 (UTC)
X-FDA: 85325400510.27.F75471F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id C27024000F
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:31:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZFPC/KMz";
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792081873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U2FTBC55kHlfmFsiLIJXZR0ZuKP9p6FEbsh8MFHa/Xw=;
	b=usBhW1idJ8Fdh/XUj+DPJluUogxrire4Y1wMGdM0sHl5ndyXtqwHopxKD4THQLG93QbIKS
	V+brITkqSFaaSIq5WUjYSDjx4NBWKEJGjZrAtXWkK+Llt/tgHib7Wwb2XUAw/nrpl8te5U
	jbm/fw3eluxZJ3mP9rPdnrdHwHYusdY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZFPC/KMz";
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792081873;
	b=UV3JX/yxuk5b9yyDma+3ftWOL03Jo9t2luT3h96QKkABhPPTwVApz+D5dLooJ6wszgX+0G
	lLReNtskP1ZmqH3iIQA5u6Dckx6J7dhlW6xftSO5vjqAAXzwlMnRwwYW9kYyvTE/x+MaE8
	ueFGwvvNU6K6HL8VzEdhX6172bErTN8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4DCB6601EF;
	Thu, 15 Oct 2026 16:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047B21F000C4;
	Thu, 15 Oct 2026 16:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792081873;
	bh=U2FTBC55kHlfmFsiLIJXZR0ZuKP9p6FEbsh8MFHa/Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZFPC/KMzqnFDT+QKGQ+FgK9734+xFyYL0ffRIrpYpj6dTn6pK0dYlgTzh+mtRfZJk
	 8QiotR2D5nfLbgGkEMe2luxsjzEvPXzG57QErp2r04JhlGxF3Xf55WYVbqCI0J6wb2
	 fU44SFZykcwhi9tTyJ2BjtHYRt5qdtQJvlwlk4604zQHkaFVr3jrbKA5/K0LADHL7S
	 xYzKZaKYC5aN+q+Yj3UxpsD+Z4vZjjgC6RGrq72kVogO6TBnA8L9ESOy8YDtL4lEFZ
	 MM9ppYBIhuOhtLH0qRCu4SRpV8L042BU3XGyvJqusOE5jAqnRh5IbD34ly6dYrIuIE
	 Vht0gLJm4G85Q==
From: "Harry Yoo (Meta)" <harry@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Karl Mehltretter <kmehltretter@gmail.com>
Cc: kernel-team@meta.com,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shengming Hu <hu.shengming@zte.com.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: initialize the free pointer of the bootstrap kmem_cache_node
Date: Thu, 15 Oct 2026 17:31:08 +0100
Message-ID: <179208176814.13496.3999707949555956880.b4-ty@b4>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261010203906.93156-1-kmehltretter@gmail.com>
References: <20261010203906.93156-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C27024000F
X-Rspam-User: 
X-Stat-Signature: jr8n31tadz5be9wzcxa3e9k6swjy4efo
X-HE-Tag: 1792081873-547361
X-HE-Meta: U2FsdGVkX18Rq8QykxzoC8xssLmW5+WQE8ecbSnRNSt1rWtu8kST1Qr5QW7tANoQUSOcewbhnROwnOX1h3XdH0i7C3Fozc9d1syITZfLlnY2XPIXNNUrAU9XHUMxtRqsUkUIAFMWOvIsG6HjJd5g19f7wYGvX4LKgfxYmYpO5uw/63YIgv7ftQIVKV+vbDljis7qs+Wm0x7MDs4VRy0pIwI0b198r/FTZ8UGUz+YrYXV22KkBJgOpEd1H1Tz43kHkBiaVR6MqFTW3jlyr18MNp3seFaxFCIUhNxIxItlQzeFFlJvIepbd9F/U+v9xnxbX2SH0evFoUIrNiwlDAKNtRNOv6KHkMAcWWi4AJF95Fc+63sn4/7spT8GSc5SxaRV9jPKgEzFVcWNF5CAUXRQ0b6Zv3u9wzVnUDoobeqhOYupZZXQbWtfuuyC9185fdVghgCG0O5JmQKpcA9udhYPzdKw9l5mHOvDfIzBsMhTQNFGwWTa16snZ+PLHIM9jLyIjwGu0/MGW+D16eUUyA5OAOVO6N9L6YPXHT0/4ruIa4fpBcuqCX75qMss2FMdf2cGzfj4Z5v6bU8rRiVbfRjHuo/QAzxhZm/99zRdnDXc2xyyK6j4rW4/o6bMX7Wp7kLmGvcFGnHKt+NL3Pv3dHdb85z4J404VxfO6f7S1yWHstwUSFigQr1iwpsDsNv/iajtseM6XkFZuj5m86BKczciBXQEUOZ5MtqAxkM/bowp5lEIScv+YxbnkxU+0puUZXH2HGffHA+QZ8lSUftabmNAgJFEymFVhMkWp15xn6Id+A/J61+dh1TzVJMNuEOyIut6M1QXUiu+GfINClo5ldW/8nHJIUbMw5q1VSYYMEwWAWjLUs29FDByDgN3pXnhzLCRpS+XbsewoAd1jCVPg7674zEzYm4rcndfHvfc0PDPcuGHHhkJBlNdY89zFxtSBWDwoK5EMMyLxNwWaxUtnBy
 ofPvRJj4
 n4L0j2bpjG3XtcpjJJE1nrmGLI5UTQO4R4OzWkI9BAtEuTLXj++nb2ightCtMOsIbHZLgLwZ4AtCxibrq1VAsECq0KLTtjzsTmjFI6EFpDa7ZvRbPmxmsUruUDG0wmyOiNLR1Ql3N7Y206RB3Tk66OSuZB7AwRkMPXUqfob2tDmCLQj+BhuuALFFtnu+Zi8wY4PuCwRGJ6tC/rT+Mtl329WlIUVY9M6VXqK33CRdJkLhYaUNGrDyv+M6RE9pleLPBHPEflECtHcSLICE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 10 Oct 2026 22:39:06 +0200, Karl Mehltretter wrote:
> With slub_debug=FZPU, validating kmem_cache_node reports
> 
>   BUG kmem_cache_node (Not tainted): Freepointer corrupt
>   Object 0xffff888000140040 @offset=64 fp=0x5a5a5a5a5a5a5a5a
> 
> and taints the kernel. Poisoning places the bootstrap object's free
> pointer outside the object, where check_object() checks it even while
> allocated.
> 
> [...]

Applied to mm/slab.git slab/for-next, thanks!

[1/1] mm/slub: initialize the free pointer of the bootstrap kmem_cache_node
      commit: 10a5ff7555ae3042393d8a662a25dca9b38ea415

Note: I did not add Cc: stable because it only affects slab_debug users
and requires writing to 'validate' field, which requires the root.

-- 
Cheers,
Harry / Hyeonggon


