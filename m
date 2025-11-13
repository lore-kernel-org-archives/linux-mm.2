Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE032CD8CAC
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 17:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29D6B8E0006; Thu, 13 Nov 2025 12:01:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 273FF8E0002; Thu, 13 Nov 2025 12:01:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B1F48E0006; Thu, 13 Nov 2025 12:01:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 09BA18E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:01:39 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9F263BC181
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:01:38 +0000 (UTC)
X-FDA: 84106200276.29.5CD94FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8955840017
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:01:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tNRxMltb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763053296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zijvUdHpGUrAfCyQkiJ/bibQPVenmUxWgnRbnC1L2kU=;
	b=sLPwHkZo14vSx5JYS/N+uvZStw4yQYfeBpGw29Pho8alkOkUk6EHjdqud4r0Op5QAIY/w3
	t/OwyMptw6SrNokrE71Nua4qaXuxph0yFKmU+XSBJJAXnHNr3MVlW85F1qiwY1qi1cvznP
	qY3fc0u3kDbWojqlJcmF3/J3m/i3hrQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763053296; a=rsa-sha256;
	cv=none;
	b=s/nCmVx6tw4rUrj1xMlUOeyM3IBfe7NX642utEO0gEMZG5K4y0IiTksmJGHKwtsqE+YvJw
	HnfZFupJdzH9BfzEq/w0ok+2gdl7q6EVuCJqDy9Xm5RFl4gnOwkHA/y+jfpn+IlQvJ3cO9
	sys2Zjv5BsVWd0qtzsS8bZfyVoGR6SE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tNRxMltb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EE30C601E8;
	Thu, 13 Nov 2025 17:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9109DC4CEF5;
	Thu, 13 Nov 2025 17:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763053294;
	bh=kbuxuJEVO1FB2vnyklMpjD3cLjwG6jTifNxLUVieshA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tNRxMltbBpxB7lr3rdpcqilWvsuzdDXcu7T6gDw4K4gzRZQyHczebCtGk5tkV2Ofj
	 NMJI1PTOh/04MS7ZefyMRtCcRS4Go2l9kRBKHEWz0OPo1p4w7gWZTMYMusZGT8SAam
	 n8NsZscBIcTtSSonzY+OVi+HmJiTpaBGrgXWE5ayseutTYmw3yRXmdPTPq/sBeH/J7
	 VTJOw7879ahoRHSaUZW1XgakFW/H5E5z+A1AJI4q33nAI7I1gHAdFC92pUJjVa2olP
	 I86XX+sO1ydhjdtb0SGSkeupLsTNWeR1EeQpkVzkL5pfKJDc/b4goGpCeT4bQzjNwe
	 YLq/w8zT9YUFA==
Date: Thu, 13 Nov 2025 09:01:34 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Tytus Rogalewski <tytanick@gmail.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH V1] mm/slub: fix memory leak in free_to_pcs_bulk()
Message-ID: <20251113170134.GD196370@frogsfrogsfrogs>
References: <20251111125331.12246-1-harry.yoo@oracle.com>
 <20251112184645.GP196391@frogsfrogsfrogs>
 <aRUpqFS8pU0qGIsb@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRUpqFS8pU0qGIsb@hyeyoo>
X-Stat-Signature: t3rqxsr4kjc7xo3d497fcstfzmfijaz5
X-Rspam-User: 
X-Rspamd-Queue-Id: 8955840017
X-Rspamd-Server: rspam10
X-HE-Tag: 1763053295-812550
X-HE-Meta: U2FsdGVkX1+1fL8VToV3tLk+dSJvD2dVgYE4FxJyTLOXn1JJJJjwBzWehT5CDQgS+vbKMM8SLd6auMbtVP3jTR6+uVQ+SBQ4C94pIjV7xmey10qgWyj8KQi98KMbhQ2BED/IKjHOB/K+c7a6FmwJDkxxjh8FByOi26LLP9Zc4whkftGszRkp9b+1riAdRr98cZkg/gv1AiqDSRwjZNb2df5XIdgWhcZj17bSzQc4NU9WUgJ9nVYpQz1zUeYv/fCQgwLbpZHWeupIu1bmE9Y5wWQt4yVRaMpxkdgftfnkm0dsNLjbEVCXlYjHzVd1Orz3MlJcqCPb+MGLII7Afq909HW0E8lPiv17jWCN0PzIV8cMeAYOmLgnn4P8Ps7OpDJe4BWdjiYldql/+bZ1k7fQn6cEXvzxY89GIl0zQwDo2jaf+edbfuoADUNF/rADDiI+/OMrU5wDPuPumN/T2Wdw/nkQ2QZw1BQA3JWpxb2maD/d95etr3yDoX2LRl9YrBwYFXEFtpVqQuJYDLtvR6xYa6vJTSYTX9yoEpXWUwcoaffMg49TtutCG8qomSQ4a/Orf8qKiXWXKRMjuqiVGOPEkSUAq+RLemSL5n/AnDjJMvOHdwranVCXgLllwHRGriOHGOZ7CmXZucRKiQGYOXTMvO/hucHeDN0QYsm9gnBJs/DxvIbams0HbJmueyN8iDuspLNe9oSNJExT7pWrpAJF3mmUwB0/9K5hHRV/39Ow9Xe3nX3TPDJvU+blc1A/TnfKHv9diaSmuVPSOMuqbSlAykzFvHKbAXqZ2fcOFUeEc6LUpkc8WcHP7DYaxtejrCqBQUn545rF5YTwWaHiGUds5oZ6j75yDmgqsTr/aRXJKh2Szj1QsjAsIYf78JOIHTP7WujvLhBLfZ+euCOpZMnUHuoHCUH08ZYmGRz9AEE0fGjUj4WepskN6jL6x5ZYT5kOYGecmefalv9KqcnVF+U
 txMkC/0K
 vScaWrSvRBLDkWd2EKrx7AFaSRd9IR5M+WHx9A4iHbBXynLFLFZgdLmXwrV4o+1V08h+lNLLowgaR82j+gP0y9nusLi4oL5l3pC5SxV6IXLlpL4klWgzm5fCYzRQZlbkZydJBmSt+4wkUmh73Nw3oVtdpZS++69wPNsnhT0QHagSv4YbMJYBlV1LJbM+h8I6I0iHhxwLmiTrU/u4h8TITcmJGaYavpqFBfKjSzmXffJy+KTFV5M6E1e/F4X90y/Jl3HRjjckik/VtMsPphLnXJ5vLHI5Lku7IGd36GFR4K73zrrfLAuKZpdawXbJopEgyESry
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 09:43:20AM +0900, Harry Yoo wrote:
> On Wed, Nov 12, 2025 at 10:46:45AM -0800, Darrick J. Wong wrote:
> > On Tue, Nov 11, 2025 at 09:53:31PM +0900, Harry Yoo wrote:
> > > The commit 989b09b73978 ("slab: skip percpu sheaves for remote object
> > > freeing") introduced the remote_objects array in free_to_pcs_bulk() to
> > > skip sheaves when objects from a remote node are freed.
> > > 
> > > However, the array is flushed only when:
> > >   1) the array becomes full (++remote_nr >= PCS_BATCH_MAX), or
> > >   2) slab_free_hook() returns false and size becomes zero.
> > > 
> > > When neither of the conditions is met, objects in the array are leaked.
> > > This resulted in a memory leak [1], where 82 GiB of memory was allocated
> > > for the maple_node cache.
> > > 
> > > Flush the array after successfully freeing objects to sheaves
> > > in the do_free: path.
> > > 
> > > In the meantime, move the snippet if (!size) goto flush_remote; outside
> > > the while loop for readability. Let's say all objects in the array are
> > > from a remote node: then we acquire s->cpu_sheaves->lock and try to free
> > > an object even when size is zero. This doesn't appear to be harmful,
> > > but isn't really readable.
> > 
> > I'll put this on my test fleet this evening.  Thank you for the quick
> > fix! :)
> 
> Thanks for testing, Darrick!

Nothing OOMed overnight, so I think this patch is ok.

Tested-by: "Darrick J. Wong" <djwong@kernel.org>

--D


> -- 
> Cheers,
> Harry / Hyeonggon

