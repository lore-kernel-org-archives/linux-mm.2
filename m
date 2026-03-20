Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEBA41093168
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 03:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 530DF6B041F; Thu, 19 Mar 2026 23:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E0B86B0421; Thu, 19 Mar 2026 23:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F6A16B0429; Thu, 19 Mar 2026 23:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 295196B041F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:09:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 637578C55A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:09:21 +0000 (UTC)
X-FDA: 84564960522.26.630E284
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8A0381C000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:09:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jsCZiUGQ;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773976159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wI2cRGuN/FzKezpYiBNayPTvxChM8S5YdzkvAb4Lzts=;
	b=CudXI71anqXhhDSgRZEgzRhLQxG1+i/cTqWjmesQeBZmd3px3sCVd1MfrtUbLg0oebYw9s
	+w5Hzemglhz8gOIQ2KOq4juAcNwMUI70kKAkZCQzqFSNup6wcTnZwfJz171Ba7ghAjCb9Z
	vH6YYg+HWM9Kgosar6vK5pcm0tReeWg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773976159; a=rsa-sha256;
	cv=none;
	b=xpor4WCFLDIsBCLEBuWeuRZXhs1A5+OKc/uEK0cemaSUK5KnGIgERJXt8rkUqu1UQE9G/Z
	sd2tRHLfibDezuX1m6qW/JRxg40nKPfoMzhk7/OUUq4ePjSIrBC3OBCHNo7hdAlQZnhILZ
	iNbS/cNWaJd3r0s3kuQLvE9Quvw67sQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jsCZiUGQ;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 537E143582;
	Fri, 20 Mar 2026 03:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCA4C19425;
	Fri, 20 Mar 2026 03:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773976158;
	bh=1nu7xvIa4iZYd5WAcCJ2dkMWrSUCOquDX2FpVhwFabo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jsCZiUGQbl3PXFkIm5aVjXOcmNQcEEgzZz0BLqsHZxnNno57YJfUMMb1KfA3Ry8i7
	 +J54G+06TkQ10EnqWPS4qgAPg84lFMGsCRxcsC/PmmV/M0xJz+6dByICVFF+2OtL+C
	 Y11BWcJZi7cvkdrALT4CDzVBtscsxVFiYBJB2D00=
Date: Thu, 19 Mar 2026 20:09:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH v2 0/9] mm/huge_memory: refactor zap_huge_pmd()
Message-Id: <20260319200917.ce345a369d035050b6329ac5@linux-foundation.org>
In-Reply-To: <cover.1773924928.git.ljs@kernel.org>
References: <cover.1773924928.git.ljs@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gdmwaazm9qudq8d9ffqg6csokxopntr9
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A0381C000E
X-Rspamd-Server: rspam12
X-HE-Tag: 1773976159-471754
X-HE-Meta: U2FsdGVkX18TGxd3QYh1jXMpCH+/X1PLN7s3yhhgJFqKy3cYUuZoF8n5E/QdfRRo9eFLU0wHPT9vHwGhnpgD4kFN5w5A32muifmVbTXWSKurCyxaatEoxtY2mS5Z50YRXW/k2qLfEgGLf/HJKMtQ03SP9cBPodGYqpsdgnVtaNP4ZZedaML1MxkGCIQ+VCag8ghXD4AoxYAcd7BXqLZzCv6VlG3npUfRvGdB9LXdp109I9EPtUzR3xHHv+0EU9zeXGx15jFV/BHcRWHGDSUwcYG9z2q1ne3niSOXi1RGY4l9h2UrL8TJnrZAcxWs0bUYeaBSv7+bbBG0qGKpAOow34EcoVCUURmTGq2/EhJvCExhzznRVBDfFHTNcokVmMM7IqJ/T5jpecu/dkjTnP/5EZu7tytxHMYbBahdSuBWQJVrqakCeuyAidNbXfj9H404qV5Jcw4F3n4fZqtq53QMavwAK5R689yTHYf5JaaoH8NT/qX+rmmi2jIpOXSnKsBIDHZPh9xVzNORKuUp0PmAoSz+7MIzUoyaUQjChJK2jH29FJsWkKVbDRjyTqUVang2BTsQT2EcB5s8DEBd8KYaLkZMOdUd38O3Zolzw9VjimOQsQZMvy/QabADO5C/HEbvtcZzjWwZk1KgPZRc30S1mNlIxz86ZOGY7KVIYN8XUx42/PqeW4pwdomHkE8dk1FCjfcbz442KU88Z3fXFCRuwY/60kuQjdVqyyvariiDaAVg7uyOaImhi4J/4kqoFlK4Qth1rmlKSZ2iB4ElwfZy0/6pqxbm0lQ8KGtY/OpBVoip5hFCbUdB0GPC4MVhyzLnWjSCeLOabw4gMDfYcEnxSv1wmuIzPi/F6M6/iPaGfwT1IJuc8MSdlM8WEF3G/NooKmFQ5fby275lRFe2viV5mXFrBreLS33D6xpcF3zuLiry1tjlQlzgOdiupI2HYVL9/EEzBAE+B/6z9c4wXKX
 e4Bp9xNs
 FucjuGNI3ceI6RQ8pFbrFfBEXoEa7kqgSSX8cAbHdEdi+KAnAX7n09Eju4tlP/jNO1q4NO4x4tX6YTZroauqjS8hcdg/DUJg/BsJx1n1Ww8mX7xit8KoG0HWfK8wLSXsjZsUyyLHdPMbc15E38a3VjRSKYGxwRcEHfDg+1Pwd+CqKHf22iWs11hk/AStilWnmEu+BXJPDVHY/dLQFACPZNf3kwhLpdC+n8JFezy70xSeXOu6k4tIEwelFmneZYCG1pXlYwYRFjEsD+Bio3M0401ndJAI9HQDRAebHpg2wUwPQc/boHgBVu5FhY5xfohxxmqsaXKvM5nGHrzKJuzG8F1mekmjxpauCe8ey9L+m9uSVZ5Rp7PxXt2chJOdHNcEXX8OW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 13:00:06 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> The zap_huge_pmd() function is overly complicated, clean it up and also add
> an assert in the case that we encounter a buggy PMD entry that doesn't
> match expectations.
> 
> This is motivated by a bug discovered [0] where the PMD entry was none of:
> 
> * A non-DAX, PFN or mixed map.
> * The huge zero folio
> * A present PMD entry
> * A softleaf entry
> 
> In zap_huge_pmd(), but due to the bug we manged to reach this code.
> 
> It is useful to explicitly call this out rather than have an arbitrary NULL
> pointer dereference happen, which also improves understanding of what's
> going on.
> 
> [0]:https://lore.kernel.org/all/6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local/

AI review has questions, which I assume you've seen
	https://sashiko.dev/#/patchset/cover.1773924928.git.ljs%40kernel.org



This isn't going well from a workflow POV.  I merge stuff (this was v2)
then half a day later a bunch of potential issues are identified.

If these reviews are useful (they seem to be, enough) then I guess I'll
need to further increase the lag between seeing-it and merging-it.  But
if there's a 2-day lag before I get onto a series and I'm the first to
look at Sashiko then that won't help.

So it needs to be something like

	- series is posted
	- 24 hours pass
	- submitter takes a look at the AI review, maybe prepares a new
	  series.
	- 24 hours pass
	- rinse, repeat
	- it gets merged, hopefully with some Reviewed-by"s.

Not unreasonable, but it requires that submitter be made aware of
Sashiko's comments.  At present that's via me being tiresome.


Anyway, early days.  I'm thinking that an emailed reply-to-all from
Sashiko will help.  Much hinges on how useful submitters find these
questions to be - something which I'm paying close attention to...


