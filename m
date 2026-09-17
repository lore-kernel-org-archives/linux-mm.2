Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E146C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 18:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 295676B0095; Thu, 17 Sep 2026 14:47:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26D9A6B0096; Thu, 17 Sep 2026 14:47:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 183F36B0098; Thu, 17 Sep 2026 14:47:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F06F56B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:47:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63B81C043B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:47:31 +0000 (UTC)
X-FDA: 85224137502.12.B772AC3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id C1AD740003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:47:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JnjBVVm6;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789670849;
	b=HtdsXFRE8w5Q+P04gPPVi4vGRzIyQ/afhd9HN5Dk5nsWRy1VDkZic0MInCQgcRZGRQtfF0
	g4gaxqQhAV/y5RpFFACpt1FgKzivp3v4X/KB82n1ZASvE85ch40V/g9rahcghdl90HQn5N
	NzjkhAI2leqMfRkmPDrxDpS4R9mD6hY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JnjBVVm6;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789670849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LunYzoiAKjoE67t/tElgUxKy6nFW6VTmmVlpKMVNL30=;
	b=SQA8njvZryQjCwMN1NLc9TlKvOsC30m0St/f7MvmLIQM4RrHvap8ix184pJqJh3gxSR8wy
	ZYAQuLFaT+baFVSoWbDI7Gh4d/u9xq4iBV9cWrGHsDVAlYd8xk/IVxsDvSslo4u9sgiG09
	Zzn8uZMfHrnIkDajW7azoZzcpMhe/No=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DA55743DF2;
	Thu, 17 Sep 2026 18:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3651B1F00898;
	Thu, 17 Sep 2026 18:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789670847;
	bh=LunYzoiAKjoE67t/tElgUxKy6nFW6VTmmVlpKMVNL30=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JnjBVVm6wJKpRW7Esko1uFg2mN8TSoyBw+7CZ9LrCD8c0C4WuHYkREzcqn57OSWZZ
	 WHJvvQwfQRAzhzye3VC8InZgAtR/12Pn9vPFyht3xBDL4fvWfvRKlxPJazjobRh9zB
	 w8WyjIkoCeRHG7T7UoMwuhDmtU91IZd+uRVPzG29vNbflMyMZqU7Ckz+j4fW5toUnk
	 Pby9hOcpbRrMNmELLdoVSF/yIiMahQFiIkNXk97Rjs+VsPhWqRMq0VEPJyGuINjKEm
	 a2JJ9M1IQiMwlOko9yN5vXoTLi+9A5CPdt463oTFxEa58L1fA2OgWV9JQPxPK5VKff
	 OxtkoWk3/c1Yw==
Date: Thu, 17 Sep 2026 19:47:25 +0100
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH slab/for-next-fixes] MAINTAINERS: update slab.git URL
Message-ID: <aqwz4CrVP8sKDfn5@thinkstation>
References: <20260917-maint-slab-git-v1-1-d21a5210aec9@kernel.org>
 <178965921180.1114058.11649457371183198247.b4-ty@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178965921180.1114058.11649457371183198247.b4-ty@b4>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C1AD740003
X-Rspam-User: 
X-Stat-Signature: go146sd3o7xyw9yagst38u1t6qts7p93
X-HE-Tag: 1789670849-988772
X-HE-Meta: U2FsdGVkX194LNO+lzp/oXuJ3iy/6Gw44pPiU6SKRultuAsV65QDcKxMZeg6JrzDwzm/DvRmfjzLkphZs3LmxKpSAeKHPtgHk023Saku3GB64AVme+Yzg9/telg+uboXLPdxHpSM3H2a+9eGYANoONfJkF6EfD9xK0hwUw324MyS4DUTAKxNxTkg5ZdGC24CkbsZJdwc4gH30xUsaehL4b9TNG/K9w7lMcq/mN4tMxZ5wPwEZccb8v8S8cUQjIPE4ok1Xy63PugaRLfe+Jp06v4czOxUrMO2pfYVj1fDv2sYClLKX0HN2cmkGM69eUYu9R6w6P0mJwRP8A2Az6t60R8msGUG5uoqJgX2u4L5HunDEgo9rMiPxcrdWSg8itvR/HNIUA10+2ZHRv35TMiAOSnpXwvfiw8w5I6WKQ0ojxE5P6TL3cOuLy7tkhnXkprjE5tuGnI3BpXsP2bzwfK3bMIQ5WtENs9wo9I1PY1VqrbhpM3gbEThNrIXLiBXB1s0MJthOQ1FGuoPQ4CBXsjPdIBOwyN+HTqM8nd8KMDAS6Qgi5fui/us6xF2DalWPSWY1SwTRsbWRwR3X893xAXovok1JuD44SJrdas0xaT8SZrpluRks8wvL82tqpNUP06xsZy0Unkn5MwdeChH2zMIOKJzwls335rHbanss6vI6k9uGQMF5reRHdV9w0UaLmSNorF0iIjx15YgblLGuu8YqCAiBlH2nw91ytaGY4ZcMnBcqf6mJbnRoddXQ67sJC2r8OGJxrOfLnVqVNsBjstukqO7GVCJd2ZAeVmDYXnO3k+xeoBNW7Badie6ja9v6vrbafLh8hLPCETRoUwQY7IUxxXQtjmCR73F4jDLLK2crV8dYEWaSR/cziZpYSgfyAN8n7ckeHmiYazR2iXwJWXWKgQ+eaBV9waO6EUyx5x8uyPBJPQ/9M7hSJSTwY60j6zznY1JhN4f/TzXZ50TUs5
 KYlA6RXw
 7tEfAuFdWzwWEygEztIXmbqoBkrVJgxNYvqpLTyFwCDbSS86LP0vAwGKTpnjvPJQ8GK1KgCliQ5xfXHJguGbAlyAdxwCaCe1MsTZ45W0jslW1OGvS5j5HClt6a2f3GwYHRiLzGWkY8SD5fHQXIiXgYUimWCg5mh7uurkfyzyfFW7eYkgYXu9K9DwlReuYzyyaLDpRpFwLQunPQXmyL9EHiCXm+Y/qNB1qCd4Bba4ewGO++hRq4xCPnLVYKJuM0G+FZdxpMaZASuUjZ2X3NLaSKJYWBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 04:37:01PM +0100, Harry Yoo (Meta) wrote:
> 
> On Thu, 17 Sep 2026 16:38:37 +0200, Vlastimil Babka (SUSE) wrote:
> > The slab.git tree has been moved to a new URL as part of the mm-next
> > integration. Reflect this in MAINTAINERS as well. The old URL will stay
> > around with historical branches and tags.
> 
> Applied to mm/slab.git slab/for-next-fixes, thanks!
> 
> [1/1] MAINTAINERS: update slab.git URL
>       commit: 4c51f0b648cbf190d15d4ff60826c769f7e81df6

Haha, it took a while to figure out what `b4 -sl shazam` and `b4 ty -i`
actually do...

> https://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git/commit/?id=4c51f0b648cbf190d15d4ff60826c769f7e81df6

/me forgets and learns what `b4 trailers -u` does, once again

Now it has R-b from David Hildenbrand :-)
https://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git/commit/?id=f4feefcf46b9a63e4ab096c3f2cb260ef8e3902a

Whoa, looks like I didn't mess up something.
Thank you folks!

-- 
Cheers,
Harry / Hyeonggon

