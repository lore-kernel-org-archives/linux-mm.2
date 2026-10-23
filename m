Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 085EA606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 23:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jB0OKTON
Received: by kanga.kvack.org (Postfix)
	id 2BDB86B0BEE; Fri, 23 Oct 2026 19:36:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26F486B0BF2; Fri, 23 Oct 2026 19:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1859A6B0C07; Fri, 23 Oct 2026 19:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBF6E6B0BEE
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:36:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4FD3BA711F
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:36:35 +0000 (UTC)
X-FDA: 85355502750.03.0B8C47C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6EB1080008
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:36:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jB0OKTON;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792798593;
	b=Ount2RVGl3aI+My82jZBPK5/AKHI7OPBkRVkUiJ0aeB+bHWuVaj9VpyQVXGX1ag+bxpoj6
	3qZilqNw6isSzDrFs08SCZrnmSqs8HCXtprKqAOtsq80BM3nlcexi3Q1KgVPbIO3gi4VU7
	3UtdbWlzBB1GqbFb5QyQ60SF6NFeSYc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jB0OKTON;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792798593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I/Zuzgcss+svgkUIXyl3XnDM+vG1fLBLQV3+87i8Mnc=;
	b=03cZuAYsisGOr/9It/VumDTjpv8Kr4sVb/cx/G2qFn6n99KX6PxR907SHZpORiL13W50GU
	QnK1SzmyT0AhiK/1I01kfpV0d1AhdGJ25FQ+r6rYD6eer+orS4Bn5ab4tezSlII4C0ctIw
	gQttxxpgeABxJOM482rsP2idFiaSmJA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 076FC6022A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F6A1F01828
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792798592;
	bh=I/Zuzgcss+svgkUIXyl3XnDM+vG1fLBLQV3+87i8Mnc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jB0OKTONgdkG2Ymv8c4ENoQThRe0kQWZFgQIhN34BmS9ejXoT4mjjy1AbVTtkVly2
	 RjdGXaVmWcoJlICJutOp3Hp6+OdfczGTyqBWcP2BfNHbFMXozfElaH7BVwGnJS7FxA
	 eligGEYQdmOJ+qGiMktTc2sRA7inLcaj8mrWSxDSn02Q8XdFrjAymF6titCUW53Ugb
	 68iifeN7Af6Q4D3TmmfHBUlKLbZLldOQve8fvcsBvinxCKjX01sQ0F3GSOsZt1AL6s
	 llREUtBf+g33TCGr/NEI3V/+RdxbF5AVNqgiLZOOHoJmbUooteJzpqSqoPLYVAdR/G
	 MJKVmShnQJ+yA==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c40f29667e6so216522366b.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 16:36:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxo+PVFmWQy1bBotsHomFWnhn0LSyS29inv+29vO4oA7Buy1tOp5SZa/u8Ub7eAnnC58N4OeHuB+Q==@kvack.org
X-Gm-Message-State: AFq9FYKhNnoSLQozkez+PvfqsA7pce5kd9YaYHXESm3I8hDlNWueMcVZ
	okcvmdO7PpHniskl6sufXRun72fX/6u+P74sHLz56MGS04D0TxOMM7uPKlZEIYyuP84Ryprkf9Z
	5EwALJKiwkDdm1W1QMQFIEFNoS/yNOec=
X-Received: by 2002:a17:907:9715:b0:c33:ae8b:817d with SMTP id
 a640c23a62f3a-c46bde4b904mr47591566b.46.1792798591415; Fri, 23 Oct 2026
 16:36:31 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022232734.496064-1-suseendranb@google.com>
 <20261023102607.7635885be12b0b6e7a5971aa@linux-foundation.org>
 <20261023200426.3865221-1-suseendranb@google.com> <20261023162100.41145a57fb91ed1073c24c41@linux-foundation.org>
In-Reply-To: <20261023162100.41145a57fb91ed1073c24c41@linux-foundation.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 23 Oct 2026 16:36:19 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNBX6Oac4nJryEv1U-57JjgzAS+Bbfe=FGV4fH=sZ7PBQ@mail.gmail.com>
X-Gm-Features: AclHuK_H5zlrHTD2kZ5uuZ3nnaWevuLYmwlKdeVczL5o5zYQlHUT2FAtC6qHqWg
Message-ID: <CAO9r8zNBX6Oac4nJryEv1U-57JjgzAS+Bbfe=FGV4fH=sZ7PBQ@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: validate dlen and normalize comp_ret on
 compression success
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suseendran Bhaskaran <suseendranb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: t8nmp3ea1bpmcpxm6hbhtxq98caxnr64
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6EB1080008
X-Rspam-User: 
X-HE-Tag: 1792798593-870671
X-HE-Meta: U2FsdGVkX18grHtTfuD+WBeKeVmgXwg++d6PshllDgzLHRTeGzgDp8oa2DtOTsWwD9xtrSSufJPb8cexBxCd0EEI9oPN645xJGOWikqntC2IELAyW9c57oXkzoruHFNQHWJv1/vav7kv/wouBnNGxb7ePFzYaem6KVnQHLye+/JrIuv3R/yyl102hDm+NpEjHveoOVtOk5Wk+YydwmY7ORBqCstJYsyiRz9nUPWDt5IRocaRt6XfK9lnzR8K6VRMl9AXHHW/K83UZhiZeL1HoQFZ1I1wBdi4p9CAXmHFiO08h04Ebx+I/nSifU5wSrpInJ8vQ5RMxrKsA87k6SmVUOCK8EiG1dX7pMnnyU2ZiCYRNe3P1L3PPe6qAaxnnVqH1pnN+nKsxa4F7L3arQxFcTS02ghlWqYDrqLIL3QtDlIU2wSvdYErvSHBMQuRnDh7W5/7uLsHIwdVUY2vlEqS/HeO4yZuHiUTqTaOMM1HSmJW3RQsTDIcQb+iiARHmHhIJlLtTRNvdZZ7DxFnjmeWiS/1oFGXWezc8K6JBp5m/1lZWLWRQoRGlBvH3/cDZNFr6qkgp/ULUcHXyS5DQrOWy7NYZmHJaaZ6UvKGh4VxBPvNDva1fUB9/TUr3rpLV3k0zBSYDwXdP/k/RLHI3glnPRm/Q1za7Jd2FjRQBubfpkQ2YCL34I1zzODEeA3qJx7hO2dvA3jXb2JMKhUW9udBQtWPrVL4znx211u6uOm3aJ1V+PMec7T+bW0mFybPXlYnwkPsHDcNPxNGg7aW1m36AIsQQ2h05Duy4XWX69F4KAyXWlOkRcVCDhjnHBx6Iz+XCSzRIzA9a+ziuTRnYn+8xkRUYGExrRkHPEBK4v0EURtm76Z8j4MqKxa6drrhb4jx5ft5TfqDe9Hd+JLQmxIoCgvqNHKAB5MZ6d4BL6ZfUk9+3EuRbJQVdklR2roEuh/lPXDbJgWXIFi1ZVRcxuG
 vAHUvh6e
 WXatPuMFDDHLmz/NOkdZd0+ew51nFEmfl9YJd75UIhhMc3RBrXnVnNCWXjZTUtmFbIvVSaReeC8GN6e/4F7jqPv11QVVc+lLLLDfndsYW9JDWUQmUyui9HUBFeP3gKgE5VMFbYcwYW21MTUcC0dPCkx5Yqm5JGPgZ1M610cGyXkJgyXuy16MdLWkQJfvhz+6/aUWalX+3A5WDjZp2/TkjlUr2LT3t2xYCnPRXArko/IJtsaIT8YjlnJpRQPCcCdUg0XKJnwDl0pM8cO+eYYtkn8MyKO+0oNuTCnKWf+r3KankvWOzONa04yw0Hb35xaERRn9Qg8Q1OjYegwLXugsRnmCYdYpazmk/DfGRPxLW8D2HzVYZblPLtSbUKVk7Hr1AXlvSL2XtP0e3H2WOOwhsZjx+tDUwBHveW8mc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 4:21=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 23 Oct 2026 20:04:26 +0000 Suseendran Bhaskaran <suseendranb@goog=
le.com> wrote:
>
> > > Wht you forgot to tell us (please never forget this) is the
> > > userspace-visible runtime effects of the bug.  Autobot says:
> > >
> > > : The userspace-visible effects are limited to corrected zswap
> > > : statistics and a new warning for invalid compressor results.
> > > :
> > > : When compression succeeds but produces exactly PAGE_SIZE bytes, and
> > > : zswap writeback is disabled, the page is rejected as before. Howeve=
r,
> > > : reject_compress_poor now increments instead of reject_compress_fail=
.
> > > : This makes the debugfs statistics distinguish incompressible pages
> > > : from actual compressor failures more accurately.
> > > :
> > > : A compressor which reports success with a zero or oversized output
> > > : length will now trigger WARN_ON_ONCE(). Previously, zswap handled
> > > : these results without a warning. On systems with panic_on_warn
> > > : enabled, this could cause a kernel panic.
> > > :
> > > : There is no intended change to which pages zswap accepts, rejects
> > > : or stores uncompressed, nor to normal application behavior.
> > > :
> > > : I think these runtime effects should be described more prominently
> > > : in the changelog, particularly the new warning.
> >
> > Apologies for missing the userspace-visible runtime impact in the commi=
t
> > description. I will make sure to always include this going forward.
> > Autobot is spot-on here. I would be happy to send a v2 with an updated
> > commit message that clearly documents these runtime effects and
> > behavioral changes.
>
> I'm mainly interested in answering "should we backport this into
> -stable kernels?".  A small debugfs accounting error is probably a
> "no", but a WARN is "yes".  Is that real?  Can current kernels truly
> emit WARNs due to this issue?

No need for a stable backport, it's just debugfs accounting, and the
new WARN is just hardening.

>
> If so then yup, please send along a new changelog.  Or a v2 with a new
> changelog.

