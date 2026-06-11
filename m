Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53E22CD98D2
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 09:44:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D1286B008C; Thu, 11 Jun 2026 05:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8810B6B0092; Thu, 11 Jun 2026 05:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797666B0093; Thu, 11 Jun 2026 05:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 65FAF6B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 05:44:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F151812057A
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:44:42 +0000 (UTC)
X-FDA: 84867147204.01.024CBCD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4D91B180008
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:44:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DETy5PZf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781171081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GDi+IlU7odqCU3b6/NqPii4xRsY6tCi0zw2in+d4kpI=;
	b=gmNy6981/sTQSk+Fck0OjN1rTxRJtjcYqaZhWYai3k+IIWe0qDz7mf+XQq5sQW0AqsjNUw
	vfiUacijNRrT3YvKPNPLx1rpKJELGQSf5eVoYBDxuTZf+kNrJMZj5Iognv4AAtpWDMsbxw
	rvJS34I8Ig4aW4srgifQhpc/asbDeik=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DETy5PZf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781171081;
	b=X8iXC/P0VuPvhNUuUIhs0h9SbGYKHdqWRkuRSZoII6h8Rg2U4W3fv0YjTvepigUVqr+4t7
	cMwgA+c7fUwTPIIAjkncQT7tgpCNN1I3DYj1J84xc6Nc+n3afm1D67MWxvJ4d3/roXX6/4
	ckZLJcAKi4nJl5pKK9b3rVhZvbLtaFM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C36C41905;
	Thu, 11 Jun 2026 09:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87081F00893;
	Thu, 11 Jun 2026 09:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781171080;
	bh=GDi+IlU7odqCU3b6/NqPii4xRsY6tCi0zw2in+d4kpI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DETy5PZfXYGzapPs7W3ysg8WksQLVm4wbK3V4tyCuDz2DsJziOB74H9yxhSw23vsf
	 LMiYqsUWWzLHFg/5YNab5HEts4ZmRZce+Y75DSjnDN8/IgSeTCc+sIfx/ICSwJHEfS
	 w6XOrpH9EBGuu0xs6OIjPbfQIVlSF05ntEbdH9DpcHbzwvCI7yVY7qwfqsh5WwQnAu
	 aoucjQWTxgJNGfNacGus7yeldVBeSOatDzy5cDQp/6IYZky0Iji4qpOfnD5vOGGd4R
	 8nOPK3qURixRO50u0Y79DftYV4eNlzTJDGHGeEce7+WIVGpLO9IiPH8h/Vm2nOWzTu
	 bT3s0skcQMWWg==
Date: Thu, 11 Jun 2026 10:44:33 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 2/3] mm/vma: remove mmap_action->success_hook
Message-ID: <aiqDUBVRGay_6P3n@lucifer>
References: <cover.1780397980.git.ljs@kernel.org>
 <f79434e6d30af6d92999be6b76e197f1847105fa.1780397980.git.ljs@kernel.org>
 <aiprMy4_XyNt2CYO@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiprMy4_XyNt2CYO@localhost.localdomain>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4D91B180008
X-Stat-Signature: he7p65bjcmwwney5p1xdeqbehq8hogry
X-HE-Tag: 1781171081-96513
X-HE-Meta: U2FsdGVkX18b/7wrnQJn5GM+1EaToFkpuxRYysaHcIV0T0G3JOjnao/C1Ht/a+D1hJOI/o0ZoUCYjXFOJB1t7rkPHL4/0+6cQIzUqw4koklGjxU10mf7jujuYUIwasUltAVuPrmeP+hfLEW3mko+u92QQrmke9dHgD08SA0m7d75+1TdduoHFXjpOFV9ceWGm6DV6QkCYDofpgP2rZ9KvhCjyPJBX6/hlcz0Pj/23hMMsHRFaG80Bn/QM5ZtYG1kpyu12+jxVw7YOB8qs/BAEoade7nQJm/+jL1bPDuUvWh5YRwvDcJ7uSETZyp9YOJCjOVHF7BRGxClbRpHagkjqKa8wR5UN8s8p5iiGgEyMJaw/c3dREL+q9MzItawOrUphuALXx6x15T13zYIcfb3gklHow8x7SSoSlGHp7gv0cVldLTMY2604vF83DPvur/1AF/hW04wXh8cW/SX9EpwVD+4SOysoWpJct9fj7UDJMc8RfjOIqcza07uwklWZeAUMnN1ddXI2ukJ3cz67c5REjwObjDT8r9QFgzftqYHr0d4jk8amdmWNCtM/AwWt1RysEVIOaPfSu4RcfdynBaQiBY19ABN/FXB3rahN/4GIqBRZJpDh7tMwVvYjp6PWQkZ/3OdijchOYz9Qmmpb07sXFVRIEbOemad9sqejWNyp1CLZuqiTVLmsrszb5tIuaFif9xxQQSjs7+mGp3P42Lky/+UZ7pzKtbLLvjdrclEp2bLk/dZotB3rFdr4b4e17Bz7HzkEY/qAUOsfW+OjomU7TueSxbLTq+jvbNhg1DrkrUcfQwq7rvHT/XEOZkpXnUnvziMMjS4HavGbWrW08IvxE7VpYPQ5FBrHpjS56nptwKszFUZjqSVAJWnlXb/2bDwcY1vT2KKWNnwlgdo0vQxbPaGkF8vHGfkECKf3ze5JWLgc7loAYQCu5PagjOQ1+n7nO/6x+qi8uubj/Vj4Ac
 aVfOo48f
 oyUgpYhqjaTrn8Y1l0Ikt3RWmT4k56KvmrP4QCLMMb4ET78PIpu7GNVI5+QPTA1y1mlcgzBZOaRITxELNjSbSl9BCQ3bO87hh1jydJK1WTHDft6Q0QksXpGNWyJd6xfFp1jVdd8YRWsC1/D0KJOmoIAwRuE0wOIz3BeH4UuPUN5iBzHxWyeAWNFs0Nhtgt4bVRjsrxmuBghAUZLi+LDDiJQrBQAwFc/u08xf1piPH+KVm4xCpDGRf86DPGpluIrZb5t7eItO8eRh0FKN7kpVt+IxFwxP9iKF4EHhTqegbYNAJQh6nfGa37vs2Dwh4oe/EZ5M5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 10:00:51AM +0200, Oscar Salvador (SUSE) wrote:
> On Tue, Jun 02, 2026 at 12:06:26PM +0100, Lorenzo Stoakes wrote:
> > This hook was introduced to work around code that seemed to absolutely
> > require access to a VMA pointer upon mmap().
> >
> > However, providing this hook leaves a backdoor to drivers getting access
> > to the very thing mmap_prepare eliminates - a pointer to the VMA.
> >
> > Let's solve this contradiction by removing it.  The key intended user was
> > hugetlb, however it seems that the best course now is to avoid allowing
> > all drivers the ability to work around mmap_prepare, and find a different
> > solution there.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
> Reach out if I can be of any help with the hugetlb thing :-)

Thanks :)

I will probably have a quick go at it at some point and just see what I can
do, hopefully I can figure something out quick, otherwise might very well
take you up on that :))

>
> Reviewed-by: Oscar Salvador <osalvador@suse.de>

Thanks!

>
>
>
> --
> Oscar Salvador
> SUSE Labs

Cheers, Lorenzo

