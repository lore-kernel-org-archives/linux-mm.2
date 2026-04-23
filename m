Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55AC4F99368
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 10:12:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA3276B0005; Thu, 23 Apr 2026 06:12:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B54056B008A; Thu, 23 Apr 2026 06:12:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A91B06B008C; Thu, 23 Apr 2026 06:12:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C31B6B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:12:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2CAACA041A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:12:43 +0000 (UTC)
X-FDA: 84689406606.28.B897118
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9B9B78000B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:12:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rkGUoWBV;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776939161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/QGaBkuH8/ZAILPAHHRSOYrjxsaY8b0v1dzahYdn6F4=;
	b=jeyurrBo+erTUeY42MGCID0KomEK9vPa0bYUShQa7mjFS1Lbpy7Vy4YyTQUD4eERYUvHYx
	+VYORp98LskvV75XDf4/SIzlkYkTx1Eqts29haMpPW2K2m6ZCzJA5fie78qH9FvsuQEGck
	UO1NLPTeXkKA3dh6UazeScw+Tx2t67w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rkGUoWBV;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776939161; a=rsa-sha256;
	cv=none;
	b=U0fm+HehIMgXiWCnEjkozjqShcgNN1Dz26F143SKNewaFHMXlNbwmqGmKO/ZzVRawc2Cjx
	JJwAp2opHHFoIGJFI56PPckge1gdUkqAiOLFeVKwy3DP00DWsNP6UsldBwTnOW22wEeTfn
	Jg7/wzMxg1a/B9aynuRCEKxgdkvD3d4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BD6D5600AE;
	Thu, 23 Apr 2026 10:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16658C2BCAF;
	Thu, 23 Apr 2026 10:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776939160;
	bh=+14qKYwGR7mK4frHPpqn4+FCvyjDbN88/zo77nmiP3Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rkGUoWBV2u1VTD+8d9LICVnCwPAgvFjhDDylawqcFBJvfk+19Pgr+HvzAbL+ZoCST
	 7dsFmhGyEZ7JFZvc4LILLuLdp1dex43jlHy+eEK3bKoc+Rr0L4VtwTHErlX9qURc25
	 8R+iAt+Ozrcvo960EE0WNnWFkcBDr7wgha6cClTGi0qZ03vW2NUdtZj6Zt0STUkFX8
	 6jg4vLPyuqhH4HGy7ssmjAD7jE5viuCqHFtXaCXkv/ZaocQYayOZMe/xvwFHIK9gLJ
	 eTEpkMMrvLrO0yePINl5UYHME+hLj/naE7VPY42ZPvAQQiWPJ0ITuG9ee+GY1csFQl
	 +5L2eKdLYdrXQ==
Date: Thu, 23 Apr 2026 11:12:35 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: SeongJae Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Vlastimil Babka <vbabka@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH] MAINTAINERS: fix regex pattern in CORE MM category
Message-ID: <aenwfb-6JPtnH9qS@lucifer>
References: <20260422123726.517220-1-pfalcato@suse.de>
 <20260423003227.74498-1-sj@kernel.org>
 <v6cqjcp3fdkmh7z7twu2onxvmybl4na4enbnpsjf6z3lklaphw@n7iqq4rbkytn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <v6cqjcp3fdkmh7z7twu2onxvmybl4na4enbnpsjf6z3lklaphw@n7iqq4rbkytn>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9B9B78000B
X-Stat-Signature: fip7eawobk3muuaxik3ahi6z3eo5mema
X-Rspam-User: 
X-HE-Tag: 1776939161-716178
X-HE-Meta: U2FsdGVkX19ygNu5O1duBpPiI1Qgi55fj/vjnAtTvhsCHOpuLXTd5NEnqp/yRIuohhexjyuw/rVzOQ8BPlxH8cqDhy3K0qTQkSdZHOiLkbKPJ8Xb80IQmUiCtqDcrXlRwrQAhxavosUpU4F7S42Vy6iRvHSaEsYcy2W69aPNhB+4sQcxh89yrq/vbhrZDIt0hRQWEs6bQIARTh9/E/MFsh3yK8MProcqSO2X3pMg8VN+mhbfnsEyJf6HNbogxJ07E6b4yMqxbINHy7HxbQFpLxhnBXBrw0sUMqy3FAslAqvNnUEp2RMyqAlFcSRzx26NVO9TX28Q/WalvF9UsPzds/Dhx5ArMWKcWWU3ZqS/bb2jowWKr56H12GjRmHEzP/mzJUYgpQLzWyR1R91l0zBOolG4t9kiLtphAzoO2u4Q+ccK9X5rE6HcQb/g8odyPQ0nhUaeDWzle0QtHWHBz9mm7IWoYb16qX+48SD5mTUy64wf0ceL3N85x8ulUxVZqlJbjRVADdvwJTvbTNhDI8LfZtOGi14Tel+qt6gL0YOBiG4sbYnk3fHTTpuI26PvjhS8UKfqbUCRw6eiVpKLA5uxUcB7VflmSQquEcR9CZN/6K96TIP2/XzPxmj/Y6lEhb2OKsIRzfCPjXVWJI42WTFthqNm3t8uf2dNKBYAD0Ze+qCAhszrzoUYzt6up3VBk/BWsuEK6rQyKSYGB3uDcdqyhMPZBn44jf8Da7ZLIt/p+agOqwt9z3BNKrS/eggZ1xXQDkHObzkB2bia95wKp2jcldAHu90X1bErQyVuX686XZXNuKAdKBoeVRKehOITbwEvMHFfHMUWuKaLRMckZmKVYZvYmpudvuQGnrNajpN3zC8o/ZvDtmFQz4QRGlFDW6jvYZfAJbqSR9RwPFu9TfvENlOX+jj0CtcDQZw8Zz2Yrnv+EKu2HlgnSgnztDWgTFS5q3z8knaLmavbEjKwpb
 fqY8cGdh
 OX/TEGE1dn0eX7eEtozYQcbGPk32mwsQo89RerbTbKm7EslJGg8K0Z2C+1/lAxg6bdjoDmrEN8bSTvAqgseqcSZs+1bc64BkQ9XSohluoJTuNlnWpkto6hsMppjPbPO6CF7k/OKWnOV81HVPv0BpSJgWHp6mOq7VNdbpOpiugJJnvD5wP4e9nQDRC9Kr82CxUUjqzZiMmSQKu5XnalH/pHRJgV/A1okq5JP6SDrSz+nxNEK4X458cn1RUvb9pdyPzRWHOAYIZN+Pv15dzv8AY9jHWGGWXesXeuJURu7UWIJEIr7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 10:39:59AM +0100, Pedro Falcato wrote:
> On Wed, Apr 22, 2026 at 05:32:26PM -0700, SeongJae Park wrote:
> > On Wed, 22 Apr 2026 13:37:26 +0100 Pedro Falcato <pfalcato@suse.de> wrote:
> >
> > > The pattern "include/linux/page[-_]*" matches every file that starts with
> > > "page", because it's a regex and not a glob (so it has the meaning of
> > > include/linux/page + match [-_] 0+ times).
> > >
> > > Fix it up into a more regex-correct expression. Doing so reduces CC's
> > > drastically in patches that touch pagemap.h (which is maintained as part of
> > > PAGE CACHE).
> > >
> > > As a side-effect, move linux/pageblock-flags.h explicitly under PAGE
> > > ALLOCATOR.
> > >
> > > Link: https://lore.kernel.org/linux-mm/20260422005608.342028-1-fmayle@google.com/
> >
> > Just thinking loud.  I was initially wondering the purpose of this link.  Seems
> > this was added to show the example of pagemap.h touching patch that can
> > dmonstrate how many CC can be reduced.  I once thought about suggesting to add
> > the number or the context on the description, but realize it is too trivial.
> > So just thinking loud.
>
> Right, I probably chucked that link in there without explaining it well
> enough. I was having my leasurely read through linux-mm when I noticed that
> particular patch had _way_ too many CC's. I had a quick look and, yeah, found
> the issue.
>
> For what it's worth there are many such CC's out there. A group of 6-8 MM people
> get CC'd on pretty much everything that happens in the kernel. Not super wieldy.
>
> One thing at a time, I guess.

Yup this is a useful addition, the link is fine one thing at a time indeed :)

>
> >
> > $ # Without this patch
> > $ ./scripts/get_maintainer.pl ./0001-mm-limit-filemap-fault-readahead-to-vma-boundaries.patch | wc -l
> > 13
> > $ # With this patch
> > $ ./scripts/get_maintainer.pl ./0001-mm-limit-filemap-fault-readahead-to-vma-boundaries.patch | wc -l
> > 6
> >
> > > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> >
> > Reviewed-by: SeongJae Park <sj@kernel.org>
>
> Thanks!
>
> --
> Pedro

Cheers, Lorenzo

