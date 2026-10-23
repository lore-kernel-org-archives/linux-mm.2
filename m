Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D694606A338
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 17:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cSS0Ck+N
Received: by kanga.kvack.org (Postfix)
	id 4D51B6B0BC3; Fri, 23 Oct 2026 13:56:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AD526B0BC4; Fri, 23 Oct 2026 13:56:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39D316B0BC5; Fri, 23 Oct 2026 13:56:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E98A6B0BC3
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:56:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8636714018E
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:56:54 +0000 (UTC)
X-FDA: 85354646748.15.0CEF702
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id DC71680002
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:56:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cSS0Ck+N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792778212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6dF6ilgg1hCkDWkXW/uBaYSBlAJ46T4Q2XsH6HK8HOg=;
	b=ovoXWu4tLMpcgQeDibM1pW9r5TGeXaeTEsdOjn9wtxnbLiQGt2wqCBFKpM/gpPB+l/R8eb
	gHdBNl/rcRMMl0MA8fBmrXVlFBV5olLOfsLK5FwiscWIm8D/82SRlnZWxMJvlswX+VJqug
	xzrgv2e4doPCofmVpUsVPY2ujYd7KGc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cSS0Ck+N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792778212;
	b=GVIoMN3bAzM3udeVexhzLYnboQN1mocdax92Bwj0fWxPPEYo6bfBUV78OT8ueVKCJnmiwa
	Yk42eg9YrSUplozIYyimDir/OHGs8EJH8TbaMoomB0YluPsYZwttMU8KmkZjRN+X7JLDUZ
	fyIKfcvINtnq9gXrqueMak2boAUIjOw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DE34E43829;
	Fri, 23 Oct 2026 17:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC88E1F01825;
	Fri, 23 Oct 2026 17:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792778211;
	bh=6dF6ilgg1hCkDWkXW/uBaYSBlAJ46T4Q2XsH6HK8HOg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=cSS0Ck+NSrHUjM87ec4oK+tVdxn6iGBvpBVeHnRpI22pz+cl9kv1k0ewBZ6D1dP+H
	 bVCrhcxC+JX6TIeI103IOMyfzAmdk506bzOeqKt/MOMquKKvT1H3qIU73fAK3GAQD3
	 UQlqk7gxESl8jGzFOcBtz2W413JkJo6jZRh/xmnMPIYxFkrcqf1glg89nY6LY2l/0X
	 aJ/9uKUiEryCHOLmtUz1ro8l08+ntqMmWItaBiiLJxqhRJGDs9MBDrmv54p8TOFGhD
	 QyQb0Jsgts77moGbNmbU+g5dVigMmtm4cqWEQPd5/mN5PVJ1CnseuSeozwbX/TfRV1
	 lwu628+jAAQiw==
Date: Fri, 23 Oct 2026 10:56:50 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin
 <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Muchun Song
 <muchun.song@linux.dev>, Hao Ge <hao.ge@linux.dev>, Pedro Falcato
 <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, Jason Xing <kerneljasonxing@gmail.com>, Willem de
 Bruijn <willemb@google.com>, Mina Almasry <almasrymina@google.com>,
 =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, Sebastian Andrzej
 Siewior <bigeasy@linutronix.de>, Jiayuan Chen <jiayuan.chen@linux.dev>,
 netdev@vger.kernel.org
Subject: Re: [PATCH slab/for-next 05/14] net: skbuff: specify
 SLAB_MAY_ACCOUNT for skbuff_head_cache
Message-ID: <20261023105650.393c8fc8@kernel.org>
In-Reply-To: <atoHqLrf70QSkn8F@thinkstation>
References: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
	<20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-5-096800aa3330@kernel.org>
	<20261021121941.4d8f8edf@kernel.org>
	<atoHqLrf70QSkn8F@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DC71680002
X-Stat-Signature: y7f5c4bz4aiodtmpjkrkbwh61rusjmfx
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792778212-802188
X-HE-Meta: U2FsdGVkX19OJG0nCveR8veT2mIWWWsHLsyvzSARuPOGp9y5yIulJb3hCZ+6LWgKK3q5xxbkYfVCXZNNmELgfaTCXL6yOA2mJ8pewk1LCpRWJAbdwHTLqD8gY9epPNDX+6nKyQkejBOLWrCamRhq0RBajfCZBkr5sziyz5kNLQHDByHHju7TOhS3dUdUZGEA6TSK231ta4a5+mcRAvxTIhaGB6Z+IG+rwgktWoCy7yEjZ5/bcgUh5X8qDk/7UvKEgi6wrFTjTVR5N/9YY6017knRfT7cAu0Z5EekzCEcFU+EMstHnlGlDbrINjGFMg86rnieNmP62DkfaYuP0l3zTeJbQheeY64cUJNqzvqto3Gue6d0Zr53mXKLk/NaP7uaV/A64pmqKNquCgeRK6N1vQqJPXN5DItyL5UIJpeDXkq5x8FOlr4GCXaQMx5uFKxcfaDiF7ZSz6vpeT9/uxCzngpwJInqYyisfy7LQF7c4EOXHwql+0+5PsrFHnfV24UyhhSQxYmCTLyICAWRv/4bYRl34J5svw2CTzBb/Q9IqrcIHYakTxVFpLHMwB/V0QKlmfYcuDZtrQuo+iMYY77uwQ+NZm3zxXZjYF6IcCgF/eg6lhDii4fCGjcMM27G9L4zseykZu7jNOlEs8v55agREXhMiK0OfCT9HCDpRh4/XRYtGyk7YQddxNCuDQyYwuabyPQLlJf5Kx1GfIpfRupJTEqInCIs/C3lRAdHDuLbLWOhX9lJfmp0IRohw5KG2jTlvmRdJJDiKsqpq0O6wGI7uBGMvOiaHiILLm3Qq6MaUBRq/9N88LOKurK1DVaqdonMng/eJER7Ae0BePO8VgKdw8L0wJS92FmChvF+cR3Sv051qfELhI6aZdVrZHMWYM09kezJjzcJ5DLyKD+vuplBtLR8BFNMfpb/SVAjJOm6qzkvGLcE5weAFwBhp2znp8ii229gM9I79iye5hXO+eH
 hK/8si+x
 B2lXHZQpNx+A3dahqSuTDJXkSlJQeGMS/18l3p91oazaMEr3VTenieznlEqkT7sWTldT3xTkbEFxmUTxp3xR6FjaZwGAec1fvyLUGHd6JiyOKn73gKbdCMRrHRbtrsP/uwQQ7OeB5SNmAMmqWAZ4+PTaktd+JLS/9ZiU7pMVTPsl1/fQA/mKDi5rs5qXSCmKaFFJNoNlGfdtd/+kYu89AZ91rVMxb6njdQQBkquDBlEhDpzjl4qf9PiL2AOgKzkpcKRTZrY5V+VqGfj8E0asXJNkl3cq0yk8YY0NM83UzXPsRlFEKXR40i+LhnwwQNG9upw6eR0TKmCQMnJ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 22 Oct 2026 14:43:42 +0100 Harry Yoo wrote:
> On Wed, Oct 21, 2026 at 12:19:41PM -0700, Jakub Kicinski wrote:
> > On Wed, 21 Oct 2026 12:46:46 +0100 Harry Yoo (Meta) wrote:  
> > > AF_UNIX sets sk->sk_allocation to GFP_KERNEL_ACCOUNT, so skbs can be
> > > allocated from skbuff_head_cache with __GFP_ACCOUNT. Specify
> > > SLAB_MAY_ACCOUNT when the object may be charged to a memcg.
> > > __GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.  
> > 
> > Could you please skip this for the first batch and resend
> > later to net-next?  
> 
> Apologies. Wasn't keen to the net-next development process.
> 
> I can resubmit later, but hmm, actually, do you mind if we let it go
> through slab/for-next with Acked-by: from networking folks?
> 
> It's only few lines of change and it'll create a lot of dependency for
> pull requests if each patch goes through each subsystem's tree...

Think I misread the cover letter.

Acked-by: Jakub Kicinski <kuba@kernel.org>

