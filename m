Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D4C9C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71C816B009F; Tue, 11 Aug 2026 12:20:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F3E16B00A0; Tue, 11 Aug 2026 12:20:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 609416B00A1; Tue, 11 Aug 2026 12:20:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A38F6B009F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:20:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A1816C04CF
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:20:35 +0000 (UTC)
X-FDA: 85089501630.06.A914344
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id CC4F820013
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:20:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=acTIzyrQ;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786465234;
	b=Fxodfo34JH3L4TbvhGdG3nC5o7lg8DiPlPIh93x1cwajSTywoycW8hs6vnppK/KiqnTwtx
	v6TYL1YIeGXez9BptS5lgEUY+DDLyRqPH/4HA07e4PeGsQWzy9VxZmbibuHf80+5cRAZny
	0FDyM38YQ9LTBNJuLQPBvfgH4iVAo1M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=acTIzyrQ;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786465234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rABLzlg0u43+P339RMNGZnI+bssjGoZAX7d22G0Ys3U=;
	b=WtZpeeKY/ACLhXp2oktt31IGx8xebBsSfrd3ptCw/8ukvrF+KddwETFFkg69e0JD2KUtqq
	Ptu/QJzmZANf9vxXGjHfG2sMtoDSwffDl6C3kqw2rHW2cCdT+sCspLvfazGJIF0eZEDzHz
	KexwomgG8cCUGTohipPSAgbeTUEpgGs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EA3874332E;
	Tue, 11 Aug 2026 16:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0581F000E9;
	Tue, 11 Aug 2026 16:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786465232;
	bh=rABLzlg0u43+P339RMNGZnI+bssjGoZAX7d22G0Ys3U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=acTIzyrQRgh1FIirEmgF/tH7NRIIlVSax39cdCWA7OWihUsPz3hnQWANNtJJr0ViB
	 p/pplBIzwCxHcSImUCPEffJVZXYhcFHJgmXdvRqzLHFEWm+Y1NPc7dm352kpJMwVSX
	 apLW+KJT15K+EgM+v3CsoZBxt1YFrEWdbnr3eAMk=
Date: Tue, 11 Aug 2026 09:20:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko
 <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH] selftests/mm: thuge-gen: fix test_shmget() for
 PAGE_SIZE check
Message-Id: <20260811092031.8e6eadf43c3df4c1c6005ec0@linux-foundation.org>
In-Reply-To: <20260809-selftests-thuge-gen-fix-v1-1-1919f4b3d12f@kernel.org>
References: <20260809-selftests-thuge-gen-fix-v1-1-1919f4b3d12f@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CC4F820013
X-Rspam-User: 
X-Stat-Signature: iqoj337ea184hud7odywbdk399mbnuej
X-Rspamd-Server: rspam06
X-HE-Tag: 1786465233-307719
X-HE-Meta: U2FsdGVkX18eQybGbN1gwFdIE/4FZg7hLfgywASMg0bt7GsGc+iNSEiVsel9PiYklyDgIy6pW1EtfBIZpugphojg27OT9v9XK/dGSl7nSdxB0QlM2B9hfwMEmk8bPVpxSHrpezaMzMl1/EFQgfJfaBa6lhHqFWVKbD+j3N2CKCrj+54ElXMc85E3sFPkAk9o5ftRGO8hTzEN0Yyt5s3CkiAQe/5YHkpzULokx847pwelCV+4UWLj+SYbEz9hik7R/zW7Zpkh9Mrq/hoLlPK8iDH7zeDGamqHzRLX+gv+WGHttnQWVyQ28J3lWfqHdbl9NHWPLVIsp2cghfc6ezy7GwVqTX4HgcFk82GQJrbp9K8eHaKuk2T5/Mhpx8tChHrtQAXWG56KfHp4SCrRlGQOSb52MElLGsXL01QXB5Ctk+Q97XwJWDjgqM/Ea95mXCfz1PL8jNvXlxT81bhUJNyO/lJrwrz5oygE9oZGZHZzzOoIV5MbFiPRuQUZUllub0ytg8AO67EDMw3Q8Zok2W7MrcoGU18/jXOt1BcFkHja1r5QV26DSY5UeWGiTQxo6jkyIasfNQMfdbE3+S6L1NilrP//dnkiyeC5eOxDQwaSbjGl8kJagVWRtTdUgjOw5gssl6RcLL8tfnhXhjvkJiFZRpCFjUTjN+QqxjBGDGB8+wsm2Rj6pmYCOHDwCeGI+7uPRshJpiPCGe28f7DBQehuvAb/Hh1i2bBHYuOYcIQjVvNRcyk0hLd7z+iAt0PJxOci2sJ4yncI8w5U4huxXuLrHeIjeLznY6fZWNf3/Z+EMc/Oa4lPvoWHOqrGqxqKLhbxwQuUU4tynWK4D0uLDLG8k7QuMYJzYYZ43GTZP+fWgyBERG6yrV/854YkN8i7K1+Yl+Gwlmp+Id7lmmVEqPHvxa99Ix8yR6jHrdKCxhD6kK9DiATHQgsRj/WPFWsWNcQ0iyw0/c75sL70yq5w2ME
 BGHOgg6r
 FHxiGAeuHY7A2Gd/5wSfRFF2btSVK2tFAzdTeFdk06Yin9Q26uLXmxiUyv9equ9aiGvzuDGSIrg14xvjiZsI2BqE0CJ1iZ3vry3yhah09FIMqs7lsXyK1KaWpT0tf6rZfOshcMrzKys620HL59g9g3bapSZ+do2C6q9SVPWdEDXe0YayS5wYlJEhx+UEF8QxntlHyGSmf9PZfCsW0aEg7C+W/quQ1Ut9Z+sDPnyxe+fwxTMU8rnPxSZULEFLHgkvLfJOgwGl8o1zZ0kTPS/jgTipBJyYYeWr8278AONk9H5eI4gA9/RD9cue78bpX6JElz2qD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 09 Aug 2026 11:03:35 +0300 "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:

> Commit 49a4e7186b08 ("selftests/mm: thuge-gen: add setup of HugeTLB pages")
> changed thuge-gen test to use common functions for reading hugetlb
> attributes from sysfs, but it missed that the original read_free() function
> special cased PAGE_SIZE tests.
> 
> For PAGE_SIZE tests, failure to read sysfs was ignored and read_free()
> returned 0.
> 
> This allowed test_shmget() to essentially skip the check of how many huge
> pages was consumed when it ran with PAGE_SIZE.
> 
> Commit 3199b0c09efa ("selftests/mm: fix read_file() return value check")
> fixed the common read_file() to actually return error on failure and this
> exposed the issue in test_shmget() that checks the number of free hugetlb
> pages even for PAGE_SIZE test, tries to access
> 
> /sys/kernel/mm/hugepages/hugepages-<PAGE_SIZE>/free_hugepages
> 
> and obviously fails there.
> 
> Gate the checks for free huge pages on size != getpagesize() and initialize
> before and after variables to values matching PAGE_SIZE test.

Thanks.

> Fixes: 49a4e7186b08 ("selftests/mm: thuge-gen: add setup of HugeTLB pages")

Which is in mm-stable.  I'll plan to slip this fixup into mm-stable
later this week.


