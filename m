Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE230C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:10:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7716B009F; Fri, 11 Sep 2026 07:10:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E408C6B00A0; Fri, 11 Sep 2026 07:10:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D09F56B00A1; Fri, 11 Sep 2026 07:10:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABFAF6B009F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:10:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A9B841C00A9
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:10:44 +0000 (UTC)
X-FDA: 85201213608.25.8314B8F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0D7ED80008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:10:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h/c+qFhx";
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789125043;
	b=OypufJ45obxqEYXVuqMWp5rB4KBkPKbACqxHYQ310HFuj+t2PLIgfPgET0kTRwDVEJgcRV
	HBS9rFzkiU3CrDWPXY1qbRIrVxEASAMN9ij8/xEck1YnBudPIfa6HgAEln6CWCNnhXo31c
	hkBrRhOyBZ7VbqoZuM+v6hBL0Ew/X0E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h/c+qFhx";
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789125043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOHnzJY8zoaiZvHpHO0QM8mcDeIkQPrxEZz8rSneVIQ=;
	b=Z+ElpQ0fL9vfEAMydJCAt73fYfgdyo1gEWun+IICCWKdRAgOGPF98wCYh8f0cXPKxuZ7i+
	leDWyCrJ35Hq/cPEyf5Y90OhrZcvzDZHcZmHY7KwtqX2U85Qh2SCJv8wReoO+4G8y31rRA
	pz1dOtQaGMiTxl5X6RXZ1rGpgr+h97s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 22F2A43D91;
	Fri, 11 Sep 2026 11:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CC01F00893;
	Fri, 11 Sep 2026 11:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789125042;
	bh=SOHnzJY8zoaiZvHpHO0QM8mcDeIkQPrxEZz8rSneVIQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h/c+qFhxD20GqIbFToMJMf/3OEJTO8Zt02a1EHl9g+WuvtTnQcvBmYWeS9rs4soLk
	 YPLaZCkzRNQ2CllBH/SJwdb3mfBQcmBrLxkTNK3Aj6bbavz8HHLc3JqColBpJn12Rl
	 eCNOgXQ6reGJu7ZXrrd45MV8rODJeXLAsEffal2t33SAIS2mQM+GzCwHBjOQnH8RQ3
	 28e+/AVvvd3QwJTKtF6k4qIu/QIjuWMFwA+NfoqxuIDExhWYUlpRxpQ1q/Eu+Qm3UF
	 2nIUpWB+SUiC0H7zA2NyIIW7MN9dEorrXLzYITdkdHdE6DfhR789d9AhDErogP/9fw
	 4iawhW/J8MX9Q==
Date: Fri, 11 Sep 2026 12:10:40 +0100
From: Harry Yoo <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>, 
	Vlastimil Babka <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mm/slub: preserve one previous object lifetime
Message-ID: <aqPDpORERiVkBmBf@thinkstation>
References: <20260813160825.73031-1-pengpeng@iscas.ac.cn>
 <20260813161244.74476-1-pengpeng@iscas.ac.cn>
 <aoLcw91-afP2Mjtb@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoLcw91-afP2Mjtb@fedora>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0D7ED80008
X-Stat-Signature: 11yt8udjzp6mpiqq5c4b4akf34thobio
X-HE-Tag: 1789125042-818906
X-HE-Meta: U2FsdGVkX1+5B9vbYPZJttZpXj8FrZAFFiaVrWFkLXcSI3MznsLcrals+8A+PvpVaqx7p/f0gfVvxENUzzeaxG6Ayaozp6/GLuJdQpf2qxjpINgEmz7fxyOrY0ZEgeMyD2muM9pr3PpdH59rji65uVzrjl6t35KptW6cEnBGK7b642vH/OXHEtRpaPiwtMxJZnjA9Mdm+xEFP7V1k3KXvlI9uMQdYihvsVBOdOhEbjy1ODwgdvVFqXk1x9SLBIZHwrBVVMw23Cfw+3xdrLw0o4Ro40lPfm77rkRinjMdvbfedmmoIpOnLB78dIxfEXcS3LIVMiv61PQWf+JfixKI51erDGB/Z/o6B12JUtaDr8LTl2ZhxpsyXgfyeYcbGlNhP+hRMhgUy76iNBW0Ty5Po/pVrHiUc4W3uGOyZ9dpGUAT0I0bveemA5sW+4seH+ZGBclc4pP+GQS6mfofpNwq2JUDDVyxbdjIRCx6KUvQnzoVrlvtlofkO4GkCxyLVb4z25Fbph6tUH293dtgoPlTg57LHym/q3eErJD97rjZnUwp1wDPNw9zql76Uy2+Z/vcWWs5/STfM2zsvYjgxG09QITPWGeZ5gLsTwbAR9z6dw9Va+bV6EMUNQH5pQ31zhrCIpIAloQhyqfN5idhN5WMIwPOHXmF+Pl6zQ1Hpr9VIjx+8czcD14Ft06g3PuBP6M2eRXGYnck6498vga3X+W6Kt/v5cCYrh9cNFFebCLw5x9+N0rsIKiBYJ7s6hUXNxHPmNIIKxg9rt/eErJCIJYLGuIvbpuesrKKuiArfuIeXhIaQdhFXFUbf/mGHjsjioQQBLxciWT2JYHPBlYKwsVedcoY9Ws8+25ObJE8dTDH+ii+382q8oszHDRCVKdrOKuKWJwnh8TwhtwDB2aLFPQb5uoA/v6EmLhmT7ZhN1eMAllx8TNugTJKocse0/QYd6F4qs7P5FtrLUGNohjN4U1
 utaVevGo
 enrC08bhSq8wJeYbd4+RfWJOjpY0uQRZEcsVi43YJx/zsIoGeVe8+u7ZRqZkRDRUQeQRdX/bEeSP2uQXz5H358JxKfHW7FWQkYlilYaou+fKKZneQGWTTMB/zaEGP1G+1Jjyt1i55vmFROP6UBaOkVYEQMIKrA1+xlrdvO+Jxzh4GxyuUqTL3dDVOVC7nyqlJDaGpKAW928OE7kLw5hUdmeaWUBt1+I9LFPpTOdEU9nzXZwtuuOKOEVa8qenc5O+RkoNb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 06:30:51PM +0800, Hao Li wrote:
> On Fri, Aug 14, 2026 at 12:12:44AM +0800, Pengpeng Hou wrote:
> > SLAB_STORE_USER replaces the allocation track when an object is reused.  A
> > later stale free can then replace the free track as well, leaving the
> > report without the completed lifetime that created the stale reference.

Can we explicitly mention "double free" to make it more straightforward?
It confused me twice already ;-)

> > Store one additional alloc/free pair.  Before recording a new allocation,
> > copy the current pair to the previous slots only when both records exist.

Hmm we should probably instead:

1. Copy TRACK_ALLOC to TRACK_PREV_ALLOC before updating TRACK_ALLOC
2. Copy TRACK_FREE to TRACK_PREV_FREE before updating TRACK_FREE

I feel thinking of one pair as one 'lifetime' adds quite some confusion
because TRACK_ALLOC/TRACK_FREE sometimes form a 'lifetime', but
sometimes span more than one lifetime.

> > Keep the current free track intact to preserve existing SLAB_STORE_USER
> > behavior during the reuse window.
> >
> > Print the previous pair when available.  These records are diagnostic
> > history and do not infer semantic ownership.
> > 
> > Assisted-by: Codex:gpt-5
> > Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> > ---
> >  mm/slub.c | 45 ++++++++++++++++++++++++++++++++++++---------
> >  1 file changed, 36 insertions(+), 9 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 0653def0fe36..355fbffb981f 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -1113,12 +1130,22 @@ static void print_track(const char *s, struct track *t, unsigned long pr_time)
> >  
> >  void print_tracking(struct kmem_cache *s, void *object)
> >  {
> > +	struct track *prev_alloc;
> >  	unsigned long pr_time = jiffies;
> > +
> >  	if (!(s->flags & SLAB_STORE_USER))
> >  		return;
> >  
> >  	print_track("Allocated", get_track(s, object, TRACK_ALLOC), pr_time);
> >  	print_track("Freed", get_track(s, object, TRACK_FREE), pr_time);
> 
> When object is in allocated state, under normal case, this "Freed" line
> duplicates with the "Freed" line under "Previous object lifetime:"

Good catch!

> Would it make sense to add a check here? something like:
> 
> if ("free track" isn't the same as "prev_free track")

Perhaps it's better to never make this condition true to avoid
confusion?

> 	print_track("Freed", get_track(s, object, TRACK_FREE), pr_time);

Pengpeng, do you plan to respin this?

-- 
Cheers,
Harry / Hyeonggon

