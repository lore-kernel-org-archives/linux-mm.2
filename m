Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7F4DCA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 14:03:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0C36B008C; Fri,  2 Oct 2026 10:03:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C617F6B0092; Fri,  2 Oct 2026 10:03:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76F06B0093; Fri,  2 Oct 2026 10:03:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BEB66B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:03:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D474160737
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:03:39 +0000 (UTC)
X-FDA: 85277854158.11.E6284BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 85DF010000C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:03:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eKoc2jCl;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790949817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gWwfdqjbo5/JYZBSynfxpMN46VuFVrXGoHfSEvxFFA0=;
	b=QA4apbV2Ko8CJz9z1S4d+Dzb5HPHZIF53OhzW92OxFqYp9+j+xrUN1DJjWxOh0PNcWOs/V
	aI+SJR8jE/4bslJXAxnyCkzkWYN35sUXdwEicF+ezp2hHrF26bLcF7/5xj2IPl6SihhGZg
	BzRZLm7kGcDs6QzCPJZO69IZ5hEJ9Po=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790949817;
	b=bIw3tgyVZhszTTHuu8KGkGG8LNA1BCRN3Wh/EcB0eAa0x3R8S06J8cR0NSM8/TIWFFN8yp
	Suec3isY342LIfnpRqHzONRzZGy7QZx1mkN6ZrXt/3s26DbQxAESi1xHmN23NRf+tUPD6+
	FoAJaBGH3uVE1yKFqlJhJlFXk3jcC/Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eKoc2jCl;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 111C060A70;
	Fri,  2 Oct 2026 14:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF3D1F000FF;
	Fri,  2 Oct 2026 14:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790949816;
	bh=gWwfdqjbo5/JYZBSynfxpMN46VuFVrXGoHfSEvxFFA0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eKoc2jClDyYguaZFoi6WI+m4U2zVSs0I7XA5Umw1GJSBUKpkJBfkdyaGTEyorjZFX
	 hNhl4DZ+INOhPFnqYhXqh+WoOJoer+Z89yZmf0ZxL7Lg97E9zZT3jm7Kc/CCCst9u4
	 3vdDN37e2fvWz7cRsSuRKAWWE+71BpKefEDwbtH5p8nvU9/7SPLQ5xcdAU1Kq+t38B
	 kYfTCTGnQTdOSuLsVAumxJEPwb0C/nKUOCc2hzySMbKg0cd+tP9TDxAuJe6kjiLtfR
	 SpFVwzdKnr/RO2BpDaAfrCRUhoty+oZseiSp6sKMFtot99Cf3V8HQjj6lSuJRMbEZl
	 zTHIiP77MOXiw==
Date: Fri, 2 Oct 2026 15:03:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>, 
	akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, peterx@redhat.com, dave.hansen@linux.intel.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm: don't ioremap COWed anon pages in
 generic_access_phys()
Message-ID: <ar-5iLzr-1LH09pa@gremlin>
References: <699ae98c.050a0220.340abe.0d31.GAE@google.com>
 <20261001152524.171115-1-ngocthang2710.1999@gmail.com>
 <32fe40e2-854a-47ec-9d95-93e23f9a7af4@kernel.org>
 <ar9omYD3HcTDBpGA@gremlin>
 <c6253814-0cf6-48f3-8f81-3285466dca45@kernel.org>
 <9d43234f-93cb-4c86-a2a6-a3cdebf48f3b@kernel.org>
 <ar-Cq0YNpQ6_3fDG@gremlin>
 <494d436c-e3b3-4b65-8a6c-1059d9f468d4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494d436c-e3b3-4b65-8a6c-1059d9f468d4@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 85DF010000C
X-Stat-Signature: 99mwr37mg3buxtozuowteoioa7cnjszs
X-HE-Tag: 1790949817-275761
X-HE-Meta: U2FsdGVkX18akaR/Dx/WQPAhh5eW/n0UNNJyccCSJDZIQV6oMad1Q1FK5eg8sauJUZST0uFUPUqSvCR7iJIHtafeg1buGE6Z79g55GcxHuxq7ViATYc0zARIvJwZQQKuV8v2v7zhJ/aLLM/J7jrkjN8JF9eBgE7gmnl+9F2b/fuBRhpQNTkjChmIxnh4+ALgMcHs+qHxRh4XBPyXF/zp7oPAOVVjmA/oieIwcLJ0eynB4g4vcGjx0gEbicsKEEOv/jqlF8zwoj4H+jKF0wNOvJzrPGZpDyjmR5nvSlZKvAgk2MrXr0d7VAHsSb1O5wTylniSiONNmjisjXVfSsvuyqf4jKP5qB1nOtBDRYiFHwQDmCtcFkNHXy1N1XQsurj+kXmX+/R5Rr/YKl+vjDGr11Nnlu1l55lQFGR4N7EDy79tVb5AUUYjtQhECEoH19WSNARg2X48RAGYLtKsLwyAIxh2ek+P8kYAx14EuikoxuXn3B0iL4CCaQWFj1u0cGaD98FNTHADb6TRMZegpsDCBzncW+d4GHaUiyKcnP1syfH049SaCCpVKa1Hhnxy2Lm5g2jl+YbuQEbxFxlAHa91AbeRf6o6tkA9TSpvCGJ8WHyJ8adF9tsXyqA73yYah9bh5UAD1LFKYBjgBGqvMnZeNhFxecI4kaqE/UmMzkttQ6MuezpgGZ0kJ/W7cj02Hfoa4TkmI1WOqx4i14AOYrO79oyQddnwd7lKKZeOqTA40pfSgmmYYKJVRIf3lYYec89IFEsScy2Cz6siKk0MIbzXe/mpBsg4Nx7wNaiN/F+daWYnzqj1q3VHa/9c4GJFoSUa6T2wbOyFE50F4qkLxqn7tqG61KCiBIfaFWmLwxteYENtA/IjA0u78PSfV0WxVT3CPFjcYal19h7/D3n8uQZI5SplNvZ7FcWkNoVmiO3SrM9fxPQZF+GCYdlI702GcVWQD1DvpUDiTngESW946KC
 n+c/tgBk
 eKEjbSGSY97FUF836KzBtwqFOeSeq09Sbowg15rU1wJGEDvrTtB8+ZbGYHcmqdlaVLTzRW3RTk6MfLfNKctpCq0AH+uUm8GDEFbMGPg+FwTIkZCSXASlrzqJNHls5jHIhz/ns5abrVht/FvTsoEYjTDu+i7lbNKk/uRR0oGsnwMherC2BTMYV55Mkz98WIGzyoeN1sonRpWQ9Eh/YEwRLOMwJpr/ogHejhR6W6HJz7m0jHeACEb7XmuPQKGUGNd25r0QWq46EcYQIVnNDbOm+Olw2q7w9yZs1ruhBhw1uAsWGVhgQ5mRWrsINOfbeKAzyVYBw3u7HAHtAgMqORw9sxfD5ZfXlZW0rtGnbB8iswnWyjt5vK/GpAs7PhGxwO7QC4xlJAB9VtrLL++EaiQ7JLcTvp1svOikSIC5bHw+ieYCqL8hg5L5b6zIang==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 02:19:00PM +0200, David Hildenbrand (Arm) wrote:
> On 10/2/26 12:09, Lorenzo Stoakes (ARM) wrote:
> > On Fri, Oct 02, 2026 at 12:04:27PM +0200, David Hildenbrand (Arm) wrote:
> >> On 10/2/26 12:02, David Hildenbrand (Arm) wrote:
> >>>
> >>> Yes, I'll take care of it.
> >>>
> >>> [...]
> >>>
> >>> After sending this yesterday, I concluded that we can do this cleaner: just have
> >>>
> >>> bool normal_page;
> >>>
> >>> (naming suggestions?)
> >>>
> >>> that express that this is something refcounted with a struct page, like
> >>> documented for vm_normal_page().
> >>
> >> Hmm, have to think about that once more, regarding VM_IO and if there are some
> >> cases that would actually have to work in generic_access_phys().
> >
> > Well, my series at least makes it easier to reason about VMA_IO_BIT!
> >
> > Though not sure if it really touches PFN map cases specifically.
>
> I'm more concerned about someone using this function on VM_MIXEDMAP | VM_IO with
> a memory page that has a struct page but is actually not memory. So we could get
> something that vm_normal_page() would flag but generic_access_phys() could
> actually read ... I'll have to explore the generic_access_phys() users once more.

Hmm that could be a problem also for struct page's that are there but you're not
supposed to access for other reasons to as well?

Definitely need to be careful about that.

>
> All way to complicated (and you series improves things).

:) well there's still a lot of complexity in there, one battle at a time...

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

