Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5F5BD3941D
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 13:42:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B9606B008A; Thu,  2 Apr 2026 09:42:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1907D6B008C; Thu,  2 Apr 2026 09:42:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A6ED6B0092; Thu,  2 Apr 2026 09:42:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF1136B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:42:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A0E141B8749
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:42:37 +0000 (UTC)
X-FDA: 84613730754.17.5BDDE5C
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf06.hostedemail.com (Postfix) with ESMTP id E45E5180003
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:42:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jcv47Cld
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775137356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HzUyBSX9B0826rh3H7aiflY6cSvBVcWG5MnMLxb5ifo=;
	b=eCh0t5ibPzw+e/AbxPi5xvZzfLyPdExhyfMMnyzuEqxQ5U1YjAtspNivYlK71o6e3RfMar
	oooYnDzFevSCHZmWNiTxMa8MnmFPe7dkQHP06GNjuPmcAVIHqsF7Cd6aM2KHWmGIX3DWNc
	P+nvCGj5VSKcwFsi87xX7XOBgaMO5oQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775137356; a=rsa-sha256;
	cv=none;
	b=rfslMAmRjjW6yxpGp6QVRKPqqbQe1eB2Q6c8/5BeVvLKBt2yx999Lqtz/DzsoE14XNwBqP
	m5knBK8GT82zm9oEnSw+sFjz+zBc1GRHPwbZKPcmN69HXx9sv1OG0JaGWFyOqItpTmCuos
	YBc8U5DMhqGkHEhMnaxf67MOIw5e8lk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jcv47Cld;
	dmarc=none;
	spf=none (imf06.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HzUyBSX9B0826rh3H7aiflY6cSvBVcWG5MnMLxb5ifo=; b=jcv47Cldca7szzNvJ926bHHXv2
	xWmfzFYuZ7r+nsOCy7qdk6lIegkj0amoWxUE/KP3Qq1fYbW8XqmPVdrEnyIlGWt2oBeBI7VCRmOs9
	4QtGqG1HJ11ibQySDvtPIk9rd9JY3/rjbBc+RsOPWqxMwg0RqLHQ3JkXC1ru5QodJs+NAJmg9brSJ
	Rl02Iy01EehBzGK+tNwAPXymlElqHJIc55AFxJedzgpo+zlbLbsLNCQgW1uDlUiFpFxOBWHONW6nP
	4wKsWYZo/RrqmDnJWtdwAajpbBVK5nsDfPC5uBpseb8hma2w9em7y9jBk3EMFDl+VOOK//oeCM/Nz
	p1LRSDzg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w8IJP-003ns7-25;
	Thu, 02 Apr 2026 13:42:18 +0000
Date: Thu, 2 Apr 2026 06:42:13 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/2] mm: huge_memory: use sysfs_match_string() in
 defrag_store()
Message-ID: <ac5w-LjEA3gkGHNf@gmail.com>
References: <20260320-thp_defrag-v1-0-6ab15d0d26eb@debian.org>
 <20260320-thp_defrag-v1-1-6ab15d0d26eb@debian.org>
 <3c2f0e52-0271-4bd7-b3d7-84249c40e2fc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c2f0e52-0271-4bd7-b3d7-84249c40e2fc@kernel.org>
X-Debian-User: leitao
X-Rspamd-Queue-Id: E45E5180003
X-Stat-Signature: iij61wzxcf8emtpgtngyyncepd56oppq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775137355-712419
X-HE-Meta: U2FsdGVkX19and/CpCVKcq/TaUisj9WCAFBC3o8jDXL9A+fQj8DUX09hmIzcmgXu2wFgi5YZpWCNBsVUedMIdinYvaNEOTTCM1ySw9K3Ozuo0A3Ku+CD8T9ZLsnjN01hXnX885g1JEKfFv/rExKAUnQGTBFVH8I2wzGBEqFSVij0XYOWMS5Q6rRDNMWYxkrVkoTTv/CwWbGYTgRm9ZMDrJsqNSw+RIqzXhpruoigzLJFg7j8JmweBmBpqN6OPYcqTRQAf10exDy7q8KoYvyAUjtK633oYtTMmsvPu6Jtm5a3MjgGGAfG6pHThRQ3Zpc1Q+ArwPXawfcBfCI9l8k4+v/7/8wIvZCzfpF29UOgAYwqjedz8ZVuF1mM2SvxqZqCrJ+sb1Li77HBuogdhKdyvrjqyYs5OJr0nDPaH31eVk51csQsGwHhGYFVOuah7dwRlv71s4fKk4CW/4gUOHlFgcrS1tiEo9o1UsM+L28SxJxiRqrGIpoKu9C2xTu6K9kqv118IW/A0xhNM29CHnJJrWELY+sIaEm5W5CpP2gozHw9uiZ00Yv/hqJwXcQAgRdDUZljoqMRWAhMAAuEXruyou9/kwR7Rtkux29DtoE+pMs+Aw7OKrq2VZK86FaKyyBNjxl0GIOrwaDsE4qXbh2EtVpIYkYgEK6oFSckT+MTJUw1Q0fmgoDfauncBEMm14kDvEPEjFJxPRzQWcZ8ba/DViixymvBFz4Bq/CIirSveFsvlfXfSlSjTY2Ns1SN5RTua1lxrFezj6VhajVd/0WM9yubX3eccQ2lv0xpZu705EViAfbSyrD1BkA5wf1EW068XqL+PenmnRre+FePdHSVZ8QqUv5dPOdIkHCeqpyURTP7GKkA+Y2/5ZMHEMifbgm+eDyIt/c2op9I3iw4x/Oklyz/RvRJGy7ULMY3v7LhD3SFuobH+7YBQlBYZsIR6NybAYO8SENuvzUloYwHIhS
 bDzKxyyh
 ZQuzZ5MmMZqvegsShFrNjHX0GdMR79EvQzMad2Ytp4IPCaguJ9PTRMdt7Pp8Yyh6kVt9eH2pKjTycWGolv6tM17lbA+nce6YA5CVtLDRF/Mva7cG/bpjFz+tHY+kyUDqhEr4Zywl6Um1cNEzDuZzGUgoumQ9WphsSNVqWVWOeAFLOT8hQDdPrlOPgzkyPYJIpp8s6NBUN5heqnBDNlNmw3KQ2+f6/4tiRyUSeIoS5ethp9mZeacRQsy75uK63joieL1eF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 10:21:30AM +0200, David Hildenbrand (Arm) wrote:
> On 3/20/26 17:05, Breno Leitao wrote:
> > +enum defrag_mode {
> > +	DEFRAG_ALWAYS		= 0,
> > +	DEFRAG_DEFER		= 1,
> > +	DEFRAG_DEFER_MADVISE	= 2,
> > +	DEFRAG_MADVISE		= 3,
> > +	DEFRAG_NEVER		= 4,
> > +};
>
> These numbers should get assigned as default (C standard) I think, and
> can be dropped.

You're correct that they would be assigned by default. However, I've
explicitly set them to clarify that we iterate over these enum values
using an integer and require these specific values.

This was discussed in the previous patch series:

https://lore.kernel.org/all/20260308140530.9ab6d1445d0936467eab4aef@linux-foundation.org/

Please let me know if it should be removed here, and I will update the
patch,

Thanks for the review,
--breno

