Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 854C7107637E
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFCC36B0005; Wed,  1 Apr 2026 10:14:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAE256B0088; Wed,  1 Apr 2026 10:14:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D75916B008A; Wed,  1 Apr 2026 10:14:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C635F6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:14:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D029BB627
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:14:15 +0000 (UTC)
X-FDA: 84610181670.23.C510122
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2F22E80014
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:14:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jvfq07ZR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=71Mm1Bwf;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jvfq07ZR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=71Mm1Bwf;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775052853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+sYCJoO8GdgGI8H0Pq4RGX002BhgSxrAJc/rOLh/sY=;
	b=ZOOyi1/NQmV6SkzVzzyFr9pyraGkSB07WhAsWXCY3mgmtaBNjbreIVQ0xk8wu7cKssJhCA
	ZbmEgkMR73QVk6mPNu3fc4cmpcm4XgaeXAZwJDTydqlbZiyKmWvsVVERK8om7+EikrWapu
	VeFVBYi8VxXGWrnBwKFPP2zsgrqOMF8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jvfq07ZR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=71Mm1Bwf;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jvfq07ZR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=71Mm1Bwf;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775052853; a=rsa-sha256;
	cv=none;
	b=g8FY3oY+twTy1F5RH7Y+mKHCkWDfMR1SZySixckaNh13frDm2D1BN6El7u76yqa8yTP66P
	odNOlrYkQw7Ke+2I1mgeMfxPU8iYnxUZJSniEB+UzmfgHM5cQCwsh7B5vtBmGUHvODwsJN
	yfZEgDtc5XjmELZ6UCeyOMtH81Baixo=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7277C4D31C;
	Wed,  1 Apr 2026 14:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775052851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f+sYCJoO8GdgGI8H0Pq4RGX002BhgSxrAJc/rOLh/sY=;
	b=jvfq07ZR1Z+6Tgt9EYOyUREMltCqwfDIfZ/vmPzfZUCASLFDXkJO9iCjB4qaxp6YtW6MKb
	bkwUauXWVqk3NvXlGbA1EJjyXi5yec6CVxDnj5unvsy1if0m1NfcayAzlnXMUUZl8SlXHI
	S62y6vbuQ9xf7FQispLfj7QGjgInQ1w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775052851;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f+sYCJoO8GdgGI8H0Pq4RGX002BhgSxrAJc/rOLh/sY=;
	b=71Mm1Bwfrkh8s6uX3FdIQJzieOdn4f5xC7kfzfVg/MSsspqBs+ADjhFgqs71fu03U4vRn8
	n0WRaeBQuBDaUVAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775052851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f+sYCJoO8GdgGI8H0Pq4RGX002BhgSxrAJc/rOLh/sY=;
	b=jvfq07ZR1Z+6Tgt9EYOyUREMltCqwfDIfZ/vmPzfZUCASLFDXkJO9iCjB4qaxp6YtW6MKb
	bkwUauXWVqk3NvXlGbA1EJjyXi5yec6CVxDnj5unvsy1if0m1NfcayAzlnXMUUZl8SlXHI
	S62y6vbuQ9xf7FQispLfj7QGjgInQ1w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775052851;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f+sYCJoO8GdgGI8H0Pq4RGX002BhgSxrAJc/rOLh/sY=;
	b=71Mm1Bwfrkh8s6uX3FdIQJzieOdn4f5xC7kfzfVg/MSsspqBs+ADjhFgqs71fu03U4vRn8
	n0WRaeBQuBDaUVAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A0F664A0B0;
	Wed,  1 Apr 2026 14:14:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LyX7IzIozWlRdQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 01 Apr 2026 14:14:10 +0000
Date: Wed, 1 Apr 2026 15:14:08 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Luke Yang <luyang@redhat.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Dev Jain <dev.jain@arm.com>, jhladky@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Nico Pache <npache@redhat.com>
Subject: Re: [PATCH v2 0/2] mm/mprotect: micro-optimization work
Message-ID: <wnfqwxdtepdpf4eq2ckrhasupated2itv3ai6zpll36seefm25@dr6m5n254ztc>
References: <20260324154342.156640-1-pfalcato@suse.de>
 <CAL2CeBxT4jtJ+LxYb6=BNxNMGinpgD_HYH5gGxOP-45Q2OncqQ@mail.gmail.com>
 <20260330130635.1d8bf3f1f9dfcafc0317f5e7@linux-foundation.org>
 <bb40b9b5-d71e-4968-8c14-86af46e33fee@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb40b9b5-d71e-4968-8c14-86af46e33fee@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 2F22E80014
X-Stat-Signature: zwybehrjc93x5611t6rgarqxtxst8mch
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775052852-520570
X-HE-Meta: U2FsdGVkX1+unkLDyjrm5F78yft/5nQ7TUhFfN0+cggC60aaLilGreTyIJ8f9hkyFS9Gi4XHkhMS1DmIJ+GHOlY2AXGMm41N7uBLLVxPW+3vh9w1fHoFFtv8VqiOOMTCpgKv6MFwMLMmOoNt+mi02LhHi0kbRpUlUvQoIehzVNPuz+9ddlQPxr/6qBOMHH1layK2LDJ8vxPodCc1l3x8XgBwmCXa0rVE9A80CI0yJm1TV/5/K3u2C9wNPeAIeo4BzV1nRrj3VQT5dutrwsgt5BL0F1FBcgOc/yp5dz+njajGrI4rJxQh8av+vPY4BylCXjCmzJFBZt4+OpUYqUJ/gmc/rUvN73v4lzGzfy5V/AFkVRq7B+MDDh25zn/RID5jWS52Hq90rKPkZAwLfa8FwsyRQz+ErNpHSUYAD+bUGKZ2E3STTUDs1ZODdKwgxSgg3l8aX6BXjcx278MxmNzXpprt+wHVWZVtTXfsHc7ZbS1BRCd7+Dq/vepLrpsBZPwn73zFspgFm69RdYVkigniMLanORnY6orj1HJ/zBWuWmJ0VtWoGgNhulSNOfh0q8egeTjhXiUDL01f6IXEPElN8B9NiVXEHoXkd59q//t52u2PlTgUummYmB7fLTNUnpnkzyiEiNmdi3WJy6yAFLxvAuaq1+f54lhuYjuj8YsknpzfD/UssGGWufvvwhrmp4t+7i8+Gy0wgVBYv8jidBL1l48y/zY9SoPt6anJ6iY1yCHgqy4gsLAGJpIpBl8W7jvAvkceGE/+AhlaHk1H3vPwOm95JDJ36/sbozrwo3WwTxc4t5u9WyD/jt4kMYJ2K20qckeXqe0zkUCTdPDkFPx5Ywr9EDIPmbxDT1U0VWzyJrulpkBSLj5dE3ha++GXRpfqsdsKyc7EkYVp/sOia7wgx7cq7JhipGK5N0EcBGBjV5FLZs7eFSJ7vvTpff7XiQ8asUCPRg6Fw7JjdHXDrEy
 Naj6ygfT
 wpr9URk0o9NAx63P/s2OV06csc/ZjLufSOiVS5EYr3QPicHa13voLURvojociPCNDdkCxUKZMNBpDAYEwnyCVrapEd4wiq4loLNG2vnaZveQDOz2Gr3q0JxdIEnWL5Kjwi09Ry1qmlNHfX4wf2d59+YIHm9rhWcqEZSzcoZxDAGbdraUflXHaUXHeB0d1Iirru5nAdVG6r0VQxPna6Q+7D83VXud4LSuZvzpNO9DYkSRhv+XzkG34bvoVpHL3LTBgBcJssAWj0qvHJDBCa1Mk8VImHhC3sI1iLylWCGsXTZjvWi1wlaTPAsF8dHAbjzX7Q7Swihs8NBv8/kL7eh2xZ2crJL3k0SZvaEh/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 10:25:40AM +0200, David Hildenbrand (Arm) wrote:
> On 3/30/26 22:06, Andrew Morton wrote:
> > On Mon, 30 Mar 2026 15:55:51 -0400 Luke Yang <luyang@redhat.com> wrote:
> > 
> >> Thanks for working on this. I just wanted to share that we've created a
> >> test kernel with your patches and tested on the following CPUs:
> >>
> >> --- aarch64 ---
> >> Ampere Altra
> >> Ampere Altra Max
> >>
> >> --- x86_64 ---
> >> AMD EPYC 7713
> >> AMD EPYC 7351
> >> AMD EPYC 7542
> >> AMD EPYC 7573X
> >> AMD EPYC 7702
> >> AMD EPYC 9754
> >> Intel Xeon Gold 6126
> >> Into Xeon Gold 6330
> >> Intel Xeon Gold 6530
> >> Intel Xeon Platinum 8351N
> >> Intel Core i7-6820HQ
> >>
> >> --- ppc64le ---
> >> IBM Power 10
> >>
> >> On average, we see improvements ranging from a minimum of 5% to a
> >> maximum of 55%, with most improvements showing around a 25% speed up in
> >> the libmicro/mprot_tw4m micro benchmark.
> > 
> > Thanks, that's nice.  I've added some of the above into the changelog
> > and I took the liberty of adding your Tested-by: to both patches.
> > 
> > fyi, regarding [2/2]: it's unclear to me whether the discussion with
> > David will result in any alterations.  If there's something I need to
> > it always helps to lmk ;)
> 
> I think we want to get a better understanding of which exact __always_inline
> is really helpful in patch #2, and where to apply the nr_ptes==1 forced
> optimization.
> 
> I updated my microbenchmark I use for fork+unmap etc to measure
> mprotect as well
> 
> 	https://gitlab.com/davidhildenbrand/scratchspace/-/raw/main/pte-mapped-folio-benchmarks.c?ref_type=heads
> 
> Running some simple tests with order-0 on 1 GiB of memory:
> 
> 
> Upstream Linus:
> 
> ./pte-mapped-folio-benchmarks 0 write-protect 5
> 0.005779
> ...
> ./pte-mapped-folio-benchmarks 0 write-unprotect 5
> 0.009113
> ...
> 
> 
> With Pedro's patch #2:
> $ ./pte-mapped-folio-benchmarks 0 write-protect 5
> 0.003941
> ...
> $ ./pte-mapped-folio-benchmarks 0 write-unprotect 5
> 0.006163
> ...
> 
> 
> With the patch below:
> 
> $ ./pte-mapped-folio-benchmarks 0 write-protect 5
> 0.003364
> 
> $ ./pte-mapped-folio-benchmarks 0 write-unprotect 5
> 0.005729

Hmm. Thanks for the testing. Interesting. I'll give it a shot. I'll have
results and/or a possible v3 by tomorrow, if need be.

Apologies for the slight delay here! :)

-- 
Pedro

