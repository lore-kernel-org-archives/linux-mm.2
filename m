Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6C69C4451B
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 20:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F77F6B0088; Sun, 19 Jul 2026 16:57:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4812A6B008A; Sun, 19 Jul 2026 16:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3705A6B008C; Sun, 19 Jul 2026 16:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0796F6B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 16:57:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6EEACA08E4
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 20:57:32 +0000 (UTC)
X-FDA: 85006737144.26.3A98BEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 460E7C0004
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 20:57:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Px0/OulM";
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784494650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kf/D2eGXofeqwU06mgJD2zI/DQOENIt/7RlYfrGzglk=;
	b=72yy/L38W9VwyWnRwXZs+jairsG2n5eUjRq8YCS7MKtyvjhrF273ZnF93D6HTAmSX55Y0O
	sm/sA5rp4CAYP329Hom+FfGjGHwDVPSrRSaLVZNvfYgKo8LHmt/d+sMBUBZRxp0jQkE2y8
	m3mXchbybdlebe6rDGDmlFL5mujPiBs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Px0/OulM";
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784494650;
	b=YhQXQqmmsA0TqcU+c2nQC0WvL6YSpckPTzHyBJhsg73uqaOh8RZfvKImLEjX0e0W7D09d7
	GXR1vlMmNy8j/3K6VM0DswEw/XZugfEBAQY+sEnWeb/0Fq1esPuU1hVL4q5ngOHgHoLIJg
	nP6OR2QgbaGys/NoLABU4/swq1PsCUs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 12DDE40BC9;
	Sun, 19 Jul 2026 20:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68181F000E9;
	Sun, 19 Jul 2026 20:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784494648;
	bh=Kf/D2eGXofeqwU06mgJD2zI/DQOENIt/7RlYfrGzglk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Px0/OulMXHjLridg50I95gUYfcWrh709oeu1hQg+2u64ry9sGaMHSG0/UT7hAmPH+
	 6cNHP66EAgoprnTu2QgMWiW8Blq3j+G7uIjN4oPiADbyGfh2x1pJ4Aea+tNHdVEUs6
	 Qrug01ntXR0xV9jN2gHvXq5fGIDgE8qG69LFI6Zo=
Date: Sun, 19 Jul 2026 13:57:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: <cem@kernel.org>, <djwong@kernel.org>, <hch@lst.de>,
 <willy@infradead.org>, <hwenwur@gmail.com>, <linux-xfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] mm: introduce memalloc_flags_move() for
 transferring allocation scopes
Message-Id: <20260719135728.cb036d8c922c5cea1e263ca1@linux-foundation.org>
In-Reply-To: <20260719095732.1813590-2-yun.zhou@windriver.com>
References: <20260719095732.1813590-1-yun.zhou@windriver.com>
	<20260719095732.1813590-2-yun.zhou@windriver.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 460E7C0004
X-Stat-Signature: n5mnen589wjukkcase896y6e11asf1pn
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784494650-243559
X-HE-Meta: U2FsdGVkX1/UR8O8R9P+iP2GTWuWCe6QL/9nZCGBO0WQKKmN7bbrcqE7pEGzw6n7tgVRjoxjwaOOYeqZfuNK1Ztz2KR3nyKFMs/W31GOEx32PjRMR6wAhylCXrc+jK/PPsQpcoIlLsQXChBbYjf6ANW+6H5UfoRMkwadagxh/rSRBptM2aCFWSA0mS5jIRYHLnwMCiaP3C4cLZlz19xOiO9F/6PqVcn9D/5pdtI1jl/mltdaoLxn9dOn2bpnQK+5tghH5scU7ME//zFPz4eFBl+ah3XGDdYr0P7eersnxRUjy1JZ6pWjDdpAKmX5LuNybJ936a+9U4x/7AJkl8oZN6JwOxRsOghIiJ9MUqchKYo/8WkTY94rZHFhEcFje+A16EKxoBcuCRpzHi1PSMSDl2zO+mo16qizwaC/VkoGx6qvTNrqXY2hNj5ZAeOqvlQHhx7y0hIUeiG7qBCVga5p0BZ0OVTGAvh2r05npgZ2RofrG0Qh9vicDANG3l+iTEUY16UF7iTMQjU3prEdwSbF3Z0Q43SmohVCs3AqkCRRsL05SG6rBhb34UKQqaky7cufcUdEtqPQQ6ozSHSFR0FbIe8m8bLTR+Rz3rMXIwWv4sGfyM7zy9c9wqTOAMrSWL+2v7Tg/4RMcuDTJRXq+k5XVV2BaQ1i1VA/Sm0ncjOSyutUieZEyWgM418cLY0/ZFwGDF9qa6XWKmgEsJEyyweE1BR4EvHqplOUnXIGKOg1dOuMvBU7ehlfXlyznBA/Z87cx/0W/Wawe5slgFEM60jKZQFuvUxtwaf6RfTnTYmonJmm5qZ5WD6xNdbQ2M1X6NbyKV3WSZAOjsaZVLOvEUQMUhj3TaYwhl9wJnLxVNgRa0rXtIAlKuPc+xlFWHxVugj0c6WaWUcJxGqzT+WdgBKJUnfcpDFOKppQ3X3Bx4VATsz3pLH0JqTUyQfPalb5VT6WEU5GPTmzcE+gOAlUKQ9
 xHmNUxZF
 pkcNT3ecSmEbo2TON9QpI1poJK9BfD0CUi/IjcYxlFP9gAlfBQPw07rksoyFEqlTWNgS6Cy2wpQRBvWCsuHFL5Gv6vtP0eTArEkT3n+gjDd2hNWFTalzz352jhp/RdA4rnnJ0/qbpH2Z3IkcFfHl0UqnYx602EPw9sutBKP6zWAXHkZCvV6kVxukPpjL+cLhpfm+1B7EC9HhV1dWcbE7w1QdQK+8ftpkhLXB0+KSiFFCSpOezyDI0SCFhDM39wKPiMfar89lpG+0HLDcFRfiuhVMdMPJcI/AEOkIOk7Z0wwiq4cNh6MW2hrS+kINA73bMsfHkYatu/S87a+p8R2k7MfGTE7DMWjRT2DmtWQ5hxzyi4BeU9dFpeze4lYutZ5P8K4+Wtzx+2YsN8V4KxPBvNCQg0bunoaiW32TM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 19 Jul 2026 17:57:31 +0800 Yun Zhou <yun.zhou@windriver.com> wrote:

> Add memalloc_flags_move() to transfer a saved memalloc scope from one
> tracking variable to another.  The source is zeroed so that a
> subsequent memalloc_flags_restore() on it becomes a no-op, effectively
> transferring ownership of the scope to the destination.
> 
> This is needed when a subsystem hands off an allocation context from
> one structure to another (e.g. during transaction rolling in
> filesystems), and needs to ensure the scope remains active without an
> extra save/restore cycle.
> 
> ...
>

Thanks.  fyi, Sashiko might have found a pre-existing xfs issue:
	https://sashiko.dev/#/patchset/20260719095732.1813590-1-yun.zhou@windriver.com

>  include/linux/sched/mm.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)

This file isn't mentioned in MAINTAINERS.  Could someone please propose
a patch?

From the MM side, probably just place it in every record which mentions
include/linux/mm.h - close enough.

> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -342,6 +342,23 @@ static inline void memalloc_flags_restore(unsigned flags)
>  	current->flags &= ~flags;
>  }
>  
> +/**
> + * memalloc_flags_move - transfer a memalloc scope from one tracking
> + * variable to another.
> + * @old_flags: pointer to the source flags (will be zeroed)
> + *
> + * Returns the flags value to store in the destination.  The source is
> + * set to zero so that a subsequent memalloc_flags_restore() on it is
> + * a no-op.
> + */
> +static inline unsigned int memalloc_flags_move(unsigned int *old_flags)
> +{
> +	unsigned int ret = *old_flags;
> +
> +	*old_flags = 0;
> +	return ret;
> +}
> +

I've added linux-mm to cc here.  Please include it in any future
versions of this patchset.


