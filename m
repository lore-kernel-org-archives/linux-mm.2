Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B4BDD39426
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 14:37:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9104D6B008A; Thu,  2 Apr 2026 10:37:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E7786B008C; Thu,  2 Apr 2026 10:37:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 824F16B0092; Thu,  2 Apr 2026 10:37:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 71B1F6B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 10:37:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27BD2B9630
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:37:51 +0000 (UTC)
X-FDA: 84613869942.02.7C8723C
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7566B1C0013
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:37:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=PAJGAi81
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775140669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z5ZRPGNvAMpOcTixcrJlcNRUdg6JCMkwOopqEJi5GRQ=;
	b=IdhrqbJ6g5BI4dvrxPlocizIAC9hxhskcJxLQXYft2Z7AlD1rO6z/RoaiTXByaMEV6tbAG
	H1NNNttlrXHSZlvpsWfjx4Gr3b0aKp7HxTTqRpcctO/loF0dl3UweP4TmmuGBqCOj3T9gr
	8jTvtl+r2a3PZPI+cYE3OJQzV2gdbj4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=PAJGAi81;
	spf=none (imf21.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775140669; a=rsa-sha256;
	cv=none;
	b=ViwvsF3ACkiwMJd819wImEKeLii52Ew/LUh9Ll2slCcQFkK38U8hUxma3xQ/CSuUcT68Fn
	uGbilIprUh/23pXxjLX6nockynZ87cD+9fH8nZOOd9tkgWPOZxK9NgZBi7d2G9efGfCGsp
	x0ijBbKxG4X33dsrv32Ege9OlQJj96A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Z5ZRPGNvAMpOcTixcrJlcNRUdg6JCMkwOopqEJi5GRQ=; b=PAJGAi81mveUFhKTreIg0VaZ4M
	Ze7imDFYG9dGUwVISQTHgnRqm9I05OmpasTd+LQEt7hBsnL6qbFWOi/Qf1WcrjcxPrSmiCYypoL3e
	nKhzZbvV9Pm0wdmbx6l3WHUBYsKPLHQm44UEsBKGQwQcyG5q7ttXkgDEBiVu7pmuRKpGqHfNjShA+
	HyQLs90DxOPvyMb12KMTGzexbiP2U5a7JlJ9kTMYo1c4lV9zfxDknJd2NBQ3aTG33AiDT/CblTtE4
	XIpWz77MoERtCtD4coeFLX5f6LuRRfIqIWbb74QNZsaoup2S5Y5YxpVUZmcVZKboQdaYA+PrBcn6t
	0562CfCA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w8JAr-003pcd-0o;
	Thu, 02 Apr 2026 14:37:32 +0000
Date: Thu, 2 Apr 2026 07:37:26 -0700
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
Message-ID: <ac55BrZEXDw1Mt7q@gmail.com>
References: <20260320-thp_defrag-v1-0-6ab15d0d26eb@debian.org>
 <20260320-thp_defrag-v1-1-6ab15d0d26eb@debian.org>
 <3c2f0e52-0271-4bd7-b3d7-84249c40e2fc@kernel.org>
 <ac5w-LjEA3gkGHNf@gmail.com>
 <1bd5618b-f21e-4f87-85fb-e581d1efb803@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bd5618b-f21e-4f87-85fb-e581d1efb803@kernel.org>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 7566B1C0013
X-Stat-Signature: whiwc8aef76bj9fu3shxd6oxoti9spgc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775140669-651807
X-HE-Meta: U2FsdGVkX1/QNKsXBVftQdD4esNxaebpFNlCMbjr6RGrOfP7vSJnuC3kcHMg9fx7kRAa2D7quXtAucWzdYuW7uzrO7LNJSRqSL5LqwOCjgWpqQHid47MAlmx9KTndoBxYJlnOhT+98Hk+QZEPed8IJZUv/Uk1L/4148VdxsixWEXUIKT8vZDjh6ix8S8Nt0RjXchvCW8UUuqYjDNCS8w51p8p1UkqfUN/kfjUaHlBIyswRstXemu7hlSN48LwCt10VG4y+loL8RczEUQkkVSKxlCCSw+87tGFdakR/9c1zCxFb69OutDBhuyMEfRv83ZOogs1mbpDyYqscgDLFxgHS5e9S35in8BiowiDzToYcOgvKWP6GG0/xX0yfVHnbYXaq/MwUbuabZPS5Iyf18NT98v9H9rj5k8aI2n/lbhMr03DLmT602uCPsDVwfo2Wm+aTwKgggXVPxSFfdWF71jwnvylCp7nkcYN2IW0LlKGaPnTpMBY/moeg+eXPPVl3qcxir7BGOzjdyX4dA3y0hLgQ85pbtNuO2TtfFtNkjvRU355NM8ohGSE4s4GtDWz1Dat/Jbi08XdngvwSENwoYR2f/BvvnW9Dn5mPxiK6/XpJVBSGsYPsiX6yvN+StxVaSiTaWTW/w2ijN/zB/fr2xUsBgATQnCLqGaZ+JRY+XXsje0+gFBePHYbTI6CQZA8mpn0WQ0H+WAP0HxI7aobSWuqTzcpKBVtbJ9bEm1HDx6DDw74VBTnkfbKMNh3gmB+x2vM5dTfUdbrJ5L0cuvrN5yBE0b6LviUdL6kwFC4rW3b8FZY4ajLBZCxtXiu/N1Qy/REF4KN65BOaMEb4PXoCL6Z0jv/rAYH4wtdBgn3fv9LA7EhILu4VZSd2q7hZK5NTwOmNb1+sKl/4jjjc4ZDGUy6x6tMxkEizBpEe7IqvgaN0i77pD+zorsi4qtXUWYnnVdiL8F/e8NSV+HHtv97at
 x1tGf8/9
 mvUrupl5FgFoajetu4Dw8CLf5/W5ymCecd/vSZrIp2AmCBJ/gFqPTuCbyTB8y1g1fpyit6TjPokIriGq/Ml0rUfKiNDhiHkA0RgX2FCSavvJytqQ1BdC1NnGHXLginrVV1coq6R8yVOXoyRbnAOwm8C9JHuHcegMeWWMgAxR7aBIDPrHMgcENavPpth1mzwAqGefefbt5KNr/xF7ezA99o6QHxCSl1dhzmGC2JDTR189PzhKJg8agLC5Rz2qKcjPBAPTs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 03:45:25PM +0200, David Hildenbrand (Arm) wrote:
> On 4/2/26 15:42, Breno Leitao wrote:
> > On Thu, Apr 02, 2026 at 10:21:30AM +0200, David Hildenbrand (Arm) wrote:
> >> On 3/20/26 17:05, Breno Leitao wrote:
> >>> +enum defrag_mode {
> >>> +	DEFRAG_ALWAYS		= 0,
> >>> +	DEFRAG_DEFER		= 1,
> >>> +	DEFRAG_DEFER_MADVISE	= 2,
> >>> +	DEFRAG_MADVISE		= 3,
> >>> +	DEFRAG_NEVER		= 4,
> >>> +};
> >>
> >> These numbers should get assigned as default (C standard) I think, and
> >> can be dropped.
> >
> > You're correct that they would be assigned by default. However, I've
> > explicitly set them to clarify that we iterate over these enum values
> > using an integer and require these specific values.
> >
> > This was discussed in the previous patch series:
> >
> > https://lore.kernel.org/all/20260308140530.9ab6d1445d0936467eab4aef@linux-foundation.org/
> >
> > Please let me know if it should be removed here, and I will update the
> > patch,
>
> It's ok to leave it. It's just ... unnecessary :)
>
> What I saw in the past is that we highlight it by only setting the "= 0"
> on the first entry.

Understood. You're right that I was overly verbose here.

Thanks for the review,
--breno

