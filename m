Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74EA1E9DE6A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 08:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF31B6B0088; Thu,  9 Apr 2026 04:30:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7CE56B008A; Thu,  9 Apr 2026 04:30:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C939F6B008C; Thu,  9 Apr 2026 04:30:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8A446B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 04:30:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B087E2C31
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:30:59 +0000 (UTC)
X-FDA: 84638347038.05.BB196A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 910CF14000C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:30:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ruokKZdC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775723457; a=rsa-sha256;
	cv=none;
	b=H7oipGBgTEKm2QWXLr83Czhck8eQCI9ZLOiguz3vhEBaclMWNL3bIk54vFkoiKHkgttdiX
	HxdRuQ1ivIhP1I+KXL1ibmUaQo7rjJFoNsEoilK+qa1r/uSRqLhZfyLf9PhbdfOSD691on
	WuLMTKQPBSGPJEQRlFvhdA47D69i4qM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ruokKZdC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775723457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w7+WQEPdZAbaIeNUWLI05wldYgx//0og0LMFZyzUjgM=;
	b=63BBXwN8bfX+Uxa/hEmFq9Y0TcknBUZzQbp4QOOlcJ2+m2IyqFpranSo4SLMMzFyjFQfij
	it/RjWrxqwndY+x7rDc9LlkxD0sVmDvDQx/FMrQB+lcl2tF/svw9IDO+yyFGArDChaJqS1
	yys8ahMifMxhGdGJ43sG4/4OnWtahu8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B60444229;
	Thu,  9 Apr 2026 08:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557F8C4CEF7;
	Thu,  9 Apr 2026 08:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775723456;
	bh=w7+WQEPdZAbaIeNUWLI05wldYgx//0og0LMFZyzUjgM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ruokKZdCmJx7L5SIx8dUn8jgqp0U92ztzhYLlfLOqemt50nL01wCCr87saOVWQkRn
	 ipR56g2gMUyn7hp5+Eg+kRgPjjm5gs9mbHMTLD6GflZ0s7PnS91k99hm9zGOpRFz4F
	 JyYlNHF8Lq5fGjKdsebU+Pvd/wITCV25iGAxMFCH97JBmmWGKHPhk35PvUdWbNkED/
	 8+ct838P5EjqYeOX4zufsxjdQfkPyVX433K0rQWltCB8+3McXZNSV4fI1fGyFMFOKv
	 ZyN+vXRT8msUUf4WC4sEJuglCnHfUfpgzR+ceWRNb6RdYszyVIyVRorxDRUvuPAOHC
	 252EmDm7wALmQ==
Date: Thu, 9 Apr 2026 09:30:51 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC] fs: drop_caches: introduce per-node drop_caches
 interface
Message-ID: <addjLJ9MVTNQD7YZ@lucifer>
References: <20260409063503.3475420-1-wangkefeng.wang@huawei.com>
 <addP4MKmA8zfSN1o@tiehlicka>
 <dbb92553-58ba-42e1-b7df-b8450bd69d33@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbb92553-58ba-42e1-b7df-b8450bd69d33@huawei.com>
X-Rspamd-Queue-Id: 910CF14000C
X-Stat-Signature: 6iefsnkehzku161xkjabedbmjre8r5db
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775723457-874567
X-HE-Meta: U2FsdGVkX1+oHqMCVmIScn/mZ+4bPB12yjaY2PAvXc6xzpfeNHx6+wzYvojJZIXnv8G5oiC0UZ9a6fo5QsCu7q5RRouI7C0DF8gJcbp1YZu1MXnIlwRI0F9IzTleQs9yp1WLy44P4cr/mz8vzNqbR1kR/PxcoklkaYrUkIV9yoj9tg9kSvh5gdi5H9VgToxF9RebtBUFxSsP2mJMoh1DrWJXdVPoxa1il3aIusUirCYPEw7h2eIaOnUFZ/OxyYDX0lLMqhKHftcIKstcWYdaeh+VNADI4fxoIWp6+81YFzwHwY5CzBh3GmbUiH8DbBs7qEKg3khpcNM96uad0teGKtVQP6ZuvRKkB2oOWs5D1a8CmSWe9PT9jOtIWcv7dw9cVNrNu6Yq/NL3xOnDl+ErueWi03Eyu+2Yo4wkP9CSlJrhZNdeCdRJd+ZDb/DMX7Z2g4taAYheC4mgiK0Yi2uEd9qxE+ONWszzUuMDNn0Zadd+zNnTBKQalEP8hrq53eAEFLcjl7HU89PlIKA4JvkmTZ3xC83qgVdNbM3OCUX+rHNAoZNHpfu/5baMRqUCjrygXf8d5XTVuWYIiEx1SS1y/9hdIQfTHMeZms9A/sWDS/BvH67Umj552jdxLLRjgM/wau1C6Qrq+oasPceQj7SbP3BQkCqxqrtfffQLsVE9SqLAvkn05LsP7cfvFUy3PhowHTnayxa1INf615gb5jTWwKdvhNWeOorqvU25Dw5ancGjAmqmXz43Ypi1Z7yb2eVNcKKEfWubAByqr2BXbGprqcXcg8Ec2RNuwE7jwU2GguDCvy1Fy6bEbu3OA3et99e83oM+uBw1Ji5GX7yDxUTcLdda5YlFkkHutVNJPXp7PoD0I0yUT4rBI0b4PzfFLOENUSP/PjxyeyJ23kuZi3Sk0vpSYnUvkHV1JpF75eBdARRn3XMyHmINhE275FZKfaReaZ9pxsatzITtYywN31V
 gSOxe4Sw
 GiDGSjWd12836wW7GdlyaWUujANhDdifm9F2+qhxqdFLNB9nKT7zgbnwKymtDVNuHhIv5pkKhWdjJUd4p3xUrHSGdv99GUFKffSjy632VnDawS/yd3T0LnVt0C8Wum0H4xR3iSCcetiT3FDBb/OdjzJnu6B/9bbx5rrJMxlSNurNw+9i1Q1L0iGQA/gNXSjQvXYdaxXxsiQixagrl97y1/hXCzHIH8GTJAw9Lqzb7svaDboEqt52uH/AcrQc7ippElwbbD4v5AMdjqhILLnzhadh5LkuqtYQThoLZ+AeJHCPnizw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 04:08:37PM +0800, Kefeng Wang wrote:
> On 4/9/2026 3:06 PM, Michal Hocko wrote:
> > Quite honestly drop_caches is not the best interface to build any new
> > functionality on top of. It has backfired a lot in the past and we have
> > tried to make it extra clear that this should be used for debugging
> > purposes only. Extending it further sounds like a bad step.
>
> I am not clear about this history of this interface, but some of our
> products do use this interface :(

All the more reason for us not to add another one like it...!

